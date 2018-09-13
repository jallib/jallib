/**********************************************************
 **
 ** cmd_br.c : the CMD_TYPE_BRANCH functions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <assert.h>
#include "../libutils/mem.h"
#include "cmdd.h"
#include "cmd_brch.h"

static void cmd_branch_dump(cmd_t cmd, FILE *dst)
{
  const char *tstr;
  const char *cstr;

  tstr = "{unknown}";
  switch (cmd_brtype_get(cmd)) {
    case CMD_BRANCHTYPE_NONE:         tstr = "{none}";       break;
    case CMD_BRANCHTYPE_GOTO:         tstr = "goto";         break;
    case CMD_BRANCHTYPE_CALL:         tstr = "call";         break;
    case CMD_BRANCHTYPE_RETURN:       tstr = "return";       break;
    case CMD_BRANCHTYPE_TASK_START:   tstr = "task_start";   break;
    case CMD_BRANCHTYPE_TASK_SUSPEND: tstr = "task_suspend"; break;
    case CMD_BRANCHTYPE_TASK_END:     tstr = "task_end";     break;
  }
  cstr = "{unknown}";
  switch (cmd_brcond_get(cmd)) {
    case CMD_BRANCHCOND_NONE:   cstr = 0 ;      break;
    case CMD_BRANCHCOND_TRUE:   cstr = "true";  break;
    case CMD_BRANCHCOND_FALSE:  cstr = "false"; break;
  }
  fprintf(dst, "%s ", tstr);
  if (cstr) {
    fprintf(dst, "%s ? ", cstr);
    value_dump(cmd_brval_get(cmd), dst);
  }
  if (cmd_brdst_get(cmd)) {
    if (cstr) {
      fprintf(dst, "-->");
    }
    fprintf(dst, "%s", label_name_get(cmd_brdst_get(cmd)));
  } else if (cmd_brproc_get(cmd)) {
    variable_def_t        vdef;
    variable_def_member_t mbr;
    size_t                ii;
    value_t              *params;
    value_t               proc;

    proc   = cmd_brproc_get(cmd);
    params = cmd_brproc_params_get(cmd);

    if (cstr) {
      fprintf(dst, "-->");
    }
    fprintf(dst, "%s%s(", value_is_indirect(proc)
      ? "&" : "", value_name_get(proc));
    vdef = value_def_get(proc);
    for (mbr = variable_def_member_get(vdef), ii = 0;
         mbr;
         mbr = variable_def_member_link_get(mbr), ii++) {
      if (ii) {
        fputc(',', dst);
      }
      value_dump(params[ii], dst);
    }
    fprintf(dst, ")");
  }
}

static void cmd_branch_free(cmd_t cmd)
{
  struct cmd_ *ptr;

  cmd_brval_set(cmd, 0);
  cmd_brdst_set(cmd, 0);

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    if (ptr->u.br.proc) {
      value_t              *params;
      variable_def_t        def;
      variable_def_member_t mbr;
      size_t                ii;
      pfile_proc_t         *proc_ptr;

      value_use_ct_bump(ptr->u.br.proc, CTR_BUMP_DECR);
      def    = value_def_get(ptr->u.br.proc);
      params = ptr->u.br.proc_params;
      for (ii = 0, mbr = variable_def_member_get(def);
           mbr;
           ii++, mbr = variable_def_member_link_get(mbr)) {
        variable_def_t mdef;

        mdef = variable_def_member_def_get(mbr);
        if (variable_def_flag_test(mdef, VARIABLE_DEF_FLAG_IN)) {
          value_use_ct_bump(params[ii], CTR_BUMP_DECR);
        }
        /* if ii == 0 this is the return value, which is an implied OUT */
        if (!ii || variable_def_flag_test(mdef, VARIABLE_DEF_FLAG_OUT)) {
          value_assign_ct_bump(params[ii], CTR_BUMP_DECR);
        }
        value_release(params[ii]);
      }
      FREE(ptr->u.br.proc_params);
      proc_ptr = value_proc_get(ptr->u.br.proc);
      if (proc_ptr) {
        label_usage_bump(pfile_proc_label_get(proc_ptr), CTR_BUMP_DECR);
      }
      value_release(ptr->u.br.proc);
    }
  }
}

static cmd_t cmd_branch_dup(const cmd_t cmd)
{
  value_t *dup_params;
  value_t *params;

  params = cmd_brproc_params_get(cmd);
  if (params) {
    dup_params = CALLOC(sizeof(*dup_params), cmd_brproc_param_ct_get(cmd));
    if (dup_params) {
      size_t ii;

      for (ii = 0; ii < cmd_brproc_param_ct_get(cmd); ii++) {
        dup_params[ii] = params[ii];
        value_lock(dup_params[ii]);
      }
    }
  } else {
    dup_params = 0;
  }

  return cmd_branch_alloc(cmd_brtype_get(cmd),
      cmd_brcond_get(cmd), cmd_brdst_get(cmd),
      cmd_brval_get(cmd), cmd_brproc_get(cmd),
      dup_params);
}

