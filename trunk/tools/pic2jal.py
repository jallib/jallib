#!/usr/bin/python
# ----------------------------------------------------------------------
# Title: pic2Jal.py  - Create JalV2 device files for flash PICs
#
# Author: Rob Hamerling, Copyright (c) 2014..2014, all rights reserved.
#
# Adapted-by:
#
# Revision: $Revision$
#
# Compiler: N/A
#
# This file is part of jallib  http://jallib.googlecode.com
# Released under the BSD license
#              http://www.opensource.org/licenses/bsd-license.php
#
# Description:
#   Python script to create device specifications for JALV2, and
#   the file chipdef_jallib.jal, included by each of these.
#   Input are .pic files from MPLAB-X.
#   Apart from declaration of all registers, register-subfields, ports
#   and pins of the chip the device files contain shadowing procedures
#   to prevent the 'read-modify-write' problems and use the LATx register
#   (for PICs which have such registers) for output in stead of PORTx.
#   In addition some device dependent procedures are provided
#   for common operations, like enable_digital_io().
#   Also various aliases are declared to 'normalize' the names of
#   registers and bit fields, which makes it easier to build device
#   independent libraries.
#
# Sources:  MPLAB-X .pic files
#
# Notes:
#   - A summary of changes of this script is maintained in 'changes.txt'
#     (not published, available on request).
#
# ----------------------------------------------------------------------

import os, sys
import re
import fnmatch
import time
import json
from xml.dom.minidom import parse, Node


# -- basic working parameters -----------------------------

scriptversion   = "0.0.4"
scriptauthor    = "Rob Hamerling"
compilerversion = "2.4q2"
mplabxversion   = "205"
mplabxbase      = "k:/mplab-x_" + mplabxversion                # MPLAB-X base directory
jallibbase      = "k:/jallib"                                  # local copy of jallib trunk

# --- input -----------------------------------------------

picdir        = os.path.join(mplabxbase, "crownking.edc.jar/content/edc")   # dir(s) with pic files
devspecfile   = os.path.join(jallibbase, "tools/devicespecific.json")       # additional PIC properties
pinmapfile    = os.path.join(jallibbase, "tools/pinmap_pinsuffix.json")     # pin aliases
datasheetfile = os.path.join(jallibbase, "tools/datasheet.list")            # list of datasheets

# --- output ----------------------------------------------

dstdir      = "./test"                                         # dest. of generated device files

# --- global constants and variables ----------------------

cfgvar      = {}                                               # PIC properties on picname
devspec     = {}                                               # PIC specific info on picname
pinmap      = {}                                               # pin mapping (pin aliases)
datasheet   = {}                                               # datasheet + suffix on DS number
fusedef_osc = {}                                               # fuse_def OSC keyword mapping
fusedef_kwd = {}                                               # fuse_def keyword normalization

sharedmem   = []                                               # begin,end allocatable shared mem

sfrranges   = {}                                               # address range per base address

names       = []                                               # names of declared variables


# ---------------------------------------------------------
# Title:   Add copyright, etc to header in device files and chipdef.jallib
# Input:   filespec of destination file
# Returns: nothing
# ---------------------------------------------------------
def list_copyright(fp):
   fp.write("--\n")
   fp.write("-- Author: " + scriptauthor + ", Copyright (c) 2008..2014, " +
                          "all rights reserved.\n")
   fp.write("--\n")
   fp.write("-- Adapted-by: N/A (generated file, do not change!)\n")
   fp.write("--\n")
   fp.write("-- Revision: $Revision$\n")
   fp.write("--\n")
   fp.write("-- Compiler: " + compilerversion + "\n")
   fp.write("--\n")
   fp.write("-- This file is part of jallib (http://jallib.googlecode.com)\n")
   fp.write("-- Released under the ZLIB license " +
                " (http://www.opensource.org/licenses/zlib-license.html)\n")
   fp.write("--\n")


# ---------------------------------------------------------
# Title:   List common constants in ChipDef.Jal
# Input:   filespec of destination file
# Returns: nothing
# ---------------------------------------------------------
def list_chipdef_header(fp):
   list_separator(fp)
   fp.write("-- Title: Common Jallib include file for device files\n")
   list_copyright(fp)                                      # insert copyright and other info
   fp.write("-- Sources:\n")
   fp.write("--\n")
   fp.write("-- Description:\n")
   fp.write("--    Common Jallib include files for device files\n")
   fp.write("--\n")
   fp.write("-- Notes:\n")
   fp.write("--    - File creation date/time: " + time.ctime() + "\n")
   fp.write("--    - This file is generated by <pic2jal.py> script " + scriptversion + "\n")
   fp.write("--\n")
   list_separator(fp)
   fp.write("--\n")
   fp.write("-- JalV2 compiler required constants\n")
   fp.write("--\n")
   fp.write("const       PIC_12            = 1\n")
   fp.write("const       PIC_14            = 2\n")
   fp.write("const       PIC_16            = 3\n")
   fp.write("const       SX_12             = 4\n")
   fp.write("const       PIC_14H           = 5\n")
   fp.write("--\n")
   fp.write("const bit   PJAL              = 1\n")
   fp.write("--\n")
   fp.write("const byte  W                 = 0\n")
   fp.write("const byte  F                 = 1\n")
   fp.write("--\n")
   fp.write("include  constants_jallib                     -- common Jallib library constants\n")
   fp.write("--\n")
   list_separator(fp)
   fp.write("--\n")
   fp.write("-- A value assigned to const 'target_chip' by\n")
   fp.write("--    'pragma target chip' in device files\n")
   fp.write("-- can be used for conditional compilation, for example:\n")
   fp.write("--    if (target_chip == PIC_16F88) then\n")
   fp.write("--      ....                                  -- for 16F88 only\n")
   fp.write("--    endif\n")
   fp.write("--\n")


