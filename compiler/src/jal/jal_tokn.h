/************************************************************
 **
 ** jal_tokn.h : JAL token declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef jal_tokn_h__
#define jal_tokn_h__

#include "../libcore/pfile.h"

value_t     jal_token_to_constant(pfile_t *pf, pfile_log_t plog);
value_t     jal_token_to_str(pfile_t *pf, pfile_log_t plog);
boolean_t   jal_token_is_eos(pfile_t *pf);
boolean_t   jal_token_is_identifier(pfile_t *pf);

const char *jal_token_get(pfile_t *pf, pf_token_get_t which);
boolean_t   jal_token_is_keyword(pfile_t *pf);
void        jal_token_is(pfile_t *pf, const char *token);

/* just return everything through the end of the line */
const char *jal_token_parse_raw(pfile_t *pf);

#endif /* jal_tokn_h__ */

