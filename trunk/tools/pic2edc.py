
# pic2edc - expand MPLAB-X .pic files

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

scriptversion = "0.0.16"
mplabxversion = "185"

mplabx = "k:/mplab-x_" + mplabxversion + "/crownking.edc.jar/content/edc"    # MPLAB-X .pic files
edcdir = "k:/jal/pic2jal/edc_" + mplabxversion             # output: dir with .edc files

pictypes = ( "10f", "10l", "12f", "12h", "12l", "16f", "16h", "16l", "18f", "18l" )

def make_edc(picname, pathname):
   """ create .edc file for picname, using pathname as input """
   print picname
   root = parse(pathname)                             # performs the expansion
   fp = open(edcdir + '/' + picname + ".edc", "w")
   root.writexml(fp)
   fp.close()


def walktree(top):
   """ search .pic files of PICs supported by JalV2
       and deliver these to make_edc()               """
   flist = os.listdir(top)
   for f in flist:
     pathname = os.path.join(top, f)
     mode = os.stat(pathname).st_mode
     if S_ISDIR(mode):
        walktree(pathname)
     elif S_ISREG(mode):
        fn = os.path.splitext(f)[0][0:].lower()
        if (fn.startswith("pic") & (fn[3:6] in pictypes)):   # only JalV2 supported PICs
           make_edc(fn[3:], pathname)


if __name__ == "__main__":

   wlist = open("MPLAB-X_VERSION", "w")               # info for edc2jal script
   wlist.write("MPLAB-X_VERSION " + mplabxversion + " ScriptVersion " + scriptversion)
   wlist.close()

   if not os.path.exists(edcdir):                     # make sure output directory exists
      os.mkdir(edcdir)

   walktree(mplabx)                                   # create .edc files

