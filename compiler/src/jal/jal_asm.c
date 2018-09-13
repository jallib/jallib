/************************************************************
 **
 ** jal_asm.c : JAL assembler definitions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <errno.h>
#include "../libutils/mem.h"
#include "../libpic12/pic_inst.h"
#include "../libcore/cmd_asm.h"
#include "../libcore/pf_msg.h"
#include "../libcore/pf_proc.h"
#include "../libcore/pf_cmd.h"
#include "jal_expr.h"
#include "jal_tokn.h"
#include "jal_incl.h"
#include "jal_blck.h"
#include "jal_asm.h"

/* needed MACROS:
   ADDCF  f,d : btfsc _status, _c;  incf f,d
   ADDDCF f,d : btfsc _status, _dc; incf f,d
   B      n   : goto n
   BC     n   : btfsc _status, _c;  goto n
   BDC    n   : btfsc _status, _dc; goto n
   BNC    n   : btfss _status, _c;  goto n
   BNDC   n   : btfss _status, _dc; goto n
   BNZ    n   : btfss _status, _z;  goto n
   BZ     n   : btfss _status, _z;  goto n
   CLRC       : bcf _status, _c
   CLRDC      : bcf _status, _dc
   CLRZ       : bcf _status, _z
   LCALL  n   : page call n
   LGOTO  n   : page goto n
   MOVFW  f   : movf f,w
   NEGF   f,d : comf f,f; inc f,f
   SETC       : bsf _status, _c
   SETDC      : bsf _status, _dc
   SETZ       : bsf _status, _z
   SKPC       : btfss _status, _c
   SKPDC      : btfss _status, _dc
   SKPNC      : btfsc _status, _c
   SKPNDC     : btfsc _status, _dc
   SKPNZ      : btfsc _status, _z
   SKPZ       : btfss _status, _z
   SUBCF  f,d : btfsc _status, _c ; decf f,d
   SUBDCF f,d : btfsc _status, _dc; decf f,d
*/
/* there are only six types of instructions:
     op     --
     op f   --
     op f,d -- d = 0 or 1
     op f,b -- 0 <= b <= 7
     op n   -- 0 <= n <= 255
     op k   -- 0 <= k <= 2047
   plus two special commands:
     bank -- set the bank bits for the next instruction
     page -- set the page bits for the next instruction
*/
/*
 * tblrd [ * | *+ | *- | +* ]
 * tblwr [ * | *+ | *- | +* ]
 *   *   -- tblptr --> tablat
 *   *+  -- tblptr --> tablat; tblptr++
 *   *-  -- tblptr --> tablat; tblptr--
 *   +*  -- tblptr++; tblptr --> tablat
 */
/* parse a single assembly command */
#define ASM_BIT_NONE 0x0000
#define ASM_BIT_BANK 0x0001 /* BANK found */
#define ASM_BIT_PAGE 0x0002 /* PAGE found */

/* changes to this enum must be reflected in the following arrays! */
typedef enum {
  asm_cmd_special_none,
  asm_cmd_special_addcf, /* btfsc _status, _c; incf f, d */
  asm_cmd_special_adddcf,/* btfsc _status, _dc; incf f, d */
  asm_cmd_special_b,     /* goto n */
  asm_cmd_special_bc,    /* btfsc _status, _c; goto n */
  asm_cmd_special_bdc,   /* btfsc _status, _dc; goto n */
  asm_cmd_special_bnc,   /* btfss _status, _c; goto n */
  asm_cmd_special_bndc,  /* btfsc _status, _c; goto n */
  asm_cmd_special_bnz,   /* btfss _status, _z; goto n */
  asm_cmd_special_bz,    /* btfsc _status, _z; goto n */
  asm_cmd_special_clrc,  /* bcf   _status, _c */
  asm_cmd_special_clrdc, /* bcf   _status, _dc */
  asm_cmd_special_clrz,  /* bcf   _status, _z  */
  asm_cmd_special_lcall, /* page call n */
  asm_cmd_special_lgoto, /* page goto n */
  asm_cmd_special_movfw, /* movf f,0 */
  asm_cmd_special_negf,  /* comf  f, 1; incf f, d */
  asm_cmd_special_setc,  /* bsf   _status, _c */
  asm_cmd_special_setdc, /* bsf   _status, _dc */
  asm_cmd_special_setz,  /* bsf   _status, _z  */
  asm_cmd_special_skpc,  /* btfss _status, _c  */
  asm_cmd_special_skpdc, /* btfss _status, _dc */
  asm_cmd_special_skpnc, /* btfsc _status, _c  */
  asm_cmd_special_skpndc,/* btfsc _status, _dc */
  asm_cmd_special_skpnz, /* btfsc _status, _z  */
  asm_cmd_special_skpz,  /* btfss _status, _z  */
  asm_cmd_special_subcf, /* btfss _status, _c; decf f, d */
  asm_cmd_special_subdcf,/* btfsc _status, _dc; decf f, d */
  asm_cmd_special_tstf,  /* movf f, f */
  asm_cmd_special_tblrd, /* tblrd */
  asm_cmd_special_tblwt, /* tblwt */
  asm_cmd_special_ct
} asm_cmd_special_t;

