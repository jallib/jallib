/************************************************************
 **
 ** pic_daop.h : PIC data optimization declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_daop_h__
#define pic_daop_h__

#include "pic.h"

void pic_code_databits_optimize(pfile_t *pf);
void pic_code_databits_remove(pfile_t *pf);

#endif /* pic_daop_h__ */


