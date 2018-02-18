#!/usr/bin/env python3
"""
Title: Compare new device files with previous committed device files

Author: Rob Hamerling, Copyright (c) 2017..2017, all rights reserved.

Adapted-by: Rob Jansen, Copyright (c) 2017..2017, all rights reserved.

Revision: $Revision$

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the BSD license https://www.opensource.org/licenses/bsd-license.php

Description:
   Compare new device files with previous committed device files
   - skip header (about 35 lines)
   - when difference(s) show the first different line of each
   - when different show files with Kdiff3 (optional)
   - log names of files between which differences are detected.
   - generate commandfile to copy changed or new files to old directory.
   Output files are stored in the directory of the [PIC2JAL] environment variable

Sources: N/A

Notes:
   Adapt the platform dependent variables to your situation

"""

from pic2jal_environment import check_and_set_environment
base, mplabxversion = check_and_set_environment()    # obtain environment variables
if (base == ""):
   exit(1)

import sys
import os
import glob
import fnmatch
import subprocess
import platform

platform_name = platform.system()

# --- system dependent paths
if (platform_name == "Linux"):
   olddir = os.path.join("/", "media", "nas", "picdevices", "test")  # previous device files
   kdiff  = "kdiff3"                                                 # assumed to be in path
   cpy    = os.path.join(base, "comparejal_copy.sh")                 # copy commandfile
elif (platform_name == "Windows"):
   olddir = os.path.join("D:\\", "jallib-master", "include", "device")      # previous device files
   kdiff  = os.path.join("C:\\", "Program Files", "KDiff3", "kdiff3.exe")    # full path
   cpy    = os.path.join(base, "comparejal_copy.cmd")                # copy commandfile
elif (platform_name == "Darwin"):                                    # Mac
   olddir = os.path.join("/", "media", "nas", "picdevices", "test")  # previous device files
   kdiff  = "kdiff3"                                                 # assumed to be in path
   cpy    = os.path.join(base, "comparejal_copy.sh")                 # copy commandfile
else:
   print("Please add platform specific info to this script!")
   exit(1)

newdir = os.path.join(base, "test")                   # new device files
log    = os.path.join(base, "comparejal.log")         # list with change device files


# -----------------------------------------------------

def compare_devs(newdevs, selection):

   comparecount = 0
   diffcount = 0
   newcount = 0
   visual_compare = "ON"

   fl = open(log, "w")                                # log file
   fc = open(cpy, "w")                                # commandlist with copy commands

   newdevs.sort()
   for newdev in newdevs:                             # all new device files

      picname = os.path.split(newdev)[1][:-4]
      if not fnmatch.fnmatch(picname, selection):     # not within selection
         continue

      print(picname)                                  # progress signal

      olddev = os.path.join(olddir, picname +  ".jal")   # pathspec old device file
      if not os.path.exists(olddev):
         print("   Seems a new device")
         fl.write("++ " + newdev +  "\n")
         if (platform_name == "Linux"):
            fc.write("cp ")
         elif (platform_name == "Windows"):
            fc.write("copy ")
         elif (platform_name == "Darwin"):
            fc.write("cp ")
         else:                                        # other platform
            pass
         fc.write(os.path.join(newdir, newdev) + " " + olddev + "\n")
         newcount += 1
         continue

      fn = open(newdev, "r")
      if (fn == None):
         print("   Failed to open new:", newdev, ", terminating!")
         break
      fo = open(os.path.join(olddev, olddev), "r")
      if (fo == None):
         print("   Failed to open old:", olddev, ", terminating!")
         break

      # skip header part of new and old device files
      newl = " "
      while not newl.startswith("include chipdef_jallib"):
         newl = fn.readline()
      oldl = " "
      while not oldl.startswith("include chipdef_jallib"):
         oldl = fo.readline()

      comparecount += 1
      diff_flag = 0                                   # no differences (yet)
      x = "Y"                                         # default answer

      while (True):                                   # all lines

         newl = fn.readline()
         if (newl == ""):                             # EOF
            break

         oldl = fo.readline()
         if (oldl == ""):                             # EOF
            break

         if (newl == oldl):                           # lines are equal
            continue                                  # continue with next line

         print("   new:", newl.strip())
         print("   old:", oldl.strip())
         fo.close()                                   # unequal pair of lines: no more reading
         fn.close()
         diff_flag = 1
         diffcount = diffcount + 1                    # count files which are different
         fl.write("!! " + os.path.join(olddir, olddev) + "\n")
         if (platform_name == "Linux"):
            fc.write("cp ")
         elif (platform_name == "Windows"):
            fc.write("copy ")
         elif (platform_name == "Darwin"):
            fc.write("cp ")
         else:                                        # other platform
            pass
         fc.write(os.path.join(newdir, newdev) + " " + olddev + "\n")
         if (visual_compare != 'ON'):
            break                             #
         sys.stdout.write("Press N to skip this file, U to only list different files, Q to quit entirely:")
         sys.stdout.flush()
         x = sys.stdin.readline().strip().upper()
         if (x == "U"):                               # skip visual compare of remaining files
            visual_compare = "OFF"
            break
         elif ((x == "N") or (x == "Q")):             # no (more) compares
            break
         else:
            subprocess.call([kdiff, newdev, os.path.join(olddir, olddev)], shell=False)
            break

      if (diff_flag == 0):                            # no differences
         fl.write('== ' + newdev + "\n")

      if (x == "Q"):                                  # skip all following files in list
         break

   fl.close()                                         # close log
   fc.close()                                         # close list of copy commands

   return [comparecount, diffcount, newcount]




# === E N T R Y   P O I N T ===

if (__name__ == "__main__"):

   if (len(sys.argv) > 1):                            # any commandline argument(s)
      selection = sys.argv[1]                         # first is PIC name selection (wildcards)
   else:
      selection = "1*"                                # all device files

   print("Comparing 2 collections of include files:")
   print("  ", newdir, "<-->", olddir)

   newdevs = glob.glob(os.path.join(newdir, selection))
   if (len(newdevs) == 0):
      print("No files matching", "'" + selection + "'", "in directory", newdir)
      sys.exit(1)

   print("   Comparing", len(newdevs), "device files in", newdir)

   comparecount, diffcount, newcount = compare_devs(newdevs, selection)   # pass list of device files

   if ((diffcount > 0) | (newcount > 0)):
      print("\nOf the", len(newdevs), "new device files", comparecount, "were compared,", diffcount, "did NOT match!")
      print("There are", newcount, "new device files to be added to", olddir)
      print("See", log, "for a list of files with different files.\n")
   else:
      print("\nNo differences found in", comparecount, "device files.\n")

