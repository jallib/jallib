#!/usr/bin/python
# -----------------------------------------------------------------------
# Title: Analyze TORELEASE and check consistency with Jallib
#
# Author: Rob Hamerling, Copyright (c) 2008..2014, all rights reserved.
#
# Adapted-by:
#
# Revision: $Revision$
#
# Compiler: N/A
#
# This file is part of jallib  http://jallib.googlecode.com
# Released under the BSD license
#              http://www.opensource.org/licenses/bsd-license.php
#
# Description:
# - Read TORELEASE and collect entries on a per-directory basis
#   (2nd level subdirectory for includes, 1st level for others).
# - Collect PICnames used in filenames of sample programs.
#   Check if there is at least 1 blink-a-led sample for each PIC.
# - Check if every sample uses a released device file.
# - Collect and list some statistics for every main library group.
# - Collect Jallib contents (directory tree) and
#    - list unreleased samples
#    - list released samples which include one or more unreleased libraries
# - Sort each of the parts and create a new TORELEASE
#   (report and comment-out duplicate entries)
#
# Sources: none
#
# Notes:
#  - When a commandline argument 'runtype' is specified a slightly more
#    extensive listing is produced: ALL unreleased files are listed.
#    By default unreleased device files and unreleased basic blink-a-led
#    samples are not listed, only counted.
#
# -----------------------------------------------------------------------

import os, sys
import re
import time
from string import maketrans

base       = "k:/jallib"                                    # base directory of local copy of Jallib
libdir     = base + "/include"                              # device files and function libraries
smpdir     = base + "/sample"                               # samples
projdir    = base + "/project"                              # projecta
torelease  = base + "/TORELEASE"                            # TORELEASE
newrelease = 'TORELEASE.NEW'                                # New TORELEASE
report     = 'torelease.lst'                                # Report file

xunderscore = maketrans("_"," ")                            # underscore -> space
xslash      = maketrans("\\","/")                           # backward slash -> forward slash
pic8flash   = re.compile(r"^1(0|2|6|8)(f|lf|hv).*")         # 8 bits flash PIC name pattern

fcount     = {}                                             # file counts
dev        = {}                                             # PIC names in device files
smppic     = {}                                             # PIC names in sample files
blinkpic   = {}                                             # PIC names in blink sample files
f          = {}                                             # parts and their files

missing    = []                                             # in TORELEASE but not in Jallib
lines      = []                                             # contents of TORELEASE
libs       = []                                             # libraries (without path)


# -----------------------------------------------
# Read TORELEASE into a list of lines
# -----------------------------------------------
def read_torelease():
   print "Reading", torelease
   global lines
   ft = open(torelease, "r")
   for ln in ft:
      ln = ln.strip()
      lnlow = ln.lower()
      if ( (lnlow != ln) & (not ln.startswith("#")) ):
         print "Warning: uppercase character(s) fixed in:"
         print "   ", ln
      if ((len(ln) < 2)  |  ln.startswith("#")):            # empty or comment line
         lines.append("")
      else:
         lines.append(lnlow)
   ft.close()


# -----------------------------------------------
# Analyze TORELEASE
# - Check existence of each of the released files
# - Collect the files into groups (parts)
# - Make a list of picnames used in the name of the sample and
#   make a list of picnames used in the name of the blink-samples
#   (for later analysis)
# -----------------------------------------------
def analyze_torelease(fr):
   print "Analyzing", torelease
   global f, lines, libs, smppic, blinkpic, missing         # externs
   linecount = 0
   for ln in lines:
      linecount = linecount + 1                             # line number
      if (ln == ""):                                        # empty (comment)
         continue
      if (os.path.exists(os.path.join(base, ln)) == False): # file not found
         missing.append([linecount, ln])                    # line number and pathspec
      dirs = ln.split("/")
      if (len(dirs) > 1):                                   # at least 2 level directory
         if (dirs[0] == "include"):                         # include file
            part = dirs[1]                                  # part is 2nd level subdirectory
            libs.append(os.path.split(ln)[1])               # add to list of device files and libraries
         else:                                              # sample / project / doc
            part = dirs[0]                                  # part is 1st level subdirectory
         if (part == "sample"):
            word = ln.split("_")
            picname = word[0][7:]
            if (picname != ""):
               smppic[picname] = picname                    # PIC with at least 1 sample
               if (word[1] == "blink"):
                  blinkpic[picname] = picname               # blink sample found for this PIC
         if (f.get(part) == None):                          # new part
            f[part] = []
         f[part].append(ln)                                 # add filespec


