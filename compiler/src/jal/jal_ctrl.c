/**********************************************************
 **
 ** jal_ctrl.c : parser for JAL control functions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <errno.h>
#include "../libutils/mem.h"
#include "../libcore/pf_cmd.h"
#include "../libcore/pf_expr.h"
#include "../libcore/pf_proc.h"
#include "jal_expr.h"
#include "jal_blck.h"
#include "jal_file.h"
#include "jal_ctrl.h"
#include "jal_tokn.h"

/*
 * NAME
 *   jal_parse_for
 *
 * DESCRIPTION
 *   implement FOR
 *
 * PARAMETERS
 *   pf       : 
 *
 * RETURN
 *   none
 *
 * NOTES
 *   FOR expr LOOP ... END LOOP
 * this becomes:
 *   tmp = expr
 *   label_top:
 *     if (!tmp) goto label_end
 *     block
 *     tmp--
 *     goto label_top
 *   label_end:
 */
void jal_parse_for(pfile_t *pf, const pfile_pos_t *statement_start)
{
  value_t     expr;
  boolean_t   codegen_disable;
  label_t     lbl_top;
  label_t     lbl_end;
  label_t     lbl_exit;
  label_t     lbl_exit_prev;
  value_t     val;
  value_t     zero;
  cmd_t       cmd_start;
  boolean_t   is_modified;
  boolean_t   is_special;

  expr = jal_parse_expr(pf);
  pfile_expr_string_fix(pf, expr);
  if (!value_is_const(expr)) {
    /* The lifetime of a temporary is assumed to be one statement
     * but that's not true for a FOR loop. */
    value_t tmp;

    tmp = jal_file_loop_var_get(pf, expr);
    pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &tmp, expr, VALUE_NONE);
    value_release(expr);
    expr = tmp;
  }

  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "using")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
    val = jal_parse_expr(pf);
    if (value_is_const(expr)) {
      /* check that expr will fit in the resulting variable */
      if (value_is_bit(val)) {
        if (((1UL << value_sz_get(val)) - 1) < value_const_get(expr)) {
          pfile_log(pf, PFILE_LOG_ERR, "expr doesn't fit into variable");
        } else if (value_is_boolean(val)) {
          if (pfile_flag_test(pf, PFILE_FLAG_WARN_MISC)) {
            pfile_log(pf, PFILE_LOG_WARN, 
                "BIT values shouldn't be used in loops");
          }
        }
      } else {
        if (!value_is_universal(expr) 
            && (value_sz_get(expr) > value_sz_get(val))) {
          pfile_log(pf, PFILE_LOG_ERR, "expr doesn't fit into variable");
        }
      }
    }
  } else {
    val = jal_file_loop_var_get(pf, expr);
  }

  codegen_disable = (value_is_const(expr) && !value_const_get(expr));

  if (codegen_disable) {
    pfile_codegen_disable(pf, BOOLEAN_TRUE);
  }
  is_special = BOOLEAN_FALSE;
  if (value_is_const(expr)) {
    variable_const_t cn;

    cn = value_const_get(expr);
    if ((cn >= 1) && !(cn & (cn - 1))) {
      if ((1UL << 8 * value_sz_get(val)) == cn) {
        is_special = BOOLEAN_TRUE;
      }
    }
  }

  zero = pfile_constant_get(pf, 0, VARIABLE_DEF_NONE);
  pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &val, zero, VALUE_NONE);

  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "loop")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  }

  lbl_top  = pfile_label_alloc(pf, 0);
  lbl_end  = pfile_label_alloc(pf, 0);
  lbl_exit = pfile_label_alloc(pf, 0);

  if (lbl_end
    && (!value_is_const(expr) || !value_const_get(expr))) {
    /* if the value is constant > 0, we don't need this goto */
    pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
      CMD_BRANCHCOND_NONE, lbl_end, VALUE_NONE, 0, 0);
  }

  pfile_cmd_label_add(pf, lbl_top);
  cmd_start = pfile_cmdlist_tail_get(pf);
  lbl_exit_prev = pfile_exit_label_set(pf, lbl_exit);
  jal_block_process(pf, JAL_BLOCK_PROCESS_FLAG_NONE);
  pfile_exit_label_set(pf, lbl_exit_prev);
  /* make sure the control variable isn't modified in the block! */
  is_modified = BOOLEAN_FALSE;
  while (cmd_start && !is_modified) {
    is_modified = cmd_variable_accessed_get(cmd_start,
        value_variable_get(val)) & CMD_VARIABLE_ACCESS_FLAG_WRITTEN;
    cmd_start = cmd_link_get(cmd_start);
  }
  if (is_modified) {
    if (pfile_flag_test(pf, PFILE_FLAG_WARN_MISC)) {
      pfile_log(pf, PFILE_LOG_WARN,
          "%s should not be modified in the LOOP block",
          value_name_get(val));
    }
  }

  pfile_cmd_op_add(pf, OPERATOR_INCR, &val, VALUE_NONE, 
      VALUE_NONE);
  if (lbl_end) {
    value_t tmp;

    pfile_cmd_label_add(pf, lbl_end);
    tmp = VALUE_NONE;
    if (is_special) {
      pfile_cmd_op_add(pf, OPERATOR_EQ, &tmp, val, zero);
    } else if (VALUE_NONE != expr) {
      pfile_cmd_op_add(pf, OPERATOR_EQ, &tmp, val, expr);
    }
    pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO, 
        CMD_BRANCHCOND_FALSE, lbl_top, tmp, 0, 0);
    value_release(tmp);
  }
  pfile_cmd_label_add(pf, lbl_exit);
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "end")
    && pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "loop")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  } else {
    jal_block_start_show(pf, "FOR", statement_start);
  }

  value_release(zero);
  label_release(lbl_exit);
  label_release(lbl_end);
  label_release(lbl_top);
  if (codegen_disable) {
    pfile_codegen_disable(pf, BOOLEAN_FALSE);
  }
  value_release(val);
  value_release(expr);
}

