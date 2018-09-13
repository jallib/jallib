/************************************************************
 **
 ** pf_expr.h : pfile expression declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_expr_h__
#define pf_expr_h__

#include "pfile.h"
#include "expr.h"

variable_def_t pfile_variable_def_promotion_get_default(pfile_t *pf,
    operator_t op, value_t val1, value_t val2);

result_t pfile_expr_push(pfile_t *pf, expr_t **stk, value_t val,
    operator_t op);

void pfile_cmd_op_add(pfile_t *pf,
  operator_t op, value_t *pdst, value_t val1, value_t val2);

variable_def_t pfile_variable_def_promotion_get(pfile_t *pf,
    operator_t op, value_t val1, value_t val2);

void pfile_cmd_op_add_assign(pfile_t *pf, operator_t op,
  value_t *pdst, value_t src);

boolean_t pfile_value_def_overflow_check(pfile_t *pf, 
  operator_t op, const variable_def_t vdef, value_t val);

void pfile_value_def_type_check(pfile_t *pf, operator_t op, 
    variable_def_t dst_def, value_t val1, value_t val2);

boolean_t pfile_expr_string_fix(pfile_t *pf, value_t val);
#endif /* pf_expr_h__ */

