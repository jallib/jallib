/************************************************************
 **
 ** pfile.h : pfile API declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pfile_h__
#define pfile_h__


#include <stdio.h>
#include "../libutils/cod_file.h"
#include "univ.h"
#include "pf_src.h"
#include "pf_token.h"

#define PFILE_TOKEN_SZ_MAX 1023

#define PFILE_TMP_VARNAME       "_temp"
#define PFILE_BTMP_VARNAME      "_btemp"
#define PFILE_BITBUCKET_VARNAME "_bitbucket"

#define PFILE_FLAG_NONE                0x00000000UL
/* use Rick Farmer's PIC loader */
#define PFILE_FLAG_BOOT_RICK           0x00000001UL
/* don't put out the fuses line */
#define PFILE_FLAG_BOOT_FUSES          0x00000002UL
/* force the first instruction to be a long jump to the program start */
#define PFILE_FLAG_BOOT_LONG_START     0x00000004UL

/* clear user variables on entry */
#define PFILE_FLAG_MISC_CLEAR_BSS      0x00000008UL
/* don't save/restore _pic_state in ISR preamble */
#define PFILE_FLAG_MISC_INTERRUPT_FAST 0x00000010UL
/* no ISR preamble */
#define PFILE_FLAG_MISC_INTERRUPT_RAW  0x00000020UL
/* don't show status */
#define PFILE_FLAG_MISC_QUIET          0x00000040UL

/* debugging */
#define PFILE_FLAG_DEBUG_COMPILER      0x00000080UL
/* show pcode in assembly */
#define PFILE_FLAG_DEBUG_PCODE         0x00000100UL
/* generate backend code */
#define PFILE_FLAG_DEBUG_CODEGEN       0x00000200UL

#define PFILE_FLAG_OPT_EXPR_REDUCTION  0x00000400UL
#define PFILE_FLAG_OPT_CEXPR_REDUCTION 0x00000800UL
/* allow temporary reduction */
#define PFILE_FLAG_OPT_TEMP_REDUCE     0x00001000UL
/* allow constant detection  */
#define PFILE_FLAG_OPT_CONST_DETECT    0x00002000UL
 /* remove variables that are assigned but never used, 
  * or used but never assigned */
#define PFILE_FLAG_OPT_VARIABLE_REDUCE 0x00004000UL
 /* remove redundant assigned & loads (aka, track W) */
#define PFILE_FLAG_OPT_LOAD_REDUCE     0x00008000UL

/* allow code generation warnings */
#define PFILE_FLAG_WARN_BACKEND        0x00010000UL
/* warn on sign/unsigned conversion */
#define PFILE_FLAG_WARN_CONVERSION     0x00020000UL
/* show compiler directives */
#define PFILE_FLAG_WARN_DIRECTIVES     0x00040000UL
/* misc. warnings */
#define PFILE_FLAG_WARN_MISC           0x00080000UL
/* warn on range check errors */
#define PFILE_FLAG_WARN_RANGE          0x00100000UL
/* stack overflow is a warning, not an error */
#define PFILE_FLAG_WARN_STACK_OVERFLOW 0x00200000UL
/* warn on truncation during assignment */
#define PFILE_FLAG_WARN_TRUNCATE       0x00400000UL
/* another bootloader option -- preamble is:
 * goto start ; org 4 ... */
#define PFILE_FLAG_BOOT_BLOADER        0x00800000UL
/* re-use variable space */
#define PFILE_FLAG_OPT_VARIABLE_REUSE  0x01000000UL
/* allocate full frames instead of individual variables */
#define PFILE_FLAG_OPT_VARIABLE_FRAME  0x02000000UL
/* run the emulator */
#define PFILE_FLAG_DEBUG_EMULATOR      0x04000000UL
/* turn off dead-code removal */
#define PFILE_FLAG_DEBUG_DEADCODE      0x08000000UL
/* for 18 series, start code at 0x800, isr at 0x808 */
#define PFILE_FLAG_BOOT_LOADER18       0x10000000UL
/* optimize commands for speed (default = size) */
#define PFILE_FLAG_CMD_SPEED           0x20000000UL
/* use the new expression simplifier */
#define PFILE_FLAG_OPT_EXPR_SIMPLIFY   0x40000000UL
/* use fast multiplies */
#define PFILE_FLAG_MISC_FASTMATH       0x80000000UL

#define PFILE_FLAG_WARN_ALL           \
  ( PFILE_FLAG_WARN_BACKEND           \
    | PFILE_FLAG_WARN_CONVERSION      \
    | PFILE_FLAG_WARN_DIRECTIVES      \
    | PFILE_FLAG_WARN_MISC            \
    | PFILE_FLAG_WARN_RANGE           \
    | PFILE_FLAG_WARN_STACK_OVERFLOW  \
    | PFILE_FLAG_WARN_TRUNCATE )
 