/*
 * NAME
 *   jal_parse_forever
 *
 * DESCRIPTION
 *   implement FOREVER
 *
 * PARAMETERS
 *   pf: 
 *
 * RETURN
 *   none
 *
 * NOTES
 *   FOREVER LOOP ... END LOOP
 * this becomes:
 *   label_top:
 *      block
 *      goto label_top
 */
void jal_parse_forever(pfile_t *pf, const pfile_pos_t *statement_start)
{
  label_t lbl_top;
  label_t lbl_exit;
  label_t lbl_exit_prev;

  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "loop")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  }

  lbl_top  = pfile_label_alloc(pf, 0);
  lbl_exit = pfile_label_alloc(pf, 0);

  pfile_cmd_label_add(pf, lbl_top);
  lbl_exit_prev = pfile_exit_label_set(pf, lbl_exit);
  jal_block_process(pf, JAL_BLOCK_PROCESS_FLAG_NONE);
  pfile_exit_label_set(pf, lbl_exit_prev);
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "end")
    && pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "loop")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  } else {
    jal_block_start_show(pf, "FOREVER", statement_start);
  }
  if (lbl_top) {
    pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
        CMD_BRANCHCOND_NONE, lbl_top, VALUE_NONE, 0, 0);
  }
  pfile_cmd_label_add(pf, lbl_exit);
  label_release(lbl_exit);
  label_release(lbl_top);
}

/*
 * NAME
 *   jal_parse_while
 *
 * DESCRIPTION
 *   implement WHILE
 *
 * PARAMETERS
 *   pf: 
 *
 * RETURN
 *   none
 *
 * NOTES
 *   WHILE bexpr LOOP ... END LOOP
 * this becomes:
 *   tmp = bexpr
 *   label_top:
 *     if (!tmp) goto label_end
 *     block
 *     goto label_top
 *   label_end: 
 */