static const struct {
  unsigned     asm_bit; /* BANK and/or PAGE flags to add   */
  pic_opcode_t flag_op; /* operator used by _status, _flag */
  const char  *flag;    /* flag to test                    */
  pic_opcode_t op;      /* translated op                   */
} macro_xlate[asm_cmd_special_ct] = {
  {ASM_BIT_NONE, PIC_OPCODE_NONE,  0,     PIC_OPCODE_NONE}, /* */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSC, "_c",  PIC_OPCODE_INCF}, /* addcf  */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSC, "_dc", PIC_OPCODE_INCF}, /* adddcf */
  {ASM_BIT_NONE, PIC_OPCODE_NONE,  0,     PIC_OPCODE_GOTO}, /* b      */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSC, "_c",  PIC_OPCODE_GOTO}, /* bc     */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSC, "_dc", PIC_OPCODE_GOTO}, /* bdc    */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSS, "_c",  PIC_OPCODE_GOTO}, /* bnc    */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSS, "_dc", PIC_OPCODE_GOTO}, /* bndc   */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSS, "_z",  PIC_OPCODE_GOTO}, /* bnz    */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSC, "_z",  PIC_OPCODE_GOTO}, /* bz     */
  {ASM_BIT_NONE, PIC_OPCODE_BCF,   "_c",  PIC_OPCODE_NONE}, /* clrc   */
  {ASM_BIT_NONE, PIC_OPCODE_BCF,   "_dc", PIC_OPCODE_NONE}, /* clrdc  */
  {ASM_BIT_NONE, PIC_OPCODE_BCF,   "_z",  PIC_OPCODE_NONE}, /* clrz   */
  {ASM_BIT_PAGE, PIC_OPCODE_NONE,  0,     PIC_OPCODE_CALL}, /* lcall  */
  {ASM_BIT_PAGE, PIC_OPCODE_NONE,  0,     PIC_OPCODE_GOTO}, /* lgoto  */
  {ASM_BIT_NONE, PIC_OPCODE_NONE,  0,     PIC_OPCODE_MOVF}, /* movfw  */
  {ASM_BIT_NONE, PIC_OPCODE_NONE,  0,     PIC_OPCODE_INCF}, /* negf   */
  {ASM_BIT_NONE, PIC_OPCODE_BSF,   "_c",  PIC_OPCODE_NONE}, /* setc   */
  {ASM_BIT_NONE, PIC_OPCODE_BSF,   "_dc", PIC_OPCODE_NONE}, /* setdc  */
  {ASM_BIT_NONE, PIC_OPCODE_BSF,   "_z",  PIC_OPCODE_NONE}, /* setz   */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSS, "_c",  PIC_OPCODE_NONE}, /* skpc   */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSS, "_dc", PIC_OPCODE_NONE}, /* skpdc  */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSC, "_c",  PIC_OPCODE_NONE}, /* skpnc  */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSC, "_dc", PIC_OPCODE_NONE}, /* skpndc */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSC, "_z",  PIC_OPCODE_NONE}, /* skpnz  */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSS, "_z",  PIC_OPCODE_NONE}, /* skpz   */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSC, "_c",  PIC_OPCODE_NONE}, /* subcf  */
  {ASM_BIT_NONE, PIC_OPCODE_BTFSC, "_dc", PIC_OPCODE_NONE}, /* subdcf */
  {ASM_BIT_NONE, PIC_OPCODE_NONE,  0,     PIC_OPCODE_MOVF}, /* tstf   */
  {ASM_BIT_NONE, PIC_OPCODE_NONE,  0,     PIC_OPCODE_TBLRD},/* tblrd  */
  {ASM_BIT_NONE, PIC_OPCODE_NONE,  0,     PIC_OPCODE_TBLWT},/* tblwt  */
};


