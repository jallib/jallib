#!/usr/bin/env python3
"""
Title: Create Datasheet wiki files

Author: Rob Hamerling, Copyright (c) 2009..2017, all rights reserved.

Adapted-by:

Revision: $Revision$

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the BSD license https://www.opensource.org/licenses/bsd-license.php

Description:
   Create wiki files of Datasaheets and Programming Specifications
     * DataSheet
     * Programming Specifications
     * PICs with the same DataSheet
     * PICs with the same Programming Specifications

 Sources: N/A

 Notes: - Run this script after updates of datasheet.list and devicespecific.json.
        - Uses devicespecific,json to obtain DataSheet numbers of PICs
          datasheet.list to obtain the latest suffixes and titles of the datasheets

"""

from pic2jal_environment import check_and_set_environment
base, mplabxversion = check_and_set_environment()              # obtain environment variables
if (base == ""):
   exit(1)

import sys
import os
import time
import json

url = "http://ww1.microchip.com/downloads/en/DeviceDoc/"    # Microchip site with datasheets

# --- input ---
picspecfile = os.path.join(base, "devicespecific.json")     # PIC specific properties
dslist      = os.path.join(base, "datasheet.list")          # datasheet number/title file

# --- output ---
wikidir = os.path.join(base, "wiki")                        # output directory
if (os.path.exists(wikidir) == False):
   os.makedirs(wikidir)


def read_datasheet_list(infile):
   """ fill dictionary 'datasheet' with number and title """
   with open(infile, "r")   as fp:                          # datasheet list
      for ln in fp:
         w = ln.split(" ", 1)                               # separate number from title
         if (len(w) > 1):
            dd = w[0].upper()
            ds = w[1].strip()
            key = int(dd[0:len(dd)-1])                      # strip letter; get numeric key
            datasheet[key] = {"NUMBER" : dd, "TITLE" : ds}


def pic_wiki(outfile):
   """ create datasheet or programming specifications wiki """
   if (outfile.find("Programming") >= 0):
      type  = "ps"
      title = "PICname - Programming Specifications cross reference"
   else:
      type  = "ds"
      title = "PICname - DataSheet cross reference"
   print("Building", title)
   with open(os.path.join(wikidir, outfile), "w") as fp:
      fp.write("#" + title + "\n\n")
      fp.write("## (" + time.ctime() + ")\n\n")
      fp.write("<table>\n")
      fp.write("<tr><th>PIC type</th><th>Number</th><th>Datasheet Title</th></tr>\n")
      piclist = list(picspec.keys())
      piclist.sort()
      for pic in piclist:
         picd = dict(list(picspec[pic].items()))
         if (type == "ds"):
            ds = picd.get("DATASHEET", "-")
         else:
            ds = picd.get("PGMSPEC", "-")
         if (ds != "-"):
            key = int(ds)                                   # numeric index!
            if key in datasheet:                            # DS present
               if datasheet[key].get("TITLE") != None:      # title present
                  fp.write("<tr><td>%-12s</td>" % pic
                           + "<td>" + '<a href="' + url + datasheet[key].get("NUMBER") + '.pdf">'
                           + datasheet[key].get("NUMBER") + "</a></td>"
                           + "<td>" + datasheet[key].get("TITLE")  + "</td></tr>\n")
               else:
                  print("No title found of datasheet", key)
            else:
               print("Datasheet", key, "of", pic, "in", picspecfile, "not found")
      fp.write("</table>\n")


def group_wiki(outfile):
   """ create wiki of groups of PICs with the same datasheet or programming specifications """

   def sort_group_on_pic(group):
      """ custom sort on first PIC of group in groups """
      return groups[group][0]

   if outfile.find("Pgm") >= 0:
      type  = "ps"
      title = "PICs sharing the same Programming Specifications"
   else:
      type  = "ds"
      title = "PICs sharing the same Datasheet"
   print("Building", title)
   groups = {}
   piclist = list(picspec.keys())
   for pic in piclist:
      picd = dict(list(picspec[pic].items()))
      if type == "ds":
         ds = picd.get("DATASHEET", "-")
      else:
         ds = picd.get("PGMSPEC", "-")
      if ds != "-":
         key = int(ds)                                      # for numeric sorting!
         if key not in groups:
            groups[key] = [pic]
         else:
            groups[key].append(pic)
            groups[key].sort()                              # keep list in sequence
   with open(os.path.join(wikidir, outfile), "w") as fp:
      fp.write("#" + title + "\n\n")
      fp.write("## (" + time.ctime() + ")\n\n")
      fp.write("##Sorted on DataSheet number\n")
      fp.write("###(see below for a list sorted on PIC type)\n\n")
      fp.write("<table>\n")
      fp.write("<tr><th>DataSheet</th>><th>PIC type</th></tr>\n")
      grouplist = list(groups.keys())
      grouplist.sort()
      for group in grouplist:
         if group in datasheet:
            fp.write("<tr><td>" + '<a href="' + url + datasheet[group].get("NUMBER") + '.pdf">'
                      + datasheet[group].get("NUMBER") + "</a></td>"
                      + "<td>"+ " ".join(groups[group]) + "</td></tr>\n")
         else:
            print("Datasheet", group, "not found")
      fp.write("</table>\n\n")
      fp.write("#" + title + "\n")
      fp.write("##Sorted on PIC type (lowest in the group)\n\n")
      fp.write("<table>\n")
      fp.write("<tr><th>DataSheet</th>><th>PIC type</th></tr>\n")
      grouplist = list(groups.keys())
      grouplist.sort(key = sort_group_on_pic)
      for group in grouplist:
         if group in datasheet:
            fp.write("<tr><td>" + '<a href="' + url + datasheet[group].get("NUMBER") + '.pdf">'
                      + datasheet[group].get("NUMBER") + "</a></td>"
                      + "<td>" + " ".join(groups[group]) + "</td></tr>\n")
      fp.write("</table>\n")


# ====== E N T R Y   P O I N T ======

if __name__ == "__main__":
   datasheet = {}                                           # new dictionary
   read_datasheet_list(dslist)                              # load datasheet info
   picspec = json.load(open(picspecfile))                   # load PIC specific info
   pic_wiki("DataSheets.md")
   pic_wiki("ProgrammingSpecifications.md")
   group_wiki("PicGroups.md")
   group_wiki("PicPgmGroups.md")


