/**********************************************************
 **
 ** variable.c : manipulators for variable_t
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <assert.h>
#include <math.h>
#include <string.h>
#include "../libutils/mem.h"
/*#include "../libutils/array.h"*/
#include "pf_proc.h"
#include "vararray.h"
#include "variable.h"

static unsigned variable_id;

typedef struct variable_ref_ {
  variable_t var;
  refct_t    ref_ct;
} variable_ref_t;
#define VARIABLE_REF_NONE ((variable_ref_t *) 0)

struct variable_ {
  variable_t         link;
  refct_t            ref_ct;

  unsigned           id;

  tag_t              tag;
  unsigned           tag_n;

  flag_t             flags;
  variable_def_t     def;       /* the variable's definition  */
  variable_base_t    base[VARIABLE_MIRROR_CT];
                                /* base position, or offset from
                                   master's base position     */
  unsigned short     bit_offset;/* bit #                      */
  ctr_t              ctr_assign;/* # of times assigned        */
  ctr_t              ctr_use;   /* # of times used            */
  unsigned char     *data;      /* misc. data; size = ct * sz */
  struct {
    float            single;
    float           *array;
  } cflt;

  /* if this is an alias, master points to the controlling variable */
  variable_t         master;
  /* for functions this is the destination */
  pfile_proc_t      *proc;
  label_t            lbl;
  value_t            val; /* for whereis(val) */

  const char        *name;

  void              *user_data;

  array_t           *used_by;  /* variables used by this one */
  array_t           *uses;     /* variables this one uses    */
  variable_array_t  *interference;
};

static cache_t variable_cache;
static boolean_t variable_cache_is_init;

static void variable_cache_cleanup(void)
{
#if 0
  unsigned n;

  for (n = 1; n < variable_cache.next; n++) {
    struct variable_ *ptr;

    ptr = cache_element_seek(&variable_cache, n, BOOLEAN_FALSE);
    if (ptr->ref_ct != (refct_t) 0xefbe) {
      printf("var leaked: %u (refct = %u)\n", n, ptr->ref_ct);
    }
  }
#endif
  cache_cleanup(&variable_cache);
}

static variable_t variable_element_alloc(void)
{
  if (!variable_cache_is_init) {
    variable_cache_is_init = BOOLEAN_TRUE;
    atexit(variable_cache_cleanup);
    (void) cache_init(&variable_cache, sizeof(struct variable_), "variable");
  }
  return cache_element_alloc(&variable_cache);
}

static struct variable_ *variable_element_seek(variable_t el, boolean_t mod)
{
  struct variable_ *ptr;

  ptr  = cache_element_seek(&variable_cache, el, mod);
  return ptr;
}

