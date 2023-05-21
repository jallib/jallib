"""
Title: Generate a new build using GitHub Actions

Author: Rob Jansen, Copyright (c) 2020..2023, all rights reserved.

Adapted-by: 

Compiler: N/A

This file is part of jallib (https://github.com/jallib/jallib)
Released under the ZLIB license (http://www.opensource.org/licenses/zlib-license.html)

Description:
   Create a new build by validating and compiling all samples mentioned in TORELASE.
   A build is started after each push.

Sources: 

Notes:

"""
import sys
import os
import subprocess

# Global data
torelease        = "TORELEASE"
in_release       = []          # contents of TORELEASE
include_list     = []          # list of include directories
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
    validator = os.path.join("tools","jallib3.py")
    for ln in in_release:
        cmdlist = ["python", validator, "validate", ln]
        try:
            log = subprocess.check_output(cmdlist, stderr=subprocess.STDOUT, universal_newlines=True, shell=False)
            counter = counter + 1
            # We have to print something to prevent a timeout on TravisCI
            if ((counter % 50) == 0):
                print(counter)
            if debug:
                print(log)
        except subprocess.CalledProcessError as e:
            print("Validation failed for:", ln)
            print(e.output)
            result = False
    if result:
        print("   Validated ", counter, "files.")
    return result


# Create the complete include path for compiler.
def build_include_list(parent):
    global include_list
    file_count = 0                          # include files in this directory
    incl_dir = os.path.join(parent)
    for child in os.listdir(parent):
        incl_sub = os.path.join(parent, child)
        if os.path.isdir(incl_sub):         # this is a directory
            build_include_list(incl_sub)    # recurse!
        else:
            if child.endswith(".jal"):      # count only jal include files
                file_count += 1
    if file_count > 0:                      # dir contains at least 1 include file
        include_list.append(incl_dir)


# Compile sample files.
def compile_samples():
    print("Compiling sample files ...")
    global in_release
    counter = 0
    result = True
    # Compiler path
    compiler = os.path.join("compiler","jalv2-x86-64")
    # Build the include path of all include directories
    current_path = os.path.join("include")
    build_include_list(current_path)
    include_string = ";".join(include_list)
    if debug:
        print("Include path:", include_string)
        print("Number of include directories:", len(include_list))
        print("Length of include string:", len(include_string))
    for ln in in_release:
        # Only build sample files.
        is_sample = ln.find("sample/")
        if (is_sample != -1):
            if debug:
               print("File", ln)
            cmdlist = [compiler, "-no-asm", "-no-codfile", "-no-hex", ln, "-s", include_string]
            try:
                log = subprocess.check_output(cmdlist, stderr=subprocess.STDOUT, universal_newlines=True, shell=False)
                counter = counter + 1
                # We have to print something to prevent a timeout on TravisCI
                if ((counter % 50) == 0):
                    print(counter)
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
        all_ok = all_ok & compile_samples()
    if all_ok:
        print("Build succeeded!")
        sys.exit(0)
    else:
        print("Build failed!")
        sys.exit(1)








