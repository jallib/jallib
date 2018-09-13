/************************************************************
 **
 ** jal_blck.c : JAL block processing definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <errno.h>
#include <string.h>
#include <assert.h>
#include "../libutils/mem.h"
#include "../libcore/pf_cmd.h"
#include "../libcore/pf_expr.h"
#include "../libcore/pf_msg.h"
#include "../libpic12/pic.h"
#include "jal_file.h"
#include "jal_tokn.h"
#include "jal_ctrl.h"
#include "jal_proc.h"
#include "jal_expr.h"
#include "jal_prnt.h"
#include "jal_asm.h"
#include "jal_incl.h"
#include "jal_vdef.h"
#include "jal_blck.h"
#if defined(MSDOS) && !defined(__WATCOMC__)
#include <dir.h>
#define FILENAME_MAX MAXPATH
#endif


/* this traces the masters back to find one with a _get or _put function */

static boolean_t jal_parse_assign(pfile_t *pf)
{
  const char    *ptr;
  value_t        jval[JAL_VAL_TYPE_CT];
  boolean_t      success;

  ptr     = pf_token_get(pf, PF_TOKEN_CURRENT);
  success = jal_value_find(pf, ptr, jval);
  /* nb: precedence of use:
   *     val_put : highest
   *     val
   *     val_vput
   */
  if (success) {
    boolean_t is_put;
    value_t   val;

    is_put = BOOLEAN_FALSE;
    val    = VALUE_NONE;

    if (jval[JAL_VAL_TYPE_PUT]) {
      val = jval[JAL_VAL_TYPE_PUT];
      if (VARIABLE_DEF_TYPE_POINTER == value_type_get(val)) {
        value_assign_ct_bump(val, CTR_BUMP_INCR);
        value_dereference(val);
      }
      assert(VARIABLE_DEF_TYPE_FUNCTION == value_type_get(val));
      is_put = BOOLEAN_TRUE;
    } else if (jval[JAL_VAL_TYPE_BASE]) {
      val = jval[JAL_VAL_TYPE_BASE];
      if (VARIABLE_DEF_TYPE_FUNCTION == value_type_get(val)) {
      }
      if (value_vflag_test(val, VARIABLE_FLAG_READ)
        && !value_vflag_test(val, VARIABLE_FLAG_WRITE)) {
        pfile_log(pf, PFILE_LOG_ERR, "cannot write to %s",
          value_name_get(val));
      }
      /* don't skip this token; this value will be reprocessed later */
    } else if (jval[JAL_VAL_TYPE_IPUT]) { 
      val = jval[JAL_VAL_TYPE_IPUT];
      assert(VARIABLE_DEF_TYPE_FUNCTION == value_type_get(val));
      is_put = BOOLEAN_TRUE;
    } else {
      success = BOOLEAN_FALSE;
      pfile_log(pf, PFILE_LOG_ERR, "No PUT procedure");
    }
    value_lock(val);
    if (!is_put && (VARIABLE_DEF_TYPE_FUNCTION == value_type_get(val))) {
      value_t ret_val;

      pf_token_get(pf, PF_TOKEN_NEXT);
      ret_val = jal_parse_call(pf, val, JAL_PARSE_CALL_FLAG_NONE);
      if (ret_val) {
        if (pfile_flag_test(pf, PFILE_FLAG_WARN_MISC)) {
          pfile_log(pf, PFILE_LOG_WARN, "return value ignored");
        }
        value_release(ret_val);
      }
    } else {
      value_t idx;
      size_t  param_ct;

      idx = VALUE_NONE;
      param_ct = 0;
      if (!is_put) {
        value_release(val);
        val = jal_parse_value(pf, JAL_PARSE_VALUE_TYPE_LVALUE);
        if (!val) {
          if (jal_token_is_identifier(pf)) {
            pfile_log(pf, PFILE_LOG_ERR, "\"%s\" not found", 
                pf_token_get(pf, PF_TOKEN_CURRENT));
            pf_token_get(pf, PF_TOKEN_NEXT);
          } else {
            pfile_log(pf, PFILE_LOG_ERR, "variable expected");
          }
        } else {
          while (jal_parse_structure(pf, &val)
            || jal_parse_subscript(pf, &val))
            ; /* null body */
        }
      } else {
        variable_def_t        def;
        variable_def_member_t mbr;

        pf_token_get(pf, PF_TOKEN_NEXT);
        /* look to see if this is an array */
        def = value_def_get(val);
        mbr = variable_def_member_get(def); /* return value (none) */
        mbr = variable_def_member_link_get(mbr); /* index or parameter  */
        mbr = variable_def_member_link_get(mbr); /* parameter or none   */
        if (!mbr) {
          param_ct = 2;
        } else {
          param_ct = 3;
          /* parse the index */
          if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "[")) {
            pf_token_get(pf, PF_TOKEN_NEXT);
            idx = jal_parse_expr(pf);
            if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "]")) {
              pf_token_get(pf, PF_TOKEN_NEXT);
            }
          }
        }
      }
      if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "(")) {
        value_release(jal_parse_call(pf, VALUE_NONE, JAL_PARSE_CALL_FLAG_NONE));
      } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "=")) {
        value_t expr;

        pf_token_get(pf, PF_TOKEN_NEXT);

        expr = jal_parse_expr(pf);
        if (expr) {
          if (!value_def_is_same(val, expr)
            && !pfile_expr_string_fix(pf, expr)) {
              value_release(val);
              val = VALUE_NONE;
          }

          if (val) {
            if (is_put) {
              value_t *params;

              params = MALLOC(param_ct * sizeof(*params));
              if (!params) {
                pfile_log_syserr(pf, ENOMEM);
              } else {
                params[0] = VALUE_NONE;
                if (3 == param_ct) {
                  params[1] = idx;
                  params[2] = expr;
                } else {
                  params[1] = expr;
                }
                value_lock(expr);
                value_lock(idx);
                pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_CALL,
                  CMD_BRANCHCOND_NONE, LABEL_NONE, VALUE_NONE,
                  val, params);
              }
            } else {
              pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &val, expr, VALUE_NONE);
            }
          }
          value_release(expr);
        }
      }
      value_release(idx);
    }
    value_release(val);
    jal_value_release(jval);
  }
  return success;
}

