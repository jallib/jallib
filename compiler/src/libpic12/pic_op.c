/************************************************************
 **
 ** pic_op.c : PIC operator generation definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <assert.h>
#include <errno.h>
#include <string.h>
#include <math.h>

#include "../libcore/pf_proc.h"
#include "../libcore/pf_expr.h"
#include "../libcore/pf_op.h"
#include "pic_opfn.h"
#include "pic_stvar.h"
#include "pic_var.h"
#include "piccolst.h"
#include "pic_inst.h"
#include "pic_op.h"

/*
 * general note:
 *   all operations must take into account:
 *     constants
 *     single bit
 *     multi-bit
 *     simple
 *     indirect
 *     in W
 *     different banks
 * nb: operations on bitfields will occur *as if*
 *     the bitfield was promoted to the smallest
 *     integer type that can contain it
 *
 * naming convention
 *   pic_op_* -- only called via pic_op(...)
 */
/* sometimes it's not necessary to mask the bits while shifting
 * because they are masked elsewhere. assign to/from bit fields
 * is a good example of this */
#define PIC_SHIFT_FLAG_NONE      0x0000
#define PIC_SHIFT_FLAG_MASK_BITS 0x0001
static void pic_shift_right(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2, unsigned flags);
static void pic_shift_left(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2, unsigned flags);

/*
 * these are used to prevent duplicate calls to _multiply or _divide
 * for example:
 *    ch = n % 10
 *    n  = n / 10
 * they are reset when a label or branch is encountered
 * also if any of the values are used as a destination
 */
typedef enum pic_last_value_ {
  PIC_LAST_VALUE_FIRST,
  PIC_LAST_VALUE_DIVISOR = PIC_LAST_VALUE_FIRST,
  PIC_LAST_VALUE_DIVIDEND,
  PIC_LAST_VALUE_MULTIPLIER,
  PIC_LAST_VALUE_MULTIPLICAND,
  PIC_LAST_VALUE_CT
} pic_last_value_t;

static value_t pic_last_values[PIC_LAST_VALUE_CT];

void pic_last_value_set(pic_last_value_t which, value_t n)
{
  assert(which < PIC_LAST_VALUE_CT);

  value_lock(n);
  value_release(pic_last_values[which]);
  pic_last_values[which] = n;
}

void pic_last_values_reset(void)
{
  pic_last_value_t which;
  
  for (which = PIC_LAST_VALUE_FIRST; 
       which < PIC_LAST_VALUE_CT;
       which++) {
    pic_last_value_set(which, VALUE_NONE);
  }
}

static boolean_t pic_value_is_w(value_t val)
{
  return (VALUE_NONE == val)
    || (VARIABLE_NONE == value_variable_get(val));
}

/* 
 * for a binary op, the result size is the greater of the two
 * operand sizes
 * If the result size is greater than the destination size, the
 * result size is lowered to the destination size
 */
static variable_sz_t pic_result_sz_get(value_t val1, value_t val2, 
    value_t dst)
{
  variable_sz_t sz;

  sz = pic_value_is_w(val1) ? 1 : value_byte_sz_get(val1);

  if (val2 && !pic_value_is_w(val2)) {
    variable_sz_t val2_sz;

    val2_sz = value_byte_sz_get(val2);
    if (val2_sz > sz) {
      sz = val2_sz;
    }
  }
  /* if dst is boolean, the result must be done in the full
   * size of val1 & val2 because dst will be 1 if the result
   * is non-0, and 0 if the result is 0
   */
  if (dst && !value_is_boolean(dst)) {
    variable_sz_t dst_sz;

    dst_sz = (pic_value_is_w(dst)) ? 1 : value_byte_sz_get(dst);
    if (dst_sz < sz) {
      sz = dst_sz;
    }
  }
  return sz;
}

/*
 * determine the result sign flag based on the promotion rules
 */
static flag_t pic_result_flag_get(pfile_t *pf, value_t val1, value_t val2)
{
  variable_def_t rdef;

  rdef = pfile_variable_def_promotion_get(pf, OPERATOR_NULL, val1, val2);
  return variable_def_flag_test(rdef, VARIABLE_DEF_FLAG_SIGNED)
    ? VARIABLE_DEF_FLAG_SIGNED
    : VARIABLE_DEF_FLAG_NONE;
}

static boolean_t pic_result_is_signed(pfile_t *pf, value_t val1, 
    value_t val2)
{
  return VARIABLE_DEF_FLAG_SIGNED == pic_result_flag_get(pf, val1, val2);
}

/* 
 * allocate a pic temp variable & assign val to it. The size of the result
 * is less{dst, greater{val1, val2}}
 */
static value_t pic_var_temp_get_assign(pfile_t *pf, value_t val, value_t val2,
    value_t dst)
{
  value_t        tmp;
  size_t         sz;

  UNUSED(dst);
  sz = pic_result_sz_get(val, val2, VALUE_NONE/*dst*/);
  tmp = pic_var_temp_get(pf, pic_result_flag_get(pf, val, val2), sz);
  pic_op(pf, OPERATOR_ASSIGN, tmp, val, VALUE_NONE);
  return tmp;
}

/* get the constant byte at offset n. This differs from simply shifting
 * because it preserves the sign bit at higher offsets */
static uchar pic_value_const_byte_get(const value_t val, unsigned ofs)
{
  variable_const_t cn;

  cn = value_const_get(val);
  if (ofs >= value_sz_get(val)) {
    cn = (value_is_signed(val) && (cn >= 0x8000000))
      ? 0xff
      : 0x00;
  } else {
    cn >>= (8 * ofs);
  }
  return (uchar) cn;
}

value_t pic_cast(value_t src, variable_sz_t sz)
{
  variable_def_t def;
  value_t        tmp;

  tmp = value_clone(src);
  def = variable_def_sz_set(value_def_get(tmp), sz);
  value_def_set(tmp, def);
  return tmp;
}

value_t pic_fsr_get(pfile_t *pf)
{
  pic_stvar_fsr_mark(pf);
  return pfile_value_find(pf, PFILE_LOG_ERR, 
    (pic_is_16bit(pf) || pic_is_14bit_hybrid(pf))
    ? "_fsr0l"
    : "_fsr");
}

void pic_fsr_setup(pfile_t *pf, value_t val)
{
  pic_stvar_fsr_mark(pf);
  if (pic_is_16bit(pf) || pic_is_14bit_hybrid(pf)) {
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val, 1, PIC_OPDST_W);
    pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr0h");
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val, 0, PIC_OPDST_W);
    pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr0l");
  } else {
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val, 0, PIC_OPDST_W);
    pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr");
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_irp");
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val, 1, PIC_OPDST_F);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BSF, "_status", "_irp");
  }
}

/*
 * NAME
 *   pic_indirect_setup
 *
 * DESCRIPTION
 *   setup irp:fsr
 *
 * PARAMETERS
 *   pf    : file
 *   val   : value
 *   offset: offset from start of value
 *
 * RETURN
 *
 * NOTES
 *   1. A value is assumed to not span banks
 *   2. Normally this is called if val.baseofs is non-const
 */
static void pic_op_assign(pfile_t *pf, operator_t op, value_t dst,
    value_t src, value_t val2);
void pic_indirect_setup(pfile_t *pf, value_t val, size_t offset)
{
  value_t baseofs;

  pic_stvar_fsr_mark(pf);
  baseofs = value_baseofs_get(val);
  if (value_is_bit(val)) {
    offset += (value_bit_offset_get(val) + 7) / 8;
  }

  if (value_is_indirect(val)) {
    /* STATUS<IRP>:FSR = *value */
    value_t tmp;

    tmp = value_clone(val);
    value_baseofs_set(tmp, VALUE_NONE);
    if (value_flag_test(val, VALUE_FLAG_ARRAY)) {
      pic_opcode_t op;

      offset += value_const_get(baseofs);
      value_baseofs_set(tmp, VALUE_NONE);
      if (pic_is_16bit(pf) || pic_is_14bit_hybrid(pf)) {
        if (pic_is_16bit(pf)) {
          pic_instr_append_lfsr(pf, 0, tmp, offset);
        } else {
          unsigned char lsb;
          unsigned char msb;

          lsb = (uchar) (value_base_get(tmp) & 0xff);
          msb = (uchar) (value_base_get(tmp) >> 8);

          if (!lsb) {
            pic_instr_append_reg(pf, PIC_OPCODE_CLRF, "_fsr0l");
          } else {
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, lsb);
            pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr0l");
          }
          if (!msb) {
            pic_instr_append_reg(pf, PIC_OPCODE_CLRF, "_fsr0h");
          } else {
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, msb);
            pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr0h");
          }
        }
        if (!value_is_const(baseofs) || offset) {
          if (value_is_const(baseofs)) {
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, offset);
          } else {
            pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, baseofs, 0, PIC_OPDST_W);
            if (offset) {
              pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, offset);
            }
          }
          pic_instr_append_reg_d(pf, PIC_OPCODE_ADDWF, "_fsr0l", PIC_OPDST_F);
        }
      } else {
        if ((VALUE_NONE != baseofs) && !value_is_const(baseofs)) {
          if (value_is_bit(baseofs)) {
            pic_op_assign(pf, OPERATOR_ASSIGN, VALUE_NONE, baseofs, 
                VALUE_NONE);
            pic_instr_append_f(pf, PIC_OPCODE_ADDLW, tmp, offset);
          } else {
            pic_instr_append_f(pf, PIC_OPCODE_MOVLW, tmp, offset);
            pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, baseofs, 0, 
                PIC_OPDST_W);
          }
        } else {
            pic_instr_append_f(pf, PIC_OPCODE_MOVLW, tmp, offset);
        }
        pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr");
        op = (value_base_get(tmp) >= 256)
          ? PIC_OPCODE_IRP_SET
          : PIC_OPCODE_IRP_CLR;
        pic_instr_append(pf, op);
      }
    } else {
      /* assert(value_is_pointer(val)); */
      value_flag_clr(tmp, VALUE_FLAG_INDIRECT);

      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tmp, 0, PIC_OPDST_W);
      if (baseofs) {
        if (value_is_const(baseofs)) {
          if (value_const_get(baseofs)) {
            pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, 
                value_const_get(baseofs));
          }
        } else {
          pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, baseofs, 0, PIC_OPDST_W);
        }
      }
      if (pic_is_16bit(pf) || pic_is_14bit_hybrid(pf)) {
        pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr0l");
        pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tmp, 1, PIC_OPDST_W);
        pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr0h");
      } else {
        pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr");
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_irp");
        pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, tmp, 1, 0);
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BSF, "_status", "_irp");
      }
    }
    value_release(tmp);
  } else {
    variable_base_t base;
    value_t         fsr;

    fsr = pic_fsr_get(pf);
    if (!pic_is_16bit(pf) && !pic_is_14bit_hybrid(pf)) {
      pic_instr_append(pf, 
         (variable_base_get(value_variable_get(val), 0) >= 256) 
         ? PIC_OPCODE_IRP_SET : PIC_OPCODE_IRP_CLR);
    }
    base = value_base_get(val) + offset;
    if (value_is_const(baseofs)) {
      /* fsr = value_base_get(value) + value_const_get(baseofs) + sz */
      base += (variable_base_t) value_const_get(baseofs);
      if (pic_is_16bit(pf)) {
        pic_instr_append_lfsr(pf, 0, val, value_const_get(baseofs));
      } else {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, base);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, fsr, 0);
      }
    } else {
      /* fsr = base (+ sz - 1) */
      if (pic_is_16bit(pf)) {
        pic_instr_append_lfsr(pf, 0, val, 0);
      } else {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, base);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, fsr, 0);
      }
      if (VALUE_NONE != baseofs) {
        /* w = baseofs */
        pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, baseofs, 0, PIC_OPDST_W);
        /* _fsr += w */
        pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, fsr, 0, PIC_OPDST_F);
      }
    }
    value_release(fsr);
  }
}

/*
 * given three values, determine which one is indirect. This assumes
 * (obviously) that only one is indirect!
 */
static value_t pic_indirect_value_get(value_t val1, value_t val2, value_t val3)
{
  value_t val;

  if (value_is_indirect(val1)) {
    assert((value_is_same(val1, val2) || !value_is_indirect(val2))
           && (value_is_same(val1, val3) || !value_is_indirect(val3)));
    val = val1;
  } else if (value_is_indirect(val2)) {
    assert(value_is_same(val2, val3) || !value_is_indirect(val3));
    val = val2;
  } else if (value_is_indirect(val3)) {
    val = val3;
  } else {
    val = VALUE_NONE;
  }
  return val;
}

/*
 * given three values (only one of which is indirect) and an offset,
 * setup the irp:ind to the requested offset. This is a no-op
 * if none of the values is indirect
 *   ipos is used to track the relative indirect offset & should
 *        *never* be modified except by pic_indirect_bump3
 */
static void pic_indirect_setup3(pfile_t *pf, value_t val1, value_t val2,
  value_t val3, variable_sz_t ofs, variable_sz_t *ipos)
{
  value_t val;

  val = pic_indirect_value_get(val1, val2, val3);
  if (VALUE_NONE != val) {
    variable_sz_t n;

    n = (ofs >= value_sz_get(val))
      ? value_sz_get(val) - 1
      : ofs;
    pic_indirect_setup(pf, val, n);
  }
  *ipos = ofs;
}

/*
 * if any of the three values is indirect, and the position is in range
 * bump the position in the desired direction
 */
static void pic_indirect_bump3(pfile_t *pf, value_t val1, value_t val2,
  value_t val3, variable_sz_t ix, variable_sz_t *ipos)
{
  value_t val;

  val = pic_indirect_value_get(val1, val2, val3);
  if (VALUE_NONE != val) {
    /* we can only move one in either direction */
    value_t fsr;
    
    assert((ix == *ipos)
        || (ix + 1 == *ipos) 
        || (ix - 1 == *ipos));

    fsr = pic_fsr_get(pf);
    if ((ix > *ipos) && (ix < value_sz_get(val))) {
      pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, PIC_OPDST_F);
    } else if ((ix < *ipos) && (*ipos < value_sz_get(val))) {
      pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
    }
    value_release(fsr);
    *ipos = ix;
  }
}

/*
 * return the pic sign value appropriately set if val is signed
 * indirect values are expected to be at the MSB entry.
 * If accum is VALUE_NONE, the returned value will be 
 *   pic_var_accum so pic_var_accum_release() must be used!
 */
static void pic_value_sign_get_in_w(pfile_t *pf, value_t val)
{
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
  if (value_is_signed(val)) {
    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, val, value_sz_get(val) - 1, 7);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 255);
  }
}

static value_t pic_value_sign_get(pfile_t *pf, value_t val, value_t accum)
{
  if (value_is_signed(val)) {
    if (VALUE_NONE == accum) {
      accum = pic_var_accum_get(pf);
    }
    pic_value_sign_get_in_w(pf, val);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, accum, 0);
  } else {
    accum = VALUE_NONE;
  }
  return accum;
}

/*
 * determine if two values reside in the same bank
 */
static boolean_t pic_val_bank_same(pfile_t *pf, value_t val1, value_t val2)
{
  boolean_t  rc;

  if (value_is_indirect(val1) 
      || value_is_indirect(val2)
      || pic_value_is_w(val1)
      || pic_value_is_w(val2)
      || value_is_shared(val1)
      || value_is_shared(val2)
      || value_is_const(val1)
      || value_is_const(val2)) {
    rc = BOOLEAN_TRUE;
  } else {
    variable_t var1;
    variable_t var2;

    rc   = BOOLEAN_FALSE;
    var1 = value_variable_get(val1);
    var2 = value_variable_get(val2);

    if (pic_is_16bit(pf)) {
      rc = (value_base_get(val1) / 256) == (value_base_get(val2) / 256);
    } else if (pic_is_14bit_hybrid(pf)) {
      rc = (value_base_get(val1) / 128) == (value_base_get(val2) / 128);
    } else {
      size_t ii;

      for (ii = 0, rc = BOOLEAN_FALSE; 
           (BOOLEAN_FALSE == rc) && (ii < VARIABLE_MIRROR_CT);
           ii++) {
        variable_base_t base1;
        size_t          jj;

        base1 = variable_base_get(var1, ii);
        if (VARIABLE_BASE_UNKNOWN == base1) {
          /* nothing more to do! */
          break; /* <--- */
        }
        for (jj = 0;
             (BOOLEAN_FALSE == rc) && (jj < VARIABLE_MIRROR_CT);
             jj++) {
          variable_base_t base2;
          unsigned        bank_sz;

          base2 = variable_base_get(var2, jj);
          if (VARIABLE_BASE_UNKNOWN == base2) {
            /* nothing more to do! */
            break; /* <--- */
          }
          bank_sz = pic_target_bank_size_get(pf);
          rc = (((base1 ^ base2) & (bank_sz * 2 | bank_sz)) == 0);
        }
      }
    }
  }
  return rc;
}

/*
 * sign extend a value. If the value is indirect, irp:ind are expected
 * to point to the highest byte in the value.
 */
static void pic_value_sign_extend(pfile_t *pf, value_t val, 
    variable_sz_t pos, boolean_t is_signed)
{
  if (pos + 1 < value_sz_get(val)) {
    if (is_signed) {
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
      pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, val, pos, 7);
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 255);
    }
    while (pos + 1 < value_sz_get(val)) {
      pos++;
      if (value_is_indirect(val)) {
        value_t fsr;

        fsr = pic_fsr_get(pf);
        pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, PIC_OPDST_F);
        value_release(fsr);
      }
      pic_instr_append_f(pf, is_signed ? PIC_OPCODE_MOVWF : PIC_OPCODE_CLRF, 
          val, pos);
    }
  }
}

static void pic_assign_const(pfile_t *pf, value_t dst,
  value_t val1, value_t val2, variable_const_t n)
{
  value_t        tmp;
  variable_def_t def;

  def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
      pic_result_flag_get(pf, val1, val2),
      pic_result_sz_get(val1, val2, 
        (value_is_boolean(dst) ? VALUE_NONE : dst)));
  tmp = pfile_constant_get(pf, n, def);
  pic_op(pf, OPERATOR_ASSIGN, dst, tmp, VALUE_NONE);
  value_release(tmp);
}

#define PIC_WORK_IN_TEMP_FLAG_NONE          0x0000
#define PIC_WORK_IN_TEMP_FLAG_VAL1          0x0001 /* check val1 */
#define PIC_WORK_IN_TEMP_FLAG_VAL2          0x0002 /* check val2 */
#define PIC_WORK_IN_TEMP_FLAG_DST           0x0004 /* check dst  */
/* if DST is volatile assume we cannot work in it */
#define PIC_WORK_IN_TEMP_FLAG_DST_VOLATILE  0x0008
/* if {DST, VALx} are indirect *and* equal, move VALx to a temp */
#define PIC_WORK_IN_TEMP_FLAG_DST_VAL_EQUAL 0x0010
/* check both values (most commmon) */
#define PIC_WORK_IN_TEMP_FLAG_VALS \
  PIC_WORK_IN_TEMP_FLAG_VAL1       \
  | PIC_WORK_IN_TEMP_FLAG_VAL2
/* check all values */
#define PIC_WORK_IN_TEMP_FLAG_VALS_DST \
  PIC_WORK_IN_TEMP_FLAG_VALS      \
  | PIC_WORK_IN_TEMP_FLAG_DST

/* determine if the work must be done in a temporary
 * returns TRUE if work was done in a temporary, FALSE if no
 * nb: in the 16 bit cores, increment and decrement muck with
 *     STATUS<C>. To simplify things, I'll simply disallow
 *     indirect operations for the 16 bit cores
 */
static boolean_t pic_work_in_temp(pfile_t *pf, operator_t op,
  value_t dst, value_t val1, value_t val2, unsigned flags)
{
  boolean_t rc;
#define PWIT_FLAG_IND \
  (VARIABLE_FLAG_PTR_LOOKUP \
   | VARIABLE_FLAG_PTR_EEPROM \
   | VARIABLE_FLAG_PTR_FLASH)

  rc = BOOLEAN_TRUE;
  if (pic_is_16bit(pf) && value_is_indirect(dst)) {
    flags |= PIC_WORK_IN_TEMP_FLAG_VALS_DST;
  }
  if ((flags & PIC_WORK_IN_TEMP_FLAG_VAL1)
      && !value_is_const(val1)
      && ((value_is_indirect(val1) 
          && value_is_indirect(dst)
          && ((flags & PIC_WORK_IN_TEMP_FLAG_DST_VAL_EQUAL)
            || !value_is_same(val1, dst)))
        || (value_is_indirect(val1)
          && value_is_indirect(val2)
          && !value_is_same(val1, val2))
        || value_is_bit(val1)
        || value_is_lookup(val1)
        || (value_is_indirect(val1)
          && (variable_flags_get_all(value_variable_get(val1)) 
            & PWIT_FLAG_IND))
        || (value_is_indirect(val1)
          && (pic_is_16bit(pf)))
        || value_is_value(val1)
        || value_is_label(val1))) {
    /* val1 cannot be used as is, get a temp for it instead */
    value_t tmp;

    tmp = pic_var_temp_get_assign(pf, val1, val2, dst);
    pic_op(pf, op, dst, tmp, val2);
    pic_var_temp_release(pf, tmp);
  } else if ((flags & PIC_WORK_IN_TEMP_FLAG_VAL2)
      && !value_is_const(val2)
      && ((value_is_indirect(val2)
          && value_is_indirect(dst)
          && ((flags & PIC_WORK_IN_TEMP_FLAG_DST_VAL_EQUAL)
           || !value_is_same(dst, val2)))
        || value_is_bit(val2)
        || value_is_lookup(val2)
        || (value_is_indirect(val2)
          && (variable_flags_get_all(value_variable_get(val2))
            & PWIT_FLAG_IND))
        || (value_is_indirect(val2)
          && pic_is_16bit(pf))
        || value_is_value(val2)
        || value_is_label(val2))) {
    /* val2 cannot be used as it, get a temp for it instead */
    value_t tmp;

    tmp = pic_var_temp_get_assign(pf, val2, val1, dst);
    pic_op(pf, op, dst, val1, tmp);
    pic_var_temp_release(pf, tmp);
  } else if ((flags & PIC_WORK_IN_TEMP_FLAG_DST)
      && ((value_is_indirect(dst)
          && (variable_flags_get_all(value_variable_get(dst)) & PWIT_FLAG_IND))
        || value_is_float(dst)
        || (value_is_bit(dst)
          || ((flags & PIC_WORK_IN_TEMP_FLAG_DST_VOLATILE)
            && value_is_volatile(dst)))
        || (value_is_indirect(dst)
          && pic_is_16bit(pf)))) {
    value_t tmp;

    tmp = pic_var_temp_get(pf, pic_result_flag_get(pf, val1, val2),
        pic_result_sz_get(val1, val2, dst));
    pic_op(pf, op, tmp, val1, val2);
    pic_op(pf, OPERATOR_ASSIGN, dst, tmp, VALUE_NONE);
    pic_var_temp_release(pf, tmp);
  } else {
    rc = BOOLEAN_FALSE;
  }
  return rc;
#undef PWIT_FLAG_IND
}

static void pic_assign_from_bit(pfile_t *pf, value_t dst, value_t src);
/* on exit, Z is set if src is 0, clear otherwise */
static void pic_value_is_zero(pfile_t *pf, value_t src)
{
  assert(!value_is_const(src));
  if (value_is_const(src)) {
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, value_const_get(src) ? 1 : 0);
  } else if (pic_value_is_w(src)) {
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xff);
  } else if (value_is_single_bit(src)) {
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_z");
    pic_instr_append_f(pf, PIC_OPCODE_BTFSS, src, 0);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BSF, "_status", "_z");
  } else if (value_is_bit(src)) {
    value_t tmp;

    tmp = pic_var_temp_get(pf, VARIABLE_DEF_FLAG_NONE,
      value_byte_sz_get(src));
    pic_assign_from_bit(pf, tmp, src);
    pic_value_is_zero(pf, tmp);
    pic_var_temp_release(pf, tmp);
  } else if (value_is_indirect(src) 
    && value_flag_test(src, VALUE_FLAG_POINTER)) {
    value_t tmp;

    tmp = pic_var_temp_get_assign(pf, src, VALUE_NONE, VALUE_NONE);
    pic_value_is_zero(pf, tmp);
    pic_var_temp_release(pf, tmp);
  } else {
    variable_sz_t ii;
    variable_sz_t ipos;

    pic_indirect_setup3(pf, src, VALUE_NONE, VALUE_NONE, 0, &ipos);
    for (ii = 0; ii < value_sz_get(src); ii++) {
      pic_indirect_bump3(pf, src, VALUE_NONE, VALUE_NONE, 
          ii, &ipos);
      pic_instr_append_f_d(pf, 
          (ii) ? PIC_OPCODE_IORWF : PIC_OPCODE_MOVF, src, ii, PIC_OPDST_W);
    }
  }
}

/*
 * convert an integer (any size) to float, leaving the result in
 * _pic_fval1
 */
static void pic_integer_to_float(pfile_t *pf, value_t src)
{
  value_t       dst;
  label_t       lbl;
  variable_sz_t sz;

  sz = value_sz_get(src);
  if (value_is_bit(src)) {
    sz = (sz + 7) / 8;
  }

  dst = pic_var_float_conv_get(pf, sz);
  lbl = pic_label_find(pf, value_is_signed(src) 
    ? PIC_LABEL_FLOAT_SCONV 
    : PIC_LABEL_FLOAT_CONV, BOOLEAN_TRUE);
  pic_op(pf, OPERATOR_ASSIGN, dst, src, VALUE_NONE);
  pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl);
  label_release(lbl);
  pic_var_float_conv_release(pf, dst);
}

static void pic_float_to_integer(pfile_t *pf, value_t src)
{
  pic_var_float_t flt;
  label_t         lbl;

  pic_var_float_get(pf, &flt);
  pic_op(pf, OPERATOR_ASSIGN, flt.fval1, src, VALUE_NONE);
  lbl = pic_label_find(pf, PIC_LABEL_FLOAT_TOINT, BOOLEAN_TRUE);
  pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl);
  label_release(lbl);
  pic_var_float_release(pf, &flt);
}

