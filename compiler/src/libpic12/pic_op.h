/************************************************************
 **
 ** pic_op.h : PIC operator generation declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_op_h__
#define pic_op_h__

#include "pic.h"

#define SWAP(type, a, b) \
   { type tmp__; tmp__ = a; a = b; b = tmp__; }


/* operator --> pic instructions */
void pic_op(pfile_t *pf, operator_t op, value_t dst, value_t val1,
    value_t val2);
void pic_indirect_setup(pfile_t *pf, value_t val, size_t offset);

void pic_last_values_reset(void);

operator_t pic_relational(pfile_t *pf, operator_t op, value_t dst, 
    value_t val1, value_t val2);

value_t pic_cast(value_t src, variable_sz_t sz);

#endif /* pic_op_h__ */

