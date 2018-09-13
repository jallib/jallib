/************************************************************
 **
 ** pf_expr.c : p-code expression & operator functions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <assert.h>
#include "pfiled.h"
#include "pf_cmd.h"
#include "pf_op.h"
#include "pf_expr.h"

variable_def_t pfile_variable_def_promotion_get_default(pfile_t *pf,
    operator_t op, value_t val1, value_t val2)
{
  variable_def_t      rdef; /* result */
  variable_sz_t       sz1;
  variable_sz_t       sz2;
  variable_def_t      def1;
  variable_def_t      def2;

  UNUSED(pf);
  UNUSED(op);

  def1 = value_def_get(val1);
  def2 = value_def_get(val2);

  sz1 = variable_def_sz_get(def1);
  if (!value_is_bit(val1)) {
    sz1 *= 8;
  }
  sz2 = variable_def_sz_get(def2);
  if (!value_is_bit(val2)) {
    sz2 *= 8;
  }

  if (!def2 || variable_def_is_same(def1, def2)) {
    /* (1) definition is the same */
    rdef = def1;
  } else if (VARIABLE_DEF_TYPE_FLOAT == variable_def_type_get(def1)) {
    rdef = def1;
  } else if (VARIABLE_DEF_TYPE_FLOAT == variable_def_type_get(def2)) {
    rdef = def2;
  } else if (variable_def_flag_test(def1, VARIABLE_DEF_FLAG_SIGNED)
    && variable_def_flag_test(def2, VARIABLE_DEF_FLAG_SIGNED)) {
    /* (2) both operands are signed, the result is the one with the
     * greatest size */
    rdef = (sz1 > sz2) ? def1 : def2;
  } else if (!variable_def_flag_test(def1, VARIABLE_DEF_FLAG_SIGNED)
      && (sz1 >= sz2)) {
    /* (3a) unsigned type sz >= signed type size; result is unsigned */
    rdef = def1;
  } else if (!variable_def_flag_test(def2, VARIABLE_DEF_FLAG_SIGNED)
      && (sz2 >= sz1)) {
    /* (3b) unsigned type sz >= signed type size; result is unsigned */
    rdef = def2;
  } else if (variable_def_flag_test(def1, VARIABLE_DEF_FLAG_SIGNED)
      && (sz1 > sz2)) {
    /* (4a) */
    rdef = def1;
  } else if (variable_def_flag_test(def2, VARIABLE_DEF_FLAG_SIGNED)
      && (sz2 > sz1)) {
    /* (4b) */
    rdef = def2;
  } else {
    /* (5) */
    rdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
        VARIABLE_DEF_FLAG_NONE, (sz1 > sz2) ? sz1 : sz2);
  }
  if (variable_def_flag_test(rdef, VARIABLE_DEF_FLAG_CONST)
      || variable_def_flag_test(rdef, VARIABLE_DEF_FLAG_BIT)) {
    /* flip this bit */
    rdef = variable_def_flags_change(rdef,
        variable_def_flags_get_all(rdef)
        & ~(VARIABLE_DEF_FLAG_CONST | VARIABLE_DEF_FLAG_BIT));
  }
  return rdef;
}

variable_def_t pfile_variable_def_promotion_get(pfile_t *pf,
    operator_t op, value_t val1, value_t val2)
{
  variable_def_t rdef;

  rdef = (pf->vectors->pf_expr_result_def_get_fn)
    ? pf->vectors->pf_expr_result_def_get_fn(pf, op, val1, val2)
    : pfile_variable_def_promotion_get_default(pf, op, val1, val2);
  if (!rdef) {
    pfile_log(pf, PFILE_LOG_ERR, "invalid operation");
  }
  return rdef;
}

/*
 * NAME
 *   pfile_expr_push
 *
 * DESCRIPTION
 *   push a subexpression onto the expression stack
 *
 * PARAMETERS
 *   pf   : returned by pfile_open()
 *   stk  : top of the expression stack
 *   expr : expression to append
 *
 * RETURN
 *   none
 *
 * NOTES
 *   this creates commands as necessary
 */