/* basic functions */
variable_t variable_alloc(tag_t tag, variable_def_t def)
{
  variable_t var;

  var = variable_element_alloc();
  if (var) {
    struct variable_ *ptr;
    size_t            data_sz;

    ptr = variable_element_seek(var, BOOLEAN_TRUE);

    ptr->id = ++variable_id;
    if (tag) {
      tag_lock(tag);
      ptr->tag = tag;
      ptr->tag_n = tag_n_get(tag);
      tag_n_bump(tag);
    } else {
      ptr->tag   = 0;
      ptr->tag_n = 0;
    }

    ptr->data        = 0;
    ptr->cflt.single = 0.0;
    ptr->cflt.array  = 0;
    data_sz = (variable_def_flag_test(def, VARIABLE_DEF_FLAG_CONST))
      ? variable_def_sz_get(def) : 0;
    if (data_sz && var) {
      ptr->data = MALLOC(data_sz);
      if (!ptr->data) {
        var = VARIABLE_NONE;
      } else {
	      memset(ptr->data, 0, data_sz);
	    }
      if ((VARIABLE_DEF_TYPE_ARRAY == variable_def_type_get(def)
        && (VARIABLE_DEF_TYPE_FLOAT == variable_def_type_get(
          variable_def_member_def_get(variable_def_member_get(def)))))) {
        size_t ct;

        ct = variable_def_member_ct_get(variable_def_member_get(def));
        ptr->cflt.array = MALLOC(ct * sizeof(*ptr->cflt.array));
        if (ptr->cflt.array) {
          while (ct--) {
            ptr->cflt.array[ct] = 0.0;
          }
        }
      }
    }

    if (var) {
      size_t ii;

      ptr->link       = VARIABLE_NONE;
      ptr->ref_ct     = 1;
      ptr->flags      = VARIABLE_FLAG_NONE;

      ptr->def        = def;
      for (ii = 0; ii < VARIABLE_MIRROR_CT; ii++) {
        ptr->base[ii] = VARIABLE_BASE_UNKNOWN;
      }
      ptr->bit_offset = 0;
      ptr->ctr_assign = 0;
      ptr->ctr_use    = 0;
      ptr->master     = VARIABLE_NONE;
      ptr->proc       = PFILE_PROC_NONE;
      ptr->lbl        = LABEL_NONE;
      ptr->name       = tag_name_get(tag);
      ptr->user_data  = 0;
      ptr->uses       = array_alloc(0, sizeof(variable_ref_t));
      ptr->used_by    = array_alloc(0, sizeof(variable_ref_t));
      ptr->interference  = variable_array_alloc(0);
    }
  }
  return var;
}

void variable_release(variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr && !--ptr->ref_ct) { 
    variable_master_set(var, VARIABLE_NONE);
    ptr = variable_element_seek(var, BOOLEAN_TRUE);
    array_free(ptr->used_by);
    array_free(ptr->uses);
    variable_array_free(ptr->interference);
    variable_data_set(var, 0);
    variable_label_set(var, LABEL_NONE);
    tag_release(ptr->tag);
    cache_element_free(&variable_cache, var);
    FREE(ptr->cflt.array);
  }
}

void variable_lock(variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ptr->ref_ct++;
  }
}

/* member retrieval */
boolean_t variable_dflag_test(const variable_t var, flag_t flags)
{
  return variable_def_flag_test(variable_def_get(var), flags);
}

flag_t variable_dflags_get_all(const variable_t var)
{
  return variable_def_flags_get_all(variable_def_get(var));
}

void variable_flag_set(variable_t var, flag_t flags)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags |= flags;
  }
}

void variable_flag_clr(variable_t var, flag_t flags)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags &= ~flags;
  }
}

boolean_t variable_flag_test(const variable_t var, flag_t flags)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ((ptr->flags & flags) == flags) : 0; /* BOOLEAN_FALSE; */
}

boolean_t variable_is_shared(const variable_t var)
{
  variable_t vptr;

  vptr = var;
  while (variable_master_get(vptr)) {
    vptr = variable_master_get(vptr);
  }
  return variable_flag_test(vptr, VARIABLE_FLAG_SHARED);
}

const char *variable_name_get(const variable_t var)
{
  struct variable_ *ptr;
  const char       *name;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  name = (ptr) ? tag_name_get(ptr->tag) : 0;
  if (ptr && !name) {
    name = variable_name_get(variable_master_get(var));
  }
  return name;
}

unsigned variable_tag_n_get(const variable_t var)
{
  struct variable_ *ptr;
  const char       *name;
  unsigned          n;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  name = (ptr) ? tag_name_get(ptr->tag) : 0;

  if (ptr && !name) {
    n = variable_tag_n_get(variable_master_get(var));
  } else if (ptr) {
    n = ptr->tag_n;
  } else {
    n = 0;
  }
  return n;
}

variable_sz_t   variable_sz_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? variable_def_sz_get(ptr->def): 0;
}

variable_base_t variable_base_real_get(const variable_t var, size_t which)
{
  struct variable_ *ptr;
  variable_base_t   base;

  ptr  = variable_element_seek(var, BOOLEAN_FALSE);
  base = VARIABLE_BASE_UNKNOWN;
  if (ptr && (which < VARIABLE_MIRROR_CT)) {
    base = ptr->base[which];
  }
  return base;
}

