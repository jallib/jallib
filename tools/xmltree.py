#!/usr/bin/env python3
"""
Title: Convert XML file into a simple tree structure

Author: Rob Hamerling, Copyright (c) 2014..2024, all rights reserved.
        Rob Jansen,    Copyright (c) 2018..2024, all rights reserved.
		
Adapted-by:

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the ZLIB license http://www.opensource.org/licenses/zlib-license.html

Description:
    Script to convert XML file into a simple tree structure
    to better understand the contents of the MPLAB-X .pic (XML) files.

Sources: N/A

Notes:

    Changes RobH 2024-04-xx
    - .xmltree files built in parallel with 'futures'
    - the mplabxtract script collects all .PIC files into
        'mplabx'.mplabxversion (no subdirectories)

"""

from pic2jal_environment import check_and_set_environment

base, mplabxversion = check_and_set_environment()    # obtain environment variables
if (base == ""):
   exit(1)

import sys
import os
import re
import time
import fnmatch
from concurrent import futures
from xml.dom.minidom import parse, Node

picdir = os.path.join(base, "mplabx")

# output (relative path)
xmltreedir = os.path.join(base, "xmltree")              # destination of .xmltree files
if not os.path.exists(xmltreedir):
   os.makedirs(xmltreedir)                              # with MPLABX version

def child_print(fp, child, level):
   if (child.nodeType != Node.TEXT_NODE):
      if child.nodeType == Node.ELEMENT_NODE:
         fp.write(".."*level + child.localName + "\n")
         for i in range(child.attributes.length):
            attr = child.attributes.item(i)
            fp.write("  "*(level+1) + attr.localName + " = " + attr.value +"\n")
      elif child.nodeType == Node.COMMENT_NODE:
         fp.write(".."*level + child.nodeValue + "\n")

def show_nodes(fp, parent, level):
   child = parent.firstChild
   child_print(fp, child, level)
   if child.hasChildNodes():
      show_nodes(fp, child, level + 1)                  # recursive call
   while child.nextSibling:
      child = child.nextSibling
      child_print(fp, child, level)
      if child.hasChildNodes():
         show_nodes(fp, child, level + 1)                # recursive call

def build_xmltree(devspec):
   picspec = os.path.split(devspec)[-1]                  # filename.ext
   picname = os.path.splitext(picspec)[0][3:].lower()    # remove extension and 'pic' prefix
   print(picname)
   parent = parse(os.path.join(devspec))
   with open(os.path.join(xmltreedir, picname + ".xmltree"), "w") as fp:
      show_nodes (fp, parent, 0)
   return 1                                             # number of output files


# === mainline ===

if (__name__ == "__main__"):

   if len(sys.argv) > 1:
      selection = sys.argv[1].upper()
   else:
      selection = "1*"                                   # base .pic file selection

   start_time = time.time()
   devs = []                                             # new list of filespecs
   for file in sorted(os.listdir(picdir)):               # all .PIC files
      picname = os.path.splitext(file)[0][3:].upper()    # pic type
      if (fnmatch.fnmatch(picname, selection)):          # selection by user wildcard
         devs.append(os.path.join(picdir, file))         # add filespec to list

   if len(devs) == 0:
      print("Nothing in selection")
      exit(1)

   # Start a number of parallel processes
   with futures.ProcessPoolExecutor() as executor:
      results = executor.map(build_xmltree, devs)        # for all selected PICs
      count = sum(results)
   print(f"Generated {count} xmltree files")
   runtime = time.time() - start_time
   print(f"Runtime: {runtime:.1f} seconds")
   if runtime > 0:
      print(f"        ({count/runtime:.2f} files per second)")

#
