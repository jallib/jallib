#!/bin/bash

start_time=`date +%s`

export JALLIB_ROOT=`pwd`	# correct when set by buildbot
###export JALLIB_ROOT=`pwd`/../..	# run manually here
export JALLIB_REPOS=$JALLIB_ROOT/include
export JALLIB_UNITTESTDIR=$JALLIB_ROOT/test/unittest

jaltfiles=`find $JALLIB_UNITTESTDIR -name \*.jalt -type f`
jalfiles=`find $JALLIB_UNITTESTDIR -name \*.jal -type f`

echo `echo $jaltfiles $jalfiles | sed "s#\.jal #.jal\n#g" | sed "s#\.jalt #.jalt\n#g" | wc -l` unittests to run...
for t in `echo $jaltfiles $jalfiles`
do
   echo `basename $t`
done
echo

at_least_one_failed=0
counter=0

echo "" > /tmp/unittest.out
echo "" > /tmp/unittest.failed

for jalfile in `echo $jaltfiles $jalfiles`
do
	###echo file: $jalfile... 
	$JALLIB_PYTHON $JALLIB_ROOT/tools/jallib.py unittest $jalfile > /tmp/tmpval.out 2>&1 
	if [ "$?" != "0" ]
	then
		echo `basename $jalfile` >> /tmp/unittest.failed
		echo -- `basename $jalfile` failed, run again with details -- >> /tmp/unittest.out
		$JALLIB_PYTHON $JALLIB_ROOT/tools/jallib.py unittest -v $jalfile > /tmp/tmpval.out 2>&1
		cat /tmp/tmpval.out >> /tmp/unittest.out
		echo -- -- -- >> /tmp/unittest.out
		echo >> /tmp/unittest.out
		at_least_one_failed=1
		counter=`expr $counter + 1`		
	fi
done

if [ "$counter" = "0" ]
then
	echo "All unittests run with success :)"
else
	echo "$counter unittests has failed..."
	echo List:
	cat /tmp/unittest.failed
	echo
	echo
	echo Details:
	cat /tmp/unittest.out
	echo
fi

echo "Environment config"
echo JALLIB_ROOT=$JALLIB_ROOT
echo JALLIB_REPOS=$JALLIB_REPOS
echo JALLIB_UNITTESTDIR=$JALLIB_UNITTESTDIR
echo JALLIB_JALV2=$JALLIB_JALV2
echo JALLIB_PYTHON=$JALLIB_PYTHON
echo
end_time=`date +%s`
seconds=`expr $end_time - $start_time`
echo "Time duration: $seconds secs"



rm -f /tmp/unittest.out
exit $at_least_one_failed
