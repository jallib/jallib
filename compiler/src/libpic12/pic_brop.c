/************************************************************
 **
 ** pic_brop.c : PIC branch optimization definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <string.h>
#include <assert.h>

#include "../libcore/pf_proc.h"
#include "pic.h"
#include "piccolst.h"
#include "pic_inst.h"
#include "pic_msg.h"
#include "pic_opfn.h"
#include "pic_gop.h"
#include "pic_brop.h"

typedef struct pic_code_brop_data_ {
  pic_branchbits_t branchbits[PIC_CODE_GOP_DEPTH];
  unsigned         ix;
  unsigned         changed;
} pic_code_brop_data_t;

/* note: this is very similar to databit optimization, but must
         be iterative because each time an operator is added or
         removed all of the other locations change which could
         cause yet another iteration
         the iterations work as follows:
           pic_code_pc_set() : sets the PC on all instructions & labels
           repeat
             analyze user path
             analyze data path
             remove redundant instructions
           while (label bank changed) */

/* run through & make sure all of the PC values are set correctly */
void pic_branchbits_pc_set(pfile_t *pf, unsigned flag)
{
  pic_code_t code;
  pic_pc_t   pc;

  for (pc = 0, code = pic_code_list_head_get(pf);
       code;
       code = pic_code_next_get(code)) {
    if (PIC_OPCODE_ORG == pic_code_op_get(code)) {
      /* unlike the other opcodes, I want to set the PC of an ORG
         to the ORG value */
      value_t org;

      org = pic_code_literal_get(code);
      pc = (pic_pc_t) value_const_get(org);
    }
    pic_code_pc_set(code, pc);
    if (pic_code_label_get(code)) {
      unsigned dist;
      const char *sign;

      dist = (unsigned) pc 
        - (unsigned) label_pc_get(pic_code_label_get(code));
      if (dist >= 0x80000000UL) {
        sign = "-";
        dist = -dist;
      } else {
        sign = "";
      }
      if ((flag & PIC_BRANCHBITS_PC_SET_FLAG_CHECK)
        && (label_pc_get(pic_code_label_get(code)) != pc)) {
        pfile_log(pf, PFILE_LOG_ERR,
          "!! PC mismatch: %s old(0x%04x) new(0x%04x) (dist=%s%u) %p\n",
          label_name_get(pic_code_label_get(code)),
          (unsigned) label_pc_get(pic_code_label_get(code)),
          (unsigned) pc,
          sign, dist, (void *) pic_code_label_get(code));
      }
      label_pc_set(pic_code_label_get(code), pc);
    }
    /* don't increment the PC for pseudo-ops */
    pc += pic_code_sz_get(code, pic_target_cpu_get(pf));
  }
}

/*
 * NAME
 *   pic_code_branchbits_analyze
 *
 * DESCRIPTION
 *   branch analyzing & fixing
 *
 * PARAMETERS
 *   pf : pfile
 *
 * RETURN
 *   TRUE if a branchbit transitions from NOP to SET/CLR
 *   FALSE if not
 *
 * NOTES
 */
