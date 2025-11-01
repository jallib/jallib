#!/bin/bash
# Example Linux bash script to run the all-in-one pic2jal Python script for a specific MPLABX version.
export PIC2JAL="/mnt/data/picdevices"
export JALLIB="/mnt/data/GitHub/jallib"
export JALCOMPILER="$PWD/jalv2-x86-64"
export MPLABXVERSION="6.25"
python3 all-in-one.py

