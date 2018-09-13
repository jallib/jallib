/**********************************************************
 **
 ** jal_proc.c : JAL proc parsing
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <errno.h>
#include <string.h>
#include <assert.h>
#include "../libutils/mem.h"
#include "../libcore/cmd_brch.h"
#include "../libcore/pf_msg.h"
#include "../libcore/pf_cmd.h"
#include "../libcore/pf_expr.h"
#include "../libcore/pf_proc.h"
#include "../libcore/vardef.h"
#include "jal_vdef.h"
#include "jal_blck.h"
#include "jal_expr.h"
#include "jal_proc.h"

/*
 * PROCEDURE name [( type [volatile] [in] [out] name [ = expr ] ) IS ... 
 *   END PROCEDURE
 * TASK name [( [type [volatile] in name[,...]] ) IS ... 
 *   END TASK
 * FUNCTION name [( type [volatile] [in] [out] name [ = expr ] ) RETURN type 
 *   IS ... END FUNCTION
 */    
typedef enum {
  JAL_PARSE_PROCEDURE,
  JAL_PARSE_FUNCTION,
  JAL_PARSE_TASK
} jal_parse_proc_type;

/* allocate a function reference, return type is ret,
 * parameter type is parm */
static variable_def_t jal_variable_fn_def_alloc(pfile_t *pf,
  variable_def_t ret, variable_def_t parm, flag_t fn_flags)
{
  variable_def_t base;
  variable_def_t def;

  base = variable_def_alloc(0, VARIABLE_DEF_TYPE_POINTER,
      VARIABLE_DEF_FLAG_IN, pfile_pointer_size_get(pf));
  def  = variable_def_alloc(0, VARIABLE_DEF_TYPE_FUNCTION, fn_flags, 0);
  variable_def_member_add(base, 0, def, 1);
  if (ret) {
    ret = variable_def_flags_change(ret, VARIABLE_DEF_FLAG_OUT);
  }
  variable_def_member_add(def, 0, ret, 1);
  if (parm) {
    parm = variable_def_flags_change(parm, 
      (variable_def_flags_get_all(parm) & ~VARIABLE_DEF_FLAG_OUT)
      | VARIABLE_DEF_FLAG_IN);
    variable_def_member_add(def, 0, parm, 1);
  }
  return base;
}