result_t pfile_expr_push(pfile_t *pf, expr_t **stk, value_t val,
    operator_t op)
{
  result_t rc;
  expr_t  *stkptr;
  expr_t  *expr;

  rc     =  expr_alloc(&expr, op, val);
  stkptr = *stk;
  if (RESULT_OK == rc) {
    while (stkptr 
      && (operator_priority_get(expr_operator_get(stkptr))
        >= operator_priority_get(expr_operator_get(expr)))) {
      expr_t  *stkpv;
      value_t  dst;

      stkpv = expr_link_get(stkptr);
      dst   = 0;

      if (operator_is_assign(expr_operator_get(stkptr))) {
        /* stkptr->val stkptr->op expr->val */
        dst = expr_val_get(stkptr);
        pfile_cmd_op_add(pf, expr_operator_get(stkptr),
          &dst, expr_val_get(expr), 0);
        value_lock(dst);
      } else {
        /* dst = stkptr->val stkptr->op expr->val */
        operator_t s_op;

        s_op = expr_operator_get(stkptr);
        if ((OPERATOR_SHIFT_RIGHT == s_op)
          && value_is_signed(expr_val_get(stkptr))) {
          s_op = OPERATOR_SHIFT_RIGHT_ARITHMETIC;
        }
        pfile_cmd_op_add(pf, s_op, &dst, expr_val_get(stkptr), 
            expr_val_get(expr));
      }
      expr_val_set(expr, dst);
      expr_free(stkptr);
      value_release(dst);
      stkptr = stkpv;
    }
    expr_link_set(expr, stkptr);
    *stk = expr;
  }
  if (RESULT_OK != rc) {
    pfile_log_syserr(pf, rc);
  }
  return rc;
}

/* does the relation make sense? */
typedef enum relation_result_ {
  RELATION_RESULT_UNKNOWN, /* no problems */
  RELATION_RESULT_TRUE,    /* result is always TRUE */
  RELATION_RESULT_FALSE    /* result is always FALSE */
} relation_result_t;

