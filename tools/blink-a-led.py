#!/usr/bin/python3
""" Create and compile blink-a-led samples.
  Author: Rob Hamerling, Copyright (c) 2008..2025, all rights reserved.
  Adapted-by: Rob Jansen

  This file is part of jallib  https://github.com/jallib/jallib
  Released under the ZLIB license
                 http://www.opensource.org/licenses/zlib-license.html

  Description: Python script to create blink-a-led samples
               for every available device file.
               - Validate the device file
               - Create one or more blink-a-led sample programs
               - Validate the sample programs
               - Compile the samples program
               - Check the compiler output for errors and warnings
               With validation or compiler errors or warnings:
               - find '.vlog' and/or '.log' files with the samples

      Check if requirements for pic2jal scripts are satisfied:
     - Python version: at least Python 3.5
     - Environment variables:
       - PIC2JAL        - path of destination directory 
       - JALCOMPILER    - used JAL compiler (platform specific)
       - MPLABXVERSION  - latest version number of MPLABX, e.g.: 6.25

  Sources:

  Version: 0.8 dd 2024-04-xx
   - runtype selection (PROD / TEST) removed (test mode only left)
   - validation script: import of 'jallib' and direct invocation
     (not called in a subprocess qwith Python)
   - devspec contents loaded at import time (no more 'global')
     all other globals (var, fusedef) passed as procedure arguments
   - compiler invocation with os.popen(), not with subprocess
   - blink sample created directly in destination directory
     (no move needed from working to destination directory)
   - no creation of compiler .asm and .hex files
   - device files now included from 'device' subdirectory (not 'test')
   - using parallel processing via futures.ProcessPoolExecutor
   - some minor changes, cleanup, optimisations, harminisation, like:
      - check for PGM pin incorporated in search for blink pin
      - validation log (with validation errors): 'pgmname.jal.vlog'
      - compiler log (with compile errors/warnings): 'pgmname.jal.log'
      - 'haspgmpin' moved into 'var' dictionary
      - use of format strings (f"...")


  Notes:
   - One or more blink-a-led samples are generated for every device file:
     a HS sample if possible and INTOSC sample if possible
   - For PICs with USB support a sample is generated using HS_USB.
   - The generation of samples can be limited to a subset by
     supplying (part of a) PIC type (with wildcards, e.g.: "16f8*").

"""

import sys
import os
import time
import fnmatch
import json
from concurrent import futures
import jallib3                                  # Python 3 version

# Check - environment - requirements for running this script.
if (sys.version_info < (3,5,0)):
    print("You need Python 3.5.0 or later to run this script!\n")
    exit(1)

if not ('PIC2JAL' in os.environ):
    print("Environment variable PIC2JAL for destination not set.")
    exit(1)

if not ('JALCOMPILER' in os.environ):
    print("Environment variable JALCOMPILER for compiling samples not set.")
    exit(1)

if not ('MPLABXVERSION' in os.environ):
    print("Environment variable MPLABXVERSION for latest MPLABX version not set.")
    exit(1)

# All OK, set variables. 
base = os.path.join(os.environ['PIC2JAL'] + "." + os.environ['MPLABXVERSION'])
compiler = os.environ['JALCOMPILER']

# global constants

ScriptAuthor    = "Rob Hamerling, Rob Jansen"
CompilerVersion = "2.5r9"   # latest JalV2 compiler version
scriptversion = "2.1"       # script version

devdir = os.path.join(base, "device")           # origin of new device files
dstdir = os.path.join(base, "blink")            # destination of new samples
if not os.path.exists(dstdir):                  # dstdir doesn't exists
   os.makedirs(dstdir)                          # create it

devspecfile = os.path.join(base, "devicespecific.json")  # specific PIC properties
with open(devspecfile, "r") as fp:
   devspec = json.load(fp)                      # get dictionary with contents

if not os.path.exists('constants_jallib.jal'):
   print('Missing required "constants_jallib.jal" in current directory')
   exit(6)

