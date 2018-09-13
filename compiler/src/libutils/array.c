/************************************************************
 **
 ** array.h : array definitions
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <string.h>

#include "mem.h"
#include "array.h"

struct array_ {
  size_t el_sz;
  size_t alloc;
  size_t used;
  char  *data;
};

array_t *array_alloc(size_t alloc, size_t el_sz)
{
  array_t *array;

  array = MALLOC(sizeof(*array));
  if (array) {
    array->alloc = 0;
    array->used  = 0;
    array->el_sz = el_sz;
    array->data  = 0;
    if (alloc) {
      array->data = MALLOC(el_sz * alloc);
      if (array->data) {
        array->alloc = alloc;
      }
    }
  }
  return array;
}

void array_free(array_t *array)
{
  if (array) {
    FREE(array->data);
    FREE(array);
  }
}

void *array_get(const array_t *array, size_t n)
{
  return (array && (n < array->used))
    ? array->data + n * array->el_sz
    : 0;
}

void *array_set(array_t *array, size_t n, const void *el)
{
  void *data;

  data = (array && (n < array->used))
    ? array->data + n * array->el_sz
    : 0;
  if (data && el) {
    memcpy(array->data + n * array->el_sz, el, array->el_sz);
  }
  return data;
}

void array_swap(array_t *array, size_t ix1, size_t ix2)
{
  if (array && (ix1 < array->used) && (ix2 < array->used)) {
    char  *el1;
    char  *el2;
    size_t ii;

    el1 = array->data + ix1 * array->el_sz;
    el2 = array->data + ix2 * array->el_sz;
    for (ii = 0; ii < array->el_sz; ii++) {
      char ch;

      ch      = el1[ii];
      el1[ii] = el2[ii];
      el2[ii] = ch;
    }
  }
}

void *array_insert(array_t *array, size_t ix, const void *el)
{
  size_t move_sz;

  if (array && (array->used == array->alloc)) {
    void  *tmp;
    size_t alloc;

    alloc = (array->alloc) ? 2 * array->alloc : 32;
    tmp   = REALLOC(array->data, alloc * array->el_sz);
    if (tmp) {
      array->data  = tmp;
      array->alloc = alloc;
    }
  }
  if (array->used < array->alloc) {
    array->used++;
  }
  move_sz = array->el_sz * (array->used - 1 - ix);
  if (move_sz) {
    memmove(array->data + (ix + 1) * array->el_sz,
            array->data + (ix    ) * array->el_sz,
            array->el_sz * (array->used - 1 - ix));
  }
  return array_set(array, ix, el);
}

void *array_append(array_t *array, const void *el)
{
  return array_insert(array, array->used, el);
}

void array_remove(array_t *array, size_t ix)
{
  while (ix + 1 < array->used) {
    (void) array_set(array, ix, array_get(array, ix + 1));
    ix++;
  }
  array->used--;
}

void array_remove_all(array_t *array)
{
  array->used = 0;
}

size_t array_ct(const array_t *array)
{
  return (array) ? array->used : 0;
}

/* search for key in array. on exit, if ix exists it is set to the
 * element index if found, or the next greater element if not.
 */
void *array_search(array_t *array, const void *key, size_t *ix,
  array_element_cmp_t cmp, void *cmp_arg)
{
  size_t    lo;
  size_t    hi;
  void     *el;
  int       rc;

  el = 0; /* shutup compiler warning */
  lo = 0;
  hi = array_ct(array) - 1;
  rc = -1;
  while ((rc != 0) && ((size_t) -1 != hi) && (lo <= hi)) {
    size_t  md;

    md   = lo + (hi - lo) / 2;
    el   = array_get(array, md);
    rc   = cmp(cmp_arg, key, el);

    if (rc < 0) {
      hi = md - 1;
    } else if (0 == rc) {
      lo  = md;
    } else {
      lo = md + 1;
    }
  }
  if (ix) {
    *ix = lo;
  }
  if (rc) {
    el = 0;
  }
  return el;
}

void array_add(array_t *array, const void *el, unsigned flags,
  array_element_cmp_t cmp, void *cmp_arg)
{
  if (0 == array_ct(array)) {
    (void) array_append(array, el);
  } else {
    void   *el2;
    size_t  ix;

    el2 = array_search(array, el, &ix, cmp, cmp_arg);
    if (!el2 || (flags & ARRAY_ADD_FLAG_DUP)) {
      (void) array_insert(array, ix, el);
    }
  }
}

void array_delete(array_t *array, const void *el,
  array_element_cmp_t cmp, void *cmp_arg)
{
  size_t ix;

  if (array_search(array, el, &ix, cmp, cmp_arg)) {
    array_remove(array, ix);
  }
}

