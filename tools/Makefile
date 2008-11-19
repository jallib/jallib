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
VERSION=dev
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
	# clean distrib dir
	-rm -fr distrib
		
test :
	# run testsuite

compile:
	for f in `find ${SAMPLIR_DIR}/by_device -name \*.jal`; \
	do \
		jalv2 -s "`find ${INCLUDE_DIR} -type d | grep -v \.svn | tr '\n' ';'`" $$f | grep '0 errors' && true || ( echo problem with $$f && exit 255; ) \
	done 

jsg:
	for f in `find ${SAMPLIR_DIR} -name \*.jal`; \
	do \
		./jallib.py validate $$f ;\
	done 
	for f in `find ${INCLUDE_DIR} -name \*.jal`; \
	do \
		./jallib.py validate $$f ;\
	done 

doc:
	./jalapi_generate.sh ../${ENV}

matrix:
	./jallib_matrix_generate.sh ../${ENV}

export:
	# prepare distrib dir
	mkdir distrib
	mkdir distrib/jallib-${VERSION}
	mkdir distrib/jallib-${VERSION}/lib
	mkdir distrib/jallib-${VERSION}/doc
	mkdir distrib/jallib-all_devices-${VERSION}
	mkdir distrib/jallib-all_devices-${VERSION}/lib
	mkdir distrib/jallib-all_devices-${VERSION}/blink
	mkdir -p distrib/jallib-all_devices-${VERSION}/doc/html
	# get clean source from repos
	# (svn export gets the sources, but without any .svn dir (no svn metadata)
	svn export http://jallib.googlecode.com/svn/trunk/${ENV} distrib/jallib-export
	# always svn export unvalidated map, to get last devices/blink files
	svn export http://jallib.googlecode.com/svn/trunk/unvalidated distrib/jallib-unvalidated
	# license is common for both svn and release
	svn export -N http://jallib.googlecode.com/svn/trunk distrib/jallib-extra
	# get readme for the release (force because target dir already exists)
	svn export --force http://jallib.googlecode.com/svn/trunk/tools distrib/jallib-extra
	# flatten library files
	find distrib/jallib-export/include -type f -exec cp {} distrib/jallib-${VERSION}/lib \;
	find distrib/jallib-unvalidated/include/device -type f -exec cp {} distrib/jallib-all_devices-${VERSION}/lib \;
	for f in `find distrib/jallib-unvalidated/sample/by_device/ -type f | grep -e 'blink_[[:digit:]]\{2\}[[:alpha:]]\+.*\.jal'`; \
	do \
		cp $$f distrib/jallib-all_devices-${VERSION}/blink;\
	done
	# doc
	cp -r distrib/jallib-export/doc/* distrib/jallib-${VERSION}/doc
	# license, readme, install, ...
	# 	jallib
	cp distrib/jallib-extra/LICENSE distrib/jallib-${VERSION}/
	cp distrib/jallib-extra/README.release distrib/jallib-${VERSION}/README
	# 	jallib-all_devices
	cp distrib/jallib-extra/LICENSE distrib/jallib-all_devices-${VERSION}/
	cp distrib/jallib-extra/README.device distrib/jallib-all_devices-${VERSION}/README
	cp distrib/jallib-extra/README.blink distrib/jallib-all_devices-${VERSION}/README.blink
	cp -r distrib/jallib-export/doc/html/devicefiles.html distrib/jallib-all_devices-${VERSION}/doc/html
	cp -r distrib/jallib-export/doc/html/jallib.css distrib/jallib-all_devices-${VERSION}/doc/html
	# TODO: readme for jallib-device
	# keep sample map as is
	cp -r distrib/jallib-export/sample distrib/jallib-${VERSION}/
	echo DONE: release directory distrib/jallib-${VERSION}/

release: export
	cd distrib && tar czfv jallib-${VERSION}.tar.gz jallib-${VERSION}
	cd distrib && tar czfv jallib-all_devices-${VERSION}.tar.gz jallib-all_devices-${VERSION}
	cd distrib && zip -r jallib-${VERSION}.zip jallib-${VERSION}
	cd distrib && zip -r jallib-all_devices-${VERSION}.zip jallib-all_devices-${VERSION}