# ---------------------------------------------------------
# Title:   Generate common header
# Input:   - picname
#          - destination file
# Returns: nothing
# Notes:   - Shared memory for _pic_accum and _pic_isr_w is allocated:
#            - for core 12, 14 and 14H from high to low address
#            - for core 16 from low to high address
# ---------------------------------------------------------
def list_devicefile_header(fp, picname):
   list_separator(fp)
   fp.write("-- Title: JalV2 device include file for " + picname + "\n")
   list_copyright(fp)
   fp.write("-- Description:\n")
   fp.write("--    Device include file for PIC " + picname + ", containing:\n")
   fp.write("--    - Declaration of ports and pins of the chip.\n")
   if cfgvar["haslat"] == True:
      fp.write("--    - Procedures to force the use of the LATx register\n")
      fp.write("--      for output when PORTx or pin_xy is addressed.\n")
   else:
      fp.write("--    - Procedures for shadowing of ports and pins\n")
      fp.write("--      to circumvent the read-modify-write problem.\n")
   fp.write("--    - Symbolic definitions for configuration bits (fuses)\n")
   fp.write("--    - Some device dependent procedures for common\n")
   fp.write("--      operations, like:\n")
   fp.write("--      . enable_digital_io()\n")
   fp.write("--\n")
   fp.write("-- Sources:\n")
   fp.write("--  - {MPLAB-X " + mplabxversion[0:1] + "." + mplabxversion[1:3] + "}/" +
            "crownking.edc.jar/content/edc/../" + "PIC" + picname.upper() + ".PIC\n")
   fp.write("--\n")
   fp.write("-- Notes:\n")
   fp.write("--  - File creation date/time: " + time.ctime() + "\n")
   fp.write("--  - This file is generated by <pic2jal.py> script " + scriptversion + "\n")
   fp.write("--\n")
   list_separator(fp)
   fp.write("--\n")
   fp.write("const  word  DEVICE_ID   = 0x%04X" % (cfgvar["devid"]) + "            -- ID for PIC programmer\n")
   fp.write("const  word  CHIP_ID     = 0x%04X" % (cfgvar["procid"]) + "            -- ID in chipdef_jallib\n")
   fp.write("const  byte  PICTYPE[]   = \"" + picname.upper() + "\"\n")
   picdata = dict(devspec[picname.upper()].items())
   fp.write("const  byte  DATASHEET[] = \"" + datasheet[picdata["DATASHEET"]] + "\"\n")
   if "dsid" in cfgvar:
      dsid1 = cfgvar["dsid"]
      if (dsid1 != "0") & (dsid1 != ""):
         dsid2 = dsid1[0:1] + "000" + dsid1[1:]
         if (dsid1 != picdata["DATASHEET"]) & (dsid2 != picdata["DATASHEET"]):
            print "   Possibly conflicting datasheet numbers:"
            print "   .pic file: ", cfgvar["dsid"], ", devicespecific: ", picdata["DATASHEET"]
   if picdata["PGMSPEC"] != "-":
      fp.write("const  byte  PGMSPEC[]   = \"" + datasheet[picdata["PGMSPEC"]] + "\"\n")
   fp.write("--\n")
   fp.write("-- Vdd Range: " + cfgvar["vddmin"] + '-' + cfgvar["vddmax"] +
                " Nominal: " + cfgvar["vddnom"] + "\n")
   fp.write("-- Vpp Range: " + cfgvar["vppmin"] + '-' + cfgvar["vppmax"] +
                " Default: " + cfgvar["vppdef"] + "\n")
   fp.write("--\n")
   list_separator(fp)
   fp.write("--\n")
   fp.write("include chipdef_jallib                  -- common constants\n")
   fp.write("--\n")
   fp.write("pragma  target  cpu   PIC_" + cfgvar["core"] + "            -- (banks=%d)\n" % cfgvar["numbanks"])
   fp.write("pragma  target  chip   " + picname.upper() + "\n")
   fp.write("pragma  target  bank   0x%04X\n" % cfgvar["banksize"])
   if cfgvar["pagesize"] > 0:
      fp.write("pragma  target  page   0x%04X\n" % cfgvar["pagesize"])
   fp.write("pragma  stack          %d\n" % cfgvar["hwstack"])
   if cfgvar["osccal"] > 0:
      fp.write("pragma  code           %d" % (cfgvar["codesize"] - 1) + " "*15 + "-- (excl high mem word)\n")
   else:
      fp.write("pragma  code           %d\n" % cfgvar["codesize"])
   if "eeaddr" in cfgvar:
      fp.write("pragma  eeprom         0x%X,%d\n" % (cfgvar["eeaddr"], cfgvar["eesize"]))
   if "idaddr" in cfgvar:
      fp.write("pragma  ID             0x%X,%d\n" % (cfgvar["idaddr"], cfgvar["idsize"]))

   if "DATA" in picdata:
      fp.write("pragma  data           " + picdata["DATA"] + "\n")
      print "   pragma data overruled by specification in devicespecific"
   else:
      for i in range(0, len(cfgvar["datarange"]), 5):       # max 5 ranges per line
         y = cfgvar["datarange"][i : i+5]
         fp.write("pragma  data           " + ",".join(("0x%X-0x%X" % (r[0], r[1]-1)) for r in y) + "\n")

   fp.write("pragma  shared         ")
   global sharedmem
   sharedmem = []                                           # clear
   if "SHARED" in picdata:
      fp.write(picdata["SHARED"] + "\n")
      print "   pragma shared overruled by specification in devicespecific"
      x = picdata["SHARED"].split("-", 1)
      sharedmem.append(eval(x[0]))
      sharedmem.append(eval(x[1]))
   else:
      if cfgvar["core"] == '16':                            # add high range of access bank
         fp.write("0x%X-0x%X,0xF%X-0xFFF\n" %  \
             (cfgvar["sharedrange"][0],        \
             (cfgvar["sharedrange"][-1] - 1),  \
              cfgvar["accessbanksplitoffset"]) )
      elif cfgvar["core"] == "14H":                         # add core register memory
         fp.write("0x00-0x0B,0x%X-0x%X\n" %    \
             (cfgvar["sharedrange"][0],        \
             (cfgvar["sharedrange"][-1] - 1)))
      else:
         fp.write("0x%X-0x%X\n" %              \
             (cfgvar["sharedrange"][0],        \
              cfgvar["sharedrange"][-1] - 1))
      sharedmem = list(cfgvar["sharedrange"])               # take a workcopy for allocation
      sharedmem[1] = sharedmem[1]  - 1                      # high address
   fp.write("--\n")

   sharedmem_avail = sharedmem[1] - sharedmem[0] + 1        # incl upper bound
   if (cfgvar["core"] == "12") | (cfgvar["core"] == "14"):
      if sharedmem_avail < 2:
         print "   At least 2 bytes of shared memory required! Found:", sharedmem_avail
      else:
         fp.write("var volatile byte _pic_accum at 0x%0X" % sharedmem[1] + "      -- (compiler)\n")
         sharedmem[1] = sharedmem[1] - 1
         fp.write("var volatile byte _pic_isr_w at 0x%0X" % sharedmem[1] + "      -- (compiler)\n")
         sharedmem[1] = sharedmem[1] - 1
   else:
      if sharedmem_avail < 1:
         print "   At least 1 byte of shared memory required! Found:", sharedmem_avail
      elif (cfgvar["core"] == "14H"):
         fp.write("var volatile byte _pic_accum at 0x%0X" % sharedmem[1] + "      -- (compiler)\n")
         sharedmem[1] = sharedmem[1] - 1
      else:                                                 # 16-bits core
         fp.write("var volatile byte _pic_accum at 0x%0X" % sharedmem[0] + "      -- (compiler)\n")
         sharedmem[0] = sharedmem[0] + 1
   fp.write("--\n")


# ---------------------------------------------------------
# Title:   Generate configuration memory declaration and defaults
# Input:   - picname
#          - output file
# Output:  part of device files
# Returns: (nothing)
# ---------------------------------------------------------
def list_config_memory(fp):
   fp.write("const word   _FUSES_CT             = " + "%d" % cfgvar["fusesize"] + "\n")
   if cfgvar["fusesize"] == 1:                    #  single word: only with baseline/midrange
      fp.write("const word   _FUSE_BASE            = 0x%X" % cfgvar["fuseaddr"] + "\n")
      fp.write("const word   _FUSES                = 0x%X" % cfgvar["fusedefault"][0] + "\n")
   else:
      if cfgvar["core"] != "16":
         fp.write("const word   _FUSE_BASE[_FUSES_CT] = { 0x%X" % cfgvar["fuseaddr"])
      else:
         fp.write("const byte*3 _FUSE_BASE[_FUSES_CT] = { 0x%X" % cfgvar["fuseaddr"])
      for i in range(cfgvar["fusesize"] - 1):
         fp.write(",\n" + " "*39 + "0x%X" % (cfgvar["fuseaddr"] + i + 1))
      fp.write(" }\n")
      if cfgvar["core"] != "16":
         fp.write("const word   _FUSES[_FUSES_CT]     = { 0x%04X," % (cfgvar["fusedefault"][0]) +
                  " "*10 + "-- CONFIG1\n")
         for i in range(cfgvar["fusesize"] - 2):
            fp.write(" "*39 + "0x%04X" % (cfgvar["fusedefault"][i + 1]) + "," +
                     " "*10 + "-- CONFIG" + "%d" % (i+2) + "\n")
         fp.write(" "*39 + "0x%04X" % (cfgvar["fusedefault"][-1]) + " }" +
                  " "*9 + "-- CONFIG" + "%d\n" % (cfgvar["fusesize"]))
      else:
         fp.write("const byte   _FUSES[_FUSES_CT]     = { 0x%02X," % (cfgvar["fusedefault"][0]) +
                  " "*10 + "-- CONFIG1L" + "\n")
         for i in range(cfgvar["fusesize"] - 2):
            fp.write(" "*39 + "0x%02X," % (cfgvar["fusedefault"][i + 1]) +
                     " "*10 + "-- CONFIG" + "%d" % ((i+3)/2) + "HL"[i%2] + "\n")
         fp.write(" "*39 + "0x%02X }" % (cfgvar["fusedefault"][-1]) +
                  " "*9 + "-- CONFIG" + "%d" % (cfgvar["fusesize"]/2) + "H\n")
   fp.write("--\n")



# ---------------------------------------------------------
# Title:   Generate oscillator calibration instructions
# Input:   - picname
#          - output file
# Output:  part of device files
# Returns: (nothing)
# Notes:   - Only for PICs with OSCCAL
#          - Only safe for 12-bits core
#          - Code for 14-bits core is present but disabled
# ---------------------------------------------------------
def list_osccal(fp):

   if cfgvar["osccal"] > 0:                                 # PIC has OSCCAL register
      if cfgvar["core"] == '12':                            # 10F2xx, some 12F5xx, 16f5xx
         fp.write("var volatile byte  __osccal  at  0x%x" % cfgvar["osccal"] + "\n")
         if cfgvar["numbanks"] > 1:
            fp.write("var volatile byte  __fsr     at  0x%x" % cfgvar["fsr"] + "\n")
            fp.write("asm          bcf   __fsr,5                  -- select bank 0\n")
            if cfgvar["numbanks"] > 2:
               fp.write("asm          bcf   __fsr,6                  --   \"     \"\n")
         fp.write("asm          movwf __osccal                 -- calibrate INTOSC\n")
         fp.write("--\n")
"""
      elif cfgvar["core"] == '14':                          # 12F629/675, 16F630/676
         fp.write("var  volatile byte  __osccal  at  0x%x" % cfgvar["osccal"] + "\n")
         fp.write("asm  page    call   0x%x" % (cfgvar["codesize"]-1) + " "*15 + "-- fetch calibration value\n")
         fp.write("asm  bank    movwf  __osccal            -- calibrate INTOSC\n")
         fp.write("--\n")
"""


# ---------------------------------------------------------
# Ttiel:   Generate declarations of special function registers, pins, etc.
# Input:   - output file
#          - root of .pic (xml parsed structure)
# Output:  part of device files
# Returns: (nothing)
# Notes:   - skip SFRs with 'ExtendedModeOnly' parent
# ---------------------------------------------------------
def list_all_sfr(fp, root):
   sfrdatasectors = root.getElementsByTagName("edc:SFRDataSector")
   for sfrdatasector in sfrdatasectors:
      if (sfrdatasector.parentNode.nodeName != "edc:ExtendedModeOnly"):
         sfraddr = eval(sfrdatasector.getAttribute("edc:beginaddr"))    # new start value
         if len(sfrdatasector.childNodes) > 0:
            child = sfrdatasector.firstChild
            sfraddr = list_sfrdata_child(fp, child, sfraddr)
            while child.nextSibling:
               child = child.nextSibling
               sfraddr = list_sfrdata_child(fp, child, sfraddr)


