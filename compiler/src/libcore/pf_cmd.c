/************************************************************
 **
 ** pf_cmd.c : p-code cmd list functions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <assert.h>
#include <string.h>

#include "../libutils/mem.h"
#include "cmd_op.h"
#include "cmd_usec.h"
#include "cmd_log.h"
#include "pfiled.h"
#include "pf_proc.h"
#include "pf_expr.h"
#include "pf_cmd.h"

/*
 * NAME
 *   pfile_cmd_add
 *
 * DESCRIPTION
 *   add a command to the command list
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 */
void pfile_cmd_add(pfile_t *pf, cmd_t cmd)
{
  /*cmd_dump(cmd, stdout);*/
#if 1
  if (pfile_codegen_disable_get(pf)) {
    cmd_free(cmd);
  } else {
#else
    {
#endif
    pfile_block_t *blk;
    if (!cmd_source_get(cmd)) {
      pfile_pos_t    pos;

      if (pf->cmd_cursor) {
        pos.line = cmd_line_get(pf->cmd_cursor);
        pos.src  = cmd_source_get(pf->cmd_cursor);
      } else {
        pos = pf->statement_start;
      }
      if (pos.src) {
        cmd_line_set(cmd, pos.line);
        cmd_source_set(cmd, pos.src);
      }
    }
    if (pf->cmd_cursor) {
      /* this cmd goes *after* pf->cmd_cursor */
      cmd_link_set(cmd, cmd_link_get(pf->cmd_cursor));
      cmd_link_set(pf->cmd_cursor, cmd);
      pf->cmd_cursor = cmd;
    } else {
      cmd_link_set(pf->cmd_tail, cmd);
      pf->cmd_tail = cmd;
    }
    if (!pf->cmd_head) {
      pf->cmd_head = cmd;
    }
    blk = pfile_proc_block_active_get(pfile_proc_active_get(pf));
    if (blk && (CMD_NONE == pfile_block_cmd_get(blk))) {
      assert(CMD_TYPE_BLOCK_START == cmd_type_get(cmd));
      pfile_block_cmd_set(blk, cmd);
    }
    if (pfile_flag_test(pf, PFILE_FLAG_CMD_SPEED)) {
      cmd_flag_set(cmd, CMD_FLAG_SPEED);
    }
  }
}

void pfile_cmd_special_add(pfile_t *pf, cmd_type_t type, pfile_proc_t *proc)
{
  cmd_t cmd;

  cmd = cmd_alloc(type, 0);
  if (cmd) {
    if (proc) {
      cmd_proc_set(cmd, proc);
    }
    pfile_cmd_add(pf, cmd);
  }
}

void pfile_cmd_usec_delay_add(pfile_t *pf, variable_const_t n)
{
  cmd_t cmd;

  cmd = cmd_usec_delay_alloc(n);
  pfile_cmd_add(pf, cmd);
}

typedef struct {
  label_map_t    lbl_map;
  variable_map_t var_map;
} map_info_t;

static variable_t variable_map_search(const variable_map_t *map,
  variable_t var)
{
  size_t     ii;
  variable_t res;

  res = VARIABLE_NONE;
  for (ii = 0;
       (ii < map->used) && (map->map[ii].old != var);
       ii++)
    ;
  if (ii < map->used) {
    res = map->map[ii].new;
  }
  return res;
}

/* hit this on a block-enter */
static cmd_t pfile_cmd_block_dup(pfile_t *pf, pfile_proc_t *proc,
    value_t *proc_params, pfile_block_t *blk, map_info_t *map, cmd_t cmd,
    const variable_map_t *replacement_var_map)
{
  pfile_block_t *child;
  variable_t     var;

  child = PFILE_BLOCK_NONE;
  cmd = cmd_link_get(cmd);
  (void) pfile_block_enter(pf);
  /* add all variables defined in blk to the active block;
   * also add them to the associated maps
   */
  for (var = pfile_block_variable_list_head(blk);
       var;
       var = variable_link_get(var)) {
    if (!variable_is_const(var)
      && (VARIABLE_NONE == variable_map_search(replacement_var_map, var))) {
      /* if this variable is in replacement_var_map, don't touch it.
       * if this variable's master is in replacement_var_map
       *   use that one
       */   
      variable_t new;
      variable_t master;
      size_t     ii;

      map->var_map.map[map->var_map.used].old = var;
      /* here's a fun one -- var.master might *also* be in this block
       * so I need to remap it also; if there's a chain each entry should
       * fix itself up as necessary */
      master = variable_master_get(var);
      if (VARIABLE_NONE != master) {
        variable_t tvar;

        tvar = variable_map_search(replacement_var_map, master);
        if (VARIABLE_NONE == tvar) {
          tvar = variable_map_search(&map->var_map, master);
        }
        if (VARIABLE_NONE != tvar) {
          master = tvar;
        }
      }
      (void) pfile_variable_alloc(pf, PFILE_VARIABLE_ALLOC_LOCAL,
          variable_name_get(var), variable_def_get(var),
          master, &new);
      map->var_map.map[map->var_map.used].new = new;
      variable_flags_set_all(new, variable_flags_get_all(var));
      variable_bit_offset_set(new, variable_bit_offset_get(var));
      for (ii = 0; ii < VARIABLE_MIRROR_CT; ii++) {
        variable_base_set(new, variable_base_real_get(var, ii), ii);
      }

      map->var_map.used++;
    }
  }

  if (proc_params) {
    /* this is the entry into the procedure. go ahead & make the
     * necessary assignments */
    size_t ii;

    for (ii = 0; ii < pfile_proc_param_ct_get(proc); ii++) {
      if (proc_params[ii]) {
        value_t val;

        val = pfile_proc_param_get(proc, ii);
        if (value_dflag_test(val, VARIABLE_DEF_FLAG_IN)
            && proc_params[ii]) {
          pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &val, proc_params[ii], 
              VALUE_NONE);
        }
      }
    }
  }

  while (CMD_TYPE_BLOCK_END != cmd_type_get(cmd)) {
    if (CMD_TYPE_BLOCK_START == cmd_type_get(cmd)) {
      child = (child) ? pfile_block_sibbling_get(child)
        : pfile_block_child_get(blk);
      cmd = pfile_cmd_block_dup(pf, PFILE_PROC_NONE, 0, child, map, cmd,
        replacement_var_map);
    } else {
      cmd_t dup;

      assert(CMD_TYPE_BLOCK_END != cmd_type_get(cmd));
      dup = cmd_dup(cmd);
      if (cmd_label_get(cmd)) {
        /* when a label cmd is dup'd, its label is lost (because
         * the label points directly to the associated cmd). So,
         * we need to do a bit of extra processing here
         */
        if (map->lbl_map.used == map->lbl_map.alloc) {
          size_t n;
          void  *tmp;

          n = (map->lbl_map.alloc) ? 2 * map->lbl_map.alloc : 16;
          tmp = REALLOC(map->lbl_map.map, sizeof(*map->lbl_map.map) * n);
          if (tmp) {
            map->lbl_map.map = tmp;
            map->lbl_map.alloc = n;
          }
        }
        if (map->lbl_map.used < map->lbl_map.alloc) {
          map->lbl_map.map[map->lbl_map.used].old = cmd_label_get(cmd);
          map->lbl_map.map[map->lbl_map.used].new = pfile_label_alloc(pf, 0);
          map->lbl_map.used++;
        }
        /* remap the label straight away */
        cmd_label_set(dup, map->lbl_map.map[map->lbl_map.used - 1].new);
      }

#if 0
      cmd_dump(cmd, stdout);
      printf("-->");
      cmd_dump(dup, stdout);
      printf("\n");
#endif
      if (dup) {
        pfile_cmd_add(pf, dup);
        /*cmd_dump(dup, stdout);*/
        if (value_proc_get(cmd_brproc_get(dup))) {
          (void) pfile_proc_call_add(pfile_proc_active_get(pf),
              value_proc_get(cmd_brproc_get(dup)));
        }
      }
      cmd = cmd_link_get(cmd);
    }
  }
  if (proc_params) {
    /* this is the exit from the procedure, so make the necessary
     * assignments */
    size_t ii;

    for (ii = 0; ii < pfile_proc_param_ct_get(proc); ii++) {
      if (proc_params[ii]) {
        value_t val;

        val = pfile_proc_param_get(proc, ii);
        if (value_dflag_test(val, VARIABLE_DEF_FLAG_OUT)
            && !value_is_const(proc_params[ii])) {
          pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &proc_params[ii], val, 
              VALUE_NONE);
        }
        value_release(proc_params[ii]);
      }
    }
  }
  (void) pfile_block_leave(pf);
  return cmd_link_get(cmd);
}