/* create an integer variable that overlays a bit variable */
static value_t pic_bit_overlay_create(value_t val)
{
  variable_t     var;
  variable_def_t def;
  unsigned       bit_ofs;
  unsigned       sz;
  value_t        dst;

  bit_ofs = value_bit_offset_get(val);
  sz      = value_sz_get(val);

  /* create a byte array covering dst */
  def   = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
      VARIABLE_DEF_FLAG_NONE, (bit_ofs + sz + 7) / 8);
  var   = variable_alloc(TAG_NONE, def);
  variable_master_set(var, variable_master_get(value_variable_get(val)));

  dst   = value_alloc(var);
  variable_release(var);
  return dst;
}

/* dst is a bit, src is not lookup */
static void pic_assign_to_bit(pfile_t *pf, value_t dst, value_t src)
{
  unsigned dst_bit_ofs;

  dst_bit_ofs  = value_bit_offset_get(dst);
  if (value_sz_get(dst) == 1) {
    if (value_is_const(src)) {
      variable_const_t cn;

      cn = value_const_get(src);
      pic_instr_append_f_bn(pf,
          ((value_is_boolean(dst) && cn)
          || (cn & 1)) ? PIC_OPCODE_BSF : PIC_OPCODE_BCF,
          dst, 0, 0);
    } else {
      if (value_is_bit(src) && (value_sz_get(src) == 1)) {
        /* single bit --> single bit */
        if (value_is_volatile(dst) || !pic_val_bank_same(pf, dst, src)) {
          label_t lbl_set;
          label_t lbl_done;

          lbl_set  = pfile_label_alloc(pf, 0);
          lbl_done = pfile_label_alloc(pf, 0);
          pic_instr_append_f(pf, PIC_OPCODE_BTFSC, src, 0);
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
          pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
          pic_instr_append_label(pf, lbl_set);
          pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
          pic_instr_append_label(pf, lbl_done);
          label_release(lbl_done);
          label_release(lbl_set);
        } else {
          pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
          pic_instr_append_f(pf, PIC_OPCODE_BTFSC, src, 0);
          pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        }
      } else {
        /* determine if src is 0, set src to _status:_z, and invert test */
        if (pic_value_is_w(src)) {
          pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 
            (value_is_boolean(dst) ? 0xff : 0x01));
        } else {
          if (value_is_boolean(dst)) {
            pic_value_is_zero(pf, src);
          } else {
            if (value_is_indirect(src)) {
              variable_sz_t ipos;

              pic_indirect_setup3(pf, src, VALUE_NONE, VALUE_NONE, 0, &ipos);
            }
            pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, src, 0, PIC_OPDST_W);
            pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 1);
          }
        }
        /* set or clear dst as appropriate */
        if (value_is_volatile(dst) || !pic_val_bank_same(pf, dst, src)) {
          /* cannot change dst twice or cannot skip a single inst. :( */
          label_t done;
          label_t skip;

          skip = pfile_label_alloc(pf, 0);
          done = pfile_label_alloc(pf, 0);

          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, skip);
          pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, done);
          pic_instr_append_label(pf, skip);
          pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
          pic_instr_append_label(pf, done);
          label_release(done);
          label_release(skip);
        } else {
          /* simple single-bit transform */
          pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
          pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        }
      }
    }
  } else if (!pic_work_in_temp(pf, OPERATOR_ASSIGN, dst, src, VALUE_NONE,
    PIC_WORK_IN_TEMP_FLAG_VALS)) {
    if (!value_is_const(src) 
      && !value_is_volatile(dst)
      && (value_sz_get(dst) <= 4)
      && ((dst_bit_ofs & 7) >= 5)) {
      variable_sz_t dst_sz;
      variable_sz_t dst_ofs;
      variable_sz_t ii;
      value_t       tmp;

      tmp = src;
      if (pic_value_is_w(tmp) || !pic_val_bank_same(pf, src, dst)) {
        tmp = pic_var_accum_get(pf);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, tmp, 0);
      }

      dst_sz  = value_sz_get(dst);
      dst_ofs = value_bit_offset_get(dst);
      dst = pic_bit_overlay_create(dst);
      for (ii = 0; ii < dst_sz; ii++) {
        pic_instr_append_f_bn(pf, PIC_OPCODE_BCF, dst,
            (dst_ofs + ii) / 8,
            (dst_ofs + ii) & 7);
        pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, tmp, ii / 8, ii & 7);
        pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, dst,
            (dst_ofs + ii) / 8,
            (dst_ofs + ii) & 7);
      }
      if (tmp != src) {
        pic_var_accum_release(pf, tmp);
      }
      value_release(dst);
    } else {
      /* optimize this a bit -- don't use the standard and/or
       * routines. instead do it directly (a combined and + or)
       */
      unsigned dst_byte_ofs;
      unsigned dst_byte_sz;  /* the number of bytes of interest */
      unsigned dst_bit_sz;
      unsigned mask;

      dst_byte_ofs = dst_bit_ofs / 8;
      dst_bit_ofs  = dst_bit_ofs & 7;
      dst_bit_sz   = value_sz_get(dst);
      dst_byte_sz  = (dst_bit_sz + dst_bit_ofs + 7)/ 8;

      /* we can ignore the first dst_byte_ofs bytes of dst as
       * they're not going to change */
      dst  = pic_bit_overlay_create(dst);
      mask = ~(((1 << dst_bit_sz) - 1) << dst_bit_ofs);

      /* tmp = src with bits masked off */
      if (value_is_const(src)) {
        unsigned sval;

        sval = (value_const_get(src) & ((1 << dst_bit_sz) - 1)) << dst_bit_ofs;

        while (dst_byte_sz) {
          if ((mask & 0xff) == 0x00) {
            /* there's nothing to mask off, simply copy this value in */
            if (sval & 0xff) {
              /* there is a value, copy it in */
              pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, sval & 0xff);
              pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, dst_byte_ofs);
            } else {
              /* no value, simply clear this */
              pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, dst_byte_ofs);
            }
          } else {
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW,
              (unsigned char) (mask & 0xff));
            if (sval & 0xff) {
              /* sval is not 0, we'll need to AND and OR */
              pic_instr_append_f_d(pf, PIC_OPCODE_ANDWF, dst, dst_byte_ofs, 
                PIC_OPDST_W);
              pic_instr_append_w_kn(pf, PIC_OPCODE_IORLW,
                (unsigned char) (sval & 0xff));
              pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, dst_byte_ofs);
            } else {
              /* sval is 0, we need only and */
              pic_instr_append_f_d(pf, PIC_OPCODE_ANDWF, dst, dst_byte_ofs, 
                PIC_OPDST_F);
            }
          }
          dst_byte_ofs++;
          dst_byte_sz--;
          mask >>= 8;
          sval >>= 8;
        }
      } else {
        value_t tmp;
        value_t tmp2;
        size_t  ii;

        /* tmp = ( src << dst_bit_ofs ) & mask */
        tmp  = pic_var_temp_get(pf, VARIABLE_DEF_FLAG_NONE, dst_byte_sz);
        if (value_sz_get(src) < value_sz_get(tmp)) {
          pic_op(pf, OPERATOR_ASSIGN, tmp, src, VALUE_NONE);
          src = tmp;
        }
        if (dst_bit_ofs) {
          tmp2 = pfile_constant_get(pf, dst_bit_ofs, VARIABLE_DEF_NONE);
          pic_shift_left(pf, OPERATOR_SHIFT_LEFT, tmp, src, tmp2,
            PIC_SHIFT_FLAG_NONE);
          value_release(tmp2);
          src = tmp;
        }
        /* if bit ofs is 4 and bit sz is 4 no further masking is necessary */
        /*if ((dst_bit_ofs != 4) || (dst_bit_sz != 4)) */{
          tmp2 = pfile_constant_get(pf, ~mask, VARIABLE_DEF_NONE);
          pic_op(pf, OPERATOR_ANDB, tmp, src, tmp2);
          value_release(tmp2);
        }
        for (ii = 0; ii < dst_byte_sz; ii++) {
          if ((mask & 0xff) == 0x00) {
            /* no mask, this is a straight copy */
            pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tmp, ii, PIC_OPDST_F);
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, dst_byte_ofs + ii);
          } else {
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, mask & 0xff);
            pic_instr_append_f_d(pf, PIC_OPCODE_ANDWF, dst, dst_byte_ofs + ii,
              PIC_OPDST_W);
            pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, tmp, ii, PIC_OPDST_W);
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, dst_byte_ofs + ii);
          }
          mask >>= 8;
        }
        pic_var_temp_release(pf, tmp);
      }
      value_release(dst);
    }
  }
}

/* dst is not bit, src is non-const bit */
static void pic_assign_from_bit(pfile_t *pf, value_t dst, value_t src)
{
  if ((value_sz_get(src) == 1) && (value_bit_offset_get(src) != 0)) {
    variable_sz_t ipos;

    /* the result is either all 0 or all 0xff */
    pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
    pic_instr_append_f(pf, PIC_OPCODE_BTFSC, src, 0);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 
        value_is_signed(src) ? 0xff : 1);
    if (!pic_value_is_w(dst)) {
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
      pic_value_sign_extend(pf, dst, 0, value_is_signed(src));
    }
  } else if (!value_is_volatile(src)
      && (value_sz_get(src) < 5)
      && ((value_bit_offset_get(src) & 7) >= 5)) {
    variable_sz_t ipos;
    variable_sz_t ii;
    variable_sz_t src_sz;
    variable_sz_t src_bit_ofs;

    src_sz      = value_sz_get(src);
    src_bit_ofs = value_bit_offset_get(src);
    src = pic_bit_overlay_create(src);
    pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
    if (value_is_volatile(dst)
        || pic_value_is_w(dst)
        || !pic_val_bank_same(pf, dst, src)) {
      /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
      for (ii = 0; ii < src_sz; ii++) {
        pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, src, 
            (src_bit_ofs + ii) / 8, 
            (src_bit_ofs + ii) & 7);
        pic_instr_append_w_kn(pf, PIC_OPCODE_IORLW, 1 << ii);
      }
      if (!pic_value_is_w(dst)) {
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
      }
    } else {
      pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, 0);
      for (ii = 0; ii < src_sz; ii++) {
        pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, src, 
            (src_bit_ofs + ii) / 8, 
            (src_bit_ofs + ii) & 7);
        pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, dst, 0, ii);
      }
    }
    value_release(src);
    if (!pic_value_is_w(dst)) {
      pic_value_sign_extend(pf, dst, 0, value_is_signed(src));
    }
  } else {
    /* dst = (src >> src_bit_ofs) & mask */
    value_t       tdst;
    variable_sz_t src_bit_sz;
    variable_sz_t src_bit_ofs;
    variable_sz_t src_byte_sz;
    variable_sz_t src_byte_ofs;
    unsigned      mask;
    value_t       tmp;

    src_bit_ofs  = value_bit_offset_get(src);
    src_bit_sz   = value_sz_get(src);
    src_byte_ofs = src_bit_ofs / 8;
    src_bit_ofs  = src_bit_ofs & 7;
    src_byte_sz  = (src_bit_sz + 7) / 8;

    src = pic_bit_overlay_create(src);

    if (src_bit_ofs) {
      tdst = (pic_value_is_w(dst) || value_is_volatile(dst)) 
        ? pic_var_temp_get(pf, VARIABLE_DEF_FLAG_NONE,
            pic_value_is_w(dst) ? 1 : pic_result_sz_get(src, VALUE_NONE, dst))
        : dst;
    } else {
      tdst = src;
    }
    /* tdst = src >> src_bit_ofs */
    if (src_bit_ofs) {
      tmp = pfile_constant_get(pf, src_bit_ofs, VARIABLE_DEF_NONE);
      pic_shift_right(pf, OPERATOR_SHIFT_RIGHT, tdst, src, tmp,
        PIC_SHIFT_FLAG_NONE);
      value_release(tmp);
    }

    mask = ((1 << src_bit_sz) - 1);

    if (pic_value_is_w(dst)) {
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tdst,
        (tdst == src) ? src_byte_ofs : 0, PIC_OPDST_W);
      if ((mask & 0xff) != 0xff) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, mask & 0xff);
      }
    } else {
      variable_sz_t ii;
      variable_sz_t sz;

      if (src_byte_sz < value_sz_get(dst)) {
        sz = src_byte_sz;
      } else {
        sz = value_sz_get(dst);
      }

      for (ii = 0; ii < sz; ii++) {
        if ((mask & 0xff) == 0xff) {
          if (dst != tdst) {
            pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tdst, 
              ii + ((tdst == src) ? src_byte_ofs : 0), PIC_OPDST_W);
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
          }
        } else {
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, mask & 0xff);
          if (dst == tdst) {
            pic_instr_append_f_d(pf, PIC_OPCODE_ANDWF, dst, ii, PIC_OPDST_F);
          } else {
            pic_instr_append_f_d(pf, PIC_OPCODE_ANDWF, tdst, 
              ii + ((tdst == src) ? src_byte_ofs : 0), PIC_OPDST_W);
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
          } 
        }
      }
      while (ii < value_sz_get(dst)) {
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
        ii++;
      }
    }
    if ((src != tdst) && (dst != tdst)) {
      pic_var_temp_release(pf, tdst);
    }
    value_release(src);
  }
}

/* dst is not bit, src is const */
static void pic_assign_from_const(pfile_t *pf, value_t dst, value_t src)
{
  variable_sz_t sz;
  variable_sz_t ii;
  variable_sz_t ipos;
  variable_sz_t ofs;
  variable_sz_t limit;
  variable_sz_t src_sz;
  uchar         last;
  const char   *data;

  sz     = (pic_value_is_w(dst) ? 1 : value_sz_get(dst));
  src_sz = value_sz_get(src);
  last   = 0;
  ofs    = 0;
  pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
  data = variable_data_get(value_variable_get(src));
  limit = variable_sz_get(value_variable_get(src));
  /* If data is NULL, neither offset nor limit matter./ */
  if (data) {
    if (value_baseofs_get(src)) {
      ofs = value_const_get(value_baseofs_get(src)) * src_sz;
    }
  } else {
    src_sz = 0;
    limit  = 0;
  }
  for (ii = 0; ii < sz; ii++) {
    uchar ch;

    pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
    /* note: data can be 0 if a variable is later determined to be const */
    if ((ii < src_sz) && (ofs + ii < limit)) {
      ch = data[ofs + ii];
    } else {
      ch = last;
      if ((ii == src_sz) || (ofs + ii == limit)) {
        if (value_is_signed(src)) {
          ch = (last & 0x80) ? 0xff : 0x00;
        } else {
          ch = 0;
        }
      }
    }
    if ((ii == 0) || (ch != last)) {
      if (ch || pic_value_is_w(dst)) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, ch);
      }
      last = ch;
    }
    if (!pic_value_is_w(dst)) {
      pic_instr_append_f(pf, (ch) ? PIC_OPCODE_MOVWF : PIC_OPCODE_CLRF, dst, 
          ii);
    }
  }
}

/* dst is anything, src is lookup */
static void pic_assign_from_lookup(pfile_t *pf, value_t dst,
    value_t src)
{
  if (value_is_bit(dst)) {
    /* assign src to a temporary, then the temporary to dst */
    value_t       tmp;
    variable_sz_t sz;

    sz = value_sz_get(src);
    if (sz > value_byte_sz_get(dst)) {
      sz = value_byte_sz_get(dst);
    }
    tmp = pic_var_temp_get(pf, pic_result_flag_get(pf, src, VALUE_NONE), sz);
    pic_op(pf, OPERATOR_ASSIGN, tmp, src, VALUE_NONE);
    pic_op(pf, OPERATOR_ASSIGN, dst, tmp, VALUE_NONE);
    pic_var_temp_release(pf, tmp);
  } else {
    variable_sz_t  ii;
    variable_sz_t  ipos;
    variable_sz_t  sz;
    value_t        tmp;
    variable_def_t def;
    value_t        baseofs;
    label_t        lbl;
    value_t         tablat;
    variable_def_member_t mbr;

    def = variable_def_get(value_variable_get(src));
    mbr = variable_def_member_get(def);
    baseofs = value_baseofs_get(src);
    tmp = VALUE_NONE;

    sz = pic_result_sz_get(src, VALUE_NONE, dst);
    pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
    if (pic_is_16bit(pf)) {
      pic_code_t code;
      value_t    tblptr;

      lbl = pic_lookup_label_find(pf, value_variable_get(src), 
          PIC_LOOKUP_LABEL_FIND_FLAG_DATA);
      tblptr = pfile_value_find(pf, PFILE_LOG_ERR, "_tblptr");
      pic_stvar_tblptr_mark(pf);
      for (ii = 0; ii < 3; ii++) {
        code   = pic_instr_append(pf, PIC_OPCODE_MOVLW);
        pic_code_brdst_set(code, lbl);
        pic_code_ofs_set(code, ii);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, tblptr, ii);
      }
      if (baseofs) {
        pic_op(pf, OPERATOR_ADD, tblptr, baseofs, VALUE_NONE);
      }
      value_release(tblptr);
      tablat = pfile_value_find(pf, PFILE_LOG_ERR, "_tablat");
    } else {
      lbl = pic_lookup_label_find(pf, value_variable_get(src), 
          PIC_LOOKUP_LABEL_FIND_FLAG_NONE);
      tablat = VALUE_NONE;
      if (variable_def_member_sz_get(mbr) * variable_def_member_ct_get(mbr)
          > 255) {
        /* need to pass LSB in _pic_loop, MSB in W */
        tmp = pic_var_loop_get(pf);
        pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, baseofs, 0, PIC_OPDST_W);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, tmp, 0);
        if (value_byte_sz_get(baseofs) > 1) {
          pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, baseofs, 1, PIC_OPDST_W);
        } else {
          /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
        }
      } else {
        /* need to find a way to set PCLATH to the high byte of the dst
         * nb: not needed on the 14bit hybrid as pclath will be set correctly
         *     by `movlp' */
        if (!pic_is_14bit_hybrid(pf)) {
          pic_code_t code;

          code = pic_instr_append(pf, PIC_OPCODE_MOVLW);
          pic_code_brdst_set(code, lbl);
          pic_code_ofs_set(code, 1);
          pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_pclath");
        }
        if (value_is_bit(baseofs)) {
          pic_op_assign(pf, OPERATOR_ASSIGN, VALUE_NONE, baseofs, 
              VALUE_NONE);
        } else {
          pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, baseofs, 0, PIC_OPDST_W);
        }
        tmp = baseofs;
      }
    }
    for (ii = 0; ii < sz; ii++) {
      pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
      if (pic_is_16bit(pf)) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_TBLRD, PIC_TBLPTR_CHANGE_POST_INC);
        pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tablat, 0, PIC_OPDST_W);
      } else {
        if (ii) {
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, ii);
          pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, tmp, 0, PIC_OPDST_W);
        }
        pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl);
      }
      if (!pic_value_is_w(dst)) {
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
      }
    }
    if (tmp && (tmp != baseofs)) {
      pic_var_loop_release(pf, tmp);
    }
    value_release(tablat);
    label_release(lbl);
    pic_value_sign_extend(pf, dst, ii - 1, value_is_signed(src));
  }
}

static void pic_assign_from_label2(pfile_t *pf, value_t dst, label_t lbl)
{
  pic_code_t    code;
  variable_sz_t ipos;

  pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
  code = pic_instr_append(pf, PIC_OPCODE_MOVLW);
  pic_code_brdst_set(code, lbl);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
  if (value_sz_get(dst) > 1) {
    variable_sz_t ii;

    pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, 1, &ipos);
    code = pic_instr_append(pf, PIC_OPCODE_MOVLW);
    pic_code_brdst_set(code, lbl);
    pic_code_ofs_set(code, 1);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 1);
    for (ii = 2; ii < value_sz_get(dst); ii++) {
      pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
      pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
    }
  }
}

static void pic_assign_from_value(pfile_t *pf, value_t dst, value_t src)
{
  variable_sz_t ipos;
  variable_t    var;

  var = value_variable_get(src);
  src = variable_value_get(var);

  if (value_is_const(src)) {
    if (pic_code_gen_pass_get(pf) == 1) {
      label_t lbl;

      lbl = pic_lookup_label_find(pf,
        value_variable_get(variable_value_get(var)),
        (pic_is_16bit(pf))
          ? PIC_LOOKUP_LABEL_FIND_FLAG_DATA
          : PIC_LOOKUP_LABEL_FIND_FLAG_NONE);
      if (!lbl) {
        pfile_log(pf, PFILE_LOG_ERR, "Cannot use whereis() on a constant");
      } else {
        pic_assign_from_label2(pf, dst, lbl);
        label_release(lbl);
      }
    }
  } else {
    pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, value_base_get(src));
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
    if (value_sz_get(dst) > 1) {
      variable_sz_t ii;

      pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, 1, &ipos);
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW,
          value_base_get(src) >> 8);
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 1);
      for (ii = 2; ii < value_sz_get(dst); ii++) {
        pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
      }
    }
  }
}

static void pic_assign_from_label(pfile_t *pf, value_t dst, value_t src)
{
  pic_assign_from_label2(pf, dst, value_label_get(src));
}

static void pic_assign_from_function(pfile_t *pf, value_t dst,
  value_t src)
{
  variable_def_t src_def;
  variable_def_t dst_def;
  pic_code_t     code;
  pfile_proc_t  *proc;
  label_t        lbl;
  variable_sz_t  ipos;
  size_t         ii;

  assert(value_is_pointer(dst));
  src_def = value_def_get(src);
  dst_def = value_def_get(dst);
  /* dereference dst def */
  dst_def = variable_def_member_def_get(variable_def_member_get(dst_def));
  assert(variable_def_is_same(src_def, dst_def));

  proc = value_proc_get(src);
  lbl  = pfile_proc_label_get(proc);

  pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
  for (ii = 0; ii < pic_pointer_size_get(pf); ii++) {
    code = pic_instr_append(pf, PIC_OPCODE_MOVLW);
    pic_code_brdst_set(code, lbl);
    pic_code_ofs_set(code, ii);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
  }
}

static void pic_assign_array_to_pointer(pfile_t *pf, value_t dst, value_t src)
{
  if (value_is_const(src)) {
    /* this is assign from lookup */
    pic_code_t code;
    label_t        lbl;

    lbl = pic_lookup_label_find(pf, value_variable_get(src), 
        PIC_LOOKUP_LABEL_FIND_FLAG_NONE);
    code = pic_instr_append(pf, PIC_OPCODE_MOVLW);
    pic_code_brdst_set(code, lbl);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
    code = pic_instr_append(pf, PIC_OPCODE_MOVLW);
    pic_code_brdst_set(code, lbl);
    pic_code_ofs_set(code, 1);
    pic_instr_append_w_kn(pf, PIC_OPCODE_IORLW, 0x40);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 1);
    label_release(lbl);
  } else {
    variable_base_t base;
    variable_sz_t   ii;

    base = value_base_get(src);
    for (ii = 0, base = value_base_get(src);
         ii < value_sz_get(dst);
         ii++, base >>= 8) {
      if (base) {
        pic_code_t code;
        unsigned   flag;

        code = pic_instr_append(pf, PIC_OPCODE_MOVLW);
        pic_code_value_set(code, src);
        flag = PIC_CODE_FLAG_NONE;
        switch (ii) {
          case 0: break;
          case 1: flag = PIC_CODE_FLAG_LABEL_HIGH;  break;
          case 2: flag = PIC_CODE_FLAG_LABEL_UPPER; break;
        }
        pic_code_flag_set(code, flag);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
      } else {
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
      }
    }
  }
}

static void pic_assign_ptr_to_ptr(pfile_t *pf, value_t dst, value_t src)
{
  variable_sz_t ii;

  /* nb: src might have baseofs set if it is called indirectly or the
   *     function is re-entrant. In either case, src will be an offset
   *     into pic_temp
   */
  /*assert(!value_baseofs_get(src));*/
  src = value_clone(src);
  value_baseofs_set(src, VALUE_NONE);
  value_indirect_clear(src);

  assert(!value_baseofs_get(dst));
  dst = value_clone(dst);
  value_baseofs_set(dst, VALUE_NONE);
  value_indirect_clear(dst);

  for (ii = 0; ii < pic_pointer_size_get(pf); ii++) {
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, src, ii, PIC_OPDST_W);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
  }
  value_release(dst);
  value_release(src);
}

/* dst has one or more of the LOOKUP/EEPROM/FLASH bits set */
static void pic_assign_to_ptr(pfile_t *pf, value_t dst, value_t src)
{
  if (value_is_pointer(src)) {
    pic_assign_ptr_to_ptr(pf, dst, src);
  } else if (variable_is_lookup(value_variable_get(src))) {
    pic_code_t    code;
    label_t       lbl;
    variable_sz_t ii;

    lbl = pic_lookup_label_find(pf, value_variable_get(src), 
        PIC_LOOKUP_LABEL_FIND_FLAG_ALLOC
        | PIC_LOOKUP_LABEL_FIND_FLAG_DATA);
    for (ii = 0; ii < pic_pointer_size_get(pf); ii++) {
      code = pic_instr_append(pf, PIC_OPCODE_MOVLW);
      pic_code_brdst_set(code, lbl);
      pic_code_ofs_set(code, ii);
      if (ii + 1 == pic_pointer_size_get(pf)) {
        /* This has to be forced. Previously I optimized this out
         * in some circumstances, but that lead to bad code
         */
        pic_instr_append_w_kn(pf, PIC_OPCODE_IORLW, 0x40);
      }
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
    }
    label_release(lbl);
  } else if (value_is_array(src)) {
    pic_assign_array_to_pointer(pf, dst, src);
  } else {
    if (variable_flag_test(value_variable_get(dst),
      VARIABLE_FLAG_PTR_LOOKUP)) {
      pfile_log(pf, PFILE_LOG_ERR, 
        "Attempt to assign to a lookup table");
    } else {
      assert(0);
    }
  }
}

