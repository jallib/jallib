#
# JALv2 Makefile
# Copyright (c) 2008, Kyle A. York
# All rights reserved
#
# Usage:
#   higher level makefiles define PROGRAM (program name) or LIBRARY
#   (library name) but not both. All sources in the directory are
#   assumed to belong. The result is left in the same directory
#   as the sources.
#   Object files go into obj
#   Dependency files are automatically generated and go into .dep
#
default: project

#COVERAGE=-fprofile-arcs -ftest-coverage
#PROFILE=-pg
DEBUG=-g

ifeq ($(ARCH),x86-64)
  MARCH = -m64
else ifeq ($(ARCH),i686)
  MARCH = -m32
else
  $(error Unknown or unset ARCH)
endif

CFLAGS=-O0 -Werror -ansi -pedantic -W -Wall -Wshadow -Wcast-qual -Wcast-align -march=$(ARCH) $(MARCH) $(DEBUG) $(PROFILE) $(COVERAGE)
LFLAGS=$(DEBUG) $(PROFILE) $(COVERAGE) $(MARCH) -march=$(ARCH) -lm

OBJ_DIR=.obj-$(ARCH)

DEP_DIR=.dep
SRCS=$(wildcard *.c)
OBJS=$(addprefix $(OBJ_DIR)/, $(SRCS:.c=.o))

%.asm : %.jal
	../bin/jalv2 -pcode -no-fuse -s lib $<

%.a : %.jal
	../bin/jalv2 -pcode -no-fuse -s lib $<

%.d : %.jal
	../bin/jalv2 -debug -pcode -no-fuse -s lib $<

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)
	mkdir -p $(DEP_DIR)

#
# splint note -- unless I plan to annotate the source
# (I don't) I need to use '-weak'
#
DEP=$(DEP_DIR)/$(*F)
$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	#splint -weak -bufferoverflowhigh -pred-bool -cast-fcn-ptr -unrecog -skipisoheaders $<
	$(CC) -MMD -MF $(DEP).d -c -o $@ $(CFLAGS) $<

%.o : $(OBJ_DIR)/%.o

#
# Program rules
#
ifneq ($(PROGRAM),)

project: $(PROGRAM)

$(PROGRAM): $(OBJS) $(LIBS)
	$(CC) $(LFLAGS) -o $@ $(OBJS) $(LIBS)

clean::
	-rm $(PROGRAM)

endif

#
# Library rules
#
ifneq ($(LIBRARY),)

project: $(LIBRARY)

$(LIBRARY): $(OBJS)
	$(AR) -r $@ $(OBJS)

clean::
	-rm -f $(LIBRARY)

endif

#
# Parts rules (subdirectories)
#
ifneq ($(PARTS),)

project:
	@for dir in $(PARTS) ; do \
		( make -C $$dir )       \
	done

clean::
	@for dir in $(PARTS) ; do \
		( make -C $$dir clean ) \
	done

endif

ifeq ($(strip $(filter clean%, $(MAKECMDGOALS))),)
	-include $(addprefix $(DEP_DIR)/,$(SRCS:.c=.d))
endif


clean::
	-rm -rf $(OBJ_DIR) $(DEP_DIR) 

