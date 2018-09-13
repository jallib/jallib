/************************************************************
 **
 ** pfile.c : p-code file definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/

#include <stdarg.h>
#include <string.h>
#include <errno.h>
#include <assert.h>
#include "../libutils/mem.h"
#include "expr.h"
#include "cmd_brch.h"
#include "cmd_optm.h"
#include "cmd_op.h"
#include "cmd_asm.h"
#include "cmd_log.h"
#include "cmdarray.h"
#include "pfiled.h"
#include "pf_proc.h"
#include "pf_msg.h"
#include "pf_cmd.h"
#include "pf_expr.h"
#include "pf_op.h"

#include "exprnode.h"

/* when the opt loop reaches this, assume we're in some
 * oscillating state and stop looping
 */
#define OPT_PASS_INFINITE 32
/*
 * NAME
 *   pfile_open
 *
 * DESCRIPTION
 *   create the pfile structure
 *
 * PARAMETERS
 *   dst : [out] holds result
 *   name  : source name
 *   f_src : source file    (input)
 *   f_asm : assembly file  (output)
 *   f_lst : listing file   (output)
 *   f_hex : intel hex file (output)
 *   f_log : log file       (output)
 *
 * RETURN
 *   0 : no error
 *
 * NOTES
 */
result_t pfile_open(pfile_t **dst, 
    FILE *f_asm, FILE *f_lst, FILE *f_hex, FILE *f_log, 
    const char *COD_name, flag_t flags, pfile_vectors_t *vectors, 
    void *arg, unsigned task_ct, const char *compiler)
{
  pfile_t *pf;
  int      rc;

  pf = MALLOC(sizeof(*pf));
  if (0 == pf) {
    rc = RESULT_MEMORY;
  } else {
    rc = RESULT_OK;
    pf->src   = 0;
    pf->f_asm = f_asm;
    pf->f_lst = f_lst;
    pf->f_hex = f_hex;
    pf->f_log = f_log;
    pf->COD_name = COD_name;
    pf->COD_dir  = 0;
    if (COD_name) {
      pf->COD_dir = COD_directory_alloc((const uchar *) compiler);
    }

    /* the following are set by token_get: 
       ch_unget
       line_no
       token_len
       token
    */   
    pf->errct       = 0;
    pf->warnct      = 0;
    pf->statement_start.src = 0;
    pf->statement_start.line = 0;
    pf->codegen_disable = 0;
    pf->cmd_head    = CMD_NONE;
    pf->cmd_tail    = CMD_NONE;
    pf->cmd_cursor  = CMD_NONE;
    pf->proc_root   = pfile_proc_alloc(PFILE_PROC_NONE, LABEL_NONE, 
        LABEL_NONE, LABEL_NONE, VARIABLE_DEF_NONE);
    pf->proc_active = pf->proc_root;
    (void) pfile_block_enter(pf);
    variable_list_init(&pf->var_const);

    pf->label_temp_ct = 0;
    label_list_init(&pf->label_temp);
    pf->label_temp_ptr  = 0;

    pf->label_main = 0;
    pf->label_isr  = 0;
    pf->label_isr_preamble = 0;

    pf->hex.pc_msw = (unsigned) -1;
    pf->hex.pc     = 0;
    pf->hex.ct     = 0;
    pf->flags      = flags;

    pf->vectors    = vectors;
    pf->vector_arg = arg;
    pf->include_path  = 0;
    pf->unnamed_vdefs = 0;
    pf->tag_list      = TAG_NONE;
    pf->src_list      = PFILE_SOURCE_NONE;
    pf->stats.lines   = 0;
    pf->stats.chars   = 0;
    pf->stats.files   = 0;
    pf->token_ct      = 0;

        /* allocate the predefined labels and variables */
    /* _isr_cleanup --> user jumps to this when isr processing
                        is finished
       _freq        --> clock frequency of the PIC */ 
    label_release(pfile_label_alloc(pf, "_isr_cleanup"));
    pf->label_isr_preamble = pfile_label_alloc(pf, "_isr_preamble");
    pf->task_ct = task_ct;
    pf->exit_label = LABEL_NONE;
    pf->multiply_ct = 0;

	  rc = pf->vectors->pf_open_fn(pf);
    if (RESULT_OK != rc) {
      pfile_close(pf);
    } else {
      *dst = pf;
    }
  }
  return rc;
}

/*
 * NAME
 *   pfile_hex_line_flush
 *
 * DESCRIPTION
 *   flush the current line in the hex buffer
 *
 * PARAMETERS
 *   pf : pfile
 *
 * RETURN
 *   none
 *
 * NOTES
 */
static void pfile_hex_line_flush(pfile_t *pf)
{
  if (pf->f_hex && pf->hex.ct) {
    unsigned ii;
    unsigned chk;

    fprintf(pf->f_hex, ":%02X%02X%02X00", 
        pf->hex.ct,
        (pf->hex.pc >> 8) & 0xff,
        (pf->hex.pc     ) & 0xff);
    chk = pf->hex.ct
        + ((pf->hex.pc >> 8) & 0xff)
        + ((pf->hex.pc     ) & 0xff);
    for (ii = 0; ii < pf->hex.ct; ii++) {
      chk += pf->hex.buf[ii];
      fprintf(pf->f_hex, "%02X", pf->hex.buf[ii]);
    }
    fprintf(pf->f_hex, "%02X\n", (unsigned char) (-chk));
  }
  pf->hex.ct = 0;
}

/*
 * NAME
 *   pfile_close
 *
 * DESCRIPTION
 *   close an open pfile
 *
 * PARAMETERS
 *   pf : returned from pfile_open
 *
 * RETURN
 *   none
 *
 * NOTES
 */
void pfile_close(pfile_t *pf)
{
  COD_directory_free(pf->COD_dir);
  pf->vectors->pf_cmd_cleanup(pf);
  pf->vectors->pf_close_fn(pf);
  cmd_list_free(pf->cmd_head);

  pfile_user_entry_set(pf, 0);
  /*pfile_isr_entry_set(pf, 0);*/
  label_release(pf->label_isr_preamble);
  pfile_proc_free(pf->proc_root, pf);

  label_list_reset(&pf->label_temp);

  variable_list_reset(&pf->var_const);
  pfile_hex_line_flush(pf);
  if (pf->f_hex) {
    fprintf(pf->f_hex, ":00000001FF\n");
  }
  pfile_source_restore(pf, 0);
  while (pf->tag_list) {
    tag_t tag;

    tag = pf->tag_list;
    pf->tag_list = tag_link_get(tag);

    if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_COMPILER)) {
      if (tag_ref_ct_get(tag) != 1) {
        fprintf(stderr, "!!! tag 0x%lx: %s(%u) ct = %u\n", 
            (ulong) tag, tag_name_get(tag),
            tag_n_get(tag), tag_ref_ct_get(tag));
      }
    }
    tag_release(tag);
  }
  variable_def_ugly_hack_cleanup();
    
  FREE(pf);
}

/*
 * NAME
 *   pfile_reset
 *
 * DESCRIPTION
 *   reset the pfile descriptor
 *
 * PARAMETERS
 *   pf : pfile
 *
 * RETURN
 *   none
 *
 * NOTES
 *   this:
 *      1. free all commands
 *      2. reset the temp var ptr
 *      3. reset the temp label ptr
 *      4. rewind the source file
 */
#if 0
static void pfile_proc_calls_dump(pfile_t *pf, pfile_proc_t *proc, int lvl)
{
  size_t        ii;
  pfile_proc_t *calls;

  ii = 0;
  do {
    calls = pfile_proc_calls_get(proc, ii);
    if (calls) {
      pfile_write(pf, pfile_write_lst, "; %*s-->%s\n", lvl, "",
          pfile_proc_tag_get(calls));
      pfile_proc_calls_dump(pf, calls, lvl + 2);
      ii++;
    }
  } while (calls);
}
#endif

/*
 * NAME
 *   pfile_ch_get
 *
 * DESCRIPTION
 *   get the next character from the file
 *
 * PARAMETERS
 *   pf : returned from pfile_open
 *
 * RETURN
 *   character read, or EOF
 *
 * NOTES
 *   needed due to problems in some versions of ungetc()
 */
int pfile_ch_get(pfile_t *pf)
{
  int ch;

  ch = pfile_source_ch_get(pf->src);
  if ('\n' == ch) {
    pf->stats.lines++;
  }
  pf->stats.chars++;
  return ch;
}

/*
 * NAME
 *   pfile_ch_unget
 *
 * DESCRIPTION
 *   return a character to the file
 *
 * PARAMETERS
 *   pf : returned from pfile_open
 *   ch : last character read
 *
 * RETURN
 *   none
 *  
 * NOTES
 *   only one character can be unget()
 */
void pfile_ch_unget(pfile_t *pf, int ch)
{
  pfile_source_ch_unget(pf->src, ch);
  if ('\n' == ch) {
    pf->stats.lines--;
  }
  pf->stats.chars--;
}

/*
 * NAME
 *   pfile_constant_get
 *
 * DESCRIPTION
 *   return an unnamed constant whose value matches val
 *
 * PARAMETERS
 *   pf  :
 *   val : value to match
 *   dst : holds result on success
 *
 * RETURN
 *   0 : no error
 *
 * NOTES
 */

/* unnamed constant find */
typedef struct uncfind_data_ {
  variable_const_t n;
  variable_def_t   def;
} uncfind_data_t;

static boolean_t uncfind_cb(void *arg, const variable_t var, 
    const void *unused)
{
  uncfind_data_t *data;

  UNUSED(unused);

  data = arg;

  return (variable_is_const(var))
    && (data->n == variable_const_get(var, variable_def_get(var), 0))
    && (!data->def 
        || (variable_def_is_same(data->def, variable_def_get(var))));
}

value_t pfile_constant_get(pfile_t *pf, variable_const_t n, variable_def_t def)
{
  /* let's find a suitable constant or create one */
  uncfind_data_t data;
  variable_t     var;
  value_t        val;

  val = VALUE_NONE;
  data.n   = n;
  data.def = def;

  /* now that we know what to look for, find it! */
  var = variable_list_find(&pf->var_const, uncfind_cb, &data, 0);
  if (var) {
    val = value_alloc(var);
    variable_release(var);
  } else {
    val = value_constant_get(n, def);
    if (var) {
      variable_list_append(&pf->var_const, value_variable_get(val));
    }
  }
  if (!val) {
    pfile_log_syserr(pf, ENOMEM);
  } 
  return val;
}

typedef struct uncffind_data_ {
  float            n;
  variable_def_t   def;
} uncffind_data_t;

static boolean_t uncffind_cb(void *arg, const variable_t var, 
    const void *unused)
{
  uncffind_data_t *data;

  UNUSED(unused);

  data = arg;

  return (variable_is_const(var))
    && (data->n == variable_const_float_get(var, 0))
    && (!data->def 
        || (variable_def_is_same(data->def, variable_def_get(var))));
}

value_t pfile_constant_float_get(pfile_t *pf, float n, variable_def_t def)
{
  /* let's find a suitable constant or create one */
  uncffind_data_t data;
  variable_t      var;
  value_t         val;

  val = VALUE_NONE;
  data.n   = n;
  data.def = def;

  /* now that we know what to look for, find it! */
  var = variable_list_find(&pf->var_const, uncffind_cb, &data, 0);
  if (var) {
    val = value_alloc(var);
    variable_release(var);
  } else {
    val = value_constant_float_get(n, def);
    if (var) {
      variable_list_append(&pf->var_const, value_variable_get(val));
    }
  }
  if (!val) {
    pfile_log_syserr(pf, ENOMEM);
  } 
  return val;
}
/*
 * NAME
 *   pfile_value_alloc
 *
 * DESCRIPTION
 *   allocate a variable and a value to contain it
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 */
result_t pfile_value_alloc(pfile_t *pf, pfile_variable_alloc_t which,
    const char *name, variable_def_t def, value_t *dst)
{
  result_t   rc;
  variable_t var;

  rc = pfile_variable_alloc(pf, which, name, def, VARIABLE_NONE, &var);
  if (RESULT_OK == rc) {
    value_t val;

    val = value_alloc(var);
    variable_release(var);
    if (!val) {
      rc = RESULT_MEMORY;
    } else {
      rc = RESULT_OK;
      if (dst) {
        *dst = val;
      } else {
        value_release(val);
      }
    }
  }
  return rc;
}

/*
 * NAME
 *   pfile_value_temp_get
 *
 * DESCRIPTION
 *   return a temporary; allocate a new one if necessary
 *
 * PARAMETERS
 *   pf    : 
 *   sz    : 
 *   flags : 
 *   dst   : [out] holds result on success
 *
 * RETURN
 *
 * NOTES
 */
value_t pfile_value_temp_get(pfile_t *pf, variable_def_type_t type,
    variable_sz_t sz)
{
  assert(sz);
  return pfile_proc_value_temp_get(pf->proc_active, pf, type, sz);
}

value_t pfile_value_temp_get_from_def(pfile_t *pf, variable_def_t def)
{
  assert(variable_def_sz_get(def));
  return pfile_proc_value_temp_get_from_def(pf->proc_active, pf, def);
}


/*
 * NAME
 *   pfile_line
 *
 * DESCRIPTION
 *   return the current line #
 *
 * PARAMETERS
 *   pf : returned by pfile_open()
 *
 * RETURN
 *   current line #
 *
 * NOTES
 */
unsigned pfile_line_get(const pfile_t *pf)
{
  return pfile_source_line_get(pf->src);
}

/*
 * NAME
 *   pfile_log
 *
 * DESCRIPTION
 *   log a message
 *
 * PARAMETERS
 *   pf   : returned by pfile_open()
 *   plog : log level
 *   fmt  : log format
 *   ...
 *
 * RETURN
 *   none
 *
 * NOTES
 */
void pfile_log(pfile_t *pf, pfile_log_t plog, const char *fmt, ...)
{
  if ((PFILE_LOG_NONE != plog) 
    && !pfile_codegen_disable_get(pf)) {
    va_list     lst;
    FILE       *dst;
    const char *sev_str;

    if (PFILE_LOG_ERR == plog) {
      pf->errct++;
    } else if (PFILE_LOG_WARN == plog) {
      pf->warnct++;
    }

    dst = (pf->f_log) ? pf->f_log : stdout;

    sev_str = "???";
    switch (plog) {
      case PFILE_LOG_CRIT: 
        sev_str = "critical: "; 
        break;
      case PFILE_LOG_ERR:  
        sev_str = pfile_line_get(pf) ? "" : "error: "; 
        break;
      case PFILE_LOG_WARN: 
        sev_str = "warning: "; 
        break;
      case PFILE_LOG_NONE: 
        sev_str = ""; 
        break;
      case PFILE_LOG_INFO: 
        sev_str = (pfile_flag_test(pf, PFILE_FLAG_MISC_QUIET)) ? 0 : ""; 
        break;
      case PFILE_LOG_DEBUG: 
        sev_str = (pfile_flag_test(pf, PFILE_FLAG_DEBUG_COMPILER)) ? "" : 0; 
        break;
    }
    if (sev_str) {
      if ((pf->statement_start.line
            && ((PFILE_LOG_ERR == plog) 
              || (PFILE_LOG_WARN == plog)
        || (PFILE_LOG_CRIT == plog)))) {
        fprintf(dst, "%s:%u: ", pfile_source_name_get(pf->statement_start.src),
            pf->statement_start.line);
      }
      fprintf(dst, "%s", sev_str);
      va_start(lst, fmt);
      vfprintf(dst, fmt, lst);
      va_end(lst);
      fputc('\n', dst);
      fflush(dst);
    }
  }
}

/*
 * NAME
 *   pfile_log_syserr
 *
 * DESCRIPTION
 *   log a system error
 *
 * PARAMETERS
 *   pf : pfile
 *   rc : result
 *
 * RETURN
 *   none
 *
 * NOTES
 *   used mostly for ``out of memory'' and such
 */
void pfile_log_syserr(pfile_t *pf, result_t rc)
{
  if (RESULT_OK != rc) {
    const char *str;

    str = "{??unknown??}";
    switch (rc) {
      case RESULT_OK:             str = " no error";       break;
      case RESULT_MEMORY:         str = " out of memory";  break;
      case RESULT_SYNTAX:         str = " syntax error";   break;
      case RESULT_NOT_FOUND :     str = " not found";      break;
      case RESULT_DIVIDE_BY_ZERO: str = " divide by zero"; break;
      case RESULT_EXISTS:         str = " exists";         break;
      case RESULT_RANGE:          str = " out of range";   break;
      case RESULT_INTERNAL:       str = " internal error"; break;
      case RESULT_INVALID:        str = " invalid";        break;
    }
    pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_INTERNAL_ERROR, str);
  }
}

