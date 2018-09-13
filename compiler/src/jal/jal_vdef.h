/************************************************************
 **
 ** jal_vdef.h : JAL variable parsing declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef jal_vdef_h__
#define jal_vdef_h__

#include "../libcore/pf_block.h"
#include "../libcore/pfile.h"

void jal_parse_var_common(pfile_t *pf, const pfile_pos_t *start,
  variable_t *dst, flag_t flags);
void jal_parse_var(pfile_t *pf, const pfile_pos_t *start);
void jal_parse_const(pfile_t *pf, const pfile_pos_t *start);
variable_def_t jal_vdef_get(pfile_t *pf, flag_t flags);
variable_t jal_parse_var_alias(pfile_t *pf);
void jal_parse_record(pfile_t *pf, const pfile_pos_t *start);

typedef struct {
  char           *name;
  variable_t      master;
  variable_base_t base[VARIABLE_MIRROR_CT];
  size_t          base_ct;
  unsigned        bit;
  unsigned        ct;        /* for arrays, -1 = undetermined size */
  flag_t          var_flags; /* variable specific flags */
  flag_t          def_flags;
  variable_def_t  vdef;
} jal_variable_info_t;

void jal_variable_info_init(jal_variable_info_t *inf);
variable_t jal_variable_alloc(pfile_t *pf, 
  const jal_variable_info_t *inf, boolean_t is_param,
  size_t init_ct, value_t *init, pfile_variable_alloc_t where);

typedef enum {
  JAL_VAL_TYPE_MIN = 0,
  JAL_VAL_TYPE_BASE = JAL_VAL_TYPE_MIN, /* base value       */
  JAL_VAL_TYPE_GET,  /* user-defined GET */
  JAL_VAL_TYPE_IGET, /* implicit GET     */
  JAL_VAL_TYPE_PUT,  /* user-defined PUT */
  JAL_VAL_TYPE_IPUT, /* implicit PUT     */
  JAL_VAL_TYPE_CT
} jal_val_type_t;

boolean_t jal_value_find(pfile_t *pf, const char *name,
    value_t val[JAL_VAL_TYPE_CT]);
void      jal_value_release(value_t val[JAL_VAL_TYPE_CT]);

boolean_t jal_identifier_is_reserved(pfile_t *pf);

#endif /* jal_vdef_h__ */