typedef struct pfile_stats_ {
  unsigned long chars;
  unsigned long lines;
  unsigned long files;
} pfile_stats_t;

/* front-end callbacks */
typedef result_t (*pf_open_fn_t)(pfile_t *pf);
typedef void     (*pf_close_fn_t)(pfile_t *pf);
typedef void     (*pf_include_fn_t)(pfile_t *pf);
typedef const char *(*pf_token_get_fn_t)(pfile_t *pf, pf_token_get_t which);
typedef variable_def_t (*pf_expr_result_def_get_t)(pfile_t *pf,
    operator_t op, value_t val1, value_t val2);
/* back-end callbacks */
typedef void     (*pf_cmd_pre_generate_t)(pfile_t *pf, cmd_t *cmd_head);
typedef void     (*pf_cmd_generate_t)(pfile_t *pf, const cmd_t cmd_head);
typedef void     (*pf_cmd_dump_t)(pfile_t *pf, const cmd_t cmd, 
    boolean_t is_first);
typedef void     (*pf_cmd_cleanup_t)(pfile_t *pf);
typedef void     (*pf_cmd_emu_t)(pfile_t *pf);
typedef variable_sz_t (*pf_pointer_size_get_t)(pfile_t *pf);

typedef struct {
  /* front-end functions */
  pf_open_fn_t             pf_open_fn;
  pf_close_fn_t            pf_close_fn;
  pf_token_get_fn_t        pf_token_get_fn;
  pf_include_fn_t          pf_include_fn;
  pf_expr_result_def_get_t pf_expr_result_def_get_fn;
  /* back-end functions */
  pf_cmd_pre_generate_t    pf_cmd_pre_generate;
  pf_cmd_generate_t        pf_cmd_generate;
  pf_cmd_dump_t            pf_cmd_dump;
  pf_cmd_cleanup_t         pf_cmd_cleanup;
  pf_cmd_emu_t             pf_cmd_emu;
  pf_pointer_size_get_t    pf_pointer_size_get;
} pfile_vectors_t;

#define PFILE_LENGTH_DEF ((size_t) -1)
result_t pfile_open(pfile_t **dst, FILE *f_asm, FILE *f_lst,
    FILE *f_hex, FILE *f_log, const char *COD_name, flag_t flags,
    pfile_vectors_t *vectors, void *arg, unsigned task_ct,
    const char *compiler);
void pfile_close(pfile_t *pf);

FILE *pfile_asm_file_set(pfile_t *pf, FILE *f_asm);
FILE *pfile_hex_file_set(pfile_t *pf, FILE *f_hex);

void  pfile_loader_offset_set(pfile_t *pf, ulong offset);
ulong pfile_loader_offset_get(pfile_t *pf);

void pfile_task_ct_set(pfile_t *pf, unsigned task_ct);

int pfile_ch_get(pfile_t *pf);
void pfile_ch_unget(pfile_t *pf, int ch);

/* unnamed constant manipulation */
value_t pfile_constant_float_get(pfile_t *pf, float n,
    variable_def_t def);
value_t pfile_constant_get(pfile_t *pf, variable_const_t n,
    variable_def_t def);

/* value manipulation */
value_t pfile_value_temp_get(pfile_t *pf, variable_def_type_t type, 
    variable_sz_t sz);
value_t pfile_value_temp_get_from_def(pfile_t *pf, variable_def_t def);
result_t pfile_value_alloc(pfile_t *pf, pfile_variable_alloc_t which,
    const char *name, variable_def_t def, value_t *dst);
value_t pfile_value_find(pfile_t *pf, pfile_log_t plog, const char *name);
value_t pfile_string_find(pfile_t *pf, size_t sz, const char *str);

/* variable manipulation */
result_t pfile_variable_alloc(pfile_t *pf, pfile_variable_alloc_t which,
    const char *name, variable_def_t def, variable_t master, variable_t *dst);
result_t       pfile_variable_def_add(pfile_t *pf, variable_def_t def);
variable_def_t pfile_variable_def_find(pfile_t *pf, pfile_log_t plog,
  const char *name);
struct pfile_block_;
variable_t pfile_variable_find(pfile_t *pf, pfile_log_t plog,
  const char *name, struct pfile_block_ **blk);
void pfile_variable_fixup(pfile_t *pf, flag_t flags);
void pfile_variable_dump(pfile_t *pf);
void pfile_write_hex(pfile_t *pf, ulong pc, unsigned char data);

/* label manipulation */
label_t pfile_label_alloc(pfile_t *pf, const char *name);
label_t pfile_label_find(pfile_t *pf, pfile_log_t plog, const char *name);
void pfile_label_dump(pfile_t *pf);
void pfile_label_fixup(pfile_t *pf);

