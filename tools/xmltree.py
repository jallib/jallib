#!/usr/bin/env python3
"""
Title: Convert XML file into a simple tree structure
Author: Rob Hamerling, Copyright (c) 2014..2025, all rights reserved.
Adapted-by: Rob Jansen

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
    Changes RobH 2024-11-xx
    - use of xml.etree.ElementTree in stead of xml.dom.minidom
    - some related changes
"""

import sys
import os
import re
import time
import fnmatch
from concurrent import futures
import xml.etree.ElementTree as et

# Check - environment - requirements for running this script.
if (sys.version_info < (3,5,0)):
    print("You need Python 3.5.0 or later to run this script!\n")
    exit(1)

if not ('PIC2JAL' in os.environ):
    print("Environment variable PIC2JAL for destination not set.")
    exit(1)


if not ('MPLABXVERSION' in os.environ):
    print("Environment variable MPLABXVERSION for latest MPLABX version not set.")
    exit(1)

# All OK, set variables. 
base = os.path.join(os.environ['PIC2JAL'] + "." + os.environ['MPLABXVERSION'])  

xmldir = os.path.join(base, "mplabx")                   # location of xml .PIC files

# destination of xmltree files
xmltreedir = os.path.join(base, "xmltree")              # destination of .xmltree files
if not os.path.exists(xmltreedir):
   os.makedirs(xmltreedir)                              # with MPLABX version

def element_print(fp, element, level):
    fp.write(".."*level + element.tag + "\n")
    for attr in element.attrib:
        fp.write("  "*(level+1) + str(attr) + ' = ' + str(element.get(attr))  + "\n")

def show_elements(fp, parent, level):
    for element in iter(parent):
        element_print(fp, element, level + 1)
        show_elements(fp, element, level + 1)           # recursive call

def build_xmltree(picname):
    print(picname)
    devspec = os.path.join(xmldir, 'PIC' + picname + '.PIC')
    with open(devspec, 'r') as fp:
        xmlstr = fp.read()                              # complete xml content
        # remove 'edc:' and 'xsi:' namespace prefixes in xml file
        xmlstr = xmlstr.replace('edc:', '')
        xmlstr = xmlstr.replace('xsi:', '')
    root = et.fromstring(xmlstr)                        # parse xml content
    with open(os.path.join(xmltreedir, picname.lower() + ".xmltree"), "w") as fp:
        element_print(fp, root, 0)
        show_elements(fp, root, 0)
    return 1                                            # number of output files


# === mainline ===

if (__name__ == "__main__"):

    if len(sys.argv) > 1:
        selection = sys.argv[1].upper()
    else:
        selection = "1*"                                # base .pic file selection

    start_time = time.time()
    pics = []                                           # new list of filespecs
    for file in os.listdir(xmldir):                     # all .PIC xml files
        picname = os.path.splitext(file)[0][3:].upper()     # pic type
        if (fnmatch.fnmatch(picname, selection)):       # selection by user (wildcard)
            pics.append(picname)                        # add pic to list

    if len(pics) == 0:
        print("Nothing in selection")
        exit(1)

    # Start a number of parallel processes
    with futures.ProcessPoolExecutor() as executor:
        results = executor.map(build_xmltree, pics)     # for all selected PICs
        count = sum(results)
    print(f"Generated {count} xmltree files")
    runtime = time.time() - start_time
    print(f"Runtime: {runtime:.1f} seconds")
    if runtime > 0:
        print(f"        ({count/runtime:.2f} files per second)")

#
