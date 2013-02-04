# Title: Makefile to handle common task
# Author: Sebastien Lelong, Copyright (c) 2008, all rights reserved.
# Adapted by:
# 
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
#


all : clean test

WEEKLYBUILDCODENAME=bee
VERSION=dev
SAMPLIR_DIR=../sample
TEST_DIR=../test
INCLUDE_DIR=../include
JALV2_BIN := $(shell pwd)/distrib/jallib-export/compiler/jalv2
JALV2_VERSION := `${JALV2_BIN} 2> /dev/null | sed "s\#.*jal \(.*\) (.*\#\1\#"`


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
		../compiler/jalv2 -no-variable-reuse -s "`find ${INCLUDE_DIR} -type d | grep -v \.svn | tr '\n' ';'`" $$f | grep '^0 errors, 0 warnings' && true || ( echo problem with $$f && exit 255; ) \
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

pwmlib:
	cd pwm && ./pwm_generate_all.sh

adclib:
	cd adc && ./adc_generate_all.sh

doc:
	./jalapi_generate.sh ..

vimdoc:
	for f in `find ../include -name \*.jal | grep -v include.device` ; \
	do \
		libfile=`basename $$f`; \
		vimfile=`echo $$libfile | sed "s#\.jal#.txt#"`; \
		python2.7 jallib.py jalapi -l -d ../sample -t jalapi_vim.tmpl -o ../doc/vim/$$vimfile $$f ;\
	done

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

prepare:
	# flatten library files
	cd  distrib/jallib-${VERSION} && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^include\/ | sed 's#\r##g'`; \
	do \
		cp ../jallib-export/$$f lib || (echo problem with $$f ) \
	done | grep problem && exit 255 || true
	# same but no device
	cd  distrib/jallib-libnodevice && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep -v ^include\/device | grep ^include\/ | sed 's#\r##g'`; \
	do \
		cp ../jallib-export/$$f . || (echo problem with $$f ) \
	done | grep problem && exit 255 || true
	# keep sample structure, but only for those in TORELEASE
	-cd  distrib/jallib-${VERSION} && mkdir sample
	cd  distrib/jallib-${VERSION} && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^sample\/ | sed 's#\r##g'`; \
	do \
		cp ../jallib-export/$$f sample/ || (echo problem with $$f ) \
	done | grep problem && exit 255 || true
	# same for "project"
	-cd  distrib/jallib-${VERSION} && mkdir project
	cd  distrib/jallib-${VERSION} && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^project\/ | sed 's#\r##g'`; \
	do \
		mkdir -p `dirname $$f`; cp ../jallib-export/$$f `dirname $$f`/ || (echo problem with $$f ) \
	done
	# for all_devices package, keep everything...
	find distrib/jallib-export/include/device -type f -exec cp {} distrib/jallib-all_devices-${VERSION}/lib \;
	for f in `find distrib/jallib-export/sample -type f | grep -e '[[:digit:]]\{2\}[[:alpha:]]\+[[:digit:]]\+_blink\.jal' | grep -v canopen`; \
	do \
		cp $$f distrib/jallib-all_devices-${VERSION}/blink;\
	done
	# also add dependencies
	cp distrib/jallib-export/include/jal/constants_jallib.jal distrib/jallib-all_devices-${VERSION}/lib
	# doc
	for f in `cat distrib/jallib-export/TORELEASE | grep ^include | grep -v include.device | sed 's#\r##g'` ; \
	do \
		libfile=`basename $$f`; \
		htmlfile=`echo $$libfile | sed "s#\.jal#.html#"`; \
		python2.7 jallib.py jalapi -l -d distrib/jallib-${VERSION}/sample -t jalapi_html.tmpl -o distrib/jallib-${VERSION}/doc/html/$$htmlfile distrib/jallib-${VERSION}/lib/$$libfile ;\
	done
	# one-page doc
	python2.7 jallib.py jalapi -s -l -d distrib/jallib-${VERSION}/sample -t jalapi_html.tmpl -o distrib/jallib-${VERSION}/doc/html/jallib_onepage.html distrib/jallib-libnodevice/
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

