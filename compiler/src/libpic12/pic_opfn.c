/************************************************************
 **
 ** pic_opfn.c : PIC built-in function generation
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <string.h>
#include "pic_inst.h"
#include "pic_stvar.h"
#include "pic_op.h"
#include "pic_opfn.h"
#include "../libcore/value.h"

/*
 *  algorithm -- 
 *    worst case time
 *      16 x 16 - 31 cycles
 *      32 x 32 - 85 cycles
 *  
 *    for ii = 0 to width of multiplier - 1
 *      for jj = 0 to width of multiplicand - 1
 *        if (ii + jj < width of mresult)
 *          prod = multiplier[ii] * multiplicand[jj]
 *          mresult[ii + jj] += prod
 *        end if
 *      next
 *    next
 *  on exit, mresult holds the result
 *
 *  note: in the PIC18F2420 data sheet, the algorithm
 *        is somewhat different. Since sizeof(mresult)
 *        == sizeof(multiplcand), this is not an issue.
 *        If that assertion no longer holds, more work
 *        will need to be done here.
 */
static void pic_multiply_create_fn16(pfile_t *pf, 
    value_t mresult, value_t multiplier, value_t multiplicand)
{
  variable_sz_t w1;
  variable_sz_t w2;
  variable_sz_t ii;
  value_t       prod;
  value_t       tmp_result;
  unsigned long c;
  boolean_t     prod_clear;

  w1 = value_byte_sz_get(multiplier);
  w2 = (value_is_universal(multiplicand)) 
     ? w1 : value_byte_sz_get(multiplicand);
  prod = pfile_value_find(pf, PFILE_LOG_ERR, "prod");   


  if (value_is_const(multiplicand)) {
    /* make sure the constant is in the multiplier */
    SWAP(value_t, multiplier, multiplicand);
    SWAP(variable_sz_t, w1, w2);
  }
  if (value_is_same(mresult, multiplier)
    || value_is_same(mresult, multiplicand)) {
      /* we need a temporary variable */
      tmp_result = pic_var_temp_get(pf, VARIABLE_DEF_FLAG_NONE,
          value_byte_sz_get(mresult));
  } else {
      tmp_result = mresult;
  }
  c = value_const_get(multiplier);

  prod_clear = BOOLEAN_FALSE;
  for (ii = 0; ii < w1; ii++, c >>= 8) {
    variable_sz_t jj;

    for (jj = 0; jj < w2; jj++) {
      if (ii + jj < value_sz_get(mresult)) {
        if (value_is_const(multiplier)) {
          unsigned lsb;

          lsb = (unsigned) c & 0xff;
          if (!lsb) {
            if (!prod_clear) {
              prod_clear = BOOLEAN_TRUE;
            }
          } else {
            pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, lsb);
            pic_instr_append_f(pf, PIC_OPCODE_MULWF, multiplicand, jj);
            prod_clear = BOOLEAN_FALSE;
          }
        } else {
          pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, multiplier, ii, 
              PIC_OPDST_W);
          pic_instr_append_f(pf, PIC_OPCODE_MULWF, multiplicand, jj);
          prod_clear = BOOLEAN_FALSE;
        }
        if ((0 == ii) && (0 == jj)) {
          pic_op(pf, OPERATOR_ASSIGN, tmp_result, prod, VALUE_NONE);
        } else {
          if (!prod_clear) {
            value_t          tmp;
            variable_const_t baseofs;

            tmp     = pic_cast(tmp_result, value_sz_get(mresult) - (ii + jj));
            baseofs = value_const_get(value_baseofs_get(tmp_result));
            value_baseofs_set(tmp, pfile_constant_get(pf, baseofs + ii + jj, 
                VARIABLE_DEF_NONE));
            pic_op(pf, OPERATOR_ADD, tmp, prod, VALUE_NONE);
            value_release(tmp);
          }
        }
      }
    }
  }
  if (tmp_result != mresult) {
    pic_op(pf, OPERATOR_ASSIGN, mresult, tmp_result, VALUE_NONE);
    pic_var_temp_release(pf, tmp_result);
  }
  value_release(prod);
}

/*
 *  algorithm -- 
 *    worst case time
 *      16 x 16 - 289 cycles
 *      32 x 32 - 957 cycles
 *    for ii = 1 to bits in multiplier
 *      mresult <<= 1
 *      multiplier <<= 1
 *      if (carry)
 *        mresult += multiplicand
 *      end if
 *    next
 *  on exit, mresult holds the result
 */
void pic_multiply_create_fn(pfile_t *pf, label_t lbl,
    value_t mresult, value_t multiplier, value_t multiplicand)
{
  if (LABEL_NONE != lbl) {
    pic_instr_append_label(pf, lbl);
  }
  if (pic_is_16bit(pf)) {
    pic_multiply_create_fn16(pf, mresult, multiplier, multiplicand);
  } else {
    label_t       top;
    label_t       skip;
    variable_sz_t ii;
    pic_var_mul_t mvars;
    value_t       c_1;
    value_t       loop;

    pic_var_mul_get(pf, -1, -1, &mvars);
    c_1    = pfile_constant_get(pf, 1, VARIABLE_DEF_NONE);
    loop   = pic_var_loop_get(pf);
    top    = pfile_label_alloc(pf, 0);
    skip   = pfile_label_alloc(pf, 0);
    /*
     * if the shift width is smaller than the full width, clear
     * out the difference (the top ones are shifted out, so no
     * worries
     */
    /*
     * nb: if using the emulator, clear the entire result or
     *     you'll get a lot of `uninitialized memory read'
     *     warnings
     */
    if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_EMULATOR)) {
      for (ii = 0; ii < value_sz_get(mresult); ii++) {
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, mresult, ii);
      }
    } else {
      for (ii = value_sz_get(multiplier);
           ii < value_sz_get(mresult);
           ii ++) {
        pic_instr_append_f(pf, PIC_OPCODE_CLRF, mresult, 
           ii - value_sz_get(multiplier));
      }
    }
    pic_instr_append_w_kn(pf, 
        PIC_OPCODE_MOVLW, 8 * value_sz_get(multiplier));
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, loop, 0);
    pic_instr_append_label(pf, top);
    pic_op(pf, OPERATOR_SHIFT_LEFT, mresult, c_1, 0);
    pic_op(pf, OPERATOR_SHIFT_LEFT, multiplier, c_1, 0);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_c");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, skip);
    pic_op(pf, OPERATOR_ADD, mresult, multiplicand, 0);
    pic_instr_append_label(pf, skip);
    pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, loop, 0, PIC_OPDST_F);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, top);
    label_release(skip);
    label_release(top);
    pic_var_loop_release(pf, loop);
    value_release(c_1);
    pic_var_mul_release(pf, &mvars);
  }
  if (LABEL_NONE != lbl) {
    pic_instr_append(pf, PIC_OPCODE_RETURN);
  }
}

static void pic_multiply_create(pfile_t *pf)
{
  size_t        ii;
  pic_var_mul_t mvars;

  pic_var_mul_get(pf, -1, -1, &mvars);
  if (pfile_flag_test(pf, PFILE_FLAG_MISC_FASTMATH)) {
    const pfile_multiply_width_table_entry_t *mw;

    ii = 0;
    while (0 != (mw = pfile_multiply_width_table_entry_get(pf, ii))) {
      char    label[32];
      label_t lbl;

      sprintf(label, "%s_%u_%u", PIC_LABEL_MULTIPLY,
          mw->multiplier,
          mw->multiplicand);
      /*
       * note: the label might not exist. In this case the
       *       multiplication might have been optimized out,
       *       or inlined
       */
      lbl = pfile_label_find(pf, PFILE_LOG_NONE, label);
      if (lbl) {
        value_t multiplier;
        value_t multiplicand;
        value_t mresult;

        multiplier = pic_cast(mvars.multiplier, mw->multiplier);
        multiplicand = pic_cast(mvars.multiplicand, mw->multiplicand);
        mresult = pic_cast(mvars.mresult, mw->multiplicand);
        pic_multiply_create_fn(pf, lbl, mresult, multiplier, multiplicand);    
        if (mresult != mvars.mresult) {
          value_release(mresult);
        }
        if (multiplicand != mvars.multiplicand) {
          value_release(multiplicand);
        }
        if (multiplier != mvars.multiplier) {
          value_release(multiplier);
        }
        label_release(lbl);
      }
      ii++;
    }
  } else {
    label_t lbl;

    lbl = pfile_label_find(pf, PFILE_LOG_NONE, PIC_LABEL_MULTIPLY);
    if (lbl) {
      pic_multiply_create_fn(pf, lbl, mvars.mresult, mvars.multiplier,
          mvars.multiplicand);
      label_release(lbl);
    }
  }
  pic_var_mul_release(pf, &mvars);
}