# ---------------------------------------------------------
# Title:   Generate declaration of a single SFR or a joined SFR with individual SFRs
# Input:   - output file
#          - SFRDef node
#          - current SFR addr
# Output:  part of device file
# Returns: (nothing)
# Notes:   -
# ---------------------------------------------------------
def list_sfrdata_child(fp, child, sfraddr):
   if child.nodeType == Node.ELEMENT_NODE:
      if child.hasAttribute("edc:cname"):
         if child.nodeName == "edc:SFRDef":
            list_sfr(fp, child, sfraddr)
         elif child.nodeName == "edc:JoinedSFRDef":
            reg = child.getAttribute("edc:cname")
            width = max(2, (eval(child.getAttribute("edc:nzwidth")) + 7) / 8)   # mplab-x bug
            list_separator(fp)
            list_variable(fp, reg, width, sfraddr)
            gchild = child.firstChild
            sfraddr_g = sfraddr
            if gchild.nodeName == "edc:SFRDef":
               list_sfr(fp, gchild, sfraddr)
               sfraddr_g = sfraddr_g + 1
            while gchild.nextSibling:
               gchild = gchild.nextSibling
               if gchild.nodeName == "edc:SFRDef":
                  list_sfr(fp, gchild, sfraddr_g)
                  sfraddr_g = sfraddr_g + 1
   return calc_sfraddr(child, sfraddr)                               # adjust for next child


# ---------------------------------------------------------
# Title:   Generate declaration of a single register (and its bitfields)
# Input:   - output file
#          - SFRDef node
#          - current SFR addr
# Output:  part of device files
# Returns: (nothing)
# ---------------------------------------------------------
def list_sfr(fp, sfr, sfraddr):
   list_separator(fp)
   sfrname = sfr.getAttribute("edc:cname")
   list_variable(fp, sfrname, 1, sfraddr)
   modelist = sfr.getElementsByTagName("edc:SFRMode")
   for mode in modelist:
      modeid = mode.getAttribute("edc:id")
      if modeid.startswith("DS.") | modeid.startswith("LT."):
         if len(mode.childNodes) > 0:
            child = mode.firstChild
            offset = list_sfr_child(fp, child, sfrname, 0)
            while child.nextSibling:
               child = child.nextSibling
               offset = list_sfr_child(fp, child, sfrname, offset)
   if sfrname in ("BSR",   "FSR",    "FSR0L",   "FSR0H",   "FSR1L",   "FSR1H",   \
                  "INDF",  "INDF0",  "PCL",     "PCLATH",  "PCLATU",  "STATUS",  \
                  "TBLAT", "TBLPTR", "TBLPTRH", "TBLPTRL", "TBLPTRU"):
      if (sfrname == "INDF") | (sfrname == "INDF0"):
         sfrname = "IND"                                       # compiler wants '_ind'
      list_variable(fp, "_" + sfrname.lower(), 1, sfraddr)     # compiler required name
      if sfrname == "STATUS":
         list_status_sfr(fp, sfr)                              # compiler required additions


# ---------------------------------------------------------
# Title:   Generate declaration of a register subfield
# Input:   - output file
#          - SFRDef child node
#          - SFR name
#          - field offset
# Output:
# Returns: offset next child
# Notes:   - bitfield
#          - some configuration info collected
# ---------------------------------------------------------
def list_sfr_child(fp, child, sfrname, offset):
   if child.nodeType == Node.ELEMENT_NODE:
      if child.nodeName == "edc:AdjustPoint":
         offset = offset + eval(child.getAttribute("edc:offset"))
      elif child.nodeName == "edc:SFRFieldDef":
         width = eval(child.getAttribute("edc:nzwidth"))
         fieldname = child.getAttribute("edc:cname")
         list_bitfield(fp, sfrname + "_" + fieldname, width, sfrname, offset)
         if (sfrname == "PORTA") & (fieldname == "RA3") & \
            (cfgvar["lata3_out"] == False):
            fp.write("--    pin_A3 input only\n")
         elif (sfrname == "PORTE") & (fieldname == "RE3") & \
            (cfgvar["late3_out"] == False):
            fp.write("--    pin_E3 input only\n")
         if sfrname.startswith("LAT") & (width == 1) & ("0" <= fieldname[-1] <= "7"):
            portletter = sfrname[-1]
            pinnumber = fieldname[-1]
            pin = "pin_" + portletter + pinnumber
            list_bitfield(fp, pin, 1, "PORT"+portletter, offset)
            list_pin_alias(fp, portletter+pinnumber, "PORT" + portletter)
         # collect some configuration info
         if sfrname[0:5] in ("ANSEL", "ADCON"):
            if fieldname == "ADCS":
               cfgvar["adcs_bits"] = width                    # width -> bits
            elif fieldname.startswith("ADCS")  &  fieldname[4:].isdigit():
               cfgvar["adcs_bits"] = int(fieldname[4:]) + 1   # (highest) offset + 1
         offset = offset + width
   return offset


# ----------------------------------------------------------------
# Title:   Procedure to generate pin alias declarations
# Input:   - file pointer
#          - name of bit (portletter||offset)
#          - PORT of alias
# Returns: index of alias (0 if none)
# Notes:   - declare alias definitions for all synonyms in pinmap.
#          - declare extra aliases for first of multiple I2C or SPI modules
#          - delaree extra aliases for TX and RX pins of only USART module
# ----------------------------------------------------------------
def list_pin_alias(fp, portbit, port):
   PICname = cfgvar["picname"].upper()
   if "R"+portbit in pinmap[PICname]:
      for alias in pinmap[PICname]["R"+portbit]:
         if alias.endswith("-"):
            alias = alias[:-1] + "_NEG"
         elif alias.endswith("+"):
            alias = alias[:-1] + "_POS"
         alias = "pin_" + alias
         list_alias(fp, alias, "pin_" + portbit)
#        if alias in ('pin_SDA1', 'pin_SDI1', 'pin_SDO1', 'pin_SCK1', \
#                     'pin_SCL1', 'pin_SS1', 'pin_TX1', 'pin_RX1'):
#           list_alias(fp, pinalias, pin)
   else:
      print "list_pin_alias()", portbit, "not in pinmap of", PICname


# -------------------------------------------------------
# Title:   List a line with an alias declaration
# Input:   - name of original variable (or other alias)
#          - name of alias
# Returns: - returncode of duplicate_name()
# -------------------------------------------------------
def list_alias(fp, alias, original):
   if original != "":
      fp.write("%-19s %-25s is %s\n" % ("alias", alias, original))


# -------------------------------------------------------
# Title:   Generate a line with a volatile variable
# Input:   - name
#          - width (in bytes)
#          - address (decimal)   ??? maybe string ???
# Returns: nothing
# -------------------------------------------------------
def list_variable(fp, var, width, addr):
   global names
   if var in names:
      print "   Duplicate name:", var
   else:
      names.append(var)
   if width == 1:
      type = "byte"
   elif width == 2:
      type = "word"
   else:
      type = "byte*%d" % width
   fp.write("var volatile %-6s %-25s at { " % (type, var))
   if (cfgvar["core"] == "14H") & (addr < 0xC):
      fp.write("0x%X" % sfrranges[addr][0])
   else:
      fp.write(", ".join(["0x%X" % x for x in sfrranges[addr]]))
   fp.write(" }\n")



# -------------------------------------------------------
# Title:   Generate a line with a volatile variable
# Input:   - type (byte, word, etc.)
#          - name
#          - address (decimal or string)
# Returns: nothing
# Notes:   Fields if 8 bits (or larger) are not declared
# -------------------------------------------------------
def list_bitfield(fp, var, width, reg, offset):
   if not var.startswith("pin_"):
      bitfieldname = var.upper()
   else:
      bitfieldname = var
   if bitfieldname in names:
      print "   Duplicate name:", bitfieldname
   else:
      if reg.endswith("_SHAD") & bitfieldname.endswith("_SHAD"):
         bitfieldname = bitfieldname[:-5]                # remove trailing "_SHAD"
      names.append(bitfieldname)
   if width == 1:
      fp.write("var volatile bit    %-25s at %s : %d\n" % (bitfieldname, reg, offset))
   elif width < 8:
      fp.write("var volatile bit*%d  %-25s at %s : %d\n" % (width, bitfieldname, reg, offset))


# -----------------------------------------------------
# Title:  list status register
# input:  - file pointer.
#         - node of status sfr
# Note:
# -----------------------------------------------------
def list_status_sfr(fp, status):
   modes = status.getElementsByTagName("edc:SFRMode")
   for mode in modes:
      offset = 0
      bitfield = mode.firstChild
      offset = list_status_field(fp, bitfield, offset)
      while bitfield.nextSibling:
         bitfield = bitfield.nextSibling
         offset = list_status_field(fp, bitfield, offset)
   if cfgvar["core"] == "16":
      fp.write("const        byte   _banked %24s" % "=  1\n")
      fp.write("const        byte   _access %24s" % "=  0\n")


