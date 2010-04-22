
Rem Translate JAL to C
..\jalparser blink_avr.jal >blink_avr.c

Rem Compile C-file to elf-file
c:\MyRobot\winavr\bin\avr-gcc -g -Wall -Os -mmcu=atmega168p  -IAVRlib -I. -I./libs -o blink_avr.elf blink_avr.c

Rem convert elf to hex file
c:\MyRobot\winavr\bin\avr-objcopy -j .text -j .data -O ihex blink_avr.elf blink_avr.hex  

rem line below programs target. Remove REM and reset target before you execute this line...
rem c:\MyRobot\winavr\bin\avrdude -F -V -CC:\myrobot\arduino\tools\avr\etc\avrdude.conf -p m168 -c stk500v1 -Pcom11 -b19200 -D -U blink_avr.hex                                                                                                                                                                                                                                                                                                                                                               
