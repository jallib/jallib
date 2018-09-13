/************************************************************
 **
 ** jal_main.c : JAL main file
 **
 ** Copyright (c) 2005-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <errno.h>
#include "../libutils/mem.h"
#include "../libcore/pf_msg.h"
#include "../libcore/pf_expr.h"
#include "../libcore/pf_cmd.h"
#include "../libpic12/pic_cmdo.h"
#include "../libpic12/pic.h"
#include "jal_blck.h"
#include "jal_file.h"
#include "jal_tokn.h"
#include "jal_build.h"

#if defined (MSDOS) && !defined (__WATCOMC__)
extern unsigned _stklen = 16384;
#endif

#define JAL_VERSION            2004   /* major * 1000 + minor */
#define JAL_MSG_COMPDATE       "jal "JAL_VERSION_STR" (compiled %s)"
#define JAL_VERSION_CONST_NAME "jal_version"
#define JAL_BUILD_CONST_NAME   "jal_build"


/* format: 
 *   picjal file 
 *     -hex name : set the name of the hex  file, default is file.hex
 *     -asm name : set the name of the assembly file, default is file.asm
 */     

typedef enum {
  opt_none,
  /* --- file operations --- */
  opt_file_asm,
  opt_file_cod,
  opt_file_hex,
  opt_file_include_path,
  opt_file_include,
  opt_file_lst,
  opt_file_log,
  opt_file_jal,
  /* --- bootloader options --- */
  opt_boot_bloader,
  opt_boot_fuse,
  opt_boot_long_start,
  opt_boot_rickpic,
  opt_boot_loader18,
  /* --- misc. options --- */
  opt_misc_clear_bss,
  opt_misc_quiet,
  opt_misc_task,
  opt_misc_fastmath,
  /* --- warnings --- */
  opt_warn_all,
  opt_warn_backend,
  opt_warn_conversion,
  opt_warn_directives,
  opt_warn_misc,
  opt_warn_range,
  opt_warn_stack_overflow,
  opt_warn_truncate,
  /* --- optimizations --- */
  opt_opt_cexpr_reduction,
  opt_opt_const_detect,
  opt_opt_expr_reduction,
  opt_opt_load_reduce,
  opt_opt_temp_reduce,
  opt_opt_variable_reduce,
  opt_opt_variable_reuse,
  opt_opt_variable_frame,
  opt_opt_expr_simplify,
  /* --- compiler debugging --- */
  opt_debug_debug,
  opt_debug_pcode,
  opt_debug_codegen,
  opt_debug_emu,
  opt_debug_deadcode
} opt_t;

#define OPT_FLAG_NONE        0x0000 /* no flags                        */
#define OPT_FLAG_PARAM       0x0001 /* requires a parameter            */
#define OPT_FLAG_NO_PREFIX   0x0002 /* allow "no-" prefix              */
#define OPT_FLAG_WARN        0x0004 /* this starts '-W'                */
#define OPT_FLAG_PFLAG       0x0008 /* twiddle a pflag                 */
typedef struct {
  opt_t       opt;
  const char *key;
  const char *descr;
  unsigned    opt_flags;  /* OPT_FLAG_* (see above) */
  flag_t      pfile_flag; /* flag to twiddle        */
} opt_def_t;

