@echo off

set comport=com3
rem set comport=com11
set arduinopath=C:\arduino\arduino-0018\hardware\tools\avr

Rem remove old files
if exist  blink_avr.c      del blink_avr.c
if exist  blink_avr.elf    del blink_avr.elf
if exist  blink_avr.hex    del blink_avr.hex
rem if exist  blink_avr.lss    del blink_avr.lss
rem if exist  blink_avr.sym    del blink_avr.sym

Rem Translate JAL to C
..\..\bin\jalparser sample\blink_avr.jal -o blink_avr.c

Rem Compile C-file to elf-file
%arduinopath%\bin\avr-gcc -g -Wall -Os -mmcu=atmega168p  -I../ -o blink_avr.elf blink_avr.c

Rem convert elf to hex file
%arduinopath%\bin\avr-objcopy -j .text -j .data -O ihex blink_avr.elf blink_avr.hex

rem generate listing and symbol table
rem %arduinopath%\bin\avr-objdump -h -S blink_avr.elf > blink_avr.lss
rem %arduinopath%\bin\avr-nm -n blink_avr.elf > blink_avr.sym

echo Reset your target to activate bootloader
pause

rem program hex in target device. 
%arduinopath%\bin\avrdude -C %arduinopath%\\etc\avrdude.conf -p m168 -c stk500v1 -P %comport% -b 19200 -F -U flash:w:blink_avr.hex
