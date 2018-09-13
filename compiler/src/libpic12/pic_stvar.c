/************************************************************
 **
 ** pic_stvar.c : pic state variable maintainence
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/

/*
 * The PIC state variables are as follows:
 *   _pic_state -- this contains the values needed for temporary
 *                 storage, multiplication, division, intrinsic
 *                 parameters and indirect parameters
 *                   struct _pic_state_ {
 *                     loop      : used for internal looping (shift, mul, div)
 *                     sign      : used for sign extension
 *                     stack_ptr : holds the stack pointer for recursion
 *                     union {
 *                       temp : used when an operation occurs over two
 *                              arrays, or to hold the parameters for
 *                              intrinsics (memset, memcpy, memcmp, ...)
 *                              or for indirect parameter passing
 *                       struct {
 *                         multiplier
 *                         multiplicand
 *                         mresult
 *                       } mul;
 *                       struct {
 *                         dividend
 *                         divisor
 *                         quotient
 *                         remainder
 *                       } div;
 *  _pic_istate -- holds a copy of pic_state while in an interrupt
 *                 currently holds a *complete* copy, but in the future
 *                 should only holds as much as is needed
 *  _pic_isr_w      -- must be shared or allocated in all banks
 *  _pic_isr_status -- must be allocated in the first bank
 *  _pic_isr_pclath -- must be allocated in the first bank
 */
#include <stddef.h>
#include <assert.h>
#include "../libcore/pf_proc.h"
#include "../libcore/pf_expr.h"
#include "pic_op.h"
#include "pic_var.h"
#include "pic_inst.h"
#include "pic_stvar.h"

#define PIC_STVAR_FLAG_NONE     0x0000
#define PIC_STVAR_FLAG_ACCUM    0x0001
#define PIC_STVAR_FLAG_LOOP     0x0002
#define PIC_STVAR_FLAG_LOOP_TMP 0x0004
#define PIC_STVAR_FLAG_SIGN     0x0008
#define PIC_STVAR_FLAG_POINTER  0x0010
#define PIC_STVAR_FLAG_MULTIPLY 0x0020
#define PIC_STVAR_FLAG_DIVIDE   0x0040
#define PIC_STVAR_FLAG_MEMCPY   0x0080
#define PIC_STVAR_FLAG_TASK_PTR 0x0100
#define PIC_STVAR_FLAG_STKPTR   0x0200
#define PIC_STVAR_FLAG_FSR      0x0400
#define PIC_STVAR_FLAG_TBLPTR   0x0800
#define PIC_STVAR_FLAG_FLOAT    0x1000

static unsigned stvar_flags; /* make sure two routines don't both
                                grab the same variable! */
static struct {
  unsigned      var_flags;    /* flags used by the ISR     */
  variable_sz_t temp_size;    /* max. size used by the ISR */
} isr_info;

static size_t pic_divide_size;   /* # of bytes needed for divide vars   */

static variable_t pic_var_state_var_get(pfile_t *pf)
{
  variable_t var;

  var = pfile_variable_find(pf, PFILE_LOG_NONE, "_pic_state", 0);
  if (!var) {
    pfile_variable_alloc(pf, PFILE_VARIABLE_ALLOC_GLOBAL,
      "_pic_state", VARIABLE_DEF_NONE, VARIABLE_NONE, &var);
  }
  return var;
}

/*
 * NAME
 *   pic_var_value_get
 *
 * DESCRIPTION
 *   get the named value; allocate if necessary
 *
 * PARAMETERS
 *   pf   : pfile handle
 *   name :
 *   type :
 *   sz   :
 *
 * RETURN
 *   value
 *
 * NOTES
 *   the value's size can be reset here; the act of getting a value
 *   bumps the assign & usage count so it will be allocated later!
 */
