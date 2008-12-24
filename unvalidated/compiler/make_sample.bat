@echo off
rem This is a batch file to show how to compile a
rem sample on windows.

set sample=..\sample\by_device\16f877a\blink_16f877a.jal

jalv2.exe -long-start -s ..\lib %sample%

echo.
echo.
echo Look for the output files in the sample directory.