/**********************************************************
 **
 ** jal_tokn.c : JAL token parsing bits
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <string.h>
#include <math.h>
#include "../libcore/pf_msg.h"
#include "jal_tokn.h"

/*
 * NAME
 *   allow_*
 *
 * DESCRIPTION
 *   used by the parsing functions
 *
 * PARAMETERS
 *   ch : character to test
 *
 * RETURN
 *   TRUE if the character is allowed, FALSE if not
 *
 * NOTES
 *   none
 */
static boolean_t allow_identifier(int ch)
{
  return ISALPHA(ch) || ISDIGIT(ch) || ('_' == ch);
}

static boolean_t allow_decimal(int ch)
{
  return ISDIGIT(ch) || ('_' == ch);
}

static boolean_t allow_hex(int ch)
{
  return ISXDIGIT(ch) || ('_' == ch);
}

static boolean_t allow_binary(int ch)
{
  return ('0' == ch) || ('1' == ch) || ('_' == ch);
}

static boolean_t allow_octal(int ch)
{
  return (('0' <= ch) && (ch <= '7')) || ('_' == ch);
}

static boolean_t allow_space(int ch)
{
  return /*('\n' != ch) && */ISSPACE(ch) || (ch < ' ');
}

static boolean_t allow_comment(int ch)
{
  return ('\n' != ch);
}

static boolean_t allow_any(int ch)
{
  return !ISSPACE(ch);
}

