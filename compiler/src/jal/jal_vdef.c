/**********************************************************
 **
 ** jal_vdef.c : JAL variable defintion parsing
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <errno.h>
#include <string.h>
#include <assert.h>

#include "../libutils/mem.h"
#include "../libcore/pf_msg.h"
#include "../libcore/pf_expr.h"
#include "../libcore/pf_proc.h"
#include "../libcore/pf_block.h"
#include "jal_expr.h"
#include "jal_tokn.h"
#include "jal_vdef.h"

boolean_t jal_identifier_is_reserved(pfile_t *pf)
{
  boolean_t rc;

  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "count")
    || pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "defined")
    || pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "whereis")) {
    pfile_log(pf, PFILE_LOG_ERR, "'%s' is a reserved word", 
      pf_token_get(pf, PF_TOKEN_CURRENT));
    rc = BOOLEAN_TRUE;
  } else {
    rc = BOOLEAN_FALSE;
  }
  return rc;
}

/* 
 * parse:
 *   VAR [[volatile] type] name 
 *   [(cexpr)]
 *   [AT cexpr | variable : bit pos] 
 *   [IS variable] 
 *   [= expr]
 * on entry, the next token is either VOLATILE or type
 *
 * if var exists, this changes a bit
 *    1. require 'in' and/or 'out'
 *    2. don't allow assignment
 */   
static void jal_parse_var_init(pfile_t *pf, variable_t var, size_t el, 
    value_t expr)
{
  size_t         sz;
  variable_def_t vdef;

  vdef = variable_def_get(var);
  if (variable_is_array(var)) {
    vdef = variable_def_member_def_get(
          variable_def_member_get(vdef)
          );
  }
  sz = variable_def_sz_get(vdef);
  if (variable_is_const(var)) {
    if (!value_is_const(expr)) {
      pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_EXPECTED);
    } else {
      if (value_is_float(expr)) {
        variable_const_float_set(var, el * sz, value_const_float_get(expr));
      } else {
        variable_const_set(var, vdef, el * sz, value_const_get(expr));
      }
    }
  } else {
    if (var) {
      value_t val;

      val = value_alloc(var);
      if (val) {
        if (el) {
          value_t ofs;

          ofs = pfile_constant_get(pf, el * sz, VARIABLE_DEF_NONE);
          value_baseofs_set(val, ofs);
          value_release(ofs);
        }
        if (value_is_array(val)) {
          value_dereference(val);
        }
        pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &val, expr, VALUE_NONE);
        value_release(val);
      }
    }
  }
}

variable_t jal_variable_alloc(pfile_t *pf, 
  const jal_variable_info_t *inf, boolean_t is_param,
  size_t init_ct, value_t *init, pfile_variable_alloc_t where)
{
  variable_t     var;
  variable_def_t vdef;

  var = VARIABLE_NONE;

  vdef = (inf->vdef) 
    ? inf->vdef 
    : variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER, 
        VARIABLE_DEF_FLAG_UNIVERSAL, 4);

  if (inf->name) {
    size_t         ii;
    variable_def_t vvdef;
    flag_t         def_flags;

    def_flags = inf->def_flags | variable_def_flags_get_all(vdef);

    if (inf->master && variable_is_volatile(inf->master)) {
      def_flags |= VARIABLE_DEF_FLAG_VOLATILE;
    }
    vvdef = variable_def_flags_change(vdef, def_flags);
    if (inf->ct) {
      variable_def_t adef;

      adef = variable_def_alloc(0, VARIABLE_DEF_TYPE_ARRAY,
          def_flags, 0);
      variable_def_member_add(adef, 0, vvdef, inf->ct);
      vvdef = adef;
    } else if (def_flags & VARIABLE_DEF_FLAG_BYREF) {
      variable_def_t rdef;

      rdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_REFERENCE,
          def_flags, 0);
      variable_def_member_add(rdef, 0, vvdef, 1);
      vvdef = rdef;
    }
    if (is_param) {
      var = variable_alloc(pfile_tag_alloc(pf, inf->name), vvdef);
      if (!var) {
        pfile_log_syserr(pf, ENOMEM);
      }
      variable_master_set(var, inf->master);
    } else {
      if (RESULT_OK != pfile_variable_alloc(pf, 
        where, inf->name, vvdef, inf->master, &var)) {
        var = VARIABLE_NONE;
      }
    }
    variable_flag_set(var, inf->var_flags);

    for (ii = 0; ii < inf->base_ct; ii++) {
      variable_base_set(var, inf->base[ii], ii);
    }
    variable_bit_offset_set(var, inf->bit);

    if ((init_ct > 1) && !variable_is_array(var)) {
      pfile_log(pf, PFILE_LOG_ERR, 
        "more initializers than allowed");
      init_ct = 1;
    }
    for (ii = 0; ii < init_ct; ii++) {
      jal_parse_var_init(pf, var, ii, init[ii]);
    }
  }
  return var;
}

void jal_variable_info_init(jal_variable_info_t *inf)
{
  inf->name      = 0;
  inf->master    = VARIABLE_NONE;
  inf->base_ct   = 0;
  inf->bit       = 0;
  inf->ct        = 0;
  inf->var_flags = VARIABLE_FLAG_NONE;
  inf->def_flags = VARIABLE_DEF_FLAG_NONE;
  inf->vdef      = VARIABLE_DEF_NONE;
}

