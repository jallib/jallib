/************************************************************
 **
 ** pf_proc.c : pfile procedure definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <string.h>
#include <errno.h>
#include <assert.h>
#include "../libutils/mem.h"
#include "pfile.h"
#include "pf_proc.h"
#include "pf_procd.h"
#include "cmdarray.h"

pfile_proc_t  *pfile_proc_alloc(pfile_proc_t *parent, label_t entry_label,
  label_t skip_lbl, label_t exit_lbl, variable_def_t def)
{
  pfile_proc_t *proc;

  proc = MALLOC(sizeof(*proc));
  if (proc) {
    size_t                ii;
    variable_def_member_t mbr;

    proc->parent = parent;
    if (parent) {
      proc->sibbling = parent->child;
      parent->child = proc;
    } else {
      proc->sibbling = 0;
    }
    proc->child = 0;

    proc->label      = entry_label;
    proc->skip_label = skip_lbl;
    proc->exit_label = exit_lbl;
    proc->temp       = VARIABLE_NONE;
    proc->btemp      = VARIABLE_NONE;
    proc->flags      = 0;
    proc->entered    = 0;

    proc->block_root   = pfile_block_alloc(PFILE_BLOCK_NONE, proc, CMD_NONE);
    proc->block_active = 0;
    proc->block_ct     = 0;

    proc->def      = def;
    for (ii = 0, mbr = variable_def_member_get(def);
         mbr;
         ii++, mbr = variable_def_member_link_get(mbr))
      ; /* null body */
    proc->param_ct = ii;
    proc->params   = 0;

    proc->calls    = pfile_proc_array_alloc(0);

    proc->frame    = VARIABLE_NONE;
    proc->frame_sz = 0;
    proc->depth    = 0;

    proc->ret_ptr  = VARIABLE_NONE;

    proc->name       = label_name_get(entry_label);
    proc->successors = CMD_ARRAY_NONE;
  }
  return proc;
}

void pfile_proc_free(pfile_proc_t *proc, pfile_t *pf)
{
  /* get rid of all children */
  while (proc->child) {
    pfile_proc_t *child;

    child = proc->child;
    proc->child = child->sibbling;
    pfile_proc_free(child, pf);
  }
  /* free up the lists */
  cmd_array_free(proc->successors);
  label_release(proc->label);
  label_release(proc->exit_label);
  label_release(proc->skip_label);
  FREE(proc->calls);
  variable_release(proc->temp);
  variable_release(proc->btemp);
  variable_release(proc->ret_ptr);
  variable_release(proc->frame);
  if (proc->params) {
    size_t ii;

    for (ii = 0; ii < proc->param_ct; ii++) {
      value_release(proc->params[ii]);
    }
    FREE(proc->params);
  }
  pfile_block_free(proc->block_root, pf);
  FREE(proc);
}


/*
 * NAME
 *   pfile_proc_params_define
 *
 * DESCRIPTION
 *   Move the variables out of the params into the block variable
 *   list.
 *
 * PARAMETERS
 *   proc   : procedure handle
 *   params : parameters to use
 *
 * RETURN
 *   none
 *
 * NOTES
 *   this is required to allow the declaration of a function
 *     outside its definition
 *   it must be called after the block has been initialized
 */
result_t pfile_proc_define(pfile_proc_t *proc, variable_def_t def, pfile_t *pf)
{
  result_t rc;

  UNUSED(def);

  if (proc->params) {
    rc = RESULT_EXISTS;
  } else {
    rc = RESULT_OK;

    proc->params = MALLOC(sizeof(*proc->params) * proc->param_ct);
    if (!proc->params) {
      rc = RESULT_MEMORY;
    } else {
      variable_def_member_t mbr;
      size_t                ii;

      for (ii = 0, mbr = variable_def_member_get(proc->def);
           mbr;
           ii++, mbr = variable_def_member_link_get(mbr)) {
        variable_t var;

        if (variable_def_member_def_get(mbr)) {
          var = VARIABLE_NONE;
          if (variable_def_member_tag_get(mbr)) {
            (void) pfile_block_variable_alloc(proc->block_root,
              pfile_tag_alloc(pf, variable_def_member_tag_get(mbr)),
              variable_def_member_def_get(mbr),
              VARIABLE_NONE, /* no master */
              pf,
              &var);
          }
          proc->params[ii] = value_alloc(var);
          if (!var) {
            value_def_set(proc->params[ii], variable_def_member_def_get(mbr));
          }
          variable_release(var);
        } else {
          proc->params[ii] = VALUE_NONE;
        }
      }
    }
  }
  return rc;
}

const char *pfile_proc_tag_get(const pfile_proc_t *proc)
{
  return (proc) ? label_name_get(proc->label) : 0;
}

