/************************************************************
 **
 ** pf_blckd.h : pfile block definition
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_blckd_h__
#define pf_blckd_h__

#include "pf_block.h"

struct pfile_block_ {
  struct pfile_block_ *parent;
  struct pfile_block_ *child;
  struct pfile_block_ *sibbling;

  struct pfile_proc_  *owner;

  ulong          block_no;

  variable_def_t var_defs;
  varlist_t      var_active;
  lbllist_t      label_user;

  variable_t     bit_bucket;
  unsigned       bit_pos;

  cmd_t          cmd;         /* 1st command in the block */
};
  
#endif /* pf_blckd_h__ */

