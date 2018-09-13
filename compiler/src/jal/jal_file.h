/************************************************************
 **
 ** jal_file.h : JAL file structure declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef jal_file_h__
#define jal_file_h__

#include "../libcore/pfile.h"

result_t    jal_file_open(pfile_t *pf);
void        jal_file_close(pfile_t *pf);

void        jal_source_process(pfile_t *pf);

boolean_t   jal_file_flag_test(const pfile_t *pf, flag_t flag);
void        jal_file_flag_set(pfile_t *pf, flag_t flag);
void        jal_file_flag_clr(pfile_t *pf, flag_t flag);

value_t     jal_file_loop_var_get(pfile_t *pf, value_t src);

#endif /* jal_file_h__ */