static const opt_def_t opt_defs[] = {
  {opt_none, 0, "--- File Options ---", OPT_FLAG_NONE, PFILE_FLAG_NONE},
  {opt_file_asm, "asm",
      "set the name of the asm file (default is basename + '.asm')", 
      OPT_FLAG_PARAM | OPT_FLAG_NO_PREFIX, PFILE_FLAG_NONE},
  {opt_file_cod, "codfile",
      "set the name of the COD file (default is basename + '.cod')",
      OPT_FLAG_PARAM | OPT_FLAG_NO_PREFIX, PFILE_FLAG_NONE},
  {opt_file_hex, "hex",
      "set the name of the hex file (default is basename + '.hex')", 
      OPT_FLAG_PARAM | OPT_FLAG_NO_PREFIX, PFILE_FLAG_NONE},
  {opt_file_include, "include",
      "include {name} before parsing the file", 
      OPT_FLAG_PARAM, PFILE_FLAG_NONE},
  {opt_file_lst, "lst",
      "set the name of the lst file (default is no file created)",
      OPT_FLAG_PARAM | OPT_FLAG_NO_PREFIX, PFILE_FLAG_NONE},
  {opt_file_log, "log",
      "set the name of the log file (default is no file created)",
      OPT_FLAG_PARAM | OPT_FLAG_NO_PREFIX, PFILE_FLAG_NONE},
  {opt_file_include_path, "s",
      "set the include path, elements seperated with ';'", 
      OPT_FLAG_PARAM, PFILE_FLAG_NONE},

  {opt_none, 0, "--- Bootloader Options ---", OPT_FLAG_NONE, PFILE_FLAG_NONE},
  {opt_boot_bloader, "bloader",
      "using screamer/bloader PIC loader", 
      OPT_FLAG_PFLAG, PFILE_FLAG_BOOT_BLOADER},
  {opt_boot_fuse, "fuse",
      "do not put FUSES into the assembly or hex file",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_BOOT_FUSES},
  {opt_boot_long_start, "long-start",
      "force the first instruction to be a long jump",
      OPT_FLAG_PFLAG, PFILE_FLAG_BOOT_LONG_START},
  {opt_boot_rickpic, "rickpic",
      "using Rick Farmer's PIC loader", 
      OPT_FLAG_PFLAG, PFILE_FLAG_BOOT_RICK},
  {opt_boot_loader18, "loader18",
      "Use the 18 series bootloader preamble",
      OPT_FLAG_PFLAG | OPT_FLAG_PARAM, PFILE_FLAG_BOOT_LOADER18},
  {opt_none, 0, "--- Misc. Options ---", OPT_FLAG_NONE, PFILE_FLAG_NONE},
  {opt_misc_clear_bss, "clear", 
      "clear data area on program entry",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_MISC_CLEAR_BSS},
  {opt_misc_quiet, "quiet",
      "disable/enable compile status updates", 
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_MISC_QUIET},
  {opt_misc_task, "task",
      "set the maximum # of concurrent tasks", 
      OPT_FLAG_PARAM, PFILE_FLAG_NONE},
  {opt_misc_fastmath, "fastmath",
      "use fast math",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_MISC_FASTMATH},

  {opt_none, 0, "--- Warnings ---", OPT_FLAG_NONE, PFILE_FLAG_NONE},
  {opt_warn_all, "all",
      "enable/disable all warnings",
      OPT_FLAG_WARN | OPT_FLAG_PFLAG | OPT_FLAG_NO_PREFIX, 
      PFILE_FLAG_WARN_ALL},
  {opt_warn_backend, "codegen",
      "enable/disable code generation warnings",
      OPT_FLAG_WARN | OPT_FLAG_PFLAG | OPT_FLAG_NO_PREFIX,
      PFILE_FLAG_WARN_BACKEND},
  {opt_warn_conversion, "conversion",
      "enable/disable signed/unsigned conversion warning", 
      OPT_FLAG_WARN | OPT_FLAG_PFLAG | OPT_FLAG_NO_PREFIX, 
      PFILE_FLAG_WARN_CONVERSION},
  {opt_warn_directives, "directives",
      "enable/disable warning when a compiler directive is found", 
      OPT_FLAG_WARN | OPT_FLAG_PFLAG | OPT_FLAG_NO_PREFIX, 
      PFILE_FLAG_WARN_DIRECTIVES},
  {opt_warn_misc, "misc",
      "enable/disable uncategorized warnings",
      OPT_FLAG_WARN | OPT_FLAG_PFLAG | OPT_FLAG_NO_PREFIX, 
      PFILE_FLAG_WARN_MISC},
  {opt_warn_range, "range",
      "enable/disable value out of range warnings",
      OPT_FLAG_WARN | OPT_FLAG_PFLAG | OPT_FLAG_NO_PREFIX, 
      PFILE_FLAG_WARN_RANGE},
  {opt_warn_stack_overflow, "stack-overflow",
      "issue a warning on hardware stack overflow instead of an error",
      OPT_FLAG_WARN | OPT_FLAG_PFLAG | OPT_FLAG_NO_PREFIX, 
      PFILE_FLAG_WARN_STACK_OVERFLOW},
  {opt_warn_truncate, "truncate",
      "enable/disable possible truncation in assignment warning", 
      OPT_FLAG_WARN | OPT_FLAG_PFLAG | OPT_FLAG_NO_PREFIX, 
      PFILE_FLAG_WARN_TRUNCATE},

  {opt_none, 0, "--- Optimizations ---", OPT_FLAG_NONE, PFILE_FLAG_NONE},
  {opt_opt_cexpr_reduction, "cexpr-reduction",
      "enable/disable constant expression reduction", 
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_OPT_CEXPR_REDUCTION},
  {opt_opt_const_detect, "const-detect",
      "enable/disable constant detection",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_OPT_CONST_DETECT},
  {opt_opt_expr_reduction, "expr-reduction",
      "enable/disable expression reduction", 
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_OPT_EXPR_REDUCTION},
  {opt_opt_expr_simplify, "expr-simplify",
      "enable/disable expression simplification",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_OPT_EXPR_SIMPLIFY},
  {opt_opt_load_reduce, "load-reduce",
      "enable/disable redundant load removal",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_OPT_LOAD_REDUCE},
  {opt_opt_temp_reduce, "temp-reduce",
      "enable/disable temporary reduction",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_OPT_TEMP_REDUCE},
  {opt_opt_variable_frame, "variable-frame",
      "allocate variables into a full frame",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_OPT_VARIABLE_FRAME},
  {opt_opt_variable_reduce, "variable-reduce",
      "enable/disable unused or unassigned variables removal",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_OPT_VARIABLE_REDUCE},
  {opt_opt_variable_reuse, "variable-reuse",
      "enable/disable reusing variable space",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_OPT_VARIABLE_REUSE},

  {opt_none, 0, "--- Compiler Debugging ---", OPT_FLAG_NONE, PFILE_FLAG_NONE},
  {opt_debug_codegen, "codegen",
      "do not generate any assembly code", 
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_DEBUG_CODEGEN},
  {opt_debug_debug, "debug",
      "show debug information", 
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_DEBUG_COMPILER},
  {opt_debug_pcode, "pcode",
      "show pcode in the asm file",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_DEBUG_PCODE},
  {opt_debug_emu, "emu",
      "run the emulator",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_DEBUG_EMULATOR},
  {opt_debug_deadcode, "deadcode",
      "enable dead code elimination",
      OPT_FLAG_NO_PREFIX | OPT_FLAG_PFLAG, PFILE_FLAG_DEBUG_DEADCODE}
};

