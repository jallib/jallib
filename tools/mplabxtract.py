#!/usr/bin/env python3
"""
Title: Collect .PIC files of JALV2 supported PICs

Author: Rob Hamerling, Copyright (c) 2014..2018, all rights reserved.

Adapted-by:

Revision: $Revision$

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the BSD license https://www.opensource.org/licenses/bsd-license.php

Description:
   Copy .PIC files of JALV2 supported PICs from MPLABX to working directory

Sources: N/A

Notes:
   - May need to be run with root or administrator privileges
   - MPLABX-IDE needs be installed.

"""

from pic2jal_environment import check_and_set_environment
base, mplabxversion = check_and_set_environment()    # obtain environment variables
if (base == ""):
   exit(1)

import os
import sys
import glob
# import zipfile
import platform
import shutil

platform_name = platform.system()

# platform specific path prefix (Linux, Windows, OSX (Darwin))
if (platform_name == "Linux"):
   xml_pfx = os.path.join("/", "opt", "microchip", "mplabx", "v" + mplabxversion)
elif (platform_name == "Windows"):
 #  xml_pfx = os.path.join("C:\\", "Program Files (x86)", "microchip", "mplabx", "v" + mplabxversion)
   xml_pfx = os.path.join("D:\\", "picscripts", "mplabx_v" + mplabxversion)
elif (platform_name == "Darwin"):
   xml_pfx = os.path.join("/", "Applications", "microchip", "mplabx", "v" + mplabxversion)
else:
   sys.stderr.write("Please add proper environment settings for this platform\n")
   exit(1)
   
# Complete prefixes and suffixes
#xml_prefix = os.path.join(xml_pfx, "packs", "Microchip")
xml_prefix = os.path.join(xml_pfx, "Microchip")
xml_suffix = os.path.join("__version__", "edc")

# destination of extracted .pic files:
dst = os.path.join(base, "mplabx." + mplabxversion, "content", "edc")   # destination of .pic xml files

# Selection of directories of .PIC files to be collected from MPLABX
pic_select = {
   # appropriate input and corresponding output directories
   "PIC10-12Fxxx_DFP"   : "16c5x",              # was 12-bits only, now mixed 12/14
   "PIC12-16F1xxx_DFP"  : "16xxxx",             # mixed 12/14 bits
   "PIC16F1xxxx_DFP"    : "16xxxx",             
   "PIC16Fxxx_DFP"      : "16xxxx",             # mixed 12/14 bits
   "PIC18F-J_DFP"       : "18xxxx",
   "PIC18F-K_DFP"       : "18xxxx",   
   "PIC18F-Q_DFP"       : "18xxxx",
   "PIC18Fxxxx_DFP"     : "18xxxx"
   }

# Unsupported PICs (exceptions to the selection above!)

unsup  = ("PIC12F529T39A.PIC", "PIC12F529T48A.PIC",
          "PIC16HV540.PIC", "PIC16F527.PIC", "PIC16F570.PIC")


# ===  E N T R Y   P O I N T ===

if (__name__ == "__main__"):

   print("Copying .PIC files of JalV2 supported PICs from MPLABX V%s" % mplabxversion)

   if not os.path.exists(dst):                  # check existence
      os.makedirs(dst)                          # create destination directory

   for picdir in pic_select.keys():             # all directories with PIC files 
      picpath = os.path.join(xml_prefix, picdir, xml_suffix) # build path of dir with .PIC files      
      os.chdir(picpath)                         # make it current working directory
      filelist = glob.glob("PIC1*.PIC")         # make list of selected .PIC files
      for f in filelist:                        # all of these
         if (f not in unsup):                   # when supported by JalV2 
            with open(f, "r") as fp:
               ln = fp.readline()                # first line
               arch_offset = ln.index("edc:arch=")    # search core
               if (arch_offset > 0):             
                  arch = ln[arch_offset + 10 : arch_offset + 13].lower()  # leading 3 chars
                  if (arch == "16c"):   
                     subdir = "16c5x"
                  elif ((arch == "16x") | (arch == "16e")):
                     subdir = "16xxxx"
                  elif (arch == "18x"):
                     subdir = "18xxxx"
                  else:
                     sys.stderr.write("WNG! %s: Unrecognised core specification: %s\n" % (f, arch))
                     subdir = pic_select[picdir]   # take most likely
               else: 
                   sys.stderr.write("%s: No core specification found\n" % f)
                   continue   
               picdst = os.path.join(dst, subdir)  # destination directory
               if not os.path.exists(picdst):      # check for existence
                  os.makedirs(picdst)   
               shutil.copy2(f, picdst)             # copy .PIC file

   print("Done!\n")

