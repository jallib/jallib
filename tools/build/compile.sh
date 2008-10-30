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
echo `echo $jalsamples | sed "s#\.jal #.jal\n#g" | wc -l` samples to compile...

at_least_one_failed=0

for sample in $jalsamples
do
   echo -n sample: $sample ... 
   $JALLIB_PYTHON $JALLIB_ROOT/tools/jallib.py compile $sample > /tmp/compiler.out 2>&1 
   if [ "$?" = "0" ]
   then
	  echo OK
   else
	  echo Failed !
	  cat /tmp/compiler.out
	  echo -- jalv2 output --
	  echo $output
	  echo -- -- --
	  at_least_one_failed=1
   fi
done

rm -f /tmp/compiler.out
exit $at_least_one_failed
