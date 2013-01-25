/* ---------------------------------------------------------------------------- */
/* CreateDSwikis.cmd - create wiki tables:                                      */
/*                     * Datasheet                                              */
/*                     * Programming Specifications                             */
/*                     * PICs with the same Datasheet                           */
/*                     * PICs with the same Programming Specifications          */
/*                                                                              */
/* Notes: - Only PICs for which a Jallib device file is available.              */
/*        - Script can be run on any platform which supports Rexx.              */
/*          See for a 'howto' devicefiles.html and the comments in dev2jal.cmd  */
/* ---------------------------------------------------------------------------- */

parse upper arg runtype .

/* -- input files (change for other systems or platforms) -- */
if runtype  = 'TEST' then
   jaldir   = 'k:/jal/dev2jal/test/'                /* dir with test device files */
else
   jaldir   = 'k:/jallib/include/device/'           /* dir with production device files */
pdfdir      = 'n:/picdatasheets/'                   /* dir with datasheets (local)  */
PicSpecFile = 'k:/jallib/tools/devicespecific.json' /* PIC specific properties      */
titles      = 'k:/jallib/tools/datasheet.list'      /* datasheet number/title file  */

/* -- output -- */
dswiki      = 'k:/jallib/wiki/DataSheets.wiki'      /* out: DS wiki */
pswiki      = 'k:/jallib/wiki/ProgrammingSpecifications.wiki'    /* out: PS wiki */
dsgroupwiki = 'k:/jallib/wiki/PicGroups.wiki'
psgroupwiki = 'k:/jallib/wiki/PicPgmGroups.wiki'

url         = 'http://ww1.microchip.com/downloads/en/DeviceDoc/' /* Microchip site  */

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                               /* load REXX functions */

if SysFileTree(jaldir'1*.jal', dir, 'FO') != 0 then do
  say 'Problem collecting file list of directory' jaldir
  return 1
end
if dir.0 < 1 then do
  say 'No appropriate PIC .dev files found in directory' jaldir
  return 1
end

call SysStemSort 'dir.', 'A', 'I'               /* sort ascending, case independent */

PicSpec. = '?'
call read_picspec                               /* obtain device specific info */

call  pic_wiki    dswiki                        /* PIC -> datasheet wiki */
call  pic_wiki    pswiki                        /* PIC -> Programming Specifications wiki */
call  group_wiki  dsgroupwiki                   /* create PIC groups wiki */
call  group_wiki  psgroupwiki                   /* create Programming Groups wiki */

return 0


/* -------------------------------------------------- */
/*  create a PIC - dataset or programmming specs wiki */
/* -------------------------------------------------- */
pic_wiki: procedure expose dir. PicSpec. titles pdfdir url

parse arg wiki .

if pos('ProgrammingSpecifications',wiki) > 0 then    /* select wiki type */
  type = 'ps'
else
  type = 'ds'

if stream(wiki, 'c', 'query exists') \= '' then
  call SysFileDelete wiki
call stream wiki, 'c', 'open write'                 /* create new */

if type = 'ps' then do
  say 'Building PICname - Programming Specifications cross reference'
  call lineout wiki, '#summary PICname - Programming Specifications cross reference'
end
else do
  call lineout wiki, '#summary PICname - Datasheet cross reference'
  say 'Building PICname - DataSheet cross reference'
end
call lineout wiki, ''
call lineout wiki, '----'
call lineout wiki, ''
if type = 'ps' then
  call lineout wiki, '= PICname - Programming Specifications cross reference ='
else
  call lineout wiki, '= PICname - Datasheet cross reference ='
call lineout wiki, ''
call lineout wiki, '||  *PIC*       || *Number* || *datasheet title* ||'