result_t pfile_proc_variable_def_add(pfile_proc_t *proc, 
    variable_def_t def)
{
  return pfile_block_variable_def_add(proc->block_active, def);
}

/* level = recursion level. 0 = found in proc, 1 = found in
 *         proc->parent, ... */
variable_def_t pfile_proc_variable_def_find(pfile_proc_t *proc,
    const char *tag)
{
  pfile_block_t *blk;
  variable_def_t def;

  for (def = 0, blk = proc->block_active;
       blk && !def;
       blk = pfile_block_parent_get(blk)) {
    def = pfile_block_variable_def_find(blk, tag); 
  }
  return def;
}

result_t pfile_proc_variable_alloc(pfile_proc_t *proc, 
    pfile_variable_alloc_t which, tag_t tag,
      variable_def_t def, variable_t master, pfile_t *pf, 
      variable_t *dst)
{
  result_t rc;

  rc = pfile_block_variable_alloc(
    (PFILE_VARIABLE_ALLOC_GLOBAL == which)
    ? proc->block_root : proc->block_active,
    tag, def, master, pf, dst);
  return rc;
}

variable_t  pfile_proc_variable_find(const pfile_proc_t *proc, 
    const char *name, pfile_block_t **pblk)
{
  pfile_block_t *blk;
  variable_t     var;

  for (var = 0, 
       blk = proc->block_active ? proc->block_active : proc->block_root;
       blk && !var;
       blk = pfile_block_parent_get(blk)) {
    var = pfile_block_variable_find(blk, name);
    if (var && pblk) {
      *pblk = blk;
    }
  }
  return var;
}

variable_t pfile_proc_variable_get_first(const pfile_proc_t *proc)
{
  return pfile_block_variable_get_first(proc->block_root);
}

result_t pfile_proc_label_alloc(pfile_proc_t *proc, tag_t tag, 
  label_t *dst)
{
  return pfile_block_label_alloc(proc->block_active, tag, dst);
}

label_t pfile_proc_label_find(const pfile_proc_t *proc, const char *name)
{
  label_t lbl;
  pfile_block_t *blk;

  blk = pfile_proc_block_active_get(proc);
  lbl = 0;
  while (blk && !lbl) {
    lbl = pfile_block_label_find(blk, name);
    blk = pfile_block_parent_get(blk);
  }
  return lbl;
}


/* new temporary handling (12/04):
 *   there will be *one* temporary block per proc name _temp
 *   the size will be determined during the cmd optimization phase
 *   all temporary variables will simply be aliased to it, having only
 *   their offsets changed as necessary
 */   
static value_t pfile_proc_value_temp_boolean_get(pfile_proc_t *proc, 
    pfile_t *pf)
{
  value_t val;

  val = VALUE_NONE;
  if (!proc->btemp) {
    pfile_block_t *blk_temp;
    variable_def_t mdef;

    mdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
        VARIABLE_DEF_FLAG_BIT, 0);
    /* the temporary area is always allocated in the root block */
    blk_temp = proc->block_active;
    proc->block_active = proc->block_root;
    (void) pfile_variable_alloc(pf, PFILE_VARIABLE_ALLOC_LOCAL,
        PFILE_BTMP_VARNAME, mdef, VARIABLE_NONE, &proc->btemp);
    proc->block_active = blk_temp;
  }
  if (proc->btemp) {
    variable_t     tmp;
    variable_def_t mdef;
    char           name[16];
    static unsigned dummy;

    /*sprintf(name, "%s%u", PFILE_BTMP_VARNAME, variable_sz_get(proc->btemp));*/
    sprintf(name, "%s%u", PFILE_BTMP_VARNAME, ++dummy);

    mdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_BOOLEAN,
        VARIABLE_DEF_FLAG_BIT, 1);
    (void) pfile_variable_alloc(pf, PFILE_VARIABLE_ALLOC_LOCAL,
        name, mdef, proc->btemp, &tmp);
    variable_bit_offset_set(tmp, variable_sz_get(proc->btemp));
    variable_def_set(proc->btemp,
        variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
          VARIABLE_DEF_FLAG_BIT, 1 + variable_sz_get(proc->btemp)));
    val = value_alloc(tmp);
    variable_release(tmp);
  }
  return val;
}

