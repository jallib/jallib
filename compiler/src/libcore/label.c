/**********************************************************
 **
 ** label.c : manipulators for label_t
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include "label.h"
#include "labelmap.h"

struct label_ {
  label_t          link;     /* next element in list      */
  refct_t          ref_ct;

  flag_t           flags;
  unsigned         pc;       /* where this label exists   */
  tag_t            tag;
  unsigned         tag_n;

  ctr_t            usage;    /* # of references           */
  cmd_t            cmd;      /* owning cmd */
  void            *code;     /* for pic code generation   */
};

static cache_t   label_cache;
static boolean_t label_cache_is_init;

static void label_cache_cleanup(void)
{
  cache_cleanup(&label_cache);
}

static label_t label_element_alloc(void)
{
  if (!label_cache_is_init) {
    label_cache_is_init = BOOLEAN_TRUE;
    atexit(label_cache_cleanup);
    (void) cache_init(&label_cache, sizeof(struct label_), "label");
  }
  return cache_element_alloc(&label_cache);
}

static struct label_ *label_element_seek(label_t el, boolean_t mod)
{
  return cache_element_seek(&label_cache, el, mod);
}

/* basic functions */
label_t label_alloc(tag_t tag)
{
  label_t lbl;

  lbl = label_element_alloc();
  if (lbl) {
    struct label_ *ptr;

    ptr = label_element_seek(lbl, BOOLEAN_TRUE);
    ptr->link    = 0;
    ptr->ref_ct  = 1;
    ptr->flags   = 0;
    ptr->pc      = 0;
    ptr->usage   = 0;
    if (tag) {
      tag_lock(tag);
      ptr->tag = tag;
      ptr->tag_n = tag_n_get(tag);
      tag_n_bump(tag);
    } else {
      ptr->tag = TAG_NONE;
      ptr->tag_n = 0;
    }
    ptr->cmd     = CMD_NONE;
    ptr->code    = 0;
  }
  return lbl;
}

void label_release(label_t lbl)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_TRUE);
  if (ptr && !--ptr->ref_ct) {
    tag_release(ptr->tag);
    label_cmd_set(lbl, CMD_NONE);
    cache_element_free(&label_cache, lbl);
  }
}

void label_lock(label_t lbl)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_TRUE);
  if (ptr) {
    ptr->ref_ct++;
  }
}

/* member retrieval */
const char *label_name_get(const label_t lbl)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_FALSE);
  return (ptr) ? tag_name_get(ptr->tag) : 0;
}

unsigned label_tag_n_get(const label_t lbl)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_FALSE);
  return (ptr) ? ptr->tag_n : 0;
}

void label_list_init(lbllist_t *lst)
{
  lst->head = 0;
  lst->tail = 0;
}

static void label_link_set(label_t lbl, label_t link)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_TRUE);
  if (ptr) {
    ptr->link = link;
  }
}

void label_list_append(lbllist_t *lst, label_t lbl)
{
  label_lock(lbl);

  if (lst->tail) {
    label_link_set(lst->tail, lbl);
  } else {
    lst->head = lbl;
  }
  lst->tail = lbl;
}


label_t label_link_get(label_t lbl)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_FALSE);
  return ptr ? ptr->link : 0;
}

label_t label_list_find(lbllist_t *lst, lblfind_cb_t cb, void *cb_arg,
    const void *data)
{
  label_t lbl;

  for (lbl = lst->head;
       lbl && !cb(cb_arg, lbl, data);
       lbl = label_link_get(lbl))
    ;
  if (lbl) {
    label_lock(lbl);
  }
  return lbl;
}

refct_t label_refct_get(const label_t lbl)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_FALSE);
  return (ptr) ? ptr->ref_ct : 0;
}

void label_list_reset(lbllist_t *lst)
{
  while (lst->head) {
    label_t        lbl;

    lbl = lst->head;
    if (label_refct_get(lbl) > 1) {
      fprintf(stderr, "label leak: 0x%lx %s\n", 
        (ulong) lbl, label_name_get(lbl));
    }
    lst->head = label_link_get(lbl);
    if (!lst->head) {
      lst->tail = lst->head;
    }
    label_release(lbl);
  }
}

void label_dump(const label_t lbl, FILE *out)
{
  fprintf(out, "%s", label_name_get(lbl));
}

label_t label_list_head(const lbllist_t *lst)
{
  return lst->head;
}

label_t label_next_get(label_t lbl)
{
  return label_link_get(lbl);
}

ctr_t label_usage_get(const label_t lbl)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_FALSE);
  return (ptr) ? ptr->usage : 0;
}

void label_usage_bump(label_t lbl, ctr_bump_t chg)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_TRUE);
  if (ptr) {
    switch (chg) { 
      case CTR_BUMP_INCR: 
        ++ptr->usage; 
        break;
      case CTR_BUMP_DECR: 
        if (ptr->usage) {
          --ptr->usage; 
        }
        break;
    }
  }
}

unsigned label_pc_get(label_t lbl)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_FALSE);
  return (ptr) ? ptr->pc : 0;
}

void label_pc_set(label_t lbl, unsigned pc)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_TRUE);
  if (ptr) {
    ptr->pc = pc;
  }
}

ctr_t label_ref_ct_get(const label_t lbl)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_FALSE);
  return (ptr) ? ptr->ref_ct : 0;
}

boolean_t label_flag_test(const label_t lbl, flag_t flag)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_FALSE);
  return (ptr) ? ((ptr->flags & flag) == flag): 0;
}

void label_flag_set(label_t lbl,  flag_t flag)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags |= flag;
  }
}

void label_remove(lbllist_t *lst, label_t lbl)
{
  if (lbl == lst->head) {
    lst->head = label_next_get(lbl);
    if (!lst->head) {
      lst->tail = 0;
    }
  } else {
    label_t el, pv;

    for (pv = 0, el = lst->head; 
         el && el != lbl; 
         pv = el, el = label_next_get(el))
      ;
    if (el) {
      label_t next;

      next = label_next_get(el);
      if (pv) {
        label_link_set(pv, next);
      } else {
        lst->head = next;
      }
      if (el == lst->tail) {
        lst->tail = next;
      }
      label_release(lbl);
    }
  }
}

void label_cmd_set(label_t lbl, cmd_t cmd)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_TRUE);
  if (ptr) {
    ptr->cmd = cmd;
  }
}

cmd_t label_cmd_get(label_t lbl)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_FALSE);
  return (ptr) ? ptr->cmd : CMD_NONE;
}

void label_code_set(label_t lbl, void *code)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_TRUE);
  if (ptr) {
    ptr->code = code;
  }
}

void *label_code_get(label_t lbl)
{
  struct label_ *ptr;

  ptr = label_element_seek(lbl, BOOLEAN_FALSE);
  return (ptr) ? ptr->code : 0;
}

label_t label_map_find(const label_map_t *map, label_t lbl)
{
  label_t ret;

  if (!lbl) {
    ret = lbl;
  } else {
    size_t ii;

    for (ii = 0; (ii < map->used) && (map->map[ii].old != lbl); ii++)
      ;
    ret = (ii < map->used) ? map->map[ii].new : LABEL_NONE;
  }
#if 0
  if (ret) {
    printf("label remap %s:%u --> %s:%u\n",
        label_name_get(lbl), label_tag_n_get(lbl),
        label_name_get(ret), label_tag_n_get(lbl));
  }
#endif
  return ret;
}

