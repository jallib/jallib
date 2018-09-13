/************************************************************
 **
 ** pic_code.h : pic code declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_code_h__
#define pic_code_h__

#include "../libutils/cache.h"
#include "../libcore/label.h"
#include "pic_opco.h"

typedef ulong pic_pc_t;

typedef enum pic_bitstate_ {
  PIC_BITSTATE_UNKNOWN,
  PIC_BITSTATE_SET,
  PIC_BITSTATE_CLR,
  PIC_BITSTATE_INDETERMINATE
} pic_bitstate_t;

typedef struct {
  pic_bitstate_t rp1;
  pic_bitstate_t rp0;
} pic_databits_t;

typedef struct {
  pic_bitstate_t pclath4;
  pic_bitstate_t pclath3;
} pic_branchbits_t;

typedef struct {
  pic_branchbits_t before; /* bits on entry to the instruction */
  pic_branchbits_t action; /* bits modified by the instruction */
} pic_branchbits_state_t;

typedef struct {
  pic_databits_t before;
  pic_databits_t action;
} pic_databits_state_t;

typedef struct {
  uchar before; /* pclath value on entry to the instruction  */
  uchar action; /* pclath value modified byt the instruction */
} pic_pclath_state_t;

#define PIC_BSR_UNKNOWN       0xfe /* hasn't been set yet */
#define PIC_BSR_INDETERMINATE 0xff /* tried to set to two different values */

#define PIC_PCLATH_UNKNOWN       0xfe /* hasn't been set yet */
#define PIC_PCLATH_INDETERMINATE 0xff /* tried to set to two different values */

#define PIC_CODE_FLAG_NONE        0x0000
/* do *not* touch this code. this is used for inline assembly
 * as well as for timing loops. branch_* and data_* will be
 * updated as necessary but never deleted */
#define PIC_CODE_FLAG_NO_OPTIMIZE 0x0001
/* used for dead code removal */
#define PIC_CODE_FLAG_VISITED     0x0002

/* the following are for branchlo/branchhi transitions in the branch
   optimizer. if a branch
   transitions from _nop to _set/_clr, it is never allowed to transition
   back to _nop */
#define PIC_CODE_FLAG_BRANCHLO_LOCK 0x0004
#define PIC_CODE_FLAG_BRANCHHI_LOCK 0x0008

/*
 * this is the same as the branch bits above, but for movlp
 * since these are mutually exclusive, I can re-use the bits
 */
#define PIC_CODE_FLAG_MOVLP_LOCK    0x0004

/* visited by w-detect */
#define PIC_CODE_FLAG_W_VISITED     0x0010
/* set if the value of W could be different things */
#define PIC_CODE_FLAG_W_UNKNOWN     0x0020
/* use HIGH lbl */
#define PIC_CODE_FLAG_LABEL_HIGH    0x0040
/* use UPPER lbl */
#define PIC_CODE_FLAG_LABEL_UPPER   0x0080

typedef struct pic_code_ *pic_code_t;
#define PIC_CODE_NONE ((pic_code_t) 0)

pic_code_t pic_code_alloc(label_t lbl, pic_opcode_t op, flag_t flags);
void       pic_code_free(pic_code_t code);

void       pic_code_prev_set(pic_code_t code, pic_code_t link);
pic_code_t pic_code_prev_get(pic_code_t code);

void       pic_code_next_set(pic_code_t code, pic_code_t link);
pic_code_t pic_code_next_get(pic_code_t code);

boolean_t  pic_code_flag_test(pic_code_t code, flag_t flag);
void       pic_code_flag_set(pic_code_t code, flag_t flag);
void       pic_code_flag_clr(pic_code_t code, flag_t flag);
flag_t     pic_code_flag_get_all(pic_code_t code);
void       pic_code_flag_set_all(pic_code_t code, flag_t flags);

void       pic_code_cmd_set(pic_code_t code, cmd_t cmd);
cmd_t      pic_code_cmd_get(pic_code_t code);

void       pic_code_pc_set(pic_code_t code, pic_pc_t pc);
pic_pc_t   pic_code_pc_get(pic_code_t code);

void       pic_code_label_set(pic_code_t code, label_t label);
label_t    pic_code_label_get(pic_code_t code);

void       pic_code_op_set(pic_code_t code, pic_opcode_t op);
pic_opcode_t pic_code_op_get(pic_code_t code);

void       pic_code_value_set(pic_code_t code, value_t val);
value_t    pic_code_value_get(pic_code_t code);

void       pic_code_ofs_set(pic_code_t code, size_t ofs);
size_t     pic_code_ofs_get(pic_code_t code);

void pic_code_fsr_n_set(pic_code_t code, unsigned fsr_n);
unsigned pic_code_fsr_n_get(pic_code_t code);

void       pic_code_dst_set(pic_code_t code, pic_opdst_t dst);
pic_opdst_t pic_code_dst_get(pic_code_t code);

void        pic_code_literal_set(pic_code_t code, value_t lit);
value_t     pic_code_literal_get(pic_code_t code);

void        pic_code_brdst_set(pic_code_t code, label_t brdst);
label_t     pic_code_brdst_get(pic_code_t code);

void        pic_code_databits_get(pic_code_t code, pic_databits_state_t *dst);
void        pic_code_databits_set(pic_code_t code, 
    const pic_databits_state_t *src);

void        pic_code_branchbits_get(pic_code_t code, 
    pic_branchbits_state_t *dst);
void        pic_code_branchbits_set(pic_code_t code, 
    const pic_branchbits_state_t *src);

void        pic_code_depth_set(pic_code_t code, unsigned depth);
unsigned    pic_code_depth_get(pic_code_t code);

value_t     pic_code_w_value_get(const pic_code_t code);
void        pic_code_w_value_set(pic_code_t code, value_t val);

size_t      pic_code_sz_get(pic_code_t code, pic_target_cpu_t target);

uchar       pic_code_bsr_get(const pic_code_t code);
void        pic_code_bsr_set(pic_code_t code, uchar bsr);

size_t      pic_code_data_sz_get(const pic_code_t code);
const void *pic_code_data_get(const pic_code_t code);
/* data is assumed to have been malloc()'d and will be free()'d */
void        pic_code_data_set(pic_code_t code, size_t sz, void *data);

void        pic_code_pclath_get(const pic_code_t code, 
              pic_pclath_state_t *dst);
void        pic_code_pclath_set(pic_code_t code, 
              const pic_pclath_state_t *src);
boolean_t   pic_code_is_exec(pic_code_t code);

#endif /* pic_code_h__ */