static value_t pic_var_value_get(pfile_t *pf, const char *name,
    variable_def_type_t type, variable_sz_t sz)
{
  value_t val;

  val = pfile_value_find(pf, PFILE_LOG_NONE, name);
  if (!val && ((variable_sz_t) -1 != sz)) {
    variable_t     var;
    variable_def_t def;

    def    = variable_def_alloc(0, type, VARIABLE_DEF_FLAG_NONE, sz);
    pfile_variable_alloc(pf, PFILE_VARIABLE_ALLOC_GLOBAL, name, def, 
      VARIABLE_NONE, &var);
    val = value_alloc(var);
    variable_release(var);
  }
  if (val) {
    /*assert(value_type_get(val) == type);*/
    if ((value_type_get(val) != type)
      || ((((variable_sz_t) -1) != sz) && (value_sz_get(val) != sz))) {
      variable_def_t def;

      def = variable_def_alloc(0, type, VARIABLE_DEF_FLAG_NONE, sz);
      if (sz > value_sz_get(val)) {
        variable_def_set(value_variable_get(val), def);
      }
      value_def_set(val, def);
    }
  }
  return val;
}

value_t pic_var_task_ptr_get(pfile_t *pf)
{
  assert(!(stvar_flags & PIC_STVAR_FLAG_TASK_PTR));
  stvar_flags |= PIC_STVAR_FLAG_TASK_PTR;
  if (pic_in_isr(pf)) {
    isr_info.var_flags |= PIC_STVAR_FLAG_TASK_PTR;
  }

  return pic_var_value_get(pf, "_pic_task_ptr", VARIABLE_DEF_TYPE_INTEGER, 
    pic_pointer_size_get(pf));
}

void pic_var_task_ptr_release(pfile_t *pf, value_t val)
{
  UNUSED(pf);
  assert(stvar_flags & PIC_STVAR_FLAG_TASK_PTR);
  stvar_flags &= ~PIC_STVAR_FLAG_TASK_PTR;
  value_release(val);
}

value_t pic_var_loop_get(pfile_t *pf)
{
  assert(!(stvar_flags & PIC_STVAR_FLAG_LOOP));
  stvar_flags |= PIC_STVAR_FLAG_LOOP;
  if (pic_in_isr(pf)) {
    isr_info.var_flags |= PIC_STVAR_FLAG_LOOP;
    value_release(pic_var_value_get(pf, "_pic_isr_loop", VARIABLE_DEF_TYPE_INTEGER,
      1));
  }

  return pic_var_value_get(pf, "_pic_loop", VARIABLE_DEF_TYPE_INTEGER, 1);
}

void pic_var_loop_release(pfile_t *pf, value_t val)
{
  UNUSED(pf);
  assert(stvar_flags & PIC_STVAR_FLAG_LOOP);
  stvar_flags &= ~PIC_STVAR_FLAG_LOOP;
  value_release(val);
}

value_t pic_var_loop_tmp_get(pfile_t *pf)
{
  assert(!(stvar_flags & PIC_STVAR_FLAG_LOOP_TMP));
  stvar_flags |= PIC_STVAR_FLAG_LOOP_TMP;
  if (pic_in_isr(pf)) {
    isr_info.var_flags |= PIC_STVAR_FLAG_LOOP_TMP;
  }
  return pic_var_value_get(pf, "_pic_loop_tmp", VARIABLE_DEF_TYPE_INTEGER, 1);
}

void pic_var_loop_tmp_release(pfile_t *pf, value_t val)
{
  UNUSED(pf);
  assert(stvar_flags & PIC_STVAR_FLAG_LOOP_TMP);
  stvar_flags &= ~PIC_STVAR_FLAG_LOOP_TMP;
  value_release(val);
}

value_t pic_var_sign_get(pfile_t *pf)
{
  assert(!(stvar_flags & PIC_STVAR_FLAG_SIGN));
  stvar_flags |= PIC_STVAR_FLAG_SIGN;
  if (pic_in_isr(pf)) {
    isr_info.var_flags |= PIC_STVAR_FLAG_SIGN;
    value_release(pic_var_value_get(pf, "_pic_isr_sign",
      VARIABLE_DEF_TYPE_INTEGER, 1));
  }
  return pic_var_value_get(pf, "_pic_sign", VARIABLE_DEF_TYPE_INTEGER, 1);
}

void pic_var_sign_release(pfile_t *pf, value_t val)
{
  UNUSED(pf);
  assert(stvar_flags & PIC_STVAR_FLAG_SIGN);
  stvar_flags &= ~PIC_STVAR_FLAG_SIGN;
  value_release(val);
}

