/************************************************************
 **
 ** pic_var.c : PIC variable allocation definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <assert.h>

#include "../libutils/mem.h"
#include "../libcore/pf_proc.h"
#include "pic_msg.h"
#include "pic_stvar.h"
#include "pic_var.h"

#undef BLIST_DEBUG

static unsigned  auto_mem_reg = 1;

unsigned         pic_blist_max; /* max amount used     */
unsigned         pic_blist_total;
static pic_bank_info_t *pic_data_bank_list;
static pic_bank_info_t *pic_shared_bank_list;

size_t           pic_stk_sz;
variable_base_t  pic_stk_base;

#ifdef BLIST_DEBUG
static void pic_blist_dump(pfile_t *pf, const pic_bank_info_t *blist)
{
  const pic_bank_info_t *bptr;

  pfile_log(pf, PFILE_LOG_DEBUG, "--- blist start ---");
  for (bptr = blist; bptr; bptr = bptr->link) {
    pfile_log(pf, PFILE_LOG_DEBUG, 
        PIC_MSG_DBG_BANK, bptr->lo, bptr->hi);
  }
  pfile_log(pf, PFILE_LOG_DEBUG, "--- blist end ---");
}

static void pic_blist_check(const pic_bank_info_t *blist)
{
  const pic_bank_info_t *b1;
  const pic_bank_info_t *b2;

  b1 = blist;
  b2 = (b1) ? b1->link : 0;
  while (b1 && b2 && (b1 != b2)) {
    b1 = b1->link;
    b2 = b2->link;
    if (b2) {
      b2 = b2->link;
    }
  }
  assert(b1 != b2);
  for (b1 = blist; b1; b1 = b1->link) {
    assert(b1->lo <= b1->hi);
    if (b1->link) {
      assert(b1->hi < b1->link->lo);
    }
  }
}
#endif

/*
 * NAME
 *   pic_variable_alloc
 *
 * DESCRIPTION
 *   allocate space for all variables
 *
 * PARAMETERS
 *   pf
 *
 * RETURN
 *
 * NOTES
 *   this is dummied up for now. eventually i'll need to sort
 *   the variables by size for a more optimimal filling
 */
/* this is the union of  blist with {lo,hi} */
void pic_blist_add(pfile_t *pf, pic_bank_info_t **pblist, 
    size_t lo, size_t hi)
{
  pic_bank_info_t *ptr;
  pic_bank_info_t *pv;
  pic_bank_info_t *blist;

  UNUSED(pf);

  assert(lo <= hi);
  blist = *pblist;
  for (ptr = blist, pv = 0; 
       ptr && (lo > ptr->hi);
       pv = ptr, ptr = ptr->link)
    ;
  /* this could use *a lot* of improvement, but will work for now
   * 1st I'll simply allocate a new entry & insert it, then I'll
   * do some cleanup */
  if (ptr && (ptr->lo <= lo) && (ptr->hi >= hi)) {
  } else {
    ptr = MALLOC(sizeof(*ptr));
    ptr->lo = lo;
    ptr->hi = hi;
    ptr->link = (pv) ? pv->link : blist;
    if (pv) {
      ptr->link = pv->link;
      pv->link  = ptr;
    } else {
      ptr->link = blist;
      blist     = ptr;
    }

    ptr = blist;
    while (ptr->link) {
      pic_bank_info_t *link;

      link = ptr->link;
      if (ptr->hi + 1 >= link->lo) {
        /* remove ptr->link */
        if (ptr->hi < link->hi) {
          ptr->hi = link->hi;
        }
        ptr->link = link->link;
        FREE(link);
      } else {
        ptr = link;
      }
    }
  }
  *pblist = blist;
#ifdef BLIST_DEBUG
  pic_blist_check(blist);
  pfile_log(pf, PFILE_LOG_DEBUG, "BLIST ADD(%u,%u)", lo, hi);
  pic_blist_dump(pf, pic_blist);
#endif
}

void pic_data_bank_list_add(pfile_t *pf, size_t lo, size_t hi)
{
  pic_blist_add(pf, &pic_data_bank_list, lo, hi);
}

