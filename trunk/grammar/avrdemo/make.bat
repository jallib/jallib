@echo off

set arduinopath=C:\arduino\arduino-0018\hardware\tools\avr

Rem remove old files
if exist  blink_avr.c      del blink_avr.c
if exist  blink_avr.elf    del blink_avr.elf
if exist  blink_avr.hex    del blink_avr.hex

Rem Translate JAL to C
..\jalparser blink_avr.jal

Rem Compile C-file to elf-file
%arduinopath%\bin\avr-gcc -g -Wall -Os -mmcu=atmega168p  -IAVRlib -I. -I./libs -o blink_avr.elf blink_avr.c

Rem convert elf to hex file
%arduinopath%\bin\avr-objcopy -j .text -j .data -O ihex blink_avr.elf blink_avr.hex

echo Reset your target to activate bootloader
pause

rem program hex in target device. 
%arduinopath%\bin\avrdude -F -V -C%arduinopath%\\etc\avrdude.conf -p m168 -c stk500v1 -Pcom11 -b19200 -D -U blink_avr.hex