def scan_devfile(devfile):
   """ Scan device file for selected device info """

   var = {"ircfwidth" : 0}                      # new, default width OSCCON_IRCF
   fusedef = {}                                 # new

   def collect_fusedef(fp):
      """ Scan (part of) device file for keywords of current fusedef """
      kwdlist = []
      while (ln := fp.readline()) != "":
         words = ln.split()
         if words[0] == "}":                    # end of this fusedef
            break
         kwdlist.append(words[0])
      return kwdlist

   with open(os.path.join(devdir,devfile), "r") as fp:
      while (ln := fp.readline()) != "":
         words = ln.split()
         if len(words) == 0:
            pass
         elif words[0] == "--":
            pass
         elif len(words) > 2:
            if (words[0] == "pragma") & (words[1] == "fuse_def"):  # obtain fuse_def keyword if any
               fuse = words[2]
               if fuse.startswith("BROWNOUT"):
                  fusedef["brownout"] = collect_fusedef(fp)
               elif fuse.startswith("CLKOUTEN"):
                  fusedef["clkouten"] = collect_fusedef(fp)
               elif fuse.startswith("CPUDIV"):
                  fusedef["cpudiv"] = collect_fusedef(fp)
               elif fuse.startswith("CSWEN"):
                  fusedef["cswen"] = collect_fusedef(fp)
               elif fuse.startswith("DEBUG"):
                  fusedef["debug"] = collect_fusedef(fp)
               elif fuse.startswith("FCMEN"):
                  fusedef["fcmen"] = collect_fusedef(fp)
               elif fuse.startswith("FOSC2"):
                   fusedef["fosc2"] = collect_fusedef(fp)
               elif fuse.startswith("ICPRT"):
                  fusedef["icprt"] = collect_fusedef(fp)
               elif fuse.startswith("IESO"):
                  fusedef["ieso"] = collect_fusedef(fp)
               elif fuse.startswith("IOSCFS"):
                  fusedef["ioscfs"] = collect_fusedef(fp)
               elif fuse.startswith("LVP"):
                  fusedef["lvp"] = collect_fusedef(fp)
               elif fuse.startswith("MCLR"):
                  fusedef["mclr"] = collect_fusedef(fp)
               elif fuse.startswith("OSC:") | (fuse == "OSC"):
                  fusedef["osc"] = collect_fusedef(fp)
               elif fuse.startswith("PLLDIV"):
                  fusedef["plldiv"] = collect_fusedef(fp)
               elif fuse.startswith("PLLEN"):
                  fusedef["pllen"] = collect_fusedef(fp)
               elif fuse.startswith("RSTOSC"):
                  fusedef["rstosc"] = collect_fusedef(fp)
               elif fuse.startswith("USBDIV"):
                  fusedef["usbdiv"] = collect_fusedef(fp)
               elif fuse.startswith("VREGEN"):
                  fusedef["vregen"] = collect_fusedef(fp)
               elif fuse.startswith("WDT:") | (fuse == "WDT"):
                  fusedef["wdt"] = collect_fusedef(fp)
               elif fuse.startswith("XINST"):
                  fusedef["xinst"] = collect_fusedef(fp)
               elif fuse.startswith("JTAGEN"):               # Find JTAGEN since it must be disabled.
                  fusedef["jtagen"] = collect_fusedef(fp)
               elif fuse.startswith("MVECEN"):               # Find Multi Vectored Interrupt since it must be disabled.
                  fusedef["mvecen"] = collect_fusedef(fp)
            else:
               if ln.find(" WDTCON_SWDTEN ") >= 0:
                  var["wdtcon_swdten"] = True                           # has field
               elif ln.find(" USB_BDT_ADDRESS ") >= 0:
                  var["usb_bdt"] = True
               elif ln.find(" OSCCON_IRCF ") >= 0:
                  if ln.find("bit*2") >= 0:
                     var["ircfwidth"] = 2
                  elif ln.find("bit*3") >= 0:
                     var["ircfwidth"] = 3
                  elif ln.find("bit*4") >= 0:
                     var["ircfwidth"] = 4
               elif ln.find(" OSCCON_SCS ") >= 0:
                  var["osccon_scs"] = True
               elif ln.find(" OSCCON_SPLLEN ") >= 0:
                  var["osccon_spllen"] = True
               elif ln.find(" OSCFRQ_FRQ3 ") >= 0:   # For PICs running at 64 MHz we need to check for bit 4 since ...
                  var["oscfrq_frq3"] = True          # ... OSCFRQ_HFFRQ also exists but should not be used.
               elif ln.find(" OSCFRQ_HFFRQ ") >= 0:
                  var["oscfrq_hffrq"] = True
               elif ln.find(" OSCFRQ_FRQ ") >= 0:
                  var["oscfrq_frq"] = True
               # RJ: Fix issue with newer PICs with 4-bit OSCFRQ_HFFRQ3 register
               elif ln.find(" OSCFRQ_HFFRQ3 ") >= 0:
                  var["oscfrq_hffrq3"] = True
               elif ln.find(" OSCCON1_NOSC ") >= 0:
                  var["osccon1_nosc"] = True
               elif ln.find(" OSCCON1_NDIV ") >= 0:
                  var["osccon1_ndiv"] = True
               elif ln.find(" OSCTUNE_PLLEN ") >= 0:
                  var["osctune_pllen"] = True
   return var, fusedef


