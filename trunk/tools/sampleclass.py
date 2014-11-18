#!/usr/bin/python
# ---------------------------------------------------------------
# Title: Sampleclas.py - Create list with count of sample types based on filename
#
# Author: Rob Hamerling, Copyright (c) 2012..2014, all rights reserved.
#
# Adapted-by:
#
# Revision: $Revision$
#
# Compiler: N/A
#
# This file is part of jallib  http://jallib.googlecode.com
# Released under the BSD license
#              http://www.opensource.org/licenses/bsd-license.php
#
# Description:
#   Create a list with a count of sample types based on the filename.
#   It is assumed that the filename starts with PIC type, followed
#   by the name of the library for which the sample is a showcase.
#
# Sources:
#
# Notes:
#
# --------------------------------------------------------------

import os, sys

base       = "k:/jallib"                                    # base directory of local copy of Jallib
smpdir     = base + "/sample"                               # samples
report     = "sampleclass.lst"

# --------------------------------------------------------------
# mainline
# --------------------------------------------------------------
def main():
   print "Collecting primary library usage"
   fr = open(report, "w")
   libcount = {}
   for (root, dirs, files) in os.walk(smpdir):              # whole tree (incl subdirs!)
      dirs.sort()
      files.sort()
      for file in files:
         fn = file[:-4]                                     # remove extension '.jal'
         word = fn.split("_", 1)
         libname = word[1]                                  # 2nd part of filename
         libcount[libname] = libcount.get(libname, 0) + 1

   keylist = sorted(libcount.keys())
   for lib in keylist:
       fr.write("%4d  %s\n" % (libcount[lib], lib))

   fr.close()
   print "See", report, "for results."


# === start ====================================================
# process commandline parameters, start process
# ==============================================================

if (__name__ == "__main__"):

   main()


