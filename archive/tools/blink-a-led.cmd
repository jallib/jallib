/* ------------------------------------------------------------------------ *
 * Title: blink-a-led.cmd - Create and compile blink-a-led samples.         *
 *                                                                          *
 * Author: Rob Hamerling, Copyright (c) 2008..2014, all rights reserved.    *
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
 * Description: Rexx script to create one or more blink-a-led sample        *
 *              for every available device file.                            *
 *              - Validate the device file itself                           *
 *              - create a sample program                                   *
 *              - validated the sample program                              *
 *              - compile the sample program                                *
 *              - check the compiler output for errors and warnings         *
 *              When all OK:                                                *
 *              - in PROD mode copy the sample to /jallib/sample/           *
 *                and delete compiler output                                *
 *              - in TEST mode move sample and compiler output to ./test    *
 *                                                                          *
 * Sources:                                                                 *
 *                                                                          *
 * Version: 0.0.6                                                           *
 *                                                                          *
 * Notes:                                                                   *
 *  - Uses Classic Rexx.                                                    *
 *  - For all device files a blink sample is generated:                     *
 *    a HS sample if possible, otherwise an INTOSC sample.                  *
 *  - For all PICs with USB support a sample is generated using HS_PLL      *
 *  - There is no summary of changes maintained for this script.            *
 *                                                                          *
 * ------------------------------------------------------------------------ */
   ScriptAuthor    = 'Rob Hamerling'
   CompilerVersion = '2.4q2'

parse upper arg runtype selection .                 /* arguments */
if runtype \= 'PROD' & runtype \= 'TEST' then do
   say '   Required runtype argument missing: "prod" or "test"'
   return 1
end

devdir = 'k:/jallib/include/device'                    /* default device files */
if runtype = 'TEST' then do                            /* test mode */
   devdir = 'k:/jal/pic2jal/test'                      /* test device files */
   if stream(devdir'/chipdef_jallib.jal', 'c', 'query exists') = '' then do   /* no test device files */
      devdir = 'k:/jallib/include/device'              /* production device files */
      say '   Using production device files'
   end
end

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                                      /* load Rexx utilities */

if selection = '' then
   call SysFileTree devdir'/1*.jal', 'pic.', 'FO'      /* all device files  */
else
   call SysFileTree devdir'/'selection'.jal', 'pic.', 'FO'  /* selected device files  */
if pic.0 = 0 then do
   say '   No appropriate device files found in directory' devdir
   return 1
end

/* Tables with the names of PICs for which an extra INTOSC blink sample     */
/* should be generated beyond the standard default 'HS' or HS_USB' variant. */
/* Note: an extra sample will only be generated when HS resp. HS_USB sample is OK. */
extra_intosc     = '12f1840'  ,
                   '12f635'   ,
                   '12f675'   ,
                   '12f683'   ,
                   '16f1459'  ,
                   '16f1516'  ,
                   '16f1784'  ,
                   '16f1827'  ,
                   '16f1934'  ,
                   '16f648a'  ,
                   '16f722'   ,
                   '16f877a'  ,
                   '16f88'    ,
                   '18f1220'  ,
                   '18f13k50' ,
                   '18f23k22' ,
                   '18f26j53' ,
                   '18f4550'  ,
                   '18f4620'  ,
                   '18f6310'  ,
                   '18f6722'  ,
                   '18f67j50' ,
                   '18f67k22'
extra_intosc_usb = '18f4550'  ,
                   '18f6722'  ,
                   '18f67j50'

const. = '?'
call load_ircf                                        /* pattern OSCCON_IRCF for 4 MHz per datasheet */

call envir 'python'                                   /* Python environment for validation */

samplecount = 0                                       /* count of created blink samples */

