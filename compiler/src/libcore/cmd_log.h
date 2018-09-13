/************************************************************
 **
 ** cmd_log.h : cmd log declarations
 **
 ** Copyright (c) 2009, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef cmd_log_h__
#define cmd_log_h__

#include "pf_log.h"
#include "cmd.h"

cmd_t cmd_log_alloc(pfile_log_t plog, size_t str_sz, const char *str);

pfile_log_t cmd_log_type_get(const cmd_t cmd);
void        cmd_log_type_set(cmd_t cmd, pfile_log_t plog);

const char *cmd_log_str_get(const cmd_t cmd);
void        cmd_log_str_set(cmd_t cmd, size_t sz, const char *str);

#endif /* cmd_log_h__ */