def find_blinkpin(devfile, var):
   """ Find suitable pin for LED in range pin_A0..pin_C7
       First choice is pin_A0, but must be checked with device file.
       Check also if PIC has (LVP) programming pin
   """
   with open(os.path.join(devdir, devfile), "r") as fp:
      fstr = fp.read()                                # whole file
      var["haspgmpin"] = "pin_PGM" in fstr            # presence of (LVP) PGM pin
      ports = ("A", "B", "C")                         # possible ports
      for p in ports:
         for q in range(8):                           # possible pin numbers (0..7)
            if (pinpq := f" pin_{p}{q} ") in fstr:    # 'isolated' pin declaration
               pinpq = pinpq.strip()                  # strip leading, trailing blanks
               # print(f"{pinpq=} pindir: < {pinpq}_direction>", fstr.find(f" {pinpq}_direction"))
               if (pinpq_dir := f" {pinpq}_direction") in fstr:  # pin direction
                  return pinpq                        # use this pin for LED
               else:                                  # no TRIS-bit found
                  # print(f"   {devfile} Found {pinpq} but no {pinpq_dir}, skipped")
                  continue
      print("   Could not find suitable I/O pin for LED")
   return ""


def validate_jalfile(jalfile):
   """ Validate JAL file with 'jallib3' script
       Can be device file or sample program
   """
   vlog = os.path.join(dstdir, os.path.split(jalfile)[1] + ".vlog")
   if os.path.exists(vlog):
       os.remove(vlog)
   try:
      loglist = jallib3.validate(jalfile)
      if not (len(loglist[0]) == 0 and len(loglist[1]) == 0):
         with open(vlog, "w") as fp:                  # create log
            if len(loglist[0]) > 0:
               fp.write(f"[{loglist[0]}]")
            if len(loglist[1]) > 0:
               fp.write(f"[{oglist[1]}]]")
         print(f"Validation of {jalfile} failed,\n   see: {vlog}")
         return False
      else:                                           # compilation succeeded
         # print(f"Validation of {jalfile} succeeded!")
         return True
   except Exception as e:
      print(f"Validation of {jalfile} failed:\n  {e}")
      return False
   return True