void jal_parse_while(pfile_t *pf, const pfile_pos_t *statement_start)
{
  label_t     lbl_top;
  label_t     lbl_end;
  label_t     lbl_exit;
  label_t     lbl_exit_prev;
  value_t     expr;
  boolean_t   codegen_disable;

  lbl_top  = pfile_label_alloc(pf, 0);
  lbl_end  = pfile_label_alloc(pf, 0);
  lbl_exit = pfile_label_alloc(pf, 0);
  expr     = VALUE_NONE;

  pfile_cmd_label_add(pf, lbl_top);
  expr = jal_parse_expr(pf);

  if (!value_is_boolean(expr)) {
    pfile_log(pf, PFILE_LOG_WARN, "boolean expression expected");
  }
  codegen_disable = (value_is_const(expr) && !value_const_get(expr));
  if (codegen_disable) {
    pfile_codegen_disable(pf, BOOLEAN_TRUE);
  }
  if (lbl_end && expr) {
    pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
        CMD_BRANCHCOND_FALSE, lbl_end, expr, 0, 0);
  }
  value_release(expr);
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "loop")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  }
  lbl_exit_prev = pfile_exit_label_set(pf, lbl_exit);
  jal_block_process(pf, JAL_BLOCK_PROCESS_FLAG_NONE);
  pfile_exit_label_set(pf, lbl_exit_prev);
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "end")
    && pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "loop")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  } else {
    jal_block_start_show(pf, "WHILE", statement_start);
  }
  pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
      CMD_BRANCHCOND_NONE, lbl_top, VALUE_NONE, 0, 0);
  pfile_cmd_label_add(pf, lbl_end);
  if (codegen_disable) {
    pfile_codegen_disable(pf, BOOLEAN_FALSE);
  }
  pfile_cmd_label_add(pf, lbl_exit);
  label_release(lbl_exit);
  label_release(lbl_end);
  label_release(lbl_top);
}

void jal_parse_repeat(pfile_t *pf, const pfile_pos_t *statement_start)
{
  label_t     lbl_top;
  label_t     lbl_exit;
  label_t     lbl_exit_prev;
  value_t     expr;

  lbl_top  = pfile_label_alloc(pf, 0);
  lbl_exit = pfile_label_alloc(pf, 0);
  expr     = VALUE_NONE;

  pfile_cmd_label_add(pf, lbl_top);

  lbl_exit_prev = pfile_exit_label_set(pf, lbl_exit);
  jal_block_process(pf, JAL_BLOCK_PROCESS_FLAG_NONE);
  pfile_exit_label_set(pf, lbl_exit_prev);
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "until")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  } else {
    jal_block_start_show(pf, "REPEAT", statement_start);
  }
  expr = jal_parse_expr(pf);
  if (!value_is_boolean(expr)) {
    pfile_log(pf, PFILE_LOG_WARN, "boolean expression expected");
  }
  pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
      CMD_BRANCHCOND_FALSE, lbl_top, expr, 0, 0);
  value_release(expr);
  pfile_cmd_label_add(pf, lbl_exit);
  label_release(lbl_exit);
  label_release(lbl_top);
}

/*
 * NAME
 *   jal_skip_if
 *
 * DESCRIPTION
 *   skip an if block
 *
 * PARAMETERS
 *   pf       : pfile
 *   is_else  : TRUE if this is an else clause
 *
 * RETURN
 *   TRUE  : this resulted in an `end if' (absorbed)
 *   FALSE : the return is either 'elsif' or 'else'
 *
 * NOTES
 *   this is a rather wacky result of the way the IF statement works in
 *   JAL. JAL, having no preprocessor, uses `IF cexpr THEN...' like the
 *   C preprocessor's #if ...
 */
static boolean_t jal_skip_if(pfile_t *pf, boolean_t is_else)
{
  boolean_t   is_end;

  is_end = BOOLEAN_FALSE;
  do {
    /* embedded IF */
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "end")
      && pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_NONE, "if")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
      is_end = BOOLEAN_TRUE;
    } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "if")) {
      while (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "if")) {
        pf_token_get(pf, PF_TOKEN_NEXT);
        while (!pf_token_is_eof(pf) && !jal_skip_if(pf, BOOLEAN_FALSE)) {
          /* empty */
        }
      }
    } else {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    if (!is_else
      && (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "elsif")
        || pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "else"))) {
      break;
    }
  } while (!pf_token_is_eof(pf) && !is_end);
  return is_end;
}

/*
 * NAME
 *   jal_parse_if
 *
 * DESCRIPTION
 *   implement IF
 *
 * PARAMETERS
 *   pf: 
 *
 * RETURN
 *   none
 *
 * NOTES
 *   IF expr THEN .. [ELSIF expr THEN ...] [ELSE ...] END IF
 * becomes:
 *   release for each ELSIF:
 *     if !expr goto label_next
 *       block
 *       goto label_end
 *     label_next
 *     ..
 *     label_end
 */
