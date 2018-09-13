/************************************************************
 **
 ** jal_expr.h : JAL expression parsing declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef jal_expr_h__
#define jal_expr_h__

#include "../libcore/pfile.h"

value_t jal_parse_expr(pfile_t *pf);

typedef enum {
  JAL_PARSE_VALUE_TYPE_ANY,
  JAL_PARSE_VALUE_TYPE_LVALUE,
  JAL_PARSE_VALUE_TYPE_RVALUE
} jal_parse_value_type_t;

value_t   jal_parse_value(pfile_t *pf, jal_parse_value_type_t type);
boolean_t jal_parse_structure(pfile_t *pf, value_t *pval);
boolean_t jal_parse_subscript(pfile_t *pf, value_t *pval);

#endif /* jal_expr_h__ */


