#!/bin/bash

export JALLIB_ROOT=`pwd`	# correct when set by buildbot
###export JALLIB_ROOT=`pwd`/../..	# run manually here
export JALLIB_REPOS=$JALLIB_ROOT/$JALLIB_ENV/include
export JALLIB_SAMPLEDIR=$JALLIB_ROOT/$JALLIB_ENV/sample


jalsamples=`find $JALLIB_SAMPLEDIR/by_device -name \*.jal -type f`
echo `echo $jalsamples | sed "s#\.jal #.jal\n#g" | wc -l` samples to compile...

at_least_one_failed=0
counter=0

echo "" > /tmp/compile.out
echo "" > /tmp/compile.failed

for sample in $jalsamples
do
	$JALLIB_PYTHON $JALLIB_ROOT/tools/jallib.py compile $sample > /tmp/tmpcomp.out 2>&1 
	if [ "$?" != "0" ]
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

echo JALLIB_ROOT=$JALLIB_ROOT
echo JALLIB_ENV=$JALLIB_ENV
echo JALLIB_REPOS=$JALLIB_ROOT/$JALLIB_ENV/include
echo JALLIB_SAMPLEDIR=$JALLIB_ROOT/$JALLIB_ENV/sample
echo JALLIB_JALV2=$JALLIB_JALV2
echo JALLIB_PYTHON=$JALLIB_PYTHON



rm -f /tmp/compile.out
exit $at_least_one_failed