/*
 * here there are a few possibilities:
 *   * proc_params[0] is the return value. It has no variable assigned to it
 *     so it's a simple value search & replace.
 *   * proc_params[1..n] can be replaced if the following conditions are met:
 *     1. the variable definitions match exactly
 *     2. the passed-in value doesn't have a baseofs
 *     3. if an IN only parameter, it can never be assigned a value
 *     4. if an OUT only parameter, it can never be read
 *     5. if the matching param[] is volatile, then it can only be read
 *        and/or written once
 *     6. the parameter *cannot* have any other variable located `at' it
 *     and, just to be obnoxious, the variables themselves must be compared
 *     and replaced, not the values
 *
 *   So, this creates two maps -- the first one for parameter zero is
 *   a value map, the second one for the other parameters
 */
static void pfile_cmd_proc_inline_param_replacements_get(
  pfile_t *pf, pfile_proc_t *proc, value_t *params, value_map_t *value_map, 
  variable_map_t *variable_map, cmd_t cmd_start)
{
  size_t ii;

  for (ii = 0; ii < pfile_proc_param_ct_get(proc); ii++) {
    value_t    pval;
    variable_t pvar;
    boolean_t  replaceable;
    value_t    rparam; /* replaceable parameter */

    pval = pfile_proc_param_get(proc, ii);
    pvar = value_variable_get(pval);
    rparam = params[ii];
    /* replaceable if
     * (1) the definitions are the same
     * (2) the parameter doesn't have a baseofs set
     * (3) pval is a pointer, but param is not and their
     *     definitions are otherwise the same
     */
    /* nb : if pvar has a master set, don't allow the replacement
     *      the only time this *should* fail is if pvar is part of
     *      another parameter, which would be odd to say the least!
     *
     *      Don't allow replacement if the parameters is an array
     *      element. The replacement routines are not setup to
     *      allow this.
     */
    if (value_baseofs_get(rparam)) {
      /* this *might* be a temporary variable, in  which case it is
       * replaceable. Note this is duplicated below. I don't at the
       * moment see away around that. */
      replaceable = (!pvar
        || variable_def_is_same(value_def_get(rparam),
            value_def_get(pval)))
        && (VARIABLE_BASE_UNKNOWN == variable_base_get(pvar, 0));
      if (replaceable && (VARIABLE_NONE != pvar)) {
        /* an array element is being used in replacement. There's no
         * easy way to do this, so I'll simply set the element to a
         * new variable, and use that
         */
        char            pbuf[16];
        static unsigned pn;
        value_t         tmp;
        cmd_t           cmd;

        sprintf(pbuf, "_rparam%u", pn);
        pn++;
        (void) pfile_value_alloc(pf, PFILE_VARIABLE_ALLOC_LOCAL,
          pbuf, value_def_get(pval), &tmp);
        cmd = cmd_op_alloc(OPERATOR_ASSIGN, tmp, rparam, VALUE_NONE);
        pfile_cmd_add(pf, cmd);
        rparam = tmp;
        value_release(tmp);
      }
    } else if (value_is_pointer(pval) && value_is_function(rparam)) {
      replaceable = variable_def_is_same(value_def_get(rparam),
        variable_def_member_def_get(
          variable_def_member_get(
            variable_def_get(pvar))));
    } else if (value_is_pointer(pval) && value_is_array(rparam)) {
      replaceable = variable_def_is_same(
        variable_def_member_def_get(
          variable_def_member_get(
            variable_def_get(pvar))),
        variable_def_member_def_get(
          variable_def_member_get(
            variable_def_get(
              value_variable_get(
                rparam)))));
    } else {
      replaceable = (!pvar
        || variable_def_is_same(value_def_get(rparam),
            value_def_get(pval)))
        && (VARIABLE_BASE_UNKNOWN == variable_base_get(pvar, 0)
        && !variable_flag_test(pvar, VARIABLE_FLAG_UNREPLACEABLE));
    }

    if (replaceable) {
      /* count the number of times a variable is read or written */
      unsigned  read_ct;
      unsigned  write_ct;
      boolean_t baseofs_set;
      cmd_t     cmd;

      read_ct     = 0;
      write_ct    = 0;
      baseofs_set = BOOLEAN_FALSE;
      for (cmd = cmd_start; 
           replaceable && (CMD_TYPE_PROC_LEAVE != cmd_type_get(cmd)); 
           cmd = cmd_link_get(cmd)) {
        flag_t flags;

        flags = (pvar)
          ? cmd_variable_accessed_get(cmd, pvar)
          : cmd_value_accessed_get(cmd, pval);
        if (flags & CMD_VARIABLE_ACCESS_FLAG_READ) {
          read_ct++;
        }
        if (flags & CMD_VARIABLE_ACCESS_FLAG_WRITTEN) {
          write_ct++;
        }
        baseofs_set = baseofs_set && (value_baseofs_get(pval) != VALUE_NONE);
      }
#if 0
      printf("%s read(%u) written(%u)\n",
        variable_name_get(pvar), read_ct, write_ct);
#endif
      /* determine if this variable is replaceable */
      if (read_ct && !value_dflag_test(pval, VARIABLE_DEF_FLAG_IN)) {
        /* cannot read from a non-IN parameter */
        replaceable= BOOLEAN_FALSE;
      } else if (write_ct 
        && !value_dflag_test(pval, VARIABLE_DEF_FLAG_OUT)) {
        /* cannot write to a non-OUT parameter */
        replaceable = BOOLEAN_FALSE;
      } else if (value_is_volatile(rparam)
        && ((read_ct > 1) || (write_ct > 1))) {
        /* if the passed-in value is volatile, it can only be read
         * or written once
         */
        replaceable = BOOLEAN_FALSE;
      }
#if 1
      if (replaceable) {
        if (pvar) {
          /* replace the variable */
          variable_map->map[variable_map->used].old = pvar;
          variable_map->map[variable_map->used].new =
            value_variable_get(rparam);
          variable_map->used++;
        } else {
          /* replace the value -- this should only happen *once*
           * (for the return value)
           */
          value_map->map[value_map->used].old = pval;
          value_map->map[value_map->used].new = rparam;
          value_map->used++;
        }
        if (value_name_get(rparam)) {
          pfile_log(pf, PFILE_LOG_DEBUG, "%s is replaceable (with %s)!",
            value_name_get(pval), value_name_get(rparam));
        } else if (pval) {
          pfile_log(pf, PFILE_LOG_DEBUG, "%s is replaceable (with %lu)!",
            value_name_get(pval), value_const_get(rparam));
        }
        params[ii] = VALUE_NONE;
      }
#endif
    }
  }
}