# -----------------------------------------------
# Produce some statistics
# - Chech if there is a device file for every sample
# - Count samples in functional groups based on filename
# -----------------------------------------------
def list_counts(fr):
   print "Classify and count released samples in major groups"
   global f
   for smp in f["sample"]:                                  # all samples
      smp = smp[7:-4]                                       # sample name
      word = smp.split("_")
      picname = word[0]
      if (picname != dev.get(picname)):                     # not released device file
         fr.write("  Device file of " + picname + \
                  " for sample " + smp + " not released\n")
      smpname = word[1]
      if (smpname in ("blink", "adc", "i2c", "lcd", "glcd", "network", "pwm", "pwm2", "serial", "usb")):
         fcount[smpname] = fcount.get(smpname, 0) + 1
      else:
         fcount["other"] = fcount.get("other", 0) + 1    # other sample

   total_libraries = len(f["external"])   + \
                     len(f["filesystem"]) + \
                     len(f["jal"])        + \
                     len(f["networking"]) + \
                     len(f["peripheral"]) + \
                     len(f["protocol"])
   total_samples = 0
   for p in fcount:
      total_samples = total_samples + fcount[p]

   fr.write("\n\n")
   fr.write("TORELEASE contains %4d Device files\n" % (len(f["device"]) - 1))
   fr.write("                   %4d Function libraries in the following categories:\n" % (total_libraries))
   fr.write("                        %4d External\n" % (len(f["external"])))
   fr.write("                        %4d FileSystem\n" % (len(f["filesystem"])))
   fr.write("                        %4d JAL Extension\n" % (len(f["jal"])))
   fr.write("                        %4d Networking\n" % (len(f["networking"])))
   fr.write("                        %4d Peripheral\n" % (len(f["peripheral"])))
   fr.write("                        %4d Protocol\n" % (len(f["protocol"])))
   fr.write("                   %4d Samples in following categories (based on primary library):\n" \
                                    % (total_samples))
   fr.write("                        %4d ADC\n" % (fcount["adc"]))
   fr.write("                        %4d Blink-a-led\n" % (fcount["blink"]))
   fr.write("                        %4d I2C\n" % (fcount["i2c"]))
   fr.write("                        %4d [G]LCD\n" % (fcount["lcd"] + fcount["glcd"]))
   fr.write("                        %4d Networking\n" % (fcount["network"]))
   fr.write("                        %4d PWM\n" % (fcount["pwm"] + fcount["pwm2"]))
   fr.write("                        %4d Serial\n" % (fcount["serial"]))
   fr.write("                        %4d USB\n" % (fcount["usb"]))
   fr.write("                        %4d Other\n" % (fcount["other"]))
   fr.write("                   %4d Project files\n" % (len(f["project"])))
   fr.write("                   %4d Documentation files\n" % (len(f["doc"])))
   if (f.get("misc") != None):
      fr.write("                   %4d Other files\n" % (len(f["misc"])))
   fr.write("\n")


# -----------------------------------------------
# Check blink samples against device files
# - Make a list of picnames from the device files
# - Check if there is a blink-a-led sample for every device file
# -----------------------------------------------
def check_blink(fr):
   print "Checking if a blink sample is released for every released device file"
   global f, dev
   for df in f["device"]:
      if (df == "include/device/chipdef_jallib.jal"):
         continue
      picname = df[15:-4]
      dev[picname] = picname                                 # remember device file
      if (os.path.exists(os.path.join(base, df)) == True):   # device file present
         if (blinkpic.get(picname) == None):
            fr.write("  No basic blink sample for " + picname + "\n")
         elif (blinkpic[picname] != picname):
            fr.write("  No basic blink sample for " + picname + "\n")


