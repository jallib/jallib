/************************************************************
 **
 ** pic_emu.h : PIC instruction emulator declarations
 **
 ** Copyright (c) 2007, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_emu_h__
#define pic_emu_h__

#include "../libcore/pfile.h"
#include "pic.h"
extern unsigned pic_emu_instr_ct;
typedef struct pic_emu_state_ *pic_emu_state_t;
typedef struct pic_emu_var_def_ {
  const char     *name;
  flag_t          dflags;
  variable_sz_t   sz;
  variable_base_t base[VARIABLE_MIRROR_CT];
} pic_emu_var_def_t;

pic_emu_state_t  pic_emu_state_alloc(pfile_t *pf, pic_target_cpu_t cpu);
void             pic_emu_state_free(pic_emu_state_t state);

variable_const_t pic_emu_value_read(const pic_emu_state_t state,
                   const value_t val, const pfile_pos_t *fpos);
void             pic_emu_value_write(pic_emu_state_t state,
                   const value_t val, variable_const_t cn,
                   const pfile_pos_t *fpos);
void             pic_emu_volatile_check(const pic_emu_state_t state, 
                   const value_t val);

uchar            pic_emu_w_get(const pic_emu_state_t state);
void             pic_emu_w_set(pic_emu_state_t state, uchar cn);

label_t          pic_emu_entry_get(const pic_emu_state_t state);

void             pic_emu_data_mem_init(pic_emu_state_t state);

void             pic_emu(pfile_t *pf, pic_emu_state_t state);
pic_code_t       pic_emu_instr(pfile_t *pf,
                    pic_emu_state_t state, const pic_code_t code);

pic_target_cpu_t pic_emu_state_target_get(const pic_emu_state_t state);
#endif /* pic_emu_h__ */

