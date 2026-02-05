# Title: Makefile to handle common task
# Author: Sebastien Lelong, Copyright (c) 2008..2023, all rights reserved.
# Adapted by: Rob Jansen
# 
# This file is part of jallib (https://github.com/jallib/jallib)
# Released under the ZLIB license (http://www.opensource.org/licenses/zlib-license.html)
#
# VERSION defaults to 'alpha' if not set (e.g. make release VERSION=2.0.0).
# Override JALV2 for compiler path (e.g. JALV2=../compiler/jalv2-x86-64 on 64-bit Linux).
#

all : alpha

help:
	@echo "Main targets:"
	@echo "  alpha        - alpha build (default): jallib_full-alpha.zip"
	@echo "  bee          - weekly build: jallib-pack-bee-jalv<ver>-<date>.zip"
	@echo "  bee-win      - bee build + Windows installer (Wine; times out after WIN_INSTALLER_TIMEOUT s, default 1800)"
	@echo "  release      - release zips: jallib-\$$(VERSION).zip, jallib_full-\$$(VERSION).zip"
	@echo "  release-win  - release zips + Windows installer .exe"
	@echo "  beta         - beta build (same as release, VERSION=beta)"
	@echo "  maketest     - quick test of Makefile (VERSION=maketest, no PDFs)"
	@echo "  clean        - remove build artifacts and distrib/"
	@echo "  win-installer - build jallib_full_win_setup-\$$(VERSION).exe (Wine; WIN_INSTALLER_TIMEOUT s)"
	@echo "  publish-release - copy distrib/*.zip and *.exe to PUBLISH_DIR_RELEASE (builds/release)"
	@echo "  publish-bee     - copy distrib/*.zip and *.exe to PUBLISH_DIR_BEE (builds/bee)"
	@echo "  download-compiler   - fetch compiler from jalv2compiler (used by export)"
	@echo "  download-win-includes - fetch AutoIt includes to Include/ (used by bee-win, win-installer under Wine)"
	@echo ""
	@echo "Examples: make release VERSION=2.0.0   make publish-release   make publish-bee   make publish PUBLISH_DIR_RELEASE=/path"

WEEKLYBUILDCODENAME=bee
VERSION ?= alpha
SAMPLE_DIR=../sample
TEST_DIR=../test
INCLUDE_DIR=../include
JALV2 ?= ../compiler/jalv2-i686
PUBLISH_DIR_RELEASE ?= /var/www/html/jal/jal.prod/sites/default/files/ftp_server/builds/release
PUBLISH_DIR_BEE ?= /var/www/html/jal/jal.prod/sites/default/files/ftp_server/builds/bee
PUBLISH_DEST ?= $(PUBLISH_DIR_RELEASE)
# Timeout for Wine+Aut2exe (seconds); if it hangs, build the .exe on Windows. Override: make bee-win WIN_INSTALLER_TIMEOUT=3600
WIN_INSTALLER_TIMEOUT ?= 1800
# AutoIt standard includes for Wine build (Aut2exe looks for ..\Include relative to itself; tools/Include = JallibWinSetup/../Include)
# Downloaded once; stored in Include/. If AUTOIT_INCLUDES_CACHE is set, copy from cache when possible and fill cache after download.
AUTOIT_INCLUDES_URL ?= https://github.com/310ken1/AutoItSciTEj/archive/refs/heads/master.zip
AUTOIT_INCLUDES_CACHE ?= $(HOME)/.cache/jallib/autoit-includes
JALV2COMPILER_URL ?= https://github.com/jallib/jalv2compiler/archive/refs/heads/master.zip
JALV2_BIN := $(shell pwd)/distrib/jallib-export/compiler/jalv2-i686
# JALV2_VERSION: extract at runtime in bee-archive; avoid $(shell) here due to make parsing of )
JALV2_VERSION :=
DITA_HOME ?= ~/3rdparty/dita-ot-3.7.2

