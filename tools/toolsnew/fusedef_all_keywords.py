#!/usr/bin/env python3
"""
Title:  Create inventory of DCRFieldDef names

Author: Rob Hamerling, Copyright (c) 2016..2017, all rights reserved.

Adapted-by:

Compiler: N/A

This file is part of jallib (https://github.com/jallib/jallib)
Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)

Sources:

Description: Analyse the configuration information in MPLABX .pic files
             and produce an overview of the bits and bitfields.
             The output file is named 'fusedef_all_keywords.<mplabxversion>

Dependencies: This script uses the .pic files of MPLABX as
              extracted by mplabxtract script.

Notes: This script is useful to get insight in the configuration bits
       variations. It is particularly helpful to maintain and improve
       the device file generation script.
"""

from pic2jal_environment import check_and_set_environment
base, mplabxversion = check_and_set_environment()              # obtain environment variables
if (base == ""):
   exit(1)

import os
import sys
import re
from xml.dom.minidom import parse, Node

# basic parameters:

picdir        = os.path.join(base, "mplabx." + mplabxversion, "content", "edc")    # dir with .PIC files
listing       = os.path.join(base, "fusedef_all_keywords." + mplabxversion)

kwdnamedict = {}                          # collection of
piccount = 0                              # number of .pic files scanned


# ------------------------------------------------------
def add_pic(file):
   """ Obtain all DCRFieldDef nodes of a PIC
   """
   global piccount
   piccount += 1                                            # count PICs
   rootnode = parse(os.path.join(picdir, file))
   if (rootnode.getElementsByTagName("edc:ConfigFuseSector").length > 0):
      cfglist = rootnode.getElementsByTagName("edc:ConfigFuseSector")
   elif (rootnode.getElementsByTagName("edc:WORMHoleSector").length > 0):
      cfglist = rootnode.getElementsByTagName("edc:WORMHoleSector")
   for node in cfglist:
      fielddeflist = node.getElementsByTagName("edc:DCRFieldDef")
      for fielddef in fielddeflist:
         name = fielddef.getAttribute("edc:name")           # fusedef keyword
         kwdnamedict[name] = kwdnamedict.get(name, 0) + 1   # count occurrences

# --------------------------------------------------------
def list_kwd_names():
   """ list all keyword and their occurencies
   """
   print("Creatng a list of DCRFieldDef names and their occurencies")
   kwdnamelist = list(kwdnamedict.keys())
   kwdnamelist.sort()                                       # in ASCCI sequence
   with open(listing, "w") as fp:
      fp.write("Fusedef keywords and their occurencies\n\n")
      for name in kwdnamelist:
         fp.write("%5d %s\n" % (kwdnamedict[name], name))
   print("Output in", listing)


# ----------------------------------------------------------
def main():
   """ process all .pic files in directory tree
   """
   print("Collecting all DCRFieldDef names")
   for (root, dirs, files) in os.walk(picdir):              # whole tree
      dirs.sort()
      files.sort()                                          # alpha_numeric sequence
      for file in files:
         add_pic(os.path.join(root, file))                  # process .pic file
   list_kwd_names()                                         # print results


# === E N T R Y   P O I N T ===

if __name__ == "__main__":
   main()
   print("Number of .pic files processed:", piccount)
   print("List of fusedef keywords and their occurrences in:", listing)


