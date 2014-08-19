#!/usr/bin/python
# -----------------------------------------------------------------------
# Title: Process TORELEASE file to check consistency with Jallib
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
# - read TORELEASE and collect entries into
#   on a per-directory ('part') basis (1st level subdirectory)
#   collect PICnames used in filenames of sample programs
# - check if there is a basic blink-a-led sample for every device file
# - check if there is a device file for every sample
# - collect and list some statistics for every main library group
# - collect Jallib contents (directory tree) and
#    - list unreleased files
#    - list released files which include one or more unreleased libraries
# - sort each of the parts (on first level directory)
#   and create new TORELEASE
# - report and comment-out duplicate entries
#
# Sources: none
#
# Notes:
#  - When a commandline argument 'runtype' is specified a more extensive
#    listing is produced: ALL unrelease files are listed,
#    (by default unreleased device files and unreleased basic blink-a-led
#     samples are not listed, only counted).
#
# -----------------------------------------------------------------------

import os, sys
import re
import time
from string import maketrans

base       = "k:/jallib"                                    # base Jallib directory
libdir     = base + "/include"                              # libraries
smpdir     = base + "/sample"                               # samples
projdir    = base + "/project"                              # project files
torelease  = base + "/TORELEASE"                            # TORELEASE file
newrelease = 'TORELEASE.NEW'                                # release list
report     = 'torelease.lst'                                # script output

xunderscore = maketrans("_"," ")                            # from -> to
xslash      = maketrans("\\","/")

devpfx = ("10f", "10l", "12f", "12h", "12l", "16f", "16h", "16l", "18f", "18l")

fcount     = {}                                             # file counts
dev        = {}                                             # PIC names in device files
smppic     = {}                                             # PIC names in sample files
blinkpic   = {}                                             # PIC names in blink sample files
f          = {}                                             # parts and their files

missing    = []                                             # in TORELEASE but not in Jallib
lines      = []                                             # contents of TORELEASE
libs       = []                                             # libraries (without path)



# -----------------------------
def read_and_check_torelease(fr):
   print "Analysing", torelease
   global f, lines, libs, smppic, blinkpic                  # externs
   ft = open(torelease, "r")
   for ln in ft:
      ln = ln.lower().strip()
      if ((len(ln) < 2)  |  ln.startswith("#")):            # empty or comment line
         lines.append("")
      else:
         lines.append(ln)
   ft.close()

   blink_sample_count = 0
   for ln in lines:
      if (os.path.exists(os.path.join(base, ln)) == False):   # file not found
         fr.write("  In TORELEASE but file not found: " + ln + "\n")
         missing.append(ln)
      tree = ln.split("/")
      if (ln.startswith("include/device/")):
         part = "device"
         libs.append(os.path.split(ln)[1])
      elif (ln.startswith("include/external/")):
         part = "external"
         libs.append(os.path.split(ln)[1])
      elif (ln.startswith("include/filesystem/")):
         part = "filesystem"
         libs.append(os.path.split(ln)[1])
      elif (ln.startswith("include/jal/")):
         part = "jal"
         libs.append(os.path.split(ln)[1])
      elif (ln.startswith("include/networking/")):
         part = "network"
         libs.append(os.path.split(ln)[1])
      elif (ln.startswith("include/peripheral/")):
         part = "peripheral"
         libs.append(os.path.split(ln)[1])
      elif (ln.startswith("include/protocol/")):
         part = "protocol"
         libs.append(os.path.split(ln)[1])
      elif (ln.startswith("project/")):
         part = 'project'
      elif (ln.startswith("doc/")):
         part = "doc"
      elif (ln.startswith("sample/")):
         part = "sample"
         word = ln.split("_")
         picname = word[0][7:]
         if (picname != ""):
            smppic[picname] = picname                       # PIC with at least 1 sample
            if (word[1] == "blink"):
               blink_sample_count = blink_sample_count + 1  # count 'm
               blinkpic[picname] = picname                  # blink sample found for this PIC
      else:
         if (ln != ""):
            print "Unrecognised entry:", ln
            part = "misc"
         else:
            part = "comment"
      if (f.get(part) == None):
         f[part] = []
      f[part].append(ln)


