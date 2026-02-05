# Title: Makefile to handle common task
# Author: Sebastien Lelong, Copyright (c) 2008..2023, all rights reserved.
# Adapted by: Rob Jansen
# 
# This file is part of jallib (https://github.com/jallib/jallib)
# Released under the ZLIB license (http://www.opensource.org/licenses/zlib-license.html)
#
# Usage: make [target] [VERSION=version_name]
# Available targets: help, dev, beta, release, bee, maketest, clean, etc.

# Enable strict error handling
SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

# =============================================================================
# VARIABLES
# =============================================================================

# Version and Build Configuration
VERSION ?= dev
WEEKLYBUILDCODENAME ?= bee
MAX_PROCESSES ?= 16
ENABLE_PDFS ?= true

# Directory Configuration
SAMPLIR_DIR ?= ../sample
TEST_DIR ?= ../test
INCLUDE_DIR ?= ../include
BASEDIR ?= ~
DITA_HOME ?= ~/3rdparty/dita-ot-3.7.2

# Tool Configuration
JALV2_BIN := $(abspath $(shell pwd)/distrib/jallib-export/compiler/jalv2-i686)
JALV2_VERSION := $(shell bash -c '${JALV2_BIN} 2>/dev/null | head -1 | cut -d" " -f2' || echo "unknown")


# Export variables for sub-makes
export BASEDIR
export DITA_HOME

# =============================================================================
# PHONY TARGETS
# =============================================================================
.PHONY: all help clean compile jsg pwmlib adclib doc vimdoc matrix generate-docs export prepare prepare-quick jallib-pack-base jallib-pack jallib-pack-quick archive check bee-archive bee-check check-quick maketest dev beta release bee pdfbooks

# =============================================================================
# MAIN TARGETS
# =============================================================================

all : dev

help: ## Show this help message
	@echo "Jallib Makefile - Available targets:"
	@echo ""
	@echo "Main Build Targets:"
	@echo "  dev        - Development build (fast, no PDFs)"
	@echo "  beta       - Beta release build (with PDFs)"
	@echo "  release    - Full release build (with PDFs)"
	@echo "  bee        - Weekly build (with PDFs)"
	@echo "  maketest   - For Makefile testing only"
	@echo ""
	@echo "Utility Targets:"
	@echo "  clean      - Clean generated files"
	@echo "  help       - Show this help"
	@echo "  compile    - Compile sample files"
	@echo "  doc        - Generate API documentation"
	@echo ""
	@echo "Usage: make [target] [VERSION=version_name]"
	@echo "Example: make dev VERSION=myversion"
	@echo ""
	@echo "Current configuration:"
	@echo "  VERSION: $(VERSION)"
	@echo "  MAX_PROCESSES: $(MAX_PROCESSES)"
	@echo "  ENABLE_PDFS: $(ENABLE_PDFS)"

clean : ## Clean generated files and build artifacts
	@echo "Cleaning generated files..."
	@echo "Cleaning JAL compilation artifacts..."
	@find ${SAMPLIR_DIR} -name \*.cod -exec rm {} \; 2>/dev/null || true
	@find ${SAMPLIR_DIR} -name \*.lst -exec rm {} \; 2>/dev/null || true
	@find ${SAMPLIR_DIR} -name \*.hex -exec rm {} \; 2>/dev/null || true
	@find ${SAMPLIR_DIR} -name \*.err -exec rm {} \; 2>/dev/null || true
	@find ${SAMPLIR_DIR} -name \*.obj -exec rm {} \; 2>/dev/null || true
	@find ${SAMPLIR_DIR} -name \*.asm -exec rm {} \; 2>/dev/null || true
	@find ${TEST_DIR} -name \*.cod -exec rm {} \; 2>/dev/null || true
	@find ${TEST_DIR} -name \*.lst -exec rm {} \; 2>/dev/null || true
	@find ${TEST_DIR} -name \*.hex -exec rm {} \; 2>/dev/null || true
	@find ${TEST_DIR} -name \*.err -exec rm {} \; 2>/dev/null || true
	@find ${TEST_DIR} -name \*.obj -exec rm {} \; 2>/dev/null || true
	@find ${TEST_DIR} -name \*.asm -exec rm {} \; 2>/dev/null || true
	@echo "Cleaning Python bytecode..."
	@find ./ -name \*.pyc -exec rm {} \; 2>/dev/null || true
	@echo "Cleaning distribution directory..."
	@rm -fr distrib 2>/dev/null || true
	@echo "Clean completed successfully"
		
