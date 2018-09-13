/************************************************************
 **
 ** pic_inst.h : PIC instructions declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_inst_h__
#define pic_inst_h__

#include "pic.h"

/* pic instruction generation */

/* d = W or F                */
/* f = file register         */
/* b = bit (0..7)            */
/* k = constant (0..255)     */
/* n = destination (0..2047) */
void      pic_instr_default_flag_set(pfile_t *pf, flag_t flags);
void      pic_instr_default_flag_clr(pfile_t *pf, flag_t flags);
boolean_t pic_instr_default_flag_test(pfile_t *pf, flag_t flags);
flag_t    pic_instr_default_flag_get_all(pfile_t *pf);

pic_code_t pic_instr_alloc(pfile_t *pf, label_t lbl, pic_opcode_t op);
pic_code_t pic_instr_append(pfile_t *pf, pic_opcode_t op);
pic_code_t pic_instr_append_label(pfile_t *pf, label_t lbl);
pic_code_t pic_instr_append_f_d(pfile_t *pf, pic_opcode_t op, value_t f, 
    size_t ofs, pic_opdst_t dst);
pic_code_t pic_instr_append_reg_d(pfile_t *pf, pic_opcode_t op, const char *reg,
  pic_opdst_t dst);
pic_code_t pic_instr_append_f(pfile_t *pf, pic_opcode_t op, value_t f, 
    size_t ofs);
pic_code_t pic_instr_append_reg(pfile_t *pf, pic_opcode_t op, const char *reg);
pic_code_t pic_instr_append_f_b(pfile_t *pf, pic_opcode_t op, value_t f, 
    size_t ofs, value_t bit);
pic_code_t pic_instr_append_reg_bn(pfile_t *pf, pic_opcode_t op, 
    const char *reg, variable_const_t bit);
pic_code_t pic_instr_append_reg_flag(pfile_t *pf, pic_opcode_t op, 
    const char *reg, const char *flag);
pic_code_t pic_instr_append_f_bn(pfile_t *pf, pic_opcode_t op,
    value_t f, size_t ofs, variable_const_t n);
pic_code_t pic_instr_append_w_k(pfile_t *pf, pic_opcode_t op, 
    value_t k);
pic_code_t pic_instr_append_w_kn(pfile_t *pf, pic_opcode_t op,
    variable_const_t n);
pic_code_t pic_instr_append_n(pfile_t *pf, pic_opcode_t op, label_t dst);

const char *pic_opcode_str(pic_opcode_t op);
pic_optype_t pic_optype_get(pic_opcode_t op);
const char *pic_opdst_str(pic_opdst_t type);

boolean_t pic_opcode_is_branch_bit(pic_opcode_t op);
boolean_t pic_opcode_is_data_bit(pic_opcode_t op);

void pic_instr_append_daop(pfile_t *pf, value_t f, pic_opcode_t op,
    boolean_t force);
boolean_t pic_are_variable_databits_different(pfile_t *pf, value_t a, 
    value_t b);

pic_opcode_t pic_value_datalo_get(pfile_t *pf, value_t val);
pic_opcode_t pic_value_datahi_get(pfile_t *pf, value_t val);

pic_code_t pic_instr_append_lfsr(pfile_t *pf, unsigned which,
    value_t val, size_t ofs);
#endif /* pic_inst_h__ */

