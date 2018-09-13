/************************************************************
 **
 ** pic14h.h : 14-bit hybrid pic code generation declarations
 **
 ** Copyright (c) 2009, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic14h_h__
#define pic14h_h__

#include "../libcore/pfile.h"
#include "pic.h"
#include "pic_code.h"

boolean_t pic14h_code_to_pcode(pfile_t *pf, pic_code_t code,
    unsigned val, unsigned literal, pic_code_to_pcode_t *dst);
void pic14h_asm_header_write(pfile_t *pf, variable_const_t n_code_sz);

#endif