value_t  pfile_proc_value_temp_get_from_def(pfile_proc_t *proc, 
  pfile_t *pf, variable_def_t def)
{
  value_t val;

  if (VARIABLE_DEF_TYPE_BOOLEAN == variable_def_type_get(def)) {
    val = pfile_proc_value_temp_boolean_get(proc, pf);
  } else {
    boolean_t is_bit;

    val = VALUE_NONE;
    is_bit = variable_def_flag_test(def, VARIABLE_DEF_FLAG_BIT);
    /* only inherit the signed flag */
    def = variable_def_flags_change(def, 
      variable_def_flags_get_all(def) & VARIABLE_DEF_FLAG_SIGNED);
    /* we *do* want temporary booleans, we *don't* want temporary generic
     * bits, otherwise JAL won't work correctly */
    if (is_bit) {
      /* I don't want to allocate temporary bits! instead, I'll allocate the
       * smallest temporary that will hold the full bit value */
      variable_sz_t       sz;
      variable_def_type_t type;
      flag_t              flags;

      type = variable_def_type_get(def);
      if (VARIABLE_DEF_TYPE_BOOLEAN == type) {
        type = VARIABLE_DEF_TYPE_INTEGER;
      }
      flags = variable_def_flags_get_all(def) & VARIABLE_DEF_FLAG_SIGNED;
      sz = (variable_def_sz_get(def) + 7) / 8;
      def = variable_def_alloc(0, type, flags, sz);
    }
    if (!proc->temp) {
      pfile_block_t *blk_temp;
      variable_def_t mdef;

      mdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_NONE, 
          VARIABLE_DEF_FLAG_NONE, 0);

      /* the temporary area is always allocated in the root block */
      blk_temp = proc->block_active;
      proc->block_active = proc->block_root;
      (void) pfile_variable_alloc(pf, PFILE_VARIABLE_ALLOC_LOCAL,
          PFILE_TMP_VARNAME, mdef, VARIABLE_NONE, &proc->temp);
      proc->block_active = blk_temp;
    } 
    if (proc->temp) {
      val = value_alloc(proc->temp);
      if (!val) {
        pfile_log_syserr(pf, ENOMEM);
      } else {
        variable_t     ovar;
        value_t        oval;

        value_def_set(val, def);
        def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER, 
            VARIABLE_DEF_FLAG_CONST, 2);

        ovar = variable_alloc(0, def);
        variable_const_set(ovar, variable_def_get(ovar), 0, 0);
        oval = value_alloc(ovar);

        value_baseofs_set(val, oval);
        value_release(oval);
        variable_release(ovar);
      }
    }
    assert(!value_dflag_test(val, VARIABLE_DEF_FLAG_BIT));
    assert(VARIABLE_DEF_TYPE_BOOLEAN != value_type_get(val));
    assert(!value_dflag_test(val, VARIABLE_DEF_FLAG_CONST));
  }
  return val;
}

value_t pfile_proc_value_temp_get(pfile_proc_t *proc, 
  pfile_t *pf, variable_def_type_t type, variable_sz_t sz)
{
  variable_def_t def;

  def = variable_def_alloc(0, type, VARIABLE_DEF_FLAG_NONE, sz);
  return pfile_proc_value_temp_get_from_def(proc, pf, def);
}

void pfile_proc_param_fixup(pfile_proc_t *proc)
{
  if (label_usage_get(pfile_proc_label_get(proc))) {
    size_t ii;

    for (ii = 1; ii < proc->param_ct; ii++) {
      value_t val;

      val = pfile_proc_param_get(proc, ii);

      if (value_dflag_test(val, VARIABLE_DEF_FLAG_IN)) {
        variable_assign_ct_bump(value_variable_get(val), CTR_BUMP_INCR);
      }
      if (value_dflag_test(val, VARIABLE_DEF_FLAG_OUT)) {
        variable_use_ct_bump(value_variable_get(val), CTR_BUMP_INCR);
      }
    }
  }
}

void pfile_proc_variable_fixup(pfile_proc_t *proc, pfile_t *pf, flag_t flags)
{
  variable_t     bitbucket;
  variable_def_t def;

  def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
    VARIABLE_DEF_FLAG_NONE, 0);

  bitbucket = 0;
  (void) pfile_block_variable_alloc(proc->block_root,
    pfile_tag_alloc(pf, PFILE_BITBUCKET_VARNAME), def, 
    VARIABLE_NONE, pf, &bitbucket);
  pfile_block_variable_fixup(pfile_proc_block_root_get(proc), 
    bitbucket, 0, flags);
  variable_release(bitbucket);
}

void pfile_proc_bitchain_fixup(pfile_proc_t *proc, pfile_t *pf)
{
  UNUSED(pf);

  pfile_block_bitchain_fixup(pfile_proc_block_root_get(proc));
}

void pfile_proc_label_fixup(pfile_proc_t *proc)
{
  UNUSED(proc);
#if 0
  label_t lbl;

  for (lbl = label_list_head(&proc->label_user); 
       lbl;
       lbl = label_next_get(lbl)) {
    if (label_usage_get(lbl)) {
      label_flag_set(lbl, LABEL_FLAG_USED);
    }
  }
  proc = pfile_proc_next(proc);
#endif
}


pfile_proc_t  *pfile_proc_child_get(const pfile_proc_t *proc)
{
  return proc->child;
}