void jal_variable_info_cleanup(jal_variable_info_t *inf)
{
  FREE(inf->name);
  variable_release(inf->master);
}

/* this looks for byte[*n] or other base definition */
variable_def_t jal_vdef_get(pfile_t *pf, flag_t flags)
{
  variable_def_t vdef;
  const char    *ptr;

  ptr = pf_token_get(pf, PF_TOKEN_CURRENT);

  vdef = pfile_variable_def_find(pf, 
    (flags & VARIABLE_DEF_FLAG_CONST) ? PFILE_LOG_NONE : PFILE_LOG_ERR,
    ptr);
  if (!vdef) {
    if (flags & VARIABLE_DEF_FLAG_CONST) {
      /* create a universal type */
      vdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER,
        VARIABLE_DEF_FLAG_UNIVERSAL, 4);
    } else if (jal_token_is_identifier(pf)) {
      /* assume a mis-spelled type and continue */
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
  } else {
    pf_token_get(pf, PF_TOKEN_NEXT);
    if ((variable_def_sz_get(vdef) == 1)
      && ((VARIABLE_DEF_TYPE_INTEGER == variable_def_type_get(vdef))
        || (VARIABLE_DEF_TYPE_BOOLEAN == variable_def_type_get(vdef)))
      && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "*")) {
      value_t val;

      /* this is a user-selected size */
      pf_token_get(pf, PF_TOKEN_NEXT);
      val = jal_parse_expr(pf);
      if (val) {
        if (!value_is_const(val)) {
          pfile_log(pf, PFILE_LOG_ERR, "constant expected");
        } else {
          variable_def_type_t type;

          type = variable_def_type_get(vdef);
          if (VARIABLE_DEF_TYPE_BOOLEAN == type) {
            type = VARIABLE_DEF_TYPE_INTEGER;
          }

          vdef = variable_def_alloc(0,
            type,
            variable_def_flags_get_all(vdef),
            value_const_get(val));
        }
        value_release(val);
      }
    }
  }
  return vdef;
}

/*
 * NAME
 *   jal_value_find
 *
 * DESCRIPTION
 *   find a named value
 *
 * PARAMETERS
 *   pf      : pfile handle
 *   name    : value name
 *   val[]   : [out] holds all values found
 *
 * RETURN
 *   block in which the values were found, or NULL if none
 *
 * NOTES
 *   1. unlike most routines, all entries in val[] are set to VALUE_NONE
 *      on entry.
 *   2. val, 'get and 'put, 'vget, or 'vput if defined, must all be defined 
 *      at the same place (same block).
 */
const char *jal_value_type_to_name(char *dst, const char *name, 
    jal_val_type_t type)
{
  const char *fmt_str;

  fmt_str = "%s";
  switch (type) {
    case JAL_VAL_TYPE_CT:   assert(0);
    case JAL_VAL_TYPE_BASE: break;
    case JAL_VAL_TYPE_GET:  fmt_str = "_%s_get"; break;
    case JAL_VAL_TYPE_IGET: fmt_str = "_%s_vget"; break;
    case JAL_VAL_TYPE_PUT:  fmt_str = "_%s_put"; break;
    case JAL_VAL_TYPE_IPUT: fmt_str = "_%s_vput"; break;
  }
  sprintf(dst, fmt_str, name);
  return dst;
}

boolean_t jal_value_find(pfile_t *pf, const char *name,
    value_t val[JAL_VAL_TYPE_CT])
{
  char          *name_buf;
  size_t         name_sz;
  boolean_t      found;
  
  found = BOOLEAN_FALSE;
  if (!jal_token_is_identifier(pf)) {
    jal_val_type_t ii;

    for (ii = JAL_VAL_TYPE_MIN; ii < JAL_VAL_TYPE_CT; ii++) {
      val[ii] = VALUE_NONE;
    }
  } else {
    /* space for the passed in name is not needed */
    name_sz  = 7 + strlen(name);
    name_buf = MALLOC(name_sz);
    if (!name_buf) {
      pfile_log_syserr(pf, ENOMEM);
    } else {
      /* fill the name buffers */
      pfile_proc_t  *proc;
      variable_t     var[JAL_VAL_TYPE_CT];
      jal_val_type_t ii;

      for (ii = JAL_VAL_TYPE_MIN; ii < JAL_VAL_TYPE_CT; ii++) {
        var[ii] = VARIABLE_NONE;
      }

      for (proc = pfile_proc_active_get(pf), found = BOOLEAN_FALSE;
           proc/* && !found*/;
           proc = pfile_proc_parent_get(proc)) {
        pfile_block_t *blk;

        for (blk = pfile_proc_block_active_get(proc);
             blk;
             blk = pfile_block_parent_get(blk)) {
          for (ii = JAL_VAL_TYPE_MIN; ii < JAL_VAL_TYPE_CT; ii++) {
            if (VARIABLE_NONE == var[ii]) {
              var[ii] = pfile_block_variable_find(blk, jal_value_type_to_name(
                    name_buf, name, ii));
              if (VARIABLE_NONE != var[ii]) {
                found = BOOLEAN_TRUE;
                if (JAL_VAL_TYPE_BASE == ii) {
                  /* if this was an alias, the name will have changed */
                  name = variable_name_get(var[ii]);
                  FREE(name_buf);
                  name_sz  = 7 + strlen(name);
                  name_buf = MALLOC(name_sz);
                }
              }
            }
          }
        }
      }
      if (found) {
        /* make sure everything found is in the newest block */
        ulong block_no;
        
        block_no = 0;
        for (ii = JAL_VAL_TYPE_MIN; ii < JAL_VAL_TYPE_CT; ii++) {
          ulong vblock_no;

          vblock_no = pfile_block_no_get(variable_user_data_get(var[ii]));
          if (vblock_no > block_no) {
            block_no = vblock_no;
          }
        }

        for (ii = JAL_VAL_TYPE_MIN; ii < JAL_VAL_TYPE_CT; ii++) {
          ulong vblock_no;

          vblock_no = pfile_block_no_get(variable_user_data_get(var[ii]));
          if (block_no != vblock_no) {
            variable_release(var[ii]);
            var[ii] = VARIABLE_NONE;
          }
        }
      }
      for (ii = JAL_VAL_TYPE_MIN; ii < JAL_VAL_TYPE_CT; ii++) {
        if (var[ii]) {
          val[ii] = value_alloc(var[ii]);
          variable_release(var[ii]);
        } else {
          val[ii] = VALUE_NONE;
        }
      }
      if (!found && !jal_token_is_keyword(pf)) {
        /* assume a mis-spelling & simply create the current token
         * as a BYTE value */
        pfile_log(pf, PFILE_LOG_ERR, "\"%s\" not defined",
          pf_token_ptr_get(pf));
        pfile_value_alloc(pf, PFILE_VARIABLE_ALLOC_LOCAL,
            pf_token_ptr_get(pf),
            pfile_variable_def_find(pf, PFILE_LOG_NONE, "byte"),
            &val[JAL_VAL_TYPE_BASE]);
      }
      FREE(name_buf);
    }
  }
  return found;
}