variable_base_t variable_base_get(variable_t var, size_t which)
{
  variable_base_t base;

  base = VARIABLE_BASE_UNKNOWN;
  do {
    variable_base_t mbase;

    mbase = variable_base_real_get(var, which);
    if (VARIABLE_BASE_UNKNOWN != mbase) {
      if (VARIABLE_BASE_UNKNOWN == base) {
        base = mbase;
      } else {
        base += mbase;
      }
    }
    var = variable_master_get(var);
  } while (var);
  return base;
}

void variable_base_set(variable_t var, variable_base_t base, size_t which)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    if (which < VARIABLE_MIRROR_CT) {
      ptr->base[which] = base;
    }
  }
}

variable_const_t variable_const_get(const variable_t var, 
    variable_def_t def, size_t ofs)
{
  struct variable_ *ptr;
  variable_const_t  n;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  if (ptr && ptr->data) {
    size_t           ii;
    size_t           pos_mx;

    if (variable_dflag_test(var, VARIABLE_DEF_FLAG_BIT)) {
      pos_mx = (variable_sz_get(var) + 7) / 8;
    } else {
      pos_mx = variable_sz_get(var);
    }

    for (ii = 0, n = 0; (ii < variable_def_sz_get(def)); ii++) {
      /*n <<= 8UL;*/
      if (ofs + ii < pos_mx) {
        n |= ptr->data[ofs + ii] << (8 * ii);
      }
    }
    if (variable_def_flag_test(def, VARIABLE_DEF_FLAG_SIGNED)) {
      if ((ii < sizeof(n)) && (n & (1UL << ((8 * ii) - 1)))) {
        /* we need to extend the signed bit here! */
        while (ii < sizeof(n)) {
          n |= 255UL << (8 * ii);
          ii++;
        }
      }
    }
  } else {
    n = 0;
  }
  return n;
}

void variable_const_set(variable_t var, variable_def_t vdef,
    size_t ofs, variable_const_t n)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr && ptr->data) {
    size_t ii;
    size_t ofs_mx;

    if (variable_dflag_test(var, VARIABLE_DEF_FLAG_BIT)) {
      ofs_mx = (variable_sz_get(var) + 7) / 8;
      if (VARIABLE_DEF_TYPE_BOOLEAN == variable_type_get(var)) {
        n = !!n;
      } else {
        n &= (1 << variable_sz_get(var)) - 1;
      }
      if (variable_is_signed(var)
        && (n & (1 << (variable_sz_get(var) - 1)))) {
        /* high bit is set, so negate n */
        n = -n;
      }
    } else {
      ofs_mx = variable_sz_get(var);
    }
    for (ii = 0; ii < variable_def_sz_get(vdef); ii++) {
      if (ofs + ii < ofs_mx) {
        ptr->data[ofs + ii] = (uchar) (n & 0xff);
      }
      n >>= 8;
    }
  }
}

float variable_const_float_get(const variable_t var, size_t ofs)
{
  struct variable_ *ptr;
  float             f;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  f   = 0.0;
  if (ptr && ptr->data) {
    if (variable_is_array(var)) {
      assert((ofs % 4) == 0);
      f = ptr->cflt.array[ofs / 4];
    } else {
      assert(0 == ofs);
      f = ptr->cflt.single;
    }
  }
  return f;
}

