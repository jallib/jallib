/************************************************************
 **
 ** cache.h : low-memory caching declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef cache_h__
#define cache_h__

#include <stdio.h>
#include <stdlib.h>

#include "types.h"

/*
 * define CACHE_LOMEM uses several swap files instead of allocating the
 * memory locally. The current swap file buffer is 8K and there are five
 * so total memory usage is 40K + misc. When the swap files are not in
 * use the total memory can easily exceed 1M
 */
#undef CACHE_LOMEM

/* this could be allocated, but why waste the overhead? */
typedef unsigned char cacheid_t;
#ifdef CACHE_LOMEM
typedef unsigned long cache_element_t;
#else
typedef void *cache_element_t;
#endif

typedef struct cache_ {
  cacheid_t       cacheid;
  const char     *name;
  size_t          el_sz;    /* # bytes/element                       */
  cache_element_t free_lst; /* first entry on the free list          */
  struct {
    unsigned long hits;
    unsigned long misses;
    unsigned long allocs;
    unsigned long frees;
    unsigned long invalids;
    unsigned long reused;
  } stats;
#ifdef CACHE_LOMEM
  size_t          el_ct;    /* # of elements in the cache            */
  cache_element_t first;    /* first element ID in the cache         */
  boolean_t       dirty;    /* TRUE if the cache needs to be flushed */
  cache_element_t next;     /* next available for allocating         */
  char           *buf;      /* the allocated cache                   */
  FILE           *swap;     /* the swap file if needed               */
#endif /* CACHE_LOMEM */
} cache_t;

result_t        cache_init(cache_t *cache, size_t element_sz, const char *name);
void            cache_cleanup(cache_t *cache);
cache_element_t cache_element_alloc(cache_t *cache);
void            cache_element_free(cache_t *cache, cache_element_t el);
void           *cache_element_seek(cache_t *cache, cache_element_t el, 
                    boolean_t mod);
#endif /* cache_h__ */

