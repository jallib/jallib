/************************************************************
 **
 ** variable.h : variable declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef variable_h__
#define variable_h__

#include <stdio.h>
#include "../libutils/cache.h"
#include "tag.h"
#include "vardef.h"
#include "univ.h"

#define VARIABLE_NONE ((variable_t) 0)
/*
 * the number of elements in the variable_base array, used to
 * describe variables that are mirrored in multiple locations
 * (basically a hack to give the PIC PCLATH flags some hints)
 */
#define VARIABLE_MIRROR_CT 4

/* member notes:
     bit, boolean, 
     unsigned, signed,
     float              : cannot have any members
     pointer            : can have one member
     function           : 1st member = return value
                          others are parameters
     structure,union    : any number of members
 */
typedef struct variable_ *variable_t;
typedef struct varlist_  varlist_t;

struct varlist_ {
  variable_t head;
  variable_t tail;
  size_t     ct;
};

typedef unsigned short variable_base_t;
typedef unsigned long  variable_const_t;

#define VARIABLE_BASE_UNKNOWN ((variable_base_t) -1)

/* BIT variables are slightly different than normal variables
     sz = # of bits (currently, must be 1!)
     ct = 1 -- no bit arrays allowed

   pointers   : as in C, pointers hold an indirect value. pointers must be
                dereferenced to be useful
    
   references : as in C++, references are pointers that are automatically
                dereferenced. must also have POINTER set
 */
#define VARIABLE_DEF_FLAG_NONE     0x0000U
#define VARIABLE_DEF_FLAG_CONST    0x0001U
#define VARIABLE_DEF_FLAG_VOLATILE 0x0002U
#define VARIABLE_DEF_FLAG_SIGNED   0x0004U
#define VARIABLE_DEF_FLAG_BIT      0x0008U
/* I'm not sure if this is a hack, but these are parameter options.
 * IN     -- pass by value
 * IN+OUT -- pass by reference
 * OUT    -- */
#define VARIABLE_DEF_FLAG_IN       0x0010U
#define VARIABLE_DEF_FLAG_OUT      0x0020U
/* BYREF -- this is an automatically dereferenced pointer */
#define VARIABLE_DEF_FLAG_BYREF    0x0040U
/* yet another JAL hack -- if a type is UNIVERSAL, all constant operations
 * are performed in 32 bits, but when the value is used in a non-constant
 * operation (or with another non-universal type), it is changed to the type
 * of the other operand */
#define VARIABLE_DEF_FLAG_UNIVERSAL 0x0080U
/* ugh, another JAL hack. I formerly used '"' for single characters
 * (eg, ``ch - "a"''), and also for string and constant initiation. Now
 * it can also be used to declare an anonymous constant array which can
 * be passed directly to a function (eg, ``write_string("hello")''). I
 * need a way to differentiate between the two cases, so I'll set this
 * bit. If set, the array can gracefully degrade to its first member
 * when needed */
#define VARIABLE_DEF_FLAG_STRING   0x0100U
 
#define VARIABLE_FLAG_NONE         0x0000U
#define VARIABLE_FLAG_AUTO         0x0001U
/* when alias is set, all references to this variable will silently
   be changed to the master */
#define VARIABLE_FLAG_ALIAS        0x0002U
/* lookup means a constant array was accessed through a non-const
 * index */
#define VARIABLE_FLAG_LOOKUP       0x0004U

/* when creating a variable, both READ and WRITE are allowed; if
 * a 'get or 'put function is created without the associated variable,
 * then the variable will be created but without either READ or WRITE
 * (that way it can be used as an alias).
 * VARIABLE_DEF_FLAG_CONST should be deprecated, and these used in
 * it's place (testing for !VARIABLE_FLAG_WRITE should be the same)
 * Currently, these flags are *only* used in the JAL compiler.
 */
#define VARIABLE_FLAG_READ         0x0008U /* variable is readable  */
#define VARIABLE_FLAG_WRITE        0x0010U /* variable is writeable */
#define VARIABLE_FLAG_STICKY       0x0020U /* this variable is AUTO, but it's
                                             assigned a location and cannot
                                             move */
#define VARIABLE_FLAG_CONST_TESTED 0x0040U /* this variable has already been
                                             subjected to CONST testing */
#define VARIABLE_FLAG_ALLOC_FAIL   0x0080U /* no space for this var */

#define VARIABLE_FLAG_UNREPLACEABLE 0x0100U /* this variable cannot be replaced
                                               during inlining */
/* these probably don't belone here, but I don't know where
 * else to put them. these flag what is assigned to a *ptr*
 * and used to generate the appropriate PIC routines
 */
#define VARIABLE_FLAG_PTR_PTR    0x0100U
#define VARIABLE_FLAG_PTR_LOOKUP 0x0200U
#define VARIABLE_FLAG_PTR_EEPROM 0x0400U
#define VARIABLE_FLAG_PTR_FLASH  0x0800U

/* this variable is available in all banks; rp1:rp0/BSR will be ignord */
#define VARIABLE_FLAG_SHARED     0x1000U

#define VARIABLE_FLAG_PTR_MASK \
  (VARIABLE_FLAG_PTR_PTR       \
   | VARIABLE_FLAG_PTR_LOOKUP  \
   | VARIABLE_FLAG_PTR_EEPROM  \
   | VARIABLE_FLAG_PTR_FLASH)

typedef boolean_t (*varfind_cb_t)(void *arg, const variable_t var, 
    const void *data);