void variable_const_float_set(variable_t var, size_t ofs, float n)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr && ptr->data) {
    int           e;
    unsigned long mantissa;

    /* 
     * convert the floating point to data. I don't know that
     * all compilers use IEEE754 (though it appears to be
     * required by the C9x standard), and don't know if some
     * are little or big endian, so I convert manually here
     * using frexp(), and assuming little endiant:
     *   m0 m1 m2:exp0 exp1..exp7:sign
     */
    if (variable_is_array(var)) {
      assert((ofs % 4) == 0);
      ptr->cflt.array[ofs/4] = n;
    } else {
      assert(0 == ofs);
      ptr->cflt.single = n;
    }
    if (n == 0) {
      mantissa = 0;
    } else {
      mantissa = ((unsigned long) (0x01000000UL * frexp(fabs(n), &e))) 
        & 0x007fffffUL;
      mantissa = mantissa | ((e + 0x7eUL) << 23);
      if (n < 0) {
        mantissa = mantissa | 0x80000000;
      }
    }
    ptr->data[ofs]   = (mantissa      ) & 0xff;
    ptr->data[ofs+1] = (mantissa >>  8) & 0xff;
    ptr->data[ofs+2] = (mantissa >> 16) & 0xff;
    ptr->data[ofs+3] = (mantissa >> 24);
  }
}

void variable_dump(const variable_t var, FILE *out)
{
  const char *fmt;

#if 0
  fprintf(out, "{%lx:", (unsigned long) var);
#else
  fprintf(out, "{");
#endif
  if (VARIABLE_DEF_TYPE_POINTER == variable_type_get(var)) {
    fputc('*', out);
  }
  if (variable_name_get(var)) {
    fmt = (variable_tag_n_get(var)) ? "__%s_%u" : "%s";
    fprintf(out, fmt, variable_name_get(var), variable_tag_n_get(var));
  } else {
    variable_t master;

    master = variable_master_get(var);
    if (variable_name_get(master)) {
      fmt = (variable_tag_n_get(var)) ? "__%s_%u" : "%s";
      fprintf(out, fmt, variable_name_get(master), 
          variable_tag_n_get(master));
    }
  }
  fprintf(out, "[%c%c%c%c%s%u]", 
      variable_def_type_to_ch(variable_type_get(var)), 
      variable_dflag_test(var, VARIABLE_DEF_FLAG_CONST) ? 'C' : '-',
      variable_dflag_test(var, VARIABLE_DEF_FLAG_VOLATILE) ? 'V' : '-',
      variable_dflag_test(var, VARIABLE_DEF_FLAG_SIGNED) ? 'S' : '-',
    variable_dflag_test(var, VARIABLE_DEF_FLAG_BIT) ? ":" : "",
    variable_sz_get(var));
  if (variable_is_const(var)) {
    fmt = (variable_dflag_test(var, VARIABLE_DEF_FLAG_SIGNED))
      ? "%ld" : "%lu";
    fprintf(out, fmt, variable_const_get(var, variable_def_get(var), 0));
  }
  fputc('}', out);
}

refct_t variable_refct_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->ref_ct : 0;
}

variable_t variable_link_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->link : 0;
}

void variable_link_set(variable_t var, variable_t link)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ptr->link = link;
  }
}

ctr_t variable_assign_ct_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->ctr_assign : 0;
}

void variable_assign_ct_set(variable_t var, ctr_t ctr)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ptr->ctr_assign = ctr;
  }
}

void variable_assign_ct_bump(variable_t var, ctr_bump_t dir)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    switch (dir) {
      case CTR_BUMP_INCR: 
        ptr->ctr_assign++; 
        break;
      case CTR_BUMP_DECR: 
        if (ptr->ctr_assign) {
          ptr->ctr_assign--; 
        } else {
          /*fprintf(stderr, "%s: assign is 0\n", variable_name_get(var));*/
        }
        break;
    }
    if (ptr->master) {
      variable_assign_ct_bump(ptr->master, dir);
    }
  }
}

ctr_t variable_use_ct_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->ctr_use : 0;
}

void variable_use_ct_set(variable_t var, ctr_t ctr)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ptr->ctr_use = ctr;
  }
}