static pic_code_gop_rc_t pic_code_brop_analyze(pfile_t *pf, pic_code_t code,
    pic_code_gop_which_t which, void *odata)
{
  pic_code_brop_data_t  *data;
  pic_code_gop_rc_t      rc;
  pic_branchbits_t       bbits;
  pic_branchbits_state_t cbitstate;

  data = odata;
  if (PIC_CODE_NONE != code) {
    bbits = data->branchbits[data->ix];
    pic_code_branchbits_get(code, &cbitstate);
  } else {
    bbits.pclath3 = PIC_BITSTATE_UNKNOWN;
    bbits.pclath4 = PIC_BITSTATE_UNKNOWN;
  }
  rc = PIC_CODE_GOP_RC_CONTINUE;

  switch (which) {
    case PIC_CODE_GOP_WHICH_ENTER:
      data->ix++;
      assert(data->ix < PIC_CODE_GOP_DEPTH);
      if (data->ix > 0) {
        data->branchbits[data->ix] = data->branchbits[data->ix - 1];
      }
      break;
    case PIC_CODE_GOP_WHICH_EXIT:
      data->ix--;
      break;
    case PIC_CODE_GOP_WHICH_PRE:  
      if ((cbitstate.before.pclath3 == bbits.pclath3)
          && (cbitstate.before.pclath4 == bbits.pclath4)) {
        /* this is what we expect, no change here */
        rc = PIC_CODE_GOP_RC_STOP;
      } else {
        pic_opcode_t op;

        if (PIC_BITSTATE_UNKNOWN != cbitstate.before.pclath3) {
          if (cbitstate.before.pclath3 != bbits.pclath3) {
            bbits.pclath3 = PIC_BITSTATE_INDETERMINATE;
          }
          if (cbitstate.before.pclath4 != bbits.pclath4) {
            bbits.pclath4 = PIC_BITSTATE_INDETERMINATE;
          }
        }
        cbitstate.before = bbits;
        op = pic_code_op_get(code);

        if (pic_opcode_is_branch_bit(op)) {
          pic_code_t   brcode;
          pic_opcode_t brop;
          label_t      lbl;
          unsigned     page_sz;
          pic_pc_t     brlbl_pc;

          page_sz = pic_target_page_size_get(pf);

          brcode = code;
          lbl = pic_code_brdst_get(brcode);
          brlbl_pc = (pic_pc_t) label_pc_get(lbl);
          if ((PIC_OPCODE_BRANCHLO_SET == op)
            || (PIC_OPCODE_BRANCHLO_CLR == op)
            || (PIC_OPCODE_BRANCHLO_NOP == op)) {
            brop = (brlbl_pc & page_sz) 
                 ? PIC_OPCODE_BRANCHLO_SET : PIC_OPCODE_BRANCHLO_CLR;
            if (PIC_OPCODE_BRANCHLO_NOP == op) {
              /* is this unnecessary? */
              if ((PIC_OPCODE_BRANCHLO_CLR == brop)
                && (PIC_BITSTATE_CLR == bbits.pclath3)) {
                brop = op;
              } else if ((PIC_OPCODE_BRANCHLO_SET == brop)
                && (PIC_BITSTATE_SET == bbits.pclath3)) {
                brop = op;
              } else {
                pic_code_flag_set(code, PIC_CODE_FLAG_BRANCHLO_LOCK);
              }
            }
          } else {
            /* op must be PIC_OPCODE_BRANCHHI_[SET|CLR] */
            brop = (brlbl_pc & (2 * page_sz)) 
                 ? PIC_OPCODE_BRANCHHI_SET : PIC_OPCODE_BRANCHHI_CLR;
            if (PIC_OPCODE_BRANCHHI_NOP == op) {
              if ((PIC_OPCODE_BRANCHHI_CLR == brop)
                && (PIC_BITSTATE_CLR == bbits.pclath4)) {
                brop = op;
              } else if ((PIC_OPCODE_BRANCHHI_SET == brop)
                && (PIC_BITSTATE_SET == bbits.pclath4)) {
                brop = op;
              } else {
                pic_code_flag_set(code, PIC_CODE_FLAG_BRANCHHI_LOCK);
              }
            }
          }
          if (brop != op) {
            op = brop;
            pic_code_op_set(code, brop);
            data->changed++;
          }
        }

        switch (op) {
          case PIC_OPCODE_BRANCHLO_SET:
            bbits.pclath3 = PIC_BITSTATE_SET;
            break;
          case PIC_OPCODE_BRANCHLO_CLR:
            bbits.pclath3 = PIC_BITSTATE_CLR;
            break;
          case PIC_OPCODE_BRANCHHI_SET:
            bbits.pclath4 = PIC_BITSTATE_SET;
            break;
          case PIC_OPCODE_BRANCHHI_CLR:
            bbits.pclath4 = PIC_BITSTATE_CLR;
            break;
          default:
            break;
        }
        if (pic_flag_test(pf, PIC_FLAG_NO_PCLATH3)) {
          bbits.pclath3 = PIC_BITSTATE_CLR;
        }
        if (pic_flag_test(pf, PIC_FLAG_NO_PCLATH4)) {
          bbits.pclath4 = PIC_BITSTATE_CLR;
        }
        cbitstate.action = bbits;
        pic_code_branchbits_set(code, &cbitstate);
      }
      break;
    case PIC_CODE_GOP_WHICH_POST:
      if (pic_code_is_suspend(pf, code)
        || (PIC_OPCODE_CALL == pic_code_op_get(code))) {
        bbits.pclath3 = (pic_flag_test(pf, PIC_FLAG_NO_PCLATH3))
            ? PIC_BITSTATE_CLR
            : PIC_BITSTATE_INDETERMINATE;
        bbits.pclath4 = (pic_flag_test(pf, PIC_FLAG_NO_PCLATH4))
            ? PIC_BITSTATE_CLR
            : PIC_BITSTATE_INDETERMINATE;
        pic_code_branchbits_set(code, &cbitstate);
      }
      break;
  }
  if (PIC_CODE_NONE != code) {
    data->branchbits[data->ix] = bbits;
  }
  return rc;
}