static void pfile_cmd_branch_add_inline(pfile_t *pf,
    pfile_proc_t *proc, value_t *proc_params)
{
  /* count the number of variables and labels defined by this
   * procedure (to create a mapping)
   */
  size_t         var_ct;
  size_t         ii;
  pfile_block_t *blk;
  cmd_t          cmd;
  cmd_t          cmd_start;
  map_info_t     map;
  value_map_t    replacement_val_map;
  variable_map_t replacement_var_map;
  value_t       *dup_proc_params;
  size_t         param_ct;

  param_ct = pfile_proc_param_ct_get(proc);
  /* i need to dup these so I can release them later; the
   * param replacements function zeros out the original
   * params array when replacement occurs
   */
  dup_proc_params = MALLOC(sizeof(*dup_proc_params) * param_ct);
  if (!dup_proc_params) {
    pfile_log(pf, PFILE_LOG_ERR, "out of memory");
  } else {
    for (ii = 0; ii < param_ct; ii++) {
      dup_proc_params[ii] = proc_params[ii];
    }
  }

  replacement_val_map.alloc = pfile_proc_param_ct_get(proc);
  replacement_val_map.used  = 0;
  replacement_val_map.map   = MALLOC(sizeof(*replacement_val_map.map) 
      * replacement_val_map.alloc);

  replacement_var_map.alloc = pfile_proc_param_ct_get(proc);
  replacement_var_map.used  = 0;
  replacement_var_map.map   = MALLOC(sizeof(*replacement_var_map.map) 
      * replacement_var_map.alloc);

  for (blk = pfile_proc_block_root_get(proc),
         var_ct = 0;
       blk;
       blk = pfile_block_next(blk)) {
    variable_t var;

    for (var = pfile_block_variable_list_head(blk);
         var;
         var = variable_link_get(var)) {
      if (!variable_is_const(var)) {
        var_ct++;
      }
    }
  }

  map.lbl_map.alloc = 0;
  map.lbl_map.used  = 0;
  map.lbl_map.map   = 0;

  map.var_map.alloc = var_ct;
  map.var_map.used  = 0;
  map.var_map.map   = (var_ct)
    ? CALLOC(sizeof(*map.var_map.map), var_ct)
    : 0;

  cmd = label_cmd_get(pfile_proc_label_get(proc));
  assert(CMD_TYPE_PROC_ENTER == cmd_type_get(cmd));
  cmd = cmd_link_get(cmd);
  assert(CMD_TYPE_BLOCK_START == cmd_type_get(cmd));
  cmd_start = pfile_cmdlist_tail_get(pf);

  pfile_cmd_proc_inline_param_replacements_get(pf, proc, proc_params,
    &replacement_val_map, &replacement_var_map, cmd);

  /* printf("--- block dup ---\n"); */
  cmd = pfile_cmd_block_dup(pf, proc, proc_params,
      pfile_proc_block_root_get(proc), &map, cmd,
      &replacement_var_map);
  /* printf("-----------------\n"); */
  assert(CMD_TYPE_PROC_LEAVE == cmd_type_get(cmd));
  cmd_start = cmd_link_get(cmd_start);
  /* printf("\n==== (cmd list) ====\n"); */
  while (cmd_start) {
    value_t  dst;
    value_t *rparams;
    value_t  proc_pre;
    value_t  proc_post;
    
#if 0
    printf("pre-->(0x%0x)", (unsigned) cmd_start);
    cmd_dump(cmd_start, stdout);
#endif
    rparams = cmd_brproc_params_get(cmd_start);
    if (rparams) {
      dst = rparams[0];
    } else {
      dst = cmd_opdst_get(cmd_start);
    }
    proc_pre = cmd_brproc_get(cmd_start);
    cmd_value_remap(cmd_start, &replacement_val_map);
    cmd_variable_remap(cmd_start, &replacement_var_map);
    cmd_label_remap(cmd_start, &map.lbl_map);
    cmd_variable_remap(cmd_start, &map.var_map);
    proc_post = cmd_brproc_get(cmd_start);
    /* if this command was an indirect procedure call, it might
     * have changed to a direct procedure call. In that case
     * it must be added to proc->calls */
    if (value_is_indirect(proc_pre) && !value_is_indirect(proc_post)) {
      pfile_proc_t *dproc;

      dproc = variable_proc_get(value_variable_get(proc_post));
      /* I'd expect this to always be true */
      if (dproc) {
        pfile_proc_flag_set(dproc, PFILE_PROC_FLAG_DIRECT);
        (void) pfile_proc_call_add(pfile_proc_active_get(pf), dproc);
      }
    }

    /* temporary variables are a special case because the *value* is
     * important (the variable is really just a placeholder), so if
     * this is an assignment to a temporary, we'll need to do some
     * value replacement
     */
    if (dst) {
      /* create a value map */
      value_map_pair_t value_map_pair;
      value_map_t      value_map;
      cmd_t            cmd_ptr;

      value_map_pair.old = dst;
      if (CMD_TYPE_OPERATOR == cmd_type_get(cmd_start)) {
        value_map_pair.new = cmd_opdst_get(cmd_start);
      } else {
        assert(CMD_TYPE_BRANCH == cmd_type_get(cmd_start));
        rparams = cmd_brproc_params_get(cmd_start);
        value_map_pair.new = rparams[0];
      }
      value_map.used  = 1;
      value_map.alloc = 0;
      value_map.map   = &value_map_pair;

      for (cmd_ptr = cmd_link_get(cmd_start);
           CMD_TYPE_STATEMENT_END != cmd_type_get(cmd_ptr);
           cmd_ptr = cmd_link_get(cmd_ptr)) {
        cmd_value_remap(cmd_ptr, &value_map);
      }
    }
#if 0
    printf("post-->");
    cmd_dump(cmd_start, stdout);
#endif
    cmd_start = cmd_link_get(cmd_start);
  }
  /*printf("====================\n");*/
  for (ii = 0; ii < map.var_map.used; ii++) {
    variable_release(map.var_map.map[ii].new);
  }
  FREE(map.var_map.map);
  for (ii = 0; ii < map.lbl_map.used; ii++) {
    label_release(map.lbl_map.map[ii].new);
  }
  FREE(map.lbl_map.map);
  FREE(replacement_val_map.map);
  FREE(replacement_var_map.map);
  for (ii = 0; ii < param_ct; ii++) {
    if (!proc_params[ii]) {
      value_release(dup_proc_params[ii]);
    }
  }
  FREE(dup_proc_params);
  FREE(proc_params);
}

