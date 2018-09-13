/**********************************************************
 **
 ** cmd.c : the cmd_type base functions
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include <assert.h>
#include <stddef.h>
#include "cmdd.h"

static cache_t   cmd_cache;
static boolean_t cmd_cache_is_init;
static ulong     serial_no;

static void cmd_cache_cleanup(void)
{
  cache_cleanup(&cmd_cache);
}

static cmd_t cmd_element_alloc(void)
{
  if (!cmd_cache_is_init) {
    cmd_cache_is_init = BOOLEAN_TRUE;
    atexit(cmd_cache_cleanup);
    (void) cache_init(&cmd_cache, sizeof(struct cmd_), "cmd");
  }
  return (cmd_t) cache_element_alloc(&cmd_cache);
}

struct cmd_ *cmd_element_seek(cmd_t el, boolean_t mod)
{
  return (cmd_t) cache_element_seek(&cmd_cache, el, mod);
}

cmd_t cmd_alloc(cmd_type_t type, 
  const cmd_vtbl_t *vtbl)
{
  cmd_t cmd;

  cmd = cmd_element_alloc();
  if (cmd) {
    struct cmd_ *ptr;
    
    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      ptr->link     = CMD_NONE;
      ptr->prev     = CMD_NONE;
      ptr->flags    = 0;
      ptr->serial_no = ++serial_no;
      ptr->pos.src  = 0;
      ptr->pos.line = 0;
      ptr->type     = type;
      ptr->opt      = 0;
      ptr->vtbl     = vtbl;
      ptr->u.proc   = PFILE_PROC_NONE;
      ptr->live_in  = VARIABLE_ARRAY_NONE;
      ptr->live_out = VARIABLE_ARRAY_NONE;
      ptr->var_gen  = VARIABLE_ARRAY_NONE;
      ptr->var_kill = VARIABLE_ARRAY_NONE;
    }
  }
  return cmd;
}

void cmd_free(cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    if (ptr->vtbl && ptr->vtbl->free_fn) {
      ptr->vtbl->free_fn(cmd);
    }
    variable_array_free(cmd->live_in);
    variable_array_free(cmd->live_out);
    variable_array_free(cmd->var_gen);
    variable_array_free(cmd->var_kill);
    pfile_source_release(ptr->pos.src);
    cache_element_free(&cmd_cache, cmd);
  }
}

cmd_t cmd_dup(const cmd_t cmd)
{
  const struct cmd_ *ptr;
  cmd_t        dup;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  if (!ptr) {
    dup = CMD_NONE;
  } else {
    if (ptr->vtbl && ptr->vtbl->dup_fn) {
      dup = ptr->vtbl->dup_fn(cmd);
    } else {
      dup = cmd_alloc(cmd_type_get(cmd), ptr->vtbl);
    }
    if (dup) {
      cmd_flag_set_all(dup, cmd_flag_get_all(cmd));
      cmd_line_set(dup, cmd_line_get(cmd));
      cmd_source_set(dup, cmd_source_get(cmd));
    }
  }
  return dup;
}

void cmd_label_remap(cmd_t cmd, const label_map_t *map)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr && ptr->vtbl && ptr->vtbl->label_remap_fn) {
    ptr->vtbl->label_remap_fn(cmd, map);
  }
}

void cmd_variable_remap(cmd_t cmd, const variable_map_t *map)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr && ptr->vtbl && ptr->vtbl->variable_remap_fn) {
    ptr->vtbl->variable_remap_fn(cmd, map);
  }
}

void cmd_value_remap(cmd_t cmd, const value_map_t *map)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr && ptr->vtbl && ptr->vtbl->value_remap_fn) {
    ptr->vtbl->value_remap_fn(cmd, map);
  }
}

void cmd_list_free(cmd_t cmd)
{
  while (cmd) {
    cmd_t link;

    link = cmd_link_get(cmd);
    cmd_free(cmd);
    cmd = link;
  }
}

cmd_t cmd_link_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) ? ptr->link : 0;
}

void cmd_link_set(cmd_t cmd, cmd_t link)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->link = link;
  }
}

cmd_t cmd_prev_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) ? ptr->prev : CMD_NONE;
}

void cmd_prev_set(cmd_t cmd, cmd_t prev)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->prev = prev;
  }
}

cmd_type_t cmd_type_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) ? ptr->type : CMD_TYPE_STATEMENT_END;
}

void       cmd_type_set(cmd_t cmd, cmd_type_t type)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->type = type;
  }
}

unsigned cmd_opt_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) ? ptr->opt : 0;
}

void cmd_opt_set(cmd_t cmd, unsigned opt)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->opt = opt;
  }
}

unsigned   cmd_line_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) ? ptr->pos.line : -1U;
}

void       cmd_line_set(cmd_t cmd, unsigned line)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->pos.line = line;
  }
}

pfile_source_t *cmd_source_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) ? ptr->pos.src : 0;
}

void cmd_source_set(cmd_t cmd, pfile_source_t *src)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    pfile_source_lock(src);
    if (ptr->pos.src) {
      pfile_source_release(ptr->pos.src);
    }
    ptr->pos.src = src;
  }
}

#if 0
static void cmd_varray_dump(variable_array_t *ary, const char *title,
  FILE *dst)
{
  size_t ii;

  fprintf(dst, ";      -->%s: ", title);
  for (ii = 0; ii < variable_array_entry_ct(ary); ii++) {
    variable_t  var;
    const char *fmt;
    unsigned    tag_n;

    var = *variable_array_entry_get(ary, ii);
    tag_n = variable_tag_n_get(var);
    fmt = tag_n ? "%s%s:%u" : "%s%s";
    fprintf(dst, fmt, (ii) ? ", " : "", variable_name_get(var), tag_n);
  }
  fputc('\n', dst);
}
#endif

void cmd_dump(cmd_t cmd, FILE *dst)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  if (ptr->vtbl && ptr->vtbl->dump_fn) {
    ptr->vtbl->dump_fn(cmd, dst);
  } else {
    const char *str;

    str = "{unknown}";
    switch (ptr->type) {
      case CMD_TYPE_ISR_CLEANUP:   str = "{isr_cleanup}";  break;
      case CMD_TYPE_END:           str = "{end}";          break;
      case CMD_TYPE_SLEEP:         str = "{sleep}";        break;
      case CMD_TYPE_NOP:           str = "{nop}";          break;
      case CMD_TYPE_BRANCH:        str = "{branch}";       break;
      case CMD_TYPE_OPERATOR:      str = "{operator}";     break;
      case CMD_TYPE_PROC_ENTER:    str = "{enter: %s}";    break;
      case CMD_TYPE_PROC_LEAVE:    str = "{leave: %s}";    break;
      case CMD_TYPE_BLOCK_START:   str = "{block}";        break;
      case CMD_TYPE_BLOCK_END:     str = "{end-of-block}"; break;
      case CMD_TYPE_STATEMENT_END: str = "{eos}";          break;
      case CMD_TYPE_ASM:           str = "{asm}";          break;
      case CMD_TYPE_LABEL:         str = "{label}";        break;
      case CMD_TYPE_USEC_DELAY:    str = "{usec-delay}";   break;
      case CMD_TYPE_ASSERT:        str = "{assert}";       break;
      case CMD_TYPE_COMMENT:       str = "{comment}";      break;
      case CMD_TYPE_LOG:           str = "{log}";          break;
    }
    if ((CMD_TYPE_PROC_ENTER == ptr->type)
      || (CMD_TYPE_PROC_LEAVE == ptr->type)) {
      fprintf(dst, str, pfile_proc_tag_get(cmd_proc_get(cmd)));
    } else {
      fprintf(dst, "%s", str);
    }
  }
  fputc('\n', dst);
#if 0
  cmd_varray_dump(cmd_gen_get(cmd), "gen", dst);
  cmd_varray_dump(cmd_kill_get(cmd), "kill", dst);
  cmd_varray_dump(cmd_live_in_get(cmd), "live-in", dst);
  cmd_varray_dump(cmd_live_out_get(cmd), "live-out", dst);
#endif
}

void cmd_flag_set_all(cmd_t cmd, flag_t flags)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags = flags;
  }
}

flag_t cmd_flag_get_all(cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) ? ptr->flags : 0;
}

void cmd_flag_set(cmd_t cmd, flag_t flag)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags |= flag;
  }
}

void cmd_flag_clr(cmd_t cmd, flag_t flag)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr) {
    ptr->flags = (ptr->flags & ~flag);
  }
}

boolean_t cmd_flag_test(const cmd_t cmd, flag_t flag)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) 
    ? ((ptr->flags & flag) == flag)
    : 0;
}

static int cmd_var_array_cmp(void *arg, const void *A, const void *B)
{
  variable_t a;
  variable_t b;
  UNUSED(arg);

  a = *(variable_t const *) A;
  b = *(variable_t const *) B;
  return (a > b) - (b > a);
}

static void cmd_var_array_add(cmd_t cmd, variable_t var, size_t ofs)
{
  while (variable_master_get(var)) {
    var = variable_master_get(var);
  }
  if (var && !variable_is_const(var)
    && (VARIABLE_BASE_UNKNOWN == variable_base_get(var, 0))) {
    struct cmd_ *ptr;

    ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
    if (ptr) {
      variable_array_t **ary;

      ary = (void *) ((unsigned char *) ptr + ofs);
      if (VARIABLE_ARRAY_NONE == *ary) {
        *ary = variable_array_alloc(0);
      }
      if (VARIABLE_ARRAY_NONE != *ary) {
        variable_array_entry_add(*ary, &var, ARRAY_ADD_FLAG_NONE,
          cmd_var_array_cmp, 0);
      }
    }
  }
}

static variable_array_t *cmd_var_array_get(cmd_t cmd, size_t ofs)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) 
    ? *(variable_array_t **) ((uchar *) ptr + ofs) 
    : VARIABLE_ARRAY_NONE;
}

void cmd_live_in_add(cmd_t cmd, variable_t var)
{
  cmd_var_array_add(cmd, var, offsetof(struct cmd_, live_in));
}

variable_array_t *cmd_live_in_get(cmd_t cmd)
{
  return cmd_var_array_get(cmd, offsetof(struct cmd_, live_in));
}

void cmd_live_out_add(cmd_t cmd, variable_t var)
{
  cmd_var_array_add(cmd, var, offsetof(struct cmd_, live_out));
}

variable_array_t *cmd_live_out_get(cmd_t cmd)
{
  return cmd_var_array_get(cmd, offsetof(struct cmd_, live_out));
}

void cmd_gen_add(cmd_t cmd, variable_t var)
{
  cmd_var_array_add(cmd, var, offsetof(struct cmd_, var_gen));
}

variable_array_t *cmd_gen_get(cmd_t cmd)
{
  return cmd_var_array_get(cmd, offsetof(struct cmd_, var_gen));

}

void cmd_kill_add(cmd_t cmd, variable_t var)
{
  cmd_var_array_add(cmd, var, offsetof(struct cmd_, var_kill));
}

variable_array_t *cmd_kill_get(cmd_t cmd)
{
  return cmd_var_array_get(cmd, offsetof(struct cmd_, var_kill));
}

/*
 * NAME
 *   cmd_next_exec_get
 *
 * DESCRIPTION
 *   get the next *executable* cmd
 *
 * PARAMETERS
 *   cmd : starting point
 *
 * RETURN
 *   next executable command
 *
 * NOTES
 *   this skips non-exectuable commands. it's helpful when looking
 *   past all labels
 */
