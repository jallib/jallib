//JAT V0.1 - Just Another Translator (Jal -> C code converter)


//----- JAT code start --------------------------------------------------------
#include <stdio.h>
#include <stdint.h>

#include "jaltarget.h"


#include <avr/io.h>

#define F_CPU 16000000

// Some macros that make the code more readable
#define output_low(port,pin) port &= ~(1<<pin)
#define output_high(port,pin) port |= (1<<pin)
#define set_input(portdir,pin) portdir &= ~(1<<pin)
#define set_output(portdir,pin) portdir |= (1<<pin)

void delay_ms( uint8_t ms) { 
   static void *this_function = delay_ms;

   uint16_t delay_count = F_CPU / 17500;
   volatile uint16_t i;
   
   while (ms != 0) {
   for (i=0; i != delay_count; i++);
   ms--;
   }
}

uint8_t LED = 4;

int main(int argc, char **argv) {

   set_output(DDRB,LED);
   for (;;) {
      output_high(PORTB,LED);
      delay_ms(200);
      output_low(PORTB,LED);
      delay_ms(200);
   }

} 
//----- JAT code end ----------------------------------------------------------