# ---------------------------------------------
# List unreleased libraries
# - Walk the include directory tree
#   to find unreleased libraries and device files
# - Check if samples use unreleased device files
# ---------------------------------------------
def list_unreleased_libraries(fr):
   print "Searching for unreleased libraries"
   global libs
   fr.write("\nUnreleased libraries")
   if (runtype == None):
      fr.write(" (excluding unreleased device files)")
   else:
      fr.write(" and device files")
   fr.write("\n--------------------------------------------------------\n")
   unlisted = 0
   unlisteddevice = 0
   for (root, dirs, files) in os.walk(libdir):              # whole tree (incl subdirs!)
      dirs.sort()
      files.sort()
      for file in files:
         picname = file[:-4]                                # filename less extension
         fs = os.path.join(root,file)                       # full pathspec
         fs.translate(xslash)                               # backward to forward slash
         fs = fs[(len(base) + 1):]                          # remove base prefix
         if (fs not in lines):
            unlisted = unlisted + 1
            if (fs.startswith("include/device/")):          # unreleased device file
               unlisteddevice = unlisteddevice + 1
               if (runtype != None):
                  fr.write(fs + "\n")
               if (smppic.get(picname) != None):
                  fr.write(fs + "  (unreleased device file, but sample program(s) released!)\n")
            else:                                           # function library
               fr.write(fs + "\n")                          # unreleased library
   if (runtype != None):
      fr.write("\n%d unreleased libraries and device files\n\n" % (unlisted))
   else:
      fr.write("\n%d unreleased libraries + %d unreleased device files\n\n" % \
                (unlisted - unlisteddevice, unlisteddevice))


# ---------------------------------------------
# List unreleased samples or use of unreleased libraries or device files
# - Walk the sample directory tree
#   to find unreleased samples
# - Check if sample name and included device file are matching
# - Check if unreleased libraries are included
# ---------------------------------------------
def list_unreleased_samples(fr):
   print "Searching for unreleased samples and checking for include of unreleased libraries"
   fr.write("\nUnreleased samples")
   if (runtype == None):
      fr.write(" (excluding unreleased basic blink samples)")
   else:
      fr.write(" (including basic blink samples)")
   fr.write('\n-------------------------------------------------------\n')

   unlisted = 0
   unlistedblink = 0
   unreleasedinclude  = []

   for (root, dirs, files) in os.walk(smpdir):              # whole tree (incl subdirs!)
      dirs.sort()
      files.sort()
      for file in files:
         word = file.split("_")
         picname = word[0]
         fs = os.path.join(root,file)                       # full pathspec
         fs.translate(xslash)                               # backward to forward slash
         fs = fs[(len(base) + 1):]                          # remove base prefix
         if (fs not in lines):                              # unreleased sample
            unlisted = unlisted + 1
            if (word[1] == "blink"):
               unlistedblink = unlistedblink + 1
               if (runtype != None):                        # blink samples to be listed
                  fr.write(fs + "\n")                       # list unreleased blink sample
            else:                                           # not a blink sample
               fr.write(fs + "\n")                          # list unreleased sample
         else:                                              # found sample in torelease
            fi = open(os.path.join(root,file))              # full pathspec
            lncount = 0
            for ln in fi:
               lncount = lncount + 1                        # line number
               ln = ln.lower().strip()
               if ((len(ln) < 2) | ln.startswith("--") | ln.startswith(";")):    # empty or comment line
                  continue
               word = ln.split()
               if ((word[0] == "include") & (len(word) > 1)):
                  if (re.match(pic8flash, word[1]) != None):   # probably device file
                     if (word[1] != picname):                  # not matching!
                        print "Sample " + fs + " includes wrong device file: ", word[1], "in line", lncount
                     elif (word[1] not in dev):
                        print "Sample " + fs + " includes unreleased device file: ", word[1], "in line", lncount
                        unreleasedinclude.append(file)
                  elif (word[1] + ".jal" not in libs):
                     print "sample", file, "includes an unreleased library:", word[1], "in line", lncount
                     unreleasedinclude.append(file)
            fi.close()

   if (runtype != None):
      fr.write("\n%d unreleased sample files\n" % (unlisted))
   else:
      fr.write("\n%d unreleased sample files + %d unreleased basic blink samples\n" % \
                (unlisted - unlistedblink, unlistedblink))

   if (len(unreleasedinclude) > 0):
      fr.write("\nSamples in TORELEASE which include unreleased libraries\n")
      fr.write("-------------------------------------------------------\n\n")
      for f in unreleasedinclude:
         fr.write(f + "\n")
      fr.write("\n")


