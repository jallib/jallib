#!/usr/bin/env python3
"""
Title: Create JalV2 device files for Microchip 8-bits flash PICs.

Author: Rob Hamerling, Copyright (c) 2014..2024, all rights reserved.
        Rob Jansen,    Copyright (c) 2020..2025, all rights reserved.

Adapted-by:

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the ZLIB license http://www.opensource.org/licenses/zlib-license.html

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

"""
   Changes dd 2024-04-xx (multiprocessing and other)
   - removed runtype argument: runs now always as previous 'test' mode,
     generated device files are created directly in 'dstdir',
     (which is renamed to 'device')
   - script version upgraded to 1.6.0
   - Added 'futures' for multiprocessing
   - First a list of all (selected) .PIC files and the
     chipdef_jallib.jal file are created.
     Since 'procid' is needed in chipdef_jallib.jal but the xml
     file is not yet scanned yet, procid is collected by a simple
     separate procedure which scans the raw xml file for procid=.
   - The list of XML files is handed over to a (new) scheduling
     procedure to create the device files in parallel depending on
     the available processor cores.
   - on several places string formatting with: f"..." is introduced
   - pinanmap removed, not used anymore (was required by ADC libraries)
   - procedures read_devspec() and read_pinaliases() removed,
     devspec and pinaliases are read at script import
   - the mplabxtract script collects all .PIC files in
        'mplabx'.mplabxversion (no subdirectories)
     the generate_devicefiles() procedure is changed accordingly
   Changes dd 2024-11-xx
   - use of xml.etree.ElementTree in stead of xml.dom.minidom
     for processing the MPLABX xml files
   - removed (support for) 'temporary' excluded pics

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
import xml.etree.ElementTree as et
from concurrent import futures

# --- basic working parameters
scriptauthor = "Rob Hamerling, Rob Jansen"
scriptversion = "2.2"       # script version
compilerversion = "2.5r9"   # latest JalV2 compiler version

# Additional file specifications
# paths may have to be adapted to local environment
xmldir = os.path.join(base, "mplabx")
pinaliasfile = os.path.join(base, "pinaliases.json")  # pin aliases
devspecfile = os.path.join(base, "devicespecific.json")  # some PIC properties not in MPLABX

# needed before creating device file:
devspec = {}  # contents of devicespecific.json
with open(devspecfile, "r") as fp:              # 2024-03-xx RobH
    devspec = json.load(fp)  # obtain contents

pinaliases = {}  # contents of pinaliases.py
with open(pinaliasfile, "r") as fp:             # 2024-03-xx RobH
    pinaliases = json.load(fp)  # obtain contents

dstdir = os.path.join(base, "device")  # destination of device files
if not os.path.exists(dstdir):
    os.makedirs(dstdir)

# --- global variables per individual device
cfgvar = {}  # collection of some PIC properties
sharedmem = []  # list of allocatable shared mem ranges
sfr_mirrors = {}  # base address + mirror addresses if any
names = []  # list of names of declared variables

