/************************************************************
 **
 ** pic_inst.c : PIC instruction generation definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <string.h>
#include <assert.h>

#include "piccolst.h"
#include "pic12.h"
#include "pic14.h"
#include "pic14h.h"
#include "pic16.h"
#include "pic_inst.h"

static flag_t pic_instr_default_flags;

void pic_instr_default_flag_set(pfile_t *pf, flag_t flags)
{
  UNUSED(pf);

  pic_instr_default_flags |= flags;
}

void pic_instr_default_flag_clr(pfile_t *pf, flag_t flags)
{
  UNUSED(pf);

  pic_instr_default_flags &= ~flags;
}

boolean_t pic_instr_default_flag_test(pfile_t *pf, flag_t flag)
{
  UNUSED(pf);

  return (pic_instr_default_flags & flag) == flag;
}

flag_t pic_instr_default_flag_get_all(pfile_t *pf)
{
  UNUSED(pf);

  return pic_instr_default_flags;
}


pic_code_t pic_instr_alloc(pfile_t *pf, label_t lbl, pic_opcode_t op)
{
  pic_code_t code;

  if (pic_is_16bit(pf)) {
    if (PIC_OPCODE_RLF == op) {
      op = PIC_OPCODE_RLCF;
    } else if (PIC_OPCODE_RRF == op) {
      op = PIC_OPCODE_RRCF;
    }
  } 
  code = pic_code_alloc(lbl, op, pic_instr_default_flag_get_all(pf));
  pic_code_list_append(pf, code);
  return code;
}


pic_code_t pic_instr_append_label(pfile_t *pf, label_t lbl)
{
  return pic_instr_alloc(pf, lbl, PIC_OPCODE_NONE);
}

/* 
 * determine if var exists in the region defined by {lo,hi}
 */
static boolean_t pic_variable_region_test(variable_t var, size_t lo, 
  size_t hi)
{
  size_t    ii;
  boolean_t rc;

  while (variable_master_get(var)) {
    var = variable_master_get(var);
  }
  for (rc = BOOLEAN_FALSE, ii = 0; !rc && (ii < VARIABLE_MIRROR_CT); ii++) {
    variable_base_t base;

    base = variable_base_get(var, ii);
    rc = (lo <= base) && (base <= hi);
  }
  return rc;
}

/* 
 * returns
 *   PIC_OPCODE_NONE       : no code needed
 *   PIC_OPCODE_DATALO_CLR
 *   PIC_OPCODE_DATALO_SET
 */
pic_opcode_t pic_value_datalo_get(pfile_t *pf, value_t val)
{
  pic_opcode_t op;
  unsigned     bank_sz;

  bank_sz = pic_target_bank_size_get(pf);
  if (value_is_const(val)) {
    variable_const_t cn;

    cn = value_const_get(val);
    op = (cn & bank_sz) ? PIC_OPCODE_DATALO_SET : PIC_OPCODE_DATALO_CLR;
  } else {
    variable_t var;

    var = value_variable_get(val);

    /* if this exists in both region 0 & 2, nothing need be done with rp0 */
    if (!(pic_variable_region_test(var,        0x0000,      bank_sz - 1) 
          && pic_variable_region_test(var,     bank_sz, 2 * bank_sz - 1))
        && !(pic_variable_region_test(var, 2 * bank_sz, 3 * bank_sz - 1) 
          && pic_variable_region_test(var, 3 * bank_sz, 4 * bank_sz - 1))) {
      variable_base_t base;

      base = value_base_get(val);
      op = (base & bank_sz) 
           ? PIC_OPCODE_DATALO_SET
           : PIC_OPCODE_DATALO_CLR;
    } else {
      op = PIC_OPCODE_NONE;
    }
  }
  return op;
}

/*
 * returns
 *   PIC_OPCODE_NONE      : no code needed
 *   PIC_OPCODE_DATAHI_CLR
 *   PIC_OPCODE_DATAHI_SET
 */
