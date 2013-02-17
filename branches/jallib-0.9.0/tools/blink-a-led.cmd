/* ------------------------------------------------------------------------ *
 * Title: blink-a-led.cmd - Create and compile blink-a-led samples.         *
 *                                                                          *
 * Author: Rob Hamerling, Copyright (c) 2008..2011, all rights reserved.    *
 *                                                                          *
 * Adapted-by:                                                              *
 *                                                                          *
 * Revision: $Revision$                                                     *
 *                                                                          *
 * Compiler: N/A                                                            *
 *                                                                          *
 * This file is part of jallib  http://jallib.googlecode.com                *
 * Released under the BSD license                                           *
 *                http://www.opensource.org/licenses/bsd-license.php        *
 *                                                                          *
 * Description: Rexx script to create a blink-a-led sample for every        *
 *              generated device file.                                      *
 *              First the device file is validated, then a program is       *
 *              created, validated and submitted to the compiler.           *
 *              The console log is checked for errors and warnings.         *
 *              When all OK and when the run is in 'PROD' mode the source   *
 *              of the sample program is copied to the local SVN directory  *
 *              and all compiler output is deleted.                         *
 *              In TEST mode the log and jal files are retained.            *
 *                                                                          *
 * Sources:                                                                 *
 *                                                                          *
 * Version: 0.0.4                                                           *
 *                                                                          *
 * Notes:                                                                   *
 *  - Uses Classic Rexx.                                                    *
 *  - There is no summary of changes maintained for this script.            *
 *                                                                          *
 * ------------------------------------------------------------------------ */

   ScriptAuthor    = 'Rob Hamerling'
   CompilerVersion = '2.4o'

parse upper arg runtype selection .             /* where to store jal files */

if runtype \= 'PROD' & runtype \= 'TEST' then do
  say 'Error: Required argument missing: "prod" or "test"'
  return 1
end

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                               /* load Rexx utilities */


Validator = '/jallib/tools/jallib.py validate'  /* validation command */

if runtype = 'PROD' then do                     /* test mode */
  compiler = 'k:\jallib\compiler\JalV2ecs.exe'  /* prod compiler */
  include = 'k:/jallib/include/device;/jallib/include/jal'   /* JalV2 include specification */
  dst = 'k:/jallib/sample'                      /* blink-samples destination */
  src = 'k:/jallib/include/device'              /* source for samples */
  Options = '-no-codfile -no-asm -s' Include    /* compiler options */
end
else do                                         /* test mode */
  compiler = 'k:\c\jalv2\bin\JalV2ecs.exe'      /* latest compiler */
  Include = 'k:/jal/dev2jal/test;/jallib/include/device;/jallib/include/jal'   /* test + prod device files */
  dst = './test'                                /* to test subdirectory */
  src = 'k:/jal/dev2jal/test'                   /* test device files */
  if stream(src'/chipdef_jallib.jal', 'c', 'query exists') = '' then   /* no test device files */
    src = 'k:/jallib/include/device'            /* production device files */
  Options = '-no-codfile -s' Include            /* compiler options */
end

if selection = '' then
  call SysFileTree src'/1*.jal', 'pic.', 'FO'      /* all device files  */
else
  call SysFileTree src'/'selection'.jal', 'pic.', 'FO'  /* selected device files  */
if pic.0 < 1 then do
  say 'No appropriate device files found in directory' src
  return 1
end

call envir 'python'                             /* set Python environment */

k = 0

