## After compiling ##

So you succesfully compiled your JAL program, using the jallib source, see

> [Using the SVN repository as library for JALV2](http://code.google.com/p/jallib/wiki/UnixCompilingFromSvnHowto)


So you have a .hex file. Now what?


# Programmer #

There are lots of programmers. Some work on a Parallel Port, some on a serial port. But your shiny new Unix machine only has USB ports.

Here, I'll teach you to use the Wisp648 programmer, which you can buy here:

http://www.voti.nl/wisp648/index.html

This programmer uses a serial connection, because the serial protocol, also called RS232 is much simpler than the USB protocol.

# Serial port #

But you don't have one! No, that's why we will use an USB-to-serial converter. This looks like a cable with a serial connector on one end (a male [DE9](DE9.md)http://en.wikipedia.org/wiki/DE-9_connector#DE-9_connector plug to be precise) and a USB-A plug on the other end. These come in many colors and brands and the difference under Posix is mainly the availability of drivers.

## The Great Driver Hunt ##
Get such a cable, try to see if it mentions "Linux" or "Mac" on the packaging. If it doesn't, don't worry. Plug it in. Depending on the flavor of Posix you have, there are several ways to get info for your particular converter. What you are lookig for is this:

```
USB-Serial Controller:

  Version:	3.00
  Bus Power (mA):	500
  Speed:	Up to 12 Mb/sec
  Manufacturer:	Prolific Technology Inc.
  Product ID:	0x2303
  Vendor ID:	0x067b

```

On a Mac this is listed in System Profiler.app, which can be run from /Applications or via About this Mac/More Info.

Hunt the web for drivers. Don't give up until you have one. If you can't find anything, buy another. Google "<your OS> USB serial converter" until you find a better one.

## Driver installation ##

OK, you found it. You probably needed to reboot (shudder!). Now check /dev for any suspicious new stuff. Remove the cable, do an ls -lt of /dev, plug it in and repeat ls -lt /dev. Notice any difference?

```
$ ls -lt /dev | head
total 4
crw-rw-rw-   1 root  wheel       5,   1 Aug 25 23:36 ptyp1
crw--w----   1 eur   tty         4,   1 Aug 25 23:36 ttyp1
crw-rw-rw-   1 root  wheel       8,   0 Aug 25 23:36 random
crw-rw-rw-   1 root  wheel       5,   5 Aug 25 23:36 ptyp5
crw-rw-rw-   1 root  wheel       3,   2 Aug 25 23:36 null
crw-rw-rw-   1 root  wheel       9,  15 Aug 25 23:30 cu.usbserial
crw-rw-rw-   1 root  wheel       9,  14 Aug 25 23:30 tty.usbserial
crw-rw-rw-   1 root  wheel       4,   5 Aug 25 23:19 ttyp5
crw-rw-rw-   1 root  wheel       2,   0 Aug 25 23:19 tty
$ ls -lt /dev | head
total 4
crw-rw-rw-   1 root  wheel       5,   1 Aug 25 23:36 ptyp1
crw--w----   1 eur   tty         4,   1 Aug 25 23:36 ttyp1
crw-rw-rw-   1 root  wheel       8,   0 Aug 25 23:36 random
crw-rw-rw-   1 root  wheel       5,   5 Aug 25 23:36 ptyp5
crw-rw-rw-   1 root  wheel       3,   2 Aug 25 23:36 null
crw-rw-rw-   1 root  wheel       4,   5 Aug 25 23:19 ttyp5
crw-rw-rw-   1 root  wheel       2,   0 Aug 25 23:19 tty
crw--w----   1 eur   tty         4,   4 Aug 25 23:17 ttyp4
crw-rw-rw-   1 root  wheel       5,   4 Aug 25 23:17 ptyp4
$ 
```


Bingo. We will use tty.usbserial from here on, and yes, your port will be named different.

## Python Script ##

Xwisp648 comes with a shell script that should work on most OS. Get it here:

http://www.voti.nl/xwisp

and read all. For the impatient, the actual source is here:

http://www.voti.nl/xwisp/xwisp_src.tar.gz

I assume you know how to unpack a GZipped Tape ARchive. Tape as in a thin plastic strip loaded with chromium oxide particles.

Put the xwisp.py file somewhere in your PATH, say in: `/usr/local/xwisp/xwisp.py`

## Python ##

Check if your system has python:

```
$ python
Python 2.5 (r25:51918, Sep 19 2006, 08:49:13) 
[GCC 4.0.1 (Apple Computer, Inc. build 5341)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```

It has.

```
$ python
-bash: python: command not found
```

It hasn't. Get Python from python.org or preferably from your ports/packages/RPM system.

## Connection ##

Plug in the USB-to-serial converter. Plug in the programmer. Give it some juice, either by connecting it to a juiced-up target PIC, or by applying wall-wart power to the programmer itself.

Now test the connection to the programmer with:

`python /usr/local/bin/xwisp/xwisp.py port /dev/tty.usbserial talk`

Which should give a response like:

```
$ xw talk
XWisp 1.30, command line mode
hardware: Wisp628 1.23 (fast) (wisp648 firmware)

[..]
    import termios, TERMIOS, sys
ImportError: No module named TERMIOS
  
```

Don't mind the errors. `hardware: Wisp628 1.23 (fast) (wisp648 firmware)` is what you are looking for. This means the xwisp.py script has found the programmer and has talked to it.

If you get this:

```
xw talk
XWisp 1.30, command line mode

[..]
    "send='" + Char + "' received='" + Reply + "'"
WBus_Protocol_Error: send='t' received=''
```

then the Python script can't talk to the programmer. Either the cable is not connected, or the programmer is not powered. Did the LED blink twice when you applied the power?

# Programming PICs #

This is what it is all about: actually flashing a .hex file into a PIC.

You compiled a JAL program, say blink-16f877a.jal, successfully. Now you have a hex file. Send this hex file to the programmer with the following command:


`python /usr/local/bin/xwisp/xwisp.py port /dev/tty.usbserial go blink-16f877a.hex`

and check the output. You should see something like:

```
XWisp 1.30, command line mode
hardware: Wisp628 1.23 (fast) (wisp648 firmware)
target: 16f877a, device code 0E20 revision bits 07
OK                                                          
```

Congratulations! Your LED blinks!


## programming shell script ##

The command to program the hex file can also be put in a shell script, for instance named xw. This should be the contents of xw:

`python ~/freebsd/python/xwisp.py port /dev/tty.usbserial $*`

Here too, point to the directory that houses the xwisp.py file. Put the serialposix.py file in that directory too. Oh, and use the serial port name your el-cheapo USB-serial converter generates. Make sure it exists in /dev

This script should be executable as well:

`chmod +x xw`

Now you can  program with:

`xw go jal_prog.hex`

Neat, huh?