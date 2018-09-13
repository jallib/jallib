/**********************************************************
 **
 ** cmd_op.c : the CMD_TYPE_OPERATOR functions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <assert.h>
#include "cmdd.h"
#include "cmd_op.h"

/* expression, dst = val1 op val2 */
static void cmd_op_dump(cmd_t cmd, FILE *dst)
{
  fprintf(dst, "%s ", operator_to_str(cmd_optype_get(cmd)));
  if (cmd_opdst_get(cmd) || cmd_opval1_get(cmd)) {
    if (cmd_opdst_get(cmd)) {
      value_dump(cmd_opdst_get(cmd), dst);
    }
    if (cmd_opval1_get(cmd)) {
      fprintf(dst, ", ");
      value_dump(cmd_opval1_get(cmd), dst);
      if (cmd_opval2_get(cmd)) {
        fprintf(dst, ", ");
        value_dump(cmd_opval2_get(cmd), dst);
      }
    }
  }
}

static void cmd_op_free(cmd_t cmd)
{
  cmd_opdst_set(cmd, 0);
  cmd_opval1_set(cmd, 0);
  cmd_opval2_set(cmd, 0);
}

static cmd_t cmd_op_dup(const cmd_t cmd)
{
  return cmd_op_alloc(cmd_optype_get(cmd),
      cmd_opdst_get(cmd), cmd_opval1_get(cmd),
      cmd_opval2_get(cmd));
}

static void cmd_op_variable_remap(cmd_t cmd, const variable_map_t *map)
{
  cmd_variable_remap2(cmd, map, cmd_opdst_get, cmd_opdst_set);
  cmd_variable_remap2(cmd, map, cmd_opval1_get, cmd_opval1_set);
  cmd_variable_remap2(cmd, map, cmd_opval2_get, cmd_opval2_set);
}

static void cmd_op_value_remap(cmd_t cmd, const value_map_t *map)
{
  cmd_value_remap2(cmd, map, cmd_opdst_get, cmd_opdst_set);
  cmd_value_remap2(cmd, map, cmd_opval1_get, cmd_opval1_set);
  cmd_value_remap2(cmd, map, cmd_opval2_get, cmd_opval2_set);
}

static flag_t cmd_op_variable_accessed(const cmd_t cmd, variable_t var)
{
  flag_t flags;

  flags = CMD_VARIABLE_ACCESS_FLAG_NONE;
  if (var == value_variable_get(cmd_opdst_get(cmd))) {
    flags |= CMD_VARIABLE_ACCESS_FLAG_WRITTEN;
  }
  if ((var == value_variable_get(cmd_opval1_get(cmd)))
    || (var == value_variable_get(cmd_opval2_get(cmd)))) {
    flags |= CMD_VARIABLE_ACCESS_FLAG_READ;
  }
  return flags;
}

static flag_t cmd_op_value_accessed(const cmd_t cmd, value_t val)
{
  flag_t flags;

  flags = CMD_VARIABLE_ACCESS_FLAG_NONE;
  if (val == cmd_opdst_get(cmd)) {
    flags |= CMD_VARIABLE_ACCESS_FLAG_WRITTEN;
  }
  if ((val == cmd_opval1_get(cmd))
    || (val == cmd_opval2_get(cmd))) {
    flags |= CMD_VARIABLE_ACCESS_FLAG_READ;
  }
  return flags;
}

static void cmd_op_assign_used_set(cmd_t cmd)
{
  cmd_gen_add(cmd, value_variable_get(cmd_opval1_get(cmd)));
  cmd_gen_add(cmd, value_variable_get(cmd_opval2_get(cmd)));
  cmd_kill_add(cmd, value_variable_get(cmd_opdst_get(cmd)));
}

static const cmd_vtbl_t cmd_op_vtbl = {
  cmd_op_free,
  cmd_op_dump,
  cmd_op_dup,
  0, /* no label remap */
  cmd_op_variable_remap,
  cmd_op_value_remap,
  cmd_op_variable_accessed,
  cmd_op_value_accessed,
  cmd_op_assign_used_set,
  0 /* use default successor set */
};

cmd_t cmd_op_alloc(operator_t op,
  value_t dst, value_t val1, value_t val2)
{
  cmd_t cmd;

  cmd = cmd_alloc(CMD_TYPE_OPERATOR, &cmd_op_vtbl);
  if (cmd) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      ptr->u.op.op   = op;
      ptr->u.op.dst  = 0;
      ptr->u.op.val1 = 0;
      ptr->u.op.val2 = 0;

      cmd_opdst_set(cmd, dst);
      cmd_opval1_set(cmd, val1);
      cmd_opval2_set(cmd, val2);
    }
  }
  return cmd;
}


