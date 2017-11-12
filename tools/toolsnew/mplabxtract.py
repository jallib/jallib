#!/usr/bin/env python3
"""
Title: Extract .pic files of JALV2 supported PICs

Author: Rob Hamerling, Copyright (c) 2014..2017, all rights reserved.

Adapted-by:

Revision: $Revision$

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the BSD license https://www.opensource.org/licenses/bsd-license.php

Description:
   Extract .PIC files of JALV2 supported PICs from MPLAB-X file crownking.edc.jar

Sources: N/A

Notes:
   - May need to be run with root or administrator privileges
   - Either MPLABX-IPE or MPLABX-IDE needs be installed.

"""

from pic2jal_environment import check_and_set_environment
base, mplabxversion = check_and_set_environment()    # obtain environment variables
if (base == ""):
   exit(1)

import os
import sys
import zipfile
import platform

# begin part of platform specific paths (Linux, Windows, OSX (Darwin))
# _ipe_ stands for MPLABX-IPE, _ide_ stands for MPLABX_IDE, _com_ stands for either or both
jar_com_pfx_linux   = os.path.join("/", "opt", "microchip", "mplabx", "v" + mplabxversion)
jar_com_pfx_windows = os.path.join("C:\\", "Program Files (x86)", "microchip", "mplabx", "v" + mplabxversion)
jar_com_pfx_darwin  = os.path.join("/", "Applications", "microchip", "mplabx", "v" + mplabxversion)

# last part of platform specific paths
jar_com_sfx_linux   = os.path.join("lib", "crownking.edc.jar")
jar_com_sfx_windows = os.path.join("lib", "crownking.edc.jar")
jar_ipe_sfx_darwin  = os.path.join("Contents", "Resources", "mplab_ide", "mplablibs", "modules", "ext", "crownking.edc.jar")
jar_ide_sfx_darwin  = os.path.join("Contents", "Java", "lib", "crownking.edc.jar")

platform_name = platform.system()

# platform specific path of 'crownking.edc.jar
if (platform_name == "Linux"):
   jar = os.path.join(jar_com_pfx_linux, "mplab_ipe", jar_com_sfx_linux)
   if not os.path.exists(jar):
      jar = os.path.join(jar_com_pfx_linux, "mplab_ide", jar_com_sfx_linux)
elif (platform_name == "Windows"):
   jar = os.path.join(jar_com_pfx_windows, "mplab_ipe", jar_com_sfx_windows)
   if not os.path.exists(jar):
      jar = os.path.join(jar_com_pfx_windows, "mplab_ide", jar_com_sfx_windows)
elif (platform_name == "Darwin"):
   jar = os.path.join(jar_com_pfx_darwin, "mplab_ipe.app", jar_ipe_sfx_darwin)
   if not os.path.exists(jar):
      jar = os.path.join(jar_com_pfx_darwin, "mplab_ide.app", jar_ide_sfx_darwin)
else:
   print("Please add platform specific settings for this type of system")
   exit(1)

if not os.path.exists(jar):
   print("Could not locate the required MPLABX file 'crownking.edc.jar'")
   exit(1)

# destination of extracted .pic files:
dst = os.path.join(base, "mplabx." + mplabxversion)   # destination of .pic xml files

# Selection strings for .pic files to be collected from .jar archive
# Note: This is the name format used by Python zipfile module,
#       common for all platforms (thus not a os.path.join() object).

pic_select = (
   # 12 bits
   "content/edc/16c5x/PIC10F",
   "content/edc/16c5x/PIC12F",
   "content/edc/16c5x/PIC16F",
   "content/edc/16c5x/PIC16HV",
   # 14 bits
   "content/edc/16xxxx/PIC10F",
   "content/edc/16xxxx/PIC10LF",
   "content/edc/16xxxx/PIC12F",
   "content/edc/16xxxx/PIC12LF",
   "content/edc/16xxxx/PIC12HV",
   "content/edc/16xxxx/PIC16F",
   "content/edc/16xxxx/PIC16LF",
   "content/edc/16xxxx/PIC16HV",
   # 16 bits
   "content/edc/18xxxx/PIC18F",
   "content/edc/18xxxx/PIC18LF"
   )

# Unsupported PICs (exceptions to the selection above!)

unsup  = ("PIC12F529T39A.PIC", "PIC12F529T48A.PIC",
          "PIC16HV540.PIC", "PIC16F527.PIC", "PIC16F570.PIC")



# ===  E N T R Y   P O I N T ===

if (__name__ == "__main__"):

   print("Extracting .pic files of JalV2 supported PICs from:\n", jar)

   if not os.path.exists(dst):                  # check existence
      os.makedirs(dst)                          # create destination directory

   with zipfile.ZipFile(jar, "r") as zf:        # open .jar file
      for name in zf.namelist():                # all files
         if name.startswith(pic_select):        # selection candidate
            if (os.path.split(name)[1] not in unsup):   # check JalV2 supported
               zf.extract(name, path=dst)       # get it

   print("Done!\n")