value_t pic_var_accum_get(pfile_t *pf)
{
  assert(!(stvar_flags & PIC_STVAR_FLAG_ACCUM));
  stvar_flags |= PIC_STVAR_FLAG_ACCUM;
  if (pic_in_isr(pf)) {
    isr_info.var_flags |= PIC_STVAR_FLAG_ACCUM;
    value_release(pic_var_value_get(pf, "_pic_isr_accum",
      VARIABLE_DEF_TYPE_INTEGER, 1));
  }
  return pfile_value_find(pf, PFILE_LOG_ERR, "_pic_accum");
}

void pic_var_accum_release(pfile_t *pf, value_t val)
{
  UNUSED(pf);
  assert(stvar_flags & PIC_STVAR_FLAG_ACCUM);
  stvar_flags &= ~PIC_STVAR_FLAG_ACCUM;
  value_release(val);
}

value_t pic_var_pointer_get(pfile_t *pf)
{
  assert(!(stvar_flags & PIC_STVAR_FLAG_POINTER));
  stvar_flags |= PIC_STVAR_FLAG_POINTER;
  if (pic_in_isr(pf)) {
    isr_info.var_flags |= PIC_STVAR_FLAG_POINTER;
    value_release(pic_var_value_get(pf, "_pic_isr_pointer",
      VARIABLE_DEF_TYPE_INTEGER, 1));
  }
  return pic_var_value_get(pf, "_pic_pointer", VARIABLE_DEF_TYPE_INTEGER,
    pic_pointer_size_get(pf));
}

void pic_var_pointer_release(pfile_t *pf, value_t val)
{
  UNUSED(pf);
  assert(stvar_flags & PIC_STVAR_FLAG_POINTER);
  stvar_flags &= ~PIC_STVAR_FLAG_POINTER;
  value_release(val);
}

boolean_t pic_memcpy_params_get(pfile_t *pf, value_t *params)
{
  assert(!(stvar_flags & PIC_STVAR_FLAG_MEMCPY));
  stvar_flags |= PIC_STVAR_FLAG_MEMCPY;
  if (pic_in_isr(pf)) {
    isr_info.var_flags |= PIC_STVAR_FLAG_MEMCPY;
  }
  params[0] = pic_var_value_get(pf, "_pic_memcpy_src",
      VARIABLE_DEF_TYPE_INTEGER, 2);
  params[1] = pic_var_value_get(pf, "_pic_memcpy_dst",
      VARIABLE_DEF_TYPE_INTEGER, 2);
  return BOOLEAN_TRUE;
}

void pic_memcpy_params_release(pfile_t *pf, value_t *params)
{
  UNUSED(pf);
  assert(stvar_flags & PIC_STVAR_FLAG_MEMCPY);
  stvar_flags &= ~PIC_STVAR_FLAG_MEMCPY;
  value_release(params[1]);
  value_release(params[0]);
}

value_t pic_var_stkptr_get(pfile_t *pf)
{
  assert(!(stvar_flags & PIC_STVAR_FLAG_STKPTR));
  stvar_flags |= PIC_STVAR_FLAG_STKPTR;
  return pic_var_value_get(pf, "_pic_stkptr", VARIABLE_DEF_TYPE_INTEGER, 2);
}

void pic_var_stkptr_release(pfile_t *pf, value_t stkptr)
{
  UNUSED(pf);
  assert(stvar_flags & PIC_STVAR_FLAG_STKPTR);
  stvar_flags &= ~PIC_STVAR_FLAG_STKPTR;
  value_release(stkptr);
}