/*
 * NAME
 *    pic_divide_create
 *
 * DESCRIPTION
 *    create an n-bit divide
 *
 * PARAMETERS
 *    pf : pfile
 *
 * RETURN
 *
 * NOTES
 *   entry:
 *     dividend, divisor are set on entry
 *   algorithm:
 *     for ii = 1 to bits
 *       quotient <<= 1
 *       dividend <<= 1
 *       remainder = remainder << 1 | carry from prev. op
 *       if (remainder >= divisor)
 *         remainder -= divisor
 *         quotient |= 1
 *       end if
 *     next 
 */
static void pic_sdivide_create(pfile_t *pf)
{
  pic_var_div_t dvars;
  value_t       sign;
  value_t       loop;
  value_t       c_1;
  value_t       c_0;
  label_t       top;
  label_t       skip;
  label_t       doit;
  label_t       sdivide;
  label_t       divide;
  label_t       lbl;

  divide = pfile_label_find(pf, PFILE_LOG_NONE, PIC_LABEL_DIVIDE);
  sdivide = pfile_label_find(pf, PFILE_LOG_NONE, PIC_LABEL_SDIVIDE);

  sign   = pic_var_sign_get(pf);
  pic_var_div_get(pf, -1, &dvars);
  c_1 = pfile_constant_get(pf, 1, VARIABLE_DEF_NONE);
  c_0 = pfile_constant_get(pf, 0, VARIABLE_DEF_NONE);

  loop   = pic_var_loop_get(pf);
  top    = pfile_label_alloc(pf, 0);
  skip   = pfile_label_alloc(pf, 0);
  doit   = pfile_label_alloc(pf, 0);

  if (sdivide) {
    /* create the signed divide preamble */
    lbl = pfile_label_alloc(pf, 0);
    /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, dvars.dividend, 
      value_sz_get(dvars.dividend) - 1, 7);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    /* dividend = -dividend */
    pic_op(pf, OPERATOR_NEG, dvars.dividend, dvars.dividend, 0);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 1);
    pic_instr_append_label(pf, lbl);
    label_release(lbl);
    lbl = 0;
    /* sign = 0 (unsigned) 1 (signed) */
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, sign, 0);

    lbl = pfile_label_alloc(pf, 0);

    /* pic_instr_append(pf, PIC_OPCODE_CLRW); */
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, dvars.divisor, 
      value_sz_get(dvars.divisor) - 1, 7);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    /* divisor = -divisor */
    pic_op(pf, OPERATOR_NEG, dvars.divisor, dvars.divisor, 0);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 1);
    pic_instr_append_label(pf, lbl);
    /* sign = 0 (unsigned) 1 (signed) */
    pic_instr_append_f_d(pf, PIC_OPCODE_XORWF, sign, 0, PIC_OPDST_F);

    label_release(lbl);
  }

  if (sdivide && divide) {
    /* sdivide needs to jump over a statement here */
    lbl = pfile_label_alloc(pf, 0);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    pic_instr_append_label(pf, divide);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, sign, 0);
    pic_instr_append_label(pf, lbl);
    label_release(lbl);
  } else {
    pic_instr_append_label(pf, divide);
  }
  /* 
   * nb: normally there's no need to clear the quotient because it
   *     it is completely rotated out, however the emulator will
   *     flag this as an `uninitialized memory read' so if running
   *     the emulator, clear it.
   */
  if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_EMULATOR)) {
    pic_op(pf, OPERATOR_ASSIGN, dvars.quotient, c_0, VALUE_NONE);
  }
  /* # bits --> loop */
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 8 * value_sz_get(dvars.quotient));
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, loop, 0);
  pic_op(pf, OPERATOR_ASSIGN, dvars.remainder, c_0, 0);
  pic_instr_append_label(pf, top);
  /* quotient <<= 1 */
  pic_op(pf, OPERATOR_SHIFT_LEFT, dvars.quotient, c_1, 0);
  /* {dividend:remainder} <<= 1 */
  pic_op(pf, OPERATOR_SHIFT_LEFT, dvars.divaccum, c_1, 0);
  /* if divisor > remainder, subtract */
  pic_op(pf, OPERATOR_LE, 0, dvars.remainder, dvars.divisor);
  pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, doit);
  pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, skip);
  pic_instr_append_label(pf, doit);
  pic_op(pf, OPERATOR_SUB, dvars.remainder, dvars.divisor, 0);
  pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, dvars.quotient, 0, 0);
  pic_instr_append_label(pf, skip);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, loop, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, top);

  if (sdivide) {
    /* what to do with the result */
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, sign, 0, PIC_OPDST_W);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    /* invert the result */
    pic_op(pf, OPERATOR_NEG, dvars.quotient, 0, 0);
    pic_op(pf, OPERATOR_NEG, dvars.remainder, 0, 0);
  }
  pic_instr_append(pf, PIC_OPCODE_RETURN);

  pic_var_sign_release(pf, sign);
  label_release(sdivide);
  label_release(divide);
  label_release(doit);
  label_release(skip);
  label_release(top);
  pic_var_loop_release(pf, loop);
  value_release(c_1);
  value_release(c_0);
  pic_var_div_release(pf, &dvars);
}

/*
 * NAME
 *    pic_divide_create
 *
 * DESCRIPTION
 *    create a signed divide
 *
 * PARAMETERS
 *    pf
 *
 * RETURN
 *
 * NOTES
 *   on entry:
 *   algorithm:
 *     if dividend & divisor are not the same sign, the result is (-)
 *     dividend = abs(dividend)
 *     divisor = abs(divisor)
 *     call divide (above)
 *     if (-) then quotient = -quotient
 */
static void pic_divide_create(pfile_t *pf)
{
  label_t lbl;

  lbl = pfile_label_find(pf, PFILE_LOG_NONE, PIC_LABEL_SDIVIDE);
  if (lbl) {
    label_release(lbl);
  } else {
    pic_sdivide_create(pf);
  }
}

/*
 * NAME
 *   pic_memcmp_create
 *
 * DESCRIPTION
 *   create memory compare
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 *   _pic_temp[0,1] = &a
 *   _pic_temp[2,3] = &b
 *   w holds the length; 0 = 256
 *   uses _sign and _loop
 *   Z set if equal
 *   C set if a < b
 */
