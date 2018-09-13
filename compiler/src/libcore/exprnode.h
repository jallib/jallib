/************************************************************
 **
 ** exprnode.h : expression node API declarations
 **
 ** Copyright (c) 2009, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef exprnode_h__
#define exprnode_h__

#include "value.h"
#include "operator.h"
#include "../libutils/array.h"

typedef struct expr_node_ *expr_node_t;
ARRAY_DEF(expr_node_array, expr_node_t)
#define EXPR_NODE_NONE ((expr_node_t ) 0)
#define EXPR_NODE_ARRAY_NONE ((expr_node_array_t *) 0)

typedef struct expr_node_op_ *expr_node_op_t;
ARRAY_DEF(expr_node_op_array, expr_node_op_t)
#define EXPR_NODE_OP_NONE ((expr_node_op_t) 0)
#define EXPR_NODE_OP_ARRAY_NONE ((expr_node_op_array_t *) 0)

void                  expr_node_id_reset(void);

expr_node_t           expr_node_alloc(value_t val);
void                  expr_node_lock(expr_node_t node);
void                  expr_node_release(expr_node_t node);

unsigned              expr_node_refct_get(const expr_node_t node);
unsigned              expr_node_id_get(const expr_node_t node);

#define EXPR_NODE_FLAG_NONE      0x0000
#define EXPR_NODE_FLAG_GENERATED 0x0001 /* code has been generated */
                                        /* for this node           */
boolean_t             expr_node_flag_test(const expr_node_t node, 
                        unsigned flag);
void                  expr_node_flag_set(expr_node_t node,
                        unsigned flag);

value_t               expr_node_value_get(const expr_node_t node);
void                  expr_node_value_set(expr_node_t node, value_t val);

expr_node_t           expr_node_dup(const expr_node_t node);

expr_node_op_array_t *expr_node_children_get(const expr_node_t node);
void                  expr_node_child_append(expr_node_t node, 
                        expr_node_t child, operator_t op);

void                  expr_node_noderef_add(expr_node_t node, 
                        expr_node_t cnode);

expr_node_op_t        expr_node_op_alloc(expr_node_t node, operator_t op);
void                  expr_node_op_free(expr_node_op_t nodeop);

operator_t            expr_node_op_op_get(expr_node_op_t nodeop);
void                  expr_node_op_op_set(expr_node_op_t nodeop,
                        operator_t op);

expr_node_t           expr_node_op_node_get(expr_node_op_t nodeop);
void                  expr_node_op_node_set(expr_node_op_t nodeop, 
                        expr_node_t node);

#endif /* exprnode_h__ */

