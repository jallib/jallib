#!/usr/bin/env python3
"""
Title: Create JalV2 device files for Microchip 8-bits flash PICs.

Author: Rob Hamerling, Copyright (c) 2014..2017, all rights reserved.

Adapted-by: Rob Jansen, Copyright (c) 2018..2018, all rights reserved.

Revision: $Revision$

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the BSD license https://www.opensource.org/licenses/bsd-license.php

Description:
  Python script to create device files for JALV2,
  and the file chipdef_jallib.jal, included by every device file.
  Primary information is obtained from the .pic files of MPLABX.
      Apart from declaration of all registers, register-subfields, ports
      and pins of the chip the device files contain shadowing procedures
      to prevent the 'read-modify-write' problems and use the LATx register
      (for PICs which have such registers) for output in stead of PORTx.
      In addition some device dependent procedures are provided
      for common operations, like enable_digital_io().
      Also various aliases are declared to 'normalize' the names of
      registers and bit fields, which makes it easier to build device
      independent libraries.
  Some additional information is collected via some Jallib tools files:
      - devicespecific.json - with PIC specific data
      - pinaliases.json     - with aliases for pins
                              (generated from MPLABX files).

Sources:  MPLABX .pic files, datasheets

Notes:
  - A summary of changes of this script is maintained in 'CHANGES.device'
        (not published, available on request).
  - MPLABX contains more .pic files than really exist!
    For example many low power PICs (LF-types) cannot be purchased!
    These PICs are not listed in the devicespecific.json, so there
    won't be device files created for these PICs.
  - This script can be processed by pydoc to obtain a html document:
       pydoc3 -w pic2jal
"""

from pic2jal_environment import check_and_set_environment

base, mplabxversion = check_and_set_environment()  # obtain environment variables
if (base == ""):
    exit(1)

import sys
import os
import fnmatch
import json
import re
import shutil
import time
from xml.dom.minidom import parse, Node

# --- basic working parameters
scriptauthor = "Rob Hamerling, Rob Jansen"
scriptversion = "1.1"       # script version
compilerversion = "2.5r2"   # latest JalV2 compiler version
jallib_contribution = True  # True: for jallib, False: for private use

# Additional file specifications
# paths may have to be adapted to local environment
picdir = os.path.join(base, "mplabx." + mplabxversion, "content", "edc")  # .pic files
pinaliasfile = os.path.join(base, "pinaliases.json")  # pin aliases
devspecfile = os.path.join(base, "devicespecific.json")  # some PIC properties not in MPLABX

# destination of device files depends on 1st commandline parameter

# --- global variables
cfgvar = {}  # collection of some PIC properties
# (needed before creating device file)
devspec = {}  # contents of devicespecific.json
pinaliases = {}  # contents of pinaliases.py
pinanmap = {}  # pin_ANx pins
sharedmem = []  # list if allocatable shared mem ranges
sfr_mirrors = {}  # base address + mirror addresses if any
names = []  # list of names of declared variables

# translation/normalisation of fusedef keywords
# Key = MPLABX cname, value = Jallib keyword
# All keywords are included also if the keywords in MPLABX and Jallib are the same.
fusedef_kwd = {"ABW": "ABW",
               "ADCSEL": "ADCSEL",
               "ADDRBW": "ABW",
               "BACKBUG": "DEBUG",
               "BBEN": "BBEN",
               "BBSIZ": "BBSIZ",
               "BBSIZE": "BBSIZ",
               "BOD": "BROWNOUT",
               "BODENV": "VOLTAGE",
               "BOR": "BROWNOUT",
               "BOR4V": "VOLTAGE",
               "BOREN": "BROWNOUT",
               "BORPWR": "BORPWR",
               "BORSEN": "BORSEN",
               "BORV": "VOLTAGE",
               "BW": "DBW",
               "CANMX": "CANMUX",
               "CCP2MUX": "CCP2MUX",
               "CCP2MX": "CCP2MUX",
               "CCP3MX": "CCP3MUX",
               "CCPMX": "CCP1MUX",
               "CFGPLLEN": "PLLEN",
               "CINASEL": "CINASEL",
               "CLKOEC": "CLKOEC",
               "CLKOEN": "CLKOUTEN",
               "CLKOUTEN": "CLKOUTEN",
               "CP": "CP",
               "CP0": "CP0",
               "CP1": "CP1",
               "CP2": "CP2",
               "CP3": "CP3",
               "CP4": "CP4",
               "CP5": "CP5",
               "CP6": "CP6",
               "CP7": "CP7",
               "CPB": "CPB",
               "CPD": "CPD",
               "CPDF": "CPD",
               "CPUDIV": "CPUDIV",
               "CSWEN": "CSWEN",
               "DATABW": "DBW",
               "DEBUG": "DEBUG",
               "DSBITEN": "DSBITEN",
               "DSBOREN": "BROWNOUT",
               "DSWDTEN": "DSWDTEN",
               "DSWDTOSC": "DSWDTOSC",
               "DSWDTPS": "DSWDTPS",
               "EASHFT": "EASHFT",
               "EBTR": "EBTR",
               "EBTR0": "EBTR0",
               "EBTR1": "EBTR1",
               "EBTR2": "EBTR2",
               "EBTR3": "EBTR3",
               "EBTR4": "EBTR4",
               "EBTR5": "EBTR5",
               "EBTR6": "EBTR6",
               "EBTR7": "EBTR7",
               "EBTRB": "EBTRB",
               "ECCPMX": "ECCPMUX",
               "ETHLED": "ETHLED",
               "EXCLKMX": "EXCLKMUX",
               "FCMEN": "FCMEN",
               "FEXTOSC": "OSC",
               "FLTAMX": "FLTAMUX",
               "FOSC": "OSC",
               "FOSC0": "OSC",
               "FOSC2": "FOSC2",
               "FSCM": "FCMEN",
               "HFOFST": "HFOFST",
               "HPOL": "HPOL",
               "ICPRT": "ICPRT",
               "IESO": "IESO",
               "INTOSCSEL": "INTOSCSEL",
               "IOL1WAY": "IOL1WAY",
               "IOSCFS": "IOSCFS",
               "IVT1WAY": "IVT1WAY",
               "LCDPEN": "LCDPEN",
               "LPBOR": "LPBOR",
               "LPBOREN": "LPBOREN",
               "LPOL": "LPOL",
               "LPT1OSC": "LPT1OSC",
               "LS48MHZ": "LS48MHZ",
               "LVP": "LVP",
               "MCLRE": "MCLR",
               "MCPU": "MCPU",
               "MODE": "PMODE",
               "MSSP7B_EN": "MSSPMASK",
               "MSSPMSK": "MSSPMASK",
               "MSSPMSK1": "MSSPMSK1",
               "MSSPMSK2": "MSSPMSK2",
               "MVECEN": "MVECEN",
               "NLPBOR": "LPBOR",
               "NPWRTEN": "PWRTE",
               "OSC": "OSC",
               "OSCS": "OSCS",
               "P2BMX": "P2BMUX",
               "PBAD": "PBADEN",
               "PBADEN": "PBADEN",
               "PCLKEN": "PCLKEN",
               "PLLCFG": "PLLEN",
               "PLLDIV": "PLLDIV",
               "PLLEN": "PLLEN",
               "PLLMULT": "PLLMULT",
               "PLLSEL": "PLLSEL",
               "PM": "PMODE",
               "PMPMX": "PMPMUX",
               "POSCMD": "POSCMD",
               "PPS1WAY": "PPS1WAY",
               "PR1WAY": "PR1WAY",
               "PRICLKEN": "PCLKEN",
               "PUT": "PWRTE",
               "PWM4MX": "PWM4MUX",
               "PWMPIN": "PWMPIN",
               "PWRT": "PWRTE",
               "PWRTE": "PWRTE",
               "PWRTEN": "PWRTE",
               "PWRTS": "PWRTS",
               "RETEN": "RETEN",
               "RSTOSC": "RSTOSC",
               "RTCOSC": "RTCOSC",
               "RTCSOSC": "RTCOSC",
               "SAFEN": "SAFEN",
               "SCANE": "SCANE",
               "SDOMX": "SDOMUX",
               "SOSCSEL": "SOSCSEL",
               "SSPMX": "SSPMUX",
               "STVR": "STVR",
               "STVREN": "STVR",
               "T0CKMX": "T0CKMUX",
               "T1DIG": "T1DIG",
               "T1OSCMX": "T1OSCMUX",
               "T3CKMX": "T3CKMUX",
               "T3CMX": "T3CKMUX",
               "T5GSEL": "T5GSEL",
               "USBDIV": "USBDIV",
               "USBLSCLK": "USBLSCLK",
               "VBATEN": "VBATEN",
               "VBTBOR": "VBTBOR",
               "VCAPEN": "VCAPEN",
               "VREGEN": "VREGEN",
               "WAIT": "WAIT",
               "WDPS": "WDTPS",
               "WDT": "WDT",
               "WDTCCS": "WDTCCS",
               "WDTCLK": "WDTCLK",
               "WDTCPS": "WDTCPS",
               "WDTCWS": "WDTCWS",
               "WDTE": "WDT",
               "WDTEN": "WDT",
               "WDTWIN": "WDTWIN",
               "WDTPS": "WDTPS",
               "WINEN": "WINEN",
               "WINDIS": "WINDIS",
               "WPCFG": "WPCFG",
               "WPDIS": "WPDIS",
               "WPEND": "WPEND",
               "WPFP": "WPFP",
               "WPSA": "WPSA",
               "WRT": "WRT",
               "WRT0": "WRT0",
               "WRT1": "WRT1",
               "WRT2": "WRT2",
               "WRT3": "WRT3",
               "WRT4": "WRT4",
               "WRT5": "WRT5",
               "WRT6": "WRT6",
               "WRT7": "WRT7",
               "WRTAPP": "WRTAPP",
               "WRTB": "WRTB",
               "WRTC": "WRTC",
               "WRTD": "WRTD",
               "WRTEN": "WRT",
               "WRTSAF": "WRTSAF",
               "WURE": "WURE",
               "XINST": "XINST",
               "ZCD": "ZCD",
               "ZCDDIS": "ZCD"}

# Translation/normalisation of fusedef OSC keywords.
# Key = MPLABX cname, value = Jallib keyword
# This dictionary has exceptions which must be handled by the code
fusedef_osc = {"EC": "EC_CLKOUT",
               "EC1": "ECL_NOCLKOUT",
               "EC1IO": "ECL_CLKOUT",
               "EC2": "ECM_NOCLKOUT",
               "EC2IO": "ECM_CLKOUT",
               "EC3": "ECH_NOCLKOUT",
               "EC3IO": "ECH_CLKOUT",
               "ECCLK": "EC_CLKOUT",
               "ECCLKOUTH": "ECH_CLKOUT",
               "ECCLKOUTL": "ECL_CLKOUT",
               "ECCLKOUTM": "ECM_CLKOUT",
               "ECH": "ECH_NOCLKOUT",
               "ECHCLKO": "ECH_CLKOUT",
               "ECHIO": "ECH_NOCLKOUT",
               "ECHP": "ECH_CLKOUT",
               "ECHPIO6": "ECH_NOCLKOUT",
               "ECIO": "EC_NOCLKOUT",
               "ECIO6": "EC_NOCLKOUT",
               "ECIOPLL": "EC_NOCLKOUT_PLL_HW",
               "ECIOSWPLL": "EC_NOCLKOUT_PLL_SW",
               "ECIO_EC": "EC_NOCLKOUT",
               "ECL": "ECL_NOCLKOUT",
               "ECLCLKO": "ECL_CLKOUT",
               "ECLIO": "ECL_NOCLKOUT",
               "ECLP": "ECL_CLKOUT",
               "ECLPIO6": "ECL_NOCLKOUT",
               "ECM": "ECM_NOCLKOUT",
               "ECMCLKO": "ECM_CLKOUT",
               "ECMIO": "ECM_NOCLKOUT",
               "ECMP": "ECM_CLKOUT",
               "ECMPIO6": "ECM_NOCLKOUT",
               "ECPLL": "EC_CLKOUT_PLL",
               "ECPLLIO_EC": "EC_NOCLKOUT_PLL",
               "ECPLL_EC": "EC_CLKOUT_PLL",
               "EC_EC": "EC_CLKOUT",
               "EC_OSC": "EC_NOCLKOUT",
               "ERC": "RC_NOCLKOUT",
               "ERCCLKOUT": "RC_CLKOUT",
               "ERCLK": "RC_CLKOUT",
               "ERIO": "RC_NOCLKOUT",
               "EXTRC": "RC_NOCLKOUT",
               "EXTRCCLK": "RC_CLKOUT",
               "EXTRCIO": "RC_NOCLKOUT",
               "EXTRC_CLKOUT": "RC_CLKOUT",
               "EXTRC_CLKOUTEN": "RC_CLKOUT",
               "EXTRC_IO": "RC_NOCLKOUT",
               "EXTRC_NOCLKOUT": "RC_NOCLKOUT",
               "EXTRC_RB4": "RC_NOCLKOUT",
               "EXTRC_RB4EN": "RC_NOCLKOUT",
               "FRC": "INTOSC_NOCLKOUT",
               "FRC500KHZ": "INTOSC_500KHZ",
               "FRCDIV": "INTOSC_DIV",
               "FRCPLL": "INTOSC_NOCLKOUT_PLL",
               "HS": "HS",
               "HS1": "HSM",
               "HS2": "HSH",
               "HSH": "HSH",
               "HSHP": "HSH",
               "HSM": "HSM",
               "HSMP": "HSM",
               "HSPLL": "HS_PLL",
               "HSPLL_HS": "HS_PLL",
               "HSSWPLL": "HS_PLL_SW",
               "HS_OSC": "HS",
               "INT": "INTOSC_NOCLKOUT",
               "INTIO1": "INTOSC_CLKOUT",
               "INTIO2": "INTOSC_NOCLKOUT",
               "INTIO67": "INTOSC_NOCLKOUT",
               "INTIO7": "INTOSC_CLKOUT",
               "INTOSC": "INTOSC_NOCLKOUT",
               "INTOSCCLK": "INTOSC_CLKOUT",
               "INTOSCCLKO": "INTOSC_CLKOUT",
               "INTOSCIO": "INTOSC_NOCLKOUT",
               "INTOSCIO_EC": "INTOSC_NOCLKOUT_USB_EC",
               "INTOSCO": "INTOSC_CLKOUT",
               "INTOSCPLL": "INTOSC_NOCLKOUT_PLL",
               "INTOSCPLLO": "INTOSC_CLKOUT_PLL",
               "INTOSC_EC": "INTOSC_CLKOUT_USB_EC",
               "INTOSC_HS": "INTOSC_NOCLKOUT_USB_HS",
               "INTOSC_XT": "INTOSC_NOCLKOUT_USB_XT",
               "INTRC": "INTOSC_NOCLKOUT",
               "INTRCCLK": "INTOSC_CLKOUT",
               "INTRCIO": "INTOSC_NOCLKOUT",
               "INTRC_CLKOUT": "INTOSC_CLKOUT",
               "INTRC_CLKOUTEN": "INTOSC_CLKOUT",
               "INTRC_IO": "INTOSC_NOCLKOUT",
               "INTRC_NOCLKOUT": "INTOSC_NOCLKOUT",
               "INTRC_RB4": "INTOSC_NOCLKOUT",
               "INTRC_RB4EN": "INTOSC_NOCLKOUT",
               "IRC": "INTOSC_CLKOUT",
               "IRCCLKOUT": "INTOSC_CLKOUT",
               "IRCIO": "INTOSC_NOCLKOUT",
               "IRCIO67": "INTOSC_NOCLKOUT",
               "IRCIO7": "INTOSC_CLKOUT",
               "LP": "LP",
               "LPRC": "INTOSC_LP",
               "LP_OSC": "LP",
               "OFF": "OFF",
               "PRI": "PRI",
               "PRIPLL": "PRI_PLL",
               "RC": "RC_CLKOUT",
               "RC1": "RC_CLKOUT",
               "RC2": "RC_CLKOUT",
               "RCCLKO": "RC_CLKOUT",
               "RCIO": "RC_NOCLKOUT",
               "RCIO6": "RC_NOCLKOUT",
               "SOSC": "SEC",
               "XT": "XT",
               "XTPLL_XT": "XT_PLL",
               "XT_OSC": "XT",
               "XT_XT": "XT"}

# Translation/normalisation of fusedef PLLDIV keywords
# Key = MPLABX cname, value = Jallib keyword
fusedef_plldiv = {"RESERVED": "   ",
                  "NOPLL": "X1",
                  "NODIV": "P1",
                  "1": "P1",
                  "DIV2": "P2",
                  "2": "P2",
                  "DIV3": "P3",
                  "3": "P3",
                  "DIV4": "P4",
                  "4": "P4",
                  "DIV5": "P5",
                  "5": "P5",
                  "DIV6": "P6",
                  "6": "P6",
                  "DIV10": "P10",
                  "10": "P10",
                  "DIV12": "P12",
                  "12": "P12",
                  "PLL4X": "X4",
                  "PLL6X": "X6",
                  "PLL8X": "X8"}


def list_copyright(fp):
    """ Add copyright, etc to header in device files and chipdef_jallib

   Input:   filespec of destination file
   Returns: nothing
   """
    fp.write("--\n")
    yyyy = time.ctime().split()[-1]
    fp.write("-- Author: " + scriptauthor + ", Copyright (c) 2008.." + yyyy +
             " all rights reserved.\n" +
             "--\n" +
             "-- Adapted-by: N/A (generated file, do not change!)\n" +
             "--\n" +
             "-- Compiler: " + compilerversion + "\n" +
             "--\n")
    if (jallib_contribution == True):
        fp.write("-- This file is part of jallib (https://github.com/jallib/jallib)\n")
    else:
        fp.write("-- This file is following Jallib-style (https://github.com/jallib/jallib)\n")

    fp.write("-- Released under the ZLIB license" +
             " (http://www.opensource.org/licenses/zlib-license.html)\n--\n")


def list_chipdef_header(fp):
    """ List common constants in chipdef_jallib.jal

   Input:   filespec of destination file
   Returns: nothing
   """
    list_separator(fp)
    if (jallib_contribution == True):
        fp.write("-- Title: Common Jallib include file for device files\n")
    else:
        fp.write("-- Title: Common Jallib-style include file for device files\n")
    list_copyright(fp)  # insert copyright and other info
    fp.write("-- Sources:\n" +
             "--\n" +
             "-- Description:\n")
    if (jallib_contribution == True):
        fp.write("--    Common Jallib include file for device files\n")
    else:
        fp.write("--    Common Jallib-style include file for device files\n")
    fp.write("--\n" +
             "-- Notes:\n" +
             "--    - This file is generated by <pic2jal.py> script version " + scriptversion + "\n" +
             "--    - File creation date/time: " + time.ctime() + "\n" +
             "--    - Based on MPLABX " + mplabxversion + "\n" +
             "--\n")
    list_separator(fp)
    fp.write("--\n" +
             "-- JalV2 compiler required constants\n" +
             "--\n" +
             "const       PIC_12            = 1\n" +
             "const       PIC_14            = 2\n" +
             "const       PIC_16            = 3\n" +
             "const       SX_12             = 4\n" +
             "const       PIC_14H           = 5\n" +
             "--\n" +
             "const bit   PJAL              = 1\n" +
             "--\n" +
             "const byte  W                 = 0\n" +
             "const byte  F                 = 1\n" +
             "--\n" +
             "include  constants_jallib                     -- common Jallib library constants\n" +
             "--\n")
    list_separator(fp)
    fp.write("--\n" +
             "-- A value assigned to const 'target_chip' by\n" +
             "--    'pragma target chip' in device files\n" +
             "-- can be used for conditional compilation, for example:\n" +
             "--    if (target_chip == PIC_16F88) then\n"
             "--      ....                                  -- for 16F88 only\n" +
             "--    endif\n" +
             "--\n")
    list_separator(fp)


