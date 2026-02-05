#!/usr/bin/env python3
"""
Title: Check if requirements for pic2jal scripts are satisfied 
Author: Rob Hamerling, Copyright (c) 2017..2025. All rights reserved.
Adapted-by: Rob Jansen

This file is part of jallib  https://github.com/jallib/jallib
Released under the ZLIB license http://www.opensource.org/licenses/zlib-license.html

Description:
   Check if requirements for pic2jal scripts are satisfied and define
   default environment variables that are needed by the various scripts
   (not all are always needed by all scripts):
   - Python version: at least Python 3.5
   - Set defaults for environment variables:
     - PIC2JAL        - path of destination directory
     - MPLABXINSTALL  - installation of MPLABX
     - MPLABXVERSION  - version number of MPLABX, e.g.: 6.25
     - JALLIB         - path of local Github
     - JALCOMPILER    - name of JAL compiler
     - KDIFF3         - installation of kdiff3 (for compare scripts)

   If OK, returns the list with variables. Display an error or warning message
   when something is wrong or missing and then return list with empty strings.

Sources: N/A

Notes: - Use defaults in script or adapt script to actual situation
         before running any device files generation script!
       - Allthough this script sets the environment variables these are
         only 'active' for the current process and subprocesses.
       - The following paltform names are serviced:
         "Linux", "Windows" and "Darwin".
"""

import sys
import os
import platform

platform_name = platform.system()

def check_and_set_environment():

   if (sys.version_info < (3,5,0)):
      sys.stderr.write("You need Python 3.5.0 or later to run this script!\n")
      return ["","","","","",""]

   # Version of MPLABX, to be changed with each new MPLABX version.
   try:
      mplabxversion = os.environ["MPLABXVERSION"]  
   except:                                        
      # Local settings.                               
      mplabxversion = "6.25"
   sys.stdout.write("MPLABX version: " + mplabxversion + "\n")
   os.environ["MPLABXVERSION"] = mplabxversion

   # Path to destination directory.
   try:
      base = os.environ["PIC2JAL"]                 
   except: 
      # Local settings, platform dependent.                               
      if (platform_name == "Linux"):
         base = os.path.join("/", "mnt", "data")  
      elif (platform_name == "Windows"):
        base = os.path.join("D:\\")               
      elif (platform_name == "Darwin"):
         base = os.path.join("/", "mnt", "data")  
      else:
         sys.write.stderr("Please add proper environment setting for the destination directory.\n")
         return ["","","","","",""]
      base = os.path.join(base, "picdevices." + mplabxversion) 
   sys.stdout.write("Base for all output: " + base + "\n")
   os.environ["PIC2JAL"] = base                

   # Location of MPLABX installation.
   try:
      mplabxinstall = os.environ["MPLABXINSTALL"]      
   except:                                         
       # Local settings, platform dependent.                               
      if (platform_name == "Linux"):
         mplabxinstall = os.path.join("/", "opt", "microchip", "mplabx") 
      elif (platform_name == "Windows"):
         mplabxinstall = os.path.join("C:\\", "Program Files", "microchip", "mplabx")               
      elif (platform_name == "Darwin"):
         mplabxinstall = os.path.join("/", "opt", "microchip", "mplabx")  
      else:
         sys.write.stderr("Please add proper environment settings for MPLABX installlation.\n")
         return ["","","","","",""]
   sys.stdout.write("MPLABX installation location: " + mplabxinstall + "\n")
   os.environ["MPLABXINSTALL"] = mplabxinstall            

   # Path to local Github.
   try:
      jallib = os.environ["JALLIB"]
   except:                                       
      # Local settings, platform dependent.                               
      if (platform_name == "Linux"):
         jallib = os.path.join("/", "mnt", "data", "GitHub", "jallib")  
      elif (platform_name == "Windows"):
        jallib = os.path.join("D:\\", "GitHub", "jallib")       
      elif (platform_name == "Darwin"):
         jallib = os.path.join("/", "mnt", "data", "GitHub", "jallib")  
      else:
         sys.write.stderr("Please add proper environment settings for your local GitHub.\n")
         return ["","","","","",""]
   sys.stdout.write("Local GitHub location: " + jallib + "\n")
   os.environ["JALLIB"] = jallib         

   # Name of JAL compiler.
   try:
      compiler = os.environ["JALCOMPILER"]         
   except:                                        
       # Local settings, platform dependent.                               
      if (platform_name == "Linux"):
         compiler = "jalv2-x86-64"  
      elif (platform_name == "Windows"):
         compiler = "jalv2_64.exe"  
      elif (platform_name == "Darwin"):
         compiler = "jalv2osx"  
      else:
         sys.write.stderr("Please add proper environment settings for your local JAL comiler.\n")
         return ["","","","","",""]
   compiler = os.path.join(os.getcwd() , compiler) 
   sys.stdout.write("JAL compiler: " + compiler + "\n")
   os.environ["JALCOMPILER"] = compiler              

   # Path to kdiff3.
   try:
      kdiff3 = os.environ["KDIFF3"]
   except:                                       
      # Local settings, platform dependent.                               
      if (platform_name == "Linux"):
         kdiff3 = os.path.join("/", "usr", "bin", "kdiff3")  
      elif (platform_name == "Windows"):
         kdiff3 = os.path.join("C:\\", "Program Files", "Kdiff3", "kdiff3.exe")               
      elif (platform_name == "Darwin"):
         kdiff3 = os.path.join("/", "usr", "bin", "kdiff3")  
      else:
         sys.write.stderr("Please add proper environment settings for kfiff3 installation.\n")
         return ["","","","","",""]
   sys.stdout.write("Local kdiff3 installation: " + kdiff3 + "\n")
   os.environ["KDIFF3"] = kdiff3         

   return [base, mplabxinstall, mplabxversion, jallib, compiler, kdiff3]          


# === E N T R Y   P O I N T ===

if (__name__ == "__main__"):

   check_and_set_environment()

#
