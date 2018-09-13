/**********************************************************
 **
 ** jal_expr.c : JAL expression parsing
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <string.h>
#include "../libutils/mem.h"
#include "../libcore/pf_expr.h"
#include "jal_proc.h"
#include "jal_tokn.h"
#include "jal_vdef.h"
#include "jal_expr.h"

static void jal_val_baseofs_add(pfile_t *pf, value_t val, value_t ofs)
{
  value_t baseofs;

  baseofs = value_baseofs_get(val);
  if (VALUE_NONE == baseofs) {
    value_baseofs_set(val, ofs);
  } else if (value_is_const(baseofs) && value_is_const(ofs)) {
    value_t cval;

    cval = pfile_constant_get(pf,
        value_const_get(baseofs) + value_const_get(ofs),
        VARIABLE_DEF_NONE);
    value_baseofs_set(val, cval);
    value_release(cval);
  } else {
    value_t tmp;

    tmp = VALUE_NONE;
    pfile_cmd_op_add(pf, OPERATOR_ADD, &tmp, baseofs, ofs);
    value_baseofs_set(val, tmp);
    value_release(tmp);
  }
}

boolean_t jal_parse_subscript(pfile_t *pf, value_t *pval)
{
  boolean_t rc;
  value_t   val;

  rc  = BOOLEAN_FALSE;
  val = *pval;
  if ((value_is_array(val) || value_is_pointer(val))
    && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "[")) {
      value_t n;

      rc = BOOLEAN_TRUE;
      pf_token_get(pf, PF_TOKEN_NEXT);
      n = jal_parse_expr(pf);
      if (n) {
        /* n *= sz */
        value_t          tmp;
        variable_const_t bound;

        bound = value_is_array(val)
          ? value_ct_get(val)
          : (variable_const_t) -1;
        value_use_ct_bump(val, CTR_BUMP_INCR);
        tmp = value_clone(val);
        value_dereference(tmp);
        value_release(val);
        val = tmp;

        if (value_is_const(n)) {
          variable_const_t nc;

          nc = value_const_get(n);
          if (nc >= bound) {
            pfile_log(pf, PFILE_LOG_ERR, "subscript out of range");
          } else {
            nc = nc * value_sz_get(val);
            value_release(n);
            n = pfile_constant_get(pf, nc, VARIABLE_DEF_NONE);
            jal_val_baseofs_add(pf, val, n);
          }
        } else {
          if (variable_def_flag_test(value_def_get(val),
               VARIABLE_DEF_FLAG_UNIVERSAL)) {
            pfile_log(pf, PFILE_LOG_ERR, 
                "universal typed arrays require a constant subscript");
          } else {
            if (1 == value_sz_get(val)) {
              tmp = n;
              value_lock(tmp);
            } else {
              value_t sz;
              sz = pfile_constant_get(pf, value_sz_get(val), 
                  VARIABLE_DEF_NONE);
              tmp = VALUE_NONE;
              pfile_cmd_op_add(pf, OPERATOR_MUL, &tmp, n, sz);
              value_release(sz);
            }
            jal_val_baseofs_add(pf, val, tmp);
            value_release(tmp);
          }
        }
        value_release(n);
        *pval = val;
      }
      if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "]")) {
        pf_token_get(pf, PF_TOKEN_NEXT);
      }
    }
    return rc;
}

boolean_t jal_parse_structure(pfile_t *pf, value_t *pval)
{
  boolean_t rc;
  value_t   val;

  rc  = BOOLEAN_FALSE;
  val = *pval;
  if (value_is_structure(val) 
    && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ".")) {
    const char            *ptr;
    variable_def_t         vdef;
    variable_def_member_t  mbr;
    size_t                 ofs;

    rc   = BOOLEAN_TRUE;
    vdef = value_def_get(val);
    ptr  = pf_token_get(pf, PF_TOKEN_NEXT);
    for (ofs = 0, mbr = variable_def_member_get(vdef);
         mbr && strcmp(variable_def_member_tag_get(mbr), ptr);
         ofs += variable_def_member_sz_get(mbr),
           mbr = variable_def_member_link_get(mbr))
      ; /* null body */
    if (!mbr) {
      pfile_log(pf, PFILE_LOG_ERR, "No member named \"%s\"",
        ptr);
    } else {
      value_t n;

      value_def_set(val, variable_def_member_def_get(mbr));
      n = pfile_constant_get(pf, ofs, VARIABLE_DEF_NONE);
      jal_val_baseofs_add(pf, val, n);
      value_release(n);
    }
    pf_token_get(pf, PF_TOKEN_NEXT);
  }
  return rc;
}

