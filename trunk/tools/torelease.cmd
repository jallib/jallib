/* ------------------------------------------------------------------------ *
 * Title: Process TORELEASE file to check consistency with Jallib           *
 *                                                                          *
 * Author: Rob Hamerling, Copyright (c) 2008..2014, all rights reserved.    *
 *                                                                          *
 * Adapted-by:                                                              *
 *                                                                          *
 * Revision: $Revision$                                              *
 *                                                                          *
 * Compiler: N/A                                                            *
 *                                                                          *
 * This file is part of jallib  http://jallib.googlecode.com                *
 * Released under the BSD license                                           *
 *              http://www.opensource.org/licenses/bsd-license.php          *
 *                                                                          *
 * Description:                                                             *
 * - read TORELEASE and                                                     *
 *   collect entries into compound variable f.                              *
 *   on a per-directory ('part') basis (1st level subdirectory)             *
 *   collect PICnames used in filenames of sample programs                  *
 * - check if there is a basic blink-a-led sample for every device file     *
 * - check if there is a device file for every sample                       *
 * - collect some statistics for every main library group                   *
 * - list these statistics                                                  *
 * - collect Jallib contents (directory tree) and                           *
 *    - list if unreleased                                                  *
 *    - list if sample released but device file not                         *
 * - sort each of the parts (on first level directory)                      *
 *   and create new TORELEASE                                               *
 * - report and comment-out duplicate entries                               *
 *                                                                          *
 * Sources: none                                                            *
 *                                                                          *
 * Notes:                                                                   *
 *  - When a commandline argument 'runtype' is specified a more extensive   *
 *    listing is produced: ALL unrelease files are listed,                  *
 *    (by default unreleased device files and unreleased basic blink-a-led  *
 *     samples are not listed, only counted).                               *
 *                                                                          *
 * ------------------------------------------------------------------------ */

parse upper arg runtype .                                   /* any: list all unreleased files */

base       = 'k:\jallib'                                    /* base Jallib directory */
libdir     = base'\include'                                 /* libraries */
smpdir     = base'\sample'                                  /* samples */
projdir    = base'\project'                                 /* project files */
torelease  = base'\TORELEASE'                                 /* TORELEASE file */
newrelease = 'TORELEASE.NEW'                                /* release list */
list       = 'torelease.lst'                                /* script output */

fcount.    = 0                                              /* zero all file counts */
dev.       = '-'                                            /* PIC names in device files */
smppic.    = '-'                                            /* PIC names in sample files */
blinkpic.  = '-'                                            /* PIC names in blink sample files */
missing.   = ''                                             /* in TORELEASE but not in Jallib */
missing.0  = 0                                              /* no missing files detected */

f.                 = 0                                      /* jallib parts */

blink_sample_count = 0

say 'Checking contents of' torelease 'against' base
if runtype = '' then do
   say '   Excluding unreleased device files and basic blink samples'
   say '   To include these specify any non blank character as argument'
end

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                                   /* load Rexx utilities */

call SysFileDelete list
call stream  list, 'c', 'open write'
call lineout list, ''
call lineout list, 'Analysis of' filespec('N', torelease),
                    'dd' date('N')  time('N') '(local time)'
call lineout list, ''

call stream torelease, 'c', 'open read'
say 'Analysing' torelease
do linenumber = 1  while lines(torelease)                   /* collect files */
   ln = linein(torelease)
   if length(ln) < 2  |  left(word(ln,1),1) = '#' then      /* empty or comment line */
      iterate
   ln = tolower(ln)                                         /* ensure lower case */
   if stream(base'/'ln, 'c', 'query exists') = '' then do   /* file not found */
      i = missing.0 + 1
      missing.i = format(linenumber,4)'.  'ln               /* remember */
      say 'missing:' ln
      missing.0 = i
   end
   select
      when left(ln,15) = 'include/device/' then
         part = 'device'
      when left(ln,17) = 'include/external/' then
         part = 'external'
      when left(ln,19) = 'include/filesystem/' then
         part = 'filesystem'
      when left(ln,12) = 'include/jal/' then
         part = 'jal'
      when left(ln,19) = 'include/networking/' then
         part = 'networking'
      when left(ln,19) = 'include/peripheral/' then
         part = 'peripheral'
      when left(ln,17) = 'include/protocol/' then
         part = 'protocol'
      when left(ln,4) = 'doc/' then
         part = 'doc'
      when left(ln,8) = 'project/' then
         part = 'project'
      when left(ln,7) = 'sample/' then do
         part = 'sample'
         parse var ln 'sample/' picname '_' pgmname .         /* separate Picname and Pgmname */
         if picname \= '' then do                              /* picname derived */
            smppic.picname = picname                           /* PIC with at least 1 sample */
            if pgmname = 'blink_hs.jal'         |,
               pgmname = 'blink_intosc.jal'     |,
               pgmname = 'blink_hs_usb.jal'     |,
               pgmname = 'blink_intosc_usb.jal' then do
               blink_sample_count = blink_sample_count + 1     /* count 'm */
               blinkpic.picname = picname                      /* blink sample found for this PIC */
            end
         end
      end
      otherwise
         say 'Unrecognised entry:' ln
         iterate
   end
   part = toupper(part)                                      /* 'part' must be uppercase */
   k = f.part.0 + 1                                          /* counts per part */
   f.part.k = ln
   f.part.0 = k