void jal_parse_procedure_common(pfile_t *pf, jal_parse_proc_type type,
  const pfile_pos_t *statement_start)
{
  size_t          sz;
  variable_def_t  return_def;  /* return value definition */
  variable_def_t  var_def;     /* for GET & PUT, this is the required def */
  variable_def_t  proc_def;    /* full procedure definition */
  char           *proc_name_buf;
  char           *proc_name_ptr;
  pfile_proc_t   *proc;
  size_t          params_ct;
  size_t          params_expected; /* for 'get & 'put */
  variable_t     *params;
  size_t          params_alloc;
  enum {
    PROC_USER, /* user defined procedure */
    PROC_GET,  /* GET procedure          */
    PROC_PUT   /* PUT procedure          */
  } proc_type;

  return_def      = VARIABLE_DEF_NONE;
  var_def         = VARIABLE_DEF_NONE;
  params_ct       = 0;
  params_expected = 0;
  params_alloc    = 0;
  params          = 0;

  proc_def = variable_def_alloc(0, VARIABLE_DEF_TYPE_FUNCTION, 0, 0);

  jal_identifier_is_reserved(pf);

  sz = strlen(pf_token_ptr_get(pf));
  proc_name_buf = MALLOC(sz + 8);
  if (!proc_name_buf) {
    pfile_log_syserr(pf, ENOMEM);
    proc_name_ptr = 0;
  } else {
    proc_name_buf[0] = '_';
    proc_name_buf[1] = '_';
    proc_name_ptr = proc_name_buf + 2;
    memcpy(proc_name_ptr, pf_token_ptr_get(pf), sz + 1);
  }
  pf_token_get(pf, PF_TOKEN_NEXT);
  if ((JAL_PARSE_TASK != type)
    && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "'")) {
    const char *expect;

    expect = 0;
    switch (type) {
      case JAL_PARSE_PROCEDURE: expect = "put"; break;
      case JAL_PARSE_FUNCTION:  expect = "get"; break;
      case JAL_PARSE_TASK:      break; /* cannot get here */
    }
    if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, expect)) {
      pfile_block_t *blk;
      variable_t     var;

      blk = pfile_proc_block_active_get(
        pfile_proc_active_get(pf));
      proc_type = (JAL_PARSE_PROCEDURE == type)
        ? PROC_PUT
        : PROC_GET;
      /* first look for a corresponding variable to find its definition */
      var = pfile_block_variable_find(blk, proc_name_ptr);
      if (var) {
        var_def = variable_def_get(var);
        if (VARIABLE_DEF_TYPE_ARRAY == variable_def_type_get(var_def)) {
          /* this is an array, so find out what type it *really* is */
          var_def = variable_def_member_def_get(
              variable_def_member_get(var_def));
          params_expected = (JAL_PARSE_PROCEDURE == type)
            ? 2 : 1;
        } else {
          params_expected = (JAL_PARSE_PROCEDURE == type)
            ? 1 : 0;
        }
#if 0
        /* i've no idea why I used to do this! */
        if (PROC_PUT == proc_type) {
          variable_assign_ct_bump(var, CTR_BUMP_INCR);
        } else {
          variable_use_ct_bump(var, CTR_BUMP_INCR);
        }
#endif
        variable_release(var);
      } else {
        char *ptr;
        /* no variable, look for a corresponding _get or _put */

        ptr = proc_name_ptr + strlen(proc_name_ptr);
        strcpy(ptr, (JAL_PARSE_PROCEDURE == type) ? "_get" : "_put");
        proc_name_ptr[-1] = '_';
        proc = pfile_proc_find(pf, PFILE_LOG_NONE, proc_name_ptr - 1);
        if (proc) {
          variable_def_member_t mbr;

          /* mbr points to the return value */
          for (mbr = variable_def_member_get(pfile_proc_def_get(proc));
               variable_def_member_link_get(mbr);
               mbr = variable_def_member_link_get(mbr), params_expected++)
            ; /* empty body */
          params_expected--; /* ignore the return parameter */
          if (JAL_PARSE_PROCEDURE == type) {
            params_expected--;
          }
          if (PROC_GET == proc_type) {
            /* we need the definition of the last member
             * (the 1st member is the return value, members
             * after that are indices */
            var_def = variable_def_member_def_get(mbr);
          } else {
            var_def = pfile_proc_return_def_get(proc);
          }
        } else {
          params_expected = -1;
        }
        *ptr = 0;
      }
      strcat(proc_name_ptr, "_");
      strcat(proc_name_ptr, expect);
      proc_name_ptr--;
      pf_token_get(pf, PF_TOKEN_NEXT);
    } else {
      proc_type     = PROC_USER;
      proc_name_ptr = 0;
    }
  } else {
    proc_type = PROC_USER;
  }
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "(")) {
    /* parse the parameters */
    /* some folks find it more intuitive to use '()' to denote
     * an empty parameter list, so allow it */
    pf_token_get(pf, PF_TOKEN_NEXT);
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ")")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    } else {
      boolean_t is_first;

      is_first = BOOLEAN_TRUE;
      do {
        variable_t var;
        flag_t     flags;

        if (is_first) {
          is_first = BOOLEAN_FALSE;
        } else {
          pf_token_get(pf, PF_TOKEN_NEXT);
        }
        if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "volatile")) {
          flags = VARIABLE_DEF_FLAG_VOLATILE;
          pf_token_get(pf, PF_TOKEN_NEXT);
        } else {
          flags = VARIABLE_DEF_FLAG_NONE;
        }
        var = VARIABLE_NONE;
        jal_parse_var_common(pf, statement_start, &var, flags);
        if ((JAL_PARSE_TASK == type)
            && variable_dflag_test(var, VARIABLE_DEF_FLAG_OUT)) {
          pfile_log(pf, PFILE_LOG_ERR,
              "OUT parameters are not allowed for TASKs");
        }
        if (variable_dflag_test(var, VARIABLE_DEF_FLAG_VOLATILE)
            && !variable_master_get(var)) {
          /* this is really a function call or two */
          char *vname;
          char *vname_ptr;

          vname = MALLOC(strlen(variable_name_get(var)) + 6);
          sprintf(vname, "_%s", variable_name_get(var));
          vname_ptr = vname + strlen(vname);
          if (variable_dflag_test(var, VARIABLE_DEF_FLAG_IN)) {
            /* change the name to: '_*_get', type = function,
             * return type = variable type, parameters = none
             * keep the OUT flag to let the caller know it needs
             * an OUT also */
            strcpy(vname_ptr, "_get");
            variable_def_member_add(
              proc_def, 
              vname, 
              jal_variable_fn_def_alloc(
                pf, 
                variable_def_get(var),
                VARIABLE_DEF_NONE, 
                VARIABLE_DEF_FLAG_IN
                | (variable_dflag_test(var, VARIABLE_DEF_FLAG_OUT)
                   ? VARIABLE_DEF_FLAG_OUT : 0)), 
              1);
          }
          if (variable_dflag_test(var, VARIABLE_DEF_FLAG_OUT)) {
            /* change the name to: '_*_put', type = function,
             * return type = none, parameters = variable type */
            strcpy(vname_ptr, "_put");
            variable_def_member_add(
              proc_def, 
              vname, 
              jal_variable_fn_def_alloc(
                pf, 
                VARIABLE_DEF_NONE, 
                variable_def_get(var), 
                VARIABLE_DEF_FLAG_OUT),
              1);
          }
          FREE(vname);
        } else {
          /* if this is a variable with infinite (aka, no) dimension
           * turn it into a pointer; add the _name_count so the COUNT()
           * operator will work as expected
           */
          if (variable_dflag_test(var, VARIABLE_DEF_FLAG_BYREF)
              || (variable_is_array(var) 
                && ((variable_sz_t) -1 == variable_def_member_ct_get(
                    variable_def_member_get(
                      variable_def_get(var)
                      )
                    )
                  )
                )) {
            variable_def_t vdef;

            if (variable_is_array(var)) {
              char *vname;

              vname = MALLOC(strlen(variable_name_get(var)) + 8);
              sprintf(vname, "_%s_count", variable_name_get(var));
              variable_def_member_add(proc_def, vname,
                variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
                  VARIABLE_DEF_FLAG_IN, 2), 1);
              FREE(vname);
            }
            vdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_POINTER,
                variable_def_flags_get_all(variable_def_get(var)), 
                pfile_pointer_size_get(pf));
            if (variable_is_array(var)) {
              variable_def_member_add(vdef,
                  0, /* no tag */
                  variable_def_dup(
                    variable_def_member_def_get(
                      variable_def_member_get(
                        variable_def_get(
                          var
                          )
                        )
                      )
                    ),
                  1
                  );
            } else {
              variable_def_member_add(vdef,
                  0, /* no tag */
                  variable_def_dup(
                    variable_def_get(
                      var
                      )
                    ),
                  1
                  );
            }
            variable_def_set(var, vdef);
          }
          variable_def_member_add(proc_def, variable_name_get(var),
            variable_def_get(var), 1);
        }
        /* i need to hold onto the variables in case one of the parameters
           is an alias. There is no way to convey this information in the
           variable_def structure, and I don't think it makes a lot of
           sense to do so (it would need master/offset/bit). Instead I'll
           hold onto the variable definitions & add fixup the procedure's
           parameters after allocating it */
        if (params_ct == params_alloc) {
          void  *tmp;
          size_t newalloc;

          newalloc = (params_alloc) ? 2 * params_alloc : 16;

          tmp = REALLOC(params, sizeof(*params) * newalloc);
          if (tmp) {
            params = tmp;
            params_alloc = newalloc;
          }
        }
        if (params_ct < params_alloc) {
          params[params_ct] = var;
        } else {
          variable_release(var);
        }
        params_ct++;
      } while (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ","));
      if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, ")")) {
        pf_token_get(pf, PF_TOKEN_NEXT);
      }
    }
  }
  if (JAL_PARSE_FUNCTION == type) {
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "return")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
      return_def = jal_vdef_get(pf, VARIABLE_DEF_FLAG_NONE);
      if (return_def) {
        return_def = variable_def_flags_change(return_def,
          variable_def_flags_get_all(return_def) | VARIABLE_DEF_FLAG_OUT);
      }
    }
  }
  switch (proc_type) {
    case PROC_USER: 
      break;
    case PROC_GET:
      if ((size_t) -1 == params_expected) {
        if (params_ct < 2) {
          params_expected = params_ct;
        } else {
          pfile_log(pf, PFILE_LOG_ERR,
              "GET functions can have 0 or 1 parameters");
          params_expected = 0;
        }
      }
      if (0 == params_expected) {
        if (params_ct) {
          pfile_log(pf, PFILE_LOG_ERR, "no parameters expected");
        }
        if (var_def && !variable_def_is_same(return_def, var_def)) {
          pfile_log(pf, PFILE_LOG_ERR, "type mismatch");
        }
      } else if (1 == params_expected) {
        /* the first parameter must be IN only */
        variable_def_t ix_def;

        ix_def = variable_def_member_def_get(
          variable_def_member_get(proc_def));
        if (params_ct != params_expected) {
          pfile_log(pf, PFILE_LOG_ERR, "%lu parameters expected", 
              (ulong) params_expected);
        } else {
          if (VARIABLE_DEF_TYPE_INTEGER != variable_def_type_get(ix_def)) {
            pfile_log(pf, PFILE_LOG_ERR, "Index must be an integer");
          }
          if (!variable_def_flag_test(ix_def, VARIABLE_DEF_FLAG_IN)) {
            pfile_log(pf, PFILE_LOG_ERR, "Index must be an IN parameter");
          }
          if (variable_def_flag_test(ix_def, VARIABLE_DEF_FLAG_OUT)) {
            pfile_log(pf, PFILE_LOG_ERR, "Index must NOT be an OUT parameter");
          }
        }
        /* the return type must match */
        if (var_def && !variable_def_is_same(return_def, var_def)) {
          /*variable_def_member_def_get(variable_def_member_get(var_def)))) {*/
          pfile_log(pf, PFILE_LOG_ERR, "type mismatch");
        }
      } else {
        pfile_log(pf, PFILE_LOG_ERR, 
          "A GET function can have 0 or 1 parameters.");
      }
      break;
    case PROC_PUT:
      {
        variable_def_t        param_def;
        variable_def_member_t param_mbr;
        size_t                ct;

        if ((size_t) -1 == params_expected) {
          if (params_ct < 3) {
            params_expected = params_ct;
          } else {
            pfile_log(pf, PFILE_LOG_ERR, 
                "PUT procedures can have 1 or 2 parameters");
            params_expected = 1;
          }
        }
        param_mbr = variable_def_member_get(proc_def);
        param_def = variable_def_member_def_get(param_mbr);
        ct = params_ct;

        if (2 == ct) {
          /* the first member is the index. it must be IN only */
          if (VARIABLE_DEF_TYPE_INTEGER != variable_def_type_get(param_def)) {
            pfile_log(pf, PFILE_LOG_ERR, "Index must be an integer");
          }
          if (!variable_def_flag_test(param_def, VARIABLE_DEF_FLAG_IN)) {
            pfile_log(pf, PFILE_LOG_ERR, "Index must be IN");
          }
          if (variable_def_flag_test(param_def, VARIABLE_DEF_FLAG_OUT)) {
            pfile_log(pf, PFILE_LOG_ERR, "Index must *not* be OUT");
          }
          param_mbr = variable_def_member_link_get(param_mbr);
          param_def = variable_def_member_def_get(param_mbr);
          /* dereference var_def */
          ct--;
        }
        if (1 != ct) {
          pfile_log(pf, PFILE_LOG_ERR, 
            "PUT function require one or two parameters");
        } 
        if (var_def
          && !variable_def_is_same(var_def, param_def)) {
          pfile_log(pf, PFILE_LOG_ERR, "type mismatch");
        }
        if (!variable_def_flag_test(param_def, VARIABLE_DEF_FLAG_IN)) {
          pfile_log(pf, PFILE_LOG_ERR, "PUT requires an IN parameter");
        }
        if (variable_def_flag_test(param_def, VARIABLE_DEF_FLAG_OUT)) {
          pfile_log(pf, PFILE_LOG_ERR, "PUT parameter cannot be OUT");
        }
      }
      break;
  }
  /* add the return def */
  variable_def_member_insert(proc_def, 0, 0, return_def, 1);

  /* create the procedure */
  if (!proc_name_ptr) {
    proc = PFILE_PROC_NONE;
  } else {
    proc = pfile_proc_find(pf, PFILE_LOG_NONE, proc_name_ptr);
    if (proc) {
      if (!variable_def_is_same(proc_def, pfile_proc_def_get(proc))) {
        pfile_log(pf, PFILE_LOG_ERR, "function signature is different");
      }
    } else {
      proc = pfile_proc_create(pf, proc_name_ptr, proc_def);
      if (JAL_PARSE_TASK == type) {
        pfile_proc_flag_set(proc, PFILE_PROC_FLAG_TASK);
      }
    }
  }
  FREE(proc_name_buf);
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "is")) {
    const char        *etype;
    label_t            proc_lbl;

    pf_token_get(pf, PF_TOKEN_NEXT);
    /* it looks like ``begin'' is optional if it follows ``is'' */
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "begin")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }

    proc_lbl = pfile_proc_label_get(proc);

    if (proc) {
      size_t ii;

      pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
          CMD_BRANCHCOND_NONE, pfile_proc_skip_label_get(proc), 
            VALUE_NONE, VALUE_NONE, 0);
      pfile_proc_enter(pf, pfile_proc_tag_get(proc));
      pfile_block_enter(pf);

      if (label_flag_test(proc_lbl, LABEL_FLAG_DEFINED)) {
        pfile_log(pf, PFILE_LOG_ERR, "function already defined");
      } else {
        label_flag_test(proc_lbl, LABEL_FLAG_DEFINED);
      }
      pfile_proc_define(proc, proc_def, pf);
      /* proc_define takes the proc_def and creates the necessary
       * variables from it. Unfortunately, proc_def doesn't contain
       * information about masters, or bases, so that is passed
       * in here. */
      for (ii = 0; (ii < params_ct) && (ii < params_alloc); ii++) {
        if (variable_master_get(params[ii])
          || (VARIABLE_BASE_UNKNOWN != variable_base_real_get(params[ii], 0))) {
          variable_t tmp;

          /* remember, proc[0] = return value */
          tmp = value_variable_get(pfile_proc_param_get(proc, ii+1));
          variable_bit_offset_set(tmp, variable_bit_offset_get(params[ii]));
          variable_base_set(tmp, variable_base_real_get(params[ii], 0), 0);
          variable_master_set(tmp, variable_master_get(params[ii]));
          if (variable_is_alias(params[ii])) {
            variable_flag_set(tmp, VARIABLE_FLAG_ALIAS);
          }
        }
      }
    }

    label_flag_set(pfile_proc_label_get(proc), LABEL_FLAG_DEFINED);
    /*pfile_emit_enter_cmd(pf);*/
    jal_block_process(pf, JAL_BLOCK_PROCESS_FLAG_NO_BLOCK);
    etype = "???";
    switch (type) {
      case JAL_PARSE_PROCEDURE: etype = "procedure"; break;
      case JAL_PARSE_FUNCTION:  etype = "function";  break;
      case JAL_PARSE_TASK:      etype = "task";      break;
    }
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "end")
      && pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, etype)) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    } else {
      jal_block_start_show(pf, etype, statement_start);
    }
    if (proc) {
      pfile_cmd_label_add(pf, pfile_proc_exit_label_get(proc));
      pfile_block_leave(pf);
      pfile_proc_leave(pf);
      pfile_cmd_label_add(pf, pfile_proc_skip_label_get(proc));
    }
  }
  while (params_ct--) {
    if (params_ct < params_alloc) {
      variable_release(params[params_ct]);
    }
  }
  FREE(params);
}