pfile_proc_t  *pfile_proc_sibbling_get(const pfile_proc_t *proc)
{
  return proc->sibbling;
}

pfile_proc_t  *pfile_proc_parent_get(const pfile_proc_t *proc)
{
  return proc->parent;
}

label_t pfile_proc_label_get(const pfile_proc_t *proc)
{
  return (proc) ? proc->label : 0;
}

static int pfile_proc_call_unique_cmp(void *arg, const void *A,
  const void *B)
{
  pfile_proc_t const *a = A;
  pfile_proc_t const *b = B;

  UNUSED(arg);

  return (a > b) - (b > a);
}

result_t pfile_proc_call_add(pfile_proc_t *proc, pfile_proc_t *dst)
{
  pfile_proc_array_entry_add(proc->calls, (void *) &dst, ARRAY_ADD_FLAG_NONE,
     pfile_proc_call_unique_cmp, 0);
  variable_assign_ct_bump(pfile_proc_ret_ptr_get(dst), CTR_BUMP_INCR);
  variable_use_ct_bump(pfile_proc_ret_ptr_get(dst), CTR_BUMP_INCR);
  return RESULT_OK;
}

size_t pfile_proc_calls_ct_get(const pfile_proc_t *proc)
{
  return (proc) ? pfile_proc_array_entry_ct(proc->calls) : 0;
}

pfile_proc_t *pfile_proc_calls_get(const pfile_proc_t *proc, size_t n)
{
  pfile_proc_t **entry;

  entry = pfile_proc_array_entry_get(proc->calls, n);
  return (entry) ? *entry : PFILE_PROC_NONE;
}

#if 0
value_t pfile_proc_vparam_get(const pfile_proc_t *proc, size_t n)
{
  return (proc && (n < proc->param_ct)) ? proc->params[n] : 0;
}

size_t pfile_proc_param_ct_get(const pfile_proc_t *proc)
{
  return proc ? proc->param_ct : 0;
}
#endif

/* dump the entire pfile_proc heirarchy as follows:
 *   name
 *     labels
 *     variable defs
 *     variables
 *     temporaries
 */
#if 0
static void pfproc_variable_def_dump(pfile_t *pf, variable_def_t def, 
    int indent)
{
  const char           *tstr;
  variable_def_member_t mbr;

  tstr = "???";
  switch (variable_def_type_get(def)) {
    case variable_def_type_bit:      tstr = "bit";       break;
    case VARIABLE_DEF_TYPE_BOOLEAN:  tstr = "bool";      break;
    case variable_def_type_unsigned: tstr = "unsigned";  break;
    case variable_def_type_signed:   tstr = "signed";    break;
    case VARIABLE_DEF_TYPE_FLOAT:    tstr = "float";     break;
    case VARIABLE_DEF_TYPE_POINTER:  tstr = "pointer";   break;
    case VARIABLE_DEF_TYPE_FUNCTION: tstr = "function";  break;
    case VARIABLE_DEF_TYPE_STRUCTURE:tstr = "struct";    break;
    case VARIABLE_DEF_TYPE_UNION:    tstr = "union";     break;
    case VARIABLE_DEF_TYPE_NONE:     tstr = "none";      break;
  }
  pfile_write(pf, pfile_write_lst, "%*s{%s %c%c%c%c}\n", indent, "", tstr,
      variable_def_flag_test(def, VARIABLE_DEF_FLAG_CONST)    ? 'C' : '-',
      variable_def_flag_test(def, VARIABLE_DEF_FLAG_VOLATILE) ? 'V' : '-',
      variable_def_flag_test(def, VARIABLE_DEF_FLAG_IN)       ? 'I' : '-',
      variable_def_flag_test(def, VARIABLE_DEF_FLAG_OUT)      ? 'O' : '-'
      );
  for (mbr = variable_def_member_get(def);
       mbr;
       mbr = variable_def_member_link_get(mbr)) {
    pfile_write(pf, pfile_write_lst, "%*s%u * %s{", "", indent + 2,
        variable_def_member_ct_get(mbr),
        variable_def_member_tag_get(mbr) 
        ? variable_def_member_tag_get(mbr)
        : "");
    pfproc_variable_def_dump(pf, def, indent + 2);
  }
}
#endif

