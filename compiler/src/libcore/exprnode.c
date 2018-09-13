/************************************************************
 **
 ** exprnode.c : expression node definitions
 **
 ** Copyright (c) 2009, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <assert.h>

#include "value.h"
#include "operator.h"
#define ARRAY_DEFINE
#include "exprnode.h"
#include "../libutils/mem.h"

static unsigned expr_node_id;

struct expr_node_
{
  unsigned              ref_ct;
  unsigned              id;
  unsigned              flags;
  value_t               val;
  expr_node_array_t    *noderef;
  expr_node_op_array_t *children; 
};

/*
 * this simply resets the global node id to simplify
 * debugging.
 */
void expr_node_id_reset(void)
{
  expr_node_id = 0;
}

expr_node_t expr_node_alloc(value_t val)
{
  expr_node_t node;

  node = MALLOC(sizeof(*node));
  if (node) {
    node->id       = ++expr_node_id;
    node->ref_ct   = 1;
    node->flags    = 0;
    node->val      = VALUE_NONE;
    node->children = EXPR_NODE_OP_ARRAY_NONE;
    node->noderef  = EXPR_NODE_ARRAY_NONE;

    expr_node_value_set(node, val);
  }

  return node;
}

void expr_node_lock(expr_node_t node)
{
  if (node) {
    node->ref_ct++;
  }
}

void expr_node_release(expr_node_t node)
{
  if (node) {
    assert(node->ref_ct);
    node->ref_ct--;
    if (!node->ref_ct) {
      size_t ii;

      ii = expr_node_op_array_entry_ct(node->children);
      while (ii--) {
        expr_node_op_free(*expr_node_op_array_entry_get(node->children, ii));
      }
      expr_node_op_array_free(node->children);
      expr_node_value_set(node, VALUE_NONE);
      ii = expr_node_array_entry_ct(node->noderef);
      while (ii--) {
        expr_node_release(*expr_node_array_entry_get(node->noderef, ii));
      }
      expr_node_array_free(node->noderef);
    }
  }
}

unsigned expr_node_refct_get(const expr_node_t node)
{
  return (node) ? node->ref_ct : 0;
}

unsigned expr_node_id_get(const expr_node_t node)
{
  return (node) ? node->id : 0;
}

boolean_t expr_node_flag_test(const expr_node_t node, unsigned flag)
{
  return (node) ? ((node->flags & flag) != 0) : 0; /* BOOLEAN_FALSE; */
}

void expr_node_flag_set(expr_node_t node, unsigned flag)
{
  if (node) {
    node->flags |= flag;
  }
}

value_t expr_node_value_get(const expr_node_t node)
{
  return (node) ? node->val : VALUE_NONE;
}

void expr_node_value_set(expr_node_t node, value_t val)
{
  if (node) {
    value_lock(val);
    value_release(node->val);
    node->val = val;
  }
}

expr_node_t expr_node_dup(const expr_node_t node)
{
  expr_node_t dnode;

  dnode = EXPR_NODE_NONE;
  if (node) {
    dnode = expr_node_alloc(node->val);
    if (dnode) {
      if (node->children) {
        size_t ii;
        size_t ct;

        ct = expr_node_op_array_entry_ct(node->children);
        for (ii = 0; ii < ct; ii++) {
          expr_node_op_t nodeop;

          nodeop = *expr_node_op_array_entry_get(node->children, ii);
          expr_node_child_append(dnode, 
            expr_node_op_node_get(nodeop),
            expr_node_op_op_get(nodeop));
        }
      }
    }
  }
  return dnode;
}

expr_node_array_t *expr_node_children_get(const expr_node_t node)
{
  return (node) ? node->children : EXPR_NODE_ARRAY_NONE;
}

void expr_node_child_append(expr_node_t node, expr_node_t child,
  operator_t op)
{
  if (node && child) {
    if (!node->children) {
      node->children = expr_node_op_array_alloc(1);
    }
    if (node->children) {
      expr_node_op_t nodeop;

      nodeop = expr_node_op_alloc(child, op);
      (void) expr_node_op_array_entry_append(node->children, &nodeop);
    }
  }
}

/*
 * if a node's children are expanded directly into a node,
 * I still need to keep a reference to the expanded node
 * otherwise it will end up getting code generated for it
 */
void expr_node_noderef_add(expr_node_t node, expr_node_t cnode)
{
  if (!node->noderef) {
    node->noderef = expr_node_array_alloc(1);
  }
  if (node->noderef) {
    expr_node_lock(cnode);
    (void) expr_node_array_entry_append(node->noderef, &cnode);
  }
}


/*
 * the operator works on the node -- aka, the leftmost operator
 * of the children must be OPERATOR_NULL
 */
struct expr_node_op_ {
  operator_t  op;
  expr_node_t node;
};

expr_node_op_t expr_node_op_alloc(expr_node_t node, operator_t op)
{
  expr_node_op_t nodeop;

  nodeop = MALLOC(sizeof(*nodeop));
  if (nodeop) {
    nodeop->node = EXPR_NODE_NONE;
    nodeop->op   = op;
    expr_node_op_node_set(nodeop, node);
  }
  return nodeop;
}

void expr_node_op_free(expr_node_op_t nodeop)
{
  if (nodeop) {
    expr_node_op_node_set(nodeop, EXPR_NODE_NONE);
    FREE(nodeop);
  }
}

operator_t expr_node_op_op_get(expr_node_op_t nodeop)
{
  return (nodeop) ? nodeop->op : OPERATOR_NULL;
}

void expr_node_op_op_set(expr_node_op_t nodeop, operator_t op)
{
  if (nodeop) {
    nodeop->op = op;
  }
}

expr_node_t expr_node_op_node_get(expr_node_op_t nodeop)
{
  return (nodeop) ? nodeop->node : EXPR_NODE_NONE;
}

void expr_node_op_node_set(expr_node_op_t nodeop, expr_node_t node)
{
  if (nodeop) {
    expr_node_lock(node);
    expr_node_release(nodeop->node);
    nodeop->node = node;
  }
}