void jal_parse_procedure(pfile_t *pf, const pfile_pos_t *statement_start)
{
  jal_parse_procedure_common(pf, JAL_PARSE_PROCEDURE, statement_start);
}

void jal_parse_function(pfile_t *pf, const pfile_pos_t *statement_start)
{
  jal_parse_procedure_common(pf, JAL_PARSE_FUNCTION, statement_start);
}

void jal_parse_return(pfile_t *pf, const pfile_pos_t *statement_start)
{
  label_t       lbl;
  pfile_proc_t *proc;

  UNUSED(statement_start);
  proc = pfile_proc_active_get(pf);
  lbl = pfile_proc_exit_label_get(proc);
  if (!lbl) {
    pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_SYNTAX_ERROR);
  } else {
    value_t val;
    value_t expr;

    val = pfile_proc_param_get(proc, 0);
    if (val) {
      expr = jal_parse_expr(pf);
      if (expr) {
        pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &val, expr, VALUE_NONE);
        value_release(expr);
      }
    }
    pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
        CMD_BRANCHCOND_NONE, lbl, VALUE_NONE, VALUE_NONE, 0);
  }
}

/*
 * NAME
 *   jal_volatile_function_create
 *
 * DESCRIPTION
 *   create an implicit GET or PUT function
 *
 * PARAMETERS
 *   pf       : pfile handle
 *   var_name : variable name
 *   fn_name  : function name
 *
 * RETURN
 *   value
 *
 * NOTES
 */