static int file_open(FILE **dst, const char *name, const char *mode,
    const char *ext, size_t base_sz, char *namebuf)
{
  FILE *f;
  int   rc;

  if (!name && ext) {
    strcpy(namebuf + base_sz, ext);
    name = namebuf;
  }
  if (!name) {
    *dst = 0;
    rc   = 0;
  } else {
    f = fopen(name, mode);
    if (0 == f) {
      fprintf(stderr, "Cannot open: %s (%s)\n", name, strerror(errno));
      rc = 1;
    } else {
      *dst = f;
      rc = 0;
    }
  }
  return rc;
}

static void file_remove(const char *name, const char *ext,
    size_t base_sz, char *namebuf)
{
  if (!name) {
    strcpy(namebuf + base_sz, ext);
    name = namebuf;
  }
  remove(name);
}

static void jal_include_process(pfile_t *pf)
{
  /* let's make sure the file hasn't already been included. This
   * needs to be done here, not in pfile, because languages like
   * C allow a file to be included multiple times */
  pfile_source_t *src;
  pfile_source_t *src_link;

  src = pfile_source_list_head_get(pf);
  for (src_link = pfile_source_link_get(src);
       src_link;
       src_link = pfile_source_link_get(src_link)) {
    if (!strcmp(pfile_source_name_get(src), 
          pfile_source_name_get(src_link))) {
      pfile_log(pf, PFILE_LOG_DEBUG, "blocking source: %s", 
          pfile_source_name_get(src));
      pf_token_set(pf, "");
      break;
    }
  }
  if (!src_link) {
    pfile_pos_t pos;
    
    pf_token_get(pf, PF_TOKEN_FIRST);
    pf_token_start_get(pf, &pos);
    pfile_statement_start_set(pf, &pos);
    jal_block_process(pf, JAL_BLOCK_PROCESS_FLAG_NO_BLOCK);
  }
}

