#
# Title: JALPIC control program.
#
# Author: Rob Jansen, Copyright (c) 2019..2019, all rights reserved.
#
# Adapted-by:
#
# Compiler:
#
# This file is part of jallib (https://github.com/jallib/jallib)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
#
# Description: This script handles the programming of the application PIC on the 
#              JALPIC One development board. It servers as an interface between 
#              JalEdit or JalIDE and the JALPIC One board to ease the programming 
#              process or as interface to ease manual programmig of the application PIC.


import sys
import os
import serial
import keyboard

default_baudrate = 115200
default_port = "com3"
ser = serial.Serial()


# Initialize and open the serial port. Returns True when successful.
def serial_init(which_port):
    ser.port = which_port
    ser.baudrate = default_baudrate
    ser.bytesize = 8
    ser.parity = 'N'
    ser.stopbits = 1
    ser.timeout = 30  # 30 second wait timeout for reading response. Programming may take some time.
    ser.xonxoff = 0
    ser.rtscts = 1  # RTS/CTS must be enabled!
    try:
        ser.open()
        if ser.is_open:
            port_is_open = True
        else:
            port_is_open = False
    except:
        port_is_open = False
    if port_is_open:
        return True
    else:
        print("Could not open serial port:",which_port)
        return False


def serial_end():
    try:
        ser.close()
    except:
        pass


def erase_flash():
    ser.write(b'!EF\r\n')
    response = ser.readline()
    # Response format is: b'0\r\n' for 0 (OK) or b'1\r\n' for 1 (not OK).
    if (response == b'0\r\n'):
        print("Flash erased")
        return True
    else:
        print("Flash not erased")
        return False


def erase_eeprom():
    ser.write(b'!EE\r\n')
    response = ser.readline()
    # Response format is: b'0\r\n' for 0 (OK) or b'1\r\n' for 1 (not OK).
    if (response == b'0\r\n'):
        print("EEPROM erased")
        return True
    else:
        print("EEPROM not erased")


def start_programmer():
    ser.write(b'!P\r\n')
    response = ser.readline()
    # Response format is: b'0\r\n' for 0 (OK) or b'1\r\n' for 1 (not OK).
    if (response == b'0\r\n'):
        print("Programmer mode started")
        return True
    else:
        print("Programmer mode not started")


def copy_file(which_file):
    ser.write(open(which_file, "rb").read())
    response = ser.readline()
    # Response format is: b'0\r\n' for 0 (OK) or b'1\r\n' for 1 (not OK).
    if (response == b'0\r\n'):
        print("Device programmed")
        return True
    else:
        print("Device not programmed")
        return False


if __name__ == "__main__":
    # Main program starts here.
    print("Script for programming the JALPIC development board.")
    # If 2 arguments are given we assume the default port.
    if (len(sys.argv) == 2):
        hexfile = sys.argv[1]
        comport = default_port
    elif (len(sys.argv) == 3):
        hexfile = sys.argv[1]
        comport = sys.argv[2]
    else:
        print("Arguments must be <file> and optional <comport>.")
        print("If no <comport> is given, the program uses:", default_port)
        sys.exit(1)

    # Check if file exists.
    if os.path.isfile(hexfile): 
        all_ok = True
    else:
        print("File not found:",hexfile)
        all_ok = False
		
    # No nested if's to make the program more readable :-)
    if all_ok:
        all_ok = serial_init(comport)
    if all_ok:
        all_ok = erase_flash()
	# If no EEPROM is used, the EEPROM programming could be removed.
    if all_ok:
        all_ok = erase_eeprom()
    if all_ok:
        all_ok = start_programmer()
    if all_ok:
        all_ok = copy_file(hexfile)
    if all_ok:
        serial_end()
        sys.exit(0)
    else:
	    # In case of an error we ask the user to press escape otherwise the error
		# will not be visible when programming from e.g. JalEdit. In this way the
        # user can see what went wrong.
        print("Programming failed, press escape to continue.")
        keyboard.wait('esc')
        serial_end()
        sys.exit(1)