/*
 * NAME
 *   pfile_variable_find
 *
 * DESCRIPTION
 *   find an existing variable
 *
 * PARAMETERS
 *   pf   : returned by pfile_open()
 *   log  : how to log result
 *   name : name to find
 *   dst  : holds result on success
 *
 * RETURN
 *   0      : no error
 *   ENOENT : not found
 *
 * NOTES
 */
variable_t pfile_variable_find(pfile_t *pf, pfile_log_t plog,
  const char *name, pfile_block_t **blk)
{
  variable_t    var;
  pfile_proc_t *proc;

  for (var = 0, proc = pf->proc_active;
       proc && !var;
       proc = pfile_proc_parent_get(proc)) {
    var = pfile_proc_variable_find(proc, name, blk);
  }
  if (!var) {
    pfile_log(pf, plog, PFILE_MSG_NOT_FOUND, name);
  }
  return var;
}

/*
 * NAME
 *   pfile_value_find
 *
 * DESCRIPTION
 *   find an existing variable & wrap it in a value
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 */
value_t pfile_value_find(pfile_t *pf, pfile_log_t plog,
  const char *name)
{
  variable_t var;
  value_t    val;

  val = 0;
  var = pfile_variable_find(pf, plog, name, 0);
  if (var) {
    val = value_alloc(var);
    if (!val) {
      pfile_log_syserr(pf, ENOMEM);
    }
    variable_release(var);
  }
  return val;
}

/*
 * NAME
 *   pfile_variable_alloc
 *
 * DESCRIPTION
 *   allocate a variable
 *
 * PARAMETERS
 *   pf : returned by pfile_open()
 *   name : variable name (0 for unnamed)
 *   flags :
 *   sz    :
 *   ct    : array size, must be >= 1
 *   cbuf  : constant buffer
 *   dst   : [out] holds result on success
 *
 * RETURN
 *
 * NOTES
 */
result_t pfile_variable_alloc(pfile_t *pf, pfile_variable_alloc_t which,
    const char *name, variable_def_t def, variable_t master, variable_t *dst)
{
  result_t   rc;
  variable_t var;

  rc = pfile_proc_variable_alloc(
    (PFILE_VARIABLE_ALLOC_GLOBAL == which) 
      ? pf->proc_root : pf->proc_active, 
    which, (name) ? pfile_tag_alloc(pf, name) : TAG_NONE, def, master, pf, 
    &var);
  if (RESULT_OK != rc) {
    if (RESULT_EXISTS == rc) {
      pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_MULTI_DEF, name);
    } else {
      pfile_log_syserr(pf, rc);
    }
  } else {
    if (dst) {
      *dst = var;
    } else {
      variable_release(var);
    }
  }
  return rc;
}


label_t pfile_label_alloc(pfile_t *pf, const char *label)
{
  char    name[32];
  label_t lbl;

  if (label) {
    result_t rc;
    tag_t    tag;

    lbl = LABEL_NONE;
    tag = pfile_tag_alloc(pf, label);
    rc = pfile_proc_label_alloc(pf->proc_active, tag, &lbl);
    if (RESULT_EXISTS == rc) {
      pfile_log(pf, PFILE_LOG_ERR, "label exists");
      tag_release(tag);
    } else if (!lbl) {
      pfile_log_syserr(pf, ENOMEM);
      tag_release(tag);
    }
  } else {
    if (pf->label_temp_ptr) {
      lbl = pf->label_temp_ptr;
      pf->label_temp_ptr = label_next_get(pf->label_temp_ptr);
      label_lock(lbl);
    } else {
      sprintf(name, "_l%u", ++pf->label_temp_ct);
      lbl = label_alloc(pfile_tag_alloc(pf, name));
      if (!lbl) {
        pfile_log_syserr(pf, ENOMEM);
      } else {
        label_list_append(&pf->label_temp, lbl);
      }
    }
  }
  return lbl;
}

label_t pfile_label_temp_head_get(pfile_t *pf)
{
  return label_list_head(&pf->label_temp);
}

/*
 * NAME
 *   pfile_label_find
 *
 * DESCRIPTION
 *   find an existing label
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 */
label_t pfile_label_find(pfile_t *pf, pfile_log_t plog, const char *name)
{
  label_t       lbl;
  pfile_proc_t *proc;

  for (proc = pf->proc_active, lbl = LABEL_NONE;
       proc && !lbl;
       proc = pfile_proc_parent_get(proc)) {
    lbl = pfile_proc_label_find(proc, name);
  }
  if (!lbl) {
    pfile_log(pf, plog, PFILE_MSG_NOT_FOUND, name);
  }
  return lbl;
}

/*
 * NAME
 *   pfile_label_remove_unused
 *
 * DESCRIPTION
 *   remove unused labels
 *
 * PARAMETERS
 *   lst  : label list
 *   name : list name (for reporting)
 *
 * RETURN
 *   none
 *
 * NOTES
 */
#if 0
static void pfile_label_remove_unused(pfile_t *pf, lbllist_t *lst, 
    const char *name)
{
  label_t  lbl;
  unsigned ct;

  UNUSED(pf);
  UNUSED(name);

  lbl = label_list_head(lst);
  ct  = 0;
  while (lbl) {
    label_t lbl_next;

    lbl_next = label_next_get(lbl);
    if (!label_usage_get(lbl)) {
      label_remove(lst, lbl);
      label_release(lbl);
      ct++;
    }
    lbl = lbl_next;
  }
}
#endif

/*
 * NAME
 *   pfile_mem_minimize
 *
 * DESCRIPTION
 *   minimize the amount of used memory
 *
 * PARAMETERS
 *   pf : pfile
 *
 * RETURN
 *   none
 *
 * NOTES
 *   this release all unused temporaries, isr temporaries,
 *   labels, and cmds before calling pic_cmd_alloc() for
 *   the times when memory is at a premium.
 */

static void pfile_mem_minimize(pfile_t *pf)
{
  UNUSED(pf);
  /*pfile_label_remove_unused(pf, &pf->label_user, "user");*/
  /*pfile_label_remove_unused(pf, &pf->label_temp, "temporary");*/
}

/* this runs through the file and fixes up temporary variable offsets
 * a temporary value is fully defined by the (var/offset). since
 * offset.var is unique the constant value can be changed with no
 * ill effects.
 */ 
boolean_t value_is_temp(const value_t val)
{
  const char *ptr;

  ptr = value_name_get(val);
  return ptr 
    && (!memcmp(ptr, PFILE_TMP_VARNAME, sizeof(PFILE_TMP_VARNAME) - 1) 
        || !memcmp(ptr, PFILE_BTMP_VARNAME, sizeof(PFILE_BTMP_VARNAME) - 1));
}

#if 0
static void pfile_temp_op_fixup(cmd_t cmd, value_t val, unsigned *tmppos)
{
  assert(value_flag_test(val, VARIABLE_FLAG_TEMPSET));
  for (cmd = cmd_link_get(cmd);
       cmd && (CMD_TYPE_STATEMENT_END != cmd_type_get(cmd));
       cmd = cmd_link_get(cmd)) {
    if ((CMD_TYPE_OPERATOR == cmd_type_get(cmd))
      && ((cmd_opval1_get(cmd) == val)
          || (cmd_opval2_get(cmd) == val))) {
      break;
    }
  }
  if (!cmd || (CMD_TYPE_STATEMENT_END == cmd_type_get(cmd))) {
    /* this temp is no longer used so go ahead & get rid of it */
    if (value_const_get(value_baseofs_get(val)) == *tmppos) {
      printf("reducing tmppos\n");
      *tmppos -= value_sz_get(val);
    }
  }
}
#endif

void pfile_temp_fixup(pfile_t *pf)
{
  cmd_t         cmd;
  variable_sz_t tmppos;    /* current hi position */

  tmppos = 0;
  for (cmd = pf->cmd_head; cmd; cmd = cmd_link_get(cmd)) {
    if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
      const value_t *brproc_params;

      brproc_params = cmd_brproc_params_get(cmd);

      if (brproc_params) {
        size_t ii;
        size_t ct;

        ct = cmd_brproc_param_ct_get(cmd);
        for (ii = 0; ii < ct; ii++) {
          value_t    dst;
          variable_t dst_var;

          dst = brproc_params[ii];
          if ((!ii || value_dflag_test(dst, VARIABLE_DEF_FLAG_OUT))
            && value_is_temp(dst) 
            && !value_flag_test(dst, VALUE_FLAG_TEMPSET)
            && !value_is_boolean(dst)) {
            value_flag_set(dst, VALUE_FLAG_TEMPSET);
            value_const_set(value_baseofs_get(dst), tmppos);
            tmppos += value_sz_get(dst);
            dst_var = value_variable_get(dst);
            if (variable_sz_get(dst_var) < tmppos) {
              variable_def_t def;

              def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER, 
                  VARIABLE_DEF_FLAG_NONE, tmppos);
              variable_def_set(dst_var, def);
            }
          }
        }
      }
    } else if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
      value_t dst;

      dst = cmd_opdst_get(cmd);

      if (value_is_temp(dst)
        && !value_is_boolean(dst)  
        && !value_flag_test(dst, VALUE_FLAG_TEMPSET)) {
        /* we only need to adjust the offset when the temp
         * is used as a destination */
        variable_t dst_var;

        value_flag_set(dst, VALUE_FLAG_TEMPSET);
        value_const_set(value_baseofs_get(dst), tmppos);
        tmppos += value_sz_get(dst);
        dst_var = value_variable_get(dst);
        if (variable_sz_get(dst_var) < tmppos) {
          variable_def_t def;

          def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER, 
              VARIABLE_DEF_FLAG_NONE, tmppos);
          variable_def_set(dst_var, def);
        }
      }
#if 0
      if (value_is_temp(val1)) {
        /* make sure this has been set. if it's no longer used, remove it */
        pfile_temp_op_fixup(cmd, val1, &tmppos);
      }
      if (value_is_temp(val2)) {
        /* make sure this has been set */
        pfile_temp_op_fixup(cmd, val2, &tmppos);
      }
#endif
    } else if (CMD_TYPE_STATEMENT_END == cmd_type_get(cmd)) {
      tmppos    = 0;
    }
  }
}


/*
 * NAME
 *   pfile_cexpr_reduction
 *
 * DESCRIPTION
 *   constant expression reduction
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   none
 *
 * NOTES
 *   This replaces constant expressions with a simple assignment.
 *   If the assignment is to a temporary, all references to the
 *   temporary are replaced by the expression.
 *
 *   nb: *don't* check for value_is_const, instead check for
 *       the value never being assigned!
 */
static void pfile_cexpr_reduction_val2(value_t *pval, value_t dst, 
    value_t cval)
{
  if (value_baseofs_get(*pval) == dst) {
    value_baseofs_set(*pval, cval);
  } else if (*pval == dst) {
    *pval = cval;
  }
}

static void pfile_cexpr_reduction_val(cmd_t cmd, 
    value_t (*val_get)(const cmd_t cmd), 
    void (*val_set)(cmd_t cmd, value_t val), value_t dst, value_t cval)
{
  value_t val;

  val = val_get(cmd);
  pfile_cexpr_reduction_val2(&val, dst, cval);
  val_set(cmd, val);
}

void pfile_cexpr_reduction(pfile_t *pf)
{
  if (pfile_flag_test(pf, PFILE_FLAG_OPT_CEXPR_REDUCTION)) {
    cmd_t    cmd;
    cmd_t    cmd_pv;
    unsigned ct;

    ct     = 0;
    cmd_pv = CMD_NONE;
    cmd    = pf->cmd_head;
    while (cmd) {
      if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
        value_t dst;
        value_t val1;
        value_t val2;

        dst  = cmd_opdst_get(cmd);
        val1 = cmd_opval1_get(cmd);
        val2 = cmd_opval2_get(cmd);

        if (value_is_pseudo_const(val1) && value_is_pseudo_const(val2)) {
          value_t cval;

          if (OPERATOR_ASSIGN == cmd_optype_get(cmd)) {
            cval = val1;
            value_lock(cval);
          } else {
            pf_const_t c;

            c = pfile_op_const_exec(pf, cmd_optype_get(cmd), val1, val2);
            cval = pf_const_to_const(pf, c, value_def_get(dst));
          }
          if (1) { /* !value_is_temp(dst)) { */
            cmd_optype_set(cmd, OPERATOR_ASSIGN);
            cmd_opval1_set(cmd, cval);
            cmd_opval2_set(cmd, VALUE_NONE);
          } else {
            cmd_t cmd_ptr;

            cmd_ptr = cmd;
            do {
              cmd_ptr = cmd_link_get(cmd_ptr);
              if (CMD_TYPE_OPERATOR == cmd_type_get(cmd_ptr)) {
                pfile_cexpr_reduction_val(cmd_ptr, cmd_opval1_get, 
                    cmd_opval1_set, dst, cval);
                pfile_cexpr_reduction_val(cmd_ptr, cmd_opval2_get, 
                    cmd_opval2_set, dst, cval);
              } else if (CMD_TYPE_BRANCH == cmd_type_get(cmd_ptr)) {
                size_t   param_ct;
                value_t *params;

                pfile_cexpr_reduction_val(cmd_ptr, cmd_brval_get,
                    cmd_brval_set, dst, cval);
                param_ct = cmd_brproc_param_ct_get(cmd_ptr);
                params   = cmd_brproc_params_get(cmd_ptr);
                while (param_ct--) {
                  pfile_cexpr_reduction_val2(params + param_ct,
                      dst, cval);
                }
              } else if (CMD_TYPE_ASM == cmd_type_get(cmd_ptr)) {
                pfile_cexpr_reduction_val(cmd_ptr, cmd_asm_val_get, 
                    cmd_asm_val_set, dst, cval);
              }
            } while ((CMD_TYPE_STATEMENT_END != cmd_type_get(cmd_ptr))
              && (dst != cmd_opdst_get(cmd_ptr)));
            if (cmd_pv) {
              cmd_link_set(cmd_pv, cmd_link_get(cmd));
            } else {
              pf->cmd_head = cmd_link_get(cmd);
            }
            cmd_free(cmd);
            ct++;
            cmd = cmd_pv;
          }
          value_release(cval);
        }
      }
      cmd_pv = cmd;
      cmd = cmd_link_get(cmd_pv);
    }
    pfile_log(pf, PFILE_LOG_DEBUG, 
        "%u commands removed by constant expression reduction", ct);
  }
}

/*
 * NAME
 *   pfile_expr_reduction
 *
 * DESCRIPTION
 *   cleans up trivial expressions
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   none
 *
 * NOTES
 *   this fixes up any operators and removes redundant
 *   assignments (x = x)
 */
void pfile_expr_reduction(pfile_t *pf)
{
  if (pfile_flag_test(pf, PFILE_FLAG_OPT_EXPR_REDUCTION)) {
    cmd_t    cmd;
    cmd_t    cmd_pv;
    value_t  value_zero;
    value_t  value_one;
    unsigned ct;

    cmd_pv = CMD_NONE;
    cmd    = pf->cmd_head;
    ct     = 0;

    value_zero = pfile_constant_get(pf, 0, VARIABLE_DEF_NONE);
    value_one  = pfile_constant_get(pf, 1, VARIABLE_DEF_NONE);
    while (cmd) {
      if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
        (void) cmd_op_reduction(cmd, value_zero, value_one);
        if ((OPERATOR_ASSIGN == cmd_optype_get(cmd))
            && (value_is_same(cmd_opdst_get(cmd), cmd_opval1_get(cmd)))) {
          if (cmd_pv) {
            cmd_link_set(cmd_pv, cmd_link_get(cmd));
          } else {
            pf->cmd_head = cmd_link_get(cmd);
          }
          ct++;
          cmd_free(cmd);
          cmd = cmd_pv;
        }
      }
      cmd_pv = cmd;
      cmd    = cmd_link_get(cmd_pv);
    }
    value_release(value_zero);
    value_release(value_one);
    pfile_log(pf, PFILE_LOG_DEBUG, 
        "%u commands removed by expression reduction", ct);
  }
}