void pic_shared_bank_list_add(pfile_t *pf, size_t lo, size_t hi)
{
  pic_blist_add(pf, &pic_shared_bank_list, lo, hi);
}


static void pic_blist_remove(pfile_t *pf, pic_bank_info_t **pblist,
    size_t base, size_t sz)
{
  pic_bank_info_t *ptr;
  pic_bank_info_t *pv;
  pic_bank_info_t *blist;
  size_t           lo;
  size_t           hi;

  blist = *pblist;
  lo = base;
  hi = base + sz - 1;

  for (ptr = blist, pv = 0;
       ptr && (lo > ptr->hi);
       pv = ptr, ptr = ptr->link)
    ;
  if (ptr && (lo <= ptr->hi) && (hi >= ptr->lo)) {
    /* lo <= ptr->hi
       ptr->lo <= hi <= ptr->hi */
    if (lo <= ptr->lo) {
      ptr->lo = hi + 1;
    }
    if (hi >= ptr->hi) {
      ptr->hi = lo - 1;
    }
    /* if (ptr->hi < ptr->lo), this bit is gone */
    if (ptr->hi < ptr->lo) {
      if (pv) {
        pv->link = ptr->link;
      } else {
        blist = ptr->link;
      }
      FREE(ptr);
    } else if ((ptr->lo < lo) && (hi < ptr->hi)) {
      /* split this into:
           {ptr->lo, lo - 1}
           {hi + 1, ptr->hi} */
      pv = ptr;
      ptr = MALLOC(sizeof(*ptr));
      if (!ptr) {
        pfile_log_syserr(pf, RESULT_MEMORY);
      } else {
        ptr->link = pv->link;
        pv->link  = ptr;
        ptr->hi   = pv->hi;
        ptr->lo   = hi + 1;
        pv->hi    = lo - 1;
      }
    }
  }
  *pblist = blist;
#ifdef BLIST_DEBUG
  pic_blist_check(blist);
  pfile_log(pf, PFILE_LOG_DEBUG, "BLIST REMOVE(%u,%u)", lo, lo + sz - 1);
  pic_blist_dump(pf, pic_blist);
#endif
}

/* allocate a block out of the data area */
static variable_base_t pic_data_alloc(pfile_t *pf, pic_bank_info_t **blist,
  variable_sz_t need)
{
  pic_bank_info_t *bank;
  variable_base_t  base;
  unsigned         bank_size;
  unsigned         bank_mask;

  base = VARIABLE_BASE_UNKNOWN;
  bank_size = pic_target_bank_size_get(pf);
  bank_mask = ~(bank_size - 1);

  if (bank_size & (bank_size - 1)) {
    pfile_log(pf, PFILE_LOG_ERR, 
      "code generation error. Target size (%u) is not a power of 2!",
      bank_size);
  }

  /*
   * On the 16 bit cores, different banks are contiguous. For example
   * the bank list might show 0x0000 - 0x03ff but this is really
   * four different banks requiring four different MOVLB instructions.
   * This was never a problem on the 12 or 14 bit cores where the
   * beginning of each bank consists of special function registers.
   * I'll try to account for that here.
   */
  for (bank = *blist; 
       bank && (VARIABLE_BASE_UNKNOWN == base); 
       bank = bank->link) {
    variable_sz_t lo;
    variable_sz_t hi;

    lo = bank->lo;
    do {
      hi = lo + need - 1;
      if (((lo & bank_mask) == (hi & bank_mask))
        && (hi <= bank->hi)) {
        base = lo; /* we have a winner! */
      } else if (hi <= bank->hi) {
        /* put lo in the same bank as hi */
        lo = hi & bank_mask;
      }
    } while ((hi <= bank->hi) && (VARIABLE_BASE_UNKNOWN == base));
  }
  if (VARIABLE_BASE_UNKNOWN != base) {
    /* base = bank->lo; */
    pic_blist_remove(pf, blist, base, need);
#ifdef BLIST_DEBUG
    fprintf(stderr, "Allocating %u\n", base);
#endif
    pic_blist_max += need;
  } 
  return base;
}