/* src has one or more of the LOOKUP/EEPROM/FLASH bits set */
static void pic_assign_from_ptr(pfile_t *pf, value_t dst, value_t src)
{
  if (value_is_pointer(dst)) {
    pic_assign_ptr_to_ptr(pf, dst, src);
  } else {
    variable_t     svar;
    value_t        tmp;
    value_t        baseofs;
    variable_sz_t  ii;
    variable_def_t src_def;

    src     = value_clone(src);
    baseofs = value_baseofs_get(src);
    value_baseofs_set(src, VALUE_NONE);
    value_indirect_clear(src);

    /*#error "this needs fixin!!!";*/
    /* src needs another variable placed at it, with the flags clear
     * to make the new variable appear to be an integer of the same
     * size
     */
    tmp = pic_var_pointer_get(pf);
    src_def = value_def_get(src);
    value_def_set(src, value_def_get(tmp));

    svar = value_variable_get(src);
    if ((variable_flag_test(svar, VARIABLE_FLAG_PTR_PTR)
          && variable_flag_test(svar, VARIABLE_FLAG_PTR_LOOKUP))
        || variable_flag_test(svar, VARIABLE_FLAG_PTR_EEPROM)
        || variable_flag_test(svar, VARIABLE_FLAG_PTR_FLASH)) {
      /* this will necessitate a function call */
      variable_sz_t sz;
      variable_sz_t ipos;
      label_t       lbl;

      if ((VALUE_NONE == baseofs)
        || (value_is_const(baseofs) && !value_const_get(baseofs))) {
        /* nb: cannot call pic_op(...OPERATOR_ASSIGN...) here as we
         *     end up in an infinite loop, so just do the necessary
         *     inline 
         * pic_op(pf, OPERATOR_ASSIGN, tmp, src, VALUE_NONE);
         */
        assert(value_sz_get(src) == value_sz_get(tmp));
        for (ii = 0; ii < value_sz_get(tmp); ii++) {
          if (ii < value_sz_get(src)) {
            pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, src, ii, PIC_OPDST_W);
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, tmp, ii);
          } else {
            pic_instr_append_f(pf, PIC_OPCODE_CLRF, tmp, ii);
          }
        }
      } else {
        pic_op(pf, OPERATOR_ADD, tmp, src, baseofs);
      }
      value_def_set(src, src_def);
      lbl = pic_label_find(pf, PIC_LABEL_PTR_READ, BOOLEAN_TRUE);
      sz  = pic_result_sz_get(src, VALUE_NONE, dst);
      pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
      for (ii = 0; ii < sz; ii++) {
        if (ii) {
          pic_instr_append_f_d(pf, PIC_OPCODE_INCF, tmp, 0, PIC_OPDST_F);
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
          pic_instr_append_f_d(pf, PIC_OPCODE_INCF, tmp, 1, PIC_OPDST_F);
        }
        pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
        pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl);
        if (!pic_value_is_w(dst)) {
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
        }
      }
      pic_value_sign_extend(pf, dst, ii - 1, value_is_signed(src));

      label_release(lbl);
    } else if (variable_flag_test(svar, VARIABLE_FLAG_PTR_PTR)) {
      /* ptr --> dst */
      assert(0);
    } else if (variable_flag_test(svar, VARIABLE_FLAG_PTR_LOOKUP)) {
      /* lookup --> dst */
      /* pic_sign holds LSB */
      /* W holds MSB */
      variable_sz_t sz;
      variable_sz_t ipos;
      value_t       mask;
      ulong         cmask;

      /* 
       * bit 6 of the high byte of the pointer is 1, bit 7 is 0
       * so, simply clear bit 6
       */
      cmask = ~(1UL << (8 * pic_pointer_size_get(pf) - 2));
      mask  = pfile_constant_get(pf, cmask, VARIABLE_DEF_NONE);
      if (pic_is_16bit(pf)) {
        pic_var_pointer_release(pf, tmp);
        tmp = pfile_value_find(pf, PFILE_LOG_ERR, "_tblptr");
        pic_stvar_tblptr_mark(pf);
      }
      /*
       * if baseofs is zero, `OPERATOR_ADD' --> `OPERATOR_ASSIGN'
       * which brings us right back here!
       */
      if ((VALUE_NONE != baseofs) 
        && (!value_is_const(baseofs) || value_const_get(baseofs))) {
        pic_op(pf, OPERATOR_ADD, tmp, src, baseofs);
        pic_op(pf, OPERATOR_ANDB, tmp, tmp, mask);
      } else {
        pic_op(pf, OPERATOR_ANDB, tmp, src, mask);
      }
      value_def_set(src, src_def);
      value_release(mask);
      pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
      sz = pic_result_sz_get(src, VALUE_NONE, dst);
      if (pic_is_16bit(pf)) {
        value_t tablat;

        tablat = pfile_value_find(pf, PFILE_LOG_ERR, "_tablat");
        for (ii = 0; ii < sz; ii++) {
          pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
          pic_instr_append_w_kn(pf, PIC_OPCODE_TBLRD, PIC_TBLPTR_CHANGE_POST_INC);
          pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tablat, 0, PIC_OPDST_W);
          if (VALUE_NONE != dst) {
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
          }
        }
        value_release(tablat);
        value_release(tmp);
        tmp = VALUE_NONE;
      } else {
        label_t       lbl;

        lbl = pic_label_find(pf, PIC_LABEL_INDIRECT, BOOLEAN_TRUE);
        for (ii = 0; ii < sz; ii++) {
          if (ii) {
            pic_op(pf, OPERATOR_INCR, tmp, VALUE_NONE, VALUE_NONE);
          }
          pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
          pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tmp, 
            pic_pointer_size_get(pf) - 1, PIC_OPDST_W);
          pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl);
          if (!pic_value_is_w(dst)) {
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
          }
        }
        label_release(lbl);
      }
      pic_value_sign_extend(pf, dst, ii - 1, value_is_signed(src));
    }
    value_release(src);
    if (VALUE_NONE != tmp) {
      pic_var_pointer_release(pf, tmp);
    }
  }
}

static void pic_assign_to_float(pfile_t *pf, value_t dst, value_t src)
{

  if (value_is_const(src)) {
    value_t tmp;

    tmp = pfile_constant_float_get(pf, value_const_get(src), 
      value_def_get(src));
    pic_op(pf, OPERATOR_ASSIGN, dst, tmp, VALUE_NONE);
    value_release(tmp);
  } else {
    pic_var_float_t flt;
    pic_integer_to_float(pf, src);
    pic_var_float_get(pf, &flt);
    pic_op(pf, OPERATOR_ASSIGN, dst, flt.fval1, VALUE_NONE);
    pic_var_float_release(pf, &flt);
  }
}

static void pic_assign_from_float(pfile_t *pf, value_t dst, value_t src)
{
  value_t       fconv;
  variable_sz_t sz;

  sz = value_sz_get(dst);
  if (value_is_bit(dst)) {
    sz = (sz + 7) / 8;
  }
  fconv = pic_var_float_conv_get(pf, sz);
  pic_float_to_integer(pf, src);
  pic_op(pf, OPERATOR_ASSIGN, dst, fconv, VALUE_NONE);
  value_release(fconv);
}

/* note: dst or src can be W */
static void pic_op_assign(pfile_t *pf, operator_t op, value_t dst,
    value_t src, value_t val2)
{
  UNUSED(op);
  UNUSED(val2);

  if (value_is_same(dst, src)) {
    /* this might happen during some internal work, ignore it */
  } else if (value_is_float(dst) && !value_is_float(src)) {
    pic_assign_to_float(pf, dst, src);
  } else if (value_is_float(src) && !value_is_float(dst)) {
    pic_assign_from_float(pf, dst, src);
  } else if (value_is_function(src)) {
    pic_assign_from_function(pf, dst, src);
  } else if (value_is_label(src)) {
    pic_assign_from_label(pf, dst, src);
  } else if (value_is_value(src)) {
    pic_assign_from_value(pf, dst, src);
  } else if (/* value_flag_test(dst, VALUE_FLAG_INDIRECT) && */
      (variable_flags_get_all(value_variable_get(dst))
        & (VARIABLE_FLAG_PTR_LOOKUP
          | VARIABLE_FLAG_PTR_EEPROM
          | VARIABLE_FLAG_PTR_FLASH))) {
    pic_assign_to_ptr(pf, dst, src);
  } else if (/*value_flag_test(src, VALUE_FLAG_INDIRECT) && */
      (variable_flags_get_all(value_variable_get(src))
        & (VARIABLE_FLAG_PTR_LOOKUP
          | VARIABLE_FLAG_PTR_EEPROM
          | VARIABLE_FLAG_PTR_FLASH))) {
    pic_assign_from_ptr(pf, dst, src);
  } else if (value_is_indirect(dst) && value_is_indirect(src)) {
    /* src must move to a temporary */
    value_t tmp;

    tmp = pic_var_temp_get_assign(pf, src, VALUE_NONE, dst);
    pic_op(pf, OPERATOR_ASSIGN, dst, tmp, VALUE_NONE);
    pic_var_temp_release(pf, tmp);
  } else if (value_is_lookup(src)) {
    pic_assign_from_lookup(pf, dst, src);
  } else if (value_is_bit(dst)) {
    pic_assign_to_bit(pf, dst, src);
  } else if (value_is_pointer(dst) && value_is_array(src)) {
    pic_assign_array_to_pointer(pf, dst, src);
  } else if (value_is_const(src)) {
    pic_assign_from_const(pf, dst, src);
  } else if (value_is_bit(src)) {
    pic_assign_from_bit(pf, dst, src);
  } else {
    /* simple assignment from src to dst */
    variable_sz_t ipos;
    variable_sz_t ii;
    variable_sz_t sz;
    value_t       accum;

    accum = VALUE_NONE;
    sz = pic_result_sz_get(src, VALUE_NONE, dst);
    if (pic_value_is_w(dst)) {
      sz = 1;
    }
    if (pic_value_is_w(src) && value_is_indirect(dst)) {
      /* store src in the accumulator */
      accum = pic_var_accum_get(pf);
      src   = accum;
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, accum, 0);
    }
    pic_indirect_setup3(pf, src, VALUE_NONE, dst, 0, &ipos);
    for (ii = 0; ii < sz; ii++) {
      pic_indirect_bump3(pf, dst, src, VALUE_NONE, ii, &ipos);
      if (!pic_value_is_w(src)) {
        pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, src, ii, PIC_OPDST_W);
      }
      if (!pic_value_is_w(dst)) {
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
      }
    }
    pic_value_sign_extend(pf, dst, ii - 1, value_is_signed(src));
    if (accum) {
      pic_var_accum_release(pf, accum);
    }
  }
}

/* operator on val1 & dst (assign, neg, etc.). if val1 is signed,
 * and its size is smaller than dst, and the result *is not*
 * signed, shrink dst to val1 to eliminate sign extension,
 * perform the operation, then zero out the upper bytes in dst
 */
static void pic_unary_fixup(pfile_t *pf, operator_t op,
    value_t dst, value_t val1, value_t val2)
{
  if (value_is_signed(val1)
      && !pic_result_is_signed(pf, val1, val2)
      && (pic_result_sz_get(val1, val2, dst) < value_byte_sz_get(dst))) {
    variable_def_t def;
    variable_def_t def_fixed;

    def = value_def_get(dst);
    def_fixed = variable_def_alloc(0, 
        variable_def_type_get(def),
        variable_def_flags_get_all(def),
        pic_result_sz_get(val1, val2, dst));
    value_def_set(dst, def_fixed);
    pic_op(pf, op, dst, val1, val2);
    value_def_set(dst, def);
    pic_value_sign_extend(pf, dst, pic_result_sz_get(val1, val2, dst) - 1,
        BOOLEAN_FALSE);
  } else {
    pic_op(pf, op, dst, val1, val2);
  }
}

/*
 * ADD: a = a + b
 *   movf   b_n, w
 *   if (n >= 1)
 *     btfsc _c
 *     incfsz b_n, w
 *   fi  
 *   addwf  a_n, f
 * 
 * SUB: a = a - b
 *   movf   b_n, w
 *   if (n >= 1)
 *     btfss  _c
 *     incfsz b_n
 *   fi  
 *   subwf  a_n
 *
 * nb : in the case where size <= 2, a and b can be in different
 *      banks. in the case where size > 2, a and b *must* be in the
 *      same bank. For that case a special register is defined,
 *      pic_accum. This variable *must* exist in all banks either in 
 *      a shared space (preferable), or at the same offset in each bank.
 */

/* 
 * the 16 bit cores change the status<c> on incf/decf operations
 * so the 12 & 14 bit add/sub routines cannot be used. Use the new
 *    addwfc -- w + f + c --> dst
 *    subfwb -- w - f - !c --> dst
 *    subwfb -- f - w - !c --> dst
 * these routines are much simpler:
 *    movf val1,w
 *    addwf val2,w
 *    movwf dst
 *    repeat
 *      movf   val1+n, w
 *      addwfc val2+n, w
 *      movwf  dst
 */
static void pic_add_sub_16bit(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2, variable_sz_t sz)
{
  pic_opdst_t   pop_dst;
  pic_opcode_t  pop;      /* opcode for first byte      */
  pic_opcode_t  pop_cont; /* opcode for remaining bytes */
  variable_sz_t ii;
  value_t       val1_sign;
  value_t       val2_sign;
  boolean_t     release_val;
  boolean_t     result_is_signed;
  value_t       tmp;
  variable_sz_t ipos;

  /*
   * This is called by both 16 bit and 14 bit hybrid. The
   * former changes status<c> on increment decrement, so
   * cannot work with indirect variables. The later doesn't
   * have this restriction
   */
  if (pic_is_16bit(pf)) {
    assert(!value_is_indirect(dst));
    assert(!value_is_indirect(val1));
    assert(!value_is_indirect(val2));
  }

  result_is_signed = pic_result_is_signed(pf, val1, val2);
  /* nb: we always want the const to be in val1! */
  release_val = BOOLEAN_FALSE;
  if ((OPERATOR_SUB == op) && value_is_const(val2)) {
    /* var - const = (-const) + var */
    val2 = pfile_constant_get(pf, -value_const_get(val2), VARIABLE_DEF_NONE);
    release_val = BOOLEAN_TRUE;
    op = OPERATOR_ADD;
  }
  if (value_is_const(val2)
    || ((OPERATOR_ADD == op) && value_is_same(val1, dst))) {
    tmp  = val1;
    val1 = val2;
    val2 = tmp;
  }
  assert(!value_is_const(val2));
  pop_dst = (value_is_same(val2, dst)) ? PIC_OPDST_F : PIC_OPDST_W;
  if (OPERATOR_ADD == op) {
    pop      = PIC_OPCODE_ADDWF;
    pop_cont = PIC_OPCODE_ADDWFc;
  } else {
    pop      = PIC_OPCODE_SUBFWB;
    pop_cont = PIC_OPCODE_SUBFWB;
  }
  val1_sign = val1;
  val2_sign = val2;
  if (OPERATOR_SUB == op) {
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BSF, "_status", "_c");
  }
  pic_indirect_setup3(pf, dst, val1, val2, 0, &ipos);
  for (ii = 0; ii < sz; ii++) {
    pic_indirect_bump3(pf, dst, val1, val2, ii, &ipos);
    if (ii == value_sz_get(val1) && !value_is_const(val1)) {
      tmp = pic_var_temp_get(pf, VARIABLE_DEF_FLAG_NONE, 1);
      val1_sign = pic_value_sign_get(pf, val1, tmp);
      if (VALUE_NONE == val1_sign) {
        /*val1_sign = pic_var_accum_get(pf);*/
        val1_sign = tmp;
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, val1_sign, 0);
      }
    } else if (ii == value_sz_get(val2)) {
      tmp = pic_var_temp_get(pf, VARIABLE_DEF_FLAG_NONE, 1);
      val2_sign = pic_value_sign_get(pf, val2, tmp);
      if (VALUE_NONE == val2_sign) {
        /*val2_sign = pic_var_accum_get(pf);*/
        val2_sign = tmp;
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, val2_sign, 0);
      }
    }
    if (value_is_const(val1)) {
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 
        pic_value_const_byte_get(val1, ii));
    } else {
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val1_sign, 
        (val1_sign == val1) ? ii : 0, PIC_OPDST_W);
    }
    pic_instr_append_f_d(pf, pop, val2_sign,
      (val2_sign == val2) ? ii : 0, pop_dst);
    if (PIC_OPDST_W == pop_dst) {
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
    }
    pop = pop_cont;
  }
  if (val1_sign && (val1_sign != val1)) {
    /* pic_var_accum_release(pf, val1_sign); */
    pic_var_temp_release(pf, val1_sign);
  }
  if (val2_sign && (val2_sign != val2)) {
    /*pic_var_accum_release(pf, val2_sign);*/
    pic_var_temp_release(pf, val2_sign);
  }
  if (release_val) {
    value_release(val1);
  }
  pic_value_sign_extend(pf, dst, ii - 1, result_is_signed);
}

/* the simplest of all cases */
static void pic_add_sub_1byte(pfile_t *pf, operator_t op,
  value_t dst, value_t val1, value_t val2, variable_sz_t sz)
{
  UNUSED(sz);

  if (value_is_const(val1)) {
    variable_sz_t ipos;

    pic_indirect_setup3(pf, dst, val1, val2, 0, &ipos);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val2, 0, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_SUBLW,
      value_const_get(val1));
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
  } else {
    pic_opcode_t   pop;
    pic_opdst_t    opdst;
    variable_sz_t  ipos;
    pop   = (OPERATOR_ADD == op) ? PIC_OPCODE_ADDWF : PIC_OPCODE_SUBWF;
    opdst = (value_is_same(dst, val1)) ? PIC_OPDST_F : PIC_OPDST_W;

    pic_indirect_setup3(pf, dst, val1, val2, 0, &ipos);
    if (value_is_const(val2)) {
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 
        pic_value_const_byte_get(val2, 0));
    } else {
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val2, 0, PIC_OPDST_W);
    }
    pic_instr_append_f_d(pf, pop, val1, 0, opdst);
    if (PIC_OPDST_W == opdst) {
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
    }
  }
}

/* this one isn't so bad either */
static void pic_add_sub_2byte(pfile_t *pf, operator_t op,
  value_t dst, value_t val1, value_t val2, variable_sz_t sz)
{
  pic_opcode_t  pop;
  pic_opcode_t  pop_post;
  pic_opcode_t  pop_skip;
  pic_opdst_t   opdst;
  variable_sz_t ipos;
  variable_sz_t ii;
  value_t       val1_sign;
  value_t       val2_sign;

  pic_indirect_setup3(pf, dst, val1, val2, sz - 1, &ipos);
  if (OPERATOR_ADD == op) {
    pop      = PIC_OPCODE_ADDWF;
    pop_post = PIC_OPCODE_INCF;
    pop_skip = PIC_OPCODE_BTFSC;
  } else {
    pop      = PIC_OPCODE_SUBWF;
    pop_post = PIC_OPCODE_DECF;
    pop_skip = PIC_OPCODE_BTFSS;
  }
  opdst = (value_is_same(dst, val1)) ? PIC_OPDST_F : PIC_OPDST_W;
  assert(!value_is_const(val1));

  val1_sign = VALUE_NONE;
  val2_sign = VALUE_NONE;
  if (!value_is_const(val1) && (value_sz_get(val1) == 1)) {
    val1_sign = pic_value_sign_get(pf, val1, VALUE_NONE);
    if ((VALUE_NONE == val1_sign) && (OPERATOR_SUB == op)) {
      val1_sign = pic_var_accum_get(pf);
      pic_instr_append_f(pf, PIC_OPCODE_CLRF, val1_sign, 0);
    }
  } else if (!value_is_const(val2) && (value_sz_get(val2) == 1)) {
    val2_sign = pic_value_sign_get(pf, val2, VALUE_NONE);
  }

  for (ii = 2; ii > 0; ii--) {
    pic_indirect_bump3(pf, dst, val1, val2, ii - 1, &ipos);
    if ((value_is_const(val2) && (0 == pic_value_const_byte_get(val2, ii - 1)))
      || (!value_is_const(val2) 
        && (VALUE_NONE == val2_sign) 
        && (ii - 1 >= value_sz_get(val2)))) {
      if (PIC_OPDST_W == opdst) {
        if (ii - 1 >= value_sz_get(val1)) {
          if (VALUE_NONE == val1_sign) {
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
          } else {
            pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val1_sign, 0, 
              PIC_OPDST_W);
          }
        } else {
          pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val1, ii - 1, 
            PIC_OPDST_W);
        }
      }
      if (1 == ii) {
        /* an add 0 on the high byte clearly will have no effect,
         * so don't bother with the pop-skip/increment */
        op = OPERATOR_NULL;
      }
    } else {
      if (value_is_const(val2)) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 
          pic_value_const_byte_get(val2, ii - 1));
      } else if (ii - 1 >= value_sz_get(val2)) {
        if (VALUE_NONE == val2_sign) {
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
        } else {
          pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val2_sign, 0, 
            PIC_OPDST_W);
        }
      } else {
        pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val2, ii - 1, PIC_OPDST_W);
      }
      if (ii - 1 >= value_sz_get(val1)) {
        assert(PIC_OPDST_W == opdst);
        if (VALUE_NONE == val1_sign) {
          /* no need to do anything here */
        } else {
          pic_instr_append_f_d(pf, pop, val1_sign, 0, PIC_OPDST_W);
        }
      } else {
        pic_instr_append_f_d(pf, pop, val1, ii - 1, opdst);
      }
    }
    if (PIC_OPDST_W == opdst) {
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii - 1);
    }
  }
  if (value_is_indirect(dst)) {
    pic_indirect_bump3(pf, dst, val1, val2, 1, &ipos);
  }
  if (OPERATOR_NULL != op) {
    pic_instr_append_reg_flag(pf, pop_skip, "_status", "_c");
    pic_instr_append_f_d(pf, pop_post, dst, 1, PIC_OPDST_F);
  }
  if (VALUE_NONE != val1_sign) {
    pic_var_accum_release(pf, val1_sign);
  } else if (VALUE_NONE != val2_sign) {
    pic_var_accum_release(pf, val2_sign);
  }
}

static void pic_add_sub_nbyte(pfile_t *pf, operator_t op,
  value_t dst, value_t val1, value_t val2, variable_sz_t sz)
{
  pic_opcode_t  pop;
  pic_opcode_t  pop_skip;
  pic_opcode_t  pop_post;
  variable_sz_t ipos;
  variable_sz_t ii;
  value_t       accum;
  value_t       use;
  value_t       tdst;

  tdst = VALUE_NONE;
  if (!value_is_same(dst, val1)) {
    if (value_is_same(dst, val2)) {
      tdst = dst;
      dst = pic_var_temp_get_assign(pf, val1, val2, dst);
    } else {
      pic_op(pf, OPERATOR_ASSIGN, dst, val1, VALUE_NONE);
    }
  }
  pic_indirect_setup3(pf, dst, VALUE_NONE, val2, 0, &ipos);
  if (OPERATOR_ADD == op) {
    pop      = PIC_OPCODE_ADDWF;
    pop_skip = PIC_OPCODE_INCFSZ;
    pop_post = PIC_OPCODE_BTFSC;
  } else {
    pop      = PIC_OPCODE_SUBWF;
    pop_skip = PIC_OPCODE_INCFSZ;
    pop_post = PIC_OPCODE_BTFSS;
  }
  assert(!value_is_const(val1));

  accum = pic_var_accum_get(pf);
  for (ii = 0; ii < sz; ii++) {
    pic_indirect_bump3(pf, dst, VALUE_NONE, val2, ii, &ipos);
    if (value_is_const(val2)) {
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW,
        pic_value_const_byte_get(val2, ii));
      if (ii) {
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, accum, 0);
      }
      use = accum;
    } else if (ii >= value_sz_get(val2)) {
      if (value_is_signed(val2)) {
        if (ii == value_sz_get(val2)) {
          pic_value_sign_get(pf, val2, accum);
          pic_instr_append_daop(pf, dst, PIC_OPCODE_NONE, BOOLEAN_FALSE);
        } else {
          pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, accum, 0, PIC_OPDST_W);
        }
      } else {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
        if (ii) {
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, accum, 0);
        }
      }
      use = accum;
    } else {
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val2, ii, PIC_OPDST_W);
      if (ii && !pic_val_bank_same(pf, dst, val2)) {
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, accum, 0);
        pic_instr_append_daop(pf, dst, PIC_OPCODE_NONE, BOOLEAN_FALSE);
        use = accum;
      } else {
        use = val2;
      }
    }
    if (ii) {
      pic_instr_append_reg_flag(pf, pop_post, "_status", "_c");
      pic_instr_append_f_d(pf, pop_skip, use,
        (use == val2) ? ii : 0, PIC_OPDST_W);
    }
    pic_instr_append_f_d(pf, pop, dst, ii, PIC_OPDST_F);
  }
  pic_var_accum_release(pf, accum);
  if (tdst) {
    pic_op(pf, OPERATOR_ASSIGN, tdst, dst, VALUE_NONE);
    pic_var_temp_release(pf, dst);
  }
}

static void pic_add_sub_float(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  pic_var_float_t flt;
  label_t         lbl;
  const char     *which;

  pic_var_float_get(pf, &flt);
  pic_op(pf, OPERATOR_ASSIGN, flt.fval2, val2, VALUE_NONE);
  pic_op(pf, OPERATOR_ASSIGN, flt.fval1, val1, VALUE_NONE);
  which = (OPERATOR_ADD == op) ? PIC_LABEL_FLOAT_ADD : PIC_LABEL_FLOAT_SUB;
  lbl = pic_label_find(pf, which, BOOLEAN_TRUE);
  pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl);
  label_release(lbl);
  if ((VALUE_NONE != dst) && (flt.fval1 != dst)) {
    pic_op(pf, OPERATOR_ASSIGN, dst, flt.fval1, VALUE_NONE);
  }
}