value_t jal_parse_value(pfile_t *pf, jal_parse_value_type_t type)
{
  const char    *ptr;
  value_t        val;
  variable_def_t cast_def;

  ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
  cast_def = pfile_variable_def_find(pf, PFILE_LOG_NONE, ptr);
  if (cast_def) {
    pf_token_get(pf, PF_TOKEN_NEXT);
    if ((VARIABLE_DEF_TYPE_INTEGER == variable_def_type_get(cast_def))
          && !variable_def_flag_test(cast_def, VARIABLE_DEF_FLAG_BIT)
          && (1 == variable_def_sz_get(cast_def))
          && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "*")) {
      value_t cval;

      pf_token_get(pf, PF_TOKEN_NEXT);
      cval = jal_parse_expr(pf);
      if (!value_is_const(cval)) {
        pfile_log(pf, PFILE_LOG_ERR, "constant expression expected");
        value_release(cval);
      } else {
        cast_def = variable_def_alloc(0,
            variable_def_type_get(cast_def),
            variable_def_flags_get_all(cast_def),
            value_const_get(cval));
      }
      value_release(cval);
    }
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "(")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    val = jal_parse_expr(pf);
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, ")")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    if (val) {
      boolean_t in_temp;

      if (value_is_float(val) 
        ^ (VARIABLE_DEF_TYPE_FLOAT == variable_def_type_get(cast_def))) {
        /* casting to/from float, must be done in a temp! */
        in_temp = BOOLEAN_TRUE;
      } else {
        variable_sz_t val_sz;
        variable_sz_t cast_sz;

        val_sz = value_sz_get(val);
        if (!value_is_bit(val)) {
          val_sz *= 8;
        }
        cast_sz = variable_def_sz_get(cast_def);
        if (!variable_def_flag_test(cast_def, VARIABLE_DEF_FLAG_BIT)) {
          cast_sz *= 8;
        }
        if ((val_sz >= cast_sz) || value_is_const(val)) {
          if (value_is_const(val)) {
            cast_def = variable_def_flags_change(cast_def, 
                          variable_def_flags_get_all(cast_def)
                          | VARIABLE_DEF_FLAG_CONST);
          }
          value_def_set(val, cast_def);
          in_temp = BOOLEAN_FALSE;
        } else {
          in_temp = BOOLEAN_TRUE;
        }
      }
      if (in_temp) {
        /* if we're casting to a larger value, we need to sock this
         * away into a temporary */
        value_t tmp;

        tmp = pfile_value_temp_get(pf, variable_def_type_get(cast_def),
            variable_def_sz_get(cast_def));
        value_def_set(tmp, cast_def);
        pfile_cmd_op_add_assign(pf, OPERATOR_ASSIGN, &tmp, val);
        value_release(val);
        val = tmp;
      }
    }
  } else {
    value_t   jvals[JAL_VAL_TYPE_CT];
    boolean_t jval_found;
    flag_t    parse_flags;

    parse_flags = JAL_PARSE_CALL_FLAG_NONE;
    jval_found = jal_value_find(pf, ptr, jvals);
    if (JAL_PARSE_VALUE_TYPE_RVALUE == type) {
      value_release(jvals[JAL_VAL_TYPE_PUT]);
      jvals[JAL_VAL_TYPE_PUT] = VALUE_NONE;
      value_release(jvals[JAL_VAL_TYPE_IPUT]);
      jvals[JAL_VAL_TYPE_IPUT] = VALUE_NONE;
    } else if (JAL_PARSE_VALUE_TYPE_LVALUE == type) {
      value_release(jvals[JAL_VAL_TYPE_GET]);
      jvals[JAL_VAL_TYPE_GET] = VALUE_NONE;
      value_release(jvals[JAL_VAL_TYPE_IGET]);
      jvals[JAL_VAL_TYPE_IGET] = VALUE_NONE;
    }
    val = VALUE_NONE;
    if (jval_found) {
      if (jvals[JAL_VAL_TYPE_GET]) {
        val = jvals[JAL_VAL_TYPE_GET];
        if (VARIABLE_DEF_TYPE_POINTER == value_type_get(val)) {
          value_dereference(val);
        }
        parse_flags = JAL_PARSE_CALL_FLAG_GET;
      } else if (jvals[JAL_VAL_TYPE_BASE]) {
        val = jvals[JAL_VAL_TYPE_BASE];
      } else if (jvals[JAL_VAL_TYPE_PUT]) {
        pfile_log(pf, PFILE_LOG_ERR, 
            "Attempted read from an OUT volatile parameter (%s)", ptr);
      }
    }
    if (val) {
      value_lock(val);
      pf_token_get(pf, PF_TOKEN_NEXT);
      if (VARIABLE_DEF_TYPE_FUNCTION == value_type_get(val)) {
        value_t tval;

        tval = jal_parse_call(pf, val, parse_flags);
        value_release(val);
        val = tval;
        if (!tval) {
          pfile_log(pf, PFILE_LOG_ERR, "no return value");
        }
      }
    }
    jal_value_release(jvals);
  }
  return val;
}