def list_devicefile_header(fp, picfile):
    """ Generate common header

   Input:   - destination file
            - pic filename
   Returns: nothing
   Notes:   - Shared memory for _pic_accum and _pic_isr_w is allocated:
              - for core 12, 14 and 14H from high to low address
              - for core 16 from low to high address
   """
    picname = os.path.splitext(os.path.basename(picfile))[0][3:].lower()
    subdir = os.path.split(os.path.split(picfile)[0])[1]
    list_separator(fp)
    fp.write("-- Title: JalV2 device include file for " + picname + "\n")
    list_copyright(fp)
    fp.write("-- Description:\n" +
             "--    Device include file for pic" + picname + ", containing:\n" +
             "--    - Declaration of ports and pins of the chip.\n")
    if (cfgvar["haslat"] == True):
        fp.write("--    - Procedures to force the use of the LATx register\n" +
                 "--      for output when PORTx or pin_xy is addressed.\n")
    else:
        fp.write("--    - Procedures for shadowing of ports and pins\n" +
                 "--      to circumvent the read-modify-write problem.\n")
    fp.write("--    - Symbolic definitions for configuration bits (fuses)\n" +
             "--    - Some device dependent procedures for common\n" +
             "--      operations, like:\n" +
             "--      . enable_digital_io()\n" +
             "--\n" +
             "-- Sources:\n" +
             "--  - {Microchip\MPLABX V" + mplabxversion + " \packs\Microchip}/" +
             "content/edc/" + subdir + "/pic" + picname + ".pic\n" +
             "--\n" +
             "-- Notes:\n" +
             "--  - This file is generated by <pic2jal.py> script version " + scriptversion + "\n" +
             "--  - File creation date/time: " + time.ctime() + "\n" +

             "--\n")
    list_separator(fp)
    fp.write("--\n" +
             "const  word  DEVICE_ID   = 0x%04X" % (cfgvar["devid"]) + "            -- ID for PIC programmer\n" +
             "const  word  CHIP_ID     = 0x%04X" % (cfgvar["procid"]) + "            -- ID in chipdef_jallib\n" +
             "const  byte  PICTYPE[]   = \"" + picname.upper() + "\"\n")
    picdata = dict(list(devspec[picname.upper()].items()))
    fp.write("--\n" +
             "include chipdef_jallib                  -- common constants\n" +
             "--\n" +
             "pragma  target  cpu        PIC_" + cfgvar["core"] + "        -- (banks=%d)\n" % cfgvar["numbanks"] +
             "pragma  target  chip       " + picname.upper() + "\n" +
             "pragma  target  bank       0x%04X\n" % cfgvar["banksize"])
    # Pragma for number of banks is only needed for the compiler when more than 32 banks for PIC with core 14H.
    if (cfgvar["core"] == '14H') & (cfgvar["numbanks"] > 32):
        fp.write("pragma  target  numbanks   %d\n" % cfgvar["numbanks"])
    if cfgvar["pagesize"] > 0:
        fp.write("pragma  target  page       0x%04X\n" % cfgvar["pagesize"])
    fp.write("pragma  stack              %d\n" % cfgvar["hwstack"])
    if cfgvar["osccal"] > 0:
        fp.write("pragma  code               %d" % (cfgvar["codesize"] - 1) + " " * 15 + "-- (excl high mem word)\n")
    else:
        fp.write("pragma  code               %d\n" % cfgvar["codesize"])
    if "eeaddr" in cfgvar:
        fp.write("pragma  eeprom             0x%X,%d\n" % (cfgvar["eeaddr"], cfgvar["eesize"]))
    if "idaddr" in cfgvar:
        fp.write("pragma  ID                 0x%X,%d\n" % (cfgvar["idaddr"], cfgvar["idsize"]))
    if "DATA" in picdata:
        fp.write("pragma  data               " + picdata["DATA"] + "\n")
        print("   pragma data overruled by specification in devicespecific")
    else:
        for i in range(0, len(cfgvar["datarange"]), 5):  # max 5 ranges per line
            y = cfgvar["datarange"][i: i + 5]
            fp.write("pragma  data               " + ",".join(("0x%X-0x%X" % (r[0], r[1] - 1)) for r in y) + "\n")
    fp.write("pragma  shared             ")
    global sharedmem
    sharedmem = []  # clear
    if "SHARED" in picdata:
        print("   pragma shared overruled by specification in devicespecific")
        fp.write(picdata["SHARED"] + "\n")
        x = picdata["SHARED"].split("-", 1)
        sharedmem.append(eval(x[0]))
        sharedmem.append(eval(x[1]))
    else:
        if (cfgvar["core"] == '16'):  # add high range of access bank
            fp.write("0x%X-0x%X,0xF%X-0xFFF\n" %
                     (cfgvar["sharedrange"][0],
                      (cfgvar["sharedrange"][-1] - 1),
                      cfgvar["accessbanksplitoffset"]))
        elif (cfgvar["core"] == "14H"):  # add core register memory
            fp.write("0x00-0x0B,0x%X-0x%X\n" %
                     (cfgvar["sharedrange"][0],
                      (cfgvar["sharedrange"][-1] - 1)))
        elif (picname == "12f510"):  # special
            fp.write("0x00-0x09,0x%X-0x%X\n" %
                     (cfgvar["sharedrange"][0],
                      (cfgvar["sharedrange"][-1] - 1)))
        elif (picname == "16f506"):  # special
            fp.write("0x00-0x0C,0x%X-0x%X\n" %
                     (cfgvar["sharedrange"][0],
                      (cfgvar["sharedrange"][-1] - 1)))
        else:
            fp.write("0x%X-0x%X\n" %
                     (cfgvar["sharedrange"][0],
                      cfgvar["sharedrange"][-1] - 1))
        sharedmem = list(cfgvar["sharedrange"])  # take a workcopy for allocation
        sharedmem[1] = sharedmem[1] - 1  # high address
    fp.write("--\n")
    sharedmem_avail = sharedmem[1] - sharedmem[0] + 1  # incl upper bound
    if (cfgvar["core"] == "12") | (cfgvar["core"] == "14"):
        if sharedmem_avail < 2:
            print("   At least 2 bytes of shared memory required! Found:", sharedmem_avail)
        else:
            fp.write("var volatile byte _pic_accum at 0x%X" % sharedmem[1] + "      -- (compiler)\n")
            sharedmem[1] = sharedmem[1] - 1
            fp.write("var volatile byte _pic_isr_w at 0x%X" % sharedmem[1] + "      -- (compiler)\n")
            sharedmem[1] = sharedmem[1] - 1
    else:  # core 14H or 16
        if sharedmem_avail < 1:
            print("   At least 1 byte of shared memory required! Found:", sharedmem_avail)
        elif (cfgvar["core"] == "14H"):
            fp.write("var volatile byte _pic_accum at 0x%X" % sharedmem[1] + "      -- (compiler)\n")
            sharedmem[1] = sharedmem[1] - 1
        else:  # 16-bits core
            fp.write("var volatile byte _pic_accum at 0x%X" % sharedmem[0] + "      -- (compiler)\n")
            sharedmem[0] = sharedmem[0] + 1
    fp.write("--\n")


def list_config_memory(fp):
    """ Generate configuration memory declaration and defaults

   Input:   - picname
            - output file
   Output:  part of device files
   Returns: (nothing)
   """
    fp.write("const word   _FUSES_CT             = " + "%d" % cfgvar["fusesize"] + "\n")
    if cfgvar["fusesize"] == 1:  # single word: only with baseline/midrange
        fp.write("const word   _FUSE_BASE            = 0x%X" % cfgvar["fuseaddr"] + "\n")
        fp.write("const word   _FUSES                = 0x%X" % cfgvar["fusedefault"][0] + "\n")
    else:
        if cfgvar["core"] != "16":
            fp.write("const word   _FUSE_BASE[_FUSES_CT] = { 0x%X" % cfgvar["fuseaddr"])
        else:
            fp.write("const byte*3 _FUSE_BASE[_FUSES_CT] = { 0x%X" % cfgvar["fuseaddr"])
        for i in range(cfgvar["fusesize"] - 1):
            fp.write(",\n" + " " * 39 + "0x%X" % (cfgvar["fuseaddr"] + i + 1))
        fp.write(" }\n")
        if cfgvar["core"] != "16":
            fp.write("const word   _FUSES[_FUSES_CT]     = { 0x%04X," % (cfgvar["fusedefault"][0]) +
                     " " * 10 + "-- CONFIG1\n")
            for i in range(cfgvar["fusesize"] - 2):
                fp.write(" " * 39 + "0x%04X" % (cfgvar["fusedefault"][i + 1]) + "," +
                         " " * 10 + "-- CONFIG" + "%d" % (i + 2) + "\n")
            fp.write(" " * 39 + "0x%04X" % (cfgvar["fusedefault"][-1]) + " }" +
                     " " * 9 + "-- CONFIG" + "%d\n" % (cfgvar["fusesize"]))
        else:
            fp.write("const byte   _FUSES[_FUSES_CT]     = { 0x%02X," % (cfgvar["fusedefault"][0]) +
                     " " * 10 + "-- CONFIG1L" + "\n")
            for i in range(cfgvar["fusesize"] - 2):
                fp.write(" " * 39 + "0x%02X," % (cfgvar["fusedefault"][i + 1]) +
                         " " * 10 + "-- CONFIG" + "%d" % ((i + 3) / 2) + "HL"[i % 2] + "\n")
            fp.write(" " * 39 + "0x%02X }" % (cfgvar["fusedefault"][-1]) +
                     " " * 9 + "-- CONFIG" + "%d" % (cfgvar["fusesize"] / 2) + "H\n")
    fp.write("--\n")


def list_osccal(fp):
    """ Generate oscillator calibration instructions

   Input:   - picname
            - output file
   Output:  part of device files
   Returns: (nothing)
   Notes:   - Only for PICs with OSCCAL
            - Only safe for 12-bits core
            - Code for 14-bits core is present but disabled!
   """
    if cfgvar["osccal"] > 0:  # PIC has OSCCAL register
        if cfgvar["core"] == '12':  # 10F2xx, some 12F5xx, 16f5xx
            fp.write("var volatile byte   osccal__  at  0x%x" % cfgvar["osccal"] + "\n")
            if cfgvar["numbanks"] > 1:
                fp.write("var volatile byte   fsr__     at  0x%x" % cfgvar["fsr"] + "\n")
                fp.write("asm          bcf    fsr__,5                  -- select bank 0\n")
                if cfgvar["numbanks"] > 2:
                    fp.write("asm          bcf    fsr__,6                  --   \"     \"\n")
            fp.write("asm          movwf  osccal__                 -- calibrate INTOSC\n")
            fp.write("--\n")
        """
      # This part is disabled because of risc of reset-loop when
      # uppermost byte of code memory doesn't contain return instruction
      elif cfgvar["core"] == '14':                          # 12F629/675, 16F630/676
         fp.write("var  volatile byte   osccal__  at  0x%x" % cfgvar["osccal"] + "\n")
         fp.write("asm  page     call   0x%x" % (cfgvar["codesize"]-1) + " "*15 + "-- fetch calibration value\n")
         fp.write("asm  bank     movwf  osccal__            -- calibrate INTOSC\n")
         fp.write("--\n")
      """


def list_all_sfr(fp, root):
    """ Generate declarations of special function registers, pins, etc.

   Input:   - output file
            - root of .pic (xml parsed structure)
   Output:  part of device files
   Returns: (nothing)
   Notes:   - skip SFRs with 'ExtendedModeOnly' parent
   """
    sfrdatasectors = root.getElementsByTagName("edc:SFRDataSector")
    for sfrdatasector in sfrdatasectors:
        if (sfrdatasector.parentNode.nodeName != "edc:ExtendedModeOnly"):
            if len(sfrdatasector.childNodes) > 0:
                child = sfrdatasector.firstChild
                list_sfrdata_child(fp, child)
                while child.nextSibling:
                    child = child.nextSibling
                    list_sfrdata_child(fp, child)