/*
 * create expression trees & simplify expressions
 * at this point, all expressions are in 3-part form:
 *      dst = val1 op val2
 * this makes it difficult to determine if any optimizations are possible
 * for example, x = x + 1 + 2 + 3 comes out as:
 *      t0 = x + 1
 *      t1 = t0 + 2
 *      t2 = t1 + 3
 *      x  = t2
 * whereas it could be simplified to:
 *      x  = x + 6
 * to simplify, expressions are turned into n-way trees. Above would be
 * represented as:
 *        =
 *       / \
 *      x   \  
 *             +   +   +   +
 *           x   1   2   3
 *
 * This will also help with sub-expression elimination.
 * Note: some arithmetic identities can be used here, while others
 *       cannot. For example:
 *         y = x - 10 + 10
 *       is the same as:
 *         y = x
 *       whereas:
 *         y = x / 10 * 10
 *       if *not* the same as
 *         y = x
 *       as in integer arithmetic, the former has the effect of zeroing
 *       the least significant digit!
 * It will also be important to look for other identities such as:
 *   y = x + x + x
 * is the same as:
 *   y = 3 * x
 * or
 *   y = 2 * x + x
 * depending on how I chose to do it!
 */

/*
 * determine if two nodes are identical
 */
static boolean_t pfile_expr_node_equal(pfile_t *pf,
  expr_node_t node1, expr_node_t node2)
{
  boolean_t             rc;
  expr_node_op_array_t *children1;
  expr_node_op_array_t *children2;

  UNUSED(pf);
  rc = BOOLEAN_FALSE;

  children1 = expr_node_children_get(node1);
  children2 = expr_node_children_get(node2);
  if (children1 && children2) {
    /* compare the children. note order is not important here! */
    size_t ct1;
    size_t ct2;

    ct1 = expr_node_op_array_entry_ct(children1);
    ct2 = expr_node_op_array_entry_ct(children2);
    if (ct1 == ct2) {
      unsigned long ix_seen; /* make sure the same index isn't used twice */
      size_t        ii;

      ix_seen = 0;

      rc = BOOLEAN_TRUE;
      for (ii = 0; rc && (ii < ct1); ii++) {
        expr_node_op_t entry1;
        size_t         jj;

        entry1 = *expr_node_op_array_entry_get(children1, ii);
        rc = BOOLEAN_FALSE;
        for (jj = 0; !rc && (jj < ct2); jj++) {
          if (!(ix_seen & (1UL << jj))) {
            expr_node_op_t entry2;

            entry2 = *expr_node_op_array_entry_get(children2, jj);
            if ((expr_node_op_op_get(entry1) == expr_node_op_op_get(entry2))
              && (pfile_expr_node_equal(pf, 
                expr_node_op_node_get(entry1), 
                  expr_node_op_node_get(entry2)))) {
              ix_seen |= (1UL << jj);
              rc = BOOLEAN_TRUE;
            }
          }
        }
      }
    }
  } else if (!children1
    && !children2
    && (!value_is_temp(expr_node_value_get(node1)) 
      && !value_is_temp(expr_node_value_get(node2)) 
      && value_is_same(expr_node_value_get(node1),
        expr_node_value_get(node2)))) {
    rc = BOOLEAN_TRUE;
  }
  return rc;
}

/*
 * find a similar node in the existing list
 */
static expr_node_t pfile_expr_node_find(pfile_t *pf,
  expr_node_array_t *nodes, expr_node_t node)
{
  size_t      ct;
  size_t      ii;
  expr_node_t entry;

  UNUSED(pf);
  ct = expr_node_array_entry_ct(nodes);
  for (ii = 0; ii < ct; ii++) {
    entry = *expr_node_array_entry_get(nodes, ii);
    if (pfile_expr_node_equal(pf, entry, node)) {
      break;
    }
  }
  return (ii < ct) ? entry : EXPR_NODE_NONE;
}

/*
 * given a value, create a new node or return an existing one
 */
static expr_node_t pfile_expr_node_from_value(pfile_t *pf,
  expr_node_array_t *node_array, value_t val)
{
  expr_node_t node;

  UNUSED(pf);

  node = EXPR_NODE_NONE;
  if (val) {
    size_t ii;

    for (ii = 0; ii < expr_node_array_entry_ct(node_array); ii++) {
      value_t nval;

      node = *expr_node_array_entry_get(node_array, ii);
      nval = expr_node_value_get(node);
      if ((nval == val) 
          || (!value_is_temp(nval) 
            && !value_is_temp(val) 
            && value_is_same(nval, val))) {
        break;
      }
    }
    if (ii == expr_node_array_entry_ct(node_array)) {
      /* create a new one */
      node = expr_node_alloc(val);
      (void) expr_node_array_entry_append(node_array, &node);
    }
    expr_node_lock(node);
  }
  return node;
}

#define PFILE_EXPR_NODE_DUMP_FLAG_NONE  0x0000
#define PFILE_EXPR_NODE_DUMP_FLAG_FIRST 0x0001
#define PFILE_EXPR_NODE_DUMP_FLAG_LAST  0x0002
static void pfile_expr_node_dump(pfile_t *pf, const expr_node_t node, 
  operator_t op, unsigned indent, unsigned flags)
{
  value_t               val;
  expr_node_op_array_t *children;
  size_t                ct;

  children = expr_node_children_get(node);
  ct       = expr_node_op_array_entry_ct(children);

  if (indent) {
    unsigned ii;

    ii = indent;
    fputc('|', stdout);
    while (ii > 2) {
      fputs((flags && (ii <= 4))
        ? "  +" : "  |", stdout);
      ii -= 2;
    }
    while (ii--) {
      fputc((!ii && ct) ? '-' : '-', stdout);
    }
  }
  printf((OPERATOR_NULL == op) ? "     " : " (%s) ", operator_to_str(op));
  printf("%s{NODE(%u:%u)}", 
    (expr_node_flag_test(node, EXPR_NODE_FLAG_GENERATED)) ? "*" : "",
    expr_node_id_get(node), 
    expr_node_refct_get(node));
  val = expr_node_value_get(node);
  if (value_is_const(val)) {
    const char *fmt;

    fmt = (value_is_signed(val)) ? "%ld" : "%lu";
    printf(fmt, value_const_get(val));
  } else if (value_is_temp(val)) {
    printf("{T:%u}", value_id_get(val));
  } else {
    printf("{%s:%u}", value_name_get(val), value_id_get(val));
  }
  fputc('\n', stdout);
  if (ct) {
    size_t         ii;
    expr_node_op_t cnode;

    for (ii = 0; ii < ct; ii++) {
      unsigned cflags;

      cflags = PFILE_EXPR_NODE_DUMP_FLAG_NONE;
      if (0 == ii) {
        cflags |= PFILE_EXPR_NODE_DUMP_FLAG_FIRST;
      }
      if ((ii + 1) == ct) {
        cflags |= PFILE_EXPR_NODE_DUMP_FLAG_LAST;
      }
      cnode = *expr_node_op_array_entry_get(children, ii);

      pfile_expr_node_dump(pf, expr_node_op_node_get(cnode),
        expr_node_op_op_get(cnode), indent + 2, cflags);
    }
  }
}

static void pfile_expr_node_array_dump(pfile_t *pf, 
  const expr_node_array_t *nodes) 
{
  size_t ii;
  size_t ct;

  ct = expr_node_array_entry_ct(nodes);

  for (ii = 0; ii < ct; ii++) {
    expr_node_t node;

    node = *expr_node_array_entry_get(nodes, ii);
    pfile_expr_node_dump(pf, node, OPERATOR_NULL, 0, 
      PFILE_EXPR_NODE_DUMP_FLAG_NONE);
    fputc('\n', stdout);
  }
}

/*
 * replace the existing expression with an optimized one
 * cmd_prev  : the command immediately preceeding the expression
 * cmd_reset : the command immediately after the expression
 * nodes     : the node array (duh!)
 *
 * this will free everthing between {cmd_prev, cmd_reset} and replace
 * with the results of tree creation.
 * for the moment, the last entry in the node array will be the
 * correct entry to use. In the more general case, it will probably
 * be necessary to expand any node whose value is not a temporary.
 */
static void pfile_expr_generate_cmd(pfile_t *pf,
  cmd_t *cmd_prev, cmd_t cmd_reset, cmd_t cmd,
  operator_t op, value_t dst, value_t val1, value_t val2)
{
  cmd_t tcmd;

  UNUSED(pf);

  tcmd  = cmd_op_alloc(op, dst, val1, val2);
  cmd_link_set(*cmd_prev, tcmd);
  *cmd_prev = tcmd;
  cmd_link_set(tcmd, cmd_reset);
  cmd_line_set(tcmd, cmd_line_get(cmd));
  cmd_source_set(tcmd, cmd_source_get(cmd));
}

static value_t pfile_expr_generate(pfile_t *pf,
  cmd_t *cmd_prev, cmd_t cmd_reset, cmd_t cmd,
  const expr_node_t node, value_t dst);

static value_t pfile_expr_node_value_get(pfile_t *pf,
  cmd_t *cmd_prev, cmd_t cmd_reset, cmd_t cmd,
  expr_node_t node, value_t dst)
{
  if (!expr_node_flag_test(node, EXPR_NODE_FLAG_GENERATED)
    && value_is_temp(expr_node_value_get(node))) {
    value_t tdst;

    tdst = expr_node_value_get(node);
    if (value_variable_get(tdst)
      && (!dst 
        || !value_is_temp(tdst)
        || !variable_def_is_same(value_def_get(dst), value_def_get(tdst)))) {
      dst = tdst;
    }
    dst = pfile_expr_generate(pf, cmd_prev, cmd_reset, cmd, node, dst);
  } else {
    dst = expr_node_value_get(node);
  }
  return dst;
}

/*
 * When done, cmd_prev is changed to the last generated instruction
 * (whose link must be to cmd_reset)
 */ 
static value_t pfile_expr_generate(pfile_t *pf,
  cmd_t *cmd_prev, cmd_t cmd_reset, cmd_t cmd,
  const expr_node_t node, value_t dst)
{
  const expr_node_op_array_t *children;

  children = expr_node_children_get(node);
  if (!dst || !children) {
    dst = expr_node_value_get(node);
    if (!value_variable_get(dst)) {
      dst = VALUE_NONE;
    }
  }
  if (children) {
    expr_node_op_t cnode;
    size_t         ii;
    size_t         ct;
    value_t        val1;

    ct = expr_node_op_array_entry_ct(children);

    cnode = *expr_node_op_array_entry_get(children, 0);
    val1 = pfile_expr_node_value_get(pf, cmd_prev, cmd_reset,
      cmd, expr_node_op_node_get(cnode), dst);

    if (1 == ct) {
      pfile_expr_generate_cmd(pf, cmd_prev, cmd_reset, cmd,
         expr_node_op_op_get(cnode),
         dst,
         val1,
         VALUE_NONE);
    } else {
      value_t val2;

      val2 = VALUE_NONE;
      for (ii = 1; ii < ct; ii++) {

        cnode = *expr_node_op_array_entry_get(children, ii);
        val2 = pfile_expr_node_value_get(pf, cmd_prev, cmd_reset,
                 cmd, expr_node_op_node_get(cnode), val2);
        pfile_expr_generate_cmd(pf, cmd_prev, cmd_reset, cmd,
           expr_node_op_op_get(cnode),
           dst,
           val1,
           val2);
        val1 = dst;
      }
    }
    expr_node_flag_set(node, EXPR_NODE_FLAG_GENERATED);
  }
  return dst;
}

static void pfile_expr_replace(pfile_t *pf,
  cmd_t cmd_prev, cmd_t cmd_reset, const expr_node_array_t *nodes)
{
  size_t ct;
  size_t ii;
  cmd_t  cmd;

  ct  = expr_node_array_entry_ct(nodes);
  cmd = CMD_NONE;

  /* first, free all commands between cmd_prev & cmd_reset as
   * they're no longer needed */
  while (cmd_link_get(cmd_prev) != cmd_reset) {
    cmd_t tmp;

    tmp = cmd_link_get(cmd_prev);
#if 0
    cmd_dump(tmp, stdout);
#endif
    cmd_link_set(cmd_prev, cmd_link_get(tmp));
    if (!cmd) {
      cmd = tmp;
    } else {
      cmd_free(tmp);
    }
  }
  fflush(stdout);
  /*
   * generate all terminal nodes. terminal nodes have a reference
   * count of 1 (everything else is an internal node and will
   * be generated when the corresponding terminal node is generated)
   */
  for (ii = 0; ii < ct; ii++) {
    expr_node_t node;

    node = *expr_node_array_entry_get(nodes, ii);
    if ((expr_node_refct_get(node) == 1) 
      && !expr_node_flag_test(node, EXPR_NODE_FLAG_GENERATED)) {
      (void) pfile_expr_generate(pf, &cmd_prev, cmd_reset, 
        cmd, node, VALUE_NONE);
    }
  }
  cmd_free(cmd);
}

static void pfile_expr_node_array_reset(pfile_t *pf,
  expr_node_array_t *nodes)
{
  size_t ii;
  size_t ct;

  UNUSED(pf);
  ct = expr_node_array_entry_ct(nodes);

  for (ii = 0; ii < ct; ii++) {
    expr_node_t node;

    node = *expr_node_array_entry_get(nodes, ii);
    expr_node_release(node);
  }
  expr_node_array_entry_remove_all(nodes);
  expr_node_id_reset();
}


/*
 * this does a few different things depending on the operator:
 *    +, - : combine constants
 *           look for identities ( x + y - x --> y )
 *           group variables     ( x + y + x --> x + x + y)
 *                               (allows for x << 1 + y optimization)
 *    *    : combine constants throughout expression
 *    /    : combine consequetive constants (x / 2 / 3 --> x / 6)
 *    %    : none
 *    relationals : none
 *    logicals    : none
 *    &, | : combine constants
 *    ^    : none
 *    shift: combine consequetive constants
 */