typedef enum {
  JAL_VOLATILE_FN_GET,
  JAL_VOLATILE_FN_PUT
} jal_volatile_fn_type;

static value_t jal_volatile_function_create(pfile_t *pf, 
    jal_volatile_fn_type type, const char *var_name)
{
  value_t tmp;
  value_t val;

  val = pfile_value_find(pf, PFILE_LOG_ERR, var_name);
  tmp = VALUE_NONE;
  if (val) {
    variable_def_t  proc_def;
    variable_def_t  return_def;
    variable_def_t  param_def;
    pfile_proc_t   *proc;
    variable_t      var;
    pfile_block_t  *blk;
    char           *fn_name;
    size_t          fn_name_sz;
    const char     *fn_suffix;

    fn_name_sz = 7 + strlen(var_name);

    proc_def   = variable_def_alloc(0, VARIABLE_DEF_TYPE_FUNCTION, 0, 0);
    return_def = VARIABLE_DEF_NONE;
    param_def  = VARIABLE_DEF_NONE;
    fn_suffix  = "";
    switch (type) {
      case JAL_VOLATILE_FN_GET:
        return_def = value_def_get(val);
        return_def = variable_def_flags_change(return_def,
            variable_def_flags_get_all(param_def) | VARIABLE_DEF_FLAG_OUT);
        fn_suffix = "vget";
        break;
      case JAL_VOLATILE_FN_PUT:
        param_def = value_def_get(val);
        param_def = variable_def_flags_change(param_def,
            (variable_def_flags_get_all(param_def) 
            & ~VARIABLE_DEF_FLAG_VOLATILE)
            | VARIABLE_DEF_FLAG_IN);
        fn_suffix = "vput";
        break;
    }

    variable_def_member_add(proc_def, 0, return_def, (return_def) ? 1 : 0);
    if (param_def) {
      variable_def_member_add(proc_def, "n", param_def, 1);
    }

    fn_name = MALLOC(fn_name_sz);
    if (!fn_name) {
      pfile_log_syserr(pf, ENOMEM);
      tmp = VALUE_NONE;
    } else {
      pfile_proc_t  *pfproc_active;   /* current active proc */
      pfile_block_t *pfblock_active; /* current active block within proc */

      /*
       * this function needs to be created in the same
       * proc and block of the named variable. So...
       * first, find exactly where the variable is
       */
      sprintf(fn_name, "_%s_%s", var_name, fn_suffix);
      var = pfile_variable_find(pf, PFILE_LOG_ERR, var_name, &blk);
      variable_release(var);
      /*
       * use the information to create the procedures in the
       * correct place
       */
      pfproc_active  = pfile_proc_active_get(pf);
      pfblock_active = pfile_proc_block_active_get(pfproc_active);
      pfile_proc_active_set(pf, pfile_block_owner_get(blk));
      pfile_proc_block_active_set(pfile_block_owner_get(blk), blk);
      proc = pfile_proc_create(pf, fn_name, proc_def);
      pfile_proc_block_active_set(pfile_block_owner_get(blk), pfblock_active);
      pfile_proc_active_set(pf, pfproc_active);

      pfile_cmd_cursor_set(pf, pfile_block_cmd_get(blk));
      pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
          CMD_BRANCHCOND_NONE, pfile_proc_skip_label_get(proc),
          VALUE_NONE, VALUE_NONE, 0);
      pfile_proc_enter(pf, pfile_proc_tag_get(proc));
      pfile_block_enter(pf);
      pfile_proc_define(proc, proc_def, pf);
      switch (type) {
        case JAL_VOLATILE_FN_GET:
          tmp = pfile_proc_param_get(proc, 0);
          pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &tmp, val, VALUE_NONE);
          break;
        case JAL_VOLATILE_FN_PUT:
          tmp = pfile_proc_param_get(proc, 1);
          pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &val, tmp, VALUE_NONE);
          break;
      }
      pfile_block_leave(pf);
      pfile_proc_leave(pf);
      pfile_cmd_label_add(pf, pfile_proc_skip_label_get(proc));
      pfile_cmd_cursor_set(pf, CMD_NONE);
      tmp = pfile_value_find(pf, PFILE_LOG_ERR, fn_name);
      value_release(val);
    }
  }
  return tmp;
}

