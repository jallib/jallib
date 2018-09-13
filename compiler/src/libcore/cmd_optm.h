/************************************************************
 **
 ** cmd_optm.h : p-code optimization declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef cmd_optm_h__
#define cmd_optm_h__

#include "cmd.h"

/* note: these optimizations are order dependent, and should
         be run in the order listed */
void cmd_analyze(cmd_t cmd_top, cmd_t cmd, flag_t flag, size_t depth,
  pfile_t *pf);
boolean_t cmd_opt_branch(cmd_t *cmd_head);
boolean_t cmd_opt_branch2(cmd_t *cmd_head);
boolean_t cmd_opt_branch3(cmd_t *cmd_head);
boolean_t cmd_opt_branch4(pfile_t *pf, cmd_t *cmd_head);

#endif /* cmd_optm_h__ */

