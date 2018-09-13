/************************************************************
 **
 ** jal_proc.h : JAL procedure declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef jal_proc_h__
#define jal_proc_h__

#include "../libcore/pfile.h"

void jal_parse_procedure(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_function(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_return(pfile_t *pf, const pfile_pos_t *start);

#define JAL_PARSE_CALL_FLAG_NONE  0x0000
#define JAL_PARSE_CALL_FLAG_PUT   0x0001
#define JAL_PARSE_CALL_FLAG_GET   0x0002
#define JAL_PARSE_CALL_FLAG_START 0x0004

value_t jal_parse_call(pfile_t *pf, value_t val, flag_t jal_parse_call_flag);

void jal_parse_task(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_start(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_suspend(pfile_t *pf, const pfile_pos_t *start);

#endif /* jal_proc_h__ */

