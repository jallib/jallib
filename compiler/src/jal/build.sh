#!/bin/sh

DST=jal_build.h
rm -f $DST
echo "#define JAL_BUILD `date +%Y%m%d`" > $DST
#
# determine the version, which is the name of the directory two
# down from here.
# This will eliminate /jal
JAL_VERSION_STR=`dirname $PWD`
#
# This will eliminated /src
#
JAL_VERSION_STR=`dirname $JAL_VERSION_STR`
#
# This will strip off the directory
#
JAL_VERSION_STR=`basename $JAL_VERSION_STR`
echo "#define JAL_VERSION_STR \"$JAL_VERSION_STR\"" >> $DST