void variable_use_ct_bump(variable_t var, ctr_bump_t dir)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    switch (dir) {
      case CTR_BUMP_INCR: 
        ptr->ctr_use++; 
        break;
      case CTR_BUMP_DECR: 
        if (ptr->ctr_use) {
          ptr->ctr_use--; 
        } else {
          /*fprintf(stderr, "%s:%u use is 0\n", variable_name_get(var),
              variable_tag_n_get(var));*/
        }
        break;
    }
    if (ptr->master) {
      variable_use_ct_bump(ptr->master, dir);
    }
  }
}

ctr_t variable_ref_ct_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->ref_ct : 0;
}

void variable_list_init(varlist_t *lst)
{
  lst->head = 0;
  lst->tail = 0;
  lst->ct   = 0;
}

void variable_list_append(varlist_t *lst, variable_t var)
{
  variable_lock(var);

  if (lst->tail) {
    variable_link_set(lst->tail, var);
  } else {
    lst->head = var;
  }
  lst->tail = var;
  lst->ct++;
}

variable_t variable_list_find(varlist_t *lst, varfind_cb_t cb, void *cb_arg,
    const void *data)
{
  variable_t var;

  for (var = lst->head;
       var && !cb(cb_arg, var, data);
       var = variable_link_get(var))
    ;
  if (var) {
    variable_lock(var);
  }
  return var;
}

#if 0
/* nb : with the introduction of master variables (aka, aliases)
        it's necessary to run through the list *twice* to find
        if there's a leak */
static void variable_leak_test(variable_t var, pfile_t *pf)
{
  if (variable_refct_get(var) > 1) {
    if (variable_name_get(var)) {
      pfile_log(pf, PFILE_LOG_DEBUG, PFILE_MSG_DBG_VAR_LEAK, 
          var, variable_refct_get(var), variable_name_get(var));
    } else {
      pfile_log(pf, PFILE_LOG_DEBUG, PFILE_MSG_DBG_CONST_LEAK, 
          var, variable_refct_get(var), 
          variable_const_get(var, variable_def_get(var), 0));
    }
  }
}
#endif

void variable_list_reset(varlist_t *lst)
{
  variable_t var;

  /* first, set all of the masters to 0 */
  for (var = lst->head;
       var;
       var = variable_link_get(var)) {
    variable_master_set(var, VARIABLE_NONE);
  }
  while (lst->head) {
    var = lst->head;
    lst->head = variable_link_get(var);
    /*variable_leak_test(var, pf);*/
    variable_release(var);
  }
  lst->tail = 0;
  lst->ct = 0;
}

size_t variable_list_ct_get(const varlist_t *lst)
{
  return (lst) ? lst->ct : 0;
}

variable_t variable_list_head(varlist_t *lst)
{
  return lst->head;
}

variable_def_t variable_def_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->def : 0;
}

void variable_def_set(variable_t var, variable_def_t def)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ptr->def = def;
  }
}

/* given a constant, n, determine the smallest variable size
   that will hold it */
void variable_calc_sz_min(variable_const_t n, 
  variable_sz_t *psz, variable_def_type_t *ptype,
  flag_t *pflags)
{
  unsigned char       n0, n1, n2, n3;
  variable_sz_t       sz;
  variable_def_type_t type;
  flag_t              flags;


  n0 = (uchar) ((n      ) & 0xff);
  n1 = (uchar) ((n >>  8) & 0xff);
  n2 = (uchar) ((n >> 16) & 0xff);
  n3 = (uchar) ((n >> 24) & 0xff);
  sz = 4;
  type  = VARIABLE_DEF_TYPE_INTEGER;
  flags = VARIABLE_DEF_FLAG_NONE;
  if (0 == n3) {
    sz--;
    if (0 == n2) {
      sz--;
      if (0 == n1) {
        sz--;
      }
    }
  } else if ((0xff == n3) && (n2 & 0x80)) {
    /* the code generator will sign extend as necessary, so we'll
       pretend that this value is signed */
    flags |= VARIABLE_DEF_FLAG_SIGNED;
    sz--;
    if ((0xff == n2) && (n1 & 0x80)) {
      sz--;
      if ((0xff == n1) && (n0 & 0x80)) {
        sz--;
      }
    }
  }
  if (psz) {
    *psz = sz;
  }
  if (ptype) {
    *ptype = type;
  }
  if (pflags) {
    *pflags = flags;
  }
}