static void pic_code_brop_optimize(pfile_t *pf,
    pic_code_gop_who_t who, void *odata)
{
  pic_code_brop_data_t *data;

  UNUSED(pf);
  data = odata;
  switch (who) {
    case PIC_CODE_GOP_WHO_ISR:
    case PIC_CODE_GOP_WHO_USER:
      data->branchbits[0].pclath3 = PIC_BITSTATE_CLR;
      data->branchbits[0].pclath4 = PIC_BITSTATE_CLR;
      break;
    case PIC_CODE_GOP_WHO_INDIRECT:
      data->branchbits[0].pclath3 = PIC_BITSTATE_INDETERMINATE;
      data->branchbits[0].pclath4 = PIC_BITSTATE_INDETERMINATE;
      break;
  }
  data->ix      = (unsigned) -1;
}

/* this returns TRUE if a label has crossed as code boundary. in that
   case the entire analyze phase must be done again! 
   
   pre_add is TRUE if one of the branch-bits transitioned from NOP to SET/CLR
   once this becomes TRUE it remains TRUE and no other branchbits will be
   removed
*/
boolean_t pic_code_branchbits_post_analyze(pfile_t *pf)
{
  pic_code_t code;
  unsigned   ins_ct; /* instruction ct */
  unsigned   rem_ct;
  boolean_t  lbl_fix;

  lbl_fix = BOOLEAN_FALSE;
  pic_branchbits_pc_set(pf, PIC_BRANCHBITS_PC_SET_FLAG_CHECK);
  for (ins_ct = 0, rem_ct = 0, code = pic_code_list_head_get(pf);
       code;
       ins_ct++) {
    pic_code_t next;

    next = pic_code_next_get(code);
    if (!pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)) {
      pic_branchbits_state_t cbitstate;

      pic_code_branchbits_get(code, &cbitstate);

      switch (pic_code_op_get(code)) {
        case PIC_OPCODE_BRANCHLO_SET:
        case PIC_OPCODE_BRANCHLO_CLR:
          if ((cbitstate.before.pclath3 == cbitstate.action.pclath3)
            && !pic_code_flag_test(code, PIC_CODE_FLAG_BRANCHLO_LOCK)) {
            pic_code_op_set(code, PIC_OPCODE_BRANCHLO_NOP);
            rem_ct++;
          }
          break;
        case PIC_OPCODE_BRANCHHI_SET:
        case PIC_OPCODE_BRANCHHI_CLR:
          if ((cbitstate.before.pclath4 == cbitstate.action.pclath4) 
            && !pic_code_flag_test(code, PIC_CODE_FLAG_BRANCHHI_LOCK)) {
            pic_code_op_set(code, PIC_OPCODE_BRANCHHI_NOP);
            rem_ct++;
          }
          break;
        default:
          break;
      }
    }
    if (rem_ct) {
      /* adjust the PC */
      pic_code_pc_set(code, (pic_pc_t) (pic_code_pc_get(code) - rem_ct));
      if (pic_code_label_get(code)) {
        pic_pc_t pc_old;
        pic_pc_t pc_new;
        label_t  lbl;

        lbl = pic_code_label_get(code);
        pc_old = (pic_pc_t) label_pc_get(lbl);
        pc_new = (pic_pc_t) (pc_old - rem_ct);
        label_pc_set(lbl, pic_code_pc_get(code));
        if ((pc_old & 0x1800) != (pc_new & 0x1800)) {
          pfile_log(pf, PFILE_LOG_DEBUG, 
              "...%s moved from 0x%04lx to 0x%04lx (dist=%u) %p",
              label_name_get(lbl), pc_old, pc_new, rem_ct, (void *) lbl);
          lbl_fix = BOOLEAN_TRUE;
        }
      }
    }
    code = next;
  }
  pfile_log(pf, PFILE_LOG_DEBUG, "...removed %u of %u instructions", 
      rem_ct, ins_ct);
  pic_branchbits_pc_set(pf, PIC_BRANCHBITS_PC_SET_FLAG_CHECK);
  return lbl_fix;
}

