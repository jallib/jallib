# ------------------------------------------------------------------------------------
# Title: JAL bitmap image array generation script  
# Author: Rob Jansen, Copyright (c) 2022..2025, all rights reserved.
# Python version : 3.8
#
# This file is part of jallib (https://github.com/jallib/jallib)
# Released under the ZLIB license (http://www.opensource.org/licenses/zlib-license.html)
# 
# Description: Script to convert an RGB565 bitmap image to a JAL Array.
#
# Notes:       A way to generate the RGB565 bitmap from a png or jpg file:
#              Converter: https://online-converting.com/image/convert2bmp/
#              Choose: 16 (5:6:5 RGB Hi-Color), rows direction Top - Bottom
#              If needed set a new DPI size. DPI must be an even number for this script!
#

import sys
import os

# Define a new line. Using \r in f.write does not seem to work for the JAL Compiler.
newline="""
"""

# Convert the RGB565 bitmap in the given source file to a JAL array.
def conversion(name):
    sourcefile = name
    convname = name[:-4]
    destfile = (convname + ".jal")
    print("Reading image file")
    f = open(sourcefile, "rb")
    data = f.read()
    f.close()
    # Check if this is a bmp image. Data[0] must be 'B', data[1] must be 'M'
    if ((data[0]) != 66) or (data[1] != 77):
        print("Source file is not a bitmap")
        exit(1)
    print("Converting image file to JAL array")
    f = open(destfile, "w")
    # Write the header to JAL file.
    f.write("-- -----------------------------------------------------------------------------" + newline)
    f.write("-- Title: JAL bitmap image array generated from an RGB565 bitmap file." + newline)
    f.write("-- Author: Script by Rob Jansen, Copyright (c) 2022..2025, all rights reserved." + newline)
    f.write("-- Adapted-by:" + newline)
    f.write("-- Compiler: 2.5r9" + newline)
    f.write("--" + newline)
    f.write("-- This file is part of jallib (https://github.com/jallib/jallib)" + newline)
    f.write("-- Released under the ZLIB license (http://www.opensource.org/licenses/zlib-license.html)" + newline)
    f.write("--" + newline)
    f.write("-- Description: An RGB565 bitmap image converted to JAL Array." + newline)
    f.write("--" + newline)
    f.write("-- Notes:       A way to generate the RGB565 bitmap from a png or jpg file:" + newline)
    f.write("--              Converter: https://online-converting.com/image/convert2bmp/" + newline)
    f.write("--              Choose: 16 (5:6:5 RGB Hi-Color), rows direction Top - Bottom" + newline)
    f.write("--              If needed set a new DPI size. DPI must be an even number." + newline)
    f.write("--" + newline)
    if (endian == "big"):
       f.write("--              This array uses the non-default Big Endian format!" + newline) 
    else:
        f.write("--              This array uses the JAL default Little Endian format." + newline) 
    f.write("--" + newline + newline)
    # Get the width and the height of the picture.
    width = (data[19] * 256) + data[18]
    print("Picture width is:", width)
    # Another calculation is used when nr of pixels > 255.
    if (width > 255):
        width = (65535 - width) + 1
    # The width must be even otherwise we get a sideways shifted picture.
    if ((width % 2) != 0):
        print("Picture width must be even, please resize source file.")
        print("Conversion cancelled.")
        exit(1)
    height = (data[23] * 256) + data[22]
    # Another calculation is used when nr of pixels > 255.
    if (height > 255):
        height = (65535 - height) + 1
    print("Picture height is:", height)
    # Write width and height to JAL file.
    f.write("-- Image size." + newline)
    f.write("const word " + convname.upper() + "_WIDTH = " + str(width) + newline)
    f.write("const word " + convname.upper() + "_HEIGHT = " + str(height) + newline + newline)
    picture_size = width * height
    print("Picture size is:", picture_size, "words")
    # Define the const array.
    f.write("-- Bitmap image." + newline)
    f.write("const word " + convname.upper() + "_BITMAP" + "[" + convname.upper() + "_WIDTH * " + convname.upper() + "_HEIGHT] = ")
    f.write(newline + "{" + newline)
    # Write the data. First get the location.
    index = (data[11] * 256) + data[10] + (65535 * (data[13] * 256) + data[12])
    words_per_line = 8
    while (picture_size > 0):
        f.write("0x")
        if (endian == "big"):
            # Big Endign, MSB first.
           jal_byte = data[index]
           f.write(f'{jal_byte:02x}')
           jal_byte = data[index + 1]
           f.write(f'{jal_byte:02x}')
        else:
           # Normal JAL word is written with LSB first.
           jal_byte = data[index + 1]
           f.write(f'{jal_byte:02x}')
           jal_byte = data[index]
           f.write(f'{jal_byte:02x}')
        index = index + 2
        picture_size = picture_size - 1
        words_per_line = words_per_line - 1
        if (picture_size > 0):
            if words_per_line == 0:
                f.write("," + newline)
                words_per_line = 8
            else:
                # Next row
                f.write(", ")
        else:
            # Last data word, close array.
            f.write(newline + "}" + newline)
    f.close()
    print("Done!")
    print("The result is stored in file:", destfile)


if __name__ == "__main__":
    # Main program starts here.
    if (len(sys.argv) == 2):
        filename = sys.argv[1]
        endian = "little"
    elif (len(sys.argv) == 3):
        filename = sys.argv[1]
        endian = sys.argv[2]
        if (endian != "big"):
            print("Illegal second argument")
            sys.exit(1)
    else:
        print("Script for converting an RGB565 BMP image to a JAL const word array.")
        print("Give the name of the bmp file as first argument. Arguments are case sensitive.")
        print("The word array uses Little Endian (default for JAL) which can be changed")
        print("to Big Endian by using the optional second argument 'big'.")
        sys.exit(1)

    if os.path.exists(filename):
        conversion(filename)
    else:
        print("Sourcefile does not exist")