#define PFILE_EXPR_NODE_FIXUP_FLAG_NONE                  0x0000U
#define PFILE_EXPR_NODE_FIXUP_FLAG_CONSTANTS_COMBINE     0x0001U
#define PFILE_EXPR_NODE_FIXUP_FLAG_CONSTANTS_COMBINE_CONSECUTIVE 0x0002U
#define PFILE_EXPR_NODE_FIXUP_FLAG_GROUP                 0x0004U
#define PFILE_EXPR_NODE_FIXUP_FLAG_IDENTITIES            0x0008U
static void pfile_expr_node_fixup(pfile_t *pf, expr_node_t node)
{
  expr_node_op_array_t *children;
  size_t                child_ct;

  children = expr_node_children_get(node);
  child_ct = expr_node_op_array_entry_ct(children);

  /* pointless to continue if we haven't at least two children */
  if (child_ct > 1) {
    expr_node_op_t child;
    operator_t     op;
    unsigned       fixup;

    child = *expr_node_op_array_entry_get(children, 0);
    op    = expr_node_op_op_get(child);
    fixup = PFILE_EXPR_NODE_FIXUP_FLAG_NONE;

    switch (op) {
    case OPERATOR_NULL:
    case OPERATOR_MOD:
    case OPERATOR_LT:
    case OPERATOR_LE:
    case OPERATOR_EQ:
    case OPERATOR_NE:
    case OPERATOR_GE:
    case OPERATOR_GT:
    case OPERATOR_ANDL:
    case OPERATOR_ORL:
    case OPERATOR_NOTL:
    case OPERATOR_XORB:
    case OPERATOR_CMPB:
    case OPERATOR_ASSIGN:
    case OPERATOR_NEG:
    case OPERATOR_INCR:
    case OPERATOR_DECR:
    case OPERATOR_LOGICAL:
    case OPERATOR_REFERENCE:
    case OPERATOR_DOT:
    case OPERATOR_CAST:
    case OPERATOR_SUBSCRIPT:
    case OPERATOR_CT:
      break;
    case OPERATOR_ADD:
    case OPERATOR_SUB: 
      fixup = PFILE_EXPR_NODE_FIXUP_FLAG_GROUP 
         | PFILE_EXPR_NODE_FIXUP_FLAG_CONSTANTS_COMBINE; 
      break;
    case OPERATOR_MUL: 
      fixup = PFILE_EXPR_NODE_FIXUP_FLAG_GROUP
         | PFILE_EXPR_NODE_FIXUP_FLAG_CONSTANTS_COMBINE; 
      break;
    case OPERATOR_DIV: 
      fixup = PFILE_EXPR_NODE_FIXUP_FLAG_CONSTANTS_COMBINE_CONSECUTIVE; 
      break;
    case OPERATOR_ANDB: 
      fixup = PFILE_EXPR_NODE_FIXUP_FLAG_GROUP
         | PFILE_EXPR_NODE_FIXUP_FLAG_CONSTANTS_COMBINE; 
      break;
    case OPERATOR_ORB:  
      fixup = PFILE_EXPR_NODE_FIXUP_FLAG_GROUP
         | PFILE_EXPR_NODE_FIXUP_FLAG_CONSTANTS_COMBINE; 
      break;
    case OPERATOR_SHIFT_LEFT: 
    case OPERATOR_SHIFT_RIGHT:
    case OPERATOR_SHIFT_RIGHT_ARITHMETIC:
      fixup = PFILE_EXPR_NODE_FIXUP_FLAG_CONSTANTS_COMBINE_CONSECUTIVE; 
      break;
    }
    if (fixup & (PFILE_EXPR_NODE_FIXUP_FLAG_CONSTANTS_COMBINE
        | PFILE_EXPR_NODE_FIXUP_FLAG_CONSTANTS_COMBINE_CONSECUTIVE)) {
      size_t ii;

      for (ii = 0; ii < child_ct - 1; ) {
        expr_node_op_t c1;
        expr_node_t    c1n;
        value_t        c1nv;

        c1    = *expr_node_op_array_entry_get(children, ii);
        c1n   = expr_node_op_node_get(c1);
        c1nv  = expr_node_value_get(c1n);
        if (value_is_const(c1nv)) {
          size_t           jj;
          variable_const_t accum;
          operator_t       c1_op;

          accum = value_const_get(expr_node_value_get(c1n));
          c1_op = expr_node_op_op_get(c1);

          for (jj = ii + 1; jj < child_ct; ) {
            expr_node_op_t c2;
            expr_node_t    c2n;
            value_t        c2nv;

            c2 = *expr_node_op_array_entry_get(children, jj);
            c2n = expr_node_op_node_get(c2);
            c2nv = expr_node_value_get(c2n);
            if (value_is_const(c2nv)) {
              variable_const_t c2v;
              operator_t       c2_op;

              c2v   = value_const_get(c2nv);
              c2_op = expr_node_op_op_get(c2);

              /* combine c1 & c2
               * possibilites (based on op):
               *   +/-   ( - c1 - c2 --> - ( c1 + c2 )
               *         ( - c1 + c2 -->   ( c2 - c1 )
               *         ( + c1 - c2 -->   ( c1 - c2 )
               *         ( + c1 + c2 -->   ( c1 + c2 )
               *   *     ( * constants   )
               *   /     ( * constants   )
               *   &     ( & constants   )
               *   |     ( | constants   )
               *   shift ( add constants )
               */
              /* how to combine the constants... */
              if (OPERATOR_SUB == c1_op) {
                if (OPERATOR_SUB == c2_op) {
                  accum += c2v;
                } else {
                  accum = c2v - accum;
                  c1_op = OPERATOR_ADD;
                }
              } else if (OPERATOR_ADD == c1_op) {
                if (OPERATOR_SUB == c2_op) {
                  accum -= c2v;
                } else {
                  accum += c2v;
                }
              } else if (OPERATOR_MUL == c2_op) {
                accum *= c2v;
              } else if (OPERATOR_DIV == c2_op) {
                accum *= c2v;
              } else if (OPERATOR_ANDB == c2_op) {
                accum &= c2v;
              } else if (OPERATOR_ORB == c2_op) {
                accum |= c2v;
              } else if ((OPERATOR_SHIFT_LEFT == c2_op)
                || (OPERATOR_SHIFT_RIGHT == c2_op)
                || (OPERATOR_SHIFT_RIGHT_ARITHMETIC == c2_op)) {
                accum += c2v;
              }
              expr_node_op_array_entry_remove(children, jj);
              child_ct--;
              expr_node_op_free(c2);
            } else if (fixup
              & PFILE_EXPR_NODE_FIXUP_FLAG_CONSTANTS_COMBINE_CONSECUTIVE) {
              break; /* nothing left to do here */
            } else {
              jj++;
            }
          }
          expr_node_op_op_set(c1, c1_op);
          if (accum != value_const_get(c1nv)) {
            value_t tmp;
            expr_node_t anode;

            tmp = pfile_constant_get(pf, accum, value_def_get(c1nv));
            anode = expr_node_alloc(tmp);
            expr_node_op_node_set(c1, anode);
            expr_node_release(anode);
            value_release(tmp);
          }
          ii = jj;
        } else {
          ii++;
        }
      }
    }
    if (fixup & PFILE_EXPR_NODE_FIXUP_FLAG_GROUP) {
    }
    if (fixup & PFILE_EXPR_NODE_FIXUP_FLAG_IDENTITIES) {
    }
  }
}

/*
 * operators are compatible if one is null, both are equal,
 * or both are either add/sub 
 */
static void pfile_expr_node_child_append(pfile_t *pf,
  expr_node_t node, expr_node_t child, operator_t op)
{
  expr_node_op_array_t *children;
  boolean_t             ops_similar;

  UNUSED(pf);

  children    = expr_node_children_get(child);
  ops_similar = BOOLEAN_FALSE;
  if (children) {
    operator_t cop;

    cop = expr_node_op_op_get(*expr_node_op_array_entry_get(children, 0));
    ops_similar = (op == cop)
      || (((op == OPERATOR_ADD) | (op == OPERATOR_SUB))
        && ((cop == OPERATOR_ADD) | (cop == OPERATOR_SUB)));
  }
  if (ops_similar 
    && (variable_def_is_same(value_def_get(expr_node_value_get(node)),
      value_def_get(expr_node_value_get(child))))) {
    /* this can be flattened */
    size_t ct;
    size_t ii;

    expr_node_noderef_add(node, child);
    ct = expr_node_op_array_entry_ct(children);
    for (ii = 0; ii < ct; ii++) {
      expr_node_op_t cnode;

      cnode = *expr_node_op_array_entry_get(children, ii);
      expr_node_child_append(node, expr_node_op_node_get(cnode),
        (0 == ii) ? op : expr_node_op_op_get(cnode));
    }
  } else {
    expr_node_child_append(node, child, op);
  }
}

static void pfile_expr_simplify(pfile_t *pf)
{
  cmd_t              cmd;
  cmd_t              cmd_prev;
  expr_node_array_t *nodes;

  nodes = expr_node_array_alloc(16);
  for (cmd_prev = CMD_NONE, cmd = pf->cmd_head; 
       cmd; 
       cmd_prev = cmd, cmd = cmd_link_get(cmd)) {
    if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
      printf("%s:%u\n", 
        pfile_source_name_get(cmd_source_get(cmd)),
        cmd_line_get(cmd));
      /*
       * note:
       * Currently the sub-expression elimination is limited to a
       * single expression. This should be trivial to generalize
       * in the global case as follows:
       *       + flush nodes whenever a cmd with a label is found
       *         (since we don't really know any state at that point)
       *       * flush nodes at any call (for fear a variable changed
       *         out from under us, might be a bit excessive)
       *       * for each cmd, look at cmd_kill_get, remove any nodes
       *         that are dependent upon any killed variable
       */
      do {
        expr_node_t node_left;
        expr_node_t node_right;
        expr_node_t node;
        expr_node_t tnode;
        operator_t  op;

        op = cmd_optype_get(cmd);

        node_left  = pfile_expr_node_from_value(pf, nodes, 
                       cmd_opval1_get(cmd));
        tnode = pfile_expr_node_find(pf, nodes, node_left);
        if (tnode) {
          expr_node_lock(tnode);
          expr_node_release(node_left);
          node_left = tnode;
        }

        node_right = pfile_expr_node_from_value(pf, nodes, 
                       cmd_opval2_get(cmd));
        tnode = pfile_expr_node_find(pf, nodes, node_right);
        if (tnode) {
          expr_node_lock(tnode);
          expr_node_release(node_right);
          node_right = tnode;
        }

        node       = expr_node_alloc(cmd_opdst_get(cmd));
        (void) expr_node_array_entry_append(nodes, &node);
        /*
         * operator probably needs to be set if it's unary
         */
        pfile_expr_node_child_append(pf, node, node_left, 
          (OPERATOR_SUB == op) ? OPERATOR_ADD : op);
        if (node_right) {
          pfile_expr_node_child_append(pf, node, node_right, op);
          pfile_expr_node_fixup(pf, node);
        }
        expr_node_release(node_left);
        expr_node_release(node_right);
        cmd = cmd_link_get(cmd);
      } while (CMD_TYPE_OPERATOR == cmd_type_get(cmd));
      /* 
       * at this point, cmd is the first command not used
       * in the expression
       */
      pfile_expr_replace(pf, cmd_prev, cmd, nodes);
      pfile_expr_node_array_dump(pf, nodes);
      pfile_expr_node_array_reset(pf, nodes);
#if 0
      {
        cmd_t tcmd;

        for (tcmd = cmd_link_get(cmd_prev);
             tcmd != cmd;
             tcmd = cmd_link_get(tcmd)) {
          cmd_dump(tcmd, stdout);
        }
      }
#endif
      printf("-----\n");
      /*
       * we can safely continue *past* cmd as we know cmd
       * is not of type operator!
       */
    }
  }
  expr_node_array_free(nodes);
}

/* look for occurances of:
 *   _tmp = x
 *   y    = _tmp
 * and reduce to:
 *   y = x
 */


/* this attempts to eliminate unnecessary temporaries
   for example:
       _t0 = x & C0
       _t2 = y & C1
       _t5 = _t0 << 7
       y   = _t2 | _t5
   first, since y & _t2 are the same size and y is overwritten
   without being used again, _t2 can be eliminated leaving:
       _t0 = x & C0
       _y  = y & C1
       _t5 = _t0 << 7
       y   = y | _t5
   but, this can be further reduced! _t0 isn't used again after
   line 3 and is the same size as _t5, so this becomes:
       _t0 = x & C0
       _y  = y & C1
       _t0 = _t0 << 7
       y   = y | _t0
*/
#if 0
static boolean_t cmd_is_eos(cmd_t cmd)
{
  return !cmd
   || (CMD_TYPE_STATEMENT_END == cmd_type_get(cmd))
   || (CMD_TYPE_BLOCK_END == cmd_type_get(cmd))
   || (CMD_TYPE_PROC_LEAVE == cmd_type_get(cmd))
   || (CMD_TYPE_END == cmd_type_get(cmd));
}
#endif

static void pfile_temp_reduction(pfile_t *pf)
{
  cmd_t    cmd;
  unsigned ct = 0;

  for (cmd = pf->cmd_head; cmd; cmd = cmd_link_get(cmd)) {
    if (value_is_temp(cmd_opdst_get(cmd))) {
      /* we've _tx = blah */
      cmd_t     cptr;
      value_t   dst;

      dst  = cmd_opdst_get(cmd);

      cptr = cmd_link_get(cmd);
      if ((OPERATOR_ASSIGN == cmd_optype_get(cptr))
        && value_is_same(dst, cmd_opval1_get(cptr))
        /* the following is needed for `return expr' because the return
         * variable isn't allocated here; it's allocated by the PIC lib
         */
        && value_variable_get(cmd_opdst_get(cptr))) {
        /* this is:
             _t = ???
             v  = _t
         */
        cmd_opdst_set(cmd, cmd_opdst_get(cptr));
        cmd_link_set(cmd, cmd_link_get(cptr));
        cmd_free(cptr);
        ct++;
      } else if (pfile_flag_test(pf, PFILE_FLAG_OPT_TEMP_REDUCE)) {
        cmd_t cmd_last; /* last statement that accesses dst */

        cmd_last = CMD_NONE; /* there might not be any! */
        while (cptr && (CMD_TYPE_STATEMENT_END != cmd_type_get(cptr))) {
          flag_t val_access;

          val_access = cmd_value_accessed_get(cptr, dst);
          if (val_access & CMD_VARIABLE_ACCESS_FLAG_READ) {
            cmd_last = cptr;
          }
          cptr = cmd_link_get(cptr);
        }
        if (cmd_last != CMD_NONE) {
          /* look for an assignment to temp where the temp definition
           * matches dst, then replace all such assignments with dst
           */
          value_map_pair_t map_data;
          value_map_t      map;

          map.alloc    = 0;
          map.used     = 0;
          map.map      = &map_data;
          
          for (cptr = cmd_last;
               cptr && (CMD_TYPE_STATEMENT_END != cmd_type_get(cptr));
               cptr = cmd_link_get(cptr)) {
            value_t cdst;

            cdst = cmd_opdst_get(cptr);
            if (!(cmd_value_accessed_get(cptr, cdst) 
                & CMD_VARIABLE_ACCESS_FLAG_READ)
                && value_is_temp(cdst) 
                && variable_def_is_same(
                  value_def_get(cdst), value_def_get(dst))) {
              map_data.old = cdst;
              map_data.new = dst;
              map.used = 1;
              break;
            }
          }
          if (map.used) {
#if 0
            printf("Remapping...");
            value_dump(map_data.old, stdout);
            printf("--->");
            value_dump(map_data.new, stdout);
            printf("\n");
#endif
            while (cptr && (CMD_TYPE_STATEMENT_END != cmd_type_get(cptr))) {
              cmd_value_remap(cptr, &map);
              cptr = cmd_link_get(cptr);
            }
          }
        }
      }
    }
  }
  pfile_log(pf, PFILE_LOG_DEBUG, "Removed %u temporaries", ct);
}

static void pfile_callstack_dump_proc(pfile_t *pf, pfile_proc_t *proc,
  unsigned depth)
{
  const char *prname;
  size_t      call_ct;
  size_t      ii;

  prname = pfile_proc_tag_get(proc);
  pfile_write(pf, pfile_write_lst, "; %*s%s (depth=%u)\n",
    (int) (2 * depth),
    pfile_proc_flag_test(proc, PFILE_PROC_FLAG_VISITED) ? "*" : "",
    prname ? prname : "{root}",
    depth);
  if (!pfile_proc_flag_test(proc, PFILE_PROC_FLAG_VISITED)) {
    pfile_proc_flag_set(proc, PFILE_PROC_FLAG_VISITED);
    call_ct = pfile_proc_calls_ct_get(proc);
    for (ii = 0; ii < call_ct; ii++) {
      pfile_callstack_dump_proc(pf, pfile_proc_calls_get(proc, ii), depth + 1);
    }
    pfile_proc_flag_clr(proc, PFILE_PROC_FLAG_VISITED);
  }
}

static void pfile_callstack_dump(pfile_t *pf)
{
  pfile_proc_t *proc;
  /* first clear the visited flag from all procedures */

  pfile_write(pf, pfile_write_lst, "; --- call stack ---\n");
  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    pfile_proc_flag_clr(proc, PFILE_PROC_FLAG_VISITED);
  }
  pfile_callstack_dump_proc(pf, pfile_proc_root_get(pf), 0);
}

/*
 * given an assignment, (x = y), return TRUE if the data
 * at x(ofs...ofs+len-1) are the same as the constant y,
 * or FALSE if not (or if y is non constant)
 * entry:
 *    val   : contains the value being tested
 *    dmask : a bit mask to determine if a particular byte in
 *            val has been set
 *    data  : an array of bytes set in val
 *    src   : the source to be tested
 */
static boolean_t var_const_data_assign(value_t val,
  variable_sz_t data_sz, uchar *data_mask, uchar *data, value_t src)
{
  boolean_t rc;

  rc = value_is_const(src);
  if (rc) {
    variable_const_t n;
    variable_const_t v_ofs;
    variable_const_t v_sz;

    n     = value_const_get(src); /* a good start */
    v_ofs = value_const_get(value_baseofs_get(val));
    v_sz  = value_byte_sz_get(val);
    for ( ;
         v_sz && rc;
         v_sz--, v_ofs++) {
      uchar n_lsb;

      n_lsb = (uchar) (n & 0xff);
      n >>= 8;
      if (v_ofs < data_sz) {
        if (!(data_mask[v_ofs/8] & (1 << (v_ofs & 0x07)))) {
          /* first time being set */
          data[v_ofs] = n_lsb;
          data_mask[v_ofs/8] |= (1 << (v_ofs & 0x07));
        } else {
          rc = (data[v_ofs] == n_lsb);
        }
      }
    }
  }
  return rc;
}

/* return a new, constant value if val has become const, 
 * otherwise return VALUE_NONE */
