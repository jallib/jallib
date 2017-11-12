#!/usr/bin/env python3
"""
Title: Create new pinmap.py from MPLABX.

Author: Rob Hamerling, Copyright (c) 2009..2017. All rights reserved.

Adapted-by:

Revision: $Revision$

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the BSD license https://www.opensource.org/licenses/bsd-license.php

Description:
   pinmap_create.py - create new pinmap.py from MPLABX.
   This script is part of a sub-project using MPLABX info for Jallib,
   in particular the generation of device files, but also for some
   other libraries. This script uses the .pic files of MPLABX.
   The Pin section of a .pic file contains the pin aliases.
   Some manipulation is performed, for example:
    - leave only Port pins (skip pins like VDD, VSS, etc)
    - skip aliases which are not likely be used by Jal programs,
      like: ICSPDAT, ICSPCLK, ICDDAT, ICDCLK, CLKI, CLKO, MCLR, etc.
    - skip non-aliases of a pin, like IOCxx, INTxx
    - correct apparent errors or omissions of MPLABX
   When pins are not in .pic file or known to be incorrect
   the entry in the old pinmap file will be copied (when present).
   Same when the .pic file does not contain a Pin section at all.
   When not present the pinmap must be created manually from the datasheet.
   This script handles issues with MPLABX (version see below).
   for newer MPLABX versions it will probably have to be adapted
   because of corrections made by Microchip or with new .pic files.

Sources: N/A

Notes: - Last checked for corrections/errors/omisions with MPLABX 4.05
         (but check may not be complete!).


"""

from pic2jal_environment import check_and_set_environment
base, mplabxversion = check_and_set_environment()           # obtain environment variables
if (base == ""):
   exit(1)

import os
import sys
import re
from xml.dom.minidom import parse, Node
import shutil

from pinmap import pinmap                                   # read current pinmap contents

fpinmapnew  = os.path.join(base, "pinmap.py")               # in destination directory
fpinaliases = os.path.join(base, "pinaliases.json")         #

picdir     = os.path.join(base, "mplabx." + mplabxversion, "content", "edc")   # place of .pic files

portpin    = re.compile(r"^R[A-L]{1}[0-7]{1}\Z")            # Rx0..7 (x in range A..L)
gpiopin    = re.compile(r"^GP[0-5]{1}\Z")                   # GP0..5


# aliases to be excluded when starting with one of the following strings:
pinexcl = ("AVDD", "AVSS", "D+", "D-", "VDD", "VPP", "VSS",
           "ICD", "ICSP", "PGC", "PGD", "INT", "IOC")

# ------------------------------
def list_pic(fp, pic, alias):
   """ list all pins and their aliases of a single pic in dictionary alias
   """
   def list_aliases(aliaslist):
      if (len(aliaslist) > 0):                              # at least 1 alias
         return ('\n          "' + pin + '" : ["' + '", "'.join(aliaslist) + '"]')
      else:
         return ('\n          "' + pin + '" : []')          # no aliases

   pins = sorted(list(alias.keys()))                        # sorted list
   pl = []
   for i in range(len(pins)):
      pin = pins[i]
      pl.append(list_aliases(alias[pin]))
   fp.write('   "' + pic + '": \n          {' + ', '.join(pl) + "\n          }")



