/************************************************************
 **
 ** cod_file.h : COD file declarations
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef cod_file_h__
#define cod_file_h__

#include <stdio.h>
#include "array.h"

#define COD_BLOCK_SIZE 512

#if 0
typedef unsigned long  ulong;
typedef unsigned short ushort;
typedef unsigned char  uchar;
#else
#undef ulong
#undef ushort
#undef uchar
#define ulong  unsigned long
#define ushort unsigned short
#define uchar  unsigned char
#endif

/* actual, raw code */
typedef struct COD_code_entry_ {
  uchar data[512];
} COD_code_entry_t;

/* show which bits of the code area are actually in use */
typedef struct COD_code_map_entry_ {
  ushort start;
  ushort end;
} COD_code_map_entry_t;

ARRAY_DEF(COD_code_map_table, COD_code_map_entry_t)

/*
 * nb: these were derived from VIEWCODE.PAS; for the most part
 *     I've absolutely no idea what they might mean
 */
typedef enum COD_symbol_type_
{
  COD_SYMBOL_TYPE_A_REG,
  COD_SYMBOL_TYPE_X_REG,
  COD_SYMBOL_TYPE_C_SHORT,
  COD_SYMBOL_TYPE_C_LONG,
  COD_SYMBOL_TYPE_C_USHORT,
  COD_SYMBOL_TYPE_C_ULONG,
  COD_SYMBOL_TYPE_C_POINTER,
  COD_SYMBOL_TYPE_C_UPOINTER,
  COD_SYMBOL_TYPE_TABLE,
  COD_SYMBOL_TYPE_M_BYTE,
  COD_SYMBOL_TYPE_M_BOOLEAN,
  COD_SYMBOL_TYPE_M_INDEX,
  COD_SYMBOL_TYPE_BYTE_ARRAY,
  COD_SYMBOL_TYPE_U_BYTE_ARRAY,
  COD_SYMBOL_TYPE_WORD_ARRAY,
  COD_SYMBOL_TYPE_U_WORD_ARRAY,
  COD_SYMBOL_TYPE_FUNC_VOID_NONE,
  COD_SYMBOL_TYPE_FUNC_VOID_BYTE,
  COD_SYMBOL_TYPE_FUNC_VOID_TWO_BYTE,
  COD_SYMBOL_TYPE_FUNC_VOID_LONG,
  COD_SYMBOL_TYPE_FUNC_VOID_UNDEF,
  COD_SYMBOL_TYPE_FUNC_INT_NONE,
  COD_SYMBOL_TYPE_FUNC_INT_BYTE,
  COD_SYMBOL_TYPE_FUNC_INT_TWO_BYTE,
  COD_SYMBOL_TYPE_FUNC_INT_LONG,
  COD_SYMBOL_TYPE_FUNC_INT_UNDEF,
  COD_SYMBOL_TYPE_FUNC_LONG_NONE,
  COD_SYMBOL_TYPE_FUNC_LONG_BYTE,
  COD_SYMBOL_TYPE_FUNC_LONG_TWO_BYTE,
  COD_SYMBOL_TYPE_FUNC_LONG_LONG,
  COD_SYMBOL_TYPE_FUNC_LONG_UNDEF,
  COD_SYMBOL_TYPE_PFUN_VOID_NONE,
  COD_SYMBOL_TYPE_PFUN_VOID_BYTE,
  COD_SYMBOL_TYPE_PFUN_VOID_TWO_BYTE,
  COD_SYMBOL_TYPE_PFUN_VOID_LONG,
  COD_SYMBOL_TYPE_PFUN_VOID_UNDEF,
  COD_SYMBOL_TYPE_PFUN_INT_NONE,
  COD_SYMBOL_TYPE_PFUN_INT_BYTE,
  COD_SYMBOL_TYPE_PFUN_INT_TWO_BYTE,
  COD_SYMBOL_TYPE_PFUN_INT_LONG,
  COD_SYMBOL_TYPE_PFUN_INT_UNDER,
  COD_SYMBOL_TYPE_PFUN_LONG_NONE,
  COD_SYMBOL_TYPE_PFUN_LONG_BYTE,
  COD_SYMBOL_TYPE_PFUN_LONG_TWO_BYTE,
  COD_SYMBOL_TYPE_PFUN_LONG_LONG,
  COD_SYMBOL_TYPE_PFUN_LONG_UNDER,
  COD_SYMBOL_TYPE_ADDRESS,
  COD_SYMBOL_TYPE_CONSTANT,
  COD_SYMBOL_TYPE_BAD_UND,
  COD_SYMBOL_TYPE_BR_UND,
  COD_SYMBOL_TYPE_UPPER_UND,
  COD_SYMBOL_TYPE_BYTE_UND,
  COD_SYMBOL_TYPE_ADD_UND,
  COD_SYMBOL_TYPE_M_KEYWORD,
  COD_SYMBOL_TYPE_ADD_MI_UND,
  COD_SYMBOL_TYPE_VECTOR,
  COD_SYMBOL_TYPE_PORT_W,
  COD_SYMBOL_TYPE_PORT_R,
  COD_SYMBOL_TYPE_PORT_RW,
  COD_SYMBOL_TYPE_PORT_RMW,
  COD_SYMBOL_TYPE_ENDIF,
  COD_SYMBOL_TYPE_EXUNDEF,
  COD_SYMBOL_TYPE_MACRO_T,
  COD_SYMBOL_TYPE_MACRO_S,
  COD_SYMBOL_TYPE_MACRO_A,
  COD_SYMBOL_TYPE_MACRO_C,
  COD_SYMBOL_TYPE_C_KEYWORD,
  COD_SYMBOL_TYPE_VOID,
  COD_SYMBOL_TYPE_C_ENUM,
  COD_SYMBOL_TYPE_C_TYPEDEF1,
  COD_SYMBOL_TYPE_C_UTYPEDEF1,
  COD_SYMBOL_TYPE_C_TYPEDEF2,
  COD_SYMBOL_TYPE_C_UTYPEDEF2,
  COD_SYMBOL_TYPE_CP_TYPEDEF1,
  COD_SYMBOL_TYPE_CP_UTYPEDEF1,
  COD_SYMBOL_TYPE_CP_TYPEDEF2,
  COD_SYMBOL_TYPE_CP_UTYPEDEF2,
  COD_SYMBOL_TYPE_C_STRUCT,
  COD_SYMBOL_TYPE_I_STRUCT,
  COD_SYMBOL_TYPE_L_CONST,
  COD_SYMBOL_TYPE_S_SHORT,
  COD_SYMBOL_TYPE_S_USHORT,
  COD_SYMBOL_TYPE_S_LONG,
  COD_SYMBOL_TYPE_S_ULONG,
  COD_SYMBOL_TYPE_SA_SHORT,
  COD_SYMBOL_TYPE_SA_USHORT,
  COD_SYMBOL_TYPE_SA_LONG,
  COD_SYMBOL_TYPE_SA_ULONG,
  COD_SYMBOL_TYPE_SP_SHORT,
  COD_SYMBOL_TYPE_SP_USHORT,
  COD_SYMBOL_TYPE_SP_LONG,
  COD_SYMBOL_TYPE_SP_ULONG,
  COD_SYMBOL_TYPE_FIXED_POINTER,
  COD_SYMBOL_TYPE_POINTER_FUNCTION,
  COD_SYMBOL_TYPE_CC_REG,
  COD_SYMBOL_TYPE_PTRF_VOID_NONE,
  COD_SYMBOL_TYPE_PTRF_VOID_BYTE,
  COD_SYMBOL_TYPE_PTRF_VOID_TWO_BYTE,
  COD_SYMBOL_TYPE_PTRF_VOID_LONG,
  COD_SYMBOL_TYPE_PTRF_VOID_UNDEF,
  COD_SYMBOL_TYPE_PTRF_INT_NONE,
  COD_SYMBOL_TYPE_PTRF_INT_BYTE,
  COD_SYMBOL_TYPE_PTRF_INT_TWO_BYTE,
  COD_SYMBOL_TYPE_PTRF_INT_LONG,
  COD_SYMBOL_TYPE_PTRF_INT_UNDEF,
  COD_SYMBOL_TYPE_PTRF_LONG_NONE,
  COD_SYMBOL_TYPE_PTRF_LONG_BYTE,
  COD_SYMBOL_TYPE_PTRF_LONG_TWO_BYTE,
  COD_SYMBOL_TYPE_PTRF_LONG_LONG,
  COD_SYMBOL_TYPE_PTRF_LONG_UNDEF,
  COD_SYMBOL_TYPE_PFAR_VOID_NONE,
  COD_SYMBOL_TYPE_PFAR_VOID_BYTE,
  COD_SYMBOL_TYPE_PFAG_VOID_TWO_BYTE,
  COD_SYMBOL_TYPE_PFAR_VOID_LONG,
  COD_SYMBOL_TYPE_PFAR_VOID_UNDEF,
  COD_SYMBOL_TYPE_PFAR_INT_NONE,
  COD_SYMBOL_TYPE_PFAR_INT_BYTE,
  COD_SYMBOL_TYPE_PFAR_INT_TWO_BYTE,
  COD_SYMBOL_TYPE_PFAR_INT_LONG,
  COD_SYMBOL_TYPE_PFAR_INT_UNDEF,
  COD_SYMBOL_TYPE_PFAR_LONG_NONE,
  COD_SYMBOL_TYPE_PFAR_LONG_BYTE,
  COD_SYMBOL_TYPE_PFAR_LONG_TWO_BYTE,
  COD_SYMBOL_TYPE_PFAR_LONG_LONG,
  COD_SYMBOL_TYPE_PFAR_LONG_UNDEF,
  COD_SYMBOL_TYPE_FWDLIT,
  /* MCHIP?? */
  COD_SYMBOL_TYPE_PFUNC,
  COD_SYMBOL_TYPE_MGOTO,
  COD_SYMBOL_TYPE_MCGOTO,
  COD_SYMBOL_TYPE_MCGOTO2,
  COD_SYMBOL_TYPE_MCGOTO3,
  COD_SYMBOL_TYPE_MCGOTO4,
  COD_SYMBOL_TYPE_MCGOTO74,
  COD_SYMBOL_TYPE_MCGOTO17,
  COD_SYMBOL_TYPE_MCCALL17,
  COD_SYMBOL_TYPE_MCALL,
  COD_SYMBOL_TYPE_MC_CALL,
  COD_SYMBOL_TYPE_RES_WORD,
  COD_SYMBOL_TYPE_LOCAL,
  COD_SYMBOL_TYPE_UNKNOWN,
  COD_SYMBOL_TYPE_VARLABEL,
  COD_SYMBOL_TYPE_EXTERNAL,
  COD_SYMBOL_TYPE_GLOBAL,
  COD_SYMBOL_TYPE_SEGMENT,
  COD_SYMBOL_TYPE_BANKADDR
} COD_symbol_type_t;

