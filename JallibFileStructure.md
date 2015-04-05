
---


# Library structure #

This document tries to help you with the use and extension of our include files.


---


## The overall picture ##

```
                    ┌─────────────┐   ┌─────────────┐
                    │   device    │   │   common    │
                    │  specific   ├───┤   include   │
                    │   include   │   │             │  
                    │<pictype>.jal│   │ chipdef.jal │
                    └──────┬──────┘   └─────────────┘
                           │
           ┌───────────────┼───────────────┬─────────────
           │               │               │
     ┌─────┴────┐    ┌─────┴────┐    ┌─────┴────┐    ┌───
     │ function │    │ function │    │ function │    │
     │ include  │    │ include  │    │ include  │    │ etc
     │ 'delay'  │    │  'adc'   │    │  'lcd'   │    │
     └──────────┘    └──────────┘    └──────────┘    └───

```

This schematic shows the organization of the **JalLib** files.
A program should first indicate for which target chip it is meant by including the appropriate device include file (which includes itself:`chipdef.jal`).
Depending on the functionality of the program it may also include one or more function include files.


---


## Device File ##

There is a device include file for every _supported_ PICmicro.

File name format: 

&lt;pictype&gt;

.jal**, more specifically**xxfyyyy.jal**in which
  ***xx**can be**10**,**12**,**16**, or**18*****f**can be**f**,**hv**, or**lf*****yyyy**is a combination of digits and letters**

The device specific include files contain information for the compiler, like:
  * cpu type (12-, 14- or 16-bits core)
  * program size specification
  * data (EEPROM) location and size specification
  * config and ID memory specification
  * general purpose register (GPR, RAM) location, range and sharing
  * special function register (SFR) address and mirror addresses, alias names and bit names
  * procedures and functions for shadowing of I/O ports for the baseline and midrange
  * forced use of LATx registers for the 18F series
  * configuration bit declarations

Device include files do not initialize any register or configuration bit (fuse). This falls under the responsibility of the user program.
Other user program responsibilities:
  * Specification of oscillator speed, e.g. `pragma clockspeed 4_000_000`
  * Enabling digital I/O when the chip has analog features and the port(s) are by default in analog mode. For this purpose each device include file contains a special function: `enable_digital_io()`, which contains the instructions for the specific PICmicro.

### Naming conventions for Ports and Port pins ###

For all registers of the chip a variable is declared and where appropriate also for the individual bits or groups of bits.
For all ports and port pins a device independent alias is defined and a similar direction, as the following examples show:

For **PORTA** and **TRISA**:
```
  var volatile byte PORTA  at <addr>
  var volatile bit  PIN_A0 at PORTA : 0
  var volatile byte TRISA  at <addr>
  var volatile byte PORT_A_DIRECTION at TRISA 
  var volatile bit  PIN_A0_DIRECTION at TRISA : 0

etc. for all other existing pins and other ports.
```
Smaller chips with **GPIO** and **TRISIO** registers have:
```
  var volatile byte GPIO   at <addr>
  var volatile byte PORTA  at GPIO  

and all the other declarations as for PORTA above, so it can be used as PORTA.
```
Also declared are several pseudo variables:
```
  var          byte PORT_A_LOW                -- low order nibble
  var          byte PORT_A_HIGH               -- high order nibble
  var          byte PORT_A_LOW_DIRECTION
  var          byte PORT_A_HIGH DIRECTION
```

The names of subfields of registers have the register as prefix. For example the 'carry'-bit 'C' of the STATUS register is defined as:
```
  var volatile bit   STATUS_C 
```

Apart from these also a number of other names are declared in lower case and starting with an underscore character. These names are for use by the compiler.


### About Port Shadowing ###

