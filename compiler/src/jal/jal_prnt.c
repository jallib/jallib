/**********************************************************
 **
 ** jal_prnt.c : parser for JAL print functions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include "../libcore/pf_cmd.h"
#include "../libcore/pf_expr.h"
#include "jal_expr.h"
#if 0
#include "jal_blck.h"
#include "jal_file.h"
#endif
#include "jal_prnt.h"

/* format:
 *   print {"string" | 'c' | expr} [, ...]
 * an external variable, `_print_base,' determines
 * the base of the result.
 * also, an external procedure is required:
 *   procedure _chout(byte in ch)
 * this currently requires backend support  
 */   
void jal_parse_print(pfile_t *pf)
{
  UNUSED(pf);
}