typedef struct COD_symbol_entry_ {
  uchar             label[13];
  COD_symbol_type_t type;
  ushort            value;
} COD_symbol_entry_t;

ARRAY_DEF(COD_symbol_table, COD_symbol_entry_t)

/*
 * it appears the local vars table is different than all others
 * (go figure). There are two different formats, depending on
 * the first entry:
 *   __LOCAL -- this is a key, where start and end define the
 *              code locations over which these variables are valid
 *              this is followed by any number of variable symbols
 */
typedef struct COD_local_vars_entry_ {
  struct {
    /* the first bit is an 8-byte string that is always \007__LOCAL */
    ulong start;    /*  first code location where these are valid */
    ulong end;      /*  last code location where these are valid  */
  } header;
  COD_symbol_table_t *symbols;
} COD_local_vars_entry_t;

ARRAY_DEF(COD_local_vars_table, COD_local_vars_entry_t)

typedef struct COD_name_entry_ {
  uchar label[64];
} COD_name_entry_t;

ARRAY_DEF(COD_name_table, COD_name_entry_t)

#define SMOD_FLAG_SOURCE_LINE    0x80 /* 'C' */
#define SMOD_FLAG_FUNCTION_START 0x40 /* 'F' */
#define SMOD_FLAG_ISR_START      0x20 /* 'I' */
#define SMOD_FLAG_DEFINITION     0x10 /* 'D' no code */
#define SMOD_FLAG_CONSTANT       0x08 /* 'C' */
#define SMOD_FLAG_NO_LISTING     0x04 /* 'L' */
#define SMOD_FLAG_NO_OBJECT      0x02 /* 'N' */
#define SMOD_FLAG_ASSERT         0x01 /* 'A' */

