/************************************************************
 **
 ** pic.c : pic code generation definitions
 **
 ** Copyright (c) 2004-2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <string.h>
#include <errno.h>
#include <assert.h>

#include "../libutils/mem.h"
#include "../libcore/cmd_asm.h"
#include "../libcore/cmd_brch.h"
#include "../libcore/cmd_op.h"
#include "../libcore/cmd_usec.h"
#include "../libcore/pf_proc.h"
#include "../libcore/pf_msg.h"
#include "../libcore/pf_cmd.h"
#include "piccolst.h"
#include "pic_brop.h"
#include "picbsrop.h"
#include "picmovlpop.h"
#include "pic_daop.h"
#include "pic_inst.h"
#include "pic_msg.h"
#include "pic_op.h"
#include "pic_opfn.h"
#include "pic_stvar.h"
#include "pic_var.h"
#include "pic_stk.h"
#include "picdelay.h"
#include "pic_wopt.h"
#include "pic_emu.h"
#include "pic.h"
#include "pic12.h"
#include "pic14.h"
#include "pic14h.h"
#include "pic16.h"

#define PIC_LABEL_COLUMN_SZ 32
#define PIC_OPCODE_COLUMN_SZ 8
#define STRINGIZE2(x) #x
#define STRINGIZE(x) STRINGIZE2(x)

static pic_target_cpu_t pic_target_cpu;       /* target CPU type */
static unsigned         pic_target_page_size; /* code page size  */
static unsigned         pic_target_bank_size; /* data bank size  */
static boolean_t        pic_in_isr_flag;      /* TRUE when generating ISR */
static unsigned         pic_code_gen_pass;

const char *pic_opcode_str(pic_opcode_t op)
{
  const char *ostr;

  ostr = "{unknown}";
  switch (op) {
    case PIC_OPCODE_NONE:   ostr = "{none}"; break;
    /* 12 & 14 bit instructions */
    case PIC_OPCODE_ORG:    ostr = "org";    break;
    case PIC_OPCODE_END:    ostr = "end";    break;
    case PIC_OPCODE_ADDWF:  ostr = "addwf";  break;
    case PIC_OPCODE_ANDWF:  ostr = "andwf";  break;
    case PIC_OPCODE_XORWF:  ostr = "xorwf";  break;
    case PIC_OPCODE_IORWF:  ostr = "iorwf";  break;
    case PIC_OPCODE_SUBWF:  ostr = "subwf";  break;
    case PIC_OPCODE_COMF:   ostr = "comf";   break;
    case PIC_OPCODE_DECF:   ostr = "decf";   break;
    case PIC_OPCODE_DECFSZ: ostr = "decfsz"; break;
    case PIC_OPCODE_INCF:   ostr = "incf";   break;
    case PIC_OPCODE_INCFSZ: ostr = "incfsz"; break;
    case PIC_OPCODE_RLF:    ostr = "rlf";    break;
    case PIC_OPCODE_RLCF:   ostr = "rlcf";   break;
    case PIC_OPCODE_RRF:    ostr = "rrf";    break;
    case PIC_OPCODE_RRCF:   ostr = "rrcf";   break;
    case PIC_OPCODE_MOVF:   ostr = "movf";   break;
    case PIC_OPCODE_SWAPF:  ostr = "swapf";  break;
    case PIC_OPCODE_CLRF:   ostr = "clrf";   break;
    case PIC_OPCODE_CLRW:   ostr = "clrw";   break;
    case PIC_OPCODE_MOVWF:  ostr = "movwf";  break;
    case PIC_OPCODE_NOP:    ostr = "nop";    break;
    case PIC_OPCODE_RETFIE: ostr = "retfie"; break;
    case PIC_OPCODE_RETURN: ostr = "return"; break;
    case PIC_OPCODE_SLEEP:  ostr = "sleep";  break;
    case PIC_OPCODE_CLRWDT: ostr = "clrwdt"; break;
    case PIC_OPCODE_BCF:    ostr = "bcf";    break;
    case PIC_OPCODE_BSF:    ostr = "bsf";    break;
    case PIC_OPCODE_BTFSC:  ostr = "btfsc";  break;
    case PIC_OPCODE_BTFSS:  ostr = "btfss";  break;
    case PIC_OPCODE_ADDLW:  ostr = "addlw";  break;
    case PIC_OPCODE_ANDLW:  ostr = "andlw";  break;
    case PIC_OPCODE_IORLW:  ostr = "iorlw";  break;
    case PIC_OPCODE_MOVLW:  ostr = "movlw";  break;
    case PIC_OPCODE_SUBLW:  ostr = "sublw";  break;
    case PIC_OPCODE_XORLW:  ostr = "xorlw";  break;
    case PIC_OPCODE_CALL:   ostr = "call";   break;
    case PIC_OPCODE_GOTO:   ostr = "goto";   break;
    case PIC_OPCODE_RETLW:  ostr = "retlw";  break;
    /* 16 bit instructions */
    case PIC_OPCODE_MULLW:  ostr = "mullw";  break;
    case PIC_OPCODE_ADDWFc: ostr = "addwfc"; break;
    case PIC_OPCODE_DCFSNZ: ostr = "dcsfnz"; break;
    case PIC_OPCODE_INFSNZ: ostr = "infsnz"; break;
    case PIC_OPCODE_RLNCF:  ostr = "rlncf";  break;
    case PIC_OPCODE_RRNCF:  ostr = "rrncf";  break;
    case PIC_OPCODE_SUBFWB: ostr = "subfwb"; break;
    case PIC_OPCODE_SUBWFB: ostr = "subwfb"; break;
    case PIC_OPCODE_CPFSEQ: ostr = "cpfseq"; break;
    case PIC_OPCODE_CPFSGT: ostr = "cpfsgt"; break;
    case PIC_OPCODE_CPFSLT: ostr = "cpfslt"; break;
    case PIC_OPCODE_MULWF:  ostr = "mulwf";  break;
    case PIC_OPCODE_NEGF:   ostr = "negf";   break;
    case PIC_OPCODE_SETF:   ostr = "setf";   break;
    case PIC_OPCODE_TSTFSZ: ostr = "tstfsz"; break;
    case PIC_OPCODE_BTG:    ostr = "btg";    break;
    case PIC_OPCODE_BC:     ostr = "bc";     break;
    case PIC_OPCODE_BN:     ostr = "bn";     break;
    case PIC_OPCODE_BNC:    ostr = "bnc";    break;
    case PIC_OPCODE_BNN:    ostr = "bnn";    break;
    case PIC_OPCODE_BNOV:   ostr = "bnov";   break;
    case PIC_OPCODE_BNZ:    ostr = "bnz";    break;
    case PIC_OPCODE_BOV:    ostr = "bov";    break;
    case PIC_OPCODE_BZ:     ostr = "bz";     break;
    case PIC_OPCODE_BRA:    ostr = "bra";    break;
    case PIC_OPCODE_RCALL:  ostr = "rcall";  break;
    case PIC_OPCODE_DAW:    ostr = "daw";    break;
    case PIC_OPCODE_POP:    ostr = "pop";    break;
    case PIC_OPCODE_PUSH:   ostr = "push";   break;
    case PIC_OPCODE_RESET:  ostr = "reset";  break;
    case PIC_OPCODE_LFSR:   ostr = "lfsr";   break;
    case PIC_OPCODE_MOVFF:  ostr = "movff";  break;
    case PIC_OPCODE_MOVLB:  ostr = "movlb";  break;
    case PIC_OPCODE_MOVLP:  ostr = "movlp";  break;
    case PIC_OPCODE_TBLRD:  ostr = "tblrd";  break;
    case PIC_OPCODE_TBLWT:  ostr = "tblwt";  break;
    /* macro & misc */
    case PIC_OPCODE_DATALO_SET:   ostr = "datalo_set";   break;
    case PIC_OPCODE_DATALO_CLR:   ostr = "datalo_clr";   break;
    case PIC_OPCODE_DATAHI_SET:   ostr = "datahi_set";   break;
    case PIC_OPCODE_DATAHI_CLR:   ostr = "datahi_clr";   break;
    case PIC_OPCODE_IRP_SET:      ostr = "irp_set";      break;
    case PIC_OPCODE_IRP_CLR:      ostr = "irp_clr";      break;
    case PIC_OPCODE_BRANCHLO_SET: ostr = "branchlo_set"; break;
    case PIC_OPCODE_BRANCHLO_CLR: ostr = "branchlo_clr"; break;
    case PIC_OPCODE_BRANCHLO_NOP: ostr = "branchlo_nop"; break;
    case PIC_OPCODE_BRANCHHI_SET: ostr = "branchhi_set"; break;
    case PIC_OPCODE_BRANCHHI_CLR: ostr = "branchhi_clr"; break;
    case PIC_OPCODE_BRANCHHI_NOP: ostr = "branchhi_nop"; break;
    case PIC_OPCODE_MOVLP_NOP:    ostr = "movlp_nop";    break;
    case PIC_OPCODE_OPTION:       ostr = "option";       break;
    case PIC_OPCODE_TRIS:         ostr = "tris";         break;
    case PIC_OPCODE_DB:           ostr = "db";           break;
  }
  return ostr;
}

pic_optype_t pic_optype_get(pic_opcode_t op)
{
  pic_optype_t type;

  type = PIC_OPTYPE_NONE;
  switch (op) {
    case PIC_OPCODE_NONE:
    case PIC_OPCODE_ORG:
    case PIC_OPCODE_END:
    case PIC_OPCODE_CLRW:
    case PIC_OPCODE_NOP:
    case PIC_OPCODE_RETFIE:
    case PIC_OPCODE_RETURN:
    case PIC_OPCODE_SLEEP:
    case PIC_OPCODE_CLRWDT:
    case PIC_OPCODE_OPTION:
    case PIC_OPCODE_DB:
    case PIC_OPCODE_POP:
    case PIC_OPCODE_PUSH:
    case PIC_OPCODE_RESET:
    case PIC_OPCODE_DAW:
      type = PIC_OPTYPE_NONE;
      break;
    case PIC_OPCODE_CLRF:
    case PIC_OPCODE_MOVWF:
    case PIC_OPCODE_DATALO_SET:
    case PIC_OPCODE_DATALO_CLR:
    case PIC_OPCODE_DATAHI_SET:
    case PIC_OPCODE_DATAHI_CLR:
    case PIC_OPCODE_IRP_SET:
    case PIC_OPCODE_IRP_CLR:
    case PIC_OPCODE_CPFSEQ:
    case PIC_OPCODE_CPFSGT:
    case PIC_OPCODE_CPFSLT:
    case PIC_OPCODE_MULWF:
    case PIC_OPCODE_NEGF:
    case PIC_OPCODE_SETF:
    case PIC_OPCODE_TSTFSZ:
      type = PIC_OPTYPE_F;
      break;
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
    case PIC_OPCODE_RLF:
    case PIC_OPCODE_RLCF:
    case PIC_OPCODE_RRF:
    case PIC_OPCODE_RRCF:
    case PIC_OPCODE_MOVF:
    case PIC_OPCODE_SWAPF:
    case PIC_OPCODE_DCFSNZ:
    case PIC_OPCODE_INFSNZ:
    case PIC_OPCODE_ADDWFc:
    case PIC_OPCODE_RLNCF:
    case PIC_OPCODE_RRNCF:
    case PIC_OPCODE_SUBFWB:
    case PIC_OPCODE_SUBWFB:
      type = PIC_OPTYPE_F_D;
      break;
    case PIC_OPCODE_BCF:
    case PIC_OPCODE_BSF:
    case PIC_OPCODE_BTFSC:
    case PIC_OPCODE_BTFSS:
    case PIC_OPCODE_BTG:
      type = PIC_OPTYPE_F_B;
      break;
    case PIC_OPCODE_ADDLW:
    case PIC_OPCODE_ANDLW:
    case PIC_OPCODE_IORLW:
    case PIC_OPCODE_MOVLW:
    case PIC_OPCODE_SUBLW:
    case PIC_OPCODE_XORLW:
    case PIC_OPCODE_RETLW:
    case PIC_OPCODE_TRIS:
    case PIC_OPCODE_MULLW:
    case PIC_OPCODE_TBLRD:
    case PIC_OPCODE_TBLWT:
      type = PIC_OPTYPE_N;
      break;
    case PIC_OPCODE_CALL:
    case PIC_OPCODE_GOTO:
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

    case PIC_OPCODE_BRANCHLO_SET:
    case PIC_OPCODE_BRANCHLO_CLR:
    case PIC_OPCODE_BRANCHLO_NOP:
    case PIC_OPCODE_BRANCHHI_SET:
    case PIC_OPCODE_BRANCHHI_CLR:
    case PIC_OPCODE_BRANCHHI_NOP:
      type = PIC_OPTYPE_K;
      break;
    case PIC_OPCODE_LFSR:
    case PIC_OPCODE_MOVFF:
    case PIC_OPCODE_MOVLB:
    case PIC_OPCODE_MOVLP:
    case PIC_OPCODE_MOVLP_NOP:
      type = PIC_OPTYPE_NONE;
      break;
  }
  return type;
}

const char *pic_opdst_str(pic_opdst_t type)
{
  const char *str;

  str = "{none}";
  switch (type) {
    case PIC_OPDST_NONE: break;
    case PIC_OPDST_W:    str = "w"; break;
    case PIC_OPDST_F:    str = "f"; break;
  }
  return str;
}


/************************************************************
 **
 ** utility functions
 **
 ************************************************************/

/*
 * NAME
 *   pic_branch_proc
 *
 * DESCRIPTION
 *   execute a procedure call
 *
 * PARAMETERS
 *   pf          : pfile handle
 *   brcond      : condition
 *   brval       : value for condition
 *   proc        :
 *   proc_params :
 *
 * RETURN
 *   none
 *
 * NOTES
 *   There are three types of procedures
 *     1. normal -- variable block is discretely allocated local variables
 *        1. copy the IN parameters
 *        2. call proc
 *        3. copy the OUT parameters
 *     2. recursive -- all local variables are allocated out of a single block
 *        1. call the pre-fn
 *           (push the local variables onto the stack)
 *        2. copy the IN parameters
 *        3. call proc
 *        4. copy the OUT parameter
 *        5. call the post-fn
 *           (pop the local variables off of the stack)
 *     3. indirect -- parameters are allocated in a single block,
 *                    remaining locals are allocated discretetly
 *        1. copy the IN parameters to the pic_temp block
 *        2. call the indirect fn
 *           1. copy the pic_temp block to the parameter block
 *           2. execute the function
 *              1. copy the function's address into _indirect_call_addr
 *              2. call indirect_call
 *                 1. load PCLATH
 *                 2. load PCL
 *           3. copy the parameter block to the pic_temp block
 *        3. copy the OUT parameters from the pic_temp block
 *
 * the first 1-byte OUT parameter (including the return value)
 * will be returned in W; the first 1-byte IN parameter
 * will be passed in W *except* for indirect functions
 */
label_t pic_label_find(pfile_t *pf, const char *name, boolean_t alloc)
{
  label_t lbl;

  lbl = pfile_label_find(pf, PFILE_LOG_NONE, name);
  if (!lbl && alloc) {
    lbl = pfile_label_alloc(pf, name);
  }
  return lbl;
}

value_t pic_value_find_or_alloc(pfile_t *pf, const char *name,
  variable_def_type_t type, variable_sz_t sz)
{
  value_t val;

  val = pfile_value_find(pf, PFILE_LOG_NONE, name);
  if (!val) {
    variable_def_t def;

    def = variable_def_alloc(0, type, VARIABLE_DEF_FLAG_NONE, sz);
    (void) pfile_value_alloc(pf, PFILE_VARIABLE_ALLOC_GLOBAL,
      name, def, &val);
  }
  return val;
}

/* return the parameter number that will be passed in W
 * flag = VARIABLE_FLAG_IN or VARIABLE_FLAG_OUT
 */
#define PIC_PROC_W_PARAM_NONE ((size_t) -1)

size_t pic_proc_w_param_get(pfile_t *pf, const pfile_proc_t *proc,
    flag_t flag)
{
  size_t ii;

  if (((VARIABLE_DEF_FLAG_IN == flag)
    && (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INDIRECT)
      || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_REENTRANT)))
      || ((VARIABLE_DEF_FLAG_OUT == flag)
        && pfile_proc_flag_test(proc, PFILE_PROC_FLAG_REENTRANT))
      || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_TASK)
      || pic_is_12bit(pf)
      || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_NOSTACK)) {
    /* a function that is called indirectly *never* gets a parameter
     * passed in W, likewise a re-entrant function cannot ever return
     * a value in W */
    ii = PIC_PROC_W_PARAM_NONE;
  } else {
    for (ii = 0; ii < pfile_proc_param_ct_get(proc); ii++) {
      value_t val;

      val = pfile_proc_param_get(proc, ii);
      if (value_dflag_test(val, flag)
          && (1 == value_sz_get(val))
          && !value_dflag_test(val, VARIABLE_DEF_FLAG_BIT)
          && !variable_is_const(value_variable_get(val))
          /*&& !value_is_const(val)
          && value_variable_get(val)*/) {
        break;
      }
    }
  }
  if (ii == pfile_proc_param_ct_get(proc)) {
    ii = PIC_PROC_W_PARAM_NONE;
  }

  return ii;
}

/* move a one-byte value in val to W */
void pic_value_move_to_w(pfile_t *pf, value_t val)
{
  pic_op(pf, OPERATOR_ASSIGN, VALUE_NONE, val, VALUE_NONE);
}

/*
 * start a new task
 *    FOR task_ct USING task_idx loop
 *      IF !task_list[task_idx] THEN
 *        task_list[task_idx] = val
 *        RETURN
 *      END IF
 *    END LOOP
 */
static void pic_task_start(pfile_t *pf, value_t prval)
{
  label_t       fn;
  value_t       fnval;
  pic_code_t    code;
  pfile_proc_t *proc;
  label_t       lbl;
  variable_sz_t ii;

  proc = value_proc_get(prval);
  lbl  = pfile_proc_label_get(proc);

  /* this is probably a hack, but I don't know how else to do it!
     is might be best ot create a pic_instr_append_n_d() */
  fnval = pic_var_task_ptr_get(pf);
  for (ii = 0; ii < pic_pointer_size_get(pf); ii++) {
    code = pic_instr_append_f_d(pf, PIC_OPCODE_MOVLW, prval, ii, PIC_OPDST_W);
    pic_code_brdst_set(code, lbl);
    pic_code_value_set(code, VALUE_NONE);
    if (ii + 1 < pic_pointer_size_get(pf)) {
      (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, fnval, ii);
    }
  }
  fn = pic_label_find(pf, PIC_LABEL_TASK_START, BOOLEAN_TRUE);
  (void) pic_instr_append_n(pf, PIC_OPCODE_CALL, fn);
  label_release(fn);
  pic_var_task_ptr_release(pf, fnval);
}

