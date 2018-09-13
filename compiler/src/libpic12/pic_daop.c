/************************************************************
 **
 ** pic_daop.c : PIC data optimization definitions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <assert.h>

#include "pic.h"
#include "pic_gop.h"
#include "piccolst.h"
#include "pic_msg.h"
#include "pic_daop.h"

typedef struct pic_code_daop_data_ {
  pic_databits_t databits[PIC_CODE_GOP_DEPTH];
  unsigned       ix;
} pic_code_daop_data_t;

/*
 * NAME
 *   pic_code_databits_analyze
 *
 * DESCRIPTION
 *   analyze the databits in the pic_codes[] array
 *
 * PARAMETERS
 *   pf       : 
 *   pcl      : pcl on entry
 *   databits : current databits
 *   depth    : depth (for statistics only)
 *
 * RETURN
 *   none
 *
 * NOTES
 *   This follows all codepaths to determine when
 *   status<irp> and status<rp1:rp0> need to be changed, thus minimizing
 *   these changes.
 *   Note about calls: the statement after a call is assumed to
 *     have lost all information about the databits. This is unfortunate,
 *     but it is very difficult to accurately detemine without building
 *     a rather large and complex tree. This is something I'll work on
 *     when I've the chance. The main problem I've run into is how to
 *     detect loops.
 */
static pic_code_gop_rc_t pic_code_daop_analyze(pfile_t *pf,
  pic_code_t code, pic_code_gop_which_t which, void *odata) 
{
  pic_code_daop_data_t *data;
  pic_code_gop_rc_t     rc;
  pic_databits_state_t  cbits;
  pic_databits_t        dbits;

  data  = odata;
  if (PIC_CODE_NONE != code) {
    dbits = data->databits[data->ix];
    pic_code_databits_get(code, &cbits);
  } else {
    dbits.rp0 = PIC_BITSTATE_UNKNOWN;
    dbits.rp1 = PIC_BITSTATE_UNKNOWN;
  }
  rc = PIC_CODE_GOP_RC_CONTINUE;
  
  switch (which) {
    case PIC_CODE_GOP_WHICH_ENTER:
      data->ix++;
      assert(data->ix < PIC_CODE_GOP_DEPTH);
      if (data->ix > 0) {
        data->databits[data->ix] = data->databits[data->ix - 1];
      }
      break;
    case PIC_CODE_GOP_WHICH_EXIT:
      data->ix--;
      break;
    case PIC_CODE_GOP_WHICH_PRE:
      if (((cbits.before.rp0 == dbits.rp0)
          || (PIC_BITSTATE_INDETERMINATE == cbits.before.rp0))
        && ((cbits.before.rp1 == dbits.rp1)
          || (PIC_BITSTATE_INDETERMINATE == cbits.before.rp1))) {
        rc = PIC_CODE_GOP_RC_STOP;
      } else if ((PIC_BITSTATE_INDETERMINATE == cbits.before.rp0)
          && (PIC_BITSTATE_INDETERMINATE == cbits.before.rp1)) {
        rc = PIC_CODE_GOP_RC_STOP;
      } else {
        if (PIC_BITSTATE_UNKNOWN == cbits.before.rp0) {
          cbits.before = dbits;
        } else {
          if (cbits.before.rp0 != dbits.rp0) {
            cbits.before.rp0 = PIC_BITSTATE_INDETERMINATE;
          }
          if (cbits.before.rp1 != dbits.rp1) {
            cbits.before.rp1 = PIC_BITSTATE_INDETERMINATE;
          }
        }
        pic_code_databits_set(code, &cbits);
        switch (pic_code_op_get(code)) {
          case PIC_OPCODE_DATALO_SET:
            dbits.rp0 = PIC_BITSTATE_SET;
            break;
          case PIC_OPCODE_DATALO_CLR:
            dbits.rp0 = PIC_BITSTATE_CLR;
            break;
          case PIC_OPCODE_DATAHI_SET:
            dbits.rp1 = PIC_BITSTATE_SET;
            break;
          case PIC_OPCODE_DATAHI_CLR:
            dbits.rp1 = PIC_BITSTATE_CLR;
            break;
          default:
            break;
        }
      }
      break;
    case PIC_CODE_GOP_WHICH_POST:
      if (pic_code_is_suspend(pf, code)
        || (PIC_OPCODE_CALL == pic_code_op_get(code))) {
        dbits.rp0 = PIC_BITSTATE_INDETERMINATE;
        dbits.rp1 = PIC_BITSTATE_INDETERMINATE;
      }
      cbits.action = dbits;
      pic_code_databits_set(code, &cbits);
      break;
  }
  if (PIC_CODE_NONE != code) {
    data->databits[data->ix] = dbits;
  }
  return rc;
}

