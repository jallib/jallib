/* -----------------------------------------------------------------------  *
 * Title: Pic2edc.cmd - expand .pic files to '.edc' files                   *
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
 *   Rexx script to expand MPlab-X .pic files.                              *
 *   This includes:                                                         *
 *   - translate tab chars to blanks                                        *
 *   - remove module import section(s)                                      *
 *   - handle Module_Ref statements and                                     *
 *     process ModuleMacro and ModuleExclude statements                     *
 *   - translate everything to uppercase                                    *
 *   The resulting files are targets for the Edc2jal script.                *
 *                                                                          *
 * Sources:  MPLAB-X .pic files, which can be found in:                     *
 * Program Files (x86)\Microchip\mplabx\mplab_ide\bin\lib\crownking.edc.jar *
 * and after unZIPping this file in .\content\edc\*                         *
 *                                                                          *
 * Notes:                                                                   *
 *   - This script is written in 'classic' Rexx executed on eComStation     *
 *     See Notes with Edc2jal script for running it on other platforms      *
 *                                                                          *
 * ------------------------------------------------------------------------ */
   ScriptVersion   = '0.0.14'
   ScriptAuthor    = 'Rob Hamerling'
   mplabxversion   = '185'
/* ------------------------------------------------------------------------ */

/* 'msglevel' controls the amount of messages being generated */
/*   0 - progress messages, info, warnings and errors         */
/*   1 - info, warnings and errors                            */
/*   2 - warnings and errors                                  */
/*   3 - errors (always reported!)                            */

msglevel = 0

/* 'debuglevel' controls specific debug info                  */
/*   0 - no debugging output                                  */
/*   1 - debugging output of /pic file reading / expansion    */

debuglevel = 0

/* MPLAB-X should be installed.                                                */
/* The .PIC files used are in [basedir]/MPLAB_IDE/BIN/LIB/CROWNKING.EDC.JAR.   */
/* This file must be expanded (unZIPped) to obtain the individual .pic files.  */
/* For any system or platform the following base information must be           */
/* specified as a minimum.                                                     */

MplabXbase = 'k:/MPlab-X_'mplabxversion'/'         /* directory of the */
                                                   /* unzipped crownking.jar file */

/* The following directories are used to collect information */
/* from MPLAB-X .pic files:                                  */

picdir = MplabXbase'crownking.edc.jar/content/edc'          /* dir with MPLAB .pic  */
moddir = picdir'/module'                                    /* dir with module files */

call msg 0, 'Pic2edc version' ScriptVersion '  -  ' ScriptAuthor '  -  ' date('N')';' time('N')
if msglevel > 2 then
   call msg 0, 'Only reporting errors!'

/* The optional first commandline argument designates for which PICs        */
/* must be processed.                                                       */
/* The selection may contain wildcards like '18LF*', default is '*' (all).  */
/* Regardless the selection only flash PICs are processed.                  */

parse upper arg selection .                                 /* commandline arguments */

if selection = '' then                                      /* no selection spec'd */
   wildcard = 'PIC1*.pic'                                   /* default (8 bit PICs) */
else                                                        /* selection */
   wildcard = 'PIC'selection'.pic'                          /* accept user selection */

call msg 0, 'Expanding .pic files of  MPLAB-X version' mplabxversion/100

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                                           /* load Rexx utilities */

call SysFileTree picdir'/'wildcard, dir, 'FOS'              /* get list of matching files */
if dir.0 = 0 then do
   call msg 3, 'No .pic files found matching <'wildcard'> in' picdir
   return 0                                                 /* nothing to do */
end

signal on syntax name catch_syntax                          /* catch syntax errors */
signal on error  name catch_error                           /* catch execution errors */

versionfile = 'MPLAB-X-VERSION.'mplabxversion               /* this version of .edc files */
call SysFileDelete versionfile                              /* delete existing file */
call lineout versionfile, 'MPlab-X version' mplabxversion/100
call stream versionfile, 'c', 'close'

call SysStemSort 'dir.', 'A', 'I'                           /* sort on name */