/*
 * NAME
 *   jal_parse_call
 *
 * DESCRIPTION
 *   parse a call
 *
 * PARAMETERS
 *   pf  : pfile handle
 *   val : a function, a function pointer, or a function reference
 *
 * RETURN
 *   The resulting value, or VALUE_NONE
 *
 * NOTES
 *   This will automatically deference val.
 */
value_t jal_parse_call(pfile_t *pf, value_t call_val, flag_t flags)
{
  value_t              *parms;
  value_t              *put_parms; /* needed for any 'put */
  size_t                param_ct;
  variable_def_t        def;
  variable_def_member_t mbr;
  value_t               val;
  boolean_t             is_put;
  const char           *param_open;
  const char           *param_close;
  size_t                ii;

  is_put = flags & JAL_PARSE_CALL_FLAG_PUT;
  assert((VALUE_NONE == call_val)
      || (VARIABLE_DEF_TYPE_FUNCTION == value_type_get(call_val)));
  def = value_def_get(call_val);
  for (mbr = variable_def_member_get(def), param_ct = 0;
       mbr;
       mbr = variable_def_member_link_get(mbr), param_ct++)
    ; /* null body */

  if (!param_ct) {
    param_ct = 1;
  }
  parms = CALLOC(sizeof(*parms), param_ct);
  put_parms = CALLOC(sizeof(*put_parms), param_ct);
  if (!parms || !put_parms) {
    pfile_log_syserr(pf, ENOMEM);
  }

  mbr = variable_def_member_get(def);
  if (parms) {
    if (variable_def_member_def_get(mbr)) {
        parms[0] = pfile_value_temp_get_from_def(pf, 
            variable_def_member_def_get(mbr));
    } else {
      parms[0] = VALUE_NONE;
    }
  }

  if (flags & (JAL_PARSE_CALL_FLAG_PUT | JAL_PARSE_CALL_FLAG_GET)) {
    param_open = "[";
    param_close = "]";
  } else {
    param_open = "(";
    param_close = ")";
  }
  ii = 1;
  if (is_put 
      || pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, param_open)) {
    boolean_t need_close;

    need_close = !is_put && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE,
        param_open);

    if (is_put || need_close) {

      if (need_close) {
        pf_token_get(pf, PF_TOKEN_NEXT);
      }
      if (!pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, param_close)) {
        for (ii = 1;
            /*(ii < param_ct) */
            ((1 == ii)
              || (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ",")));
             ii++) {
          const char *ptr;
          /*const char *vname;*/
          boolean_t   need_ct;

          /* skip either the opening '(' or the last ',' */
          if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ",")) {
            ptr = pf_token_get(pf, PF_TOKEN_NEXT);
          } else {
            ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
          }
          mbr = variable_def_member_link_get(mbr);
          def = variable_def_member_def_get(mbr);