# -----------------------------------------------------
# Title: list status register subfields
# input: - start index in pic.
# Note:  - name is stored but not checked on duplicates
# -----------------------------------------------------
def list_status_field(fp, field, offset):
   if field.nodeType == Node.ELEMENT_NODE:
      if field.nodeName == "edc:AdjustPoint":
         offset = offset + eval(field.getAttribute("edc:offset"))
      elif field.nodeName == "edc:SFRFieldDef":
         fieldname = field.getAttribute("edc:cname").lower()
         width = eval(field.getAttribute("edc:nzwidth"))
         if width == 1:
            if fieldname == "nto":
               fp.write("const        byte   %-25s =  %d\n" % ("_not_to", offset))
            elif fieldname == "npd":
               fp.write("const        byte   %-25s =  %d\n" % ("_not_pd", offset))
            else:
               fp.write("const        byte   %-25s =  %d\n" % ("_" + fieldname, offset))
         offset = offset + width
   return offset


# ---------------------------------------------------------
# Title:   Generate instructions to set all I/O to digital mode
# Input:   - picname
#          - output file
# Output:  part of device files
# Returns: (nothing)
# ---------------------------------------------------------
def list_digital_io(fp, picname):
   fp.write("--\n")
   list_separator(fp)
   fp.write("-- Procedures to disable analog functions\n")
   list_separator(fp)
   fp.write("\n")

   picdata = dict(devspec[picname.upper()].items())         # pic specific info

   if "ADCGROUP" not in picdata:                            # no ADC group specified
      if (("ADCON" in names) | ("ADCON0" in names) | ("ADCON1" in names)):
         print "   Has ADCONx register, but no ADCgroup found in devicespecific.json"
      ADC_group = '0'                                       # no ADC module
      ADC_res = '0'                                         # # bits
   else:                                                    # ADC group specified
      ADC_group = picdata["ADCGROUP"]
      if "ADCMAXRESOLUTION" not in picdata:                 # # bits not specified
         if (cfgvar["adc_highres"] == False) & (cfgvar["core"] != '16'):    # base/mid range without ADRESH
            ADC_res = '8'
         else:
            ADC_res = '10'                                  # default max res
      else:
         ADC_res = picdata["ADCMAXRESOLUTION"]              # specified ADC resolution

#  if ("ANCOUNT" not in picdata) | (ADC_group == '0'):       # PIC has no ADC module
#     PinMap.PicNameCaps.ANCOUNT = 0

   fp.write("const      ADC_GROUP          = " + ADC_group)
   if ADC_group == '0':
      fp.write("        -- no ADC module present")
   fp.write("\n")
#  fp.write("const byte ADC_NTOTAL_CHANNEL = " + PinMap["ANCOUNT"] + "\n")
   fp.write("const byte ADC_ADCS_BITCOUNT  = " + "%d" % cfgvar["adcs_bits"] + "\n")
   fp.write("const byte ADC_MAX_RESOLUTION = " + ADC_res + "\n")
   fp.write("--\n")

#  if ((ADC_group == '0'  &  picdata["PinMap.PicNameCaps.ANCOUNT > 0) |,
#      (ADC_group \= '0' & PinMap.PicNameCaps.ANCOUNT = 0)):
#     print "   Possible conflict between ADC-group (" + ADC_group + ") " \
#           "and number of ADC channels (" + PinMap.PicNameCaps.ANCOUNT + ")\n")

   analog = []                                              # list of analog component names

   if (("ANSEL"  in names) | \
       ("ANSEL1" in names) | \
       ("ANSELA" in names) | \
       ("ANSELC" in names) | \
       ("ANCON0" in names) | \
       ("ANCON1" in names)):
      analog.append("ANSEL")                                # analog functions present
      fp.write("-- - - - - - - - - - - - - - - - - - - - - - - - - - -\n")
      fp.write("-- Change analog I/O pins into digital I/O pins.\n")
      fp.write("procedure analog_off() is\n")
      fp.write("   pragma inline\n")

      if "ANSEL" in names:
         fp.write("   ANSEL  = 0b0000_0000\n")
      for i in range(10):                                   # ANSEL0..ANSEL9
         qname = "ANSEL" + str(i)
         if qname in names:
            fp.write("   " + qname + " = 0b0000_0000\n")
      caps = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      for i in range(len(caps)):                            # ANSELA..Z
         qname = "ANSEL" + caps[i]                          # qualified name
         if qname in names:
            fp.write("   " + qname + " = 0b0000_0000\n")
      for i in range(10):                                   # ANCON0..ANCON9
         qname = 'ANCON' + str(i)
         if qname in names:
            bitname = "$$$"
            for j in range(0, 8 * i + 8):                   # all PCFG bits
               bitname = qname + "_PCFG" + str(j)
               if  bitname in names:                        # ANCONi has a PCFG bit
                  fp.write("   " + qname + " = 0b1111_1111\n")
                  break
            if bitname not in names:                        # ANCONi has no PCFG bit
               for j in range(0, 8 * i + 8):            # try ANSEL bits
                  bitname = qname + "_ANSEL" + str(j)       # ANSEL bit
                  if bitname in names:                      # ANCONi has ANSEL bit(s)
                     fp.write("   " + qname + " = 0b0000_0000\n")
                     break
      fp.write("end procedure\n")
      fp.write("--\n")

   if ("ADCON0" in names) | \
      ("ADCON" in names):
      analog.append("ADC")                                    # ADC module(s) present
      fp.write("-- - - - - - - - - - - - - - - - - - - - - - - - - - -\n")
      fp.write("-- Disable ADC module\n")
      fp.write("procedure adc_off() is\n")
      fp.write("   pragma inline\n")
      if "ADCON0" in names:
         fp.write("   ADCON0 = 0b0000_0000\n")
      else:
         fp.write("   ADCON  = 0b0000_0000\n")
      if "ADCON1" in names:
         if (picdata["ADCGROUP"] == "ADC_V1"):
            fp.write("   ADCON1 = 0b0000_0111         -- digital I/O\n")
         elif picdata["ADCGROUP"] in ("ADC_V2", "ADC_V4", "ADC_V5", "ADC_V6", "ADC_V12"):
            fp.write("   ADCON1 = 0b0000_1111\n")
         elif (picdata["ADCGROUP"] == "ADC_V3"):
            fp.write("   ADCON1 = 0b0111_1111\n")
         else:
            fp.write("   ADCON1 = 0b0000_0000\n")
            if ("ADCON1_PCFG" in names):
               print "ADCON1_PCFG field present: PIC maybe in wrong ADC_GROUP"
         if "ADCON2" in names:
            fp.write("   ADCON2 = 0b0000_0000\n")    # all groups
      fp.write("end procedure\n")
      fp.write("--\n")

   if ("CMCON"   in names) | \
      ("CMCON0"  in names) | \
      ("CM1CON"  in names) | \
      ("CM1CON0" in names) | \
      ("CM1CON1" in names):
      analog.append("COMPARATOR")                              # Comparator(s) present
      fp.write("-- - - - - - - - - - - - - - - - - - - - - - - - - - -\n")
      fp.write("-- Disable comparator module\n")
      fp.write("procedure comparator_off() is\n")
      fp.write("   pragma inline\n")
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
      elif "CM1CON0" in names:
         fp.write("   CM1CON0 = 0b0000_0000\n")
         if "CM1CON1" in names:
            fp.write("   CM1CON1 = 0b0000_0000\n")
         if "CM2CON0" in names:
            fp.write("   CM2CON0 = 0b0000_0000\n")
            if "CM2CON1" in names:
               fp.write("   CM2CON1 = 0b0000_0000\n")
         if "CM3CON0" in names:
            fp.write("   CM3CON0 = 0b0000_0000\n")
            if "CM3CON1" in names:
               fp.write("   CM3CON1 = 0b0000_0000\n")
      elif "CM1CON1" in names:
         fp.write("   CM1CON1 = 0b0000_0000\n")
         if "CM2CON1" in names:
            fp.write("   CM2CON1 = 0b0000_0000\n")
      fp.write("end procedure\n")
      fp.write("--\n")

   fp.write("-- - - - - - - - - - - - - - - - - - - - - - - - - - -\n")
   fp.write("-- Switch analog ports to digital mode when analog module(s) present.\n")
   fp.write("procedure enable_digital_io() is\n")
   fp.write("   pragma inline\n")
   if "ANSEL" in analog:
      fp.write("   analog_off()\n")
   if "ADC" in analog:
      fp.write("   adc_off()\n")
   if "COMPARATOR" in analog:
      fp.write("   comparator_off()\n")
   if cfgvar["core"] == "12":                                # baseline PIC
      fp.write("   OPTION_REG_T0CS = OFF        -- T0CKI pin input + output\n")
   fp.write("end procedure\n")


# ---------------------------------------------------------
# Title:   Generate miscellaneous information
# Input:   - picname
#          - output file
# Output:  part of device files
# Returns: (nothing)
# ---------------------------------------------------------
def list_miscellaneous(fp, picname):
   fp.write("--\n")
   list_separator(fp)
   fp.write("--    Miscellaneous information\n")
   list_separator(fp)

   fp.write("--\n")
   picdata = dict(devspec[picname.upper()].items())
   if "PPSGROUP" in picdata:                                # PPS group specified
      fp.write("const PPS_GROUP             = " + picdata["PPSGROUP"] + \
               "       -- PPS group " + picdata["PPSGROUP"][-1] + "\n")
   else:
      fp.write("const PPS_GROUP             = PPS_0" + \
               "       -- no Peripheral Pin Selection\n")

   if "UCON" in names:                                      # USB control register present
      fp.write("--\n")
      if "USBBDT" in picdata:
         fp.write("const word USB_BDT_ADDRESS  = 0x" + picdata["USBBDT"] + "\n")
      else:
         print "   Has USB module but USB_BDT_ADDRESS not specified"

   fp.write("--\n")
   sharedmem_avail = sharedmem[1] - sharedmem[0]
   if (sharedmem_avail > 0):
      fp.write("-- Free shared memory: 0x%X" % sharedmem[0])
      if (sharedmem_avail > 1):
         fp.write("-0x%X" % sharedmem[1])
      fp.write("\n")
   else:
      fp.write("-- No free shared memory!\n")