# ---------------------------------------------
# List unreleased project files
# - Walks project directory tree to find unreleased project files
# ---------------------------------------------
def list_unreleased_projects(fr):
   print "Searching for unreleased project files"
   fr.write("\n\nUnreleased Project files\n")
   fr.write("------------------------\n")
   unlisted = 0
   for (root, dirs, files) in os.walk(projdir):             # whole tree (incl subdirs!)
      dirs.sort()
      files.sort()
      for file in files:
         fs = os.path.join(root,file)                       # full pathspec
         fs.translate(xslash)                               # backward to forward slash
         fs = fs[(len(base) + 1):]                          # remove base prefix
         if (fs not in lines):
            unlisted = unlisted + 1
            fr.write(fs + "\n")                             # list unreleased sample
   fr.write("\n%d unreleased project files\n\n" % (unlisted))


# ---------------------------------------------
# List files listed in TORELEASE but missing in Jallib
# ---------------------------------------------
def list_missing_files(fr):
   print "Listing missing Jallib files"
   if (len(missing) > 0):
      fr.write("\n\nFiles listed in TORELEASE, but missing in Jallib\n")
      fr.write("------------------------------------------------\n")
      fr.write("Line#  File\n")
      for f in missing:
         fr.write("%4d   %s\n" % (f[0], f[1]))
      fr.write("\n")


# ---------------------------------------------
# Create new TORELEASE
# ---------------------------------------------
def create_new_torelease():
   print "Creating new TORELEASE:", torelease
   fn = open(newrelease, "w")
   fn.write("# Title: List of files to release\n")
   fn.write("#\n# $Revision$\n#\n")
   listpart(fn, "device", "Device files")
   listpart(fn, "external", "Externals")
   listpart(fn, "filesystem", "FileSystems")
   listpart(fn, "jal", "JAL extensions")
   listpart(fn, "networking", "Networking")
   listpart(fn, "peripheral", "Peripherals")
   listpart(fn, "protocol", "Protocols")
   listpart(fn, "project", "Projects")
   listpart(fn, "sample", "Samples")
   listpart(fn, "doc", "Static documentation (only in jallib-pack)")
   fn.close()


# -----------------------------------------------
# Write members of subdirectory to new torelease
# after being sorted on name
# Comment out duplicates
# -----------------------------------------------
def listpart(fn, part, title):
   global f
   fn.write("# " + title + "\n")
   f[part].sort(key = sortpart)                             # custom sort!
   for i in range(len(f[part])):                            # list this part
      p = i - 1                                             # index of previous item
      if (f[part][p] == f[part][i]):
         fn.write("# " + f[part][p] + "   duplicate!\n")
      else:
         fn.write(f[part][i] + "\n")
   fn.write("\n")


# ---------------------------------------------
# Custom sort of files
# Chars '_' in name treated as ' '
# such that e.g. 16f72_xxx appears before 16f722_xxx
# ---------------------------------------------
def sortpart(key):
   return key.translate(xunderscore)                        # underscore -> space


# --------------------------------------------------------------
# mainline
# --------------------------------------------------------------
def main():
   read_torelease()
   fr = open(report, "w")
   fr.write("\nAnalysis of " +  torelease + \
            " dd " + time.ctime() + " (local time)\n\n")
   analyze_torelease(fr)
   check_blink(fr)
   list_counts(fr)
   list_unreleased_libraries(fr)
   list_unreleased_samples(fr)
   list_unreleased_projects(fr)
   list_missing_files(fr)
   create_new_torelease()
   fr.close()
   print "See", report, "for results."


# === start ====================================================
# process commandline parameters, start process
# ==============================================================

if (__name__ == "__main__"):

   runtype = None
   if (len(sys.argv) > 1):
      runtype = sys.argv[1].upper()

   print "Checking", torelease, "against content of Jallib"
   if (runtype == None):
      print '   Excluding unreleased device files and basic blink samples'
      print '   To include these specify any non blank character as argument'

   main()


