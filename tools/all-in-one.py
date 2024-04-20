#!/usr/bin/env python3
"""
Title: Generate Jallib device files and blink-a-led samples.

Author: Rob Hamerling, Copyright (c) 2017..2024, all rights reserved.
        Rob Jansen,    Copyright (c) 2020..2024, all rights reserved.

Adapted-by: 

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the ZLIB license http://www.opensource.org/licenses/zlib-license.html

Description:
   Run all scripts to create device files and blink samples,
   incl. validation and compilation of blink-a-led samples.
   Several intermediate steps take care of the required support files.

Sources: N/A

Notes:
   - See the file README.pic2jal for user instructions

   Changes 2024-03-08
   - replaced subprocess by popen method
   - 'args' parameter in run_script() never used: removed


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
def run_script(script):                               
   """ Run a Python script as subprocess.
       Check result, when failing: log output and return False
       Always create log file for pic2jal and blink-a-led scripts
   """
   if (not os.path.exists(script)):
      print("Could not find script", script)
      return False
   cmdstring = f"{python_exec} {script}"
   print(f"Running: {cmdstring} ...")
   output = os.popen(cmdstring)                 # start process
   loglist = output.readlines()                 # subprocess output: list of lines
   if (((rc := output.close()) is not None) or           # in case of failure
       (script in ("pic2jal.py", "blink-a-led.py"))):    # always a log desired
      flog = os.path.join(base, script[:-2] + "log")     # build name for log file
      with open(flog, "w") as fp:               # create log file
         fp.write("".join(loglist))             # save output
      if rc is not None:                        # script error(s)
         print(f"{script} failed, returncode: {rc}") 
         return False
      else:
         print(f"See logfile: {flog}")       
   print("   Successful!")
   return True


# ----------------------------
# --- E N T R Y  P O I N T ---
# ----------------------------
if (__name__ == "__main__"):
   """ Start process """

   print("Generating JalV2 device files and blink-a-led samples")

   # prepare
   if os.path.exists(base):                  # old base
      sys.stdout.write("==> WARNING! Found existing destination: " + base + "\n")
      sys.stdout.write("==>          Press 'Y' to discard all contents and continue: ")
      sys.stdout.flush()
      if "Y" != sys.stdin.readline().strip().upper():    # check response
         exit(99)                            # terminate to preserve destination
      else:
         shutil.rmtree(base)                 # start from scratch!
   os.makedirs(base)                         # create new base

   # step 1
   # extract the required .pic files from MPLABX
   if run_script("mplabxtract.py") == False:
      exit(1)

   # step 2
   # Create human readable versions of .pic files
   if run_script("xmltree.py") == False:
      exit(2)

   # step 3
   # Create new pinmap.py and pinaliases.json files
   if run_script("pinmap_create.py") == False:
      exit(3)

   # step 4
   # copy required files for next step to destination
   print("Copying some files to", base)
   try:
       shutil.copy2("devicespecific.json", base)
#      shutil.copy2("../jallib/tools/devicespecific.json", base)    # RobH
   except:
      print("Failed to copy file(s) to", base)
      exit(4)

   # step 5
   # Create device files
   if run_script("pic2jal.py") == False:
      exit(5)

   # step 6
   # Verify device files and create, verify and compile blink-a-led samples
   if (run_script("blink-a-led.py") == False):
      exit(6)

   print("\nAll done!\n")

#
