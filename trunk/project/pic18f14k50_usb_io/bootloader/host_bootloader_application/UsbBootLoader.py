#!/usr/bin/python
#
#
# Title: jallib USB bootloader (auto start) application
# Author: Albert Faber, Copyright (c) 2009 - 2010, all rights reserved.
# Adapted-by: Sebastien Lelong
# Compiler:
#
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
#
# Description: USB loader command line tool, see help for options and usage
#
# Dependencies: you'll need to install the LIBUSB package in order to use the application
#
# Notes:
#

import sys
import os
import usb
import time

from array import array

import intelhex
from intelhex import IntelHex

import UsbBootLoaderDriver
from UsbBootLoaderDriver import UsbBootLoaderDriver


class UsbBootLoader():

    max_program_flash_size = 128 * 1024
    bulk_erase_frame_size = 64    # defaulting to 18f4550 value
    program_flash_frame_size = 16 # |
    device_entry = None
    bootloader_offset = 0x800
    flash_hex = None

    ID_location = 0x200000
    ID_location_size = 8
    config_location = 0x300000
    config_location_size = 14

        
    # table with supported USB devices
    device_table= \
    {  
        # device_id, 
        #       PIC name, 
        #                      flash size(in bytes)
        #                               eeprom size (in bytes) 
        #                                     write frame size
        #                                         erase frame size
        0x4740: ['18f13k50'  , 0x02000, 0x80, 16, 64 ],
        0x4700: ['18lf13k50' , 0x02000, 0x80, 16, 64],
        
        0x4760: ['18f14k50'  , 0x04000, 0xFF, 16, 64 ],
        0x4720: ['18f14k50'  , 0x04000, 0xFF, 16, 64 ],
        
        0x2420: ['18f2450'   , 0x04000, 0x00, 16, 64 ],
        0x1260: ['18f2455'   , 0x06000, 0xFF, 16, 64 ],
        0x2A60: ['18f2458'   , 0x06000, 0xFF, 16, 64 ],
        
        0x4C00: ['18f24J50'  , 0x04000, 0x00, 16, 64 ],
        0x4CC0: ['18lf24J50' , 0x04000, 0x00, 16, 64 ],
        
        0x1240: ['18f2550'   , 0x08000, 0xFF, 16, 64 ],
        0x2A40: ['18f2553'   , 0x08000, 0xFF, 16, 64 ],
        0x4C20: ['18f25J50'  , 0x08000, 0x00, 16, 64 ],
        0x4CE0: ['18lf25J50' , 0x08000, 0x00, 16, 64 ],
        
        0x4C40: ['18f26J50'  , 0x10000, 0x00, 16, 64 ],
        0x4D00: ['18lf26J50' , 0x10000, 0x00, 16, 64 ],
        
        0x1200: ['18f4450'   , 0x04000, 0x00, 16, 64 ],
        0x1220: ['18f4455'   , 0x06000, 0x00, 16, 64 ],
        0x2A20: ['PIC18F4458', 0x06000, 0xFF, 16, 64 ],
        
        0x4C60: ['18f44J50'  , 0x04000, 0x00, 16, 64 ],
        0x4D20: ['18lf44J50' , 0x04000, 0x00, 16, 64 ],
        
        0x1200: ['18f4550'   , 0x08000, 0xFF, 16, 64 ],
        0x2A00: ['18f4553'   , 0x08000, 0xFF, 16, 64 ],
        
        0x4C80: ['18f45J50'  , 0x08000, 0x00, 16, 64 ],
        0x4D40: ['18lf45J50' , 0x08000, 0x00, 16, 64 ],
        
        0x4CA0: ['18f46J50'  , 0x10000, 0x00, 16, 64 ],
        0x4D60: ['18f46J50'  , 0x10000, 0x00, 16, 64 ],
        
        0x4100: ['18f65J50'  , 0x08000, 0x00, 16, 64 ],
        0x1560: ['18f66J50'  , 0x10000, 0x00, 16, 64 ],
        0x4160: ['18f66J55'  , 0x18000, 0x00, 16, 64 ],
        0x4180: ['18f67J50'  , 0x20000, 0x00, 16, 64 ],
        0x41A0: ['18f85J50'  , 0x08000, 0x00, 16, 64 ],
        0x41E0: ['18f86J50'  , 0x10000, 0x00, 16, 64 ],
        0x1F40: ['18f86J55'  , 0x18000, 0x00, 16, 64 ],
        0x4220: ['18f87J50'  , 0x20000, 0x00, 16, 64 ],

        0x5860: ['18f27J53'  , 0x20000, 0x00, 64, 1024 ],
        0x58E0: ['18f47J53'  , 0x20000, 0x00, 64, 1024 ],
    }
    
          
    def __init__(self, ):
        if sys.platform=="win32":
            self.fileseparator="\\"
        else:
            self.fileseparator="/"


    def WaitForDevice(self):
     
        device_found = False
        version_number = None
        
        while version_number == None :
            usb_driver = UsbBootLoaderDriver()
        
            try: 
                version_number = usb_driver.ReadVersion()
            
            except AttributeError: 
                # if we get there, this means USB object doesn't have
                # appropriate method defined, meaning USB device
                # doesn't exist on the system (eg. not plugged, not
                # configure yet, ...). let's wait some more
                pass

            
        usb_driver.CloseDevice()
        return version_number
             
    def GetDeviceType(self):
     
        usb_driver = UsbBootLoaderDriver()
        
        strRet = "PIC not found"
        rx_buffer = []
        try: 
            # read device ID from location 0x3FFFFE
            rx_buffer = usb_driver.ReadFlashBlock( 0x3F, 0xFF, 0xFE, 2 )

            print versionNumber 
            device_found = True
        except:
            """ catch exception """            
        
        usb_driver.CloseDevice()

        device_id = ( ( int( rx_buffer[1] ) ) << 8 ) + int( rx_buffer[0] )
        device_rev = device_id & 0x001F


        # mask revision number
        device_id = device_id  & 0xFFE0
        
        hexValue = "%X" % device_id
        
        self.program_flash_size = 0x0000
                
        for device_entry in self.device_table :
            if ( device_id == device_entry ) :
                self.program_flash_size = self.device_table[ device_entry ][1]                
                self.device_entry = device_entry
                self.program_flash_frame_size = self.device_table[ device_entry ][3]
                self.bulk_erase_frame_size = self.device_table[ device_entry ][4]

    def GetPICName( self ) :
        if ( self.device_entry == None ) :
            self.GetDeviceType()
        if ( self.device_entry != None ) :
            return self.device_table[ self.device_entry ][0]
        return None
        
    def GetPICDeviceID( self ) :
        if ( self.device_entry == None ) :
            self.GetDeviceType()
        if ( self.device_entry != None ) :
            return "%04X" % self.device_entry
        else :
            return None
                    

    def LoadHexFile(self, filename):
        # start with a clean hex file
        self.file_hex = intelhex.IntelHex()
        self.file_hex.readfile( filename ) 



    def EraseUserFlash(self):
        
        usb_driver = UsbBootLoaderDriver()
        
        try:  
            for address in range( self.bootloader_offset, self.program_flash_size, self.bulk_erase_frame_size ) :

                addr_u = ( address >> 16 ) & 0xFF  
                addr_h = ( address >> 8  ) & 0xFF
                addr_l = ( address       ) & 0xFF

                usb_driver.EraseFlashBlock( 1, addr_u, addr_h, addr_l )

        except:
            print "Erase failed \n"
            raise
                      
        usb_driver.CloseDevice()

    def _WriteFlashRegion(self, usb_driver, start_address, end_address, frame_size ):
        
        for address in range( start_address, end_address, frame_size ) :

            addr_u = ( address >> 16 ) & 0xFF  
            addr_h = ( address >> 8  ) & 0xFF
            addr_l = ( address       ) & 0xFF
            
            data = []
            
            # copy data to flex_hex memory
            for i in range(0,frame_size): 
                data.append( self.file_hex[ address + i ] )
                                
            data = usb_driver.WriteFlashBlock( addr_u, addr_h, addr_l, frame_size )
            

     
    def WriteFlash(self, start_address, end_address, write_eeprom, write_config = False, write_id = False):
        
        # start with a clean hex file
        self.flash_hex = intelhex.IntelHex()

        if ( start_address == None ) :
            start_address = 0x800

        if ( end_address == None ) :
            end_address = self.program_flash_size

        if ( end_address > self.program_flash_size ) :
            end_address = self.program_flash_size

        start_address = start_address & 0xFFFFF0

        num_frames = self.program_flash_size / self.program_flash_frame_size
        
        base_address = 0
        
        usb_driver = UsbBootLoaderDriver(self.program_flash_frame_size)
        
        self.EraseUserFlash()
                
        base_address = 0
        
        for k in range(0,num_frames):

            valid_frame = False

            # check if there is any data to flash in the memory region
            for j in range(0,self.program_flash_frame_size):
                 byteVal = self.file_hex[ base_address + j ]
                 if  byteVal != 0xFF :
                     valid_frame = True
        
            # got some valid data, do erase / 4 writes
            if ( valid_frame ) :
            
                 if ( j < ( self.bootloader_offset / self.program_flash_frame_size ) ) :
                      print "Overwriting boot block !!"
                 elif ( j > num_frames ) :
                      print "HEX file out of bounds!!"
                 else :
                        addr_u = ( base_address >> 16 ) & 0xFF  
                        addr_h = ( base_address >> 8  ) & 0xFF
                        addr_l = ( base_address       ) & 0xFF
        
                        block_offset = 0
        
                        for i in range( 0, self.program_flash_frame_size / self.program_flash_frame_size ) :
                            addr_u = ( ( base_address + block_offset  ) >> 16 ) & 0xFF  
                            addr_h = ( ( base_address + block_offset  ) >> 8  ) & 0xFF
                            addr_l = ( ( base_address + block_offset  )       ) & 0xFF
                              
                            buffer = []
                              
                            for j in range( 0, self.program_flash_frame_size ) :
                                buffer.append(  self.file_hex[ base_address + block_offset + j ] )
                            
                            usb_driver.WriteFlashBlock( buffer, addr_u, addr_h, addr_l )
                            
                            block_offset = block_offset + self.program_flash_frame_size
                    
                    
            base_address = base_address + self.program_flash_frame_size
  
        usb_driver.CloseDevice()


    def _ReadFlashRegion(self, usb_driver, start_address, end_address, frame_size ):
        
        for address in range( start_address, end_address, frame_size ) :

            addr_u = ( address >> 16 ) & 0xFF  
            addr_h = ( address >> 8  ) & 0xFF
            addr_l = ( address       ) & 0xFF
            
            data = usb_driver.ReadFlashBlock( addr_u, addr_h, addr_l, frame_size )
            
            # copy data to flex_hex memory
            for i in range(0,frame_size): 
                self.flash_hex[ address + i ] = data[i    ]
                # print "READ REGION " + "%02X" % self.flash_hex[ address + i ]


    def ReadFlash(self, start_address, end_address, read_eeprom = False, read_config = False, read_id = False):
        
        usb_driver = UsbBootLoaderDriver()

        # start with a clean hex file
        self.flash_hex = intelhex.IntelHex()

        if ( start_address == None ) :
            start_address = 0

        if ( end_address == None ) :
            end_address = self.program_flash_size

        if ( end_address > self.program_flash_size ) :
            end_address = self.program_flash_size

        start_address = start_address & 0xFFFFF0
        end_address = end_address & 0xFFFFF0
        
            
        try:  
            self._ReadFlashRegion( usb_driver, start_address, end_address, self.program_flash_frame_size )
        except:
            print "Read failed \n"
                      


        try:  
            if read_id :
                # print "READ ID FROM " + "%06X" % self.ID_location + " TO " + "%06X" % ( self.ID_location + self.ID_location_size )
                self._ReadFlashRegion( usb_driver, self.ID_location, self.ID_location + self.ID_location_size, self.ID_location_size )
        except:
            print "Read ID location failed \n"
                      


        try:  
            if read_config :
                # print "READ CONFIG FROM " + "%06X" % self.config_location + " TO " + "%06X" % ( self.config_location + self.config_location_size )
                self._ReadFlashRegion( usb_driver, self.config_location, self.config_location + self.config_location_size, self.config_location_size )
        except:
            print "Read config failed \n"
                      
        # print "CONFIG AT 0 " + "%02X" % flash_hex[ self.config_location + 2 ]

                      
        usb_driver.CloseDevice()


    def DumpHexMemory(self, data, start_address, end_address ):        

        
        strOut = ""

        try:  
            for address in range( start_address, end_address, 16 ) :

                strTmp = "%06X" % address + " " 
                 
                for i in range(0,16): 
                    if ( ( address + i ) < end_address ):
                        strTmp = strTmp + "%02X" % data[ address + i ] + " " 
    
                strOut = strOut + strTmp  + "\n"
        except:
            print "Dump failed \n"
            strOut = None
                      
        return strOut


    def DumpFlashHexMemory(self, start_address, end_address ):        
        if ( end_address == None ) :
            end_address = self.program_flash_size
        return self.DumpHexMemory( self.flash_hex, start_address, end_address )

    def DumpFlashIDLocation(self):        
        return self.DumpHexMemory( self.flash_hex, self.ID_location, self.ID_location + self.ID_location_size )
    def DumpFlashConfig(self):        
        return self.DumpHexMemory( self.flash_hex, self.config_location, self.config_location + self.config_location_size )


    def DumpFileHexMemory(self, start_address, end_address ):        
        if ( end_address == None ) :
            end_address = self.program_flash_size
        return self.DumpHexMemory( self.file_hex, start_address, end_address )
        
    def WriteFlashHexToFile(self, fname, start_address ):        
        self.flash_hex.writefile( fname, start_address )
    
    def ResetDevice(self):
        try:
            usb_driver = UsbBootLoaderDriver()
            usb_driver.Reset()
            usb_driver.CloseDevice()
            
        except:
            """ catch exception """
    

