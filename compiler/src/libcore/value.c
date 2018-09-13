/**********************************************************
 **
 ** value.c : manipulators for value_t
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <string.h>
#include <assert.h>
#include "pf_proc.h"
#include "value.h"

static unsigned value_id;

struct value_
{
  refct_t         ref_ct;
  unsigned        id;
  variable_t      var;       /* base variable                */
  value_t         baseofs;   /* offset from base of variable */
  variable_def_t  def;       /* the definition               */
  flag_t          flags;
  const char     *name;
};


static cache_t   value_cache;
static boolean_t value_cache_is_init;

static void value_cache_cleanup(void)
{
  cache_cleanup(&value_cache);
}

static value_t value_element_alloc(void)
{
  if (!value_cache_is_init) {
    value_cache_is_init = BOOLEAN_TRUE;
    atexit(value_cache_cleanup);
    (void) cache_init(&value_cache, sizeof(struct value_), "value");
  }
  return cache_element_alloc(&value_cache);
}

static struct value_ *value_element_seek(value_t el, boolean_t mod)
{
  return cache_element_seek(&value_cache, el, mod);
}

void value_variable_set(value_t val, variable_t var)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_TRUE);
  if (ptr && (ptr->var != var)) {
    if (ptr->var) {
      variable_release(ptr->var);
    }
    if (var) {
      variable_lock(var);
    }
    ptr = value_element_seek(val, BOOLEAN_TRUE);
    ptr->var   = var;
    ptr->def   = variable_def_get(var);
    ptr->name  = variable_name_get(var);
  }
}

value_t value_alloc(variable_t var)
{
  value_t        val;
  struct value_ *ptr;

  val = value_element_alloc();
  if (val) {
    ptr = value_element_seek(val, BOOLEAN_TRUE);
    ptr->ref_ct    = 1;
    ptr->id        = ++value_id;
    ptr->var       = VARIABLE_NONE;
    ptr->baseofs   = VALUE_NONE;
    ptr->def       = VARIABLE_DEF_NONE;
    ptr->flags     = VALUE_FLAG_NONE;
    ptr->name      = 0;

    value_variable_set(val, var);

  }
  return val;
}

void value_def_set(value_t val, variable_def_t def)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_TRUE);
  if (ptr) {
    ptr->def = def;
  }
}

void value_indirect_set(value_t val)
{
  value_flag_set(val, VALUE_FLAG_INDIRECT);
}

void value_indirect_clear(value_t val)
{
  value_flag_clr(val, VALUE_FLAG_INDIRECT);
}

value_t value_clone(value_t src)
{
  variable_t      var;
  value_t         baseofs;
  variable_def_t  def;
  value_t         val;
  flag_t          flags;

  var     = value_variable_get(src);
  baseofs = value_baseofs_get(src);
  def     = value_def_get(src);
  flags   = value_flag_get_all(src);

  val = value_alloc(var);
  if (val) {
    value_baseofs_set(val, baseofs);
    value_def_set(val, def);
    value_flag_set_all(val, flags);
  }
  return val;
}

void value_lock(value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_TRUE);
  if (ptr) {
    ptr->ref_ct++;
  }
}

refct_t value_ref_ct_get(const value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? ptr->ref_ct : 0;
}

unsigned value_id_get(const value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? ptr->id : 0;
}

void value_release(value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_TRUE);
  if (ptr && !--ptr->ref_ct) {
    value_baseofs_set(val, 0);
    value_variable_set(val, 0);
    cache_element_free(&value_cache, val);
  }
}

variable_sz_t value_sz_get(const value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? variable_def_sz_get(ptr->def) : 0;
}

variable_sz_t value_byte_sz_get(const value_t val)
{
  variable_sz_t sz;

  sz = value_sz_get(val);
  if (value_is_bit(val)) {
    sz = (sz + 7) / 8;
  } else if (value_is_universal(val)) {
    variable_const_t cn;
    uchar            n0, n1, n2, n3;

    cn = value_const_get(val);
    n0 = (uchar)  (cn        & 0xff);
    n1 = (uchar) ((cn >>  8) & 0xff);
    n2 = (uchar) ((cn >> 16) & 0xff);
    n3 = (uchar) ((cn >> 24) & 0xff);

    sz = 4;
    if (value_is_signed(val) && (n3 & 0x80)) {
      if ((0xff == n3) && (n2 & 0x80)) {
        sz--;
        if ((0xff == n2) && (n1 & 0x80)) {
          sz--;
          if ((0xff == n1) && (n0 & 0x80)) {
            sz--;
          }
        }
      }
    } else {
      if (0x00 == n3) {
        sz--;
        if (0x00 == n2) {
          sz--;
          if (0x00 == n1) {
            sz--;
          }
        }
      }
    }
  }
  return sz;
}

