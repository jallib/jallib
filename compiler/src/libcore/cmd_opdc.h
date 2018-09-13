/************************************************************
 **
 ** cmd_opdc.h : p-code operation structure declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef cmd_opdc_h__
#define cmd_opdc_h__

#include "operator.h"
#include "value.h"

typedef struct cmd_op_ {
  operator_t  op;
  value_t     dst;
  value_t     val1;
  value_t     val2;
} cmd_op_t;

#endif /* cmd_opdc_h__ */