void jal_value_release(value_t val[JAL_VAL_TYPE_CT])
{
  size_t ii;

  for (ii = 0; ii < JAL_VAL_TYPE_CT; ii++) {
    value_release(val[ii]);
  }
}

/*
 * Find the variable represented by the current token, or
 * create one if necessary. It would be necessary, for
 * instance, if the variable is only represented by a
 * pseudo-variable.
 */
variable_t jal_parse_var_alias(pfile_t *pf)
{
  value_t     jvals[JAL_VAL_TYPE_CT];
  boolean_t   jval_found;
  variable_t  var;
  const char *ptr;

  var = VARIABLE_NONE;

  ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
  jval_found = jal_value_find(pf, ptr, jvals);
  if (jval_found) {
    /* If JAL_VAL_TYPE_BASE is set, no problem. Otherwise
     * we need to create one based on whether the appropriate
     * 'get and/or 'put routines are in place
     */
    if (VALUE_NONE == jvals[JAL_VAL_TYPE_BASE]) {
      /* create a new variable */
      variable_t     jvar;
      variable_def_t jdef;
      flag_t         jvar_flags;

      /* let's find the definition! */
      jvar_flags = VARIABLE_FLAG_NONE;
      jdef       = VARIABLE_DEF_NONE;
      if (jvals[JAL_VAL_TYPE_GET]) {
        /* the definition is the return value, or first parameter */
        jdef = value_def_get(jvals[JAL_VAL_TYPE_GET]);
        jdef = variable_def_member_def_get(
                 variable_def_member_get(
                   jdef));
        jvar_flags |= VARIABLE_FLAG_READ;
      } 
      if (jvals[JAL_VAL_TYPE_PUT]) {
        /* the definition is the second parameter */
        if (!jdef) {
          jdef = value_def_get(jvals[JAL_VAL_TYPE_PUT]);
          jdef = variable_def_member_def_get(
                   variable_def_member_link_get(
                     variable_def_member_get(
                       jdef)));
        }
        jvar_flags |= VARIABLE_FLAG_WRITE;
      } 
      if (!jdef) {
        abort();
      }
      jvar = VARIABLE_NONE;
      pfile_block_variable_alloc(
        pfile_proc_block_active_get(
          pfile_proc_active_get(pf)),
        pfile_tag_alloc(pf, ptr), jdef, VARIABLE_NONE, pf, &jvar);
      if (jvar) {
        variable_flags_set_all(jvar, jvar_flags);
        jvals[JAL_VAL_TYPE_BASE] = value_alloc(jvar);
        variable_release(jvar);
      }
    }
    pf_token_get(pf, PF_TOKEN_NEXT);
    var = value_variable_get(jvals[JAL_VAL_TYPE_BASE]);
  }
  jal_value_release(jvals);
  return var;
}

static value_t jal_parse_init(pfile_t *pf, variable_def_t def);

