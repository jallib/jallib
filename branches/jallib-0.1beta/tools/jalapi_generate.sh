#!/bin/bash

ROOT=$1
DOCDIR="$ROOT/doc"
HTMLDOCDIR="$DOCDIR/html"

MENU=$HTMLDOCDIR/menu.html

export SAMPLEDIR=$ROOT/sample

echo "<!-- sorted -->" > $MENU

for jalfile in `find $ROOT/include -name \*.jal | grep -v $ROOT/include/device`
do
	basefile=`basename $jalfile`
	htmlfile="`echo $basefile | sed 's#\.jal$#.html#'`"
	libname=`echo $basefile | sed 's#\.jal$##'`
	echo -n "Generating doc for $basefile... "
	python jalapi.py jalapi_html.tmpl $jalfile > $HTMLDOCDIR/$htmlfile
	status=$?
	if [ "X$status" = "X0" ]
	then
		echo done
		notinsvn=`svn st $HTMLDOCDIR/$htmlfile| grep -c ^?`
		if [ "X$notinsvn" = "X1" ]
		then
			svn add $HTMLDOCDIR/$htmlfile
		fi
		svn ps svn:mime-type text/html $HTMLDOCDIR/$htmlfile > /dev/null 2>&1
		echo "<a href='$htmlfile' target='lib_desc'>$libname</a><br/>" >> $MENU
	else
		rm $HTMLDOCDIR/$htmlfile
		echo ERROR 
	fi
done

# sort lib: this should be ok
sort $MENU > $MENU.tmp
echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
    <head>
		<title>Libraries - jallib API doc</title>
	</head>
	
	<body>
" > $MENU
# manually include device files doc, as it's not generated from a lib
echo "<a href='devicefiles.html' target='lib_desc'>device files</a><br/>" >> $MENU
cat $MENU.tmp >> $MENU
rm $MENU.tmp
echo "</body>
</html>" >> $MENU