static variable_sz_t pic_data_biggest(const pic_bank_info_t *blist)
{
  variable_sz_t biggest;

  biggest = 0;
  while (blist) {
    variable_sz_t sz;

    sz = blist->hi - blist->lo + 1;
    if (sz > biggest) {
      biggest = sz;
    }
    blist = blist->link;
  }
  return biggest;
}

/* returns BOOLEAN_TRUE if a new base was set, else BOOLEAN_FALSE */
static boolean_t pic_variable_base_set(pfile_t *pf, pfile_proc_t *proc, 
  pic_bank_info_t **blist, variable_t vptr)
{
  variable_sz_t   need;
  variable_base_t base;
  boolean_t       rc;

  need = variable_sz_get(vptr);
  assert(need);
  /* first we'll see if the entire thing can fit in a bank.
     If so, good! */

  base = pic_data_alloc(pf, blist, need);
  rc   = BOOLEAN_FALSE;
  if (VARIABLE_BASE_UNKNOWN == base) {
    pfile_log(pf, PFILE_LOG_ERR, "no space for %s:%s (need=%u available=%u)",
        (proc) ? pfile_proc_tag_get(proc) : "",
        variable_name_get(vptr),
        need, pic_data_biggest(*blist));
    variable_flag_set(vptr, VARIABLE_FLAG_ALLOC_FAIL);
  } else {
    assert(VARIABLE_BASE_UNKNOWN == variable_base_get(vptr, 0));
    rc = BOOLEAN_TRUE;
    variable_base_set(vptr, base, 0);
  }
  return rc;
}

boolean_t pic_variable_alloc_one(pfile_t *pf, pfile_proc_t *proc,
    variable_t var)
{
  return pic_variable_base_set(pf, proc, &pic_data_bank_list, var);
}

/* find all variables that the user has placed & make sure these
   positions do not get reused */
static void blist_total(void)
{
  const pic_bank_info_t *binfo;

  for (pic_blist_total = 0, binfo = pic_data_bank_list; 
       binfo; 
       pic_blist_total += binfo->hi - binfo->lo + 1, binfo = binfo->link)
    ;
}

static void pic_variable_alloc_proc(pfile_t *pf, pfile_proc_t *proc);
static void pic_variable_alloc_block(pfile_t *pf, pfile_proc_t *proc, 
    pfile_block_t *blk)
{
  variable_t     vptr;
  pfile_block_t *cblk;
  size_t         ct;
  pfile_proc_t  *cproc;
  /*size_t         entry_sz;*/
  unsigned       auto_mem_reg_init;
  unsigned       change_ct;
  unsigned       var_ct;

  auto_mem_reg_init = auto_mem_reg;

#if 0
  printf("allocating space for: %s\n",
      label_name_get(pfile_proc_label_get(proc)));
#endif

  if (!blk) {
    blk = pfile_proc_block_root_get(proc);
  }
  /* first, allocate all variables for this procedure */
  for (vptr = pfile_block_variable_list_head(blk), 
         change_ct = 0, var_ct = 0; 
       vptr; 
       vptr = variable_link_get(vptr)) {
    if (variable_is_auto(vptr) 
        && !variable_is_sticky(vptr)
        && !variable_flag_test(vptr, VARIABLE_FLAG_ALLOC_FAIL)) {
      /* find the first bank that will hold this variable */
      variable_sz_t   sz;
      variable_base_t old_base;

      var_ct++;
      sz = variable_sz_get(vptr);
      assert(sz);
      old_base = variable_base_get(vptr, 0);
      if ((old_base == VARIABLE_BASE_UNKNOWN)
        || (old_base < auto_mem_reg)) {
        change_ct++;
        variable_base_set(vptr, auto_mem_reg, 0);
        auto_mem_reg += sz;
        if (old_base != VARIABLE_BASE_UNKNOWN) {
          pfile_log(pf, PFILE_LOG_DEBUG, 
              "Resetting...%s%u (was %u, now %u)",
              variable_name_get(vptr), variable_tag_n_get(vptr),
              old_base, variable_base_get(vptr, 0)
              );
        }
      }
    }
  }
  /* If no changes were made here, no changes will be made below. */
  if ((var_ct == 0) || (change_ct > 0)) {
    /* next, recurse into all procedures this one calls and
     * allocate *those* variables */
    for (cblk = pfile_block_child_get(blk);
         cblk;
         cblk = pfile_block_sibbling_get(cblk)) {
      pic_variable_alloc_block(pf, proc, cblk);
    }
    for (ct = 0; (cproc = pfile_proc_calls_get(proc, ct)) != 0; ct++) {
      if (!pfile_proc_flag_test(cproc, PFILE_PROC_FLAG_VISITED)) {
        pfile_proc_flag_set(cproc, PFILE_PROC_FLAG_VISITED);
        pic_variable_alloc_proc(pf, cproc);
        pfile_proc_flag_clr(cproc, PFILE_PROC_FLAG_VISITED);
      }
    }
  }
  if (pfile_flag_test(pf, PFILE_FLAG_OPT_VARIABLE_REUSE)) {
    auto_mem_reg = auto_mem_reg_init;
  }
}