/*
 * I'm not going to be nearly as restrictive as the real JAL,
 * the only real change is going to be the relationals always
 * return booleans!
 */ 
static variable_def_t jal_expr_result_def_get(pfile_t *pf, operator_t op,
    value_t val1, value_t val2)
{
  variable_def_t rdef;

  if (operator_is_relation(op)
      || (OPERATOR_NOTL == op)
      || (OPERATOR_LOGICAL == op)) {
    rdef = pfile_variable_def_find(pf, PFILE_LOG_ERR, "bit");
  } else if (VALUE_NONE == val1) {
    rdef = value_def_get(val2);
  } else if (VALUE_NONE == val2) {
    rdef = value_def_get(val1);
  } else if (value_is_single_bit(val1) 
      && value_is_single_bit(val2)
      && ((OPERATOR_ANDB == op)
        || (OPERATOR_ORB == op)
        || (OPERATOR_XORB == op)
        || (OPERATOR_ANDL == op)
        || (OPERATOR_ORL == op))) {
    /* this needs to be done in a bit */
    rdef = variable_def_alloc(0, VARIABLE_DEF_TYPE_BOOLEAN,
        VARIABLE_DEF_FLAG_BIT, 1);
  } else if (value_dflag_test(val1, VARIABLE_DEF_FLAG_UNIVERSAL)
      ^ value_dflag_test(val2, VARIABLE_DEF_FLAG_UNIVERSAL)) {
    /* they're not both universal, so the result is the *non*
     * universal one */
    rdef = value_def_get(
        value_dflag_test(val1, VARIABLE_DEF_FLAG_UNIVERSAL)
          ? val2
          : val1);
  } else {
    rdef = pfile_variable_def_promotion_get_default(pf, op, val1, val2);
  }
  return rdef;
}


static pfile_vectors_t vectors = {
  /* front-end vectors */
  jal_file_open,
  jal_file_close,
  jal_token_get,
  jal_include_process,
  jal_expr_result_def_get,
  /* back-end vectors */
  pic_cmd_optimize,
  pic_cmd_generate,
  pic_cmd_dump,
  pic_code_cleanup,
  pic_code_emu,
  pic_pointer_size_get
};

static void jal_show_format(const char *prog, flag_t def)
{
  size_t ii;

  printf("Usage: %s {options} filename\n\n"
         "Default options marked with '*'\n\n",
         prog);

  for (ii = 0; ii < COUNT(opt_defs); ii++) {
    if (opt_defs[ii].key) {
      char buf[3];
      const char *def_disable;
      const char *def_enable;

      def_disable = "";
      def_enable  = "";
      buf[0] = '-';
      buf[1] = 0;
      if (opt_defs[ii].opt_flags & OPT_FLAG_WARN) {
        buf[1] = 'W';
        buf[2] = 0;
      }
      if (opt_defs[ii].opt_flags & OPT_FLAG_PFLAG) {
        if ((def & opt_defs[ii].pfile_flag) == opt_defs[ii].pfile_flag) {
          def_disable = " ";
          def_enable  = "*";
        } else {
          def_disable = "*";
          def_enable  = " ";
        }
      }
      printf("%s%s%s\n", def_enable, buf, opt_defs[ii].key);
      if (opt_defs[ii].opt_flags & OPT_FLAG_NO_PREFIX) {
        printf("%s%sno-%s\n", def_disable, buf, opt_defs[ii].key);
      }
    }
    printf("    %s\n\n", opt_defs[ii].descr);
  }
}

