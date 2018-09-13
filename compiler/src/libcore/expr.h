/************************************************************
 **
 ** expr.h : expression structure declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef expr_h__
#define expr_h__

#include "variable.h"
#include "operator.h"
#include "value.h"

typedef struct expr_ expr_t;

result_t    expr_alloc(expr_t **edst, operator_t op, value_t val);
void        expr_free(expr_t *expr);
void        expr_val_set(expr_t *expr, value_t var);
value_t     expr_val_get(const expr_t *expr);
void        expr_operator_set(expr_t *expr, operator_t op);
operator_t  expr_operator_get(const expr_t *expr);
expr_t     *expr_link_get(const expr_t *expr);
void        expr_link_set(expr_t *expr, expr_t *dst);

void        expr_list_free(expr_t **head);

#if defined (MSDOS) && !defined (__WATCOMC__)
#include "exprd.h"
#endif

#endif /* expr_h__ */