void variable_list_init(varlist_t *lst);
void variable_list_append(varlist_t *lst, variable_t var);
variable_t variable_list_find(varlist_t *lst, varfind_cb_t fn, void *arg,
    const void *data);
void variable_list_reset(varlist_t *lst);
size_t	variable_list_ct_get(const varlist_t *lst);

/* basic functions */
variable_t variable_alloc(tag_t tag, variable_def_t def);
void variable_release(variable_t var);
void variable_lock(variable_t var);

/* member retrieval */
const char     *variable_name_get(const variable_t var);
unsigned        variable_tag_n_get(const variable_t var);

boolean_t       variable_dflag_test(const variable_t var, flag_t flag);
flag_t          variable_dflags_get_all(const variable_t var);

boolean_t       variable_flag_test(const variable_t var, flag_t flag);
void            variable_flag_set(variable_t var, flag_t flag);
void            variable_flag_clr(variable_t var, flag_t flag);
flag_t          variable_flags_get_all(variable_t var);
void            variable_flags_set_all(variable_t var, flag_t flags);

variable_sz_t   variable_sz_get(const variable_t var);

variable_def_type_t variable_type_get(const variable_t var);
variable_base_t variable_base_real_get(const variable_t var, size_t which);
variable_base_t variable_base_get(variable_t var, size_t which);
void            variable_base_set(variable_t var, variable_base_t base,
    size_t which);
/* ofs == *byte* offset from beginning of area */
variable_const_t variable_const_get(const variable_t var, 
    variable_def_t vdef, size_t ofs);
void             variable_const_set(variable_t var, variable_def_t vdef,
    size_t ofs, variable_const_t n);

float            variable_const_float_get(const variable_t var, size_t ofs);
void             variable_const_float_set(const variable_t var, size_t ofs,
    float n);

void             variable_data_set(variable_t var, void *x);
void            *variable_data_get(const variable_t var);

refct_t          variable_refct_get(const variable_t var);

variable_t      variable_link_get(const variable_t var);
void            variable_link_set(variable_t var, variable_t lnk);

const char  *variable_const_buf_get(const variable_t var);
void            variable_const_buf_set(variable_t var, const char *buf);

void            variable_dump(const variable_t var, FILE *dst);

variable_t      variable_list_head(varlist_t *var);

ctr_t          variable_assign_ct_get(const variable_t var);
void           variable_assign_ct_set(variable_t var, ctr_t ctr);
void           variable_assign_ct_bump(variable_t var, ctr_bump_t dir);

ctr_t          variable_use_ct_get(const variable_t var);
void           variable_use_ct_set(variable_t var, ctr_t ctr);
void           variable_use_ct_bump(variable_t var, ctr_bump_t dir);

ctr_t          variable_ref_ct_get(const variable_t var);

variable_def_t    variable_def_get(const variable_t var);
void              variable_def_set(variable_t var, variable_def_t def);

void variable_calc_sz_min(variable_const_t n, 
  variable_sz_t *psz, variable_def_type_t *ptype, flag_t *flags);

void     variable_bit_offset_set(variable_t var, ushort pos);
unsigned variable_bit_offset_get(const variable_t var);

variable_t variable_master_get(const variable_t var);
void       variable_master_set(variable_t var, variable_t master);

pfile_proc_t *variable_proc_get(const variable_t var);
void          variable_proc_set(variable_t var, pfile_proc_t *proc);

typedef struct value_ *value_t;
value_t       variable_value_get(const variable_t var);
void          variable_value_set(variable_t var, value_t val);

label_t       variable_label_get(const variable_t var);
void          variable_label_set(variable_t var, label_t lbl);

boolean_t     variable_is_volatile(const variable_t var);
boolean_t     variable_is_const(const variable_t var);
boolean_t     variable_is_pseudo_const(const variable_t var);
boolean_t     variable_is_auto(const variable_t var);
boolean_t     variable_is_array(const variable_t var);
boolean_t     variable_is_lookup(const variable_t var);
boolean_t     variable_is_bit(const variable_t var);
boolean_t     variable_is_sticky(const variable_t var);
boolean_t     variable_is_assigned(const variable_t var);
boolean_t     variable_is_used(const variable_t var);
boolean_t     variable_is_alias(const variable_t var);
boolean_t     variable_is_temp(const variable_t var);
boolean_t     variable_is_signed(const variable_t var);
boolean_t     variable_is_pointer(const variable_t var);
boolean_t     variable_is_shared(const variable_t var);
boolean_t     variable_is_function(const variable_t var);
boolean_t     variable_is_float(const variable_t var);

typedef struct {
  size_t      used;
  size_t      alloc;
  struct {
    variable_t old;
    variable_t new;
  } *map;
} variable_map_t;

variable_t variable_map_find(const variable_map_t *map, variable_t var);

void  variable_user_data_set(variable_t var, void *data);
void *variable_user_data_get(const variable_t var);

void variable_uses_add(variable_t var, variable_t uses);
void variable_uses_remove(variable_t var, variable_t uses);
variable_t variable_uses_get(variable_t var, size_t ix);
variable_t variable_used_by_get(variable_t var, size_t ix);
variable_t variable_interfer_get(variable_t var, size_t ix);

int variable_unique_cmp(void *arg, const void *A, const void *B);
void variable_interference_add(variable_t var1, variable_t var2);
struct array_ *variable_interference_get(variable_t var);

unsigned variable_id_get(variable_t var);

#endif /* variable_h__ */

