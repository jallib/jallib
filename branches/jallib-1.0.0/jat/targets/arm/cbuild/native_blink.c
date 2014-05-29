#include "lpc2xxx.h"

void delay(int ms)
{  volatile int i, j;
   for (j=0; j<ms; j++) {
   	for (i=0; i< 960; i++);
   }
}

int main(int argc, char **argv)
{   
	IODIR0 |= 0x10000;	// port 0.16 output
	IOSET0  = 0x10000;	// port 0.16 high => led OFF

   for (;;)	 {
   	IOCLR0  = 0x10000;	// port 0.16 low => LED on
   	delay(300);
   	IOSET0  = 0x10000;	// port 0.16 high => LED off
   	delay(300);
   }
}