static void pic_memcmp_create(pfile_t *pf)
{
  label_t top;
  value_t val1;
  value_t val2;
  value_t loop;
  value_t sign; /* temporary holder */
  value_t ind;  /* indirect value   */

  top  = pfile_label_alloc(pf, 0);
  val1 = pic_var_temp_get(pf, VARIABLE_DEF_FLAG_NONE, 2);
  val2 = pic_var_temp_get(pf, VARIABLE_DEF_FLAG_NONE, 2);
  sign = pic_var_sign_get(pf);
  loop = pic_var_loop_get(pf);
  ind  = pic_indirect_get(pf, PFILE_LOG_ERR, 0);

  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, loop, 0);
  pic_instr_append_label(pf, top);
  /* w = *pic_memcmp_a */
  pic_fsr_setup(pf, val1);
  pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ind, 0, PIC_OPDST_W);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, sign, 0);
  /* w = *pic_memcmp_b  - w */
  pic_fsr_setup(pf, val2);
  pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ind, 0, PIC_OPDST_W);
  pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, sign, 0, PIC_OPDST_W);
  /* test _sign */
  pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
  pic_instr_append(pf, PIC_OPCODE_RETURN);
  pic_instr_append_f_d(pf, PIC_OPCODE_INCF, val1, 0, PIC_OPDST_F);
  pic_instr_append_f_d(pf, PIC_OPCODE_INCF, val2, 0, PIC_OPDST_F);
  pic_instr_append_f(pf, PIC_OPCODE_DECFSZ, loop, 0);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, top);
  pic_instr_append(pf, PIC_OPCODE_RETURN);

  value_release(ind);
  pic_var_loop_release(pf, loop);
  pic_var_sign_release(pf, sign);
  pic_var_temp_release(pf, val2);
  pic_var_temp_release(pf, val1);
  label_release(top);
}

/*
 * NAME
 *   pic_memset_create
 *
 * DESCRIPTION
 *   create the memset function
 *
 * PARAMETERS
 *   
 * RETURN
 *
 * NOTES
 *   _fsr:_irp = &dst
 *   _pic_loop = length
 *   w         = value
 */
static void pic_memset_create(pfile_t *pf)
{
  label_t top;
  value_t loop;
  value_t fsr;
  value_t ind;

  fsr  = pic_fsr_get(pf);
  top  = pfile_label_alloc(pf, 0);
  loop = pic_var_loop_get(pf);
  ind  = pic_indirect_get(pf, PFILE_LOG_ERR, 0);

  pic_instr_append_label(pf, top);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, ind, 0);
  pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, PIC_OPDST_F);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, loop, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, top);
  pic_instr_append(pf, PIC_OPCODE_RETURN);

  value_release(ind);
  pic_var_loop_release(pf, loop);
  label_release(top);
  value_release(fsr);
}

/*
 * NAME
 *   pic_memcpy_create
 *
 * DESCRIPTION
 *   create the mem copy
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 *   _pic_memcpy_src = src
 *   _pic_memcpy_dst = dst
 *   w = length (0 = 256)
 */
static void pic_memcpy_create(pfile_t *pf)
{
  label_t top;
  value_t params[2];
  value_t loop;
  value_t sign; /* temporary holder */
  value_t ind;

  pic_memcpy_params_get(pf, params);
  sign = pic_var_sign_get(pf);
  loop = pic_var_loop_get(pf);
  top  = pfile_label_alloc(pf, 0);
  ind  = pic_indirect_get(pf, PFILE_LOG_ERR, 0);

  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, loop, 0);
  pic_instr_append_label(pf, top);
  /* sign = *src */
  pic_fsr_setup(pf, params[0]);
  pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ind, 0, PIC_OPDST_W);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, sign, 0);
  pic_instr_append_f_d(pf, PIC_OPCODE_INCF, params[0], 0, PIC_OPDST_F);
  /* *dst = sign */
  pic_fsr_setup(pf, params[1]);
  pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, sign, 0, PIC_OPDST_W);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, ind, 0);
  /* test _sign */
  pic_instr_append_f_d(pf, PIC_OPCODE_INCF, params[1], 0, PIC_OPDST_F);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, loop, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, top);
  pic_instr_append(pf, PIC_OPCODE_RETURN);

  value_release(ind);
  pic_var_loop_release(pf, loop);
  pic_var_sign_release(pf, sign);
  pic_memcpy_params_release(pf, params);
  label_release(top);
}

/*
 * NAME
 *   pic_stkpush_create
 *
 * DESCRIPTION
 *   create the stack push function
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 *   entry
 *     _pic_memcpy_src = src
 *     w               = size
 *   function
 *     stkptr -= w
 *     _pic_memcpy_dst = stkptr
 *     goto memcpy
 */
static void pic_stkpush_create(pfile_t *pf)
{
  value_t memcpy_params[2];

  value_t stkptr; /* stack pointer      */
  value_t loop;   /* temp storage for w */
  label_t pic_memcpy;

  pic_memcpy_params_get(pf, memcpy_params);
  stkptr     = pic_var_stkptr_get(pf);
  loop       = pic_var_loop_get(pf);
  pic_memcpy = pic_label_find(pf, PIC_LABEL_MEMCPY, BOOLEAN_TRUE);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, loop, 0);
  pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, stkptr, 0, PIC_OPDST_F);
  pic_op(pf, OPERATOR_ASSIGN, memcpy_params[1], stkptr, VALUE_NONE);
  pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, loop, 0, PIC_OPDST_W);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, pic_memcpy);
  label_release(pic_memcpy);
  pic_var_loop_release(pf, loop);
  pic_var_stkptr_release(pf, stkptr);
  pic_memcpy_params_release(pf, memcpy_params);
}

/*
 * NAME
 *   pic_stkpop_create
 *
 * DESCRIPTION
 *   create the stack pop function
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 *   entry
 *     pic_memcpy_dst = dst
 *     w              = size
 *   function
 *     pic_memcpy_src = stkptr
 *     call memcpy
 *     stkptr += w
 *   nb: stkptr must be incremented *after* the memcpy to protect against
 *       interruption
 */
static void pic_stkpop_create(pfile_t *pf)
{
  value_t memcpy_params[2];
  value_t loop_tmp;
  value_t stkptr; /* stack pointer      */
  label_t pic_memcpy;

  pic_memcpy_params_get(pf, memcpy_params);
  loop_tmp   = pic_var_loop_tmp_get(pf);
  stkptr     = pic_var_stkptr_get(pf);
  pic_memcpy = pic_label_find(pf, PIC_LABEL_MEMCPY, BOOLEAN_TRUE);

  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, loop_tmp, 0);
  pic_op(pf, OPERATOR_ASSIGN, memcpy_params[0], stkptr, VALUE_NONE);
  pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, loop_tmp, 0, PIC_OPDST_W);
  pic_instr_append_n(pf, PIC_OPCODE_CALL, pic_memcpy);
  pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, loop_tmp, 0, PIC_OPDST_W);
  pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, stkptr, 0, PIC_OPDST_F);
  pic_instr_append(pf, PIC_OPCODE_RETURN);
  label_release(pic_memcpy);
  pic_var_stkptr_release(pf, stkptr);
  pic_var_loop_tmp_release(pf, loop_tmp);
  pic_memcpy_params_release(pf, memcpy_params);
}

/*
 * NAME
 *   pic_indirect_create
 *
 * DESCRIPTION
 *   create the indirect call routine  
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 *   entry:
 *     _pointer[0] holds LSB
 *     _pointer[1] holds SB
 *     W           holds MSB
 *   This simply puts W into _pcl which executes a jump to _pclath:_pcl
 *   It needs to be its own function because the return value needs
 *   to be put onto the stack.
 */
static void pic_indirect_create(pfile_t *pf)
{
  value_t            lsb;
  static const char *names[] = { "_pcl", "_pclath", "_pclatu" };
  variable_sz_t      ii;

  lsb = pic_var_pointer_get(pf);
  for (ii = pic_pointer_size_get(pf); ii > 0; ii--) {
    if (ii < pic_pointer_size_get(pf)) {
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, lsb, ii - 1, PIC_OPDST_W);
    }
    pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, names[ii - 1]);
  }
  pic_var_pointer_release(pf, lsb);
}

