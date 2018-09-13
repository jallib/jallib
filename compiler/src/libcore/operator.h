/************************************************************
 **
 ** operator.h : operator declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef operator_h__
#define operator_h__

#include "variable.h"

typedef enum operator_ {
  OPERATOR_NULL,         /* no operation   */
  /* basic operations */
  OPERATOR_ADD,
  OPERATOR_SUB,
  OPERATOR_MUL,
  OPERATOR_DIV,
  OPERATOR_MOD,
  /* relationals      */
  OPERATOR_LT,
  OPERATOR_LE,
  OPERATOR_EQ,
  OPERATOR_NE,
  OPERATOR_GE,
  OPERATOR_GT,
  /* logicals         */
  OPERATOR_ANDL,
  OPERATOR_ORL,
  OPERATOR_NOTL, /* unary */
  /* bits             */
  OPERATOR_ANDB,
  OPERATOR_ORB,
  OPERATOR_XORB,
  OPERATOR_CMPB, /* unary */
  /* misc */
  OPERATOR_ASSIGN,  /* unary */
  OPERATOR_NEG,     /* unary */
  OPERATOR_INCR,    /* unary */
  OPERATOR_DECR,    /* unary */
  OPERATOR_SHIFT_LEFT,
  OPERATOR_SHIFT_RIGHT,
  OPERATOR_SHIFT_RIGHT_ARITHMETIC, /* preserve the sign bit */
  OPERATOR_LOGICAL,  /* unary : convert a value to either 0 or 1 */
  OPERATOR_REFERENCE,/* unary : return the address of a variable or label */
  OPERATOR_DOT,      /* unary : (val) parses member      */
  OPERATOR_SUBSCRIPT,/* binary: (val, offset)            */
  OPERATOR_CAST,     /* unary : (val, val2 holds newdef) */
  OPERATOR_CT
} operator_t;

typedef unsigned short operator_priority_t;

operator_priority_t operator_priority_get(operator_t op);
boolean_t           operator_is_binary(operator_t op);
boolean_t           operator_is_unary(operator_t op);
boolean_t           operator_is_assign(operator_t op);
boolean_t           operator_is_logical(operator_t op);
boolean_t           operator_is_relation(operator_t op);
boolean_t           operator_is_commutative(operator_t op);
const char *        operator_to_str(operator_t op);
#endif /* operator_h__ */

