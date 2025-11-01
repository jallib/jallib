echo off
REM Example Windows batch file to run the blink-a-led.py script for a specific MPLABX version.
set "PIC2JAL=D:\picdevices"
set "JALCOMPILER=%cd%\jalv2_64.exe"
set "MPLABXVERSION=6.25"
python blink-a-led.py

