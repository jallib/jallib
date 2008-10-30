#!/usr/bin/python
#
# Title: timeset, writes now.jal which contains the right date and furture time
# Author: Eur van Andel, eur@fiwihex.nl Copyright (c) 2008, all rights reserved.
# Adapted-by:
# Compiler:
# 
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
# 
# Description: this script writes the system time in a jal file that can be included in a RTC setting
# to have  a proper date and time just after programming

from time import strftime, localtime, sleep


if __name__ == "__main__":

   jal = open('now.jal','w')
   
   jal.write('-- \n')
   jal.write('-- file:      now.jal, Python generated\n')
   jal.write('-- author:    Eur van Andel, eur@fiwihex.nl\n')
   jal.write('-- purpose:   to set RTC in JAL, time is set to now + 1 minute\n')
   jal.write('-- \n')
   jal.write('\n')

   date    = localtime()[2]
   month   = localtime()[1]
   year    = localtime()[0]

   hours   = localtime()[3]
   minutes = localtime()[4]
   seconds = localtime()[5]

   minutes = minutes + 1
   if minutes > 59 :
      minutes = (minutes - 60)
      hours = hours + 1             # don't run this at 23:59, OK?

   jal.write('date    = %2d \n' % date)
   jal.write('month   = %2d \n' % month)
   jal.write('year    = %2d \n' % year)
   jal.write('hours   = %2d \n' % hours)
   jal.write('minutes = %2d \n' % minutes)
   jal.write('seconds = %2d \n' % seconds)

   print 'date is %02d-%02d-%02d' % (date, month, year)             # to see something happening
   print 'time is %02d:%02d:%02d' % (hours, minutes, seconds)

   jal.flush
   jal.close


