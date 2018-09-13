/************************************************************
 **
 ** array.h : array handling
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef array_h__
#define array_h__

#include <stdlib.h>

typedef struct array_ array_t;
typedef int (*array_element_cmp_t)(void *arg, const void *a, const void *b);

array_t *array_alloc(size_t alloc, size_t el_sz);
void     array_free(array_t *array);
void    *array_get(const array_t *array, size_t n);
void    *array_set(array_t *array, size_t n, const void *el);
void    *array_insert(array_t *array, size_t ix, const void *el);
void    *array_append(array_t *array, const void *el);
void     array_remove(array_t *array, size_t ix);
void     array_remove_all(array_t *array);
size_t   array_ct(const array_t *array);
void     array_swap(array_t *array, size_t ix1, size_t ix2);

#define ARRAY_ADD_FLAG_NONE   0x0000
#define ARRAY_ADD_FLAG_DUP    0x0001 /* allow duplicate elements */
void     array_add(array_t *array, const void *el, unsigned flags,
  array_element_cmp_t cmp, void *cmp_arg);
void    *array_search(array_t *array, const void *key, size_t *ix,
  array_element_cmp_t cmp, void *cmp_arg);
void     array_delete(array_t *array, const void *el,
  array_element_cmp_t cmp, void *cmp_arg);

#endif
/*
 * generate a typesafe array class. `name' is the array name. the
 * accessor functions will be name_*
 * the type will be name_t
 * the array will holds types of element
 */
#undef ARRAY_DEF
#ifdef ARRAY_DEFINE

#define ARRAY_DEF(name, element)                                  \
  typedef array_t name##_t;                                       \
  name##_t *name##_alloc(size_t ct)                               \
    { return (name##_t *) array_alloc(ct, sizeof(element)); }     \
  void name##_free(name##_t *array)                               \
    { array_free((array_t *) array); }                            \
  element *name##_entry_append(name##_t *array, const element *el)\
    { return array_append((array_t *) array, el); }               \
  void *name##_entry_insert(name##_t *array, size_t n,            \
    const element *el)                                            \
    { return array_insert((array_t *) array, n, el); }            \
  void name##_entry_remove(name##_t *array, size_t n)             \
    { array_remove((array_t *) array, n); }                       \
  void name##_entry_remove_all(name##_t *array)                   \
    { array_remove_all((array_t *) array); }                      \
  element *name##_entry_get(const name##_t *array, size_t n)      \
    { return (element *) array_get((const array_t *) array, n); } \
  element *name##_entry_set(name##_t *array, size_t n,            \
    const element *el)                                            \
    { return (element *) array_set((array_t *) array, n, el); }   \
  size_t name##_entry_ct(const name##_t *array)                   \
    { return array_ct(array); }                                   \
  void name##_entry_swap(name##_t *array, size_t ix1, size_t ix2) \
    { array_swap(array, ix1, ix2); }                              \
  void name##_entry_add(name##_t *array, const element *el,       \
    unsigned flags, array_element_cmp_t cmp, void *cmp_arg)       \
    { array_add(array, el, flags, cmp, cmp_arg); }                \
  void *name##_entry_search(name##_t *array, const void *key,     \
    size_t *ix, array_element_cmp_t cmp, void *cmp_arg)           \
    { return (element *) array_search(array, key, ix, cmp,        \
        cmp_arg); }                                               \
  void name##_entry_delete(name##_t *array, const element *el,    \
    array_element_cmp_t cmp, void *cmp_arg)                       \
    { array_delete(array, el, cmp, cmp_arg); }                    \

#undef ARRAY_DEFINE

#else

#define ARRAY_DEF(name, element)                                  \
  typedef array_t name##_t;                                       \
  name##_t *name##_alloc(size_t ct);                              \
  void name##_free(name##_t *array);                              \
  element *name##_entry_append(name##_t *array,                   \
    const element *el);                                           \
  void    *name##_entry_insert(name##_t *array, size_t n,         \
    const element *el);                                           \
  void     name##_entry_remove(name##_t *array, size_t n);        \
  void     name##_entry_remove_all(name##_t *array);              \
  element *name##_entry_get(const name##_t *array, size_t n);     \
  element *name##_entry_set(name##_t *array, size_t n,            \
    const element *el);                                           \
  size_t   name##_entry_ct(const name##_t *array);                \
  void     name##_entry_swap(name##_t *array, size_t ix1,         \
    size_t ix2);                                                  \
  void name##_entry_add(name##_t *array, const element *el,       \
    unsigned flags, array_element_cmp_t cmp, void *cmp_arg);      \
  void *name##_entry_search(name##_t *array, const void *key,     \
    size_t *ix, array_element_cmp_t cmp, void *cmp_arg);          \
  void name##_entry_delete(name##_t *array, const element *el,    \
    array_element_cmp_t cmp, void *cmp_arg);                      \

#endif
