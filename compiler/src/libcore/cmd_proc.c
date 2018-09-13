/**********************************************************
 **
 ** cmd_proc.c : the cmd_type proc functions
 **
 ** Copyright (c) 2008, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include "cmdd.h"

static void cmd_proc_free(cmd_t cmd)
{
  cmd_proc_set(cmd, PFILE_PROC_NONE);
}

static void cmd_proc_dump(cmd_t cmd, FILE *dst)
{
  pfile_proc_t *proc;

  proc = cmd_proc_get(cmd);
  fprintf(dst, "{%s %s",
      (CMD_TYPE_PROC_ENTER == cmd_type_get(cmd))
      ? "enter" : "leave",
      pfile_proc_tag_get(proc));
  if (CMD_TYPE_PROC_ENTER == cmd_type_get(cmd)) {
    size_t                ii;
    variable_def_member_t mbr;

    fprintf(dst, "(");
    mbr = variable_def_member_get(pfile_proc_def_get(proc));
    for (ii = 1; ii < pfile_proc_param_ct_get(proc); ii++) {
      mbr = variable_def_member_link_get(mbr);
      fprintf(dst, 
        "%s%s", (ii > 1) ? ", " : "",
        variable_def_member_tag_get(mbr));
    }
    fprintf(dst, ")");
  } 
  fprintf(dst, "}");
}

static cmd_t cmd_proc_dup(const cmd_t cmd)
{
  return cmd_proc_alloc(cmd_type_get(cmd), cmd_proc_get(cmd));
}

static void cmd_proc_assigned_used_set(cmd_t cmd)
{
  pfile_proc_t *proc;
  size_t        ct;

  proc = cmd_proc_get(cmd);
  ct   = pfile_proc_param_ct_get(proc);
  if (ct) {
    size_t ix;

    for (ix = 0; ix < ct; ix++) {
      value_t param;

      param = pfile_proc_param_get(proc, ix);
      if ((CMD_TYPE_PROC_ENTER == cmd_type_get(cmd))
        && value_dflag_test(param, VARIABLE_DEF_FLAG_IN)) {
        cmd_kill_add(cmd, value_variable_get(param));
      } else if ((CMD_TYPE_PROC_LEAVE == cmd_type_get(cmd))
        && value_dflag_test(param, VARIABLE_DEF_FLAG_OUT)) {
        cmd_kill_add(cmd, value_variable_get(param));
      }
    }
  }
}

static cmd_successor_rc_t cmd_proc_successor_get(cmd_t cmd, size_t ix,
  cmd_t *dst)
{
  cmd_successor_rc_t rc;
  
  rc = CMD_SUCCESSOR_RC_IX_BAD;
  if (CMD_TYPE_PROC_ENTER == cmd_type_get(cmd)) {
    if (0 == ix) {
      *dst = cmd_link_get(cmd);
      rc = CMD_SUCCESSOR_RC_DONE;
    }
  } else if (CMD_TYPE_PROC_LEAVE == cmd_type_get(cmd)) {
    pfile_proc_t *proc;

    proc = cmd_proc_get(cmd);
    if (proc && (ix < pfile_proc_successor_count(proc))) {
      *dst = pfile_proc_successor_get(proc, ix);
      rc = CMD_SUCCESSOR_RC_MORE;
    }
  }
  return rc;
}

static const cmd_vtbl_t cmd_proc_vtbl = {
  cmd_proc_free,
  cmd_proc_dump,
  cmd_proc_dup,
  0,  /* ignore label remap           */
  0,  /* ignore variable remap        */
  0,  /* ignore value remap           */
  0,  /* ignore cmd variable accessed */
  0,  /* ignore cmd value accessed    */
  cmd_proc_assigned_used_set,
  cmd_proc_successor_get
};

cmd_t cmd_proc_alloc(cmd_type_t type, pfile_proc_t *proc)
{
  cmd_t        cmd;
  struct cmd_ *ptr;

  cmd = cmd_alloc(type, &cmd_proc_vtbl);
  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->u.proc = PFILE_PROC_NONE;
  }
  cmd_proc_set(cmd, proc);
  return cmd;
}

pfile_proc_t *cmd_proc_get(const cmd_t cmd)
{
  pfile_proc_t *proc;

  proc = 0;
  if ((CMD_TYPE_PROC_ENTER == cmd_type_get(cmd))
    || (CMD_TYPE_PROC_LEAVE == cmd_type_get(cmd))) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
    if (ptr) {
      proc = ptr->u.proc;
    }
  }
  return proc;
}

static void cmd_proc_param_ctrs_bump(pfile_proc_t *proc, ctr_bump_t dir)
{
  size_t ii;

  /* bump the counters on the new proc parameters */
  for (ii = 0; ii < pfile_proc_param_ct_get(proc); ii++) {
    value_t val;

    val  = pfile_proc_param_get(proc, ii);
    if (value_dflag_test(val, VARIABLE_DEF_FLAG_IN)) {
      value_assign_ct_bump(val, dir);
    }
    if (value_dflag_test(val, VARIABLE_DEF_FLAG_OUT)) {
      value_use_ct_bump(val, dir);
    }
  }
}

void cmd_proc_set(cmd_t cmd, pfile_proc_t *proc)
{
  if ((CMD_TYPE_PROC_ENTER == cmd_type_get(cmd))
    || (CMD_TYPE_PROC_LEAVE == cmd_type_get(cmd))) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      if ((CMD_TYPE_PROC_ENTER == cmd_type_get(cmd))
        || (CMD_TYPE_PROC_LEAVE == cmd_type_get(cmd))) {
        label_cmd_set(pfile_proc_label_get(ptr->u.proc), CMD_NONE);
        cmd_proc_param_ctrs_bump(proc, CTR_BUMP_INCR);
        cmd_proc_param_ctrs_bump(ptr->u.proc, CTR_BUMP_DECR);
        ptr->u.proc = proc;
        if (CMD_TYPE_PROC_ENTER == cmd_type_get(cmd)) {
          label_cmd_set(pfile_proc_label_get(proc), cmd);
        }
      }
    }
  }
}


