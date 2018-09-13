/************************************************************
 **
 ** labelmap.h : label map handling declarations
 **
 ** Copyright (c) 2006, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef labelmap_h__
#define labelmap_h__

#include "univ.h"

typedef struct {
  size_t   used;
  size_t   alloc;
  struct {
    label_t old;
    label_t new;
  } *map;
} label_map_t;

label_t label_map_find(const label_map_t *map, label_t lbl);

#endif /* labelmap_h__ */

