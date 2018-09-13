#
# JALv2 Makefile
# Copyright (c) 2008, Kyle A. York
# All rights reserved
#
PARTS = libutils libcore libpic12 jal

include Makefile.inc

win32: libutils/libutils.a libcore/libcore.a libpic12/libpic12.a
	wine nmake /f "jal/jal.mak" "CFG=jal - Win32 Release"
	wine nmake /f "jal/jal.mak" "CFG=jal - Win32 Debug"

ctags_list_file:
	find . -name *.[ch] > ctags_list_file

ctags: ctags_list_file
	rm -f tags
	ctags -L ctags_list_file --extra=+f -f tags  
