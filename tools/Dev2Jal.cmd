/* ------------------------------------------------------------------------ *
 * Title: Dev2Jal.cmd - Create JalV2 device include files for flash PICs    *
 *                                                                          *
 * Author: Rob Hamerling, Copyright (c) 2008..2009, all rights reserved.    *
 *                                                                          *
 * Adapted-by:                                                              *
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
 *   Apart from declaration of all ports and pins of the chip               *
 *   the include files will contain shadowing procedures to                 *
 *   prevent the 'read-modify-write' problems of midrange PICs and          *
 *   for the 18F force the use of LATx for output in stead of PORTx.        *
 *   In addition some device dependent procedures are provided              *
 *   for common operations, like enable-digital-io().                       *
 *                                                                          *
 * Sources:  MPLAB .dev and .lkr files                                      *
 *                                                                          *
 * Notes:                                                                   *
 *   - Summary of internal changes is kept in 'changes.txt' (not published) *
 *   - The script contains some test and debugging code.                    *
 *                                                                          *
 * ------------------------------------------------------------------------ */
   ScriptVersion   = '0.0.73'                   /*                          */
   ScriptAuthor    = 'Rob Hamerling'            /* global constants         */
   CompilerVersion = '2.4k'                     /*                          */
/* ------------------------------------------------------------------------ */

mplabdir    = 'k:/mplab833/'                    /* MPLAB base directory */
                                                /* (drive letter mandatory!) */
devdir      = mplabdir'mplab_ide/device/'       /* dir with .dev files */
lkrdir      = mplabdir'mpasm_suite/lkr/'        /* dir with .lkr files */
PicSpecFile = 'devicespecific.cmd'              /* script with PIC specific info */
PinMapFile  = 'pinmap.cmd'                      /* script with pin aliases */
FuseDefFile = 'fusedefmap.cmd'                  /* script with fuse_def name mapping */

say 'Dev2Jal version' ScriptVersion '  -  ' ScriptAuthor

parse upper arg destination selection .         /* commandline arguments */
if destination = 'PROD' then                    /* production run */
  dstdir = '/jallib/include/device/'            /* local Jallib */
else if destination = 'TEST' then               /* test run */
  dstdir = 'test/'                              /* subdir for testing */
else do
  say 'Error: Required argument missing: "prod" or "test"'
  return 1
end

if selection = '' then                          /* no selection spec'd */
  wildcard = 'pic1*.dev'                        /* default (8 bit PICs) */
else if destination = 'TEST' then               /* TEST run */
  wildcard = 'pic'selection'.dev'               /* accept user selection */
else do                                         /* PROD run with selection */
  say 'Selection not allowed for production run!'
  return 1                                      /* exit */
end

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                               /* load Rexx utilities */

call SysFileTree devdir||wildcard, dir, 'FO'    /* get list of filespecs */
if dir.0 < 1 then do
  say 'No .dev files matching <'wildcard'> found in' devdir
  return 1
end

chipdef = dstdir'chipdef_jallib.jal'            /* common include file */
if stream(chipdef, 'c', 'query exists') \= '' then   /* old chipdef file present */
  call SysFileDelete chipdef                    /* delete it */
if stream(chipdef, 'c', 'open write') \= 'READY:' then do   /* new chipdef file */
  Say 'Error: Could not create common include file' chipdef
  return 1
end

call time 'E'                                   /* start 'elapsed' timer */
say 'Creating JalV2 device files ...'

signal on syntax name catch_syntax              /* catch syntax errors */
signal on error  name catch_error               /* catch execution errors */

PicSpec. = '?'                                  /* PIC specific data */
call file_read_picspec                          /* read device specific data */

PinMap.  = '?'                                  /* pin mapping data */
call file_read_pinmap                           /* read pin alias names */

Fuse_Def. = '?'                                 /* Fuse_Def name mapping */
call file_read_fusedef                          /* read fuse_def table */

call list_chip_const                            /* make header of chipdef file */

ListCount = 0                                   /* # created device files */