static relation_result_t pfile_expr_relation_check(pfile_t *pf, operator_t op,
  value_t val1, value_t val2)
{
  variable_const_t  cn;
  size_t            val1_sz;
  const char       *wstr;
  relation_result_t result;

  result = RELATION_RESULT_UNKNOWN;
  if (value_is_const(val1) || value_is_const(val2)) {
    /* first, force the constant to the right side */
    if (value_is_const(val1)) {
      value_t tmp;

      switch (op) {
        case OPERATOR_LT: op = OPERATOR_GT; break;
        case OPERATOR_LE: op = OPERATOR_GE; break;
        case OPERATOR_GE: op = OPERATOR_LE; break;
        case OPERATOR_GT: op = OPERATOR_LT; break;
        default:
          /*
           * The only way to get here is '=' or '!=' and these are
           * cummutative so it doesn't matter. No other operators
           * should have come this far!
           */
           break;
      }
      tmp = val1;
      val1 = val2;
      val2 = tmp;
    }
    cn = value_const_get(val2);
    val1_sz = value_sz_get(val1);
    if (!value_is_bit(val1)) {
      val1_sz *= 8;
    }
    if (value_is_signed(val1)) {
      if (!value_is_signed(val2) && (cn & 0x80000000)) {
        switch (op) {
          case OPERATOR_LT:
          case OPERATOR_LE:
          case OPERATOR_NE: result = RELATION_RESULT_TRUE;  break;
          case OPERATOR_EQ:
          case OPERATOR_GE:
          case OPERATOR_GT: result = RELATION_RESULT_FALSE;  break;
          default: break;
        }
      } else if (val1_sz < 32) {
        long cn_low;
        long cn_high;
        long cns;

        cn_high = (long) (1L << (val1_sz - 1)) - 1;
        cn_low  = (long) -(1L << (val1_sz - 1));
        cns     = (long) cn;

        switch (op) {
          case OPERATOR_LT:
            if (cns <= cn_low) {
              result = RELATION_RESULT_FALSE;
            } else if (cns > cn_high) {
              result = RELATION_RESULT_TRUE;
            }
            break;
          case OPERATOR_LE:
            if (cns < cn_low) {
              result = RELATION_RESULT_FALSE;
            } else if (cns >= cn_high) {
              result = RELATION_RESULT_TRUE;
            }
            break;
          case OPERATOR_EQ:
            if ((cns < cn_low) || (cns > cn_high)) {
              result = RELATION_RESULT_FALSE;
            }
            break;
          case OPERATOR_NE:
            if ((cns < cn_low) || (cns > cn_high)) {
              result = RELATION_RESULT_TRUE;
            }
            break;
          case OPERATOR_GE:
            if (cns <= cn_low) {
              result = RELATION_RESULT_TRUE;
            } else if (cns > cn_high) {
              result = RELATION_RESULT_FALSE;
            }
            break;
          case OPERATOR_GT:
            if (cns < cn_low) {
              result = RELATION_RESULT_TRUE;
            } else if (cns >= cn_high) {
              result = RELATION_RESULT_FALSE;
            }
            break;
          default:
            break;
        }
      }
    } else {
      if (value_is_signed(val2) && (cn & 0x80000000)) {
        switch (op) {
          case OPERATOR_LT: /* an unsigned value can never be <= a negative #*/
          case OPERATOR_LE:
          case OPERATOR_EQ: result = RELATION_RESULT_FALSE; break;
          case OPERATOR_NE:
          case OPERATOR_GE:
          case OPERATOR_GT: result = RELATION_RESULT_TRUE;  break;
          default: break;
        }
      } else if (val1_sz < 32) {
        variable_const_t cn_high;

        /* the highest possible number that can fit into val1 */
        cn_high = (1ul << val1_sz) - 1;
        switch (op) {
          case OPERATOR_LT:
            if (cn == 0) {
              result = RELATION_RESULT_FALSE;
            } else if (cn > cn_high) {
              result = RELATION_RESULT_TRUE;
            }
            break;
          case OPERATOR_LE:
            if (cn >= cn_high) {
              result = RELATION_RESULT_TRUE;
            }
            break;
          case OPERATOR_EQ:
            if (cn > cn_high) {
              result = RELATION_RESULT_FALSE;
            }
            break;
          case OPERATOR_NE:
            if (cn > cn_high) {
              result = RELATION_RESULT_TRUE;
            }
            break;
          case OPERATOR_GE:
            if (cn == 0) {
              result = RELATION_RESULT_TRUE;
            } else if (cn > cn_high) {
              result = RELATION_RESULT_FALSE;
            }
            break;
          case OPERATOR_GT:
            if (cn >= cn_high) {
              result = RELATION_RESULT_FALSE;
            }
            break;
          default: break;
        }
      }
    }
    wstr = 0;
    switch (result) {
      case RELATION_RESULT_UNKNOWN: break;
      case RELATION_RESULT_TRUE:    wstr = "operation is always TRUE";  break;
      case RELATION_RESULT_FALSE:   wstr = "operation is always FALSE"; break;
    }
    if (wstr) {
      pfile_log(pf, PFILE_LOG_WARN, "%s", wstr);
    }
  }
  return result;
}

/*
 * Check to see if the universal in val1 is compatible with val2
 * (it's compatible if its value will fit within the definition
 * if val2).
 * nb: the operator is needed here for the logicals and for
 *     binary and -- as long as the high order bytes of binary
 *     and are 0xff they have no bearing on the result, therefore
 *     should not affect overflow
 */