static boolean_t opt_def_key_comp(const char *arg,
    boolean_t is_no, boolean_t is_warn, const opt_def_t *def)
{
  size_t arg_len;

  arg_len = strlen(arg);
  /* nb: the 2nd line below is a bit obtuse, here's the explanation:
   *     !!(def->opt_flags & OPT_FLAG_WARN)
   *       results in 1 if OPT_FLAG_WARN is set, 0 if not
   *     is_warn ^  !!(def->opt_flags & OPT_FLAG_WARN)
   *       results in 0 if either both are 0 or both are 1
   *     !(...)
   *       results in 1 if either both are 0 or both are 1
   *     in short, if is_warn is 0 skip all definitions with
   *     OPT_FLAG_WARN set, and if is_warn is 1 skip all definitions
   *     with OPT_FLAG_WARN clear
   */
  return (def->key
    && (!(!!is_warn ^ !!(def->opt_flags & OPT_FLAG_WARN)))
    && (!is_no || def->opt_flags & OPT_FLAG_NO_PREFIX)
    && (0 == memcmp(arg, def->key, arg_len)));
}

typedef struct cli_expanded_ {
  char  *data;
  size_t alloc;
  size_t used;
} cli_expanded_t;

int main(int argc, char **argv)
{
  FILE       *f_asm;
  FILE       *f_hex;
  FILE       *f_log;
  FILE       *f_lst;
  const char *hex_name;
  const char *asm_name;
  const char *cod_name;
  const char *lst_name;
  const char *log_name;
  const char *jal_name;
  const char *prog_name;
  flag_t      pfile_flags;
  flag_t      pfile_flags_def;
  char       *namebuf; /* for creating default names */
  pfile_t    *pf;
  boolean_t   err;
  char       *inc_path;
  char       *pre_include;
  unsigned    task_ct;
  int         arg_no;
  ulong       loader_offset;
  ulong       files_disabled;

  err            = BOOLEAN_FALSE;
  inc_path       = 0;
  pre_include    = 0;
  task_ct        = 0;
  arg_no         = 0;
  loader_offset  = 0;
  files_disabled = 0;

#ifdef MSDOS
  cos(1.0); /* silly, but it links in the math bits */
#endif

  setvbuf(stdout, 0, _IONBF, 0);
  if (argc) {
    prog_name = argv[arg_no];
    arg_no++;
  } else {
    prog_name = "jalv2";
  }
  f_asm    = 0;
  f_hex    = 0;

  hex_name = 0;
  asm_name = 0;
  jal_name = 0;
  cod_name = 0;
  lst_name = 0;
  log_name = 0;
  namebuf  = 0;
  pfile_flags_def = 
    PFILE_FLAG_WARN_ALL
    | PFILE_FLAG_OPT_EXPR_REDUCTION
    | PFILE_FLAG_OPT_CEXPR_REDUCTION
    | PFILE_FLAG_OPT_VARIABLE_REDUCE
    | PFILE_FLAG_OPT_VARIABLE_REUSE
    | PFILE_FLAG_BOOT_FUSES
    | PFILE_FLAG_DEBUG_CODEGEN
    | PFILE_FLAG_DEBUG_DEADCODE;
  pfile_flags_def &= ~PFILE_FLAG_WARN_DIRECTIVES;
  pfile_flags = pfile_flags_def;

  printf(JAL_MSG_COMPDATE"\n", __DATE__);

  if (arg_no == argc) {
    err = BOOLEAN_TRUE;
  } else {
    while (!err && (arg_no < argc)) {
      size_t           ii;
      const opt_def_t *def;
      const char      *arg;
      boolean_t        is_no;
      boolean_t        is_warn;
      opt_t            opt;

      arg     = argv[arg_no];
      is_no   = BOOLEAN_FALSE;
      is_warn = BOOLEAN_FALSE;
      opt     = opt_none;
      def     = 0;

      ii = 0;
      if ((0 == strcmp(arg, "--help"))
          || (0 == strcmp(arg, "/help"))
          || (0 == strcmp(arg, "/h"))
          || (0 == strcmp(arg, "/?"))) {
        jal_show_format(argv[0], pfile_flags_def);
        err = BOOLEAN_TRUE;
      } else if (0 == strcmp(arg, "--version")) {
        err = BOOLEAN_TRUE;
      } else if (arg[0] == '-') {
        /* this is an option */
        arg++;
        if (arg[0] == 'W') {
          /* this is a warning option */
          is_warn = BOOLEAN_TRUE;
          arg++;
        }
        if (memcmp(arg, "no-", 3) == 0) {
          /* a no prefix */
          is_no = BOOLEAN_TRUE;
          arg += 3;
        }
        for (ii = 0; !err && (ii < COUNT(opt_defs)); ii++) {
          if (opt_def_key_comp(arg, is_no, is_warn, opt_defs + ii)) {
            if (!def) {
              def = opt_defs + ii;
            } else {
              fprintf(stderr, "ambiguous argument: %s\n", argv[arg_no]);
              err = BOOLEAN_TRUE;
            }
          }
        }
        if (!def) {
          fprintf(stderr, "unknown option: %s\n", argv[arg_no]);
          err = BOOLEAN_TRUE;
        } else {
          opt = def->opt;
        }
        arg_no++;
      } else {
        opt = opt_file_jal;
      }

      if ((arg_no == argc) 
          && def
          && (def->opt_flags & OPT_FLAG_PARAM)
          && !is_no) {
        fprintf(stderr, "Required parameter to %s is missing!\n",
            def->key);
        err = BOOLEAN_TRUE;
      } else {
        const char **need;
        char       **need_append;

        need = 0;
        need_append = 0;
        switch (opt) {
          case opt_file_asm:          need        = &asm_name;    break;
          case opt_file_cod:          need        = &cod_name;    break;
          case opt_file_hex:          need        = &hex_name;    break;
          case opt_file_include:      need_append = &pre_include; break;
          case opt_file_include_path: need_append = &inc_path;    break;
          case opt_file_jal:          need        = &jal_name;    break;
          case opt_file_lst:          need        = &lst_name;    break;
          case opt_file_log:          need        = &log_name;    break;
          case opt_boot_rickpic:
             if (!is_no) {
               pfile_flags &= ~PFILE_FLAG_BOOT_FUSES;
             }
             break;
          case opt_boot_bloader:
          case opt_boot_fuse:
          case opt_boot_long_start:
          case opt_misc_clear_bss:
          case opt_misc_quiet:
          case opt_misc_fastmath:
          case opt_warn_conversion:
          case opt_warn_truncate:
          case opt_warn_all:
          case opt_warn_backend:
          case opt_warn_directives:
          case opt_warn_misc:
          case opt_warn_range:
          case opt_warn_stack_overflow:
          case opt_opt_expr_reduction:
          case opt_opt_cexpr_reduction:
          case opt_opt_temp_reduce:
          case opt_opt_const_detect:
          case opt_opt_variable_frame:
          case opt_opt_variable_reduce:
          case opt_opt_variable_reuse:
          case opt_opt_load_reduce:
          case opt_debug_debug:
          case opt_debug_pcode:
          case opt_debug_codegen: 
          case opt_debug_emu:
          case opt_debug_deadcode:
          case opt_opt_expr_simplify:
          case opt_none:
            break;
          case opt_misc_task:
            {
              char *eptr;

              task_ct = strtoul(argv[arg_no], &eptr, 10);
              arg_no++;
              if (*eptr) {
                fprintf(stderr, "number expected\n");
                err = BOOLEAN_TRUE;
              } else if (0 == task_ct) {
                fprintf(stderr, "task count must be > 0\n");
                err = BOOLEAN_TRUE;
              } 
            }
            break;
          case opt_boot_loader18:
            {
              char *eptr;

              if (argv[arg_no] && ISDIGIT(*argv[arg_no])) {
                loader_offset = strtoul(argv[arg_no], &eptr, 10);
                if (*eptr
                  || ((ULONG_MAX == loader_offset) && (ERANGE == errno))) {
                  fprintf(stderr, "Invalid loader18 value\n");
                  err = BOOLEAN_TRUE;
                } else {
                  arg_no++;
                }
              } else {
                loader_offset = 0x0800;
              }
            }
        }
        if (need) {
          if (*need) {
            const char *opt_name;

            if (!def) {
              opt_name = "source file";
            } else {
              opt_name = def->key;
            }
            if (is_no) {
              *need = 0;
              files_disabled |= (1 << opt);
            } else {
              fprintf(stderr, 
                  "%s previously defined (as \"%s\")\n", opt_name, *need);
              err = BOOLEAN_TRUE;
            }
          } else {
            if (is_no) {
              files_disabled |= (1 << opt);
            } else {
              *need = argv[arg_no];
              files_disabled &= ~(1 << opt);
            }
          }
          /*
           * the `no-' version requires no extra parameters
           */
          if (!is_no) {
            arg_no++;
          }
        } else if (need_append) {
          char  *tmp;
          size_t str_len;
          size_t argv_len;

          argv_len = strlen(argv[arg_no]) + 1; /* add 1 for the seperator */
          str_len  = (*need_append) ? strlen(*need_append) : 0;

          tmp = REALLOC(*need_append, str_len + argv_len + 1);
          if (!tmp) {
            fprintf(stderr, "out of memory?\n");
          } else {
            *need_append = tmp;
            if (str_len) {
              tmp[str_len] = ';';
              str_len++;
            }
            memcpy(tmp + str_len, argv[arg_no], argv_len);
          }
          arg_no++;
        }
        if (def && (def->opt_flags & OPT_FLAG_PFLAG)) {
          if (is_no) {
            pfile_flags &= ~def->pfile_flag;
          } else {
            pfile_flags |= def->pfile_flag;
          }
        }
      }
    }
  }
  if (!jal_name) {
    fprintf(stderr, "no source file, use %s --help for help\n",
        prog_name);
    err = BOOLEAN_TRUE;
  }
  if (err) {
    /*jal_show_format(argv[0], pfile_flags_def);*/
  } else {
    size_t sz;

    /* first, if jal_name includes a path, prepend it to inc_path */
    for (sz = strlen(jal_name);
         sz && (jal_name[sz-1] != '/') && (jal_name[sz-1] != '\\');
         sz--)
      ; /* empty body */
    if (sz > 1) {
      /* prepend jal_name[0..sz] to inc_path */
      sz--;
      if (!inc_path) {
        inc_path = MALLOC(sz + 1);
        memcpy(inc_path, jal_name, sz);
        inc_path[sz] = 0;
      } else {
        size_t inc_sz;
        char  *tmp;

        inc_sz = 1 + strlen(inc_path);
        tmp = REALLOC(inc_path, inc_sz + sz + 1);
        memmove(tmp + sz + 1, tmp, inc_sz);
        memcpy(tmp, jal_name, sz);
        tmp[sz] = ';';
        inc_path = tmp;
      }
    }
    sz = 0;
    if (!hex_name || !asm_name || !cod_name) {
      /* need to create a name buffer */
      for (sz = strlen(jal_name);
           sz 
           && ('.' != jal_name[sz-1]) 
           && ('/' != jal_name[sz-1])
           && ('\\' != jal_name[sz-1]);
           sz--)
        ; /* null body */
      if (!sz || ('.' != jal_name[sz-1])) {
        sz = strlen(jal_name);
      } else {
        sz--;
      }
      namebuf = MALLOC(sz + 5);
      if (!namebuf) {
        fprintf(stderr, "out of memory\n");
        err = 1;
      } else {
        memcpy(namebuf, jal_name, sz);
      }
    }
    if (!err
        && (0 == file_open(&f_asm, asm_name, "wt", 
          (files_disabled & (1 << opt_file_asm)) ? 0 : ".asm", sz, namebuf))
        && (0 == file_open(&f_hex, hex_name, "wt", 
          (files_disabled & (1 << opt_file_hex)) ? 0 : ".hex", sz, namebuf))
        && (0 == file_open(&f_lst, lst_name, "wt", 0,      sz, namebuf))
        && (0 == file_open(&f_log, log_name, "wt", 0,      sz, namebuf))) {
      result_t rc;

      if (!cod_name && !(files_disabled & (1 << opt_file_cod))) {
        strcpy(namebuf + sz, ".cod");
        cod_name = namebuf;
      }
      if (!(pfile_flags & PFILE_FLAG_DEBUG_DEADCODE)) {
        /* turning off dead code elimination implies PCODE */
        pfile_flags |= PFILE_FLAG_DEBUG_PCODE;
      }
      rc = pfile_open(&pf, f_asm, f_asm, f_hex, f_log,
        cod_name, pfile_flags, &vectors, 0, task_ct, "JAL "JAL_VERSION_STR);
      if (RESULT_OK == rc) {
        if (log_name) {
          pfile_log(pf, PFILE_LOG_INFO, JAL_MSG_COMPDATE, __DATE__);
        }
        rc = pfile_source_set(pf, jal_name);
        if (RESULT_OK == rc) {
          value_t        builtin;
          variable_def_t def;

          pfile_loader_offset_set(pf, loader_offset);
          def = variable_def_alloc(0, VARIABLE_DEF_TYPE_INTEGER, 
            VARIABLE_DEF_FLAG_CONST, 4);
          builtin = VALUE_NONE;
          pfile_value_alloc(pf, PFILE_VARIABLE_ALLOC_GLOBAL,
            JAL_VERSION_CONST_NAME, def, &builtin);
          value_const_set(builtin, JAL_VERSION);
          value_release(builtin);

          pfile_value_alloc(pf, PFILE_VARIABLE_ALLOC_GLOBAL,
            JAL_BUILD_CONST_NAME, def, &builtin);
          value_const_set(builtin, JAL_BUILD);
          value_release(builtin);

          pfile_include_path_set(pf, inc_path);
          jal_file_process(pf, pre_include);
          if (!pfile_errct_get(pf) 
              /*|| pfile_flag_test(pf, PFILE_FLAG_DEBUG)*/) {
            pfile_stats_t stats;
            char         *name_buf;

            pfile_stats_get(pf, &stats);
            pfile_log(pf, PFILE_LOG_INFO, 
              "%lu tokens, %lu chars; %lu lines; %lu files",
              pfile_token_ct_get(pf), stats.chars, stats.lines, stats.files);
            pfile_label_fixup(pf);
            name_buf = MALLOC(sizeof(JAL_MSG_COMPDATE) + 1 + sizeof(__DATE__));
            if (name_buf) {
              sprintf(name_buf, JAL_MSG_COMPDATE"\n", __DATE__);
            }
            pfile_cmd_dump(pf, (name_buf) ? name_buf : prog_name, argc, argv);
            if (name_buf) {
              FREE(name_buf);
            }
          }
        } else {
          pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CANNOT_OPEN, jal_name);
        }
        pfile_log(pf, PFILE_LOG_INFO, "%u errors, %u warnings",
            pfile_errct_get(pf), pfile_warnct_get(pf));
        err = pfile_errct_get(pf);
        pfile_close(pf);
      }
    }
    if (f_hex) {
      fclose(f_hex);
    }
    if (f_asm) {
      fclose(f_asm);
    }
    if (err) {
      if (!(pfile_flags & PFILE_FLAG_DEBUG_COMPILER)) {
        file_remove(asm_name, ".asm", sz, namebuf);
      }
      file_remove(hex_name, ".hex", sz, namebuf);
      file_remove(cod_name, ".cod", sz, namebuf);
      file_remove(cod_name, ".lst", sz, namebuf);
      file_remove(cod_name, ".log", sz, namebuf);
    } 

    FREE(inc_path);
    FREE(pre_include);
    FREE(namebuf);
  }
  return (err) ? EXIT_FAILURE : EXIT_SUCCESS;
}

