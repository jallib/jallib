/************************************************************
 **
 ** exprd.h : expression structure declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef exprd_h__
#define exprd_h__

#include "value.h"
#include "operator.h"

struct expr_ {
  struct expr_ *link;
  value_t       val;
  operator_t    op;
};

#endif /* exprd_h__ */