#if 0
static void pfproc_var_reference_dump(pfile_t *pf, pfile_write_t where,
  variable_t var, const char *title,
  variable_t (*fn)(variable_t var, size_t ix)) 
{
  UNUSED(pf);
  UNUSED(where);
  UNUSED(var);
  UNUSED(title);
  UNUSED(fn);

#if 1
  if (VARIABLE_NONE != fn(var, 0)) {
    variable_t vptr;
    size_t     ii;

    pfile_write(pf, where, ";   %s: ", title);
    ii = -1;
    do {
      ii++;
      vptr = fn(var, ii);
      if (VARIABLE_NONE != vptr) {
        const char *fmt;

        fmt = (variable_tag_n_get(vptr)) ? "%s__%s_%u" : "%s%s";
        pfile_write(pf, where, fmt, (ii) ? ", " : "",
          variable_name_get(vptr), variable_tag_n_get(vptr));
      }
    } while (VARIABLE_NONE != vptr);
    pfile_write(pf, where, "\n");
  }
#endif
}
#endif

static void pfproc_variable_list_dump(pfile_block_t *blk, pfile_t *pf, 
  int indent)
{
  variable_t var;

  for (var = pfile_block_variable_list_head(blk);
       var; 
       var = variable_link_get(var)) {
    variable_def_t def;
    unsigned       ano;
    const char    *fmt;
    /*variable_array_t *interfer;*/
    size_t            ii;


    ano = variable_tag_n_get(var);

    def = variable_def_get(var);
    fmt = (ano)
      ? ";%*s%u:_%s_%u "
      : ";%*s%u:_%s ";
    pfile_write(pf, pfile_write_lst, fmt, indent, "",
        variable_id_get(var), variable_name_get(var), ano);

    pfile_write(pf, pfile_write_lst,
      "%s (type=%c dflags=%c%c%c%c%c%s%s%s%s%s%s%s%s sz=%u use=%u assigned=%u",
      (variable_def_tag_get(def)) ? variable_def_tag_get(def) : "",
      variable_def_type_to_ch(variable_def_type_get(def)),
      variable_dflag_test(var, VARIABLE_DEF_FLAG_CONST)   ? 'C' : '-',
      variable_dflag_test(var, VARIABLE_DEF_FLAG_VOLATILE)? 'V' : '-',
      variable_dflag_test(var, VARIABLE_DEF_FLAG_SIGNED)  ? 'S' : '-',
      variable_dflag_test(var, VARIABLE_DEF_FLAG_BIT)     ? 'B' : '-',
      variable_dflag_test(var, VARIABLE_DEF_FLAG_UNIVERSAL) ? 'U' : '-',
      variable_flag_test(var, VARIABLE_FLAG_AUTO)         ? " auto" : "",
      variable_flag_test(var, VARIABLE_FLAG_STICKY)       ? " sticky" : "",
      variable_flag_test(var, VARIABLE_FLAG_ALIAS)        ? " alias" : "",
      variable_flag_test(var, VARIABLE_FLAG_LOOKUP)       ? " lookup" : "",
      variable_flag_test(var, VARIABLE_FLAG_PTR_PTR)      ? " ptr_ptr" : "",
      variable_flag_test(var, VARIABLE_FLAG_PTR_LOOKUP)   ? " ptr_lookup" : "",
      variable_flag_test(var, VARIABLE_FLAG_PTR_EEPROM)   ? " ptr_eeprom" : "",
      variable_flag_test(var, VARIABLE_FLAG_PTR_FLASH)    ? " ptr_flash" : "",
      variable_sz_get(var),
      variable_use_ct_get(var),
      variable_assign_ct_get(var));
    if (!variable_master_get(var) 
        && !variable_is_const(var)) {
      pfile_write(pf, pfile_write_lst, " base=%04x", 
          variable_base_get(var, 0));
    }
    if (variable_dflag_test(var, VARIABLE_DEF_FLAG_BIT)) {
      pfile_write(pf, pfile_write_lst, " bit=%u",
          variable_bit_offset_get(var));
    }
    pfile_write(pf, pfile_write_lst, ")");
    if (variable_master_get(var)) {
      variable_t master;

      master = variable_master_get(var);
      fmt = (variable_tag_n_get(master))
        ? " ---> __%s%u"
        : " ---> %s";
      pfile_write(pf, pfile_write_lst, fmt,
          variable_name_get(master), variable_tag_n_get(master));
      if (variable_base_get(var, 0)) {
        pfile_write(pf, pfile_write_lst, "+%u", variable_base_get(var, 0)
            - variable_base_get(variable_master_get(var), 0));
      }
    }
    pfile_write(pf, pfile_write_lst, "\n");
    /*variable_def_dump(variable_def_get(var), pf, indent + 2);*/
    if (variable_dflag_test(var, VARIABLE_DEF_FLAG_CONST)) {
      /* dump the constant or array! */
      size_t ct;

      def = variable_def_get(var);

      if (VARIABLE_DEF_TYPE_ARRAY == variable_def_type_get(def)) {
        ct = variable_def_member_ct_get(
            variable_def_member_get(def));
        def = variable_def_member_def_get(
            variable_def_member_get(def));
      } else {
        ct = 1;
      }
      fmt = (variable_dflag_test(var, VARIABLE_DEF_FLAG_SIGNED))
          ? "%s%ld" : "%s%lu";
      pfile_write(pf, pfile_write_lst, ";%*s = ", indent, "");
      for (ii = 0; ii < ct; ii++) {
        pfile_write(pf, pfile_write_lst, fmt,
            (ii) ? "," : "", variable_const_get(var, def, 
                                                ii * variable_def_sz_get(def)));
      }
      pfile_write(pf, pfile_write_lst, "\n");
    }
    /* dump the uses/used by fields */
#if 0
    pfproc_var_reference_dump(pf, pfile_write_lst, var,
      "Uses", variable_uses_get);
    pfproc_var_reference_dump(pf, pfile_write_lst, var,
      "Used by", variable_used_by_get);
    pfproc_var_reference_dump(pf, pfile_write_lst, var,
      "Interfer", variable_interfer_get);
    interfer = variable_interference_get(var);
    if (interfer && variable_array_entry_ct(interfer)) {
      size_t col;

      col = pfile_write(pf, pfile_write_lst, ";interference: ");
      for (ii = 0; ii < variable_array_entry_ct(interfer); ii++) {
        if (col > 70) {
          pfile_write(pf, pfile_write_lst, "\n;...");
          col = 4;
        }
        col += pfile_write(pf, pfile_write_lst, "%s%s", (ii) ? ", " : "", 
          variable_name_get(*variable_array_entry_get(interfer, ii)));
      }
      pfile_write(pf, pfile_write_lst, "\n");
    }
#endif
  }
}

