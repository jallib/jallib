/* ---------------------------------------------------------------------------*
 * Flash_pics.cmd - Process downloaded CSV file of Microchip flash PICs       *
 *                  * create a straight forward listing                       *
 *                  * create a SimpleJSON formatted file                      *
 *                  In both cases only selected 'columns' are included.       *
 *                                                                            *
 * How to run this script:                                                    *
 *  - To run this script you need a Rexx interpretor.                         *
 *    With eComStation (OS/2) Rexx is installed by default.                   *
 *    On systems without Rexx install:                                        *
 *    * Rexx (Regina: http://www.http://regina-rexx.sourceforge.net/)         *
 *    * RegUtil (http://pages.interlog.com/~ptjm/)                            *
 *  - Download the Excel files with PIC properties from the Microchip site    *
 *    * select 'Products' -> '8-bits PICs' -> 'Flash',                        *
 *      click 'Show All Specs' and then 'EXPORT TO XLS'                       *
 *    * select 'Products' -> '8-bits PICs' -> 'Mature Products',              *
 *      click 'Show All Specs' and then 'EXPORT TO XLS'                       *
 *    These Excel files have name format: <product-group>-<date>.csv          *
 *  - If needed, modify the first few lines below for your system setup:      *
 *    * directory with the downloaded XLS files                               *
 *    * names of the XLS files (prefixes without the date)                    *
 *      (maybe rename the file because of the special (R) character)          *
 *    * <date> of the XLS files (assumed equal for both XLS files)            *
 *    * directory with the Jallib device files                                *
 *      (used for the selection of PICs for which properties to list)         *
 *  - Start the script:                                                       *
 *    * with Rexx under eComStation (OS/2) enter in a commandline session:    *
 *        flash_pics                                                          *
 *    * with Regina Rexx enter in a commandline session:                      *
 *        regina flash_pics.cmd                                               *
 *      (you might have to copy this script to the directory with Regina)     *
 *                                                                            *
 * -------------------------------------------------------------------------- */

base   = 'k:/picdatasheets/'                    /* XLS downloaded directory   */
flash  = 'FLASH'                                /* 'flash' XLS file           */
mature = 'Mature PIC~ MCUs'                     /* 'mature products' XLS file */
date   = '2010-07-12'                           /* date of the XLS files      */
dev    = 'k:/jallib/include/device/'            /* dir of Jallib device files */
tools  = 'k:/jallib/tools/'                     /* dir of Jallib tools/data   */

/* build the complete filespecs */
fls  = base||flash'-'date'.csv'                 /* filespec of flash XLS */
mat  = base||mature'-'date'.csv'                /* filespec of mature XLS */
psp  = tools'devicespecific.json'               /* filespec of PIC specific data */

/* specify output files */
list = 'flash_pics.lst'                         /* filespec output listing */
json = tools'flash_pics.json'                   /* filespec output json file */

/* start processing */
call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                               /* load REXX utilities */

if stream(fls,'c','query exists') = '' then do
  say 'Could not find file with flash properties' fls
  return 1
end

if stream(mat,'c','query exists') = '' then do
  say 'Could not find file with mature products properties' mat
  return 1
end

call SysFileTree dev'1*.jal', dev., 'FO'        /* list of device files */
if dev.0 = 0 then do
  say 'Could not find any device files in' dev
  return 1
end

if stream(list,'c','query exists') \= '' then
  call SysFileDelete list
call stream list, 'c', 'open write'

if stream(json,'c','query exists') \= '' then
  call SysFileDelete json
call stream json, 'c', 'open write'

p. = '?'                                        /* init properties */
call file_read_csv fls
call file_read_csv mat
call file_read_json psp

say dev.0 'device files found in' dev

call lineout list, 'PIC properties list dd' date
call lineout list, ''
call lineout json, '{'                          /* open json collection */