#if 0
          vname = variable_def_member_tag_get(mbr);
          if (vname
            && ('_' == vname[0])
            && (strlen(vname) > 7)
            && (0 == strcmp(vname + strlen(vname) - 6, "_count"))) {
            /* this is a COUNT. the next parameter must be either an array
             * or an pointer. if the former, this parameter is set
             * to the number of elements. If the later, there should
             * be an associated _*_count variable
             */
            char   *ct_name;
            value_t ct_val;

            ct_name = MALLOC(strlen(ptr) + 8);
            sprintf(ct_name, "_%s_count", ptr);
            ct_val = pfile_value_find(pf, PFILE_LOG_NONE, ct_name);
            FREE(ct_name);
            if (VALUE_NONE == ct_val) {
              /* get the actual value, check that it's an array, and go on */
              ct_val = pfile_value_find(pf, PFILE_LOG_ERR, ptr);
              if (VALUE_NONE != ct_val) {
                if (!value_is_array(ct_val)) {
                  pfile_log(pf, PFILE_LOG_ERR, "array type expected");
                } else {
                  value_t tmp;

                  tmp = pfile_constant_get(pf, value_ct_get(ct_val), 
                    VARIABLE_DEF_NONE);
                  value_release(ct_val);
                  ct_val = tmp;
                }
              }
            }
            if (parms && (ii < param_ct)) {
              parms[ii] = ct_val;
            } else {
              value_release(ct_val);
            }
            mbr = variable_def_member_link_get(mbr);
            def = variable_def_member_def_get(mbr);
            ii++;
          }
