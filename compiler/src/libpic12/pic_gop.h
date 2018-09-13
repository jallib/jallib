/************************************************************
 **
 ** pic_gop.h : PIC general optimization declarations
 **
 ** Copyright (c) 2010, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pic_gop_h__
#define pic_gop_h__

#include "../libcore/pfile.h"
#include "pic_code.h"

/* this is the maximum depth the optimizer should reach! */
#define PIC_CODE_GOP_DEPTH 128

typedef enum {
  PIC_CODE_GOP_WHICH_ENTER, /* analyze fn entered */
  PIC_CODE_GOP_WHICH_EXIT,  /* analyze fn exited  */
  PIC_CODE_GOP_WHICH_PRE,   /* pre-code work      */
  PIC_CODE_GOP_WHICH_POST   /* post-code work     */
} pic_code_gop_which_t;

typedef enum {
  PIC_CODE_GOP_RC_CONTINUE,
  PIC_CODE_GOP_RC_STOP
} pic_code_gop_rc_t;

typedef pic_code_gop_rc_t (pic_code_gop_analyze_cb_t)(
    pfile_t             *pf,
    pic_code_t           code,
    pic_code_gop_which_t which,
    void                *data);

typedef enum pic_code_gop_who_ {
  PIC_CODE_GOP_WHO_ISR,
  PIC_CODE_GOP_WHO_USER,
  PIC_CODE_GOP_WHO_INDIRECT
} pic_code_gop_who_t;

typedef void (pic_code_gop_optimize_cb_t)(
    pfile_t             *pf, 
    pic_code_gop_who_t   who,
    void                *data);

void pic_code_gop_optimize(
  pfile_t                   *pf,
  pic_code_gop_optimize_cb_t optimize_cb,
  pic_code_gop_analyze_cb_t  analyze_cb,
  void                      *data
  );

#endif /* pic_gop_h__ */

