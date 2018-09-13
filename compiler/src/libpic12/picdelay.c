/************************************************************
 **
 ** picdelay.c : PIC delay generator
 **
 ** Copyright (c) 2004-2006, Kyle A. York
 ** All rights reserved
 **
 ************************************************************/
#include <math.h>
#include "pic_inst.h"
#include "pic_stvar.h"
#include "picdelay.h"

/*
 * NAME
 *   pic_delay_create
 *
 * DESCRIPTION
 *   create an n us delay
 *
 * PARAMETERS
 *   pf   :
 *   usec : # of usec to delay
 *
 * RETURN
 *   none
 *
 * NOTES
 *   all delays are inline. There are three used:
 *   1, 2, or 3 variable. all of them force PCLATH<4:3>
 *   to be set always.
 *   Governing equations
 *
 *   1 variable : (3x + 5);        8 instr;  8 <= cycles <=         773
 *   2 variable : y(5x+6) + 3;    14 instr; 14 <= cycles <=     329,219
 *   3 variable : z(y(5x+6)+6)+3; 20 instr; 20 <= cycles <=  84,280,835
 */
static unsigned long pic12_delay3_create(pfile_t *pf, unsigned long cycles)
{
  unsigned long x;
  unsigned long used;
  unsigned long best_x;
  unsigned long best_y;
  unsigned long best_z;
  unsigned long best_r;
  label_t       lblz;
  label_t       lbly;
  label_t       lblx;
  value_t       delay2;
  value_t       delay1;
  value_t       delay0;

  best_r = 0;
  best_x = 0;
  best_y = 0;
  best_z = 0;
  for (x = 1; x <= 256; x++) {
    unsigned long y;
    
    for (y = 1; y <= 256; y++) {
      unsigned long z;
      unsigned long r;

      z = (cycles - 3) / ( y * (5 * x + 6) + 6);
      if (z > 256) {
        z = 256;
      }

      r = z * ( y * ( 5 * x + 6) + 6 ) + 3;
      if ((r <= cycles) && (r > best_r)) {
        best_r = r;
        best_x = x;
        best_y = y;
        best_z = z;
      }
    }
  }
  used = best_z * ( best_y * (5 * best_x + 6) + 6) + 3;
  lblz = pfile_label_alloc(pf, 0);
  lbly = pfile_label_alloc(pf, 0);
  lblx = pfile_label_alloc(pf, 0);

  delay2 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);
  delay1 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);
  delay0 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);

  if (value_is_shared(delay0)) {
    pic_instr_append(pf, PIC_OPCODE_NOP);
    pic_instr_append(pf, PIC_OPCODE_NOP);
  } else {
    pic_instr_append_f(pf, PIC_OPCODE_DATALO_CLR, delay2, 0);
    pic_instr_append_f(pf, PIC_OPCODE_DATAHI_CLR, delay2, 0);
  }
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, best_z);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay2, 0);
  pic_instr_append_label(pf, lblz);
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, best_y);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay1, 0);
  pic_instr_append_label(pf, lbly);
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, best_x);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay0, 0);
  pic_instr_append_label(pf, lblx);
  pic_instr_append_n(pf, PIC_OPCODE_BRANCHHI_CLR, lblx);
  pic_instr_append_n(pf, PIC_OPCODE_BRANCHLO_CLR, lblx);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay0, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lblx);
  pic_instr_append_n(pf, PIC_OPCODE_BRANCHHI_CLR, lbly);
  pic_instr_append_n(pf, PIC_OPCODE_BRANCHLO_CLR, lbly);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay1, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbly);
  pic_instr_append_n(pf, PIC_OPCODE_BRANCHHI_CLR, lblz);
  pic_instr_append_n(pf, PIC_OPCODE_BRANCHLO_CLR, lblz);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay2, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lblz);

  pic_var_temp_release(pf, delay0);
  pic_var_temp_release(pf, delay1);
  pic_var_temp_release(pf, delay2);
  label_release(lblx);
  label_release(lbly);
  label_release(lblz);
  return used;
}

