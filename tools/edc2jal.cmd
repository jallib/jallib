/* ------------------------------------------------------------------------ *
 * Title: Edc2Jal.cmd - Create JalV2 device specifications for flash PICs   *
 *                                                                          *
 * Author: Rob Hamerling, Copyright (c) 2013..2013, all rights reserved.    *
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
 *   Rexx script to create device specifications for JALV2, and             *
 *   the file chipdef_jallib.jal, included by each of these.                *
 *   Input are .edc files: expanded MPLAB-X .pic files.                     *
 *   Apart from declaration of all registers, register-subfields, ports     *
 *   and pins of the chip the device files contain shadowing procedures     *
 *   to prevent the 'read-modify-write' problems and use the LATx register  *
 *   (for PICs which have such registers) for output in stead of PORTx.     *
 *   In addition some device dependent procedures are provided              *
 *   for common operations, like enable_digital_io().                       *
 *   Also various aliases are declared to 'normalize' the names of          *
 *   registers and bit fields, which makes it easier to build device        *
 *   independent libraries.                                                 *
 *                                                                          *
 * Sources:  MPLAB-X .pic files  (preprocessed by pic2edc script).          *
 *           MPLAB-X .lkr files  (via devicespecific.json)                  *
 *                                                                          *
 * Notes:                                                                   *
 *   - This script is written in 'classic' Rexx as delivered with           *
 *     eComStation (OS/2) and is executed on a system with eCS 2.1 or 2.2.  *
 *     With only minor changes it can be executed on a different system,    *
 *     or even a different platform (Linux, Windows) with "Regina Rexx"     *
 *     Ref:  http://regina-rexx.sourceforge.net/                            *
 *     See the embedded comments below for instructions for possibly        *
 *     required changes. You don't have to look further than the line which *
 *     says "Here the device file generation actually starts" (approx 135). *
 *   - A summary of changes of this script is maintained in 'changes.txt'   *
 *     (not published, available on request).                               *
 *                                                                          *
 * ------------------------------------------------------------------------ */
   ScriptVersion   = '0.0.21'
   ScriptAuthor    = 'Rob Hamerling'
   CompilerVersion = '2.4q'
/* mplabxversion obtained from file MPLAB-X_VERSION created by pic2edc script. */
/* ------------------------------------------------------------------------ */

/* 'msglevel' controls the amount of messages being generated */
/*   0 - progress messages, info, warnings and errors         */
/*   1 - info, warnings and errors                            */
/*   2 - warnings and errors                                  */
/*   3 - errors (always reported!)                            */

msglevel = 1

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                                           /* load Rexx utilities */

parse value linein('MPLAB-X_VERSION') with 'MPLAB-X_VERSION' val1 'SCRIPT_VERSION' val2
call stream 'MPLAB-X_VERSION', 'c', 'close'
if val1 = '' then do
   say 'Could not determine MPLAB-X version from file MPLAB-X_VERSION'
   return 0
end
mplabxversion = strip(val1)
if ScriptVersion \= strip(val2)  then do
   say 'Conflicting script versions, found' val2', expecting' ScriptVersion
   return 0
end

/* MPLAB-X and a local copy of the Jallib SVN tree should be installed.        */
/* The .pic files used are in <basedir>/MPLAB_IDE/BIN/LIB/CROWNKING.EDC.JAR.   */
/* This file must be expanded (unZIPped) to obtain the individual .pic files,  */
/* and be expanded by the pic2edc script to obtain the necessary .edc files.   */
/* Directory of expanded MPLAB-X .pic files:                                   */

edcdir        = './edc_'mplabxversion                       /* source of expanded .pic files */

/* Some information is collected from files in JALLIB tools directory */

JALLIBbase    = 'k:/jallib'                                  /* local JALLIB base directory */
DevSpecFile   = JALLIBbase'/tools/devicespecific.json'       /* device specific data */
PinMapFile    = JALLIBbase'/tools/pinmap_pinsuffix.json'     /* pin aliases */
FuseDefFile   = JALLIBbase'/tools/fusedefmap.cmd'            /* OSC fuse_def mappings */
DataSheetFile = JALLIBbase'/tools/datasheet.list'            /* actual datasheets */

call msg 0, 'Edc2Jal version' ScriptVersion '  -  ' ScriptAuthor '  -  ' date('N')';' time('N')
if msglevel > 2 then
   call msg 0, 'Only reporting errors!'

/* The destination of the generated device files depends on the first     */
/* mandatory commandline argument, which must be 'PROD' or 'TEST'         */
/*  - with 'PROD' the files go to directory "<JALLIBbase>/include/device" */
/*  - with 'TEST' the files go to directory "./test>"                     */
/* Note: Before creating new device files all .jal files are              */
/*       removed from the destination directory.                          */

parse upper arg destination selection .                     /* commandline arguments */

if destination = 'PROD' then                                /* production run */
   dstdir = JALLIBbase'/include/device'                     /* local Jallib */
else if destination = 'TEST' then do                        /* test run */
   dstdir = './test'                                        /* subdir for testing */
   rx = SysMkDir(dstdir)                                    /* create destination dir */
   if rx \= 0 & rx \= 5 then do                             /* not created, not existing */
      call msg 3, 'Error' rx 'while creating destination directory' dstdir
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
/* Regardless the selection only flash PICs are processed.                   */

if selection = '' then                                      /* no selection spec'd */
   wildcard = '1*.edc'                                      /* default (8 bit PICs) */
else if destination = 'TEST' then                           /* TEST run */
   wildcard = selection'.edc'                               /* accept user selection */
else do                                                     /* PROD run with selection */
   call msg 3, 'No selection allowed for production run!'
   return 1                                                 /* unrecoverable: terminate */
end

/* ------ Here the device file generation actually starts ------------------------ */

call time 'R'                                               /* reset 'elapsed' timer */

call msg 0, 'Creating Jallib device files with MPLAB-X version' mplabxversion/100

call SysFileTree edcdir'/'wildcard, 'dir.', 'FOS'           /* search all .edc files */
if dir.0 = 0 then do
   call msg 3, 'No .edc files found matching <'wildcard'> in' edcdir
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
do i = 1 to jal.0                                           /* all .jal files */
   call SysFileDelete jal.i                                 /* remove */
end

chipdef = dstdir'/chipdef_jallib.jal'                       /* common include for device files */
if stream(chipdef, 'c', 'open write') \= 'READY:' then do   /* new chipdef file */
   call msg 3, 'Could not create common include file' chipdef
   return 1                                                 /* unrecoverable: terminate */
end
call list_chipdef_header                                    /* create header of chipdef file */

xChipDef. = '?'                                             /* collection of dev IDs in chipdef */

ListCount = 0                                               /* # created device files */
SpecMissCount = 0                                           /* # missing in devicespecific.json */
DSMissCount = 0                                             /* # missing datasheet */
PinmapMissCount = 0                                         /* # missing in pinmap */