static void pic_branch_proc(pfile_t *pf, cmd_branchcond_t brcond,
    value_t brval, value_t prval, value_t *proc_params)
{
  label_t brskip;

  /* I don't know that this will ever be possible, but it's probably
   * worth coding up just in case */
  assert(CMD_BRANCHCOND_NONE == brcond);
  if (CMD_BRANCHCOND_NONE == brcond) {
    brskip = LABEL_NONE;
  } else {
    pic_opcode_t op;

    brskip = pfile_label_alloc(pf, 0);
    if (value_is_single_bit(brval)) {
      op = PIC_OPCODE_NOP;
      switch (brcond) {
        case CMD_BRANCHCOND_TRUE:  op = PIC_OPCODE_BTFSC; break;
        case CMD_BRANCHCOND_FALSE: op = PIC_OPCODE_BTFSS; break;
        case CMD_BRANCHCOND_NONE:  break;
      }
      (void) pic_instr_append_f(pf, op, brval, 0);
    } else {
      op = PIC_OPCODE_NOP;
      switch (brcond) {
        case CMD_BRANCHCOND_TRUE:  op = PIC_OPCODE_BTFSS; break;
        case CMD_BRANCHCOND_FALSE: op = PIC_OPCODE_BTFSC; break;
        case CMD_BRANCHCOND_NONE:  break;
      }
      pic_op(pf, OPERATOR_LOGICAL, VALUE_NONE, brval, VALUE_NONE);
      /* pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 1); */
      (void) pic_instr_append_reg_flag(pf, op, "_status", "_z");
    }
    (void) pic_instr_append_n(pf, PIC_OPCODE_GOTO, brskip);
  }
  if (VARIABLE_DEF_TYPE_FUNCTION == value_type_get(prval)) {
    pfile_proc_t *proc;

    proc = value_proc_get(prval);
    if (!proc
      || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_REENTRANT)
      || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INDIRECT)) {
      /* an re-entrant, indirect, or call to a function that is called
       * indirectly elsewhere. all parameters go into the global parameter
       * block. */
      variable_def_member_t mbr_head;
      variable_def_member_t mbr_ptr;
      value_t              *tvals;
      size_t                ct;
      size_t                return_in_w;

      mbr_head = variable_def_member_get(value_def_get(prval));
      for (ct = 0, mbr_ptr = mbr_head;
           mbr_ptr;
           ct++, mbr_ptr = variable_def_member_link_get(mbr_ptr))
        ; /* null body */
      tvals = MALLOC(sizeof(*tvals) * ct);
      if (!tvals) {
        pfile_log_syserr(pf, ENOMEM);
      } else {
        size_t  ii;
        label_t lbl;
        value_t lsb;
        value_t val2;

        /* setup all of the parameters into the temporary area
           proc_params[0] = where to put the return value */
        for (ii = 0, mbr_ptr = mbr_head,
              return_in_w = PIC_PROC_W_PARAM_NONE;
             ii < ct;
             ii++, mbr_ptr = variable_def_member_link_get(mbr_ptr)) {
          variable_def_t def_ptr;

          def_ptr = variable_def_member_def_get(mbr_ptr);
          if (!pic_is_12bit(pf)
              && !pfile_proc_flag_test(proc, PFILE_PROC_FLAG_NOSTACK)
              && !pfile_proc_flag_test(proc, PFILE_PROC_FLAG_REENTRANT)
              && (PIC_PROC_W_PARAM_NONE == return_in_w)
              && variable_def_flag_test(def_ptr, VARIABLE_DEF_FLAG_OUT)
              && (variable_def_sz_get(def_ptr) == 1)
              && !variable_def_flag_test(def_ptr, VARIABLE_DEF_FLAG_BIT)) {
            return_in_w = ii;
          }
          if (variable_def_flag_test(def_ptr, VARIABLE_DEF_FLAG_IN)) {
            /* if this is a re-entrant procedure and the parameter is not
             * AUTO, go ahead and make the assignment */
            value_t pval;

            pval = pfile_proc_param_get(proc, ii);
            if (!pval || value_is_auto(pval)) {
              tvals[ii] = pic_var_temp_get_def(pf, def_ptr);
              pic_op(pf, OPERATOR_ASSIGN, tvals[ii], proc_params[ii],
                VALUE_NONE);
            } else if (!value_is_const(pval) && !value_is_lookup(pval)) {
              pic_op(pf, OPERATOR_ASSIGN, pval, proc_params[ii],
                  VALUE_NONE);
              tvals[ii] = VALUE_NONE;
            } else {
              tvals[ii] = VALUE_NONE;
            }
          } else {
            tvals[ii] = VALUE_NONE;
          }
        }
        for (ii = ct; ii > 1; ii--) {
          if (tvals[ii-1]) {
            pic_var_temp_release(pf, tvals[ii-1]);
          }
        }
        /* execute the function */
        if (!proc) {
          /* an indirect call
           * 12/14 bit : _pic_pointer[0] = PCL
           *             W               = PCLATH
           * 16    bit : _pic_pointer[0] = PCL
           *                         [1] = PCLATH
           *             W               = PCLATHU
           */
          variable_sz_t ofs;

          lsb = pic_var_pointer_get(pf);
          val2 = value_clone(prval);
          value_indirect_clear(val2);
          for (ofs = 0; ofs < pic_pointer_size_get(pf); ofs++) {
            (void) pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val2, ofs, 
              PIC_OPDST_W);
            if (ofs + 1 < pic_pointer_size_get(pf)) {
              (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, lsb, ofs);
            }
          }
          value_release(val2);
          lbl = pic_label_find(pf, PIC_LABEL_INDIRECT, BOOLEAN_TRUE);
        } else {
          lbl = pfile_proc_label_get(proc);
          label_lock(lbl);
          lsb = VALUE_NONE;
        }
        (void) pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl);
        label_release(lbl);
        if (VALUE_NONE != lsb) {
          pic_var_pointer_release(pf, lsb);
        }
        /* pickup any return values */
        if ((PIC_PROC_W_PARAM_NONE != return_in_w) 
          && proc_params[return_in_w]) {
          if (value_is_indirect(proc_params[return_in_w])) {
            value_t rtmp;

            rtmp = pic_var_sign_get(pf);
            pic_op(pf, OPERATOR_ASSIGN, rtmp, VALUE_NONE, VALUE_NONE);
            pic_op(pf, OPERATOR_ASSIGN, proc_params[return_in_w], rtmp,
                VALUE_NONE);
            pic_var_sign_release(pf, rtmp);
          } else {
            pic_op(pf, OPERATOR_ASSIGN, proc_params[return_in_w], VALUE_NONE,
                VALUE_NONE);
          }
        }
        for (ii = 0, mbr_ptr = mbr_head;
             ii < ct;
             ii++, mbr_ptr = variable_def_member_link_get(mbr_ptr)) {
          variable_def_t def_ptr;

          def_ptr = variable_def_member_def_get(mbr_ptr);
          if ((return_in_w != ii)
              && variable_def_flag_test(def_ptr, VARIABLE_DEF_FLAG_OUT)) {
            tvals[ii] = pic_var_temp_get_def(pf, def_ptr);
            if (value_use_ct_get(proc_params[ii])) {
              pic_op(pf, OPERATOR_ASSIGN, proc_params[ii], tvals[ii],
                VALUE_NONE);
            }
          } else {
            tvals[ii] = 0;
          }
        }
        for (ii = ct; ii; ii--) {
          if (tvals[ii-1]) {
            pic_var_temp_release(pf, tvals[ii-1]);
          }
        }
      }
    } else {
      /* a direct call */
      value_t val;
      size_t  ii;
      size_t  param_in_w;
      size_t  return_in_w;

      param_in_w = pic_proc_w_param_get(pf, proc, VARIABLE_DEF_FLAG_IN);
      for (ii = 0; ii < pfile_proc_param_ct_get(proc); ii++) {
        /* if the proc parameter has gone const, it will be reflected in the
         * attached variable, *not* the value itself */
        val = pfile_proc_param_get(proc, ii);
        if (value_dflag_test(val, VARIABLE_DEF_FLAG_IN)) {
          if (!value_is_const(val)
            && !variable_is_const(value_variable_get(val))) {
            if (ii != param_in_w) {
              pic_op(pf, OPERATOR_ASSIGN, val, proc_params[ii], VALUE_NONE);
            }
          }
        }
      }
      if (PIC_PROC_W_PARAM_NONE != param_in_w) {
        /* nb: the assign/use ct bits are done in the loop above */
        pic_value_move_to_w(pf, proc_params[param_in_w]);
      }
      if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_TASK)) {
        pic_task_start(pf, prval);
      } else if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_NOSTACK)) {
        label_t lbl_ret;
        value_t rval;

        lbl_ret = pfile_label_alloc(pf, 0);
        rval    = value_alloc(pfile_proc_ret_ptr_get(proc));

        /* copy the return address */
        for (ii = value_sz_get(rval); ii; ii--) {
          pic_code_t code;

          code = pic_instr_append(pf, PIC_OPCODE_MOVLW);
          pic_code_brdst_set(code, lbl_ret);
          pic_code_ofs_set(code, ii - 1);
          (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, rval, ii - 1);
        }
        value_release(rval);

        /* jump to the procedure */
        for (ii = value_sz_get(rval); ii; ii--) {
          value_t     pcl;
          pic_code_t  code;
          const char *pcl_name;

          code = pic_instr_append(pf, PIC_OPCODE_MOVLW);
          pic_code_brdst_set(code, pfile_proc_label_get(proc));
          pic_code_ofs_set(code, ii - 1);
          pcl_name = "{error}";
          switch (ii - 1) {
            case 2: pcl_name = "_pclatu"; break;
            case 1: pcl_name = "_pclath"; break;
            case 0: pcl_name = "_pcl";    break;
          }
          pcl = pfile_value_find(pf, PFILE_LOG_ERR, pcl_name);
          (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, pcl, 0);
          value_release(pcl);
        }

        /* note the return address */
        (void) pic_instr_append_label(pf, lbl_ret);
        label_release(lbl_ret);
      } else {
        (void) pic_instr_append_n(pf, PIC_OPCODE_CALL, 
          pfile_proc_label_get(proc));
      }

      return_in_w = pic_proc_w_param_get(pf, proc, VARIABLE_DEF_FLAG_OUT);
      if (PIC_PROC_W_PARAM_NONE != return_in_w) {
        /* nb: the assign/use ct bits are done in the loop above */
        if (value_is_indirect(proc_params[return_in_w])) {
          value_t rtmp;

          if (proc_params[return_in_w]) {
            rtmp = pic_var_sign_get(pf);
            pic_op(pf, OPERATOR_ASSIGN, rtmp, VALUE_NONE, VALUE_NONE);
            pic_op(pf, OPERATOR_ASSIGN, proc_params[return_in_w], rtmp,
                VALUE_NONE);
            pic_var_sign_release(pf, rtmp);
          }
        } else if (value_is_function(proc_params[return_in_w])) {
          pfile_proc_t *rproc;

          rproc = value_proc_get(proc_params[return_in_w]);
          (void) pic_instr_append_n(pf, PIC_OPCODE_CALL, 
            pfile_proc_label_get(rproc));
        } else {
          if (proc_params[return_in_w]
              && !value_is_const(proc_params[return_in_w])) {
            pic_op(pf, OPERATOR_ASSIGN, proc_params[return_in_w], VALUE_NONE,
                VALUE_NONE);
          }
        }
      }
      for (ii = 0; ii < pfile_proc_param_ct_get(proc); ii++) {
        val = pfile_proc_param_get(proc, ii);

        if (value_dflag_test(val, VARIABLE_DEF_FLAG_OUT)) {
          if (proc_params[ii]
              && !value_is_const(proc_params[ii])
              && !variable_is_const(value_variable_get(proc_params[ii]))) {
            if (ii != return_in_w) {
              pic_op(pf, OPERATOR_ASSIGN, proc_params[ii], val, VALUE_NONE);
            }
          }
        }
      }
    }
  }
  if (brskip) {
    (void) pic_instr_append_label(pf, brskip);
    label_release(brskip);
  }
}

static void pic_task_suspend(pfile_t *pf)
{
  label_t       ret;
  value_t       task_ptr;
  pic_code_t    code;
  label_t       suspend;
  variable_sz_t ii;

  suspend = pic_label_find(pf, PIC_LABEL_TASK_SUSPEND, BOOLEAN_TRUE);
  ret      = pfile_label_alloc(pf, 0);
  task_ptr = pic_var_task_ptr_get(pf);
  for (ii = 0; ii < pic_pointer_size_get(pf); ii++) {
    code = pic_instr_append(pf, PIC_OPCODE_MOVLW);
    pic_code_ofs_set(code, ii);
    pic_code_brdst_set(code, ret);
    if (ii + 1 < pic_pointer_size_get(pf)) {
      (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, task_ptr, ii);
    }
  }
  (void) pic_instr_append_n(pf, PIC_OPCODE_GOTO, suspend);
  (void) pic_instr_append_label(pf, ret);

  label_release(suspend);
  label_release(ret);
  pic_var_task_ptr_release(pf, task_ptr);
}

/*
 * NAME
 *   pic_branch
 *
 * DESCRIPTION
 *   handle command type CMD_TYPE_BRANCH
 *
 * PARAMETERS
 *   pf  : pfile
 *   cmd : a branch command
 *
 * RETURN
 *
 * NOTES
 */
static void pic_branch(pfile_t *pf, cmd_branchtype_t brtype,
    cmd_branchcond_t brcond, label_t dst, value_t val,
    value_t proc, value_t *proc_params)
{
  if (proc) {
    pic_branch_proc(pf, brcond, val, proc, proc_params);
  } else {
    pic_opcode_t op;

    if (CMD_BRANCHCOND_NONE != brcond) {
      /* val might be NULL if Z is already set elsewhere */
      if (val) {
        /* pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 1); */
        if (value_is_single_bit(val)) {
          op = PIC_OPCODE_NOP;
          switch (brcond) {
            case CMD_BRANCHCOND_TRUE:  op = PIC_OPCODE_BTFSC; break;
            case CMD_BRANCHCOND_FALSE: op = PIC_OPCODE_BTFSS; break;
            case CMD_BRANCHCOND_NONE:  break;
          }
          (void) pic_instr_append_f(pf, op, val, 0);
        } else {
          op = PIC_OPCODE_NOP;
          switch (brcond) {
            case CMD_BRANCHCOND_TRUE:  op = PIC_OPCODE_BTFSS; break;
            case CMD_BRANCHCOND_FALSE: op = PIC_OPCODE_BTFSC; break;
            case CMD_BRANCHCOND_NONE:  break;
          }
          pic_op(pf, OPERATOR_LOGICAL, 0, val, 0);
          (void) pic_instr_append_reg_flag(pf, op, "_status", "_z");
        }
      } else {
        op = PIC_OPCODE_NOP;
        switch (brcond) {
          case CMD_BRANCHCOND_TRUE:  op = PIC_OPCODE_BTFSS; break;
          case CMD_BRANCHCOND_FALSE: op = PIC_OPCODE_BTFSC; break;
          case CMD_BRANCHCOND_NONE:  break;
        }
        (void) pic_instr_append_reg_flag(pf, op, "_status", "_z");
      }
    }
    op = PIC_OPCODE_NONE;
    switch (brtype) {
      case CMD_BRANCHTYPE_TASK_START:
      case CMD_BRANCHTYPE_TASK_END:
      case CMD_BRANCHTYPE_NONE:         break;
      case CMD_BRANCHTYPE_TASK_SUSPEND: pic_task_suspend(pf);   break;
      case CMD_BRANCHTYPE_GOTO:         op = PIC_OPCODE_GOTO;   break;
      case CMD_BRANCHTYPE_CALL:         op = PIC_OPCODE_CALL;   break;
      case CMD_BRANCHTYPE_RETURN:       op = PIC_OPCODE_RETURN; break;
    }
    if (PIC_OPCODE_RETURN == op) {
      (void) pic_instr_append(pf, op);
    } else if (PIC_OPCODE_NONE != op) {
      (void) pic_instr_append_n(pf, op, dst);
    }
  }
  if (CMD_BRANCHTYPE_CALL == brtype) {
    /* we might have called someone so reset the known values */
    pic_last_values_reset();
  }
}

/* this is yet another special condition in the form:
   _temp = expression
   if (_temp) then goto dst; end if
   in this case, depending on the expression, things can be simplified.
   unfortunately this *could* result in more temporary variable space being
   allocated than necessary but I'm not quite sure how to solve that yet;

   the only operations that are allowed are:
     relationals
     equality
     logical
     notl
     cmpb
   If this changed, pic_cmd_optimize() must also be changed!

   only one of tval or flag may exist!
*/
static void pic_branch_cond_append(pfile_t *pf, pic_opcode_t pop,
    label_t brdst, pic_opcode_t brop, value_t tval, const char *flag)
{
  if (tval) {
    (void) pic_instr_append_f(pf, brop, tval, 0);
  } else {
    (void) pic_instr_append_reg_flag(pf, brop, "_status", flag);
  }
  if (PIC_OPCODE_RETURN == pop) {
    (void) pic_instr_append(pf, pop);
  } else {
    (void) pic_instr_append_n(pf, pop, brdst);
  }
}

static pic_opcode_t pic_branch_cond_brop_invert(pic_opcode_t op)
{
  return (PIC_OPCODE_BTFSS == op) ? PIC_OPCODE_BTFSC : PIC_OPCODE_BTFSS;
}

static void pic_branch_cond(pfile_t *pf, cmd_t cmd)
{
  operator_t   op;
  pic_opcode_t pop;
  label_t      lbl;
  value_t      dst;
  value_t      val1;
  value_t      val2;

  op   = cmd_optype_get(cmd);
  dst  = cmd_opdst_get(cmd);
  val1 = cmd_opval1_get(cmd);
  val2 = cmd_opval2_get(cmd);

  cmd = cmd_link_get(cmd);
  pop = PIC_OPCODE_NOP;
  switch (cmd_brtype_get(cmd)) {
    case CMD_BRANCHTYPE_TASK_START:
    case CMD_BRANCHTYPE_TASK_SUSPEND:
    case CMD_BRANCHTYPE_TASK_END:
    case CMD_BRANCHTYPE_NONE:   assert(0); break;
    case CMD_BRANCHTYPE_GOTO:   pop = PIC_OPCODE_GOTO; break;
    case CMD_BRANCHTYPE_CALL:   pop = PIC_OPCODE_CALL; break;
    case CMD_BRANCHTYPE_RETURN: pop = PIC_OPCODE_RETURN; break;
  }

  lbl = cmd_brdst_get(cmd);
  if (operator_is_relation(op)) {
    label_t skip;

    op = pic_relational(pf, op, dst, val1, val2);

    if (CMD_BRANCHCOND_FALSE == cmd_brcond_get(cmd)) {
      /* invert the operator */
      switch (op) {
        case OPERATOR_LT: op = OPERATOR_GE; break;
        case OPERATOR_LE: op = OPERATOR_GT; break;
        case OPERATOR_EQ: op = OPERATOR_NE; break;
        case OPERATOR_NE: op = OPERATOR_EQ; break;
        case OPERATOR_GE: op = OPERATOR_LT; break;
        case OPERATOR_GT: op = OPERATOR_LE; break;
        default: assert(0); break;
      }
    }

    skip = ((OPERATOR_LT == op)
        || (OPERATOR_LE == op)
        || (OPERATOR_GE == op)
        || (OPERATOR_GT == op))
      ? pfile_label_alloc(pf, 0)
      : LABEL_NONE;
    switch (op) {
      /*
       * nb : carry is *inverted* because subtract is done via
       *      2's complement add
       */
      case OPERATOR_LT: /* c and !z */
        pic_branch_cond_append(pf, PIC_OPCODE_GOTO, skip, PIC_OPCODE_BTFSC,
          VALUE_NONE, "_z");
        pic_branch_cond_append(pf, pop, lbl, PIC_OPCODE_BTFSC, VALUE_NONE,
          "_c");
        break;
      case OPERATOR_LE: /* c or z */
        pic_branch_cond_append(pf, PIC_OPCODE_GOTO, lbl, PIC_OPCODE_BTFSC,
          VALUE_NONE, "_z");
        pic_branch_cond_append(pf, pop, lbl, PIC_OPCODE_BTFSC, VALUE_NONE,
          "_c");
        break;
      case OPERATOR_EQ: /* z */
        pic_branch_cond_append(pf, pop, lbl, PIC_OPCODE_BTFSC, VALUE_NONE,
          "_z");
        break;
      case OPERATOR_NE: /* !z */
        pic_branch_cond_append(pf, pop, lbl, PIC_OPCODE_BTFSS, VALUE_NONE,
          "_z");
        break;
      case OPERATOR_GE: /* !c or z */
        pic_branch_cond_append(pf, PIC_OPCODE_GOTO, lbl, PIC_OPCODE_BTFSC,
          VALUE_NONE, "_z");
        pic_branch_cond_append(pf, pop, lbl, PIC_OPCODE_BTFSS, VALUE_NONE,
          "_c");
        break;
      case OPERATOR_GT: /* !c and !z */
        /* the complex case :( */
        pic_branch_cond_append(pf, PIC_OPCODE_GOTO, skip, PIC_OPCODE_BTFSC,
          VALUE_NONE, "_z");
        pic_branch_cond_append(pf, pop, lbl, PIC_OPCODE_BTFSS, VALUE_NONE,
          "_c");
        break;
      default:
        assert(0);
    }
    if (skip) {
      (void) pic_instr_append_label(pf, skip);
      label_release(skip);
    }
  } else {
    /*
     * op is one of:
     *    OPERATOR_LOGICAL
     *    OPERATOR_NOTL
     *    OPERATOR_CMPB
     * these are all very much the same
     */
    value_t      tmp;
    const char  *flag;
    pic_opcode_t brop;

    flag = 0;
    if (dst) {
      tmp = dst;
      pic_op(pf, op, dst, val1, VALUE_NONE);
    } else if (value_is_single_bit(val1)
        || (!value_is_lookup(val1)
          && !value_is_indirect(val1)
          && (1 == value_sz_get(val1)))) {
      tmp = val1;
    } else {
      if (OPERATOR_CMPB == op) {
        tmp = pic_var_temp_get(pf, VARIABLE_FLAG_NONE,
            value_byte_sz_get(val1));
      } else {
        tmp = VALUE_NONE;
      }
      pic_op(pf, (OPERATOR_NOTL == op) ? OPERATOR_LOGICAL : op,
          tmp, val1, VALUE_NONE);
    }
    if (value_is_single_bit(tmp)) {
      /* notl is the same as cmpb; logical is the reverse */
      brop = (OPERATOR_LOGICAL == op)
        ? PIC_OPCODE_BTFSC : PIC_OPCODE_BTFSS;
    } else if (1 == value_sz_get(tmp)) {
      flag = "_z";
      if ((OPERATOR_LOGICAL == op) || (OPERATOR_NOTL == op)) {
        /* z is set if tmp is FALSE, clear if TRUE */
        (void) pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tmp, 0, PIC_OPDST_W);
        brop = (OPERATOR_LOGICAL == op)
          ? PIC_OPCODE_BTFSS : PIC_OPCODE_BTFSC;
      } else if (OPERATOR_CMPB == op) {
        (void) pic_instr_append_f_d(pf, PIC_OPCODE_COMF, tmp, 0, PIC_OPDST_W);
        brop = PIC_OPCODE_BTFSS;
      } else {
        assert(0);
      }
    } else {
      if (OPERATOR_CMPB == op) {
        pic_op(pf, OPERATOR_LOGICAL, VALUE_NONE, tmp, VALUE_NONE);
        op = OPERATOR_LOGICAL;
      }
      brop = (OPERATOR_LOGICAL == op)
        ? PIC_OPCODE_BTFSS
        : PIC_OPCODE_BTFSC;
      flag = "_z";
    }
    if (CMD_BRANCHCOND_FALSE == cmd_brcond_get(cmd)) {
      brop = pic_branch_cond_brop_invert(brop);
    }
    pic_branch_cond_append(pf, pop, lbl, brop, (flag) ? VALUE_NONE : tmp,
        flag);
    if ((tmp != dst) && (tmp != val1)) {
      pic_var_temp_release(pf, tmp);
    }
  }
}


/*
 * NAME
 *   pic_isr_cleanup
 *
 * DESCRIPTION
 *   handle command type CMD_TYPE_ISR_CLEANUP
 *
 * PARAMETERS
 *   pf  : pfile
 *   cmd : command
 *
 * RETURN
 *   none
 *
 * NOTES
 */
