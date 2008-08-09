/* ------------------------------------------------------------------------ */
/* Title: blink-an-led.cmd - Create and test blink-an-LED samples.          */
/*                                                                          */
/* Author: Rob Hamerling, Copyright (c) 2008..2008, all rights reserved.    */
/*                                                                          */
/* Adapted-by:                                                              */
/*                                                                          */
/* Compiler: >=2.4g                                                         */
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

Parse upper arg p1 .

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                               /* load Rexx utilities      */

if p1 = 'DEBUG' then                            /* script debug mode        */
  I = 'k:/jal/dev2jal/'                         /* include directory        */
else                                            /* normal mode              */
  I = 'k:/jallib/unvalidated/includes/device/'  /* SVN include directory    */
J = 'k:/c/Jalv2/JalV2.exe'                      /* compiler path (eCS)      */
O = '-Wno-all -no-fuse -s' I                    /* compiler options         */

call SysFileTree I'1*.jal', pic, 'FO'           /* list of device includes  */
if dir.0 < 1 then do
  say 'No appropriate device files found in directory' devdir
  return 1
end

dst = '\jallib\unvalidated\samples\blink\'      /* destination directory    */
k = 0

do i=1 to pic.0

  parse value filespec('Name', pic.i) with M '.jal'
  say M

  B = 'b'M'.jal'                                /* source file to create */
  call stream  B, 'c', 'open write replace'
  call lineout B, '-- ------------------------------------------------------'
  call lineout B, '-- Title: Blink-an-LED of the Microchip PIC'M
  call lineout B, '--'
  call lineout B, '-- Author: Rob Hamerling, Copyright (c) 2008..2008, all rights reserved.'
  call lineout B, '--'
  call lineout B, '-- Adapted-by:'
  call lineout B, '--'
  call lineout B, '-- Compiler: >=2.4g'
  call lineout B, '--'
  call lineout B, '-- This file is part of jallib',
                         ' (http://jallib.googlecode.com)'
  call lineout B, '-- Released under the BSD license',
                         '(http://www.opensource.org/licenses/bsd-license.php)'
  call lineout B, '--'
  call lineout B, '-- Description: Sample blink-an-LED program for Microchip PIC'M
  call lineout B, '--'
  call lineout B, '-- Sources:'
  call lineout B, '--'
  call lineout B, '-- Notes:'
  call lineout B, '--  - File creation date/time:' date('N') time('N')'.'
  call lineout B, '--'
  call lineout B, '-- ------------------------------------------------------'
  call lineout B, '--'
  call lineout B, 'include' M '                 -- target PICmicro'
  call lineout B, '--'
  call lineout B, '-- Specify "pragma target xxx" to obtain a working program, e.g.'
  call lineout B, '--   pragma target OSC  HS        -- with a crystal or resonator'
  call lineout B, '--   pragma target WDT  disabled  -- '
  call lineout B, '--   pragma target LVP  disabled  -- if applicable'
  call lineout B, '--'
  call lineout B, '-- You may want to change the clock speed:'
  call lineout B, 'pragma target clock 20_000_000    -- oscillator frequency'
  call lineout B, '--'
  call lineout B, 'enable_digital_io()               -- disable analog I/O (if any)'
  call lineout B, '--'
  call lineout B, '-- You may want to change the selected pin:'

  port.0 = 3                                                 /* ports to scan */
  port.1 = 'A'
  port.2 = 'B'
  port.3 = 'C'
  do p=1 to port.0
    do q=0 to 7
      call SysFileSearch ' pin_'port.p||q' ', pic.i, pin., 'C'  /* search I/O pin */
      if pin.0 > 0 then do                                   /* pin found */
        call SysFileSearch ' TRIS'port.p, pic.i, tris., 'C'  /* search any TRISx */
        if tris.0 > 0 then do                                /* found */
          call SysFileSearch ' pin_'port.p||q'_direction', pic.i, tris., 'C'
          if tris.0 > 0 then do                              /* found pin direction */
            call lineout B, 'var bit LED           is pin_'port.p||q'   -- alias'
            call lineout B, 'var bit LED_direction is pin_'port.p||q'_direction'
            call lineout B, '--'
            call lineout B, 'LED_direction = output'
            leave p
          end
          else do
            nop   /* say 'not found:' ' pin_'port.p||q'_direction' */
          end
        end
        else do                                              /* no tris found */
          call lineout B, 'var bit LED           is pin_'port.p||q'   -- alias'
          leave p
        end
      end
    end
  end
  if p > port.0 then do
    say 'Error: Could not find suitable I/O pin for LED on' M
    iterate
  end

  call lineout B, '--'
  call lineout B, 'forever loop'
  call lineout B, '  LED = on'
  call lineout B, '  _usec_delay(250000)'
  call lineout B, '  LED = off'
  call lineout B, '  _usec_delay(250000)'
  call lineout B, 'end loop'
  call lineout B, '--'
  call stream B, 'c', 'close'

  if p1 = 'DEBUG' then
    '@'J O B '>b'M'.log'
  else
    '@'J O B '-a nul' '>b'M'.log'               /* no asm output */

  if rc \= 0 then                               /* compiler error */
    leave                                       /* terminate */

  B = 'b'M                                      /* add 'B' prefix to name */
  '@erase' B'.cod' B'.err' B'.lst' B'.obj' '1>nul 2>nul'

  call SysFileSearch 'WARNING', B'.log', LG.    /* find warning line in log */
  if LG.0 > 0 then do
    parse upper var LG.1 errs 'ERRORS,' wngs 'WARNINGS'
    if errs = 0 & wngs = 0 then do
      k = k + 1
      '@copy'  B'.jal' dst'*' '1>nul'
      '@erase' B'.hex' B'.asm' B'.jal' '1>nul 2>nul'
    end
    else
      say 'Compilation of' B'.jal failed:' LG.1
  end
  else do
    say 'Compilation of' B'.jal failed, file' B'.log' 'not found'
  end

/*  if k > 300 then exit loop */

end

say 'Compiled' k 'of' pic.0 'blink-an-led programs without warnings or errors!'

return 0


