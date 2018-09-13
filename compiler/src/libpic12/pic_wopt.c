/************************************************************
 **
 ** pic_wopt.c : W value optimization definitions
 **
 ** Copyright (c) 2006, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include "../libcore/pf_proc.h"
#include "piccolst.h"
#include "pic_wopt.h"

/*
 * NAME
 *   pic_code_z_changed
 *
 * DESCRIPTION
 *   determine if an instruction changes the 'z' flag
 *
 * PARAMETERS
 *   op : opcode
 *
 * RETURN
 *   return TRUE if an instruction changes 'z', FALSE if not
 *
 * NOTES
 */
static boolean_t pic_code_z_changed(pic_opcode_t op)
{
  boolean_t rc;

  rc = BOOLEAN_FALSE;
  switch (op) {
    case PIC_OPCODE_ORG:
    case PIC_OPCODE_END:
    case PIC_OPCODE_NONE:
    case PIC_OPCODE_NOP:
    case PIC_OPCODE_SLEEP:
    case PIC_OPCODE_CLRWDT:
    case PIC_OPCODE_OPTION:
    case PIC_OPCODE_BCF:
    case PIC_OPCODE_BSF:
    case PIC_OPCODE_BTFSC:
    case PIC_OPCODE_BTFSS:
    case PIC_OPCODE_TRIS:
    case PIC_OPCODE_DATALO_SET:
    case PIC_OPCODE_DATALO_CLR:
    case PIC_OPCODE_DATAHI_SET:
    case PIC_OPCODE_DATAHI_CLR:
    case PIC_OPCODE_IRP_SET:
    case PIC_OPCODE_IRP_CLR:
    case PIC_OPCODE_BRANCHLO_SET:
    case PIC_OPCODE_BRANCHLO_CLR:
    case PIC_OPCODE_BRANCHLO_NOP:
    case PIC_OPCODE_BRANCHHI_SET:
    case PIC_OPCODE_BRANCHHI_CLR:
    case PIC_OPCODE_BRANCHHI_NOP:
    case PIC_OPCODE_RLCF:
    case PIC_OPCODE_RLF:
    case PIC_OPCODE_RRCF:
    case PIC_OPCODE_RRF:
    case PIC_OPCODE_SWAPF:
    case PIC_OPCODE_MOVWF:
    case PIC_OPCODE_MOVLW:
    case PIC_OPCODE_RETLW:
    case PIC_OPCODE_RETFIE:
    case PIC_OPCODE_RETURN:
    case PIC_OPCODE_GOTO:
    case PIC_OPCODE_CALL:
    case PIC_OPCODE_DECFSZ:
    case PIC_OPCODE_INCFSZ:
    case PIC_OPCODE_MULLW:
    case PIC_OPCODE_DCFSNZ:
    case PIC_OPCODE_INFSNZ:
    case PIC_OPCODE_CPFSEQ:
    case PIC_OPCODE_CPFSGT:
    case PIC_OPCODE_CPFSLT:
    case PIC_OPCODE_MULWF:
    case PIC_OPCODE_SETF:
    case PIC_OPCODE_TSTFSZ:
    case PIC_OPCODE_BTG:
    case PIC_OPCODE_BC:
    case PIC_OPCODE_BNC:
    case PIC_OPCODE_BN:
    case PIC_OPCODE_BNOV:
    case PIC_OPCODE_BNN:
    case PIC_OPCODE_BNZ:
    case PIC_OPCODE_BOV:
    case PIC_OPCODE_BZ:
    case PIC_OPCODE_BRA:
    case PIC_OPCODE_RCALL:
    case PIC_OPCODE_DAW:
    case PIC_OPCODE_POP:
    case PIC_OPCODE_PUSH:
    case PIC_OPCODE_LFSR:
    case PIC_OPCODE_MOVFF:
    case PIC_OPCODE_MOVLB:
    case PIC_OPCODE_MOVLP:
    case PIC_OPCODE_MOVLP_NOP:
    case PIC_OPCODE_TBLRD:
    case PIC_OPCODE_TBLWT:
    case PIC_OPCODE_DB:
      rc = BOOLEAN_FALSE;
      break;
    case PIC_OPCODE_RESET:
    case PIC_OPCODE_NEGF:
    case PIC_OPCODE_RLNCF:
    case PIC_OPCODE_RRNCF:
    case PIC_OPCODE_ADDWFc:
    case PIC_OPCODE_SUBFWB:
    case PIC_OPCODE_SUBWFB:
    case PIC_OPCODE_CLRF:
    case PIC_OPCODE_ADDWF:
    case PIC_OPCODE_ANDWF:
    case PIC_OPCODE_XORWF:
    case PIC_OPCODE_IORWF:
    case PIC_OPCODE_SUBWF:
    case PIC_OPCODE_COMF:
    case PIC_OPCODE_DECF:
    case PIC_OPCODE_INCF:
    case PIC_OPCODE_MOVF:
    case PIC_OPCODE_CLRW:
    case PIC_OPCODE_ADDLW:
    case PIC_OPCODE_ANDLW:
    case PIC_OPCODE_IORLW:
    case PIC_OPCODE_SUBLW:
    case PIC_OPCODE_XORLW:
      rc = BOOLEAN_TRUE;
      break;
  }
  return rc;
}