Port shadowing is a technique to prevent the Read-Modify-Write problem with I/O ports of baseline and midrange PICmicros. This is a problem related to its hardware design and may occur when a read of a port is immediately followed by writing to that port.
With shadowing a RAM location is used as replacement for the port. Reading is done from the port directly. Writing is done to the shadow register and then its contents flushed to the real port.
With these device include files shadowing is automatic, as long as you use the following names:
```
  PORTx          - all bits of port x
  PORT_x_LOW     - low order nibble of port x (bits 3..0)
  PORT_x_HIGH    - high order nibble of port x (bits 7..4)
  PIN_xy         - single bit 'y' of port 'x'
```
(in which 'x' is a port-letter and 'y' a bit- or pin-number).

If you want to use other names for pins or nibbles or the whole port you can specify an alias. For example when you have a red LED connected to pin 0 of PortA, you could specify:
```
   var bit LED_red is pin_A0
```
and use `LED_red = on` or `LED_red = off` in your program.
You should avoid direct pin and I/O port manipulation, because it will be
overruled by the automatic shadowing mechanism. For example do not specify:
```
  var bit LED_red at portA : 0
```
With this specification a `LED-red = on` will have the desired result, but it will not update the shadow register. Any next operation which uses the shadowing mechanism will override the previous direct control operation.

The shadowing is also bypassed when you initialize the alias with the  declaration. So declaring and initializing an alias as follows:
```
   var bit LED_red is pin_A0 = off
```
is bad practice!


### Naming convention for configuration bitmasks (fuses) ###

The configuration bits or groups of bits is such a large variety that it
is not easy to have a naming convention which covers it all.
The following design rules are used:
  * For all implemented config bits a option name and tags are defined, but:
    * duplicate option names may be generated
    * duplicate tags may be defined for a single option
    * some of the tags may not be acceptable for the compiler
  * When the compiler stalls over a fuse-def line a manual correction should be applied.
  * For the most popular config bits a 'standard' option name is defined, along  with a 'standard' tag, see the list below.

Only for the oscillator specification the MPLAB information files contain
more than 140 different indications!! Because of the synonyms this number
could be normalized to a smaller number. The first part is the oscillator type, the optional second part indicates secondary functions.
For example it may indicate if the OSC2 pin is CLKOUT or I/O, or if PLL is
active for the 18F series.
Other names may appear when the script could not decipher the description
in the MPLab device file.

Fuse\_Def OSC  (oscillator)
```
      LP              - Low Power crystal on OSC1,OSC2
      XT              - Crystal or Resonator on OSC1,OSC2
      HS              - High Speed Crystal or Resonator on OSC1,OSC2
      HS_PLL          - as HS + PLL
      HS_USB          - as HS + USB
      EC_CLKOUT       - External Clock (TTL) signal on OSC1, OSC2 is ClockOut
      EC_NOCLKOUT     - External Clock (TTL) signal on OSC1, OSC2 is I/O
      EC_PLL          - as EC + PLL active
      EC_USB          - as EC + USB
      RC_CLKOUT       - RC oscillator on OSC1, OSC2 is ClockOut
      RC_NOCLKOUT     - RC oscillator on OSC1, OSC2 is I/O
      EXTOSC_CLKOUT   - External oscillator on OSC1, ClockOut on OSC2
      EXTOSC_NOCLKOUT - External oscillator on OSC1, OSC2 is I/O
      INTOSC_CLKOUT   - Internal oscillator, OSC1 is I/O, ClockOut on OSC2
      INTOSC_NOCLKOUT - Internal oscillator, OSC1 and OSC2 are I/O
      (some other keywords may be used)
```