/* parse BLOCK...END BLOCK */
static void jal_parse_block(pfile_t *pf, const pfile_pos_t *statement_start)
{
  jal_block_process(pf, JAL_BLOCK_PROCESS_FLAG_NONE);
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "end")
    && pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "block")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  } else {
    jal_block_start_show(pf, "BLOCK", statement_start);
  }
}

static void jal_parse_assert(pfile_t *pf, const pfile_pos_t *statement_start)
{
  value_t expr;

  UNUSED(statement_start);

  if (!pfile_flag_test(pf, PFILE_FLAG_DEBUG_EMULATOR)) {
    pfile_codegen_disable(pf, BOOLEAN_TRUE);
  }
  expr = jal_parse_expr(pf);
  if ((VALUE_NONE != expr) 
      && pfile_flag_test(pf, PFILE_FLAG_DEBUG_EMULATOR)) {
    pfile_cmd_add(pf, cmd_assert_alloc(expr));
  }
  value_release(expr);
  if (!pfile_flag_test(pf, PFILE_FLAG_DEBUG_EMULATOR)) {
    pfile_codegen_disable(pf, BOOLEAN_FALSE);
  }
}

/*
 * ALIAS name IS var
 */
static void jal_parse_alias(pfile_t *pf, const pfile_pos_t *statement_start)
{
  UNUSED(statement_start);
  if (!jal_token_is_identifier(pf)) {
    pfile_log(pf, PFILE_LOG_ERR, "identifier expected");
  } else {
    char       *id;
    variable_t  var;

    id = STRDUP(pf_token_get(pf, PF_TOKEN_CURRENT));
    if (!id) {
      pfile_log_syserr(pf, ENOMEM);
    } 
    if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "is")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    var = jal_parse_var_alias(pf);
    if (var) {
      variable_t avar;

      if (RESULT_OK == pfile_variable_alloc(pf, PFILE_VARIABLE_ALLOC_LOCAL,
        id, variable_def_get(var), var, &avar)) {
        variable_flag_set(avar, VARIABLE_FLAG_ALIAS);
        variable_release(avar);
      }
    }
    FREE(id);
  }
}

/*
 * NAME
 *   jal_statement_process
 *
 * DESCRIPTION
 *   process a single JAL statement
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   BOOLEAN_TRUE : a statement was processed
 *   BOOLEAN_FALSE: no statement was processed
 *
 * NOTES
 */
