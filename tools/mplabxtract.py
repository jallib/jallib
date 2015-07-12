#!/usr/bin/python
"""
# Extract .pic files of JALV2 supported PICs from MPLAB-X file crownking.edc.jar
# Resulting files will have all lowercase names.
"""

import os
import subprocess

# specify working environment
mplabxversion = "3.05"
edc = "crownking.edc.jar"
base = os.path.join("/", "home", "robh")
jar = os.path.join("/", "opt","microchip","mplabx","v"+mplabxversion,"mplab_ipe","lib",edc)
dst = os.path.join(base,"mplab-x_" + mplabxversion)

def extract(ddd, ppp):
   # ddd = subdirectory,  ppp = PIC name (start characters of name)
   inc = os.path.join("content", "edc", ddd, "pic" + ppp + "*.pic") 
   subprocess.call(["unzip", "-LL", "-o", "-q", jar, inc, "-d", dst], shell=False) 

print "Extracting selected .pic files from", edc, "of MPLAB-X version", mplabxversion 

if not os.path.exists(dst):
   os.mkdir(dst) 
   
# 12-bits
extract("16c5x", "10f")
extract("16c5x", "12f")
extract("16c5x", "16f")

# 14 bits
extract("16xxxx", "10f")
extract("16xxxx", "10lf")
extract("16xxxx", "12f")
extract("16xxxx", "12lf")
extract("16xxxx", "12hv")
extract("16xxxx", "16f")
extract("16xxxx", "16lf")
extract("16xxxx", "16hv")

# 16 bits
extract("18xxxx", "18f")
extract("18xxxx", "18lf")

