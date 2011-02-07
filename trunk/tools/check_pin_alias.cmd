/* Rexx script Check pinmap.py for aliases for SPI and I2C pins.       */
/* When and SDA1 pin is specified, an alias SDA should be present,     */
/* same: alias SDI for SDI1, SCK alias for SCK1 and SCL alias for SCL1 */
/* See Jallib issue # 136                                              */

infile = 'pinmap.py'

call stream infile, 'c', 'open read'
do i = 1 while lines(infile)
  ln = linein(infile)
  call check_1_alias 'SDA'
  call check_1_alias 'SDI'
  call check_1_alias 'SCK'
  call check_1_alias 'SCL'
end
call stream infile, 'c', 'close'
return


/* ------------------ */
/* check single alias */
check_1_alias: procedure expose ln i
parse upper arg y .
if pos("'"y"1'", ln) > 0 then do                /* item y1 present */
  if pos("'"y"'", ln) = 0 then                  /* item y not present */
    say 'Line' i 'missing alias for' y"1"       /* report */
end
return
