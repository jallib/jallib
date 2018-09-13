#
# JALv2 Makefile
# Copyright (c) 2008, Kyle A. York
# All rights reserved
#
LIBS=../libpic12/libpic12-$(ARCH).a ../libcore/libcore-$(ARCH).a ../libutils/libutils-$(ARCH).a
PROGRAM=../../bin/jalv2-$(ARCH)

.PHONY: dummy

jaldefault: dummy project

dummy:
	./build.sh
	-rm -f .obj/jal_main.o

include ../Makefile.inc

