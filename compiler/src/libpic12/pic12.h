/************************************************************
 **
 ** pic12.h : 12-bit pic code generation declarations
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic12_h__
#define pic12_h__

#include "../libcore/pfile.h"
#include "pic.h"
#include "pic_code.h"

boolean_t pic12_code_to_pcode(pfile_t *pf, pic_code_t code,
    unsigned val, unsigned literal, pic_code_to_pcode_t *dst);

void pic12_asm_header_write(pfile_t *pf, variable_const_t n_code_sz);

#endif

