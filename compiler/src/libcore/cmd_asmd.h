/************************************************************
 **
 ** cmd_asmd.h : inline assembly bits
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef cmdasmd_h__
#define cmdasmd_h__

#include "../libpic12/pic_inst.h"

typedef struct cmd_asm_ {
  pic_opcode_t op;
  pic_opdst_t  opdst;
  value_t      val;
  size_t       valofs;
  value_t      n;
  label_t      lbl;
  flag_t       flags;
  size_t       data_sz;
  uchar       *data;
} cmd_asm_t;

#endif /*cmdasmd_h__ */


