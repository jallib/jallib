#!/usr/bin/python

 # Author: Rob Hamerling, Copyright (c) 2009..2015. All rights reserved.

"""
   pinmap_create.py - create new pinmap.py (pinmapnew.py) from MPLAB-X.
   This script is part of a sub-project using MPLAB-X info for Jallib,
   in particular the generation of device files, but also for some
   other libraries. This script uses the .pic files of MPLAB-X.
   The Pin section of a .pic file contains the pin aliases.
   Some manipulation is performed, for example:
    - skip pins which are not accessible from the program like Vpp, Vdd
    - skip non-aliases of a pin, like IOCxx, INTxx
    - skip aliases which are not likely be used by Jal programs,
      like ICSPDAT/CLK, ICDDAT/CLK, MCLR
    - correct apparent errors or omissions of MPLAB-X
    - determine the base name of a pin and make it first in the list
   When pins are not in .pic file or known to be incorrect
   the entry in the old pinmap file will be copied (when present).
   Same when the .pic file does not contain a Pin section at all.
   When not present the pinmap must be created manually from the datasheet.
   This script handles issues with MPLAB-X (version see below).
   for newer MPLAB-X versions it will probably have to be adapted
   because of corrections made by Microchip or with new .pic files.
"""

import os
import sys
import fnmatch
import re
from xml.dom.minidom import parse, Node

mplabxversion = "300"                                       # latest version of MPLAB-X

picdir = os.path.join("/", "media", "NAS", "mplab-x_" + mplabxversion, "crownking.edc.jar", "content", "edc")   # place of .pic files

pinmapnew = "pinmapnew.py"                                  # output
try:
   fp = open(pinmapnew, "w")
except IOError:
   print "Could not create output file", pinmapnew
   sys.exit(1)
fp.write("pinmap = {\n")                                    # opening line

pic8flash  = re.compile(r"^1(0|2|6|8)(f|lf|hv).*")          # relevant PICs only
pic8excl   = ["12f529t39a", "12f529t48a", \
              "16hv540", "16f527", "16f570"]
portpin = re.compile(r"^R[A-L]{1}[0-7]{1}\Z")               # Rx0..7 (x in range A..L)
gpiopin = re.compile(r"^GP[0-5]{1}\Z")                      # GP0..5

def list_pic(_pic, _alias):
# list all pins and their aliases of a single _pic in dictionary _alias
   header = '   "' + _pic + '": {'                          # start of pinmap this PIC
   fp.write(header)

   pinlist_sorted = list(_alias.keys())
   pinlist_sorted.sort()
   for i in range(len(pinlist_sorted) - 1):                 # all but last
      pin = pinlist_sorted[i]
      fp.write('"' + pin + '" : ["' + '", "'.join(_alias[pin]) + '"],\n' + " "*len(header))
   pin = pinlist_sorted[-1]
   fp.write('"' + pin + '" : ["' + '", "'.join(_alias[pin]) + '"]\n' + " "*len(header))
   fp.write("},\n")                                         # end of pinmap this PIC


