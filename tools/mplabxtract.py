#!/usr/bin/env python3
"""
Title: Collect .PIC files of JALV2 supported PICs
Author: Rob Hamerling, Copyright (c) 2014..2025, all rights reserved.
Adapted-by: Rob Jansen

This file is part of jallib  https://github.com/jallib/jallib
Released under the ZLIB license http://www.opensource.org/licenses/zlib-license.html

Description:
   Copy .PIC files of JALV2 supported PICs from MPLABX to working directory

Sources: N/A

Notes:
   - May need to be run with root or administrator privileges
   - MPLABX-IDE or IPE needs being installed
   - Path to your local MPLABX installation may have to be adapted
   - Modified for MPLABX 4.20 (changed directory structure using version numbering)

   Changes dd 2024-04-xx by RobH
   - .PIC xmp files are collected from MPLAX into directory 'mplabx'
     (not anymore in a subdirectories structure like MPLABX itself)
     (xmltree, pinmap_create and pic2jal scripts changed accordingly!)

"""

import os
import sys
import fnmatch
import shutil

# Check - environment - requirements for running this script.
if (sys.version_info < (3,5,0)):
    print("You need Python 3.5.0 or later to run this script!\n")
    exit(1)

if not ('PIC2JAL' in os.environ):
    print("Environment variable PIC2JAL for destination not set.")
    exit(1)

if not ('MPLABXVERSION' in os.environ):
    print("Environment variable MPLABXVERSION for MPLABX version not set.")
    exit(1)

if not ('MPLABXINSTALL' in os.environ):
    print("Environment variable MPLABXINSTALL for MPLABX installation not set.")
    exit(1)

# All OK, set variables.
mplabxversion = os.environ['MPLABXVERSION']
mplabinstall = os.environ['MPLABXINSTALL']
base = os.path.join(os.environ['PIC2JAL'] + "." + mplabxversion)  

# xml paths.
xml_pfx = os.path.join(mplabinstall, "v" + mplabxversion)
xml_prefix = os.path.join(xml_pfx, "packs", "Microchip")

# destination of extracted .pic files:
dst = os.path.join(base, "mplabx")              # destination of .pic xml files

# MPLABX subdirectories from which 8-bits .PIC files are collected
pic_select = ("PIC10-12Fxxx_DFP", "PIC12-16F1xxx_DFP",
              "PIC16F1xxxx_DFP", "PIC16Fxxx_DFP",
              "PIC18F-J_DFP", "PIC18F-K_DFP", "PIC18F-Q_DFP", "PIC18Fxxxx_DFP")

# Unsupported PICs (exceptions to the selection above!)
# RJ: PIC16F527 and PIC15F570 generate errors in the script. According to Rob Hamerling not supported by JAL compiler.
unsup  = ("PIC12F529T39A.PIC", "PIC12F529T48A.PIC",
          "PIC16HV540.PIC", "PIC16F527.PIC", "PIC16F570.PIC")


# ===  E N T R Y   P O I N T ===

if (__name__ == "__main__"):

   print("Copying .PIC files of JalV2 supported PICs from MPLABX V%s" % mplabxversion)

   if not os.path.exists(dst):                  # check existence
      os.makedirs(dst)                          # create destination directory

   for picdir in pic_select:                    # all directories with .PIC files
      picvers = os.path.join(xml_prefix, picdir) # path to version directories
      picpath = os.path.join(picvers, "__version__", "edc")  # default path (< 4.20)
      # There may be more versions in the directory, we need to pick the highest version.
      subdirs = sorted(list(os.listdir(picvers)))
      subdir = subdirs[-1] # Last item from the list is the highest version.
      if os.path.isdir(os.path.join(picvers, subdir)):  # must be a directory
         if "edc" in os.listdir(os.path.join(picvers, subdir)):  # contains edc directory
            picpath = os.path.join(picvers, subdir, "edc")  # path to MCU collection
      print("Processing", picpath)              # progress signal
      piclist = [x for x in os.listdir(picpath) if fnmatch.fnmatch(x, "PIC1*.PIC")]
      for pic in piclist:                       # all of these
         if pic not in unsup:                   # skip when usupported by JalV2
             shutil.copy2(os.path.join(picpath,pic), dst)             # copy .PIC file

   print("Done!\n")