boolean_t pfile_value_def_overflow_check(pfile_t *pf, 
  operator_t op, const variable_def_t vdef, value_t val)
{
  boolean_t        overflow;

  if (operator_is_logical(op)) {
    /* there is no overflow with logical operators */
    overflow = BOOLEAN_FALSE;
  } else {
    variable_const_t cn;
    variable_sz_t    vdef_sz;

    cn      = value_const_get(val);
    vdef_sz = variable_def_sz_get(vdef);
    if (!variable_def_flag_test(vdef, VARIABLE_DEF_FLAG_BIT)) {
      vdef_sz *= 8;
    }
    if ((OPERATOR_ANDB == op) && (vdef_sz < 32)) {
      /*
       * in this case, as long as all of the high order bits are set
       * there is no overflow since x & 0xff == x
       */
      variable_const_t hbits; /* the high order bits */
      variable_const_t lbit;  /* low order bit       */
      variable_const_t mask;
      
      hbits = cn;
      lbit  = 1UL << vdef_sz;
      mask  = lbit - 1;
      hbits = hbits & ~mask;
      if ((0 == hbits) || (0 == hbits + lbit)) {
        cn = cn & mask;
      }
    }
    if (variable_def_flag_test(vdef, VARIABLE_DEF_FLAG_SIGNED)) {
      long hi;
      long lo;
      
      hi = (long) (1L << (vdef_sz - 1)) - 1;
      lo = (long) -(1L << (vdef_sz - 1));
      if (value_is_signed(val)) {
        overflow = (((long) cn < lo) || ((long) cn > hi));
      } else {
        overflow = (long) cn > hi;
      }
      if (overflow) {
        pfile_log(pf, PFILE_LOG_WARN, "value out of range (%ld:%ld...%ld)",
          (long) cn,
          lo,
          hi);
      }
    } else if (vdef_sz < 32) { /* vdef is unsigned */
      ulong hi;

      hi = (1ul << vdef_sz) - 1;
      overflow = cn > hi;
      if (overflow) {
        if (value_is_signed(val)) {
          pfile_log(pf, PFILE_LOG_WARN, "value out of range (%ld:0...%lu)",
            (long) cn, hi);
        } else {
          pfile_log(pf, PFILE_LOG_WARN, "value out of range (%lu:0...%lu)",
            cn, hi);
        }
      }
    } else {
      overflow = BOOLEAN_FALSE;
    }
  }
  return overflow;
}

static boolean_t pfile_value_overflow_check(pfile_t *pf, 
  operator_t op, value_t val1, value_t val2)
{
  boolean_t overflow;

  overflow = BOOLEAN_FALSE;
  if (value_is_number(val1) 
    && value_is_number(val2)
    && (value_is_universal(val1) || value_is_universal(val2))) {
    if (value_is_universal(val2)) {
      value_t tmp;

      tmp  = val2;
      val2 = val1;
      val1 = tmp;
    }
    (void) pfile_value_def_overflow_check(pf, op, value_def_get(val2), val1);
  }
  return overflow;
}

/* do two things
 *   1. if val2 exists, make sure val1 & val2 are compatible
 *   2. make sure the result of (val1/val2) is compatible with dst
 */