def compile_sample(pgmname):
   """ Compile sample program and check the result
       Return 0 if compilation with no errors or warnings
       otherwise return result code and create .log file
   """
   opts = '-no-asm -no-hex -no-codfile'               # compiler options
   cmd = f'{compiler} {opts} -s {devdir} {os.path.join(dstdir,pgmname)}'
   flog = os.path.join(dstdir, pgmname + ".log")      # compiler output report
   if os.path.exists(flog):
      os.remove(flog)
   try:
      output = os.popen(cmd)                          # with full command string
      loglist = output.readlines()                    # list of output lines
      if (rc := output.close()) is not None:          # in case of failure
         with open(flog, "w") as fp:                  # create log
            fp.write("".join(loglist))                # save compiler output
         lastlist = loglist[-1].strip().split()       # list of strings in last line
         if "warnings" in lastlist:                   # expected in last line
            errors = int(lastlist[0])
            warnings = int(lastlist[2])
            print(f"Compilation of {pgmname} failed: {errors=} {warnings=}; ")
            print(f"   {rc=} see: {flog}")
         return rc
      else:                                           # compilation succeeded
         return 0
   except Exception as e:
      print(f"Compilation of {pgmname} failed:", e)
      return 1
   return 0


def build_sample(pic, pin, osctype, oscword, fusedef, var):
   """ Build blink-a-led sample source file
       Type of oscillator determines contents.
       Returns source file program name if successful, None if not
   """
   if osctype in ("HS", "INTOSC", "HS_USB", "INTOSC_USB"):
      pgmname = pic + "_blink_" + osctype.lower()
   elif osctype in ("HS_32MHZ"):
      pgmname = pic + "_blink_hs"  # Newer PICs have HS_xxMHZ like the PIC18F16Q20
   else:
      print("   Unrecognized oscillator type:", osctype)
      return None

   picdata = devspec.get(pic.upper(), {})             # pic specific info

   # No 4 MHz INTOSC for some PICs indicated by mentioning the OSCCON_IRCF in devicespecific.json but
   # without a value ("-").

   # RJ: Maybe this can be removed since ["OSCCON_IRCF"] == "-" is removed from devicespecific.json.
   #     Those devices that where indicated with this option did not have OSCCON_IRCF in the device file.
   if osctype.startswith("INTOSC") & ("OSCCON_IRCF" in picdata):
      if picdata["OSCCON_IRCF"] == "-":
         print("   Does not support 4 MHz with internal oscillator")
         return None

   def fusedef_insert(fuse, kwd, cmt):
      """ Insert a fusedef line (if fuse and specific keyword are present)
      """
      if fuse in fusedef:
         if kwd in fusedef[fuse]:
            fp.write("pragma target %-8s %-25s " % (fuse.upper(), kwd) + "-- " + cmt + "\n")

   pgmname = pgmname + ".jal"                         # add jal extension
   with open(os.path.join(dstdir, pgmname),  "w") as fp:
      fp.write("-- ------------------------------------------------------\n")
      fp.write("-- Title: Blink-a-led of the Microchip pic" + pic + "\n")
      fp.write("--\n")
      yyyy = time.ctime().split()[-1]
      fp.write("-- Author: " + ScriptAuthor + ", Copyright (c) 2008.." + yyyy + " all rights reserved.\n")
      fp.write("--\n")
      fp.write("-- Adapted-by: N/A (generated file, do not change!)\n")
      fp.write("--\n")
      fp.write("-- Compiler: " + CompilerVersion + "\n")
      fp.write("--\n")
      fp.write("-- This file is part of jallib (https://github.com/jallib/jallib)\n")
      fp.write("-- Released under the ZLIB license " +
                         "(http://www.opensource.org/licenses/zlib-license.html)\n")
      fp.write("--\n")
      fp.write("-- Description:\n")
      fp.write("--    Simple blink-a-led program for Microchip pic" + pic + "\n")
      if (osctype == "HS") | (osctype == "HS_32MHZ") | (osctype == "HS_USB"):
         fp.write("--    using an external crystal or resonator.\n")
      else:
         fp.write("--    using the internal oscillator.\n")
      fp.write("--    The LED should be flashing twice a second!\n")
      fp.write("--\n")
      fp.write("-- Sources:\n")
      fp.write("--\n")
      fp.write("-- Notes:\n")
      fp.write("--    - This file is generated by <blink-a-led.py> script version " + scriptversion + "\n")
      fp.write("--    - File creation date/time: " + time.ctime() + "\n")
      fp.write("--\n")
      fp.write("-- ------------------------------------------------------\n")
      fp.write("--\n")
      fp.write("include "  + pic + "                     -- target PICmicro\n")
      fp.write("--\n")

      # oscillator selection
      if (osctype == "HS") | (osctype == "HS_32MHZ"):  # HS crystal or resonator
         fp.write("-- This program assumes that a 20 MHz resonator or crystal\n")
         fp.write("-- is connected to pins OSC1 and OSC2.\n")
         fp.write("pragma target clock 20_000_000      -- oscillator frequency\n")
         fp.write("--\n")
         fp.write("pragma target OSC      %-25s " % (oscword) + "-- crystal or resonator\n")
         if "fosc2" in fusedef:
            fp.write("pragma target FOSC2    %-25s " % ("ON") + "-- system clock: OSC\n")
         if "rstosc" in fusedef:
            if "EXT1X" in fusedef["rstosc"]:
               fp.write("pragma target RSTOSC   %-25s " % ("EXT1X") + "-- power-up clock select: OSC\n")
         if oscword == "PRI":
            fp.write("pragma target POSCMD   %-25s " % ("HS") +  "-- high speed\n")

      elif (osctype == "INTOSC") | (osctype == ""):    # internal oscillator
         fp.write("-- This program uses the internal oscillator at 4 MHz.\n")
         fp.write("pragma target clock    4_000_000       -- oscillator frequency\n")
         fp.write("--\n")
         # For older versions without OSC, we skip the OSC when it has the value of F4MHZ.
         # F4MHZ is written later (also for other PICs) at ioscfs.
         if oscword != "F4MHZ":                       # PIC has fuse_def OSC
            fp.write("pragma target OSC      %-25s " % (oscword) + "-- internal oscillator\n")
         fusedef_insert("fosc2", "OFF", "Internal Oscillator")
         fusedef_insert("ioscfs", "F4MHZ", "select 4 MHz")
         if "oscfrq_frq3" in var:
            fusedef_insert("rstosc", "HFINTOSC_64MHZ", "select 64 MHz")
         elif ("oscfrq" in var) | ("oscfrq_hffrq" in var):
            fusedef_insert("rstosc", "HFINT32", "select 32 MHz")
         elif "oscfrq_frq" in var:
            fusedef_insert("rstosc", "HFINTOSC_32MHZ", "select 32 MHz")
      elif osctype == "HS_USB":                      # HS oscillator and USB
         fp.write("-- This program assumes that a 20 MHz resonator or crystal\n")
         fp.write("-- is connected to pins OSC1 and OSC2, and USB active.\n")
         fp.write("-- But PIC will be running at 48MHz.\n")
         fp.write("pragma target clock 48_000_000      -- oscillator frequency\n")
         fp.write("--\n")
         fp.write("pragma target OSC      %-25s " % (oscword) + "-- HS osc + PLL\n")
      elif osctype == "INTOSC_USB":                     # internal oscillator + USB
         fp.write("-- This program uses the internal oscillator with PLL active.\n")
         fp.write("pragma target clock 48_000_000      -- oscillator frequency\n")
         fp.write("--\n")
         fp.write("pragma target OSC      %-25s " % (oscword) + "-- internal oscillator\n")
         fusedef_insert("fosc2", "OFF", "Internal oscillator")

      # other OSC related fuse_defs
      if "pllen" in fusedef:                            # PLLEN present
         if osctype == "INTOSC":                        # INTOSC selected
            if "PLLEN" in picdata:
               fusedef_insert("pllen", "ENABLED", "PLL on")
            else:
               fusedef_insert("pllen", "DISABLED", "PLL off")
         elif osctype == "INTOSC_USB":
            fusedef_insert("pllen", "ENABLED", "PLL on")
         else:
            fusedef_insert("pllen", "DISABLED", "PLL off")

      if "plldiv" in fusedef:
         if osctype == "HS_USB":
            fusedef_insert("plldiv", "P5", "20 MHz -> 4 MHz")
         elif osctype == "INTOSC_USB":
            fusedef_insert("plldiv", "P2", "8 MHz -> 4 MHz")
         else:
            fusedef_insert("plldiv", "P1", "clock postscaler")

      fusedef_insert("cpudiv", "P1", "Fosc divisor")

      if osctype == "HS_USB":
         fusedef_insert("usbdiv", "P2", "USB clock selection")

      # now the "easy" fuse_defs!
      fusedef_insert("clkouten", "DISABLED", "no clock output")
      wdtword = ""
      if "wdt" in fusedef:
         if "DISABLED" in fusedef["wdt"]:
            fp.write("pragma target WDT      %-25s " % ("DISABLED") + "-- watchdog\n")
            wdtword = "DISABLED"
         elif "CONTROL" in fusedef["wdt"]:
            fp.write("pragma target WDT      %-25s " % ("CONTROL") + "-- watchdog\n")
            wdtword = "CONTROL"
      fusedef_insert("xinst", "DISABLED", "do not use extended instructionset")
      fusedef_insert("debug", "DISABLED", "no debugging")
      fusedef_insert("brownout", "DISABLED", "no brownout reset")
      fusedef_insert("fcmen", "DISABLED", "no clock monitoring")
      fusedef_insert("cswen", "ENABLED", "allow writing OSCCON1 NOSC and NDIV")
      fusedef_insert("ieso", "DISABLED", "no int/ext osc switching")
      fusedef_insert("vregen", "ENABLED", "voltage regulator used")
      # For LVP we add a note for PICs that have a PGM pin.
      if var.get("haspgmpin", False) == True:
         fusedef_insert("lvp", "ENABLED", "low voltage programming, pull pin_PGM LOW for normal operation")
      else:
         fusedef_insert("lvp", "ENABLED", "low voltage programming")
      fusedef_insert("mclr", "EXTERNAL", "external reset")
      fusedef_insert("mvecen", "DISABLED", "Do not use multi vectored interrupts")
      fusedef_insert("jtagen", "DISABLED", "no JTAG to enable all I/O pins")
      fp.write("--\n")
      fp.write("-- The configuration bit settings above are only a selection, sufficient\n")
      fp.write("-- for this program. Other programs may need more or different settings.\n")
      fp.write("--\n")

      if wdtword == "CONTROL":
         if "wdtcon_swdten" in var:
            fp.write("WDTCON_SWDTEN = OFF                 -- disable WDT\n")

      if (osctype == "HS")  | (osctype == "HS_32MHZ"):  # HS crystal / resonator
         if "osccon_scs" in var:
            fp.write("OSCCON_SCS = 0                      -- select primary oscillator\n")
         if "osctune_pllen" in var:
            fp.write("OSCTUNE_PLLEN = FALSE               -- no PLL\n")
      elif osctype == "INTOSC":                       # internal oscillator
         if "osccon_scs" in var:
            fp.write("OSCCON_SCS = 0                      -- select primary oscillator\n")
         if "oscfrq_frq3" in var:
            # MPLABX 6.20. Some newer PICx (e.g. 18FxxQ20) do not have an OSCFRQ_HFFRQ register
            # but a OSCFRQ register.
            if "oscfrq_hffrq" in var:
               fp.write("OSCFRQ_HFFRQ = 0b0010               -- Fosc 64 -> 4 MHz\n")
            else:
               fp.write("OSCFRQ = 0b0010                     -- Fosc 64 -> 4 MHz\n")
         elif "oscfrq_hffrq3" in var:
            # 4-bit HFFRQ register. For these PICs, check for OSCCON1_NOSC register is required
            # to the the correct frequency. But first check if we can use OSSCON1_NDIV instead.
            if "osccon1_ndiv" in var:
               fp.write("OSCCON1_NDIV = 0b0011               -- Fosc 32 / 8 -> 4 MHz\n")
            else:
               # Use the combination OSCFRQ_HFFRQ and OSCCON1_NOSC
               fp.write("OSCFRQ_HFFRQ = 0b0011               -- Fosc 32 -> ...\n")
               fp.write("OSCCON1_NOSC = 0b110                -- ... 4 MHz\n")
         elif "oscfrq_hffrq" in var:
            # 3-bit HFFRQ register.
            fp.write("OSCFRQ_HFFRQ = 0b010                -- Fosc 32 -> 4 MHz\n")
         elif "oscfrq_frq" in var:
            fp.write("OSCFRQ_FRQ = 0b010                  -- Fosc 32 -> 4 MHz\n")
         if "ircfwidth" in var:
            if (var["ircfwidth"] > 0) & ("OSCCON_IRCF" in picdata):
               fp.write("OSCCON_IRCF = 0b%-5s" % picdata["OSCCON_IRCF"] + "               -- 4 MHz\n")
         if "osctune_pllen" in var:
            fp.write("OSCTUNE_PLLEN = FALSE               -- no PLL\n")
         if "osccon_spllen" in var:
            fp.write("OSCCON_SPLLEN = FALSE               -- software PLL off\n")
      elif osctype == "HS_USB":                       # HS cryst./res. + USB
         if "osccon_scs" in var:
            fp.write("OSCCON_SCS = 0                      -- select primary oscillator\n")
         if "osctune_pllen" in var:
            fp.write("OSCTUNE_PLLEN = TRUE                -- PLL\n")
      elif osctype == "INTOSC_USB":                   # internal oscillator + USB
         if "osccon_scs" in var:
            fp.write("OSCCON_SCS = 0                      -- select primary oscillator\n")
         if "osctune_pllen" in var:
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
   return pgmname

