# Title: Makefile to handle common task
# Author: Sebastien Lelong, Copyright (c) 2008, all rights reserved.
# Adapted by:
# 
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
#


all : clean test

VERSION=dev
SAMPLIR_DIR=../sample
TEST_DIR=../test
INCLUDE_DIR=../include

clean :
	# clean what jal produces
	find ${SAMPLIR_DIR} -name \*.cod -exec rm {} \;
	find ${SAMPLIR_DIR} -name \*.lst -exec rm {} \;
	find ${SAMPLIR_DIR} -name \*.hex -exec rm {} \;
	find ${SAMPLIR_DIR} -name \*.err -exec rm {} \;
	find ${SAMPLIR_DIR} -name \*.obj -exec rm {} \;
	find ${SAMPLIR_DIR} -name \*.asm -exec rm {} \;
	find ${TEST_DIR} -name \*.cod -exec rm {} \;
	find ${TEST_DIR} -name \*.lst -exec rm {} \;
	find ${TEST_DIR} -name \*.hex -exec rm {} \;
	find ${TEST_DIR} -name \*.err -exec rm {} \;
	find ${TEST_DIR} -name \*.obj -exec rm {} \;
	find ${TEST_DIR} -name \*.asm -exec rm {} \;
	# clean python bytecode
	find ./ -name \*.pyc -exec rm {} \;
	# clean distrib dir
	-rm -fr distrib
		
test :
	# run testsuite

compile:
	for f in `find ${SAMPLIR_DIR} -name \*.jal`; \
	do \
		../compiler/jalv2 -s "`find ${INCLUDE_DIR} -type d | grep -v \.svn | tr '\n' ';'`" $$f | grep '0 errors' && true || ( echo problem with $$f && exit 255; ) \
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
	./jalapi_generate.sh ..

matrix:
	./jallib_matrix_generate.sh ../

export:
	# prepare distrib dir
	mkdir distrib
	mkdir distrib/jallib-${VERSION}
	mkdir distrib/jallib-${VERSION}/lib
	mkdir -p distrib/jallib-${VERSION}/doc/html
	mkdir distrib/jallib-all_devices-${VERSION}
	mkdir distrib/jallib-all_devices-${VERSION}/lib
	mkdir distrib/jallib-all_devices-${VERSION}/blink
	mkdir -p distrib/jallib-all_devices-${VERSION}/doc/html
	# special dir with all libs, except device files, for "one page" doc
	mkdir distrib/jallib-libnodevice
	# generate VERSION file for each
	echo ${VERSION} > distrib/jallib-${VERSION}/VERSION
	echo ${VERSION} > distrib/jallib-all_devices-${VERSION}/VERSION
	# get clean source from repos
	# (svn export gets the sources, but without any .svn dir (no svn metadata)
	svn export http://jallib.googlecode.com/svn/trunk distrib/jallib-export
	# license is common for both svn and release
	svn export -N http://jallib.googlecode.com/svn/trunk distrib/jallib-extra
	# get readme for the release (force because target dir already exists)
	svn export --force http://jallib.googlecode.com/svn/trunk/tools distrib/jallib-extra

