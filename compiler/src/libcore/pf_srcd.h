/************************************************************
 **
 ** pf_srcd.h : pfile source definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_srcd_h__
#define pf_srcd_h__

#include <stdio.h>
#include "../libutils/types.h"

/* this holds the state of the source file. useful for
 * include and such
 */ 
struct pfile_source_ {
  struct pfile_source_ *link;
  refct_t               ref_ct;  /* # of references */
  const char           *name;
  FILE                 *f;
  int                   ch_last;
  int                   ch_unget;
  unsigned              line_no;
  unsigned              file_no; /* file # (used by the COD generator) */
};

#endif /* pf_srcd_h__*/