void pic_isr_cleanup(pfile_t *pf)
{
  label_t lbl;

  lbl = pfile_isr_entry_get(pf);
  if (lbl) {
    pic_var_isr_t isr_vars;

    label_release(lbl);

    (void) pic_var_isr_get(pf, BOOLEAN_TRUE, &isr_vars);
    if (!pfile_flag_test(pf, PFILE_FLAG_MISC_INTERRUPT_FAST)) {
      pic_var_isr_exit(pf);
    }
    pic_instr_default_flag_set(pf, PIC_CODE_FLAG_NO_OPTIMIZE);
    if (pic_is_14bit_hybrid(pf)) {
      (void) pic_instr_append(pf, PIC_OPCODE_RETFIE);
    } else if (pic_is_16bit(pf)) {
      (void) pic_instr_append_w_kn(pf, PIC_OPCODE_RETFIE, 1);
    } else {
      (void) pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, isr_vars.pclath, 0, 
        PIC_OPDST_W);
      (void) pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_pclath");
      (void) pic_instr_append_f_d(pf, PIC_OPCODE_SWAPF, isr_vars.status, 0, 
        PIC_OPDST_W);
      (void) pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_status");
      (void) pic_instr_append_f_d(pf, PIC_OPCODE_SWAPF, isr_vars.w, 0, 
        PIC_OPDST_F);
      (void) pic_instr_append_f_d(pf, PIC_OPCODE_SWAPF, isr_vars.w, 0, 
        PIC_OPDST_W);
      (void) pic_instr_append(pf, PIC_OPCODE_RETFIE);
    }
    pic_instr_default_flag_clr(pf, PIC_CODE_FLAG_NO_OPTIMIZE);
    pic_var_isr_release(pf, &isr_vars);
  }
}

/*
 * NAME
 *   pic_end
 *
 * DESCRIPTION
 *   handle commands of type CMD_TYPE_END
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 *   this simply loops to a sleep instruction
 */
void pic_end(pfile_t *pf)
{
  if (!pfile_flag_test(pf, PFILE_FLAG_DEBUG_EMULATOR)) {
    label_t lbl;

    lbl = pfile_label_alloc(pf, 0);
    if (lbl) {
      (void) pic_instr_append_label(pf, lbl);
      (void) pic_instr_append(pf, PIC_OPCODE_SLEEP);
      (void) pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
      label_release(lbl);
    }
  }
}

/*
 * NAME
 *   pic_branch_bittest_out
 *
 * DESCRIPTION
 *   output a bittest for a branch
 *
 * PARAMETERS
 *   pf   :
 *   val1 : value to test
 *   val2 : bit #
 *
 * RETURN
 *   none
 *
 * NOTES
 *   this is similar to pic_bittest() but that cannot be used because
 *   it always assumes btfsc, whereas we need either btfsc or btfss
 *   here
 */
void pic_brtest_out(pfile_t *pf, value_t val1, value_t val2,
    cmd_branchcond_t cond)
{
  variable_const_t n;
  pic_opcode_t     pop;

  pop = (CMD_BRANCHCOND_TRUE == cond) ? PIC_OPCODE_BTFSC : PIC_OPCODE_BTFSS;

  n = value_const_get(val2);
  if (n >= 8U * value_sz_get(val1)) {
    if (pfile_flag_test(pf, PFILE_FLAG_WARN_RANGE)
        && pfile_flag_test(pf, PFILE_FLAG_WARN_BACKEND)) {
      pfile_log(pf, PFILE_LOG_WARN, PFILE_MSG_CONSTANT_RANGE);
    }
    /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
    (void) pic_instr_append_reg_flag(pf, PIC_OPCODE_BSF, "_status", "_z");
    (void) pic_instr_append_reg_flag(pf, pop, "_status", "_z");
  } else {
    if ((n / 8) || !value_name_get(val1)) {
      (void) pic_instr_append_f_bn(pf, pop, val1, (size_t) n / 8, n & 7);
    } else {
      (void) pic_instr_append_f_b(pf, pop, val1, (size_t) n / 8, val2);
    }
  }
}

unsigned pic_proc_frame_sz_get(pfile_block_t *blk)
{
  unsigned   frame_sz;
  unsigned   subframe_sz_max;
  variable_t var;

  for (frame_sz = 0, var = pfile_block_variable_list_head(blk);
       var;
       var = variable_link_get(var)) {
    if (variable_is_auto(var)) {
      frame_sz += variable_sz_get(var);
    }
  }
  subframe_sz_max = 0;
  for (blk = pfile_block_child_get(blk);
       blk;
       blk = pfile_block_sibbling_get(blk)) {
    unsigned subframe_sz;

    subframe_sz = pic_proc_frame_sz_get(blk);
    if (subframe_sz > subframe_sz_max) {
      subframe_sz_max = subframe_sz;
    }
  }
  return frame_sz + subframe_sz_max;
}

static value_t pic_proc_rval_get(pfile_t *pf, pfile_proc_t *proc)
{
  value_t rval;

  rval = VALUE_NONE;
  if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_REENTRANT)) {
    const char *proc_name;
    size_t      sz;
    char       *rname;

    proc_name = label_name_get(pfile_proc_label_get(proc));
    sz        = 1 + strlen(proc_name);
    rname = MALLOC(2 + sz);
    if (!rname) {
      pfile_log_syserr(pf, ENOMEM);
    } else {
      rname[0] = '_';
      rname[1] = 'r';
      memcpy(rname + 2, proc_name, sz);
      rval = pic_value_find_or_alloc(pf, rname, VARIABLE_DEF_TYPE_INTEGER, 1);
      variable_flag_set(value_variable_get(rval), VARIABLE_FLAG_AUTO);
      FREE(rname);
    }
  }
  return rval;
}


/* pic_proc_enter processing:
 * for re-entrant functions:
 *    increment _r{procname}
 *    if _r{procname} > 1
 *       push all local variables onto the stack
 * for re-entrant or indirect functions
 *    copy parameters from the system parameter block into
 *    the local paramter area
 */
void pic_proc_enter(pfile_t *pf, pfile_proc_t *proc)
{
  size_t  param_in_w;
  size_t  return_in_w;

  param_in_w  = pic_proc_w_param_get(pf, proc, VARIABLE_DEF_FLAG_IN);
  return_in_w = pic_proc_w_param_get(pf, proc, VARIABLE_DEF_FLAG_OUT);

  if (0 != return_in_w) {
    /* create the temporary variable for the return value */
    value_t        tmp;
    variable_def_t def;
    value_t        val;

    val = pfile_proc_param_get(proc, 0);
    if (!value_variable_get(val)) {
      assert(!value_variable_get(val));

      def = value_def_get(val);
      tmp = pic_var_temp_get_def(pf, value_def_get(val));
      value_variable_set(val, value_variable_get(tmp));
      pic_var_temp_release(pf, tmp);
      value_def_set(val, def);
    }
  }

  (void) pic_instr_append_label(pf, pfile_proc_label_get(proc));

  if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_REENTRANT)
    || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INDIRECT)) {
    value_t   *tvals;
    size_t     ct;

    /* re-entrant and indirect functions pass all parameters into
     * the global parameter area */
    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_REENTRANT)
        && pfile_proc_frame_sz_get(proc)) {
      value_t         rval;
      label_t         lbl_skip;
      label_t         lbl_exec;
      value_t         frame;
#if 0
      value_t         memcpy_params[2];
      label_t         lbl_stkpush;
      variable_base_t base;
#endif

      rval = pic_proc_rval_get(pf, proc);
      frame = value_alloc(pfile_proc_frame_get(proc));
      /* if no one else is in this proc, skip the push */
      (void) pic_instr_append_f_d(pf, PIC_OPCODE_INCF, rval, 0, PIC_OPDST_F);
      (void) pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, rval, 0, PIC_OPDST_W);
      lbl_exec = pfile_label_alloc(pf, 0);
      lbl_skip = pfile_label_alloc(pf, 0);
      (void) pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_exec);
      (void) pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_skip);
      (void) pic_instr_append_label(pf, lbl_exec);
      label_release(lbl_exec);
      /* push the local variables onto the stack */
      /* this should probably be based on size -- anything greater than 8
       * should probably use the stkpush call
       */
#if 0
      pic_memcpy_params_get(pf, memcpy_params);
      base = value_base_get(frame);
      pic_instr_append_w_k(pf, PIC_OPCODE_MOVLW, frame);
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, memcpy_params[0], 0);
      if (base >> 8) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, base >> 8);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, memcpy_params[0], 1);
      } else {
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, memcpy_params[0], 1);
      }
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW,
          pfile_proc_frame_sz_get(proc));
      lbl_stkpush = pic_label_find(pf, PIC_LABEL_STKPUSH, BOOLEAN_TRUE);
      pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl_stkpush);
      label_release(lbl_stkpush);
      pic_memcpy_params_release(pf, memcpy_params);
#else
      if (frame) {
        size_t  ii;
        value_t stkptr;
        value_t fsr;
        value_t ind;

        stkptr = pic_var_stkptr_get(pf);
        fsr    = pic_fsr_get(pf);
        ind    = pic_indirect_get(pf, PFILE_LOG_ERR, 0);
        /*
         * pic_fsr_setup could be used in both cases, but requires
         * extra code on 12/14 bit controllers, so I'm doing it differently
         * here
         */
        if (pic_is_16bit(pf) || pic_is_14bit_hybrid(pf)) {
          pic_fsr_setup(pf, stkptr);
        } else {
          pic_stvar_fsr_mark(pf);
          (void) pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, stkptr, 0, 
            PIC_OPDST_W);
          (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, fsr, 0);
          (void) pic_instr_append(pf, 
            (pic_stk_base < 256) ? PIC_OPCODE_IRP_CLR : PIC_OPCODE_IRP_SET);
        }
        if (1 == pfile_proc_frame_sz_get(proc)) {
          (void) pic_instr_append_f_d(pf, PIC_OPCODE_DECF, stkptr, 0, 
            PIC_OPDST_F);
        } else {
          (void) pic_instr_append_w_kn(pf, PIC_OPCODE_SUBLW, 
            pfile_proc_frame_sz_get(proc));
          (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, stkptr, 0);
        }
        for (ii = 0; ii < pfile_proc_frame_sz_get(proc); ii++) {
          (void) pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
          (void) pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, frame, ii, 
            PIC_OPDST_W);
          (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, ind, 0);
        }
        value_release(ind);
        value_release(fsr);
        pic_var_stkptr_release(pf, stkptr);
      }
#endif
      (void) pic_instr_append_label(pf, lbl_skip);
      label_release(lbl_skip);
      value_release(frame);
      value_release(rval);
    }
    /* copy the values from temporary to local */
    ct = pfile_proc_param_ct_get(proc);
    tvals = MALLOC(sizeof(*tvals) * ct);
    if (!tvals) {
      pfile_log_syserr(pf, ENOMEM);
    } else {
      size_t ii;

      for (ii = 0; ii < ct; ii++) {
        value_t val;

        val = pfile_proc_param_get(proc, ii);
        if (!value_is_const(val)
          && value_dflag_test(val, VARIABLE_DEF_FLAG_IN)) {
          tvals[ii] = pic_var_temp_get_def(pf, value_def_get(val));
          pic_op(pf, OPERATOR_ASSIGN, val, tvals[ii], VALUE_NONE);
        } else {
          tvals[ii] = VALUE_NONE;
        }
      }
      if (PIC_PROC_W_PARAM_NONE != param_in_w) {
        pic_value_move_to_w(pf, tvals[param_in_w]);
      }
      for (ii = ct; ii; ii--) {
        if (tvals[ii-1]) {
          pic_var_temp_release(pf, tvals[ii-1]);
        }
      }
      FREE(tvals);
    }
  }
  if (PIC_PROC_W_PARAM_NONE != param_in_w) {
    value_t val;

    val = pfile_proc_param_get(proc, param_in_w);
    if (value_is_auto(val) || value_is_volatile(val)) {
      pic_op(pf, OPERATOR_ASSIGN, val, VALUE_NONE, VALUE_NONE);
    } else {
      /*
       * if the parameter shares space with an auto or volatile variable
       * go ahead & make the assignment
       */
      variable_t var;

      var = value_variable_get(val);
#if 0
      while (var && !variable_is_auto(var) && !variable_is_volatile(var)) {
        var = variable_master_get(var);
      }
#endif
      if (var) {
        /* do the assignment */
        value_t tmp;

        tmp = value_alloc(var);
        pic_op(pf, OPERATOR_ASSIGN, tmp, VALUE_NONE, VALUE_NONE);
        value_release(tmp);
      }
    }
  }
}

/* pic_proc_leave processing:
 * for re-entrant or indirect functions
 *    copy OUT parameters from the local parameter block into
 *    the system paramter block
 * for re-entrant functions:
 *    decrement _r{procname}
 *    if _r{procname} > 0
 *       pop all local variables from the stack
 */
void pic_proc_leave(pfile_t *pf, pfile_proc_t *proc)
{
  if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_TASK)) {
    label_t lbl;

    lbl = pic_label_find(pf, PIC_LABEL_TASK_SUICIDE, BOOLEAN_TRUE);
    (void) pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    label_release(lbl);
  } else {
    size_t return_in_w;

    return_in_w = pic_proc_w_param_get(pf, proc, VARIABLE_DEF_FLAG_OUT);

    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INDIRECT)
      || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_REENTRANT)) {
      /* copy OUT parameters to the system parameter block */
      value_t *tval;
      size_t   ct;

      ct = pfile_proc_param_ct_get(proc);
      tval = MALLOC(sizeof(*tval) * ct);
      if (!tval) {
        pfile_log_syserr(pf, ENOMEM);
      } else {
        size_t ii;

        for (ii = 0; ii < ct; ii++) {
          value_t val;

          val = pfile_proc_param_get(proc, ii);
          if (value_dflag_test(val, VARIABLE_DEF_FLAG_OUT)
            && (ii != return_in_w)
            && ((0 == ii)
              || (value_is_volatile(val)
                || value_is_auto(val)))) {
            tval[ii] = pic_var_temp_get_def(pf, value_def_get(val));
            if (0 != ii) {
              pic_op(pf, OPERATOR_ASSIGN, tval[ii], val, VALUE_NONE);
            }
          } else {
            tval[ii] = VALUE_NONE;
          }
        }
        for (ii = ct; ii; ii--) {
          if (tval[ii-1]) {
            pic_var_temp_release(pf, tval[ii-1]);
          }
        }
        FREE(tval);
      }
    }
    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_REENTRANT)
        && pfile_proc_frame_sz_get(proc)) {
      value_t         rval;
      value_t         frame;
      label_t         lbl_exec;
      label_t         lbl_skip;
#if 0
      value_t         memcpy_params[2];
      label_t         lbl_stkpop;
      variable_base_t vbase_hi;
#endif

      rval = pic_proc_rval_get(pf, proc);
      lbl_skip = pfile_label_alloc(pf, 0);
      lbl_exec   = pfile_label_alloc(pf, 0);
      (void) pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, rval, 0, PIC_OPDST_F);
      (void) pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_exec);
      (void) pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_skip);
      (void) pic_instr_append_label(pf, lbl_exec);
      label_release(lbl_exec);
      /* do stuff */
      frame = value_alloc(pfile_proc_frame_get(proc));
#if 0
      pic_memcpy_params_get(pf, memcpy_params);
      pic_instr_append_w_k(pf, PIC_OPCODE_MOVLW, val);
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, memcpy_params[1], 0);
      vbase_hi = variable_base_get(var, 0) >> 8;
      if (vbase_hi) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, vbase_hi);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, memcpy_params[1], 1);
      } else {
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, memcpy_params[1], 1);
      }
      lbl_stkpop = pic_label_find(pf, PIC_LABEL_STKPOP, BOOLEAN_TRUE);
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW,
          pfile_proc_frame_sz_get(proc));
      pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl_stkpop);
      label_release(lbl_stkpop);
      pic_memcpy_params_release(pf, memcpy_params);
#else
      if (frame) {
        size_t  ii;
        value_t stkptr;
        value_t fsr;
        value_t ind;

        stkptr = pic_var_stkptr_get(pf);
        fsr    = pic_fsr_get(pf);
        ind    = pic_indirect_get(pf, PFILE_LOG_ERR, 0);
        if (pic_is_16bit(pf) || pic_is_14bit_hybrid(pf)) {
          pic_fsr_setup(pf, stkptr);
        } else {
          pic_stvar_fsr_mark(pf);
          (void) pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, stkptr, 0, 
            PIC_OPDST_W);
          (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, fsr, 0);
          (void) pic_instr_append(pf, 
            (pic_stk_base < 256) ? PIC_OPCODE_IRP_CLR : PIC_OPCODE_IRP_SET);
        }
        for (ii = pfile_proc_frame_sz_get(proc); ii; ii--) {
          (void) pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ind, 0, PIC_OPDST_W);
          (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, frame, ii - 1);
          if (ii > 1) {
            (void) pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, 
              PIC_OPDST_F);
          }
        }
        (void) pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, PIC_OPDST_W);
        (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, stkptr, 0);
        value_release(ind);
        value_release(fsr);
        pic_var_stkptr_release(pf, stkptr);
      }
#endif
      (void) pic_instr_append_label(pf, lbl_skip);
      label_release(lbl_skip);
      value_release(frame);
      value_release(rval);
    }
    if ((PIC_PROC_W_PARAM_NONE != return_in_w)
      && (0 != return_in_w)) {
      value_t retval;

      retval = pfile_proc_param_get(proc, return_in_w);
      if (value_is_const(retval)) {
        (void) pic_instr_append_w_k(pf, PIC_OPCODE_MOVLW,
            pfile_proc_param_get(proc, return_in_w));
      } else if (retval) {
        (void) pic_instr_append_f_d(pf, PIC_OPCODE_MOVF,
            pfile_proc_param_get(proc, return_in_w), 0, PIC_OPDST_W);
      }
    }
    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_NOSTACK)) {
      value_t rval;
      size_t  ii;

      /* this would have been allocated on enter */
      rval = value_alloc(pfile_proc_ret_ptr_get(proc));
      for (ii = value_sz_get(rval); ii; ii--) {
        value_t     pcl;
        const char *pcl_name;

        (void) pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, rval, ii - 1, 
          PIC_OPDST_W);
        pcl_name = "{error}";
        switch (ii - 1) {
          case 2: pcl_name = "_pclatu"; break;
          case 1: pcl_name = "_pclath"; break;
          case 0: pcl_name = "_pcl";    break;
        }
        pcl = pfile_value_find(pf, PFILE_LOG_ERR, pcl_name);
        (void) pic_instr_append_f(pf, PIC_OPCODE_MOVWF, pcl, 0);
        value_release(pcl);
      }
      value_release(rval);
    } else {
      (void) pic_instr_append(pf, PIC_OPCODE_RETURN);
    }
  }
}

static void pic_cmd_to_asm(pfile_t *pf, cmd_t cmd)
{
  pic_code_t   code;
  pic_opcode_t op;
  label_t      lbl;
  value_t      val;
  value_t      n;
  unsigned     page_size;

  op        = cmd_asm_op_get(cmd);
  lbl       = cmd_asm_lbl_get(cmd);
  val       = cmd_asm_val_get(cmd);
  n         = cmd_asm_n_get(cmd);
  page_size = pic_target_page_size_get(pf);

  switch (op) {
    case PIC_OPCODE_DATALO_CLR:
    case PIC_OPCODE_DATALO_SET:
      op = pic_value_datalo_get(pf, val);
      break;
    case PIC_OPCODE_DATAHI_CLR:
    case PIC_OPCODE_DATAHI_SET:
      op = pic_value_datahi_get(pf, val);
      break;
    case PIC_OPCODE_BRANCHLO_CLR:
    case PIC_OPCODE_BRANCHLO_SET:
      op = (label_pc_get(lbl) & page_size)
        ? PIC_OPCODE_BRANCHLO_SET
        : PIC_OPCODE_BRANCHLO_CLR;
      break;
    case PIC_OPCODE_BRANCHHI_CLR:
    case PIC_OPCODE_BRANCHHI_SET:
      op = (label_pc_get(lbl) & (2 * page_size))
        ? PIC_OPCODE_BRANCHHI_SET
        : PIC_OPCODE_BRANCHHI_CLR;
      break;
    case PIC_OPCODE_MOVLB:
      if (!value_is_const(val)) {
        n = pfile_constant_get(pf, 
                variable_base_get(value_variable_get(val), 0)
                / pic_target_bank_size_get(pf),
                0);
        val = VALUE_NONE;
      }
      break;
    default:
      break;
  }
  if (cmd_asm_flag_test(cmd, PIC_CODE_FLAG_NO_OPTIMIZE)) {
    pic_instr_default_flag_set(pf, PIC_CODE_FLAG_NO_OPTIMIZE);
  }
  code = pic_instr_alloc(pf, LABEL_NONE, op);
  pic_code_cmd_set(code, cmd);
  pic_code_flag_set_all(code, cmd_asm_flag_get_all(cmd));
  pic_code_brdst_set(code, lbl);
  pic_code_dst_set(code, cmd_asm_opdst_get(cmd));
  pic_code_literal_set(code, n);
  pic_code_value_set(code, val);
  pic_code_ofs_set(code, cmd_asm_valofs_get(cmd));
  if (cmd_asm_flag_test(cmd, PIC_CODE_FLAG_NO_OPTIMIZE)) {
    pic_instr_default_flag_clr(pf, PIC_CODE_FLAG_NO_OPTIMIZE);
  }
}


/*
 * NAME
 *   pic_cmd_out
 *
 * DESCRIPTION
 *   convert a cmd_t to one or more PIC instructions
 *
 * PARAMETERS
 *   pf  : pfile
 *   cmd : cmd to convert
 *
 * RETURN
 *   none
 *
 * NOTES
 */
