/************************************************************
 **
 ** label.h : label structure declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef label_h__
#define label_h__

#include "../libutils/cache.h"
#include "cmd.h"
#include "tag.h"
#include "value.h"
#include "univ.h"

typedef struct {
  label_t head;
  label_t tail;
} lbllist_t;

#define LABEL_FLAG_NONE    0x0000
#define LABEL_FLAG_DEFINED 0x0001 /* this label has a definition   */
#define LABEL_FLAG_USED    0x0002 /* one external reference exists */
#define LABEL_FLAG_GLOBAL  0x0004 /* this must be global           */
#define LABEL_FLAG_USER    0x0008 /* user defined label            */

#define LABEL_NONE ((label_t ) 0)

label_t label_alloc(tag_t tag);
void label_lock(label_t lbl);
void label_release(label_t lbl);

void label_list_init(lbllist_t *lst);
void label_list_reset(lbllist_t *lst);
unsigned label_list_ct_get(const lbllist_t *lst);

typedef boolean_t (*lblfind_cb_t)(void *arg, const label_t lbl, 
    const void *data);
label_t label_list_find(lbllist_t *lst, lblfind_cb_t fn, void *arg,
  const void *data);
void label_list_append(lbllist_t *lst, label_t lbl);


const char *label_name_get(const label_t lbl);
unsigned    label_tag_n_get(const label_t lbl);
boolean_t   label_flag_test(const label_t lbl, flag_t flag);
void        label_flag_set(label_t lbl,  flag_t flag);

ctr_t       label_usage_get(const label_t lbl);
void        label_usage_bump(label_t lbl, ctr_bump_t chg);

ctr_t       label_ref_ct_get(const label_t lbl);

label_t     label_next_get(label_t lbl);
label_t     label_list_head(const lbllist_t *lst);

unsigned    label_pc_get(label_t lbl);
void        label_pc_set(label_t lbl, unsigned pc);

void        label_remove(lbllist_t *lst, label_t lbl);

label_t     label_link_get(label_t lbl);

void        label_cmd_set(label_t lbl, cmd_t cmd);
cmd_t       label_cmd_get(label_t lbl);

/* this is sloppy on two fronts:
   (1) label shouldn't know anything about pic_code
   (2) i'm going to be storing an unsigned long as a pointer
   although (2) is specifically allowed by the standard, there
   is no guarentee that the results of converting an integer
   to a pointer & back will give meaningful results. On *my*
   computer it does but this should be addressed */
void        label_code_set(label_t lbl, void *);
void       *label_code_get(label_t lbl);

#endif /* label_h__ */