boolean_t cmd_is_executable(cmd_t cmd)
{
  return (CMD_TYPE_NOP           != cmd_type_get(cmd))
      && (CMD_TYPE_LABEL         != cmd_type_get(cmd))
      && (CMD_TYPE_BLOCK_START   != cmd_type_get(cmd))
      && (CMD_TYPE_BLOCK_END     != cmd_type_get(cmd))
      && (CMD_TYPE_STATEMENT_END != cmd_type_get(cmd));
}

cmd_t cmd_next_exec_get(cmd_t cmd)
{
  while (cmd && !cmd_is_executable(cmd)) {
    cmd = cmd_link_get(cmd);
  }
  return cmd;
}

void cmd_remove(cmd_t *cmd_head, cmd_t cmd)
{
  cmd_t cmd_pv;

  if (cmd == *cmd_head) {
    cmd_pv = CMD_NONE;
  } else {
    for (cmd_pv = *cmd_head;
         cmd_link_get(cmd_pv) != cmd;
         cmd_pv = cmd_link_get(cmd_pv))
      ;
    if (!cmd_pv) {
      assert(0);
      cmd = CMD_NONE;
    }
  }
  if (CMD_NONE != cmd) {
    if (cmd_pv) {
      cmd_link_set(cmd_pv, cmd_link_get(cmd));
    } else {
      *cmd_head = cmd_link_get(cmd);
    }
    cmd_free(cmd);
  }
}

