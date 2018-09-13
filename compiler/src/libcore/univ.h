/************************************************************
 **
 ** univ.h : universal declarations
 **          these are needed by circular includes; I need to
 **          find a way to restructure such that this file
 **          goes away.
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef univ_h__
#define univ_h__

#include "../libutils/cache.h"

typedef struct pfile_proc_   pfile_proc_t;
typedef struct pfile_        pfile_t;
typedef struct label_       *label_t;
typedef struct cmd_         *cmd_t;
typedef struct pfile_source_ pfile_source_t;
typedef struct pfile_pos_    pfile_pos_t;

typedef enum {
  PFILE_VARIABLE_ALLOC_LOCAL,
  PFILE_VARIABLE_ALLOC_GLOBAL
} pfile_variable_alloc_t;

#endif /* univ_h__ */