static void pic_op_add_sub(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  variable_sz_t    sz;
  variable_const_t cn;

  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  sz = pic_result_sz_get(val1, val2, dst);
  /* one constant for addition : put into val2
   * if (dst,val2) are the same swap
   */
  if ((OPERATOR_ADD == op) && 
      (value_is_const(val1) || value_is_same(dst, val2))) {
    SWAP(value_t, val1, val2);
  }

  cn = 0;
  if (value_is_const(val2)) {
    cn = value_const_get(val2);
  }
    
  if (value_is_float(val1) || value_is_float(val2) || value_is_float(dst)) {
    pic_add_sub_float(pf, op, dst, val1, val2);
  } else if (value_is_const(val2) && (0 == cn)) {
    /* if val1 is signed, but the result is unsigned, change val1 */
    pic_unary_fixup(pf, OPERATOR_ASSIGN, dst, val1, val2);
  } else if (value_is_const(val2) && (1 == cn)) {
    pic_unary_fixup(pf, (OPERATOR_ADD == op) ? OPERATOR_INCR : OPERATOR_DECR, 
        dst, val1, val2);
  } else if (value_is_const(val2) && ((variable_const_t) -1 == cn)) {
    pic_unary_fixup(pf, (OPERATOR_ADD == op) ? OPERATOR_DECR : OPERATOR_INCR, 
        dst, val1, val2);
  } else if (value_is_const(val1) && (0 == value_const_get(val1))) {
    pic_unary_fixup(pf, (OPERATOR_ADD == op) ? OPERATOR_ASSIGN : OPERATOR_NEG,
        dst, val2, val1);
  } else if ((OPERATOR_ADD == op) && value_is_same(val1, val2)) {
    value_t tmp;

    tmp = pfile_constant_get(pf, 1, value_def_get(val1));
    pic_op(pf, OPERATOR_SHIFT_LEFT, dst, val1, tmp);
    value_release(tmp);
  } else if (pic_work_in_temp(pf, op, dst, val1, val2,
        PIC_WORK_IN_TEMP_FLAG_VALS
        | PIC_WORK_IN_TEMP_FLAG_DST
        | (((sz > 1) && !pic_is_16bit(pf)) 
            ? PIC_WORK_IN_TEMP_FLAG_DST_VOLATILE : 0))) {
  } else if (pic_is_16bit(pf) 
      || ((OPERATOR_ADD == op) && pic_is_14bit_hybrid(pf))) {
    /*
     * the 14 bit hybrid controllers do not have
     * the subfwb operator (they do have subwfb however).
     * The 16 bit subtract uses subfwb, so it cannot
     * be used on the 14 bit hybrids
     */
    pic_add_sub_16bit(pf, op, dst, val1, val2, sz);
  } else {
    boolean_t result_is_signed;

    result_is_signed = pic_result_is_signed(pf, val1, val2);
    if ((OPERATOR_SUB == op) && value_is_const(val1)) {
      variable_def_t   vdef;
      value_t          tmp;
      variable_sz_t    ii;
      variable_sz_t    ipos;

      /* dst = ~val2 + (val1 + 1) */
      pic_indirect_setup3(pf, dst, val1, val2, 0, &ipos);
      for (ii = 0; ii < sz; ii++) {
        pic_indirect_bump3(pf, dst, val1, val2, ii, &ipos);
        if (value_is_same(dst, val2)) {
          pic_instr_append_f_d(pf, PIC_OPCODE_COMF, dst, ii, PIC_OPDST_F);
        } else {
          if (ii < value_sz_get(val2)) {
            pic_instr_append_f_d(pf, PIC_OPCODE_COMF, val2, ii, PIC_OPDST_W);
          } else if (ii == value_sz_get(val2)) {
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0xff);
            if (value_is_signed(val2)) {
              pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, val2, 
                value_sz_get(val2) - 1, 7);
              pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
            }
          }
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
        }
      }

      /* pic_op(pf, OPERATOR_CMPB, dst, val2, VALUE_NONE); */
      cn = 1 + value_const_get(val1);
      if (sz < 4) {
        cn &= (1UL << 8 * sz) - 1;
      }
      if (0 == cn) {
        op = OPERATOR_NULL;
      } else {
        vdef = value_def_get(val1);
        tmp = pfile_constant_get(pf, cn,
          variable_def_alloc(0, variable_def_type_get(vdef),
            VARIABLE_DEF_FLAG_CONST
            | (variable_def_flag_test(vdef, VARIABLE_DEF_FLAG_SIGNED)
              ? VARIABLE_DEF_FLAG_SIGNED : VARIABLE_DEF_FLAG_NONE),
            sz));
        val1 = dst;
        val2 = tmp;
        op   = OPERATOR_ADD;
      }
    }
    if (OPERATOR_NULL != op) {
      if (value_is_const(val1)) {
        SWAP(value_t, val1, val2);
      }
      if (1 == sz) {
        pic_add_sub_1byte(pf, op, dst, val1, val2, sz);
      } else if (2 == sz) {
        pic_add_sub_2byte(pf, op, dst, val1, val2, sz);
      } else {
        pic_add_sub_nbyte(pf, op, dst, val1, val2, sz);
      }
    }
    pic_value_sign_extend(pf, dst, sz - 1, result_is_signed);
  }
}

/* 
 * return the shift value for a multiply or divide,
 * or 0 if the value is not const or not shiftable
 * (assumes shift of 0 is optimized out earlier)
 */
static value_t pic_shift_get(pfile_t *pf, value_t val, value_t val2)
{
  value_t shift_val;

  shift_val = VALUE_NONE;
  if (value_is_const(val)) {
    variable_const_t n;

    n = value_const_get(val);
    if (!(n & (n - 1))) {
      /* make this a shift */
      variable_const_t shift;

      for (shift = -1; n; shift++, n >>= 1)
        ;
      shift_val = pfile_constant_get(pf, shift, 
          pfile_variable_def_promotion_get(pf, OPERATOR_NULL, val, val2));
    }
  }
  return shift_val;
}

/*
 * 16 bit pics have a built in 8x8=16 multiplier, so use that
 * the constant is always on the right
 *   It appears 1 & 2 byte multiplies should be inlined
 * whereas anything larger should be a built-in
 */
static boolean_t pic_multiply_inline_16bit(pfile_t *pf, value_t dst, 
  value_t val1, value_t val2, pic_var_mul_t *mvars)
{
  value_t   prod;
  boolean_t was_inlined;

  prod = pfile_value_find(pf, PFILE_LOG_NONE, "prod");
  if (!prod) {
    was_inlined = BOOLEAN_FALSE;
  } else {
    variable_sz_t dst_sz;
    value_t       mresult;
    value_t       multiplicand;
    boolean_t     need_assign;

    was_inlined = BOOLEAN_TRUE;
    dst_sz = pic_result_sz_get(val1, val2, dst);
    if (value_is_indirect(dst)
      || value_is_volatile(dst) 
      || value_is_same(dst, val2)) {
      mresult = pic_cast(mvars->mresult, dst_sz);
      need_assign = BOOLEAN_TRUE;
    } else {
      mresult = pic_cast(dst, dst_sz);
      need_assign = BOOLEAN_FALSE;
    }
    if (value_is_indirect(val2)) {
      multiplicand = pic_cast(mvars->multiplicand, value_sz_get(val2));
      pic_op(pf, OPERATOR_ASSIGN, multiplicand, val2, VALUE_NONE);
    } else {
      multiplicand = val2;
      value_lock(val2);
    }
    if (value_is_indirect(val1)) {
      pic_indirect_setup(pf, val1, 0);
    }
    pic_multiply_create_fn(pf, LABEL_NONE, mresult, val1, multiplicand);
    if (need_assign) {
      pic_op(pf, OPERATOR_ASSIGN, dst, mresult, VALUE_NONE);
    } else {
      pic_value_sign_extend(pf, dst, dst_sz - 1,
        pic_result_is_signed(pf, val1, val2));
    }
    value_release(multiplicand);
    value_release(mresult);
    value_release(prod);
  }
  return was_inlined;
}

/*
 * if this particular multiplication is only used once, inline
 * it. On entry we know if there's a constant, it's in val2
 * return BOOLEAN_TRUE if this was inlined, BOOLEAN_FALSE otherwise
 */
static boolean_t pic_multiply_inline(pfile_t *pf, value_t dst, value_t val1,
  value_t val2, pic_var_mul_t *mvars)
{
  boolean_t     was_inlined;
  variable_sz_t w1;
  variable_sz_t w2;
  const pfile_multiply_width_table_entry_t *mw;
  size_t        ii;

  w1 = value_byte_sz_get(val1);
  w2 = value_is_universal(val2) ? w1 : value_byte_sz_get(val2);

  if (w1 > w2) {
    SWAP(variable_sz_t, w1, w2);
    SWAP(value_t, val1, val2);
  }
  was_inlined = BOOLEAN_FALSE;

  /* 16 bit, any multiply of 2x2 or less is always inlined */
  /* also inline a 3x1 as it is the same size (17 instructions) */
  if (pic_is_16bit(pf)
      && (((w1 <= 2) && (w2 <= 2))
          || ((w1 == 1) && (w2 == 3)))
      && pic_multiply_inline_16bit(pf, dst, val1, val2, mvars)) {
    was_inlined = BOOLEAN_TRUE;
  } else if (pfile_flag_test(pf, PFILE_FLAG_MISC_FASTMATH)) {
    for (ii = 0;
         (0 != (mw = pfile_multiply_width_table_entry_get(pf, ii)))
         && ((mw->multiplier != w1) || (mw->multiplicand != w2));
         ii++)
      ; /* null body */
    /* on everything, if a multiply is only used once, inline it */  
    if (mw && (1 == mw->use_ct)) {
      /* this can be inlined! */
      if (pic_is_16bit(pf)
          && pic_multiply_inline_16bit(pf, dst, val1, val2, mvars)) {
        was_inlined = BOOLEAN_TRUE;
      } else {
        value_t multiplier;
        value_t multiplicand;
        value_t mresult;

        multiplier = pic_cast(mvars->multiplier, w1);
        pic_op(pf, OPERATOR_ASSIGN, multiplier, val1, VALUE_NONE);
        if (value_is_indirect(val2)
          || value_is_volatile(val2) 
          || value_is_same(val2, dst)) {
          multiplicand = pic_cast(mvars->multiplicand, w2);
          pic_op(pf, OPERATOR_ASSIGN, multiplicand, val2, VALUE_NONE);
        } else {
          multiplicand = val2;
          value_lock(multiplicand);
        }
        if (value_is_volatile(dst)
          || value_is_indirect(dst)) {
          mresult = pic_cast(mvars->mresult, w2);
        } else {
          mresult = pic_cast(dst, w2);
        }
        pic_multiply_create_fn(pf, LABEL_NONE, mresult, multiplier, 
            multiplicand);
        if (value_variable_get(mresult) != value_variable_get(dst)) {
          pic_op(pf, OPERATOR_ASSIGN, dst, mresult, VALUE_NONE);
        } else {
          pic_value_sign_extend(pf, dst, value_byte_sz_get(mresult) - 1,
            pic_result_is_signed(pf, val1, val2));
        }
        value_release(mresult);
        value_release(multiplicand);
        value_release(multiplier);
      }
    }
  }
  return was_inlined;
}

/*
 * adjust a float by a power of two (add or subtract from the exponent)
 * return BOOLEAN_TRUE if exponent adjusted, otherwise BOOLEAN_FALSE
 */
static boolean_t pic_float_adj_exp(pfile_t *pf, value_t dst, value_t val1,
  value_t val2, pic_opcode_t op)
{
  boolean_t        ret;

  ret = BOOLEAN_FALSE;
  if (value_is_const(val2)) {
    variable_const_t shift; /* shift distance */
    boolean_t        neg;   /* negate result  */

    if (value_is_float(val2)) {
      float n;
      float mantissa;
      int   exp;

      n = value_const_float_get(val2);
      neg = n < 0.0;
      if (neg) {
        n = -n;
      }

      mantissa = frexp(value_const_float_get(val2), &exp);
      if ((mantissa - 0.5) < 0.0000001) {
        /* This is a power of 2. */
        ret = BOOLEAN_TRUE;
        exp--;
        if (exp < 0) {
          op = (PIC_OPCODE_ADDLW == op)
            ? PIC_OPCODE_SUBLW
            : PIC_OPCODE_ADDLW;
          exp = -exp;
        }
        shift = exp;
      }
    } else {
      variable_const_t n;

      n = value_const_get(val2);
      neg = (value_is_signed(val2) && (n & 0x80000000));
      if (neg) {
        n = -n;
      } 
      if ((n & (n - 1)) == 0) {

        ret = BOOLEAN_TRUE;
        for (shift = -1; n; shift++, n = n >> 1)
          ; /* null body */
      }
    }
    if (BOOLEAN_TRUE == ret) {
      pic_op(pf, (neg) ? OPERATOR_NEG : OPERATOR_ASSIGN, dst, val1,
        VALUE_NONE);
      if (shift) {
        value_t accum;
        label_t lbl_skip;
        label_t lbl_zero;

        accum = pic_var_accum_get(pf);
        lbl_skip = pfile_label_alloc(pf, 0);
        lbl_zero = pfile_label_alloc(pf, 0);
        pic_instr_append_f_d(pf, PIC_OPCODE_RLF, dst, 2, PIC_OPDST_W);
        pic_instr_append_f_d(pf, PIC_OPCODE_RLF, dst, 3, PIC_OPDST_W);
        /* If dst is 0, no action so skip. */
        pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xff);
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_skip);
        if (PIC_OPCODE_ADDLW == op) {
          pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, shift);
          /*
           * Check for overflow. If 'C' is set, we've overflow. Also
           * if the result is 0xff, that's also overflow.
           */
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_zero);
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, accum, 0);
          pic_instr_append_w_kn(pf, PIC_OPCODE_SUBLW, 0xff);
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_zero);
        } else {
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, accum, 0);
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, shift);
          pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, accum, 0, PIC_OPDST_F);
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_zero);
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_c");
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_zero);
        }
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0x80);
        pic_instr_append_f_d(pf, PIC_OPCODE_ANDWF, dst, 3, PIC_OPDST_F);
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
        pic_instr_append_f_d(pf, PIC_OPCODE_RRF, accum, 0, PIC_OPDST_W);
        pic_instr_append_f_bn(pf, PIC_OPCODE_BCF, dst, 2, 7);
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
        pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, dst, 2, 7);
        pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, dst, 3, PIC_OPDST_F);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_skip);
        pic_instr_append_label(pf, lbl_zero);
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, 0);
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, 1);
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, 2);
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, 3);
        pic_instr_append_label(pf, lbl_skip);
        label_release(lbl_skip);
        label_release(lbl_zero);
        pic_var_accum_release(pf, accum);
      }
    }
  }
  return ret;
}


static void pic_float_mul(pfile_t *pf, value_t dst, value_t val1, 
  value_t val2) 
{
  if (value_is_const(val1)) {
    SWAP(value_t, val1, val2);
  }
  if (!pic_float_adj_exp(pf, dst, val1, val2, PIC_OPCODE_ADDLW)) {
    pic_var_float_t flt;
    label_t         lbl;

    lbl = pic_label_find(pf, PIC_LABEL_FLOAT_MULTIPLY, BOOLEAN_TRUE);
    pic_var_float_get(pf, &flt);
    pic_op(pf, OPERATOR_ASSIGN, flt.fval2, val2, VALUE_NONE);
    pic_op(pf, OPERATOR_ASSIGN, flt.fval1, val1, VALUE_NONE);
    pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl);
    pic_op(pf, OPERATOR_ASSIGN, dst, flt.fval1, VALUE_NONE);
    pic_var_float_release(pf, &flt);
    label_release(lbl);
  }
}

static void pic_op_mul(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  UNUSED(op);

  /* make sure the constant is on the right */
  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  if (value_is_const(val1)) {
    SWAP(value_t, val1, val2);
  }
  if (value_is_const(val2) && (0 == value_const_get(val2))) {
    pic_assign_const(pf, dst, val1, val2, 0);
  } else if (value_is_const(val2) && (1 == value_const_get(val2))) {
    pic_unary_fixup(pf, OPERATOR_ASSIGN, dst, val1, val2);
  } else if (value_is_const(val2) 
      && ((variable_const_t) -1 == value_const_get(val2))) {
    pic_unary_fixup(pf, OPERATOR_NEG, dst, val1, val2);
  } else if (value_is_float(val1) || value_is_float(val2)) {
    pic_float_mul(pf, dst, val1, val2);
  } else {
    value_t shift_val;

    shift_val = pic_shift_get(pf, val2, val1);
    if (shift_val) {
      pic_op(pf, OPERATOR_SHIFT_LEFT, dst, val1, shift_val);
      value_release(shift_val);
    } else {
      pic_var_mul_t  mvars;
      variable_def_t def;
      value_t        tmp;
      boolean_t      skip_assign;
      variable_sz_t  w1;
      variable_sz_t  w2;

      skip_assign = BOOLEAN_FALSE;
      w1 = value_byte_sz_get(val1);
      w2 = value_is_universal(val2) ? w1 : value_byte_sz_get(val2);

      /* multiplier is always the narrower of the two */
      if (w1 > w2) {
        SWAP(value_t, val1, val2);
        SWAP(variable_sz_t, w1, w2);
      }

      pic_var_mul_get(pf, w1, w2, &mvars);
      if ((value_is_same(val1, pic_last_values[PIC_LAST_VALUE_MULTIPLIER])
          && value_is_same(val2, pic_last_values[PIC_LAST_VALUE_MULTIPLICAND]))
          || (value_is_same(val1, pic_last_values[PIC_LAST_VALUE_MULTIPLICAND])
            && value_is_same(val2, pic_last_values[PIC_LAST_VALUE_MULTIPLIER]))
          ) {
        /* we needn't do anything here */
      } else {
        pic_last_values_reset();
        if (pic_multiply_inline(pf, dst, val1, val2, &mvars)) {
          skip_assign = BOOLEAN_TRUE;
        } else {
          label_t fn;
          char    label[32];

          if (pfile_flag_test(pf, PFILE_FLAG_MISC_FASTMATH)) {
            tmp = pic_cast(mvars.multiplier, w1);
            pic_op(pf, OPERATOR_ASSIGN, tmp, val1, VALUE_NONE);
            value_release(tmp);

            tmp = pic_cast(mvars.multiplicand, w2);
            pic_op(pf, OPERATOR_ASSIGN, tmp, val2, VALUE_NONE);
            value_release(tmp);

            sprintf(label, "%s_%u_%u", PIC_LABEL_MULTIPLY, w1, w2);
          } else {
            strcpy(label, PIC_LABEL_MULTIPLY);
            pic_op(pf, OPERATOR_ASSIGN, mvars.multiplier, val1, VALUE_NONE);
            pic_op(pf, OPERATOR_ASSIGN, mvars.multiplicand, val2, VALUE_NONE);
          }
          fn = pic_label_find(pf, label, BOOLEAN_TRUE);
          pic_instr_append_n(pf, PIC_OPCODE_CALL, fn);
          label_release(fn);
          pic_last_value_set(PIC_LAST_VALUE_MULTIPLIER,   val1);
          pic_last_value_set(PIC_LAST_VALUE_MULTIPLICAND, val2);
        }
      }
      if (!skip_assign) {
        tmp = value_clone(mvars.mresult);
        def = pfile_variable_def_promotion_get(pf, OPERATOR_NULL,
            val1, val2);
        value_def_set(tmp, def);
        pic_op(pf, OPERATOR_ASSIGN, dst, tmp, VALUE_NONE);
        value_release(tmp);
      }
      pic_var_mul_release(pf, &mvars);
    }
  }
}

static void pic_float_div(pfile_t *pf, value_t dst, value_t val1,
  value_t val2)
{
  if (!pic_float_adj_exp(pf, dst, val1, val2, PIC_OPCODE_SUBLW)) {
    label_t         lbl;
    pic_var_float_t flt;

    pic_var_float_get(pf, &flt);
    lbl = pic_label_find(pf, PIC_LABEL_FLOAT_DIVIDE, BOOLEAN_TRUE);
    pic_op(pf, OPERATOR_ASSIGN, flt.fval2, val2, VALUE_NONE);
    pic_op(pf, OPERATOR_ASSIGN, flt.fval1, val1, VALUE_NONE);
    pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl);
    pic_op(pf, OPERATOR_ASSIGN, dst, flt.fval1, VALUE_NONE);
    label_release(lbl);
    pic_var_float_release(pf, &flt);
  }
}

static void pic_op_div_mod(pfile_t *pf, operator_t op, value_t dst, 
    value_t val1, value_t val2)
{
  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  if (value_is_const(val2) && (0 == value_const_get(val2))) {
    pfile_log(pf, PFILE_LOG_ERR, "division by zero");
  } else if (value_is_same(val1, val2)) {
    pic_assign_const(pf, dst, val1, val2, (OPERATOR_DIV == op) ? 1 : 0);
  } else if (value_is_const(val2) && (1 == value_const_get(val2))) {
    if (OPERATOR_DIV == op) {
      pic_unary_fixup(pf, OPERATOR_ASSIGN, dst, val1, val2);
    } else {
      pic_assign_const(pf, dst, val1, val2, 0);
    }
  } else if (value_is_const(val2) 
      && pic_result_is_signed(pf, val1, val2)
      && ((variable_const_t) -1 == value_const_get(val2))) {
    if (OPERATOR_DIV == op) {
      pic_unary_fixup(pf, OPERATOR_NEG, dst, val1, val2);
    } else {
      pic_assign_const(pf, dst, val1, val2,  0);
    }
  } else if (value_is_float(val1) || value_is_float(val2)) {
    pic_float_div(pf, dst, val1, val2);
  } else {
    value_t shift_val;

    shift_val = pic_shift_get(pf, val2, val1);
    /* cannot shift right if the result is signed, for example
     * -1 / 8 should be zero, but would shift into -1 */
    if (shift_val && !pic_result_is_signed(pf, val1, val2)) {
      if (OPERATOR_DIV == op) {
        /* right shift */
        pic_op(pf, OPERATOR_SHIFT_RIGHT, dst, val1, shift_val);
      } else if (OPERATOR_MOD == op) {
        /* binary and */
        value_t tmp;

        tmp = pfile_constant_get(pf, value_const_get(val2) - 1, 
            pfile_variable_def_promotion_get(pf, op, val1, val2));
        pic_op(pf, OPERATOR_ANDB, dst, val1, tmp);
        value_release(tmp);
      }
      value_release(shift_val);
    } else {
      variable_sz_t sz;
      pic_var_div_t dvars;
      value_t       result;

      sz = pic_result_sz_get(val1, val2, VALUE_NONE);
      pic_var_div_get(pf, sz, &dvars);
      if (value_is_same(pic_last_values[PIC_LAST_VALUE_DIVIDEND], val1)
          && value_is_same(pic_last_values[PIC_LAST_VALUE_DIVISOR], val2)) {
      } else {
        label_t fn;

        pic_op(pf, OPERATOR_ASSIGN, dvars.divisor,  val2, VALUE_NONE);
        pic_op(pf, OPERATOR_ASSIGN, dvars.dividend, val1, VALUE_NONE);
        fn = pic_label_find(pf,
            (VARIABLE_DEF_FLAG_SIGNED == pic_result_flag_get(pf, val1, val2))
            ? PIC_LABEL_SDIVIDE
            : PIC_LABEL_DIVIDE,
            BOOLEAN_TRUE);
        pic_instr_append_n(pf, PIC_OPCODE_CALL, fn);
        label_release(fn);
        pic_last_values_reset();
        pic_last_value_set(PIC_LAST_VALUE_DIVIDEND, val1);
        pic_last_value_set(PIC_LAST_VALUE_DIVISOR, val2);
      }
      result = (OPERATOR_DIV == op)
        ? dvars.quotient : dvars.remainder;
      if (pic_result_is_signed(pf, val1, val2)
          ^ value_is_signed(result)) {
        variable_def_t def;
        value_t        tmp;

        tmp = value_clone(result);
        def = pfile_variable_def_promotion_get(pf, OPERATOR_NULL,
            val1, val2);
        value_def_set(tmp, def);
        pic_op(pf, OPERATOR_ASSIGN, dst, tmp, VALUE_NONE);
        value_release(tmp);
      } else {
        pic_op(pf, OPERATOR_ASSIGN, dst, result, VALUE_NONE);
      }
      pic_var_div_release(pf, &dvars);
    }
  }
}

/* if dst is a single, non-volatile bit, clear it for 0, set for 1
 */
#define PIC_ASSIGN_LOGICAL_TO_DST_NONE 0x0000
#define PIC_ASSIGN_LOGICAL_TO_DST_OP   0x0001 /* finish with pic_op(..) */
static void pic_assign_logical_to_dst(pfile_t *pf, value_t dst, uchar n,
    unsigned flags)
{
  assert((0 == n) || (1 == n));
  if (value_is_single_bit(dst)) {
    pic_instr_append_f(pf,
        (n) ? PIC_OPCODE_BSF : PIC_OPCODE_BCF,
        dst, 0);
  } else {
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, n);
    if (flags & PIC_ASSIGN_LOGICAL_TO_DST_OP) {
      /* assign the result to dst */
      pic_op(pf, OPERATOR_ASSIGN, dst, VALUE_NONE, VALUE_NONE);
    }
  }
}

typedef enum {
  PIC_VALUE_TO_W_NONE, /* unused */
  PIC_VALUE_TO_W_MOV,
  PIC_VALUE_TO_W_SUB,
  PIC_VALUE_TO_W_ADD
} pic_value_to_w_t;

static void pic_value_to_w(pfile_t *pf, pic_value_to_w_t op,
    value_t val, value_t val_sign, variable_sz_t pos)
{
  if (value_is_const(val) 
      || (VALUE_NONE == val)
      || ((VALUE_NONE == val_sign) && (pos >= value_sz_get(val)))) {
    pic_opcode_t pop;

    pop = PIC_OPCODE_NONE;
    switch (op) {
      case PIC_VALUE_TO_W_NONE: break;
      case PIC_VALUE_TO_W_MOV:  pop = PIC_OPCODE_MOVLW; break;
      case PIC_VALUE_TO_W_SUB:  pop = PIC_OPCODE_SUBLW; break;
      case PIC_VALUE_TO_W_ADD:  pop = PIC_OPCODE_ADDLW; break;
    }
    if ((VALUE_NONE == val)/* || (pos >= value_sz_get(val))*/) {
      pic_instr_append_w_kn(pf, pop, 0);
    } else {
      pic_instr_append_w_kn(pf, pop, pic_value_const_byte_get(val, pos));
    }
  } else {
    pic_opcode_t pop;

    pop = PIC_OPCODE_NONE;
    switch (op) {
      case PIC_VALUE_TO_W_NONE: break;
      case PIC_VALUE_TO_W_MOV:  pop = PIC_OPCODE_MOVF;  break;
      case PIC_VALUE_TO_W_SUB:  pop = PIC_OPCODE_SUBWF; break;
      case PIC_VALUE_TO_W_ADD:  pop = PIC_OPCODE_ADDWF; break;
    }
    if (pos >= value_sz_get(val)) {
      pic_instr_append_f_d(pf, pop, val_sign, 0, PIC_OPDST_W);
    } else {
      pic_instr_append_f_d(pf, pop, val, pos, PIC_OPDST_W);
    }
  }
}