static value_t jal_parse_array_init(pfile_t *pf, variable_def_t def)
{
  value_t               stval;
  const char           *str;
  variable_def_member_t mbr;
  variable_def_t        mbr_def;
  size_t                mbr_ct;
  size_t                mbr_sz;

  mbr     = variable_def_member_get(def);
  mbr_def = variable_def_member_def_get(mbr);
  mbr_ct  = variable_def_member_ct_get(mbr);
  mbr_sz  = variable_def_member_sz_get(mbr);
  str = pf_token_get(pf, PF_TOKEN_CURRENT);
  if ('"' == *str) {
    if (VARIABLE_DEF_TYPE_INTEGER != variable_def_type_get(mbr_def)) {
      pfile_log(pf, PFILE_LOG_ERR, "type mismatch");
      stval = VALUE_NONE;
    } else {
      size_t         ii;
      variable_t     stvar;
      variable_def_t stdef;
      char          *stdata;
      size_t         len;
      
      str++;
      len = pf_token_sz_get(pf) - 1;
      if (len && ('"' == str[len - 1])) {
        len--;
      }

      if (VARIABLE_CT_UNKNOWN == mbr_ct) {
        mbr_ct = len;
        variable_def_member_ct_set(def, mbr, mbr_ct);
      }
      stdef = variable_def_flags_change(def, VARIABLE_DEF_FLAG_CONST);
      stval = pfile_constant_get(pf, 0, stdef);
      stvar = value_variable_get(stval);

      for (ii = 0, 
             stdata = variable_data_get(stvar);
           ii < mbr_ct;
           stdata += mbr_sz,
             ii++) {
        *stdata = str[ii];
        if (mbr_sz > 1) {
          memset(stdata + 1, 0, mbr_sz - 1);
        }
      }
      if (len < mbr_ct) {
        pfile_log(pf, PFILE_LOG_WARN, "fewer initializers than expected");
      } else if (len > mbr_ct) {
        pfile_log(pf, PFILE_LOG_WARN, "more initializers than expected");
      }
    }
    pf_token_get(pf, PF_TOKEN_NEXT);
  } else if (!pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "{")) {
    stval = VALUE_NONE;
  } else {
    value_t   *vals;
    size_t     vals_ct;
    size_t     vals_alloc;
    boolean_t  is_const;
    boolean_t  is_overflow;
    boolean_t  is_oom;

    vals_ct     = 0;
    vals_alloc  = (mbr_ct == (variable_ct_t) -1) ? 16 : mbr_ct;
    vals        = MALLOC(sizeof(*vals) * vals_alloc);
    is_const    = BOOLEAN_TRUE;
    is_overflow = BOOLEAN_FALSE;
    is_oom      = BOOLEAN_FALSE;
    for ( ; ; ) {
      pf_token_get(pf, PF_TOKEN_NEXT);
      stval = jal_parse_init(pf, mbr_def);
      if (vals_ct == mbr_ct) {
        value_release(stval);
        is_overflow = BOOLEAN_TRUE;
      } else if (is_oom) {
        value_release(stval);
      } else {
        if (vals_ct == vals_alloc) {
          value_t *tmp;

          vals_alloc *= 2;
          tmp         = REALLOC(vals, sizeof(*vals) * vals_alloc);
          if (tmp == NULL) {
            is_oom = BOOLEAN_TRUE;
          } else {
            vals = tmp;
          }
        }
        if (!is_oom) {
          vals[vals_ct] = stval;
          is_const     &= value_is_const(vals[vals_ct]);
          if (variable_def_flag_test(def, VARIABLE_DEF_FLAG_CONST) &&
            !value_is_const(vals[vals_ct])) {
            pfile_log(pf, PFILE_LOG_ERR, "initializer %u must be constant",
              (unsigned) vals_ct + 1);
          }
          vals_ct++;
        } else {
          value_release(stval);
        }
      }
      if (!pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ",")) {
        break;
      }
    }
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "}")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    if (VARIABLE_CT_UNKNOWN == mbr_ct) {
      mbr_ct = vals_ct;
      variable_def_member_ct_set(def, mbr, mbr_ct);
    }

    if (is_overflow) {
      pfile_log(pf, PFILE_LOG_WARN, "more initializers than expected");
    } else if (vals_ct < mbr_ct) {
      pfile_log(pf, PFILE_LOG_WARN, "fewer initializers than expected");
    }

    if (is_const) {
      size_t         ii;
      variable_t     stvar;
      variable_def_t stdef;
      char          *stdata;
      size_t         sz;

      stdef = variable_def_flags_change(def, VARIABLE_DEF_FLAG_CONST);
      stval = pfile_constant_get(pf, 0, stdef);
      stvar = value_variable_get(stval);

      sz = variable_def_sz_get(mbr_def);
      if ((VARIABLE_DEF_TYPE_FLOAT == variable_def_type_get(mbr_def))
        || (VARIABLE_DEF_TYPE_INTEGER == variable_def_type_get(mbr_def))) {
        /*
         * This might have to convert between different integer and/or
         * floating point types.
         */
        size_t dst_ofs;
        
        for (ii = 0, dst_ofs = 0; ii < vals_ct; ii++, dst_ofs += sz) {
          if (value_is_float(vals[ii])) {
            float f;

            f = value_const_float_get(vals[ii]);
            if (VARIABLE_DEF_TYPE_FLOAT == variable_def_type_get(mbr_def)) {
              variable_const_float_set(stvar, dst_ofs, f);
            } else {
              variable_const_set(stvar, mbr_def, dst_ofs, f);
            }
          } else {
            variable_const_t n;

            n = value_const_get(vals[ii]);
            if (VARIABLE_DEF_TYPE_FLOAT == variable_def_type_get(mbr_def)) {
              variable_const_float_set(stvar, dst_ofs, n);
            } else {
              variable_const_set(stvar, mbr_def, dst_ofs, n);
            }
          }
        }
      } else {
        for (ii = 0, 
               stdata = variable_data_get(stvar);
             ii < vals_ct;
             stdata += sz,
               ii++) {
          memcpy(stdata, variable_data_get(value_variable_get(vals[ii])), sz);
          value_release(vals[ii]);
        }
      }
    } else {
      size_t ii;
      size_t offset;

      stval = pfile_value_temp_get_from_def(pf, def);
      for (ii = 0, offset = 0;
           ii < vals_ct; 
           offset += mbr_sz, ii++) {
        value_t mbrval;
        value_t mbrofs;

        mbrval = value_alloc(value_variable_get(stval));
        value_def_set(mbrval, variable_def_member_def_get(mbr));
        mbrofs = pfile_constant_get(pf, offset, VARIABLE_DEF_NONE);
        value_baseofs_set(mbrval, mbrofs);
        pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &mbrval, vals[ii], VALUE_NONE);
        value_release(mbrofs);
        value_release(mbrval);
        value_release(vals[ii]);
      }
    }
    FREE(vals);
  }
  return stval;
}