# translation/normalisation of fusedef keywords
# Key = MPLABX cname, value = Jallib keyword
# All keywords are included also if the keywords in MPLABX and Jallib are the same.
# The PIC mentioned is where the first (initial) value came from.
fusedef_kwd = {"ABW": "ABW",
               "ADCSEL": "ADCSEL",               # PIC18F27/47/57Q84
               "ADDRBW": "ABW",
               "APPSCEN": "APPSCEN",             # PIC18F27/47/57Q84
               "BACKBUG": "DEBUG",
               "BBEN": "BBEN",
               "BBSIZ": "BBSIZ",
               "BBSIZE": "BBSIZ",
               "BCRCERESH": "BCRCERESH",         # PIC18F27/47/57Q84
               "BCRCERESL": "BCRCERESL",         # PIC18F27/47/57Q84
               "BCRCEREST": "BCRCEREST",         # PIC18F27/47/57Q84
               "BCRCERESU": "BCRCERESU",         # PIC18F27/47/57Q84
               "BCRCPOLH": "BCRCPOLH",           # PIC18F27/47/57Q84
               "BCRCPOLL": "BCRCPOLL",           # PIC18F27/47/57Q84
               "BCRCPOLT": "BCRCPOLT",           # PIC18F27/47/57Q84
               "BCRCPOLU": "BCRCPOLU",           # PIC18F27/47/57Q84
               "BCRCSEEDH": "BCRCSEEDH",         # PIC18F27/47/57Q84
               "BCRCSEEDL": "BCRCSEEDL",         # PIC18F27/47/57Q84
               "BCRCSEEDT": "BCRCSEEDT",         # PIC18F27/47/57Q84
               "BCRCSEEDU": "BCRCSEEDU",         # PIC18F27/47/57Q84
               "BOD": "BROWNOUT",
               "BODENV": "VOLTAGE",
               "BOOTCOE": "BOOTCOE",             # PIC18F27/47/57Q84
               "BOOTPINSEL": "BOOTPINSEL",       # PIC18F27/47/57Q84
               "BOOTPOR": "BOOTPOR",             # PIC18F27/47/57Q84
               "BOOTSCEN": "BOOTSCEN",           # PIC18F27/47/57Q84
               "BOR": "BROWNOUT",
               "BOR4V": "VOLTAGE",
               "BOREN": "BROWNOUT",
               "BORPWR": "BORPWR",
               "BORSEN": "BORSEN",
               "BORV": "VOLTAGE",                # PIC18F27/47/57Q84
               "BPEN": "BPEN",                   # PIC18F27/47/57Q84
               "BW": "DBW",
               "CANMX": "CANMUX",
               "CCP2MUX": "CCP2MUX",
               "CCP2MX": "CCP2MUX",
               "CCP3MX": "CCP3MUX",
               "CCPMX": "CCP1MUX",
               "CFGPLLEN": "PLLEN",
               "CFGSCEN": "CFGSCEN",             # PIC18F27/47/57Q84
               "CINASEL": "CINASEL",
               "CLKOEC": "CLKOEC",
               "CLKOEN": "CLKOUTEN",
               "CLKOUTEN": "CLKOUTEN",
               "COE": "COE",                     # PIC18F27/47/57Q84
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
               "CRCERESH": "CRCERESH",            # PIC18F27/47/57Q84
               "CRCERESL": "CRCERESL",            # PIC18F27/47/57Q84
               "CRCEREST": "CRCEREST",            # PIC18F27/47/57Q84
               "CRCERESU": "CRCERESU",            # PIC18F27/47/57Q84
               "CRCPOLH": "CRCPOLH",              # PIC18F27/47/57Q84
               "CRCPOLL": "CRCPOLL",              # PIC18F27/47/57Q84
               "CRCPOLT": "CRCPOLT",              # PIC18F27/47/57Q84
               "CRCPOLU": "CRCPOLU",              # PIC18F27/47/57Q84
               "CRCSEEDH": "CRCSEEDH",            # PIC18F27/47/57Q84
               "CRCSEEDL": "CRCSEEDL",            # PIC18F27/47/57Q84
               "CRCSEEDT": "CRCSEEDT",            # PIC18F27/47/57Q84
               "CRCSEEDU": "CRCSEEDU",            # PIC18F27/47/57Q84
               "CSWEN": "CSWEN",
               "DACAUTOEN" : "DACAUTOEN",         # PIC16F17114/15/24/25/44/45
               "DATABW": "DBW",
               "DATASCEN": "DATASCEN",            # PIC18F27/47/57Q84
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
               "FCMENP": "FCMENP",
               "FCMENS": "FCMENS",
               "FEXTOSC": "OSC",
               "FLTAMX": "FLTAMUX",
               "FOSC": "OSC",
               "FOSC0": "OSC",
               "FOSC2": "FOSC2",
               "FSCM": "FCMEN",
               "HFOFST": "HFOFST",
               "HPOL": "HPOL",
               "ICPRT": "ICPRT",
               "ICSPDIS": "ICSPDIS",             # PIC18FxxQ24
               "IESO": "IESO",
               "INTOSCSEL": "INTOSCSEL",
               "IOL1WAY": "IOL1WAY",
               "IOSCFS": "IOSCFS",
               "IVT1WAY": "IVT1WAY",
               "JTAGEN": "JTAGEN",               # PIC18F27/47/57Q84
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
               "ODCON": "ODCON",                 # PIC18F27/47/57Q84
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
               "SAFLOCK": "SAFLOCK",             # PIC18FxxQ20
               "SAFSCEN": "SAFSCEN",             # PIC18F27/47/57Q84
               "SAFSZ": "SAFSZ",                 # PIC18F26/46/56Q71
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
               "VDDAR" : "VDDAR",                # PIC16F15213/14/23/24/43/44
               "VDDIO2MD": "VDDIO2MD",           # PIC18FxxQ20
               "VDDIO3MD": "VDDI3OMD",           # PIC18FxxQ20
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
               "ZCD1": "ZCD1",                   # PIC18xxQ24
               "ZCD2": "ZCD2",                   # PIC18xxQ24
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
               "HS_8MHZ": "HS_8MHZ",                       # PIC18FxxQ20
               "HS_16MHZ": "HS_16MHZ",                     # PIC18FxxQ20
               "HS_24MHZ": "HS_24MHZ",                     # PIC18FxxQ20
               "HS_32MHZ": "HS_32MHZ",                     # PIC18FxxQ20
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

# Translation/normalisation of instruction set keywords
# Key = MPLABX cname, number = Jallib compiler instruction set number. Only a limited number of instruction
# set are used by the compiler to perform specific tasks, all other are just reserved when needed.
instruction_set_def = { "cpu_p16f1_v1"  : 1,
                        "cpu_pic18f_v6" : 2,
                        "pic12c5xx"     : 3,
                        "pic16f77"      : 4,
                        "cpu_mid_v10"   : 5,
                        "pic18"         : 6,
                        "egg"           : 7}

# 2025-02-07: The following is a temporary fix for the PIC16(L)F1713 and PIC16(L)F1716 due to an error in MPLABX
pic16f1713_6_pps_fix_def = {"NCOOUT": 0x03,
                            "CLC1OUT": 0x04,
                            "CLC2OUT": 0x05,
                            "CLC3OUT": 0x06,
                            "CLC4OUT": 0x07,
                            "COG1A": 0x08,
                            "COG1B": 0x09,
                            "COG1C": 0x0A,
                            "COG1D": 0x0B,
                            "CCP1": 0x0C,
                            "CCP2": 0x0D,
                            "PWM3OUT": 0x0E,
                            "PWM4OUT": 0x0F,
                            "SDO": 0x11,
                            "SDA": 0x11,
                            "SCL": 0x10,
                            "SCK": 0x10,
                            "CK": 0x14,
                            "TX": 0x14,
                            "DT": 0x15,
                            "C1OUT": 0x16,
                            "C2OUT": 0x17
                             }

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
    fp.write("-- This file is part of jallib (https://github.com/jallib/jallib)\n")
    fp.write("-- Released under the ZLIB license" +
             " (http://www.opensource.org/licenses/zlib-license.html)\n--\n")

def list_chipdef_header(fp):
    """ List common constants in chipdef_jallib.jal
    Input:   filespec of destination file
    Returns: nothing
    """
    list_separator(fp)
    fp.write("-- Title: Common Jallib include file for device files\n")
    list_copyright(fp)  # insert copyright and other info
    fp.write("-- Sources:\n" +
             "--\n" +
             "-- Description:\n")
    fp.write("--    Common Jallib include file for device files\n")
    fp.write("--\n" +
             "-- Notes:\n" +
             "--    - This file is generated by <pic2jal.py> script version " + scriptversion + "\n" +
             "--    - File creation date/time: " + time.ctime() + "\n" +
             "--    - Based on MPLABX v" + mplabxversion + "\n" +
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
             "--  - {Microchip\\MPLABX V" + mplabxversion + " \\packs\\Microchip}/" +
             ".../.../" + subdir + "/PIC" + picname.upper() + ".PIC\n" +
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
             "include chipdef_jallib                -- common constants\n" +
             "--\n" +
             "pragma  target  cpu      PIC_" + cfgvar["core"] + "       -- (banks=%d)\n" % cfgvar["numbanks"])
    # RJ: New: instruction set. Only write the ones currently used by the compiler.
    if (cfgvar["instructionset"] == 1) | (cfgvar["instructionset"] == 2):
        fp.write("pragma  target  inst     %d" % cfgvar["instructionset"] + "            -- instruction set : " +
                 cfgvar["instructionset_name"] + "\n")
    fp.write("pragma  target  chip     " + picname.upper() + "\n" +
             "pragma  target  bank     0x%04X\n" % cfgvar["banksize"])
    if cfgvar["pagesize"] > 0:
        fp.write("pragma  target  page     0x%04X\n" % cfgvar["pagesize"])
    fp.write("pragma  stack            %d\n" % cfgvar["hwstack"])
    if cfgvar["osccal"] > 0:
        fp.write("pragma  code             %d" % (cfgvar["codesize"] - 1) + " " * 15 + "-- (excl high mem word)\n")
    else:
        fp.write("pragma  code             %d\n" % cfgvar["codesize"])
    if "eeaddr" in cfgvar:
        fp.write("pragma  eeprom           0x%X,%d\n" % (cfgvar["eeaddr"], cfgvar["eesize"]))
    if "idaddr" in cfgvar:
        fp.write("pragma  ID               0x%X,%d\n" % (cfgvar["idaddr"], cfgvar["idsize"]))
    if "DATA" in picdata:
        fp.write("pragma  data             " + picdata["DATA"] + "\n")
        print("   pragma data overruled by specification in devicespecific")
    else:
        for i in range(0, len(cfgvar["datarange"]), 5):  # max 5 ranges per line
            y = cfgvar["datarange"][i: i + 5]
            fp.write("pragma  data             " + ",".join(("0x%X-0x%X" % (r[0], r[1] - 1)) for r in y) + "\n")
    fp.write("pragma  shared           ")
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
            fp.write("0x%X-0x%X,0x%X-0x%X\n" %
                     (cfgvar["sharedrange"][0],
                      (cfgvar["sharedrange"][-1] - 1),
                      cfgvar["accessfunctionregisters"][0],
                      (cfgvar["accessfunctionregisters"][-1] -1)))
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

def determine_max_fuse_size():
    max_fuse_size = 0
    for i in range(cfgvar["fusesize"]):
        if cfgvar["fusename"][i] != "RESERVED":
            max_fuse_size = i
    return max_fuse_size + 1

#RJ 2020-06-20: Fix for errors in XML files to correct the fuse size. We go through all config register and define
#               the maximum size as the last defined config register. This problem was found in PIC18F56Q43 and
#               when fixed by Microchip this could be removed but the function does not do any harm.
def list_config_memory(fp):
    """ Generate configuration memory declaration and defaults
    Input:   - picname
             - output file
    Output:  part of device files
    Returns: (nothing)
    """
    size = determine_max_fuse_size()
    fp.write("const word   _FUSES_CT             = " + "%d" % size + "\n")
    if cfgvar["fusesize"] == 1:  # single word: only with baseline/midrange
        fp.write("const word   _FUSE_BASE            = 0x%X" % cfgvar["fuseaddr"] + "\n")
        fp.write("const word   _FUSES                = 0x%X" % cfgvar["fusedefault"][0] + "\n")
    else:
        if cfgvar["core"] != "16":
            fp.write("const word   _FUSE_BASE[_FUSES_CT] = {\n")
        else:
            fp.write("const byte*3 _FUSE_BASE[_FUSES_CT] = {\n")
        # Write the addresses of the fuses.
        for i in range(size):
            fp.write(" " * 39 + "0x%X" % (cfgvar["fuseaddr"] + i))
            # Check if last element was written.
            if (i == (size - 1)):
                fp.write(" \n")
            else:
                fp.write(",\n")
        fp.write(" " * 36 + " }\n")
        # Now write the names of the fuses (config registers).
        if cfgvar["core"] != "16":
            fp.write("const word   _FUSES[_FUSES_CT]     = {\n")
            for i in range(size):
                fp.write(" " * 39 + "0x%04X" % (cfgvar["fusedefault"][i]))
                if (i == (size - 1)):
                    fp.write(" ")
                else:
                    fp.write("," )
                fp.write(" " * 5 + "-- " + (cfgvar["fusename"][i]) + "\n")
            fp.write(" " * 36 + " }\n")
        else:
            fp.write("const byte   _FUSES[_FUSES_CT]     = {\n")
            for i in range(size):
                fp.write(" " * 39 + "0x%02X" % (cfgvar["fusedefault"][i]) )
                if (i == (size - 1)):
                    fp.write(" ")
                else:
                    fp.write(",")
                fp.write( " " * 5 + "-- " + (cfgvar["fusename"][i]) + "\n")
            fp.write(" " * 36 + " }\n")
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

def list_all_sfr(fp, pic):
    """ Generate declarations of special function registers, pins, etc.
    Input:   - output file
             - pic: root of .pic (xml parsed structure)
    Output:  part of device files
    Returns: (nothing)
    Notes:   - skip SFRs with 'ExtendedModeOnly' parent
    """
    dataspace = pic.find("DataSpace")
    for mode in list(dataspace):
        if mode.tag == "ExtendedModeOnly":  # not supported by JalV2
            continue
        for sfrdatasector in mode.findall("SFRDataSector"):
            for child in list(sfrdatasector):
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
    if child.tag == "SFRDef":
        list_sfr(fp, child)
    elif child.tag == "JoinedSFRDef":
        reg = child.get("cname").upper()
        width = max(2, (eval(child.get("nzwidth")) + 7) // 8)  # round to # bytes
        if width < 3:  # maybe not correct: check
            width_chk = len(child.findall("MuxedSFRDef"))
            if (width_chk == 0):  # no muxed SFRs
                width_chk = len(child.findall("SFRDef"))  # regular SFRs
            width = max(width, width_chk)  # take largest
        sfraddr = eval(child.get("_addr"))
        list_separator(fp)
        list_variable(fp, reg, width, sfraddr)
        list_multi_module_register_alias(fp, child)
        if reg in ("FSR0", "FSR1", "PCLAT", "TABLAT", "TBLPTR"):
            list_variable(fp, "_" + reg.lower(), width, sfraddr)  # compiler required name
        for gchild in list(child):
            if gchild.tag == "MuxedSFRDef":
                for selectsfr in gchild.findall("SelectSFR"):
                    list_muxed_sfr(fp, selectsfr)
            elif gchild.tag == "SFRDef":
                list_sfr(fp, gchild)
    elif (child.tag == "MuxedSFRDef"):
        selectsfrs = child.findall("SelectSFR")
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
    sfrname = sfr.get("cname").upper()
    sfraddr = eval(sfr.get("_addr"))
    if (sfrname.startswith("TMR") & sfrname.endswith("L")):
        if (sfrname[0:-1] not in names):  # missing word for 16-bits timer
            list_variable(fp, sfrname[0:-1], 2, sfraddr)
            list_separator(fp)
    if not ((sfrname == "GPIO") | ((sfrname.startswith("PORT")) & (sfrname != "PORTVP"))):
        list_variable(fp, sfrname, 1, sfraddr)  # not a port
    if sfrname.startswith("LAT") & (sfrname != "LATVP"):
        if ("PORT" + sfrname[-1]) in names:  # PORTx < LATx
            list_lat_shadow(fp, sfrname)
    elif sfrname.startswith("PORT") & (sfrname != "PORTVP"):
        if ((sfrname == "PORTB") & (picname.startswith("12"))):
            print("   PORTB register interpreted as GPIO / PORTA")
            list_variable(fp, "GPIO_", 1, sfraddr)
            list_alias(fp, "PORTA_", "GPIO_")
            list_port_shadow(fp, "PORTA")
        elif cfgvar["haslat"] == False:
            list_variable(fp, sfrname + "_", 1, sfraddr)
            list_port_shadow(fp, sfrname)
        elif (cfgvar["haslat"] == True) & (("LAT" + sfrname[-1]) in names):  # LATx < PORTx
            list_variable(fp, sfrname, 1, sfraddr)
            list_lat_shadow(fp, sfrname)
        else:
            list_variable(fp, sfrname, 1, sfraddr)
    elif sfrname == "GPIO":
        list_variable(fp, "GPIO_", 1, sfraddr)
        list_alias(fp, "PORTA_", "GPIO_")
        list_port_shadow(fp, "PORTA")
    elif sfrname in ("SPBRG", "SPBRG1", "SP1BRG"):
        width = eval(sfr.get("nzwidth"))
        if ((width == 8) & ("SPBRGL" not in names)):
            list_alias(fp, "SPBRGL", sfrname)
    elif sfrname in ("SPBRG2", "SP2BRG"):
        if ("SPBRGL2" not in names):
            list_alias(fp, "SPBRGL2", sfrname)
    elif sfrname in ("TRISIO", "TRISGPIO"):
        list_alias(fp, "TRISA", sfrname)
        list_alias(fp, "PORTA_direction", sfrname)
        list_tris_nibbles(fp, "TRISA")
    elif sfrname.startswith("TRIS") & (sfrname != "TRISVP"):
        list_alias(fp, "PORT" + sfrname[-1] + "_direction", sfrname)
        list_tris_nibbles(fp, sfrname)

    modelist = sfr.find("SFRModeList")
    for mode in modelist.findall("SFRMode"):
        offset = 0
        for fielddef in list(mode):
            offset = list_sfr_subfield(fp, fielddef, sfrname, offset)

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
    # Some PICs have an inconsistency in the MPLABX file,
    # which are PICs with USB pins. These pins are input-only
    if (child.tag == "AdjustPoint"):
        picname = cfgvar["picname"]
        if ((offset == 0) & (picname in ("18f13k50", "18lf13k50", "18f14k50", "18lf14k50",
                                         "16f1454", "16f1455", "16f1459",
                                         "16lf1454", "16lf1455", "16lf1459"))):
            if ((sfrname == "LATA") & ("pin_A0" not in names)):
                print("   Adding pin_A0, A1")
                for p in range(2):  # add pin_A0..A1
                    # list_bitfield(fp, "LATA_LATA%d" % (p), 1, "LATA", p)
                    list_bitfield(fp, "pin_A%d" % (p), 1, "PORTA", p)
                    list_pin_alias(fp, "A%d" % (p), "PORTA")
        offset = offset + eval(child.get("offset"))
    elif (child.tag == "SFRFieldDef"):
        width = eval(child.get("nzwidth"))
        if (subfields_wanted(sfrname)):  # exclude subfields of some registers
            adcssplitpics = ("16f737", "16f747", "16f767", "16f777",
                             "16f818", "16f819", "16f88",
                             "16f873a", "16f874a", "16f876a", "16f877a",
                             "18f242", "18f2439", "18f248", "18f252", "18f2539",
                             "18f258", "18f442", "18f4439",
                             "18f448", "18f452", "18f4539", "18f458")
            picname = cfgvar["picname"]
            core = cfgvar["core"]
            fieldname = child.get("cname").upper()
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
                        # 18F PICs with USB pins (C4 and C5) are only input.
                        ((fieldname == "LATC4") & (cfgvar["latc4_out"] == False)) |
                        ((fieldname == "LATC5") & (cfgvar["latc5_out"] == False)) |
                        ((fieldname == "LATE3") & (cfgvar["late3_out"] == False))):
                    list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                    pin = "pin_" + portletter + pinnumber
                    if ("PORT" + portletter in names) & (pin not in names):  # PORTx < LATx
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
                elif ((sfrname == "PORTC") & (fieldname == "RC4") &
                      (cfgvar["haslat"] == True) & (cfgvar["latc4_out"] == False)):
                    # PICs with USB pins (C4) are only input.
                    list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
                    list_bitfield(fp, pin, 1, sfrname, offset)
                    list_pin_alias(fp, portletter + pinnumber, sfrname)
                elif ((sfrname == "PORTC") & (fieldname == "RC5") &
                      (cfgvar["haslat"] == True) & (cfgvar["latc5_out"] == False)):
                    # PICs with USB pins (C5) are only input.
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
                    if ("LAT" + portletter in names) & (pin not in names):  # LAT<portletter> already declared
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
                mask = eval(child.get("mask"))
                # print(sfrname, fieldname, width, mask, offset)
                if ((width == 8) & (mask in (1, 3, 7, 15, 31, 63, 127))):
                    #  print("width", width, "mask", mask)
                    width = 1 + (1, 3, 7, 15, 31, 63, 127).index(mask)
                    #  print("new width", width)
                list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)

            # additional declarations:
            if ((sfrname.startswith("ADCON")) & (fieldname.endswith("VCFG0"))):
                list_bitfield(fp, sfrname + "_VCFG", 2, sfrname, offset)
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