/*
 * NAME
 *   pic_task_start_create
 *
 * DESCRIPTION
 *   create the task start procedure
 *
 * PARAMETERS
 *   task_ptr[0]      holds base
 *   task_ptr[1] or W holds HIGH
 *   task_ptr[2] or W holds UPPER
 *
 * RETURN
 *   none
 *
 * NOTES
 *   basically:
 *   LOOP task_ct USING task_idx LOOP
 *     IF 0 == task_list[task_idx] THEN
 *       task_list[task_idx] = entry
 *       RETURN
 *     END IF
 *   END_LOOP
 */
static void pic_task_start_create(pfile_t *pf)
{
  value_t       idx;
  value_t       task_list;
  value_t       task_ptr;
  label_t       lbl_top;
  label_t       lbl_found;
  variable_ct_t task_ct;
  value_t       fsr;
  value_t       ind;
  variable_sz_t ii;

  fsr       = pic_fsr_get(pf);
  task_ct   = pfile_task_ct_get(pf);
  if (task_ct < 2) {
    pfile_log(pf, PFILE_LOG_ERR, "task count must be >= 2!");
    task_ct = 2;
  }

  task_list = pfile_value_find(pf, PFILE_LOG_NONE, "_task_list");
  if (VALUE_NONE == task_list) {
    variable_def_t def;
    variable_def_t vdef;
    value_t        task_active;

    vdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
        VARIABLE_DEF_FLAG_NONE, pic_pointer_size_get(pf));
    def  = variable_def_alloc(0, VARIABLE_DEF_TYPE_ARRAY,
        VARIABLE_DEF_FLAG_NONE, 0);
    variable_def_member_add(def, 0, vdef, task_ct);

    task_list = VALUE_NONE;
    pfile_value_alloc(pf, PFILE_VARIABLE_ALLOC_GLOBAL, "_task_list", 
        def, &task_list);
    variable_flag_set(value_variable_get(task_list), VARIABLE_FLAG_AUTO);
    /* also, allocate _task_active */
    def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
        VARIABLE_DEF_FLAG_NONE, 1);
    task_active = VALUE_NONE;
    pfile_value_alloc(pf, PFILE_VARIABLE_ALLOC_GLOBAL, "_task_active",
        def, &task_active);
    variable_flag_set(value_variable_get(task_active), VARIABLE_FLAG_AUTO);
    value_release(task_active);
  }

  idx      = pic_var_loop_get(pf);
  task_ptr = pic_var_task_ptr_get(pf);
  ind      = pic_indirect_get(pf, PFILE_LOG_ERR, 0);

  /* store W as it will be destroyed */
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, task_ptr, 
    value_sz_get(task_ptr) - 1);
  /* find an empty slot */
  pic_indirect_setup(pf, task_list, pic_pointer_size_get(pf) * task_ct - 1);
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, task_ct);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, idx, 0);
  lbl_top = pfile_label_alloc(pf, 0);
  lbl_found = pfile_label_alloc(pf, 0);
  pic_instr_append_label(pf, lbl_top);
  for (ii = 0; ii < pic_pointer_size_get(pf); ii++) {
    if (ii) {
      pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
      pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, ind, 0, PIC_OPDST_W);
    } else {
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ind, 0, PIC_OPDST_W);
    }
  }
  pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_found);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, idx, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_top);
  pic_instr_append(pf, PIC_OPCODE_RETURN); /* nothing empty, ignore */
  pic_instr_append_label(pf, lbl_found);
  for (ii = 0; ii < pic_pointer_size_get(pf); ii++) {
    if (ii) {
      pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, PIC_OPDST_F);
    }
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, task_ptr, ii, PIC_OPDST_W);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, ind, 0);
  }
  pic_instr_append(pf, PIC_OPCODE_RETURN);

  label_release(lbl_found);
  label_release(lbl_top);

  value_release(ind);
  pic_var_task_ptr_release(pf, task_ptr);
  pic_var_loop_release(pf, idx);
  value_release(task_list);
  value_release(fsr);
}

/*
 * NAME
 *   pic_task_kill_create
 *
 * DESCRIPTION
 *   create the pic_task_kill function
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   none
 *
 * NOTES
 *   on entry, W holds the task ID. 
 *   basically:
 *     _task_active = W
 *     _task_list[_task_active] = 0
 *     suspend
 */
static void pic_task_kill_create(pfile_t *pf)
{
  value_t task_active;

  task_active = pfile_value_find(pf, PFILE_LOG_ERR, "_task_active");
  pic_op(pf, OPERATOR_ASSIGN, task_active, VALUE_NONE, VALUE_NONE);
  value_release(task_active);
  label_release(pic_label_find(pf, PIC_LABEL_TASK_SUICIDE, BOOLEAN_TRUE));
}

static void pic_task_suicide_create(pfile_t *pf)
{
  value_t       task_ptr;
  variable_sz_t ii;

  task_ptr = pic_var_task_ptr_get(pf);
  for (ii = 0; ii < value_sz_get(task_ptr) - 1; ii++) {
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, task_ptr, ii);
  }
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
  /* fall through to suspend! */
  pic_var_task_ptr_release(pf, task_ptr);
  label_release(pic_label_find(pf, PIC_LABEL_TASK_SUSPEND, BOOLEAN_TRUE));
}

/*
 * NAME
 *   pic_task_suspend_create
 *
 * DESCRIPTION
 *   suspend the current task
 *
 * PARAMETERS
 *   task_ptr[0]      holds the base of the next instruction for this task
 *   task_ptr[1] or W holds the HIGH of the next instruction for this task
 *   task_ptr[2] or W holds the UPPER of the next instruction for this task
 *
 * RETURN
 *   none
 *
 * NOTES
 *   basically:
 *      task_list[task_idx] = ptr
 *      FOREVER LOOP
 *        IF (0 == task_idx) THEN
 *          task_idx = task_ct
 *        END IF
 *        task_idx--
 *        IF (task_list[task_idx]) THEN
 *          GOTO task_list[task_idx]
 *        END IF
 *      END LOOP

 *   LOOP task_ct USING task_idx LOOP
 *     IF 0 == task_list[task_idx] THEN
 *       task_list[task_idx] = entry
 *       RETURN
 *     END IF
 *   END_LOOP
 *
 * Note2: to kill a task, suspend with the lsb/msb of 0
 */
static void pic_task_suspend_create(pfile_t *pf)
{
  value_t       idx;
  value_t       task_list;
  value_t       task_ptr;
  unsigned      task_ct;
  label_t       lbl_top;
  label_t       lbl_skip;
  value_t       task_idx;
  value_t       fsr;
  value_t       ind;
  variable_sz_t ii;

  fsr       = pic_fsr_get(pf);
  task_ct   = pfile_task_ct_get(pf);
  task_list = pfile_value_find(pf, PFILE_LOG_ERR, "_task_list");
  task_idx  = pfile_value_find(pf, PFILE_LOG_ERR, "_task_active");
  idx       = pic_var_loop_get(pf);
  task_ptr  = pic_var_task_ptr_get(pf);
  ind       = pic_indirect_get(pf, PFILE_LOG_ERR, 0);
  lbl_top   = pfile_label_alloc(pf, 0);
  lbl_skip  = pfile_label_alloc(pf, 0);

  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, task_ptr,
    value_sz_get(task_ptr) - 1);
  pic_indirect_setup(pf, task_list, 0);

  /* store the return address */
  pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, task_idx, 0, PIC_OPDST_W);
  for (ii = 0; ii < pic_pointer_size_get(pf); ii++) {
    pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, fsr, 0, PIC_OPDST_F);
  }
  for (ii = 0; ii < pic_pointer_size_get(pf); ii++) {
    if (ii) {
      pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, PIC_OPDST_F);
    }
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, task_ptr, ii, PIC_OPDST_W);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, ind, 0);
  }
  for (ii = 1; ii < pic_pointer_size_get(pf); ii++) {
    pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
  }
  /* find an active task */
  pic_instr_append_label(pf, lbl_top);
  pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, task_idx, 0, PIC_OPDST_F);
  pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_skip);
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, task_ct);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, task_idx, 0);
  for (ii = 0; ii < pic_pointer_size_get(pf); ii++) {
    pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, fsr, 0, PIC_OPDST_F);
  }
  pic_instr_append_label(pf, lbl_skip);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECF, task_idx, 0, PIC_OPDST_F);
  for (ii = 0; ii < pic_pointer_size_get(pf); ii++) {
    pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, (0 == ii) ? PIC_OPCODE_MOVF : PIC_OPCODE_IORWF, 
      ind, 0, PIC_OPDST_W);
  }
  pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_top);
  /* jump to the active task */
  if (pic_is_16bit(pf)) {
    pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ind, 0, PIC_OPDST_W);
    pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_pclatu");
    pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ind, 0, PIC_OPDST_W);
    pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_pclath");
    pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ind, 0, PIC_OPDST_W);
    pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_pcl");
  } else {
    pic_instr_append_f_d(pf, PIC_OPCODE_INCF, fsr, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ind, 0, PIC_OPDST_W);
    pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_pclath");
    pic_instr_append_f_d(pf, PIC_OPCODE_DECF, fsr, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ind, 0, PIC_OPDST_W);
    pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_pcl");
  }

  label_release(lbl_skip);
  label_release(lbl_top);

  value_release(ind);
  pic_var_task_ptr_release(pf, task_ptr);
  pic_var_loop_release(pf, idx);
  value_release(task_idx);
  value_release(task_list);
  value_release(fsr);
}