/*
 * NAME
 *   value_get
 *
 * DESCRIPTION
 *   get an expression's value
 *
 * PARAMETERS
 *   pf    : return from pfile_open()
 *   var   : [out] holds result
 *
 * RETURN
 *
 * NOTES
 */
static value_t value_get(pfile_t *pf)
{
  value_t     val;

  /* valid values: 
       constant ('%' or '$' or decimal #)
       variable name (alpha + alpha|digit|'_')
       '(' -- subfunction
       '!' -- logical NOT
       '-' -- negation (two's complement)
       '~' -- complement (one's complement) */
  val = VALUE_NONE;
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "count")) {
    if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "(")) {
      value_t tmp;

      pf_token_get(pf, PF_TOKEN_NEXT);
      tmp = jal_parse_expr(pf);
      if (VALUE_NONE != tmp) {
        if (value_is_array(tmp)) {
          val = pfile_constant_get(pf,
              variable_def_member_ct_get(
                variable_def_member_get(
                  value_def_get(
                    tmp))),
              VARIABLE_DEF_NONE);
        } else if (value_is_pointer(tmp)) {
          const char *vname;
          char       *ct_name;

          vname = value_name_get(tmp);
          ct_name = MALLOC(8 + strlen(vname));
          sprintf(ct_name, "_%s_count", vname);
          val = pfile_value_find(pf, PFILE_LOG_NONE, ct_name);
          FREE(ct_name);
        } 
        if (VALUE_NONE == val) {
          pfile_log(pf, PFILE_LOG_ERR, "\"%s\" is not an array",
              value_name_get(tmp));
        }
        value_release(tmp);
      }
      if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, ")")) {
        pf_token_get(pf, PF_TOKEN_NEXT);
      }
    } 
  } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "whereis")) {
    if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "(")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    if (!jal_token_is_identifier(pf)) {
      pfile_log(pf, PFILE_LOG_ERR, "identifier expected");
    } else {
      const char *ptr;
      label_t     lbl;

      ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
      lbl = pfile_label_find(pf, PFILE_LOG_NONE, ptr);
      val = VALUE_NONE;
      if (!lbl) {
        val = pfile_value_find(pf, PFILE_LOG_NONE, ptr);
        if (val == VALUE_NONE) {
          pfile_log(pf, PFILE_LOG_ERR, "%s not found", ptr);
        }
      }
      if (lbl || val) {
        variable_def_t def;
        variable_t     var;

        def = variable_def_alloc(0, (lbl) ? VARIABLE_DEF_TYPE_LABEL
            : VARIABLE_DEF_TYPE_VALUE, VARIABLE_DEF_FLAG_VOLATILE, 2);
        var = variable_alloc(TAG_NONE, def);
        if (lbl) {
          variable_label_set(var, lbl);
        } else {
          variable_value_set(var, val);
        }
        value_release(val);
        val = value_alloc(var);
        variable_release(var);
        label_release(lbl);
      }
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, ")")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
  } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "defined")) {
    if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "(")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    if (!jal_token_is_identifier(pf)) {
      pfile_log(pf, PFILE_LOG_ERR, "identifier expected");
    } else {
      const char      *ptr;
      label_t          lbl;
      value_t          tst_val;
      variable_def_t   vdef;

      vdef    = variable_def_alloc(0, VARIABLE_DEF_TYPE_BOOLEAN, 0, 1);
      ptr     = pf_token_get(pf, PF_TOKEN_CURRENT);
      lbl     = pfile_label_find(pf, PFILE_LOG_NONE, ptr);
      tst_val = pfile_value_find(pf, PFILE_LOG_NONE, ptr);

      value_release(tst_val);
      label_release(lbl);
      val = pfile_constant_get(pf,
         (lbl != LABEL_NONE) || (tst_val != VALUE_NONE),
          vdef);
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, ")")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
  } else {
    const char *ptr;
    operator_t  op;

    ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
    op = OPERATOR_NULL;
    switch (*ptr) {
      case '!':
        op = ('!' == ptr[1]) ? OPERATOR_LOGICAL : OPERATOR_CMPB;
        /* fall through */
      case '-':
      case '+':
        if ('-' == *ptr) {
          op = OPERATOR_NEG;
        }
        pf_token_get(pf, PF_TOKEN_NEXT); /* this one's done */
        val = value_get(pf);   /* var is the next value */
        /* create the expression:
         *   _t# = var op
         *   and return _t#
         */
        if (val && (OPERATOR_NULL != op)) {
          value_t tmp;

          if ((OPERATOR_NEG == op) && value_is_const(val)) {
            if (value_is_float(val)) {
              tmp = pfile_constant_float_get(pf,
                -value_const_float_get(val), VARIABLE_DEF_NONE);
            } else {
              variable_def_t      def;
              variable_sz_t       sz;
              variable_def_type_t type;
              flag_t              flags;
              variable_const_t    n;

              n = -value_const_get(val);

              if (value_name_get(val)) {
                sz    = value_sz_get(val);
                type  = VARIABLE_DEF_TYPE_INTEGER;
                flags = VARIABLE_DEF_FLAG_SIGNED;
              } else {
                variable_calc_sz_min(n, &sz, &type, &flags);
              }
              if (value_is_universal(val)) {
                flags |= VARIABLE_DEF_FLAG_UNIVERSAL;
              }
              def = variable_def_alloc(0, type, flags, sz);
              tmp = pfile_constant_get(pf, n, def);
            }
            value_release(val);
            val = tmp;
          } else {
            tmp = VALUE_NONE;
            pfile_cmd_op_add(pf, op, &tmp, val, 0);
            value_release(val);
            val = tmp;
          }
        }
        break;
      case '(':
        pf_token_get(pf, PF_TOKEN_NEXT);
        val = jal_parse_expr(pf);
        /* prepend the existing result to the new result */
        if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, ")")) {
          pf_token_get(pf, PF_TOKEN_NEXT);
        }
        break;
      default:
        if (jal_token_is_identifier(pf)) {
          val = jal_parse_value(pf, JAL_PARSE_VALUE_TYPE_RVALUE);
        } else {
          val = jal_token_to_constant(pf, PFILE_LOG_ERR);
          if (val) {
            pf_token_get(pf, PF_TOKEN_NEXT);
          }
        }
        break;
    }
  }
  while (jal_parse_structure(pf, &val)
    || jal_parse_subscript(pf, &val)) 
    ; /* null loop */
  return val;
}