# -----------------------------
def check_blink(fr):
   print "Checking if a blink sample is released for every released device file"
   global f, dev
   for df in f["device"]:
      if (df == "include/device/chipdef_jallib.jal"):
         continue
      picname = df[15:-4]
      if (blinkpic.get(picname) == None):
         fr.write("  No basic blink sample for " + picname + "\n")
      elif (blinkpic[picname] != picname):
         fr.write("  No basic blink sample for " + picname + "\n")
      dev[picname] = picname                                 # remember device file
   fr.write("  Released device files: %d\n" % (len(f["device"]) - 1))     # excl chipdef_jallib


# -----------------------------
def list_counts(fr):
   print "Classify and count released samples in major groups"
   global f
   for smp in f["sample"]:                                     # all samples
      smp = smp[7:-4]                                          # sample name
      word = smp.split("_")
      picname = word[0]
      if (picname != dev.get(picname)):                        # not released device file
         fr.write("  Device file of " + picname + \
                  " for sample " + smp + " not released\n")
      smpname = word[1]
      if (smpname in ("blink", "adc", "i2c", "lcd", "glcd", "network", "pwm", "pwm2", "serial", "usb")):
         fcount[smpname] = fcount.get(smpname, 0) + 1
      else:
         fcount["othersamples"] = fcount.get("othersamples", 0) + 1           # other sample

   total_libraries = len(f["external"])   + \
                     len(f["filesystem"]) + \
                     len(f["jal"])        + \
                     len(f["network"])    + \
                     len(f["peripheral"]) + \
                     len(f["protocol"])
   total_samples = 0
   for p in fcount:
      total_samples = total_samples + fcount[p]

   fr.write("\n\n")
   fr.write("TORELEASE contains %4d Device files\n" % (len(f["device"]) - 1))
   fr.write("                   %4d Function libraries\n" % (total_libraries))
   fr.write("                   %4d Samples in following categories (based on primary library)\n" \
                                    % (total_samples))
   fr.write("                       %4d ADC samples\n" % (fcount["adc"]))
   fr.write("                       %4d Blink-a-led samples\n" % (fcount["blink"]))
   fr.write("                       %4d I2C samples\n" % (fcount["i2c"]))
   fr.write("                       %4d [G]LCD samples\n" % (fcount["lcd"] + fcount["glcd"]))
   fr.write("                       %4d Networking samples\n" % (fcount["network"]))
   fr.write("                       %4d PWM samples\n" % (fcount["pwm"] + fcount["pwm2"]))
   fr.write("                       %4d Serial samples\n" % (fcount["serial"]))
   fr.write("                       %4d USB samples\n" % (fcount["usb"]))
   fr.write("                       %4d Other samples\n" % (fcount["othersamples"]))
   fr.write("                   %4d Project files\n" % (len(f["project"])))
   fr.write("                   %4d Documentation files\n" % (len(f["doc"])))
   if (f.get("misc") != None):
      fr.write("                   %4d Other files\n" % (len(f["misc"])))
   fr.write("\n")


# -----------------------------
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
   for (root, dirs, files) in os.walk(libdir):                 # whole tree (incl subdirs!)
      dirs.sort()
      files.sort()
      for file in files:
         picname = file[:-4]                                   # filename less extension
         fs = os.path.join(root,file)                          # full pathspec
         fs.translate(xslash)                                  # backward to forward slash
         fs = fs[(len(base) + 1):]                             # remove base prefix
         if (fs not in lines):
            unlisted = unlisted + 1
            if (fs.startswith("include/device/")):             # unreleased device file
               unlisteddevice = unlisteddevice + 1
               if (runtype != None):
                  fr.write(fs + "\n")
               if (smppic.get(picname) != None):
                  fr.write(fs + "  (unreleased device file, but sample program(s) released!)\n")
            else:                                              # function library
               fr.write(fs + "\n")                             # unreleased library
   if (runtype != None):
      fr.write("\n%d unreleased libraries and device files\n\n" % (unlisted))
   else:
      fr.write("\n%d unreleased libraries + %d unreleased device files\n\n" % \
                (unlisted - unlisteddevice, unlisteddevice))