static void pic_variable_alloc_proc(pfile_t *pf, pfile_proc_t *proc)
{
  /*
   * if the procedure is ever called indirectly its variables were
   * allocated earlier so this can be ignored
   */
  pic_variable_alloc_block(pf, proc, 0);
}

#if 0
static void pic_variable_interfer_proc(pfile_t *pf, pfile_proc_t *proc,
  variable_array_t *live, variable_array_t *all_vars)
{
  variable_t     vptr;
  pfile_block_t *blk;
  size_t         ct;
  pfile_proc_t  *cproc;

  for (blk = pfile_proc_block_root_get(proc);
       blk;
       blk = pfile_block_next(blk)) {
    /* first, allocate all variables for this procedure */
    for (vptr = pfile_block_variable_list_head(blk); 
         vptr; 
         vptr = variable_link_get(vptr)) {
      if (variable_is_auto(vptr) 
          && !variable_is_sticky(vptr)) {
        /* add this variable to all entries in live */
        size_t live_ct;

        variable_array_entry_add(all_vars, &vptr, ARRAY_ADD_FLAG_NONE,
          variable_unique_cmp, 0);
        variable_interference_add(vptr, vptr);
        live_ct = variable_array_entry_ct(live);
        while (live_ct--) {
          variable_interference_add(*variable_array_entry_get(live, live_ct), 
            vptr);
          variable_interference_add(vptr, 
            *variable_array_entry_get(live, live_ct));
        }
        variable_array_entry_add(live, &vptr, ARRAY_ADD_FLAG_NONE,
          variable_unique_cmp, 0);
      }
    }
  }
  /* next, recurse into all procedures this one calls */
  for (ct = 0; (cproc = pfile_proc_calls_get(proc, ct)) != 0; ct++) {
    pic_variable_interfer_proc(pf, cproc, live, all_vars);
  }
  /* finally, this procedure's variables are no longer live, so
   * remove them */
  for (blk = pfile_proc_block_root_get(proc);
       blk;
       blk = pfile_block_next(blk)) {
    /* first, allocate all variables for this procedure */
    for (vptr = pfile_block_variable_list_head(blk); 
         vptr; 
         vptr = variable_link_get(vptr)) {
      if (variable_is_auto(vptr) 
          && !variable_is_sticky(vptr)) {
        /* remove this variable to all entries in live */
        variable_array_entry_delete(live, &vptr, variable_unique_cmp, 0);
      }
    }
  }
}
#endif

/* allocate all variables out of a single block. base holds the block */
static void pic_block_data_alloc(pfile_t *pf, pfile_block_t *blk, 
  variable_base_t base)
{
  variable_t vptr;

  for (vptr = pfile_block_variable_list_head(blk);
       vptr;
       vptr = variable_link_get(vptr)) {
    if (variable_is_auto(vptr)) {
      variable_base_set(vptr, base, 0);
      variable_flag_set(vptr, VARIABLE_FLAG_STICKY);
      base += variable_sz_get(vptr);
    }
  }
  for (blk = pfile_block_child_get(blk);
       blk;
       blk = pfile_block_sibbling_get(blk)) {
    pic_block_data_alloc(pf, blk, base);
  }
}

