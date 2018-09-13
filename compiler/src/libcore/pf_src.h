/************************************************************
 **
 ** pf_src.h : pfile source API declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#ifndef pf_src_h__
#define pf_src_h__

#include "../libutils/types.h"
#include "univ.h"

#define PFILE_SOURCE_NONE ((pfile_source_t *) 0)

struct pfile_pos_ {
  unsigned        line;
  pfile_source_t *src;
};

result_t pfile_source_open(pfile_source_t **dst, const char *fname,
    pfile_t *pf);
void pfile_source_lock(pfile_source_t *src);
void pfile_source_release(pfile_source_t *src);

pfile_source_t *pfile_source_link_get(const pfile_source_t *src);
void            pfile_source_link_set(pfile_source_t *src, 
    pfile_source_t *link);

int  pfile_source_ch_get(pfile_source_t *src);
void pfile_source_ch_unget(pfile_source_t *src, int ch);
unsigned pfile_source_line_get(const pfile_source_t *src);
const char *pfile_source_name_get(const pfile_source_t *src);

void pfile_source_rewind(pfile_source_t *src);

void pfile_source_file_no_set(pfile_source_t *src, unsigned file_no);
unsigned pfile_source_file_no_get(const pfile_source_t *src);

#endif /* pf_src_h__ */


