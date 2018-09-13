/************************************************************
 **
 ** pf_src.c : pfile source file declarations
 **
 ** Copyright (c) 2004-2005, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <string.h>
#include "../libutils/mem.h"
#include "pf_log.h"
#include "pf_src.h"
#include "pf_srcd.h"

result_t pfile_source_open(pfile_source_t **dst, const char *fname,
    pfile_t *pf)
{
  pfile_source_t *src;
  FILE           *f;
  size_t          sz;
  result_t        rc;

  f = fopen(fname, "rt");
  if (!f) {
    rc = RESULT_NOT_FOUND;
  } else {
    sz = 1 + strlen(fname);

    src = MALLOC(sizeof(*src) + sz);
    if (!src) {
      pfile_log_syserr(pf, RESULT_MEMORY);
      rc = RESULT_MEMORY;
      fclose(f);
    } else {
      src->ref_ct = 1;
      src->name = (void *) (src + 1);
      strcpy((void *) (src + 1), fname);
      src->f = f;
      src->link = PFILE_SOURCE_NONE;
      src->file_no = 0;
      rc = RESULT_OK;
      *dst = src;
    }
  }
  return rc;
}

void pfile_source_lock(pfile_source_t *src)
{
  if (src) {
    ++src->ref_ct;
  }
}

void pfile_source_release(pfile_source_t *src)
{
  if (src && !--src->ref_ct) {
    fclose(src->f);
    FREE(src);
  }
}

int pfile_source_ch_get(pfile_source_t *src)
{
  int ch;

  if (!src) {
    ch = EOF;
  } else if (-1 != src->ch_unget) {
    ch = src->ch_unget;
    src->ch_unget = -1;
  } else {
    if ('\n' == src->ch_last) {
      src->line_no++;
    }
    ch = fgetc(src->f);
  }
  src->ch_last = ch;
  return ch;
}

void pfile_source_ch_unget(pfile_source_t *src, int ch)
{
  if (src) {
    src->ch_unget = ch;
  }
}

unsigned pfile_source_line_get(const pfile_source_t *src)
{
  return (src) ? src->line_no : 0;
}


const char *pfile_source_name_get(const pfile_source_t *src)
{
  return (src) ? src->name : "";
}

void pfile_source_rewind(pfile_source_t *src)
{
  if (src) {
    rewind(src->f);
    src->line_no = 0;
    src->ch_unget = -1;
    src->ch_last  = '\n';
  }
}

pfile_source_t *pfile_source_link_get(const pfile_source_t *src)
{
  return (src) ? src->link : PFILE_SOURCE_NONE;
}

void pfile_source_link_set(pfile_source_t *src, pfile_source_t *link)
{
  if (src) {
    pfile_source_lock(link);
    pfile_source_release(src->link);
    src->link = link;
  }
}

void pfile_source_file_no_set(pfile_source_t *src, unsigned file_no)
{
  if (src) {
    src->file_no = file_no;
  }
}

unsigned pfile_source_file_no_get(const pfile_source_t *src)
{
  return (src) ? src->file_no : -1U;
}


