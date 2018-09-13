/**********************************************************
 **
 ** cmdoptmz.c : command optimizier functions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <assert.h>
#include <string.h>

#include "pfile.h"
#include "pf_proc.h"
#include "pf_op.h"
#include "cmd_brch.h"
#include "cmd_op.h"
#include "cmd_asm.h"
#include "cmd_optm.h"

/*
 * NAME
 *   cmd_opt_branch
 *
 * DESCRIPTION
 *   basic branch optimization
 *
 * PARAMETERS
 *   cmd : head of the cmd list
 *
 * RETURN
 *   none
 *
 * NOTES
 *   first, the true branch destination is determined by following
 *     any chains of absolute GOTOs
 *   next:
 *     1. call to a return --> removed
 *     2. call immediately followed by return --> call changed to goto
 *     3. goto a return --> goto changed to return
 *     4. if (cond) goto l1
 *        absolute branch
 *        l1:
 *        ...
 *        --> if (!cond) goto l2
 *     5. goto l1 (or if cond goto l1)
 *        l1:
 *        remove!
 *
 * nb: on 5 above, there's a separate conditional possibility introduced
 *     by the PIC backend. Namely:
 *        tmp = expr
 *        if tmp goto l1
 *        l1:
 *     tmp = expr might be removed, so this becomes:
 *        expr
 *        if () goto l1
 *        l1:
 *     where () is simply the flags resulting from `tmp = expr'
 */
/* on entry, cmd points to a GOTO or a CALL
 * the returned cmd is the *true* destination (aka, this follows
 * a string of absolute GOTOs until it reaches the end) */
static cmd_t cmd_branch_true_dest_get(cmd_t cmd, cmd_t *cmd_head, label_t *dlbl)
{
  label_t lbl;
  unsigned opt;

  opt = cmd_opt_get(cmd) + 1;

  do {
    cmd_opt_set(cmd, opt);
    lbl = cmd_brdst_get(cmd);
    cmd = cmd_next_exec_get(cmd_label_find(*cmd_head, lbl));
  } while ((CMD_BRANCHTYPE_GOTO == cmd_brtype_get(cmd))
    && (CMD_BRANCHCOND_NONE == cmd_brcond_get(cmd))
    && (opt != cmd_opt_get(cmd)));
  *dlbl = lbl;
  return cmd;
}

