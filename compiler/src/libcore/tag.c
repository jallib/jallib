/************************************************************
 **
 ** tag.h : tag definitons
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <stdlib.h>
#include <string.h>
#include "../libutils/mem.h"
#include "tag.h"

struct tag_ {
  struct tag_ *link;
  refct_t      ref_ct;
  const char  *name;
  unsigned     n;
};

tag_t tag_alloc(const char *name)
{
  tag_t  tag;
  size_t name_sz;

  name_sz = 1 + strlen(name);
  tag = MALLOC(sizeof(*tag) + name_sz);
  if (tag) {
    tag->link = TAG_NONE;
    tag->name = (char *) (tag + 1);
    memcpy(tag+1, name, name_sz);
    tag->n = 0;
    tag->ref_ct = 1;
  }
  return tag;
}

void tag_lock(tag_t tag)
{
  if (tag) {
    tag->ref_ct++;
  }
}

void tag_release(tag_t tag)
{
  if (tag && !--tag->ref_ct) {
    tag_link_set(tag, TAG_NONE);
    FREE(tag);
  }
}

const char *tag_name_get(tag_t tag)
{
  return (tag) ? tag->name : 0;
}

unsigned tag_n_get(const tag_t tag)
{
  return (tag) ? tag->n : 0;
}

void tag_n_bump(tag_t tag)
{
  if (tag) {
    tag->n++;
  }
}

tag_t tag_link_get(const tag_t tag)
{
  return (tag) ? tag->link : 0;
}

void tag_link_set(tag_t tag, tag_t link)
{
  if (tag) {
    tag_lock(link);
    tag_release(tag->link);
    tag->link = link;
  }
}

refct_t tag_ref_ct_get(const tag_t tag)
{
  return (tag) ? tag->ref_ct : 0;
}