pic_opcode_t pic_value_datahi_get(pfile_t *pf, value_t val)
{
  pic_opcode_t op;
  unsigned     bank_sz;

  bank_sz = pic_target_bank_size_get(pf);
  if (value_is_const(val)) {
    variable_const_t cn;

    cn = value_const_get(val);
    op = (cn & (2 * bank_sz)) ? PIC_OPCODE_DATAHI_SET : PIC_OPCODE_DATAHI_CLR;
  } else {
    variable_t var;

    var = value_variable_get(val);

    /* if this exists in both region 1 & 3, nothing need be done with rp1 */
    if (!(pic_variable_region_test(var,         0x0000,     bank_sz - 1) 
          && pic_variable_region_test(var, 2 * bank_sz, 3 * bank_sz - 1))
        && !(pic_variable_region_test(var,     bank_sz, 2 * bank_sz - 1) 
          && pic_variable_region_test(var, 3 * bank_sz, 4 * bank_sz - 1))) {
      variable_base_t base;

      base = value_base_get(val);
      op   = (base & (2 * bank_sz))
             ? PIC_OPCODE_DATAHI_SET
             : PIC_OPCODE_DATAHI_CLR;
    } else {
      op = PIC_OPCODE_NONE;
    }
  }
  return op;
}

/*
 * determine if the databit setup required by a and b are different
 */
boolean_t pic_are_variable_databits_different(pfile_t *pf, value_t a, 
    value_t b)
{
  boolean_t rc;

  pic_opcode_t a_lo;
  pic_opcode_t a_hi;
  pic_opcode_t b_lo;
  pic_opcode_t b_hi;

  a_lo = pic_value_datalo_get(pf, a);
  a_hi = pic_value_datahi_get(pf, a);
  b_lo = pic_value_datalo_get(pf, b);
  b_hi = pic_value_datahi_get(pf, b);

  rc = ((PIC_OPCODE_NONE != a_lo) 
      && (PIC_OPCODE_NONE != b_lo) 
      && (a_lo != b_lo))
    || ((PIC_OPCODE_NONE != a_hi)
      && (PIC_OPCODE_NONE != b_hi)
      && (a_hi != b_hi));
  return rc;
}

void pic_instr_append_daop(pfile_t *pf, value_t f, pic_opcode_t opcode,
    boolean_t force)
{
  if ((force || !pic_instr_default_flag_test(pf, PIC_CODE_FLAG_NO_OPTIMIZE))
      && (PIC_OPCODE_MOVLW != opcode)
      && (PIC_OPCODE_RETLW != opcode)
      && (VALUE_NONE != f)
      && !value_is_const(f)
      && !value_is_shared(f)) {
    variable_base_t base;
    pic_opcode_t    op;

    /*
     * check the last code in the chain. If it's a conditional, insert
     * these instructions before it. If that was wrong, it will be
     * caught later.
     */
    pic_code_t brcode;
    pic_code_t brlist;

    brlist = PIC_CODE_NONE;
    brcode = pic_code_list_tail_get(pf);
    while ((PIC_OPCODE_BTFSC == pic_code_op_get(brcode))
        || (PIC_OPCODE_BTFSS == pic_code_op_get(brcode))
        || (PIC_OPCODE_DECFSZ == pic_code_op_get(brcode))
        || (PIC_OPCODE_INCFSZ == pic_code_op_get(brcode))) {
      pic_code_list_remove(pf, brcode);
      pic_code_next_set(brcode, brlist);
      brlist = brcode;
      brcode = pic_code_list_tail_get(pf);
    }
    /*
     * insert the appropriate data operation
     */
    base = value_base_get(f);

    if (pic_is_16bit(pf)) {
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLB, base / 256);
    } else if (pic_is_14bit_hybrid(pf)) {
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLB, base / 128);
    } else {
      op = pic_value_datalo_get(pf, f);
      if (PIC_OPCODE_NONE != op) {
        pic_code_t code;

        code = pic_instr_alloc(pf, LABEL_NONE, op);
        pic_code_value_set(code, f);
      }

      op = pic_value_datahi_get(pf, f);
      if (PIC_OPCODE_NONE != op) {
        pic_code_t code;

        code = pic_instr_alloc(pf, LABEL_NONE, op);
        pic_code_value_set(code, f);
      }
    }
    /* ...and do any fixup */
    while (brlist) {
      brcode = brlist;
      brlist = pic_code_next_get(brlist);
      pic_code_next_set(brcode, PIC_CODE_NONE);
      pic_code_list_append(pf, brcode);
    }
  }
}

pic_code_t pic_instr_append_f_d(pfile_t *pf, pic_opcode_t op, value_t f, 
    size_t ofs, pic_opdst_t dst)
{
  pic_code_t code;
  boolean_t  indirect;

  indirect = BOOLEAN_FALSE;
  if (value_is_indirect(f)) {
    indirect = BOOLEAN_TRUE;
    f = pic_indirect_get(pf, PFILE_LOG_ERR, 0);
    ofs = 0;
  }
  pic_instr_append_daop(pf, f, op, BOOLEAN_FALSE);
  code = pic_instr_alloc(pf, LABEL_NONE, op);
  if (code) {
    pic_code_value_set(code, f);
    pic_code_ofs_set(code, ofs);
    pic_code_dst_set(code, dst);
  }
  if (indirect) {
    value_release(f);
  }
  return code;
}