void jal_parse_if(pfile_t *pf, const pfile_pos_t *statement_start)
{
  label_t     lbl_end;
  boolean_t   else_skip;
  boolean_t   is_first;
  boolean_t   is_end;
  flag_t      block_process_flag;

  lbl_end = pfile_label_alloc(pf, 0);
  block_process_flag = JAL_BLOCK_PROCESS_FLAG_NONE;

  /* else_skip is set to TRUE if any of the preceding IF clauses
     has evaluated to a constant TRUE which means the ELSE can
     never be hit */
  else_skip = BOOLEAN_FALSE;
  is_first  = BOOLEAN_TRUE;
  is_end    = BOOLEAN_FALSE;
  do {
    value_t   expr;
    boolean_t skip_clause;
    label_t   lbl_next;

    if (is_first) {
      is_first = BOOLEAN_FALSE;
    } else {
      /* the current token must be "elsif" */
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    expr = jal_parse_expr(pf);
    if (!value_is_boolean(expr)) {
      pfile_log(pf, PFILE_LOG_WARN, "boolean expression expected");
    }
    /*
     * if a clause has already been hit (hence else_skip is set)
     * all other clauses need to be skipped
     */
    skip_clause = else_skip;
    if (value_is_const(expr)) {
      if (pfile_flag_test(pf, PFILE_FLAG_WARN_DIRECTIVES)) {
        pfile_log(pf, PFILE_LOG_WARN, "compiler directive");
      }
      block_process_flag = JAL_BLOCK_PROCESS_FLAG_NO_BLOCK;
      if (value_const_get(expr)) {
        else_skip = BOOLEAN_TRUE;
      } else {
        skip_clause = BOOLEAN_TRUE;
      }
    }
    if (skip_clause) {
      pfile_codegen_disable(pf, BOOLEAN_TRUE);
      lbl_next = LABEL_NONE;
    } else {
      lbl_next = pfile_label_alloc(pf, 0);
      if (lbl_next) {
        pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
            CMD_BRANCHCOND_FALSE, lbl_next, expr, 0, 0);
      }
    }
    value_release(expr);
    jal_token_is(pf, "then");
    if (skip_clause) {
      is_end = jal_skip_if(pf, BOOLEAN_FALSE);
    } else {
      jal_block_process(pf, block_process_flag);
    }
    if (lbl_end) {
      pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
          CMD_BRANCHCOND_NONE, lbl_end, VALUE_NONE, 0, 0);
    }
    if (skip_clause) {
      pfile_codegen_disable(pf, BOOLEAN_FALSE);
    } else {
      pfile_cmd_label_add(pf, lbl_next);
      label_release(lbl_next);
    }
  } while (!is_end && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, 
        "elsif"));
  if (!is_end && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "else")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
    if (else_skip) {
      is_end = jal_skip_if(pf, BOOLEAN_TRUE);
    } else {
      jal_block_process(pf, block_process_flag);
    }
  }
  if (!is_end) {
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "end")
      && pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "if")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    } else {
      jal_block_start_show(pf, "IF", statement_start);
    }
  }
  pfile_cmd_label_add(pf, lbl_end);
  label_release(lbl_end);
}

/*
 * NAME
 *   jal_parse_usec_delay
 *
 * DESCRIPTION
 *   parse the usec_delay command
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 */

void jal_parse_usec_delay(pfile_t *pf, const pfile_pos_t *statement_start)
{
  UNUSED(statement_start);

  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "(")) {
    value_t cval;

    pf_token_get(pf, PF_TOKEN_NEXT);
    cval = jal_parse_expr(pf);
    if (cval) {
      if (!value_is_const(cval)) {
        pfile_log(pf, PFILE_LOG_ERR, "constant expression expected");
      } else {
        pfile_cmd_usec_delay_add(pf, value_const_get(cval));
      }
      value_release(cval);
    }
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, ")")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
  }
}

/*
 * NAME
 *   jal_parse_case
 *
 * DESCRIPTION
 *   parse the case command
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   none
 *
 * NOTES
 *   CASE expr OF
 *      cexpr[, cexpr2...] : statement
 *      ...
 *      [OTHERWISE] statement
 *   END CASE
 */

