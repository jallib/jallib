#!/usr/bin/env python3
"""
Title: Collect datasheet and picname per PPS_group from device files

Author: Rob Hamerling, Copyright (c) 2017..2017, all rights reserved.

Adapted-by:

Revision: $Revision$

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the BSD license https://www.opensource.org/licenses/bsd-license.php

Description:
    Collect datasheet and picname per PPS_group from device files
    Format data as table to be inserted in devicefiles.html
    Assumes that every device file has datasheet and PPS_GROUP specified.

Sources: N/A

Notes:
   - The PPS groups table contains only PPS-GROUPS 1 to 5
     (group 0 means 'no PPS support' and is not so relevant to document)
   - Adapt the platform dependent variables to your situation


"""

from pic2jal_environment import check_and_set_environment
base, mplabxversion = check_and_set_environment()    # obtain environment variables
if (base == ""):
   exit(1)

import os
import glob

devdir = os.path.join(base, "test")             # new device files
ppstab = os.path.join(base, "pps_groups.html")  # new PPS_GROUPS html table


pps_group = { "PPS_1" : [],
              "PPS_2" : [],
              "PPS_3" : [],
              "PPS_4" : [],
              "PPS_5" : []
             }

ds_pics = {}                                    # pics sharing the same datasheet
                                                # key = datasheet, value = list of pics
pps_flav = {}                                   # PPS flavor per PIC
                                                # key = pps_flavor, value = list of pics


# --------------------------------------------------------
def build_pps_dicts(devlist):
   """ file the ds_pics and pps_flav dictionaries
   """

   global ds_pics, pps_flav
   devlist.sort()
   for devf in devlist:
      picname = os.path.splitext(os.path.split(devf)[1])[0]   # get name of pic
      try:
         with open(devf, "r") as fd:
            ln = " "
            while not ln.startswith("const  byte  DATASHEET[] ="):
               ln = fd.readline()
            ds = int(ln.split()[-1].strip('"')[:-1])        # datasheet number without suffix
            if ds in ds_pics:
               ds_pics[ds].append(picname)
            else:
               ds_pics[ds] = [picname]

            while not ln.startswith("const PPS_GROUP             = PPS_"):
               ln = fd.readline()
            pg = ln.split()[3].strip()
            if pg in pps_group:
               if ds not in pps_group[pg]:
                  pps_group[pg].append(ds)
      except:
         print("   Failed to open:", devf)
         break


# ------------------------------------------------------
def create_pps_table():
   """ create (part of) HTML document to embedded in devicefiles.html
   """
   try:
      with open(ppstab, "w") as fl:
         fl.write("\n<table>\n")
         fl.write("<tr><th>PPS group <th>Datasheet <th>PICs </tr>\n\n")
         pglist = list(pps_group.keys())
         pglist.sort()
         for pg in pglist:
            pps_group[pg].sort()
            fl.write("<tr><td>%s</tr>\n" % pg)
            dslist = pps_group[pg]
            dslist.sort()
            for ds in dslist:
               fl.write("<tr><td>          <td>%8d<td>" % ds)
               piclist = ds_pics[ds]
               piclist.sort
               for p in piclist:
                  fl.write(" %s" % (p))
               fl.write("</tr>\n")
            fl.write("\n")
         fl.write("</table>\n\n")
   except:
      print("Failed to create html table:", ppstab);




# === E N T R Y  P O I N T  ===

if (__name__ == "__main__"):

   print("Building PPS groups table for devicefiles.html")

   devlist = glob.glob(os.path.join(devdir, "1?f*.jal"))    # check for some device files

   if (len(devlist) > 0):
      build_pps_dicts(devlist)               # file the dictionaries
      create_pps_table()                     # create PPS table

   else:
      print("No device files in", devdir)
      sys.exit(1)

