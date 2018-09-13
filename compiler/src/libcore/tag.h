/************************************************************
 **
 ** tag.h : tag declarations
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef tag_h__
#define tag_h__

#include "../libutils/types.h"

/* if the resulting assembly file is going to be processed by
 * mpasm (or any external assembler), all labels must be uniq.
 * so the option is never allowing two variables in different
 * scope to share a name, or make them unique. This makes them
 * unique by adding 'n' */
typedef struct tag_ *tag_t;

#define TAG_NONE ((tag_t) 0)

tag_t       tag_alloc(const char *name);
void        tag_lock(tag_t tag);
void        tag_release(tag_t tag);

const char *tag_name_get(tag_t tag);
unsigned    tag_n_get(const tag_t tag);
void        tag_n_bump(tag_t tag);
tag_t       tag_link_get(const tag_t tag);
void        tag_link_set(tag_t tag, tag_t link);
refct_t     tag_ref_ct_get(const tag_t tag);

#endif /* tag_h__ */