def process_pic(picname, filename):
#  process a specific PIC (expect picname in upper case)
   print picname                                            # progress signal

   filepath = os.path.join(root,filename)                   # pathspec
   dom = parse(filepath)                                    # load .pic file

   pinnumber = 0
   pinlist = {}                                             # new dictionary
   for pin in dom.getElementsByTagName("edc:Pin"):          # select pin nodes
      pinnumber = pinnumber + 1                             # calculated next pin, maybe
      for pinc in pin.childNodes:                           #   corrected by comment node
         if pinc.nodeType == pinc.COMMENT_NODE:
            wlist = pinc.nodeValue.split()
            if wlist[0].isdigit() == True:
               pinnumber = int(wlist[0])
            elif wlist[1].isdigit() == True:
               pinnumber = int(wlist[1])
      aliaslist = []                                        # new aliaslist this pin
      for vpin in pin.getElementsByTagName("edc:VirtualPin"):
         alias = vpin.getAttribute("edc:name").upper().strip("_")
         if (alias[0:3] not in ("INT", "IOC", "VPP", "ICD", "ICS")):  # excluded aliases
            if alias.startswith("RB") & picname.startswith("12"):     # Jallib requirement
               aliaslist.append("RA" + alias[-1])           # RBx -> RAx
               aliaslist.append("GP" + alias[-1])           # add GPx
               print "  Renamed pin", alias, "to RA" + alias[-1]
            elif alias in("RB1AN10", "RC7AN9"):             # MPLAB-X errors
               aliaslist.append(alias[0:3])
               aliaslist.append(alias[3:])
               print "  Splitted alias", alias, "into", alias[0:3], "and", alias[3:], "for pin", pinnumber
            elif (alias == "DAC1VREF+N"):                   # MPLAB-X error
               aliaslist.append("DAC1VREF+")
               print "  Replaced", alias, "by DAC1VREF+ for pin", pinnumber
            elif (alias.find("MCLR") >= 0):                 # anywhere in alias name
               pass                                         # suppress MCLR alias
            elif ( (picname in ("16F1707", "16LF1707")) &
                   (alias == "AN9") & (pinnumber == 8) ):
               aliaslist.append("AN8")
               print "  Replaced alias", alias, "by AN8 for pin", pinnumber
            elif ( (picname in ("18F2439", "18F2539", "18F4439", "18F4539")) &
                   (alias.startswith("PWM")) ):
               aliaslist.append(alias)
               if alias[-1] == "1":
                  aliaslist.append("RC2")                   # MPLAB-X omission
                  print "  Added RC2 to pin", pinnumber
               else:
                  aliaslist.append("RC1")
                  print "  Added RC1 to pin", pinnumber
            else:
               aliaslist.append(alias)                      # normal alias!

      if (picname in ("16LF1559")) & (pinnumber == 18):
         if not "AN1" in aliaslist:
            aliaslist.append("AN1")                         # missing in mplab-x 2.30
            print "  Added missing alias AN1 to pin", pinnumber
      elif (picname in ("16F1614", "16LF1614")) & (pinnumber == 3):
         if not "AN3" in aliaslist:
            aliaslist.append("AN3")                         # missing in mplab-x 2.30
            print "  Added missing alias AN3 to pin", pinnumber
      elif (picname in ("16F1618", "16LF1618", "16F1619", "16LF1619")) & (pinnumber == 19):
         if not "AN0" in aliaslist:
            aliaslist.append("AN0")                         # missing in mplab-x 2.30
            print "  Added missing alias AN0 to pin", pinnumber
      elif (picname in ("18F2331", "18F2431")) & (pinnumber == 26):
         aliaslist = ["RE3"] + aliaslist                    # missing pin name
         print "  Added RE3 to pin", pinnumber
      elif (picname in ("18F4220", "18F4320")) & (pinnumber == 36):
         aliaslist = pinmap[picname].get("RB3", ["RB3"])    # copy from old pinmap if present
         print "  Aliaslist of pin", pinnumber, "copied from old pinmap"
      elif (picname in ("18F86J11", "18F86J16", "18F87J11"))  & (pinnumber == 55):
         aliaslist = pinmap[picname].get("RB3", ["RB3"])    # copy from old pinmap if present
         print "  Aliaslist of pin", pinnumber, "copied from old pinmap"

      portbit = None
      for alias in aliaslist:
         if re.match(portpin,alias):                        # check for Rxy
            portbit = alias
            if portbit != aliaslist[0]:                     # not first in list
               aliaslist.remove(portbit)
               aliaslist = [portbit] + aliaslist            # shift to front
            break
         elif re.match(gpiopin,alias):                      # check for GPx
            portbit = "RA" + alias[-1]                      # note: RAx not in aliaslist!
            break
      if portbit != None:                                   # found Rxy or GPx
         if portbit in pinlist:
            print "  Duplicate pin specification:", portbit, "pin", pinnumber, "skipped"
         else:
            pinlist[portbit] = aliaslist                    # add aliaslist this pin

   if len(pinlist) > 0:
      list_pic(picname, pinlist)                            # list pinmap this pic
   elif pinmap.get(picname) != None:                        # present in old list
      list_pic(picname, pinmap[picname])                    # copy old mapping
      print "  Pinlist missing in .pic file, entry copied from current pinmap"
   else:
      print "  Pinlist missing, add it manually!"


# === mainline ===

if (__name__ == "__main__"):

   from pinmap import pinmap                                   # current ('old') pinmap

   print "Building new pinmap from .pic files in", picdir

   piccount = 0

   for (root, dirs, files) in os.walk(picdir):                 # whole tree (incl subdirs!)
      files.sort()                                             # for unsorted filesystems!
      for file in files:
         picname = os.path.splitext(file)[0][3:].lower()       # 1st selection: pic type
         if ((re.match(pic8flash, picname) != None) & (picname not in pic8excl)):   # Jallib selection!
            process_pic(picname.upper(), os.path.join(root,file))      # create device file from .pic file
            piccount = piccount + 1

   fp.write("  }\n")                                           # end of pinmap
   fp.close()

   print "Generated pinmap", pinmapnew, "for", piccount, "PICs"
   print "Compare new with current, when OK copy", pinmapnew, "to pinmap.py"