static value_t jal_parse_struct_init(pfile_t *pf, variable_def_t def)
{
  value_t stval;

  if (!pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "{")) {
    stval = VALUE_NONE;
  } else {
    variable_def_member_t mbr;
    value_t              *vals;
    size_t                vals_sz; /* number allocated */
    size_t                vals_ct; /* number in use    */
    boolean_t             is_const;

    vals_ct = 0;
    vals_sz = 0;
    vals    = 0;

    is_const = BOOLEAN_TRUE;
    /* first, parse as many elements as there are */
    for (mbr = variable_def_member_get(def);
         mbr;
         mbr = variable_def_member_link_get(mbr)) {
      /* skip either '{' or ',' */
      pf_token_get(pf, PF_TOKEN_NEXT);
      if (vals_ct == vals_sz) {
        value_t *tmp;
        size_t   tmp_sz;

        tmp_sz = (vals_sz) ? 2 * vals_sz : 16;
        tmp    = REALLOC(vals, sizeof(*vals) * tmp_sz);
        if (tmp) {
          vals    = tmp;
          vals_sz = tmp_sz;
        }
      }
      stval = jal_parse_init(pf, variable_def_member_def_get(mbr));
      if (vals_ct < vals_sz) {
        vals[vals_ct] = stval;
        is_const &= value_is_const(vals[vals_ct]);
        if (variable_def_flag_test(def, VARIABLE_DEF_FLAG_CONST) &&
          !value_is_const(vals[vals_ct])) {
          pfile_log(pf, PFILE_LOG_ERR, "initializer %u must be constant",
            (unsigned) vals_ct + 1);
        }
        vals_ct++;
      } else {
        value_release(stval);
      }
      if (!pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ",")) {
        break;
      }
    }
    if (variable_def_member_link_get(mbr)) {
      pfile_log(pf, PFILE_LOG_WARN, "fewer initializers than expected");
    }
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "}")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    /* OK, we've all of the values. was this const? */
    if (is_const) {
      size_t         ii;
      variable_t     stvar;
      variable_def_t stdef;
      char          *stdata;
      size_t         sz;

      stdef = variable_def_flags_change(def, VARIABLE_DEF_FLAG_CONST);
      stval = pfile_constant_get(pf, 0, stdef);
      stvar = value_variable_get(stval);

      for (ii = 0, 
             mbr = variable_def_member_get(def),
             stdata = variable_data_get(stvar);
           ii < vals_ct;
           stdata += sz,
             mbr = variable_def_member_link_get(mbr),
             ii++) {
        sz = variable_def_member_sz_get(mbr);
        memcpy(stdata, variable_data_get(value_variable_get(vals[ii])), sz);
        value_release(vals[ii]);
      }
    } else {
      size_t ii;
      size_t offset;

      stval = pfile_value_temp_get_from_def(pf, def);
      for (ii = 0, offset = 0, mbr = variable_def_member_get(def); 
           ii < vals_ct; 
           offset += variable_def_member_sz_get(mbr),
             mbr = variable_def_member_link_get(mbr),
             ii++) {
        value_t mbrval;
        value_t mbrofs;

        mbrval = value_alloc(value_variable_get(stval));
        value_def_set(mbrval, variable_def_member_def_get(mbr));
        mbrofs = pfile_constant_get(pf, offset, VARIABLE_DEF_NONE);
        value_baseofs_set(mbrval, mbrofs);
        pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &mbrval, vals[ii], VALUE_NONE);
        value_release(mbrofs);
        value_release(mbrval);
        value_release(vals[ii]);
      }
    }
    FREE(vals);
  }
  return stval;
}

static value_t jal_parse_init(pfile_t *pf, variable_def_t def)
{
  value_t val;

  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "{")) {
    if (VARIABLE_DEF_TYPE_STRUCTURE == variable_def_type_get(def)) {
      val = jal_parse_struct_init(pf, def);
    } else if (VARIABLE_DEF_TYPE_ARRAY == variable_def_type_get(def)) {
      val = jal_parse_array_init(pf, def);
    } else {
      val = VALUE_NONE;
    }
  } else if ((*pf_token_get(pf, PF_TOKEN_CURRENT) == '"') 
    && (VARIABLE_DEF_TYPE_ARRAY == variable_def_type_get(def))) {
    val = jal_parse_array_init(pf, def);
  } else {
    val = jal_parse_expr(pf);
  }
  return val;
}