boolean_t pfile_opt_single_constant_assign_val(pfile_t *pf, cmd_t cmd, 
  value_t val, value_t val1, unsigned pass)
{
  variable_t var;
  boolean_t  is_const;

  UNUSED(pf);
  UNUSED(pass);

  is_const = BOOLEAN_FALSE;
  var = value_variable_get(val);
  /* no need to proceed if this has already been tested */
  if (var 
      && !variable_flag_test(var, VARIABLE_FLAG_CONST_TESTED)
      && !variable_is_const(var)) {
    variable_sz_t sz;

    variable_flag_set(var, VARIABLE_FLAG_CONST_TESTED);
    /* nothing to do if the value is volatile or being assigned
       a non-constant */
    sz = (variable_is_array(var)) 
      ? variable_def_sz_get(
          variable_def_member_def_get(
            variable_def_member_get(
              variable_def_get(var))))
      : variable_sz_get(var);
    if (!variable_dflag_test(var, VARIABLE_DEF_FLAG_VOLATILE)
      && !variable_master_get(var)
      && !value_baseofs_get(val)
      && (!variable_is_array(var) || (1 == sz))
      && value_is_const(val1)) {
      uchar        *data_mask;
      uchar        *data;
      cmd_t         cmd_ptr;

      /*printf("%s --> %lu\n", value_name_get(val), value_const_get(val1));*/
      sz = variable_sz_get(var);
      if (variable_dflag_test(var, VARIABLE_DEF_FLAG_BIT)) {
        sz = (sz + 7) / 8; /* convert bit size to byte size */
      }

      data  = MALLOC(sz + (sz + 7) / 8);
      if (!data) {
        is_const = BOOLEAN_FALSE;
      } else {
        memset(data, 0, sz + (sz + 7) / 8);
        data_mask = data + sz;

        is_const = BOOLEAN_TRUE;
        /* let's look to all other uses of this variable. if it's
           not assigned again, or it's assigned the same constant,
           then change it to a constant, otherwise ignore it. */
        for (cmd_ptr = cmd;
             is_const && cmd_ptr;
             cmd_ptr = cmd_link_get(cmd_ptr)) {
          variable_t var2;

          val  = cmd_opdst_get(cmd_ptr);
          var2 = value_variable_get(val);
          if (var == var2) {
            if (OPERATOR_ASSIGN != cmd_optype_get(cmd_ptr)) {
              /* it's not simple assignment, therefore give it up */
              is_const = BOOLEAN_FALSE;
            } else {
              is_const = var_const_data_assign(val,
                sz, data_mask, data, cmd_opval1_get(cmd_ptr));
            }
          } else if (cmd_brproc_param_ct_get(cmd_ptr)) {
            /* if var is used as an OUT parameter to a function call,
               it must be assumed to be non const; if var is used as
               an IN parameter it's an implied assignment */
            const pfile_proc_t *proc;
            size_t              proc_param_ct;
            const value_t      *proc_params;
            size_t              ii;

            proc          = value_proc_get(cmd_brproc_get(cmd_ptr));
            proc_param_ct = cmd_brproc_param_ct_get(cmd_ptr);
            proc_params   = cmd_brproc_params_get(cmd_ptr);

            for (ii = 0; is_const && (ii < proc_param_ct); ii++) {
              value_t pparam;

              pparam = pfile_proc_param_get(proc, ii);
              if ((value_variable_get(proc_params[ii]) == var) 
                && value_dflag_test(pparam, VARIABLE_DEF_FLAG_OUT)) {
                is_const = var_const_data_assign(proc_params[ii],
                    sz, data_mask, data, pparam);
              } else if ((value_variable_get(pparam) == var)
                && value_dflag_test(pparam, VARIABLE_DEF_FLAG_IN)) {
                is_const = var_const_data_assign(pparam,
                    sz, data_mask, data, proc_params[ii]);
              }
            }
          } else if (CMD_TYPE_ASM == cmd_type_get(cmd_ptr)) {
            /* if the variable is used in an inline assembly construct
             * it cannot be const */
            is_const = (var != value_variable_get(cmd_asm_val_get(cmd_ptr)))
              && (var != value_variable_get(cmd_asm_n_get(cmd_ptr)));
          }
        }
        if (!is_const) {
          FREE(data); /* no more use for this */
        } else {
          /* this is really a const. first change the variable to
             const and set the new data pointer */
          variable_def_t def;

          def = variable_def_get(var);
          def = variable_def_flags_change(def,
            variable_def_flags_get_all(def) | VARIABLE_DEF_FLAG_CONST);

          variable_def_set(var, def);
          variable_data_set(var, data);
#if 0
          pfile_log(pf, PFILE_LOG_DEBUG, 
            "variable %s%u has been reduced to %lu in pass %u!",
            variable_name_get(var), variable_tag_n_get(var), 
            variable_const_get(var, VARIABLE_DEF_NONE, 0),
            pass);
#endif
        }
      }
    }
  }
  return is_const;
}

/* determine if a temporary value is const. formerly this was trivial
 * as a temporary was guarenteed to only be assigned once. With inline
 * function parameter substitution, this is no longer the case.
 *   temporary values have no variable attached, so the normal method
 * (above) cannot be used. instead, a far more involved method is
 * required.
 *   since there is no variable attached, we can simply compare the
 * values directly which simplifies things  
 */
static value_t pfile_opt_temp_is_const(pfile_t *pf, cmd_t cmd, value_t val)
{
  boolean_t        is_const;
  variable_const_t n;

  is_const = BOOLEAN_TRUE;
  n        = 0;
  if (value_flag_test(val, VALUE_FLAG_CONST_TESTED)) {
    is_const = BOOLEAN_FALSE;
  } else {
    boolean_t is_assigned; /* TRUE if n has been set */

    is_assigned = BOOLEAN_FALSE;
    value_flag_set(val, VALUE_FLAG_CONST_TESTED);
    while (cmd && is_const && (CMD_TYPE_PROC_LEAVE != cmd_type_get(cmd))) {
      if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
        /* is val assigned a non-const *or* different consts */
        if (val == cmd_opdst_get(cmd)) {
          if ((OPERATOR_ASSIGN == cmd_optype_get(cmd))
            && value_is_const(cmd_opval1_get(cmd))) {
            variable_const_t n1;

            n1 = value_const_get(cmd_opval1_get(cmd));
            is_const = !is_assigned || (n == n1);
            is_assigned = BOOLEAN_TRUE;
            n = n1;
          } else {
            is_const = BOOLEAN_FALSE;
          }
        }
      } else if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
        /* check that val isn't used as an OUT parameter */
        pfile_proc_t *proc;
        
        proc = value_proc_get(cmd_brproc_get(cmd));
        if (proc) {
          size_t   ii;
          value_t *params;

          params = cmd_brproc_params_get(cmd);
          for (ii = 0; is_const && (ii < pfile_proc_param_ct_get(proc)); ii++) {
            is_const = (params[ii] != val)
              || !value_dflag_test(pfile_proc_param_get(proc, ii),
                  VARIABLE_DEF_FLAG_OUT);
          }
        }
      } else if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
        /* if val exists in an asm, it *cannot* be const */
        is_const = (cmd_asm_n_get(cmd) != val) 
            && (cmd_asm_val_get(cmd) != val);

      }
      cmd = cmd_link_get(cmd);
    }
  }
  return (is_const)
    ? pfile_constant_get(pf, n, value_def_get(val))
    : VALUE_NONE;
}

static void pfile_opt_temp_replace(pfile_t *pf, cmd_t cmd_pv, cmd_t cmd,
  value_t val, value_t val_const)
{
  value_map_pair_t map_pair;
  value_map_t      map;

  UNUSED(pf);

  map_pair.old = val;
  map_pair.new = val_const;
  map.alloc    = 0;
  map.used     = 1;
  map.map      = &map_pair;
  while (cmd) {
    cmd_t cmd_next;

    cmd_next = cmd_link_get(cmd);
    if (val == cmd_opdst_get(cmd)) {
      /* delete this */
      cmd_link_set(cmd_pv, cmd_next);
      cmd_free(cmd);
      cmd = CMD_NONE;
    } else {
      cmd_value_remap(cmd, &map);
    }
    /* and...finish up */
    if (cmd) {
      cmd_pv = cmd;
    }
    cmd = cmd_next;
  }
}

#if 0
static unsigned cmd_list_check_ct;

void cmd_list_check(cmd_t head)
{
  cmd_list_check_ct++;
  while (head) {
    head = cmd_link_get(head);
  }
}
#endif

boolean_t pfile_opt_single_constant_assign(pfile_t *pf, unsigned pass)
{
  cmd_t     cmd;
  cmd_t     cmd_next;
  cmd_t     cmd_pv;
  unsigned  rem_ct;
  boolean_t any_changed;

  any_changed = BOOLEAN_FALSE;

  /* first, clear the VARIABLE_FLAG_CONST_TESTED flags...
   * also clear the VALUE_FLAG_CONST_TESTED which is used
   * for temporaries */
  for (cmd = pf->cmd_head; cmd; cmd = cmd_link_get(cmd)) {
    pfile_proc_t *proc;

    variable_flag_clr(value_variable_get(cmd_opdst_get(cmd)),
          VARIABLE_FLAG_CONST_TESTED);
    value_flag_clr(cmd_opdst_get(cmd), VALUE_FLAG_CONST_TESTED);
    proc = value_proc_get(cmd_brproc_get(cmd));
    if (proc) {
      size_t ii;

      for (ii = 0; ii < pfile_proc_param_ct_get(proc); ii++) {
        variable_flag_clr(value_variable_get(
              pfile_proc_param_get(proc, ii)), VARIABLE_FLAG_CONST_TESTED);
        value_flag_clr(pfile_proc_param_get(proc, ii), 
          VALUE_FLAG_CONST_TESTED);
      }
    }
  }

  for (cmd_pv = CMD_NONE, cmd = pf->cmd_head, rem_ct = 0;
       cmd;
       cmd = cmd_next) {
    cmd_next = cmd_link_get(cmd);

    if (OPERATOR_ASSIGN == cmd_optype_get(cmd)) {
      value_t val;

      val = cmd_opdst_get(cmd);
      if (value_is_temp(val)) {
        value_t val_const;

        val_const = pfile_opt_temp_is_const(pf, cmd, val);
        if (val_const) {
          /* replace all occurances of val with val_const and remove
           * all occurances of assigning to _temp
           * nb: we can safely ignore proc parameters
           *     (since a temp used as an OUT parameter clearly isn't
           *     going to be const), and asm values (same reason)
           */
          pfile_log(pf, PFILE_LOG_DEBUG, "_temp is const!: %lu", 
            value_const_get(val_const));
          pfile_opt_temp_replace(pf, cmd_pv, cmd, val, val_const); 
          value_release(val_const);
          any_changed = BOOLEAN_TRUE;
          cmd_next = cmd_link_get(cmd_pv);
          cmd = CMD_NONE;
        }
      } else if (pfile_opt_single_constant_assign_val(pf, cmd, val,
            cmd_opval1_get(cmd), pass)) {
        cmd_t      cmd_pv2;
        cmd_t      cmd_next2;
        cmd_t      cmd_ptr;
        variable_t var;
        /* second, look for all assignments to this variable
           and remove them */

        any_changed = BOOLEAN_TRUE;
        var = value_variable_get(val);
#if 1
        pfile_log(pf, PFILE_LOG_DEBUG, "variable is const!: %s%u (%lu)",
            variable_name_get(var), variable_tag_n_get(var),
            value_const_get(cmd_opval1_get(cmd)));
#endif
        for (cmd_pv2 = cmd_pv, cmd_ptr = cmd;
             cmd_ptr;
             cmd_ptr = cmd_next2) {
          cmd_next2 = cmd_link_get(cmd_ptr);
          if (var == value_variable_get(cmd_opdst_get(cmd_ptr))) {
            cmd_link_set(cmd_pv2, cmd_next2);
            if (cmd_ptr == cmd_next) {
              cmd_next = cmd_next2;
            }
            cmd_free(cmd_ptr);
            if (cmd_ptr == cmd) {
              cmd = CMD_NONE;
            }
            rem_ct++;
          } else {
            cmd_pv2 = cmd_ptr;
          }
        }
      }
    } else if (cmd_brproc_get(cmd) && cmd_brproc_param_ct_get(cmd)) {
      /* scan for any IN parameters assigned to constants */
      pfile_proc_t *proc;
      value_t      *proc_params;
      size_t        ii;

      proc        = value_proc_get(cmd_brproc_get(cmd));
      proc_params = cmd_brproc_params_get(cmd);
      for (ii = 0; ii < pfile_proc_param_ct_get(proc); ii++) {
        value_t val;

        val = pfile_proc_param_get(proc, ii);
        if (value_dflag_test(val, VARIABLE_DEF_FLAG_IN)) {
          /* implicit assignment */
          if (pfile_opt_single_constant_assign_val(pf, cmd, val, 
                proc_params[ii], pass)) {
            any_changed = BOOLEAN_TRUE;
            /* since this has gone CONST, 
             * remove the `VARIABLE_DEF_FLAG_IN' flag */
            /*assert(0);*/
          }
        }
        if (value_dflag_test(val, VARIABLE_DEF_FLAG_OUT)) {
          if (pfile_opt_single_constant_assign_val(pf, cmd, proc_params[ii], 
                val, pass)) {
            any_changed = BOOLEAN_TRUE;
          }
        }
      }
    }

    if (CMD_NONE != cmd) {
      cmd_pv = cmd;
    }
  }
  return any_changed;
}

/* this does several things (despite its name, which I need to change):
 *   look for constant arrays with non-constant indices and mark as LOOKUP
 *   look for constant arrays assigned to pointers & mark as LOOKUP
 *   look for anything assigned to pointers and set the appropriate PTR_FLAG
 */
static boolean_t pfile_ptr_flag_set(variable_t dst, flag_t flag)
{
  boolean_t rc;

  rc = BOOLEAN_FALSE;
  if (!variable_flag_test(dst, flag)) {
    rc = BOOLEAN_TRUE;
    variable_flag_set(dst, flag);
  }
  return rc;
}

static boolean_t pfile_lookup_mark_val(value_t val, value_t dst)
{
  variable_t var;
  variable_t dvar;
  boolean_t  rc;

  var  = value_variable_get(val);
  dvar = value_variable_get(dst);
  rc   = BOOLEAN_FALSE;
  if (variable_is_const(var)) {
    if (value_is_pointer(dst)) {
      variable_flag_set(var, VARIABLE_FLAG_LOOKUP);
      rc = pfile_ptr_flag_set(dvar, VARIABLE_FLAG_PTR_LOOKUP);
    } else {
      value_t baseofs;

      if (!variable_data_get(value_variable_get(val))) {
        value_baseofs_set(val, VALUE_NONE);
      }
      baseofs = value_baseofs_get(val);
      if (baseofs && !value_is_const(baseofs)) {
        variable_flag_set(var, VARIABLE_FLAG_LOOKUP);
      }
    }
  } else if (variable_is_pointer(var) && variable_is_pointer(dvar)) {
    /* assign pointer to pointer -- make sure all src pointer flags
     * are also present in dst */
    flag_t test_flags[] = {
      VARIABLE_FLAG_PTR_PTR,
      VARIABLE_FLAG_PTR_LOOKUP,
      VARIABLE_FLAG_PTR_EEPROM,
      VARIABLE_FLAG_PTR_FLASH
    };
    size_t ii;

    for (ii = 0; ii < COUNT(test_flags); ii++) {
      if (variable_flag_test(var, test_flags[ii])) {
        rc = pfile_ptr_flag_set(dvar, test_flags[ii]) || rc;
      }
    }
  } else if (value_is_pointer(dst)) {
    rc = pfile_ptr_flag_set(dvar, VARIABLE_FLAG_PTR_PTR);
  }
  return rc;
}

static void pfile_lookup_mark(pfile_t *pf)
{
  cmd_t     cmd;
  boolean_t rc;

  /* this must be repeated each time a dst flag propogate
   * a pointer being assigned to another pointer.
   */
  do {
    rc = BOOLEAN_FALSE;
    for (cmd = pf->cmd_head; cmd; cmd = cmd_link_get(cmd)) {
      if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
        value_t dst;

        dst = cmd_opdst_get(cmd);
        rc = pfile_lookup_mark_val(cmd_opval1_get(cmd), dst) || rc;
        rc = pfile_lookup_mark_val(cmd_opval2_get(cmd), dst) || rc;
      } else if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
        rc = pfile_lookup_mark_val(cmd_asm_val_get(cmd), VALUE_NONE) || rc;
      } else if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
        value_t      *params;
        pfile_proc_t *proc;
        size_t        param_ct;

        (void) pfile_lookup_mark_val(cmd_brval_get(cmd), VALUE_NONE);
        param_ct = cmd_brproc_param_ct_get(cmd);
        params   = cmd_brproc_params_get(cmd);
        proc     = value_proc_get(cmd_brproc_get(cmd));
        while (param_ct--) {
          rc = pfile_lookup_mark_val(params[param_ct],
              pfile_proc_param_get(proc, param_ct)) || rc;
        }
      }
    }
  } while (rc);
}

