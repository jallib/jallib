/************************************************************
 **
 ** pf_proc.h : pfile procedure API declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_proc_h__
#define pf_proc_h__

#include "univ.h"
#include "variable.h"
#include "label.h"
#include "pf_block.h"

#define PFILE_PROC_NONE ((pfile_proc_t *) 0)
#define PFILE_PROC_FLAG_INDIRECT     0x0001 /* this is called indirectly        */
#define PFILE_PROC_FLAG_DIRECT       0x0002 /* this is called directly          */
#define PFILE_PROC_FLAG_REENTRANT    0x0004 /* this proc need re-entrant 
                                               handling */
#define PFILE_PROC_FLAG_TASK         0x0008 /* this is a special task 
                                               procedure */
#define PFILE_PROC_FLAG_INTERRUPT    0x0010 /* this is an interrupt entry pt */
#define PFILE_PROC_FLAG_KEEP_PAGE    0x0020 /* keep the PAGE bits */
#define PFILE_PROC_FLAG_KEEP_BANK    0x0040 /* keep the BANK bits */
#define PFILE_PROC_FLAG_CONTEXT_USER 0x0080 /* called by user code */
#define PFILE_PROC_FLAG_CONTEXT_ISR  0x0100 /* called in interrupt context */

#define PFILE_PROC_FLAG_VISITED      0x0200 /* used during re-entrant 
                                               determining */
#define PFILE_PROC_FLAG_INLINE       0x0400 /* inline procedure */
#define PFILE_PROC_FLAG_FRAME        0x0800 /* this procedure's variables
                                               must be put into a single
                                               frame */
#define PFILE_PROC_FLAG_NOSTACK      0x1000 /* execute calls without using
                                               the stack */

/* def is a type function
     its first member is the return definition
     the remaining members are the parameters
     for the definition, the parameter tags are NULL
     during the declaration, the parameter tags are set */  
pfile_proc_t  *pfile_proc_alloc(pfile_proc_t *parent, label_t entry_label,
  label_t skip_lbl, label_t exit_lbl, variable_def_t def);
void           pfile_proc_free(pfile_proc_t *proc, pfile_t *pf);

variable_def_t pfile_proc_def_get(const pfile_proc_t *proc);
variable_def_t pfile_proc_return_def_get(const pfile_proc_t *proc);

size_t         pfile_proc_param_ct_get(const pfile_proc_t *proc);
value_t        pfile_proc_param_get(const pfile_proc_t *proc, size_t n);
void           pfile_proc_param_set(pfile_proc_t *proc, size_t n, value_t val);

result_t       pfile_proc_define(pfile_proc_t *proc, variable_def_t def,
    pfile_t *pf);

pfile_proc_t  *pfile_proc_child_get(const pfile_proc_t *proc);
pfile_proc_t  *pfile_proc_sibbling_get(const pfile_proc_t *proc);
pfile_proc_t  *pfile_proc_parent_get(const pfile_proc_t *proc);

const char    *pfile_proc_tag_get(const pfile_proc_t *proc);

result_t       pfile_proc_variable_def_add(pfile_proc_t *proc, 
    variable_def_t def);
variable_def_t pfile_proc_variable_def_find(pfile_proc_t *proc,
    const char *tag);

result_t       pfile_proc_variable_alloc(pfile_proc_t *proc,
    pfile_variable_alloc_t which,
    tag_t tag, variable_def_t def, variable_t master, pfile_t *pf, 
    variable_t *dst);
variable_t     pfile_proc_variable_find(const pfile_proc_t *proc, 
    const char *name, pfile_block_t **blk);
variable_t     pfile_proc_variable_get_first(const pfile_proc_t *proc);

value_t pfile_proc_value_temp_get(pfile_proc_t *proc, pfile_t *pf,
  variable_def_type_t type, variable_sz_t sz);
value_t  pfile_proc_value_temp_get_from_def(pfile_proc_t *proc, pfile_t *pf,
  variable_def_t def);

result_t pfile_proc_label_alloc(pfile_proc_t *pf, tag_t tag, label_t *dst);
label_t pfile_proc_label_find(const pfile_proc_t *pf, const char *name);

void pfile_proc_param_fixup(pfile_proc_t *proc);
void pfile_proc_variable_fixup(pfile_proc_t *root, pfile_t *pf, flag_t flags);
void pfile_proc_bitchain_fixup(pfile_proc_t *root, pfile_t *pf);
void pfile_proc_label_fixup(pfile_proc_t *root);

label_t pfile_proc_label_get(const pfile_proc_t *proc);
result_t pfile_proc_call_add(pfile_proc_t *proc, pfile_proc_t *dst);

size_t        pfile_proc_calls_ct_get(const pfile_proc_t *proc);
pfile_proc_t *pfile_proc_calls_get(const pfile_proc_t *proc, size_t n);

void          pfile_proc_dump(pfile_proc_t *root, pfile_t *pf, int depth);

pfile_proc_t *pfile_proc_next(const pfile_proc_t *proc);

boolean_t     pfile_proc_flag_test(const pfile_proc_t *proc, flag_t flag);
void          pfile_proc_flag_set(pfile_proc_t *proc, flag_t flag);
void          pfile_proc_flag_clr(pfile_proc_t *proc, flag_t flag);

pfile_block_t *pfile_proc_block_root_get(const pfile_proc_t *proc);
pfile_block_t *pfile_proc_block_active_get(const pfile_proc_t *proc);
void           pfile_proc_block_active_set(pfile_proc_t *proc,
                 pfile_block_t *blk);

result_t       pfile_proc_block_enter(pfile_proc_t *proc);
result_t       pfile_proc_block_leave(pfile_proc_t *proc);

void     pfile_proc_stats_generate(pfile_proc_t *proc);
size_t   pfile_proc_frame_sz_get(const pfile_proc_t *proc);
variable_t pfile_proc_frame_get(const pfile_proc_t *proc);
void       pfile_proc_frame_set(pfile_proc_t *proc, variable_base_t base,
  pfile_t *pf);
unsigned pfile_proc_block_ct_get(const pfile_proc_t *proc);
void     pfile_proc_frame_sz_calc(pfile_proc_t *proc);
unsigned pfile_proc_depth_get(const pfile_proc_t *proc);

/* the skip label is allocated out of the proc's parent and is
   used to skip over the procedure (before the proc_enter has
   executed;
   the exit label is used to quickly exit the proc (aka
   after the proc_enter, but before the proc_leave) */
label_t pfile_proc_exit_label_get(const pfile_proc_t *proc);
label_t pfile_proc_skip_label_get(const pfile_proc_t *proc);
void    pfile_proc_reentrant_test(pfile_proc_t *proc, flag_t flag, 
  unsigned depth);
void    pfile_proc_block_reset(pfile_proc_t *proc);

void       pfile_proc_ret_ptr_alloc(pfile_proc_t *proc, pfile_t *pf);
variable_t pfile_proc_ret_ptr_get(pfile_proc_t *proc);

void       pfile_proc_successor_add(pfile_proc_t *proc, cmd_t cmd);
size_t     pfile_proc_successor_count(const pfile_proc_t *proc);
cmd_t      pfile_proc_successor_get(const pfile_proc_t *proc, size_t ix);
#endif /* pf_proc_h__ */