static void cmd_branch_label_remap(cmd_t cmd, const label_map_t *map)
{
  cmd_label_remap2(cmd, map, cmd_brdst_get, cmd_brdst_set);
}

static void cmd_branch_variable_remap(cmd_t cmd, const variable_map_t *map)
{
  size_t        ii;
  value_t      *params;

  cmd_variable_remap2(cmd, map, cmd_brval_get, cmd_brval_set);
  cmd_variable_remap2(cmd, map, cmd_brproc_get, cmd_brproc_set);
  params = cmd_brproc_params_get(cmd);
  for (ii = 0; ii < cmd_brproc_param_ct_get(cmd); ii++) {
    value_t tmp;

    tmp = value_variable_remap(params[ii], map);
    if (tmp) {
      cmd_brproc_param_set(cmd, ii, tmp);
      value_release(tmp);
    }
  }
}

static void cmd_branch_value_remap(cmd_t cmd, const value_map_t *map)
{
  size_t   ii;
  value_t *params;

  cmd_value_remap2(cmd, map, cmd_brval_get, cmd_brval_set);
  cmd_value_remap2(cmd, map, cmd_brproc_get, cmd_brproc_set);
  params = cmd_brproc_params_get(cmd);
  for (ii = 0; ii < cmd_brproc_param_ct_get(cmd); ii++) {
    value_t tmp;

    tmp = value_map_find(map, params[ii]);
    if (tmp) {
      cmd_brproc_param_set(cmd, ii, tmp);
    }
  }
}

static flag_t cmd_branch_variable_accessed(const cmd_t cmd, variable_t var)
{
  flag_t                flags;
  size_t                ii;
  variable_def_t        def;
  variable_def_member_t mbr;
  value_t              *params;

  flags = CMD_VARIABLE_ACCESS_FLAG_NONE;
  if (value_variable_get(cmd_brval_get(cmd)) == var) {
    flags |= CMD_VARIABLE_ACCESS_FLAG_READ;
  }
  def = value_def_get(cmd_brproc_get(cmd));
  params = cmd_brproc_params_get(cmd);
  for (ii = 0, mbr = variable_def_member_get(def);
       mbr;
       ii++, mbr = variable_def_member_link_get(mbr)) {
    if (var == value_variable_get(params[ii])) {
      if (variable_def_flag_test(variable_def_member_def_get(mbr),
        VARIABLE_DEF_FLAG_IN)) {
        flags |= CMD_VARIABLE_ACCESS_FLAG_READ;
      }
      if (variable_def_flag_test(variable_def_member_def_get(mbr),
        VARIABLE_DEF_FLAG_OUT)) {
        flags |= CMD_VARIABLE_ACCESS_FLAG_WRITTEN;
      }
    }
  }
  return flags;
}

static flag_t cmd_branch_value_accessed(const cmd_t cmd, value_t val)
{
  flag_t                flags;
  size_t                ii;
  variable_def_t        def;
  variable_def_member_t mbr;
  value_t              *params;

  flags = CMD_VARIABLE_ACCESS_FLAG_NONE;
  if (cmd_brval_get(cmd) == val) {
    flags |= CMD_VARIABLE_ACCESS_FLAG_READ;
  }
  def = value_def_get(cmd_brproc_get(cmd));
  params = cmd_brproc_params_get(cmd);
  for (ii = 0, mbr = variable_def_member_get(def);
       mbr;
       ii++, mbr = variable_def_member_link_get(mbr)) {
    if (val == params[ii]) {
      if (variable_def_flag_test(variable_def_member_def_get(mbr),
        VARIABLE_DEF_FLAG_IN)) {
        flags |= CMD_VARIABLE_ACCESS_FLAG_READ;
      }
      if (variable_def_flag_test(variable_def_member_def_get(mbr),
        VARIABLE_DEF_FLAG_OUT)) {
        flags |= CMD_VARIABLE_ACCESS_FLAG_WRITTEN;
      }
    }
  }
  return flags;
}

static void cmd_branch_assigned_used_set(cmd_t cmd)
{
  size_t        ct;
  pfile_proc_t *proc;
  
  cmd_gen_add(cmd, value_variable_get(cmd_brval_get(cmd)));
  ct = cmd_brproc_param_ct_get(cmd);
  if (ct) {
    size_t   ii;
    value_t *vals;

    vals = cmd_brproc_params_get(cmd);
    for (ii = 0; ii < ct; ii++) {
      cmd_gen_add(cmd, value_variable_get(vals[ii]));
      cmd_kill_add(cmd, value_variable_get(vals[ii]));
    }
  }
  proc = value_proc_get(cmd_brproc_get(cmd));
  if (proc) {
    /* make sure the proc's exit knows we've called it */
    pfile_proc_successor_add(proc, cmd_link_get(cmd));
  }
}