/*
 * NAME
 *   pic_code_z_used
 *
 * DESCRIPTION
 *   determine if status:z is used before an intervening
 *   command changes it
 *
 * PARAMETERS
 *   code : place to start
 *
 * RETURN
 *   TRUE -- status:z is used, FALSE, it's not
 *
 * NOTES
 *   an instruction set like:
 *     movwf x
 *     movf  x,w
 *     btfss _status, _z
 *   will be broken if the movwf/movf set is removed. To avoid
 *   this, determine if _status:_z is used before it is changed
 *   by another code. If so, change the movwf/movf to iorlw 0
 *   which will correctly set the flag
 */
static boolean_t pic_code_z_used(pfile_t *pf, pic_code_t code)
{
  boolean_t rc;
  value_t   status;
  value_t   status_z;

  rc       = BOOLEAN_FALSE;
  status   = pfile_value_find(pf, PFILE_LOG_ERR, "_status");
  status_z = pfile_value_find(pf, PFILE_LOG_ERR, "_z");

  if (!pic_code_z_changed(pic_code_op_get(code))) {
    if ((PIC_OPCODE_BTFSS == pic_code_op_get(code))
      || (PIC_OPCODE_BTFSC == pic_code_op_get(code))) {
      if (value_is_same(pic_code_value_get(code), status)
          && (value_const_get(status_z) 
            == value_const_get(pic_code_literal_get(code)))) {
        rc = BOOLEAN_TRUE;
      }
    }
  }
  value_release(status_z);
  value_release(status);
  return rc;
}

/*
 * NAME
 *   pic_code_w_value_detect
 *
 * DESCRIPTION
 *   determine the value in W at each code location
 *
 * PARAMETERS
 *   pf      : pfile handle
 *   code    : current code
 *   w_value : current value in w
 *
 * RETURN
 *   last known value in W
 *
 * NOTES
 */