variable_sz_t pic_temp_sz_in_use;
value_t pic_var_temp_get(pfile_t *pf, flag_t flags, variable_sz_t sz)
{
  value_t        val;

  if (0 == sz) {
    val = VALUE_NONE;
  } else {
    variable_t     var;
    variable_def_t def;

    val = pfile_value_find(pf, PFILE_LOG_NONE, "_pic_temp");
    if (!val) {
      val = pic_var_value_get(pf, "_pic_temp", VARIABLE_DEF_TYPE_INTEGER, sz);
    }
    if (pic_temp_sz_in_use) {
      value_t tmp;

      tmp = pfile_constant_get(pf, pic_temp_sz_in_use, VARIABLE_DEF_NONE);
      value_baseofs_set(val, tmp);
      value_release(tmp);
    }
    pic_temp_sz_in_use += sz;
    if (pic_in_isr(pf) && (isr_info.temp_size < pic_temp_sz_in_use)) {
      isr_info.temp_size = pic_temp_sz_in_use;
    }
    var = value_variable_get(val);
    if (variable_sz_get(var) < pic_temp_sz_in_use) {
      def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER, 
          VARIABLE_DEF_FLAG_NONE, pic_temp_sz_in_use);
      variable_def_set(var, def);
    }
    def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER, 
        flags & VARIABLE_DEF_FLAG_SIGNED, sz);
    value_def_set(val, def);
  }
  return val;
}

value_t pic_var_temp_get_def(pfile_t *pf, variable_def_t def)
{
  value_t val;

  val = pic_var_temp_get(pf, variable_def_flags_get_all(def), 
      variable_def_byte_sz_get(def));
  value_def_set(val, def);
  return val;
}

void pic_var_temp_release(pfile_t *pf, value_t tmp)
{
  variable_const_t n;
  value_t          baseofs;

  UNUSED(pf);
  pic_temp_sz_in_use -= value_byte_sz_get(tmp);
  baseofs = value_baseofs_get(tmp);
  n       = (baseofs) ? value_const_get(baseofs) : 0;
  assert(pic_temp_sz_in_use == n);
  value_release(tmp);
}

variable_sz_t pic_var_mul_div_sz_get(pfile_t *pf, variable_sz_t req, 
    const char *name)
{
  if ((variable_sz_t) -1 != req) {
    variable_t var;

    var = pfile_variable_find(pf, PFILE_LOG_NONE, name, 0);
    if (var) {
      if (variable_sz_get(var) != req) {
        if (req < variable_sz_get(var)) {
          req = variable_sz_get(var);
        } else {
          variable_def_t def;

          def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER, 
              VARIABLE_DEF_FLAG_NONE, req);
          variable_def_set(var, def);
        }
      }
      variable_release(var);
    }
  }
  return req;
}

boolean_t pic_var_mul_get(pfile_t *pf, variable_sz_t sz1, variable_sz_t sz2,
    pic_var_mul_t *dst)
{
  if (pic_in_isr(pf)) {
    isr_info.var_flags |= PIC_STVAR_FLAG_MULTIPLY;
  }
  if (sz1 > sz2) {
    SWAP(variable_sz_t, sz1, sz2);
  }
  if (!pfile_flag_test(pf, PFILE_FLAG_MISC_FASTMATH)) {
    sz1 = pic_var_mul_div_sz_get(pf, sz1, "_pic_multiplier");
    sz2 = pic_var_mul_div_sz_get(pf, sz2, "_pic_multiplicand");
  }

  pic_var_loop_release(pf, pic_var_loop_get(pf));
  dst->multiplier = pic_var_value_get(pf, "_pic_multiplier",
      VARIABLE_DEF_TYPE_INTEGER, sz1);
  dst->multiplicand = pic_var_value_get(pf, "_pic_multiplicand",
      VARIABLE_DEF_TYPE_INTEGER, sz2);
  dst->mresult = pic_var_value_get(pf, "_pic_mresult",
      VARIABLE_DEF_TYPE_INTEGER, sz2);
  return (boolean_t) (dst->multiplier != VALUE_NONE);
}

void pic_var_mul_release(pfile_t *pf, pic_var_mul_t *dst)
{
  UNUSED(pf);
  value_release(dst->mresult);
  value_release(dst->multiplicand);
  value_release(dst->multiplier);
}

