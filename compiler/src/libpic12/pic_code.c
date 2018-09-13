/**********************************************************
 **
 ** pic_code.c : manipulators for pic_code_t
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "../libutils/mem.h"
#include "../libcore/cmd_asm.h"
#include "pic.h"
#include "pic_code.h" 

struct pic_code_ {
  pic_code_t             next;
  pic_code_t             prev;

  flag_t                 flags;

  cmd_t                  cmd;
  pic_pc_t               pc;       /* program counter */

  /* databits are modified by variable reference */
  pic_databits_state_t   databits;
  uchar                  bsr;     /* track what's in BSR */
  /* branchbits are modified by branching instructions (12/14 bit) */
  pic_branchbits_state_t branchbits;
  /* pclath modified by movlp (14 bit hybrids) */
  pic_pclath_state_t     pclath;

  label_t                label;
  pic_opcode_t           op;
  /* unsigned char  op; */
  /* pic_opcode_t       op; */
  /* pic_instr_append_f_d   */
  /* pic_instr_append_reg_d */
  /* pic_instr_append_f     */
  /* pic_instr_append_reg   */
  value_t                value; /* this *MUST BE* a variable (not a constant) */
  size_t                 ofs;
  pic_opdst_t            dst;          /* f, w or none   */
  /* pic_instr_append_f_b      */
  /* pic_instr_append_reg_bn   */
  /* pic_instr_append_reg_flag */
  /* pic_instr_append_w_k      */
  /* pic_instr_append_w_kn     */
  value_t                literal; /* bit or literal */
  /* pic_instr_append_n        */
  label_t                brdst;

  unsigned               fsr_n; /* which FSR */
  unsigned               depth;

  value_t                w_value; /* tracks what W is holding */

  size_t                 data_sz; /* data size for PIC_OPCODE_DB */
  void                  *data;    /* the actual data             */
};

static cache_t   pic_code_cache;
static boolean_t pic_code_cache_is_init;

static void pic_code_cache_cleanup(void)
{
  cache_cleanup(&pic_code_cache);
}

static pic_code_t pic_code_element_alloc(void)
{
  if (!pic_code_cache_is_init) {
    pic_code_cache_is_init = BOOLEAN_TRUE;
    atexit(pic_code_cache_cleanup);
    cache_init(&pic_code_cache, sizeof(struct pic_code_), "pic_code");
  }
  return cache_element_alloc(&pic_code_cache);
}

static struct pic_code_ *pic_code_element_seek(pic_code_t el, boolean_t mod)
{
  return cache_element_seek(&pic_code_cache, el, mod);
}

pic_code_t pic_code_alloc(label_t lbl, pic_opcode_t op, flag_t flags)
{
  pic_code_t code;

  code = pic_code_element_alloc();
  if (code) {
    struct pic_code_ *ptr;
    
    ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
    
    if (ptr) {
      static const pic_databits_state_t   db_state_none = {
        {PIC_BITSTATE_UNKNOWN, PIC_BITSTATE_UNKNOWN},
        {PIC_BITSTATE_UNKNOWN, PIC_BITSTATE_UNKNOWN}};
      static const pic_branchbits_state_t bb_state_none = {
        {PIC_BITSTATE_UNKNOWN, PIC_BITSTATE_UNKNOWN},
        {PIC_BITSTATE_UNKNOWN, PIC_BITSTATE_UNKNOWN}};

      ptr->next       = PIC_CODE_NONE;
      ptr->prev       = PIC_CODE_NONE;
      ptr->flags      = PIC_CODE_FLAG_NONE;
      ptr->cmd        = CMD_NONE;
      ptr->pc         = 0;
      ptr->databits   = db_state_none;
      ptr->branchbits = bb_state_none;
      ptr->label      = LABEL_NONE;
      ptr->op         = PIC_OPCODE_NONE;
      ptr->value      = VALUE_NONE;
      ptr->ofs        = 0;
      ptr->dst        = PIC_OPDST_NONE;
      ptr->literal    = VALUE_NONE;
      ptr->brdst      = LABEL_NONE;
      ptr->depth      = -1;
      pic_code_label_set(code, lbl);
      pic_code_op_set(code, op);
      pic_code_flag_set_all(code, flags);
      ptr->w_value    = VALUE_NONE;
      ptr->bsr        = PIC_BSR_UNKNOWN;
      ptr->pclath.before = PIC_PCLATH_UNKNOWN;
      ptr->pclath.action = PIC_PCLATH_UNKNOWN;
      ptr->data_sz    = 0;
      ptr->data       = 0;
    }
  }
  return code;
}

void pic_code_free(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    pic_code_label_set(code, LABEL_NONE);
    value_release(ptr->value);
    value_release(ptr->literal);
    label_release(ptr->brdst);
    value_release(ptr->w_value);
    FREE(ptr->data);
    cache_element_free(&pic_code_cache, code);
  }
}