pic_code_t pic_instr_append_lfsr(pfile_t *pf, unsigned which,
    value_t val, size_t ofs)
{
  pic_code_t code;

  code = pic_instr_alloc(pf, LABEL_NONE, PIC_OPCODE_LFSR);
  pic_code_fsr_n_set(code, which);
  pic_code_value_set(code, val);
  pic_code_ofs_set(code, ofs);
  return code;
}

pic_code_t pic_instr_append_reg_d(pfile_t *pf, pic_opcode_t op, const char *reg,
  pic_opdst_t dst)
{
  value_t    src;
  pic_code_t code;

  src = pfile_value_find(pf, PFILE_LOG_ERR, reg);
  if (src) {
    code = pic_instr_append_f_d(pf, op, src, 0, dst);
    value_release(src);
  } else {
    code = PIC_CODE_NONE;
  }
  return code;
}


pic_code_t pic_instr_append_f(pfile_t *pf, pic_opcode_t op, value_t f, 
    size_t ofs)
{
  pic_code_t code;
  boolean_t  indirect;

  indirect = BOOLEAN_FALSE;
  if (value_is_indirect(f)) {
    indirect = BOOLEAN_TRUE;
    f = pic_indirect_get(pf, PFILE_LOG_ERR, 0);
    ofs = 0;
  }

  pic_instr_append_daop(pf, f, op, BOOLEAN_FALSE);
  code = pic_instr_alloc(pf, LABEL_NONE, op);
  value_variable_get(f);
  if (code) {
    pic_code_value_set(code, f);
    pic_code_ofs_set(code, ofs);
  }
  if (indirect) {
    value_release(f);
  }
  return code;
}

pic_code_t pic_instr_append_reg(pfile_t *pf, pic_opcode_t op, const char *reg)
{
  value_t    tmp;
  pic_code_t code;

  tmp = pfile_value_find(pf, PFILE_LOG_ERR, reg);
  if (tmp) {
    code = pic_instr_append_f(pf, op, tmp, 0);
    value_release(tmp);
  } else {
    code = PIC_CODE_NONE;
  }
  return code;
}

pic_code_t pic_instr_append(pfile_t *pf, pic_opcode_t op)
{
  /* this might be a hack, but the 12 bit cores do not have
   * a simple return instruction; instead `retlw 0' is used */
  return (pic_is_12bit(pf) && (PIC_OPCODE_RETURN == op))
    ? pic_instr_append_w_kn(pf, PIC_OPCODE_RETLW, 0)
    : pic_instr_alloc(pf, LABEL_NONE, op);
}

pic_code_t pic_instr_append_f_b(pfile_t *pf, pic_opcode_t op, value_t f, 
    size_t ofs, value_t bit)
{
  pic_code_t code;
  boolean_t  indirect;

  indirect = BOOLEAN_FALSE;
  if (value_is_indirect(f)) {
    indirect = BOOLEAN_TRUE;
    f = pic_indirect_get(pf, PFILE_LOG_ERR, 0);
    ofs = 0;
  }
  pic_instr_append_daop(pf, f, op, BOOLEAN_FALSE);
  code = pic_instr_alloc(pf, LABEL_NONE, op);
  if (code) {
    pic_code_value_set(code, f);
    pic_code_ofs_set(code, ofs);
    if (bit) {
      value_use_ct_bump(bit, CTR_BUMP_INCR);
    }
    pic_code_literal_set(code, bit);
  }
  if (indirect) {
    value_release(f);
  }
  return code;
}

pic_code_t pic_instr_append_reg_bn(pfile_t *pf, pic_opcode_t op, 
    const char *reg, variable_const_t bit)
{
  value_t    vreg;
  pic_code_t code;

  code = PIC_CODE_NONE;
  vreg = pfile_value_find(pf, PFILE_LOG_ERR, reg);
  if (vreg) {
    value_t vflag;

    vflag = pfile_constant_get(pf, bit, VARIABLE_DEF_NONE);
    if (vflag) {
      code = pic_instr_append_f_b(pf, op, vreg, 0, vflag);
      value_release(vflag);
    }
    value_release(vreg);
  }
  return code;
}