static void pfproc_label_list_dump(pfile_block_t *blk, pfile_t *pf, int indent)
{
  label_t lbl;

  for (lbl = pfile_block_label_list_head(blk); 
       lbl; 
       lbl = label_link_get(lbl)) {
    pfile_write(pf, pfile_write_lst,
      ";%*s%s (pc(%04x) usage=%u)\n",
      indent, "", label_name_get(lbl), 
      label_pc_get(lbl),
      label_usage_get(lbl));
  }
}

static void pfproc_variable_def_dump(pfile_block_t *blk, pfile_t *pf, 
    int indent)
{
  UNUSED(blk);
  UNUSED(pf);
  UNUSED(indent);
  /*variable_def_dump(pfile_block_variable_def_head(blk), pf, indent);*/
}

static void pfile_proc_block_dump(pfile_block_t *blk, pfile_t *pf, int indent)
{
  pfile_write(pf, pfile_write_lst,
      ";%*s%s\n", indent, "", "{block enter}");
  indent += 2;
  pfile_write(pf, pfile_write_lst,
      ";%*s%s\n", indent, "", "--- records ---");
  pfproc_variable_def_dump(blk, pf, indent);
  pfile_write(pf, pfile_write_lst,
      ";%*s%s\n", indent, "", "--- variables ---");
  pfproc_variable_list_dump(blk, pf, indent);
  pfile_write(pf, pfile_write_lst,
      ";%*s%s\n", indent, "", "--- labels ---");
  pfproc_label_list_dump(blk, pf, indent);
  for (blk = pfile_block_child_get(blk);
       blk;
       blk = pfile_block_sibbling_get(blk)) {
    pfile_proc_block_dump(blk, pf, indent);
  }
  indent -= 2;
  pfile_write(pf, pfile_write_lst,
      ";%*s%s\n", indent, "", "{block exit}");
}

void pfile_proc_dump(pfile_proc_t *root, pfile_t *pf, int depth)
{
  pfile_proc_stats_generate(root);
  pfile_write(pf, pfile_write_lst,
      ";%*s%s %c%c%c%c%c %c%c%c (frame_sz=%u blocks=%u)\n", 2 * depth, "", 
      root->label ? label_name_get(root->label) : "{root}",
      pfile_proc_flag_test(root, PFILE_PROC_FLAG_VISITED)      ? 'V' : '-',
      pfile_proc_flag_test(root, PFILE_PROC_FLAG_REENTRANT)    ? 'R' : '-',
      pfile_proc_flag_test(root, PFILE_PROC_FLAG_DIRECT)       ? 'D' : '-',
      pfile_proc_flag_test(root, PFILE_PROC_FLAG_INDIRECT)     ? 'I' : '-',
      pfile_proc_flag_test(root, PFILE_PROC_FLAG_INLINE)       ? 'L' : '-',
      pfile_proc_flag_test(root, PFILE_PROC_FLAG_FRAME)        ? 'F' : '-',
      pfile_proc_flag_test(root, PFILE_PROC_FLAG_CONTEXT_USER) ? 'U' : '-',
      pfile_proc_flag_test(root, PFILE_PROC_FLAG_CONTEXT_ISR)  ? 'I' : '-',
      pfile_proc_frame_sz_get(root),
      pfile_proc_block_ct_get(root));
  depth++;
  pfile_proc_block_dump(pfile_proc_block_root_get(root), pf, 2 + depth);

  for (root = root->child; root; root = root->sibbling) {
    pfile_proc_dump(root, pf, depth + 2);
  }
}

