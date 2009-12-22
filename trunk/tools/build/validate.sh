#!/bin/bash

start_time=`date +%s`

export JALLIB_ROOT=`pwd`	# correct when set by buildbot
###export JALLIB_ROOT=`pwd`/../..	# run manually here
export JALLIB_REPOS=$JALLIB_ROOT/include
export JALLIB_SAMPLEDIR=$JALLIB_ROOT/sample

jalsamples=`find $JALLIB_SAMPLEDIR -name \*.jal -type f`
jallibs=`find $JALLIB_REPOS -name \*.jal -type f`

echo `echo $jalsamples | sed "s#\.jal #.jal\n#g" | wc -l` samples to validate...
echo `echo $jallibs | sed "s#\.jal #.jal\n#g" | wc -l` libraries to validate...

at_least_one_failed=0
counter=0

echo "" > /tmp/validate.out
echo "" > /tmp/validate.failed

for jalfile in `echo $jalsamples $jallibs`
do
	##echo -n file: $jalfile... 
	$JALLIB_PYTHON $JALLIB_ROOT/tools/jallib.py validate $jalfile > /tmp/tmpval.out 2>&1 
	if [ "$?" != "0" ]
	then
		echo -- jsg output -- >> /tmp/validate.out
		cat /tmp/tmpval.out >> /tmp/validate.out
		echo -- -- -- >> /tmp/validate.out
		echo >> /tmp/validate.out
		echo `basename $jalfile` >> /tmp/validate.failed
		at_least_one_failed=1
		counter=`expr $counter + 1`		
	fi
done

if [ "$counter" = "0" ]
then
	echo "All files validated :)"
else
	echo "$counter files can't be validated..."
	echo List:
	cat /tmp/validate.failed
	echo
	echo
	echo Details:
	cat /tmp/validate.out
	echo
fi

echo "Environment config"
echo JALLIB_ROOT=$JALLIB_ROOT
echo JALLIB_REPOS=$JALLIB_REPOS
echo JALLIB_SAMPLEDIR=$JALLIB_SAMPLEDIR
echo JALLIB_JALV2=$JALLIB_JALV2
echo JALLIB_PYTHON=$JALLIB_PYTHON
echo
end_time=`date +%s`
seconds=`expr $end_time - $start_time`
echo "Time duration: $seconds secs"



rm -f /tmp/validate.out
exit $at_least_one_failed