static const struct {
  const char       *tag;
  pic_optype_t      type;
  pic_opcode_t      op;
  asm_cmd_special_t special; /* a hack for the special operations */
} asm_cmds[] = {
  {"addwf",  PIC_OPTYPE_F_D,  PIC_OPCODE_ADDWF,  asm_cmd_special_none},
  {"addwfc", PIC_OPTYPE_F_D,  PIC_OPCODE_ADDWFc, asm_cmd_special_none},
  {"andwf",  PIC_OPTYPE_F_D,  PIC_OPCODE_ANDWF,  asm_cmd_special_none},
  {"clrf",   PIC_OPTYPE_F,    PIC_OPCODE_CLRF,   asm_cmd_special_none},
  {"clrw",   PIC_OPTYPE_NONE, PIC_OPCODE_CLRW,   asm_cmd_special_none},
  {"comf",   PIC_OPTYPE_F_D,  PIC_OPCODE_COMF,   asm_cmd_special_none},
  {"decf",   PIC_OPTYPE_F_D,  PIC_OPCODE_DECF,   asm_cmd_special_none},
  {"decfsz", PIC_OPTYPE_F_D,  PIC_OPCODE_DECFSZ, asm_cmd_special_none},
  {"incf",   PIC_OPTYPE_F_D,  PIC_OPCODE_INCF,   asm_cmd_special_none},
  {"incfsz", PIC_OPTYPE_F_D,  PIC_OPCODE_INCFSZ, asm_cmd_special_none},
  {"iorwf",  PIC_OPTYPE_F_D,  PIC_OPCODE_IORWF,  asm_cmd_special_none},
  {"movf",   PIC_OPTYPE_F_D,  PIC_OPCODE_MOVF,   asm_cmd_special_none},
  {"movwf",  PIC_OPTYPE_F,    PIC_OPCODE_MOVWF,  asm_cmd_special_none},
  {"mulwf",  PIC_OPTYPE_F,    PIC_OPCODE_MULWF,  asm_cmd_special_none},
  {"nop",    PIC_OPTYPE_NONE, PIC_OPCODE_NOP,    asm_cmd_special_none},
  {"rlf",    PIC_OPTYPE_F_D,  PIC_OPCODE_RLF,    asm_cmd_special_none},
  {"rlcf",   PIC_OPTYPE_F_D,  PIC_OPCODE_RLCF,   asm_cmd_special_none},
  {"rlncf",  PIC_OPTYPE_F_D,  PIC_OPCODE_RLNCF,  asm_cmd_special_none},
  {"rrf",    PIC_OPTYPE_F_D,  PIC_OPCODE_RRF,    asm_cmd_special_none},
  {"rrcf",   PIC_OPTYPE_F_D,  PIC_OPCODE_RRCF,   asm_cmd_special_none},
  {"rrncf",  PIC_OPTYPE_F_D,  PIC_OPCODE_RRNCF,  asm_cmd_special_none},
  {"subwf",  PIC_OPTYPE_F_D,  PIC_OPCODE_SUBWF,  asm_cmd_special_none},
  {"swapf",  PIC_OPTYPE_F_D,  PIC_OPCODE_SWAPF,  asm_cmd_special_none},
  {"xorwf",  PIC_OPTYPE_F_D,  PIC_OPCODE_XORWF,  asm_cmd_special_none},
  {"bcf",    PIC_OPTYPE_F_B,  PIC_OPCODE_BCF,    asm_cmd_special_none},
  {"bsf",    PIC_OPTYPE_F_B,  PIC_OPCODE_BSF,    asm_cmd_special_none},
  {"btfsc",  PIC_OPTYPE_F_B,  PIC_OPCODE_BTFSC,  asm_cmd_special_none},
  {"btfss",  PIC_OPTYPE_F_B,  PIC_OPCODE_BTFSS,  asm_cmd_special_none},
  {"addlw",  PIC_OPTYPE_N,    PIC_OPCODE_ADDLW,  asm_cmd_special_none},
  {"andlw",  PIC_OPTYPE_N,    PIC_OPCODE_ANDLW,  asm_cmd_special_none},
  {"call",   PIC_OPTYPE_K,    PIC_OPCODE_CALL,   asm_cmd_special_none},
  {"clrwdt", PIC_OPTYPE_NONE, PIC_OPCODE_CLRWDT, asm_cmd_special_none},
  {"goto",   PIC_OPTYPE_K,    PIC_OPCODE_GOTO,   asm_cmd_special_none},
  {"iorlw",  PIC_OPTYPE_N,    PIC_OPCODE_IORLW,  asm_cmd_special_none},
  {"movlw",  PIC_OPTYPE_N,    PIC_OPCODE_MOVLW,  asm_cmd_special_none},
  {"retfie", PIC_OPTYPE_NONE, PIC_OPCODE_RETFIE, asm_cmd_special_none},
  {"retlw",  PIC_OPTYPE_N,    PIC_OPCODE_RETLW,  asm_cmd_special_none},
  {"reset",  PIC_OPTYPE_NONE, PIC_OPCODE_RESET,  asm_cmd_special_none},
  {"return", PIC_OPTYPE_NONE, PIC_OPCODE_RETURN, asm_cmd_special_none},
  {"sleep",  PIC_OPTYPE_NONE, PIC_OPCODE_SLEEP,  asm_cmd_special_none},
  {"sublw",  PIC_OPTYPE_N,    PIC_OPCODE_SUBLW,  asm_cmd_special_none},
  {"xorlw",  PIC_OPTYPE_N,    PIC_OPCODE_XORLW,  asm_cmd_special_none},
  {"tblrd",  PIC_OPTYPE_NONE, PIC_OPCODE_TBLRD,  asm_cmd_special_tblrd},
  {"tblwt",  PIC_OPTYPE_NONE, PIC_OPCODE_TBLWT,  asm_cmd_special_tblwt},
  {"reset",  PIC_OPTYPE_NONE, PIC_OPCODE_RESET,  asm_cmd_special_none},
  /* don't use the next two! */
  {"option", PIC_OPTYPE_NONE, PIC_OPCODE_OPTION, asm_cmd_special_none},
  {"tris",   PIC_OPTYPE_TRIS, PIC_OPCODE_TRIS,   asm_cmd_special_none},
  /* let's add some common macros */
  {"addcf",  PIC_OPTYPE_F_D,  PIC_OPCODE_NONE, asm_cmd_special_addcf},
  {"adddcf", PIC_OPTYPE_F_D,  PIC_OPCODE_NONE, asm_cmd_special_adddcf},
  {"b",      PIC_OPTYPE_K,    PIC_OPCODE_NONE, asm_cmd_special_b},
  {"bc",     PIC_OPTYPE_K,    PIC_OPCODE_NONE, asm_cmd_special_bc},
  {"bdc",    PIC_OPTYPE_K,    PIC_OPCODE_NONE, asm_cmd_special_bdc},
  {"bnc",    PIC_OPTYPE_K,    PIC_OPCODE_NONE, asm_cmd_special_bnc},
  {"bndc",   PIC_OPTYPE_K,    PIC_OPCODE_NONE, asm_cmd_special_bndc},
  {"bnz",    PIC_OPTYPE_K,    PIC_OPCODE_NONE, asm_cmd_special_bnz},
  {"bz",     PIC_OPTYPE_K,    PIC_OPCODE_NONE, asm_cmd_special_bz},
  {"clrc",   PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_clrc},
  {"clrdc",  PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_clrdc},
  {"clrz",   PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_clrz},
  {"lcall",  PIC_OPTYPE_K,    PIC_OPCODE_NONE, asm_cmd_special_lcall},
  {"lgoto",  PIC_OPTYPE_K,    PIC_OPCODE_NONE, asm_cmd_special_lgoto},
  {"movfw",  PIC_OPTYPE_F,    PIC_OPCODE_NONE, asm_cmd_special_movfw},
  {"negf",   PIC_OPTYPE_F,    PIC_OPCODE_NONE, asm_cmd_special_negf},
  {"setc",   PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_setc},
  {"setdc",  PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_setdc},
  {"setz",   PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_setz},
  {"skpc",   PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_skpc},
  {"skpdc",  PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_skpdc},
  {"skpnc",  PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_skpnc},
  {"skpndc", PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_skpndc},
  {"skpnz",  PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_skpnz},
  {"skpz",   PIC_OPTYPE_NONE, PIC_OPCODE_NONE, asm_cmd_special_skpz},
  {"subcf",  PIC_OPTYPE_F_D,  PIC_OPCODE_NONE, asm_cmd_special_subcf},
  {"subdcf", PIC_OPTYPE_F_D,  PIC_OPCODE_NONE, asm_cmd_special_subdcf},
  {"tstf",   PIC_OPTYPE_F,    PIC_OPCODE_NONE, asm_cmd_special_tstf}
};