void variable_bit_offset_set(variable_t var, ushort bit)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ptr->bit_offset = bit;
  }
}

unsigned variable_bit_offset_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->bit_offset : 0;
}

variable_t variable_master_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->master : 0;
}

static void variable_master_counters_adjust(variable_t var,
    ctr_t ctr_assign, ctr_t ctr_use)
{
  while (var) {
    struct variable_ *ptr;

    ptr = variable_element_seek(var, BOOLEAN_TRUE);
    ptr->ctr_assign += ctr_assign;
    ptr->ctr_use    += ctr_use;
    var = variable_master_get(var);
  }
}

void variable_master_set(variable_t var, variable_t master)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ctr_t ctr_assign;
    ctr_t ctr_use;

    ctr_assign = variable_assign_ct_get(var);
    ctr_use    = variable_use_ct_get(var);

    variable_master_counters_adjust(
        variable_master_get(var), -ctr_assign, -ctr_use);
    /* now, remove the master */
    variable_lock(master);
    ptr = variable_element_seek(var, BOOLEAN_TRUE);
    variable_release(ptr->master);
    ptr = variable_element_seek(var, BOOLEAN_TRUE);
    ptr->master = master;
    if (master && (VARIABLE_BASE_UNKNOWN == ptr->base[0])) {
      ptr->base[0] = 0;
    }
    variable_master_counters_adjust(master, ctr_assign, ctr_use);
  }
}

variable_def_type_t variable_type_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? variable_def_type_get(ptr->def) : VARIABLE_DEF_TYPE_NONE;
}

pfile_proc_t *variable_proc_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->proc : PFILE_PROC_NONE;
}

void variable_proc_set(variable_t var, pfile_proc_t *proc)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ptr->proc = proc;
  }
}

value_t variable_value_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->val : VALUE_NONE;
}

void variable_value_set(variable_t var, value_t val)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    value_lock(val);
    value_release(ptr->val);
    ptr->val = val;
  }
}

label_t variable_label_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->lbl : LABEL_NONE;
}

void variable_label_set(variable_t var, label_t lbl)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    label_lock(lbl);
    label_usage_bump(ptr->lbl, CTR_BUMP_DECR);
    label_release(ptr->lbl);
    label_usage_bump(lbl, CTR_BUMP_INCR);
    ptr->lbl = lbl;
  }
}

boolean_t variable_is_float(const variable_t var)
{
  return VARIABLE_DEF_TYPE_FLOAT == variable_type_get(var);
}

boolean_t variable_is_function(const variable_t var)
{
  return VARIABLE_DEF_TYPE_FUNCTION == variable_type_get(var);
}

boolean_t variable_is_bit(const variable_t var)
{
  return variable_dflag_test(var, VARIABLE_DEF_FLAG_BIT);
}

boolean_t variable_is_pointer(const variable_t var)
{
  return VARIABLE_DEF_TYPE_POINTER == variable_type_get(var);
}

boolean_t variable_is_volatile(const variable_t var)
{
  return variable_dflag_test(var, VARIABLE_DEF_FLAG_VOLATILE);
}

boolean_t variable_is_signed(const variable_t var)
{
  return variable_dflag_test(var, VARIABLE_DEF_FLAG_SIGNED);
}

boolean_t variable_is_alias(const variable_t var)
{
  return variable_flag_test(var, VARIABLE_FLAG_ALIAS);
}

boolean_t variable_is_auto(const variable_t var)
{
  return variable_flag_test(var, VARIABLE_FLAG_AUTO);
}

boolean_t variable_is_sticky(const variable_t var)
{
  return variable_flag_test(var, VARIABLE_FLAG_STICKY);
}

boolean_t variable_is_lookup(const variable_t var)
{
  return variable_flag_test(var, VARIABLE_FLAG_LOOKUP);
}