/* given a proc, return the next one. this is used for traversing
 * all of the procs. */
pfile_proc_t *pfile_proc_next(const pfile_proc_t *proc)
{
  pfile_proc_t *next;

  if (proc->child) {
    next = proc->child;
  } else if (proc->sibbling) {
    next = proc->sibbling;
  } else {
    while (proc && !proc->sibbling) {
      proc = proc->parent;
    }
    next = (proc)
      ? proc->sibbling
      : PFILE_PROC_NONE;
  }
  return next;
}

boolean_t pfile_proc_flag_test(const pfile_proc_t *proc, flag_t flag)
{
  return (proc && ((proc->flags & flag) == flag));
}

void pfile_proc_flag_set(pfile_proc_t *proc, flag_t flag)
{
  if (proc) {
    proc->flags |= flag;
  }
}
  
void          pfile_proc_flag_clr(pfile_proc_t *proc, flag_t flag)
{
  if (proc) {
    proc->flags &= ~flag;
  }
}

pfile_block_t *pfile_proc_block_root_get(const pfile_proc_t *proc)
{
  return proc->block_root;
}

pfile_block_t *pfile_proc_block_active_get(const pfile_proc_t *proc)
{
  return proc->block_active;
}

void pfile_proc_block_active_set(pfile_proc_t *proc, pfile_block_t *blk)
{
  proc->block_active = blk;
}

result_t pfile_proc_block_enter(pfile_proc_t *proc)
{
  if (proc->block_active) {
    /* this becomes a child of the current block */
    pfile_block_t *blk;

    blk = pfile_block_alloc(proc->block_active, proc, CMD_NONE);
    proc->block_active = blk;
  } else {
    proc->block_active = proc->block_root;
  }
  return RESULT_OK;
}

result_t pfile_proc_block_leave(pfile_proc_t *proc)
{
  assert(proc->block_active != PFILE_BLOCK_NONE);
  proc->block_active = pfile_block_parent_get(proc->block_active);
  
  return RESULT_OK;
}

/* make the root block the active one */
void pfile_proc_block_reset(pfile_proc_t *proc)
{
  proc->block_active = proc->block_root;
}

static unsigned pfile_proc_block_frame_sz_get(pfile_block_t *blk)
{
  variable_t var;
  unsigned   frame_sz;
  unsigned   child_sz;

  for (frame_sz = 0, var = pfile_block_variable_list_head(blk);
       var;
       var = variable_link_get(var)) {
    if (variable_is_auto(var) && !variable_is_volatile(var)) {
      frame_sz += variable_sz_get(var);
    }
  }
  for (child_sz = 0, blk = pfile_block_child_get(blk);
       blk;
       blk = pfile_block_sibbling_get(blk)) {
    unsigned sz;

    sz = pfile_proc_block_frame_sz_get(blk);
    if (sz > child_sz) {
      child_sz = sz;
    }
  }
  return frame_sz + child_sz;
}

void pfile_proc_stats_generate(pfile_proc_t *proc)
{
  pfile_block_t *blk;
  unsigned       blk_ct;

  proc->frame_sz = pfile_proc_block_frame_sz_get(proc->block_root);
  for (blk_ct = 0, blk = proc->block_root;
       blk;
       blk_ct++, blk = pfile_block_next(blk))
    ;
  proc->block_ct = blk_ct;
}

size_t pfile_proc_frame_sz_get(const pfile_proc_t *proc)
{
  return proc->frame_sz;
}

variable_t pfile_proc_frame_get(const pfile_proc_t *proc)
{
  return proc->frame;
}

void pfile_proc_frame_set(pfile_proc_t *proc, variable_base_t base, 
  pfile_t *pf)
{
  if (!proc->frame) {
    char       *fname;
    size_t      sz;
    const char *pname;

    pname = label_name_get(pfile_proc_label_get(proc));
    sz    = 1 + strlen(pname);
    fname = MALLOC(2 + sz);
    if (fname) {
      variable_def_t vdef;

      vdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
        VARIABLE_DEF_FLAG_NONE, pfile_proc_frame_sz_get(proc));

      memcpy(fname, "_f", 2);
      memcpy(fname + 2, pname, sz);
      pfile_variable_alloc(pf, PFILE_VARIABLE_ALLOC_GLOBAL,
        fname, vdef, VARIABLE_NONE, &proc->frame);
      FREE(fname);
    }
  }
  if (proc->frame) {
    variable_base_set(proc->frame, base, 0);
  }
}