/*
 * NAME
 *   jal_token_get
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
const char *jal_token_get(pfile_t *pf, pf_token_get_t which)
{
  static const char xdig[] = "0123456789abcdef";
  int      ch;

  switch (which) {
    case PF_TOKEN_FIRST:
      pfile_rewind(pf);
      /* fall through */
    case PF_TOKEN_NEXT:
      /* skip any preceding spaces */
      do {
        ch = pf_token_parse_allow(pf, allow_space, 0);
        pf_token_reset(pf);
        if (ISALPHA(ch)) {
          ch = TOLOWER(ch);
        }
        pf_token_ch_append(pf, ch);
        if (('_' == ch) || ISALPHA(ch)) {
          /* identifier */
          ch = pf_token_parse_allow(pf, allow_identifier, 
            PF_TOKEN_PARSE_ALLOW_STORE
            | PF_TOKEN_PARSE_ALLOW_UNGET);
        } else if (ISDIGIT(ch)) {
          /* constant */
          pf_token_parse_allow_cb_t allow;

          allow = allow_decimal;
          if ('0' == ch) {
            /* check for 0x (hex) or 0b (binary) */
            ch = pfile_ch_get(pf);
            if (EOF != ch) {
              ch = TOLOWER(ch);
              if ('b' == ch) {
                /* this is a binary constant */
                allow = allow_binary;
              } else if ('q' == ch) {
                /* this is an octal constant */
                allow = allow_octal;
              } else if ('x' == ch) {
                /* this is a hex constant */
                allow = allow_hex;
              } else if (ISDIGIT(ch) || ('.' == ch) || ('e' == TOLOWER(ch))) {
                /* this is a decimal constant */
                /* (no change to allow */
              } else {
                pfile_ch_unget(pf, ch);
                allow = 0;
              }
              if (allow) {
                pf_token_ch_append(pf, ch);
              }
            }
          }
          if (allow) {
            ch = pf_token_parse_allow(pf, allow, PF_TOKEN_PARSE_ALLOW_STORE);
            if (allow_decimal == allow) {
              if ('.' == ch) {
                pf_token_ch_append(pf, ch);
                ch = pf_token_parse_allow(pf, allow, 
                  PF_TOKEN_PARSE_ALLOW_STORE);
                if ('e' == TOLOWER(ch)) {
                  pf_token_ch_append(pf, 'e');
                  ch = pfile_ch_get(pf);
                  if (('+' == ch) || ('-' == ch) || ISDIGIT(ch)) {
                    pf_token_ch_append(pf, ch);
                    ch = pf_token_parse_allow(pf, allow,
                      PF_TOKEN_PARSE_ALLOW_STORE);
                  } else {
                    pfile_ch_unget(pf, ch);
                  }
                }
              }
            }
            if (('_' == ch) || ISALPHA(ch)) {
              /* JAL doesn't quote filenames and certain other things,
                 so here's a hack for names that start with a number
                 and have a '_' or letter without any intervening spaces
                 will continue until the next space */
              pf_token_ch_append(pf, TOLOWER(ch));
              pf_token_parse_allow(pf, allow_any, PF_TOKEN_PARSE_ALLOW_STORE
                | PF_TOKEN_PARSE_ALLOW_UNGET);
            } else {
              pfile_ch_unget(pf, ch);
            }
          }
        } else {
          switch (ch) {
            case '=':
              ch = pfile_ch_get(pf);
              if ('=' == ch) {
                pf_token_ch_append(pf, ch);
              } else {
                pfile_ch_unget(pf, ch);
              }
              break;
            case '<': /* might be < or <= or <> */
              ch = pfile_ch_get(pf);
              if (('=' == ch) || ('>' == ch) || ('<' == ch)) {
                pf_token_ch_append(pf, ch);
              } else {
                pfile_ch_unget(pf, ch);
              }
              break;
            case '>': /* might be > or >=       */
              ch = pfile_ch_get(pf);
              if (('=' == ch) || ('>' == ch)) {
                pf_token_ch_append(pf, ch);
              } else {
                pfile_ch_unget(pf, ch);
              }
              break;
            case '-': /* might be '--' (skip to eol) */
              ch = pfile_ch_get(pf);
              if ('-' == ch) {
                ch = pf_token_parse_allow(pf, allow_comment, 
                    PF_TOKEN_PARSE_ALLOW_UNGET);
                pf_token_reset(pf);
                pf_token_ch_append(pf, ' ');
              } else {
                pfile_ch_unget(pf, ch);
              }
              break;
            case ';': /* comment, skip to EOL */
              ch = pf_token_parse_allow(pf, allow_comment, 
                  PF_TOKEN_PARSE_ALLOW_UNGET);
              /* the next character must either be EOL or EOF */
              pf_token_reset(pf);
              pf_token_ch_append(pf, ' ');
              break;
            case '!': /* look for != or !! */
              ch = pfile_ch_get(pf);
              if ('=' == ch) {
                pf_token_ch_append(pf, ch);
              } else if ('!' == ch) {
                pf_token_ch_append(pf, ch);
              } else {
                pfile_ch_unget(pf, ch);
              }
              break;
            case '\"': /* string constant, ends at EOL or " */
              {
                enum {
                  ch_type_normal = 0, /* normal processing */
                  ch_type_esc,        /* escape character */
                  ch_type_hex,        /* hex processing   */
                  ch_type_oct,        /* oct processing */
                  ch_type_bin
                } mode;
                char val;     /* value if processing hex or oct */

                val = 0;
                mode = ch_type_normal;

                do {
                  ch = pfile_ch_get(pf);
                  switch (mode) {
                    case ch_type_normal:
                      if ('\\' == ch) {
                        mode = ch_type_esc;
                      } else {
                        if ((EOF != ch) && ('\n' != ch)) {
                          pf_token_ch_append(pf, ch);
                        }
                      }
                      break;
                    case ch_type_esc:
                      mode = ch_type_normal;
                      if (ISOCTDIGIT(ch)) {
                        mode = ch_type_oct;
                        val = (ch - '0');
                      } else {
                        switch (ch) {
                          case 'a': 
                            pf_token_ch_append(pf, '\a'); /* bell */
                            break; 
                          case 'b': 
                            pf_token_ch_append(pf, '\b'); /* bkpc */
                            break;
                          case 'f': 
                            pf_token_ch_append(pf, '\f'); /* ff */
                            break;
                          case 'n': 
                            pf_token_ch_append(pf, '\n'); /* lf */
                            break;
                          case 'r': 
                            pf_token_ch_append(pf, '\r'); /* cr */
                            break;
                          case 't': 
                            pf_token_ch_append(pf, '\t'); /* h.tab */
                            break;
                          case 'v': 
                            pf_token_ch_append(pf, '\v'); /* v.tab */
                            break;
                          case 'x': 
                            mode = ch_type_hex; /* 1 or 2 hex digits */
                            val  = 0;
                            break;
                          case 'z':
                            mode = ch_type_bin; /* 1 - 8 binary digits */
                            val = 0;
                            break;
                          default:
                            if ((EOF != ch) && ('\n' != ch)) {
                              pf_token_ch_append(pf, ch);
                              ch = 0;
                            }
                        }
                      }
                      break;
                      
                    case ch_type_oct:
                      if (ISOCTDIGIT(ch)) {
                        val = val * 8 + (ch - '0');
                      } else {
                        pf_token_ch_append(pf, val & 0xff);
                        mode = ch_type_normal;
                        pfile_ch_unget(pf, ch);
                        ch = 0;
                      }
                      break;
                    case ch_type_hex:
                      if (ISXDIGIT(ch)) {
                        val = val * 16 + (strchr(xdig, TOLOWER(ch)) - xdig);
                      } else {
                        pf_token_ch_append(pf, val & 0xff);
                        mode = ch_type_normal;
                        pfile_ch_unget(pf, ch);
                        ch = 0;
                      }
                      break;
                    case ch_type_bin:
                      if (ISBINDIGIT(ch)) {
                        val = val * 2 + (ch - '0');
                      } else {
                        pf_token_ch_append(pf, val & 0xff);
                        mode = ch_type_normal;
                        pfile_ch_unget(pf, ch);
                        ch = 0;
                      }
                      break;
                  }
                } while ((EOF != ch) && ('\n' != ch) && ('"' != ch));
                if ('"' != ch) {
                  pfile_ch_unget(pf, ch);
                }
              }
              break;
            case '*': /* might be *, *+, *- */
              ch = pfile_ch_get(pf);
              if (('+' == ch) || ('-' == ch)) {
                pf_token_ch_append(pf, ch);
              } else {
                pfile_ch_unget(pf, ch);
              }
              break;
            case '+': /* might be +, +*     */
              ch = pfile_ch_get(pf);
              if ('*' == ch) {
                pf_token_ch_append(pf, ch);
              } else {
                pfile_ch_unget(pf, ch);
              }
              break;
            default: /* don't know what this is, so it must be its own token */
              break;
          }
        }
      } while (ISSPACE(*pf_token_ptr_get(pf)));
      break;
      /* fall through */
    case PF_TOKEN_CURRENT:
      break;
  }
  return pf_token_ptr_get(pf);
}