# ---------------------------------------------------------
# Tile:    Generate all fuse_def statements
# Input:   - picname
#          - output file
# Output:  part of device files
# Returns: (nothing)
# ---------------------------------------------------------
def list_fuse_defs(fp, root):
   fp.write("--\n")
   list_separator(fp)
   fp.write("--    Symbolic Fuse Definitions\n")
   list_separator(fp)
   configfusesectors = root.getElementsByTagName("edc:ConfigFuseSector")
   if len(configfusesectors) == 0:
      configfusesectors = root.getElementsByTagName("edc:WORMHoleSector")
   for configfusesector in configfusesectors:
      dcraddr = eval(configfusesector.getAttribute("edc:beginaddr"))    # start address
      if len(configfusesector.childNodes) > 0:
         dcrdef = configfusesector.firstChild
         dcraddr = list_dcrdef(fp, dcrdef, dcraddr)
         while dcrdef.nextSibling:
            dcrdef = dcrdef.nextSibling
            dcraddr = list_dcrdef(fp, dcrdef, dcraddr)


# ---------------------------------------------------------
# Title:   Generate declaration of a configuration byte/word, incl subfields
# Input:   - output file
#          - config fuse sector node
#          - current config address
# Output:  part of device file
# Returns: config fuse address (updated if applicable)
# ---------------------------------------------------------
def list_dcrdef(fp, dcrdef, addr):
   if dcrdef.nodeName == "edc:AdjustPoint":
      addr = addr + eval(dcrdef.getAttribute("edc:offset"))
   elif dcrdef.nodeName == "edc:DCRDef":
      dcrname = dcrdef.getAttribute("edc:cname")
      fp.write("--\n")
      fp.write("-- %s (0x%X)\n" % (dcrname, addr))
      fp.write("--\n")
      dcrmodes = dcrdef.getElementsByTagName("edc:DCRMode")
      for dcrmode in dcrmodes:
         if dcrmode.nodeType == Node.ELEMENT_NODE:
            if len(dcrmode.childNodes) > 0:
               offset = 0
               dcrfielddef = dcrmode.firstChild
               offset = list_dcrfielddef(fp, dcrfielddef, addr - cfgvar["fuseaddr"], offset)
               while dcrfielddef.nextSibling:
                  dcrfielddef = dcrfielddef.nextSibling
                  offset = list_dcrfielddef(fp, dcrfielddef, addr - cfgvar["fuseaddr"], offset)
      addr = addr + 1
   return addr


# ---------------------------------------------------------
# Title:   Generate declaration of a configuration byte/word, incl subfields
# Input:   - output file
#          - config fuse sector node
#          - current config address
# Output:  part of device file
# Returns: config fuse address (updated if applicable)
# ---------------------------------------------------------
def list_dcrfielddef(fp, dcrfielddef, index, offset):
   if dcrfielddef.nodeName == "edc:AdjustPoint":
      offset = offset + eval(dcrfielddef.getAttribute("edc:offset"))
   elif dcrfielddef.nodeName == "edc:DCRFieldDef":
      width = eval(dcrfielddef.getAttribute("edc:nzwidth"))
      if dcrfielddef.hasAttribute("edc:ishidden") == False:          # do not list hidden fields
         name = dcrfielddef.getAttribute("edc:cname").upper()
         name = normalize_fusedef_key(name)
         mask = eval(dcrfielddef.getAttribute("edc:mask"))
         str = "pragma fuse_def " + name
         if cfgvar["fusesize"] > 1:
            str = str + ":%d " % (index)
         str = str + " 0x%X {" % (mask << offset)                    # position in byte!
         fp.write("%-40s -- %s\n" % (str, dcrfielddef.getAttribute("edc:desc")))
         list_dcrfieldsem(fp, dcrfielddef, offset)
         fp.write("       }\n")
      offset = offset + width
   return offset


# ---------------------------------------------------------
# Title:   Generate declaration of a dcrdeffield semantics
# Input:   - output file
#          - SFRDef child node
#          - SFRe
#          - field offset
# Output:
# Returns: offset next child
# Notes:   - bitfield
# ---------------------------------------------------------
def list_dcrfieldsem(fp, dcrfielddef, offset):
   for child in dcrfielddef.childNodes:
      if child.nodeName == "edc:DCRFieldSemantic":
         if child.hasAttribute("edc:cname"):
            fieldname = child.getAttribute("edc:cname").upper()
            if (fieldname != "RESERVED") & (fieldname != ""):
               if (dcrfielddef.hasAttribute("edc:islanghidden") == False):
                  if (dcrfielddef.getAttribute("edc:cname") == "FOSC") | \
                     (dcrfielddef.getAttribute("edc:cname") == "OSC"):
                     if fieldname in fusedef_osc:
   #                    print "renamed", fieldname, "to", fusedef_osc[fieldname]
                        fieldname = fusedef_osc[fieldname]
                     else:
                        print "  Missing <", fieldname, "> as key in fusedef_osc"
                  when = child.getAttribute("edc:when").split()
                  desc = child.getAttribute("edc:desc")
                  str = "       " + fieldname + " = " + "0x%X" % (eval(when[-1])<<offset)
                  fp.write("%-40s -- %s\n" % (str, desc))


# ----------------------------------------------------
# Title:   Normalize fusedef keywords
# Input:   - keyword
# Returns: - normalized keyword
# ----------------------------------------------------
def normalize_fusedef_key(key):

   if key == "":
      return key

   if (key in ("RES", "RES1")) | key.startswith("RESERVED"):
      return key

   if key.find("ENICPORT") >= 0:
      return key

   picname = cfgvar["picname"]

   if (key in ("CPD", "WRTD"))  & \
      (picname in ("18f2410", "18f2510", "18f2515", "18f2610", \
                   "18f4410", "18f4510"  "18f4515"  "18f4610")):
      return key

   if (key in ("EBTR_3", "CP_3", "WRT_3")) & (picname == "18f4585"):
      return key

   if (key in ("EBTR_4", "CP_4", "WRT_4", \
               "EBTR_5", "CP_5", "WRT_5", \
               "EBTR_6", "CP_6", "WRT_6", \
               "EBTR_7", "CP_7", "WRT_7"))   & \
       (picname in ("18f6520", "18f8520")):
      return key

   if key.startswith("CCP") & key.endswith("MX"):
      key = key[:-2] + "MUX"                          # CCP(x)MX -> CCP(x)MUX
      if key == "CCPMUX":
         key = "CCP1MUX"                              # compatibility
      return key

   if key.startswith("CP_")  &  key[3:].isdigit():
      return "CP" + key[3:]                           # remove underscore

   if key.startswith("EBRT"):                         # typo MPLAB-X!
      return "EBTR" + key[4:]

   if key.startswith("EBTR_")  &  key[5:].isdigit():
      return "EBTR" + key[5:]

   if key.startswith("WRT_")  &  key[4:].isdigit():
      return "WRT" + key[5:]

   if key in fusedef_kwd:
      return fusedef_kwd[key]

   return key                                         # no match: return unchanged


# -------------------------------------------------------
# Title:   Generate a separator line
# Input:   file pointer
# Returns:  nothing
# -------------------------------------------------------
def list_separator(fp):
   fp.write("-- " + "-"*65 + "\n")


