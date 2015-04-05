#summary jallib style guide, a recipe to write a standard jalv2 library
#labels Featured

The **jallib style guide** defines the standards used to write jalv2 code.

# Why ? #

There're many ways to write code, whatever the programming language is. Each language has its preferences. For instance, java prefers _CamelCase_ _whereas python prefers_underscore\_lowercase_._

While this seems a real constraint, not necessarily needed, it actually helps a lot while sharing code with everyone: it improves **readability**, and readability is important because code is read much more often than it is written.

Finally, more than a howto write code, this guide is here to help you not forget things like _author(s)_, _licence_, and remember you some basic principles.


# Headers in library #

Every jal files published on this repository must have the following headers (comments), as the very beginning of the file:

```
-- Title: [title, very small description if needed]
-- Author: [author's name], Copyright (c) YEAR..YEAR, all rights reserved.
-- Adapted-by: [adapters' name, comma seperated]
-- Compiler: [specify which version of compiler is needed. Ex: >=2.4g, =2.3, ???]
-- Revision: $Revision$
-- 
-- This file is part of jallib (http://jallib.googlecode.com)
-- Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
--
-- Sources: [ if relevant, specify what sources of informations you use: website, article, specifications, appnotes, etc... ]
-- 
-- Description: [describe what is the functional purpose of this lib]
--
-- Notes: [put here information not related to functional description]
--

[code start here...]
```

The **author** is the original author's name. The library may have been modified and adapted by **adapters**. The **compiler** helps readers to know which compiler version is needed to use this file (no space between operator and version: >=2.4g). **revision** field is automatically set by SVN and stores the current revision of the file (useful when file is leaving SVN). **sources**, **description** and **notes** fields must be followed by an empty line (just `--`) to declare the end of the field content. As a consequence, those fields cannot have empty lines within them.

Note: Revision field is optional. It may be set as previously shown with "-- Revision: $Revision$". Committers can then tell SVN to update this field automatically so it is shown as "-- Revision: $Revision: 2760 $".

Revision updates can be automatically done using auto-props features. The following page shows how to do this, both for command line clients and TortoiseSVN: http://www.mediawiki.org/wiki/Subversion/auto-props. Note it works only when adding or importing files ("svn add", "svn import"), not when committing existing files. Short version: put the following lines in your SVN configuration file (or uncomment as needed):

```
 enable-auto-props = yes
 *.jal = svn:eol-style=native;svn:keywords Revision
```

```
svn ps svn:keywords Revision thefile.jal
```

JSG header Example:

```
-- Title: USART hardware control
-- Author: Stef Mientki, Copyright (c) 2002..2008, all rights reserved.
-- Adapted-by: Sebastien Lelong, Someone Else
-- Compiler: >=2.4g
-- Revision: $Revision$
-- 
-- This file is part of jallib (http://jallib.googlecode.com)
-- Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
-- 
-- Description: Routines for sending and receiving through the PIC-usart,
-- both RS232 and SPI are supported (for SPI see spi_hardware.jal)
-- Baudrate can simply be set through a human constant,
-- because the baudrate depending registers are calculated by this unit.
-- Baudrate is calculated, starting at the high baudrate flag,
-- which will ensure the highest possible accuracy.
-- --
-- SPI routines are setup for more SPI-devices,
-- in which case CS should be controled outside this unit.
-- 
-- Sources: excellent article on USART: http://www.google.fr/search?q=usart
-- 
-- Notes: an incredible note
--
```

Note: if you need to create a new paragraph within a multiline field, use the "--" special chars. See example in Description field: "SPI routines ..." is part of the Description field, but visually seperated from the beginning of the field content.

In the `/tools` directory, you'll find `jallib.py`. Amongst many things, you can run "validate" action, and check lots of JSG requirements. You can (must) use it to make sure your jal files are JSG compliant. This script will help you to identify problems:

Ex:
```
bash$ python jallib.py validate my_file.jal

File: my_file.jal
6 errors found
        ERROR: Cannot find references to jallib (should have: '^-- This file is part of jallib\\s+\\(http://jallib.googlecode.com\\)')
        ERROR: Cannot find references to license (should have: '^-- Released under the BSD license\\s+\\(http://www.opensource.org/licenses/bsd-license.php\\)')
        ERROR: Cannot find field Title (searched for '^-- Title:\s*(.*)')
        ERROR: Cannot find field Author (searched for '^-- Author:\s*(.*)')
        ERROR: Cannot find field Compiler (searched for '^-- Compiler:\s*(.*)')
        ERROR: Cannot find field Description (searched for '^-- Description:\s*(.*)')

0 warnings found
```


# Rules of thumb #


## Filenames, variables, procedures naming convention ##

### Filenames ###