boolean_t cmd_is_reachable(cmd_t cmd)
{
  return cmd_flag_test(cmd, CMD_FLAG_USER)
    || cmd_flag_test(cmd, CMD_FLAG_INTERRUPT);
}

void cmd_label_remap2(cmd_t cmd, const label_map_t *map,
    label_t (*cmd_lbl_get)(const cmd_t cmd),
    void (*cmd_lbl_set)(cmd_t cmd, label_t lbl))
{
  label_t lbl;

  lbl = label_map_find(map, cmd_lbl_get(cmd));
  if (lbl) {
    cmd_lbl_set(cmd, lbl);
  }
}

void cmd_variable_remap2(cmd_t cmd, const variable_map_t *map,
    value_t (*cmd_val_get)(const cmd_t cmd), 
    void (*cmd_val_set)(cmd_t cmd, value_t n))
{
  value_t val;

  val = value_variable_remap(cmd_val_get(cmd), map);
  if (val) {
    cmd_val_set(cmd, val);
    value_release(val);
  }
}

void cmd_value_remap2(cmd_t cmd, const value_map_t *map,
    value_t (*cmd_val_get)(const cmd_t cmd),
    void (*cmd_val_set)(cmd_t cmd, value_t n))
{
  value_t val;

  val = value_map_find(map, cmd_val_get(cmd));
  if (val) {
    cmd_val_set(cmd, val);
  }
}