do i=1 to pic.0

  parse value filespec('Name', pic.i) with PicName '.jal'
  say PicName

  '@python' validator src'/'PicName'.jal' '1>'PicName'.pyout' '2>'PicName'.pyerr'
  if rc \= 0 then do
    say 'Validation of device file for' PicName 'failed, rc' rc
    '@type' PicName'.pyerr'
    leave                                       /* terminate! */
  end
  '@erase' PicName'.py*'                        /* when OK, discard logs */
  say '     Device file validated OK!'

  PgmName = PicName'_blink'                     /* program name */
  PgmFile = PgmName'.jal'                       /* program filespec */

  call SysFileDelete PgmFile
  call stream  PgmFile, 'c', 'open write'
  call lineout PgmFile, '-- ------------------------------------------------------'
  call lineout PgmFile, '-- Title: Blink-a-led of the Microchip pic'PicName
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Author:' ScriptAuthor', Copyright (c) 2008..2011, all rights reserved.'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Adapted-by:'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Revision: $Revision$'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Compiler:' CompilerVersion
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- This file is part of jallib',
                         ' (http://jallib.googlecode.com)'
  call lineout PgmFile, '-- Released under the BSD license',
                         '(http://www.opensource.org/licenses/bsd-license.php)'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Description:'
  call lineout PgmFile, '-- Sample blink-a-led program for Microchip PIC'PicName'.'
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
  if osc.0 > 0 then do                                   /* oscillator pragma present */
    call SysFileSearch ' HS', pic.i, osc.
    if  osc.0 > 0 then do                                /* HS mode supported */
      do j = 1 to osc.0
        if word(osc.j,1) = 'HS'  |,                      /* found default */
           word(osc.j,1) = 'HS_HIGH' then do             /* found alternate */
          hs = word(osc.j,1)                             /* select */
          leave j
        end
      end
      call lineout PgmFile, '-- This program assumes that a 20 MHz resonator or crystal'
      call lineout PgmFile, '-- is connected to pins OSC1 and OSC2.'
      call lineout PgmFile, '-- (unspecified configuration bits may cause a different frequency!)'
      call lineout PgmFile, 'pragma target clock 20_000_000     -- oscillator frequency'
      call lineout PgmFile, '-- configuration memory settings (fuses)'
      call lineout PgmFile, 'pragma target OSC      'left(hs,7)'          -- HS crystal or resonator'
      osc_type = 'HS'
    end
    else do                                             /* assume internal oscillator */
      call lineout PgmFile, '-- This program assumes the internal oscillator'
      call lineout PgmFile, '-- is running at a frequency of 4 MHz.'
      call lineout PgmFile, 'pragma target clock 4_000_000      -- oscillator frequency'
      call lineout PgmFile, '-- configuration memory settings (fuses)'
      call SysFileSearch ' INTOSC', pic.i, osc.
      if osc.0 > 0 then do                              /* found internal oscillator */
        do j = 1 to osc.0
          if pos('NOCLK', osc.j) > 0 then do            /* search for noclkout */
             call lineout PgmFile, 'pragma target OSC      'word(osc.j,1)'     -- internal oscillator'
             leave                                      /* done! */
          end
        end
        if j > osc.0 then                               /* not 'noclkout': take first */
          call lineout PgmFile, 'pragma target OSC       'word(osc.1,1)'    -- internal oscillator'
      end
      call SysFileSearch ' IOSCFS ', pic.i, ioscfs.
      if ioscfs.0 > 0 then
        call lineout PgmFile, 'pragma target IOSCFS  F4MHZ        -- select 4 MHz'
      osc_type = 'INTOSC'
    end
  end
  else do
    call lineout PgmFile, '-- This program assumes the internal oscillator'
    call lineout PgmFile, '-- is running at a frequency of 4 MHz.'
    call lineout PgmFile, 'pragma target clock 4_000_000     -- oscillator frequency'
    call lineout PgmFile, '-- configuration memory settings (fuses)'
    call SysFileSearch ' IOSCFS ', pic.i, ioscfs.
    if ioscfs.0 > 0 then
      call lineout PgmFile, 'pragma target IOSCFS   F4MHZ      -- select 4 MHz'
    osc_type = 'INTOSC'
  end
  call SysFileSearch 'fuse_def PLLEN', pic.i, pll., 'N'
  if pll.0 > 0 then do                                         /* PLLEN present */
    if osc_type = 'INTOSC' then do                             /* INTOSC selected */
      call SysFileSearch '16MHZ =', pic.i, 'freq.', 'N'
      if freq.0 > 0 then                                      /* 16f720,1 (etc) */
        call lineout PgmFile, 'pragma target PLLEN    F16MHZ       -- PLL on'
    end
    else if pos('intosc', pll.1) = 0 then                   /* PLL, not for intosc */
      call lineout PgmFile, 'pragma target PLLEN    P1         -- PLL off'
  end
  call stream pic.i, 'c', 'close'                       /* closed for SysFileSearch */
  call SysFileSearch 'fuse_def PLLDIV', pic.i, pll.
  if pll.0 > 0 then
    call lineout PgmFile, 'pragma target PLLDIV   P1           -- no divide'
  call SysFileSearch 'fuse_def CPUDIV', pic.i, pll.
  if pll.0 > 0 then
    call lineout PgmFile, 'pragma target CPUDIV   P1           -- no Fosc divisor'
  call SysFileSearch 'fuse_def WDT', pic.i, wdt.
  if wdt.0 > 0 then
    call lineout PgmFile, 'pragma target WDT      disabled     -- no watchdog'
  call SysFileSearch 'fuse_def XINST', pic.i, xinst.
  if xinst.0 > 0 then
    call lineout PgmFile, 'pragma target XINST    disabled     -- not supported by JalV2'
  call SysFileSearch 'fuse_def DEBUG', pic.i, debug.
  if debug.0 > 0 then
    call lineout PgmFile, 'pragma target DEBUG    disabled     -- no debugging'
  call SysFileSearch 'fuse_def IESO', pic.i, ieso.
  if ieso.0 > 0 then
    call lineout PgmFile, 'pragma target IESO     disabled     -- no in/ext oscillator switchover'
  call SysFileSearch 'fuse_def LVP', pic.i, lvp.
  if lvp.0 > 0 then
    call lineout PgmFile, 'pragma target LVP      disabled     -- no Low Voltage Programming'
  call SysFileSearch 'fuse_def MCLR', pic.i, mclr., 'N'
  if mclr.0 > 0 then do
    do  word(mclr.1,1)                                  /* skip lines ahead of MCLR */
      call linein pic.i
    end
    ln = linein(pic.i)                                  /* line after fuse_def MCLR */
    if pos('EXTERNAL',ln) > 0 then do                   /* MCLR external */
      call lineout PgmFile, 'pragma target MCLR     external     -- reset externally'
    end
    else do
      ln = linein(pic.i)                                /* try next line */
      if pos('EXTERNAL',ln) > 0 then do                 /* MCLR external */
        call lineout PgmFile, 'pragma target MCLR     external     -- reset externally'
      end
    end
  end
  call stream pic.i, 'c', 'close'                       /* closed for SysFileSearch */
  call lineout PgmFile, '-- These configuration bit settings are only a selection, sufficient for'
  call lineout PgmFile, '-- this program, but other programs may need more or different settings.'
  call lineout PgmFile, '--'
  if osc_type = 'INTOSC' then do                        /* internal oscillator selected */
    call SysFileSearch 'OSCCON_IRCF', pic.i, 'ircf.', 'N'
    if ircf.0 > 0 then do
      if pos('bit*2', ircf.1) > 0 then
        if PicName = '12f752' | PicName = '12hv752' then
          call lineout PgmFile, 'OSCCON_IRCF = 0b10                -- 4 MHz'
        else
          call lineout PgmFile, 'OSCCON_IRCF = 0b01                -- 4 MHz'
      else if pos('bit*3', ircf.1) > 0 then
        call lineout PgmFile, 'OSCCON_IRCF = 0b101               -- 4 MHz'
      else if pos('bit*4', ircf.1) > 0 then
        call lineout PgmFile, 'OSCCON_IRCF = 0b1101              -- 4 MHz'
      call lineout PgmFile, '--'
    end
  end
  call lineout PgmFile, 'enable_digital_io()                -- make all pins digital I/O'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Specify the pin to which the LED is connected.'
  call lineout PgmFile, '-- A low current (2 mA) led with 2.2K series resistor is recommended'
  call lineout PgmFile, '-- since the chosen pin may not be able to drive an ordinary 20mA led.'
  call lineout PgmFile, '--'
  port.0 = 3                                            /* ports to scan */
  port.1 = 'A'
  port.2 = 'B'
  port.3 = 'C'
  do p=1 to port.0
    do q=0 to 7
      pinPQ = 'pin_'port.p||q                           /* pin name */
      call SysFileSearch ' 'pinPQ' ', pic.i, pin.       /* search pin in device file */
      if pin.0 > 0 then do                              /* pin found */
        call SysFileSearch ' 'pinPQ'_direction', pic.i, tris.    /* search TRISx */
        if tris.0 > 0 then do                           /* found */
          call lineout PgmFile, 'alias   led      is' pinPQ
          call lineout PgmFile, pinPQ'_direction =  output'
          leave p
        end
        else do                                         /* no TRISx found */
          say 'Found' pinPQ', but missing' pinPQ'_direction declaration'
        end
      end
    end
  end
  call stream pic.i, 'c', 'close'                       /* done with device file */
  if p > port.0 then do
    say 'Error: Could not find suitable I/O pin for LED on' PicName
    iterate
  end

  call lineout PgmFile, '--'
  call lineout PgmFile, 'forever loop'
  call lineout PgmFile, '   led = on'
  call lineout PgmFile, '   _usec_delay(250_000)'
  call lineout PgmFile, '   led = off'
  call lineout PgmFile, '   _usec_delay(250_000)'
  call lineout PgmFile, 'end loop'
  call lineout PgmFile, '--'
  call stream PgmFile, 'c', 'close'

  '@python' validator PgmFile '1>'PgmName'.pyout' '2>'PgmName'.pyerr'
  if rc \= 0 then do
    say 'Validation of blink sample program' PgmFile 'failed, rc' rc
    '@type' PgmName'.pyerr'
    leave                                       /* terminate! */
  end
  '@erase' PgmName'.py*'                        /* when OK, discard log */
  say '     Sample program validated OK!'

  '@'compiler Options '-log' PgmName'.log' PgmFile '>nul'  /* compile */

  if rc \= 0 then do                            /* compile error */
    say 'JalV2 compile error' rc
    if runtype = 'PROD' then
      leave                                     /* terminate */
  end
  else
    say '     Sample program compiled OK!'

  call SysFileSearch 'WARNING', PgmName'.log', 'LG.'    /* find warning line in log */
  if LG.0 > 0 then do
    parse upper var LG.1 errs 'ERRORS,' wngs 'WARNINGS'
    if errs = 0 & wngs = 0 then do
      if stream(PgmName'.hex', 'c', 'query exists') = '' then do
        Say 'Zero warnings and errors, but no hex file. Compiler failure!'
        leave                                   /* terminate */
      end
      else do
        k = k + 1                               /* all OK */
        '@xcopy' PgmFile translate(dst,'\','/')  '1>nul'
        if rc \= 0 then do
          say 'Copy of' PgmFile 'to' dst 'failed'
          leave
        end
        if runtype = 'TEST' then do
          '@xcopy' PgmName'.hex' translate(dst,'\','/') '1>nul'
          '@xcopy' PgmName'.log' translate(dst,'\','/') '1>nul'
          '@xcopy' PgmName'.asm' translate(dst,'\','/') '1>nul'
        end
        call SysFileDelete PgmName'.jal'
        call SysFileDelete PgmName'.log'
        call SysFileDelete PgmName'.hex'
        call SysFileDelete PgmName'.asm'
      end
    end
    else do
      say 'Compilation of' PgmFile 'failed:' LG.1
      leave
    end
  end
  else do
    say 'Compilation of' PgmFile 'failed, file' PgmName'.log' 'not found'
    leave                                       /* terminate */
  end

end

say 'Processed successfully' k 'of' pic.0 ' device files and blink-a-led programs!'

return 0


