/* ----------------------------------------------------------------------- */
/* CreatePinMap.cmd - creeate 'pinmap.py' from MPLAB-X                     */
/* This script is part of a project using MPLAB-X info for Jallib,         */
/* in particular device files.                                             */
/* This script uses the .edc files created by the pic2edc script.          */
/* The PinList section of these files contains the pin aliases.            */
/* Some manipulations are needed, for example skip pins which are not      */
/* accessible from the program (like Vpp, Vdd, etc), finding the           */
/* the base name of a pin an correctiong some Microchip quircks.           */
/* See for more info the comments in the scripts pic2edc and edc2jal.      */
/* ----------------------------------------------------------------------- */

mplabxversion = '185'
edcdir  = 'k:\jal\pic2jal\edc.'mplabxversion
Listing  = 'pinmap.py'                      /* output */

parse arg selection .
if selection \= '' then
  wildcard = selection'.edc'                /* selection */
else
  wildcard = '*.edc'                        /* all */

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                       /* load REXX functions */

if SysFileTree(edcdir'\'wildcard, dir, 'FOS') != 0 then do
  say 'Problem collecting file list of directory' edcdir
  return 1
end
if dir.0 = 0 then do
  say 'No appropriate files matching "'wildcard'" found in directory' edcdir
  return 1
end

say 'Generating PinMap file from' edcdir 'for (max)' dir.0 'Pics'

call SysFileDelete Listing
call stream Listing, 'c', 'open write'
call lineout Listing, 'pinmap = {'

PicCount = 0

do i=1 to dir.0                                 /* all files */
    parse upper value filespec('N', dir.i) with PicName '.EDC'
   if PicName = '' then do
      Say 'Error: Could not derive PIC name from filespec: "'dir.i'"'
      iterate                                     /* next entry */
   end
   if stream(dir.i, 'c', 'open read') \= 'READY:' then do
      Say 'Error: Could not open file' dir.i
      iterate
   end

   do while lines(dir.i) & word(ln,1) \= '<EDC:PINLIST>'     /* search start */
      ln = linein(dir.i)
   end

   if lines(dir.i) = 0 then do
      say 'No PinList found for' PicName
      iterate
   end

   PicHeader = " '"PicName"': {"                     /* Pic header */
   call charout Listing, PicHeader

   PicCount = PicCount + 1

   do while lines(dir.i) & word(ln,1) \= '</EDC:PINLIST>'
      ln = linein(dir.i)
      if word(ln,1) = '<EDC:PIN>' then do
         pinalias.0 = 0

         do while word(ln,1) \= '</EDC:PIN>'
            ln = linein(dir.i)
            parse var ln '<EDC:VIRTUALPIN' 'EDC:NAME="' val1 '"' .
            if val1 \= '' then do
               val1 = strip(val1, 'B', '_')           /* remove underscore(s)  Microchip quirck! */
               if (val1         = 'AVDD'     |,
                   val1         = 'AVSS'     |,
                   val1         = 'VBAT'     |,
                   val1         = 'VCAP'     |,
                   val1         = 'VDD'      |,
                   val1         = 'VDDCORE'  |,
                   left(val1,4) = 'VSEL'     |,
                   val1         = 'VSS'      |,
                   val1         = 'VUSB'     |,
                   val1         = 'NC')    then do
                  pinalias.0 = 0                   /* empty: irrelevant pin */
                  leave                            /* skip rest, process next pin */
               end
               else if left(val1,2) = 'GP' then do      /* modify GP -> RA */
                  val1 = 'RA'right(val1,1)
               end
               else if left(val1,2) = 'RB'  &  left(PicName,2) = '12' then do
                  k = pinalias.0 + 1
                  pinalias.k = 'GP'right(val1,1)   /* add 'GPx' */
                  pinalias.0 = k
                  val1 = 'RA'right(val1,1)         /* modify RBx -> RAx */
               end
               if \(val1 = 'IOC'    |,             /* skip pseudo pin-aliases */
                    val1 = 'INT') then do
                  k = pinalias.0 + 1
                  pinalias.k = val1
                  pinalias.0 = k
               end
            end
         end

         if pinalias.0 > 0 then do
            do k = 1 to pinalias.0                 /* search base name ('Rxy') */
               if length(pinalias.k) = 3    &,
                  left(pinalias.k,1) = 'R'  &,
                  datatype(right(pinalias.k,1)) = 'NUM' then do
                  leave                            /* found! */
               end
            end
            if k <= pinalias.0 then do             /* base name found */
               call charout Listing, "'"pinalias.k"': ["    /* base name */
               call charout Listing, "'"pinalias.1"'"       /* first alias */
               do k = 2 to pinalias.0                       /* other aliases */
                  call charout Listing, ", '"pinalias.k"'"
               end
               call lineout Listing, "],"                   /* end of line */
               call charout Listing, copies(' ', length(PicHeader))
            end
         end
      end
   end
   if i < dir.0 then
      call lineout Listing, "},"                   /* not the last PIC */
   else
      call lineout Listing, "}"

   call stream dir.i, 'c', 'close'                 /* done with this PIC */

end

call lineout Listing, '  }'
call lineout Listing, ''
call stream listing, 'c', 'close'

say 'Generated PinMap file for' PicCount 'Pics'

return 0