def list_muxed_sfr(fp, selectsfr):
    """ Generate declaration of multiplexed registers (registers which share their address).
    Input:   - output file
             - SelectSFR node
             - current SFR addr
    Output:  part of device files
    Returns: (nothing)
    Notes:   Multiplexed registers must be declared after all other SFRs
             because the pseudo procedures access a control register
             which must have been declared first, otherwise it is 'unknown'.
    """
    cond = selectsfr.get("when")
    for sfr in selectsfr.findall("SFRDef"):
        if (cond == None):  # default sfr
            list_sfr(fp, sfr)
        else:  # alternate sfr on this address
            sfrname = sfr.get("cname").upper()
            sfraddr = eval(sfr.get("_addr"))
            core = cfgvar["core"]
            subst = sfrname + "_"  # substitute name
            if (core == "14"):
                if (sfrname == "SSPMSK"):
                    list_muxed_pseudo_sfr(fp, sfrname, sfraddr, cond)
                else:
                    print("Unexpected multiplexed SFR", sfr, "for core", core)
            # MPLABX 6.05. New PICS with core 14H now have multiplexed registers too.
            elif (core == "14H") | (core == "16"):
                if sfrname.startswith("PMDOUT"):
                    list_variable(fp, sfrname, 1, sfraddr)  # master/slave: automatic
                elif (sfrname in ("SSP1MSK", "SSP2MSK")):
                    list_muxed_pseudo_sfr(fp, sfrname, sfraddr, cond)
                    if (sfrname == "SSP1MSK"):
                        list_alias(fp, "SSPMSK", sfrname)
                # MPLABX 6.20. Added: TU16ATMRT, TU16ACRT, TU16BTMRT, TU16BCRT for PIC18FxxQ20.
                elif ((sfrname in ("CVRCON", "MEMCON", "PADCFG1", "REFOCON", "CRCOUTL", "CRCOUTH", "CRCOUTU",
                                   "CRCOUTT","CRCSHFTL","CRCSHFTH", "CRCSHFTU", "CRCSHFTU", "CRCSHFTT",
                                   "CRCXORL", "CRCXORH", "CRCXORU", "CRCXORT", "TU16ACRT", "TU16ATMRL",
                                   "TU16ATMRH", "TU16ATMRT", "TU16ACRL", "TU16ACRH", "TU16BTMRL", "TU16BTMRH",
                                   "TU16BCRL", "TU16BCRH", "TU16BCRT", "TU16BTMRT")) |
                       sfrname.startswith(("ODCON", "ANCON"))):
                    list_muxed_pseudo_sfr(fp, sfrname, sfraddr, cond)
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
    sfrname = sfr.get("cname").upper()
    modelist = sfr.find("SFRModeList")
    for mode in list(modelist):
        offset = 0
        for child in list(mode):
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
    if (child.tag == "AdjustPoint"):
        offset = offset + eval(child.get("offset"))
    elif (child.tag == "SFRFieldDef"):
        width = eval(child.get("nzwidth"))
        if subfields_wanted(sfrname):
            field = sfrname + "_" + child.get("cname").upper()
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
                mask = eval(child.get("mask"))
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
    if not cfgvar["core"] == "12":
        return
    dataspace = root.find("DataSpace")
    modelist = list(dataspace)
    for mode in list(modelist):
        if mode.tag == "ExtendedModeOnly":  # not supported by JalV2
            continue
        if (nmmrplace := mode.find("NMMRPlace")) is not None:
            for sfr in nmmrplace.findall("SFRDef"):
                list_nmmrdata_child(fp, sfr)