jallib-pack: pdfbooks
	# now include compiler binaries
	# guess compiler version
	mkdir -p distrib/jallib-pack-${JALV2_VERSION}-${VERSION}
	# generate VERSION file (jallib version)
	echo ${VERSION} > distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/VERSION
	# include CHANGELOG
	cp distrib/jallib-export/CHANGELOG distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/
	cp -rp distrib/jallib-export/compiler distrib/jallib-pack-${JALV2_VERSION}-${VERSION}
	cp -rp distrib/jallib-${VERSION}/* distrib/jallib-pack-${JALV2_VERSION}-${VERSION}
	# include PDF books
	#   generated
	cp $$HOME/tmp/pdfbooks_${VERSION}/*.pdf distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/doc/ 
	#   static
	cd  distrib/jallib-pack-${JALV2_VERSION}-${VERSION} && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^doc\/ | sed 's#\r##g'`; \
	do \
		cp ../jallib-export/$$f doc/ || (echo problem with $$f ) \
	done | grep problem && exit 255 || true
	echo DONE: jallib pack ready

archive:
	##cd distrib && tar czfv jallib-${VERSION}.tar.gz jallib-${VERSION}
	##cd distrib && tar czfv jallib-all_devices-${VERSION}.tar.gz jallib-all_devices-${VERSION}
	##cd distrib && tar czfv jallib-pack-${JALV2_VERSION}-${VERSION}.tar.gz jallib-pack-${JALV2_VERSION}-${VERSION}
	# ZIPs don't contain a base directory
	cd distrib/jallib-${VERSION} && zip -r jallib-${VERSION}.zip . && mv jallib-${VERSION}.zip ..
	cd distrib/jallib-all_devices-${VERSION} && zip -r jallib-all_devices-${VERSION}.zip . && mv jallib-all_devices-${VERSION}.zip ..
	cd distrib/jallib-pack-${JALV2_VERSION}-${VERSION} && zip -r jallib-pack-${JALV2_VERSION}-${VERSION}.zip . && mv jallib-pack-${JALV2_VERSION}-${VERSION}.zip ..

check:
	sh check_package.sh distrib/jallib-${VERSION}/lib distrib/jallib-${VERSION}/sample ../compiler/jalv2
	sh check_package.sh distrib/jallib-all_devices-${VERSION}/lib distrib/jallib-all_devices-${VERSION}/blink ../compiler/jalv2
	sh check_package.sh distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/lib distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/sample distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/compiler/jalv2

bee-archive:
	# simplify folder name so I can use `` while generating archive names (else some `` are nested)
	# Oh, Seb, how long will you use this crappy Makefile ??
	-mv distrib/jallib-pack-${JALV2_VERSION}-${VERSION} distrib/jallib-pack-${VERSION}
	# We need to enrich version with date, so user can report what exact version is used (else there'll just a "bee"
	echo ${VERSION}-${JALV2_VERSION}-`date +%Y%m%d` > distrib/jallib-pack-${VERSION}/VERSION
	##cd distrib && tar czfv jallib-pack-`cat jallib-pack-${VERSION}/VERSION`.tar.gz jallib-pack-${VERSION}
	cd distrib/jallib-pack-${VERSION} && zip -r jallib-pack-`cat VERSION`.zip . && mv jallib-pack-`cat VERSION`.zip ..

bee-upload:
	##python2.7 ~/bin/googlecode_upload.py -s "Automated weekly build, bleeding edge jallib, version `cat distrib/jallib-pack-${VERSION}/VERSION`" -l Type-Buildbot -p jallib -u $$UPLOAD_USER -w $$UPLOAD_PASSWD distrib/jallib-pack-`cat distrib/jallib-pack-${VERSION}/VERSION`.tar.gz
	python2.7 ~/bin/googlecode_upload.py -s "Automated weekly build, bleeding edge jallib, version `cat distrib/jallib-pack-${VERSION}/VERSION`" -p jallib -l Type-Buildbot -p jallib -u $$UPLOAD_USER -w $$UPLOAD_PASSWD distrib/jallib-pack-`cat distrib/jallib-pack-${VERSION}/VERSION`.zip

bee-check:
	sh check_package.sh distrib/jallib-pack-${VERSION}/lib distrib/jallib-pack-${VERSION}/sample distrib/jallib-pack-${VERSION}/compiler/jalv2

release: export prepare jallib-pack archive check

bee: clean export prepare jallib-pack bee-archive bee-check bee-upload

pdfbooks:
	# Tutorial book
	ant -f $$DITA_HOME/build_demo.xml -Dprompt.ditamap.filename=`pwd`/../doc/dita/tutorials/tutorials.ditamap -Dprompt.output.type=pdf -Dprompt.output.directory=$$HOME/tmp/pdfbooks_${VERSION} -Dprompt.output.confirm=y
