/************************************************************
 **
 ** piccolst.c : pic code list definitions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <assert.h>
#include "piccolst.h"

typedef struct pic_code_list_ {
  pic_code_t head;
  pic_code_t tail;
  unsigned   ct;
} pic_code_list_t;

static pic_code_list_t pic_code_lst;

#if 0
static void pic_code_list_check(pfile_t *pf)
{
  unsigned   ct;
  pic_code_t code;
  pic_code_t code2;

  for (ct = 0, 
         code = pic_code_list_head_get(pf),
         code2 = pic_code_next_get(code);
       code;
       ct++, 
         code = pic_code_next_get(code),
         code2 = pic_code_next_get(pic_code_next_get(code2))) {
    assert(code != code2);
    if (pic_code_prev_get(code)) {
      assert(pic_code_next_get(pic_code_prev_get(code)) == code);
    } else {
      assert(pic_code_list_head_get(pf) == code);
    }

    if (pic_code_next_get(code)) {
      assert(pic_code_prev_get(pic_code_next_get(code)) == code);
    } else {
      assert(pic_code_list_tail_get(pf) == code);
    }
  }
  assert(ct == pic_code_lst.ct);
}
#else
#define pic_code_list_check(x)
#endif

pic_code_t pic_code_list_head_get(pfile_t *pf)
{
  UNUSED(pf);

  return pic_code_lst.head;
}

pic_code_t pic_code_list_tail_get(pfile_t *pf)
{
  UNUSED(pf);

  return pic_code_lst.tail;
}

unsigned pic_code_list_ct_get(pfile_t *pf)
{
  UNUSED(pf);

  return pic_code_lst.ct;
}

pic_pc_t pic_code_list_pc_next_get(pfile_t *pf)
{
  pic_opcode_t op_pv;
  pic_pc_t     pc;

  UNUSED(pf);

  op_pv = pic_code_op_get(pic_code_lst.tail);
  pc    = pic_code_pc_get(pic_code_lst.tail);
  if ((PIC_OPCODE_ORG != op_pv)
    && (PIC_OPCODE_END != op_pv)
    && (PIC_OPCODE_NONE != op_pv)) {
    pc++;
  }
  return pc;
}

void pic_code_list_append(pfile_t *pf, pic_code_t code)
{
  UNUSED(pf);

  assert(!pic_code_prev_get(code));
  assert(!pic_code_next_get(code));
  if (!pic_code_lst.head) {
    pic_code_lst.head = code;
  } else {
    pic_code_prev_set(code, pic_code_lst.tail);
    pic_code_next_set(pic_code_lst.tail, code);
  }
  pic_code_lst.tail = code;
  pic_code_lst.ct++;
  pic_code_list_check(pf);
}

void pic_code_list_insert(pfile_t *pf, pic_code_t pv, pic_code_t code)
{
  pic_code_t next;

  UNUSED(pf);

  assert(!pic_code_prev_get(code));
  assert(!pic_code_next_get(code));
  assert(pv);

  next = pic_code_next_get(pv);

  pic_code_prev_set(code, pv);
  pic_code_next_set(pv, code);

  pic_code_next_set(code, next);
  if (next) {
    pic_code_prev_set(next, code);
  } else {
    pic_code_lst.tail = code;
  } 
  pic_code_lst.ct++;
  pic_code_list_check(pf);
}


void pic_code_list_remove(pfile_t *pf, pic_code_t code)
{
  pic_code_t code_prev;
  pic_code_t code_next;

  UNUSED(pf);

  code_prev = pic_code_prev_get(code);
  code_next = pic_code_next_get(code);

  pic_code_next_set(code_prev, code_next);
  pic_code_prev_set(code_next, code_prev);

  if (code == pic_code_lst.head) {
    pic_code_lst.head = code_next;
  }
  if (code == pic_code_lst.tail) {
    pic_code_lst.tail = code_prev;
  }
  pic_code_prev_set(code, PIC_CODE_NONE);
  pic_code_next_set(code, PIC_CODE_NONE);
  pic_code_lst.ct--;
  pic_code_list_check(pf);
  if (pic_code_label_get(code)) {
    label_code_set(pic_code_label_get(code), code_next);
  }
}

void pic_code_list_reset(pfile_t *pf)
{
  UNUSED(pf);

  while (pic_code_lst.head) {
    pic_code_t code;

    code = pic_code_lst.head;
    pic_code_lst.head = pic_code_next_get(code);

    pic_code_free(code);
  }
  pic_code_lst.tail = 0;
  pic_code_lst.ct   = 0;
}

void pic_code_list_init(pfile_t *pf)
{
  UNUSED(pf);

  pic_code_lst.head = PIC_CODE_NONE;
  pic_code_lst.tail = PIC_CODE_NONE;
  pic_code_lst.ct   = 0;
}