/*
 * allocate variables for all of the indirect functions. It's probably
 * to analyze these a bit better & do a smarter allocation so we can
 * reuse data space, but it's far easier to just say dataspace for all 
 * functions called indirectly cannot be reused
 */
static void pic_variable_alloc_indirect_proc(pfile_t *pf, pfile_proc_t *proc)
{
  variable_base_t base;
  size_t          ct;
  pfile_proc_t   *cproc;

#if 0
  printf("allocating non-reusable space for: %s\n",
      label_name_get(pfile_proc_label_get(proc)));
#endif
  if (pfile_proc_frame_sz_get(proc)) {
    base = pic_data_alloc(pf, &pic_data_bank_list, 
      pfile_proc_frame_sz_get(proc));
    pic_block_data_alloc(pf, pfile_proc_block_root_get(proc), base);
    pfile_proc_frame_set(proc, base, pf);
  }
  /* now...anything *called* by this procedure must also be allocated
   * in permanent, non-reusable store because I don't track indirect
   * references
   */ 
  for (ct = 0; (cproc = pfile_proc_calls_get(proc, ct)) != 0; ct++) {
    if (!pfile_proc_flag_test(cproc, PFILE_PROC_FLAG_VISITED)) {
      pfile_proc_flag_set(cproc, PFILE_PROC_FLAG_VISITED);
      pic_variable_alloc_indirect_proc(pf, cproc);
      /* do *not* reset the visited flag here. once an indirect function's
       * variables are set, they are never moved! */
    }
  }
}

static void pic_variable_alloc_indirect(pfile_t *pf)
{
  pfile_proc_t *proc;

  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INDIRECT)
          || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_REENTRANT)
          || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_TASK)
          || pfile_proc_flag_test(proc, PFILE_PROC_FLAG_FRAME)) {
      pic_variable_alloc_indirect_proc(pf, proc);
    }
  }
}

/* all interrupt entry points share the same variable space, so...
     1. calculate the maximum size needed
     2. allocate a single block that size
     3. divy it up appropriately
 */
static void pic_variable_alloc_isr(pfile_t *pf)
{
  variable_base_t isr_block;
  pfile_proc_t   *proc;
  size_t          sz;

  for (proc = pfile_proc_root_get(pf), sz = 0; 
       proc; 
       proc = pfile_proc_next(proc)) {
    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INTERRUPT) 
      && (sz < pfile_proc_frame_sz_get(proc))) {
      sz = pfile_proc_frame_sz_get(proc);
    }
  }

  isr_block = (sz)
    ? pic_data_alloc(pf, &pic_data_bank_list, sz)
    : VARIABLE_BASE_UNKNOWN;

  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INTERRUPT)) {
      pfile_block_t *blk;

      /* allocate all of the procedure's variables out of isr_block */
      pic_block_data_alloc(pf, pfile_proc_block_root_get(proc), isr_block);
      /* remove the AUTO flag from all of the procedure's variables */
      for (blk = pfile_proc_block_root_get(proc);
           blk;
           blk = pfile_block_next(blk)) {
        variable_t vptr;

        for (vptr = pfile_block_variable_list_head(blk);
             vptr;
             vptr = variable_link_get(vptr)) {
          variable_flag_clr(vptr, VARIABLE_FLAG_AUTO);
        }
      }
      /* recalc the frame size (should be 0) */
      pfile_proc_frame_sz_calc(proc);
      /* allocate anything called by this proc */
      pic_variable_alloc_indirect_proc(pf, proc);
    }
  }
}

static void pic_variable_alloc_volatile(pfile_t *pf)
{
  pfile_proc_t *proc;

  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    /* if this is in an interrupt routine, it will have been allocated
     * elsewhere */
    if (!pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INTERRUPT)) {
      pfile_block_t *blk;

      for (blk = pfile_proc_block_root_get(proc);
           blk;
           blk = pfile_block_next(blk)) {
        variable_t var;

        for (var = pfile_block_variable_list_head(blk);
             var;
             var = variable_link_get(var)) {
          if (variable_is_volatile(var) && variable_is_auto(var)) {
            if (variable_is_volatile(var)
                && (VARIABLE_BASE_UNKNOWN == variable_base_get(var, 0))
                && (variable_is_used(var) || variable_is_assigned(var))) {
              pic_variable_alloc_one(pf, proc, var);
              /*variable_flag_clr(var, VARIABLE_FLAG_AUTO);*/
              variable_flag_set(var, VARIABLE_FLAG_STICKY);
            }
          }
        }
      }
    }
  }
}

