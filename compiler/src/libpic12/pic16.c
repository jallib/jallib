/************************************************************
 **
 ** pic16.c : 16-bit pic code generation definitions
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include "pic16.h"

boolean_t pic16_code_to_pcode(pfile_t *pf, pic_code_t code,
    unsigned val, unsigned literal, pic_code_to_pcode_t *pdst)
{
  unsigned pcode_lo;
  unsigned pcode_hi;
  unsigned dst;
  unsigned access;
  unsigned bit;
  unsigned lit1;
  unsigned lit8;
  unsigned lit11;
  unsigned lit12;
  ulong    lit20;
  unsigned shadow;
  unsigned ct;

  bit     = (literal & 0x07) << 9;
  lit1    = literal & 0x00000001; /*  1 bit literal */
  lit8    = literal & 0x000000ff; /*  8 bit literal */
  lit11   = literal & 0x000007ff; /* 11 bit literal */
  lit12   = literal & 0x00000fff; /* 12 bit literal */
  lit20   = literal & 0x000fffff; /* 20 bit literal */
  dst     = (PIC_OPDST_F == pic_code_dst_get(code)) << 9;
  access  = value_is_shared(pic_code_value_get(code))
              ? 0U : 0x0100U;
  shadow  = 0;
  pcode_lo= 0xffff; /* an impossible code (it's greater than 14 bits) */
  pcode_hi= 0x0000;
  ct      = 1;
  switch (pic_code_op_get(code)) {
    /* directives (no code) */
    case PIC_OPCODE_ORG:    /* ORG xxxx */
    case PIC_OPCODE_END:    /* END      */
    case PIC_OPCODE_NONE:   /* no code here */
      ct = 0;
      break;
    case PIC_OPCODE_NOP:    
      pcode_lo = 0x0000; 
      ct       = 1;
      break;
    /* file operator (code, dst, val) */
    case PIC_OPCODE_CLRF:   pcode_lo = 0x6a00 |       access | val; break;
    case PIC_OPCODE_CPFSEQ: pcode_lo = 0x6200 |       access | val; break;
    case PIC_OPCODE_CPFSGT: pcode_lo = 0x6400 |       access | val; break;
    case PIC_OPCODE_CPFSLT: pcode_lo = 0x6000 |       access | val; break;
    case PIC_OPCODE_MOVWF:  pcode_lo = 0x6e00 |       access | val; break;
    case PIC_OPCODE_MULWF:  pcode_lo = 0x0200 |       access | val; break;
    case PIC_OPCODE_NEGF:   pcode_lo = 0x6c00 |       access | val; break;
    case PIC_OPCODE_SETF:   pcode_lo = 0x6800 |       access | val; break;
    case PIC_OPCODE_TSTFSZ: pcode_lo = 0x6600 |       access | val; break;
    case PIC_OPCODE_ADDWF:  pcode_lo = 0x2400 | dst | access | val; break;
    case PIC_OPCODE_ADDWFc: pcode_lo = 0x2000 | dst | access | val; break;
    case PIC_OPCODE_ANDWF:  pcode_lo = 0x1400 | dst | access | val; break;
    case PIC_OPCODE_COMF:   pcode_lo = 0x1c00 | dst | access | val; break;
    case PIC_OPCODE_DECF:   pcode_lo = 0x0400 | dst | access | val; break;
    case PIC_OPCODE_DECFSZ: pcode_lo = 0x2c00 | dst | access | val; break;
    case PIC_OPCODE_DCFSNZ: pcode_lo = 0x4c00 | dst | access | val; break;
    case PIC_OPCODE_INCF:   pcode_lo = 0x2800 | dst | access | val; break;
    case PIC_OPCODE_INCFSZ: pcode_lo = 0x3c00 | dst | access | val; break;
    case PIC_OPCODE_INFSNZ: pcode_lo = 0x4800 | dst | access | val; break;
    case PIC_OPCODE_IORWF:  pcode_lo = 0x1000 | dst | access | val; break;
    case PIC_OPCODE_MOVF:   pcode_lo = 0x5000 | dst | access | val; break;
    case PIC_OPCODE_RLCF:
    case PIC_OPCODE_RLF:    pcode_lo = 0x3400 | dst | access | val; break;
    case PIC_OPCODE_RLNCF:  pcode_lo = 0x4400 | dst | access | val; break;
    case PIC_OPCODE_RRCF:
    case PIC_OPCODE_RRF:    pcode_lo = 0x3000 | dst | access | val; break;
    case PIC_OPCODE_RRNCF:  pcode_lo = 0x4000 | dst | access | val; break;
    case PIC_OPCODE_SUBFWB: pcode_lo = 0x5400 | dst | access | val; break;
    case PIC_OPCODE_SUBWF:  pcode_lo = 0x5c00 | dst | access | val; break;
    case PIC_OPCODE_SUBWFB: pcode_lo = 0x5800 | dst | access | val; break;
    case PIC_OPCODE_SWAPF:  pcode_lo = 0x3800 | dst | access | val; break;
    case PIC_OPCODE_XORWF:  pcode_lo = 0x1800 | dst | access | val; break;
    /* simple opcodes (no operands) */
    case PIC_OPCODE_CLRWDT: pcode_lo = 0x0004; break;
    case PIC_OPCODE_DAW:    pcode_lo = 0x0007; break;
    case PIC_OPCODE_RETFIE: pcode_lo = 0x0010 | lit1; break;
    case PIC_OPCODE_RETURN: pcode_lo = 0x0012 | lit1; break;
    case PIC_OPCODE_PUSH:   pcode_lo = 0x0005; break;
    case PIC_OPCODE_POP:    pcode_lo = 0x0006; break;
    case PIC_OPCODE_RESET:  pcode_lo = 0x00ff; break;
    case PIC_OPCODE_SLEEP:  pcode_lo = 0x0003; break;
    /* bit oriented (3 bit literal) */
    case PIC_OPCODE_BCF:    pcode_lo = 0x9000 | bit | access | val; break;
    case PIC_OPCODE_BSF:    pcode_lo = 0x8000 | bit | access | val; break;
    case PIC_OPCODE_BTFSC:  pcode_lo = 0xb000 | bit | access | val; break;
    case PIC_OPCODE_BTFSS:  pcode_lo = 0xa000 | bit | access | val; break;
    case PIC_OPCODE_BTG:    pcode_lo = 0x7000 | bit | access | val; break;
    /* literal & w  (8 bit literal) */
    case PIC_OPCODE_MOVLW:  pcode_lo = 0x0e00 | lit8; break;
    case PIC_OPCODE_RETLW:  pcode_lo = 0x0c00 | lit8; break;
    case PIC_OPCODE_IORLW:  pcode_lo = 0x0900 | lit8; break;
    case PIC_OPCODE_ANDLW:  pcode_lo = 0x0b00 | lit8; break;
    case PIC_OPCODE_XORLW:  pcode_lo = 0x0a00 | lit8; break;
    case PIC_OPCODE_SUBLW:  pcode_lo = 0x0800 | lit8; break;
    case PIC_OPCODE_ADDLW:  pcode_lo = 0x0f00 | lit8; break;
    case PIC_OPCODE_MULLW:  pcode_lo = 0x0d00 | lit8; break;
    case PIC_OPCODE_MOVLB:  pcode_lo = 0x0100 | lit8; break;
    /* branching (8 or 9 bit literal)
       nb: on the 16 bit cores, absolute goto & absolute call are
           *word* based, so divide lit here */
    case PIC_OPCODE_CALL:   lit20 /= 2;
                            pcode_lo = 0xec00U 
                                       | (unsigned) (lit20 & 0x000000ff)
                                       | shadow;
                            pcode_hi = 0xf000U 
                                       | (unsigned) (lit20 >> 8);
                            ct       = 2;
                            break;
    case PIC_OPCODE_GOTO:   lit20 /= 2;
                            pcode_lo = 0xef00U 
                                       | (unsigned) (lit20 & 0x000000ff);
                            pcode_hi = 0xf000U 
                                       | (unsigned) (lit20 >> 8);
                            ct       = 2;
                            break;
    case PIC_OPCODE_BC:     pcode_lo = 0xe200 | lit8; break;
    case PIC_OPCODE_BN:     pcode_lo = 0xe600 | lit8; break;
    case PIC_OPCODE_BNC:    pcode_lo = 0xe300 | lit8; break;
    case PIC_OPCODE_BNN:    pcode_lo = 0xe700 | lit8; break;
    case PIC_OPCODE_BNOV:   pcode_lo = 0xe500 | lit8; break;
    case PIC_OPCODE_BNZ:    pcode_lo = 0xe100 | lit8; break;
    case PIC_OPCODE_BOV:    pcode_lo = 0xe400 | lit8; break;
    case PIC_OPCODE_BZ:     pcode_lo = 0xe000 | lit8; break;
    case PIC_OPCODE_BRA:    pcode_lo = 0xd000 | lit11; break;
    case PIC_OPCODE_RCALL:  pcode_lo = 0xd800 | lit11; break;
    /* special (pseudo) opcodes */
    case PIC_OPCODE_DB: /* this is handled elsewhere */
      break;
    case PIC_OPCODE_LFSR:
      {
        unsigned base;
        value_t  bval;

        bval = pic_code_value_get(code);
        base = value_base_get(bval)
              + value_const_get(value_baseofs_get(bval))
              + pic_code_ofs_get(code);
        pcode_lo = 0xee00 | (pic_code_fsr_n_get(code) << 4) | (base >> 8);
        pcode_hi = 0xf000 | (base & 0x00ff);
        ct = 2;
      }
      break;
    case PIC_OPCODE_TBLRD:
      pcode_lo = 0x0008 | (lit12 & 0x03);
      break;
    case PIC_OPCODE_TBLWT:
      pcode_lo = 0x000c | (lit12 & 0x03);
      break;
    case PIC_OPCODE_MOVFF:
    case PIC_OPCODE_BRANCHLO_CLR:
    case PIC_OPCODE_BRANCHLO_SET:
    case PIC_OPCODE_BRANCHLO_NOP:
    case PIC_OPCODE_BRANCHHI_CLR:
    case PIC_OPCODE_BRANCHHI_SET:
    case PIC_OPCODE_BRANCHHI_NOP:
    case PIC_OPCODE_DATALO_CLR:
    case PIC_OPCODE_DATALO_SET:
    case PIC_OPCODE_DATAHI_CLR:
    case PIC_OPCODE_DATAHI_SET:
    case PIC_OPCODE_IRP_SET:
    case PIC_OPCODE_IRP_CLR:
    case PIC_OPCODE_CLRW:
    case PIC_OPCODE_TRIS:         /* tris 6 or 7 */
    case PIC_OPCODE_OPTION:       /* option */
    case PIC_OPCODE_MOVLP:
    case PIC_OPCODE_MOVLP_NOP:
      pfile_log(pf, PFILE_LOG_ERR, "illegal instruction");
      ct = 0;
      break;
  }
  pdst->ct      = ct;
  pdst->code[0] = pcode_lo;
  pdst->code[1] = pcode_hi;
  return pdst->ct != 0;
}