pic_code_t pic_instr_append_reg_flag(pfile_t *pf, pic_opcode_t op, 
    const char *reg, const char *flag)
{
  value_t    vreg;
  pic_code_t code;

  code = PIC_CODE_NONE;
  vreg = pfile_value_find(pf, PFILE_LOG_ERR, reg);
  if (vreg) {
    value_t vflag;

    vflag = pfile_value_find(pf, PFILE_LOG_ERR, flag);
    if (vflag) {
      code = pic_instr_append_f_b(pf, op, vreg, 0, vflag);
      value_release(vflag);
    }
    value_release(vreg);
  }
  return code;
}

pic_code_t pic_instr_append_f_bn(pfile_t *pf, pic_opcode_t op,
    value_t f, size_t ofs, variable_const_t n)
{
  value_t    vn;
  pic_code_t code;

  vn = pfile_constant_get(pf, n, VARIABLE_DEF_NONE);
  if (vn) {
    code = pic_instr_append_f_b(pf, op, f, ofs
        /*+ value_const_get(value_baseofs_get(f))*/, vn);
    value_release(vn);
  } else {
    code = PIC_CODE_NONE;
  }
  return code;
}

pic_code_t pic_instr_append_w_k(pfile_t *pf, pic_opcode_t op, 
    value_t k)
{
  pic_code_t code;

  pic_instr_append_daop(pf, k, op, BOOLEAN_FALSE);
  code = pic_instr_alloc(pf, LABEL_NONE, op);
  if (code) {
    pic_code_literal_set(code, k);
  }
  return code;
}

pic_code_t pic_instr_append_w_kn(pfile_t *pf, pic_opcode_t op,
    variable_const_t n)
{
  value_t    vn;
  pic_code_t code;

  vn = pfile_constant_get(pf, n, VARIABLE_DEF_NONE);
  if (vn) {
    code = pic_instr_append_w_k(pf, op, vn);
    value_release(vn);
  } else {
    code = PIC_CODE_NONE;
  }
  return code;
}

pic_code_t pic_instr_append_n(pfile_t *pf, pic_opcode_t op, label_t dst)
{
  pic_code_t code;

  if (dst 
      && !(pic_instr_default_flag_test(pf, PIC_CODE_FLAG_NO_OPTIMIZE))
      && !pic_is_16bit(pf)) {
    /* if the previous code is a skip conditional insert the 
     * PCLATH instructions *before* code_pv, otherwise insert
     * them *after* code_pv */
    pic_code_t brcode;
    pic_code_t brlist;
    value_t    code_sz;
    unsigned   page_sz;

    code_sz = pfile_value_find(pf, PFILE_LOG_ERR, "_code_size");
    page_sz = pic_target_page_size_get(pf);
    brlist = PIC_CODE_NONE;
    brcode = pic_code_list_tail_get(pf);
    while ((PIC_OPCODE_BTFSC == pic_code_op_get(brcode))
        || (PIC_OPCODE_BTFSS == pic_code_op_get(brcode))
        || (PIC_OPCODE_DECFSZ == pic_code_op_get(brcode))
        || (PIC_OPCODE_INCFSZ == pic_code_op_get(brcode))
        || (PIC_OPCODE_MOVLB == pic_code_op_get(brcode))) {
      pic_code_list_remove(pf, brcode);
      pic_code_next_set(brcode, brlist);
      brlist = brcode;
      brcode = pic_code_list_tail_get(pf);
    }
    /* note: we've not enough information to set the branchbits yet,
     *       just make sure they appear *before* any conditionals */
    if (pic_is_14bit_hybrid(pf)) {
      code = pic_instr_alloc(pf, LABEL_NONE, PIC_OPCODE_MOVLP);
      pic_code_brdst_set(code, dst);
      pic_code_ofs_set(code, 1);
    } else {
      if (value_const_get(code_sz) > page_sz) {
        code = pic_instr_alloc(pf, LABEL_NONE, PIC_OPCODE_BRANCHLO_CLR);
        pic_code_brdst_set(code, dst);
      }
      if (value_const_get(code_sz) > (2 * page_sz)) {
        code = pic_instr_alloc(pf, LABEL_NONE, PIC_OPCODE_BRANCHHI_CLR);
        pic_code_brdst_set(code, dst);
      }
    }

    while (brlist) {
      brcode = brlist;
      brlist = pic_code_next_get(brlist);
      pic_code_next_set(brcode, PIC_CODE_NONE);
      pic_code_list_append(pf, brcode);
    }
    value_release(code_sz);
  }
  code = pic_instr_alloc(pf, LABEL_NONE, op);
  pic_code_brdst_set(code, dst);
  return code;
}

