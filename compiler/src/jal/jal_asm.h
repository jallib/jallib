/************************************************************
 **
 ** jal_asm.h : JAL assembler declarations
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef jal_asm_h__
#define jal_asm_h__

#include "../libcore/pfile.h"

void jal_parse_asm(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_assembler(pfile_t *pf, const pfile_pos_t *start);

#endif /* jal_asm_h__ */

