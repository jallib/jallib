/* Rexx script to compile a sample under eComStation (OS/2) */
/* Execute this Rexx script to compile one of the Jallib    */
/* 'blink-a-led' samples or any other sample program.       */
/* Assumes directory structure as of JalPack.               */

parse arg pic smp .
if smp = '' then
  smp = 'blink'                                 /* default pgm */
if pic = '' then
  pic = '16f877a'                               /* default PIC */
say 'Compiling Jallib sample:' pic'_'smp

base   = directory()
base   = filespec('d',base)||filespec('p',base)
jj     = base'compiler\jalv2ecs'                /* compiler executable */
lib    = base'lib'                              /* ibrary */
pgm    = base'sample\'||pic'_'smp               /* sample file */

'@'jj '-no-codfile -no-asm -s' lib  pgm'.jal'   /* compile */

say ''
if rc = 0 then                                  /* compilation successful */
  say 'Hex file:' pgm'.hex'

