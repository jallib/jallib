
import os, sys, stat
import time
import datetime
from datetime import date
import json


"""
 CreateDSwikis.cmd - create wiki files:
                     * Datasheet
                     * Programming Specifications
                     * PICs with the same Datasheet
                     * PICs with the same Programming Specifications
 Uses: devicespecific,json to obtain datasheet numbers of a PIC
       datasheet.list to obtain the latest suffix and title of the datasheets
       directory with PIC datasheets (pf files) to obtain dates of the datasheets
"""

#  input files (may require changes for other systems or platforms)
pdfdir      = "n:/picdatasheets"                            # dir with datasheets (local)
picspecfile = "k:/jallib/tools/devicespecific.json"         # PIC specific properties
dslist      = "k:/jallib/tools/datasheet.list"              # datasheet number/title file

#  output files
dst         = "k:/jallib/wiki"                              # output path
dswiki      = "DataSheets.wiki"                             # out: DS wiki
pswiki      = "ProgrammingSpecifications.wiki"              # out: PS wiki
dsgroupwiki = "PicGroups.wiki"
psgroupwiki = "PicPgmGroups.wiki"
url         = 'http://ww1.microchip.com/downloads/en/DeviceDoc/' # Microchip site


def read_datasheet(infile):
   """ fill dictionary 'datasheet' with number, title and date """
   fp = open(infile, "r")                             # datasheet list
   for ln in fp:
      w = ln.split(" ", 1)                            # number / title
      dd = w[0]
      key = int(dd[0:len(dd)-1])                      # strip letter, numeric index
      fd = os.path.getmtime(os.path.join(pdfdir,dd.lower()+".pdf"))
      fd = time.strftime("%Y/%m", time.gmtime(fd))    # only year/month
      ds = w[1].strip()                               # title
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
   fp.write("|| *PIC* || *Number* || *Date* || *Datasheet Title* ||\n")
   piclist = picspec.keys()
   piclist.sort()
   for pic in piclist:
      picd = dict(picspec[pic].items())
      if type == "ds":
         ds = picd.get("DATASHEET", "-")
      else:
         ds = picd.get("PGMSPEC", "-")
      if ds != "-":
         dsnum = int(ds)                                    # numeric index!
         fp.write("|| " + pic + " || "
                  + "<a " + url + datasheet[dsnum].get("NUMBER") + ">"
                  + datasheet[dsnum].get("NUMBER") + "</a> || "
                  + datasheet[dsnum].get("DATE")   + " || "
                  + datasheet[dsnum].get("TITLE")  + " ||\n")
   fp.write("\n")
   fp.close()


def group_wiki(outfile):
   """ create wiki of groups of PICs with the same datasheet or programming specifications """

   def sort_group_on_pic(group):
      """ custom sort on first PIC of the group """
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
         dsnum = int(ds)                        # for numeric sorting
         if dsnum not in groups:
            groups[dsnum] = [pic]
         else:
            groups[dsnum].append(pic)
            groups[dsnum].sort()

   fp = open(os.path.join(dst,outfile), "w")
   fp.write("#summary " + title + "\n\n----\n\n= " + title + " =\n\n")
   fp.write("== sorted on datasheet number ==\n")
   fp.write("=== see below for a list sorted on PIC type) ===\n\n")
   fp.write("|| *DataSheet* || *Date* || *PIC type* ||\n")

   grouplist = groups.keys()
   grouplist.sort()
   for group in grouplist:
      fp.write("|| " + "<a " + url + datasheet[group].get("NUMBER") + ">"
                + datasheet[group].get("NUMBER") + " || "
                + datasheet[group].get("DATE")   + " || "
                + " ".join(groups[group]) + "||\n")

   fp.write("\n\n----\n\n= " + title + " =\n\n")
   fp.write("== sorted on PIC type (lowest in the group) ==\n\n")
   fp.write("|| *DataSheet* || *Date* || *PIC type* ||\n")
   grouplist = groups.keys()
   grouplist.sort(key = sort_group_on_pic)
   for group in grouplist:
      fp.write("|| " + "<a " + url + datasheet[group].get("NUMBER") + ">"
                + datasheet[group].get("NUMBER") + " || "
                + datasheet[group].get("DATE")   + " || "
                + " ".join(groups[group]) + "||\n")
   fp.write("\n")

   fp.close()


if __name__ == "__main__":

   datasheet = {}
   read_datasheet(dslist)
   picspec = json.load(file(picspecfile))
   pic_wiki(dswiki)
   pic_wiki(pswiki)
   group_wiki(dsgroupwiki)
   group_wiki(psgroupwiki)


