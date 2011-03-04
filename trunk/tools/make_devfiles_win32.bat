REM *************************************************************************************
REM Script to generate the JAL device files
REM *************************************************************************************
REM
REM download the regina35w32.exe, for example from
REM for example from http://mirror.optus.net/sourceforge/r/re/regina-rexx/
REM install regina35w32.exe the package
REM Make sure the system PATH includes the regina install directory
REM run this script
REM
REM *************************************************************************************


mkdir d:\temp
mkdir d:\temp\mplab863
mkdir "d:\temp\mplab863\mpasm suite"
mkdir "d:\temp\mplab863\mpasm suite\LKR"
mkdir "d:\temp\mplab863\mplab ide"
mkdir "d:\temp\mplab863\mplab ide\device"

del "d:\temp\mplab863\mpasm suite\LKR\*.*" /S /F /Q
del "d:\temp\mplab863\mplab ide\device" /S /F /Q


copy "D:\pic\Microchip\MPASM Suite\LKR\*.*" "d:\temp\mplab863\mpasm suite\LKR\"
copy "D:\pic\Microchip\MPLAB IDE\device\*.*" "d:\temp\mplab863\mplab ide\device\"

subst k: /d
subst k: d:\temp

mkdir test
del test\*.* /S /F /Q

regina.exe Dev2Jal.cmd test

