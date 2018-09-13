/************************************************************
 **
 ** pf_block.h : pfile block API definitions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pfblock_h__
#define pfblock_h__

#include "variable.h"
#include "label.h"
#include "univ.h"

typedef struct pfile_block_ pfile_block_t;

#define PFILE_BLOCK_NONE ((pfile_block_t *) 0)

pfile_block_t *pfile_block_alloc(pfile_block_t *parent, 
    pfile_proc_t *owner, cmd_t cmd);
void           pfile_block_free(pfile_block_t *blk, pfile_t *pf);

pfile_block_t *pfile_block_child_get(pfile_block_t *blk);
pfile_block_t *pfile_block_parent_get(pfile_block_t *blk);
pfile_block_t *pfile_block_sibbling_get(pfile_block_t *blk);

pfile_block_t *pfile_block_next(pfile_block_t *blk);

result_t       pfile_block_variable_def_add(pfile_block_t *block, 
    variable_def_t def);
variable_def_t pfile_block_variable_def_find(pfile_block_t *block,
    const char *tag);

result_t       pfile_block_variable_alloc(pfile_block_t *block, 
    tag_t tag, variable_def_t def, variable_t master, pfile_t *pf,
    variable_t *dst);
result_t pfile_block_variable_add(pfile_block_t *blk,
    variable_t var);
variable_t     pfile_block_variable_find(pfile_block_t *block,
    const char *name);
variable_t     pfile_block_variable_get_first(pfile_block_t *block);

result_t pfile_block_label_alloc(pfile_block_t *blk, tag_t tag, 
  label_t *dst);
label_t pfile_block_label_find(pfile_block_t *blk, const char *name);

variable_t     pfile_block_variable_list_head(pfile_block_t *blk);
variable_def_t pfile_block_variable_def_head(pfile_block_t *blk);
label_t        pfile_block_label_list_head(pfile_block_t *blk);

void pfile_block_variable_fixup(pfile_block_t *blk,
  variable_t bitbucket, unsigned bitbucket_inuse, flag_t flags);
void pfile_block_bitchain_fixup(pfile_block_t *blk);

size_t pfile_block_data_sz_calc(pfile_block_t *blk);

void   pfile_block_cmd_set(pfile_block_t *blk, cmd_t cmd);
cmd_t  pfile_block_cmd_get(pfile_block_t *blk);

pfile_proc_t *pfile_block_owner_get(const pfile_block_t *blk);
void          pfile_block_owner_set(pfile_block_t *blk, pfile_proc_t *proc);

ulong  pfile_block_no_get(const pfile_block_t *blk);

#endif /* pfblock_h__ */

