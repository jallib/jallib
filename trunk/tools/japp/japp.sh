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

source japp_config.py
if [ "$?" != "0" ]
then
   echo "Unable to source configuration file 'japp_config.py'"
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

if [ "$JAPP_EMAIL" = "" ]
then
   echo "Please set JAPP_EMAIL env. variable to an account monitored by the website (mailhandler)"
   exit 255
fi

if [ "$JAPP_TMP" = "" ]
then
   JAPP_TMP=/tmp/japptmp
fi

while read DITAFILE
do
   echo "Processing file '$DITAFILE'..."
   ext=`echo $DITAFILE | sed "s#.*\.\(.*\)\\$#\1#"`
   noext=`echo $DITAFILE | sed "s#\(.*\)\..*\\$#\1#"`

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
		 continue
	  fi
	  echo "    Preparing HTML for Drupal publishing..."
	  python $JAPP_ROOT/htmlizer.py $JAPP_TMP/$noext.html
	  if [ "$?" != "0" ]
	  then
		 echo
		 echo
		 echo "    Failed..."
		 continue
	  fi
	  echo "    Sending content..."
	  pushd $JAPP_ROOT
	  python publish.py $JAPP_TMP/topublish
	  if [ "$?" != "0" ]
	  then
		 echo
		 echo
		 echo "    Failed..."
	  fi
	  popd
   fi
done