/* operator operations */
operator_t cmd_optype_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr && (CMD_TYPE_OPERATOR == cmd_type_get(cmd)))
    ? ptr->u.op.op
    : OPERATOR_NULL;
}

void cmd_optype_set(cmd_t cmd, operator_t op)
{
  if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      ptr->u.op.op = op;
    }
  }
}

value_t cmd_opdst_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr && (CMD_TYPE_OPERATOR == cmd_type_get(cmd)))
    ? ptr->u.op.dst
    : 0;
}

void cmd_opdst_set(cmd_t cmd, value_t dst)
{
  if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      if (dst) {
        value_assign_ct_bump(dst, CTR_BUMP_INCR);
        value_lock(dst);
      }
      if (ptr->u.op.dst) {
        variable_uses_remove(value_variable_get(ptr->u.op.dst),
          value_variable_get(ptr->u.op.val1));
        variable_uses_remove(value_variable_get(ptr->u.op.dst),
          value_variable_get(ptr->u.op.val2));
        value_assign_ct_bump(ptr->u.op.dst, CTR_BUMP_DECR);
        value_release(ptr->u.op.dst);
      }
      ptr->u.op.dst = dst;
      variable_uses_add(value_variable_get(dst),
        value_variable_get(ptr->u.op.val1));
      variable_uses_add(value_variable_get(dst),
        value_variable_get(ptr->u.op.val2));
    }
  }
}

value_t cmd_opval1_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr && (CMD_TYPE_OPERATOR == cmd_type_get(cmd)))
    ? ptr->u.op.val1
    : 0;
}

void cmd_opval1_set(cmd_t cmd, value_t val1)
{
  if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      if (val1) {
        pfile_proc_t *proc;

        proc = value_proc_get(val1);
        if (proc) {
          pfile_proc_flag_set(proc, PFILE_PROC_FLAG_INDIRECT);
        }

        value_lock(val1);
        value_use_ct_bump(val1, CTR_BUMP_INCR);
      }
      if (ptr->u.op.val1) {
        value_use_ct_bump(ptr->u.op.val1, CTR_BUMP_DECR);
        value_release(ptr->u.op.val1);
        variable_uses_remove(value_variable_get(ptr->u.op.dst),
          value_variable_get(ptr->u.op.val1));
      }
      ptr->u.op.val1 = val1;
      variable_uses_add(value_variable_get(ptr->u.op.dst),
        value_variable_get(val1));
    }
  }
}

value_t cmd_opval2_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr && (CMD_TYPE_OPERATOR == cmd_type_get(cmd)))
    ? ptr->u.op.val2
    : 0;
}

void cmd_opval2_set(cmd_t cmd, value_t val2)
{
  if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      if (val2) {
        value_lock(val2);
        value_use_ct_bump(val2, CTR_BUMP_INCR);
      }
      if (ptr->u.op.val2) {
        value_use_ct_bump(ptr->u.op.val2, CTR_BUMP_DECR);
        value_release(ptr->u.op.val2);
        variable_uses_remove(value_variable_get(ptr->u.op.dst),
          value_variable_get(ptr->u.op.val2));
      }
      ptr->u.op.val2 = val2;
      variable_uses_add(value_variable_get(ptr->u.op.dst),
        value_variable_get(val2));
    }
  }
}

/*
 * NAME
 *   cmd_op_cleanup
 *
 * DESCRIPTION
 *   cleanup an operator
 *
 * PARAMETERS
 *   cmd        : command
 *   value_zero : constant value 0
 *   value_one  : constant value 1 
 *
 * RETURN
 *   RESULT_OK
 *   RESULT_DIVIDE_BY_ZERO
 *   RESULT_RANGE : a shift is out of range for the type
 *
 * NOTES
 *   This does a few different things:
 *     1. the constant is *always* on the right for commutative
 *        operators and relations
 *     2. reduce the following identities:
 *       x = x -- nop
 *       x + 0 -- nop
 *       x - 0 -- nop
 *       0 - x = -x
 *       x - x = 0
 *       x * 1 -- nop
 *       x * 0  = 0
 *       x * -1 = -x
 *       x / 1 -- nop
 *       x / -1 = -x
 *       x / 0 = err
 *       0 / x = 0
 *       x % 0 = 0
 *       x % 1 = 0
 *       x <  0, x unsigned --> 0
 *       x <= 0, x unsigned --> x == 0
 *       x >= 0, x unsigned --> 1
 *       x >  0, x unsigned --> x != 0
 *       x && 0 = 0
 *       x && x = !!x
 *       x || 0 = !!x
 *       x || x = !!x
 *       x & 0  = 0
 *       x & x  = x 
 *       x | 0  = x
 *       x | x  = x 
 *       x ^ 0  = x
 *       x ^ x  = 0
 *       0 << # = 0
 *       x << 0 = x
 *       x << # = 0 if # >= bits in x
 *       0 >> # = 0
 *       x >> 0 = x
 *       x >> # = 0 if # >= bits in x
 *       x == 0 = !x
 *       x != 0 = !!x
 *       x == 1 = x iff x is single bit
 *       x != 1 = !x iff x is single bit
 */
