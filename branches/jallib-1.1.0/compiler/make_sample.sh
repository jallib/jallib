#!/bin/bash

# This is a shell script to show how to compile a
# sample on linux (and other *nix)

# By default, 16f877a_blink.jal is compiled,
# but you can specify your own sample on 
# the commandline (full path)
SAMPLE=../sample/16f877a_blink.jal
if [ "$1" != "" ]
then
   SAMPLE=$1
fi

./jalv2 -long-start -s ../lib $SAMPLE

echo
echo
echo Look for the output files in the sample directory:
outdir=`dirname $SAMPLE`
f=`basename $SAMPLE`
ls $outdir/`echo $f | sed "s#\.jal\\\$##"`.*
echo
echo