do i = 1 to dir.0                                           /* all relevant .edc files */
                                                            /* init for each new PIC */
   DevFile = tolower(translate(dir.i,'/','\'))              /* lower case + forward slashes */
   parse value filespec('Name', DevFile) with PicName '.edc'
   if PicName = '' then do
      call msg 3, 'Could not derive PIC name from filespec: "'DevFile'"'
      leave                                                 /* setup error: terminate */
   end

   PicName = tolower(PicName)                               /* ensure name is in lower case */
   if \(substr(PicName,3,1) = 'f'    |,                     /* not flash PIC or */
        substr(PicName,3,2) = 'lf'   |,                     /*     low power flash PIC or */
        substr(PicName,3,2) = 'hv')  |,                     /*     high voltage flash PIC */
      PicName = '16hv540' |,                                /* not a flash PIC */
      PicName = '16f527'  |,                                /* bank selection via BSR */
      PicName = '16f570' then do                            /*   "      "      "   "  */
      iterate                                               /* skip */
   end

   call msg 0, PicName                                      /* progress signal */

   PicNameCaps = toupper(PicName)
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

   Pic. = ''                                                /* reset .pic file contents */
   edcfile = edcdir'/'PicName'.edc'
   do j = 1 while lines(edcfile)                            /* read edc file */
      Pic.j = translate(linein(edcfile), ' ', '09'x)        /* tab -> blank */
   end                                                      /* error with read */
   Pic.0 = j - 1
   call stream edcfile, 'c', close

   Ram.                  = ''                               /* sfr usage and mirroring */
   Name.                 = '-'                              /* register and subfield names */
   CfgAddr.              = ''                               /* config memory addresses (decimal) */
   Cfgmem                = ''                               /* config string */

   DevID                 = '0000'                           /* no device ID */
   NumBanks              = 0                                /* # memory banks */
   StackDepth            = 0                                /* hardware stack depth */
   AccessBankSplitOffset = 128                              /* 0x80 (18Fs) */
   CodeSize              = 0                                /* amount of program memory */
   DataSize              = 0                                /* amount of data memory (RAM) */
   EESpec                = ''                               /* EEPROM: hexaddr,size (dec) */
   IDSpec                = ''                               /* ID bytes: hexaddr,size (dec) */
   VddRange              = 0                                /* working voltage range */
   VddNominal            = 0                                /* nominal working voltage */
   VppRange              = 0                                /* programming voltage range */
   VppDefault            = 0                                /* default programming voltage */
   dsnumber              = ''                               /* datasheet number in .edc file */
   psnumber              = ''                               /* pgm spec number in .edc file */

   ADCS_bits             = 0                                /* # ADCONx_ADCS bits */
   ADC_highres           = 0                                /* 0 = has no ADRESH register */
   IRCF_bits             = 0                                /* # OSCCON_IRCF bits */
   HasLATreg             = 0                                /* zero LAT registers found (yet) */
                                                            /* used for enhanced midrange only */
   HasMuxedSFR           = 0                                /* zero multiplexed SFRs found(yet) */
   OSCCALaddr            = 0                                /* address of OSCCAL (>0 if present!)  */
   FSRaddr               = 0                                /* address of FSR (>0 if present!)  */


   /* -------- collect some basic information ------------ */

   core = load_config_info()                                /* core + various cfg info */

   /* -------- set core-dependent default properties ----- */

   select
      when core = '12' then do                              /* baseline */
         MaxRam       = 128                                 /* range 0..0x7F */
         BankSize     = 32                                  /* 0x0020 */
         PageSize     = 512                                 /* 0x0200 */
      end
      when core = '14' then do                              /* classic midrange */
         MaxRam       = 512                                 /* range 0..0x1FF */
         BankSize     = 128                                 /* 0x0080 */
         PageSize     = 2048                                /* 0x0800 */
      end
      when core = '14H' then do                             /* enhanced midrange (Hybrid) */
         MaxRam       = 4096                                /* range 0..0xFFF */
         BankSize     = 128                                 /* 0x0080 */
         PageSize     = 2048                                /* 0x0800 */
      end
      when core = '16' then do                              /* 18Fs */
         MaxRam       = 4096                                /* range 0..0xFFF */
         BankSize     = 256                                 /* 0x0100 */
      end
   otherwise                                                /* other or undetermined core */
      call msg 3, 'Unsupported core:' Core,                 /* report detected Core */
                  'Internal script error, terminating ....'
      call msg 0, Pic.0 ':' Pic.1
      leave                                                 /* script error: terminate */
   end

   if dsnumber \= ''  then do
      if length(DevSpec.PicNameCaps.DataSheet) > 5  & length(dsnumber) = 5 then
         dsnumber = insert('000', dsnumber, 1)              /* make 8-digits variant */
      if DevSpec.PicNameCaps.DataSheet \= dsnumber then
         call msg 1, 'Non matching DataSheet numbers:' DevSpec.PicNameCaps.DataSheet '<->' dsnumber
   end
   if psnumber \= '' then do
      if length(DevSpec.PicNameCaps.PgmSpec) > 5 & length(psnumber) = 5 then
         psnumber = insert('000', psnumber, 1)
      if psnumber \= '' & DevSpec.PicNameCaps.PgmSpec \= psnumber then
         call msg 1, 'Non matching PgmSpec numbers:' DevSpec.PicNameCaps.PgmSpec '<->' psnumber
   end

   call load_sfr_info                                       /* SFR address map */

   /* ------------ produce device file ------------------------ */

   jalfile = dstdir'/'PicName'.jal'                         /* device filespec */
   if stream(jalfile, 'c', 'open write') \= 'READY:' then do
      call msg 3, 'Could not create device file' jalfile
      leave                                                 /* unrecoverable error */
   end

   parse var DevSpec.PicNameCaps.SHARED '0x' addr1 '-' '0x' addr2
   SharedMem.0 = x2d(addr2) - x2d(addr1) + 1                /* # bytes of shared memory */
   SharedMem.1 = x2d(addr1)                                 /* lowest address (decimal) */
   SharedMem.2 = x2d(addr2)                                 /* highest */

   call list_header                                         /* common devicefile header */

   call list_cfgmem                                         /* cfg mem addr + defaults */

   select

      when core = '12' then do                              /* baseline */
         if OSCCALaddr > 0 then                             /* OSCCAL present */
            call list_osccal                                /* INTRC calibration */
         call list_sfr
         if HasMuxedSFR > 0 then
            call list_muxed_sfr
         call list_nmmr12                                   /* TRIS, OPTION, etc. */
      end

      when core = '14' then do                              /* midrange */
/*       if OSCCALaddr > 0 then      */                     /* OSCCAL present */
/*          call list_osccal         */                     /* TOO DANGEROUS (INTRC calibration) */
         call list_sfr
         if HasMuxedSFR > 0 then
            call list_muxed_sfr
      end

      when core = '14H' then do                             /* enhanced midrange (Hybrids) */
         call list_sfr
         if HasMuxedSFR > 0 then
            call list_muxed_sfr
      end

      when core = '16' then do                              /* 18Fs */
         call list_sfr
         if HasMuxedSFR > 0 then
            call list_muxed_sfr
      end

   end

   call list_analog_functions                               /* common enable_digital_io() */

   call list_miscellaneous                                  /* other info */

   call list_fusedef                                        /* pragma fusedef */

   call stream jalfile, 'c', 'close'                        /* done with this PIC */

   ListCount = ListCount + 1;                               /* count generated device files */

end

call lineout chipdef, '--'                                  /* last line */
call stream  chipdef, 'c', 'close'                          /* done */

call msg 0, ''                                              /* empty line */
ElapsedTime = time('E')
if ElapsedTime > 0 then
   call msg 0, 'Generated' listcount 'device files in' format(ElapsedTime,,2) 'seconds',
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




/* -------------------------------------------- */
/* procedure to collect various elementary      */
/* information and figures.                     */
/* input:   - nothing                           */
/* output:  - nothing                           */
/* returns: core (0, '12', '14', '14H', '16')   */
/* -------------------------------------------- */
load_config_info: procedure expose Pic. PicName Name. CfgAddr. ,
                                   StackDepth NumBanks Banksize AccessBankSplitOffset,
                                   CodeSize EESpec IDSpec DevID Cfgmem,
                                   VddRange VddNominal VppRange VppDefault,
                                   HasLATreg HasMuxedSFR OSCCALaddr FSRaddr,
                                   ADC_highres ADCS_bits IRCF_bits,
                                   dsnumber psnumber

CfgAddr.0 = 0                                               /* empty */
Core = 0                                                    /* undetermined */
CodeSize = 0                                                /* no code memory */
NumBanks = 0                                                /* no databanks */

SFRaddr = 0                                                 /* start of SFRs */

do i = 1 to Pic.0

   kwd = word(Pic.i,1)                                      /* selection keyword */

   select

      when pos('<edc:PIC', Pic.i) > 0 then do
         parse var Pic.i . 'edc:arch="' val1 '"' .
         if val1 \= '' then do
            if      val1 = '16c5x' then
               Core = '12'
            else if val1 = '16xxxx' then
               Core = '14'
            else if val1 = '16Exxx' then
               Core = '14H'
            else if val1 = '18xxxx' then
               Core = '16'
            else do                                         /* otherwise */
               msg 3, 'Unrecognized core type:' val1', terminated!'
               exit 3
            end
         end
         parse var Pic.i . 'edc:dsid="' val1 '"' .
         if val1 \= '' then do
            dsnumber = strip(val1)                          /* DataSheet number */
            if dsnumber = '0' then
               dsnumber = ''                                /* unknown */
         end
         parse var Pic.i . 'edc:psid="' val1 '"' .
         if val1 \= '' then do
            psnumber = strip(val1)                          /* PgmSpec number */
            if psnumber = '0' then
               psnumber = ''                                /* unknown */
         end
      end

      when kwd = '<edc:VPP' then do
         parse var Pic.i '<edc:VPP' 'edc:defaultvoltage="' val1 '"',
                          'edc:maxvoltage="' val2 '"' 'edc:minvoltage="' val3 '"' .
         if val1 \= '' then do
            VppDefault = strip(val1)
            VppRange = strip(val3)'-'strip(val2)
         end
      end

      when kwd = '<edc:VDD' then do
         parse var Pic.i '<edc:VDD' 'edc:maxdefaultvoltage="' val1 'edc:maxvoltage="' val2 '"',
                          'edc:mindefaultvoltage="' val3 'edc:minvoltage="' val4 '"',
                          'edc:nominalvoltage="' val5 '"' .
         if val1 \= '' then do
            VddRange = strip(val4)'-'strip(val2)
            VddNominal = strip(val5)
         end
      end

      when kwd = '<edc:MemTraits' then do
         parse var Pic.i '<edc:MemTraits',
                          'edc:bankcount="' val1 '"' 'edc:hwstackdepth="' val2 '"' .
         if val1 \= '' then
            Numbanks = todecimal(val1)                      /* want decimal value */
         else
            parse var Pic.i '<edc:MemTraits' 'edc:hwstackdepth="' val2 '"' .
         if val2 \= '' then
            StackDepth = todecimal(val2)                    /* want decimal value */
      end

      when kwd = '<edc:ConfigFuseSector' |,
           kwd = '<edc:WORMHoleSector' then do
         if kwd = '<edc:ConfigFuseSector' then
            parse var Pic.i '<edc:ConfigFuseSector',
                          'edc:beginaddr="0x' val1 '"' 'edc:endaddr="0x' val2 '"' .
         else
            parse var Pic.i '<edc:WORMHoleSector',
                          'edc:beginaddr="0x' val1 '"' 'edc:endaddr="0x' val2 '"' .
         if val1 \= '' then do
            val1 = X2D(val1)                                /* take decimal values */
            val2 = X2D(val2)
            CfgAddr.0 = val2 - val1                         /* number of config words/bytes */
            do j = 1 to CfgAddr.0                           /* all of 'm */
               CfgAddr.j = val1 + j - 1                     /* address (decimal) */
            end
         end
         FuseOffset = 0
         do i = i until (word(Pic.i,1) = '</edc:ConfigFuseSector>' |,
                         word(Pic.i,1) = '</edc:WORMHoleSector>')
            select
               when word(Pic.i,1) = '<edc:AdjustPoint' then do
                  parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
                  if val1 \= '' then do
                     val1 = todecimal(val1)                 /* want decimal value */
                     FuseOffset = FuseOffset + val1         /* adjust */
                     Cfgmem = Cfgmem||copies('00',val1)     /* concat unimplemented bytes */
                                                            /* presumably only with 18Fs */
                  end
               end
               when word(Pic.i,1) = '<edc:DCRDef' then do
                  parse var Pic.i '<edc:DCRDef' . 'edc:default="' val1 '"' .
                  if val1 \= '' then do
                     val1 = strip(val1)
                     if left(val1,2) = '0x' then
                        val1 = substr(val1,3)               /* strip '0x' prefix */
                     newfuse = val1
                  end
                  if core = '12' then
                     newfuse = C2X(BITAND(X2C(right(newfuse,4,'0')),'0FFF'x))
                  else if core = '14' | core = '14H' then
                     newfuse = C2X(BITAND(X2C(right(newfuse,4,'0')),'3FFF'x))
                  else
                     newfuse = C2X(BITAND(X2C(right(newfuse,2,'0')),'FF'x))
                  Cfgmem = Cfgmem||newfuse                  /* concat byte/word */
                  do while word(Pic.i,1) \= '</edc:DCRModeList>'
                     i = i + 1                              /* skip inner statements */
                  end
               end
            otherwise
               nop
            end
         end
      end

      when kwd = '<edc:CodeSector' then do
         parse var Pic.i '<edc:CodeSector',
                          'edc:beginaddr="0x' val1 '"' 'edc:endaddr="0x' val2 '"' .
         if val1 \= '' then
            CodeSize = CodeSize + X2D(val2) - X2D(val1)
      end

      when kwd = '<edc:DeviceIDSector' then do
         parse var Pic.i '<edc:DeviceIDSector' . 'edc:mask="0x' val1 '"' . 'edc:value="0x' val2 '"' .
         if val1 \= '' then do
            RevMask = right(strip(val1),4,'0')                    /* 4 hex chars */
            DevID = right(strip(val2),4,'0')
            DevID = C2X(bitand(X2C(DevID),X2C(RevMask)))          /* reset revision bits */
         end
         else do                                                  /* no revision mask */
            parse var Pic.i '<edc:DeviceIDSector' . 'edc:value="0x' val1 '"' .
            if val1 \= '' then
               DevID = right(strip(val1),4,'0')                   /* 4 hex chars */
         end
      end

      when kwd = '<edc:UserIDSector' then do
         parse var Pic.i '<edc:UserIDSector',
                          'edc:beginaddr="0x' val1 '"' 'edc:endaddr="0x' val2 '"' .
         if val1 \= '' then
            IDSpec = '0x'strip(val1)','X2D(val2) - X2D(val1)
      end

      when kwd = '<edc:EEDataSector' then do
         parse var Pic.i '<edc:EEDataSector' ,
                          'edc:beginaddr="0x' val1 '"' 'edc:endaddr="0x' val2 '"' .
         if val1 \= '' then
            EESpec = '0x'val1','X2D(val2) - X2D(val1)
      end

      when kwd = '<edc:FlashDataSector' then do
         parse var Pic.i '<edc:FlashDataSector' ,
                          'edc:beginaddr="0x' val1 '"' 'edc:endaddr="0x' val2 '"' .
         if val1 \= '' then
            EESpec = '0x'val1','X2D(val2) - X2D(val1)
      end

      when kwd = '<edc:SFRDataSector' then do
         parse var Pic.i '<edc:SFRDataSector' 'edc:bank="' val1 '"',
                          'edc:beginaddr="' val2 '"' .
         if val1 \= '' then do
            val1 = todecimal(val1)                       /* want decimal value */
            if NumBanks < val1 + 1 then                  /* new larger than previous */
               Numbanks = val1 + 1
         end
         if val2 \= '' then
            SFRaddr = todecimal(val2)
      end

      when kwd = '<edc:ExtendedModeOnly>' then do        /* skip extended mode features */
         do until word(Pic.i,1) = '</edc:ExtendedModeOnly>'
            i = i + 1
         end
      end

      when kwd = '<edc:PinList>' then do                 /* skip pin descriptions */
         do until word(Pic.i,1) = '</edc:PinList>'
            i = i + 1
         end
      end

      when kwd = '<edc:GPRDataSector' then do
         parse var Pic.i '<edc:GPRDataSector' 'edc:bank="' val1 '"' ,
                          'edc:beginaddr="0x' val2 '"' 'edc:endaddr="0x' val3 '"' .
         if val1 \= '' then do
            val1 = todecimal(val1)                       /* want decimal value */
            if NumBanks < val1 + 1 then                  /* new larger than previous */
               Numbanks = val1 + 1
            if val1 = 0  &  X2D(val2) = 0 then           /* first part of access bank */
               AccessBankSplitOffset = X2D(val3)
         end
         else do                                         /* no bank specification */
            parse var Pic.i '<edc:GPRDataSector' ,
                             'edc:beginaddr="' val1 '"' 'edc:endaddr="' val2 '"' .
            if val1 \= '' then do
               val1 = todecimal(val1)                    /* want decimal value */
               if val1 = 0 then                          /* first part of access bank */
                  AccessBankSplitOffset = todecimal(val2)
            end
         end
      end

      when kwd = '<edc:MuxedSFRDef' then do
         do while word(Pic.i,1) \= '</edc:MuxedSFRDef>'
            if word(Pic.i,1) = '<edc:SFRDef' then do
               parse var Pic.i '<edc:SFRDef' . 'edc:cname="' val1 '"' .
               reg = strip(val1)
               if left(reg,5) = 'ADCON'  |,              /* ADCONx register */
                  left(reg,5) = 'ANSEL' then do          /* ANSELx register */
                  do while word(pic.i,1) \= '</edc:SFRModeList>'  /* till end subfields */
                     if word(Pic.i,1) = '<edc:SFRMode' then do    /* new set of subfields */
                        parse var Pic.i '<edc:SFRMode' 'edc:id="' val1 '"' .
                        if val1 = 'DS.0' then do               /* check only one SFRmode */
                           do while word(pic.i,1) \= '</edc:SFRMode>'
                              if word(pic.i,1) = '<edc:SFRFieldDef' then do
                                 parse var Pic.i '<edc:SFRFieldDef' . 'edc:cname="' val1 '"' . ,
                                                  'edc:nzwidth="' val2 '"' .
                                 val1 = strip(val1)
                                 if val1 = 'ADCS' then                     /* multi-bit ADCS field */
                                    ADCS_bits = ADCS_bits + todecimal(val2)   /* count ADCS bits */
                                 else if left(val1,4) = 'ADCS'  &,         /* enumerated */
                                         datatype(substr(val1,5)) = 'NUM' then
                                    ADCS_bits = ADCS_bits + 1              /* count ADCS bits */
                              end
                              i = i + 1
                           end
                        end
                     end
                     i = i + 1
                  end
               end
            end
            i = i + 1
         end
         HasMuxedSFR = HasMuxedSFR + 1                   /* count */
         SFRaddr = SFRaddr + 1                           /* muxed SFRs count for 1 */
      end

      when kwd = '<edc:SFRDef' then do
         parse var Pic.i '<edc:SFRDef' . 'edc:cname="' val1 '"' .
         reg = strip(val1)
         if reg = 'OSCCAL' then
            OSCCALaddr = SFRaddr                         /* store addr (dec) */
         else if left(reg,3) = 'LAT' then
            HasLATreg = HasLATReg + 1                    /* count LATx registers */
         else if reg = 'FSR' then
            FSRaddr = SFRaddr                            /* store addr (dec) */
         else if reg = 'ADRESH' | reg = 'ADRES0H' then
            ADC_highres = 1                              /* has high res ADC */
         else if left(reg,5) = 'ADCON'  |,               /* ADCONx register */
                 left(reg,5) = 'ANSEL' then do           /* ANSELx register */
            do while word(pic.i,1) \= '</edc:SFRModeList>'  /* till end subfields */
               if word(Pic.i,1) = '<edc:SFRMode' then do    /* new set of subfields */
                  parse var Pic.i '<edc:SFRMode' 'edc:id="' val1 '"' .
                  if val1 = 'DS.0' then do               /* check only one SFRmode */
                     do while word(pic.i,1) \= '</edc:SFRMode>'
                        if word(pic.i,1) = '<edc:SFRFieldDef' then do
                           parse var Pic.i '<edc:SFRFieldDef' . 'edc:cname="' val1 '"' . ,
                                            'edc:nzwidth="' val2 '"' .
                           val1 = strip(val1)
                           if val1 = 'ADCS' then                     /* multibit(?) ADCS field */
                              ADCS_bits = ADCS_bits + todecimal(val2)   /* count ADCS bits */
                           else if left(val1,4) = 'ADCS'   &,        /* enumerated */
                                   datatype(substr(val1,5)) = 'NUM' then
                              ADCS_bits = ADCS_bits + 1              /* count ADCS bits */
                        end
                        i = i + 1
                     end
                  end
               end
               i = i + 1
            end
         end
         else if reg = 'OSCCON' then do                    /* OSCCON register */
            do while word(pic.i,1) \= '</edc:SFRModeList>'  /* till end subfields */
               if word(pic.i,1) = '<edc:SFRFieldDef' then do
                  parse var Pic.i '<edc:SFRFieldDef' . 'edc:cname="' val1 '"' .,
                                            'edc:nzwidth="' val2 '"' .
                  val1 = strip(val1)
                  if left(val1,4) = 'IRCF' then do             /* IRCF field */
                     val2 = todecimal(val2)                 /* want decimal value */
                     if val2 = 1 then                          /* single bit */
                        IRCF_bits = IRCF_bits + val2           /* count enumerated IRCF bits */
                     else                                      /* mult-bit field */
                        IRCF_bits = val2                       /* # IRCF bits */
                  end
               end
               i = i + 1
            end
         end
         do while word(pic.i,1) \= '</edc:SFRDef>'
            i = i + 1                                 /* skip subfields */
         end
         SFRaddr = SFRaddr + 1
      end

      when kwd = '<edc:Mirror' then do
         parse var Pic.i '<edc:Mirror' 'edc:nzsize="' val1 '"' .
         if val1 \= '' then
            SFRaddr = SFRaddr + todecimal(val1)
      end

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then
            SFRaddr = SFRaddr + todecimal(val1)
      end

   otherwise
      nop                                                /* ignore */
   end

end
return core


/* ---------------------------------------------------------- */
/* procedure to build special function register array         */
/* with mirror info and unused registers                      */
/* input:  nothing                                            */
/* output: nothing                                            */
/* notes: - banksize and number of banks must be known ahead  */
/*        - joined SFRs specs can be ignored                  */
/*        - multiplexed SFRs count for 1                      */
/* ---------------------------------------------------------- */
load_sfr_info: procedure expose Pic. Name. Ram. core,
                           NumBanks BankSize MaxRam msglevel
do i = 0 to NumBanks*Banksize                            /* whole range */
   Ram.i = -1                                            /* mark address as unused */
end

SFRaddr = 0                                              /* start value */

do i = 1 while \(word(Pic.i,1) = '<edc:DataSpace'   |,    /* search start of dataspace */
                 word(Pic.i,1) = '<edc:DataSpace>')
   nop
end

do i = i while word(Pic.i,1) \= '</edc:DataSpace>'       /* to end of data */

   kwd = word(Pic.i,1)                                   /* selection keyword */

   select

      when kwd = '<edc:SFRDataSector' then do
         parse var Pic.i '<edc:SFRDataSector' 'edc:beginaddr="0x' val1 '"' .
         if val1 \= '' then
            SFRaddr = X2D(val1)
      end

      when kwd = '<edc:MuxedSFRDef' then do
         Ram.SFRaddr = SFRaddr
         do while word(Pic.i,1) \= '</edc:MuxedSFRDef>'  /* skip all inner statements */
            i = i + 1
         end
         SFRaddr = SFRaddr + 1                           /* muxed SFRs count for 1 */
      end

      when kwd = '<edc:SFRDef' then do
         Ram.SFRaddr = SFRaddr
         do while word(pic.i,1) \= '</edc:SFRDef>'
            i = i + 1                                    /* skip subfields */
         end
         SFRaddr = SFRaddr + 1
      end

      when kwd = '<edc:Mirror' then do
         parse var Pic.i '<edc:Mirror' 'edc:nzsize="' val1 '"' . 'edc:regionidref="' val2 '"' .
         if val1 \= '' then do
            val1 = todecimal(val1)                       /* want decimal value */
            do j = 0 to val1 - 1
               BaseBank = right(val2,1)                  /* base bank of SFR */
               baseaddr = BaseBank * BankSize + (SFRaddr // Banksize)   /* base addr */
               Ram.SFRaddr = baseaddr                    /* mirrored address */
               SFRaddr = SFRaddr + 1
            end
         end
      end

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then
            SFRaddr = SFRaddr + todecimal(val1)
      end

   otherwise
      nop

   end

end

return 0


/* ---------------------------------------------------- */
/* procedure to list special function registers         */
/* input:  - nothing                                    */
/* ---------------------------------------------------- */
list_sfr: procedure expose Pic. Ram. Name. PinMap. PinANMap. SharedMem.,
                             Core PicName ADCS_bits IRCF_bits jalfile BankSize,
                             HasLATReg NumBanks PinmapMissCount msglevel
PortLat. = 0                                                /* no pins at all */
SFRaddr = 0                                                 /* start value */

do i = 1 to Pic.0  until (word(Pic.i,1) = '<edc:DataSpace'   |,
                          word(Pic.i,1) = '<edc:DataSpace>')    /* start of data */
   nop
end

do i = i to Pic.0 while word(pic.i,1) \= '</edc:DataSpace>'  /* end of SFRs */

   kwd = word(Pic.i,1)

   select

      when kwd = '<edc:NMMRPlace' then do                   /* start of NMMR section */
         do until word(Pic.i,1) = '</edc:NMMRPlace>'        /* skip all of it */
            i = i + 1
         end
      end

      when kwd = '<edc:SFRDataSector' then do               /* start of SFRs */
         parse var Pic.i '<edc:SFRDataSector' . 'edc:beginaddr="0x' val1 '"' .
         if val1 \= '' then
            SFRaddr = X2D(val1)
      end

      when kwd = '<edc:Mirror' then do
         parse var Pic.i '<edc:Mirror' 'edc:nzsize="' val1 '"' .
         if val1 \= '' then
            SFRaddr = SFRaddr + todecimal(val1)
      end

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then
            SFRaddr = SFRaddr + todecimal(val1)
      end

      when kwd = '<edc:JoinedSFRDef' then do
         parse var Pic.i '<edc:JoinedSFRDef' . 'edc:cname="' val1 '"' . 'edc:nzwidth="' val2 '"' .
         if val1 \= '' then do
            reg = strip(val1)
            Name.reg = reg                                        /* add to collection of names */
            addr = SFRaddr                                        /* decimal */
            Ram.addr = addr                                       /* mark address in use */
            addr = sfr_mirror_address(addr)                       /* add mirror addresses */
            width = todecimal(val2)
            if width <= 8 then                                    /* one byte */
               field = 'byte  '
            else if width <= 16  then                             /* two bytes */
               field = 'word  '
            else
               field = 'byte*'||(width+7)%8                       /* rounded to whole bytes */
            call lineout jalfile, '-- ------------------------------------------------'
            call list_variable field, reg, addr
            if (reg = 'FSR'      |,
                reg = 'PCL'      |,
                reg = 'TABLAT'   |,
                reg = 'TBLPTR') then do
               reg = tolower(reg)                                 /* to lower case */
               call list_variable field, '_'reg, addr             /* compiler privately */
            end
         end
      end

      when kwd = '<edc:MuxedSFRDef' then do
         do while word(Pic.i,1) \= '</edc:MuxedSFRDef>'
            if word(Pic.i,1) = '<edc:SelectSFR>' then             /* unconditional */
               cond = ''
            else if word(Pic.i,1) = '<edc:SelectSFR' then do
               parse var Pic.i '<edc:SelectSFR' 'edc:when="' val1 '"' .
               cond = val1                                        /* conditional */
            end
            else if word(Pic.i,1) = '<edc:SFRDef' then do
               parse var Pic.i '<edc:SFRDef' . 'edc:cname="' val1 '"' .
               if val1 \= '' then do
                  reg = strip(val1)
                  Name.reg = reg                                  /* add to collection of names */
                  subst  = '_'reg                                 /* substitute name */
                  addr = SFRaddr                                  /* decimal */
                  Ram.addr = addr                                 /* mark address in use */
                  addr = sfr_mirror_address(addr)                 /* add mirror addresses */
                  if cond = '' then do                            /* unconditional */
                     call lineout jalfile, '-- ------------------------------------------------'
                     call list_variable 'byte  ', reg, addr
                     call list_sfr_subfields i, reg               /* SFR bit fields */
                  end
               end

               do while word(Pic.i,1) \= '</edc:SFRDef>'
                  i = i + 1
               end

            end
            i = i + 1
         end
         SFRaddr = SFRaddr + 1
      end

      when kwd = '<edc:SFRDef' then do
         i_save = i                                               /* remember start SFR */
         parse var Pic.i '<edc:SFRDef' . 'edc:cname="' val1 '"' . 'edc:nzwidth="' val2 '"' .
         if val1 \= '' then do
            reg = strip(val1)
            Name.reg = reg                                        /* add to collection of names */
            width = todecimal(val2)
            addr = SFRaddr                                        /* decimal */
            Ram.addr = addr                                       /* mark address in use */
            addr = sfr_mirror_address(addr)                       /* add mirror addresses */
            field = 'byte  '
            call lineout jalfile, '-- ------------------------------------------------'
            if \(left(reg,4) = 'PORT'  |,
                      reg    = 'GPIO') then                       /* not PORTx or GPIO */
               call list_variable field, reg, addr

            select                                                /* possibly additional declarations  */
               when left(reg,3) = 'LAT' then do                   /* LATx register  */
                  call list_port16_shadow reg                     /* force use of LATx (core 16 like) */
                                                                  /* for output to PORTx */
               end
               when left(reg,4) = 'PORT' then do                  /* port */
                  if reg = 'PORTB'  &  left(PicName,2) = '12' then do
                     call msg 1, 'PORTB register interpreted as GPIO / PORTA'
                     call list_variable field, '_GPIO',  addr     /* GPIO */
                     call list_alias '_'PORTA, '_'GPIO            /* PORTA alias of GPIO */
                     call list_port1x_shadow 'PORTA'
                  end
                  else if HasLATReg = 0 then do                   /* PIC without LAT registers */
                     call list_variable field, '_'reg,  addr
                     call list_port1x_shadow reg
                  end
                  else do                                         /* PIC with LAT registers */
                     call list_variable field, reg, addr
                     PortLetter = substr(reg,4)
                     PortLat.PortLetter. = 0                      /* init: zero pins in PORTx */
                                                                  /* updated in list_sfr_subfields */
                  end
               end
               when reg = 'GPIO' then do                          /* port */
                  call list_variable field, '_'reg, addr
                  call list_alias '_'PORTA, '_'reg
                  call list_port1x_shadow 'PORTA'                 /* GPIO -> PORTA */
               end
               when (reg = 'SPBRG' | reg = 'SPBRG1') & width = 8 then do    /* 8-bits wide */
                  if Name.SPBRGL = '-' then                       /* SPBRGL not defined yet */
                     call list_alias 'SPBRGL', reg                /* add alias */
               end
               when (reg = 'SPBRG2' | reg = 'SP2BRG') & width = 8 then do   /* 8 bits wide */
                  if Name.SPBRGL2 = '-' then                      /* SPBRGL2 not defined yet */
                     call list_alias 'SPBRGL2', reg               /* add alias */
               end
               when reg = 'TRISIO' | reg = 'TRISGPIO' then do     /* low pincount PIC */
                  call list_alias  'TRISA', reg
                  call list_alias  'PORTA_direction', reg
                  call list_tris_nibbles 'TRISA'                  /* nibble direction */
               end
               when left(reg,4) = 'TRIS' then do                  /* TRISx */
                  call list_alias 'PORT'substr(reg,5)'_direction', reg
                  call list_tris_nibbles reg                      /* nibble direction */
               end
            otherwise
               nop                                                /* others can be ignored */
            end

            call list_sfr_subfields i, reg                        /* SFR bit fields */

            if (reg = 'BSR'      |,
                reg = 'FSR'      |,
                reg = 'FSR0L'    |,
                reg = 'FSR0H'    |,
                reg = 'FSR1L'    |,
                reg = 'FSR1H'    |,
                reg = 'INDF'     |,
                reg = 'INDF0'    |,
                reg = 'PCL'      |,
                reg = 'PCLATH'   |,
                reg = 'PCLATU'   |,
                reg = 'STATUS'   |,
                reg = 'TABLAT'   |,
                reg = 'TBLPTR'   |,
                reg = 'TBLPTRH'  |,
                reg = 'TBLPTRL'  |,
                reg = 'TBLPTRU') then do
               if reg = 'INDF' | reg = 'INDF0' then
                  reg = 'IND'                                     /* compiler wants '_ind' */
               reg = tolower(reg)                                 /* to lower case */
               call list_variable field, '_'reg, addr             /* compiler privately */
               if reg = 'status' then                             /* status register */
                  call list_status i                              /* compiler privately */
            end

            else if reg = 'TRISE'  &,
               (PicName = '16lf1904' | PicName = '16lf1906' | PicName = '16lf1907' ) then do
               /* --- extra --- (for missing TRISE3) */
               call msg 1, 'Adding TRISE3'
               call list_bitfield 1, 'TRISE_TRISE3', reg, 3
               pin = 'pin_E3_direction'
               call list_alias pin, 'TRISE_TRISE3'
               call list_pin_direction_alias reg, 'RE3', pin
               call lineout jalfile, '--'
            end

            call list_multi_module_register_alias i, reg          /* even when there are no  */
                                                                  /* multiple modules, register */
                                                                  /* aliases may have to be added */

         end

         do while word(Pic.i,1) \= '</edc:SFRDef>'
            i = i + 1
         end
         SFRaddr = SFRaddr + 1
      end

   otherwise
      nop

   end

end
return 0


/* ------------------------------------------------------ */
/* procedure to list SFR subfields                        */
/* input:  - index in pic. stem                           */
/*         - SFR name                                     */
/* Notes:  There are 2 parts in the subfield declaration: */
/*         1. intercept special cases                     */
/*            and declare 'normal' cases                  */
/*         2. add additional stuff                        */
/* -----------------------------------------------------  */
list_sfr_subfields: procedure expose Pic. Ram. Name. PinMap. PinANMap. SharedMem.,
                                     PortLat.,
                                     Core PicName ADCS_bits IRCF_bits jalfile BankSize,
                                     HasLATReg NumBanks PinmapMissCount msglevel
parse arg i, reg .

offset = 0

do i = i while word(pic.i,1) \= '</edc:SFRModeList>'

   kwd = word(pic.i,1)

   select

      when kwd = '<edc:SFRMode' then do                     /* new set of subfields */
         offset = 0                                         /* reset bitfield offset */
         parse var pic.i '<edc:SFRMode' 'edc:id="' val1 '"' .
         SFRmode_id = strip(val1)                           /* remember */
         if right(pic.i,2) \= '/>' then do                  /* has child nodes */
            if \(left(val1,3) = 'DS.' | left(val1,3) = 'LT.') then do
               do while word(pic.i,1) \= '</edc:SFRMode>'
                  i = i + 1
               end
            end
         end
      end

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then do
            val1 = todecimal(val1)
            if offset = 0           &,
               SFRmode_id = 'DS.0'  &,
               (PicName = '18f13k50' | PicName = '18lf13k50' |,        /* *** SPECIAL *** */
                PicName = '18f14k50' | PicName = '18lf14k50')  then do
               if reg = 'LATA' then do
                  call msg 1, 'Adding pin_A0, A1 and A3'
                  do p = 0 to 3                                /* add pin_A0..A3 */
                     if p = 2 then                             /* but NOT A2! */
                        iterate
                     call list_bitfield 1, 'LATA_LATA'p, 'LATA', p
                     call list_bitfield 1, 'pin_A'p, 'PORTA', p
                     call list_pin_alias 'PORTA', 'RA'p, 'pin_A'p
                     call lineout jalfile, '--'
                     call lineout jalfile, 'procedure' 'pin_A'p"'put"'(bit in x',
                                                'at LATA :' offset') is'
                     call lineout jalfile, '   pragma inline'
                     call lineout jalfile, 'end procedure'
                     call lineout jalfile, '--'
                  end
               end
               else if reg = 'TRISA' then do
                  call msg 1, 'Adding pin_A0/A1/A3_direction'
                  do p = 0 to 3                                /* add pin_A0..A3_direction */
                     if p = 2 then                             /* but NOT A2! */
                        iterate
                     call list_bitfield 1, 'TRISA_TRISA'p, 'TRISA', p
                     call list_alias 'pin_A'p'_direction', 'TRISA_TRISA'p
                     call list_pin_direction_alias 'TRISA', 'RA'p, 'pin_A'p'_direction'
                     call lineout jalfile, '--'
                  end
               end
            end
            offset = offset + val1
         end
      end

      when kwd = '<edc:SFRFieldDef' then do
         parse var Pic.i '<edc:SFRFieldDef' 'edc:cname="' val1 '"' . ,
                          'edc:mask="' val3 '"' . 'edc:nzwidth="' val4 '"' .
         if val1 \= '' then do
            val1 = toupper(strip(val1))
            field = reg'_'val1
            if right(reg,5) = '_SHAD' & right(val1,5) = '_SHAD' then
               field = left(field, length(field) - 5)        /* remove trailing '_SHAD' */
            width = todecimal(val4)
            if width \= 8 then do                            /* skip 8-bit width subfields */

                                                             /* *** INTERCEPTIONS *** */
               select
                  when reg = 'ADCON0' & val1 = 'ADCS' & width = 2  &,
                      (PicName = '16f737'  | PicName = '16f747'  |,
                       PicName = '16f767'  | PicName = '16f777'  |,
                       PicName = '16f818'  | PicName = '16f819'  |,
                       PicName = '16f873a' | PicName = '16f874a' |,
                       PicName = '16f876a' | PicName = '16f877a' |,
                       PicName = '16f88'                         |,
                       PicName = '18f242'  | PicName = '18f2439' |,   /* splitted ADCS bits */
                       PicName = '18f248'                        |,
                       PicName = '18f252'  | PicName = '18f2539' |,
                       PicName = '18f258'                        |,
                       PicName = '18f442'  | PicName = '18f4439' |,
                       PicName = '18f448'                        |,
                       PicName = '18f452'  | PicName = '18f4539' |,
                       PicName = '18f458'                        ) then do
                     call list_bitfield width, reg'_ADCS10', reg, offset
                     if core = '16' then do                 /* ADCON1 comes before ADCON0 */
                        call lineout jalfile, '--'
                        call lineout jalfile, 'var volatile byte   ADCON0_ADCS    -- shadow'
                        call lineout jalfile, 'procedure  ADCON0_ADCS'"'put"'(byte in x) is'
                        call lineout jalfile, '   ADCON0_ADCS10 = (x & 0x03)      -- low order bits'
                        call lineout jalfile, '   ADCON1_ADCS2  = (x & 0x04)      -- high order bit'
                        call lineout jalfile, 'end procedure'
                        call lineout jalfile, '--'
                     end
                  end
                  when reg = 'ADCON1'  &  val1 = 'ADCS2'  &,
                      (PicName = '16f737'  | PicName = '16f747'  |,
                       PicName = '16f767'  | PicName = '16f777'  |,
                       PicName = '16f818'  | PicName = '16f819'  |,
                       PicName = '16f873a' | PicName = '16f874a' |,
                       PicName = '16f876a' | PicName = '16f877a' |,
                       PicName = '16f88'                         |,
                       PicName = '18f242'  | PicName = '18f2439' |,   /* splitted ADCS bits */
                       PicName = '18f248'                        |,
                       PicName = '18f252'  | PicName = '18f2539' |,
                       PicName = '18f258'                        |,
                       PicName = '18f442'  | PicName = '18f4439' |,
                       PicName = '18f448'                        |,
                       PicName = '18f452'  | PicName = '18f4539' |,
                       PicName = '18f458'                        ) then do
                     call list_bitfield width, field, reg, offset
                     if core = '14' then do                 /* ADCON0 comes before ADCON1 */
                        call lineout jalfile, '--'
                        call lineout jalfile, 'var volatile byte   ADCON0_ADCS    -- shadow'
                        call lineout jalfile, 'procedure  ADCON0_ADCS'"'put"'(byte in x) is'
                        call lineout jalfile, '   ADCON0_ADCS10 = (x & 0x03)      -- low order bits'
                        call lineout jalfile, '   ADCON1_ADCS2  = (x & 0x04)      -- high order bit'
                        call lineout jalfile, 'end procedure'
                        call lineout jalfile, '--'
                     end
                  end
                  when reg = 'ADCON0'  &,                   /* ADCON0 */
                       (PicName = '16f737'  | PicName = '16f747'  |,
                        PicName = '16f767'  | PicName = '16f777')   &,
                        val1 = 'CHS' then do
                     call list_bitfield width, field'210', reg, offset
                     call lineout jalfile, '--'
                     call lineout jalfile, 'procedure' reg'_CHS'"'put"'(byte in x) is'
                     call lineout jalfile, '   'reg'_CHS210 = (x & 0x07)     -- low order bits'
                     call lineout jalfile, '   'reg'_CHS3   = 0              -- reset'
                     call lineout jalfile, '   if ((x & 0x08) != 0) then'
                     call lineout jalfile, '      'reg'_CHS3 = 1             -- high order bit'
                     call lineout jalfile, '   end if'
                     call lineout jalfile, 'end procedure'
                     call lineout jalfile, '--'
                  end
                  when (left(val1,2) = 'AN'  &  width = 1)  &,             /* AN(S) subfield */
                       (left(reg,5) = 'ADCON'  | left(reg,5) = 'ANSEL')  then do
                     call list_bitfield 1, field, reg, offset
                     ansx = ansel2j(reg, val1)
                     if ansx < 99 then                      /* valid number */
                        call list_alias 'JANSEL_ANS'ansx, field
                  end
                  when pos('CCP',reg) > 0  & right(reg,3) = 'CON'  &,   /* [E]CCPxCON */
                       left(val1,3) = 'CCP'                        &,
                       (right(val1,1) = 'X' | right(val1,1) = 'Y') then do   /* CCP.X/Y */
                     nop                                    /* suppress */
                  end
                  when (reg = 'GPIO' & left(val1,2) = 'RB') then do  /* suppress wrong pinnames */
                     nop
                  end
                  when (reg = 'GPIO' & left(val1,2) = 'GP') then do
                     if width = 1 then do                   /* only single pins */
                        field = reg'_GP'right(val1,1)       /* pin GPIOx -> GPx */
                        call list_bitfield 1, field, '_'reg, offset
                     end
                  end
                  when reg = 'OSCCON' & left(val1,4) = 'IRCF' & width = 1 then do
                     nop                                    /* suppress enumerated IRCF bits */
                  end
                  when reg = 'OPTION_REG' & val1 = 'PS2' then do
                     call list_bitfield 1, reg'_PS', reg, offset
                  end
                  when reg = 'PORTB' & left(val1,2) = 'RB' & left(PicName,2) = '12' then do
                     field = 'GPIO_GP'right(val1,1)         /* pin GPIO_GPx */
                     call list_bitfield width, field, '_GPIO', offset
                  end
                  when (PicName = '18f4439' | PicName = '18f4539') &,
                       (reg = 'PORTE' | reg = 'LATE')              &,
                       (offset > 2) then do
                     call msg 1, 'suppressing pin' offset 'of' reg
                     nop                                    /* suppress non existing pins */
                  end
                  when (left(reg,4) = 'PORT' | reg = 'GPIO') &,    /* exceptions for PORTx or GPIO */
                        HasLATReg = 0 then do                      /* PIC without LAT registers */
                     call list_bitfield 1, field, '_'reg, offset
                  end
                  when width > 1  &,                        /* no multi-bit fields for pins */
                       (left(reg,4) = 'PORT' | left(reg,4) = 'GPIO'   |,
                        left(reg,3) = 'LAT'  | left(reg,4) = 'TRIS')  then do
                     nop
                  end

               otherwise

                  if subfields_wanted(reg) > 0 then         /* subfields of some SFRs unwanted */
                     call list_bitfield width, field, reg, offset

               end

                                                            /* *** ADDITIONS *** */
               select
                  when left(reg,5) = 'ADCON'  &,            /* ADCON0/1 */
                       right(field,5) = 'VCFG0' then do     /* enumerated VCFG field */
                     field = reg'_VCFG'
                     if Name.field = '-' then               /* multi-bit field not declared */
                        call list_bitfield 2, field, reg, offset
                  end
                  when reg = 'CANCON'  &  val1 = 'REQOP0' then do
                     call list_bitfield 3, reg'_REQOP', reg, offset
                  end
                  when pos('CCP',reg) > 0  &  right(reg,3) = 'CON' &,   /* [E]CCPxCON */
                     ((left(val1,3) = 'CCP' &  right(val1,1) = 'Y') |,    /* CCPxY */
                      (left(val1,2) = 'DC' &  right(val1,2) = 'B0')) then do /* DCxB0 */
                     if left(val1,2) = 'DC' then
                        field = reg'_DC'substr(val1,3,1)'B'
                     else
                        field = reg'_DC'substr(val1,4,1)'B'
                     call list_bitfield 2, field, reg, (offset - width + 1)
                  end
                  when reg = 'FVRCON'  &  (val1 = 'CDAFVR0' | val1 = 'ADFVR0') then do
                     call list_bitfield 2, strip(field,'T','0'), reg, offset
                  end
                  when reg = 'GPIO' then do
                     if left(val1,2) = 'GP' & width = 1 then do    /* single I/O pin */
                        if HasLATReg = 0 then do                  /* PIC without LAT registers */
                           shadow = '_PORTA_shadow'
                           pin = 'pin_A'right(val1,1)
                           if list_bitfield(1, pin, '_'reg, offset) = 0 then do
                              call list_pin_alias 'PORTA', 'RA'right(val1,1), pin
                              call lineout jalfile, '--'
                              call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                               'at' shadow ':' offset') is'
                              call lineout jalfile, '   pragma inline'
                              call lineout jalfile, '   _PORTA =' shadow
                              call lineout jalfile, 'end procedure'
                              call lineout jalfile, '--'
                           end
                        end
                        else do                                   /* PIC with LAT registers */
                           PortLetter = right(reg,1)
                           PortLat.PortLetter.offset = PortLetter||offset
                        end
                     end
                  end
                  when reg = 'INTCON' then do
                     if left(val1,2) = 'T0' then
                        call list_bitfield 1, reg'_TMR0'substr(val1,3), reg, offset
                  end
                  when left(reg,3) = 'LAT' & width = 1 then do     /* single pin */
                     if \( (PicName = '18f4439' | PicName = '18f4539') &,
                           (reg = 'PORTE' | reg = 'LATE')              &,
                           (offset > 2) )  then do                 /* only existing pins */
                        PortLetter = right(reg,1)
                        PinNumber  = right(val1,1)
                        pin = 'pin_'PortLat.PortLetter.offset
                        if PortLat.PortLetter.offset \= 0 then do  /* pin present in PORTx */
                           if Name.pin = '-' then do               /* not already declared */
                              call list_bitfield 1, pin, 'PORT'PortLetter, offset
                              call list_pin_alias 'PORT'portletter, 'R'PortLat.PortLetter.offset, pin
                              call lineout jalfile, '--'
                              call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                         'at' reg ':' offset') is'
                              call lineout jalfile, '   pragma inline'
                              call lineout jalfile, 'end procedure'
                              call lineout jalfile, '--'
                           end
                        end
                     end
                  end
                  when reg = 'OPTION_REG' &,
                       (val1 = 'T0CS' | val1 = 'T0SE' | val1 = 'PSA') then do
                     call list_alias 'T0CON_'val1, reg'_'val1
                  end
                  when reg = 'OPTION_REG' & val1 = 'PS2' then do
                     call list_bitfield 1, field, reg, offset
                     call list_alias 'T0CON_T0PS', reg'_'PS
                  end
                  when reg = 'OSCCON'  &  val1 = 'IRCF0' then do
                     call list_bitfield IRCF_bits, reg'_IRCF', reg, offset
                  end
                  when reg = 'PADCFG1'  &  val1 = 'RTSECSEL0' then do
                     call list_bitfield 2, reg'_RTSECSEL', reg, offset
                  end
                  when left(reg,4) = 'PORT' & width = 1 then do
                     if left(val1,1) = 'R'  &,
                        substr(val1,2,length(val1)-2) = right(reg,1) then do  /* prob. I/O pin */
                        if reg = 'PORTB' & left(val1,2) = 'RB' & left(PicName,2) = '12' then do
                           shadow = '_PORTA_shadow'
                           pin = 'pin_A'right(val1,1)
                           call list_bitfield 1, pin, '_GPIO', offset
                           call list_pin_alias reg, 'RA'right(val1,1), pin
                           call lineout jalfile, '--'
                           call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                          'at' shadow ':' offset') is'
                           call lineout jalfile, '   pragma inline'
                           call lineout jalfile, '   _PORTA =' shadow
                           call lineout jalfile, 'end procedure'
                           call lineout jalfile, '--'
                        end
                        else if HasLATReg = 0 then do       /* PIC without LAT registers */
                           shadow = '_PORT'right(reg,1)'_shadow'
                           pin = 'pin_'right(val1,2)
                           if list_bitfield(1, pin, '_'reg, offset) = 0 then do
                              call list_pin_alias reg, 'R'right(val1,2), pin
                              call lineout jalfile, '--'
                              call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                             'at' shadow ':' offset') is'
                              call lineout jalfile, '   pragma inline'
                              call lineout jalfile, '   _PORT'substr(reg,5) '=' shadow
                              call lineout jalfile, 'end procedure'
                              call lineout jalfile, '--'
                           end
                        end
                        else do                             /* PIC with LAT registers */
                           PortLetter = substr(reg,5)
                           PortLat.PortLetter.offset = PortLetter||offset
                        end
                     end
                  end
                  when left(field,12) = 'TRISIO_TRISA' then do  /* esp. several 12f/hv6xx */
                     nop                                    /* no subfields wanted */
                  end
                  when reg = 'TRISIO' | reg = 'TRISGPIO' then do
                     pin = 'pin_A'right(val1,1)'_direction'
                     if list_alias(pin, reg'_'val1) = 0 then
                        call list_pin_direction_alias 'TRISA', 'RA'right(val1,1), pin
                     call lineout jalfile, '--'
                  end
                  when left(reg,4) = 'TRIS' & left(val1,4) = 'TRIS' & width = 1 then do
                                                                   /* single tris bit */
                     pin = 'pin_'substr(val1,5)'_direction'
                     call list_alias pin, reg'_'val1
                     if substr(val1,5,1) = right(reg,1) then
                        call list_pin_direction_alias reg, 'R'substr(val1,5), pin
                     call lineout jalfile, '--'
                  end
               otherwise
                  nop
               end

            end

            if subfields_wanted(reg) > 0 then
               call list_multi_module_bitfield_alias reg, toupper(val1)

            Offset = Offset + width

         end
      end

   otherwise
      nop
   end

end
return 0



/* ---------------------------------------------------- */
/* procedure to list (only) multiplexed registers       */
/* input:  - nothing                                    */
/* ---------------------------------------------------- */
list_muxed_sfr: procedure expose Pic. Ram. Name. PinMap. PinANMap. ,
                                 Core PicName jalfile BankSize HasMuxedSFR msglevel

SFRaddr = 0                                                 /* start value */

if HasMuxedSFR > 0 then do
  call lineout jalfile,'--'
  call lineout jalfile,'-- ========================================================'
  call lineout jalfile,'--'
  call lineout jalfile,'--  Multiplexed registers'
  call lineout jalfile,'--'
end

do i = 1 to Pic.0  until (word(Pic.i,1) = '<edc:DataSpace'   |,
                          word(Pic.i,1) = '<edc:DataSpace>')    /* start of data */
   nop
end

do i = i to Pic.0 while word(pic.i,1) \= '</edc:DataSpace>'  /* end of SFRs */

   kwd = word(Pic.i,1)

   select

      when kwd = '<edc:NMMRPlace' then do                   /* start of NMMR section */
         do until word(Pic.i,1) = '</edc:NMMRPlace>'        /* skip all of it */
            i = i + 1
         end
      end

      when kwd = '<edc:SFRDataSector' then do               /* start of SFRs */
         parse var Pic.i '<edc:SFRDataSector' . 'edc:beginaddr="0x' val1 '"' .
         if val1 \= '' then
            SFRaddr = X2D(val1)
      end

      when kwd = '<edc:Mirror' then do
         parse var Pic.i '<edc:Mirror' 'edc:nzsize="' val1 '"' .
         if val1 \= '' then
            SFRaddr = SFRaddr + todecimal(val1)
      end

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then
            SFRaddr = SFRaddr + todecimal(val1)
      end

      when kwd = '<edc:MuxedSFRDef' then do
         do while word(Pic.i,1) \= '</edc:MuxedSFRDef>'
            if word(Pic.i,1) = '<edc:SelectSFR>' then             /* no conditional expression */
               cond = ''
            else if word(Pic.i,1) = '<edc:SelectSFR' then do
               parse var Pic.i '<edc:SelectSFR' 'edc:when="' val1 '"' .
               cond = val1                                        /* condition expression */
            end
            else if word(Pic.i,1) = '<edc:SFRDef' then do
               parse var Pic.i '<edc:SFRDef' . 'edc:cname="' val1 '"' .
               if val1 \= '' then do
                  if cond \= '' then do                           /* only conditional SFRs */
                     reg = strip(val1)
                     Name.reg = reg                               /* add to collection of names */
                     subst  = '_'reg                              /* substitute name */
                     addr = SFRaddr                               /* decimal */
                     addr = sfr_mirror_address(addr)              /* add mirror addresses */
                     call lineout jalfile, '-- ------------------------------------------------'
                     parse var cond '($0x'val1 val2 '0x'val3')' . '0x' val4 .

                     if core = '14' then do
                        if reg = 'SSPMSK' then do
                           call lineout jalfile, 'var volatile byte  ' left(subst,25) 'at' addr
                           call lineout jalfile, '-- ----- Address 0x'val1 'assumed to be SSPCON -----'
                           call lineout jalfile, 'procedure' reg"'put"'(byte in x) is'
                           call lineout jalfile, '   var byte _sspcon_saved = SSPCON'
                           call lineout jalfile, '   SSPCON = SSPCON' toascii(val2) '(!0x'val3')'
                           call lineout jalfile, '   SSPCON = SSPCON | 0x'val4
                           call lineout jalfile, '   'subst '= x'
                           call lineout jalfile, '   SSPCON = _sspcon_saved'
                           call lineout jalfile, 'end procedure'
                           call lineout jalfile, 'function' reg"'get"'() return byte is'
                           call lineout jalfile, '   var  byte  x'
                           call lineout jalfile, '   var byte _sspcon_saved = SSPCON'
                           call lineout jalfile, '   SSPCON = SSPCON' toascii(val2) '(!0x'val3')'
                           call lineout jalfile, '   SSPCON = SSPCON | 0x'val4
                           call lineout jalfile, '   x =' subst
                           call lineout jalfile, '   SSPCON = _sspcon_saved'
                           call lineout jalfile, '   return  x'
                           call lineout jalfile, 'end function'
                           call lineout jalfile, '--'
                        end
                        else
                           call msg 3, 'Unexpected multiplexed SFR' reg 'for core' core
                     end

                     else if core = '16' then do
                        if reg = 'SSP1MSK' |,
                           reg = 'SSP2MSK' then do
                           index = substr(reg,4,1)                   /* SSP module number */
                           call lineout jalfile, 'var volatile byte  ' left(subst,25) 'at' addr
                           call lineout jalfile, '-- ----- address 0x'val1 'assumed to be SSP'index'CON1 -----'
                           call lineout jalfile, 'procedure' reg"'put"'(byte in x) is'
                           call lineout jalfile, '   var byte _ssp'index'con1_saved = SSP'index'CON1'
                           call lineout jalfile, '   SSP'index'CON1 = SSP'index'CON1' toascii(val2) '(!0x'val3')'
                           call lineout jalfile, '   SSP'index'CON1 = SSP'index'CON1 | 0x'val4
                           call lineout jalfile, '   'subst '= x'
                           call lineout jalfile, '   SSP'index'CON1 = _ssp'index'con1_saved'
                           call lineout jalfile, 'end procedure'
                           call lineout jalfile, 'function' reg"'get"'() return byte is'
                           call lineout jalfile, '   var  byte  x'
                           call lineout jalfile, '   var  byte  _ssp'index'con1_saved = SSP'index'CON1'
                           call lineout jalfile, '   SSP'index'CON1 = SSP'index'CON1' toascii(val2) '(!0x'val3')'
                           call lineout jalfile, '   SSP'index'CON1 = SSP'index'CON1 | 0x'val4
                           call lineout jalfile, '   x =' subst
                           call lineout jalfile, '   SSP'index'CON1 = _ssp'index'con1_saved'
                           call lineout jalfile, '   return  x'
                           call lineout jalfile, 'end function'
                           call lineout jalfile, '--'
                           if reg = SSP1MSK then
                              call list_alias  'SSPMSK', reg
                        end

                        else if left(reg,6) = 'PMDOUT' then do
                           call list_variable 'byte  ', reg, addr
                        end

                        else if left(reg,5) = 'ODCON' |,
                                left(reg,5) = 'ANCON' |,
                                reg = 'CVRCON'        |,
                                reg = 'MEMCON'        |,
                                reg = 'PADCFG1'       |,
                                reg = 'REFOCON'      then do
                           call lineout jalfile, 'var volatile byte  ' left(subst,25) 'at' addr
                           call lineout jalfile, '-- ----- address 0x'val1 'assumed to be WDTCON -----'
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

                           call list_muxed_sfr_subfields i, reg     /* SFR bit fields */

                        end

                        else
                           call msg 3, 'Unexpected multiplexed SFR' reg 'for core' core

                     end

                     else
                        call msg 3, 'Unexpected core' core 'with multiplexed SFR' reg

                  end
               end
               do while word(Pic.i,1) \= '</edc:SFRDef>'
                  i = i + 1
               end
            end
            i = i + 1
         end
         SFRaddr = SFRaddr + 1                        /* muxed SFRs count for 1 */
      end

      when kwd = '<edc:SFRDef' then do
         do while word(Pic.i,1) \= '</edc:SFRDef>'
            i = i + 1
         end
         SFRaddr = SFRaddr + 1
      end

   otherwise
      nop

   end

end
return 0


/* ---------------------------------------------------------- */
/* Formatting of subfields of multiplexed SFRs                */
/* of the 18F series                                          */
/* input:  - index in .pic                                    */
/*         - register name                                    */
/* 16-bit core                                                */
/* ---------------------------------------------------------- */
list_muxed_sfr_subfields: procedure expose Pic. Name. PinMap. PicName jalfile msglevel

parse arg i, reg .

offset = 0

do while word(pic.i,1) \= '</edc:SFRModeList>'

   kwd = word(Pic.i,1)

   select

      when kwd = '<edc:SFRMode' then do                     /* new set of subfields */
         offset = 0                                         /* reset bitfield offset */
         parse var Pic.i '<edc:SFRMode' 'edc:id="' val1 '"' .
         if \(left(val1,3) = 'DS.' | left(val1,3) = 'LT.') then do
            do until word(pic.i,1) = '</edc:SFRMode>'
               i = i + 1
            end
         end
      end

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then do
            offset = offset + val1
         end
      end

      when kwd = '<edc:SFRFieldDef' then do
         parse var Pic.i '<edc:SFRFieldDef' 'edc:cname="' val1 '"' . ,
                          'edc:mask="' val3 '"' . 'edc:nzwidth="' val4 '"' .
         if val1 \= '' then do
            field = reg'_'val1
            width = todecimal(val4)
            if width \= 8 then do                           /* skip 8-bit width subfields */

               field = reg'_'val1
               Name.field = field                           /* remember name */
               subst = '_'reg                               /* substitute name of SFR */

               if width = 1 then do                         /* single bit */
                  call lineout jalfile, 'procedure' field"'put"'(bit in x) is'
                  call lineout jalfile, '   var  bit   y at' subst ':' offset
                  call lineout jalfile, '   WDTCON_ADSHR = TRUE'
                  call lineout jalfile, '   y = x'
                  call lineout jalfile, '   WDTCON_ADSHR = FALSE'
                  call lineout jalfile, 'end procedure'
                  call lineout jalfile, 'function ' field"'get"'() return bit is'
                  call lineout jalfile, '   var  bit   x at' subst ':' offset
                  call lineout jalfile, '   var  bit   y'
                  call lineout jalfile, '   WDTCON_ADSHR = TRUE'
                  call lineout jalfile, '   y = x'
                  call lineout jalfile, '   WDTCON_ADSHR = FALSE'
                  call lineout jalfile, '   return y'
                  call lineout jalfile, 'end function'
                  call lineout jalfile, '--'
               end
               else if width < 8  then do                   /* multi-bit */
                  call lineout jalfile, 'procedure' field"'put"'(bit*'width 'in x) is'
                  call lineout jalfile, '   var  bit*'width 'y at' subst ':' offset
                  call lineout jalfile, '   WDTCON_ADSHR = TRUE'
                  call lineout jalfile, '   y = x'
                  call lineout jalfile, '   WDTCON_ADSHR = FALSE'
                  call lineout jalfile, 'end procedure'
                  call lineout jalfile, 'function ' field"'get"'() return bit*'width 'is'
                  call lineout jalfile, '   var  bit*'width 'x at' subst ':' offset
                  call lineout jalfile, '   var  bit*'width 'y'
                  call lineout jalfile, '   WDTCON_ADSHR = TRUE'
                  call lineout jalfile, '   y = x'
                  call lineout jalfile, '   WDTCON_ADSHR = FALSE'
                  call lineout jalfile, '   return y'
                  call lineout jalfile, 'end function'
                  call lineout jalfile, '--'
               end
            end
         end
         offset = offset + width
      end

   otherwise
      nop

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
PicNameCaps = toupper(PicName)
if PinMap.PicNameCaps.PinName.0 = '?' then do
   call msg 2, 'list_pin_alias() PinMap.'PicNameCaps'.'PinName 'is undefined'
   PinmapMissCount = PinmapMissCount + 1                    /* count misses */
   return 0                                                 /* no alias */
end
if PinMap.PicNameCaps.PinName.0 > 0 then do
   do k = 1 to PinMap.PicNameCaps.PinName.0                 /* all aliases */
      pinalias = 'pin_'PinMap.PicNameCaps.PinName.k
      call list_alias pinalias, Pin
      if pinalias = 'pin_SDA1' |,                           /* 1st I2C module */
         pinalias = 'pin_SDI1' |,                           /* 1st SPI module */
         pinalias = 'pin_SDO1' |,
         pinalias = 'pin_SCK1' |,
         pinalias = 'pin_SCL1' |,
         pinalias = 'pin_SS1'  |,
         pinalias = 'pin_TX1'  |,                           /* 1st USART */
         pinalias = 'pin_RX1' then
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
PicNameCaps = toupper(PicName)
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
/* input:  - index i in Pic.i of line with this register              */
/*         - register                                                 */
/* returns: nothing                                                   */
/* notes:  - add unqualified alias for module 1                       */
/*         - add (modified) alias for modules 2..9                    */
/*         - bitfields are expanded as for 'real' registers           */
/* All cores                                                          */
/* ------------------------------------------------------------------ */
list_multi_module_register_alias: procedure expose Pic. Name. Core PicName jalfile msglevel

parse upper arg i, reg

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
        reg = 'SPBRG1'   |,
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
   if subfields_wanted(reg) > 0 then                        /* subfields desired */
      call list_sfr_subfield_alias i, alias, reg            /* declare subfield aliases */
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
list_multi_module_bitfield_alias: procedure expose Name. Core jalfile msglevel

parse arg reg, bitfield

j = 0                                                    /* default: no multi-module */

bitfield = toupper(bitfield)                             /* must be all capitals */
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
   return                                                /* no alias required */
if j = 1 then                                            /* first module */
   j = ''                                                /* no suffix */
alias = reg'_'strippedfield||j                           /* alias name (with suffix) */
call list_alias alias, reg'_'bitfield                    /* declare alias subfields */
return


/* --------------------------------------------------------------------- */
/* Procedure to determine if subfields of a specific register are wanted */
/* input:  - register name                                               */
/* returns: 0 - no expansion                                             */
/*          1 - expansion desired                                        */
/* --------------------------------------------------------------------- */
subfields_wanted: procedure expose PicName
parse upper arg reg .

if  left(reg,3) = 'SSP' &,                                  /* SSPx  register */
     (right(reg,3) = 'ADD' | right(reg,3) = 'BUF' | right(reg,3) = 'MSK') then do
   return 0                                                 /* subfields not wanted */
end

return 1                                                    /* subfields wanted */
end


/* ------------------------------------------------------- */
/* List a line with a volatile variable                    */
/* arguments: - type (byte, word, etc.)                    */
/*            - name                                       */
/*            - address (decimal or string)                */
/* returns:   nothing                                      */
/* ------------------------------------------------------- */
list_variable: procedure expose Core JalFile Name.
parse arg type, var, addr                                   /* addr can be string with spaces */
if addr = '' then do
   call msg 3, 'list_variable(): less than 3 arguments found, no output generated!'
   return
end
if duplicate_name(var, var) \= 0 then                       /* name already declared */
   return
call charout jalfile, 'var volatile' left(type,max(6,length(type))),
                                     left(var,max(25,length(var)))' at '
call lineout jalfile, addr                                  /* string */
return


/* --------------------------------------------------------- */
/* List a line with a volatile bitfield variable             */
/* arguments: - width in bits (1,2, .. 8)                    */
/*            - name of the bit                              */
/*            - register                                     */
/*            - offset within the register                   */
/*            - address (decimal, only for core 14H and 16)  */
/* returns:   - 0 all OK                                     */
/*            - 1 specification error                        */
/*            - returncode of duplicate_name()               */
/* --------------------------------------------------------- */
list_bitfield: procedure expose Core JalFile Name.
parse arg width, bitfield, reg, offset, addr .
if offset = '' then do
   call msg 3, 'list_bitfield(): less than 4 arguments found, no output generated!'
   return
end
if datatype(width) \= 'NUM'  |  width < 1  |  width > 8 then do
   call msg 3, 'list_bitfield(): bitfield width' width 'not supported, no output generated!'
   return 1
end

rx = duplicate_name(bitfield, reg)                          /* check for duplicate */
if rx \= 0 then                                             /* name already declared */
   return rx
call charout jalfile, 'var volatile '
if width = 1 then
   call charout jalfile, left('bit',7)
else
   call charout jalfile, left('bit*'width,7)
call lineout jalfile, left(bitfield,max(25,length(bitfield))),
                      'at' reg ':' offset
return 0


/* ------------------------------------------------------- */
/* List a line with an alias declaration                   */
/* arguments: - name of alias                              */
/*            - name of original variable (or other alias) */
/* returns:   - returncode of duplicate_name()             */
/* ------------------------------------------------------- */
list_alias: procedure expose Core JalFile Name. reg msglevel
parse arg alias, original .
if orininal = '' then do
   call msg 3, 'list_alias(): 2 arguments expected, no output generated!'
   return
end
rx = duplicate_name(alias,reg)
if rx = 0 then do
   call lineout jalfile, left('alias',19) left(alias,max(25,length(alias))) 'is' original
end
return rx


/* --------------------------------------------- */
/* Formatting of SFR subfield aliases            */
/* Generates aliases for bitfields               */
/* input:  - index of register line  in .pic     */
/*         - alias of register                   */
/*         - original register                   */
/* --------------------------------------------- */
list_sfr_subfield_alias: procedure expose Pic. Name. PinMap. PinANMap. PortLat. ,
                                          PicName Core jalfile msglevel
parse arg i, reg_alias, reg .

do while word(pic.i,1) \= '</edc:SFRModeList>'

   kwd = word(Pic.i,1)

   select

      when kwd = '<edc:SFRMode' then do                     /* new set of subfields */
         offset = 0                                         /* reset bitfield offset */
         parse var Pic.i '<edc:SFRMode' 'edc:id="' val1 '"' .
         if \(left(val1,3) = 'DS.' | left(val1,3) = 'LT.') then do
            do until word(pic.i,1) = '</edc:SFRMode>'       /* skip SIM. etc */
               i = i + 1
            end
         end
      end

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then do
            offset = offset + val1
         end
      end

      when kwd = '<edc:SFRFieldDef' then do
         parse var Pic.i '<edc:SFRFieldDef' 'edc:cname="' val1 '"' . ,
                          'edc:mask="' val3 '"' . 'edc:nzwidth="' val4 '"' .
         if val1 \= '' then do
            val1 = toupper(val1)
            field = reg'_'val1
            width = todecimal(val4)
            alias  = ''                                     /* nul alias */
            if width \= 8 then do                           /* skip 8-bit width subfields */
               original = reg'_'val1                        /* original subfield */
               if (left(n.j,4) = 'SSPM' & datatype(substr(val1,5)) = 'NUM') then do
                  if right(val1,1) = '0' then do            /* last enumerated bit */
                     alias = reg_alias'_SSPM'               /* not enumerated */
                     original = reg'_SSPM'                  /* modify original too */
                  end
               end
               else do
                  alias = reg_alias'_'val1
               end
            end
            if alias \= '' then do
               call list_alias alias, original
            end
         end
         offset = offset + width                            /* next offset */
      end
   otherwise
      nop
   end
   i = i + 1                                                /* next record */
end
return 0


/* -------------------------------------------------- */
/* Procedure to list non memory mapped registers      */
/* of 12-bit core as pseudo variables.                */
/* Only some selected registers are handled:          */
/* TRISxx and OPTIONxx (and GPIO as TRISIO)           */
/* input:  - nothing                                  */
/* 12-bit core                                        */
/* -------------------------------------------------- */
list_nmmr12: procedure expose Pic. Ram. Name. PinMap.  SharedMem. PicName,
                              jalfile  BankSize  NumBanks  msglevel
do i = 1 to Pic.0  while word(Pic.i,1) \= '<edc:NMMRPlace'  /* start of NMMR specs */
   nop
end

do i = i to Pic.0 while word(pic.i,1) \= '</edc:NMMRPlace>'   /* end of NMMRs */

   kwd = word(Pic.i,1)
   if kwd = '<edc:SFRDef' then do
      parse var Pic.i '<edc:SFRDef' . 'edc:cname="' val1 '"' .
      if val1 \= '' then do
         reg = strip(val1)
         field = 'byte  '

         if left(reg,4) = 'TRIS' then do                       /* handle TRISIO or TRISGPIO */
            Name.reg = reg                                     /* add to collection of names */
            call lineout jalfile, '-- ------------------------------------------------'
            portletter = substr(reg,5)
            if portletter = 'IO' |  portletter = 'GPIO' |  portletter = '' then do   /* TRIS[GP][IO] */
               portletter = 'A'                                /* handle as TRISA */
               call msg 1, reg 'register interpreted as PORTA'
            end
            else if portletter = 'B' & left(picname,2) = '12' then do   /* TRISB for 12Fxxx */
               reg = 'TRISIO'
               portletter = 'A'
               call msg 1, reg 'register interpreted as TRISIO'
            end
            shadow = '_TRIS'portletter'_shadow'
            if sharedmem.0 < 1 then do
               call msg 1, 'No (more) shared memory for' shadow
               call lineout jalfile, 'var volatile byte  ' left(shadow,25) '= 0b1111_1111    -- all input'
            end
            else do
               shared_addr = sharedmem.2
               call lineout jalfile, 'var volatile byte  ' left(shadow,25) 'at 0x'D2X(shared_addr),
                                      '= 0b1111_1111    -- all input'
               sharedmem.2 = sharedmem.2 - 1
               sharedmem.0 = sharedmem.0 - 1
            end
            call lineout jalfile, '--'
            call lineout jalfile, 'procedure PORT'portletter"_direction'put(byte in x",
                                                                           'at' shadow') is'
            call lineout jalfile, '   pragma inline'
            call lineout jalfile, '   asm movf' shadow',W'
            if reg = 'TRISIO' | reg = 'TRISGPIO' then          /* TRIS[GP]IO (small PIC) */
               call lineout jalfile, '   asm tris 6'
            else                                               /* TRISx */
               call lineout jalfile, '   asm tris' 5 + C2D(portletter) - C2D('A')
            call lineout jalfile, 'end procedure'
            call lineout jalfile, '--'
            half = 'PORT'portletter'_low_direction'
            call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
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

         if left(reg,4) = 'GPIO' then do                       /* *** SPECIAL for 12F529Txxx */
            reg = 'TRISIO'                                     /* replace by TRISIO */
            Name.reg = reg                                     /* add to collection of names */
            call msg 2, 'NMMR GPIO interpreted as TRISIO / TRISA'
            call lineout jalfile, '-- ------------------------------------------------'
            shadow = '_TRISA_shadow'
            if sharedmem.0 < 1 then do
               call msg 1, 'No (more) shared memory for' shadow
               call lineout jalfile, 'var volatile byte  ' left(shadow,25) '= 0b1111_1111    -- all input'
            end
            else do
               shared_addr = sharedmem.2
               call lineout jalfile, 'var volatile byte  ' left(shadow,25) 'at 0x'D2X(shared_addr),
                                      '= 0b1111_1111    -- all input'
               sharedmem.2 = sharedmem.2 - 1
               sharedmem.0 = sharedmem.0 - 1
            end
            call lineout jalfile, '--'
            call lineout jalfile, "procedure PORTA_direction'put(byte in x" 'at' shadow') is'
            call lineout jalfile, '   pragma inline'
            call lineout jalfile, '   asm movf _TRISA_shadow,W'
            call lineout jalfile, '   asm tris 6'
            call lineout jalfile, 'end procedure'
            call lineout jalfile, '--'
            half = 'PORTA_low_direction'
            call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
            call lineout jalfile, '   'shadow '= ('shadow '& 0xF0) | (x & 0x0F)'
            call lineout jalfile, '   asm movf _TRISA_shadow,W'
            call lineout jalfile, '   asm tris 6'
            call lineout jalfile, 'end procedure'
            call lineout jalfile, '--'
            half = 'PORTA_high_direction'
            call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
            call lineout jalfile, '   'shadow '= ('shadow '& 0x0F) | (x << 4)'
            call lineout jalfile, '   asm movf _TRISA_shadow,W'
            call lineout jalfile, '   asm tris 6'
            call lineout jalfile, 'end procedure'
            call lineout jalfile, '--'
            call list_nmmr_sub12_tris i, reg                /* individual TRIS bits */
         end

         else if reg = 'OPTION_REG' | reg = OPTION2 then do  /* option */
            Name.reg = reg                                  /* add to collection of names */
            call lineout jalfile, '-- ------------------------------------------------'
            shadow = '_'reg'_shadow'
            if sharedmem.0 < 1 then do
               call msg 1, 'No (more) shared memory for' shadow
               call lineout jalfile, 'var volatile byte  ' left(shadow,25) '= 0b1111_1111    -- at reset'
            end
            else do
               shared_addr = sharedmem.2
               call lineout jalfile, 'var volatile byte  ' left(shadow,25) 'at 0x'D2X(shared_addr),
                                      '= 0b1111_1111    -- at reset'
               sharedmem.2 = sharedmem.2 - 1
               sharedmem.0 = sharedmem.0 - 1
            end
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
end
return 0


/* ---------------------------------------- */
/* Formatting of non memory mapped register */
/* subfields of TRISx                       */
/* input:  - index in .pic                  */
/*         - port letter                    */
/* 12-bit core                              */
/* ---------------------------------------- */
list_nmmr_sub12_tris: procedure expose Pic. Name. PinMap. PicName,
                                       jalfile msglevel
parse arg i, reg .
i = i + 1

do while word(pic.i,1) \= '</edc:SFRModeList>'

   kwd = word(Pic.i,1)

   select

      when kwd = '<edc:SFRMode' then do                     /* new set of subfields */
         offset = 0                                         /* bitfield offset */
         parse var Pic.i '<edc:SFRMode' 'edc:id="' val1 '"' .
         if left(val1,3) \= 'DS.' then do
            do while word(pic.i,1) \= '</edc:SFRMode>'
               i = i + 1
            end
         end
      end

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then
            offset = offset + val1
      end

      when kwd = '<edc:SFRFieldDef' then do
         parse var Pic.i '<edc:SFRFieldDef' 'edc:cname="' val1 '"' . ,
                          'edc:mask="' val3 '"' . 'edc:nzwidth="' val4 '"' .
         if val1 \= '' then do                              /* found */
            val1 = strip(val1)
            portletter = substr(reg,5)
            if portletter = 'IO' | portletter = 'GPIO' then     /* TRIS(GP)IO */
               portletter = 'A'                             /* handle as TRISA */
            shadow = '_TRIS'portletter'_shadow'
            call lineout jalfile, 'procedure pin_'portletter||offset"_direction'put(bit in x",
                                                      'at' shadow ':' offset') is'
            call lineout jalfile, '   pragma inline'
            call lineout jalfile, '   asm movf _TRIS'portletter'_shadow,W'
            if reg = 'TRISIO' | reg = 'TRISGPIO' then       /* TRIS(GP)IO */
               call lineout jalfile, '   asm tris 6'
            else                                            /* TRISx */
               call lineout jalfile, '   asm tris' 5 + C2D(portletter) - C2D('A')
            call lineout jalfile, 'end procedure'
            call list_pin_direction_alias reg, 'R'portletter||right(val1,1),,
                                  'pin_'portletter||right(val1,1)'_direction'
            call lineout jalfile, '--'
            offset = offset + todecimal(val4)
         end
      end

   otherwise
      nop

   end
   i = i + 1                                                /* next record */
end
return 0


/* ------------------------------------------------- */
/* Formatting of non memory mapped registers:        */
/* OPTION_REG and OPTION2                            */
/* input:  - index in .pic                           */
/*         - register name                           */
/* Generates names for pins or bits                  */
/* 12-bit core                                       */
/* ------------------------------------------------- */
list_nmmr_sub12_option: procedure expose Pic. Name. PinMap. PicName,
                                         jalfile msglevel
parse arg i, reg .
i = i + 1

do while word(pic.i,1) \= '</edc:SFRModeList>'

   kwd = word(Pic.i,1)

   select

      when kwd = '<edc:SFRMode' then do                     /* new set of subfields */
         offset = 0                                         /* bitfield offset */
         parse var Pic.i '<edc:SFRMode' 'edc:id="' val1 '"' .
         if left(val1,3) \= 'DS.' then do
            do until word(pic.i,1) = '</edc:SFRMode>'
               i = i + 1
            end
         end
      end

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then
            offset = offset + val1
      end

      when kwd = '<edc:SFRFieldDef' then do
         parse var Pic.i '<edc:SFRFieldDef' 'edc:cname="' val1 '"' . ,
                          'edc:mask="' val3 '"' . 'edc:nzwidth="' val4 '"' .
         if val1 \= '' then do                              /* found */
            call lineout jalfile, '--'
            field = toupper(reg'_'val1)
            Name.field = field                              /* remember name */
            val4 = todecimal(val4)
            shadow = '_'reg'_shadow'
            if val4 = 1 then
               call lineout jalfile, 'procedure' field"'put"'(bit in x',
                                                 'at' shadow ':' offset') is'
            else
               call lineout jalfile, 'procedure' field"'put"'(bit*'val4 'in x',
                                                 'at' shadow ':' offset') is'
            call lineout jalfile, '   pragma inline'
            call lineout jalfile, '   asm movf' shadow',0'
            if reg = 'OPTION_REG' then                      /* OPTION_REG */
               call lineout jalfile, '   asm option'
            else                                            /* OPTION2 */
               call lineout jalfile, '   asm tris 7'
            call lineout jalfile, 'end procedure'
            if reg = 'OPTION_REG' then do
               if val1 = 'T0CS' | val1 = 'T0SE' | val1 = 'PSA' then
                  call list_alias 'T0CON_'val1, reg'_'val1
               else if val1 = 'PS' then
                  call list_alias 'T0CON_T0'val1, reg'_'val1
            end
         end
         offset = offset + val4
      end

   otherwise
      nop

   end
   i = i + 1                                                /* next record */
end
return 0


/* --------------------------------------------------- */
/* procedure to create port shadowing functions        */
/* for full byte, lower- and upper-nibbles             */
/* For 12- and 14-bit core                             */
/* input:  - Port register                             */
/* shared memory is allocated from high to low address */
/* --------------------------------------------------- */
list_port1x_shadow: procedure expose jalfile sharedmem. msglevel
parse upper arg reg .
shadow = '_PORT'substr(reg,5)'_shadow'
call lineout jalfile, '--'
call lineout jalfile, 'var          byte  ' left('PORT'substr(reg,5),25) 'at _PORT'substr(reg,5)
if sharedmem.0 < 1 then do
   call msg 1, 'No (more) shared memory for' shadow
   call lineout jalfile, 'var volatile byte  ' left(shadow,25)
end
else do
   shared_addr = sharedmem.2
   call lineout jalfile, 'var volatile byte  ' left(shadow,25) 'at 0x'D2X(shared_addr)
   sharedmem.2 = sharedmem.2 - 1
   sharedmem.0 = sharedmem.0 - 1
end
call lineout jalfile, '--'
call lineout jalfile, 'procedure' reg"'put"'(byte in x at' shadow') is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   _PORT'substr(reg,5) '=' shadow
call lineout jalfile, 'end procedure'
call lineout jalfile, '--'
half = 'PORT'substr(reg,5)'_low'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   'shadow '= ('shadow '& 0xF0) | (x & 0x0F)'
call lineout jalfile, '   _PORT'substr(reg,5) '=' shadow
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   return ('reg '& 0x0F)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
half = 'PORT'substr(reg,5)'_high'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   'shadow '= ('shadow '& 0x0F) | (x << 4)'
call lineout jalfile, '   _PORT'substr(reg,5) '=' shadow
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
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
call lineout jalfile, '   'lat '= ('lat '& 0xF0) | (x & 0x0F)'
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   return ('port '& 0x0F)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
half = 'PORT'substr(lat,4)'_high'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   'lat '= ('lat '& 0x0F) | (x << 4)'
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
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
call lineout jalfile, '   'reg '= ('reg '& 0xF0) | (x & 0x0F)'
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   return ('reg '& 0x0F)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
half = 'PORT'substr(reg,5)'_high_direction'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   'reg '= ('reg '& 0x0F) | (x << 4)'
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   return ('reg '>> 4)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
return


/* ----------------------------------------------------- */
/* procedure to list SFR subfields                       */
/* input: - start index in pic.                          */
/* Note:  - name is stored but not checked on duplicates */
/* ----------------------------------------------------- */
list_status: procedure expose Pic. Name. Core PicName jalfile msglevel
parse arg i .

offset = 0

do i = i while word(pic.i,1) \= '</edc:SFRDef>'

   kwd = word(Pic.i,1)

   select

      when kwd = '<edc:SFRMode' then do
         offset = 0                                         /* bitfield offset */
      end

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then
            offset = offset + val1
      end

      when kwd = '<edc:SFRFieldDef' then do
         parse var Pic.i '<edc:SFRFieldDef' 'edc:cname="' val1 '"' . ,
                          'edc:mask="' val3 '"' . 'edc:nzwidth="' val4 '"' .
         if val1 \= '' then do
            val1 = tolower(strip(val1))
            val4 = todecimal(val4)
            if val4 = 1 then do
               if val1 = 'nto' then
                  call lineout jalfile, 'const        byte  ' left('_not_to',25) '= ' offset
               else if val1 = 'npd' then
                  call lineout jalfile, 'const        byte  ' left('_not_pd',25) '= ' offset
               else
                  call lineout jalfile, 'const        byte  ' left('_'val1,25) '= ' offset
               offset = offset + 1
            end
            else
               offset = offset + val4                       /* skip multibit fields */
         end
      end

   otherwise
      nop
   end

end

if Core = '16' then do
   call lineout jalfile, 'const        byte  ' left('_banked',25) '=  1'
   call lineout jalfile, 'const        byte  ' left('_access',25) '=  0'
end

return 0


/* -------------------------------------------------------- */
/* procedure to assign a JalV2 unique ID in chipdef_jallib  */
/* input:  - nothing                                        */
/* -------------------------------------------------------- */
list_devid_chipdef: procedure expose Pic. jalfile chipdef Core PicName msglevel DevID xChipDef.
PicNameCaps = toupper(PicName)                           /* name in upper case */
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
   call msg 1, 'DevID ('xDevId') in use by' xChipDef.xDevid
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
         call msg 1, 'DevID ('tDevId') in use by' xChipDef.tDevid
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
/* notes:  - cfgmem may be missing defaults at the end,        */
/*           these are declared as 0x00                        */
/* ----------------------------------------------------------- */
list_cfgmem: procedure expose jalfile Pic. CfgAddr. cfgmem DevSpec. PicName Core msglevel
PicNameCaps = toupper(PicName)
if DevSpec.PicNameCaps.FUSESDEFAULT \= '?' then do          /* specified in devicespecific.json */
   if length(DevSpec.PicNameCaps.FUSESDEFAULT) \= length(cfgmem) then do
      call msg 3, 'Fuses in devicespecific.json do not match size of configuration memory'
      call msg 0, '   <'DevSpec.PicNameCaps.FUSESDEFAULT'>  <-->  <'cfgmem'>'
      FusesDefault = DevSpec.PicNameCaps.FUSESDEFAULT       /* take derived value */
   end
   else do                                                  /* same length */
      if DevSpec.PicNameCaps.FUSESDEFAULT = cfgmem then
         call msg 2, 'FusesDefault in devicespecific.json same as derived:' cfgmem
      else
         call msg 1, 'Using default fuse settings from devicespecific.json:' FusesDefault
      FusesDefault = devSpec.PicNameCaps.FUSESDEFAULT      /* take devicespecific value */
   end
end
else do                                                     /* not in devicespecific.json */
   FusesDefault = cfgmem                                    /* take derived value */
end
call lineout jalfile, 'const word   _FUSES_CT             =' CfgAddr.0
if CfgAddr.0 = 1 then do                    /* single word/byte only with baseline/midrange ! */
   call lineout jalfile, 'const word   _FUSE_BASE            = 0x'D2X(CfgAddr.1)
   call charout jalfile, 'const word   _FUSES                = 0b'
   do i = 1 to 4
      call charout jalfile, '_'X2B(substr(FusesDefault,i,1))
   end
   call lineout jalfile, ''
end
else do                                                     /* multiple fuse words/bytes */
   if core \= '16' then                                     /* baseline,midrange */
      call charout jalfile, 'const word   _FUSE_BASE[_FUSES_CT] = { '
   else                                                     /* 18F */
      call charout jalfile, 'const byte*3 _FUSE_BASE[_FUSES_CT] = { '
   do j = 1 to CfgAddr.0
      if core \= '16' then
         call charout jalfile, '0x'right(D2X(CfgAddr.j),4,'0')
      else
         call charout jalfile, '0x'right(D2X(CfgAddr.j),6,'0')
      if j < CfgAddr.0 then do
         call lineout jalfile, ','
         call charout jalfile, copies(' ',39)
      end
   end
   call lineout jalfile, ' }'

   if core \= '16' then do                                     /* core 12, 14, 14H */
      call charout jalfile, 'const word   _FUSES[_FUSES_CT]     = { '
      do j = 1 to CfgAddr.0
         call charout jalfile, '0b'
         do i = 1 to 4                                         /* # nibbles */
            call charout jalfile, '_'X2B(substr(FusesDefault,i+4*(j-1),1,'0'))
         end
         if j < CfgAddr.0 then                                 /* not last word */
            call charout jalfile, ', '
         else
            call charout jalfile, ' }'
         call lineout jalfile, '        -- CONFIG'||j
         if j < CfgAddr.0 then
            call charout jalfile, copies(' ',39)
      end
   end

   else do                                                     /* 18F */
      call charout jalfile, 'const byte   _FUSES[_FUSES_CT]     = { '
      do j = 1 to CfgAddr.0
         call charout jalfile, '0b'
         do i = 1 to 2                                         /* # nibbles */
            call charout jalfile, '_'X2B(substr(FusesDefault,i+2*(j-1),1,'0'))
         end
         if j < CfgAddr.0 then
            call charout jalfile, ', '
         else
            call charout jalfile, ' }'
         call lineout jalfile, '        -- CONFIG'||(j+1)%2||substr('HL',1+(j//2),1)
         if j < CfgAddr.0 then
            call charout jalfile, copies(' ',39)
      end
   end

end
call lineout jalfile, '--'
return


/* ----------------------------------------------------------- */
/* procedure to generate OSCCAL calibration instructions       */
/* input:  - nothing                                           */
/* cores 12 and 14                                             */
/* notes: Only safe for 12 bits core!                          */
/* ----------------------------------------------------------- */
list_osccal: procedure expose jalfile Pic. CfgAddr. DevSpec. PicName,
                              Core NumBanks CodeSize OSCCALaddr FSRaddr msglevel
if OSCCALaddr > 0 then do                          /* PIC has OSCCAL register */
   if Core = 12 then do                            /* 10F2xx, some 12F5xx, 16f5xx */
      call lineout jalfile, 'var volatile byte  __osccal  at  0x'D2X(OSCCALaddr)
      if NumBanks > 1 then do
         call lineout jalfile, 'var volatile byte  __fsr     at  0x'D2X(FSRaddr)
         call lineout jalfile, 'asm          bcf   __fsr,5                  -- select bank 0'
         if NumBanks > 2 then
            call lineout jalfile, 'asm          bcf   __fsr,6                  --   "     "'
      end
      call lineout jalfile, 'asm          movwf __osccal                 -- calibrate INTOSC'
      call lineout jalfile, '--'
   end
   else if Core = 14 then do                       /* 12F629/675, 16F630/676 */
      call lineout jalfile, 'var  volatile byte   __osccal  at  0x'D2X(OSCCALaddr)
      call lineout jalfile, 'asm  page    call   0x'D2X(CodeSize-1)'              -- fetch calibration value'
      call lineout jalfile, 'asm  bank    movwf  __osccal                   -- calibrate INTOSC'
      call lineout jalfile, '--'
   end
end
return


/* ----------------------------------------------- */
/* convert ANSEL-bit to JANSEL_number              */
/* input: - register  (ANSELx,ADCONx,ANCONx, etc.) */
/*        - Name of bit (ANSy)                     */
/* returns channel number                          */
/* All cores                                       */
/* This procedure has to be evaluated              */
/* with every additional PIC(-group)               */
/* Return value 99 indicates 'no JANSEL number'    */
/* ----------------------------------------------- */
ansel2j: procedure expose Core PicName PinMap. PinANMap. msglevel
parse upper arg reg, ans .                                  /* ans is name of bitfield! */

if datatype(right(ans,2),'W') = 1 then                      /* name ends with 2 digits */
   ansx = right(ans,2)                                      /* 2 digits seq. nbr. */
else                                                        /* 1 digit assumed */
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
         else if right(PicName,4) = 'f753' | right(PicName,5) = 'hv753' then
            ansx = word('4 5 6 7 99 99 99 99', ansx + 1)
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
         if right(PicName,4) = 'f720' | right(PicName,4) = 'f721'  |,
            right(PicName,4) = 'f752' | right(PicName,5) = 'hv752' |,
            right(PicName,4) = 'f753' | right(PicName,5) = 'hv753' then
            ansx = word('0 1 2 99 3 99 99 99', ansx + 1)
         else if left(PicName,5) = '16f70' | left(PicName,6) = '16lf70' |,
                 left(PicName,5) = '16f72' | left(PicName,6) = '16lf72' then
            ansx = word('0 1 2 3 99 4 99 99', ansx + 1)
         else if left(PicName,4) = '16f9' & left(ans,3) \= 'ANS' then
            ansx = 99                                       /* skip dup ANSEL subfields 16f9xx */
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
            left(PicName,6) = '16f178'  | left(PicName,7) = '16lf178' |,
                                          left(PicName,7) = '16lf190' |,
            left(PicName,6) = '16f193'  | left(PicName,7) = '16lf193' then
            ansx = ansx + 5
         else if left(PicName,6) = '16f152' | left(PicName,7) = '16lf152' then
            ansx = word('27 28 29 99 99 99 99 99', ansx + 1)
         else if left(PicName,6) = '16f194' | left(PicName,7) = '16lf194' then
            ansx = 99                              /* none */
         else
            ansx = ansx + 20
      end
      when reg = 'ANSELD' then do
         if left(PicName,6) = '16f151' | left(PicName,7) = '16lf151' then
            ansx = ansx + 20
         else if left(PicName,6) = '16f152' | left(PicName,7) = '16lf152' then
            ansx = word('23 24 25 26 99 99 99 99', ansx + 1)
         else
            ansx = 99                              /* none */
      end
      when reg = 'ANSELC' then do
         if left(PicName,6) = '16f151' | left(PicName,7) = '16lf151' then
            ansx = word('99 99 14 15 16 17 18 19', ansx + 1)
         else if left(PicName,6) = '16f145' | left(PicName,7) = '16lf145' |,
                 left(PicName,6) = '16f150' | left(PicName,7) = '16lf150' |,
                 left(PicName,6) = '16f170' | left(PicName,7) = '16lf170' |,
                 left(PicName,6) = '16f182' | left(PicName,7) = '16lf182' then
            ansx = word('4 5 6 7 99 99 8 9', ansx + 1)
         else
            ansx = 99                              /* none */
      end
      when reg = 'ANSELB' then do
         if PicName = '16f1826' | PicName = '16lf1826' |,
            PicName = '16f1827' | PicName = '16lf1827' |,
            PicName = '16f1847' | PicName = '16lf1847' then
            ansx = word('99 11 10 9 8 7 5 6', ansx + 1)
         else if left(PicName,6) = '16f145' | left(PicName,7) = '16lf145' then
            ansx = word('99 99 99 99 10 11 99 99', ansx + 1)
         else if left(PicName,6) = '16f150' | left(PicName,7) = '16lf150' |,
                 left(PicName,6) = '16f170' | left(PicName,7) = '16lf170' |,
                 left(PicName,6) = '16f182' | left(PicName,7) = '16lf182' then
            ansx = word('99 99 99 99 10 11 99 99', ansx + 1)
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
                 left(PicName,6) = '16f170' | left(PicName,7) = '16lf170' |,
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
         if (PicName = '18f13k22' | PicName = '18lf13k22' |,
             PicName = '18f14k22' | PicName = '18lf14k22')  &,
             left(ans,5) = 'ANSEL' then do
            call msg 1, 'Suppressing probably duplicate JANSEL_ANSx declaration ('ans')'
            ansx = 99
         end
         else if ansx < 8 then
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
         if (PicName = '18f13k22' | PicName = '18lf13k22' |,
             PicName = '18f14k22' | PicName = '18lf14k22') then do
            if left(ans,5) = 'ANSEL' then do
               call msg 1, 'Suppressing probably duplicate JANSEL_ANSx declarations'
               ansx = 99
            end
         end
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

PicNameCaps = toupper(PicName)
aliasname    = 'AN'ansx
if ansx < 99 & PinANMap.PicNameCaps.aliasname = '-' then do  /* no match */
   call msg 2, 'No "pin_AN'ansx'" alias in pinmap for' reg'_'ans
   ansx = 99                                                /* error indication */
end
return ansx


/* ---------------------------------------------------- */
/* procedure to list fusedef specifications             */
/* input:  - nothing                                   */
/* ---------------------------------------------------- */
list_fusedef: procedure expose Pic. Ram. Name. Fuse_def. Core PicName jalfile,
                             msglevel CfgAddr.

call lineout jalfile, '-- ==================================================='
call lineout jalfile, '--'
call lineout jalfile, '--    Symbolic Fuse Definitions'
call lineout jalfile, '-- ------------------------------'


FuseAddr = 0                                                /* start value */

do i = 1 to Pic.0  until (word(Pic.i,1) = '<edc:ConfigFuseSector' |,
                          word(Pic.i,1) = '<edc:WORMHoleSector')    /* fusedefs */
   nop
end

if word(Pic.i,1) = '<edc:ConfigFuseSector' then
   parse var Pic.i '<edc:ConfigFuseSector' 'edc:beginaddr="0x' val1 '"' .
else
   parse var Pic.i '<edc:WORMHoleSector' 'edc:beginaddr="0x' val1 '"' .

if val1 \= '' then
   FuseAddr = X2D(val1)                                     /* start address */

FuseStart = FuseAddr

do i = i to Pic.0 until (word(pic.i,1) = '</edc:ConfigFuseSector>' |,
                         word(pic.i,1) = '</edc:WORMHoleSector>')   /* end of fusedefs */

   kwd = word(Pic.i,1)

   select

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then
            FuseAddr = FuseAddr + todecimal(val1)
      end

      when kwd = '<edc:DCRDef' then do
         parse var Pic.i '<edc:DCRDef' . 'edc:cname="' val1 '"' ,
                          'edc:default="0x' val2 '"' . 'edc:nzwidth=' val3 '"' .
         if val1 \= '' then do
            call lineout jalfile, '--'
            call lineout jalfile, '--' strip(val1) '(0x'D2X(FuseAddr)')'
            call lineout jalfile, '--'
            call list_fusedef_fielddefs i, FuseAddr - FuseStart   /* fusedef bit fields */
         end
         FuseAddr = FuseAddr + 1
         do while word(Pic.i,1) \= '</edc:DCRDef>'
            i = i + 1                                       /* skip inner statements */
         end
      end

   otherwise
      nop
   end

end
call lineout jalfile, '--'
return 0


/* ---------------------------------------------------- */
/* procedure to list Fusedef subfields                  */
/* input:  - index in Pic.                              */
/*         - fuse byte/word index                       */
/* ---------------------------------------------------- */
list_fusedef_fielddefs: procedure expose Pic. CfgAddr. Fuse_Def. PicName Core jalfile msglevel
parse arg i, index .

do i = i to Pic.0  while word(Pic.i,1) \= '<edc:DCRMode'     /* fusedef subfields */
   nop
end

offset = 0                                                  /* bit offset */

do i = i while word(pic.i,1) \= '</edc:DCRMode>'

   kwd = word(Pic.i,1)

   select

      when kwd = '<edc:AdjustPoint' then do
         parse var Pic.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
         if val1 \= '' then do
            offset = offset + val1                          /* bit offset */
         end
      end

      when kwd = '<edc:DCRFieldDef' then do
         parse var Pic.i '<edc:DCRFieldDef' 'edc:cname="' val1 '"' 'edc:desc="' val2 '"',
                          'edc:mask="0x' val3 '"' . 'edc:nzwidth="' val4 '"' .
         val1u = toupper(val1)
         val2u = toupper(val2)
         if val1 \= ''  &  left(val1u,3) \= 'RES'  &  val2u \= 'RESERVED' then do
            key = normalize_fusedef_keyword(val1u)          /* uniform keyword */
            if \(key = 'OSC' & left(PicName,5) = '10f20') then do   /* OSC, but not a 10F */
               mask = strip(B2X(X2B(val3)||copies('0',offset)),'L','0')    /* bit alignment */
               if CfgAddr.0 = 1 then                        /* single byte/word */
                  str = 'pragma fuse_def' key '0x'mask '{'
               else                                         /* multi byte/word */
                  str = 'pragma fuse_def' key':'index '0x'mask '{'
               call lineout jalfile, left(str, 42) '--' val2
               call list_fusedef_fieldsemantics i, offset, key
               if val1 = 'ICPRT'  &,
                  (PicName = '18f1230'   | PicName = '18f1330'  |,
                   PicName = '18f24k50'  | PicName = '18f25k50' |,
                   PicName = '18lf24k50' | PicName = '18lf25k50') then do
                  call msg 1, 'Adding "ENABLED = 0x'mask'"  for fuse_def' val1
                  call lineout jalfile, left('       ENABLED = 0x'mask, 42) '-- ICPORT enabled'
               end
               call lineout jalfile, '       }'
            end
         end
         offset = offset + todecimal(val4)                  /* adjust bit offset */
      end

   otherwise
      nop
   end

end
return


/* ---------------------------------------------------- */
/* procedure to list Fusedef subfields                  */
/* input:  - index in Pic.                              */
/*         - bitfield offset                            */
/* ---------------------------------------------------- */
list_fusedef_fieldsemantics: procedure expose Pic. Fuse_Def. Core PicName jalfile msglevel
parse arg i, offset, key .

do i = i to Pic.0  while word(Pic.i,1) \= '<edc:DCRFieldSemantic'     /* fusedef subfields */
   nop
end

kwdname. = '-'                                           /* no key names collected yet */

do i = i while word(pic.i,1) \= '</edc:DCRFieldDef>'
   if word(Pic.i,1) = '<edc:DCRFieldSemantic' then do
      parse var Pic.i '<edc:DCRFieldSemantic' 'edc:cname="' val1 '"',
                       'edc:desc="' val2 '"' 'edc:when="' . '==' '0x' val3 '"' .

      if val1 = '' & key \= 'OSC' then do                /* parse without cname, not for OSC */
         parse var Pic.i '<edc:DCRFieldSemantic' ,
                       'edc:desc="' val2 '"' 'edc:when="' . '==' '0x' val3 '"' .
      end
      val1u = toupper(val1)
      if val1u = 'RESERVED' then                         /* skip reserved patterns */
         iterate
      if val2 \= '' then do
         kwd = normalize_fusedef_keywordvalue(key, val1u, '"'val2'"')      /* normalize keyword */
         if kwd = '' then                                /* probably reserved */
            iterate
         mask = strip(B2X(X2B(val3)||copies('0',offset)),'L','0')    /* bit alignment */
         if mask = '' then
            mask = '0'
         if kwdname.kwd \= '-' then do                   /* duplicate */
            call msg 2, 'Duplicate fuse_def' key '{'kwd '= 0x'mask'} skipped'
         end
         else do
            kwdname.kwd = kwd                            /* remember name */
            call lineout jalfile, left('       'kwd '= 0x'mask, 42) '--' toascii(val2)
         end
      end
   end
end
return


/* ---------------------------------------------------- */
/* procedure to normalize fusedef keywords              */
/* input:  - keyword                                    */
/* returns - normalized keyword                         */
/* ---------------------------------------------------- */
normalize_fusedef_keyword: procedure expose PicName
parse upper arg key .

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
      return key
   end

   select                                          /* reduce synonyms and */
                                                   /* correct MPLAB-X errors */
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
      when left(key,4) = 'EBRT' then               /* typo in .pic files */
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
      when key = 'FSCKM' | key = 'FSCM' then
         key = 'FCMEN'
      when key = 'MCLRE' then
         key = 'MCLR'
      when key = 'MSSP7B_EN' | key = 'MSSPMSK' then
         key = 'MSSPMASK'
      when key = 'P2BMX' then
         key = 'P2BMUX'
      when key = 'PLL_EN' | key = 'CFGPLLEN' | key = 'PLLCFG' then
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
      when key = 'SDOMX' then
         key = 'SDOMUX'
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
      when key = 'T3CKMX' | key = 'T3CMX' then
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

end

return key

end


/* ------------------------------------------------------------------------ */
/* Detailed formatting of fusedef keywords                                  */
/* input:  - fuse_def keyword                                               */
/*         - keyword value                                                  */
/*         - keyword value description string                               */
/* returns normalized keyword                                               */
/*                                                                          */
/* notes: val2 contains keyword description with undesired chars and blanks */
/*        val2u is val2 with all these replaced by a single underscore      */
/* ------------------------------------------------------------------------ */
normalize_fusedef_keywordvalue: procedure expose Pic. Fuse_Def. jalfile Fuse_Def.,
                                                 Core PicName msglevel
parse upper arg key, val, desc

desc = strip(desc, 'B', '"')                                /* strip double quoted */
desc = toascii(desc)                                        /* replace xml meta by ASCII char */
descu = toupper(desc)                                       /* to uppercase */
descu = translate(descu, '                ',,               /* replace special chars by blanks */
                        '+-:;.,<>{}[]()=/?')
descu = space(descu,,'_')                                   /* replace blanks by single underscore */

kwdvalue = ''                                               /* null value */

select                                                      /* specific formatting */

   when val = 'RESERVED' then do                            /* reserved values skipped */
      return ''
   end

   when key = 'ADCSEL'  |,                                  /* ADC resolution */
        key = 'ABW'     |,                                  /* address bus width */
        key = 'BW'    then do                               /* external memory bus width */
      parse value word(desc,1) with kwdvalue '-' .          /* assign number */
      kwdvalue = 'B'kwdvalue                                /* add prefix */
   end

   when key = 'BBSIZ' then do
      if desc = 'ENABLED' then do
         kwdvalue = desc
      end
      else if desc = 'DISABLED' then do
         kwdvalue = desc
      end
      else do j=1 to words(desc)
         if left(word(desc,j),1) >= '0' & left(word(desc,j),1) <= '9' then do
            kwdvalue = 'W'word(desc,j)                      /* found leading digit */
            leave
         end
      end
      if datatype(substr(kwdvalue,2),'W') = 1  &,           /* second char numeric */
          pos('KW',descu) > 0 then do                       /* contains KW */
         kwdvalue = kwdvalue'K'                             /* append 'K' */
      end
   end

   when key = 'BG' then do                                  /* band gap */
      if word(desc,1) = 'HIGHEST' | word(desc,1) = 'LOWEST' then
         kwdvalue = word(desc,1)
      else if word(desc,1) = 'ADJUST' then do
         if pos('-',desc) > 0 then                          /* negative voltage */
            kwdvalue = word(desc,1)'_NEG'
         else
            kwdvalue = word(desc,1)'_POS'
      end
      else if descu = '' then
         kwdvalue = 'MEDIUM'val
      else
         kwdvalue = descu
   end

   when key = 'BORPWR' then do                              /* BOR power mode */
      if pos('ZPBORMV',descu) > 0 then
         kwdvalue = 'ZERO'
      else if pos('HIGH_POWER',descu) > 0 then
         kwdvalue = 'HP'
      else if pos('MEDIUM_POWER',descu) > 0 then
         kwdvalue = 'MP'
      else if pos('LOW_POWER',descu) > 0 then
         kwdvalue = 'LP'
      else
         kwdvalue = descu
   end

   when key = 'BROWNOUT' then do
      if  pos('SLEEP',descu) > 0 & pos('DEEP_SLEEP',descu) = 0 then
         kwdvalue = 'RUNONLY'
      else if pos('HARDWARE_ONLY',descu) > 0 then do
         kwdvalue = 'ENABLED'
      end
      else if pos('CONTROL',descu) > 0 then
         kwdvalue = 'CONTROL'
      else if pos('ENABLED',descu) > 0 | descu = 'ON' then
         kwdvalue = 'ENABLED'
      else do
         kwdvalue = 'DISABLED'
      end
   end

   when key = 'CANMUX' then do
      if pos('_RB', descu) > 0 then
         kwdvalue = 'pin_'substr(descu, pos('_RB', descu) + 2, 2)
      else if pos('_RC', descu) > 0 then
         kwdvalue = 'pin_'substr(descu, pos('_RC', descu) + 2, 2)
      else if pos('_RE', descu) > 0 then
         kwdvalue = 'pin_'substr(descu, pos('_RE', descu) + 2, 2)
      else
         kwdvalue = descu
   end

   when left(key,3) = 'CCP' & right(key,3) = 'MUX' then do    /* CCPxMUX */
      if pos('MICRO',descu) > 0 then                        /* Microcontroller mode */
         kwdvalue = 'pin_E7'                                /* valid for all current PICs */
      else if val = 'ON'  | descu = 'ENABLED'  then
         kwdvalue = 'ENABLED'
      else if val = 'OFF' | descu = 'DISABLED' then
         kwdvalue = 'DISABLED'
      else
         kwdvalue = 'pin_'right(descu,2)                    /* last 2 chars */
   end

   when key = 'CINASEL' then do
      if pos('DEFAULT',descu) > 0 then                      /* Microcontroller mode */
         kwdvalue = 'DEFAULT'
      else
         kwdvalue = 'MAPPED'
   end

   when key = 'CP' |,                                       /* code protection */
       ( left(key,2) = 'CP' &,
           (datatype(substr(key,3),'W') = 1 |,
            substr(key,3,1) = 'D'           |,
            substr(key,3,1) = 'B') )       then do
      if val = 'OFF' | pos('NOT',desc) > 0 | pos('DISABLED',desc) > 0  |  pos('OFF',desc) > 0 then
         kwdvalue = 'DISABLED'
      else if left(val,5) = 'UPPER' | left(val,5) = 'LOWER'  | val = 'HALF' then
         kwdvalue = val
      else if pos('ALL_PROT', descu) > 0 then               /* all protected */
         kwdvalue = 'ENABLED'
      else if left(desc,1) = '0' then do                    /* probably a range */
         kwdvalue = word(desc,1)                            /* begin(-end) of range */
         if word(desc,2) = 'TO' then                        /* splitted words */
            kwdvalue = kwdvalue'-'word(desc,3)              /* add end of range */
         kwdvalue = 'R'translate(kwdvalue,'_','-')          /* format */
      end
      else
         kwdvalue = 'ENABLED'
   end

   when key = 'CPUDIV' then do
      if word(desc,1) = 'NO' then
         kwdvalue = 'P1'                                    /* no division */
      else if pos('DIVIDE',desc) > 0 & wordpos('BY',desc) > 0 then
         kwdvalue = 'P'word(desc,words(desc))               /* last word */
      else if pos('DIVIDE',desc) > 0 & wordpos('(NO',desc) > 0 then
         kwdvalue = 'P'1                                    /* no divide */
      else if pos('/',desc) > 0 then
         kwdvalue = 'P'substr(desc,pos('/',desc)+1,1)       /* digit after '/' */
      else
         kwdvalue = descu
   end

   when key = 'DSBITEN' then do
      if val = 'ON' then
         kwdvalue = 'ENABLED'
      else
         kwdvalue = 'DISABLED'
   end

   when key = 'DSWDTOSC' then do
      if pos('INT',descu) > 0 then
         kwdvalue = 'INTOSC'
      else if pos('LPRC',descu) > 0 then
         kwdvalue = 'LPRC'
      else if pos('SOSC',descu) > 0 then
         kwdvalue = 'SOSC'
      else
         kwdvalue = 'T1'
   end

   when key = 'DSWDTPS'   |,
        key = 'WDTPS' then do
      parse var desc p0 ':' p1                              /* split */
      kwdvalue = translate(word(p1,1),'      ','.,()=/')    /* 1st word, cleaned */
      kwdvalue = space(kwdvalue,0)                          /* remove all spaces */
      do j=1 while kwdvalue >= 1024
         kwdvalue = kwdvalue / 1024                         /* reduce to K, M, G, T */
      end
      kwdvalue = 'P'format(kwdvalue,,0)||substr(' KMGT',j,1)
   end

   when key = 'EBTR' |,
        left(key,4) = 'EBTR'  &,
           (datatype(substr(key,5),'W') = 1 |,
            substr(key,5,1) = 'B')       then do
      if val = 'OFF' then
         kwdvalue = 'DISABLED'                              /* not protected */
      else
         kwdvalue = 'ENABLED'
   end

   when key = 'ECCPMUX' then do
      if pos('_R',descu) > 0 then                           /* check for _R<pin> */
         kwdvalue = 'pin_'substr(descu,pos('_R',descu)+2,2)  /* 2 chars after '_R' */
      else
         kwdvalue = descu
   end

   when key = 'EMB' then do
      if pos('12',desc) > 0 then                            /* 12-bit mode */
         kwdvalue = 'B12'
      else if pos('16',desc) > 0 then                       /* 16-bit mode */
         kwdvalue = 'B16'
      else if pos('20',desc) > 0 then                       /* 20-bit mode */
         kwdvalue = 'B20'
      else
         kwdvalue = 'DISABLED'                              /* no en/disable balancing */
   end

   when key = 'ETHLED' then do
      if val = 'ON' | pos('ENABLED',desc) > 0  then         /* LED enabled */
         kwdvalue = 'ENABLED'
      else
         kwdvalue = 'DISABLED'
   end

   when key = 'EXCLKMUX' then do                            /* Timer0/5 clock pin */
      if pos('_R',descu) > 0 then                          /* check for _R<pin> */
         kwdvalue = 'pin_'substr(descu,pos('_R',descu)+2,2)  /* 2 chars after '_R' */
      else
         kwdvalue = descu
   end

   when key = 'FLTAMUX' then do
      if pos('_R',descu) > 0 then                          /* check for _R<pin> */
         kwdvalue = 'pin_'substr(descu,pos('_R',descu)+2,2)  /* 2 chars after '_R' */
      else
         kwdvalue = descu
   end

   when key = 'FOSC2' then do
      if pos('INTRC', descu) > 0  |,
         desc = 'ENABLED' then
         kwdvalue = 'INTOSC'
      else
         kwdvalue = 'OSC'
   end

   when key = 'FCMEN'  |,                                   /* Fail safe clock monitor */
        key = 'FSCKM' then do
      x1 = pos('ENABLED', descu)
      x2 = pos('DISABLED', descu)
      if x1 > 0 & x2 > 0 & x2 > x1 then
         kwdvalue  = 'SWITCHING'
      else if x1 > 0 & x2 = 0 then
         kwdvalue  = 'ENABLED'
      else if x1 = 0 & x2 > 0 then
         kwdvalue  = 'DISABLED'
      else
         kwdvalue = descu
   end

   when key = 'HFOFST' then do
      if val = 'ON' | pos('NOT_DELAYED',descu) > 0 then
         kwdvalue = 'ENABLED'
      else
         kwdvalue = 'DISABLED'
   end

   when key = 'INTOSCSEL' then do
      if pos('HIGH_POWER',descu) > 0 then
         kwdvalue = 'HP'
      else if pos('LOW_POWER',descu) > 0 then
         kwdvalue = 'LP'
      else
         kwdvalue = descu
   end

   when key = 'IOL1WAY' then do
      if val = 'ON' then
         kwdvalue = 'ENABLED'
      else
         kwdvalue = 'DISABLED'
   end

   when key = 'IOSCFS' then do
      if pos('MHZ',descu) > 0 then do
         if pos('8',descu) > 0 then                         /* 8 MHz */
            kwdvalue = 'F8MHZ'
         else
            kwdvalue = 'F4MHZ'                              /* otherwise */
      end
      else if descu = 'ENABLED' then
         kwdvalue = 'F8MHZ'
      else if descu = 'DISABLED' then
         kwdvalue = 'F4MHZ'                                 /* otherwise */
      else do
         kwdvalue = descu
         if left(kwdvalue,1) >= '0' & left(kwdvalue,1) <= '9' then
            kwdvalue = 'F'kwdvalue                          /* prefix when numeric */
      end
   end

   when key = 'LPT1OSC' then do
      if pos('LOW',descu) > 0 | pos('ENABLE',descu) > 0 then
         kwdvalue = 'LOW_POWER'
      else
         kwdvalue = 'HIGH_POWER'
   end

   when key = 'LS48MHZ' then do
      if pos('TO_4',descu) > 0 then
         kwdvalue = 'P4'
      else if pos('TO_8',descu) > 0 then
         kwdvalue = 'P8'
      else if pos('BY_2',descu) > 0 then
         kwdvalue = 'P2'
      else if pos('BY_1',descu) > 0 then
         kwdvalue = 'P1'
      else
         kwdvalue = descu
   end

   when key = 'LVP' then do
      if pos('ENABLE',desc) > 0 then
         kwdvalue = 'ENABLED'
      else
         kwdvalue = 'DISABLED'
   end

   when key = 'MCLR' then do
      if val = 'OFF' then
         kwdvalue = 'INTERNAL'
      else if val = 'ON'                  |,
         pos('EXTERN',desc) > 0           |,
         pos('MCLR ENABLED',desc) > 0     |,
         pos('MCLR PIN ENABLED',desc) > 0 |,
         pos('MASTER',desc) > 0           |,
         pos('AS MCLR',desc) > 0          |,
         pos('IS MCLR',desc) > 0          |,
         desc = 'MCLR'                    |,
         desc = 'ENABLED'   then
         kwdvalue = 'EXTERNAL'
      else
         kwdvalue = 'INTERNAL'
   end

   when key = 'MSSPMASK'  |,
        key = 'MSSPMSK1'  |,
        key = 'MSSPMSK2' then do
      if left(desc,1) >= 0  &  left(desc,1) <= '9' then
         kwdvalue = 'B'left(desc, 1)                        /* digit 5 or 7 expected */
      else
         kwdvalue = descu
   end

   when key = 'OSC' then do
      kwdvalue = Fuse_Def.Osc.descu
      if left(descu,1) = '1' | left(descu,1) = '0' then do   /* desc starts with '1' or '0' */
         call msg 2, 'Skipping probably duplicate fuse_def' key':' desc
         kwdvalue = ''
      end
      else if kwdvalue = '?' then do
         call msg 2, 'No mapping for fuse_def' key':' descu
         kwdvalue = descu
      end
   end

   when key = 'P2BMUX' then do
      if substr(descu,length(descu)-3,2) = '_R' then        /* check for _R<pin> */
         kwdvalue = 'pin_'right(descu,2)
      else
         kwdvalue = descu
   end

   when key = 'PARITY' then do
      if pos('CLEAR',descu) > 0 then                        /* check for _R<pin> */
         kwdvalue = 'CLEAR'
      else
         kwdvalue = 'SET'
   end

   when key = 'PBADEN' then do
      if pos('ANALOG',descu) > 0  |  desc = 'ENABLED' then
         kwdvalue = 'ANALOG'
      else
         kwdvalue = 'DIGITAL'
   end

   when key = 'PCLKEN' then do
      if val = 'ON' then
         kwdvalue = 'ENABLED'
      else
         kwdvalue = 'DISABLED'
   end

   when key = 'PLLDIV' then do
      if descu = 'Reserved' then
         kwdvalue = '   '                                   /* to be ignored */
      else if left(descu,6) = 'NO_PLL' then
         kwdvalue = 'P0'                                    /* no PLL */
      else if right(word(desc,1),1) = 'X' then
         kwdvalue = 'X'||strip(word(desc,1),'T','X')        /* multiplier */
      else if left(descu,9) = 'DIVIDE_BY' then
         kwdvalue = 'P'||word(desc,3)                       /* 3rd word */
      else if wordpos('DIVIDED BY', desc) > 0 then
         kwdvalue = 'P'||word(desc, wordpos('DIVIDED BY', desc) + 2)    /* word after 'devided by' */
      else if word(desc,1) = 'NO' |,
              pos('NO_DIVIDE', descu) > 0 then
         kwdvalue = 'P1'
      else
         kwdvalue = descu
   end

   when key = 'PLLEN' then do
      if pos('MULTIPL',desc) > 0 then
         kwdvalue = 'P'word(desc, words(desc))              /* last word */
      else if pos('500 KHZ',desc) > 0  |  pos('500KHZ',desc) > 0 then
         kwdvalue = 'F500KHZ'
      else if pos('16 MHZ',desc) > 0  |  pos('16MHZ',desc) > 0 then
         kwdvalue = 'F16MHZ'
      else if pos('DIRECT',desc) > 0 | pos('DISABLED',desc) > 0 | pos('SOFTWARE',desc) > 0 then
         kwdvalue = 'P1'
      else if pos('ENABLED',desc) > 0 then
         kwdvalue = 'P4'
      else if datatype(left(desc,1),'W') = 1 then
         kwdvalue = 'F'descu
      else
         kwdvalue = descu
   end

   when key = 'PLLSEL' then do
      if pos('96M',descu) > 0 then
         kwdvalue = 'PLL96'
      else if pos('3X',desc) > 0 then
         kwdvalue = 'PLL3X'
      else if pos('4X',desc) > 0 then
         kwdvalue = 'PLL4X'
      else
         kwdvalue = descu
   end

   when key = 'PMODE' then do
      if pos('EXT',desc) > 0 then do
         if pos('-BIT', desc) > 0 then
            kwdvalue = 'B'substr(desc, pos('-BIT',desc)-2, 2) /* # bits */
         else
            kwdvalue = 'EXT'
      end
      else if pos('PROCESSOR',desc) > 0 then do
         kwdvalue = 'MICROPROCESSOR'
         if pos('BOOT',descu) > 0 then
            kwdvalue = kwdvalue'_BOOT'
      end
      else
         kwdvalue = 'MICROCONTROLLER'
   end

   when key = 'PMPMUX' then do
      if wordpos('ON',desc) > 0 then                        /* contains ' ON ' */
         kwdvalue = left(word(desc, wordpos('ON',desc) + 1),5)
      else if wordpos('ELSEWHERE',desc) > 0  |,             /* contains ' ELSEWHERE ' */
              wordpos(' NOT ',desc) > 0 then                /* contains ' NOT ' */
         kwdvalue = 'ELSEWHERE'
      else if wordpos('NOT',desc) = 0 then                  /* does not contain ' NOT ' */
         kwdvalue = left(word(desc, wordpos('TO',desc) + 1),5)
      else
         kwdvalue = descu
   end

   when key = 'POSCMD' then do                              /* primary osc */
      if pos('DISABLED',descu) > 0 then                     /* check for _R<pin> */
         kwdvalue = 'DISABLED'
      else if pos('HS', descu) > 0 then
         kwdvalue = 'HS'
      else if pos('MS', descu) > 0 then
         kwdvalue = 'MS'
      else if pos('EXTERNAL', descu) > 0 then
         kwdvalue = 'EC'
      else
         kwdvalue = descu
   end

   when key = 'PWM4MUX' then do
      if pos('_R',descu) > 0 then                          /* check for _R<pin> */
         kwdvalue = 'pin_'substr(descu,pos('_R',descu)+2,2)  /* 2 chars after '_R' */
      else
         kwdvalue = descu
   end

   when key = 'RETEN' then do
      if val = 'OFF' then
         kwdvalue = 'DISABLED'
      else
         kwdvalue = 'ENABLED'
   end

   when key = 'RTCOSC' then do
      if pos('INTRC',descu) > 0 then
         kwdvalue = 'INTRC'
      else
         kwdvalue = 'T1OSC'
   end

   when key = 'SDOMUX' then do
      if pos('ON_R', descu) > 0 then
         kwdvalue = 'pin_'substr(descu, pos('ON_R', descu) + 4, 2)
      else
         kwdvalue = word(desc,words(desc))                  /* last word */
   end

   when key = 'SIGN' then do
      if pos('CONDUC',descu) > 0 then
         kwdvalue = 'NOT_CONDUCATED'
      else
         kwdvalue = 'AREA_COMPLETE'
   end

   when key = 'SOSCSEL' then do
      if val = 'HIGH' | pos('HIGH_POWER',descu) > 0 then
         kwdvalue = 'HP'
      else if val = 'DIG' | pos('DIGITAL',descu) then
         kwdvalue = 'DIG'
      else if val = 'LOW' | pos('LOW_POWER',descu) > 0 then
         kwdvalue = 'LP'
      else if pos('SECURITY',descu) > 0 then
         kwdvalue = 'HS_CP'
      else
         kwdvalue = descu
   end

   when key = 'SSPMUX' then do
      offset1 = pos('_MULTIPLEX',descu)
      if offset1 > 0 then do                                /* 'multiplexed' found */
         offset2 = pos('_R',substr(descu,offset1))          /* first pin */
         if offset2 > 0 then
            kwdvalue = 'pin_'substr(descu,offset1+offset2+1,2)
         else
            kwdvalue = 'ENABLED'
      end
      else
         kwdvalue = 'DISABLED'                              /* no en/disable balancing */
   end

   when key = 'STVR' then do
      if pos('NOT', desc) > 0 | pos('DISABLED',desc) > 0 then   /* no stack overflow */
         kwdvalue = 'DISABLED'
      else
         kwdvalue = 'ENABLED'
   end

   when key = 'T0CKMUX' then do
      if pos('_RB', descu) > 0 then
         kwdvalue = 'pin_'substr(descu, pos('_RB', descu) + 2, 2)
      else if pos('_RG', descu) > 0 then
         kwdvalue = 'pin_'substr(descu, pos('_RG', descu) + 2, 2)
      else
         kwdvalue = descu
   end

   when key = 'T1OSCMUX' then do
      if left(right(descu,4),2) = '_R' then
         kwdvalue = 'pin_'right(descu,2)                    /* last 2 chars */
      else if val = 'ON' then
         kwdvalue = 'LP'
      else if val = 'OFF' then
         kwdvalue = 'STANDARD'
      else
         kwdvalue = descu
   end

   when key = 'T1DIG' then do
      if val = 'ON' then
         kwdvalue = 'ENABLED'
      else if val = 'OFF' then
         kwdvalue = 'DISABLED'
      else
         kwdvalue = descu
   end

   when key = 'T3CKMUX' then do
      if pos('_R', descu) > 0 then
         kwdvalue = 'pin_'substr(descu, pos('_R', descu) + 2, 2)
      else
         kwdvalue = descu
   end

   when key = 'T5GSEL' then do
      if pos('T3G',descu) > 0 then
         kwdvalue = 'T3G'
      else
         kwdvalue = 'T5G'
   end

   when key = 'USBDIV' then do                              /* mplab >= 8.60 (was USBPLL) */
      if descu = 'ENABLED' | pos('96_MH',descu) > 0 | pos('DIVIDED_BY',descu) > 0 then
         kwdvalue = 'P4'                                    /* compatibility */
      else
         kwdvalue = 'P1'                                    /* compatibility */
   end

   when key = 'USBLSCLK' then do
      if pos('48',descu) > 0 then
         kwdvalue = 'F48MHZ'
      else
         kwdvalue = 'F24MHZ'
   end

   when key = 'USBPLL' then do
      if pos('PLL',descu) > 0 then
         kwdvalue = 'F48MHZ'
      else
         kwdvalue = 'OSC'
   end

   when key = 'VCAPEN' then do
      if pos('DISABLED',desc) > 0 then
         kwdvalue = 'DISABLED'
      else if pos('ENABLED_ON',descu) > 0 then do
         x = wordpos('ON',desc)
         kwdvalue = word(desc, x + 1)                       /* last word */
         if left(kwdvalue,1) = 'R' then                     /* pinname Rxy */
            kwdvalue = 'pin_'substr(kwdvalue,2)             /* make it pin_xy */
         else
            kwdvalue = 'ENABLED'
      end
      else
         kwdvalue = 'ENABLED'                               /* probably never reached */
   end

   when key = 'VOLTAGE' then do
      do j=1 to words(desc)                                 /* scan word by word */
         if left(word(desc,j),1) >= '0' & left(word(desc,j),1) <= '9' then do
            if pos('.',word(desc,j)) > 0 then do            /* select digits */
               kwdvalue = 'V'left(word(desc,j),1,1)||substr(word(desc,j),3,1)
               if kwdvalue = 'V21' then
                  kwdvalue = 'V20'                          /* compatibility */
               leave                                        /* done */
            end
         end
      end
      if j > words(desc) then do                            /* no voltage value found */
         if pos('MINIMUM',desc) > 0  |,
            pos(' LOW ',desc) > 0 then
            kwdvalue = 'MINIMUM'
         else if pos('MAXIMUM',desc) > 0 |,
            pos(' HIGH ',desc) > 0 then
            kwdvalue = 'MAXIMUM'
         else if descu = '' then
            kwdvalue = 'MEDIUM'val
         else
            kwdvalue = descu
      end
   end

   when key = 'WAIT' then do
      if val = 'OFF' | pos('NOT',desc) > 0 | pos('DISABLE',desc) > 0 then
         kwdvalue = 'DISABLED'
      else
         kwdvalue = 'ENABLED'
   end

   when key = 'WDT' then do                                 /* Watchdog */
      pos_en = pos('ENABLE', desc)
      pos_dis = pos('DISABLE', desc)
      if pos('RUNNING', desc) > 0 |,
         pos('DISABLED_IN_SLEEP', descu) > 0 then
         kwdvalue = 'RUNONLY'
      else if descu = 'OFF' | (pos_dis > 0 & (pos_en = 0 | pos_en > pos_dis)) then do
         kwdvalue = 'DISABLED'
      end
      else if pos('HARDWARE', desc) > 0 then do
         kwdvalue = 'HARDWARE'
      end
      else if pos('CONTROL', desc) > 0  then do
         if core = '16' then                                /* *** backward compatibility *** */
            kwdvalue = 'DISABLED'
         else
            kwdvalue = 'CONTROL'
      end
      else if descu = 'ON' | (pos_en > 0 & (pos_dis = 0 | pos_dis > pos_en)) then do
         kwdvalue = 'ENABLED'
      end
      else
         kwdvalue = descu                                   /* normalized description */
   end

   when key = 'WDTCLK' then do
      if pos('ALWAYS',descu) > 0 then do
         if pos('INTOSC', descu) > 0 then
             kwdvalue = 'INTOSC'
         else
             kwdvalue = 'SOCS'
      end
      else if pos('FRC',descu) > 0 then
         kwdvalue = 'FRC'
      else if pos('FOSC_4',descu) > 0 then
         kwdvalue = 'FOSC'
      else
         kwdvalue = descu
   end

   when key = 'WDTCS' then do
      if pos('LOW',descu) > 0 then
         kwdvalue = 'LOW_POWER'
      else
         kwdvalue = 'STANDARD'
   end

   when key = 'WDTWIN' then do
      x = pos('WIDTH_IS', descu)
      if x > 0 then
         kwdvalue = 'P'substr(descu, x + 9, 2)              /* percentage */
      else
         kwdvalue = descu
   end

   when key = 'WPCFG' then do
      if val = 'ON' | val = 'WPCFGEN' then
         kwdvalue = 'ENABLED'
      else
         kwdvalue = 'DISABLED'
   end

   when key = 'WPDIS' then do
      if val = 'ON' | val = 'WPEN' then
         kwdvalue = 'ENABLED'
      else
         kwdvalue = 'DISABLED'
   end

   when key = 'WPEND' then do
      if pos('PAGES_0', descu) > 0  | pos('PAGE_0', descu) > 0  then
         kwdvalue = 'P0_WPFP'
      else
         kwdvalue = 'PWPFP_END'
   end

   when key = 'WPFP' then do
      kwdvalue = 'P'word(desc, words(desc))                 /* last word */
   end

   when key = 'WPSA' then do
      x = pos(':', desc)                                    /* fraction */
      if x > 0 then
         kwdvalue = 'P'substr(desc, x + 1)                  /* divisor */
      else
         kwdvalue = descu
   end

   when key = 'WRT'  |,
      ( left(key,3) = 'WRT'  &,
           (datatype(substr(key,4),'W') = 1 |,
            substr(key,4,1) = 'B'           |,
            substr(key,4,1) = 'C'           |,
            substr(key,4,1) = 'D') )     then do
      if pos('NOT',desc) > 0  |  val = 'OFF' then
         kwdvalue = 'DISABLED'                              /* not protected */
      else if val = 'BOOT' then
         kwdvalue = 'BOOT_BLOCK'                            /* boot block protected */
      else if val = 'HALF' then
         kwdvalue = 'HALF'                                  /* 1/2 of memory protected */
      else if val = 'FOURTH' | val = '1FOURTH' then
         kwdvalue = 'FOURTH'                                /* 1/4 of memory protected */
      else if datatype(val) = 'NUM' then
         kwdvalue = 'W'val                                  /* number of words */
      else
         kwdvalue = 'ENABLED'                               /* whole memory protected */
   end

   when key = 'WURE' then do
      if val = 'ON' then
         kwdvalue = 'CONTINUE'
      else
         kwdvalue = 'RESET'
   end

otherwise                                                   /* everything else */
   if val = 'OFF' | val = 'DISABLED' then
      kwdvalue = 'DISABLED'
   else if val = 'ON' | val = 'DISABLED' then
      kwdvalue = 'ENABLED'
   else if pos('ACTIVE',desc) > 0 then do
      if pos('HIGH',desc) > pos('ACTIVE',desc) then
         kwdvalue = 'ACTIVE_HIGH'
      else if pos('LOW',desc) > pos('ACTIVE',desc) then
         kwdvalue = 'ACTIVE_LOW'
      else do
         kwdvalue = 'ENABLED'
      end
   end
   else if pos('ENABLE',desc) > 0 | desc = 'ON' | desc = 'ALL' then do
      kwdvalue = 'ENABLED'
   end
   else if pos('DISABLE',desc) > 0 | desc = 'OFF' | pos('SOFTWARE',desc) > 0 then do
      kwdvalue = 'DISABLED'
   end
   else if pos('ANALOG',desc) > 0 then
      kwdvalue = 'ANALOG'
   else if pos('DIGITAL',desc) > 0 then
      kwdvalue = 'DIGITAL'
   else do
      if left(desc,1) >= '0' & left(desc,1) <= '9' then do  /* starts with digit */
         if pos('HZ',desc) > 0  then                        /* probably frequency (range) */
            kwdvalue = 'F'word(desc,1)                      /* 'F' prefix */
         else if pos(' TO ',desc) > 0  |,                   /* probably a range */
                 pos('0 ',  desc) > 0  |,
                 pos(' 0',  desc) > 0  |,
                 pos('H-',  desc) > 0  then do
            if pos(' TO ',desc) > 0  then do
               kwdvalue = delword(desc,4)                   /* keep 1st three words */
               kwdvalue = delword(kwdvalue,2,1)             /* keep only 'from' and 'to' */
               kwdvalue = translate(kwdvalue, ' ','H')      /* replace 'H' by space */
               kwdvalue = space(kwdvalue,1,'_')             /* single underscore */
            end
            else
               kwdvalue = word(desc,1)                      /* keep 1st word */
            kwdvalue = 'R'translate(kwdvalue,'_','-')       /* 'R' prefix, hyphen->underscore */
         end
         else do                                            /* probably a number */
            kwdvalue = 'N'word(desc,1)                      /* 1st word, 'N' prefix */
         end
      end
      else
         kwdvalue = descu                                   /* if no alternative! */
   end
end

if kwdvalue = '   ' then                                    /* special ('...') */
   nop                                                      /* ignore */
else if kwdvalue = '' then                                  /* empty keyword */
   call msg 3, 'No keyword found for fuse_def' key '('desc')'
else if length(kwdvalue) > 22  then
   call msg 2, 'fuse_def' key 'keyword excessively long: "'kwdvalue'"'

return kwdvalue


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
list_analog_functions: procedure expose jalfile Name. Core DevSpec. PinMap. Sharedmem.,
                                        ADCS_bits ADC_highres PicName msglevel
call lineout jalfile, '--'
call lineout jalfile, '-- ==================================================='
call lineout jalfile, '--'
call lineout jalfile, '--    Constants and procedures for analog features'
call lineout jalfile, '--    --------------------------------------------'
call lineout jalfile, '--'

PicNameCaps = toupper(PicName)
if DevSpec.PicNameCaps.ADCgroup = '?' then do               /* no ADC group specified */
   if (Name.ADCON \= '-' | Name.ADCON0 \= '-' | Name.ADCON1 \= '-') then do
      call msg 3, 'PIC has ADCONx register, but no ADCgroup found in devicespecific.json!'
   end
   ADC_group = '0'                                          /* no ADC module */
   ADC_res = '0'                                            /* # bits */
end
else do                                                     /* ADC group specified */
   ADC_group = DevSpec.PicNameCaps.ADCgroup
   if DevSpec.PicNameCaps.ADCMAXRESOLUTION = '?' then do    /* # bits not specified */
      if ADC_highres = 0  &  Core < 16  then                /* base/mid range without ADRESH */
         ADC_res = '8'
      else
         ADC_res = '10'                                     /* default max res */
   end
   else
      ADC_res = DevSpec.PicNameCaps.ADCMAXRESOLUTION        /* specified ADC bits */
end

if  PinMap.PicNameCaps.ANCOUNT = '?' |,                     /* PIC not in pinmap.cmd? */
    ADC_group = '0'  then                                   /* PIC has no ADC module */
   PinMap.PicNameCaps.ANCOUNT = 0
call charout jalfile, 'const      ADC_GROUP          =' ADC_group
if ADC_group = '0' then
   call charout jalfile, '        -- no ADC module present'
call lineout jalfile, ''
call lineout jalfile, 'const byte ADC_NTOTAL_CHANNEL =' PinMap.PicNameCaps.ANCOUNT
call lineout jalfile, 'const byte ADC_ADCS_BITCOUNT  =' ADCS_bits
call lineout jalfile, 'const byte ADC_MAX_RESOLUTION =' ADC_res
call lineout jalfile, '--'

if (ADC_group = '0'  & PinMap.PicNameCaps.ANCOUNT > 0) |,
   (ADC_group \= '0' & PinMap.PicNameCaps.ANCOUNT = 0) then do
   call msg 2, 'Possible conflict between ADC-group ('ADC_group')',
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
         do j = (8 * i) to (8 * 1 + 7)                      /* all PCFG bits */
            bitname = qname'_PCFG'j
            if Name.bitname \= '-' then do                  /* ANCON has a PCFG bit */
               call lineout jalfile, '   'qname '= 0b1111_1111     -- digital I/O'
               leave
            end
         end
         if Name.bitname = '-' then do                      /* ANCON has no  PCFG bit */
            do j = (8 * i) to (8 * i + 7)                   /* try ANSEL bits */
               bitname = qname'_ANSEL'j                     /* ANSEL bit */
               if Name.bitname \= '-' then do               /* ANCONi has ANSEL bit(s) */
                  call lineout jalfile, '   'qname '= 0b0000_0000        -- digital I/O'
                  leave
               end
            end
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
      if ADC_group = 'ADC_V1' then
         call lineout jalfile, '   ADCON1 = 0b0000_0111         -- digital I/O'
      else if ADC_group = 'ADC_V2'     |,
              ADC_group = 'ADC_V4'     |,
              ADC_group = 'ADC_V5'     |,
              ADC_group = 'ADC_V6'     |,
              ADC_group = 'ADC_V12'    then
         call lineout jalfile, '   ADCON1 = 0b0000_1111'
      else if ADC_group = 'ADC_V3' then
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
call lineout jalfile, '-- Switch analog ports to digital mode when analog module(s) present.'
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


/* --------------------------------------------------------- */
/* procedure to extend address with mirrored addresses       */
/* input:  - register number (decimal)                       */
/*         - address  (decimal)                              */
/* returns string of addresses between {}                    */
/* (only for Core 12 and 14)                                 */
/* --------------------------------------------------------- */
sfr_mirror_address: procedure expose Ram. BankSize NumBanks Core
parse upper arg addr .
addr_list = '{ 0x'D2X(addr)                                 /* open bracket, orig. addr */
if Core = '12' | Core = '14' then do
   MaxBanks = NumBanks
   if NumBanks > 4 then
      MaxBanks = 4
   do i = (addr + BankSize) to (MaxBanks * BankSize - 1) by BankSize  /* avail ram */
      if addr = Ram.i then                                  /* matching reg number */
         addr_list = addr_list',0x'D2X(i)                   /* concatenate to string */
   end
end
return addr_list' }'                                        /* complete string */


/* --------------------------------------------------------- */
/* Miscellaneous information                                 */
/* --------------------------------------------------------- */
list_miscellaneous:
call lineout jalfile, '--'
call lineout jalfile, '-- ==================================================='
call lineout jalfile, '--'
call lineout jalfile, '--    Miscellaneous'
call lineout jalfile, '--    -------------'

call lineout jalfile, '--'
if DevSpec.PicNameCaps.PPSgroup = '?' then
   call lineout jalfile, 'const PPS_GROUP        = PPS_0',
                         '       -- no Peripheral Pin Selection'
else
   call lineout jalfile, 'const PPS_GROUP        = 'DevSpec.PicNameCaps.PPSgroup,
                         '       -- PPS group' right(DevSpec.PicNameCaps.PPSgroup,1)

if Name.UCON \= '-' then do                                 /* USB module present */
   call lineout jalfile, '--'
   if DevSpec.PicNameCaps.USBBDT \= '?' then
      call lineout jalfile, 'const word USB_BDT_ADDRESS    = 0x'DevSpec.PicNameCaps.USBBDT
   else
      call msg 2, PicName 'has USB module but USB_BDT_ADDRESS not specified'
end

call lineout jalfile, '--'
if sharedmem.0 > 0 then do                                  /* any shared memory left */
   call charout jalfile, '-- Free shared memory: 0x'D2X(sharedmem.1)
   if sharedmem.1 < sharedmem.2 then                        /* more than 1 byte */
      call lineout jalfile, '-0x'D2X(sharedmem.2)
   else
      call lineout jalfile, ''
end
else
   call lineout jalfile, '-- No free shared memory!'
call lineout jalfile, '--'
return


/* --------------------------------------------------------- */
/* Generate common header                                    */
/* Shared memory for _pic_accum and _pic_isr_w is allocated: */
/* - for core 12, 14 and 14H from high to low address        */
/* - for core 16 from low to high address                    */
/* --------------------------------------------------------- */
list_header:
call lineout jalfile, '-- ==================================================='
call lineout jalfile, '-- Title: JalV2 device include file for PIC'toupper(PicName)
call list_copyright_etc jalfile
call lineout jalfile, '-- Description:'
call lineout Jalfile, '--    Device include file for pic'PicName', containing:'
call lineout jalfile, '--    - Declaration of ports and pins of the chip.'
if HasLATreg \= 0 then do                                   /* PIC has LATx register(s)  */
   call lineout jalfile, '--    - Procedures to force the use of the LATx register'
   call lineout jalfile, '--      for output when PORTx or pin_xy is addressed.'
end
else do                                                     /* for the 18F series */
   call lineout jalfile, '--    - Procedures for shadowing of ports and pins'
   call lineout jalfile, '--      to circumvent the read-modify-write problem.'
end
call lineout jalfile, '--    - Symbolic definitions for configuration bits (fuses)'
call lineout jalfile, '--    - Some device dependent procedures for common'
call lineout jalfile, '--      operations, like:'
call lineout jalfile, '--      . enable_digital_io()'
call lineout jalfile, '--'
call lineout jalfile, '-- Sources:'
call lineout jalfile, '--  - {MPLAB-X' mplabxVersion/100'}',
                             'crownking.edc.jar/content/edc/../PIC'toupper(PicName)'.PIC'
call lineout jalfile, '--'
call lineout jalfile, '-- Notes:'
call lineout jalfile, '--  - Created with Edc2Jal Rexx script version' ScriptVersion
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
   else do
      psnumber = insert('000', psnumber, 1)              /* make 8-digits variant */
      call SysFileSearch psnumber, DataSheetFile, 'sheet.'
      if sheet.0 > 0 then
         call lineout jalfile, 'const byte PGMSPEC[]   = "'word(sheet.1,1)'"'
   end
end
else if psnumber \= '' then do
   call SysFileSearch psnumber, DataSheetFile, 'sheet.'
   if sheet.0 > 0 then
      call lineout jalfile, 'const byte PGMSPEC[]   = "'word(sheet.1,1)'"'
   else do
      psnumber = insert('000', psnumber, 1)              /* make 8-digits variant */
      call SysFileSearch psnumber, DataSheetFile, 'sheet.'
      if sheet.0 > 0 then
         call lineout jalfile, 'const byte PGMSPEC[]   = "'word(sheet.1,1)'"'
   end
end
call stream DataSheetFile, 'c', 'close'                     /* not needed anymore */
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
if OSCCALaddr > 0 then                                      /* has OSCCAL word in high mem */
   call lineout jalfile, 'pragma  code    'CodeSize-1'                     -- (excl high mem word)'
else
   call lineout jalfile, 'pragma  code    'CodeSize
if EEspec \= '' then                                        /* any EEPROM present */
   call lineout jalfile, 'pragma  eeprom  'EESpec
if IDSpec \= '' then                                        /* PIC has ID memory */
   call lineout jalfile, 'pragma  ID      'IDSpec

drange = DevSpec.PicNameCaps.DATA
do while length(drange) > 50                                /* split large string */
   splitpoint = pos(',', drange, 49)                        /* first comma beyond 50 */
   if splitpoint = 0 then                                   /* no more commas */
      leave
   call lineout jalfile, 'pragma  data    'left(drange, splitpoint - 1)
   drange = substr(drange, splitpoint + 1)                  /* remainder */
end
call lineout jalfile, 'pragma  data    'drange              /* last or only line */

srange = DevSpec.PicNameCaps.SHARED                         /* shared GPR range */
if core = '16' then
   call lineout jalfile, 'pragma  shared  'srange',0xF'D2X(AccessBankSplitOffset)'-0xFFF'
else if core = '14H' then
   call lineout jalfile, 'pragma  shared  0x00-0x0B,'srange
else
   call lineout jalfile, 'pragma  shared  'srange

call lineout jalfile, '--'
if Core = '12'  |  Core = '14' then do
   if sharedmem.0 < 2 then                                  /* not enough shared memory */
      call msg 3, 'At least 2 bytes of shared memory required! Found:' sharedmem.0
   else do
      call lineout jalfile, 'var volatile byte _pic_accum at',
                               '0x'D2X(sharedmem.2)'      -- (compiler)'
      sharedmem.2 = sharedmem.2 - 1
      call lineout jalfile, 'var volatile byte _pic_isr_w at',
                               '0x'D2X(sharedmem.2)'      -- (compiler)'
      sharedmem.2 = sharedmem.2 - 1
      sharedmem.0 = sharedmem.0 - 2                         /* 2 bytes shared memory used */
   end
end
else do
   if sharedmem.0 < 1 then                                  /* not enough shared memory */
      call msg 3, 'At least 1 byte of shared memory required! Found:' sharedmem.0
   else if Core = '14H' then do
      call lineout jalfile, 'var volatile byte _pic_accum at',
                               '0x'D2X(sharedmem.2)'      -- (compiler)'
      sharedmem.2 = sharedmem.2 - 1
   end
   else do
      call lineout jalfile, 'var volatile byte _pic_accum at',
                               '0x'D2X(sharedmem.1)'      -- (compiler)'
      sharedmem.1 = sharedmem.1 + 1
   end
   sharedmem.0 = sharedmem.0 - 1                            /* 1 byte shared memory used */
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
call lineout chipdef, '--    - Created with Edc2Jal Rexx script version' ScriptVersion
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
call lineout listfile, '-- Author:' ScriptAuthor', Copyright (c) 2008..2013,',
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
f_size  = chars(DevSpecFile)                                /* determine filesize */
f_input = charin(DevSpecFile, 1, f_size)                    /* read file as a whole */
call stream DevSpecFile, 'c', 'close'                       /* done */
f_index = 0                                                 /* start index */

do until x = '{' | x = 0                                    /* search begin of pinmap */
   x = json_newchar()
end
do until x = '}' | x = 0                                    /* end of pinmap */
   do until x = '}' | x = 0                                 /* end of pic */
      PicName = json_newstring()                            /* new PIC */
      do until x = '{' | x = 0                              /* search begin PIC specs */
         x = json_newchar()
      end
      do until x = '}' | x = 0                              /* this PIC's specs */
         ItemName = json_newstring()
         value = json_newstring()
         DevSpec.PicName.ItemName = value
         x = json_newchar()
      end
      x = json_newchar()
   end
   x = json_newchar()
end
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
f_size  = chars(PinMapFile)
f_input = charin(PinMapFile, 1, f_size)
call stream DevSpecFile, 'c', 'close'
f_index = 0                                                 /* start index */

do until x = '{' | x = 0                                    /* search begin of pinmap */
   x = json_newchar()
end
do until x = '}' | x = 0                                    /* end of pinmap */
   do until x = '}' | x = 0                                 /* end of pic */
      PicName = json_newstring()                            /* new PIC */
      PinMap.PicName = PicName                              /* PIC listed in JSON file */
      do until x = '{' | x = 0                              /* search begin PIC specs */
        x = json_newchar()
      end
      ANcount = 0                                           /* zero ANxx count this PIC */
      do until x = '}' | x = 0                              /* this PICs specs */
         pinname = json_newstring()
         i = 0                                              /* no aliases (yet) */
         do until x = '[' | x = 0                           /* search pin aliases */
           x = json_newchar()
         end
         do until x = ']' | x = 0                           /* end of aliases this pin */
            aliasname = json_newstring()
            if aliasname = '' then do                       /* no (more) aliases */
               x = ']'                                      /* must have been last char read! */
               iterate
            end
            if right(aliasname,1) = '-' then                /* handle trailing '-' character */
               aliasname = strip(aliasname,'T','-')'_NEG'
            else if right(aliasname,1) = '+' then           /* handle trailing '+' character */
               aliasname = strip(aliasname,'T','+')'_POS'
            else if pos('+', aliasname) > 0 then do         /* handle middle '+' character */
               x = pos('+', aliasname)
               aliasname = delstr(aliasname, x, 1)
               aliasname = insert('_POS_', aliasname, x - 1)
            end
            else if pos('-', aliasname) > 0 then do         /* handle middle '-' character */
               x = pos('-', aliasname)
               aliasname = delstr(aliasname, x, 1)
               aliasname = insert('_NEG_', aliasname, x - 1)
            end
            i = i + 1
            PinMap.PicName.pinname.i = aliasname
            if left(aliasname,2) = 'AN' & datatype(substr(aliasname,3)) = 'NUM' then do
               ANcount = ANcount + 1
               PinANMap.PicName.aliasname = PinName         /* pin_ANx -> RXy */
            end
            x = json_newchar()
         end
         PinMap.PicName.pinname.0 = i
         x = json_newchar()
      end
      ANCountName = 'ANCOUNT'
      PinMap.PicName.ANCountName = ANcount
      x = json_newchar()
   end
   x = json_newchar()
end
return 0


/* -------------------------------- */
json_newstring: procedure expose f_input f_index f_size

do until x = '"' | x = ']' | x = '}' | x = 0                /* start new string or end of everything */
   x = json_newchar()
end
if x \= '"' then                                            /* no string found */
   return ''
str = ''
x = json_newchar()                                          /* first char */
do while x \= '"'
   str = str||x
   x = json_newchar()
end
return str


/* -------------------------------- */
json_newchar: procedure expose f_input f_index f_size
do while f_index < f_size
   f_index = f_index + 1
   x = substr(f_input,f_index,1)                            /* next character */
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
/* Collect all names in Name. stem               */
/* --------------------------------------------- */
duplicate_name: procedure expose Name. PicName msglevel
parse arg newname, reg .
if newname = '' then do                                     /* no name specified */
   call msg 3, 'Attempt to check an empty name for duplicates'
   return 1                                                 /* not acceptable */
end
if Name.newname = '-' then do                               /* name not in use yet */
   Name.newname = reg                                       /* mark in use by which reg */
   return 0                                                 /* unique */
end
if reg \= newname then do                                   /* not alias of register */
   call msg 2, 'Duplicate name:' newname 'in' reg
   return 1                                                 /* duplicate */
end
return 0


/* -------------------------------------------------- */
/* translate string to lower or upper case            */
/* translate (capital) meta-characters to ASCII chars */
/* convert (hexa)numeric string to decimal value      */
/* -------------------------------------------------- */

tolower: procedure
return translate(arg(1), xrange('a','z'), xrange('A','Z'))

toupper: procedure
return translate(arg(1), xrange('A','Z'), xrange('a','z'))

toascii: procedure
xml.1.1 = '&lt;'
xml.1.2 = '<'
xml.2.1 = '&LT;'
xml.2.2 = '<'
xml.3.1 = '&gt;'
xml.3.2 = '>'
xml.4.1 = '&GT;'
xml.4.2 = '>'
xml.5.1 = '&amp;'
xml.5.2 = '&'
xml.6.1 = '&AMP;'
xml.6.2 = '&'
xml.0 = 6
parse arg ln                                                /* line to be converted */
do i = 1 to xml.0                                           /* all meta strings */
   x = pos(xml.i.1, ln)                                     /* search this xml meta string */
   do while x > 0
      ln = delstr(ln, x, length(xml.i.1))                   /* remove meta string and .. */
      ln = insert(xml.i.2, ln, x - 1)                       /* .. replace it by ASCII char */
      x = pos(xml.i.1, ln)                                  /* search next instance of meta string */
   end
end
return ln

/* return the decimal value of a numeric string */
/* (convert hexadecimal to decimal when prefixed with 0x) */
todecimal: procedure
parse upper arg z .                                         /* argument uppercase */
z = strip(z)                                                /* remove surrounding blanks */
if left(z,2) = '0X' then                                    /* when prefixed with '0x' */
   z = X2D(substr(z,3))                                     /* convert to decimal */
return z + 0                                                /* return numeric value */


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