static cmd_successor_rc_t cmd_branch_successor_get(cmd_t cmd, size_t ix,
  cmd_t *dst)
{
  cmd_successor_rc_t rc;

  rc = CMD_SUCCESSOR_RC_IX_BAD;
  if ((CMD_BRANCHTYPE_CALL == cmd_brtype_get(cmd))
    || (CMD_BRANCHTYPE_GOTO == cmd_brtype_get(cmd))) {
    cmd_t  brdst;

    brdst = label_cmd_get(cmd_brdst_get(cmd));
    /* brdst may not exist (indirect call) */
    if ((0 == ix) && (CMD_NONE != brdst)) {
      *dst = brdst;
      rc = CMD_SUCCESSOR_RC_MORE;
    } else if ((CMD_BRANCHTYPE_CALL == cmd_brtype_get(cmd))
      || (CMD_BRANCHCOND_NONE != cmd_brcond_get(cmd))) {
      /* if this is a conditional goto, or a call, the next
       * command is also a successor */
      *dst = cmd_link_get(cmd);
      rc = CMD_SUCCESSOR_RC_DONE;
    }
  }
  return rc;
}

static const cmd_vtbl_t cmd_br_vtbl = {
  cmd_branch_free,
  cmd_branch_dump,
  cmd_branch_dup,
  cmd_branch_label_remap,
  cmd_branch_variable_remap,
  cmd_branch_value_remap,
  cmd_branch_variable_accessed,
  cmd_branch_value_accessed,
  cmd_branch_assigned_used_set,
  cmd_branch_successor_get
};

/* proc_params[0] = where to put the return value */
cmd_t cmd_branch_alloc(
  cmd_branchtype_t type,
  cmd_branchcond_t cond, label_t dst, value_t val,
  value_t proc, value_t *proc_params)
{
  cmd_t cmd;

  if (CMD_BRANCHTYPE_CALL == type) {
    assert(dst == LABEL_NONE);
    assert(proc != VALUE_NONE);
  }
  cmd = cmd_alloc(CMD_TYPE_BRANCH, &cmd_br_vtbl);
  if (cmd) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      ptr->u.br.type        = type;
      ptr->u.br.cond        = cond;
      ptr->u.br.dst         = 0;
      ptr->u.br.var         = 0;
      ptr->u.br.proc        = proc;
      ptr->u.br.proc_params = proc_params;
      
      cmd_brdst_set(cmd, dst);
      cmd_brval_set(cmd, val);
      if (proc) {
        pfile_proc_t         *proc_ptr;
        variable_def_t        def;
        variable_def_member_t mbr;
        size_t                ii;

        value_lock(proc);

        def = value_def_get(proc);
        assert(VARIABLE_DEF_TYPE_FUNCTION == variable_def_type_get(def));
        value_use_ct_bump(proc, CTR_BUMP_INCR);
        for (mbr = variable_def_member_get(def), ii = 0;
             mbr;
             mbr = variable_def_member_link_get(mbr), ii++) {
          variable_def_t mdef;

          mdef = variable_def_member_def_get(mbr);
          if (mdef) {
            /* if ii == 0 this is the return value. we'll assume it's used */
            if (!ii || variable_def_flag_test(mdef, VARIABLE_DEF_FLAG_IN)) {
              value_use_ct_bump(proc_params[ii], CTR_BUMP_INCR);
            }
            if (variable_def_flag_test(mdef, VARIABLE_DEF_FLAG_OUT)
              || ((!value_is_const(proc_params[ii])
                && (VARIABLE_DEF_TYPE_POINTER 
                  == variable_def_type_get(mdef))))) {
              value_assign_ct_bump(proc_params[ii], CTR_BUMP_INCR);
            }
            proc_ptr = value_proc_get(proc_params[ii]);
            if (proc_ptr) {
              pfile_proc_flag_set(proc_ptr, PFILE_PROC_FLAG_INDIRECT);
              label_usage_bump(pfile_proc_label_get(proc_ptr), CTR_BUMP_INCR);
            }
          }
        }
        proc_ptr = value_proc_get(proc);
        if (proc_ptr) {
          label_usage_bump(pfile_proc_label_get(proc_ptr), CTR_BUMP_INCR);
        }
      }
    }
  }
  return cmd;
}

cmd_branchtype_t cmd_brtype_get(const cmd_t cmd)
{
  struct cmd_ *ptr;
  
  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);

  return (ptr && (CMD_TYPE_BRANCH == cmd_type_get(cmd)))
    ? ptr->u.br.type
    : CMD_BRANCHTYPE_NONE;
}

