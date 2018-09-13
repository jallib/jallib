/************************************************************
 **
 ** pic_opco.h : PIC opcode declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_opco_h__
#define pic_opco_h__

/*
 * d = 0 (W) 1 (F)
 * a = 0 (access) 1 (BSR)
 * b = bit (0 <= b <= 7)
 * r = relative offset -128 <= r <= 127
 * R = relative offset -1024 <= R <= 1023
 * s = 0 (no update) 1 (save W/Status/BSR)
 * k = absolute address or value
 * x = doesn't matter
 * n = 0 (no change) 1 (post incr) 2 (post decr) 3 (pre incr)
 */
typedef enum {
  PIC_OPCODE_ORG,    /* ORG xxxx */
  PIC_OPCODE_END,    /* END      */
  PIC_OPCODE_NONE,   /* no code here */
  /* literal instructions on W */

  /* pic_instr_append_w_k  */
  /* pic_instr_append_w_kn */
  PIC_OPCODE_ADDLW,  /* w = k + w */
  PIC_OPCODE_ANDLW,  /* w = k & w */
  PIC_OPCODE_IORLW,  /* w = k | w */
  PIC_OPCODE_MOVLW,  /* w = k     */
  PIC_OPCODE_MULLW,  /* w * l --> PRODH:PRODL */
  PIC_OPCODE_RETLW,
  PIC_OPCODE_SUBLW,  /* w = k - w */
  PIC_OPCODE_XORLW,  /* w = k ^ w */
  PIC_OPCODE_TRIS,   /* w --> tris; k must be 6; backward compat only! */

  /* file register with destination */
  /* pic_instr_append_f_d   */
  /* pic_instr_append_reg_d */
  PIC_OPCODE_ADDWF,  /* f  + w --> d                 */
  PIC_OPCODE_ADDWFc, /* 0010 00da ffff ffff */
  PIC_OPCODE_ANDWF,  /* f  & w --> d                 */
  PIC_OPCODE_COMF,   /* ~f     --> d                 */
  PIC_OPCODE_DECF,   /* f - 1  --> d                 */
  PIC_OPCODE_DCFSNZ, /* 0100 11da ffff ffff */
  PIC_OPCODE_DECFSZ, /* f - 1  --> d, skip next if 0 */
  PIC_OPCODE_INCF,   /* f + 1  --> d                 */
  PIC_OPCODE_INCFSZ, /* f + 1  --> d, skip next if 0 */
  PIC_OPCODE_INFSNZ, /* 0100 10da ffff ffff */
  PIC_OPCODE_IORWF,  /* f  | w --> d                 */
  PIC_OPCODE_MOVF,   /* f      --> d                 */
  PIC_OPCODE_RLF,    /* f << 1 --> d                 */
  PIC_OPCODE_RLCF,   /* f << 1 --> d                 */
  PIC_OPCODE_RLNCF,  /* 0100 01da ffff ffff */
  PIC_OPCODE_RRF,    /* f >> 1 --> d                 */
  PIC_OPCODE_RRCF,   /* f >> 1 --> d                 */
  PIC_OPCODE_RRNCF,  /* 0100 00da ffff ffff */
  PIC_OPCODE_SUBFWB, /* 0101 01da ffff ffff */
  PIC_OPCODE_SUBWF,  /* f  - w --> d                 */
  PIC_OPCODE_SUBWFB,
  PIC_OPCODE_SWAPF,  /* swap nibbles in f --> d      */
  PIC_OPCODE_XORWF,  /* f  ^ w --> d                 */
  /* filre register instructions w/o dst */
  /* pic_instr_append_f   */
  /* pic_instr_append_reg */
  PIC_OPCODE_CLRF,   /* f = 0                        */
  PIC_OPCODE_CPFSEQ, /* 0110 001a ffff ffff */
  PIC_OPCODE_CPFSGT, /* 0110 010a ffff ffff */
  PIC_OPCODE_CPFSLT, /* 0110 000a ffff ffff */
  PIC_OPCODE_MOVWF,  /* 0110 111a ffff ffff */
  PIC_OPCODE_MULWF,  /* 0000 001a ffff ffff */
  PIC_OPCODE_NEGF,   /* 0110 110a ffff ffff */
  PIC_OPCODE_SETF,   /* 0110 100a ffff ffff */
  PIC_OPCODE_TSTFSZ, /* 0110 011a ffff ffff */
  /* bit instructions */
  /* pic_instr_append_f_b      */
  /* pic_instr_append_reg_flag */
  /* pic_instr_append_f_bn     */
  /* pic_instr_append_reg_bn   */
  PIC_OPCODE_BCF,    /* f, b -- bit clear */
  PIC_OPCODE_BSF,    /* f, b -- bit set   */
  PIC_OPCODE_BTFSC,  /* f, b -- bit test, skip next if clear */
  PIC_OPCODE_BTFSS,  /* f, b -- bit test, skip next if set   */
  PIC_OPCODE_BTG,    /* f, b -- bit toggle */
  /* relative branch instructions -128...127 */
  PIC_OPCODE_BC,     /* 1110 0010 rrrr rrrr */
  PIC_OPCODE_BN,     /* 1110 0110 rrrr rrrr */
  PIC_OPCODE_BNC,    /* 1110 0011 rrrr rrrr */
  PIC_OPCODE_BNN,    /* 1110 0111 rrrr rrrr */
  PIC_OPCODE_BNOV,   /* 1110 0101 rrrr rrrr */
  PIC_OPCODE_BNZ,    /* 1110 0001 rrrr rrrr */
  PIC_OPCODE_BOV,    /* 1110 0100 rrrr rrrr */
  PIC_OPCODE_BZ,     /* 1110 0000 rrrr rrrr */
  /* relative branch instruction */
  PIC_OPCODE_BRA,    /* 1101 0RRR RRRR RRRR */
  PIC_OPCODE_RCALL,  /* 1101 1RRR RRRR RRRR */
  /* long branch instructions */
  /* pic_instr_append_n */
  PIC_OPCODE_CALL,   /* call n */
  PIC_OPCODE_GOTO,   /* goto n */
  /* no operand instructions */
  /* pic_instr_append */
  PIC_OPCODE_CLRW,   /* w = 0     */
  PIC_OPCODE_CLRWDT,
  PIC_OPCODE_DAW,
  PIC_OPCODE_NOP,    /*                              */
  PIC_OPCODE_OPTION, /* w --> option */
  PIC_OPCODE_POP,    /* 0000 0000 0000 0110 */
  PIC_OPCODE_PUSH,   /* 0000 0000 0000 0101 */
  PIC_OPCODE_RESET,  /* 0000 0000 1111 1111 */
  PIC_OPCODE_RETURN, /* return */
  PIC_OPCODE_RETFIE, /* return from interrupt */
  PIC_OPCODE_SLEEP,
  /* misc. instructions */
  PIC_OPCODE_LFSR,   /* 1110 1110 00ff kkkk (11..8) */
                       /* 1111 0000 kkkk kkkk ( 7..0) */
  PIC_OPCODE_MOVFF,  /* 1100 ffff ffff ffff (src) */
                       /* 1111 ffff ffff ffff (dst) */
  PIC_OPCODE_MOVLB,  /* literal --> BSR */
  PIC_OPCODE_MOVLP,  /* literal --> PCLATH */
  PIC_OPCODE_MOVLP_NOP, /* dummy value used during movlp optimization */
  PIC_OPCODE_TBLRD,  /* 0000 0000 0000 10nn */
  PIC_OPCODE_TBLWT,  /* 0000 0000 0000 11nn */
  /* pseudo-ops to make life easier, translation in comments */
  PIC_OPCODE_DATALO_SET, /* bsf _status, _rp0 */
  PIC_OPCODE_DATALO_CLR, /* bcf _status, _rp0 */
  PIC_OPCODE_DATAHI_SET, /* bsf _status, _rp1 */
  PIC_OPCODE_DATAHI_CLR, /* bcf _status, _rp1 */
  PIC_OPCODE_IRP_SET,    /* bsf _status, _irp */
  PIC_OPCODE_IRP_CLR,    /* bcf _status, _irp */
  PIC_OPCODE_BRANCHLO_SET, /* bsf _pclath, 3 */
  PIC_OPCODE_BRANCHLO_CLR, /* bcf _pclath, 3 */
  PIC_OPCODE_BRANCHLO_NOP, /* nop */
  PIC_OPCODE_BRANCHHI_SET, /* bsf _pclath, 4 */
  PIC_OPCODE_BRANCHHI_CLR, /* bcf _pclath, 4 */
  PIC_OPCODE_BRANCHHI_NOP, /* nop */
  PIC_OPCODE_DB            /* db yy,xx */
} pic_opcode_t;