clean :
	# clean what jal produces
	find ${SAMPLE_DIR} -name \*.cod -exec rm {} \;
	find ${SAMPLE_DIR} -name \*.lst -exec rm {} \;
	find ${SAMPLE_DIR} -name \*.hex -exec rm {} \;
	find ${SAMPLE_DIR} -name \*.err -exec rm {} \;
	find ${SAMPLE_DIR} -name \*.obj -exec rm {} \;
	find ${SAMPLE_DIR} -name \*.asm -exec rm {} \;
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
		
compile:
	for f in `find ${SAMPLE_DIR} -name \*.jal`; \
	do \
		$(JALV2) -no-variable-reuse -s "`find ${INCLUDE_DIR} -type d | grep -v \.svn | tr '\n' ';'`" $$f | grep '^0 errors, 0 warnings' && true || { echo problem with $$f; exit 255; }; \
	done

jsg:
	for f in `find ${SAMPLE_DIR} -name \*.jal`; \
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

doc: ## Generate API documentation using jalapi_generate.sh
	@echo "Generating API documentation..."
	./jalapi_generate.sh .. || (echo "Documentation generation failed" && exit 1)
	@echo "API documentation generated successfully"

vimdoc: ## Generate Vim documentation files
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
	# generate VERSION file
	echo ${VERSION} > distrib/jallib-${VERSION}/VERSION
	# get clean source from repos
	git clone --depth 1 https://github.com/jallib/Jallib.git distrib/jallib-export
	$(MAKE) download-compiler