void pic_cmd_out(pfile_t *pf, cmd_t *cmd_ptr)
{
  cmd_t      cmd_nxt;
  cmd_t      cmd;
  value_t    val;
  pic_code_t code_first;
  pfile_pos_t pos;

  code_first = pic_code_list_tail_get(pf);
  cmd = *cmd_ptr;
  pic_in_isr_flag = cmd_flag_test(cmd, CMD_FLAG_INTERRUPT);

  pos.line = cmd_line_get(cmd);
  pos.src  = cmd_source_get(cmd);
  pfile_statement_start_set(pf, &pos);
  /* this is probably a hack, but it's also an easy way to get the
   * optimization type into the pic generation code without having
   * to modify every single function! */
  if (cmd_flag_test(cmd, CMD_FLAG_SPEED)) {
    pfile_flag_set(pf, PFILE_FLAG_CMD_SPEED);
  } else {
    pfile_flag_clr(pf, PFILE_FLAG_CMD_SPEED);
  }

  if ((CMD_TYPE_PROC_ENTER != cmd_type_get(cmd)) && cmd_label_get(cmd)) {
    (void) pic_instr_append_label(pf, cmd_label_get(cmd));
  }
  cmd_nxt = cmd_link_get(cmd);
  val = cmd_opval2_get(cmd);
  if (!val) {
    val = cmd_opval1_get(cmd);
  }
  if (value_is_const(val)
      && (((OPERATOR_ANDB == cmd_optype_get(cmd))
          && !(value_const_get(val) & (value_const_get(val) - 1))))
      && (CMD_TYPE_BRANCH == cmd_type_get(cmd_nxt))
      && (0 == memcmp(value_name_get(cmd_opdst_get(cmd)), "_t", 2))
      && (value_is_same(cmd_opdst_get(cmd), cmd_brval_get(cmd_nxt)))) {
    /* this is a special case:
     *   bittst [tmp], [x], [constant bit]
     *   branch [true|false] [tmp] [dst]
     *   ..or..
     *   andb [tmp], [x], [constant bit]
     *   branch [true|false] [tmp] [dst]
     *
     * since andb x,0x80  --> bittst x,7
     */
    variable_const_t n;
    variable_const_t bit;

    n = value_const_get(val);
    for (bit = 0;
         0 != (n >>= 1);
         bit++)
      ; /* null body */
    val = pfile_constant_get(pf, bit, VARIABLE_DEF_NONE);
    if (val) {
      pic_last_values_reset();
      pic_brtest_out(pf, cmd_opval1_get(cmd), val,
          cmd_brcond_get(cmd_nxt));
      pic_branch(pf, cmd_brtype_get(cmd_nxt), CMD_BRANCHCOND_NONE,
          cmd_brdst_get(cmd_nxt), 0, 0, 0);
      value_release(val);
    }
    *cmd_ptr = cmd_nxt;
    cmd = cmd_nxt;
  } else if ((CMD_TYPE_OPERATOR == cmd_type_get(cmd))
    && (operator_is_relation(cmd_optype_get(cmd))
      || (OPERATOR_LOGICAL == cmd_optype_get(cmd))
      || (OPERATOR_NOTL == cmd_optype_get(cmd))
      || (OPERATOR_CMPB == cmd_optype_get(cmd)))
    && (CMD_TYPE_BRANCH == cmd_type_get(cmd_link_get(cmd)))
    && value_is_same(cmd_opdst_get(cmd), cmd_brval_get(cmd_link_get(cmd)))
    && (CMD_BRANCHCOND_NONE != cmd_brcond_get(cmd_link_get(cmd)))) {
    pic_last_values_reset();
    pic_branch_cond(pf, cmd);
    *cmd_ptr = cmd_nxt;
    cmd = cmd_nxt;
  } else {
    switch (cmd_type_get(cmd)) {
      case CMD_TYPE_ASM:
        pic_cmd_to_asm(pf, cmd);
        break;
      case CMD_TYPE_OPERATOR:
        pic_op(pf, cmd_optype_get(cmd), cmd_opdst_get(cmd),
            cmd_opval1_get(cmd), cmd_opval2_get(cmd));
        break;
      case CMD_TYPE_BRANCH:
        pic_last_values_reset();
        pic_branch(pf, cmd_brtype_get(cmd), cmd_brcond_get(cmd),
            cmd_brdst_get(cmd), cmd_brval_get(cmd), cmd_brproc_get(cmd),
            cmd_brproc_params_get(cmd));
        break;
      case CMD_TYPE_NOP:
        (void) pic_instr_append(pf, PIC_OPCODE_NOP);
        break;
      case CMD_TYPE_SLEEP:
        (void) pic_instr_append(pf, PIC_OPCODE_SLEEP);
        break;
      case CMD_TYPE_END:
        pic_end(pf);
        break;
      case CMD_TYPE_ISR_CLEANUP:
        pic_last_values_reset();
        pic_isr_cleanup(pf);
        break;
      case CMD_TYPE_PROC_ENTER:
        pic_last_values_reset();
        pic_proc_enter(pf, cmd_proc_get(cmd));
        break;
      case CMD_TYPE_PROC_LEAVE:
        pic_last_values_reset();
        pic_proc_leave(pf, cmd_proc_get(cmd));
        break;
      case CMD_TYPE_BLOCK_START:
      case CMD_TYPE_BLOCK_END:
      case CMD_TYPE_STATEMENT_END:
      case CMD_TYPE_LABEL:
      case CMD_TYPE_COMMENT:
      case CMD_TYPE_LOG:
        break;
      case CMD_TYPE_USEC_DELAY:
        pic_delay_create(pf, cmd_usec_delay_get(cmd));
        break;
      case CMD_TYPE_ASSERT:
        /* put in a dummy opcode */
        (void) pic_instr_append(pf, PIC_OPCODE_NOP);
        break;
    }
  }
  for (code_first = (code_first)
         ? pic_code_next_get(code_first) : pic_code_list_head_get(pf);
      code_first;
      code_first = pic_code_next_get(code_first)) {
    pic_code_cmd_set(code_first, cmd);
  }
}

/*
 * NAME
 *   pic_bitstate_changed
 *
 * DESCRIPTION
 *   determine if a bitstate has changed
 *
 * PARAMETERS
 *   old : original state
 *   new : new state
 *
 * RETURN
 *   1 : changed
 *   0 : no change
 *
 * NOTES
 *   a bit has changed if it's not the same as new and it's not
 *   indeterminte
 */

boolean_t pic_bitstate_changed(pic_bitstate_t old, pic_bitstate_t new)
{
  return ((old != new)
      && (PIC_BITSTATE_INDETERMINATE != old));
}


/*
 * NAME
 *   pic_code_label_find
 *
 * DESCRIPTION
 *   find a label in the code
 *
 * PARAMETERS
 *   pf   :
 *   lbl  : label to find
 *   ppcl : [out] holds result on success
 *
 * RETURN
 *   0      : no error
 *   ENOENT : label not found
 *
 * NOTES
 */
pic_code_t pic_code_label_find(pfile_t *pf, const label_t lbl)
{
  pic_code_t code;

  code = label_code_get(lbl);
  if (PIC_CODE_NONE == code) {
    /*
     * this is a direct user jump, try to find the location 
     * note: I cannot simply cache the result in the label
     * as it might move during various optimizations
     */
    for (code = pic_code_list_head_get(pf);
         code && (pic_code_pc_get(code) < label_pc_get(lbl));
         code = pic_code_next_get(code))
      ; /* empty body */
    if (pic_code_pc_get(code) != label_pc_get(lbl)) {
      code = PIC_CODE_NONE;
    }
  }
  return code;
}

/*
 * NAME
 *   pic_cmd_dump
 *
 * DESCRIPTION
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 */
static int pic_tag_dump(pfile_t *pf, pfile_write_t where,
  const char *pre, const char *name, unsigned tag_n,
  COD_symbol_type_t type, unsigned value, boolean_t COD_add)
{
  const char *fmt;
  int         sz;

  fmt = tag_n ? "%s__%s_%u" : "%s%s";
  sz = pfile_write(pf, where, fmt, pre, name, tag_n);
  if (COD_add && (-1 != sz)) {
    COD_directory_t *dir;
    char            *lbl;

    if (0 == sz) {
      /*
       *  `where' isn't open, so make an appropriate guess
       *  12 = 3 underscores + 8 digits for n, which would be
       *  truly odd
       */
      sz = strlen(pre) + strlen(name) + 12;
    }
    dir = pfile_COD_dir_get(pf);
    lbl = MALLOC(1 + sz);
    if (lbl) {
      sprintf(lbl, fmt, pre, name, tag_n);
      COD_symbol_entry_add(dir, (uchar *) lbl, type, (ushort) value);
      FREE(lbl);
    }
  }
  return sz;
}

static int pic_variable_tag_dump(pfile_t *pf, pfile_write_t where,
  variable_t var, boolean_t COD_add)
{
  return pic_tag_dump(pf, where, "v_", variable_name_get(var),
    variable_tag_n_get(var),
    variable_is_const(var)
    ? COD_SYMBOL_TYPE_CONSTANT : COD_SYMBOL_TYPE_ADDRESS,
    (unsigned) (variable_is_const(var)
      ? variable_const_get(var, variable_def_get(var), 0)
      : variable_base_get(var, 0)), COD_add);
}

static int pic_label_tag_dump(pfile_t *pf, pfile_write_t where,
  label_t lbl, boolean_t COD_add)
{
  return pic_tag_dump(pf, where, "l_", label_name_get(lbl),
    label_tag_n_get(lbl),
    COD_SYMBOL_TYPE_ADDRESS, label_pc_get(lbl), COD_add);
}

static void pic_bitstate_dump(pfile_t *pf, pfile_write_t where,
    pic_bitstate_t st, char set, char clr)
{
  char ch;

  ch = '!';
  switch (st) {
    case PIC_BITSTATE_UNKNOWN:       ch = '-'; break;
    case PIC_BITSTATE_SET:           ch = set; break;
    case PIC_BITSTATE_CLR:           ch = clr; break;
    case PIC_BITSTATE_INDETERMINATE: ch = '?'; break;
  }
  pfile_write(pf, where, "%c", ch);
}

static void pic_variable_name_write(pfile_t *pf, pfile_write_t where,
    variable_t var)
{
  const char *fmt;

  fmt = (variable_tag_n_get(var)) ? "%s%u" : "%s";
  pfile_write(pf, where, fmt, variable_name_get(var),
      variable_tag_n_get(var));
}

static void pic_obj_write_byte(pfile_t *pf, pic_pc_t pc, unsigned char data)
{
  pfile_write_hex(pf, pc, data & 0xff);
  if (pc < 0x10000UL) {
    COD_code_entry_add(pfile_COD_dir_get(pf), (ushort) pc, data);
  }
}

static void pic_obj_write(pfile_t *pf, const pic_code_t code,
    uchar smod, unsigned pc, pic_code_to_pcode_t *pcode)
{
  size_t ii;

  cmd_t cmd;
  uchar  file_no;
  ushort line_no;

  cmd = pic_code_cmd_get(code);
  file_no = pfile_source_file_no_get(cmd_source_get(cmd));
  line_no = cmd_line_get(cmd);

  if ((uchar) -1 == file_no) {
    file_no = 0;
  }
  COD_line_symbol_entry_add(pfile_COD_dir_get(pf),
      file_no,
      smod,
      line_no,
      (pic_is_16bit(pf)) ? pc : pc / 2);
  if (pcode) {
    for (ii = 0; ii < pcode->ct; ii++) {
      pic_obj_write_byte(pf, 2 * ii + pc,
          pcode->code[ii] & 0xff);
      pic_obj_write_byte(pf, 2 * ii + pc + 1,
          (pcode->code[ii] >> 8) & 0xff);
    }
  }
}

static boolean_t pic_opcode_is_literal(pic_opcode_t op)
{
  boolean_t rc;

  rc = BOOLEAN_FALSE;
  switch (op)
  {
    case PIC_OPCODE_ADDLW:
    case PIC_OPCODE_ANDLW:
    case PIC_OPCODE_IORLW:
    case PIC_OPCODE_MOVLW:
    case PIC_OPCODE_MULLW:
    case PIC_OPCODE_RETLW:
    case PIC_OPCODE_SUBLW:
    case PIC_OPCODE_XORLW:
      rc = BOOLEAN_TRUE;
      break;
    case PIC_OPCODE_ORG:
    case PIC_OPCODE_END:
    case PIC_OPCODE_NONE:
    case PIC_OPCODE_TRIS:
    case PIC_OPCODE_ADDWF:
    case PIC_OPCODE_ADDWFc:
    case PIC_OPCODE_ANDWF:
    case PIC_OPCODE_COMF:
    case PIC_OPCODE_DECF:
    case PIC_OPCODE_DCFSNZ:
    case PIC_OPCODE_DECFSZ:
    case PIC_OPCODE_INCF:
    case PIC_OPCODE_INCFSZ:
    case PIC_OPCODE_INFSNZ:
    case PIC_OPCODE_IORWF:
    case PIC_OPCODE_MOVF:
    case PIC_OPCODE_RLF:
    case PIC_OPCODE_RLCF:
    case PIC_OPCODE_RLNCF:
    case PIC_OPCODE_RRF:
    case PIC_OPCODE_RRCF:
    case PIC_OPCODE_RRNCF:
    case PIC_OPCODE_SUBFWB:
    case PIC_OPCODE_SUBWF:
    case PIC_OPCODE_SUBWFB:
    case PIC_OPCODE_SWAPF:
    case PIC_OPCODE_XORWF:
    case PIC_OPCODE_CLRF:
    case PIC_OPCODE_CPFSEQ:
    case PIC_OPCODE_CPFSGT:
    case PIC_OPCODE_CPFSLT:
    case PIC_OPCODE_MOVWF:
    case PIC_OPCODE_MULWF:
    case PIC_OPCODE_NEGF:
    case PIC_OPCODE_SETF:
    case PIC_OPCODE_TSTFSZ:
    case PIC_OPCODE_BCF:
    case PIC_OPCODE_BSF:
    case PIC_OPCODE_BTFSC:
    case PIC_OPCODE_BTFSS:
    case PIC_OPCODE_BTG:
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
    case PIC_OPCODE_CALL:
    case PIC_OPCODE_GOTO:
    case PIC_OPCODE_CLRW:
    case PIC_OPCODE_CLRWDT:
    case PIC_OPCODE_DAW:
    case PIC_OPCODE_NOP:
    case PIC_OPCODE_OPTION:
    case PIC_OPCODE_POP:
    case PIC_OPCODE_PUSH:
    case PIC_OPCODE_RESET:
    case PIC_OPCODE_RETURN:
    case PIC_OPCODE_RETFIE:
    case PIC_OPCODE_SLEEP:
    case PIC_OPCODE_LFSR:
    case PIC_OPCODE_MOVFF:
    case PIC_OPCODE_MOVLB:
    case PIC_OPCODE_MOVLP:
    case PIC_OPCODE_MOVLP_NOP:
    case PIC_OPCODE_TBLRD:
    case PIC_OPCODE_TBLWT:
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
    case PIC_OPCODE_DB:
      break;
  }
  return rc;
}

static size_t pic_add_access_or_banked(pfile_t *pf, pic_code_t code)
{
  size_t sz;

  sz = 0;
  if (pic_is_16bit(pf)
    && pic_code_value_get(code)
    && !pic_opcode_is_literal(pic_code_op_get(code))
    && (PIC_OPCODE_LFSR != pic_code_op_get(code))) {
    sz = pfile_write(pf, pfile_write_asm, ",%s",
      value_is_shared(pic_code_value_get(code))
      ? "v__access"
      : "v__banked");
  }
  return sz;
}

