/************************************************************
 **
 ** cmdarray.h : cmdiable array
 **
 ** Copyright (c) 2009, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef cmdarray_h__
#define cmdarray_h__

#include "univ.h"
#include "../libutils/array.h"

ARRAY_DEF(cmd_array, cmd_t)
#undef ARRAY_DEFINE
#ifndef CMD_ARRAY_NONE
#define CMD_ARRAY_NONE ((cmd_array_t *) 0)
#endif

#endif /* cmdarray_h__ */