void cmd_brtype_set(cmd_t cmd, cmd_branchtype_t brtype)
{
  if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      ptr->u.br.type = brtype;
    }
  }
}

cmd_branchcond_t cmd_brcond_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr && (CMD_TYPE_BRANCH == cmd_type_get(cmd)))
    ? ptr->u.br.cond
    : CMD_BRANCHCOND_NONE;
}

void cmd_brcond_set(cmd_t cmd, cmd_branchcond_t brcond)
{
  if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      ptr->u.br.cond = brcond;
    }
  }
}

label_t cmd_brdst_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (CMD_TYPE_BRANCH == cmd_type_get(cmd))
    ? ptr->u.br.dst
    : 0;
}

void cmd_brdst_set(cmd_t cmd, label_t dst)
{
  if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      if (dst) {
        label_lock(dst);
        label_usage_bump(dst, CTR_BUMP_INCR);
      }
      if (ptr->u.br.dst) {
        label_usage_bump(ptr->u.br.dst, CTR_BUMP_DECR);
        label_release(ptr->u.br.dst);
      }
      ptr->u.br.dst = dst;
    }
  }
}

value_t cmd_brval_get(const cmd_t cmd)
{
  const struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (cmd && (CMD_TYPE_BRANCH == cmd_type_get(cmd)))
    ? ptr->u.br.var
    : 0;
}

void cmd_brval_set(cmd_t cmd, value_t val)
{
  if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);

    if (ptr) {
      if (val) {
        value_lock(val);
        value_use_ct_bump(val, CTR_BUMP_INCR);
      }
      if (ptr->u.br.var) {
        value_use_ct_bump(ptr->u.br.var, CTR_BUMP_DECR);
        value_release(ptr->u.br.var);
      }
      ptr->u.br.var = val;
    }
  }
}

value_t cmd_brproc_get(const cmd_t cmd)
{
  value_t proc;

  proc = VALUE_NONE;
  if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);

    if (ptr) {
      proc = ptr->u.br.proc;
    }
  }
  return proc;
}

void cmd_brproc_set(cmd_t cmd, value_t proc)
{
  if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);

    if (ptr) {
      value_lock(proc);
      value_use_ct_bump(proc, CTR_BUMP_INCR);
      label_usage_bump(pfile_proc_label_get(value_proc_get(proc)),
        CTR_BUMP_INCR);

      value_use_ct_bump(ptr->u.br.proc, CTR_BUMP_DECR);
      label_usage_bump(pfile_proc_label_get(value_proc_get(ptr->u.br.proc)),
        CTR_BUMP_DECR);
      value_release(ptr->u.br.proc);
      ptr->u.br.proc = proc;
    }
  }
}

value_t *cmd_brproc_params_get(const cmd_t cmd)
{
  value_t *params;

  params = 0;
  if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);

    if (ptr) {
      params = ptr->u.br.proc_params;
    }
  }
  return params;
}

size_t cmd_brproc_param_ct_get(const cmd_t cmd)
{
  variable_def_t        def;
  variable_def_member_t mbr;
  size_t                ct;

  def = value_def_get(cmd_brproc_get(cmd));
  for (ct = 0, mbr = variable_def_member_get(def);
       mbr;
       ct++, mbr = variable_def_member_link_get(mbr))
    ; /* null body */
  return ct;
}

void cmd_brproc_param_set(cmd_t cmd, size_t ix, value_t val)
{
  value_t *params;

  params = cmd_brproc_params_get(cmd);
  if (params && (ix <= cmd_brproc_param_ct_get(cmd))) {
    variable_def_t        def;
    variable_def_member_t mbr;
    value_t               old_val;
    
    old_val = params[ix];
    params[ix] = val;
    def = value_def_get(cmd_brproc_get(cmd));
    for (mbr = variable_def_member_get(def);
         mbr && ix;
         mbr = variable_def_member_link_get(mbr), ix--)
      ;
    if (variable_def_flag_test(variable_def_member_def_get(mbr),
          VARIABLE_DEF_FLAG_IN)) {
      value_use_ct_bump(val, CTR_BUMP_INCR);
      value_use_ct_bump(old_val, CTR_BUMP_DECR);
    }
    if (variable_def_flag_test(variable_def_member_def_get(mbr),
          VARIABLE_DEF_FLAG_OUT)) {
      value_assign_ct_bump(val, CTR_BUMP_INCR);
      value_assign_ct_bump(old_val, CTR_BUMP_DECR);
    }
    value_lock(val);
    value_release(old_val);
  }
}

value_t cmd_brproc_param_get(const cmd_t cmd, size_t ix)
{
  value_t *params;

  params = cmd_brproc_params_get(cmd);
  return (params && (ix < cmd_brproc_param_ct_get(cmd))) 
    ? params[ix]
    : VALUE_NONE;
}

