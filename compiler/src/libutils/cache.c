/************************************************************
 **
 ** cache.h : low-memory caching definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <assert.h>
#include <string.h>

#undef CACHE_DEBUG

#include "mem.h"
#include "cache.h"

/* buffer size : maximum size to allocate for the buffer */
/* blocking    : file blocking. file operations are usually more
 *               efficient if a standard block size is used than
 *               if a random one is used. obviously blocking size
 *               must be >= buffer size
 *
 * note: a larger cache is a mixed blessing -- more fits into it,
 *       which is good, but it also takes a lot longer to load
 *       from disk, which isn't so good. 8K seems like a good
 *       compromise.
 */       
#define CACHE_SWAP_BLOCK_SIZE 8*1024UL

typedef struct cache_element_entry_free_ {
  cache_element_t next;
} cache_element_entry_free_t;

/* since gcc doesn't do type checking on like types, and
   all cache elements are the same type, I'll do runtime
   checking here */
typedef struct cache_element_header_ {
  cache_t  *owner;
  boolean_t inuse;
} cache_element_header_t;

/* all cache elements are of the same type, so normal typechecking
 * doesn't catch when an element of type x is passed to a cache of
 * type y. so...the top 8 bits of the cache element are going to
 * be a uniq cache type
 */
static cacheid_t cacheid;

void cache_cleanup(cache_t *cache)
{
#ifdef CACHE_DEBUG
  fprintf(stderr, 
      "cache: %s\n"
      "  %10lu hits\n"
      "  %10lu misses\n"
      "  %10lu allocs (%lu reused)\n"
      "  %10lu frees (%lu leaked)\n"
#ifdef CACHE_LOMEM
      "  %10lu total bytes used\n"
      "  %10lu elements/page\n"
#endif /* CACHE_LOMEM */
      ,
      cache->name,
      cache->stats.hits,
      cache->stats.misses,
      cache->stats.allocs, cache->stats.reused,
      cache->stats.frees,
      cache->stats.allocs - cache->stats.frees
#ifdef CACHE_LOMEM
      ,(unsigned long) ((cache->next - 1) * cache->el_sz),
      (unsigned long) (CACHE_SWAP_BLOCK_SIZE / cache->el_sz)
#endif
  );
#endif
#ifdef CACHE_LOMEM
  if (cache->swap) {
    fclose(cache->swap);
  }
  FREE(cache->buf);
#else
  while (cache->free_lst) {
    cache_element_header_t     *tmp = cache->free_lst;
    cache_element_entry_free_t *next;

    tmp = cache->free_lst;
    next = (void *) (tmp + 1);
    cache->free_lst = next->next;
    FREE(tmp);
  }
#endif
}

#ifdef CACHE_LOMEM
static FILE *cache_tmpfile(void)
{
#if 0
  static unsigned tmpno = 0;
  char            buf[256];

  sprintf(buf, "cache%u.tmp", ++tmpno);
  return fopen(buf, "w+b");
#else
  return tmpfile();
#endif
}
#endif /* CACHE_LOMEM */

/* initialize the cache */
result_t cache_init(cache_t *cache, size_t element_sz, const char *name)
{
  result_t rc;

  rc = RESULT_OK;
  if (!cache->el_sz) {
    cache->cacheid   = ++cacheid;
    cache->name      = name;
    cache->el_sz     = element_sz + sizeof(cache_element_header_t);
    cache->free_lst  = 0;
    cache->stats.hits     = 0;
    cache->stats.misses   = 0;
    cache->stats.allocs   = 0;
    cache->stats.frees    = 0;
    cache->stats.invalids = 0;
    cache->stats.reused   = 0;
#ifdef CACHE_LOMEM
    cache->buf       = 0;
    cache->swap      = 0;
    cache->first     = 0;
    cache->el_ct     = CACHE_SWAP_BLOCK_SIZE / cache->el_sz;
    cache->dirty     = BOOLEAN_FALSE;
    cache->next      = 1;
#endif /* CACHE_LOMEM */
#ifdef CACHE_DEBUG
    fprintf(stderr, "CACHE: %s is %u\n", name, cacheid);
#endif
  } else if (cache->el_sz != element_sz) {
    rc = RESULT_INVALID;
  }
  return rc;
}

#ifdef CACHE_DEBUG
static void cache_element_poison(cache_element_header_t *el, cache_t *cache)
{
  size_t ii;
  char  *ptr;

  ptr = (void *) (el + 1);

  for (ii = 0; ii < cache->el_sz - sizeof(*el); ii++) {
    static const unsigned char ch[] = { 0xde, 0xad, 0xbe, 0xef };

    ptr[ii] = ch[ii % 4];
  }
}
#else
#define cache_element_poison(el, cache)
#endif



#ifdef CACHE_LOMEM
/* this is where the real work is done! make sure el is in the
 * cache, and return a pointer to it
 *   cache : the cache structure
 *   el    : element # to get, 0 returns NULL
 *   mod   : non-zero to mark the buffer dirty */
