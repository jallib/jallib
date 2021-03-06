About devicespecific.json
=========================

Changed in devicespecific from MPLABX_V5.20 onwards:
----------------------------------------------------
-) The numner of the DATASHEET was replaced by the presence of a DATASHEET using '+'
-) PGMSPEC was removed
-) ADCGROUP was removed, usage is replaced by ADCON1
-) ADCMAXRESOLUTION was removed 
-) ADCON1 was added
-) OSCCON_IRCF was added
-) PLLEN was added

Current content of devicespecific.json:
--------------------------------------
-) DATASHEET is used to generate a device file is the datasheet exists ("+"). If not "-" then no device file is generated by the pic2jal.py script. The latter
   can be used to document the availabilty of newly announced chips for which there is only a product brief or programming specification but no datasheet yet.
-) DATA is only used to correct errors in the Microchip MPLABX file for data space
-) SHARED is only used to correct errors in the Microchip MPLABX file for shared data space
-) ADCON1 is used by pic2jal.py to create the device file, more specific for the function 'enable_digital_io()' which disables the ADC. The value - if defined -
   in devicespecific.json is meant to set all analog pins to digital. If not defined the pic2jal.py script will set the ADCON1 register to 0b0000_0000 if the 
   register exits. Note that this ADCON1 setting is not needed for all PICs even if they have a ADCON1 register so only define it in devicespecic.json if the
   value must be different than 0b0000_0000.
-) OSCCON_IRCF is used by blink-a-led.py to set the right 4 MHz internal oscillator clock. It just copies the exact value from this file to the blink-a-led.sample.
   -) For PICs that for which OSCCON_IRCF is not needed for the blink-a-led sample, the keyword is not mentioned
   -) There are some PICs that are mentioned with a value of '-'. These are exceptions handled by the blink-a-led.py script.
-) PLLEN is used by blink-a-led.py for certain PICs that need PLL to be enable to create a 4 MHz clock. There is no value, the presence of the keyword is sufficient.
-) USBBDT is the start address of the USB memory for PICs that have USB hardware.



Rob Jansen
2020-05-22