typedef struct COD_line_symbol_entry_ {
  uchar  file; /* file number (see name table) */
  uchar  smod; /* byte of flag info???         */
  ushort line; /* line within file             */
  ushort sloc; /* location of code             */
} COD_line_symbol_entry_t;

ARRAY_DEF(COD_line_symbol_table, COD_line_symbol_entry_t)

typedef struct COD_long_symbol_entry_ {
  uchar  name[256]; /* only size bytes of name is stored */
  uchar  stype0;
  uchar  stype1;
  ulong  svalue;
} COD_long_symbol_entry_t;

ARRAY_DEF(COD_long_symbol_table, COD_long_symbol_entry_t)

typedef struct COD_message_entry_ {
  ulong address;
  uchar type;
  uchar string[256];
} COD_message_entry_t;

ARRAY_DEF(COD_message_table, COD_message_entry_t)

/* index: simply block/code space mapping
 *   index[0] holds the block for code area   0.. 511
 *   index[1] holds the block for code area 512..1023
 *   ...
 */     
typedef struct COD_directory_ {
  /* this bit is derrived */
  FILE                     *io;         /* source or dest file */
  ushort                    block_start;/* first block */
  COD_symbol_table_t       *symbol_table;
  COD_name_table_t         *name_table;
  COD_line_symbol_table_t  *xref_table;
  COD_code_map_table_t     *code_map_table;
  COD_local_vars_table_t   *local_vars_table;
  COD_long_symbol_table_t  *long_symbol_table;
  COD_message_table_t      *message_table;
  COD_code_entry_t         *code[128];
  COD_code_map_entry_t     *code_entry; /* used to speed up code */

  /* everything below this is read from the file */
  ushort index[128]; /* points to code blocks */
  uchar  source[64]; /* [0] = length, 1..63 = data */
  uchar  date[8];    /* [0] = length, 1..7 = data (ddmmmyy)*/
  ushort time;       /* hh * 100 + mm */
  uchar  version[20];
  uchar  compiler[12];
  uchar  notice[64];
  ushort symbol_table_start;
  ushort symbol_table_end;
  ushort name_table_start;
  ushort name_table_end;
  ushort list_table_start;
  ushort list_table_end;
  uchar  addr_size;     /* # of bytes for addr, 2, 3, 4 (0 = 2)? */
  ushort high_addr;
  ushort next_dir;
  ushort code_map_start;
  ushort code_map_end;
  ushort local_vars_start;
  ushort local_vars_end;
  ushort COD_type;
  uchar  processor[9];
  ushort long_symbol_start;
  ushort long_symbol_end;
  ushort message_start;
  ushort message_end;
} COD_directory_t;