/*
 * pic_pointer_read_create
 *   when called, _pic_pointer holds the location to read
 *   on exit, W holds the result (_pic_pointer is unchanged)
 * the top two bits in the pointer are (MSB on left):
 *   0 0 : data pointer
 *   0 1 : lookup table
 *   1 0 : eeprom
 *   1 1 : flash
 */
static void pic_pointer_read_create(pfile_t *pf)
{
  value_t  ptr;
  value_t  pic_sign;
  label_t  lbl_eeprom_or_flash;
  label_t  lbl_lookup;
  label_t  lbl_pic_indirect;
  value_t  ind;
  size_t   msb;

  ptr      = pic_var_pointer_get(pf);
  pic_sign = pic_var_sign_get(pf);
  ind      = pic_indirect_get(pf, PFILE_LOG_ERR, 0);
  lbl_eeprom_or_flash = pfile_label_alloc(pf, 0);
  lbl_lookup = pfile_label_alloc(pf, 0);
  lbl_pic_indirect = pic_label_find(pf, PIC_LABEL_INDIRECT, BOOLEAN_TRUE);

  msb = pic_pointer_size_get(pf) - 1;

  pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, ptr, msb, 7);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_eeprom_or_flash);
  pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, ptr, msb, 6);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_lookup);
  /* _pic_pointer points to data */
#if 0
  pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ptr, 0, PIC_OPDST_W);
  pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, "_fsr");
  pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_irp");
  pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, ptr, 1, 0);
  pic_instr_append_reg_flag(pf, PIC_OPCODE_BSF, "_status", "_irp");
#else
  pic_fsr_setup(pf, ptr);
#endif
  pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ind, 0, PIC_OPDST_W);
  pic_instr_append(pf, PIC_OPCODE_RETURN);
  /* _pic_pointer points to lookup */
  pic_instr_append_label(pf, lbl_lookup);
  if (pic_is_16bit(pf)) {
    /* do a simple lookup */
    size_t  ii;
    value_t tmp;

    /* setup the table pointer */
    tmp = pfile_value_find(pf, PFILE_LOG_ERR, "_tblptr");
    pic_stvar_tblptr_mark(pf);
    for (ii = 0; ii < 3; ii++) {
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ptr, ii, PIC_OPDST_W);
      if (2 == ii) {
        /* mask off the high two bits */
        pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, (~0xc0) & 0xff);
      }
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, tmp, ii);
    }
    value_release(tmp);
    /* latch the value */
    pic_instr_append_w_kn(pf, PIC_OPCODE_TBLRD, PIC_TBLPTR_CHANGE_NONE);
    /* read the value */
    tmp = pfile_value_find(pf, PFILE_LOG_ERR, "_tablat");
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, tmp, 0, PIC_OPDST_W);
    value_release(tmp);
    /* return */
    pic_instr_append(pf, PIC_OPCODE_RETURN);
  } else {
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ptr, 0, PIC_OPDST_W);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, pic_sign, 0);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, ptr, 1, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, (~(0x80 | 0x40)) & 0xff);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_pic_indirect);
  }
  /* _pic_pointer points to either EEPROM or FLASH (not supported yet) */
  pic_instr_append_label(pf, lbl_eeprom_or_flash);
  pic_instr_append(pf, PIC_OPCODE_RETURN);
  label_release(lbl_pic_indirect);
  label_release(lbl_lookup);
  label_release(lbl_eeprom_or_flash);
  value_release(ind);
  pic_var_sign_release(pf, pic_sign);
  pic_var_pointer_release(pf, ptr);
}

/*
 * all floating point functions take two parameters
 * in _pic_fval1 and _pic_fval2
 * and leave the result in _pic_fval1
 */
static boolean_t pic_is_float_supported(pfile_t *pf)
{
  boolean_t        ret;
  static boolean_t reported; /* only report this once */

  ret = BOOLEAN_TRUE;
  if (!reported && pic_is_12bit(pf)) {
    pfile_log(pf, PFILE_LOG_ERR, 
      "Floating point is not supported on this chip.");
    ret = BOOLEAN_FALSE;
    reported = BOOLEAN_TRUE;
  }
  return ret;
}

/*
 * subtract -- simply invert the sign of _pic_fval2, then
 *             fall through to add
 */
static void pic_float_sub_create(pfile_t *pf)
{
  if (pic_is_float_supported(pf)) {
    pic_var_float_t vals;
    label_t         lbl_add;

    lbl_add = pic_label_find(pf, PIC_LABEL_FLOAT_ADD, BOOLEAN_TRUE);
    label_release(lbl_add);

    pic_var_float_get(pf, &vals);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0x80);
    pic_instr_append_f_d(pf, PIC_OPCODE_XORWF, vals.fval2, 3, PIC_OPDST_F);
  }
}

/*
 * add
 */
