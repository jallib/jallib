/************************************************************
 **
 ** pic_stk.c : determine PIC stack usage definitions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include "../libcore/pf_proc.h"
#include "pic.h"
#include "pic_code.h"
#include "piccolst.h"
#include "pic_stk.h"

#define PIC_STACK_DEPTH_INFINITE 15

static unsigned pic_stack_depth_get_user(pfile_t *pf,
    pic_code_t code, value_t pcl, unsigned depth)
{
  unsigned   depth_max;
  boolean_t  is_cond;

  depth_max = depth;
  is_cond   = BOOLEAN_FALSE;

  if (depth_max >= 16) {
    return depth_max;
  }
  /*
   * logically, we could stop when depth_max reaches DEPTH_INFINITE, but I 
   * want each bit of code marked for the debug output.
   */
  while (code 
      /*&& (depth_max < 16)*/
      && ((-1U == pic_code_depth_get(code))
        || (pic_code_depth_get(code) < depth))) {
    pic_code_t   next;
    pic_opcode_t op;
    boolean_t    is_suspend;

    is_suspend = pic_code_is_suspend(pf, code);

    pic_code_depth_set(code, depth);
    next = pic_code_next_get(code);
    op = pic_code_op_get(code);
    if ((PIC_OPCODE_INCFSZ == op)
        || (PIC_OPCODE_DECFSZ == op)
        || (PIC_OPCODE_BTFSC == op)
        || (PIC_OPCODE_BTFSS == op)) {
      is_cond = BOOLEAN_TRUE;
    } else {
      if (!is_cond
        && ((PIC_OPDST_F == pic_code_dst_get(code)) 
          || (PIC_OPCODE_MOVWF == op))) {
        /* look for a destination of _pcl */
        if (value_is_same(pic_code_value_get(code), pcl)) {
          next = PIC_CODE_NONE;
        }
      } else if (!is_cond 
          && ((PIC_OPCODE_RETURN == op)
            || (PIC_OPCODE_RETLW == op) 
            || (PIC_OPCODE_RETFIE == op))) {
        /* done! */
        next = PIC_CODE_NONE;
      } else if ((PIC_OPCODE_GOTO == op) || (PIC_OPCODE_CALL == op)) {
        label_t    lbl;
        pic_code_t lbl_code;

        lbl      = pic_code_brdst_get(code);
        lbl_code = pic_code_label_find(pf, lbl);

        if ((PIC_OPCODE_CALL == op) || is_cond || is_suspend) {
          unsigned n;

          n = pic_stack_depth_get_user(pf, lbl_code, pcl,
              depth + ((PIC_OPCODE_CALL == op) ? 1 : 0));
          if (n > depth_max) {
            depth_max = n;
          }
        } else {
          next = lbl_code;
        }
      } 
      if (PIC_OPCODE_NONE != op) {
        is_cond = BOOLEAN_FALSE;
      }
    }
    code = next;
  }
  return depth_max;
}

unsigned pic_stack_depth_get(pfile_t *pf)
{
  unsigned      depth;
  label_t       lbl;
  value_t       pcl;
  pfile_proc_t *proc;

  pcl = pfile_value_find(pf, PFILE_LOG_ERR, "_pcl");

  lbl = pfile_user_entry_get(pf);
  if (lbl) {
    depth = pic_stack_depth_get_user(pf, pic_code_list_head_get(pf), pcl, 0);
    label_release(lbl);
  } else {
    depth = 0;
  }
  for (proc = pfile_proc_root_get(pf); 
       proc; 
       proc = pfile_proc_next(proc)) {
    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_TASK)) {
      pic_code_t code;

      lbl = pfile_proc_label_get(proc);
      code = label_code_get(lbl);
      if (code) {
        unsigned task_depth;

        task_depth = pic_stack_depth_get_user(pf, code, pcl, 0);
        if (task_depth > depth) {
          depth = task_depth;
        }
      }
    }
  }
  if (depth != PIC_STACK_DEPTH_INFINITE) {
    lbl = pfile_isr_entry_get(pf);
    if (lbl) {
      /*
       * we must assume an ISR can trigger at the deepest stack
       * depth
       */
      pic_code_t code;

      for (code = pic_code_list_head_get(pf);
           code && (4 != pic_code_pc_get(code));
           code = pic_code_next_get(code))
        ;
      if (code) {
        depth = pic_stack_depth_get_user(pf, (pic_code_t) label_code_get(lbl), 
            pcl, depth + 1);
      }
      label_release(lbl);
    }
  }
  value_release(pcl);
  return depth;
}