boolean_t pic_var_float_get(pfile_t *pf, pic_var_float_t *dst)
{
  dst->fval1 = pic_var_value_get(pf, "_pic_fval1",
    VARIABLE_DEF_TYPE_FLOAT, 4);
  dst->exp1  = pic_var_value_get(pf, "_pic_fexp1",
    VARIABLE_DEF_TYPE_INTEGER, 1);
  dst->fval2 = pic_var_value_get(pf, "_pic_fval2",
    VARIABLE_DEF_TYPE_FLOAT, 4);
  dst->exp2  = pic_var_value_get(pf, "_pic_fexp2",
    VARIABLE_DEF_TYPE_INTEGER, 1);
  return BOOLEAN_TRUE;
}

void pic_var_float_release(pfile_t *pf, pic_var_float_t *dst)
{
  UNUSED(pf);
  value_release(dst->fval1);
  value_release(dst->exp1);
  value_release(dst->fval2);
  value_release(dst->exp2);
}

value_t pic_var_float_conv_get(pfile_t *pf, variable_sz_t sz)
{
  value_t val;

  val = pic_var_value_get(pf, "_pic_fconv",
    VARIABLE_DEF_TYPE_INTEGER, -1);
  if (!val || (value_sz_get(val) < sz)) {
    if (val) {
      value_release(val);
    }
    val = pic_var_value_get(pf, "_pic_fconv",
      VARIABLE_DEF_TYPE_INTEGER, sz);
  }
  return val;
}

void pic_var_float_conv_release(pfile_t *pf, value_t val)
{
  UNUSED(pf);
  value_release(val);
}

boolean_t pic_var_div_get(pfile_t *pf, variable_sz_t sz, pic_var_div_t *dst)
{
  if (pic_in_isr(pf)) {
    isr_info.var_flags |= PIC_STVAR_FLAG_DIVIDE;
  }
  if ((variable_sz_t) -1 != sz) {
    sz = pic_var_mul_div_sz_get(pf, sz, "_pic_divisor");
    pic_divide_size = 4 * sz;
  }
  pic_var_loop_release(pf, pic_var_loop_get(pf));
  dst->divisor = pic_var_value_get(pf, "_pic_divisor",
      VARIABLE_DEF_TYPE_INTEGER, sz);
  dst->dividend = pic_var_value_get(pf, "_pic_dividend",
      VARIABLE_DEF_TYPE_INTEGER, sz);
  dst->quotient = pic_var_value_get(pf, "_pic_quotient",
      VARIABLE_DEF_TYPE_INTEGER, sz);
  dst->remainder = pic_var_value_get(pf, "_pic_remainder",
      VARIABLE_DEF_TYPE_INTEGER, sz);
  dst->divaccum = pic_var_value_get(pf, "_pic_divaccum",
      VARIABLE_DEF_TYPE_INTEGER, 
	  (variable_sz_t) ((((variable_sz_t) -1) == sz) ? sz : 2 * sz));
  return (boolean_t) (dst->divisor != VALUE_NONE);
}

void pic_var_div_release(pfile_t *pf, pic_var_div_t *dst)
{
  UNUSED(pf);
  value_release(dst->divaccum);
  value_release(dst->remainder);
  value_release(dst->quotient);
  value_release(dst->dividend);
  value_release(dst->divisor);
}

boolean_t pic_var_isr_get(pfile_t *pf, boolean_t alloc, pic_var_isr_t *dst)
{
  variable_t isr_status;

  isr_status = pfile_variable_find(pf, PFILE_LOG_NONE, "_pic_isr_status", 0);
  if (isr_status) {
    dst->w      = pfile_value_find(pf, PFILE_LOG_ERR, "_pic_isr_w");
    dst->status = pfile_value_find(pf, PFILE_LOG_ERR, "_pic_isr_status");
    dst->pclath = pfile_value_find(pf, PFILE_LOG_ERR, "_pic_isr_pclath");
  } else if (alloc) {
    dst->w      = pic_var_value_get(pf, "_pic_isr_w", 
      VARIABLE_DEF_TYPE_INTEGER, 1);
    dst->status = pic_var_value_get(pf, "_pic_isr_status",
      VARIABLE_DEF_TYPE_INTEGER, 1);
    dst->pclath = pic_var_value_get(pf, "_pic_isr_pclath",
      VARIABLE_DEF_TYPE_INTEGER, 1);
  }
  variable_release(isr_status);
  return (boolean_t) (isr_status != VARIABLE_NONE);
}

