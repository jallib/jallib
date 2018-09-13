/**********************************************************
 **
 ** cmd_asm.c : manipulators for cmd_asm_t
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <stdio.h>
#include <assert.h>
#include "../libutils/mem.h"
#include "../libpic12/pic_inst.h"
#include "cmdd.h"
#include "cmd_asm.h"

static void cmd_asm_dump_value(value_t val, const char *str, FILE *dst)
{
  if (val) {
    if (value_name_get(val)) {
      fprintf(dst, "%s%s", str, value_name_get(val));
    } else {
      fprintf(dst, "%s%u", str, (unsigned) value_const_get(val));
    }
  }
}

static void cmd_asm_dump(cmd_t cmd, FILE *dst)
{
  pic_optype_t type;

  fprintf(dst, "%s", pic_opcode_str(cmd_asm_op_get(cmd)));
  type = pic_optype_get(cmd_asm_op_get(cmd));
  switch (type) {
    case PIC_OPTYPE_NONE:
      break;
    case PIC_OPTYPE_F:
    case PIC_OPTYPE_F_D:
    case PIC_OPTYPE_F_B:
      cmd_asm_dump_value(cmd_asm_val_get(cmd), " ", dst);
      if (PIC_OPTYPE_F_D == type) {
        fprintf(dst, ", %s", pic_opdst_str(cmd_asm_opdst_get(cmd)));
      } else if (PIC_OPTYPE_F_B == type) {
        cmd_asm_dump_value(cmd_asm_n_get(cmd), ", ", dst);
      }
      break;
    case PIC_OPTYPE_N:
    case PIC_OPTYPE_TRIS:
      cmd_asm_dump_value(cmd_asm_n_get(cmd), " ", dst);
      break;
    case PIC_OPTYPE_K:
      if (cmd_asm_lbl_get(cmd)) {
        fprintf(dst, " %s", label_name_get(cmd_asm_lbl_get(cmd)));
      } else {
        cmd_asm_dump_value(cmd_asm_n_get(cmd), " ", dst);
      }
      break;
    case PIC_OPTYPE_DB:
      {
        uchar *data;
        size_t data_sz;
        size_t ii;

        data_sz = cmd_asm_data_sz_get(cmd);
        data    = cmd_asm_data_get(cmd);
        for (ii = 0; ii < data_sz; ii++) {
          fprintf(dst, "%u%s", data[ii], (ii + 1 < data_sz) ? "," : "");
        }
      }
      break;
  }
}

static void cmd_asm_free(cmd_t cmd)
{
  cmd_asm_val_set(cmd, VALUE_NONE);
  cmd_asm_n_set(cmd, VALUE_NONE);
  cmd_asm_lbl_set(cmd, LABEL_NONE);
  cmd_asm_data_set(cmd, 0, 0);
}

static cmd_t cmd_asm_dup(const cmd_t cmd)
{
  return cmd_asm_alloc(cmd_asm_op_get(cmd), cmd_asm_val_get(cmd),
    cmd_asm_valofs_get(cmd),
    cmd_asm_opdst_get(cmd), cmd_asm_n_get(cmd), cmd_asm_lbl_get(cmd),
    cmd_asm_flag_get_all(cmd),
    cmd_asm_data_sz_get(cmd),
    cmd_asm_data_get(cmd));
}

static void cmd_asm_label_remap(cmd_t cmd, const label_map_t *map)
{
  cmd_label_remap2(cmd, map, cmd_asm_lbl_get, cmd_asm_lbl_set);
}

static void cmd_asm_variable_remap(cmd_t cmd, const variable_map_t *map)
{
  cmd_variable_remap2(cmd, map, cmd_asm_val_get, cmd_asm_val_set);
  cmd_variable_remap2(cmd, map, cmd_asm_n_get, cmd_asm_n_set);
}

static void cmd_asm_value_remap(cmd_t cmd, const value_map_t *map)
{
  cmd_value_remap2(cmd, map, cmd_asm_val_get, cmd_asm_val_set);
  cmd_value_remap2(cmd, map, cmd_asm_n_get, cmd_asm_n_set);
}

static flag_t cmd_asm_variable_accessed(const cmd_t cmd, variable_t var)
{
  return ((value_variable_get(cmd_asm_val_get(cmd)) == var)
        || (value_variable_get(cmd_asm_n_get(cmd)) == var))
    ? CMD_VARIABLE_ACCESS_FLAG_READ | CMD_VARIABLE_ACCESS_FLAG_WRITTEN
    : CMD_VARIABLE_ACCESS_FLAG_NONE;
}

static flag_t cmd_asm_value_accessed(const cmd_t cmd, value_t val)
{
  return (cmd_asm_val_get(cmd) == val)
        || (cmd_asm_n_get(cmd) == val)
    ? CMD_VARIABLE_ACCESS_FLAG_READ | CMD_VARIABLE_ACCESS_FLAG_WRITTEN
    : CMD_VARIABLE_ACCESS_FLAG_NONE;
}

static void cmd_asm_assigned_use_set(cmd_t cmd)
{
  variable_t var;

  var = value_variable_get(cmd_asm_n_get(cmd));
  if ((VARIABLE_NONE != var) && !variable_is_const(var)) {
    switch (cmd_asm_op_get(cmd)) {
      case PIC_OPCODE_ORG:
      case PIC_OPCODE_END:
      case PIC_OPCODE_NONE:
      case PIC_OPCODE_TRIS:
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
      case PIC_OPCODE_TBLRD:
      case PIC_OPCODE_TBLWT:
      case PIC_OPCODE_DB:
      case PIC_OPCODE_ADDLW:
      case PIC_OPCODE_ANDLW:
      case PIC_OPCODE_IORLW:
      case PIC_OPCODE_MOVLW:
      case PIC_OPCODE_MULLW:
      case PIC_OPCODE_RETLW:
      case PIC_OPCODE_SUBLW:
      case PIC_OPCODE_XORLW:
      case PIC_OPCODE_BRANCHLO_SET:
      case PIC_OPCODE_BRANCHLO_CLR:
      case PIC_OPCODE_BRANCHLO_NOP:
      case PIC_OPCODE_BRANCHHI_SET:
      case PIC_OPCODE_BRANCHHI_CLR:
      case PIC_OPCODE_BRANCHHI_NOP:
      case PIC_OPCODE_MOVLP_NOP:
        break; /* should never get here */
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
        cmd_gen_add(cmd, var);
        if (PIC_OPDST_F == cmd_asm_opdst_get(cmd)) {
          cmd_kill_add(cmd, var);
        }
        break;
      case PIC_OPCODE_CPFSEQ:
      case PIC_OPCODE_CPFSGT:
      case PIC_OPCODE_CPFSLT:
      case PIC_OPCODE_TSTFSZ:
      case PIC_OPCODE_BTFSC:
      case PIC_OPCODE_BTFSS:
      case PIC_OPCODE_LFSR:
      case PIC_OPCODE_MOVLB:
      case PIC_OPCODE_MOVLP:
      case PIC_OPCODE_DATALO_SET:
      case PIC_OPCODE_DATALO_CLR:
      case PIC_OPCODE_DATAHI_SET:
      case PIC_OPCODE_DATAHI_CLR:
      case PIC_OPCODE_IRP_SET:
      case PIC_OPCODE_IRP_CLR:
        cmd_gen_add(cmd, var);
        break;
      case PIC_OPCODE_NEGF:
      case PIC_OPCODE_BTG:
        cmd_gen_add(cmd, var);
        cmd_kill_add(cmd, var);
        break;
      case PIC_OPCODE_SETF:
      case PIC_OPCODE_BCF:
      case PIC_OPCODE_BSF:
      case PIC_OPCODE_MOVWF:
      case PIC_OPCODE_MULWF:
      case PIC_OPCODE_CLRF:
        cmd_kill_add(cmd, var);
        break;
      case PIC_OPCODE_MOVFF:
        cmd_gen_add(cmd, var);
        /* cmd_kill_add(cmd, var2); */
        break;
    }
  }
}