void pic_code_prev_set(pic_code_t code, pic_code_t link)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->prev = link;
  }
}

pic_code_t pic_code_prev_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->prev : 0;
}

void pic_code_next_set(pic_code_t code, pic_code_t link)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->next = link;
  }
}

pic_code_t pic_code_next_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->next : 0;
}

void pic_code_cmd_set(pic_code_t code, cmd_t cmd)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->cmd = cmd;
  }
}

cmd_t pic_code_cmd_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->cmd : 0;
}

void pic_code_pc_set(pic_code_t code, pic_pc_t pc)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->pc = pc;
  }
}

pic_pc_t pic_code_pc_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->pc : 0;
}

void pic_code_label_set(pic_code_t code, label_t label)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    label_lock(label);
    label_release(ptr->label);
    ptr->label = label;
    label_code_set(label, (void *) code);
  }
}

label_t pic_code_label_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->label : 0;
}

void pic_code_op_set(pic_code_t code, pic_opcode_t op)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->op = op;
  }
}

pic_opcode_t pic_code_op_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->op : 0;
}

void pic_code_value_set(pic_code_t code, value_t val)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    value_lock(val);
    value_release(ptr->value);
    ptr->value = val;
  }
}

value_t pic_code_value_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->value : 0;
}

void pic_code_ofs_set(pic_code_t code, size_t ofs)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->ofs = ofs;
  }
}

size_t pic_code_ofs_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->ofs : 0;
}

void pic_code_fsr_n_set(pic_code_t code, unsigned fsr_n)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->fsr_n = fsr_n;
  }
}

unsigned pic_code_fsr_n_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->fsr_n : 0;
}
void pic_code_dst_set(pic_code_t code, pic_opdst_t dst)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->dst = dst;
  }
}

pic_opdst_t pic_code_dst_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->dst : 0;
}

void pic_code_literal_set(pic_code_t code, value_t lit)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    value_lock(lit);
    value_release(ptr->literal);
    ptr->literal = lit;
  }
}

value_t pic_code_literal_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->literal : 0;
}

void pic_code_brdst_set(pic_code_t code, label_t brdst)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    label_lock(brdst);
    label_usage_bump(ptr->brdst, CTR_BUMP_DECR);
    label_release(ptr->brdst);
    ptr->brdst = brdst;
    label_usage_bump(brdst, CTR_BUMP_INCR);
  }
}

label_t pic_code_brdst_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->brdst : 0;
}

void pic_code_databits_get(pic_code_t code, pic_databits_state_t *dst)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  if (ptr) {
    *dst = ptr->databits;
  }
}

void pic_code_databits_set(pic_code_t code, const pic_databits_state_t *src)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->databits = *src;
  }
}

void pic_code_branchbits_get(pic_code_t code, pic_branchbits_state_t *dst)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  if (ptr) {
    *dst = ptr->branchbits;
  }
}

void pic_code_branchbits_set(pic_code_t code, 
    const pic_branchbits_state_t *src)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->branchbits = *src;
  }
}

boolean_t  pic_code_flag_test(pic_code_t code, flag_t flag)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return ptr && ((ptr->flags & flag) == flag);
}

void pic_code_flag_set(pic_code_t code, flag_t flag)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags |= flag;
  }
}

void pic_code_flag_clr(pic_code_t code, flag_t flag)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags &= ~flag;
  }
}

flag_t pic_code_flag_get_all(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return ptr ? ptr->flags : 0;
}

void pic_code_flag_set_all(pic_code_t code, flag_t flags)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags = flags;
  }
}

void pic_code_depth_set(pic_code_t code, unsigned depth)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->depth = depth;
  }
}

unsigned pic_code_depth_get(pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->depth : 0;
}


value_t pic_code_w_value_get(const pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->w_value : VALUE_NONE;
}

void pic_code_w_value_set(pic_code_t code, value_t val)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    value_lock(val);
    value_release(ptr->w_value);
    ptr->w_value = val;
  }
}

uchar pic_code_bsr_get(const pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->bsr : PIC_PCLATH_UNKNOWN;
}

void pic_code_bsr_set(pic_code_t code, uchar bsr)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->bsr = bsr;
  }
}

void pic_code_pclath_get(const pic_code_t code, pic_pclath_state_t *dst)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  if (ptr) {
    *dst = ptr->pclath;
  }
}

void pic_code_pclath_set(pic_code_t code, const pic_pclath_state_t *src)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    ptr->pclath = *src;
  }
}