# -----------------------------------------------------
# Title:   Initialize dictionary 'fusedef_osc' (mapping .pic -> .jal of OSC keyword)
# Input:   nothing
# Output:  fusedef_osc dictionary initialized
# Returns: nothing
# -----------------------------------------------------
def init_fusedef_mapping():

   global fusedef_osc

   fusedef_osc = {"EC"             : "EC_CLKOUT",
                  "EC1"            : "ECL_NOCLKOUT",
                  "EC1IO"          : "ECL_CLKOUT",
                  "EC2"            : "ECM_NOCLKOUT",
                  "EC2IO"          : "ECM_CLKOUT",
                  "EC3"            : "ECH_NOCLKOUT",
                  "EC3IO"          : "ECH_CLKOUT",
                  "ECCLK"          : "EC_CLKOUT",
                  "ECCLKOUTH"      : "ECH_CLKOUT",
                  "ECCLKOUTL"      : "ECL_CLKOUT",
                  "ECCLKOUTM"      : "ECM_CLKOUT",
                  "ECH"            : "ECH_NOCLKOUT",
                  "ECHCLKO"        : "ECH_CLKOUT",
                  "ECHIO"          : "ECH_NOCLKOUT",
                  "ECHP"           : "ECH_CLKOUT",
                  "ECHPIO6"        : "ECH_NOCLKOUT",
                  "ECIO"           : "EC_NOCLKOUT",
                  "ECIO6"          : "EC_NOCLKOUT",
                  "ECIOPLL"        : "EC_NOCLKOUT_PLL_HW",
                  "ECIOSWPLL"      : "EC_NOCLKOUT_PLL_SW",
                  "ECIO_EC"        : "EC_NOCLKOUT",
                  "ECL"            : "ECL_NOCLKOUT",
                  "ECLCLKO"        : "ECL_CLKOUT",
                  "ECLIO"          : "ECL_NOCLKOUT",
                  "ECLP"           : "ECL_CLKOUT",
                  "ECLPIO6"        : "ECL_NOCLKOUT",
                  "ECM"            : "ECM_NOCLKOUT",
                  "ECMCLKO"        : "ECM_CLKOUT",
                  "ECMIO"          : "ECM_NOCLKOUT",
                  "ECMP"           : "ECM_CLKOUT",
                  "ECMPIO6"        : "ECM_NOCLKOUT",
                  "ECPLL"          : "EC_CLKOUT_PLL",
                  "ECPLLIO_EC"     : "EC_NOCLKOUT_PLL",
                  "ECPLL_EC"       : "EC_CLKOUT_PLL",
                  "EC_EC"          : "EC_CLKOUT",
                  "EC_OSC"         : "EC_NOCLKOUT",
                  "ERC"            : "RC_NOCLKOUT",
                  "ERCCLKOUT"      : "RC_CLKOUT",
                  "ERCLK"          : "RC_CLKOUT",
                  "ERIO"           : "RC_NOCLKOUT",
                  "EXTRC"          : "RC_NOCLKOUT",
                  "EXTRCCLK"       : "RC_CLKOUT",
                  "EXTRCIO"        : "RC_NOCLKOUT",
                  "EXTRC_CLKOUT"   : "RC_CLKOUT",
                  "EXTRC_CLKOUTEN" : "RC_CLKOUT",
                  "EXTRC_IO"       : "RC_NOCLKOUT",
                  "EXTRC_NOCLKOUT" : "RC_NOCLKOUT",
                  "EXTRC_RB4"      : "RC_NOCLKOUT",
                  "EXTRC_RB4EN"    : "RC_NOCLKOUT",
                  "FRC"            : "INTOSC_NOCLKOUT",
                  "FRC500KHZ"      : "INTOSC_500KHZ",
                  "FRCDIV"         : "INTOSC_DIV",
                  "FRCPLL"         : "INTOSC_NOCLKOUT_PLL",
                  "HS"             : "HS",
                  "HS1"            : "HSM",
                  "HS2"            : "HSH",
                  "HSH"            : "HSH",
                  "HSHP"           : "HSH",
                  "HSM"            : "HSM",
                  "HSMP"           : "HSM",
                  "HSPLL"          : "HS_PLL",
                  "HSPLL_HS"       : "HS_PLL",
                  "HSSWPLL"        : "HS_PLL_SW",
                  "HS_OSC"         : "HS",
                  "INT"            : "INTOSC_NOCLKOUT",
                  "INTIO1"         : "INTOSC_CLKOUT",
                  "INTIO2"         : "INTOSC_NOCLKOUT",
                  "INTIO67"        : "INTOSC_NOCLKOUT",
                  "INTIO7"         : "INTOSC_CLKOUT",
                  "INTOSC"         : "INTOSC_NOCLKOUT",
                  "INTOSCCLK"      : "INTOSC_CLKOUT",
                  "INTOSCCLKO"     : "INTOSC_CLKOUT",
                  "INTOSCIO"       : "INTOSC_NOCLKOUT",
                  "INTOSCIO_EC"    : "INTOSC_NOCLKOUT_USB_EC",
                  "INTOSCO"        : "INTOSC_CLKOUT",
                  "INTOSCPLL"      : "INTOSC_NOCLKOUT_PLL",
                  "INTOSCPLLO"     : "INTOSC_CLKOUT_PLL",
                  "INTOSC_EC"      : "INTOSC_CLKOUT_USB_EC",
                  "INTOSC_HS"      : "INTOSC_NOCLKOUT_USB_HS",
                  "INTOSC_XT"      : "INTOSC_NOCLKOUT_USB_XT",
                  "INTRC"          : "INTOSC_NOCLKOUT",
                  "INTRCCLK"       : "INTOSC_CLKOUT",
                  "INTRCIO"        : "INTOSC_NOCLKOUT",
                  "INTRC_CLKOUT"   : "INTOSC_CLKOUT",
                  "INTRC_CLKOUTEN" : "INTOSC_CLKOUT",
                  "INTRC_IO"       : "INTOSC_NOCLKOUT",
                  "INTRC_NOCLKOUT" : "INTOSC_NOCLKOUT",
                  "INTRC_RB4"      : "INTOSC_NOCLKOUT",
                  "INTRC_RB4EN"    : "INTOSC_NOCLKOUT",
                  "IRC"            : "INTOSC_CLKOUT",
                  "IRCCLKOUT"      : "INTOSC_CLKOUT",
                  "IRCIO"          : "INTOSC_NOCLKOUT",
                  "IRCIO67"        : "INTOSC_NOCLKOUT",
                  "IRCIO7"         : "INTOSC_CLKOUT",
                  "LP"             : "LP",
                  "LPRC"           : "INTOSC_LP",
                  "LP_OSC"         : "LP",
                  "PRI"            : "PRI",
                  "PRIPLL"         : "PRI_PLL",
                  "RC"             : "RC_CLKOUT",
                  "RC1"            : "RC_CLKOUT",
                  "RC2"            : "RC_CLKOUT",
                  "RCCLKO"         : "RC_CLKOUT",
                  "RCIO"           : "RC_NOCLKOUT",
                  "RCIO6"          : "RC_NOCLKOUT",
                  "SOSC"           : "SEC",
                  "XT"             : "XT",
                  "XTPLL_XT"       : "XT_PLL",
                  "XT_OSC"         : "XT",
                  "XT_XT"          : "XT"}

   global fusedef_kwd

   fusedef_kwd = {"ADDRBW"    : "ABW",
                  "BACKBUG"   : "DEBUG",
                  "BKBUG"     : "DEBUG",
                  "BBSIZ0"    : "BBSIZ",
                  "BODENV"    : "VOLTAGE",
                  "BOR4V"     : "VOLTAGE",
                  "BORV"      : "VOLTAGE",
                  "BODEN"     : "BROWNOUT",
                  "BOREN"     : "BROWNOUT",
                  "DSBOREN"   : "BROWNOUT",
                  "BOD"       : "BROWNOUT",
                  "BOR"       : "BROWNOUT",
                  "CANMX"     : "CANMUX",
                  "CLKOEN"    : "CLKOUTEN",
                  "CPDF"      : "CPD",
                  "CPSW"      : "CPD",
                  "DATABW"    : "BW",
                  "ECCPMX"    : "ECCPMUX",
                  "ECCPXM"    : "ECCPMUX",
                  "EXCLKMX"   : "EXCLKMUX",
                  "FLTAMX"    : "FLTAMUX",
                  "FOSC"      : "OSC",
                  "FOSC0"     : "OSC",
                  "FEXTOSC"   : "OSC",
                  "FSCKM"     : "FCMEN",
                  "FSCM"      : "FCMEN",
                  "MCLRE"     : "MCLR",
                  "MSSP7B_EN" : "MSSPMASK",
                  "MSSPMSK"   : "MSSPMASK",
                  "P2BMX"     : "P2BMUX",
                  "PLL_EN"    : "PLLEN",
                  "CFGPLLEN"  : "PLLEN",
                  "PLLCFG"    : "PLLEN",
                  "MODE"      : "PMODE",
                  "PM"        : "PMODE",
                  "PMPMX"     : "PMPMUX",
                  "PWM4MX"    : "PWM4MUX",
                  "PUT"       : "PWRTE",
                  "PWRT"      : "PWRTE",
                  "PWRTEN"    : "PWRTE",
                  "NPWRTE"    : "PWRTE",
                  "NPWRTEN"   : "PWRTE",
                  "RTCSOSC"   : "RTCOSC",
                  "SDOMX"     : "SDOMUX",
                  "SOSCEL"    : "SOSCSEL",
                  "SSPMX"     : "SSPMUX",
                  "STVREN"    : "STVR",
                  "T0CKMX"    : "T0CKMUX",
                  "T1OSCMX"   : "T1OSCMUX",
                  "T3CKMX"    : "T3CKMUX",
                  "T3CMX"     : "T3CKMUX",
                  "WDTEN"     : "WDT",
                  "WDTE"      : "WDT",
                  "WDPS"      : "WDTPS",
                  "WRT_ENABLE": "WRT",
                  "WRTEN"     : "WRT" }


