/************************************************************
 **
 ** pf_block.c : pfile block declarations
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <string.h>
#include "../libutils/mem.h"
#include "pfile.h"
#include "pf_proc.h"
#include "pf_blckd.h"

/*
 * this is needed due to the peculiarity of pseudo-variables
 * when a variable is found, it must all come from the same
 * block. Say someone creates a variable, x, at block 5. In
 * some derived block (say, 10) he x'put is created. This
 * must completely block the original x.
 *    So...when searching out each of the five possible x's
 * (variable x, x'get, x'put, internal x'get, internal x'put)
 * only the ones from the newest block will be kept.
 */
static ulong block_ct;

pfile_block_t *pfile_block_alloc(pfile_block_t *parent, 
    pfile_proc_t *owner, cmd_t cmd)
{
  pfile_block_t *blk;

  blk = MALLOC(sizeof(*blk));
  if (blk) {
    blk->parent   = parent;
    blk->child    = 0;
    blk->sibbling = 0;
    blk->owner    = owner;
    blk->block_no = ++block_ct;
    if (parent) {
      pfile_block_t *ptr;

      for (ptr = parent->child; ptr && ptr->sibbling; ptr = ptr->sibbling)
        ; /* null body */
      if (ptr) {
        ptr->sibbling = blk;
      } else {
        parent->child = blk;
      }
    }
    blk->var_defs = 0;
    variable_list_init(&blk->var_active);
    label_list_init(&blk->label_user);

    blk->bit_bucket = VARIABLE_NONE;
    blk->bit_pos    = 0;

    blk->cmd        = cmd;
  }
  return blk;
}

void pfile_block_free(pfile_block_t *blk, pfile_t *pf)
{
  while (blk->child) {
    pfile_block_t *child;

    child = blk->child;
    blk->child = child->sibbling;
    pfile_block_free(child, pf);
  }
  label_list_reset(&blk->label_user);
  variable_release(blk->bit_bucket);
  variable_list_reset(&blk->var_active);
  while (blk->var_defs) {
    variable_def_t def;

    def = blk->var_defs;
    blk->var_defs = variable_def_link_get(def);
    variable_def_free(def);
  }
  FREE(blk);
}

pfile_block_t *pfile_block_child_get(pfile_block_t *blk)
{
  return blk->child;
}

pfile_block_t *pfile_block_parent_get(pfile_block_t *blk)
{
  return blk->parent;
}

pfile_block_t *pfile_block_sibbling_get(pfile_block_t *blk)
{
  return blk->sibbling;
}

result_t pfile_block_variable_def_add(pfile_block_t *blk, variable_def_t def)
{
  result_t rc;

  if (pfile_block_variable_def_find(blk, variable_def_tag_get(def))) {
    rc = RESULT_EXISTS;
  } else {
    rc = RESULT_OK;
    variable_def_link_set(def, blk->var_defs);
    blk->var_defs = def;
  }
  return rc;
}

variable_def_t pfile_block_variable_def_find(pfile_block_t *blk, const char *tag)
{
  variable_def_t def;

  for (def = blk->var_defs; 
       def && strcmp(tag, variable_def_tag_get(def));
       def = variable_def_link_get(def))
    ; /* null body */
  return def;
}

result_t pfile_block_variable_add(pfile_block_t *blk,
    variable_t var)
{
  variable_list_append(&blk->var_active, var);
  return RESULT_OK;

}

result_t pfile_block_variable_alloc(pfile_block_t *blk, tag_t tag,
    variable_def_t def, variable_t master, pfile_t *pf, variable_t *dst)
{
  result_t   rc;
  variable_t var;

  UNUSED(pf);

  var = (tag) 
        ? pfile_block_variable_find(blk, tag_name_get(tag)) 
        : VARIABLE_NONE;
  if (var) {
    rc = RESULT_EXISTS;
    variable_release(var);
  } else {
    var = variable_alloc(tag, def);
    if (!var) {
      rc = RESULT_MEMORY;
    } else {
      rc = RESULT_OK;
      variable_user_data_set(var, blk);
      if (tag) {
        variable_list_append(&blk->var_active, var);
      }
      if (master) {
        variable_master_set(var, master);
      }
      if (dst) {
        *dst = var;
      } else {
        variable_release(var);
      }
    }
  }
  return rc;
}

