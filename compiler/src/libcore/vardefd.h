/************************************************************
 **
 ** vardefd.h : variable definition definitions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef vardefd_h__
#define vardefd_h__

#include <stdlib.h>
#include "vardef.h"

struct variable_def_member_ {
  variable_def_member_t link;
  const char           *tag;
  variable_ct_t         ct;
  variable_def_t        def;
};

struct variable_def_ {
  struct {
    variable_def_t prev;
    variable_def_t next;
  } ugly_hack;
  variable_def_t        link;
  const char           *tag;
  variable_def_type_t   type;
  flag_t                flags;
  variable_sz_t         sz;
  variable_def_member_t members;
};

#endif /* vardefd_h__ */