void pfile_value_def_type_check(pfile_t *pf, operator_t op, 
    variable_def_t dst_def, value_t val1, value_t val2)
{
  if (variable_def_type_is_number(variable_def_type_get(dst_def)) 
      && value_is_number(val1)
      && ((VALUE_NONE == val2) || value_is_number(val2))
      && (pfile_flag_test(pf, PFILE_FLAG_WARN_TRUNCATE)
          || pfile_flag_test(pf, PFILE_FLAG_WARN_CONVERSION))) {
    variable_def_t rdef;
    flag_t         warnings;

    warnings = 0; /* assume no warnings */
    rdef = pfile_variable_def_promotion_get(pf, op, val1, val2);
    if (value_is_universal(val2)) {
      value_t tmp;

      tmp  = val1;
      val1 = val2;
      val2 = tmp;
    }
    if (!value_is_universal(val1)) {
      if (((VALUE_NONE != val2) 
              && (value_is_signed(val1) ^ value_is_signed(val2))) 
            || ((VALUE_NONE == val2)
              && (variable_def_flag_test(dst_def, VARIABLE_DEF_FLAG_SIGNED) 
                ^ variable_def_flag_test(rdef, VARIABLE_DEF_FLAG_SIGNED)))) {
        warnings |= PFILE_FLAG_WARN_CONVERSION;
      }
      if (variable_def_sz_get(dst_def) < variable_def_sz_get(rdef)) {
        warnings |= PFILE_FLAG_WARN_TRUNCATE;
      }
    } else {
      /* determine which warnings are appropriate; these are done
       * using a flag to make sure warnings are only reported once
       */
      variable_sz_t val1_bitsz;
      flag_t        val1_flags;
      variable_sz_t dst_bitsz;

      variable_calc_sz_min(value_const_get(val1), &val1_bitsz, 0, 
          &val1_flags);

      val1_bitsz *= 8;  
      /*
       * nb: only warn if the universal is signed, and the other not.
       *     otherwise ``var sbyte xx = 0'' will throw a warning
       */
      if (VALUE_NONE == val2) {
        if (!variable_def_flag_test(dst_def, VARIABLE_DEF_FLAG_SIGNED)
          && value_is_signed(val1)) {
          warnings |= PFILE_FLAG_WARN_CONVERSION;
        }
      } else {
        if (!value_is_signed(val2) && value_is_signed(val1)) {
          warnings |= PFILE_FLAG_WARN_CONVERSION;
        }
      }

      dst_bitsz = variable_def_sz_get(dst_def);
      if (variable_def_flag_test(dst_def, VARIABLE_DEF_FLAG_BIT)) {
        /* 
         * determine how many *bits* are required to hold val1
         * if the topmost bit is 1, subtract the number of 1s on
         *   the left side
         * if the topmost bit is 0, subtract the number of 0s on
         *   the left side
         */
        variable_const_t n;
        ulong            top_bit;

        top_bit = 1UL << (val1_bitsz - 1);

        n = value_const_get(val1);
        if (n & top_bit) {
          while (top_bit && (n & top_bit)) {
            top_bit >>= 1;
            val1_bitsz--;
          }
        } else {
          while (top_bit && !(n & top_bit)) {
            top_bit >>= 1;
            val1_bitsz--;
          }
        }
      } else {
        dst_bitsz *= 8;
      }

      if (dst_bitsz < val1_bitsz) {
        warnings |= PFILE_FLAG_WARN_TRUNCATE;
      }
    }
    if ((warnings & PFILE_FLAG_WARN_TRUNCATE)
      && pfile_flag_test(pf, PFILE_FLAG_WARN_TRUNCATE)) {
      pfile_log(pf, PFILE_LOG_WARN, 
          "assignment to smaller type; truncation possible");
    }
    if ((warnings & PFILE_FLAG_WARN_CONVERSION)
      && pfile_flag_test(pf, PFILE_FLAG_WARN_CONVERSION)) {
      pfile_log(pf, PFILE_LOG_WARN, "signed/unsigned mismatch");
    }
  }
  if (value_is_float(val1) || value_is_float(val2)) {
    /* make sure this is legal for a floating point value */
    switch (op) {
      case OPERATOR_EQ:
      case OPERATOR_NE:
        pfile_log(pf, PFILE_LOG_WARN, 
          "You should not compare floating values for equality");
      case OPERATOR_ADD:
      case OPERATOR_SUB:
      case OPERATOR_MUL:
      case OPERATOR_DIV:
      case OPERATOR_MOD:
      case OPERATOR_LT:
      case OPERATOR_LE:
      case OPERATOR_GE:
      case OPERATOR_GT:
      case OPERATOR_ANDL:
      case OPERATOR_ORL:
      case OPERATOR_NOTL:
      case OPERATOR_ASSIGN:
      case OPERATOR_NEG:
      case OPERATOR_INCR:
      case OPERATOR_DECR:
      case OPERATOR_LOGICAL:
        break;
      case OPERATOR_ANDB:
      case OPERATOR_ORB:
      case OPERATOR_XORB:
      case OPERATOR_CMPB:
      case OPERATOR_SHIFT_LEFT:
      case OPERATOR_SHIFT_RIGHT:
      case OPERATOR_SHIFT_RIGHT_ARITHMETIC:
      case OPERATOR_NULL:
      case OPERATOR_REFERENCE:
      case OPERATOR_DOT:
      case OPERATOR_SUBSCRIPT:
      case OPERATOR_CAST:
      case OPERATOR_CT:
        pfile_log(pf, PFILE_LOG_ERR,
          "Invalid operation");
    }
  }
}

