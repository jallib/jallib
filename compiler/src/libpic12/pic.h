/************************************************************
 **
 ** pic.h : PIC code generation definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef _pic_h__
#define _pic_h__

/*
 * these are also defined in jal/jal_incl.h. Make sure
 * the definitions match!
 */
#define PIC_EEPROM                 "_eeprom"
#define PIC_EEPROM_BASE PIC_EEPROM "_base"
#define PIC_EEPROM_USED PIC_EEPROM "_used"

#define PIC_ID                 "_id0"
#define PIC_ID_BASE PIC_ID     "_base"
#define PIC_ID_USED PIC_ID     "_used"

typedef enum {
  PIC_TARGET_CPU_NONE = 0,
  PIC_TARGET_CPU_12BIT,
  PIC_TARGET_CPU_14BIT,
  PIC_TARGET_CPU_16BIT,
  PIC_TARGET_CPU_SX_12,
  PIC_TARGET_CPU_14HBIT
} pic_target_cpu_t;

#include "../libcore/pfile.h"
#include "pic_code.h"

#define PIC_LABEL_RESET   "_pic_reset"    /* reset vector */
#define PIC_LABEL_ISR     "_pic_isr"      /* ISR vector   */
#define PIC_LABEL_PRE_ISR "_pic_pre_isr"  /* pre-isr bits. */
#define PIC_LABEL_PREUSER "_pic_pre_user" /* pre-user init */
/* pic_lookup is a dummy value used to determine if any
 * lookup tables are present */
#define PIC_LABEL_LOOKUP  "_pic_lookup"
#define PIC_STACKPTR_NAME "_stackptr"

/* a note about bitstate:
     unknown       : has not yet been analyzed
     set           : is known to be set
     clear         : is known to be clear
     indeterminate : sometimes set, sometimes clear, it will
                     need to be explicitly put into a real state */
/* general notes:
     special handling : btfsc, btfss, incfsz, decfsz
       since these skip the *next* instruction, i'll need to
       peek ahead & make any changes to irp, rp1:rp0, or pclath4:pclath3
       before this instruction

   pass 1: simply generate the instruction list, leaving all bits
           marked ``unknown''
   pass 2: analyze the real bit values as follows:
           * at a label that follows an absolute GOTO or RETURN,
             pclath<4:3> are known. to find the others we'll need to
             look at every path to this label
           * at any other label pclath<4:3> may not be known
           * when a CALL is placed, we'll need to find all RETURNs to 
             determine the bit states
           this looks like it could be a multi-pass proposition!
*/
void     p16f877_init(pfile_t *pf);
void     pic_cmd_generate(pfile_t *pf, const cmd_t cmd);
void     pic_cmd_dump(pfile_t *pf, const cmd_t cmd, boolean_t first);
void     pic_code_cleanup(pfile_t *pf);
void     pic_code_emu(pfile_t *pf);

boolean_t pic_bitstate_changed(pic_bitstate_t old, pic_bitstate_t new);
#define pic_bitstate_fixup(dst, src) \
  if (PIC_BITSTATE_UNKNOWN == dst) {  \
    dst = src;                       \
  } else if (dst != src) {           \
    dst = PIC_BITSTATE_INDETERMINATE; \
  }
pic_code_t pic_code_label_find(pfile_t *pf, const label_t lbl);

boolean_t pic_opcode_is_pseudo_op(pic_opcode_t op);
boolean_t pic_opcode_is_conditional(pic_opcode_t op);
boolean_t pic_opcode_modifies_z(pic_opcode_t op);

typedef struct pic_code_out_ {
  unsigned ct;      /* # of WORDs for in this instruction */
  unsigned code[2]; /* PICs have one or two words         */
} pic_code_to_pcode_t;

boolean_t pic_code_to_pcode(pfile_t *pf, const pic_code_t code,
    pic_code_to_pcode_t *dst);

typedef struct pic_bank_info_ {
  struct pic_bank_info_ *link;
  size_t                 lo;    /* first accessible location in a bank */
  size_t                 hi;    /* last accessible location in a bank  */
} pic_bank_info_t;

#if 0
extern pic_bank_info_t *pic_data_bank_list;
extern pic_bank_info_t *pic_shared_bank_list;
#endif
extern size_t           pic_stk_sz;
extern variable_base_t  pic_stk_base;

typedef unsigned pic_mem_size_t;
extern pic_mem_size_t pic_mem_size;
extern pic_mem_size_t pic_mem_size_loader;

void pic_init(pfile_t *pf);
void pic_data_bank_list_add(pfile_t *pf, size_t lo, size_t hi);
void pic_shared_bank_list_add(pfile_t *pf, size_t lo, size_t hi);

label_t pic_label_find(pfile_t *pf, const char *tag, boolean_t alloc);

boolean_t pic_code_modifies_pcl(pfile_t *pf, pic_code_t code);
/*
 * there are two labels for each lookup table:
 *   _lookup_* : the code pre-amble (12 & 14 bit only)
 *   _data_*   : the actual data
 */
#define PIC_LOOKUP_LABEL_FIND_FLAG_NONE  0x0000
#define PIC_LOOKUP_LABEL_FIND_FLAG_ALLOC 0x0001
#define PIC_LOOKUP_LABEL_FIND_FLAG_DATA  0x0002
label_t pic_lookup_label_find(pfile_t *pf, variable_t var, unsigned flags);
size_t pic_lookup_is_const(variable_t var, size_t ofs);
boolean_t pic_code_is_suspend(pfile_t *pf, pic_code_t code);

void pic_code_preamble(pfile_t *pf);

void pic_asm_header_write(pfile_t *pf, const char *chip);
void pic_variable_counters_set(pfile_t *pf);
void pic_code_dump(pfile_t *pf, const pic_code_t code);

pic_target_cpu_t pic_target_cpu_get(pfile_t *pf);
void             pic_target_cpu_set(pfile_t *pf, pic_target_cpu_t target);
unsigned         pic_target_bank_size_get(pfile_t *pf);
void             pic_target_bank_size_set(pfile_t *pf, unsigned sz);
unsigned         pic_target_page_size_get(pfile_t *pf);
void             pic_target_page_size_set(pfile_t *pf, unsigned sz);
boolean_t        pic_is_12bit(pfile_t *pf);
boolean_t        pic_is_14bit(pfile_t *pf);
boolean_t        pic_is_14bit_hybrid(pfile_t *pf);
boolean_t        pic_is_16bit(pfile_t *pf);

value_t pic_fsr_get(pfile_t *pf);
void    pic_fsr_setup(pfile_t *pf, value_t val);

char *pic_chip_name_get(pfile_t *pf);

boolean_t        pic_in_isr(pfile_t *pf); /* TRUE when generating ISR code */
value_t          pic_indirect_get(pfile_t *pf, pfile_log_t plog, size_t which);
variable_sz_t    pic_pointer_size_get(pfile_t *pf);
unsigned         pic_code_gen_pass_get(pfile_t *pf);
/* the _reentrant block is a temporary holding area for re-entrant functions */

#define PIC_FLAG_NONE       0x0000
#define PIC_FLAG_NO_PCLATH4 0x0001 /* program is < 2 * page_sz */
#define PIC_FLAG_NO_PCLATH3 0x0002 /* program is < 1 * page_sz */

void      pic_flag_set(pfile_t *pf, unsigned flag);
boolean_t pic_flag_test(pfile_t *pf, unsigned flag);

#endif /* _pic_h__ */