PicCount = 0
do i = 1 to dev.0
  parse value filespec('N',dev.i) with PicType '.jal' .
  call lineout list, PicType
  PicNameCaps = translate('pic'PicType,xrange('A','Z'),xrange('a','z'))
  if p.PicNameCaps.ARCHITECTURE = '?' then do           /* check absence in CSV files */
    if pos('LF',PicNameCaps) > 0 then do
      PicTemp = delstr(PicType,3,1)                     /* remove 'l' */
      PicNameCaps = translate('pic'PicTemp,xrange('A','Z'),xrange('a','z'))
      if p.PicNameCaps.ARCHITECTURE = '?' &,            /* check abcense */
         p.PicNameCaps.DATASHEET = '?' then do          /* check abcense */
        call lineout list, '  *** No properties found'
        iterate
      end
      else do
        call lineout json, '   "'PicType'": {'  /* standin present */
        PicType = PicTemp                       /* show properties of standin */
      end
    end
    else do
      call lineout list, '  *** No properties found'
      iterate
    end
  end
  else                                          /* PicType present */
    call lineout json, '   "'PicType'": {'

  PicCount = PicCount + 1

  call list_property PicType, 'ARCHITECTURE'
  call list_property PicType, 'DATASHEET'
  call list_property PicType, 'PGMSPEC'
  call list_property PicType, 'PROGRAM_MEMORY_KBYTES'
  call list_property PicType, 'PROGRAM_MEMORY_KWORDS'
  call list_property PicType, 'SELF_WRITE'
  call list_property PicType, 'EEPROM_DATA_MEMORY'
  call list_property PicType, 'RAM'
  call list_property PicType, 'FUSESDEFAULT'
  call list_property PicType, 'I_O_PINS'
  call list_property PicType, 'PIN_COUNT'
  call list_property PicType, 'MAX_CPU_SPEED_MHZ'
  call list_property PicType, 'CPU_SPEED_MIPS'
  call list_property PicType, 'BROWN_OUT_RESET_BOR'
  call list_property PicType, 'LOW_VOLTAGE_DETECTION'
  call list_property PicType, 'POWER_ON_RESET_POR'
  call list_property PicType, 'WATCH_DOG_TIMERS_WDT'
  call list_property PicType, 'INTERNAL_OSCILLATOR'
  call list_property PicType, 'HARDWARE_RTCC'
  call list_property PicType, 'NANOWATT_LOW_SLEEP'
  call list_property PicType, 'NANOWATT_FAST_WAKE'
  call list_property PicType, 'NANOWATT_POWER_MODES'
  call list_property PicType, 'COMPARATORS'
  call list_property PicType, '#_OF_A_D_CONVERTERS'
  call list_property PicType, '#_OF_A_D_CH'
  call list_property PicType, 'ADCGROUP'
  call list_property PicType, 'CAP_TOUCH_CHANNELS'
  call list_property PicType, 'BANDGAP_REFERENCE'
  call list_property PicType, 'SR_LATCH'
  call list_property PicType, 'DIGITAL_COMMUNICATION'
  call list_property PicType, 'PERIPHERAL_PIN_SELECT_PPS_CROSSBAR'
  call list_property PicType, '#_USB_CHANNELS'
  call list_property PicType, 'USB_SPEED'
  call list_property PicType, 'USB_COMPLIANT'
  call list_property PicType, '#_OF_CAN_MODULES'
  call list_property PicType, 'TYPE_OF_CAN_MODULE'
  call list_property PicType, 'CAN_TRANSMIT_BUFFERS'
  call list_property PicType, 'CAN_RECEIVE_BUFFERS'
  call list_property PicType, 'LIN'
  call list_property PicType, 'IRDA'
  call list_property PicType, 'ETHERNET'
  call list_property PicType, 'CAPTURE_COMPARE_PWM_PERIPHERALS'
  call list_property PicType, 'TIMERS'
  call list_property PicType, 'SEGMENT_LCD'
  call list_property PicType, 'GRAPHICAL_DISPLAY'
  call list_property PicType, 'EMA'
  call list_property PicType, 'JTAG'
  call list_property PicType, 'ICSP'
  call list_property PicType, 'ICD_DEBUG'
  call list_property PicType, 'TEMPERATURE_RANGE'
  call list_property PicType, 'OPERATION_VOLTAGE_RANGE'
  call list_property PicType, 'PACKAGES'

  call stream  json, 'C', 'seek -3'                 /* remove last comma and CR/LF */
  call lineout json, ''
  call lineout json, '   } ,'