boolean_t cmd_opt_branch(cmd_t *cmd_head)
{
  cmd_t cmd;
  unsigned rem_ct;
  cmd_t    cmd_prev;

  /* first, move cmd to the first *executable* instruction */
  rem_ct = 0;
  cmd = cmd_next_exec_get(*cmd_head);
  cmd_prev = CMD_NONE;

  while (cmd) {
    cmd_t cmd_next;

    cmd_next = cmd_link_get(cmd);

    if (value_is_const(cmd_brval_get(cmd))
        && ((CMD_BRANCHCOND_TRUE == cmd_brcond_get(cmd))
          || (CMD_BRANCHCOND_FALSE == cmd_brcond_get(cmd)))) {
      /* we know the condition, can we remove the instruction? */
      boolean_t rem;

      if (value_const_get(cmd_brval_get(cmd))) {
        rem = CMD_BRANCHCOND_FALSE == cmd_brcond_get(cmd);
      } else {
        rem = CMD_BRANCHCOND_TRUE == cmd_brcond_get(cmd);
      }
      if (rem) {
        cmd_remove(cmd_head, cmd);
        rem_ct++;
        cmd = CMD_NONE;
      } else {
        cmd_brcond_set(cmd, CMD_BRANCHCOND_NONE);
      }
    }
    if ((CMD_BRANCHTYPE_GOTO == cmd_brtype_get(cmd))
      || (CMD_BRANCHTYPE_CALL == cmd_brtype_get(cmd))
      || (CMD_BRANCHTYPE_TASK_START == cmd_brtype_get(cmd))) {
      /* find the TRUE destination (aka, follow the call chain) */
      cmd_t   cmd_lbl_exec;
      label_t lbl;

      cmd_lbl_exec = cmd_branch_true_dest_get(cmd, cmd_head, &lbl);
      /* lbl == TRUE destination
       * cmd_lbl_exec = first executable statement after lbl */
      cmd_brdst_set(cmd, lbl);
      if ((CMD_BRANCHTYPE_RETURN == cmd_brtype_get(cmd_lbl_exec))
        && (CMD_BRANCHCOND_NONE == cmd_brcond_get(cmd_lbl_exec))) {
        if (CMD_BRANCHTYPE_GOTO == cmd_brtype_get(cmd)) {
          /* GOTO destination is a RETURN; replace GOTO with RETURN */
          cmd_brtype_set(cmd, CMD_BRANCHTYPE_RETURN);
        } else {
          /* CALL destination is a RETURN; delete the CALL */
          cmd_remove(cmd_head, cmd);
          rem_ct++;
        }
      } else if (CMD_BRANCHTYPE_CALL == cmd_brtype_get(cmd)) {
        /* look at the next exectuteable statement, if it's a return,
         * change the CALL to a GOTO */
        cmd_t cmd_ptr;

        cmd_ptr = cmd_next_exec_get(cmd_link_get(cmd));
        if ((CMD_BRANCHTYPE_RETURN == cmd_brtype_get(cmd_ptr))
            && (CMD_BRANCHCOND_NONE == cmd_brcond_get(cmd_ptr))) {
          cmd_brtype_set(cmd, CMD_BRANCHTYPE_GOTO);
        }
      }
      if (CMD_BRANCHTYPE_GOTO == cmd_brtype_get(cmd)) {
        /* is this goto 1 forward? if so, get rid of it */
        cmd_t cmd_ptr;

        for (cmd_ptr = cmd_link_get(cmd);
             cmd_ptr
             && !cmd_is_executable(cmd_ptr)
             && (cmd_label_get(cmd_ptr) != cmd_brdst_get(cmd));
             cmd_ptr = cmd_link_get(cmd_ptr)) {
        }
        if (cmd_label_get(cmd_ptr) == cmd_brdst_get(cmd)) {
          /* goto following label --> remove cmd */
          /* KY: 2010-May-03 -- don't know exactly what this is supposed
           * to do, but it breaks some code on the 16 bit cores 
           * I think it's just supposed to make the result prettier
           * KY: 2012-Nov-14 -- I need to put this back (and fix it)!
           * It handles the case of an empty IF statement:
           *    IF expr THEN
           *    END IF
           * Without it, the expression is evaluated which leads to code
           * bloat.
           */
          if (!cmd_brval_get(cmd)
            && !cmd_opdst_get(cmd_prev)
            && !cmd_label_get(cmd_prev)) {
#if 0
            cmd_remove(cmd_head, cmd_prev);
            cmd_prev = CMD_NONE;
#endif
          }
          cmd_remove(cmd_head, cmd);
          rem_ct++;
        } else if ((CMD_BRANCHCOND_NONE != cmd_brcond_get(cmd))
          && (CMD_BRANCHTYPE_GOTO == cmd_brtype_get(cmd_ptr))
          && (CMD_BRANCHCOND_NONE == cmd_brcond_get(cmd_ptr))) {
          /* so far we've 
           *   if (cond) goto l1:
           *   goto l2:
           *   ???
           */
          cmd_t cmd_ptr2;

          for (cmd_ptr2 = cmd_link_get(cmd_ptr);
               cmd_ptr2
               && !cmd_is_executable(cmd_ptr2)
               && (cmd_label_get(cmd_ptr2) != cmd_brdst_get(cmd));
               cmd_ptr2 = cmd_link_get(cmd_ptr2))
            ; /* null body */
          if (cmd_label_get(cmd_ptr2) == cmd_brdst_get(cmd)) {
#if 0
            /* 
             * change the condition on cmd
             * remove cmd_ptr
             */
            cmd_brcond_set(cmd,
                (CMD_BRANCHCOND_TRUE == cmd_brcond_get(cmd))
                ? CMD_BRANCHCOND_FALSE
                : CMD_BRANCHCOND_TRUE);
            cmd_brdst_set(cmd, cmd_brdst_get(cmd_ptr));
            if (cmd_next == cmd_ptr) {
              cmd_next = cmd_link_get(cmd_ptr);
            }
            cmd_remove(cmd_head, cmd_ptr);
            rem_ct++;
            /* we need to re-evaluate cmd! */
            cmd_next = cmd;
#endif
          }
        }
      }
    }
    if (cmd != cmd_next) {
      cmd_prev = cmd;
    }
    cmd = cmd_next;
  }
  return rem_ct != 0;
}

/*
 * look for:
 *   _temp = !x
 *   branch [true|false] _temp, ...
 *   --> branch [false|true] x
 *
 *   _temp = !!x
 *   branch [true|false] _temp, ...
 *   --> branch [true|false] x
 */
