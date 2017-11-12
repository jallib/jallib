#!/usr/bin/env python3
"""
Title:  Analysis of selected configuration bits or bitfields

Author: Rob Hamerling, Copyright (c) 2013..2017, all rights reserved.

Adapted-by:

Compiler: N/A

This file is part of jallib (htts://github.com/jallib/jallib)
Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)

Sources:

Description: Analyse the configuration information in MPLAB-X .pic files
             and produce an overview of the selected bits or bit fields.
             The selection is on the cname attribute of the DCRFieldDef nodes
             (the fusedef keywords), and of these the symbolic values and
             corresponding descriptions are collected (the DCRFieldSemantic attributes).
             The output file is named 'fusedef_analysis_<keyword>.<mplabversion>
             in which <keyword> is the name of the (first of several)
             selection keyword(s) specified on the commandline.
             For example:
                  python3 fusedef_analysis.py osc fosc
             produces a file fusedef_analysis_osc.<mplabxversion>
             with all oscillator keywords and descriptions,
             in several overviews with statistics.
             It is probably only useful to specify apparent 'synonyms' as
             selection keywords (like OSC and FOSC).

Dependencies: This script uses the .pic files of MPLABX as
              extracted by mplabxtract script.

Notes: This script is useful to get insight in the configuration bits
       variations. It is particularly helpful to maintain and improve
       the fusedef section of device file generation script.

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

picdir   = os.path.join(base, "mplabx." + mplabxversion, "content", "edc")    # dir with .PIC files

kwdkwddict  = {}
kwdnamedict = {}
kwddescdict = {}
kwdpicsdict = {}


# ------------------------------------------------------------
def add_kwd(node, picname):
   """ process DCRFieldSemantic
   """
   if (node.nodeType != Node.ELEMENT_NODE):                    # process only element nodes
      return
   kwdlist = node.getElementsByTagName("edc:DCRFieldSemantic")
   for kwdtype in kwdlist:
      kwd = kwdtype.getAttribute("edc:cname").upper()          # obtain symbolic name
      hidden = kwdtype.getAttribute("edc:ishidden")            # get hidden status
      if ((kwd != "") & (hidden != "true")):
         desc = kwdtype.getAttribute("edc:desc")               # obtain description
         if (desc != ""):                                      # description present
            kwdkwddict[kwd] = kwdkwddict.get(kwd,0) + 1        # count symbolic values occurrences
            if (kwddescdict.get(kwd) == None):                 # first desc for this value
               kwddescdict[kwd] = [desc]                       # make description list
               kwdpicsdict[(kwd, desc)] = [picname]            # make pic list
            else:
               if (not desc in kwddescdict[kwd]):              # new desc
                  kwddescdict[kwd].append(desc)                # to existing list
                  kwdpicsdict[(kwd, desc)] = [picname]         # make pic list
               else:
                  kwdpicsdict[(kwd, desc)].append(picname)
      else:
         print("   no symbolic value or hidden:", kwdtype.getAttribute("edc:desc"))


# --------------------------------------------------------------
def add_pic(file, kwdlist):
   """ process selected DCRFieldDef nodes of a PIC
   """
   picfile = os.path.split(file)[1]
   picname = picfile.split(".")[0][3:].lower()
   print(picname)
   root = parse(os.path.join(picdir, file))
   if (root.getElementsByTagName("edc:ConfigFuseSector").length > 0):
      cfglist = root.getElementsByTagName("edc:ConfigFuseSector")
   elif (root.getElementsByTagName("edc:WORMHoleSector").length > 0):
      cfglist = root.getElementsByTagName("edc:WORMHoleSector")
   for node in cfglist:
      fielddeflist = node.getElementsByTagName("edc:DCRFieldDef")
      for fielddef in fielddeflist:
         attr = fielddef.getAttribute("edc:name")
         if (attr in (kwdlist)):                               # selected keywords only
            kwdnamedict[attr] = kwdnamedict.get(attr,0) + 1    # count occurrences
            add_kwd(fielddef, picname)


# -------------------------------------------------------------
def list_separator(fp):
   """ write separator line to listing
   """
   fp.write("\n" + "-" * 60 + "\n\n")


# -------------------------------------------------------------
def list_results(kwdlist, listing):
   """ Produce listing with diffent views of the collection
   """
   print("Creating", listing, "from .pic files in", picdir)
   with open(listing, "w") as fp:
      fp.write("\nSearched for DCRFieldDefs: " + " ".join(kwdlist) + "\n\n")
      fp.write("Occurrences of DCRFieldDefs (" + str(len(kwdnamedict)) + ")\n\n")
      kwdlist = sorted(kwdnamedict.keys())
      for kwd in kwdlist:
         fp.write("%15s" % kwd + " : " + str(kwdnamedict[kwd]) + "\n")
      list_separator(fp)

      kwdlist = sorted(kwdkwddict.keys())
      fp.write("Symbolic values and their occurrences (" + str(len(kwdlist)) + ")\n\n")
      for kwd in kwdlist:
         fp.write("%15s" % kwd + " : " + str(kwdkwddict[kwd])+ "\n")
      list_separator(fp)

      kwdlist = sorted(kwddescdict.keys())
      fp.write("Symbolic values + descriptions\n\n")
      for kwd in kwdlist:
         fp.write(kwd + "\n")
         for desc in kwddescdict[kwd]:
            fp.write(" " * 18 + str(desc) + "\n")
      list_separator(fp)

      kwdlist = sorted(kwddescdict.keys())
      fp.write("Symbolic values + descriptions, and involved PICs\n\n")
      for kwd in kwdlist:
         fp.write(kwd)
         piccount = 0
         for desc in kwddescdict[kwd]:
            fp.write("\n" + " " * 18 + str(desc) + "\n")
            piccount = piccount + len(kwdpicsdict[(kwd, desc)])
            fp.write("%15s" % len(kwdpicsdict[(kwd, desc)]) + ' : ')
            fp.write(" ".join(kwdpicsdict[(kwd,desc)]) + "\n")
         fp.write("            ---\n%15s\n" % (piccount))
         if (piccount != kwdkwddict[kwd]):                  # check!
            fp.write("Script error: piccount does not match keyword occurrences" + kwdkwddict[kwd] + "\n")
         fp.write("\n")
      list_separator(fp)


# ----------------------------------------------------------
def main():
   """ process .edc files in picdir
   """
   listing = os.path.join(base, "fusedef_analysis_" + sys.argv[1].lower() + '.' + mplabxversion)   # list file
   kwdlist = []                                             # create list of keywords from commandline
   for kwd in sys.argv[1:]:                                 # all except first word
      kwdlist.append(kwd.upper())                           # use uppercase
   print("Scanning", picdir, "for DCRFieldDef keywords", " ".join(kwdlist))
   for (root, dirs, files) in os.walk(picdir):              # whole tree
      dirs.sort()
      files.sort()                                          # alpha_numeric sequence
      for file in files:
         add_pic(os.path.join(root,file), kwdlist)          # process .pic file

   list_results(kwdlist, listing)



# === E N T R Y   P O I N T ===

if __name__ == "__main__":
   if (len(sys.argv) > 1):
      main()
   else:
      print('Please specify one or more names of DCRFieldDefs for analysis')

