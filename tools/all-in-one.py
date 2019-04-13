#!/usr/bin/env python3
"""
Title: Generate Jallib device files and blink-a-led samples.

Author: Rob Hamerling, Copyright (c) 2017..2019, all rights reserved.

Adapted-by: Rob Jansen

Revision: $Revision$

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the BSD license https://www.opensource.org/licenses/bsd-license.php

Description:
   Run all scripts to create device files and blink samples,
   incl. validation and compilation of blink-a-led samples.
   Several intermediate steps take care of the required support files.

Sources: N/A

Notes:
   - See the file README.pic2jal for user instructions

"""

from pic2jal_environment import check_and_set_environment
base, mplabxversion = check_and_set_environment()    # obtain environment variables
if ((base == "") | (mplabxversion == "")):
   exit(1)

import sys
import os
import subprocess
import shutil

if (base == os.getcwd()):                             # cwd must be different than base
   print("This script should not be run in the destination directory\n   <",
         base,
         ">\nInstall the pic2jal package in a separate directory.")
   exit(1)

# Name of python executable is required for calling other Python scripts.
python_exec = "python3"                               # assume python2 and python3 are installed
try:
   log = subprocess.check_output([python_exec, "--version"], shell=False)
except:
   python_exec = "python"                             # Python3 is probably default

# -------------------------------
def run_script(cmd, args=None):                       # args expected as list of arguments
   """ Run a script as subprocess.
       Check result, when failing: log output and return False
       Always create log file for pic2jal and blink-a-led scripts
   """
   if (not os.path.exists(cmd)):
      print("Could not find script", cmd)
      return False
   cmdlist = [python_exec, cmd]
   if (args != None):
      cmdlist = cmdlist + args
   print("Running:", " ".join(cmdlist), "...")
   try:
      log = subprocess.check_output(cmdlist, stderr=subprocess.STDOUT, universal_newlines=True, shell=False)
      if (cmd in ("pic2jal.py", "blink-a-led.py")):   # logs desired for these scripts!
         slog = os.path.join(base, os.path.splitext(cmd)[0] + ".log")
         with open(slog, "w") as fp:
            print(log, file=fp)                       # save script output
   except subprocess.CalledProcessError as e:
      slog = os.path.join(base, os.path.splitext(cmd)[0] + ".log")
      with open(slog, "w") as fp:
         print(e.output, file=fp)                     # save compiler output
      print("   Failed, see", slog, "for details")
      return False
   print("   Successful!")
   return True


# ----------------------------
# --- E N T R Y  P O I N T ---
# ----------------------------
if (__name__ == "__main__"):
   """ Start process
   """

   print("Generating JalV2 device files and blink-a-led samples")

   # prepare
   if os.path.exists(base):                  # old base
      sys.stdout.write("==> WARNING! Found existing destination: " + base + "\n")
      sys.stdout.write("==>          Press 'Y' to discard all contents and continue: ")
      sys.stdout.flush()
      if ("Y" != sys.stdin.readline().strip().upper()):    # check response
         exit(99)                            # terminate to preserve destination
      else:
         shutil.rmtree(base)                 # start from scratch!
   os.makedirs(base)                         # create new base

   # step 1
   # extract the required .pic files from MPLABX
   if (run_script("mplabxtract.py") == False):
      exit(1)

   # step 2
   # Create human readable versions of .pic files
   if (run_script("xmltree.py") == False):
      exit(2)

   # step 3
   # Create new pinmap.py and pinaliases.json files
   if (run_script("pinmap_create.py") == False):
      exit(3)

   # step 4
   # copy required files for next step to destination
   print("Copying some files to", base)
   try:
#      shutil.copy2("datasheet.list", base)
      shutil.copy2("devicespecific.json", base)
   except:
      print("Failed to copy file(s) to", base)
      exit(4)

   # step 5
   # Create device files
   if (run_script("pic2jal.py", args=["test"]) == False):
      exit(5)

   # step 6
   # Verify device files and create, verify and compile blink-a-led samples
   if (run_script("blink-a-led.py", args=["test"]) == False):
      exit(6)

   print("\nAll done!\n")