/* i must set all branchbits to unknown before calling analyze */
static void pic_code_branchbits_pre_analyze(pfile_t *pf)
{
  pic_code_t             code;
  pic_branchbits_state_t brstate;
  pic_branchbits_t       brbits;

  brbits.pclath3 = PIC_BITSTATE_UNKNOWN;
  brbits.pclath4 = PIC_BITSTATE_UNKNOWN;
  brstate.before = brbits;
  brstate.action = brbits;
  for (code = pic_code_list_head_get(pf);
       code;
       code = pic_code_next_get(code)) {
    pic_code_branchbits_set(code, &brstate);
  }
}

void pic_code_branchbits_optimize(pfile_t *pf)
{
  unsigned             pass;
  pic_code_brop_data_t data;

  pass = 0;
  pic_branchbits_pc_set(pf, PIC_BRANCHBITS_PC_SET_FLAG_NONE);
  do {
    data.changed = 0;
    pfile_log(pf, PFILE_LOG_DEBUG, PIC_MSG_FIXING_CODE_BITS, ++pass);
    pic_code_branchbits_pre_analyze(pf);
    pic_code_gop_optimize(pf, pic_code_brop_optimize,
      pic_code_brop_analyze, &data);
    if (data.changed) {
      pic_branchbits_pc_set(pf, PIC_BRANCHBITS_PC_SET_FLAG_NONE);
    }
  } while (pic_code_branchbits_post_analyze(pf) || data.changed);
}

/*
 * NAME
 *   pic_code_branch_optimize
 *
 * DESCRIPTION
 *   optimize branches
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   none
 *
 * NOTES
 *   optimizations performed:
 *     branch to goto
 *     ---> resolve & branch
 *     goto to return
 *     ---> replace with return
 *     call to return
 *     ---> remove call
 *     goto following instruction
 *     ---> remove goto
 *     call followed by return
 *     ---> call changed to goto 
 */
/* if the code becomes less than 6K, remove all branchhi_* ops,
 * if it becomes less than 4K, remove all branchlo_* ops
 */ 
pic_code_t pic_code_brnext_get(pfile_t *pf, pic_code_t code, label_t *dst_lbl)
{
  label_t    brlbl;
  pic_code_t brdst;

  brlbl = pic_code_brdst_get(code);
  brdst = pic_code_label_find(pf, brlbl);
  /* let's figure out what the destination *really* is */
  while (brdst
      && (pic_opcode_is_branch_bit(pic_code_op_get(brdst))
        || (PIC_OPCODE_NONE == pic_code_op_get(brdst)))) {
    brdst = pic_code_next_get(brdst);
  }
  if (dst_lbl) {
    *dst_lbl = brlbl;
  }
  return brdst;
}

