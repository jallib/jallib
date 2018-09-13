/************************************************************
 **
 ** mem.h : memory debugging declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef mem_h__
#define mem_h__

#include <stdlib.h>

#undef  MEMDEBUG

char *my_strdup(const char *src);
#define STRDUP(x)   my_strdup(x)

#ifdef MEMDEBUG

void *my_malloc(size_t x);
void *my_calloc(size_t x, size_t y);
void  my_free(void *ptr);
void *my_realloc(void *ptr, size_t sz);

#define MALLOC(x)    my_malloc(x)
#define CALLOC(x,y)  my_calloc(x, y)
#define FREE(x)      my_free(x)
#define REALLOC(x,y) my_realloc(x,y)

#else

#include <stdlib.h>

#define MALLOC(x)    malloc(x)
#define CALLOC(x,y)  calloc(x, y)
#define REALLOC(x,y) realloc(x,y)
#define FREE(x)      do { if (x) free(x) ; } while (0)

#endif

#endif /* mem_h__ */