static boolean_t varname_cb(void *arg, const variable_t var, const void *data)
{
  const char *name;

  UNUSED(arg);

  name = variable_name_get(var);
  return name && !strcmp(name, data);
}

variable_t pfile_block_variable_find(pfile_block_t *blk, const char *name)
{
  variable_t var;

  if (!name) {
    var = VARIABLE_NONE;
  } else {
    var = variable_list_find(&blk->var_active, varname_cb, 0, name);
    while (var && variable_is_alias(var)) {
      variable_t master;

      master = variable_master_get(var);
      variable_lock(master);
      variable_release(var);
      var = master;
    }
  }
  return var;
}

variable_t pfile_block_variable_get_first(pfile_block_t *block)
{
  return variable_list_head(&block->var_active);
}

result_t pfile_block_label_alloc(pfile_block_t *blk, tag_t tag, 
  label_t *dst)
{
  label_t  lbl;
  result_t rc;

  lbl = pfile_block_label_find(blk, tag_name_get(tag));
  if (lbl) {
    rc = RESULT_EXISTS;
  } else {
    lbl = label_alloc(tag);
    if (!lbl) {
      rc = RESULT_MEMORY;
    } else {
      rc = RESULT_OK;
      label_list_append(&blk->label_user, lbl);
      if (dst) {
        *dst = lbl;
      } else {
        label_release(lbl);
      }
    }
  }
  return rc;
}

/* unlike variables & variable definitions, labels are only local
 * to the current proc */
static boolean_t lblname_cb(void *arg, const label_t lbl, const void *data)
{
  const char   *name;

  UNUSED(arg);

  name = label_name_get(lbl);
  return (0 == strcmp(name, data));
}

label_t pfile_block_label_find(pfile_block_t *blk, const char *name)
{
  return label_list_find(&blk->label_user, lblname_cb, 0, name);
}

pfile_block_t *pfile_block_next(pfile_block_t *blk)
{
  if (blk->child) {
    blk = blk->child;
  } else if (blk->sibbling) {
    blk = blk->sibbling;
  } else {
    while (blk && !blk->sibbling) {
      blk = blk->parent;
    }
    if (blk) {
      blk = blk->sibbling;
    }
  }
  return blk;
}

variable_t pfile_block_variable_list_head(pfile_block_t *blk)
{
  return variable_list_head(&blk->var_active);
}

variable_def_t pfile_block_variable_def_head(pfile_block_t *blk)
{
  return blk->var_defs;
}

label_t pfile_block_label_list_head(pfile_block_t *blk)
{
  return label_list_head(&blk->label_user);
}


/*
 * NAME
 *   pfile_block_variable_fixup
 *
 * DESCRIPTION
 *   assign all bits locations in the procedure's bitbucket
 *
 * PARAMETERS
 *   blk             : 
 *   bitbucket       :
 *   bitbucket_inuse : # of bits in the bit bucket currently in use
 *
 * RETURN
 *   none
 *
 * NOTES
 *   this recurses through all child blocks
 */
