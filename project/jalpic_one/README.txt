Information on the JALPIC One development board
===============================================

source
-------
Contains all source files of the controller PIC software
The Hex file for the controller PIC is also included in this directory.

examples
---------
Contains the two examples for showing the operation of the application PIC.
These examples are used in the documentation. This directory also contains
the jalpic_one.jal include file which has to be included by every program
that needs to run on the application PIC.
The Hex files of both example programs are also included in this directory.

board
-----
Contains all files used to create the board. These are:
-) Schematic diagram designed in Eagle 9.31
-) Board design designed in Eagle 9.31
-) PDF of the schematic diagram
-) PDF of the board design
-) PDF of the component layout
-) Screenshot of the board layout
-) Zipfile containing the Gerber files. This zipfile is used by the pcb
   manufacturer to manufacture the board.

doc
---
MS Word file of the user manual of the JALPIC One development board
PDF of the user manual of the JALPIC One development board

Tools
-----
File jalpic_one.py. Python script to easy the programming of the JALPIC One development board
See the manual on how to create a compiled version of this script.
When using the compiled version, Python does not have to be installed.

Notes
-----
After the zip file with the Gerber file was created, some small additions were made in the
silk screen of the board desing, e.g adding the text 'JALPIC One'. The board design itself
was not changed but note that when the zipfile is used to order a board, this text will not
be on it unless a new zipfile with Gerber file is created.

When using Python you need to have PySerial installed:
-) Python website: https://www.python.org/
-) Install PySerial: python -m pip install pyserial

A short video on how the board works can be found on: https://www.youtube.com/watch?v=lj-_5-6WYTY

Rob Jansen
2019-04-05