def list_sfrdata_child(fp, child):
    """ Generate declaration of a single SFR or a joined SFR with individual SFRs

   Input:   - output file
            - SFRDef node
            - current SFR addr
   Output:  part of device file
   Returns: (nothing)
   Notes:   - MuxedSFRDef can exist within JoinedSFRDef
            - JoinedSFR is at least and mostly 2 bytes wide, but can be wider.

   """
    if (child.nodeType == Node.ELEMENT_NODE):
        if (child.nodeName == "edc:SFRDef"):
            list_sfr(fp, child)
        elif (child.nodeName == "edc:JoinedSFRDef"):
            reg = child.getAttribute("edc:cname")
            width = max(2, (eval(child.getAttribute("edc:nzwidth")) + 7) // 8)  # round to # bytes
            if (width < 3):  # maybe not correct: check
                width_chk = len(child.getElementsByTagName("edc:MuxedSFRDef"))
                if (width_chk == 0):  # no muxed SFRs
                    width_chk = len(child.getElementsByTagName("edc:SFRDef"))  # regular SFRs
                width = max(width, width_chk)  # take largest
            sfraddr = eval(child.getAttribute("edc:_addr"))
            list_separator(fp)
            list_variable(fp, reg, width, sfraddr)
            list_multi_module_register_alias(fp, child)
            if (reg in ("FSR0", "FSR1", "PCLAT", "TABLAT", "TBLPTR")):
                list_variable(fp, "_" + reg.lower(), width, sfraddr)  # compiler required name
            if (len(child.childNodes) > 0):
                gchild = child.firstChild
                if (gchild.nodeName == "edc:MuxedSFRDef"):
                    selectsfrs = gchild.getElementsByTagName("edc:SelectSFR")
                    for selectsfr in selectsfrs:
                        list_muxed_sfr(fp, selectsfr)
                elif (gchild.nodeName == "edc:SFRDef"):
                    list_sfr(fp, gchild)
                while gchild.nextSibling:
                    gchild = gchild.nextSibling
                    if (gchild.nodeName == "edc:MuxedSFRDef"):
                        selectsfrs = gchild.getElementsByTagName("edc:SelectSFR")
                        for selectsfr in selectsfrs:
                            list_muxed_sfr(fp, selectsfr)
                    elif (gchild.nodeName == "edc:SFRDef"):
                        list_sfr(fp, gchild)
        elif (child.nodeName == "edc:MuxedSFRDef"):
            selectsfrs = child.getElementsByTagName("edc:SelectSFR")
            for selectsfr in selectsfrs:
                list_muxed_sfr(fp, selectsfr)


def list_sfr(fp, sfr):
    """ Generate declaration of a single register (and its bitfields)

   Input:   - output file
            - SFRDef node
            - current SFR addr
   Output:  part of device files
   Returns: (nothing)
   """
    picname = cfgvar["picname"]
    list_separator(fp)
    sfrname = sfr.getAttribute("edc:cname")
    sfraddr = eval(sfr.getAttribute("edc:_addr"))
    if (sfrname.startswith("TMR") & sfrname.endswith("L")):
        if (sfrname[0:-1] not in names):  # missing word for 16-bits timer
            list_variable(fp, sfrname[0:-1], 2, sfraddr)
            list_separator(fp)
    if not ((sfrname == "GPIO") | ((sfrname.startswith("PORT")) & (sfrname != "PORTVP"))):
        list_variable(fp, sfrname, 1, sfraddr)  # not a port
    if ((sfrname.startswith("LAT")) & (sfrname != "LATVP")):
        if ("PORT" + sfrname[-1] in names):  # PORTx < LATx
            list_lat_shadow(fp, sfrname)
    elif ((sfrname.startswith("PORT")) & (sfrname != "PORTVP")):
        if ((sfrname == "PORTB") & (picname.startswith("12"))):
            print("   PORTB register interpreted as GPIO / PORTA")
            list_variable(fp, "GPIO_", 1, sfraddr)
            list_alias(fp, "PORTA_", "GPIO_")
            list_port_shadow(fp, "PORTA")
        elif (cfgvar["haslat"] == False):
            list_variable(fp, sfrname + "_", 1, sfraddr)
            list_port_shadow(fp, sfrname)
        elif ((cfgvar["haslat"] == True) & ("LAT" + sfrname[-1] in names)):  # LATx < PORTx
            list_variable(fp, sfrname, 1, sfraddr)
            list_lat_shadow(fp, sfrname)
        else:
            list_variable(fp, sfrname, 1, sfraddr)
    elif (sfrname == "GPIO"):
        list_variable(fp, "GPIO_", 1, sfraddr)
        list_alias(fp, "PORTA_", "GPIO_")
        list_port_shadow(fp, "PORTA")
    elif (sfrname in ("SPBRG", "SPBRG1", "SP1BRG")):
        width = eval(sfr.getAttribute("edc:nzwidth"))
        if ((width == 8) & ("SPBRGL" not in names)):
            list_alias(fp, "SPBRGL", sfrname)
    elif (sfrname in ("SPBRG2", "SP2BRG")):
        if ("SPBRGL2" not in names):
            list_alias(fp, "SPBRGL2", sfrname)
    elif sfrname in ("TRISIO", "TRISGPIO"):
        list_alias(fp, "TRISA", sfrname)
        list_alias(fp, "PORTA_direction", sfrname)
        list_tris_nibbles(fp, "TRISA")
    elif ((sfrname.startswith("TRIS")) & (sfrname != "TRISVP")):
        list_alias(fp, "PORT" + sfrname[-1] + "_direction", sfrname)
        list_tris_nibbles(fp, sfrname)

    modelist = sfr.getElementsByTagName("edc:SFRMode")
    for mode in modelist:
        modeid = mode.getAttribute("edc:id")
        if modeid.startswith(("DS.", "LT.")):
            if (len(mode.childNodes) > 0):
                child = mode.firstChild
                offset = list_sfr_subfield(fp, child, sfrname, 0)
                while (child.nextSibling):
                    child = child.nextSibling
                    offset = list_sfr_subfield(fp, child, sfrname, offset)

    #  Adding missing bitfields:
    if ((sfrname in ("SSPCON1", "SSP1CON1", "SSP2CON1")) &
            (sfrname + "_SSPM" not in names) & (sfrname + "_SSPM3" in names)):
        list_bitfield(fp, sfrname + "_SSPM", 4, sfrname, 0)

    #  Special cases:
    list_multi_module_register_alias(fp, sfr)

    #  Special for compiler internal naming conventions:
    if sfrname in ("BSR",
                   "FSR", "FSR0L", "FSR0H", "FSR1L", "FSR1H",
                   "IND", "INDF", "INDF0",
                   "PCL", "PCLATH", "PCLATU",
                   "STATUS",
                   "TABLAT", "TBLPTR", "TBLPTRH", "TBLPTRL", "TBLPTRU"):
        if sfrname in ("INDF", "INDF0"):
            sfrname = "IND"  # compiler wants '_ind'
        list_variable(fp, "_" + sfrname.lower(), 1, sfraddr)  # compiler required name
        if (sfrname == "STATUS"):
            list_status_sfr(fp, sfr)  # compiler required additions


def list_sfr_subfield(fp, child, sfrname, offset):
    """ Generate declaration of a register subfield

   Input:   - output file
            - SFRDef child node
            - SFR name
            - field offset
   Output:
   Returns: offset next child
   Notes:   - bitfield
            - pin_A3 and pin_E3 are frequently MCLR pins and read only,
              and then declared under PORTA/E, rather than LATA/E.
            - some configuration info collected
   """
    global cfgvar
    if (child.nodeType == Node.ELEMENT_NODE):
        if (child.nodeName == "edc:AdjustPoint"):
            picname = cfgvar["picname"]
            if ((offset == 0) & (picname in ("18f13k50", "18lf13k50", "18f14k50", "18lf14k50",
                                             "16f1454", "16f1455", "16f1459",
                                             "16lf1454", "16lf1455", "16lf1459"))):
                if ((sfrname == "LATA") & ("pin_A0" not in names)):
                    print("   Adding pin_A0, A1")
                    for p in range(2):  # add pin_A0..A1
                        list_bitfield(fp, "LATA_LATA%d" % (p), 1, "LATA", p)
                        list_bitfield(fp, "pin_A%d" % (p), 1, "PORTA", p)
                        list_pin_alias(fp, "A%d" % (p), "PORTA")
                        fp.write("procedure pin_A%d'put(bit in x at LATA : %d) is\n" % (p, p) +
                                 "   pragma inline\n" +
                                 "end procedure\n" +
                                 "--\n")
#RJ: 2019-04-13. Removed since these pins can only be input so do not have a direction.
#                elif ((sfrname == "TRISA") & ("pin_A0_direction" not in names)):
#                    print("   Adding pin_A0/A1_direction")
#                    for p in range(2):  # add pin_A0..A1
#                        list_bitfield(fp, "TRISA_TRISA%d" % (p), 1, "TRISA", p)
#                        list_alias(fp, "pin_A%d_direction" % (p), "TRISA_TRISA%d" % (p))
#                        list_pin_direction_alias(fp, "A%d" % (p), "PORTA")
            offset = offset + eval(child.getAttribute("edc:offset"))

        elif (child.nodeName == "edc:SFRFieldDef"):
            width = eval(child.getAttribute("edc:nzwidth"))
            if (subfields_wanted(sfrname)):  # exclude subfields of some registers
                adcssplitpics = ("16f737", "16f747", "16f767", "16f777",
                                 "16f818", "16f819", "16f88",
                                 "16f873a", "16f874a", "16f876a", "16f877a",
                                 "18f242", "18f2439", "18f248", "18f252", "18f2539",
                                 "18f258", "18f442", "18f4439",
                                 "18f448", "18f452", "18f4539", "18f458")
                picname = cfgvar["picname"]
                core = cfgvar["core"]
                fieldname = child.getAttribute("edc:cname").upper()
                portletter = sfrname[-1]  # if applicable
                pinnumber = "0"
                if (len(fieldname) > 0):
                    pinnumber = fieldname[-1]
                if sfrname.startswith(("ANSEL", "ADCON")):
                    if (fieldname == "ADCS"):
                        if (width >= cfgvar["adcs_bits"]):
                            cfgvar["adcs_bits"] = width  # width -> bits
                    elif (fieldname.startswith("ADCS") & (fieldname[4:].isdigit())):
                        if (int(fieldname[4:]) >= cfgvar["adcs_bits"]):
                            cfgvar["adcs_bits"] = int(fieldname[4:]) + 1  # (highest) offset + 1
                if ((fieldname == "") | fieldname.startswith("RESERVED")):
                    pass  # skip unsupported or reserved bits
                elif ((sfrname == "ADCON0") & (fieldname == "ADCS") & (width == 2) & (picname in adcssplitpics)):
                    list_bitfield(fp, "ADCON0_ADCS10", width, sfrname, offset)
                    if (core == "16"):  # ADCON1 comes before ADCON0
                        fp.write("--\n" +
                                 "var volatile byte   ADCON0_ADCS    -- shadow\n" +
                                 "procedure ADCON0_ADCS'put(byte in x) is\n" +
                                 "   ADCON0_ADCS10 = (x & 0x03)      -- low order bits\n" +
                                 "   ADCON1_ADCS2  = (x & 0x04)      -- high order bit\n" +
                                 "end procedure\n" +
                                 "--\n")
                elif ((sfrname == "ADCON1") & (fieldname == "ADCS2") & (picname in adcssplitpics)):
                    list_bitfield(fp, "ADCON1_ADCS2", width, sfrname, offset)
                    if (core == "14"):  # ADCON0 comes before ADCON1
                        fp.write("--\n" +
                                 "var volatile byte   ADCON0_ADCS    -- shadow\n" +
                                 "procedure ADCON0_ADCS'put(byte in x) is\n" +
                                 "   ADCON0_ADCS10 = (x & 0x03)      -- low order bits\n" +
                                 "   ADCON1_ADCS2  = (x & 0x04)      -- high order bit\n" +
                                 "end procedure\n" +
                                 "--\n")
                elif ((sfrname == "ADCON0") & (picname in ("16f737", "16f747", "16f767", "16f777")) &
                      (fieldname == "CHS")):
                    list_bitfield(fp, "ADCON0_CHS210", width, sfrname, offset)
                    fp.write("--\n" +
                             "procedure ADCON0_CHS'put(byte in x) is\n" +
                             "   ADCON0_CHS210 = (x & 0x07)     -- low order bits\n" +
                             "   ADCON0_CHS3   = 0              -- reset\n" +
                             "   if ((x & 0x08) != 0) then\n" +
                             "      ADCON0_CHS3 = 1             -- high order bit\n" +
                             "   end if\n" +
                             "end procedure\n" +
                             "--\n")
                elif ((sfrname.startswith("BAUDC")) & (fieldname == "CKTXP")):  # 'inverted' fieldname
                    list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                    list_alias(fp, sfrname + "_TXCKP", sfrname + "_CKTXP")
                elif ((sfrname.startswith("BAUDC")) & (fieldname == "DTRXP")):  # 'inverted' fieldname
                    list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                    list_alias(fp, sfrname + "_RXDTP", sfrname + "_DTRXP")
                elif ((sfrname == "GPIO") & (fieldname.startswith("RB"))):  # suppress wrong pinnames
                    pass
                elif ((sfrname == "GPIO") & (fieldname.startswith("GPIO"))):
                    pass
                elif ((sfrname == "GPIO") & (width == 1) & ("0" <= pinnumber <= "7")):
                    list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname + "_", offset)
                    pin = "pin_A" + pinnumber
                    if (pin not in names):
                        list_bitfield(fp, pin, 1, sfrname + "_", offset)
                        list_pin_alias(fp, "A" + pinnumber, "PORTA_")
                        fp.write("procedure " + pin + "'put(bit in x" + " at PORTA_shadow_ : " + pinnumber + ") is\n" +
                                 "   pragma inline\n" +
                                 "   PORTA_ = PORTA_shadow_\n" +
                                 "end procedure\n" +
                                 "--\n")
                elif (sfrname.startswith("LAT") & (sfrname != "LATVP") & (width == 1) & ("0" <= fieldname[-1] <= "7")):
                    if not (((fieldname == "LATA3") & (cfgvar["lata3_out"] == False)) |
                            ((fieldname == "LATA5") & (cfgvar["lata5_out"] == False)) |
                            ((fieldname == "LATE3") & (cfgvar["late3_out"] == False))):
                        list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                        pin = "pin_" + portletter + pinnumber
                        if ("PORT" + portletter in names):  # PORTx < LATx
                            list_bitfield(fp, pin, 1, "PORT" + portletter, offset)
                            list_pin_alias(fp, portletter + pinnumber, "PORT" + portletter)
                            fp.write("procedure " + pin + "'put(bit in x at " + sfrname + " : " + pinnumber + ") is\n" +
                                     "   pragma inline\n" +
                                     "end procedure\n" +
                                     "--\n")
                elif ((fieldname == "NMCLR") & ((sfrname.startswith("PORT")) | (sfrname == "GPIO"))):
                    # print("   Renamed", fieldname, "of", sfrname, "to MCLR")
                    list_bitfield(fp, sfrname + "_MCLR", 1, sfrname, offset)
                elif ((sfrname == "OPTION_REG") & (fieldname in ("T0CS", "T0SE", "PSA"))):
                    list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                    list_alias(fp, "T0CON_" + fieldname, sfrname + "_" + fieldname)
                elif ((sfrname == "OPTION_REG") & (fieldname == "NWPUEN")):
                    list_bitfield(fp, sfrname + "_" + "WPUEN", width, sfrname, offset)
                elif ((sfrname == "OPTION_REG") & (fieldname == "PS2")):
                    list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                    if ("OPTION_REG_PS" not in names):
                        list_bitfield(fp, sfrname + "_PS", 3, sfrname, offset - 2)
                    list_alias(fp, "T0CON_T0PS", sfrname + "_PS")
                elif ((sfrname == "PORTB") & (fieldname.startswith("RB")) & (picname.startswith("12"))):
                    list_bitfield(fp, "GPIO_GP" + fieldname[2:], 1, "GPIO_", offset)
                elif ((sfrname.startswith("PORT")) & (sfrname != "PORTVP") & (width == 1) &
                      (fieldname.startswith("R")) & ("0" <= fieldname[-1] <= "7")):
                    list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                    pin = "pin_" + portletter + pinnumber
                    if ((sfrname == "PORTA") & (fieldname == "RA3") &
                            (cfgvar["haslat"] == True) & (cfgvar["lata3_out"] == False)):
                        list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                        list_bitfield(fp, pin, 1, sfrname, offset)
                        list_pin_alias(fp, portletter + pinnumber, sfrname)
                    elif ((sfrname == "PORTA") & (fieldname == "RA5") &
                          (cfgvar["haslat"] == True) & (cfgvar["lata5_out"] == False)):
                        list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                        list_bitfield(fp, pin, 1, sfrname, offset)
                        list_pin_alias(fp, portletter + pinnumber, sfrname)
                    elif ((sfrname == "PORTE") & (fieldname == "RE3") &
                          (cfgvar["haslat"] == True) & (cfgvar["late3_out"] == False)):
                        list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                        list_bitfield(fp, pin, 1, sfrname, offset)
                        list_pin_alias(fp, portletter + pinnumber, sfrname)
                    elif (cfgvar["haslat"] == False):
                        list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname + "_", offset)
                        list_bitfield(fp, pin, 1, "PORT" + portletter + "_", offset)
                    elif (cfgvar["haslat"] == True):
                        if ("LAT" + portletter in names):  # LAT<portletter> already declared
                            list_bitfield(fp, pin, 1, sfrname, offset)
                            list_pin_alias(fp, portletter + pinnumber, sfrname)
                            fp.write(
                                "procedure " + pin + "'put(bit in x at LAT" + portletter + " : " + pinnumber + ") is\n" +
                                "   pragma inline\n" +
                                "end procedure\n" +
                                "--\n")
                    else:
                        list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                    if (cfgvar["haslat"] == False):
                        list_pin_alias(fp, portletter + pinnumber, "PORT" + portletter + "_")
                        fp.write(
                            "procedure " + pin + "'put(bit in x at " + sfrname + "_shadow_ : " + pinnumber + ") is\n" +
                            "   pragma inline\n" +
                            "   " + sfrname + "_ = " + sfrname + "_shadow_\n" +
                            "end procedure\n" +
                            "--\n")
                elif ((sfrname.startswith("PORT")) & (sfrname != "PORTVP")):
                    if (cfgvar["haslat"] == False):
                        list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname + "_", offset)
                    else:
                        list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                elif (((len(sfrname) == 5) & sfrname.startswith("T") & sfrname.endswith("CON"))):
                    list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                    if ((width == 1) & (len(fieldname) > 4) & fieldname.endswith("SYNC")):
                        if (fieldname.startswith("NT")):
                            list_alias(fp, sfrname + "_T" + sfrname[1] + "SYNC", sfrname + "_" + fieldname)
                        elif (fieldname.startswith("T")):
                            list_alias(fp, sfrname + "_NT" + sfrname[1] + "SYNC", sfrname + "_" + fieldname)
                        else:
                            list_alias(fp, sfrname + "_NT" + sfrname[1] + "SYNC", sfrname + "_" + fieldname)
                            list_alias(fp, sfrname + "_T" + sfrname[1] + "SYNC", sfrname + "_" + fieldname)
                    elif (fieldname in ("CKPS", "CS", "SYNC")):
                        list_alias(fp, sfrname + "_TMR" + sfrname[1] + fieldname, sfrname + "_" + fieldname)
                        list_alias(fp, sfrname + "_T" + sfrname[1] + fieldname, sfrname + "_" + fieldname)
                elif ((sfrname == "TRISGP") & (fieldname.startswith("TRISB")) & (picname.startswith("12"))):
                    pass  # suppress this combination
                elif (sfrname.startswith("TRIS") & (sfrname != "TRISVP") & (width == 1) & \
                      fieldname.startswith("TRIS") & ("0" <= fieldname[-1] <= "7")):
                    list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                    if (sfrname.endswith("IO")):  # TRISIO/TRISGPIO
                        pin = "pin_A" + pinnumber
                        list_bitfield(fp, pin + "_direction", 1, "TRISA", offset)
                        list_pin_direction_alias(fp, "A" + pinnumber, "PORTA")
                    else:
                        pin = "pin_" + portletter + pinnumber
                        list_bitfield(fp, pin + "_direction", 1, sfrname, offset)
                        list_pin_direction_alias(fp, portletter + pinnumber, "PORT" + portletter)
                elif ((width > 1) & sfrname.startswith(("PORT", "GPIO", "LAT", "TRIS"))):
                    pass  # no multi-bit subfields for these regs
                else:
                    mask = eval(child.getAttribute("edc:mask"))
                    # print(sfrname, fieldname, width, mask, offset)
                    if ((width == 8) & (mask in (1, 3, 7, 15, 31, 63, 127))):
                        #  print("width", width, "mask", mask)
                        width = 1 + (1, 3, 7, 15, 31, 63, 127).index(mask)
                        #  print("new width", width)
                    list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)

                # additional declarations:
                if ((sfrname.startswith("ADCON")) & (fieldname.endswith("VCFG0"))):
                    list_bitfield(fp, sfrname + "_VCFG", 2, sfrname, offset)
                elif ((fieldname.startswith("AN")) & (width == 1) &
                      (sfrname.startswith(("ADCON", "ANSEL")))):
                   ansx = ansel2j(sfrname, fieldname)
                   if (ansx < 99):
                      list_alias(fp, "JANSEL_ANS%d" % ansx, sfrname + "_" + fieldname)
                elif ((sfrname == "CANCON") & (fieldname == "REQOP0")):
                    list_bitfield(fp, "CANCON_REQOP", 3, sfrname, offset)
                elif ((sfrname == "FVRCON") & (fieldname in ("CDAFVR0", "ADFVR0"))):
                    list_bitfield(fp, sfrname + "_" + fieldname[:-1], 2, sfrname, offset)
                elif (sfrname == "INTCON"):
                    if (fieldname.startswith("T0")):
                        list_alias(fp, sfrname + "_TMR0" + fieldname[2:], sfrname + "_" + fieldname)
                elif ((sfrname == "OSCCON") & (fieldname == "IRCF0")):
                    list_bitfield(fp, sfrname + "_IRCF", cfgvar["ircf_bits"], sfrname, offset)
                elif ((sfrname == "OSCCON") & (fieldname == "SCS0")):
                    list_bitfield(fp, sfrname + "_SCS", 2, sfrname, offset)
                elif ((sfrname == "PADCFG1") & (fieldname == "RTSECSEL0")):
                    list_bitfield(fp, sfrname + "_RTSECSEL", 2, sfrname, offset)
                elif ((sfrname.find("CCP") >= 0) & sfrname.endswith("CON")):
                    if ((fieldname.startswith("CCP") & fieldname.endswith("Y")) |
                            (fieldname.startswith("DC") & fieldname.endswith("B0"))):
                        if (fieldname.startswith("DC")):
                            field = sfrname + "_" + fieldname[:-1]
                        else:
                            field = sfrname + "_DC" + fieldname[3:-1] + "B"
                        list_bitfield(fp, field, 2, sfrname, offset - width + 1)
                    elif (fieldname.startswith("CCP") & fieldname.endswith(("MODE", "M"))):
                        # list_bitfield(fp, sfrname + "_MODE", width, sfrname, offset)
                        list_alias(fp, sfrname + "_MODE", sfrname + "_" + fieldname)

                list_multi_module_bitfield_alias(fp, sfrname, fieldname)

            offset = offset + width

    return offset


"""
            elif ( (sfrname.find("CCP") >= 0) & (sfrname.endswith("CON")) &  \         # ?CCPxCON
                   (((fieldname.startswith("CCP")) & (fieldname.endswith("Y")))  | \
                    ((fieldname.startswith("DC"))  & (fieldname.endswith("B0")))) ):
               if (fieldname.startswith("DC")):
                  field = sfrname + "_" + fieldname[:-1]
               else:
                  field = sfrname + "_DC" + fieldname[3:-1] + "B"
               list_bitfield(fp, field, 2, sfrname, offset - width + 1)
"""


def list_muxed_sfr(fp, selectsfr):
    """ Generate declaration of multiplexed registers

   Input:   - output file
            - SelectSFR node
            - current SFR addr
   Output:  part of device files
   Returns: (nothing)
   Notes:   Multiplexed registers must be declared after all other SFRs
            because the pseudo procedures access a control register
            which must have been declared first, otherwise it is 'unknown'.
   """
    cond = None
    if (selectsfr.hasAttribute("edc:when")):
        cond = selectsfr.getAttribute("edc:when")
    sfrs = selectsfr.getElementsByTagName("edc:SFRDef")
    for sfr in sfrs:
        if (cond == None):  # default sfr
            list_sfr(fp, sfr)
        else:  # alternate sfr on this address
            sfrname = sfr.getAttribute("edc:cname")
            sfraddr = eval(sfr.getAttribute("edc:_addr"))
            core = cfgvar["core"]
            subst = sfrname + "_"  # substitute name
            if (core == "14"):
                if (sfrname == "SSPMSK"):
                    list_muxed_pseudo_sfr(fp, sfrname, sfraddr, cond)
                else:
                    print("Unexpected multiplexed SFR", sfr, "for core", core)
            elif (core == "16"):
                if sfrname.startswith("PMDOUT"):
                    list_variable(fp, sfrname, 1, sfraddr)  # master/slave: automatic
                elif (sfrname in ("SSP1MSK", "SSP2MSK")):
                    list_muxed_pseudo_sfr(fp, sfrname, sfraddr, cond)
                    if (sfrname == "SSP1MSK"):
                        list_alias(fp, "SSPMSK", sfrname)
                elif ((sfrname in ("CVRCON", "MEMCON", "PADCFG1", "REFOCON")) |
                      sfrname.startswith(("ODCON", "ANCON"))):
                    list_muxed_pseudo_sfr(fp, sfrname, sfraddr, cond)
                    if (sfrname == "SSP1MSK"):
                        list_alias(fp, "SSPMSK", sfrname)
                    list_muxed_sfr_subfields(fp, sfr)  # controlled by WDTCON_ADSHR
                else:
                    print("Unexpected multiplexed SFR", sfrname, "for core", core)

            else:
                print("Unexpected core", core, "with multiplexed SFR", sfrname)


def list_muxed_pseudo_sfr(fp, sfrname, sfraddr, cond):
    """ Generate declaration of pseudo variable of muxed sfr

   Input:   - output file
            - substituted name of muxed SFR
            - current SFR addr
            - condition expression
   Output:  part of device files
   Returns: (nothing)
   """
    global names
    condl = cond.split(" ")  # parse condition elements from
    val1 = condl[0][2:]  # ($val1 val2 val3) == val4
    val2 = condl[1]
    val3 = condl[2][:-1]
    val4 = condl[4]
    subst = sfrname + "_"
    list_variable(fp, subst, 1, sfraddr)  # declare substitute variable
    if (sfrname not in names):
        names.append(sfrname)
    fp.write("--\n" +
             "procedure " + sfrname + "'put(byte in x) is\n" +
             "   var volatile byte _control_sfr at " + val1 + "\n" +
             "   var byte _saved_sfr = _control_sfr\n" +
             "   _control_sfr = _control_sfr " + val2 + " (!" + val3 + ")\n" +
             "   _control_sfr = _control_sfr | " + val4 + "\n" +
             "   " + subst + " = x\n" +
             "   _control_sfr = _saved_sfr\n" +
             "end procedure\n" +
             "function " + sfrname + "'get() return byte is\n" +
             "   var volatile byte _control_sfr at " + val1 + "\n" +
             "   var byte _saved_sfr = _control_sfr\n" +
             "   var byte x\n" +
             "   _control_sfr = _control_sfr " + val2 + " (!" + val3 + ")\n" +
             "   _control_sfr = _control_sfr | " + val4 + "\n" +
             "   x = " + subst + "\n" +
             "   _control_sfr = _saved_sfr\n" +
             "   return  x\n" +
             "end function\n")


def list_muxed_sfr_subfields(fp, sfr):
    """ Format the subfields of multiplexed SFRs

   Input:  - index in .pic
           - register node
   Notes:  - Expected to be used with 18Fs only
           - Only valid for SFRs which use WDTCON_ADSHR bit
             to switch to the alternate content
   """
    sfrname = sfr.getAttribute("edc:cname")
    modelist = sfr.getElementsByTagName("edc:SFRMode")
    for mode in modelist:
        offset = 0
        modeid = mode.getAttribute("edc:id")
        if modeid.startswith(("DS.", "LT.")):
            if len(mode.childNodes) > 0:
                child = mode.firstChild
                offset = list_muxed_sfr_bitfield(fp, child, sfrname, 0)
                while child.nextSibling:
                    child = child.nextSibling
                    offset = list_muxed_sfr_bitfield(fp, child, sfrname, offset)


def list_muxed_sfr_bitfield(fp, child, sfrname, offset):
    """ Format a single bitfield of a multiplexed SFR

   Input:  - index in .pic
           - register node
   Notes:  - Expected to be used with 18Fs only
           - Only valid for SFRs which use WDTCON_ADSHR bit
             to switch to the alternate content: controlled by
             SFR selection in list_muxed_sfr().
   """
    if (child.nodeType == Node.ELEMENT_NODE):
        if (child.nodeName == "edc:AdjustPoint"):
            offset = offset + eval(child.getAttribute("edc:offset"))
        elif (child.nodeName == "edc:SFRFieldDef"):
            width = eval(child.getAttribute("edc:nzwidth"))
            if subfields_wanted(sfrname):
                field = sfrname + "_" + child.getAttribute("edc:cname")
                if (field not in names):  # new variable
                    names.append(field)
                subst = sfrname + "_"
                if (width == 1):
                    fp.write("--\n" +
                             "procedure " + field + "'put(bit in x) is\n" +
                             "   var volatile bit control_bit at " +
                             "0x%X : %d" % cfgvar["wdtcon_adshr"] + "\n" +
                             "   var bit y at " + subst + " : %d" % (offset) + "\n" +
                             "   control_bit = TRUE\n" +
                             "   y = x\n" +
                             "   control_bit = FALSE\n" +
                             "end procedure\n" +
                             "function " + field + "'get() return bit is\n" +
                             "   var volatile bit control_bit at " +
                             "0x%X : %d" % cfgvar["wdtcon_adshr"] + "\n" +
                             "   var bit x at " + subst + ' : %d' % (offset) + "\n" +
                             "   var bit y\n" +
                             "   control_bit = TRUE\n" +
                             "   y = x\n" +
                             "   control_bit = FALSE\n" +
                             "   return y\n" +
                             "end function\n")
                elif (width <= 8):  # multi-bit
                    mask = eval(child.getAttribute("edc:mask"))
                    if ((width == 8) & (mask in (1, 3, 7, 15, 31, 64, 127))):
                        # print("width", width, "mask", mask)
                        width = 1 + (1, 3, 7, 15, 31, 64, 127).index(mask)
                        # print("new width", width)
                    fp.write("--\n" +
                             "procedure " + field + "'put(bit*%d" % (width) + " in x) is\n" +
                             "   var volatile bit control_bit at " +
                             "0x%X : %d" % cfgvar["wdtcon_adshr"] + "\n" +
                             "   var bit*%d" % (width) + " y at " + subst + " : %d" % (offset) + "\n" +
                             "   control_bit = TRUE\n" +
                             "   y = x\n" +
                             "   control_bit = FALSE\n" +
                             "end procedure\n" +
                             "function " + field + "'get() return bit*%d" % (width) + " is\n" +
                             "   var volatile bit control_bit at " +
                             "0x%X : %d" % cfgvar["wdtcon_adshr"] + "\n" +
                             "   var bit*%d" % (width) + " x at " + subst + " : %d" % (offset) + "\n" +
                             "   var bit*%d" % (width) + " y\n" +
                             "   control_bit = TRUE\n" +
                             "   y = x\n" +
                             "   control_bit = FALSE\n" +
                             "   return y\n" +
                             "end function\n")
            offset = offset + width
    return offset