# ---------------------------------------------------------
#Title:    Calculate next SFRaddr with current Node
# Input:   - Node
#          - current SFR address (decimal)
# Output:  (nothing)
# Returns: new SFR address (decimal)
# ---------------------------------------------------------
def calc_sfraddr(child, sfraddr):
   global sfrranges
   if child.nodeName == "edc:SFRDef":
      if sfraddr in sfrranges:
         if sfraddr not in sfrranges[sfraddr]:
            sfrranges[sfraddr].append(sfraddr)
      else:
         sfrranges[sfraddr] = [sfraddr]
      sfraddr = sfraddr + 1
   elif child.nodeName == "edc:AdjustPoint":
      sfraddr = sfraddr + eval(child.getAttribute("edc:offset"))
   elif child.nodeName == "edc:Mirror":
      base = sfraddr % cfgvar["banksize"] + \
             eval(child.getAttribute("edc:regionidref")[-1]) * cfgvar["banksize"]
      for i in range(eval(child.getAttribute("edc:nzsize"))):
         if (base + i) in sfrranges:
            if sfraddr not in sfrranges[base + i]:
               sfrranges[base + i].append(sfraddr + i)
         else:
            sfrranges[base + i] = [sfraddr + i]
      sfraddr = sfraddr + eval(child.getAttribute("edc:nzsize"))
   elif child.nodeName == "edc:MuxedSFRDef":
      sfraddr = sfraddr + (eval(child.getAttribute("edc:nzwidth")) + 7) / 8    # bits -> bytes, rounded
   elif child.nodeName == "edc:JoinedSFRDef":
      width = max(2, (eval(child.getAttribute("edc:nzwidth")) + 7) / 8)        # circumvent mplab-x bugs
      for i in range(width):
         if (sfraddr + i) in sfrranges:
            if (sfraddr + i)  not in sfrranges[sfraddr + i]:
               sfrranges[sfraddr+i].append(sfraddr+i)
         else:
            sfrranges[sfraddr+i] = [sfraddr+i]
      sfraddr = sfraddr + width
   return sfraddr


# ---------------------------------------------------------
# Title:   Compact address ranges
# Input:   list of pairs of address ranges
# Output:  (nothing)
# Returns: compacted list of pairs of address ranges
# ---------------------------------------------------------
def compact_address_range(r):
   x = list(r[:])
   x.sort()
   j = 0
   y = []
   y.append(list(x[0]))
   for i in range(len(x) - 1):
      if x[i][-1] == x[i+1][0]:
         y[j][-1] = x[i+1][-1]
      else:
         y.append(list(x[i+1]))
         j = j + 1
   return y


# ---------------------------------------------------------
# Title:   Collect PIC various configuration data
# Input:   - 'pic' xml structure
#          - picname
# Output:  fills 'cfgvar' dictionary
# Returns: (nothing)
# Notes:   - JalV2 compiler supports for 12- and 14-bits core only 4 memory banks
#          - Fuse defaults are set fo baseline and (extended) midrange
#            for 16-bits core the defaults are collected from the.pic file.
# ---------------------------------------------------------
def collect_config_info(root, picname):

   global cfgvar
   global names

   cfgvar.clear()                                        # empty dict. of config variables
   cfgvar["picname"] = picname
   cfgvar["adc_highres"] = False                         # no high resolution ADC
   cfgvar["adcs_bits"] = 0                               # adcs bits in ANSEL/ANCON
   cfgvar["devid"] = 0                                   # no devID
   cfgvar["haslat"] = False                              # no LATx register
   cfgvar["lata3_out"] = False                           # True: LATA_RA3 bit output capable
   cfgvar["late3_out"] = False                           #
   cfgvar["numbanks"] = 1                                # RAM banks
   cfgvar["osccal"] = 0                                  # no OSCCAL

   pic = root.getElementsByTagName("edc:PIC")
   cfgvar["arch"]   = pic[0].getAttribute("edc:arch")
   if cfgvar["arch"]    == "16c5x":
      cfgvar["core"]     = "12"
      cfgvar["maxram"]   = 128
      cfgvar["banksize"] = 32
      cfgvar["pagesize"] = 512
   elif cfgvar["arch"]  == "16xxxx":
      cfgvar["core"]     = "14"
      cfgvar["maxram"]   = 512
      cfgvar["banksize"] = 128
      cfgvar["pagesize"] = 2048
   elif cfgvar["arch"]  == "16Exxx":
      cfgvar["core"]     = "14H"
      cfgvar["maxram"]   =  4096
      cfgvar["banksize"] = 128
      cfgvar["pagesize"] = 2048
   elif cfgvar["arch"]  == "18xxxx":
      cfgvar["core"]     = "16"
      cfgvar["maxram"]   = 4096
      cfgvar["banksize"] = 256
      cfgvar["pagesize"] = 0                             # no pages!
   else:
      print "   undetermined core : ", cfgvar["arch"]
   cfgvar["procid"] = eval(pic[0].getAttribute("edc:procid"))      # first (only) 'PIC' node
   cfgvar["dsid"]   = pic[0].getAttribute("edc:dsid")

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
   cfgvar["hwstack"]  = eval(memtraits[0].getAttribute("edc:hwstackdepth"))

   pgmspace = root.getElementsByTagName("edc:ProgramSpace")
   codesectors = pgmspace[0].getElementsByTagName("edc:CodeSector")
   codesize = 0
   for codesector in codesectors:
      codesize = codesize + eval(codesector.getAttribute("edc:endaddr")) - \
                            eval(codesector.getAttribute("edc:beginaddr"))
   cfgvar["codesize"] = codesize
   useridsectors = pgmspace[0].getElementsByTagName("edc:UserIDSector")
   if len(useridsectors) > 0:
      cfgvar["idaddr"] = eval(useridsectors[0].getAttribute("edc:beginaddr"))
      cfgvar["idsize"] = eval(useridsectors[0].getAttribute("edc:endaddr")) - \
                         eval(useridsectors[0].getAttribute("edc:beginaddr"))
   eedatasectors = pgmspace[0].getElementsByTagName("edc:EEDataSector")
   if len(eedatasectors) > 0:
      cfgvar["eeaddr"] = eval(eedatasectors[0].getAttribute("edc:beginaddr"))
      cfgvar["eesize"] = eval(eedatasectors[0].getAttribute("edc:endaddr")) - \
                         eval(eedatasectors[0].getAttribute("edc:beginaddr"))
   flashdatasectors = pgmspace[0].getElementsByTagName("edc:FlashDataSector")
   if len(flashdatasectors) > 0:
      cfgvar["eeaddr"] = eval(flashdatasectors[0].getAttribute("edc:beginaddr"))
      cfgvar["eesize"] = eval(flashdatasectors[0].getAttribute("edc:endaddr")) - \
                         eval(flashdatasectors[0].getAttribute("edc:beginaddr"))
   devidsectors = pgmspace[0].getElementsByTagName("edc:DeviceIDSector")
   if len(devidsectors) > 0:
      cfgvar["devid"] = eval(devidsectors[0].getAttribute("edc:value"))
   configfusesectors = pgmspace[0].getElementsByTagName("edc:ConfigFuseSector")
   if len(configfusesectors) > 0:
      cfgvar["fuseaddr"] = eval(configfusesectors[0].getAttribute("edc:beginaddr"))
      cfgvar["fusesize"] = eval(configfusesectors[0].getAttribute("edc:endaddr")) - \
                           eval(configfusesectors[0].getAttribute("edc:beginaddr"))
      picdata = dict(devspec[picname.upper()].items())
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
   if len(wormholesectors) > 0:                       # expected with 16-bits code only
      cfgvar["fuseaddr"] = eval(wormholesectors[0].getAttribute("edc:beginaddr"))
      cfgvar["fusesize"] = eval(wormholesectors[0].getAttribute("edc:endaddr")) - \
                           eval(wormholesectors[0].getAttribute("edc:beginaddr"))
      cfgvar["fusedefault"] = [0] * cfgvar["fusesize"]
      load_fuse_defaults(root)

   sfraddr = 0                                                    # startvalue of SFR reg addr.
   sfrdatasectors = root.getElementsByTagName("edc:SFRDataSector")
   for sfrdatasector in sfrdatasectors:
      if sfrdatasector.hasAttribute("edc:bank"):                     # count numbanks
         cfgvar["numbanks"] = max(eval(sfrdatasector.getAttribute("edc:bank")) + 1, cfgvar["numbanks"])
      sfraddr = eval(sfrdatasector.getAttribute("edc:beginaddr"))    # current SFRaddr
      if len(sfrdatasector.childNodes) > 0:
         child = sfrdatasector.firstChild
         sfraddr = calc_sfraddr(child, sfraddr)                      # next SFRaddr
         while child.nextSibling:
            child = child.nextSibling
            if child.nodeType == Node.ELEMENT_NODE:
               if child.hasAttribute("edc:cname"):
                  childname = child.getAttribute("edc:cname")
                  if childname == "OSCCAL":
                     cfgvar["osccal"] = sfraddr
                  elif childname == "FSR":
                     cfgvar["fsr"] = sfraddr
                  elif childname in ("ADRESH", "ADRES0H"):
                     cfgvar["adc_highres"] = True
                  elif childname.startswith("LAT") & (len(childname) == 4) & \
                        ("A" <= childname[-1] <= "L"):
                     cfgvar["haslat"] = True
                     access = child.getAttribute("edc:access")
                     if (childname == "LATA") | (childname == "LATE"):
                        fields = child.getElementsByTagName("edc:SFRFieldDef")
                        for field in fields:
                           fieldname = field.getAttribute("edc:cname")
                           if (fieldname == "LATA3") & (access[4] != "r"):
                              cfgvar["lata3_out"] = True
                           elif (fieldname == "LATE3") & (access[4] != "r"):
                              cfgvar["late3_out"] = True
               sfraddr = calc_sfraddr(child, sfraddr)                   # next adjust

   data = []                                                         # intermediate result
   gprdatasectors = root.getElementsByTagName("edc:GPRDataSector")
   for gprdatasector in gprdatasectors:
      if gprdatasector.hasAttribute("edc:bank"):                     # count numbanks
         cfgvar["numbanks"] = max(eval(gprdatasector.getAttribute("edc:bank")) + 1, cfgvar["numbanks"])
      parent = gprdatasector.parentNode
      if parent.nodeName != "edc:ExtendedModeOnly":
         if gprdatasector.hasAttribute("edc:shadowidref") == False:
            gpraddr = eval(gprdatasector.getAttribute("edc:beginaddr"))
            gprlast = eval(gprdatasector.getAttribute("edc:endaddr"))
            data.append((gpraddr,gprlast))
            if (gprdatasector.getAttribute("edc:regionid") == "gprnobnk")  | \
               (gprdatasector.getAttribute("edc:regionid") == "gprnobank") | \
               (gprdatasector.getAttribute("edc:regionid") == "accessram"):
               cfgvar["sharedrange"] = (gpraddr, gprlast)
            if (gpraddr == 0):
               cfgvar["accessbanksplitoffset"] = gprlast
   dprdatasectors = root.getElementsByTagName("edc:DPRDataSector")
   for dprdatasector in dprdatasectors:
      if dprdatasector.hasAttribute("edc:bank"):                     # count numbanks
         cfgvar["numbanks"] = max(eval(dprdatasector.getAttribute("edc:bank")) + 1, cfgvar["numbanks"])
      parent = dprdatasector.parentNode
      if parent.nodeName != "edc:ExtendedModeOnly":
         if dprdatasector.hasAttribute("edc:shadowidref") == False:
            dpraddr = eval(dprdatasector.getAttribute("edc:beginaddr"))
            dprlast = eval(dprdatasector.getAttribute("edc:endaddr"))
            data.append((dpraddr,dprlast))
            if (dprdatasector.getAttribute("edc:regionid") == "dprnobnk")  | \
               (dprdatasector.getAttribute("edc:regionid") == "dprnobank") | \
               (dprdatasector.getAttribute("edc:regionid") == "accessram"):
               cfgvar["sharedrange"] = (dpraddr, dprlast)
            if (dpraddr == 0):
               cfgvar["accessbanksplitoffset"] = dprlast
   cfgvar["datarange"] = compact_address_range(data)

   if ((cfgvar["core"] == '12') | (cfgvar["core"] == '14')) & (cfgvar["numbanks"] > 4):
      cfgvar["numbanks"] = 4                                   # max 4 banks for core 12, 14

   if "sharedrange" not in cfgvar:                             # no shared range found
      if len(cfgvar["datarange"]) == 1:                        # single data bank
         cfgvar["sharedrange"] = cfgvar["datarange"][0]        # all data is shared
      else:
         print "   Multiple banks, but no shared data!"