/* return the # of words used by this code */
size_t pic_code_sz_get(pic_code_t code, pic_target_cpu_t target)
{
  size_t sz;

  sz = 0;
  switch (pic_code_op_get(code)) {
    case PIC_OPCODE_ORG:
    case PIC_OPCODE_END:
    case PIC_OPCODE_NONE:
    case PIC_OPCODE_BRANCHLO_NOP:
    case PIC_OPCODE_BRANCHHI_NOP:
    case PIC_OPCODE_MOVLP_NOP:
      sz = 0;
      break;
    case PIC_OPCODE_ADDWF:
    case PIC_OPCODE_ANDWF:
    case PIC_OPCODE_XORWF:
    case PIC_OPCODE_IORWF:
    case PIC_OPCODE_SUBWF:
    case PIC_OPCODE_COMF:
    case PIC_OPCODE_DECF:
    case PIC_OPCODE_DECFSZ:
    case PIC_OPCODE_INCF:
    case PIC_OPCODE_INCFSZ:
    case PIC_OPCODE_RLF:
    case PIC_OPCODE_RLCF:
    case PIC_OPCODE_RRF:
    case PIC_OPCODE_RRCF:
    case PIC_OPCODE_MOVF:
    case PIC_OPCODE_SWAPF:
    case PIC_OPCODE_CLRF:
    case PIC_OPCODE_MOVWF:
    case PIC_OPCODE_NOP:
    case PIC_OPCODE_CLRW:
    case PIC_OPCODE_RETFIE:
    case PIC_OPCODE_RETURN:
    case PIC_OPCODE_SLEEP:
    case PIC_OPCODE_CLRWDT:
    case PIC_OPCODE_OPTION:
    case PIC_OPCODE_BCF:
    case PIC_OPCODE_BSF:
    case PIC_OPCODE_BTFSC:
    case PIC_OPCODE_BTFSS:
    case PIC_OPCODE_ADDLW:
    case PIC_OPCODE_ANDLW:
    case PIC_OPCODE_IORLW:
    case PIC_OPCODE_MOVLW:
    case PIC_OPCODE_SUBLW:
    case PIC_OPCODE_XORLW:
    case PIC_OPCODE_RETLW:
    case PIC_OPCODE_TRIS:
    case PIC_OPCODE_DATALO_SET:
    case PIC_OPCODE_DATALO_CLR:
    case PIC_OPCODE_DATAHI_SET:
    case PIC_OPCODE_DATAHI_CLR:
    case PIC_OPCODE_IRP_SET:
    case PIC_OPCODE_IRP_CLR:
    case PIC_OPCODE_BRANCHLO_SET:
    case PIC_OPCODE_BRANCHLO_CLR:
    case PIC_OPCODE_BRANCHHI_SET:
    case PIC_OPCODE_BRANCHHI_CLR:
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
    case PIC_OPCODE_TBLRD:
    case PIC_OPCODE_TBLWT:
    case PIC_OPCODE_MOVLB:
    case PIC_OPCODE_MOVLP:
      sz = 1;
      break;
    case PIC_OPCODE_LFSR:
    case PIC_OPCODE_MOVFF:
      sz = 2;
      break;
    case PIC_OPCODE_CALL:
    case PIC_OPCODE_GOTO:
      sz = (PIC_TARGET_CPU_16BIT == target) ? 2 : 1;
      break;
    case PIC_OPCODE_DB:
      {
        cmd_t cmd;

        sz  = pic_code_data_sz_get(code);
        if (!sz) {
          cmd = pic_code_cmd_get(code);
          sz  = cmd_asm_data_sz_get(cmd);
        }
        sz = (sz + 1) / 2;
      }
      break;
  }
  if (PIC_TARGET_CPU_16BIT == target) {
    sz *= 2;
  }
  return sz;
}

size_t pic_code_data_sz_get(const pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->data_sz : 0;
}

const void *pic_code_data_get(const pic_code_t code)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_FALSE);
  return (ptr) ? ptr->data : 0;
}

/* data is assumed to have been malloc()'d and will be free()'d */
void pic_code_data_set(pic_code_t code, size_t sz, void *data)
{
  struct pic_code_ *ptr;

  ptr = pic_code_element_seek(code, BOOLEAN_TRUE);
  if (ptr) {
    FREE(ptr->data);
    ptr->data_sz = sz;
    ptr->data    = data;
  }
}

boolean_t pic_code_is_exec(pic_code_t code)
{
  return (PIC_OPCODE_ORG          != pic_code_op_get(code))
      && (PIC_OPCODE_END          != pic_code_op_get(code)) 
      && (PIC_OPCODE_NONE         != pic_code_op_get(code))
      && (PIC_OPCODE_BRANCHLO_NOP != pic_code_op_get(code))
      && (PIC_OPCODE_BRANCHHI_NOP != pic_code_op_get(code));
}