end
call stream torelease, 'c', 'close'                         /* done */

say 'Checking if a blink sample is released for every released device file'
do i = 1 to f.device.0                                      /* all device files */
   if f.device.i \= 'include/device/chipdef_jallib.jal' then do
      parse value filespec('n',f.device.i) with picname '.jal' .   /* PIC name */
      if blinkpic.picname \= picname then
         call lineout list, 'No basic blink sample for' picname
      dev.picname = picname                                 /* remember device file */
   end
end

say 'Classify and count released samples in major groups'
do i = 1 to f.sample.0                                      /* all samples */
   parse var f.sample.i 'sample/' picsmp '.jal' .           /* sample filename */
   parse var picsmp picname '_' pgmname .                   /* extract pic and pgm */
   if picname \= dev.picname then do                        /* not released device file */
      call lineout list, 'Device file' picname'.jal',
                         'for sample' picsmp'.jal not released'
   end
   select
      when pgmname = 'blink_hs'         |,
           pgmname = 'blink_intosc'     |,                   /* basic BLINK sample */
           pgmname = 'blink_hs_usb'     |,
           pgmname = 'blink_intosc_usb' then
         fcount.blink = fcount.blink + 1
      when left(pgmname,3) = 'adc' then                      /* ADC sample */
         fcount.adc = fcount.adc + 1
      when left(pgmname,3) = 'i2c' then                      /* I2C sample */
         fcount.i2c = fcount.i2c + 1
      when left(pgmname,3) = 'lcd'  |,                       /* LCD sample */
           left(pgmname,4) = 'glcd' then                     /* GLCD sample */
         fcount.lcd = fcount.lcd + 1
      when left(pgmname,7) = 'network' then                  /* networking sample */
         fcount.networking = fcount.networking + 1
      when left(pgmname,3) = 'pwm' then                       /* PWM sample */
         fcount.pwm = fcount.pwm + 1
      when left(pgmname,6) = 'serial' then                   /* SERIAL sample */
         fcount.serial = fcount.serial + 1
      when left(pgmname,3) = 'usb' then                      /* USB sample */
         fcount.usb = fcount.usb + 1
      otherwise do
         fcount.othersamples = fcount.othersamples + 1           /* other sample */
      end
   end
end

total_libraries = f.external.0 + f.filesystem.0 + f.jal.0 +,
                  f.networking + f.peripheral.0 + f.protocol.0
total_samples   = fcount.adc + fcount.blink  + fcount.i2c + fcount.lcd +,
                  fcount.networking + fcount.pwm + fcount.serial + fcount.usb +,
                  fcount.othersamples

call lineout list, ''
call lineout list, 'TORELEASE contains' format(f.device.0 - 1,4) 'device files'
call lineout list, '                  ' format(total_libraries,4) 'function libraries'
call lineout list, '                  ' format(total_samples,4) 'samples in following categories:',
                                          '(based on primary library)'
call lineout list, '                      ' format(fcount.adc,4) 'ADC samples'
call lineout list, '                      ' format(fcount.blink,4) 'blink samples'
call lineout list, '                      ' format(fcount.i2c,4) 'I2C samples'
call lineout list, '                      ' format(fcount.lcd,4) '[G]LCD samples'
call lineout list, '                      ' format(fcount.networking,4) 'Networking samples'
call lineout list, '                      ' format(fcount.pwm,4) 'PWM samples'
call lineout list, '                      ' format(fcount.serial,4) 'Serial samples'
call lineout list, '                      ' format(fcount.usb,4) 'USB samples'
call lineout list, '                      ' format(fcount.othersamples,4) 'Other samples'
call lineout list, '                  ' format(f.project.0,4) 'project files'
call lineout list, '                  ' format(fcount.misc,4) 'other files'
call lineout list, ''

call lineout list, ''
call charout list, 'Unreleased libraries'
if runtype = '' then
  call charout list, ' (excluding unreleased device files)'
else
  call charout list, ' and device files'
call lineout list, ''
call lineout list, '--------------------------------------------------------'

