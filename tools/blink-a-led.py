#!/usr/bin/python3
""" Create and compile blink-a-led samples.

  Author: Rob Hamerling, Copyright (c) 2008..2017, all rights reserved.

  Adapted-by:

  Revision: $Revision$

  Compiler: N/A

  This file is part of jallib  https://github.com/jallib/jallib
  Released under the BSD license
                 http://www.opensource.org/licenses/bsd-license.php

  Description: Python script to create blink-a-led samples
               for every available device file.
               - Validate the device file
               - Create a sample program
               - Validate the sample program
               - Compile the sample program
               - Check the compiler output for errors and warnings
               When all OK:
               - in PROD mode move the source of the sample to
                 the jalib sample directory
               - in TEST mode move the source to ./test

  Sources:

  Version: 0.1.1

  Notes:
   - A blink-a-led sample is generated for every device file:
     a HS sample if possible, otherwise an INTOSC sample.
   - For all PICs with USB support a sample is generated using HS_USB.
   - For both HS and HS_USB an INTOSC sample may be created when
     the PICname is in the corresponding table and the PIC supports
     INTOSC and INTOSC for USB!
   - With a second commandline argument the generation of samples can be
     limited to a subset: specify a PICname (with wildcard characters).
   - when a datasheet is renumbered (e.g. 41234 -> 40001234),
     the ircf dictionary must be modified accordingly.

"""

from pic2jal_environment import check_and_set_environment
base, mplabxversion = check_and_set_environment()    # obtain environment variables
if (base == ""):
   exit(1)

import sys
import os
import datetime
import time
import glob
import subprocess
import shutil
import platform

platform_name = platform.system()

# --- general constants

ScriptAuthor    = "Rob Hamerling"
CompilerVersion = "2.4q6"


# specification of system dependent compiler executable
if (platform_name == "Linux"):
   compiler = os.path.join(os.getcwd(), "jalv2-x86-64")
elif (platform_name == "Windows"):
   compiler = os.path.join(os.getcwd(), "jalv2.exe")
elif (platform_name == "Darwin"):
   compiler = os.path.join(os.getcwd(), "jalv2osx")
else:
   print("Please specify platform specific compiler to this script!")

devdir = os.path.join(base, "test")                      # device files
dstdir = os.path.join(base, "blink")                     # destination of samples
if (not os.path.exists(dstdir)):
   os.makedirs(dstdir)

# Name of python executable is required for calling the jallib script.
python_exec = "python3"                                  # assume python2 and python3 are installed
try:
   log = subprocess.check_output([python_exec, "--version"], shell=False)
except:
   python_exec = "python"                                # Python3 is probably default



# global dictionaries for PIC information, re-filled with every PIC
var = {}
fusedef = {}


