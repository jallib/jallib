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

echo include ../pc_target        >test.jal
type %1.jal                     >>test.jal
..\jalparser test.jal            >test.c
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

:diff_done
rem ----------------- END message of SUCCES or FAILED

type test.diff                  >>all.diff
type test.txt                   >> alloutput.txt

rem ---------------------------------------------------------------------------
rem end of test-one here
rem ---------------------------------------------------------------------------

:end



