/************************************************************
 **
 ** pic_emu.c : PIC instruction emulator
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <string.h>
#include <assert.h>

#include "../libcore/cmd.h"
#include "piccolst.h"
#include "pic_inst.h"
#include "pic_var.h"

#include "pic_emu.h"

#define PIC_DATA_MEM_SIZE   0x1000
#define PIC_CALL_STACK_SIZE 8

#define PIC_SFR_STATUS_C     0
#define PIC_SFR_STATUS_DC    1
#define PIC_SFR_STATUS_Z     2
#define PIC16_SFR_STATUS_OV  3
#define PIC16_SFR_STATUS_N   4
#define PIC14_SFR_STATUS_RP0 5
#define PIC14_SFR_STATUS_RP1 6
#define PIC14_SFR_STATUS_IRP 7

#define BIT(n) (1U << n)

unsigned pic_emu_instr_ct;

typedef struct SFR_region_ {
  unsigned lo;
  unsigned hi;
} SFR_region_t;

#define PIC_DECODE_FLAG_NONE   0x0000
#define PIC_DECODE_FLAG_SHADOW 0x0001

typedef enum {
  PIC_DECODE_TBL_ACTION_NONE,
  PIC_DECODE_TBL_ACTION_POST_INC,
  PIC_DECODE_TBL_ACTION_POST_DEC,
  PIC_DECODE_TBL_ACTION_PRE_INC
} pic_decode_tbl_action_t;

typedef enum {
  PIC_DECODE_OP_TYPE_NULL, /* nothing */
  PIC_DECODE_OP_TYPE_LIT8, /* bit 7..0  = 8-bit literal */
  PIC_DECODE_OP_TYPE_A,    /* bit 8 = a, 7..0 = f */
  PIC_DECODE_OP_TYPE_DA,   /* bit 9 = d, 8 = a, 7..0 = f */
  PIC_DECODE_OP_TYPE_BR,   /* bit 7..0 = branch offset */
  PIC_DECODE_OP_TYPE_BIT,  /* bit 11..9 = bit, 8 = a, 7..0 = f */
  PIC_DECODE_OP_TYPE_BR11, /* bit 10..0 = branch offset */
  PIC_DECODE_OP_TYPE_CALL, /* bit 8 = s, 7..0 = dst (low) 11..0 = dst(hi) */
  PIC_DECODE_OP_TYPE_GOTO, /* bit 7..0 = dst (low), 11..0 = dst(hi)       */
  PIC_DECODE_OP_TYPE_LFSR, /* bit 5..4 = which, 3..0 & 7..0 = f           */
  PIC_DECODE_OP_TYPE_MOVFF,/* bit 11..0 = src, 11..0 = dst */
  PIC_DECODE_OP_TYPE_RET,  /* bit 0 = 0 (na) 1 (restore shadow registers) */
  PIC_DECODE_OP_TYPE_TBL,  /* bit 0..1 = action */
  PIC_DECODE_OP_TYPE_TRIS
} pic_decode_op_type_t;

typedef struct {
  unsigned             mask;
  unsigned             value;
  pic_opcode_t         op;
  pic_decode_op_type_t type;
} pic_decode_info_t;

typedef struct pic_decode_ {
  pic_opcode_t            op;
  ushort                  f;          /* fully translated file register  */
  ushort                  f1;         /* fully translated file register  */
  ulong                   n;          /* misc n (depends on instruction) */
  pic_decode_tbl_action_t tbl_action; /* see above */
  flag_t                  flags;      /* see above */
  pic_opdst_t             dst;
} pic_decode_t;

struct pic_emu_state_ {
  uchar     w;
  uchar    *mem;
  uchar    *imem;    /* bits 0..3 : # of times read
                             4..7 : # of times written */
  pic_target_cpu_t target;
  pic_code_t call_stack[PIC_CALL_STACK_SIZE];
  unsigned   call_stack_ptr;

  boolean_t (*pic_decode)(pfile_t *pf, const pic_emu_state_t state,
      const pic_code_to_pcode_t *pcode, pic_decode_t *dst);

  size_t              SFR_region_ct;
  const SFR_region_t *SFR_regions;

  unsigned            status;
};

#define PIC_EMU_DATA_MEM_READ_FLAG_NONE 0x0000
#define PIC_EMU_DATA_MEM_READ_FLAG_CHECK 0x0001

/* read a byte from data memory */
static uchar pic_emu_data_mem_read(
    const pic_emu_state_t  state, 
    const pfile_pos_t     *fpos,
    unsigned               mem,
    flag_t                 flags)
{
  if ((flags & PIC_EMU_DATA_MEM_READ_FLAG_CHECK)
    && (0 == ((state->imem[mem] & 0xf0)))) {
    printf("%s:%u uninitialized memory read (%u)!\n", 
        (fpos) ? pfile_source_name_get(fpos->src) : "internal", 
        (fpos) ? fpos->line : 0,
        mem);
  }
  if ((state->imem[mem] & 0x0f) != 0x0f) {
    state->imem[mem]++;
  }
  return state->mem[mem];
}

/* write a byte to data memory; d = 0(W) 1(F) */
static void pic_emu_data_mem_write(
    pic_emu_state_t    state,
    const pfile_pos_t *fpos,
    unsigned           mem, 
    uchar              ch)
{
  UNUSED(fpos);

  if ((state->imem[mem] & 0xf0) != 0xf0) {
    state->imem[mem] += 0x10;
  }
  state->mem[mem] = ch;
}

static void pic_emu_status_bit_change(
    pic_emu_state_t state, const pfile_pos_t *fpos, unsigned mask, 
    unsigned val)
{
  pic_emu_data_mem_write(state, fpos, state->status,
      (pic_emu_data_mem_read(state, fpos, state->status, 
                             PIC_EMU_DATA_MEM_READ_FLAG_NONE)
      & ~mask) | val);
}

static boolean_t pic_emu_status_bit_test(const pic_emu_state_t state,
    unsigned bit)
{
  return (state->mem[state->status] & BIT(bit)) != 0;
}

static void pic_emu_arithmetic_write(
    pic_emu_state_t    state, 
    const pfile_pos_t *fpos,
    unsigned           mem,
    unsigned           n,
    pic_opdst_t        dst,
    unsigned           status_bits)
{
  if (status_bits & BIT(PIC_SFR_STATUS_C)) {
    pic_emu_status_bit_change(state, fpos, BIT(PIC_SFR_STATUS_C),
        (n > 255) ? BIT(PIC_SFR_STATUS_C) : 0);
  }
  n &= 0xff;
  if (status_bits & BIT(PIC_SFR_STATUS_Z)) {
    pic_emu_status_bit_change(state, fpos, BIT(PIC_SFR_STATUS_Z),
        (0 == n) ? BIT(PIC_SFR_STATUS_Z) : 0);
  }
  switch (dst) {
    case PIC_OPDST_W:
      state->w = (uchar) n;
      break;
    case PIC_OPDST_NONE: 
      /* assert(0);  */
      /* break; */
    case PIC_OPDST_F:
      pic_emu_data_mem_write(state, fpos, mem, (uchar) n);
      break;
  }
}

#define PIC14_SFR_IND        0x0000 /* all    */
#define PIC14_SFR_TMR0       0x0001 /* 0x0101 */
#define PIC14_SFR_OPTION_REG 0x0081 /* 0x0181 */
#define PIC14_SFR_PCL        0x0002 /* all    */
#define PIC14_SFR_STATUS     0x0003 /* all    */
#define PIC14_SFR_FSR        0x0004 /* all    */
#define PIC14_SFR_PORTB      0x0006 /* 0x0106 */
#define PIC14_SFR_TRISB      0x0086 /* 0x0186 */
#define PIC14_SFR_PCLATH     0x000a /* all    */
#define PIC14_SFR_INTCON     0x000b /* all    */
/* 0x0070 - 0x007f == shared */

static const SFR_region_t SFR_regions14[] = {
  {0x000, 0x01f},
  {0x080, 0x09f},
  {0x100, 0x10f},
  {0x180, 0x18f}
};