boolean_t variable_is_const(const variable_t var)
{
  return variable_dflag_test(var, VARIABLE_DEF_FLAG_CONST);
}

boolean_t variable_is_pseudo_const(const variable_t var)
{
  boolean_t rc;

  rc = variable_is_const(var);
  if (!rc) {
    if (variable_master_get(var)) {
      rc = variable_is_pseudo_const(variable_master_get(var));
    } else {
      rc = !(variable_is_volatile(var) || variable_assign_ct_get(var));
    }
  }
  return rc;
}

boolean_t variable_is_array(const variable_t var)
{
  return VARIABLE_DEF_TYPE_ARRAY == variable_type_get(var);
}

/* a variable is assigned if it's volatile and used,
 * or if any of it's masters are assigned */
boolean_t variable_is_assigned(const variable_t var)
{
  boolean_t  rc;
  variable_t tvar;

  for (tvar = var, rc = BOOLEAN_FALSE;
       tvar && !rc;
       tvar = variable_master_get(tvar)) {
    rc = 0 != variable_assign_ct_get(tvar);
    if (!rc && variable_is_volatile(tvar)) {
      rc = 0 != variable_use_ct_get(tvar);
    }
  }
  return rc;
}

/* a variable is used if it's volatile and assigned,
 * or if any of it's masters are used */
boolean_t variable_is_used(const variable_t var)
{
  boolean_t rc;
  variable_t tvar;

  for (tvar = var, rc = BOOLEAN_FALSE;
       tvar && !rc;
       tvar = variable_master_get(tvar)) {
    rc = 0 != variable_use_ct_get(tvar);
    if (!rc && variable_is_volatile(tvar)) {
      rc = 0 != variable_assign_ct_get(tvar);
    }
  }
  return rc;
}

void variable_data_set(variable_t var, void *x)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    if (ptr->data != x) {
      FREE(ptr->data);
    }
    ptr->data = x;
  }
}

void *variable_data_get(const variable_t var)
{
  const struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->data : 0;
}

variable_t variable_map_find(const variable_map_t *map, variable_t var)
{
  variable_t ret;

  if (!var) {
    ret = var;
  } else {
    size_t ii;

    for (ii = 0; (ii < map->used) && (map->map[ii].old != var); ii++)
      ;
    ret = (ii < map->used) ? map->map[ii].new : VARIABLE_NONE;
  }
#if 0
  if (ret) {
    printf("variable remap %s:%u --> %s:%u\n",
        variable_name_get(var), variable_tag_n_get(var),
        variable_name_get(ret), variable_tag_n_get(ret));
  }
#endif
  return ret;
}

flag_t variable_flags_get_all(variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->flags : 0;
}

void variable_flags_set_all(variable_t var, flag_t flags)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags = flags;
  }
}

void  variable_user_data_set(variable_t var, void *data)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    ptr->user_data = data;
  }
}

void *variable_user_data_get(const variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->user_data : 0;
}

static variable_ref_t *variable_ref_find(array_t *array, variable_t var)
{
  size_t          ii;
  variable_ref_t *fnd;

  fnd = VARIABLE_REF_NONE;
  for (ii = 0; ii < array_ct(array); ii++) {
    variable_ref_t *ref;

    ref = array_get(array, ii);
    if (ref->var == var) {
      fnd = ref;
      break;
    }
  }
  return fnd;
}

static void variable_ref_add(array_t *array, variable_t var)
{
  variable_ref_t *fnd;

  fnd = variable_ref_find(array, var);
  if (fnd) {
    fnd->ref_ct++;
  } else {
    variable_ref_t new_ref;

    new_ref.var    = var;
    new_ref.ref_ct = 1;
    (void) array_append(array, &new_ref);
  }
}

