/**********************************************************
 **
 ** cmdassrt.c : the cmd_type assert functions
 **
 ** Copyright (c) 2008, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include "cmdd.h"

value_t cmd_assert_value_get(const cmd_t cmd)
{
  value_t val;

  val = VALUE_NONE;
  if (CMD_TYPE_ASSERT == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
    if (ptr) {
      val = ptr->u.val;
    }
  }
  return val;
}

void cmd_assert_value_set(cmd_t cmd, value_t val)
{
  if (CMD_TYPE_ASSERT == cmd_type_get(cmd)) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      value_lock(val);
      value_assign_ct_bump(val, CTR_BUMP_INCR);
      value_use_ct_bump(val, CTR_BUMP_INCR);
      value_assign_ct_bump(ptr->u.val, CTR_BUMP_DECR);
      value_use_ct_bump(ptr->u.val, CTR_BUMP_DECR);
      value_release(ptr->u.val);
      ptr->u.val = val;
    }
  }
}

static void cmd_assert_free(cmd_t cmd)
{
  cmd_assert_value_set(cmd, VALUE_NONE);
}

static void cmd_assert_dump(cmd_t cmd, FILE *dst)
{
  value_dump(cmd_assert_value_get(cmd), dst);
}

static cmd_t cmd_assert_dup(const cmd_t cmd)
{
  return cmd_assert_alloc(cmd_assert_value_get(cmd));
}

static const cmd_vtbl_t cmd_assert_vtbl = {
  cmd_assert_free,
  cmd_assert_dump,
  cmd_assert_dup,
  0, /* ignore label remap           */
  0, /* ignore variable map          */
  0, /* ignore value map             */
  0, /* ignore cmd variable accessed */
  0, /* ignore cmd value accessed    */
  0, /* ignore assign/used set       */
  0  /* use default successor set    */
};

cmd_t cmd_assert_alloc(value_t val)
{
  cmd_t cmd;

  cmd = cmd_alloc(CMD_TYPE_ASSERT, &cmd_assert_vtbl);
  if (cmd) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      ptr->u.val = VALUE_NONE;
      cmd_assert_value_set(cmd, val);
    }
  }
  return cmd;
}

