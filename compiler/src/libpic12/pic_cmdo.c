/************************************************************
 **
 ** pic_cmdo.c : pic cmd optimization definitions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include "../libcore/value.h"
#include "../libcore/cmd_op.h"
#include "../libcore/cmd_brch.h"
#include "../libcore/pfile.h"
#include "../libcore/pf_proc.h"
#include "pic.h"
#include "pic_cmdo.h"


/* this occurs after all pfile optimization, but before variable
 * definition
 *
 * currently, it looks for
 *   tmp = expr
 *   branch condition tmp --> x
 * and removes tmp from (tmp = relational)
 */ 
void pic_cmd_optimize(pfile_t *pf, cmd_t *cmd_head)
{
  cmd_t         cmd;
  pfile_proc_t *proc;

  UNUSED(pf);

  cmd = cmd_next_exec_get(*cmd_head);
  while (cmd) {
    cmd_t cmd_next;
    
    cmd_next = cmd_next_exec_get(cmd_link_get(cmd));
    if ((operator_is_relation(cmd_optype_get(cmd))
          || (OPERATOR_ASSIGN == cmd_optype_get(cmd))
          || (OPERATOR_LOGICAL == cmd_optype_get(cmd))
          || (OPERATOR_NOTL == cmd_optype_get(cmd))
          || (OPERATOR_CMPB == cmd_optype_get(cmd)))
        && value_is_temp(cmd_opdst_get(cmd))
        && value_is_same(cmd_opdst_get(cmd), cmd_brval_get(cmd_next))
        && (CMD_BRANCHCOND_NONE != cmd_brcond_get(cmd_next))) {
      cmd_opdst_set(cmd, VALUE_NONE);
      cmd_brval_set(cmd_next, VALUE_NONE);
    }
    cmd = cmd_next;
  }
  /* look for any re-entrant functions and mark then `frame'
   * similarly, any indirect functions need to be marked `frame'
   * because for now these all need to be permanently allocated.
   *   In the future, any time a function is called indirectly
   *   I should assume any function with the same signature might
   *   be called, and add that information to the interference
   *   graph. 
   * Any procedure marked `nostack' needs a procedure level variable,
   *   _return, to hold the return address */
  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_REENTRANT)
      || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INDIRECT)) {
      pfile_proc_flag_set(proc, PFILE_PROC_FLAG_FRAME);
    }
  }
}

