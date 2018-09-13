/**********************************************************
 **
 ** cmd_log.c : cmd log definitions
 **
 ** Copyright (c) 2009, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <string.h>
#include "../libutils/mem.h"
#include "cmd_log.h"
#include "cmdd.h"

static void cmd_log_free(cmd_t cmd)
{
  cmd_log_str_set(cmd, 0, 0);
}

static void cmd_log_dump(cmd_t cmd, FILE *dst)
{
  const char *type;

  type = "???";
  switch (cmd_log_type_get(cmd)) {
    case PFILE_LOG_NONE:                  break;
    case PFILE_LOG_CRIT:  type = "crit";  break;
    case PFILE_LOG_ERR:   type = "error"; break;
    case PFILE_LOG_WARN:  type = "warn";  break;
    case PFILE_LOG_INFO:  type = "info";  break;
    case PFILE_LOG_DEBUG: type = "debug"; break;
  }
  fprintf(dst, "log(%s): %s", type, cmd_log_str_get(cmd));
}

static cmd_t cmd_log_dup(const cmd_t cmd)
{
  size_t      sz;
  const char *ptr;

  ptr = cmd_log_str_get(cmd);
  sz  = (ptr) ? strlen(ptr) : 0;
  return cmd_log_alloc(cmd_log_type_get(cmd), sz, ptr);
}

static const cmd_vtbl_t cmd_log_vtbl = {
  cmd_log_free,
  cmd_log_dump,
  cmd_log_dup,
  0, /* no label remap     */
  0, /* no variable remap  */
  0, /* no value remap     */
  0, /* no variable access */
  0, /* no value access    */
  0, /* no assign/used set */
  0  /* use default successor set */
};

cmd_t cmd_log_alloc(pfile_log_t plog, size_t sz, const char *str)
{
  cmd_t        cmd;
  struct cmd_ *ptr;

  cmd = cmd_alloc(CMD_TYPE_LOG, &cmd_log_vtbl);

  ptr= cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->u.log.str = 0;
  }
  cmd_log_type_set(cmd, plog);
  cmd_log_str_set(cmd, sz, str);
  return cmd;
}

pfile_log_t cmd_log_type_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) ? ptr->u.log.type : PFILE_LOG_NONE;
}

void cmd_log_type_set(cmd_t cmd, pfile_log_t plog)
{
  struct cmd_ *ptr;

  ptr= cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->u.log.type = plog;
  }
}

const char *cmd_log_str_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) ? ptr->u.log.str : "";
}

void cmd_log_str_set(cmd_t cmd, size_t sz, const char *str)
{
  struct cmd_ *ptr;

  ptr= cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    if (ptr->u.log.str) {
      FREE(ptr->u.log.str);
      ptr->u.log.str = 0;
    }
    if (str && sz) {
      sz++;
      ptr->u.log.str = MALLOC(sz);
      if (ptr->u.log.str) {
        memcpy(ptr->u.log.str, str, sz);
      }
    }
  }
}