static unsigned long pic12_delay2_create(pfile_t *pf, unsigned long cycles)
{
  unsigned long x;
  unsigned long used;
  unsigned long best_x;
  unsigned long best_y;
  unsigned long best_r;
  label_t       lbly;
  label_t       lblx;
  value_t       delay1;
  value_t       delay0;

  best_r = 0;
  best_x = 0;
  best_y = 0;

  for (x = 1; x <= 256; x++) {
    unsigned long r;
    unsigned long y;

    y = (cycles - 3) / ( 5 * x + 6 );

    if (y > 256) {
      y = 256;
    }
    r = (y * ( 5 * x + 6) + 3);
    if ((r <= cycles) && (r > best_r)) {
      best_r = r;
      best_x = x;
      best_y = y;
    }
  }
  used = best_y * ( 5 * best_x + 6) + 3;
  pfile_log(pf, PFILE_LOG_DEBUG, "delay 2 {%lu,%lu}", best_y, best_x);
  /* now that we've a reasonable number, lets use it! */
  lbly = pfile_label_alloc(pf, 0);
  lblx = pfile_label_alloc(pf, 0);

  delay1 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);
  delay0 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);

  if (value_is_shared(delay0)) {
    pic_instr_append(pf, PIC_OPCODE_NOP);
    pic_instr_append(pf, PIC_OPCODE_NOP);
  } else {
    pic_instr_append_f(pf, PIC_OPCODE_DATALO_CLR, delay1, 0);
    pic_instr_append_f(pf, PIC_OPCODE_DATAHI_CLR, delay1, 0);
  }
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, best_y);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay1, 0);
  pic_instr_append_label(pf, lbly);
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, best_x);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay0, 0);
  pic_instr_append_label(pf, lblx);
  pic_instr_append_n(pf, PIC_OPCODE_BRANCHHI_CLR, lblx);
  pic_instr_append_n(pf, PIC_OPCODE_BRANCHLO_CLR, lblx);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay0, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lblx);
  pic_instr_append_n(pf, PIC_OPCODE_BRANCHHI_CLR, lbly);
  pic_instr_append_n(pf, PIC_OPCODE_BRANCHLO_CLR, lbly);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay1, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbly);

  pic_var_temp_release(pf, delay0);
  pic_var_temp_release(pf, delay1);
  label_release(lblx);
  label_release(lbly);
  return used;
}

static unsigned long pic12_delay_create(pfile_t *pf, unsigned long cycles)
{
  unsigned long used;

  /* 329216 is the maximum double-variable delay, so while n
     is greater than this, use the 3-variable delay */
  while (cycles > 329219UL) {
    used = pic12_delay3_create(pf, cycles);
    cycles -= used;
     pfile_log(pf, PFILE_LOG_DEBUG, 
        "...%lu cycles used in 3-var; %lu remaining", used, cycles);
  }
  /* 773 is the maximum single-variable delay, so while n is
     greater than this, use the 2-variable delay */
  while (cycles > 773) {
    used = pic12_delay2_create(pf, cycles);
    cycles -= used;
    pfile_log(pf, PFILE_LOG_DEBUG, 
        "...%lu cycles used in 2-var; %lu remaining", used, cycles);
  }
  /* 11 is the smallest value worthy of a loop */
  while (cycles >= 11) {
    unsigned long x;
    label_t       lbl;
    value_t       delay0;

    x = ((cycles - 5) / 3);
    if (x > 256) {
      x = 256;
    }
    used = (3 * x + 5);
    cycles -= used;
    pfile_log(pf, PFILE_LOG_DEBUG, 
        "...%lu cycles used in 1-var; %lu remaining", used, cycles);
    /* fix this */
    lbl = pfile_label_alloc(pf, 0);
    delay0 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);

    if (value_is_shared(delay0)) {
      pic_instr_append(pf, PIC_OPCODE_NOP);
      pic_instr_append(pf, PIC_OPCODE_NOP);
    } else {
      pic_instr_append_f(pf, PIC_OPCODE_DATALO_CLR, delay0, 0);
      pic_instr_append_f(pf, PIC_OPCODE_DATAHI_CLR, delay0, 0);
    }
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, (x == 256) ? 0 : x);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay0, 0);
    pic_instr_append_n(pf, PIC_OPCODE_BRANCHHI_CLR, lbl);
    pic_instr_append_n(pf, PIC_OPCODE_BRANCHLO_CLR, lbl);
    pic_instr_append_label(pf, lbl);
    pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay0, 0, PIC_OPDST_F);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    pic_var_temp_release(pf, delay0);
    label_release(lbl);
  }
  return cycles;
}