static ushort pic_decode14_f_xlate(pfile_t *pf, const pic_emu_state_t state,
    ushort f)
{
  UNUSED(pf);

  if (f < 0x0070) {
    if (PIC14_SFR_IND == f) {
      f = state->mem[PIC14_SFR_FSR] 
        | ((state->mem[PIC14_SFR_STATUS] & BIT(PIC14_SFR_STATUS_IRP)) << 1U);
    } else if ((PIC14_SFR_TMR0 == f) 
        || (PIC14_SFR_OPTION_REG == f)
        || (PIC14_SFR_PORTB == f)
        || (PIC14_SFR_TRISB == f)) {
      f |= (state->mem[PIC14_SFR_STATUS] & BIT(PIC14_SFR_STATUS_RP0)) << 2U;
    } else if ((PIC14_SFR_PCL     != f)
        && (PIC14_SFR_STATUS  != f)
        && (PIC14_SFR_FSR     != f)
        && (PIC14_SFR_PCLATH  != f)
        && (PIC14_SFR_INTCON  != f)) {
      f |= (state->mem[PIC14_SFR_STATUS] 
          & (BIT(PIC14_SFR_STATUS_RP1) | BIT(PIC14_SFR_STATUS_RP0))) << 2U;
    }
  }
  return f;
}

static boolean_t pic_decode14(pfile_t *pf, const pic_emu_state_t state,
    const pic_code_to_pcode_t *ppcode, pic_decode_t *dst)
{
  static const pic_decode_info_t decode[] = {
    {0x3fff, 0x0064, PIC_OPCODE_CLRWDT, PIC_DECODE_OP_TYPE_NULL },
    {0x3fff, 0x0063, PIC_OPCODE_SLEEP,  PIC_DECODE_OP_TYPE_NULL },
    {0x3fff, 0x0009, PIC_OPCODE_RETFIE, PIC_DECODE_OP_TYPE_NULL },
    {0x3fff, 0x0008, PIC_OPCODE_RETURN, PIC_DECODE_OP_TYPE_NULL },
    {0x3f9f, 0x0000, PIC_OPCODE_NOP,    PIC_DECODE_OP_TYPE_NULL },
    {0x3f80, 0x0080, PIC_OPCODE_MOVWF,  PIC_DECODE_OP_TYPE_A    },
    {0x3f00, 0x3a00, PIC_OPCODE_XORLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x3f00, 0x3900, PIC_OPCODE_ANDLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x3f00, 0x3800, PIC_OPCODE_IORLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x3f00, 0x0f00, PIC_OPCODE_INCFSZ, PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0e00, PIC_OPCODE_SWAPF,  PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0d00, PIC_OPCODE_RLF,    PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0c00, PIC_OPCODE_RRF,    PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0b00, PIC_OPCODE_DECFSZ, PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0a00, PIC_OPCODE_INCF,   PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0900, PIC_OPCODE_COMF,   PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0800, PIC_OPCODE_MOVF,   PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0700, PIC_OPCODE_ADDWF,  PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0600, PIC_OPCODE_XORWF,  PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0500, PIC_OPCODE_ANDWF,  PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0400, PIC_OPCODE_IORWF,  PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0300, PIC_OPCODE_DECF,   PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0200, PIC_OPCODE_SUBWF,  PIC_DECODE_OP_TYPE_DA   },
    {0x3f00, 0x0100, PIC_OPCODE_CLRF,   PIC_DECODE_OP_TYPE_DA   },
    {0x3e00, 0x3e00, PIC_OPCODE_ADDLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x3e00, 0x3c00, PIC_OPCODE_SUBLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x3c00, 0x3400, PIC_OPCODE_RETLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x3c00, 0x3000, PIC_OPCODE_MOVLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x3c00, 0x1c00, PIC_OPCODE_BTFSS,  PIC_DECODE_OP_TYPE_BIT  },
    {0x3c00, 0x1800, PIC_OPCODE_BTFSC,  PIC_DECODE_OP_TYPE_BIT  },
    {0x3c00, 0x1400, PIC_OPCODE_BSF,    PIC_DECODE_OP_TYPE_BIT  },
    {0x3c00, 0x1000, PIC_OPCODE_BCF,    PIC_DECODE_OP_TYPE_BIT  },
    {0x3800, 0x2800, PIC_OPCODE_GOTO,   PIC_DECODE_OP_TYPE_GOTO },
    {0x3800, 0x2000, PIC_OPCODE_CALL,   PIC_DECODE_OP_TYPE_CALL },
  };
  unsigned pcode;
  size_t   ii;

  pcode = ppcode->code[0];

  for (ii = 0; 
      (ii < COUNT(decode))
      && ((pcode & decode[ii].mask) != decode[ii].value);
       ii++)
    ;
  if (ii == COUNT(decode)) {
    abort();
  } else {
    dst->op = decode[ii].op;
    switch (decode[ii].type) {
      case PIC_DECODE_OP_TYPE_NULL:
         break;
      case PIC_DECODE_OP_TYPE_LIT8:
         dst->n = pcode & 0xff;
         break;
      case PIC_DECODE_OP_TYPE_A:
         dst->f = pic_decode14_f_xlate(pf, state, pcode & 0x7f);
         break;
      case PIC_DECODE_OP_TYPE_DA:
         dst->dst = (pcode & 0x80) ? PIC_OPDST_F : PIC_OPDST_W;
         dst->f   = pic_decode14_f_xlate(pf, state, pcode & 0x7f);
         break;
      case PIC_DECODE_OP_TYPE_BIT:
         dst->n   = (pcode >> 7) & 0x07;
         dst->f   = pic_decode14_f_xlate(pf, state, pcode & 0x7f);
         break;
      case PIC_DECODE_OP_TYPE_CALL:
      case PIC_DECODE_OP_TYPE_GOTO:
         dst->n   = ((state->mem[PIC14_SFR_PCLATH] & 0x18) << 8U)
           | (pcode & 0x03ff);
         break;
      case PIC_DECODE_OP_TYPE_LFSR:
      case PIC_DECODE_OP_TYPE_BR:
      case PIC_DECODE_OP_TYPE_BR11:
      case PIC_DECODE_OP_TYPE_MOVFF:
      case PIC_DECODE_OP_TYPE_RET:
      case PIC_DECODE_OP_TYPE_TBL:
      case PIC_DECODE_OP_TYPE_TRIS:
         assert(0);
         abort();
         break;
    }
  }
  return (ii < COUNT(decode));
}

#define PIC16_SFR_BSR      0x0fe0
#define PIC16_SFR_INFD0    0x0fef
#define PIC16_SFR_POSTINC0 0x0fee
#define PIC16_SFR_POSTDEC0 0x0fed
#define PIC16_SFR_PREINC0  0x0fec
#define PIC16_SFR_PLUSW0   0x0feb
#define PIC16_SFR_FSR0H    0x0fea
#define PIC16_SFR_FSR0L    0x0fe9
#define PIC16_SFR_INFD1    0x0fe7
#define PIC16_SFR_POSTINC1 0x0fe6
#define PIC16_SFR_POSTDEC1 0x0fe5
#define PIC16_SFR_PREINC1  0x0fe4
#define PIC16_SFR_PLUSW1   0x0fe3
#define PIC16_SFR_FSR1H    0x0fe2
#define PIC16_SFR_FSR1L    0x0fe1
#define PIC16_SFR_INFD2    0x0fdf
#define PIC16_SFR_POSTINC2 0x0fde
#define PIC16_SFR_POSTDEC2 0x0fdd
#define PIC16_SFR_PREINC2  0x0fdc
#define PIC16_SFR_PLUSW2   0x0fdb
#define PIC16_SFR_FSR2H    0x0fda
#define PIC16_SFR_FSR2L    0x0fd9
#define PIC16_SFR_PRODL    0x0ff3
#define PIC16_SFR_PRODH    0x0ff4
#if 0
static const SFR_region_t SFR_regions16[] = {
  { 0x0f80, 0x0fff }
};
#endif