COD_directory_t *COD_directory_read(const char *fname);
/*
 * take all data and create the file
 */
void             COD_directory_write(COD_directory_t *dir,
                                     const char *fname);
COD_directory_t *COD_directory_alloc(const uchar *compiler);
void             COD_directory_version_set(COD_directory_t *dir,
                                           const uchar *version);
void             COD_directory_notice_set(COD_directory_t *dir,
                                          const uchar *notice);
void             COD_directory_processor_set(COD_directory_t *dir,
                                             const uchar *processor);
void             COD_directory_free(COD_directory_t *dir);

/*
 * the long symbol table will be created as needed
 */
void             COD_symbol_entry_add(COD_directory_t   *dir,
                                      const uchar       *label,
                                      COD_symbol_type_t  type,
                                      ushort             value);
/*
 * returns the index into the name table of the entry. Entry 0
 * is always created and set to 'src' passed in through alloc
 */
uchar            COD_name_entry_add(COD_directory_t *dir,
                                    const uchar     *label);
/*
 * the code map is created dynamically
 */
void             COD_line_symbol_entry_add(COD_directory_t *dir,
                                           uchar            file,
                                           uchar            smod,
                                           ushort           line,
                                           ushort           sloc);

void             COD_code_entry_add(COD_directory_t *dir,
                                    ushort           sloc,
                                    uchar            code);
#endif