download-compiler:
	# download compiler from https://github.com/jallib/jalv2compiler (bin/) and merge into jallib-export/compiler
	@test -d distrib/jallib-export || (echo "Run export first." && exit 1)
	curl -sL -o distrib/jalv2compiler.zip $(JALV2COMPILER_URL)
	unzip -q -o distrib/jalv2compiler.zip -d distrib
	cp -r distrib/jalv2compiler-master/bin/* distrib/jallib-export/compiler/
	rm -rf distrib/jalv2compiler-master distrib/jalv2compiler.zip
	@echo "Compiler downloaded from jalv2compiler and merged into jallib-export/compiler"

prepare:
	# flatten library files
	cd  distrib/jallib-${VERSION} && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^include\/ | tr -d '\r'`; \
	do \
		cp ../jallib-export/$$f lib || (echo problem with $$f ) \
	done | grep problem && exit 255 || true
	# keep sample structure, but only for those in TORELEASE
	# Create directory structure including subdirectories like sample/blink
	-cd  distrib/jallib-${VERSION} && mkdir -p sample
	cd  distrib/jallib-${VERSION} && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^sample\/ | tr -d '\r'`; \
	do \
		mkdir -p `dirname $$f`; cp ../jallib-export/$$f $$f || (echo problem with $$f ) \
	done | grep problem && exit 255 || true
	# same for "project"
	-cd  distrib/jallib-${VERSION} && mkdir project
	cd  distrib/jallib-${VERSION} && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^project\/ | tr -d '\r'`; \
	do \
		mkdir -p `dirname $$f`; cp ../jallib-export/$$f `dirname $$f`/ || (echo problem with $$f ) \
	done
	# include compiler in jallib package (same structure as original release)
	cp -rp distrib/jallib-export/compiler distrib/jallib-${VERSION}/

	# license, readme, install, ...
	# 	jallib
	cp distrib/jallib-export/LICENSE.bsd distrib/jallib-${VERSION}/
	cp distrib/jallib-export/LICENSE.zlib distrib/jallib-${VERSION}/
	cp distrib/jallib-export/tools/README.release distrib/jallib-${VERSION}/README
	cp distrib/jallib-export/tools/README.device distrib/jallib-${VERSION}/README.device
	cp distrib/jallib-export/tools/README.blink distrib/jallib-${VERSION}/README.blink
	# include CHANGELOG
	cp distrib/jallib-export/CHANGELOG distrib/jallib-${VERSION}/
	echo DONE: release directory distrib/jallib-${VERSION}/

prepare-quick:
	$(MAKE) prepare

jallib_full-base:
	# full package: libraries + compiler + doc + jaledit (same structure as original)
	mkdir -p distrib/jallib_full-${VERSION}
	echo ${VERSION} > distrib/jallib_full-${VERSION}/VERSION
	cp distrib/jallib-export/CHANGELOG distrib/jallib_full-${VERSION}/
	cp -rp distrib/jallib-export/compiler distrib/jallib_full-${VERSION}
	cp -rp distrib/jallib-${VERSION}/* distrib/jallib_full-${VERSION}
	# include static docs (doc/pdf from TORELEASE)
	cd  distrib/jallib_full-${VERSION} && mkdir -p doc && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^doc\/ | tr -d '\r'`; \
	do \
		cp ../jallib-export/$$f doc/ || (echo problem with $$f ) \
	done | grep problem && exit 255 || true
	# include jaledit (from Release_Files) to match original jallib_full structure
	@if [ -f ../../Release_Files/jaledit0.9.0.9.zip ]; then \
		mkdir -p distrib/jallib_full-${VERSION}/jaledit; \
		unzip -q -o ../../Release_Files/jaledit0.9.0.9.zip -d distrib/jallib_full-${VERSION}/jaledit; \
		echo "JalEdit added to jallib_full"; \
	fi

jallib_full: pdfbooks jallib_full-base
	# include PDF books (generated)
	cp $$HOME/tmp/pdfbooks_${VERSION}/*.pdf distrib/jallib_full-${VERSION}/doc/
	echo DONE: jallib_full ready

jallib_full-quick: jallib_full-base
	echo DONE: jallib_full ready - quick version

archive:
	# ZIPs don't contain a base directory. Release outputs: jallib-${VERSION}.zip, jallib_full-${VERSION}.zip
	cd distrib/jallib-${VERSION} && zip -r jallib-${VERSION}.zip . && mv jallib-${VERSION}.zip .. && \
	cd ../jallib_full-${VERSION} && zip -r jallib_full-${VERSION}.zip . && mv jallib_full-${VERSION}.zip ..

check:
	bash check_package_parallel.sh distrib/jallib-${VERSION}/lib distrib/jallib-${VERSION}/sample $(JALV2)
	bash check_package_parallel.sh distrib/jallib_full-${VERSION}/lib distrib/jallib_full-${VERSION}/sample distrib/jallib_full-${VERSION}/compiler/jalv2-i686

bee-archive:
	# bee: jallib-pack-bee-jalv<ver>-<date>.zip; alpha: jallib_full-alpha.zip
	@JALV2_VER=$$(distrib/jallib-export/compiler/jalv2-i686 2>/dev/null | sed 's/.*jal \([^ ]*\).*/\1/' | tr -d ' .' || echo "unknown"); \
	DATE=$$(date +%Y%m%d); \
	echo ${VERSION}-$${JALV2_VER}-$${DATE} > distrib/jallib_full-${VERSION}/VERSION; \
	if [ "${VERSION}" = "bee" ]; then \
		cd distrib/jallib_full-${VERSION} && zip -r jallib-pack-bee-$${JALV2_VER}-$${DATE}.zip . && mv jallib-pack-bee-$${JALV2_VER}-$${DATE}.zip ..; \
	else \
		cd distrib/jallib_full-${VERSION} && zip -r jallib_full-${VERSION}.zip . && mv jallib_full-${VERSION}.zip ..; \
	fi

bee-check:
	bash check_package_parallel.sh distrib/jallib_full-${VERSION}/lib distrib/jallib_full-${VERSION}/sample distrib/jallib_full-${VERSION}/compiler/jalv2-i686



check-quick:
	bash check_package_parallel.sh distrib/jallib-${VERSION}/lib distrib/jallib-${VERSION}/sample $(JALV2) test-one
	bash check_package_parallel.sh distrib/jallib_full-${VERSION}/lib distrib/jallib_full-${VERSION}/sample distrib/jallib_full-${VERSION}/compiler/jalv2-i686 test-one

