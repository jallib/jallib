#!/bin/bash
# Example Linux bash script to run the blink-a-led.py script for a specific MPLABX version.
export PIC2JAL="/mnt/data/picdevices"
export JALCOMPILER="$PWD/jalv2-x86-64"
export MPLABXVERSION="6.25"
python3 blink-a-led.py