static void pic_float_add_create(pfile_t *pf)
{
  if (pic_is_float_supported(pf)) {
    pic_var_float_t vals;
    label_t         lbl;
    label_t         lbl_no_adjust;
    unsigned        ii;
    value_t         dval1; /* overlay a BYTE*3 on the mantissa */
    value_t         dval2; /* overlay a BYTE*3 on the mantissa */
    label_t         lbl_loop_cmp;
    label_t         lbl_loop_top;
    label_t         lbl_normalize;
    label_t         lbl_same_sign;
    label_t         lbl_doit;
    variable_def_t  def;

    pic_var_float_get(pf, &vals);
    dval1 = value_alloc(value_variable_get(vals.fval1));
    dval2 = value_alloc(value_variable_get(vals.fval2));
    def   = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
      VARIABLE_DEF_FLAG_NONE, 3);
    value_def_set(dval1, def);
    value_def_set(dval2, def);
    lbl = pfile_label_alloc(pf, 0);
    /* fval1 exponent --> W */
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, vals.fval1, 2, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, vals.fval1, 3, PIC_OPDST_W);
    /* If zero, result = fval2 */
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xff);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    for (ii = 0; ii < 4; ii++) {
      pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, vals.fval2, ii, PIC_OPDST_W);
      pic_instr_append_f(pf, PIC_OPCODE_MOVWF, vals.fval1, ii);
    }
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    /* store the exponent */
    pic_instr_append_label(pf, lbl);
    label_release(lbl);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, vals.exp1, 0);
    /* fval2 exponent --> W */
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, vals.fval2, 2, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, vals.fval2, 3, PIC_OPDST_W);
    /* if zero, done! */
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xff);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    /* store the exponent */
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, vals.exp2, 0);
    /* check the difference in exponents. */
    pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, vals.exp1, 0, PIC_OPDST_W);
    /* if zero, no adjustment necessary to skip this. */
    lbl_no_adjust = pfile_label_alloc(pf, 0);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_no_adjust);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_c");
    lbl = pfile_label_alloc(pf, 0);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    /*
     * exp1 > exp2; if the difference is > 23, the result is val1
     * (val2 will be shifted out of existence)
     */
    pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, -23);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    /* denormalize fval2 */
    /* return the `hidden' bits */
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, vals.fval1, 2, 7);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, vals.fval2, 2, 7);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, 23);
    lbl_loop_top = pfile_label_alloc(pf, 0);
    pic_instr_append_label(pf, lbl_loop_top);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, vals.fval2, 2, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, vals.fval2, 1, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, vals.fval2, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_INCF, vals.exp2, 0, PIC_OPDST_F);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, 0xff);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_loop_top);
    label_release(lbl_loop_top);
    lbl_doit = pfile_label_alloc(pf, 0);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_doit);
    /*
     * exp2 > exp1; if the difference > 23, the result is val2
     * (val1 will be shifted out of existence)
     */
    pic_instr_append_label(pf, lbl);
    label_release(lbl);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, vals.exp1, 0, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, vals.exp2, 0, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, -23);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_c");
    lbl = pfile_label_alloc(pf, 0);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    pic_op(pf, OPERATOR_ASSIGN, vals.fval1, vals.fval2, VALUE_NONE);
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    /* denormalize fval1 */
    /* return the `hidden' bits */
    pic_instr_append_label(pf, lbl);
    label_release(lbl);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, vals.fval1, 2, 7);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, vals.fval2, 2, 7);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, 23);
    lbl_loop_top = pfile_label_alloc(pf, 0);
    pic_instr_append_label(pf, lbl_loop_top);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, vals.fval1, 2, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, vals.fval1, 1, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, vals.fval1, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_INCF, vals.exp1, 0, PIC_OPDST_F);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, 0xff);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_loop_top);
    label_release(lbl_loop_top);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_doit);

    pic_instr_append_label(pf, lbl_no_adjust);
    label_release(lbl_no_adjust);
    /* return the `hidden' bits */
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, vals.fval1, 2, 7);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, vals.fval2, 2, 7);
    /* determine if the signs are the same */
    pic_instr_append_label(pf, lbl_doit);
    label_release(lbl_doit);
    lbl = pfile_label_alloc(pf, 0);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, vals.fval1, 3, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_XORWF, vals.fval2, 3, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x80);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    /* fval2 = -fval2 */
    pic_op(pf, OPERATOR_NEG, dval2, VALUE_NONE, VALUE_NONE);
    /* add the mantissas */
    pic_instr_append_label(pf, lbl);
    label_release(lbl);
    pic_op(pf, OPERATOR_ADD, dval1, dval2, VALUE_NONE);

    lbl_normalize = pfile_label_alloc(pf, 0);
    /* check if the signs are the same */
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, vals.fval1, 3, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_XORWF, vals.fval2, 3, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x80);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    lbl_same_sign = pfile_label_alloc(pf, 0);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_same_sign);
    /* 
     * signs were different. if overflow:
     * mantissa = -mantissa, and sign = !sign
     */
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_normalize);

    pic_op(pf, OPERATOR_NEG, dval1, VALUE_NONE, VALUE_NONE);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, vals.fval1, 3, PIC_OPDST_W);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, vals.fval1, 3, 7);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x80);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status","_z");
    pic_instr_append_f_bn(pf, PIC_OPCODE_BCF, vals.fval1, 3, 7);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_normalize);
    /* signs were the same. if carrys is set fixup fval1 */
    pic_instr_append_label(pf, lbl_same_sign);
    label_release(lbl_same_sign);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_c");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_normalize);
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, vals.fval1, 2, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, vals.fval1, 1, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, vals.fval1, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_INCF, vals.exp1, 0, PIC_OPDST_F);
    /* normalize the mantissa */
    pic_instr_append_label(pf, lbl_normalize);
    label_release(lbl_normalize);
    /* first check for 0 */
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, vals.fval1, 0, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, vals.fval1, 1, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, vals.fval1, 2, PIC_OPDST_W);
    lbl = pfile_label_alloc(pf, 0);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, vals.fval1, 3);
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    pic_instr_append_label(pf, lbl);
    label_release(lbl);

    lbl_loop_top = pfile_label_alloc(pf, 0);
    lbl_loop_cmp = pfile_label_alloc(pf, 0);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_loop_cmp);
    pic_instr_append_label(pf, lbl_loop_top);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, vals.fval1, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, vals.fval1, 1, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, vals.fval1, 2, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_DECF, vals.exp1, 0, PIC_OPDST_F);
    pic_instr_append_label(pf, lbl_loop_cmp);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, vals.fval1, 2, 7);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_loop_top);
    label_release(lbl_loop_cmp);
    label_release(lbl_loop_top);
    /* clear the `hidden' bit */
    pic_instr_append_f_bn(pf, PIC_OPCODE_BCF, vals.fval1, 2, 7);
    /* mask off the sign bit */
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0x80);
    pic_instr_append_f_d(pf, PIC_OPCODE_ANDWF, vals.fval1, 3, PIC_OPDST_F);
    /* shift the exponent 1 to the right & put in place */
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, vals.exp1, 0, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, vals.fval1, 3, PIC_OPDST_F);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, vals.fval1, 2, 7);
    /* done! */
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    value_release(dval2);
    value_release(dval1);
    pic_var_float_release(pf, &vals);
  }
}

/* signed integer conversion to float */
static void pic_float_sconv_create(pfile_t *pf)
{
  if (pic_is_float_supported(pf)) {
    label_t         lbl_skip;
    value_t         val;
    pic_var_float_t flt;
    label_t         lbl;

    pic_var_float_get(pf, &flt);
    val = pic_var_float_conv_get(pf, -1);
    lbl_skip = pfile_label_alloc(pf, 0);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, val,
      value_sz_get(val) - 1, 7);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_skip);
    pic_op(pf, OPERATOR_NEG, val, val, VALUE_NONE);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, flt.fval1, 3, 7);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0x80);
    pic_instr_append_label(pf, lbl_skip);
    /*
     * this is guaranteed to be clear, we just want to skip the
     * `movlw 0' which begins a normal conversion create
     */
    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, val,
      value_sz_get(val) - 1, 7);
    label_release(lbl_skip);
    value_release(val);
    pic_var_float_release(pf, &flt);
    lbl = pic_label_find(pf, PIC_LABEL_FLOAT_CONV, BOOLEAN_TRUE);
    label_release(lbl);
    /* this will fall through to pic_float_conv_create */
  }
}

/* integer convertion to float */
static void pic_float_conv_create(pfile_t *pf)
{
  if (pic_is_float_supported(pf)) {
    pic_var_float_t flt;
    unsigned        ii;
    label_t         lbl_loop_top;
    label_t         lbl_loop_cmp;
    value_t         src;

    pic_var_float_get(pf, &flt);
    src = pic_var_float_conv_get(pf, -1);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, flt.fval1, 0);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, flt.fval1, 1);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, flt.fval1, 2);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.fval1, 3);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, flt.exp1, 0);

    lbl_loop_top = pfile_label_alloc(pf, 0);
    lbl_loop_cmp = pfile_label_alloc(pf, 0);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_loop_cmp);
    pic_instr_append_label(pf, lbl_loop_top);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    for (ii = value_sz_get(src); ii; ii--) {
      pic_instr_append_f_d(pf, PIC_OPCODE_RRF, src, ii - 1, PIC_OPDST_F);
    }
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, flt.fval1, 2, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, flt.fval1, 1, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, flt.fval1, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
    pic_instr_append_label(pf, lbl_loop_cmp);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, src, 0, PIC_OPDST_W);
    for (ii = 1; ii < value_sz_get(src); ii++) {
      pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, src, ii, PIC_OPDST_W);
    }
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_loop_top);
    label_release(lbl_loop_cmp);
    label_release(lbl_loop_top);
    /* if exp1 is 0, the original value was 0 */
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, flt.exp1, 0, PIC_OPDST_F);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, 0x7e);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
    pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, flt.exp1, 0, PIC_OPDST_F);

    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, flt.exp1, 0, PIC_OPDST_F);
    /* clear the `hidden bit' */
    pic_instr_append_f_bn(pf, PIC_OPCODE_BCF, flt.fval1, 2, 7);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, flt.fval1, 2, 7);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, flt.exp1, 0, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, flt.fval1, 3, PIC_OPDST_F);
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    value_release(src);
    pic_var_float_release(pf, &flt);
  }
}

