/************************************************************
 **
 ** pic12.c : 12-bit pic code generation definitions
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include "pic12.h"

boolean_t pic12_code_to_pcode(pfile_t *pf, pic_code_t code,
    unsigned val, unsigned literal, pic_code_to_pcode_t *pdst)
{
  unsigned dst;
  unsigned bit;
  unsigned lit8;
  unsigned lit9; /* branch literal */
  unsigned pcode;

  bit   = literal & 0x07;
  lit8  = literal & 0x00ff; /* 8 bit literal */
  lit9  = literal & 0x01ff; /* 9 bit literal (goto) */
  dst   = (PIC_OPDST_F == pic_code_dst_get(code)) << 5;
  pcode = 0xffff; /* an impossible code (it's greater than 14 bits) */
  switch (pic_code_op_get(code)) {
    /* directives (no code) */
    case PIC_OPCODE_ORG:    /* ORG xxxx */
    case PIC_OPCODE_END:    /* END      */
    case PIC_OPCODE_NONE:   /* no code here */
    case PIC_OPCODE_BRANCHLO_NOP:
    case PIC_OPCODE_BRANCHHI_NOP:
      break;
    case PIC_OPCODE_NOP:    pcode = 0x0000; break;
    /* file operator (code, dst, val) */
    case PIC_OPCODE_MOVWF:  pcode = 0x0000 | 0x20 | val; break;
    case PIC_OPCODE_CLRF:   pcode = 0x0000 | 0x60 | val; break;
    case PIC_OPCODE_SUBWF:  pcode = 0x0080 |  dst | val; break;
    case PIC_OPCODE_DECF:   pcode = 0x00c0 |  dst | val; break;
    case PIC_OPCODE_IORWF:  pcode = 0x0100 |  dst | val; break;
    case PIC_OPCODE_ANDWF:  pcode = 0x0140 |  dst | val; break;
    case PIC_OPCODE_XORWF:  pcode = 0x0180 |  dst | val; break;
    case PIC_OPCODE_ADDWF:  pcode = 0x01c0 |  dst | val; break;
    case PIC_OPCODE_MOVF:   pcode = 0x0200 |  dst | val; break;
    case PIC_OPCODE_COMF:   pcode = 0x0240 |  dst | val; break;
    case PIC_OPCODE_INCF:   pcode = 0x0280 |  dst | val; break;
    case PIC_OPCODE_DECFSZ: pcode = 0x02c0 |  dst | val; break;
    case PIC_OPCODE_RRCF:
    case PIC_OPCODE_RRF:    pcode = 0x0300 |  dst | val; break;
    case PIC_OPCODE_RLCF:
    case PIC_OPCODE_RLF:    pcode = 0x0340 |  dst | val; break;
    case PIC_OPCODE_SWAPF:  pcode = 0x0380 |  dst | val; break;
    case PIC_OPCODE_INCFSZ: pcode = 0x03c0 |  dst | val; break;
    /* simple opcodes (no operands) */
    case PIC_OPCODE_RETFIE: pcode = 0xffff; break;
    case PIC_OPCODE_RETURN: pcode = 0xffff; break;
    case PIC_OPCODE_SLEEP:  pcode = 0x0003; break;
    case PIC_OPCODE_CLRWDT: pcode = 0x0004; break;
    case PIC_OPCODE_CLRW:   pcode = 0x0040; break;
    /* bit oriented (3 bit literal) */
    case PIC_OPCODE_BCF:    pcode = 0x0400 | (bit << 5) | val; break;
    case PIC_OPCODE_BSF:    pcode = 0x0500 | (bit << 5) | val; break;
    case PIC_OPCODE_BTFSC:  pcode = 0x0600 | (bit << 5) | val; break;
    case PIC_OPCODE_BTFSS:  pcode = 0x0700 | (bit << 5) | val; break;
    /* literal & w  (8 bit literal) */
    case PIC_OPCODE_MOVLW:  pcode = 0x0c00 | lit8; break;
    case PIC_OPCODE_RETLW:  pcode = 0x0800 | lit8; break;
    case PIC_OPCODE_IORLW:  pcode = 0x0d00 | lit8; break;
    case PIC_OPCODE_ANDLW:  pcode = 0x0e00 | lit8; break;
    case PIC_OPCODE_XORLW:  pcode = 0x0f00 | lit8; break;
    case PIC_OPCODE_SUBLW:
    case PIC_OPCODE_ADDLW:
       pfile_log(pf, PFILE_LOG_ERR, "%slw not supported!",
           (PIC_OPCODE_SUBLW == pic_code_op_get(code)) ? "sub" : "add");
       break;
    /* branching (8 or 9 bit literal) */
    case PIC_OPCODE_CALL:   
       if (lit9 > 256) {
         pfile_log(pf, PFILE_LOG_ERR, "call past 0x1ff");
       }
       pcode = 0x0900 | lit8; 
       break;
    case PIC_OPCODE_GOTO:   pcode = 0x0a00 | lit9; break;
    /* special (pseudo) opcodes */
    case PIC_OPCODE_DATALO_SET: /* bsf _fsr, 5 */
      pcode = 0x0500U | (5 << 5) | 0x0004;
      break;
    case PIC_OPCODE_DATALO_CLR: /* bcf _fsr, 5 */
      pcode = 0x0400U | (5 << 5) | 0x0004;
      break;
    case PIC_OPCODE_DATAHI_SET: /* bsf _fsr, 6 */
      pcode = 0x0500U | (6 << 5) | 0x0004;
      break;
    case PIC_OPCODE_DATAHI_CLR: /* bcf _fsr, 6 */
      pcode = 0x0400U | (6 << 5) | 0x0004;
      break;
    case PIC_OPCODE_IRP_SET:
    case PIC_OPCODE_IRP_CLR:
      pfile_log(pf, PFILE_LOG_ERR, "irp macros not supported");
      break;
    case PIC_OPCODE_BRANCHLO_SET: /* bsf _status, 5 */
      pcode = 0x0500U | (5 << 5) | 0x0003;
      break;
    case PIC_OPCODE_BRANCHLO_CLR: /* bcf _status, 5 */
      pcode = 0x0400U | (5 << 5) | 0x0003;
      break;
    case PIC_OPCODE_BRANCHHI_SET: /* bsf _status, 6 */
      pcode = 0x0500U | (6 << 5) | 0x0003;
      break;
    case PIC_OPCODE_BRANCHHI_CLR: /* bcf _status, 6 */
      pcode = 0x0400U | (6 << 5) | 0x0003;
      break;
    case PIC_OPCODE_OPTION:       /* option */
      pcode = 0x0002U;
      break;
    case PIC_OPCODE_TRIS:         /* tris 6 or 7 */
      pcode = lit8 & 0x07;
      break;
    case PIC_OPCODE_DB: /* this is handled elsewhere */
      break;
    case PIC_OPCODE_MULLW:
    case PIC_OPCODE_ADDWFc:
    case PIC_OPCODE_DCFSNZ:
    case PIC_OPCODE_INFSNZ:
    case PIC_OPCODE_RLNCF:
    case PIC_OPCODE_RRNCF:
    case PIC_OPCODE_SUBFWB:
    case PIC_OPCODE_SUBWFB:
    case PIC_OPCODE_CPFSEQ:
    case PIC_OPCODE_CPFSGT:
    case PIC_OPCODE_CPFSLT:
    case PIC_OPCODE_MULWF:
    case PIC_OPCODE_NEGF:
    case PIC_OPCODE_SETF:
    case PIC_OPCODE_TSTFSZ:
    case PIC_OPCODE_BTG:
    case PIC_OPCODE_BC:
    case PIC_OPCODE_BN:
    case PIC_OPCODE_BNC:
    case PIC_OPCODE_BNN:
    case PIC_OPCODE_BNOV:
    case PIC_OPCODE_BNZ:
    case PIC_OPCODE_BOV:
    case PIC_OPCODE_BZ:
    case PIC_OPCODE_BRA:
    case PIC_OPCODE_RCALL:
    case PIC_OPCODE_DAW:
    case PIC_OPCODE_POP:
    case PIC_OPCODE_PUSH:
    case PIC_OPCODE_RESET:
    case PIC_OPCODE_LFSR:
    case PIC_OPCODE_MOVFF:
    case PIC_OPCODE_MOVLB:
    case PIC_OPCODE_MOVLP:
    case PIC_OPCODE_MOVLP_NOP:
    case PIC_OPCODE_TBLRD:
    case PIC_OPCODE_TBLWT:
      pfile_log(pf, PFILE_LOG_ERR, "illegal instruction");
      break;
  }
  pdst->ct = 0;
  if (0xffffU != pcode) {
    pdst->ct      = 1;
    pdst->code[0] = pcode;
  }
  return pdst->ct != 0;
}