/* misc bits */
label_t pfile_lblptr_get(pfile_t *pf);
void     pfile_lblptr_set(pfile_t *pf, label_t lbl);
void     pfile_rewind(pfile_t *pf);
unsigned pfile_errct_get(const pfile_t *pf);
unsigned pfile_warnct_get(const pfile_t *pf);
unsigned pfile_line_get(const pfile_t *pf);

void pfile_isr_preamble(pfile_t *pf);

void     pfile_user_entry_set(pfile_t *pf, label_t lbl);
label_t  pfile_user_entry_get(pfile_t *pf);
void     pfile_isr_entry_set(pfile_t *pf, label_t lbl);
label_t  pfile_isr_entry_get(pfile_t *pf);

label_t  pfile_isr_preamble_entry_get(pfile_t *pf);

typedef enum pfile_write_ {
  pfile_write_asm, /* out the the `.asm' file */
  pfile_write_lst  /* out to the `.lst' file  */
} pfile_write_t;

int pfile_write(pfile_t *pf, pfile_write_t dst, const char *fmt, ...);

boolean_t pfile_flag_test(const pfile_t *pf, flag_t flag);
void      pfile_flag_set(pfile_t *pf, flag_t flag);
void      pfile_flag_clr(pfile_t *pf, flag_t flag);
flag_t    pfile_flag_get_all(const pfile_t *pf);
/* flags = (flags & mask) | set */
void      pfile_flag_change(pfile_t *pf, flag_t mask, flag_t set);

pfile_source_t       *pfile_source_get(const pfile_t *pf);
void                  pfile_source_restore(pfile_t *pf, pfile_source_t *src);
result_t              pfile_source_set(pfile_t *pf, const char *fname);
pfile_source_t       *pfile_source_list_head_get(pfile_t *pf);

/* create a new procedure */
pfile_proc_t *pfile_proc_create(pfile_t *pf, const char *tag, variable_def_t def);
/* enter a procedure */
result_t pfile_proc_enter(pfile_t *pf, const char *tag);
/* leave an existing procedure */
result_t pfile_proc_leave(pfile_t *pf);

result_t pfile_block_enter(pfile_t *pf);
result_t pfile_block_leave(pfile_t *pf);

pfile_proc_t *pfile_proc_find(pfile_t *pf, pfile_log_t plog, const char *tag);

pfile_proc_t *pfile_proc_active_get(const pfile_t *pf);
void          pfile_proc_active_set(pfile_t *pf, pfile_proc_t *proc);
pfile_proc_t *pfile_proc_root_get(const pfile_t *pf);

const char *pfile_include_path_get(pfile_t *pf);
result_t    pfile_include_path_set(pfile_t *pf, const char *inc_path);

void       *pfile_vector_arg_get(const pfile_t *pf);
void        pfile_vector_arg_set(pfile_t *pf, void *arg);

void        pfile_include_process(pfile_t *pf, size_t fname_sz,
  const char *fname);

void        pfile_codegen_disable(pfile_t *pf, boolean_t disable);
boolean_t   pfile_codegen_disable_get(const pfile_t *pf);

void        pfile_pos_get(pfile_t *pf, pfile_pos_t *pos);
void        pfile_statement_start_set(pfile_t *pf, const pfile_pos_t *pos);
void        pfile_statement_start_get(pfile_t *pf, pfile_pos_t *dst);

void        pfile_token_start_get(pfile_t *pf, pfile_pos_t *dst);
void        pfile_token_start_set(pfile_t *pf, const pfile_pos_t *src);

tag_t       pfile_tag_alloc(pfile_t *pf, const char *name);

void pfile_token_get_fn_set(pfile_t *pf, pf_token_get_fn_t fn, void *arg);

void pfile_stats_get(pfile_t *pf, pfile_stats_t *stats);

typedef unsigned long pfile_token_ct_t;
pfile_token_ct_t pfile_token_ct_get(pfile_t *pf);

void pfile_cmd_cursor_set(pfile_t *pf, cmd_t cmd);

label_t pfile_label_temp_head_get(pfile_t *pf);

unsigned pfile_task_ct_get(pfile_t *pf);

COD_directory_t *pfile_COD_dir_get(pfile_t *pf);

variable_sz_t pfile_pointer_size_get(pfile_t *pf);

label_t pfile_exit_label_get(const pfile_t *pf);
label_t pfile_exit_label_set(pfile_t *pf, label_t lbl);

typedef struct pfile_multiply_width_table_entry_ {
  unsigned use_ct;        /* # of times this is used   */
  unsigned multiplier;    /* width of the multiplier   */
  unsigned multiplicand;  /* width of the multiplicand */
} pfile_multiply_width_table_entry_t;

const pfile_multiply_width_table_entry_t *
    pfile_multiply_width_table_entry_get(pfile_t *pf, size_t ii);

#if defined (MSDOS) && !defined (__WATCOMC__)
#include "pfiled.h"
#endif

#endif /* pfile_h__ */

