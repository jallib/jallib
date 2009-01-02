#!/bin/bash

ROOT=$1
TESTSDIR=$ROOT/doc/html/tests
DOCDIR="$ROOT/doc"

python jallib.py -f testing_matrix.yaml -G testing_matrix.tmpl  -g test_result.tmpl -o $TESTSDIR/index.html

for htmlfile in `ls $TESTSDIR/*.html`
do
   notinsvn=`svn st $htmlfile| grep -c ^?`
   if [ "X$notinsvn" = "X1" ]
   then
	  svn add $htmlfile
   fi
   svn ps svn:mime-type text/html $htmlfile #> /dev/null 2>&1
done