# OSCCON_IRCF settings for 4 MHz INTOSC per datasheet number
ircf =   { 30221    : "--",
           30292    : "--",
           30325    : "--",
           30430    : "--",
           30445    : "--",
           30485    : "--",
           30487    : "110",
           30491    : "--",
           30498    : "110",
           30509    : "101",      # falls back on DS 39977
           30569    : "--",
           30575    : "--",       # special!
           30684    : "101",
           35007    : "--",
           39564    : "--",
           39582    : "--",
           39597    : "--",
           39598    : "110",
           39599    : "110",
           39605    : "110",
           39609    : "--",
           39612    : "--",
           39616    : "110",
           39625    : "110",
           39626    : "110",
           39629    : "110",
           39631    : "110",
           39632    : "110",
           39635    : "110",
           39636    : "110",
           39637    : "110",
           39646    : "110",
           39663    : "--",       # no 4 MHz
           39682    : "--",       # no 4 MHz
           39689    : "110",
           39755    : "110",      # falls back on DS 39631
           39758    : "110",
           39760    : "--",       # no 4 MHz
           39761    : "110",
           39762    : "--",       # no 4 MHz
           39770    : "110",
           39774    : "110",
           39775    : "110",
           39778    : "110",
           39887    : "110",      # falls back on DS 39632
           39894    : "110",      # falls back on DS 39646
           39896    : "110",      # falls back on DS 39629
           39931    : "110",
           39932    : "110",
           39933    : "110",
           39948    : "110",      # false back on DS 39933
           39957    : "101",
           39960    : "101",      # falls back on DS 39625
           39963    : "110",
           39964    : "110",
           39974    : "110",
           39977    : "101",
           39979    : "110",
           40039    : "--",
           40044    : "--",
           40197    : "--",
           40300    : "--",
           41159    : "--",
           41190    : "--",
           41202    : "110",
           41203    : "110",
           41206    : "--",
           41211    : "110",
           41213    : "--",
           41232    : "110",
           41236    : "--",
           41249    : "110",
           41250    : "110",
           41262    : "110",
           41268    : "--",       # IOSCFS = 0 for 4MHz
           41270    : "--",       # IOSCFS = 0 for 4MHz
           41288    : "--",       # IOSCFS = 0 for 4MHz
           41291    : "110",
           41302    : "--",       # IOSCFS = 0 for 4MHz
           41303    : "101",
           41319    : "--",       # IOSCFS = 0 for 4MHz
           41326    : "--",       # IOSCFS = 0 for 4MHz
           41350    : "101",
           41364    : "1101",
           41365    : "101",
           41391    : "1101",
           41414    : "1101",
           41417    : "01",       # PLLEN = 1
           41418    : "01",       # PLLEN = 1
           41455    : "1101",
           41458    : "1101",
           41569    : "1101",
           41575    : "1101",
           41580    : "101",      # falls back on DS 41365
           41607    : "1101",
           41624    : "1101",
           41634    : "--",       # IOSCFS = 0 for 4MHz
           41635    : "--",       # IOSCFS = 0 for 4MHz
           41636    : "1101",
           41637    : "1101",
           41657    : "1101",
           41673    : "1101",     # falls back on DS 41440
           41675    : "1101",
           30000684 : "101",
           40001239 : "--",
           40001341 : "01",       # PLLEN = 1
           40001412 : "101",
           40001413 : "1101",
           40001419 : "1101",
           40001430 : "01",       # PLLEN : 1
           40001440 : "1101",
           40001441 : "1101",
           40001452 : "1101",
           40001453 : "1101",
           40001455 : "1101",
           40001574 : "1101",
           40001569 : "1101",
           40001576 : "10",
           40001579 : "1101",
           40001585 : "101",
           40001586 : "1101",
           40001594 : "1101",
           40001607 : "1101",
           40001609 : "1101",
           40001615 : "1101",
           40001636 : "1101",
           40001637 : "1101",
           40001639 : "1101",
           40001652 : "--",      # IOSCFS : 0 for 4MHz
           40001674 : "1101",
           40001675 : "1101",
           40001684 : "--",      # IOSCFS : 0 for 4MHz
           40001709 : "10",
           40001715 : "1101",
           40001722 : "1101",
           40001723 : "1101",
           40001726 : "1101",
           40001729 : "1101",
           40001737 : "1101",
           40001740 : "1101",
           40001761 : "1101",
           40001769 : "1101",
           40001770 : "1101",
           40001775 : "1101",
           40001782 : "1101",
           40001810 : "1101",
           40001817 : "1101",
           40001819 : "1101"
           }


# List of PICs for which an extra INTOSC blink sample should
# be generated beyond the standard default HS or HS_USB variant.
# Note: An extra sample will only be generated if HS resp. HS_USB sample is OK
#       and the PIC supports INTOSC at 4 MHZ, resp. USB with INTOSC

# --- PICs for which a _BLINK_INTOSC sample is desired ---

extra_intosc  =    [ "12f1840"  ,
                     "12f635"   ,
                     "12f675"   ,
                     "12f683"   ,
                     "16f1459"  ,
                     "16f1516"  ,
                     "16f1574"  ,
                     "16f1575"  ,
                     "16f1615"  ,
                     "16f1765"  ,
                     "16f1769"  ,
                     "16lf1769" ,
                     "16f1827"  ,
                     "16f1934"  ,
                     "16f648a"  ,
                     "16f690"   ,
                     "16f722"   ,
                     "16f877a"  ,
                     "16f88"    ,
                     "18f1220"  ,
                     "18f14k50" ,
                     "18f24j10" ,
                     "18f23k22" ,
                     "18f24k10" ,
                     "18f2553"  ,
                     "18f26j53" ,
                     "18f4550"  ,
                     "18f4620"  ,
                     "18f6310"  ,
                     "18f66j55" ,
                     "18f6722"  ,
                     "18f67j50" ,
                     "18f67k22" ]

# --- PICs for which a _BLINK_INTOSC_USB sample is desired ---

extra_intosc_usb = [ "16f1455"  ,
                     "18f24j10" ,
                     "18f2553"  ,
                     "18f4550"  ,
                     "18f66j55" ,
                     "18f6722"  ,
                     "18f67j50" ]


# -----------------------------------------------------------
def collect_fusedef(fp):
   """ Scan (part of) device file for keywords of current fusedef
       This procedure is called from scan_devfile() and:
       - assumes the devicefile is opened
       - starts reading from the current location
   """
   kwdlist = []
   ln = fp.readline()
   while (ln != ""):
      words = ln.split()
      if (words[0] == "}"):                                    # end of this fusedef
         break
      kwdlist.append(words[0])
      ln = fp.readline()
   return kwdlist