static void asm_cmd_add(pfile_t *pf,
    pic_opcode_t op, value_t val, size_t valofs, pic_opdst_t opdst, 
    value_t n, label_t lbl, flag_t flags, size_t data_sz, uchar *data)
{
  cmd_t cmd;

  cmd = cmd_asm_alloc(op, val, valofs, opdst, n, lbl, flags, data_sz, data);
  if (cmd) {
    pfile_cmd_add(pf, cmd);
  }
}

typedef struct asm_db_data_ {
  size_t alloc;
  size_t used;
  uchar *data;
} asm_db_data_t;

/* parse: 
 *   db c1,c2[,c3,c4...] 
 *   dw c1[,c2...]
 *   ds "blah"|c1[,...]
 */
typedef enum {
  jal_parse_asm_db,
  jal_parse_asm_dw,
  jal_parse_asm_ds
} jal_parse_asm_t;

static pic_target_cpu_t asm_target_cpu_get(pfile_t *pf)
{
  value_t          target;
  pic_target_cpu_t cpu_family;

  target = pfile_value_find(pf, PFILE_LOG_NONE, "target_cpu");
  if (!target) {
    pfile_log(pf, PFILE_LOG_WARN, 
      "target cpu not defined, assuming 14 bit core");
    cpu_family = PIC_TARGET_CPU_14BIT;
  } else {
    cpu_family = value_const_get(target);
    value_release(target);
  }
  return cpu_family;
}

static void asm_data_append(pfile_t *pf, asm_db_data_t *data, 
  jal_parse_asm_t type, variable_const_t n)
{
  variable_const_t n_max;
  pic_target_cpu_t cpu_family;

  cpu_family = asm_target_cpu_get(pf);
  if (data->used == data->alloc) {
    size_t tmp_alloc;
    void  *tmp;

    tmp_alloc = (data->alloc) ? 2 * data->alloc : 256;
    tmp       = REALLOC(data->data, sizeof(*data->data) * tmp_alloc);
    if (!tmp) {
      pfile_log_syserr(pf, ENOMEM);
    } else {
      data->data  = tmp;
      data->alloc = tmp_alloc;
    }
  }
  /* let's validate n */
  if (PIC_TARGET_CPU_16BIT == cpu_family) {
    n_max = 255;
  } else {
    if (jal_parse_asm_ds == type) {
      n_max = 127;
    } else {
      /* on a 14 bit core, even bytes are limited to 6 bits */
      n_max = (variable_const_t) (data->used & 0x0001) ? 255 : 63;
    }
  }
  if ((n > n_max) && pfile_flag_test(pf, PFILE_FLAG_WARN_RANGE)) {
    pfile_log(pf, PFILE_LOG_WARN, "%u out of range", (unsigned) n & 0xff);
  }
  if (data->used < data->alloc) {
    data->data[data->used] = (uchar) (n & n_max);
    data->used++;
  }
}