def list_nmmrdata_child(fp, nmmr):
    """ Generate declaration a memory mapped register
    Input:   - output file
             - NMMR node
    Output:  part of device files
    Returns: (nothing)
    Notes:   only for core 12
    """
    global names
    if nmmr.tag == "SFRDef":
        sfrname = nmmr.get("cname").upper()
        picname = cfgvar["picname"]
        if sfrname == "OPTION_REG":
            if sfrname not in names:
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
    sfrname = nmmr.get("cname").upper()
    modelist = nmmr.find("SFRModeList")
    for mode in list(modelist):
        offset = 0
        for item in list(mode):
            offset = list_nmmr_option_bitfield(fp, item, sfrname, offset)

def list_nmmr_tris_subfields(fp, nmmr):
    """ Format all subfields of NMMR TRIS
    Input:  - file
            - NMMR node
    Notes:  - Expected to be used with 12Fs only
    """
    sfrname = nmmr.get("cname").upper()
    modelist = nmmr.find("SFRModeList")
    for mode in list(modelist):
        offset = 0
        for item in list(mode):
            offset = list_nmmr_tris_bitfield(fp, item, sfrname, offset)

def list_nmmr_option_bitfield(fp, child, sfrname, offset):
    """ Format a single bitfield of NMMR OPTION pseudo register
    Input:  - index in .pic
            - register node
    Notes:  - Expected to be used with 12Fs only
    """
    if (child.tag == "AdjustPoint"):
        offset = offset + eval(child.get("offset"))
    elif (child.tag == "SFRFieldDef"):
        width = eval(child.get("nzwidth"))
        fieldname = child.get("cname").upper()
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

    if (child.tag == "AdjustPoint"):
        offset = offset + eval(child.get("offset"))
    elif (child.tag == "SFRFieldDef"):
        portletter = child.get("cname")[4:]
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