typedef enum {
  PIC_OPTYPE_NONE = 0, /* no parameters */
  PIC_OPTYPE_F,        /* opdst = none, val = f, val2 = none, label = none */
  PIC_OPTYPE_F_D,      /* opdst = w/f,  val = f, val2 = none, label = none */
  PIC_OPTYPE_F_B,      /* opdst = none, val = f, val2 = bit,  label = none */
  PIC_OPTYPE_N,        /* opdst = none, val = none, val2 = #, label = none */
  PIC_OPTYPE_K,        /* opdst = none, val = none, val2 = none, label = k */
  PIC_OPTYPE_TRIS,     /* opdst = none, val = none, val2 = t, label = none */
  PIC_OPTYPE_DB
} pic_optype_t;

typedef enum {
  PIC_OPDST_NONE, /* no dst */
  PIC_OPDST_W,
  PIC_OPDST_F
} pic_opdst_t;

typedef enum {
  PIC_TBLPTR_CHANGE_NONE,     /* no change      */
  PIC_TBLPTR_CHANGE_POST_INC, /* post increment */
  PIC_TBLPTR_CHANGE_POST_DEC, /* post decrement */
  PIC_TBLPTR_CHANGE_PRE_INC   /* pre increment  */
} pic_tblptr_change_t;

#endif /* pic_opco_h__ */