/* float to integer */
static void pic_float_toint_create(pfile_t *pf)
{
  if (pic_is_float_supported(pf)) {
    value_t         dst;
    pic_var_float_t flt;
    unsigned        ii;
    label_t         lbl;

    pic_var_float_get(pf, &flt);
    dst = pic_var_float_conv_get(pf, -1);
    for (ii = 0; ii < value_sz_get(dst); ii++) {
      pic_instr_append_f(pf, PIC_OPCODE_CLRF, dst, ii);
    }
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval1, 2, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval1, 3, PIC_OPDST_W);
    /* return if exp == 0 */
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xff);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, 0x82);
    /* exp <= 0x7e, return (the answer is 0) */
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_c");
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, flt.fval1, 2, 7);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.exp1, 0);
    lbl = pfile_label_alloc(pf, 0);
    pic_instr_append_label(pf, lbl);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval1, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval1, 1, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval1, 2, PIC_OPDST_F);
    for (ii = 0; ii < value_sz_get(dst); ii++) {
      pic_instr_append_f_d(pf, PIC_OPCODE_RLF, dst, ii, PIC_OPDST_F);
    }
    pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, flt.exp1, 0, PIC_OPDST_F);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    label_release(lbl);
    /* is the sign set? */
    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, flt.fval1, 3, 7);
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    pic_op(pf, OPERATOR_NEG, dst, dst, VALUE_NONE);
    pic_instr_append(pf, PIC_OPCODE_RETURN);

    pic_var_float_conv_release(pf, dst);
    pic_var_float_release(pf, &flt);
  }
}

/* flt.fval1 = flt.fval1 * flt.fval2 */
static void pic_float_multiply_create(pfile_t *pf)
{
  if (pic_is_float_supported(pf)) {
    pic_var_mul_t   mul;
    pic_var_float_t flt;
    label_t         lbl;
    label_t         lbl1;
    label_t         lbl_loop_top;
    value_t         dval1;
    value_t         dval2;
    variable_def_t  def;
    char            mul_name[32];

    pic_var_float_get(pf, &flt);

    dval1 = value_alloc(value_variable_get(flt.fval1));
    dval2 = value_alloc(value_variable_get(flt.fval2));
    def   = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
      VARIABLE_DEF_FLAG_NONE, 3);
    value_def_set(dval1, def);
    value_def_set(dval2, def);
    pic_var_mul_get(pf, 3, 6, &mul);

    /* exp1 = exp1 + exp2 - 127 */
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval1, 2, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval1, 3, PIC_OPDST_W);
    /* if exp1 is 0, simply return (result is 0) */
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xff);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    /* fval1 is 0, return */
    pic_instr_append(pf, PIC_OPCODE_RETURN);

    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.exp1, 0);

    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval2, 2, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval2, 3, PIC_OPDST_W);
    /* if exp2 is 0, clear fval1 & return */
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xff);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSS, "_status", "_z");
    lbl = pfile_label_alloc(pf, 0);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, flt.fval1, 0);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, flt.fval1, 1);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, flt.fval1, 2);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, flt.fval1, 3);
    pic_instr_append(pf, PIC_OPCODE_RETURN);
    pic_instr_append_label(pf, lbl);
    label_release(lbl);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, 0x81); /* - 0x7f */
    pic_instr_append_f_d(pf, PIC_OPCODE_ADDWF, flt.exp1, 0, PIC_OPDST_F);

    /* sign1 = sign1 ^ sign2 */
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, flt.fval2, 3, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_XORWF, flt.fval1, 3, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x80);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.fval1, 3);

    /* set the hidden bit & multiply */
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, flt.fval1, 2, 7);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, flt.fval2, 2, 7);

    pic_op(pf, OPERATOR_ASSIGN, mul.multiplier, dval1, VALUE_NONE);
    pic_op(pf, OPERATOR_ASSIGN, mul.multiplicand, dval2, VALUE_NONE);

    if (pfile_flag_test(pf, PFILE_FLAG_MISC_FASTMATH)) {
      sprintf(mul_name, "%s_3_6", PIC_LABEL_MULTIPLY);
    } else {
      strcpy(mul_name, PIC_LABEL_MULTIPLY);
    }
    lbl = pic_label_find(pf, mul_name, BOOLEAN_TRUE);
    pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl);
    label_release(lbl);

    lbl = pfile_label_alloc(pf, 0);
    lbl1 = pfile_label_alloc(pf, 0);
    lbl_loop_top = pfile_label_alloc(pf, 0);

    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, mul.mresult, 5, 7);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl1);
    pic_instr_append_label(pf, lbl);
    pic_instr_append_f_d(pf, PIC_OPCODE_DECF, flt.exp1, 0, PIC_OPDST_F);
    pic_instr_append_label(pf, lbl_loop_top);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, mul.mresult, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, mul.mresult, 1, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, mul.mresult, 2, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, mul.mresult, 3, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, mul.mresult, 4, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, mul.mresult, 5, PIC_OPDST_F);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, mul.mresult, 5, 7);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_loop_top);
    /* finally, put it all together */
    pic_instr_append_label(pf, lbl1);

    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, mul.mresult, 3, PIC_OPDST_W);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.fval1, 0);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, mul.mresult, 4, PIC_OPDST_W);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.fval1, 1);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, mul.mresult, 5, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x7f);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.fval1, 2);

    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, flt.exp1, 0, PIC_OPDST_W);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, flt.fval1, 2, 7);
    pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, flt.fval1, 3, PIC_OPDST_F);

    label_release(lbl_loop_top);
    label_release(lbl1);
    label_release(lbl);

    pic_instr_append(pf, PIC_OPCODE_RETURN);

    value_release(dval2);
    value_release(dval1);
    pic_var_float_release(pf, &flt);
  }
}