A library must be named as:

  * **`<function>_<implementation|other>.jal`** for PIC-specific libraries (peripherals). _function_ gives clues about what the library is about. Then _implementation_ or _other_ is here to differentiate libraries, and is more about implementations (`serial_hardware.jal`, `serial_software.jal`), things specific to the function (`pwm_ccp1.jal`, `pwm_ccp2.jal`, ...).

> Ex: `serial_hardware.jal`, `serial_software.jal`, `pwm_ccp1.jal`.

  * **`<device-family>_<device>.jal`** for external libraries. _device-family_ describes the device family (...), and is often the directory name where the lib is. _device_ precisely sets the part.

> Ex: `lcd_hd44780_4.jal`, `rtc_ds1302.jal`, `co2_t6603.jal`



### Constants, variables, procedures, functions ###

All **external names** (of global variables, constants, procedures and functions available to application programs) **must** start with a prefix unique to the library. Names of other global entities (not supposed being used by application programs) should use this prefix and use an additional underscore at the beginning.

Variables, constants, procedures and functions must be named as:

  * **`<device>_<whatever>`** if you want to avoid namespace collision
  * **`<device-family>_<whatever>`** if you want to have a common API

For example, co2\_t6603.jal library have all its procedures starting with `t6603_` (and `_t6603_` for internal names). This makes all these procedures very specific to this library. If you have another CO2 sensor, you'll be able to use both at the same time, because they'll be no namespace collision. This is the purpose of the `<device>_<whatever>` naming convention.

Another example: the names of the procedures in the LCD libaries start with `lcd_` (and `_lcd_` for internal names). There are many different LCD types, but all implements the same API, because procedures, variables, etc... are named according to the device-family, not the device itself. This is the purpose of the `<device-family>_<whatever>` naming convention.

Now, how do you know which to follow ? Ask, we'll discuss...

Note:
following the same principle, naming const/var/procdecure/function in a PIC-specific libraries (peripherals) can include the _function_ and/or the _implementation_. This depends whether you want to have more than one function within a same PIC.

Ex: There are two implementations of i2c and serial: hardware and software. Having both i2c implementation within a same PIC is not useful, since i2c is adressable. Thus, all const/var/... are prefixed by `i2c_<whatever>.jal`. On the contrary, it can be useful to have two serial implementation within a same PIC (eg. one talking a PIC, another talking to a external device). Thus, serial libs' const/var/... are prefixed by `serial_hw_<whatever>.jal` or `serial_sw_<whatever>.jal`.


### Pin names ###

The pins are named as:

  * **`<device>_<external_pin_name>`** if you want to avoid namespace collision
  * **`<device-family>_<external_pin_name>`** if you want to have a common API

This is almost the same as for variables, contants, ... except the `<whatever>` part now corresponds the pin name of the external device (usually found in datasheets). Using the `<device-family>_<external_pin_name>` convention to build a common API may cause problems, if pin names aren't named the same in all supported devices. In that case, the pin name should be as explicit as possible...

_See also the very important rules about pin names within a library: "Don't use port and pin names"_

### Samples and tests ###

Tests are named as `test_<whatever>.jal`. That is, they should starts with the prefix `test_`. That is, samples must **not** start with `test_`.

Board files are named as `board_<pic>_<whatever>.jal`

Samples are named as `<pic>_<whatever>.jal`. 

&lt;whatever&gt;

 can be whatever, but should give users hints about what the sample is (eg. 16f88\_serial\_hardware.jal)


### Why such a pain ?... ###

The main purpose of this is to control the naming conflicts between libraries and application code. Bear in mind that this is about source-level libraries which are combined by the compiler to form a single application program.

Having naming convention is also a great optimize process, saving time, by scripting and generating code. This is good.


## Don't use port and pin names ##

**Don't use port and pin names** like `portA` or `pin_a5` in your great library, because someone may (will) want to use your library on another port or pin. It also helps to make your great library PIC independent.

**Name your pins according to the context**, to what your library is doing. Client code, ie. users, will have to define those variables before actually include your great library.

**Let the user set the pin directions, except if the library is supposed to modify direction during execution**

Ex: how to use your library (doing amazing things with the GP2D02 IR ranger)
```
  -- declare in/out pins for the ranger
  alias ranger_pin_in          is pin_A0
  alias ranger_pin_out         is pin_A1
```
and make sure the pins work as required:
```
  -- specify the direction of the pins
  -- Since directions won't change during execution, this is
  -- done here, during the setup, before including the library
  pin_A0_direction = input
  pin_A1_direction = output
```
and now include the library:
```
  -- now include the library which uses ranger_pin_in and ranger_pin_out
  include gp2d02            -- ranger library 
```

_Exception_: if your library uses a special PIC feature, it may use the name defined in the device files / datasheet. Not so much an exception, as you'll use the pin name given the context (feature, peripheral)

_Note_: syntax "var ... is ..." is now deprecated in favor of "alias ... is ..." and must not be used anymore. "alias" keyword is more powerful as it allows to create synonyms for any type of names (variables, constants, procedures, functions, psdeudo-variables)

