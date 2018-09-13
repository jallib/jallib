/**********************************************************
 **
 ** cmd_usec.h : declarations for cmd_type_usec_t
 **
 ** Copyright (c) 2006, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#ifndef cmd_usec_h__
#define cmd_usec_h__

#include "cmd.h"

/* delay hack */
cmd_t            cmd_usec_delay_alloc(variable_const_t n);
variable_const_t cmd_usec_delay_get(const cmd_t cmd);
void             cmd_usec_delay_set(cmd_t cmd, variable_const_t n);

#endif /* cmd_usec_h__ */

