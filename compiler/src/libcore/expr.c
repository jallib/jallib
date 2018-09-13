/**********************************************************
 **
 ** expr.c : operators on expr_t
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ***********************************************************/
#include "../libutils/mem.h"
#include "expr.h"
#include "exprd.h"

result_t expr_alloc(expr_t **dst, operator_t op, value_t val)
{
  int     rc;
  expr_t *ptr;

  ptr = MALLOC(sizeof(*ptr));
  if (0 == ptr) {
    rc = RESULT_MEMORY;
  } else {
    rc = RESULT_OK;
    ptr->link = 0;
    ptr->val  = 0;
    expr_operator_set(ptr, op);
    expr_val_set(ptr, val);
    *dst = ptr;
  }
  return rc;
}

void expr_free(expr_t *expr)
{
  expr_val_set(expr, 0);
  FREE(expr);
}

void expr_val_set(expr_t *expr, value_t var)
{
  if (var) {
    value_lock(var);
  }
  if (expr->val) {
    value_release(expr->val);
  }
  expr->val = var;
}

value_t expr_val_get(const expr_t *expr)
{
  return expr->val;
}

void expr_operator_set(expr_t *expr, operator_t op)
{
  expr->op = op;
}

operator_t expr_operator_get(const expr_t *expr)
{
  return expr->op;
}

expr_t *expr_link_get(const expr_t *expr)
{
  return expr->link;
}

void expr_link_set(expr_t *expr, expr_t *dst)
{
  expr->link = dst;
}

void expr_list_free(expr_t **head)
{
  expr_t *exprstk;

  exprstk = *head;
  while (exprstk) {
    /* free any remaining elements. unless an error has occured,
       there should be only one */
    expr_t *link;

    link = expr_link_get(exprstk);
    expr_free(exprstk);
    exprstk = link;
  }
  *head = exprstk;
}