void jal_parse_asm_data(pfile_t *pf, jal_parse_asm_t type)
{
  asm_db_data_t data;

  data.alloc = 0;
  data.used  = 0;
  data.data  = 0;
  do {
    /* skip the ',' or dx */
    pf_token_get(pf, PF_TOKEN_NEXT);
    if ('"' == *pf_token_get(pf, PF_TOKEN_CURRENT)) {
      /* parse a string */
      const char *str;
      size_t      str_sz;

      str    = pf_token_get(pf, PF_TOKEN_CURRENT) + 1;
      str_sz = pf_token_sz_get(pf) - 1;
      if (str_sz && ('"' == str[str_sz-1])) {
        str_sz--;
      }
      while (str_sz) {
        if ((jal_parse_asm_db == type)
          || (jal_parse_asm_dw == type)) {
          asm_data_append(pf, &data, type, 0);
        }
        asm_data_append(pf, &data, type, *str);
        str++;
        str_sz--;
      }
      pf_token_get(pf, PF_TOKEN_NEXT);
    } else {
      value_t          cexpr;
      variable_const_t n;

      cexpr = jal_parse_expr(pf);
      if (!value_is_const(cexpr)) {
        pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_EXPECTED);
        n = 0;
      } else {
        n = value_const_get(cexpr);
      }
      value_release(cexpr);
      if (jal_parse_asm_dw == type) {
        asm_data_append(pf, &data, type, n / 256);
      }
      asm_data_append(pf, &data, type, n & 0xff);
    }
  } while (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ","));
  if (data.used) {
    if (data.used & 0x01) {
      /* due to the way the data member is allocated, we know that
         an even number of bytes always exists (this padding will not
         cause a buffer overflow */
      if (pfile_flag_test(pf, PFILE_FLAG_WARN_MISC)) {
        pfile_log(pf, PFILE_LOG_WARN, "size is odd, padding used");
      }
      data.data[data.used] = 0;
      data.used++;
    }
    if (jal_parse_asm_ds == type) {
      /* pack 2 chars into 1 14-bit word */
      size_t ii;

      for (ii = 0; ii < data.used; ii += 2) {
        unsigned n;

        n = data.data[ii] * 128U + data.data[ii+1];
        data.data[ii]   = n >> 8;
        data.data[ii+1] = n & 0xff;
      }
    }
    asm_cmd_add(pf, PIC_OPCODE_DB, VALUE_NONE, 0, PIC_OPDST_NONE,
      VALUE_NONE, LABEL_NONE, 0, data.used, data.data);
  }
}