static ushort pic_decode16_f_xlate(pfile_t *pf, const pic_emu_state_t state,
    ushort f)
{
  unsigned n;

  UNUSED(pf);

  if (f & 0x0100) {
    /* use BSR as the top 4 bits */
    f = (f & 0xff) | (state->mem[PIC16_SFR_BSR] << 8U);
  } else {
    /* either the first or last half of memory */
    if (f >= 0x80) {
      f |= 0x0f00;
    }
  }
  /* f might have further meaning */
  n = 0xffff;
  switch (f) {
    case PIC16_SFR_INFD0:
    case PIC16_SFR_POSTINC0:
    case PIC16_SFR_POSTDEC0:
    case PIC16_SFR_PREINC0:
    case PIC16_SFR_PLUSW0:
      n = PIC16_SFR_FSR0H;
      break;
    case PIC16_SFR_INFD1:
    case PIC16_SFR_POSTINC1:
    case PIC16_SFR_POSTDEC1:
    case PIC16_SFR_PREINC1:
    case PIC16_SFR_PLUSW1:
      n = PIC16_SFR_FSR1H;
      break;
    case PIC16_SFR_INFD2:
    case PIC16_SFR_POSTINC2:
    case PIC16_SFR_POSTDEC2:
    case PIC16_SFR_PREINC2:
    case PIC16_SFR_PLUSW2:
      n = PIC16_SFR_FSR2H;
      break;
  }
  if (0xffff != n) {
    switch (f) {
      case PIC16_SFR_INFD0:
      case PIC16_SFR_INFD1:
      case PIC16_SFR_INFD2:
        f = (state->mem[n] << 8UL) | state->mem[n - 1];
        break; /* non change */
      case PIC16_SFR_POSTINC0:
      case PIC16_SFR_POSTINC1:
      case PIC16_SFR_POSTINC2:
        f = (state->mem[n] << 8UL) | state->mem[n - 1];
        if (0 == (++state->mem[n - 1])) {
          ++state->mem[n];
        }
        break;
      case PIC16_SFR_POSTDEC0:
      case PIC16_SFR_POSTDEC1:
      case PIC16_SFR_POSTDEC2:
        f = (state->mem[n] << 8UL) | state->mem[n - 1];
        if (0 == (state->mem[n - 1]--)) {
          state->mem[n]--;
        }
        break;
      case PIC16_SFR_PREINC0:
      case PIC16_SFR_PREINC1:
      case PIC16_SFR_PREINC2:
        if (0 == (++state->mem[n - 1])) {
          ++state->mem[n];
        }
        f = (state->mem[n] << 8UL) | state->mem[n - 1];
        break;
      case PIC16_SFR_PLUSW0:
      case PIC16_SFR_PLUSW1:
      case PIC16_SFR_PLUSW2:
        if (((255 - state->w) > state->mem[n - 1])) {
          state->mem[n]++;
        }
        state->mem[n - 1] += state->w;
        f = (state->mem[n] << 8UL) | state->mem[n - 1];
        break;
    }
  }
  return f;
}

