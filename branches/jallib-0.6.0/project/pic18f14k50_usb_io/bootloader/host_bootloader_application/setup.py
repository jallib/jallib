#!/usr/bin/python
#
#
# Title: jallib USB bootloader (auto start) setup script
# Author: Albert Faber, Copyright (c) 2009, all rights reserved.
# Adapted-by:
# Compiler:
#
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
#
# Description: setup script for bootloader
#
# Dependencies: you'll need to install the LIBUSB and wxWidgets(2.8) package in order to use the application
#
# Notes:
#

from distutils.core import setup
import py2exe

setup(
    # The first three parameters are not required, if at least a
    # 'version' is given, then a versioninfo resource is built from
    # them and added to the executables.
    version = "0.5.0",
    description = "py2exe sample script",
    name = "py2exe samples",

    # targets to build
    #windows = ["UsbBootLoaderW.py"],
    console = ["UsbBootLoader.py"],
    )
