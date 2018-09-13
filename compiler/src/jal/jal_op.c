/**********************************************************
 **
 ** jal_op.c : JAL operator precedence declarations
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include "../libcore/operator.h"

operator_priority_t operator_priority_get(operator_t op)
{
  operator_priority_t pr;

  pr = 0;
  switch (op) {
    case OPERATOR_NULL:        pr = 0; break; 
    case OPERATOR_DOT:
    case OPERATOR_CAST:
    case OPERATOR_SUBSCRIPT:
    case OPERATOR_CT:
    case OPERATOR_REFERENCE:   pr = 16; break;
    case OPERATOR_LOGICAL:
    case OPERATOR_NOTL:
    case OPERATOR_NEG:
    case OPERATOR_CMPB:        pr = 15; break;
    case OPERATOR_MUL:
    case OPERATOR_DIV:
    case OPERATOR_MOD:         pr = 14; break;
    case OPERATOR_ADD:
    case OPERATOR_SUB:         pr = 13; break;
    case OPERATOR_SHIFT_LEFT: 
    case OPERATOR_SHIFT_RIGHT:
    case OPERATOR_SHIFT_RIGHT_ARITHMETIC:
    case OPERATOR_LT:
    case OPERATOR_LE:
    case OPERATOR_EQ:
    case OPERATOR_NE:
    case OPERATOR_GE:
    case OPERATOR_GT:          pr = 11; break;
    case OPERATOR_ANDL:
    case OPERATOR_ORL:
    case OPERATOR_ANDB:
    case OPERATOR_ORB:
    case OPERATOR_XORB:        pr = 10; break;
    case OPERATOR_INCR:
    case OPERATOR_DECR:
    case OPERATOR_ASSIGN:      pr = 0; break;
  }
  return pr;
}