static cmd_successor_rc_t cmd_asm_successor_get(cmd_t cmd, size_t ix, 
  cmd_t *dst)
{
  cmd_successor_rc_t rc;

  rc = CMD_SUCCESSOR_RC_IX_BAD;
  switch (cmd_asm_op_get(cmd)) {
    case PIC_OPCODE_ORG:
    case PIC_OPCODE_END:
    case PIC_OPCODE_NONE:
    case PIC_OPCODE_TRIS:
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
    case PIC_OPCODE_TBLRD:
    case PIC_OPCODE_TBLWT:
    case PIC_OPCODE_DB:
    case PIC_OPCODE_ADDLW:
    case PIC_OPCODE_ANDLW:
    case PIC_OPCODE_IORLW:
    case PIC_OPCODE_MOVLW:
    case PIC_OPCODE_MULLW:
    case PIC_OPCODE_RETLW:
    case PIC_OPCODE_SUBLW:
    case PIC_OPCODE_XORLW:
    case PIC_OPCODE_BRANCHLO_SET:
    case PIC_OPCODE_BRANCHLO_CLR:
    case PIC_OPCODE_BRANCHLO_NOP:
    case PIC_OPCODE_BRANCHHI_SET:
    case PIC_OPCODE_BRANCHHI_CLR:
    case PIC_OPCODE_BRANCHHI_NOP:
    case PIC_OPCODE_MOVLP_NOP:
    case PIC_OPCODE_ADDWF:
    case PIC_OPCODE_ADDWFc:
    case PIC_OPCODE_ANDWF:
    case PIC_OPCODE_COMF:
    case PIC_OPCODE_DECF:
    case PIC_OPCODE_INCF:
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
    case PIC_OPCODE_MULWF:
    case PIC_OPCODE_LFSR:
    case PIC_OPCODE_MOVLB:
    case PIC_OPCODE_MOVLP:
    case PIC_OPCODE_DATALO_SET:
    case PIC_OPCODE_DATALO_CLR:
    case PIC_OPCODE_DATAHI_SET:
    case PIC_OPCODE_DATAHI_CLR:
    case PIC_OPCODE_IRP_SET:
    case PIC_OPCODE_IRP_CLR:
    case PIC_OPCODE_NEGF:
    case PIC_OPCODE_BTG:
    case PIC_OPCODE_SETF:
    case PIC_OPCODE_BCF:
    case PIC_OPCODE_BSF:
    case PIC_OPCODE_MOVWF:
    case PIC_OPCODE_CLRF:
    case PIC_OPCODE_MOVFF:
      if (0 == ix) {
        *dst = cmd_link_get(cmd);
        rc = CMD_SUCCESSOR_RC_DONE;
      } 
      break;
    case PIC_OPCODE_DCFSNZ:
    case PIC_OPCODE_DECFSZ:
    case PIC_OPCODE_INCFSZ:
    case PIC_OPCODE_INFSNZ:
    case PIC_OPCODE_CPFSEQ:
    case PIC_OPCODE_CPFSGT:
    case PIC_OPCODE_CPFSLT:
    case PIC_OPCODE_TSTFSZ:
    case PIC_OPCODE_BTFSC:
    case PIC_OPCODE_BTFSS:
      /* successor is both the next command or the command that follows */
      if (0 == ix) {
        *dst = cmd_link_get(cmd);
        rc = CMD_SUCCESSOR_RC_MORE;
      } else if (1 == ix) {
        *dst = cmd_link_get(cmd_link_get(cmd));
        rc = CMD_SUCCESSOR_RC_DONE;
      }
      break;
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
      /* successor is both the next command or the label */
      if (0 == ix) {
        *dst = cmd_link_get(cmd);
        rc = CMD_SUCCESSOR_RC_MORE;
      } else if (1 == ix) {
        *dst = label_cmd_get(cmd_asm_lbl_get(cmd));
        rc = CMD_SUCCESSOR_RC_DONE;
      }
      break;
    case PIC_OPCODE_GOTO:
      /* successor is only the label */
      if (0 == ix) {
        *dst = label_cmd_get(cmd_asm_lbl_get(cmd));
        rc = CMD_SUCCESSOR_RC_DONE;
      }
      break;
  }
  return rc;
}