static value_t pic_code_w_value_detect(pfile_t *pf, pic_code_t code, 
    value_t w_value)
{
  boolean_t pv_code_is_cond;
  boolean_t changed;

  pv_code_is_cond = BOOLEAN_FALSE;
  changed         = BOOLEAN_TRUE;
  while (code 
      && (changed
        || !pic_code_flag_test(code, PIC_CODE_FLAG_W_VISITED))) {
    pic_opcode_t op;
    boolean_t    code_is_cond;
    pic_code_t   next;

    next = pic_code_next_get(code);

    pic_code_flag_set(code, PIC_CODE_FLAG_W_VISITED);
    /* we know changed is BOOLEAN_TRUE, so need only set it to false */
    if (pic_code_flag_test(code, PIC_CODE_FLAG_W_UNKNOWN)) {
      w_value = VALUE_NONE;
      changed = BOOLEAN_FALSE;
    } else if (VALUE_NONE == pic_code_w_value_get(code)) {
      if (w_value) {
        pic_code_w_value_set(code, w_value);
      } else {
        changed = BOOLEAN_FALSE;
      }
    } else if (!value_is_same(w_value, pic_code_w_value_get(code))) {
      pic_code_w_value_set(code, VALUE_NONE);
      pic_code_flag_set(code, PIC_CODE_FLAG_W_UNKNOWN);
    } else {
      changed = BOOLEAN_FALSE;
    }
    op = pic_code_op_get(code);
    code_is_cond = (PIC_OPCODE_BTFSS == op)
       || (PIC_OPCODE_BTFSC == op)
       || (PIC_OPCODE_INCFSZ == op)
       || (PIC_OPCODE_DECFSZ == op);
    switch (op) {
      case PIC_OPCODE_ORG:
      case PIC_OPCODE_END:
      case PIC_OPCODE_NONE:
      case PIC_OPCODE_CLRF:
      case PIC_OPCODE_NOP:
      case PIC_OPCODE_SLEEP:
      case PIC_OPCODE_CLRWDT:
      case PIC_OPCODE_OPTION:
      case PIC_OPCODE_BCF:
      case PIC_OPCODE_BSF:
      case PIC_OPCODE_BTFSC:
      case PIC_OPCODE_BTFSS:
      case PIC_OPCODE_TRIS:
      case PIC_OPCODE_DATALO_SET:
      case PIC_OPCODE_DATALO_CLR:
      case PIC_OPCODE_DATAHI_SET:
      case PIC_OPCODE_DATAHI_CLR:
      case PIC_OPCODE_IRP_SET:
      case PIC_OPCODE_IRP_CLR:
      case PIC_OPCODE_BRANCHLO_SET:
      case PIC_OPCODE_BRANCHLO_CLR:
      case PIC_OPCODE_BRANCHLO_NOP:
      case PIC_OPCODE_BRANCHHI_SET:
      case PIC_OPCODE_BRANCHHI_CLR:
      case PIC_OPCODE_BRANCHHI_NOP:
      case PIC_OPCODE_MULLW:
      case PIC_OPCODE_DCFSNZ:
      case PIC_OPCODE_INFSNZ:
      case PIC_OPCODE_CPFSEQ:
      case PIC_OPCODE_CPFSGT:
      case PIC_OPCODE_CPFSLT:
      case PIC_OPCODE_MULWF:
      case PIC_OPCODE_NEGF:
      case PIC_OPCODE_SETF:
      case PIC_OPCODE_TSTFSZ:
      case PIC_OPCODE_BTG:
      case PIC_OPCODE_DAW:
      case PIC_OPCODE_POP:
      case PIC_OPCODE_PUSH:
      case PIC_OPCODE_RESET:
      case PIC_OPCODE_LFSR:
      case PIC_OPCODE_MOVFF:
      case PIC_OPCODE_MOVLB:
      case PIC_OPCODE_MOVLP:
      case PIC_OPCODE_MOVLP_NOP:
      case PIC_OPCODE_TBLRD:
      case PIC_OPCODE_TBLWT:
      case PIC_OPCODE_DB:
        break; /* these don't change W */
      case PIC_OPCODE_ADDWFc:
      case PIC_OPCODE_ADDWF:
      case PIC_OPCODE_ANDWF:
      case PIC_OPCODE_XORWF:
      case PIC_OPCODE_IORWF:
      case PIC_OPCODE_SUBWF:
      case PIC_OPCODE_COMF:
      case PIC_OPCODE_DECF:
      case PIC_OPCODE_DECFSZ:
      case PIC_OPCODE_INCF:
      case PIC_OPCODE_INCFSZ:
      case PIC_OPCODE_RLCF:
      case PIC_OPCODE_RLF:
      case PIC_OPCODE_RRCF:
      case PIC_OPCODE_RRF:
      case PIC_OPCODE_RLNCF:
      case PIC_OPCODE_RRNCF:
      case PIC_OPCODE_SUBFWB:
      case PIC_OPCODE_SUBWFB:
      case PIC_OPCODE_SWAPF:
        /* if the destination of these is W, the result is unknown */
        if (PIC_OPDST_W == pic_code_dst_get(code)) {
          w_value = VALUE_NONE;
        } else if ((PIC_OPDST_F == pic_code_dst_get(code))
          && value_is_same(pic_code_value_get(code), 
            pic_code_w_value_get(code))) {
          w_value = VALUE_NONE;
        }
        break;
      case PIC_OPCODE_MOVWF:
        /* if W goes into this we'll assume W has a new value (we only
         * track one value for W).
         * nb: cannot assume anything about volatile variables! */
        w_value = (!value_is_volatile(pic_code_value_get(code)))
          ? pic_code_value_get(code)
          : VALUE_NONE;
        break;
      case PIC_OPCODE_MOVF:
        /* if this goes into W we know what W contains; */
        w_value = (!value_is_volatile(pic_code_value_get(code))
            && (PIC_OPDST_W == pic_code_dst_get(code)))
          ? pic_code_value_get(code)
          : VALUE_NONE;
        break;
      case PIC_OPCODE_CLRW:
      case PIC_OPCODE_ADDLW:
      case PIC_OPCODE_ANDLW:
      case PIC_OPCODE_IORLW:
      case PIC_OPCODE_MOVLW:
      case PIC_OPCODE_SUBLW:
      case PIC_OPCODE_XORLW:
        w_value = VALUE_NONE;
        break;
      case PIC_OPCODE_RETLW:
        w_value = VALUE_NONE;
        /* fall through */
      case PIC_OPCODE_RETFIE:
      case PIC_OPCODE_RETURN:
        /* we're done here */
        next = PIC_CODE_NONE;
        break;
      case PIC_OPCODE_GOTO:   /* goto n */
      case PIC_OPCODE_CALL:   /* call n */
      case PIC_OPCODE_BC:
      case PIC_OPCODE_BN:
      case PIC_OPCODE_BNC:
      case PIC_OPCODE_BNN:
      case PIC_OPCODE_BNOV:
      case PIC_OPCODE_BNZ:
      case PIC_OPCODE_BOV:
      case PIC_OPCODE_BZ:
      case PIC_OPCODE_BRA:
      case PIC_OPCODE_RCALL:
        {
          pic_code_t dst;

          dst = pic_code_label_find(pf, pic_code_brdst_get(code));
          if ((PIC_OPCODE_CALL == op) || pv_code_is_cond) {
            w_value = pic_code_w_value_detect(pf, dst, w_value);
            if (PIC_OPCODE_CALL == op) {
              /* after a call, assume we don't know the value of W */
              w_value = VALUE_NONE;
            }
          } else {
            next = dst;
          }
        }
        break;
    }
    pv_code_is_cond = code_is_cond;
    code = next;
  }
  return w_value;
}

