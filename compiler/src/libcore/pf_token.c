/**********************************************************
 **
 ** pf_tokn.c : token parsing bits
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <string.h>
#include "pfile.h"
#include "pfiled.h"
#include "pf_msg.h"
#include "pf_token.h"

/*
 * NAME
 *   pf_token_parse_allow
 *
 * DESCRIPTION
 *   parse the token while the character is allowed
 *
 * PARAMETERS
 *   pf    : returned by pf_open()
 *   allow : allow function
 *   flags : determine what to do with the characters
 *
 * RETURN
 *   first character not allowed
 *
 * NOTES
 */
int pf_token_parse_allow(
  pfile_t                  *pf, 
  pf_token_parse_allow_cb_t allow, 
  flag_t                    flags)
{
  int ch;

  for ( ; ; ) {
    ch = pfile_ch_get(pf);
    if ((EOF == ch) || !allow(ch)) {
      break; /* done !*/
    } else if (flags & PF_TOKEN_PARSE_ALLOW_STORE) {
      pf_token_ch_append(pf, TOLOWER(ch));
    }
  }
  if (flags & PF_TOKEN_PARSE_ALLOW_UNGET) {
    pfile_ch_unget(pf, ch);
  }
  return ch;
}

/*
 * NAME
 *   pf_token_get
 *
 * DESCRIPTION
 *   retrieve a token
 *
 * PARAMETERS
 *   pf    : returned by pfile_open()
 *   which : which token to get (first, current, next)
 *   dst   : [out] points to retrieved token
 *
 * RETURN
 *   none
 *
 * NOTES
 */
const char *pf_token_get(pfile_t *pf, pf_token_get_t which)
{
  switch (which) {
    case PF_TOKEN_FIRST:
      pf->token_ct = 1;
      break;
    case PF_TOKEN_NEXT:
      pf->token_ct++;
      break;
    case PF_TOKEN_CURRENT:
      break;
  }
  return (pf->vectors->pf_token_get_fn(pf, which));
}

/*
 * NAME
 *   pf_token_to_variable
 *
 * DESCRIPTION
 *   return the variable named by the current token
 *
 * PARAMETERS
 *   pf : returned by pfile_open
 *   plog : how to log result
 *   dst  : [out] holds result on success
 *
 * RETURN
 *   0      : no error
 *   EINVAL : token is not an identifier
 *   ENOENT : variable does not exist
 *
 * NOTES
 *   *dst is locked when returned
 */
result_t pf_identifier_to_variable(pfile_t *pf, pfile_log_t plog,
  const char *id, variable_t *dst)
{
  variable_t  var;
  result_t    rc;

  var = 0;
  if (('_' != *id) && !ISALPHA(*id)) {
    pfile_log(pf, plog, PFILE_MSG_VARIABLE_EXPECTED);
    rc = RESULT_INVALID;
  } else {
    var = pfile_variable_find(pf, plog, id, 0);
    if (var) {
      rc = RESULT_OK;
      *dst = var;
    } else {
      rc = RESULT_NOT_FOUND;
    }
  }
  return rc;
}

result_t pf_token_to_variable(pfile_t *pf, pfile_log_t plog,
    variable_t *dst)
{
  return pf_identifier_to_variable(pf, plog,
    pf_token_get(pf, PF_TOKEN_CURRENT), dst);
}

result_t pf_identifier_to_value(pfile_t *pf, pfile_log_t plog, 
  const char *id, value_t *dst)
{
  variable_t var;
  value_t    val;
  result_t   rc;

  rc = pf_identifier_to_variable(pf, plog, id, &var);
  if (RESULT_OK == rc) {
    val = value_alloc(var);
    variable_release(var);
    if (!val) {
      rc = RESULT_MEMORY;
      pfile_log_syserr(pf, rc);
    } else {
      rc = RESULT_OK;
      *dst = val;
    }
  }
  return rc;
}

result_t pf_token_to_value(pfile_t *pf, pfile_log_t plog, value_t *dst)
{
  return pf_identifier_to_value(pf, plog, 
    pf_token_get(pf, PF_TOKEN_CURRENT), dst);
}

result_t pf_token_to_label(pfile_t *pf, pfile_log_t plog, 
    boolean_t alloc, label_t *dst)
{
  label_t     lbl;
  const char *ptr;
  result_t    rc;

  ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
  rc = RESULT_OK;
  lbl = pfile_label_find(pf, (alloc) ? PFILE_LOG_NONE : plog, ptr);
  if (!lbl && alloc) {
    lbl = pfile_label_alloc(pf, ptr);
    if (!lbl) {
      rc = RESULT_MEMORY;
    }
  }
  if (RESULT_OK == rc) {
    if (!lbl) {
      rc = RESULT_NOT_FOUND;
    } else {
      *dst = lbl;
    }
  }
  return rc;
}

boolean_t pf_token_is(pfile_t *pf, pf_token_get_t which, 
    pfile_log_t plog, const char *str)
{
  boolean_t   rc;
  const char *ptr;

  ptr = pf_token_get(pf, which);
  rc = (str) ? (0 == strcmp(ptr, str)) : 0;
  if (!rc) {
    pfile_log(pf, plog, PFILE_MSG_EXPECTED, str, ptr);
  }
  return rc;
}

boolean_t pf_token_is_eof(pfile_t *pf)
{
  const char *ptr;

  ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
  return (0 == *ptr);
}

boolean_t pf_token_is_eos(pfile_t *pf)
{
  return pf_token_is_eof(pf)
    || pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "\n");
}

const char *pf_token_ptr_get(pfile_t *pf)
{
  return pf->token;
}

void pf_token_set(pfile_t *pf, const char *tokn)
{
  size_t sz;

  sz = strlen(tokn);
  if (sz > PFILE_TOKEN_SZ_MAX) {
    sz = PFILE_TOKEN_SZ_MAX;
  }
  memcpy(pf->token, tokn, sz);
  pf->token[sz] = 0;
  pf->token_len = sz;
}

size_t pf_token_sz_get(pfile_t *pf)
{
  return pf->token_len;
}

void pf_token_ch_append(pfile_t *pf, int ch)
{
  if (EOF == ch) {
    if (!pf->token_len) {
      pf->token[0] = 0;
    }
  } else {
    if (pf->token_len < PFILE_TOKEN_SZ_MAX) {
      pf->token[pf->token_len++] = ch;
      pf->token[pf->token_len] = 0;
    }
  }
}

void pf_token_reset(pfile_t *pf)
{
  pfile_pos_get(pf, &pf->token_start);
  pf->token_len = 0;
  pf->token[0] = 0;
}

void pf_token_start_get(pfile_t *pf, pfile_pos_t *pos)
{
  if (pf && pos) {
    *pos = pf->token_start;
  }
}

