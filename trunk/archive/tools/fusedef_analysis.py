#!/usr/bin/python
#
# Title:  Analysis of selected configuration bits or bitfields
# Author: Rob Hamerling, Copyright (c) 2013..2014, all rights reserved.
# Adapted-by:
# Compiler: N/A
#
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
#
# Description: Analyse the configuration information in MPLAB-X .pic files
#              and produce an overview of the selected bits or bit fields.
#              The selection is on the cname attribute of the DCRFieldDef nodes,
#              and of these the cname and desc attributes of DCRFieldSemantic
#              nodes are analyzed.
#              The output file is named 'fusedef_analysis_<keyword>.<mplab-version>
#              in which <keyword> is the name of the (first of several)
#              selection keyword(s) specified on the commandline.
#              Example: fusedef_analysis OSC FOSC
#              produces a file fusedef_analysis_osc.205
#              with all oscillator keywords and descriptions,
#              in several overviews with statistics.
#
# Dependencies: This script uses the .pic files of MPLAB-X which should be
#               extracted from crownking.edc.jar (see devicefiles.html).
#
# Notes: This script is useful to get insight in the configuration bits
#        variations. It is particularly helpful to maintain and improve
#        the device file generation.
#

import os
import sys
import re
from xml.dom.minidom import parse, Node


# basic parameters:

mplabxversion = "205"
picdir        = "K:/mplab-x_" + mplabxversion + "/crownking.edc.jar/content/edc"    # dir with .PIC files
pic8flash     = re.compile(r"^PIC1(0|2|6|8)(F|LF|HV).*\.PIC")    # select 8-bits flash pics


kwdkwddict  = {}
kwdnamedict = {}
kwddescdict = {}
kwdpicsdict = {}

def add_kwd(node, picname):
   # process DCRFieldSemantic
   if node.nodeType != Node.ELEMENT_NODE:                      # process only element nodes
     return
   kwdlist = node.getElementsByTagName("edc:DCRFieldSemantic")
   for kwdtype in kwdlist:
      kwd = kwdtype.getAttribute("edc:cname").upper()
      hidden = kwdtype.getAttribute("edc:ishidden")
      if (kwd != "") & (hidden != "true"):
         kwdkwddict[kwd] = kwdkwddict.get(kwd,0) + 1           # count keyword occurrences
         desc = kwdtype.getAttribute("edc:desc")
         if desc != "":                                        # description present
            if kwddescdict.get(kwd) == None:                   # first desc for this keyword
               kwddescdict[kwd] = [desc]                       # make description list
               kwdpicsdict[(kwd, desc)] = [picname]            # make pic list
            else:
               if not (desc in kwddescdict[kwd]):              # new desc
                  kwddescdict[kwd].append(desc)                # to existing list
                  kwdpicsdict[(kwd, desc)] = [picname]         # make pic list
               else:
                  kwdpicsdict[(kwd, desc)].append(picname)
      else:
        print "   no keyword or hidden:", kwdtype.getAttribute("edc:desc")


def add_pic(file, kwdlist):
   # process selected DCRFieldDef nodes of a PIC
   picfile = os.path.split(file)[1]
   picname = picfile.split(".")[0].lower()
   print picname
   root = parse(os.path.join(picdir, file))
   if root.getElementsByTagName("edc:ConfigFuseSector").length > 0:
      cfglist = root.getElementsByTagName("edc:ConfigFuseSector")
   elif root.getElementsByTagName("edc:WORMHoleSector").length > 0:
      cfglist = root.getElementsByTagName("edc:WORMHoleSector")
   for node in cfglist:
      fielddeflist = node.getElementsByTagName("edc:DCRFieldDef")
      for fielddef in fielddeflist:
         attr = fielddef.getAttribute("edc:name")
         if attr in (kwdlist):                                 # selected keywords only
            kwdnamedict[attr] = kwdnamedict.get(attr,0) + 1    # count occurrences
            add_kwd(fielddef, picname)                         #


def list_results(kwdlist, listing):
   fp = open(listing, "w")
   fp.write("\nSearched for DCRFieldDefs: " + " ".join(kwdlist) + "\n\n")
   fp.write("Occurrences of DCRFieldDefs (" + str(len(kwdnamedict)) + ")\n\n")
   kwdlist = sorted(kwdnamedict.keys())
   for kwd in kwdlist:
     fp.write("%15s" % kwd + " : " + str(kwdnamedict[kwd]) + "\n")
   fp.write("\n" + "-" * 60 + "\n\n")

   kwdlist = sorted(kwdkwddict.keys())
   fp.write("Keywords and their occurrences (" + str(len(kwdlist)) + ")\n\n")
   for kwd in kwdlist:
      fp.write("%15s" % kwd + " : " + str(kwdkwddict[kwd])+ "\n")
   fp.write("\n" + "-" * 60 + "\n\n")

   kwdlist = sorted(kwddescdict.keys())
   fp.write("Keywords and their descriptions\n\n")
   for kwd in kwdlist:
      fp.write(kwd + "\n")
      for desc in kwddescdict[kwd]:
         fp.write(" " * 18 + str(desc) + "\n")
   fp.write("\n" + "-" * 60 + "\n\n")

   kwdlist = sorted(kwddescdict.keys())
   fp.write("Keywords + descriptions, and involved PICs\n\n")
   for kwd in kwdlist:
      fp.write(kwd)
      piccount = 0
      for desc in kwddescdict[kwd]:
         fp.write("\n" + " " * 18 + str(desc) + "\n")
         piccount = piccount + len(kwdpicsdict[(kwd, desc)])
         fp.write("%15s" % len(kwdpicsdict[(kwd, desc)]) + ' : ')
         fp.write(" ".join(kwdpicsdict[(kwd,desc)]) + "\n")
      fp.write(" "*12 + "---" + "\n" + "%15s" % piccount + "\n")
      if piccount != kwdkwddict[kwd]:
         fp.write("Error: piccount does not match number of keyword occurrences\n")
      fp.write("\n")
   fp.write("\n" + "-" * 60 + "\n\n")
   fp.close()


def main():
   # process .edc files in picdir
   kwdlist = []                                             # create list of keywords
   for kwd in sys.argv[1:]:                                 # all except first
      kwdlist.append(kwd.upper())                           # force uppercase
   print "Scanning", picdir, "for keywords", " ".join(kwdlist)
   listing = "fusedef_analysis_" + sys.argv[1] + '.' + mplabxversion   # output listing
   print "Building", listing, "from .pic files in", picdir
   for (root, dir, files) in os.walk(picdir):               # whole tree
      if len(files) > 0:
         files.sort()                                       # alpha_numeric sequence
         for file in files:
            if re.match(pic8flash, file) != None:           # select 8-bits flash PICs
               add_pic(os.path.join(root,file), kwdlist)    # process .pic file
         list_results(kwdlist, listing)

if __name__ == "__main__":
   if len(sys.argv) > 1:
      main()
   else:
      print 'Please specify one or more names of DCRFieldDefs to analyse'