/*
 * NAME
 *   jal_token_to_constant
 *
 * DESCRIPTION
 *   convert the current token to an unnamed constant
 *
 * PARAMETERS
 *   pf   : returned by pfile_open()
 *   plog : how to log an invalid result
 *   dst  : [out] holds result on success
 *
 * RETURN
 *   0      : no error
 *   EINVAL : current token is not a constant
 *   ERANGE : constant is too large
 *
 * NOTES
 *   [dst] will be *locked* on successful return
 */
value_t jal_token_to_constant(pfile_t *pf, pfile_log_t plog)
{
  int         base;
  const char *ptr;
  value_t     val;
  const char *errstr;

  errstr = 0;
  ptr  = pf_token_get(pf, PF_TOKEN_CURRENT);
  if (ISDIGIT(*ptr)) {
    base = 10;
    if ('0' == *ptr) {
      if ('b' == ptr[1]) {
        base = 2;
        ptr += 2;
      } else if ('q' == ptr[1]) {
        base = 8;
        ptr += 2;
      } else if ('x' == ptr[1]) {
        base = 16;
        ptr += 2;
      }
    }
    if (0 == base) {
      errstr = PFILE_MSG_CONSTANT_EXPECTED;
      val    = VALUE_NONE;
    } else {
      static const char *digits = "0123456789abcdef";
      unsigned long n;
      float         nf;
      const char   *digptr;
      boolean_t     suppress;
      boolean_t     is_float;

      n        = 0;
      nf       = 0.0;
      is_float = BOOLEAN_FALSE;
      suppress = BOOLEAN_FALSE;
      while (('_' == *ptr) || (0 != (digptr = memchr(digits, *ptr, base)))) {
        if ('_' != *ptr) {
          if (!suppress && ((n * base)/base != n)) {
            /*
             * only issue this warning once/constant
             */
            pfile_log(pf, PFILE_LOG_WARN, 
              "constant does not fit in UNIVERSAL");
            suppress = BOOLEAN_TRUE;
          }
          n = n * base + (digptr - digits);
          nf = nf * base + (digptr - digits);
        }
        ptr++;
      }
      if (('.' == *ptr) || ('e' == *ptr)) {
        /* this is a floating point constant */
        float nfrac;

        is_float = BOOLEAN_TRUE;
        nfrac    = 10.0;
        if ('.' == *ptr) {
          ptr++;
          while (isdigit(*ptr)) {
            nf = nf + (*ptr - '0') / nfrac;
            nfrac = nfrac * 10.0;
            ptr++;
          }
        }
        if ('e' == *ptr) {
          float     nexp;
          boolean_t neg_exp;

          nexp    = 0.0;
          neg_exp = BOOLEAN_FALSE;
          ptr++;
          if ('+' == *ptr) {
            ptr++;
          } else if ('-' == *ptr) {
            neg_exp = BOOLEAN_TRUE;
            ptr++;
          }
          while (isdigit(*ptr)) {
            nexp = nexp * 10.0 + (*ptr - '0');
            ptr++;
          }
          if (neg_exp) {
            nexp = -nexp;
          }
          nf = nf * pow(10.0, nexp);
        }
      }

      if (*ptr) {
        errstr = PFILE_MSG_CONSTANT_EXPECTED;
        val    = VALUE_NONE;
      } else {
        variable_def_t def;
        def = VARIABLE_DEF_NONE;
        val = (is_float)
          ? pfile_constant_float_get(pf, nf, def)
          : pfile_constant_get(pf, n, def);
      }
    }
  } else if ('"' == *ptr) {
    variable_def_t  vdef;
    variable_def_t  adef;
    variable_t      var;
    size_t          sz;
    size_t          ii;
    static unsigned cstr_no;
    char            cstr_name[16];
    /*
     * create a constant array of BYTEs
     */
    vdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
      VARIABLE_DEF_FLAG_CONST, 1);
    adef = variable_def_alloc(0, VARIABLE_DEF_TYPE_ARRAY,
      VARIABLE_DEF_FLAG_CONST | VARIABLE_DEF_FLAG_STRING, 0);
    sz = strlen(ptr) - 1;
    if (sz && ('"' == ptr[sz])) {
      sz--;
    }
    variable_def_member_add(adef, 0, vdef, sz);
    sprintf(cstr_name, "_cstr%u", cstr_no);
    cstr_no++;
    if (RESULT_OK != pfile_variable_alloc(pf, PFILE_VARIABLE_ALLOC_GLOBAL, 
      cstr_name, adef, VARIABLE_NONE, &var)) {
      val = VALUE_NONE;
    } else {
      for (ii = 0; ii < sz; ii++) {
        variable_const_set(var, adef, ii, ptr[ii + 1]);
      }
      val = value_alloc(var);
      variable_release(var);
    }
  } else {
    errstr = PFILE_MSG_CONSTANT_EXPECTED;
    val = VALUE_NONE;
  }
  if (errstr) {
    pfile_log(pf, plog, "%s", errstr);
  }
  return val;
}