void pic_code_dump(pfile_t *pf, const pic_code_t code)
{
  const char         *comma;
  int                 sz;
  label_t             lbl;
  boolean_t           need_cr;
  pic_code_to_pcode_t pcode;
  boolean_t           in_comment;

  in_comment = BOOLEAN_FALSE;
  if (PIC_OPCODE_DB == pic_code_op_get(code)) {
    const uchar *data;
    size_t       data_sz;
    size_t       ii;
    cmd_t        cmd;
    pic_pc_t     pc;

    cmd     = pic_code_cmd_get(code);
    data_sz = cmd_asm_data_sz_get(cmd);
    data    = cmd_asm_data_get(cmd);
    if (!data_sz) {
      data_sz = pic_code_data_sz_get(code);
      data    = pic_code_data_get(code);
    }

    pic_obj_write(pf, code, 
      SMOD_FLAG_SOURCE_LINE | SMOD_FLAG_DEFINITION,
      pic_code_pc_get(code), 0);
    if (pic_is_16bit(pf)) {
      for (ii = 0, pc = pic_code_pc_get(code);
           ii < data_sz;
           ii ++, pc++) {
        pic_obj_write_byte(pf, pc, data[ii]);
      }
      /* we always must write an even number of bytes! */
      if (ii & 0x0001) {
        pic_obj_write_byte(pf, pc, 0);
        pc++;
      }
    } else {
      for (ii = 0, pc = 2 * pic_code_pc_get(code);
           ii < data_sz;
           ii += 2, pc += 2) {
        pic_obj_write_byte(pf, pc, (ii + 1 < data_sz) ? data[ii + 1] : 0);
        pic_obj_write_byte(pf, pc + 1, data[ii]);
      }
    }
    pcode.ct = 0;
  } else {
    if (pic_code_to_pcode(pf, code, &pcode)) {
      pic_obj_write(pf, code, SMOD_FLAG_SOURCE_LINE,
        (pic_is_16bit(pf) ? 1 : 2) * pic_code_pc_get(code), &pcode);
    }
  }

#if 0
  {
    pfile_source_t *src;
    cmd_t           cmd;

    cmd = pic_code_cmd_get(code);
    src = cmd_source_get(cmd);

    pfile_write(pf, pfile_write_lst, "; code=0x%x at %s:%u (next=%x, (flags=%u)\n", code,
      pfile_source_name_get(src), pfile_source_line_get(src),
      (unsigned) pic_code_next_get(code), pic_code_flag_get_all(code));
  }
#endif

  lbl = pic_code_label_get(code);
  if (label_usage_get(lbl)) {
    sz = pic_label_tag_dump(pf, pfile_write_asm, lbl, BOOLEAN_TRUE);
    pic_last_values_reset();
    need_cr = BOOLEAN_TRUE;
  } else {
    sz = 0;
    need_cr = BOOLEAN_FALSE;
  }
  if ((PIC_OPCODE_NONE != pic_code_op_get(code))
    && (pfile_flag_test(pf, PFILE_FLAG_DEBUG_COMPILER)
      || ((PIC_OPCODE_BRANCHLO_NOP != pic_code_op_get(code))
        && (PIC_OPCODE_BRANCHHI_NOP != pic_code_op_get(code))))) {
    need_cr = BOOLEAN_TRUE;
    sz += pfile_write(pf, pfile_write_asm,
        "%*s%-" STRINGIZE(PIC_OPCODE_COLUMN_SZ) "s ",
        (sz < (PIC_LABEL_COLUMN_SZ - 1))
        ? (PIC_LABEL_COLUMN_SZ - 1)- sz : 1, " ",
        pic_opcode_str(pic_code_op_get(code)));
    if (PIC_OPCODE_DB == pic_code_op_get(code)) {
      const uchar *data;
      size_t       data_sz;
      cmd_t        cmd;
      size_t       ii;

      cmd     = pic_code_cmd_get(code);
      data_sz = cmd_asm_data_sz_get(cmd);
      data    = cmd_asm_data_get(cmd);
      if (!data_sz) {
        data_sz = pic_code_data_sz_get(code);
        data    = pic_code_data_get(code);
      }
      for (ii = 0; ii < data_sz; ii++) {
        if (ii && !(ii & 0x07)) {
          pfile_write(pf, pfile_write_asm,
            "\n%*s%-" STRINGIZE(PIC_OPCODE_COLUMN_SZ) "s ",
            (PIC_LABEL_COLUMN_SZ - 1), " ",
            pic_opcode_str(pic_code_op_get(code)));
        }
        pfile_write(pf, pfile_write_asm, "%s0x%02x",
          (ii & 0x07) ? "," : "", data[ii]);
      }
      if (ii & 0x0001) {
        pfile_write(pf, pfile_write_asm, ",0x00");
      }
    } else {
      value_t val;
      size_t  ofs;

      comma = "";
      val = pic_code_value_get(code);
      ofs = value_const_get(value_baseofs_get(val))
           + pic_code_ofs_get(code);

      if (val && (PIC_OPCODE_LFSR != pic_code_op_get(code))) {
        variable_t master;
        variable_t var;
        variable_t show;
        boolean_t  is_indirect;

        if (value_is_indirect(val)) {
          /* this is an array, so use the _ind register */
          val = pic_indirect_get(pf, PFILE_LOG_ERR, 0);
          is_indirect = BOOLEAN_TRUE;
          assert(val);
        } else {
          value_lock(val);
          is_indirect = BOOLEAN_FALSE;
        }
        var    = value_variable_get(val);
        master = variable_master_get(var);

        if (variable_dflag_test(var, VARIABLE_DEF_FLAG_BIT) && master) {
          show = master;
          ofs += variable_bit_offset_get(var) / 8;
          ofs += variable_base_real_get(var, 0);
        } else {
          show = var;
        }
        if (!value_is_const(val) && variable_name_get(show)) {
          if (pic_code_flag_test(code, PIC_CODE_FLAG_LABEL_HIGH)) {
            sz += pfile_write(pf, pfile_write_asm, "HIGH ");
          } else if (pic_code_flag_test(code, PIC_CODE_FLAG_LABEL_UPPER)) {
            sz += pfile_write(pf, pfile_write_asm, "UPPER ");
          }
          sz += pic_variable_tag_dump(pf, pfile_write_asm, show, BOOLEAN_FALSE);
        } else {
          sz += pfile_write(pf, pfile_write_asm, "%u", value_const_get(val));
        }
        if (ofs && !is_indirect) {
          /* make sure we're not accessing data out of range! */
          /* assert(ofs < variable_sz_get(var)); */
          sz += pfile_write(pf, pfile_write_asm, "+%u", ofs);
        }
        if (value_dflag_test(val, VARIABLE_DEF_FLAG_BIT)) {
          if ((PIC_OPCODE_DATALO_SET != pic_code_op_get(code))
            && (PIC_OPCODE_DATALO_CLR != pic_code_op_get(code))
            && (PIC_OPCODE_DATAHI_SET != pic_code_op_get(code))
            && (PIC_OPCODE_DATAHI_CLR != pic_code_op_get(code))) {
            sz += pfile_write(pf, pfile_write_asm, ", %u",
                value_bit_offset_get(val) & 0x07);
          }
          sz += pic_add_access_or_banked(pf, code);
          sz += pfile_write(pf, pfile_write_asm, " ; ");
          pic_variable_name_write(pf, pfile_write_asm, var);
          in_comment = BOOLEAN_TRUE;
        }
        if (PIC_OPDST_NONE != pic_code_dst_get(code)) {
          sz += pfile_write(pf, pfile_write_asm, ",%c",
              (PIC_OPDST_W == pic_code_dst_get(code)) ? 'w' : 'f');
        }
        comma = ", ";
        value_release(val);
      }
      if (PIC_OPCODE_LFSR == pic_code_op_get(code)) {
        sz += pfile_write(pf, pfile_write_asm, "%u,",
          pic_code_fsr_n_get(code));
        sz += pic_variable_tag_dump(pf, pfile_write_asm, 
          value_variable_get(val), BOOLEAN_FALSE);
        if (ofs) {
          sz += pfile_write(pf, pfile_write_asm, "+%u", ofs);
        }
      }
      if (!in_comment && pic_code_literal_get(code)) {
        value_t lit;

        lit = pic_code_literal_get(code);
        if ((PIC_OPCODE_TBLRD == pic_code_op_get(code))
          || (PIC_OPCODE_TBLWT == pic_code_op_get(code))) {
          const char *tr;

          tr = "";
          switch ((pic_tblptr_change_t) value_const_get(lit)) {
            case PIC_TBLPTR_CHANGE_NONE:     tr = "*"; break;
            case PIC_TBLPTR_CHANGE_POST_INC: tr = "*+"; break;
            case PIC_TBLPTR_CHANGE_POST_DEC: tr = "*-"; break;
            case PIC_TBLPTR_CHANGE_PRE_INC:  tr = "+*"; break;
          }
          sz += pfile_write(pf, pfile_write_asm, "%s", tr);
        } else {
          if (value_name_get(lit)
              && !variable_is_array(value_variable_get(lit))) {
            sz += pfile_write(pf, pfile_write_asm, "%s", comma);
            sz += pic_variable_tag_dump(pf, pfile_write_asm,
              value_variable_get(lit), BOOLEAN_FALSE);
          } else if (PIC_OPCODE_ORG == pic_code_op_get(code)) {
            variable_const_t n;

            n = value_const_get(lit);
            sz += pfile_write(pf, pfile_write_asm, "%s%lu", comma, n);
#if 1
          } else if ((PIC_OPCODE_ORG != pic_code_op_get(code))
              && (PIC_OPCODE_LFSR != pic_code_op_get(code))) {
            sz += pfile_write(pf, pfile_write_asm, "%s%lu", comma,
                value_const_get(lit) & 0xff);
          } else {
            sz += pfile_write(pf, pfile_write_asm, "%s%lu", comma,
                value_const_get(lit));
#endif
          }
        }
      }
      if (!in_comment && pic_code_brdst_get(code)) {
        const char *modifier;

        modifier = "";
        switch (pic_code_ofs_get(code)) {
          case 0:                      break;
          case 1: modifier = "HIGH ";  break;
          case 2: modifier = "UPPER "; break;
        }
        sz += pfile_write(pf, pfile_write_asm, "%s", modifier);
        sz += pic_label_tag_dump(pf, pfile_write_asm,
          pic_code_brdst_get(code), BOOLEAN_FALSE);
      }
    }
    if (!in_comment) {
      sz += pic_add_access_or_banked(pf, code);
    }
    if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_COMPILER)) {
      size_t                 ii;
      if (sz < 60) {
        pfile_write(pf, pfile_write_asm, "%*s", 60 - sz, "");
      }
      /*pfile_write(pf, pfile_write_asm, " %p", code);*/
      pfile_write(pf, pfile_write_asm, "; %2u %c%c ",
          pic_code_depth_get(code),
          pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)
            ? '-' : 'O',
          pic_code_flag_test(code, PIC_CODE_FLAG_VISITED)
            ? 'V' : '-');
      if (pic_is_16bit(pf) || pic_is_14bit_hybrid(pf)) {
        uchar bsr;

        bsr = pic_code_bsr_get(code);
        if (PIC_BSR_UNKNOWN == bsr) {
          pfile_write(pf, pfile_write_asm, "bsr(UN)");
        } else if (PIC_BSR_INDETERMINATE == bsr) {
          pfile_write(pf, pfile_write_asm, "bsr(IN)");
        } else {
          pfile_write(pf, pfile_write_asm, "bsr(%02x)",
              pic_code_bsr_get(code));
        }
        if (pic_is_14bit_hybrid(pf)) {
          pic_pclath_state_t pclath;

          pic_code_pclath_get(code, &pclath);
          if (PIC_PCLATH_UNKNOWN == pclath.before) {
            pfile_write(pf, pfile_write_asm, " pclath(UN)");
          } else if (PIC_PCLATH_INDETERMINATE == pclath.before) {
            pfile_write(pf, pfile_write_asm, " pclath(IN)"); 
          } else {
            pfile_write(pf, pfile_write_asm, " pclath(%02x)", pclath.before);
          }
        }
      } else {
        pic_databits_state_t   dbits;
        pic_branchbits_state_t brbits;

        pic_code_databits_get(code, &dbits);
        pic_code_branchbits_get(code, &brbits);
        pic_bitstate_dump(pf, pfile_write_asm, dbits.before.rp1, 'R', 'r');
        pic_bitstate_dump(pf, pfile_write_asm, dbits.before.rp0, 'S', 's');
        pfile_write(pf, pfile_write_asm, " ");
        pic_bitstate_dump(pf, pfile_write_asm, dbits.action.rp1, 'R', 'r');
        pic_bitstate_dump(pf, pfile_write_asm, dbits.action.rp0, 'S', 's');
        pfile_write(pf, pfile_write_asm, " [");
        pic_bitstate_dump(pf, pfile_write_asm, brbits.before.pclath4, 'H', 'h');
        pic_bitstate_dump(pf, pfile_write_asm, brbits.before.pclath3, 'L', 'l');
        pfile_write(pf, pfile_write_asm, " ");
        pic_bitstate_dump(pf, pfile_write_asm, brbits.action.pclath4, 'H', 'h');
        pic_bitstate_dump(pf, pfile_write_asm, brbits.action.pclath3, 'L', 'l');
        pfile_write(pf, pfile_write_asm, "]");
      }
      pfile_write(pf, pfile_write_asm, " %04x", pic_code_pc_get(code));
      for (ii = 0; ii < pcode.ct; ii++) {
        pfile_write(pf, pfile_write_asm, " %02x%02x",
          (unsigned char) (pcode.code[ii] >> 8),
          (unsigned char) (pcode.code[ii] & 0xff));
      }
      if (pic_code_w_value_get(code)) {
        pfile_write(pf, pfile_write_asm, "\n%60s; W = ", "");
        pic_variable_tag_dump(pf, pfile_write_asm,
          value_variable_get(pic_code_w_value_get(code)), BOOLEAN_FALSE);
      }
    }
  }
  if (need_cr) {
    pfile_write(pf, pfile_write_asm, "\n");
  }
}

static void pic_eeprom_or_id_dump(pfile_t *pf, value_t eeprom_or_id,
  const char *name,
  const char *name_base,
  const char *name_used,
  const char *comment)
{
  value_t sz;

  sz = pfile_value_find(pf, PFILE_LOG_NONE, name_used);
  if (sz && (value_const_get(sz))) {
    /* dump the eeprom bits */
    unsigned ii;
    value_t  v_base;
    variable_const_t base;

    v_base = pfile_value_find(pf, PFILE_LOG_ERR, name_base);
    base = value_const_get(v_base);
    value_release(v_base);

    pfile_write(pf, pfile_write_asm, "\n; %s data\n\n", comment);
    pfile_write(pf, pfile_write_asm,
      "%*s%-" STRINGIZE(PIC_OPCODE_COLUMN_SZ) "s0x%04x\n",
      PIC_LABEL_COLUMN_SZ - 1, "", "org", value_const_get(eeprom_or_id));
    pfile_write(pf, pfile_write_asm,
      "%*s%-" STRINGIZE(PIC_OPCODE_COLUMN_SZ) "s",
      PIC_LABEL_COLUMN_SZ - 1, "", (pic_is_16bit(pf)) ? "db" : "dw");
    value_release(eeprom_or_id);

    eeprom_or_id = pfile_value_find(pf, PFILE_LOG_NONE, name);
    value_dereference(eeprom_or_id);
    if (!pic_is_16bit(pf)) {
      base *= 2;
    }
    for (ii = 0; ii < value_const_get(sz); ii++) {
      value_t             c;
      variable_const_t    n;

      c = pfile_constant_get(pf, ii, VARIABLE_DEF_NONE);
      value_baseofs_set(eeprom_or_id, c);
      value_release(c);
      n = value_const_get(eeprom_or_id);
      pfile_write(pf, pfile_write_lst, "%s%u",
          (ii) ? "," : "", n);
      pic_obj_write_byte(pf, base, n);
      base++;
      if (!pic_is_16bit(pf)) {
        pic_obj_write_byte(pf, base, 0);
        base++;
      }
    }
    if (pic_is_16bit(pf) && (base & 0x0001)) {
      pic_obj_write_byte(pf, base, 0);
    }
    pfile_write(pf, pfile_write_lst, "\n");
  }
  value_release(sz);
}

static void pic_eeprom_dump(pfile_t *pf, value_t eeprom)
{
  pic_eeprom_or_id_dump(pf, eeprom, 
    PIC_EEPROM, PIC_EEPROM_BASE, PIC_EEPROM_USED,
    "EEPROM");
}

static void pic_id_dump(pfile_t *pf, value_t id)
{
  pic_eeprom_or_id_dump(pf, id, 
    PIC_ID, PIC_ID_BASE, PIC_ID_USED, "ID");
}

static void pic_config_dump(pfile_t *pf, value_t config)
{
  if (pfile_flag_test(pf, PFILE_FLAG_BOOT_FUSES)) {
    value_t          fuses;

    fuses = pfile_value_find(pf, PFILE_LOG_ERR, "_fuses");
    if (value_is_array(fuses)) {
      variable_ct_t ii;

      for (ii = 0; ii < value_ct_get(fuses); ii++) {
        variable_const_t    n;
        variable_const_t    base;
        value_t             tfuses;
        value_t             tbase;

        tfuses = value_subscript_set(fuses, ii);
        tbase  = value_subscript_set(config, ii);

        n    = value_const_get(tfuses);
        base = value_const_get(tbase);
        if (value_sz_get(tfuses) == 2) {
          pic_obj_write_byte(pf, 2 * base,     n & 0xff);
          pic_obj_write_byte(pf, 2 * base + 1, (n >> 8) & 0xff);
        } else if (value_sz_get(tfuses) == 1) {
          pic_obj_write_byte(pf, base, n & 0xff);
        }
        value_release(tbase);
        value_release(tfuses);
      }
    } else {
      variable_const_t    n;
      variable_const_t    base;

      n    = value_const_get(fuses);
      base = value_const_get(config);

      pic_obj_write_byte(pf, 2 * base,     n & 0xff);
      pic_obj_write_byte(pf, 2 * base + 1, (n >> 8) & 0xff);
    }
    value_release(fuses);
  }
}

static pic_code_t pic_code_out;

void pic_cmd_dump(pfile_t *pf, const cmd_t cmd, boolean_t first)
{
  /* if first is TRUE, we need to dump the preamble */
  if (first) {
    pic_stack_depth_get(pf);
    for (pic_code_out = pic_code_list_head_get(pf);
         pic_code_out && (pic_code_cmd_get(pic_code_out) != cmd);
         pic_code_out = pic_code_next_get(pic_code_out)) {
      pic_code_dump(pf, pic_code_out);
    }
  }
  while (pic_code_out && (pic_code_cmd_get(pic_code_out) == cmd)) {
    pic_code_dump(pf, pic_code_out);
    pic_code_out = pic_code_next_get(pic_code_out);
  }
  if (CMD_NONE == cmd) {
    unsigned stack_depth = 0;

    struct block_ {
      value_t val;
      void   (*dump)(pfile_t *pf, value_t val);
    } block[3] = {
      { VALUE_NONE, pic_eeprom_dump },
      { VALUE_NONE, pic_id_dump     },
      { VALUE_NONE, pic_config_dump }
    };

    /* 
     * for purely aesthetic reasons I'm putting these in numeric order
     * sort using a simple 3-element network sort
     */
    block[0].val = pfile_value_find(pf, PFILE_LOG_NONE, PIC_EEPROM_BASE);
    block[1].val = pfile_value_find(pf, PFILE_LOG_NONE, PIC_ID_BASE);
    block[2].val = pfile_value_find(pf, PFILE_LOG_NONE, "_fuse_base");
#define SWAPIT(x,y) \
    if (value_const_get(x.val) > value_const_get(y.val)) { \
      struct block_ tmp;                                 \
      tmp = x;                                     \
      x   = y;                                     \
      y   = tmp;                                   \
    }
    SWAPIT(block[1],block[2]);
    SWAPIT(block[0],block[2]);
    SWAPIT(block[0],block[1]);
#undef SWAPIT
    block[0].dump(pf, block[0].val);
    block[1].dump(pf, block[1].val);
    block[2].dump(pf, block[2].val);
    value_release(block[0].val);
    value_release(block[1].val);
    value_release(block[2].val);
    pfile_write(pf, pfile_write_asm, "%*s\n", PIC_LABEL_COLUMN_SZ + 2, "end");
    if (!pfile_errct_get(pf)) {
      value_t sz;
      value_t stack_sz;

      sz = pfile_value_find(pf, PFILE_LOG_NONE, "_code_size");
      if (!sz) {
        if (pfile_flag_test(pf, PFILE_FLAG_WARN_BACKEND)) {
          pfile_log(pf, PFILE_LOG_WARN, "Maximum code size is not set!");
        }
      } else {
        pic_code_t ptr;

        ptr = pic_code_list_tail_get(pf);
        pic_blist_info_log(pf);
        if (ptr) {
          unsigned code_sz;

          code_sz = (ptr) 
            ? pic_code_pc_get(ptr) 
              + pic_code_sz_get(ptr, pic_target_cpu_get(pf))
            : 0;
          pfile_log(pf, PFILE_LOG_INFO, PIC_MSG_CODE_USED,
              code_sz, (unsigned) value_const_get(sz),
              pic_is_16bit(pf) ? "bytes" : "words");
          if (code_sz >= value_const_get(sz)) {
            pfile_log(pf, PFILE_LOG_ERR, PIC_MSG_CODE_TOO_BIG);
          }
        }

        for (ptr = pic_code_list_head_get(pf), stack_depth = 0; 
             ptr; 
             ptr = pic_code_next_get(ptr)) {
          if ((-1U != pic_code_depth_get(ptr))
            && (stack_depth < pic_code_depth_get(ptr))) {
            stack_depth = pic_code_depth_get(ptr);
          }
        }
        value_release(sz);
      }
      pfile_log(pf, PFILE_LOG_INFO, PIC_MSG_DATA_USED, pic_blist_max,
          pic_blist_total);
      pfile_log(pf, PFILE_LOG_INFO, PIC_MSG_STACK_AVAIL, (ulong) pic_stk_sz);

      stack_sz = pfile_value_find(pf, PFILE_LOG_NONE, "_stack_size");
      if (stack_depth >= 15) {
        pfile_log(pf, PFILE_LOG_INFO, "Hardware stack depth INFINITE");
      } else {
        pfile_log(pf, PFILE_LOG_INFO, "Hardware stack depth %u of %u",
            stack_depth, (unsigned) value_const_get(stack_sz));
      }
      if (!stack_sz) {
        if (pfile_flag_test(pf, PFILE_FLAG_WARN_BACKEND)) {
          pfile_log(pf, PFILE_LOG_WARN, "stack size not set");
        }
      } else if (stack_depth > value_const_get(stack_sz)) {
        pfile_log(pf,
            pfile_flag_test(pf, PFILE_FLAG_WARN_STACK_OVERFLOW)
            ? PFILE_LOG_WARN
            : PFILE_LOG_ERR,
            "Hardware stack overflow!");
      }
      value_release(stack_sz);
    }
  }
}

/* create a map of all used data areas! the map will show 'v'
 * for volatile, '*' for used and '-' for unused */
static void pic_data_area_map_create(pfile_t *pf)
{
  char *map;

  map     = CALLOC(1024, 1); /* nothing should be out of this range */
  if (map) {
    pfile_proc_t   *proc;
    variable_base_t highest;
    variable_base_t lowest;
    size_t          ii;

    lowest  = -1;
    highest = 0;
    for (proc = pfile_proc_root_get(pf);
         proc;
         proc = pfile_proc_next(proc)) {
      pfile_block_t *blk;

      for (blk = pfile_proc_block_root_get(proc);
           blk;
           blk = pfile_block_next(blk)) {
        variable_t var;

        for (var = pfile_block_variable_get_first(blk);
             var;
             var = variable_link_get(var)) {
          variable_base_t base;

          base = variable_base_get(var, 0);
          if (!variable_master_get(var) && (VARIABLE_BASE_UNKNOWN != base)) {
            if (base < 1024) {
              size_t sz;

              sz = variable_sz_get(var);
              if (0 == highest) {
                highest = base;
                lowest = base;
              } else if (base < lowest) {
                lowest = base;
              } else if (base > highest) {
                highest = base;
              }
              for (ii = 0; ii < sz; ii++, base++) {
                if (variable_is_volatile(var)) {
                  map[base] = 'v';
                } else if (!variable_is_auto(var)) {
                  map[base] = 'u';
                } else if (0 == map[base]) {
                  map[base] = '*';
                }
              }
            }
          }
        }
      }
    }
    lowest  = (lowest / 32) * 32;
    highest = ((highest + 31) / 32) * 32;
    if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_COMPILER)) {
      for (ii = lowest; ii < highest; ii+= 32) {
        char   buf[64];
        int    col;
        size_t jj;

        col = sprintf(buf, "%04lx: ", (ulong) ii);
        for (jj = 0; jj < 32; jj++) {
          if (!(jj & 0x03)) {
            buf[col++] = ' ';
          }
          buf[col++] = map[ii+jj] ? map[ii+jj] : '-';
        }
        buf[col] = 0;
        pfile_log(pf, PFILE_LOG_DEBUG, "%s", buf);
      }
    }
    if (pfile_flag_test(pf, PFILE_FLAG_MISC_CLEAR_BSS)) {
      label_t   lbl_memset;
      value_t   pic_loop;
      size_t    base;

      lbl_memset = pic_label_find(pf, PIC_LABEL_MEMSET, BOOLEAN_TRUE);
      pic_loop   = pic_var_loop_get(pf);

      for (base = lowest; base < highest; base++) {
        if ('*' == map[base]) {
          size_t len;

          for (len = 0; 
               (base + len < highest) && ('*' == map[base + len]); 
               len++)
            ;
          while (len) {
            size_t clr;

            clr = (len >= 256) ? 256 : len;
            if (clr <= 7) {
              value_t        val;
              variable_def_t def;
              char           bss_name[32];

              def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
                  VARIABLE_DEF_FLAG_VOLATILE, clr);
              sprintf(bss_name, "_pic_bss_%lx", (ulong) base);
              pfile_value_alloc(pf, PFILE_VARIABLE_ALLOC_GLOBAL,
                  bss_name, def, &val);
              variable_base_set(value_variable_get(val), base, 0);
              value_assign_ct_bump(val, CTR_BUMP_INCR);
              for (ii = 0; ii < clr; ii++) {
                pic_instr_append_f(pf, PIC_OPCODE_CLRF, val, ii);
              }
              value_release(val);
            } else {
              pic_stvar_fsr_mark(pf);
              if (pic_is_16bit(pf) || pic_is_14bit_hybrid(pf)) {
                pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, base & 0xff);
                pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr0l");
                pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, base >> 8);
                pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr0h");
              } else {
                pic_instr_append_reg_flag(pf,
                    (base & 0x0100) ? PIC_OPCODE_BSF : PIC_OPCODE_BCF,
                    "_status", "_irp");
                pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, base & 0xff);
                pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr");
              }
              pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, clr);
              pic_instr_append_f(pf, PIC_OPCODE_MOVWF, pic_loop, 0);
              /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
              pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
              pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl_memset);
            }
            /* bad form, I know, but the clearest I can think to do! */
            base += clr - 1;
            len  -= clr;
          }
        }
      }
      pic_var_loop_release(pf, pic_loop);
      label_release(lbl_memset);
    }
    FREE(map);
  }
}


