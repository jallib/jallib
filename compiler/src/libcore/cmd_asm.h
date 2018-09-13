/**********************************************************
 **
 ** cmd_asm.h : declarations for cmd_asm_t
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#ifndef cmd_asm_h__
#define cmd_asm_h__

#include "value.h"
#include "../libpic12/pic_opco.h"

cmd_t cmd_asm_alloc(
    pic_opcode_t op, value_t val, size_t valofs, pic_opdst_t opdst,
    value_t n, label_t lbl, flag_t flags, size_t data_sz, uchar *data);

pic_opcode_t cmd_asm_op_get(const cmd_t cmd);
void         cmd_asm_op_set(cmd_t cmd, pic_opcode_t op);

value_t      cmd_asm_val_get(const cmd_t cmd);
void         cmd_asm_val_set(cmd_t cmd, value_t val);

size_t       cmd_asm_valofs_get(const cmd_t cmd);
void         cmd_asm_valofs_set(cmd_t cmd, size_t val);

pic_opdst_t  cmd_asm_opdst_get(const cmd_t cmd);
void         cmd_asm_opdst_set(cmd_t cmd, pic_opdst_t dst);

value_t      cmd_asm_n_get(const cmd_t cmd);
void         cmd_asm_n_set(cmd_t cmd, value_t n);

label_t      cmd_asm_lbl_get(const cmd_t cmd);
void         cmd_asm_lbl_set(cmd_t cmd, label_t lbl);

boolean_t    cmd_asm_flag_test(const cmd_t cmd, flag_t flag);
flag_t       cmd_asm_flag_get_all(const cmd_t cmd);

size_t       cmd_asm_data_sz_get(const cmd_t cmd);
uchar       *cmd_asm_data_get(const cmd_t cmd);
void         cmd_asm_data_set(cmd_t cmd, size_t sz, uchar *data);

#endif /* cmd_asm_h__ */