void pic_var_isr_release(pfile_t *pf, pic_var_isr_t *dst)
{
  UNUSED(pf);
  value_release(dst->pclath);
  value_release(dst->status);
  value_release(dst->w);
}

/*
 * NAME
 *   pic_stvar_fixup
 *
 * DESCRIPTION
 *   once all needed state variables have been accessed
 *   position each in its place in the _pic_state union
 *
 * PARAMETERS
 *   pf : pfile
 *
 * RETURN
 *   none
 *
 * NOTES
 */
void pic_stvar_fixup(pfile_t *pf)
{
  variable_sz_t pic_state_sz;
  variable_sz_t pic_isr_state_sz;
  variable_t    state_var;
  variable_t    var;
  /* this is used to create _pic_state */
  static const struct {
    unsigned    pos;
    const char *tag;
    unsigned    flag;
  } varinfo[] = {
    {0, "_pic_temp",         PIC_STVAR_FLAG_NONE},

    {0, "_pic_memcpy_src",   PIC_STVAR_FLAG_MEMCPY},
    {1, "_pic_memcpy_dst",   PIC_STVAR_FLAG_MEMCPY},
    {2, "_pic_loop_tmp",     PIC_STVAR_FLAG_MEMCPY},

    {0, "_pic_divaccum",     PIC_STVAR_FLAG_DIVIDE},
    {0, "_pic_dividend",     PIC_STVAR_FLAG_DIVIDE},
    {1, "_pic_remainder",    PIC_STVAR_FLAG_DIVIDE},
    {2, "_pic_divisor",      PIC_STVAR_FLAG_DIVIDE},
    {3, "_pic_quotient",     PIC_STVAR_FLAG_DIVIDE},

    {0, "_pic_multiplier",   PIC_STVAR_FLAG_MULTIPLY},
    {1, "_pic_multiplicand", PIC_STVAR_FLAG_MULTIPLY},
    {2, "_pic_mresult",      PIC_STVAR_FLAG_MULTIPLY},

  };
  /* these are internal variables that are not in pic_state */
  static const char *util_vars[] = {
    /* these need to be saved & restored during a context switch          */
    "_pic_isr_status",
    "_pic_isr_pclath",
    "_pic_loop",
    "_pic_isr_loop",
    "_pic_isr_accum",
    "_pic_sign",
    "_pic_isr_sign",
    "_pic_pointer",
    "_pic_isr_pointer",
    "_pic_isr_fsr",
    "_pic_isr_tblptr",
    "_pic_fval1",
    "_pic_fexp1",
    "_pic_fval2",
    "_pic_fexp2",
    "_pic_fconv",
    /* these do *not* need to be saved & restored during a context switch */
    "_pic_stkptr",
    "_pic_task_ptr"
  };
  unsigned pic_state_pos[COUNT(varinfo)];
  size_t   ii;

  /* first, set the positions of the pic_state union members (see above)
   * while calculating pic_state_sz *and* pic_isr_state_sz */
  pic_state_sz     = 0;
  pic_isr_state_sz = isr_info.temp_size;
  for (ii = 0; ii < COUNT(pic_state_pos); ii++) {
    pic_state_pos[ii] = 0;
  }
  state_var = pic_var_state_var_get(pf);
  for (ii = 0; ii < COUNT(varinfo); ii++) {
    unsigned pos;

    var = pfile_variable_find(pf, PFILE_LOG_NONE, varinfo[ii].tag, 0);
    pos = varinfo[ii].pos;
    pic_state_pos[pos] = (pos) ? pic_state_pos[pos-1] : 0;
    if (var) {
      variable_base_set(var, (variable_base_t) pic_state_pos[pos], 0);
      variable_master_set(var, state_var);
      pic_state_pos[pos] += variable_sz_get(var);
      if (pic_state_pos[pos] > pic_state_sz) {
        pic_state_sz = (variable_sz_t) pic_state_pos[pos];
      } if ((isr_info.var_flags & varinfo[ii].flag)
        && (pic_state_pos[pos] > pic_isr_state_sz)) {
        pic_isr_state_sz = (variable_sz_t) pic_state_pos[pos];
      }
      variable_release(var);
    }
  }
  /* state var exists and has a size, allocate pic_isr_state
   * as necessary */
  if (state_var && pic_state_sz) {
    variable_def_t def;

    def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
          VARIABLE_DEF_FLAG_NONE, pic_state_sz);
    variable_def_set(state_var, def);
    pic_variable_alloc_one(pf, PFILE_PROC_NONE, 
      state_var); /* allocate this space */
    if (pic_isr_state_sz) {
      def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
        VARIABLE_DEF_FLAG_VOLATILE, pic_isr_state_sz);
      pfile_variable_alloc(pf, PFILE_VARIABLE_ALLOC_GLOBAL,
        "_pic_isr_state", def, VARIABLE_NONE, &var);
      pic_variable_alloc_one(pf, PFILE_PROC_NONE, var);
      variable_use_ct_set(var, 1);
      variable_assign_ct_set(var, 1);
      variable_release(var);
    }
  }
  variable_release(state_var);
  /* finally, allocate any other variables as necessary */
  for (ii = 0; ii < COUNT(util_vars); ii++) {
    var = pfile_variable_find(pf, PFILE_LOG_NONE, util_vars[ii], 0);
    if (var) {
      /* printf("Allocating...%s\n", variable_name_get(var)); */
      pic_variable_alloc_one(pf, PFILE_PROC_NONE, var);
      variable_use_ct_set(var, 1);
      variable_assign_ct_set(var, 1);
      variable_release(var);
    }
  }
  pfile_log(pf, PFILE_LOG_DEBUG, "isr(%04x, %u)", 
    isr_info.var_flags, isr_info.temp_size);
}