def list_all_nmmr(fp, root):
    """ Generate declarations of all non memory mapped registers

   Input:   - output file
            - root of .pic (xml parsed structure)
   Output:  part of device files
   Returns: (nothing)
   Notes:   only for core 12
   """
    if (cfgvar["core"] == "12"):
        nmmrplaces = root.getElementsByTagName("edc:NMMRPlace")
        for nmmrplace in nmmrplaces:
            if (len(nmmrplace.childNodes) > 0):
                child = nmmrplace.firstChild
                list_nmmrdata_child(fp, child)
                while child.nextSibling:
                    child = child.nextSibling
                    list_nmmrdata_child(fp, child)


def list_nmmrdata_child(fp, nmmr):
    """ Generate declaration a memory mapped register

   Input:   - output file
            - NMMR node
   Output:  part of device files
   Returns: (nothing)
   Notes:   only for core 12
   """
    global names
    if (nmmr.nodeType == Node.ELEMENT_NODE):
        if (nmmr.nodeName == "edc:SFRDef"):
            sfrname = nmmr.getAttribute("edc:cname")
            picname = cfgvar["picname"]
            if (sfrname == "OPTION_REG"):
                if (sfrname not in names):
                    names.append(sfrname)
                list_separator(fp)
                shadow = sfrname + "_shadow_"
                sharedmem_avail = sharedmem[1] - sharedmem[0] + 1  # incl upper bound
                if (sharedmem_avail < 1):
                    # print("   No (more) shared memory for", shadow)
                    fp.write("var volatile byte  %-25s" % (shadow) + " = 0b1111_1111\n")
                else:
                    shared_addr = sharedmem[1]
                    fp.write("var volatile byte   %-25s at 0x%X" % (shadow, shared_addr) + " = 0b1111_1111\n")
                    sharedmem[1] = sharedmem[1] - 1
                fp.write("--\n" +
                         "procedure " + sfrname + "'put(byte in x at " + shadow + ") is\n" +
                         "   pragma inline\n" +
                         "   asm movf " + shadow + ",0\n" +
                         "   asm option\n" +
                         "end procedure\n")
                list_nmmr_option_subfields(fp, nmmr)

            elif (sfrname.startswith("TRIS")):  # handle TRISIO or TRISGPIO
                if (sfrname not in names):
                    names.append(sfrname)
                list_separator(fp)
                portletter = sfrname[4:]
                if (portletter in ("IO", "GPIO", "")):
                    # print(sfrname, "register interpreted as TRISA")
                    portletter = "A"  # handle as TRISA
                elif ((portletter == "B") & (picname.startswith("12"))):
                    print(sfrname, "register interpreted as TRISA")
                    sfrname = "TRISIO"
                    portletter = "A"
                shadow = "TRIS" + portletter + "_shadow_"
                sharedmem_avail = sharedmem[1] - sharedmem[0] + 1  # incl upper bound
                if (sharedmem_avail < 1):
                    # print("   No (more) shared memory for", shadow)
                    fp.write("var volatile byte  %-25s" % (shadow) + " = 0b1111_1111\n")
                else:
                    shared_addr = sharedmem[1]
                    fp.write("var volatile byte   %-25s at 0x%X" % (shadow, shared_addr) + " = 0b1111_1111\n")
                    sharedmem[1] = sharedmem[1] - 1
                fp.write("--\n" +
                         "procedure PORT" + portletter + "_direction'put(byte in x at " + shadow + ") is\n" +
                         "   pragma inline\n" +
                         "   asm movf " + shadow + ",W\n")
                if (sfrname in ("TRISIO", "TRISGPIO")):
                    fp.write("   asm tris 6\n")
                else:  # TRISx
                    fp.write("   asm tris %d\n" % (5 + "ABCDE".find(portletter)))
                fp.write("end procedure\n" +
                         "--\n")
                half = "PORT" + portletter + "_low_direction"
                fp.write("procedure " + half + "'put(byte in x) is\n" +
                         "   " + shadow + " = (" + shadow + " & 0xF0) | (x & 0x0F)\n" +
                         "   asm movf TRIS" + portletter + "_shadow_,W\n")
                if (sfrname == "TRISIO"):
                    fp.write("   asm tris 6\n")
                else:  # TRISx
                    fp.write("   asm tris %d\n" % (5 + "ABCDE".find(portletter)))
                fp.write("end procedure\n" +
                         "--\n")
                half = "PORT" + portletter + "_high_direction"
                fp.write("procedure " + half + "'put(byte in x) is\n" +
                         "   " + shadow + " = (" + shadow + " & 0x0F) | (x << 4)\n" +
                         "   asm movf TRIS" + portletter + "_shadow_,W\n")
                if (sfrname == "TRISIO"):
                    fp.write("   asm tris 6\n")
                else:  # TRISx
                    fp.write("   asm tris %d\n" % (5 + "ABCDE".find(portletter)))
                fp.write("end procedure\n" +
                         "--\n")
                list_nmmr_tris_subfields(fp, nmmr)  # individual TRIS bits


def list_nmmr_option_subfields(fp, nmmr):
    """ Format all subfields of NMMR OPTION_REG

   Input:  - file
           - NMMR node
   Notes:  - Expected to be used with 12Fs only
   """
    sfrname = nmmr.getAttribute("edc:cname")
    modelist = nmmr.getElementsByTagName("edc:SFRMode")
    for mode in modelist:
        offset = 0
        modeid = mode.getAttribute("edc:id")
        if modeid.startswith(("DS.", "LT.")):
            if len(mode.childNodes) > 0:
                child = mode.firstChild
                offset = list_nmmr_option_bitfield(fp, child, sfrname, 0)
                while child.nextSibling:
                    child = child.nextSibling
                    offset = list_nmmr_option_bitfield(fp, child, sfrname, offset)


def list_nmmr_tris_subfields(fp, nmmr):
    """ Format all subfields of NMMR TRIS

   Input:  - file
           - NMMR node
   Notes:  - Expected to be used with 12Fs only
   """
    sfrname = nmmr.getAttribute("edc:cname")
    modelist = nmmr.getElementsByTagName("edc:SFRMode")
    for mode in modelist:
        offset = 0
        modeid = mode.getAttribute("edc:id")
        if modeid.startswith(("DS.", "LT.")):
            if (len(mode.childNodes) > 0):
                child = mode.firstChild
                offset = list_nmmr_tris_bitfield(fp, child, sfrname, 0)
                while child.nextSibling:
                    child = child.nextSibling
                    offset = list_nmmr_tris_bitfield(fp, child, sfrname, offset)


def list_nmmr_option_bitfield(fp, child, sfrname, offset):
    """ Format a single bitfield of NMMR OPTION pseudo register

   Input:  - index in .pic
           - register node
   Notes:  - Expected to be used with 12Fs only
   """
    if (child.nodeType == Node.ELEMENT_NODE):
        if (child.nodeName == "edc:AdjustPoint"):
            offset = offset + eval(child.getAttribute("edc:offset"))
        elif (child.nodeName == "edc:SFRFieldDef"):
            width = eval(child.getAttribute("edc:nzwidth"))
            fieldname = child.getAttribute("edc:cname").upper()
            field = sfrname + "_" + fieldname
            if (field not in names):  # new variable
                names.append(field)
            shadow = sfrname + "_shadow_"
            if (width == 1):
                fp.write("--\n" +
                         "procedure " + field + "'put(bit in x at "
                         + shadow + ": %d" % (offset) + ") is\n" +
                         "   pragma inline\n" +
                         "   asm movf " + shadow + ",0\n" +
                         "   asm option\n" +
                         "end procedure\n")
            elif (width < 8):  # multi-bit
                fp.write("--\n" +
                         "procedure " + field + "'put(bit*%d" % (width) + " in x at " \
                         + shadow + ": %d" % (offset) + ") is\n" +
                         "   pragma inline\n" +
                         "   asm movf " + shadow + ",0\n" +
                         "   asm option\n" +
                         "end procedure\n")
            if (fieldname in ("T0CS", "T0SE", "PSA")):
                list_alias(fp, "T0CON_" + fieldname, field)
            elif (fieldname == "PS"):
                list_alias(fp, "T0CON_T0" + fieldname, field)
            offset = offset + width
    return offset


def list_nmmr_tris_bitfield(fp, child, sfrname, offset):
    """ Format a single bitfield of NMMR TRIS pseudo register

   Input:  - index in .pic
           - register node
   Notes:  - Expected to be used with 12Fs only
   """
    if (child.nodeType == Node.ELEMENT_NODE):
        if (child.nodeName == "edc:AdjustPoint"):
            offset = offset + eval(child.getAttribute("edc:offset"))
        elif (child.nodeName == "edc:SFRFieldDef"):
            portletter = child.getAttribute("edc:cname")[4:]
            if portletter.startswith(("IO", "GPIO")):
                portletter = 'A'  # handle as TRISA
            else:
                portletter = portletter[0]
            if ((portletter == "B") & (cfgvar["picname"].startswith("12"))):
                return offset
            shadow = "TRIS" + portletter + "_shadow_"
            pin = "pin_" + portletter + "%d" % (offset)
            field = pin + "_direction"
            if (field not in names):  # new variable
                names.append(field)
            fp.write("procedure " + field + "'put(bit in x at "
                     + shadow + ": %d" % (offset) + ") is\n" +
                     "   pragma inline\n" +
                     "   asm movf " + shadow + ",W\n")
            if (sfrname in ("TRISIO", "TRISGPIO")):
                fp.write("   asm tris 6\n")
            else:
                fp.write("   asm tris %d\n" % (5 + "ABCDE".index(portletter)))
            fp.write("end procedure\n")
            list_pin_direction_alias(fp, portletter + "%d" % (offset), shadow)
            offset = offset + 1
    return offset


def subfields_wanted(sfrname):
    """ Indicate if subfields of a specific register are wanted

   input:   Register name
   returns: 0 - no expansion
            1 - expansion desired
   notes: This suppresses expansions of SFR subfields
          which are not used by Jallib libraries
   """
    if (sfrname.startswith("SSP") & sfrname.endswith(("ADD", "BUF", "MSK"))):
        return False
    elif sfrname.startswith(("SPBRG", "SP1BRG", "SP2BRG")):
        return False
    elif sfrname.endswith("PPS"):  # all sfrs ending with PPS
        return False
    else:
        return True  # subfields wanted


def list_pin_alias(fp, portbit, port):
    """ Generate pin aliases

   Input:   - file pointer
            - name of bit (portletter||offset)
            - PORT of the pin
   Returns: (nothing)
   Notes:   - declare aliases for all synonyms in pinaliases.
            - declare extra aliases for first of multiple I2C or SPI modules
            - declare extra aliases for TX and RX pins of only USART module
   """
    picname = cfgvar["picname"].upper()
    if ("R" + portbit in pinaliases[picname]):
        for alias in pinaliases[picname]["R" + portbit]:
            alias = "pin_" + alias
            pin = "pin_" + portbit
            list_alias(fp, alias, pin)
            if alias in ("pin_SDA1", "pin_SDI1", "pin_SDO1", "pin_SCK1",
                         "pin_SCL1", "pin_SS1", "pin_TX1", "pin_RX1", "pin_DT1", "pin_CK1"):
                alias = alias[:-1]
                list_alias(fp, alias, pin)
        fp.write("--\n")
    # else:
    #    print("   R" + portbit, "not in pinaliases of", picname)


def list_pin_direction_alias(fp, portbit, port):
    """ Generate pin_direction aliases

   input:   - file pointer
            - name of bit (portletter||offset)
            - port of the pin
   returns: (nothing)
   notes:   - generate alias definitions for all synonyms in pinaliases
              with '_direction' added!
            - generate extra aliases for first of multiple I2C or SPI modules
   """
    PICname = cfgvar["picname"].upper()  # capitals!
    if ("R" + portbit in pinaliases[PICname]):
        for alias in pinaliases[PICname]["R" + portbit]:
            alias = 'pin_' + alias + "_direction"
            pindir = "pin_" + portbit + "_direction"
            list_alias(fp, alias, pindir)
            if (alias in ("pin_SDA1_direction",
                          "pin_SDI1_direction",
                          "pin_SDO1_direction",
                          "pin_SCK1_direction",
                          "pin_SCL1_direction")):
                alias = alias[:7] + alias[8:]
                list_alias(fp, alias, pindir)
            elif (alias in ("pin_SS1_direction",
                            "pin_TX1_direction",
                            "pin_RX1_direction")):
                alias = alias[:6] + alias[7:]
                list_alias(fp, alias, pindir)
        fp.write("--\n")


#  else:
#     print("   R" + portbit, "is an unknown pin")


def list_variable(fp, var, width, addr):
    """ Generate a line with a volatile variable

   Input:   - file pointer
            - name
            - width (in bytes)
            - address (decimal)   ??? maybe string ???
   Returns: nothing
   """
    global names
    if (var not in names):
        names.append(var)  # add name of this variable
        if (width == 1):
            type = "byte"
        elif (width == 2):
            type = "word"
        elif (width == 4):
            type = "dword"
        else:
            type = "byte*%d" % width
        fp.write("var volatile %-6s %-25s at { " % (type, var))
        if (addr in sfr_mirrors):
            fp.write(",".join(["0x%X" % x for x in sfr_mirrors[addr]]) + " }\n")
        else:
            fp.write("0x%X }\n" % addr)
    else:
        print("   Duplicate name:", var)


def list_bitfield(fp, var, width, sfrname, offset):
    """ Generate a line with a volatile variable

   Input:   - file pointer
            - name
            - width (number of bits)
            - SFR
            - offset (decimal or string)
   Returns: nothing
   Notes:   Fields of 8 bits or larger are not declared
   """
    if (not var.startswith("pin_")):
        bitfieldname = var.upper()
    else:
        bitfieldname = var
    if ((sfrname.endswith("_SHAD")) & (bitfieldname.endswith("_SHAD"))):
        bitfieldname = bitfieldname[:-5]  # remove trailing "_SHAD"
    if (bitfieldname not in names):
        names.append(bitfieldname)
        if (width == 1):
            fp.write("var volatile bit    %-25s at %s : %d\n" % (bitfieldname, sfrname, offset))
        elif (width < 8):
            fp.write("var volatile bit*%d  %-25s at %s : %d\n" % (width, bitfieldname, sfrname, offset))


def list_alias(fp, alias, original):
    """ List a line with an alias declaration

   Input:   - file pointer
            - name of alias
            - name of original variable (or other alias)
   Returns: - (_bankednothing)
   """
    global names
    if alias not in names:
        names.append(alias)
        fp.write("%-19s %-25s is %s\n" % ("alias", alias, original))
    # else:
    #    print("   Duplicate alias name:", alias)


def list_port_shadow(fp, reg):
    """ Create port shadowing functions for
   full byte, lower- and upper-nibbles of 12- and 14-bit core

   input:  - file pointer
           - Port register
   notes:  - shared memory is allocated from high to low address
   """
    shadow = "PORT" + reg[4:] + "_shadow_"
    fp.write("--\n")
    fp.write("var          byte   %-25s at PORT%s_\n" % ("PORT" + reg[4:], reg[4:]))
    sharedmem_avail = sharedmem[1] - sharedmem[0] + 1  # incl upper bound
    if (sharedmem_avail < 1):
        # print("   No (more) shared memory for", shadow)
        fp.write("var volatile byte  %-25s" % (shadow) + "\n")
    else:
        shared_addr = sharedmem[1]
        fp.write("var volatile byte   %-25s at 0x%X" % (shadow, shared_addr) + "\n")
        sharedmem[1] = sharedmem[1] - 1
    fp.write("--\n" +
             "procedure " + reg + "'put(byte in x at " + shadow + ") is\n" +
             "   pragma inline\n" +
             "   PORT" + reg[4:] + "_ = " + shadow + "\n" +
             "end procedure\n" +
             "--\n")
    half = "PORT" + reg[-1] + "_low"
    fp.write("procedure " + half + "'put(byte in x) is\n" +
             "   " + shadow + " = (" + shadow + " & 0xF0) | (x & 0x0F)\n" +
             "   PORT" + reg[-1] + "_ = " + shadow + "\n" +
             "end procedure\n" +
             "function " + half + "'get() return byte is\n" +
             "   return (" + reg + " & 0x0F)\n" +
             "end function\n" +
             "--\n")
    half = "PORT" + reg[-1] + "_high"
    fp.write("procedure " + half + "'put(byte in x) is\n" +
             "   " + shadow + " = (" + shadow + " & 0x0F) | (x << 4)\n" +
             "   PORT" + reg[-1] + "_ = " + shadow + "\n" +
             "end procedure\n" +
             "function " + half + "'get() return byte is\n" +
             "   return (" + reg + " >> 4)\n" +
             "end function\n" +
             "--\n")


def list_lat_shadow(fp, sfr):
    """ Force use of LATx with core 14H and 16 for full byte, lower- and upper-nibbles

   input:  - LATx register
   """
    lat = "LAT" + sfr[-1]
    port = "PORT" + sfr[-1]
    fp.write("--\n" +
             "procedure " + port + "'put(byte in x at " + lat + ") is\n" +
             "   pragma inline\n" +
             "end procedure\n" +
             "--\n")
    half = port + "_low"
    fp.write("procedure " + half + "'put(byte in x) is\n" +
             "   " + lat + " = (" + lat + " & 0xF0) | (x & 0x0F)\n" +
             "end procedure\n" +
             "function " + half + "'get() return byte is\n" +
             "   return (" + port + " & 0x0F)\n" +
             "end function\n" +
             "--\n")
    half = port + "_high"
    fp.write("procedure " + half + "'put(byte in x) is\n" +
             "   " + lat + " = (" + lat + " & 0x0F) | (x << 4)\n" +
             "end procedure\n" +
             "function " + half + "'get() return byte is\n" +
             "   return (" + port + " >> 4)\n" +
             "end function\n" +
             "--\n")


def list_tris_nibbles(fp, reg):
    """ Create TRIS functions for lower- and upper-nibbles only

   Input:  - file pointer
           - TRIS register
   """
    port = "PORT" + reg[4:]
    if port.endswith("IO"):
        port = "PORTA"
    fp.write("--\n")
    half = port + "_low_direction"
    fp.write("procedure " + half + "'put(byte in x) is\n" +
             "   " + reg + " = (" + reg + " & 0xF0) | (x & 0x0F)\n" +
             "end procedure\n" +
             "function " + half + "'get() return byte is\n" +
             "   return (" + reg + " & 0x0F)\n" +
             "end function\n" +
             "--\n")
    half = port + "_high_direction"
    fp.write("procedure " + half + "'put(byte in x) is\n" +
             "   " + reg + " = (" + reg + " & 0x0F) | (x << 4)\n" +
             "end procedure\n" +
             "function " + half + "'get() return byte is\n" +
             "   return (" + reg + " >> 4)\n" +
             "end function\n" +
             "--\n")


def list_sfr_subfield_alias(fp, child, sfralias, sfrname, offset):
    """ Generate declaration of a register subfield alias

   Input:   - output file
            - SFRDef node
            - aliasname of this SFR
            - offset of bitfield
   Output:
   Returns: offset next bitfield
   Notes:
   """
    if (child.nodeType == Node.ELEMENT_NODE):
        if (child.nodeName == "edc:AdjustPoint"):
            offset = offset + eval(child.getAttribute("edc:offset"))
        elif (child.nodeName == "edc:SFRFieldDef"):
            width = eval(child.getAttribute("edc:nzwidth"))
            if (width < 8):
                fieldname = child.getAttribute("edc:cname").upper()
                list_alias(fp, sfralias + "_" + fieldname, sfrname + "_" + fieldname)
                if (sfralias.startswith("BAUDC")):
                    if (fieldname == "CKTXP"):
                        list_alias(fp, sfralias + "_TXCKP", sfrname + "_" + fieldname)
                    elif (fieldname == "DTRXP"):
                        list_alias(fp, sfralias + "_RXDTP", sfrname + "_" + fieldname)
            offset = offset + width
    return offset