/* when this is called, W is either 0, 1, or 255
 * in the later case, if w is 255 we'll want to replicate it
 */
static void pic_assign_from_w(pfile_t *pf, value_t dst, boolean_t sign_extend)
{
  if (!pic_value_is_w(dst)) {
    variable_sz_t ipos;
    variable_sz_t ii;

    ipos = 0;
    if (value_is_indirect(dst)) {
      value_t accum;

      accum = pic_var_accum_get(pf);
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, accum, 0);
      pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, accum, 0, PIC_OPDST_W);
      pic_var_accum_release(pf, accum);
    }
    for (ii = 0; ii < value_sz_get(dst); ii++) {
      pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
      if ((0 == ii) || sign_extend) {
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
      } else {
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
      }
    }
  }
}

/* much simpler than relational -- need only compare bytes;
 * nb : this is called for both OPERATOR_EQ & OPERATOR_NE
 * if dst is VALUE_NONE, the caller must check _Z and act
 * appropriately.
 */
static operator_t pic_relational_float(pfile_t *pf, operator_t op, 
  value_t dst, value_t val1, value_t val2);
static void pic_equality(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  if (value_is_same(val1, val2)) {
    value_t          c;

    c = pfile_constant_get(pf, 
        (OPERATOR_EQ == op) ? 1 : 0, VARIABLE_DEF_NONE);
    pic_op(pf, OPERATOR_ASSIGN, dst, c, VALUE_NONE);
    value_release(c);
  } else if (value_is_float(val1) || value_is_float(val2)) {
    pic_relational_float(pf, op, dst, val1, val2);
  } else if (value_is_single_bit(val1) 
    && value_is_single_bit(val2)
    && !value_is_const(val1)
    && !value_is_const(val2)) {
    /* possible cases:
     *   dst == VALUE_NONE : need only set or clear status<z>
     *   dst is single bit
     *     volatile or different bank than val1/val2
     *   otherwise, work in W and assign
     */
    label_t      lbl_val1_clear;
    label_t      lbl_false;
    label_t      lbl_true;
    label_t      lbl_done;
    pic_opcode_t op_true;
    pic_opcode_t op_false;
    uchar        val_true;
    uchar        val_false;

    if (dst && (OPERATOR_NE == op)) {
      op_true   = PIC_OPCODE_BCF;
      op_false  = PIC_OPCODE_BSF;
      val_true  = 0;
      val_false = 1;
    } else {
      op_true   = PIC_OPCODE_BSF;
      op_false  = PIC_OPCODE_BCF;
      val_true  = 1;
      val_false = 0;
    }

    lbl_val1_clear = pfile_label_alloc(pf, 0);
    lbl_false      = pfile_label_alloc(pf, 0);
    lbl_true       = pfile_label_alloc(pf, 0);
    lbl_done       = pfile_label_alloc(pf, 0);

    /* for single bits, dst and val2 must be in the same bank */
    if (value_is_single_bit(dst)
      && !pic_val_bank_same(pf, dst, val2)
      && pic_val_bank_same(pf, dst, val1)) {
      value_t tmp;

      tmp = val1;
      val1 = val2;
      val2 = tmp;
    }

    if (value_is_single_bit(dst) 
      && (value_is_volatile(dst) 
        || !pic_val_bank_same(pf, dst, val2))) {
      /* this needs a bit different strategy */
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_val1_clear);
      /* val1 is TRUE */
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_false);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_true);
      /* val1 is FALSE */
      pic_instr_append_label(pf, lbl_val1_clear);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_true);
      /* the result is FALSE */
      pic_instr_append_label(pf, lbl_false);
      pic_instr_append_f(pf, op_false, dst, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      /* the result is TRUE */
      pic_instr_append_label(pf, lbl_true);
      pic_instr_append_f(pf, op_true, dst, 0);
    } else {
      /* initialize dst to TRUE */
      if (!dst) {
        pic_instr_append_reg_flag(pf, op_true, "_status", "_z");
      } else if (value_is_single_bit(dst)) {
        pic_instr_append_f(pf, op_true, dst, 0);
      } else {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, val_true);
      }
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_val1_clear);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_false);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_label(pf, lbl_val1_clear);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
      pic_instr_append_label(pf, lbl_false);
      if (!dst) {
        pic_instr_append_reg_flag(pf, op_false, "_status", "_z");
      } else if (value_is_single_bit(dst)) {
        pic_instr_append_f(pf, op_false, dst, 0);
      } else {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, val_false);
      }
    }
    pic_instr_append_label(pf, lbl_done);
    if (dst && !value_is_single_bit(dst)) {
      pic_op(pf, OPERATOR_ASSIGN, dst, VALUE_NONE, VALUE_NONE);
    }
    label_release(lbl_done);
    label_release(lbl_true);
    label_release(lbl_false);
    label_release(lbl_val1_clear);
  } else if (!pic_work_in_temp(pf, op, dst, val1, val2,
        PIC_WORK_IN_TEMP_FLAG_VALS
        | (value_is_single_bit(dst)
          ? 0
          : PIC_WORK_IN_TEMP_FLAG_DST))) {
    value_t       tmp; /* for multi-byte operations */
    value_t       val1_sign;
    value_t       val2_sign;
    variable_sz_t sz;
    variable_sz_t ii;
    variable_sz_t ipos;
    variable_const_t cn;

    sz = pic_result_sz_get(val1, val2, VALUE_NONE);
    val1_sign = VALUE_NONE;
    val2_sign = VALUE_NONE;
    tmp       = VALUE_NONE;
    if (sz > 1) {
      tmp = pic_var_temp_get(pf, VARIABLE_DEF_FLAG_NONE, 1);
    }
    pic_indirect_setup3(pf, val1, val2, VALUE_NONE, 0, &ipos);
    /* if this is const v. variable, put the const on the left */
    if (value_is_const(val2)) {
      assert(!value_is_const(val1));
      SWAP(value_t, val1, val2);
    }
    cn = 0;
    if (value_is_const(val1)) {
      cn = value_const_get(val1);
    }
    for (ii = 0; ii < sz; ii++) {
      pic_opcode_t     pop;
      variable_const_t cn_pv;

      cn_pv = cn;
      if (!value_is_const(val1) && (ii == value_sz_get(val1))) {
        val1_sign = pic_value_sign_get(pf, val1, VALUE_NONE);
        val1      = val1_sign;
      } else if (!value_is_const(val2) && (ii == value_sz_get(val2))) {
        val2_sign = pic_value_sign_get(pf, val2, VALUE_NONE);
        val2      = val2_sign;
      }
      pic_indirect_bump3(pf, val1, val2, VALUE_NONE, ii, &ipos);

      pop = PIC_OPCODE_NONE;
      if (value_is_const(val1)) {
        uchar ch;

        ch = pic_value_const_byte_get(val1, ii);
        if (0 == ch) {
          pop = (0 == cn) ? PIC_OPCODE_IORWF : PIC_OPCODE_MOVF;
        } else if (1 == ch) {
          pop = PIC_OPCODE_DECF;
        } else if (255 == ch) {
          pop = PIC_OPCODE_INCF;
        } else {
          pop = PIC_OPCODE_SUBWF;
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, ch);
        }
        cn = cn >> 8;
      } else if (VALUE_NONE != val1) {
        pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val1, 
            (val1 == val1_sign) ? 0 : ii, PIC_OPDST_W);
        pop = PIC_OPCODE_SUBWF;
      }
      if (value_is_const(val2)) {
        assert(0);
        pic_instr_append_w_kn(pf, PIC_OPCODE_SUBLW,
            pic_value_const_byte_get(val2, ii));
      } else if (VALUE_NONE != val2) {
        pic_instr_append_f_d(pf, 
            (VALUE_NONE == val1) ? PIC_OPCODE_MOVF : pop, 
            val2, (val2 == val2_sign) ? 0 : ii, PIC_OPDST_W);
      }
      if (VALUE_NONE != tmp) {
        if (ii) {
          if (!value_is_const(val1) || (cn_pv != 0)) {
            pic_instr_append_f_d(pf,
                PIC_OPCODE_IORWF, tmp, 0, 
                ((ii + 1 == sz) || (value_is_const(val1) && (0 == cn)))
                ? PIC_OPDST_W : PIC_OPDST_F);
          }
        } else {
          if (!value_is_const(val1) || (cn != 0)) {
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, tmp, 0);
          }
        }
      }
    }
    /* _status:_z is set for equal (w = 0), clear for not (w != 0) */
    if ((VALUE_NONE != dst) 
        && !value_is_single_bit(dst)) {
      pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 1);
      if (OPERATOR_EQ == op) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_XORLW, 1);
      }
    }
    if (VALUE_NONE != val2_sign) {
      pic_var_accum_release(pf, val2_sign);
    }
    if (VALUE_NONE != val1_sign) {
      pic_var_accum_release(pf, val1_sign);
    }
    if (VALUE_NONE != tmp) {
      pic_var_temp_release(pf, tmp);
    }
    if (value_is_indirect(dst)) {
      /* must sock W away */
      tmp = pic_var_temp_get(pf, VARIABLE_DEF_FLAG_NONE, 1);
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, tmp, 0);
      pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tmp, 0, PIC_OPDST_W);
      pic_var_temp_release(pf, tmp);
    }
    if (value_is_single_bit(dst)) {
      pic_opcode_t skip_op;

      skip_op = (OPERATOR_EQ == op) 
        ? PIC_OPCODE_BTFSC 
        : PIC_OPCODE_BTFSS;
      if (value_is_volatile(dst)) {
        label_t lbl_set;
        label_t lbl_done;

        lbl_set = pfile_label_alloc(pf, 0);
        lbl_done = pfile_label_alloc(pf, 0);
        pic_instr_append_reg_flag(pf, skip_op, "_status", "_z");
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
        pic_instr_append_label(pf, lbl_set);
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        pic_instr_append_label(pf, lbl_done);
        label_release(lbl_done);
        label_release(lbl_set);
      } else {
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        pic_instr_append_reg_flag(pf, skip_op, "_status", "_z");
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      }
    } else if (!pic_value_is_w(dst)) {
      pic_assign_from_w(pf, dst, BOOLEAN_FALSE);
    }
  }
}

/* 
 * one of val1 or val2 must be float. the result is wholey defined by the 
 * flt.fval1 exponent + sign.
 *   sign(1)  : <
 *   exp == 0 : ==
 *   sign(0)  : >
 *
 * if dst is VALUE_NONE, 'C' and 'Z' are expected to be set as appropriate
 */
static operator_t pic_relational_float(pfile_t *pf, operator_t op, 
  value_t dst, value_t val1, value_t val2)
{
  pic_var_float_t flt;

  /*
   * put the const on the right
   */
  if (value_is_const(val1)) {
    SWAP(value_t, val1, val2);
    if (OPERATOR_GE == op) {
      op = OPERATOR_LE;
    } else if (OPERATOR_GT == op) {
      op = OPERATOR_LT;
    } else if (OPERATOR_LE == op) {
      op = OPERATOR_GE;
    } else if (OPERATOR_LT == op) {
      op = OPERATOR_GT;
    }
  }
  if (value_is_const(val2)
    && ((value_is_float(val2) && (0.0 == value_const_float_get(val2)))
      || (!value_is_float(val2) && (0 == value_const_get(val2))))) {
    /* this is (val1 op 0). Start by setting 'Z' */
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, val1, 2, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, val1, 3, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xff);
    /* 'Z' is set if val2 is 0 */
    if (VALUE_NONE == dst) {
      if ((OPERATOR_EQ != op) && (OPERATOR_NE != op)) {
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BSF, "_status", "_c");
        pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, val1, 3, 7);
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
      }
    } else {
      label_t lbl;

      pic_var_float_get(pf, &flt);
      pic_instr_append_f(pf, PIC_OPCODE_CLRF, flt.exp1, 0);
      switch (op) {
        case OPERATOR_EQ: /*       Z */
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
          pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
          break;
        case OPERATOR_NE: /*      !Z */
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
          pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
          break;
        case OPERATOR_LT: /* C && !Z */
          lbl = pfile_label_alloc(pf, 0);
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
          pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, val1, 3, 7);
          pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
          pic_instr_append_label(pf, lbl);
          label_release(lbl);
          break;
        case OPERATOR_LE: /* C ||  Z */
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
          pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, val1, 3, 7);
          pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
          break;
        case OPERATOR_GE: /* !C || Z */
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
          pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, val1, 3, 7);
          pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
          break;
        case OPERATOR_GT: /* !C && !Z */
          lbl = pfile_label_alloc(pf, 0);
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
          pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, val1, 3, 7);
          pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
          pic_instr_append_label(pf, lbl);
          label_release(lbl);
          break;
        default:
          break;
      }
      pic_op(pf, OPERATOR_ASSIGN, dst, flt.exp1, VALUE_NONE);
      pic_var_float_release(pf, &flt);
    }
  } else {
    /* only deal with < and <= */
    if ((OPERATOR_GE == op) || (OPERATOR_GT == op)) {
      SWAP(value_t, val1, val2);
      op = (OPERATOR_GE == op) 
         ? OPERATOR_LE
         : OPERATOR_LT;
    }
    pic_add_sub_float(pf, OPERATOR_SUB, VALUE_NONE, val1, val2);
    pic_var_float_get(pf, &flt);
    /* set flt.exp1 to 0 if the result is FALSE, else 1 */
    if (VALUE_NONE != dst) {
      pic_instr_append_f(pf, PIC_OPCODE_CLRF, flt.exp1, 0);
    }
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval1, 2, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval1, 3, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xff);
      /* Z is set if the exponent is 0 */
    if (VALUE_NONE == dst) {
      /* C doesn't matter in the simple equality test */
      if ((OPERATOR_EQ != op) && (OPERATOR_NE != op)) {
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
        pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, flt.fval1, 3, 7);
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BSF, "_status", "_c");
      }
    } else {
      label_t lbl;

      lbl = pfile_label_alloc(pf, 0);
      switch (op) {
        case OPERATOR_EQ:
        case OPERATOR_NE:
          pic_instr_append_reg_flag(pf,
            (OPERATOR_EQ == op) ? PIC_OPCODE_BTFSC : PIC_OPCODE_BTFSS,
            "_status", "_z");
          pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
          break;
        case OPERATOR_LT: /* (sign bit set) AND (z == 0) */
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
          pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, flt.fval1, 3, 7);
          pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
          pic_instr_append_label(pf, lbl);
          break;
        case OPERATOR_LE: /* (sign bit set) OR (z == 1) */
          pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, flt.fval1, 3, 7);
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BSF, "_status", "_z");
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
          pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
          break;
        default:
          break;
      }
      label_release(lbl);
      pic_op(pf, OPERATOR_ASSIGN, dst, flt.exp1, VALUE_NONE);
    }
    pic_var_float_release(pf, &flt);
  }
  return op;
}

/* this only handles <, <=, >=, >; the rest are handled by pic_equality
 * on exit, if dst is VALUE_NONE, _C and/or _Z must be tested by the caller 
 * also note the operator might change.
 */
operator_t pic_relational(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  if ((OPERATOR_EQ == op) || (OPERATOR_NE == op)) {
    pic_equality(pf, op, dst, val1, val2);
  } else if (value_is_same(val1, val2)) {
    value_t          c;

    c = pfile_constant_get(pf,
          ((OPERATOR_LE == op) || (OPERATOR_GE == op)) ? 1 : 0,
          VARIABLE_DEF_NONE);
    pic_op(pf, OPERATOR_ASSIGN, dst, c, VALUE_NONE);
    value_release(c);
  } else if (value_is_float(val1) || value_is_float(val2)) {
    op = pic_relational_float(pf, op, dst, val1, val2);
  } else {
    /*
     * nb: this must be done before pic_work_in_temp or we lose
     *     the operator if it changes, resulting in B00063
     */
    if (value_is_const(val2)) {
      /* val1 *must* be the const, so swap these & fixup the op */
      SWAP(value_t, val1, val2);
      switch (op) {
        case OPERATOR_LT: op = OPERATOR_GT; break;
        case OPERATOR_LE: op = OPERATOR_GE; break;
        case OPERATOR_GE: op = OPERATOR_LE; break;
        case OPERATOR_GT: op = OPERATOR_LT; break;
        default: abort();
      }
    }
    if (!pic_work_in_temp(pf, op, dst, val1, val2,
        PIC_WORK_IN_TEMP_FLAG_VALS
        | (value_is_single_bit(dst)
          ? 0
          : PIC_WORK_IN_TEMP_FLAG_DST))) {
      /* unlike equality, relationals must work from the highest
       * part of the # to the lowest */
      variable_sz_t sz;
      variable_sz_t ipos;
      variable_sz_t ii;
      value_t       val1_sign;
      value_t       val2_sign;
      label_t       lbl_done;
      boolean_t     is_first;

      val1_sign = VALUE_NONE;
      val2_sign = VALUE_NONE;
      is_first  = BOOLEAN_TRUE;

      lbl_done = pfile_label_alloc(pf, 0);
      sz = pic_result_sz_get(val1, val2, VALUE_NONE);
      pic_indirect_setup3(pf, val1, val2, VALUE_NONE, sz - 1, &ipos);
      ii = sz;
      if (!value_is_const(val1) && (ii > value_sz_get(val1))) {
        val1_sign = pic_value_sign_get(pf, val1, VALUE_NONE);
        if (VALUE_NONE == val1_sign) {
          val1_sign = pic_var_accum_get(pf);
          pic_instr_append_f(pf, PIC_OPCODE_CLRF, val1_sign, 0);
        }
      }
      if (!value_is_const(val2) && (ii > value_sz_get(val2))) {
        val2_sign = pic_value_sign_get(pf, val2, VALUE_NONE);
        if (VALUE_NONE == val2_sign) {
          val2_sign = pic_var_accum_get(pf);
          pic_instr_append_f(pf, PIC_OPCODE_CLRF, val2_sign, 0);
        }
      }
      if (pic_result_is_signed(pf, val1, val2)) {
        value_t tmp;

        tmp = pic_var_temp_get(pf, VARIABLE_DEF_FLAG_NONE, 1);
        pic_value_to_w(pf, PIC_VALUE_TO_W_MOV, val2, val2_sign, ii - 1);
        pic_instr_append_w_kn(pf, PIC_OPCODE_XORLW, 0x80);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, tmp, 0);
        if (value_is_const(val1)) {
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW,
            pic_value_const_byte_get(val1, ii - 1) ^ 0x80);
        } else {
          pic_value_to_w(pf, PIC_VALUE_TO_W_MOV, val1, val1_sign, ii - 1);
          pic_instr_append_w_kn(pf, PIC_OPCODE_XORLW, 0x80);
        }
        pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, tmp, 0, PIC_OPDST_W);
        pic_var_temp_release(pf, tmp);
        is_first = BOOLEAN_FALSE;
        ii--;
      }
      while (ii--) {
        if (!is_first) {
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
          pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
        }
        is_first = BOOLEAN_FALSE;
        pic_indirect_bump3(pf, val1, val2, VALUE_NONE, ii, &ipos);
        pic_value_to_w(pf, PIC_VALUE_TO_W_MOV, val1, val1_sign, ii);
        pic_value_to_w(pf, 
            (value_is_const(val2) ? PIC_VALUE_TO_W_ADD : PIC_VALUE_TO_W_SUB), 
             val2, val2_sign, ii);
      }
      pic_instr_append_label(pf, lbl_done);

      /* _c & !_z : val1 < val2  */
      /* _c & _z  : val1 <= val2 */
      /* !_c & _z : val1 >= val2 */
      /* !_c & !_z: val1 >  val2 */
      if (VALUE_NONE != dst) {
        label_t lbl_skip;

        lbl_skip = LABEL_NONE;
        if ((OPERATOR_LT == op) || (OPERATOR_GT == op)) {
          lbl_skip = pfile_label_alloc(pf, 0);
        }

        if (value_is_single_bit(dst)) {
          pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        } else {
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
        }
        switch (op) {
          case OPERATOR_LT:
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
            pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_skip);
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
            break;
          case OPERATOR_LE:
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
            break;
          case OPERATOR_GE:
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_c");
            break;
          case OPERATOR_GT:
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
            pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_skip);
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_c");
            break;
          default:
            abort();
        }
        if (value_is_single_bit(dst)) {
          pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        } else {
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 1);
        }
        if (LABEL_NONE != lbl_skip) {
          pic_instr_append_label(pf, lbl_skip);
        }
        label_release(lbl_skip);
      }
      if (VALUE_NONE != val2_sign) {
        pic_var_accum_release(pf, val2_sign);
      }
      if (VALUE_NONE != val1_sign) {
        pic_var_accum_release(pf, val1_sign);
      }
      label_release(lbl_done);
      if ((VALUE_NONE != dst) && !value_is_single_bit(dst)) {
        pic_assign_from_w(pf, dst, BOOLEAN_FALSE);
      }
    }
  }
  return op;
}

static void pic_op_relational(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  pic_relational(pf, op, dst, val1, val2);
}

/* if dst is VALUE_NONE, the caller is responsible for checking _Z
 * _Z is set if val1 && val2 == 0, clear if not
 */