unsigned pfile_proc_block_ct_get(const pfile_proc_t *proc)
{
  return proc->block_ct;
}

label_t pfile_proc_exit_label_get(const pfile_proc_t *proc)
{
  return proc->exit_label;
}

label_t pfile_proc_skip_label_get(const pfile_proc_t *proc)
{
  return proc->skip_label;
}


variable_def_t pfile_proc_return_def_get(const pfile_proc_t *proc)
{
  return (proc) 
    ? variable_def_member_def_get(variable_def_member_get(proc->def))
    : VARIABLE_DEF_NONE;
}

variable_def_t pfile_proc_def_get(const pfile_proc_t *proc)
{
  return (proc) ? proc->def : VARIABLE_DEF_NONE;
}

size_t pfile_proc_param_ct_get(const pfile_proc_t *proc)
{
  return (proc) ? proc->param_ct : 0;
}

value_t pfile_proc_param_get(const pfile_proc_t *proc, size_t n)
{
  return (proc && (n < proc->param_ct) && proc->params)
    ? proc->params[n]
    : VALUE_NONE;
}

void pfile_proc_param_set(pfile_proc_t *proc, size_t n, value_t val)
{
  if (proc && (n < proc->param_ct) && proc->params) {
    value_lock(val);
    value_release(proc->params[n]);
    proc->params[n] = val;
  }
}


void pfile_proc_frame_sz_calc(pfile_proc_t *proc)
{
  proc->frame_sz = pfile_block_data_sz_calc(proc->block_root);
}

void pfile_proc_reentrant_test(pfile_proc_t *proc, flag_t flag, unsigned depth)
{
  pfile_proc_flag_set(proc, flag);
  /* if this is called in both the user & ISR context then it's
     reentrant */
  if (((PFILE_PROC_FLAG_CONTEXT_USER == flag)
    && pfile_proc_flag_test(proc, PFILE_PROC_FLAG_CONTEXT_ISR))
    || ((PFILE_PROC_FLAG_CONTEXT_ISR == flag)
    && pfile_proc_flag_test(proc, PFILE_PROC_FLAG_CONTEXT_USER))) {
    pfile_proc_flag_set(proc, PFILE_PROC_FLAG_REENTRANT);
    proc->depth = (unsigned) -1;
  }
  if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_VISITED)) {
    pfile_proc_flag_set(proc, PFILE_PROC_FLAG_REENTRANT);
    proc->depth = (unsigned) -1;
  } else {
    unsigned      ct;
    pfile_proc_t *cproc;

    pfile_proc_flag_set(proc, PFILE_PROC_FLAG_VISITED);
    if (depth > proc->depth) {
      proc->depth = depth;
    }
    for (ct = 0; (cproc = pfile_proc_calls_get(proc, ct)) != 0; ct++) {
      pfile_proc_reentrant_test(cproc, flag, depth + 1);
    }
    pfile_proc_flag_clr(proc, PFILE_PROC_FLAG_VISITED);
  }
}

void pfile_proc_ret_ptr_alloc(pfile_proc_t *proc, pfile_t *pf)
{
  if (proc && (VARIABLE_NONE == proc->ret_ptr)) {
    variable_def_t def;
    tag_t          tag;

    def = variable_def_alloc(0, VARIABLE_DEF_TYPE_POINTER,
      VARIABLE_DEF_FLAG_NONE, pfile_pointer_size_get(pf));
    tag = pfile_tag_alloc(pf, "_return");
    (void) pfile_proc_variable_alloc(proc, PFILE_VARIABLE_ALLOC_GLOBAL,
      tag, def, VARIABLE_NONE, pf, &proc->ret_ptr);
  }
}

variable_t pfile_proc_ret_ptr_get(pfile_proc_t *proc)
{
  return (proc) ? proc->ret_ptr : VARIABLE_NONE;
}

static int successor_array_cmp(void *arg, const void *A, const void *B)
{
  cmd_t a;
  cmd_t b;
  UNUSED(arg);

  a = *(cmd_t const *) A;
  b = *(cmd_t const *) B;
  return (a > b) - (b > a);
}

void pfile_proc_successor_add(pfile_proc_t *proc, cmd_t cmd)
{
  if (!proc->successors) {
    proc->successors = cmd_array_alloc(1);
  }
  cmd_array_entry_add(proc->successors, &cmd, ARRAY_ADD_FLAG_NONE,
    successor_array_cmp, 0);
}

size_t pfile_proc_successor_count(const pfile_proc_t *proc)
{
  return cmd_array_entry_ct(proc->successors);
}

cmd_t pfile_proc_successor_get(const pfile_proc_t *proc, size_t ix)
{
  cmd_t *cptr;

  cptr = cmd_array_entry_get(proc->successors, ix);
  return (cptr) ? *cptr : CMD_NONE;
}