def list_multi_module_register_alias(fp, sfr):
    """ Adding aliases of registers for PICs with multiple similar modules
   used only for registers which are fully dedicated to a module.

   Input:  - file pointer
           - SFR node
   Returns: nothing
   Notes:  - add unqualified alias for module 1
           - add (modified) alias for modules 2..9
           - bitfields are expanded as for 'real' registers
   """
    sfrname = sfr.getAttribute("edc:cname")
    if (len(sfrname) < 5):  # can skip short names
        return
    alias = ''  # default: no alias
    if (sfrname == "BAUDCTL"):  # some midrange, 18f1x20
        alias = 'BAUDCON'
    elif (sfrname == "BAUD1CON"):  # 1st USART: sfrname with index
        alias = "BAUDCON"  # remove "1"
    elif (sfrname == "BAUD2CON"):  # 2nd USART: sfrname with suffix
        alias = "BAUDCON2"  # make index "2" a suffix
    elif (sfrname in ("BAUDCON1", "BAUDCTL1", "RCREG1", "RCSTA1",
                      "SPBRG1", "SPBRGH1", "SPBRGL1", "TXREG1", "TXSTA1")):
        alias = sfrname[0:-1]  # remove trailing "1" index
    elif (sfrname in ("RC1REG", "RC1STA", "SP1BRG", "SP1BRGH",
                      "SP1BRGL", "TX1REG", "TX1STA")):
        alias = sfrname[0:2] + sfrname[3:]  # remove embedded "1" index
    elif (sfrname in ("RC2REG", "RC2STA", "SP2BRG", "SP2BRGH",
                      "SP2BRGL", "TX2REG", "TX2STA")):
        alias = sfrname[0:2] + sfrname[3:] + "2"  # make index "2" a suffix
    elif (sfrname in ("SSPCON", "SSP2CON")):
        alias = sfrname + "1"  # add suffix "1"
    elif ((sfrname.startswith("SSP")) & (sfrname[3] == "1")):  # first or only MSSP module
        alias = sfrname[0:3] + sfrname[4:]  # remove module number
        if (alias in ("SSPCON", "SSP2CON")):
            alias = alias + "1"
    if (alias != ""):  # alias to be declared
        fp.write("--\n")
        list_alias(fp, alias, sfrname)
        if (subfields_wanted(sfrname)):
            modelist = sfr.getElementsByTagName("edc:SFRMode")
            for mode in modelist:
                modeid = mode.getAttribute("edc:id")
                if modeid.startswith(("DS.", "LT.")):
                    if (len(mode.childNodes) > 0):
                        child = mode.firstChild
                        offset = list_sfr_subfield_alias(fp, child, alias, sfrname, 0)
                        while child.nextSibling:
                            child = child.nextSibling
                            offset = list_sfr_subfield_alias(fp, child, alias, sfrname, offset)

            #  Adding aliases for missing bitfields:
            if ((sfrname in ("SSPCON1", "SSP1CON1", "SSP2CON1")) &
                    (alias + "_SSPM" not in names) & (alias + "_SSPM3" in names)):
                list_alias(fp, alias + "_SSPM", sfrname + "_SSPM")


def list_multi_module_bitfield_alias(fp, reg, bitfield):
    """Add aliases of register bitfields related to
             multiple similar modules.

   input:  - register
           - bitfield
   returns: nothing
   Notes:  - Used for registers which happen to contain bitfields
             For - PIE, PIR and IPR registers
             USART and SSP interrupt bits
           - add unqualified alias for module 1
           - add (modified) alias for modules 2..9
   """
    j = ""  # default: no multi-module
    bitfield.upper()  # must be all capitals
    if (reg[0:3] in ("PIE", "PIR", "IPR")):
        if (bitfield[0:2] in ("TX", "RC")):
            j = bitfield[2]  # possibly module number
            if (j.isdigit()):
                strippedfield = bitfield[0:2] + bitfield[3:]
            else:
                j = bitfield[-1]  # possibly module number
                if (j.isdigit()):  # numeric suffix
                    strippedfield = left(bitfield, length(bitfield) - 1)
                else:  # no module number found
                    j = ""  # no alias required
        elif (bitfield.startswith("SSP") |  # SSP related bitfields
              bitfield.startswith("CCP")):  # CCP related bitfields
            j = bitfield[3]  # extract module number
            if (j == "1"):  # first module
                strippedfield = bitfield[:3] + bitfield[4:]  # remove the number
            else:  # no module number found
                j = ""  # no alias required
    if (j == ""):  # no module number found
        return  # no alias required
    if (j == "1"):  # first module
        j = ""  # no suffix
    alias = reg + "_" + strippedfield + j  # alias name (with suffix)
    list_alias(fp, alias, reg + "_" + bitfield)  # declare alias subfields


def list_status_sfr(fp, status):
    """ list status register

   Input:  - file pointer.
           - node of status sfr
   Note:
   """
    modes = status.getElementsByTagName("edc:SFRMode")
    for mode in modes:
        offset = 0
        bitfield = mode.firstChild
        offset = list_status_subfield(fp, bitfield, offset)
        while bitfield.nextSibling:
            bitfield = bitfield.nextSibling
            offset = list_status_subfield(fp, bitfield, offset)
    if cfgvar["core"] == "16":
        fp.write("const        byte   _banked %23s" % "=  1\n")
        fp.write("const        byte   _access %23s" % "=  0\n")


def list_status_subfield(fp, field, offset):
    """List subfields of status register

   Input: - start index in pic.
   Notes: - name is stored but not checked on duplicates
   """
    if (field.nodeType == Node.ELEMENT_NODE):
        if (field.nodeName == "edc:AdjustPoint"):
            offset = offset + eval(field.getAttribute("edc:offset"))
        elif (field.nodeName == "edc:SFRFieldDef"):
            fieldname = field.getAttribute("edc:cname").lower()
            width = eval(field.getAttribute("edc:nzwidth"))
            if (width == 1):
                if fieldname == "nto":
                    fp.write("const        byte   %-25s =  %d\n" % ("_not_to", offset))
                elif fieldname == "npd":
                    fp.write("const        byte   %-25s =  %d\n" % ("_not_pd", offset))
                else:
                    fp.write("const        byte   %-25s =  %d\n" % ("_" + fieldname, offset))
            offset = offset + width
    return offset

