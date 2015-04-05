
# CreateDSwiki.py
#
# Author: Rob Hamerling, Copyrigh (c) 2009..2015. All rights reserved.

"""
 CreateDSwikis.py - create wiki files:
                    * DataSheet
                    * Programming Specifications
                    * PICs with the same DataSheet
                    * PICs with the same Programming Specifications
 Uses:  devicespecific,json to obtain DataSheet numbers of PICs
        datasheet.list to obtain the latest suffixes and titles of the datasheets
        directory with PIC datasheets (pdf files) to obtain dates of the datasheets
 Notes: Run this script when new datasheets have become available, but after
        datasheet.list and devicespecific.json have been updated and the datasheets
        (and programming specifications) have been downloaded.
"""

import os, sys
import time
import json


#  input (may require changes for other systems or platforms)
home        = os.path.join("/", "home", "robh")             # user home directory
base        = os.path.join("/", "media", "NAS")             # base of MPLAB-X material  
picspecfile = os.path.join(home,"jallib","tools","devicespecific.json")   # PIC specific properties
dslist      = os.path.join(home,"jallib","tools","datasheet.list")        # datasheet number/title file
pdfdir      = os.path.join(base,"PicDatasheets")                          # dir with datasheets

#  output
dst         = os.path.join(home, "jallib","wiki")                         # output path

url         = "http://ww1.microchip.com/downloads/en/DeviceDoc/"          # Microchip site


def read_datasheet(infile):
   """ fill dictionary 'datasheet' with number, date and title """
   fp = open(infile, "r")                             # datasheet list
   for ln in fp:
      w = ln.split(" ", 1)                            # separate number from title
      dd = w[0].upper()
      ds = w[1].strip()
      key = int(dd[0:len(dd)-1])                      # strip letter; get numeric key
      fd = os.path.getmtime(os.path.join(pdfdir, dd + ".pdf"))
      fd = time.strftime("%Y/%m", time.gmtime(fd))    # year/month
      datasheet[key] = {"NUMBER" : dd, "TITLE" : ds, "DATE" : fd}


def pic_wiki(outfile):
   """ create datasheet or programming specifications wiki """
   if outfile.find("Programming") >= 0:
      type  = "ps"
      title = "PICname - Programming Specifications cross reference"
   else:
      type  = "ds"
      title = "PICname - DataSheet cross reference"
   print "Building", title
   fp = open(os.path.join(dst,outfile), "w")
   fp.write("#summary " + title + "\n\n----\n\n= " + title + " =\n\n")
   fp.write("|| *PIC type* || *Number* || *Date* || *Datasheet Title* ||\n")
   piclist = picspec.keys()
   piclist.sort()
   for pic in piclist:
      picd = dict(picspec[pic].items())
      if type == "ds":
         ds = picd.get("DATASHEET", "-")
      else:
         ds = picd.get("PGMSPEC", "-")
      if ds != "-":
         key = int(ds)                                   # numeric index!
         if key in datasheet:                            # DS present
            if datasheet[key].get("TITLE") != None:      # title present
               fp.write("|| %-12s || " % pic
                        + '<a href="' + url + datasheet[key].get("NUMBER") + '.pdf">'
                        + datasheet[key].get("NUMBER") + "</a> || "
                        + datasheet[key].get("DATE")   + " || "
                        + datasheet[key].get("TITLE")  + " ||\n")
            else:
               print "No title found of datasheet", key
         else:
            print "Datasheet number", key, "of", pic, "in", picspecfile, "not found"
   fp.write("\n")
   fp.close()


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
   print "Building", title
   groups = {}
   piclist = picspec.keys()
   for pic in piclist:
      picd = dict(picspec[pic].items())
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

   fp = open(os.path.join(dst,outfile), "w")
   fp.write("#summary " + title + "\n\n----\n\n= " + title + " =\n\n")
   fp.write("== Sorted on DataSheet number ==\n")
   fp.write("=== (see below for a list sorted on PIC type) ===\n\n")
   fp.write("|| *DataSheet* || *Date* || *PIC type* ||\n")
   grouplist = groups.keys()
   grouplist.sort()
   for group in grouplist:
      if group in datasheet:
         fp.write("|| " + '<a href="' + url + datasheet[group].get("NUMBER") + '.pdf">'
                   + datasheet[group].get("NUMBER") + "</a> || "
                   + datasheet[group].get("DATE")   + " || "
                   + " ".join(groups[group]) + "||\n")
      else:
         print "Datasheet", group, "not found"
   fp.write("\n\n----\n\n= " + title + " =\n\n")
   fp.write("== Sorted on PIC type (lowest in the group) ==\n\n")
   fp.write("|| *DataSheet* || *Date* || *PIC type* ||\n")
   grouplist = groups.keys()
   grouplist.sort(key = sort_group_on_pic)
   for group in grouplist:
      if group in datasheet:
         fp.write("|| " + '<a href="' + url + datasheet[group].get("NUMBER") + '.pdf">'
                   + datasheet[group].get("NUMBER") + "</a> || "
                   + datasheet[group].get("DATE")   + " || "
                   + " ".join(groups[group]) + "||\n")
   fp.write("\n")
   fp.close()


if __name__ == "__main__":

   datasheet = {}                                           # new dictionary
   read_datasheet(dslist)                                   # load datasheet info
   picspec = json.load(file(picspecfile))                   # load PIC specific info
   pic_wiki("DataSheets.wiki")
   pic_wiki("ProgrammingSpecifications.wiki")
   group_wiki("PicGroups.wiki")
   group_wiki("PicPgmGroups.wiki")

