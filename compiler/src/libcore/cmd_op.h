/**********************************************************
 **
 ** cmd_op.h : the CMD_TYPE_OPERATOR declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#ifndef cmd_op_h__
#define cmd_op_h__

#include "operator.h"
#include "cmd.h"

/* operator operations */
operator_t        cmd_optype_get(const cmd_t cmd);
void              cmd_optype_set(cmd_t cmd, operator_t op);

value_t cmd_opdst_get(const cmd_t cmd);
void              cmd_opdst_set(cmd_t cmd, value_t dst);

value_t cmd_opval1_get(const cmd_t cmd);
void              cmd_opval1_set(cmd_t cmd, value_t val1);

value_t cmd_opval2_get(const cmd_t cmd);
void              cmd_opval2_set(cmd_t cmd, value_t val2);

result_t cmd_op_reduction(cmd_t cmd, value_t value_zero, value_t value_one);

boolean_t cmd_op_is_assign(operator_t op, value_t val1, value_t val2);

#endif /* cmd_op_h__ */