flag_t cmd_variable_accessed_get(const cmd_t cmd, variable_t var)
{
  struct cmd_ *ptr;
  flag_t       flags;

  flags = CMD_VARIABLE_ACCESS_FLAG_NONE;
  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  if (ptr && ptr->vtbl && ptr->vtbl->variable_accessed_fn) {
    flags = ptr->vtbl->variable_accessed_fn(cmd, var);
  }
  return flags;
}

flag_t cmd_value_accessed_get(const cmd_t cmd, value_t val)
{
  struct cmd_ *ptr;
  flag_t       flags;

  flags = CMD_VARIABLE_ACCESS_FLAG_NONE;
  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  if (ptr && ptr->vtbl && ptr->vtbl->value_accessed_fn) {
    flags = ptr->vtbl->value_accessed_fn(cmd, val);
  }
  return flags;
}

void cmd_gen_kill_set(cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr && ptr->vtbl && ptr->vtbl->assigned_used_set_fn) {
    ptr->vtbl->assigned_used_set_fn(cmd);
  }
}

cmd_successor_rc_t cmd_successor_get(cmd_t cmd, size_t ix, cmd_t *dst)
{
  struct cmd_       *ptr;
  cmd_successor_rc_t rc;

  ptr = cmd_element_seek(cmd, BOOLEAN_TRUE);
  if (ptr && ptr->vtbl && ptr->vtbl->successor_get_fn) {
    rc = ptr->vtbl->successor_get_fn(cmd, ix, dst);
  } else if ((0 == ix) && cmd_link_get(cmd)) {
    rc = CMD_SUCCESSOR_RC_DONE;
    *dst = cmd_link_get(cmd);
  } else {
    rc = CMD_SUCCESSOR_RC_IX_BAD;
  }
  return rc;
}


/*
 * live variable analysis is rather simple. each command
 * may either generate (use) a value, or kill (assign)
 * a value.
 *   live_in[S] = gen[S] U (live_out[S] - kill[S])
 *   live_out[S] = U live_in[p] (for all successors)
 * it turns out infinitely faster to do the analysis back
 * to front.
 */