def list_variable(fp, var, width, addr):
    """ Generate a line with a volatile variable
    Input:   - file pointer
             - name
             - width (in bytes)
             - address (decimal)   ??? maybe string ???
    Returns: nothing
    """
    global names
    if var not in names:
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
    if (child.tag == "AdjustPoint"):
        offset = offset + eval(child.get("offset"))
    elif (child.tag == "SFRFieldDef"):
        width = eval(child.get("nzwidth"))
        if (width < 8):
            fieldname = child.get("cname").upper()
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
    sfrname = sfr.get("cname").upper()
    if (len(sfrname) < 5):  # can skip short names
        return
    alias = ''  # default: no alias
    if (sfrname == "BAUDCTL"):  # some midrange, 18f1x20
        alias = 'BAUDCON'
    elif (sfrname == "BAUD1CON"):  # 1st USART: sfrname with index
        alias = "BAUDCON"  # remove "1"
    elif (sfrname == "BAUD2CON"):  # 2nd USART: sfrname with suffix
        alias = "BAUDCON2"  # make index "2" a suffix
    elif (sfrname == "BAUD3CON"):  # 3rd USART: sfrname with suffix
        alias = "BAUDCON3"  # make index "3" a suffix
    elif (sfrname == "BAUD4CON"):  # 4th USART: sfrname with suffix
        alias = "BAUDCON4"  # make index "4" a suffix
    elif (sfrname == "BAUD5CON"):  # 5th USART: sfrname with suffix
        alias = "BAUDCON5"  # make index "5" a suffix
    elif (sfrname in ("BAUDCON1", "BAUDCTL1", "RCREG1", "RCSTA1",
                      "SPBRG1", "SPBRGH1", "SPBRGL1", "TXREG1", "TXSTA1")):
        alias = sfrname[0:-1]  # remove trailing "1" index
    elif (sfrname in ("RC1REG", "RC1STA", "SP1BRG", "SP1BRGH",
                      "SP1BRGL", "TX1REG", "TX1STA")):
        alias = sfrname[0:2] + sfrname[3:]  # remove embedded "1" index
    elif (sfrname in ("RC2REG", "RC2STA", "SP2BRG", "SP2BRGH",
                      "SP2BRGL", "TX2REG", "TX2STA")):
        alias = sfrname[0:2] + sfrname[3:] + "2"  # make index "2" a suffix
    elif (sfrname in ("RC3REG", "RC3STA", "SP3BRG", "SP3BRGH",
                      "SP3BRGL", "TX3REG", "TX3STA")):
        alias = sfrname[0:2] + sfrname[3:] + "3"  # make index "3" a suffix
    elif (sfrname in ("RC4REG", "RC4STA", "SP4BRG", "SP4BRGH",
                      "SP4BRGL", "TX4REG", "TX4STA")):
        alias = sfrname[0:2] + sfrname[3:] + "4"  # make index "4" a suffix
    elif (sfrname in ("RC5REG", "RC5STA", "SP5BRG", "SP5BRGH",
                      "SP5BRGL", "TX5REG", "TX5STA")):
        alias = sfrname[0:2] + sfrname[3:] + "5"  # make index "5" a suffix
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
            sfrmodelist = sfr.find("SFRModeList")
            for mode in sfrmodelist.findall("SFRMode"):
                offset = 0
                for child in list(mode):
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
    modelist = status.find("SFRModeList")
    modes = modelist.findall("SFRMode")
    for mode in modes:
        offset = 0
        for bitfield in list(mode):
            offset = list_status_subfield(fp, bitfield, offset)
    if cfgvar["core"] == "16":
        fp.write("const        byte   _banked %23s" % "=  1\n")
        fp.write("const        byte   _access %23s" % "=  0\n")

def list_status_subfield(fp, field, offset):
    """List subfields of status register
    Input: - start index in pic.
    Notes: - name is stored but not checked on duplicates
    """
    if field.tag == "AdjustPoint":
        offset = offset + eval(field.get("offset"))
    elif field.tag == "SFRFieldDef":
        fieldname = field.get("cname").lower()
        width = eval(field.get("nzwidth"))
        if width == 1:
            if fieldname == "nto":
                fp.write("const        byte   %-25s =  %d\n" % ("_not_to", offset))
            elif fieldname == "npd":
                fp.write("const        byte   %-25s =  %d\n" % ("_not_pd", offset))
            else:
                fp.write("const        byte   %-25s =  %d\n" % ("_" + fieldname, offset))
        offset = offset + width
    return offset

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
    if (pinlist := root.find("PinList")) is None:
        return
    remaplist = pinlist.findall("RemappablePin")
    for pin in remaplist:
        pindir = pin.get("direction")
        if (pindir in ("out", "bi")):
            vpins = pin.findall("VirtualPin")
            for vpin in vpins:
                pinfunc = vpin.get("name")
                pinfunc = pinfunc.upper()
                pinpatt = vpin.get("ppsval")
                if pinpatt is None:
                    pinpatt = "0"
                if pinpatt == "0":
                    # No value found. First check if we need to apply the pps fix for 16f1713/16f1716.
                    if ((picname in ("16f1713", "16f1716", "16lf1713", "16lf1716")) and
                        (pinfunc in pic16f1713_6_pps_fix_def)):
                        pinpatt = pic16f1713_6_pps_fix_def[pinfunc]
                        # Same code as below but since it is temporary we duplicate it for now.
                        if pinpatt in ppsoutdict:
                            tmp = ppsoutdict[pinpatt]  # get old
                            tmp.append(pinfunc)
                            ppsoutdict[pinpatt] = tmp
                        else:
                            ppsoutdict[pinpatt] = [pinfunc]
                    else:
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
            pps_error = False
            # If RxyPPS is too big there might be an error in the MPLABX file. Assume higher than 100 is too big.
            if (k > 100):
                pps_warning = True
                pps_error = True
            if (k < 200): # pattern found in .pic file
                for f in ppsoutdict[k]:
                    # correction of MPLABX error. @2018-06-17: Correction still needed.
                    if (picname in ("16f15355", "16f15356", "16lf15355", "16lf15356")):
                        if ((f == "CK2") & (k == 0x0F)):
                            f = "CK1"
                    # Do not print the PPS value if it is incorrect.
                    if (pps_error == True):
                        print("   Ignoring PPS for", f)
                    else:
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
                pps_warning = True
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
    programspace = root.find("ProgramSpace")
    if (configfusesector := programspace.find("ConfigFuseSector")) is None:
        configfusesector = programspace.find("WORMHoleSector")
    dcraddr = eval(configfusesector.get("beginaddr"))  # start address
    for dcrdef in list(configfusesector):
        dcraddr = list_dcrdef(fp, dcrdef, dcraddr)