/*
 * NAME
 *   operator_get
 *
 * DESCRIPTION
 *   get an operator
 *
 * PARAMETERS
 *   expr : expression
 *   pf   : returned by pfile_open()
 *
 * RETURN
 *   0      : no error
 *   EINVAL : no operator present
 *
 * NOTES
 */
static operator_t operator_get(pfile_t *pf)
{
  static const struct {
    const char *token;
    operator_t     op;
  } operator_token_map[] = {
    {"*",    OPERATOR_MUL},
    {"/",    OPERATOR_DIV},
    {"%",    OPERATOR_MOD},
    {"+",    OPERATOR_ADD},
    {"-",    OPERATOR_SUB},
    {"<<",   OPERATOR_SHIFT_LEFT},
    {">>",   OPERATOR_SHIFT_RIGHT},
    {"<",    OPERATOR_LT},
    {"<=",   OPERATOR_LE},
    {"==",   OPERATOR_EQ},
    {"!=",   OPERATOR_NE},
    {">=",   OPERATOR_GE},
    {">",    OPERATOR_GT},
    {"&",    OPERATOR_ANDB},
    {"|",    OPERATOR_ORB},
    {"^",    OPERATOR_XORB},
    {"!!",   OPERATOR_LOGICAL},
    {".",    OPERATOR_DOT},
    {"[",    OPERATOR_SUBSCRIPT}
  };
  size_t ii;
  operator_t op;

  for (ii = 0; 
       (ii < COUNT(operator_token_map))
        && !pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE,
          operator_token_map[ii].token); 
        ii++)
    ;
  if (ii == COUNT(operator_token_map)) {
    op = OPERATOR_NULL;
  } else {
    op = operator_token_map[ii].op;
    pf_token_get(pf, PF_TOKEN_NEXT);
  }
  return op;
}

/*
 * NAME
 *   expr_parse
 *
 * DESCRIPTION
 *   parse an expression
 *
 * PARAMETERS
 *   dst   : [out] holds result
 *   pf    : parse file
 *   lhvar : for assignments, this is the base left-hand variable
 *
 * RETURN
 *
 * NOTES
 */
value_t jal_parse_expr(pfile_t *pf)
{
  operator_t  op;
  expr_t     *exprstk;
  value_t     val;

  exprstk = 0;
  op      = OPERATOR_NULL;
  do {
    val = value_get(pf);
    op = operator_get(pf);
    if (val) {
      pfile_expr_push(pf, &exprstk, val, op);
      value_release(val);
    }
  } while (OPERATOR_NULL != op);
  if (exprstk) {
    val = expr_val_get(exprstk);
    value_lock(val);
    expr_list_free(&exprstk);
  }
  return val;
}

