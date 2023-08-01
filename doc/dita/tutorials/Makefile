# Title: Makefile to create the Jallib Tutorial in pdf and html documentation using dita
# Author: Rob Jansen, Copyright (c) 2023..2023, all rights reserved.
# Adapted by:
# 
# This file is part of jallib (https://github.com/jallib/jallib)
# Released under the ZLIB license (http://www.opensource.org/licenses/zlib-license.html)
#

SOURCE_DIR=`pwd`

clean: 
	rm -rf $$HOME/tmp/pdf
	rm -rf $$HOME/tmp/html

doc:
	# Jallib Tutorial in pdf format
	$$DITA_HOME/bin/dita -project=${SOURCE_DIR}/pdf.xml -o $$HOME/tmp/pdf
	# Jallib Tutorial in html format
	$$DITA_HOME/bin/dita -project=${SOURCE_DIR}/html.xml -o $$HOME/tmp/html

all: clean doc