/* variables are allocated in an infinite memory, virtual space,
 * starting at location one. this routine maps the virtual space
 * into necessary PIC banks
 */ 
#if 1
static int vinfo_cmp(const void *A, const void *B)
{
  variable_t       a;
  variable_t       b;
  variable_base_t  a_base;
  variable_base_t  b_base;

  a = *(struct variable_ * const *) A;
  b = *(struct variable_ * const *) B;
  a_base = variable_base_get(a, 0);
  b_base = variable_base_get(b, 0);

  /* this isn't as obscure as it looks. remember relational operators
   * are guarenteed to return either 0 or 1, then work out the three
   * possibilities
   */ 
  return (a_base > b_base) - (a_base < b_base);
}

/* find the largest space available for the software stack */
static void pic_software_stack_calc(pfile_t *pf)
{
  const pic_bank_info_t *bank;

  UNUSED(pf);
  for (bank = pic_data_bank_list; bank; bank = bank->link) {
    size_t sz;

    sz = (bank->hi - bank->lo + 1);
    if (sz > pic_stk_sz) {
      pic_stk_sz = sz;
      pic_stk_base = bank->lo + sz;
    }
  }
}

static void pic_variable_alloc_fixup(pfile_t *pf)
{
  struct {
    size_t      used;
    size_t      alloc;
    struct variable_ **data;
  } vinfo;
  pfile_proc_t *proc;
  size_t        ii;

  vinfo.used  = 0;
  vinfo.alloc = 0;
  vinfo.data  = 0;
  /* first, find each allocated variable */
  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    pfile_block_t *blk;

    for (blk = pfile_proc_block_root_get(proc);
         blk;
         blk = pfile_block_next(blk)) {
      variable_t vptr;

      for (vptr = pfile_block_variable_list_head(blk);
           vptr;
           vptr = variable_link_get(vptr)) {
        if (variable_is_auto(vptr)
            && !variable_is_sticky(vptr)
            && (VARIABLE_BASE_UNKNOWN != variable_base_get(vptr, 0))) {
          if (vinfo.used == vinfo.alloc) {
            size_t resize;
            void  *tmp;

            resize = (vinfo.alloc) ? 2 * vinfo.alloc : 1024;
            tmp    = REALLOC(vinfo.data, sizeof(*vinfo.data) * resize);
            if (tmp) {
              vinfo.alloc = resize;
              vinfo.data  = tmp;
            }
          }
          if (vinfo.used < vinfo.alloc) {
            vinfo.data[vinfo.used] = vptr;
            vinfo.used++;
          }
        }
      }
    }
  }
  /* sort the variables by position */
  qsort(vinfo.data, vinfo.used, sizeof(*vinfo.data), vinfo_cmp);
  /* finally, put the variables in their correct positions. find the
   * largest variable at each position, allocate that much space, then
   * set the base of all affected variables
   */
  ii = 0;
  while (ii < vinfo.used) {
    size_t          jj;
    size_t          sz_reqd; /* largest size required at position */
    variable_base_t base;

    sz_reqd = variable_sz_get(vinfo.data[ii]);
    for (jj = ii + 1;
         (jj < vinfo.used) 
         && (variable_base_get(vinfo.data[ii], 0) 
           == variable_base_get(vinfo.data[jj], 0));
         jj++) {
      size_t vsz;

      vsz = variable_sz_get(vinfo.data[jj]);
      if (vsz > sz_reqd) {
        sz_reqd = vsz;
      }
    }
    base = pic_data_alloc(pf, &pic_data_bank_list, sz_reqd);
    if (VARIABLE_BASE_UNKNOWN == base) {
      pfile_log(pf, PFILE_LOG_ERR, "Out of data space!");
      break; /* no use to continue! */
    } else {
      pfile_log(pf, PFILE_LOG_DEBUG, "register %u mapped to %u",
          variable_base_get(vinfo.data[ii], 0),
          base);
      while (ii < jj) {
        variable_base_set(vinfo.data[ii], base, 0);
        ii++;
      }
    }
  }
  /* printf("Total variables: %u\n", vinfo.used); */
  FREE(vinfo.data);
  pic_software_stack_calc(pf);
}

