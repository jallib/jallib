#!/bin/bash

# read on stdin strings formatting like
#
# <filename>.<extension>
#
# and process it.
#  - if extension is "ditamap", produces a PDF file (this is a book)
#  - if extension is not "ditamap", produces a HTML file
#
#  Processing goes like this:
#  1. convert DITA file (dita2html.sh or ditamap2pdf.sh)
#  2. prepare HTML for publishing (htmlize.py)
#  3. format and send an email with content & attachements


CONFFILE=$1
source $CONFFILE

if [ "$?" != "0" ]
then
   echo "Unable to source configuration file '$CONFFILE'"
   exit 255
fi


if [ "$DITA_ROOTPATH" = "" ]
then
   echo "Please set DITA_ROOTPATH env. variable to the directory containing DITA files"
   echo "(used by concatenating DITA_ROOTPATH and relative path given via stdin)"
   exit 255
fi

if [ "$JAPP_ROOT" = "" ]
then
   echo "Please set JAPP_ROOT env. variable to the directory containing JAPP scripts"
   exit 255
fi

if [ "$JAPP_TMP" = "" ]
then
   JAPP_TMP=/tmp/japptmp
fi

at_least_one_failed=0
while read DITAFILE
do
   [[ $DITAFILE == \#* ]] && continue
   echo "Processing file '$DITAFILE'..."
   ext=`echo $DITAFILE | sed "s#.*\.\(.*\)\\$#\1#"`
   basen=`basename $DITAFILE`
   noext=`echo $basen | sed "s#\(.*\)\..*\\$#\1#"`

   if [ "$ext" = "ditamap" ]
   then

      echo "    Extension ditamap gives PDF, not implemented yet..."
	  continue

   else

	  echo "    Extension $ext gives HTML, converting..."
	  echo
	  echo
	  sh $JAPP_ROOT/dita2html.sh $DITA_ROOTPATH/$DITAFILE $JAPP_TMP
	  if [ "$?" != "0" ]
	  then
		 echo
		 echo
		 echo "    Failed..."
		 at_least_one_failed=1
		 continue
	  fi
	  echo "    Preparing HTML for Drupal publishing..."
	  python2.6 $JAPP_ROOT/htmlizer.py $CONFFILE $JAPP_TMP/$noext.html
	  if [ "$?" != "0" ]
	  then
		 echo
		 echo
		 echo "    Failed..."
		 at_least_one_failed=1
		 continue
	  fi
	  echo "    Sending content..."
	  pushd $JAPP_ROOT
	  python2.6 publish.py $CONFFILE $JAPP_TMP/topublish
	  if [ "$?" != "0" ]
	  then
		 echo
		 echo
		 echo "    Failed..."
		 at_least_one_failed=1
	  fi
	  popd
   fi
done

exit $at_least_one_failed