do i=1 to pic.0                                       /* all selected PIC names (device files) */

   parse value filespec('Name', pic.i) with picname '.jal'
   say picname

   if validate_file(devdir'/'picname'.jal') \= 0 then
      leave                                           /* terminate! */

   var. = '?'                                         /* modified to '!' or a number if present */
   fusedef. = ''                                      /* default empty */

   call scan_dev pic.i                                /* scan device file */

   if words(fusedef.osc) = 0 then do                  /* no fusedef.osc at all */
      osctype = 'INTOSC'                              /* must be internal oscillator */
      oscword = ''                                    /* without fuse_def OSC */
   end
   else if wordpos('HSH', fusedef.osc) > 0 then do
      osctype = 'HS'
      oscword = 'HSH'
   end
   else if wordpos('PRI', fusedef.osc) > 0  then do
      osctype = 'HS'
      oscword = 'PRI'
   end
   else if wordpos('HS', fusedef.osc) > 0  then do
      osctype = 'HS'
      oscword = 'HS'
   end
   else if wordpos('INTOSC_NOCLKOUT', fusedef.osc) > 0 then do
      osctype = 'INTOSC'
      oscword = 'INTOSC_NOCLKOUT'
   end
   else do
      say '   Could not detect suitable OSC keyword in' fusedef.osc
      iterate                                                  /* skip this PIC */
   end

   if create_sample(osctype, oscword, pic.i) = 0 then do       /* primary sample OK */
      samplecount = samplecount + 1
      if osctype = 'HS' then do                                /* this was a HS type */
         if wordpos(picname, extra_intosc) > 0   &,            /* INTOSC sample requested */
            wordpos('INTOSC_NOCLKOUT', fusedef.osc) > 0 then do   /* has intosc support */
            if create_sample('INTOSC', 'INTOSC_NOCLKOUT', pic.i) = 0 then do
               samplecount = samplecount + 1
            end
         end
         if wordpos('HS_PLL', fusedef.osc) > 0  &,             /* must have HS_PLL osc. mode */
            var.usb_bdt = '!'  then do                         /* must have USB support */
            if create_sample('HS_USB', 'HS_PLL', pic.i) = 0 then do
               samplecount = samplecount + 1
               if wordpos(picname, extra_intosc_usb) > 0  &,   /* INTOSC_USB sample requested */
                  wordpos('INTOSC_NOCLKOUT_USB_HS', fusedef.osc) > 0  then do   /* must have! */
                  if create_sample('INTOSC_USB', 'INTOSC_NOCLKOUT_USB_HS', pic.i) = 0 then do
                     samplecount = samplecount + 1
                  end
               end
            end
         end
      end
   end
end

say 'Created' samplecount 'blink-a-led sample programs!'

return 0


/* --------------------------------------------------- */
/* Create, validate and compile sample                  */
/* --------------------------------------------------- */
create_sample: procedure expose picname pgmname Compilerversion ScriptAuthor,
                                runtype var. const. fusedef.

parse arg osctype, oscword, devfile .

pgmname = build_sample(osctype, oscword, devfile)
if pgmname = '' then
   return 1                                        /* build failed */

if validate_file(pgmname'.jal') \= 0 then
   return 1                                        /* validate failed */

if compile_sample(pgmname) \= 0 then
   return 1                                        /* compilation failed */

return 0


/* --------------------------------------------------- */
/* Build sample program                                */
/* Type of oscillator determines contents.             */
/* Returns PgmName when successful, emtpy if not.      */
/* --------------------------------------------------- */
build_sample: procedure expose picname pgmname Compilerversion ScriptAuthor,
                               var. const. fusedef.

parse arg osctype, oscword, devfile .

pgmname = picname'_blink'                             /* pictype + function */
if osctype = 'HS' then
   pgmname = pgmname'_hs'                             /* OSC ID */
else if osctype = 'INTOSC' then
   pgmname = pgmname'_intosc'
else if osctype = 'HS_USB' then
   pgmname = pgmname'_hs_usb'
else if osctype = 'INTOSC_USB' then
   pgmname = pgmname'_intosc_usb'
else do
   say '   Unrecognized oscillator type:' osctype
   return ''
end

if left(osctype,6) = 'INTOSC'  &,                     /* no 4 MHz INTOSC for some PICs */
    (var.datasheet = '39663' |,
     var.datasheet = '39682' |,
     var.datasheet = '39760' |,
     var.datasheet = '39762')   then do
   say '   'does not support 4 MHz with internal oscillator'
   return ''
end

pgmfile = pgmname'.jal'                               /* program filespec */

call SysFileDelete pgmfile                            /* remove any previous version */
call stream  pgmfile, 'c', 'open write'
call lineout pgmfile, '-- ------------------------------------------------------'
call lineout pgmfile, '-- Title: Blink-a-led of the Microchip pic'picname
call lineout pgmfile, '--'
call lineout pgmfile, '-- Author:' ScriptAuthor', Copyright (c) 2008..2014, all rights reserved.'
call lineout pgmfile, '--'
call lineout pgmfile, '-- Adapted-by:'
call lineout pgmfile, '--'
call lineout pgmfile, '-- Revision: $Revision$'
call lineout pgmfile, '--'
call lineout pgmfile, '-- Compiler:' CompilerVersion
call lineout pgmfile, '--'
call lineout pgmfile, '-- This file is part of jallib',
                      ' (http://jallib.googlecode.com)'