/* #define this to use a single branch with a complex expression;
 * #undef this to use multiple branches */
#undef JAL_CASE_SINGLE_BRANCH

void jal_parse_case(pfile_t *pf, const pfile_pos_t *statement_start)
{
  value_t  expr;   /* controlling expression */
#ifdef JAL_CASE_SINGLE_BRANCH
  value_t  brexpr; /* branch expression      */
#endif
  label_t  label_done;
  label_t  label_skip;
  unsigned cexpr_ct;
  struct {
    size_t            alloc;
    size_t            used;
    variable_const_t *data;
  } consts_used;
  cmd_t    dummy;

  consts_used.alloc = 0;
  consts_used.used  = 0;
  consts_used.data  = 0;
  expr = jal_parse_expr(pf);
  pfile_expr_string_fix(pf, expr);
  if (value_is_bit(expr)) {
    /* this resulted in a bit expression, let's go ahead
     * and assign it to an appropriately sized byte*2
     * value to avoid a shift/mask per case
     */
    variable_def_t tmp_def;
    value_t        tmp;

    tmp_def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
      value_is_signed(expr) 
      ? VARIABLE_DEF_FLAG_SIGNED
      : VARIABLE_DEF_FLAG_NONE,
      value_byte_sz_get(expr));
    tmp = pfile_value_temp_get_from_def(pf, tmp_def);
    pfile_cmd_op_add_assign(pf, OPERATOR_ASSIGN, &tmp, expr);
    value_release(expr);
    expr = tmp;
  }
  dummy = cmd_alloc(CMD_TYPE_COMMENT, 0);
  pfile_cmd_add(pf, dummy);

  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "of")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  }
  label_done = LABEL_NONE;
  label_skip = LABEL_NONE;
#ifdef JAL_CASE_SINGLE_BRANCH
  brexpr     = VALUE_NONE;
#endif
  do {
    value_t cexpr;
    label_t label_go;
    value_t val;

    label_go   = LABEL_NONE;

    if (label_done != LABEL_NONE) {
      pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
        CMD_BRANCHCOND_NONE, label_done, VALUE_NONE, VALUE_NONE, 0);
      pfile_cmd_label_add(pf, label_skip);
    }
    label_skip = pfile_label_alloc(pf, 0);
    cexpr_ct = 0;
    cexpr    = VALUE_NONE;
    do {
      pfile_pos_t pos;

      pf_token_start_get(pf, &pos);
      pfile_statement_start_set(pf, &pos);
      if (VALUE_NONE != cexpr) {
        /* the current token must be ',' */
        pf_token_get(pf, PF_TOKEN_NEXT);
        val = VALUE_NONE;
        pfile_cmd_op_add(pf, OPERATOR_EQ, &val, expr, cexpr);
#ifndef JAL_CASE_SINGLE_BRANCH
        pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
          CMD_BRANCHCOND_TRUE, label_go, val, VALUE_NONE, 0);
        value_release(val);
#else
        if (VALUE_NONE == brexpr) {
          brexpr = val;
        } else {
          pfile_cmd_op_add(pf, OPERATOR_ANDL, &brexpr, val, VALUE_NONE);
          value_release(val);
        }
#endif
        value_release(cexpr);
      }
      cexpr = jal_parse_expr(pf);
      if ((cexpr && !value_is_const(cexpr))
        || (!cexpr && (LABEL_NONE != label_go))) {
        pfile_log(pf, PFILE_LOG_ERR, "constant expression expected");
      } 
      if (cexpr) {
        variable_const_t n;
        size_t           ii;

        n = value_const_get(cexpr);
        for (ii = 0; 
             (ii < consts_used.used) && (consts_used.data[ii] != n);
             ii++)
          ; /* empty body */
        if (ii < consts_used.used) {
          pfile_log(pf, PFILE_LOG_ERR, "CASE expression already used: %lu",
            n);
        }
        cexpr_ct++;
        if (consts_used.used == consts_used.alloc) {
          size_t newalloc;
          void  *tmp;

          newalloc = (consts_used.alloc) ? 2 * consts_used.alloc : 16;
          tmp = REALLOC(consts_used.data, 
            sizeof(*consts_used.data) * newalloc);
          if (!tmp) {
            pfile_log_syserr(pf, ENOMEM);
          } else {
            consts_used.alloc = newalloc;
            consts_used.data  = tmp;
          }
        }
        if (consts_used.used < consts_used.alloc) {
          consts_used.data[consts_used.used++] = n;
        }
      }
      if (LABEL_NONE == label_go) {
        label_go = pfile_label_alloc(pf, 0);
      }
    } while (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ","));
    if (cexpr_ct) {
      if (cexpr) {
        val = VALUE_NONE;
        pfile_cmd_op_add(pf, OPERATOR_EQ, &val, expr, cexpr);
#ifndef JAL_CASE_SINGLE_BRANCH
        pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
          CMD_BRANCHCOND_FALSE, label_skip, val, VALUE_NONE, 0);
#else
        if (brexpr) {
          pfile_cmd_op_add(pf, OPERATOR_ANDL, &brexpr, val, VALUE_NONE);
          pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
            CMD_BRANCHCOND_FALSE, label_skip, brexpr, VALUE_NONE, 0);
        } else {
          pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
            CMD_BRANCHCOND_FALSE, label_skip, val, VALUE_NONE, 0);
        }
