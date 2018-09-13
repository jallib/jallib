/************************************************************
 **
 ** pic14.c : 14-bit pic code generation definitions
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include "pic14.h"

boolean_t pic14_code_to_pcode(pfile_t *pf, pic_code_t code,
    unsigned val, unsigned literal, pic_code_to_pcode_t *pdst)
{
  unsigned pcode;
  unsigned dst;
  unsigned bit;
  unsigned lit8;
  unsigned lit10; /* branch literal */

  bit     = literal & 0x07;
  lit8    = literal & 0x00ff; /* 8 bit literal */
  lit10   = literal & 0x07ff; /* 10 bit literal */
  dst     = (PIC_OPDST_F == pic_code_dst_get(code)) << 7;
  pcode   = 0xffff; /* an impossible code (it's greater than 14 bits) */
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
    case PIC_OPCODE_MOVWF:  pcode = 0x0000 | 0x80 | val; break;
    case PIC_OPCODE_CLRF:   pcode = 0x0100 | 0x80 | val; break;
    case PIC_OPCODE_SUBWF:  pcode = 0x0200 |  dst | val; break;
    case PIC_OPCODE_DECF:   pcode = 0x0300 |  dst | val; break;
    case PIC_OPCODE_IORWF:  pcode = 0x0400 |  dst | val; break;
    case PIC_OPCODE_ANDWF:  pcode = 0x0500 |  dst | val; break;
    case PIC_OPCODE_XORWF:  pcode = 0x0600 |  dst | val; break;
    case PIC_OPCODE_ADDWF:  pcode = 0x0700 |  dst | val; break;
    case PIC_OPCODE_MOVF:   pcode = 0x0800 |  dst | val; break;
    case PIC_OPCODE_COMF:   pcode = 0x0900 |  dst | val; break;
    case PIC_OPCODE_INCF:   pcode = 0x0a00 |  dst | val; break;
    case PIC_OPCODE_DECFSZ: pcode = 0x0b00 |  dst | val; break;
    case PIC_OPCODE_RRCF:
    case PIC_OPCODE_RRF:    pcode = 0x0c00 |  dst | val; break;
    case PIC_OPCODE_RLCF:
    case PIC_OPCODE_RLF:    pcode = 0x0d00 |  dst | val; break;
    case PIC_OPCODE_SWAPF:  pcode = 0x0e00 |  dst | val; break;
    case PIC_OPCODE_INCFSZ: pcode = 0x0f00 |  dst | val; break;
    /* simple opcodes (no operands) */
    case PIC_OPCODE_RETFIE: pcode = 0x0009; break;
    case PIC_OPCODE_RETURN: pcode = 0x0008; break;
    case PIC_OPCODE_SLEEP:  pcode = 0x0063; break;
    case PIC_OPCODE_CLRWDT: pcode = 0x0064; break;
    /* the following doesn't look right to me based on the microchip doc's, but
     * it is what MPLAB puts out */
    case PIC_OPCODE_CLRW:   pcode = 0x0103; break;
    /* bit oriented (3 bit literal) */
    case PIC_OPCODE_BCF:    pcode = 0x1000 | (bit << 7) | val; break;
    case PIC_OPCODE_BSF:    pcode = 0x1400 | (bit << 7) | val; break;
    case PIC_OPCODE_BTFSC:  pcode = 0x1800 | (bit << 7) | val; break;
    case PIC_OPCODE_BTFSS:  pcode = 0x1c00 | (bit << 7) | val; break;
    /* literal & w  (8 bit literal) */ 
    case PIC_OPCODE_MOVLW:  pcode = 0x3000 | lit8; break;
    case PIC_OPCODE_RETLW:  pcode = 0x3400 | lit8; break;
    case PIC_OPCODE_IORLW:  pcode = 0x3800 | lit8; break;
    case PIC_OPCODE_ANDLW:  pcode = 0x3900 | lit8; break;
    case PIC_OPCODE_XORLW:  pcode = 0x3a00 | lit8; break;
    case PIC_OPCODE_SUBLW:  pcode = 0x3c00 | lit8; break;
    case PIC_OPCODE_ADDLW:  pcode = 0x3e00 | lit8; break;
    /* branching (10 bit literal) */
    case PIC_OPCODE_CALL:   pcode = 0x2000 | lit10; break;
    case PIC_OPCODE_GOTO:   pcode = 0x2800 | lit10; break;
    /* special (pseudo) opcodes */
    case PIC_OPCODE_DATALO_SET: /* bsf _status, _rp0 */
      pcode = 0x1400U | (5 << 7) | 0x0003;
      break;
    case PIC_OPCODE_DATALO_CLR: /* bcf _status, _rp0 */
      pcode = 0x1000U | (5 << 7) | 0x0003;
      break;
    case PIC_OPCODE_DATAHI_SET: /* bsf _status, _rp1 */
      pcode = 0x1400U | (6 << 7) | 0x0003;
      break;
    case PIC_OPCODE_DATAHI_CLR: /* bcf _status, _rp1 */
      pcode = 0x1000U | (6 << 7) | 0x0003;
      break;
    case PIC_OPCODE_IRP_SET:    /* bsf _status, _irp */
      pcode = 0x1400U | (7 << 7) | 0x0003;
      break;
    case PIC_OPCODE_IRP_CLR:    /* bcf _status, _irp */
      pcode = 0x1000U | (7 << 7) | 0x0003;
      break;
    case PIC_OPCODE_BRANCHLO_SET: /* bsf _pclath: 3 */
      pcode = 0x1400U | (3 << 7) | 0x000a;
      break;
    case PIC_OPCODE_BRANCHLO_CLR: /* bcf _pclath: 3 */
      pcode = 0x1000U | (3 << 7) | 0x000a;
      break;
    case PIC_OPCODE_BRANCHHI_SET: /* bsf _pclath: 4 */
      pcode = 0x1400U | (4 << 7) | 0x000a;
      break;
    case PIC_OPCODE_BRANCHHI_CLR: /* bcf _pclath: 4 */
      pcode = 0x1000U | (4 << 7) | 0x000a;
      break;
    case PIC_OPCODE_OPTION:       /* option */
      pcode = 0x0002U;
      break;
    case PIC_OPCODE_TRIS:         /* tris 6 */
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
  if (0xffff != pcode) {
    pdst->ct      = 1;
    pdst->code[0] = pcode;
  }
  return pdst->ct != 0;
}