static void variable_ref_remove(array_t *array, variable_t var)
{
  variable_ref_t *fnd;

  fnd = variable_ref_find(array, var);
  if (fnd) {
    assert(fnd->ref_ct > 0);
    if (fnd->ref_ct > 0) {
      fnd->ref_ct--;
    }
  }
}

static void variable_used_by_add(variable_t var, variable_t uses)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    variable_ref_add(ptr->used_by, uses);
  }
}

static void variable_used_by_remove(variable_t var, variable_t uses)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  if (ptr) {
    variable_ref_remove(ptr->used_by, uses);
  }
}

variable_t variable_used_by_get(variable_t var, size_t ix)
{
  struct variable_ *ptr;
  variable_ref_t   *ref;

  ptr = variable_element_seek(var, BOOLEAN_TRUE);
  ref = VARIABLE_REF_NONE;
  if (ptr) {
    ref = array_get(ptr->used_by, ix);
  }
  return (ref) ? ref->var : VARIABLE_NONE;
}

void variable_uses_add(variable_t var, variable_t uses)
{
  if ((VARIABLE_NONE != var) && (VARIABLE_NONE != uses)) {
    struct variable_ *ptr;

    ptr = variable_element_seek(var, BOOLEAN_TRUE);
    if (ptr) {
      variable_ref_add(ptr->uses, uses);
      variable_used_by_add(uses, var);
    }
  }
}

void variable_uses_remove(variable_t var, variable_t uses)
{
  if ((VARIABLE_NONE != var) && (VARIABLE_NONE != uses)) {
    struct variable_ *ptr;

    ptr = variable_element_seek(var, BOOLEAN_TRUE);
    if (ptr) {
      variable_ref_remove(ptr->uses, uses);
      variable_used_by_remove(uses, var);
    }
  }
}

variable_t variable_uses_get(variable_t var, size_t ix)
{
  struct variable_ *ptr;
  variable_ref_t   *ref;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  ref = VARIABLE_REF_NONE;
  if (ptr) {
    ref = array_get(ptr->uses, ix);
  }
  return (ref) ? ref->var : VARIABLE_NONE;
}

variable_t variable_interfer_get(variable_t var, size_t ix)
{
  struct variable_ *ptr;
  variable_ref_t   *ref;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  ref = VARIABLE_REF_NONE;
  if (ptr) {
    ref = array_get(ptr->interference, ix);
  }
  return (ref) ? ref->var : VARIABLE_NONE;
}

int variable_unique_cmp(void *arg, const void *A, const void *B)
{
  variable_t a;
  variable_t b;

  UNUSED(arg);

  a = *(variable_t const *) A;
  b = *(variable_t const *) B;

  return (a > b) - (b > a);
}

void variable_interference_add(variable_t var1, variable_t var2)
{
  while (variable_master_get(var1)) {
    var1 = variable_master_get(var1);
  }

  while (variable_master_get(var2)) {
    var2 = variable_master_get(var2);
  }

  if (/* variable_is_auto(var1) 
    && variable_is_auto(var2) */
    (VARIABLE_BASE_UNKNOWN == variable_base_get(var1, 0))
    && (VARIABLE_BASE_UNKNOWN == variable_base_get(var2, 0))) {
    struct variable_ *ptr;

    ptr = variable_element_seek(var1, BOOLEAN_TRUE);
    if (ptr) {
      variable_array_entry_add(ptr->interference, &var2,
        ARRAY_ADD_FLAG_NONE, variable_unique_cmp, 0);
    }

    ptr = variable_element_seek(var2, BOOLEAN_TRUE);
    if (ptr) {
      variable_array_entry_add(ptr->interference, &var1,
        ARRAY_ADD_FLAG_NONE, variable_unique_cmp, 0);
    }
  }
}

variable_array_t *variable_interference_get(variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->interference : VARIABLE_ARRAY_NONE;
}

unsigned variable_id_get(variable_t var)
{
  struct variable_ *ptr;

  ptr = variable_element_seek(var, BOOLEAN_FALSE);
  return (ptr) ? ptr->id : 0;
}

