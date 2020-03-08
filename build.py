"""
Title: Generate a new build using Travis CI

Author: Rob Jansen, Copyright (c) 2020..2020, all rights reserved.

Adapted-by: 

Revision: $Revision$

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the BSD license https://www.opensource.org/licenses/bsd-license.php

Description:
   Create a new build by validating and compiling all samples mentioned in TORELASE.
   A build is started after each commit.

Sources: 

Notes:

"""
import sys
import os
import subprocess
import shutil
import json
import platform

# Global data
validator        = os.path.join("tools","jallib3.py")
compiler         = os.path.join("compiler","jalv2")
dir_device       = os.path.join("include","device")
dir_jal          = os.path.join("include","jal")
dir_external     = os.path.join("include","external")
dir_filesystem   = os.path.join("include","filesystem")
dir_networking   = os.path.join("include","networking")
dir_peripheral   = os.path.join("include","peripheral")
dir_protocol     = os.path.join("include","protocol")
dir_samples      = os.path.join("sample")
compiler_include = "include\jal;include\device;include\external;include\filesystem;include\networking;include\peripheral;include\protocol"
python_exe       = "python"
torelease        = "TORELEASE"
in_release       = []          # contents of TORELEASE

# Read TORELEASE into a list of lines (comments removed) and get all JAL files.
def read_torelease():
   print("Reading", torelease, " ...")
   global in_release
   try:
      with open(torelease, "r") as ft:
         for ln in ft:
            ln = ln.strip()
            if (len(ln) > 0):
                if (ln[0] != "#"):  # blank comment lines
                    in_release.append(ln)
                    print(ln)
         print("Done!")
   except:
      print("Failed to open", torelease)
      sys.exit(1)


# Validate all jal files given in 'in_release'. This includes device files and sample files.
def validate_jalfile():
   print("Validating JAL files ...")
   global in_release
   for ln in in_release:
      # Only validate JAL files.
      position = ln.find(".jal")
      if position > 0:
         print("File", ln)
         cmdlist = [python_exe, validator, "validate", ln]
         try:
            subprocess.check_output(cmdlist, stderr=subprocess.STDOUT, universal_newlines=True, shell=False)
         except subprocess.CalledProcessError as e:
            print("Validation failed for:", ln)
            sys.exit(1)
   print("Done!")


# Compile sample files.
def compile_samples():
    print("Compiling sample files ...")
    global in_release
    for ln in in_release:
        # Only build sample files.
        position = ln.find("sample/")
        if position != -1:
           # Get the sample file and replace \ by /
           samplefile = os.path.join(dir_samples, ln[7:])
           print("File", samplefile)
           cmdlist = [compiler, "-no-asm", "-no-codfile", "-no-hex", samplefile, "-s", compiler_include]
           try:
               log = subprocess.check_output(cmdlist, stderr=subprocess.STDOUT, universal_newlines=True, shell=False)
               print(log)
           except subprocess.CalledProcessError as e:
               print("Compiling failed for:", samplefile)
               print(e.output)
               sys.exit(1)
    print("Done!")


# ----------------------------
# --- E N T R Y  P O I N T ---
# ----------------------------
if (__name__ == "__main__"):

   # Start process
   print("Starting the build")
   read_torelease()
   validate_jalfile()
   compile_samples()