#endif
          if ((ii + 1 < param_ct)
            && (VARIABLE_DEF_TYPE_INTEGER == variable_def_type_get(def))
            && VARIABLE_DEF_TYPE_POINTER
              == variable_def_type_get(
                variable_def_member_def_get(
                  variable_def_member_link_get(mbr)))) {
            /*
             * this must be the count associated with the pointer. 
             * skip it, it will be filled in later 
             */
            need_ct = BOOLEAN_TRUE;
            mbr     = variable_def_member_link_get(mbr);
            def     = variable_def_member_def_get(mbr);
            ii++;
          } else {
            need_ct = BOOLEAN_FALSE;
          }

          if ((VARIABLE_DEF_TYPE_POINTER == variable_def_type_get(def)) 
              && (VARIABLE_DEF_TYPE_FUNCTION == variable_def_type_get(
                  variable_def_member_def_get(
                    variable_def_member_get(
                      def)
                    )
                  )
                )) {
            /* this *must be* a function reference. this means a volatile
               parameter. look at the function defintion flags, they'll
               either be:
                 IN     -- the _get function is needed
                 IN|OUT -- the _get + _put functions are needed
                 OUT    -- the _put function is needed */
            value_t        jvals[JAL_VAL_TYPE_CT];
            variable_def_t fn_def;
            variable_def_t fn_def2;

            jal_value_find(pf, ptr, jvals);

            fn_def = variable_def_member_def_get( variable_def_member_get(def));
            if (variable_def_flag_test(fn_def, VARIABLE_DEF_FLAG_IN)) {
              if (jvals[JAL_VAL_TYPE_GET]) {
                val = jvals[JAL_VAL_TYPE_GET];
                value_lock(val);
              } else if (jvals[JAL_VAL_TYPE_IGET]) {
                val = jvals[JAL_VAL_TYPE_IGET];
                value_lock(val);
              } else {
                /* nb: the name might have changed (via alias), so if there's
                       a found entry, use its name instead */
                size_t valn;

                for (valn = JAL_VAL_TYPE_MIN;
                     (valn < JAL_VAL_TYPE_CT) && (VALUE_NONE == jvals[valn]);
                     valn++)
                  ; /* empty body */
                if (valn < JAL_VAL_TYPE_CT) {
                  ptr = value_name_get(jvals[valn]);
                }
                val = jal_volatile_function_create(pf, JAL_VOLATILE_FN_GET, 
                    ptr);
              }
                
              fn_def2 = value_def_get(val);
              if (VARIABLE_DEF_TYPE_POINTER == variable_def_type_get(fn_def2)) {
                fn_def2 = variable_def_member_def_get(
                  variable_def_member_get(fn_def2));
              }
              if (!variable_def_is_same(fn_def, fn_def2)) {
                pfile_log(pf, PFILE_LOG_ERR, "type mismatch");
                value_release(val);
                val = VALUE_NONE;
              }
              if (parms && (ii < param_ct)) {
                parms[ii] = val;
              } else {
                value_release(val);
              }
            }
            if (variable_def_flag_test(fn_def, VARIABLE_DEF_FLAG_OUT)) {
              if (variable_def_flag_test(fn_def, VARIABLE_DEF_FLAG_IN)) {
                /* this is an in/out so the next parameter must be the OUT
                   parameter */
                ii++;
                mbr = variable_def_member_link_get(mbr);
                fn_def = variable_def_member_def_get(
                  variable_def_member_get(
                    variable_def_member_def_get(mbr)));
              }

              if (jvals[JAL_VAL_TYPE_PUT]) {
                val = jvals[JAL_VAL_TYPE_PUT];
                value_lock(val);
              } else if (jvals[JAL_VAL_TYPE_IPUT]) {
                val = jvals[JAL_VAL_TYPE_IPUT];
                value_lock(val);
              } else {
                val = jal_volatile_function_create(pf, JAL_VOLATILE_FN_PUT, ptr);
              }
              fn_def2 = value_def_get(val);
              if (VARIABLE_DEF_TYPE_POINTER
                == variable_def_type_get(fn_def2)) {
                fn_def2 = variable_def_member_def_get(
                  variable_def_member_get(fn_def2));
              }
              if (!variable_def_is_same(fn_def, fn_def2)) {
                pfile_log(pf, PFILE_LOG_ERR, "parameter %u type mismatch",
                  (unsigned) ii);
                value_release(val);
                val = VALUE_NONE;
              }
              if (parms && (ii < param_ct)) {
                parms[ii] = val;
              } else {
                value_release(val);
              }
            }
            jal_value_release(jvals);
            pf_token_get(pf, PF_TOKEN_NEXT);
          } else if (variable_def_flag_test(def, VARIABLE_DEF_FLAG_OUT)) {
            /* this needs to be a simple variable or PUT procedure */
            value_t jvals[JAL_VAL_TYPE_CT];

            jal_value_find(pf, ptr, jvals);

            if (jvals[JAL_VAL_TYPE_PUT]) {
              variable_def_t        put_def;
              variable_def_member_t put_mbr;
              value_t               tval;

              val = jvals[JAL_VAL_TYPE_PUT];
              value_lock(val);
              tval = variable_def_flag_test(def, VARIABLE_DEF_FLAG_IN)
                ? jal_parse_value(pf, JAL_PARSE_VALUE_TYPE_RVALUE)
                : VALUE_NONE;
              if (put_parms && (ii < param_ct)) {
                put_parms[ii] = val;
              } else {
                value_release(val);
              }
              if (!tval || !value_is_temp(tval)) {
                put_def = value_def_get(val); /* this should be a function */
                put_mbr = variable_def_member_get(put_def);
                put_mbr = variable_def_member_link_get(put_mbr);
                put_def = variable_def_member_def_get(put_mbr);
                val = pfile_value_temp_get_from_def(pf, put_def);
                if (tval) {
                  pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &val, tval, VALUE_NONE);
                  value_release(tval);
                }
              } else {
                val = tval;
              }
              put_def = value_def_get(val);
              put_def = variable_def_flags_change(put_def,
                  variable_def_flags_get_all(put_def)
                  | VARIABLE_DEF_FLAG_OUT);
              value_def_set(val, put_def);
              if (!tval) {
                pf_token_get(pf, PF_TOKEN_NEXT);
              }
            } else {
              val = jal_parse_value(pf, JAL_PARSE_VALUE_TYPE_LVALUE);
              if (value_is_const(val)) {
                pfile_log(pf, PFILE_LOG_ERR, "%s cannot be a constant",
                    value_name_get(val));
              } else if (value_vflag_test(val, VARIABLE_FLAG_READ)
                && !value_vflag_test(val, VARIABLE_FLAG_WRITE)) {
                pfile_log(pf, PFILE_LOG_ERR, "cannot read %s",
                  value_name_get(val));
              }
              while (jal_parse_structure(pf, &val)
                || jal_parse_subscript(pf, &val))
                ; /* null body */
            }
            if (!((variable_def_type_is_number(variable_def_type_get(def))
                && value_is_number(val))
                || variable_def_is_same(def, value_def_get(val)))) {
              pfile_log(pf, PFILE_LOG_ERR, "type mismatch");
              value_release(val);
              val = VALUE_NONE;
            }
            if (parms && (ii < param_ct)) {
              parms[ii] = val;
            } else {
              value_release(val);
            }
            jal_value_release(jvals);
          } else {
            /* this must be IN only! */
            boolean_t      ok;
            variable_def_t vdef;

            val = jal_parse_expr(pf);
            if (value_vflag_test(val, VARIABLE_FLAG_WRITE)
              && !value_vflag_test(val, VARIABLE_FLAG_READ)) {
              pfile_log(pf, PFILE_LOG_ERR, "cannot read from %s",
                value_name_get(val));
            }
            if (ii < param_ct) {
              vdef = value_def_get(val);
              ok = variable_def_type_is_number(variable_def_type_get(def))
                      && value_is_number(val);
              if (ok) {
                pfile_value_def_type_check(pf, OPERATOR_ASSIGN, def, val,
                  VALUE_NONE);
                if (value_is_universal(val)) {
                  pfile_value_def_overflow_check(pf, OPERATOR_ASSIGN, def, val);
                }
              }
              ok = ok || variable_def_is_same(def, vdef);
              /*
               * allow the assignment of an array to a pointer
               */
              ok = ok 
                || ((VARIABLE_DEF_TYPE_POINTER == variable_def_type_get(def))
                      && (VARIABLE_DEF_TYPE_ARRAY 
                        == variable_def_type_get(vdef))
                      && variable_def_is_same(
                        variable_def_member_def_get(
                          variable_def_member_get(def)
                          ),
                        variable_def_member_def_get(
                          variable_def_member_get(vdef)
                          )
                        )
                      );
              /*
               * if vdef is a one element array, and def is a single element
               * of the same type, allow this
               */
              ok = ok
                || ((VARIABLE_DEF_TYPE_ARRAY == variable_def_type_get(vdef))
                  && variable_def_type_is_number(
                    variable_def_type_get(def))
                  && variable_def_type_is_number(
                       variable_def_type_get(
                         variable_def_member_def_get(
                           variable_def_member_get(vdef))))
                  && (1 == variable_def_member_ct_get(
                    variable_def_member_get(vdef))));
              if (!val || !ok) {
                if (val) {
                  pfile_log(pf, PFILE_LOG_ERR, "type mismatch");
                  value_release(val);
                  val = VALUE_NONE;
                }
              }
            }
            if (parms && (ii < param_ct)) {
              parms[ii] = val;
              if (val && need_ct) {
                char *ct_name;

                ptr     = value_name_get(val);
                ct_name = MALLOC(8 + strlen(ptr));
                if (!ct_name) {
                  pfile_log_syserr(pf, ENOMEM);
                } else {
                  value_t ct_val;

                  sprintf(ct_name, "_%s_count", ptr);
                  ct_val = pfile_value_find(pf, PFILE_LOG_NONE, ct_name);
                  if (!ct_val) {
                    ct_val = pfile_constant_get(pf, value_ct_get(val),
                      VARIABLE_DEF_TYPE_NONE);
                  }
                  parms[ii - 1] = ct_val;
                  FREE(ct_name);
                }
              }
            } else {
              value_release(val);
            }
          }
        }
      }
      if (need_close 
          && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, param_close)) {
        pf_token_get(pf, PF_TOKEN_NEXT);
      }
    }
  }
  if (ii != param_ct) {
    pfile_log(pf, PFILE_LOG_ERR, 
        "Too %s parameters (%lu expected, %lu found)",
        (ii < param_ct) ? "few" : "many",
        (ulong) (param_ct - 1), (ulong) (ii - 1));
  }
  val = parms[0];
  value_lock(val);
  if (call_val) {
    pfile_cmd_branch_add(pf, 
        (flags & JAL_PARSE_CALL_FLAG_START)
          ? CMD_BRANCHTYPE_TASK_START
          : CMD_BRANCHTYPE_CALL,
        CMD_BRANCHCOND_NONE, LABEL_NONE,
        VALUE_NONE, call_val, parms);
  }
  /* look for any PUT params, and do the necessary calls here... */
  if (put_parms) {
    for (ii = 0; ii < param_ct; ii++) {
      if (put_parms[ii]) {
        /* need to call put_params[ii] with params[ii] as the parameter */
        value_t        *parms2;

        parms2 = CALLOC(2, sizeof(*parms2));
        parms2[0] = VALUE_NONE; /* no return value */
        value_lock(parms[ii]);
        parms2[1] = parms[ii];
        pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_CALL,
            CMD_BRANCHCOND_NONE, LABEL_NONE, VALUE_NONE,
            put_parms[ii], parms2);
        value_release(put_parms[ii]);
      }
    }
    FREE(put_parms);
  }

  return val;
}