boolean_t jal_token_is_identifier(pfile_t *pf)
{
  const char *ptr;

  ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
  return ('_' == *ptr) || ISALPHA(*ptr);
}

boolean_t jal_token_is_keyword(pfile_t *pf)
{
  size_t             ii;
  static const char *keywords[] = {
    "var",
    "const",
    "for",
    "if",
    "then",
    "else",
    "elsif",
    "forever",
    "while",
    "asm",
    "assembler",
    "return",
    "procedure",
    "function",
    "task",
    "include",
    "pragma",
    "start",
    "suspend",
    "block",
    "case",
    "end",
    "_usec_delay",
    "otherwise",
    "until"
  };

  for (ii = 0;
      (ii < COUNT(keywords))
      && !pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, keywords[ii]);
      ii++)
    ;
  return (ii < COUNT(keywords))
      ? BOOLEAN_TRUE
      : BOOLEAN_FALSE;
}

void jal_token_is(pfile_t *pf, const char *token)
{
  if (!pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, token)) {
    while (!pf_token_is_eof(pf)
        && !pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_NONE, token))
      ; /* empty loop */
  }
  pf_token_get(pf, PF_TOKEN_NEXT);
}

/* parse to the end of the line */
const char *jal_token_parse_raw(pfile_t *pf)
{
  pf_token_reset(pf);
  pf_token_parse_allow(pf, allow_comment, PF_TOKEN_PARSE_ALLOW_STORE);
  return pf_token_ptr_get(pf);
}

