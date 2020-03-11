"""
Title: Generate a new build using Travis CI

Author: Rob Jansen, Copyright (c) 2020..2020, all rights reserved.

Adapted-by: 

Revision: $Revision$

Compiler: N/A

This file is part of jallib  https://github.com/jallib/jallib
Released under the BSD license https://www.opensource.org/licenses/bsd-license.php

Description:
   Create a new build by validating and compiling all samples mentioned in TORELASE.
   A build is started after each commit.

Sources: 

Notes:

"""
import sys
import os
import subprocess

# Global data
compiler_include = "include/jal;include/device;" \
                   "include/networking;include/filesystem;" \
                   "include/peripheral;include/protocol;" \
                   "include/external"
python_exe       = "python"
torelease        = "TORELEASE"
in_release       = []          # contents of TORELEASE
debug            = False

# Read TORELEASE into a list of lines (comments removed) and get all JAL files.
def read_torelease():
    print("Reading", torelease, " ...")
    global in_release
    result = True
    try:
        with open(torelease, "r") as ft:
            for ln in ft:
                ln = ln.strip()
                if (len(ln) > 0):
                    position = ln.find(".jal")
                    # Only store no commented files and JAL files
                    if (ln[0] != "#") & (position > 0):
                        in_release.append(ln)
                        if debug:
                            print(ln)
    except:
        print("Failed to open", torelease)
        result = False
    if result:
        print("   Done!")
    return result


# Validate all jal files given in 'in_release'. This includes device files and sample files.
def validate_jalfile():
    print("Validating JAL files ...")
    global in_release
    counter = 0
    result = True
    for ln in in_release:
        validator = os.path.join("tools","jallib3.py")
        cmdlist = [python_exe, validator, "validate", ln]
        try:
            log = subprocess.check_output(cmdlist, stderr=subprocess.STDOUT, universal_newlines=True, shell=False)
            counter = counter + 1
            if debug:
                print(log)
        except subprocess.CalledProcessError as e:
            print("Validation failed for:", ln)
            print(e.output)
            result = False
    if result:
        print("   Validated ", counter, "files.")
    return result


# Compile sample files.
def compile_samples():
    print("Compiling sample files ...")
    global in_release
    counter = 0
    result = True
    for ln in in_release:
        # Only build sample files.
        is_sample = ln.find("sample/")
        # Temporary! Only compile blink files.
        is_blink = ln.find("blink")
        if (is_sample != -1) & (is_blink != -1):
            THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
            compiler = os.path.join(THIS_FOLDER,"compiler","jalv2-i686")
            if debug:
               print("File", ln)
            cmdlist = [compiler, "-no-asm", "-no-codfile", "-no-hex", ln, "-s", compiler_include]
            try:
                log = subprocess.check_output(cmdlist, stderr=subprocess.STDOUT, universal_newlines=True, shell=False)
                counter = counter + 1
                if debug:
                    print(log)
            except subprocess.CalledProcessError as e:
                print("Compiling failed for:", ln)
                print(e.output)
                result = False
    if result:
        print("   Compiled ", counter, "files.")
    return result


# ----------------------------
# --- E N T R Y  P O I N T ---
# ----------------------------
if (__name__ == "__main__"):

    # Start process
    print("Starting the build")
    all_ok = read_torelease()
    if all_ok:
        all_ok = all_ok & validate_jalfile()
    if all_ok:
        all_ok = all_ok * compile_samples()
    if all_ok:
        print("Build succeeded!")
        sys.exit(0)
    else:
        print("Build failed!")
        sys.exit(1)








