#!/bin/bash

export JALLIB_ROOT=`pwd`	# correct when set by buildbot
export JALLIB_REPOS=$JALLIB_ROOT/$JALLIB_ENV/include
export JALLIB_SAMPLEDIR=$JALLIB_ROOT/$JALLIB_ENV/sample

echo JALLIB_ROOT=$JALLIB_ROOT
echo JALLIB_ENV=$JALLIB_ENV
echo JALLIB_REPOS=$JALLIB_ROOT/$JALLIB_ENV/include
echo JALLIB_SAMPLEDIR=$JALLIB_ROOT/$JALLIB_ENV/sample
echo JALLIB_JALV2=$JALLIB_JALV2
echo JALLIB_PYTHON=$JALLIB_PYTHON


jalsamples=`find $JALLIB_SAMPLEDIR/by_device -name \*.jal -type f`
jallibs=`find $JALLIB_REPOS -name \*.jal -type f`

echo `echo $jalsamples | sed "s#\.jal #.jal\n#g" | wc -l` samples to validate...
echo `echo $jallibs | sed "s#\.jal #.jal\n#g" | wc -l` libraries to validate...

at_least_one_failed=0

for jalfile in `echo $jalsamples $jallibs`
do
   echo -n file: $jalfile... 
   $JALLIB_PYTHON $JALLIB_ROOT/tools/jallib.py validate $jalfile> /tmp/validate.out 2>&1 
   if [ "$?" = "0" ]
   then
	  echo OK
   else
	  echo Failed !
	  cat /tmp/validate.out
	  echo -- jsg output --
	  echo $output
	  echo -- -- --
	  at_least_one_failed=1
   fi
done

rm -f /tmp/validate.out
exit $at_least_one_failed
