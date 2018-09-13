/************************************************************
 **
 ** picdelay.h : PIC delay generator declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef picdelay_h__
#define picdelay_h__

#include "pic.h"

void pic_delay_create(pfile_t *pf, variable_const_t usec);

#endif /* picdelay_h__ */