boolean_t value_dflag_test(const value_t val, flag_t flag)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? variable_def_flag_test(ptr->def, flag) : 0;
}

boolean_t value_vflag_test(const value_t val, flag_t flags)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? variable_flag_test(ptr->var, flags) : 0;
}

void value_vflag_set(value_t val, flag_t flags)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_TRUE);
  if (ptr) {
    variable_flag_set(ptr->var, flags);
  }
}

void value_vflag_clr(value_t val, flag_t flags)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_TRUE);
  if (ptr) {
    variable_flag_clr(ptr->var, flags);
  }
}

flag_t value_flag_get_all(value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? ptr->flags : 0;
}

void value_flag_set_all(value_t val, flag_t flags)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags = flags;
  }
}


const char *value_name_get(const value_t val)
{
  return variable_name_get(value_variable_get(val));
}

variable_const_t value_const_get(const value_t val)
{
  variable_const_t n;
  struct value_   *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  if (!ptr) {
    n = 0;
  } else {
    variable_const_t pos;
    if (ptr->baseofs && !value_is_const(ptr->baseofs)) {
      assert(!value_is_lookup(val) && !value_assign_ct_get(val));
      /*abort(); *//* uh oh! */
    }
    pos = value_const_get(ptr->baseofs);
    ptr = value_element_seek(val, BOOLEAN_FALSE);
    n = variable_const_get(ptr->var, value_def_get(val), pos);
  }
  return n;
}

void value_const_set(value_t val, variable_const_t c)
{
  struct value_   *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  if (ptr) {
    variable_const_t pos;
    if (ptr->baseofs && !value_is_const(ptr->baseofs)) {
      abort(); /* uh oh! */
    }
    pos = value_const_get(ptr->baseofs);
    ptr = value_element_seek(val, BOOLEAN_FALSE);
    variable_const_set(ptr->var, value_def_get(val), pos, c);
  }
}

float value_const_float_get(const value_t val)
{
  float            n;
  struct value_   *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  if (!ptr) {
    n = 0.0;
  } else {
    variable_const_t pos;
    if (ptr->baseofs && !value_is_const(ptr->baseofs)) {
      assert(!value_is_lookup(val) && !value_assign_ct_get(val));
      /*abort(); *//* uh oh! */
    }
    pos = value_const_get(ptr->baseofs);
    ptr = value_element_seek(val, BOOLEAN_FALSE);
    n = variable_const_float_get(ptr->var, pos);
  }
  return n;
}

void value_const_float_set(value_t val, float c)
{
  struct value_   *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  if (ptr) {
    variable_const_t pos;
    if (ptr->baseofs && !value_is_const(ptr->baseofs)) {
      abort(); /* uh oh! */
    }
    pos = value_const_get(ptr->baseofs);
    ptr = value_element_seek(val, BOOLEAN_FALSE);
    variable_const_float_set(ptr->var, pos, c);
  }
}

void value_dump(const value_t val, FILE *dst)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  if (ptr) {
    fprintf(dst, "%u[%c%c%c%c%c%c%c%u]:", value_id_get(val),
        variable_def_type_to_ch(value_type_get(val)),
        value_dflag_test(val, VARIABLE_DEF_FLAG_CONST) ? 'C' : '-',
        value_dflag_test(val, VARIABLE_DEF_FLAG_VOLATILE) ? 'V' : '-',
        value_dflag_test(val, VARIABLE_DEF_FLAG_SIGNED) ? 'S' : '-',
        value_flag_test(val, VALUE_FLAG_INDIRECT) ? 'I' : '-',
        value_flag_test(val, VALUE_FLAG_ARRAY)    ? 'A' : '-',
        value_flag_test(val, VALUE_FLAG_POINTER)  ? 'P' : '-',
          value_sz_get(val));
    variable_dump(ptr->var, dst);
    if (ptr->baseofs) {
      value_t baseofs;

      baseofs = ptr->baseofs;
      if (!value_name_get(baseofs)) {
        fprintf(dst, "+%lx", (unsigned long) value_const_get(baseofs));
      } else {
        fprintf(dst, "+%s(%lx)", value_name_get(baseofs),
          (unsigned long) value_const_get(baseofs));
      }
    }
  }
}