do i = 1 to dir.0                                           /* all relevant .pic files */
                                                            /* init for each new PIC */
   PicFile = tolower(translate(dir.i,'/','\'))              /* lower case + forward slashes */
   parse value filespec('Name', PicFile) with 'pic' PicName '.pic'
   if PicName = '' then do
      call msg 3, 'Could not derive PIC name from filespec: "'PicFile'"'
      leave                                                 /* setup error: terminate */
   end

   if \(substr(PicName,3,1) = 'f'    |,                     /* not flash PIC or */
        substr(PicName,3,2) = 'lf'   |,                     /*     low power flash PIC or */
        substr(PicName,3,2) = 'hv')  |,                     /*     high voltage flash PIC */
      PicName = '16hv540'     then do                       /* OTP */
      iterate                                               /* skip */
   end

   call msg 0, PicName                                      /* progress signal */

   PicNameCaps = toupper(PicName)                           /* name of PPIC in upper case */

   Pic. = ''                                                /* reset .pic file contents */
   Mod. = ''                                                /* reset .module file contents */
   if file_read_pic(PicFile) = 0 then                       /* expand MPLAB-X .pic file */
      iterate                                               /* error with read */

   edcfile = 'edc.'mplabxversion'\'Picname'.edc'            /* expanded .pic file */
   call SysFileDelete edcfile                               /* delete existing file */
   do j = 1 to Pic.0
      call lineout edcfile, line_cleanup(Pic.j)             /* output clean line */
   end
   call stream edcfile, 'c', close                          /* done with .edc file */

end

signal off error
signal off syntax                                           /* restore to default */

call SysDropFuncs                                           /* release Rexxutil */

return 0


/* ------------------------------------------- */
/* cleanup output line:                        */
/* - all upper case                            */
/* - replace tab-chars by spaces               */
/* ------------------------------------------- */
line_cleanup: procedure expose PicName
parse arg ln
ln = translate(ln)                                          /* whole line uppercase */
ln = translate(ln, ' ', '09'x)                              /* tabs -> space */
return ln


/* ------------------------------------------- */
/* Read .pic file contents into stem variable  */
/* input: MPLAB-X .pic file                    */
/* ------------------------------------------- */
file_read_pic: procedure expose Pic. Mod. moddir msglevel debuglevel
parse arg PicFile .

if stream(PicFile, 'c', 'open read') \= 'READY:' then do
   call msg 3, 'Could not open .pic file' PicFile
   return 0                                                 /* zero records */
end

Pic.0 = 0
do while lines(PicFile) > 0                                 /* read whole file */

   ln = translate(linein(PicFile), ' ', '09'x)              /* tabs -> spaces */

   if word(ln,1) = '<edc:Import>' then do                   /* import section */
      do while word(ln,1) \= '</edc:Import>'                /* to be skipped completely */
         ln = translate(linein(PicFile), ' ', '09'x)
      end
      iterate
   end

   i = Pic.0 + 1                                            /* new line */
   Pic.i = ln                                               /* raw data (mixed case) */
   Pic.0 = i                                                /* # stored lines */
   if word(Pic.i,1) = '<edc:Module_ref' then do
      parse var Pic.i '<edc:Module_ref' val0 'edc:modsrc="' val1 '"' .
      if val1 \= '' then do
         sela = ''
         selz = ''
         if val0 \= '' then do                              /* partial include */
            parse var val0 with 'edc:begin="' sela '"' 'edc:end="' selz '"' .
            if sela \= '' then do
               if left(sela,2) = '0x' then
                  sela = X2D(substr(sela,3))                /* decimal begin */
               if left(selz,2) = '0x' then
                  selz = X2D(substr(selz,3))                /* decimal end */
            end
         end

         Mod. = ''                                          /* new Module file contents */
         call file_read_module val1                         /* read module file */
         if right(pic.i,2) = '/>' then do                   /* read whole file unmodified */
            Pic.0 = Pic.0 - 1                               /* remove module_ref line */

            call module_copy_selection sela selz            /* copy (part of) modified module */

         end
         else do                                            /* modifications expected */
            do while word(Pic.i,1) \= '</edc:Module_ref>'
               Pic.i = translate(linein(PicFile), ' ', '09'x)
               if word(Pic.i,1) = '<edc:ModuleMacro' then do
                  parse var Pic.i '<edc:ModuleMacro' ,
                                   'edc:replace="' val1 '"' 'edc:with="' val2 '"' .
                  if val1 \= '' then do
                     call file_macro_module val1 val2       /* modify module file */
                  end
               end
               else if word(Pic.i,1) = '<edc:ModuleExclude' then do
                  parse var Pic.i '<edc:ModuleExclude' ,
                                   'edc:impl="0x' val1 '"' 'edc:offset="' val2 '"' .
                  if val1 \= '' then do
                     if left(val2,2) = '0x' then
                        val2 = X2D(substr(val2,3))          /* take decimal value */
                     call file_exclude_module right(val1,2,'0') val2   /* modify module file */
                  end
               end
            end
            Pic.0 = Pic.0 - 1                               /* remove module_ref line */

            call module_copy_selection sela selz            /* copy (part of) modified module */

         end
      end
   end
end
call stream PicFile, 'c', 'close'                           /* done */
return Pic.0


/* -------------------------------------------------- */
/* append [selection] of [modified] module to Pic.    */
/* input: first and last SFR offset in module         */
/* -------------------------------------------------- */
module_copy_selection: procedure expose Pic. Mod. msglevel debuglevel
parse arg first last .
if debuglevel = 1 then
   call msg 0, 'module_copy_selection <'first'>..<'last'>'

SFRcount = -1                                               /* start value */
do j = 1 until SFRcount >= first
   if word(Mod.j,1) = '<edc:SFRDef' then
      SFRcount = SFRCount + 1
end
j = j - 1

do until SFRcount >= last  |  j > Mod.0
   if word(Mod.j,1) = '<edc:JoinedSFRDef' then do
      do while word(Mod.j,1) \= '</edc:JoinedSFRDef>'        /* whole joined SFR */
         if Mod.j \= '' then do
            i = Pic.0 + 1
            Pic.i = Mod.j
            Pic.0 = i
            if debuglevel = 2 then
               call msg 0, 'c' i'.' Pic.i
            if word(Mod.j,1) = '<edc:SFRDef' then do
               SFRcount = SFRCount + 1
            end
         end
         j = j + 1
      end
   end
   else if word(Mod.j,1) = '<edc:SFRDef' then do
      SFRcount = SFRCount + 1
      do while word(Mod.j,1) \= '</edc:SFRDef>'              /* whole SFR */
         if Mod.j \= '' then do
            i = Pic.0 + 1
            Pic.i = Mod.j
            if debuglevel = 2 then
               call msg 0, 'c' i'.' Pic.i
            Pic.0 = i
         end
         j = j + 1
      end
   end
   i = Pic.0 + 1
   Pic.i = Mod.j
   if debuglevel = 2 then
      call msg 0, 'c' i'.' Pic.i
   Pic.0 = i
   j = j + 1
end
return


/* -------------------------------------------------- */
/* Read .module file contents into stem variable      */
/* input: module name                                 */
/* -------------------------------------------------- */
file_read_module: procedure expose Mod. moddir msglevel debuglevel
parse arg ModFile .
if debuglevel = 2 then
   call msg 0, 'file_read_module' ModFile
ModFile = moddir'/'ModFile
if stream(ModFile, 'c', 'open read') \= 'READY:' then do
   call msg 3, 'Could not open .module file' ModFile
   return 0                                              /* zero records */
end

Mod. = ''
Mod.0 = 0

do while lines(ModFile) > 0                              /* whole module */
   ln = translate(linein(ModFile), ' ', '09'x)
   if left(word(ln,1),2) = '<?' then                     /* skip xml */
      nop
   else if word(ln,1) = '<edc:ArchDef>' then do        /* skip archdef */
      do until word(ln,1) = '</edc:ArchDef>'
         ln = translate(linein(ModFile), ' ', '09'x)
      end
   end
   else do
      i = Mod.0 + 1
      Mod.i = ln                                            /* store line */
      Mod.0 = i
   end
end
call stream ModFile, 'c', 'close'                        /* done */

if debuglevel = 1 then do
   do i = 1 to Mod.0
      call msg 0, 'r' i'.' Mod.i
   end
end

return


/* ---------------------------------------------- */
/* Modify module file contents                    */
/* input: - string to be replaced                 */
/*        - string to replaced the old string     */
/* ---------------------------------------------- */
file_macro_module: procedure expose Mod. msglevel debuglevel
parse arg sold snew .
if debuglevel = 1 then
   call msg 0, 'file_macro_module' sold '-->' snew
do i = 1 to Mod.0                                           /* all lines */
   k = pos(sold, Mod.i)                                     /* first occurence */
   do while k > 0
      Mod.i = delstr(Mod.i, k, length(sold))                /* remove old string and .. */
      Mod.i = insert(snew, Mod.i, k - 1)                    /* .. replace it by new string */
      k = pos(sold, Mod.i)                                  /* next occurence */
   end
end

if debuglevel = 1 then do
   do i = 1 to Mod.0
      call msg 0, 'm' i'.' Mod.i
   end
end

return


/* ---------------------------------------------- */
/* Modify module file contents                    */
/* input: - impl-mask (2 hex chars)               */
/*        - SFR offset (decimal)                  */
/* ---------------------------------------------- */
file_exclude_module: procedure expose Mod. msglevel debuglevel
parse arg impl offset .
if debuglevel = 2 then
   call msg 0, 'file_exclude_module' impl offset
addrx = 0                                                  /* offset counter */
do i = 1 while i < Mod.i  & addrx < offset                 /* search SFR */
   if word(Mod.i,1) = '<edc:AdjustPoint' then do            /* addrx adjustment */
      parse var Mod.i '<edc:AdjustPoint edc:offset="' val1 '"' .
      if val1 \= '' then do
         if left(val1,2) = '0x' then
            val1 = X2D(substr(val1,3))
         addrx = addrx + val1                               /* adjust */
      end
   end
   else if word(Mod.i,1) = '<edc:SFRDef' then do            /* SFR */
      if addrx = offset then
         leave                                              /* this is the one! */
      do i = i while word(Mod.i,1) \= '</edc:SFRDef>'       /* skip rest of SFR */
         nop
      end
      addrx = addrx + 1
   end
end
if debuglevel = 2 then do
   say 'i =' i  'addrx =' addrx  'offset =' offset
end

if i > mod.0 then do
   call msg 3, i 'offset ('offset') greater than included SFRs in module ('addrx')'
   return
end

do while i < Mod.i & word(Mod.i,1) \= '</edc:SFRDef>'          /* all of this SFR */
   if impl = '00' then do                          /* whole SFR to be excluded */
      Mod.i =  '    <edc:AdjustPoint edc:offset="1"/>'  /* insert replacement */
      i = i + 1
      do while word(Mod.i,1) \= '</edc:SFRDef>'
         Mod.i = ''                                /* remove remainder of this SFR */
         i = i + 1
      end
      Mod.i = ''                                   /* last line of SFRDef */
      leave                                        /* all done */
   end
   else do                                         /* partial exclude */
      j = 0                                        /* init bit offset */
      do while word(Mod.i,1) \= '</edc:SFRModeList>'
         if word(Mod.i,1) = '<edc:SFRMode' then do   /* new subfield group */
            j = 0                                  /* bit number */
         end
         else if word(Mod.i,1) = '<edc:AdjustPoint' then do   /* address adjustment */
            parse var Mod.i '<edc:AdjustPoint' 'edc:offset="' val1 '"' .
            if val1 \= '' then do
               if left(val1,2) = '0x' then
                  val1 = X2D(substr(val1,3))
               j = j + val1                        /* adjust bit number */
            end
         end
         else if word(Mod.i,1) = '<edc:SFRFieldDef' then do   /* subfield */
            parse var Mod.i '<edc:SFRFieldDef' . 'edc:mask="0x' val1 '"' .,
                            'edc:nzwidth="' val2 '"' .
            if left(val2,2) = '0x' then            /* hex value */
               val2 = X2D(substr(val2,3))          /* make decimal */
            if val2 = 1 then do                    /* single bit */
               testmask = right(left('1',1+j,'0'),8,'0')
               fieldmask = right(X2B(impl),8,'0')
               if debuglevel = 2 then do
                  call msg 0, j'.' testmask fieldmask val1 val2
               end
               if BITAND(testmask,fieldmask) = '00000000' then do
                  Mod.i =  '          <edc:AdjustPoint edc:offset="1"/>'  /* repl. */
               end
               j = j + 1
            end
            else if val2 <= 8 then do
               testmask = right(X2B(val1)||copies('0',j),8,'0')      /* 8 bits */
               fieldmask = right(X2B(impl),8,'0')     /* 8 bits */
               if debuglevel = 2 then do
                  call msg 0, j'.' testmask fieldmask val1 val2
               end
               if BITAND(testmask,fieldmask) = '00000000' then do
                  Mod.i =  '          <edc:AdjustPoint edc:offset="'val2'"/>'
               end
               j = j + val2
            end
            else do
               call msg 2, 'line' i 'exclude mask' val1 'larger than 8 bits ('val2')'
               call msg 0, Mod.i
            end
         end
         i = i + 1                                 /* next module line */
      end
      leave
   end
   i = i + 1                                       /* next module line */
end

if debuglevel = 2 then do
   do i = 1 to Mod.0
      call msg 0, 'e 'i'.'  Mod.i
   end
end

return



/* ---------------------------------------------- */
/* translate string to lower or upper case        */
/* ---------------------------------------------- */

tolower:
return translate(arg(1), xrange('a','z'), xrange('A','Z'))

toupper:
return translate(arg(1), xrange('A','Z'), xrange('a','z'))


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


