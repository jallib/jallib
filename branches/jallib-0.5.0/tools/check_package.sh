#!/bin/bash


LIBDIR=$1
SAMPLEDIR=$2
COMPILERBIN=$3


status=0
for f in `find $SAMPLEDIR -name \*.jal`
do
	$COMPILERBIN -s $LIBDIR $f > /dev/null 2>&1 
	if [ "$?" != "0" ]
	then
		echo "$f failed !"
		status=1
	fi
done

exit $status