boolean_t cmd_opt_branch2(cmd_t *cmd_head)
{
  cmd_t    cmd;
  cmd_t    cmd_pv;
  unsigned rem_ct;

  rem_ct = 0;

  cmd_pv = CMD_NONE;
  cmd    = cmd_next_exec_get(*cmd_head);
  while (cmd) {
    cmd_t cmd_next;

    cmd_next = cmd_next_exec_get(cmd_link_get(cmd));
    if (((OPERATOR_NOTL == cmd_optype_get(cmd)
        || OPERATOR_LOGICAL == cmd_optype_get(cmd)))
      && value_is_temp(cmd_opdst_get(cmd))
      && value_is_same(cmd_opdst_get(cmd), cmd_brval_get(cmd_next))
      && ((CMD_BRANCHCOND_TRUE == cmd_brcond_get(cmd_next))
        || (CMD_BRANCHCOND_FALSE == cmd_brcond_get(cmd_next)))) {
      /* remove cmd */
      cmd_branchcond_t brcond;

      brcond = cmd_brcond_get(cmd_next);
      if (OPERATOR_NOTL == cmd_optype_get(cmd)) {
        /* invert the condition */
        brcond = (CMD_BRANCHCOND_TRUE == cmd_brcond_get(cmd_next))
            ? CMD_BRANCHCOND_FALSE
            : CMD_BRANCHCOND_TRUE;
      }
      if (cmd_pv) {
        /*
         * cmd_pv points to the previous *executable* statement,
         * it need to move to the actual previous statement
         */  
        while (cmd_link_get(cmd_pv) != cmd) {
          cmd_pv = cmd_link_get(cmd_pv);
        }
        cmd_link_set(cmd_pv, cmd_link_get(cmd));
      } else {
        *cmd_head = cmd_link_get(cmd);
      }
      cmd_brcond_set(cmd_next, brcond);
      cmd_brval_set(cmd_next, cmd_opval1_get(cmd));
      cmd_free(cmd);
      rem_ct++;
    } else {
      cmd_pv = cmd;
    }
    cmd = cmd_next;
  }
  return rem_ct != 0;
}

/*
 * NAME
 *   cmd_opt_branch4
 *
 * DESCRIPTION
 *   do branch4 optimizations (see below)
 *
 * PARAMETERS
 *   cmd_head : start of cmd list
 *
 * RETURN
 *   BOOLEAN_TRUE : something was changed
 *
 * NOTES
 *   This looks for operations of the form:
 *     val = cexpr
 *     goto [true|false] val, label
 *   and either changes the goto to an unconditional, or removes it  
 *   then, if val doesn't exist or is temporary & not further used,
 *   it will also be removed
 */
boolean_t cmd_opt_branch4(pfile_t *pf, cmd_t *cmd_head)
{
  cmd_t    cmd;
  cmd_t    cmd_pv;
  unsigned rem_ct;

  rem_ct = 0;

  cmd_pv = CMD_NONE;
  cmd    = *cmd_head; /* cmd_next_exec_get(*cmd_head); */
  while (cmd) {
    cmd_t cmd_next;

    cmd_next = cmd_link_get(cmd);
    if ((CMD_BRANCHCOND_NONE != cmd_brcond_get(cmd_next))
        && ((cmd_brval_get(cmd_next) 
            && value_is_pseudo_const(cmd_brval_get(cmd_next)))
          || (CMD_TYPE_OPERATOR == cmd_type_get(cmd)
            && (value_is_same(cmd_opdst_get(cmd), cmd_brval_get(cmd_next)))
            && value_is_pseudo_const(cmd_opval1_get(cmd))
            && value_is_pseudo_const(cmd_opval2_get(cmd))))) {
      variable_const_t n;

      if (cmd_brval_get(cmd_next)
          && value_is_pseudo_const(cmd_brval_get(cmd_next))) {
        n = value_is_const(cmd_brval_get(cmd_next))
          ? value_const_get(cmd_brval_get(cmd_next))
          : 0;
      } else {
        pf_const_t c;

        c = pfile_op_const_exec(pf, cmd_optype_get(cmd), 
            cmd_opval1_get(cmd), cmd_opval2_get(cmd));
        n = 0;
        switch (c.type) {
          case PF_CONST_TYPE_FLOAT:   n = c.u.f; break;
          case PF_CONST_TYPE_INTEGER: n = c.u.n; break;
          case PF_CONST_TYPE_NONE:
            break;
        }
      }
      /* determine whether to take the branch or not */
      if (((CMD_BRANCHCOND_FALSE == cmd_brcond_get(cmd_next)) && !n)
        || ((CMD_BRANCHCOND_TRUE == cmd_brcond_get(cmd_next)) && n)) {
        /* this becomes an absolute branch */
        cmd_brcond_set(cmd_next, CMD_BRANCHCOND_NONE);
        cmd_brval_set(cmd_next, VALUE_NONE);
      } else {
        /* this is removed */
        cmd_link_set(cmd, cmd_link_get(cmd_next));
        cmd_free(cmd_next);
        rem_ct++;
      }
      if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
        flag_t accessed;

        accessed = CMD_VARIABLE_ACCESS_FLAG_NONE;
        if (cmd_opdst_get(cmd)) {
          for (cmd_next = cmd_link_get(cmd);
               cmd_next 
               && (CMD_TYPE_BLOCK_END != cmd_type_get(cmd_next));
               cmd_next = cmd_link_get(cmd_next)) {
            accessed = cmd_value_accessed_get(cmd_next, cmd_opdst_get(cmd));
            if (accessed) {
              break;
            }
          }
        }
        if (!(accessed & CMD_VARIABLE_ACCESS_FLAG_READ)) {
          /* if the result of cmd is not used again, remove it */
          if (cmd_pv) {
            while (cmd_link_get(cmd_pv) != cmd) {
              cmd_pv = cmd_link_get(cmd_pv);
            }
            cmd_link_set(cmd_pv, cmd_link_get(cmd));
          } else {
            *cmd_head = cmd_link_get(cmd);
          }
          cmd_free(cmd);
          cmd = (cmd_pv) ? cmd_pv : *cmd_head;
          rem_ct++;
        }
      }
    }
    cmd_pv = cmd;
    cmd = cmd_link_get(cmd);
  }
  return rem_ct != 0;
}