/* two values are the same iff they point to the same variable
 * and have the same offset and subscript */
boolean_t value_is_same(const value_t val1, const value_t val2)
{
  boolean_t rc;

  rc = (val1 == val2)
    || (value_is_const(val1)
      && value_is_const(val2)
      && value_def_is_same(val1, val2)
      && (value_const_get(val1) == value_const_get(val2)));
  if (!rc) {
    const char *name1;
    const char *name2;

    name1 = value_name_get(val1);
    name2 = value_name_get(val2);

    if ((name1 && !strcmp(name1, "_temp")) 
      || (name2 && !strcmp(name2, "_temp"))) {
      rc = BOOLEAN_FALSE;
    } else {
      rc = (value_variable_get(val1) == value_variable_get(val2))
        && (value_def_is_same(val1, val2));

      if (rc) {
        value_t base1;
        value_t base2;

        base1 = value_baseofs_get(val1);
        base2 = value_baseofs_get(val2);

        if (base1 == base2) {
          /* still true */
        } else if (value_is_const(base1) 
          && value_is_const(base2)
          && (value_const_get(base1) == value_const_get(base2))) {
          /* sitll true */
        } else {
          rc = BOOLEAN_FALSE;
        }
      }
    }
  }
  return rc;
}

value_t value_baseofs_get(const value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? ptr->baseofs : 0;
}

void value_baseofs_set(value_t val, value_t baseofs)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_TRUE);
  if (ptr && (ptr->baseofs != baseofs)) {
    if (baseofs) {
      value_lock(baseofs);
    }
    ptr = value_element_seek(val, BOOLEAN_TRUE);
    if (ptr->baseofs) {
      value_release(ptr->baseofs);
    }
    ptr = value_element_seek(val, BOOLEAN_TRUE);
    ptr->baseofs = baseofs;
  }
}

value_t value_constant_get(variable_const_t n, variable_def_t def)
{
  value_t             val;
  variable_t          var;

  if (!def) {
    def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER, 
        VARIABLE_DEF_FLAG_UNIVERSAL | VARIABLE_DEF_FLAG_CONST, 4);
  } else if (!variable_def_flag_test(def, VARIABLE_DEF_FLAG_CONST)) {
    def = variable_def_flags_change(def,
        variable_def_flags_get_all(def) | VARIABLE_DEF_FLAG_CONST);
  }
  var = variable_alloc(0, def);
  if (!var) {
    val = VALUE_NONE;
  } else {
    variable_const_set(var, variable_def_get(var), 0, n);
    val = value_alloc(var);
    variable_release(var);
  }
  return val;
}

value_t value_constant_float_get(float n, variable_def_t def)
{
  value_t    val;
  variable_t var;

  if (!def) {
    def = variable_def_alloc(0, VARIABLE_DEF_TYPE_FLOAT, 
        VARIABLE_DEF_FLAG_CONST | VARIABLE_DEF_FLAG_SIGNED, 4);
  } else if (!variable_def_flag_test(def, VARIABLE_DEF_FLAG_CONST)) {
    def = variable_def_flags_change(def,
        variable_def_flags_get_all(def) | VARIABLE_DEF_FLAG_CONST);
  }
  var = variable_alloc(0, def);
  if (!var) {
    val = VALUE_NONE;
  } else {
    variable_const_float_set(var, 0, n);
    val = value_alloc(var);
    variable_release(var);
  }
  return val;
}

value_t value_subscript_set(value_t val, variable_ct_t subscript)
{
  value_t rval;

  if (value_is_array(val) && (subscript < value_ct_get(val))) {
    rval = value_clone(val);
    if (rval) {
      variable_def_t def;
      
      def = variable_def_member_def_get(
          variable_def_member_get(
            value_def_get(
              rval)));
      value_baseofs_set(rval, value_constant_get(
            subscript * variable_def_sz_get(def), VARIABLE_DEF_NONE));
      value_dereference(rval);
    }
  } else {
    rval = VALUE_NONE;
  }
  return rval;
}

variable_t value_variable_get(const value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? ptr->var : 0;
}

ctr_t value_assign_ct_get(const value_t val)
{
  return variable_assign_ct_get(value_variable_get(val));
}

void value_assign_ct_bump(value_t val, ctr_bump_t dir)
{
  variable_assign_ct_bump(value_variable_get(val), dir);
  value_use_ct_bump(value_baseofs_get(val), dir);
}