/*
 * NAME
 *   pfile_cmd_branch_add
 *
 * DESCRIPTION
 *   add a branching command
 *
 * PARAMETERS
 *   pf : pfile
 *   label : line label
 *   type  : branching type
 *   cond  : branching condition
 *   dst   : destination label
 *   var   : condition variable
 *
 * RETURN
 *
 * NOTES
 */
void pfile_cmd_branch_add(pfile_t *pf, 
  cmd_branchtype_t type, cmd_branchcond_t cond, label_t dst,
  value_t var, value_t proc, value_t *proc_params)
{
  cmd_t ptr;

  if ((CMD_BRANCHTYPE_CALL == type)
    && (CMD_BRANCHCOND_NONE == cond)
    &&  pfile_proc_flag_test(value_proc_get(proc), PFILE_PROC_FLAG_INLINE)) {
    pfile_cmd_branch_add_inline(pf, value_proc_get(proc), proc_params);
  } else {
    if ((CMD_BRANCHCOND_NONE != cond) 
      && value_is_const(var)) {
      /* this is an absolute branch disguised as a conditonal one */
      variable_const_t n;

      n = value_const_get(var);
      if (((0 == n) && (CMD_BRANCHCOND_FALSE == cond)) 
          || ((0 != n) && (CMD_BRANCHCOND_TRUE == cond))) {
        cond = CMD_BRANCHCOND_NONE;
      } else {
        type = CMD_BRANCHTYPE_NONE;
      }
    }
    if (CMD_BRANCHTYPE_NONE == type) {
      /* do nothing */
    } else {
      if (proc) {
        if (VARIABLE_DEF_TYPE_FUNCTION == value_type_get(proc)) {
          /* add this to the called list */
          pfile_proc_t *pproc;

          pproc = value_proc_get(proc);
          if (pproc) {
            pfile_proc_flag_set(value_proc_get(proc), PFILE_PROC_FLAG_DIRECT);
            (void) pfile_proc_call_add(pfile_proc_active_get(pf), 
              value_proc_get(proc));
          }
        }
      }
      ptr = cmd_branch_alloc(type, cond, dst, var, proc, proc_params);
      if (!ptr) {
        pfile_log_syserr(pf, RESULT_MEMORY);
      } else {
        pfile_cmd_add(pf, ptr);
      }
    }
  }
}