compile: ## Compile sample files (single-threaded, use check_package_parallel.sh for faster builds)
	@echo "Compiling sample files (single-threaded)..."
	@echo "Note: For faster compilation, use check_package_parallel.sh instead"
	@for f in `find ${SAMPLIR_DIR} -name \*.jal`; \
	do \
		echo "Compiling $$f..."; \
		../compiler/jalv2-i686 -no-variable-reuse -s "`find ${INCLUDE_DIR} -type d | grep -v \.svn | tr '\n' ';'`" $$f | grep '^0 errors, 0 warnings' && true || ( echo "ERROR: Compilation failed for $$f" && exit 255; ) \
	done
	@echo "Compilation completed successfully" 

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

generate-docs:
	# doc
	for f in `cat distrib/jallib-export/TORELEASE | grep ^include | grep -v include.device | tr -d '\r'` ; \
	do \
		libfile=`basename $$f`; \
		htmlfile=`echo $$libfile | sed "s#\.jal#.html#"`; \
		python2.7 jallib.py jalapi -l -d distrib/jallib-${VERSION}/sample -t jalapi_html.tmpl -o distrib/jallib-${VERSION}/doc/html/$$htmlfile distrib/jallib-${VERSION}/lib/$$libfile ;\
	done
	# doc menu...
	echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd"><html><head><title>Libraries - jallib API doc</title></head><body>' > distrib/jallib-${VERSION}/doc/html/menu.html
	# manually include device files doc, as it's not generated from a lib
	echo "<a href='https://github.com/jallib/jallib' target='_parent'><i>back to jallib</i></a><br/><br/>" >> distrib/jallib-${VERSION}/doc/html/menu.html
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
	git clone --depth 1 https://github.com/jallib/Jallib.git distrib/jallib-export

prepare:
	# flatten library files
	cd  distrib/jallib-${VERSION} && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^include\/ | tr -d '\r'`; \
	do \
		cp ../jallib-export/$$f lib || (echo problem with $$f ) \
	done | grep problem && exit 255 || true
	# same but no device
	cd  distrib/jallib-libnodevice && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep -v ^include\/device | grep ^include\/ | tr -d '\r'`; \
	do \
		cp ../jallib-export/$$f . || (echo problem with $$f ) \
	done | grep problem && exit 255 || true
	# keep sample structure, but only for those in TORELEASE
	-cd  distrib/jallib-${VERSION} && mkdir sample
	cd  distrib/jallib-${VERSION} && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^sample\/ | tr -d '\r'`; \
	do \
		cp ../jallib-export/$$f sample/ || (echo problem with $$f ) \
	done | grep problem && exit 255 || true
	# same for "project"
	-cd  distrib/jallib-${VERSION} && mkdir project
	cd  distrib/jallib-${VERSION} && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^project\/ | tr -d '\r'`; \
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

ifneq ($(GENERATE_DOCS),false)
	$(MAKE) generate-docs
endif

	# license, readme, install, ...
	# 	jallib
	cp distrib/jallib-export/LICENSE.bsd distrib/jallib-${VERSION}/
	cp distrib/jallib-export/LICENSE.zlib distrib/jallib-${VERSION}/
	cp distrib/jallib-export/tools/README.release distrib/jallib-${VERSION}/README
	cp distrib/jallib-export/tools/README.device distrib/jallib-${VERSION}/README.device
	cp distrib/jallib-export/tools/README.blink distrib/jallib-${VERSION}/README.blink
	# 	jallib-all_devices
	cp distrib/jallib-export/LICENSE.bsd distrib/jallib-all_devices-${VERSION}/
	cp distrib/jallib-export/LICENSE.zlib distrib/jallib-all_devices-${VERSION}/
	cp distrib/jallib-export/tools/README.device distrib/jallib-all_devices-${VERSION}/README
	cp distrib/jallib-export/tools/README.blink distrib/jallib-all_devices-${VERSION}/README.blink
	cp -r distrib/jallib-export/doc/html/devicefiles.html distrib/jallib-all_devices-${VERSION}/doc/html
	cp -r distrib/jallib-export/doc/html/jallib.css distrib/jallib-all_devices-${VERSION}/doc/html
	# include CHANGELOG
	cp distrib/jallib-export/CHANGELOG distrib/jallib-${VERSION}/
	cp distrib/jallib-export/CHANGELOG distrib/jallib-all_devices-${VERSION}/
	echo DONE: release directory distrib/jallib-${VERSION}/ and distrib/jallib-all_devices-${VERSION}/

prepare-quick:
	$(MAKE) prepare GENERATE_DOCS=false