void pfile_block_variable_fixup(pfile_block_t *blk,
  variable_t bitbucket, unsigned bitbucket_inuse, flag_t flags)
{
  variable_t vptr;

  for (vptr = variable_list_head(&blk->var_active);
       vptr;
       vptr = variable_link_get(vptr)) {
    if (!variable_is_const(vptr)
        && (VARIABLE_BASE_UNKNOWN == variable_base_get(vptr, 0))
        && !variable_master_get(vptr)) {
      /* this variable either needs to be marked CONST or AUTO */
      if (((flags & PFILE_FLAG_OPT_VARIABLE_REDUCE)
          && ((variable_is_volatile(vptr)
          && (variable_is_assigned(vptr) || variable_is_used(vptr)))
          || (variable_is_assigned(vptr) && variable_is_used(vptr))))
          || (!(flags & PFILE_FLAG_OPT_VARIABLE_REDUCE) 
            && variable_sz_get(vptr))) {
        /* if it's volatile *or* both assigned & used then it's auto */
        if (variable_dflag_test(vptr, VARIABLE_DEF_FLAG_BIT)) {
          /* bits go into the great bit bucket! */
          variable_sz_t sz;

          variable_master_set(vptr, bitbucket);
          variable_bit_offset_set(vptr, bitbucket_inuse);
          bitbucket_inuse += variable_sz_get(vptr);
          sz = (variable_sz_t) ((bitbucket_inuse + 7) / 8);
          if (sz > variable_sz_get(bitbucket)) {
            /* adjust change the bitbucket size */
            variable_def_t def;

            def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
              VARIABLE_DEF_FLAG_NONE, sz);
            variable_def_set(bitbucket, def);
            variable_assign_ct_bump(bitbucket, CTR_BUMP_INCR);
            variable_use_ct_bump(bitbucket, CTR_BUMP_INCR);
            variable_flag_set(bitbucket, VARIABLE_FLAG_AUTO);
          }
        } else {
          variable_flag_set(vptr, VARIABLE_FLAG_AUTO);
        } 
      } else {
        /* it's neither volatile or assigned & used */
        variable_def_t def;

        def = variable_def_get(vptr);
#if 0
        if (variable_is_array(vptr)) {
          def = variable_def_member_def_get(variable_def_member_get(def));
        }
#endif
        def = variable_def_alloc(0, variable_def_type_get(def),
          variable_def_flags_get_all(def) | VARIABLE_DEF_FLAG_CONST,
          variable_def_sz_get(def));
        variable_def_set(vptr, def);
      }
    }
  }
  for (blk = pfile_block_child_get(blk);
       blk;
       blk = pfile_block_sibbling_get(blk)) {
    pfile_block_variable_fixup(blk, bitbucket, bitbucket_inuse, flags);
  }
}

void pfile_block_bitchain_fixup(pfile_block_t *blk)
{
  variable_t vptr;

  for (vptr = variable_list_head(&blk->var_active);
       vptr;
       vptr = variable_link_get(vptr)) {
    if (!variable_is_const(vptr)
        && variable_is_bit(vptr)) {
      variable_t master;
      unsigned   bit_ofs;

      master  = variable_master_get(vptr);
      bit_ofs = variable_bit_offset_get(vptr);
      while (variable_is_bit(master)) {
        bit_ofs += variable_bit_offset_get(master);
        master = variable_master_get(master);
      }
      variable_bit_offset_set(vptr, bit_ofs);
      variable_master_set(vptr, master);
    }
  }
  for (blk = pfile_block_child_get(blk);
       blk;
       blk = pfile_block_sibbling_get(blk)) {
    pfile_block_bitchain_fixup(blk);
  }
}

/*
 * NAME
 *   pfile_block_data_sz_calc
 *
 * DESCRIPTION
 *   calculate the amount of space needed for all data in a block
 *   also mark all automatic variables automatic
 *
 * PARAMETERS
 *   proc : procedure
 *
 * RETURN
 *   none
 *
 * NOTES
 *   an automatic variable has the following features:
 *      * is not constant
 *      * has a sz > 0
 *      * has no master
 *      * hasn't already been set
 *      * is either volatile or has been both assigned & used
 */
size_t pfile_block_data_sz_calc(pfile_block_t *blk)
{
  variable_t vptr;
  size_t     sz_total;
  size_t     sz_max;

  /* first get our size */
  for (vptr = pfile_block_variable_list_head(blk), sz_total = 0;
       vptr;
       vptr = variable_link_get(vptr)) {
    if (variable_is_auto(vptr)) {
      sz_total += variable_sz_get(vptr);
    }
  }
  /* find the largest child block */
  for (blk = pfile_block_child_get(blk), sz_max = 0;
       blk;
       blk = pfile_block_sibbling_get(blk)) {
    size_t sz;

    sz = pfile_block_data_sz_calc(blk);
    if (sz > sz_max) {
      sz_max = sz;
    }
  }
  return sz_total + sz_max;
}

void pfile_block_cmd_set(pfile_block_t *blk, cmd_t cmd)
{
  if (blk) {
    blk->cmd = cmd;
  }
}

cmd_t  pfile_block_cmd_get(pfile_block_t *blk)
{
  return (blk) ? blk->cmd : CMD_NONE;
}

pfile_proc_t *pfile_block_owner_get(const pfile_block_t *blk)
{
  return (blk) ? blk->owner : PFILE_PROC_NONE;
}

void pfile_block_owner_set(pfile_block_t *blk, pfile_proc_t *proc)
{
  if (blk) {
    blk->owner = proc;
  }
}

ulong  pfile_block_no_get(const pfile_block_t *blk)
{
  return (blk) ? blk->block_no : 0;
}

