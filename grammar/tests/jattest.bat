rem @echo off
if NOT "%1"=="" goto parameter

rem ---------------------------------------------------------------------------
rem start of list here
rem ---------------------------------------------------------------------------

del alloutput.txt
del all.diff

call %0 test_001
rem call %0 test02
rem call %0 test03


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

echo include ../pc_target        >test.jal
type %1.jal                     >>test.jal
..\jalparser test.jal            >test.c
gcc test.c -otest.exe
test.exe                         >test.txt
diff test.txt %1.txt             >test.diff

test test.diff                  >>all.diff
type testoutput.txt             >> alloutput.txt

rem ---------------------------------------------------------------------------
rem end of test-one here
rem ---------------------------------------------------------------------------

:end