# ------------------------------------------------------------
def scan_devfile(devfile):
   """ Scan device file for selected device info.
       Notes: - returns info in the exposed global variables.
   """
   global var
   var = {"ircfwidth" : 0}                                     # default width of OSCCON_IRCF
   global fusedef
   fusedef = {}                                                # clear (empty)
   fp = open(os.path.join(devdir,devfile), "r")
   ln = fp.readline()                                          # first line
   while (ln != ""):
      words = ln.split()
      if (len(words) == 0):
         pass
      elif (words[0] == "--"):
         pass
      elif (len(words) > 2):
         if ((words[0] == "pragma") & (words[1] == "fuse_def")):  # obtain fuse_def keyword if any
            fuse = words[2]
            if (fuse.startswith("BROWNOUT")):
               fusedef["brownout"] = collect_fusedef(fp)
            elif (fuse.startswith("CLKOUTEN")):
               fusedef["clkouten"] = collect_fusedef(fp)
            elif (fuse.startswith("CPUDIV")):
               fusedef["cpudiv"] = collect_fusedef(fp)
            elif (fuse.startswith("CSWEN")):
               fusedef["cswen"] = collect_fusedef(fp)
            elif (fuse.startswith("DEBUG")):
               fusedef["debug"] = collect_fusedef(fp)
            elif (fuse.startswith("FCMEN")):
               fusedef["fcmen"] = collect_fusedef(fp)
            elif (fuse.startswith("FOSC2")):
                fusedef["fosc2"] = collect_fusedef(fp)
            elif (fuse.startswith("ICPRT")):
               fusedef["icprt"] = collect_fusedef(fp)
            elif (fuse.startswith("IESO")):
               fusedef["ieso"] = collect_fusedef(fp)
            elif (fuse.startswith("IOSCFS")):
               fusedef["ioscfs"] = collect_fusedef(fp)
            elif (fuse.startswith("LVP")):
               fusedef["lvp"] = collect_fusedef(fp)
            elif (fuse.startswith("MCLR")):
               fusedef["mclr"] = collect_fusedef(fp)
            elif (fuse.startswith("OSC:") | (fuse == "OSC")):
               fusedef["osc"] = collect_fusedef(fp)
            elif (fuse.startswith("PLLDIV")):
               fusedef["plldiv"] = collect_fusedef(fp)
            elif (fuse.startswith("PLLEN")):
               fusedef["pllen"] = collect_fusedef(fp)
            elif (fuse.startswith("RSTOSC")):
               fusedef["rstosc"] = collect_fusedef(fp)
            elif (fuse.startswith("USBDIV")):
               fusedef["usbdiv"] = collect_fusedef(fp)
            elif (fuse.startswith("VREGEN")):
               fusedef["vregen"] = collect_fusedef(fp)
            elif (fuse.startswith("WDT:") | (fuse == "WDT")):
               fusedef["wdt"] = collect_fusedef(fp)
            elif (fuse.startswith("XINST")):
               fusedef["xinst"] = collect_fusedef(fp)
         else:
            if (ln.find(" DATASHEET[]") >= 0):
               ds = words[-1].strip('"')                             # last word excl quotes
               if ds.isdigit():
                  var["datasheet"] = int(ds)
               elif ds[:-1].isdigit():                               # without suffix
                  var["datasheet"] = int(ds[:-1])
            elif (ln.find(" WDTCON_SWDTEN ") >= 0):
               var["wdtcon_swdten"] = True                           # has field
            elif (ln.find(" USB_BDT_ADDRESS ") >= 0):
               var["usb_bdt"] = True
            elif (ln.find(" OSCCON_IRCF ") >= 0):
               if (ln.find("bit*2") >= 0):
                  var["ircfwidth"] = 2
               elif (ln.find("bit*3") >= 0):
                  var["ircfwidth"] = 3
               elif (ln.find("bit*4") >= 0):
                  var["ircfwidth"] = 4
            elif (ln.find(" OSCCON_SCS ") >= 0):
               var["osccon_scs"] = True
            elif (ln.find(" OSCCON_SPLLEN ") >= 0):
               var["osccon_spllen"] = True
            elif (ln.find(" OSCFRQ_HFFRQ ") >= 0):
               var["oscfrq_hffrq"] = True
            elif (ln.find(" OSCTUNE_PLLEN ") >= 0):
               var["osctune_pllen"] = True
      ln = fp.readline()
   fp.close()
   return var