jallib-pack-base:
	# now include compiler binaries
	# guess compiler version
	mkdir -p distrib/jallib-pack-${JALV2_VERSION}-${VERSION}
	# generate VERSION file (jallib version)
	echo ${VERSION} > distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/VERSION
	# include CHANGELOG
	cp distrib/jallib-export/CHANGELOG distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/
	cp -rp distrib/jallib-export/compiler distrib/jallib-pack-${JALV2_VERSION}-${VERSION}
	cp -rp distrib/jallib-${VERSION}/* distrib/jallib-pack-${JALV2_VERSION}-${VERSION}
	# include static docs
	cd  distrib/jallib-pack-${JALV2_VERSION}-${VERSION} && \
	for f in `cat ../jallib-export/TORELEASE | grep -v ^\# | grep ^doc\/ | tr -d '\r'`; \
	do \
		cp ../jallib-export/$$f doc/ || (echo problem with $$f ) \
	done | grep problem && exit 255 || true

jallib-pack: pdfbooks jallib-pack-base
	# include PDF books (generated)
	cp $$HOME/tmp/pdfbooks_${VERSION}/*.pdf distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/doc/ 
	echo DONE: jallib pack ready

jallib-pack-quick: jallib-pack-base
	echo DONE: jallib pack ready - quick version

archive:
	# ZIPs don't contain a base directory
	cd distrib/jallib-${VERSION} && zip -r jallib-${VERSION}.zip . && mv jallib-${VERSION}.zip ..
	cd distrib/jallib-all_devices-${VERSION} && zip -r jallib-all_devices-${VERSION}.zip . && mv jallib-all_devices-${VERSION}.zip ..
	cd distrib/jallib-pack-${JALV2_VERSION}-${VERSION} && zip -r jallib-pack-${JALV2_VERSION}-${VERSION}.zip . && mv jallib-pack-${JALV2_VERSION}-${VERSION}.zip ..

check:
	bash check_package_parallel.sh distrib/jallib-${VERSION}/lib distrib/jallib-${VERSION}/sample ../compiler/jalv2-i686
	bash check_package_parallel.sh distrib/jallib-all_devices-${VERSION}/lib distrib/jallib-all_devices-${VERSION}/blink ../compiler/jalv2-i686
	bash check_package_parallel.sh distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/lib distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/sample distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/compiler/jalv2-i686

bee-archive:
	# simplify folder name so I can use `` while generating archive names (else some `` are nested)
	-mv distrib/jallib-pack-${JALV2_VERSION}-${VERSION} distrib/jallib-pack-${VERSION}
	# We need to enrich version with date, so user can report what exact version is used (else there'll just a "bee"
	echo ${VERSION}-${JALV2_VERSION}-`date +%Y%m%d` > distrib/jallib-pack-${VERSION}/VERSION
	##cd distrib && tar czfv jallib-pack-`cat jallib-pack-${VERSION}/VERSION`.tar.gz jallib-pack-${VERSION}
	cd distrib/jallib-pack-${VERSION} && zip -r jallib-pack-`cat VERSION`.zip . && mv jallib-pack-`cat VERSION`.zip ..

bee-check:
	bash check_package_parallel.sh distrib/jallib-pack-${VERSION}/lib distrib/jallib-pack-${VERSION}/sample distrib/jallib-pack-${VERSION}/compiler/jalv2-i686



check-quick:
	bash check_package_parallel.sh distrib/jallib-${VERSION}/lib distrib/jallib-${VERSION}/sample ../compiler/jalv2-i686 test-one
	bash check_package_parallel.sh distrib/jallib-all_devices-${VERSION}/lib distrib/jallib-all_devices-${VERSION}/blink ../compiler/jalv2-i686 test-one
	bash check_package_parallel.sh distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/lib distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/sample distrib/jallib-pack-${JALV2_VERSION}-${VERSION}/compiler/jalv2-i686 test-one

maketest: ## Quick test build (fast, minimal testing)
	@echo "Starting maketest build (VERSION=maketest)..."
	$(MAKE) VERSION=maketest clean export prepare-quick jallib-pack-quick archive check-quick
	@echo "Maketest build completed successfully"

bee: ## Weekly build (with PDFs, for automated builds)
	@echo "Starting bee weekly build (VERSION=bee)..."
	$(MAKE) VERSION=bee clean export prepare jallib-pack bee-archive bee-check
	@echo "Bee weekly build completed successfully"

dev: ## Development build (fast, no PDFs)
	@echo "Starting dev build (VERSION=dev)..."
	$(MAKE) VERSION=dev clean export prepare jallib-pack bee-archive bee-check
	@echo "Dev build completed successfully"

beta: ## Beta release build (with PDFs)
	@echo "Starting beta build (VERSION=beta)..."
	$(MAKE) VERSION=beta clean export prepare jallib-pack archive check
	@echo "Beta build completed successfully"

release: ## Full release build (with PDFs)
	@echo "Starting release build (VERSION=release)..."
	$(MAKE) VERSION=release clean export prepare jallib-pack archive check
	@echo "Release build completed successfully"

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