void pic_code_branch_optimize(pfile_t *pf)
{
  pic_code_t code;
  unsigned   goto_return         = 0;
  unsigned   call_dst_return     = 0;
  unsigned   return_follows_call = 0;
  unsigned   branch_goto         = 0;
  unsigned   total_freed         = 0;
  boolean_t  prev_cond; /* true if the previous instruction is conditional */
  unsigned   page_sz;
  value_t    code_sz;
  variable_const_t n_code_sz;

  /* set some flags based on code size */
  page_sz = pic_target_page_size_get(pf);
  code_sz = pfile_value_find(pf, PFILE_LOG_ERR, "_code_size");
  n_code_sz = value_const_get(code_sz);
  value_release(code_sz);
  if (n_code_sz <= page_sz) {
    pic_flag_set(pf, PIC_FLAG_NO_PCLATH3);
    pic_flag_set(pf, PIC_FLAG_NO_PCLATH4);
  } else if (n_code_sz <= 2 * page_sz) {
    pic_flag_set(pf, PIC_FLAG_NO_PCLATH4);
  }

  prev_cond = BOOLEAN_FALSE;

  pfile_log(pf, PFILE_LOG_DEBUG, "optimizing branches...");
  code = pic_code_list_head_get(pf);
  while (code) {
    pic_code_t next;

    next = pic_code_next_get(code);
    if (!pic_opcode_is_pseudo_op(pic_code_op_get(code))) {
      boolean_t code_cond;

      code_cond = pic_opcode_is_conditional(pic_code_op_get(code));

      if (!pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)
        && !prev_cond
        && ((PIC_OPCODE_GOTO == pic_code_op_get(code))
          || (PIC_OPCODE_CALL == pic_code_op_get(code)))) {
        pic_code_t brdst;
        label_t    brlbl;

        for (brdst = next;
             brdst
             && (PIC_OPCODE_NONE == pic_code_op_get(brdst))
             && (pic_code_label_get(brdst) != pic_code_brdst_get(code));
             brdst = pic_code_next_get(brdst))
          ; /* empty */
        if ((PIC_OPCODE_GOTO == pic_code_op_get(code))
          && (pic_code_label_get(brdst) == pic_code_brdst_get(code))) {
          /* GOTO label 
             label: */
          pic_code_list_remove(pf, code);
          pic_code_free(code);
        } else {
          pic_code_t brnext;

          /* brnext is required to detect infinite loops */
          brdst  = pic_code_brnext_get(pf, code, &brlbl);
          brnext = pic_code_brnext_get(pf, brdst, 0);
          while (brdst 
            && (PIC_OPCODE_GOTO == pic_code_op_get(brdst))
            && (brdst != brnext)) {
            brdst  = pic_code_brnext_get(pf, brdst, &brlbl);
            brnext = pic_code_brnext_get(pf, brnext, 0);
          }
          if (brnext == brdst) {
            pfile_log(pf, PFILE_LOG_DEBUG, "loop detected: %s",
              label_name_get(brlbl));
          }
#if 0
          do {
            brlbl = pic_code_brdst_get(brdst);
            brdst = pic_code_label_find(pf, brlbl);
            /* let's figure out what the destination *really* is */
            while (brdst
                && (pic_opcode_is_branch_bit(pic_code_op_get(brdst))
                  || (PIC_OPCODE_NONE == pic_code_op_get(brdst)))) {
              brdst = pic_code_next_get(brdst);
            }
          } while (brdst && (PIC_OPCODE_GOTO == pic_code_op_get(brdst)));
#endif
          /* brlbl is the last label we've found and brdst is the first
           * instruction past the last label */
          if (brlbl != pic_code_brdst_get(code)) {
            /* change any branch bit destinations */
            pic_code_t brbits;

            brbits = pic_code_prev_get(code);
            while ((pic_code_brdst_get(brbits) == pic_code_brdst_get(code))
                && pic_opcode_is_branch_bit(pic_code_op_get(brbits))) {
              pic_code_brdst_set(brbits, brlbl);
              brbits = pic_code_prev_get(brbits);
            }
          }
          if ((PIC_OPCODE_RETURN == pic_code_op_get(brdst))
            || (PIC_OPCODE_RETFIE == pic_code_op_get(brdst))
            || (PIC_OPCODE_RETLW == pic_code_op_get(brdst))) {
            pic_code_t code_tmp;

            if (PIC_OPCODE_GOTO == pic_code_op_get(code)) {
              /* GOTO a RETURN ; replace the GOTO */
              pic_code_op_set(code, pic_code_op_get(brdst));
              pic_code_literal_set(code, pic_code_literal_get(brdst));
              pic_code_brdst_set(code, LABEL_NONE);
              goto_return++;
              code = pic_code_prev_get(code);
            } else {
              /* CALL a RETURN ; remove the CALL */
              call_dst_return++;
              code_tmp = pic_code_prev_get(code);
              /* if this is call --> retlw, replace with movlw
                 otherwise remove this instruction */
              if (PIC_OPCODE_RETLW == pic_code_op_get(brdst)) {
                pic_code_t rcode; /* replacement code */

                rcode = pic_code_alloc(
                  pic_code_label_get(code),
                  PIC_OPCODE_MOVLW,
                  pic_code_flag_get_all(code));
                pic_code_literal_set(rcode, pic_code_literal_get(brdst));
                pic_code_cmd_set(rcode, pic_code_cmd_get(code));
                pic_code_list_insert(pf, code_tmp, rcode);
              } else {
                total_freed++;
              }
              pic_code_list_remove(pf, code);
              pic_code_free(code);
              code = code_tmp;
            }
            while (code && pic_opcode_is_branch_bit(pic_code_op_get(code))) {
              code_tmp = pic_code_prev_get(code);
              pic_code_list_remove(pf, code);
              pic_code_free(code);
              total_freed++;
              code = code_tmp;
            }
          } else if (pic_code_brdst_get(code) != brlbl) {
            pic_code_brdst_set(code, brlbl);
            branch_goto++;
          }
          if (PIC_OPCODE_CALL == pic_code_op_get(code)) {
            /* is this call followed by return? if yes, make it a goto */
            pic_code_t code_tmp;

            code_tmp = pic_code_next_get(code);
            while (code_tmp
                && (PIC_OPCODE_NONE == pic_code_op_get(code_tmp))) {
              code_tmp = pic_code_next_get(code_tmp);
            }
            if (PIC_OPCODE_RETURN == pic_code_op_get(code_tmp)) {
              return_follows_call++;
              pic_code_op_set(code, PIC_OPCODE_GOTO);
              next = pic_code_next_get(code_tmp);
            }
          }
        }
      }
      prev_cond = code_cond;
    }
    code = next;
  }
  pfile_log(pf, PFILE_LOG_DEBUG, 
      "...goto/return(%u) call/return(%u) branch/goto(%u)",
      goto_return, call_dst_return, branch_goto);
  pfile_log(pf, PFILE_LOG_DEBUG,
      "...return follows call(%u) total freed(%u)",
      return_follows_call, total_freed);
}