do i=1 to dir.0                                /* a line for every Jallib PIC device file */

  parse upper value filespec('Name', dir.i) with  PicName '.JAL'
  if PicName = '' then do
    Say 'Error: Could not derive PIC name from filespec: "'dir.i'"'
    leave                                       /* terminate */
  end

  if type = 'ds' then
    DS = PicSpec.PicName.DataSheet
  else
    DS = PicSpec.PicName.PgmSpec

  if DS \= '-'  &  DS \= '?' then do
    call SysFileSearch DS, titles, dsnum.               /* lookup ds# & title */
    if dsnum.0 > 0 then do
      call lineout wiki, '||' left(PicName,12),
                         '|| <a href="'url||left(word(dsnum.1,1)'.pdf">',12)left(word(dsnum.1,1),6)'</a>',
                         '||'delword(dsnum.1,1,1) '||'
      call SysFileTree pdfdir||word(dsnum.1,1).pdf, 'dsfile', 'FO'
      if dsfile.0 = 0 then                              /* check on presence */
        say 'Datasheet' dsnum.1 'not found in' pdfdir
    end
    else do
      call lineout wiki, '||' left(PicName,12),
                         '||' left(DS,6),
                         '|| - ||'
    end
  end
  else                                      /* no datasheet number found */
    call lineout wiki, '||' left(PicName,12),
                       '||' left('-',6),
                       '|| - ||'

  call stream dir.i, 'c', 'close'

end

call stream wiki, 'c', 'close'

return

/* -------------------------------------------------------- */
/*  create dataset groups or programmming specs groups wiki */
/* -------------------------------------------------------- */
group_wiki: procedure expose dir. PicSpec. titles url

parse arg wiki .

if pos('Pgm', wiki) > 0 then
  type = 'ps'
else
  type = 'ds'

if stream(wiki, 'c', 'query exists') \= '' then
  call SysFileDelete wiki
call stream  wiki, 'c', 'open write'

call charout wiki, '#summary PICs sharing the same '
if type = 'ds' then
  call lineout wiki, 'datasheet'
else
  call lineout wiki, 'programming specifications'
call lineout wiki, ''
call lineout wiki, '----'
call lineout wiki, ''

group.0 = 0
ds.0    = 0

do i=1 to dir.0                                /* all entries */
  parse upper value filespec('Name', dir.i) with  PicName '.JAL'
  if PicName = '' then do
    Say 'Error: Could not derive PIC name from filespec: "'dir.i'"'
    iterate                                     /* next entry */
  end

  if type = 'ds' then
    Sheet = PicSpec.PicName.DataSheet
  else
    Sheet = PicSpec.PicName.PgmSpec
  if Sheet = '-' then
    Sheet = '_missing_'                         /* no datasheet */

  do j = 1 to ds.0                              /* search in ds array */
    if ds.j = Sheet then                        /* found */
      leave
  end

  if j > ds.0 then do                           /* not found */
    ds.j = Sheet                                /* add to array */
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
call lineout wiki, '|| *Datasheet* || *PICtype* ||'

PicCount = 0
call sortGroup 'D'
do j = 1 to ds.0
  call SysFileSearch ds.j, titles, dsnum.
  if dsnum.0 > 0 then
    call lineout wiki,,
                '|| <a href="'url||word(dsnum.1,1)'.pdf">'word(dsnum.1,1)'</a>',
                '||' group.j '||'
  else
    call lineout wiki, '||' left(ds.j,11) '||' group.j '||'
  PicCount = PicCount + words(group.j)
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
  call SysFileSearch ds.j, titles, dsnum.
  if dsnum.0 > 0 then do
    call lineout wiki,,
                '|| <a href="'url||word(dsnum.1,1)'.pdf">'word(dsnum.1,1)'</a>',
                '||' group.j '||'
  end
  else do
    call lineout wiki, '||' left(ds.j,11) '||' group.j '||'
  end
end
call lineout wiki, ''
call lineout wiki, '----'

call lineout wiki, ''
call lineout wiki, PicCount 'PICs in' group.0 'groups.'
call stream  wiki, 'c', 'close'

say type 'group wiki created.'

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
read_picspec: procedure expose PicSpecFile PicSpec.
if stream(PicSpecFile, 'c', 'open read') \= 'READY:' then do
  Say '  Error: could not open file with device specific data' PicSpecFile
  exit 1                                        /* zero records */
end
call charout , 'Reading device specific data items from' PicSpecFile '... '
do until x = '{' | x = 0                /* search begin of pinmap */
  x = json_newchar(PicSpecFile)
end
do until x = '}' | x = 0                /* end of pinmap */
  do until x = '}' | x = 0              /* end of pic */
    PicName = json_newstring(PicSpecFile)  /* new PIC */
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