ctr_t value_use_ct_get(const value_t val)
{
  return variable_use_ct_get(value_variable_get(val));
}

void  value_use_ct_bump(value_t val, ctr_bump_t dir)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_TRUE);
  if (ptr) {
    variable_use_ct_bump(ptr->var, dir);
    value_use_ct_bump(ptr->baseofs, dir);
  }
}

/* the underlying variable might have become const which wouldn't be
 * reflected in the value definition so it must also be checked
 * (this is the case of a variable being used without ever being
 * assigned)
 */
boolean_t value_is_const(const value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return ptr
    && ((value_dflag_test(val, VARIABLE_DEF_FLAG_CONST) 
          || variable_dflag_test(ptr->var, VARIABLE_DEF_FLAG_CONST))
        && (!ptr->baseofs || value_is_const(ptr->baseofs)));
}

boolean_t value_is_pseudo_const(const value_t val)
{
  return variable_is_pseudo_const(value_variable_get(val))
      && (!value_baseofs_get(val) || value_is_const(value_baseofs_get(val)));
}

boolean_t value_is_signed(const value_t val)
{
  return value_dflag_test(val, VARIABLE_DEF_FLAG_SIGNED);
}

boolean_t value_is_lookup(const value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return ptr
    && ptr->baseofs
    && (variable_is_const(value_variable_get(val))) 
    && !value_is_const(ptr->baseofs);
}

variable_base_t value_base_get(const value_t val)
{
  return variable_base_get(value_variable_get(val), 0);
}

variable_def_t value_def_get(const value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? ptr->def : 0;
} 

boolean_t value_def_is_same(const value_t val1, const value_t val2)
{
  variable_def_t var1, var2;
  var1 = value_def_get(val1);
  var2 = value_def_get(val2);
  return variable_def_is_same(var1, var2);
}

boolean_t value_is_record(const value_t val)
{
  variable_def_t def;

  def = value_def_get(val);
  return (def && variable_def_member_get(def));
}

boolean_t value_is_function(const value_t val)
{
  return VARIABLE_DEF_TYPE_FUNCTION == value_type_get(val);
}

boolean_t value_is_label(const value_t val)
{
  return VARIABLE_DEF_TYPE_LABEL == value_type_get(val);
}

boolean_t value_is_value(const value_t val)
{
  return VARIABLE_DEF_TYPE_VALUE == value_type_get(val);
}

boolean_t value_is_indirect(const value_t val)
{
  boolean_t rc;

  if (value_is_lookup(val)) {
    rc = BOOLEAN_FALSE;
  } else {
    value_t baseofs;

    baseofs = value_baseofs_get(val);
    rc = value_flag_test(val, VALUE_FLAG_INDIRECT)
      || (baseofs && !value_is_const(baseofs));
  }
  return rc;
}

boolean_t value_is_volatile(const value_t val)
{
  return variable_is_volatile(value_variable_get(val));
}

boolean_t value_is_auto(const value_t val)
{
  return variable_is_auto(value_variable_get(val));
}

unsigned value_tag_n_get(const value_t val)
{
  return variable_tag_n_get(value_variable_get(val));
}

unsigned value_bit_offset_get(const value_t val)
{
  return variable_bit_offset_get(
    value_variable_get(val));
}

pfile_proc_t *value_proc_get(const value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? variable_proc_get(ptr->var) : PFILE_PROC_NONE;
}

label_t value_label_get(const value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? variable_label_get(ptr->var) : LABEL_NONE;
}

variable_def_type_t value_type_get(const value_t val)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? variable_def_type_get(ptr->def) : VARIABLE_DEF_TYPE_NONE;
}

boolean_t value_is_number(const value_t val)
{
  return variable_def_type_is_number(value_type_get(val));
}

boolean_t value_is_bit(const value_t val)
{
  return value_dflag_test(val, VARIABLE_DEF_FLAG_BIT);
}

boolean_t value_is_array(const value_t val)
{
  return VARIABLE_DEF_TYPE_ARRAY == value_type_get(val);
}

boolean_t value_is_pointer(const value_t val)
{
  return VARIABLE_DEF_TYPE_POINTER == value_type_get(val);
}

boolean_t value_is_shared(const value_t val)
{
  return variable_is_shared(value_variable_get(val));
}

boolean_t value_is_float(const value_t val)
{
  return VARIABLE_DEF_TYPE_FLOAT == value_type_get(val);
}

