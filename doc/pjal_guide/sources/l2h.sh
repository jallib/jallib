#!/usr/bin
# ****************************************
# ****************************************
# *** Usage: l2h.sh file.tex
# ****************************************
# ****************************************

base=$1
basedir=./${base%.tex}_dir
mkdir $basedir
latex $base
pdflatex --interaction batchmode $base
latex2rtf $base
latex2html -local_icons -white -antialias -prefix ${base%.tex}_ -address '<HR>pJAL Manual.<BR>(c) 2006 Javier Martinez, Vasile Surducan and Dave Lagzdin.' -no_footnode -nonumbered_footnotes  -bottom_navigation -top_navigation -html_version 3.2 -dir $basedir -split +2 -show_section_numbers $1
echo "****************************************"
echo "****************************************"
echo "*** html files in "$basedir
echo "*** pdf file in current dir"
echo "*** rtf file in current dir"
echo "****************************************"
echo "****************************************"