#endif
        value_release(val);
      }
      if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, ":")) {
        pf_token_get(pf, PF_TOKEN_NEXT);
      }
      if (label_go != LABEL_NONE) {
        pfile_cmd_label_add(pf, label_go);
      }
      jal_statement_process(pf);
      if (LABEL_NONE == label_done) {
        label_done = pfile_label_alloc(pf, 0);
      }
    }
    value_release(cexpr);
    label_release(label_go);
    label_release(label_skip);
  } while (cexpr_ct && !pf_token_is_eof(pf));
  if (!consts_used.used) {
    pfile_log(pf, PFILE_LOG_ERR, "No CASE entries");
  }
  if (value_is_const(expr)) {
    variable_const_t n;
    size_t           ii;

    n = value_const_get(expr);
    for (ii = 0; 
         (ii < consts_used.used) && (consts_used.data[ii] != n);
         ii++)
      ; /* empty body */
    if (ii == consts_used.used) {
      if (pfile_flag_test(pf, PFILE_FLAG_WARN_MISC)) {
        pfile_log(pf, PFILE_LOG_WARN, "No matching CASE entries");
      }
    }
  }
  value_release(expr);
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "otherwise")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
    jal_statement_process(pf);
  }
  pfile_cmd_label_add(pf, label_done);
  label_release(label_done);
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "end")
    && pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "case")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  } else {
    jal_block_start_show(pf, "CASE", statement_start);
  }
  FREE(consts_used.data);
}

void jal_parse_exit(pfile_t *pf, const pfile_pos_t *start)
{
  label_t lbl;

  UNUSED(start);

  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "loop")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  }
  lbl = pfile_exit_label_get(pf);
  if (LABEL_NONE == lbl) {
    pfile_log(pf, PFILE_LOG_ERR, "EXIT LOOP can only be used in loops");
  } else {
    pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
      CMD_BRANCHCOND_NONE, lbl, VALUE_NONE, VALUE_NONE, 0);
  }
}

static void jal_parse_log(pfile_t *pf, const pfile_pos_t *start,
  pfile_log_t plog)
{
  const char *ptr;

  UNUSED(start);
  ptr = pf_token_ptr_get(pf);
  if (*ptr != '"') {
    pfile_log(pf, PFILE_LOG_ERR, "'\"' expected");
  } else {
    pfile_cmd_log_add(pf, plog, pf_token_sz_get(pf), ptr);
    pf_token_get(pf, PF_TOKEN_NEXT);
  }
}

void jal_parse_debug(pfile_t *pf, const pfile_pos_t *start)
{
  jal_parse_log(pf, start, PFILE_LOG_DEBUG);
}

void jal_parse_warn(pfile_t *pf, const pfile_pos_t *start)
{
  jal_parse_log(pf, start, PFILE_LOG_WARN);
}

void jal_parse_error(pfile_t *pf, const pfile_pos_t *start)
{
  jal_parse_log(pf, start, PFILE_LOG_ERR);
}


