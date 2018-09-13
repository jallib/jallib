/************************************************************
 **
 ** picbsrop.c : PIC data optimization definitions
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <assert.h>
#include "../libcore/pf_proc.h"
#include "pic_msg.h"
#include "piccolst.h"
#include "pic_gop.h"
#include "picbsrop.h"

typedef struct pic_code_bsr_data_ {
  uchar    bsr[PIC_CODE_GOP_DEPTH];
  unsigned ix;
} pic_code_bsr_data_t;

/*
 * NAME
 *   pic_code_bsr_analyze
 *
 * DESCRIPTION
 *   analyze the bsr in the pic_codes[] array
 *
 * PARAMETERS
 *   pf    : 
 *   pcl   : pcl on entry
 *   bsr   : current contents of BSR
 *   depth : depth (for statistics only)
 *
 * RETURN
 *   none
 *
 * NOTES
 */
static pic_code_gop_rc_t pic_code_bsr_analyze(pfile_t *pf, pic_code_t code,
  pic_code_gop_which_t which, void *odata)
{
  pic_code_gop_rc_t    rc;
  pic_code_bsr_data_t *data;
  uchar                bsr;

  data = odata;
  if (PIC_CODE_NONE != code) {
    bsr = data->bsr[data->ix];
  } else {
    bsr = PIC_BSR_UNKNOWN;
  }

  rc = PIC_CODE_GOP_RC_CONTINUE;
  switch (which) {
    case PIC_CODE_GOP_WHICH_ENTER:
      data->ix++;
      assert(data->ix < PIC_CODE_GOP_DEPTH);
      if (data->ix > 0) {
        data->bsr[data->ix] = data->bsr[data->ix - 1];
      }
      break;
    case PIC_CODE_GOP_WHICH_EXIT:
      data->ix--;
      break;
    case PIC_CODE_GOP_WHICH_PRE:
      if ((pic_code_bsr_get(code) == bsr) 
        || (PIC_BSR_INDETERMINATE == pic_code_bsr_get(code))) {
        rc = PIC_CODE_GOP_RC_STOP;
      } else {
        if (PIC_BSR_UNKNOWN == pic_code_bsr_get(code)) {
          pic_code_bsr_set(code, bsr);
        } else if (bsr != pic_code_bsr_get(code)) {
          pic_code_bsr_set(code, PIC_BSR_INDETERMINATE);
        }
        switch (pic_code_op_get(code)) {
          case PIC_OPCODE_MOVLB:
            bsr = (uchar) value_const_get(pic_code_literal_get(code));
            break;
          default:
            break;
        }
      }
      break;
    case PIC_CODE_GOP_WHICH_POST:
      if (pic_code_is_suspend(pf, code)
        || (PIC_OPCODE_CALL == pic_code_op_get(code))) {
        bsr = PIC_BSR_INDETERMINATE;
      }
      break;
  }
  if (PIC_CODE_NONE != code) {
    data->bsr[data->ix] = bsr;
  }
  return rc;
}

static void pic_code_bsr_opt(pfile_t *pf,
    pic_code_gop_who_t who, void *odata)
{
  pic_code_bsr_data_t *data;

  UNUSED(pf);
  data = odata;
  switch (who) {
    case PIC_CODE_GOP_WHO_ISR:
    case PIC_CODE_GOP_WHO_INDIRECT:
      data->bsr[0] = PIC_BSR_INDETERMINATE;
      break;
    case PIC_CODE_GOP_WHO_USER:
      data->bsr[0] = 0;
      break;
  }
  data->ix = (unsigned) -1;
}

/* run through the pic_codes and remove any redundant dataset commands */
static void pic_code_bsr_post_analyze(pfile_t *pf)
{
  pic_code_t code;
  unsigned   ins_ct; /* instruction ct */
  unsigned   rem_ct;

  for (ins_ct = 0, rem_ct = 0, code = pic_code_list_head_get(pf);
       code;
       ins_ct++) {
    pic_code_t next;

    next = pic_code_next_get(code);
    if (!pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)) {
      boolean_t            cremove;

      switch (pic_code_op_get(code)) {
        case PIC_OPCODE_MOVLB:
          cremove = value_const_get(pic_code_literal_get(code))
              == pic_code_bsr_get(code);
          break;
        default:
          cremove = BOOLEAN_FALSE;
          break;
      }
      if (cremove) {
        pic_code_list_remove(pf, code);
        pic_code_free(code);
        rem_ct++;
      }
    }
    code = next;
  }
  pfile_log(pf, PFILE_LOG_DEBUG, "...removed %u of %u instructions", 
      rem_ct, ins_ct);
}

void pic_code_bsr_optimize(pfile_t *pf)
{
  pic_code_bsr_data_t data;

  pfile_log(pf, PFILE_LOG_DEBUG, PIC_MSG_FIXING_BSR);
  pic_code_gop_optimize(pf, pic_code_bsr_opt,
    pic_code_bsr_analyze, &data);
  pfile_log(pf, PFILE_LOG_DEBUG, "...post analyze");
  pic_code_bsr_post_analyze(pf);
}