/*
 * NAME
 *   pic_code_isr_preamble
 *
 * DESCRIPTION
 *   create the isr preamble code
 *
 * PARAMETERS
 *   pf : pfile
 *
 * RETURN
 *
 * NOTES
 *   from the PIC reference:
 *      movwf w_temp     ; w --> w_temp
 *      swapf status, w  ; status --> w (nybble swapped but not flags
 *                                      effected)
 *      clrf  status     ; 0 --> status (irp/rp1/rp0 = clr)
 *      movwf status_tmp ; w --> status_temp
 *      movf  pclath, w  ; pclath --> w
 *      movwf pclath_tmp ; w --> pclath_temp
 *      clrf  pclath     ; 0 --> pclath
 *      ...
 *      {isr}
 *      ...
 *      movf  pclath_tmp,w ; pclath_tmp --> w
 *      movwf pclath       ; w --> pclath
 *      swapf status_tmp,w ; status_tmp --> w
 *      movwf status       ; w --> status
 *      swapf w_temp,f     ; w_temp->h <--> w_temp->l --> w_temp
 *      swapf w_temp,w     ; w_temp->h <--> w_temp->l --> w
 *      retfie
 *
 *  also, the lookup tables may not cross 256 byte boundaries (giving a maximum of
 *    254 entries/table). Since I might need to futz with the ORGs here, I don't
 *    want to have to deal with moving them around if branchbits get inserted, so
 *    I'm going to waste a bit of space here & force the branchbits. it doesn't matter
 *    what I use as long as the order is:  HI, LO, goto. The analyzer will make
 *    any necessary corrections later.
 */
static void pic_preuser_init(pfile_t *pf, label_t lbl_user)
{
  pfile_proc_t *proc;
  value_t       stkptr;
  value_t       task_list;
  value_t       task_active;
  pic_code_t    code_start;
  label_t       lbl;

  code_start = pic_code_list_tail_get(pf);

  lbl = pic_label_find(pf, PIC_LABEL_PREUSER, BOOLEAN_FALSE);
  if (lbl) {
    pic_instr_append_label(pf, lbl);
    label_release(lbl);
  }

  /* any recursive functions need their recursive count cleared */
  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    value_t rval;

    rval = pic_proc_rval_get(pf, proc);
    if (pfile_proc_frame_sz_get(proc) && rval) {
      pic_instr_append_f(pf, PIC_OPCODE_CLRF, rval, 0);
    }
    value_release(rval);
  }
  /* if the software stack is used, the stack pointer must be set */
  stkptr = pfile_value_find(pf, PFILE_LOG_NONE, "_pic_stkptr");
  if (stkptr) {
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, pic_stk_base & 0xff);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, stkptr, 0);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, pic_stk_base >> 8);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, stkptr, 1);
    value_release(stkptr);
  }
  /* if the task list is used, the task array
   * & active pointers must be cleared
   * if PFILE_FLAG_MISC_CLEAR_BSS is set, the clearing will be done
   * elsewhere
   */
  if (!pfile_flag_test(pf, PFILE_FLAG_MISC_CLEAR_BSS)) {
    task_list = pfile_value_find(pf, PFILE_LOG_NONE, "_task_list");
    if (task_list) {
      unsigned task_ct;

      task_ct = 2 * pfile_task_ct_get(pf);
      while (task_ct--) {
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, task_list, task_ct);
      }
      value_release(task_list);
    }

    task_active = pfile_value_find(pf, PFILE_LOG_NONE, "_task_active");
    if (task_active) {
      pic_instr_append_f(pf, PIC_OPCODE_CLRF, task_active, 0);
      value_release(task_active);
    }
  }
  pic_data_area_map_create(pf);
  /* if PFILE_FLAG_CLEAR_BSS is set we're going to assume it produced
   * some code, otherwise the program is too trivial */
  if ((pic_code_list_tail_get(pf) != code_start)
      || pfile_flag_test(pf, PFILE_FLAG_MISC_CLEAR_BSS)) {
    /* code was generated, so create the label */
    label_release(pic_label_find(pf, PIC_LABEL_PREUSER, BOOLEAN_TRUE));
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_user);
  }
}

label_t pic_lookup_label_find(pfile_t *pf, variable_t var, unsigned flags)
{
  size_t  sz;
  label_t lbl;
  char   *name;

  sz  = 19; /* '_lookup_\0' */
  sz += strlen(variable_name_get(var));
  name = MALLOC(sz);
  lbl = LABEL_NONE;
  if (name) {
    const char *fmt;

    fmt = variable_tag_n_get(var)
      ? "_%s_%s_%u"
      : "_%s_%s";
    sprintf(name, fmt,
        (flags & PIC_LOOKUP_LABEL_FIND_FLAG_DATA) ? "data" : "lookup",
      variable_name_get(var), variable_tag_n_get(var));

    lbl = pic_label_find(pf, name, (flags & PIC_LOOKUP_LABEL_FIND_FLAG_ALLOC));
    FREE(name);
  }
  return lbl;
}

/*
 * create all of the lookup tables. this is done simply:
 * 1. create an array with all of the lookup tables & sizes
 * 2. sort by size
 * 3. create the tables, largest to smallest adjusting the PC
 *    as necessary when crossing a 256 byte boundary
 */

typedef struct pic_lookup_inf_ {
  variable_t var;
  size_t     sz;
} pic_lookup_inf_t;

static int lookup_inf_cmp(const void *A, const void *B)
{
  const pic_lookup_inf_t *a = A;
  const pic_lookup_inf_t *b = B;

  return (a->sz < b->sz) - (a->sz > b->sz);
}

/* this is used by the 16 bit architectures */
static void pic_lookup_init_16bit(pfile_t *pf)
{
  pfile_proc_t  *proc;
  label_t         lbl_lookup;

  lbl_lookup = LABEL_NONE;
  /* this needs to be marked VISITED to make sure no one tries to delete it */
  pic_instr_default_flag_set(pf, PIC_CODE_FLAG_VISITED);
  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    pfile_block_t *blk;

    for (blk = pfile_proc_block_root_get(proc);
         blk;
         blk = pfile_block_next(blk)) {
      variable_t var;

      for (var = pfile_block_variable_list_head(blk);
           var;
           var = variable_link_get(var)) {
        if (variable_is_lookup(var) && variable_data_get(var)) {
          size_t     sz;
          void      *data;

          sz = variable_sz_get(var);
          data = MALLOC(sz);
          if (!data) {
            pfile_log_syserr(pf, errno);
          } else {
            label_t    lbl;
            pic_code_t code;
            if (!lbl_lookup) {
              /* this is a sentinel to let the pre-amble code know it needs
                 to GOTO over this! */
              lbl_lookup = pic_label_find(pf, PIC_LABEL_LOOKUP, BOOLEAN_TRUE);
              label_release(lbl_lookup);
            }
            memcpy(data, variable_data_get(var), sz);
            lbl = pic_lookup_label_find(pf, var,
              PIC_LOOKUP_LABEL_FIND_FLAG_ALLOC
              | PIC_LOOKUP_LABEL_FIND_FLAG_DATA);
            pic_instr_append_label(pf, lbl);
            label_release(lbl);
            code = pic_instr_append(pf, PIC_OPCODE_DB);
            pic_code_data_set(code, sz, data);
          }
        }
      }
    }
  }
  pic_instr_default_flag_clr(pf, PIC_CODE_FLAG_VISITED);
}

/* this is used by 12 & 14 bit architectures */
static void pic_lookup_init_14bit(pfile_t *pf)
{
  pfile_proc_t *proc;
  struct {
    size_t            alloc;
    size_t            used;
    pic_lookup_inf_t *data;
  } lookup_inf = {0, 0, 0};

  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    pfile_block_t *blk;

    for (blk = pfile_proc_block_root_get(proc);
         blk;
         blk = pfile_block_next(blk)) {
      variable_t var;

      for (var = pfile_block_variable_list_head(blk);
           var;
           var = variable_link_get(var)) {
        if (variable_is_lookup(var)) {
          /* create the lookup table */
          if (lookup_inf.used == lookup_inf.alloc) {
            void  *tmp;
            size_t tmp_sz;
            size_t tmp_ct;

            tmp_ct = (lookup_inf.alloc) ? 2 * lookup_inf.alloc : 16;
            tmp_sz = tmp_ct * sizeof(*lookup_inf.data);
            tmp = REALLOC(lookup_inf.data, tmp_sz);
            if (!tmp) {
              pfile_log_syserr(pf, ENOMEM);
            } else {
              lookup_inf.alloc = tmp_ct;
              lookup_inf.data  = tmp;
            }
          }
          if (lookup_inf.used < lookup_inf.alloc) {
            lookup_inf.data[lookup_inf.used].var = var;
            lookup_inf.data[lookup_inf.used].sz  = variable_sz_get(var);
            lookup_inf.used++;
          }
        }
      }
    }
  }
  if (lookup_inf.used) {
    size_t pc;

    label_release(pic_label_find(pf, PIC_LABEL_LOOKUP, BOOLEAN_TRUE));

    /* this needs to be marked VISITED to make sure no one tries to delete
     * it. this can be wasteful in some situations, but we go through
     * hoops to make sure nothing crosses the 256 byte boundaries, so
     * moving things around would be bad */
    pic_instr_default_flag_set(pf, PIC_CODE_FLAG_VISITED);
    qsort(lookup_inf.data, lookup_inf.used, sizeof(*lookup_inf.data),
      lookup_inf_cmp);

    pic_branchbits_pc_set(pf, PIC_BRANCHBITS_PC_SET_FLAG_NONE);
    pc = pic_code_list_pc_next_get(pf);

    while (lookup_inf.used) {
      size_t    ii;
      boolean_t used;

      for (ii = 0, used = BOOLEAN_FALSE; ii < lookup_inf.used; ) {
        label_t        lbl;
        variable_def_t def;
        boolean_t      writeit;

        def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
          VARIABLE_DEF_FLAG_NONE, 1);

        lbl = pic_lookup_label_find(pf, lookup_inf.data[ii].var,
            PIC_LOOKUP_LABEL_FIND_FLAG_ALLOC);
        if (pic_is_16bit(pf)) {
          writeit = BOOLEAN_TRUE;
          pic_instr_append_label(pf, lbl);
        } else {
          writeit = BOOLEAN_FALSE;
          if (lookup_inf.data[ii].sz > 255) {
            /* the offset is passed in W:tmp */
            value_t tmp;

            tmp = pic_var_loop_get(pf);
            pc += (pic_is_14bit_hybrid(pf)) ? 7 : 8;
            pic_instr_append_label(pf, lbl);
            if (pc >> 8) {
              pc++;
              pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, pc >> 8);
            }
            pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_pclath");
            pic_instr_append_daop(pf, tmp, PIC_OPCODE_MOVF, BOOLEAN_TRUE);
            pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tmp, 0, PIC_OPDST_W);
            pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, pc & 0xff);
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
            pic_instr_append_reg_d(pf, PIC_OPCODE_INCF, "_pclath", PIC_OPDST_F);
            pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_pcl");
            writeit = BOOLEAN_TRUE;
            pic_var_loop_release(pf, tmp);
          } else {
            size_t pc_hi;

            pc_hi = pc + lookup_inf.data[ii].sz;
            if (pc / 256 == pc_hi / 256) {
              /* put in the table */
              pic_instr_append_label(pf, lbl);
              pic_instr_append_reg_d(pf, PIC_OPCODE_ADDWF, "_pcl",
                PIC_OPDST_F);
              writeit = BOOLEAN_TRUE;
              pc++;
            }
          }
        }
        if (writeit) {
          /* remove this from the list by bumping all other elements down */
          size_t jj;
          label_t lbl_data;

          lbl_data = pic_lookup_label_find(pf, lookup_inf.data[ii].var,
              PIC_LOOKUP_LABEL_FIND_FLAG_DATA);
          if (LABEL_NONE != lbl_data) {
            pic_instr_append_label(pf, lbl_data);
            label_release(lbl_data);
          }

          for (jj = 0; jj < lookup_inf.data[ii].sz; jj++) {
            pic_instr_append_w_kn(pf, PIC_OPCODE_RETLW,
              variable_const_get(lookup_inf.data[ii].var, def, jj));
          }
          pc += lookup_inf.data[ii].sz;
          for (jj = ii + 1; jj < lookup_inf.used; jj++) {
            lookup_inf.data[jj - 1] = lookup_inf.data[jj];
          }
          lookup_inf.used--;
          used = BOOLEAN_TRUE;
        } else {
          ii++;
        }
        label_release(lbl);
      }
      if (!used) {
        /* we need to waste some space here. put in a new origin */
        pic_pc_t pc_new;

        pc_new = 256 * ((pc + 255) / 256);
        pic_instr_append_w_kn(pf, PIC_OPCODE_ORG, pc_new);
        pfile_log(pf, PFILE_LOG_DEBUG,
            "Wasting %lu bytes for lookup table alignment",
            (ulong) (pc_new - pc));
        pc = pc_new;
      }
    }
    FREE(lookup_inf.data);
    pic_instr_default_flag_clr(pf, PIC_CODE_FLAG_VISITED);
  }
}

static void pic_lookup_init(pfile_t *pf)
{
  if (pic_is_16bit(pf)) {
    pic_lookup_init_16bit(pf);
  } else {
    pic_lookup_init_14bit(pf);
  }
}


void pic_code_preamble(pfile_t *pf)
{
  label_t lbl_user;
  label_t lbl_pic_reset;   /* the reset vector */
  label_t lbl_pic_isr;     /* the ISR vector */
  label_t lbl_pic_preuser; /* the preuser vector */
  label_t lbl_pic_lookup;  /* dummy label present if there are any
                              lookup tables */
  label_t lbl_entry;       /* actual entry point, either lbl_user,
                              lbl_preuser, or none */
  label_t lbl_pic_pre_isr;

  lbl_pic_pre_isr = pic_label_find(pf, PIC_LABEL_PRE_ISR, BOOLEAN_TRUE);
  lbl_pic_reset   = pic_label_find(pf, PIC_LABEL_RESET, BOOLEAN_TRUE);
  lbl_pic_isr     = pic_label_find(pf, PIC_LABEL_ISR, BOOLEAN_TRUE);
  lbl_pic_preuser = pic_label_find(pf, PIC_LABEL_PREUSER,
    pfile_flag_test(pf, PFILE_FLAG_MISC_CLEAR_BSS));
  lbl_pic_lookup  = pic_label_find(pf, PIC_LABEL_LOOKUP, BOOLEAN_FALSE);

  lbl_user = pfile_user_entry_get(pf);

  if (!lbl_user) {
    pfile_log(pf, PFILE_LOG_CRIT, PIC_MSG_NO_USER_ENTRY);
  } else {
    label_t          lbl_loader; /* used by the boot loader */
    label_t          lbl_isr;
    unsigned         pc;
    value_t          code_sz;
    variable_const_t n_code_sz;

    code_sz    = pfile_value_find(pf, PFILE_LOG_ERR, "_code_size");
    n_code_sz  = value_const_get(code_sz);
    lbl_isr    = pfile_isr_entry_get(pf);
    lbl_loader = LABEL_NONE;

    pic_instr_default_flag_set(pf, PIC_CODE_FLAG_NO_OPTIMIZE);
    lbl_entry = (lbl_pic_preuser)
      ? lbl_pic_preuser
      : lbl_user;
    if (pfile_flag_test(pf, PFILE_FLAG_BOOT_RICK)) {
      pc = 3;
      if (pic_is_16bit(pf)) {
        pfile_log(pf, PFILE_LOG_ERR, "-rickpic not available on 16 bit cores");
      }
      pic_instr_append_w_kn(pf, PIC_OPCODE_ORG, pc);
      pic_instr_append_label(pf, lbl_pic_reset);
      if (lbl_pic_lookup) {
        /* we need to skip the lookup table, so jump to a dummy
         * location that will jump to the real address
         */
        lbl_loader = pfile_label_alloc(pf, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_loader);
      } else {
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_entry);
      }
    } else if (pfile_flag_test(pf, PFILE_FLAG_BOOT_BLOADER)) {
      if (pic_is_16bit(pf)) {
        pfile_log(pf, PFILE_LOG_ERR, "-bloader not available on 16 bit cores");
      }
      pic_instr_append_w_kn(pf, PIC_OPCODE_ORG, 0);
      pic_instr_append_label(pf, lbl_pic_reset);
      lbl_loader = pfile_label_alloc(pf, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_loader);
      pc = 4;
      pic_instr_append_w_kn(pf, PIC_OPCODE_ORG, pc);
    } else if (pfile_flag_test(pf, PFILE_FLAG_BOOT_LOADER18)) {
      if (!pic_is_16bit(pf)) {
        pfile_log(pf, PFILE_LOG_ERR, 
          "-loader18 is only available on 16 bit cores");
      }
      pc = pfile_loader_offset_get(pf);
      pic_instr_append_w_kn(pf, PIC_OPCODE_ORG, pc);
      pic_instr_append_label(pf, lbl_pic_reset);
      if (lbl_pic_lookup) {
        /* we need to skip the lookup table, so jump to a dummy
         * location that will jump to the real address
         */
        lbl_loader = pfile_label_alloc(pf, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_loader);
      } else {
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_entry);
      }
    } else {
      pc = 0;
      pic_instr_append_w_kn(pf, PIC_OPCODE_ORG, pc);
      pic_instr_append_label(pf, lbl_pic_reset);
      if ((lbl_isr
        || lbl_pic_lookup
        || pfile_flag_test(pf, PFILE_FLAG_BOOT_LONG_START)
        || pic_intrinsics_exist(pf))) {
        if (!pic_is_16bit(pf)) {
          if (pic_is_14bit_hybrid(pf)) {
            pic_code_t code;

            code = pic_instr_append_n(pf, PIC_OPCODE_MOVLP, lbl_entry);
            pic_code_ofs_set(code, 1);
          } else {
            if (pfile_flag_test(pf, PFILE_FLAG_BOOT_LONG_START)
              || (n_code_sz >= 4096)) {
              pic_instr_append_n(pf, PIC_OPCODE_BRANCHHI_CLR, lbl_entry);
            }
            if (pfile_flag_test(pf, PFILE_FLAG_BOOT_LONG_START)
              || (n_code_sz >= 2048)) {
              pic_instr_append_n(pf, PIC_OPCODE_BRANCHLO_CLR, lbl_entry);
            }
          }
        }
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_entry);
        if (pfile_flag_test(pf, PFILE_FLAG_BOOT_LONG_START)) {
          pic_instr_append(pf, PIC_OPCODE_NOP);
          if (pic_is_14bit_hybrid(pf) || pic_is_16bit(pf)) {
            pic_instr_append(pf, PIC_OPCODE_NOP);
          }
        }
      }
    }

    if (lbl_isr) {
      /* nb: for the RF PIC loader, the ISR preamble code cannot exceed 2K */
      pic_var_isr_t isr_vars;

      /* the interrupt vector is:
       *    12 & 14 bit cores : 0x0004
       *    16 bit cores      : 0x0008 & 0x0018!
       * assume no priority interrupts for 16 bit, so we'll use `retfie fast'
       * to restore STATUS/BSR/W. We'll still need to deal with FSR[0-2][HL]
       * though for the first release only FSR0 will be used.
       */
      pic_var_isr_get(pf, BOOLEAN_TRUE, &isr_vars);
      if (pic_is_16bit(pf)) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_ORG, pc + 8);
        pic_instr_append_label(pf, lbl_pic_isr);
        pc += 8;
      } else if (pic_is_14bit_hybrid(pf)) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_ORG, 4);
        pic_instr_append_label(pf, lbl_pic_isr);
      } else {
        pic_instr_append_w_kn(pf, PIC_OPCODE_ORG, 4);
        pic_instr_append_label(pf, lbl_pic_isr);
        /* finally, the ISR preamble */
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, isr_vars.w, 0);
        pic_instr_append_reg_d(pf, PIC_OPCODE_SWAPF, "_status", PIC_OPDST_W);
        pic_instr_append_reg(pf, PIC_OPCODE_CLRF, "_status");
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, isr_vars.status, 0);
        pic_instr_append_reg_d(pf, PIC_OPCODE_MOVF, "_pclath", PIC_OPDST_W);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, isr_vars.pclath, 0);
        pic_instr_append_reg(pf, PIC_OPCODE_CLRF, "_pclath");
      }
      if (pfile_flag_test(pf, PFILE_FLAG_MISC_INTERRUPT_FAST)) {
        label_release(lbl_pic_pre_isr);
        lbl_pic_pre_isr = lbl_isr;
        lbl_isr = LABEL_NONE;
      }

      if (!pic_is_16bit(pf)) {
        if (pic_is_14bit_hybrid(pf)) {
          pic_code_t code;

          code = pic_instr_append_n(pf, PIC_OPCODE_MOVLP, lbl_pic_pre_isr);
          pic_code_ofs_set(code, 1);
        } else {
          if (n_code_sz > 4096) {
            pic_instr_append_n(pf, PIC_OPCODE_BRANCHHI_SET, lbl_pic_pre_isr);
          }
          if (n_code_sz > 2048) {
            pic_instr_append_n(pf, PIC_OPCODE_BRANCHLO_SET, lbl_pic_pre_isr);
          }
        }
      }
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_pic_pre_isr);
      pic_var_isr_release(pf, &isr_vars);
      label_release(lbl_isr);
    }
    if (lbl_loader) {
      unsigned page_size;

      page_size = pic_target_page_size_get(pf);
      pic_instr_append_label(pf, lbl_loader);
      if (!pic_is_16bit(pf)) {
        if (pic_is_14bit_hybrid(pf)) {
          pic_code_t code;

          code = pic_instr_append_n(pf, PIC_OPCODE_MOVLP, lbl_entry);
          pic_code_ofs_set(code, 1);
        } else {
          if (n_code_sz >= (2 * page_size)) {
            pic_instr_append_n(pf, PIC_OPCODE_BRANCHHI_CLR, lbl_entry);
          }
          if (n_code_sz >= page_size) {
            pic_instr_append_n(pf, PIC_OPCODE_BRANCHLO_CLR, lbl_entry);
          }
        }
      }
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_entry);
      label_release(lbl_loader);
    }
    /* the lookup table *must* follow the ISR entry */
    pic_lookup_init(pf);
    /* from here on we can start optimizing again */
    pic_instr_default_flag_clr(pf, PIC_CODE_FLAG_NO_OPTIMIZE);
    if (pfile_flag_test(pf, PFILE_FLAG_MISC_CLEAR_BSS)) {
      /* assume memset is used */
      label_release(pic_label_find(pf, PIC_LABEL_MEMSET, BOOLEAN_TRUE));
    }
    pic_intrinsics_create(pf);
    if (!pfile_flag_test(pf, PFILE_FLAG_MISC_INTERRUPT_FAST)) {
      pic_instr_append_label(pf, lbl_pic_pre_isr);
      pic_var_isr_entry(pf);
    }
    pic_preuser_init(pf, lbl_user);

    label_release(lbl_user);
    value_release(code_sz);
  }
  label_release(lbl_pic_lookup);
  label_release(lbl_pic_preuser);
  label_release(lbl_pic_reset);
  label_release(lbl_pic_pre_isr);
  label_release(lbl_pic_isr);
}

