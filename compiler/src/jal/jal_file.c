/************************************************************
 **
 ** jal_file.c : JAL file structure definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include "../libutils/mem.h"
#include "jal_file.h"

typedef struct jal_file_ {
  unsigned loop_no;    /* next ID to use for FOR loops */
} jal_file_t;

result_t jal_file_open(pfile_t *pf)
{
  result_t    rc;
  jal_file_t *jal;

  jal = MALLOC(sizeof(*jal));
  if (!jal) {
    rc = RESULT_MEMORY;
  } else {
    rc = RESULT_OK;
    jal->loop_no = 0;
    pfile_vector_arg_set(pf, jal);
  }

  return rc;
}

void jal_file_close(pfile_t *pf)
{
  jal_file_t *jal;

  jal = pfile_vector_arg_get(pf);
  if (jal) {
    FREE(jal);
  }
}

/* the FOR command needs a variable. It cannot use the normal _temp
 * because the _temp semantics assume that no _temps are in use at
 * the end-of-statement mark. so, just pass in the resulting value
 * as src and a new value, _floop#, is created and returned
 */ 
value_t jal_file_loop_var_get(pfile_t *pf, value_t src)
{
  jal_file_t *jal;
  value_t     val;

  val = VALUE_NONE;
  jal = pfile_vector_arg_get(pf);
  if (jal) {
    char           name[32];
    variable_def_t def;

    if (value_is_universal(src)) {
      variable_sz_t       sz;
      variable_def_type_t type;
      flag_t              flags;
      variable_const_t    cn;

      cn = value_const_get(src); 
      variable_calc_sz_min(cn, &sz, &type, &flags);
        /* If the value is border power of two, use the next smallest
         * size. For example, 256 can fit into a BYTE, 65536 into a BYTE*2,
         * etc. */
      if ((sz > 1) && !(cn & (cn - 1))) {
        unsigned long which;

        for (which = 0, cn >>= 1; cn; which += 1, cn >>= 1)
          ; /* no body */
        if ((which % 8) == 0) {
          sz--;
        }
      }

      def = variable_def_alloc(0, type, flags, sz);

    } else {
      def = variable_def_alloc(0, value_type_get(src), 0, value_sz_get(src));
    }

    sprintf(name, "_floop%u", ++jal->loop_no);
    pfile_value_alloc(pf, PFILE_VARIABLE_ALLOC_LOCAL, name, def, &val);
  } 
  return val;
}