static void pic_op_logical_and(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  UNUSED(op);

  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  /* make sure dst/val1 are the same */
  if (value_is_same(dst, val2)) {
    SWAP(value_t, val1, val2);
  }

  if (value_is_same(val1, val2)) {
    pic_op(pf, OPERATOR_LOGICAL, dst, val1, VALUE_NONE);
  } else if (value_is_const(val1) || value_is_const(val2)) {
    if (value_is_const(val2)) {
      SWAP(value_t, val1, val2);
    }
    /* val1 is const */
    if (value_const_get(val1)) {
      pic_op(pf, OPERATOR_LOGICAL, dst, val2, VALUE_NONE);
    } else {
      pic_assign_logical_to_dst(pf, dst, 0, PIC_ASSIGN_LOGICAL_TO_DST_OP);
    }
  } else if (value_is_single_bit(val1) && value_is_single_bit(val2)) {
    if (pic_val_bank_same(pf, val1, val2) && !value_is_same(dst, val1)) {
      if (!value_is_single_bit(dst)
          || (value_is_single_bit(dst)
            && !value_is_volatile(dst)
            && pic_val_bank_same(pf, dst, val1))) {
        pic_assign_logical_to_dst(pf, dst, 1, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
        pic_assign_logical_to_dst(pf, dst, 0, PIC_ASSIGN_LOGICAL_TO_DST_OP);
      } else {
        label_t lbl_done;
        label_t lbl_clr;

        lbl_done = pfile_label_alloc(pf, 0);
        lbl_clr  = pfile_label_alloc(pf, 0);

        pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
        pic_instr_append_label(pf, lbl_clr);
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        pic_instr_append_label(pf, lbl_done);

        label_release(lbl_clr);
        label_release(lbl_done);
      }
    } else {
      label_t lbl_done;
      label_t lbl_clr;

      lbl_done = pfile_label_alloc(pf, 0);
      lbl_clr  = pfile_label_alloc(pf, 0);

      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
      pic_assign_logical_to_dst(pf, dst, 1, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_label(pf, lbl_clr);
      pic_assign_logical_to_dst(pf, dst, 0, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
      pic_instr_append_label(pf, lbl_done);
      if (!value_is_single_bit(dst)) {
        pic_assign_from_w(pf, dst, BOOLEAN_FALSE);
      }
      label_release(lbl_clr);
      label_release(lbl_done);
    }
  } else if (value_is_single_bit(val1) || value_is_single_bit(val2)) {
    /* do some work */
    if (value_is_single_bit(val2)) {
      SWAP(value_t, val1, val2);
    }
    pic_value_is_zero(pf, val2);
    /* W is 0 or 1 */
    if (value_is_single_bit(dst)
        && (value_is_volatile(dst) 
          || !pic_val_bank_same(pf, dst, val1)
          || value_is_same(dst, val1)
          || value_is_same(dst, val2))) {
      label_t lbl_clr;
      label_t lbl_done;

      lbl_done = pfile_label_alloc(pf, 0);
      lbl_clr  = pfile_label_alloc(pf, 0);
      pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
      pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_label(pf, lbl_clr);
      pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      pic_instr_append_label(pf, lbl_done);
      label_release(lbl_clr);
      label_release(lbl_done);
    } else {
      pic_assign_logical_to_dst(pf, dst, 1, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
      pic_instr_append_daop(pf, val1, PIC_OPCODE_BTFSS, BOOLEAN_FALSE);
      pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
      pic_assign_logical_to_dst(pf, dst, 0, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
      if (!value_is_single_bit(dst)) {
        pic_assign_from_w(pf, dst, BOOLEAN_FALSE);
      }
    }
  } else {
    label_t lbl_done;
    label_t lbl_clr;

    lbl_done = pfile_label_alloc(pf, 0);
    lbl_clr  = pfile_label_alloc(pf, 0);

    pic_value_is_zero(pf, val1);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
    pic_value_is_zero(pf, val2);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
    pic_assign_logical_to_dst(pf, dst, 1, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
    pic_instr_append_label(pf, lbl_clr);
    pic_assign_logical_to_dst(pf, dst, 0, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
    pic_instr_append_label(pf, lbl_done);
    if (!value_is_single_bit(dst)) {
      pic_assign_from_w(pf, dst, BOOLEAN_FALSE);
    }
    label_release(lbl_clr);
    label_release(lbl_done);
  }
}

/* if dst is VALUE_NONE, _Z is set if A || B is true, clear if false */
static void pic_op_logical_or(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  UNUSED(op);

  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  if (value_is_same(val1, val2)) {
    pic_op(pf, OPERATOR_LOGICAL, dst, val1, VALUE_NONE);
  } else if (value_is_const(val1) || value_is_const(val2)) {
    if (value_is_const(val2)) {
      SWAP(value_t, val1, val2);
    }
    /* val1 is const */
    if (value_const_get(val1)) {
      pic_assign_logical_to_dst(pf, dst, 1, PIC_ASSIGN_LOGICAL_TO_DST_OP);
    } else {
      pic_op(pf, OPERATOR_LOGICAL, dst, val2, VALUE_NONE);
    }
  } else if (value_is_single_bit(val1) && value_is_single_bit(val2)) {
    if (pic_val_bank_same(pf, val1, val2)) {
      if (!value_is_single_bit(dst)
          || (value_is_single_bit(dst)
            && !value_is_volatile(dst)
            && !value_is_same(dst, val1)
            && !value_is_same(dst, val2)
            && pic_val_bank_same(pf, dst, val1))) {
        pic_assign_logical_to_dst(pf, dst, 0, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
        pic_assign_logical_to_dst(pf, dst, 1, PIC_ASSIGN_LOGICAL_TO_DST_OP);
      } else {
        label_t lbl_done;
        label_t lbl_set;

        lbl_done = pfile_label_alloc(pf, 0);
        lbl_set  = pfile_label_alloc(pf, 0);

        pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
        pic_instr_append_label(pf, lbl_set);
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        pic_instr_append_label(pf, lbl_done);

        label_release(lbl_set);
        label_release(lbl_done);
      }
    } else {
      label_t lbl_done;
      label_t lbl_set;

      lbl_done = pfile_label_alloc(pf, 0);
      lbl_set  = pfile_label_alloc(pf, 0);

      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
      pic_assign_logical_to_dst(pf, dst, 0, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_label(pf, lbl_set);
      pic_assign_logical_to_dst(pf, dst, 1, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
      pic_instr_append_label(pf, lbl_done);
      if (!value_is_single_bit(dst)) {
        pic_assign_from_w(pf, dst, BOOLEAN_FALSE);
      }
      label_release(lbl_set);
      label_release(lbl_done);
    }
  } else if (value_is_single_bit(val1) || value_is_single_bit(val2)) {
    /* do some work */
    if (value_is_single_bit(val2)) {
      SWAP(value_t, val1, val2);
    }
    pic_value_is_zero(pf, val2);
    /* W is 0 or 1 */
    if (value_is_single_bit(dst)
        && (value_is_volatile(dst) 
          || !pic_val_bank_same(pf, dst, val1)
          || value_is_same(dst, val1)
          || value_is_same(dst, val2))) {
      label_t lbl_set;
      label_t lbl_done;

      lbl_done = pfile_label_alloc(pf, 0);
      lbl_set  = pfile_label_alloc(pf, 0);
      pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
      pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_label(pf, lbl_set);
      pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      pic_instr_append_label(pf, lbl_done);
      label_release(lbl_set);
      label_release(lbl_done);
    } else {
      pic_assign_logical_to_dst(pf, dst, 0, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
      pic_instr_append_daop(pf, val1, PIC_OPCODE_BTFSS, BOOLEAN_FALSE);
      pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
      pic_assign_logical_to_dst(pf, dst, 1, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
      if (!value_is_single_bit(dst)) {
        pic_assign_from_w(pf, dst, BOOLEAN_FALSE);
      }
    }
  } else {
    label_t lbl_done;
    label_t lbl_set;

    lbl_done = pfile_label_alloc(pf, 0);
    lbl_set  = pfile_label_alloc(pf, 0);

    pic_value_is_zero(pf, val1);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
    pic_value_is_zero(pf, val2);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
    pic_assign_logical_to_dst(pf, dst, 0, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
    pic_instr_append_label(pf, lbl_set);
    pic_assign_logical_to_dst(pf, dst, 1, PIC_ASSIGN_LOGICAL_TO_DST_NONE);
    pic_instr_append_label(pf, lbl_done);
    if (!value_is_single_bit(dst)) {
      pic_assign_from_w(pf, dst, BOOLEAN_FALSE);
    }
    label_release(lbl_set);
    label_release(lbl_done);
  }
}

/* perform an AND, OR, or XOR */
static void pic_binary_and_or_xor(pfile_t *pf, operator_t op,
    value_t dst, value_t val1, value_t val2, pic_opcode_t pop)
{
  if (value_is_const(val1) || value_is_const(val2)) {
    variable_const_t cval;

    if (value_is_const(val1)) {
      SWAP(value_t, val1, val2);
    }
    cval = value_const_get(val2);
    if (!cval) {
      if (OPERATOR_ANDB == op) {
        /* anything AND 0 is 0, so set dst to 0 */
        /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
        pic_op(pf, OPERATOR_ASSIGN, dst, VALUE_NONE, VALUE_NONE);
      } else {
        /* anything XOR or OR 0 is unchanged */
        pic_unary_fixup(pf, OPERATOR_ASSIGN, dst, val1, val2);
      }
    } else if ((cval == (variable_const_t) -1) && (OPERATOR_ANDB == op)) {
      /* anything AND all bits is unchanged */
      pic_unary_fixup(pf, OPERATOR_ASSIGN, dst, val1, val2);
    } else if (value_is_same(dst, val1)
      && (((OPERATOR_ANDB == op) && ((~cval & (~cval - 1)) == 0))
        || ((OPERATOR_ANDB != op) && ((cval & (cval - 1)) == 0)))) {
      /* single bit set, clear, or flip */
      unsigned bit;

      if (OPERATOR_ANDB == op) {
        cval = ~cval;
      }

      for (bit = -1; cval; cval >>= 1, bit++)
        ;
      if (value_is_bit(dst)) {
        if (bit < value_sz_get(dst)) {
          bit += value_bit_offset_get(dst);
        } else {
          dst = VALUE_NONE;
        }
      } else if (bit >= 8U * value_sz_get(dst)) {
        dst = VALUE_NONE;
      }
      if (VALUE_NONE != dst) {
        variable_sz_t ipos;

        pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE,
            bit / 8, &ipos);
        if (OPERATOR_ANDB == op) {
          pic_instr_append_f_bn(pf, PIC_OPCODE_BCF, dst, bit / 8, bit & 7);
        } else if (OPERATOR_ORB == op) {
          pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, dst, bit / 8, bit & 7);
        } else if (OPERATOR_XORB == op) {
          if (value_is_volatile(dst) || value_is_same(dst, val1)) {
            label_t lbl_done;
            label_t lbl_set;

            lbl_done = pfile_label_alloc(pf, 0);
            lbl_set  = pfile_label_alloc(pf, 0);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, val1, bit / 8, bit & 7);
            pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BCF, dst, bit / 8, bit & 7);
            pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
            pic_instr_append_label(pf, lbl_set);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, dst, bit / 8, bit & 7);
            pic_instr_append_label(pf, lbl_done);
            label_release(lbl_set);
            label_release(lbl_done);
          } else {
            pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, dst, bit / 8, bit & 7);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BCF,   dst, bit / 8, bit & 7);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, dst, bit / 8, bit & 7);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BSF,   dst, bit / 8, bit & 7);
          }
        }
      }
    } else if (!pic_work_in_temp(pf, op, dst, val1, val2,
          PIC_WORK_IN_TEMP_FLAG_VALS_DST)) {
      /* dst = val1 op c */
      variable_sz_t sz;
      variable_sz_t ii;
      variable_sz_t ipos;
      value_t       sign;     /* for sign extension */
      variable_sz_t val1_ofs; /* index into val1    */
      uchar         ch_last;

      sign    = VALUE_NONE;
      ch_last = 0; /* prevent a compiler warning */

      sz = pic_result_sz_get(val1, val2, dst);
      pic_indirect_setup3(pf, dst, val1, VALUE_NONE, 0, &ipos);
      for (ii = 0, val1_ofs = 0; ii < sz; ii++) {
        uchar ch;

        if (ii) {
          pic_indirect_bump3(pf, dst, val1, val2, ii, &ipos);
          if (!sign && (++val1_ofs == value_sz_get(val1))) {
            sign     = pic_value_sign_get(pf, val1, VALUE_NONE);
            val1     = sign;
            val1_ofs = 0;
          }
          cval >>= 8;
        }
        ch = cval & 0xff;
        /* 0 && x --> 0; just clear dst */
        if (((0 == ch) || (VALUE_NONE == val1)) && (OPERATOR_ANDB == op)) {
          pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
        } else {
          pic_opcode_t opcode;

          if (((0xff == ch) && (OPERATOR_ANDB == op))
            || (((0x00 == ch) || (VALUE_NONE == val1))
              && ((OPERATOR_ORB == op) || (OPERATOR_XORB == op)))) {
            /* no action: x & 0xff == x */
            /*            x | 0x00 == x */
            /*            x ^ 0x00 == x */
            opcode = PIC_OPCODE_MOVF;
            if ((VALUE_NONE == val1) && ch) {
              pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, ch);
            }
          } else {
            /* if val1 & dst are different, W was destroyed */
            if (!value_is_same(dst, val1) || (ch != ch_last) || (0 == ii)) {
              pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, ch);
              ch_last = ch;
            }
            opcode = pop;
          }
          if (value_is_same(dst, val1)) {
            if (opcode != PIC_OPCODE_MOVF) {
              pic_instr_append_f_d(pf, opcode, val1, val1_ofs, PIC_OPDST_F);
            }
          } else {
            if (val1 != VALUE_NONE) {
              pic_instr_append_f_d(pf, opcode, val1, val1_ofs, PIC_OPDST_W);
            }
            if ((VALUE_NONE == val1) && !ch) {
              pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
            } else {
              pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
            }
          }
        }
      }
      pic_value_sign_extend(pf, dst, ii - 1,
          pic_result_is_signed(pf, val1, val2));
      if (sign) {
        pic_var_accum_release(pf, sign);
      }
    }
  } else if (!pic_work_in_temp(pf, op, dst, val1, val2,
        PIC_WORK_IN_TEMP_FLAG_VALS_DST)) {
    value_t       val1_sign;
    value_t       val2_sign;
    variable_sz_t sz;
    variable_sz_t ii;
    variable_sz_t ipos;
    variable_sz_t val1_ofs;
    variable_sz_t val2_ofs;
    pic_opdst_t   opdst;

    /* if dst is the same as an argument, make sure that argument is first */
    if (value_is_same(dst, val2)) {
      SWAP(value_t, val1, val2);
    }

    opdst = (value_is_same(dst, val1))
      ? PIC_OPDST_F
      : PIC_OPDST_W;

    val1_sign = VALUE_NONE;
    val2_sign = VALUE_NONE;
    sz = pic_result_sz_get(val1, val2, dst);
    pic_indirect_setup3(pf, val1, val2, dst, 0, &ipos);
    for (ii = 0, val1_ofs = 0, val2_ofs = 0; ii < sz; ii++) {
      if (ii) {
        if ((VALUE_NONE == val1_sign) && (++val1_ofs == value_sz_get(val1))) {
          val1_sign = pic_value_sign_get(pf, val1, VALUE_NONE);
          val1      = val1_sign;
          val1_ofs  = 0;
        }
        if ((VALUE_NONE == val2_sign) && (++val2_ofs == value_sz_get(val2))) {
          val2_sign = pic_value_sign_get(pf, val2, VALUE_NONE);
          val2      = val2_sign;
          val2_ofs  = 0;
        }
        pic_indirect_bump3(pf, dst, val1, val2, ii, &ipos);
      }
      /* if we've run out of val1 or val2 and it's not sign extended
       * it will always be `and 0' which is effectively clear dst
       */
      if ((VALUE_NONE == val1) || (VALUE_NONE == val2)) {
        if (OPERATOR_ANDB == op) {
          pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
        } else if (PIC_OPDST_W == opdst) {
          if (VALUE_NONE == val1) {
            pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val2, val2_ofs, opdst);
          } else {
            pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val1, val1_ofs, opdst);
          }
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
        }
      } else {
        pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val2, val2_ofs, PIC_OPDST_W);
        pic_instr_append_f_d(pf, pop, val1, val1_ofs, opdst);
        if (PIC_OPDST_W == opdst) {
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
        }
      }
    }
    if (VALUE_NONE != val1_sign) {
      pic_var_accum_release(pf, val1_sign);
    }
    if (VALUE_NONE != val2_sign) {
      pic_var_accum_release(pf, val2_sign);
    }
    pic_value_sign_extend(pf, dst, ii - 1, 
        pic_result_is_signed(pf, val1, val2));
  }
}

static void pic_op_binary_and(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  if (value_is_same(val1, val2)) {
    pic_op(pf, OPERATOR_ASSIGN, dst, val1, VALUE_NONE);
  } else if (!value_is_const(val1)
      && !value_is_const(val2)
      && value_is_single_bit(val1) 
      && value_is_single_bit(val2)) {
    /* the quick case only works if:
     *   val1 & val2 are in the same bank
     *   dst is not bit
     *     or dst is not volatile & dst is in the same bank as val1
     */
    label_t lbl_clr;
    label_t lbl_done;
    uchar   true_value;

    true_value = 1;
    if (pic_result_is_signed(pf, val1, val2)) {
      true_value = 255;
    }

    if (value_is_same(dst, val2)) {
      SWAP(value_t, val1, val2);
    }

    lbl_done = pfile_label_alloc(pf, 0);
    lbl_clr  = pfile_label_alloc(pf, 0);
    if (pic_val_bank_same(pf, val1, val2)) {
      if (!value_is_same(dst, val1)
          && (!value_is_single_bit(dst)
            || (!value_is_volatile(dst) 
              && pic_val_bank_same(pf, dst, val1)
              && pic_val_bank_same(pf, dst, val2)))) {
        /* 4 instructions (+ assignment if dst is not a bit) */
        if (value_is_single_bit(dst)) {
          pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        } else {
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, true_value);
        }
        if (value_is_shared(val1)) {
          pic_instr_append_daop(pf, val2, PIC_OPCODE_NONE, BOOLEAN_FALSE);
        }
        pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
        if (value_is_single_bit(dst)) {
          pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        } else {
          /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
        }
      } else if (!value_is_same(dst, val1)
          && !value_is_volatile(dst) 
          && !pic_val_bank_same(pf, dst, val1)) {
        /* 5 instructions */
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        if (value_is_shared(val2)) {
          pic_instr_append_daop(pf, val2, PIC_OPCODE_NONE, BOOLEAN_FALSE);
        }
        pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      } else if (value_is_same(dst, val1)) {
        /* dst = dst & val2, both are single bit; only relies
         * on val2! */
        pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      } else {
        /* 6 instructions */
        if (value_is_shared(val1)) {
          pic_instr_append_daop(pf, val2, PIC_OPCODE_NONE, BOOLEAN_FALSE);
        }
        pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
        pic_instr_append_label(pf, lbl_clr);
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      }
    } else if (!value_is_same(dst, val1)
        && (!value_is_single_bit(dst) || !value_is_volatile(dst))) {
      /* 6 instructions */
      if (value_is_single_bit(dst)) {
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      } else {
        /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
      }
      if (value_is_shared(val1)) {
        pic_instr_append_daop(pf, val2, PIC_OPCODE_NONE, BOOLEAN_FALSE);
      }
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      if (value_is_single_bit(dst)) {
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      } else {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, true_value);
      }
    } else {
      /* 7 instructions */
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
      pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_label(pf, lbl_clr);
      pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
    }
    pic_instr_append_label(pf, lbl_done);
    if (!value_is_single_bit(dst)) {
      pic_assign_from_w(pf, dst, 255 == true_value);
    }
    label_release(lbl_clr);
    label_release(lbl_done);
  } else {
    pic_binary_and_or_xor(pf, op, dst, val1, val2, PIC_OPCODE_ANDWF);
  } 
}

static void pic_op_binary_or(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  if (value_is_same(val1, val2)) {
    pic_op(pf, OPERATOR_ASSIGN, dst, val1, VALUE_NONE);
  } else if (!value_is_const(val1)
    && !value_is_const(val2)
    && value_is_single_bit(val1) 
    && value_is_single_bit(val2)
    && !(value_is_signed(val1) ^ value_is_signed(val2))) {
    label_t lbl_done;
    label_t lbl_set;
    uchar   true_value;

    true_value = 1;

    if (value_is_signed(val1) || value_is_signed(val2)) {
      true_value = 255;
    }

    lbl_done = pfile_label_alloc(pf, 0);
    lbl_set  = pfile_label_alloc(pf, 0);

    /* make sure (dst, val1) are same if any */
    if (value_is_same(dst, val2)) {
      SWAP(value_t, val1, val2);
    }
    if (pic_val_bank_same(pf, val1, val2)) {
      if (!value_is_same(dst, val1)
        && (!value_is_single_bit(dst)
            || (!value_is_volatile(dst) 
              && pic_val_bank_same(pf, dst, val1)
              && pic_val_bank_same(pf, dst, val2)))) {
        /* 4 instructions (+ assignment if dst is not a bit) */
        if (value_is_single_bit(dst)) {
          pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        } else {
          /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
        }
        if (value_is_shared(val1)) {
          pic_instr_append_daop(pf, val2, PIC_OPCODE_NONE, BOOLEAN_FALSE);
        }
        pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
        if (value_is_single_bit(dst)) {
          pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        } else {
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, true_value);
        }
      } else if (!value_is_same(dst, val1)
        && !value_is_volatile(dst) 
        && !pic_val_bank_same(pf, dst, val1)) {
        /* 5 instructions */
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        if (value_is_shared(val1)) {
          pic_instr_append_daop(pf, val2, PIC_OPCODE_NONE, BOOLEAN_FALSE);
        }
        pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      } else if (value_is_same(dst, val1)) {
        pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      } else {
        /* 6 instructions */
        if (value_is_shared(val1)) {
          pic_instr_append_daop(pf, val2, PIC_OPCODE_NONE, BOOLEAN_FALSE);
        }
        pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val1, 0);
        pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
        pic_instr_append_label(pf, lbl_set);
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      }
    } else if (!value_is_same(dst, val1)
      && (!value_is_single_bit(dst) || !value_is_volatile(dst))) {
      /* 6 instructions */
      if (value_is_single_bit(dst)) {
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      } else {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, true_value);
      }
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      if (value_is_single_bit(dst)) {
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      } else {
        /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
      }
    } else {
      /* 7 instructions */
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
      pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_label(pf, lbl_set);
      pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
    }
    pic_instr_append_label(pf, lbl_done);
    if (!value_is_single_bit(dst)) {
      pic_assign_from_w(pf, dst, 255 == true_value);
    }
    label_release(lbl_set);
    label_release(lbl_done);
  } else {
    pic_binary_and_or_xor(pf, op, dst, val1, val2, PIC_OPCODE_IORWF);
  }
}

static void pic_op_binary_xor(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  if (value_is_same(val1, val2)) {
    /* a ^ a = 0 */
    variable_sz_t ii;
    variable_sz_t ipos;

    pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
    for (ii = 0; ii < value_sz_get(dst); ii++) {
      pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
      pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
    }
  } else if (!value_is_const(val1)
      && !value_is_const(val2)
      && value_is_single_bit(val1) 
      && value_is_single_bit(val2)
      && !(value_is_signed(val1) ^ value_is_signed(val2))) {
    label_t lbl_done;
    label_t lbl_skip;
    label_t lbl_set;
    label_t lbl_clr;
    uchar   true_value; /* value for TRUE */

    true_value = 1;
    if (value_is_signed(val1) || value_is_signed(val2)) {
      true_value = 255;
    }

    lbl_done = pfile_label_alloc(pf, 0);
    lbl_skip = pfile_label_alloc(pf, 0);
    lbl_set  = pfile_label_alloc(pf, 0);
    lbl_clr  = pfile_label_alloc(pf, 0);

    if (value_is_same(dst, val2)) {
      SWAP(value_t, val1, val2);
    }

    if (!value_is_single_bit(dst)
        || (!value_is_volatile(dst)
          && !value_is_same(dst, val1)
          && pic_val_bank_same(pf, dst, val2))) {
      if (value_is_single_bit(dst)) {
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      } else {
        /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
      }
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_skip);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
      if (value_is_single_bit(dst)) {
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      } else {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, true_value);
      }
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_label(pf, lbl_skip);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
      if (value_is_single_bit(dst)) {
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      } else {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, true_value);
      }
    } else {
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val1, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_skip);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, val2, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
      pic_instr_append_label(pf, lbl_skip);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, val2, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
      pic_instr_append_label(pf, lbl_clr);
      pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_label(pf, lbl_set);
      pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
    }
    pic_instr_append_label(pf, lbl_done);
    if (!value_is_single_bit(dst)) {
      pic_assign_from_w(pf, dst, 255 == true_value);
    }
    label_release(lbl_clr);
    label_release(lbl_set);
    label_release(lbl_skip);
    label_release(lbl_done);
  } else {
    pic_binary_and_or_xor(pf, op, dst, val1, val2, PIC_OPCODE_XORWF);
  }
}

static void pic_op_cmp(pfile_t *pf, operator_t op, value_t dst,
  value_t src, value_t val2)
{
  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(src));

  if (value_is_single_bit(dst) && value_is_single_bit(src)) {
    if (value_is_boolean(dst) 
        && !value_is_signed(src)
        && !value_is_boolean(src)) {
      /* if src is 0, dst is clearly 1; if src is 1,
       * the inverse is -2 */
      pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
    } else if (value_is_volatile(src)
        || value_is_same(dst, src)
        || !pic_val_bank_same(pf, dst, src)) {
      label_t lbl_done;
      label_t lbl_set;

      lbl_done = pfile_label_alloc(pf, 0);
      lbl_set  = pfile_label_alloc(pf, 0);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, src, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
      pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
      pic_instr_append_label(pf, lbl_set);
      pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      pic_instr_append_label(pf, lbl_done);
      label_release(lbl_set);
      label_release(lbl_done);
    } else {
      pic_instr_append_f(pf, PIC_OPCODE_BTFSC, src, 0);
      pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      pic_instr_append_f(pf, PIC_OPCODE_BTFSS, src, 0);
      pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
    }
  } else if (!pic_work_in_temp(pf, op, dst, src, val2,
        PIC_WORK_IN_TEMP_FLAG_VAL1
        | PIC_WORK_IN_TEMP_FLAG_DST)) {
    variable_sz_t sz;
    variable_sz_t sz_hi;
    variable_sz_t ii;
    variable_sz_t ipos;
    pic_opdst_t   opdst;

    sz    = pic_result_sz_get(src, val2, dst);
    sz_hi = value_sz_get(src);
    if (sz < sz_hi) {
      sz_hi = sz;
    }
    pic_indirect_setup3(pf, dst, src, val2, 0, &ipos);
    opdst = (value_is_same(dst, src))
      ? PIC_OPDST_F
      : PIC_OPDST_W;
    for (ii = 0; ii < sz_hi; ii++) {
      pic_indirect_bump3(pf, dst, src, val2, ii, &ipos);
      pic_instr_append_f_d(pf, PIC_OPCODE_COMF, src, ii, opdst);
      if (PIC_OPDST_W == opdst) {
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
      }
    }
    if (ii < sz) {
      src = pic_value_sign_get(pf, src, VALUE_NONE);
      if (VALUE_NONE == src) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0xff);
      } else {
        pic_instr_append_f_d(pf, PIC_OPCODE_COMF, src, 0, PIC_OPDST_W);
      }
      while (ii < sz) {
        pic_indirect_bump3(pf, dst, src, val2, ii, &ipos);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
        ii++;
      }
      if (VALUE_NONE != src) {
        pic_var_accum_release(pf, src);
      }
    }
    pic_value_sign_extend(pf, dst, ii - 1, 
        pic_result_is_signed(pf, src, val2));
  }
}

static void pic_op_neg(pfile_t *pf, operator_t op, value_t dst,
  value_t src, value_t val2)
{
  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(src));

  if (value_is_float(src)) {
    pic_var_float_t flt;

    pic_var_float_get(pf, &flt);
    if (!value_is_same(dst, src)) {
      if (value_is_float(dst)) {
        pic_op(pf, OPERATOR_ASSIGN, dst, src, VALUE_NONE);
        src = dst;
      } else {
        pic_op(pf, OPERATOR_ASSIGN, flt.fval1, src, VALUE_NONE);
        src = flt.fval1;
      }
    }
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, src, 3, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x80);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BCF, src, 3, 7);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, src, 3, 7);
    if (!value_is_same(dst, src)) {
      pic_op(pf, OPERATOR_ASSIGN, dst, src, VALUE_NONE);
    }
    pic_var_float_release(pf, &flt);
  } else if (!pic_work_in_temp(pf, op, dst, src, val2,
        PIC_WORK_IN_TEMP_FLAG_VAL1
        | PIC_WORK_IN_TEMP_FLAG_DST)) {
    variable_sz_t sz;

    sz = pic_result_sz_get(src, val2, dst);
    if ((1 == sz) 
      && !pic_is_12bit(pf)  
      && (value_is_volatile(dst) || !value_is_same(dst, src))) {
      variable_sz_t ipos;

      pic_indirect_setup3(pf, dst, src, val2, 0, &ipos);
      pic_instr_append_f_d(pf, PIC_OPCODE_COMF, src, 0, PIC_OPDST_W);
      pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, 1);
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
      
      pic_value_sign_extend(pf, dst, 0, 
          pic_result_is_signed(pf, src, val2));
    } else if (value_is_volatile(dst)) {
        value_t tmp;

        tmp = pic_var_temp_get(pf, pic_result_flag_get(pf, src, val2),
            pic_result_sz_get(src, val2, dst));
        pic_op(pf, OPERATOR_CMPB, tmp, src, val2);
        pic_op(pf, OPERATOR_INCR, dst, tmp, VALUE_NONE);
        pic_var_temp_release(pf, tmp);
    } else if (value_sz_get(dst) > sz) {
      value_t        tmp;
      variable_def_t def;

      tmp = value_clone(dst);
      def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
          value_dflag_test(src, VARIABLE_DEF_FLAG_SIGNED)
            ? VARIABLE_DEF_FLAG_SIGNED
            : VARIABLE_DEF_FLAG_NONE,
          sz);
      value_def_set(tmp, def);
      pic_op(pf, OPERATOR_CMPB, tmp, src, val2);
      pic_op(pf, OPERATOR_INCR, tmp, tmp, VALUE_NONE);
      pic_value_sign_extend(pf, dst, sz - 1, 
          pic_result_is_signed(pf, src, val2));
      value_release(tmp);
    } else {
      pic_op(pf, OPERATOR_CMPB, dst, src, val2);
      pic_op(pf, OPERATOR_INCR, dst, dst, VALUE_NONE);
    }
  }
}