boolean_t jal_statement_process(pfile_t *pf)
{
  size_t      ii;
  cmd_t       cmd_init;
  pfile_pos_t pos;
  boolean_t   rc;

  /*
   * note : JAL is much simpler than BASIC because everything
   *        must be predefined. This means only a single pass
   *        through the source.
   *        Also, there is no end of statement to deal with.
   */       
  /* NONE   -- immediately call the action routine
   * ABSORB -- get the next statement before calling the action routine
   */
#define JAL_STATEMENT_TOKEN_NONE   0x0000
#define JAL_STATEMENT_TOKEN_ABSORB 0x0001
  static struct {
    const char *tag;
    void      (*fn)(pfile_t *, const pfile_pos_t *statement_start);
    unsigned    flags;
  } keyword_table[] = {
    {"var",         jal_parse_var,        JAL_STATEMENT_TOKEN_ABSORB},
    {"const",       jal_parse_const,      JAL_STATEMENT_TOKEN_ABSORB},
    {"if",          jal_parse_if,         JAL_STATEMENT_TOKEN_ABSORB},
    {"while",       jal_parse_while,      JAL_STATEMENT_TOKEN_ABSORB},
    {"for",         jal_parse_for,        JAL_STATEMENT_TOKEN_ABSORB},
    {"forever",     jal_parse_forever,    JAL_STATEMENT_TOKEN_ABSORB},
    {"asm",         jal_parse_asm,        JAL_STATEMENT_TOKEN_ABSORB},
    {"assembler",   jal_parse_assembler,  JAL_STATEMENT_TOKEN_ABSORB},
    {"return",      jal_parse_return,     JAL_STATEMENT_TOKEN_ABSORB},
    {"procedure",   jal_parse_procedure,  JAL_STATEMENT_TOKEN_ABSORB},
    {"function",    jal_parse_function,   JAL_STATEMENT_TOKEN_ABSORB},
    {"include",     jal_parse_include,    JAL_STATEMENT_TOKEN_NONE},
    {"pragma",      jal_parse_pragma,     JAL_STATEMENT_TOKEN_ABSORB},
    {"task",        jal_parse_task,       JAL_STATEMENT_TOKEN_ABSORB},
    {"start",       jal_parse_start,      JAL_STATEMENT_TOKEN_ABSORB},
    {"suspend",     jal_parse_suspend,    JAL_STATEMENT_TOKEN_ABSORB},
    {"_usec_delay", jal_parse_usec_delay, JAL_STATEMENT_TOKEN_ABSORB},
    {"_warn",       jal_parse_warn,       JAL_STATEMENT_TOKEN_ABSORB},
    {"_error",      jal_parse_error,      JAL_STATEMENT_TOKEN_ABSORB},
    {"_debug",      jal_parse_debug,      JAL_STATEMENT_TOKEN_ABSORB},
    {"block",       jal_parse_block,      JAL_STATEMENT_TOKEN_ABSORB},
    {"case",        jal_parse_case,       JAL_STATEMENT_TOKEN_ABSORB},
    {"assert",      jal_parse_assert,     JAL_STATEMENT_TOKEN_ABSORB},
    {"exit",        jal_parse_exit,       JAL_STATEMENT_TOKEN_ABSORB},
    {"repeat",      jal_parse_repeat,     JAL_STATEMENT_TOKEN_ABSORB},
    {"alias",       jal_parse_alias,      JAL_STATEMENT_TOKEN_ABSORB},
    {"record",      jal_parse_record,     JAL_STATEMENT_TOKEN_ABSORB}
  };

  pf_token_start_get(pf, &pos);
  pfile_statement_start_set(pf, &pos);

  pf_token_start_get(pf, &pos);
  pfile_statement_start_set(pf, &pos);
  cmd_init = pfile_cmdlist_tail_get(pf);
  for (ii = 0; 
       (ii < COUNT(keyword_table))
       && !pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE,
         keyword_table[ii].tag);
       ii++)
    ;
  if (ii < COUNT(keyword_table)) {
    if (keyword_table[ii].flags & JAL_STATEMENT_TOKEN_ABSORB) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    keyword_table[ii].fn(pf, &pos);
    rc = BOOLEAN_TRUE;
  } else if (jal_parse_assign(pf)) {
    rc = BOOLEAN_TRUE;
  } else {
    rc = BOOLEAN_FALSE;
  }
  if (pfile_cmdlist_tail_get(pf) != cmd_init) {
    pfile_cmd_special_add(pf, CMD_TYPE_STATEMENT_END, 0);
  }
  return rc;
}


