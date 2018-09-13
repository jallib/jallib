/**********************************************************
 **
 ** operator.c : manipulators for operator_t
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include "operator.h"

/*
 * NAME
 *   operator_is_unary
 *
 * DESCRIPTION
 *   determine if an operator is a unary op
 *
 * PARAMETERS
 *   op : operator
 *
 * RETURN
 *   0 : operator is not unary
 *   1 : operator is unary
 *
 * NOTES
 */
boolean_t operator_is_unary(operator_t op)
{
  boolean_t rc;

  rc = BOOLEAN_FALSE;
  switch (op) {
    case OPERATOR_NULL:
    case OPERATOR_ADD:
    case OPERATOR_SUB:
    case OPERATOR_MUL:
    case OPERATOR_DIV:
    case OPERATOR_MOD:
    case OPERATOR_LT:
    case OPERATOR_LE:
    case OPERATOR_EQ:
    case OPERATOR_NE:
    case OPERATOR_GE:
    case OPERATOR_GT:
    case OPERATOR_ANDL:
    case OPERATOR_ORL:
    case OPERATOR_ANDB:
    case OPERATOR_ORB:
    case OPERATOR_XORB:
    case OPERATOR_SHIFT_LEFT:
    case OPERATOR_SHIFT_RIGHT:
    case OPERATOR_SHIFT_RIGHT_ARITHMETIC:
    case OPERATOR_ASSIGN:
    case OPERATOR_CT:
      break;
    case OPERATOR_LOGICAL:
    case OPERATOR_NOTL:
    case OPERATOR_CMPB:
    case OPERATOR_NEG:
    case OPERATOR_INCR:
    case OPERATOR_DECR:
    case OPERATOR_REFERENCE:
    case OPERATOR_CAST:
    case OPERATOR_DOT:
    case OPERATOR_SUBSCRIPT:
      rc = BOOLEAN_TRUE;
      break;
  }
  return rc;
}

boolean_t operator_is_assign(operator_t op)
{
  boolean_t rc;

  rc = BOOLEAN_FALSE;
  switch (op) {
    case OPERATOR_NULL:
    case OPERATOR_ADD:
    case OPERATOR_SUB:
    case OPERATOR_MUL:
    case OPERATOR_DIV:
    case OPERATOR_MOD:
    case OPERATOR_LT:
    case OPERATOR_LE:
    case OPERATOR_EQ:
    case OPERATOR_NE:
    case OPERATOR_GE:
    case OPERATOR_GT:
    case OPERATOR_ANDL:
    case OPERATOR_ORL:
    case OPERATOR_ANDB:
    case OPERATOR_ORB:
    case OPERATOR_XORB:
    case OPERATOR_SHIFT_LEFT:
    case OPERATOR_SHIFT_RIGHT:
    case OPERATOR_SHIFT_RIGHT_ARITHMETIC:
    case OPERATOR_LOGICAL:
    case OPERATOR_NOTL:
    case OPERATOR_CMPB:
    case OPERATOR_NEG:
    case OPERATOR_INCR:
    case OPERATOR_DECR:
    case OPERATOR_REFERENCE:
    case OPERATOR_DOT:
    case OPERATOR_CAST:
    case OPERATOR_SUBSCRIPT:
    case OPERATOR_CT:
      break;
    case OPERATOR_ASSIGN:
      rc = BOOLEAN_TRUE;
      break;
  }
  return rc;
}

boolean_t operator_is_binary(operator_t op)
{
  return !(operator_is_unary(op) || operator_is_assign(op));
}

boolean_t operator_is_logical(operator_t op)
{
  boolean_t rc;

  rc = BOOLEAN_FALSE;
  switch (op) {
    case OPERATOR_NULL:
    case OPERATOR_ADD:
    case OPERATOR_SUB:
    case OPERATOR_MUL:
    case OPERATOR_DIV:
    case OPERATOR_MOD:
    case OPERATOR_LT:
    case OPERATOR_LE:
    case OPERATOR_EQ:
    case OPERATOR_NE:
    case OPERATOR_GE:
    case OPERATOR_GT:
    case OPERATOR_ANDB:
    case OPERATOR_ORB:
    case OPERATOR_XORB:
    case OPERATOR_SHIFT_LEFT:
    case OPERATOR_SHIFT_RIGHT:
    case OPERATOR_SHIFT_RIGHT_ARITHMETIC:
    case OPERATOR_CMPB:
    case OPERATOR_NEG:
    case OPERATOR_INCR:
    case OPERATOR_DECR:
    case OPERATOR_ASSIGN:
    case OPERATOR_REFERENCE:
    case OPERATOR_DOT:
    case OPERATOR_CAST:
    case OPERATOR_SUBSCRIPT:
    case OPERATOR_CT:
      break;
    case OPERATOR_ANDL:
    case OPERATOR_ORL:
    case OPERATOR_LOGICAL:
    case OPERATOR_NOTL:
      rc = BOOLEAN_TRUE;
      break;
  }
  return rc;
}