Ex: a i2c hardware library (using built-in PIC i2c) may refer to `SCK` and `SDA`. Those pin names are set into the device include file (prefixed with the portname!).

## Let the user initialize the library ##

Most of the time, a library needs to configured (you define variables/constants before including the file), then initialized (you call `<libname>_init()`). While having the init step automatically called when the library is called can be convenient, this results in a lack of flexibility. Indeed, you may want to initialize one library or the other, or initialization step can take quite a long time, so you want to have control about when you can "waste" such time.

So, **a library must never call its own init procedures, the user will**. And the init procedure must be named either as **`<device>_init`** or **`<function>_init`**, whether you want to avoid namespace collision, or on the contrary, if you want to have different implementation for the same API (see rules about naming convention above).


## Avoid weird default values in library ##

**Don't put default values** in your library, someone may (will) have a different opinion about what's a _default value_. Even if it's tempting because it can save time writing the same value again and again. Remember, your library is to be shared, nasty default value can be a real obstacle using it...

## Write examples ##

**Write examples** to show the world how to use your great library. Without it, people may (will) not use your library, because it's too complicated and time-consuming reading code to actually discover what it does. Also remember writing examples can help _you_ to design a usable, simple and clear API.


## Assembler ##

Avoid the use of inline Assembler. If you cannot do without it use **standard asm opcodes** and avoid nasty Assembler statements. So:

**Good**
```
btfsc STATUS_Z
```

**Bad**
```
skpnz
```

## Warnings are errors... ##

Don't be tempted to ignore warnings. **Consider warnings as errors**, until you've completely understand why there should be a warning (or not). Warnings can mask more relevant warnings and errors, so track them and try to avoid them. **A library should compile without any warnings... if possible**.


# Code Layout #

## Indent your code ##

It helps following the code structure (flows). Code must be indented using **3 spaces** (no tab). You can use `python jallib.py reindent <file.jal>` for this.

**Good**
```
var byte char
forever loop
   if serial_hw_read(char) then
      echo(char)
   end if
end loop
```

**Bad**
```
var byte char
forever loop
if serial_hw_read(char) then
echo(char)
end if
end loop
```

## Use lower\_case\_with\_underscores ... ##

**Good**
```
var byte this_is_a_variable
var byte another_one
```

**Bad**
```
var byte ThisIsAVariable
var byte Another_One
```

## ... except for constants ##

Uppercase variables should be used for constants, internal PIC function registers or for external PIN names, if they are uppercase in the datasheet as well.

**Good**
```
const RESET_CHAR = "*"
SSPCON1_CKP = 1
```

**Bad**
```
const reset_CHAR = "*"
sspCON1_Ckp = 1
```

## Be explicit when calling procedures and functions ##

When a procedure (or a function) does not take any parameters, be explicit and help your readers: put parenthesis so everyone knows it's a call. Same when defining the function/procedures. Also note no space is allowed between the procedure/function name and the opening parenthesis. Finally, pseudo-variable must be defined with parenthesis, but not when used (heh, these are functions/procedures behaving like variables !).

**Good**
```
-- Defining
procedure do_it_please() is
    -- I will do it
end procedure

-- Calling
do_it_please()

-- pseudo-var
function my_pseudo_var'get() return byte is
    -- I promise I'll do it
end function

var byte what = my_pseudo_var
```

**Bad**
```
procedure do_it_again is
    -- this is bad
end procedure

do_it_again

function my_pseudo_var'get () return byte is
    -- this is bad, too because there's a space !
end procedure
```


## Filenames are lowercased, includes statements too ##

All jal files must be lowercased. So:

**Good**
```
$ ls 16f88.jal
```

**Bad**
```
$ ls 16F88.jal
```

Being consistent, include statements are lowercased, too:

**Good**
```
include 16f88
```

**Bad**
```
include 16F88
```


## Inform readers what should be considered private ##

Functions, procedures, variables, etc... starting with an underscore is warning
to users saying "you shouldn't use me, I'm for internal use only". Play carefully with this, remember users are quite curious and may want them anyway :)

## Comment your code ##

It helps readers understand what's going on.
The comment should describe **why** your code does its thing, not what is does. That should be obvious from the code itself.


# External data #

When developing a library, you may need to collect and organize external / 3rd party data. For instance, the relation between a datasheet reference and the PICs described in this datasheet is what we call external data: it's not jal code, but _often_ used to generate some, and _always_ a source of information everyone can refer too.

External data must store in a **structured format** so everyone potentially is able to use it. Before we, developers, are also (kind of) humans, we want this format to be readable, and even writable, but also structured enough so a computer can also use and exploit it. That's why this format is [JSON](http://www.json.org/) (and not XML), which is available in many languages. This is a way to share information, amongst the many scripts used to deal jal code base.