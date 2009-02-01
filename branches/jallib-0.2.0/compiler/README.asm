JALv2 Inline Assembler
=======================

JALv2 allows inline assembly through either the single statement:
  asm ...
or the assembly block:
  assembler
    ...
  end assembler

The JALv2 inline assembler is not nearly as powerful as the MicroCHIP
assembler -- it doesn't allow macros for instance. If there is any
feature missing that you require, please let me know & I'll see what
I can do.

Assembly instructions and formats recognized. Some notes:
  f : a file register. it can be either a constant expression
      or relative to a known variable:
        clrf 5 ; clear file register #5
        clrf x ; clear file register located at variable x
        clrf x + 5; clear file register located 5 spaces past variable x
        clrf x - 5; clear file register located 5 spaces before variable x
      nb : this doesn't fully implement the normal assembler semantics. If
           you've two variables, x at location 0x20 and y at location 0x40,
           you cannot write, ``x + y'' The bit after the '+' or '-' must
           be a constant expression.
  d : destination. This is a constant expression that must resolve to 0
      or 1. Generally, the constants 'f' or 'w' are used.
  b : a constant expression that evaluates to 0 <= b <= 7    
  n : a constant expression that evaluates to 0 <= n <= 255
  l : a label (used by call and goto)
  t : a constant expression that evaluates to 5 <= t <= 7

  All instructions can be preceded by BANK and/or PAGE. BANK will set the
  bank bits to guarantee access to a variable is correct, while PAGE will
  guarantee a CALL or GOTO is correct. For example:
    BANK clrf x
  guarantees the bank containing x is selected before the operation,
  whereas
    PAGE goto zz
  guarantees the page bits are set correctly for a jump to zz

  If `pragma keep bank' isn't selected, the BANK prefix may generate no
  code.

  If `pragma keep page' isn't selected, the PAGE prefix may generate no
  code.

  Also, to guarantee the bits are correct, the following are allowed:
    BANK var ; set the necessary bank bits
    PAGE label ; set the necessary data bits
  These are useful for conditional operations, for example:
    PAGE label
    BANK btfsc f, 5
    goto label
  since the page bits for `label' were previously set, it's guaranteed
  that the `btfsc' will only skip a single instruction.

  Finally, local labels can be defined as:
    local label1, label2
  Tells the compiler that label1 and label2 will be assigned later,
  and if a line begins with:

  label ':' ...

  the compiler sets the label to that line.

  See the appropriate PIC assembly guide for instruction details.

  addwf   f, d
  andwf   f, d
  clrf    f
  clrw
  comf    f, d
  decf    f, d
  decfsz  f, d
  incf    f, d
  incfsz  f, d
  iorwf   f, d
  movf    f, d
  movwf   f
  nop
  rlf     f, d
  rrf     f, d
  subwf   f, d
  swapf   f, d
  xorwf   f, d
  bcf     f, b
  bsf     f, b
  btfsc   f, b
  btfss   f, b
  addlw   n
  andlw   n
  call    l
  clrwdt
  goto    l
  iorlw   n
  movlw   n
  retfie
  retlw   n
  return
  sleep
  sublw   n
  xorlw   n
  option
  tris    t

The following macros are allowed (some translate into multiple
commands, each command is separated by ';'):

  addcf   f, d : btfsc _status, _c;  incf f ,d
  adddcf  f, d : btfsc _status, _dc; incf f, d
  b       l    : goto  l
  bc      l    : btfsc _status, _c ; goto l
  bdc     l    : btfsc _status, _dc; goto l
  bnc     l    : btfss _status, _c ; goto l
  bndc    l    : btfss _status, _dc; goto l
  bnz     l    : btfss _status, _z ; goto l
  bz      l    : btfsc _status, _z ; goto l
  clrc         : bcf _status, _c
  clrdc        : bcf _status, _dc
  clrz         : bcf _status, _z
  lcall        : PAGE call l
  lgoto        : PAGE goto l
  movfw   f    : movf f,w
  negf    f, d : comf f,f          ; incf f,d
  setc         : bsf _status, _c
  setdc        : bsf _status, _dc
  setz         : bsf _status, _z
  skpc         : btfss _status, _c
  skpdc        : btfss _status, _dc
  skpnc        : btfsc _status, _c
  skpndc       : btfsc _status, _dc
  skpnz        : btfsc _status, _z
  skpz         : btfss _status, _z
  subcf  f, d  : btfsc _status, _c ; decf f, d
  subdcf f, d  : btfsc _status, _dc; decf f, d
  tstf   f     : movf f, f

And, finally, some raw data commands:

  db     c1,c2[,c3,c4.]
  db     "hello"
    Place values c1:c2 directly into the code (c1 is MSB, c2 is LSB)
    0 <= c1 < 64
    0 <= c2 < 256
    (this gives the 14 bits allowed on a 14 bit core)
    When a string is given, ex "hello", the result is the same as:
      db 0,'h',0,'e',0,'l',0,'l',0,'o'

  dw     c1[,c2,...]
  dw     "hello"
    0 <= c1 < 16384
    (again, the 14 bits allowed on a 14 bit core)
    When a string is given, ex "hello", the result is the same as:
      dw 'h','e','l','l','o'

  ds     c1[,c2,...]
  ds     "hello"
    0 <= c1 < 128
    When a string is given, ex "hello", the result packs the string such
    that two full characters fit into one word. A good way to prevent
    wasted space (since a lookup table requires one program word per entry).
    Use the eeprom read functions to get at this data.

Example:

  ;
  ; create a compressed string table, and put its location in table_loc
  ;
  var word table_loc
  asm local table, done
  asm goto done
  asm table:
  asm ds "this is a compressed string"
  asm done:
  table_loc = whereis(table)

