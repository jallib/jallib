echo off
REM Example Windows batch file to run the compilesamples.py script for a specific MPLABX version.
set "PIC2JAL=D:\picdevices"
set "JALLIB=D:\GitHub\Jallib"
set "JALCOMPILER=%cd%\jalv2_64.exe"
set "MPLABXVERSION=6.25"
python compilesamples.py