```
Fuse_Def WDT  (watchdog)
      ENABLED          - Watchdog enabled
      DISABLED         - Watchdog disabled

Fuse_Def WDTPS  (Watchdog postscaler)
      P32768           -  1 : 32,768
      P16384           -  1 : 16,384
      P...             -  1 : ...
      P2               -  1 : 2
      P1               -  1 : 1

Fuse_Def MCLR  (reset)
      EXTERNAL         - /MCLR pin enabled
      INTERNAL         - /MCLR pin is digital I/O

Fuse_Def PWRTE  (power reset timeout)
      ENABLED          - Power up timer enabled
      DISABLED         - Power Up timer disabled

Fuse_Def BROWNOUT  (Brown Out detect)
      ENABLED          - BOD enabled, SBOREN disabled
      RUNONLY          - BOD enabled in run, disabled in sleep
      CONTROL          - SBOREN controls BOR function
      DISABLED         - BOD and SBOREN disabled

Fuse_Def VOLTAGE  (Brownout voltage)
      V20              - 2.0 Volt
      V27              - 2.7 Volt
      V42              - 4.0 Volt
      V45              - 4.5 Volt
      ...  etc (whatever voltages are applicable)

Fuse_Def LVP  (Low Voltage Programming)
      ENABLED          - LVP on, enabled
      DISABLED         - LVP off, disabled

Fuse_Def CP  (Code Protection)
      ENABLED          - Code protection on, enabled
      DISABLED         - Code Protection off, disabled

Fuse_Def CPD  (EEPROM Data Protection)
      ENABLED          - Data Protection on, enabled
      DISABLED         - Data Protection off, disabled
```
Notes:
  * In addition to the 'standard' fuse\_defs above there may be others, depending  on the features of the specific PICmicro. Please read the include file to see which fuse-defs are available for your target PICmicro.
  * The terms **Enabled** and **Disabled** may need to be specified where usually **On** and **Off** are used.

The symbolic specification with `pragma target` is preferred, since it is more portable. But in stead you may specify the fuse-word(s) or -byte(s) explicitly with bit patterns. For example for the PIC16F690 the following group of statements:
```
  pragma target OSC       HS
  pragma target WDT       Disabled
  pragma target PWRTE     Enabled
  pragma target MCLR      External
  pragma target CP        Disabled
  pragma target CPD       Disabled
  pragma target BROWNOUT  Enabled
  pragma target IESO      Disabled
  pragma target FCMEN     Disabled
```
is equivalent with:
```
  pragma target fuses   0b_11_0011_1110_0010
```

PICs with 16-bits core (the 18F series) have such a large variety of configuration bits that explicit specification is probably the best way to make sure all config bits are set correctly for your program. As an example see the following list for a simple blink-a-LED program with an 18F242.
```
 pragma  target fuses 0  0b_0010_0010       -- not switchable, HS osc, no PLL
 pragma  target fuses 2  0b_0000_0001       -- BOR disabled, PWTR disabled
 pragma  target fuses 3  0b_0000_0000       -- watchdog disabled
 pragma  target fuses 4  0b_0000_0000       -- (N/A)
 pragma  target fuses 5  0b_0000_0001       -- CCP2 on RC1
 pragma  target fuses 6  0b_1000_0001       -- no bg debug, no LVP, STVREN
 pragma  target fuses 7  0b_0000_0000       -- (N/A)
 pragma  target fuses 8  0b_0000_1111       -- no code protection
 pragma  target fuses 9  0b_1100_0000       -- no data protection
 pragma  target fuses 10 0b_0000_1111       -- no code write protection
 pragma  target fuses 11 0b_1110_0000       -- no other write protection
 pragma  target fuses 12 0b_0000_1111       -- no table read protection
 pragma  target fuses 13 0b_0100_0000       -- no boot block write protec
```

Notes:
  * All pragma target statements target must be specified after the include statement of the device file.
  * When a PIC has multiple config words or bytes the index value should be specified between pragma target fuses and the value, as shown in the example for the 18F242 above.

The meaning of config bits can be found in in the Programming Specifications of the specific PICmicro, and frequently in the DataSheet as well. For your convenience the MicroChip document numbers are mentioned in the heading of the device include files (when found in the MPlab .dev file).


---


## Function Includes ##

(to be done)


---


## Samples ##

The sample program that explains a library sets the default needed parameters. It also includes parameters that have a default setting in the library, so need not be declared by the user, in comments, with the default value. Example:


```
const baudrate = 2400

-- const nine_bit_tx  = false
-- const nine_bit_rx  = false
-- const synchronous  = false


include serial_hardware_16
```


Since the hardware libraries have their default values, direct messing with configuration bits in special function registers should happen after including the library.

The **aim** is for the newbie to include the library with a minimum of parameters so that it works right away.