/*
 * NAME
 *   pfile_opt_proc_return
 *
 * DESCRIPTION
 *   optimize the way procedure return values are handled
 *
 * PARAMETERS
 *   pf : pfile handle
 *
 * RETURN
 *   none
 *
 * NOTES
 *   In general, the return value of procedure is immediately
 *   assigned to another variable, or discarded. In the former
 *   case, the variable will take the place of the temporary,
 *   and in the later case the temporary will be removed altogether
 */

static void pfile_opt_proc_return(pfile_t *pf)
{
  cmd_t cmd;
  cmd_t cmd_next;

  for (cmd = pfile_cmdlist_get(pf);
       cmd;
       cmd = cmd_next) {
    value_t tmp;

    cmd_next = cmd_link_get(cmd);
    tmp = cmd_brproc_param_get(cmd, 0); /* get the return value */
    if (tmp && value_is_temp(tmp)) {
      /* make resure this isn't used elsewhere */
      cmd_t     cmd_ptr;
      boolean_t is_used;
      boolean_t is_assigned;

      cmd_ptr = cmd_next;
      if ((OPERATOR_ASSIGN == cmd_optype_get(cmd_next))
          && (tmp == cmd_opval1_get(cmd_next))
          && value_variable_get(cmd_opdst_get(cmd_next))) {
        is_assigned = BOOLEAN_TRUE;
        cmd_ptr = cmd_link_get(cmd_ptr);
      } else {
        is_assigned = BOOLEAN_FALSE;
      }

      for (is_used = BOOLEAN_FALSE;
           !is_used 
           && cmd_ptr 
           && (CMD_TYPE_PROC_LEAVE != cmd_type_get(cmd_ptr));
           cmd_ptr = cmd_link_get(cmd_ptr)) {
        is_used = (cmd_value_accessed_get(cmd_ptr, tmp) != 0);
      }
      if (!is_used) {
        if (!is_assigned) {
          cmd_brproc_param_set(cmd, 0, VALUE_NONE);
        } else {
          cmd_brproc_param_set(cmd, 0, cmd_opdst_get(cmd_next));
          cmd_link_set(cmd, cmd_link_get(cmd_next));
          cmd_free(cmd_next);
          cmd_next = cmd_link_get(cmd);
        }
      }
    }
  }
}

static void pfile_flags_write(pfile_t *pf)
{
  static const struct {
    flag_t flag;
    const char *name;
  } flag_map[] = {
    {PFILE_FLAG_BOOT_RICK,           "boot-rick"},
    {PFILE_FLAG_BOOT_FUSES,          "boot-fuse"},
    {PFILE_FLAG_BOOT_LONG_START,     "boot-long-start"},
    {PFILE_FLAG_MISC_CLEAR_BSS,      "misc-clear-bss"},
    {PFILE_FLAG_MISC_INTERRUPT_FAST, "misc-interrupt-fast"},
    {PFILE_FLAG_MISC_INTERRUPT_RAW,  "misc-interrupt-raw"},
    {PFILE_FLAG_MISC_QUIET,          "misc-quiet"},
    {PFILE_FLAG_DEBUG_COMPILER,      "debug-compiler"},
    {PFILE_FLAG_DEBUG_PCODE,         "debug-pcode"},
    {PFILE_FLAG_DEBUG_CODEGEN,       "debug-codegen"},
    {PFILE_FLAG_OPT_EXPR_REDUCTION,  "opt-expr-reduce"},
    {PFILE_FLAG_OPT_CEXPR_REDUCTION, "opt-cexpr-reduce"},
    {PFILE_FLAG_OPT_TEMP_REDUCE,     "opt_temp_reduce" },
    {PFILE_FLAG_OPT_CONST_DETECT,    "opt-const-detect"},
    {PFILE_FLAG_OPT_VARIABLE_REDUCE, "opt-variable-reduce"},
    {PFILE_FLAG_OPT_LOAD_REDUCE,     "opt-load-reduce"},
    {PFILE_FLAG_WARN_BACKEND,        "warn-backend"},
    {PFILE_FLAG_WARN_CONVERSION,     "warn-conversion"},
    {PFILE_FLAG_WARN_DIRECTIVES,     "warn-directives"},
    {PFILE_FLAG_WARN_MISC,           "warn-misc"},
    {PFILE_FLAG_WARN_RANGE,          "warn-range"},
    {PFILE_FLAG_WARN_STACK_OVERFLOW, "warn-stack-overflow"},
    {PFILE_FLAG_WARN_TRUNCATE,       "warn-truncate"}
  };
  size_t      ii;
  const char *sep;
  size_t      col;

  col = 0;
  sep = ";    ";

  pfile_write(pf, pfile_write_asm, "; compiler flags:\n");
  for (ii = 0; ii < COUNT(flag_map); ii++) {
    if (pfile_flag_test(pf, flag_map[ii].flag)) {
      const char *name;

      name = flag_map[ii].name;
      if (col + strlen(name) > 70) {
        pfile_write(pf, pfile_write_asm, "\n");
        sep = ";    ";
        col = 0;
      }
      col += pfile_write(pf, pfile_write_asm, "%s%s", sep, flag_map[ii].name);
      if (';' == sep[0]) {
        sep = ", ";
      }
    }
  }
  if (',' == sep[0]) {
    pfile_write(pf, pfile_write_asm, "\n");
  }
}

static void cmd_opt_proc_return(cmd_t cmd)
{
  while (cmd) {
    cmd_t next;

    next = cmd_link_get(cmd);
    if ((CMD_BRANCHTYPE_CALL == cmd_brtype_get(cmd))
      && value_proc_get(cmd_brproc_get(cmd))) {
      value_t      *proc_params;
      pfile_proc_t *proc;

      proc_params = cmd_brproc_params_get(cmd);
      proc        = value_proc_get(cmd_brproc_get(cmd));
      if (pfile_proc_param_ct_get(proc) 
          && value_is_temp(proc_params[0])
          && (OPERATOR_ASSIGN == cmd_optype_get(next))
          && (proc_params[0] == cmd_opval1_get(next))
          && (value_byte_sz_get(proc_params[0])
              >= value_byte_sz_get(cmd_opdst_get(next)))
          && !(value_is_bit(proc_params[0])
              ^ value_is_bit(cmd_opdst_get(next)))) {
        cmd_t tmp;

        tmp = next;
        value_release(proc_params[0]);
        proc_params[0] = VALUE_NONE;
        next = cmd_link_get(next);
        cmd_link_set(cmd, next);
        cmd_free(tmp);
      }
    }
    cmd = next;
  }
}

/*
 * determine the sizes used for mulitplication
 */
static void pfile_cmd_arithmetic_check(pfile_t *pf)
{
  cmd_t  cmd;

  for (cmd = pf->cmd_head; cmd; cmd = cmd_link_get(cmd)) {
    if (OPERATOR_MUL == cmd_optype_get(cmd)) {
      unsigned w1;
      unsigned w2;
      size_t   ii;

      if (value_is_float(cmd_opval1_get(cmd))
        || value_is_float(cmd_opval2_get(cmd))) {
        w1 = 3;
        w2 = 6;
      } else {
        w1 = value_byte_sz_get(cmd_opval1_get(cmd));
        w2 = value_byte_sz_get(cmd_opval2_get(cmd));
        if (value_is_universal(cmd_opval1_get(cmd))) {
          w1 = w2;
        }
        if (value_is_universal(cmd_opval2_get(cmd))) {
          w2 = w1;
        }
      }
      if (w1 > w2) {
        unsigned tmp;

        tmp = w1;
        w1 = w2;
        w2 = tmp;
      }
      for (ii = 0; 
           (ii < pf->multiply_ct)
           && ((pf->multiply_widths[ii].multiplier != w1)
             || (pf->multiply_widths[ii].multiplicand != w2)); 
           ii++)
        ; /* null body */
      if (ii == pf->multiply_ct) {
        if (PFILE_MULTIPLY_PAIR_MAX == pf->multiply_ct) {
          pfile_log(pf, PFILE_LOG_ERR, "too many different multiply pairs!");
        } else {
          pf->multiply_widths[ii].multiplier   = w1;
          pf->multiply_widths[ii].multiplicand = w2;
          pf->multiply_widths[ii].use_ct       = 1;
          pf->multiply_ct++;
        }
      } else {
        pf->multiply_widths[ii].use_ct++;
      }
    }
  }
}


/*
 * NAME
 *   dump the command list
 *
 * DESCRIPTION
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 */
void pfile_cmd_dump(pfile_t *pf, const char *prog_name,
     size_t argc, char **argv)
{
  cmd_t           cmd;
  unsigned        cmd_no;
  label_t         lbl;
  int             is_dead;
  boolean_t       first;
  pfile_source_t *src;
  pfile_proc_t   *proc;

  first = BOOLEAN_TRUE;

  is_dead = 0;
  pfile_source_rewind(pf->src);
  /* first some optimizations */
  pfile_log(pf, PFILE_LOG_DEBUG, PFILE_MSG_PCODE_OPT);

  pfile_opt_proc_return(pf);
  /* this should come first */
  if (pfile_flag_test(pf, PFILE_FLAG_OPT_CONST_DETECT)) {
    unsigned        pass;

    pass = 0;
    do {
      pass++;
      pfile_cexpr_reduction(pf);
      (void) cmd_opt_branch4(pf, &pf->cmd_head);
    } while (pfile_opt_single_constant_assign(pf, pass));
  } else {
    pfile_cexpr_reduction(pf);
  }

  pfile_expr_reduction(pf);
  if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_CODEGEN)
      && pf->vectors->pf_cmd_pre_generate) {
    pf->vectors->pf_cmd_pre_generate(pf, &pf->cmd_head);
  }
  if (pfile_flag_test(pf, PFILE_FLAG_OPT_EXPR_SIMPLIFY)) {
    pfile_expr_simplify(pf);
  }
  pfile_temp_reduction(pf);
  /* this needs to be done again because temp_reduction tends to
   * lead to a lot of assignments to self */
  pfile_expr_reduction(pf);
  pfile_temp_fixup(pf);
  /* pfile_temp_fixup() also marks unassigned variables CONST, so
   * this needs to be done again */
  pfile_cexpr_reduction(pf);

  pfile_proc_reentrant_test(pfile_proc_root_get(pf), 
      PFILE_PROC_FLAG_CONTEXT_USER, 0);
  for (proc = pfile_proc_root_get(pf);
       proc;
       proc = pfile_proc_next(proc)) {
    if (pfile_proc_flag_test(proc, PFILE_PROC_FLAG_INTERRUPT)) {
      pfile_proc_reentrant_test(proc, PFILE_PROC_FLAG_CONTEXT_ISR, 0);
    }
  }

  /* now analyze the result to get rid of dead code */
  /* this call to cmd_opt_branch is needed to get the true destination
   * of a branch */
  (void) cmd_opt_branch(&pf->cmd_head);
  lbl = pfile_isr_entry_get(pf);
  if (lbl) {
    cmd_analyze(pf->cmd_head, cmd_label_find(pf->cmd_head, lbl), 
      CMD_FLAG_INTERRUPT, 0, pf);
    label_release(lbl);
  }
  lbl = pfile_user_entry_get(pf);
  if (lbl) {
    cmd_analyze(pf->cmd_head, cmd_label_find(pf->cmd_head, lbl),
      CMD_FLAG_USER, 0, pf);
    label_release(lbl);
  }
  /* remove all code that is unreachable.
   * note that pfile_cmd_remove_unreachable() must be called at least
   * once before pic_cmd_alloc() or the variable allocator will not
   * see variables in unused space & issue a bunch of errors! */
#if 0
  pfile_variable_fixup(pf);
  pfile_cexpr_reduction(pf);
#endif

  if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_DEADCODE)) {
    boolean_t changed;
    unsigned  opt_pass;

    opt_pass = 0;
    cmd_opt_proc_return(pf->cmd_head);
    do {
      opt_pass++;
      changed = pfile_cmd_remove_unreachable(pf);
      changed = cmd_opt_branch2(&pf->cmd_head) || changed;
      changed = cmd_opt_branch(&pf->cmd_head) || changed;
      changed = pfile_cmd_remove_assignments(pf) || changed;
      changed = pfile_cmd_remove_empty_blocks(pf) || changed;
      changed = cmd_opt_branch4(pf, &pf->cmd_head) || changed;
    } while (changed && (opt_pass < OPT_PASS_INFINITE));
    if (opt_pass == OPT_PASS_INFINITE) {
      pfile_log(pf, PFILE_LOG_INFO, "opt pass has gone infinite!");
    } else {
      pfile_log(pf, PFILE_LOG_DEBUG, "opt pass %u", opt_pass);
    }
  }
  /* now that its been analyzed, add in the isr preamble */
  pfile_variable_fixup(pf, pfile_flag_get_all(pf));
  pfile_cexpr_reduction(pf);

  pfile_lookup_mark(pf);

  if (pf->label_isr) {
    pfile_isr_preamble(pf);
  }
  pfile_mem_minimize(pf);

  pfile_cmdlist_check(pf->cmd_head);

  /* due liveness analysis */
  cmd_variable_live_analyze(pf->cmd_head);
  /* build the interference graph */
  cmd_variable_interference_generate(pf->cmd_head);
  /* all backend variables will be allocated as globals */
  pf->proc_active = pf->proc_root;
  pfile_proc_block_reset(pf->proc_active);

  pfile_cmd_arithmetic_check(pf);

  /* first, write the program name, version, and command line */
  pfile_write(pf, pfile_write_asm, "; compiler: %s\n", prog_name);
  pfile_write(pf, pfile_write_asm, "; command line: ");
  {
    size_t ii;

    for (ii = 0; ii < argc; ii++) {
      pfile_write(pf, pfile_write_asm, " %s", argv[ii]);
    }
    pfile_write(pf, pfile_write_asm, "\n");
  }
  if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_COMPILER)) {
    pfile_flags_write(pf);
  }
  if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_CODEGEN)) {
    pf->vectors->pf_cmd_generate(pf, pf->cmd_head);
  }
  pfile_log(pf, PFILE_LOG_INFO, PFILE_MSG_DUMPING_RESULT);
  /* dump all of the variables */
  src = cmd_source_get(pf->cmd_head);
  pfile_source_rewind(src);

  for (cmd = pf->cmd_head, cmd_no = 0; 
       cmd && !pfile_errct_get(pf); 
       cmd = cmd_link_get(cmd), cmd_no++) {
    int ch;

    pfile_pos_t pos;

    cmd_pos_get(cmd, &pos);
    pfile_statement_start_set(pf, &pos);
    if (!is_dead && !cmd_is_reachable(cmd)) {
      if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_PCODE)) {
        pfile_write(pf, pfile_write_lst, ";***dead code\n");
      }
      is_dead = 1;
    } else if (is_dead && cmd_is_reachable(cmd)) {
      if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_PCODE)) {
        pfile_write(pf, pfile_write_lst, ";************\n");
      }
      is_dead = 0;
    }
#if 0
    /* first, dump anything that isn't in the current file */
    if (src != cmd_source_get(cmd)) {
      while (src != cmd_source_get(cmd)) {
        pfile_write(pf, pfile_write_lst, ";%5u ", 
            pfile_source_line_get(src));
        
        while (EOF != (ch = pfile_source_ch_get(src))) {
          if ('\n' == ch) {
            pfile_write(pf, pfile_write_lst, "\n");
            break;
          } else {
            pfile_write(pf, pfile_write_lst, "%c", ch);
          }
        }
        src = cmd_source_get(cmd);
        pfile_source_rewind(src);
      }
    }
    ch = 0;
    while ((EOF != ch) && (cmd_line_get(cmd) != pfile_source_line_get(src))) {

      pfile_write(pf, pfile_write_lst, ";%5u ", 
          1 + pfile_source_line_get(src));
      
      while (EOF != (ch = pfile_source_ch_get(src))) {
        if ('\n' == ch) {
          pfile_write(pf, pfile_write_lst, "\n");
          break;
        } else {
          pfile_write(pf, pfile_write_lst, "%c", ch);
        }
      }
    }
#else
    /* here's an alternative - instead of trying to dump all of the
       source, only dump the line of source that contributes
       to this command */
    if (src != cmd_source_get(cmd)) {
      src = cmd_source_get(cmd);
      pfile_source_rewind(src);
      pfile_write(pf, pfile_write_lst, "; %s\n",
        pfile_source_name_get(src));
    }
    if (cmd_line_get(cmd) != pfile_source_line_get(src)) {
      do {
        ch = pfile_source_ch_get(src);
      } while ((EOF != ch) 
        && (cmd_line_get(cmd) != pfile_source_line_get(src)));
      if (EOF != ch) {
        assert(cmd_line_get(cmd) == pfile_source_line_get(src));
        pfile_write(pf, pfile_write_lst, ";%5u ",
          pfile_source_line_get(src));
        do {
          if ('\r' != ch) {
            pfile_write(pf, pfile_write_lst, "%c", ch);
          }
          if ('\n' == ch) {
            break;
          }
        } while (EOF != (ch = pfile_source_ch_get(src)));
        /* in case the file doesn't end with an EOL */
        if ('\n' != ch) {
          pfile_write(pf, pfile_write_lst, "\n");
        }
      }
    }
