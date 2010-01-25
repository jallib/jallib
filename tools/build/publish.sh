#!/bin/bash

# this script automatically publish DITA files to the website. It uses 
# TOPUBLISH file registering what should go to the website. This scripts
# works incrementally: it doesn't publish *every* DITA files each time 
# TOPUBLISH has been modified, instead it uses SVN diff action to know
# which lines have changed. To do this, a revision number is stored in
# a file, this is last revision on which this script successfully run.

start_time=`date +%s`

export JALLIB_ROOT=`pwd`/../build	# correct when set by buildbot
##export JALLIB_ROOT=`pwd`/../..	# run manually here
export JALLIB_DITA=$JALLIB_ROOT
export JALLIB_TOOLS=`pwd`/../tools
export JALLIB_TOPUBLISH=$JALLIB_DITA/TOPUBLISH

JALLIB_TMP=$JALLIB_ROOT/tmp
mkdir -p $JALLIB_TMP

# sanity check
if ! test -s $JALLIB_LASTREVFILE
then
   echo "Last revision file $JALLIB_LASTREVFILE does not exist or is empty."
   echo "Please specify a revision from which DITA files should be considered"
   echo "in incremental publication"
   exit 255
fi

# extracting changed lines 
svncmd="svn info $JALLIB_TOPUBLISH"
LANG=C $svncmd
reposrev=`LANG=C $svncmd | grep ^Revision: | sed "s#Revision:##" | sed "s# ##g"`
lastrev=`cat $JALLIB_LASTREVFILE`
at_least_one_failed=0
counter=0
# replace spaces on the fly to read whole line by whole line...
echo svn diff -r$lastrev:$reposrev $JALLIB_TOPUBLISH
for file in `cat <(svn diff -r$lastrev:$reposrev $JALLIB_TOPUBLISH  | grep "^+" | grep -v -e "^+#" -e "^+[[:space:]]*$" -e "^+++" | sed "s# \|\t#___#g")`
do
   pushd $JALLIB_TOOLS/japp

   cmdline=`echo $file | sed "s#^+##" | sed "s#___# #g" `
   dita=`echo $cmdline | awk '{print $1}'`
   conf=`echo $cmdline | awk '{print $2}'`
   basedita=`basename $dita`
   # let's publish...
   echo
   echo Publishing $basedita using $conf configuration
   echo 
   echo $dita | ./japp.sh $conf
   # pipe: exit code is from the right side, this is what we want
   if [ "$?" != "0" ]
   then
	  echo "Failed to publish $basedita" >> $JALLIB_TMP/publish.failed
	  at_least_one_failed=1
	  counter=`expr $counter + 1`
   fi

   popd
done

if [ "$counter" = "0" ]
then
   echo "All new DITA documents published :)"
else
   echo "$counter DITA documents can't be published"
   echo "List:"
   cat $JALLIB_TMP/publish.failed
fi

rm -fr $JALLIB_TMP
echo $reposrev > $JALLIB_LASTREVFILE

end_time=`date +%s`
seconds=`expr $end_time - $start_time`
echo "Time duration: $seconds secs"

exit $at_least_one_failed
