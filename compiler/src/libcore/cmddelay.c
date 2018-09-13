/**********************************************************
 **
 ** cmddelay.c : the cmd delay functions
 **
 ** Copyright (c) 2006, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include "cmd_usec.h"
#include "cmdd.h"

static void cmd_usec_delay_dump(cmd_t cmd, FILE *dst)
{
  fprintf(dst, "usec_delay(%lu)", cmd_usec_delay_get(cmd));
}

static cmd_t cmd_usec_delay_dup(const cmd_t cmd)
{
  return cmd_usec_delay_alloc(cmd_usec_delay_get(cmd));
}

static const cmd_vtbl_t cmd_usec_delay_vtbl = {
  0, /* no special free processing */
  cmd_usec_delay_dump,
  cmd_usec_delay_dup,
  0, /* no label remap     */
  0, /* no variable remap  */
  0, /* no value remap     */
  0, /* no variable access */
  0, /* no value access    */
  0, /* no assign/used set */
  0  /* use default successor set */
};

cmd_t cmd_usec_delay_alloc(variable_const_t n)
{
  cmd_t cmd;

  cmd = cmd_alloc(CMD_TYPE_USEC_DELAY, &cmd_usec_delay_vtbl);
  cmd_usec_delay_set(cmd, n);
  return cmd;
}

variable_const_t cmd_usec_delay_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) ? ptr->u.usec_delay : 0;
}

void cmd_usec_delay_set(cmd_t cmd, variable_const_t n)
{
  struct cmd_ *ptr;

  ptr= cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->u.usec_delay = n;
  }
}

