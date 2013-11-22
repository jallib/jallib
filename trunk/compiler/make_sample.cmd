/* Rexx script to compile a sample under eComStation (OS/2) */

/* Execute this Rexx procedure to compile one of the Jallib
   'blink-an-LED' sample programs. You may need to change
   the base directory of the Jallib Pack and the target PICmicro */

base   = '\jalpack\'                            /* Jallib pack base directory */
pic    = '16f877a'                              /* target device */

jj     = base'compiler\jalv2ecs'                /* compiler executable */
lib    = base'lib'                              /* include library */
smp    = base'sample\'                          /* directory with samples */
pgm    = smp||pic'_blink'                       /* sample program */

'@'jj '-no-codfile -no-asm -s' lib  pgm'.jal'   /* compile */

say ''
if rc = 0 then                                  /* compilation successful */
  say 'Hex file:' pgm'.hex'