static const cmd_vtbl_t cmd_asm_vtbl = {
  cmd_asm_free,
  cmd_asm_dump,
  cmd_asm_dup,
  cmd_asm_label_remap,
  cmd_asm_variable_remap,
  cmd_asm_value_remap,
  cmd_asm_variable_accessed,
  cmd_asm_value_accessed,
  cmd_asm_assigned_use_set,
  cmd_asm_successor_get
};

cmd_t cmd_asm_alloc(pic_opcode_t op, value_t val, size_t valofs,
    pic_opdst_t opdst, value_t n, label_t lbl, flag_t flags,
    size_t data_sz, uchar *data)
{
  cmd_t cmd;

  cmd = cmd_alloc(CMD_TYPE_ASM, &cmd_asm_vtbl);
  if (cmd) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      ptr->u.op_asm.op      = op;
      ptr->u.op_asm.val     = VALUE_NONE;
      ptr->u.op_asm.valofs  = valofs;
      ptr->u.op_asm.opdst   = opdst;
      ptr->u.op_asm.n       = VALUE_NONE;
      ptr->u.op_asm.lbl     = LABEL_NONE;
      ptr->u.op_asm.flags   = flags;
      ptr->u.op_asm.data_sz = 0;
      ptr->u.op_asm.data    = 0;
      
      cmd_asm_val_set(cmd, val);
      cmd_asm_n_set(cmd, n);
      cmd_asm_lbl_set(cmd, lbl);
      cmd_asm_data_set(cmd, data_sz, data);
    }
  }
  return cmd;
}