void pic14_asm_header_write(pfile_t *pf, variable_const_t n_code_sz)
{
  pfile_write(pf, pfile_write_asm, 
      "datahi_set macro val\n"
      "  bsf 3, 6 ; STATUS<rp1>\n"
      "  endm\n");
  pfile_write(pf, pfile_write_asm,
      "datahi_clr macro val\n"
      "  bcf 3, 6 ; STATUS<rp1>\n"
      "  endm\n");
  pfile_write(pf, pfile_write_asm,
      "datalo_set macro val\n"
      "  bsf 3, 5 ; STATUS<rp0>\n"
      "  endm\n");
  pfile_write(pf, pfile_write_asm,
      "datalo_clr macro val\n"
      "  bcf 3, 5 ; STATUS<rp0>\n"
      "  endm\n");
  pfile_write(pf, pfile_write_asm,
      "irp_clr macro\n"
      "  bcf 3, 7 ; STATUS<irp>\n"
      "  endm\n");
  pfile_write(pf, pfile_write_asm,
      "irp_set macro\n"
      "  bsf 3, 7 ; STATUS<irp>\n"
      "  endm\n");
  pfile_write(pf, pfile_write_asm,
      "branchhi_set macro lbl\n"
      "  %s\n"
      "  endm\n", 
      (n_code_sz < 4096) ? "nop" : "  bsf 10, 4 ; PCLATH<4>");
  pfile_write(pf, pfile_write_asm,
      "branchhi_clr macro lbl\n"
      "  %s\n"
      "  endm\n",
      (n_code_sz < 4096) ? "nop" : "  bcf 10, 4 ; PCLATH<4>");
  pfile_write(pf, pfile_write_asm,
      "branchlo_set macro lbl\n"
      "  %s\n"
      "  endm\n",
      (n_code_sz  < 2048) ? "nop" : "  bsf 10, 3 ; PCLATH<3>");
  pfile_write(pf, pfile_write_asm,
      "branchlo_clr macro lbl\n"
      "  %s\n"
      "  endm\n",
      (n_code_sz  < 2048) ? "nop" : "  bcf 10, 3 ; PCLATH<3>");
  if (pfile_flag_test(pf, PFILE_FLAG_DEBUG_COMPILER)) {
    pfile_write(pf, pfile_write_asm,
        "branchhi_nop macro lbl\n"
        "  endm\n");
    pfile_write(pf, pfile_write_asm,
        "branchlo_nop macro lbl\n"
        "  endm\n");
  }
}