if __name__ == '__main__':
    import getopt
    import os
    import sys
    
    usage = '''Python USB Bootloader utility.
Usage:
    python UsbBootLoader.py [options] command file.hex

Arguments:
    file.hex                name of hex file to processing.
    command                 read ; read data from flash, write to file.hex if specified
                            dump ; read data from flash, dumps data to console
                            write; read data from file.hex, write to flash
                            erase; erase user data, NOTE:
                                   file.hex/range/eeprom/configuration/id_location options will be ignored
Options:
    -h, --help              this help message.
    -c, --configuration     read/write configuration bytes
    -e, --eeprom            read/write eeprom bytes
    -i, --id-location       read/write ID locations bytes
    -r, --range=START:END   specify address range for reading/writing
                            (ascii hex value).
    
    -x, --reset             reset on exit
    -v, --verbose           shows details info
'''

    start = 0x0800
    end = None
    configuration = False
    eeprom = False
    id_location = False
    verbose = 0
    reset = False
        
    try:
        # print "args "
        # print sys.argv[1:]
        opts, args = getopt.getopt(sys.argv[1:], "hceir:vx",
                                 ["help", "configuration", "eeprom", "id-location", "range=",
                                  "verbose","reset"])

        # print opts
        # print args
    
        for o, a in opts:
            # print "o is " + o 
            if o in ("-h", "--help"):
                print usage
                sys.exit(0)
            elif o in ("-c", "--configuration"):
                try:
                    configuration = True
                except:
                    raise getopt.GetoptError, 'Bad configuration value'
            elif o in ("-e", "--eeprom"):
                try:
                    eeprom = True
                except:
                    raise getopt.GetoptError, 'Bad eeprom value'
            elif o in ("-x", "--reset"):
                try:
                    reset = True
                except:
                    raise getopt.GetoptError, 'Bad reset value'
            elif o in ("-i", "--id-location"):
                try:
                    id_location = True
                except:
                    raise getopt.GetoptError, 'Bad id_location value'
            elif o in ("-r", "--range"):
                try:
                    l = a.split(":")
                    if l[0] != '':
                        start = int(l[0], 16)
                        if l[1] != '':
                            end = int(l[1], 16)
                    # print "start %d" & start                             
                    # print "end %d" & end                             
                except:
                    raise getopt.GetoptError, 'Bad range value(s)'
            elif o in ("-v", "--verbose"):
                try:
                    verbose = 1
                except:
                    raise getopt.GetoptError, 'Bad verbose value'
            
        if not args:
            raise getopt.GetoptError, 'Hex file is not specified'
            
        if len(args) > 3:
            raise getopt.GetoptError, 'Too many arguments'

    except getopt.GetoptError, msg:
        print msg
        print usage
        sys.exit(2)

    command = args[0]
    file_name = None
    
    if len(args) == 2:
        file_name = args[1]
        #        import os.path
        #        name, ext = os.path.splitext(fin)
        #        fout = name + ".bin"
        #    else:
        #        fout = args[1]
     
    print "COMMAND " + command 
    if file_name == None :
        print "FILENAME NONE"
    else:
        print "FILENAME " + file_name

    #sys.exit(hex2bin(fin, fout, start, end, size, pad))
    
    print"Waiting for USB PIC bootloader device ..."

    test_loader = UsbBootLoader()
    
    print"Boot device version number " + str( test_loader.WaitForDevice() )

    pic_name = test_loader.GetPICName()
    device_id = test_loader.GetPICDeviceID()
    
    if ( pic_name != None ) :

        print "Found PIC, device_id " + device_id + " name " + test_loader.GetPICName()

        if command == "read":
            if file_name == None :
                print "Read command failed, file name not specified "
                sys.exit(1)
                
            test_loader.ReadFlash( start, end , eeprom, configuration, id_location)
            test_loader.WriteFlashHexToFile( file_name, start )
            
        elif command == "write":
            
            if file_name == None :
                print "Write command failed, file name not specified "
            else:
                if not os.path.isfile(file_name):
                    print "File not found " + file_name
                    sys.exit(1)
                print "Flashing file %s" % file_name
                test_loader.LoadHexFile( file_name )
                test_loader.WriteFlash( start, end, eeprom, configuration, id_location)
                
        elif command == "erase":
            print "Erase command "
            test_loader.EraseUserFlash()
        elif command == "dump":
            test_loader.ReadFlash( start, end , eeprom, configuration, id_location)
            print test_loader.DumpFlashHexMemory( start, end )
        else :
            print "UNKNOWN COMMAND " + command
            print usage
            sys.exit(0)
            
        if reset == True :
            test_loader.ResetDevice()


    else:
        print "PIC type " + repr(device_id) + " not supported"
        
    sys.exit( 0 )