call lineout pgmfile, '-- Released under the BSD license',
                      '(http://www.opensource.org/licenses/bsd-license.php)'
call lineout pgmfile, '--'
call lineout pgmfile, '-- Description:'
call lineout pgmfile, '-- Simple blink-a-led program for Microchip pic'picname
if osctype = 'HS' | osctype = 'HS_USB' then
   call lineout pgmfile, '-- using an external crystal or resonator.'
else
   call lineout pgmfile, '-- using the internal oscillator.'
call lineout pgmfile, '-- The LED should be flashing twice a second!'
call lineout pgmfile, '--'
call lineout pgmfile, '-- Sources:'
call lineout pgmfile, '--'
call lineout pgmfile, '-- Notes:'
call lineout pgmfile, '--  - Creation date/time:' date('N') time('N')'.'
call lineout pgmfile, '--  - This file is generated by "blink-a-led.cmd" script! Do not change!'
call lineout pgmfile, '--'
call lineout pgmfile, '-- ------------------------------------------------------'
call lineout pgmfile, '--'
call lineout pgmfile, 'include' picname '                     -- target PICmicro'
call lineout pgmfile, '--'

/* oscillator configuration */
if osctype = 'HS' then do                             /* HS crystal or resonator */
   call lineout pgmfile, '-- This program assumes that a 20 MHz resonator or crystal'
   call lineout pgmfile, '-- is connected to pins OSC1 and OSC2.'
   call lineout pgmfile, 'pragma target clock 20_000_000      -- oscillator frequency'
   call lineout pgmfile, '--'
   call lineout pgmfile, 'pragma target OSC      'left(oscword,25) '-- crystal or resonator'
   if osc_word = 'PRI' then do
      call lineout pgmfile, 'pragma target POSCMD   'left('HS',25) '-- high speed'
   end
end
else if osctype = 'INTOSC' | osctype = '' then do       /* internal oscillator */
   call lineout pgmfile, '-- This program uses the internal oscillator at 4 MHz.'
   call lineout pgmfile, 'pragma target clock 4_000_000       -- oscillator frequency'
   call lineout pgmfile, '--'
   if oscword \= '' then                              /* PIC has fuse_def OSC */
      call lineout pgmfile, 'pragma target OSC      'left(oscword,25) '-- internal oscillator'
   if wordpos('F4MHZ', fusedef.ioscfs) > 0 then
      call lineout pgmfile, 'pragma target IOSCFS   'left('F4MHZ',25) '-- select 4 MHz'
end
else if osctype = 'HS_USB' then do                    /* HS oscillator and USB */
   call lineout pgmfile, '-- This program assumes that a 20 MHz resonator or crystal'
   call lineout pgmfile, '-- is connected to pins OSC1 and OSC2, and USB active.'
   call lineout pgmfile, '-- But PIC will be running at 48MHz.'
   call lineout pgmfile, 'pragma target clock 48_000_000      -- oscillator frequency'
   call lineout pgmfile, '--'
   call lineout pgmfile, 'pragma target OSC      'left(oscword,25) '-- HS osc + PLL'
end
else if osctype = 'INTOSC_USB' then do                   /* internal oscillator + USB */
   call lineout pgmfile, '-- This program uses the internal oscillator with PLL active.'
   call lineout pgmfile, 'pragma target clock 48_000_000      -- oscillator frequency'
   call lineout pgmfile, '--'
   call lineout pgmfile, 'pragma target OSC      'left(oscword,25) '-- internal oscillator'
end

/* other required fuse_defs */
if fusedef.pllen \= '' then do                                 /* PLLEN present */
   if osctype = 'INTOSC' then do                               /* INTOSC selected */
      if (var.datasheet = '40001430'                           |,
          var.datasheet = '41341' | var.datasheet = '40001341' |,
          var.datasheet = '41417' | var.datasheet = '40001417' |,
          var.datasheet = '41418' | var.datasheet = '40001418' ) then
         call lineout pgmfile, 'pragma target PLLEN    'left('ENABLED',25) '-- PLL on'
      else
         call lineout pgmfile, 'pragma target PLLEN    'left('DISABLED',25) '-- PLL off'
   end
   else if pos('DISABLED', fusedef.pllen) > 0 then             /* PLL off */
      call lineout pgmfile, 'pragma target PLLEN    'left('DISABLED',25) '-- PLL off'