static boolean_t pic_decode16(pfile_t *pf, const pic_emu_state_t state,
    const pic_code_to_pcode_t *ppcode, pic_decode_t *dst)
{
  size_t ii;

  pic_decode_info_t decode[] = {
    { 0xffff, 0x00ff, PIC_OPCODE_RESET,  PIC_DECODE_OP_TYPE_NULL  },
    { 0xffff, 0x0007, PIC_OPCODE_DAW,    PIC_DECODE_OP_TYPE_NULL  },
    { 0xffff, 0x0006, PIC_OPCODE_POP,    PIC_DECODE_OP_TYPE_NULL  },
    { 0xffff, 0x0005, PIC_OPCODE_PUSH,   PIC_DECODE_OP_TYPE_NULL  },
    { 0xffff, 0x0004, PIC_OPCODE_CLRWDT, PIC_DECODE_OP_TYPE_NULL  },
    { 0xffff, 0x0003, PIC_OPCODE_SLEEP,  PIC_DECODE_OP_TYPE_NULL  },
    { 0xffff, 0x0000, PIC_OPCODE_NOP,    PIC_DECODE_OP_TYPE_NULL  },
    { 0xfffe, 0x0012, PIC_OPCODE_RETURN, PIC_DECODE_OP_TYPE_RET   },
    { 0xfffe, 0x0010, PIC_OPCODE_RETFIE, PIC_DECODE_OP_TYPE_RET   },
    { 0xfffc, 0x000c, PIC_OPCODE_TBLWT,  PIC_DECODE_OP_TYPE_TBL   },
    { 0xfffc, 0x0008, PIC_OPCODE_TBLRD,  PIC_DECODE_OP_TYPE_TBL   },
    { 0xffc0, 0xee00, PIC_OPCODE_LFSR,   PIC_DECODE_OP_TYPE_LFSR  },
    { 0xff00, 0xef00, PIC_OPCODE_GOTO,   PIC_DECODE_OP_TYPE_GOTO  },
    { 0xff00, 0xe700, PIC_OPCODE_BNN,    PIC_DECODE_OP_TYPE_BR    },
    { 0xff00, 0xe600, PIC_OPCODE_BN,     PIC_DECODE_OP_TYPE_BR    },
    { 0xff00, 0xe500, PIC_OPCODE_BNOV,   PIC_DECODE_OP_TYPE_BR    },
    { 0xff00, 0xe400, PIC_OPCODE_BOV,    PIC_DECODE_OP_TYPE_BR    },
    { 0xff00, 0xe300, PIC_OPCODE_BNC,    PIC_DECODE_OP_TYPE_BR    },
    { 0xff00, 0xe200, PIC_OPCODE_BC,     PIC_DECODE_OP_TYPE_BR    },
    { 0xff00, 0xe100, PIC_OPCODE_BNZ,    PIC_DECODE_OP_TYPE_BR    },
    { 0xff00, 0xe000, PIC_OPCODE_BZ,     PIC_DECODE_OP_TYPE_BR    },
    { 0xff00, 0x0f00, PIC_OPCODE_ADDLW,  PIC_DECODE_OP_TYPE_LIT8  },
    { 0xff00, 0x0e00, PIC_OPCODE_MOVLW,  PIC_DECODE_OP_TYPE_LIT8  },
    { 0xff00, 0x0d00, PIC_OPCODE_MULLW,  PIC_DECODE_OP_TYPE_LIT8  },
    { 0xff00, 0x0c00, PIC_OPCODE_RETLW,  PIC_DECODE_OP_TYPE_LIT8  },
    { 0xff00, 0x0b00, PIC_OPCODE_ANDLW,  PIC_DECODE_OP_TYPE_LIT8  },
    { 0xff00, 0x0a00, PIC_OPCODE_XORLW,  PIC_DECODE_OP_TYPE_LIT8  },
    { 0xff00, 0x0900, PIC_OPCODE_IORLW,  PIC_DECODE_OP_TYPE_LIT8  },
    { 0xff00, 0x0800, PIC_OPCODE_SUBLW,  PIC_DECODE_OP_TYPE_LIT8  },
    { 0xff00, 0x0100, PIC_OPCODE_MOVLB,  PIC_DECODE_OP_TYPE_LIT8  },
    { 0xfe00, 0xec00, PIC_OPCODE_CALL,   PIC_DECODE_OP_TYPE_CALL  },
    { 0xfe00, 0x6e00, PIC_OPCODE_MOVWF,  PIC_DECODE_OP_TYPE_A     },
    { 0xfe00, 0x6c00, PIC_OPCODE_NEGF,   PIC_DECODE_OP_TYPE_A     },
    { 0xfe00, 0x6a00, PIC_OPCODE_CLRF,   PIC_DECODE_OP_TYPE_A     },
    { 0xfe00, 0x6800, PIC_OPCODE_SETF,   PIC_DECODE_OP_TYPE_A     },
    { 0xfe00, 0x6600, PIC_OPCODE_TSTFSZ, PIC_DECODE_OP_TYPE_A     },
    { 0xfe00, 0x6400, PIC_OPCODE_CPFSGT, PIC_DECODE_OP_TYPE_A     },
    { 0xfe00, 0x6200, PIC_OPCODE_CPFSEQ, PIC_DECODE_OP_TYPE_A     },
    { 0xfe00, 0x6000, PIC_OPCODE_CPFSLT, PIC_DECODE_OP_TYPE_A     },
    { 0xfe00, 0x0200, PIC_OPCODE_MULWF,  PIC_DECODE_OP_TYPE_A     },
    { 0xfc00, 0x5c00, PIC_OPCODE_SUBWF,  PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x5800, PIC_OPCODE_SUBWFB, PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x5400, PIC_OPCODE_SUBFWB, PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x5000, PIC_OPCODE_MOVF,   PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x4c00, PIC_OPCODE_DCFSNZ, PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x4800, PIC_OPCODE_INFSNZ, PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x4400, PIC_OPCODE_RLNCF,  PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x4000, PIC_OPCODE_RRNCF,  PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x3c00, PIC_OPCODE_INCFSZ, PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x3800, PIC_OPCODE_SWAPF,  PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x3400, PIC_OPCODE_RLF,    PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x3000, PIC_OPCODE_RRF,    PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x2c00, PIC_OPCODE_DECFSZ, PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x2800, PIC_OPCODE_INCF,   PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x2400, PIC_OPCODE_ADDWF,  PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x2000, PIC_OPCODE_ADDWFc, PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x1c00, PIC_OPCODE_COMF,   PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x1800, PIC_OPCODE_XORWF,  PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x1400, PIC_OPCODE_ANDWF,  PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x1000, PIC_OPCODE_IORWF,  PIC_DECODE_OP_TYPE_DA    },
    { 0xfc00, 0x0400, PIC_OPCODE_DECF,   PIC_DECODE_OP_TYPE_DA    },
    { 0xf800, 0xd800, PIC_OPCODE_RCALL,  PIC_DECODE_OP_TYPE_BR11  },
    { 0xf800, 0xd000, PIC_OPCODE_BRA,    PIC_DECODE_OP_TYPE_BR11  },
    { 0xf000, 0xc000, PIC_OPCODE_MOVFF,  PIC_DECODE_OP_TYPE_MOVFF },
    { 0xf000, 0xb000, PIC_OPCODE_BTFSC,  PIC_DECODE_OP_TYPE_BIT   },
    { 0xf000, 0xa000, PIC_OPCODE_BTFSS,  PIC_DECODE_OP_TYPE_BIT   },
    { 0xf000, 0x9000, PIC_OPCODE_BCF,    PIC_DECODE_OP_TYPE_BIT   },
    { 0xf000, 0x8000, PIC_OPCODE_BSF,    PIC_DECODE_OP_TYPE_BIT   },
    { 0xf000, 0x7000, PIC_OPCODE_BTG,    PIC_DECODE_OP_TYPE_BIT   }
  };

  dst->op         = PIC_OPCODE_NONE;
  dst->f          = 0x0000;
  dst->f1         = 0x0000;
  dst->n          = 0x0000;
  dst->tbl_action = PIC_DECODE_TBL_ACTION_NONE;
  dst->flags      = 0x0000;
  dst->dst        = PIC_OPDST_NONE;

  for (ii = 0; 
       (ii < COUNT(decode))
       && ((ppcode->code[0] & decode[ii].mask)
         != decode[ii].value);
       ii++)
    ;
  if (ii == COUNT(decode)) {
    abort();
  } else {
    dst->op = decode[ii].op;
    switch (decode[ii].type) {
      case PIC_DECODE_OP_TYPE_NULL:
        break;
      case PIC_DECODE_OP_TYPE_LIT8:
      case PIC_DECODE_OP_TYPE_BR:
        dst->n = ppcode->code[0] & 0xff;
        break;
      case PIC_DECODE_OP_TYPE_DA:
        dst->dst = (ppcode->code[0] & 0x0200)
                   ? PIC_OPDST_F
                   : PIC_OPDST_W;
        /* fall through */
      case PIC_DECODE_OP_TYPE_A:
        dst->f = pic_decode16_f_xlate(pf, state, ppcode->code[0] & 0x01ff);
        break;
      case PIC_DECODE_OP_TYPE_BIT:
        dst->f = pic_decode16_f_xlate(pf, state, ppcode->code[0] & 0x01ff);
        dst->n = (ppcode->code[0] >> 9) & 0x07;
        break;
      case PIC_DECODE_OP_TYPE_BR11:
        dst->n = ppcode->code[0] & 0x07ff;
        break;
      case PIC_DECODE_OP_TYPE_CALL:
        if ((ppcode->code[0] >> 8) & 0x01) {
          dst->flags |= PIC_DECODE_FLAG_SHADOW;
        }
        /* fall through */
      case PIC_DECODE_OP_TYPE_GOTO:
        dst->n = ((ppcode->code[1] & 0x0fff) << 8UL) 
                 | (ppcode->code[0] & 0xff);
        break;
      case PIC_DECODE_OP_TYPE_LFSR:
        dst->n = (ppcode->code[0] >> 4) & 0x03;
        dst->f = ((ppcode->code[0] & 0x0f) << 8)
                 | (ppcode->code[1] & 0xff);
        break;
      case PIC_DECODE_OP_TYPE_MOVFF:
        dst->f     = ppcode->code[0] & 0x0fff;
        dst->f1    = ppcode->code[1] & 0x0fff;
        break;
      case PIC_DECODE_OP_TYPE_RET:
        if (ppcode->code[0] & 0x01) {
          dst->flags |= PIC_DECODE_FLAG_SHADOW;
        }
        break;
      case PIC_DECODE_OP_TYPE_TBL:
        dst->n     = ppcode->code[0] & 0x03;
        break;
      case PIC_DECODE_OP_TYPE_TRIS:
        assert(0);
        abort();
        break;
    }
  }
  return BOOLEAN_TRUE;
}

static const SFR_region_t SFR_regions12[] = {
  {0x000, 0x01f}
};

#define PIC12_SFR_IND    0x0000
#define PIC12_SFR_STATUS 0x0003
#define PIC12_SFR_FSR    0x0004
static ushort pic_decode12_f_xlate(pfile_t *pf, const pic_emu_state_t state,
    ushort f)
{
  UNUSED(pf);

  if (f >= 0x0010) {
    if (PIC12_SFR_IND == f) {
      f = state->mem[PIC12_SFR_FSR] & 0x3f;
    } else {
      f |= state->mem[PIC12_SFR_FSR] & 0x60;
    }
  }
  return f;
}