void pic_stvar_tblptr_mark(pfile_t *pf)
{
  if (pic_in_isr(pf)) {
    /* nb: '4' is used below to reserve space for _tablat */
    isr_info.var_flags |= PIC_STVAR_FLAG_TBLPTR;
    value_release(pic_var_value_get(pf, "_pic_isr_tblptr",
      VARIABLE_DEF_TYPE_INTEGER, 4));
  }
}

void pic_stvar_fsr_mark(pfile_t *pf)
{
  if (pic_in_isr(pf)) {
    isr_info.var_flags |= PIC_STVAR_FLAG_FSR;
    value_release(pic_var_value_get(pf, "_pic_isr_fsr",
      VARIABLE_DEF_TYPE_INTEGER, 
        (pic_is_16bit(pf) || pic_is_14bit_hybrid(pf)) ? 2 : 1));
  }
}


/* save off any variables use by the ISR:
   _pic_loop
   _pic_sign
   _pic_pointer
   _pic_state
     (this has to be calculates)
   */
static const struct {
  const char *user_name;
  const char *isr_name;
  unsigned    flag;
} pic_isr_var_map[] = {
  { "_pic_accum",   "_pic_isr_accum",   PIC_STVAR_FLAG_ACCUM   },
  { "_pic_loop",    "_pic_isr_loop",    PIC_STVAR_FLAG_LOOP    },
  { "_pic_sign",    "_pic_isr_sign",    PIC_STVAR_FLAG_SIGN    },
  { "_pic_pointer", "_pic_isr_pointer", PIC_STVAR_FLAG_POINTER },
  { 0,              "_pic_isr_fsr",     PIC_STVAR_FLAG_FSR     },
  { 0,              "_pic_isr_tblptr",  PIC_STVAR_FLAG_TBLPTR  },
  { "_pic_state",   "_pic_isr_state",   0                      }
};

static const char *pic14_reg_fsr[] = { "_fsr" };
static const char *pic16_reg_fsr[] = { "_fsr0l", "_fsr0h" };
static const char *pic16_reg_tblptr[] = { "tblptrl", "tblptrh", "tblptru",
  "_tablat"};

typedef struct pic_isr_reg_get_ {
  const char **reg;
  size_t       ct;
} pic_isr_reg_get_t;