say 'Searching for unreleased libraries'
call SysFileTree libdir'/*.jal', 'fls.', 'FSO'               /* libraries */
if fls.0 = 0 then do
   call lineout list, "Found no libraries in '"libdir"'"
  return 1
end
unlisted = 0
unlisteddevice = 0
do i = 1 to fls.0
   fls.i = translate(fls.i, '/', '\')                        /* backward to forward slash */
   fs = substr(fls.i, length(base) + 2)                      /* remove base prefix */
   call SysFileSearch fs, torelease, x.                      /* search file in list */
   if x.0 = 0 then do                                        /* file not found */
      unlisted = unlisted + 1
      parse var fs 'include/device/' picname .               /* if devicename: get name of PIC */
      if picname \= '' then do                               /* unreleased device file */
         unlisteddevice = unlisteddevice + 1
         if runtype \= '' then
            call lineout list, fs
         if smppic.picname \= '-' then                       /* sample present! */
           call lineout list, fs '(unreleased device file, but sample program released)'
      end
      else do                                                /* not device file */
         call lineout list, fs                               /* not released lib */
      end
   end
end
call stream torelease, 'c', 'close'                         /* done */
call lineout list, ''
if runtype \= '' then
   call lineout list, unlisted 'unreleased include files'
else
   call lineout list, unlisted - unlisteddevice 'unreleased libraries',
                      '+' unlisteddevice 'unreleased device files'
call lineout list, ''
call lineout list, ''

say 'Searching for unreleased samples and checking for include of unreleased libraries'
call charout list, 'Unreleased samples'
if runtype = '' then
  call charout list, ' (excluding unreleased basic blink samples)'
else
  call charout list, ' (including basic blink samples)'
call lineout list, ''
call lineout list, '-------------------------------------------------------'

call SysFileTree smpdir'/*.jal', 'fls', 'FSO'      /* all samples */
if fls.0 = 0 then do
   call lineout list, 'Found no samples in <'smpdir'>'
  return 1
end

unlisted = 0
unlistedblink = 0
unreleasedinclude.  = ''
unreleasedinclude.0 = 0

do i=1 to fls.0
   fls.i = tolower(translate(fls.i, '/', '\'))        /* forward slashes, lower case */
   filespec = substr(fls.i, length(base) + 2)         /* remove base prefix */
   call SysFileSearch filespec, torelease, x.
   if x.0 = 0  |,                                     /* not found in TORELEASE */
      left(word(x.1,1),1) = '#' then do               /* commented out in TORELEASE */
      unlisted = unlisted + 1
      if pos('_blink_hs.',    filespec) > 0      |,
         pos('_blink_intosc.',filespec) > 0      |,
         pos('_blink_hs_usb.',filespec) > 0      |,
         pos('_blink_intosc_usb.',filespec) > 0  then do
         unlistedblink = unlistedblink + 1
         if runtype \= '' then                        /* blink samples to be listed */
            call lineout list, filespec               /* list unreleased blink sample */
      end
      else                                            /* not a blink sample */
         call lineout list, filespec                  /* list unreleased sample */
   end
   else do                                            /* found sample in torelease */
      parse var filespec picname '_'
      picname = tolower(filespec('N', picname))
      call SysFileSearch 'include ', fls.i, 'inc.'    /* search included libraries */
      call stream fls.i, 'c', 'close'                 /* done */
      do j=1 to inc.0                                 /* all lines with 'include' */
         inc.j = translate(tolower(inc.j), ' ', '09'x)  /* all lower case, tabs -> blanks */
         if word(inc.j,1) = 'include' &,              /* 1st word is 'include' and .. */
            words(inc.j) > 1  then do                 /* .. at least 2 words */
            libx = tolower(word(inc.j,2))             /* 2nd word is library or device file */
            if left(libx,3) = '10f'  |,               /* when device file */
               left(libx,4) = '10lf' |,
               left(libx,3) = '12f'  |,
               left(libx,4) = '12hv' |,
               left(libx,4) = '12lf' |,
               left(libx,3) = '16f'  |,
               left(libx,4) = '16hv' |,
               left(libx,4) = '16lf' |,
               left(libx,3) = '18f'  |,
               left(libx,4) = '18lf' then do
               if libx \= picname then                /* not matching! */
                 say 'sample' left(filespec('n',fls.i),40) 'includes wrong device file:' libx
            end
            else do
       /*      say 'searching' '/'libx'.jal' 'in' torelease   */
               call SysFileSearch '/'libx'.jal', torelease, 'liby.'
       /*      say 'found' liby.0 'hits'     */
               if liby.0 = 0 then do                      /* not found */
                  say 'sample' left(filespec('N',fls.i),40) 'includes a non released library:' libx
                  u = unreleasedinclude.0 + 1
                  unreleasedinclude.u = left('sample/'filespec('N', fls.i),40) 'includes:' libx    /* store for report */
                  unreleasedinclude.0 = u
               end
            end
         end
      end
   end
end
call stream torelease, 'c', 'close'                /* done */
call lineout list, ''
if runtype \= '' then
  call lineout list, unlisted 'unreleased sample files'
else
  call lineout list, unlisted - unlistedblink 'unreleased sample files',
                     '+' unlistedblink 'unreleased basic blink samples'
call lineout list, ''

if unreleasedinclude.0 > 0 then do
  call lineout list, ''
  call lineout list, 'Samples in TORELEASE which include unreleased libraries'
  call lineout list, '-------------------------------------------------------'
  call lineout list, ''
  do i = 1 to unreleasedinclude.0
    call lineout list, unreleasedinclude.i
  end
  call lineout list, ''
end

call lineout list, ''
call lineout list, 'Unreleased Project files'
call lineout list, '------------------------'
call SysFileTree projdir'/*', 'fls', 'FSO'         /* project files */
unlisted = 0
do i=1 to fls.0
  if pos('.svn', fls.i) > 0 then                   /* svn file */
    iterate                                        /* ignore */
  fls.i = translate(fls.i, '/', '\')
  filespec = substr(fls.i, length(base) + 2)       /* remove base prefix */
  call SysFileSearch filespec, torelease, x.
  if x.0 = 0 then do                               /* not found */
    unlisted = unlisted + 1
    call lineout list, filespec                    /* list not released lib */
  end
end
call stream torelease, 'c', 'close'
call lineout list, ''
call lineout list, unlisted 'unreleased project files'
call lineout list, ''

if missing.0 > 0 then do
  call lineout list, ''
   call lineout list, ''
   call lineout list, 'Files listed in TORELEASE, but missing in Jallib'
   call lineout list, '------------------------------------------------'
   call lineout list, 'Line#  File'
   do i = 1 to missing.0
      call lineout list, missing.i
   end
   call lineout list, ''
end

call stream list, 'c', 'close'

Say 'Creating' torelease'.NEW (sorted, duplicates commented out)'
call SysFileDelete newrelease
call stream newrelease, 'c', 'open write'
call lineout newrelease, '# Title: List of files to release'
call lineout newrelease, '#'
call lineout newrelease, '# $Revision$'
call lineout newrelease, '#'
call listpart 'DEVICE', 'Device files'
call listpart 'EXTERNAL', 'Externals'
call listpart 'FILESYSTEM', 'FileSystems'
call listpart 'JAL', 'JAL extensions'
call listpart 'NETWORKING', 'Networking'
call listpart 'PERIPHERAL', 'Peripherals'
call listpart 'PROTOCOL', 'Protocols'
call listpart 'PROJECT', 'Projects'
call listpart 'SAMPLE', 'Samples'
call listpart 'DOC', 'Static documentation (only in jallib-pack)'
call stream newrelease, 'c', 'close'

say 'See' list 'for the detailed results'

return 0     /* all done */



/* --------------------------------------------- */
/* translate shortcuts: toupper / tolower        */
/* --------------------------------------------- */
toupper: return translate(arg(1),xrange('A','Z'),xrange('a','z'))
tolower: return translate(arg(1),xrange('a','z'),xrange('A','Z'))


/* ----------------------------------------------- */
/* Write members of subdirectory to new torelease  */
/* after being sorted on name                      */
/* ----------------------------------------------- */
listpart: procedure expose f. newrelease
parse arg part, title
call sortpart part                                          /* sort this part of collection */
call lineout newrelease, '#' title
do i = 1 to f.part.0                                        /* list this collection */
  p = i - 1
  if f.part.p = f.part.i then
     call lineout newrelease, '# 'f.part.i '   duplicate!'
  else
     call lineout newrelease, f.part.i
end
call lineout newrelease, ''
return


/* --------------------------------------------- */
/* Sorting members of 1st level subdirectory.    */
/* '_' in name for sort changed into '/'         */
/* such that 16f72_xxx comes before 16f722_xxx   */
/* Spaces in filenames will become underscores!  */
/* --------------------------------------------- */
sortpart: procedure expose f. newrelease
parse upper arg part .
g.0 = f.part.0
do i = 1 to g.0                                             /* copy to shadow compound var */
  g.i = translate(f.part.i,' ','_')                         /* underscore -> space */
end
call SysStemSort 'g.', 'A', 'I'                             /* sort the group */
do i = 1 to g.0                                             /* copy back */
  f.part.i = translate(g.i, '_', ' ')                       /* space -> underscore */
end
return