boolean_t pic_code_to_pcode(pfile_t *pf, const pic_code_t code, 
    pic_code_to_pcode_t *dst)
{
  unsigned  literal;
  unsigned  val;
  boolean_t lit_assigned;
  boolean_t rc;

  lit_assigned = BOOLEAN_FALSE;

  if (pic_code_brdst_get(code)) {
    literal = label_pc_get(pic_code_brdst_get(code));
    lit_assigned = BOOLEAN_TRUE;
    /* this is kind of a hack, but I if there's a branch
       destination, I use offset 0 for the LSB, and offset
       1 for the MSB */
    switch (pic_code_ofs_get(code)) {
      case 0: break;
      case 1: literal >>= 8; break;
      case 2: literal >>= 16; break;
    }
  } else if (pic_code_literal_get(code)) {
    lit_assigned = BOOLEAN_TRUE;
    if (value_is_const(pic_code_literal_get(code))) {
      literal = value_const_get(pic_code_literal_get(code));
    } else {
      literal = value_base_get(pic_code_literal_get(code))
        + value_const_get(value_baseofs_get(pic_code_literal_get(code)));
    }
  } else {
    literal = 0x0000;
  }

  if (pic_code_value_get(code)) {
    value_t cv;

    cv = pic_code_value_get(code);
    if (value_is_const(cv)) {
      val = value_const_get(cv);
    } else if (value_is_indirect(cv)) {
      value_t ind;

      ind = pic_indirect_get(pf, PFILE_LOG_ERR, 0);
      val = value_base_get(ind);
      value_release(ind);
    } else {
      val = (value_base_get(cv) 
        + value_const_get(value_baseofs_get(cv))
        + value_bit_offset_get(cv) / 8
        + pic_code_ofs_get(code));
      if (pic_code_flag_test(code, PIC_CODE_FLAG_LABEL_HIGH)) {
        val >>= 8;
      } else if (pic_code_flag_test(code, PIC_CODE_FLAG_LABEL_UPPER)) {
        val >>= 16;
      }
      if (value_base_get(cv) == VARIABLE_BASE_UNKNOWN) {
        fprintf(stderr, "%lx (%x + %lu): ", 
            pic_code_pc_get(code), 
            value_base_get(cv),
            (ulong) pic_code_ofs_get(code));
        variable_dump(value_variable_get(cv), stderr);
        fprintf(stderr, "\n");
        /*assert(0);*/
      } else {
        if (!lit_assigned) {
          literal = val;
        }
      }
      val &= (pic_target_bank_size_get(pf) - 1);
    }
    if (value_is_bit(cv)) {
      literal  = value_bit_offset_get(cv);
    }
  } else {
    val = 0xffff;
  }

  rc = BOOLEAN_FALSE;
  switch (pic_target_cpu_get(pf)) {
    case PIC_TARGET_CPU_NONE:
    case PIC_TARGET_CPU_SX_12:
      pfile_log(pf, PFILE_LOG_ERR, "core type not set");
      break;
    case PIC_TARGET_CPU_12BIT:
      rc = pic12_code_to_pcode(pf, code, val, literal, dst);
      break;
    case PIC_TARGET_CPU_14BIT:
      rc = pic14_code_to_pcode(pf, code, val, literal, dst);
      break;
    case PIC_TARGET_CPU_14HBIT:
      rc = pic14h_code_to_pcode(pf, code, val, literal, dst);
      break;
    case PIC_TARGET_CPU_16BIT:
      rc = pic16_code_to_pcode(pf, code, val, literal, dst);
      break;
  }
  return rc;
}

boolean_t pic_opcode_is_branch_bit(pic_opcode_t op)
{
  return (PIC_OPCODE_BRANCHLO_CLR == op)
    || (PIC_OPCODE_BRANCHLO_SET == op)
    || (PIC_OPCODE_BRANCHLO_NOP == op)
    || (PIC_OPCODE_BRANCHHI_CLR == op)
    || (PIC_OPCODE_BRANCHHI_SET == op)
    || (PIC_OPCODE_BRANCHHI_NOP == op);
}

boolean_t pic_opcode_is_data_bit(pic_opcode_t op)
{
  return (PIC_OPCODE_DATALO_CLR == op)
    || (PIC_OPCODE_DATALO_SET == op)
    || (PIC_OPCODE_DATAHI_CLR == op)
    || (PIC_OPCODE_DATAHI_SET == op);
}

