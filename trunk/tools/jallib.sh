#!/bin/bash
#
#
# Title: jallib executable for linux systems
# Author: Sebastien Lelong, Copyright (c) 2008, all rights reserved.
# Adapted-by:
# Compiler:
# 
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
# 
# Description: the aim of this script is to ease user's life !
# If *you* are a user, edit (or copy) this script by specfiying the following
# environment variables. These variables will save you some typing
# while using the jallib wrapper script. Adapt it to your own need !
# Once done, you can put this script in your path.
# Rem: usually, setting JALLIB_ROOT as an absolute path is enough.
# 


#########################
# ENVIRONMENT VARIABLES #
#########################
# Path to the jallib root's repository (containing "tools,"unvalidated","validated" dirs)
export JALLIB_ROOT=
# path to jallib root's libraries. You may want to point to "validated" or "unvalidated"
export JALLIB_REPOS=$JALLIB_ROOT/unvalidated/include
# path to jallib root's samples. You may want to point to "validated" or "unvalidated"
export JALLIB_SAMPLEDIR=$JALLIB_ROOT/unvalidated/sample
# path to "jalv2" executable. If not in your PATH, set an absolute path to the exec
export JALLIB_JALV2=jalv2



# Either:
#  - run the "jallib" standalone executable
#    (no dependencies, recommended)
#  - run the jallib.py python script 
#    (advanced user, you'll need to install dependencies first)

##############
# Standalone #
##############
# (recommended)
$JALLIB_ROOT/tools/jallib $*


####################
# python script    #
####################
# (advanced users)
# uncomment the two last line, and comment the standalone call.
## path to "python" executable, if needed
#export JALLIB_PYTHON=python
#$JALLIB_PYTHON $JALLIB_ROOT/tools/jallib.py $*


