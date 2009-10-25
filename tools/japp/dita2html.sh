#!/bin/bash

DITAFILE=$1
OUTPUTDIR=$2
TMPDIR=${OUTPUTDIR}.tmp

if [ "$DITA_HOME" = "" ]
then
    echo "DITA_HOME must be set to DITA installation directory"
    exit 255
fi

if [ "$DITAFILE" = "" ] || [ "$OUTPUTDIR" = "" ]
then
    echo "Please provide a DITA file and an output directory"
    exit 255
fi

# clean outputdir
if ! test -d $OUTPUTDIR 
then
    mkdir -p $OUTPUTDIR
else
    rm -fr $OUTPUTDIR/*
fi
if ! test -d $TMPDIR
then
    mkdir $TMPDIR
else
    rm -fr $TMPDIR/*
fi

# -Duser.csspath.url=  ---> don't copy css files
cmd="ant -Dargs.transtype=xhtml -Duser.csspath.url= -Doutput.dir=$OUTPUTDIR -Dargs.input=$DITAFILE -Dargs.logdir=$TMPDIR -Ddita.temp.dir=$TMPDIR -Dargs.target=init -f $DITA_HOME/build.xml dita2xhtml"
echo $cmd
$cmd
