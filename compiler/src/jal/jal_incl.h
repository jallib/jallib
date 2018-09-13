/************************************************************
 **
 ** jal_incl.h : JAL include and pragma declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef jal_incl_h__
#define jal_incl_h__

#include "../libcore/pfile.h"

/*
 * these are defined both here and in libpic12.
 * it would be far better to have them only defined
 * in one place, but I cannot see how to do that :(
 */
#define JAL_EEPROM                 "_eeprom"
#define JAL_EEPROM_BASE JAL_EEPROM "_base"
#define JAL_EEPROM_USED JAL_EEPROM "_used"

#define JAL_ID                 "_id0"
#define JAL_ID_BASE JAL_ID     "_base"
#define JAL_ID_USED JAL_ID     "_used"

void jal_parse_include(pfile_t *pf, const pfile_pos_t *statement_start);
void jal_parse_pragma(pfile_t *pf, const pfile_pos_t *statement_start);

#endif /* jal_incl_h__ */

