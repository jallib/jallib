/* ---------------------------------------------------------------------------- */
/* CreateDSwikis.cmd - create wiki files:                                       */
/*                     * Datasheet                                              */
/*                     * Programming Specifications                             */
/*                     * PICs with the same Datasheet                           */
/*                     * PICs with the same Programming Specifications          */
/*                                                                              */
/* Notes: - Script can be run on any platform which supports Rexx.              */
/*          See for a 'howto' devicefiles.html and the comments in dev2jal.cmd  */
/* ---------------------------------------------------------------------------- */

parse upper arg runtype .

/* -- input files (may require changes for other systems or platforms) -- */
pdfdir      = 'n:/picdatasheets/'                   /* dir with datasheets (local)  */
PicSpecFile = 'k:/jallib/tools/devicespecific.json' /* PIC specific properties      */
dslist      = 'k:/jallib/tools/datasheet.list'      /* datasheet number/title file  */

/* -- output -- */
dst         = 'k:/jallib/wiki/'                     /* output path */
dswiki      = dst'DataSheets.wiki'                  /* out: DS wiki */
pswiki      = dst'ProgrammingSpecifications.wiki'   /* out: PS wiki */
dsgroupwiki = dst'PicGroups.wiki'
psgroupwiki = dst'PicPgmGroups.wiki'
url         = 'http://ww1.microchip.com/downloads/en/DeviceDoc/' /* Microchip site  */

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                               /* load REXX functions */

PicSpec. = ''
call  read_devspec                              /* obtain device specific info */

dsinfo. = ''                                    /* compound var: ds number and title */
call  read_dsinfo                               /* load datasheet info */

call  pic_wiki    dswiki                        /* PIC -> datasheet wiki */
call  pic_wiki    pswiki                        /* PIC -> Programming Specifications wiki */
call  group_wiki  dsgroupwiki                   /* create PIC groups wiki */
call  group_wiki  psgroupwiki                   /* create Programming Groups wiki */

return 0


/* -------------------------------------------------- */
/*  create a PIC - dataset or programmming specs wiki */
/* -------------------------------------------------- */
pic_wiki: procedure expose PicSpec. pdfdir url dsinfo.

parse arg wiki .
if pos('Data',wiki) > 0 then                             /* wiki type */
  type = 'ds'
else
  type = 'ps'

if stream(wiki, 'c', 'query exists') \= '' then
  call SysFileDelete wiki
call stream wiki, 'c', 'open write'                      /* create new */

if type = 'ds' then do
  call lineout wiki, '#summary PICname - Datasheet cross reference'
  say 'Building PICname - DataSheet cross reference'
end
else do
  call lineout wiki, '#summary PICname - Programming Specifications cross reference'
  say 'Building PICname - Programming Specifications cross reference'
end
call lineout wiki, ''
call lineout wiki, '----'
call lineout wiki, ''
if type = 'ds' then
  call lineout wiki, '= PICname - Datasheet cross reference ='
else
  call lineout wiki, '= PICname - Programming Specifications cross reference ='
call lineout wiki, ''
call lineout wiki, '||  *PIC*       || *Number* || *Date* || *Datasheet title* ||'
do i=1 to PicSpec.0                                      /* every Jallib PIC device file */
  PicName = PicSpec.i
  if type = 'ds' then
    dskey = PicSpec.PicName.DATASHEET
  else
    dskey = PicSpec.PicName.PGMSPEC
  if dskey \= '-' then do
    dsnum = dsinfo.dskey.DSNBR                           /* number with suffix */
    if dsinfo.dskey.FDATE \= '' then
      call lineout wiki, '||' left(PicName,12),
                         '|| <a' left('href="'url||dsnum'.pdf">',length(url)+21) right(dsnum,9)'</a>',
                         '||' left(dsinfo.dskey.FDATE, 7),
                         '||' dsinfo.dskey.TITLE '||'
  end
end
call stream wiki, 'c', 'close'
return


/* -------------------------------------------------------- */
/*  create dataset groups or programmming specs groups wiki */
/* -------------------------------------------------------- */
group_wiki: procedure expose PicSpec. pdfdir url dsinfo.

parse arg wiki .

if pos('Pgm', wiki) > 0 then
  type = 'ps'
else
  type = 'ds'

if stream(wiki, 'c', 'query exists') \= '' then
  call SysFileDelete wiki
call stream  wiki, 'c', 'open write'

call charout wiki, '#summary PICs sharing the same '
if type = 'ds' then do
  call lineout wiki, 'datasheet'
  say 'Building PIC datasheet group cross reference'
end
else do
  call lineout wiki, 'programming specifications'
  say 'Building PIC programming specifications group cross reference'
end
call lineout wiki, ''
call lineout wiki, '----'
call lineout wiki, ''

group.0 = 0
ds.0    = 0
do i=1 to PicSpec.0                            /* all entries */
  PicName = PicSpec.i
  if type = 'ds' then
    dskey = PicSpec.PicName.DATASHEET
  else
    dskey = PicSpec.PicName.PGMSPEC
  do j = 1 to ds.0                              /* search in ds array */
    if ds.j = dskey then                        /* found */
      leave
  end
  if j > ds.0 then do                           /* not found */
    ds.j = dskey                                /* add to array */
    ds.0 = j                                    /* count */
    group.j = ''                                /* new group */
    group.0 = j                                 /* count */
  end
  group.j = group.j||PicName' '                 /* append PicName */
