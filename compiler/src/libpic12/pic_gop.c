/************************************************************
 **
 ** pic_gop.c : PIC general optimization definitions
 **
 ** Copyright (c) 2010, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include "../libcore/pf_proc.h"
#include "pic_msg.h"
#include "piccolst.h"
#include "pic_gop.h"

static void pic_code_gop_analyze(
    pfile_t                   *pf, 
    pic_code_t                 code,
    pic_code_gop_analyze_cb_t  analyze_fn,
    void                      *data
    )
{
  boolean_t pv_code_is_cond;

  pv_code_is_cond = BOOLEAN_FALSE;
  analyze_fn(pf, PIC_CODE_NONE, PIC_CODE_GOP_WHICH_ENTER, data);
  do {
    boolean_t  code_is_cond;
    pic_code_t next;

    code_is_cond = BOOLEAN_FALSE;
    next = pic_code_next_get(code);

    switch (analyze_fn(pf, code, PIC_CODE_GOP_WHICH_PRE, data)) {
      case PIC_CODE_GOP_RC_STOP:
        next = PIC_CODE_NONE;
        break;
      case PIC_CODE_GOP_RC_CONTINUE:
        switch (pic_code_op_get(code)) {
          case PIC_OPCODE_RETURN:
          case PIC_OPCODE_RETFIE:
          case PIC_OPCODE_RETLW:
          case PIC_OPCODE_RESET:
            /* if this is unconditional we're done otherwise simply continue */
            if (!pv_code_is_cond) {
              next = 0;
            }
            break;
          case PIC_OPCODE_GOTO:
          case PIC_OPCODE_CALL:
            {
              pic_code_t brcode;

              brcode = pic_code_label_find(pf, pic_code_brdst_get(code));

              if ((PIC_OPCODE_GOTO == pic_code_op_get(code))
                  && !pv_code_is_cond
                  && !pic_code_is_suspend(pf, code)) {
                /* an absolute goto so next = brcode */
                next = brcode;
              } else {
                /* this is either a conditional goto or a call. either
                   way we first process then branch, then continue
                   processing from where we were. for the time being
                   a call is going to invalidate the known bits */
                pic_code_gop_analyze(pf, brcode, analyze_fn, data);
              }
            }
            break;
          case PIC_OPCODE_INCFSZ:
          case PIC_OPCODE_DECFSZ:
          case PIC_OPCODE_BTFSC:
          case PIC_OPCODE_BTFSS:
            code_is_cond = BOOLEAN_TRUE;
            break;
          default:
            break;
        }
        if (pic_code_modifies_pcl(pf, code)) {
          next = PIC_CODE_NONE;
        }
        switch (analyze_fn(pf, code, PIC_CODE_GOP_WHICH_POST, data)) {
          case PIC_CODE_GOP_RC_CONTINUE:
            break;
          case PIC_CODE_GOP_RC_STOP:
            next = PIC_CODE_NONE;
            break;
        }
        break;
    }
    pv_code_is_cond = code_is_cond;
    code = next;
  } while (code);
  analyze_fn(pf, PIC_CODE_NONE, PIC_CODE_GOP_WHICH_EXIT, data);
}

void pic_code_gop_optimize(
  pfile_t                   *pf,
  pic_code_gop_optimize_cb_t optimize_cb,
  pic_code_gop_analyze_cb_t  analyze_cb,
  void                      *data
  )
{
  label_t        lbl;
  pfile_proc_t  *proc;

  /* first -- analyze the ISR bits */
  lbl = pfile_label_find(pf, PFILE_LOG_NONE, PIC_LABEL_ISR);
  if (lbl) {
    pic_code_t code;

    code = pic_code_label_find(pf, lbl);
    if (code) {
      optimize_cb(pf, PIC_CODE_GOP_WHO_ISR, data);
      pfile_log(pf, PFILE_LOG_DEBUG, "...analyzing ISR");
      pic_code_gop_analyze(pf, code, analyze_cb, data);
    }
    label_release(lbl);
  }

  /* second -- analyze the USER bits */
  lbl = pfile_label_find(pf, PFILE_LOG_ERR, PIC_LABEL_RESET);
  if (lbl) {
    pic_code_t code;

    code = pic_code_label_find(pf, lbl);
    if (code) {
      pfile_log(pf, PFILE_LOG_DEBUG, "...analyzing USER");
      optimize_cb(pf, PIC_CODE_GOP_WHO_USER, data);
      pic_code_gop_analyze(pf, code, analyze_cb, data);
    }
    label_release(lbl);
  }
  /* find all procedures that are called indirectly as these might not have 
   * been picked up earlier
   */
  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INDIRECT)
        || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_TASK)) {
      lbl = pfile_proc_label_get(proc);
      if (lbl) {
        pic_code_t code;

        code = (pic_code_t) label_code_get(lbl);
        if (code) {
          optimize_cb(pf, PIC_CODE_GOP_WHO_INDIRECT, data);
          pic_code_gop_analyze(pf, code, analyze_cb, data);
        }
      }
    }
  }
  /* once the analysis is done, we need to run through & make
     sure no further label fixups are needed, or fix them up
     as necessary */
  pfile_log(pf, PFILE_LOG_DEBUG, "...post analyze");
}