end
call stream  json, 'C', 'seek -3'                   /* remove last comma and CR/LF */
call lineout json, ''
call lineout json, '}'
call lineout list, 'Listed properties of ' PicCount 'of' dev.0 'device files'
call lineout list, ''
call stream list, 'c', 'close'

Say 'Listed properties of ' PicCount 'of' dev.0 'device files'

return 0


/* ------------------------------------------------------------- */
/* procedure to list a single property                           */
/*                                                               */
/* For the SimpleJSON output the 'raw' property is splitted      */
/* in multiple subfields when applicable.                        */
/* ------------------------------------------------------------- */
list_property: procedure expose p. list json

parse upper arg PicType, PropName .
PicName = 'PIC'PicType                          /* name used in p. */
call lineout list, '  'PropName '= "'p.PicName.PropName'"'
call charout json, '      "'PropName'" : [ '    /* open bracket */
val = p.PicName.PropName                        /* value string */
if pos(',',val) > 0 then do                     /* CSV subfields */
  do while val \= ''
    val = strip(val,'L')                        /* remove leading blanks */
    parse upper var val valsub ',' val          /* split subfields */
    offset_times  = pos('x',valsub)
    offset_hyphen = pos('-',valsub)
    offset_slash  = pos('/',valsub)
    offset_MHZ    = pos('MHZ',valsub)
    offset_KHZ    = pos('KHZ',valsub)
    if offset_times > 0 then do
      parse var valsub valx 'x' valy          /* split */
      call charout json, '{ "'space(valy,,'_')'" : ["'strip(valx,'B')'"] } , '
    end
    else if offset_hyphen > 0   &,
       (offset_slash = 0 | offset_slash > offset_hyphen) then do
      parse var valsub valx '-' valy            /* split */
      call charout json, '{ "'space(valy,,'_')'" : ["'strip(valx,'B')'"] } , '
    end
    else if offset_slash > 0 then do
      parse var valsub valx '/' valy            /* split */
      call charout json, '{ "'space(valy,,'_')'" : ["'strip(valx,'B')'"] } , '
    end
    else if offset_MHZ > 0 then do
      if pos('MHZ',val) > 0 then do             /* 2nd MHZ value present */
        parse upper var val valsub2 ',' val     /* split inline */
        call charout json, '{ "MHZ" : ["'word(valsub,1)'" , "'word(valsub2,1)'"] } , '
      end
      else
        call charout json, '{ "MHZ" : ["'word(valsub,1)'"] } , '
    end
    else if offset_KHZ > 0 then do
      call charout json, '{ "KHZ" : ["'word(valsub,1)'"] } , '
    end
    else do
      if words(subval) > 1 then
        say 'Warning: multiple words in subval:' subval
      call charout json, '"'word(valsub,1)'" ,'
    end
  end
  call stream  json, 'C', 'seek -2'             /* remove last comma */
end
else if pos('MHz',val) > 0 then do              /* with internal oscillator (only?) */
  call charout json, '{ "MHZ" : ["'word(val,1)'"] }'
end
else
  call charout json, '"'val'"'                /* value */
call lineout json, ' ] ,'                     /* closing bracket */

return


/* -------------------------------------------------------- */
/* procedure to read CSV file                               */
/*                                                          */
/* First line is supposed to contain the columns titles,    */
/* which are slightly modified to obtain reasonable names   */
/* for each property.                                       */
/* The following lines contain the properties, which are    */
/* stored asis in the compound variable 'p' with the names  */
/* derived from the first line.                             */
/* Note: Only lines for PICs supported by JalV2 are         */
/*       processed, other lines are simply skipped.         */
/*                                                          */
/* -------------------------------------------------------- */
file_read_csv: procedure expose p.

parse arg csv

if stream(csv, 'c', 'open read') \= 'READY:' then do
  say 'Warning: Failed to open' csv 'for reading!'
  return
end

say 'Reading file' csv '...'