# -----------------------------
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

   for (root, dirs, files) in os.walk(smpdir):                 # whole tree (incl subdirs!)
      dirs.sort()
      files.sort()
      for file in files:
         word = file.split("_")
         picname = word[0]
         fs = os.path.join(root,file)                          # full pathspec
         fs.translate(xslash)                                  # backward to forward slash
         fs = fs[(len(base) + 1):]                             # remove base prefix
         if (fs not in lines):
            unlisted = unlisted + 1
            if (word[1] == "blink"):
               unlistedblink = unlistedblink + 1
               if (runtype != None):                           # blink samples to be listed
                  fr.write(fs + "\n")                          # list unreleased blink sample
            else:                                              # not a blink sample
               fr.write(fs + "\n")                             # list unreleased sample

         else:                                                 # found sample in torelease
            fi = open(os.path.join(root,file))                 # full pathspec
            lncount = 0
            for ln in fi:
               lncount = lncount + 1                           # line number
               ln = ln.lower().strip()
               if ((len(ln) < 2) | ln.startswith("--") | ln.startswith(";")):    # empty or comment line
                  continue
               word = ln.split()
               if ((word[0] == "include") & (len(word) > 1)):
                  if (word[1][:3] in devpfx):                  # probably device file
                     if (word[1] != picname):                  # not matching!
                        print "Sample " + fs + " includes wrong device file: ", word[1], "in line", lncount
                  if (word[1] + ".jal" not in libs):
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

   fr.write("\n\nUnreleased Project files\n")
   fr.write("------------------------\n")
   unlisted = 0
   for (root, dirs, files) in os.walk(projdir):                # whole tree (incl subdirs!)
      dirs.sort()
      files.sort()
      for file in files:
         fs = os.path.join(root,file)                          # full pathspec
         fs.translate(xslash)                                  # backward to forward slash
         fs = fs[(len(base) + 1):]                             # remove base prefix
         if (fs not in lines):
            unlisted = unlisted + 1
            fr.write(fs + "\n")                             # list unreleased sample
   fr.write("\n%d unreleased project files\n\n" % (unlisted))

   if (len(missing) > 0):
      fr.write("\n\nFiles listed in TORELEASE, but missing in Jallib\n")
      fr.write("------------------------------------------------\n")
      fr.write("Line#  File\n")
      for f in missing:
         fr.write("%4d   %s\n" % (lines.index(f), f))
      fr.write("\n")


# ---------------------------------------------
def create_new_torelease():
   print "Creating new", torelease, "(sorted, duplicates commented out)"
   fn = open(newrelease, "w")
   fn.write("# Title: List of files to release\n")
   fn.write("#\n")
   fn.write("# $Revision$\n")
   fn.write("#\n")
   listpart(fn, "device", "Device files")
   listpart(fn, "external", "Externals")
   listpart(fn, "filesystem", "FileSystems")
   listpart(fn, "jal", "JAL extensions")
   listpart(fn, "network", "Networking")
   listpart(fn, "peripheral", "Peripherals")
   listpart(fn, "protocol", "Protocols")
   listpart(fn, "project", "Projects")
   listpart(fn, "sample", "Samples")
   listpart(fn, "doc", "Static documentation (only in jallib-pack)")
   fn.close()



# -----------------------------------------------
# Write members of subdirectory to new torelease
# after being sorted on name
# -----------------------------------------------
def listpart(fn, part, title):
   fn.write("# " + title + "\n")
   f[part].sort(key = sortpart)                             # custom sort!
   for i in range(len(f[part])):                            # list this part
      p = i - 1
      if (f[part][p] == f[part][i]):
         fn.write("# " + f[part][p] + "   duplicate!\n")
      else:
         fn.write(f[part][i] + "\n")
   fn.write("\n")


# ---------------------------------------------
# Sorting members of 1st level subdirectory.
# Chars '_' in name treated as ' '
# such that 16f72_xxx appears before 16f722_xxx
# ---------------------------------------------
def sortpart(key):
   return key.translate(xunderscore)                        # underscore -> space


# --------------------------------------------------------------
def main():
   fr = open(report, "w")
   fr.write("\nAnalysis of " +  torelease + \
            " dd " + time.ctime() + " (local time)\n\n")
   read_and_check_torelease(fr)
   check_blink(fr)
   list_counts(fr)
   list_unreleased_libraries(fr)
   list_unreleased_samples(fr)
   create_new_torelease()
   fr.close()
   print "See", report, "for the detailed results."


# === start ====================================================
# process commandline parameters, start process, time execution
# ==============================================================

if (__name__ == "__main__"):

   runtype = None
   if (len(sys.argv) > 1):
      runtype = sys.argv[1].upper()

   if (runtype == None):
      print '   Excluding unreleased device files and basic blink samples'
      print '   To include these specify any non blank character as argument'

   elapsed = time.time()
   main()
   elapsed = time.time() - elapsed
   print "Processed in %.1f seconds" % (elapsed)