/* run through the pic_codes and remove any redundant dataset commands */
void pic_code_databits_post_analyze(pfile_t *pf)
{
  pic_code_t code;
  unsigned   ins_ct; /* instruction ct */
  unsigned   rem_ct;

  for (ins_ct = 0, rem_ct = 0, code = pic_code_list_head_get(pf);
       code;
       ins_ct++) {
    pic_code_t next;

    next = pic_code_next_get(code);
    if (!pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)) {
      boolean_t            cremove;
      pic_databits_state_t cbitstate;

      pic_code_databits_get(code, &cbitstate);

      switch (pic_code_op_get(code)) {
        case PIC_OPCODE_DATALO_SET:
        case PIC_OPCODE_DATALO_CLR:
          cremove = cbitstate.before.rp0 == cbitstate.action.rp0;
          break;
        case PIC_OPCODE_DATAHI_SET:
        case PIC_OPCODE_DATAHI_CLR:
          cremove = cbitstate.before.rp1 == cbitstate.action.rp1;
          break;
        default:
          cremove = BOOLEAN_FALSE;
          break;
      }
      if (cremove) {
        pic_code_list_remove(pf, code);
        pic_code_free(code);
        rem_ct++;
      }
    }
    code = next;
  }
  pfile_log(pf, PFILE_LOG_DEBUG, "...removed %u of %u instructions", 
      rem_ct, ins_ct);
}

static void pic_code_daop_optimize(pfile_t *pf, 
    pic_code_gop_who_t who, void *odata)
{
  pic_code_daop_data_t *data;

  UNUSED(pf);
  data = odata;
  switch (who) {
    case PIC_CODE_GOP_WHO_ISR:
    case PIC_CODE_GOP_WHO_USER:
      data->databits[0].rp1 = PIC_BITSTATE_CLR;
      data->databits[0].rp0 = PIC_BITSTATE_CLR;
      break;
    case PIC_CODE_GOP_WHO_INDIRECT:
      data->databits[0].rp1 = PIC_BITSTATE_INDETERMINATE;
      data->databits[0].rp0 = PIC_BITSTATE_INDETERMINATE;
      break;
  }
  data->ix = (unsigned) -1;

}

void pic_code_databits_optimize(pfile_t *pf)
{
  pic_code_daop_data_t data;

  pfile_log(pf, PFILE_LOG_DEBUG, PIC_MSG_FIXING_DATA_BITS);
  pic_code_gop_optimize(pf, pic_code_daop_optimize,
    pic_code_daop_analyze, &data);
  /* once the analysis is done, we need to run through & make
     sure no further label fixups are needed, or fix them up
     as necessary */
  pfile_log(pf, PFILE_LOG_DEBUG, "...post analyze");
  pic_code_databits_post_analyze(pf);
}

/* look to see if datalo_set or datahi_set are used.
 * if not, datalo_clr and datahi_clr respectively can
 * be removed
 */ 
void pic_code_databits_remove(pfile_t *pf)
{
  pic_code_t code;
  boolean_t  datalo_set;
  boolean_t  datahi_set;

  for (datalo_set = BOOLEAN_FALSE,
         datahi_set = BOOLEAN_FALSE,
         code = pic_code_list_head_get(pf);
       code && !(datalo_set && datahi_set);
       code = pic_code_next_get(code)) {
    if (PIC_OPCODE_DATALO_SET== pic_code_op_get(code)) {
      datalo_set = BOOLEAN_TRUE;
    } else if (PIC_OPCODE_DATAHI_SET== pic_code_op_get(code)) {
      datahi_set = BOOLEAN_TRUE;
    }
  }
  if (!(datalo_set && datahi_set)) {
    unsigned   rem_ct;
    pic_code_t next;

    for (rem_ct = 0,
           code = pic_code_list_head_get(pf);
         code;
         code = next) {
      next = pic_code_next_get(code);
      if (!pic_code_flag_test(code, PIC_CODE_FLAG_NO_OPTIMIZE)
        && ((!datalo_set 
          && (PIC_OPCODE_DATALO_CLR == pic_code_op_get(code)))
          || (!datahi_set
            && (PIC_OPCODE_DATAHI_CLR == pic_code_op_get(code))))) {
        pic_code_list_remove(pf, code);
        pic_code_free(code);
        rem_ct++;
      } else {
        pic_databits_state_t dbits;

        pic_code_databits_get(code, &dbits);
        if (!datalo_set) {
          dbits.before.rp0 = PIC_BITSTATE_CLR;
          dbits.action.rp0  = PIC_BITSTATE_CLR;
        }
        if (!datahi_set) {
          dbits.before.rp1 = PIC_BITSTATE_CLR;
          dbits.action.rp1  = PIC_BITSTATE_CLR;
        }
        pic_code_databits_set(code, &dbits);
      }
    }
    pfile_log(pf, PFILE_LOG_DEBUG, "...removed %u data bit instructions",
        rem_ct);
  }
}