maketest: 
	# for testing the makefile
	$(MAKE) VERSION=maketest clean export prepare-quick jallib_full-quick archive check-quick
	@if [ -f distrib/jallib-maketest.zip ] && [ -f distrib/jallib_full-maketest.zip ] && [ ! -f $$HOME/tmp/failed.log ]; then echo success; else echo failure; exit 1; fi

bee: 
	# weekly build: produces jallib-pack-bee-jalv<ver>-<date>.zip
	$(MAKE) VERSION=bee clean export prepare jallib_full bee-archive bee-check
	@if ls distrib/jallib-pack-bee-*.zip 1>/dev/null 2>&1 && [ ! -f $$HOME/tmp/failed.log ]; then echo success; else echo failure; exit 1; fi

bee-win: bee
	# bee build plus Windows installer: produces jallib-pack-bee-win-<jalv2version>-<date>.exe
	$(MAKE) bee-win-installer
	@if ls distrib/jallib-pack-bee-*.zip 1>/dev/null 2>&1 && ls distrib/jallib-pack-bee-win-*.exe 1>/dev/null 2>&1 && [ ! -f $$HOME/tmp/failed.log ]; then echo success; else echo failure; exit 1; fi

download-win-includes:
	# Ensure AutoIt includes in Include/ so Aut2exe (run from JallibWinSetup) finds ..\Include. Use cache if set to avoid re-download.
	@CACHE="$(AUTOIT_INCLUDES_CACHE)"; \
	if [ -n "$$CACHE" ] && [ -f "$$CACHE/GUIConstantsEx.au3" ]; then \
		echo "Copying AutoIt includes from cache $$CACHE to Include/"; \
		mkdir -p Include; cp -r "$$CACHE"/* Include/; \
	elif [ -f Include/GUIConstantsEx.au3 ]; then \
		echo "AutoIt includes already in Include/"; \
	else \
		echo "Downloading AutoIt includes for Wine build..."; \
		mkdir -p Include; \
		curl -sL $(AUTOIT_INCLUDES_URL) -o /tmp/autoit-includes.zip; \
		unzip -q -o /tmp/autoit-includes.zip -d /tmp; \
		cp -r /tmp/AutoItSciTEj-master/language/au3/Include/* Include/; \
		rm -rf /tmp/AutoItSciTEj-master /tmp/autoit-includes.zip; \
		if [ -n "$$CACHE" ]; then mkdir -p "$$CACHE"; cp -r Include/* "$$CACHE"/; echo "Cached to $$CACHE"; fi; \
		echo "AutoIt includes ready in Include/"; \
	fi

bee-win-installer: download-win-includes
	# Build bee Windows installer (requires wine, xvfb). Times out after WIN_INSTALLER_TIMEOUT s; if it hangs, build .exe on Windows.
	JALV2_VER=$$(distrib/jallib-export/compiler/jalv2-i686 2>/dev/null | sed 's/.*jal \([^ ]*\).*/\1/' | tr -d ' .' || echo "unknown"); \
	DATE=$$(date +%Y%m%d); \
	EXENAME="jallib-pack-bee-win-$${JALV2_VER}-$${DATE}.exe"; \
	ZIPNAME="jallib-pack-bee-$${JALV2_VER}-$${DATE}.zip"; \
	cp distrib/$$ZIPNAME JallibWinSetup/files/jallib-pack.zip && \
	cd JallibWinSetup && timeout $(WIN_INSTALLER_TIMEOUT) env WINEARCH=win32 WINEPREFIX="$$HOME/.wine-jallib-aut2exe" xvfb-run -a wine Aut2exe.exe /in JallibWinSetup.au3 /out "$$EXENAME" && \
	mv "$$EXENAME" ../distrib/ || (echo "Windows installer build timed out or failed. Build the .exe on Windows (copy JallibWinSetup and run Aut2exe there), or increase WIN_INSTALLER_TIMEOUT." && exit 1)

alpha: 
	# alpha build: produces jallib_full-alpha.zip
	$(MAKE) VERSION=alpha clean export prepare jallib_full bee-archive bee-check
	@if [ -f distrib/jallib_full-alpha.zip ] && [ ! -f $$HOME/tmp/failed.log ]; then echo success; else echo failure; exit 1; fi

