/* ------------------------------------------------------------------------ *
 * Title: Dev2Jal.cmd - Create JalV2 device include files for flash PICs    *
 *                                                                          *
 * Author: Rob Hamerling, Copyright (c) 2008..2012, all rights reserved.    *
 *                                                                          *
 * Adapted-by:                                                              *
 *                                                                          *
 * Revision: $Revision$                                                     *
 *                                                                          *
 * Compiler: N/A                                                            *
 *                                                                          *
 * This file is part of jallib  http://jallib.googlecode.com                *
 * Released under the BSD license                                           *
 *              http://www.opensource.org/licenses/bsd-license.php          *
 *                                                                          *
 * Description:                                                             *
 *   Rexx script to create device include files for JALV2, and              *
 *   the file chipdef_jallib.jal, included by each of these.                *
 *   Apart from declaration of all registers, register-subfields, ports     *
 *   and pins of the chip the device files contain shadowing procedures     *
 *   to prevent the 'read-modify-write' problems and use the LATx register  *
 *   (for PICS which have such registers) for output in stead of PORTx.     *
 *   In addition some device dependent procedures are provided              *
 *   for common operations, like enable-digital-io().                       *
 *   Also various aliases are declared to 'normalize' the names of          *
 *   registers and bit fields, which makes it easier to build device        *
 *   independent libraries.                                                 *
 *                                                                          *
 * Sources:  MPLAB .dev                                                     *
 *                                                                          *
 * Notes:                                                                   *
 *   - This script is written in 'classic' Rexx as delivered with           *
 *     eComStation (OS/2) and is executed on a system with eCS 2.1.         *
 *     With only minor changes it can be executed on a different system,    *
 *     or even a different platform (Linux, Windows) with "Regina Rexx"     *
 *     Ref:  http://regina-rexx.sourceforge.net/                            *
 *     See the embedded comments below for instructions for possibly        *
 *     required changes. You don't have to look further than the line which *
 *     says "Here the device file generation actually starts" (approx 125). *
 *   - A summary of changes of this script is maintained in 'changes.txt'   *
 *     (not published, available on request).                               *
 *                                                                          *
 * ------------------------------------------------------------------------ */
   ScriptVersion   = '0.1.41'
   ScriptAuthor    = 'Rob Hamerling'
   CompilerVersion = '2.4p'
   MPlabVersion    = '889'
/* ------------------------------------------------------------------------ */

/* 'msglevel' controls the amount of messages being generated */
/*   0 - progress messages, info, warnings and errors         */
/*   1 - info, warnings and errors                            */
/*   2 - warnings and errors                                  */
/*   3 - errors (always reported!)                            */

msglevel = 1

/* MPLAB and a local copy of the Jallib SVN tree should be installed. */
/* For any system or platform the following base information must be  */
/* specified as a minimum.                                            */

MPLABbase  = 'k:/mplab'MPlabVersion'/'             /* MPLABxxx */
JALLIBbase = 'k:/jallib/'                          /* base dir. JALLIB (local) */

/* When using 'standard' installations no other changes are needed,        */
/* but you may check below which specific sources of information are used, */
/* and adapt this script for any deviations in your system setup.          */

/* The following libraries are used to collect information from   */
/* MPLAB .dev files:                                              */

devdir = MPLABbase'mplab ide/device/'              /* dir with MPLAB .dev files */

/* Some information is collected from files in JALLIB tools directory */

DevSpecFile   = JALLIBbase'tools/devicespecific.json'       /* device specific data */
PinMapFile    = JALLIBbase'tools/pinmap_pinsuffix.json'     /* pin aliases */
FuseDefFile   = JALLIBbase'tools/fusedefmap.cmd'            /* fuse_def mapping (Fosc) */
DataSheetFile = JALLIBbase'tools/datasheet.list'            /* actual datasheets */

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                                           /* load Rexx system functions */

call msg 0, 'Dev2Jal version' ScriptVersion '  -  ' ScriptAuthor
if msglevel > 2 then
   call msg 0, 'Only reporting errors!'

/* The destination of the generated device files depends on the first    */
/* mandatory commandline argument, which must be 'PROD' or 'TEST'        */
/*  - with 'PROD' the files go to directory "<JALLIBbase>include/device" */
/*  - with 'TEST' the files go to directory "./test>"                    */
/* Note: Before creating new device files all .jal files are             */
/*       removed from the desitation directory.                          */

parse upper arg destination selection .                     /* commandline arguments */

if destination = 'PROD' then                                /* production run */
   dstdir = JALLIBbase'include/device'                      /* local Jallib */
else if destination = 'TEST' then do                        /* test run */
   dstdir = './test'                                        /* subdir for testing */
   rx = SysMkDir(dstdir)                                    /* create destination dir */
   if rx \= 0 & rx \= 5 then do                             /* not created, not existing */
      call msg 3, rx 'while creating destination directory' dstdir
      return rx                                             /* unrecoverable: terminate */
   end
end
else do
   call msg 3, 'Required argument missing: "prod" or "test"',
               ' and optionally wildcard.'
   return 1
end

/* The optional second commandline argument designates for which PICs device */
/* files must be generated. This argument is only accepted in a 'TEST' run.  */
/* The selection may contain wildcards like '18LF*', default is '*' (all).   */

if selection = '' then                                      /* no selection spec'd */
   wildcard = 'PIC1*.dev'                                   /* default (8 bit PICs) */
else if destination = 'TEST' then                           /* TEST run */
   wildcard = 'PIC'selection'.dev'                          /* accept user selection */
else do                                                     /* PROD run with selection */
   call msg 3, 'No selection allowed for production run!'
   return 1                                                 /* unrecoverable: terminate */
end

/* ------ Here the device file generation actually starts ------------------------ */

call time 'R'                                               /* reset 'elapsed' timer */

call msg 0, 'Creating Jallib device files with MPLAB version' MPlabVersion

call SysFileTree devdir||wildcard, dir, 'FO'                /* get list of matching files */
if dir.0 = 0 then do
   call msg 3, 'No .dev files found matching <'wildcard'> in' devdir
   return 0                                                 /* nothing to do */
end
call SysStemSort 'dir.', 'A', 'I'                           /* sort on name (alpha, incremental) */

signal on syntax name catch_syntax                          /* catch syntax errors */
signal on error  name catch_error                           /* catch execution errors */

DevSpec. = '?'                                              /* default PIC specific data */
if file_read_devspec() \= 0 then                            /* read device specific data */
   return 1                                                 /* terminate with error */

PinMap.   = '?'                                             /* pin mapping data */
PinANMap. = '-'                                             /* pin_ANx -> RXy mapping */
if file_read_pinmap() \= 0 then                             /* read pin alias names */
   return 1                                                 /* terminate with error */

Fuse_Def. = '?'                                             /* Fuse_Def name mapping */
if file_read_fusedef() \= 0 then                            /* read fuse_def table */
   return 1                                                 /* terminate with error */

call SysFileTree dstdir'/*.jal', 'jal.', 'FO'               /* .jal files in destination */
do i = 1 to jal.0                                           /* all */
   call SysFileDelete jal.i                                 /* remove! */
end

chipdef = dstdir'/chipdef_jallib.jal'                       /* common include for device files */
if stream(chipdef, 'c', 'open write') \= 'READY:' then do   /* new chipdef file */
   call msg 3, 'Could not create common include file' chipdef
   return 1                                                 /* unrecoverable: terminate */
end
call list_chipdef_header                                    /* header of chipdef file */

xChipDef. = '?'                                             /* collection of dev IDs in chipdef */

ListCount = 0                                               /* # created device files */
SpecMissCount = 0                                           /* # missing in devicespecific.json */
DSMissCount = 0                                             /* # missing datasheet */
PinmapMissCount = 0                                         /* # missing in pinmap */