static void pic_op_incr(pfile_t *pf, operator_t op, value_t dst,
  value_t src, value_t val2)
{
  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(src));

  if (!pic_work_in_temp(pf, op, dst, src, val2,
    PIC_WORK_IN_TEMP_FLAG_VAL1
    | PIC_WORK_IN_TEMP_FLAG_DST)) {
    variable_sz_t sz;
    variable_sz_t ii;

    ii = 0;
    sz = pic_result_sz_get(src, val2, dst);
    if (1 == sz) {
      /* trivial case */
      pic_opdst_t   opdst;
      variable_sz_t ipos;

      opdst = (value_is_same(src, dst)) ? PIC_OPDST_F : PIC_OPDST_W;

      ii = 1; /* for sign extend */
      pic_indirect_setup3(pf, src, val2, dst, 0, &ipos);
      pic_instr_append_f_d(pf, PIC_OPCODE_INCF, src, 0, opdst);
      if (PIC_OPDST_W == opdst) {
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
      }
    } else if (value_is_same(src, dst) && !value_is_indirect(src)) {
      for (ii = 0; ii < sz; ii++) {
        if (ii) {
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
        }
        pic_instr_append_f_d(pf, PIC_OPCODE_INCF, dst, ii, PIC_OPDST_F);
      }
    } else {
      variable_sz_t ipos;
      pic_opdst_t   opdst;
      value_t       src_sign;

      opdst = (value_is_same(dst, src)) ? PIC_OPDST_F : PIC_OPDST_W;
      pic_indirect_setup3(pf, dst, src, VALUE_NONE, 0, &ipos);
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 1);
      src_sign = VALUE_NONE;
      for (ii = 0; ii < sz; ii++) {
        pic_indirect_bump3(pf, dst, src, val2, ii, &ipos);
        if (ii) {
          if (ii == value_sz_get(src)) {
            src_sign = pic_value_sign_get(pf, src, VALUE_NONE);
            src      = src_sign;
            if (VALUE_NONE == src) {
              opdst = PIC_OPDST_W;
            }
          }
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 1);
        }
        if (VALUE_NONE == src) {
          if (ii + 1 < sz) {
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
          }
        } else {
          pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, src, 
            (src == src_sign) ? 0 : ii, opdst);
        }
        if (PIC_OPDST_W == opdst) {
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
        }
      }
      if (VALUE_NONE != src_sign) {
        pic_var_accum_release(pf, src_sign);
      }
    }
    pic_value_sign_extend(pf, dst, ii - 1,
      pic_result_is_signed(pf, src, val2));
  }
}

static void pic_op_decr(pfile_t *pf, operator_t op, value_t dst,
  value_t src, value_t val2)
{
  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(src));

  if (!pic_work_in_temp(pf, op, dst, src, val2,
    PIC_WORK_IN_TEMP_FLAG_VAL1
    | PIC_WORK_IN_TEMP_FLAG_DST)) {
    variable_sz_t sz;
    variable_sz_t ii;

    sz = pic_result_sz_get(src, val2, dst);
    if (1 == sz) {
      /* trivial case */
      pic_opdst_t   opdst;
      variable_sz_t ipos;

      opdst = (value_is_same(src, dst)) ? PIC_OPDST_F : PIC_OPDST_W;

      ii = 1;
      pic_indirect_setup3(pf, src, VALUE_NONE, dst, 0, &ipos);
      pic_instr_append_f_d(pf, PIC_OPCODE_DECF, src, 0, opdst);
      if (PIC_OPDST_W == opdst) {
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
      }
    } else {
      /* the work must be done in dst, 
       * so first copy src(n..1) --> dst(n..1) */
      variable_sz_t ipos;

      if (!value_is_same(dst, src)) {
        pic_indirect_setup3(pf, dst, src, VALUE_NONE, sz - 1, &ipos);
        for (ii = sz; ii > 1; ii--) {
          if (ii > value_sz_get(src)) {
            if (value_is_signed(src)) {
              if (ii == sz) {
                pic_value_sign_get_in_w(pf, src);
              }
              pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii - 1);
            } else {
              pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii - 1);
            }
          } else {
            pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, src, ii - 1, 
              PIC_OPDST_W);
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii - 1);
          }
          pic_indirect_bump3(pf, dst, src, VALUE_NONE, ii - 2, &ipos);
        }
        if (value_is_indirect(dst) || (sz > 2)) {
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 1);
          pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, src, 0, PIC_OPDST_W);
        } else {
          pic_instr_append_f_d(pf, PIC_OPCODE_DECF, src, 0, PIC_OPDST_W);
        }
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
        if (value_is_indirect(dst) || (sz > 2)) {
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 1);
        }
      } else {
        pic_indirect_setup3(pf, dst, src, VALUE_NONE, 0, &ipos);
        if (value_is_indirect(dst) || (sz > 2)) {
          pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 1);
          pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, dst, 0, PIC_OPDST_F);
        } else {
          pic_instr_append_f_d(pf, PIC_OPCODE_DECF, dst, 0, PIC_OPDST_F);
        }
      }
      if ((2 == sz) && !value_is_indirect(dst)) {
        pic_instr_append_f_d(pf, PIC_OPCODE_INCF, dst, 0, PIC_OPDST_W);
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
        pic_instr_append_f_d(pf, PIC_OPCODE_DECF, dst, 1, PIC_OPDST_F);
        ii = sz;
      } else {
        for (ii = 1; ii < sz; ii++) {
          pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
          pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_c");
          pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, dst, ii, PIC_OPDST_F);
        }
      }
    }
    pic_value_sign_extend(pf, dst, ii - 1,
      pic_result_is_signed(pf, src, val2));
  }
}

/* assign src to dst, shifting left one bit in the process */
static void pic_assign_shift_left_1_bit(pfile_t *pf, value_t dst, value_t src,
    variable_sz_t sz, unsigned flags)
{
  variable_sz_t ii;
  variable_sz_t ipos;
  pic_opdst_t   opdst;
  value_t       sign;

  assert(VALUE_NONE != dst);
  assert(VALUE_NONE != src);
  assert(!value_is_lookup(src)
    && !value_is_bit(src));
  assert(!value_is_bit(dst));
  assert(!(value_is_indirect(dst) && value_is_indirect(src))
    || value_is_same(dst, src));

  sign  = VALUE_NONE;
  opdst = (value_is_same(dst, src)) ? PIC_OPDST_F : PIC_OPDST_W;
  pic_indirect_setup3(pf, dst, src, VALUE_NONE, 0, &ipos);
  if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
  }
  for (ii = 0; ii < sz; ii++) {
    if (ii == value_sz_get(src)) {
      sign = pic_value_sign_get(pf, src, VALUE_NONE);
      if (VALUE_NONE == sign) {
        /* cannot use clrf as that clears the "C" flag */
        sign = pic_var_accum_get(pf);
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, sign, 0);
      }
      src  = sign;
    }
    pic_indirect_bump3(pf, dst, src, VALUE_NONE, ii, &ipos);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, src, 
        (VALUE_NONE == sign) ? ii : 0, opdst);
    if (PIC_OPDST_W == opdst) {
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
    }
  }
  if (VALUE_NONE != sign) {
    pic_var_accum_release(pf, sign);
  }
}

static void pic_assign_shift_left_4_bits(pfile_t *pf, value_t dst,
  value_t src, unsigned flags)
{
  variable_sz_t    ipos;

  pic_indirect_setup3(pf, dst, src, VALUE_NONE, 0, &ipos);
  pic_instr_append_f_d(pf, PIC_OPCODE_SWAPF, src, 0, PIC_OPDST_W);
  if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xf0);
  }
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
}

/* assign src to dst, shifting left (n) bytes in the process */
typedef enum {
  PIC_ASSIGN_SHIFT_N_BYTES_ACTION_COPY,
  PIC_ASSIGN_SHIFT_N_BYTES_ACTION_SWAP
} pic_assign_shift_n_bytes_action_t;

/*
 * pf         : pfile handle
 * dst        : destination value
 * src        : source vlaue
 * sz         : result size (will be <= value_size_get(dst))
 * byte_shift : number of bytes to shift
 * action     : *_COPY : all shifted bytes are copied
 *              *_SWAP : the MSB has the nibbles swapped and the
 *                       lower four bits cleared
 * mask       : the the MSB is ANDed with this before stored
 */
static void pic_assign_shift_left_n_bytes(pfile_t *pf, value_t dst, 
  value_t src, variable_sz_t sz, variable_sz_t byte_shift,
  pic_assign_shift_n_bytes_action_t action,
  unsigned mask, unsigned flags)
{
  /* if dst & src are equal and indirect, we need to have one of them
     moved to a temporary */
  if (!pic_work_in_temp(pf, OPERATOR_SHIFT_LEFT, dst, src, VALUE_NONE,
      PIC_WORK_IN_TEMP_FLAG_DST_VAL_EQUAL)) {
    /* we need to work *backward* in case src & dst are the same! */
    /* start by positioning src to byte_ofs */
    variable_sz_t ipos;
    variable_sz_t ii;
    value_t       accum;

    assert(sz > byte_shift);

    pic_indirect_setup3(pf, src, VALUE_NONE, VALUE_NONE,
      sz - byte_shift - 1, &ipos);
    if (sz - byte_shift > value_sz_get(src)) {
      accum = pic_value_sign_get(pf, src, VALUE_NONE);
    } else {
      accum = src;
    }
    if (value_is_indirect(dst)) {
      pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE,
        sz - 1, &ipos);
    }
    ii = sz;
    while (ii--) {
      if (value_is_indirect(dst)) {
        pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
      } 
      if (ii >= byte_shift) {
        if ((accum != src) && (ii - byte_shift < value_sz_get(src))) {
          if (VALUE_NONE != accum) {
            pic_var_accum_release(pf, accum);
          }
          accum = src;
        }
        if (VALUE_NONE == accum) {
          pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
        } else {
          if ((ii == sz - 1) 
            && (PIC_ASSIGN_SHIFT_N_BYTES_ACTION_SWAP == action)) {
            pic_instr_append_f_d(pf, 
              PIC_OPCODE_SWAPF, 
              accum, 
              (accum == src) ? ii - byte_shift : 0,
              PIC_OPDST_W);
            if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
              pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xf0);
            }
          } else {
            pic_instr_append_f_d(pf, 
              PIC_OPCODE_MOVF, 
              accum, 
              (accum == src) ? ii - byte_shift : 0,
              PIC_OPDST_W);
          }
          if ((ii == sz - 1) && (255 != mask)) {
            if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
              pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, mask);
            }
          }
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
        }
      } else {
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
      }
      if (ii && value_is_indirect(accum) && ipos) {
        value_t fsr;

        fsr = pic_fsr_get(pf);
        pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
        value_release(fsr);
        ipos--;
      }
    }
    assert(accum == src);
    if (value_is_indirect(dst) && (sz < value_sz_get(dst))) {
      value_t fsr;

      fsr = pic_fsr_get(pf);
      if (2 == sz) {
        pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, PIC_OPDST_F);
      } else {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, sz - 1);
        pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, fsr, 0, PIC_OPDST_F);
      }
      value_release(fsr);
    }
  }
}

static void pic_shift_left(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2, unsigned flags)
{
  variable_sz_t sz;

  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  sz = pic_result_sz_get(val1, val2, dst);

  if (value_is_const(val2)) {
    variable_const_t cn;

    cn = value_const_get(val2);
    if (0 == cn) {
      /* this is a simple assignment */
      pic_unary_fixup(pf, OPERATOR_ASSIGN, dst, val1, val2);
    } else if (cn >= 8U * sz) {
      pic_assign_const(pf, dst, val1, val2, 0);
    } else if (!pic_work_in_temp(pf, op, dst, val1, val2, 
      PIC_WORK_IN_TEMP_FLAG_VALS
      | PIC_WORK_IN_TEMP_FLAG_DST)) {
      variable_const_t byte_shift;
      variable_const_t bit_shift;
      value_t          fsr;

      byte_shift = cn / 8;
      bit_shift  = cn & 7;
      fsr        = pic_fsr_get(pf);

      if (byte_shift && !bit_shift) {
        pic_assign_shift_left_n_bytes(pf, dst, val1, sz, byte_shift,
          PIC_ASSIGN_SHIFT_N_BYTES_ACTION_COPY, 0xff, flags);
        pic_value_sign_extend(pf, dst, sz - 1,
            pic_result_is_signed(pf, val1, val2));
      } else if (!byte_shift && (1 == bit_shift)) {
        /* this can be done in one pass */
        pic_assign_shift_left_1_bit(pf, dst, val1, sz, flags);
        pic_value_sign_extend(pf, dst, sz - 1,
            pic_result_is_signed(pf, val1, val2));
      } else if ((4 == cn) && (1 == sz)) {
        /* this can be done in one pass */
        pic_assign_shift_left_4_bits(pf, dst, val1, flags);
        pic_value_sign_extend(pf, dst, sz - 1,
            pic_result_is_signed(pf, val1, val2));
      } else if (!pic_work_in_temp(pf, op, dst, val1, val2,
        PIC_WORK_IN_TEMP_FLAG_DST_VOLATILE)) {
        /* shift bytes and/or bits */
        if ((5 == cn) && (1 == sz)) {
          pic_assign_shift_left_4_bits(pf, dst, val1, flags);
          if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
          }
          pic_instr_append_f_d(pf, PIC_OPCODE_RLF, dst, 0, PIC_OPDST_F);
        } else if (8U * sz - 2 == cn) {
          variable_sz_t ipos;
          pic_opdst_t   opdst;

          if (value_is_indirect(dst)) {
            pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, sz - 1, 
              &ipos);
          } else if (value_is_indirect(val1)) {
            pic_indirect_setup3(pf, val1, VALUE_NONE, VALUE_NONE, 0, 
              &ipos);
          }
          opdst = (value_is_same(dst, val1)) ? PIC_OPDST_F : PIC_OPDST_W;
          pic_instr_append_f_d(pf, PIC_OPCODE_RRF, val1, 0, opdst);
          if (PIC_OPDST_W == opdst) {
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, sz - 1);
          }
          pic_instr_append_f_d(pf, PIC_OPCODE_RRF, dst, sz - 1, PIC_OPDST_F);
          pic_instr_append_f_d(pf, PIC_OPCODE_RRF, dst, sz - 1, PIC_OPDST_W);
          if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
            pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xc0);
          }
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, sz - 1);
          for (ipos = sz - 1; ipos; ipos--) {
            if (value_is_indirect(dst)) {
              pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
            }
            pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ipos - 1);
          }
          if ((sz > 1) && (value_sz_get(dst) > sz) && value_is_indirect(dst)) {
            /* we'll be sign extending, so move fsr to the end of dst */
            if (sz < 2) {
              pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, PIC_OPDST_F);
            } else {
              pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, sz - 1);
              pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, fsr, 0, PIC_OPDST_F);
            }
          }
        } else if (8U * sz - 1 == cn) {
          variable_sz_t ipos;
          variable_sz_t ii;

          pic_indirect_setup3(pf, dst, val1, VALUE_NONE, 0, &ipos);
          if (value_is_same(dst, val1) || !pic_val_bank_same(pf, dst, val1)) {
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, val1, 0, 0);
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0x80);
          }
          for (ii = 0; ii < sz - 1; ii++) {
            pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
            pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii + 1, &ipos);
          }
          if (value_is_same(dst, val1) || !pic_val_bank_same(pf, dst, val1)) {
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
          } else {
            pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, val1, 0, 0);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, dst, ii, 7);
          }
        } else {
          boolean_t always_clear_c;
          unsigned  loop_cost;
          unsigned  unrolled_cost;
          unsigned  bit_shift_real;

          if (cn == 8U * sz - 4) {
            bit_shift_real = 0;
          } else if (cn == 8U * sz - 3) {
            bit_shift_real = 1;
          } else {
            bit_shift_real = bit_shift;
          }

          loop_cost     = 5 + (sz - byte_shift);
          
          unrolled_cost = 1 + ((sz - byte_shift) * bit_shift_real);

          always_clear_c = BOOLEAN_TRUE;
          if (byte_shift) {
            unsigned mask;

            mask = 0xff;
            if (unrolled_cost < loop_cost) {
              if ((cn & 7) == 2) {
                mask = 0x7f;
                always_clear_c = BOOLEAN_FALSE;
              } else if ((cn & 7) == 3) {
                mask = 0x3f;
                always_clear_c = BOOLEAN_FALSE;
              }
            }
            if (always_clear_c) {
              unrolled_cost = (1 + (sz - byte_shift)) * bit_shift_real;
            } else {
              unrolled_cost++;
            }
            pic_assign_shift_left_n_bytes(pf, dst, val1, sz, byte_shift,
              cn >= (8U * sz - 4)
              ? PIC_ASSIGN_SHIFT_N_BYTES_ACTION_SWAP
              : PIC_ASSIGN_SHIFT_N_BYTES_ACTION_COPY, mask, flags);
          } else if (bit_shift && !value_is_same(dst, val1)) {
            pic_assign_shift_left_1_bit(pf, dst, val1, sz, flags);
            bit_shift--;
          }
          if (cn != 8U * sz - 4) {
            if (cn == 8U * sz - 3) {
              bit_shift = 1;
            }
            if (!pfile_flag_test(pf, PFILE_FLAG_CMD_SPEED)
              && (loop_cost < unrolled_cost)) {
              value_t       loop;
              label_t       top;
              variable_sz_t ipos;
              variable_sz_t ii;

              loop = pic_var_accum_get(pf);
              top  = pfile_label_alloc(pf, 0);
              pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, bit_shift);
              pic_instr_append_f(pf, PIC_OPCODE_MOVWF, loop, 0);
              pic_instr_append_label(pf, top);
              pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, byte_shift,
                &ipos);
              if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
                pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
              }
              for (ii = byte_shift; ii < sz; ii++) {
                pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
                pic_instr_append_f_d(pf, PIC_OPCODE_RLF, dst, ii, PIC_OPDST_F);
              }
              pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, loop, 0, 
                PIC_OPDST_F);
              pic_instr_append_n(pf, PIC_OPCODE_GOTO, top);
              label_release(top);
              pic_var_accum_release(pf, loop);
            } else {
              if (!always_clear_c) {
                if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
                  pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", 
                    "_c");
                }
              }
              while (bit_shift--) {
                variable_sz_t ii;
                variable_sz_t ipos;

                pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, byte_shift,
                  &ipos);
                if (always_clear_c) {
                  if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
                    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", 
                      "_c");
                  }
                }
                for (ii = byte_shift; ii < sz; ii++) {
                  pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, 
                    &ipos);
                  pic_instr_append_f_d(pf, PIC_OPCODE_RLF, dst, ii, 
                    PIC_OPDST_F);
                }
              }
            }
          }
        }
        pic_value_sign_extend(pf, dst, sz - 1,
            pic_result_is_signed(pf, val1, val2));
      }
      value_release(fsr);
    }
  } else if (!pic_work_in_temp(pf, op, dst, val1, val2,
    PIC_WORK_IN_TEMP_FLAG_DST
    | PIC_WORK_IN_TEMP_FLAG_DST_VOLATILE)) {
      /* nothing to do */
    if (!pic_is_12bit(pf)
        && value_is_same(dst, val1) 
        && !value_is_indirect(dst)) {
      /* minor optimization, val2 goes into W so we don't need a temp */
      variable_sz_t ipos;
      variable_sz_t ii;
      label_t       lbl_top;
      label_t       lbl_test;

      lbl_top  = pfile_label_alloc(pf, 0);
      lbl_test = pfile_label_alloc(pf, 0);

      pic_indirect_setup3(pf, VALUE_NONE, VALUE_NONE, val2, 0, &ipos);
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, val2, 0, PIC_OPDST_W);
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_test);
      pic_instr_append_label(pf, lbl_top);
      if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
      }
      for (ii = 0; ii < sz; ii++) {
        pic_instr_append_f_d(pf, PIC_OPCODE_RLF, dst, ii, PIC_OPDST_F);
      }
      pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, 255);
      pic_instr_append_label(pf, lbl_test);
      pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_top);

      label_release(lbl_test);
      label_release(lbl_top);
    } else if (pic_result_sz_get(val1, val2, dst) < value_sz_get(dst)) {
      variable_def_t def;
      variable_def_t def_fixed;

      def = value_def_get(dst);
      def_fixed = variable_def_alloc(0, 
          variable_def_type_get(def),
          variable_def_flags_get_all(def),
          pic_result_sz_get(val1, val2, dst));
      value_def_set(dst, def_fixed);
      pic_shift_left(pf, op, dst, val1, val2, flags);
      value_def_set(dst, def);
      pic_value_sign_extend(pf, dst, pic_result_sz_get(val1, val2, dst) - 1,
          pic_result_is_signed(pf, val1, val2));
    } else {
      /* do the shift, one bit at a time */
      value_t       accum;
      label_t       lbl_top;
      label_t       lbl_test;
      variable_sz_t ipos;
      variable_sz_t ii;
      value_t       fsr;

      fsr      = pic_fsr_get(pf);
      lbl_top  = pfile_label_alloc(pf, 0);
      lbl_test = pfile_label_alloc(pf, 0);

      accum = pic_var_accum_get(pf);
      pic_op(pf, OPERATOR_ASSIGN, accum, val2, VALUE_NONE);

      if (!value_is_same(dst, val1)) {
        pic_op(pf, OPERATOR_ASSIGN, dst, val1, VALUE_NONE);
      }
      /* start dst at the end */
      pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, sz - 1, &ipos);
      if (!value_is_same(dst, val1) || value_is_indirect(dst)) {
        pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, accum, 0, PIC_OPDST_W);
      }
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_test);
      pic_instr_append_label(pf, lbl_top);
      if (value_is_indirect(dst)) {
        /* adjust dst to point to the beginning */
        if ((sz > 1) && value_is_indirect(dst)) {
          if (1 == sz - 1) {
            pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
          } else {
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, sz - 1);
            pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, fsr, 0, PIC_OPDST_F);
          }
        }
      }
      ipos = 0;
      if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
        pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
      }
      for (ii = 0; ii < sz; ii++) {
        pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
        pic_instr_append_f_d(pf, PIC_OPCODE_RLF, dst, ii, PIC_OPDST_F);
      }
      pic_instr_append_f_d(pf, PIC_OPCODE_DECF, accum, 0, PIC_OPDST_F);
      pic_instr_append_label(pf, lbl_test);
      pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
      pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_top);
      pic_value_sign_extend(pf, dst, ii - 1, 
          pic_result_is_signed(pf, val1, val2));

      label_release(lbl_test);
      label_release(lbl_top);
      value_release(fsr);
      pic_var_accum_release(pf, accum);
    }
  }
}

static void pic_op_shift_left(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  pic_shift_left(pf, op, dst, val1, val2, PIC_SHIFT_FLAG_MASK_BITS);
}

/* shift right 4 bits:
   swapf  f, w
   andlw  0x0f
   movwf  f
   * [
     swapf  f + n, w
     movwf  f + n
     andlw  0xf0
     xorwf  f + n, f
     iorwf  f + n - 1, f
   ]
*/

static void pic_assign_shift_right_n_bytes(pfile_t *pf, operator_t op,
    value_t dst, value_t src, variable_const_t byte_shift,
    pic_assign_shift_n_bytes_action_t action, unsigned sign_bit,
    unsigned flags)
{
  variable_sz_t ii;
  variable_sz_t ipos;
  boolean_t     fix_sign;

  fix_sign = BOOLEAN_FALSE;
  if (value_is_indirect(dst)) {
    pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE,
        0, &ipos);
  } else if (value_is_indirect(src)) {
    pic_indirect_setup3(pf, src, VALUE_NONE, VALUE_NONE,
        byte_shift, &ipos);
  }
  for (ii = 0; ii + byte_shift < value_sz_get(src); ii++) {
    if (value_is_indirect(dst)) {
      pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
    } else if (value_is_indirect(src)) {
      pic_indirect_bump3(pf, src, VALUE_NONE, VALUE_NONE, ii + byte_shift, 
          &ipos);
    }
    if ((PIC_ASSIGN_SHIFT_N_BYTES_ACTION_SWAP == action)
      && (ii + byte_shift + 1 == value_sz_get(src))) {
      pic_instr_append_f_d(pf, PIC_OPCODE_SWAPF, src, ii + byte_shift,
        PIC_OPDST_W);
      if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x0f);
      }
      fix_sign = BOOLEAN_TRUE;
    } else {
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, src, ii + byte_shift, 
          PIC_OPDST_W);
    }
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
    if (fix_sign &&  (OPERATOR_SHIFT_RIGHT_ARITHMETIC == op)) {
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0xf0);
      pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, dst, ii, 3);
      pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, dst, ii, PIC_OPDST_F);
    }
  }
  if (ii < value_sz_get(dst)) {
    if (OPERATOR_SHIFT_RIGHT_ARITHMETIC == op) {
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
      pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, src, ii + byte_shift - 1,
          sign_bit);
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0xff);
      while (ii < value_sz_get(dst)) {
        pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
        ii++;
      }
    } else {
      while (ii < value_sz_get(dst)) {
        pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
        ii++;
      }
    }
  }
}

static void pic_assign_shift_right_1_bit(pfile_t *pf, operator_t op,
    value_t dst, value_t src, boolean_t set_sign, unsigned flags)
{
  variable_sz_t ipos;
  variable_sz_t ii;
  pic_opdst_t   opdst;
  boolean_t     is_first;

  opdst = (value_is_same(dst, src)) ? PIC_OPDST_F : PIC_OPDST_W;
  pic_indirect_setup3(pf, dst, src, VALUE_NONE, value_sz_get(src) - 1, &ipos);
  ii = value_sz_get(src);
  if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
  }
  is_first = set_sign && (OPERATOR_SHIFT_RIGHT_ARITHMETIC == op);
  while (ii--) {
    pic_indirect_bump3(pf, dst, src, VALUE_NONE, ii, &ipos);
    if (is_first) {
      is_first = BOOLEAN_FALSE;
      pic_instr_append_f_d(pf, PIC_OPCODE_RRF, src, ii, PIC_OPDST_W);
      pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, src, ii, 7);
      pic_instr_append_w_kn(pf, PIC_OPCODE_IORLW, 0x80);
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
    } else {
      pic_instr_append_f_d(pf, PIC_OPCODE_RRF, src, ii, opdst);
      if (PIC_OPDST_W == opdst) {
        pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
      }
    }
  }
}

