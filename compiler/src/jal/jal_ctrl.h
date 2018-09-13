/************************************************************
 **
 ** jal_ctrl.h : JAL control declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef jal_ctrl_h__
#define jal_ctrl_h__

#include "../libcore/pfile.h"

void jal_parse_if(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_while(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_repeat(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_for(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_forever(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_debug(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_warn(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_error(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_usec_delay(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_case(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_exit(pfile_t *pf, const pfile_pos_t *start);
#endif /* jal_ctrl_h__ */

