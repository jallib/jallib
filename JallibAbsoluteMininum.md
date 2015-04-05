# The Absolute Minimum Every Jallib User Absolutely Must Know #

## About PIC ##

  * In a PIC, **analog IO are enabled by default**. If you want to use digital IO, you have to explicitly enable them, using `enable_digital_io()` procedure. No one will do it for you...

  * **pins are inputs by default**. If you want them to be output, you need to configure them. Ex: `pin_A0_direction = output`.

## About the source repository ##

  * If you want to **save files locally from the source tree**, view the file, press show details. At the bottom of the details is a link: "show raw file" right-click on this and "save as.." to the directory of your choice.