/************************************************************
 **
 ** pic_opfn.h : PIC built-in operation declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_opfn_h__
#define pic_opfn_h__

#include "pic.h"

#define PIC_LABEL_MULTIPLY       "_pic_multiply"
#define PIC_LABEL_DIVIDE         "_pic_divide"   /* unsigned divide */
#define PIC_LABEL_SDIVIDE        "_pic_sdivide"  /* signed divide   */
#define PIC_LABEL_MEMSET         "_pic_memset"
#define PIC_LABEL_MEMCPY         "_pic_memcpy"
#define PIC_LABEL_MEMCMP         "_pic_memcmp"
#define PIC_LABEL_STKPUSH        "_pic_stkpush"
#define PIC_LABEL_STKPOP         "_pic_stkpop"
#define PIC_LABEL_INDIRECT       "_pic_indirect" /* for indirect calls */
#define PIC_LABEL_TASK_START     "_pic_task_start"
#define PIC_LABEL_TASK_SUSPEND   "_pic_task_suspend"
#define PIC_LABEL_TASK_KILL      "_pic_task_kill"
#define PIC_LABEL_TASK_SUICIDE   "_pic_task_suicide"
#define PIC_LABEL_PTR_WRITE      "_pic_pointer_write"
#define PIC_LABEL_PTR_READ       "_pic_pointer_read"
#define PIC_LABEL_FLOAT_SUB      "_pic_float_sub"
#define PIC_LABEL_FLOAT_ADD      "_pic_float_add"
#define PIC_LABEL_FLOAT_MULTIPLY "_pic_float_multiply"
#define PIC_LABEL_FLOAT_DIVIDE   "_pic_float_divide"
#define PIC_LABEL_FLOAT_SCONV    "_pic_float_sconv"
#define PIC_LABEL_FLOAT_CONV     "_pic_float_conv"
#define PIC_LABEL_FLOAT_TOINT    "_pic_float_toint"

void pic_intrinsics_create(pfile_t *pf);
boolean_t pic_intrinsics_exist(pfile_t *pf);
void pic_multiply_create_fn(pfile_t *pf, label_t lbl,
    value_t mresult, value_t multiplier, value_t multiplicand);

#endif