end
if fusedef.plldiv \= '' then do
   if osctype = 'HS_USB' then
      call lineout pgmfile, 'pragma target PLLDIV   'left('P5',25) '-- 20 MHz -> 4 MHz'
   else if osctype = 'INTOSC_USB' then
      call lineout pgmfile, 'pragma target PLLDIV   'left('P2',25) '-- 8 MHz -> 4 MHz'
   else
      call lineout pgmfile, 'pragma target PLLDIV   'left('P1',25) '-- clock postscaler'
end
if fusedef.cpudiv \= '' then
   call lineout pgmfile, 'pragma target CPUDIV   'left(word(fusedef.cpudiv,1),25) '-- Fosc divisor'
if fusedef.usbpll \= '' then do
   if osctype = 'HS_USB' then
      call lineout pgmfile, 'pragma target USBPLL   'left(word(fusedef.usbpll,1),25) '-- USB clock selection'
end
if fusedef.clkoen \= '' then
   call lineout pgmfile, 'pragma target CLKOEN   'left(word(fusedef.clkoen,1),25) '-- clockout'
if fusedef.wdt \= '' then do
   if wordpos('DISABLED', fusedef.wdt) > 0 then
      wdtword = 'DISABLED'
   else if wordpos('CONTROL', fusedef.wdt) > 0 then
      wdtword = 'CONTROL'
   call lineout pgmfile, 'pragma target WDT      'left(wdtword,25) '-- watchdog'
end
if fusedef.xinst \= '' then
   call lineout pgmfile, 'pragma target XINST    'left(word(fusedef.xinst,1),25) '-- extended instruction set'
if fusedef.debug \= '' then
   call lineout pgmfile, 'pragma target DEBUG    'left(word(fusedef.debug,1),25) '-- debugging'
if fusedef.brownout \= '' then
   call lineout pgmfile, 'pragma target BROWNOUT 'left(word(fusedef.brownout,1),25) '-- brownout reset'
if fusedef.fcmen \= '' then
   call lineout pgmfile, 'pragma target FCMEN    'left(word(fusedef.fcmen,1),25) '-- clock monitoring'
if fusedef.ieso \= '' then
   call lineout pgmfile, 'pragma target IESO     'left(word(fusedef.ieso,1),25) '-- int/ext osc. switch'
if fusedef.vregen \= '' then
   call lineout pgmfile, 'pragma target VREGEN   'left(word(fusedef.vregen,1),25) '-- voltage regulator'
if fusedef.lvp \= '' then
   call lineout pgmfile, 'pragma target LVP      'left(word(fusedef.lvp,1),25) '-- low voltage programming'
if fusedef.mclr \= '' then
   call lineout pgmfile, 'pragma target MCLR     'left(word(fusedef.mclr,1),25) '-- reset '

call lineout pgmfile, '--'
call lineout pgmfile, '-- The configuration bit settings above are only a selection, sufficient'
call lineout pgmfile, '-- for this program. Other programs may need more or different settings.'
call lineout pgmfile, '--'

if wdtword = 'CONTROL' then do
   if var.wdtcon_swdten = '!' then do                       /* SWDTEN bit present */
      call lineout pgmfile, 'WDTCON_SWDTEN = OFF                 -- disable WDT'
   end
end

if osctype = 'INTOSC' then do                               /* internal oscillator selected */
   if var.osccon_scs = '!' then
      call lineout pgmfile, 'OSCCON_SCS = 0                      -- select primary oscillator'

   if var.ircfwidth > 0 then do                             /* OSCCON_IRCF declared */
      ds = var.datasheet
      if const.ircf.ds = '?' then
         say '   Missing OSCCON_IRCF specification for datasheet' ds
      else if length(const.ircf.ds) \= var.ircfwidth then
         say '   Conflict between width of OSCCON_IRCF ('var.ircfwidth') and "'const.ircf.ds'"'
      else if const.ircf.ds = '--' then
         say '   Invalid bit pattern ("'const.ircf.ds'") for OSCCON_IRCF'
      else
         call lineout PgmFile, 'OSCCON_IRCF = 0b'const.ircf.ds'                -- 4 MHz'
   end

   if var.osccon_spllen = '!' then
      call lineout pgmfile, 'OSCCON_SPLLEN = FALSE               -- software PLL off'

end