/*
 *     movlw or clrw  --> retlw
 *     return
 *
 *     ...or...
 *     
 *     movlw or clrw  ---> (conditional)
 *     (conditional)       retlw
 *     movlw or clrw       retlw
 *     return
 */
static pic_code_t pic_code_next_exec_get(pic_code_t code)
{
  do {
    code = pic_code_next_get(code);
  } while (code 
    && ((PIC_OPCODE_NONE == pic_code_op_get(code))
      || (PIC_OPCODE_DATALO_CLR == pic_code_op_get(code))
      || (PIC_OPCODE_DATALO_SET == pic_code_op_get(code))
      || (PIC_OPCODE_DATAHI_CLR == pic_code_op_get(code))
      || (PIC_OPCODE_DATAHI_SET == pic_code_op_get(code))));
  return code;
}

static value_t pic_code_literal_value_get(pfile_t *pf, pic_code_t code)
{
  value_t n;

  if (PIC_OPCODE_CLRW == pic_code_op_get(code)) {
    n = pfile_constant_get(pf, 0, VARIABLE_DEF_NONE);
  } else {
    n = pic_code_literal_get(code);
    value_lock(n);
  }
  return n;
}

void pic_code_return_literal_optimimze(pfile_t *pf)
{
  pic_code_t code;
  unsigned   return_lit = 0;

  pfile_log(pf, PFILE_LOG_DEBUG, "optimizing return literal...");
  for (code = pic_code_list_head_get(pf);
       code;
       code = pic_code_next_get(code)) {
    if (!pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)) {
      pic_code_t next1;

      next1 = pic_code_next_exec_get(code);

      if (((PIC_OPCODE_MOVLW == pic_code_op_get(code))
          || (PIC_OPCODE_CLRW == pic_code_op_get(code)))) {
        if (PIC_OPCODE_RETURN == pic_code_op_get(next1)) {
          value_t val;

          val = pic_code_literal_value_get(pf, code);
          pic_code_op_set(code, PIC_OPCODE_RETLW);
          pic_code_literal_set(code, val);
          value_release(val);
          return_lit++;
        } else if (pic_opcode_is_conditional(pic_code_op_get(next1))) {
          pic_code_t next2;
          pic_code_t next3;

          next2 = pic_code_next_exec_get(next1);
          next3 = pic_code_next_exec_get(next2);

          if (((PIC_OPCODE_MOVLW == pic_code_op_get(next2))
            || (PIC_OPCODE_CLRW == pic_code_op_get(next2)))
            && (PIC_OPCODE_RETURN == pic_code_op_get(next3))) {
            value_t val1;
            value_t val2;

            val1 = pic_code_literal_value_get(pf, code);
            val2 = pic_code_literal_value_get(pf, next2);
            pic_code_literal_set(code, VALUE_NONE);
            pic_code_op_set(code, PIC_OPCODE_NONE);
            pic_code_literal_set(next2, val2);
            pic_code_op_set(next2, PIC_OPCODE_RETLW);
            pic_code_literal_set(next3, val1);
            pic_code_op_set(next3, PIC_OPCODE_RETLW);
            value_release(val2);
            value_release(val1);
            return_lit++;
          }
        }
      }
    }
  }
  pfile_log(pf, PFILE_LOG_DEBUG, "...return literal(%u)", return_lit);
}