# -------------------------------------
def create_pinmap_pic(picname, filepath):
   """ process a specific PIC (expect picname in upper case)
       Commented-out lines seem to be obsolete with MPLABX 4.01
       or may have been in error.
       These lines are preserved for later analysis
   """
   print(picname)                                           # progress signal

   dom = parse(filepath)                                    # load .pic file

   pinnumber = 0
   pinlist = {}                                             # new dictionary
   for pin in dom.getElementsByTagName("edc:Pin"):          # select pin nodes
      pinnumber = pinnumber + 1                             # calculated next pin
      for pinc in pin.childNodes:                           # possibly corrected by comment node
         if pinc.nodeType == pinc.COMMENT_NODE:
            wlist = pinc.nodeValue.split()
            if wlist[0].isdigit() == True:
               pinnumber = int(wlist[0])
            elif wlist[1].isdigit() == True:
               pinnumber = int(wlist[1])

      aliaslist = []                                        # new aliaslist this pin
      for vpin in pin.getElementsByTagName("edc:VirtualPin"):
         alias = vpin.getAttribute("edc:name").upper().strip("_").split()[0]  # first word
         if alias.startswith(pinexcl):                      # excluded aliases
            pass
         elif (alias.find("MCLR") >= 0):                    # MCLR anywhere in alias name
            pass
         elif (alias == "NC"):                              # Not Connected
            pass
         elif alias.startswith("RB") & picname.startswith("12"):   # 12F with PortB
            aliaslist.append("RA" + alias[-1])              # RBx -> RAx
            print("  Renamed pin", alias, "to RA" + alias[-1])
            aliaslist.append("GP" + alias[-1])              # add GPx
            print("  Added alias GP" + alias[-1])
#         elif alias in("RB1AN10", "RC7AN9"):                # MPLABX errors
#            aliaslist.append(alias[0:3])
#            aliaslist.append(alias[3:])
#            print("  Splitted alias", alias, "into", alias[0:3], "and", alias[3:], "for pin", pinnumber)
         elif (alias == "DAC1VREF+N"):                      # MPLABX typo(?)
            aliaslist.append("DAC1VREF+")
            print("  Replaced", alias, "by DAC1VREF+ for pin", pinnumber)
         elif ( (picname in ("16F1707", "16LF1707")) &
                (alias == "AN9") & (pinnumber == 8) ):
            aliaslist.append("AN8")
            print("  Replaced alias", alias, "by AN8 for pin", pinnumber)
         elif ( (picname in ("18F2439", "18F2539", "18F4439", "18F4539")) &
                (alias.startswith("PWM")) ):
            aliaslist.append(alias)
            if alias[-1] == "1":
               aliaslist.append("RC2")                      # MPLABX omission
               print("  Added RC2 to pin", pinnumber)
            else:
               aliaslist.append("RC1")
               print("  Added RC1 to pin", pinnumber)
         elif (not alias in aliaslist):                     # not a duplicate
            aliaslist.append(alias)                         # add normal alias!


      if (picname in ("16LF1559")) & (pinnumber == 18):
         if not "AN1" in aliaslist:
            aliaslist.append("AN1")                         # missing in MPLABx 2.30
            print("  Added missing alias AN1 to pin", pinnumber)
#     elif (picname in ("16F1618", "16LF1618", "16F1619", "16LF1619")) & (pinnumber == 19):
#        if not "AN0" in aliaslist:
#           aliaslist.append("AN0")                         # missing in MPLABx 2.30
#           print("  Added missing alias AN0 to pin", pinnumber)
      elif (picname.startswith(("16F1919", "16LF1919")) &
           ("RF2" in aliaslist) & ("ANF1" in aliaslist) ) :
         aliaslist.remove("ANF1")
         aliaslist.append("ANF2")
         print("  Replaced alias ANF1 by ANF2 for pin", pinnumber)
#     elif (picname in ("18F2331", "18F2431")) & (pinnumber == 26):
#        aliaslist = ["RE3"] + aliaslist                   # missing pin name
#        print("  Added RE3 to pin", pinnumber)
#     elif (picname in ("18F4220", "18F4320")) & (pinnumber == 36):
#        aliaslist = pinmap[picname].get("RB3", ["RB3"])    # copy from old pinmap if present
#        print("  Aliaslist of pin", pinnumber, "copied from old pinmap")
#     elif (picname in ("18F86J11", "18F86J16", "18F87J11"))  & (pinnumber == 55):
#        aliaslist = pinmap[picname].get("RB3", ["RB3"])    # copy from old pinmap if present
#        print("  Aliaslist of pin", pinnumber, "copied from old pinmap")

      portbit = None
      for alias in aliaslist:
         if re.match(portpin,alias):                        # check for Rxy
            portbit = alias
            if portbit != aliaslist[0]:                     # not first in list
               aliaslist.remove(portbit)                    # remove it
               aliaslist.insert(0, portbit)                 # insert at front
            break
         elif re.match(gpiopin,alias):                      # not Rxy, try GPx
            portbit = "RA" + alias[-1]                      # note: RAx not in aliaslist!
            break

      if portbit != None:                                   # found Rxy or GPx
         if portbit in pinlist:
            print("  Duplicate pin specification:", portbit, "pin", pinnumber, "skipped")
         else:
            pinlist[portbit] = aliaslist                    # add aliaslist this pin

   if len(pinlist) > 0:                                     # not empty
      return pinlist                                        # new mapping
   elif pinmap.get(picname) != None:                        # present in old list
     print("  Pinlist missing in .pic file, entry copied from current pinmap")
     return pinmap[picname]                                 # old mapping
   else:
     print("  Pinlist missing, add it manually!")
     return {}