#endif
    if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_PCODE)) {
      if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_COMPILER)) {
        pfile_write(pf, pfile_write_lst, "; c(%lu) l(%u)", cmd_id_get(cmd),
          cmd_line_get(cmd));
      } else {
        pfile_write(pf, pfile_write_lst, ";      ");
      }
      if (!pfile_flag_test(pf, PFILE_FLAG_DEBUG_COMPILER)) {
        pfile_write(pf, pfile_write_lst, " %lu", cmd_id_get(cmd));
      }
      pfile_write(pf, pfile_write_lst, "{%c%c} ", 
        (cmd_flag_test(cmd, CMD_FLAG_USER)) ? 'u' : '-',
        (cmd_flag_test(cmd, CMD_FLAG_INTERRUPT)) ? 'i' : '-');
    }

    if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_PCODE) && pf->f_lst) {
      cmd_dump(cmd, pf->f_lst);
    }
    if (!is_dead) {
      if (CMD_TYPE_LOG == cmd_type_get(cmd)) {
        pfile_log(pf, cmd_log_type_get(cmd), "%s", cmd_log_str_get(cmd));
      }
      if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_CODEGEN)) {
        if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
          value_t brproc;

          /*lbl    = cmd_brdst_get(cmd);*/
          brproc = cmd_brproc_get(cmd);
          proc   = value_proc_get(brproc);
          lbl    = pfile_proc_label_get(proc);
          if (lbl && !label_flag_test(lbl, LABEL_FLAG_DEFINED)) {
            pfile_log(pf, PFILE_LOG_ERR, "%s declared but not defined",
              label_name_get(lbl));
          }
        }
        pf->vectors->pf_cmd_dump(pf, cmd, first);
      }
      first = BOOLEAN_FALSE;
    }
  }
  if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_CODEGEN)) {
    if (!pfile_errct_get(pf)) {
      pf->vectors->pf_cmd_dump(pf, CMD_NONE, first);
      if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_EMULATOR)) {
        pf->vectors->pf_cmd_emu(pf);
      }
    }
    pf->vectors->pf_cmd_cleanup(pf);
  }

  if (!pfile_errct_get(pf)) {
    if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_COMPILER)) {
      pfile_write(pf, pfile_write_lst, "; --- procedures & call stack\n");
      pfile_proc_dump(pf->proc_root, pf, 0);
      pfile_callstack_dump(pf);
      pfile_label_dump(pf);
      pfile_variable_dump(pf);
    }
    COD_directory_write(pf->COD_dir, pf->COD_name);
  }
}


/*
 * NAME
 *   pfile_label_list_dump
 *
 * DESCRIPTION
 *   dump the label list
 *
 * PARAMETERS
 *   pf   : 
 *   lst  :
 *   name :
 *
 * RETURN
 *
 * NOTES
 */
static void pfile_label_list_dump(pfile_t *pf, lbllist_t *lst, const char *name)
{
  label_t lbl;

  pfile_write(pf, pfile_write_lst, ";%s Labels\n", name);
  for (lbl = label_list_head(lst);
       lbl;
       lbl = label_next_get(lbl)) {
    pfile_write(pf, pfile_write_lst, ";%lx:%s(use=%u:ref=%u:pc=%04x)", 
        (ulong) lbl,
        label_name_get(lbl), label_usage_get(lbl),
        label_ref_ct_get(lbl), label_pc_get(lbl));
    pfile_write(pf, pfile_write_lst, "\n");
  }
}


void pfile_label_dump(pfile_t *pf)
{
  pfile_label_list_dump(pf, &pf->label_temp, "Temporary");
}


/*
 * NAME
 *   pfile_variable_fixup
 *
 * DESCRIPTION
 *   look for any variables that are never assigned & set them to const
 *   also, look for any bit variable chains and fix them up
 *
 * PARAMETERS
 *
 * RETURN
 *
 * NOTES
 */
void pfile_variable_fixup(pfile_t *pf, flag_t flags)
{
  pfile_proc_t *proc;

  for (proc = pf->proc_root; proc; proc = pfile_proc_next(proc)) {
    pfile_proc_param_fixup(proc);
  }

  for (proc = pf->proc_root; proc; proc = pfile_proc_next(proc)) {
    pfile_proc_variable_fixup(proc, pf, flags);
  }
  
  for (proc = pf->proc_root; proc; proc = pfile_proc_next(proc)) {
    pfile_proc_bitchain_fixup(proc, pf);
  }
}

/*
 * NAME
 *   pfile_variable_list_dump
 *
 * DESCRIPTION
 *   dump the variable list
 *
 * PARAMETERS
 *   pf    : pfile
 *   lst   :
 *   title :
 *
 * RETURN
 *
 * NOTES
 */
static void pfile_variable_list_dump(pfile_t *pf, varlist_t *lst, 
      const char *title)
{
  variable_t var;

  pfile_write(pf, pfile_write_lst, ";%s Variables\n"
         ";============\n", title);
  for (var = variable_list_head(lst); var; var = variable_link_get(var)) {
    pfile_write(pf, pfile_write_lst, 
        ";%u:%s F(%c%c%c%c) sz(%u) n(%ld) use(%u)",
        variable_id_get(var),
        variable_name_get(var),
        (variable_is_const(var))    ? 'C' : '-',
        (variable_is_volatile(var)) ? 'V' : '-',
        (variable_assign_ct_get(var))                     ? 'A' : '-',
        (variable_use_ct_get(var))                        ? 'U' : '-',
        variable_sz_get(var),
        (unsigned long) variable_const_get(var, variable_def_get(var), 0),
        variable_use_ct_get(var));
    if (!(variable_is_const(var))) {
      pfile_write(pf, pfile_write_lst, " assign(%u) base(%x)", 
        variable_assign_ct_get(var),
        variable_base_get(var, 0));
    }
    pfile_write(pf, pfile_write_lst, "\n");
  }
}

void pfile_variable_dump(pfile_t *pf)
{
  pfile_variable_list_dump(pf, &pf->var_const, "Unnamed Constant");
}

unsigned pfile_errct_get(const pfile_t *pf)
{
  return pf->errct;
}

unsigned pfile_warnct_get(const pfile_t *pf)
{
  return pf->warnct;
}

/*
 * NAME
 *   pfile_isr_preamble
 *
 * DESCRIPTION
 *   generate the generic ISR preamble code
 *
 * PARAMETERS
 *   pf : pfile
 *
 * RETURN
 *   none
 *
 * NOTES
 *   isr preamble:
 *      1. save any temporaries
 *      2. jump to first defined ISR
 *   this is ignored if there are no ISRs defined
 */
void pfile_isr_preamble(pfile_t *pf)
{
  UNUSED(pf);
#if 0
  cmd_t      cmd;
  cmd_t      cmdlist; /* command list  */
  label_t    lbl;
  int        rc;

  /* first, scan all commands looking for those that
     execute in the interrupt context */
  pfile_cmd_label_add(pf, pf->label_isr_preamble);
  /* create the isr_preamble -- any temporaries used by routines common
     to both user and interrupt level need to be saved during the context
     switch */
  cmdlist = pf->cmd_head; /* save the command list */
  pf->cmd_head = 0;
  pf->cmd_tail = 0;

  /* jump to the first ISR */
  pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
    CMD_BRANCHCOND_NONE, pf->label_isr, VALUE_NONE, VALUE_NONE, 0);

  /* the last isr will jump to _isr_cleanup, so we'd best create it */
  lbl = pfile_label_find(pf, PFILE_LOG_ERR, "_isr_cleanup");
  if (0 == rc) {
    pfile_cmd_label_add(pf, lbl);
    label_release(lbl);
  }
  /* pfile_cmd_op_add(pf, 0, OPERATOR_NULL, 0, 0, 0); */
  pfile_cmd_special_add(pf, CMD_TYPE_ISR_CLEANUP, PFILE_PROC_NONE);
  /* prepend the new commands to the existing command list, but
     note that each of the new commands executes at interrupt context */
  for (cmd = pfile_cmdlist_get(pf); cmd; cmd = cmd_link_get(cmd)) {
    cmd_flag_set(cmd, CMD_FLAG_REACHABLE);
    cmd_flag_set(cmd, CMD_FLAG_INTERRUPT);
    if (!cmd_link_get(cmd)) {
      cmd_link_set(cmd, cmdlist);
      break;
    }
  } 
#endif
}

cmd_t pfile_cmdlist_get(pfile_t *pf)
{
  return pf->cmd_head;
}

cmd_t pfile_cmdlist_tail_get(pfile_t *pf)
{
  return pf->cmd_tail;
}

label_t pfile_lblptr_get(pfile_t *pf)
{
  return pf->label_temp_ptr;
}

void pfile_lblptr_set(pfile_t *pf, label_t lbl)
{
  pf->label_temp_ptr = lbl;
}

void pfile_rewind(pfile_t *pf)
{
  pfile_source_rewind(pf->src);
}

void pfile_user_entry_set(pfile_t *pf, label_t lbl)
{
  if (lbl) {
    label_lock(lbl);
    label_usage_bump(lbl, CTR_BUMP_INCR);
  }
  if (pf->label_main) {
    label_usage_bump(pf->label_main, CTR_BUMP_DECR);
    label_release(pf->label_main);
  }
  pf->label_main = lbl;
}

label_t pfile_user_entry_get(pfile_t *pf)
{
  label_t lbl;

  lbl = pf->label_main;
  if (lbl) {
    label_lock(lbl);
  }
  return lbl;
}

#if 0
void pfile_isr_entry_set(pfile_t *pf, label_t lbl)
{
  if (lbl) {
    label_lock(lbl);
    label_usage_bump(lbl, CTR_BUMP_INCR);
  }
  if (pf->label_isr) {
    label_usage_bump(pf->label_isr, CTR_BUMP_DECR);
    label_release(pf->label_isr);
  }
  pf->label_isr = lbl;
}
#endif

label_t pfile_isr_entry_get(pfile_t *pf) 
{
  label_t lbl;

  lbl = pf->label_isr;
  if (lbl) {
    label_lock(lbl);
  }
  return lbl;
}

/*
 * nb : don't rely on the output of this, as the file written
 *      may not exist, hence the returned value will be 0
 */
int pfile_write(pfile_t *pf, pfile_write_t where, const char *fmt, ...)
{
  FILE   *out;
  int     rc;

  out = pf->f_lst;
  switch (where) {
    case pfile_write_lst: out = pf->f_lst; break;
    case pfile_write_asm: out = pf->f_asm; break;
  }
  if (out) {
    va_list vlst;

    va_start(vlst, fmt);
    rc = vfprintf(out, fmt, vlst);
    va_end(vlst);
  } else {
    rc = 0;
  }
  return rc;
}

void pfile_write_hex(pfile_t *pf, ulong pc, unsigned char data)
{
  if ((pc >> 16) != pf->hex.pc_msw) {
    /* this appears to set the MSW of the pc! */
    pfile_hex_line_flush(pf);
    pf->hex.pc_msw = pc >> 16;
    if (pf->f_hex && !pfile_flag_test(pf, PFILE_FLAG_BOOT_RICK)) {
      unsigned chk;

      chk = -(2 + 4 + (pf->hex.pc_msw >> 8) + (pf->hex.pc_msw & 0xff));
      fprintf(pf->f_hex, ":02000004%04X%02X\n", pf->hex.pc_msw, chk & 0xff);
    }
  }
  if (pc != pf->hex.pc + pf->hex.ct) {
    pfile_hex_line_flush(pf);
    pf->hex.pc = pc;
  }
  pf->hex.buf[pf->hex.ct] = data;
  pf->hex.ct++;
  if (!((pf->hex.pc + pf->hex.ct) & 0x0f)) {
    pfile_hex_line_flush(pf);
  }
}

/*
 * NAME
 *   pfile_string_find
 *
 * DESCRIPTION
 *   return a string if it exists
 *
 * PARAMETERS
 *   pf  : 
 *   sz  : 
 *   ptr : 
 *
 * RETURN
 *   value describing the string, or NULL if not found
 *
 * NOTES
 *   this checks all existing lookup tables to see if a substring
 *   matches the passed in string.
 */
value_t pfile_string_find(pfile_t *pf, size_t sz, const char *ptr)
{
  value_t    val;
#if 0
  variable_t var;
  size_t     ii;
#endif

  UNUSED(pf);
  UNUSED(sz);
  UNUSED(ptr);

  val = 0;
#if 0
  ii  = 0;
  for (var = variable_list_head(&pf->var_active); 
       var; 
       var = variable_link_get(var)) {
    size_t jj;

    jj = 0;
    if (variable_flag_test(var, VARIABLE_FLAG_CONST)
        && (variable_ct_get(var) >= sz)) {

      for (ii = 0; ii <= variable_ct_get(var) - sz; ii++) {

        for (jj = 0; 
             (jj < sz) && (ptr[sz - jj - 1] == variable_const_get(var, jj + ii)); 
             jj++)
          ; /* null body */
        if (jj == sz) {
          break;
        }
      }
    }
    if (jj == sz) {
      break;
    }
  }
  if (var) {
    result_t rc;

    rc = value_alloc(&val, var, 0, 0, variable_sz_get(var));
    if (RESULT_OK != rc) {
      pfile_log_syserr(pf, rc);
    } else {
      value_ct_ofs_set(val, ii);
      value_ct_set(val, sz);
    }
  }
#endif
  return val;

}

boolean_t pfile_flag_test(const pfile_t *pf, flag_t flag)
{
  return (pf) ? ((pf->flags & flag) != 0) : 0;
}

flag_t pfile_flag_get_all(const pfile_t *pf)
{
  return (pf) ? pf->flags : 0;
}

void pfile_flag_set(pfile_t *pf, flag_t flag)
{
  pf->flags |= flag;
}

void pfile_flag_clr(pfile_t *pf, flag_t flag)
{
  pf->flags &= ~flag;
}

void pfile_flag_change(pfile_t *pf, flag_t mask, flag_t flag)
{
  pf->flags = (pf->flags & mask) | flag;
}

label_t pfile_isr_preamble_entry_get(pfile_t *pf)
{
  return pf->label_isr_preamble;
}

void pfile_label_fixup(pfile_t *pf)
{
  pfile_proc_t *proc;

  for (proc = pf->proc_root; proc; proc = pfile_proc_next(proc)) {
    pfile_proc_label_fixup(proc);
  }
}

pfile_source_t *pfile_source_get(const pfile_t *pf)
{
  return pf->src;
}

void pfile_source_restore(pfile_t *pf, pfile_source_t *src)
{
  if (pf->src) {
    pfile_source_release(pf->src);
  }
  pf->src = src;
}

result_t pfile_source_set(pfile_t *pf, const char *fname)
{
  result_t rc;

  rc = pfile_source_open(&pf->src, fname, pf);
  if (RESULT_OK == rc) {
    cmd_t cmd;

    pfile_source_file_no_set(pf->src, 
        COD_name_entry_add(pf->COD_dir, (const uchar *) fname));
    for (cmd = pf->cmd_head;
         cmd && !cmd_source_get(cmd);
         cmd = cmd_link_get(cmd)) {
      cmd_source_set(cmd, pf->src);
      cmd_line_set(cmd, 1);
    }
    pfile_source_link_set(pf->src, pf->src_list);
    pfile_source_lock(pf->src);
    pfile_source_release(pf->src_list);
    pf->src_list = pf->src;
    pfile_rewind(pf);
  }
  return rc;
}

variable_def_t pfile_variable_def_find(pfile_t *pf, pfile_log_t plog,
  const char *tag)
{
  variable_def_t def;
  pfile_proc_t  *proc;

  for (def = 0, proc = pf->proc_active;
       proc && !def;
       proc = pfile_proc_parent_get(proc)) {
    def = pfile_proc_variable_def_find(proc, tag);
  }
  if (!def) {
    pfile_log(pf, plog, "variable type expected");
  }
  return def;
}

result_t pfile_variable_def_add(pfile_t *pf, variable_def_t def)
{
  return pfile_proc_variable_def_add(pf->proc_active, def);
}


