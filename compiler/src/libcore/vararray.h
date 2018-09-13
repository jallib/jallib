/************************************************************
 **
 ** vararray.h : variable array
 **
 ** Copyright (c) 2008, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef vararray_h__
#define vararray_h__

#include "variable.h"
#include "../libutils/array.h"

ARRAY_DEF(variable_array, variable_t)

#ifndef VARIABLE_ARRAY_NONE
#define VARIABLE_ARRAY_NONE ((variable_array_t *) 0)
#endif

#endif /* vararray_h__ */

