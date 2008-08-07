# Makefile to handle common task
# Copyright (c) 2008, Sebastien Lelong. All rights reserved.
# Adapted by:
# 
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources of information:
#


all : clean test

clean :
	# clean what jal produces
	find ./samples -name \*.cod -exec rm {} \;
	find ./samples -name \*.lst -exec rm {} \;
	find ./samples -name \*.hex -exec rm {} \;
	find ./samples -name \*.err -exec rm {} \;
	find ./samples -name \*.obj -exec rm {} \;
	find ./samples -name \*.asm -exec rm {} \;
		
test :
	# run testsuite

compile:
	for f in `find ./samples -name \*.jal`; \
	do \
		jalv2 -s "`find ./includes -type d | grep -v \.svn | tr '\n' ';'`" $$f | grep '0 errors, 0 warnings' && true || ( echo problem with $$f && exit 255; ) \
	done 

