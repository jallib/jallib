#!/usr/bin/env python3
"""
Title: Compile all Jallib samples

Author: Rob Hamerling, Copyright (c) 2015..2017, all rights reserved.
        Rob Jansen,    Copyright (c) 2018..2024, all rights reserved.

Adapted-by: 

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the ZLIB license http://www.opensource.org/licenses/zlib-license.html

Description:
  Python script to compile Jallib sample programs with new device files.
  Blink-a-led samples will be skipped: supposedly compiled in
  generation cycle of device files.

Notes: - For the samples and libraries the latest jallib 'bee' package
         is used since it has the Jallib distribution structure and the
         latest libraries and all in one directory.
         Howover the new device files are used in stead of those of jallib bee
         by putting its include path in front of the bee include path.
         (Include sequence dependency is a JalV2 compiler property).
       - Blink-a-led samples are skipped: supposedly already validated/compiled
         with the generation of new device files.
       - Sample source and compiler output are preserved when any errors or
         warnings are reported in log files in the 'log' directory
         Otherwise output is discarded.
       - Not all types of compiler failures maybe catched!
       - The implementation is a single-queue-multi-server process.
         Sometimes one or more sub-processes terminate prematurely
         for an unknown reason.
"""

from pic2jal_environment import check_and_set_environment
base, mplabxversion = check_and_set_environment()              # obtain environment variables
if (base == ""):
   exit(1)

import os
import time
import subprocess
import queue
import multiprocessing as mp
import fnmatch
import shutil
import platform

scriptversion   = "1.0"
scriptauthor    = "Rob Hamerling"

platform_name = platform.system()

# --- platform dependent paths
if (platform_name == "Linux"):
   jallib   = os.path.join("/", "media", "ramdisk", "jallib-master")      # local copy Jallib master
   compiler = os.path.join(os.getcwd(), "jalv2-x86-64")        # compiler (in current directory)
elif (platform_name == "Windows"):
   jallib   = os.path.join("D:\\", "GitHub", "jallib")         # local copy jallib master
   compiler = os.path.join(os.getcwd(), "jalv2.exe")           # compiler (in current directory)
elif (platform_name == "Darwin"):
   jallib   = os.path.join("/", "media", "ramdisk", "jallib-master")      # local copy Jallib master
   compiler = os.path.join(os.getcwd(), "jalv2osx")            # compiler (in current directory)
else:
   print("Please add platform specific info to this script!")
   exit(1)

# --- common
smpdir  = os.path.join(jallib, "sample")                       # directory with Jallib samples
incldir = os.path.join(jallib, "include")                      # Jallib include directory tree
libdir  = os.path.join(base, "lib")                            # directory with collected libraries
devdir  = os.path.join(base, "device")                         # directory with new device files
logdir  = os.path.join(base, "log")                            # log files

if (os.path.exists(logdir) == False):
   os.makedirs(logdir)

q = mp.Queue()                                                 # create message queue

def pcompile(q):                                                # slave process
   """ Compile samples in queue
   Store compiler output in .log file when compile error(s) or warning(s)
   """
   print("Starting process:", os.getpid())
   cmdlist = [compiler, "-no-hex", "-no-asm", "-no-codfile", "-s", devdir, "-s", libdir]
   smpcount = 0
   errcount = 0
   os.chdir(logdir)                                            # make log directory current
   print("pcompile samples in queue:", q.qsize())
   while True:						                                 # until queue empty
      try:
         sample = q.get(False)                                 # next sample in queue
         shutil.copy2(os.path.join(smpdir, sample), logdir)    # copy sample to working directory
         flog = sample[:-3] + "log"                            # .jal -> .log
         if (os.path.exists(flog)):  			                  # remove if it exists
            os.remove(flog)
         try:
            log = subprocess.check_output(cmdlist + [sample],
                                          stderr=subprocess.STDOUT,
                                          universal_newlines=True,
                                          shell=False)
            loglist = log.split()                              # make it a list of strings
            numerrors = int(loglist[-4])                       # get number of errors
            numwarnings = int(loglist[-2])                     # and warnings
            if ((numerrors == 0) and (numwarnings == 0)):
               smpcount += 1                                   # OK! (zero errors, zero warnings)
               os.remove(sample)
            else:
               errcount += 1                                   # issue
               with open(flog, "w") as fp:
                  fp.write(log)                                # store compiler output
               print(sample, numerrors, "errors", numwarnings, "warnings")
               print("See", flog, "for compiler output")
         except subprocess.CalledProcessError as e:            # compilation failure
            errcount += 1                                      # error(s)
            with open(flog, "w") as fp:
               fp.write(e.output)                              # store compiler output
            print("Compiler reports returncode", e.returncode, "with sample", sample)
            print("See", flog, "for details")
      except queue.Empty:                                      # nothing more to do
         print("Process", os.getpid(), "terminated!")
         print("Samples compiled successfully:", smpcount, ", failed:", errcount)
         break


def prepare_queue():
   """ Fill queue with names of samples to compile
   Returns:  Number of queued samples
   """
   files = os.listdir(smpdir)                                  # all samples
   print("Selecting samples for compilation from", smpdir)
   for file in files:
      if (fnmatch.fnmatch(file, "1*.jal") & (file.find("_blink_") < 0)):   # sample, not blink-a-led
         q.put(file)                                           # queue for compilation
         print(file)
   return q.qsize()                                            # return number of queued samples


def process_queue():
   """ Compile all samples in queu
   Starts as many processes as there are cores in the system.
   Pause as long as there are samples in the queue.
   """
   for f in os.listdir(logdir):                                # remove previous contents
      os.remove(os.path.join(logdir, f))
   processes = min(mp.cpu_count(), qcount)                     # number of processes to start
   print("Starting", processes, "parallel compiler processes")
   p = []
   for i in range(processes):
      p.append(mp.Process(target=pcompile,args=(q,)))          # create compile processes
      p[i].start()                                             # start it
   while (q.qsize() > 0):                                      # periodic check
      print("Samples still to compile:", q.qsize())            # display progress
      time.sleep(3)
   for i in range(processes):                                  # wait until all terminated
      while p[i].is_alive():
         time.sleep(1)
   q.close()                                                   # done with queue
   return


def prepare_lib(tree, dest):
   """ Collect jallib libraries (except device files)
       in a single include directory for the compiler
   """
   def collect_libs(subd):
      for f in os.listdir(subd):
         p = os.path.join(subd, f)
         if os.path.isdir(p):
            if not ((subd == incldir) & (f == "device")):      # skip (old) device files
               collect_libs(p)                                 # resursive call
         else:
            shutil.copy2(p, dest)

   if not os.path.exists(dest):
      os.makedirs(dest)
   print("Collecting Jallib libraries into:", dest)
   collect_libs(os.path.join(tree))



# ======== M A I N ===============================================

if (__name__ == "__main__"):
   """ start process, clock execution time
   """
   print("Compile samples version", scriptversion, "by", scriptauthor)
   elapsed = time.time()
   prepare_lib(incldir, libdir)
   qcount = prepare_queue()
   if (qcount > 0):
      print(qcount, "samples to be compiled")
      process_queue()
   else:
      print("Nothing do do!")
   elapsed = time.time() - elapsed
   print("Runtime %.1f seconds (%.1f samples/second)" % (elapsed, qcount / elapsed))


