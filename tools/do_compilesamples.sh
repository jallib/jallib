#!/bin/bash
# Example Linux bash script to run the compilesamples.py script for a specific MPLABX version.
export PIC2JAL="/mnt/data/picdevices"
export JALLIB="/mnt/data/GitHub/jallib"
export JALCOMPILER="$PWD/jalv2-x86-64"
export MPLABXVERSION="6.25"
python3 compilesamples.py

