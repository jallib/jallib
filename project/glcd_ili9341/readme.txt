These images can be used for testing the glcd_ili9341.jal library.
-----------------------------------------------------------------
See the sample files for the ili9341 on how to use these files.

The crab.jal, photo.jal and jal_logo.jal contain images in JAL array format.
These are generated by the Python script convert_bmp_to_jal_array.py

The other .bmp image files are in the format RGB565, the format
used by the ILI9341 graphics display.

If you want to make your own images you can convert them to 
the RGB565 format using this on-line converter:
https://online-converting.com/image/convert2bmp/
Select the following options:
-) Color: 16 (5:6:5, RGB Hi Color)
-) With rows direction: Top - Bottom (this is NOT the default)
The other settings can be default

Rob Jansen
2022-10-09




