#!/bin/bash
# Example Linux bash script to run the comparejal.py script for a specific MPLABX version.
export PIC2JAL="/mnt/data/picdevices"
export JALLIB="/mnt/data/GitHub/jallib"
export MPLABXVERSION="6.25"
export KDIFF3="/usr/bin/kdiff3"
python3 comparejal.py