end

call charout wiki, '= PICs sharing the same '
if type = 'ds' then
  call lineout wiki, 'datasheet ='
else
  call lineout wiki, 'programming specifications ='
call lineout wiki, '== sorted on datasheet number =='
call lineout wiki, '=== (see below for a list sorted on PIC type) ==='
call lineout wiki, ''
call lineout wiki, '|| *Datasheet* || *Date* || *PICtype* ||'

call sortGroup 'D'
do j = 1 to ds.0                                /* skip group without datasheet */
   dskey = ds.j
   dsnum = dsinfo.dskey.DSNBR
   if dsnum \= '' then
      call lineout wiki,,
             '|| <a' left('href="'url||dsnum'.pdf">', length(url)+21) right(dsnum,9)'</a>',
             '||' left(dsinfo.dskey.FDATE, 7),
             '||' group.j '||'
end

call lineout wiki, ''
call lineout wiki, '----'
call lineout wiki, ''
call charout wiki, '= PICs sharing the same '
if type = 'ds' then
  call lineout wiki, 'datasheet ='
else
  call lineout wiki, 'programming specifications ='
call lineout wiki, '== sorted on PIC type (lowest in the group) =='
call lineout wiki, ''
call lineout wiki, '|| *Datasheet* || *PICtype* ||'

call sortGroup 'P'
do j = 1 to ds.0
   dskey = ds.j
   dsnum = dsinfo.dskey.DSNBR
   if dsnum \= '' then
      call lineout wiki,,
             '|| <a' left('href="'url||dsnum'.pdf">', length(url)+21) right(dsnum,9)'</a>',
             '||' left(dsinfo.dskey.FDATE, 7),
             '||' group.j '||'
end
call lineout wiki, ''
call lineout wiki, '----'
call stream  wiki, 'c', 'close'
return 0


/* ------------------------------------------------ */
/*  sort array on Datasheet or PicName              */
/* ------------------------------------------------ */
sortGroup: procedure expose group. ds.

parse arg sorttype                              /* 'D' or 'P' expected */
do i=1 to ds.0 - 1                              /* number of sort cycles */
  do j=1 to ds.0 - i                            /* all but last sorted */
    k = j + 1
    if sorttype = 'D' & ds.j > ds.k |,
       sorttype = 'P' & word(group.j,1) > word(group.k,1)
          then do                               /* highest is shifted right */
      tmp = ds.k
      ds.k = ds.j                               /* exchange records */
      ds.j = tmp
      tmp = group.k
      group.k = group.j                         /* exchange records */
      group.j = tmp
    end
  end
end
return


/* --------------------------------------------------- */
/* Read file with Device Specific data                 */
/* Interpret contents: fill compound variable PicSpec. */
/* --------------------------------------------------- */
read_dsinfo: procedure expose dslist dsinfo. pdfdir
if stream(dslist, 'c', 'open read') \= 'READY:' then do
  say 'Could not open' dslist
  return
end
dsinfo. = ''
do while lines(dslist)
  parse value linein(dslist) with dsnum dstitle
  dskey = left(dsnum,length(dsnum)-1)                    /* strip suffix */
  dsinfo.dskey.DSNBR = strip(dsnum)
  dsinfo.dskey.TITLE = strip(dstitle)
  dspath = pdfdir||dsnum'.pdf'
  filedate = word(stream(dspath, 'c', 'query datetime'), 1)
  if filedate = '' then
    say 'Datasheet' dsnum 'listed in' dslist 'not found'
  else
    dsinfo.dskey.FDATE = '20'right(filedate,2)'/'left(filedate,2)
end
call stream dslist, 'c', 'close'
return



/* --------------------------------------------------- */
/* Read file with Device Specific data                 */
/* Interpret contents: fill compound variable PicSpec. */
/* --------------------------------------------------- */
read_devspec: procedure expose PicSpecFile PicSpec.
if stream(PicSpecFile, 'c', 'open read') \= 'READY:' then do
  Say '  Error: could not open file with device specific data' PicSpecFile
  exit 1                                        /* zero records */
end
call charout , 'Reading device specific data items from' PicSpecFile '... '
do until x = '{' | x = 0                /* search begin of pinmap */
  x = json_newchar(PicSpecFile)
end
PicSpec.0 = 0
do until x = '}' | x = 0                /* end of pinmap */
  do until x = '}' | x = 0              /* end of pic */
    PicName = json_newstring(PicSpecFile)  /* new PIC */
    i = PicSpec.0 + 1
    PicSpec.i = PicName
    PicSpec.0 = i
    do until x = '{' | x = 0            /* search begin PIC specs */
      x = json_newchar(PicSpecFile)
    end
    do until x = '}' | x = 0            /* this PICs specs */
      ItemName = json_newstring(PicSpecFile)
      value = json_newstring(PicSpecFile)
      PicSpec.PicName.ItemName = value
      x = json_newchar(PicSpecFile)
    end
    x = json_newchar(PicSpecFile)
  end
  x = json_newchar(PicSpecFile)
end
call stream PicSpecFile, 'c', 'close'
say 'done!'
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
x = json_newchar(jsonfile)                  /* first char */
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
  if x <= ' ' then                          /* white space */
    iterate
  return x
end
return 0                                    /* dummy */


