#!/usr/bin/env python3
"""
Title: Convert XML file into a simple tree structure

Author: Rob Hamerling, Copyright (c) 2014..2017, all rights reserved.

Adapted-by:

Revision: $Revision$

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the BSD license https://www.opensource.org/licenses/bsd-license.php

Description:
    Script to convert XML file into a simple tree structure
    to better understand the contents of the MPLAB-X .pic (XML) files.

Sources: N/A

Notes:

"""

from pic2jal_environment import check_and_set_environment

base, mplabxversion = check_and_set_environment()    # obtain environment variables
if (base == ""):
   exit(1)

import sys
import os
import re
import fnmatch
from xml.dom.minidom import parse, Node

picdir = os.path.join(base, "mplabx." + mplabxversion, "content", "edc")
picdirs = ("16c5x", "16xxxx", "18xxxx")                     # directories with xml files of 8-bits pic

# output (relative path)
xmltreedir = os.path.join(base, "xmltree." + mplabxversion)      # destination of .xmltree files
if not os.path.exists(xmltreedir):
   os.makedirs(xmltreedir)                                  # with MPLABX version

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
      show_nodes(fp, child, level + 1)                      # recursive call
   while child.nextSibling:
      child = child.nextSibling
      child_print(fp, child, level)
      if child.hasChildNodes():
         show_nodes(fp, child, level + 1)                   # recursive call


# === mainline ===

if (__name__ == "__main__"):

   if len(sys.argv) > 1:
      selection = sys.argv[1].lower()
   else:
      selection = "1*"                                      # base .pic file selection

   for (root, dirs, files) in os.walk(picdir):              # whole tree (incl subdirs)
      dirs.sort()                                           # sort on core type: 12-, 14-, 16-bit
      files.sort()                                          # alphanumeric name sequence
      for file in files:
         picname = os.path.splitext(file)[0][3:].lower()    # pic type
         if (fnmatch.fnmatch(picname, selection)):          # selection by user wildcard
            print(picname)
            picnode = parse(os.path.join(root, file))
            with open(os.path.join(xmltreedir, picname + ".xmltree"), "w") as fp:
               show_nodes(fp, picnode, 0)                   # (start with) root node

