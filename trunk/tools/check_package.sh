#!/bin/bash


LIBDIR=$1
SAMPLEDIR=$2
COMPILERBIN=$3

TMPFILE=$HOME/tmp/compile.log
FAILED=$HOME/tmp/failed.log

rm -f $FAILED

status=0
mainstatus=0
for f in `find $SAMPLEDIR -name \*.jal`
do
	$COMPILERBIN -s $LIBDIR $f > $TMPFILE 2>&1 
	status=$?


	if [ "$status" != "0" ]
	then
		echo "$f failed !"
        echo "$f failed !" >> $FAILED
        cat $TMPFILE >> $FAILED
        echo >> $FAILED
		mainstatus=1
	fi
done

echo
echo
cat $FAILED
rm -f $FAILED

exit $mainstatus
