@echo off
set comport=com2


if NOT "%1"=="" goto parameter
rem ---------------------------------------------------------------------------
rem start of list here
rem ---------------------------------------------------------------------------

if exist all.ref        del all.ref


call %0 test_001
call %0 test_002
call %0 test_003
call %0 test_004
rem exclude due to jal bug - ref is okay now - call %0 test_005
call %0 test_006
call %0 test_007
call %0 test_008


rem ---------------------------------------------------------------------------
rem end of list
rem ---------------------------------------------------------------------------

goto end

:parameter
rem ---------------------------------------------------------------------------
rem start of reftest-one here
rem ---------------------------------------------------------------------------

echo --------------------------------------------------------------------------
echo RUN %1
echo --------------------------------------------------------------------------

if exist test.hex       del test.hex
if exist capture.txt    del capture.txt

echo include ../pic_target       >test.jal
type %1.jal                     >>test.jal
jalwrapper  test.jal   
call wispwrapper %comport% test.hex

perl comcapture.pl -p %comport%     >capture.txt

copy capture.txt                 %1.ref       

echo testrun: %1                >>all.ref
type capture.txt                >>all.ref

rem ---------------------------------------------------------------------------
rem end of reftest-one here
rem ---------------------------------------------------------------------------

:end