beta: 
	$(MAKE) VERSION=beta clean export prepare jallib_full archive check
	@if [ -f distrib/jallib-beta.zip ] && [ -f distrib/jallib_full-beta.zip ] && [ ! -f $$HOME/tmp/failed.log ]; then echo success; else echo failure; exit 1; fi

win-installer: download-win-includes
	# Copy full zip for installer; build .exe with Wine+Aut2exe (requires xvfb, wine). Times out after WIN_INSTALLER_TIMEOUT s.
	cp distrib/jallib_full-${VERSION}.zip JallibWinSetup/files/jallib-pack.zip && \
	cd JallibWinSetup && timeout $(WIN_INSTALLER_TIMEOUT) env WINEARCH=win32 WINEPREFIX="$$HOME/.wine-jallib-aut2exe" xvfb-run -a wine Aut2exe.exe /in JallibWinSetup.au3 /out jallib_full_win_setup-${VERSION}.exe && \
	mv jallib_full_win_setup-${VERSION}.exe ../distrib/ || (echo "Windows installer build timed out or failed. Build the .exe on Windows, or increase WIN_INSTALLER_TIMEOUT." && exit 1)

release: 
	# release: produces jallib-${VERSION}.zip, jallib_full-${VERSION}.zip
	$(MAKE) VERSION=$(VERSION) clean export prepare jallib_full archive check
	@if [ -f distrib/jallib-$(VERSION).zip ] && [ -f distrib/jallib_full-$(VERSION).zip ] && [ ! -f $$HOME/tmp/failed.log ]; then echo success; else echo failure; exit 1; fi

release-win: release
	# release plus Windows installer: also produces jallib_full_win_setup-${VERSION}.exe
	$(MAKE) VERSION=$(VERSION) win-installer
	@if [ -f distrib/jallib-$(VERSION).zip ] && [ -f distrib/jallib_full-$(VERSION).zip ] && [ -f distrib/jallib_full_win_setup-$(VERSION).exe ] && [ ! -f $$HOME/tmp/failed.log ]; then echo success; else echo failure; exit 1; fi

publish: publish-release

publish-release:
	# Copy distrib packages to release location. Override PUBLISH_DIR_RELEASE if needed.
	$(MAKE) PUBLISH_DEST=$(PUBLISH_DIR_RELEASE) _publish

publish-bee:
	# Copy distrib packages to bee location. Override PUBLISH_DIR_BEE if needed.
	$(MAKE) PUBLISH_DEST=$(PUBLISH_DIR_BEE) _publish

_publish:
	@test -d distrib || (echo "No distrib/; run make release (or bee etc.) first." && exit 1)
	@test -d $(PUBLISH_DEST) || (echo "PUBLISH_DEST $(PUBLISH_DEST) does not exist." && exit 1)
	@for f in distrib/*.zip distrib/*.exe; do [ -e "$$f" ] && cp "$$f" $(PUBLISH_DEST)/; done; echo "Published to $(PUBLISH_DEST)"

pdfbooks: ## Generate PDF and HTML documentation (requires DITA)
	@echo "Generating PDF and HTML documentation..."
	@if [ ! -d "$(DITA_HOME)" ]; then \
		echo "Error: DITA_HOME not found at $(DITA_HOME)"; \
		echo "Please install DITA-OT or set DITA_HOME variable"; \
		exit 1; \
	fi
	@mkdir -p $$HOME/tmp/pdfbooks_${VERSION}
	$$DITA_HOME/bin/dita -project=`pwd`/../doc/dita/tutorials/pdf.xml -o $$HOME/tmp/pdfbooks_${VERSION} || (echo "PDF generation failed" && exit 1)
	$$DITA_HOME/bin/dita -project=`pwd`/../doc/dita/tutorials/html.xml -o $$HOME/tmp/pdfbooks_${VERSION} || (echo "HTML generation failed" && exit 1)
	@echo "Documentation generation completed successfully"
