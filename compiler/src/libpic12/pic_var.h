/************************************************************
 **
 ** pic_var.h : PIC variable allocation declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_var_h__
#define pic_var_h__

#include "pic.h"
extern unsigned pic_blist_max;   /* max amount used     */
extern unsigned pic_blist_cur;   /* current amount used */
extern unsigned pic_blist_total; /* total available */

void pic_variable_alloc(pfile_t *pf);
boolean_t pic_variable_alloc_one(pfile_t *pf, pfile_proc_t *proc,
    variable_t var);
void pic_blist_free(pfile_t *pf);
void pic_blist_info_log(pfile_t *pf);
pic_bank_info_t *pic_bank_info_get(pfile_t *pf);

#endif /* pic_var_h__ */

