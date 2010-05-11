//JAT V0.1 - Just Another Translator (Jal -> C code converter)


//----- JAT code start --------------------------------------------------------
#include <stdio.h>
#include <stdint.h>

#include "jaltarget.h"




#include "cbuild/lpc2xxx.h"

void delay_ms( uint32_t ms) { 
   static void *this_function = delay_ms;

   volatile int i, j;        
   for (j=0; j<ms; j++) {    
   for (i=0; i< 960; i++);
   }                         
}

void io0_dir_out( uint8_t bitnr) { 
   static void *this_function = io0_dir_out;

   IODIR0  |= (1 << bitnr); 
}

void io0_set( uint8_t bitnr) { 
   static void *this_function = io0_set;

   IOSET0  =  (1 << bitnr);
}

void io0_clr( uint8_t bitnr) { 
   static void *this_function = io0_clr;

   IOCLR0  =  (1 << bitnr);
}

uint32_t LED = 31;

int main(int argc, char **argv) {

   io0_dir_out(LED);
   for (;;) {
      io0_set(LED);
      delay_ms(500);
      io0_clr(LED);
      delay_ms(100);
   }

} 
// JAT finished, 0 warnings, 0 errors.
//----- JAT code end ----------------------------------------------------------

