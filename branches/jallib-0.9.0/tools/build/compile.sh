#!/bin/bash

start_time=`date +%s`

export JALLIB_ROOT=`pwd`	# correct when set by buildbot
#export JALLIB_ROOT=`pwd`/../..	# run manually here
export JALLIB_REPOS=$JALLIB_ROOT/include
export JALLIB_SAMPLEDIR=$JALLIB_ROOT/sample

$JALLIB_PYTHON $JALLIB_ROOT/tools/jallib.py compile -h

jalsamples=`find $JALLIB_SAMPLEDIR -name \*.jal -type f`
echo `echo $jalsamples | sed "s#\.jal #.jal\n#g" | wc -l` samples to compile...

at_least_one_failed=0
counter=0

echo "" > /tmp/compile.out
echo "" > /tmp/compile.failed

for sample in $jalsamples
do
    echo `basename $sample` > /tmp/tmpcomp.out
    $JALLIB_PYTHON $JALLIB_ROOT/tools/jallib.py compile -no-variable-reuse $sample >> /tmp/tmpcomp.out 2>&1 
    status=$?

    if [ "$status" != "0" ] && grep -q "Out of data space" /tmp/tmpcomp.out
    then
        echo "Retry without -no-variable-reuse..." >> /tmp/compile.out 2>&1
		$JALLIB_PYTHON $JALLIB_ROOT/tools/jallib.py compile $sample >> /tmp/tmpcomp.out 2>&1
		status=$?
	fi

	if [ "$status" != "0" ]
	then
		echo sample: $sample ... Failed >> /tmp/compile.out
		echo -- jalv2 output -- >> /tmp/compile.out
		cat /tmp/tmpcomp.out >> /tmp/compile.out
		echo -- -- -- >> /tmp/compile.out
		echo `basename $sample` >> /tmp/compile.failed
		at_least_one_failed=1
		counter=`expr $counter + 1`
	fi
done

if [ "$counter" = "0" ]
then
	echo "All samples compile :)"
else
	echo "$counter samples can't be compiled..."
	echo List:
	cat /tmp/compile.failed
	echo
	echo
	echo Details:
	cat /tmp/compile.out
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

rm -f /tmp/compile.out
exit $at_least_one_failed
