/************************************************************
 **
 ** pic14.h : 14-bit pic code generation declarations
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic14_h__
#define pic14_h__

#include "../libcore/pfile.h"
#include "pic.h"
#include "pic_code.h"

boolean_t pic14_code_to_pcode(pfile_t *pf, pic_code_t code,
    unsigned val, unsigned literal, pic_code_to_pcode_t *dst);
void pic14_asm_header_write(pfile_t *pf, variable_const_t n_code_sz);

#endif