/*
 * 1 var :                    3x + 3;  5 instr ;  6 <= cycles <=        771
 * 2 var :          y ( 3x + 5 ) + 3;  9 instr ; 11 <= cycles <=    197,891
 * 3 var : z( y ( 3x + 5 ) + 5 ) + 3;          ; 16 <= cycles <= 50_660_611
 *
 * ... with movlp ...
 * 1 var :                    3x + 3;  6 instr ;  6 <= cycles <=        771
 * 2 var :          y ( 3x + 5 ) + 2; 11 instr ; 11 <= cycles <=    198,146
 * 3 var : z( y ( 3x + 5 ) + 5 ) + 3;          ; 16 <= cycles <= 50_660_611
 *
 */
#define PIC16_DELAY_CREATE_FLAG_NONE  0x0000
#define PIC16_DELAY_CREATE_FLAG_MOVLP 0x0001
static unsigned long pic16_delay3_create(pfile_t *pf, unsigned long cycles,
    unsigned flags)
{
  unsigned long x;
  unsigned long used;
  unsigned long best_x;
  unsigned long best_y;
  unsigned long best_z;
  unsigned long best_r;
  label_t       lblz;
  label_t       lbly;
  label_t       lblx;
  value_t       delay2;
  value_t       delay1;
  value_t       delay0;

  best_r = 0;
  best_x = 0;
  best_y = 0;
  best_z = 0;
  if (flags & PIC16_DELAY_CREATE_FLAG_MOVLP) {
    for (x = 1; x <= 256; x++) {
      unsigned long y;
      
      for (y = 1; y <= 256; y++) {
        unsigned long z;
        unsigned long r;

        z = (cycles - 2) / ( y * (3 * x + 6) + 5);
        if (z > 256) {
          z = 256;
        }

        r = z * ( y * ( 3 * x + 6) + 5 ) + 2;
        if ((r <= cycles) && (r > best_r)) {
          best_r = r;
          best_x = x;
          best_y = y;
          best_z = z;
        }
      }
    }
    used = best_z * ( best_y * (3 * best_x + 6) + 5) + 2;
  } else {
    for (x = 1; x <= 256; x++) {
      unsigned long y;
      
      for (y = 1; y <= 256; y++) {
        unsigned long z;
        unsigned long r;

        z = (cycles - 3) / ( y * (3 * x + 5) + 5);
        if (z > 256) {
          z = 256;
        }

        r = z * ( y * ( 3 * x + 5) + 5 ) + 3;
        if ((r <= cycles) && (r > best_r)) {
          best_r = r;
          best_x = x;
          best_y = y;
          best_z = z;
        }
      }
    }
    used = best_z * ( best_y * (3 * best_x + 5) + 5) + 3;
  }
  pfile_log(pf, PFILE_LOG_DEBUG, "delay 3 {%lu, %lu,%lu}", best_z, best_y, best_x);
  lblz = pfile_label_alloc(pf, 0);
  lbly = pfile_label_alloc(pf, 0);
  lblx = pfile_label_alloc(pf, 0);

  delay2 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);
  delay1 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);
  delay0 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);

  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLB, value_base_get(delay0) / 256);
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, best_z);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay2, 0);
  pic_instr_append_label(pf, lblz);
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, best_y);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay1, 0);
  pic_instr_append_label(pf, lbly);
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, best_x);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay0, 0);
  if (flags & PIC16_DELAY_CREATE_FLAG_MOVLP) {
    pic_code_t code;

    code = pic_instr_append_n(pf, PIC_OPCODE_MOVLP, lblx);
    pic_code_ofs_set(code, 1);
  }
  pic_instr_append_label(pf, lblx);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay0, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lblx);
  if (flags & PIC16_DELAY_CREATE_FLAG_MOVLP) {
    pic_code_t code;

    code = pic_instr_append_n(pf, PIC_OPCODE_MOVLP, lbly);
    pic_code_ofs_set(code, 1);
  }
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay1, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbly);
  if (flags & PIC16_DELAY_CREATE_FLAG_MOVLP) {
    pic_code_t code;

    code = pic_instr_append_n(pf, PIC_OPCODE_MOVLP, lblz);
    pic_code_ofs_set(code, 1);
  }
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay2, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lblz);

  pic_var_temp_release(pf, delay0);
  pic_var_temp_release(pf, delay1);
  pic_var_temp_release(pf, delay2);
  label_release(lblx);
  label_release(lbly);
  label_release(lblz);
  return used;
}