/*
 * NAME
 *   pic_w_cleanup
 *
 * DESCRIPTION
 *   after determining what W holds, look for assignments from the same
 *   value & remove these
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   number of instructions removed
 *
 * NOTES
 *   this also looks for values that are no longer used and removes
 *   assignments to them.
 */
static unsigned pic_w_cleanup(pfile_t *pf)
{
  pic_code_t code;
  pic_code_t next;
  unsigned   rem_ct;
  value_t    zero;

  rem_ct = 0;
  zero = pfile_constant_get(pf, 0, VARIABLE_DEF_NONE);
  for (code = pic_code_list_head_get(pf);
       code;
       code = next) {
    value_t val;
    value_t w_val;

    next  = pic_code_next_get(code);
    val   = pic_code_value_get(code);
    w_val = pic_code_w_value_get(code);

    if (val
        && !value_is_volatile(val)
        && !pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)) {
      pic_opcode_t op;

      op = pic_code_op_get(code);
      if ((PIC_OPCODE_MOVF == op)
        && (PIC_OPDST_W == pic_code_dst_get(code))  
        && value_is_same(val, w_val)) {
        value_use_ct_bump(w_val, CTR_BUMP_DECR);
        if (pic_code_z_used(pf, pic_code_next_get(code))) {
          /* change this to iorlw to make sure _status:_z is set correctly */
          pic_code_op_set(code, PIC_OPCODE_IORLW);
          pic_code_value_set(code, VALUE_NONE);
          pic_code_literal_set(code, zero);
        } else {
          pic_code_list_remove(pf, code);
          pic_code_free(code);
          rem_ct++;
        }
#if 1
      } else if (0 == value_use_ct_get(val)) {
        variable_t master;

        for (master = variable_master_get(value_variable_get(val));
             master && !variable_use_ct_get(master);
             master = variable_master_get(master))
          ; /* empty loop */

        if (!master) {
          if ((PIC_OPCODE_DATALO_SET != op)
            && (PIC_OPCODE_DATALO_CLR != op)
            && (PIC_OPCODE_DATAHI_SET != op)
            && (PIC_OPCODE_DATAHI_CLR != op)) {
            value_assign_ct_bump(val, CTR_BUMP_DECR);
          }
          pic_code_list_remove(pf, code);
          pic_code_free(code);
          rem_ct++;
        }
#endif
      }
    }
  }
  value_release(zero);
  return rem_ct;
}