if osctype = 'INTOSC_USB' then                              /* internal oscillator + USB */
   if var.osccon_scs = '!' then do
      call lineout pgmfile, 'OSCCON_SCS = 0                      -- select primary oscillator'

   if var.osctune_pllen = '!'  then
      call lineout pgmfile, 'OSCTUNE_PLLEN = TRUE                -- activate PLL module'
end

call lineout pgmfile, '--'

call lineout pgmfile, 'enable_digital_io()                 -- make all pins digital I/O'
call lineout pgmfile, '--'
call lineout pgmfile, 'include delay                       -- library with delay procedures'
call lineout pgmfile, '--'
call lineout pgmfile, '-- A low current (2 mA) led with 2.2K series resistor is recommended'
call lineout pgmfile, '-- since the chosen pin may not be able to drive an ordinary 20mA led.'
call lineout pgmfile, '--'

ledpin = find_pin(devfile)                                     /* get valid pin for LED */

call lineout pgmfile, 'alias  led       is' ledpin'          -- alias for pin with LED'
call lineout pgmfile, '--'
call lineout pgmfile, ledpin'_direction  = OUTPUT'
call lineout pgmfile, '--'
call lineout pgmfile, 'forever loop'
call lineout pgmfile, '   led = ON'
call lineout pgmfile, '   delay_100ms(1)'
call lineout pgmfile, '   led = OFF'
call lineout pgmfile, '   delay_100ms(4)'
call lineout pgmfile, 'end loop'
call lineout pgmfile, '--'
call stream pgmfile, 'c', 'close'                              /* blink sample complete! */

return pgmname


/* --------------------------------------------------- */
/* Validate JAL file                                   */
/* Can be device file of sample program                */
/* --------------------------------------------------- */
validate_file: procedure expose picname

return 0   /* *** TEMP ***/

parse arg fn .

'@python' 'k:/jallib/tools/jallib.py validate' fn '1>'picname'.pyout' '2>'picname'.pyerr'
if rc \= 0 then do
   say '   Validation of' fn 'failed, rc' rc
   '@type' picname'.pyerr'
   return rc
end
'@erase' picname'.py*'                            /* when OK, discard logs */
say '   File' fn 'validated OK!'
return 0


/* --------------------------------------------------- */
/* Compile sample program and check the result         */
/* Return result code of compiler (0 = OK)             */
/* --------------------------------------------------- */
compile_sample: procedure expose runtype

parse arg pgmname .                                /* sample name  without .jal */

pgmfile = pgmname'.jal'                            /* filename */

if runtype = 'PROD' then do                        /* test mode */
   compiler = 'k:\jallib\compiler\JalV2ecs.exe'    /* prod compiler */
   include = 'k:/jallib/include/device;k:/jallib/include/jal'   /* JalV2 include specification */
   smpdir = 'k:/jallib/sample'                        /* destination of sample source */
   devdir = 'k:/jallib/include/device'                /* device files to create samples from */
end
else do                                            /* test mode */
   compiler = 'k:\c\jalv2\bin\JalV2ecs.exe'        /* latest (beta) compiler */
   include = 'k:/jal/pic2jal/test;k:/jallib/include/jal'   /* test device files + prod JAL files */
   smpdir = './test'                                  /* destination of blink samples (all files) */
   devdir = 'k:/jal/pic2jal/test'                     /* test device files */
   if stream(devdir'/chipdef_jallib.jal', 'c', 'query exists') = '' then do   /* no test device files */
      include = 'k:/jallib/include/device;k:/jallib/include/jal'   /* prod device files + prod JAL files */
      devdir = 'k:/jallib/include/device'             /* production device files */
   end
end

options = '-no-codfile -no-asm -s' include            /* compiler options */

'@'compiler options '-log' pgmname'.log' pgmfile '>nul'  /* compile */

rx = rc
if rx \= 0 then do                                    /* compile error */
   say '   JalV2 compile error' rc
   if runtype = 'PROD' then do
      say '   Compilation of' pgmname 'failed, rc =' rx
      return rc                                       /* terminate */
   end
end

