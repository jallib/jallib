jalparser         test.jal >test.txt
perl cfilter.pl   test.txt >test.c
gcc               test.c   -otest.exe