static unsigned long pic16_delay2_create(pfile_t *pf, unsigned long cycles, 
    unsigned flags)
{
  unsigned long x;
  unsigned long used;
  unsigned long best_x;
  unsigned long best_y;
  unsigned long best_r;
  label_t       lbly;
  label_t       lblx;
  value_t       delay1;
  value_t       delay0;

  best_r = 0;
  best_x = 0;
  best_y = 0;

  if (flags & PIC16_DELAY_CREATE_FLAG_MOVLP) { 
    for (x = 1; x <= 256; x++) {
      unsigned long r;
      unsigned long y;

      y = (cycles - 2) / ( 3 * x + 6 );

      if (y > 256) {
        y = 256;
      }
      r = (y * ( 3 * x + 6) + 2);
      if ((r <= cycles) && (r > best_r)) {
        best_r = r;
        best_x = x;
        best_y = y;
      }
    }
    used = best_y * ( 3 * best_x + 6) + 2;
  } else {
    for (x = 1; x <= 256; x++) {
      unsigned long r;
      unsigned long y;

      y = (cycles - 3) / ( 3 * x + 5 );

      if (y > 256) {
        y = 256;
      }
      r = (y * ( 3 * x + 5) + 3);
      if ((r <= cycles) && (r > best_r)) {
        best_r = r;
        best_x = x;
        best_y = y;
      }
    }
    used = best_y * ( 3 * best_x + 5) + 3;
  }
  pfile_log(pf, PFILE_LOG_DEBUG, "delay 2 {%lu,%lu}", best_y, best_x);
  /* now that we've a reasonable number, lets use it! */
  lbly = pfile_label_alloc(pf, 0);
  lblx = pfile_label_alloc(pf, 0);

  delay1 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);
  delay0 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLB, value_base_get(delay0) / 256);
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, best_y & 0xff);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay1, 0);
  pic_instr_append_label(pf, lbly);
  pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, best_x & 0xff);
  pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay0, 0);
  if (flags & PIC16_DELAY_CREATE_FLAG_MOVLP) {
    pic_code_t code;

    code = pic_instr_append_n(pf, PIC_OPCODE_MOVLP, lblx);
    pic_code_ofs_set(code, 1);
  }
  pic_instr_append_label(pf, lblx);
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay0, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lblx);
  if (flags & PIC16_DELAY_CREATE_FLAG_MOVLP) {
    pic_code_t code;

    code = pic_instr_append_n(pf, PIC_OPCODE_MOVLP, lbly);
    pic_code_ofs_set(code, 1);
  }
  pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay1, 0, PIC_OPDST_F);
  pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbly);
  label_release(lblx);
  label_release(lbly);
  pic_var_temp_release(pf, delay0);
  pic_var_temp_release(pf, delay1);
  return used;
}