static boolean_t value_const_cmp(const value_t val, variable_const_t n)
{
  return value_is_const(val)
      && (value_const_get(val) == n);
}

static boolean_t value_is_unsigned(const value_t val)
{
  return !value_dflag_test(val, VARIABLE_DEF_FLAG_SIGNED);
}


result_t cmd_op_reduction(cmd_t cmd, value_t value_zero, value_t value_one)

{
  result_t   rc;

  rc   = RESULT_OK;
  if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
    operator_t     op;
    value_t        val1;
    value_t        val2;
    variable_sz_t  rsz;

    op   = cmd_optype_get(cmd);
    val1 = cmd_opval1_get(cmd);
    val2 = cmd_opval2_get(cmd);

    rsz = (value_sz_get(val1) < value_sz_get(val2))
      ? value_sz_get(val2)
      : value_sz_get(val1);

    if (value_is_const(val1)
        && (operator_is_commutative(op)
          || operator_is_relation(op))) {
      /* swap val1 & val2 */
      value_t tmp;

      tmp  = val1;
      val1 = val2;
      val2 = tmp;
      /* if it's a relation, swap the relation */
      switch (op) {
        case OPERATOR_LT: op = OPERATOR_GT; break;
        case OPERATOR_LE: op = OPERATOR_GE; break;
        case OPERATOR_GE: op = OPERATOR_LE; break;
        case OPERATOR_GT: op = OPERATOR_LT; break;
        default:
          break;
      }
      /* i need to lock/unlock these as setting them could cause
       * the counts to go to zero prematurely */
      value_lock(val1);
      value_lock(val2);
      cmd_opval1_set(cmd, val1);
      cmd_opval2_set(cmd, val2);
      value_release(val1);
      value_release(val2);
    }

    switch (op) {
      case OPERATOR_NULL:
      case OPERATOR_REFERENCE:
      case OPERATOR_CAST:
      case OPERATOR_DOT:
      case OPERATOR_SUBSCRIPT:
      case OPERATOR_CT:
        break;
      case OPERATOR_ADD:
        if (value_const_cmp(val2, 0)) {
          /* x + 0 --> x */
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        }
        break;
      case OPERATOR_SUB:
        if (value_const_cmp(val2, 0)) {
          /* x - 0 --> x */
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        } else if (value_const_cmp(val1, 0)) {
          /* 0 - x --> -x */
          val1 = val2;
          val2 = VALUE_NONE;
          op   = OPERATOR_NEG;
        } else if (value_is_same(val1, val2)) {
          op   = OPERATOR_ASSIGN;
          val1 = value_zero;
          val2 = VALUE_NONE;
        }
        break;
      case OPERATOR_MUL:
        if (value_const_cmp(val2, 0)) {
          /* x * 0 --> 0 */
          val1 = value_zero;
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        } else if (value_const_cmp(val2, 1)) {
          /* x * 1 --> x */
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        } else if (value_const_cmp(val2, -1)) {
          val2 = VALUE_NONE;
          op   = OPERATOR_NEG;
        }
        break;
      case OPERATOR_DIV:
        if (value_const_cmp(val2, 0)) {
          /* x / 0 --> *err* */
          rc = RESULT_DIVIDE_BY_ZERO;
        } else if (value_const_cmp(val2, 1)) {
          /* x / 1 --> x */
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        } else if (value_const_cmp(val1, 0)) {
          /* 0 / x --> 0 */
          val1 = value_zero;
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        } else if (value_const_cmp(val2, -1)) {
          val2 = VALUE_NONE;
          op   = OPERATOR_NEG;
        }
        break;
      case OPERATOR_MOD:
        if (value_const_cmp(val2, 0) || value_const_cmp(val2, 1)) {
          /* x % 0 --> 0 */
          /* x % 1 --> 0 */
          val1 = value_zero;
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        }
        break;
      case OPERATOR_LT:
        if (value_is_unsigned(val1) && value_const_cmp(val2, 0)) {
          /* x < 0, x unsigned --> 0 */
          val1 = value_zero;
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        }
        break;
      case OPERATOR_LE:
        if (value_is_unsigned(val1) && value_const_cmp(val2, 0)) {
          /* x <= 0, x unsigned --> x == 0 */
          val2 = VALUE_NONE;
          op   = OPERATOR_NOTL;
        }
        break;
      case OPERATOR_EQ:
      case OPERATOR_NE:
        if (value_is_const(val2)) {
          if (0 == value_const_get(val2)) {
            /* x == 0, or x != 0 */
            val2 = VALUE_NONE;
            op = (OPERATOR_EQ == op)
              ? OPERATOR_NOTL
              : OPERATOR_LOGICAL;
          } else if (value_is_single_bit(val1)
            && (1 == value_const_get(val2))) {
            /* single bit == 1 or single bit != 1 */
            val2 = VALUE_NONE;
            op = (OPERATOR_EQ == op)
              ? OPERATOR_LOGICAL
              : OPERATOR_NOTL;
          }
        }
        break;
      case OPERATOR_GE:
        if (value_is_unsigned(val1) && value_const_cmp(val2, 0)) {
          /* x >= 0, x unsigned --> x = 1 */
          val1 = value_one;
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        }
        break;
      case OPERATOR_GT:
        if (value_is_unsigned(val1) && value_const_cmp(val2, 0)) {
          /* x > 0, x unsigned --> x != 0 */
          op = OPERATOR_NE;
        }
        break;
      case OPERATOR_ANDL:
        if (value_const_cmp(val2, 0)) {
          /* x && 0 --> 0 */
          val1 = value_zero;
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        } else if (val1 == val2) {
          /* x && x --> !!x */
          val2 = VALUE_NONE;
          op   = OPERATOR_LOGICAL;
        }
        break;
      case OPERATOR_ORL:
        if (value_const_cmp(val2, 0) || (val1 == val2)) {
          /* x || 0 --> !!x */
          /* x || x --> !!x */
          val2 = VALUE_NONE;
          op   = OPERATOR_LOGICAL;
        }
        break;
      case OPERATOR_NOTL: /* unary */
        break;
      case OPERATOR_ANDB:
        if (value_const_cmp(val2, 0)) {
          /* x & 0 --> 0 */
          val1 = value_zero;
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        } else if (val1 == val2) {
          /* x & x --> x */
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        }
        break;
      case OPERATOR_ORB:
        if (value_const_cmp(val2, 0) || (val1 == val2)) {
          /* x | 0 --> x */
          /* x | x --> x */
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        }
        break;
      case OPERATOR_XORB:
        if (value_const_cmp(val2, 0)) {
          /* x ^ 0 --> x */
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        } else if (val1 == val2) {
          /* x ^ x --> 0 */
          val1 = value_zero;
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        }
        break;
      case OPERATOR_CMPB: /* unary */
        break;
      case OPERATOR_NEG:     /* unary */
        if ((VARIABLE_DEF_TYPE_BOOLEAN == value_type_get(val1))
          || value_is_single_bit(val1)) {
          /* this is a no-op */
          cmd_optype_set(cmd, OPERATOR_ASSIGN);
        }
        break;
          
      case OPERATOR_ASSIGN:  /* unary */
      case OPERATOR_INCR:    /* unary */
      case OPERATOR_DECR:    /* unary */
        break;
      case OPERATOR_SHIFT_LEFT:
      case OPERATOR_SHIFT_RIGHT:
      case OPERATOR_SHIFT_RIGHT_ARITHMETIC:
        if (value_const_cmp(val1, 0)) {
          /* 0 << x --> 0 */
          val1 = value_zero;
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        } else if (value_const_cmp(val2, 0)) {
          /* x << 0 --> x */
          val2 = VALUE_NONE;
          op   = OPERATOR_ASSIGN;
        } else if (value_is_const(val2)
            && (value_const_get(val2) >= 8UL * rsz)) {
          op = OPERATOR_ASSIGN;
          rc = RESULT_RANGE;
        }
        break;
      case OPERATOR_LOGICAL:  /* unary : convert a value to either 0 or 1 */
        break;
    }
    cmd_optype_set(cmd, op);
    cmd_opval1_set(cmd, val1);
    cmd_opval2_set(cmd, val2);
  }
  return rc;
}

boolean_t cmd_op_is_assign(operator_t op, value_t val1, value_t val2)
{
  boolean_t rc;

  if (operator_is_unary(op)) {
    rc = val1 != 0;
  } else if (operator_is_binary(op)) {
    rc = (val1 != 0) && (val2 != 0);
  } else {
    rc = operator_is_assign(op);
  }
  return rc;
}