static void pfile_value_type_check(pfile_t *pf, operator_t op, value_t dst,
    value_t val1, value_t val2)
{
  pfile_value_def_type_check(pf, op, value_def_get(dst), val1, val2);
}

/*
 * NAME
 *   pfile_cmd_op_add
 *
 * DESCRIPTION
 *   add an operation
 *
 * PARAMETERS
 *   pf:
 *   label : line label
 *   op    : operation
 *   dst   : destination, can be 0 to allocate a temporary
 *   val1  : value 1 (can be 0 for unary operations, cannot be 0 for binary)
 *   val2  : value 2 (must be 0 for unary, can be 0 for binary)
 *
 * RETURN
 *
 * NOTES
 *   if dst is NULL on entry, it will hold a value on successful exit
 *   if dst is a function
 *     *error*
 *   if dst is a reference
 *     if *dst is a function
 *       src must be a function with a matching signature
 */
void pfile_cmd_op_add_assign(pfile_t *pf, operator_t op,
  value_t *pdst, value_t src)
{
  if (!*pdst 
    && (OPERATOR_ASSIGN == op) 
    && value_is_const(src)
    && value_is_number(src)) {
    *pdst = pfile_constant_get(pf, value_const_get(src),
      value_def_get(src));
  } else {
    value_t dst;

    dst = *pdst;
    if (!dst) {
      assert(VARIABLE_DEF_TYPE_FUNCTION != value_type_get(src));
      dst = pfile_value_temp_get_from_def(pf, value_def_get(src));
      *pdst = dst;
    }
    /* assignment is allowed between variables that are logically
       the same (the definitions match), and between any two
       numbers */
    if ((variable_def_is_same(value_def_get(dst), value_def_get(src)))
      || (value_is_number(dst) && value_is_number(src))) {
      cmd_t cmd;

      cmd = cmd_op_alloc(op, dst, src, VALUE_NONE);
      pfile_cmd_add(pf, cmd);
    } else if (value_is_pointer(dst) 
      && value_is_array(src)
      && variable_def_is_same(variable_def_member_def_get(
        variable_def_member_get(value_def_get(dst))),
          variable_def_member_def_get(variable_def_member_get(
          value_def_get(src))))) {
      /* assign array to pointer */
      cmd_t cmd;

      cmd = cmd_op_alloc(op, dst, src, VALUE_NONE);
      pfile_cmd_add(pf, cmd);
    } else if (value_is_pointer(dst) 
      && value_is_function(src)
      && variable_def_is_same(variable_def_member_def_get(
        variable_def_member_get(value_def_get(dst))),
          value_def_get(src))) {
      /* assign function to pointer */
      cmd_t cmd;

      cmd = cmd_op_alloc(op, dst, src, VALUE_NONE);
      pfile_cmd_add(pf, cmd);
    } else {
      pfile_log(pf, PFILE_LOG_ERR, "invalid operation");
    }
  }
}

static void pfile_cmd_op_add_unary(pfile_t *pf, operator_t op,
    value_t *pdst, value_t src)
{
  value_t dst;

  if (!value_is_number(src)) {
    pfile_log(pf, PFILE_LOG_ERR, "invalid operation");
  } else if (!*pdst && value_is_const(src)) {
    pf_const_t n;

    n = pfile_op_const_exec(pf, op, src, VALUE_NONE);
    if (value_is_bit(src)) {
      n.u.n &= (1 << value_sz_get(src)) - 1;
    }
    *pdst = pf_const_to_const(pf, n, value_def_get(src));
  } else {
    cmd_t cmd;

    dst = *pdst;
    if (!dst) {
      dst = pfile_value_temp_get_from_def(pf, 
          pfile_variable_def_promotion_get(pf, op, src, VALUE_NONE));
      *pdst = dst;
    }
    /* see nb about volatile in add_binary */
    cmd = cmd_op_alloc(op, dst, src, VALUE_NONE);
    pfile_cmd_add(pf, cmd);
  }
}
/*
  (1) if both operands are the same type
        no conversion is done
  (2) if both operands are signed
        the operand of lesser width is promoted to the operand of greater width
  (3) if the operand that is unsigned has a greater or equal width than the 
        signed, the signed operand is converted to the unsigned type
  (4) if the operand that is signed can represent all values of the operand 
        that is unsigned, the unsigned operand is converted to the signed
  (5) failing all else, both operands are converted to the unsigned integer 
        type with the same width as the signed operand
 */
