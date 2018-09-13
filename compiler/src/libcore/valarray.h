/************************************************************
 **
 ** valarray.h : value array
 **
 ** Copyright (c) 2009, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef valarray_h__
#define valarray_h__

#include "value.h"
#include "../libutils/array.h"

ARRAY_DEF(value_array, value_t)

#ifndef VALUE_ARRAY_NONE
#define VALUE_ARRAY_NONE ((value_array_t *) 0)
#endif

#endif /* value_h__ */


