
# pic2edc script

import os
import sys
from stat import *
from xml.dom.minidom import parse

"""
  -----------------------------------------------------------------------
  This script is part of a sub-project using MPLAB-X info for Jallib,
  in particular the device files.
  This script uses the MPLAB-X .pic files and creates .edc files,
  which are 'expanded' xml files, iput for the edc2jal script.
  This script is temporary. It will become obsolete
  when the edc2jal script has been converted to Python.
  -----------------------------------------------------------------------
"""

wlist = open("MPLAB-X_VERSION", "r").read().split(' ')
if not ((wlist[0].upper() == "MPLAB-X_VERSION") & (wlist[2].upper() == "SCRIPTVERSION")):
   print "Could not obtain version of MPLAB-X or script from file MPLAB-X_VERSION"
   exit(0)

mplabxversion = wlist[1]
scriptversion = wlist[3]

mplabx = "k:/mplab-x_185/crownking.edc.jar/content/edc"    # MPLAB-X PIC files
# edcdir = "k:/jal/pic2jal/edc_" + mplabxversion             # dir with .edc files
edcdir = "k:/py/dom/edc_" + mplabxversion             # dir with .edc files

picjal3 = ["10f", "12f", "16f", "18f"]
picjal4 = ["10lf", "12lf", "12hv", "16lf", "16hv", "18lf"]


def make_edc(picname, pathname):
   """ create .edc file for picname, using pathname as input """
   print picname
   root = parse(pathname)                             # will perform the xml expansion
   if not os.path.exists(edcdir):
      os.mkdir(edcdir)
   fp = open(edcdir + '/' + picname + ".edc", "w")
   root.writexml(fp, indent="  ")
   fp.close()


def walktree(top):
   """ search .pic files of PICs supported by JalV2
       and deliver these to make_edc()               """
   for f in os.listdir(top):
     pathname = os.path.join(top, f)
     mode = os.stat(pathname).st_mode
     if S_ISDIR(mode):
        walktree(pathname)
     elif S_ISREG(mode):
        fn = os.path.splitext(f)[0][0:].lower()
        if ( fn.startswith("pic") & (fn != "pic16hv540") &
           ((fn[3:6] in picjal3) | (fn[3:7] in picjal4)) ):
           make_edc(fn[3:], pathname)
     else:
        print pathname, "skipped"


if __name__ == "__main__":
   walktree(mplabx)

