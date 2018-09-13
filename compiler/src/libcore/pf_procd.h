/************************************************************
 **
 ** pf_procd.h : pfile procedure declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_procd_h__
#define pf_procd_h__

#include "pf_proc.h"
#include "pf_proca.h"
#include "cmdarray.h"
/* note: a procedure is simply something callable with
         an entry & exit point. it also contains its own
         local types and variables.
         when searching for definitions, a proc can see
         only itself and its parents.
         eventually pfile_proc_ should probably hold its
         own command list to facilitate inlining */
struct pfile_proc_ {
  struct pfile_proc_ *parent;
  struct pfile_proc_ *sibbling;
  struct pfile_proc_ *child;

  flag_t              flags;
  ctr_t               entered;
  label_t             label;        /* 0 for root proc */
  label_t             skip_label;
  label_t             exit_label;

  variable_t          temp;         /* procedure-wide temporary    */
  variable_t          btemp;        /* procedure-wide boolean temp */

  pfile_block_t      *block_root;   /* root block      */
  pfile_block_t      *block_active; /* active block    */
  unsigned            block_ct;     /* # of blocks     */

  variable_def_t      def;

  size_t              param_ct;
  value_t            *params;

  pfile_proc_array_t *calls;
  cmd_array_t        *successors;

  size_t              frame_sz; /* # of bytes needed for the frame */
  variable_t          frame;    /* the frame variable */
  unsigned            depth;    /* maximum depth at which we're called;
                                   -1 = recursive */
  variable_t          ret_ptr;  /* for no stack, this holds a pointer
                                   to the return label */
  const char         *name;
};


#endif /* pf_procd_h__ */


