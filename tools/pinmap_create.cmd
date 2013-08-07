/* ----------------------------------------------------------------------- */
/* Create_PinMap.cmd - create 'pinmap.py' from MPLAB-X                     */
/* This script is part of a sub-project using MPLAB-X info for Jallib,     */
/* in particular the device files.                                         */
/* This script uses the .edc files created by the pic2edc script.          */
/* The PinList section of these files contains the pin aliases.            */
/* Some manipulations are needed, for example skip pins which are not      */
/* accessible from the program (like Vpp, Vdd, etc), finding the           */
/* the base name of a pin and correctiong some errors in MPLAB-X.          */
/* The hard coded corrections are valid for a specific version of MPLAB-X, */
/* for other versions it may need be modified.                             */
/* See for more info the comments in the scripts pic2edc and edc2jal.      */
/* ----------------------------------------------------------------------- */

mplabxversion = 185                          /* will be checked! */

say 'Generating file pinmap.py'

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs                       /* load REXX functions */

Call SysFileTree 'MPLAB-X-VERSION.*', 'dir.', 'FO'           /* search mplab-x version */
if dir.0 = 0 then do
   say 'Could not find the MPLAB-X-VERSION file'
   return 2
end
if right(dir.1,3) \= mplabxversion then do
  say 'WARNING: This script is aimed at MPLAB-X' mplabxversion
  say '         It may need modification for version:' right(dir.1,3)/100
end
edcdir  = 'k:\jal\pic2jal\edc.'mplabxversion

parse arg selection .
if selection \= '' then
  wildcard = selection'.edc'                 /* selection */
else
  wildcard = '*.edc'                         /* all */

if SysFileTree(edcdir'\'wildcard, dir, 'FOS') != 0 then do
  say 'Problem collecting file list of directory' edcdir
  return 1
end
if dir.0 = 0 then do
  say 'No appropriate files matching "'wildcard'" found in directory' edcdir
  return 1
end

say 'Scanning .edc files in' edcdir 'for (max)' dir.0 'PICs'

Listing  = 'pinmap.py'                      /* output */

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

            parse var ln '<!--' 'PIN' val1 .
            if val1 \= '' then do
               pinnumber = val1
            end

            parse var ln . '<EDC:VIRTUALPIN' 'EDC:NAME="' val1 '"' .
            if val1 \= '' then do
               val1 = strip(val1, 'B', '_')           /* remove underscore(s)  Microchip quirck! */
               if (val1         = 'AVDD'     |,
                   val1         = 'AVSS'     |,
                   val1         = 'VBAT'     |,
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
                  pinalias.k = 'GP'right(val1,1)            /* add 'GPx' */
                  pinalias.0 = k
                  val1 = 'RA'right(val1,1)                  /* modify RBx -> RAx */
               end
               else if val1 = 'RC7AN9' then do              /* MPLAB-X error with 16f1828/9 + LF */
                  k = pinalias.0 + 1
                  pinalias.k = left(val1,3)                 /* add 'RC7' */
                  pinalias.0 = k
                  val1 = right(val1,3)                      /* AN9 */
               end
               else if PicName = '16F722' & val1 = 'VREF' then do    /* error with 16f722 */
                  k = pinalias.0 + 1
                  pinalias.k = 'RA3'                        /* add 'RA3' */
                  pinalias.0 = k
                  val1 = val1
               end
               else if (PicName = '18F2439' | PicName = '18F2539' |,
                        PicName = '18F4439' | PicName = '18F4539')  &,
                    left(val1,3) = 'PWM' then do            /* error with 18f2439 and others */
                  k = pinalias.0 + 1
                  pinalias.k = 'RC'right(val1,1)            /* add 'RCx' */
                  pinalias.0 = k
                  val1 = val1
               end
               else if (PicName = '18F4220' | PicName = '18F4320') &,
                    pinnumber = 36 then do
                  pinalias.1 = 'RB3'                        /* add whole pin */
                  pinalias.2 = 'AN9'
                  pinalias.3 = 'CCP2'
                  pinalias.0 = 3
                  do while word(ln,1) \= '</EDC:PIN>'       /* skip rest of this pin */
                     ln = linein(dir.i)
                  end
                  leave                                     /* leave do-loop */
               end
               else if (PicName = '18F86J11' | PicName= '18F86J16' |,
                        PicName = '18F87J11') &,
                       val1 = 'ECCP2' then do
                  k = pinalias.0 + 1
                  pinalias.k = 'RB3'                        /* add 'RB3' */
                  pinalias.0 = k
                  val1 = val1
               end

               if \(val1 = 'IOC'    |,                      /* skip pseudo pin-aliases */
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

   if PicName = '16F753' | PicName = '16HV753' then do        /* missing pins */
      call lineout Listing, "'RC0': ['RC0', 'AN4', 'OPA1IN+', 'C2IN0+'],"
      call charout Listing, copies(' ', length(PicHeader))
      call lineout Listing, "'RC1': ['RC1', 'AN5', 'OPA1IN-', 'C1IN1-', 'C2IN1-'],"
      call charout Listing, copies(' ', length(PicHeader))
      call lineout Listing, "'RC2': ['RC2', 'AN6', 'OPA1OUT', 'C1IN2-', 'C2IN2-', 'SLPCIN'],"
      call charout Listing, copies(' ', length(PicHeader))
      call lineout Listing, "'RC3': ['RC3', 'AN7', 'C1IN3-', 'C2IN3-'],"
      call charout Listing, copies(' ', length(PicHeader))
      call lineout Listing, "'RC4': ['RC4', 'COG1OUT1', 'C2OUT'],"
      call charout Listing, copies(' ', length(PicHeader))
      call lineout Listing, "'RC5': ['RC5', 'COG1OUT0', 'CCP1'],"
      call charout Listing, copies(' ', length(PicHeader))
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