static boolean_t pic_shift_right_resize(pfile_t *pf, operator_t op,
    value_t dst, value_t val1, value_t val2, unsigned flags)
{
  boolean_t rc;

  rc = BOOLEAN_FALSE;
  if ((value_sz_get(val1) < value_sz_get(val2)) && !value_is_universal(val2)) {
    value_t tmp;

    tmp = pic_var_temp_get(pf,
        value_is_signed(val1) 
        ? VARIABLE_DEF_FLAG_SIGNED : VARIABLE_DEF_FLAG_NONE,
        value_sz_get(val2));
    pic_op(pf, OPERATOR_ASSIGN, tmp, val1, VALUE_NONE);
    pic_shift_right(pf, op, dst, tmp, val2, flags);
    pic_var_temp_release(pf, tmp);
    rc = BOOLEAN_TRUE;
  } else if (value_is_bit(dst)
      || (value_sz_get(dst) < pic_result_sz_get(val1, val2, VALUE_NONE))) {
    value_t tmp;

    tmp = pic_var_temp_get(pf, pic_result_flag_get(pf, val1, val2),
      pic_result_sz_get(val1, val2, VALUE_NONE));
    pic_shift_right(pf, op, tmp, val1, val2, flags);
    pic_op(pf, OPERATOR_ASSIGN, dst, tmp, VALUE_NONE);
    pic_var_temp_release(pf, tmp);
    rc = BOOLEAN_TRUE;
  } else {
    variable_sz_t  sz;

    sz = pic_result_sz_get(val1, val2, VALUE_NONE);
    if (value_sz_get(dst) > sz) {
      /* only work in the bottom part of dst, then sign extend */
      value_t        tmp;
      variable_def_t def;
      variable_sz_t  ipos;

      tmp = value_clone(dst);
      def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
          pic_result_flag_get(pf, val1, val2), sz);
      value_def_set(tmp, def);
      pic_shift_right(pf, op, tmp, val1, val2, flags);
      pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, sz - 1, &ipos);
      pic_value_sign_extend(pf, dst, sz - 1,
          pic_result_is_signed(pf, val1, val2));
      value_release(tmp);
      rc = BOOLEAN_TRUE;
    }
  }
  return rc;
}

/* note: op can be OPERATOR_SHIFT_RIGHT_ARITHMETIC which preserves the
 *       high bit during shifting
 */
static void pic_assign_shift_right_4_bits(pfile_t *pf,
  operator_t op, value_t dst, value_t src, boolean_t set_sign,
  unsigned flags)
{
  /* this can be done in one pass */
  variable_sz_t ipos;

  pic_indirect_setup3(pf, dst, src, VALUE_NONE, 0, &ipos);
  pic_instr_append_f_d(pf, PIC_OPCODE_SWAPF, src, 0, PIC_OPDST_W);
  if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x0f);
  }
  if (set_sign && (OPERATOR_SHIFT_RIGHT_ARITHMETIC == op)) {
    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, src, 0, 7);
    pic_instr_append_w_kn(pf, PIC_OPCODE_IORLW, 0xf0);
  }
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
}

static void pic_shift_right(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2, unsigned flags)
{
  variable_sz_t sz;

  assert(!pic_value_is_w(dst));
  assert(!pic_value_is_w(val1));
  assert(!pic_value_is_w(val2));

  /* the only size that matters is val1
   * if dst is smaller, right shifting could end up shifting into dst
   */

  sz = pic_result_sz_get(val1, val2, VALUE_NONE);
  if (value_is_const(val2) && !value_const_get(val2)) {
    /* shifting 0 = 0 */
    pic_unary_fixup(pf, OPERATOR_ASSIGN, dst, val1, val2);
  } else if ((OPERATOR_SHIFT_RIGHT_ARITHMETIC == op)
      && ((value_is_single_bit(val1) && (value_sz_get(val1) >= sz * 8))
        || (value_is_const(val1)
          && (value_const_get(val1) == (variable_const_t) -1)))) {
    /* arithmetic shifting of -1 == -1 */
    /* arithmetic shifting of a single bit = assignment */
    pic_unary_fixup(pf, OPERATOR_ASSIGN, dst, val1, val2);
  } else if (value_is_const(val2)) {
    variable_const_t cn;

    cn = value_const_get(val2);
    if (0 == cn) {
      /* shouldn't get here */
      pic_unary_fixup(pf, OPERATOR_ASSIGN, dst, val1, val2);
    } else if (cn >= 8U * sz) {
      if (!pic_work_in_temp(pf, op, dst, val1, val2,
            PIC_WORK_IN_TEMP_FLAG_DST)) {
        /* dst is either all 0x00s or all 0xffs */
        if ((OPERATOR_SHIFT_RIGHT_ARITHMETIC == op)) {
          variable_sz_t ii;
          variable_sz_t ipos;

          if (value_is_signed(val1) || (value_sz_get(val1) == sz)) {
            pic_indirect_setup3(pf, val1, VALUE_NONE, VALUE_NONE, 
                value_sz_get(val1) - 1, &ipos);
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0x00);
            if (value_is_bit(val1)) {
              pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC,
                  val1, 0, value_sz_get(val1) - 1);
            } else {
              pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, val1,
                  value_sz_get(val1) - 1, 7);
            }
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0xff);
            if (value_is_indirect(dst)) {
              value_t accum;

              accum = pic_var_accum_get(pf);
              pic_instr_append_f(pf, PIC_OPCODE_MOVWF, accum, 0);
              pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
              pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, accum, 0, PIC_OPDST_W);
              pic_var_accum_release(pf, accum);
            }
            if (pic_result_is_signed(pf, val1, val2)) {
              sz = value_sz_get(dst);
            }
            for (ii = 0; ii < sz; ii++) {
              pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
              pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
            }
          } else {
            pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
            for (ii = 0; ii < sz; ii++) {
              pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
              pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
            }
          }
          sz = value_sz_get(dst);
          while (ii < sz) {
            pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
            pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
            ii++;
          }
        } else {
          variable_sz_t ii;
          variable_sz_t ipos;

          pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 0, &ipos);
          sz = value_sz_get(dst);
          for (ii = 0; ii < sz; ii++) {
            pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii, &ipos);
            pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
          }
        }
      }
    } else if (!pic_shift_right_resize(pf, op, dst, val1, val2, flags)
      && !pic_work_in_temp(pf, op, dst, val1, val2,
          PIC_WORK_IN_TEMP_FLAG_VAL1)) {
      variable_sz_t bit_shift;
      variable_sz_t byte_shift;
      value_t       fsr;

      byte_shift = cn / 8;
      bit_shift  = cn & 0x07;
      fsr        = pic_fsr_get(pf);

      if (byte_shift && !bit_shift) {
        /* this can be done in one pass */
        variable_sz_t ipos;

        pic_assign_shift_right_n_bytes(pf, op, dst, val1, byte_shift,
          PIC_ASSIGN_SHIFT_N_BYTES_ACTION_COPY, 7, flags);
        pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 
            value_sz_get(val1) - 1, &ipos);
        pic_value_sign_extend(pf, dst, value_sz_get(val1) - 1,
            pic_result_is_signed(pf, val1, val2));
      } else if (!byte_shift && (1 == bit_shift)) {
        /* this can be done in one pass */
        variable_sz_t ipos;

        pic_assign_shift_right_1_bit(pf, op, dst, val1, BOOLEAN_TRUE,
          flags);
        pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 
            value_sz_get(val1) - 1, &ipos);
        pic_value_sign_extend(pf, dst, value_sz_get(val1) - 1,
            pic_result_is_signed(pf, val1, val2));
      } else if (!byte_shift && (4 == bit_shift) && (1 == sz)) {
        pic_assign_shift_right_4_bits(pf, op, dst, val1, BOOLEAN_TRUE,
          flags);
      } else if (!pic_work_in_temp(pf, op, dst, val1, val2,
            PIC_WORK_IN_TEMP_FLAG_DST_VOLATILE)) {
        if ((5 == cn) && (1 == sz)) {
          pic_assign_shift_right_4_bits(pf, op, dst, val1,
            BOOLEAN_FALSE, flags);
          if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
            pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
          }
          if (OPERATOR_SHIFT_RIGHT_ARITHMETIC == op) {
            pic_instr_append_f_d(pf, PIC_OPCODE_RRF, dst, 0, PIC_OPDST_W);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, dst, 0, 3);
            pic_instr_append_w_kn(pf, PIC_OPCODE_IORLW, (unsigned char) ~3);
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
          } else {
            pic_instr_append_f_d(pf, PIC_OPCODE_RRF, dst, 0, PIC_OPDST_F);
          }
        } else if (8U * sz - 2 == cn) {
          variable_sz_t ipos;
          pic_opdst_t   opdst;

          if (value_is_indirect(dst)) {
            pic_indirect_setup(pf, dst, 0);
          } else if (value_is_indirect(val1)) {
            pic_indirect_setup(pf, val1, sz - 1);
          } 
          opdst = (value_is_same(dst, val1)) ? PIC_OPDST_F : PIC_OPDST_W;
          pic_instr_append_f_d(pf, PIC_OPCODE_RLF, val1, sz - 1, opdst);
          if (PIC_OPDST_W == opdst) {
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
          }
          pic_instr_append_f_d(pf, PIC_OPCODE_RLF, dst, 0, PIC_OPDST_F);
          pic_instr_append_f_d(pf, PIC_OPCODE_RLF, dst, 0, PIC_OPDST_W);
          if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
            pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x03);
          }
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
          if (OPERATOR_SHIFT_RIGHT_ARITHMETIC == op) {
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, dst, 0, 1);
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, (unsigned char) ~3);
            pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, dst, 0, PIC_OPDST_F);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, dst, 0, 1);
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0xff);
            for (ipos = 1; ipos < sz; ipos++) {
              if (value_is_indirect(dst)) {
                pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, 
                  PIC_OPDST_F);
              }
              pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ipos);
            }
          } else {
            for (ipos = 1; ipos < sz; ipos++) {
              if (value_is_indirect(dst)) {
                pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, 
                  PIC_OPDST_F);
              }
              pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ipos);
            }
          }
        } else if (8U * sz - 1 == cn) {
          if (OPERATOR_SHIFT_RIGHT == op) {
            variable_sz_t ii;
            pic_opdst_t   opdst;

            if (value_is_indirect(dst)) {
              pic_indirect_setup(pf, dst, 0);
            } else if (value_is_indirect(val1)) {
              pic_indirect_setup(pf, val1, sz - 1);
            } 
            opdst = (value_is_same(dst, val1)) ? PIC_OPDST_F : PIC_OPDST_W;
            pic_instr_append_f_d(pf, PIC_OPCODE_RLF, val1, sz - 1, opdst);
            pic_instr_append_f_d(pf, PIC_OPCODE_RLF, dst, 0, PIC_OPDST_W);
            if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
              pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x01);
            }
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, 0);
            for (ii = 1; ii < sz; ii++) {
              if (value_is_indirect(dst)) {
                pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, 
                  PIC_OPDST_F);
              }
              pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
            }
          } else {
            variable_sz_t ii;

            if (value_is_indirect(dst)) {
              pic_indirect_setup(pf, dst, 0);
            } else if (value_is_indirect(val1)) {
              pic_indirect_setup(pf, val1, sz - 1);
            } 

            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
            pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, val1, sz - 1, 7);
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 255);
            for (ii = 0; ii < sz; ii++) {
              if (ii && value_is_indirect(dst)) {
                pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, 
                  PIC_OPDST_F);
              }
              pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
            }
          }
        } else if ((8U * sz - 4 == cn) || (8U * sz - 3 == cn)) {
          pic_assign_shift_right_n_bytes(pf, op, dst, val1, byte_shift,
            PIC_ASSIGN_SHIFT_N_BYTES_ACTION_SWAP, 3, flags);
          if (8U * sz - 3 == cn) {
            if (value_is_indirect(dst)) {
              if (2 == sz) {
                pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
              } else {
                pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW,
                  byte_shift);
                pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, fsr, 0, 
                  PIC_OPDST_F);
              }
            }
            if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
              pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
            }
            if (OPERATOR_SHIFT_RIGHT_ARITHMETIC == op) {
              pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, dst, 0, 7);
              pic_instr_append_reg_flag(pf, PIC_OPCODE_BSF, "_status", "_c");
            }
            assert(sz - byte_shift == 1);
            pic_instr_append_f_d(pf, PIC_OPCODE_RRF, dst, 0, 
              PIC_OPDST_F);
          }
        } else {
          unsigned cost_loop;
          unsigned cost_unrolled;
          unsigned fix;

          fix = 0;
          if (byte_shift) {
            pic_assign_shift_right_n_bytes(pf, op, dst, val1, byte_shift,
              PIC_ASSIGN_SHIFT_N_BYTES_ACTION_COPY, 7, flags);
          } else if (bit_shift 
              && !value_is_same(dst, val1)) {
            pic_assign_shift_right_1_bit(pf, op, dst, val1, BOOLEAN_TRUE, 
              flags);
            bit_shift--;
            fix = 1;
          }
          pic_value_sign_extend(pf, dst, value_sz_get(val1) - 1,
              pic_result_is_signed(pf, val1, val2)
              || (value_is_signed(val1) 
                && (value_sz_get(val2) > value_sz_get(val1))));
          cost_loop     = (sz - byte_shift) * 2 + 4;
          cost_unrolled = ((sz - byte_shift) + 1) * bit_shift;

          if (pfile_flag_test(pf, PFILE_FLAG_CMD_SPEED)
            || (cost_unrolled <= cost_loop)) {
            variable_sz_t bit;

            for (bit = 0; bit < bit_shift; bit++) {
              variable_sz_t ii;

              /* we're at 0 and need to move back to the end */
              if (value_is_indirect(dst) && (sz != 1)) {
                if (byte_shift) {
                  /* if we've byte-shifted and are indirect, we're positioned
                   * at the end of the indirect already, so set byte_shift
                   * to zero */
                  byte_shift = 0;
                } else {
                  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, sz - 1);
                  pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, fsr, 0,
                      PIC_OPDST_F);
                }
              }
              if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
                pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
              }
              ii = sz - byte_shift;
              while (ii) {
                if ((ii != sz) && value_is_indirect(dst)) {
                  pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0,
                      PIC_OPDST_F);
                }
                ii--;
                if ((bit + 1 == bit_shift) 
                  && (ii + 1 == sz - byte_shift)
                  && (OPERATOR_SHIFT_RIGHT_ARITHMETIC == op)) {
                  /* set the high bits if necessary */
                  unsigned char mask;

                  pic_instr_append_f_d(pf, PIC_OPCODE_RRF, dst, ii,
                    PIC_OPDST_W);
                  pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, dst, ii,
                    7 - bit - fix);
                  mask = 0x00; /* fix compiler warning */
                  switch (bit + fix) {
                    case 0: mask = 0x80; break;
                    case 1: mask = 0xc0; break;
                    case 2: mask = 0xe0; break;
                    case 3: mask = 0xf0; break;
                    case 4: mask = 0xf8; break;
                    case 5: mask = 0xfc; break;
                    case 6: mask = 0xfe; break;
                    case 7: mask = 0xff; break;
                  }
                  pic_instr_append_w_kn(pf, PIC_OPCODE_IORLW, mask);
                  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, dst, ii);
                } else {
                  pic_instr_append_f_d(pf, PIC_OPCODE_RRF, dst, ii, 
                    PIC_OPDST_F);
                }
              }
            }
          } else {
            value_t       loop;
            label_t       top;
            variable_sz_t ipos;
            variable_sz_t ii;

            loop = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);
            top = pfile_label_alloc(pf, 0);
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, bit_shift);
            pic_instr_append_f(pf, PIC_OPCODE_MOVWF, loop, 0);
            pic_instr_append_label(pf, top);
            pic_indirect_setup3(pf, dst, VALUE_NONE, VALUE_NONE, 
              sz - byte_shift, &ipos);
            if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
              pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
            }
            if (OPERATOR_SHIFT_RIGHT_ARITHMETIC == op) {
              pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, dst, sz - 1, 7);
              pic_instr_append_reg_flag(pf, PIC_OPCODE_BSF,"_status", "_c");
            }
            for (ii = sz - byte_shift; ii; ii--) {
              pic_indirect_bump3(pf, dst, VALUE_NONE, VALUE_NONE, ii - 1, 
                &ipos);
              pic_instr_append_f_d(pf, PIC_OPCODE_RRF, dst, ii - 1, 
                PIC_OPDST_F);
            }
            pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, loop, 0, PIC_OPDST_F);
            pic_instr_append_n(pf, PIC_OPCODE_GOTO, top);
            label_release(top);
            pic_var_temp_release(pf, loop);
          }
        }
      }
      value_release(fsr);
    }
  } else if (!pic_shift_right_resize(pf, op, dst, val1, val2, flags)
      && !pic_work_in_temp(pf, op, dst, val1, val2,
        PIC_WORK_IN_TEMP_FLAG_VAL1
        | PIC_WORK_IN_TEMP_FLAG_DST
        | PIC_WORK_IN_TEMP_FLAG_DST_VOLATILE)) {
    value_t       accum;
    label_t       lbl_top;
    label_t       lbl_end;
    value_t       c1;
    variable_sz_t ipos;
    variable_sz_t ii;

    lbl_top = pfile_label_alloc(pf, 0);
    lbl_end = pfile_label_alloc(pf, 0);

    c1 = pfile_constant_get(pf, 1, VARIABLE_DEF_NONE);
    accum = pic_var_accum_get(pf);
    pic_op(pf, OPERATOR_ASSIGN, accum, val2, VALUE_NONE);
    pic_op(pf, OPERATOR_ASSIGN, dst, val1, VALUE_NONE);
    if (!value_is_same(dst, val1)) {
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, accum, 0, PIC_OPDST_F);
    }
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_end);
    pic_instr_append_label(pf, lbl_top);
    pic_indirect_setup3(pf, val1, VALUE_NONE, dst, sz - 1, &ipos);
    if (flags & PIC_SHIFT_FLAG_MASK_BITS) {
      pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    }
    for (ii = sz; ii; ii--) {
      pic_indirect_bump3(pf, val1, VALUE_NONE, dst, ii - 1, &ipos);
      pic_instr_append_f_d(pf, PIC_OPCODE_RRF, dst, ii - 1, PIC_OPDST_F);
      if ((ii == sz) && (OPERATOR_SHIFT_RIGHT_ARITHMETIC == op)) {
        pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, dst, ii - 1, 6);
        pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, dst, ii - 1, 7);
      }
    }
    pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, accum, 0, PIC_OPDST_F);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_top);
    pic_instr_append_label(pf, lbl_end);

    pic_var_accum_release(pf, accum);
    value_release(c1);
    label_release(lbl_end);
    label_release(lbl_top);
  }
}

static void pic_op_shift_right(pfile_t *pf, operator_t op, value_t dst,
  value_t val1, value_t val2)
{
  pic_shift_right(pf, op, dst, val1, val2, PIC_SHIFT_FLAG_MASK_BITS);
}

/* set dst to 0 if val is 0, 1 if val != 0 */
static void pic_op_logical_or_not(pfile_t *pf, operator_t op, value_t dst,
  value_t src, value_t val2)
{
  UNUSED(val2);

  assert(!pic_value_is_w(src));

  if (value_is_single_bit(src)) {
    if (value_is_single_bit(dst)) {
      pic_opcode_t opcode;

      opcode = (OPERATOR_LOGICAL == op) ? PIC_OPCODE_BTFSC : PIC_OPCODE_BTFSS;

      if ((OPERATOR_LOGICAL == op) && value_is_same(dst, src)) {
        /* this is a no-op */
      } else if (value_is_same(dst, src) 
          || value_is_volatile(dst)
          || !pic_val_bank_same(pf, dst, src)) {
        label_t lbl_set;
        label_t lbl_done;

        lbl_set  = pfile_label_alloc(pf, 0);
        lbl_done = pfile_label_alloc(pf, 0);
        pic_instr_append_f(pf, opcode, src, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_set);
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
        pic_instr_append_label(pf, lbl_set);
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        pic_instr_append_label(pf, lbl_done);

        label_release(lbl_done);
        label_release(lbl_set);
      } else {
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        pic_instr_append_f(pf, opcode, src, 0);
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
      }
    } else {
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
      pic_instr_append_f(pf, (OPERATOR_LOGICAL == op)
          ? PIC_OPCODE_BTFSC
          : PIC_OPCODE_BTFSS,
          src, 0);
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 1);
      pic_assign_from_w(pf, dst, BOOLEAN_FALSE);
    }
  } else {
    pic_value_is_zero(pf, src); /* Z is set if src is zero */
    if (value_is_single_bit(dst)) {
      if (value_is_volatile(dst)) {
        label_t lbl_clr;
        label_t lbl_done;

        lbl_clr = pfile_label_alloc(pf, 0);
        lbl_done = pfile_label_alloc(pf, 0);
        pic_instr_append_reg_flag(pf, (OPERATOR_LOGICAL == op)
            ? PIC_OPCODE_BTFSC : PIC_OPCODE_BTFSS, "_status", "_z");
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_clr);
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
        pic_instr_append_label(pf, lbl_clr);
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
        pic_instr_append_label(pf, lbl_done);
        label_release(lbl_done);
        label_release(lbl_clr);
      } else {
        pic_instr_append_f(pf, PIC_OPCODE_BSF, dst, 0);
        pic_instr_append_reg_flag(pf, (OPERATOR_LOGICAL == op)
            ? PIC_OPCODE_BTFSC : PIC_OPCODE_BTFSS, "_status", "_z");
        pic_instr_append_f(pf, PIC_OPCODE_BCF, dst, 0);
      }
    } else if (VALUE_NONE != dst) {
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 1);
      pic_instr_append_reg_flag(pf, (OPERATOR_LOGICAL == op)
          ? PIC_OPCODE_BTFSC : PIC_OPCODE_BTFSS, "_status", "_z");
      pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
      pic_assign_from_w(pf, dst, BOOLEAN_FALSE);
    }
  }
}

/*
 * NAME
 *   pic_op
 *
 * DESCRIPTION
 *   create code for an operator
 *
 * PARAMETERS
 *   pf  : file
 *   op  :
 *   dst :
 *   val1:
 *   val2:
 *
 * RETURN
 *   none
 *
 * NOTES
 */
extern variable_sz_t pic_temp_sz_in_use;

typedef void (*operator_fn_t)(pfile_t *pf, operator_t op, value_t dst, 
    value_t val1, value_t val2);

static const struct operator_fn_tbl_ {
  operator_t    op;
  operator_fn_t fn;
  unsigned      flags;
} operator_fn_tbl[] = {
  { OPERATOR_NULL,        0,                     0},
  { OPERATOR_ADD,         pic_op_add_sub,        0},
  { OPERATOR_SUB,         pic_op_add_sub,        0},
  { OPERATOR_MUL,         pic_op_mul,            0},
  { OPERATOR_DIV,         pic_op_div_mod,        0},
  { OPERATOR_MOD,         pic_op_div_mod,        0},
  { OPERATOR_LT,          pic_op_relational,     0},
  { OPERATOR_LE,          pic_op_relational,     0},
  { OPERATOR_EQ,          pic_op_relational,     0},
  { OPERATOR_NE,          pic_op_relational,     0},
  { OPERATOR_GE,          pic_op_relational,     0},
  { OPERATOR_GT,          pic_op_relational,     0},
  { OPERATOR_ANDL,        pic_op_logical_and,    0},
  { OPERATOR_ORL,         pic_op_logical_or,     0},
  { OPERATOR_NOTL,        pic_op_logical_or_not, 0},
  { OPERATOR_ANDB,        pic_op_binary_and,     0},
  { OPERATOR_ORB,         pic_op_binary_or,      0},
  { OPERATOR_XORB,        pic_op_binary_xor,     0},
  { OPERATOR_CMPB,        pic_op_cmp,            0},
  { OPERATOR_ASSIGN,      pic_op_assign,         0},
  { OPERATOR_NEG,         pic_op_neg,            0},
  { OPERATOR_INCR,        pic_op_incr,           0},
  { OPERATOR_DECR,        pic_op_decr,           0},
  { OPERATOR_SHIFT_LEFT,  pic_op_shift_left,     0},
  { OPERATOR_SHIFT_RIGHT, pic_op_shift_right,    0},
  { OPERATOR_SHIFT_RIGHT_ARITHMETIC, pic_op_shift_right,    0},
  { OPERATOR_LOGICAL,     pic_op_logical_or_not, 0}
};

void pic_op(pfile_t *pf, operator_t op, value_t dst, value_t val1,
    value_t val2)
{
  variable_sz_t    init;

  init = pic_temp_sz_in_use;
  if ((OPERATOR_ASSIGN != op) 
      && (value_is_label(val1) || value_is_label(val2))) {
    if (value_is_label(val1)) {
      value_t tmp;

      tmp = pic_var_temp_get_assign(pf, val1, VALUE_NONE, dst);
      pic_op(pf, op, dst, tmp, val2);
      pic_var_temp_release(pf, tmp);
    } else if (value_is_label(val2)) {
      value_t tmp;

      tmp = pic_var_temp_get_assign(pf, val2, VALUE_NONE, dst);
      pic_op(pf, op, dst, val1, tmp);
      pic_var_temp_release(pf, tmp);
    }
  } else {
    if (operator_is_binary(op)) {
      if (!val2) {
        val2 = val1;
        val1 = dst;
      }
    } else if (operator_is_unary(op)) {
      if (!val1) {
        val1 = dst;
      }
    }
    if ((OPERATOR_ASSIGN != op)
        && value_is_const(val1)
        && (operator_is_unary(op) || value_is_const(val2))) {
      value_t    tmp;
      pf_const_t c;

      c = pfile_op_const_exec(pf, op, val1, val2);
      tmp = pf_const_to_const(pf, c, VARIABLE_DEF_NONE);
      pic_op(pf, OPERATOR_ASSIGN, dst, tmp, VALUE_NONE);
      value_release(tmp);
    } else {
      size_t           ii;
      pic_last_value_t which;

      for (ii = 0;
           (ii < COUNT(operator_fn_tbl))
           && (operator_fn_tbl[ii].op != op);
           ii++)
        ;
      if (ii == COUNT(operator_fn_tbl)) {
        assert(0);
      } else if (!operator_fn_tbl[ii].fn) {
        assert(0);
      } else {
        operator_fn_tbl[ii].fn(pf, op, dst, val1, val2);
      }
      /* if one of the last values has changed, invalid these */
      for (which = PIC_LAST_VALUE_FIRST;
           (which < PIC_LAST_VALUE_CT)
           && !value_is_same(pic_last_values[which], dst);
           which++)
        ;
      if (which < PIC_LAST_VALUE_CT) {
        pic_last_values_reset();
      }
    }
  }
  assert(init == pic_temp_sz_in_use);
}