/* this returns TRUE if at least one token has been absorbed */
void jal_parse_asm(pfile_t *pf, const pfile_pos_t *statement_start)
{
  UNUSED(statement_start);
  if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "db")) {
    jal_parse_asm_data(pf, jal_parse_asm_db);
  } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "dw")) {
    jal_parse_asm_data(pf, jal_parse_asm_dw);
  } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "ds")) {
    jal_parse_asm_data(pf, jal_parse_asm_ds);
  } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "local")) {
    /* declare some local labels */
    do {
      const char *ptr;

      ptr = pf_token_get(pf, PF_TOKEN_NEXT);
      if (jal_token_is_identifier(pf)) {
        label_release(pfile_label_alloc(pf, ptr));
        pf_token_get(pf, PF_TOKEN_NEXT);
      }
    } while (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, ","));
  } else {
    unsigned     flags;
    size_t       ii;
    value_t      val;
    size_t       valofs;
    value_t      n;
    pic_opcode_t op;
    pic_opdst_t  opdst;
    label_t      lbl;
    boolean_t    err;
    unsigned     n_lo;
    unsigned     n_hi;
   
    lbl = LABEL_NONE;
    if (jal_token_is_identifier(pf)) {
      /* protect against an ASM statement also being a label
       * I need to find a better solution to this! */
      for (ii = 0; 
           (ii < COUNT(asm_cmds)) 
           && !pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, 
             asm_cmds[ii].tag);
           ii++)
        ; /* null body */
      if (ii == COUNT(asm_cmds)) {
        const char *ptr;

        ptr = pf_token_get(pf, PF_TOKEN_CURRENT);
        lbl = pfile_label_find(pf, PFILE_LOG_NONE, ptr);
        if (lbl) {
          pfile_cmd_label_add(pf, lbl);
          label_release(lbl);
          if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, ":")) {
            pf_token_get(pf, PF_TOKEN_NEXT);
          }
        }
      }
    }
    if (!lbl) {
      err    = BOOLEAN_FALSE;
      flags  = 0;
      op     = PIC_OPCODE_NONE;
      opdst  = PIC_OPDST_NONE;
      val    = VALUE_NONE;
      valofs = 0;
      n      = VALUE_NONE;
      lbl    = LABEL_NONE;
      n_lo   = 0;
      n_hi   = -1;

      /* first, look for any pre BANK or PAGE elements */
      /* it looks like the assembler should handle the following:
         BANK value
         PAGE label
         BANK | PAGE statement
         Logically, only one of BANK or PAGE can exist for a statement and
         the flag effects only the *following* statement */
      if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "bank")) {
        flags |= ASM_BIT_BANK;
        pf_token_get(pf, PF_TOKEN_NEXT);
      } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "page")) {
        flags |= ASM_BIT_PAGE;
        pf_token_get(pf, PF_TOKEN_NEXT);
        if (pic_is_16bit(pf) && pfile_flag_test(pf, PFILE_FLAG_WARN_MISC)) {
          pfile_log(pf, PFILE_LOG_WARN, "PAGE has no meaning on 16 bit cores");
        }
      }
      for (ii = 0; 
           (ii < COUNT(asm_cmds)) 
           && !pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, 
             asm_cmds[ii].tag);
           ii++)
        ; /* null body */


      if (COUNT(asm_cmds) == ii) {
        /* let's allow:
           PAGE label
           BANK [# | value] */
        if (flags & ASM_BIT_BANK) {
          /* apparently there's some assembly command ``bank n'' */
          /* so allow it here */
          val = pfile_value_find(pf, PFILE_LOG_NONE,
              pf_token_get(pf, PF_TOKEN_CURRENT));
          if (val && !value_is_const(val)) {
            pf_token_get(pf, PF_TOKEN_NEXT);
          } else {
            if (val) {
              value_release(val);
            }
            val = jal_parse_expr(pf);
            if (val) {
              if (!value_is_const(val)) {
                pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_EXPECTED);
                err = BOOLEAN_TRUE;
              }
              value_release(val);
              val = VALUE_NONE;
              flags &= ~ASM_BIT_BANK;
            }
          }
        } else if (flags & ASM_BIT_PAGE) {
          lbl = pfile_label_find(pf, PFILE_LOG_ERR, 
                  pf_token_get(pf, PF_TOKEN_CURRENT));
          if (lbl) {
            pf_token_get(pf, PF_TOKEN_NEXT);
          } else {
            err = BOOLEAN_TRUE;
          }
        } else {
          err = BOOLEAN_TRUE;
          pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_SYNTAX_ERROR);
        }
      } else {
        /* process the cmd */
        op = asm_cmds[ii].op;
        pf_token_get(pf, PF_TOKEN_NEXT);

        switch (asm_cmds[ii].type) {
          case PIC_OPTYPE_NONE:
            /* nothing more to do */
            break;
          case PIC_OPTYPE_F:
          case PIC_OPTYPE_F_D:
          case PIC_OPTYPE_F_B:
            /* allow ''BANK'', a variable name, or a constant expression */
            if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "bank")) {
              flags |= ASM_BIT_BANK;
              pf_token_get(pf, PF_TOKEN_NEXT);
            }
            val = pfile_value_find(pf, PFILE_LOG_NONE,
                pf_token_get(pf, PF_TOKEN_CURRENT));
            if (val) {
              value_t cexpr;

              pf_token_get(pf, PF_TOKEN_NEXT);
              if (value_is_array(val)
                  && (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "["))) {
                value_t               subs;

                pf_token_get(pf, PF_TOKEN_NEXT);
                subs = jal_parse_expr(pf);
                if (subs) {
                  variable_def_t        def;
                  variable_def_member_t mbr;

                  mbr = variable_def_member_get(
                          value_def_get(val));
                  def = variable_def_member_def_get(mbr);

                  if (!value_is_const(subs)) {
                    pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_EXPECTED);
                  } else if (value_const_get(subs) 
                      >= variable_def_member_ct_get(mbr)) {
                    pfile_log(pf, PFILE_LOG_ERR, "subscript out of range");
                  } else {
                    if (variable_def_sz_get(def) > 1) {
                      value_t tmp;

                      tmp = pfile_constant_get(pf, variable_def_sz_get(def)
                          * value_const_get(subs), VARIABLE_DEF_NONE);
                      value_release(subs);
                      subs = tmp;
                    }
                    value_baseofs_set(val, subs);
                  }
                  value_release(subs);
                }
                if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, "]")) {
                  pf_token_get(pf, PF_TOKEN_NEXT);
                }
              }
              if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "+")
                || pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "-")) {
                cexpr = jal_parse_expr(pf);
                if (cexpr) {
                  if (!value_is_const(cexpr)) {
                    pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_EXPECTED);
                  } else {
                    valofs = value_const_get(cexpr);
                  }
                  value_release(cexpr);
                }
              }
            } else {
              val = jal_parse_expr(pf);
              if (val && !value_is_const(val)) {
                pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_EXPECTED);
                value_release(val);
                val = VALUE_NONE;
                err = BOOLEAN_TRUE;
              }
            }
            if (PIC_OPTYPE_F == asm_cmds[ii].type) {
              if (asm_cmd_special_movfw == asm_cmds[ii].special) {
                n = pfile_value_find(pf, PFILE_LOG_NONE, "w");
                n_lo = 0;
                n_hi = 1;
              }
            } else if (PIC_OPTYPE_F_D == asm_cmds[ii].type) {
              if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, ",")) {
                pf_token_get(pf, PF_TOKEN_NEXT);
              }
              n = jal_parse_expr(pf);
              n_lo = 0;
              n_hi = 1;
            } else {
              /* if value is a bit variable, position is assumed */
              if (!value_dflag_test(val, VARIABLE_DEF_FLAG_BIT)) {
                if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_ERR, ",")) {
                  pf_token_get(pf, PF_TOKEN_NEXT);
                }
                n = jal_parse_expr(pf);
                n_lo = 0;
                n_hi = 7;
              }
            }
            break;
          case PIC_OPTYPE_N:
            n = jal_parse_expr(pf);
            n_lo = 0;
            n_hi = 255;
            break;
          case PIC_OPTYPE_TRIS:
            n = jal_parse_expr(pf);
            n_lo = 5;
            n_hi = 9;
            break;
          case PIC_OPTYPE_K:
            if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "page")) {
              flags |= ASM_BIT_PAGE;
              pf_token_get(pf, PF_TOKEN_NEXT);
            }
            lbl = pfile_label_find(pf, PFILE_LOG_NONE, pf_token_ptr_get(pf));
            if (lbl) {
              pf_token_get(pf, PF_TOKEN_NEXT);
            } else {
              n = jal_parse_expr(pf);
              if ((VALUE_NONE == n) || !value_is_const(n)) {
                pfile_log(pf, PFILE_LOG_ERR, "constant expression expected");
                value_release(n);
                n = VALUE_NONE;
                err = BOOLEAN_TRUE;
              } else {
                lbl = pfile_label_alloc(pf, 0);
                label_pc_set(lbl, value_const_get(n));
                label_flag_set(lbl, LABEL_FLAG_DEFINED);
                label_flag_set(lbl, LABEL_FLAG_USER);
                value_release(n);
                n = VALUE_NONE;
              }
            }
            break;
          case PIC_OPTYPE_DB:
            /* this is special cased above */
            break;
        }
      }
      if (n) {
        if (!value_is_const(n)
            && !value_is_label(n)) {
          pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_EXPECTED);
          err = BOOLEAN_TRUE;
        } else if ((value_const_get(n) < n_lo) 
          || (value_const_get(n) > n_hi)) {
          pfile_log(pf, PFILE_LOG_ERR, PFILE_MSG_CONSTANT_RANGE);
          err = BOOLEAN_TRUE;
        }
        if (err) {
          value_release(n);
          n = VALUE_NONE;
        }
      }

      if (!err) {
        asm_cmd_special_t special;

        special = (ii < COUNT(asm_cmds))
          ? asm_cmds[ii].special
          : asm_cmd_special_none;

        if (asm_cmd_special_none != special) {
          /* do the flags before anything else */
          flags |= macro_xlate[special].asm_bit;
        }
        if ((flags & ASM_BIT_PAGE) && !pic_is_16bit(pf))  {
          if (!lbl) {
            if (pfile_flag_test(pf, PFILE_FLAG_WARN_MISC)) {
              pfile_log(pf, PFILE_LOG_WARN, 
                  "PAGE used without an associated label");
            }
          } else {
            /* generate page bits */
            value_t code_sz;
            flag_t  keep;

            keep = ((asm_cmd_special_lcall == special)
              || (asm_cmd_special_lgoto == special)
              || pfile_proc_flag_test(pfile_proc_active_get(pf), 
                   PFILE_PROC_FLAG_KEEP_PAGE))
              ? PIC_CODE_FLAG_NO_OPTIMIZE
              : 0;

            code_sz = pfile_value_find(pf, PFILE_LOG_ERR, "_code_size");
            if (value_const_get(code_sz) > 2048) {
              asm_cmd_add(pf, PIC_OPCODE_BRANCHLO_SET, VALUE_NONE, 0,
                  PIC_OPDST_NONE,
                  VALUE_NONE, lbl, keep, 0, 0);
            }
            if (value_const_get(code_sz) > 4096) {
              asm_cmd_add(pf, PIC_OPCODE_BRANCHHI_SET, VALUE_NONE, 0,
                  PIC_OPDST_NONE,
                  VALUE_NONE, lbl, keep, 0, 0);
            }
            value_release(code_sz);
          }
        }
        if (flags & ASM_BIT_BANK) {
          if (!val) {
            if (pfile_flag_test(pf, PFILE_FLAG_WARN_MISC)) {
              pfile_log(pf, PFILE_LOG_WARN,
                  "BANK used without an associated value");
            }
          } else {
            if ((PIC_TARGET_CPU_16BIT == asm_target_cpu_get(pf)) 
                || (PIC_TARGET_CPU_14HBIT == asm_target_cpu_get(pf))) {
              value_t lb;

              lb = pfile_constant_get(pf, 0, VARIABLE_DEF_NONE);
              asm_cmd_add(pf, PIC_OPCODE_MOVLB, val, 0, PIC_OPDST_NONE,
                VALUE_NONE, LABEL_NONE, 
                pfile_proc_flag_test(pfile_proc_active_get(pf),
                  PFILE_PROC_FLAG_KEEP_BANK) ? PIC_CODE_FLAG_NO_OPTIMIZE : 0,
                  0, 0);
              value_release(lb);
            } else {
              asm_cmd_add(pf, PIC_OPCODE_DATALO_SET, val, 0, PIC_OPDST_NONE,
                  VALUE_NONE, LABEL_NONE, 
                  pfile_proc_flag_test(pfile_proc_active_get(pf),
                    PFILE_PROC_FLAG_KEEP_BANK) ? PIC_CODE_FLAG_NO_OPTIMIZE : 0,
                    0, 0);
              asm_cmd_add(pf, PIC_OPCODE_DATAHI_SET, val, 0, PIC_OPDST_NONE,
                  VALUE_NONE, LABEL_NONE,
                  pfile_proc_flag_test(pfile_proc_active_get(pf),
                    PFILE_PROC_FLAG_KEEP_BANK) ? PIC_CODE_FLAG_NO_OPTIMIZE : 0,
                    0, 0);
            }
          }
        }
        if (asm_cmd_special_none != special) {
          /* do the translation; first any status bits */
          if (PIC_OPCODE_NONE != macro_xlate[special].flag_op) {
            value_t status;
            value_t status_flag;

            status = pfile_value_find(pf, PFILE_LOG_ERR, "_status");
            status_flag = pfile_value_find(pf, PFILE_LOG_ERR, 
              macro_xlate[special].flag);
            asm_cmd_add(pf, macro_xlate[special].flag_op, status, 0,
              PIC_OPDST_NONE, status_flag, LABEL_NONE, PIC_CODE_FLAG_NO_OPTIMIZE,
              0, 0);
            value_release(status_flag);
            value_release(status);
          }
          op = macro_xlate[special].op;
          /* for lack of a better way to do this, I'm adding some special
             processing here */
          if (asm_cmd_special_movfw == special) {
            opdst = PIC_OPDST_W;
            value_release(n);
            n = VALUE_NONE;
          } else if (asm_cmd_special_tstf == special) {
            opdst = PIC_OPDST_F;
          } else if (asm_cmd_special_negf == special) {
            asm_cmd_add(pf, PIC_OPCODE_COMF, val, valofs, PIC_OPDST_F, VALUE_NONE,
              LABEL_NONE, PIC_CODE_FLAG_NO_OPTIMIZE, 0, 0);
          } else if ((asm_cmd_special_tblrd == special)
            || (asm_cmd_special_tblwt == special)) {
            /* tblrd/tblwt */
            pic_tblptr_change_t chg;
            boolean_t           tblerr;

            chg = PIC_TBLPTR_CHANGE_NONE;
            tblerr = BOOLEAN_FALSE;
            if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "*")) {
            } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE,
              "*+")) {
              chg = PIC_TBLPTR_CHANGE_POST_INC;
            } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE,
              "*-")) {
              chg = PIC_TBLPTR_CHANGE_POST_DEC;
            } else if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE,
              "+*")) {
              chg = PIC_TBLPTR_CHANGE_PRE_INC;
            } else {
              pfile_log(pf, PFILE_LOG_ERR, 
                "One of '*', '*+', '*-', '+*' required!");
              tblerr = BOOLEAN_TRUE;
            }
            if (BOOLEAN_FALSE == tblerr) {
              n = pfile_constant_get(pf, chg, VARIABLE_DEF_NONE);
              pf_token_get(pf, PF_TOKEN_NEXT);
            }
          }
        }
        if (PIC_OPTYPE_F_D == asm_cmds[ii].type) {
          opdst = value_const_get(n) ? PIC_OPDST_F : PIC_OPDST_W;
          value_release(n);
          n = VALUE_NONE;
        }

        asm_cmd_add(pf, op, val, valofs, opdst, n, lbl, PIC_CODE_FLAG_NO_OPTIMIZE,
          0, 0);
        label_release(lbl);
        value_release(n);
        value_release(val);
      }
    }
  }
}