static boolean_t pic_decode12(pfile_t *pf, const pic_emu_state_t state,
    const pic_code_to_pcode_t *ppcode, pic_decode_t *dst)
{
  static const pic_decode_info_t decode[] = {
    {0x0fff, 0x0040, PIC_OPCODE_CLRW,   PIC_DECODE_OP_TYPE_NULL },
    {0x0fff, 0x0004, PIC_OPCODE_CLRWDT, PIC_DECODE_OP_TYPE_NULL },
    {0x0fff, 0x0003, PIC_OPCODE_SLEEP,  PIC_DECODE_OP_TYPE_NULL },
    {0x0fff, 0x0002, PIC_OPCODE_OPTION, PIC_DECODE_OP_TYPE_NULL },
    {0x0fff, 0x0000, PIC_OPCODE_NOP,    PIC_DECODE_OP_TYPE_NULL }, 
    {0x0ff8, 0x0007, PIC_OPCODE_TRIS,   PIC_DECODE_OP_TYPE_TRIS },
    {0x0fe0, 0x0060, PIC_OPCODE_CLRF,   PIC_DECODE_OP_TYPE_A    },
    {0x0fe0, 0x0020, PIC_OPCODE_MOVWF,  PIC_DECODE_OP_TYPE_A    },
    {0x0fc0, 0x03c0, PIC_OPCODE_INCFSZ, PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x0380, PIC_OPCODE_SWAPF,  PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x0340, PIC_OPCODE_RLF,    PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x0300, PIC_OPCODE_RRF,    PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x02c0, PIC_OPCODE_DECFSZ, PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x0280, PIC_OPCODE_INCF,   PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x0240, PIC_OPCODE_COMF,   PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x0200, PIC_OPCODE_MOVF,   PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x01c0, PIC_OPCODE_ADDWF,  PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x0180, PIC_OPCODE_XORWF,  PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x0140, PIC_OPCODE_ANDWF,  PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x0100, PIC_OPCODE_IORWF,  PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x00c0, PIC_OPCODE_DECF,   PIC_DECODE_OP_TYPE_DA   },
    {0x0fc0, 0x0080, PIC_OPCODE_SUBWF,  PIC_DECODE_OP_TYPE_DA   },
    {0x0f00, 0x0f00, PIC_OPCODE_XORLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x0f00, 0x0e00, PIC_OPCODE_ANDLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x0f00, 0x0d00, PIC_OPCODE_IORLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x0f00, 0x0c00, PIC_OPCODE_MOVLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x0f00, 0x0900, PIC_OPCODE_CALL,   PIC_DECODE_OP_TYPE_CALL },
    {0x0f00, 0x0800, PIC_OPCODE_RETLW,  PIC_DECODE_OP_TYPE_LIT8 },
    {0x0f00, 0x0700, PIC_OPCODE_BTFSS,  PIC_DECODE_OP_TYPE_BIT  },
    {0x0f00, 0x0600, PIC_OPCODE_BTFSC,  PIC_DECODE_OP_TYPE_BIT  },
    {0x0f00, 0x0500, PIC_OPCODE_BSF,    PIC_DECODE_OP_TYPE_BIT  },
    {0x0f00, 0x0400, PIC_OPCODE_BCF,    PIC_DECODE_OP_TYPE_BIT  },
    {0x0e00, 0x0a00, PIC_OPCODE_GOTO,   PIC_DECODE_OP_TYPE_GOTO },
  };
  unsigned pcode;
  size_t   ii;

  pcode = ppcode->code[0];

  for (ii = 0; 
      (ii < COUNT(decode))
      && ((pcode & decode[ii].mask) != decode[ii].value);
       ii++)
    ;
  if (ii == COUNT(decode)) {
    assert(0);
    abort();
  } else {
    dst->op = decode[ii].op;
    switch (decode[ii].type) {
      case PIC_DECODE_OP_TYPE_NULL:
        break;
      case PIC_DECODE_OP_TYPE_LIT8:
        dst->n = pcode & 0xff;
        break;
      case PIC_DECODE_OP_TYPE_A:
        dst->f = pic_decode12_f_xlate(pf, state, pcode & 0x1f);
        break;
      case PIC_DECODE_OP_TYPE_DA:
        dst->dst = (pcode & 0x20) ? PIC_OPDST_F : PIC_OPDST_W;
        dst->f = pic_decode12_f_xlate(pf, state, pcode & 0x1f);
        break;
      case PIC_DECODE_OP_TYPE_BIT:
        dst->n = (pcode >> 5) & 0x07;
        dst->f = pic_decode12_f_xlate(pf, state, pcode & 0x1f);
        break;
      case PIC_DECODE_OP_TYPE_CALL:
        dst->n = (pcode & 0x00ff)
          | ((state->mem[PIC12_SFR_STATUS] & 0x60) << 4U);
        break;
      case PIC_DECODE_OP_TYPE_GOTO:
        dst->n = (pcode & 0x01ff) 
          | ((state->mem[PIC12_SFR_STATUS] & 0x60) << 4U);
        break;
      case PIC_DECODE_OP_TYPE_TRIS:
        dst->n = pcode & 0x07;
        break;
      case PIC_DECODE_OP_TYPE_RET:
      case PIC_DECODE_OP_TYPE_LFSR:
      case PIC_DECODE_OP_TYPE_MOVFF:
      case PIC_DECODE_OP_TYPE_TBL:
      case PIC_DECODE_OP_TYPE_BR:
      case PIC_DECODE_OP_TYPE_BR11:
        assert(0);
        abort();
        break;
    }
  }
  return (ii < COUNT(decode));
}

pic_emu_state_t pic_emu_state_alloc(pfile_t *pf, pic_target_cpu_t cpu)
{
  pic_emu_state_t  state;

  state = malloc(sizeof(*state));
  state->w       = 0;
  state->mem     = calloc(PIC_DATA_MEM_SIZE, sizeof(*state->mem));
  state->imem    = calloc(PIC_DATA_MEM_SIZE, sizeof(*state->imem));
  state->call_stack_ptr = 0;
  state->target = cpu;
  pic_target_cpu_set(pf, cpu);
  switch (cpu) {
    case PIC_TARGET_CPU_NONE:
    case PIC_TARGET_CPU_SX_12:
      break;
    case PIC_TARGET_CPU_12BIT:
      state->SFR_region_ct          = COUNT(SFR_regions12);
      state->SFR_regions            = SFR_regions12;
      state->pic_decode             = pic_decode12;
      state->status                 = 0x0003;
      pic_target_bank_size_set(pf, 0x20);
      pic_target_page_size_set(pf, 0x0200);
      break;
    case PIC_TARGET_CPU_14BIT:
    case PIC_TARGET_CPU_14HBIT:
      state->SFR_region_ct          = COUNT(SFR_regions14);
      state->SFR_regions            = SFR_regions14;
      state->pic_decode             = pic_decode14;
      pic_target_bank_size_set(pf, 0x80);
      pic_target_page_size_set(pf, 0x0800);
      state->status                 = 0x0003;
      break;
    case PIC_TARGET_CPU_16BIT:
      state->SFR_region_ct          = 0;
      state->SFR_regions            = 0;
      state->pic_decode             = pic_decode16;
      pic_target_bank_size_set(pf, 0x0100);
      pic_target_page_size_set(pf, 0x8000);
      state->status                 = 0x0fd8;
      break;
  }
  pic_emu_data_mem_init(state);
  return state;
}

void pic_emu_state_free(pic_emu_state_t state)
{
  /*label_release(state->lbl_entry);*/
  free(state->imem);
  free(state->mem);
  free(state);
}

variable_const_t pic_emu_value_read(const pic_emu_state_t state,
                   const value_t val, const pfile_pos_t *fpos)
{
  variable_const_t cn;

  if (VARIABLE_NONE == value_variable_get(val)) {
    cn = pic_emu_w_get(state);
  } else {
    variable_sz_t    ii;
    variable_base_t  base;
    uchar            ch;

    base = value_base_get(val);
    ch = 0;
    for (ii = 0, cn = 0; ii < value_byte_sz_get(val); ii++, base++) {
      ch  = pic_emu_data_mem_read(state, fpos, value_base_get(val) + ii,
          PIC_EMU_DATA_MEM_READ_FLAG_CHECK);
      cn |= ch << (8UL * ii);
    }
    if (value_is_signed(val) && (ch & 0x80)) {
      while (ii < 4) {
        cn |= 0xff << (8UL * ii);
        ii++;
      }
    }
    if (value_is_bit(val)) {
      cn >>= value_bit_offset_get(val);
      cn &= (1 << value_sz_get(val)) - 1;
      if (value_is_signed(val) 
          && (cn & (1 << (value_sz_get(val) - 1)))) {
        cn = -cn;
      }
    }
  }
  return cn;
}

void pic_emu_value_write(pic_emu_state_t state,
                   const value_t val, variable_const_t cn,
                   const pfile_pos_t *fpos)
{
  if (VARIABLE_NONE == value_variable_get(val)) {
    pic_emu_w_set(state, cn);
  } else {
    variable_sz_t ii;

    if (value_is_bit(val)) {
      if (value_is_boolean(val)) {
        cn = (cn) ? 1 : 0;
      } else {
        cn &= ((1UL << value_sz_get(val)) - 1);
      }
      cn <<= value_bit_offset_get(val);
    }
    for (ii = 0; ii < value_sz_get(val); ii++, cn >>= 8) {
      pic_emu_data_mem_write(state, fpos, value_base_get(val) + ii, 
          (uchar) cn);
    }
  }
}

/* determine if a volatile variable was accessed more than once */
void pic_emu_volatile_check(const pic_emu_state_t state, 
                   const value_t val)
{
  if (value_is_volatile(val)) {
    variable_base_t base;
    variable_sz_t   ii;

    base = value_base_get(val);
    for (ii = 0; ii < value_sz_get(val); ii++, base++) {
      uchar ch;
      
      assert(base < PIC_DATA_MEM_SIZE);
      ch = state->imem[base];
      ch = (ch & 0x0f) + (ch >> 4);
      assert(ch < 2);
    }
  }
}