static void pic_float_divide_create(pfile_t *pf)
{
  if (pic_is_float_supported(pf)) {
    pic_var_div_t   divs;
    pic_var_float_t flt;
    label_t         lbl;
    label_t         lbl_done;
    label_t         lbl_loop_top;
    value_t         dval1;
    value_t         dval2;
    variable_def_t  def;

    pic_var_float_get(pf, &flt);
    dval1 = value_alloc(value_variable_get(flt.fval1));
    dval2 = value_alloc(value_variable_get(flt.fval2));
    def   = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
      VARIABLE_DEF_FLAG_NONE, 3);
    value_def_set(dval1, def);
    value_def_set(dval2, def);
    pic_var_div_get(pf, 6, &divs);

    /* exp1 = exp1 + 127 - exp2 */

    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval1, 2, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval1, 3, PIC_OPDST_W);
    /* if exp1 is 0, fval1 is 0 so return */
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xff);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append(pf, PIC_OPCODE_RETURN);

    /* exp1 = exp1 + 127 */
    pic_instr_append_w_kn(pf, PIC_OPCODE_ADDLW, 0x7f);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.exp1, 0);

    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval2, 2, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, flt.fval2, 3, PIC_OPDST_W);
    /* if fval2 is 0 the result is undefined so just return */
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0xff);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_z");
    pic_instr_append(pf, PIC_OPCODE_RETURN);

    /* exp1 = exp1 - exp2 */
    pic_instr_append_f_d(pf, PIC_OPCODE_SUBWF, flt.exp1, 0, PIC_OPDST_F);


    /* sign1 = sign1 ^ sign2 */
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, flt.fval2, 3, PIC_OPDST_W);
    pic_instr_append_f_d(pf, PIC_OPCODE_XORWF, flt.fval1, 3, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x80);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.fval1, 3);

    /* set the hidden bit & divide */
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, flt.fval1, 2, 7);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, flt.fval2, 2, 7);

    pic_instr_append_f(pf, PIC_OPCODE_CLRF, divs.dividend, 0);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, divs.dividend, 1);
    pic_instr_append_f(pf, PIC_OPCODE_CLRF, divs.dividend, 2);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, flt.fval1, 2, PIC_OPDST_W);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, divs.dividend, 5);
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, flt.fval1, 1, PIC_OPDST_W);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, divs.dividend, 4);
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, flt.fval1, 0, PIC_OPDST_W);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, divs.dividend, 3);
    pic_op(pf, OPERATOR_ASSIGN, divs.divisor, dval2, VALUE_NONE);
    lbl = pic_label_find(pf, PIC_LABEL_DIVIDE, BOOLEAN_TRUE);
    pic_instr_append_n(pf, PIC_OPCODE_CALL, lbl);
    label_release(lbl);

    lbl_done = pfile_label_alloc(pf, 0);
    lbl_loop_top = pfile_label_alloc(pf, 0);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSC, divs.quotient, 2, 7);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_done);
    pic_instr_append_f_d(pf, PIC_OPCODE_DECF, flt.exp1, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_DECF, flt.exp1, 0, PIC_OPDST_F);
    pic_instr_append_label(pf, lbl_loop_top);
    pic_instr_append_f_d(pf, PIC_OPCODE_INCF, flt.exp1, 0, PIC_OPDST_F);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, divs.quotient, 0, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, divs.quotient, 1, PIC_OPDST_F);
    pic_instr_append_f_d(pf, PIC_OPCODE_RLF, divs.quotient, 2, PIC_OPDST_F);
    pic_instr_append_f_bn(pf, PIC_OPCODE_BTFSS, divs.quotient, 2, 7);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_loop_top);
    pic_instr_append_label(pf, lbl_done);

    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, divs.quotient, 0, PIC_OPDST_W);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.fval1, 0);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, divs.quotient, 1, PIC_OPDST_W);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.fval1, 1);
    pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, divs.quotient, 2, PIC_OPDST_W);
    pic_instr_append_w_kn(pf, PIC_OPCODE_ANDLW, 0x7f);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, flt.fval1, 2);

    pic_instr_append_reg_flag(pf, PIC_OPCODE_BCF, "_status", "_c");
    pic_instr_append_f_d(pf, PIC_OPCODE_RRF, flt.exp1, 0, PIC_OPDST_W);
    pic_instr_append_reg_flag(pf, PIC_OPCODE_BTFSC, "_status", "_c");
    pic_instr_append_f_bn(pf, PIC_OPCODE_BSF, flt.fval1, 2, 7);
    pic_instr_append_f_d(pf, PIC_OPCODE_IORWF, flt.fval1, 3, PIC_OPDST_F);

    label_release(lbl_loop_top);
    label_release(lbl_done);

    pic_instr_append(pf, PIC_OPCODE_RETURN);

    pic_var_div_release(pf, &divs);
    value_release(dval2);
    value_release(dval1);
    pic_var_float_release(pf, &flt);
  }
}

/*
 * NAME
 *   pic_intrinsics_create 
 *
 * DESCRIPTION
 *   create the intrinsic
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   none
 *
 * NOTES
 *   the functions are created if any references exist
 *   make sure to update the static table for any other intrinsice
 */
/* nb: this table is somewhat order dependent. if an intrinsic
       relies on another one, it should come *before* the other
       one to guarentee both are generated */
static const struct {
  const char *tag;
  void (*fn)(pfile_t *);
} intrinsics[] = {
  {PIC_LABEL_STKPUSH,        pic_stkpush_create},
  {PIC_LABEL_STKPOP,         pic_stkpop_create},
  /*{PIC_LABEL_MULTIPLY,     pic_multiply_create},*/
  {PIC_LABEL_SDIVIDE,        pic_sdivide_create},
  {PIC_LABEL_DIVIDE,         pic_divide_create},
  {PIC_LABEL_MEMSET,         pic_memset_create},
  {PIC_LABEL_MEMCPY,         pic_memcpy_create},
  {PIC_LABEL_MEMCMP,         pic_memcmp_create},
  /* {PIC_LABEL_PTR_WRITE,    pic_pointer_write_create}, */
  {PIC_LABEL_PTR_READ,       pic_pointer_read_create},
  {PIC_LABEL_INDIRECT,       pic_indirect_create},
  {PIC_LABEL_TASK_START,     pic_task_start_create},
  /* KILL/SUICIDE/SUSPEND must come in this order! */
  {PIC_LABEL_TASK_KILL,      pic_task_kill_create},
  {PIC_LABEL_TASK_SUICIDE,   pic_task_suicide_create},
  {PIC_LABEL_TASK_SUSPEND,   pic_task_suspend_create},
  /* floating point functions */
  /* SUB + ADD must go in this order */
  {PIC_LABEL_FLOAT_SUB,      pic_float_sub_create},
  {PIC_LABEL_FLOAT_ADD,      pic_float_add_create},
  {PIC_LABEL_FLOAT_MULTIPLY, pic_float_multiply_create},
  {PIC_LABEL_FLOAT_DIVIDE,   pic_float_divide_create},
  {PIC_LABEL_FLOAT_SCONV,    pic_float_sconv_create},
  {PIC_LABEL_FLOAT_CONV,     pic_float_conv_create},
  {PIC_LABEL_FLOAT_TOINT,    pic_float_toint_create}
};

void pic_intrinsics_create(pfile_t *pf)
{
  size_t  ii;

  pic_multiply_create(pf);
  for (ii = 0; ii < COUNT(intrinsics); ii++) {
    label_t lbl;

    lbl = pfile_label_find(pf, PFILE_LOG_NONE, intrinsics[ii].tag);
    if (lbl) {
      if (pic_divide_create != intrinsics[ii].fn) {
        pic_instr_append_label(pf, lbl);
      }
      label_release(lbl);
      intrinsics[ii].fn(pf);
    }
  }
}

boolean_t pic_intrinsics_exist(pfile_t *pf)
{
  label_t lbl;
  size_t  ii;
  const pfile_multiply_width_table_entry_t *mw;

  for (ii = 0, lbl = LABEL_NONE; !lbl && (ii < COUNT(intrinsics)); ii++) {
    lbl = pfile_label_find(pf, PFILE_LOG_NONE, intrinsics[ii].tag);
    if (lbl) {
      label_release(lbl);
    }
  }
  for (ii = 0;
       (LABEL_NONE == lbl)
       && (0 != (mw = pfile_multiply_width_table_entry_get(pf, ii)));
       ii++) {
    char label[32];

    sprintf(label, "%s_%u_%u", PIC_LABEL_MULTIPLY, mw->multiplier,
        mw->multiplicand);
    lbl = pfile_label_find(pf, PFILE_LOG_NONE, label);
    if (lbl) {
      label_release(lbl);
    }
  }
  if (LABEL_NONE == lbl) {
    lbl = pfile_label_find(pf, PFILE_LOG_NONE, PIC_LABEL_MULTIPLY);
    if (lbl) {
      label_release(lbl);
    }
  }
      
  return (LABEL_NONE != lbl);
}