val. = '-'
ln = linein(csv)
do i = 1 while ln \= ''
  parse var ln '"' hdr '"' ln
  hdr = translate(hdr,'       2',' ()./-,²')    /* special chars -> blanks */
  hdr = space(hdr,,'_')                     /* replace (multi) spaces by (single) underscore */
  hdr = translate(hdr,xrange('A','Z'),xrange('a','z'))    /* make upper case */
  hdr.i = hdr
end

do while lines(csv)
  ln = linein(csv)
  offset = pos('PIC1', ln)
  if offset = 0 then                        /* not a line with PIC1* */
    iterate
  ln = substr(ln, offset)                   /* skip everything before 'PIC1' */
  parse var ln 'PIC'PicName ',' ln          /* extract PIC type */
  PicName = strip(PicName,'B')
  if PicJalV2(PicName) = 0 then             /* not in Jallib collection */
    iterate
  do i = 2 while ln \= ''                   /* whole line */
    ln = strip(ln,'L')                      /* remove leading blanks */
    if left(ln,1) = ',' then do
      val = "-"
      ln = substr(ln,2)
    end
    else
      parse var ln '"' val '"' ',' ln
    val = strip(val,'B')                    /* remove surrounding blanks */
    pnm = translate('pic'PicName,xrange('A','Z'),xrange('a','z'))
    hdr = hdr.i                             /* heading of column */
    p.pnm.hdr = val                         /* store value this column */
  end
end
call stream csv, 'c', 'close'               /* done with file */
return


/* --------------------------------------------------- */
/* Read file with Device Specific data                 */
/* Interpret contents: fill compound variable p.       */
/* --------------------------------------------------- */
file_read_json: procedure expose p.

parse arg jsonfile .

if stream(jsonfile, 'c', 'open read') \= 'READY:' then do
  Say '  Error: could not open file with device specific data' jsonfile
  exit 1                                        /* zero records */
end

say 'Reading file' jsonfile '...'

do until x = '{' | x = 0                        /* search begin of properties */
  x = json_newchar(jsonfile)
end
do until x = '}' | x = 0                        /* end of properties */
  do until x = '}' | x = 0                      /* end of pic */
    PicName = 'PIC'json_newstring(jsonfile)          /* new PIC */
    do until x = '{' | x = 0                    /* search begin PIC specs */
      x = json_newchar(jsonfile)
    end
    do until x = '}' | x = 0                    /* this PICs specs */
      ItemName = json_newstring(jsonfile)
      value = json_newstring(jsonfile)
      p.PicName.ItemName = value
      x = json_newchar(jsonfile)
    end
    x = json_newchar(jsonfile)
  end
  x = json_newchar(jsonfile)
end
call stream jsonfile, 'c', 'close'              /* done with file */
return


/* -------------------------------- */
json_newstring: procedure
jsonfile = arg(1)
do until x = '"' | x = ']' | x = '}' | x = 0    /* start new string or end of everything */
  x = json_newchar(jsonfile)
end
if x \= '"' then
  return ''
str = ''
x = json_newchar(jsonfile)                      /* first char */
do while x \= '"'
  str = str||x
  x = json_newchar(jsonfile)
end
return str

/* -------------------------------- */
json_newchar: procedure
jsonfile = arg(1)
do while chars(jsonfile) > 0
  x = charin(jsonfile)
  if x <= ' ' then                              /* white space */
    iterate
  return x
end
return 0                                        /* dummy */


/* --------------------------------------------------------------- */
/* Procedure to determine if PIC belongs to JalV2 supported group  */
/* returns: 0 - not supported                                      */
/*          1 - supported                                          */
/* --------------------------------------------------------------- */
PicJalV2: procedure

parse upper arg PicName .

if (left(PicName,3) = '10F'  |,
    left(PicName,3) = '12F'  |,
    left(PicName,4) = '12HV' |,
    left(PicName,3) = '16F'  |,           /* one of these */
    left(PicName,4) = '16HV' |,
    left(PicName,4) = '16LF' |,
    left(PicName,3) = '18F'  |,
    left(PicName,4) = '18LF')  &,
    pos('F18',PicName) = 0     &,         /* not one of these */
    pos('F19',PicName) = 0    then  do
      return 1                            /* supported */
end
return 0                                  /* not supported */

