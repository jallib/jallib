#!/usr/bin/env python3
"""
Title: List all pins and their aliases of all (Jallib) PICs

Author: Rob Hamerling, Copyright (c) 2017..2017. All rights reserved.

Adapted-by:

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the ZLIB license http://www.opensource.org/licenses/zlib-license.html

Description:
   Simple list of all pins and their aliases.

Sources: N/A

Notes:

"""

# obtain environment variables
from pic2jal_environment import check_and_set_environment
base, mplabxinstall, mplabxversion, jallib, compiler, kdiff3 = check_and_set_environment()            
if (base == ""):
   exit(1)

import os
import sys
import re
from xml.dom.minidom import parse, Node

pinlist = os.path.join(base, "pinlist.txt")                 # destination
picdir  = os.path.join(base, "mplabx." + mplabxversion, "content", "edc")   # base of .pic files

portpin    = re.compile(r"^R[A-L]{1}[0-7]{1}\Z")            # Rx0..7 (x in range A..L)
gpiopin    = re.compile(r"^GP[0-5]{1}\Z")                   # GP0..5


# ------------------------------
def list_pic_pins(fp, pindict):
   """ list all pins and their aliases of a pic
   """
   pinlist = list(pindict.keys())
   pinlist.sort()                                           # pin number sequence
   for pin in pinlist:
      fp.write("   %3d" % (pin) + " : " + ", ".join(pindict[pin]) + "\n")
   fp.write("\n")


# -------------------------------------
def build_pin_dict(fp, filepath):
   """ build a dictionary with pins and their aliases for one pic
       and print the dictionary
   """

   dom = parse(filepath)                                    # load .pic file

   pinlist = {}                                             # new dictionary
   i = 1                                                    # pin number
   for pin in dom.getElementsByTagName("edc:Pin"):          # select pin nodes
      aliaslist = []                                        # new aliaslist this pin
      for vpin in pin.getElementsByTagName("edc:VirtualPin"):
         alias = vpin.getAttribute("edc:name")              # raw alias
         alias = alias.upper().strip("_").split()[0]        # first word
         aliaslist.append(alias)                            # add alias!

      pinlist[i] = aliaslist                                # add aliaslist this pin
      i += 1

      for alias in aliaslist:
         if (re.match(portpin, alias) or re.match(gpiopin, alias)):  # select Rxy or GPx
            portbit = alias
            if portbit != aliaslist[0]:                     # not first in list
               aliaslist.remove(portbit)                    # remove it
               aliaslist.insert(0, portbit)                 # add it to front
            break

   picname  = os.path.splitext(os.path.split(filepath)[1])[0][3:].upper()   # pic type
   print(picname)                                           # progress signal
   fp.write(picname + "\n")
   if len(pinlist) > 0:                                     # any pins in list
      list_pic_pins(fp, pinlist)                            # list pinmap this pic
   else:
      print("   No pinlist!")
      fp.write("   No pinlist\n")


# ---------------------
def build_pinlist():
   """ For all (previously selected) PICs in MPLABX build pin dictionary
   """

   with open(pinlist, "w") as fp:
      fp.write("List of pins and their aliases in MPLABX" + mplabxversion + "\n\n")                           # opening line
      for (root, dirs, files) in os.walk(picdir):        # whole tree (incl subdirs!)
         dirs.sort()
         files.sort()                                    # for unsorted filesystems!
         for file in files:
            build_pin_dict(fp, os.path.join(root,file))  # create pin dictionary
      fp.write("\n")



# ================ mainline =======================

if (__name__ == "__main__"):

   print("Building pinlist", picdir)
   build_pinlist()