void jal_parse_var_common(pfile_t *pf, 
  const pfile_pos_t *statement_start, variable_t *dst, flag_t flags)
{
  variable_def_t vdef;
  const char    *ptr;
  pf_token_get_t which;

  UNUSED(statement_start);
  which = PF_TOKEN_CURRENT;
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "volatile")) {
    if (flags & VARIABLE_DEF_FLAG_CONST) {
      pfile_log(pf, PFILE_LOG_ERR, "volatile cannot be used here");
    } else {
      flags |= VARIABLE_DEF_FLAG_VOLATILE;
    }
    which = PF_TOKEN_NEXT;
  }
  ptr = pf_token_get(pf, which);
  vdef = jal_vdef_get(pf, flags);
  which = PF_TOKEN_CURRENT;
  flags |= variable_def_flags_get_all(vdef);
  do {
    /* parse a list of variable names */
    jal_variable_info_t inf;

    jal_variable_info_init(&inf);

    inf.vdef      = vdef;
    inf.def_flags = flags;

    if (pf_token_is(pf, which, PFILE_LOG_NONE, "volatile")) {
      inf.def_flags |= VARIABLE_DEF_FLAG_VOLATILE;
      which = PF_TOKEN_NEXT;
    } else {
      which = PF_TOKEN_CURRENT;
    }
    if (dst) {
      if (pf_token_is(pf, which, PFILE_LOG_NONE, "in")) {
        inf.def_flags |= VARIABLE_DEF_FLAG_IN;
        which = PF_TOKEN_NEXT;
      } else {
        which = PF_TOKEN_CURRENT;
      }
      if (pf_token_is(pf, which, PFILE_LOG_NONE, "out")) {
        inf.def_flags |= VARIABLE_DEF_FLAG_OUT;
        which = PF_TOKEN_NEXT;
      } else {
        which = PF_TOKEN_CURRENT;
      }
      if (pf_token_is(pf, which, PFILE_LOG_NONE, "byref")) {
        inf.def_flags |= VARIABLE_DEF_FLAG_BYREF;
        which = PF_TOKEN_NEXT;
      } else {
        which = PF_TOKEN_CURRENT;
      }
      if (inf.def_flags & VARIABLE_DEF_FLAG_BYREF) {
        if (inf.def_flags & (VARIABLE_DEF_FLAG_IN | VARIABLE_DEF_FLAG_OUT)) {
          pfile_log(pf, PFILE_LOG_ERR, 
            "byref cannot be combined with in or out");
          inf.def_flags &= ~(VARIABLE_DEF_FLAG_IN | VARIABLE_DEF_FLAG_OUT);
        }
        if (inf.def_flags & VARIABLE_DEF_FLAG_VOLATILE) {
          pfile_log(pf, PFILE_LOG_ERR,
            "byref cannot be combined with volatile");
          inf.def_flags &= ~VARIABLE_DEF_FLAG_VOLATILE;
        }
      } else if (!(inf.def_flags 
        & (VARIABLE_DEF_FLAG_IN | VARIABLE_DEF_FLAG_OUT))) {
        pfile_log(pf, PFILE_LOG_ERR, "in and/or out required");
      }
    }

    ptr = pf_token_get(pf, which);
    if (!jal_token_is_identifier(pf)) {
      pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_VARIABLE_EXPECTED);
    } else {
      /* encapsulate everything needed to create this variable */
      variable_t   var;

      var = VARIABLE_NONE;
      jal_identifier_is_reserved(pf);
      inf.name = STRDUP(pf_token_get(pf, PF_TOKEN_CURRENT));
      if (!inf.name) {
        pfile_log_syserr(pf, ENOMEM);
      }
      if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_NONE, "[")) {
        /* an array */
        variable_def_t adef;

        inf.def_flags &= ~VARIABLE_DEF_FLAG_SIGNED;
        if (variable_def_flag_test(vdef, VARIABLE_DEF_FLAG_BIT)) {
          pfile_log(pf, PFILE_LOG_ERR, "bit arrays not supported");
        }
        if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_NONE, "]")) {
          inf.ct = VARIABLE_CT_UNKNOWN;
        } else {
          value_t n;

          n = jal_parse_expr(pf);
          if (n) {
            if (!value_is_const(n)) {
              pfile_log(pf, PFILE_LOG_ERR, "constant expected");
            } else if (value_const_get(n) < 1) {
              pfile_log(pf, PFILE_LOG_ERR, "dimension must be >= 1");
            } else {
              inf.ct = value_const_get(n);
            }
            value_release(n);
          }
        }
        if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "]")) {
          pf_token_get(pf, PF_TOKEN_NEXT);
        }
        adef = variable_def_alloc(0, VARIABLE_DEF_TYPE_ARRAY,
          inf.def_flags, 0);
        variable_def_member_add(adef, 0, inf.vdef, inf.ct);
        inf.vdef = adef;
        inf.ct   = 0;
      }
      if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "shared")) {
        inf.var_flags = VARIABLE_FLAG_SHARED;
        pf_token_get(pf, PF_TOKEN_NEXT);
      }
      if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "at")) {
        /* a placed variable */
        if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_NONE, "{")) {
          /* 
           * this is a variable mirrored in multiple places
           */
          size_t ii;

          for (ii = 0; 
               (ii < VARIABLE_MIRROR_CT)
               && (!ii 
                 || pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ",")); 
                 ii++) {
            /* skip the "{" or "," */
            value_t n;

            pf_token_get(pf, PF_TOKEN_NEXT);
            n = jal_parse_expr(pf);
            if (n) {
              if (!value_is_const(n)) {
                pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_EXPECTED);
              } else {
                inf.base[inf.base_ct] = value_const_get(n);
                inf.base_ct++;
              }
              value_release(n);
            }
          }
          if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "}")) {
            pf_token_get(pf, PF_TOKEN_NEXT);
          }
        } else {
          ptr    = pf_token_get(pf, PF_TOKEN_CURRENT);
          inf.master = pfile_variable_find(pf, PFILE_LOG_NONE, ptr, 0);
          variable_flag_set(inf.master, VARIABLE_FLAG_UNREPLACEABLE);
          /* if this is a bit variable, the master will be set to
             _bit_bucket. We need to remove that */
          if (inf.master && !variable_is_const(inf.master)) {
            /* this is AT variable [: bitpos] */
            value_t tmp;

            pf_token_get(pf, PF_TOKEN_NEXT);
            inf.base[0] = 0;
            inf.base_ct = 1;

            tmp = value_alloc(inf.master);
            while (jal_parse_subscript(pf, &tmp)
              || jal_parse_structure(pf, &tmp))
              ; /* empty loop */
            if (value_baseofs_get(tmp)) {
              if (!value_is_const(value_baseofs_get(tmp))) {
                pfile_log(pf, PFILE_LOG_ERR, "constant expression expected");
              }
              inf.base[0] = value_const_get(value_baseofs_get(tmp));
            }
            value_release(tmp);
          } else {
            /* this is AT cexpr [ : bitpos] */
            value_t n;

            /* 
             * protect against the following:
             *    const bubba = 0x400
             *    var word xx at bubba
             */
            variable_release(inf.master);
            inf.master = VARIABLE_NONE;

            n = jal_parse_expr(pf);
            if (n) {
              if (!value_is_const(n)) {
                pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_EXPECTED);
              } else {
                inf.base[0] = value_const_get(n);
                inf.base_ct = 1;
              }
              value_release(n);
            }
          }
          if (variable_def_flag_test(vdef, VARIABLE_DEF_FLAG_BIT)
            && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ":")) {
            value_t n;

            pf_token_get(pf, PF_TOKEN_NEXT);
            n = jal_parse_expr(pf);
            if (n) {
              if (!value_is_const(n)) {
                pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_EXPECTED);
              } else {
                inf.bit = value_const_get(n);
              }
              value_release(n);
            }
          } else if (!variable_def_flag_test(vdef, VARIABLE_DEF_FLAG_BIT)
            && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "+")) {
            value_t n;

            pf_token_get(pf, PF_TOKEN_NEXT);
            n = jal_parse_expr(pf);
            if (n) {
              if (!value_is_const(n)) {
                pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_EXPECTED);
              } else {
                inf.base[0] = value_const_get(n);
              }
              value_release(n);
            }
          }
        }
      } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "is")) {
        /* an alias */
#if 0
        pfile_log(pf, PFILE_LOG_WARN, 
          "'IS' has been deprecated, please use `ALIAS' instead");
#endif
        pf_token_get(pf, PF_TOKEN_NEXT);
        inf.master = jal_parse_var_alias(pf);
        if (inf.master) {
          if (!variable_def_is_same(inf.vdef, 
              variable_def_get(inf.master))) {
            pfile_log(pf, PFILE_LOG_ERR, "type mismatch");
          }
          inf.var_flags = VARIABLE_FLAG_ALIAS;
          variable_lock(inf.master);
        }
      }
      if (!vdef 
            || pf_token_is(pf, PF_TOKEN_CURRENT, 
                 (flags & VARIABLE_DEF_FLAG_CONST) 
                  ? PFILE_LOG_ERR : PFILE_LOG_NONE, "=")) {
        value_t sval;
        value_t dval;
        /* pre-assigned */
        pf_token_get(pf, PF_TOKEN_NEXT);
        sval = jal_parse_init(pf, inf.vdef);
        inf.ct = 0;
        if ((VARIABLE_DEF_TYPE_ARRAY == variable_def_type_get(inf.vdef))
          && (VARIABLE_CT_UNKNOWN == variable_def_member_ct_get(
            variable_def_member_get(inf.vdef)))) {
          variable_def_member_ct_set(inf.vdef,
            variable_def_member_get(inf.vdef),
            variable_def_member_ct_get(variable_def_member_get(
              value_def_get(sval))));
        }
        var = jal_variable_alloc(pf, &inf, dst != 0, 0, 0, 
            PFILE_VARIABLE_ALLOC_LOCAL);
        dval = value_alloc(var);
        if (value_is_const(dval)) {
          if (!value_is_const(sval)) {
            pfile_log(pf, PFILE_LOG_ERR, "constant expected");
          } else if (value_is_float(sval) || value_is_float(dval)) {
            if (value_is_float(sval)) {
              float f;

              f = value_const_float_get(sval);
              if (value_is_float(dval)) {
                value_const_float_set(dval, f);
              } else {
                value_const_set(dval, f);
              }
            } else {
              variable_const_t n;

              n = value_const_get(sval);
              if (value_is_float(dval)) {
                if (value_is_signed(sval)) {
                  value_const_float_set(dval, (long) n);
                } else {
                  value_const_float_set(dval, n);
                }
              } else {
                value_const_set(dval, n);
              }
            }
          } else {
            const char *src_data;
            char       *dst_data;

            src_data = variable_data_get(value_variable_get(sval));
            dst_data = variable_data_get(value_variable_get(dval));
            if (variable_def_is_same(value_def_get(dval), 
              value_def_get(sval))) {
              /* trivial case, simply copy */
              if (src_data && dst_data) {
                memcpy(dst_data, src_data, value_sz_get(dval));
              }
            } else if (value_is_array(dval) && value_is_array(sval)) {
              /*
               * can assign arrays of unequal length; for integers
               * conversion might be required
               */
              if (!variable_def_member_is_same(
                variable_def_member_get(value_def_get(sval)), 
                variable_def_member_get(value_def_get(dval)))) {
              }
            } else if (value_is_number(sval) && value_is_number(dval)) {
              /*
               * conversion required here
               */
              value_const_set(dval, value_const_get(sval));
            } else {
              pfile_log(pf, PFILE_LOG_ERR, "type mismatch");
            }
          }
        } else {
          pfile_cmd_op_add(pf, OPERATOR_ASSIGN, &dval, sval, VALUE_NONE);
        }
        value_release(sval);
        value_release(dval);
        if (0 != dst) {
          pfile_log(pf, PFILE_LOG_ERR, "Default parameters are not allowed");
        }
      } else {
        if ((-1U == inf.ct) && !dst) {
          pfile_log(pf, PFILE_LOG_ERR,
            "Flexible arrays can only be used as parameters");
        }
        var = jal_variable_alloc(pf, &inf, dst != 0, 0, 0, 
            PFILE_VARIABLE_ALLOC_LOCAL);
#if 0
        if (variable_master_get(var)) {
          variable_flag_set(variable_master_get(var), 
            VARIABLE_FLAG_UNREPLACEABLE);
        }
#endif
        jal_variable_info_cleanup(&inf);
      }
      if (dst) {
        *dst = var;
      } else {
        variable_release(var);
      }
    }
    which = PF_TOKEN_NEXT;
  } while (!dst && pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ","));
}