void jal_parse_assembler(pfile_t *pf, const pfile_pos_t *statement_start)
{
  pfile_pos_t pos_start;

  pf_token_start_get(pf, &pos_start);
  pfile_block_enter(pf);
  while (!pf_token_is_eof(pf)
    && !pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "end")) {
    pfile_token_ct_t token_ct;

    token_ct = pfile_token_ct_get(pf);
    pf_token_start_get(pf, &pos_start);
    pfile_statement_start_set(pf, &pos_start);
    if (pf_token_is(pf, PF_TOKEN_CURRENT, PFILE_LOG_NONE, "pragma")) {
      /* allow pragmas in assembler blocks. who knew? */
      pf_token_get(pf, PF_TOKEN_NEXT);
      jal_parse_pragma(pf, statement_start);
    } else {
      jal_parse_asm(pf, statement_start);
    }
    /* if nothing has been parsed we need to skip the current token */
    if (token_ct == pfile_token_ct_get(pf)) {
      pf_token_get(pf, PF_TOKEN_NEXT);
    }
  }
  if (pf_token_is(pf, PF_TOKEN_NEXT, PFILE_LOG_ERR, "assembler")) {
    pf_token_get(pf, PF_TOKEN_NEXT);
  } else {
    jal_block_start_show(pf, "ASSEMBLER", statement_start);
  }

  pfile_block_leave(pf);
  pf_token_start_get(pf, &pos_start);
  pfile_statement_start_set(pf, &pos_start);
}