/* allocate variables but don't allow data space re-use */
static void pic_variable_alloc_no_reuse(pfile_t *pf)
{
  pfile_proc_t *proc;
  boolean_t     err;

  err = BOOLEAN_FALSE;
  for (proc = pfile_proc_root_get(pf);
       proc && !err;
       proc = pfile_proc_next(proc)) {
    pfile_block_t *blk;

    for (blk = pfile_proc_block_root_get(proc);
         blk && !err; 
         blk = pfile_block_next(blk)) {
      variable_t vptr;

      for (vptr = pfile_block_variable_list_head(blk);
           vptr && !err;
           vptr = variable_link_get(vptr)) {
        if (variable_is_auto(vptr)
            && !variable_is_sticky(vptr)) {
          variable_base_t base;

          base = pic_data_alloc(pf, &pic_data_bank_list, 
            variable_sz_get(vptr));
          if (VARIABLE_BASE_UNKNOWN == base) {
            pfile_log(pf, PFILE_LOG_ERR, "Out of data space!");
            err = BOOLEAN_TRUE;
          } else {
            variable_base_set(vptr, base, 0);
          }
        }
      }
    }
  }
  pic_software_stack_calc(pf);
}
#endif

/*
 * For all variables, set or clear the SHARED flag
 * as appropriate. Formerly this was done during variable allocation,
 * but then it missed variables hand placed in a region marked
 * "SHARED"
 */
static void pic_variable_shared_set(pfile_t *pf)
{
  pfile_proc_t *proc;

  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    pfile_block_t *blk;

    for (blk = pfile_proc_block_root_get(proc);
         blk;
         blk = pfile_block_next(blk)) {
      variable_t vptr;

      for (vptr = pfile_block_variable_list_head(blk);
          vptr;
          vptr = variable_link_get(vptr)) {
        if (!variable_master_get(vptr)) {
          variable_base_t base;

          base = variable_base_get(vptr, 0);
          if (VARIABLE_BASE_UNKNOWN != base) {
            pic_bank_info_t *bank;

            for (bank = pic_shared_bank_list;
                 bank && !((bank->lo <= base) && (base <= bank->hi));
                 bank = bank->link)
              ;
            if (bank && ((base + variable_sz_get(vptr) - 1U) <= bank->hi)) {
              variable_flag_set(vptr, VARIABLE_FLAG_SHARED);
            }
          }
        }
      }
    }
  }
}

void pic_variable_alloc(pfile_t *pf)
{
  pfile_proc_t *proc;

  blist_total();
  pfile_log(pf, PFILE_LOG_DEBUG, PIC_MSG_ALLOCATING_VARS);

  /* make sure the frame sizes are correct. currently only re-entrant
   * functions create an extra variable but that may change */

  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    pfile_proc_frame_sz_calc(proc);
  }
  /* remove any preset variables */
  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    pfile_block_t *blk;

    for (blk = pfile_proc_block_root_get(proc);
         blk;
         blk = pfile_block_next(blk)) {
      variable_t    vptr;

      for (vptr = pfile_block_variable_list_head(blk);
           vptr; 
           vptr = variable_link_get(vptr)) {
        if (!variable_master_get(vptr)
            && (VARIABLE_BASE_UNKNOWN != variable_base_get(vptr, 0))) {
          variable_base_t base;

          if (variable_sz_get(vptr)) {
            size_t ii;

            for (ii = 0; ii < VARIABLE_MIRROR_CT; ii++) {
              base = variable_base_get(vptr, ii);
              if (VARIABLE_BASE_UNKNOWN != base) {
                pic_blist_remove(pf, &pic_data_bank_list, base, 
                  variable_sz_get(vptr));
              }
            }
          }
        }
      }
    }
  }
  pic_stvar_fixup(pf);
  pic_variable_alloc_volatile(pf);
  pic_variable_alloc_isr(pf);
  pic_variable_alloc_indirect(pf);
  /* finally, allocate some variables! */