/*
 * NAME
 *   pfile_cmd_label_add
 *
 * DESCRIPTION
 *   add a label only
 *
 * PARAMETERS
 *   pf    :
 *   label :
 *
 * RETURN
 *   none
 *
 * NOTES
 *   this doesn't really do anything other than set the
 *   ``next command gets this label''
 */
void pfile_cmd_label_add(pfile_t *pf, label_t label)
{
  cmd_t cmd;

  cmd = cmd_label_alloc(label);
  pfile_cmd_add(pf, cmd);
}

void pfile_cmd_log_add(pfile_t *pf, pfile_log_t plog, size_t sz,
  const char *str)
{
  cmd_t cmd;

  cmd = cmd_log_alloc(plog, sz, str);
  pfile_cmd_add(pf, cmd);
}


/*
 * NAME
 *   pfile_cmd_remove_unreachable
 *
 * DESCRIPTION
 *   remove unreachable commands
 *
 * PARAMETERS
 *   pf : pfile
 *
 * RETURN
 *   TRUE if anything was removed, FALSE if not
 *
 * NOTES
 *   the commands are removed because doing so reduces the assign/use
 *   counts. a later pass is made to remove any assignments to
 *   variables that are not used, and to change any uses of unassigned
 *   variables to 0
 */
boolean_t pfile_cmd_remove_unreachable(pfile_t *pf)
{
  cmd_t cmd;
  cmd_t cmd_pv;
  unsigned ct;
  boolean_t was_last_eos;

  cmd = pf->cmd_head;
  cmd_pv = 0;
  was_last_eos = BOOLEAN_TRUE;

  /* first free unused commands */
  ct = 0;
  while (cmd) {
    label_t lbl;

    lbl = cmd_label_get(cmd);
    if (!cmd_is_reachable(cmd)
      || (lbl && !label_usage_get(lbl))
      || (was_last_eos && (CMD_TYPE_STATEMENT_END == cmd_type_get(cmd)))) {
      if (cmd_pv) {
        cmd_link_set(cmd_pv, cmd_link_get(cmd));
      } else {
        pf->cmd_head = cmd_link_get(cmd);
        if (!pf->cmd_head) {
          pf->cmd_tail = 0;
        }
      }
      cmd_free(cmd);
      cmd = cmd_pv;
      ct++;
      was_last_eos = BOOLEAN_TRUE;
    } else if (CMD_TYPE_LABEL != cmd_type_get(cmd)) {
      was_last_eos = CMD_TYPE_STATEMENT_END == cmd_type_get(cmd);
    }
    cmd_pv = cmd;
    cmd = cmd_link_get(cmd);
  }
  pfile_log(pf, PFILE_LOG_DEBUG, "%u unreachable commands freed", ct);
  return ct != 0;
}