boolean_t value_is_structure(const value_t val)
{
  return VARIABLE_DEF_TYPE_STRUCTURE == value_type_get(val);
}

boolean_t value_is_boolean(const value_t val)
{
  return VARIABLE_DEF_TYPE_BOOLEAN == value_type_get(val);
}

void value_dereference(value_t val)
{
  variable_def_t        def;
  variable_def_member_t mbr;

  assert((VARIABLE_DEF_TYPE_POINTER == value_type_get(val))
      || (VARIABLE_DEF_TYPE_ARRAY == value_type_get(val)));
  value_flag_set(val, 
      (value_is_pointer(val)) ? VALUE_FLAG_POINTER : VALUE_FLAG_ARRAY);
  def = value_def_get(val);
  mbr = variable_def_member_get(def);
  value_def_set(val, variable_def_member_def_get(mbr));
  if (value_flag_test(val, VALUE_FLAG_POINTER)) {
    value_indirect_set(val);
  }
}

boolean_t value_is_single_bit(const value_t val)
{
  return value_is_bit(val) && (1 == value_sz_get(val));
}

boolean_t value_is_multi_bit(const value_t val)
{
  return value_is_bit(val) && (1 < value_sz_get(val));
}

variable_ct_t value_ct_get(const value_t val)
{
  variable_ct_t  ct;

  if ((VARIABLE_DEF_TYPE_POINTER != value_type_get(val))
    && (VARIABLE_DEF_TYPE_ARRAY != value_type_get(val))) {
    ct = 1;
  } else {
    ct = variable_def_member_ct_get(
        variable_def_member_get(
          value_def_get(val)));
  }
  return ct;
}

boolean_t value_flag_test(const value_t val, flag_t flags)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_FALSE);
  return (ptr) ? (ptr->flags & flags) == flags : 0; /* BOOLEAN_FALSE; */
}

void value_flag_set(value_t val, flag_t flags)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags |= flags;
  }
}

void value_flag_clr(value_t val, flag_t flags)
{
  struct value_ *ptr;

  ptr = value_element_seek(val, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags &= ~flags;
  }
}

boolean_t value_is_assigned(const value_t val)
{
  return variable_is_assigned(value_variable_get(val));
}

boolean_t value_is_used(const value_t val)
{
  return variable_is_used(value_variable_get(val));
}

boolean_t value_is_universal(const value_t val)
{
  return value_dflag_test(val, VARIABLE_DEF_FLAG_UNIVERSAL);
}

boolean_t value_is_string(const value_t val)
{
  return value_dflag_test(val, VARIABLE_DEF_FLAG_STRING);
}

value_t value_map_find(const value_map_t *map, value_t val)
{
  value_t ret;

  if (!val) {
    ret = val;
  } else {
    size_t ii;

    for (ii = 0; (ii < map->used) && (map->map[ii].old != val); ii++)
      ;
    ret = (ii < map->used) ? map->map[ii].new : VALUE_NONE;
  }

  return ret;
}

value_t value_variable_remap(value_t val, const variable_map_t *map)
{
  value_t tmp;

  tmp = VALUE_NONE;
  if (val) {
    variable_t var;
    value_t    baseofs;

    baseofs = value_variable_remap(value_baseofs_get(val), map);
    if (baseofs) {
      /* create a new value for baseofs */
      tmp = value_clone(val);
      value_baseofs_set(tmp, baseofs);
      value_release(baseofs);
    }
    var = variable_map_find(map, value_variable_get(val));
    if (var) {
      boolean_t fix_indirect;
      variable_def_t def;

      fix_indirect = (value_is_indirect(val) && !variable_is_pointer(var));

      if (!tmp) {
        tmp = value_clone(val);
      }
      /* the def *might be* different from that var's def, so
       * save it & reset it here (the case of temporary variables)
       * or de-referenced arrays */
      def = value_def_get(tmp);
      value_variable_set(tmp, var);
      value_def_set(tmp, def);
      if (variable_is_array(var)) {
        value_flag_set(tmp, VALUE_FLAG_ARRAY);
      }

      if (fix_indirect) {
        value_flag_clr(tmp, VALUE_FLAG_INDIRECT);
        value_flag_clr(tmp, VALUE_FLAG_POINTER);
      }
    }
  }
  return tmp;
}

value_t value_remap(value_t val, const value_map_t *map)
{
  UNUSED(val);
  UNUSED(map);

  assert(0);
  return VALUE_NONE;
}