# ---------------------------------------------------------
# Title:   Load fuse defaults
# Input:   - xml structure
# Output:  cfgvar["fusedefault"]
# Returns: (nothing)
# Notes:   Can be used for all cores, but only useful with 16-bits
#          core since only defaults of 16-bits core will be updated.
# ---------------------------------------------------------
def load_fuse_defaults(root):
   configfusesectors = root.getElementsByTagName("edc:ConfigFuseSector")
   if len(configfusesectors) == 0:
      configfusesectors = root.getElementsByTagName("edc:WORMHoleSector")
   for configfusesector in configfusesectors:
      dcraddr = eval(configfusesector.getAttribute("edc:beginaddr"))    # start address
      if len(configfusesector.childNodes) > 0:
         dcrdef = configfusesector.firstChild
         dcraddr = load_dcrdef_default(dcrdef, dcraddr)
         while dcrdef.nextSibling:
            dcrdef = dcrdef.nextSibling
            dcraddr = load_dcrdef_default(dcrdef, dcraddr)


# ---------------------------------------------------------
# Title:   Load individual configuration byte/word
# Input:   - dcrdef
#          - current fuse address
# Output:  part of device file
# Returns: next config fuse address
# ---------------------------------------------------------
def load_dcrdef_default(dcrdef, addr):
   if dcrdef.nodeName == "edc:AdjustPoint":
      addr = addr + eval(dcrdef.getAttribute("edc:offset"))
   elif dcrdef.nodeName == "edc:DCRDef":
      if cfgvar["core"] == '16':
         index = addr - cfgvar["fuseaddr"]                # position in array
         cfgvar["fusedefault"][index] = eval(dcrdef.getAttribute("edc:default"))
      addr = addr + 1
   return addr


# ---------------------------------------------------------
# Title:   Read devicespecific.json
# Input:   file with datasheet info
# Output:  fills 'devspec' dictionary
# Returns: (nothing)
# ---------------------------------------------------------
def read_devspec_file():
   global devspec                                              # global variable
   fp = open(devspecfile, "r")
   devspec = json.load(fp)                                     # obtain contents devicespecific
   fp.close()


# ---------------------------------------------------------
# Title:   Read pinmap file pinmape_pinsuffix.json
# Input:   file with datasheet info
# Output:  fills 'pinmap' dictionary
# Returns: (nothing)
# ---------------------------------------------------------
def read_pinmap_file():
   global pinmap                                               # global variable
   fp = open(pinmapfile, "r")
   pinmap = json.load(fp)                                      # obtain contents devicespecific
   fp.close()


# ---------------------------------------------------------
# Title:   Read datasheet.list
# Input:   none
# Output:  fills 'datasheet' dictionary
# Returns: (nothing)
# ---------------------------------------------------------
def read_datasheet_file():
   global datasheet
   fp = open(datasheetfile, "r")
   for ln in fp:
      ds = ln.split(" ",1)[0]                                  # datasheet number+suffix
      datasheet[ds[:-1]] = ds                                  # number -> number + sufix
   fp.close()


# ---------------------------------------------------------
# Title:   Convert MPLAB-X .pic file to a JalV2 device file
# Input:   - name of the PIC
#          - path of the .pic file
# Output:  - device file
# Returns: (nothing)
# Notes:
# ---------------------------------------------------------
def pic2jal(picname, picfile):
   print picname
   global names
   names = []
   root = parse(picfile)                                       # load xml file
   collect_config_info(root, picname)                          # first scan for selected info
   fp = open(os.path.join(dstdir, picname + ".jal"), "w")      # device file to be built
   list_devicefile_header(fp, picname)
   list_config_memory(fp)
   list_osccal(fp)                                             # works only for selected PICs
   list_all_sfr(fp, root)
   list_digital_io(fp, picname)
   list_miscellaneous(fp, picname)
   list_fuse_defs(fp, root)
   fp.write("--\n")
   fp.close()


# ---------------------------------------------------------
# Main procedure: - process external configuration info
#                 - select .pic files to be processed (8-bits flash PICs)
# Input:    PICs to be selected (wildcard specification)
# Output:   - device file per selected PICs
#           - chipdef_jallib file
# Returns:  Number of generated device files
# ---------------------------------------------------------
def main(selection):

   m_pic8flash  = re.compile(r"^1(0|2|6|8)(f|lf|hv).*")        # relevant PICs only
   l_pic8excl   = ["16hv540", "16f527", "16f570"]              # exclude OTP, bank select by BSR

   init_fusedef_mapping()
   read_datasheet_file()                                       # for datasheet suffix
   read_devspec_file()                                         # PIC specific info, like datasheet #
   read_pinmap_file()                                          # pin aliases
   fp = open(os.path.join(dstdir, "chipdef_jallib.jal"), "w")  # common include for device files
   list_chipdef_header(fp)                                     # create header of chipdef file
   devcount = 0
   for (root, dirs, files) in os.walk(picdir):                 # whole tree (incl subdirs!)
      files.sort()                                             # for unsorted filesystems!
      for file in files:
         picname = os.path.splitext(file)[0][3:].lower()       # 1st selection: pic type
         if (re.match(m_pic8flash, picname) != None) & \
            (picname not in l_pic8excl):                       # select 8-bits flash PICs
            if fnmatch.fnmatch(picname, selection):            # 2nd selection (user wildcard)
               if picname.upper() in devspec:                  # must be in devicespecific
                  picdata = dict(devspec[picname.upper()].items())  # properties of this PIC
                  if picdata.get("DATASHEET") != "-":               # 3rd selection (must have datasheet)
                     pic2jal(picname, os.path.join(root,file))      # create device file from .pic file
                     fp.write("const  word  PIC_%-14s" % picname.upper() + \
                              " = 0x%X" % (cfgvar["procid"]) + "\n")
                     devcount = devcount + 1
                  else:
                     print picname, "no datasheet!"
               else:
                  print picname, "\a not present in", devspecfile    # sound a bell!
   fp.write("--\n")
   fp.close()
   return devcount


# === start ====================================================
# process commandline parameters, start process, time execution
# ==============================================================

if __name__ == "__main__":

   if len(sys.argv) > 1:
      runtype = sys.argv[1].lower()
   else:
      print "Specify at least PROD or TEST as first argument"
      print "and optionally a pictype (wildcards allowed)"
#     sys.exit(1)
      runtype = "test"

   if runtype == "prod":
      dstdir = os.path.join(jallibbase, "include/device")
   elif runtype == "test":
      dstdir = "./test"
   else:
      print "Specify PROD or TEST as first argument"
      print "and optionally a pictype (wildcards allowed)"

   if len(sys.argv) > 2:
      selection = sys.argv[2].lower()
   else:
#     selection = "*"
      selection = "18f24k50"

   elapsed = time.time()
   count = main(selection)
   elapsed = time.time() - elapsed
   print "Generated %d device files in %.1f seconds (%.1f per second)" % \
         (count, elapsed, count / elapsed)