void cmd_variable_live_analyze(cmd_t head)
{
  cmd_t     prev;
  cmd_t     cmd;
  cmd_t     tail;
  boolean_t changed;
  unsigned  iter;

  /* first set all of the prev links, and generate the gen/kill arrays */
  for (cmd = head, prev = CMD_NONE;
       cmd;
       prev = cmd, cmd = cmd_link_get(cmd)) {
    cmd_prev_set(cmd, prev);
    cmd_gen_kill_set(cmd);
  }
  /* this analysis far more efficient when done back to front, 
   * so we keep the tail */
  tail = prev;
  iter = 0;
  do {
    changed = BOOLEAN_FALSE;
    iter++;
    for (cmd = tail; CMD_NONE != cmd; cmd = cmd_prev_get(cmd)) {
      size_t             ct_live_out;
      size_t             ct_live_in;
      size_t             succ_ix;
      cmd_successor_rc_t rc;
      variable_array_t  *ary;
      variable_array_t  *ary_kill;
      variable_array_t  *ary_live_out;
      size_t             ary_kill_ct;
      size_t             ary_live_out_ct;
      size_t             ary_kill_ix;
      size_t             ary_live_out_ix;
      size_t             ct;
      size_t             ix;

      ct_live_out = variable_array_entry_ct(cmd_live_out_get(cmd));
      ct_live_in  = variable_array_entry_ct(cmd_live_in_get(cmd));

      /* live_out[S] = U live_in[p] (for all successors) */
      succ_ix = 0;
      do {
        cmd_t succ;

        rc = cmd_successor_get(cmd, succ_ix, &succ);
        if (CMD_SUCCESSOR_RC_IX_BAD != rc) {
          ary = cmd_live_in_get(succ);
          ct  = variable_array_entry_ct(ary);
          for (ix = 0; ix < ct; ix++) {
            cmd_live_out_add(cmd, *variable_array_entry_get(ary, ix));
          }
          succ_ix++;
        }
      } while (CMD_SUCCESSOR_RC_MORE == rc);

      /* live_in[S] = gen[S] U (live_out[S] - kill[S]) */

      /* live_in[S] = live_out[S] - kill[S] */
      ary_live_out    = cmd_live_out_get(cmd);
      ary_live_out_ct = variable_array_entry_ct(ary_live_out);
      ary_live_out_ix = 0;

      ary_kill        = cmd_kill_get(cmd);
      ary_kill_ct     = variable_array_entry_ct(ary_kill);
      ary_kill_ix     = 0;

      while (ary_live_out_ix < ary_live_out_ct) {
        /* line up ary_kill_ix */
        while ((ary_kill_ix < ary_kill_ct)
          && (*variable_array_entry_get(ary_kill, ary_kill_ix)
            < *variable_array_entry_get(ary_live_out, ary_live_out_ix))) {
          ary_kill_ix++;
        }
        if ((ary_kill_ix == ary_kill_ct)
          || (*variable_array_entry_get(ary_live_out, ary_live_out_ix)
            != *variable_array_entry_get(ary_kill, ary_kill_ix))) {
          cmd_live_in_add(cmd, *variable_array_entry_get(ary_live_out,
            ary_live_out_ix));
        }
        ary_live_out_ix++;
      }

      /* live_in[S] += gen[S] */
      ary = cmd_gen_get(cmd);
      ct  = variable_array_entry_ct(ary);
      for (ix = 0; ix < ct; ix++) {
        cmd_live_in_add(cmd, *variable_array_entry_get(ary, ix));
      }

      changed |= (ct_live_out != variable_array_entry_ct(cmd_live_out_get(cmd)))
              || (ct_live_in  != variable_array_entry_ct(cmd_live_in_get(cmd)));
    }
  } while (changed);
  /* printf("live variable analysis iterations: %u\n", iter); */
}

void cmd_pos_get(const cmd_t cmd, pfile_pos_t *pos)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  if (ptr) {
    *pos = ptr->pos;
  }
}

void cmd_variable_interference_generate(cmd_t cmd)
{
  while (cmd) {
    variable_array_t *live_in;
    size_t            ct;
    size_t            ix;

    live_in = cmd_live_in_get(cmd);
    ct      = variable_array_entry_ct(live_in);
    for (ix = 1; ix < ct; ix++) {
      variable_interference_add(
        *variable_array_entry_get(live_in, 0),
        *variable_array_entry_get(live_in, ix));
    }
    cmd = cmd_link_get(cmd);
  }
}

ulong cmd_id_get(const cmd_t cmd)
{
  struct cmd_ *ptr;

  ptr = cmd_element_seek(cmd, BOOLEAN_FALSE);
  return (ptr) ? ptr->serial_no : 0;
}