/* this looks for:
      btfsc/btfss blah
      goto label
      one instruction
   label:

   and changes is into
      (invert condition)
      one instruction
   label:

   it's done on it's own so it can be called by pic_code_branchbits_remove
*/
boolean_t pic_code_skip_cond_optimize(pfile_t *pf)
{
  pic_code_t   code;
  boolean_t    last_cond; /* the last code was conditional */
  unsigned     ct;

  ct = 0;

  last_cond = BOOLEAN_FALSE;
  for (code = pic_code_list_head_get(pf);
       code;
       code = pic_code_next_get(code)) {
    if (!last_cond && ((PIC_OPCODE_BTFSC == pic_code_op_get(code))
      || (PIC_OPCODE_BTFSS == pic_code_op_get(code)))) {
      pic_code_t next;

      next = pic_code_next_get(code);
      if (PIC_OPCODE_GOTO == pic_code_op_get(next)) {
        pic_code_t next2;

        next2 = pic_code_next_get(next);
        next2 = pic_code_next_get(next2);
        if (pic_code_label_get(next2) == pic_code_brdst_get(next)) {
          pic_code_op_set(code,
            (PIC_OPCODE_BTFSC == pic_code_op_get(code))
            ? PIC_OPCODE_BTFSS : PIC_OPCODE_BTFSC);
          pic_code_list_remove(pf, next);
          pic_code_free(next);
          ct++;
        }
      }
      last_cond = BOOLEAN_TRUE;
    } else if (pic_code_is_exec(code)) {
      last_cond = BOOLEAN_FALSE;
    }
  }
  pfile_log(pf, PFILE_LOG_DEBUG,
      "%u instructions removed by skip_cond optimizer", ct);
  return ct != 0;
}

/* nb: since a branchlo_nop could turn into a branchlo_[set|clr] it needs
       to be accounted for */