void pic12_asm_header_write(pfile_t *pf, variable_const_t n_code_sz)
{
  pfile_write(pf, pfile_write_asm, 
      "datahi_set macro val\n"
      "  bsf 4, 6 ; FSR<6>\n"
      "  endm\n");
  pfile_write(pf, pfile_write_asm,
      "datahi_clr macro val\n"
      "  bcf 4, 6 ; FSR<6>\n"
      "  endm\n");
  pfile_write(pf, pfile_write_asm,
      "datalo_set macro val\n"
      "  bsf 4, 5 ; FSR<5>\n"
      "  endm\n");
  pfile_write(pf, pfile_write_asm,
      "datalo_clr macro val\n"
      "  bcf 4, 5 ; FSR<5>\n"
      "  endm\n");
  pfile_write(pf, pfile_write_asm,
      "branchhi_set macro lbl\n"
      "  %s\n"
      "  endm\n",
      (n_code_sz < 1024) ? "nop" : "  bsf 3, 6 ; STATUS<6>");
  pfile_write(pf, pfile_write_asm,
      "branchhi_clr macro lbl\n"
      "  %s\n"
      "  endm\n",
      (n_code_sz < 1024) ? "nop" : "  bcf 3, 6 ; STATUS<6>");
  pfile_write(pf, pfile_write_asm,
      "branchlo_set macro lbl\n"
      "  %s\n"
      "  endm\n",
      (n_code_sz  < 512) ? "nop" : "  bsf 3, 5 ; STATUS<5>");
  pfile_write(pf, pfile_write_asm,
      "branchlo_clr macro lbl\n"
      "  %s\n"
      "  endm\n",
      (n_code_sz  < 512) ? "nop" : "  bcf 3, 5 ; STATUS<5>");
  if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_COMPILER)) {
    pfile_write(pf, pfile_write_asm,
        "branchhi_nop macro lbl\n"
        "  endm\n");
    pfile_write(pf, pfile_write_asm,
        "branchlo_nop macro lbl\n"
        "  endm\n");
  }
}

