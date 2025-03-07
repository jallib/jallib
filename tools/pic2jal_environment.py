#!/usr/bin/env python3
"""
Title: Check if requirements for pic2jal scripts are satisfied:

Author: Rob Hamerling, Copyright (c) 2017..2024. All rights reserved.
        Rob Jansen,    Copyright (c) 2018..2024. All rights reserved.

Adapted-by:

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the ZLIB license http://www.opensource.org/licenses/zlib-license.html

Description:
   Check if requirements for pic2jal scripts are satisfied:
   - Python version: at least Python 3.5
   - Obtain or set defaults for environment variables:
     PIC2JAL        - path of destination directory (platform specific)
     MPLABXVERSION  - version number of MPLABX, e.g.: 4.05
   Returns list with destination path and mplabxversion.
   Display an error or warning message when something is wrong or missing
   and then return list with 2 empty strings.

Sources: N/A

Notes: - Use defaults in script or adapt script to actual situation
         before running any device files generation script!
       - Allthough this script sets the environment variables these are
         only 'active' for the current process and subprocesses.
       - The following paltform names are serviced:
         "Windows", "Linux", "Darwin".
"""

import sys
import os
import platform

platform_name = platform.system()

def check_and_set_environment():

   if (sys.version_info < (3,5,0)):
      sys.stderr.write("You need Python 3.5.0 or later to run this script!\n")
      return ["",""]

   try:
      mplabxversion = os.environ["MPLABXVERSION"]  # obtain existing MPLABX version
   except:                                         # when not present: create new
      mplabxversion = "6.25"
      sys.stdout.write("MPLABX version: " + mplabxversion + "\n")
      os.environ["MPLABXVERSION"] = mplabxversion

   try:
      base = os.environ["PIC2JAL"]                 # obtain existing path of destination
   except:                                         # when not present: create new
      # destination of results for different platforms
      if (platform_name == "Linux"):
         base = os.path.join("/", "media", "ram")  # Linux
      elif (platform_name == "Windows"):
        base = os.path.join("D:\\")                # Windows
      elif (platform_name == "Darwin"):
         base = os.path.join("/", "media", "ram")  # OSX
      else:
         sys.write.stderr("Please add proper environment settings for this platform\n")
         return ["",""]
      base = os.path.join(base, "picdevices." + mplabxversion)  # all platforms
      sys.stdout.write("Base for all output: " + base + "\n")
      os.environ["PIC2JAL"] = base                 # set new destination path

   return [base, mplabxversion]                    # all done!


# === E N T R Y   P O I N T ===

if (__name__ == "__main__"):

   check_and_set_environment()

#
