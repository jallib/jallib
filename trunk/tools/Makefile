# Title: Makefile to handle common task
# Author: Sebastien Lelong, Copyright (c) 2008, all rights reserved.
# Adapted by:
# 
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
#


all : clean test

ENV=unvalidated
SAMPLIR_DIR=../${ENV}/sample
INCLUDE_DIR=../${ENV}/include

clean :
	# clean what jal produces
	find ${SAMPLIR_DIR} -name \*.cod -exec rm {} \;
	find ${SAMPLIR_DIR} -name \*.lst -exec rm {} \;
	find ${SAMPLIR_DIR} -name \*.hex -exec rm {} \;
	find ${SAMPLIR_DIR} -name \*.err -exec rm {} \;
	find ${SAMPLIR_DIR} -name \*.obj -exec rm {} \;
	find ${SAMPLIR_DIR} -name \*.asm -exec rm {} \;
	# clean python bytecode
	find ./ -name \*.pyc -exec rm {} \;
		
test :
	# run testsuite

compile:
	for f in `find ${SAMPLIR_DIR} -name \*.jal`; \
	do \
		jalv2 -s "`find ${INCLUDE_DIR} -type d | grep -v \.svn | tr '\n' ';'`" $$f | grep '0 errors, 0 warnings' && true || ( echo problem with $$f && exit 255; ) \
	done 

jsg:
	for f in `find ${SAMPLIR_DIR} -name \*.jal`; \
	do \
		./jsg_validator.py $$f ;\
	done 
	for f in `find ${INCLUDE_DIR} -name \*.jal`; \
	do \
		./jsg_validator.py $$f ;\
	done 

doc:
	./jalapi_generate.sh ../${ENV}
