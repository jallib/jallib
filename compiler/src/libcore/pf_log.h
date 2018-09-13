/************************************************************
 **
 ** pf_log.h : pfile logging declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_log_h__
#define pf_log_h__

/* this is a *really* useful way to make sure the format
   and arguments to a function match */
#ifdef __GNUC__
#define ATTRIBUTE __attribute__ ((__format__ (__printf__, 3, 4)))
#else
#define ATTRIBUTE
#endif

#include "univ.h"

typedef enum pfile_log_ {
  PFILE_LOG_NONE,
  PFILE_LOG_CRIT,
  PFILE_LOG_ERR,
  PFILE_LOG_WARN,
  PFILE_LOG_INFO,
  PFILE_LOG_DEBUG
} pfile_log_t;

void pfile_log(pfile_t *pf, pfile_log_t sev, const char *fmt, ...)
     ATTRIBUTE;
void pfile_log_syserr(pfile_t *pf, result_t rc);

#endif /* pf_log_h__ */

