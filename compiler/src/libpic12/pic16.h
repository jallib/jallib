/************************************************************
 **
 ** pic16.h : 16-bit pic code generation declarations
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic16_h__
#define pic16_h__

#include "../libcore/pfile.h"
#include "pic.h"
#include "pic_code.h"

boolean_t pic16_code_to_pcode(pfile_t *pf, pic_code_t code,
    unsigned val, unsigned literal, pic_code_to_pcode_t *dst);

#endif