def build_validate_compile_sample(pic, blink_pin, osctype, oscword, fusedef, var):
   """ Build, validate and compile a sample
       Check result of compile for no errors and warnings
   """
   pgmname = build_sample(pic, blink_pin, osctype, oscword, fusedef, var)
   if pgmname == None:
      print("   No blink-a-led sample for", pic)
      return False
   print(pgmname)
   if not validate_jalfile(os.path.join(dstdir, pgmname)):
      return False                                 # validate failed
   if not compile_sample(pgmname) == 0:            # zero returncode
      return False
   return True                                     # Everythng OK

def main(dev):
   """ Create one or more blink-a-led samples for this device file
       Return the number of error-free samples
   """
   def create_sample(dev, osctype, oscword):
      counter = 0
      picname = os.path.splitext(dev)[0]
      # Generate a sample for HS, INTOSC, USB
      if (osctype == "HS") | (osctype == "HS_32MHZ"):
         if build_validate_compile_sample(picname, blink_pin, osctype, oscword, fusedef, var):  # primary sample OK
            counter += 1
      elif ("ioscfs" in fusedef) & ("osc" not in fusedef): # Older PICs
         if "F4MHZ" in fusedef["ioscfs"]:
            if build_validate_compile_sample(picname, blink_pin, "INTOSC", "F4MHZ", fusedef, var):
               counter += 1
      elif "osc" in fusedef:
         # Build at most 2 internal oscillator variants, one without USB and one with (if present)
         if "INTOSC_NOCLKOUT" in fusedef["osc"]:  # no intosc + pll
            if build_validate_compile_sample(picname, blink_pin, "INTOSC", "INTOSC_NOCLKOUT", fusedef, var):
               counter += 1
         elif "INTOSC_NOCLKOUT_USB_HS" in fusedef["osc"]:  # intosc + pll
            if build_validate_compile_sample(picname, blink_pin, "INTOSC", "INTOSC_NOCLKOUT_USB_HS", fusedef, var):
               counter += 1
         elif "INTOSC_NOCLKOUT_PLL" in fusedef["osc"]:
            if build_validate_compile_sample(picname, blink_pin, "INTOSC_USB", "INTOSC_NOCLKOUT_PLL", fusedef, var):
               counter += 1
         elif "OFF" in fusedef["osc"]:
            if build_validate_compile_sample(picname, blink_pin, "INTOSC", "OFF", fusedef, var):
               counter += 1
         elif "fosc2" in fusedef:
            if "ON" in fusedef["fosc2"]:             # "implicit" fuse_def intosc
               if "EC_CLKOUT_PLL" in fusedef["osc"]:
                  if build_validate_compile_sample(picname, blink_pin, "INTOSC", "EC_CLKOUT_PLL", fusedef, var):
                     counter += 1
               elif "INTOSC_NOCLKOUT_PLL" in fusedef["osc"]:
                  if build_validate_compile_sample(picname, blink_pin, "INTOSC", "INTOSC_NOCLKOUT", fusedef, var):
                     counter += 1
         # The USB variant.
         if ("HS_PLL" in fusedef["osc"]) & ("usb_bdt" in var):
            if build_validate_compile_sample(picname, blink_pin, "HS_USB", "HS_PLL", fusedef, var):
               counter += 1
      return counter

   jalfile = os.path.join(devdir, dev)
   if not validate_jalfile(jalfile):               # device file does not validate
      return 0

   var, fusedef = scan_devfile(dev)                # selected device info and fuses
                                                   # builds also fusedef
   blink_pin = find_blinkpin(dev, var)
   if blink_pin == "":                             # no blink pin available
      return 0

   sample_count = 0

   if "osc" not in fusedef:                      # no fusedef osc at all
      osctype = "INTOSC"                         # must be internal oscillator
      if ("ioscfs" in fusedef) & ("f4mhz" in var):
         oscword = "f4mhz"
      else:
         oscword = ""                            # without fuse_def OSC
      sample_count += create_sample(dev, osctype, oscword)
   else:
      if "OFF" in fusedef["osc"]:                # 16f19155, etc. Check moved upward to have internal oscillator ...
         osctype = "INTOSC"                      # .. as preference before HS.
         oscword = "OFF"
         sample_count += create_sample(dev, osctype, oscword)
      if "INTOSC_NOCLKOUT" in fusedef["osc"]:     # First look for internal oscillator.
         osctype = "INTOSC"
         oscword = "INTOSC_NOCLKOUT"
         sample_count += create_sample(dev, osctype, oscword)
      if "HSH" in fusedef["osc"]:
         osctype = "HS"
         oscword = "HSH"
         sample_count += create_sample(dev, osctype, oscword)
      if "PRI" in fusedef["osc"]:
         osctype = "HS"
         oscword = "PRI"
         sample_count += create_sample(dev, osctype, oscword)
      if "HS" in fusedef["osc"]:
         osctype = "HS"
         oscword = "HS"
         sample_count += create_sample(dev, osctype, oscword)
      if ("HS_32MHZ" in fusedef["osc"]):
         osctype = "HS_32MHZ"
         oscword = "HS_32MHZ"
         sample_count += create_sample(dev, osctype, oscword)

   if sample_count == 0:
      print("   Could not create a blink-a-led sample for", dev)
      return 0                                     # skip this PIC

   return sample_count                             # number of generated samples



