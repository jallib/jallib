/* ------------------------------------------------------------------------ */
/* Title: blink-an-led.cmd - Create and compile blink-an-LED samples.       */
/*                                                                          */
/* Author: Rob Hamerling, Copyright (c) 2008..2008, all rights reserved.    */
/*                                                                          */
/* Adapted-by:                                                              */
/*                                                                          */
/* Compiler: =2.4                                                           */
/*                                                                          */
/* This file is part of jallib  http://jallib.googlecode.com                */
/* Released under the BSD license                                           */
/*                http://www.opensource.org/licenses/bsd-license.php        */
/*                                                                          */
/* Description: Rexx script to create a blink-an-LED JAL program in the     */
/*              in the current default directory for every PIC.             */
/*              The created program is submitted to the compiler and the    */
/*              console log is checked for errors and warnings.             */
/*              When both are 0 the source is copied to the SVN directory   */
/*              and all compiler but the compiler console log is deleted.   */
/*                                                                          */
/* Sources:                                                                 */
/*                                                                          */
/* Notes:                                                                   */
/*  - Written in Classic Rexx style, but requires Object Rexx to run.       */
/*  - There is no summary of changes maintained for this script.            */
/*                                                                          */
/* ------------------------------------------------------------------------ */

parse upper arg runtype selection .             /* where to store jal files */

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                               /* load Rexx utilities */

JalV2 = 'k:/c/Jalv2/JalV2.exe'                      /* compiler path (eCS) */

if runtype = 'TEST' then do                     /* test mode */
  Include = 'k:/jallib/test/'                         /* test include directory */
  Options = '-Wno-all -s' Include                           /* compiler options */
end
else do                                         /* normal mode */
  Include = 'k:/jallib/unvalidated/include/device/'   /* SVN include directory */
  Options = '-Wno-all -a nul -s' Include                    /* no asm output */
end

if selection = '' then
  call SysFileTree Include'1*.jal', pic, 'FO'          /* list of device includes  */
else
  call SysFileTree Include||selection, pic, 'FO'       /* list of device includes  */

if pic.0 < 1 then do
  say 'No appropriate device files found in directory' Include
  return 1
end

dst = '\jallib\unvalidated\sample\blink\'       /* destination directory */
k = 0

