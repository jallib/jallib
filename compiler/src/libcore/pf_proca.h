/************************************************************
 **
 ** pf_proca.h : pfile procedure array
 **
 ** Copyright (c) 2008, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_proca_h__
#define pf_proca_h__

#include "../libutils/array.h"

ARRAY_DEF(pfile_proc_array, struct pfile_proc_ *)

#define PFILE_PROC_ARRAY_NONE ((pfile_proc_array_t *) 0)

#endif /* pf_proca_h__ */