void pic_code_cleanup(pfile_t *pf)
{
  pic_code_list_reset(pf);
  pic_blist_free(pf);
}

void pic_code_emu(pfile_t *pf)
{
  pic_emu_state_t state;

  state = pic_emu_state_alloc(pf, pic_target_cpu_get(pf));
  pic_emu(pf, state);
  pic_emu_state_free(state);
}

boolean_t pic_code_is_suspend(pfile_t *pf, pic_code_t code)
{
  label_t   lbl;
  boolean_t is_suspend;

  lbl = pfile_label_find(pf, PFILE_LOG_NONE, PIC_LABEL_TASK_SUSPEND);
  is_suspend = lbl && (lbl == pic_code_brdst_get(code));
  label_release(lbl);
  return is_suspend;
}

static void pic_code_mark_used(pfile_t *pf, pic_code_t code)
{
  pic_code_t next;
  boolean_t  code_is_cond;

  code_is_cond = BOOLEAN_FALSE;
  while (code && !pic_code_flag_test(code, PIC_CODE_FLAG_VISITED)) {
    next = pic_code_next_get(code);
    pic_code_flag_set(code, PIC_CODE_FLAG_VISITED);
    if (PIC_OPCODE_NONE != pic_code_op_get(code)) {
      boolean_t next_is_cond;

      next_is_cond = BOOLEAN_FALSE;
      switch (pic_code_op_get(code)) {
        case PIC_OPCODE_BTFSC:
        case PIC_OPCODE_BTFSS:
        case PIC_OPCODE_INCFSZ:
        case PIC_OPCODE_DECFSZ:
          next_is_cond = BOOLEAN_TRUE;
          break;
        case PIC_OPCODE_RETFIE:
        case PIC_OPCODE_RETLW:
        case PIC_OPCODE_RETURN:
          if (!code_is_cond) {
            next = 0;
          }
          break;
        case PIC_OPCODE_GOTO:
          if (!code_is_cond && !pic_code_is_suspend(pf, code)) {
            next = pic_code_label_find(pf, pic_code_brdst_get(code));
            break;
          }
          /* a conditional goto will act like a call */
        case PIC_OPCODE_CALL:
          pic_code_mark_used(pf,
            pic_code_label_find(pf, pic_code_brdst_get(code)));
          break;
        default:
          break;
      }
      code_is_cond = next_is_cond;
    }
    code = next;
  }
}

void pic_code_free_unused(pfile_t *pf)
{
  pic_code_t    code;
  unsigned      ct = 0;
  label_t       lbl;
  pfile_proc_t *proc;

  lbl = pfile_label_find(pf, PFILE_LOG_NONE, PIC_LABEL_ISR);
  if (lbl) {
    pic_code_mark_used(pf, pic_code_label_find(pf, lbl));
    label_release(lbl);
  }
  lbl = pfile_label_find(pf, PFILE_LOG_ERR, PIC_LABEL_RESET);
  if (lbl) {
    pic_code_mark_used(pf, pic_code_label_find(pf, lbl));
    label_release(lbl);
  }
  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    pfile_block_t *blk;

    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INDIRECT)
        || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_TASK))
        /*&& !pfile_proc_flag_test(proc, PFILE_PROC_FLAG_DIRECT)) */{
      code = pic_code_label_find(pf, pfile_proc_label_get(proc));
      pic_code_mark_used(pf, code);
    }
    for (blk = pfile_proc_block_root_get(proc);
         blk;
         blk = pfile_block_next(blk)) {
      for (lbl = pfile_block_label_list_head(blk);
           lbl;
           lbl = label_link_get(lbl)) {
        if (label_usage_get(lbl)) {
          code = pic_code_label_find(pf, lbl);
          pic_code_mark_used(pf, code);
        }
      }
    }
  }

  code = pic_code_list_head_get(pf);
  while (code) {
    pic_code_t next;

    next = pic_code_next_get(code);
    if (!pic_code_flag_test(code, PIC_CODE_FLAG_VISITED)
      && !pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)
      && (PIC_OPCODE_ORG != pic_code_op_get(code))
      && (PIC_OPCODE_END != pic_code_op_get(code))
      && !pic_code_label_get(code)) {
      pic_code_list_remove(pf, code);
      pic_code_free(code);
      ct++;
    }
    code = next;
  }
  pfile_log(pf, PFILE_LOG_DEBUG, "%u unused codes removed", ct);
}


/*
 * NAME
 *   pic_variable_counters_clear
 *
 * DESCRIPTION
 *   set the assign & use counters on all variables to 0
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   none
 *
 * NOTES
 *   I only want to keep the *real* counters -- those used
 *   by the assembly instructions -- so clear all counters
 *   here, produce the code, then set the counter based
 *   on the generated code
 */
static void pic_variable_counters_clear(pfile_t *pf)
{
  pfile_proc_t *proc;

  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    pfile_block_t *blk;

    for (blk = pfile_proc_block_root_get(proc);
         blk;
         blk = pfile_block_next(blk)) {
      variable_t var;

      for (var = pfile_block_variable_list_head(blk);
           var;
           var = variable_link_get(var)) {
        if (!variable_is_const(var)) {
          variable_assign_ct_set(var, 0);
          variable_use_ct_set(var, 0);
        }
      }
    }
  }
}

/*
 * NAME
 *   pic_variable_counters_set
 *
 * DESCRIPTION
 *   set the assign & use counters based on the generated code
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   none
 *
 * NOTES
 */
void pic_variable_counters_set(pfile_t *pf)
{
  pic_code_t code;

  pic_variable_counters_clear(pf);
  for (code = pic_code_list_head_get(pf);
       code;
       code = pic_code_next_get(code)) {
    value_t      val;
    value_t      literal;
    pic_opdst_t  dst;

    val = pic_code_value_get(code);
    dst = pic_code_dst_get(code);
    literal = pic_code_literal_get(code);

    switch (pic_code_op_get(code)) {
      case PIC_OPCODE_END:
      case PIC_OPCODE_NONE:
      case PIC_OPCODE_NOP:
      case PIC_OPCODE_CLRW:
      case PIC_OPCODE_RETFIE:
      case PIC_OPCODE_RETURN:
      case PIC_OPCODE_SLEEP:
      case PIC_OPCODE_CLRWDT:
      case PIC_OPCODE_OPTION:
      case PIC_OPCODE_CALL:
      case PIC_OPCODE_GOTO:
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
      case PIC_OPCODE_DAW:
      case PIC_OPCODE_PUSH:
      case PIC_OPCODE_POP:
      case PIC_OPCODE_RESET:
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
      case PIC_OPCODE_DB:
      case PIC_OPCODE_MULLW:
      case PIC_OPCODE_MOVFF:
      case PIC_OPCODE_MOVLB:
      case PIC_OPCODE_MOVLP:
      case PIC_OPCODE_MOVLP_NOP:
      case PIC_OPCODE_TBLRD:
      case PIC_OPCODE_TBLWT:
        break; /* no action */
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
      case PIC_OPCODE_RLF:
      case PIC_OPCODE_RLCF:
      case PIC_OPCODE_RRF:
      case PIC_OPCODE_RRCF:
      case PIC_OPCODE_MOVF:
      case PIC_OPCODE_SWAPF:
      case PIC_OPCODE_ADDWFc:
      case PIC_OPCODE_DCFSNZ:
      case PIC_OPCODE_INFSNZ:
      case PIC_OPCODE_RLNCF:
      case PIC_OPCODE_RRNCF:
      case PIC_OPCODE_SUBFWB:
      case PIC_OPCODE_SUBWFB:
      case PIC_OPCODE_NEGF:
      case PIC_OPCODE_TSTFSZ:
        value_use_ct_bump(val, CTR_BUMP_INCR);
        if (PIC_OPDST_F == dst) {
          value_assign_ct_bump(val, CTR_BUMP_INCR);
        }
        break;
      case PIC_OPCODE_MOVWF:
      case PIC_OPCODE_CLRF:
      case PIC_OPCODE_BCF:
      case PIC_OPCODE_BSF:
      case PIC_OPCODE_BTG:
      case PIC_OPCODE_SETF:
        value_assign_ct_bump(val, CTR_BUMP_INCR);
        break;
      case PIC_OPCODE_BTFSC:
      case PIC_OPCODE_BTFSS:
      case PIC_OPCODE_CPFSEQ:
      case PIC_OPCODE_CPFSGT:
      case PIC_OPCODE_CPFSLT:
      case PIC_OPCODE_MULWF:
        value_use_ct_bump(val, CTR_BUMP_INCR);
        break;
      case PIC_OPCODE_ADDLW:
      case PIC_OPCODE_ANDLW:
      case PIC_OPCODE_IORLW:
      case PIC_OPCODE_MOVLW:
      case PIC_OPCODE_SUBLW:
      case PIC_OPCODE_XORLW:
      case PIC_OPCODE_RETLW:
      case PIC_OPCODE_TRIS:
      case PIC_OPCODE_ORG:
      case PIC_OPCODE_LFSR:
        if (!value_is_const(val)) {
          value_assign_ct_bump(val, CTR_BUMP_INCR);
        }
        value_use_ct_bump(val, CTR_BUMP_INCR);
        value_use_ct_bump(literal, CTR_BUMP_INCR);
        break;
    }
  }
}

char *pic_chip_name_get(pfile_t *pf)
{
  variable_t chip_var;
  char      *chip_name;

  chip_name = 0;
  chip_var = pfile_variable_find(pf, PFILE_LOG_ERR, "target_chip_name", 0);
  if (!variable_is_array(chip_var)) {
    pfile_log(pf, PFILE_LOG_ERR, "\"target_chip_name\" is invalid");
  } else {
    char          *tmp;
    variable_ct_t  ct;
    variable_def_t def;

    def = variable_def_get(chip_var);

    ct = variable_def_member_ct_get(
           variable_def_member_get(def));

    def = variable_def_member_def_get(variable_def_member_get(def));

    tmp = MALLOC(1 + ct);
    if (!tmp) {
      pfile_log_syserr(pf, ENOMEM);
    } else {
      size_t ii;

      for (ii = 0; ii < ct; ii++) {
        tmp[ii] = (char) variable_const_get(chip_var, def, ii);
      }
      tmp[ii] = 0;
      chip_name = tmp;
    }
  }
  variable_release(chip_var);
  return chip_name;
}

void pic_asm_header_write(pfile_t *pf, const char *chip_name)
{
  value_t          code_sz;
  variable_const_t n_code_sz;
  COD_directory_t *COD_dir;

  COD_dir = pfile_COD_dir_get(pf);
  if (COD_dir) {
    COD_directory_processor_set(COD_dir, (const uchar *) chip_name);
    if (pic_is_16bit(pf)) {
      COD_dir->addr_size = 4;
    }
  }
  pfile_write(pf, pfile_write_asm,
      "%32slist p=%s, r=dec\n"
      "%32serrorlevel -306 ; no page boundary warnings\n"
      "%32serrorlevel -302 ; no bank 0 warnings\n"
      "%32serrorlevel -202 ; no 'argument out of range' warnings\n"
      "\n", "", chip_name ? chip_name : "", "", "", "");

  code_sz   = pfile_value_find(pf, PFILE_LOG_ERR, "_code_size");
  n_code_sz = value_const_get(code_sz);
  value_release(code_sz);

  if (pfile_flag_test(pf, PFILE_FLAG_BOOT_FUSES)) {
    value_t     fuses;
    const char *config;
    const char *fmt_pos;
    const char *fmt_val;

    fuses = pfile_value_find(pf, PFILE_LOG_ERR, "_fuses");
    if (pic_is_16bit(pf)) {
      config  = "__config";
      fmt_pos = " 0x%08x";
      fmt_val = " 0x%02x\n";
    } else {
      config  = "__config";
      fmt_pos = " 0x%04x";
      fmt_val = " 0x%04x\n";
    }
    if (value_is_array(fuses)) {
      value_t       base;
      variable_ct_t ii;

      base = pfile_value_find(pf, PFILE_LOG_ERR, "_fuse_base");
      if (value_ct_get(base) != value_ct_get(fuses)) {
        pfile_log(pf, PFILE_LOG_ERR,
            "_fuses and _fuses_base must contain the same number of entries");
      }
      for (ii = 0; ii < value_ct_get(fuses); ii++) {
        value_t tfuses;
        value_t tbase;

        tfuses = value_subscript_set(fuses, ii);
        tbase  = value_subscript_set(base, ii);
        pfile_write(pf, pfile_write_asm, "%37s", config);
        pfile_write(pf, pfile_write_asm, fmt_pos, value_const_get(tbase));
        pfile_write(pf, pfile_write_asm, ",");
        pfile_write(pf, pfile_write_asm, fmt_val, value_const_get(tfuses));
        value_release(tbase);
        value_release(tfuses);
      }
      value_release(base);
    } else {
      pfile_write(pf, pfile_write_asm, "%37s", config);
      pfile_write(pf, pfile_write_asm, fmt_val, value_const_get(fuses));
    }
    value_release(fuses);
  }
  /* set some useful macros; these are done as absolute address because
   * it's easier than trying to determine what the true variable names
   * will be */
  switch (pic_target_cpu_get(pf)) {
    case PIC_TARGET_CPU_NONE:
      break;
    case PIC_TARGET_CPU_12BIT:
      pic12_asm_header_write(pf, n_code_sz);
      break;
    case PIC_TARGET_CPU_14BIT:
      pic14_asm_header_write(pf, n_code_sz);
      break;
    case PIC_TARGET_CPU_16BIT:
      /* must mark _banked and _access as used! */
      {
        value_t tmp;

        tmp = pfile_value_find(pf, PFILE_LOG_ERR, "_banked");
        value_use_ct_bump(tmp, CTR_BUMP_INCR);
        value_release(tmp);

        tmp = pfile_value_find(pf, PFILE_LOG_ERR, "_access");
        value_use_ct_bump(tmp, CTR_BUMP_INCR);
        value_release(tmp);
      }
      break;
    case PIC_TARGET_CPU_14HBIT:
      pic14h_asm_header_write(pf, n_code_sz);
      break;
    case PIC_TARGET_CPU_SX_12:
      break;
  }
  {
    label_t       lptr;
    pfile_proc_t *proc;

    for (proc = pfile_proc_root_get(pf);
         proc;
         proc = pfile_proc_next(proc)) {
      pfile_block_t *blk;

      for (blk = pfile_proc_block_root_get(proc);
           blk;
           blk = pfile_block_next(blk)) {
        variable_t vptr;

        for (vptr = pfile_block_variable_list_head(blk);
             vptr;
             vptr = variable_link_get(vptr)) {
          variable_const_t vdef;

          if (variable_assign_ct_get(vptr) || variable_use_ct_get(vptr)) {
            const char *pname;

            pname = label_name_get(
                pfile_proc_label_get(
                  pfile_block_owner_get(
                    variable_user_data_get(vptr)
                  )
                )
              );
            if (variable_is_const(vptr)) {
              size_t sz;

              if (variable_use_ct_get(vptr) && !variable_is_array(vptr)) {
                vdef = variable_const_get(vptr, variable_def_get(vptr), 0);
                sz = pic_variable_tag_dump(pf, pfile_write_asm, vptr,
                    BOOLEAN_TRUE);
                sz += pfile_write(pf, pfile_write_asm,
                    "%*sEQU %u",
                    (sz < (PIC_LABEL_COLUMN_SZ - 1))
                    ? (PIC_LABEL_COLUMN_SZ - 1 - sz) : 1, "", vdef);
                if (pname) {
                  pfile_write(pf, pfile_write_asm, "%*s; %s(): %s\n",
                      (sz < 43) ? (43 - sz) : 1, " ",
                      pname,
                      variable_name_get(vptr));
                } else {
                  pfile_write(pf, pfile_write_asm, "\n");
                }
              }
            } else if (VARIABLE_DEF_TYPE_FUNCTION != variable_type_get(vptr)) {
              size_t     sz;
              variable_t master;

              vdef = variable_base_get(vptr, 0);

              sz = pic_variable_tag_dump(pf, pfile_write_asm, vptr,
                  BOOLEAN_TRUE);
              pfile_write(pf, pfile_write_asm,
                  "%*sEQU 0x%04x",
                  (sz < (PIC_LABEL_COLUMN_SZ - 1))
                  ? (PIC_LABEL_COLUMN_SZ - 1 - sz) : 1, "", vdef);
              master = variable_master_get(vptr);
              pfile_write(pf, pfile_write_asm, "  ; ");
              if (pname) {
                pfile_write(pf, pfile_write_asm, "%s:", pname);
              }
              pfile_write(pf, pfile_write_asm, "%s", variable_name_get(vptr));
              if (master) {
                variable_base_t offset;

                offset = variable_base_real_get(vptr, 0);
                pfile_write(pf, pfile_write_asm, "-->");
                pic_variable_name_write(pf, pfile_write_asm, master);
                if (offset) {
                  pfile_write(pf, pfile_write_asm, "+%u", offset);
                }
                if (variable_dflag_test(vptr, VARIABLE_DEF_FLAG_BIT)) {
                  pfile_write(pf, pfile_write_asm,
                      ":%u", variable_bit_offset_get(vptr));
                }
              }
              pfile_write(pf, pfile_write_asm, "\n");
            }
          }
        }
      }
    }
    for (lptr = pfile_label_temp_head_get(pf);
         lptr;
         lptr = label_link_get(lptr)) {
      if (label_flag_test(lptr, LABEL_FLAG_USER)) {
        size_t sz;

        sz = pic_label_tag_dump(pf, pfile_write_asm, lptr, BOOLEAN_TRUE);
        pfile_write(pf, pfile_write_asm,
            "%*sEQU 0x%04x\n",
            (sz < PIC_LABEL_COLUMN_SZ - 1)
          ? (PIC_LABEL_COLUMN_SZ - 1 -sz) : 1, "", label_pc_get(lptr));
      }
    }
  }
}

#define LIT_INVALID ((unsigned) -1)
static void pic_opt_verify16(pfile_t *pf)
{
  pic_code_t code;
  unsigned   dact;
  unsigned   dact_err;
  unsigned   bank_sz;

  dact     = 0;
  dact_err = 0;
  bank_sz  = pic_target_bank_size_get(pf);
  for (code = pic_code_list_head_get(pf);
       code;
       code = pic_code_next_get(code)) {
    if (pic_code_depth_get(code) != -1U) {
      value_t      val;

      val = pic_code_value_get(code);
      /*
       * movlw -- no warning, this is taking the address of the variable
       * lfsr  -- ignores BSR using all 16 bits of the variable
       */
      if (val 
          && !value_is_shared(val)
          && (PIC_OPCODE_MOVLW != pic_code_op_get(code))
          && (PIC_OPCODE_LFSR != pic_code_op_get(code))) {

        dact++;
        if ((PIC_BSR_INDETERMINATE == pic_code_bsr_get(code))
          || ((pic_code_bsr_get(code) * bank_sz 
            + (value_base_get(val) & (bank_sz - 1))
            != value_base_get(val)))) {
          pfile_log(pf, PFILE_LOG_WARN,
            "data error at 0x%08lx (got %x expected %x)",
            (unsigned long) pic_code_pc_get(code),
            (pic_code_bsr_get(code) * bank_sz
            + (value_base_get(val) & (bank_sz - 1))),
            value_base_get(val)); 
          dact_err++;
        }
      }
    }
  }
  pfile_log(pf, PFILE_LOG_INFO, "%u data accesses checked, %u errors",
    dact, dact_err);
}

static void pic_opt_verify14h(pfile_t *pf)
{
  pic_code_t code;
  unsigned   brct;
  unsigned   brct_err;

  brct     = 0;
  brct_err = 0;
  for (code = pic_code_list_head_get(pf);
       code;
       code = pic_code_next_get(code)) {
    /*
     * See the coment above pic_opt_verify.
     */
    if (pic_code_depth_get(code) != -1U) {
      pic_opcode_t op;

      op = pic_code_op_get(code);
      if ((PIC_OPCODE_GOTO == op)
        || (PIC_OPCODE_CALL == op)) {
        label_t            dst;
        pic_pc_t           dst_pc;
        pic_pclath_state_t pclath;
        
        dst    = pic_code_brdst_get(code);
        dst_pc = label_pc_get(dst);
        pic_code_pclath_get(code, &pclath);

        brct++;
        if ((dst_pc >> 8) != pclath.before) {
          pfile_log(pf, PFILE_LOG_WARN, "branch error at 0x%04x:"
            " pclath 0x%04x, should be 0x%04x",
            (unsigned) pic_code_pc_get(code),
            (unsigned) pclath.before,
            (unsigned) dst_pc >> 8);
          brct_err++;
        }
      }
    }
  }
  pfile_log(pf, PFILE_LOG_INFO, "%u branches checked, %u errors",
    brct, brct_err);
}

/* 
 * Go through the code looking for all call/goto operations
 * and data operations. Make sure the various bits are set
 * correctly such that the destination or variable is reachable
 */