/*
 * NAME
 *   pfile_cmd_remove_assignments
 *
 * DESCRIPTION
 *   remove all assignments to variables that are never used
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   none
 *
 * NOTES
 *   this is iterative -- at each iteration it removes all variables that are
 *   assigned but never used. it repeats until no more statements have been
 *   removed
 *   nb : a special case is made for assignment to a value with no
 *        corresponding variable. this should *only* happen when setting
 *        the return value for a function!
 */
boolean_t pfile_cmd_remove_assignments(pfile_t *pf)
{
  boolean_t changed;
  unsigned  ct;
  unsigned  pass;

  ct   = 0;
  pass = 0;
  do {
    cmd_t cmd;
    cmd_t cmd_pv;

    changed = BOOLEAN_FALSE;
    pass++;

    cmd = pf->cmd_head;
    cmd_pv = 0;

    /* first free unused commands */
    while (cmd) {
      if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
        value_t    dst;

        dst   = cmd_opdst_get(cmd);
        /* if there is no variable this is either a temporary or a return
         * in either case we cannot remove it! */
        if (dst
          && value_variable_get(dst)
          && !value_is_used(dst)) {
          /* this is an assignment to an unused variable, remove it! */
          if (cmd_pv) {
            cmd_link_set(cmd_pv, cmd_link_get(cmd));
          } else {
            pf->cmd_head = cmd_link_get(cmd);
            if (!pf->cmd_head) {
              pf->cmd_tail = 0;
            }
          }
          cmd_free(cmd);
          cmd = cmd_pv;
          ct++;
          changed = BOOLEAN_TRUE;
        }
      }
      cmd_pv = cmd;
      cmd = cmd_link_get(cmd);
    }
  } while (changed);
  pfile_log(pf, PFILE_LOG_DEBUG, "%u assignment commands freed in %u passes", 
    ct, pass);
  return ct != 0;
}