# ------------------------------------------------
def find_blinkpin(devfile):
   """ Find suitable pin for LED in range pin_A0..pin_C7
       First choice is pin_A0, but must be checked with device file.
   """
   with open(os.path.join(devdir, devfile), "r") as fp:
      fstr = fp.read()                             # whole file
   ports = ("A", "B", "C")                         # possible ports
   for p in ports:
      for q in range(8):                           # possible pin numbers (0..7)
         pinpq = "pin_%c%d" % (p, q)               # pin name
         if (pinpq in fstr):                       # pin present
            pinpq_dir = pinpq + "_direction"
            if (pinpq_dir in fstr):                # pin direction present
               return pinpq                        # use this pin
            else:                                  # no TRIS-bit found
               print("   Found", pinpq, "but no", pinpq_dir,  "skip this pin.")
   print("   Could not find suitable I/O pin for LED")
   return ""


# -------------------------------------------------
def validate_jalfile(jalfile):
   """ Validate JAL file
       Can be device file or sample program
   """

   cmdlist = [python_exec, "jallib.py", "validate", jalfile]
   vlog = os.path.join(dstdir, os.path.split(jalfile)[1][:-4] + ".vlog")
   if os.path.exists(vlog):
       os.remove(vlog)
   try:
      log = subprocess.check_output(cmdlist, stderr=subprocess.STDOUT,
                                   universal_newlines=True, shell=False)
   except subprocess.CalledProcessError as e:         #
      with open(vlog, "w") as fp:
         print(e.output, file=fp)                     # save compiler output
      print("   Validation failed for", jalfile)
      print("   See", vlog, "for details")
      return False
#  print "   Validation of", jalfile, "successful!"
   return True


# ----------------------------------------------------
def compile_sample(runtype, pgmname):
   """ Compile sample program and check the result
       Return True if compilation without errors or warnings
       and move sample to destination directory
       Otherwise return False and leave source and compiler output in cwd
   """
   if (runtype == "PROD"):                            # prod mode
      include = ";".join([devprod, incljal])
      smpdir = dstprod                                # destination of created samples
      cmdlist = [compiler, "-no-asm", "-no-codfile", "-no-hex", "-s", include, pgmname]     # compiler options
   else:                                              # test mode
 #     include = ";".join([devtest, incljal])         # test device files + prod JAL files
 #     if (not os.path.exists(os.path.join(devtest, "chipdef_jallib.jal"))):
 #        include = ";".join([devprod, incljal])      # prod device files + prod JAL files
 #     smpdir = dsttest                               # destination of created samples
      fhex = os.path.join(dstdir, os.path.splitext(pgmname)[0] + ".hex")     # hex compiler output
      fasm = os.path.join(dstdir, os.path.splitext(pgmname)[0] + ".asm")     # assembler compiler output
 #      cmdlist = [compiler, "-asm", fasm, "-hex", fhex, "-no-codfile", "-s", include, pgmname]     # compiler options
   cmdlist = [compiler, "-asm", fasm, "-hex", fhex, "-no-codfile", "-s", devdir, pgmname]     # compiler cmd
   flog = os.path.join(dstdir, pgmname[:-3] + "log")  # compiler output report in test directory
   if (os.path.exists(flog)):
      os.remove(flog)
   destfile = os.path.join(dstdir, pgmname)
   if os.path.exists(destfile):                       # (needed with Windows?)
      os.remove(destfile)

   try:
      log = subprocess.check_output(cmdlist, stderr=subprocess.STDOUT,
                                    universal_newlines=True, shell=False)
      loglist = log.split()                           # make it a list of words
      numerrors = int(loglist[-4])                    # get number of errors
      numwarnings = int(loglist[-2])                  # and warnings
      if ( (numerrors == 0) and (numwarnings == 0) ):
#        print("   Compilation of", pgmname, "successful!")  # OK! (zero errors, zero warnings))
         shutil.move(pgmname, destfile)               # move sample
         if os.path.exists(fhex):                     # remove hex output
            os.remove(fhex)
         if os.path.exists(fasm):                     # remove asm output
            os.remove(fasm)
         return True
      else:
         print("   Compilation of", pgmname, "gave", numerrors, "errors", numwarnings, "warnings")
         shutil.move(pgmname, destfile)            # move sample
         with open(flog, "w") as fp:
            print(log, file=fp)                    # save compiler output
         return False
   except subprocess.CalledProcessError as e:
      shutil.move(pgmname, destfile)               # move sample
      with open(flog, "w") as fp:
         print(e.output, file=fp)                  # save compiler output
      print("   Compilation error(s) with sample", pgmname, "\n   see", flog)
      return False