uchar pic_emu_w_get(const pic_emu_state_t state)
{
  return (state) ? state->w : 0;
}

void pic_emu_w_set(pic_emu_state_t state, uchar cn)
{
  if (state) {
    state->w = cn;
  }
}

void pic_emu_data_mem_init(pic_emu_state_t state)
{
  size_t ii;
  static const uchar deadbeaf[] = {0xde, 0xad, 0xbe, 0xef};

  /* setup the SFR regions */
  memset(state->imem, 0, sizeof(*state->imem));

  for (ii = 0; ii < state->SFR_region_ct; ii++) {
    size_t jj;

    for (jj = state->SFR_regions[ii].lo; 
         jj <= state->SFR_regions[ii].hi; 
         jj++) {
      state->imem[jj] = 0xff;
    }
  }
  for (ii = 0; ii < PIC_DATA_MEM_SIZE; ii++) {
    if (!state->imem[ii]) {
      state->mem[ii] = deadbeaf[ii % sizeof(deadbeaf)];
    }
  }
}

static pic_code_t pic_code_next_exec_get(pic_code_t code)
{
  do {
    code = pic_code_next_get(code);
  } while ((PIC_CODE_NONE != code) && !pic_code_is_exec(code));
  return code;
}

/* execute a single instruction */
pic_code_t pic_emu_instr(pfile_t *pf,
    pic_emu_state_t state, const pic_code_t code)
{
  FILE       *old_asm;
  FILE       *old_hex;
  pic_code_t  next;
  pfile_pos_t fpos;
  cmd_t       cmd;

  /* probably a really cheezy way to show each line, but hey! */
  if (!pfile_flag_test(pf, PFILE_FLAG_MISC_QUIET)) {
    old_hex = pfile_hex_file_set(pf, 0);
    old_asm = pfile_asm_file_set(pf, stdout);
    printf("%4lu: ", pic_code_pc_get(code));
    pic_code_dump(pf, code);
    pfile_asm_file_set(pf, old_asm);
    pfile_hex_file_set(pf, old_hex);
  }
  pic_emu_instr_ct++;
  next  = pic_code_next_exec_get(code);
  cmd   = pic_code_cmd_get(code);
  fpos.src  = cmd_source_get(cmd);
  fpos.line = cmd_line_get(cmd);
  if (CMD_TYPE_ASSERT == cmd_type_get(cmd)) {
    value_t val;

    val = cmd_assert_value_get(cmd);
    if ((!value_is_const(val) && !pic_emu_value_read(state, val, &fpos)) 
        || (value_is_const(val) && !value_const_get(val))) {
      pfile_pos_t pos;

      cmd_pos_get(cmd, &pos);
      pfile_statement_start_set(pf, &pos);
      pfile_log(pf, PFILE_LOG_ERR, "assertion failed\n");
      /*abort();*/
    }
  } else {
    pic_code_to_pcode_t pcode;

    if (pic_code_to_pcode(pf, code, &pcode)) {
      pic_decode_t dst;

      dst.op         = PIC_OPCODE_NONE;
      dst.f          = (ushort) -1;
      dst.f1         = (ushort) -1;
      dst.n          = (ulong)  -1;
      dst.tbl_action = PIC_DECODE_TBL_ACTION_NONE;
      dst.flags      = (flag_t) -1;
      dst.dst        = PIC_OPDST_NONE;

      if (!state->pic_decode(pf, state, &pcode, &dst)) {
        printf("cannot find: %s\n", pic_opcode_str(pic_code_op_get(code)));
      } else {
        value_t         val;
        variable_base_t valpos;

        val    = pic_code_value_get(code);
        valpos = 0xffff;

        if ((VALUE_NONE != val) 
            && (PIC_OPCODE_MOVLW      != dst.op)
            && (PIC_OPCODE_DATALO_SET != pic_code_op_get(code))
            && (PIC_OPCODE_DATALO_CLR != pic_code_op_get(code))
            && (PIC_OPCODE_DATAHI_SET != pic_code_op_get(code))
            && (PIC_OPCODE_DATAHI_CLR != pic_code_op_get(code))
            && (PIC_OPCODE_IRP_SET    != pic_code_op_get(code))
            && (PIC_OPCODE_IRP_CLR    != pic_code_op_get(code))) {
          if (value_is_const(val)) {
            valpos = value_const_get(val);
          } else if (value_base_get(val) == 0) {
            valpos = 0;
          } else {
            valpos = value_base_get(val);
            if (PIC16_SFR_INFD0 == valpos) {
              valpos = state->mem[PIC16_SFR_FSR0L]
                | (state->mem[PIC16_SFR_FSR0H] << 8U);
            } else {
              valpos += value_const_get(value_baseofs_get(val))
                + value_bit_offset_get(val) / 8
                + pic_code_ofs_get(code);
            }
            if (valpos != dst.f) {
              fprintf(stderr, "valpos (0x%04x) != dst.f (0x%-4x) at 0x%04x\n",
                (unsigned) valpos,
                (unsigned) dst.f,
                (unsigned) pic_code_pc_get(code));
              abort();
            }
          }
        }
        switch (dst.op) {
          case PIC_OPCODE_ORG:
          case PIC_OPCODE_END:
          case PIC_OPCODE_NONE:
          case PIC_OPCODE_DATALO_SET:
          case PIC_OPCODE_DATALO_CLR:
          case PIC_OPCODE_DATAHI_SET:
          case PIC_OPCODE_DATAHI_CLR:
          case PIC_OPCODE_IRP_SET:
          case PIC_OPCODE_IRP_CLR:
          case PIC_OPCODE_BRANCHLO_SET:
          case PIC_OPCODE_BRANCHLO_CLR:
          case PIC_OPCODE_BRANCHLO_NOP:
          case PIC_OPCODE_BRANCHHI_SET:
          case PIC_OPCODE_BRANCHHI_CLR:
          case PIC_OPCODE_BRANCHHI_NOP:
          case PIC_OPCODE_DB:
          case PIC_OPCODE_OPTION:
          case PIC_OPCODE_TRIS:
            assert(0);
            break;
          case PIC_OPCODE_SUBWF:
          case PIC_OPCODE_ADDWF:
          case PIC_OPCODE_ADDWFc:
          case PIC_OPCODE_SUBFWB:
          case PIC_OPCODE_SUBWFB:
            {
              unsigned  n0;
              unsigned  n1;
              unsigned  n2;

              n1 = pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK) & 0xff;
              n2 = state->w;

              if ((PIC_OPCODE_SUBWF == dst.op) 
                  || (PIC_OPCODE_SUBWFB == dst.op)) {
                n2 = -n2;
              }
              if (PIC_OPCODE_SUBFWB == dst.op) {
                n1 = -n1;
              }
              n0 = n1 + n2;

              if (pic_emu_status_bit_test(state, PIC_SFR_STATUS_C)
                  && (PIC_OPCODE_ADDWFc == dst.op)) {
                n0++;
              } else if (!pic_emu_status_bit_test(state, PIC_SFR_STATUS_C)
                  && ((PIC_OPCODE_SUBFWB == dst.op) 
                    || (PIC_OPCODE_SUBWFB == dst.op))) {
                  n0--;
              }

              /* reverse the polarity for subtract */
              if ((PIC_OPCODE_SUBWF == dst.op)
                || (PIC_OPCODE_SUBWFB == dst.op)
                || (PIC_OPCODE_SUBFWB == dst.op)) {
                if (n0 < 0x0100) {
                  n0 |= 0x0100; /* set status<c> */
                } else {
                  n0 &= 0x00ff; /* reset status<c> */
                }
              }

              pic_emu_arithmetic_write(state, &fpos, dst.f, n0, dst.dst,
                BIT(PIC_SFR_STATUS_C) | BIT(PIC_SFR_STATUS_Z));
            }
            break;
          case PIC_OPCODE_ANDWF:
            pic_emu_arithmetic_write(state, &fpos, dst.f,
              pic_emu_data_mem_read(state, &fpos, dst.f, 
                PIC_EMU_DATA_MEM_READ_FLAG_CHECK) & state->w, 
              dst.dst, BIT(PIC_SFR_STATUS_Z));
            break;
          case PIC_OPCODE_XORWF:
            pic_emu_arithmetic_write(state, &fpos, dst.f,
              pic_emu_data_mem_read(state, &fpos, dst.f, 
                PIC_EMU_DATA_MEM_READ_FLAG_CHECK) ^ state->w,
              dst.dst, BIT(PIC_SFR_STATUS_Z));
            break;
          case PIC_OPCODE_IORWF:
            pic_emu_arithmetic_write(state, &fpos, dst.f,
              pic_emu_data_mem_read(state,  &fpos, dst.f,
                PIC_EMU_DATA_MEM_READ_FLAG_CHECK) | state->w,
              dst.dst, BIT(PIC_SFR_STATUS_Z));
            break;
          case PIC_OPCODE_COMF:
            pic_emu_arithmetic_write(state, &fpos, dst.f,
              ~pic_emu_data_mem_read(state, &fpos, dst.f, 
                PIC_EMU_DATA_MEM_READ_FLAG_CHECK),
              dst.dst, BIT(PIC_SFR_STATUS_Z));
            break;
          case PIC_OPCODE_DECF:
          case PIC_OPCODE_DECFSZ:
          case PIC_OPCODE_DCFSNZ:
            {
              unsigned status_bits;

              status_bits = BIT(PIC_SFR_STATUS_Z);
              if (pic_is_16bit(pf)) {
                status_bits |= BIT(PIC_SFR_STATUS_C);
              }
              pic_emu_arithmetic_write(state, &fpos, dst.f,
                pic_emu_data_mem_read(state, &fpos, dst.f, 
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK) - 1,
                dst.dst, status_bits);
              if ((PIC_OPCODE_DECFSZ == dst.op)
                && (pic_emu_status_bit_test(state, PIC_SFR_STATUS_Z))) {
                next = pic_code_next_exec_get(next);
              } else if ((PIC_OPCODE_DCFSNZ == dst.op)
                && !(pic_emu_status_bit_test(state, PIC_SFR_STATUS_Z))) {
                next = pic_code_next_exec_get(next);
              }
            }
            break;
          case PIC_OPCODE_INCF:
          case PIC_OPCODE_INCFSZ:
          case PIC_OPCODE_INFSNZ:
            {
              unsigned status_bits;

              status_bits = BIT(PIC_SFR_STATUS_Z);
              if (pic_is_16bit(pf)) {
                status_bits |= BIT(PIC_SFR_STATUS_C);
              }
              pic_emu_arithmetic_write(state, &fpos, dst.f,
                pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK) + 1,
                dst.dst, status_bits);
              if ((PIC_OPCODE_INCFSZ == dst.op)
                && (pic_emu_status_bit_test(state, PIC_SFR_STATUS_Z))) {
                next = pic_code_next_exec_get(next);
              } else if ((PIC_OPCODE_INFSNZ == dst.op)
                && !(pic_emu_status_bit_test(state, PIC_SFR_STATUS_Z))) {
                next = pic_code_next_exec_get(next);
              }
            }
            break;
          case PIC_OPCODE_CPFSEQ:
          case PIC_OPCODE_CPFSLT:
          case PIC_OPCODE_CPFSGT:
            {
              unsigned mem;

              mem = pic_emu_data_mem_read(state, &fpos, dst.f, 
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK);
              if (((PIC_OPCODE_CPFSEQ == dst.op) && (mem == dst.n))
                  || ((PIC_OPCODE_CPFSLT == dst.op) && (mem < dst.n))
                  || ((PIC_OPCODE_CPFSGT == dst.op) && (mem > dst.n))) {
                next = pic_code_next_exec_get(next);
              }
            }
            break;
          case PIC_OPCODE_NEGF:
            pic_emu_arithmetic_write(state, &fpos, dst.f,
                -pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK),
                dst.dst, BIT(PIC_SFR_STATUS_Z) | BIT(PIC_SFR_STATUS_C));
            break;
          case PIC_OPCODE_SETF:
            pic_emu_data_mem_write(state, &fpos, dst.f, 0xff);
            break;
          case PIC_OPCODE_RLNCF:
            {
              unsigned mem;

              mem = pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK);
              mem = (mem << 1) | ((mem & 0x80) ? 1 : 0);
              pic_emu_arithmetic_write(state, &fpos, dst.f, mem,
                  dst.dst, BIT(PIC_SFR_STATUS_C));
            }
            break;
          case PIC_OPCODE_RRNCF:
            {
              unsigned mem;

              mem = pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK);
              mem = (mem >> 1) | ((mem & 0x01) ? 0x80 : 0x00);
              pic_emu_arithmetic_write(state, &fpos, dst.f, mem,
                  dst.dst, BIT(PIC_SFR_STATUS_C));
            }
            break;
          case PIC_OPCODE_RLCF:
          case PIC_OPCODE_RLF:
            {
              unsigned mem;

              mem = (pic_emu_data_mem_read(state, &fpos, dst.f,
                    PIC_EMU_DATA_MEM_READ_FLAG_CHECK) << 1)
                | ((pic_emu_status_bit_test(state, PIC_SFR_STATUS_C))
                  ? 1 : 0);
              pic_emu_arithmetic_write(state, &fpos, dst.f, mem,
                  dst.dst, BIT(PIC_SFR_STATUS_C));
            }
            break;
          case PIC_OPCODE_RRF:
          case PIC_OPCODE_RRCF:
            {
              unsigned mem;
              unsigned imem;

              mem = pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK);
              imem = mem;

              mem = (mem >> 1) 
                | ((pic_emu_status_bit_test(state, PIC_SFR_STATUS_C)) 
                ? 0x80 : 0x00);
              pic_emu_arithmetic_write(state, &fpos, dst.f, mem, dst.dst, 0);
              pic_emu_status_bit_change(state, &fpos, BIT(PIC_SFR_STATUS_C),
                  (imem & 0x01) ? BIT(PIC_SFR_STATUS_C) : 0);
            }
            break;
          case PIC_OPCODE_MOVF:
            pic_emu_arithmetic_write(state, &fpos, dst.f,
              pic_emu_data_mem_read(state, &fpos, dst.f,
                PIC_EMU_DATA_MEM_READ_FLAG_CHECK),
              dst.dst, BIT(PIC_SFR_STATUS_Z));
            break;
          case PIC_OPCODE_SWAPF:
            {
              unsigned ch;

              ch = pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK);
              ch = ((ch << 4) & 0xf0) | (ch >> 4);
              pic_emu_arithmetic_write(state, &fpos, dst.f, ch, dst.dst, 0);
            }
            break;
          case PIC_OPCODE_CLRF:
          case PIC_OPCODE_CLRW:
            pic_emu_arithmetic_write(state, &fpos, dst.f, 0, dst.dst,
                BIT(PIC_SFR_STATUS_Z));
            break;
          case PIC_OPCODE_MOVWF:
            pic_emu_data_mem_write(state, &fpos, dst.f, state->w);
            break;
          case PIC_OPCODE_NOP:
            break; /* duh! */
          case PIC_OPCODE_RETLW:
            state->w = dst.n;
            /* fall through */
          case PIC_OPCODE_RETFIE:
          case PIC_OPCODE_RETURN:
            state->call_stack_ptr = ((state->call_stack_ptr)
              ? state->call_stack_ptr : PIC_CALL_STACK_SIZE) - 1;
            next = state->call_stack[state->call_stack_ptr];
            break;
          case PIC_OPCODE_SLEEP:
            break;
          case PIC_OPCODE_CLRWDT:
            break;
          case PIC_OPCODE_BCF:
            /* don't check the read */
            pic_emu_data_mem_write(state, &fpos, dst.f,
                pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_NONE)
                & ~(1 << dst.n));
            break;
          case PIC_OPCODE_BSF:
            /* don't check the read */
            pic_emu_data_mem_write(state, &fpos, dst.f,
                pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_NONE)
                | (1 << dst.n));
            break;
          case PIC_OPCODE_BTFSC:
            if (!(pic_emu_data_mem_read(state, &fpos, dst.f,
                    PIC_EMU_DATA_MEM_READ_FLAG_CHECK)
                & (1 << dst.n))) {
              next = pic_code_next_exec_get(next);
            }
            break;
          case PIC_OPCODE_BTFSS:
            if (pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK)
                & (1 << dst.n)) {
              next = pic_code_next_exec_get(next);
            }
            break;
          case PIC_OPCODE_SUBLW:
            pic_emu_arithmetic_write(state, &fpos, 0,
                dst.n - state->w,
                PIC_OPDST_W, BIT(PIC_SFR_STATUS_C) | BIT(PIC_SFR_STATUS_Z));
            break;
          case PIC_OPCODE_ADDLW:
            pic_emu_arithmetic_write(state, &fpos, 0,
                dst.n + state->w,
                PIC_OPDST_W, BIT(PIC_SFR_STATUS_C) | BIT(PIC_SFR_STATUS_Z));
            break;
          case PIC_OPCODE_ANDLW:
            pic_emu_arithmetic_write(state, &fpos, 0,
                state->w & dst.n, PIC_OPDST_W, BIT(PIC_SFR_STATUS_Z));
            break;
          case PIC_OPCODE_IORLW:
            pic_emu_arithmetic_write(state, &fpos, 0,
                state->w | dst.n, PIC_OPDST_W, BIT(PIC_SFR_STATUS_Z));
            break;
          case PIC_OPCODE_MOVLW:
            pic_emu_arithmetic_write(state, &fpos, 0,
                dst.n, PIC_OPDST_W, 0);
            break;
          case PIC_OPCODE_XORLW:
            pic_emu_arithmetic_write(state, &fpos, 0,
                state->w ^ dst.n, PIC_OPDST_W, BIT(PIC_SFR_STATUS_Z));
            break;
          case PIC_OPCODE_CALL:
          case PIC_OPCODE_RCALL:
            state->call_stack[state->call_stack_ptr] = next;
            if (PIC_CALL_STACK_SIZE == ++state->call_stack_ptr) {
              state->call_stack_ptr = 0;
            }
            /* fall through */
          case PIC_OPCODE_GOTO:
          case PIC_OPCODE_BRA:
          case PIC_OPCODE_BC:
          case PIC_OPCODE_BN:
          case PIC_OPCODE_BNC:
          case PIC_OPCODE_BNN:
          case PIC_OPCODE_BNOV:
          case PIC_OPCODE_BNZ:
          case PIC_OPCODE_BOV:
          case PIC_OPCODE_BZ:
            /* almost all jumps are forward; calls are a crap shoot */
            if ((PIC_OPCODE_CALL == dst.op)
                || (PIC_OPCODE_RCALL == dst.op)
                || (PIC_OPCODE_GOTO == dst.op)
                || (PIC_OPCODE_BRA == dst.op)
                || ((PIC_OPCODE_BC == dst.op) 
                  && (pic_emu_status_bit_test(state, PIC_SFR_STATUS_C)))
                || ((PIC_OPCODE_BN == dst.op) 
                  && (pic_emu_status_bit_test(state, PIC16_SFR_STATUS_N)))
                || ((PIC_OPCODE_BNC == dst.op) 
                  && !(pic_emu_status_bit_test(state, PIC_SFR_STATUS_C)))
                || ((PIC_OPCODE_BNN == dst.op) 
                  && !(pic_emu_status_bit_test(state, PIC16_SFR_STATUS_N)))
                || ((PIC_OPCODE_BNOV == dst.op) 
                  && !(pic_emu_status_bit_test(state, PIC16_SFR_STATUS_OV)))
                || ((PIC_OPCODE_BNZ == dst.op) 
                  && !(pic_emu_status_bit_test(state, PIC_SFR_STATUS_Z)))
                || ((PIC_OPCODE_BOV == dst.op) 
                  && (pic_emu_status_bit_test(state, PIC16_SFR_STATUS_OV)))
                || ((PIC_OPCODE_BZ == dst.op) 
                  && (pic_emu_status_bit_test(state, PIC_SFR_STATUS_Z)))) {
              next = pic_code_next_get(code);
              while ((next != code)
                && (pic_code_label_get(next) != pic_code_brdst_get(code))) {
                next = pic_code_next_get(next);
                if (PIC_CODE_NONE == next) {
                  next = pic_code_list_head_get(pf);
                }
              }
              if (code == next) {
                printf("%s:%u jump destination not found: %s\n",
                  pfile_source_name_get(fpos.src), fpos.line,
                  label_name_get(pic_code_brdst_get(code)));
                abort();
              }
            }
            break;
          case PIC_OPCODE_TSTFSZ:
            if (!pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK)) {
              next = pic_code_next_exec_get(next);
            }
            break;
          case PIC_OPCODE_BTG:
            pic_emu_data_mem_write(state, &fpos, dst.f, 
                pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK)
                  ^ BIT(dst.n));
            break;
          case PIC_OPCODE_MOVLB:
            pic_emu_data_mem_write(state, &fpos, PIC16_SFR_BSR, dst.n);
            break;
          case PIC_OPCODE_LFSR:
            {
              unsigned fsr_base;

              fsr_base = 0x0000; /* fix compiler warning */
              switch (dst.n) {
                case 0: fsr_base = PIC16_SFR_FSR0L; break;
                case 1: fsr_base = PIC16_SFR_FSR1L; break;
                case 2: fsr_base = PIC16_SFR_FSR2L; break;
                case 3: abort();
              }
              pic_emu_data_mem_write(state, &fpos, fsr_base, dst.f & 0xff);
              pic_emu_data_mem_write(state, &fpos, fsr_base + 1, dst.f >> 8);
            }
            break;
          case PIC_OPCODE_MULWF:
            {
              unsigned n;

              n = (pic_emu_data_mem_read(state, &fpos, dst.f,
                  PIC_EMU_DATA_MEM_READ_FLAG_CHECK) & 0xff) * state->w;

              pic_emu_data_mem_write(state, &fpos, PIC16_SFR_PRODH, 
                  (n >> 8) & 0xff);
              pic_emu_data_mem_write(state, &fpos, PIC16_SFR_PRODL, 
                  n & 0xff);
            }
            break;
          case PIC_OPCODE_MULLW:
          case PIC_OPCODE_DAW:
          case PIC_OPCODE_PUSH:
          case PIC_OPCODE_POP:
          case PIC_OPCODE_RESET:
          case PIC_OPCODE_MOVFF:
          case PIC_OPCODE_TBLRD:
          case PIC_OPCODE_TBLWT:
          case PIC_OPCODE_MOVLP:
          case PIC_OPCODE_MOVLP_NOP:
            fprintf(stderr, "unsupported opcode: %s (pc=%u)\n",
                pic_opcode_str(dst.op), (unsigned) pic_code_pc_get(code));
            assert(0);
            abort();
            break;
        }
      }
    }
  }
  return next;
}

void pic_emu(pfile_t *pf, pic_emu_state_t state)
{
  pic_code_t code;

  state->mem[state->status] = 0;
  if (PIC_TARGET_CPU_14BIT == state->target) {
    state->mem[PIC14_SFR_PCLATH] = 0;
  }
  if (PIC_TARGET_CPU_16BIT == state->target) {
    state->mem[PIC16_SFR_BSR] = 0;
  }

  /* find the first executable instruction */
  for (code = pic_code_list_head_get(pf);
       (PIC_CODE_NONE != code)
       && !pic_code_is_exec(code);
       code = pic_code_next_get(code))
    ; /* empty body */
  while (PIC_CODE_NONE != code) {
     code = pic_emu_instr(pf, state, code);
  }
  if (!pfile_flag_test(pf, PFILE_FLAG_MISC_QUIET)) {
    printf("%u instructions executed\n", pic_emu_instr_ct);
  }
}

pic_target_cpu_t pic_emu_state_target_get(const pic_emu_state_t state)
{
  return (state) ? state->target : PIC_TARGET_CPU_NONE;
}

