@echo off
cls
rem The build process should be integrated and configurable.
rem for now, it copies the input file to 'jat_lpc.c' and
rem compiles, links and uploads it to the target.
rem
rem *** any modifications of jat_lpc.c are destroyed by this script ! ***
rem

set comport=com4
set source=blink_lpc

Rem remove old files      
if exist jat_lpc.c del jat_lpc.c   
del .dep\*.d
del cbuild\*.o
make clean

Rem Translate JAL to C
..\..\bin\jalparser sample\%source%.jal -s include -o jat_lpc.c

Rem Compile, link & create hex
make all

Rem program hex in target device.
cbuild\lpc21isp -control  jat_lpc.hex %comport% 115200 14746
