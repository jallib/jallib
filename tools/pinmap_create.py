
#  pinmap_create.py - create new pinmap from MPLAB-X

import os
import sys
import fnmatch
import re
from xml.dom.minidom import parse, Node

"""
  -----------------------------------------------------------------------
  This script is part of a sub-project using MPLAB-X info for Jallib,
  in particular the device files, but also for some other libraries.
  This script uses the .edc files created by the pic2edc script.
  The Pin section of these files contains the pin aliases.
  Some manipulations are performed, for example:
   - skip pins which are not accessible from the program like Vpp, Vdd
   - skip non-aliases of a pin like IOC, INT
   - correct apparent errors or omissions of MPLAB-X
   - determine the base name of pins and specify 'm as first alias
  When pins are not in .edc file or known to be incorrect
  the entry in the old pinmap file will be copied (when present).
  Same when the .edc file does not contain a Pin section at all,
  otherwise the pinmap will not contain an entry for this PIC.
  This script handles issues for a MPLAB-X version 1.95,
  for other MPLAB-X versions it may need to be adapted.
  -----------------------------------------------------------------------
"""

mplabxversion = "195"

edcdir    = "k:/jal/pic2jal/edc_" + mplabxversion           # dir with .edc files
pinmapnew = "pinmapnew.py"                                  # output

portpin = re.compile(r"^R[A-L]{1}[0-7]{1}\Z")               # Rx0..7 (x in range A..L)
gpiopin = re.compile(r"^GP[0-5]{1}\Z")                      # GP0..5

dir = fnmatch.filter(os.listdir(edcdir), "*.edc")           # get list of .edc files
if len(dir) == 0:
   print "No .edc files found in directory", edcdir
   sys.exit(1)

print "Building new pinmap from .edc files in", edcdir, "for (max)", len(dir), "PICs"

try:
   fp = open(pinmapnew, "w")
except IOError:
   print "Could not create output file", pinmapnew
   sys.exit(1)


def list_pic(_pic, _alias):
# list all pins and their aliases of a single _pic in dictionary _alias
   header = '   "' + _pic + '": {'                          # start of pinmap this PIC
   fp.write(header)
   pinlist_sorted = list(_alias.keys())
   pinlist_sorted.sort()
   for pin in pinlist_sorted:                               # one line per pin
      fp.write('"' + pin + '" : ["' + '", "'.join(_alias[pin]) + '"],\n' + " "*len(header))
   fp.write("},\n")                                         # end of pinmap this PIC


from pinmap import pinmap                                   # current ('old') pinmap

dir.sort()                                                  # alphanumeric sequence
piccount = 0
fp.write("pinmap = {\n")                                    # pinmap header

for filename in dir:
   picname = os.path.splitext(filename)[0][0:].upper()      # determine PIC from filename
   print picname

   if picname == "16F722":
      filename = "16lf722.edc"                              # replace by alternative input
      print "  Pinmap derived from 16lf722"

   filepath = os.path.join(edcdir,filename)                 # pathspec
   dom = parse(filepath)                                    # load .edc file

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
         if alias not in ("INT", "IOC"):                    # only 'real' alias names
            if alias.startswith("RB")  & picname.startswith("12"):   # Jallib requirement
               aliaslist.append("RA" + alias[-1])           # RBx -> RAx
               aliaslist.append("GP" + alias[-1])           # add GPx
               print "  Renamed pin", alias, "to RA" + alias[-1]
            elif alias == "RC7AN9":                         # MPLAB-X error
               aliaslist.append("RC7")
               aliaslist.append("AN9")
               print "  Splitted RC7AN9 into RC7 and AN9 for pin", pinnumber
            elif ( (picname in ("18F2439", "18F2539", "18F4439", "18F4539")) &
                   (alias.startswith("PWM")) ):
               aliaslist.append(alias)
               aliaslist.append("RC" + alias[-1])           # MPLAB-X omission
               print "  Added RC" + alias[-1], "( pin", pinnumber, ")"
            else:
               aliaslist.append(alias)                      # normal alias!

      if (picname in ("18F4220", "18F4320")) & (pinnumber == 36):  # MPLAB-X omission
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
         elif re.match(gpiopin,alias):                      # check gor GPx
            portbit = "RA" + alias[-1]                      # note: RAx not in aliaslist!
            break
      if portbit != None:                                   # found Rxy or GPx
         if portbit in pinlist:
            print "  Duplicate pin specification:", portbit, "pin", pinnumber, "skipped"
         else:
            pinlist[portbit] = aliaslist                    # add aliaslist this pin

   if picname in ("16F1704", "16LF1704"):
      for pin in ("RB4", "RB5", "RB6", "RB7", "RC6", "RC7"):
         if pinlist.get(pin) == None:                       # MPLAB-X omission
            if pinmap[picname].get(pin) != None:            # pin present in old pinmap
               pinlist[pin] = pinmap[picname].get(pin)      # take it from old pinmap
               print "  Copied alias list of pin", pin, "from old pinmap"
            else:
               pinlist[pin] = [pin]                         # insert dummy
               print "  Inserted dummy alias list for pin", pin
   elif picname in ("16LF1833",):
      for pin in ("RC4",):                                  # MPLAB-X error
         print "  Replacing alias list for pin", pin
         if pinmap[picname].get(pin) != None:               # present in old pinmap
            pinlist[pin] = pinmap[picname].get(pin, [pin])  # replace unconditionally
            print "  Copied alias list of pin", pin, "from old pinmap"
         else:
            pinlist[pin] = [pin]                            # insert dummy
            print "  Inserted dummy alias list for pin", pin

   if len(pinlist) > 0:
      list_pic(picname, pinlist)                            # list pinmap this pic
      piccount += 1
   elif pinmap.get(picname) != None:                        # present in old list
      list_pic(picname, pinmap[picname])                    # copy old mapping
      piccount += 1
      print "  No pinlist in .edc file, entry copied from current pinmap"
   else:
      print "  No pinlist, add it manually!"

fp.write("  }\n")                                           # end of pinmap
fp.close()

print "Generated pinmap", pinmapnew, "for", piccount, "PICs"
print "Compare new with current, when OK replace pinmap.py by", pinmapnew


