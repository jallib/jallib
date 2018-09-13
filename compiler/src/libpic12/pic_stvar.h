/************************************************************
 **
 ** pic_stvar.h : pic state variable definitions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_stvar_h__
#define pic_stvar_h__

#include "pic.h"

value_t pic_var_task_ptr_get(pfile_t *pf);
void pic_var_task_ptr_release(pfile_t *pf, value_t val);

value_t pic_var_loop_get(pfile_t *pf);
void    pic_var_loop_release(pfile_t *pf, value_t val);

value_t pic_var_loop_tmp_get(pfile_t *pf);
void    pic_var_loop_tmp_release(pfile_t *pf, value_t val);

value_t pic_var_sign_get(pfile_t *pf);
void    pic_var_sign_release(pfile_t *pf, value_t val);

value_t pic_var_accum_get(pfile_t *pf);
void    pic_var_accum_release(pfile_t *pf, value_t val);

value_t pic_var_pointer_get(pfile_t *pf);
void    pic_var_pointer_release(pfile_t *pf, value_t val);

boolean_t pic_memcpy_params_get(pfile_t *pf, value_t *params);
void      pic_memcpy_params_release(pfile_t *pf, value_t *params);

value_t pic_var_temp_get(pfile_t *pf, flag_t flags, variable_sz_t sz);
value_t pic_var_temp_get_def(pfile_t *pf, variable_def_t def);
void    pic_var_temp_release(pfile_t *pf, value_t tmp);

typedef struct {
  value_t multiplier;
  value_t multiplicand;
  value_t mresult;
} pic_var_mul_t;

boolean_t pic_var_mul_get(pfile_t *pf, variable_sz_t sz1, variable_sz_t sz2,
   pic_var_mul_t *dst);
void pic_var_mul_release(pfile_t *pf, pic_var_mul_t *dst);

typedef struct {
  value_t divisor;
  value_t dividend;
  value_t quotient;
  value_t remainder;
  value_t divaccum; /* this covers divisor + remainder for long shifts */
} pic_var_div_t;

boolean_t pic_var_div_get(pfile_t *pf, variable_sz_t sz, pic_var_div_t *dst);
void pic_var_div_release(pfile_t *pf, pic_var_div_t *dst);

typedef struct {
  value_t fval1;
  value_t exp1;
  value_t fval2;
  value_t exp2;
} pic_var_float_t;

boolean_t pic_var_float_get(pfile_t *pf, pic_var_float_t *dst);
void      pic_var_float_release(pfile_t *pf, pic_var_float_t *dst);

/*
 * get the float convert area. this is sized to the largest integer
 * converted
 */
value_t   pic_var_float_conv_get(pfile_t *pf, variable_sz_t sz);
void      pic_var_float_conv_release(pfile_t *pf, value_t val);

typedef struct {
  value_t w;         /* holds W         on ISR entry */
  value_t status;    /* holds STATUS    on ISR entry */
  value_t pclath;    /* holds PCLATH    on ISR entry */
} pic_var_isr_t;

boolean_t pic_var_isr_get(pfile_t *pf, boolean_t alloc, pic_var_isr_t *dst);
void pic_var_isr_release(pfile_t *pf, pic_var_isr_t *dst);

void    pic_var_isr_entry(pfile_t *pf);
void    pic_var_isr_exit(pfile_t *pf);

value_t pic_var_stkptr_get(pfile_t *pf);
void    pic_var_stkptr_release(pfile_t *pf, value_t stkptr);

void    pic_stvar_fixup(pfile_t *pf);

/*
 * unlike the others, these don't really return anything; rather they
 * mark the mentioned variable as 'used' to it can be saved and restored
 * as necessary
 */
void    pic_stvar_tblptr_mark(pfile_t *pf);
void    pic_stvar_fsr_mark(pfile_t *pf);

#endif /* pic_stvar_h__ */

