/* Rexx script to compile a sample under eComStation (OS/2) */

/* Execute this Rexx procedure to compile one of the Jallib
   'blink-an-LED' sample programs. You may need to change
   the base directory of the Jallib Pack and the target PICmicro */

base   = '\jalpack\'                            /* Jallib pack base directory */
pic    = '16f877a'                              /* target device */

cc     = base'compiler\jalv2ecs'                /* compiler executable */
lib    = base'lib'                              /* include library */
smp    = base'sample\'                          /* directory with samples */
pgm    = smp||pic'_blink'                       /* sample program */

'@'cc '-long-start -s' lib  pgm'.jal'           /* compile */

say ''
if rc = 0 then                                  /* compilation successful */
  say 'Hex file in:' pgm'.hex'
else
  say 'Compilation failed'
'@del' pgm'.asm' pgm'.cod' pgm'.err' pgm'.obj' pgm'.lst' '1>nul 2>nul'

