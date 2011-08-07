@echo off
if NOT "%1"=="" goto parameter

del alloutput.txt
del all.diff

rem ---------------------------------------------------------------------------
rem start of list here
rem ---------------------------------------------------------------------------
                  
                  
call %0 test_001
call %0 test_002
call %0 test_003
call %0 test_004
call %0 test_005
call %0 test_006
call %0 test_007
call %0 test_008
call %0 test_009
call %0 test_010
call %0 test_011
call %0 test_012
call %0 test_013

rem non JAL-compliant tests:
call %0 test_100


rem ---------------------------------------------------------------------------
rem end of list
rem ---------------------------------------------------------------------------

goto end

:parameter
rem ---------------------------------------------------------------------------
rem start of test-one here
rem ---------------------------------------------------------------------------

Rem run JAT on a (one) test and compare the result with the reference

del test.c
del test.exe
del test.txt 
del test.tmp

echo --------------------------------- %1  ---------------------------------

echo include ../pc_target        >test.jal
type %1.jal                     >>test.jal
..\jalparser test.jal            
gcc test.c -otest.exe
test.exe                         >test.tmp
perl comcapture.pl -f test.tmp   >test.txt

copy test.txt                    %1.txt   >nul
diff %1.txt %1.ref              >test.diff

rem --------------------- message of SUCCES or FAILED
if errorlevel 1 goto diff_err
echo TEST %1 SUCCES
goto diff_done
          
: diff_err
echo TEST %1 FAILED          
pause

:diff_done
echo. 
rem ----------------- END message of SUCCES or FAILED

type test.diff                  >>all.diff
type test.txt                   >> alloutput.txt

rem ---------------------------------------------------------------------------
rem end of test-one here
rem ---------------------------------------------------------------------------

:end