do i=1 to dir.0                                 /* all relevant .dev files */
                                                /* init for each new PIC */
  Dev.        = ''                              /* .dev file contents    */
  Lkr.        = ''                              /* .lkr file contents    */
  Ram.        = ''                              /* sfr usage and mirroring */
  Name.       = '-'                             /* register and subfield names */
  CfgAddr.    = ''                              /* )          */
  IDAddr.     = ''                              /* ) decimal! */

  DevFile = tolower(translate(dir.i,'/','\'))   /* lower case + forward slashes */
  parse value filespec('Name', DevFile) with 'pic' PicName '.dev'
  if PicName = '' then do
    Say 'Error: Could not derive PIC name from filespec: "'DevFile'"'
    leave                                       /* terminate */
  end

  if substr(PicName,3,1) \= 'f'  &,             /* not flash PIC */
     substr(PicName,3,2) \= 'lf' &,             /* not low power flash PIC */
     substr(PicName,3,2) \= 'hv' then do        /* not high voltage flash PIC */
    iterate                                     /* skip */
  end

  if pos('f18', PicName) > 0  |,                /* exclude extended 14-bit core */
     pos('f19', PicName) > 0 then do
    say 'Info:' PicName 'skipped: not supported by JalV2'
    iterate                                     /* skip */
  end

  say PicName                                   /* progress signal */

  if file_read_dev() = 0 then                   /* read .dev file */
    iterate                                     /* problem */

  if file_read_lkr() = 0 then                   /* read .lkr file */
    iterate                                     /* problem */

  jalfile = dstdir||PicName'.jal'               /* .jal file */
  if stream(jalfile, 'c', 'query exists') \= '' then   /* previous */
    call SysFileDelete jalfile                  /* delete */
  if stream(jalfile, 'c', 'open write') \= 'READY:' then do
    Say 'Error: Could not create device file' jalfile
    leave                                       /* terminate */
  end

  call load_config_info                         /* collect cfg info + core */
  select                                        /* select core specific formatting */
    when core = 12 then                         /* baseline */
      rx = dev2Jal12()
    when core = 14 then                         /* midrange */
      rx = dev2Jal14()
    when core = 16 then                         /* 18Fs */
      rx = dev2Jal16()
  otherwise                                     /* other or undetermined core */
    say 'Error: Unsupported core:' Core         /* report detected Core */
    leave                                       /* terminate */
  end

  call stream jalfile, 'c', 'close'             /* done */

  if rx = 0 then                                /* device file created */
    ListCount = ListCount + 1;                  /* count successful results */

end

call lineout chipdef, '--'
call stream  chipdef, 'c', 'close'              /* done */

say 'Generated' listcount 'device files for' dir.0 '.dev files in',
     format(time('E'),,2) 'seconds'

signal off error
signal off syntax                               /* restore to default */

return 0


/* ==================================================================== */
/*                      1 2 - B I T S   C O R E                         */
/* ==================================================================== */
dev2jal12: procedure expose ScriptVersion ScriptAuthor CompilerVersion,
                            Core PicName JalFile ChipDef DevFile LkrFile,
                            Dev. Lkr. Ram. Name. CfgAddr. IDAddr.,
                            PicSpec. PinMap. Fuse_Def.

MAXRAM     = 128                                /* range 0..0x7F */
BANKSIZE   = 32                                 /* 0x0020 */
PAGESIZE   = 512                                /* 0x0200 */
DataStart  = '0x400'                            /* default */
NumBanks   = 1                                  /* default */
StackDepth = 2                                  /* default */

call load_stackdepth                            /* check stack depth */
call load_sfr1x                                 /* load sfr + mirror info */
call load_IDAddr                                /* load ID addresses */

call list_head                                  /* header */
call list_fuses_words1x                         /* config memory */
call list_IDmem                                 /* ID memory */
call list_sfr1x                                 /* special function registers */
call list_nmmr12                                /* non memory mapped regs */
call list_analog_functions                      /* register info */
call list_fuses_bits                            /* fuses details */
return 0


/* ==================================================================== */
/*                      1 4 - B I T S   C O R E                         */
/* ==================================================================== */
dev2jal14: procedure expose ScriptVersion ScriptAuthor CompilerVersion,
                            Core PicName JalFile ChipDef DevFile LkrFile,
                            Dev. Lkr. Ram. Name. CfgAddr. IDAddr.,
                            PicSpec. PinMap. Fuse_Def.

MAXRAM     = 512                                /* range 0..0x1FF */
BANKSIZE   = 128                                /* 0x0080 */
PAGESIZE   = 2048                               /* 0x0800 */
DataStart  = '0x2100'                           /* default */
NumBanks   = 1                                  /* default */
StackDepth = 8                                  /* default */

call load_stackdepth                            /* check stack depth */
call load_sfr1x                                 /* load sfr + mirror info */
call load_IDAddr                                /* load ID addresses */

call list_head                                  /* header */
call list_fuses_words1x                         /* config memory */
call list_IDmem                                 /* ID memory */
call list_sfr1x                                 /* register info */
                                                /* No NMMRs with core_14! */
call list_analog_functions                      /* register info */
call list_fuses_bits                            /* fuses details */
return 0


/* ==================================================================== */
/*                      1 6 - B I T S   C O R E                         */
/* ==================================================================== */
dev2jal16: procedure expose ScriptVersion ScriptAuthor CompilerVersion,
                            Core PicName JalFile ChipDef DevFile LkrFile,
                            Dev. Lkr. Ram. Name. CfgAddr. IDAddr.,
                            PicSpec. PinMap. Fuse_Def.

MAXRAM     = 4096                               /* range 0..0x0xFFF */
BANKSIZE   = 256                                /* 0x0100 */
DataStart  = '0xF00000'                         /* default */
NumBanks   = 1                                  /* default */
AccessBankSplitOffset = 128                     /* default */
StackDepth = 31                                 /* default */

call load_sfr16                                 /* load sfr */
call load_IDAddr                                /* load ID addresses */

call list_head                                  /* header */
call list_fuses_bytes16                         /* config memory */
call list_IDmem                                 /* ID memory */
call list_sfr16                                 /* register info */
call list_nmmr16                                /* selected non memory mapped regs */
call list_analog_functions                      /* register info */
call list_fuses_bits                            /* fuses details */
return 0


/* ==================================================================== */
/*          End of the core-specific main procedures                    */
/* ==================================================================== */


/* ------------------------------------------- */
/* Read .dev file contents into stem variable  */
/* input:                                      */
/*                                             */
/* Collect only relevant lines!                */
/* ------------------------------------------- */
file_read_dev: procedure expose DevFile Dev.
Dev.0 = 0                                       /* no records read yet */
if stream(DevFile, 'c', 'open read') \= 'READY:' then do
  Say 'Error: could not open .dev file' DevFile
  return 0                                      /* zero records */
end
i = 1                                           /* first record */
do while lines(DevFile) > 0                     /* read whole file */
  parse upper value linein(DevFile) with Dev.i  /* store line in upper case */
  if length(Dev.i) \< 3 then do                 /* not an 'empty' record */
    if left(word(Dev.i,1),1) \= '#' then        /* not comment */
      i = i + 1                                 /* keep this record */
  end
end
call stream DevFile, 'c', 'close'               /* done */
Dev.0 = i - 1                                   /* # of stored records */
return Dev.0


/* ------------------------------------------- */
/* Read .lkr file contents into stem variable  */
/* input:  - PicName                           */
/* output: - LkrFile pathspec                  */
/*                                             */
/* Collect only relevant lines!                */
/* ------------------------------------------- */
file_read_lkr: procedure expose PicName LkrDir LkrFile Lkr.
LkrFile = LkrDir||PicName'_g.lkr'               /* try with full PIC name */
if stream(LkrFile, 'c', 'query exists') = '' then do
  if pos('lf',PicName) > 0 then do              /* low voltage PIC */
    LkrFile = LkrDir||left(PicName,3)||substr(PicName,5)'_g.lkr'  /* keep 'L', strip 'F' */
    if stream(LkrFile,'c','query exists') = '' then do
      LkrFile = LkrDir||left(PicName,2)||substr(PicName,4)'_g.lkr'  /* strip 'L' */
      if stream(LkrFile,'c','query exists') = '' then
        nop                                     /* all LF alternatives failed */
    end
  end
end
Lkr.0 = 0                                       /* no records read */
if stream(LkrFile, 'c', 'open read') \= 'READY:' then do
  Say 'Error: Could not find any suitable .lkr file for' PicName
  return 0                                      /* zero records */
end
i = 1                                           /* first record */
do while lines(LkrFile) > 0                     /* whole file */
  parse upper value linein(LkrFile) with Lkr.i  /* store line in upper case */
  if length(Lkr.i) \> 2           |,            /* empty */
     left(word(Lkr.i,1),2) = '//' |,            /* .lkr comment */
     word(Lkr.i,1) = '#FI'        |,            /* end if */
     word(Lkr.i,1) = '#DEFINE'    |,            /* const definition */
     word(Lkr.i,1) = 'LIBPATH' then             /* Library path */
    iterate                                     /* skip these lines */
  if word(Lkr.i,1) = '#IFDEF' then do           /* conditional part */
    if left(word(Lkr.i,2),6) = '_DEBUG'  |,     /* debugging */
       left(word(Lkr.i,2),6) = '_EXTEN' then do /* extended mode */
      do while lines(LkrFile) > 0               /* skip lines */
        parse upper value linein(LkrFile) with ln  /* read line */
        if word(ln,1) = '#ELSE' |,              /* other than debugging */
           word(ln,1) = '#FI' then do           /* end conditional part */
          leave                                 /* resume normal */
        end
      end
    end
  end
  else do                                       /* not skipped */
    i = i + 1                                   /* keep this record */
  end
end
call stream LkrFile, 'c', 'close'               /* done */
Lkr.0 = i - 1                                   /* # non-comment records */
return Lkr.0                                    /* number of records */


/* --------------------------------------------------- */
/* Read file with Device Specific data                 */
/* Interpret contents: fill compound variable PicSpec. */
/* --------------------------------------------------- */
file_read_picspec: procedure expose PicSpecFile PicSpec.
if stream(PicSpecFile, 'c', 'open read') \= 'READY:' then do
  Say 'Error: could not open file with Device Specific data' PicSpecFile
  exit 1                                        /* zero records */
end
call charout , 'Reading PIC specific properties from' PicSpecFile '... '
do while lines(PicSpecFile) > 0                 /* read whole file */
  interpret linein(PicSpecFile)                 /* read and interpret line */
end
call stream PicSpecFile, 'c', 'close'           /* done */
say 'done!'
return


/* --------------------------------------------------- */
/* Read file with pin alias information                */
/* Interpret contents: fill compound variable PinMap.  */
/* --------------------------------------------------- */
file_read_pinmap: procedure expose PinMapFile PinMap.
if stream(PinMapFile, 'c', 'open read') \= 'READY:' then do
  Say 'Error: could not open file with Pin Alias information' PinMapFile
  exit 1                                        /* zero records */
end
call charout , 'Reading pin alias names from' PinMapFile '... '
do while lines(PinMapFile) > 0                  /* read whole file */
  interpret linein(PinMapFile)                  /* read and interpret line */
end
call stream PinMapFile, 'c', 'close'            /* done */
say 'done!'
return


/* ---------------------------------------------------- */
/* Read file with oscillator name mapping               */
/* Interpret contents: fill compound variable Fuse_Def. */
/* ---------------------------------------------------- */
file_read_fusedef: procedure expose FuseDefFile Fuse_Def.
if stream(FuseDefFile, 'c', 'open read') \= 'READY:' then do
  Say 'Error: could not open file with fuse_def mappings' FuseDefFile
  exit 1                                        /* zero records */
end
call charout , 'Reading Fusedef Names from' FuseDefFile '... '
do while lines(FuseDefFile) > 0                 /* read whole file */
  interpret linein(FuseDefFile)                 /* read and interpret line */
end
call stream FuseDefFile, 'c', 'close'           /* done */
say 'done!'
return


/* ---------------------------------------------- */
/* procedure to collect Config (fuses) info       */
/* input:   - nothing                             */
/* output:  - core (0, 12, 14, 16 bits)           */
/* ---------------------------------------------- */
load_config_info: procedure expose Dev. CfgAddr. Core
CfgAddr.0 = 0                                   /* empty */
Core = 0                                        /* reset: undetermined */
do i = 1 to Dev.0
  parse var Dev.i 'CFGMEM' '(' 'REGION' '=' '0X' Val1 '-' '0X' Val2 ')' .
  if Val1 \= '' then do
    Val1 = X2D(Val1)                            /* take decimal value */
    Val2 = X2D(Val2)
    if Val1 = X2D('FFF') then                   /* 12-bits core */
      Core = 12
    else if Val1 = X2D('2007') | Val1 = X2D('8007') then  /* 14-bits core */
      Core = 14
    else                                        /* presumably 16-bits core */
      Core = 16
    CfgAddr.0 = Val2 - Val1 + 1                 /* number of config bytes */
    do j = 1 to CfgAddr.0                       /* all config bytes */
      CfgAddr.j = Val1 + j - 1                  /* address */
    end
    leave                                       /* 1 occurence expected */
  end
end
return


/* ---------------------------------------------- */
/* procedure to determine ID memory range         */
/* input:  - nothing                              */
/* ---------------------------------------------- */
load_IDAddr: procedure expose Dev. IDaddr.
IDaddr.0 = 0                                    /* empty */
do i = 1 to Dev.0
  parse var Dev.i 'USERID' '(' 'REGION' '=' Value ')' .
  if Value \= '' then do
    parse var Value '0X' val1 '-' '0X' val2 .
    if val1 \= '' then do
      IDaddr.0 = X2D(val2) - X2D(val1) + 1      /* count */
      do j = 1 to IDAddr.0
        IDaddr.j = X2D(val1) + j - 1            /* address */
      end
    end
    leave                                       /* 1 occurence expected */
  end
end
return


/* ---------------------------------------------- */
/* procedure to obtain hardware stack depth       */
/* input:  - nothing                              */
/* ---------------------------------------------- */
load_stackdepth: procedure expose Dev. StackDepth
do i = 1 to Dev.0
  parse var Dev.i 'HWSTACKDEPTH' '=' Val1 .
  if Val1 \= '' then do
    StackDepth = strip(val1)
    leave                                       /* 1 occurence expected */
  end
end
return


/* ---------------------------------------------------------- */
/* procedure to build special function register array         */
/* with mirror info and unused registers                      */
/* input:  - nothing                                          */
/* 12-bit and 14-bit core                                     */
/* ---------------------------------------------------------- */
load_sfr1x: procedure expose Dev. Name. Ram. MAXRAM NumBanks
do i = 0 to MAXRAM - 1                          /* whole range */
  Ram.i = 0                                     /* mark as unused */
end
do i = 1 to Dev.0
  ln = Dev.i                                    /* copy line */
  parse var ln 'NUMBANKS' '=' Value .           /* memory banks */
  if Value \= '' then do
    NumBanks = strip(Value)
    if NumBanks > 4 then do                     /* esp. for 16F59 */
      say 'Warning: Number of RAM banks > 4'
      NumBanks = 4                              /* compiler limit */
    end
    iterate
  end
  parse var ln 'MIRRORREGS' '(' '0X' low.1  '-' '0X' high.1,
                                '0X' low.2  '-' '0X' high.2,
                                '0X' low.3  '-' '0X' high.3,
                                '0X' low.4  '-' '0X' high.4,
                                '0X' low.5  '-' '0X' high.5,
                                '0X' low.6  '-' '0X' high.6,
                                '0X' low.7  '-' '0X' high.7,
                                '0X' low.8  '-' '0X' high.8,
                                '0X' low.9  '-' '0X' high.9,
                                '0X' low.10 '-' '0X' high.10,
                                '0X' low.11 '-' '0X' high.11,
                                '0X' low.12 '-' '0X' high.12,
                                '0X' low.13 '-' '0X' high.13,
                                '0X' low.14 '-' '0X' high.14,
                                '0X' low.15 '-' '0X' high.15,
                                '0X' low.16 '-' '0X' high.16 ')' .
  if low.1 \= '' & high.1 \= '' then do
    a = X2D(strip(low.1))
    b = X2D(strip(strip(high.1),'B',')'))
    do j = 2 to 16                              /* all possible banks */
      if low.j \= '' & high.j \= '' then do     /* specified bank */
        p = X2D(strip(low.j))                   /* mirror low bound */
        do k = a to b                           /* whole range */
          Ram.k = k                             /* mark 'used' */
          Ram.p = k                             /* mark as mirror */
          p = p + 1                             /* next mirrored reg. */
        end
      end
    end
    iterate
  end
  parse var ln 'UNUSEDREGS' '(' '0X' lo '-' '0X' hi ')' .
  if lo \= '' & hi \= '' then do
    a = X2D(strip(lo))
    b = X2D(strip(hi))
    do k = a to b                               /* whole range */
      Ram.k = -1                                /* mark 'unused' */
    end
    iterate
  end
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
load_sfr16: procedure expose Dev. Ram. BankSize NumBanks AccessBankSplitOffset
do i = 1 to Dev.0
  parse var Dev.i 'NUMBANKS' '=' Value .        /* memory banks */
  if Value \= '' then do
    NumBanks = strip(Value)                     /* feedback */
    iterate
  end
  parse var Dev.i 'ACCESSBANKSPLITOFFSET' '=' '0X' Value .  /* split */
  if Value \= '' then do
    AccessBankSplitOffset = X2D(strip(Value))    /* feedback */
    iterate
  end
  parse var Dev.i 'UNUSEDREGS' '(' '0X' lo '-' '0X' hi ')' .
  if lo \= '' & hi \= '' then do
    a = X2D(strip(lo))
    b = X2D(strip(hi))
    do k = a to b                               /* whole range */
      Ram.k = -1                                /* mark 'unused' */
    end
  end
end
return 0


/* --------------------------------------------------- */
/* procedure to list code memory size from .dev file   */
/* input:  - nothing                                   */
/* --------------------------------------------------- */
list_code_size: procedure expose Dev. jalfile core
CodeSize = 0
do i = 1 to Dev.0
  if word(Dev.i,1) \= 'PGMMEM' then         /* exclude 'EXTPGMMEM' ! */
    iterate
  parse var Dev.i 'PGMMEM' '(' 'REGION' '=' Value ')' .
  if Value \= '' then do
    parse var Value '0X' val1 '-' '0X' val2 .
    CodeSize = X2D(strip(Val2)) - X2D(strip(val1)) + 1
    if core == 16 then                      /* for 18Fs */
      CodeSize = CodeSize / 2               /* make it words */
  end
end
call lineout jalfile, 'pragma  code    'CodeSize'                    -- (words)'
return


/* ---------------------------------------------------------- */
/* procedure to list EEPROM data memory size from .dev file   */
/* input:  - nothing                                          */
/* ---------------------------------------------------------- */
list_data_size: procedure expose Dev. jalfile DataStart
do i = 1 to Dev.0
  if word(Dev.i,1) \= 'EEDATA'    &,
     word(Dev.i,1) \= 'FLASHDATA' then
    iterate
  parse var Dev.i val0 'REGION' '=' Value ')' .
  if Value \= '' then do
    parse var Value '0X' val1 '-' '0X' val2 .
    if X2D(val1) > 0 then do                    /* start address */
      say 'Info: DataStart changed from' DataStart 'to 0x'val1
      DataStart = '0x'val1
    end
    DataSize = X2D(val2) - X2D(val1) + 1
    call lineout jalfile, 'pragma  eeprom  'DataStart','DataSize
    leave                                       /* 1 occurence expected */
  end
end
return


/* ---------------------------------------------- */
/* procedure to list Device ID from .dev file     */
/* input:  - nothing                              */
/* remarks: some corrections of errors in MPLAB   */
/* ---------------------------------------------- */
list_devid: procedure expose Dev. jalfile chipdef Core PicName
DevID = '0000'                                  /* default (not found) */
do i = 1 to Dev.0
  parse var Dev.i 'DEVID' val0 'IDMASK' '=' Val1 'ID' '=' '0X' val2 ')' .
  if val2 \= '' then do
    RevMask = right(strip(Val1),4,'0')          /* 4 hex chars */
    DevID = right(strip(Val2),4,'0')            /* 4 hex chars */
    DevID = C2X(bitand(X2C(DevID),X2C(RevMask)))  /* reset revision bits */
    leave                                       /* 1 occurence expected */
  end
end
if DevId == '0000' then do                      /* DevID not found */
  if PicName = '16f627' then                    /* missing in MPlab */
    Devid = '07A0'
  else if PicName = '16f628' then               /* missing in MPlab */
    Devid = '07C0'
  else if PicName = '16f84A' then               /* missing in MPlab */
    Devid = '0560'
end
parse upper var PicName PicNameUpper
call lineout jalfile, 'const word DEVICE_ID   = 0x'DevID
if DevId \== '0000' then do                     /* DevID not missing */
  call lineout chipdef, left('const       PIC_'PicNameUpper,29) '= 0x_'Core'_'DevID
end
else do                                         /* DevID unknown */
  DevID = right(PicNameUpper,3)                 /* rightmost 3 chars of name */
  if datatype(Devid,'X') = 0 then do            /* not all hex digits */
    DevID = right(right(PicNameUpper,2),3,'F')  /* 'F' + rightmost 2 chars */
  end
  call lineout chipdef, left('const       PIC_'PicNameUpper,29) '= 0x_'Core'_F'DevID
end
return


/* ---------------------------------------------- */
/* procedure to list Vpp info from .dev file      */
/* input:  - nothing                              */
/* ---------------------------------------------- */
list_Vpp: procedure expose Dev. jalfile
do i = 1 to Dev.0
  parse var Dev.i 'VPP' '(' 'RANGE' '=' Val1 'DFLT' '=' Val2 ')' .
  if Val1 \= '' then do
    call lineout jalfile, '-- Vpp',
           'Range:' strip(Val1) 'Default:' strip(Val2)
    leave                                       /* 1 occurence expected */
  end
end
return


/* ---------------------------------------------- */
/* procedure to list Vdd info from .dev file      */
/* input:  - nothing                              */
/* ---------------------------------------------- */
list_Vdd: procedure expose Dev. jalfile
do i = 1 to Dev.0
  parse var Dev.i 'VDD' '(' 'RANGE' '=' Val1 'DFLTRANGE' '=' Val2 'NOMINAL' '=' Val3 ')' .
  if Val1 \= '' then do
    call lineout jalfile, '-- Vdd',
         'Range:' strip(Val1) 'Nominal:' strip(Val3)
    leave                                       /* 1 occurence expected */
  end
end
return


/* --------------------------------------------------------------- */
/* procedure to list shared RAM (gpr) ranges from .dev file        */
/* input:  - nothing                                               */
/* returns - string with range of shared RAM                       */
/*           in MaxSharedRam highest shared RAM address  (decimal) */
/* Note: Some PICs are handled 'exceptionally'                     */
/* --------------------------------------------------------------- */
list_shared_data_range: procedure expose Lkr. jalfile Core MaxSharedRAM PicName
select                                          /* exceptions first */
  when PicName = '12f629'  |,                   /* have only shared RAM */
       PicName = '12f675'  |,
       PicName = '16f630'  |,
       PicName = '16f676' then do
    DataRange = '0x5E-0x5F'                     /* some shared, rest unshared */
    MaxSharedRAM = X2D(5F)
    end                                         /* .. declared as non shared */
  when PicName = '16f818' then do
    DataRange = '0x40-0x7F'                     /* shared data range */
    MaxSharedRAM = X2D(7F)                      /* upper bound */
    end
  when PicName = '16f819'  |,                   /* */
       PicName = '16f870'  |,
       PicName = '16f871'  |,
       PicName = '16f872' then do
    DataRange = '0x70-0x7F'
    MaxSharedRAM = X2D(7F)
    end
  when PicName = '16f873'  |,                   /* have no shared RAM */
       PicName = '16f873a' |,
       PicName = '16f874'  |,
       PicName = '16f874a' then do
    DataRange = ''                              /* no shared RAM */
    MaxSharedRAM = 0
    end
otherwise                                       /* scan .lkr file */
  DataRange = ''                                /* set defaults */
  MaxSharedRAM = 0
  do i = 1 to Lkr.0
    ln = Lkr.i
    if pos('PROTECTED', ln) > 0 then            /* skip protected mem */
      iterate
    if Core = 12 | Core = 14 then
      parse var ln 'SHAREBANK' Val0 'START' '=' '0X' val1 'END' '=' '0X' val2 .
    else
      parse var Lkr.i 'ACCESSBANK' Val0 'START' '=' '0X' val1 'END' '=' '0X' val2 .
    if val1 \= '' then do
      if DataRange \= '' then                   /* not first range */
        DataRange = DataRange','                /* insert separator */
      val1 = strip(val1)
      val2 = strip(val2)
      if X2D(val2) > MaxSharedRAM then          /* new high limit */
        MaxSharedRAM = X2D(val2)                /* upper bound */
      DataRange = DataRange'0x'val1'-0x'val2    /* concatenate range */
    end
  end
end
if DataRange \= '' then do                      /* some shared RAM present */
  call lineout jalfile, 'pragma  shared  'DataRange
end
return DataRange                                /* range */


/* ------------------------------------------------------------- */
/* procedure to list unshared RAM (gpr) ranges from .dev file    */
/* input:  - nothing                                             */
/* returns in MaxUnsharedRam highest unshared RAM addr. in bank0 */
/* Note: Some PICs are handled 'exceptionally'                   */
/* ------------------------------------------------------------- */
list_unshared_data_range: procedure expose Lkr. jalfile MaxUnsharedRAM PicName Core
select                                          /* exceptions first */
  when PicName = '12f629'  |,                   /* have only shared RAM */
       PicName = '12f675'  |,
       PicName = '16f630'  |,
       PicName = '16f676' then do
    DataRange = '0x20-0x5D'                     /* most unshared, some shared */
    MaxUnsharedRAM = X2D(5D)                    /* bank 0 */
    end
  when PicName = '16f59' then do
    DataRange = '0x10-0x1F,0x30-0x3F,0x50-0x5F,0x70-0x7F' /* 4 bank limit! */
    MaxUnsharedRAM = X2D(1F)                    /* bank 0 */
    end
  when PicName = '16f818' then do
    DataRange = '0x20-0x3F,0xA0-0xBF'           /* unshared RAM range */
    MaxUnsharedRAM = X2D(3F)                    /* upper bound */
    end
  when PicName = '16f819' then do
    DataRange = '0x20-0x6F,0xA0-0xEF,0x120-0x16F'
    MaxUnsharedRAM = X2D(6F)                    /* bank 0 */
    end
  when PicName = '16f870'  |,
       PicName = '16f871'  |,
       PicName = '16f872'  then do
    DataRange = '0x20-0x6F,0xA0-0xBF'
    MaxUnsharedRAM = X2D(6F)                    /* bank 0 */
    end
  when PicName = '16f873'  |,
       PicName = '16f873a' |,
       PicName = '16f874'  |,
       PicName = '16f874a' then do
    DataRange = '0x20-0x7F,0xA0-0xFF'
    MaxUnsharedRAM = X2D(7F)                    /* bank 0 */
    end
otherwise                                       /* scan .lkr file */
  DataRange = ''                                /* default  */
  MaxUnsharedRAM = 0
  do i = 1 to Lkr.0
    ln = Lkr.i
    if pos('PROTECTED', ln) > 0 then            /* skip protected mem */
      iterate
    parse var ln 'DATABANK' Val0 'START' '=' '0X' val1 'END' '=' '0X' val2 .
    if val1 \= '' & val2 \= '' then do          /* both found */
      if Length(DataRange) > 50 then do         /* long string */
        call lineout jalfile, 'pragma  data    'DataRange   /* 'flush' */
        DataRange = ''                          /* reset */
      end
      if DataRange \= '' then                   /* not first range */
        DataRange = DataRange','                /* insert separator */
      val1 = strip(val1)
      val2 = strip(val2)
      if X2D(val2) > MaxUnsharedRAM then        /* new high limit */
        MaxUnSharedRAM = X2D(Val2)              /* bank 0 */
      DataRange = DataRange'0x'val1'-0x'val2    /* concatenate range */
    end
  end
end
if DataRange \= '' then
  call lineout jalfile, 'pragma  data    'DataRange
return


/* ---------------------------------------------- */
/* procedure to list Config (fuses) settings      */
/* input:  - nothing                              */
/* 12-bit and 14-bit core                         */
/* uses device specific table                     */
/* ---------------------------------------------- */
list_fuses_words1x: procedure expose jalfile CfgAddr. PicSpec. PicName
PicNameCap = toupper(PicName)
FusesDefault = PicSpec.FusesDefault.PicNameCap
if FusesDefault = '?' then do
  say PicName 'unknown for FusesDefault in devicespecific.cmd!'
  exit 1
end
call lineout jalfile, 'const word  _FUSES_CT             =' CfgAddr.0
if CfgAddr.0 = 1 then do
  call lineout jalfile, 'const word  _FUSE_BASE            = 0x'D2X(CfgAddr.1)
  call charout jalfile, 'const word  _FUSES                = 0b'
  do i = 1 to 4
    call charout jalfile, '_'X2B(substr(FusesDefault,i,1))
  end
  call lineout jalfile, ''
end
else do
  call charout jalfile, 'const word  _FUSE_BASE[_FUSES_CT] = { '
  do  j = 1 to CfgAddr.0
    call charout jalfile, '0x'D2X(CfgAddr.j)
    if j < CfgAddr.0 then
      call charout jalfile, ','
  end
  call lineout jalfile, ' }'
  call charout jalfile, 'const word  _FUSES[_FUSES_CT]     = { '
  do  j = 1 to CfgAddr.0
    call charout jalfile, '0b'
    do i = 1 to 4
      call charout jalfile, '_'X2B(substr(FusesDefault,i+4*(j-1),1,'0'))
    end
    if j < CfgAddr.0 then                           /* not last word */
      call charout jalfile, ', '
    else
      call charout jalfile, ' }'
    call lineout jalfile, '        -- CONFIG'||j
    if j < CfgAddr.0 then
      call charout jalfile, left('',38,' ')
  end
end
call lineout jalfile, '--'
return


/* ---------------------------------------------- */
/* procedure to list Config (fuses) settings      */
/* input:  - nothing                              */
/* 16-bit core                                    */
/* uses device specific table                     */
/* ---------------------------------------------- */
list_fuses_bytes16: procedure expose jalfile CfgAddr. PicSpec. PicName
PicNameCap = toupper(PicName)
FusesDefault = PicSpec.FusesDefault.PicNameCap      /* get default */
if FusesDefault = '?' then do
  say PicName 'unknown for FusesDefault in devicespecific.cmd!'
  exit 1
end
call lineout jalfile, 'const word  _FUSES_CT             =' CfgAddr.0
call charout jalfile, 'const dword _FUSE_BASE[_FUSES_CT] = { '
do  j = 1 to CfgAddr.0
  call charout jalfile, '0x'D2X(CfgAddr.j,6)
  if j < CfgAddr.0 then do
    call lineout jalfile, ','
    call charout jalfile, left('',38,' ')
  end
end
call lineout jalfile, ' }'
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
  call lineout jalfile, '        -- CONFIG'||(j+1)%2||substr('LH',1+(j//2),1)
  if j < CfgAddr.0 then
    call charout jalfile, left('',38,' ')
end
call lineout jalfile, '--'
return


/* ---------------------------------------------- */
/* procedure to list ID memory  settings          */
/* input:  - nothing                              */
/* ---------------------------------------------- */
list_IDmem: procedure expose jalfile IDaddr. Core
if IDaddr.0 > 0 then do
  call lineout jalfile, 'const word  _ID_CT                =' IDAddr.0
  if  core = 12 | core = 14 then
    call charout jalfile, 'const word  _ID_BASE[_ID_CT]      = { '
  else                                          /* 16-bits core */
    call charout jalfile, 'const dword _ID_BASE[_ID_CT]      = { '
  do  j = 1 to IDaddr.0
    if Core = 12 | Core = 14 then do
      call charout jalfile, '0x'D2X(IDaddr.j,4)  /* address */
      if j < IDaddr.0 then
        call charout jalfile, ','
    end
    else do                                     /* 16-bits core */
      call charout jalfile, '0x'D2X(IDaddr.j,6)   /* address */
      if j < IDaddr.0 then do
        call lineout jalfile, ','
        call charout jalfile, left('',38,' ')
      end
    end
  end
  call lineout jalfile, ' }'
  if Core = 12 | Core = 14 then
    call charout jalfile, 'const word  _ID[_ID_CT]           = { '
  else
    call charout jalfile, 'const byte  _ID[_ID_CT]           = { '
  do  j = 1 to IDaddr.0
    if Core = 12 | Core = 14 then
      call charout jalfile, '0x0000'              /* word */
    else
      call charout jalfile, '0x00'                /* byte */
    if j < IDaddr.0 then
      call charout jalfile, ','
  end
  call lineout jalfile, ' }'
  call lineout jalfile, '--'
end
return


/* -------------------------------------------------- */
/* procedure to list special function registers       */
/* input:  - nothing                                  */
/* Note: name is stored but not checked on duplicates */
/* 12-bit and 14-bit core                             */
/* -------------------------------------------------- */
list_sfr1x: procedure expose Dev. Ram. Name. PinMap. PicName jalfile BANKSIZE NumBanks
do i = 1 to Dev.0
  if word(Dev.i,1) \= 'SFR' then                /* skip */
    iterate
  parse var Dev.i  val0 '(KEY=' val1 ' ADDR' '=' '0X' val2 'SIZE' '=' val3 .
  if val1 \= '' then do
    reg = strip(val1)                           /* register name */
    if reg = 'SSPCON1' |,                       /* to be normalized */
       reg = 'SSPCON0' then
      reg = 'SSPCON'                            /* normalized name */
    Name.reg = reg                              /* add to collection of names */
    addr = X2D(strip(val2))                     /* decimal */
    Ram.addr = addr                             /* mark address in use */
    addr = sfr_mirror(addr)                     /* add mirror addresses */
    size = strip(val3)                          /* field size */
    if size = 1 then
      field = 'byte  '
    else if size = 2 then
      field = 'word  '
    else
      field = 'dword '
    call lineout jalfile, '-- ------------------------------------------------'
    call lineout jalfile, 'var volatile' field left(reg,25) 'at' addr
    if left(reg,4) = 'PORT' then do             /* port */
      call list_port1x_shadow reg
    end
    else if reg = 'GPIO' | reg = 'GP' then do   /* port */
      call lineout jalfile, 'var volatile byte  ' left('PORTA',25) 'at' reg
      call list_port1x_shadow 'PORTA'
    end
    else if reg = 'TRISIO' then do              /* low pincount PIC */
      call lineout jalfile, 'var volatile byte  ' left('TRISA',25) 'at' reg
      call lineout jalfile, 'var volatile byte  ' left('PORTA_direction',25) 'at' reg
      call list_tris_nibbles 'TRISA'             /* nibble direction */
    end
    else if left(reg,4) = 'TRIS' then do        /* TRISx */
      call lineout jalfile, 'var volatile byte  ',
                           left('PORT'substr(reg,5)'_direction',25) 'at' reg
      call list_tris_nibbles reg                 /* nibble direction */
    end

    call list_sfr_subfields1x i, reg            /* bit fields */

    if reg = 'PCL' |,
       reg = 'FSR' |,
       reg = 'PCLATH' then do
      reg = tolower(reg)                        /* to lower case */
      call lineout jalfile, 'var volatile byte  ' left('_'reg,25) 'at' addr,
                            '     -- (compiler)'
    end
    else if reg = 'INDF' then do
      call lineout jalfile, 'var volatile byte  ' left('_ind',25) 'at' addr,
                            '     -- (compiler)'
    end
    else if reg = 'STATUS' then do              /* status register */
      call list_status1x i, addr                /* extra for compiler */
    end
  end
end
return 0


/* ------------------------------------------------- */
/* Formatting of special function register subfields */
/* input:  - index in .dev                           */
/*         - register name                           */
/* Generates names for pins or bit fields            */
/* 12-bit and 14-bit core                            */
/* ------------------------------------------------- */
list_sfr_subfields1x: procedure expose Dev. Name. PinMap. PicName jalfile
i = arg(1) + 1                                          /* first after reg */
reg = arg(2)                                            /* register (name) */
PicUpper = toupper(picname)                             /* for alias handling */
do k = 0 to 8 while (word(Dev.i,1) \= 'SFR'  &,         /* max # of records */
                     word(Dev.i,1) \= 'NMMR')           /* other type */
  parse var Dev.i 'BIT' val0 'NAMES' '=' val1 'WIDTH' '=' val2 ')' .
  if val1 \= ''   &,                                    /* found */
     pos('SCL', val0) = 0  then do                      /* not 'scl' */
    names = strip(strip(val1), 'B', "'")                /* strip blanks */
    sizes = strip(strip(val2), 'B', "'")                /*   and quotes */
    n. = '-'                                            /* reset */
    parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
    parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
    do                                                  /* subfields */
      offset = 7                                        /* MSbit first */
      do j = 1 to 8 while offset >= 0                   /* max 8 bits */
        if n.j = '-'  |  n.j = '' then do               /* bit not used */
          offset = offset - 1
        end
        else if datatype(s.j) = 'NUM' then do           /* numeric */
          if s.j = 1 then do                            /* single bit */
            if pos('/', n.j) \= 0 then do               /* twin name */
              parse var n.j val1'/'val2 .
              if val1 \= '' then do                     /* present */
                field = reg'_'val1                      /* new name */
                if duplicate_name(field,reg) = 0 then do  /* unique */
                  call lineout jalfile, 'var volatile bit   ',
                       left(field,25) 'at' reg ':' offset
                end
              end
              if val2 \= '' then do
                field = reg'_'val2
                if duplicate_name(field,reg) = 0 then do   /* unique */
                  call lineout jalfile, 'var volatile bit   ',
                       left(field,25) 'at' reg ':' offset
                end
              end
            end
            else do                                     /* not twin name */
              field = reg'_'n.j
              if left(reg,5) = 'ANSEL'  &,              /* intercept ANSELx */
                 left(n.j,3) = 'ANS' then do
                if reg = 'ANSELH' | reg = 'ANSEL1' then
                  call lineout jalfile, 'var volatile bit   ',
                      left(JANSEL_ANS||offset+8,25) 'at' reg ':' offset
                else if reg = 'ANSELB' then
                  call lineout jalfile, 'var volatile bit   ',
                      left(JANSEL_ANS||offset+6,25) 'at' reg ':' offset
                else if reg = 'ANSELE' then
                  call lineout jalfile, 'var volatile bit   ',
                      left(JANSEL_ANS||offset+12,25) 'at' reg ':' offset
                else
                  call lineout jalfile, 'var volatile bit   ',
                      left(JANSEL_ANS||offset,25) 'at' reg ':' offset
              end
              else if duplicate_name(field,reg) = 0 then     /* unique */
                call lineout jalfile, 'var volatile bit   ',
                               left(field,25) 'at' reg ':' offset
              if reg = 'INTCON' then do
                if left(n.j,2) = 'T0' then
                  call lineout jalfile, 'var volatile bit   ',
                           left(reg'_TMR0'||substr(n.j,3),25) 'at' reg ':' offset
                end
              else if left(reg,4) = 'PORT' then do
                if left(n.j,1) = 'R'  &,
                    substr(n.j,2,1) = right(reg,1) then do  /* prob. I/O pin */
                  shadow = '_PORT'right(reg,1)'_shadow'
                  pin = 'pin_'||substr(n.j,2)
                  call lineout jalfile, 'var volatile bit   ',
                                        left(pin,25) 'at' reg ':' offset
/* alias */       call insert_pin_alias reg, n.j, pin
                  call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                 'at' shadow ':' offset') is'
                  call lineout jalfile, '   pragma inline'
                  call lineout jalfile, '   _PORT'substr(reg,5)'_flush()'
                  call lineout jalfile, 'end procedure'
                  call lineout jalfile, '--'
                end
              end
              else if reg = 'GPIO' | reg = 'GP' then do
                shadow = '_PORTA_shadow'
                pin = 'pin_A'right(n.j,1)
                call lineout jalfile, 'var volatile bit   ',
                                     left(pin,25) 'at' reg ':' offset
/* alias */     call insert_pin_alias 'PORTA', 'RA'right(n.j,1), pin
                call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                 'at' shadow ':' offset') is'
                call lineout jalfile, '   pragma inline'
                call lineout jalfile, '   _PORTA_flush()'
                call lineout jalfile, 'end procedure'
                call lineout jalfile, '--'
              end
              else if reg = 'TRISIO' then do
                call lineout jalfile, 'var volatile bit   ',
                    left('TRISA'right(n.j,1),25) 'at' reg ':' offset
                pin = 'pin_A'substr(n.j,7)'_direction'
                call lineout jalfile, 'var volatile bit   ' left(pin,25) 'at' reg ':' offset
/* alias */     call insert_pin_dir_alias 'TRISA', 'RA'substr(n.j,7), pin
              end
              else if left(reg,4) = 'TRIS' then do
                if left(n.j,4) = 'TRIS' then do
                  pin = 'pin_'substr(n.j,5)'_direction'
                  call lineout jalfile, 'var volatile bit   ',
                     left('pin_'substr(n.j,5)'_direction',25) 'at' reg ':' offset
/* alias */       call insert_pin_dir_alias reg, 'R'substr(n.j,5), pin
                end
              end
              else if left(reg,5) = 'ADCON'  &,         /* ADCON0/1 */
                      pos('VCFG',field) > 0  then do    /* VCFG field */
                p = j - 1                               /* previous bit */
                if right(n.j,5) = 'VCFG0' & right(n.p,5) = 'VCFG1' then
                  call lineout jalfile, 'var volatile bit*2 ',
                       left(left(field,length(field)-1),25) 'at' reg ':' offset
              end
              else if left(reg,5) = 'ADCON'  &,         /* ADCON0/1 */
                      n.j = 'CHS3'  then do             /* 'loose' 4th bit */
                if  Name.ADCON0_CHS012 = '-' then       /* partner field not present */
                  say 'Warning: ADCONx_CHS3 bit without previous ADCONx_CHS012 field declaration'
                else do
                  call lineout jalfile, 'procedure' reg'_CHS'"'put"'(byte in x) is'
                  call lineout jalfile, '   pragma inline'
                  call lineout jalfile, '   'reg'_CHS012 = x         -- low order bits'
                  call lineout jalfile, '   'reg'_CHS3 = 0'
                  call lineout jalfile, '   if ((x & 0x08) != 0) then'
                  call lineout jalfile, '      'reg'_CHS3 = 1        -- high order bit'
                  call lineout jalfile, '   end if'
                  call lineout jalfile, 'end procedure'
                end
              end
            end
            offset = offset - 1                         /* next bit */
          end
          else if s.j <= 8 then do                      /* multi-bit subfield */
            field = reg'_'n.j
            if field = 'OSCCON_IOSCF' then              /* wrong name */
              field = 'OSCCON_IRCF'                     /* datasheet name */
            else if field = 'OSCCON_IRFC' then          /* wrong name */
              field = 'OSCCON_IRCF'                     /* datasheet name */
            if duplicate_name(field,reg) = 0 then do    /* unique */
              if left(reg,5) = 'ADCON'  &,              /* ADCON0/1 */
                 pos('VCFG',field) > 0  then do         /* multibit VCFG field */
                call lineout jalfile, 'var volatile bit   ',
                      left(field'1',25) 'at' reg ':' offset - 0
                call lineout jalfile, 'var volatile bit   ',
                      left(field'0',25) 'at' reg ':' offset - 1
                call lineout jalfile, 'var volatile bit*'s.j' ',
                      left(field,25) 'at' reg ':' offset - s.j + 1
              end
              else if left(reg,5) = 'ADCON'  &,         /* ADCON0/1 */
                      n.j = 'CHS'            &,         /* (multibit) CHS field */
                      pos('CHS3',Dev.i) > 0  then do    /* 'loose' 4th bit present */
                field = field'012'                      /* rename! */
                if duplicate_name(field,reg) = 0 then      /* renamed subfield */
                  call lineout jalfile, 'var volatile bit*'s.j' ',
                      left(field,25) 'at' reg ':' offset - s.j + 1
              end
              else if (left(n.j,3) = 'ANS')   &,        /* ANS subfield */
                 (left(reg,5) = 'ADCON'  |,             /* ADCON* reg */
                  left(reg,5) = 'ANSEL')    then do     /* ANSELx reg */
                k = s.j - 1
                do while k >= 0
                  if reg = 'ANSELH' then
                    call lineout jalfile, 'var volatile bit   ',
                        left(JANSEL_ANS||k+8 ,25) 'at' reg ':' offset + k + 1 - s.j
                  else if reg = 'ANSELE' then
                    call lineout jalfile, 'var volatile bit   ',
                        left(JANSEL_ANS||k+20,25) 'at' reg ':' offset + k + 1 - s.j
                  else if reg = 'ANSELD' then
                    call lineout jalfile, 'var volatile bit   ',
                        left(JANSEL_ANS||k+12,25) 'at' reg ':' offset + k + 1 - s.j
                  else if reg = 'ANSELB' then
                    call lineout jalfile, 'var volatile bit   ',
                        left(JANSEL_ANS||k+6 ,25) 'at' reg ':' offset + k + 1 - s.j
                  else
                    call lineout jalfile, 'var volatile bit   ',
                        left(JANSEL_ANS||k   ,25) 'at' reg ':' offset + k + 1 - s.j
                  k = k - 1
                end
              end
              else                                      /* other */
                if \(s.j = 8  &  n.j = reg) then        /* subfield not alias of reg */
                  call lineout jalfile, 'var volatile bit*'s.j' ',
                            left(field,25) 'at' reg ':' offset - s.j + 1
            end
            offset = offset - s.j
          end
        end
      end
    end
  end
  i = i + 1                                     /* next record */
end
return 0


/* -------------------------------------------------------- */
/* procedure to list special function registers             */
/* input:  - nothing                                        */
/* Note: - name is stored but not checked on duplicates     */
/* 16-bit core                                              */
/* -------------------------------------------------------  */
list_sfr16: procedure expose Dev. Ram. Name. PinMap. jalfile,
            BANKSIZE NumBanks PicName AccessBankSplitOffset
do i = 1 to Dev.0
  if word(Dev.i,1) \= 'SFR' then
    iterate
  parse var Dev.i  val0 '(KEY=' val1 ' ADDR' '=' '0X' val2 'SIZE' '=' val3 .
  if val1 \= '' then do
    reg = strip(val1)                           /* register name */
    if left(reg,3) = 'SSP' then                 /* MSSP register */
      reg = normalize_ssp16(reg)                /* possibly to be renamed */
    Name.reg = reg                              /* remember name */
    addr = strip(val2)
    k = X2D(addr)                               /* address decimal */
    size = strip(val3)                          /* # bytes */
    if size = 1 then                            /* single byte */
      field = 'byte  '
    else if size = 2 then                       /* two bytes */
      field = 'word  '
    else                                        /* three bytes */
      field = 'byte*3'
    Ram.k = k                                   /* mark in use */
    call lineout jalfile, '-- ------------------------------------------------'
    if  k < AccessBankSplitOffset + X2D('F00') then do
      memtype = '      '                        /* in non shared memory */
 /*   say 'SFR below AccessBankSplitOffset (0xF'D2X(AccessbankSplitOffset)'): 0x'addr   */
    end
    else
      memtype = 'shared'                        /* in shared memory */
    call lineout jalfile, 'var volatile' field left(reg,25) memtype 'at 0x'addr

    if left(reg,3) = 'LAT' then do              /* LATx register */
      call list_port16_shadow reg               /* force use of LATx */
                                                /* for output to PORTx */
    end
    else if left(reg,4) = 'TRIS' then do        /* TRISx */
      call lineout jalfile, 'var volatile byte  ',
             left('PORT'substr(reg,5)'_direction',25) 'shared at' reg
      call list_tris_nibbles reg                 /* nibble directions */
    end

    call list_sfr_subfields16 i, reg, memtype   /* bit fields */

    if  reg = 'FSR0'   |,
        reg = 'FSR0L'  |,
        reg = 'FSR0H'  |,
        reg = 'PCL'    |,
        reg = 'PCLATH' |,
        reg = 'PCLATU' |,
        reg = 'TABLAT' |,
        reg = 'TBLPTR'    then do
      reg = tolower(reg)                        /* to lower case */
      call lineout jalfile, 'var volatile' field left('_'reg,25),
                            'shared at 0x'addr '     -- (compiler)'
    end
    else if  reg = 'INDF0'  then do
      call lineout jalfile, 'var volatile' field left('_ind0',25),
                            'shared at 0x'addr '     -- (compiler)'
    end
    else if reg = 'STATUS' then do              /* status register */
      call list_status16 i, addr                /* extra for compiler */
    end
  end
end
return 0


/* -------------------------------------------------------- */
/* procedure to normalize MSSP register names               */
/* input: - register name                                   */
/* 16-bit core                                              */
/* -------------------------------------------------------  */
normalize_ssp16:
select
  when reg = 'SSPADD' then
    reg = 'SSP1ADD'
  when reg = 'SSP1CON1' |,
       reg = 'SSPCON1'  |,
       reg = 'SSPCON'   then
    reg = 'SSP1CON'
  when reg = 'SSPCON2'  then
    reg = 'SSP1CON2'
  when reg = 'SSPMSK'   |,
       reg = 'SSPMASK'  then
    reg = 'SSP1MSK'
  when reg = 'SSPSTAT'  then
    reg = 'SSP1STAT'
  when reg = 'SSPBUF'   then
    reg = 'SSP1BUF'
  when reg = 'SSP2CON1' then                    /* second MSSP modle */
    reg = 'SSP2CON'
  otherwise
    nop
end
return  reg                                     /* return normalized name */

/* --------------------------------------- */
/* Formatting of special function register */
/* input:  - index in .dev                 */
/*         - register name                 */
/* Generates names for pins or bit fields  */
/* 16-bit core                             */
/* --------------------------------------- */
list_sfr_subfields16: procedure expose Dev. Name. PinMap. PicName jalfile
i = arg(1) + 1                                          /* 1st after reg */
reg = arg(2)                                            /* register (name) */
memtype = arg(3)                                        /* shared/blank */
do k = 0 to 8 while (word(Dev.i,1) \= 'SFR'   &,        /* max # of records */
                     word(Dev.i,1) \= 'NMMR')           /* other register */
  parse var Dev.i 'BIT' val0 'NAMES=' val1 'WIDTH=' val2 ')' .
  if val1 \= ''  &,                                     /* found */
     pos('SCL', val0) = 0  &,                           /* not 'scl' */
     word(Dev.i,1) \= 'QBIT' then do                    /* not 'qbit' */
    names = strip(strip(val1), 'B', "'")                /* strip blanks .. */
    sizes = strip(strip(val2), 'B', "'")                /* .. and quotes */
    parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
    parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
    do                                                  /* sub-div of reg */
      offset = 7                                        /* MSbit first */
      do j = 1 to 8 while offset >= 0                   /* 8 bits */
        if n.j = '-' then do                            /* bit not used */
          offset = offset - 1
        end
        else if datatype(s.j) = 'NUM' then do           /* numeric */
          if s.j = 1 then do                            /* single bit */
            if pos('/', n.j) \= 0 then do               /* twin name */
              parse var n.j val1'/'val2 .
              if val1 \= '' then do
                field = reg'_'val1
                if duplicate_name(field,reg) = 0 then do  /* unique */
                  call lineout jalfile, 'var volatile bit   ',
                       left(field,25) memtype 'at' reg ':' offset
                end
              end
              if val2 \= '' then do
                field = reg'_'val2
                if duplicate_name(field,reg) = 0 then do  /* unique */
                  call lineout jalfile, 'var volatile bit   ',
                       left(field,25) memtype 'at' reg ':' offset
                end
              end
            end
            else do                                     /* not twin name */
              field = reg'_'n.j
              if left(reg,5) = 'ANSEL'  &,              /* intercept ANSELx */
                 left(n.j,3) = 'ANS' then do
                if reg = 'ANSELH' then
                  call lineout jalfile, 'var volatile bit   ',
                      left(JANSEL_ANS||offset+8,25) 'at' reg ':' offset
                else
                  call lineout jalfile, 'var volatile bit   ',
                      left(JANSEL_ANS||offset,25) 'at' reg ':' offset
              end
              else if duplicate_name(field,reg) = 0 then     /* unique */
                call lineout jalfile, 'var volatile bit   ',
                     left(field,25) memtype 'at' reg ':' offset
              if reg = 'INTCON' then do
                if left(n.j,2) = 'T0' then
                  call lineout jalfile, 'var volatile bit   ',
                           left(reg'_TMR0'||substr(n.j,3),25) memtype 'at' reg ':' offset
              end
              else if left(reg,3) = 'LAT' then do       /* LATx register */
                if left(n.j,3) = 'LAT'   &,
                    substr(n.j,4,1) = right(reg,1) then do     /* I/O pin */
                  pin = 'pin_'||substr(n.j,4)
                  call lineout jalfile, 'var volatile bit   ',
                           left(pin,25) memtype 'at PORT'substr(reg,4) ':' offset
/* alias */       call insert_pin_alias 'PORT'substr(reg,4), 'R'substr(n.j,4), pin
                  call lineout jalfile, 'procedure' pin"'put"'(bit in x',
                                                   'at' reg ':' offset') is'
                  call lineout jalfile, '   pragma inline'
                  call lineout jalfile, 'end procedure'
                  call lineout jalfile, '--'
                end
              end
              else if left(reg,4) = 'TRIS' then do
                pin = 'pin_'||substr(n.j,5)'_direction'
                if  left(n.j,4) = 'TRIS' then do        /* only TRIS bits */
                  call lineout jalfile, 'var volatile bit   ',
                               left(pin,25) memtype 'at' reg ':' offset
/* alias */       call insert_pin_dir_alias 'PORT'substr(reg,5), 'R'substr(n.j,5), pin
                end
              end
              else if left(reg,5) = 'ADCON'  &,         /* ADCON0/1 */
                      pos('VCFG',field) > 0  then do    /* VCFG field */
                p = j - 1                               /* previous bit */
                if right(n.j,5) = 'VCFG0' & right(n.p,5) = 'VCFG1' then
                  call lineout jalfile, 'var volatile bit*2 ',
                       left(left(field,length(field)-1),25) memtype 'at' reg ':' offset
              end
            end
            offset = offset - 1                         /* next offset */
          end
          else if s.j <= 8 then do                      /* multi bit field */
            field = reg'_'n.j
            if field \= reg then do                     /* not reg alias */
              if duplicate_name(field,reg) = 0 then do  /* unique */
                if left(reg,5) = 'ADCON'  &,            /* ADCON0/1 */
                   pos('VCFG',field) > 0  &,            /* VCFG field */
                   s.j > 1                then do       /* multibit */
                  call lineout jalfile, 'var volatile bit   ',
                        left(field'1',25) memtype 'at' reg ':' offset - 0
                  call lineout jalfile, 'var volatile bit   ',
                        left(field'0',25) memtype 'at' reg ':' offset - 1
                  call lineout jalfile, 'var volatile bit*'s.j' ',
                        left(field,25) memtype 'at' reg ':' offset - s.j + 1
                end
                else if (left(n.j,3) = 'ANS')   &,        /* ANS subfield */
                   (left(reg,5) = 'ADCON'  |,             /* ADCON* reg */
                    left(reg,5) = 'ANSEL')    then do     /* ANSELx reg */
                  k = s.j - 1
                  do while k >= 0
                    if reg = 'ANSELH' then
                      call lineout jalfile, 'var volatile bit   ',
                          left(JANSEL_ANS||k+8 ,25) 'at' reg ':' offset + k + 1 - s.j
                    else
                      call lineout jalfile, 'var volatile bit   ',
                          left(JANSEL_ANS||k   ,25) 'at' reg ':' offset + k + 1 - s.j
                    k = k - 1
                  end
                end
                else
                  if \(s.j = 8  &  n.j = reg) then      /* subfield not alias of reg */
                    call lineout jalfile, 'var volatile bit*'s.j' ',
                               left(field,25) memtype 'at' reg ':' offset - s.j + 1
              end
            end
            offset = offset - s.j                       /* next offset */
          end
        end
      end
    end
  end
  i = i + 1                                             /* next record */
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
list_nmmr12: procedure expose Dev. Ram. Name. PinMap. PicName jalfile BANKSIZE NumBanks
do i = 1 to Dev.0
  if word(Dev.i,1) \= 'NMMR' then                       /* not 'nmmr' */
    iterate                                             /* skip */
  parse var Dev.i  val0 '(KEY=' val1 ' ADDR' '=' '0X' val2 'SIZE' '=' val3 .
  if val1 \= '' then do                                 /* found! */
    reg = strip(val1)                                   /* register name */

    if left(reg,4) = 'TRIS' then do                     /* handle TRISxx */
      Name.reg = reg                                    /* add to collection of names */
      call lineout jalfile, '-- ------------------------------------------------'
      portletter = substr(reg,5)
      if portletter = 'IO'  |  portletter = '' then     /* TRISIO */
        portletter = 'A'                                /* handle it as TRISA */
      shadow = '_TRIS'portletter'_shadow'
      call lineout jalfile, 'var  byte' shadow '= 0b1111_1111         -- default all input'
      call lineout jalfile, '--'
      call lineout jalfile, 'procedure PORT'portletter"_direction'put(byte in x) is"
      call lineout jalfile, '   pragma inline'
      call lineout jalfile, '   'shadow '= x'
      call lineout jalfile, '   asm movf' shadow',W'
      if reg = 'TRISIO' then                            /* TRISIO (small PIC) */
        call lineout jalfile, '   asm tris 6'
      else                                              /* TRISx */
        call lineout jalfile, '   asm tris' 5 + C2D(portletter) - C2D('A')
      call lineout jalfile, 'end procedure'
      call lineout jalfile, '--'
      half = 'PORT'portletter'_low_direction'
      call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
      call lineout jalfile, '   'shadow '= ('shadow '& 0xF0) | (x & 0x0F)'
      call lineout jalfile, '   asm movf _TRIS'portletter'_shadow,W'
      if reg = 'TRISIO' then                            /* TRISIO (small PICs) */
        call lineout jalfile, '   asm tris 6'
      else                                              /* TRISx */
        call lineout jalfile, '   asm tris' 5 + C2D(portletter) - C2D('A')
      call lineout jalfile, 'end procedure'
      call lineout jalfile, '--'
      half = 'PORT'portletter'_high_direction'
      call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
      call lineout jalfile, '   'shadow '= ('shadow '& 0x0F) | (x << 4)'
      call lineout jalfile, '   asm movf _TRIS'portletter'_shadow,W'
      if reg = 'TRISIO' then                            /* TRISIO (small PICs) */
        call lineout jalfile, '   asm tris 6'
      else                                              /* TRISx */
        call lineout jalfile, '   asm tris' 5 + C2D(portletter) - C2D('A')
      call lineout jalfile, 'end procedure'
      call lineout jalfile, '--'
      call list_nmmr_sub_tris_12 i, reg                 /* individual TRIS bits */
    end

    else if reg = 'OPTION_REG' | reg = OPTION2 then do  /* option */
      Name.reg = reg                                    /* add to collection of names */
      shadow = '_'reg'_shadow'
      call lineout jalfile, '-- ------------------------------------------------'
      call lineout jalfile, 'var  byte' shadow '= 0b1111_1111         -- default all set'
      call lineout jalfile, '--'
      call lineout jalfile, 'procedure' reg"'put(byte in x) is"
      call lineout jalfile, '   pragma inline'
      call lineout jalfile, '   'shadow '= x'
      call lineout jalfile, '   asm movf' shadow',0'
      if reg = 'OPTION_REG' then                        /* OPTION_REG */
        call lineout jalfile, '   asm option'
      else                                              /* OPTION2 */
        call lineout jalfile, '   asm tris 7'
      call lineout jalfile, 'end procedure'
      call list_nmmr_sub_option_12 i, reg               /* subfields */
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
list_nmmr_sub_tris_12: procedure expose Dev. Name. PinMap. PicName jalfile
i = arg(1) + 1                                          /* 1st after reg */
reg = arg(2)                                            /* register (name) */
do k = 0 to 3 while (word(Dev.i,1) \= 'SFR'   &,        /* max # of records */
                     word(Dev.i,1) \= 'NMMR')           /* other register */
  parse var Dev.i 'BIT' val0 'NAMES=' val1 'WIDTH=' val2 ')' .
  if val1 \= '' then do                                 /* found */
    names = strip(strip(val1), 'B', "'")                /* strip blanks .. */
    parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
    portletter = substr(reg,5)
    if portletter = 'IO' then                           /* TRISIO */
      portletter = 'A'                                  /* handle as TRISA */
    shadow = '_TRIS'portletter'_shadow'
    offset = 7                                          /* MSbit first */
    do j = 1 to 8 while offset >= 0                     /* max 8 bits */
      if n.j \= '-' then do
        call lineout jalfile, 'procedure pin_'portletter||offset"_direction'put(bit in x",
                                                  'at' shadow ':' offset') is'
        call lineout jalfile, '   pragma inline'
        call lineout jalfile, '   asm movf _TRIS'portletter'_shadow,W'
        if reg = 'TRISIO' then                          /* TRISIO */
          call lineout jalfile, '   asm tris 6'
        else                                            /* TRISx */
          call lineout jalfile, '   asm tris' 5 + C2D(portletter) - C2D('A')
        call lineout jalfile, 'end procedure'
/* alias */  call insert_pin_dir_alias reg, 'R'portletter||right(n.j,1),,
                              'pin_'portletter||right(n.j,1)'_direction'
        call lineout jalfile, '--'
      end
      offset = offset - 1
    end
  end
  i = i + 1                                             /* next record */
end
return 0


/* ------------------------------------------------- */
/* Formatting of non memory mapped registers:        */
/* OPTION_REG and OPTION2                            */
/* input:  - index in .dev                           */
/*         - register name                           */
/* Generates names for pins or bits                  */
/* 12-bit and 14-bit core                            */
/* ------------------------------------------------- */
list_nmmr_sub_option_12: procedure expose Dev. Name. PinMap. PicName jalfile
i = arg(1) + 1                                          /* first after reg */
reg = arg(2)                                            /* register (name) */
do k = 0 to 8 while (word(Dev.i,1) \= 'SFR'  &,         /* max # of records */
                     word(Dev.i,1) \= 'NMMR')           /* other type */
  parse var Dev.i 'BIT' val0 'NAMES' '=' val1 'WIDTH' '=' val2 ')' .
  if val1 \= '' then do                                 /* found */
    names = strip(strip(val1), 'B', "'")                /* strip blanks */
    sizes = strip(strip(val2), 'B', "'")                /*   and quotes */
    n. = '-'                                            /* reset */
    parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
    parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
    shadow = '_'reg'_shadow'
    offset = 7                                          /* MSbit first */
    do j = 1 to 8 while offset >= 0                     /* max 8 bits */
      if n.j \= '-' & n.j \= '' then do                 /* bit(s) in use */
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
      end
      offset = offset - s.j
    end
  end
  i = i + 1                                             /* next record */
end
return 0


/* -------------------------------------------------------- */
/* procedure to list non memory mapped registers            */
/* input:  - nothing                                        */
/* Note: - name is stored but not checked on duplicates     */
/*       - for NMMR registers pseudo variables are declared */
/* 16-bit core                                              */
/* -------------------------------------------------------  */
list_nmmr16: procedure expose Dev. Ram. Name. jalfile BANKSIZE NumBanks
do i = 1 to Dev.0
  if word(Dev.i,1) \= 'NMMR' then
    iterate
  if pos('ANCON',Dev.i) = 0 then                /* only ANCONx handled at this moment */
    iterate
  parse var Dev.i 'NMMR' '(KEY=' val1 'MAPADDR=0X' val2 ' ADDR=0X' val0 'SIZE=' val3 .
  if val1 \= '' then do
    reg = strip(val1)                           /* register name */
    Name.reg = reg                              /* remember */
    shadow = '_'reg'_shadow'                    /* its shadow */
    addr = strip(val2)                          /* (mapped) address */
    size = strip(val3)                          /* # bytes */
    call lineout jalfile, '-- ------------------------------------------------'
    call lineout jalfile, 'var volatile byte  ' left(reg,25) 'shared at 0x'addr
    call lineout jalfile, '--'
    call lineout jalfile, 'var          byte  ' shadow '       = 0b1111_1111'
    call lineout jalfile, '--'
    call lineout jalfile, 'procedure _'reg'_flush() is'
    call lineout jalfile, '   pragma inline'
    call lineout jalfile, '   WDTCON_ADSHR = TRUE        -- map register'
    call lineout jalfile, '   'reg '=' shadow
    call lineout jalfile, '   WDTCON_ADSHR = FALSE       -- unmap register'
    call lineout jalfile, 'end procedure'
    call lineout jalfile, '--'
    call lineout jalfile, 'procedure' reg"'put"'(byte in x) is'
    call lineout jalfile, '   pragma inline'
    call lineout jalfile, '   'shadow '= x'
    call lineout jalfile, '   _'reg'_flush()'
    call lineout jalfile, 'end procedure'
    call lineout jalfile, '--'

/*  subfields to be handled? */

  end
end
return 0


/* ---------------------------------------------- */
/* procedure to create port shadowing functions   */
/* for full byte, lower- and upper-nibbles        */
/* For 12- and 14-bit core                        */
/* input:  - Port register                        */
/* ---------------------------------------------- */
list_port1x_shadow: procedure expose jalfile
reg = arg(1)
shadow = '_PORT'substr(reg,5)'_shadow'
call lineout jalfile, '--'
call lineout jalfile, 'var          byte ' shadow '       = 'reg
call lineout jalfile, '--'
call lineout jalfile, 'procedure _PORT'substr(reg,5)'_flush() is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   'reg '=' shadow
call lineout jalfile, 'end procedure'
call lineout jalfile, 'procedure' reg"'put"'(byte in x) is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   'shadow '= x'
call lineout jalfile, '   _PORT'substr(reg,5)'_flush()'
call lineout jalfile, 'end procedure'
call lineout jalfile, '--'
half = 'PORT'substr(reg,5)'_low'
/* call lineout jalfile, 'var  byte' half */
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   'shadow '= ('shadow '& 0xF0) | (x & 0x0F)'
call lineout jalfile, '   _PORT'substr(reg,5)'_flush()'
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   return ('reg '& 0x0F)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
half = 'PORT'substr(reg,5)'_high'
/* call lineout jalfile, 'var  byte' half */
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   'shadow '= ('shadow '& 0x0F) | (x << 4)'
call lineout jalfile, '   _PORT'substr(reg,5)'_flush()'
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
lat  = arg(1)                                   /* LATx register */
port = 'PORT'substr(lat,4)                      /* corresponding port */
call lineout jalfile, '--'
call lineout jalfile, 'procedure' port"'put"'(byte in x) is'
call lineout jalfile, '   pragma inline'
call lineout jalfile, '   'lat '= x'
call lineout jalfile, 'end procedure'
call lineout jalfile, '--'
half = 'PORT'substr(lat,4)'_low'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   'lat '= ('port '& 0xF0) | (x & 0x0F)'
call lineout jalfile, 'end procedure'
call lineout jalfile, 'function' half"'get()" 'return byte is'
call lineout jalfile, '   return ('port '& 0x0F)'
call lineout jalfile, 'end function'
call lineout jalfile, '--'
half = 'PORT'substr(lat,4)'_high'
call lineout jalfile, 'procedure' half"'put"'(byte in x) is'
call lineout jalfile, '   'lat '= ('port '& 0x0F) | (x << 4)'
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
reg = arg(1)
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


/* -------------------------------------------------------- */
/* procedure to add pin alias declarations                  */
/* input:  - register name                                  */
/*         - original pin name (Rx)                         */
/*         - pinname for aliases (pin_Xy)                   */
/* -------------------------------------------------------- */
insert_pin_alias: procedure expose  PinMap. Name. PicName jalfile
PicUpper = toupper(PicName)
reg     = arg(1)
PinName = arg(2)
Pin     = arg(3)
/* Say 'insert_pin_alias for reg' reg 'alias' PinName 'for pin' pin */
if PinMap.PicUpper.PinName.0 = '?' then do
  Say 'Warning: PinMap.'PicUpper'.'PinName 'is undefined'
  return
end
if PinMap.PicUpper.PinName.0 > 0 then do
  do k = 1 while k <= PinMap.PicUpper.PinName.0     /* all aliases */
    pinalias = 'pin_'PinMap.PicUpper.PinName.k
    if duplicate_name(pinalias,reg) = 0 then do     /* unique */
      call lineout jalfile, 'var volatile bit   ' left(pinalias,25) 'is' Pin
    end
  end
end
call lineout jalfile, '--'                          /* separator */
return k


/* -------------------------------------------------------- */
/* procedure to add pin_direction alias declarations        */
/* input:  - register name                                  */
/*         - original pin name (Rx)                         */
/*         - pinname for aliases (pin_Xy)                   */
/* note: '_direction' is added                              */
/* -------------------------------------------------------- */
insert_pin_dir_alias: procedure expose  PinMap. Name. PicName jalfile
PicUpper = toupper(PicName)
reg     = arg(1)
PinName = arg(2)
Pin     = arg(3)
/* Say 'insert_pin_dir_alias for reg' reg 'alias' PinName 'for pin' pin */
if PinMap.PicUpper.PinName.0 = '?' then do
  Say 'Warning: PinMap.'PicUpper'.'PinName 'is undefined'
  return
end
if PinMap.PicUpper.PinName.0 > 0 then do
  do k = 1 while k <= PinMap.PicUpper.PinName.0     /* all aliases */
    pinalias = 'pin_'PinMap.PicUpper.PinName.k'_direction'
    if duplicate_name(pinalias,reg) = 0 then do     /* unique */
      call lineout jalfile, 'var volatile bit   ' left(pinalias,25) 'is' pin
    end
  end
end
call lineout jalfile, '--'                          /* separator */
return k


/* -------------------------------------------------------- */
/* Special _extra_ formatting of STATUS register            */
/* input:  - index in .dev                                  */
/*         - register name (Status)                         */
/* remark: Is extra set of definitions for compiler only.   */
/*         Not intended for use by application programs.    */
/* 12-bit and 14-bit core                                   */
/* -------------------------------------------------------- */
list_status1x: procedure expose Dev. jalfile
i = arg(1) + 1                                  /* just after register */
reg = arg(2)                                    /* register (name) */
call lineout jalfile, 'var volatile byte ' left('_status',25) 'at' reg,
                            '     -- (compiler)'
do k = 0 to 4 while word(Dev.i, 1) \= 'SFR'     /* max 4 records */
  parse var Dev.i 'BIT' val0 'NAMES=' val1 'WIDTH=' val2 ')' .
  if val1 \= '' then do
    names = strip(strip(val1), 'B', "'")        /* strip blanks */
    sizes = strip(strip(val2), 'B', "'")        /* .. and quotes */
    parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
    parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
    offset = 7                                  /* MSbit */
    do i = 1 to 8                               /* all individual bits */
      if n.i = '-' then do                      /* bit not present */
        offset = offset - 1
      end
      else if datatype(s.i) = 'NUM' then do     /* field size */
        if s.i = 1 then do                      /* single bit */
          n.i = tolower(n.i)                    /* to lower case */
          if n.i = 'nto' then do
            call lineout jalfile, 'const        byte ',
                    left('_not_to',25) '= ' offset '     -- (compiler)'
          end
          else if n.i = 'npd' then do
            call lineout jalfile, 'const        byte ',
                    left('_not_pd',25) '= ' offset '     -- (compiler)'
          end
          else do
            call lineout jalfile, 'const        byte ',
                    left('_'n.i,25) '= ' offset '     -- (compiler)'
          end
          offset = offset - 1                   /* next bit */
        end
        else do j = s.i - 1  to  0  by  -1      /* enumerate */
          call lineout jalfile, 'const        byte ',
                  left('_'n.i||j,25) '= ' offset '     -- (compiler)'
          offset = offset - 1
        end
      end
    end
  end
  i = i + 1                                     /* next record */
end
return


/* -------------------------------------------------------- */
/* Special _extra_ formatting of STATUS register            */
/* input:  - index in .dev                                  */
/*         - register name (STATUS)                         */
/* remark: Is extra set of definitions for compiler only.   */
/*         Not intended for use by application programs.    */
/* 16-bit core                                              */
/* -------------------------------------------------------- */
list_status16: procedure expose Dev. jalfile
i = arg(1) + 1                                  /* just after register */
addr = arg(2)                                   /* register */
call lineout jalfile, 'var volatile byte  ' left('_status',25),
                                    'shared at 0x'addr '     -- (compiler)'
do k = 0 to 4 while word(Dev.i, 1) \= 'SFR'     /* max 4 records */
  parse var Dev.i 'BIT' val0 'NAMES=' val1 'WIDTH=' val2 ')' .
  if val1 \= '' then do
    names = strip(strip(val1), 'B', "'")        /* strip blanks */
    sizes = strip(strip(val2), 'B', "'")        /* .. and quotes */
    parse  var names n.1 n.2 n.3 n.4 n.5 n.6 n.7 n.8 .
    parse  var sizes s.1 s.2 s.3 s.4 s.5 s.6 s.7 s.8 .
    offset = 7                                  /* MSbit */
    do i = 1 to 8 while offset >= 0             /* all individual bits */
      if n.i = '-' then do                      /* bit not present */
        offset = offset - 1                     /* skip */
      end
      else if datatype(s.i) = 'NUM' then do     /* field size */
        n.i = tolower(n.i)                      /* to lowercase */
        call lineout jalfile, 'const        byte  ',
                    left('_'n.i,25) '= ' offset '     -- (compiler)'
        offset = offset - 1                     /* next bit */
      end
    end
  end
  i = i + 1                                     /* next record */
end
call lineout jalfile, 'const        byte  ' left('_banked',25) '=  1',
                              '     -- (compiler - use BSR)'
call lineout jalfile, 'const        byte  ' left('_access',25) '=  0',
                              '     -- (compiler - use ACCESS)'
return


/* ---------------------------------------------------------------------- */
/* Formatting of configuration bits                                       */
/* input:  - nothing                                                      */
/* Note:  some fuse_defs are omitted because the bits is not supported,   */
/*        even if it is (partly) specified in the .dev file.              */
/*        See at the bottom of changes.txt for details.                   */
/* ---------------------------------------------------------------------- */
list_fuses_bits:   procedure expose Dev. jalfile CfgAddr. Fuse_Def. Core PicName
call lineout jalfile, '--'
call lineout jalfile, '-- =================================================='
call lineout jalfile, '--'
call lineout jalfile, '-- Symbolic Fuse definitions'
call lineout jalfile, '-- -------------------------'
k = 0                                           /* config word count */
do i = 1 to dev.0                               /* scan .dev file */
  if word(Dev.i,1) \= 'CFGBITS' then            /* appropriate record */
    iterate
  ln = Dev.i
  parse var ln 'CFGBITS' val0 ' ADDR' '=' '0X' val1 'UNUSED' '=' '0X' val2 ')' .
  if val1 \= '' then do                         /* address found */
    k = k + 1                                   /* count fuse words */
    addr = strip(val1)                          /* hex addr */
    call lineout jalfile, '--'
    call lineout jalfile, '-- addr 0x'addr
    call lineout jalfile, '--'
    i = i + 1                                   /* next record */
    ln = dev.i                                  /* next line */
    do while i <= dev.0  &  word(ln, 1) \= 'CFGBITS'
      parse var ln 'FIELD' val0 'KEY=' val1 'MASK' '=' '0X' val2 .
      if val1 \= '' then do                     /* field found */
        key = strip(val1)
        if pos('RESERVED',key) > 0 then do      /* skip */
          i = i + 1
          ln = Dev.i
          iterate                               /* to next key */
        end
        if pos('ENICPORT',key) > 0 then do      /* ignore */
          i = i + 1
          ln = Dev.i
          say 'Warning: fuse_def suppressed for' key 'of' PicName
          iterate                               /* to next key */
        end
        if (key = 'CPD' | key = 'WRTD')  &,
           (PicName = '18f2410' | PicName = '18f2510' |,
            PicName = '18f2515' | PicName = '18f2610' |,
            PicName = '18f4410' | PicName = '18f4510' |,
            PicName = '18f4515' | PicName = '18f4610')  then do
          i = i + 1
          ln = Dev.i
          say 'Warning: fuse_def suppressed for' key 'of' PicName
          iterate                               /* to next key */
        end
        if (key = 'EBTR_3' | key = 'CP_3' | key = 'WRT_3') &,
           (PicName = '18f4585') then do
          i = i + 1
          ln = Dev.i
          say 'Warning: fuse_def suppressed for' key 'of' PicName
          iterate                               /* to next key */
        end
        if (key = 'EBTR_4' | key = 'CP_4' | key = 'WRT_4' |,
            key = 'EBTR_5' | key = 'CP_5' | key = 'WRT_5' |,
            key = 'EBTR_6' | key = 'CP_6' | key = 'WRT_6' |,
            key = 'EBTR_7' | key = 'CP_7' | key = 'WRT_7')   &,
           (PicName = '18f6520' | PicName = '18f8520') then do
          i = i + 1
          ln = Dev.i
          say 'Warning: fuse_def suppressed for' key 'of' PicName
          iterate                               /* to next key */
        end
        if pos('OSC',key) > 0      &,           /* any ...OSC... */
           key \= 'FOSC2'          &,           /* excl FOSC2 */
           key \= 'OSCS'           &,           /* excl OSCS */
           key \= 'IOSCFS'         &,           /* excl IOSCFS */
           key \= 'LPT1OSC'        &,           /* excl LPT1OSC */
           key \= 'DSWDTOSC'       &,           /* excl deep sleep WDT osc */
           key \= 'RTCOSC'         &,           /* excl RTC OSC */
           key \= 'RTCSOSC'        &,           /* excl RTC OSC */
           key \= 'SOSCEL'         &,           /* excl Security */
           key \= 'T1OSCMX'            then     /* excl T1 OSC mux */
          key = 'OSC'
        else if pos('IOSCFS',key) > 0 |,
                pos('IOFSCS',key) > 0 then      /* .dev error */
          key = 'IOSCFS'
        else if pos('DSWDTEN',key) > 0 then
          key = 'DSWDTEN'
        else if pos('DSWDTOSC',key) > 0 then
          key = 'DSWDTOSC'
        else if pos('DSWDTPS',key) > 0 then
          key = 'DSWDTPS'
        else if pos('WDTPS',key) > 0 then
          key = 'WDTPS'
        else if pos('WDTCS',key) > 0 then
          key = 'WDTCS'
        else if pos('WDT',key) > 0 then
          key = 'WDT'
        else if pos('BODENV',key) > 0 |,
                pos('BOR4V',key)  > 0 |,
                pos('BORV',key)   > 0 then
          key = 'VOLTAGE'
        else if pos('BODEN',key) > 0  | pos('BOREN',key) > 0 then
          key = 'BROWNOUT'
        else if pos('MCLR',key) > 0 then
          key = 'MCLR'
        else if pos('PUT',key) > 0 |,
                pos('PWRTE',key) > 0 then
          key = 'PWRTE'
        else if pos('WRT ',key) > 0  |,
                pos('WRT_ENABLE',key) > 0 then
          key = 'WRT'

        if CfgAddr.0 > 1 then                 /* multi fuse bytes/words */
          call lineout jalfile, 'pragma fuse_def',
                                key':'X2D(addr) - CfgAddr.1,
                                '0x'strip(val2) '{'
        else
          call lineout jalfile, 'pragma fuse_def' key '0x'strip(val2) '{'

        if key = 'OSC' then
          call list_fuse_def_osc i, key
        else if key = 'DSWDTPS' then
          call list_fuse_def_wdtps i, key
        else if key = 'IOSCFS' then
          call list_fuse_def_ioscfs i, key
        else if key = 'WDTPS' then
          call list_fuse_def_wdtps i, key
        else if key = 'WDT' then
          call list_fuse_def_wdt i, key
        else if key = 'VOLTAGE' then
          call list_fuse_def_voltage i, key
        else if key = 'BROWNOUT' then
          call list_fuse_def_brownout i, key
        else if key = 'MCLR' then               /* /MCLR functions */
          call list_fuse_def_mclr i, key
        else if key = 'WRT' then                /* flash protect */
          call list_fuse_def_wrt i, key
        else
          call list_fuse_def_other i, key
        call lineout jalfile, '       }'
      end
      i = i + 1
      ln = Dev.i
    end
  end
  i = i - 1                                     /* read one to many */
end
call lineout jalfile, '--'
return


/* ------------------------------------------- */
/* Generate fuse_defs for oscillator settings  */
/* - filter the oscillator type                */
/* - filter possible secundary effects         */
/* - check on duplicate names (filter fault!)  */
/* ------------------------------------------- */
list_fuse_def_osc: procedure expose Dev. Fuse_Def. jalfile PICname
aoscname. = '-'                                 /* empty name compound */
do i = arg(1) + 1 while i <= dev.0  &,
          (word(dev.i,1) = 'SETTING' | word(dev.i,1) = 'CHECKSUM')
  parse var Dev.i 'SETTING' val0 'VALUE' '=' '0X',
                         val1 'DESC' '=' '"' val2 '"' .
  if val1 \= '' then do
    mask = strip(val1)                          /* bit mask (hex) */
    name = translate(val2, '_________________',' +-:;.,<>{}[]()=/')
    oscname = Fuse_Def.Osc.name
    if oscname = '?' then do
      say 'Warning: No mapping for OSC Name' name
      return
    end
    if aoscname.oscname = '-' then do           /* not duplicate */
      aoscname.oscname = oscname                /* store name */
      call lineout jalfile, '       'oscname '= 0x'mask
    end
    else
      say 'Warning: Duplicate OSC name:' oscname '('name')'
  end
end
return


/* ------------------------------------------- */
/* Generate fuse_defs for watchdog postscaler  */
/* ------------------------------------------- */
list_fuse_def_wdtps: procedure expose Dev. jalfile
do i = arg(1) + 1 while i <= dev.0  &  word(dev.i,1) = 'SETTING'
  parse var Dev.i 'SETTING' val0 'VALUE' '=' '0X',
                         val1 'DESC' '=' '"' val2 '"' ')' .
  if val1 \= '' then do
    val1 = strip(val1)                  /* remove blanks */
    parse var val2 p0 ':' p1            /* split */
    p1 = translate(p1, '______','.,()=/')  /* to underscore */
    p1 = word(p1,1)
    offset = pos('_',p1)
    do while offset > 1                 /* remove underscores */
      p1 = substr(p1,1,offset-1)||substr(p1,offset+1)
      offset = pos('_',p1)
    end
    call lineout jalfile, '       P'p1 '= 0x'val1
  end
end
return


/* ------------------------------------------- */
/* Generate fuse_defs for watchdog settings    */
/* ------------------------------------------- */
list_fuse_def_wdt: procedure expose Dev. jalfile
flag_enabled = 0                                /* for checking of pair */
flag_disabled = 0
do i = arg(1) + 1 while i <= dev.0  &  word(dev.i,1) = 'SETTING'
  parse var Dev.i 'SETTING' val0 'VALUE' '=' '0X',
                         val1 'DESC' '=' '"' val2 '"' ')' .
  if val1 \= '' then do
    val1 = strip(val1)                  /* remove blanks */
    if val2 = 'ON' | pos('ENABLE', val2) > 0  then do   /* replace */
      val2 = 'ENABLED'
      flag_enabled = 1
    end
    else if val2 = 'OFF' | pos('DISABLE',val2) > 0 then do   /* replace */
      val2 = 'DISABLED'
      flag_disabled = 1
    end
    else
      val2 = translate(val2, '_________________',' +-:;.,<>{}[]()=/')  /* undersc. */
    call lineout jalfile, '       'val2 '= 0x'val1
  end
end
if flag_enabled \= flag_disabled then               /* impaired */
  say 'Warning: enable/disable impairment fuse_def' arg(2)
return


/* ------------------------------------------- */
/* Generate fuse_defs for /MCLR settings       */
/* ------------------------------------------- */
list_fuse_def_mclr: procedure expose Dev. jalfile
do i = arg(1) + 1 while i <= dev.0  &  word(dev.i,1) = 'SETTING'
  parse var Dev.i 'SETTING' val0 'VALUE' '=' '0X',
                         val1 'DESC' '=' '"' val2 '"' ')' .
  if val1 \= '' then do
    val1 = strip(val1)
    val2 = strip(val2)
    if pos('EXTERN',val2) > 0       |,
       pos('MCLR ENABLED',val2) > 0 |,
       pos('MASTER',val2) > 0       |,
       pos('AS MCLR',val2) > 0      |,
       val2 = 'MCLR'                |,
       val2 = 'ENABLED'  then
      val2 = 'EXTERNAL'
    else
      val2 = 'INTERNAL'
    call lineout jalfile, '       'val2 '= 0x'val1
  end
end
return


/* ------------------------------------------- */
/* Generate fuse_defs for WRT settings         */
/* ------------------------------------------- */
list_fuse_def_wrt: procedure expose Dev. jalfile
do i = arg(1) + 1 while i <= dev.0  &  word(dev.i,1) = 'SETTING'
  parse var Dev.i 'SETTING' val0 'VALUE' '=' '0X',
                         val1 'DESC' '=' '"' val2 '"' ')' .
  if val1 \= '' then do
    val1 = strip(val1)
    val2 = strip(val2)
    if pos('DISABLED',val2) > 0 |,              /* unprotected */
       pos('OFF',val2) > 0 then
      val2 = 'NO_PROTECTION'
    if pos('ENABLED',val2) > 0 then             /* protected */
      val2 = 'ALL_PROTECTED'
    else if left(Val2,1) = '0' then do          /* memory range */
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
      val2 = 'R'right(strip(aa),4,'0')'_'right(strip(zz),4,'0')
    end
    else
      val2 = translate(val2, '_________________',' +-:;.,<>{}[]()=/')
    call lineout jalfile, '       'val2 '= 0x'val1
  end
end
return


/* ------------------------------------------- */
/* Generate fuse_defs for brownout voltage     */
/* ------------------------------------------- */
list_fuse_def_voltage: procedure expose Dev. jalfile
do i = arg(1) + 1 while i <= dev.0  &  word(dev.i,1) = 'SETTING'
  parse var Dev.i 'SETTING' val0 'VALUE' '=' '0X',
                         val1 'DESC' '=' '"' val2 '"' ')' .
  if val1 \= '' then do
    val1 = strip(val1)                          /* remove blanks */
    val2 = word(val2, words(val2))              /* only last word */
    parse var val2 p1 '.' p2 'V'                /* select digits */
    call lineout jalfile, '       V'p1||p2 '= 0x'val1
  end
end
return


/* ---------------------------------------------- */
/* Generate fuse_defs for IOSCFS (int oscs freq)  */
/* ---------------------------------------------- */
list_fuse_def_ioscfs: procedure expose Dev. jalfile
do i = arg(1) + 1 while i <= dev.0  &  word(dev.i,1) = 'SETTING'
  parse var Dev.i 'SETTING' val0 'VALUE' '=' '0X',
                         val1 'DESC' '=' '"' val2 '"' ')' .
  if val1 \= '' then do
    val1 = strip(val1)                          /* remove blanks */
    val2 = strip(val2)
    if pos('MHZ',val2) > 0 then do
      if pos('8',val2) > 0 then                 /* 8 MHz */
        val2 = 'F8MHZ'
      else
        val2 = 'F4MHZ'                          /* otherwise */
    end
    else do
      val2 = translate(val2, '_________________',' +-:;.,<>{}[]()=/')  /* to underscore */
      if left(val2,1) >= '0' & left(val2,1) <= '9' then
        val2 = '_'val2                  /* prefix when numeric */
    end
    call lineout jalfile, '       'val2 '= 0x'val1
  end
end
return


/* ------------------------------------------- */
/* Generate fuse_defs for brownout settings    */
/* ------------------------------------------- */
list_fuse_def_brownout: procedure expose Dev. jalfile
flag_enabled = 0                                /* for checking of pair */
flag_disabled = 0
do i = arg(1) + 1 while i <= dev.0  &  word(dev.i,1) = 'SETTING'
  parse var Dev.i 'SETTING' val0 'VALUE' '=' '0X',
                         val1 'DESC' '=' '"' val2 '"' ')' .
  if val1 \= '' then do
    val1 = strip(val1)                  /* remove blanks */
    if pos('SLEEP',val2) > 0  &  pos('DEEP SLEEP',val2) = 0 then
      Val2 = 'RUNONLY'
    else if pos('ENABLE',val2) \= 0  |,
            val2 = 'ON' then do
      val2 = 'ENABLED'
      flag_enabled = 1
    end
    else if pos('CONTROL',val2) \= 0 then
      Val2 = 'CONTROL'
    else do
      Val2 = 'DISABLED'
      flag_disabled = 1
    end
    call lineout jalfile, '       'val2 '= 0x'val1
  end
end
if flag_enabled \= flag_disabled then               /* impaired */
  say 'Warning: enable/disable impairment fuse_def' arg(2)
return


/* ------------------------------------------- */
/* Generate fuse_defs for 'other' settings     */
/* ------------------------------------------- */
list_fuse_def_other: procedure expose Dev. jalfile
flag_enabled = 0                                /* for checking of pair */
flag_disabled = 0
do i = arg(1) + 1 while i <= dev.0  &,
       (word(dev.i,1) = 'SETTING' | word(dev.i,1) = 'CHECKSUM')
  parse var Dev.i 'SETTING' val0 'VALUE' '=' '0X',
                         val1 'DESC' '=' '"' val2 '"' ')' .
  if val1 \= '' then do
    val1 = strip(val1)                          /* remove blanks */
    val2 = strip(val2)
    if left(val2,6) = 'ENABLE' | val2 = 'ON' | val2 = 'ALL' then do
      val2 = 'ENABLED'
      flag_enabled = 1
    end
    else if left(val2,7) = 'DISABLE' | val2 = 'OFF' then do
      val2 = 'DISABLED'
      flag_disabled = 1
    end
    else if pos('ANALOG',val2) > 0 then
      val2 = 'ANALOG'
    else if pos('DIGITAL',val2) > 0 then
      val2 = 'DIGITAL'
    else do
      val2 = translate(val2, '_________________',' +-:;.,<>{}[]()=/')  /* to blanks */
      if left(val2,1) >= '0' & left(val2,1) <= '9' then
        val2 = '_'val2                  /* prefix when numeric */
    end
    call lineout jalfile, '       'val2 '= 0x'val1

  end
end
if flag_enabled \= flag_disabled then               /* impaired */
  say 'Warning: enable/disable impairment fuse_def' arg(2)
return


/* ----------------------------------------------------------------------------- *
 * Generate functions w.r.t. analog modules.                                     *
 * First individual procedures for different analog modules,                     *
 * then a procedure to invoke these procedures.                                  *
 *                                                                               *
 * Possible combinations for the different PICS:                                 *
 * ANSEL   [ANSELH]                                                              *
 * ANSEL0  [ANSEL1]                                                              *
 * ANSELA   ANSELB [ANSELD  ANSELE]                                              *
 * ADCON0  [ADCON1 [ADCON2 [ADCON3]]]                                            *
 * ANCON0   ANCON1                                                               *
 * CMCON                                                                         *
 * CMCON0  [CMCON1]                                                              *
 * CM1CON0 [CM1CON1] [CM2CON0 CM2CON1]                                           *
 * Between brackets optional, otherwise always together.                         *
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
 * PICs are classified in groups for ADC module settings.                        *
 * Below the register settings for all-digital I/O:                              *
 * ADC_V0   ADCON0 = 0b0000_0000 [ADCON1 = 0b0000_0000]                          *
 *          ANSEL0 = 0b0000_0000  ANSEL1 = 0b0000_0000  (or ANSEL_/H,A/B/D/E)    *
 * ADC_V1   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0111                           *
 * ADC_V2   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111                           *
 * ADC_V3   ADCON0 = 0b0000_0000  ADCON1 = 0b0111_1111                           *
 * ADC_V4   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111                           *
 * ADC_V5   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111                           *
 * ADC_V6   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111                           *
 * ADC_V7   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000  ADCON2 = 0b0000_0000     *
 *          ANSEL0 = 0b0000_0000  ANSEL1 = 0b0000_0000                           *
 * ADC_V7_1 ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000  ADCON2 = 0b0000_0000     *
 *          ANSEL  = 0b0000_0000 [ANSELH = 0b0000_0000]                          *
 * ADC_V8   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000  ADCON2 = 0b0000_0000     *
 *          ANSEL  = 0b0000_0000  ANSELH = 0b0000_0000                           *
 * ADC_V9   ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000                           *
 *          ANCON0 = 0b1111_1111  ANCON1 = 0b1111_1111                           *
 * ADC_V10  ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000                           *
 *          ANSEL  = 0b0000_0000  ANSELH = 0b0000_0000                           *
 * ADC_V11  ADCON0 = 0b0000_0000  ADCON1 = 0b0000_0000                           *
 *          ANCON0 = 0b1111_1111  ANCON1 = 0b1111_1111                           *
 * ADC_V12  ADCON0 = 0b0000_0000  ADCON1 = 0b0000_1111  ADCON2 = 0b0000_0000     *
 * ----------------------------------------------------------------------------- */
list_analog_functions: procedure expose jalfile Name. Core PicSpec. PinMap. PicName
PicNameCap = toupper(PicName)

call lineout jalfile, '--'
call lineout jalfile, '-- ==================================================='
call lineout jalfile, '--'
call lineout jalfile, '-- Special (device specific) constants and procedures'
call lineout jalfile, '--'

if PicSpec.ADCgroup.PicNameCap = '?' then do
  say PicName 'Error: No ADCgroup for' PicName 'in devicespecific.cmd!'
  exit 1
end
ADCgroup = PicSpec.ADCgroup.PicNameCap

if  PinMap.PicNameCap.ANCOUNT = '?' |,                  /* PIC not in pinmap.cmd? */
    ADCGroup = '0'  then                                /* PIC has no ADC module */
  PinMap.PicNameCap.ANCOUNT = 0
call charout jalfile, 'const ADC_GROUP = 'ADCgroup
if ADCgroup = '0' then
  call lineout jalfile, '             -- no ADC module present'
else
  call lineout jalfile, ''
call lineout jalfile, 'const byte ADC_NTOTAL_CHANNEL =' PinMap.PicNameCap.ANCOUNT
call lineout jalfile, '--'

if (ADCgroup = '0'  & PinMap.PicNameCap.ANCOUNT > 0) |,
   (ADCgroup \= '0' & PinMap.PicNameCap.ANCOUNT = 0) then
  say 'Warning:' PicName 'Possible conflict between ADC-group ('ADCgroup')',
               'and number of ADC channels ('PinMap.PicNameCap.ANCOUNT')'

analog. = '-'                                           /* no analog modules */

if Name.ANSEL  \= '-' | Name.ANSEL1 \= '-' |,           /* check on presence */
   Name.ANSELA \= '-' | Name.ANCON0 \= '-'  then do
  analog.ANSEL = 'analog'                       /* analog functions present */
  call lineout jalfile, '-- - - - - - - - - - - - - - - - - - - - - - - - - - -'
  call lineout jalfile, '-- Change analog I/O pins into digital I/O pins.'
  call lineout jalfile, 'procedure analog_off() is'
  call lineout jalfile, '   pragma inline'
  if Name.ANSEL \= '-' then do                          /* ANSEL declared */
    call lineout jalfile, '   ANSEL  = 0b0000_0000       -- all digital'
    if Name.ANSELH \= '-' then
      call lineout jalfile, '   ANSELH = 0b0000_0000       -- all digital'
  end
  if Name.ANSEL0 \= '-' then do                         /* ANSEL0 declared */
    suffix = '0123456789'                               /* suffix numbers */
    do i = 1 to length(suffix)
      qname = 'ANSEL'substr(suffix,i,1)                 /* qualified name */
      if Name.qname \= '-' then                         /* ANSELx declared */
        call lineout jalfile, '   'qname '= 0b0000_0000        -- all digital'
    end
  end
  if Name.ANSELA \= '-' then do                         /* ANSELA declared */
    suffix = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'               /* suffix letters */
    do i = 1 to length(suffix)
      qname = 'ANSEL'substr(suffix,i,1)                 /* qualified name */
      if Name.qname \= '-' then                         /* ANSELx declared */
        call lineout jalfile, '   'qname '= 0b0000_0000        -- all digital'
    end
  end
  if Name.ANCON0 \= '-' then                            /* ANCON0 declared */
    call lineout jalfile, '   ANCON0 = 0b1111_1111        -- all digital'
  if Name.ANCON1 \= '-' then                            /* ANCON1 declared */
    call lineout jalfile, '   ANCON1 = 0b1111_1111        -- all digital'
  call lineout jalfile, 'end procedure'
  call lineout jalfile, '--'
end

if Name.ADCON0 \= '-' then do                           /* check on presence */
  analog.ADC = 'adc'                                    /* ADC module present */
  call lineout jalfile, '-- - - - - - - - - - - - - - - - - - - - - - - - - - -'
  call lineout jalfile, '-- Disable ADC module'
  call lineout jalfile, 'procedure adc_off() is'
  call lineout jalfile, '   pragma inline'
  call lineout jalfile, '   ADCON0 = 0b0000_0000         -- disable ADC'
  if Name.ADCON1 \= '-' then do                         /* ADCON1 declared */
    if ADCgroup = 'ADC_V0' then
      call lineout jalfile, '   ADCON1 = 0b0000_0000'
    else if ADCgroup = 'ADC_V1' then
      call lineout jalfile, '   ADCON1 = 0b0000_0111         -- digital I/O'
    else if ADCgroup = 'ADC_V2'  |,
            ADCgroup = 'ADC_V4'  |,
            ADCgroup = 'ADC_V5'  |,
            ADCgroup = 'ADC_V6'  |,
            ADCgroup = 'ADC_V12' then
      call lineout jalfile, '   ADCON1 = 0b0000_1111         -- digital I/O'
    else if ADCgroup = 'ADC_V3' then
      call lineout jalfile, '   ADCON1 = 0b0111_1111         -- digital I/O'
    else                                                /* ADC_V7,7_1,8,9,10,11 */
      call lineout jalfile, '   ADCON1 = 0b0000_0000'
    if Name.ADCON2 \= '-' then                          /* ADCON2 declared */
      call lineout jalfile, '   ADCON2 = 0b0000_0000'   /* all groups */
  end
  call lineout jalfile, 'end procedure'
  call lineout jalfile, '--'
end

if Name.CMCON   \= '-' | Name.CMCON0 \= '-' |,
   Name.CM1CON0 \= '-' | Name.CM1CON1 \= '-' then do
  analog.CMCON = 'comparator'                           /* Comparator present */
  call lineout jalfile, '-- - - - - - - - - - - - - - - - - - - - - - - - - - -'
  call lineout jalfile, '-- Disable comparator module'
  call lineout jalfile, 'procedure comparator_off() is'
  call lineout jalfile, '   pragma inline'
  if Name.CMCON \= '-' then
    call lineout jalfile, '   CMCON  = 0b0000_0111        -- disable comparator'
  else if Name.CMCON0 \= '-' then
    call lineout jalfile, '   CMCON0 = 0b0000_0111        -- disable comparator'
  else if Name.CM1CON0 \= '-' then do
    call lineout jalfile, '   CM1CON0 = 0b0000_0000       -- disable comparator'
    if Name.CM2CON0 \= '-' then
      call lineout jalfile, '   CM2CON0 = 0b0000_0000       -- disable 2nd comparator'
  end
  else if Name.CM1CON1 \= '-' then do
    call lineout jalfile, '   CM1CON1 = 0b0000_0000       -- disable comparator'
    if Name.CM2CON1 \= '-' then
      call lineout jalfile, '   CM2CON1 = 0b0000_0000       -- disable 2nd comparator'
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

if left(PicName,3) = '10f' |,                   /* all 10Fs */
   PicName = '12f508' | PicName = '12f509' |,
   PicName = '12f510' | PicName = '12f519' |,
   PicName = '16f505' | PicName = '16f506' |,
   PicName = '16f526' then
  call lineout jalfile, '   OPTION_REG_T0CS = OFF        -- T0CKI pin input + output'
call lineout jalfile, 'end procedure'


return


/* --------------------------------------- */
/* Generate common header                  */
/* --------------------------------------- */
list_head:
call lineout jalfile, '-- ==================================================='
call lineout jalfile, '-- Title: JalV2 device include file for PIC' toupper(PicName)
call list_copyright_etc jalfile
call lineout jalfile, '-- Description:'
call lineout Jalfile, '--    Device include file for pic'PicName', containing:'
call lineout jalfile, '--    - Declaration of ports and pins of the chip.'
if core \= 16 then do                           /* for the baseline and midrange */
  call lineout jalfile, '--    - Procedures for shadowing of ports and pins'
  call lineout jalfile, '--      to circumvent the read-modify-write problem.'
end
else do                                         /* for the 18F series */
  call lineout jalfile, '--    - Procedures to force the use of the LATx register'
  call lineout jalfile, '--      when PORTx is addressed.'
end
call lineout jalfile, '--    - Symbolic definitions for configuration bits (fuses)'
call lineout jalfile, '--    - Some device dependent procedures for common'
call lineout jalfile, '--      operations, like:'
call lineout jalfile, '--      . enable_digital_io()'
call lineout jalfile, '--'
call lineout jalfile, '-- Sources:'
call lineout jalfile, '--  - x:'substr(DevFile,3)      /* always drive 'x' */
call lineout jalfile, '--  - x:'substr(LkrFile,3)
call lineout jalfile, '--'
call lineout jalfile, '-- Notes:'
call lineout jalfile, '--  - Created with Dev2Jal Rexx script version' ScriptVersion
call lineout jalfile, '--  - File creation date/time:' date('N') left(time('N'),5)
call lineout jalfile, '--'
call lineout jalfile, '-- ==================================================='
call lineout jalfile, '--'
call list_devID
PicNameCap = toupper(PicName)
call lineout jalfile, 'const byte PICTYPE[]   = "'PicNameCap'"'
DataSheet = PicSpec.DataSheet.PicNameCap
if DataSheet = '?' then do
  say PicName 'unknown for Datasheet in devicespecific.cmd!'
  exit 1
end
call lineout jalfile, 'const byte DATASHEET[] = "'DataSheet'"'
PgmSpec = PicSpec.PgmSpec.PicNameCap
if PgmSpec = '?' then do
  say PicName 'unknown for PgmSpec in devicespecific.cmd!'
  exit 1
end
call lineout jalfile, 'const byte PGMSPEC[]   = "'PgmSpec'"'
call lineout jalfile, '--'
call list_Vdd
call list_Vpp
call lineout jalfile, '--'
call lineout jalfile, '-- ---------------------------------------------------'
call lineout jalfile, '--'
call lineout jalfile, 'include chipdef_jallib                  -- common constants'
call lineout jalfile, '--'
call lineout jalfile, 'pragma  target  cpu   PIC_'Core '           -- (banks = 'Numbanks')'
call lineout jalfile, 'pragma  target  chip  'PicName
call lineout jalfile, 'pragma  target  bank  0x'D2X(BANKSIZE,4)
if core = 12 | core = 14 then
  call lineout jalfile, 'pragma  target  page  0x'D2X(PAGESIZE,4)
call lineout jalfile, 'pragma  stack   'StackDepth
call list_code_size
call list_data_size
MaxUnsharedRAM = 0                              /* no unshared RAM */
call list_unshared_data_range                   /* MaxUnsharedRam updated! */
MaxSharedRAM = 0                                /* no shared RAM */
x = list_shared_data_range()                    /* returns range string */
/* - - - - - - - -  temporary? - - - - - - - - - - - - - - - - - */
if MaxUnsharedRAM = 0  &  MaxSharedRAM > 0 then do      /* no unshared RAM */
  say 'Warning:' PicName 'has only shared, no unshared RAM!'
  say '         Must be handled as exceptional chip!'
end
else if MaxSharedRAM = 0 then do                        /* no shared RAM */
  if Core \= 12                                 &,      /* known as 'OK' */
     PicName \= '12f629'                        &,
     PicName \= '12f675'                        &,
     PicName \= '16f630'                        &,
     PicName \= '16f676'                        &,
     PicName \= '16f73'                         &,
     PicName \= '16f74'                         &,
     PicName \= '16f83'                         &,
     PicName \= '16f84'  & PicName \= '16f84a'  &,
     PicName \= '16f873' & PicName \= '16f873a' &,
     PicName \= '16f874' & PicName \= '16f874a' &,
     PicName \= '16hv540'                        ,
  then do
    say 'Warning:' PicName 'has no shared RAM!'
    say '         May have to be handled as exceptional chip!'
  end
end
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
call lineout jalfile, '--'
if Core = 12  | Core = 14 then do
  if x \= '' then do                            /* with shared RAM */
    call lineout jalfile, 'var volatile byte _pic_accum shared at',
                          sfr_mirror(MaxSharedRAM-1)'   -- (compiler)'
    call lineout jalfile, 'var volatile byte _pic_isr_w shared at',
                          sfr_mirror(MaxSharedRAM)'   -- (compiler)'
  end
  else do                                       /* no shared RAM */
    call lineout jalfile, 'var volatile byte _pic_accum at',
                          sfr_mirror(MaxUnsharedRAM-1)'   -- (compiler)'
    call lineout jalfile, 'var volatile byte _pic_isr_w at',
                          sfr_mirror(MaxUnSharedRAM)'   -- (compiler)'
  end
end
else if Core = 16 then do
  call lineout jalfile, 'var volatile byte _pic_accum shared at',
                        '0x'D2X(MaxSharedRAM-1)'   -- (compiler)'
  call lineout jalfile, 'var volatile byte _pic_isr_w shared at',
                        '0x'D2X(MaxSharedRAM)'   -- (compiler)'
end
call lineout jalfile, '--'
return


/* ------------------------------------------------- */
/* List common constants in ChipDef.Jal              */
/* input:  - nothing                                 */
/* ------------------------------------------------- */
list_chip_const:
call lineout chipdef, '-- =================================================================='
call lineout chipdef, '-- Title: Common JalV2 compiler include file'
call list_copyright_etc chipdef
call lineout chipdef, '-- Sources:'
call lineout chipdef, '--'
call lineout chipdef, '-- Description:'
call lineout chipdef, '--    Common JalV2 compiler include file'
call lineout chipdef, '--'
call lineout chipdef, '-- Notes:'
call lineout chipdef, '--    - Created with Dev2Jal Rexx script version' ScriptVersion
call lineout chipdef, '--    - File creation date/time:' date('N') left(time('N'),5)
call lineout chipdef, '--'
call lineout chipdef, '-- ---------------------------------------------------'
call lineout chipdef, 'const       PIC_12            = 1'
call lineout chipdef, 'const       PIC_14            = 2'
call lineout chipdef, 'const       PIC_16            = 3'
call lineout chipdef, 'const       SX_12             = 4'
call lineout chipdef, '--'
call lineout chipdef, 'const bit   PJAL              = 1'
call lineout chipdef, '--'
call lineout chipdef, 'const byte  W                 = 0'
call lineout chipdef, 'const byte  F                 = 1'
call lineout chipdef, '--'
call lineout chipdef, 'const bit   TRUE              = 1'
call lineout chipdef, 'const bit   FALSE             = 0'
call lineout chipdef, 'const bit   HIGH              = TRUE'
call lineout chipdef, 'const bit   LOW               = FALSE'
call lineout chipdef, 'const bit   ON                = TRUE'
call lineout chipdef, 'const bit   OFF               = FALSE'
call lineout chipdef, 'const bit   ENABLED           = TRUE'
call lineout chipdef, 'const bit   DISABLED          = FALSE'
call lineout chipdef, 'const bit   INPUT             = TRUE'
call lineout chipdef, 'const bit   OUTPUT            = FALSE'
call lineout chipdef, 'const byte  ALL_INPUT         = 0b_1111_1111'
call lineout chipdef, 'const byte  ALL_OUTPUT        = 0b_0000_0000'
call lineout chipdef, '--'
call lineout chipdef, 'const       ADC_V0            = 0x_ADC_0'
call lineout chipdef, 'const       ADC_V1            = 0x_ADC_1'
call lineout chipdef, 'const       ADC_V2            = 0x_ADC_2'
call lineout chipdef, 'const       ADC_V3            = 0x_ADC_3'
call lineout chipdef, 'const       ADC_V4            = 0x_ADC_4'
call lineout chipdef, 'const       ADC_V5            = 0x_ADC_5'
call lineout chipdef, 'const       ADC_V6            = 0x_ADC_6'
call lineout chipdef, 'const       ADC_V7            = 0x_ADC_7'
call lineout chipdef, 'const       ADC_V7_1          = 0x_ADC_7_1'
call lineout chipdef, 'const       ADC_V8            = 0x_ADC_8'
call lineout chipdef, 'const       ADC_V9            = 0x_ADC_9'
call lineout chipdef, 'const       ADC_V10           = 0x_ADC_10'
call lineout chipdef, 'const       ADC_V11           = 0x_ADC_11'
call lineout chipdef, 'const       ADC_V12           = 0x_ADC_12'
call lineout chipdef, '--'
call lineout chipdef, '-- =================================================================='
call lineout chipdef, '--'
call lineout chipdef, '-- Values assigned to const "target_chip" by'
call lineout chipdef, '-- "pragma target chip" in device files.'
call lineout chipdef, '-- Can be used for conditional compilation, for example:'
call lineout chipdef, '--    if (target_chip = PIC_16F88) then'
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
listfile = arg(1)                               /* destination filespec */
call lineout listfile, '--'
call lineout listfile, '-- Author:' ScriptAuthor', Copyright (c) 2008..2009,',
                       'all rights reserved.'
call lineout listfile, '--'
call lineout listfile, '-- Adapted-by:'
call lineout listfile, '--'
call lineout listfile, '-- Compiler:' CompilerVersion
call lineout listfile, '--'
call lineout listfile, '-- This file is part of jallib',
                       ' (http://jallib.googlecode.com)'
call lineout listfile, '-- Released under the ZLIB license',
                       '(http://www.opensource.org/licenses/zlib-license.html)'
call lineout listfile, '--'
return


/* --------------------------------------------------------- */
/* procedure to extend address with mirrored addresses       */
/* input:  - register number (decimal)                       */
/* returns string of addresses between {}                    */
/* (not used for 16-bit core)                                */
/* --------------------------------------------------------- */
sfr_mirror: procedure expose Ram. BANKSIZE NumBanks
addr = arg(1)
addr_list = '{ 0x'D2X(addr)                     /* open bracket, orig. addr */
do i = addr + BANKSIZE to NumBanks * BANKSIZE - 1 by BANKSIZE   /* avail ram */
  if addr = Ram.i then                          /* matching reg number */
    addr_list = addr_list',0x'D2X(i)            /* concatenate to string */
end
return addr_list' }'                            /* complete string */


/* --------------------------------------------- */
/* Signal duplicates names                       */
/* Collect all names in Name. compound variable  */
/* Return - 0 when name is unique                */
/*        - 1 when name is dumplicate            */
/* --------------------------------------------- */
duplicate_name: procedure expose Name. PicName
newname = arg(1)
if newname = '' then                            /* no name specified */
  return 1                                      /* not acceptable */
reg = arg(2)                                    /* register */
if Name.newname = '-' then do                   /* name not in use yet */
  Name.newname = reg                            /* mark in use by which reg */
  return 0                                      /* unique */
end
if reg \= newname then do                       /* not alias of register */
  Say 'Error: Duplicate name for' PicName':' newname 'in' reg'. First occurence:' Name.newname
  return 1                                      /* duplicate */
end


/* ---------------------------------------------- */
/* translate string to lower/upper case           */
/* ---------------------------------------------- */

tolower:
return translate(arg(1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')

toupper:
return translate(arg(1), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')


/* ---------------------------------------------- */
/* some script debugging procedures               */
/* ---------------------------------------------- */

catch_error:
Say 'Rexx Execution error, rc' rc 'at script line' SIGL
return rc

catch_syntax:
if rc = 4 then                                  /* interrupted */
  exit
Say 'Rexx Syntax error, rc' rc 'at script line' SIGL":"
Say SourceLine(SIGL)
return rc



