#!/usr/bin/env python3
"""
Title: Modify 'in place' multiple (selected) files in a directory tree

Author: Rob Hamerling, Copyright (c) 2017..2017, all rights reserved.

Adapted-by:

Compiler: N/A

This file is part of jallib  http://github.com/jallib/jallib
Released under the BSD license
             http://www.opensource.org/licenses/bsd-license.php

Description:
  Python script to update multiple Jallib files,
  in particular samples and libraries.

Notes: -

"""

import os
import sys

base = os.path.join("/", "media", "ramdisk", "jallib-master")   # parent directory

subdirs = ("include", "sample")                    # selected subdirectories
                                                   # subdirectories of these are handled too!

google = "http://jallib.googlecode.com"            # current content
github = "https://github.com/jallib/jallib"        # replacement



def edit_file(f, subd):
   """ Edit a single file
   """
   p = os.path.join(subd, f)
   with open(p, "r", errors='ignore') as fd:       # ignore (encoding) issues
      ln = fd.readlines()                          # obtain list of lines

   lm = []                                         # new list of lines
   change_flag = False                             # no changes (yet)
   for i in range(len(ln)):                        # all read lines
      if (ln[i].find(google) >= 0):
         lm.append(ln[i].replace(google, github))  # edit
         print("    Replaced reference to Googlecode")
         change_flag = True                        # something changed
      elif ((f.startswith("18f2450")) &
            (ln[i].find("target VOLTAGE") >= 0) &
            (ln[i].find("V20") >= 0)):
         lm.append(ln[i].replace("V20", "V21"))    # edit
         print("    Updated pragma target voltage")
         change_flag = True                        # something changed
      elif ((f.startswith("18f4550")) &
            (ln[i].find("target VOLTAGE") >= 0) &
            (ln[i].find("MINIMUM") >= 0)):
         lm.append(ln[i].replace("MINIMUM", "V21    "))    # edit
         print("    Updated pragma target voltage")
         change_flag = True                        # something changed
      else:
         lm.append(ln[i])                          # unchanged

   if (change_flag):                               # something changed
      print("      of:", os.path.split(p)[-1])
      with open(p, "w") as fp:                     # rewrite (modified) file
         fp.writelines(lm)



def edit_subdir(subd):
   """ Select all files to be edited
   """
   print(subd)
   files = os.listdir(subd)
   files.sort()
   for f in files:
      p = os.path.join(subd, f)
      if os.path.isdir(p):
         if not f in ("device"):                   # skip all device files
            edit_subdir(p)                         # recursive call
      else:
         if (f.find("_blink_") < 0):               # do not process blink samples
            edit_file(f, subd)


# === E N T R Y   P O I N T ===

if (__name__ == "__main__"):
   print("Editing multiple files in Jallib directory trees", subdirs)
   for sd in subdirs:
      edit_subdir(os.path.join(base, sd))