static void pic_isr_reg_get(pfile_t *pf, unsigned flag, pic_isr_reg_get_t *dst)
{
    if (flag & PIC_STVAR_FLAG_FSR) {
      if (pic_is_16bit(pf)) {
        dst->reg = pic16_reg_fsr;
        dst->ct  = COUNT(pic16_reg_fsr);
      } else if (pic_is_14bit_hybrid(pf)) {
        /*
         * on entry to an interrupt, the 12 core
         * registers are saved on the hybrids, so
         * i needn't worry about doing so
         */
        dst->reg = 0;
        dst->ct  = 0;
      } else {
        dst->reg = pic14_reg_fsr;
        dst->ct  = COUNT(pic14_reg_fsr);
      }
    } else if (flag & PIC_STVAR_FLAG_TBLPTR) {
      dst->reg = pic16_reg_tblptr;
      dst->ct  = COUNT(pic16_reg_tblptr);
    } else {
      assert(0);
    }
}

void pic_var_isr_entry(pfile_t *pf)
{
  size_t  ii;
  label_t lbl_isr;

  lbl_isr = pfile_isr_entry_get(pf);
  for (ii = 0; ii < COUNT(pic_isr_var_map); ii++) {
    value_t user_val;
    value_t isr_val;

    user_val = (pic_isr_var_map[ii].user_name)
      ? pfile_value_find(pf, PFILE_LOG_NONE,
          pic_isr_var_map[ii].user_name)
      : VALUE_NONE;
    isr_val  = pfile_value_find(pf, PFILE_LOG_NONE,
      pic_isr_var_map[ii].isr_name);
    if (value_sz_get(isr_val)) {
      if (pic_is_16bit(pf) || pic_is_14bit_hybrid(pf)) {
        pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLB,
          value_base_get(isr_val)
          / ((pic_is_16bit(pf)) ? 256 : 128));
      }
      if (VALUE_NONE == user_val) {
        pic_isr_reg_get_t reg;
        size_t            jj;

        pic_isr_reg_get(pf, pic_isr_var_map[ii].flag, &reg);
        for (jj = 0; jj < reg.ct; jj++) {
          pic_instr_append_reg_d(pf, PIC_OPCODE_MOVF, reg.reg[jj], 
            PIC_OPDST_W);
          pic_instr_append_f(pf, PIC_OPCODE_MOVWF, isr_val, jj);
        }
      } else {
        pic_op(pf, OPERATOR_ASSIGN, isr_val, user_val, VALUE_NONE);
      }
    }
    value_release(isr_val);
    value_release(user_val);
  }
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl_isr);
  label_release(lbl_isr);
}

void pic_var_isr_exit(pfile_t *pf)
{
  size_t  ii;
  value_t user_val;
  value_t isr_val;

  for (ii = COUNT(pic_isr_var_map); ii; ii--) {
    user_val = (pic_isr_var_map[ii - 1].user_name)
      ? pfile_value_find(pf, PFILE_LOG_NONE,
          pic_isr_var_map[ii - 1].user_name)
      : VALUE_NONE;
    isr_val  = pfile_value_find(pf, PFILE_LOG_NONE,
      pic_isr_var_map[ii - 1].isr_name);
    if (value_sz_get(isr_val)) {
      /* isr_val might be (is likely to be) smaller than user_val,
       * so a direct assignment isn't possible */
      if (VALUE_NONE == user_val) {
        pic_isr_reg_get_t reg;
        size_t            jj;

        pic_isr_reg_get(pf, pic_isr_var_map[ii - 1].flag, &reg);
        for (jj = 0; jj < reg.ct; jj++) {
          pic_instr_append_f_d(pf, PIC_OPCODE_MOVF, isr_val, jj, PIC_OPDST_W);
          pic_instr_append_reg(pf, PIC_OPCODE_MOVWF, reg.reg[jj]);
        }
      } else {
        value_t tmp;

        tmp = value_clone(user_val);
        value_def_set(tmp, value_def_get(isr_val));
        pic_op(pf, OPERATOR_ASSIGN, tmp, isr_val, VALUE_NONE);
        value_release(tmp);
      }
    }
    value_release(isr_val);
    value_release(user_val);
  }
}

