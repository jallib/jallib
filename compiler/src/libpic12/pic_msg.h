/************************************************************
 **
 ** pic_msg.h : PIC message declartions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_msg_h__
#define pic_msg_h__

#define PIC_MSG_NO_USER_ENTRY           "no user entry"
#define PIC_MSG_CODE_USED               "Code area: %u of %u used (%s)"
#define PIC_MSG_DATA_USED               "Data area: %u of %u used"
#define PIC_MSG_STACK_AVAIL             "Software stack available: %lu bytes"
#define PIC_MSG_CODE_TOO_BIG            "PIC image too big!"
#define PIC_MSG_GENERATING_CODE         "generating PIC code pass %u"
#define PIC_MSG_FINDING_INTRIN          "finding intrinsics"
#define PIC_MSG_FIXING_BSR              "fixing up BSR"
#define PIC_MSG_FIXING_DATA_BITS        "fixing up data bits" \
                                        " (STATUS<IRP><RP1:RP0>)"
#define PIC_MSG_FIXING_CODE_BITS        "fixing up code bits" \
                                        " (PCLATH<4:3>) pass %u"
#define PIC_MSG_FIXING_PCLATH           "fixing up code bits" \
                                        " (PCLATH) pass %u"
#define PIC_MSG_RANGE_INVALID           "invalid range"
#define PIC_MSG_PICLOADER_START_BAD     "picloader start must be less than" \
                                        " code size"
#define PIC_MSG_PRAGMA_UNKNOWN          "unknown pragma: '%s'"
#define PIC_MSG_LABEL_NOT_FOUND         "'%s' not found"
#define PIC_MSG_CODEGEN_ERROR           "code generation error (cmd# %u)"
#define PIC_MSG_NO_DATA_SPACE           "no room to allocate '%s'"
#define PIC_MSG_SPANS_BANKS             "'%s' spans %u banks"
#define PIC_MSG_CANNOT_ALLOCATE_CODEGEN "cannot allocate codegen. need %u" \
                                        " bytes at the start of bank 0"
#define PIC_MSG_ALLOCATING_VARS         "allocating variables"
#define PIC_MSG_DBG_INSERTED_INST       "...inserted %u instructions in %u"\
                                        " passes"
#define PIC_MSG_DBG_MUL_SZ              "...multiply %u bits"
#define PIC_MSG_DBG_DIV_SZ              "...divide %u bits"
#define PIC_MSG_DBG_BANK                "...bank %u...%u"
#define PIC_MSG_DBG_DATA_USED           "...data used %u"

#endif /* pic_msg_h__ */