/*
 * NAME
 *   jal_block_process
 *
 * DESCRIPTION
 *   process until a block end occurs
 *
 * PARAMETERS
 *   pf    : returned by pfile_open()
 *   flags : see JAL_BLOCK_PROCESS_FLAG_* in jal_blck.h
 *
 * RETURN
 *   none
 *
 * NOTES
 *   return on EOF or the first non parsable token
 */
void jal_block_process(pfile_t *pf, flag_t flags)
{
  if (!(flags & JAL_BLOCK_PROCESS_FLAG_NO_BLOCK)) {
    pfile_block_enter(pf);
  }
  while (jal_statement_process(pf))
    ; /* empty body */
  if (!(flags & JAL_BLOCK_PROCESS_FLAG_NO_BLOCK)) {
    pfile_block_leave(pf);
  }
}

void jal_source_process(pfile_t *pf)
{
  label_t     lbl;
  pfile_pos_t pos;

  pf_token_get(pf, PF_TOKEN_FIRST);
  pf_token_start_get(pf, &pos);
  pfile_statement_start_set(pf, &pos);
  lbl = pfile_label_alloc(pf, "_main");
  pfile_user_entry_set(pf, lbl);
  pfile_cmd_label_add(pf, lbl);
  label_release(lbl);
  jal_block_process(pf, JAL_BLOCK_PROCESS_FLAG_NO_BLOCK);
  if (!pf_token_is_eof(pf)) {
    pfile_log(pf, PFILE_LOG_ERR, "unexpected token: %s",
      pf_token_get(pf, PF_TOKEN_CURRENT));
  }
  pfile_cmd_special_add(pf, CMD_TYPE_END, 0);
}


void jal_file_process(pfile_t *pf, char *pre_inc)
{
  size_t        ii;

  static const struct {
    const char         *tag;
    variable_def_type_t type;
    flag_t              flags;
    variable_sz_t       sz;
  } basetypes[] = {
    {"bit",     VARIABLE_DEF_TYPE_BOOLEAN, VARIABLE_DEF_FLAG_BIT,    1},
    {"byte",    VARIABLE_DEF_TYPE_INTEGER, VARIABLE_DEF_FLAG_NONE,   1},
    {"sbyte",   VARIABLE_DEF_TYPE_INTEGER, VARIABLE_DEF_FLAG_SIGNED, 1},
    {"word",    VARIABLE_DEF_TYPE_INTEGER, VARIABLE_DEF_FLAG_NONE,   2},
    {"sword",   VARIABLE_DEF_TYPE_INTEGER, VARIABLE_DEF_FLAG_SIGNED, 2},
    {"dword",   VARIABLE_DEF_TYPE_INTEGER, VARIABLE_DEF_FLAG_NONE,   4},
    {"sdword",  VARIABLE_DEF_TYPE_INTEGER, VARIABLE_DEF_FLAG_SIGNED, 4},
    {"float",   VARIABLE_DEF_TYPE_FLOAT,   VARIABLE_DEF_FLAG_SIGNED, 4}
  };

  for (ii = 0; ii < COUNT(basetypes); ii++) {
    variable_def_t vdef;

    vdef = variable_def_alloc(basetypes[ii]. tag,basetypes[ii].type,  
      basetypes[ii].flags, basetypes[ii].sz);
    if (vdef) {
      pfile_variable_def_add(pf, vdef);
    }
  }

  pic_init(pf); /* intialize the pic-specific bits */
  pfile_log(pf, PFILE_LOG_INFO, "generating p-code");
  while (pre_inc) {
    char *next;

    next = strchr(pre_inc, ';');
    if (next) {
      *next = 0;
    }
    pfile_include_process(pf, (next) ? (next - pre_inc) : 0, pre_inc);
    if (next) {
      *next = ';';
      next++;
    }
    pre_inc = next;
  }
  jal_source_process(pf);
}

void jal_block_start_show(pfile_t *pf, const char *tag, 
  const pfile_pos_t *statement_start)
{
  pfile_log(pf, PFILE_LOG_ERR,
    "{%s starts at %s:%u}", tag,
    pfile_source_name_get(statement_start->src),
    statement_start->line);
}

