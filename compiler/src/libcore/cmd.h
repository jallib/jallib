/************************************************************
 **
 ** cmd.h : p-code structure handling declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ** $Log: cmd.h,v $
 ** Revision 1.33  2012/03/30 21:02:57  kyle
 ** Minor tweaks to improve debugging
 **
 ** Revision 1.32  2010-11-10 19:09:15  kyle
 ** * backed out all of the variable allocation changes
 ** * changed all enums to upper case
 ** * changed the various PIC optimizers to use a central
 **   core
 **
 ** Revision 1.29  2009-08-26 23:07:06  kyle
 ** cleanup splint warnings
 **
 ** Revision 1.28  2009-06-29 16:12:48  kyork
 ** Added variable interference generation, but have not integrated
 ** it with the variable allocator.
 **
 ** Revision 1.27  2009-02-25 23:01:06  kyork
 ** Finished _warn and _error
 **
 ** Revision 1.26  2009-02-25 16:37:52  kyork
 ** Initial _warn & _error work
 **
 ** Revision 1.25  2008-11-07 00:37:27  kyork
 ** More variable analysis work.
 **
 ** Revision 1.24  2008-11-06 17:56:41  kyork
 ** More work on variable liveness analysis
 **
 ** Revision 1.23  2008-11-04 00:29:56  kyork
 ** Beginning infrastructure for live variable analysis (take 2!)
 **
 ** Revision 1.22  2008-09-25 22:42:54  kyork
 ** *** empty log message ***
 **
 ** Revision 1.16.2.1.2.1  2008-09-10 18:40:57  kyork
 ** * added `pragam speed' and `pragma size'
 ** * ported some changes from jalv2.5
 **
 ** Revision 1.16.2.1  2008-03-14 19:04:38  kyork
 ** B00029: `forever loop end loop' hangs compiler.
 ** Added loop detection to `cmd_branch_true_dest_get'
 **
 ** Revision 1.16  2007-12-03 17:56:28  kyork
 ** Added the CMD_TYPE_COMMENT to allow comments to show up in the ASM file.
 **
 ** Revision 1.15  2007/02/26 20:55:29  kyork
 ** Finished the emulator (stage one) and added assert capabilities!
 **
 ** Revision 1.14  2006/09/27 16:56:54  kyork
 ** Trying to fix branch damage.
 **
 ** Revision 1.13.2.2  2006/09/18 16:31:03  kyork
 ** More assembler enhancement fixes
 **
 ** Revision 1.13.2.1  2006/09/16 00:07:15  kyork
 ** Started to add `db' to the acceptable asm list.
 **
 ** Revision 1.13  2006/07/29 14:51:37  kyork
 ** Fixed various MSVC warnings; update the README.txt file
 **
 ** Revision 1.12  2006/07/24 23:15:46  kyork
 ** Test
 **
 **
 ************************************************************/
#ifndef cmd_h__
#define cmd_h__

#include "../libutils/cache.h"
#include "label.h"
#include "labelmap.h"
#include "operator.h"
#include "value.h"
#include "vararray.h"
#define CMD_NONE ((cmd_t) 0)

typedef enum cmd_type_ {
  CMD_TYPE_NOP,           /* no operation             */
  CMD_TYPE_LABEL,         /* this holds a label       */
  CMD_TYPE_OPERATOR,      /* operator                 */
  CMD_TYPE_BRANCH,        /* control                  */
  CMD_TYPE_ASM,           /* inline assembly          */
  CMD_TYPE_END,           /* end of program           */
  CMD_TYPE_SLEEP,         /* sleep                    */
  CMD_TYPE_ISR_CLEANUP,
  CMD_TYPE_PROC_ENTER,    /* enter a procedure        */
  CMD_TYPE_PROC_LEAVE,    /* exit a procedure         */
  CMD_TYPE_BLOCK_START,   /* enter a block            */
  CMD_TYPE_BLOCK_END,     /* leave a block            */
  CMD_TYPE_STATEMENT_END, /* end-of-statement         */
  CMD_TYPE_USEC_DELAY,    /* delay (in usec)          */
  CMD_TYPE_ASSERT,        /* assert value != 0        */
  CMD_TYPE_COMMENT,
  CMD_TYPE_LOG            /* log a warning or error   */
} cmd_type_t;

typedef void  (*cmd_dump_t)(cmd_t cmd, FILE *dst);
typedef void  (*cmd_free_t)(cmd_t cmd);
typedef cmd_t (*cmd_dup_t)(const cmd_t cmd);
typedef void  (*cmd_label_remap_t)(cmd_t cmd, const label_map_t *map);
typedef void  (*cmd_variable_remap_t)(cmd_t cmd, const variable_map_t *map);
typedef void  (*cmd_value_remap_t)(cmd_t cmd, const value_map_t *map);
#define CMD_VARIABLE_ACCESS_FLAG_NONE    0x0000U /* no flags            */
#define CMD_VARIABLE_ACCESS_FLAG_READ    0x0001U /* variable is read    */
#define CMD_VARIABLE_ACCESS_FLAG_WRITTEN 0x0002U /* variable is written */
typedef flag_t (*cmd_variable_accessed_t)(const cmd_t cmd, variable_t val);
typedef flag_t (*cmd_value_accessed_t)(const cmd_t cmd, value_t val);
typedef void   (*cmd_assigned_used_set_t)(cmd_t cmd);
typedef enum cmd_successor_rc_ {
  CMD_SUCCESSOR_RC_MORE,   /* there are more successors    */
  CMD_SUCCESSOR_RC_DONE,   /* there are no more successors */
  CMD_SUCCESSOR_RC_IX_BAD  /* there is no successor at this index */
} cmd_successor_rc_t;