do i=1 to pic.0

  parse value filespec('Name', pic.i) with PicName '.jal'
  say PicName

  '@python jsg_validator.py' pic.i '>'PgmName'.pylog'
  if rc \= 0 then do
    say 'returncode of validation include file' PicName'.jal is:' rc
    exit rc
  end
  '@erase' PgmName'.pylog'                      /* when OK, discard log */

  PgmName = 'b'PicName                          /* program name */
  PgmFile = 'b'PicName'.jal'                    /* program filespec */
  call stream  PgmFile, 'c', 'open write replace'
  call lineout PgmFile, '-- ------------------------------------------------------'
  call lineout PgmFile, '-- Title: Blink-an-LED of the Microchip PIC'PicName
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Author: Rob Hamerling, Copyright (c) 2008..2008, all rights reserved.'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Adapted-by:'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Compiler: =2.4'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- This file is part of jallib',
                         ' (http://jallib.googlecode.com)'
  call lineout PgmFile, '-- Released under the BSD license',
                         '(http://www.opensource.org/licenses/bsd-license.php)'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Description: Sample blink-an-LED program for Microchip PIC'PicName
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Sources:'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Notes:'
  call lineout PgmFile, '--  - File creation date/time:' date('N') time('N')'.'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- ------------------------------------------------------'
  call lineout PgmFile, '--'
  call lineout PgmFile, 'include' PicName '                   -- target PICmicro'
  call lineout PgmFile, '--'
  call SysFileSearch 'pragma fuse_def OSC', pic.i, osc.
  if osc.0 > 0 then do                                  /* oscillator pragma present */
    call SysFileSearch 'HS =', pic.i, osc.
    if  osc.0 > 0 then do                               /* HS mode supported */
      call lineout PgmFile, '-- This program assumes a 20 MHz resonator or crystal'
      call lineout PgmFile, '-- is connected to pins OSC1 and OSC2.'
      call lineout PgmFile, 'pragma target OSC HS               -- HS crystal or resonator'
      call lineout PgmFile, 'pragma target clock 20_000_000     -- oscillator frequency'
    end
    else do                                             /* assume internal oscillator */
      call lineout PgmFile, '-- This program assumes the internal oscillator'
      call lineout PgmFile, '-- is used with a frequency of 4 MHz.'
      call lineout PgmFile, 'pragma target OSC INTOSC_NOCLKOUT  -- internal oscillator'
      call lineout PgmFile, 'pragma target clock 4_000_000      -- oscillator frequency'
      call SysFileSearch ' IOSCFS ', pic.i, ioscfs.
      if ioscfs.0 > 0 then
        call lineout PgmFile, 'pragma target IOSCFS  F4MHZ        -- select 4 MHz'
    end
  end
  else do
    call lineout PgmFile, '-- This program assumes the internal oscillator'
    call lineout PgmFile, '-- is used with a frequency of 4 MHz.'
    call lineout PgmFile, 'pragma target clock 4_000_000      -- oscillator frequency'
    call SysFileSearch ' IOSCFS ', pic.i, ioscfs.
    if ioscfs.0 > 0 then
      call lineout PgmFile, 'pragma target IOSCFS  F4MHZ        -- select 4 MHz'
  end
  call SysFileSearch 'pragma fuse_def WDT', pic.i, wdt.
  if wdt.0 > 0 then do
    call lineout PgmFile, 'pragma target WDT  disabled'
  end
  call SysFileSearch 'pragma fuse_def LVP', pic.i, lvp.
  if lvp.0 > 0 then do
    call lineout PgmFile, 'pragma target LVP  disabled'
  end
  call SysFileSearch 'pragma fuse_def MCLR', pic.i, mclr., 'N'
  if mclr.0 > 0 then do
    ln = linein(pic.i, word(mclr.1,1) + 1)              /* line after fuse_def */
    if pos('EXTERNAL',ln) > 0 then do                   /* MCLR external */
      call lineout PgmFile, 'pragma target MCLR external'
    end
    else do
      ln = linein(pic.i)                                /* try next line */
      if pos('EXTERNAL',ln) > 0 then do                 /* MCLR external */
        call lineout PgmFile, 'pragma target MCLR external'
      end
    end
  end
  call stream Pic.i, 'c', 'close'                       /* done with device file */
  call lineout PgmFile, '--'
  call lineout PgmFile, 'enable_digital_io()                -- disable analog I/O (if any)'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- You may want to change the selected pin:'

  port.0 = 3                                                 /* ports to scan */
  port.1 = 'A'
  port.2 = 'B'
  port.3 = 'C'
  do p=1 to port.0
    do q=0 to 7
      call SysFileSearch ' pin_'port.p||q' ', pic.i, pin.    /* search I/O pin */
      if pin.0 > 0 then do                                   /* pin found */
        call SysFileSearch ' pin_'port.p||q'_direction', pic.i, tris.       /* TRISx */
        if tris.0 > 0 then do                                /* found */
          call lineout PgmFile, 'var bit led           is pin_'port.p||q'   -- alias'
          call lineout PgmFile, 'var bit led_direction is pin_'port.p||q'_direction'
          call lineout PgmFile, '--'
          call lineout PgmFile, 'led_direction = output'
          leave p
        end
        else do                                              /* no TRISx found */
          say 'Found pin_'port.p||q', but missing pin_'port.p||q'_direction declaration'
        end
      end
    end
  end

  if p > port.0 then do
    say 'Error: Could not find suitable I/O pin for LED on' PicName
    iterate
  end

  call lineout PgmFile, '--'
  call lineout PgmFile, 'forever loop'
  call lineout PgmFile, '  led = on'
  call lineout PgmFile, '  _usec_delay(250000)'
  call lineout PgmFile, '  led = off'
  call lineout PgmFile, '  _usec_delay(250000)'
  call lineout PgmFile, 'end loop'
  call lineout PgmFile, '--'
  call stream PgmFile, 'c', 'close'


  '@python jsg_validator.py' PgmFile '>'PgmName'.pylog'     /* validate blink program */
  if rc \= 0 then do
    say 'returncode of validation blink program' PgmFile 'is:' rc
    exit rc                                     /* terminate! */
  end
  '@erase' PgmName'.pylog'                      /* when OK, discard log */

  '@'JalV2 Options PgmFile '>'PgmName'.log'      /* compile */

  if rc \= 0 then                               /* compiler error */
    leave                                       /* terminate */

  '@erase' PgmName'.cod' PgmName'.err' PgmName'.lst' PgmName'.obj' '1>nul 2>nul'

  call SysFileSearch 'WARNING', PgmName'.log', LG.    /* find warning line in log */
  if LG.0 > 0 then do
    parse upper var LG.1 errs 'ERRORS,' wngs 'WARNINGS'
    if errs = 0 & wngs = 0 then do
      if stream(PgmName'.hex', 'c', 'query exists') = '' then do
        Say 'Zero warnings and errors, but no hex file. Compiler failure!'
      end
      else do
        k = k + 1                               /* all OK */
        '@copy'  PgmName'.jal' dst'*' '1>nul'
        if runtype \= 'TEST' then
          '@erase' PgmName'.hex' PgmName'.asm' PgmName'.jal' PgmName'.log' '1>nul 2>nul'
      end
    end
    else
      say 'Compilation of' PgmName'.jal failed:' LG.1
  end
  else do
    say 'Compilation of' PgmName'.jal failed, file' PgmName'.log' 'not found'
  end


  if k > 500 then exit loop     /* set (low) limit for test purposes */

end

say 'Compiled' k 'of' pic.0 'blink-an-led programs without warnings or errors!'

return 0