/* remove all sequences of {block} [{eos}] {end-of-block}
 * note: this must be repeated to catch nested blocks */

boolean_t pfile_cmd_remove_empty_blocks(pfile_t *pf)
{
  boolean_t changed;
  unsigned  ct;
  unsigned  pass;

  ct   = 0;
  pass = 0;
  do {
    cmd_t cmd;
    cmd_t cmd_pv;

    changed = BOOLEAN_FALSE;
    pass++;

    cmd = pf->cmd_head;
    cmd_pv = 0;

    /* first free unused commands */
    while (cmd) {
      if (CMD_TYPE_BLOCK_START == cmd_type_get(cmd)) {
        size_t remove_ct;

        remove_ct = 0;
        if ((CMD_TYPE_STATEMENT_END == cmd_type_get(cmd_link_get(cmd)))
          && (CMD_TYPE_BLOCK_END == cmd_type_get(cmd_link_get(
                cmd_link_get(cmd))))) {
          remove_ct = 3;
        } else if (CMD_TYPE_BLOCK_END == cmd_type_get(cmd_link_get(cmd))) {
          /* {block} {block end} */
          remove_ct = 2;
        }
        if (remove_ct) {
          cmd_t cmd_ptr;

          ct++;
          changed = BOOLEAN_TRUE;
          cmd_ptr = CMD_NONE;
          while (remove_ct--) {
            cmd_ptr = cmd_link_get(cmd);
            cmd_free(cmd);
            cmd = cmd_ptr;
          }
          cmd_link_set(cmd_pv, cmd_ptr);
          cmd = cmd_pv;
        }
      }
      cmd_pv = cmd;
      cmd = cmd_link_get(cmd);
    }
  } while (changed);
  pfile_log(pf, PFILE_LOG_DEBUG, "%u empty blocks freed in %u passes", ct, 
      pass);
  return ct != 0;
}


void pfile_cmdlist_check(cmd_t cmd)
{
  UNUSED(cmd);
#if 0
  while (cmd) {
    pfile_proc_t *proc;

    assert(1368 != cmd_brval_get(cmd));
    assert(1368 != cmd_opdst_get(cmd));
    assert(1368 != cmd_opval1_get(cmd));
    assert(1368 != cmd_opval2_get(cmd));
    proc = cmd_brproc_get(cmd);
    if (proc) {
      unsigned ii;

      for (ii = 0; ii < pfile_proc_param_ct_get(proc); ii++) {
        assert(1368 != cmd_brproc_params_get(cmd)[ii]);
      }
    }
    cmd = cmd_link_get(cmd);
  }
#endif
}