void jal_parse_task(pfile_t *pf, const pfile_pos_t *statement_start)
{
  jal_parse_procedure_common(pf, JAL_PARSE_TASK, statement_start);
}

void jal_parse_start(pfile_t *pf, const pfile_pos_t *statement_start)
{
  pfile_proc_t *proc;

  UNUSED(statement_start);

  proc = pfile_proc_active_get(pf);
  if (pfile_proc_parent_get(proc)) {
    pfile_log(pf, PFILE_LOG_ERR, "START can only be used in the main program");
  } else {
    value_t   jvals[JAL_VAL_TYPE_CT];
    boolean_t jval_found;

    jval_found = jal_value_find(pf, pf_token_get(pf, PF_TOKEN_CURRENT), jvals);
    proc = value_proc_get(jvals[JAL_VAL_TYPE_BASE]);
    if (!jval_found
        || !proc 
        || !pfile_proc_flag_test(proc, PFILE_PROC_FLAG_TASK)) {
      pfile_log(pf, PFILE_LOG_ERR, "task expected");
    } else {
      pf_token_get(pf, PF_TOKEN_NEXT);
      value_release(
          jal_parse_call(pf, jvals[JAL_VAL_TYPE_BASE], 
            JAL_PARSE_CALL_FLAG_START));
      jal_value_release(jvals);
    }
  }
}

void jal_parse_suspend(pfile_t *pf, const pfile_pos_t *statement_start)
{
  pfile_proc_t *proc;

  UNUSED(statement_start);

  proc = pfile_proc_active_get(pf);
  if ((proc != pfile_proc_root_get(pf))
    && !pfile_proc_flag_test(proc, PFILE_PROC_FLAG_TASK)) {
    pfile_log(pf, PFILE_LOG_ERR, "SUSPEND can only be used in a TASK");
  } else {
    pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_TASK_SUSPEND,
      CMD_BRANCHCOND_NONE, LABEL_NONE, VALUE_NONE, VALUE_NONE, 0);
  }
}