/*
 * NAME
 *   cmd_analyze
 *
 * DESCRIPTION
 *   analyze the command list for dead code
 *
 * PARAMETERS
 *   cmd_head : head of the cmd list
 *   cmd      : current entry
 *   flag     : CMD_FLAG_USER      : analyzing user area
 *              CMD_FLAG_INTERRUPT : analyzing an ISR
 *
 * RETURN
 *   none
 *
 * NOTES
 *   this doesn't solve the NP problem, it simply takes each
 *   path to determine if it's possible to get there from here
 */
static size_t depth_max;
void cmd_analyze(cmd_t cmd_top, cmd_t cmd, flag_t flag, size_t depth,
  pfile_t *pf)
{
  boolean_t pv_cond;

  pv_cond = BOOLEAN_FALSE;
  if (depth > depth_max) {
    depth_max = depth;
  }
  while (cmd && !cmd_flag_test(cmd, flag)) {
    cmd_flag_set(cmd, flag);
    if (CMD_TYPE_OPERATOR == cmd_type_get(cmd)) {
      if (OPERATOR_ASSIGN == cmd_optype_get(cmd)) {
        if (VARIABLE_DEF_TYPE_FUNCTION 
            == value_type_get(cmd_opval1_get(cmd))) {
          /* assigning a function to a variable. eventually this
           * variable will be called (it's probably worth checking
           * use first), so go ahead & make the call here */
          cmd_t ptr;

          ptr = cmd_label_find(cmd_top,
              pfile_proc_label_get(
                variable_proc_get(
                  value_variable_get(
                    cmd_opval1_get(cmd)))));
          cmd_analyze(cmd_top, ptr, flag, depth + 1, pf);
        }
      }
      pv_cond = BOOLEAN_FALSE;
      cmd = cmd_link_get(cmd);
    } else if (PIC_OPCODE_RESET == cmd_asm_op_get(cmd)) {
      cmd = (pv_cond) ? cmd_link_get(cmd) : CMD_NONE;
    } else if (CMD_TYPE_BRANCH == cmd_type_get(cmd)) {
      switch (cmd_brtype_get(cmd)) {
        case CMD_BRANCHTYPE_GOTO:
        case CMD_BRANCHTYPE_CALL:
        case CMD_BRANCHTYPE_TASK_START:
          {
            value_t  proc;
            value_t *params;
            size_t   param_ct;
            size_t   ii;

            proc     = cmd_brproc_get(cmd);
            param_ct = cmd_brproc_param_ct_get(cmd);
            params   = cmd_brproc_params_get(cmd);

            if (cmd_brdst_get(cmd)) {
              /* look for the label */
              cmd_t ptr;

              ptr = cmd_label_find(cmd_top, cmd_brdst_get(cmd));
              if ((CMD_BRANCHTYPE_GOTO == cmd_brtype_get(cmd))
                && (cmd_brdst_get(cmd) == cmd_label_get(cmd_link_get(ptr)))) {
                /* GOTO (cmd+1) -- this is unnecessary! */
                cmd_flag_clr(ptr, flag);
                cmd = cmd_link_get(cmd);
              } else if ((CMD_BRANCHTYPE_GOTO == cmd_brtype_get(cmd))
                  && (CMD_BRANCHCOND_NONE == cmd_brcond_get(cmd))) {
                /* unconditional goto, simply change cmd */
                cmd = ptr;
              } else {
                /* recurse using ptr, then continue */
                cmd_analyze(cmd_top, ptr, flag, depth + 1, pf);
                cmd = cmd_link_get(cmd);
              }
            } else if (proc) {
              /* this is an indirect call */
              value_t val;

              val = proc;
              if (VARIABLE_DEF_TYPE_FUNCTION == value_type_get(val)) {
                cmd_t ptr;

                ptr = cmd_label_find(cmd_top,
                    pfile_proc_label_get(
                      variable_proc_get(
                        value_variable_get(
                          val))));
                cmd_analyze(cmd_top, ptr, flag, depth + 1, pf);
                cmd = cmd_link_get(cmd);
              }
            }
            /* all the parameter must also be checked. any function
               references or pointers will have to be assumed to have
               been called. */
            /* parameter 0 is the return value & can be ignored */
            for (ii = 1; ii < param_ct; ii++) {
              if (VARIABLE_DEF_TYPE_FUNCTION == value_type_get(params[ii])) {
                cmd_t ptr;
                label_t lbl;

                lbl = pfile_proc_label_get(
                  variable_proc_get(
                    value_variable_get(
                      params[ii])
                  )
                );
                assert(lbl != LABEL_NONE);
                if (lbl) {
                  ptr = cmd_label_find(cmd_top, lbl);
                  cmd_analyze(cmd_top, ptr, flag, depth + 1, pf);
                }
              }
            }
          }
          pv_cond = BOOLEAN_FALSE;
          break;
        case CMD_BRANCHTYPE_RETURN:
          if (CMD_BRANCHCOND_NONE == cmd_brcond_get(cmd)) {
            /* at the end of the chain, so exit */
            pv_cond = BOOLEAN_FALSE;
            cmd = 0;
            break;
          }
          /* fall through */
        case CMD_BRANCHTYPE_NONE: 
        case CMD_BRANCHTYPE_TASK_END:
        case CMD_BRANCHTYPE_TASK_SUSPEND:
          pv_cond = BOOLEAN_FALSE;
          cmd = cmd_link_get(cmd);
          break;
      }
    } else if ((CMD_TYPE_END == cmd_type_get(cmd))
      || (CMD_TYPE_PROC_LEAVE == cmd_type_get(cmd))
      || (CMD_TYPE_ISR_CLEANUP == cmd_type_get(cmd))) {
      pv_cond = BOOLEAN_FALSE;
      cmd = 0; /* we're done */
    } else if (CMD_TYPE_ASM == cmd_type_get(cmd)) {
      label_t lbl;
      pic_opcode_t op;

      lbl = cmd_asm_lbl_get(cmd);
      if (LABEL_NONE != lbl) {
        cmd_t ptr;

        ptr = cmd_label_find(cmd_top, lbl);
        cmd_analyze(cmd_top, ptr, flag, depth + 1, pf);
      }
      op = cmd_asm_op_get(cmd);
#if 0
      cmd = (!pv_cond
            && ((PIC_OPCODE_GOTO == op)
              || (PIC_OPCODE_BRA == op)
              || (PIC_OPCODE_RESET == op)
              || (PIC_OPCODE_RETURN == op)
              || (PIC_OPCODE_RETFIE == op)))
              ? CMD_NONE
              : cmd_link_get(cmd);
#else
      cmd = cmd_link_get(cmd);
#endif

      pv_cond = (PIC_OPCODE_INCFSZ == op)
        || (PIC_OPCODE_DECFSZ == op)
        || (PIC_OPCODE_BTFSC == op)
        || (PIC_OPCODE_BTFSS == op);
    } else {
      if (cmd_is_executable(cmd)) {
        pic_opcode_t op;

        op = cmd_asm_op_get(cmd);
        pv_cond = (PIC_OPCODE_INCFSZ == op)
          || (PIC_OPCODE_DECFSZ == op)
          || (PIC_OPCODE_BTFSC == op)
          || (PIC_OPCODE_BTFSS == op);
      }
      cmd = cmd_link_get(cmd);
    }
  }
}