static unsigned long pic16_delay_create(pfile_t *pf, unsigned long cycles,
  unsigned flag)
{
  unsigned long used;

  /* 329216 is the maximum double-variable delay, so while n
     is greater than this, use the 3-variable delay */
  while (cycles > 197891UL) {
    used = pic16_delay3_create(pf, cycles, flag);
    cycles -= used;
     pfile_log(pf, PFILE_LOG_DEBUG, 
        "...%lu cycles used in 3-var; %lu remaining", used, cycles);
  }
  /* 771 is the maximum single-variable delay, so while n is
     greater than this, use the 2-variable delay */
  while (cycles > 771) {
    used = pic16_delay2_create(pf, cycles, flag);
    cycles -= used;
    pfile_log(pf, PFILE_LOG_DEBUG, 
        "...%lu cycles used in 2-var; %lu remaining", used, cycles);
  }
  /* 6 is the smallest value worthy of a loop */
  while (cycles >= 6) {
    unsigned long x;
    label_t       lbl;
    value_t       delay0;

    x = ((cycles - 3) / 3);
    if (x > 256) {
      x = 256;
    }
    used = (3 * x + 3);
    cycles -= used;
    pfile_log(pf, PFILE_LOG_DEBUG, 
        "...%lu cycles used in 1-var; %lu remaining", used, cycles);
    /* fix this */
    lbl = pfile_label_alloc(pf, 0);
    delay0 = pic_var_temp_get(pf, VARIABLE_FLAG_NONE, 1);

    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLB, value_base_get(delay0) / 256);
    pic_instr_append_w_kn(pf, PIC_OPCODE_MOVLW, (x == 256) ? 0 : x);
    pic_instr_append_f(pf, PIC_OPCODE_MOVWF, delay0, 0);
    if (flag & PIC16_DELAY_CREATE_FLAG_MOVLP) {
      pic_code_t code;

      code = pic_instr_append_n(pf, PIC_OPCODE_MOVLP, lbl);
      pic_code_ofs_set(code, 1);
    }
    pic_instr_append_label(pf, lbl);
    pic_instr_append_f_d(pf, PIC_OPCODE_DECFSZ, delay0, 0, PIC_OPDST_F);
    pic_instr_append_n(pf, PIC_OPCODE_GOTO, lbl);
    pic_var_temp_release(pf, delay0);
    label_release(lbl);
  }
  return cycles;
}

void pic_delay_create(pfile_t *pf, variable_const_t usec)
{
  double        dcycles;
  unsigned long cycles;
  unsigned long used;
  value_t       freq;

  pic_instr_default_flag_set(pf, PIC_CODE_FLAG_NO_OPTIMIZE);
  freq = pfile_value_find(pf, PFILE_LOG_ERR, "target_clock");
  /* cycles = # of cycles needed. this is computed in floating point
   * to allow for odd frequencies without long integer overflow */
  dcycles = 1.0 * usec * value_const_get(freq) / 4000000;
  cycles = ceil(dcycles);
  value_release(freq);
  pfile_log(pf, PFILE_LOG_DEBUG, "delay %lu requires %lu cycles", 
      usec, cycles);
  used = 0;
  switch (pic_target_cpu_get(pf)) {
    case PIC_TARGET_CPU_NONE:
    case PIC_TARGET_CPU_SX_12:
        break;
    case PIC_TARGET_CPU_12BIT:
    case PIC_TARGET_CPU_14BIT:
        used = pic12_delay_create(pf, cycles);
        break;
    case PIC_TARGET_CPU_14HBIT:
        used = pic16_delay_create(pf, cycles, PIC16_DELAY_CREATE_FLAG_MOVLP);
        break;
    case PIC_TARGET_CPU_16BIT:
        used = pic16_delay_create(pf, cycles, PIC16_DELAY_CREATE_FLAG_NONE);
        break;
  }
  if (used) {
    pfile_log(pf, PFILE_LOG_DEBUG, 
        "...%lu cycles used in no-ops", used);
  }
  while (used--) {
    /* filler */
    pic_instr_append(pf, PIC_OPCODE_NOP);
  }
  pic_instr_default_flag_clr(pf, PIC_CODE_FLAG_NO_OPTIMIZE);
}