/*
 * NAME
 *   pfile_proc_create
 *
 * DESCRIPTION
 *   create a new procedure
 *
 * PARAMETERS
 *   pf         : pfile handle
 *   tag        : procedure name
 *   param_ct   : # of parameters
 *   params     : array of parameters
 *   return_def : return type
 *
 * RETURN
 *   matching procedure
 *
 * NOTES
 *   if the procedure already exists, this checks to make sure
 *   the parameters & return value are the same
 *   if the procedure does not exist, it allocates a matching
 *   function variable and procedure  
 */
pfile_proc_t *pfile_proc_create(pfile_t *pf, const char *tag, 
    variable_def_t proc_def)
{
  pfile_proc_t *proc;

  proc = pfile_proc_find(pf, PFILE_LOG_NONE, tag);
  if (proc) {
    /* check to make sure this has the same signature */
  } else {
    label_t entry_label;
    label_t skip_label;
    label_t exit_label;

    entry_label = pfile_label_alloc(pf, tag);
    skip_label  = pfile_label_alloc(pf, 0);
    exit_label  = pfile_label_alloc(pf, 0);

    proc = pfile_proc_alloc(pf->proc_active, entry_label, skip_label,
        exit_label, proc_def);
    if (!proc) {
      pfile_log_syserr(pf, ENOMEM);
    } else {
      /* let's allocate the corresponding variable. this has the same
       * name as the proc and is type variable_def_type_fn */
       variable_t var;

      if (RESULT_OK == pfile_variable_alloc(pf,
          PFILE_VARIABLE_ALLOC_LOCAL, tag, proc_def, VARIABLE_NONE, 
          &var)) {
        variable_proc_set(var, proc);
        variable_base_set(var, 0, 0);
        variable_release(var);
      }
    }
  }
  return proc;
}

/* enter a procedure */
result_t pfile_proc_enter(pfile_t *pf, const char *tag)
{
  pfile_proc_t *child;
  result_t      rc;

  for (child = pfile_proc_child_get(pf->proc_active);
       child && strcmp(tag, pfile_proc_tag_get(child));
       child = pfile_proc_sibbling_get(child))
    ; /* null body */
  if (child) {
    pf->proc_active = child;
    if (!pfile_proc_flag_test(child, PFILE_PROC_FLAG_INTERRUPT)) {
      pfile_cmd_special_add(pf, CMD_TYPE_PROC_ENTER, child);
    }

    rc = RESULT_OK;
  } else {
    rc = RESULT_NOT_FOUND;
  }
  return rc;
}

/* leave an existing procedure */
result_t pfile_proc_leave(pfile_t *pf)
{
  result_t rc;

  if (pf->proc_root == pf->proc_active) {
    rc = RESULT_INTERNAL;
  } else {
    if (!pfile_proc_flag_test(pf->proc_active, PFILE_PROC_FLAG_INTERRUPT)) {
      pfile_cmd_add(pf, cmd_proc_alloc(CMD_TYPE_PROC_LEAVE, pf->proc_active));
      if (pfile_proc_flag_test(pf->proc_active, PFILE_PROC_FLAG_NOSTACK)) {
        pfile_proc_ret_ptr_alloc(pf->proc_active, pf);
      }
    } else {
      if (pf->label_isr) {
        pfile_cmd_branch_add(pf, CMD_BRANCHTYPE_GOTO,
            CMD_BRANCHCOND_NONE, pf->label_isr, VALUE_NONE, VALUE_NONE,
            0);
      } else {
        pfile_cmd_special_add(pf, CMD_TYPE_ISR_CLEANUP, PFILE_PROC_NONE);
      }
      pf->label_isr = pfile_proc_label_get(pf->proc_active);
    }
      
    pf->proc_active = pfile_proc_parent_get(pf->proc_active);
    rc = RESULT_OK;
  }
  return rc;
}

result_t pfile_block_enter(pfile_t *pf)
{
  result_t rc;

  rc = pfile_proc_block_enter(pf->proc_active);
  if (RESULT_OK == rc) {
    pfile_cmd_special_add(pf, CMD_TYPE_BLOCK_START, 0);
  }
  return rc;
}

result_t pfile_block_leave(pfile_t *pf)
{
  pfile_cmd_special_add(pf, CMD_TYPE_BLOCK_END, 0);
  return pfile_proc_block_leave(pf->proc_active);
}


/* look for procedure named, ``tag''. 
 *    1st -- search all children
 *    2nd -- move up the tree & repeat */
pfile_proc_t *pfile_proc_find(pfile_t *pf, pfile_log_t plog, const char *tag)
{
  pfile_proc_t *proc;
  pfile_proc_t *root;

  UNUSED(plog);

  root = pf->proc_active;

  proc = 0;
  while (root && !proc) {
    for (proc = pfile_proc_child_get(root); 
         proc && strcmp(pfile_proc_tag_get(proc), tag); 
         proc = pfile_proc_sibbling_get(proc))
      ;
    if (!proc) {
      root = pfile_proc_parent_get(root);
    }
  }
  return proc;
}

pfile_proc_t *pfile_proc_active_get(const pfile_t *pf)
{
  return pf->proc_active;
}

void pfile_proc_active_set(pfile_t *pf, pfile_proc_t *proc)
{
  pf->proc_active = proc;
}

pfile_proc_t *pfile_proc_root_get(const pfile_t *pf)
{
  return pf->proc_root;
}

/*
 * NAME
 *   pf_include_process
 *
 * DESCRIPTION
 *   process an include file
 *
 * PARAMETERS
 *   pf    : file
 *   fname : include file name
 *
 * RETURN
 *   none
 *
 * NOTES
 */
void pfile_include_process(pfile_t *pf, size_t fname_sz,
  const char *fname)
{
  const char *ptr;
  char       *token;

  pf->stats.files++;
  if (!fname_sz) {
    fname_sz = strlen(fname);
  }
  pfile_log(pf, PFILE_LOG_DEBUG, PFILE_MSG_DBG_INCLUDE, (int) fname_sz, fname);
  ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
  token = MALLOC(1 + strlen(ptr));
  if (!token) {
    pfile_log_syserr(pf, RESULT_MEMORY);
  } else {
    pfile_source_t *psrc;
    char           *fpath;
    result_t        rc;

    strcpy(token, ptr);
    psrc = pfile_source_get(pf);

    fpath = MALLOC((size_t) (1 + FILENAME_MAX));
    if (!fpath) {
      pfile_log_syserr(pf, RESULT_MEMORY);
    } else {
      ptr = 0;
      do {
        size_t      sz;
        const char *ptr_nxt; /* points to the next element */

        if (!ptr) {
          sz = 0;
          rc = RESULT_OK;
          ptr_nxt = pfile_include_path_get(pf);
        } else {
          ptr_nxt = strchr(ptr, ';');
          if (ptr_nxt) {
            sz = (size_t) (ptr_nxt - ptr);
            ptr_nxt++;
            if (!*ptr_nxt) {
              ptr_nxt = 0;
            }
          } else {
            sz = strlen(ptr);
          }
        }
        /* note: i'm not going to deal with the edge case of
                 the requested file being exactly the maximum
                 path length */
        if ((int) (sz + 1 + fname_sz) >= FILENAME_MAX) {
          pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_PATH_TOO_LONG);
          rc = RESULT_RANGE;
        } else {
          if (sz) {
            /* copy over the path */
            memcpy(fpath, ptr, sz);
            /* add a path seperator if necessary */
            if ((fpath[sz-1] != '/') && (fpath[sz-1] != '\\')) {
              fpath[sz++] = '/';
            }
          } else {
            /* no path, hence no seperator */
            fpath[0] = 0;
          }
          memcpy(fpath + sz, fname, fname_sz);
          fpath[fname_sz + sz] = 0;
        }
        ptr = ptr_nxt;
        rc = pfile_source_set(pf, fpath);
        if (RESULT_OK == rc) {
          pfile_log(pf, PFILE_LOG_DEBUG, PFILE_MSG_DBG_INCLUDE, 
            (int) strlen(fpath), fpath);
        }
      } while (ptr && (RESULT_OK != rc));
      if (RESULT_OK != rc) {
        pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CANNOT_OPEN, fname);
      } else {
        pfile_pos_t statement_start;
        pfile_pos_t token_start;

        pfile_statement_start_get(pf, &statement_start);
        pfile_token_start_get(pf, &token_start);
        pf->vectors->pf_include_fn(pf);
        ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
        if (*ptr) {
          pfile_log(pf, PFILE_LOG_ERR, "unexpected token: \"%s\"", ptr);
        }
        pfile_token_start_set(pf, &token_start);
        pfile_statement_start_set(pf, &statement_start);
        pfile_source_restore(pf, psrc);
      }
      FREE(fpath);
    }
    pf_token_set(pf, token);
    FREE(token);
  }
}

const char *pfile_include_path_get(pfile_t *pf)
{
  return pf->include_path;
}

result_t pfile_include_path_set(pfile_t *pf, const char *inc_path)
{
  size_t   sz;
  result_t rc;

  rc = RESULT_OK;
  if (pf->include_path) {
    FREE(pf->include_path);
  }
  if (inc_path) {
    sz = strlen(inc_path) + 1;
    pf->include_path = MALLOC(sz);
    if (!pf->include_path) {
      rc = RESULT_MEMORY;
    } else {
      memcpy(pf->include_path, inc_path, sz);
    }
  } else {
    pf->include_path = 0;
  }
  return rc;
}

void *pfile_vector_arg_get(const pfile_t *pf)
{
  return pf->vector_arg;
}

void pfile_vector_arg_set(pfile_t *pf, void *arg)
{
  pf->vector_arg = arg;
}

void        pfile_codegen_disable(pfile_t *pf, boolean_t disable)
{
  if (disable) {
    pf->codegen_disable++;
  } else {
    assert(pf->codegen_disable);
    if (pf->codegen_disable) {
      pf->codegen_disable--;
    }
  }
}

boolean_t   pfile_codegen_disable_get(const pfile_t *pf)
{
  return pf->codegen_disable != 0;
}

void pfile_statement_start_set(pfile_t *pf, const pfile_pos_t *pos)
{
  if (pos) {
    pfile_source_lock(pos->src);
  }
  if (pf->statement_start.src) {
    pfile_source_release(pf->statement_start.src);
  }
  /*pf->statement_start = pf->token_start;*/
  pf->statement_start = *pos;
}

void pfile_statement_start_get(pfile_t *pf, pfile_pos_t *pos)
{
  *pos = pf->statement_start;
}

void pfile_token_start_get(pfile_t *pf, pfile_pos_t *pos)
{
  *pos = pf->token_start;
}

void pfile_token_start_set(pfile_t *pf, const pfile_pos_t *pos)
{
  pf->token_start = *pos;
}

void pfile_pos_get(pfile_t *pf, pfile_pos_t *pos)
{
  if (pf && pos) {
    pos->src = pf->src;
    pos->line = pfile_source_line_get(pf->src);
  }
}

result_t pfile_value_member_select(pfile_t *pf, value_t val, 
    const char *tag)
{
  variable_def_t        def;
  variable_def_member_t mbr;
  size_t                ofs;
  size_t                bitofs;
  result_t              rc;

  def    = value_def_get(val);
  mbr    = variable_def_member_get(def);
  bitofs = 0;
  ofs    = 0;
  if (!tag) {
    assert(mbr && !variable_def_member_link_get(mbr));
  } else {
    while (mbr && strcmp(tag, variable_def_member_tag_get(mbr))) {
      variable_def_t      mdef;

      mdef = variable_def_member_def_get(mbr);
      if (variable_def_flag_test(mdef, VARIABLE_DEF_FLAG_BIT)) {
        bitofs += variable_def_sz_get(mdef);
      } else {
        if (bitofs) {
          ofs += (bitofs + 7) / 8;
          bitofs = 0;
        }
        ofs += variable_def_member_ct_get(mbr)
          * variable_def_sz_get(mdef);
      }
      mbr = variable_def_member_link_get(mbr);
    }
  }
  if (mbr) {
    value_t tmp;
    expr_t *stk;

    stk = 0;

    rc = RESULT_OK;
    if (ofs) {
      tmp = pfile_constant_get(pf, ofs, VARIABLE_DEF_NONE);

      if (value_baseofs_get(val)) {
        (void) pfile_expr_push(pf, &stk, tmp, OPERATOR_ADD);
        (void) pfile_expr_push(pf, &stk, value_baseofs_get(val), OPERATOR_NULL);
        value_release(tmp);
        tmp = expr_val_get(stk);
        value_lock(tmp);
        expr_free(stk);
      }
      value_baseofs_set(val, tmp);
      value_release(tmp);
    }
    value_def_set(val, variable_def_member_def_get(mbr));
  } else {
    rc = RESULT_NOT_FOUND;
  }
  return rc;
}

result_t pfile_value_element_select(pfile_t *pf, value_t val, value_t el)
{
  variable_def_t        def;
  result_t              rc;

  def = value_def_get(val);
  if (VARIABLE_DEF_TYPE_POINTER == variable_def_type_get(def)) {
    /* descend in to the next member and adjust */
    variable_def_member_t mbr;
    value_t               tmp;
    expr_t               *stk;

    rc  = RESULT_OK;
    mbr = variable_def_member_get(def);
    tmp = pfile_constant_get(pf, variable_def_sz_get(
          variable_def_member_def_get(mbr)), VARIABLE_DEF_NONE);
    stk = 0;
    /* el * tmp [ + previous ] */
    (void) pfile_expr_push(pf, &stk, tmp, OPERATOR_MUL);
    if (value_baseofs_get(val)) {
      (void) pfile_expr_push(pf, &stk, el, OPERATOR_ADD);
      (void) pfile_expr_push(pf, &stk, value_baseofs_get(val), OPERATOR_NULL);
    } else {
      (void) pfile_expr_push(pf, &stk, el, OPERATOR_NULL);
    }
    value_baseofs_set(val, expr_val_get(stk));
    expr_free(stk);
    value_release(tmp);
  } else {
    rc = RESULT_INVALID;
  }
  return rc;
}

tag_t pfile_tag_alloc(pfile_t *pf, const char *name)
{
  tag_t tag;

  for (tag = pf->tag_list;
       tag && strcmp(tag_name_get(tag), name); 
       tag = tag_link_get(tag))
    ; /* null body */
  if (!tag) {
    tag = tag_alloc(name);
    if (tag) {
      tag_link_set(tag, pf->tag_list);
      pf->tag_list = tag;
    }
  }
  return tag;
}

pfile_source_t *pfile_source_list_head_get(pfile_t *pf)
{
  return pf->src_list;
}

void pfile_stats_get(pfile_t *pf, pfile_stats_t *stats)
{
  if (pf) {
    memcpy(stats, &pf->stats, sizeof(*stats));
  } else {
    memset(stats, 0, sizeof(*stats));
  }
}

pfile_token_ct_t pfile_token_ct_get(pfile_t *pf)
{
  return pf->token_ct;
}

/* set the cmd insertion point (aka cursor) to cmd */
void pfile_cmd_cursor_set(pfile_t *pf, cmd_t cmd)
{
  pf->cmd_cursor = cmd;
}

unsigned pfile_task_ct_get(pfile_t *pf)
{
  return (pf) ? pf->task_ct : 0;
}

void pfile_task_ct_set(pfile_t *pf, unsigned ct)
{
  if (pf) {
    pf->task_ct = ct;
  }
}

FILE *pfile_asm_file_set(pfile_t *pf, FILE *f_asm)
{
  FILE *f;

  f = pf->f_asm;
  pf->f_asm = f_asm;
  return f;
}

FILE *pfile_hex_file_set(pfile_t *pf, FILE *f_hex)
{
  FILE *f;

  f = pf->f_hex;
  pf->f_hex = f_hex;
  return f;
}

COD_directory_t *pfile_COD_dir_get(pfile_t *pf)
{
  return pf->COD_dir;
}

variable_sz_t pfile_pointer_size_get(pfile_t *pf)
{
  return pf->vectors->pf_pointer_size_get(pf);
}

label_t pfile_exit_label_get(const pfile_t *pf)
{
  return pf->exit_label;
}

label_t pfile_exit_label_set(pfile_t *pf, label_t lbl)
{
  label_t old;

  old = pf->exit_label;
  pf->exit_label = lbl;
  return old;
}

void pfile_loader_offset_set(pfile_t *pf, ulong offset)
{
  if (pf) {
    pf->loader_offset = offset;
  }
}

ulong pfile_loader_offset_get(pfile_t *pf)
{
  return (pf) ? pf->loader_offset : 0;
}

const pfile_multiply_width_table_entry_t *
    pfile_multiply_width_table_entry_get(pfile_t *pf, size_t ii)
{
  return (ii < pf->multiply_ct)
    ? pf->multiply_widths + ii
    : 0;
}


