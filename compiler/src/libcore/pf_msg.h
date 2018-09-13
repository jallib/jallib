/************************************************************
 **
 ** pf_msg.h : pfile message declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_msg_h__
#define pf_msg_h__

#define PFILE_MSG_INTERNAL_ERROR    "internal error%s"
#define PFILE_MSG_NOT_FOUND         "'%s' not found"
#define PFILE_MSG_MULTI_DEF         "'%s' previously defined"
#define PFILE_MSG_PCODE_OPT         "p-code optimizer"
#define PFILE_MSG_DBG_INCLUDE       "including '%.*s'"
#define PFILE_MSG_PATH_TOO_LONG     "path too long"
#define PFILE_MSG_CANNOT_OPEN       "cannot open '%s'"
#define PFILE_MSG_DUMPING_RESULT    "writing result"
#define PFILE_MSG_CONSTANT_RANGE    "constant out of range"
#define PFILE_MSG_SYNTAX_ERROR      "syntax error"
#define PFILE_MSG_CONSTANT_EXPECTED "constant expression expected"
#define PFILE_MSG_EXPECTED          "'%s' expected (got '%s')"
#define PFILE_MSG_VARIABLE_EXPECTED "variable name expected"

#endif /* pf_msg_h__ */