#if 0
  {
    variable_array_t *live;
    variable_array_t *all_vars;
    variable_array_t *allocated_vars;
    size_t            ii;

    live     = variable_array_alloc(0);
    all_vars = variable_array_alloc(0);
    allocated_vars = variable_array_alloc(0);
    pic_variable_interfer_proc(pf, pfile_proc_root_get(pf), live,
      all_vars);
    assert(0 == variable_array_entry_ct(live));
    variable_array_free(live);
    printf("Total variables: %u\n", 
      (unsigned) variable_array_entry_ct(all_vars));
    while (variable_array_entry_ct(all_vars)) {
      size_t jj;

      ii = variable_array_entry_ct(all_vars) - 1;
      /* allocate all variables that are live with this one */
      live = variable_interference_get(
        *variable_array_entry_get(all_vars, ii));
      printf("Allocating: %s (%u interfer)\n",
        variable_name_get(*variable_array_entry_get(all_vars, ii)),
        variable_array_entry_ct(live));
      for (jj = 0; jj < variable_array_entry_ct(live); jj++) {
        variable_t var;

        var = *variable_array_entry_get(live, jj);
        if (VARIABLE_BASE_UNKNOWN == variable_base_get(var, 0)) {
          variable_base_t base;

          base = pic_data_alloc(pf, &pic_data_bank_list, variable_sz_get(var));
          if (VARIABLE_BASE_UNKNOWN == base) {
#if 0
            pfile_log(pf, PFILE_LOG_ERR, "out of data space: %s",
              variable_name_get(var));
#endif
          } else {
            variable_base_set(var, base, 0);
            variable_array_entry_add(allocated_vars, &var,
              ARRAY_ADD_FLAG_NONE, variable_unique_cmp, 0);
          }
        }
      }
      /* and free all of the space for re-use */
      while (variable_array_entry_ct(allocated_vars)) {
        variable_t      var;
        variable_base_t base;
        size_t          ix;

        ix = variable_array_entry_ct(allocated_vars) - 1;

        var  = *variable_array_entry_get(allocated_vars, ix);
        base = variable_base_get(var, 0);

        pic_blist_add(pf, &pic_data_bank_list, base,
          base + variable_sz_get(var) - 1);
        variable_array_entry_remove(allocated_vars, ix);
      }
      variable_array_entry_remove(all_vars, ii);
    }
    variable_array_free(all_vars);
  }
#else
  if (pfile_flag_test(pf, PFILE_FLAG_OPT_VARIABLE_REUSE)) {
    pic_variable_alloc_proc(pf, pfile_proc_root_get(pf));
    pic_variable_alloc_fixup(pf);
  } else {
    pic_variable_alloc_no_reuse(pf);
  }
#endif
  pic_variable_shared_set(pf);
  pfile_log(pf, PFILE_LOG_DEBUG, PIC_MSG_DBG_DATA_USED, pic_blist_max);
}

void pic_blist_info_log(pfile_t *pf)
{
  UNUSED(pf);

#if 0
  pic_bank_info_t *bank;
  unsigned         total_avail;
  unsigned         total_used;
  unsigned         ct;

  for (ct = 0, total_used = 0, total_avail = 0, bank = pic_blist;
       bank;
       ct++, total_used += bank->next - bank->lo, 
         total_avail += bank->hi + 1 - bank->lo, bank = bank->link)
    ;
  pfile_log(pf, PFILE_LOG_INFO, PIC_MSG_DATA_USED,
      total_used, total_avail);
#endif
}

void pic_blist_free(pfile_t *pf)
{
  UNUSED(pf);

  while (pic_data_bank_list) {
    pic_bank_info_t *bank;

    bank = pic_data_bank_list->link;
    FREE(pic_data_bank_list);
    pic_data_bank_list = bank;
  }
}

pic_bank_info_t *pic_bank_info_get(pfile_t *pf)
{
  UNUSED(pf);

  return pic_data_bank_list;
}