static void pic_opt_verify14(pfile_t *pf)
{
  pic_code_t code;
  unsigned   brct;
  unsigned   brct_err;
  unsigned   dact;
  unsigned   dact_err;

  brct     = 0;
  brct_err = 0;
  dact     = 0;
  dact_err = 0;
  for (code = pic_code_list_head_get(pf);
       code;
       code = pic_code_next_get(code)) {
    /* See the comment above pic_opt_verify. */
    if (pic_code_depth_get(code) != -1U) {
      pic_opcode_t op;

      op = pic_code_op_get(code);

      if ((PIC_OPCODE_GOTO == op)
          || (PIC_OPCODE_CALL == op)) {
        label_t                dst;
        unsigned               lit;
        pic_branchbits_state_t bbits;

        dst = pic_code_brdst_get(code);
        lit = label_pc_get(dst) & (pic_target_page_size_get(pf) - 1);
        pic_code_branchbits_get(code, &bbits);
        if (PIC_BITSTATE_SET == bbits.before.pclath3) {
          lit |= pic_target_page_size_get(pf);
        } else if (PIC_BITSTATE_CLR != bbits.before.pclath3) {
          lit = LIT_INVALID;
        }
        if (PIC_BITSTATE_SET == bbits.before.pclath4) {
          lit |= 2 * pic_target_page_size_get(pf);
        } else if (PIC_BITSTATE_CLR != bbits.before.pclath4) {
          lit = LIT_INVALID;
        }
        brct++;
        if ((LIT_INVALID == lit) || (lit != label_pc_get(dst))) {
          pfile_log(pf, PFILE_LOG_WARN, 
            "branch error at 0x%04x: got 0x%04x expected 0x%04x",
                (unsigned) pic_code_pc_get(code), 
                lit, 
                (unsigned) label_pc_get(dst));
          brct_err++;
        }
      } else if (
           (PIC_OPCODE_DATALO_CLR != op)
        && (PIC_OPCODE_DATALO_SET != op)
        && (PIC_OPCODE_DATAHI_CLR != op)
        && (PIC_OPCODE_DATAHI_SET != op)
        && (PIC_OPCODE_MOVLW != op)) {
        value_t val;

        val = pic_code_value_get(code);
        if (val && !value_is_shared(val)) {
          pic_databits_state_t dbits;
          pic_opcode_t         op_datalo;
          pic_opcode_t         op_datahi;
          boolean_t            err;

          op_datalo = pic_value_datalo_get(pf, val);
          op_datahi = pic_value_datahi_get(pf, val);
          pic_code_databits_get(code, &dbits);

          err = BOOLEAN_FALSE;
          if (PIC_OPCODE_NONE != op_datalo) {
            if (PIC_OPCODE_DATALO_SET == op_datalo) {
              err = PIC_BITSTATE_SET != dbits.before.rp0;
            } else {
              err = PIC_BITSTATE_CLR != dbits.before.rp0;
            }
          }

          if (PIC_OPCODE_NONE != op_datahi) {
            if (PIC_OPCODE_DATAHI_SET == op_datahi) {
              err = PIC_BITSTATE_SET != dbits.before.rp1;
            } else {
              err = PIC_BITSTATE_CLR != dbits.before.rp1;
            }
          }

          dact++;
          if (err) {
            pfile_log(pf, PFILE_LOG_WARN,
              "data error at 0x%04x",
                  (unsigned) pic_code_pc_get(code)); 
            dact_err++;
          }
        }
      }
    }
  }
  pfile_log(pf, PFILE_LOG_INFO, "%u branches checked, %u errors",
    brct, brct_err);
  pfile_log(pf, PFILE_LOG_INFO, "%u data accesses checked, %u errors",
    dact, dact_err);
}

/*
 * Verify that the skip instructions (btfss, btfsc, etc.) do not skip
 * data or code bit operations. The only time this is currently valid
 * is with IRP, and then the sequence must be:
 *    bcf IRP,...
 *    btfsc ...
 *    bsf IRP,...
 */
static void pic_opt_verify_skip(pfile_t *pf)
{
  pic_code_t code;
  unsigned   skipct;
  unsigned   skipct_err;
  boolean_t  last_was_sc; /* last was skip conditional */

  skipct      = 0;
  skipct_err  = 0;
  last_was_sc = BOOLEAN_FALSE;
  for (code = pic_code_list_head_get(pf);
       code;
       code = pic_code_next_get(code)) {
    if (pic_code_depth_get(code) != -1U) {
      if (pic_code_is_exec(code)) {
        switch (pic_code_op_get(code)) {
          case PIC_OPCODE_BTFSC:
          case PIC_OPCODE_BTFSS:
          case PIC_OPCODE_DECFSZ:
          case PIC_OPCODE_DCFSNZ:
          case PIC_OPCODE_INCFSZ:
          case PIC_OPCODE_INFSNZ:
            last_was_sc = BOOLEAN_TRUE;
            skipct++;
            break;
          default:
            if (last_was_sc) {
              switch (pic_code_op_get(code)) {
                case PIC_OPCODE_MOVLB:
                case PIC_OPCODE_MOVLP:
                case PIC_OPCODE_DATALO_CLR:
                case PIC_OPCODE_DATALO_SET:
                case PIC_OPCODE_DATAHI_CLR:
                case PIC_OPCODE_DATAHI_SET:
                case PIC_OPCODE_BRANCHLO_CLR:
                case PIC_OPCODE_BRANCHLO_SET:
                case PIC_OPCODE_BRANCHHI_CLR:
                case PIC_OPCODE_BRANCHHI_SET:
                  pfile_log(pf, PFILE_LOG_WARN,
                    "skip error at 0x%04x",
                      (unsigned) pic_code_pc_get(code));
                  skipct_err++;
                  break;
                default:
                  break;
              }
              last_was_sc = BOOLEAN_FALSE;
            }
        }
      }
    }
  }
  pfile_log(pf, PFILE_LOG_INFO, "%u skips checked, %u errors",
    skipct, skipct_err);
  
}

/*
 * Sometimes a bit of code will either go unused, or appear unused.
 * If this bit has the NO_OPTIMIZE flag set, then it will not be removed
 * but also it will not have the appropriate bank/data/bsr bits set.
 * In that case, just skip the check. If this is caused by the compiler
 * determining during PIC code generation that a variable is really
 * constant, no issues as the code really isn't used. Alternately, if
 * it's caused by a user implementing a jump table (which the compiler
 * cannot see) it's the user's responsibility to determine that everything
 * is set up correctly.
 *   Another way to handle this is to separate out NO_OPTIMIZE (user
 * requested) and NO_OPTIMIZE (internal compiler) and allow the later to
 * be removed.
 */
static void pic_opt_verify(pfile_t *pf)
{
  if (0 == pfile_errct_get(pf)) {
    if (pic_is_14bit(pf)) {
      pic_opt_verify14(pf);
    } else if (pic_is_14bit_hybrid(pf)) {
      pic_opt_verify14h(pf);
      pic_opt_verify16(pf);
    } else if (pic_is_16bit(pf)) {
      pic_opt_verify16(pf);
    }
    pic_opt_verify_skip(pf);
  }
}

/*
 * NAME
 *   pic_cmd_generate
 *
 * DESCRIPTION
 *   populate the pic_codes[] array
 *
 * PARAMETERS
 *   pf  :
 *   cmd : first command
 *
 * RETURN
 *   none
 *
 * NOTES
 */
void pic_cmd_generate(pfile_t *pf, const cmd_t cmd)
{
  label_t       lbl_tmp;
  cmd_t         cmd_ptr;
  pic_code_t    code;
  pfile_proc_t *proc;
  value_t       chipdef;

  chipdef = pfile_value_find(pf, PFILE_LOG_NONE, "target_cpu");
  if (VALUE_NONE == chipdef) {
    pfile_log(pf, PFILE_LOG_WARN,
        "target cpu not defined, assuming 14 bit core");
    pic_target_cpu_set(pf, PIC_TARGET_CPU_14BIT);
  } else {
    pic_target_cpu_set(pf, value_const_get(chipdef));
    if ((PIC_TARGET_CPU_12BIT != pic_target_cpu)
        && (PIC_TARGET_CPU_14BIT != pic_target_cpu)
        && (PIC_TARGET_CPU_16BIT != pic_target_cpu)
        && (PIC_TARGET_CPU_14HBIT != pic_target_cpu)) {
      pfile_log(pf, PFILE_LOG_ERR, "Unsupported core: %u", pic_target_cpu);
    }
    value_release(chipdef);
  }

  chipdef = pfile_value_find(pf, PFILE_LOG_NONE, "target_bank_size");
  if (VALUE_NONE == chipdef) {
    pfile_log(pf, PFILE_LOG_WARN,
        "target bank size not defined, assuming 0x80");
    pic_target_bank_size = 0x80;
  } else {
    pic_target_bank_size = value_const_get(chipdef);
    value_release(chipdef);
  }

  chipdef = pfile_value_find(pf, PFILE_LOG_NONE, "target_page_size");
  if ((VALUE_NONE == chipdef) && (PIC_TARGET_CPU_16BIT != pic_target_cpu)) {
    pfile_log(pf, PFILE_LOG_WARN,
        "target page size not defined, assuming 0x0800");
    pic_target_page_size = 0x0800;
  } else {
    pic_target_page_size = value_const_get(chipdef);
    value_release(chipdef);
  }

  lbl_tmp = pfile_lblptr_get(pf);
  /* define the processor (this needs to be changed) */
  pic_code_list_init(pf);
  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    pfile_proc_frame_sz_calc(proc);
  }
  for (pic_code_gen_pass = 0;
       (pic_code_gen_pass < 2) && !pfile_errct_get(pf);
       pic_code_gen_pass++) {
    pfile_log(pf, PFILE_LOG_INFO, PIC_MSG_GENERATING_CODE,
      1 + pic_code_gen_pass);
    if (1 == pic_code_gen_pass) {
      pic_code_list_reset(pf);
      pic_last_values_reset();
      pfile_lblptr_set(pf, lbl_tmp);
      pic_code_preamble(pf);
    }

    for (code = pic_code_list_head_get(pf);
         code;
         code = pic_code_next_get(code)) {
      pic_code_cmd_set(code, cmd);
    }
    for (cmd_ptr = cmd; cmd_ptr; cmd_ptr = cmd_link_get(cmd_ptr)) {
      if (cmd_is_reachable(cmd_ptr)) {
        pic_cmd_out(pf, &cmd_ptr);
      }
    }
    if (0 == pic_code_gen_pass) {
      /* we need to create the intrinsic functions here. that guarentees
       * any needed internal variables are also created */
      pic_code_preamble(pf);
      pic_variable_counters_set(pf);
      pic_variable_alloc(pf);
    }
  }

  pic_w_value_optimize(pf);
  pic_code_branch_optimize(pf);
  pic_code_return_literal_optimimze(pf);
  pic_code_branch_optimize(pf);
  pic_code_bsr_optimize(pf);
  pic_code_free_unused(pf);
  pic_code_skip_cond_optimize(pf);
  pic_code_databits_optimize(pf);
  pic_code_databits_remove(pf);
  pic_w_value_optimize1(pf);
  /* each time something is removed, we must again go through the branchbits
     optimization. otherwise the code could be larger than necessary.
     For example, say the code is 2K + 1 byte. The first branchbits_optimize
     will have to address both PCLATH bits. brnachbits_remove() will notice
     the smaller size and remove all PCLATH<4> instructions. When these
     instructions are removed, the code size could fall below 2K in which
     case there is no reason to have *any* PCLATH instructions */
  if (pic_is_12bit(pf) || pic_is_14bit(pf)) {
    pic_code_branchbits_remove(pf);
    do {
      pic_code_branchbits_optimize(pf);
    } while (pic_code_branchbits_remove(pf));
  } else if (pic_is_14bit_hybrid(pf)) {
    pic_code_movlp_optimize(pf);
  } else {
    pic_branchbits_pc_set(pf, PIC_BRANCHBITS_PC_SET_FLAG_NONE);
  }
  /*
   * finally, let's verify that the optimizations worked!
   */
  pic_stack_depth_get(pf);
  pic_opt_verify(pf);
  /* nb: no 16bit branch optimizations yet */
  pic_code_free_unused(pf);
  /* printf("PIC analyze max depth: %u\n", max_depth); */
  /* pic_cmd_dump(pf); */
  /* note: i'll also need to analyze starting at the interrupt vector (4) */
  {
    char *chip_name;

    chip_name = pic_chip_name_get(pf);
    pic_variable_counters_set(pf);
    pic_asm_header_write(pf, chip_name);
    FREE(chip_name);
  }
  /* now that we've made it this far, let's set each pointer type */
  /*pic_variable_pointer_bits_set(pf);*/
}

boolean_t pic_opcode_is_conditional(pic_opcode_t op)
{
  return (PIC_OPCODE_INCFSZ == op)
    || (PIC_OPCODE_DECFSZ == op)
    || (PIC_OPCODE_BTFSC == op)
    || (PIC_OPCODE_BTFSS == op);
}

boolean_t pic_opcode_is_pseudo_op(pic_opcode_t op)
{
  return (PIC_OPCODE_ORG == op)
      || (PIC_OPCODE_END == op)
      || (PIC_OPCODE_NONE == op)
      || (PIC_OPCODE_BRANCHLO_NOP == op)
      || (PIC_OPCODE_BRANCHHI_NOP == op);
}

boolean_t pic_code_modifies_pcl(pfile_t *pf, pic_code_t code)
{
  pic_opcode_t op;
  boolean_t    rc;

  op = pic_code_op_get(code);
  rc = BOOLEAN_FALSE;
  switch (op) {
    case PIC_OPCODE_MOVWF:
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
    case PIC_OPCODE_RLF:
    case PIC_OPCODE_RRF:
    case PIC_OPCODE_SWAPF:
    case PIC_OPCODE_CLRF:
    case PIC_OPCODE_BCF:
    case PIC_OPCODE_BSF:
      /* if this is an operation on which the dest is _pcl,
       * treat it as a return */
      if ((PIC_OPCODE_MOVWF == op)
          || (PIC_OPDST_F == pic_code_dst_get(code))) {
        value_t    val;
        variable_t var;

        val = pic_code_value_get(code);
        var = pfile_variable_find(pf, PFILE_LOG_ERR, "_pcl", 0);
        if (value_variable_get(val) == var) {
          rc = BOOLEAN_TRUE;
        }
        variable_release(var);
      }
      break;

    default:
      break;
  }
  return rc;
}

/*
 * return TRUE if the code modifies the <status:z>
 */
boolean_t pic_code_modifies_z(pic_code_t code)
{
  pic_opcode_t op;
  boolean_t    rc;

  op = pic_code_op_get(code);
  rc = BOOLEAN_FALSE;
  switch (op) {
  case PIC_OPCODE_ORG:
  case PIC_OPCODE_END:
  case PIC_OPCODE_NONE:
  case PIC_OPCODE_RETLW:
  case PIC_OPCODE_TRIS:
  case PIC_OPCODE_MULLW:
  case PIC_OPCODE_SWAPF:
  case PIC_OPCODE_CPFSEQ:
  case PIC_OPCODE_CPFSGT:
  case PIC_OPCODE_CPFSLT:
  case PIC_OPCODE_MOVWF:
  case PIC_OPCODE_MULWF:
  case PIC_OPCODE_SETF:
  case PIC_OPCODE_TSTFSZ:
  case PIC_OPCODE_BCF:
  case PIC_OPCODE_BSF:
  case PIC_OPCODE_BTFSC:
  case PIC_OPCODE_BTFSS:
  case PIC_OPCODE_BTG:
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
  case PIC_OPCODE_CALL:
  case PIC_OPCODE_GOTO:
  case PIC_OPCODE_CLRWDT:
  case PIC_OPCODE_DAW:
  case PIC_OPCODE_NOP:
  case PIC_OPCODE_OPTION:
  case PIC_OPCODE_POP:
  case PIC_OPCODE_PUSH:
  case PIC_OPCODE_RESET:
  case PIC_OPCODE_RETURN:
  case PIC_OPCODE_RETFIE:
  case PIC_OPCODE_SLEEP:
  case PIC_OPCODE_LFSR:
  case PIC_OPCODE_MOVFF:
  case PIC_OPCODE_MOVLB:
  case PIC_OPCODE_MOVLP:
  case PIC_OPCODE_MOVLP_NOP:
  case PIC_OPCODE_TBLRD:
  case PIC_OPCODE_TBLWT:
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
  case PIC_OPCODE_DB:
    rc = BOOLEAN_FALSE;
    break;
  case PIC_OPCODE_ADDLW:
  case PIC_OPCODE_ANDLW:
  case PIC_OPCODE_IORLW:
  case PIC_OPCODE_MOVLW:
  case PIC_OPCODE_SUBLW:
  case PIC_OPCODE_XORLW:
  case PIC_OPCODE_ADDWF:
  case PIC_OPCODE_ADDWFc:
  case PIC_OPCODE_ANDWF:
  case PIC_OPCODE_COMF:
  case PIC_OPCODE_DECF:
  case PIC_OPCODE_DCFSNZ:
  case PIC_OPCODE_DECFSZ:
  case PIC_OPCODE_INCF:
  case PIC_OPCODE_INCFSZ:
  case PIC_OPCODE_INFSNZ:
  case PIC_OPCODE_IORWF:
  case PIC_OPCODE_MOVF:
  case PIC_OPCODE_RLF:
  case PIC_OPCODE_RLCF:
  case PIC_OPCODE_RLNCF:
  case PIC_OPCODE_RRF:
  case PIC_OPCODE_RRCF:
  case PIC_OPCODE_RRNCF:
  case PIC_OPCODE_SUBFWB:
  case PIC_OPCODE_SUBWF:
  case PIC_OPCODE_SUBWFB:
  case PIC_OPCODE_XORWF:
  case PIC_OPCODE_CLRF:
  case PIC_OPCODE_NEGF:
  case PIC_OPCODE_CLRW:
    rc = BOOLEAN_TRUE;
    break;
  }
  return rc;
}


pic_target_cpu_t pic_target_cpu_get(pfile_t *pf)
{
  UNUSED(pf);

  return pic_target_cpu;
}

void pic_target_cpu_set(pfile_t *pf, pic_target_cpu_t target)
{
  UNUSED(pf);

  pic_target_cpu = target;
}

unsigned pic_target_bank_size_get(pfile_t *pf)
{
  UNUSED(pf);

  return pic_target_bank_size;
}

void pic_target_bank_size_set(pfile_t *pf, unsigned sz)
{
  UNUSED(pf);

  if (sz & (sz - 1)) {
    pfile_log(pf, PFILE_LOG_ERR, "Bank size must be a power of 2");
  }
  pic_target_bank_size = sz;
}

unsigned pic_target_page_size_get(pfile_t *pf)
{
  UNUSED(pf);

  return pic_target_page_size;
}

void pic_target_page_size_set(pfile_t *pf, unsigned sz)
{
  UNUSED(pf);

  if (sz & (sz - 1)) {
    pfile_log(pf, PFILE_LOG_ERR, "Page size must be a power of 2");
  }
  pic_target_page_size = sz;
}

boolean_t pic_is_12bit(pfile_t *pf)
{
  return (PIC_TARGET_CPU_12BIT == pic_target_cpu_get(pf));
}

boolean_t pic_is_14bit(pfile_t *pf)
{
  return (PIC_TARGET_CPU_14BIT == pic_target_cpu_get(pf));
}

boolean_t pic_is_14bit_hybrid(pfile_t *pf)
{
  return (PIC_TARGET_CPU_14HBIT == pic_target_cpu_get(pf));
}

boolean_t pic_is_16bit(pfile_t *pf)
{
  return (PIC_TARGET_CPU_16BIT == pic_target_cpu_get(pf));
}

boolean_t pic_in_isr(pfile_t *pf)
{
  UNUSED(pf);

  return pic_in_isr_flag;
}

unsigned pic_code_gen_pass_get(pfile_t *pf)
{
  UNUSED(pf);

  return pic_code_gen_pass;
}

value_t pic_indirect_get(pfile_t *pf, pfile_log_t plog, size_t which)
{
  value_t val;

  val = VALUE_NONE;
  if (0 == which) {
    /* 0 is special -- it can be either "_ind" or "_ind0" */
    val = pfile_value_find(pf, PFILE_LOG_NONE, "_ind");
  }
  if (VALUE_NONE == val) {
    char name[16];

    sprintf(name, "_ind%u", (unsigned) which);
    val = pfile_value_find(pf, plog, name);
  }
  return val;
}

variable_sz_t pic_pointer_size_get(pfile_t *pf)
{
  if (PIC_TARGET_CPU_NONE == pic_target_cpu_get(pf)) {
    value_t          chipdef;

    chipdef = pfile_value_find(pf, PFILE_LOG_NONE, "target_cpu");
    if (VALUE_NONE == chipdef) {
      pfile_log(pf, PFILE_LOG_WARN,
          "target cpu not defined, assuming 14 bit core");
      pic_target_cpu = PIC_TARGET_CPU_14BIT;
    } else {
      pic_target_cpu = value_const_get(chipdef);
      if ((PIC_TARGET_CPU_12BIT != pic_target_cpu)
          && (PIC_TARGET_CPU_14BIT != pic_target_cpu)
          && (PIC_TARGET_CPU_14HBIT != pic_target_cpu)
          && (PIC_TARGET_CPU_16BIT != pic_target_cpu)) {
        pfile_log(pf, PFILE_LOG_ERR, "Unsupported core: %u", pic_target_cpu);
      }
      value_release(chipdef);
    }
  }
  return (pic_is_16bit(pf)) ? 3 : 2;
}

void pic_init(pfile_t *pf)
{
  UNUSED(pf);
}

static unsigned pic_flag;

void pic_flag_set(pfile_t *pf, unsigned flag)
{
  UNUSED(pf);
  pic_flag |= flag;
}

boolean_t pic_flag_test(pfile_t *pf, unsigned flag)
{
  UNUSED(pf);
  return (pic_flag & flag) == flag;
}

