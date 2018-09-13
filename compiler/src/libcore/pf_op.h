/************************************************************
 **
 ** pf_op.h : declarations for constant operations
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_op_h__
#define pf_op_h__

#include "pfile.h"
#include "operator.h"

typedef enum {
  PF_CONST_TYPE_NONE = 0,
  PF_CONST_TYPE_INTEGER = 1,
  PF_CONST_TYPE_FLOAT = 2
} pf_const_type_t;

typedef struct {
  pf_const_type_t type;
  union {
    variable_const_t n;
    float            f;
  } u;
} pf_const_t;

pf_const_t pfile_op_const_exec(pfile_t *pf,
    operator_t op,
    value_t    val1,
    value_t    val2);

value_t pf_const_to_const(pfile_t *pf,
    pf_const_t c, variable_def_t def);

#endif /* pf_op_h__ */

