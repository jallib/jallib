/* ------------------------------------------------------------------------ *
 * Title: blink-an-led.cmd - Create and compile blink-an-LED samples.       *
 *                                                                          *
 * Author: Rob Hamerling, Copyright (c) 2008..2009, all rights reserved.    *
 *                                                                          *
 * Adapted-by:                                                              *
 *                                                                          *
 * Compiler: 2.4k                                                           *
 *                                                                          *
 * This file is part of jallib  http://jallib.googlecode.com                *
 * Released under the BSD license                                           *
 *                http://www.opensource.org/licenses/bsd-license.php        *
 *                                                                          *
 * Description: Rexx script to create a blink-an-LED JAL program in the     *
 *              in the current default directory for every PIC.             *
 *              The created program is validated (JSG) and submitted to     *
 *              the compiler. The console log is checked for errors and     *
 *              warnings. When both are 0 the source is copied to the SVN   *
 *              directory and all compiler but the compiler console log     *
 *              is deleted.                                                 *
 *                                                                          *
 * Sources:                                                                 *
 *                                                                          *
 * Notes:                                                                   *
 *  - Uses Classic Rexx.                                                    *
 *  - There is no summary of changes maintained for this script.            *
 *                                                                          *
 * ------------------------------------------------------------------------ */

parse upper arg runtype selection .             /* where to store jal files */

call envir 'python'                             /* set Python environment */

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                               /* load Rexx utilities */

JalV2 = 'k:/jallib/compiler/JalV2ecs.exe'       /* latest compiler */
Validator = 'k:/jallib/tools/jallib.py validate'  /* validation command */

if runtype = 'TEST' then do                     /* test mode */
  Include = '/jal/dev2jal/test/'                /* device files under test */
  Options = '-s' Include                        /* compiler options */
  dst = './'                                    /* current directory */
end
else do                                         /* normal mode */
  Include = '/jallib/include/device/'           /* SVN include directory */
  Options = '-a nul -s' Include                 /* no asm output */
  dst = '/jallib/sample/'                       /* sample dir */
end

if selection = '' then
  call SysFileTree Include'1*.jal', pic, 'FO'   /* list of device files  */
else
  call SysFileTree Include||selection'.jal', pic, 'FO'  /* list of includes  */

if pic.0 < 1 then do
  say 'No appropriate device files found in directory' Include
  return 1
end

k = 0