do i=1 to dir.0                                             /* all relevant .dev files */
                                                            /* init for each new PIC */
   DevFile = tolower(translate(dir.i,'/','\'))              /* lower case + forward slashes */
   parse value filespec('Name', DevFile) with 'pic' PicName '.dev'
   if PicName = '' then do
      call msg 3, 'Could not derive PIC name from filespec: "'DevFile'"'
      leave                                                 /* setup error: terminate */
   end

   if \(substr(PicName,3,1) = 'f'    |,                     /* not flash PIC or */
        substr(PicName,3,2) = 'lf'   |,                     /*     low power flash PIC or */
        substr(PicName,3,2) = 'hv')  |,                     /*     high voltage flash PIC */
      PicName = '16f54'              |,                     /* )                 */
      PicName = '16f57'              |,                     /* ) specific not    */
      PicName = '16f59'              |,                     /* ) supported PICs  */
      PicName = '16hv540' then do                           /* )                 */
      iterate
   end

   call msg 0, PicName                                      /* progress signal */

   PicNameCaps = SysMapCase(PicName)
   if DevSpec.PicNameCaps.DataSheet = '?' then do
      call msg 2, 'Not listed in' DevSpecFile', no device file generated'
      SpecMissCount = SpecMissCount + 1
      iterate                                               /* skip */
   end
   else if DevSpec.PicNameCaps.DataSheet = '-' then do
      call msg 2, 'No datasheet found in' DevSpecFile', no device file generated'
      DSMissCount = DSMissCount + 1
      iterate                                               /* skip */
   end
   if PinMap.PicNameCaps \= PicNameCaps then do             /* Name mismatch */
      call msg 2, 'No Pinmapping found in' PinMapFile
      PinmapMissCount = PinmapMissCount + 1                 /* count misses */
      iterate                                               /* skip */
   end

   Dev.        = ''                                         /* reset .dev file contents */
   if file_read_dev(DevFile) = 0 then                       /* read MPLAB .dev file */
      iterate

   Ram.                  = ''                               /* sfr usage and mirroring */
   Name.                 = '-'                              /* register and subfield names */
   CfgAddr.              = ''                               /* config memory addresses (decimal) */

   DevID                 = '0000'                           /* no device ID */
   NumBanks              = 0                                /* # memory banks */
   StackDepth            = 0                                /* hardware stack depth */
   AccessBankSplitOffset = 128                              /* 0x80 (18Fs) */
   CodeSize              = 0                                /* amount of program memory */
   DataSize              = 0                                /* amount of data memory (RAM) */
   IDSpec                = ''                               /* ID bytes: hexaddr,size (dec) */
   VddRange              = 0                                /* working voltage range */
   VddNominal            = 0                                /* nominal working voltage */
   VppRange              = 0                                /* programming voltage range */
   VppDefault            = 0                                /* default programming voltage */

   adcs_bitcount         = 0                                /* # ADCONx_ADCS bits */
   HasLATReg             = 0                                /* zero LAT registers found (yet) */
                                                            /* used for extended midrange only */


   /* -------- collect some basic information ------------ */

   core = load_config_info()                                /* core + various cfg info */

   /* -------- set core-dependent properties ------------ */

   select
      when core = '12' then do                              /* baseline */
         MaxRam       = 128                                 /* range 0..0x7F */
         BankSize     = 32                                  /* 0x0020 */
         PageSize     = 512                                 /* 0x0200 */
         DataStart    = '0x400'
         call load_sfr1x                                    /* SFR info */
      end
      when core = '14' then do                              /* classic midrange */
         MaxRam       = 512                                 /* range 0..0x1FF */
         BankSize     = 128                                 /* 0x0080 */
         PageSize     = 2048                                /* 0x0800 */
         DataStart    = '0x2100'
         call load_sfr1x
      end
      when core = '14H' then do                             /* enhance midrange (Hybrid) */
         MaxRam       = 4096                                /* range 0..0xFFF */
         BankSize     = 128                                 /* 0x0080 */
         PageSize     = 2048                                /* 0x0800 */
         DataStart    = '0xF000'
         call load_sfr1x
      end
      when core = '16' then do                              /* 18Fs */
         MaxRam       = 4096                                /* range 0..0xFFF */
         BankSize     = 256                                 /* 0x0100 */
         DataStart    = '0xF00000'
         rx = load_sfr16
      end
   otherwise                                                /* other or undetermined core */
      call msg 3, 'Unsupported core:' Core,                 /* report detected Core */
                  'Internal script error, terminating ....'
      leave                                                 /* script error: terminate */
   end

   /* ------------ produce device file ------------------------ */

   jalfile = dstdir'/'PicName'.jal'                         /* device filespec */
   if stream(jalfile, 'c', 'open write') \= 'READY:' then do
      call msg 3, 'Could not create device file' jalfile
      leave                                                 /* unrecoverable error */
   end

   call list_head                                           /* common header */
   call list_cfgmem                                          /* cfg mem addr + defaults */

   select
      when core = '12' then do                              /* baseline */
         call list_sfr1x
         call list_nmmr12
      end
      when core = '14' then do                              /* midrange */
         call list_sfr1x
         call list_nmmr14
      end
      when core = '14H' then do                             /* extended midrange (Hybrids) */
         call list_sfr14h
      end
      when core = '16' then do                              /* 18Fs */
         call list_sfr16
         call list_nmmr16
      end
   otherwise                                                /* other core  caught above */
      nop
   end

   call list_analog_functions                               /* common enable_digital_io() */

   call list_fusedefs                                       /* fusedefs */

   call stream jalfile, 'c', 'close'                        /* done with this PIC */

   ListCount = ListCount + 1;                               /* count generated device files */

end

call lineout chipdef, '--'                                  /* last line */
call stream  chipdef, 'c', 'close'                          /* done */

call stream DataSheetFile, 'c', 'close'                     /* done */

call msg 0, ''
ElapsedTime = time('E')
if ElapsedTime > 0 then
   call msg 1, 'Generated' listcount 'device files in' format(ElapsedTime,,2) 'seconds',
               ' ('format(listcount/ElapsedTime,,1) 'per second)'
if SpecMissCount > 0 then
   call msg 3, SpecMissCount 'device files not created because PIC not in' DevSpecFile
if DSMissCount > 0 then
   call msg 3, DSMissCount 'device files not created because no datasheet in' DevSpecFile
if PinmapMissCount > 0 then
   call msg 3, PinmapMissCount 'occurences of missing pin mapping in' PinmapFile

signal off error
signal off syntax                                           /* restore to default */

call SysDropFuncs                                           /* release Rexxutil */

return 0

/* ---------- This is the end of the mainline of dev2jal --------------- */




/* ---------------------------------------------- */
/* procedure to collect Config (fuses) info       */
/* input:   - nothing                             */
/* output:  - core (0, '12', '14', '14H', '16')   */
/* ---------------------------------------------- */
load_config_info: procedure expose Dev. PicName,
                                   StackDepth NumBanks AccessBankSplitOffset,
                                   CodeSize DataSize IDSpec DevID CfgAddr.,
                                   VddRange VddNominal VppRange VppDefault
CfgAddr.0 = 0                                               /* empty */
Core = 0                                                    /* undetermined */
do i = 1 to Dev.0 until word(Dev.i,1) = 'SFR'               /* process only the header lines */

   kwd = word(Dev.i,1)                                      /* selection keyword */

   select

      when kwd = 'CFGMEM' then do
         parse var Dev.i 'CFGMEM' '(' 'REGION' '=' '0X' Val1 '-' '0X' Val2 ')' .
         if Val1 \= '' then do
            Val1 = X2D(Val1)                                /* take decimal value */
            Val2 = X2D(Val2)
            if Val1 = X2D('FFF')  |,
               Val1 = X2D('7FF') then                       /* a.o. 16f527 */
               Core = '12'
            else if Val1 = X2D('2007') then
               Core = '14'
            else if Val1 = X2D('8007') then
               Core = '14H'
            else                                            /* otherwise */
               Core = '16'
            CfgAddr.0 = Val2 - Val1 + 1                     /* number of config words/bytes */
            do j = 1 to CfgAddr.0                           /* all of 'm */
               CfgAddr.j = Val1 + j - 1                     /* address (decimal) */
            end
         end
      end

      when left(kwd,12) = 'HWSTACKDEPTH' then do
         parse var Dev.i 'HWSTACKDEPTH' '=' Val1 .
         if Val1 \= '' then do
            StackDepth = strip(val1)
         end
      end

      when left(kwd,8) = 'NUMBANKS' then do
         parse var Dev.i 'NUMBANKS' '=' Value .
         if Value \= '' then
            NumBanks = strip(Value)
      end

      when left(kwd,21) = 'ACCESSBANKSPLITOFFSET' then do
         parse var Dev.i 'ACCESSBANKSPLITOFFSET' '=' '0X' Value .
         if Value \= '' then
            AccessBankSplitOffset = X2D(strip(Value))
      end

      when kwd = 'PGMMEM' then do
         parse var Dev.i 'PGMMEM' '(' 'REGION' '=' Value ')' .
         if Value \= '' then do
            parse var Value '0X' val1 '-' '0X' val2 .
            CodeSize = X2D(Val2) - X2D(val1) + 1
         end
      end

      when kwd = 'EEDATA' | kwd = 'FLASHDATA' then do
         parse var Dev.i val0 'REGION' '=' Value ')' .
         if Value \= '' then do
            parse var Value '0X' val1 '-' '0X' val2 .
            DataSize = X2D(val2) - X2D(val1) + 1
         end
      end

      when kwd = 'USERID' then do
         parse var Dev.i val0 'REGION' '=' Value ')' .
         if Value \= '' then do
            parse var Value '0X' val1 '-' '0X' val2 .
            IDSpec = '0x'strip(val1)','X2D(val2) - X2D(val1) + 1
         end
      end

      when kwd = 'DEVID' then do
         parse var Dev.i 'DEVID' val0 'IDMASK' '=' Val1 'ID' '=' '0X' val2 ')' .
         if val2 \= '' then do
            RevMask = right(strip(Val1),4,'0')                    /* 4 hex chars */
            DevID = right(strip(Val2),4,'0')                      /* 4 hex chars */
            DevID = C2X(bitand(X2C(DevID),X2C(RevMask)))          /* reset revision bits */
         end
      end

      when kwd = 'VPP' then do
         parse var Dev.i 'VPP' '(' 'RANGE' '=' Val1 'DFLT' '=' Val2 ')' .
         if Val1 \= '' then do
            VppRange = strip(Val1)
            VppDefault = strip(Val2)
         end
      end

      when kwd = 'VDD' then do
         parse var Dev.i 'VDD' '(' 'RANGE' '=' Val1 'DFLTRANGE' '=' Val2 'NOMINAL' '=' Val3 ')' .
         if Val1 \= '' then do
            VddRange = strip(Val1)
            VddNominal = strip(Val3)
         end
      end

   otherwise
      nop                                                         /* ignore */
   end

end
return core


/* ---------------------------------------------------------- */
/* procedure to build special function register array         */
/* with mirror info and unused registers                      */
/* input:  - nothing                                          */
/* 12-bit and 14-bit core                                     */
/* ---------------------------------------------------------- */
load_sfr1x: procedure expose Dev. Name. Ram. core MaxRam HasLATReg msglevel
do i = 0 to MaxRam - 1                                      /* whole range */
   Ram.i = 0                                                /* mark whole RAM as unused */
end
do i = 1 to Dev.0
   parse var Dev.i 'MIRRORREGS' '(' '0X' lo.1  '-' '0X' hi.1,
                                    '0X' lo.2  '-' '0X' hi.2,
                                    '0X' lo.3  '-' '0X' hi.3,
                                    '0X' lo.4  '-' '0X' hi.4,
                                    '0X' lo.5  '-' '0X' hi.5,
                                    '0X' lo.6  '-' '0X' hi.6,
                                    '0X' lo.7  '-' '0X' hi.7,
                                    '0X' lo.8  '-' '0X' hi.8,
                                    '0X' lo.9  '-' '0X' hi.9,
                                    '0X' lo.10 '-' '0X' hi.10,
                                    '0X' lo.11 '-' '0X' hi.11,
                                    '0X' lo.12 '-' '0X' hi.12,
                                    '0X' lo.13 '-' '0X' hi.13,
                                    '0X' lo.14 '-' '0X' hi.14,
                                    '0X' lo.15 '-' '0X' hi.15,
                                    '0X' lo.16 '-' '0X' hi.16,
                                    '0X' lo.17 '-' '0X' hi.17,
                                    '0X' lo.18 '-' '0X' hi.18,
                                    '0X' lo.19 '-' '0X' hi.19,
                                    '0X' lo.20 '-' '0X' hi.20,
                                    '0X' lo.21 '-' '0X' hi.21,
                                    '0X' lo.22 '-' '0X' hi.22,
                                    '0X' lo.23 '-' '0X' hi.23,
                                    '0X' lo.24 '-' '0X' hi.24,
                                    '0X' lo.25 '-' '0X' hi.25,
                                    '0X' lo.26 '-' '0X' hi.26,
                                    '0X' lo.27 '-' '0X' hi.27,
                                    '0X' lo.28 '-' '0X' hi.28,
                                    '0X' lo.29 '-' '0X' hi.29,
                                    '0X' lo.30 '-' '0X' hi.30,
                                    '0X' lo.31 '-' '0X' hi.31,
                                    '0X' lo.32 '-' '0X' hi.32 ')' .
   if lo.1 \= '' & hi.1 \= '' then do
      a = X2D(strip(lo.1))
      b = X2D(strip(strip(hi.1),'B',')'))
      do j = 2 to 32                                        /* all possible banks */
         if lo.j \= '' & hi.j \= '' then do                 /* specified bank */
            p = X2D(strip(lo.j))                            /* mirror low bound */
            do k = a to b                                   /* whole range */
               Ram.k = k                                    /* mark 'used' */
               Ram.p = k                                    /* mark as mirror */
               p = p + 1                                    /* next mirrored reg. */
            end
         end
      end
      iterate
   end
   parse var Dev.i 'UNUSEDREGS' '(' '0X' lo '-' '0X' hi ')' .
   if lo \= '' & hi \= '' then do
      a = X2D(strip(lo))
      b = X2D(strip(hi))
      do k = a to b                                         /* whole range */
         Ram.k = -1                                         /* mark 'unused' */
      end
      iterate
   end
   parse var Dev.i  val0 '(' 'KEY' '=' reg .
   if left(reg,3) = 'LAT' then
      HasLATReg = HasLATReg + 1                             /* count LATx registers */
end
return 0


/* ---------------------------------------------------------- */
/* procedure to build special function register array         */
/* with unused registers                                      */
/*                                                            */
/* input:  - nothing                                          */
/*                                                            */
/* 16-bit core                                                */
/* ---------------------------------------------------------- */
load_sfr16: procedure expose Dev. Ram. msglevel
do i = 1 to Dev.0
   parse var Dev.i 'UNUSEDREGS' '(' '0X' lo '-' '0X' hi ')' .
   if lo \= '' & hi \= '' then do
      a = X2D(strip(lo))
      b = X2D(strip(hi))
      do k = a to b                                         /* whole range */
         Ram.k = -1                                         /* mark 'unused' */
      end
   end
end
return 0


/* -------------------------------------------------------- */
/* procedure to assign a JalV2 unique ID in chipdef_jallib  */
/* input:  - nothing                                        */
/* remarks: some corrections of errors in MPLAB             */
/* -------------------------------------------------------- */
list_devid_chipdef: procedure expose Dev. jalfile chipdef Core PicName msglevel DevID xChipDef.
PicNameCaps = SysMapCase(PicName)                           /* name in upper case */
if DevId \== '0000' then                                    /* DevID not missing */
   xDevId = left(Core,2)'_'DevID
else do                                                     /* DevID unknown */
   DevID = right(PicNameCaps,3)                             /* rightmost 3 chars of name */
   if datatype(Devid,'X') = 0 then do                       /* not all hex digits */
      DevID = right(right(PicNameCaps,2),3,'F')             /* 'F' + rightmost 2 chars */
   end
   xDevId = Core'_F'DevID
end
if xChipDef.xDevId = '?' then do                            /* if not yet assigned */
   xChipDef.xDevId = PicName                                /* remember */
   call lineout chipdef, left('const       PIC_'PicNameCaps,29) '= 0x_'xDevId
end
else do
   call msg 2, 'DevID ('xDevId') in use by' xChipDef.xDevid
   do i = 1                                                 /* index in array */
      tDevId = xDevId||substr('abcdef0123456789',i,1)       /* temp value */
      if xChipDef.tDevId = '?' then do                      /* if not yet assigned */
         xDevId = tDevId                                    /* definitve value */
         xChipDef.xDevId = PicName                          /* remember alternate */
         call lineout chipdef, left('const       PIC_'PicNameCaps,29) '= 0x_'xDevId
         call msg 1, 'Alternate devid (0x'xDevid') assigned'
         leave                                              /* suffix assigned */
      end
      else
         call msg 2, 'DevID ('tDevId') in use by' xChipDef.tDevid
   end
   if i > 16 then do
      call msg 3, 'Not enough suffixes for identical devid, terminated!'
      exit 3
   end
end
return


/* ----------------------------------------------------------- */
/* procedure to list Config memory layout and default settings */
/* input:  - nothing                                           */
/* All cores                                                   */
/* ----------------------------------------------------------- */
list_cfgmem: procedure expose jalfile Dev. CfgAddr. DevSpec. PicName Core msglevel
PicNameCaps = SysMapCase(PicName)
FusesDerived = cfgmem_mask()                                /* derive from .dev file */
if DevSpec.PicNameCaps.FUSESDEFAULT \= '?' then do          /* specified in devicespecific.json */
   if length(DevSpec.PicNameCaps.FUSESDEFAULT) \= length(FusesDerived) then do
      call msg 3, 'Fuses in devicespecific.json do not match size of configuration memory'
      call msg 0, '   <'DevSpec.PicNameCaps.FUSESDEFAULT'>  <-->  <'FusesDerived'>'
      FusesDefault = FusesDerived                           /* take derived value */
   end
   else do                                                  /* same length */
      if DevSpec.PicNameCaps.FUSESDEFAULT = FusesDerived then
         call msg 2, 'FusesDefault in devicespecific.json same as derived:' FusesDerived
      FusesDefault = devSpec.PicNameCaps.FUSESDEFAULT      /* take devicespecific value */
      call msg 1, 'Using fuses from devicespecific.json:' FusesDefault
   end
end
else do                                                     /* not in devicespecific.json */
   FusesDefault = FusesDerived                              /* take derived value */
end

call lineout jalfile, 'const word  _FUSES_CT             =' CfgAddr.0
if CfgAddr.0 = 1 then do                    /* single word/byte only with baseline/midrange ! */
   call lineout jalfile, 'const word  _FUSE_BASE            = 0x'D2X(CfgAddr.1)
   call charout jalfile, 'const word  _FUSES                = 0b'
   do i = 1 to 4
      call charout jalfile, '_'X2B(substr(FusesDefault,i,1))
   end
   call lineout jalfile, ''
end
else do                                                     /* multiple fuse words/bytes */
   if core \= '16' then                                     /* baseline,midrange */
      call charout jalfile, 'const word  _FUSE_BASE[_FUSES_CT] = { '
   else                                                     /* 18F */
      call charout jalfile, 'const dword _FUSE_BASE[_FUSES_CT] = { '
   do  j = 1 to CfgAddr.0
      call charout jalfile, '0x'D2X(CfgAddr.j)
      if j < CfgAddr.0 then do
         call lineout jalfile, ','
         call charout jalfile, left('',38)
      end
   end
   call lineout jalfile, ' }'

   if core \= '16' then do                                     /* baseline,midrange */
      call charout jalfile, 'const word  _FUSES[_FUSES_CT]     = { '
      do  j = 1 to CfgAddr.0
         call charout jalfile, '0b'
         do i = 1 to 4
            call charout jalfile, '_'X2B(substr(FusesDefault,i+4*(j-1),1,'0'))
         end
         if j < CfgAddr.0 then                                 /* not last word */
            call charout jalfile, ', '
         else
            call charout jalfile, ' }'
         call lineout jalfile, '        -- CONFIG'||j
         if j < CfgAddr.0 then
            call charout jalfile, left('',38,' ')
      end
   end

   else do                                                     /* 18F */
      call charout jalfile, 'const byte  _FUSES[_FUSES_CT]     = { '
      do j = 1 to CfgAddr.0
         call charout jalfile, '0b'
         do i = 1 to 2
            call charout jalfile, '_'X2B(substr(FusesDefault,i+2*(j-1),1,'0'))
         end
         if j < CfgAddr.0 then
            call charout jalfile, ', '
         else
            call charout jalfile, ' }'
         call lineout jalfile, '        -- CONFIG'||(j+1)%2||substr('HL',1+(j//2),1)
         if j < CfgAddr.0 then
            call charout jalfile, left('',38,' ')
      end
   end

end
call lineout jalfile, '--'
return


/* ----------------------------------------------------------------- */
/* procedure to extract default config bits setting from .dev file   */
/* returns   power-on pattern                                        */
/* notes:                                                            */
/* ----------------------------------------------------------------- */
cfgmem_mask: procedure expose  Dev. CfgAddr. Core msglevel

do i = 1 to Dev.0                                  /* whole .dev contents */
  ln = Dev.i                                       /* next line */

  /* create arrays of cfg words (baseline,midrange) or bytes (18F) */
  parse var ln 'CFGMEM' '(' 'REGION' '=' '0X' addr1 '-' '0X' addr2 ')' .
  if addr1 \= '' then do
    cfglen = 1 + X2D(addr2) - X2D(addr1)
    if Core \= '16' then do                        /* baseline, (extended) midrange */
      CfgAct  = copies('0000', cfglen)             /* active bits */
      CfgZero = copies('3FFF', cfglen)             /* 'and' pattern of fixed zero bits */
      CfgOne  = copies('3FFF', cfglen)             /* 'or'  pattern of fixed one bits */
    end
    else do                                        /* 18Fs */
      CfgAct  = copies('00', cfglen)               /* active bits */
      CfgZero = copies('FF', cfglen)               /* 'and' pattern of fixed zero bits */
      CfgOne  = copies('00', cfglen)               /* 'or' pattern of fixed one bits */
    end
    iterate
  end

  /* initialise CfgOne or CfgZero array, with the following rules: */
  /* - unused bits read as '0' with baseline,midrange              */
  /* - unused bits read as '1' with 18f                            */
  /* Unfortunately this is not always true,                        */
  /* and MPLAB .dev files contain errors!                          */
  parse var ln 'CFGBITS' x1 'ADDR=0X' Addr 'UNUSED=0X' Unused ')' .
  if Addr \= '' then do
    Addr = strip(Addr)                                   /* address of cfg byte/word */
    Unused = strip(Unused)                               /* strip blanks */
    if Core \= '16' then do                              /* baseline, (extended) midrange */
      if X2D(Addr) <= X2D('FFF') then
        mask = '0FFF'                                    /* 12 bits core */
      else if X2D(Addr) <= X2D('200F') then
        mask = '3FFF'                                    /* 14 bits core */
      else if X2D(Addr) <= X2D('800F') then
        mask = '3FFF'                                    /* extended 14 bits core */
      Offset  = cfgmem_offset(Addr)                      /* word offset in cfg array */
      Unused  = right(Unused,4,'0')                      /* 4 hex digits */
      Unused  = C2X(BITXOR(X2C(Unused),X2C('FFFF')))     /* invert mask: 0->1 , 1->0 */
      Unused  = C2X(BITAND(X2C(Unused),X2C(mask)))       /* unused bits default to 0 */
      CfgZero = overlay(Unused, CfgZero, 4 * Offset + 1) /* replace 'm in fixed-zero array */
    end
    else do                                              /* 18F */
      Offset = cfgmem_offset(Addr)                       /* byte offset in cfg array */
      Unused = right(Unused,2,'0')                       /* unused bits default to 1 */
      CfgOne = overlay(Unused, CfgOne, 2 * Offset + 1)   /* replace 'm in fixed-one array */
    end
    iterate
  end

  /* build array of fixed zero and fixed 1 bits        */
  /* both the CfgZero and CfgOne arrays are modified   */
  parse var ln 'FIELD' '(' 'KEY=' x1 'MASK=0X' mask 'DESC="' x3 '"' 'INIT=0X' init ')'
  if init \= '' then do                                  /* init mask found */
    init = word(init,1)                                  /* first item */
    mask = strip(mask)                                   /* strip blanks */
    if Core \= '16' then do                              /* baseline, (extended) midrange */
      mask = right(mask,4,'0')                           /* 4 hex digits */
      maskinv = C2X(BITXOR(X2C(mask),X2C('FFFF')))       /* inverted mask */
      init = right(init,4,'0')                           /* 4 hex digits */
                                                         /* handle 0 bits: */
      CfgMod  = substr(CfgZero, 4 * Offset + 1, 4)       /* 4 hex digits to modify (partly) */
      CfgMod  = C2X(bitand(X2C(CfgMod),X2C(maskinv)))    /* zero out mask bits */
      CfgMod  = C2X(bitor(X2C(CfgMod),X2C(init)))        /* change word */
      CfgZero = overlay(CfgMod, CfgZero, 4 * Offset + 1) /* replace word in string */
                                                         /* handle 1 bits: */
      CfgMod  = substr(CfgOne, 4 * Offset + 1, 4)        /* 4 hex digits to modify */
      CfgMod  = C2X(bitand(X2C(CfgMod),X2C(maskinv)))    /* zero init bits */
      CfgMod  = C2X(bitor(X2C(CfgMod),X2C(init)))        /* change word */
      CfgOne  = overlay(CfgMod, CfgOne, 4 * Offset + 1)  /* replace word in string */
    end
    else do                                              /* 18F series */
      mask = right(mask,2,'0')                           /* 2 hex digits */
      maskinv = C2X(BITXOR(X2C(mask),X2C('FF')))         /* inverted mask */
      init = right(init,2,'0')                           /* 2 hex digits */
                                                         /* handle 0 bits: */
      CfgMod  = substr(CfgZero, 2 * Offset + 1, 2)       /* 2 hex digits to modify (partly) */
      CfgMod  = C2X(bitand(X2C(CfgMod),X2C(maskinv)))    /* zero out mask bits */
      CfgMod  = C2X(bitor(X2C(CfgMod),X2C(init)))        /* change word */
      CfgZero = overlay(CfgMod, CfgZero, 2 * Offset + 1) /* replace word in string */
                                                         /* handle 1 bits: */
      CfgMod  = substr(CfgOne, 2 * Offset + 1, 2)        /* 2 hex digits to modify */
      CfgMod  = C2X(bitand(X2C(CfgMod),X2C(maskinv)))    /* zero init bits */
      CfgMod  = C2X(bitor(X2C(CfgMod),X2C(init)))        /* change word */
      CfgOne  = overlay(CfgMod, CfgOne, 2 * Offset + 1)  /* replace word in string */
    end
    iterate
  end

  /* Build array of implemented config bits                    */
  /* Active bits will be represented by 1 in this mask         */
  /* Note: Array will be modified for fixed-zero and fixed-one */
  /*       bits before returning to caller                     */
  parse var ln 'SETTING (REQ=0X'BitMask 'VALUE' x2 .
  if BitMask \= '' then do
    BitMask = strip(BitMask)
    if Core \= '16' then do                              /* baseline, (extended) midrange */
      BitMask = right(BitMask,4,'0')                     /* 4 hex digits */
      CfgMod = substr(CfgAct, 4 * Offset + 1, 4)         /* word to modify */
      CfgMod = C2X(bitor(X2C(CfgMod), X2C(BitMask)))     /* or the bit(s) */
      CfgAct = overlay(CfgMod, CfgAct, 4 * Offset + 1)   /* replace word */
    end
    else do                                              /* 18F */
      BitMask = right(BitMask,2,'0')                     /* 2 hex digits */
      CfgMod = substr(CfgAct, 2 * Offset + 1, 2)         /* byte to modify */
      CfgMod = C2X(bitor(X2C(CfgMod),X2C(BitMask)))      /* or the bits */
      CfgAct = overlay(CfgMod, CfgAct, 2 * Offset + 1)   /* replace byte */
    end
  end

end

CfgAct = C2X(BITOR(X2C(CfgAct),X2C(CfgOne)))             /* set fixed one bits */
CfgAct = C2X(BITAND(X2C(CfgAct),X2C(CfgZero)))           /* reset fixed zero bits */

return CfgAct                                            /* array with default settings */


/* ---------------------------------------------------------------------------- */
/* Procedure to calculate offset in array of cfg words of baseline and midrange */
/* Returns (decimal) offset of config memory of the specific PIC (type).        */
/* Note: will be word-offset for baseline/midrange, byte-offset for 18F         */
/* ---------------------------------------------------------------------------- */
cfgmem_offset: procedure expose CfgAddr. msglevel
parse arg Addr .
AddrDec = X2D(Addr)                                /* decimal value */
n = CfgAddr.0                                      /* index of last cfg address */
if AddrDec >= CfgAddr.1  &  AddrDec <= CfgAddr.n then  /* within range */
   return AddrDec - CfgAddr.1                      /* offset from first word/byte */
else
   call msg 2, 'Configuration byte/word' Addr 'not within address range' CfgAddr.1 '-' CfgAddr.n
return 0


/* ---------------------------------------------------- */
/* procedure to list special function registers         */
/* input:  - nothing                                    */
/* Note: - name is stored but not checked on duplicates */
/* 12-bit and 14-bit core                               */
/* ---------------------------------------------------- */
list_sfr1x: procedure expose Dev. Ram. Name. PinMap. PinANMap. Core PicName,
                             adcs_bitcount jalfile BankSize HasLATReg NumBanks,
                             PinmapMissCount msglevel
PortLat. = 0                                                /* no pins at all */
do i = 1 to Dev.0
   if word(Dev.i,1) \= 'SFR' then                           /* skip non SFRs */
      iterate
   parse var Dev.i  val0 '(KEY=' val1 ' ADDR' '=' '0X' val2 'SIZE' '=' val3 .
   if val1 \= '' then do
      reg = strip(val1)                                     /* register name */
      Name.reg = reg                                        /* add to collection of names */
      addr = X2D(strip(val2))                               /* decimal */
      Ram.addr = addr                                       /* mark address in use */
      addr = sfr_mirror(addr)                               /* add mirror addresses */
      size = strip(val3)                                    /* field size */
      if size = 1 then                                      /* one byte */
         field = 'byte  '
      else if size = 2 then                                 /* two bytes */
         field = 'word  '
      else if size = 3 then                                 /* three bytes */
         field = 'byte*3'
      else                                                  /* otherwise 4 bytes assumed */
         field = 'dword '

      call lineout jalfile, '-- ------------------------------------------------'

      if \(left(reg,4) = 'PORT'  |,
                reg    = 'GPIO') then                       /* not PORTx or GPIO */
         call list_variable field, reg, addr

      select                                                /* possibly additional declarations  */
         when left(reg,3) = 'LAT' then do                   /* LATx register (10F3xx, 12xx752) */
            call list_port16_shadow reg                     /* force use of LATx (core 16 like) */
                                                            /* for output to PORTx */
         end
         when left(reg,4) = 'PORT' then do                  /* port */
            if HasLATReg = 0 then do                        /* PIC without LAT registers */
               call list_variable field, '_'reg,  addr
               call list_port1x_shadow reg
            end
            else do                                         /* PIC with LAT registers */
               call list_variable field, reg, addr
               PortLetter = right(reg,1)
               PortLat.PortLetter. = 0                      /* init: zero pins in PORTx */
                                                            /* updated in list_sfr_subfields1x */
            end
         end
         when reg = 'GPIO' then do                          /* port */
            call list_variable field, '_'reg, addr
            call list_alias '_'PORTA, '_'reg
            call list_port1x_shadow 'PORTA'                 /* GPIO -> PORTA */
         end
         when reg = 'TRISIO' then do                        /* low pincount PIC */
            call list_alias  'TRISA', reg
            call list_alias  'PORTA_direction', reg
            call list_tris_nibbles 'TRISA'                  /* nibble direction */
         end
         when reg = 'SPBRG' & size = 1 then do              /* 8-bits wide */
            if Name.SPBRGL = '-' then                       /* SPBRGL not defined yet */
               call list_alias 'SPBRGL', reg                /* add alias */
         end
         when left(reg,4) = 'TRIS' then do                  /* TRISx */
            call list_alias 'PORT'substr(reg,5)'_direction', reg
            call list_tris_nibbles reg                      /* nibble direction */
         end
      otherwise
         nop                                                /* others can be ignored */
      end

      call list_sfr_subfields1x i, reg                      /* bit fields */

      if (reg = 'FSR'    |,
          reg = 'INDF'   |,
          reg = 'PCL'    |,
          reg = 'PCLATH' |,
          reg = 'STATUS')  then do
         if reg = 'INDF' then
            reg = 'IND'                                     /* compiler wants '_ind' */
         reg = tolower(reg)                                 /* to lower case */
         call list_variable 'byte', '_'reg, addr
         if reg = 'status' then                             /* status register */
            call list_status i                              /* extra for compiler */
      end

      call multi_module_register_alias i, reg               /* even though there are no  */
                                                            /* multiple modules, register */
                                                            /* aliases may have to be added */
   end
end
return 0


/* ------------------------------------------------- */
/* Formatting of special function register subfields */
/* input:  - index in .dev                           */
/*         - register name                           */
/* Generates names for pins or bit fields            */
/* 8-bits subfields are ignored (register aliases)   */
/* 12-bit and 14-bit core                            */
/* Note: part of code relies on:                     */
/*       - ADCON0 comes before ADCON1 (in .dev file) */
/* ------------------------------------------------- */
list_sfr_subfields1x: procedure expose Dev. Name. PinMap. PinANMap. PortLat. ,
                                adcs_bitcount Core PicName jalfile,
                                HasLATReg PinmapMissCount msglevel
parse arg i, reg .
PicNameCaps = SysMapCase(PicName)                           /* for alias handling */
do 8 until (word(Dev.i,1) = 'SFR' | word(Dev.i,1) = 'NMMR')  /* max 8 until next register */
   parse var Dev.i 'BIT' val0 'NAMES' '=' val1 'WIDTH' '=' val2 ')' .
   if val1 \= ''   &,                                       /* found */
      pos('SCL', val0) = 0  then do                         /* not 'scl' */
      names = strip(strip(val1), 'B', "'")                  /* strip blanks */
      sizes = strip(strip(val2), 'B', "'")                  /* and quotes */
      n. = '-'                                              /* reset */
      parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
      parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
      offset = 7                                            /* MSbit first */
      do j = 1 to 8 while offset >= 0                       /* max 8 bits */
         if n.j = '-' then do                               /* bit not used */
            if left(reg,3) = 'LAT' then do                  /* LATx register */
               PortLetter = right(reg,1)
               PinNumber  = right(n.j,1)
               pin = 'pin_'PortLat.PortLetter.offset
               if PortLat.PortLetter.offset \= 0 then do    /* pin present in PORTx */
                  call list_bitfield 1, pin, 'PORT'portletter, offset
                  call list_pin_alias 'PORT'portletter, 'R'PortLat.PortLetter.offset, pin
                  call lineout jalfile, '--'
               end
            end
         end
         else if s.j = 1 then do                            /* single bit */
            if (pos('/', n.j) > 0 | pos('_', n.j) > 0)  &,  /* check for twin name */
                left(n.j,4) \= 'PRI_' then do               /* exception */
               if pos('/', n.j) > 0 then                    /* splitted with '/' */
                  parse var n.j val1'/'val2 .
               else                                         /* splitted with '_' */
                  parse var n.j val1'_'val2 .
               if val1 \= '' then do                        /* present */
                  field = reg'_'val1                        /* new name */
                  call list_bitfield 1, field, reg, offset
               end
               if val2 \= '' & val2 \= 'SHAD' then do
                  field = reg'_'val2
                  call list_bitfield 1, field, reg, offset
               end
            end
            else do                                         /* not twin name */
               field = reg'_'n.j
               next_j = j + 1                               /* next subfield index */
               next_subfield = n.next_j                     /* next subfield name */
               select                                       /* interceptions */
                  when left(reg,5) = 'ADCON' &,             /* ADCON0/1 */
                       (n.j = 'ADCS0' | n.j = 'ADCS1' |,    /* enumerated ADCS bits */
                         (n.j = 'ADCS2' & next_subfield = 'ADCS1')) then do
                     nop                                    /* suppress ADCON_ADCS enumeration */
                                                            /* but not a 'loose' ADCS2 */
                  end
                  when left(reg,5) = 'ANSEL'  &  left(n.j,3) = 'ANS' then do
                     call list_bitfield 1, reg'_'n.j, reg, offset
                     ansx = ansel2j(reg, n.j)
                     if ansx < 99 then                      /* valid number */
                        call list_alias 'JANSEL_ANS'ansx, field
                  end
                  when pos('CCP',reg) > 0  & right(reg,3) = 'CON'  &,   /* [E]CCPxCON */
                       left(n.j,3) = 'CCP'                         &,
                       (right(n.j,1) = 'X' | right(n.j,1) = 'Y') then do   /* CCP.X/Y */
                     nop                                    /* suppress */
                  end
                  when (reg = 'GPIO' & left(n.j,4) = 'GPIO') then do
                     field = reg'_GP'right(n.j,1)            /* pin GPIOx -> GPx */
                     call list_bitfield 1, field, '_'reg, offset
                  end
                  when (reg = 'OSCCON' & left(n.j,4) = 'IRCF') then do
                    nop                                     /* suppress enumerated IRCF */
                  end
                  when (left(reg,4) = 'PORT' | reg = 'GPIO') &,    /* exceptions for PORTx or GPIO */
                        HasLATReg = 0 then do                      /* PIC without LAT registers */
                     call list_bitfield 1, field, '_'reg, offset
                  end
                  when (reg = 'T1CON' & n.j = 'T1SYNC') then do
                     field = reg'_N'n.j                     /* insert 'not' prefix */
                     call list_bitfield 1, field, reg, offset
                  end
               otherwise
                  call list_bitfield 1, field, reg, offset
               end

                                                            /* additional declarations */
               select
                  when reg = 'ADCON1'  &,                   /* ADCON1 */
                      (n.j = 'ADCS2' & next_subfield \= ADCS1)  then do    /* scattered ADCS bits */
                     call lineout jalfile, 'var  byte  ADCON0_ADCS'
                     call lineout jalfile, 'procedure  ADCON0_ADCS'"'put"'(byte in x) is'
                     call lineout jalfile, '   pragma inline'
                     call lineout jalfile, '   ADCON0_ADCS10 = (x & 0x03)      -- low order bits'
                     call lineout jalfile, '   ADCON1_ADCS2  = (x & 0x04)      -- high order bit'
                     call lineout jalfile, 'end procedure'
                     adcs_bitcount = 3                      /* ADCS is 3 bits wide */
                  end
                  when left(reg,5) = 'ADCON'  &,            /* ADCON0/1 */
                       n.j = 'ADCS0'  then do               /* enumerated ADCS */
                     field = reg'_ADCS'
                     call list_bitfield 3, field, reg, offset
                     adcs_bitcount = 3                      /* ADCS is 3 bits wide */
                  end
                  when left(reg,5) = 'ADCON'  &,            /* ADCON0/1 */
                       n.j = 'CHS3'  then do                /* 'loose' 4th bit */
                     chkname = reg'_CHS210'                 /* compose name */
                     if  Name.chkname = '-' then            /* partner field not present */
                        call msg 2, 'ADCONx_CHS3 bit without previous',
                               ' ADCONx_CHS210 field declaration'
                     else do
                        call lineout jalfile, 'procedure' reg'_CHS'"'put"'(byte in x) is'
                        call lineout jalfile, '   pragma inline'
                        call lineout jalfile, '   'reg'_CHS210 = (x & 0x07)   -- low order bits'
                        call lineout jalfile, '   'reg'_CHS3 = 0              -- reset'
                        call lineout jalfile, '   if ((x & 0x08) != 0) then'
                        call lineout jalfile, '      'reg'_CHS3 = 1           -- high order bit'
                        call lineout jalfile, '   end if'
                        call lineout jalfile, 'end procedure'
                     end
                  end
                  when left(reg,5) = 'ADCON'  &,            /* ADCON0/1 */
                       pos('VCFG',field) > 0  then do       /* VCFG field */
                     p = j - 1                              /* previous bit */
                     if right(n.j,5) = 'VCFG0' & right(n.p,5) = 'VCFG1' then
                        call list_bitfield 2, left(field,length(field)-1), reg, offset
                  end
                  when pos('CCP',reg) > 0  &  right(reg,3) = 'CON' &,   /* [E]CCPxCON */
                     ((left(n.j,3) = 'CCP' &  right(n.j,1) = 'Y') |,    /* CCPxY */
                      (left(n.j,2) = 'DC' &  right(n.j,2) = 'B0')) then do /* DCxB0 */
                     if left(n.j,2) = 'DC' then
                        field = reg'_DC'substr(n.j,3,1)'B'
                     else
                        field = reg'_DC'substr(n.j,4,1)'B'
                     call list_bitfield 2, field, reg, (offset - s.j + 1)
                  end
                  when reg = 'GPIO' then do
                     if left(n.j,2) = 'GP' then do                /* I/O pin */
                        if HasLATReg = 0 then do                  /* PIC without LAT registers */
                           shadow = '_PORTA_shadow'
                           pin = 'pin_A'right(n.j,1)
                           call list_bitfield 1, pin, '_'reg, offset
                           call list_pin_alias 'PORTA', 'RA'right(n.j,1), pin
                           call lineout jalfile, '--'
                           call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                            'at' shadow ':' offset') is'
                           call lineout jalfile, '   pragma inline'
                           call lineout jalfile, '   _PORTA =' shadow
                           call lineout jalfile, 'end procedure'
                           call lineout jalfile, '--'
                        end
                        else do                                   /* PIC with LAT registers */
                           PortLetter = right(reg,1)
                           PortLat.PortLetter.offset = PortLetter||offset
                        end
                     end
                  end
                  when reg = 'INTCON' then do
                     if left(n.j,2) = 'T0' then
                        call list_bitfield 1, reg'_TMR0'substr(n.j,3), reg, offset
                  end
                  when reg = 'OPTION_REG' &,
                       (n.j = 'T0CS' | n.j = 'T0SE' | n.j = 'PSA') then do
                     call list_alias 'T0CON_'n.j, reg'_'n.j
                  end
                  when reg = 'OSCCON' then do                     /* enumerated -> bit*3 */
                     if  n.j = 'IRCF0' then
                        call list_bitfield 3, reg'_IRCF', reg, offset
                  end
                  when left(reg,3) = 'LAT' then do                /* LATx (10F3xx, 12f752) */
                     PortLetter = right(reg,1)
                     PinNumber  = right(n.j,1)
                     pin = 'pin_'PortLat.PortLetter.offset
                     if PortLat.PortLetter.offset \= 0 then do    /* pin present in PORTx */
                        call list_bitfield 1, pin, 'PORT'PortLetter, offset
                        call list_pin_alias 'PORT'portletter, 'R'PortLat.PortLetter.offset, pin
                        call lineout jalfile, '--'
                     end
                     if left(right(n.j,2),1) = PortLetter  &,        /* port letter */
                        datatype(PinNumber) = 'NUM'        then do   /* pin number */
                        call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                   'at' reg ':' offset') is'
                        call lineout jalfile, '   pragma inline'
                        call lineout jalfile, 'end procedure'
                        call lineout jalfile, '--'
                     end
                  end
                  when left(reg,4) = 'PORT' then do
                     if left(n.j,1) = 'R'  &,
                        left(right(n.j,2),1) = right(reg,1) then do  /* prob. I/O pin */
                        if HasLATReg = 0 then do                     /* PIC without LAT registers */
                           shadow = '_PORT'right(reg,1)'_shadow'
                           pin = 'pin_'right(n.j,2)
                           call list_bitfield 1, pin, '_'reg, offset
                           call list_pin_alias reg, 'R'right(n.j,2), pin
                           call lineout jalfile, '--'
                           call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                          'at' shadow ':' offset') is'
                           call lineout jalfile, '   pragma inline'
                           call lineout jalfile, '   _PORT'substr(reg,5) '=' shadow
                           call lineout jalfile, 'end procedure'
                           call lineout jalfile, '--'
                        end
                        else do                                /* PIC with LAT registers */
                           PortLetter = right(reg,1)
                           PortLat.PortLetter.offset = PortLetter||offset
                        end
                     end
                  end
                  when reg = 'TRISIO' then do
                     pin = 'pin_A'substr(n.j,7)'_direction'
                     call list_alias pin, reg'_'n.j
                     call list_pin_direction_alias 'TRISA', 'RA'substr(n.j,7), pin
                     call lineout jalfile, '--'
                  end
                  when left(reg,4) = 'TRIS'  &,
                       left(n.j,4) = 'TRIS'  then do
                     pin = 'pin_'substr(n.j,5)'_direction'
                     call list_alias 'pin_'substr(n.j,5)'_direction', reg'_'n.j
                     if substr(n.j,5,1) = right(reg,1) then do    /* prob. I/O pin */
                       call list_pin_direction_alias reg, 'R'substr(n.j,5), pin
                     end
                     call lineout jalfile, '--'
                  end
               otherwise                                    /* other regs */
                  nop                                       /* can be ignored */
               end
            end
         end
         else if s.j < 8               |,                   /* multi-bit, not full register */
                 left(reg,5) = 'ANSEL' then do              /* or specific registers */
            field = reg'_'n.j
            if field = 'OSCCON_IOSCF' then                  /* .dev error */
               field = 'OSCCON_IRCF'                        /* datasheet name */
            if field = 'OSCCON_IRFC' then                   /* .dev error */
               field = 'OSCCON_IRCF'                        /* datasheet name */
            select
               when reg = 'ADCON0'               &,         /* ADCON0 */
                    (n.j = 'ADCS'  &  s.j = '2') &,         /* 2-bits ADCS field */
                  \(PicName = '12f510'    |,
                    PicName = '16f506'    |,
                    PicName = '16f526'    |,
                    PicName = '16f716'    |,
                    PicName = '16f72'     |,
                    PicName = '16f73'     |,
                    PicName = '16f74'     |,
                    PicName = '16f76'     |,
                    PicName = '16f77'     |,                /* not a PIC with */
                    PicName = '16f870'    |,                /* only 2 ADCS bits */
                    PicName = '16f871'    |,
                    PicName = '16f872'    |,
                    PicName = '16f873'    |,
                    PicName = '16f874'    |,
                    PicName = '16f876'    |,
                    PicName = '16f877'    |,
                    PicName = '16f882'    |,
                    PicName = '16f883'    |,
                    PicName = '16f884'    |,
                    PicName = '16f886'    |,
                    PicName = '16f887')  then do
                  field = reg'_ADCS10'                      /* bits 1 and 0; bit 2 elsewhere! */
                  call list_bitfield s.j, field, reg, (offset - s.j + 1)
               end
               when left(reg,5) = 'ADCON'  &,               /* ADCON0/1 */
                    n.j = 'CHS'            &,               /* (multibit) CHS field */
                    pos('CHS3',Dev.i) > 0  then do          /* 'loose' 4th bit present */
                  field = field'210'                        /* rename! */
                  call list_bitfield s.j, field, reg, (offset - s.j + 1)
               end
               when left(reg,5) = 'ADCON' &,                /* ADCONx */
                    pos('VCFG',field) > 0  then do          /* multibit VCFG present */
                  call list_bitfield 1, field'1', reg, offset
                  call list_bitfield 1, field'0', reg, (offset - 1)
                  call list_bitfield s.j, field, reg, (offset - s.j + 1)
               end
               when (left(n.j,2) = 'AN')    &,              /* AN(S) subfield and */
                    (left(reg,5) = 'ADCON'  |,              /* ADCONx reg */
                     left(reg,5) = 'ANSEL')  then do        /* or ANSELx reg */
                  do k = s.j - 1 to 0 by -1                 /* enumerate */
                     call list_bitfield 1, reg'_'n.j||k, reg, (offset + k + 1 - s.j)
                     ansx = ansel2j(reg, n.j||k)
                     if ansx < 99 then
                        call list_alias 'JANSEL_ANS'ansx, field||k
                  end
               end
               when reg = 'OPTION_REG' &  n.j = 'PS' then do
                  call list_bitfield s.j, field, reg, (offset - s.j + 1)
                  call list_alias  'T0CON_T0'n.j, field
               end
            otherwise                                       /* other */
               call list_bitfield s.j, field, reg, (offset - s.j + 1)
               if  left(n.j,4) = ADCS  &,
                  (left(reg,5) = 'ADCON' | left(reg,5) = 'ANSEL') then do
                  adcs_bitcount = s.j                       /* variable # ADCS bits */
               end
            end
         end

         call multi_module_bitfield_alias reg, n.j          /* possibly extra aliases */

         offset = offset - s.j

      end
      leave                                                 /* only 1 bit line to process */
   end
   i = i + 1                                                /* next record */
end
return 0


/* ---------------------------------------------------- */
/* procedure to list special function registers         */
/* input:  - nothing                                    */
/* Note: - register names are not checked on duplicates */
/*       - bits of PORTx are expanded with LATx,        */
/*         dependency: PORTx comes before LATx in .dev  */
/*       - when RE3 is the only active bit of PORTE     */
/*         it is declared with PORTE, not LATE          */
/* Extended 14-bit core                                 */
/* ---------------------------------------------------- */
list_sfr14h: procedure expose Dev. Ram. Name. PinMap. PinANMap. Core PicName,
                              adcs_bitcount jalfile BankSize NumBanks,
                              PinmapMissCount msglevel
PortLat. = 0                                                /* no pins at all */
do i = 1 to Dev.0
   if word(Dev.i,1) \= 'SFR' then                           /* skip non SFRs */
      iterate
   parse var Dev.i  val0 '(KEY=' val1 ' ADDR' '=' '0X' val2 'SIZE' '=' val3 access
   if val1 \= '' then do
      reg = strip(val1)                                     /* register name */
      Name.reg = reg                                        /* add to collection of names */
      addr = X2D(strip(val2))                               /* decimal */
      Ram.addr = addr                                       /* mark address in use */
      size = strip(val3)                                    /* field size */
      if size = 1 then                                      /* one byte */
         field = 'byte  '
      else if size = 2 then                                 /* two bytes */
         field = 'word  '
      else if size = 3 then                                 /* three bytes */
         field = 'byte*3'
      else                                                  /* otherwise four bytes assumed */
         field = 'dword '

      call lineout jalfile, '-- ------------------------------------------------'
      call list_variable field, reg, addr

      select
         when left(reg,4) = 'PORT' then do                  /* port */
            PortLetter = right(reg,1)
            PortLat.PortLetter. = 0                         /* init: zero pins in PORTx */
                                                            /* updated in list_sfr_subfields14h */
         end
         when left(reg,3) = 'LAT' then do                   /* LATx register */
            call list_port16_shadow reg                     /* force use of LATx (core 16 like) */
                                                            /* for output to PORTx */
         end
         when left(reg,4) = 'TRIS' then do                  /* TRISx */
            call list_alias 'PORT'substr(reg,5)'_direction', reg
            call list_tris_nibbles reg                      /* nibble direction */
         end
         when reg = 'SPBRG' & size = 1 then do              /* 8-bits wide */
            if Name.SPBRGL = '-' then                       /* SPBRGL not defined yet */
               call list_alias 'SPBRGL', reg                /* add alias */
         end
      otherwise                                             /* others */
         nop                                                /* can be ignored */
      end

      call list_sfr_subfields14h i, reg, addr               /* bit fields */

      if (reg = 'BSR'    |,
          reg = 'FSR0L'  |,
          reg = 'FSR0H'  |,
          reg = 'FSR1L'  |,
          reg = 'FSR1H'  |,
          reg = 'INDF0'  |,
          reg = 'PCL'    |,
          reg = 'PCLATH' |,
          reg = 'STATUS') then do
         if reg = 'INDF0' then
            reg = 'IND'                                     /* compiler wants '_ind' */
         reg = tolower(reg)                                 /* to lower case */
         call list_variable 'byte', '_'reg, addr
         if reg = 'status' then                             /* status register */
            call list_status i                              /* extra for compiler */
      end

      else if reg = 'PORTE' then do                         /* esp. for  pin_E3 */
         parse var access 'ACCESS' '=' "'" a7 a6 a5 a4 a3 a2 a1 a0 "'" ')' .
         if a7='U' & a6='U' & a5='U' & a4='U' & a3\='U' & a2='U' & a1='U' & a0='U' then do
            pin = 'pin_E3'
  /*        call msg 1, pin 'is declared under' reg     */
            call list_bitfield 1, pin, reg, 3, addr
            call list_pin_alias reg, 'RE3', pin
         end
      end

      call multi_module_register_alias i, reg               /* add aliases if applicable */

   end

end

return 0


/* ------------------------------------------------- */
/* Formatting of special function register subfields */
/* input:  - index in .dev                           */
/*         - register name                           */
/*         - address (decimal)                       */
/* Generates names for pins or bit fields            */
/* 8-bits subfields are ignored (register aliases)   */
/* Extended 14-bit core                              */
/* ------------------------------------------------- */
list_sfr_subfields14h: procedure expose Dev. Name. PinMap. PinANMap. PortLat. ,
                       adcs_bitcount Core PicName jalfile PinmapMissCount msglevel
parse arg i, reg, addr .
PicNameCaps = SysMapCase(PicName)                           /* for alias handling */
do 8 until (word(Dev.i,1) = 'SFR' | word(Dev.i,1) = 'NMMR')  /* max 8, until next register */
   parse var Dev.i 'BIT' val0 'NAMES' '=' val1 'WIDTH' '=' val2 ')' .
   if val1 \= ''  &  pos('SCL', val0) = 0  then do          /* found, not 'scl' */
      names = strip(strip(val1), 'B', "'")                  /* strip blanks */
      sizes = strip(strip(val2), 'B', "'")                  /* and quotes */
      n. = '-'                                              /* reset */
      parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
      parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
      offset = 7                                            /* MSbit first */
      do j = 1 to 8 while offset >= 0                       /* max 8 bits */

         if n.j = '-'  then do                              /* bit not used */
            if left(reg,3) = 'LAT' then do                  /* LATx register */
               PortLetter = right(reg,1)
               PinNumber  = right(n.j,1)
               pin = 'pin_'PortLat.PortLetter.offset
               if PortLat.PortLetter.offset \= 0 then do    /* pin present in PORTx */
                  call list_bitfield 1, pin, 'PORT'portletter, offset, addr
                  call list_pin_alias 'PORT'portletter, 'R'PortLat.PortLetter.offset, pin
                  call lineout jalfile, '--'
               end
            end
         end

         else if s.j = 1 then do                            /* single bit */
            if (pos('/', n.j) > 0 | pos('_', n.j) > 0)  &,  /* check for twin name */
                left(n.j,4) \= 'PRI_'                   &,  /* exception */
                reg \= 'ICDIO' then do                      /* exception */
               if pos('/', n.j) > 0 then                    /* splitted with '/' */
                 parse var n.j val1'/'val2 .
               else                                         /* splitted with '_' */
                 parse var n.j val1'_'val2 .
               if val1 \= '' then do                        /* present */
                  field = reg'_'val1                        /* new name */
                  call list_bitfield 1, field, reg, offset, addr
               end
               if val2 \= '' & val2 \= 'SHAD' then do
                  field = reg'_'val2
                  call list_bitfield 1, field, reg, offset, addr
               end
            end
            else do                                         /* not twin name */
               field = reg'_'n.j
               select                                       /* intercept */
                  when (left(reg,5) = 'ADCON'   & left(n.j,3) = 'CHS')                       |,
                       (left(reg,5) = 'ADCON'   & left(n.j,4) = 'ADCS')                      |,
                       (left(reg,6) = 'SSPCON'  & left(n.j,4) = 'SSPM')                      |,
                       (left(reg,7) = 'SSP1CON' & left(n.j,4) = 'SSPM')                      |,
                       (left(reg,7) = 'SSP2CON' & left(n.j,4) = 'SSPM')                      |,
                       (reg = 'OPTION_REG'      & (n.j = 'PS0' | n.j = 'PS1' | n.j = 'PS2')) |,
                       (reg = 'T1CON'           & (n.j = 'TMR1CS1' | n.j = 'TMR1CS0'))       |,
                       (reg = 'OSCCON'          & left(n.j,4) = 'IRCF')                      |,
                       (reg = 'OSCCON'          & left(n.j,3) = 'SCS')                       |,
                       (reg = 'OSCTUNE'         & left(n.j,3) = 'TUN')                       |,
                       (reg = 'WDTCON'          & left(n.j,5) = 'WDTPS')            then do
                     nop                                    /* suppress enumerated bitfields  */
                  end
                  when left(reg,3) = 'CCP'  &  right(reg,3) = 'CON'  &, /* CCPxCON */
                       datatype(substr(reg,4,1)) = 'NUM'        then do
                     nop                                    /* suppress enumerated bitfields */
                  end
                  when left(reg,1) = 'T'  &  right(reg,3) = 'CON'  &, /* TxCON */
                       datatype(substr(reg,2,1)) = 'NUM'           &,
                       (substr(n.j,3,5) = 'OUTPS' | substr(n.j,3,4) = 'CKPS')   then do
                     nop                                    /* suppress enumerated bitfields */
                  end
                  when left(reg,5) = 'ANSEL'  &  left(n.j,3) = 'ANS' then do
                     call list_bitfield 1, reg'_'n.j, reg, offset, addr
                     ansx = ansel2j(reg, n.j)
                     if ansx < 99 then
                        call list_alias 'JANSEL_ANS'ansx, field
                  end
                  when n.j \= '-' then do                   /* bit present */
                     call list_bitfield 1, field, reg, offset, addr
                     if left(reg,4) = 'PORT' then do
                        PortLetter = right(reg,1)
                        if left(n.j,2) = 'R'portletter  &,  /* probably pin */
                           right(n.j,1) = offset  then      /* matching pin number */
                           PortLat.PortLetter.offset = Portletter||offset
                     end
                  end
               otherwise
                  nop                                       /* can be ignored */
               end
                                                            /* additional declarations */
               select
                  when left(reg,5) = 'ADCON' &  n.j = 'CHS0' then do
                     call list_bitfield 5, reg'_CHS', reg, offset, addr
                  end
                  when left(reg,5) = 'ADCON' &  n.j = 'ADCS0' then do
                     call list_bitfield 3, reg'_ADCS', reg, offset, addr
                     adcs_bitcount = 3                      /* always 3 */
                  end
                  when pos('CCP',reg) > 0  &  right(reg,3) = 'CON' &, /* CCPxCON */
                       datatype(substr(reg,4,1)) = 'NUM'        then do
                     if left(n.j,2) = 'DC' & right(n.j,1) = '0' then
                        call list_bitfield 2, reg'_DC'substr(n.j,3,1)'B', reg , offset, addr
                     else if left(n.j,3) = 'CCP' & right(n.j,1) = '0' then
                        call list_bitfield 4, reg'_CCP'substr(n.j,4,1)'M', reg, offset, addr
                     else if left(n.j,1) = 'P' & right(n.j,1) = '0' then
                        call list_bitfield 2, reg'_P'substr(n.j,2,1)'M', reg, offset, addr
                  end
                  when reg = 'INTCON' then do
                     if left(n.j,2) = 'T0' then
                        call list_bitfield 1, reg'_TMR0'substr(n.j,3), reg, offset, addr
                  end
                  when left(reg,3) = 'LAT' then do          /* LATx register */
                     PortLetter = right(reg,1)
                     PinNumber  = right(n.j,1)
                     pin = 'pin_'PortLat.PortLetter.offset
                     if PortLat.PortLetter.offset \= 0 then do  /* pin present in PORTx */
                        call list_bitfield 1, pin, 'PORT'PortLetter, offset, addr
                        call list_pin_alias 'PORT'portletter, 'R'PortLat.PortLetter.offset, pin
                        call lineout jalfile, '--'
               /*    end   0.1.39  */
                        if left(right(n.j,2),1) = PortLetter  &,      /* port letter */
                           datatype(PinNumber) = 'NUM' then do   /* pin number */
                           call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                      'at' reg ':' offset') is'
                           call lineout jalfile, '   pragma inline'
                           call lineout jalfile, 'end procedure'
                           call lineout jalfile, '--'
                        end
                     end      /* 0.1.39 */
                  end
                  when reg = 'OPTION_REG' then do
                     if n.j = 'PS0' then do
                        call list_bitfield 3, reg'_PS', reg, offset, addr
                        call list_alias 'T0CON_T0'PS, reg'_PS'
                     end
                     else if n.j = 'TMR0CS'  |  n.j = 'TMR0SE' then
                        call list_alias 'T0CON_'delstr(n.j,2,2), reg'_'n.j
                     else if n.j = 'PSA' then
                        call list_alias 'T0CON_'n.j, reg'_'n.j
                  end
                  when reg = 'OSCCON'  &  n.j = 'IRCF0' then do
                     call list_bitfield 4, reg'_IRCF', reg, offset, addr
                  end
                  when reg = 'OSCCON'  &  n.j = 'SCS0' then do
                     call list_bitfield 2, reg'_SCS', reg, offset, addr
                  end
                  when reg = 'OSCTUNE'  &  n.j = 'TUN0' then do
                     call list_bitfield 6, reg'_TUN', reg, offset, addr
                  end
                  when (left(reg,6) = 'SSPCON'  & n.j = 'SSPM0') |,
                       (left(reg,7) = 'SSP1CON' & n.j = 'SSPM0') |,
                       (left(reg,7) = 'SSP2CON' & n.j = 'SSPM0') then do
                       call list_bitfield 4, reg'_SSPM', reg, offset, addr
                  end
                  when reg = 'T1CON' & n.j = 'TMR1CS0' then do
                     call list_bitfield 2, reg'_TMR1CS', reg, offset, addr
                  end
                  when left(reg,1) = 'T'  &  right(reg,3) = 'CON'  &,  /* TxCON */
                       datatype(substr(reg,2,1)) = 'NUM'           &,
                       (substr(n.j,3,6) = 'OUTPS0' | substr(n.j,3,5) = 'CKPS0')   then do
                     if substr(n.j,3,5) == 'OUTPS' then
                        call list_bitfield 4, reg'_'left(n.j,7), reg, offset, addr
                     else
                        call list_bitfield 2, reg'_'left(n.j,6), reg, offset, addr
                  end
                  when left(reg,4) = 'TRIS'  &,
                       left(n.j,4) = 'TRIS'  then do
                     pin = 'pin_'substr(n.j,5)'_direction'
                     call list_alias 'pin_'substr(n.j,5)'_direction', field
                     if substr(n.j,5,1) = right(reg,1) then do       /* prob. I/O pin */
                        call list_pin_direction_alias reg, 'R'substr(n.j,5), pin
                     end
                     call lineout jalfile, '--'
                  end
                  when reg = 'WDTCON' &  n.j = 'WDTPS0' then do
                     call list_bitfield 5, reg'_WDTPS', reg, offset, addr
                  end
               otherwise                                    /* other regs */
                  nop                                       /* can be ignored */
               end
            end
         end

         else if s.j < 8 | reg = 'ANSEL' then do            /* multi-bit subfield */
            field = reg'_'n.j
            if n.j = 'ADPREF'  &  reg = 'ADCON1' then do
               do k = s.j - 1 to 0 by -1                    /* enumerate */
                  call list_bitfield 1, reg'_'n.j||k, reg, (offset + k + 1 - s.j), addr
               end
            end
            else if  left(n.j,4) = ADCS  &,
               (left(reg,5) = 'ADCON' | left(reg,5) = 'ANSEL') then do
               call list_bitfield s.j, field, reg, (offset - s.j + 1), addr
               adcs_bitcount = s.j                          /* variable # ADCS bits */
            end
            else if reg = 'OPTION_REG' &  n.j = 'PS' then do
               call list_bitfield s.j, field, reg, (offset - s.j + 1), addr
               call list_alias 'T0CON_T0'n.j, field         /* additional alias */
            end
            else
               call list_bitfield s.j, field, reg, (offset - s.j + 1), addr
         end

         call multi_module_bitfield_alias reg, n.j          /* possibly extra aliases */

         offset = offset - s.j

      end
      leave                                                 /* only 1 bit line to process */
   end
   i = i + 1                                                /* next record */
end

return 0


/* -----------------------------------------------------*/
/* procedure to list special function registers         */
/* input:  - nothing                                    */
/* Note: - register names are not checked on duplicates */
/*       - bits of PORTx are expanded with LATx,        */
/*         dependency: PORTx comes before LATx in .dev  */
/*       - when RE3 is the only active bit of PORTE     */
/*         it is declared with PORTE, not LATE          */
/*       - generates some midrange aliases              */
/* 16-bit core                                          */
/* -----------------------------------------------------*/
list_sfr16: procedure expose Dev. Ram. Name. PinMap. PinANMap. jalfile,
                             adcs_bitcount BankSize NumBanks,
                             Core PicName AccessBankSplitOffset PinmapMissCount msglevel
PortLat. = 0                                                /* no pins at all */
do i = 1 to Dev.0
   if word(Dev.i,1) \= 'SFR' then
      iterate
   parse var Dev.i  val0 '(KEY=' val1 ' ADDR' '=' '0X' val2 'SIZE' '=' val3 access
   if val1 \= '' then do
      reg = strip(val1)                                     /* register name */
      Name.reg = reg                                        /* remember name */
      addr = X2D(strip(val2))                               /* decimal */
      Ram.addr = addr                                       /* mark address in use */
      size = strip(val3)                                    /* # bytes */
      if size = 1 then                                      /* single byte */
         field = 'byte  '
      else if size = 2 then                                 /* two bytes */
         field = 'word  '
      else if size = 3 then                                 /* three bytes */
         field = 'byte*3'
      else                                                  /* otherwise dword assumed */
         field = 'dword '
      call lineout jalfile, '-- ------------------------------------------------'
      call list_variable field, reg, addr                   /* base declaration */

                                                            /* additional declarations */
      select
         when left(reg,4) = 'PORT' then do                  /* PORTx register */
            PortLetter = right(reg,1)
            PortLat.PortLetter. = 0                         /* init: no pins in PORTx */
                                                            /* updated in list_sfr_subfields16 */
         end
         when left(reg,3) = 'LAT' then do                   /* LATx register */
            call list_port16_shadow reg                     /* force use of LATx */
                                                            /* for output to PORTx */
         end
         when (reg = 'SPBRG' | reg = 'SP1BRG' | reg = 'SPBRG1') & size = 1 then do   /* 8 bits wide */
            if Name.SPBRGL = '-' then                       /* SPBRGL not defined yet */
               call list_alias 'SPBRGL', reg                /* add alias */
         end
         when (reg = 'SPBRG2' | reg = 'SP2BRG') & size = 1 then do   /* 8 bits wide */
            if Name.SPBRGL2 = '-' then                      /* SPBRGL2 not defined yet */
               call list_alias 'SPBRGL2', reg               /* add alias */
         end
         when left(reg,4) = 'TRIS' then do                  /* TRISx */
            call list_alias 'PORT'substr(reg,5)'_direction', reg
            call list_tris_nibbles reg                      /* nibble directions */
         end
         when left(reg,4) = 'ECCP'  &,                      /* enhanced CCP register */
             (right(reg,3) = 'CON' | left(reg,5) = 'ECCPR') then do /* declare legacy alias */
            if (PicName = '18f448'   |,
                PicName = '18f4480'  |,
                PicName = '18f458'   |,
                PicName = '18f4580'  |,
                PicName = '18f4585'  |,
                PicName = '18f4680'  |,
                PicName = '18f4682'  |,
                PicName = '18f4685')  then do
               if right(reg,3) = 'CON' then
                  alias = 'CCP2CON'                         /* rename to CCP2CON */
               else
                  alias = 'CCPR2'substr(reg,7)              /* rename to CCPR2.. */
            end
            else
               alias = substr(reg,2)                        /* simply strip 'E' prefix */
            call list_alias alias, reg
         end
      otherwise                                             /* others */
         nop                                                /* can be ignored */
      end

      call list_sfr_subfields16 i, reg, addr                /* expand bit fields */

      alias = ''                                            /* nul alias */

      if (reg = 'FSR0'   |,
          reg = 'FSR0L'  |,
          reg = 'FSR0H'  |,
          reg = 'INDF0'  |,
          reg = 'PCL'    |,
          reg = 'PCLATH' |,
          reg = 'PCLATU' |,
          reg = 'STATUS' |,             /* test */
          reg = 'TABLAT' |,
          reg = 'TBLPTR') then do
         if reg = 'INDF0' then
            reg = 'IND'                                  /* compiler wants '_ind' */
         reg = tolower(reg)                              /* to lower case */
         call list_variable field, '_'reg, addr
         if reg = 'status' then                             /* status register */
            call list_status i                              /* extra for compiler */
      end

      else if reg = 'PORTE' then do                         /* esp. for pin_E3 */
         parse var access 'ACCESS' '=' "'" a7 a6 a5 a4 a3 a2 a1 a0 "'" ')' .
         if a7='U' & a6='U' & a5='U' & a4='U' & a3\='U' & a2='U' & a1='U' & a0='U' then do
            pin = 'pin_E3'
  /*        call msg 1, pin 'is declared under' reg   */
            call list_bitfield 1, pin, reg, 3, addr
            call list_pin_alias reg, 'RE3', pin
         end
      end

      call multi_module_register_alias i, reg

   end

end
return 0


/* ----------------------------------------------- */
/* Formatting of special function register         */
/* input:  - index in .dev                         */
/*         - register name                         */
/*         - address of register                   */
/* Generates names for pins or bit fields          */
/* 8-bits subfields are ignored (register aliases) */
/* Normalises ANS bits                             */
/* Fixes some errors in MPLAB                      */
/* Core 16                                         */
/* Note: part of code relies on                    */
/*       ADCON0 comes after ADCON1 (in .dev file)  */
/* ----------------------------------------------- */
list_sfr_subfields16: procedure expose Dev. Name. PinMap. PinANMap. PortLat. Core PicName,
                                       AccessBankSplitOffset adcs_bitcount ,
                                       jalfile PinmapMissCount msglevel
parse arg i, reg, addr .
do 8 until (word(Dev.i,1) = 'SFR' | word(Dev.i,1) = 'NMMR')  /* max 8, until next register */
   parse var Dev.i 'BIT' val0 'NAMES=' val1 'WIDTH=' val2 ')' .
   if val1 \= ''  &,                                        /* found */
      pos('SCL', val0) = 0  &,                              /* not 'scl' */
      word(Dev.i,1) \= 'QBIT' then do                       /* not 'qbit' */
      names = strip(strip(val1), 'B', "'")                  /* strip blanks .. */
      sizes = strip(strip(val2), 'B', "'")                  /* .. and quotes */
      parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
      parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
      offset = 7                                            /* MSbit first */
      do j = 1 to 8 while offset >= 0                       /* 8 bits */
         if s.j = 1  & n.j \= '-'then do                    /* single active bit */
            if (pos('/', n.j) > 0 | pos('_', n.j) > 0)  &,   /* check for twin name */
                left(n.j,4) \= 'PRI_'     &,
                left(reg,7) \= 'RXFBCON'  &,                /* exceptions */
                left(reg,4) \= 'MSEL'     then do
               if pos('/', n.j) > 0 then                    /* splitted with '/' */
                 parse var n.j val1'/'val2 .
               else                                         /* splitted with '_' */
                 parse var n.j val1'_'val2 .
               if val1 \= '' then do
                  field = reg'_'val1
                  call list_bitfield 1, field, reg, offset, addr
               end
               if val2 \= '' & val2 \= 'SHAD' then do
                  field = reg'_'val2
                  call list_bitfield 1, field, reg, offset, addr
               end
            end
            else do                                         /* not twin name */
               field = reg'_'n.j
               select                                       /* interceptions */
                  when left(reg,5) = 'ADCON'  &,            /* ADCON0/1 */
                       pos('VCFG',field) > 0  then do       /* VCFG field */
                     call list_bitfield 1, field, reg, offset, addr
                     p = j - 1                              /* previous bit */
                     if right(n.j,5) = 'VCFG0' & right(n.p,5) = 'VCFG1' then
                        call list_bitfield 2, left(field,length(field)-1), reg, offset, addr
                  end
                  when left(reg,6) = 'CANCON'  &,                   /* CANCON */
                       left(n.j,5) = 'REQOP' then do        /* REQOP bit */
                     if n.j = 'REQOP0' then                 /* last enumerated bit */
                        call list_bitfield 3, left(field,length(field)-1), reg, offset, addr
                  end
                  when pos('CCP',reg) > 0  &  right(reg,3) = 'CON' &, /* [E]CCPxCON */
                      ((left(n.j,3) = 'CCP' &  right(n.j,1) = 'Y') |, /* CCPxY */
                       (left(n.j,2) = 'DC' &  right(n.j,2) = 'B0')) then do /* DCxB0 */
                     if left(n.j,2) = 'DC' then
                        field = reg'_DC'substr(n.j,3,1)'B'
                     else
                        field = reg'_DC'substr(n.j,4,1)'B'
                     call list_bitfield 2, field, reg, (offset - s.j + 1), addr
                  end
                  when (left(reg,5) = 'ANSEL' | left(reg,5) = 'ANCON')  &,
                       left(n.j,3) = 'ANS' then do
                     call list_bitfield 1, reg'_'n.j, reg, offset, addr
                     ansx = ansel2j(reg, n.j)
                     if ansx < 99 then
                        call list_alias 'JANSEL_ANS'ansx, field
                  end
                  when left(reg,3) = 'LAT'  &,
                       n.j \= '-' then do                   /* bit active */
                     PortLetter = right(reg,1)
                     if left(n.j,3) = 'LAT'  then do        /* bit represents a pin */
                        if PortLat.PortLetter.offset \= 0 then    /* pin present in PORTx */
                          call list_bitfield 1, field, reg, offset, addr
                     end
                     else do                                /* not a pin */
                       call list_bitfield 1, field, reg, offset, addr
                       call lineout jalfile, '--'
                     end
                  end
                  when (left(reg,6) = 'SSPCON'  & left(n.j,4) = 'SSPM')   |,
                       (left(reg,7) = 'SSP1CON' & left(n.j,4) = 'SSPM')   |,
                       (left(reg,7) = 'SSP2CON' & left(n.j,4) = 'SSPM')   then do
                     nop                                    /* suppress enumerated bitfield  */
                  end
                  when left(reg,1) = 'T' & right(reg,3) = 'CON'   &,       /* TxCON */
                       left(n.j,1) = 'T' & right(n.j,4) = 'SYNC' then do   /* TxSYNC */
                     call list_bitfield 1,  reg'_N'n.j, reg, offset, addr
                  end
                  when n.j \= '-' then do                   /* bit present */
                     call list_bitfield 1, field, reg, offset, addr
                     if left(reg,4) = 'PORT' then do
                        PortLetter = right(reg,1)
                        if left(n.j,2) = 'R'portletter  &,  /* probably pin */
                           substr(n.j,3) = offset  then     /* matching pin number */
                           PortLat.PortLetter.offset = Portletter||offset
                     end
                  end
               otherwise
                  nop                                       /* others can be ignored */
               end

               if field = 'WDTCON_ADSHR' then               /* NMMR mapping bit */
                  call lineout jalfile, field '= FALSE                ',
                                       '-- ensure default (legacy) SFR mapping'

                                                            /* additional declarations */
               select
                  when reg = 'INTCON' then do
                     if left(n.j,2) = 'T0' then
                        call list_bitfield 1, reg'_TMR0'substr(n.j,3), reg, offset, addr
                  end
                  when left(reg,3) = 'LAT' then do          /* LATx register */
                     PortLetter = right(reg,1)
                     PinNumber  = right(n.j,1)
                     pin = 'pin_'PortLat.PortLetter.offset
                     if PortLat.PortLetter.offset \= 0 then do   /* pin present in PORTx */
                        call list_bitfield 1, pin, 'PORT'PortLetter, offset, addr
                        call list_pin_alias 'PORT'portletter, 'R'PortLat.PortLetter.offset, pin
                        call lineout jalfile, '--'
                /*   end    0.1.39   */
                        if substr(n.j,4,1) = portletter  &,    /* port letter */
                           datatype(pinnumber) = 'NUM' then do /* pin number */
                           call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                      'at' reg ':' offset') is'
                           call lineout jalfile, '   pragma inline'
                           call lineout jalfile, 'end procedure'
                           call lineout jalfile, '--'
                        end
                     end           /* 0.1.39 */
                  end
                  when reg = 'OSCCON'  &  n.j = 'SCS0' then do
                     field = reg'_SCS'
                     call list_bitfield 2, field, reg, offset, addr
                  end
                  when (left(reg,6) = 'SSPCON'  & n.j = 'SSPM0') |,
                       (left(reg,7) = 'SSP1CON' & n.j = 'SSPM0') |,
                       (left(reg,7) = 'SSP2CON' & n.j = 'SSPM0') then do
                     call list_bitfield 4, reg'_SSPM', reg, offset, addr
                  end
                  when left(reg,4) = 'TRIS' then do         /* TRISx register */
                     portletter = right(reg,1)
                     pinnumber  = right(n.j,1)
                     if PortLat.PortLetter.offset \= 0 then do  /* pin present in PORTx */
                        pin = 'pin_'PortLat.PortLetter.offset'_direction'
                        if  left(n.j,4) = 'TRIS' then do    /* only 'TRIS' bits */
                           call list_alias pin, reg'_'n.j
                           call list_pin_direction_alias 'PORT'substr(reg,5),,
                                           'R'substr(n.j,5), pin
                           call lineout jalfile, '--'
                        end
                     end
                  end
               otherwise                                    /* others */
                  nop                                       /* no extras */
               end
            end
         end

         else if n.j = '-' then do                          /* bit not used (?) */
            if left(reg,3) = 'LAT' then do                  /* LATx register */
               PortLetter = right(reg,1)
               PinNumber  = right(n.j,1)
               pin = 'pin_'PortLat.PortLetter.offset
               if PortLat.PortLetter.offset \= 0 then do    /* pin present in PORTx */
                  call list_bitfield 1, pin, 'PORT'portletter, offset, addr
                  call list_pin_alias 'PORT'portletter, 'R'PortLat.PortLetter.offset, pin
                  call lineout jalfile, '--'
               end
            end
         end

         else if s.j < 8 | reg = 'ANSEL' then do            /* multi-bit subfield */
            field = reg'_'n.j
            select
               when left(reg,5) = 'ADCON'  &,               /* ADCON0/1 */
                    pos('VCFG',n.j) > 0  then do            /* VCFG field */
                  call list_bitfield 1, field'1', reg, (offset - 0), addr
                  call list_bitfield 1, field'0', reg, (offset - 1), addr
                  call list_bitfield s.j, field, reg, (offset - s.j + 1), addr
               end
               when reg = 'ADCON0'               &,         /* ADCON0 */
                    (n.j = 'ADCS' &  s.j = '2')  &,         /* 2 bits of ADCS */
                    (PicName = '18f242'   |,
                     PicName = '18f2439'  |,
                     PicName = '18f248'   |,                /* specific PICs of */
                     PicName = '18f252'   |,                /* which ADCS2 bit */
                     PicName = '18f2539'  |,                /* is in ADCON1 */
                     PicName = '18f258'   |,
                     PicName = '18f442'   |,
                     PicName = '18f4439'  |,
                     PicName = '18f448'   |,
                     PicName = '18f452'   |,
                     PicName = '18f4539'  |,
                     PicName = '18f458')  then do
                  call list_bitfield s.j, field'10', reg, (offset - s.j + 1), addr
                  call lineout jalfile, 'var  byte  ADCON0_ADCS'
                  call lineout jalfile, 'procedure  ADCON0_ADCS'"'put"'(byte in x) is'
                  call lineout jalfile, '   pragma inline'
                  call lineout jalfile, '   ADCON0_ADCS10 = x       -- low order bits'
                  call lineout jalfile, '   ADCON1_ADCS2 = (x & 0x04)'
                  call lineout jalfile, 'end procedure'
                  adcs_bitcount = 3                         /* can only be 3 */
               end
               when (left(n.j,3) = 'ANS')   &,              /* ANS subfield */
                    (left(reg,5) = 'ADCON'  |,              /* ADCON* reg */
                     left(reg,5) = 'ANSEL')    then do      /* ANSELx reg */
                  do k = s.j - 1 to 0 by -1                 /* enumerate */
                     call list_bitfield 1, reg'_'n.j||k, reg, (offset + k + 1 - s.j), addr
                     ansx = ansel2j(reg, n.j||k)
                     if ansx < 99 then
                        call list_alias 'JANSEL_ANS'ansx, field||k
                  end
               end
               when reg = 'T0CON'  &,                       /* T0CON register */
                    n.j = 'T0PS' & s.j = 4 then do          /* PSA and T0PS glued */
                  field = reg'_PSA'
                  call list_bitfield 1, field, reg, offset, addr
                  field = reg'_T0PS'
                  call list_bitfield 3, field, reg, 0, addr
               end
               when left(reg,1) = 'T' & right(reg,3) = 'CON' &, /* TxCON */
                    n.j = 'TOUTPS' then do                  /* unqualified name */
                  parse var reg 'T'tmrno'CON' .             /* extract TMR number */
                  field = reg'_T'tmrno'OUTPS'
                  call list_bitfield s.j, field, reg, (offset - s.j + 1), addr
               end
            otherwise                                       /* others */
               call list_bitfield s.j, field, reg, (offset - s.j + 1), addr
               if  left(n.j,4) = ADCS  &,
                  (left(reg,5) = 'ADCON' | left(reg,5) = 'ANSEL') then
                  adcs_bitcount = s.j                       /* variable (2 or 3) */
            end
         end
                                                            /* additional declarations */
         if left(reg,4) = 'ECCP'  &,                        /* enhanced CCP register */
            (right(reg,3) = 'CON' | left(reg,5) = 'ECCPR')  &, /* registers */
            (left(n.j,3) = 'EDC'  | left(n.j,4) = 'ECCP' |, /* specific .. */
             left(n.j,2) = 'DC'   | left(n.j,3) = 'CCP') then do /* .. fields */
            if PicName = '18f448'  | PicName = '18f4480' |,
                PicName = '18f458'  | PicName = '18f4580' | PicName = '18f4585' |,
                PicName = '18f4680' | PicName = '18f4682' | PicName = '18f4685' then do
               if right(reg,3) = 'CON' then
                  regalias = 'CCP2CON'                      /* rename reg to CCP2CON */
               else
                  regalias = 'CCPR2'substr(reg,7)           /* rename reg to ECCP2R.. */
               if left(n.j,3) = 'EDC' then
                  alias = regalias'_DC2'substr(n.j,5)       /* rename to EDC2.. */
               else
                  alias = regalias'_CCP2'substr(n.j,6)      /* rename to ECCP2.. */
            end
            else do
               if left(n.j,1) = 'E' then
                  alias = substr(reg,2)'_'substr(n.j,2)     /* strip 'E' prefixes */
               else
                  alias = substr(reg,2)'_'n.j               /* take whole field name */
            end
            if s.j \= 8 & s.j \= 16 then                    /* not full byte/word */
               call list_alias alias, field
         end
         else if reg = 'RTCCFG' then do
            if n.j = 'RTCPTR0' then
               call list_bitfield 2, reg'_'left(n.j,6), reg, offset, addr
         end
         else if reg = 'PADCFG1' then do
            if n.j = 'RTSECSEL0' then
               call list_bitfield 2, reg'_'left(n.j,8), reg, offset, addr
         end
         else if reg = 'ALRMCFG'  &,                        /* ALARMCFG */
                 n.j = 'ALRMPTR' then do                    /* ALRMPTR field */
            call list_bitfield 1, field'1', reg, offset, addr
            call list_bitfield 1, field'0', reg, (offset - 1), addr
         end

         call multi_module_bitfield_alias reg, n.j

         offset = offset - s.j                              /* next offset */

      end
      leave                                                 /* only 1 bit line to process */
   end
   i = i + 1                                                /* next record */
end
return 0


/* ------------------------------------------------------------- */
/* procedure to add pin alias declarations                       */
/* input:  - register name                                       */
/*         - original pin name (Rx)                              */
/*         - pinname for aliases (pin_Xy)                        */
/* create alias definitions for all synonyms in pinmap.          */
/* create extra aliases for first of multiple I2C or SPI modules */
/* create extra aliases for TX and RX pins of only USART module  */
/* returns index of alias (0 if none)                            */
/* ------------------------------------------------------------- */
list_pin_alias: procedure expose  PinMap. Name. PicName Core PinmapMissCount jalfile msglevel
parse arg reg, PinName, Pin .
PicNameCaps = SysMapCase(PicName)
if PinMap.PicNameCaps.PinName.0 = '?' then do
   call msg 2, 'list_pin_alias() PinMap.'PicNameCaps'.'PinName 'is undefined'
   PinmapMissCount = PinmapMissCount + 1                    /* count misses */
   return 0                                                 /* no alias */
end
if PinMap.PicNameCaps.PinName.0 > 0 then do
   do k = 1 to PinMap.PicNameCaps.PinName.0                    /* all aliases */
      pinalias = 'pin_'PinMap.PicNameCaps.PinName.k
      call list_alias pinalias, Pin
      if pinalias = 'pin_SDA1' |,                           /* 1st I2C module */
         pinalias = 'pin_SDI1' |,                           /* 1st SPI module */
         pinalias = 'pin_SDO1' |,
         pinalias = 'pin_SCK1' |,
         pinalias = 'pin_SCL1' |,
         pinalias = 'pin_SS1'  |,                           /* 1st SPI module */
         pinalias = 'pin_TX1'  |,                           /* TX pin first USART */
         pinalias = 'pin_RX1' then                          /* RX                 */
         call list_alias strip(pinalias,'T',1), Pin
   end
end
return k                                                    /* k-th alias */


/* ------------------------------------------------------------- */
/* procedure to add pin_direction alias declarations             */
/* input:  - register name                                       */
/*         - original pin name (Rx)                              */
/*         - pinname for aliases (pin_Xy)                        */
/* create alias definitions for all synonyms in pinmap           */
/* with '_direction' added!                                      */
/* create extra aliases for first of multiple I2C or SPI modules */
/* returns index of alias (0 if none)                            */
/* ------------------------------------------------------------- */
list_pin_direction_alias: procedure expose  PinMap. Name. PicName,
                            Core jalfile msglevel
parse arg reg, PinName, Pin .
PicNameCaps = SysMapCase(PicName)
if PinMap.PicNameCaps.PinName.0 = '?' then do
   call msg 2, 'list_pin_direction_alias() PinMap.'PicNameCaps'.'PinName 'is undefined'
   return 0                                                 /* ignore no alias */
end
if PinMap.PicNameCaps.PinName.0 > 0 then do
   do k = 1 to PinMap.PicNameCaps.PinName.0                    /* all aliases */
      pinalias = 'pin_'PinMap.PicNameCaps.PinName.k'_direction'
      call list_alias  pinalias, Pin
      if pinalias = 'pin_SDA1_direction' |,              /* 1st I2C module */
         pinalias = 'pin_SDI1_direction' |,              /* 1st SPI module */
         pinalias = 'pin_SDO1_direction' |,
         pinalias = 'pin_SCK1_direction' |,
         pinalias = 'pin_SCL1_direction' then do
         pinalias = delstr(pinalias,8,1)
         call list_alias pinalias, Pin
      end
      else if pinalias = 'pin_SS1_direction' |,          /* 1st SPI module */
              pinalias = 'pin_TX1_direction' |,          /* TX pin first USART */
              pinalias = 'pin_RX1_direction' then do     /* RX   "  "     "    */
         pinalias = delstr(pinalias,7,1)
         call list_alias pinalias, Pin
      end
   end
end
return k


/* ------------------------------------------------------------------ */
/* Adding aliases of registers for PICs with multiple similar modules */
/* Used only for registers which are fully dedicated to a module.     */
/* input:  - index i in dev.i of line with this register              */
/*         - register                                                 */
/* returns: nothing                                                   */
/* notes:  - add unqualified alias for module 1                       */
/*         - add (modified) alias for modules 2..9                    */
/*         - bitfields are expanded as for 'real' registers           */
/* All cores                                                          */
/* ------------------------------------------------------------------ */
multi_module_register_alias: procedure expose Dev. Name. Core PicName jalfile msglevel

parse upper arg i, reg .

alias = ''                                                  /* default: no alias */
select

   when reg = 'BAUDCTL' then do                             /* some midrange, 18f1x20 */
      alias = 'BAUDCON'
   end

   when reg = 'BAUD1CON' then do                            /* 1st USART: reg with index */
      alias = 'BAUDCON'                                     /* remove '1' */
   end

   when reg = 'BAUD2CON'  then do                           /* 2nd USART: reg with suffix */
      alias = 'BAUDCON2'                                    /* make index '2' a suffix */
   end

   when reg = 'BAUDCON1' |,
        reg = 'BAUDCTL1' |,
        reg = 'RCREG1'   |,                                 /* 1st USART: reg with index */
        reg = 'RCSTA1'   |,
        reg = 'SPBRGH1'  |,
        reg = 'SPBRGL1'  |,
        reg = 'TXREG1'   |,
        reg = 'TXSTA1'   then do
      alias = strip(reg,'T','1')                            /* remove trailing '1' index */
   end

   when reg = 'RC1REG'   |,                                 /* 1st USART: reg with index */
        reg = 'RC1STA'   |,
        reg = 'SP1BRG'   |,
        reg = 'SP1BRGH'  |,
        reg = 'SP1BRGL'  |,
        reg = 'TX1REG'   |,
        reg = 'TX1STA'   then do
      alias = delstr(reg,3,1)                               /* remove embedded '1' index */
   end

   when reg = 'RC2REG'   |,                                 /* 2nd USART: reg with suffix */
        reg = 'RC2STA'   |,
        reg = 'SP2BRG'   |,
        reg = 'SP2BRGH'  |,
        reg = 'SP2BRGL'  |,
        reg = 'TX2REG'   |,
        reg = 'TX2STA'   then do
      alias = delstr(reg,3,1)'2'                            /* make index '2' a suffix */
   end

   when reg = 'SSPCON'   |,                                 /* unqualified SSPCON */
        reg = 'SSP2CON'  then do
      alias = reg'1'                                        /* add suffix '1' */
   end

   when left(reg,3) = 'SSP'  &  substr(reg,4,1) = '1' then do   /* first or only MSSP module */
      alias = delstr(reg, 4,1)                              /* remove module number */
      if alias = 'SSPCON'   |,                              /* unqualified */
         alias = 'SSP2CON'  then
         alias = alias'1'                                   /* add '1' suffix */
   end

otherwise
   nop                                                      /* ignore other registers */

end

if alias \= '' then do                                      /* alias to be declared */
   call lineout jalfile, '--'                               /* separator line */
   call list_alias alias, reg
   call list_sfr_subfield_alias i, alias, reg               /* declare subfield aliases */
end

return


/* ------------------------------------------------------- */
/* List a line with a volatile variable                    */
/* arguments: - type (byte, word, etc.)                    */
/*            - name                                       */
/*            - address (decimal or string)                */
/* returns:   nothing                                      */
/* Notes:     all cores                                    */
/* ------------------------------------------------------- */
list_variable: procedure expose Core JalFile AccessBankSplitOffset
parse arg type, var, addr                                   /* addr can be string with spaces */
if addr = '' then do
   call msg 3, 'list_variable(): less than 3 arguments found, no output generated!'
   return
end
call charout jalfile, 'var volatile' left(type,max(6,length(type))),
                                     left(var,max(25,length(var)))' '
if Core = '16' then do
   if addr >= AccessBankSplitOffset + X2D('F00') then
      call charout jalfile, 'shared '                       /* var in access bank */
   else
      call charout jalfile, '       '                       /* var in access bank */
   addr = '0x'D2X(addr)
end
else if Core = '14H' then do
   if addr < 12 then
      call charout jalfile, 'shared '                       /* 'CORE' register */
   else
      call charout jalfile, '       '                       /* not a core regsiter */
   addr = '0x'D2X(addr)
end
call lineout jalfile, 'at' addr                             /* addr is formatted string */
return


/* --------------------------------------------------------- */
/* List a line with a volatile bitfield variable             */
/* arguments: - width in bits (1,2, .. 8)                    */
/*            - name if the bit                              */
/*            - register                                     */
/*            - offset within the register                   */
/*            - address (decimal, only for core 14H and 16)  */
/* returns:   nothing                                        */
/* Notes:     all cores                                      */
/* --------------------------------------------------------- */
list_bitfield: procedure expose Core JalFile AccessBankSplitOffset Name.
parse arg width, bitfield, reg, offset, addr .
if offset = '' then do
   call msg 3, 'list_bitfield(): less than 4 arguments found, no output generated!'
   return
end
if datatype(width) \= 'NUM'  |  width < 1  |  width > 8 then do
   call msg 3, 'list_bitfield(): bitfield width' width 'not supported, no output generated!'
   return
end
if duplicate_name(bitfield,reg) \= 0 then                   /* name already declared */
   return
call charout jalfile, 'var volatile '
if width = 1 then
   call charout jalfile, left('bit',7)
else
   call charout jalfile, left('bit*'width,7)
call charout jalfile, left(bitfield,max(25,length(bitfield)))' '
if Core = '16' then do
   if addr >= AccessBankSplitOffset + X2D('F00') then
      call charout jalfile, 'shared '                       /* var inside access bank */
   else
      call charout jalfile, '       '                       /* var outside access bank */
end
else if Core = '14H' then do
   if addr < 12 then
      call charout jalfile, 'shared '                       /* 'CORE' regsiter */
   else
      call charout jalfile, '       '                       /* not a core register */
end
call lineout jalfile, 'at' reg ':' offset
return


/* ------------------------------------------------------- */
/* List a line with an alias declaration                   */
/* arguments: - name of alias                              */
/*            - name of original variable (or other alias) */
/* returns:   nothing                                      */
/* Notes:     all cores                                    */
/* ------------------------------------------------------- */
list_alias: procedure expose Core JalFile Name. reg msglevel
parse arg alias, original .
if orininal = '' then do
   call msg 3, 'list_alias(): 2 arguments expected, no output generated!'
   return
end
if duplicate_name(alias,reg) = 0 then do
   if Core = '16' | Core = '14H' then
      call lineout jalfile, left('alias',19) left(alias,max(32,length(alias))) 'is' original
   else
      call lineout jalfile, left('alias',19) left(alias,max(25,length(alias))) 'is' original
end
return


/* ----------------------------------------------------- */
/* Adding aliases of register bitfields related to       */
/* multiple similar modules.                             */
/* Used for registers which happen to contain bitfields  */
/* for multiple similar modules.                         */
/* For - PIE, PIR and IPR registers                      */
/*       USART and SSP interrupt bits                    */
/* input:  - register                                    */
/*         - bitfield                                    */
/* returns: nothing                                      */
/* notes:  - add unqualified alias for module 1          */
/*         - add (modified) alias for modules 2..9       */
/* All cores                                             */
/* ----------------------------------------------------- */
multi_module_bitfield_alias: procedure expose Name. Core jalfile msglevel

parse upper arg reg, bitfield .

j = 0                                                    /* default: no multi-module */

if left(reg,3) = 'PIE'  |,                               /* Interrupt register */
   left(reg,3) = 'PIR'  |,
   left(reg,3) = 'IPR'  then do
   if left(bitfield,2) = 'TX'  |,                        /* USART related bitfields */
      left(bitfield,2) = 'RC'  then do
      j = substr(bitfield,3,1)                           /* possibly module number */
      if datatype(j) = 'NUM' then                        /* embedded number */
         strippedfield = delstr(bitfield,3,1)
      else do
         j = right(bitfield,1)                           /* possibly module number */
         if datatype(j) = 'NUM' then                     /* numeric suffix */
            strippedfield = left(bitfield,length(bitfield)-1)
         else                                            /* no module number found */
            j = 0                                        /* no alias required */
      end
   end
   else if left(bitfield,3) = 'SSP' then do              /* SSP related bitfields */
      j = substr(bitfield,4,1)                           /* extract module number */
      if datatype(j) = 'NUM' & j = 1 then                /* first module */
         strippedfield = delstr(bitfield,4,1)            /* remove the number */
      else                                               /* no module number found */
         j = 0                                           /* no alias required */
   end
end

if j = 0 then                                            /* no module number found */
  return                                                 /* no alias required */
if j = 1 then                                            /* first module */
   j = ''                                                /* no suffix */
alias = reg'_'strippedfield||j                           /* alias name (with suffix) */
call list_alias alias, reg'_'bitfield

return


/* --------------------------------------------- */
/* Formatting of SFR subfield aliases            */
/* Generates aliases for bitfields               */
/* input:  - index of register line  in .dev     */
/*         - alias of register                   */
/*         - original register                   */
/* --------------------------------------------- */
list_sfr_subfield_alias: procedure expose Dev. Name. PinMap. PinANMap. PortLat. ,
                                          PicName Core jalfile msglevel
parse upper arg i, reg_alias, reg .
i = i + 1                                                   /* 1st after reg */
do 8 until (word(Dev.i,1) = 'SFR' | word(Dev.i,1) = 'NMMR')  /* max 8, until next register */
   parse var Dev.i 'BIT' val0 'NAMES=' val1 'WIDTH=' val2 ')' .
   if val1 \= ''  &,                                        /* found */
      pos('SCL', val0) = 0  &,                              /* not 'scl' */
      word(Dev.i,1) \= 'QBIT' then do                       /* not 'qbit' */
      names = strip(strip(val1), 'B', "'")                  /* strip blanks .. */
      sizes = strip(strip(val2), 'B', "'")                  /* .. and quotes */
      parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
      parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
      offset = 7                                            /* MSbit first */
      do j = 1 to 8 while offset >= 0                       /* 8 bits */
         if s.j = 8 then do                                 /* full byte */
            offset = offset - s.j                           /* next offset */
            iterate                                         /* skip */
         end
         if n.j \= '-' then do                              /* bit present */

            alias  = ''                                     /* nul alias */
            alias2 = ''                                     /* nul 2nd alias */
            original = reg'_'n.j                            /* original subfield */
            original2 = reg'_'n.j                           /* 2nd         "     */

            if (pos('/', n.j) > 0 | pos('_', n.j) > 0)  &,  /* check for twin name */
                left(n.j,4) \= 'PRI_'                   &,  /* exception */
                reg \= 'ICDIO' then do                      /* exception */
               if pos('/', n.j) > 0 then                    /* splitted with '/' */
                 parse var n.j val1'/'val2 .
               else                                         /* splitted with '_' */
                 parse var n.j val1'_'val2 .
               if val1 \= '' then do                        /* present */
                  alias = reg_alias'_'val1                  /* 1st subfield */
                  original = reg'_'val1                     /* split original subfield to */
               end
               if val2 \= '' & val2 \= 'SHAD' then do
                  alias2 = reg_alias'_'val2                 /* 2nd subfield */
                  original2 = reg'_'val2                    /* split original subfield too */
               end
            end

            else do                                         /* not twin name */
               if (left(n.j,4) = 'SSPM' & datatype(substr(n.j,5)) = 'NUM') then do
                  if right(n.j,1) = '0' then do             /* last enumerated bit */
                     alias = reg_alias'_SSPM'               /* not enumerated */
                     original = reg'_SSPM'                  /* modify original too */
                  end
               end
               else do
                  alias = reg_alias'_'n.j
               end
            end

            if alias \= '' then do
               call list_alias alias, original
               if alias2 \= '' then
                  call list_alias alias2, original2
            end
         end

         offset = offset - s.j                              /* next offset */
      end
   end
   i = i + 1                                                /* next record */
end
return 0


/* -------------------------------------------------- */
/* procedure to list non memory mapped registers      */
/* of 12-bit core as pseudo variables.                */
/* Only some selected registers are handled:          */
/* TRISxx and OPTIONxx                                */
/* input:  - nothing                                  */
/* Note: name is stored but not checked on duplicates */
/* 12-bit core                                        */
/* -------------------------------------------------- */
list_nmmr12: procedure expose Dev. Ram. Name. PinMap.  PicName,
                              jalfile BankSize NumBanks msglevel
do i = 1 to Dev.0
   if word(Dev.i,1) \= 'NMMR' then                          /* not 'nmmr' */
      iterate                                               /* skip */
   parse var Dev.i  val0 '(KEY=' val1 ' ADDR' '=' '0X' val2 'SIZE' '=' val3 .
   if val1 \= '' then do                                    /* found! */
      reg = strip(val1)                                     /* register name */

      if left(reg,4) = 'TRIS' then do                       /* handle TRISxx */
         Name.reg = reg                                     /* add to collection of names */
         call lineout jalfile, '-- ------------------------------------------------'
         portletter = substr(reg,5)
         if portletter = 'IO'  |  portletter = '' then      /* TRISIO */
            portletter = 'A'                                /* handle it as TRISA */
         shadow = '_TRIS'portletter'_shadow'
         call lineout jalfile, 'var  byte' shadow '= 0b1111_1111         -- default all input'
         call lineout jalfile, '--'
         call lineout jalfile, 'procedure PORT'portletter"_direction'put(byte in x",
                                                                        'at' shadow') is'
         call lineout jalfile, '   pragma inline'
         call lineout jalfile, '   asm movf' shadow',W'
         if reg = 'TRISIO' then                             /* TRISIO (small PIC) */
            call lineout jalfile, '   asm tris 6'
         else                                               /* TRISx */
            call lineout jalfile, '   asm tris' 5 + C2D(portletter) - C2D('A')
         call lineout jalfile, 'end procedure'
         call lineout jalfile, '--'
         half = 'PORT'portletter'_low_direction'
         call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
         call lineout jalfile, '   pragma inline'
         call lineout jalfile, '   'shadow '= ('shadow '& 0xF0) | (x & 0x0F)'
         call lineout jalfile, '   asm movf _TRIS'portletter'_shadow,W'
         if reg = 'TRISIO' then                             /* TRISIO (small PICs) */
           call lineout jalfile, '   asm tris 6'
         else                                               /* TRISx */
           call lineout jalfile, '   asm tris' 5 + C2D(portletter) - C2D('A')
         call lineout jalfile, 'end procedure'
         call lineout jalfile, '--'
         half = 'PORT'portletter'_high_direction'
         call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
         call lineout jalfile, '   pragma inline'
         call lineout jalfile, '   'shadow '= ('shadow '& 0x0F) | (x << 4)'
         call lineout jalfile, '   asm movf _TRIS'portletter'_shadow,W'
         if reg = 'TRISIO' then                             /* TRISIO (small PICs) */
           call lineout jalfile, '   asm tris 6'
         else                                               /* TRISx */
           call lineout jalfile, '   asm tris' 5 + C2D(portletter) - C2D('A')
         call lineout jalfile, 'end procedure'
         call lineout jalfile, '--'
         call list_nmmr_sub12_tris i, reg                   /* individual TRIS bits */
      end

      else if reg = 'OPTION_REG' | reg = OPTION2 then do    /* option */
        Name.reg = reg                                      /* add to collection of names */
        shadow = '_'reg'_shadow'
        call lineout jalfile, '-- ------------------------------------------------'
        call lineout jalfile, 'var  byte' shadow '= 0b1111_1111         -- default all set'
        call lineout jalfile, '--'
        call lineout jalfile, 'procedure' reg"'put(byte in x at" shadow') is'
        call lineout jalfile, '   pragma inline'
        call lineout jalfile, '   asm movf' shadow',0'
        if reg = 'OPTION_REG' then                          /* OPTION_REG */
           call lineout jalfile, '   asm option'
        else                                                /* OPTION2 */
           call lineout jalfile, '   asm tris 7'
        call lineout jalfile, 'end procedure'
        call list_nmmr_sub12_option i, reg                  /* subfields */
      end

   end
end
return 0


/* ---------------------------------------- */
/* Formatting of non memory mapped register */
/* subfields of TRISx                       */
/* input:  - index in .dev                  */
/*         - port letter                    */
/* 12-bit core                              */
/* ---------------------------------------- */
list_nmmr_sub12_tris: procedure expose Dev. Name. PinMap. PicName,
                                       jalfile msglevel
parse arg i, reg .
i = i + 1
do 3 until (word(Dev.i,1) = 'SFR' | word(Dev.i,1) = 'NMMR')  /* max 3, until next register */
   parse var Dev.i 'BIT' val0 'NAMES=' val1 'WIDTH=' val2 ')' .
   if val1 \= '' then do                                    /* found */
      names = strip(strip(val1), 'B', "'")                  /* strip blanks .. */
      parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
      portletter = substr(reg,5)
      if portletter = 'IO' then                             /* TRISIO */
         portletter = 'A'                                   /* handle as TRISA */
      shadow = '_TRIS'portletter'_shadow'
      offset = 7                                            /* MSbit first */
      do j = 1 to 8 while offset >= 0                       /* max 8 bits */
         if n.j \= '-' then do                              /* pin direction present */
            call lineout jalfile, 'procedure pin_'portletter||offset"_direction'put(bit in x",
                                                      'at' shadow ':' offset') is'
            call lineout jalfile, '   pragma inline'
            call lineout jalfile, '   asm movf _TRIS'portletter'_shadow,W'
            if reg = 'TRISIO' then                          /* TRISIO */
               call lineout jalfile, '   asm tris 6'
            else                                            /* TRISx */
               call lineout jalfile, '   asm tris' 5 + C2D(portletter) - C2D('A')
            call lineout jalfile, 'end procedure'
            call list_pin_direction_alias reg, 'R'portletter||right(n.j,1),,
                                  'pin_'portletter||right(n.j,1)'_direction'
            call lineout jalfile, '--'
         end
         offset = offset - 1
      end
   end
   i = i + 1                                                /* next record */
end
return 0


/* ------------------------------------------------- */
/* Formatting of non memory mapped registers:        */
/* OPTION_REG and OPTION2                            */
/* input:  - index in .dev                           */
/*         - register name                           */
/* Generates names for pins or bits                  */
/* 12-bit core                                       */
/* ------------------------------------------------- */
list_nmmr_sub12_option: procedure expose Dev. Name. PinMap. PicName,
                                         jalfile msglevel
parse arg i, reg .
i = i + 1
do 8 until (word(Dev.i,1) = 'SFR' | word(Dev.i,1) = 'NMMR')  /* max 8, until next register */
   parse var Dev.i 'BIT' val0 'NAMES' '=' val1 'WIDTH' '=' val2 ')' .
   if val1 \= '' then do                                    /* found */
      names = strip(strip(val1), 'B', "'")                  /* strip blanks */
      sizes = strip(strip(val2), 'B', "'")                  /* and quotes */
      n. = '-'                                              /* reset */
      parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
      parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
      shadow = '_'reg'_shadow'
      offset = 7                                            /* MSbit first */
      do j = 1 to 8 while offset >= 0                       /* max 8 bits */
         if n.j \= '-' & n.j \= '' then do                  /* bit(s) in use */
            call lineout jalfile, '--'
            field = reg'_'n.j
            Name.field = field                              /* remember name */
            if s.j = 1 then do                              /* single bit */
               call lineout jalfile, 'procedure' field"'put"'(bit in x',
                                                 'at' shadow ':' offset') is'
               call lineout jalfile, '   pragma inline'
            end
            else if s.j > 1  &  s.j < 8  then do            /* multi-bit */
               call lineout jalfile, 'procedure' field"'put"'(bit*'s.j 'in x',
                                                 'at' shadow ':' offset - s.j + 1') is'
               call lineout jalfile, '   pragma inline'
            end
            call lineout jalfile, '   asm movf' shadow',0'
            if reg = 'OPTION_REG' then                      /* OPTION_REG */
               call lineout jalfile, '   asm option'
            else                                            /* OPTION2 */
               call lineout jalfile, '   asm tris 7'
            call lineout jalfile, 'end procedure'
            if reg = 'OPTION_REG' then do
               if n.j = 'T0CS' | n.j = 'T0SE' | n.j = 'PSA' then
                  call list_alias 'T0CON_'n.j, reg'_'n.j
               else if n.j = 'PS' then
                  call list_alias 'T0CON_T0'n.j, reg'_'n.j
            end
         end
         offset = offset - s.j
      end
   end
   i = i + 1                                                /* next record */
end
return 0


/* ---------------------------------------------------------------- */
/* procedure to list 'shared memory' SFRs of the midrange (NMMRs)   */
/* (in this case 'shared' means using the same memory address!)     */
/* input:  - nothing                                                */
/* output: - pseudo variables are declared                          */
/*         - subfields are expanded (separate procedure)            */
/* 14-bit core                                                      */
/* ---------------------------------------------------------------- */
list_nmmr14: procedure expose Dev. Ram. Name. jalfile BankSize NumBanks msglevel
do i = 1 to Dev.0
   if word(Dev.i,1) \= 'NMMR' then
      iterate
   parse var Dev.i 'NMMR' '(KEY=' val1 'MAPADDR=0X' val2 ' ADDR=0X' val0 'SIZE=' val3 .
   if val1 \= '' then do
      reg = strip(val1)                                     /* register name */
      Name.reg = reg                                        /* remember */
      subst  = '_'reg                                       /* substitute name */
      addr = strip(val2)                                    /* (mapped) address */
      size = strip(val3)                                    /* # bytes */
      if reg = 'SSPMSK' then do
         call lineout jalfile, '-- ------------------------------------------------'
         call lineout jalfile, 'var volatile byte  ' left(subst,25) 'at 0x'addr
         call lineout jalfile, '--'
         call lineout jalfile, 'procedure' reg"'put"'(byte in x) is'
         call lineout jalfile, '   var byte _SSPCON_saved = SSPCON'
         call lineout jalfile, '   SSPCON_SSPM = 0b1001'
         call lineout jalfile, '   'subst '= x'
         call lineout jalfile, '   SSPCON = _SSPCON_saved'
         call lineout jalfile, 'end procedure'
         call lineout jalfile, 'function' reg"'get"'() return byte is'
         call lineout jalfile, '   var  byte  x'
         call lineout jalfile, '   var byte _SSPCON_saved = SSPCON'
         call lineout jalfile, '   SSPCON_SSPM = 0b1001'
         call lineout jalfile, '   x =' subst
         call lineout jalfile, '   SSPCON = _SSPCON_saved'
         call lineout jalfile, '   return  x'
         call lineout jalfile, 'end function'
         call lineout jalfile, '--'
      end

/*    call list_nmmr_sub14 i, reg     */                    /* declare subfields */

   end
end
return 0


/* ------------------------------------------------------------ */
/* procedure to list 'shared memory' SFRs of the 18Fs (NMMRs)   */
/* (in this case 'shared' means using the same memory address!) */
/* input:  - nothing                                            */
/* output: - pseudo variables are declared                      */
/*         - subfields are expanded (separate procedure)        */
/* 16-bit core                                                  */
/* ------------------------------------------------------------ */
list_nmmr16: procedure expose Dev. Ram. Name. jalfile BankSize NumBanks msglevel,
                              Core AccessBankSplitOffset
do i = 1 to Dev.0
   if word(Dev.i,1) \= 'NMMR' then
      iterate
   if pos('_INTERNAL',Dev.i) > 0  |,                        /* skip TMRx_internal */
      pos('_PRESCALE',Dev.i) > 0 then                       /* TMRx_prescale */
      iterate
   parse var Dev.i 'NMMR' '(KEY=' val1 'MAPADDR=0X' val2 ' ADDR=0X' val0 'SIZE=' val3 .
   if val1 \= '' then do
      reg = strip(val1)                                     /* register name */
      Name.reg = reg                                        /* remember */
      subst  = '_'reg                                       /* substitute name */
      addr = strip(val2)                                    /* (mapped) address */
      size = strip(val3)                                    /* # bytes */
      if reg = 'SSP1MSK' | reg = 'SSP2MSK' then do
         index = substr(reg,4,1)                            /* SSP module number */
         call lineout jalfile, '-- ------------------------------------------------'
         call lineout jalfile, 'var volatile byte  ' left(subst,25) 'at 0x'addr
         call lineout jalfile, '--'
         call lineout jalfile, 'procedure' reg"'put"'(byte in x) is'
         call lineout jalfile, '   var byte _SSP'index'CON1_saved = SSP'index'CON1'
         call lineout jalfile, '   SSP'index'CON1_SSPM = 0b1001'
         call lineout jalfile, '   'subst '= x'
         call lineout jalfile, '   SSP'index'CON1 = _SSP'index'CON1_saved'
         call lineout jalfile, 'end procedure'
         call lineout jalfile, 'function' reg"'get"'() return byte is'
         call lineout jalfile, '   var  byte  x'
         call lineout jalfile, '   var byte _SSP'index'CON1_saved = SSP'index'CON1'
         call lineout jalfile, '   SSP'index'CON1_SSPM = 0b1001'
         call lineout jalfile, '   x =' subst
         call lineout jalfile, '   SSP'index'CON1 = _SSP'index'CON1_saved'
         call lineout jalfile, '   return  x'
         call lineout jalfile, 'end function'
         call lineout jalfile, '--'
         if reg = SSP1MSK then
            call list_alias  'SSPMSK', reg
      end
      else if left(reg,6) = 'PMDOUT' then do
         call lineout jalfile, '-- ------------------------------------------------'
         call list_variable 'byte', reg, X2D(addr)               /* normal SFR! */
      end
      else do
         call lineout jalfile, '-- ------------------------------------------------'
         call lineout jalfile, 'var volatile byte  ' left(subst,25) 'shared at 0x'addr
         call lineout jalfile, '--'
         call lineout jalfile, 'procedure' reg"'put"'(byte in x) is'
         call lineout jalfile, '   WDTCON_ADSHR = TRUE'
         call lineout jalfile, '   'subst '= x'
         call lineout jalfile, '   WDTCON_ADSHR = FALSE'
         call lineout jalfile, 'end procedure'
         call lineout jalfile, 'function' reg"'get"'() return byte is'
         call lineout jalfile, '   var  byte  x'
         call lineout jalfile, '   WDTCON_ADSHR = TRUE'
         call lineout jalfile, '   x =' subst
         call lineout jalfile, '   WDTCON_ADSHR = FALSE'
         call lineout jalfile, '   return  x'
         call lineout jalfile, 'end function'
         call lineout jalfile, '--'
         call list_nmmr_sub16 i, reg                        /* declare subfields */
      end

   end
end
return 0


/* ---------------------------------------------------------- */
/* Formatting of non memory mapped registers of 16-bits core  */
/* of the 18F series                                          */
/* input:  - index in .dev                                    */
/*         - register name                                    */
/* 16-bit core                                                */
/* ---------------------------------------------------------- */
list_nmmr_sub16: procedure expose Dev. Name. PinMap. PicName jalfile msglevel
parse arg i, reg .
i = i + 1
do 8 until (word(Dev.i,1) = 'SFR' | word(Dev.i,1) = 'NMMR')  /* max 8, until next register */
   parse var Dev.i 'BIT' val0 'NAMES' '=' val1 'WIDTH' '=' val2 ')' .
   if val1 \= '' then do                                    /* found */
      names = strip(strip(val1), 'B', "'")                  /* strip blanks */
      sizes = strip(strip(val2), 'B', "'")                  /* and quotes */
      n. = '-'                                              /* reset */
      parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
      parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
      subst  = '_'reg                                       /* substitute name */
      offset = 7                                            /* MSbit first */
      do j = 1 to 8 while offset >= 0                       /* max 8 bits */
         if n.j \= '-' & n.j \= '' then do                  /* bit(s) in use */
            field = reg'_'n.j
            Name.field = field                              /* remember name */
            if s.j = 1 then do                              /* single bit */
               call lineout jalfile, 'procedure' field"'put"'(bit in x) is'
               call lineout jalfile, '   pragma inline'
               call lineout jalfile, '   var  bit   y at' subst ':' offset
               call lineout jalfile, '   WDTCON_ADSHR = TRUE'
               call lineout jalfile, '   y = x'
               call lineout jalfile, '   WDTCON_ADSHR = FALSE'
               call lineout jalfile, 'end procedure'
               call lineout jalfile, 'function ' field"'get"'() return bit is'
               call lineout jalfile, '   pragma inline'
               call lineout jalfile, '   var  bit   x at' subst ':' offset
               call lineout jalfile, '   var  bit   y'
               call lineout jalfile, '   WDTCON_ADSHR = TRUE'
               call lineout jalfile, '   y = x'
               call lineout jalfile, '   WDTCON_ADSHR = FALSE'
               call lineout jalfile, '   return y'
               call lineout jalfile, 'end function'
               call lineout jalfile, '--'
            end
            else if s.j < 8  then do                        /* multi-bit */
               call lineout jalfile, 'procedure' field"'put"'(bit*'s.j 'in x) is'
               call lineout jalfile, '   pragma inline'
               call lineout jalfile, '   var  bit*'s.j 'y at' subst ':' offset - s.j + 1
               call lineout jalfile, '   WDTCON_ADSHR = TRUE'
               call lineout jalfile, '   y = x'
               call lineout jalfile, '   WDTCON_ADSHR = FALSE'
               call lineout jalfile, 'end procedure'
               call lineout jalfile, 'function ' field"'get"'() return bit*'s.j 'is'
               call lineout jalfile, '   pragma inline'
               call lineout jalfile, '   var  bit*'s.j 'x at' subst ':' offset - s.j + 1
               call lineout jalfile, '   var  bit*'s.j 'y'
               call lineout jalfile, '   WDTCON_ADSHR = TRUE'
               call lineout jalfile, '   y = x'
               call lineout jalfile, '   WDTCON_ADSHR = FALSE'
               call lineout jalfile, '   return y'
               call lineout jalfile, 'end function'
               call lineout jalfile, '--'
            end
            else if left(reg,5) = 'ANCON' then do           /* (8-bits wide) ANCONx */
               do offset = 7 to 0 by -1                     /* enumerate */
                  call lineout jalfile, 'procedure' field||offset"'put"'(bit in x) is'
                  call lineout jalfile, '   pragma inline'
                  call lineout jalfile, '   var  bit   y at' subst ':' offset
                  call lineout jalfile, '   WDTCON_ADSHR = TRUE'
                  call lineout jalfile, '   y = x'
                  call lineout jalfile, '   WDTCON_ADSHR = FALSE'
                  call lineout jalfile, 'end procedure'
                  call lineout jalfile, 'function ' field||offset"'get"'() return bit is'
                  call lineout jalfile, '   pragma inline'
                  call lineout jalfile, '   var  bit   x at' subst ':' offset
                  call lineout jalfile, '   var  bit   y'
                  call lineout jalfile, '   WDTCON_ADSHR = TRUE'
                  call lineout jalfile, '   y = x'
                  call lineout jalfile, '   WDTCON_ADSHR = FALSE'
                  call lineout jalfile, '   return y'
                  call lineout jalfile, 'end function'
                  if left(n.j, 3) = 'ANS' then do
                     ansx = ansel2j(reg, n.j||offset)
                     if ansx < 99 then
                        call list_alias 'JANSEL_ANS'ansx, field||offset
                  end
                  if n.j = 'PCFGH' then                     /* high bits */
                     call list_alias reg'_'PCFG||offset+8, field||offset
                  else if n.j = 'PCFGL' then do             /* low bits */
                     call list_alias reg'_'PCFG||offset, field||offset
                  end
                  call lineout jalfile, '--'
               end
            end
         end
         offset = offset - s.j
      end
   end
   i = i + 1                                                /* next record */
end
return 0


/* ----------------------------------------- */
/* convert ANSEL-bit to JANSEL_number        */
/* input: - register  (ANSEL,ADCON)          */
/*        - ANS number                       */
/* All cores                                 */
/* This procedure has to be evaluated        */
/* with every additional PIC(-group)         */
/* The value 99 indicates 'no JANSEL number' */
/* ----------------------------------------- */
ansel2j: procedure expose Core PicName PinMap. PinANMap. msglevel
parse upper arg reg, ans .                                  /* ans is name of bitfield! */

if datatype(right(ans,2),'W') = 1 then                      /* name ends with 2 digits */
   ansx = right(ans,2)                                      /* 2 digits seq. nbr. */
else
   ansx = right(ans,1)                                      /* single digit seq. nbr. */

if core = '12' | core = '14' then do                        /* baseline, classic midrange */
   select
      when reg = 'ANSELH' | reg = 'ANSEL1' then do
         if ansx < 8 then                                   /* continuation of ANSEL[0|A] */
            ansx = ansx + 8
      end
      when reg = 'ANSELG' then do
         if ansx < 8 then
            ansx = ansx + 8
      end
      when reg = 'ANSELE' then do
         if left(PicName,5) = '16f70' | left(PicName,6) = '16lf70' |,
            left(PicName,5) = '16f72' | left(PicName,6) = '16lf72' then
            ansx = ansx + 5
         else
            ansx = ansx + 20
      end
      when reg = 'ANSELD' then do
         if left(PicName,5) = '16f70' | left(PicName,6) = '16lf70' |,
            left(PicName,5) = '16f72' | left(PicName,6) = '16lf72' then
            ansx = 99                                       /* not for ADC */
         else
            ansx = ansx + 12
      end
      when reg = 'ANSELC' then do
         if left(PicName,5) = '16f70' | left(PicName,6) = '16lf70' then
            ansx = 99
         else if right(PicName,4) = 'f720' | right(PicName,4) = 'f721' then
            ansx = word('4 5 6 7 99 99 8 9', ansx + 1)
         else
            ansx = ansx + 12
      end
      when reg = 'ANSELB' then do
         if right(PicName,4) = 'f720' | right(PicName,4) = 'f721' then
            ansx = ansx + 6
         else if left(PicName,5) = '16f70' | left(PicName,6) = '16lf70' |,
                 left(PicName,5) = '16f72' | left(PicName,6) = '16lf72' then
            ansx = word('12 10 8 9 11 13 99 99', ansx + 1)
         else
            ansx = ansx + 6
      end
      when reg = 'ANSELA' | reg = 'ANSEL' | reg = 'ANSEL0' | reg = 'ADCON0' then do
         if right(PicName,4) = 'f752' | right(PicName,5) = 'hv752' |,
            right(PicName,4) = 'f720' | right(PicName,4) = 'f721' then
            ansx = word('0 1 2 99 3 99 99 99', ansx + 1)
         else if left(PicName,5) = '16f70' | left(PicName,6) = '16lf70' |,
                 left(PicName,5) = '16f72' | left(PicName,6) = '16lf72' then
            ansx = word('0 1 2 3 99 4 99 99', ansx + 1)
         else
            ansx = ansx + 0                                 /* no change of ansx */
      end
   otherwise
      call msg 3, 'Unsupported ADC register for' PicName ':' reg
      ansx = 99
   end
end

else if core = '14H' then do                                /* enhanced midrange */
   select
      when reg = 'ANSELG' then do
         ansx = word('99 15 14 13 12 99 99 99', ansx + 1)
      end
      when reg = 'ANSELF' then do
         ansx = word('16 6 7 8 9 10 11 5', ansx + 1)
      end
      when reg = 'ANSELE' then do
         if left(PicName,6) = '16f151'  | left(PicName,7) = '16lf151' |,
            left(PicName,7) = '16lf190' |,
            left(PicName,6) = '16f193'  | left(PicName,7) = '16lf193' then
            ansx = ansx + 5
         else if left(PicName,6) = '16f152' | left(PicName,7) = '16lf152' then
            ansx = word('27 28 29 99 99 99 99 99', ansx + 1)
         else if left(PicName,6) = '16f194' | left(PicName,7) = '16lf194' then
            ansx = 99
         else
            ansx = ansx + 20
      end
      when reg = 'ANSELD' then do
         if left(PicName,6) = '16f151' | left(PicName,7) = '16lf151' then
            ansx = ansx + 20
         else if left(PicName,6) = '16f152' | left(PicName,7) = '16lf152' then
            ansx = word('23 24 25 26 99 99 99 99', ansx + 1)
         else
            ansx = 99
      end
      when reg = 'ANSELC' then do
         if left(PicName,6) = '16f151' | left(PicName,7) = '16lf151' then
            ansx = word('99 99 14 15 16 17 18 19', ansx + 1)
         else if left(PicName,6) = '16f145' | left(PicName,7) = '16lf145' |,
                 left(PicName,6) = '16f150' | left(PicName,7) = '16lf150' |,
                 left(PicName,6) = '16f182' | left(PicName,7) = '16lf182' then
            ansx = word('4 5 6 7 99 99 8 9', ansx + 1)
      end
      when reg = 'ANSELB' then do
         if PicName = '16f1826' | PicName = '16lf1826' |,
            PicName = '16f1827' | PicName = '16lf1827' |,
            PicName = '16f1847' | PicName = '16lf1847' then
            ansx = word('99 11 10 9 8 7 5 6', ansx + 1)
         else if left(PicName,6) = '16f145' | left(PicName,7) = '16lf145' then
            ansx = word('99 99 99 99 10 11 99 99', ansx + 1)
         else if left(PicName,6) = '16f150' | left(PicName,7) = '16lf150' |,
                 left(PicName,6) = '16f182' | left(PicName,7) = '16lf182' then
            ansx = word('99 99 99 99 10 11 99 99 ', ansx + 1)
         else if left(PicName,6) = '16f151' | left(PicName,7) = '16lf151' |,
                 left(PicName,6) = '16f178' | left(PicName,7) = '16lf178' |,
                 left(PicName,7) = '16lf190'                              |,
                 left(PicName,6) = '16f193' | left(PicName,7) = '16lf193' then
            ansx = word('12 10 8 9 11 13 99 99', ansx + 1)
         else if left(PicName,6) = '16f152' | left(PicName,7) = '16lf152' then
            ansx = word('17 18 19 20 21 22 99 99', ansx + 1)
      end
      when reg = 'ANSELA' then do
         if PicName = '16f1826' | PicName = '16lf1826' |,
            PicName = '16f1827' | PicName = '16lf1827' |,
            PicName = '16f1847' | PicName = '16lf1847' then
            ansx = ansx + 0
         else if left(PicName,6) = '16f145' | left(PicName,7) = '16lf145' then
            ansx = word('99 99 99 99 3 99 99 99', ansx + 1)
         else if left(PicName,6) = '12lf15' then
            ansx = word('0 1 2 99 3 4 99 99', ansx + 1)
         else if left(PicName,6) = '12f150' | left(PicName,7) = '12lf150' |,
                 left(PicName,6) = '12f182' | left(PicName,7) = '12lf182' |,
                 left(PicName,6) = '12f184' | left(PicName,7) = '12lf184' |,
                 left(PicName,6) = '16f150' | left(PicName,7) = '16lf150' |,
                 left(PicName,6) = '16f182' | left(PicName,7) = '16lf182' then
            ansx = word('0 1 2 99 3 99 99 99', ansx + 1)
         else if left(PicName,6) = '16f151' | left(PicName,7) = '16lf151' |,
                 left(PicName,6) = '16f152' | left(PicName,7) = '16lf152' |,
                 left(PicName,6) = '16f178' | left(PicName,7) = '16lf178' |,
                 left(PicName,7) = '16lf190'                              |,
                 left(PicName,6) = '16f193' | left(PicName,7) = '16lf193' |,
                 left(PicName,6) = '16f194' | left(PicName,7) = '16lf194' then
            ansx = word('0 1 2 3 99 4 99 99', ansx + 1)
      end
   otherwise
      call msg 3, 'Unsupported ADC register for' PicName ':' reg
      ansx = 99
   end
end

else if core = '16' then do                                 /* 18F series */
   select
      when reg = 'ANCON3' then do
         if ansx < 8 then do
            if right(PicName, 3) = 'j94' | right(PicName, 3) = 'j99' then
               ansx = ansx + 16
            else
               ansx = ansx + 24
         end
      end
      when reg = 'ANCON2' then do
         if ansx < 8 then do
            if right(PicName, 3) = 'j94' | right(PicName, 3) = 'j99' then
               ansx = ansx + 8
            else
               ansx = ansx + 16
         end
      end
      when reg = 'ANCON1' then do
         if ansx < 8 then do
            if right(PicName, 3) = 'j94' | right(PicName, 3) = 'j99' then
               ansx = ansx + 0
            else
               ansx = ansx + 8
         end
      end
      when reg = 'ANCON0' then do
         if ansx < 8 then
            ansx = ansx + 0
      end
      when reg = 'ANSELH' | reg = 'ANSEL1' then do
         if ansx < 8 then
            ansx = ansx + 8
      end
      when reg = 'ANSELE' then do
         ansx = ansx + 5
      end
      when reg = 'ANSELD' then do
         ansx = ansx + 20
      end
      when reg = 'ANSELC' then do
         ansx = ansx + 12
      end
      when reg = 'ANSELB' then do
         ansx = word('12 10 8 9 11 13 99 99', ansx + 1)
      end
      when reg = 'ANSELA' | reg = 'ANSEL' | reg = 'ANSEL0' then do
         if PicName = '18f13k22' | PicName = '18lf13k22' |,
            PicName = '18f14k22' | PicName = '18lf14k22' then
            nop                                             /* consecutive */
         else if PicName = '18f24k50' | PicName = '18lf24k50' |,
                 PicName = '18f25k50' | PicName = '18lf25k50' |,
                 PicName = '18f45k50' | PicName = '18lf45k50' then
            ansx = word('0 1 2 3 99 4 99 99', ansx + 1)
         else if right(PicName,3) = 'k22' & ansx = 5 then
            ansx = 4                                        /* jump */
      end
   otherwise
      call msg 3, 'Unsupported ADC register for' PicName ':' reg
      ansx = 99
    end
end

PicNameCaps = SysMapCase(PicName)
aliasname    = 'AN'ansx
if ansx < 99 & PinANMap.PicNameCaps.aliasname = '-' then do  /* no match */
   call msg 2, 'No "pin_AN'ansx'" alias in pinmap'
   ansx = 99                                                /* error indication */
end
return ansx


/* ---------------------------------------------- */
/* procedure to create port shadowing functions   */
/* for full byte, lower- and upper-nibbles        */
/* For 12- and 14-bit core                        */
/* input:  - Port register                        */
/* ---------------------------------------------- */
list_port1x_shadow: procedure expose jalfile
parse upper arg reg .
shadow = '_PORT'substr(reg,5)'_shadow'
call lineout jalfile, '--'
call lineout jalfile, 'var          byte  ' left('PORT'substr(reg,5),25) 'at _PORT'substr(reg,5)
call lineout jalfile, 'var          byte  ' left(shadow,25)
call lineout jalfile, '--'
call lineout jalfile, 'procedure' reg"'put"'(byte in x at' shadow') is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   _PORT'substr(reg,5) '=' shadow
call lineout jalfile, 'end procedure'
call lineout jalfile, '--'
half = 'PORT'substr(reg,5)'_low'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   'shadow '= ('shadow '& 0xF0) | (x & 0x0F)'
call lineout jalfile, '   _PORT'substr(reg,5) '=' shadow
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   return ('reg '& 0x0F)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
half = 'PORT'substr(reg,5)'_high'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   'shadow '= ('shadow '& 0x0F) | (x << 4)'
call lineout jalfile, '   _PORT'substr(reg,5) '=' shadow
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   return ('reg '>> 4)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
return


/* ------------------------------------------------ */
/* procedure to force use of LATx with 16-bits core */
/* for full byte, lower- and upper-nibbles          */
/* input:  - LATx register                          */
/* ------------------------------------------------ */
list_port16_shadow: procedure expose jalfile
parse upper arg lat .
port = 'PORT'substr(lat,4)                                  /* corresponding port */
call lineout jalfile, '--'
call lineout jalfile, 'procedure' port"'put"'(byte in x at' lat') is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, 'end procedure'
call lineout jalfile, '--'
half = 'PORT'substr(lat,4)'_low'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   'lat '= ('lat '& 0xF0) | (x & 0x0F)'
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   return ('port '& 0x0F)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
half = 'PORT'substr(lat,4)'_high'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   'lat '= ('lat '& 0x0F) | (x << 4)'
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   return ('port '>> 4)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
return


/* ---------------------------------------------- */
/* procedure to create TRIS functions             */
/* for lower- and upper-nibbles only              */
/* input:  - TRIS register                        */
/* ---------------------------------------------- */
list_tris_nibbles: procedure expose jalfile
parse upper arg reg .
call lineout jalfile, '--'
half = 'PORT'substr(reg,5)'_low_direction'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   'reg '= ('reg '& 0xF0) | (x & 0x0F)'
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   return ('reg '& 0x0F)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
half = 'PORT'substr(reg,5)'_high_direction'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   'reg '= ('reg '& 0x0F) | (x << 4)'
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   return ('reg '>> 4)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
return


/* -------------------------------------------------------- */
/* Special _extra_ formatting of STATUS register            */
/* input:  - index in .dev                                  */
/* remark: Is extra set of definitions for compiler only.   */
/*         Not intended for use by application programs.    */
/* -------------------------------------------------------- */
list_status: procedure expose Dev. jalfile Core msglevel
parse arg i .
do 4 until (word(Dev.i,1) = 'SFR' | word(Dev.i,1) = 'NMMR')  /* max 4 until next register */
   parse var Dev.i 'BIT' val0 'NAMES=' val1 'WIDTH=' val2 ')' .
   if val1 \= '' then do
      names = strip(strip(val1), 'B', "'")                  /* strip quotes */
      sizes = strip(strip(val2), 'B', "'")
      parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
      parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
      if Core = '12' | Core = '14' then                     /* baseline, midrange */
         fwidth = 25
      else
         fwidth = 32                                        /* core 14H */
      offset = 7                                            /* MSbit */
      do i = 1 to 8 while offset >= 0                       /* all bits */
         if n.i = '-' then do                               /* bit not present */
           offset = offset - s.i
         end
         else if datatype(s.i) = 'NUM' then do              /* field size */
            n.i = tolower(n.i)                              /* to lower case */
            if s.i = 1 then do                              /* single bit */
               if n.i = 'nto' then
                  call lineout jalfile, 'const        byte  ' left('_not_to',fwidth) '= ' offset
               else if n.i = 'npd' then
                  call lineout jalfile, 'const        byte  ' left('_not_pd',fwidth) '= ' offset
               else
                  call lineout jalfile, 'const        byte  ' left('_'n.i,fwidth) '= ' offset
               offset = offset - 1                          /* next bit */
            end
            else do j = s.i - 1 to 0 by -1                  /* enumerate */
               call lineout jalfile, 'const        byte  ' left('_'n.i||j,fwidth) '= ' offset
               offset = offset - 1
            end
         end
      end
   end
   i = i + 1                                                /* next record */
end
if Core = '16' then do
   call lineout jalfile, 'const        byte  ' left('_banked',32) '=  1'
   call lineout jalfile, 'const        byte  ' left('_access',32) '=  0'
end
return


/* --------------------------------------------------------- */
/* procedure to extend address with mirrored addresses       */
/* input:  - register number (decimal)                       */
/*         - address  (decimal)                              */
/* returns string of addresses between {}                    */
/* (not used for 16-bit core)                                */
/* --------------------------------------------------------- */
sfr_mirror: procedure expose Ram. BankSize NumBanks
parse upper arg addr .
addr_list = '{ 0x'D2X(addr)                                 /* open bracket, orig. addr */
do i = addr + BankSize to NumBanks * BankSize - 1 by BankSize /* avail ram */
   if addr = Ram.i then                                     /* matching reg number */
      addr_list = addr_list',0x'D2X(i)                      /* concatenate to string */
end
return addr_list' }'                                        /* complete string */


/* ---------------------------------------------------------------------- */
/* Formatting of 'pragma fusedef' lines                                   */
/* input:  - nothing                                                      */
/* Note:  some fuse_defs are omitted because the bit is not supported(!), */
/*        even if it is (partly) specified in the .dev file.              */
/*        See at the bottom of devicefiles.html for details.              */
/* ---------------------------------------------------------------------- */
list_fusedefs:   procedure expose Dev. jalfile CfgAddr. Fuse_Def. Core PicName msglevel
call lineout jalfile, '--'
call lineout jalfile, '-- =================================================='
call lineout jalfile, '--'
call lineout jalfile, '-- Symbolic Fuse definitions'
call lineout jalfile, '-- -------------------------'
k = 0                                                       /* config word count */
do i = 1 to dev.0                                           /* scan .dev file */
   if word(Dev.i,1) \= 'CFGBITS' then                       /* appropriate record */
      iterate
   ln = Dev.i
   parse var ln 'CFGBITS' '(' 'KEY' '=' val0 ' ADDR' '=' '0X' val1 'UNUSED' '=' '0X' val2 ')' .
   if val1 \= '' then do                                    /* address found */
      cfgword = strip(val0)                                 /* byte or word name */
      addr = strip(val1)                                    /* hex addr */
      call lineout jalfile, '--'
      call lineout jalfile, '--' cfgword '(0x'addr')'
      call lineout jalfile, '--'
      i = i + 1                                             /* next record */
      ln = dev.i                                            /* next line */
      do while i <= dev.0  &  word(ln, 1) \= 'CFGBITS'
         parse var ln 'FIELD' val0 'KEY=' val1 'MASK' '=' '0X' val2 'DESC' '=' '"' val3 '"'.
         key = strip(val1)

         if key \= '' then do                               /* key value found */
                                                            /* skip some superfluous bits */
            if ( key = 'RES' | key = 'RES1' | left(key,8) = 'RESERVED' )    |,
               ( pos('ENICPORT',key) > 0 )                          |,
               ( (key = 'CPD' | key = 'WRTD')  &,
                 (PicName = '18f2410' | PicName = '18f2510' |,
                  PicName = '18f2515' | PicName = '18f2610' |,
                  PicName = '18f4410' | PicName = '18f4510' |,
                  PicName = '18f4515' | PicName = '18f4610') )      |,
               ( (key = 'EBTR_3' | key = 'CP_3' | key = 'WRT_3') &,
                 (PicName = '18f4585') )                            |,
               ( (key = 'EBTR_4' | key = 'CP_4' | key = 'WRT_4' |,
                  key = 'EBTR_5' | key = 'CP_5' | key = 'WRT_5' |,
                  key = 'EBTR_6' | key = 'CP_6' | key = 'WRT_6' |,
                  key = 'EBTR_7' | key = 'CP_7' | key = 'WRT_7')  &,
                 (PicName = '18f6520' | PicName = '18f8520') )      then do
               i = i + 1
               ln = Dev.i
               iterate
            end

            select                                          /* reduce synonyms and */
                                                            /* correct MPLAB errors */
               when key = 'ADDRBW' then
                  key = 'ABW'
               when key = 'BACKBUG' | key = 'BKBUG' then
                  key = 'DEBUG'
               when key = 'BBSIZ0' then
                  key = 'BBSIZ'
               when key = 'BODENV' | key = 'BOR4V' | key = 'BORV' then
                  key = 'VOLTAGE'
               when key = 'BODEN' | key = 'BOREN' | key = 'DSBOREN' | key = 'BOD' | key = 'BOR' then
                  key = 'BROWNOUT'
               when key = 'CANMX' then
                  key = 'CANMUX'
               when left(key,3) = 'CCP' & right(key,2) = 'MX' then do
                  key = left(key,pos('MX',key)-1)'MUX'      /* CCP(x)MX -> CCP(x)MUX */
                  if key = 'CCPMUX' then
                     key = 'CCP1MUX'                        /* compatibility */
               end
               when key = 'CPDF' | key = 'CPSW' then
                  key = 'CPD'
               when left(key,3) = 'CP_' & datatype(substr(key,4),'W') = 1 then
                  key = 'CP'substr(key,4)                   /* remove underscore */
               when key = 'DATABW' then
                  key = 'BW'
               when left(key,4) = 'EBRT' then               /* typo in .dev files */
                  key = 'EBTR'substr(key,5)
               when left(key,5) = 'EBTR_' & datatype(substr(key,6),'W') = 1 then
                  key = 'EBTR'substr(key,6)                 /* remove underscore */
               when key = 'ECCPMX' | key = 'ECCPXM' then
                  key = 'ECCPMUX'                           /* ECCPxMX -> ECCPxMUX */
               when key = 'EXCLKMX' then
                  key = 'EXCLKMUX'
               when key = 'FLTAMX' then
                  key = 'FLTAMUX'
               when key = 'FOSC' | key = 'FOSC0' then
                  key = 'OSC'
               when key = 'FSCM' then
                  key = 'FCMEN'
               when key = 'MCLRE' then
                  key = 'MCLR'
               when key = 'MSSP7B_EN' | key = 'MSSPMSK' then
                  key = 'MSSPMASK'
               when key = 'P2BMX' then
                  key = 'P2BMUX'
               when key = 'PLL_EN' | key = 'CFGPLLEN' then
                  key = 'PLLEN'
               when key = 'MODE' | key = 'PM' then
                  key = 'PMODE'
               when key = 'PMPMX' then
                  key = 'PMPMUX'
               when key = 'PWM4MX' then
                  key = 'PWM4MUX'
               when key = 'PUT' | key = 'PWRT' | key = 'PWRTEN' |,
                    key = 'NPWRTE' | key = 'NPWRTEN' then
                  key = 'PWRTE'
               when key = 'RTCSOSC' then
                  key = 'RTCOSC'
               when key = 'SOSCEL' then
                  key = 'SOSCSEL'
               when key = 'SSPMX' then
                  key = 'SSPMUX'
               when key = 'STVREN' then
                  key = 'STVR'
               when key = T0CKMX then
                  key = 'T0CKMUX'
               when key = 'T1OSCMX' then
                  key = 'T1OSCMUX'
               when key = 'T3CMX' then
                  key = 'T3CMUX'
               when key = 'T3CKMX' then
                  key = 'T3CKMUX'
               when key = 'USBDIV'  &,                      /* compatibility */
                    (left(PicName,6) = '18f245' | left(PicName,6) = '18f255' |,
                     left(PicName,6) = '18f445' | left(PicName,6) = '18f455' ) then
                  key = 'USBPLL'
               when key = 'WDTEN' | key = 'WDTE' then
                  key = 'WDT'
               when key = 'WDPS' then
                  key = 'WDTPS'
               when key = 'WRT_ENABLE' | key = 'WRTEN' then
                  key = 'WRT'
               when left(key,4) = 'WRT_' & datatype(substr(key,5),'W') = 1 then
                  key = delstr(key,4,1)                     /* remove underscore from 'WRT_x' */
            otherwise
               nop                                          /* accept any other key asis */
            end

            if CfgAddr.0 > 1 then                           /* multi fuse bytes/words */
               str = 'pragma fuse_def' key':'X2D(addr) - CfgAddr.1 '0x'strip(val2) '{'
            else                                            /* single use word */
               str = 'pragma fuse_def' key '0x'strip(val2) '{'
            call lineout jalfile, left(str,40)'   --' tolower(strip(val3))

            call list_fusedef_details i, key, strip(val2) /* expand bit declations */

            call lineout jalfile, '       }'                /* done with this key */

         end
         i = i + 1
         ln = Dev.i
      end
   end
   i = i - 1                                                /* read one to many */
end
call lineout jalfile, '--'
return


/* ------------------------------------------------------------------------ */
/* Detailed formatting of fusedef lines                                     */
/* input:  - index of line in compound variable dev.                        */
/*         - keyword                                                        */
/*         - keyword mask (hex)                                             */
/* output: lines in jalfile                                                 */
/*                                                                          */
/* notes: val2 contains keyword description with undesired chars and blanks */
/*        val2u is val2 with all these replaced by a single underscore      */
/* ------------------------------------------------------------------------ */
list_fusedef_details: procedure expose Dev. Fuse_Def. jalfile Fuse_Def.,
                                          Core PicName msglevel
parse upper arg i, key, keymask .
kwd.     = '-'                                              /* empty kwd compound */
flag_enabled  = 0                                           /* to check for missing */
flag_disabled = 0                                           /* enable or disable */

if key = 'WDT' then do
   keybitcount = 0
   keybitcheck = X2C(1)
   do 8
      if bitand(X2C(keymask),keybitcheck) \= X2D('00') then do
         keybitcount = keybitcount + 1
      end
      keybitcheck = D2C(2 * C2D(keybitcheck))
   end
end

do i = i + 1  while i <= dev.0  &,
           (word(dev.i,1) = 'SETTING' | word(dev.i,1) = 'CHECKSUM')
   parse var Dev.i 'SETTING' val0 'VALUE' '=' '0X' val1 'DESC' '=' '"' val2 '"' .
   if val1 = '' then                                        /* no setting value found */
      iterate                                               /* skip to next line */

   mask = strip(val1)                                       /* bit mask (hex) */
   val2 = strip(val2)
   val2u = translate(val2, '                 ',,            /* to blank */
                           '+-:;.,<>{}[]()=/?')             /* from special char */
   val2u = space(val2u,,'_')                                /* blanks -> single underscore */

   kwd = ''                                                 /* null keyword */

   select                                                   /* key specific formatting */

      when key = 'ADCSEL'  |,                               /* ADC resolution */
           key = 'ABW'     |,                               /* address bus width */
           key = 'BW'    then do                            /* external memory bus width */
         parse value word(val2,1) with kwd '-' .            /* assign number */
         kwd = 'B'kwd                                       /* add prefix */
      end

      when key = 'BBSIZ' then do
         if val2 = 'ENABLED' then do
            kwd = val2
            flag_enabled = 1
         end
         else if val2 = 'DISABLED' then do
            kwd = val2
            flag_disabled = 1
         end
         else do j=1 to words(val2)
            if left(word(val2,j),1) >= '0' & left(word(val2,j),1) <= '9' then do
               kwd = 'W'word(val2,j)                          /* found leading digit */
               leave
            end
         end
         if datatype(substr(kwd,2),'W') = 1  &,             /* second char numeric */
             pos('KW',val2u) > 0 then do                    /* contains KW */
            kwd = kwd'K'                                    /* append 'K' */
         end
      end

      when key = 'BG' then do                               /* band gap */
         if word(val2,1) = 'HIGHEST' | word(val2,1) = 'LOWEST' then
            kwd = word(val2,1)
         else if word(val2,1) = 'ADJUST' then do
            if pos('-',val2) > 0 then                       /* negative voltage */
               kwd = word(val2,1)'_NEG'
            else
               kwd = word(val2,1)'_POS'
         end
         else
            kwd = val2u
      end

      when key = 'BORPWR' then do                           /* BOR power mode */
         if pos('ZPBORMV',val2u) > 0 then
            kwd = 'ZPBORMV'
         else if pos('HIGH_POWER',val2u) > 0 then
            kwd = 'HP_BORMV'
         else if pos('MEDIUM_POWER',val2u) > 0 then
            kwd = 'MP_BORMV'
         else if pos('LOW_POWER',val2u) > 0 then
            kwd = 'LP_BORMV'
         else
            kwd = val2u
      end

      when key = 'BROWNOUT' then do
         if  pos('SLEEP',val2u) > 0 & pos('DEEP_SLEEP',val2u) = 0 then
            kwd = 'RUNONLY'
         else if pos('HARDWARE_ONLY',val2u) > 0 then do
            kwd = 'ENABLED'
            flag_enabled = 1
         end
         else if pos('CONTROL',val2u) > 0 then
            kwd = 'CONTROL'
         else if pos('ENABLED',val2u) > 0 | val2u = 'ON' then do
            kwd = 'ENABLED'
            flag_enabled = 1
         end
         else do
            kwd = 'DISABLED'
            flag_disabled = 1
         end
      end

      when key = 'CANMUX' then do
         if pos('_RB', val2u) > 0 then
            kwd = 'pin_'substr(val2u, pos('_RB', val2u) + 2, 2)
         else if pos('_RC', val2u) > 0 then
            kwd = 'pin_'substr(val2u, pos('_RC', val2u) + 2, 2)
         else if pos('_RE', val2u) > 0 then
            kwd = 'pin_'substr(val2u, pos('_RE', val2u) + 2, 2)
         else
            kwd = val2u
      end

      when left(key,3) = 'CCP' & right(key,3) = 'MUX' then do /* CCPxMUX */
         if pos('MICRO',val2u) > 0 then                     /* Microcontroller mode */
            kwd = 'pin_E7'                                  /* valid for all current PICs */
         else if val2u = 'ENABLED' then do
            kwd = val2u
            flag_enabled = 1
         end
         else if val2u = 'DISABLED' then do
            kwd = val2u
            flag_disabled = 1
         end
         else
            kwd = 'pin_'right(val2u,2)                      /* last 2 chars */
      end

      when key = 'CINASEL' then do
         if pos('DEFAULT',val2u) > 0 then                   /* Microcontroller mode */
            kwd = 'DEFAULT'
         else
            kwd = 'MAPPED'
      end

      when key = 'CPUDIV' then do
         if word(val2,1) = 'NO' then
            kwd = 'P1'                                      /* no division */
         else if pos('DIVIDE',val2) > 0 & wordpos('BY',val2) > 0 then
            kwd = 'P'word(val2,words(val2))                 /* last word */
         else if pos('DIVIDE',val2) > 0 & wordpos('(NO',val2) > 0 then
            kwd = 'P'1                                      /* no divide */
         else if pos('/',val2) > 0 then
            kwd = 'P'substr(val2,pos('/',val2)+1,1)         /* digit after '/' */
         else
            kwd = val2u
      end

      when key = 'DSWDTOSC' then do
         if pos('INT',val2u) > 0 then
            kwd = 'INTOSC'
         else if pos('LPRC',val2u) > 0 then
            kwd = 'LPRC'
         else if pos('SOSC',val2u) > 0 then
            kwd = 'SOSC'
         else
            kwd = 'T1'
      end

      when key = 'DSWDTPS'   |,
           key = 'WDTPS' then do
         parse var val2 p0 ':' p1                           /* split */
         kwd = translate(word(p1,1),'      ','.,()=/')      /* 1st word, cleaned */
         kwd = space(kwd,0)                                 /* remove all spaces */
         do j=1 while kwd >= 1024
            kwd = kwd / 1024                                /* reduce to K, M, G, T */
         end
         kwd = 'P'format(kwd,,0)||substr(' KMGT',j,1)
      end

      when key = 'EBTRB' then do
         if pos('UNPROT',val2u) > 0 | pos('DISABLE',val2u) > 0 then do /* unprotected */
            kwd = 'DISABLED'
            flag_disabled = 1
         end
         else do
            kwd = 'ENABLED'
            flag_enabled = 1
         end
      end

      when key = 'ECCPMUX' then do
         if pos('_R',val2u) > 0 then                       /* check for _R<pin> */
            kwd = 'pin_'substr(val2u,pos('_R',val2u)+2,2)  /* 2 chars after '_R' */
         else
            kwd = val2u
      end

      when key = 'EMB' then do
         if pos('12',val2u) > 0 then                        /* 12-bit mode */
            kwd = 'B12'
         else if pos('16',val2u) > 0 then                   /* 16-bit mode */
            kwd = 'B16'
         else if pos('20',val2u) > 0 then                   /* 20-bit mode */
            kwd = 'B20'
         else
            kwd = 'DISABLED'                                /* no en/disable balancing */
      end

      when key = 'ETHLED' then do
         if pos('ETHERNET',val2u) > 0 | val2u = 'ENABLED' then do     /* LED enabled */
            kwd = 'ENABLED'
            flag_enabled = 1
         end
         else do
            kwd = 'DISABLED'
            flag_disabled = 1
         end
      end

      when key = 'EXCLKMUX' then do                         /* Timer0/5 clock pin */
         if pos('_R',val2u) > 0 then                       /* check for _R<pin> */
            kwd = 'pin_'substr(val2u,pos('_R',val2u)+2,2)  /* 2 chars after '_R' */
         else
            kwd = val2u
      end

      when key = 'FLTAMUX' then do
         if pos('_R',val2u) > 0 then                       /* check for _R<pin> */
            kwd = 'pin_'substr(val2u,pos('_R',val2u)+2,2)  /* 2 chars after '_R' */
         else
            kwd = val2u
      end

      when key = 'FOSC2' then do
         if pos('INTRC', val2u) > 0  |,
            val2 = 'ENABLED' then
            kwd = 'INTOSC'
         else
            kwd = 'OSC'
      end

      when key = 'FSCKM' then do                            /* Fail safe clock monitor */
         x1 = pos('ENABLED', val2u)
         x2 = pos('DISABLED', val2u)
         if x1 > 0 & x2 > 0 & x2 > x1 then
            kwd  = 'SWITCHING'
         else if x1 > 0 & x2 = 0 then
            kwd  = 'ENABLED'
         else if x1 = 0 & x2 > 0 then
            kwd  = 'DISABLED'
         else
            kwd = val2u
      end

      when key = 'HFOFST' then do
         if pos('STABLE',val2u) > 0 | pos('ENABLE',val2u) > 0 then do
            kwd = 'ENABLED'
            flag_enabled = 1
         end
         else do
            kwd = 'DISABLED'
            flag_disabled = 1
         end
      end

      when key = 'INTOSCSEL' then do
         if pos('HIGH_SECURITY',val2u) > 0 then
            kwd = 'HS_CP'
         else if pos('LOW_POWER',val2u) > 0 then
            kwd = 'LF_INTOSC'
         else
            kwd = val2u
      end

      when key = 'IOSCFS' then do
         if pos('MHZ',val2u) > 0 then do
            if pos('8',val2u) > 0 then                       /* 8 MHz */
               kwd = 'F8MHZ'
            else
               kwd = 'F4MHZ'                                /* otherwise */
         end
         else if val2u = 'ENABLED' then
            kwd = 'F8MHZ'
         else if val2u = 'DISABLED' then
            kwd = 'F4MHZ'                                   /* otherwise */
         else do
            kwd = val2u
            if left(kwd,1) >= '0' & left(kwd,1) <= '9' then
               kwd = 'F'kwd                                 /* prefix when numeric */
         end
      end

      when key = 'LPT1OSC' then do
         if pos('LOW',val2u) > 0 | pos('ENABLE',val2u) > 0 then
            kwd = 'LOW_POWER'
         else
            kwd = 'HIGH_POWER'
         end

      when key = 'LS48MHZ' then do
         if pos('TO_4',val2u) > 0 then
            kwd = 'P4'
         else if pos('TO_8',val2u) > 0 then
            kwd = 'P8'
         else if pos('BY_2',val2u) > 0 then
            kwd = 'P2'
         else if pos('BY_1',val2u) > 0 then
            kwd = 'P1'
         else
            kwd = val2u
      end

      when key = 'LVP' then do
         if pos('ENABLE',val2u) > 0 then do
            kwd = 'ENABLED'
            flag_enabled = 1
         end
         else do
            kwd = 'DISABLED'
            flag_disabled = 1
         end
      end

      when key = 'MCLR' then do
         if pos('EXTERN',val2) > 0           |,
            pos('MCLR ENABLED',val2) > 0     |,
            pos('MCLR PIN ENABLED',val2) > 0 |,
            pos('MASTER',val2) > 0           |,
            pos('AS MCLR',val2) > 0          |,
            pos('IS MCLR',val2) > 0          |,
            val2 = 'MCLR'                    |,
            val2 = 'ENABLED'   then
            kwd = 'EXTERNAL'
         else
            kwd = 'INTERNAL'
      end

      when key = 'MSSPMASK'  |,
           key = 'MSSPMSK1'  |,
           key = 'MSSPMSK2' then do
         if left(val2,1) >= 0  &  left(val2,1) <= '9' then
            kwd = 'B'left(val2, 1)                          /* digit 5 or 7 expected */
         else
            kwd = val2u
      end

      when key = 'OSC' then do
         kwd = Fuse_Def.Osc.val2u
         if kwd = '?' then do
            call msg 2, 'No mapping for fuse_def' key':' val2u
/* ???      return    */
         end
         else if val2u = 'INTOSC'  & ,
                (PicName = '16f913' | PicName = '16f914'|,
                 PicName = '16f916' | PicName = '16f917') then do /* exception */
            kwd = 'INTOSC_CLKOUT'                           /* correction of map: NOCLKOUT */
         end
      end

      when key = 'P2BMUX' then do
         if substr(val2u,length(val2u)-3,2) = '_R' then     /* check for _R<pin> */
            kwd = 'pin_'right(val2u,2)
         else
            kwd = val2u
      end

      when key = 'PBADEN' then do
         if pos('ANALOG',val2u) > 0  |  val2 = 'ENABLED' then
            kwd = 'ANALOG'
         else
            kwd = 'DIGITAL'
      end

      when key = 'PLLDIV' then do
         if val2u = 'RESERVED' then
            kwd = '   '                                     /* to be ignored */
         else if left(val2u,6) = 'NO_PLL' then
            kwd = 'P0'                                      /* No PLL */
         else if right(word(val2,1),1) = 'X' then
            kwd = 'X'||strip(word(val2,1),'T','X')          /* multiplier */
         else if left(val2u,9) = 'DIVIDE_BY' then
            kwd = 'P'||word(val2,3)                         /* 3rd word */
         else if wordpos('DIVIDED BY', val2) > 0 then
            kwd = 'P'||word(val2, wordpos('DIVIDED BY', val2) + 2)    /* word after 'devided by' */
         else if word(val2,1) = 'NO' |,
                 pos('NO_DIVIDE', val2u) > 0 then
            kwd = 'P1'
         else
            kwd = val2u
      end

      when key = 'PLLEN' then do
         if pos('MULTIPL',val2) > 0 then
            kwd = 'P'word(val2, words(val2))                /* last word */
         else if pos('DIRECT',val2) > 0 | pos('DISABLED',val2) > 0 then do
            kwd = 'P1'
            if left(PicName,4) = '16f7'                     /* compatibility */
               then kwd = 'F500KHZ'
         end
         else if pos('ENABLED',val2) > 0 then do
            kwd = 'P4'
            if left(PicName,4) = '16f7'                     /* compatibility */
               then kwd = 'F16MHZ'
         end
         else if datatype(left(val2,1),'W') = 1 then
            kwd = 'F'val2u
         else
            kwd = val2u
      end

      when key = 'PMODE' then do
         if pos('EXT',val2) > 0 then do
            if pos('-BIT', val2) > 0 then
               kwd = 'B'substr(val2, pos('-BIT',val2)-2, 2) /* # bits */
            else
               kwd = 'EXT'
         end
         else if pos('PROCESSOR',val2) > 0 then do
            kwd = 'MICROPROCESSOR'
            if pos('BOOT',val2u) > 0 then
               kwd = kwd'_BOOT'
         end
         else
            kwd = 'MICROCONTROLLER'
      end

      when key = 'PMPMUX' then do
         if wordpos('ON',val2) > 0 then                     /* contains ' ON ' */
            kwd = left(word(val2, wordpos('ON',val2) + 1),5)
         else if wordpos('ELSEWHERE',val2) > 0  |,          /* contains ' ELSEWHERE ' */
                 wordpos(' NOT ',val2) > 0 then             /* contains ' NOT ' */
            kwd = 'ELSEWHERE'
         else if wordpos('NOT',val2) = 0 then               /* does not contain ' NOT ' */
            kwd = left(word(val2, wordpos('TO',val2) + 1),5)
         else
            kwd = val2u
      end

      when key = 'POSCMD' then do                           /* primary osc */
         if pos('DISABLED',val2u) > 0 then                  /* check for _R<pin> */
            kwd = 'DISABLED'
         else if pos('HS', val2u) > 0 then
            kwd = 'HS'
         else if pos('MS', val2u) > 0 then
            kwd = 'MS'
         else if pos('EXTERNAL', val2u) > 0 then
            kwd = 'EC'
         else
            kwd = val2u
      end

      when key = 'PWM4MUX' then do
         if pos('_R',val2u) > 0 then                       /* check for _R<pin> */
            kwd = 'pin_'substr(val2u,pos('_R',val2u)+2,2)  /* 2 chars after '_R' */
         else
            kwd = val2u
      end

      when key = 'RTCOSC' then do
         if pos('INTRC',val2u) > 0 then
            kwd = 'INTRC'
         else
            kwd = 'T1OSC'
      end

      when key = 'SIGN' then do
         if pos('CONDUC',val2u) > 0 then
            kwd = 'NOT_CONDUCATED'
         else
            kwd = 'AREA_COMPLETE'
      end

      when key = 'SOSCSEL' then do
         if pos('T1OSC',val2u) > 0 then
            kwd = 'T1OSC'
         else if pos('DIGITAL',val2u) then
            kwd = 'SCLKI'
         else if pos('SECURITY',val2u) > 0 then
            kwd = 'HS_CP'
         else if pos('HIGH_POWER',val2u) > 0 then
            kwd = 'HP_SOSC'
         else if pos('LOW_POWER',val2u) > 0 then
            kwd = 'LP_SOSC'
         else
            kwd = val2u
      end

      when key = 'SSPMUX' then do
         offset1 = pos('_MULTIPLEX',val2u)
         if offset1 > 0 then do                             /* 'multiplexed' found */
            offset2 = pos('_R',substr(val2u,offset1))       /* first pin */
            if offset2 > 0 then
               kwd = 'pin_'substr(val2u,offset1+offset2+1,2)
            else
               kwd = 'ENABLED'
         end
         else
            kwd = 'DISABLED'                                /* no en/disable balancing */
      end

      when key = 'T0CKMUX' then do
         if pos('_RB', val2u) > 0 then
            kwd = 'pin_'substr(val2u, pos('_RB', val2u) + 2, 2)
         else if pos('_RG', val2u) > 0 then
            kwd = 'pin_'substr(val2u, pos('_RG', val2u) + 2, 2)
         else
            kwd = val2u
      end

      when key = 'T1OSCMUX' then do
         if left(right(val2u,4),2) = '_R' then
            kwd = 'pin_'right(val2u,2)                      /* last 2 chars */
         else
            kwd = val2u
      end

      when key = 'T3CKMUX' then do
         if pos('_RB', val2u) > 0 then
            kwd = 'pin_'substr(val2u, pos('_RB', val2u) + 2, 2)
         else if pos('_RG', val2u) > 0 then
            kwd = 'pin_'substr(val2u, pos('_RG', val2u) + 2, 2)
         else
            kwd = val2u
      end

      when key = 'T3CMUX' then do
         if pos('_R',val2u) > 0 then                        /* check for _R<pin> */
            kwd = 'pin_'substr(val2u,pos('_R',val2u)+2,2)   /* 2 chars after '_R' */
         else
            kwd = val2u
      end

      when key = 'T5GSEL' then do
         if pos('T3G',val2u) > 0 then
            kwd = 'T3G'
         else
            kwd = 'T5G'
      end

      when key = 'USBDIV' then do                           /* mplab >= 8.60 (was USBPLL) */
         if val2u = 'ENABLED' | pos('96_MH',val2u) > 0 | pos('DIVIDED_BY',val2u) > 0 then
            kwd = 'P4'                                  /* compatibility */
         else
            kwd = 'P1'                                      /* compatibility */
      end

      when key = 'USBLSCLK' then do
         if pos('48',val2u) > 0 then
            kwd = 'F48MHZ'
         else
            kwd = 'F24MHZ'
      end

      when key = 'USBPLL' then do
         if pos('PLL',val2u) > 0 then
            kwd = 'F48MHZ'
         else
            kwd = 'OSC'
      end

      when key = 'VCAPEN' then do
         if pos('DISABLED',val2) > 0 then
            kwd = 'DISABLED'
         else if pos('ENABLED',val2) > 0 then do
            kwd = word(val2, words(val2))                 /* last word */
            if left(kwd,1) = 'R' then                       /* pinname Rxy */
               kwd = 'pin_'substr(kwd,2)                    /* make it pin_xy */
         end
         else
            kwd = 'ENABLED'                                 /* probably never reached */
      end

      when key = 'VOLTAGE' then do
         do j=1 to words(val2)                              /* scan word by word */
            if left(word(val2,j),1) >= '0' & left(word(val2,j),1) <= '9' then do
               if pos('.',word(val2,j)) > 0 then do         /* select digits */
                  kwd = 'V'left(word(val2,j),1,1)||substr(word(val2,j),3,1)
                  if kwd = 'V21' then
                     kwd = 'V20'                            /* compatibility */
                  leave                                     /* done */
               end
            end
         end
         if j > words(val2) then do                        /* no voltage value found */
            if pos('MINIMUM',val2) > 0  |,
               pos(' LOW ',val2) > 0 then
               kwd = 'MINIMUM'
            else if pos('MAXIMUM',val2) > 0 |,
               pos(' HIGH ',val2) > 0 then
               kwd = 'MAXIMUM'
            else
               kwd = val2u
         end
      end

      when key = 'WAIT' then do
         if pos('NOT',val2u) > 0 | pos('DISABLE',val2u) > 0 then do
            kwd = 'DISABLED'
            flag_disabled = 1
         end
         else do
            kwd = 'ENABLED'
            flag_enabled = 1
         end
      end

      when key = 'WDT' then do                              /* Watchdog */
         pos_en = pos('ENABLE', val2u)
         pos_dis = pos('DISABLE', val2u)
         if pos('RUNNING', val2u) > 0 |,
            pos('DISABLED_IN_SLEEP', val2u) > 0 then
            kwd = 'RUNONLY'
         else if val2u = 'OFF' | (pos_dis > 0 & (pos_en = 0 | pos_en > pos_dis)) then do
            kwd = 'DISABLED'
            flag_disabled = 1
         end
         else if pos('HARDWARE', val2u) > 0 then do
            kwd = 'HARDWARE'
         end
         else if pos('CONTROL', val2u) > 0  then do
            if core = 16  &  keybitcount = 1  then          /* can only be en- or dis-abled */
               kwd = 'DISABLED'                             /* all 18Fs */
            else
               kwd = 'CONTROL'
         end
         else if val2u = 'ON' | (pos_en > 0 & (pos_dis = 0 | pos_dis > pos_en)) then do
            kwd = 'ENABLED'
            flag_enabled = 1
         end
         else
            kwd = val2u                                     /* normalized description */
      end

      when key = 'WDTCLK' then do
         if pos('ALWAYS',val2u) > 0 then do
            if pos('INTOSC', val2u) > 0 then
                kwd = 'INTOSC'
            else
                kwd = 'SOCS'
         end
         else if pos('FRC',val2u) > 0 then
            kwd = 'FRC'
         else if pos('FOSC_4',val2u) > 0 then
            kwd = 'FOSC'
         else
            kwd = val2u
      end

      when key = 'WDTCS' then do
         if pos('LOW',val2u) > 0 then
            kwd = 'LOW_POWER'
         else
            kwd = 'STANDARD'
      end

      when key = 'WDTWIN' then do
         x = pos('WIDTH_IS', val2u)
         if x > 0 then
            kwd = 'P'substr(val2u, x + 9, 2)                 /* percentage */
         else
            kwd = val2u
      end

      when key = 'WPEND' then do
         if pos('PAGES_0', val2u) > 0  | pos('PAGE_0', val2u) > 0  then
            kwd = 'P0_WPFP'
         else
            kwd = 'PWPFP_END'
      end

      when key = 'WPFP' then do
         kwd = 'P'word(val2, words(val2))                   /* last word */
      end

      when key = 'WPSA' then do
         x = pos(':', val2)                                 /* fraction */
         if x > 0 then
            kwd = 'P'substr(val2, x + 1)                    /* divisor */
         else
            kwd = val2u
      end

      when key = 'WRT' then do
         if val2u = 'ENABLED' | val2u = 'DISABLED' then do
            if val1 > 0 then                                /* (any) bit(s) on */
               kwd = 'NO_PROTECTION'
            else
               kwd = 'ALL_PROTECTED'
         end
         else if pos('NO ADDRESSES', val2) > 0  then
            kwd = 'ALL_PROTECTED'
         else if pos('OFF',val2u) > 0    |,
                 pos('UNPROT',val2u) > 0 then
            kwd = 'NO_PROTECTION'
         else if left(Val2,1) = '0' then do                 /* memory range */
            parse var Val2 '0X'aa '-' '0X'zz .
            if zz = '' then do
               parse var Val2 aa'H' 'TO' zz'H' .
               if zz = '' then do
                  parse var Val2 aa 'TO' zz .
                  if zz = '' then do
                     parse var Val2 aa '-' zz .
                end
              end
            end
            kwd = 'R'right(strip(aa),4,'0')'_'right(strip(zz),4,'0')
         end
         else do
           kwd = val2u                                      /* normalized text */
         end
      end

   otherwise                                                /* generic formatting */
      if pos('ACTIVE',val2) > 0 then do
         if pos('HIGH',val2) > pos('ACTIVE',val2) then
            kwd = 'ACTIVE_HIGH'
         else if pos('LOW',val2) > pos('ACTIVE',val2) then
            kwd = 'ACTIVE_LOW'
         else do
            kwd = 'ENABLED'
            flag_enabled = 1
         end
      end
      else if pos('ENABLE',val2) > 0 | val2 = 'ON' | val2 = 'ALL' then do
         kwd = 'ENABLED'
         flag_enabled = 1
      end
      else if pos('DISABLE',val2) > 0 | val2 = 'OFF' then do
         kwd = 'DISABLED'
         flag_disabled = 1
      end
      else if pos('ANALOG',val2) > 0 then
         kwd = 'ANALOG'
      else if pos('DIGITAL',val2) > 0 then
         kwd = 'DIGITAL'
      else do
         if left(val2,1) >= '0' & left(val2,1) <= '9' then do /* starts with digit */
            if pos('HZ',val2) > 0  then                     /* probably frequency (range) */
               kwd = 'F'val2u                               /* 'F' prefix */
            else if pos(' TO ',val2) > 0  |,                /* probably a range */
                    pos('0 ',  val2) > 0  |,
                    pos(' 0',  val2) > 0  |,
                    pos('H-',  val2) > 0  then do
               if pos(' TO ',val2) > 0  then do
                  kwd = delword(val2,4)                     /* keep 1st three words */
                  kwd = delword(kwd,2,1)                    /* keep only 'from' and 'to' */
                  kwd = translate(kwd, ' ','H')             /* replace 'H' by space */
                  kwd = space(kwd,1,'_')                    /* single underscore */
               end
               else
                  kwd = word(val2,1)                        /* keep 1st word */
               kwd = 'R'translate(kwd,'_','-')              /* 'R' prefix, hyphen->underscore */
            end
            else do                                         /* probably a number */
               kwd = 'N'SysMapCase(word(val2,1))            /* 1st word, 'N' prefix */
            end
         end
         else
            kwd = val2u                                     /* if no alternative! */
      end
   end

   if kwd = '   ' then                                      /* special ('...') */
      nop                                                   /* ignore */
   else if kwd = '' then                                    /* empty keyword */
      call msg 3, 'No keyword found for fuse_def' key '('val2')'
   else if kwd.kwd = '-' then do                            /* unique (not duplicate) */
      kwd.kwd = kwd                                         /* remember keyword */
      if length(kwd) > 22  then
         call msg 2, 'fuse_def' key 'keyword excessively long: "'kwd'"'
      str = '       'kwd '= 0x'mask
      if length(str) < 40 then                              /* 'short' */
         str = left(str,40)                                 /* alignment of comments */
      call lineout jalfile, str'   --' tolower(val2)
   end
   else                                                     /* duplicate kwd */
      call msg 2, 'Duplicate keyword for fuse_def' key':' kwd '('val2u')'

end

if flag_enabled \= flag_disabled then                       /* unbalanced */
   call msg 2, 'Possibly unbalanced enabled/disabled keywords for fuse_def' key
return


/* ----------------------------------------------------------------------------- *
 * Generate functions w.r.t. analog modules.                                     *
 * First individual procedures for different analog modules                      *
 * to put the  corresponding pins in digital-I/O mode,                           *
 * then the procedure 'enable_digital_io()' which invokes these procedures       *
 * as far as present in this device file.                                        *
 *                                                                               *
 * Possible combinations for the different PICS:                                 *
 * ANSEL   [ANSELH]                                                              *
 * ANSEL0  [ANSEL1]                                                              *
 * ANSELA  [ANSELB  ANSELC  ANSELD  ANSELE  ANSELF  ANSELG]                      *
 * ANCON0  [ANCON1  ANCON2  ANCON3]                                              *
 * ADCON0  [ADCON1  ADCON2  ADCON3]                                              *
 * CMCON                                                                         *
 * CMCON0  [CMCON1]                                                              *
 * CM1CON  [CM2CON]                                                              *
 * CM1CON0 [CM1CON1  CM2CON0 CM2CON1 CM3CON0 CM3CON1]                            *
 * CM1CON1 [CM2CON1]                                                             *
 * Between brackets not always present.                                          *
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
 * PICs are classified in groups for ADC module settings.                        *
 * Below the register settings for all-digital I/O:                              *
 * ADC_V0    ADCON0 = 0b0000_0000 [ADCON1 = 0b0000_0000]                         *
 *           ANSEL0 = 0b0000_0000  ANSEL1 = 0b0000_0000  (or ANSEL_/H,A/B/D/E)   *
 * ADC_V1    ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0111                          *
 * ADC_V2    ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111                          *
 * ADC_V3    ADCON0 = 0b0000_0000  ADCON1 = 0b0111_1111                          *
 * ADC_V4    ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111                          *
 * ADC_V5    ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111                          *
 * ADC_V6    ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111                          *
 * ADC_V7    ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000  ADCON2 = 0b0000_0000    *
 *           ANSEL0 = 0b0000_0000  ANSEL1 = 0b0000_0000                          *
 * ADC_V7_1  ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000  ADCON2 = 0b0000_0000    *
 *           ANSEL  = 0b0000_0000 [ANSELH = 0b0000_0000]                         *
 * ADC_V8    ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000  ADCON2 = 0b0000_0000    *
 *           ANSEL  = 0b0000_0000  ANSELH = 0b0000_0000                          *
 * ADC_V9    ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000                          *
 *           ANCON0 = 0b1111_1111  ANCON1 = 0b1111_1111                          *
 * ADC_V10   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000                          *
 *           ANSEL  = 0b0000_0000  ANSELH = 0b0000_0000                          *
 * ADC_V11   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000                          *
 *           ANCON0 = 0b1111_1111  ANCON1 = 0b1111_1111                          *
 * ADC_V11_1 ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000                          *
 *           ANCON0 = 0b1111_1111  ANCON1 = 0b1111_1111                          *
 * ADC_V12   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111  ADCON2 = 0b0000_0000    *
 * ADC_V13   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111  ADCON2 = 0b0000_0000    *
 * ADC_V13_1 ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111  ADCON2 = 0b0000_0000    *
 * ADC_V13_2 ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111  ADCON2 = 0b0000_0000    *
 * ADC_V14   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111  ADCON2 = 0b0000_0000    *
 * ADC_V14_1 ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111  ADCON2 = 0b0000_0000    *
 * ----------------------------------------------------------------------------- */
list_analog_functions: procedure expose jalfile Name. Core DevSpec. PinMap. ,
                                        adcs_bitcount PicName msglevel
call lineout jalfile, '--'
call lineout jalfile, '-- ==================================================='
call lineout jalfile, '--'
call lineout jalfile, '-- Special (device specific) constants and procedures'
call lineout jalfile, '--'
PicNameCaps = SysMapCase(PicName)
if DevSpec.PicNameCaps.ADCgroup = '?' then do               /* no ADC group specified */
   if (Name.ADCON \= '-' | Name.ADCON0 \= '-' | Name.ADCON1 \= '-') then do
      call msg 3, 'PIC has ADCONx register, but no ADCgroup found in devicespecific.json!'
   end
   ADCgroup = '0'                                           /* no ADC group */
end
else
   ADCgroup = DevSpec.PicNameCaps.ADCgroup

if  PinMap.PicNameCaps.ANCOUNT = '?' |,                     /* PIC not in pinmap.cmd? */
    ADCGroup = '0'  then                                    /* PIC has no ADC module */
   PinMap.PicNameCaps.ANCOUNT = 0
call charout jalfile, 'const ADC_GROUP = 'ADCgroup
if ADCgroup = '0' then
   call charout jalfile, '             -- no ADC module present'
call lineout jalfile, ''
call lineout jalfile, 'const byte ADC_NTOTAL_CHANNEL =' PinMap.PicNameCaps.ANCOUNT
call lineout jalfile, 'const byte ADC_ADCS_BITCOUNT  =' adcs_bitcount
call lineout jalfile, '--'

if DevSpec.PicNameCaps.PPSgroup = '?' then
   call lineout jalfile, 'const PPS_GROUP  = PPS_0        -- no Peripheral Pin Selection'
else
   call lineout jalfile, 'const PPS_GROUP  = 'DevSpec.PicNameCaps.PPSgroup,
                         '       -- PPS group' right(DevSpec.PicNameCaps.PPSgroup,1)
call lineout jalfile, '--'

if Name.UCON \= '-' then do                                 /* USB module present */
   if DevSpec.PicNameCaps.USBBDT \= '?' then
      call lineout jalfile, 'const word USB_BDT_ADDRESS    = 0x'DevSpec.PicNameCaps.USBBDT
   else
      call msg 2, PicName 'has USB module but USB_BDT_ADDRESS not specified'
   call lineout jalfile, '--'
end

if (ADCgroup = '0'  & PinMap.PicNameCaps.ANCOUNT > 0) |,
   (ADCgroup \= '0' & PinMap.PicNameCaps.ANCOUNT = 0) then do
   call msg 2, 'Possible conflict between ADC-group ('ADCgroup')',
          'and number of ADC channels ('PinMap.PicNameCaps.ANCOUNT')'
end
analog. = '-'                                               /* no analog modules */

if Name.ANSEL  \= '-' |,                                    /*                       */
   Name.ANSEL1 \= '-' |,                                    /*                       */
   Name.ANSELA \= '-' |,                                    /* any of these declared */
   Name.ANSELC \= '-' |,                                    /*                       */
   Name.ANCON0 \= '-' |,                                    /*                       */
   Name.ANCON1 \= '-' then do                               /*                       */
   analog.ANSEL = 'analog'                                  /* analog functions present */
   call lineout jalfile, '-- - - - - - - - - - - - - - - - - - - - - - - - - - -'
   call lineout jalfile, '-- Change analog I/O pins into digital I/O pins.'
   call lineout jalfile, 'procedure analog_off() is'
   call lineout jalfile, '   pragma inline'
   if Name.ANSEL \= '-' then                                /* ANSEL declared */
      call lineout jalfile, '   ANSEL  = 0b0000_0000       -- digital I/O'
   do i = 0 to 9                                            /* ANSEL0..ANSEL9 */
      qname = 'ANSEL'i                                      /* qualified name */
      if Name.qname \= '-' then                             /* ANSELi declared */
         call lineout jalfile, '   'qname '= 0b0000_0000       -- digital I/O'
   end
   suffix = XRANGE('A','Z')                                 /* suffix letters A..Z */
   do i = 1 to length(suffix)
      qname = 'ANSEL'substr(suffix,i,1)                     /* qualified name */
      if Name.qname \= '-' then                             /* ANSELx declared */
         call lineout jalfile, '   'qname '= 0b0000_0000        -- digital I/O'
   end
   do i = 0 to 9                                            /* ANCON0..ANCON9 */
      qname = 'ANCON'i                                      /* qualified name */
      if Name.qname \= '-' then do                          /* ANCONi declared */
         j = 8 * i                                          /* PCFG bit */
         bitname = qname'_PCFG'j
         if Name.bitname \= '-' then                        /* ANCON has PCFG bits */
            call lineout jalfile, '   'qname '= 0b1111_1111        -- digital I/O'
         else do
            if i > 0 & Name.ANCON0 = '-' then               /* PIC has no ANCON0 */
               j = 8 * (i - 1)                              /* alternative counting */
            bitname = 'JANSEL_ANS'j                         /* JANSEL bit */
            if Name.bitname \= '-' then                     /* ANCON has ANS(EL) bit(s) */
               call lineout jalfile, '   'qname '= 0b0000_0000        -- digital I/O'
         end
      end
   end
   call lineout jalfile, 'end procedure'
   call lineout jalfile, '--'
end

if Name.ADCON0 \= '-' |,                                    /* check on presence */
   Name.ADCON  \= '-' then do
   analog.ADC = 'adc'                                       /* ADC module present */
   call lineout jalfile, '-- - - - - - - - - - - - - - - - - - - - - - - - - - -'
   call lineout jalfile, '-- Disable ADC module'
   call lineout jalfile, 'procedure adc_off() is'
   call lineout jalfile, '   pragma inline'
   if Name.ADCON0 \= '-' then
      call lineout jalfile, '   ADCON0 = 0b0000_0000         -- disable ADC'
   else
      call lineout jalfile, '   ADCON  = 0b0000_0000         -- disable ADC'
   if Name.ADCON1 \= '-' then do                            /* ADCON1 declared */
      if ADCgroup = 'ADC_V1' then
         call lineout jalfile, '   ADCON1 = 0b0000_0111         -- digital I/O'
      else if ADCgroup = 'ADC_V2'     |,
              ADCgroup = 'ADC_V4'     |,
              ADCgroup = 'ADC_V5'     |,
              ADCgroup = 'ADC_V6'     |,
              ADCgroup = 'ADC_V12'    then
         call lineout jalfile, '   ADCON1 = 0b0000_1111'
      else if ADCgroup = 'ADC_V3' then
         call lineout jalfile, '   ADCON1 = 0b0111_1111'
      else do                                               /* all other ADC groups */
         call lineout jalfile, '   ADCON1 = 0b0000_0000'
         if Name.ADCON1_PCFG \= '-' then
            call msg 2, 'ADCON1_PCFG field present: PIC maybe in wrong ADC_GROUP'
      end
      if Name.ADCON2 \= '-' then                            /* ADCON2 declared */
         call lineout jalfile, '   ADCON2 = 0b0000_0000'    /* all groups */
   end
   call lineout jalfile, 'end procedure'
   call lineout jalfile, '--'
end

if Name.CMCON   \= '-' |,
   Name.CMCON0  \= '-' |,
   Name.CM1CON  \= '-' |,
   Name.CM1CON0 \= '-' |,
   Name.CM1CON1 \= '-' then do
   analog.CMCON = 'comparator'                              /* Comparator present */
   call lineout jalfile, '-- - - - - - - - - - - - - - - - - - - - - - - - - - -'
   call lineout jalfile, '-- Disable comparator module'
   call lineout jalfile, 'procedure comparator_off() is'
   call lineout jalfile, '   pragma inline'
   select
      when Name.CMCON \= '-' then
         if Name.CMCON_CM \= '-' then
            call lineout jalfile, '   CMCON  = 0b0000_0111        -- disable comparator'
         else
            call lineout jalfile, '   CMCON  = 0b0000_0000        -- disable comparator'
      when Name.CMCON0 \= '-' then do
         if Name.CMCON0_CM \= '-' then
            call lineout jalfile, '   CMCON0 = 0b0000_0111        -- disable comparator'
         else
            call lineout jalfile, '   CMCON0 = 0b0000_0000        -- disable comparator'
         if Name.CMCON1 \= '-' then
            call lineout jalfile, '   CMCON1 = 0b0000_0000'
      end
      when Name.CM1CON \= '-' then do
         if Name.CM1CON_CM \= '-' then
            call lineout jalfile, '   CM1CON = 0b0000_0111        -- disable comparator'
         else
            call lineout jalfile, '   CM1CON = 0b0000_0000        -- disable comparator'
         if Name.CM2CON \= '-' then
            call lineout jalfile, '   CM2CON = 0b0000_0000        -- digital I/O'
         if Name.CM3CON \= '-' then
            call lineout jalfile, '   CM3CON = 0b0000_0000'
      end
      when Name.CM1CON0 \= '-' then do
         call lineout jalfile, '   CM1CON0 = 0b0000_0000       -- disable comparator'
         if Name.CM1CON1 \= '-' then
            call lineout jalfile, '   CM1CON1 = 0b0000_0000'
         if Name.CM2CON0 \= '-' then do
            call lineout jalfile, '   CM2CON0 = 0b0000_0000       -- disable 2nd comparator'
            if Name.CM2CON1 \= '-' then
               call lineout jalfile, '   CM2CON1 = 0b0000_0000'
         end
         if Name.CM3CON0 \= '-' then do
            call lineout jalfile, '   CM3CON0 = 0b0000_0000        -- disable 3rd comparator'
            if Name.CM3CON1 \= '-' then
               call lineout jalfile, '   CM3CON1 = 0b0000_0000'
         end
      end
      when Name.CM1CON1 \= '-' then do
         call lineout jalfile, '   CM1CON1 = 0b0000_0000       -- disable comparator'
         if Name.CM2CON1 \= '-' then
            call lineout jalfile, '   CM2CON1 = 0b0000_0000       -- disable 2nd comparator'
      end
   otherwise                                                /* not possible with 'if' at top */
      nop
   end
   call lineout jalfile, 'end procedure'
   call lineout jalfile, '--'
end

call lineout jalfile, '-- - - - - - - - - - - - - - - - - - - - - - - - - - -'
call lineout jalfile, '-- Switch analog ports to digital mode (if analog module present).'
call lineout jalfile, 'procedure enable_digital_io() is'
call lineout jalfile, '   pragma inline'

if analog.ANSEL \= '-' then
   call lineout jalfile, '   analog_off()'
if analog.ADC \= '-' then
   call lineout jalfile, '   adc_off()'
if analog.CMCON \= '-' then
   call lineout jalfile, '   comparator_off()'

if core = 12 then do                                        /* baseline PIC */
   call lineout jalfile, '   OPTION_REG_T0CS = OFF        -- T0CKI pin input + output'
end
call lineout jalfile, 'end procedure'
return


/* --------------------------------------- */
/* Generate common header                  */
/* --------------------------------------- */
list_head:
call lineout jalfile, '-- ==================================================='
call lineout jalfile, '-- Title: JalV2 device include file for PIC'SysMapCase(PicName)
call list_copyright_etc jalfile
call lineout jalfile, '-- Description:'
call lineout Jalfile, '--    Device include file for pic'PicName', containing:'
call lineout jalfile, '--    - Declaration of ports and pins of the chip.'
if core \= '16' then do                                     /* for the baseline and midrange */
   call lineout jalfile, '--    - Procedures for shadowing of ports and pins'
   call lineout jalfile, '--      to circumvent the read-modify-write problem.'
end
else do                                                     /* for the 18F series */
   call lineout jalfile, '--    - Procedures to force the use of the LATx register'
   call lineout jalfile, '--      when PORTx is addressed for output.'
end
call lineout jalfile, '--    - Symbolic definitions for configuration bits (fuses)'
call lineout jalfile, '--    - Some device dependent procedures for common'
call lineout jalfile, '--      operations, like:'
call lineout jalfile, '--      . enable_digital_io()'
call lineout jalfile, '--'
call lineout jalfile, '-- Sources:'
call lineout jalfile, '--  - x:'substr(DevFile,3)           /* dummy drive 'x' ! */
call lineout jalfile, '--'
call lineout jalfile, '-- Notes:'
call lineout jalfile, '--  - Created with Dev2Jal Rexx script version' ScriptVersion
call lineout jalfile, '--  - File creation date/time:' date('N') left(time('N'),5)
call lineout jalfile, '--'
call lineout jalfile, '-- ==================================================='
call lineout jalfile, '--'
call lineout jalfile, 'const word DEVICE_ID   = 0x'DevID
call list_devID_chipdef                                     /* special for Chipdef_jallib */
call lineout jalfile, 'const byte PICTYPE[]   = "'PicNameCaps'"'
call SysFileSearch DevSpec.PicNameCaps.DataSheet, DataSheetFile, 'sheet.'    /* search actual DS */
if sheet.0 > 0 then
   call lineout jalfile, 'const byte DATASHEET[] = "'word(sheet.1,1)'"'
if DevSpec.PicNameCaps.PgmSpec \= '-' then do
   call SysFileSearch DevSpec.PicNameCaps.PgmSpec, DataSheetFile, 'sheet.'
   if sheet.0 > 0 then
      call lineout jalfile, 'const byte PGMSPEC[]   = "'word(sheet.1,1)'"'
end
call stream DataSheetFile, 'c', 'close'                     /* no more needed */
call lineout jalfile, '--'
call lineout jalfile, '-- Vdd Range:' VddRange 'Nominal:' VddNominal
call lineout jalfile, '-- Vpp Range:' VppRange 'Default:' VppDefault
call lineout jalfile, '--'
call lineout jalfile, '-- ---------------------------------------------------'
call lineout jalfile, '--'
call lineout jalfile, 'include chipdef_jallib                  -- common constants'
call lineout jalfile, '--'
call lineout jalfile, 'pragma  target  cpu   PIC_'Core '           -- (banks='Numbanks')'
call lineout jalfile, 'pragma  target  chip  'PicName
call lineout jalfile, 'pragma  target  bank  0x'D2X(BankSize,4)
if core = '12' | core = '14' | core = '14H' then
  call lineout jalfile, 'pragma  target  page  0x'D2X(PageSize,4)
call lineout jalfile, 'pragma  stack   'StackDepth
call lineout jalfile, 'pragma  code    'CodeSize
if DataSize > 0 then                                        /* any EEPROM present */
   call lineout jalfile, 'pragma  eeprom  'DataStart','DataSize
if IDSpec \= '' then                                        /* PIC has ID memory */
   call lineout jalfile, 'pragma  ID      'IDSpec

drange = DevSpec.PicNameCaps.NONSHAREDDATA
do while length(drange) > 50                    /* split large string */
   splitpoint = pos(',', drange, 49)            /* first comma beyond 50 */
   if splitpoint = 0 then                       /* no more commas */
      leave
   call lineout jalfile, 'pragma  data    'left(drange, splitpoint - 1)
   drange = substr(drange, splitpoint + 1)      /* remainder */
end
call lineout jalfile, 'pragma  data    'drange  /* last or only line */

srange = DevSpec.PicNameCaps.SHAREDDATA
call lineout jalfile, 'pragma  shared  'srange
call lineout jalfile, '--'

parse var srange '0x' val1 '-' '0x' val2                    /* lower and upper bounds */
if Core = '12'  |  Core = '14' then do
   if val2 = '' |,                                          /* not present! */
      (X2D(val2) - X2D(val1)) < 1 then
      call msg 3, 'At least 2 bytes of shared memory required! Found:' srange
   else do
      call lineout jalfile, 'var volatile byte _pic_accum shared at',
                               '0x'D2X(X2D(val2)-1)'      -- (compiler)'
      call lineout jalfile, 'var volatile byte _pic_isr_w shared at',
                            '0x'val2'      -- (compiler)'
   end
end
else if Core = '14H'  |  Core = '16' then do
   if val2 = '' then                                        /* not present */
      call msg 3, 'At least 1 byte of shared memory required! Found:' srange
   else do
      call lineout jalfile, 'var volatile byte _pic_accum shared at',
                            '0x'val2'      -- (compiler)'
   end
end
call lineout jalfile, '--'
return


/* ------------------------------------------------- */
/* List common constants in ChipDef.Jal              */
/* input:  - nothing                                 */
/* ------------------------------------------------- */
list_chipdef_header:
call lineout chipdef, '-- =================================================================='
call lineout chipdef, '-- Title: Common Jallib include file for device files'
call list_copyright_etc chipdef
call lineout chipdef, '-- Sources:'
call lineout chipdef, '--'
call lineout chipdef, '-- Description:'
call lineout chipdef, '--    Common Jallib include files for device files'
call lineout chipdef, '--'
call lineout chipdef, '-- Notes:'
call lineout chipdef, '--    - Created with Dev2Jal Rexx script version' ScriptVersion
call lineout chipdef, '--    - File creation date/time:' date('N') left(time('N'),5)
call lineout chipdef, '--'
call lineout chipdef, '-- ---------------------------------------------------'
call lineout chipdef, '--'
call lineout chipdef, '-- JalV2 compiler required constants'
call lineout chipdef, '--'
call lineout chipdef, 'const       PIC_12            = 1'
call lineout chipdef, 'const       PIC_14            = 2'
call lineout chipdef, 'const       PIC_16            = 3'
call lineout chipdef, 'const       SX_12             = 4'
call lineout chipdef, 'const       PIC_14H           = 5'
call lineout chipdef, '--'
call lineout chipdef, 'const bit   PJAL              = 1'
call lineout chipdef, '--'
call lineout chipdef, 'const byte  W                 = 0'
call lineout chipdef, 'const byte  F                 = 1'
call lineout chipdef, '--'
call lineout chipdef, 'include  constants_jallib                     -- common Jallib library constants'
call lineout chipdef, '--'
call lineout chipdef, '-- =================================================================='
call lineout chipdef, '--'
call lineout chipdef, '-- Values assigned to const "target_chip" by'
call lineout chipdef, '--    "pragma target chip" in device files'
call lineout chipdef, '-- can be used for conditional compilation, for example:'
call lineout chipdef, '--    if (target_chip == PIC_16F88) then'
call lineout chipdef, '--      ....                                  -- for 16F88 only'
call lineout chipdef, '--    endif'
call lineout chipdef, '--'
return


/* ------------------------------------------------- */
/* Add copyright, etc to header in all created files */
/* input: filespec of destination file               */
/* returns: nothing                                  */
/* ------------------------------------------------- */
list_copyright_etc:
parse arg listfile .
call lineout listfile, '--'
call lineout listfile, '-- Author:' ScriptAuthor', Copyright (c) 2008..2012,',
                       'all rights reserved.'
call lineout listfile, '--'
call lineout listfile, '-- Adapted-by:'
call lineout listfile, '--'
call lineout listfile, '-- Revision: $Revision$'
call lineout listfile, '--'
call lineout listfile, '-- Compiler:' CompilerVersion
call lineout listfile, '--'
call lineout listfile, '-- This file is part of jallib',
                       ' (http://jallib.googlecode.com)'
call lineout listfile, '-- Released under the ZLIB license',
                       ' (http://www.opensource.org/licenses/zlib-license.html)'
call lineout listfile, '--'
return


/* ------------------------------------------- */
/* Read .dev file contents into stem variable  */
/* input:                                      */
/*                                             */
/* Collect only relevant lines!                */
/* ------------------------------------------- */
file_read_dev: procedure expose Dev. msglevel
parse arg DevFile
Dev.0 = 0                                                   /* no records read yet */
if stream(DevFile, 'c', 'open read') \= 'READY:' then do
   call msg 3, 'Could not open .dev file' DevFile
   return 0                                                 /* zero records */
end
i = 1                                                       /* first record */
do while lines(DevFile) > 0                                 /* read whole file */
   parse upper value linein(DevFile) with Dev.i             /* store line in upper case */
   if length(Dev.i) \< 3 then do                            /* not an 'empty' record */
      if left(word(Dev.i,1),1) \= '#' then                  /* not comment */
         i = i + 1                                          /* keep this record */
   end
end
Dev.0 = i - 1                                               /* # of stored records */
call stream DevFile, 'c', 'close'                           /* done */
return Dev.0


/* --------------------------------------------------- */
/* Read file with Device Specific data                 */
/* Interpret contents: fill compound variable DevSpec. */
/* (simplyfied implementation of reading a JSON file)  */
/* --------------------------------------------------- */
file_read_devspec: procedure expose DevSpecFile DevSpec. msglevel
if stream(DevSpecFile, 'c', 'open read') \= 'READY:' then do
   call msg 3, 'Could not open file with device specific data' DevSpecFile
   return 1                                                 /* zero records */
end
call msg 1, 'Reading device specific data items from' DevSpecFile '...'
do until x = '{' | x = 0                                    /* search begin of pinmap */
   x = json_newchar(DevSpecFile)
end
do until x = '}' | x = 0                                    /* end of pinmap */
   do until x = '}' | x = 0                                 /* end of pic */
      PicName = json_newstring(DevSpecFile)                 /* new PIC */
      do until x = '{' | x = 0                              /* search begin PIC specs */
         x = json_newchar(DevSpecFile)
      end
      do until x = '}' | x = 0                              /* this PICs specs */
         ItemName = json_newstring(DevSpecFile)
         value = json_newstring(DevSpecFile)
         DevSpec.PicName.ItemName = value
         x = json_newchar(DevSpecFile)
      end
      x = json_newchar(DevSpecFile)
   end
   x = json_newchar(DevSpecFile)
end
call stream DevSpecFile, 'c', 'close'
return 0


/* --------------------------------------------------- */
/* Read file with pin alias information (JSON format)  */
/* Fill compound variable PinMap. and PinANMap.        */
/* (simplyfied implementation of reading a JSON file)  */
/* --------------------------------------------------- */
file_read_pinmap: procedure expose PinMapFile PinMap. PinANMap. msglevel
if stream(PinMapFile, 'c', 'open read') \= 'READY:' then do
   call msg 3, 'Could not open file with Pin Alias information' PinMapFile
   return                                                   /* zero records */
end
call msg 1, 'Reading pin alias names from' PinMapFile '...'
do until x = '{' | x = 0                                    /* search begin of pinmap */
   x = json_newchar(PinMapFile)
end
do until x = '}' | x = 0                                    /* end of pinmap */
   do until x = '}' | x = 0                                 /* end of pic */
      PicName = json_newstring(PinMapFile)                  /* new PIC */
      PinMap.PicName = PicName                              /* PIC listed in JSON file */
      do until x = '{' | x = 0                              /* search begin PIC specs */
        x = json_newchar(PinMapFile)
      end
      ANcount = 0                                           /* zero ANxx count this PIC */
      do until x = '}' | x = 0                              /* this PICs specs */
         pinname = json_newstring(PinMapFile)
         i = 0                                              /* no aliases (yet) */
         do until x = '[' | x = 0                           /* search pin aliases */
           x = json_newchar(PinMapFile)
         end
         do until x = ']' | x = 0                           /* end of aliases this pin */
            aliasname = json_newstring(PinMapFile)
            if aliasname = '' then do                       /* no (more) aliases */
               x = ']'                                      /* must have been last char read! */
               iterate
            end
            if right(aliasname,1) = '-' then                /* handle trailing '-' character */
               aliasname = strip(aliasname,'T','-')'_NEG'
            else if right(aliasname,1) = '+' then           /* handle trailing '+' character */
               aliasname = strip(aliasname,'T','+')'_POS'
            i = i + 1
            PinMap.PicName.pinname.i = aliasname
            if left(aliasname,2) = 'AN' & datatype(substr(aliasname,3)) = 'NUM' then do
               ANcount = ANcount + 1
               PinANMap.PicName.aliasname = PinName         /* pin_ANx -> RXy */
            end
            x = json_newchar(PinMapFile)
         end
         PinMap.PicName.pinname.0 = i
         x = json_newchar(PinMapFile)
      end
      ANCountName = 'ANCOUNT'
      PinMap.PicName.ANCountName = ANcount
      x = json_newchar(PinMapFile)
   end
   x = json_newchar(PinMapFile)
end
call stream PinMapFile, 'c', 'close'
return 0


/* -------------------------------- */
json_newstring: procedure
parse arg jsonfile .
do until x = '"' | x = ']' | x = '}' | x = 0                /* start new string or end of everything */
   x = json_newchar(jsonfile)
end
if x \= '"' then                                            /* no string found */
   return ''
str = ''
x = json_newchar(jsonfile)                                  /* first char */
do while x \= '"'
   str = str||x
   x = json_newchar(jsonfile)
end
return str


/* -------------------------------- */
json_newchar: procedure
parse arg jsonfile .
do while chars(jsonfile) > 0
   x = charin(jsonfile)
   if x <= ' ' then                                         /* white space */
      iterate
   return x
end
return 0                                                    /* dummy (end of file) */


/* ---------------------------------------------------- */
/* Read file with oscillator name mapping               */
/* Interpret contents: fill compound variable Fuse_Def. */
/* ---------------------------------------------------- */
file_read_fusedef: procedure expose FuseDefFile Fuse_Def. msglevel
if stream(FuseDefFile, 'c', 'open read') \= 'READY:' then do
   call msg 3, 'Could not open file with fuse_def mappings' FuseDefFile
   return 1                                                 /* zero records */
end
call msg 1, 'Reading Fusedef Names from' FuseDefFile '... '
do while lines(FuseDefFile) > 0                             /* whole file */
   interpret linein(FuseDefFile)                            /* read and interpret line */
end
call stream FuseDefFile, 'c', 'close'                       /* done */
return 0


/* --------------------------------------------- */
/* Signal duplicates names                       */
/* Arguments: - new name                         */
/*            - register                         */
/* Return - 0 when name is unique                */
/*        - 1 when name is duplicate             */
/* Collect all names in Name. compound variable  */
/* --------------------------------------------- */
duplicate_name: procedure expose Name. PicName msglevel
parse arg newname, reg .
if newname = '' then                                        /* no name specified */
   return 1                                                 /* not acceptable */
if Name.newname = '-' then do                               /* name not in use yet */
   Name.newname = reg                                       /* mark in use by which reg */
   return 0                                                 /* unique */
end
if reg \= newname then do                                   /* not alias of register */
   call msg 2, 'Duplicate name:' newname 'in' reg'. First occurence:' Name.newname
   return 1                                                 /* duplicate */
end
return 0


/* ---------------------------------------------- */
/* translate string to lower case                 */
/* ---------------------------------------------- */

tolower:
return translate(arg(1), xrange('a','z'), xrange('A','Z'))


/* ---------------------------------------------- */
/* message handling, depending on msglevel        */
/* ---------------------------------------------- */
msg: procedure expose msglevel
parse arg lvl, txt
   if lvl = 0 then                                          /* used for continuation lines */
      say txt                                               /* for continuation lines, etc. */
   else if lvl >= msglevel then do
      if lvl = 1 then                                       /* info level */
         say '   Info: 'txt
      else if lvl = 2 then                                  /* warning level */
         say '   Warning: 'txt
      else                                                  /* error level */
         say '   Error: 'txt
   end
return lvl


/* ---------------------------------------------- */
/* Some procedures to help script debugging       */
/* ---------------------------------------------- */
catch_error:
Say 'Rexx Execution error, rc' rc 'at script line' SIGL
if rc > 0 & rc < 100 then                                   /* msg text only for rc 1..99 */
  say ErrorText(rc)
return rc

catch_syntax:
if rc = 4 then                                              /* interrupted */
   exit
Say 'Rexx Syntax error, rc' rc 'at script line' SIGL":"
if rc > 0 & rc < 100 then                                   /* rc 1..99 */
  say ErrorText(rc)
Say SourceLine(SIGL)
return rc