pic_opcode_t cmd_asm_op_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = 0;
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  }
  return (ptr) ? ptr->u.op_asm.op : PIC_OPCODE_NONE;
}

void cmd_asm_op_set(cmd_t cmd, pic_opcode_t op)
{
  assert(CMD_TYPE_ASM == cmd_type_get(cmd));
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      ptr->u.op_asm.op = op;
    }
  }
}

value_t cmd_asm_val_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = 0;
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  }
  return (ptr) ? ptr->u.op_asm.val : VALUE_NONE;
}

void cmd_asm_val_set(cmd_t cmd, value_t val)
{
  struct cmd_ *ptr;

  assert(CMD_TYPE_ASM == cmd_type_get(cmd));
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      /* if a varaible is used in an assembly statement, mark it both
       * assigned *and* used */
      value_lock(val);
      value_assign_ct_bump(ptr->u.op_asm.val, CTR_BUMP_DECR);
      value_use_ct_bump(ptr->u.op_asm.val, CTR_BUMP_DECR);
      value_release(ptr->u.op_asm.val);
      ptr->u.op_asm.val = val;
      value_assign_ct_bump(val, CTR_BUMP_INCR);
      value_use_ct_bump(val, CTR_BUMP_INCR);
    }
  }
}

size_t cmd_asm_valofs_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = 0;
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  }
  return (ptr) ? ptr->u.op_asm.valofs : 0;
}

void cmd_asm_valofs_set(cmd_t cmd, size_t valofs)
{

  assert(CMD_TYPE_ASM == cmd_type_get(cmd));
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      /* if a varaible is used in an assembly statement, mark it both
       * assigned *and* used */
      ptr->u.op_asm.valofs = valofs;
    }
  }
}

pic_opdst_t  cmd_asm_opdst_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = 0;
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  }
  return (ptr) ? ptr->u.op_asm.opdst : PIC_OPDST_NONE;
}

void cmd_asm_opdst_set(cmd_t cmd, pic_opdst_t dst)
{
  assert(CMD_TYPE_ASM == cmd_type_get(cmd));
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      ptr->u.op_asm.opdst = dst;
    }
  }
}

value_t cmd_asm_n_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = 0;
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  }
  return (ptr) ? ptr->u.op_asm.n : VALUE_NONE;
}

void         cmd_asm_n_set(cmd_t cmd, value_t n)
{
  assert(CMD_TYPE_ASM == cmd_type_get(cmd));
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      value_lock(n);
      value_use_ct_bump(ptr->u.op_asm.n, CTR_BUMP_DECR);
      value_release(ptr->u.op_asm.n);
      ptr->u.op_asm.n = n;
      value_use_ct_bump(n, CTR_BUMP_INCR);
    }
  }
}

label_t cmd_asm_lbl_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = 0;
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  }
  return (ptr) ? ptr->u.op_asm.lbl : LABEL_NONE;
}

void cmd_asm_lbl_set(cmd_t cmd, label_t lbl)
{
  assert(CMD_TYPE_ASM == cmd_type_get(cmd));
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      label_lock(lbl);
      label_usage_bump(ptr->u.op_asm.lbl, CTR_BUMP_DECR);
      label_release(ptr->u.op_asm.lbl);
      ptr->u.op_asm.lbl = lbl;
      label_usage_bump(lbl, CTR_BUMP_INCR);
    }
  }
}

boolean_t cmd_asm_flag_test(const cmd_t cmd, flag_t flag)
{
  const struct cmd_ *ptr;

  ptr = 0;
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  }
  return (ptr) ? (ptr->u.op_asm.flags & flag) == flag : 0;
}

flag_t cmd_asm_flag_get_all(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = 0;
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  }
  return (ptr) ? ptr->u.op_asm.flags : 0;
}

size_t cmd_asm_data_sz_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = 0;
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  }
  return (ptr) ? ptr->u.op_asm.data_sz : 0;
}

uchar *cmd_asm_data_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = 0;
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  }
  return (ptr) ? ptr->u.op_asm.data : 0;
}

void   cmd_asm_data_set(cmd_t cmd, size_t sz, uchar *data)
{
  assert(CMD_TYPE_ASM == cmd_type_get(cmd));
  if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      FREE(ptr->u.op_asm.data);
      ptr->u.op_asm.data_sz = sz;
      ptr->u.op_asm.data    = data;
    }
  }
}

