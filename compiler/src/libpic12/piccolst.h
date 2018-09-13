/************************************************************
 **
 ** piccolst.h : PIC code list definitions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_colist_h__
#define pic_colist_h__

#include "pic.h"

pic_code_t pic_code_list_head_get(pfile_t *pf);
pic_code_t pic_code_list_tail_get(pfile_t *pf);
unsigned   pic_code_list_ct_get(pfile_t *pf);
void       pic_code_list_append(pfile_t *pf, pic_code_t code);
void       pic_code_list_insert(pfile_t *pf, pic_code_t prev, pic_code_t code);
void       pic_code_list_remove(pfile_t *pf, pic_code_t code);
void       pic_code_list_reset(pfile_t *pf);
void       pic_code_list_init(pfile_t *pf);
pic_pc_t   pic_code_list_pc_next_get(pfile_t *pf);

#endif /* pic_colist_h__ */