void jal_parse_var(pfile_t *pf, const pfile_pos_t *statement_start)
{
  jal_parse_var_common(pf, statement_start, 0, VARIABLE_DEF_FLAG_NONE);
}

void jal_parse_const(pfile_t *pf, const pfile_pos_t *statement_start)
{
  jal_parse_var_common(pf, statement_start, 0, VARIABLE_DEF_FLAG_CONST);
}

/*
 * RECORD name IS
 *    type identifier[,...]
 *    ...
 * END RECORD
 */
void jal_parse_record(pfile_t *pf, const pfile_pos_t *start)
{
  UNUSED(start);
  if (!jal_token_is_identifier(pf)) {
    pfile_log(pf, PFILE_LOG_ERR, "identifier expected");
  } else {
    variable_def_t def;

    def = variable_def_alloc(pf_token_get(pf, PF_TOKEN_CURRENT),
        VARIABLE_DEF_TYPE_STRUCTURE, VARIABLE_DEF_FLAG_NONE, 0);
    if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "is")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    do {
      boolean_t      first;
      variable_def_t mdef;

      first = BOOLEAN_TRUE;
      mdef = jal_vdef_get(pf, VARIABLE_DEF_FLAG_NONE);
      do {
        if (first) {
          first = BOOLEAN_FALSE;
        } else {
          pf_token_get(pf, PF_TOKEN_NEXT);
        }
        if (!jal_token_is_identifier(pf)) {
          pf_token_get(pf, PF_TOKEN_NEXT);
        } else {
          char       *tag;
          const char *ptr;
          size_t      ct;

          ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
          tag = MALLOC(1 + strlen(ptr));
          if (!tag) {
            pfile_log_syserr(pf, ENOMEM);
          } else {
            strcpy(tag, ptr);
          }
          ct  = 1;
          if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_NONE, "[")) {
            value_t        cexpr;
            pf_token_get(pf, PF_TOKEN_NEXT);
            cexpr = jal_parse_expr(pf);
            if (!value_is_const(cexpr)) {
              pfile_log(pf, PFILE_LOG_ERR, "constant expression expected");
            } else {
              ct = value_const_get(cexpr);
              if (ct < 1) {
                pfile_log(pf, PFILE_LOG_ERR, "dimension must be >= 1");
                ct = 1;
              }
            }
            value_release(cexpr);
            if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "]")) {
              pf_token_get(pf, PF_TOKEN_NEXT);
            }
            if (tag && mdef) {
              variable_def_t adef;

              adef = variable_def_alloc(tag, VARIABLE_DEF_TYPE_ARRAY,
                  VARIABLE_DEF_FLAG_NONE, 0);
              variable_def_member_add(adef, 0, mdef, ct);
              variable_def_member_add(def, tag, adef, 1);
            }
          } else {
            if (tag && mdef) {
              variable_def_member_add(def, tag, mdef, ct);
            }
          }
          FREE(tag);
        }
      } while (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ","));
    } while (!pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "end"));
    if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "record")) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
    if (variable_def_sz_get(def)) {
      pfile_variable_def_add(pf, def);
    }
  }
}