void pic_w_value_optimize(pfile_t *pf)
{
  pfile_proc_t *proc;
  pic_code_t    code;
  label_t       lbl;

  for (code = pic_code_list_head_get(pf);
       code;
       code = pic_code_next_get(code)) {
    pic_code_flag_clr(code, PIC_CODE_FLAG_W_VISITED);
  }
  /* first mark the use code */
  pic_code_w_value_detect(pf, pic_code_list_head_get(pf), VALUE_NONE);
  /* next the ISRs */
  lbl = pfile_label_find(pf, PFILE_LOG_NONE, PIC_LABEL_ISR);
  if (lbl) {
    pic_code_w_value_detect(pf, pic_code_label_find(pf, lbl), VALUE_NONE);
    label_release(lbl);
  }
  /* finally, any indirect or tasks */
  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INDIRECT)
        || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_TASK)) {
      pic_code_w_value_detect(pf, 
          pic_code_label_find(pf, pfile_proc_label_get(proc)), VALUE_NONE);
    }
  }

  if (pfile_flag_test(pf, PFILE_FLAG_OPT_LOAD_REDUCE)) {
    unsigned total;
    unsigned removed;
    unsigned pass;

    total = 0;
    pass  = 1;
    while ((removed = pic_w_cleanup(pf)) != 0) {
      total += removed;
      pass++;
    }
    printf("CODE (%u) removed in (%u) passes\n", total, pass);
  }
}

/*
 * look for:
 *   movwf val
 *   movf  val,w
 * and remove the second one. This is caused by the
 * pass/return byte in W code generator.
 */
void pic_w_value_optimize1(pfile_t *pf)
{
  pic_code_t code;
  pic_code_t code_pv;

  for (code_pv = PIC_CODE_NONE, code = pic_code_list_head_get(pf);
       code;
       code_pv = code, code = pic_code_next_get(code)) {
    if (!pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)
      && !pic_code_flag_test(code_pv, PIC_CODE_FLAG_NO_OPTIMIZE)
      && (PIC_OPCODE_MOVWF == pic_code_op_get(code_pv))
      && (PIC_OPCODE_MOVF == pic_code_op_get(code))
      && (PIC_OPDST_W == pic_code_dst_get(code))
      && (pic_code_ofs_get(code_pv) == pic_code_ofs_get(code))
      && value_is_same(pic_code_value_get(code), 
        pic_code_value_get(code_pv))) {
      pic_code_t next;

      for (next = pic_code_next_get(code);
            ((pic_code_op_get(next) == PIC_OPCODE_BRANCHLO_SET)
          || (pic_code_op_get(next) == PIC_OPCODE_BRANCHLO_CLR)
          || (pic_code_op_get(next) == PIC_OPCODE_BRANCHLO_NOP)
          || (pic_code_op_get(next) == PIC_OPCODE_BRANCHHI_SET)
          || (pic_code_op_get(next) == PIC_OPCODE_BRANCHHI_CLR)
          || (pic_code_op_get(next) == PIC_OPCODE_BRANCHHI_NOP)
          || (pic_code_op_get(next) == PIC_OPCODE_MOVLP));
          next = pic_code_next_get(next))
        ; /* null body */
      if (!pic_code_z_used(pf, next)) {
        /* make sure the next operation doesn't rely on <status:z> */
        pic_code_list_remove(pf, code);
        code = code_pv;
      }
    }
  }
}

