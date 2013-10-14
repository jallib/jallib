
#  pinmap_create.py - create 'pinmap.py' from MPLAB-X

import os
import sys
import re
from xml.dom.minidom import parse, Node

"""
  -----------------------------------------------------------------------
  This script is part of a sub-project using MPLAB-X info for Jallib,
  in particular the device files.
  This script uses the .edc files created by the pic2edc script.
  The PinList section of these files contains the pin aliases.
  Some manipulations are needed, for example skip pins which are not
  accessible from the program (like Vpp, Vdd, etc), finding the
  the base name of a pin and correcting some errors in MPLAB-X.
  The hard coded corrections are valid for a specific version of MPLAB-X,
  for other versions it may need modification.
  When no Pinlist found, pinmap.py will not contain an entry for this PIC
  -----------------------------------------------------------------------
"""

mplabxversion = "190"

edcdir  = "k:/jal/pic2jal/edc_" + mplabxversion             # dir with .edc files
pinmap  = "pinmap.py"                                       # output

portpin = re.compile(r"^R[A-L]{1}[0-7]{1}\Z")               # Rx0..7 (x in range A..L)
gpiopin = re.compile(r"^GP[0-5]{1}\Z")                      # GP0..5

dir = os.listdir(edcdir)
if len(dir) == 0:
   print "No files found in directory", edcdir
   sys.exit(1)

print "Building", pinmap, "from .edc files in", edcdir, "for (max)", len(dir), "PICs"

try:
   fp = open(pinmap, "w")
except IOError:
   print "Could not create output file", pinmap
   sys.exit(1)

fp.write("pinmap = {\n")                                    # file header

dir.sort()                                                  # alpha_numeric sequence
piccount = 0
for filename in dir:
   filepath = edcdir + "/" + filename
   if not os.path.isfile(filepath) & filename.endswith(".edc"):    # only .edc files apply
      continue

   picname = os.path.splitext(filename)[0][0:].upper()      # in uppercase
   print picname

   if picname == "16F722":
      filepath = edcdir + "/16lf722.edc"
      print "  Pinmap derived from 16lf722"

   dom = parse(filepath)
   pinnumber = "0"
   pinlist = {}
   for pin in dom.getElementsByTagName("edc:Pin"):
      pinnumber = "0"
      for pinc in pin.childNodes:
         if pinc.nodeType == pinc.COMMENT_NODE:
            wlist = pinc.nodeValue.split()
            if wlist[0].isdigit() == True:
               pinnumber = wlist[0]
            elif wlist[1].isdigit() == True:
               pinnumber = wlist[1]
      aliaslist = []
      for vpin in pin.getElementsByTagName("edc:VirtualPin"):
         alias = vpin.getAttribute("edc:name").upper().strip("_")
         if alias not in ("INT", "IOC"):                    # not a real alias
            if alias.startswith("RB")  & picname.startswith("12"):
               aliaslist.append("RA" + alias[-1])           # RBx -> RAx
               aliaslist.append("GP" + alias[-1])           # add GPx
            elif alias == "RC7AN9":                         # MPLAB-X error with 16f1828/9
               aliaslist.append("RC7")
               aliaslist.append("AN9")
               print "  Splitted RC7AN9 for pin", pinnumber
            elif ( (picname in ("18F2439", "18F2539", "18F4439", "18F4539")) &
                   (alias.startswith("PWM")) ):
               aliaslist.append(alias)
               aliaslist.append("RC" + alias[-1])
               print "  Added RC" + alias[-1], "for pin", pinnumber
            elif ( (picname in ("18F86J11", "18F86J16", "18F87J11"))  &
                 (pinnumber == "55") & (alias == "ECCP2") ):
               aliaslist.append(alias)
               aliaslist.append("RB3")
               print "  Added RB3 for pin", pinnumber
            else:
               aliaslist.append(alias)

      if (picname in ("18F4220", "18F4320")) & (pinnumber == "36"):
         aliaslist = ["RB3", "AN9", "CCP2"]
         print "  Replaced whole pin", pinnumber

      portbit = "?"
      for alias in aliaslist:
         if re.match(portpin,alias):
            portbit = alias
            break
         elif re.match(gpiopin,alias):
            portbit = "RA" + alias[-1]
            break
      if portbit != "?":
         if portbit in pinlist:                 # duplicate
            print "  Duplicate pin specification:", portbit, "pin", pinnumber, "skipped"
         else:
            pinlist[portbit] = aliaslist

   if len(pinlist) > 0:
      header = '   "' + picname + '": {'                    # start of pinmapping this PIC
      fp.write(header)
      pinlist_keysort = list(pinlist.keys())
      pinlist_keysort.sort()
      for key in pinlist_keysort:
         fp.write('"' + key + '" : ')
         fp.write('["' + '", "'.join(pinlist[key]) + '"],\n')
         fp.write(" "*len(header))
      fp.write("},\n")
      piccount += 1
   else:
      print "  No pinlist found"

fp.write("  }\n")
fp.close()
print "Generated", pinmap, "for", piccount, "PICs"


