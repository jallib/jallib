
#  pinmap_create.py - create 'pinmap.py' from MPLAB-X

import os
import sys
import re                                                   # regular expressions

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
  Before running this script the following manual editing is required:
  - 18f14k50.edc - split line 2468 (pin 04) over 2 lines
  -----------------------------------------------------------------------
"""

mplabxversion = "185"
edcdir  = "k:/jal/pic2jal/edc." + mplabxversion             # dir with .edc files
pinmap  = "pinmap.py"                                       # output

portpin = re.compile(r"R[A-L]{1}[0-7]{1}\Z")                # Rx0..7 (x in range A..L)
gpiopin = re.compile(r"GP[0-5]{1}\Z")                       # GP0..5


def list_pin(alias_list):
   # from list of pin names build a string with 'R.x' and its aliases
   pin = "?"
   for alias in alias_list:
      if re.match(portpin, alias):                          # R.x
         pin = alias
         break
      elif re.match(gpiopin, alias):                        # GPx
         pin = 'RA' + alias[-1]                             # use pin name 'RAx'
         break
   if pin == "?":                                           # no R?x or GPx pin
      return ""                                             # no need for aliases
   return "'" + pin + "': ['" + "', '".join(alias_list) + "'],\n"   # format line


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

dir.sort()                                                  # alpha sequence preferred

PicCount = 0
for filename in dir:
   filepath = edcdir + "/" + filename
   if os.path.isfile(filepath) & filename.endswith(".edc"):    # use only .edc files
      picname = os.path.splitext(filename)[0][0:].upper()   # in uppercase

      if picname in ("16F753", "16HV753"):
         header = "   '" + picname + "': {"                 # start of pinmapping this PIC
         fp.write(header)
         fp.write(list_pin(["RA0", "AN0", "FVROUT", "DACOUT", "C1IN0+", "ICSPDAT"]) + " "*len(header))
         fp.write(list_pin(["RA1", "AN1", "VREF", "FVRIN", "C1IN0-", "C2IN0-", "ICSPCLK"]) + " "*len(header))
         fp.write(list_pin(["RA2", "AN2", "COG1FLT", "C1OUT", "T0CKI"]) + " "*len(header))
         fp.write(list_pin(["RA3", "T1G", "MCLR", "VPP"]) + " "*len(header))
         fp.write(list_pin(["RA4", "AN3", "T1G", "CLKOUT"]) + " "*len(header))
         fp.write(list_pin(["RA5", "T1CKI", "CLKIN"]) + " "*len(header))
         fp.write(list_pin(["RC0", "AN4", "OPA1IN+", "C2IN0+"]) + " "*len(header))
         fp.write(list_pin(["RC1", "AN5", "OPA1IN-", "C1IN1-", "C2IN1-"]) + " "*len(header))
         fp.write(list_pin(["RC2", "AN6", "OPA1OUT", "C1IN2-", "C2IN2-", "SLPCIN"]) + " "*len(header))
         fp.write(list_pin(["RC3", "AN7", "C1IN3-", "C2IN3-"]) + " "*len(header))
         fp.write(list_pin(["RC4", "COG1OUT1", "C2OUT"]) + " "*len(header))
         fp.write(list_pin(["RC5", "COG1OUT0", "CCP1"]) + " "*len(header))
         fp.write("},\n")
         PicCount += 1
         print "Replaced all pins of", picname
         continue                                           # done with this PIC

      fe = open(filepath, "r")                              # start reading the  .edc file
      pinnumber = "0"

      for ln in fe:                                         # search start of pinlist
         if ln.strip() == "<EDC:PINLIST>":                  # found!
            header = "   '" + picname + "': {"              # start of pinmapping this PIC
            fp.write(header)
            break;

      for ln in fe:
         wlist = ln.strip().split()
         if "<EDC:VIRTUALPIN" in wlist:
            if picname == "18F14K50":
               print "pin", pinnumber, "index:", wlist.index("<EDC:VIRTUALPIN")
         if wlist[0] == "<EDC:VIRTUALPIN":
            pinlist = wlist[1].split('"', 3)                # isolate pin name
            lpin = pinlist[1].strip('_')                    # remove underscores (error MPLAB-X)
            if lpin in ("AVDD", "AVSS", "VBAT", "VDD", "VDDCORE", "VSEL", "VSS", "VUSB", "NC"):
               alist = []                                   # whole pin can be ignored
            elif lpin not in ("INT", "IOC"):
               if lpin.startswith("RB")  & picname.startswith("12"):
                  alist.append("RA" + lpin[-1])             # RBx -> RAx
                  alist.append("GP" + lpin[-1])             # add GPx
               elif lpin == "RC7AN9":                       # MPLAB-X error with 16f1828/9
                  alist.append("RC7")
                  alist.append("AN9")
                  print "Splitted RC7AN9 for", picname, "pin", pinnumber
               elif (picname == "16F722") & (lpin == "VREF"):   # error with 16f722
                  alist.append(lpin)
                  alist.append("RA3")
                  print "Added RA3 for", picname, "pin", pinnumber
               elif ( (picname in ("18F2439", "18F2539", "18F4439", "18F4539")) &
                      (lpin.startswith("PWM")) ):
                  alist.append(lpin)
                  alist.append("RC" + lpin[-1])
                  print "Added RC" + lpin[-1], "for", picname, "pin", pinnumber
               elif (picname in ("18F4220", "18F4320")) & (pinnumber == "36"):
                  alist = ["RB3", "AN9", "CCP2"]            # replace whole pin 36
                  print "Replaced", picname, "whole pin", pinnumber
               elif ( (picname in ("18F86J11", "18F86J16", "18F87J11"))  &
                    (pinnumber == "55") & (lpin == "ECCP2") ):
                  alist.append(lpin)
                  alist.append("RB3")
                  print "Added RB3 for", picname, "pin", pinnumber
               else:
                  alist.append(lpin)                        # only 'real' pin names
         elif wlist[0] == "<EDC:PIN>":
            alist = []                                      # new list
         elif wlist[0].startswith("<!--"):                  # may contain pin number!
            wlist = ln.strip().replace("-", " ").split()
            if "PIN" in wlist:
               pinnumber = wlist[wlist.index("PIN") + 1]    # physical pin
            elif wlist[1].isdigit():
               pinnumber = wlist[1]                         # physical pin
         elif wlist[0] == "</EDC:PIN>":
            lp = list_pin(alist)                            # format the line
            if lp != "":
               fp.write(lp)
               fp.write(" "*len(header))                    # indent next line
         elif wlist[0] == "</EDC:PINLIST>":
            fp.write("},\n")
            PicCount += 1
            break                                           # pinlist completed
      fe.close()
      if header.find(picname) == -1:
         print 'No PinList found for', picname
fp.write('  }\n')
fp.close()
print "Generated", pinmap, "for", PicCount, "PICs"


