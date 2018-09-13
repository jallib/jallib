/************************************************************
 **
 ** pf_cmd.h : pfile command API declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_cmd_h__
#define pf_cmd_h__

#include "pfile.h"
#include "cmd_brch.h"

/* command list manipulation */
void     pfile_cmd_add(pfile_t *pf, cmd_t cmd);
void     pfile_cmd_branch_add(pfile_t *pf, 
  cmd_branchtype_t type, cmd_branchcond_t cond, label_t dst,
  value_t var, value_t proc, value_t *proc_params);
void   pfile_cmd_special_add(pfile_t *pf, cmd_type_t type, pfile_proc_t *proc);
void   pfile_cmd_usec_delay_add(pfile_t *pf, variable_const_t n);
void   pfile_cmd_label_add(pfile_t *pf, label_t label);
void   pfile_cmd_log_add(pfile_t *pf, pfile_log_t plog, size_t sz,
  const char *str);
void   pfile_cmd_dump(pfile_t *pf, const char *prog_name, 
    size_t argc, char **argv);
cmd_t pfile_cmdlist_get(pfile_t *pf);
cmd_t pfile_cmdlist_tail_get(pfile_t *pf);
void pfile_cmdlist_check(cmd_t cmd);
boolean_t pfile_cmd_remove_unreachable(pfile_t *pf);
boolean_t pfile_cmd_remove_assignments(pfile_t *pf);
boolean_t pfile_cmd_remove_empty_blocks(pfile_t *pf);

#endif /* pf_cmd_h__ */

