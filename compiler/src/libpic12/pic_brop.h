/************************************************************
 **
 ** pic_brop.h : PIC branch optimization definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_brop_h__
#define pic_brop_h__

#include "pic.h"

#define PIC_BRANCHBITS_PC_SET_FLAG_NONE  0x0000
#define PIC_BRANCHBITS_PC_SET_FLAG_CHECK 0x0001
void      pic_branchbits_pc_set(pfile_t *pf, unsigned flags);
void      pic_code_branch_optimize(pfile_t *pf);
void      pic_code_branchbits_optimize(pfile_t *pf);
void      pic_code_return_literal_optimimze(pfile_t *pf);
boolean_t pic_code_branchbits_remove(pfile_t *pf);
boolean_t pic_code_skip_cond_optimize(pfile_t *pf);

#endif /* pic_brop_h__ */

