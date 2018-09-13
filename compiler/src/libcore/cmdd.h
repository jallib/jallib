/************************************************************
 **
 ** cmdd.h : p-code structure handling declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef cmdd_h__
#define cmdd_h__

#include "pf_src.h"
#include "pf_proc.h"
#include "vararray.h"
#include "cmd.h"
#include "cmd_brdc.h"
#include "cmd_opdc.h"
#include "cmd_asmd.h"

struct cmd_ {
  cmd_t             link;
  cmd_t             prev;        /* predecessor       */
  flag_t            flags;
  pfile_pos_t       pos;         /* file & line       */
  cmd_type_t        type;        /* type of command   */
  ulong             serial_no;   /* serial # (for debugging) */
  unsigned          opt;         /* used by the optimizer currently to
                                    detect loops */
  const cmd_vtbl_t *vtbl;
  union {
    label_t          label;      /* line label        */
    cmd_branch_t     br;
    cmd_op_t         op;
    cmd_asm_t        op_asm;     /* inline assembly   */
    pfile_proc_t    *proc;       /* for {enter,leave} */
    variable_const_t usec_delay; /* usec_delay        */
    /*unsigned         raw;*/        /* raw data          */
    value_t          val;
    struct {
      pfile_log_t    type;       /* how to log        */
      char          *str;        /* what to log       */
    } log;
  } u;
  variable_array_t  *live_in;
  variable_array_t  *live_out;
  variable_array_t  *var_gen;
  variable_array_t  *var_kill;
};

struct cmd_ *cmd_element_seek(cmd_t cmd, boolean_t mod);
/* when remapping a value or variable, we need to track if it's an
 * assignment or a use. */
#define CMD_ACCESS_FLAG_NONE   0x0000
#define CMD_ACCESS_FLAG_ASSIGN 0x0001
#define CMD_ACCESS_FLAG_USE    0x0002
void cmd_variable_remap2(cmd_t cmd, const variable_map_t *map,
    value_t (*cmd_val_get)(const cmd_t cmd), 
    void (*cmd_avalset)(cmd_t cmd, value_t n));
void cmd_value_remap2(cmd_t cmd, const value_map_t *map,
    value_t (*cmd_val_get)(const cmd_t cmd), 
    void (*cmd_val_set)(cmd_t cmd, value_t n));
void cmd_label_remap2(cmd_t cmd, const label_map_t *map,
    label_t (*cmd_lbl_get)(const cmd_t cmd),
    void (*cmd_lbl_set)(cmd_t cmd, label_t lbl));

#endif /* cmdd_h__ */

