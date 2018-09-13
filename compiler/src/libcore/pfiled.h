/************************************************************
 **
 ** pfiled.h : pfile definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pfiled_h__
#define pfiled_h__

#include "pfile.h"

#define PFILE_MULTIPLY_PAIR_MAX 16

struct pfile_ {
  flag_t          flags;
  pfile_source_t *src;
  FILE           *f_asm;          /* asm output  */
  FILE           *f_lst;          /* list output */
  FILE           *f_hex;          /* hex output  */
  FILE           *f_log;          /* log output  */
  ulong           loader_offset;  /* offset for loader18 */

  const char      *COD_name;
  COD_directory_t *COD_dir;

  unsigned        errct;          /* # of errors found                   */
  unsigned        warnct;         /* # of warnings found                 */

  pfile_pos_t     statement_start;

  unsigned        codegen_disable;/* non-zero to block code generation   */
                                  /* this is needed by JAL because the   */
                                  /* IF statement is used as both IF and */
                                  /* a preprocessor statement            */

  cmd_t           cmd_head;       /* list of commands          */
  cmd_t           cmd_tail;
  cmd_t           cmd_cursor;     /* where to put the next command
                                     (or CMD_NONE to append)   */

  varlist_t       var_const;      /* unnamed constants         */

  unsigned        label_temp_ct;  /* next temp. id             */
  lbllist_t       label_temp;     /* temporary labels          */
  label_t         label_temp_ptr; /* pointer to next avail.
                                     temp. label               */
  label_t         label_main;         /* entry point to the program       */
  label_t         label_isr;          /* entry point to the program's isr */
  label_t         label_isr_preamble; /* entry to the isr preamble        */
  /* the following are for hex out */
  struct {
    unsigned      pc_msw;         /* PC most signficant word     */
    unsigned      pc;             /* PC at the start of the line */
    unsigned      ct;             /* # of bytes in the buffer    */
    unsigned char buf[16];        /* data buffer                 */
  } hex;

  pfile_proc_t   *proc_root;      /* root of the procedure tree */
  pfile_proc_t   *proc_active;    /* the active procedure       */

  /* each language must provide its own token parsing routines,
   * but all of the other functions can be handled in pfile */
  size_t          token_len;
  char            token[PFILE_TOKEN_SZ_MAX + 1];
  pfile_pos_t     token_start;

  pfile_vectors_t *vectors;
  void            *vector_arg;

  char            *include_path;
  variable_def_t   unnamed_vdefs;

  tag_t            tag_list;
  pfile_source_t  *src_list;
  pfile_stats_t    stats;
  pfile_token_ct_t token_ct;

  unsigned         task_ct; /* # of concurrent tasks */
  label_t          exit_label; /* exit label for breaking out of loops */

  /*
   * track the number of different multiply routines needed.
   * the widths are in bytes. multiplier <= multiplicand
   * (since multiplication is ...)
   *   some back-ends can use this information to, for example,
   * inline multiplications that are only used once, or create
   * different versions for speed
   */
  pfile_multiply_width_table_entry_t multiply_widths[PFILE_MULTIPLY_PAIR_MAX];
  unsigned multiply_ct;
};

#endif /* pfiled_h__ */