typedef cmd_successor_rc_t (*cmd_successor_get_t)(cmd_t cmd, size_t ix, 
  cmd_t *succ);

typedef struct {
  cmd_free_t              free_fn;
  cmd_dump_t              dump_fn;
  cmd_dup_t               dup_fn;
  cmd_label_remap_t       label_remap_fn;
  cmd_variable_remap_t    variable_remap_fn;
  cmd_value_remap_t       value_remap_fn;
  cmd_variable_accessed_t variable_accessed_fn;
  cmd_value_accessed_t    value_accessed_fn;
  cmd_assigned_used_set_t assigned_used_set_fn;
  cmd_successor_get_t     successor_get_fn;
} cmd_vtbl_t;

#define CMD_FLAG_INTERRUPT 0x0001 /* used at interrupt level */
#define CMD_FLAG_USER      0x0002 /* used at user level      */
#define CMD_FLAG_SPEED     0x0004 /* optimize for speed      */
cmd_t           cmd_alloc(cmd_type_t type, const cmd_vtbl_t *vtbl);
void            cmd_free(cmd_t cmd);
cmd_t           cmd_dup(const cmd_t cmd);
void            cmd_label_remap(cmd_t cmd, const label_map_t *map);
void            cmd_variable_remap(cmd_t cmd, const variable_map_t *map);
void            cmd_value_remap(cmd_t cmd, const value_map_t *map);
void            cmd_list_free(cmd_t cmd);

cmd_t           cmd_proc_alloc(cmd_type_t type, pfile_proc_t *proc);
cmd_t           cmd_label_alloc(label_t lbl);
cmd_t           cmd_assert_alloc(value_t val);
cmd_t           cmd_op_alloc(operator_t op, value_t dst, value_t val1,
                    value_t val2);

void            cmd_flag_set(cmd_t cmd, flag_t flag);
boolean_t       cmd_flag_test(const cmd_t cmd, flag_t flag);
void            cmd_flag_clr(cmd_t cmd, flag_t flag);
void            cmd_flag_set_all(cmd_t cmd, flag_t flags);
flag_t          cmd_flag_get_all(cmd_t cmd);

/* common operations */
void            cmd_dump(cmd_t cmd, FILE *dst);
void            cmd_free(cmd_t cmd);

cmd_t           cmd_link_get(const cmd_t cmd);
void            cmd_link_set(cmd_t cmd, cmd_t lnk);

cmd_t           cmd_prev_get(const cmd_t cmd);
void            cmd_prev_set(cmd_t cmd, cmd_t prev);

cmd_type_t      cmd_type_get(const cmd_t cmd);
void            cmd_type_set(cmd_t cmd, cmd_type_t type);

unsigned        cmd_opt_get(const cmd_t cmd);
void            cmd_opt_set(cmd_t cmd, unsigned opt);

unsigned        cmd_line_get(const cmd_t cmd);
void            cmd_line_set(cmd_t cmd, unsigned line);

pfile_source_t *cmd_source_get(const cmd_t cmd);
void            cmd_source_set(cmd_t cmd, pfile_source_t *src);

pfile_proc_t   *cmd_proc_get(const cmd_t cmd);
void            cmd_proc_set(cmd_t cmd, pfile_proc_t *proc);

label_t         cmd_label_get(const cmd_t cmd);
void            cmd_label_set(cmd_t cmd, label_t lbl);

value_t         cmd_assert_value_get(const cmd_t cmd);
void            cmd_assert_value_set(cmd_t cmd, value_t val);

boolean_t       cmd_is_executable(cmd_t cmd);
cmd_t           cmd_next_exec_get(cmd_t cmd);
void            cmd_remove(cmd_t *cmd_head, cmd_t cmd);
cmd_t           cmd_label_find(cmd_t cmd, const label_t lbl);

boolean_t       cmd_is_reachable(cmd_t cmd);

flag_t          cmd_variable_accessed_get(const cmd_t cmd, variable_t var);
flag_t          cmd_value_accessed_get(const cmd_t cmd, value_t val);

void              cmd_live_in_add(cmd_t cmd, variable_t var);
variable_array_t *cmd_live_in_get(cmd_t cmd);

void              cmd_live_out_add(cmd_t cmd, variable_t var);
variable_array_t *cmd_live_out_get(cmd_t cmd);

void              cmd_gen_add(cmd_t cmd, variable_t var);
variable_array_t *cmd_gen_get(cmd_t cmd);

void              cmd_kill_add(cmd_t cmd, variable_t var);
variable_array_t *cmd_kill_get(cmd_t cmd);

void cmd_variable_live_analyze(cmd_t head);
void cmd_variable_interference_generate(cmd_t head);
cmd_successor_rc_t cmd_successor_get(cmd_t cmd, size_t ix, cmd_t *dst);

void  cmd_pos_get(const cmd_t cmd, pfile_pos_t *pos);

ulong cmd_id_get(const cmd_t cmd);

#endif /* cmd_h__ */

