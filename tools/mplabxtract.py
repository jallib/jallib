#!/usr/bin/env python3
"""
Title: Collect .PIC files of JALV2 supported PICs

Author: Rob Hamerling, Copyright (c) 2014..2018, all rights reserved.
        Rob Jansen,    Copyright (c) 2018..2024, all rights reserved.
		
Adapted-by: 

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the ZLIB license http://www.opensource.org/licenses/zlib-license.html

Description:
   Copy .PIC files of JALV2 supported PICs from MPLABX to working directory

Sources: N/A

Notes:
   - May need to be run with root or administrator privileges
   - MPLABX-IDE needs be installed
   - Change the path to your local MPLABX installation
   - Modified for MPLABX 4.20 (changed directory structure using version numbering)

"""

from pic2jal_environment import check_and_set_environment
base, mplabxversion = check_and_set_environment()    # obtain environment variables
if (base == ""):
   exit(1)

import os
import sys
import glob
import platform
import shutil

platform_name = platform.system()

# platform specific path prefix (Linux, Windows, OSX (Darwin))
if (platform_name == "Linux"):
   xml_pfx = os.path.join("/", "opt", "microchip", "mplabx", "v" + mplabxversion)
elif (platform_name == "Windows"):
   # When using the Windows MPLABX installation from the original location use this:
   xml_pfx = os.path.join("C:\\", "Program Files", "microchip", "mplabx", "v" + mplabxversion)
elif (platform_name == "Darwin"):
   xml_pfx = os.path.join("/", "Applications", "microchip", "mplabx", "v" + mplabxversion)
else:
   sys.stderr.write("Please add proper environment settings for this platform\n")
   exit(1)
   
# xml path prefixes
xml_prefix = os.path.join(xml_pfx, "packs", "Microchip")

# destination of extracted .pic files:
dst = os.path.join(base, "mplabx." + mplabxversion, "content", "edc")   # destination of .pic xml files

# Selection of directories of .PIC files to be collected from MPLABX
pic_select = {
   # appropriate input and corresponding output directories
   "PIC10-12Fxxx_DFP"   : "16c5x",              # was 12-bits only, now mixed 12/14
   "PIC12-16F1xxx_DFP"  : "16xxxx",             # mixed 12/14 bits
   "PIC16F1xxxx_DFP"    : "16xxxx",             # 14-bits
   "PIC16Fxxx_DFP"      : "16xxxx",             # mixed 12/14 bits
   "PIC18F-J_DFP"       : "18xxxx",             # )
   "PIC18F-K_DFP"       : "18xxxx",             # ) 16-bits
   "PIC18F-Q_DFP"       : "18xxxx",             # )
   "PIC18Fxxxx_DFP"     : "18xxxx"}             # )

# Unsupported PICs (exceptions to the selection above!)
# RJ: PIC16F527 and PIC15F570 generate errors in the script. According to Rob Hamerling not supported by JAL compiler.
unsup  = ("PIC12F529T39A.PIC", "PIC12F529T48A.PIC",
          "PIC16HV540.PIC", "PIC16F527.PIC", "PIC16F570.PIC")



# ===  E N T R Y   P O I N T ===

if (__name__ == "__main__"):

   print("Copying .PIC files of JalV2 supported PICs from MPLABX V%s" % mplabxversion)

   if not os.path.exists(dst):                  # check existence
      os.makedirs(dst)                          # create destination directory

   for picdir in pic_select.keys():             # all directories with PIC files 
      picvers = os.path.join(xml_prefix, picdir) # path to version directories
      picpath = os.path.join(picvers, "__version__", "edc")  # default path (< 4.20)
      # There may be more versions in the directory and we need to pick the highest version.
      files = list(os.listdir(picvers))
      files.sort()
      file = files[-1] # Last item from the list is the highest version.
      if os.path.isdir(os.path.join(picvers, file)):      # must be a directory
         if "edc" in os.listdir(os.path.join(picvers, file)):  # contains edc directory
            picpath = os.path.join(picvers, file, "edc")  # modified path
      print("Processing", picpath)               # progress signal
      os.chdir(picpath)                         # make it current working directory
      filelist = glob.glob("PIC1*.PIC")         # make list of selected .PIC files
      for f in filelist:                        # all of these
         if (f not in unsup):                   # when supported by JalV2 
            with open(f, "r") as fp:
               ln = fp.readline()                # first line
               # The 'edc:arch' can be on the first or on the second line of the XML file.
               if not "edc:arch=" in ln:
                  ln = fp.readline()  # Get second line
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