boolean_t operator_is_relation(operator_t op)
{
  boolean_t rc;

  rc = BOOLEAN_FALSE;
  switch (op) {
    case OPERATOR_NULL:
    case OPERATOR_ADD:
    case OPERATOR_SUB:
    case OPERATOR_MUL:
    case OPERATOR_DIV:
    case OPERATOR_MOD:
    case OPERATOR_ANDL:
    case OPERATOR_ORL:
    case OPERATOR_ANDB:
    case OPERATOR_ORB:
    case OPERATOR_XORB:
    case OPERATOR_SHIFT_LEFT:
    case OPERATOR_SHIFT_RIGHT:
    case OPERATOR_SHIFT_RIGHT_ARITHMETIC:
    case OPERATOR_LOGICAL:
    case OPERATOR_NOTL:
    case OPERATOR_CMPB:
    case OPERATOR_NEG:
    case OPERATOR_INCR:
    case OPERATOR_DECR:
    case OPERATOR_ASSIGN:
    case OPERATOR_REFERENCE:
    case OPERATOR_DOT:
    case OPERATOR_CAST:
    case OPERATOR_SUBSCRIPT:
    case OPERATOR_CT:
      break;
    case OPERATOR_LT:
    case OPERATOR_LE:
    case OPERATOR_EQ:
    case OPERATOR_NE:
    case OPERATOR_GE:
    case OPERATOR_GT:
      rc = BOOLEAN_TRUE;
      break;
  }
  return rc;
}

boolean_t operator_is_commutative(operator_t op)
{
  boolean_t rc;

  rc = BOOLEAN_FALSE;
  switch (op) {
    case OPERATOR_NULL:
    case OPERATOR_SUB:
    case OPERATOR_DIV:
    case OPERATOR_MOD:
    case OPERATOR_SHIFT_LEFT:
    case OPERATOR_SHIFT_RIGHT:
    case OPERATOR_SHIFT_RIGHT_ARITHMETIC:
    case OPERATOR_LOGICAL:
    case OPERATOR_NOTL:
    case OPERATOR_CMPB:
    case OPERATOR_NEG:
    case OPERATOR_INCR:
    case OPERATOR_DECR:
    case OPERATOR_ASSIGN:
    case OPERATOR_LT:
    case OPERATOR_LE:
    case OPERATOR_GE:
    case OPERATOR_GT:
    case OPERATOR_REFERENCE:
    case OPERATOR_DOT:
    case OPERATOR_CAST:
    case OPERATOR_SUBSCRIPT:
    case OPERATOR_CT:
      break;
    case OPERATOR_ADD:
    case OPERATOR_MUL:
    case OPERATOR_ANDL:
    case OPERATOR_ORL:
    case OPERATOR_ANDB:
    case OPERATOR_ORB:
    case OPERATOR_XORB:
    case OPERATOR_EQ:
    case OPERATOR_NE:
      rc = BOOLEAN_TRUE;
      break;
  }
  return rc;
}

const char *operator_to_str(operator_t op)
{
  const char *ostr;

  ostr = "{unknown}";
  switch (op) {
    case OPERATOR_NULL:         ostr = "{null}"; break;
    case OPERATOR_ADD:          ostr = "+"; break;
    case OPERATOR_SUB:          ostr = "-"; break;
    case OPERATOR_MUL:          ostr = "*"; break;
    case OPERATOR_DIV:          ostr = "/"; break;
    case OPERATOR_MOD:          ostr = "%"; break;
    case OPERATOR_LT:           ostr = "<"; break;
    case OPERATOR_LE:           ostr = "<="; break;
    case OPERATOR_EQ:           ostr = "=="; break;
    case OPERATOR_NE:           ostr = "<>"; break;
    case OPERATOR_GE:           ostr = ">="; break;
    case OPERATOR_GT:           ostr = ">"; break;
    case OPERATOR_ANDL:         ostr = "&&"; break;
    case OPERATOR_ORL:          ostr = "||"; break;
    case OPERATOR_NOTL:         ostr = "!";  break;
    case OPERATOR_ANDB:         ostr = "&";  break;
    case OPERATOR_ORB:          ostr = "|"; break;
    case OPERATOR_XORB:         ostr = "^"; break;
    case OPERATOR_CMPB:         ostr = "~"; break;
    case OPERATOR_ASSIGN:       ostr = "="; break;
    case OPERATOR_NEG:          ostr = "neg"; break;
    case OPERATOR_SHIFT_LEFT:   ostr = "<<"; break;
    case OPERATOR_SHIFT_RIGHT:  ostr = ">>"; break;
    case OPERATOR_SHIFT_RIGHT_ARITHMETIC:  ostr = ">->"; break;
    case OPERATOR_LOGICAL:      ostr = "!!"; break;
    case OPERATOR_INCR:         ostr = "++"; break;
    case OPERATOR_DECR:         ostr = "--"; break;
    case OPERATOR_REFERENCE:    ostr = "whereis "; break;
    case OPERATOR_DOT:          ostr = "."; break;
    case OPERATOR_CAST:         ostr = "()"; break;
    case OPERATOR_SUBSCRIPT:    ostr = "[]"; break;
    case OPERATOR_CT:           ostr = "{ct}"; break;
  }
  return ostr;
}