# ======== E N T R Y   P O I N T  =======================================

if __name__ == "__main__":
   """ Process commandline arguments, start process, clock execution time
   """

   if len(sys.argv) > 2:
      print("Expecting maximum 1 argument: PIC selection (wildcards)")
      print("==> When using wildcards, specify selection string between quotes")
      print("    or use the command 'set -f' to suppress wildcard expansion by the shell")
      sys.exit(1)
   if len(sys.argv) > 1:
      selection = sys.argv[1].lower()                 # device files: lower case names
   else:
      selection = "1*"
   if not selection.endswith(".jal"):
      selection += ".jal"                             # only .jal files

   print("Creating blink-a-led samples")
   start_time = time.time()
   devs = [x for x in os.listdir(devdir) if fnmatch.fnmatch(x, selection)]
   if not len(devs):
      print(f"No device files found matching {selection}")
      sys.exit(1)

   devs = sorted(devs)                                # alphanumeric order
   # Start a number of parallel processes
   with futures.ProcessPoolExecutor() as executor:
       results = executor.map(main, devs)             # for all selected PICs
       sample_count = sum(results)
   print(f"Generated {sample_count} blink-a-led samples")
   runtime = time.time() - start_time
   print(f"Runtime: {runtime:.1f} seconds")
   if runtime > 0:
      print(f"        ({sample_count/runtime:.2f} samples per second)")

#