def list_dcrdef(fp, dcrdef, addr):
    """ Generate declaration of a configuration byte/word, incl subfields

    Input:   - output file
             - config fuse sector node
             - current config address
    Output:  part of device file
    Returns: config fuse address (updated if applicable)
    """
    if dcrdef.tag == "AdjustPoint":
        addr = addr + eval(dcrdef.get("offset"))
    elif dcrdef.tag == "DCRDef":
        dcrname = dcrdef.get("cname").upper()
        fp.write("--\n")
        fp.write("-- %s (0x%X)\n" % (dcrname, addr))
        fp.write("--\n")
        modelist = dcrdef.find("DCRModeList")
        for mode in list(modelist):
            offset = 0
            for item in list(mode):
                offset = list_dcrfielddef(fp, item, addr - cfgvar["fuseaddr"], offset)
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
    if dcrfielddef.tag == "AdjustPoint":
        offset += eval(dcrfielddef.get("offset"))
    elif dcrfielddef.tag == "DCRFieldDef":
        width = eval(dcrfielddef.get("nzwidth"))
        if dcrfielddef.get("ishidden") is None:  # do not list hidden fields
            name = dcrfielddef.get("cname").upper()
            name = normalize_fusedef_key(name)
            mask = eval(dcrfielddef.get("mask"))
            str = "pragma fuse_def " + name
            if (cfgvar["fusesize"] > 1):
                str = str + ":%d " % (index)
            str = str + " 0x%X {" % (mask << offset)  # position in byte!
            fp.write("%-40s -- %s\n" % (str, dcrfielddef.get("desc")))
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
    Returns: (nothing)
    Notes:   - bitfield
    """
    kwdsemlist = []
    for child in list(dcrfielddef):
        if child.tag == "DCRFieldSemantic":
            if child.get("ishidden") is not None:   # skip hidden fields
                continue
            if (fieldname := child.get("cname")) is not None:
                fieldname = fieldname.upper()
                if fieldname.startswith("RESERVED") | (fieldname == ""):
                    continue
                if child.get("islanghidden") is not None:
                    continue
                when = child.get("when").split()
                desc = child.get("desc")
                fieldname = normalize_fusedef_value(key, fieldname, desc)
                if fieldname != "":
                    if fieldname not in kwdsemlist:
                        kwdsemlist.append(fieldname)
                        if (key == "XINST") & (fieldname == "ENABLED"):
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

    def bcrceresh(val): # CRC Boot Expected Value
        return val

    def bcrceresl(val): # CRC Boot Expected Value
        return val

    def bcrceresu(val): # CRC Boot Expected Value
        return val

    def bcrcerest(val): # CRC Boot Expected Value
        return val

    def bcrcpoll(val): # CRC Boot Polynomial
        return val

    def bcrcpolh(val): # CRC Boot Polynomial
        return val

    def bcrcpolt(val): # CRC Boot Polynomial
        return val

    def bcrcpolu(val): # CRC Boot Polynomial
        return val

    def bcrcseedh(val): # CRC Boot Seed
        return val

    def bcrcseedl(val): # CRC Boot Seed
        return val

    def bcrcseedt(val): # CRC Boot Seed
        return val

    def bcrcseedu(val): # CRC Boot Seed
        return val

    def bg(val):  # band gap
        if (val == '0'):
            return "HIGHEST"
        elif (val == "3"):
            return "LOWEST"
        else:
            return descu

    def bootpinsel(val): # CRC-on-Boot Pin Select
        if val in ("RA2", "RA4", "RC4", "RC5"):
            return val
        else:
            return descu

    def bootcoe(val): # Continue on Error for Boot Block Areas Enable
        if (val == "HALT"):
            return "DISABLED"
        elif (val == "CONTINUE"):
            return "ENABLED"
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

    def coe(val): # Continue on Error for Non-Boot Block Areas Enable
        if (val == "HALT"):
            return "DISABLED"
        elif (val == "CONTINUE"):
            return "ENABLED"
        else:
            return descu

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

    def crceresh(val): # CRC Expected Value
        return val

    def crceresl(val): # CRC Expected Value
        return val

    def crcerest(val): # CRC Expected Value
        return val

    def crceresu(val): # CRC Expected Value
        return val

    def crcpolh(val): # CRC Polynomial
        return val

    def crcpoll(val): # CRC Polynomial
        return val

    def crcpolt(val): # CRC Polynomial
        return val

    def crcpolu(val): # CRC Polynomial
        return val

    def crcseedh(val): # CRC Seed
        return val

    def crcseedl(val): # CRC Seed
        return val

    def crcseedu(val): # CRC Seed
        return val

    def crcseedt(val): # CRC Seed
        return val

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

    def vddar(val): # VDD Analog Range Calibration Selection.
        if (val == "LO"):
            return "LOW"
        elif (val == "HI"):
            return "HIGH"
        else:
            return descu

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

    def zcd(val): # Inconsistent use of ON and OFF for enable and disable for some older PICs.
        if picname in ("16f1703", "16f1704", "16f1705", "16f1707", "16f1708", "16f1709",
                       "16f1713", "16f1716", "16f1717", "16f1718", "16f1719",
                       "16lf1703", "16lf1704", "16lf1705", "16lf1707", "16lf1708", "16lf1709",
                       "16lf1713", "16lf1716", "16lf1717", "16lf1718", "16lf1719"):
            if (val == "ON"):
                return "DISABLED"
            elif (val == "OFF"):
                return "ENABLED"
            else:
                return descu
        else:
            if (val == "ON"):
                return "ENABLED"
            elif (val == "OFF"):
                return "DISABLED"
            else:
                return descu

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

    else:  # simple keywords
        kwdvalue = locals().get(key.lower(), other)(val)  # call appropriate procedure

    if kwdvalue == "":  # empty keyword
        print("   No keyword found for fuse_def", key, "<" + desc + ">")
	# RJ MPLABX6.05 kwdvalue changed from 22 to 80 because of long description.
    elif len(kwdvalue) > 80:
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
        (child.tag != "Mirror")):
        return
    if child.get("_addr") is None:  # missing address
        return
    mirror = eval(child.get("_addr"))  # mirror address
    mirror_bank = eval(child.get("regionidref")[-1])  # bank number of the mirrored sfr
    mirrored = mirror % cfgvar["banksize"] + mirror_bank * cfgvar["banksize"]
    for i in range(eval(child.get("nzsize"))):
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

def collect_config_info(pic, picname):
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
    cfgvar["procid"] = eval(pic.get("procid"))  #
    # print(f'{cfgvar["procid"]:04X}')
    cfgvar["picname"] = picname
    cfgvar["adcs_bits"] = 0  # adcs bits in ANSEL/ANCON
    cfgvar["cmxcon0mask"] = "0000_0000"  # power on reset state
    cfgvar["devid"] = 0  # no devID
    cfgvar["haslat"] = False  # no LATx register
    cfgvar["ircf_bits"] = 3  # ircf bits in OSCCON
    cfgvar["lata3_out"] = False  # True: LATA_RA3 bit output capable
    cfgvar["lata5_out"] = False  # LATA_RA5  "    "       "
    cfgvar["latc4_out"] = False  # LATC_RC4  "    "       " For 18F PICs with USB pins (C4) that are only input.
    cfgvar["latc5_out"] = False  # LATC_RC5  "    "       " For 18F PICs with USB pins (C5) that are only input.
    cfgvar["late3_out"] = False  # LATE_RE3  "    "       "
    cfgvar["numbanks"] = 1  # RAM banks
    cfgvar["instructionset"] = 0  # Not yet defined
    cfgvar["instructionset_name"] = "-"  # Not yet defined
    cfgvar["osccal"] = 0  # no OSCCAL
    cfgvar["wdtcon_adshr"] = (0, 0)  # no WDTCON_ADSHR (address,offset)
    cfgvar["arch"] = pic.get("arch")
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
    cfgvar["dsid"] = pic.get("dsid")

    power = pic.find("Power")
    vpp = power.find("VPP")
    cfgvar["vppdef"] = vpp.get("defaultvoltage")
    cfgvar["vppmax"] = vpp.get("maxvoltage")
    cfgvar["vppmin"] = vpp.get("minvoltage")
    vdd = power.find("VDD")
    cfgvar["vddnom"] = vdd.get("nominalvoltage")
    cfgvar["vddmax"] = vdd.get("maxvoltage")
    cfgvar["vddmin"] = vdd.get("minvoltage")

    arch = pic.find("ArchDef")
    memtraits = arch.find("MemTraits")
    if memtraits.find("bankcount"):
        cfgvar["numbanks"] = eval(memtraits.get("bankcount"))
    cfgvar["hwstack"] = eval(memtraits.get("hwstackdepth"))

    instrset = pic.find("InstructionSet")
    instrsetname = "-"
    instrsetname = instrset.get("instructionsetid")
    # Translate instruction set name to  number.
    if instrsetname in instruction_set_def:
        cfgvar["instructionset"] = instruction_set_def[instrsetname]
        cfgvar["instructionset_name"] =instrsetname
    else:
        print("   undetermined instruction set.")

    pgmspace = pic.find("ProgramSpace")
    codesectors = pgmspace.findall("CodeSector")
    codesize = 0
    for codesector in codesectors:
        codesize = codesize + eval(codesector.get("endaddr")) - \
                   eval(codesector.get("beginaddr"))
    cfgvar["codesize"] = codesize
    useridsector = pgmspace.find("UserIDSector")
    if useridsector is not None:
        cfgvar["idaddr"] = eval(useridsector.get("beginaddr"))
        cfgvar["idsize"] = eval(useridsector.get("endaddr")) - \
                           eval(useridsector.get("beginaddr"))
    eedatasector = pgmspace.find("EEDataSector")
    if eedatasector is not None:
        cfgvar["eeaddr"] = eval(eedatasector.get("beginaddr"))
        cfgvar["eesize"] = eval(eedatasector.get("endaddr")) - \
                           eval(eedatasector.get("beginaddr"))
    flashdatasector = pgmspace.find("FlashDataSector")
    if flashdatasector is not None:
        cfgvar["eeaddr"] = eval(flashdatasector.get("beginaddr"))
        cfgvar["eesize"] = eval(flashdatasector.get("endaddr")) - \
                           eval(flashdatasector.get("beginaddr"))
    devidsector = pgmspace.find("DeviceIDSector")
    if devidsector is not None:
        cfgvar["devid"] = eval(devidsector.get("value"))
    if len(configfusesectors := pgmspace.findall("ConfigFuseSector")) > 0:
        # From MPLABX 6.20 the XML may contain more than one configfusesector. So we need to look for more than
        # one and determine the actual fusesize taking all configfusesectors into account.
        fuseaddr_low = 0xFFFFFF
        fuseaddr_high = 0x0
        for cfgsec in configfusesectors:
            if (new_low := eval(cfgsec.get("beginaddr"))) < fuseaddr_low:
                fuseaddr_low = new_low
            if (new_high := eval(cfgsec.get("endaddr"))) > fuseaddr_high:
                fuseaddr_high = new_high
        cfgvar["fuseaddr"] = fuseaddr_low
        cfgvar["fusesize"] = fuseaddr_high - fuseaddr_low
        picdata = dict(list(devspec[picname.upper()].items()))
        if "FUSESDEFAULT" in picdata:
            cfgvar["fusedefault"] = [eval("0x" + picdata["FUSESDEFAULT"])]
            cfgvar["fusename"] = ["CONFIG"] # Any value other than 'RESERVED' is OK.
        else:
            cfgvar["fusedefault"] = [255] * cfgvar["fusesize"]
            cfgvar["fusename"] = ["RESERVED"] * cfgvar["fusesize"]
            load_fuse_defaults(pic)
    wormholesector = pgmspace.find("WORMHoleSector")
    if wormholesector is not None:  # expected with 16-bits code only
        cfgvar["fuseaddr"] = eval(wormholesector.get("beginaddr"))
        cfgvar["fusesize"] = eval(wormholesector.get("endaddr")) - \
                             eval(wormholesector.get("beginaddr"))
        cfgvar["fusedefault"] = [255] * cfgvar["fusesize"]
        cfgvar["fusename"] = ["RESERVED"] * cfgvar["fusesize"]
        load_fuse_defaults(pic)

    dataspace = pic.find("DataSpace")
    sfraddr = 0  # startvalue of SFR reg addr.
    data = []  # lis of data ranges
    for mode in list(dataspace):
        if mode.tag == "ExtendedModeOnly":  # not supported by JalV2
            continue
        for sfrdatasector in mode.findall("SFRDataSector"):
            if (bank := sfrdatasector.get("bank")) is not None:  # count numbanks
                cfgvar["numbanks"] = max(eval(bank) + 1, cfgvar["numbanks"])
            sfraddr = eval(sfrdatasector.get("beginaddr"))  # actual
            for sfrmir in list(sfrdatasector):  # Mirror or SFRDef
                if sfrmir.tag == "Mirror":
                    collect_mirrors(sfrmir)  # collect mirror addresses
                elif sfrmir.tag == "SFRDef":
                    if sfrmir.get("cname") is not None:
                        sfraddr = eval(sfrmir.get("_addr"))
                        childname = sfrmir.get("cname").upper()
                        if childname == "CM1CON0":
                            mask = sfrmir.get("por")
                            if (len(mask) == 8):  # 8 bits expected
                                mask = re.sub("[^01]", "0", mask)  # replace other than 0 and 1 by 0
                                cfgvar["cmxcon0mask"] = mask[0:4] + "_" + mask[4:8]
                        elif childname == "FSR":
                            cfgvar["fsr"] = sfraddr
                        elif childname == "OSCCAL":
                            cfgvar["osccal"] = sfraddr
                        elif childname == "OSCCON":
                            sfrmodelist = sfrmir.find("SFRModeList")
                            for sfrmode in sfrmodelist.findall("SFRMode"):
                                for bitfield in sfrmode.findall("SFRFieldDef"):
                                    bname = bitfield.get("cname").upper()
                                    if (bname.startswith("IRCF")):
                                        bwidth = eval(bitfield.get("nzwidth"))
                                        if bwidth > 1:
                                            cfgvar["ircf_bits"] = bwidth
                                        else:
                                            if (cfgvar["ircf_bits"] < eval(bname[-1])):
                                                cfgvar["ircf_bits"] = eval(bname[-1])
                        elif childname.startswith("LAT") & (len(childname) == 4) & \
                              ("A" <= childname[-1] <= "L"):
                            cfgvar["haslat"] = True
                            access = sfrmir.get("access")
                            if childname in ("LATA", "LATC", "LATE"):
                                sfrmodelist = sfrmir.find("SFRModeList")
                                for mirmode in list(sfrmodelist):
                                    for field in mirmode.findall("SFRFieldDef"):
                                        # Note: Pin numbers and offsets go in opposite direction so the value for LATA3
                                        #       can be found at access[4].
                                        fieldname = field.get("cname").upper()
                                        if ((fieldname == "LATA3") & (access[4] != "r")):
                                            cfgvar["lata3_out"] = True
                                        if ((fieldname == "LATA5") & (access[2] != "r")):
                                            cfgvar["lata5_out"] = True
                                            # print(f'{cfgvar["lata5_out"]=}')
                                        if ((fieldname == "LATC4") & (access[3] != "r")):
                                            cfgvar["latc4_out"] = True # Check for 18F PICs with USB pin C4 that are only input
                                        if ((fieldname == "LATC5") & (access[2] != "r")):
                                            cfgvar["latc5_out"] = True # Check for 18F PICs with USB pin C5 that are only input
                                        if ((fieldname == "LATE3") & (access[4] != "r")):
                                            cfgvar["late3_out"] = True
                        elif (childname == "WDTCON"):
                            sfrmodelist = sfrmir.find("SFRModeList")
                            for sfrmode in sfrmodelist.findall("SFRMode"):
                                 offset = 0
                                 for bitfield in list(sfrmode):
                                    if (bitfield.tag == "AdjustPoint"):
                                        offset = offset + eval(bitfield.get("offset"))
                                    elif bitfield.tag == "SFRFieldDef":
                                        bname = bitfield.get("cname").upper()
                                        bwidth = eval(bitfield.get("nzwidth"))
                                        if (bname == "ADSHR"):
                                            cfgvar["wdtcon_adshr"] = (sfraddr, offset)
                                            break
                                        offset = offset + bwidth

        for gprdatasector in mode.findall("GPRDataSector"):
            if (bank:= gprdatasector.get("bank")) is not None:  # count numbanks
                cfgvar["numbanks"] = max(eval(bank) + 1, cfgvar["numbanks"])
            if gprdatasector.get("shadowidref") is None:
                gpraddr = eval(gprdatasector.get("beginaddr"))
                gprlast = eval(gprdatasector.get("endaddr"))
                data.append((gpraddr, gprlast))
                if ((gprdatasector.get("regionid") == "gprnobnk") |
                    (gprdatasector.get("regionid") == "gprnobank") |
                    (gprdatasector.get("regionid") == "accessram")):
                    cfgvar["sharedrange"] = (gpraddr, gprlast)
                if gpraddr == 0:
                    cfgvar["accessbanksplitoffset"] = gprlast

    # Note that some PICs also have a SystemGPRDataSector. These sectors are in the data space but used for
    # something else. Copying the above code and replacing gprdatasectors by SystemGPRDataSector would add
    # these locations to the data space. Since it is not always clear if this can be used by the program
    # running within the PIC these locations are not added. It concerns at least the following
    # SystemGPRDataSectors which are not added to the dats space: Sector RAM, Buffer RAM and CAN RAM
    # so the total data space may be less than what is mentioned in the data sheet.

        for dprdatasector in mode.findall("DPRDataSector"):
            if (bank := dprdatasector.get("bank")) is not None:  # count numbanks
                cfgvar["numbanks"] = max(eval(bank) + 1, cfgvar["numbanks"])
            if dprdatasector.get("shadowidref") is None:    # no shadow mem
                dpraddr = eval(dprdatasector.get("beginaddr"))
                dprlast = eval(dprdatasector.get("endaddr"))
                data.append((dpraddr, dprlast))
                if ((dprdatasector.get("regionid") == "dprnobnk") |
                    (dprdatasector.get("regionid") == "dprnobank") |
                    (dprdatasector.get("regionid") == "accessram")):
                    cfgvar["sharedrange"] = (dpraddr, dprlast)
                if (dpraddr == 0):
                    cfgvar["accessbanksplitoffset"] = dprlast

        for sfrdatasector in mode.findall("SFRDataSector"):
            if sfrdatasector.get("regionid") == "accesssfr":
                gpraddr = eval(sfrdatasector.get("beginaddr"))
                gprlast = eval(sfrdatasector.get("endaddr"))
                cfgvar["accessfunctionregisters"] = (gpraddr, gprlast)

    cfgvar["datarange"] = compact_address_range(data)

    if ((cfgvar["core"] == "12") | (cfgvar["core"] == "14")) & (cfgvar["numbanks"] > 4):
        cfgvar["numbanks"] = 4  # max 4 banks for core 12, 14

    if "sharedrange" not in cfgvar:  # no shared range found
        if len(cfgvar["datarange"]) == 1:  # single data bank
            cfgvar["sharedrange"] = cfgvar["datarange"][0]  # all data is shared
        else:
            print("   Multiple banks, but no shared data!")

def load_fuse_defaults(pic):
    """ Load fuse defaults
    Input:   - xml structure
    Output:  cfgvar["fusedefault"]
    Returns: (nothing)
    Notes:   -
    """
    programspace = pic.find("ProgramSpace")
    configfusesectors = programspace.findall("ConfigFuseSector")
    if len(configfusesectors) == 0:
        configfusesectors = programspace.findall("WORMHoleSector")
    for configfusesector in configfusesectors:
        dcraddr = eval(configfusesector.get("beginaddr"))  # start address
        for item in list(configfusesector):
            dcraddr = load_dcrdef_default(item, dcraddr)

def load_dcrdef_default(dcrdef, addr):
    """ Load individual configuration byte/word
    Input:   - dcrdef
             - current fuse address
             - current fuse name
    Output:  part of device file
    Returns: next config fuse address
    """
    if dcrdef.tag == "AdjustPoint":
        addr = addr + eval(dcrdef.get("offset"))
    elif dcrdef.tag == "DCRDef":
        index = addr - cfgvar["fuseaddr"]  # position in array
        cfgvar["fusedefault"][index] = eval(dcrdef.get("default"))
        cfgvar["fusename"][index] = dcrdef.get("cname")
        addr = addr + 1
    return addr

def pic2jal(picfile):
    """ Convert a single MPLABX .PIC file to a JalV2 device file
    Input:   - picname
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

    xmlspec = os.path.join(xmldir, picfile)   # pathspec of xml file
    with open(xmlspec, 'r') as fp:
        xmlstr = fp.read()   # complete xml content
        # remove '' and 'xsi:' namespace prefixes in xml file
        xmlstr = xmlstr.replace('edc:', '')
        xmlstr = xmlstr.replace('xsi:', '')
    root = et.fromstring(xmlstr)  # parse xml content

    collect_config_info(root, picname)  # scan for selected info

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
    return 1    # device file created

