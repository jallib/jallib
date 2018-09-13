/************************************************************
 **
 ** types.h : common type definitions
 **
 ** Copyright (c) 2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef types_h__
#define types_h__

#include <ctype.h>

#if 0
typedef unsigned char uchar;
typedef unsigned long ulong;
#else
#undef uchar
#undef ushort
#undef ulong
#define uchar  unsigned char
#define ushort unsigned short
#define ulong  unsigned long
#endif

typedef unsigned short boolean_t;
/* nb : *never* compare against BOOLEAN_TRUE! */
enum {BOOLEAN_FALSE, BOOLEAN_TRUE};

typedef unsigned long  flag_t;  /* flags             */
typedef unsigned short refct_t; /* reference counter */
typedef unsigned short ctr_t;   /* usage counter     */

typedef enum result_ {
  RESULT_OK = 0,    /* no error              */
  RESULT_MEMORY,    /* out of memory         */
  RESULT_SYNTAX,    /* syntax error          */
  RESULT_NOT_FOUND,
  RESULT_DIVIDE_BY_ZERO,
  RESULT_EXISTS,
  RESULT_RANGE,
  RESULT_INTERNAL,  /* invalid parameter passed to a function */
  RESULT_INVALID
} result_t;

typedef enum ctr_bump_ {
  CTR_BUMP_INCR = 0,
  CTR_BUMP_DECR
} ctr_bump_t;

#define TOLOWER(ch)  tolower((unsigned char) ch)
#define ISSPACE(ch)  isspace((unsigned char) ch)
#define ISALPHA(ch)  isalpha((unsigned char) ch)
#define ISDIGIT(ch)  isdigit((unsigned char) ch)
#define ISXDIGIT(ch) isxdigit((unsigned char) ch)
#define ISOCTDIGIT(x) (('0' == (x)) \
                    || ('1' == (x)) \
                    || ('2' == (x)) \
                    || ('3' == (x)) \
                    || ('4' == (x)) \
                    || ('5' == (x)) \
                    || ('6' == (x)) \
                    || ('7' == (x)))
#define ISBINDIGIT(x) (('0' == (x)) || ('1' == (x)))
#define COUNT(x) (sizeof(x)/sizeof(x[0]))

/* note to the compiler that a parameter isn't used */
#define UNUSED(x) ((void) (x))

#endif /* types_h__ */