dispatch:
	# flatten library files
	cd  distrib/jallib-${VERSION} && for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^include\/ | sed 's#\r##g'`; do cp ../jallib-export/$$f lib; done
	# same but no device
	cd  distrib/jallib-libnodevice && for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep -v ^include\/device | grep ^include\/ | sed 's#\r##g'`; do cp ../jallib-export/$$f .; done
	# keep sample structure, but only for those in TORELEASE
	-cd  distrib/jallib-${VERSION} && mkdir sample
	-cd  distrib/jallib-${VERSION} && for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^sample\/ | sed 's#\r##g'`; do cp ../jallib-export/$$f sample/; done
	# same for "project"
	-cd  distrib/jallib-${VERSION} && mkdir project
	-cd  distrib/jallib-${VERSION} && for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^project\/ | sed 's#\r##g'`; do mkdir -p `dirname $$f`; cp ../jallib-export/$$f `dirname $$f`/; done
	# for all_devices package, keep everything...
	find distrib/jallib-export/include/device -type f -exec cp {} distrib/jallib-all_devices-${VERSION}/lib \;
	for f in `find distrib/jallib-export/sample -type f | grep -e '[[:digit:]]\{2\}[[:alpha:]]\+.*_blink\.jal'`; \
	do \
		cp $$f distrib/jallib-all_devices-${VERSION}/blink;\
	done
	# doc
	for f in `cat distrib/jallib-export/TORELEASE | grep ^include | grep -v include.device | sed 's#\r##g'` ; \
	do \
		libfile=`basename $$f`; \
		htmlfile=`echo $$libfile | sed "s#\.jal#.html#"`; \
		python jallib.py jalapi -l -d distrib/jallib-${VERSION}/sample -t jalapi_html.tmpl -o distrib/jallib-${VERSION}/doc/html/$$htmlfile distrib/jallib-${VERSION}/lib/$$libfile ;\
	done
	# one-page doc
	python jallib.py jalapi -s -l -d distrib/jallib-${VERSION}/sample -t jalapi_html.tmpl -o distrib/jallib-${VERSION}/doc/html/jallib_onepage.html distrib/jallib-libnodevice/
	# doc menu...
	echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd"><html><head><title>Libraries - jallib API doc</title></head><body>' > distrib/jallib-${VERSION}/doc/html/menu.html
	# manually include device files doc, as it's not generated from a lib
	echo "<a href='http://jallib.googlecode.com' target='_parent'><i>back to jallib</i></a><br/><br/>" >> distrib/jallib-${VERSION}/doc/html/menu.html
	echo "<a href='devicefiles.html' target='lib_desc'>device files</a><br/>" >> distrib/jallib-${VERSION}/doc/html/menu.html
	# generate html from lib included in the release, and specifcy to create local links to samples (-l option)
	for htmlfile in `ls distrib/jallib-${VERSION}/doc/html/*.html | egrep -v menu\.html\|welcome\.html\|index\.html\|devicefiles\.html | sort  `; \
	do \
		htmlfile=`basename $$htmlfile`; \
		libname=`echo $$htmlfile | sed "s#\.html##"`; \
		echo "<a href='$$htmlfile' target='lib_desc'>$$libname</a><br/>" >> distrib/jallib-${VERSION}/doc/html/menu.html; \
	done
	echo "</body></html>" >> distrib/jallib-${VERSION}/doc/html/menu.html
	cp distrib/jallib-export/doc/html/welcome.html distrib/jallib-${VERSION}/doc/html/
	cp distrib/jallib-export/doc/html/index.html distrib/jallib-${VERSION}/doc/html/
	# doc for all_devices
	cp -r distrib/jallib-export/doc/html/devicefiles.html distrib/jallib-${VERSION}/doc/html
	cp -r distrib/jallib-export/doc/html/jallib.css distrib/jallib-${VERSION}/doc/html
	# license, readme, install, ...
	# 	jallib
	cp distrib/jallib-extra/LICENSE.bsd distrib/jallib-${VERSION}/
	cp distrib/jallib-extra/LICENSE.zlib distrib/jallib-${VERSION}/
	cp distrib/jallib-extra/README.release distrib/jallib-${VERSION}/README
	cp distrib/jallib-extra/README.blink distrib/jallib-${VERSION}/README.blink
	# 	jallib-all_devices
	cp distrib/jallib-extra/LICENSE.bsd distrib/jallib-all_devices-${VERSION}/
	cp distrib/jallib-extra/LICENSE.zlib distrib/jallib-all_devices-${VERSION}/
	cp distrib/jallib-extra/README.device distrib/jallib-all_devices-${VERSION}/README
	cp distrib/jallib-extra/README.blink distrib/jallib-all_devices-${VERSION}/README.blink
	cp -r distrib/jallib-export/doc/html/devicefiles.html distrib/jallib-all_devices-${VERSION}/doc/html
	cp -r distrib/jallib-export/doc/html/jallib.css distrib/jallib-all_devices-${VERSION}/doc/html
	# include CHANGELOG
	cp distrib/jallib-export/CHANGELOG distrib/jallib-${VERSION}/
	cp distrib/jallib-export/CHANGELOG distrib/jallib-all_devices-${VERSION}/
	echo DONE: release directory distrib/jallib-${VERSION}/ and distrib/jallib-all_devices-${VERSION}/

pack:
	# now include compiler binaries
	# guess compiler version
	mkdir -p distrib/jallib-pack-`distrib/jallib-export/compiler/jalv2 | sed "s#.*jal \(.*\) (.*#\1#"`-${VERSION}
	# generate VERSION file (jallib version)
	echo ${VERSION} > distrib/jallib-pack-`distrib/jallib-export/compiler/jalv2 | sed "s#.*jal \(.*\) (.*#\1#"`-${VERSION}/VERSION
	# include CHANGELOG
	cp distrib/jallib-export/CHANGELOG distrib/jallib-pack-`distrib/jallib-export/compiler/jalv2 | sed "s#.*jal \(.*\) (.*#\1#"`-${VERSION}/
	cp -rp distrib/jallib-export/compiler distrib/jallib-pack-`distrib/jallib-export/compiler/jalv2 | sed "s#.*jal \(.*\) (.*#\1#"`-${VERSION}
	cp -rp distrib/jallib-${VERSION}/* distrib/jallib-pack-`distrib/jallib-export/compiler/jalv2 | sed "s#.*jal \(.*\) (.*#\1#"`-${VERSION}
	echo DONE: jallib pack ready

release: export dispatch pack
	cd distrib && tar czfv jallib-${VERSION}.tar.gz jallib-${VERSION}
	cd distrib && tar czfv jallib-all_devices-${VERSION}.tar.gz jallib-all_devices-${VERSION}
	cd distrib && tar czfv jallib-pack-`jallib-export/compiler/jalv2 | sed "s#.*jal \(.*\) (.*#\1#"`-${VERSION}.tar.gz jallib-pack-`jallib-export/compiler/jalv2 | sed "s#.*jal \(.*\) (.*#\1#"`-${VERSION}
	# ZIPs don't contain a base directory
	cd distrib/jallib-${VERSION} && zip -r jallib-${VERSION}.zip . && mv jallib-${VERSION}.zip ..
	cd distrib/jallib-all_devices-${VERSION} && zip -r jallib-all_devices-${VERSION}.zip . && mv jallib-all_devices-${VERSION}.zip ..
	cd distrib/jallib-pack-`distrib/jallib-export/compiler/jalv2 | sed "s#.*jal \(.*\) (.*#\1#"`-${VERSION} && zip -r jallib-pack-`../jallib-export/compiler/jalv2 | sed "s#.*jal \(.*\) (.*#\1#"`-${VERSION}.zip . && mv jallib-pack-`../jallib-export/compiler/jalv2 | sed "s#.*jal \(.*\) (.*#\1#"`-${VERSION}.zip ..

