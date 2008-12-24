/* Rexx script to compile a sample under eComStation (OS/2) */

/* Execute this Rexx procedure to compile one of the Jallib
   'blink-an-LED' sample programs. You may need to change
   the base directory of the Jallib Pack and the target PICmicro */

base   = 'k:\jalpack\'                          /* Jallib pack base directory */
pic    = '16f877a'                              /* target device */

cc     = base'compiler\jalv2ecs'                /* compiler binary */
lib    = base'lib'                              /* library */
smp    = base'sample\by_device\'                /* directory with samples */
pgm    = smp||pic'\blink_'pic                   /* sample program */

'@'cc '-long-start -s' lib  pgm'.jal'           /* compilation */

say ''
if rc = 0 then
  say 'Result in file' pgm'.hex'
else
  say 'Compilation failed'