def ansel2j(reg, ans):
    """ Determine JANSEL number for ANSELx bit

   Input:   - register  (ANSELx,ADCONx,ANCONx, etc.)
            - Name of bit (ANSy / ANSELy)
   Returns: - channel number (decimal, default is the value of y in ANSy)
              (99 indicates 'no JANSEL number')
   Notes:   - procedure has 3 'core' groups and a subgroup for each ANSELx register.
            - needs adaptation for every new PIC(-group).
   """
    if (ans[-2:].isdigit()):  # name ends with 2 digits
        ansx = int(ans[-2:])  # 2 digits seq. nbr.
    else:  # 1 digit assumed
        ansx = int(ans[-1:])  # single digit seq. nbr.
    core = cfgvar["core"]
    picname = cfgvar["picname"]  # in lowercase!

    if ((core == "12") | (core == "14")):  # baseline or classic midrange
        if reg in ("ANSELH", "ANSEL1"):
            if ansx < 8:  # continuation of ANSEL[0|A]
                ansx = ansx + 8
        elif (reg == "ANSELG"):
            if ansx < 8:
                ansx = ansx + 8
        elif (reg == "ANSELE"):
            if picname.startswith(("16f70", "16lf70", "16f72", "16lf72")):
                ansx = ansx + 5
            else:
                ansx = ansx + 20
        elif (reg == "ANSELD"):
            if picname.startswith(("16f70", "16lf70", "16f72", "16lf72")):
                ansx = 99  # not for ADC
            else:
                ansx = ansx + 12
        elif (reg == "ANSELC"):
            if picname.startswith(("16f70", "16lf70")):
                ansx = 99
            elif picname.endswith(("f720", "f721")):
                ansx = (4, 5, 6, 7, 99, 99, 8, 9)[ansx]
            elif picname.endswith(("f753", "hv753")):
                ansx = (4, 5, 6, 7, 99, 99, 99, 99)[ansx]
            else:
                ansx = ansx + 12
        elif (reg == "ANSELB"):
            if picname.endswith(("f720", "f721")):
                ansx = ansx + 6
            elif picname.startswith(("16f70", "16lf70", "16f72", "16lf72")):
                ansx = (12, 10, 8, 9, 11, 13, 99, 99)[ansx]
            else:
                ansx = ansx + 6
        elif reg in ("ANSELA", "ANSEL", "ANSEL0", "ADCON0"):
            if picname.endswith(("f720", "f721", "f752", "hv752", "f753", "hv753")):
                ansx = (0, 1, 2, 99, 3, 99, 99, 99)[ansx]
            elif picname.startswith(("16f70", "16lf70", "16f72", "16lf72")):
                ansx = (0, 1, 2, 3, 99, 4, 99, 99)[ansx]
            elif (picname.startswith("16f9") & (ans[0:3] != "ANS")):
                ansx = 99  # skip dup ANSEL subfields 16f9xx
        else:
            print("   Unsupported ADC register:", reg)
            ansx = 99

    elif (core == "14H"):  # enhanced midrange
        if (reg == "ANSELG"):
            if picname.startswith(("16f191", "16lf191")):
                ansx = ansx + 48
            else:
                ansx = (99, 15, 14, 13, 12, 99, 99, 99)[ansx]
        elif (reg == "ANSELF"):
            if picname.startswith(("16f191", "16lf191")):
                ansx = ansx + 40
            else:
                ansx = (16, 6, 7, 8, 9, 10, 11, 5)[ansx]
        elif (reg == "ANSELE"):
            if picname.startswith(("16f151", "16lf151",
                                   "16f171", "16lf171",
                                   "16f178", "16lf178",
                                   "16f190", "16lf190",
                                   "16f193", "16lf193")):
                ansx = ansx + 5
            elif picname.startswith(("16f152", "16lf152")):
                ansx = (27, 28, 29, 99, 99, 99, 99, 99)[ansx]
            elif picname.startswith("16lf156"):
                ansx = (30, 41, 31, 99, 99, 99, 99, 99)[ansx]
            elif picname.startswith(("16f1537", "16lf1537",
                                     "16f1538", "16lf1538",
                                     "16f183", "16lf183",
                                     "16f188", "16lf188",
                                     "16f191", "16lf191")):
                ansx = ansx + 32
            elif picname.startswith(("16f194", "16lf194")):
                ansx = 99  # none
            else:
                ansx = ansx + 20
        elif (reg == "ANSELD"):
            if picname.startswith(("16f151", "16lf151",
                                   "16f17", "16lf17")):
                ansx = ansx + 20
            elif picname.startswith(("16f152", "16lf152")):
                ansx = (23, 24, 25, 26, 99, 99, 99, 99)[ansx]
            elif picname.startswith("16lf156"):
                ansx = (42, 32, 43, 33, 34, 44, 35, 45)[ansx]
            elif picname.startswith(("16f1537", "16lf1537",
                                     "16f1538", "16lf1538",
                                     "16f183", "16lf183",
                                     "16f188", "16lf188",
                                     "16f191", "16lf191")):
                ansx = ansx + 24
            elif picname.startswith(("16f193", "16lf193")):
                ansx = 99
            else:
                print("   ANSEL2J: Unsupported ADC register:", reg)
                ansx = 99  # none
        elif (reg == "ANSELC"):
            if picname.startswith(("16f151", "16lf151",
                                   "16f171", "16lf171",
                                   "16f177", "16lf177")):
                ansx = (99, 99, 14, 15, 16, 17, 18, 19)[ansx]
            elif picname.startswith("16lf1554"):
                ansx = (13, 23, 12, 22, 11, 21, 99, 99)[ansx]
            elif picname.startswith("16lf1559"):
                ansx = (13, 23, 12, 22, 11, 21, 14, 24)[ansx]
            elif picname.startswith("16lf156"):
                ansx = (12, 23, 13, 24, 14, 25, 15, 26)[ansx]
            elif picname.startswith(("16f145", "16lf145",
                                     "16f150", "16lf150",
                                     "16f157", "16lf157",
                                     "16f161", "16lf161",
                                     "16f170", "16lf170",
                                     "16f176", "16lf176",
                                     "16f182", "16lf182")):
                ansx = (4, 5, 6, 7, 99, 99, 8, 9)[ansx]
            elif picname.startswith(("16f178", "16lf178")):
                ansx = 99  # none
            elif picname.startswith(("16f153", "16lf153",
                                     "16f183", "16lf183",
                                     "16f184", "16lf184",
                                     "16f188", "16lf188",
                                     "16f191", "16lf191")):
                ansx = ansx + 16
            else:
                print("   ANSEL2J: Unsupported ADC register:", reg)
                ansx = 99  # none
        if (reg == "ANSELB"):
            if picname in ("16f1826", "16lf1826",
                           "16f1827", "16lf1827",
                           "16f1847", "16lf1847"):
                ansx = (99, 11, 10, 9, 8, 7, 5, 6)[ansx]
            elif picname.startswith(("16f145", "16lf145",
                                     "16f161", "16lf161",
                                     "16f176", "16lf176")):
                ansx = (99, 99, 99, 99, 10, 11, 99, 99)[ansx]
            elif picname.startswith(("16f150", "16lf150",
                                     "16f157", "16lf157",
                                     "16f170", "16lf170",
                                     "16f182", "16lf182")):
                ansx = (99, 99, 99, 99, 10, 11, 99, 99)[ansx]
            elif picname.startswith(("16f151", "16lf151",
                                     "16f171", "16lf171",
                                     "16f177", "16lf177",
                                     "16f178", "16lf178",
                                     "16f190", "16lf190",
                                     "16f193", "16lf193")):
                ansx = (12, 10, 8, 9, 11, 13, 99, 99)[ansx]
            elif picname.startswith("16lf155"):
                ansx = (99, 99, 99, 99, 26, 16, 25, 15)[ansx]
            elif picname.startswith("16lf156"):
                ansx = (16, 27, 17, 28, 18, 29, 19, 40)[ansx]
            elif picname.startswith(("16f152", "16lf152")):
                ansx = (17, 18, 19, 20, 21, 22, 99, 99)[ansx]
            elif picname.startswith(("16f153", "16lf153",
                                     "16f183", "16lf183",
                                     "16f184", "16lf184",
                                     "16f188", "16lf188",
                                     "16f191", "16lf191")):
                ansx = ansx + 8
            else:
                print("   ANSEL2J: Unsupported ADC register:", reg)
                ansx = 99  # none
        if (reg == "ANSELA"):
            if picname in ("16f1826", "16lf1826",
                           "16f1827", "16lf1827",
                           "16f1847", "16lf1847"):
                ansx = ansx + 0
            elif picname.startswith(("16f153", "16lf153",
                                     "16f183", "16lf183",
                                     "16f184", "16lf184",
                                     "16f188", "16lf188",
                                     "16f191", "16lf191")):
                ansx = ansx + 0  # ansx is OK asis
            elif picname.startswith(("16f145", "16lf145")):
                ansx = (99, 99, 99, 99, 3, 99, 99, 99)[ansx]
            elif picname.startswith(("12f161", "12lf161",
                                     "16f157", "16lf157",
                                     "16f161", "16lf161",
                                     "16f170", "16lf170",
                                     "16f176", "16lf176")):
                ansx = (0, 1, 2, 99, 3, 99, 99, 99)[ansx]
            elif picname.startswith(("12f15", "12lf15",
                                     "12f182", "12lf182",
                                     "12f184", "12lf184",
                                     "16f150", "16lf150",
                                     "16f170", "16lf170",
                                     "16f182", "16lf182")):
                ansx = (0, 1, 2, 99, 3, 4, 99, 99)[ansx]
            elif picname.startswith("16lf155"):
                ansx = (0, 1, 2, 99, 10, 20, 99, 99)[ansx]
            elif picname.startswith("16lf156"):
                ansx = (20, 10, 0, 1, 2, 21, 22, 11)[ansx]
            elif picname.startswith(("16f151", "16lf151",
                                     "16f152", "16lf152",
                                     "16f171", "16lf171",
                                     "16f177", "16lf177",
                                     "16f178", "16lf178",
                                     "16f190", "16lf190",
                                     "16f193", "16lf193",
                                     "16f194", "16lf194")):
                ansx = (0, 1, 2, 3, 99, 4, 99, 99)[ansx]
            else:
                print("   ANSEL2J: Unsupported ADC register:", reg)
                ansx = 99

    elif (core == "16"):  # 18F series
        if (reg == "ANCON3"):
            if (ansx < 8):
                if picname.endswith(("j94", "j99")):
                    ansx = ansx + 16
                else:
                    ansx = ansx + 24
        elif (reg == "ANCON2"):
            if (ansx < 8):
                if picname.endswith(("j94", "j99")):
                    ansx = ansx + 8
                else:
                    ansx = ansx + 16
        elif (reg == "ANCON1"):
            if (ansx < 8):
                if picname.endswith(("j94", "j99")):
                    ansx = ansx + 0
                else:
                    ansx = ansx + 8
        elif (reg == "ANCON0"):
            if (ansx < 8):
                ansx = ansx + 0
        elif ((reg == "ANSELH") | (reg == "ANSEL1")):
            if ((picname in ("18f13k22", "18lf13k22", "18f14k22", "18lf14k22")) &
                    (ans.startswith("ANSEL"))):
                # print("   Suppressing probably duplicate JANSEL_ANSx declaration (" + ans + ")")
                ansx = 99
            elif (ansx < 8):
                ansx = ansx + 8
        elif (reg == "ANSELG"):
            if (picname.endswith("k40")):
                ansx = ansx + 48
            else:
                ansx = ansx + 48
        elif (reg == "ANSELF"):
            if (picname.endswith("k40")):
                ansx = ansx + 40
            else:
                ansx = ansx + 40
        elif (reg == "ANSELE"):
            if (picname.endswith("k40")):
                ansx = ansx + 32
            else:
                ansx = ansx + 5
        elif (reg == "ANSELD"):
            if (picname.endswith("k40")):
                ansx = ansx + 24
            else:
                ansx = ansx + 20
        elif (reg == "ANSELC"):
            if (picname.endswith("k40")):
                ansx = ansx + 16
            else:
                ansx = ansx + 12
        elif (reg == "ANSELB"):
            if (picname.endswith("k40")):
                ansx = ansx + 8
            else:
                ansx = (12, 10, 8, 9, 11, 13, 99, 99)[ansx]
        elif reg in ("ANSELA", "ANSEL", "ANSEL0"):
            if picname in ("18f13k22", "18lf13k22", "18f14k22", "18lf14k22"):
                if (ans.startswith("ANSEL")):
                    # print("   Suppressing probably duplicate JANSEL_ANSx declarations (" + ans + ")")
                    ansx = 99
            elif (picname in ("18f24k50", "18lf24k50", "18f25k50", "18lf25k50", "18f45k50", "18lf45k50")):
                ansx = (0, 1, 2, 3, 99, 4, 99, 99)[ansx]
            elif (picname.endswith("k40")):
                ansx = ansx
            elif picname.endswith("k22") & (ansx == 5):
                ansx = 4  # jump
        else:
            print("   Unsupported ADC register:", reg)
            ansx = 99

    if (ansx < 99):  # AN pin present
        if picname.startswith(("16f153", "16lf153",
                               "16f183", "16lf183",
                               "16f1845", "16lf1845",
                               "16f1842", "16lf1842",
                               "16f1844", "16lf1844",
                               "16f188", "16lf188",
                               "16f191", "16lf191")):
            aliasname = "AN%c%d" % ("ABCDEFG"[ansx // 8], ansx % 8)  # new ADC pin naming convention
        elif (picname.endswith(("k40", "k42"))):  # 18[l]fxxk40/42
            aliasname = "AN%c%d" % ("ABCDEFG"[ansx // 8], ansx % 8)  # new ADC pin naming convention
        else:
            aliasname = "AN%d" % ansx
        # RJ: 2018-02-18. Exclude error message for PICs that have ANx pins but no ADC.
        if picname in ("12f609", "12hv609",
                       "16f1454", "16lf1454"):
            ansx = 99
        elif (aliasname not in pinanmap[picname.upper()]):
            print("   No", aliasname, "in pinanmap corresponding to", reg + "_" + ans)
            ansx = 99
    return ansx


def list_digital_io(fp, picname):
    """ Generate instructions to set all I/O to digital mode

   Input:   - output file
            - picname
   Output:  part of device files
   Returns: (nothing)
   """
    fp.write("--\n")
    list_separator(fp)
    fp.write("-- Constants and procedures related to analog features\n")
    list_separator(fp)
    fp.write("\n")

    picdata = dict(list(devspec[picname.upper()].items()))  # pic specific info

    fp.write("\n")
    fp.write("const byte ADC_ADCS_BITCOUNT  = " + "%d" % cfgvar["adcs_bits"] + "\n")
    fp.write("--\n")

    analog = []  # list of analog component names
    if (("ANSEL" in names) |
            ("ANSEL1" in names) |
            ("ANSELA" in names) |
            ("ANSELC" in names) |
            ("ANCON0" in names) |
            ("ANCON1" in names)):
        analog.append("ANSEL")  # analog functions present
        fp.write("-- - - - - - - - - - - - - - - - - - - - - - - - - - -\n" +
                 "-- Change analog I/O pins into digital I/O pins.\n" +
                 "procedure analog_off() is\n" +
                 "   pragma inline\n")

        if "ANSEL" in names:
            fp.write("   ANSEL  = 0b0000_0000\n")
        for i in range(10):  # ANSEL0..ANSEL9
            qname = "ANSEL" + str(i)
            if qname in names:
                fp.write("   " + qname + " = 0b0000_0000\n")
        caps = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for i in range(len(caps)):  # ANSELA..Z
            qname = "ANSEL" + caps[i]  # qualified name
            if qname in names:
                fp.write("   " + qname + " = 0b0000_0000\n")
        for i in range(10):  # ANCON0..ANCON9
            qname = "ANCON%d" % i
            if qname in names:
                bitname = "$$$"
                for j in range(0, 8 * i + 8):  # all PCFG bits
                    bitname = qname + "_PCFG" + str(j)
                    if bitname in names:  # ANCONi has a PCFG bit
                        fp.write("   " + qname + " = 0b1111_1111\n")
                        break
                if bitname not in names:  # ANCONi has no PCFG bit
                    for j in range(0, 8 * i + 8):  # try ANSEL bits
                        bitname = qname + "_ANSEL" + str(j)  # ANSEL bit
                        if bitname in names:  # ANCONi has ANSEL bit(s)
                            fp.write("   " + qname + " = 0b0000_0000\n")
                            break
        fp.write("end procedure\n" +
                 "--\n")

    if ("ADCON0" in names) | \
            ("ADCON" in names):
        analog.append("ADC")  # ADC module(s) present
        fp.write("-- - - - - - - - - - - - - - - - - - - - - - - - - - -\n" +
                 "-- Disable ADC module\n" +
                 "procedure adc_off() is\n" +
                 "   pragma inline\n")
        if "ADCON0" in names:
            fp.write("   ADCON0 = 0b0000_0000\n")
        else:
            fp.write("   ADCON  = 0b0000_0000\n")
        if ("ADCON1" in names):
            if ("ADCON1" not in picdata):
                print("   Provisional value for ADCON1 specified")
                fp.write("   ADCON1 = 0b0000_0000\n")
            else:
                fp.write("   ADCON1 = " + picdata["ADCON1"] + "\n")
            if "ADCON2" in names:
                fp.write("   ADCON2 = 0b0000_0000\n")  # all groups
        fp.write("end procedure\n")
        fp.write("--\n")

    if (("CMCON" in names) |
            ("CMCON0" in names) |
            ("CM1CON" in names) |
            ("CM1CON0" in names)):
        analog.append("COMPARATOR")  # Comparator(s) present
        fp.write("-- - - - - - - - - - - - - - - - - - - - - - - - - - -\n" +
                 "-- Disable comparator module\n" +
                 "procedure comparator_off() is\n" +
                 "   pragma inline\n")
        if "CMCON" in names:
            if "CMCON_CM" in names:
                fp.write("   CMCON  = 0b0000_0111\n")
            else:
                fp.write("   CMCON  = 0b0000_0000\n")
        elif "CMCON0" in names:
            if "CMCON0_CM" in names:
                fp.write("   CMCON0 = 0b0000_0111\n")
            else:
                fp.write("   CMCON0 = 0b0000_0000\n")
            if "CMCON1" in names:
                fp.write("   CMCON1 = 0b0000_0000\n")
        elif "CM1CON" in names:
            if "CM1CON_CM" in names:
                fp.write("   CM1CON = 0b0000_0111\n")
            else:
                fp.write("   CM1CON = 0b0000_0000\n")
            if "CM2CON" in names:
                fp.write("   CM2CON = 0b0000_0000\n")
            if "CM3CON" in names:
                fp.write("   CM3CON = 0b0000_0000\n")
        for x in range(1, 9):  # comparator modules 1..8
            creg = "CM%dCON0" % (x)
            if creg in names:
                fp.write("   " + creg + " = 0b" + cfgvar["cmxcon0mask"] + "\n")
            creg = "CM%dCON1" % (x)
            if creg in names:
                fp.write("   " + creg + " = 0b0000_0000\n")
        fp.write("end procedure\n")
        fp.write("--\n")

    fp.write("-- - - - - - - - - - - - - - - - - - - - - - - - - - -\n" +
             "-- Switch analog ports to digital mode when analog module(s) present.\n" +
             "procedure enable_digital_io() is\n" +
             "   pragma inline\n")
    if "ANSEL" in analog:
        fp.write("   analog_off()\n")
    if "ADC" in analog:
        fp.write("   adc_off()\n")
    if "COMPARATOR" in analog:
        fp.write("   comparator_off()\n")
    if cfgvar["core"] == "12":  # baseline PIC
        fp.write("   OPTION_REG_T0CS = OFF        -- T0CKI pin input + output\n")
    fp.write("end procedure\n")


def list_miscellaneous(fp, root, picname):
    """ Generate miscellaneous information

   Input:   - output file
            - root of XML structure
            - picname
   Output:  part of device files
   Returns: (nothing)
   """
    fp.write("--\n")
    list_separator(fp)
    fp.write("--    Miscellaneous information\n")
    list_separator(fp)
    fp.write("--\n")
    fp.write("const PPS_GROUP             = PPS_")
    picdata = dict(list(devspec[picname.upper()].items()))
    if (("PPSCON" in names) & (cfgvar["core"] == "16")):
        if (picname.endswith(("11", "50"))):
            fp.write("1\n")
        elif (picname.endswith(("13", "53"))):
            fp.write("2\n")
        else:
            print("   Undeterminded PPS group")
            fp.write("0       -- undetermined!\n")
    elif (("OSCCON2_IOLOCK" in names) & (cfgvar["core"] == "16")):
        fp.write("3\n")
    elif (("PPSLOCK" in names) & (cfgvar["core"] in ("14H", "16"))):
        if ("PMD0" not in names):
            fp.write("4\n")
        else:
            fp.write("5\n")
        list_pps_out_consts(fp, root, picname)  # device specific PPS output constants
    else:
        fp.write("0       -- no Peripheral Pin Selection\n")

    if "UCON" in names:  # USB control register present
        fp.write("--\n")
        if "USBBDT" in picdata:
            fp.write("const word USB_BDT_ADDRESS  = 0x" + picdata["USBBDT"] + "\n")
        else:
            print("   Has USB module but USB_BDT_ADDRESS not specified")

    fp.write("--\n")
    sharedmem_avail = sharedmem[1] - sharedmem[0] + 1
    if (sharedmem_avail > 0):
        fp.write("-- Free shared memory: 0x%X" % sharedmem[0])
        if (sharedmem_avail > 1):
            fp.write("-0x%X" % sharedmem[1])
        fp.write("\n")
    else:
        fp.write("-- No free shared memory!\n")


def list_pps_out_consts(fp, root, picname):
    """ Declare constants for PPS output

   Input:   - output file
            - root of XML structure
   Output:  List of constants for PICs in PPS_GROUPS 4 and 5
   Returns: (nothing)
   Notes:   patterns are first collected, then listed sorted on pattern value
            Some check is done on valid pattern to assume that RxyPPS is never > 100 (found a valid max of 48)
   """
    ppsoutdict = {}  # dictionary of (value:name)
    nopatt = 200 # dummy key for missing pattern
    pps_warning = False
    remaplist = root.getElementsByTagName("edc:RemappablePin")
    for pin in remaplist:
        pindir = pin.getAttribute("edc:direction")
        if (pindir in ("out", "bi")):
            vpins = pin.getElementsByTagName("edc:VirtualPin")
            for vpin in vpins:
                pinfunc = vpin.getAttribute("edc:name")
                pinpatt = vpin.getAttribute("edc:ppsval")
                if (len(pinpatt) == 0):  # no pattern found
                    ppsoutdict[nopatt] = pinfunc  # assign dummy
                    nopatt += 1
                else:
                    if (len(pinpatt) < 5):  # probably dec or hex
                        pinpatt = eval(pinpatt)
                        if pinpatt in ppsoutdict:
                            tmp = ppsoutdict[pinpatt]  # get old
                            tmp.append(pinfunc)
                            ppsoutdict[pinpatt] = tmp
                        else:
                            ppsoutdict[pinpatt] = [pinfunc]
                    else:  # probably bin
                        ppsoutdict[int(pinpatt, base=2)] = [pinfunc]

    if (len(ppsoutdict) > 0):  # pps output pin(s) present
        fp.write("--\n--    PPS OUTPUT constants\n--\n")
        pps_line_format = "const byte PPS_%-9s = %s\n"
        pps_alias_format = "alias      PPS_%-8s is PPS_%s\n"
        fp.write(pps_line_format % ("NULL", "0x00"))
        ppskeys = list(ppsoutdict.keys())
        ppskeys.sort()
        for k in ppskeys:
            # If RxyPPS is too big there might be an error in the MPLABX file. Assume 100 it too big.
            if (k > 100):
                pps_warning = True
            if (k < 200): # pattern found in .pic file
                for f in ppsoutdict[k]:
                    if (picname in ("16f15355", "16f15356", "16lf15355", "16lf15356")):
                        if ((f == "CK2") & (k == 0x0F)):
                            f = "CK1"  # correction of MPLABX error. @2018-06-17: Correction still needed.
                    fp.write(pps_line_format % (f, "0x%02X" % (k)))
                    if ((f == "TXCK") | (f == "CKTX")):  # frequent combo in MPLABX
                        if (["TX"] not in ppsoutdict.values()):
                            print("   Adding PPS_TX for", f)
                            fp.write(pps_line_format % ("TX", "0x%02X" % (k)))
                        if (["CK"] not in ppsoutdict.values()):
                            print("   Adding PPS_CK for", f)
                            fp.write(pps_line_format % ("CK", "0x%02X" % (k)))
                    composite = f.split("_")
                    if (len(composite) > 1):  # probably multiple functions
                        for x in composite:
                            fp.write(pps_alias_format % (x, f))
            else:  # no pattern found
                print("   Missing PPS output pattern for", ppsoutdict[k])
                if (ppsoutdict[k] == "CK"):  # frequently missing in MPLABX
                    if (["TX"] in ppsoutdict.values()):  # check for TX
                        print("   Adding alias PPS_TX for CK")
                        fp.write(pps_alias_format % ("CK", "TX"))
                else:
                    fp.write(pps_line_format % (ppsoutdict[k], "0x00      -- fault"))

        # adding possible omissions in MPLABX
        if ((["SCK"] in ppsoutdict.values()) & (["SCL"] not in ppsoutdict.values())):
            print("   Adding alias PPS_SCL for SCK")
            fp.write(pps_alias_format % ("SCL", "SCK"))
        if ((["SDO"] in ppsoutdict.values()) & (["SDA"] not in ppsoutdict.values())):
            print("   Adding alias PPS_SDA for SDO")
            fp.write(pps_alias_format % ("SDA", "SDO"))

        fp.write("--\n")
    if (pps_warning == True):
        print("   Warning: Possible error in MPLABX for PPS")


def list_fuse_defs(fp, root):
    """ Generate all fuse_def statements

   Input:   - output file
            - root of XML structure
   Output:  part of device files
   Returns: (nothing)
   """
    fp.write("--\n")
    list_separator(fp)
    fp.write("--    Symbolic Fuse Definitions\n")
    list_separator(fp)
    configfusesectors = root.getElementsByTagName("edc:ConfigFuseSector")
    if (len(configfusesectors) == 0):
        configfusesectors = root.getElementsByTagName("edc:WORMHoleSector")
    for configfusesector in configfusesectors:
        dcraddr = eval(configfusesector.getAttribute("edc:beginaddr"))  # start address
        if (len(configfusesector.childNodes) > 0):
            dcrdef = configfusesector.firstChild
            dcraddr = list_dcrdef(fp, dcrdef, dcraddr)
            while dcrdef.nextSibling:
                dcrdef = dcrdef.nextSibling
                dcraddr = list_dcrdef(fp, dcrdef, dcraddr)


def list_dcrdef(fp, dcrdef, addr):
    """ Generate declaration of a configuration byte/word, incl subfields

   Input:   - output file
            - config fuse sector node
            - current config address
   Output:  part of device file
   Returns: config fuse address (updated if applicable)
   """
    if (dcrdef.nodeName == "edc:AdjustPoint"):
        addr = addr + eval(dcrdef.getAttribute("edc:offset"))
    elif (dcrdef.nodeName == "edc:DCRDef"):
        dcrname = dcrdef.getAttribute("edc:cname")
        fp.write("--\n")
        fp.write("-- %s (0x%X)\n" % (dcrname, addr))
        fp.write("--\n")
        dcrmodes = dcrdef.getElementsByTagName("edc:DCRMode")
        for dcrmode in dcrmodes:
            if (dcrmode.nodeType == Node.ELEMENT_NODE):
                if (len(dcrmode.childNodes) > 0):
                    offset = 0
                    dcrfielddef = dcrmode.firstChild
                    offset = list_dcrfielddef(fp, dcrfielddef, addr - cfgvar["fuseaddr"], offset)
                    while dcrfielddef.nextSibling:
                        dcrfielddef = dcrfielddef.nextSibling
                        offset = list_dcrfielddef(fp, dcrfielddef, addr - cfgvar["fuseaddr"], offset)
        addr = addr + 1
    return addr


def list_dcrfielddef(fp, dcrfielddef, index, offset):
    """ Generate declaration of a configuration byte/word, incl subfields

   Input:   - output file
            - config fuse sector node
            - current config bits index and offset
   Output:  part of device file
   Returns: config fuse address (updated if applicable)
   """
    if (dcrfielddef.nodeName == "edc:AdjustPoint"):
        offset = offset + eval(dcrfielddef.getAttribute("edc:offset"))
    elif (dcrfielddef.nodeName == "edc:DCRFieldDef"):
        width = eval(dcrfielddef.getAttribute("edc:nzwidth"))
        if (dcrfielddef.hasAttribute("edc:ishidden") == False):  # do not list hidden fields
            name = dcrfielddef.getAttribute("edc:cname").upper()
            name = normalize_fusedef_key(name)
            mask = eval(dcrfielddef.getAttribute("edc:mask"))
            str = "pragma fuse_def " + name
            if (cfgvar["fusesize"] > 1):
                str = str + ":%d " % (index)
            str = str + " 0x%X {" % (mask << offset)  # position in byte!
            fp.write("%-40s -- %s\n" % (str, dcrfielddef.getAttribute("edc:desc")))
            list_dcrfieldsem(fp, name, dcrfielddef, offset)
            fp.write("       }\n")
        offset = offset + width
    return offset


def list_dcrfieldsem(fp, key, dcrfielddef, offset):
    """ Generate declaration of a dcrdeffield semantics

   Input:   - output file
            - fuse bitfield child node
            - field offset
   Output:
   Returns: offset next child
   Notes:   - bitfield
   """
    kwdsemlist = []
    for child in dcrfielddef.childNodes:
        if (child.nodeName == "edc:DCRFieldSemantic"):
            if ((child.hasAttribute("edc:ishidden") == False) &
                    (child.hasAttribute("edc:cname") == True)):
                fieldname = child.getAttribute("edc:cname").upper()
                if ((not fieldname.startswith("RESERVED")) & (fieldname != "")):
                    if (child.hasAttribute("edc:islanghidden") == False):
                        when = child.getAttribute("edc:when").split()
                        desc = child.getAttribute("edc:desc")
                        fieldname = normalize_fusedef_value(key, fieldname, desc)
                        if (fieldname != ""):
                            if (fieldname not in kwdsemlist):
                                kwdsemlist.append(fieldname)
                                if ((key == "XINST") & (fieldname == "ENABLED")):
                                    str = "--     " + fieldname + " = " + "0x%X" % (eval(when[-1]) << offset)
                                    fp.write("%-40s -- %s\n" % (str, "NOTE: not supported by JALV2"))
                                else:
                                    str = "       " + fieldname + " = " + "0x%X" % (eval(when[-1]) << offset)
                                    fp.write("%-40s -- %s\n" % (str, desc))
                                if (key == "ICPRT"):
                                   if (cfgvar["picname"] in ("18f24k50", "18f25k50", "18lf24k50", "18lf25k50")):
                                        print("   Adding 'ENABLED' for fuse_def " + key)
                                        str = "       ENABLED = 0x20"
                                        fp.write("%-40s %s\n" % (str, "-- ICPORT enabled"))
                            else:
                                if ((key == "WDTCPS") & (fieldname == "F32 ")):
                                    pass  # suppress 'duplicate' msg (too many msgs!)
                                else:
                                    print("   Skipping duplicate fuse_def", key, ":", fieldname, "(", desc, ")")


def normalize_fusedef_key(key):
    """ Normalize fusedef keywords (rename synonyms to base keyword)

   Input:   - fuse_def keyword from XML structure
   Returns: - normalized keyword
   """
    if (key == ""):
        return key
    if (key in ("RES", "RES1")) | key.startswith("RESERVED"):
        return key
    picname = cfgvar["picname"]

    if (key.find("ENICPORT") >= 0):
        return key

    elif key.startswith("EBRT"):  # typo MPLABX!
        key = "EBTR" + key[4:]

    elif (key in fusedef_kwd):
        key = fusedef_kwd[key]  # translate by table (dictionary)
    else:
        print("   Warning: No normalization done for fusedef keyword ",key)

    return key


def normalize_fusedef_value(key, val, desc):
    """ Determination of appropriate keyword value for fuse_defs

   Input:   - fuse_def keyword
            - keyword value (name of DCRFieldSemantic)
            - keyword value description string
   Returns: Keyword value
   Notes:   Modified description field (descu) is returned
            when no suitable simple keyword could be found
   """
    picname = cfgvar["picname"]
    descu = desc.upper()  # whole description in uppercase
    descl = descu.split(" ")  # list of (uppercase) words in desc.
    xtable = descu.maketrans("+-:;.,<>{}[]()=/?",
                             "                 ")  # translate fuse_def descriptions
    descu = descu.translate(xtable)  # replace special chars by spaces
    descu = "_".join(descu.split())  # new desc with all spaces -> single underscore
    kwdvalue = ""  # default

    def reserved(val):
        return ""

    def unimplemented(val):
        return ""

    def abw(val):  # address bus width
        if ((val.startswith("ADDR")) & (val.endswith("BIT"))):
            return "B" + val[4:-3]
        elif (val in ("XM12", "XM16", "XM20")):
            return "B" + val[2:]
        elif (val == "MM"):
            return "B8"
        elif (val.isdigit()):
            return "B" + val
        else:
            return descu

    def adcsel(val):
        if (val.startswith("BIT")):
            return "B" + val[3:]
        elif (val.isdigit()):
            return "B" + val

    def bbsiz(val):
        if (val.isdigit()):
            x = eval(val)
            if (x >= 1024):
                return "W%dK" % (x // 1024)
            else:
                return "W%d" % (x)
        elif (val.startswith("BB")):
            x = val[2:]
            if (x.endswith("K")):
                return "W" + x
            elif (x.isdigit()):
                if (eval(x) >= 1024):
                    return "W%dK" % (eval(x) // 1024)
                else:
                    return "W" + x
            else:
                return "W" + x
        elif (descl[0].endswith("W")):
            return "W" + descl[0][:-1]
        else:
            return descu

    def bg(val):  # band gap
        if (val == '0'):
            return "HIGHEST"
        elif (val == "3"):
            return "LOWEST"
        else:
            return descu

    def borpwr(val):  # BOR power mode
        if (val == "ZPBORMV"):
            return "ZERO"
        elif (val == "HIGH"):
            return "HP"
        elif (val == "MEDIUM"):
            return "MP"
        elif (val == "LOW"):
            return "LP"
        else:
            return descu

    def brownout(val):
        if (val in ("BOACTIVE", "NOSLP", "SLEEP", "NSLEEP", "ON_ACTIVE", "SLEEP_DIS")):
            return "RUNONLY"
        elif (val in ("ON")):
            if ((descu.find("CONTROLLED") >= 0) | (descu.find("ACCORDING") > 0)):
                return "CONTROL"
            else:
                return "ENABLED"
        elif (val in ("EN", "ON", "BOHW", "SBORDIS")):
            return "ENABLED"
        elif (val in ("SBODEN", "SBOREN", "SOFT", "SBORENCTRL")):
            return "CONTROL"
        elif (val in ("DIS", "OFF")):
            return "DISABLED"
        else:
            return descu

    def canmux(val):
        if (val == "PORTB"):
            return "pin_B2"
        elif (val == "PORTC"):
            return "pin_C6"
        elif (val == "PORTE"):
            return "pin_E5"
        else:
            return descu

    def ccp1mux(val):
        if ((descu.find("RB3") != -1) & (descu.find("RE7") != -1)):  # special
            return "pin_RB3_RE7"
        elif descl[-1].startswith("R"):  # last word is pin name
            return "pin_" + descl[-1][-2:]  # last 2 chars
        else:
            return descu

    def ccp2mux(val):
        return ccp1mux(val)

    def ccp3mux(val):
        return ccp1mux(val)

    def cinasel(val):
        if (descu.find("DEFAULT") >= 0):  # Microcontroller mode
            return "DEFAULT"
        else:
            return "MAPPED"

    def cpudiv(val):
        if (val in ("NOCLKDIV", "OSC1", "OSC1_PLL2")):
            return "P1"  # no PLL
        elif (val in ("CLKDIV2", "OSC2_PLL2", "OSC2_PLL3")):
            return "P2"
        elif (val in ("CLKDIV3", "OSC3_PLL3", "OSC3_PLL4")):
            return "P3"
        elif (val in ("CLKDIV4", "OSC4_PLL6")):
            if (descl[-1] == "6"):
                return "P6"  # exception!
            else:
                return "P4"
        elif (val in ("CLKDIV6", "OSC4_PLL6")):
            return "P6"
        else:
            return descu

    def dbw(val):  # data bus width
        if (val.isdigit()):
            return "B" + val
        elif ((val.startswith("DATA")) & (val.endswith("BIT"))):
            return "B" + val[4:-3]
        else:
            return descu

    def dswdtosc(val):
        if (val == "INTOSCREF"):
            return "INTOSC"
        elif (val == "LPRC"):
            return "LPRC"
        elif (val == "SOSC"):
            return "SOSC"
        elif (val == "T1OSCREF"):
            return "T1"
        else:
            return descu

    def eccpmux(val):
        offset = descu.find("_R")
        if (offset >= 0):
            return "pin_" + descu[offset + 2: offset + 4]
        else:
            return descu

    def emb(val):
        if (desc.find("12") >= 0):  # 12-bit mode
            return "B12"
        elif (desc.find("16") >= 0):  # 16-bit mode
            return "B16"
        elif (desc.find("20") >= 0):  # 20-bit mode
            return "B20"
        else:
            return "DISABLED"  # no en/disable balancing

    def ethled(val):
        if ((val == "ON") | (descu.find("ENABLED") >= 0)):  # LED enabled
            return "ENABLED"
        else:
            return "DISABLED"

    def exclkmux(val):
        offset = descu.find("_R")
        if (offset >= 0):
            return "pin_" + descu[offset + 2: offset + 4]
        else:
            return descu

    def fosc2(val):
        if (val in ("ON", "OFF")):
            return val
        else:
            return descu

    def fcmen(val):
        if (val == "OFF"):
            return "DISABLED"
        elif (val == "ON"):
            return "ENABLED"
        elif (val == "CSDCMD"):
            return "DISABLED"
        elif (val == "CSECMD"):
            return "SWITCHING"
        elif (val == "CSECME"):
            return "ENABLED"
        else:
            return descu

    def fltamux(val):
        if ((val.startswith("R")) & (len(val) == 3)):
            return "pin_" + val[1:]
        else:
            return descu

    def intoscsel(val):
        if (val == "HIGH"):
            return "HP"
        elif (val == "LOW"):
            return "LP"
        else:
            return descu

    def ioscfs(val):
        if (val in ("ON", "8MHZ")):
            return "F8MHZ"
        elif (val in ("OFF", "4MHZ")):
            return "F4MHZ"
        else:
            return descu


    def lpt1osc(val):
        if (val == "ON"):
            return "LOW_POWER"
        elif (val == "OFF"):
            return "HIGH_POWER"
        else:
            return descu

    def ls48mhz(val):
        return "P" + val[-1]

    def mclr(val):
        if (val in ("OFF", "INTMCLR")):
            return "INTERNAL"
        elif (val in ("ON", "EXTMCLR")):
            return "EXTERNAL"

        else:
            return descu

    def msspmask(val):
        if (descu[0].isdigit()):
            return "B" + descu[0]  # digit 5 or 7 expected
        else:
            return descu

    def msspmsk1(val):
        return msspmask(val)

    def msspmsk2(val):
        return msspmask(val)

    def osc(val):
        if ("0" <= descu[0] <= "1"):
            print("   Skipping probably duplicate/unused masks", key, ":", desc)
            kwdvalue = "   "
        else:
            if (val in fusedef_osc):
                kwdvalue = fusedef_osc[val]  # translate val to keyword
                # handling of exceptions to the dictionary
                # order is important!
                if (picname in ("16f707", "16lf707", "16f720", "16lf720", "16f721", "16lf721")):
                    if (val == "EXTRC"):
                        kwdvalue = "RC_CLKOUT"
                    elif (val == "INTOSC"):
                        kwdvalue = "INTOSC_CLKOUT"
                elif (picname == "16f87"):
                    if (val == "EC"):
                        kwdvalue = "EC_NOCLKOUT"
                elif ((picname in ("16f83", "16f84", "16f84a")) | (picname.startswith("16f87"))):
                    if (val == "EXTRC"):
                        kwdvalue = "RC_CLKOUT"
                elif picname.startswith(("10f3", "10lf3",  # exceptions for ec-noclkout
                                         "12f6", "12hv6",
                                         "12f7", "12hv7",
                                         "16f5",
                                         "16f61", "16hv61",
                                         "16f63",
                                         "16f67",
                                         "16f68",
                                         "16f69",
                                         "16f7", "16hv7", "16lf7",
                                         "16f8",
                                         "16f9")):
                    if (kwdvalue == "EC_NOCLKOUT"):
                        kwdvalue = "EC_CLKOUT"
                    elif (kwdvalue == "EC_CLKOUT"):
                        kwdvalue = "EC_NOCLKOUT"
                elif picname in ("18f13k22", "18lf13k22", "18f13k50", "18lf13k50",
                                 "18f14k22", "18lf14k22", "18f14k50", "18lf14k50"):
                    if (val == "IRC"):
                        kwdvalue = "INTOSC_NOCLKOUT"
                elif picname in ("18f25k80", "18f26k80"):
                    if (val == "RC"):
                        kwdvalue = "RC_CLKOUT"
            else:
                print("  Missing <" + val + "> as key in fusedef_osc")
                kwdvalue = ""
        return kwdvalue

    def p2bmux(val):
        if (val in ("PORTB5", "PORTC0", "PORTD2")):
            return "pin_" + val[4:]
        else:
            return descl[-1]

    def parity(val):
        if (desc.find("CLEAR") >= 0):
            return "CLEAR"
        else:
            return "SET"

    def pbaden(val):
        if (val in ("ANA", "ON")):
            return "ANALOG"
        else:
            return "DIGITAL"

    def plldiv(val):
        if (val in fusedef_plldiv):
            return fusedef_plldiv[val]
        else:
            return descu

    def pllsel(val):
        if val in ("PLL96", "PLL3X", "PLL4X"):
            return val
        else:
            return descu

    def pmode(val):
        if (val in ("XM12", "XM16", "XM20")):
            return "B" + val[2:]
        elif (val == "EM"):
            return "EXT"
        elif (val in ("MC", "MM")):
            return "MICROCONTROLLER"
        elif (val == "MP"):
            return "MICROPROCESSOR"
        elif (val == "MPB"):
            return "MICROPROCESSOR_BOOT"
        else:
            return descu

    def pmpmux(val):
        if (val == "ALTERNATE"):
            return "PMP"
        elif (val == "DEFAULT"):
            return "EMB"
        else:
            return descu

    def poscmd(val):  # primary osc
        if (val in ("EC", "HS", "MS")):
            return val
        elif (val == "NONE"):
            return "DISABLED"
        else:
            return descu

    def pwm4mux(val):
        offset = descu.find("_R")
        if (offset >= 0):
            return "pin_" + descu[offset + 2: offset + 4]
        else:
            return descu

    def pwrte(val):
        if (val in ("OFF", "PWRT_OFF", "PWRT_DIS", "DISABLED")):
            return "DISABLED"
        elif (val in ("ON", "PWRT_ON", "PWRT_EN", "ENABLED")):
            return "ENABLED"
        elif (val.startswith("PWR")):
            return val
        else:
            return descu

    def pwrts(val):
        if (val.startswith("PWR")):
            return val
        else:
            return descu

    def rstosc(val):
        return val

    def rtcosc(val):
        if (val == "INTOSCREF"):
            return "INTOSC"
        elif (val == "SOSCREF"):
            return "SOSC"
        elif (val == "T1OSCREF"):
            return "T1OSC"
        else:
            return descu

    def sdomux(val):
        if (val in ("RB3", "RC7")):
            return "pin_" + val[1:]
        else:
            return descl[-1]  # last word

    def scane(val):
        if ((val == "AVAILABLE") | (val == "ON")):
            return "ENABLED"
        elif ((val == "NOT_AVAILABLE") | (val == "OFF")):
            return "DISABLED"
        else:
            return descu

    def sign(val):
        if (descu.find("CONDUC") >= 0):
            return "NOT_CONDUCATED"
        else:
            return "AREA_COMPLETE"

    def soscsel(val):
        if (val == "HIGH"):
            return "HP"
        elif (val == "DIG"):
            return "DIG"
        elif (val == "LOW"):
            return "LP"
        # elif (descu.find("SECURITY") >= 0):
        #    return "HS_CP"
        else:
            return descu

    def sspmux(val):
        offset = descu.find("_R")
        if (offset >= 0):
            return "pin_" + descu[offset + 2: offset + 4]
        else:
            return descu

    def t0ckmux(val):
        if (val == "PORTB"):
            return "pin_B5"
        elif (val == "PORTG"):
            return "pin_G4"
        else:
            return descu

    def t1oscmux(val):
        if (val in ("HIGH", "LOW")):
            return "pin_" + descl[-1][1:]
        elif (val == "ON"):
            return "LP"
        elif (val == "OFF"):
            return "STANDARD"
        else:
            return descu

    def t3ckmux(val):
        offset = descu.find("_R")
        if (offset >= 0):
            return "pin_" + descu[offset + 2: offset + 4]
        else:
            return descu

    def t5gsel(val):
        if (val in ("T3G", "T5G")):
            return val
        else:
            return descu

    def usbdiv(val):
        if ((val == "1") | (val == "OFF")):
            return "P1"
        else:
            return "P2"

    def usblsclk(val):
        if (val == "48MHZ"):
            return "F48MHZ"
        else:
            return "F24MHZ"

    def usbpll(val):
        if descu.find("PLL") >= 0:
            return "F48MHZ"
        else:
            return "OSC"

    def vcapen(val):
        if (val in ("OFF", "DIS")):
            return "DISABLED"
        elif (val == "ON"):
            return "ENABLED"
        elif (val.startswith("RA")):
            return "pin_" + val[1:]  # pin_Ax
        else:
            return "ENABLED"

    def voltage(val):
        kwdvalue = ""  # no keyword yet
        if len(desc) > 0:  # description present
            for i in range(len(descl)):  # search voltage value
                word = descl[i]
                if (("0" <= word[0] <= "9") & (len(word) > 2) & (word.find(".") > 0)):
                    if (("LF," in descl) & ("F" in descl)):  # special case: 2 voltages
                        if ((float(cfgvar["vddnom"]) > 4.9) & (descl[i + 2] == "LF,")):  # not an LF PIC
                            continue  # skip (search 'F' voltage value)
                    if (word[-1] == "V"):  # trailing V
                        word = word[:-1]  # remove trailing V
                    return "V%2d" % round((float(word) + 0.001) * 10)  # round-up of 0.5 or 0.05!
        if (kwdvalue == ""):  # no voltage value found
            if (("MINIMUM" in descl) | ("LOW" in descl) | ("LO" in descl)):
                return "MINIMUM"
            elif (("MAXIMUM" in descl) | ("HIGH" in descl) | ("HI" in desc)):
                return "MAXIMUM"
            elif (len(descu) == 0):
                return "MEDIUM" + val
            else:
                return descu

    def wdt(val):
        if (val in ("NOSLP", "NSLEEP", "SLEEP")):
            return "RUNONLY"
        elif (val == "SWDTDIS"):
            return "ENABLED"
        elif (val in ("SWDTEN", "SWON")):
            return "CONTROL"
        elif (val == "OFF"):
            kwdvalue = "DISABLED"
            if ((descu.find("CAN_BE_ENABLED") >= 0) | (descu.find("CONTROL") >= 0)):
                kwdvalue = "CONTROL"
                if ("WDTCON" not in names):  # no WDTCON register
                    kwdvalue = "DISABLED"
            return kwdvalue
        elif (val == "ON"):
            kwdvalue = "ENABLED"
            if (descu.find("CONTROL") >= 0):
                kwdvalue = "CONTROL"
            return kwdvalue
        else:
            return descu  # normalized description

    def wdtccs(val):
        if (val in ("LFINTOSC", "MFINTOSC", "HFINTOSC", "SOSC")):
            return val
        elif (val in ("SC", "SWC")):
            return "SOFTWARE"
        else:
            return descu

    def wpcfg(val):
        if (val in ("ON", "WPCFGEN")):
            return "ENABLED"
        else:
            return "DISABLED"

    def wdtclk(val):
        if (val == "LPRC"):
            return "INTOSC"
        elif (val == "SOSC"):
            return "SOSC"
        elif (val == "FRC"):
            return "FRC"
        elif (val == "SYS"):
            return "FOSC"
        else:
            return descu

    def wdtcps(val):
        if descl[0].startswith("1:"):
            kwdvalue = int(descl[0][2:])
            j = 0
            while (kwdvalue >= 1024):
                kwdvalue = (kwdvalue + 1000) // 1024  # reduce to K, M, G, T
                j = j + 1
            return "F%d" % (kwdvalue) + " KMGT"[j]
        elif descl[-1].startswith("1:"):
            kwdvalue = int(descl[-1][2:])
            j = 0
            while (kwdvalue >= 1024):
                kwdvalue = (kwdvalue + 1000) // 1024  # reduce to K, M, G, T
                j = j + 1
            return "F%d" % (kwdvalue) + " KMGT"[j]
        else:
            return "SOFTWARE"

    def wdtcs(val):
        if (descu.find("LOW") >= 0):
            return "LOW_POWER"
        else:
            return "STANDARD"

    def wdtcws(val):
        if (descl[0][0].isdigit()):
            return "P%d" % int(float(descl[0]))  # truncate percentage to integer
        elif (descl[3][0:2].isdigit()):
            return "P%d" % int(round(float(descl[3].strip(";"))))
        elif ((descl[3].find("100") > -1) & (descu.find("NO_SOFTWARE") > -1)):
            return "P0"
        else:
            return "SOFTWARE"

    def wdtwin(val):
        return "P" + val[2:4]

    def wdtps(val):
        if (descl[0].startswith("1:")):
            if (len(descl[0]) > 2):
                kwdvalue = eval("".join(descl[0][2:].split(",")))  # 1:xxx
            else:
                kwdvalue = eval("".join(descl[1].split(",")))  # 1: xxx
            j = 0
            while (kwdvalue >= 1024):
                kwdvalue = (kwdvalue + 1000) // 1024  # reduce to K, M, G, T
                j = j + 1
            return "P%d" % (kwdvalue) + " KMGT"[j]
        else:
            return descu

    def dswdtps(val):  # alias
        return wdtps(val)

    def wpdis(val):
        if (val in ("ON", "WPEN")):
            return "ENABLED"
        else:
            return "DISABLED"

    def wpend(val):
        if (val in ("PAGE_0", "WPSTARTMEM")):
            return "P0_WPFP"
        else:
            return "PWPFP_END"

    def wpfp(val):
        return "P" + descl[-1]  # last word

    def wpsa(val):
        if (val.isdigit()):
            return "P" + val
        else:
            return descu

    def wure(val):
        if (val == "OFF"):
            return "CONTINUE"
        else:
            return "RESET"

    def zcd(val):
        return val  # ON means disabled!

    def other(val):  # generic
        if (val in ("OFF", "DISABLED")):
            return "DISABLED"
        elif (val in ("ON", "ENABLED")):
            return "ENABLED"
        elif (descu.find("ACTIVE") >= 0):
            if (descu.find("HIGH") > descu.find("ACTIVE")):
                return "ACTIVE_HIGH"
            elif (descu.find("LOW") > descu.find("ACTIVE")):
                return "ACTIVE_LOW"
            else:
                return "ENABLED"
        elif ((descu.find("ENABLE") >= 0) | (descu == "ON") | (descu == "ALL")):
            return "ENABLED"
        elif ((descu.find("DISABLE") >= 0) | (descu == "OFF") | (descu.find("SOFTWARE") >= 0)):
            return "DISABLED"
        elif (descu.find("ANALOG") >= 0):
            return "ANALOG"
        elif (descu.find("DIGITAL") > 0):
            return "DIGITAL"
        elif (len(desc) == 0):  # no description
            return ""
        else:
            if (desc[0].isdigit()):  # starts with digit
                if (desc.find("HZ") >= 0):  # probably frequency (range)
                    return "F" + descl[0]  # "F" prefix
                elif ((desc.find(" TO ") >= 0) |
                      (desc.find("0 ") >= 0) |
                      (desc.find(" 0") >= 0) |
                      (desc.find("H-") >= 0)):
                    if (desc.find(" TO ") >= 0):
                        return descl[0] + "-" + descl[2]  # word 1 and 3
                    else:
                        return descl[0]  # keep 1st word
                #             return "R" + kwdvalue
                else:  # probably a number
                    return "N" + descl[0]  # 1st word, "N" prefix
            else:
                return descu  # if no alternative!

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # check first for 'complex' keys
    if ((key == "CP") |
            ((key.startswith("CP") & (key[-1].isdigit() | key.endswith(("D", "B")))))):
        if (val in ("OFF", "DISABLE")):
            kwdvalue = "DISABLED"
        elif val in ("ON", "ENABLE", "ALL"):
            kwdvalue = "ENABLED"
        elif val.startswith(("UPPER", "HALF")):
            kwdvalue = val
        elif ((val == "50") & (picname == "16f627")):
            kwdvalue = "   "  # to be skipped
        elif (desc[0] == "0"):  # probably a range
            kwdvalue = descl[0]  # begin(-end) of range
            if (len(descl) > 2):
                if (descl[1] == "TO"):  # splitted words
                    kwdvalue = kwdvalue + "_" + descl[2]  # add end of range
            kwdvalue = "R" + kwdvalue.replace("-", '_')
        else:
            kwdvalue = "DISABLED"

    elif ((key == "WRT") | \
          ((key.startswith("WRT")) & ((key[3:].isdigit()) | (key[3:] in ("B", "C", "D"))))):
        if ((desc.find("NOT") >= 0) | (val == "OFF")):
            kwdvalue = "DISABLED"  # not protected
        elif (val == "BOOT"):
            kwdvalue = "BOOT_BLOCK"  # boot block protected
        elif (val == "HALF"):
            kwdvalue = "HALF"  # 1/2 of memory protected
        elif ((val == "FOURTH") | (val == "1FOURTH")):
            kwdvalue = "FOURTH"  # 1/4 of memory protected
        elif ((val == "WRT_UPPER") | (val == "WRT_LOWER")):
            kwdvalue = val[-5:]  # part
        elif (val.isdigit()):
            kwdvalue = "W" + val  # number of words
        else:
            kwdvalue = "ENABLED"  # whole memory protected

    else:  # 'simple' keywords
        kwdvalue = locals().get(key.lower(), other)(val)  # call appropriate procedure

    if kwdvalue == "":  # empty keyword
        print("   No keyword found for fuse_def", key, "<" + desc + ">")
    elif len(kwdvalue) > 22:
        print("   fuse_def", key, "keyword excessively long: <" + kwdvalue + ">")
    elif kwdvalue == "   ":  # to be skipped
        kwdvalue = ""
    return kwdvalue


def list_separator(fp):
    """ Generate a separator line

   Input:   file pointer
   Returns: nothing
   """
    fp.write("-- " + "-" * 48 + "\n")


def collect_mirrors(child):
    """ Create or add mirror(s) to SFR addres(ses)

   Input:   - Node
   Output:  (nothing)
   Returns: (nothing)
   Notes:   - SFR mirrors of only base and midrange PICs are used.
              Enhanced midrange (core 14H) have 0x00-0x0B mirrored
              in all banks, which address ranges is specified
              in the device files as shared memory.
            - Mirror adresses rely on specification of mirrorbank
              (regionidref is normally 'sfr0' or 'sfr1')
   """
    global sfr_mirrors
    if ((cfgvar["core"] not in ("12", "14")) |
            (child.nodeType != Node.ELEMENT_NODE) |
            (child.nodeName != "edc:Mirror")):
        return
    if (not child.hasAttribute("edc:_addr")):  # missing address
        return
    mirror = eval(child.getAttribute("edc:_addr"))  # mirror address
    mirror_bank = eval(child.getAttribute("edc:regionidref")[-1])  # bank of the mirrored sfr
    mirrored = mirror % cfgvar["banksize"] + mirror_bank * cfgvar["banksize"]
    for i in range(eval(child.getAttribute("edc:nzsize"))):
        if ((mirrored + i) not in sfr_mirrors):  # no entry for mirrored sfr yet
            sfr_mirrors[mirrored + i] = [mirrored + i]  # create list for mirrored address
        sfr_mirrors[mirrored + i].append(mirror + i)  # add mirror to list


def compact_address_range(r):
    """ Compact address ranges

   Input:   list of pairs of address ranges
   Output:  (nothing)
   Returns: compacted list of pairs of address ranges
   """
    x = list(r[:])
    x.sort()
    j = 0
    y = []
    y.append(list(x[0]))
    for i in range(len(x) - 1):
        if (x[i][-1] == x[i + 1][0]):
            y[j][-1] = x[i + 1][-1]
        else:
            y.append(list(x[i + 1]))
            j = j + 1
    return y


def collect_config_info(root, picname):
    """ Collect PIC various configuration data

   Input:   - "pic" xml structure
            - picname
   Output:  fills "cfgvar" dictionary
   Returns: (nothing)
   Notes:   - JalV2 compiler supports for 12- and 14-bits core only 4 memory banks
            - Fuse defaults are set ('1') for baseline and (extended) midrange.
              For 16-bits core the defaults are collected from the .pic file.
   """
    global cfgvar
    global names
    cfgvar.clear()  # empty dict. of config variables
    pic = root.getElementsByTagName("edc:PIC")
    cfgvar["procid"] = eval(pic[0].getAttribute("edc:procid"))  # first (only) "PIC" node
    if (runtype == "CHIPDEF"):
        return  # nothing more needed for a chipdef run
    cfgvar["picname"] = picname
    cfgvar["adcs_bits"] = 0  # adcs bits in ANSEL/ANCON
    cfgvar["cmxcon0mask"] = "0000_0000"  # power on reset state
    cfgvar["devid"] = 0  # no devID
    cfgvar["haslat"] = False  # no LATx register
    cfgvar["ircf_bits"] = 3  # ircf bits in OSCCON
    cfgvar["lata3_out"] = False  # True: LATA_RA3 bit output capable
    cfgvar["lata5_out"] = False  # LATA_RA5  "    "       "
    cfgvar["late3_out"] = False  # LATE_RE3  "    "       "
    cfgvar["numbanks"] = 1  # RAM banks
    cfgvar["osccal"] = 0  # no OSCCAL
    cfgvar["wdtcon_adshr"] = (0, 0)  # no WDTCON_ADSHR (address,offset)

    cfgvar["arch"] = pic[0].getAttribute("edc:arch")
    if (cfgvar["arch"] == "16c5x"):  # baseline (12-bits)
        cfgvar["core"] = "12"
        cfgvar["maxram"] = 128
        cfgvar["banksize"] = 32
        cfgvar["pagesize"] = 512
    elif (cfgvar["arch"] == "16xxxx"):  # midrange (14 bits)
        cfgvar["core"] = "14"
        cfgvar["maxram"] = 512
        cfgvar["banksize"] = 128
        cfgvar["pagesize"] = 2048
    elif (cfgvar["arch"] == "16Exxx"):  # entended midrange (14 bits)
        cfgvar["core"] = "14H"
        cfgvar["maxram"] = 4096
        cfgvar["banksize"] = 128
        cfgvar["pagesize"] = 2048
    elif (cfgvar["arch"] == "18xxxx"):  # high performance range (16 bits)
        cfgvar["core"] = "16"
        cfgvar["maxram"] = 4096
        cfgvar["banksize"] = 256
        cfgvar["pagesize"] = 0  # no pages!
    else:
        print("   undetermined core : ", cfgvar["arch"])
    cfgvar["dsid"] = pic[0].getAttribute("edc:dsid")

    power = root.getElementsByTagName("edc:Power")
    vpp = power[0].getElementsByTagName("edc:VPP")
    cfgvar["vppdef"] = vpp[0].getAttribute("edc:defaultvoltage")
    cfgvar["vppmax"] = vpp[0].getAttribute("edc:maxvoltage")
    cfgvar["vppmin"] = vpp[0].getAttribute("edc:minvoltage")
    vdd = power[0].getElementsByTagName("edc:VDD")
    cfgvar["vddnom"] = vdd[0].getAttribute("edc:nominalvoltage")
    cfgvar["vddmax"] = vdd[0].getAttribute("edc:maxvoltage")
    cfgvar["vddmin"] = vdd[0].getAttribute("edc:minvoltage")

    arch = root.getElementsByTagName("edc:ArchDef")
    memtraits = arch[0].getElementsByTagName("edc:MemTraits")
    if memtraits[0].hasAttribute("bankcount"):
        cfgvar["numbanks"] = eval(memtraits[0].getAttribute("edc:bankcount"))
    cfgvar["hwstack"] = eval(memtraits[0].getAttribute("edc:hwstackdepth"))

    pgmspace = root.getElementsByTagName("edc:ProgramSpace")
    codesectors = pgmspace[0].getElementsByTagName("edc:CodeSector")
    codesize = 0
    for codesector in codesectors:
        codesize = codesize + eval(codesector.getAttribute("edc:endaddr")) - \
                   eval(codesector.getAttribute("edc:beginaddr"))
    cfgvar["codesize"] = codesize
    useridsectors = pgmspace[0].getElementsByTagName("edc:UserIDSector")
    if (len(useridsectors) > 0):
        cfgvar["idaddr"] = eval(useridsectors[0].getAttribute("edc:beginaddr"))
        cfgvar["idsize"] = eval(useridsectors[0].getAttribute("edc:endaddr")) - \
                           eval(useridsectors[0].getAttribute("edc:beginaddr"))
    eedatasectors = pgmspace[0].getElementsByTagName("edc:EEDataSector")
    if (len(eedatasectors) > 0):
        cfgvar["eeaddr"] = eval(eedatasectors[0].getAttribute("edc:beginaddr"))
        cfgvar["eesize"] = eval(eedatasectors[0].getAttribute("edc:endaddr")) - \
                           eval(eedatasectors[0].getAttribute("edc:beginaddr"))
    flashdatasectors = pgmspace[0].getElementsByTagName("edc:FlashDataSector")
    if (len(flashdatasectors) > 0):
        cfgvar["eeaddr"] = eval(flashdatasectors[0].getAttribute("edc:beginaddr"))
        cfgvar["eesize"] = eval(flashdatasectors[0].getAttribute("edc:endaddr")) - \
                           eval(flashdatasectors[0].getAttribute("edc:beginaddr"))
    devidsectors = pgmspace[0].getElementsByTagName("edc:DeviceIDSector")
    if (len(devidsectors) > 0):
        cfgvar["devid"] = eval(devidsectors[0].getAttribute("edc:value"))
    configfusesectors = pgmspace[0].getElementsByTagName("edc:ConfigFuseSector")
    if (len(configfusesectors) > 0):
        cfgvar["fuseaddr"] = eval(configfusesectors[0].getAttribute("edc:beginaddr"))
        cfgvar["fusesize"] = eval(configfusesectors[0].getAttribute("edc:endaddr")) - \
                             eval(configfusesectors[0].getAttribute("edc:beginaddr"))
        picdata = dict(list(devspec[picname.upper()].items()))

        if "FUSESDEFAULT" in picdata:
            cfgvar["fusedefault"] = [eval("0x" + picdata["FUSESDEFAULT"])]
        else:
            core = cfgvar["core"]
            if core == "12":
                cfgvar["fusedefault"] = [0xFFF] * cfgvar["fusesize"]
            elif (core == "14") | (core == "14H"):
                cfgvar["fusedefault"] = [0x3FFF] * cfgvar["fusesize"]
            else:
                cfgvar["fusedefault"] = [0] * cfgvar["fusesize"]
                load_fuse_defaults(root)
    wormholesectors = pgmspace[0].getElementsByTagName("edc:WORMHoleSector")
    if (len(wormholesectors) > 0):  # expected with 16-bits code only
        cfgvar["fuseaddr"] = eval(wormholesectors[0].getAttribute("edc:beginaddr"))
        cfgvar["fusesize"] = eval(wormholesectors[0].getAttribute("edc:endaddr")) - \
                             eval(wormholesectors[0].getAttribute("edc:beginaddr"))
        cfgvar["fusedefault"] = [0] * cfgvar["fusesize"]
        load_fuse_defaults(root)

    sfraddr = 0  # startvalue of SFR reg addr.
    sfrdatasectors = root.getElementsByTagName("edc:SFRDataSector")
    for sfrdatasector in sfrdatasectors:
        if sfrdatasector.hasAttribute("edc:bank"):  # count numbanks
            cfgvar["numbanks"] = max(eval(sfrdatasector.getAttribute("edc:bank")) + 1, cfgvar["numbanks"])
        sfraddr = eval(sfrdatasector.getAttribute("edc:beginaddr"))  # actual
        if len(sfrdatasector.childNodes) > 0:
            child = sfrdatasector.firstChild  # first or only child
            collect_mirrors(child)  # collect mirror addresses
            while child.nextSibling:  # all other childs
                child = child.nextSibling
                collect_mirrors(child)  # collect mirror addresses
                if child.nodeType == Node.ELEMENT_NODE:
                    if (child.hasAttribute("edc:cname")):
                        sfraddr = eval(child.getAttribute("edc:_addr"))
                        childname = child.getAttribute("edc:cname")
                        if childname == "CM1CON0":
                            mask = child.getAttribute("edc:por")
                            if (len(mask) == 8):  # 8 bits expected
                                mask = re.sub("[^01]", "0", mask)  # replace other than 0 and 1 by 0
                                cfgvar["cmxcon0mask"] = mask[0:4] + "_" + mask[4:8]
                        elif childname == "FSR":
                            cfgvar["fsr"] = sfraddr
                        elif (childname == "OSCCAL"):
                            cfgvar["osccal"] = sfraddr
                        elif (childname == "OSCCON"):
                            modes = child.getElementsByTagName("edc:SFRMode")
                            for mode in modes:
                                bitfield = mode.firstChild  # skip
                                while bitfield.nextSibling:
                                    bitfield = bitfield.nextSibling
                                    if (bitfield.nodeName == "edc:SFRFieldDef"):
                                        bname = bitfield.getAttribute("edc:cname")
                                        if (bname.startswith("IRCF")):
                                            bwidth = eval(bitfield.getAttribute("edc:nzwidth"))
                                            if (bwidth > 1):
                                                cfgvar["ircf_bits"] = bwidth
                                            else:
                                                if (cfgvar["ircf_bits"] < eval(bname[-1])):
                                                    cfgvar["ircf_bits"] = eval(bname[-1])
                        elif ((childname.startswith("LAT")) & (len(childname) == 4) & \
                              ("A" <= childname[-1] <= "L")):
                            cfgvar["haslat"] = True
                            access = child.getAttribute("edc:access")
                            if (childname in ("LATA", "LATE")):
                                fields = child.getElementsByTagName("edc:SFRFieldDef")
                                for field in fields:
                                    fieldname = field.getAttribute("edc:cname")
                                    if ((fieldname == "LATA3") & (access[4] != "r")):
                                        cfgvar["lata3_out"] = True
                                    if ((fieldname == "LATA5") & (access[2] != "r")):
                                        cfgvar["lata5_out"] = True
                                    if ((fieldname == "LATE3") & (access[4] != "r")):
                                        cfgvar["late3_out"] = True
                        elif (childname == "WDTCON"):
                            modes = child.getElementsByTagName("edc:SFRMode")
                            offset = 0
                            for mode in modes:
                                bitfield = mode.firstChild  # skip
                                while bitfield.nextSibling:
                                    bitfield = bitfield.nextSibling
                                    if (bitfield.nodeName == "edc:AdjustPoint"):
                                        offset = offset + eval(bitfield.getAttribute("edc:offset"))
                                    elif (bitfield.nodeName == "edc:SFRFieldDef"):
                                        bname = bitfield.getAttribute("edc:cname")
                                        bwidth = eval(bitfield.getAttribute("edc:nzwidth"))
                                        if (bname == "ADSHR"):
                                            cfgvar["wdtcon_adshr"] = (sfraddr, offset)
                                            break
                                        offset = offset + bwidth

    data = []  # intermediate result
    gprdatasectors = root.getElementsByTagName("edc:GPRDataSector")
    for gprdatasector in gprdatasectors:
        if gprdatasector.hasAttribute("edc:bank"):  # count numbanks
            cfgvar["numbanks"] = max(eval(gprdatasector.getAttribute("edc:bank")) + 1, cfgvar["numbanks"])
        parent = gprdatasector.parentNode
        if (parent.nodeName != "edc:ExtendedModeOnly"):
            if (gprdatasector.hasAttribute("edc:shadowidref") == False):
                gpraddr = eval(gprdatasector.getAttribute("edc:beginaddr"))
                gprlast = eval(gprdatasector.getAttribute("edc:endaddr"))
                data.append((gpraddr, gprlast))
                if ((gprdatasector.getAttribute("edc:regionid") == "gprnobnk") |
                        (gprdatasector.getAttribute("edc:regionid") == "gprnobank") |
                        (gprdatasector.getAttribute("edc:regionid") == "accessram")):
                    cfgvar["sharedrange"] = (gpraddr, gprlast)
                if (gpraddr == 0):
                    cfgvar["accessbanksplitoffset"] = gprlast
    dprdatasectors = root.getElementsByTagName("edc:DPRDataSector")
    for dprdatasector in dprdatasectors:
        if dprdatasector.hasAttribute("edc:bank"):  # count numbanks
            cfgvar["numbanks"] = max(eval(dprdatasector.getAttribute("edc:bank")) + 1, cfgvar["numbanks"])
        parent = dprdatasector.parentNode
        if (parent.nodeName != "edc:ExtendedModeOnly"):
            if (dprdatasector.hasAttribute("edc:shadowidref") == False):
                dpraddr = eval(dprdatasector.getAttribute("edc:beginaddr"))
                dprlast = eval(dprdatasector.getAttribute("edc:endaddr"))
                data.append((dpraddr, dprlast))
                if ((dprdatasector.getAttribute("edc:regionid") == "dprnobnk") |
                        (dprdatasector.getAttribute("edc:regionid") == "dprnobank") |
                        (dprdatasector.getAttribute("edc:regionid") == "accessram")):
                    cfgvar["sharedrange"] = (dpraddr, dprlast)
                if (dpraddr == 0):
                    cfgvar["accessbanksplitoffset"] = dprlast
    cfgvar["datarange"] = compact_address_range(data)

    if ((cfgvar["core"] == "12") | (cfgvar["core"] == "14")) & (cfgvar["numbanks"] > 4):
        cfgvar["numbanks"] = 4  # max 4 banks for core 12, 14

    if "sharedrange" not in cfgvar:  # no shared range found
        if len(cfgvar["datarange"]) == 1:  # single data bank
            cfgvar["sharedrange"] = cfgvar["datarange"][0]  # all data is shared
        else:
            print("   Multiple banks, but no shared data!")


def load_fuse_defaults(root):
    """ Load fuse defaults

   Input:   - xml structure
   Output:  cfgvar["fusedefault"]
   Returns: (nothing)
   Notes:   Can be used for all cores, but only useful with 16-bits
            core since only defaults of 16-bits core will be updated.
   """
    configfusesectors = root.getElementsByTagName("edc:ConfigFuseSector")
    if (len(configfusesectors) == 0):
        configfusesectors = root.getElementsByTagName("edc:WORMHoleSector")
    for configfusesector in configfusesectors:
        dcraddr = eval(configfusesector.getAttribute("edc:beginaddr"))  # start address
        if (len(configfusesector.childNodes) > 0):
            dcrdef = configfusesector.firstChild
            dcraddr = load_dcrdef_default(dcrdef, dcraddr)
            while dcrdef.nextSibling:
                dcrdef = dcrdef.nextSibling
                dcraddr = load_dcrdef_default(dcrdef, dcraddr)


def load_dcrdef_default(dcrdef, addr):
    """ Load individual configuration byte/word

   Input:   - dcrdef
            - current fuse address
   Output:  part of device file
   Returns: next config fuse address
   """
    if (dcrdef.nodeName == "edc:AdjustPoint"):
        addr = addr + eval(dcrdef.getAttribute("edc:offset"))
    elif (dcrdef.nodeName == "edc:DCRDef"):
        if (cfgvar["core"] == "16"):
            index = addr - cfgvar["fuseaddr"]  # position in array
            cfgvar["fusedefault"][index] = eval(dcrdef.getAttribute("edc:default"))
        addr = addr + 1
    return addr


def read_devspec_file():
    """ Read devicespecific.json

   Input:   (nothing, uses global variable 'devspec')
   Output:  fills "devspec" dictionary
   Returns: (nothing)
   """
    global devspec  # global variable
    with open(devspecfile, "r") as fp:
        devspec = json.load(fp)  # obtain contents devicespecific


def read_pinaliases_file():
    """ Read pinaliases file pinaliases.json

   Input:   (nothing, uses global variable 'pinaliases')
   Output:  fills "pinaliases" dictionary
   Returns: (nothing)
   """
    global pinaliases  # global variable
    global pinanmap
    with open(pinaliasfile, "r") as fp:
        pinaliases = json.load(fp)  # obtain contents devicespecific
        pinanmap = {}  # with lists of ANx pin aliases per pic
        for PICname in pinaliases:  # capitals!
            pinanmap[PICname] = []
            for pin in pinaliases[PICname]:
                for alias in pinaliases[PICname][pin]:
                    if (alias.startswith("AN") & (alias[2:].isdigit() | alias[3:].isdigit())):
                        pinanmap[PICname].append(alias)


def pic2jal(picfile, dstdir):
    """ Convert a single MPLABX .pic file to a JalV2 device file

   Input:   - path of the .pic file
            - destination
   Output:  - device file
   Returns: (nothing)
   Notes:
   """
    picname = os.path.splitext(os.path.basename(picfile))[0][3:].lower()
    print(picname)  # progress signal

    global names
    global sfr_mirrors

    names = []  # start with empty list
    sfr_mirrors.clear()  # start with empty dictionary

    root = parse(picfile)  # load xml file
    collect_config_info(root, picname)  # first scan for selected info
    if (runtype == "CHIPDEF"):
        return
    with open(os.path.join(dstdir, picname + ".jal"), "w") as fp:  # device file to be built
        list_devicefile_header(fp, picfile)
        list_config_memory(fp)
        list_osccal(fp)  # for selected PICs only
        list_all_sfr(fp, root)
        list_all_nmmr(fp, root)
        list_digital_io(fp, picname)
        list_miscellaneous(fp, root, picname)
        list_fuse_defs(fp, root)
        fp.write("--\n")


def generate_devicefiles(selection, dstdir):
    """ Main procedure.
   Process external configuration info
   Select .pic files to be processed (ic 8-bits flash PICs)

   Input:    PICs to be selected (wildcard specification)
   Output:   - device file per selected PICs
             - chipdef_jallib file
   Returns:  Number of generated device files
   """

    l_tempexcl = {  # supported by JalV2
        #      "18f24k42", "18lf24k42",                   # but issues to be resolved
    }
    typedir = {
        "16c5x": "Baseline (12-bits core)",
        "16xxxx": "(Enhanced) Mid-Range (14-bits core)",
        "18xxxx": "High Performance Series (16-bits core)"
    }
    read_devspec_file()  # PIC specific info #
    read_pinaliases_file()  # pin aliases
    with open(os.path.join(dstdir, "chipdef_jallib.jal"), "w") as fp:  # common include for device files
        list_chipdef_header(fp)  # create header of chipdef file
        devcount = 0
        for (root, dirs, files) in os.walk(picdir):  # whole tree (incl subdirs!)
            dirs.sort()  # sort on core type: 12-, 14-, 16-bit
            if (os.path.split(root)[1] in list(typedir.keys())):  # directory with 8-bits pics
                fp.write("--\n-- " + typedir[os.path.basename(root)] + "\n--\n")
                files.sort()  # alphanumeric order
                for file in files:
                    picname = os.path.splitext(file)[0][3:].lower()  # determine lowercase picname from filename
                    if fnmatch.fnmatch(picname, selection):  # selection by user wildcard
                        if (picname not in l_tempexcl):  # not temporary excluded
                            if (picname.upper() in devspec):  # present in devicespecific
                                picdata = devspec[picname.upper()]  # some properties of this PIC
                                if (picdata.get("DATASHEET", "-") != "-"):  # must have datasheet
                                    pic2jal(os.path.join(root, file), dstdir)  # create device file from .pic file
                                    fp.write("const  word  PIC_%-14s" % picname.upper() + \
                                             " = 0x%X" % (cfgvar["procid"]) + "\n")
                                    devcount = devcount + 1
                                else:
                                    print(picname, "   no datasheet!")
                            else:
                                print(picname, "   not present in", devspecfile)  # sound a bell!
                        else:
                            print("   ", picname, "temporarily(?) excluded!")

        fp.write("--\n")
    return devcount


# === E N T R Y   P O I N T =============================================

if (__name__ == "__main__"):
    """ Process commandline parameters, start process, clock execution
   """

    if (len(sys.argv) > 1):
        runtype = sys.argv[1].upper()
    else:
        print("Specify at least PROD, TEST or CHIPDEF as first argument")
        print("and optionally a pictype as second argument (wildcards allowed)")
        sys.exit(1)

    if (runtype == "PROD"):
        print("PROD option temporary disabled")
        sys.exit(1)
    elif (runtype == "TEST"):
        dstdir = os.path.join(base, "test")
    elif (runtype == "CHIPDEF"):
        dstdir = os.path.join(base, "test")
        print("==> Only 'chipdef_jallib' will be created (in", dstdir, ")!")
    else:
        print("Specify PROD, TEST or CHIPDEF as first argument")
        print("and optionally a PICtype as second argument (wildcards allowed)")
        sys.exit(1)
    if not os.path.exists(dstdir):
        os.makedirs(dstdir)  # destination of device files

    if (len(sys.argv) > 3):
        print("Expecting not more than 2 arguments: runtype + selection")
        sys.exit(1)
    elif (len(sys.argv) > 2):
        selection = sys.argv[2]
        if (selection == "*"):  # special case
            selection = "1*"  # replacement
        elif selection.upper().startswith("PIC"):
            selection = selection[3:]  # strip 'PIC' prefix
    else:
        selection = "1*"

    if not os.path.exists(devspecfile):
        shutil.copyfile("devicespecific.json", devspecfile)

    print("   Pic2jal script version", scriptversion,
          "\n   Creating JalV2 device files with MPLABX version", mplabxversion)
    elapsed = time.time()
    count = generate_devicefiles(selection.lower(), dstdir)  # call real generation routine
    elapsed = time.time() - elapsed
    print("Generated %d device files in %.1f seconds (%.1f per second)" % \
          (count, elapsed, count / elapsed))