boolean_t pic_code_branchbits_remove(pfile_t *pf)
{
  /*do {*/
    unsigned   branchhi_ct     = 0;
    unsigned   branchlo_ct     = 0;
    unsigned   branchlo_nop_ct = 0;
    pic_pc_t   pc              = 0;
    unsigned   total;
    pic_code_t code;
    unsigned   page_sz;
    enum {
      REMOVE_NONE = 0,
      REMOVE_HI,
      REMOVE_ALL
    } rem;

    pfile_log(pf, PFILE_LOG_DEBUG, "optimizing branch bits(2)...");
    pic_branchbits_pc_set(pf, PIC_BRANCHBITS_PC_SET_FLAG_NONE);
    page_sz = pic_target_page_size_get(pf);
    for (code = pic_code_list_head_get(pf);
         code;
         code = pic_code_next_get(code)) {
      if (pic_code_pc_get(code) > pc) {
        pc = pic_code_pc_get(code);
      }
      switch (pic_code_op_get(code)) {
        case PIC_OPCODE_BRANCHLO_NOP:
          branchlo_nop_ct++;
          break;
        case PIC_OPCODE_BRANCHLO_CLR:
        case PIC_OPCODE_BRANCHLO_SET:
          if (!pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)) {
            branchlo_ct++;
          }
          break;
        case PIC_OPCODE_BRANCHHI_CLR:
        case PIC_OPCODE_BRANCHHI_SET:
          if (!pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)) {
            branchhi_ct++;
          }
          break;
        default:
          break;
      }
    }
    if (pc - branchlo_ct - branchhi_ct < page_sz) {
      /* remove all branch bits */
      rem = REMOVE_ALL;
      pic_flag_set(pf, PIC_FLAG_NO_PCLATH3);
      pic_flag_set(pf, PIC_FLAG_NO_PCLATH4);
    } else if (pc - branchhi_ct + branchlo_nop_ct < (2 * page_sz)) {
      /* remove all branchhi bits */
      rem = REMOVE_HI;
      pic_flag_set(pf, PIC_FLAG_NO_PCLATH4);
    } else {
      rem = REMOVE_NONE;
    }
    total = 0;
    if (REMOVE_NONE != rem) {
      pic_code_t next;

      for (code = pic_code_list_head_get(pf);
           code;
           code = next) {
        next = pic_code_next_get(code);
        if (!pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)) {
          switch (pic_code_op_get(code)) {
            case PIC_OPCODE_BRANCHLO_CLR:
            case PIC_OPCODE_BRANCHLO_SET:
            case PIC_OPCODE_BRANCHLO_NOP:
              if (REMOVE_ALL != rem) {
                break;
              }
              /* fall through */
            case PIC_OPCODE_BRANCHHI_CLR:
            case PIC_OPCODE_BRANCHHI_SET:
            case PIC_OPCODE_BRANCHHI_NOP:
              pic_code_list_remove(pf, code);
              pic_code_free(code);
              code = PIC_CODE_NONE;
              total++;
              break;
            default:
              break;
          }
          if (PIC_CODE_NONE != code) {
            pic_branchbits_state_t bbits;

            pic_code_branchbits_get(code, &bbits);
            if (REMOVE_ALL == rem) {
              bbits.before.pclath3 = PIC_BITSTATE_CLR;
              bbits.before.pclath4 = PIC_BITSTATE_CLR;
              bbits.action.pclath3 = PIC_BITSTATE_CLR;
              bbits.action.pclath4 = PIC_BITSTATE_CLR;
            } else if (REMOVE_HI == rem) {
              bbits.before.pclath4 = PIC_BITSTATE_CLR;
              bbits.action.pclath4 = PIC_BITSTATE_CLR;
            }
            pic_code_branchbits_set(code, &bbits);
          }
        }
      }
    }
    pfile_log(pf, PFILE_LOG_DEBUG, "...unneeded branch bits(%u)", 
        total);
  return pic_code_skip_cond_optimize(pf) || (0 != total);  
}