static cache_element_header_t *cache_element_seek_internal(
    cache_t *cache, cache_element_t el, boolean_t mod)
{
  cache_element_header_t *ptr;

  ptr = 0;
  if (el && (el < cache->next)) {
    if (!cache->buf) {
      cache->buf = MALLOC(CACHE_SWAP_BLOCK_SIZE + 2);
      cache->buf[CACHE_SWAP_BLOCK_SIZE] = (unsigned char) 0xa5;
      cache->buf[CACHE_SWAP_BLOCK_SIZE+1] = 0x5a;
    }
    if (cache->buf) {
      assert((char) 0xa5 == cache->buf[CACHE_SWAP_BLOCK_SIZE]);
      assert(0x5a == cache->buf[CACHE_SWAP_BLOCK_SIZE+1]);
      if ((el < cache->first) || (el >= cache->first + cache->el_ct)) {
        int ct;

        cache->stats.misses++;
        if (cache->dirty) {
          /* flush this */
          if (!cache->swap) {
            cache->swap = cache_tmpfile();
          }
          if (cache->swap) {
            fseek(cache->swap, 
                (cache->first / cache->el_ct) * CACHE_SWAP_BLOCK_SIZE, 
                SEEK_SET);
            fwrite(cache->buf, CACHE_SWAP_BLOCK_SIZE, 1, cache->swap);
          }
          cache->dirty = BOOLEAN_FALSE;
        }
        cache->first = (el / cache->el_ct) * cache->el_ct;
        assert(cache->first <= el);
        assert(el < cache->first + cache->el_ct);
        fseek(cache->swap, 
            (cache->first / cache->el_ct) * CACHE_SWAP_BLOCK_SIZE, 
            SEEK_SET);
        ct = fread(cache->buf, CACHE_SWAP_BLOCK_SIZE, 1, cache->swap);
#ifdef CACHE_DEBUG
        if (0 == ct) {
          memset(cache->buf, 0, CACHE_SWAP_BLOCK_SIZE);
        }
#endif
      } else {
        cache->stats.hits++;
      }
      ptr = (void *) (cache->buf + (el - cache->first) * cache->el_sz);
      if (mod) {
        cache->dirty = mod;
      }
      assert((char) 0xa5 == cache->buf[CACHE_SWAP_BLOCK_SIZE]);
      assert(0x5a == cache->buf[CACHE_SWAP_BLOCK_SIZE+1]);
    }
  } else {
    if (el) {
      cache->stats.invalids++;
    }
  }
  return ptr;
}


/* allocate an element out of the cache */
static unsigned long ctr;

cache_element_t cache_element_alloc(cache_t *cache)
{
  cache_element_t         el;
  cache_element_header_t *hdr;

  ctr++;
  if (cache->free_lst) {
    el  = cache->free_lst;
    hdr = cache_element_seek_internal(cache, el, BOOLEAN_TRUE);
    if (hdr) {
      cache_element_entry_free_t *freelink;

      assert(!hdr->inuse);
      assert(hdr->owner == cache);
      freelink = (void *) (hdr + 1);
      cache->free_lst = freelink->next;
    }
    cache->stats.reused++;
  } else {
    hdr = 0;
    el  = cache->next;
    cache->next++;
  }
  cache->stats.allocs++;
  if (!hdr) {
    hdr = cache_element_seek_internal(cache, el, BOOLEAN_TRUE);
    hdr->owner = cache;
  }
  hdr->inuse = BOOLEAN_TRUE;
  cache_element_poison(hdr, cache);
  el |= (cache->cacheid << 24UL);
  return el;
}

/* this is a no-op. eventually i'll keep a linked-list of 
 * free elements, starting at element 0 */
void cache_element_free(cache_t *cache, cache_element_t el)
{
  cache_element_header_t *hdr;

  if (el) {
    assert((el >> 24UL) == cache->cacheid);
    el &= 0x00ffffff;
    hdr = cache_element_seek_internal(cache, el, BOOLEAN_TRUE);
    if (hdr) {
      cache_element_entry_free_t *freelist;

      assert(hdr->owner == cache);
      assert(hdr->inuse);
      hdr->inuse = BOOLEAN_FALSE;
      cache_element_poison(hdr, cache);
      freelist = (void *) (hdr + 1);

      freelist->next = cache->free_lst;
      cache->free_lst = el;
    }
  }
  cache->stats.frees++;
}

void *cache_element_seek(cache_t *cache, cache_element_t el, boolean_t ismod)
{
  cache_element_header_t *hdr;
  void                   *ptr;

  assert(!el || ((el >> 24UL) == cache->cacheid));
  el &= 0x00ffffff;
  hdr = cache_element_seek_internal(cache, el, ismod);
  if (!hdr) {
    ptr = 0;
  } else {
    ptr = (void *) (hdr + 1);
    assert(hdr->owner == cache);
    assert(hdr->inuse);
  }
  return ptr;
}
#else /* CACHE_LOMEM */

cache_element_t cache_element_alloc(cache_t *cache)
{
  cache_element_header_t *hdr;

  if (cache->free_lst) {
    cache_element_entry_free_t *free_el;

    hdr = cache->free_lst;
    free_el = (void *) (hdr + 1);
    cache->free_lst = free_el->next;
    assert(!hdr->inuse);
    assert(hdr->owner == cache);
    cache->stats.reused++;
  } else {
    hdr = MALLOC(sizeof(*hdr) + cache->el_sz);
    hdr->owner  = cache;
  }
  cache->stats.allocs++;
  hdr->inuse = BOOLEAN_TRUE;
  return hdr + 1;
}

void *cache_element_seek(cache_t *cache, cache_element_t el, boolean_t ismod)
{
  UNUSED(cache);
  UNUSED(ismod);

  return el;
}

void cache_element_free(cache_t *cache, cache_element_t el)
{
  cache_element_header_t     *hdr;

  hdr = (void *) (((char *) el)- sizeof(*hdr));
  assert(hdr->inuse);
  assert(hdr->owner == cache);
  hdr->inuse = BOOLEAN_FALSE;
  cache_element_poison(hdr, cache);

#ifdef CACHE_DEBUG 
  FREE(hdr);
#else
  {
    cache_element_entry_free_t *free_el;

    free_el = (void *) (hdr + 1);
    free_el->next = cache->free_lst;
    cache->free_lst = hdr;
  }
#endif
  cache->stats.frees++;
}

#endif /* CACHE_LOMEM */