static void pfile_cmd_op_add_binary(pfile_t *pf, operator_t op,
    value_t *pdst, value_t val1, value_t val2)
{
  if (!*pdst 
    && (value_is_const(val1) && !value_is_lookup(val1))
    && value_is_number(val1) 
    && (value_is_const(val2) && !value_is_lookup(val2))
    && value_is_number(val2)) {
    variable_def_t   def;
    pf_const_t       n;

    n.type = PF_CONST_TYPE_NONE;
    def = pfile_variable_def_promotion_get(pf, op, val1, val2);
    n = pfile_op_const_exec(pf, op, val1, val2);
    *pdst = pf_const_to_const(pf, n, def);
  } else {
    value_t dst;

    dst = *pdst;
    if ((!value_is_number(val1) || !value_is_number(val2))
      && ((OPERATOR_EQ != op) || (OPERATOR_NE != op))) {
      pfile_log(pf, PFILE_LOG_ERR, "invalid operation");
    } else {
      variable_def_t rdef; /* result */
      cmd_t          cmd;

      if (!value_is_number(val1)) {
        /* the result is a byte */

        rdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER, 
            VARIABLE_DEF_FLAG_NONE, 1);
      } else {
        rdef = pfile_variable_def_promotion_get(pf, op, val1, val2);
      }
      if (!dst) {
        dst = pfile_value_temp_get_from_def(pf, rdef);
        *pdst = dst;
      }
      /* nb: if dst is volatile, the work must be done in a temporary
             *but* this needs to be left to the backend because some
             operations can be optimized at a lower level */
      cmd = cmd_op_alloc(op, dst, val1, val2);
      pfile_cmd_add(pf, cmd);
    }
  }
}