do i=1 to pic.0

  parse value filespec('Name', pic.i) with PicName '.jal'
  say PicName

  '@python' validator Include||PicName'.jal' '1>'PicName'.pyout' '2>'PicName'.pyerr'
  if rc \= 0 then do
    say 'Validation of device file for' PicName 'failed, rc' rc
    leave                                       /* terminate! */
  end
  '@erase' PicName'.py*'                        /* when OK, discard logs */
  say '     Device file validated OK!'

  PgmName = PicName'_blink'                     /* program name */
  PgmFile = PgmName'.jal'                       /* program filespec */

  '@python' validator  pic.i '1>'PgmName'.pyout'  '2>'PgmName'.pyerr'
  if rc \= 0 then do
    say 'Validation of device file' PicName'.jal failed, rc' rc
    leave
  end
  '@erase' PgmName'.py*'                      /* when OK, discard python output */

  if stream(PgmFile, 'c', 'query exists') \= '' then
    '@erase' PgmFile
  call stream  PgmFile, 'c', 'open write'
  call lineout PgmFile, '-- ------------------------------------------------------'
  call lineout PgmFile, '-- Title: Blink-an-LED of the Microchip pic'PicName
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Author: Rob Hamerling, Copyright (c) 2008..2009, all rights reserved.'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Adapted-by:'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Compiler: 2.4k'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- This file is part of jallib',
                         ' (http://jallib.googlecode.com)'
  call lineout PgmFile, '-- Released under the BSD license',
                         '(http://www.opensource.org/licenses/bsd-license.php)'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- Description:'
  call lineout PgmFile, '-- Sample blink-an-LED program for Microchip PIC'PicName'.'
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
    call SysFileSearch ' HS', pic.i, osc.
    if  osc.0 > 0 then do                               /* HS mode supported */
      hs = 'HS'
      do j = 1 to osc.0
        if pos('PLL', word(osc.j,1)) = 0 then do        /* no PLL */
          hs = word(osc.j,1)                            /* select! */
          leave
        end
      end
      call lineout PgmFile, '-- This program assumes a 20 MHz resonator or crystal'
      call lineout PgmFile, '-- is connected to pins OSC1 and OSC2.'
      if left(PicName,2) = '18' then
        call lineout PgmFile, '-- Not specified configuration bits may cause a different frequency!'
      call lineout PgmFile, 'pragma target clock 20_000_000     -- oscillator frequency'
      call lineout PgmFile, '-- configuration memory settings (fuses)'
      call lineout PgmFile, 'pragma target OSC  'hs'              -- HS crystal or resonator'
    end
    else do                                             /* assume internal oscillator */
      call lineout PgmFile, '-- This program assumes the internal oscillator'
      call lineout PgmFile, '-- is running at a frequency of 4 MHz.'
      call lineout PgmFile, 'pragma target clock 4_000_000      -- oscillator frequency'
      call lineout PgmFile, '-- configuration memory settings (fuses)'
      call SysFileSearch ' INTOSC', pic.i, osc.
      if osc.0 > 0 then
        call lineout PgmFile, 'pragma target OSC  'word(osc.1,1)'     -- internal oscillator'
      else do
        call SysFileSearch ' INTRC', pic.i, osc.
        if osc.0 > 0 then
          call lineout PgmFile, 'pragma target OSC  'word(osc.1,1)'     -- internal oscillator'
      end
      call SysFileSearch ' IOSCFS ', pic.i, ioscfs.
      if ioscfs.0 > 0 then
        call lineout PgmFile, 'pragma target IOSCFS  F4MHZ        -- select 4 MHz'
    end
  end
  else do
    call lineout PgmFile, '-- This program assumes the internal oscillator'
    call lineout PgmFile, '-- is running at a frequency of 4 MHz.'
    call lineout PgmFile, 'pragma target clock 4_000_000      -- oscillator frequency'
    call lineout PgmFile, '-- configuration memory settings (fuses)'
    call SysFileSearch ' IOSCFS ', pic.i, ioscfs.
    if ioscfs.0 > 0 then
      call lineout PgmFile, 'pragma target IOSCFS  F4MHZ        -- select 4 MHz'
  end
  call SysFileSearch 'pragma fuse_def WDT', pic.i, wdt.
  if wdt.0 > 0 then do
    call lineout PgmFile, 'pragma target WDT  disabled        -- no watchdog'
  end
  call SysFileSearch 'pragma fuse_def LVP', pic.i, lvp.
  if lvp.0 > 0 then do
    call lineout PgmFile, 'pragma target LVP  disabled        -- no Low Voltage Programming'
  end
  call SysFileSearch 'pragma fuse_def MCLR', pic.i, mclr., 'N'
  if mclr.0 > 0 then do
    do  word(mclr.1,1)                                  /* skip lines ahead of MCLR */
      call linein pic.i
    end
    ln = linein(pic.i)                                  /* line after fuse_def MCLR */
    if pos('EXTERNAL',ln) > 0 then do                   /* MCLR external */
      call lineout PgmFile, 'pragma target MCLR external        -- reset externally'
    end
    else do
      ln = linein(pic.i)                                /* try next line */
      if pos('EXTERNAL',ln) > 0 then do                 /* MCLR external */
        call lineout PgmFile, 'pragma target MCLR external        -- reset externally'
      end
    end
  end
  call stream Pic.i, 'c', 'close'                       /* done for now */
  call lineout PgmFile, '--'
  call lineout PgmFile, 'enable_digital_io()                -- disable analog I/O (if any)'
  call lineout PgmFile, '--'
  call lineout PgmFile, '-- You may want to change the selected pin:'

  call stream pic.i, 'c', 'close'
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
          call lineout PgmFile, 'var bit led      is' pinPQ '        -- alias'
          call lineout PgmFile, pinPQ'_direction =  output'
          leave p
        end
        else do                                         /* no TRISx found */
          say 'Found' pinPQ', but missing' pinPQ'_direction declaration'
        end
      end
    end
  end

  if p > port.0 then do
    say 'Error: Could not find suitable I/O pin for LED on' PicName
    iterate
  end

  call stream pic.i, 'c', 'close'                       /* done with device file */

  call lineout PgmFile, '--'
  call lineout PgmFile, 'forever loop'
  call lineout PgmFile, '   led = on'
  call lineout PgmFile, '   _usec_delay(250000)'
  call lineout PgmFile, '   led = off'
  call lineout PgmFile, '   _usec_delay(250000)'
  call lineout PgmFile, 'end loop'
  call lineout PgmFile, '--'
  call stream PgmFile, 'c', 'close'


  '@python' validator PgmFile '1>'PgmName'.pyout' '2>'PgmName'.pyerr'
  if rc \= 0 then do
    say 'Validation of blink sample program' PgmFile 'failed, rc' rc
    leave                                       /* terminate! */
  end
  '@erase' PgmName'.py*'                        /* when OK, discard log */
  say '     Blink-an-LED sample validated OK!'

  '@'JalV2 Options PgmFile '>'PgmName'.log'     /* compile */

  if rc \= 0 then do                            /* compile error */
    say 'JalV2 compile error' rc
    leave                                       /* terminate */
  end
  say '     Blink-an-LED sample compiled OK!'

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
        if runtype = 'PROD' then do             /* PROD only */
          '@xcopy' PgmFile translate(dst,'\','/')'*' '/S 1>nul'
          if rc \= 0 then do
            say 'Copy of' PgmFile 'to' dst 'failed'
            return rc
          end
          '@erase' PgmName'.hex' PgmName'.asm' PgmName'.jal' PgmName'.log' '1>nul 2>nul'
        end
      end
    end
    else
      say 'Compilation of' PgmFile 'failed:' LG.1
  end
  else do
    say 'Compilation of' PgmFile 'failed, file' PgmName'.log' 'not found'
  end

end

say 'Processed successfully' k 'of' pic.0 ' device files and blink-an-led programs!'

return 0


