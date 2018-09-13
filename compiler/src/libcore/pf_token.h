/************************************************************
 **
 ** pf_token.h : pfile token declarations
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_token_h__
#define pf_token_h__

#include <stdlib.h>
#include "../libutils/types.h"
#include "univ.h"
#include "value.h"
#include "label.h"
#include "pf_log.h"

/* this needs to be provided by the language parser to grab the next
 * token from the token stream */
typedef enum pf_token_get_ { 
  PF_TOKEN_FIRST, 
  PF_TOKEN_CURRENT, 
  PF_TOKEN_NEXT 
} pf_token_get_t;

const char *pf_token_get(pfile_t *pf, pf_token_get_t which);
void        pf_token_set(pfile_t *pf, const char *token);

result_t pf_token_to_str(pfile_t *pf, pfile_log_t plog, value_t *dst);
result_t pf_token_to_constant(pfile_t *pf, pfile_log_t plog, value_t *dst);
result_t pf_token_to_value(pfile_t *pf, pfile_log_t plog, value_t *dst);
result_t pf_token_to_label(pfile_t *pf, pfile_log_t plog, boolean_t alloc,
    label_t *dst);

boolean_t pf_token_is(pfile_t *pf, pf_token_get_t which, pfile_log_t plog,
  const char *str);
boolean_t pf_token_is_eof(pfile_t *pf);
boolean_t pf_token_is_eos(pfile_t *pf);

typedef boolean_t (*pf_token_parse_allow_cb_t)(int ch);

#define PF_TOKEN_PARSE_ALLOW_STORE 0x0001 /* store the result in token    */
#define PF_TOKEN_PARSE_ALLOW_UNGET 0x0002 /* unget first not allowed char */
int pf_token_parse_allow(
  pfile_t                  *pf,
  pf_token_parse_allow_cb_t allow,
  flag_t                     flags);

const char *pf_token_ptr_get(pfile_t *bf);
void        pf_token_ch_append(pfile_t *bf, int ch);
void        pf_token_reset(pfile_t *bf);

result_t pf_identifier_to_value(pfile_t *pf, pfile_log_t plog, 
  const char *id, value_t *dst);

result_t pf_identifier_to_variable(pfile_t *pf, pfile_log_t plog,
  const char *id, variable_t *dst);

result_t pf_token_to_variable(pfile_t *pf, pfile_log_t plog,
    variable_t *dst);

const char *pf_token_ptr_get(pfile_t *pf);
void        pf_token_set(pfile_t *pf, const char *tokn);
size_t      pf_token_sz_get(pfile_t *pf);
void        pf_token_ch_append(pfile_t *pf, int ch);
void        pf_token_reset(pfile_t *pf);

void        pf_token_start_get(pfile_t *pf, pfile_pos_t *pos);

#endif /* pf_token_h__ */