# ---------------------
def build_pinmap():
   """ Create new pinmap.py, possibly used by other Jallib libaries
   """
   piccount = 0
   pinmap = {}                                                 # new dictionary
   for (root, dirs, files) in os.walk(picdir):                 # whole tree (incl subdirs!)
      dirs.sort()
      files.sort()                                             # for unsorted filesystems!
      for file in files:
         picname = os.path.splitext(file)[0][3:].upper()       # picname in upper case
         pinmap[picname] = create_pinmap_pic(picname.upper(), os.path.join(root,file))
         piccount = piccount + 1

   piclist = sorted(list(pinmap.keys()))                       # get list of keys
   try:
      with open(fpinmapnew, "w") as fp:
         fp.write("pinmap = {\n")
         for i in range(len(piclist) - 1):                     # all but last
            list_pic(fp, piclist[i], pinmap[piclist[i]])
            fp.write(",\n")
         list_pic(fp, piclist[-1], pinmap[piclist[-1]])        # last
         fp.write("\n}\n")
   except IOError:
      print("   Failed to write:", fpinaliases)


   return piccount


# ---------------------
def build_pinaliases():
   """ Create new pinaliases.json for device files
       No duplicate aliases! Suffix added when multiple pins
       have the same alias (in case of PICs with APFCON or PPS)
   """
   import imp
   newpinfile = imp.load_source('pinmap', fpinmapnew)
   pinmap = newpinfile.pinmap                                   # import newly created pinmap.py
   print("PICs in pinmap", len(pinmap.items()))
   for pic,picpin in pinmap.items():
      pinaliases = {}
      for pin,aliases in picpin.items():
         newpins = []
         for alias in aliases:
            if alias != pin:
               if alias.endswith("-"):                         # ending
                  alias = alias[:-1] + "_NEG"                  #  -  -->  _NEG
               elif alias.endswith("+"):                       #
                  alias = alias[:-1] + "_POS"                  #  +  -->  _POS
               alias = alias.replace("+", "_POS_")             #
               alias = alias.replace("-", "_NEG_")             #  embedded
               newpins.append(alias)
               pinaliases.setdefault(alias,[]).append(pin)
         picpin[pin] = newpins
      for alias,pins in pinaliases.items():
         if len(pins) > 1:                                     # duplicates
            for pin in pins:
               picpin[pin][picpin[pin].index(alias)] += "_%s" % pin

   # print aliasfile in a more compact format than with json.dump()
   piclist = sorted(list(pinmap.keys()))                         # get list of keys
   try:
      with open(fpinaliases, "w") as fp:
         fp.write("{\n")
         for i in range(len(piclist) - 1):                        # all but last
            list_pic(fp, piclist[i], pinmap[piclist[i]])
            fp.write(",\n")
         list_pic(fp, piclist[-1], pinmap[piclist[-1]])           # last
         fp.write("\n}\n")
   except IOError:
      print("   Failed to write:", fpinaliases)



# ================ mainline =======================

if (__name__ == "__main__"):

   print("Building new pinmap from .pic files in", picdir)
   piccount = build_pinmap()
   if (piccount <= 0):
      print("Could not create new pinmap file", fpinmapnew)
      exit(1)
   print("Generated pinmap", fpinmapnew, "for", piccount, "PICs")

   print("Building new pin aliases file:", fpinaliases)
   build_pinaliases()




