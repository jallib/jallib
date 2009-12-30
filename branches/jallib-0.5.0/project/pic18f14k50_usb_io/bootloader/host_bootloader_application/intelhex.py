#!/usr/bin/python
#
#
# Title: intel hex reader
# Author: Albert Faber,Alexander Belchenko  Copyright (c) 2005-2007 all rights reserved.
# Adapted-by:
# Compiler:
#
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
#
# Description: Intel hex file reader
#
# Dependencies: -
#
# Notes:
#

from array import array
from binascii import hexlify, unhexlify

class IntelHex:
    ''' Intel HEX file reader. '''

    def __init__(self):
        ''' Constructor.
        @param  fname   file name of HEX file or file object.
        '''
        #public members
        self.Error = None
        self.AddrOverlap = None
        self.padding = 0x0FF
        # Start Address
        self.start_addr = None

        # private members
        self._buf = {}
        self._readed = False
        self._eof = False
        self._offset = 0

    def readfile(self, fname):
        ''' Read file into internal buffer.
        @return True    if successful.
        '''
        if self._readed:
            return True

        if not hasattr(fname, "read"):
            f = file(fname, "rU")
            fclose = f.close
        else:
            f = self._fname
            fclose = None

        self._offset = 0
        self._eof = False

        result = True

        for s in f:
            if not self.decode_record(s):
                result = False
                break

            if self._eof:
                break

        if fclose:
            fclose()

        self._readed = result
        return result

    def decode_record(self, s):
        ''' Decode one record of HEX file.
        @param  s       line with HEX record.
        @return True    if line decode OK, or this is not HEX line.
                False   if this is invalid HEX line or checksum error.
        '''
        s = s.rstrip('\r\n')
        if not s:
            return True       # empty line

        if s[0] == ':':
            try:
                bin = array('B', unhexlify(s[1:]))
            except TypeError:
                # this might be raised by unhexlify when odd hexascii digits
                self.Error = "Odd hexascii digits"
                return False
            length = len(bin)
            if length < 5:
                self.Error = "Too short line"
                return False
        else:
            return True     # first char must be ':'

        record_length = bin[0]

        if length != (5 + record_length):
            self.Error = "Invalid line length"
            return False

        addr = bin[1]*256 + bin[2]

        record_type = bin[3]
        if not (0 <= record_type <= 5):
            self.Error = "Invalid type of record: %d" % record_type
            return False

        crc = sum(bin)
        crc &= 0x0FF
        if crc != 0:
            self.Error = "Invalid crc"
            return False

        if record_type == 0:
            # data record
            addr += self._offset
            for i in xrange(4, 4+record_length):
                if not self._buf.get(addr, None) is None:
                    self.AddrOverlap = addr
                self._buf[addr] = bin[i]
                addr += 1       # FIXME: addr should be wrapped on 64K boundary

        elif record_type == 1:
            # end of file record
            if record_length != 0:
                self.Error = "Bad End-of-File Record"
                return False
            self._eof = True

        elif record_type == 2:
            # Extended 8086 Segment Record
            if record_length != 2 or addr != 0:
                self.Error = "Bad Extended 8086 Segment Record"
                return False
            self._offset = (bin[4]*256 + bin[5]) * 16

        elif record_type == 4:
            # Extended Linear Address Record
            if record_length != 2 or addr != 0:
                self.Error = "Bad Extended Linear Address Record"
                return False
            self._offset = (bin[4]*256 + bin[5]) * 65536

        elif record_type == 3:
            # Start Segment Address Record
            if record_length != 4 or addr != 0:
                self.Error = "Bad Start Segment Address Record"
                return False
            if self.start_addr:
                self.Error = "Start Address Record appears twice"
                return False
            self.start_addr = {'CS': bin[4]*256 + bin[5],
                               'IP': bin[6]*256 + bin[7],
                              }

        elif record_type == 5:
            # Start Linear Address Record
            if record_length != 4 or addr != 0:
                self.Error = "Bad Start Linear Address Record"
                return False
            if self.start_addr:
                self.Error = "Start Address Record appears twice"
                return False
            self.start_addr = {'EIP': (bin[4]*16777216 +
                                       bin[5]*65536 +
                                       bin[6]*256 +
                                       bin[7]),
                              }

        return True

    def _get_start_end(self, start=None, end=None):
        """Return default values for start and end if they are None
        """
        if start is None:
            start = min(self._buf.keys())
        if end is None:
            end = max(self._buf.keys())
        if start > end:
            start, end = end, start
        return start, end

    def tobinarray(self, start=None, end=None, pad=None):
        ''' Convert to binary form.
        @param  start   start address of output bytes.
        @param  end     end address of output bytes.
        @param  pad     fill empty spaces with this value
                        (if None used self.padding).
        @return         array of unsigned char data.
        '''
        if pad is None:
            pad = self.padding

        bin = array('B')

        if self._buf == {}:
            return bin

        start, end = self._get_start_end(start, end)

        for i in xrange(start, end+1):
            bin.append(self._buf.get(i, pad))

        return bin

    def tobinstr(self, start=None, end=None, pad=0xFF):
        ''' Convert to binary form.
        @param  start   start address of output bytes.
        @param  end     end address of output bytes.
        @param  pad     fill empty spaces with this value
                        (if None used self.padding).
        @return         string of binary data.
        '''
        return self.tobinarray(start, end, pad).tostring()

    def tobinfile(self, fobj, start=None, end=None, pad=0xFF):
        '''Convert to binary and write to file.

        @param  fobj    file name or file object for writing output bytes.
        @param  start   start address of output bytes.
        @param  end     end address of output bytes.
        @param  pad     fill empty spaces with this value
                        (if None used self.padding).
        '''
        if not hasattr(fobj, "write"):
            fobj = file(fobj, "wb")
            fclose = fobj.close
        else:
            fclose = None

        fobj.write(self.tobinstr(start, end, pad))

        if fclose:
            fclose()

    def minaddr(self):
        ''' Get minimal address of HEX content. '''
        aa = self._buf.keys()
        if aa == []:
            return 0
        else:
            return min(aa)

    def maxaddr(self):
        ''' Get maximal address of HEX content. '''
        aa = self._buf.keys()
        if aa == []:
            return 0
        else:
            return max(aa)

    def __getitem__(self, addr):
        ''' Get byte from address.
        @param  addr    address of byte.
        @return         byte if address exists in HEX file, or self.padding
                        if no data found.
        '''
        return self._buf.get(addr, self.padding)

    def __setitem__(self, addr, byte):
        self._buf[addr] = byte

    def writefile(self, f, write_start_addr=True):
        """Write data to file f in HEX format.

        @param  f                   filename or file-like object for writing
        @param  write_start_addr    enable or disable writing start address
                                    record to file (enabled by default).
                                    If there is no start address nothing
                                    will be written.

        @return True    if successful.
        """
        fwrite = getattr(f, "write", None)
        if fwrite:
            fobj = f
            fclose = None
        else:
            fobj = file(f, 'w')
            fwrite = fobj.write
            fclose = fobj.close

        # start address record if any
        if self.start_addr and write_start_addr:
            keys = self.start_addr.keys()
            keys.sort()
            bin = array('B', '\0'*9)
            if keys == ['CS','IP']:
                # Start Segment Address Record
                bin[0] = 4      # reclen
                bin[1] = 0      # offset msb
                bin[2] = 0      # offset lsb
                bin[3] = 3      # rectyp
                cs = self.start_addr['CS']
                bin[4] = (cs >> 8) & 0x0FF
                bin[5] = cs & 0x0FF
                ip = self.start_addr['IP']
                bin[6] = (ip >> 8) & 0x0FF
                bin[7] = ip & 0x0FF
                bin[8] = (-sum(bin)) & 0x0FF    # chksum
                fwrite(':')
                fwrite(hexlify(bin.tostring()).upper())
                fwrite('\n')
            elif keys == ['EIP']:
                # Start Linear Address Record
                bin[0] = 4      # reclen
                bin[1] = 0      # offset msb
                bin[2] = 0      # offset lsb
                bin[3] = 5      # rectyp
                eip = self.start_addr['EIP']
                bin[4] = (eip >> 24) & 0x0FF
                bin[5] = (eip >> 16) & 0x0FF
                bin[6] = (eip >> 8) & 0x0FF
                bin[7] = eip & 0x0FF
                bin[8] = (-sum(bin)) & 0x0FF    # chksum
                fwrite(':')
                fwrite(hexlify(bin.tostring()).upper())
                fwrite('\n')
            else:
                self.Error = ('Invalid start address value: %r'
                              % self.start_addr)
                return False

        # data
        minaddr = IntelHex.minaddr(self)
        maxaddr = IntelHex.maxaddr(self)
        if maxaddr > 65535:
            offset = (minaddr/65536)*65536
        else:
            offset = None

        while True:
            if offset != None:
                # emit 32-bit offset record
                high_ofs = offset / 65536
                offset_record = ":02000004%04X" % high_ofs
                bytes = divmod(high_ofs, 256)
                csum = 2 + 4 + bytes[0] + bytes[1]
                csum = (-csum) & 0x0FF
                offset_record += "%02X\n" % csum 

                ofs = offset
                if (ofs + 65536) > maxaddr:
                    rng = xrange(maxaddr - ofs + 1)
                else:
                    rng = xrange(65536)
            else:
                ofs = 0
                offset_record = ''
                rng = xrange(maxaddr + 1)

            csum = 0
            k = 0
            record = ""
            for addr in rng:
                byte = self._buf.get(ofs+addr, None)
                if byte != None:
                    if k == 0:
                        # optionally offset record
                        fobj.write(offset_record)
                        offset_record = ''
                        # start data record
                        record += "%04X00" % addr
                        bytes = divmod(addr, 256)
                        csum = bytes[0] + bytes[1]

                    k += 1
                    # continue data in record
                    record += "%02X" % byte
                    csum += byte

                    # check for length of record
                    if k < 16:
                        continue

                if k != 0:
                    # close record
                    csum += k
                    csum = (-csum) & 0x0FF
                    record += "%02X" % csum
                    fobj.write(":%02X%s\n" % (k, record))
                    # cleanup
                    csum = 0
                    k = 0
                    record = ""
            else:
                if k != 0:
                    # close record
                    csum += k
                    csum = (-csum) & 0x0FF
                    record += "%02X" % csum
                    fobj.write(":%02X%s\n" % (k, record))

            # advance offset
            if offset is None:
                break

            offset += 65536
            if offset > maxaddr:
                break

        # end-of-file record
        fobj.write(":00000001FF\n")
        if fclose:
            fclose()

        return True