def generate_devicefiles(selection):
    """ Main procedure.
        Process external configuration info
        Select .pic files to be processed (ic 8-bits flash PICs)
    Input:    Selection of PICs to be handled (wildcard specification)
    Output:   - device file per PIC
              - chipdef_jallib file
    Returns:  Number of generated device files
    """
    def get_procid(picfile):
        # obtain procid from xml file
        procid = 0
        with open(picfile, "r") as fp:
            while (ln := fp.readline()) != "":
                if (offset := ln.find("procid=")) >= 0:  # found procid in this line
                    items = ln[offset + 7 :].split()
                    procid = eval(items[0].strip('"'))
                    break
            else:
                print("no procid found")
        return procid

    # Determine for which pics a devive file must be created and
    # 'en passant' create the chipdef_jallib file.
    devs = []  # start list of PIC xml files (filespecs)
    with open(os.path.join(dstdir, "chipdef_jallib.jal"), "w") as fp:  # common include for device files
        list_chipdef_header(fp)  # create header of chipdef file
        for file in sorted(os.listdir(xmldir)):
            picname = os.path.splitext(file)[0][3:].lower()  # obtain picname from filename
            if fnmatch.fnmatch(picname, selection):  # selection by user wildcard
                if (picdata := devspec.get(picname.upper())):  # some properties of this PIC
                    if picdata.get("DATASHEET", "-") != "-":  # must have datasheet
                        devs.append(file)   # add filespec to list
                        procid = get_procid(os.path.join(xmldir, file))
                        fp.write(f'const  word  PIC_{picname.upper():12s} = 0x{procid:X}\n')
                    else:
                        print("   ", picname, "temporarily(?) excluded!")
        fp.write("--\n")

    if len(devs) > 0:
        # Start a number of parallel processes
        with futures.ProcessPoolExecutor() as executor:
            results = executor.map(pic2jal, devs)
            return sum(results)
    else:
        print(f'No xml files found matching {selection}')
        return 0

# === E N T R Y   P O I N T =============================================

if (__name__ == '__main__'):
    """ Process commandline parameters, start process, clock execution
    """
    if len(sys.argv) > 2:
        print("Expecting maximum 1 argument: PIC selection (wildcards, e.g. '16f8*')")
        print("When using wildcards, specify selection string between quotes")
        print("or use the command 'set -f' to suppress wildcard expansion by the shell")
        sys.exit(1)
    if len(sys.argv) > 1:
        selection = sys.argv[1].lower()                 # device files: lower case names
    else:
        selection = "1*"

    if not os.path.exists(devspecfile):
        shutil.copyfile("devicespecific.json", devspecfile)

    print("   Pic2jal script version", scriptversion,
          "\n   Creating JalV2 device files with MPLABX version", mplabxversion)
    start_time = time.time()

    device_count = generate_devicefiles(selection)  # call real generation routine

    print(f"Generated {device_count} device files")
    runtime = time.time() - start_time
    print(f"Runtime: {runtime:.2f} seconds")
    if runtime > 0:
        print(f"        ({device_count/runtime:.2f} device files per second)")

#