# -------------------------------------------------
def build_sample(pic, pin, osctype, oscword):
   """ Build blink-a-led sample source file
       Type of oscillator determines contents.
       Returns source file program name if successful, None if not
   """
   pgmname = pic + "_blink"                        # pictype + function
   if (osctype == "HS"):
      pgmname = pgmname + "_hs"                    # OSC ID
   elif (osctype == "INTOSC"):
      pgmname = pgmname + "_intosc"
   elif (osctype == "HS_USB"):
      pgmname = pgmname + "_hs_usb"
   elif (osctype == "INTOSC_USB"):
      pgmname = pgmname + "_intosc_usb"
   else:
      print("   Unrecognized oscillator type:", osctype)
      return None

   if (osctype.startswith("INTOSC")  &             # no 4 MHz INTOSC for some PICs
       (var["datasheet"] in (39663, 30009663, 39682, 30009682,
                             39760, 30009760, 39762, 30009762))):
      print("   Does not support 4 MHz with internal oscillator")
      return None

   def fusedef_insert(fuse, kwd, cmt):
      """ Insert a fusedef line (if fuse and specific keyword are present)
      """
      if (fuse in fusedef):
         if (kwd in fusedef[fuse]):
            fp.write("pragma target %-8s %-25s " % (fuse.upper(), kwd) + "-- " + cmt + "\n")


   pgmname = pgmname + ".jal"                      # add jal extension
   fp = open(pgmname,  "w")
   fp.write("-- ------------------------------------------------------\n")
   fp.write("-- Title: Blink-a-led of the Microchip pic" + pic + "\n")
   fp.write("--\n")
   yyyy = time.ctime().split()[-1]
   fp.write("-- Author: " + ScriptAuthor + ", Copyright (c) 2008.." + yyyy + " all rights reserved.\n")
   fp.write("--\n")
   fp.write("-- Adapted-by:\n")
   fp.write("--\n")
   fp.write("-- Revision: $Revision$\n")
   fp.write("--\n")
   fp.write("-- Compiler:" + CompilerVersion + "\n")
   fp.write("--\n")
   fp.write("-- This file is part of jallib (https://github.com/jallib/jallib)\n")
   fp.write("-- Released under the BSD license " +
                      "(http://www.opensource.org/licenses/bsd-license.php)\n")
   fp.write("--\n")
   fp.write("-- Description:\n")
   fp.write("--    Simple blink-a-led program for Microchip pic" + pic + "\n")
   if ((osctype == "HS") | (osctype == "HS_USB")):
      fp.write("--    using an external crystal or resonator.\n")
   else:
      fp.write("--    using the internal oscillator.\n")
   fp.write("--    The LED should be flashing twice a second!\n")
   fp.write("--\n")
   fp.write("-- Sources:\n")
   fp.write("--\n")
   fp.write("-- Notes:\n")
   fp.write("--  - Creation date/time: " + datetime.datetime.now().ctime() + "\n")
   fp.write("--  - This file is generated by 'blink-a-led.py' script! Do not change!\n")
   fp.write("--\n")
   fp.write("-- ------------------------------------------------------\n")
   fp.write("--\n")
   fp.write("include "  + pic + "                     -- target PICmicro\n")
   fp.write("--\n")

   # oscillator selection
   if (osctype == "HS"):                                # HS crystal or resonator
      fp.write("-- This program assumes that a 20 MHz resonator or crystal\n")
      fp.write("-- is connected to pins OSC1 and OSC2.\n")
      fp.write("pragma target clock 20_000_000      -- oscillator frequency\n")
      fp.write("--\n")
      fp.write("pragma target OSC      %-25s " % (oscword) + "-- crystal or resonator\n")
      if ("fosc2" in fusedef):
         fp.write("pragma target FOSC2    %-25s " % ("ON") + "-- system clock: OSC\n")
      if ("rstosc" in fusedef):
         if ("EXT1X" in fusedef["rstosc"]):
            fp.write("pragma target RSTOSC   %-25s " % ("EXT1X") + "-- power-up clock select: OSC\n")
      if (oscword == "PRI"):
         fp.write("pragma target POSCMD   %-25s " % ("HS") +  "-- high speed\n")

   elif ((osctype == "INTOSC") | (osctype == "")):    # internal oscillator
      fp.write("-- This program uses the internal oscillator at 4 MHz.\n")
      fp.write("pragma target clock    4_000_000       -- oscillator frequency\n")
      fp.write("--\n")
      if (oscword != ""):                             # PIC has fuse_def OSC
         fp.write("pragma target OSC      %-25s " % (oscword) + "-- internal oscillator\n")
      fusedef_insert("fosc2", "OFF", "Internal Oscillator")
      fusedef_insert("ioscfs", "F4MHZ", "select 4 MHz")
      fusedef_insert("rstosc", "HFINT32", "select 32 MHz")
   elif (osctype == "HS_USB"):                    # HS oscillator and USB
      fp.write("-- This program assumes that a 20 MHz resonator or crystal\n")
      fp.write("-- is connected to pins OSC1 and OSC2, and USB active.\n")
      fp.write("-- But PIC will be running at 48MHz.\n")
      fp.write("pragma target clock 48_000_000      -- oscillator frequency\n")
      fp.write("--\n")
      fp.write("pragma target OSC      %-25s " % (oscword) + "-- HS osc + PLL\n")

   elif (osctype == "INTOSC_USB"):                   # internal oscillator + USB
      fp.write("-- This program uses the internal oscillator with PLL active.\n")
      fp.write("pragma target clock 48_000_000      -- oscillator frequency\n")
      fp.write("--\n")
      fp.write("pragma target OSC      %-25s " % (oscword) + "-- internal oscillator\n")
      fusedef_insert("fosc2", "OFF", "Internal oscillator")


   # other OSC related fuse_defs
   if ("pllen" in fusedef):                          # PLLEN present
      if (osctype == "INTOSC"):                      # INTOSC selected
         if (var["datasheet"] in (41341, 41417, 41418, 40001430, 40001341, 40001417, 40001418)):
            fusedef_insert("pllen", "ENABLED", "PLL on")
         else:
            fusedef_insert("pllen", "DISABLED", "PLL off")
      elif (osctype == "INTOSC_USB"):
         fusedef_insert("pllen", "ENABLED", "PLL on")
      else:
         fusedef_insert("pllen", "DISABLED", "PLL off")

   if ("plldiv" in fusedef):
      if (osctype == "HS_USB"):
         fusedef_insert("plldiv", "P5", "20 MHz -> 4 MHz")
      elif (osctype == "INTOSC_USB"):
         fusedef_insert("plldiv", "P2", "8 MHz -> 4 MHz")
      else:
         fusedef_insert("plldiv", "P1", "clock postscaler")

   fusedef_insert("cpudiv", "P1", "Fosc divisor")

   if (osctype == "HS_USB"):
      fusedef_insert("usbdiv", "P2", "USB clock selection")

   # now the "easy" fuse_defs!
   fusedef_insert("clkouten", "DISABLED", "no clock output")
   wdtword = ""
   if ("wdt" in fusedef):
      if ("DISABLED" in fusedef["wdt"]):
         fp.write("pragma target WDT      %-25s " % ("DISABLED") + "-- watchdog\n")
         wdtword = "DISABLED"
      elif ("CONTROL", fusedef["wdt"]):
         fp.write("pragma target WDT      %-25s " % ("CONTROL") + "-- watchdog\n")
         wdtword = "CONTROL"
   fusedef_insert("xinst", "DISABLED", "do not use extended instructionset")
   fusedef_insert("debug", "DISABLED", "no debugging")
   fusedef_insert("brownout", "DISABLED", "no brownout reset")
   fusedef_insert("fcmen", "DISABLED", "no clock monitoring")
   fusedef_insert("cswen", "ENABLED", "allow writing OSCCON1 NOSC and NDIV")
   fusedef_insert("ieso", "DISABLED", "no int/ext osc switching")
   fusedef_insert("vregen", "ENABLED", "voltage regulator used")
   fusedef_insert("lvp", "DISABLED", "no low voltage programming")
   fusedef_insert("mclr", "EXTERNAL", "external reset")
   fp.write("--\n")
   fp.write("-- The configuration bit settings above are only a selection, sufficient\n")
   fp.write("-- for this program. Other programs may need more or different settings.\n")
   fp.write("--\n")

   if (wdtword == "CONTROL"):
      if ("wdtcon_swdten" in var):
         fp.write("WDTCON_SWDTEN = OFF                 -- disable WDT\n")

   if (osctype == "HS"):                             # HS crystal / resonator
      if ("osccon_scs" in var):
         fp.write("OSCCON_SCS = 0                      -- select primary oscillator\n")
      if ("osctune_pllen" in var):
         fp.write("OSCTUNE_PLLEN = FALSE               -- no PLL\n")

   elif (osctype == "INTOSC"):                       # internal oscillator
      if ("osccon_scs" in var):
         fp.write("OSCCON_SCS = 0                      -- select primary oscillator\n")
      if ("oscfrq_hffrq" in var):
         fp.write("OSCFRQ_HFFRQ = 0b010                -- Fosc 32 -> 4 MHz\n")
      if ("ircfwidth" in var):
         if (var["ircfwidth"] > 0):
            ds = var["datasheet"]                    # get datasheet of this PIC (int)
            if (ds not in ircf):
               if (ds < 100000):                     # (old) 5-digit number
                  dstmp = (ds // 10000) * 10000000 + (ds % 10000)  # try 8-digit number
                  if (dstmp in ircf):
                     ds = dstmp
               elif (10000000 < ds < 100000000):     # (new) 8-digit number
                  dstmp = (ds // 10000000) * 10000 + (ds % 10000)  # try 5-digit number
                  if (dstmp in ircf):
                     ds = dstmp
            if (ds not in ircf):                     # not in ircf dictionary
               print("   No OSCCON_IRCF entry in dictionary table for datasheet", ds)
               print("   Assumed to be 0b1101")
               fp.write("OSCCON_IRCF = 0b1101                -- 4 MHz (presumably)\n")
            elif (len(ircf[ds]) != var["ircfwidth"]):
               print("   Conflict between width of OSCCON_IRCF (",
                         var["ircfwidth"], ") and ", len(ircf[ds]))
               print("   No OSCCON_IRCF specified")
               fp.write("-- OSCCON_IRCF = 0b1101             -- to be corrected by user!\n")
            elif (ircf[ds] == "--"):
               print("   Invalid bit pattern (", ircf[ds], ") for OSCCON_IRCF")
               print("   No OSCCON_IRCF specified")
               fp.write("-- OSCCON_IRCF = 0b1101             -- to be corrected by user!\n")
            else:
               fp.write("OSCCON_IRCF = 0b%-5s" % (ircf[ds]) + "               -- 4 MHz\n")
      if ("osctune_pllen" in var):
         fp.write("OSCTUNE_PLLEN = FALSE               -- no PLL\n")
      if ("osccon_spllen" in var):
         fp.write("OSCCON_SPLLEN = FALSE               -- software PLL off\n")

   elif (osctype == "HS_USB"):                       # HS cryst./res. + USB
      if ("osccon_scs" in var):
         fp.write("OSCCON_SCS = 0                      -- select primary oscillator\n")
      if ("osctune_pllen" in var):
         fp.write("OSCTUNE_PLLEN = TRUE                -- PLL\n")

   elif (osctype == "INTOSC_USB"):                   # internal oscillator + USB
      if ("osccon_scs" in var):
         fp.write("OSCCON_SCS = 0                      -- select primary oscillator\n")
      if ("osctune_pllen" in var):
         fp.write("OSCTUNE_PLLEN = TRUE                -- use PLL\n")

   # the actual blink-a-led program code
   fp.write("--\n")
   fp.write("enable_digital_io()                 -- make all pins digital I/O\n")
   fp.write("--\n")
   fp.write("-- A low current (2 mA) led with 2.2K series resistor is recommended\n")
   fp.write("-- since the chosen pin may not be able to drive an ordinary 20mA led.\n")
   fp.write("--\n")
   fp.write("alias  led       is " + pin + "          -- alias for pin with LED\n")
   fp.write("--\n")
   fp.write(pin + "_direction = OUTPUT\n")
   fp.write("--\n")
   fp.write("forever loop\n")
   fp.write("   led = ON\n")
   fp.write("   _usec_delay(100_000)\n")
   fp.write("   led = OFF\n")
   fp.write("   _usec_delay(400_000)\n")
   fp.write("end loop\n")
   fp.write("--\n")
   fp.close()                                         # blink sample complete!
   return pgmname


# -----------------------------------------------------
def build_validate_compile_sample(pic, blink_pin, osctype, oscword):
   """ Build, validate and compile a sample
       Chack result of compile for no errors and warnings
   """
   pgmname = build_sample(pic, blink_pin, osctype, oscword)
   if (pgmname == None):
      print("   No sample for", pic)
      return False
   print(pgmname)
   if (not validate_jalfile(pgmname)):
      return False                                    # validate failed
   if (not compile_sample(runtype, pgmname)):
      return False
   return True                                        # Everythng OK


# ----------------------------------------------------
def main(runtype, devs):
   """ Create one or more blink-a-led samples for every device file
       Arguments: runtype: PROD or TEST
                  devs: list of device files for which to build a blink sample
   """
   sample_count = 0
   for dev in devs:
      if (runtype == "PROD"):                         # production device file
         jalfile = os.path.join(devprod, dev)
      else:                                           # test device file
         jalfile = os.path.join(devdir, dev)
      if (not validate_jalfile(jalfile)):             # device file does not validate
         continue

      var = scan_devfile(dev)                         # build list of selected device info
                                                      # builds also fusedef
      if ("osc" not in fusedef):                      # no fusedef osc at all
         osctype = "INTOSC"                           # must be internal oscillator
         oscword = ""                                 # without fuse_def OSC
      elif ("HSH" in fusedef["osc"]):
         osctype = "HS"
         oscword = "HSH"
      elif ("PRI" in fusedef["osc"]):
         osctype = "HS"
         oscword = "PRI"
      elif ("HS" in fusedef["osc"]):
         osctype = "HS"
         oscword = "HS"
      elif ("INTOSC_NOCLKOUT" in fusedef["osc"]):
         osctype = "INTOSC"
         oscword = "INTOSC_NOCLKOUT"
      elif ("OFF" in fusedef["osc"]):                 # 16f19155, etc
         osctype = "INTOSC"
         oscword = "OFF"
      else:
         print("   Could not detect a suitable OSC keyword in", fusedef["osc"])
         continue                                     # skip this PIC

      blink_pin = find_blinkpin(dev)
      if (blink_pin == ""):                           # no blink pin available
         continue

      picname = os.path.splitext(dev)[0]
      if (build_validate_compile_sample(picname, blink_pin, osctype, oscword)):    # primary sample OK
         sample_count += 1
         if (osctype == "HS"):                        # this was a HS type
            if (picname in extra_intosc):             # INTOSC sample requested
               if ("INTOSC_NOCLKOUT" in fusedef["osc"]):    # no intosc + pll
                  if (build_validate_compile_sample(picname, blink_pin, "INTOSC", "INTOSC_NOCLKOUT")):
                     sample_count += 1

               elif ("INTOSC_NOCLKOUT_USB_HS" in fusedef["osc"]):  # intosc + pll
                  if (build_validate_compile_sample(picname, blink_pin, "INTOSC", "INTOSC_NOCLKOUT_USB_HS")):
                     sample_count += 1

               elif ("fosc2" in fusedef):
                  if ("ON" in fusedef["fosc2"]):      # "implicit" fuse_def intosc
                     if (build_validate_compile_sample(picname, blink_pin, "INTOSC", "INTOSC_NOCLKOUT")):
                        sample_count += 1
               else:
                  print("   INTOSC sample requested, but no INTOSC or 4 MHz not available")

            if (("HS_PLL" in fusedef["osc"]) & ("usb_bdt" in var)):            # USB variant
               if (build_validate_compile_sample(picname, blink_pin, "HS_USB", "HS_PLL")):
                  sample_count += 1

                  if (picname in extra_intosc_usb):   # INTOSC_USB sample requested
                     if ("INTOSC_NOCLKOUT_PLL" in fusedef["osc"]):
                        if (build_validate_compile_sample(picname, blink_pin, "INTOSC_USB", "INTOSC_NOCLKOUT_PLL")):
                           sample_count += 1
                     else:
                        print("   No INTOSC + PLL available for 48 KHz")
   return sample_count




# ======== E N T R Y   P O I N T  =======================================

if (__name__ == "__main__"):
   """ Process commandline arguments, start process, clock execution time
   """
   if (len(sys.argv) > 1):
      runtype = sys.argv[1].upper()
   else:
      print("Specify at least PROD or TEST as first argument")
      print("and optionally as second argument a pictype (wildcards allowed)")
      sys.exit(1)

   if (len(sys.argv) > 3):
      print("Expecting not more than 2 arguments: runtype + selection")
      print("==> When using wildcards, specify selection string between quotes")
      print("    or use the command 'set -f' to suppress wildcard expansion by the shell")
      sys.exit(1)
   elif (len(sys.argv) > 2):
      selection = sys.argv[2] + ".jal"                # add extension
   else:
      selection = "1*.jal"                            # default selection

   print("Creating blink-a-led sample files")
   elapsed = time.time()
   cwd = os.getcwd()                                  # remember working directory
   if (runtype == "PROD"):
      print("PROD option temporary disabled")
      sys.exit(1)
   elif (runtype == "TEST"):
      if (not os.path.exists(os.path.join(devdir, "chipdef_jallib.jal"))):
         print("Probably no device files in", devdir)
         sys.exit(1)
   os.chdir(devdir)                                   # dir with device files
   devs = glob.glob(selection)                        # list of device files
   os.chdir(cwd)                                      # back to working dir
   if (len(devs) == 0):
      print("No device files found matching", selection)
      sys.exit(1)
   devs.sort()                                        # alphanumeric order

#   if not os.path.exists(os.path.join(devdir, "constants_jallib.jal")):
#      shutil.copyfile("constants_jallib.jal", devdir)

   count = main(runtype, devs)                        # the actual process

   elapsed = time.time() - elapsed
   if (elapsed > 0):
      print("Generated %d blink-a-led samples in %.1f seconds (%.1f per second)" % \
             (count, elapsed, count / elapsed))