call SysFileSearch 'WARNING', pgmname'.log', 'LG.'    /* find warning line in log */
if LG.0 > 0 then do
   parse upper var LG.1 errs 'ERRORS,' wngs 'WARNINGS'
   if errs = 0 & wngs = 0 then do
      if stream(pgmname'.hex', 'c', 'query exists') = '' then do
         Say '   Zero warnings and errors, but no hex file. Compiler failure!'
         return 1                            /* terminate */
      end
      else do
         say '   Compilation of' pgmname 'succeeded!'
         '@xcopy' pgmfile translate(smpdir,'\','/')  '1>nul'
         if rc \= 0 then do
            say '   Copy of' pgmfile 'to' smpdir 'failed'
            return 1
         end
         if runtype = 'TEST' then do
            '@xcopy' pgmname'.hex' translate(smpdir,'\','/') '1>nul'
            '@xcopy' pgmname'.log' translate(smpdir,'\','/') '1>nul'
         end
         call SysFileDelete pgmfile
         call SysFileDelete pgmname'.log'
         call SysFileDelete pgmname'.hex'
      end
   end
   else do
      say '   Compilation of' pgmname 'failed:' LG.1
   end
end
else do
   say '   Compilation of' pgmname 'failed, file' pgmname'.log' 'not found'
   return 1                                    /* terminate */
end
return 0


/* ---------------------------------------------------- */
/* Find suitable pin for LED                            */
/* Default is pin_A0, but needs check with device file. */
/* ---------------------------------------------------- */
find_pin: procedure

parse arg devfile .                                   /* device file thsi PIC */

port.1 = 'A'
port.2 = 'B'
port.3 = 'C'
port.0 = 3                                            /* portletters to scan */
do p=1 to port.0
   do q=0 to 7                                        /* pin_p0..7 */
      pinPQ = 'pin_'port.p||q                         /* pin name */
      call SysFileSearch ' 'pinPQ' ', devfile, 'pin.'     /* search pin in device file */
      if pin.0 > 0 then do                            /* pin found */
         call SysFileSearch ' 'pinPQ'_direction', devfile, 'tris.'    /* search TRISx */
         if tris.0 > 0 then                           /* found */
            leave p                                   /* return */
         else                                         /* no TRISx found */
            say '   Found' pinPQ', but no' pinPQ'_direction, skip this pin.'
      end
   end
end
call stream devfile, 'c', 'close'                         /* done with device file */
if p > port.0 then do
   say '   Could not find suitable I/O pin for LED'
   return ''
end
return pinPQ


/* --------------------------------------------------- */
/* Scan device file for required (configuration) info. */
/* Note: returns info in the exposed global variables. */
/* --------------------------------------------------- */
scan_dev: procedure expose fusedef. var.

parse arg fn .

var.ircfwidth = 0                                        /* default field width */

call stream fn, 'c', 'open read'

do while lines(fn)

   ln = linein(fn)

   if pos(' DATASHEET[]', ln) > 0 then do
      ds = strip(word(ln,words(ln)),,'"')                /* last word excl quotes */
      if datatype(right(ds,1),'M') = 1 then              /* last char not numeric */
         ds = left(ds,length(ds)-1)                      /* remove suffix */
      var.datasheet = ds + 0
      iterate
   end

   if pos(' WDTCON_SWDTEN ', ln) > 0 then do
      var.wdtcon_swdten = '!'
      iterate
   end

   if pos(' USB_BDT_ADDRESS ', ln) > 0 then do
      var.usb_bdt = '!'
      iterate
   end

   if pos(' OSCCON_IRCF ', ln) > 0 then do
      if pos('bit*2', ln) > 0 then
         var.ircfwidth = '2'
      else if pos('bit*3', ln) > 0 then
         var.ircfwidth = '3'
      else if pos('bit*4', ln) > 0 then
         var.ircfwidth = '4'
      iterate
   end

   if pos(' OSCCON_SCS ', ln) > 0 then do
      var.osccon_scs = '!'
      iterate
   end

   if pos(' OSCCON_SPLLEN ', ln) > 0 then do
      var.osccon_spllen = '!'
      iterate
   end

   if pos(' OSCTUNE_PLLEN ', ln) > 0 then do
      var.osctune_pllen = '!'
      iterate
   end

   parse var ln 'pragma' 'fuse_def' fuse
   fuse = strip(fuse)

   select

      when left(fuse,8) = 'BROWNOUT' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'DISABLED' then do
               fusedef.brownout = strip(fusedef.brownout' 'kwd)
            end
         end
      end
      when left(fuse,6) = 'CLKOEN' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'DISABLED' then do
               fusedef.clkoen = strip(fusedef.clkoen' 'kwd)
            end
         end
      end
      when left(fuse,6) = 'CPUDIV' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'P1' then do
               fusedef.cpudiv = strip(fusedef.cpudiv' 'kwd)
            end
         end
      end
      when left(fuse,5) = 'DEBUG' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'DISABLED' then do
               fusedef.debug = strip(fusedef.debug' 'kwd)
            end
         end
      end
      when left(fuse,5) = 'FCMEN' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'DISABLED' then do
               fusedef.fcmen = strip(fusedef.fcmen' 'kwd)
            end
         end
      end
      when left(fuse,5) = 'ICPRT' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'DISABLED' then do
               fusedef.icprt = strip(fusedef.icprt' 'kwd)
            end
         end
      end
      when left(fuse,4) = 'IESO' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'DISABLED' then do
               fusedef.ieso = strip(fusedef.ieso' 'kwd)
            end
         end
      end
      when left(fuse,6) = 'IOSCFS' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'F4MHZ' |,
               kwd = 'F8MHZ' then do
               fusedef.ioscfs = strip(fusedef.ioscfs' 'kwd)
            end
         end
      end
      when left(fuse,3) = 'LVP' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'DISABLED' then do
               fusedef.lvp = strip(fusedef.lvp' 'kwd)
            end
         end
      end
      when left(fuse,4) = 'MCLR' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'EXTERNAL' |,
               kwd = 'INTERNAL' then do
               fusedef.mclr = strip(fusedef.mclr' 'kwd)
            end
         end
      end
      when left(fuse,4) = 'OSC:' |,
           left(fuse,4) = 'OSC ' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            fusedef.osc = strip(fusedef.osc' 'kwd)
         end
      end
      when left(fuse,6) = 'PLLDIV' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'P1' then do
               fusedef.plldiv = strip(fusedef.plldiv' 'kwd)
            end
         end
      end
      when left(fuse,5) = 'PLLEN' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            fusedef.pllen = strip(fusedef.pllen' 'kwd)
         end
      end
      when left(fuse,6) = 'USBPLL' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            fusedef.usbpll = strip(fusedef.usbpll' 'kwd)
         end
      end
      when left(fuse,6) = 'VREGEN' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'ENABLED' then do
               fusedef.vregen = strip(fusedef.vregen' 'kwd)
            end
         end
      end
      when left(fuse,4) = 'WDT:' |,
           left(fuse,4) = 'WDT ' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'DISABLED' |,
               kwd = 'CONTROL'  then do
               fusedef.wdt = strip(fusedef.wdt' 'kwd)
            end
         end
      end
      when left(fuse,5) = 'XINST' then do
         do until word(ln,1) = '}'
            ln = linein(fn)
            kwd = word(ln,1)
            if kwd = 'DISABLED' then do
               fusedef.xinst = strip(fusedef.xinst' 'kwd)
            end
         end
      end
   otherwise
      nop
   end
end
call stream fn, 'c', 'close'                    /* done with device file */
return


/* ------------------------------------------- */
/* load ircf settings per datasheet            */
/* datasheet must be specified without suffix  */
/* ircf value: -- no INTOSC or IRCF            */
/*            bb..bbbb  bit pattern for 4 MHz  */
/* PLL off unless marked on                    */
/* ------------------------------------------- */
load_ircf: procedure expose const.
const.ircf.30221    = '--'
const.ircf.30292    = '--'
const.ircf.30325    = '--'
const.ircf.30430    = '--'
const.ircf.30445    = '--'
const.ircf.30485    = '--'
const.ircf.30487    = '110'
const.ircf.30491    = '--'
const.ircf.30498    = '110'
const.ircf.30509    = '--'       /* DS 39977 */
const.ircf.30569    = '--'
const.ircf.30575    = '--'       /* special */
const.ircf.30684    = '101'
const.ircf.35007    = '--'
const.ircf.39564    = '--'
const.ircf.39582    = '--'
const.ircf.39597    = '--'
const.ircf.39598    = '110'
const.ircf.39599    = '110'
const.ircf.39605    = '110'
const.ircf.39609    = '--'
const.ircf.39612    = '--'
const.ircf.39616    = '110'
const.ircf.39625    = '110'
const.ircf.39626    = '110'
const.ircf.39629    = '110'
const.ircf.39631    = '110'
const.ircf.39632    = '110'
const.ircf.39635    = '110'
const.ircf.39636    = '110'
const.ircf.39637    = '110'
const.ircf.39646    = '110'
const.ircf.39663    = '--'       /* no 4 MHz */
const.ircf.39682    = '--'       /* no 4 MHz */
const.ircf.39689    = '110'
const.ircf.39755    = '110'      /* DS 39631 */
const.ircf.39758    = '110'
const.ircf.39759    = '--'
const.ircf.39760    = '--'       /* no 4 MHz */
const.ircf.39761    = '110'
const.ircf.39762    = '--'       /* no 4 MHz */
const.ircf.39770    = '110'
const.ircf.39774    = '110'
const.ircf.39775    = '110'
const.ircf.39778    = '110'
const.ircf.39887    = '110'      /* DS 39632 */
const.ircf.39894    = '110'      /* DS 39646 */
const.ircf.39896    = '110'      /* DS 39629 */
const.ircf.39931    = '110'
const.ircf.39932    = '110'
const.ircf.39933    = '110'
const.ircf.39948    = '110'      /* DS 39933 */
const.ircf.39957    = '101'
const.ircf.39960    = '101'      /* DS 39625 */
const.ircf.39963    = '110'
const.ircf.39964    = '110'
const.ircf.39974    = '110'
const.ircf.39977    = '101'
const.ircf.39979    = '110'
const.ircf.40001239 = '--'
const.ircf.40001430 = '01'       /* PLLEN = 1 */
const.ircf.40001441 = '1101'
const.ircf.40001452 = '1101'
const.ircf.40001453 = '1101'
const.ircf.40001574 = '1101'
const.ircf.40001576 = '10'
const.ircf.40001585 = '101'
const.ircf.40001607 = '1101'
const.ircf.40001609 = '1101'
const.ircf.40001652 = '--'       /* IOSCFS = 0 for 4MHz */
const.ircf.40001674 = '1101'
const.ircf.40001684 = '--'       /* IOSCFS = 0 for 4MHz */
const.ircf.40001709 = '10'
const.ircf.40001715 = '1101'
const.ircf.40001722 = '1101'
const.ircf.40001723 = '1101'
const.ircf.40001726 = '1101'
const.ircf.40001729 = '1101'
const.ircf.40001737 = '1101'
const.ircf.40001740 = '1101'
const.ircf.40039    = '--'
const.ircf.40044    = '--'
const.ircf.40197    = '--'
const.ircf.40300    = '--'
const.ircf.41159    = '--'
const.ircf.41190    = '--'
const.ircf.41202    = '110'
const.ircf.41203    = '110'
const.ircf.41206    = '--'
const.ircf.41211    = '110'
const.ircf.41213    = '--'
const.ircf.41232    = '110'
const.ircf.41236    = '--'
const.ircf.41249    = '110'
const.ircf.41250    = '110'
const.ircf.41262    = '110'
const.ircf.41268    = '--'       /* IOSCFS = 0 for 4MHz */
const.ircf.41270    = '--'       /* IOSCFS = 0 for 4MHz */
const.ircf.41288    = '--'       /* IOSCFS = 0 for 4MHz */
const.ircf.41291    = '110'
const.ircf.41302    = '--'       /* IOSCFS = 0 for 4MHz */
const.ircf.41303    = '101'
const.ircf.41319    = '--'       /* IOSCFS = 0 for 4MHz */
const.ircf.41326    = '--'       /* IOSCFS = 0 for 4MHz */
const.ircf.41341    = '01'       /* PLLEN = 1 */
const.ircf.41350    = '101'
const.ircf.41364    = '1101'
const.ircf.41365    = '101'
const.ircf.41391    = '1101'
const.ircf.41412    = '101'
const.ircf.41413    = '1101'
const.ircf.41414    = '1101'
const.ircf.41417    = '01'       /* PLLEN = 1 */
const.ircf.41418    = '01'       /* PLLEN = 1 */
const.ircf.41419    = '1101'
const.ircf.41440    = '1101'
const.ircf.41455    = '1101'
const.ircf.41458    = '1101'
const.ircf.41569    = '1101'
const.ircf.41575    = '1101'
const.ircf.41579    = '1101'
const.ircf.41580    = '101'      /* DS 41365 */
const.ircf.41586    = '1101'
const.ircf.41594    = '1101'
const.ircf.41607    = '1101'
const.ircf.41615    = '1101'
const.ircf.41624    = '1101'
const.ircf.41634    = '--'       /* IOSCFS = 0 for 4MHz */
const.ircf.41635    = '--'       /* IOSCFS = 0 for 4MHz */
const.ircf.41636    = '1101'
const.ircf.41637    = '1101'
const.ircf.41639    = '1101'
const.ircf.41657    = '1101'
const.ircf.41673    = '1101'     /* DS 41440 */
const.ircf.41675    = '1101'
return