void pfile_cmd_op_add(pfile_t *pf,
  operator_t op, value_t *pdst, value_t val1, value_t val2)
{
  value_t  dst;
  result_t rc;

  rc = RESULT_OK;

  dst = (pdst) ? *pdst : VALUE_NONE;

  /* check val1 and/or val2 for strings. currently
     strings cannot be used as operators for any expression

     *except* assignment!
   */
  if ((OPERATOR_ASSIGN != op)
    || !value_def_is_same(*pdst, val1)) {
    if (!pfile_expr_string_fix(pf, val1)) {
      rc = RESULT_INVALID;
    } else if (! pfile_expr_string_fix(pf, val2)) {
      rc = RESULT_INVALID;
    }
  }
  if (RESULT_OK == rc) {
    /* 1st, make sure val1 and/or val2 exit */
    if (operator_is_binary(op)) {
      assert(val1 != VALUE_NONE);
      assert((val2 != VALUE_NONE) || (dst != VALUE_NONE));
      if (!val2) {
        val2 = val1;
        val1 = dst;
      }
    } else if (operator_is_unary(op)) {
      assert(val1 || dst);
      if (!val1) {
        val1 = dst;
      }
    }
    value_lock(val1);
    value_lock(val2);

    /* non-numbers only allow:
     *   assign to 0
     *   assign to like type
     *   equal (of like type)
     *   not equal (of like type)
     */   
    pfile_value_type_check(pf, op, dst, val1, val2);
    if (dst && value_is_const(dst) && !value_name_get(dst)) {
      dst = VALUE_NONE;
    }
    /* check for an invalid read or write.
     * VARIABLE_FLAG_[READ|WRITE] are not fully implemented yet
     * so this is kind of a hack. For dst, if READ is set and
     * not WRITE issue an error. For val[1|2], if WRITE is set
     * and not READ issue an error. */
    if (value_vflag_test(dst, VARIABLE_FLAG_READ)
      && !value_vflag_test(dst, VARIABLE_FLAG_WRITE)) {
      pfile_log(pf, PFILE_LOG_ERR, "cannot write to %s",
        value_name_get(dst));
    } else if (value_vflag_test(val1, VARIABLE_FLAG_WRITE)
      && !value_vflag_test(val1, VARIABLE_FLAG_READ)) {
      pfile_log(pf, PFILE_LOG_ERR, "cannot read from %s",
        value_name_get(val1));
    } else if (value_vflag_test(val2, VARIABLE_FLAG_WRITE)
      && !value_vflag_test(val2, VARIABLE_FLAG_READ)) {
      pfile_log(pf, PFILE_LOG_ERR, "cannot read from %s",
        value_name_get(val2));
    } else if (dst && (value_is_const(dst) || value_is_lookup(dst))) {
      pfile_log(pf, PFILE_LOG_ERR, "assign to constant");
    } else if (OPERATOR_NULL == op) {
    } else if (operator_is_assign(op)) {
      (void) pfile_value_overflow_check(pf, op, dst, val1);
      if (!(val1 || val2)) {
        pfile_log(pf, PFILE_LOG_ERR, "value missing");
      } else {
        pfile_cmd_op_add_assign(pf, op, &dst, val1);
      }
    } else if (operator_is_unary(op)) {
      if (val2 || !(val1 || dst)) {
        pfile_log(pf, PFILE_LOG_ERR, "value missing");
      } else {
        assert(val2 == 0);
        assert(val1 || dst);
        if (!val1) {
          val1 = dst;
        }
        pfile_cmd_op_add_unary(pf, op, &dst, val1);
      }
    } else { /* op_is_binary! */
      if (!val1 || !(val2 || dst)) {
      } else {
        relation_result_t result;

        assert(val1 != 0);
        assert(val2 || dst);
        if (!val2) {
          val2 = val1;
          val1 = dst;
        }
        result = RELATION_RESULT_UNKNOWN;
        if (operator_is_relation(op)) {
          result = pfile_expr_relation_check(pf, op, val1, val2);
        } else {
          (void) pfile_value_overflow_check(pf, op, val1, val2);
        }
        switch (result) {
          case RELATION_RESULT_UNKNOWN:
            pfile_cmd_op_add_binary(pf, op, &dst, val1, val2);
            break;
          case RELATION_RESULT_TRUE:
          case RELATION_RESULT_FALSE:
            value_release(val1);
            val1 = pfile_constant_get(pf, (result == RELATION_RESULT_TRUE),
              pfile_variable_def_promotion_get(pf, op, val1, val2));
            pfile_cmd_op_add_assign(pf, OPERATOR_ASSIGN, &dst, val1);
            break;
        }
      }
    }

    value_release(val1);
    value_release(val2);
    if (pdst) {
      if (dst != *pdst) {
        if (*pdst) {
          value_release(*pdst);
        }
        *pdst = dst;
      }
    } else if (dst) {
      value_release(dst);
    }
  }
}

/*
 * I messed up awhile ago and need this hack. '"'...'"' can create
 * either a single character or a string. Unfortunately, there's no
 * way to determine it is supposed to be until much later. So, if it
 * is determined that a character was required, this will change the
 * value as appropriate
 *   return BOOLEAN_TRUE on success, or BOOLEAN_FALSE on failure
 */
boolean_t pfile_expr_string_fix(pfile_t *pf, value_t val)
{
  boolean_t rc;

  rc = BOOLEAN_TRUE;
  if (value_is_array(val)
    && value_is_string(val)) {
    if (1 != value_ct_get(val)) {
      pfile_log(pf, PFILE_LOG_ERR, "type mismatch");
      rc = BOOLEAN_FALSE;
    }
    value_dereference(val);
  }
  return rc;
}


