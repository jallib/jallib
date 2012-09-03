JalV2 readme
============

Please see jaldiff.txt for important information about differences.

Included in this archive:

README.txt    : this file

Documentation/jalv2.txt       : JALv2 language documentation
Documentation/jalv2opt.txt    : JALv2 compiler options
Documentation/jalv2pragma.txt : JALv2 pragmas

bin/jalv2     : the linux binary. requires libc.so.6
bin/jalv2.exe : win32 binary (no debugging, optimization on)
bin/jalv2d.exe: win32 binary with debugging enabled

chipdef/*     : chip definition files

Makefiles and executable for eComStation (OS/2) are available at
http://www.robh.nl/picsoft.php#jalv2

Note this package contains only the compiler. For a comprehensive set 
of JalV2 libraries see the Jallib collection at: 

http://jallib.google.code

or Bert van Dam's JAL Startpack:

http://home.hetnet.nl/~annie86/bvd/lonelynights/index.html

nb: I try to support most of the microcontrollers produced by MicroChip,
    but there are far too many for me to claim complete support. If you
    find a controller for which JALv2 does not produce working code,
    please let me know.
    At the moment, the 16F54, 16F57 and 16F59 are the only ones
    known not to work.

History
=======
2.4p  -- 3 Sept 2012
         * added -fastmath which does:
           + create different multiply functions for different sizes. Normally
             one multiply function is created representing the largest
             operands used
           + if a multiply is only used once, inline it
         * as a side effect of above, multiplication with differently sized
           operands has been optimized to only loop enough for the smallest
           operand
         * use native MULWF instruction on 16 bit cores
         * on 16 bit cores, multiplies <= WORD * WORD are always done inline
         * fixed bug in the branchbit optimizer  
         * added, `SHARED,' to the variable definition part of the 
           documentation, and explicitly stated that variable allocations are
           never done from the SHARED regions.
         * a direct inline assembly `goto' or `call' was missed by the
           optimizer
         * broke 16 bit addition/subtraction of different sized variables
         * uncovered latent bug resulting in incorrect multiplication
           creation
         * fixed 16 bit emulator  
         * a bug where a variable, only initialized by assignment to
           the return value of a function, could be incorrectly
           optimized away
         * passing a constant array element into an inline function
           fails
         * an extra division was required when '/' and '%' are used
           next to each other (patch sent by Geoffrey Hausheer)
         * -fastmath, where the destination is the same as one of the
           operands failed (Geoffrey Hausheer)
         * fix a missing multiply due to confusion between 
           pic_multiply_inline16bit and pic_multiply_inline (Geoffrey Hausheer)
         * on 16 bit cores, inline multiplies of 1 x 3 (Geoffrey Hausheer)
         * long-chain if/elsif/... clauses in which one entry is TRUE
           does not correctly skip further entries leading to incorrect
           warnings (Rob)
         * fixed 14 bit hybrid branch optimization (Per)
         * allow string constants to be passed directly to procedures:
           eg: string_out("hello")
         * fixed re-entrancy bug
         * On 16 bit systems ISR entry assumes the saved variables exist
           in bank 0 which is rarely if ever the case
         * implemented `pragma frame' which forces all variables in a procedure
           to be placed together in a single block
         * the source line numbers in the ASM file were off by one.  
           (Arcady)
         * lfsr should use the value instead of the base directly
         * loading an array into a pointer should use the value instead
           of using the variable directly
         * when an array is passed to a function, it should be marked `assigned'
           because the function might assign an element
         * it was possible to define a variable as a flexible array. This should
           only be allowed as parameters.

2.4o  -- 8 May 2011
         * src/jal/build.sh was missing from the source package
         * generalized the PIC optimizer, converted the various
           optimizers (data, branch, movlp, movbsr) to use the
           new code.
         * don't allow variables named built-in functions
           (COUNT/WHEREIS/DEFINED)
         * FOR cexpr... where cexpr is one larger than a variable
           could otherwise hold (eg, 256 for a BYTE variable) will
           now work correctly.
         * FOR var... now works correctly. Formerly, if var was modified
           withing the loop the results could change.
         * Fixed documentation of FOR and the example for tasks.
         * There are times when a parameter to an inline function
           *cannot* be replaced (eg, if a constant is passed to a parameter,
           and the parameter is the master of another variable).
           bugreport_20100920
         * Moved the `# errors, # warnings' output to the very end,
           averting the confusion over how a file with errors or warnings
           will report `0, 0'
         * Added another error -- universal arrays require a constant
           subscript
         * A function returning a multi-bit caused the compiler to crash
         * Introduced records:
           RECORD id IS
             type id0 [ '[' cexpr ']' ][, ...]
             ...
           END RECORD  
         * assign from str[0] fails when str is an array reference  
         * add/subtract on 16 bit cores, where the destination is
           multi-byte and volatile does *not* need to be done in a
           temporary as is needed with the 12/14 bit cores.
         * casting with bits doesn't work correctly  
         * bit indexing of arrays doesn't work correctly
         * fixed report where flexible arrays fail in 2.4o
           (bad fix to assign from str[0])
         * put the compiler version into the log file  
         * The following: DWORD(t & !0xf) caused a compiler failure
         * Expanded the optimization sections of the JALv2 Compiler
           Options and JALv2 PRAGMAs documents.
         * Blindly checking for equality with (-1U) can lead to issues
           on machines with varying integer sizes (for example, a 64-bit
           machine with 32-bit unsigned, but 64-bit size_t)
         * Minor record issues: COUNT(xx.yy) and USING xx.yy did not
           work (xx was never fully dereferenced).
         * Fixed flexible arrays (accidently removed a counter bump)

2.4n  -- 2 June 2010
         * added inline assembly statement mulwf (thanks hawkdavid52)
         * pic_value_is_zero doesn't work with pointers
           (bugreport_20100502)
         * broken arrays passed to functions
           (bugreport_20100523)
         * fixed `asm bank <var>' for 16 bit cores
         * Implicitly created pseudo-variables must be created in the same
           block as the true variable (bugreport_20100506).
         * On the 16 bit cores, if a pseudo-variable is implicitly created,
           the l_main label is somehow deleted causing the generated
           code to not work.
         * minor optimization when using 'case' with bit values.
           assign the bit to a temporary first to avoid shifting/masking
           for each case.
         * 'case 0' on a multi-bit variable fails
         * Added 14 bit hybrid support (thanks Rob!)
         * Fixed the defined() operator to return a bit (as documented)
           so no more warnings or need to compare with 'true'
         * Issue a diagnostic if a value overflows a UNIVERSAL (is > 32 bits)
           (bugreport_20100424)
         * Allow octal constants (0q...)
         * In some circumstances an aliased value would get confused
         * Invalid assert on add with the 14 bit hybrid
         * The logic in UNIVERSAL value overflow was wrong, causing a
           spurious message in edge cases.
         * The MOVLB optimizer was not seeing functions only called
           indirectly.
         * Added '\\' to the language documentation.  

2.4m  -- 26 Dec 2009
         * Fixed documentation for '-include'
         * Added '[no-]asm', '[no-]codfile', '[no-]log', '[no-]lst'
           '[no-]hex'.
         * IF expr THEN END IF caused the compiler to crash
         * Software stack was not being calculated when -no-variable-reuse
           in effect.
         * Directly accessing the 0th element (ch = buf[0]) of a
           pointer caused either an assertion failure or a segfault
         * Fixed COD generation
         * Added ID programming support with PRAGMA ID and
           PRAGMA IDDATA
         * Added 'movlb 0' to the ISR preamble on 16 bit cores
         * Fixed `db' & `dw' on 16 bit cores
         * Fixed PC which was formerly 16 bits, but can be 32 bits
           on the 16 bit cores.
         * Restructed the archive directory layout
         * Converted the three major guides (jalv2, jalv2opt, jalv2pragma)
           to docbook format in the hopes that this will help me keep
           everything up to date.
         * EEPROM data on the 16 bit cores started at location 0
           ('cause the variable created was only 16 bits, whereas
           eeprom on the 16 bit cores starts higher than 0xffff).
         * a re-entrant function taking an array parameter caused an
           invalid assertion failure
         * in some cases a SEGFAULT would occur when passing an
           array parameter
         * turned on const comparison warnings (when a comparison 
           is always TRUE or FALSE)
         * turned on overflow warnings (when a universal value is
           used that does not fit with its counterpart)
         * fixed COD file generation
         * check function parameters for type & overflow
         * comparing a single bit variable and a single bit constant
           does not work if -no-expr_reduce is set.
         * emit an error if an attempt is made to create a bit
           array (bit arrays are not supported).
         * added `pragma bootloader bloader' and `pragma bootloader loader18'
         * fixed `pramga' --> `pragma' in the inline error message
         * fixed the TRIS parameters in the online manual
         * added `addwfc' to inline assembly
         * fixed aliasing at different block levels (eg, an alias
           in a procedure referencing a global)

2.4l  --  7 Aug 2009
         * -const-detect ordered the constant big endian instead
           if little endian
         * 16 bit code generation fixed to match mpasm (namely,
           the PC is shown in bytes not words)
         * Added inline assembly: reset
         * A procedure taking a volatile parameter and also
           re-entrant would cause an assert()
         * Changed re-rentrant entry/exit to *not* use stkpush/pop  
         * A re-entrant *function's* return value was over-written
           if there were any non-volatile OUT paramters
         * added a numeric option to -loader18 to set the offset
           Examples:
             -loader18      : starts the code at 2048
             -loader18 4096 : starts the code a 4096
         * Added units to jalpragm.txt to explain that for
           `PRAGMA CODE size', size is in WORDs for 12/14 bit
           cores, and BYTEs for 16 bit cores (thanks MicroChip!).
           This follows from the second bullet above.
         * Included inclue assembly opcodes: rlcf/rlncf/rrcf/rrncf  
         * Fixed 16-bit code to use rrcf instead of rrf
         * Make sure variables don't span banks even if the banks
           are contiguous (a problem seen on 16 bit cores).
         * `ALIAS...IS' should work even if the underlying variable
           is only a pseudo-variable
         * Output of `Code area' was screwy on 16 bit cores  
         * Changed `pragma code' on the 18 series to use bytes instead
           of words

2.4k  -- 08 May 2009
         * very minor optimization for bit value return
         * B00059: compiler generated 'put for bits doesn't work
         * B00058: compiler generated 'put doesn't work
         * B00057: cannot pass volatile bit out parameter
         * fixed jalpragm.txt to match the code
         * B00060: cannot assign to a multi-bit on 16 bit cores
         * cleaned up signed/unsigned and truncation warnings
         * B00061: 16 bit cores should save TBLPTR/TABLAT on ISR
         * B00039: FSR should be saved if used in an ISR
         * B00063: IF cond THEN...generates bad code in some cases
         * databits aren't set correctly on indirectly called functions
         * if an indirect function used no data space *and* called other
           functions that *did* use data space, the space for those data
           would not be correctly allocated.

2.4j  -- 12 Mar 2009
         * B00052: Allow any characters in an include filename except
           ';' and '--'. Also, the filename may neither begin
           nor end with a space.
         * B00053: Added _warn, _error, and _debug (Thanks Sebastien!)  
         * B00054: Fixed `pragma error' to display any text on the line after
           the pragma
         * B00050: If `-loader18' was used, the code wouldn't skip over
           any preamble.
         * B00051: `const blah = 0x400; var word x at blah' failed miserably
         * passing an array element into an inline procedure failed
           (always only passed the first element of the array)
         * B00056: added 'tblrd' and 'tblwr' to inline assembly  
         * fixed comparing signed constants
         * in some instances assigning a negative number to a signed variable
           that can clearly contain it resulted in signed/unsigned mismatch
         * Removed OS/2 Makefiles
         * Issue warning when multi-byte string is used in an expression
           (x = "abc" * 2 --> only 'a' is used)
         * *Always* set the 2nd high bit when passing constant arrays  

2.4i  -- 01 Dec 2008
         * Adding suffix to displayed version (2.4i)
         * Inline function return wasn't being handled correctly
         * Inline function parameters that are not used directly
           (only used via another variable placed `at' the parameter)
           weren't working correctly.
         * Compiler directives (``if cexpr...'') incorrectly opened
           a new block
         * Passing an array element into an inlined function
           doesn't work (drops the array index)
         * Occasionally the compiler would spit out a bunch
           of nuisance messages due to some orphaned list elements
         * Fixed documentation (target_clock, not _target_clock)

2.4h  -- 15 Sept 2008
         * fixed all warnings with '-W -Wall'
         * added makefiles from Rob
         * added `pragma speed' and `pragma size'
         * fixed `movlb' generation
         * fixed HEX generation on 16 bit cores
         * allow TRIS 5 - 9 (formerly was 5 - 7)
         * introduced pragma nostack
         * return zero on success, system dependent non-zero on failure
         * minimize the amount of pic_state saved in an interrupt
         * changed to new makefile

2.4g  -- ?? June 2008
         * using `AT cexpr' instead of `AT var' doesn't work
           with function parameters

2.4f  --  (unreleased)
         * B00042 : Inline assembly using conditional operations might get
                    optimized away
         * B00041 : inlining a function or procedure that takes a
                    volatile parameter results in `invalid operation'

2.4e  -- 22 May 2008
         * B00040 : x - C, where x is 2-bytes doesn't work if the LSB of C
                    is 0, and C >= x

2.4d  --  5 May 2008
         * B00036 : Inline parameters that are specifically located
                    are incorrectly replaced with locals.
         * B00037 : Division fails due to invalid assumptions about
                    subtraction (gordon)
         * B00038 : multi-bit assignment is not shifting the result
                    into the correct bits

2.4c  --  4 April 2008
         * optimized `x + -1' and `x - -1'
         * crash: x = x - x
         * optimized `y = x + x' --> y = x << 1
         * optimized 12/14 bit addition and subtraction
         * optimized shifts
         * optimized decrement
         * fixed 16 bit lookup table generation (thanks diego)
         * added jalpragm.txt to the distribution
         * B00035: compiler crashes with lookup tables on 16 bit cores

2.4b  -- 17 March 2008
         * B00028: "opt pass has gone infinite"
         * B00029: `forever loop end loop' hangs compiler
         * B00031: inline assembly might incorrectly use bank
                   and page operators on 16 bit cores
         * B00032: `exit loop' request for all loop types
         * B00033: `repeat...until' construct
         
2.4a  --  6 March 2008
         * B00027 -- wrong registers used when receiving the result 
                     of a function in an inlined function (gordon)
         * B00026 -- Loop optimization bug with nested IFs (wouter)
         * B00024 -- Compiler is re-using state variables that are in 
                     use in some cases (joep)
         * Minor FOR loop optimization -- if we know the loop will
           be executed at least once (controlling expression is
           constant > 0), no need to initially jump over the body.
2.4   -- 23 January 2008
         * initial 16 bit support
         * added '-loader18' to support bootloaders on the 16 bit cores
         * fixed B00022 (multiple files on the command line crash the compiler)
         * fixed B00015 (temporary used in FOR loops overwritten)
         * comments on `CASE...OF...'' lines now show in resulting .asm file
         * ORG is twice what is should be on the 12/14 bit cores
           (Thanks Gordon)
         * Only 1/2 of each _fuse is put into the HEX file
           (Thanks Bert)
         * Fixed infinite recursion in the BSR analyzer (Thanks Gordon)
         * Fixed c18c* chipdef files, and added some 18f* ones.
         * Variables used in an interrupt procedure were allocated twice
         * Volatile variables used in an interrupt procedure were allocated
           multiple times.
         * Incorrect config bits in the HEX file for the 18 series  
         * fixed B00023 (aliased variables in inline functions don't work)
         * fixed B00021 (cannot alias pseudo-variables)

2.2.4 -- 23 June 2007
         * fixed -bloader (thanks N.Muto)
         * fixed flexible strings (thanks N.Muto)
         * fixed spurious `requires boolean expression' (thanks Bert)
         * fixed multi-byte decrement
         * fixed const shift right (ex, 5 >> x) and shift right
           arithmetic
         * added `use ./jalv2 --help' for help if the compiler
           is run without any source file (thanks Sunish)
         * added "/help" "/h" and "/?" as aliases for --help  

2.2.3 -- 20 June 2007
         * flexible array support
           Flexible arrays are a special array format when passing
           parameters to a procedure or function, defined as follows:

             PROCEDURE test_proc(BYTE IN str[]) IS
               ...blah...
             END PROCEDURE

           Now, str is used just like any other array (the COUNT()
           operator still works). The difference is arrays of any
           length can be passed in, for example:

           BYTE       str1[] = "this is a test"
           CONST BYTE str2[] = "another test"

           test_proc(str1)
           test_proc(str2)

           One caveat here is since the array is passed by reference,
           not value, any modifications to the array will show up.
           If a CONST is passed into a procedure that modifies the
           array, an error will be generated, but unfortunately will
           be non-obvious.

         * fixed software stack generation
         * fixed variable allocator bug (which made the amount of
           data used jump substantially in some situations).
         * changed variable names to avoid collisions
         * removed 'addlw' and 'sublw' (for 12 bit support)
         * added a new compiler flag: '-include {name}' which is
           an implicit `include name' before parsing the program
         * any source path to the file being compiled is included
           as the first include path
         * multiple include directives (and paths) allowed
         * universal types now transformed to the type of the intializer
         * optimized multi-bit assignment
         * looped shift-right in some conditions instead of
           generating a bunch of code
         * warn if an IF or WHILE expression isn't boolean
         * An unknown token in a include file now generates an error
         * Constant expressions are now assigned the correct type
           (instead of universal)
         * Now generate '.COD' file for debugging information
         * Include files for MPLAB integration

2.2.2 -- 10 May 2007
         * complete 12 & 14 bit support
           nb: division on the 12 bit is sketchy due to memory requirements
         * 12 bit emulator support
         * chipdef/16f505.jal
         * new pragmas *required* by all chips:
           pragma target cpu pic_xxx
             define the target cpu. pic_xxx already defined in chipdef.jal
           pragma target bank xxx
             define the target bank size (14 bit = 0x80, 12 bit = 0x20)
           pragma target page xxx
             define the target page size (14 bit = 0x0800, 12 bit = 0x0200)
         * fixed bugs in:
             arithmetic shift right
             x && 1 -- code generation error
             assign to bit

2.2.1 --  7 May 2007
         * A rare bug in the databit optimization code can cause the
           compiler to crash due to infinite recursion
         * Initial 12 bit support

2.2   --  2 May 2007 -- bug fix release

2.1.4 -- 25 April 2007
         * fixed a rare variable allocation bug which would cause two
           active variables to share the same memory location
         * minor change in the assembly output to show the procedure
           in which a variable is defined as part of the EQU
         * fixed -no-variable-reuse  

2.1.3 -- 19 April 2007
         * asm generation in two cases would set the destination
           for movwf causing MPLAB to barf
         * assign to bit broken if the offset is greater than 0
         * better universal type support
         * check for subscript out of range (when using constant subscripts)
         * if the left side of a rotate right is signed, the operation
           will be an arithmetic (sign preserving) shift
         * smarter warnings about signed/unsigned and truncation when
           dealing with universal types

2.1.2 -- 31 March 2006
         * IMPORTANT! Renamed _pic_add_accum to _pic_accum. This is
           *required* for add and subtract and must either be placed
           at the same offset in each bank or, preferably, in the shared
           area!
         * complete rewrite of the operator code including test generator
         * added an (incomplete) emulator to assist in checking the operators
           "-emu" : run the emulator. This will show each instruction as it's
           run unless "-quiet" is also set.
         * new instruction:
             ASSERT expr
           will stop the emulator if expr is not TRUE
         * minor optimization when returning the value of a function  
         * adding preliminary casting
             type [* sz] ( expr )
         * added patches suggested by Mark Gross (64-bit clean,
           fixes to the RICK_PIC code generator)
           
2.1   -- 27 November 2006 fixes:
         * variables were erroneously marked as either unused or unassigned
           in certain circumstances causing the assignment to be silently 
           dropped
         * In some circumstances a re-entrant call would not be setup 
           correctly (specifically, if an IN variable is not marked auto)
         * empty parameter list not allowed in call (aka, `something' works,
           whereas `something()' fails).
         * added '-screamer' bootloader option  

2.0.7 -- 12 October 2006 fixes:
         * Allow string in `pragma eedata' (pragma eedata "this is a test")
         * new keyword : defined(), returns 1 if a label is defined, 0 if not
           IF DEFINED(var) THEN ... END IF
         * new constant : JAL_VERSION holds the version value
           major * 1000 + minor (currently 2_001)
         * assembly output of `movfw' was wrong (no negative effect other
           than not being able to compile with MPLAB)

2.0.6 -- 27 September 2006 fixes:
         * long table preamble was wrong -- when incrementing pclath
           on overflow, the result went into W instead of into pclath
           causing only the first part of the table to print
         * assembler blocks were completely ignored

2.0.5 -- 25 September 2006 fixes:
         * fixed the clear variable startup code
         * added long lookup table support
         * allow `var +/- x' in inline assembly
         * allow a bunch of pre-defined macros in inline assembly
           (see README.asm)
         * allow 'db,' 'dw,' 'ds' in inline assembly
         * new keyword : whereis (see the example in README.asm)
         * all command line options that effect compilation can be
           over-ridden with pragmas (pragmas take precedence)
         * new pragma : pragma fast-interrupt
           fast-interrupt will save & restore W, STATUS, and PCLATH
           but nothing else. There are no restrictions, but logically
           the interrupt procedure should be completely inline
           assembly to prevent corruption of _pic_state
         * hex in string didn't work (ex, "\xff"  

2.0.4 -- 16 August 2006 fixes:
         * changed some branch optimizations
         * fixed W load optimization for volatile variables
         * changed const detection algorithm
         * fixed CASE statement
         * changed lookup table and pre-user order to guarantee lookup
           tables don't span 256 byte boundaries & minimize the amount of
           code not subject to optimization
         * added compiler name & version, and CLI used to compile to the
           top of the assembly file to aid debugging

2.0.3  -- 4 August 2006 fixes:
         * `a - C', with C a constant failed (became `a + C')
         * added W load optimization (see -redundant-reduce)
         * fixed lookup tables with multi-byte elements
         * changed error if a call is made with too many or too few parameters

2.0.2  -- 3 August 2006 fixes:
         * LOOP construct changed -- instead of
             while var < expr
           use
             while var != expr

         * Added a warning if the control variable in a LOOP is changed
         * functions returning BITs were broken
         * don't generate code when function return values are ignored
           (was assigning to a temporary)
         * promotion from bit to byte wasn't handled correctly
         * assigning from a single bit to an array didn't setup the array
           correctly
         * compiler crash if all space from the first bank was allocated  
         * negated universal constants weren't promoted correctly  
         * branchhi_[set|clr] were omitted on processors with 4K or less
           code memory which broken the assembly file for delays
         * changed delay code to guarantee the delay is *at least* the
           amount requested (occasionally, it could be one cycle short)
         * some work on changing the errors to be more useful
         * rewrote the binary add code generator
         * created `jalopts.txt' which explains the compiler options
         * started new naming convention
           major "." minor "." beta

2.00  -- 31 July 2006 fixes:
         * procedure calls wouldn't pass const parameters except in W
         * data area definition in c16f877.jal and c16f876.jal were wrong
           (missing 0x10 bytes in banks 2 & 3)
         * off by one error in the variable allocation functions caused
           one byte to always remain unallocated in the bank

2.00  -- 29 July 2006 fixes:
         * !0x80 wasn't properly promoted to 2 bytes
         * minor bit optimization
             x = x | 0x80  --> bsf x,7
             x = x & !0x80 --> bcf x,7
         * added compiler option '-const-detect' which enables an aggressive
           constant detection optimizer in the compiler. This looks for
           variables that are either only assigned once, or are always 
           assigned the same value and marks them const
         * added compiler option '-temp-reduce' which enables the compiler to
           optimize space used by temporary variables in complex expressions
         * added "PRAGMA INLINE" which forces a procedure or function to be
           inlined
         * DWORD lookup tables were not being created correctly
         * binary OR with a constant and src & dst unequal failed
         * watcom C makefile changes courtesy of Mat Nieuwenhoven
         * fixed PIC optimizer bug to not remove anything that follows a 
           conditional operator
         * changed Makefiles so `make depend' would only include files local 
           to this project
         * removed pjal references from README.txt (starting on 8 June '06)
         * added a new construct:

           BLOCK
             statement(s)
           END BLOCK

           Any variables defined in the block are local to that block
           (the flow control constructs: IF, FOR, WHILE, et.al.  already use 
           an implied block, this just allows for an explicit one). This 
           identical to BEGIN...END in PASCAL but follows more along the
           lines of JAL syntax

         * added a new flow control construct:

           CASE expr OF
             cexpr["," cexpr2...] ":" statement
             ...
             [OTHERWISE] statement
           END CASE

           Again, this is a JAL-ized version from PASCAL. Currently the code
           generated is almost identical to using a bunch of 
           IF/ELSIF/ELSE/END IF statements but one day I might make it a
           jump table.
         * expanded pseudo variables to allow an index parameter (creating
           virtual arrays)
         * removed some bad `const's from the source courtesy of 
           Daniel Serpell
         * cleaned up some compiler warnings

2.00  --  8 June 2006 fixes:
         * various chipdef file fixes (thanks Stef & Vasille)
         * added _usec_delay

2.00  -- 24 May 2006 fixes:
         * removed implicit assumption that shifted values are always
           a power of 2
         * changes how out of range shifts worked. Previously, given a 32
           bit value x, the result of:
              x >> 35
           was to set x to 0, whereas the result of:
              x >> y (where y is 35)
           resulted in:
              x >> (y & 31)
           This has been changed -- if a shift is out of range, the result
           is x.
         * minor Makefile corrections
         * unused volatile variables were being allocated
         * the not operator on single bit values failed if the two
           values resided in different banks
         * forced all volatile variables to be allocated first. this means
           that volatile variables local to a procedure will be considered
           static (the space won't be re-used by other variables, and recursive
           functions will not get a separate copy).
         * added '-clear' compiler option which clears all user data areas
           on program entry (note: volatile, user-placed variables, and
           unused data areas are not cleared).
         * allow "\0" embedded in strings
         * use C style string initialization, eg:
             var byte string[] = "abc" "def" "ghi"
           is the same as
             var byte string[] = "abcdefghi"

2.00  -- 15 May 2006 fixes:
         * right shift multi-byte variable by a constant >= 8 failed
         * right shift where the destination and second value are the
           same failed
         * variable places AT an element of an array will always go to
           the zeroth element
         * multi-byte signed constants weren't working correctly  

2.00  --  3 May 2006 fixes:
         * fixed shift by non-constant 0
         * fixed shift right from a larger value to a smaller
         * multiple fuse words weren't being written to the HEX file
         * bit temporaries would occasionally end up with the same name
         * bit temporary variables might not be allocated

2.00  -- 19 April 2006 fixes:
         * extended the `pragma target fuses' to require a config number
           (starting at 0). For example:
           pragma target fuses 0 1234
         * an empty ELSIF clause would skip the wrong statement
         * assignment to a constant array (aka lookup table) caused
           the compiler to crash
         * shift produced incorrect code
         * arguments to a function marked recursive whose parameters are
           placed (for example, var byte x at _port_b_buffer) wouldn't
           work correctly

2.00  -- 17 March 2006 fixes:
         * a function called indirectly with a BYTE parameter was incorrectly
           passing the parameter in W
         * fixed `x = x + 1`  

2.00  -- 16 March 2006 fixes:
         * a function called both directly and indirectly would not work
           correctly when called directly

0.95  -- 16 March 2006 fixes:
         * word = word - 100 incorrectly turned into word = word + 156
           (100, a byte, was incorrectly negated into a byte instead
           of a word).
         * bit AND/OR/XOR fail miserably if the values are not in the
           same bank (val1 & val2 in different banks always fail,
           sometimes if dst isn't in the same bank as val1 & val2 it
           also fails).
         * allow multiple config words (see c16f8x.jal)
         * fixed SEGFAULT on missing END IF
         * fixed A + A (was doing A + 1 instead of A << 1)
         * change "A = B + A" to "A + A + B"
         * if a constant expression is used in a FOR statement, and
           a variable with the USING clause, if the variable cannot
           hold the constant expression value an error is generated
         * changed name to `jal 2.0'  

0.90  --  2 March 2006 fixes:
         * I broke variable promotion in the last build when the same
           variable is used as a destination.

0.90  --  1 March 2006 fixes:
         * include files not ending in an end of line have one appended.
         * fixed HEX code generation for btfsc/btfss
         * overlapping variables (using 'at') might be incorrectly
           optimized away, causing problems with external assembly.
         * fixed right shifting from a larger type to a smaller
         * the results of binary expressions using unnamed or universal 
           constants take on the type of the other operand (fixes the
           x < 0 problem)

0.90  -- 24 February 2006 fixes:
         * aliases from a smaller name to a larger one cause page faults
         * page and databits fail after a CALL

0.90  -- 23 February 2006 fixes:
         * multiply & divide now work reliably when different sizes are
           used
         * `hardware stack overflow' is now an error. The compiler switch
           `-warn-stack-overflow' changes this to a warning
         * if a procedure is only called by an indirect procedure its
           variables were not being allocated
         * if an alias was used against something with a 'get or 'put 
           procedure, the proper 'get or 'put procedure wouldn't be found
         * target_chip *must* now be defined using `pragma target chip ...'
           this information is passed to the code generator to be included
           at the top of the assembly file
         * fixed two mistakes in c16f87x.jal
         * added check to `is' clause to make sure the alias has a compatible
           type
         * fixed HEX code generation for arrays  
         * turned on TASK functions -- start and suspend
         
0.90  --  1 February 2006 fixes:
         * the expression `x - x' wasn't optimized out at the p-code layer
           causing the PIC generator to fail
         * cannot use an array element in an `at' expression  
         * removed some errant printf's() used for debugging
         * cannot use an array element in asm instructions
         * state not saved correctly on ISR entry/exit
         * arrays can be passed into functions 
         * arrays can be used in assignments
         * arrays and constants don't need explicit sizes, eg
           var byte x[] = { 1, 2, 3, 4, 5 }
           var byte x[] = "this is a test"
         * new keyword, COUNT(x), returns the number of elements in array x,
           and can be used anywhere a constant is expected. For example:
             var byte x[] = "hello"
             var word y[count(x)]
         * procedure(byte in out x) now works correctly if x has 'put
           procedure
         * fixed resolving like-named variables and pseudo functions  
0.90  -- 19 January 2006 fixes:
         * an OUT parameter can now be either a 'put procedure or an array
           element
         * UNIVERSAL constants work as expected
         * ``if (array(n)) then...'' works
         * the compiler version is written when `pjal' is executed by itself

0.90  --  1 January 2006 fixes:
         * call to retlw changes to movlw (was deleted)
         * intrinsicly generate 'get & 'put routines if necessary
         * lookup tables were crossing 256 byte boundaries
         * assembly output wasn't always correct
         * changed to arithmetic shift right for signed numbers
         * allow inline assembly jump or call to constant
         * fixed multi-byte shifting
         * fixed multi-byte andb/orb/xorb
         * partially fixed recursive functions
         
0.90  -- 24 December 2005 fixes:
         * fixed x = y >> # where x is volatile

0.90  -- 21 December 2005 fixes:
         * fixed compiler directives; anything past ``IF 0 THEN...''
           is now skipped entirely (no processing, so it can be used
           for block comments)
         * unless the debug flag is set, the assembly file will stop
           at the `end' statement
         * added `-nocodegen' argument. When this is present no assembly
           code is generated
         * added `-Wdirectives' argument. When this is present any compiler
           directives found will show up as warnings
         * fixed bit constants, for example:
           CONST dummy = true
           will now create a bit constant instead of a byte constant
         * changed the variable allocation such that
           PRAGMA TARGET CHIP x
           and
           CONST TARGET_CHIP x
           create the same type of variable.
         * the code size displayed was off by 1 (it was showing the greatest
           value of the PC, which ignored the last instruction).

0.90  -- 15 December 2005 fixes:
         * in some situations parameters would be incorrectly marked
           CONST

0.90  -- 14 December 2005 fixes:
         * a bug in bit-variable allocation could cause unexpected
           aliasing
         * and/or/xor from single bit to single bit where the destination
           and one of the operands are the same would fail
         * and/or/xor from single bit to single bit logic was restructured
         * temporary reduction was broken during the code restructure
           so it has been removed for the time being

0.90  --  7 December 2005 fixes:
         * return value in w doesn't work except in the explicit
           case (eg, return x)
         * when a value is returned in w, it should be the first
           one assigned as the other assignments might destroy the
           contents of W

0.90  -- 28 November 2005 fixes:
         * bit inversion on assign bit --> bit (non-volatile, the volatile
           case was handled in the 23 November fix)
         * an unassigned temporary was being used in certain function calls
           causing odd results
         * introduced boolean temporaries and changed all relationals
           to return a boolean

0.90  -- 26 November 2005 fixes:
         * bugs in branch optimizer caused the produced code size
           to explode after certain boundaries, and also to fail
           after about 4K
         * another bug in the branch optimizer would fail if a label
           ended up on a 2K boundary
         * constant sign extension logic was wrong
         * equality operator with constants was wrong in some cases
         * arrays with multi-byte entries were wrong (offset was added
           to _ind)
         * added branch[hi|lo]_nop when debugging so the assembly file
           will compile

0.90  -- 23 November 2005 fixes:
         * unary bit operators now work as expected
         * bit inversion on assign bit --> bit

0.90  -- 21 November 2005 fixes:
         * fixed a branch bit optimizer bug
         * added `signed/unsigned mismatch'' and ``assignment to smaller
           type'' warnings
         * added `-Wno-conversion' and `-Wno-truncate' to turn off the
           above warnings
         * added `errorlevel -306' to suppress the page boundary warnings
           in MPASM
         * added `errorlevel -302' to suppress the `access outside of bank
           0'' warnings in MPASM
         * fixed annoying bit where if the first statement after an include
           had an error, the error would be reported at the end of the
           included file
         * fixed an error in the increment & decrement operators where
           the statement, ``return x+1'' would try to store the result at
           location 0

0.90  -- 19 November 2005 fixes:
         * Variables in procedures called in interrupt context were not
           allocated correctly
         * The relational inverses were incorrect in some paths
         * The constant 0 wasn't handled correctly which caused !0
           to also be 0.

0.90  -- 17 November 2005 fixes:
         * assign to a volatile single bit inverted the result
         * incorrect use of free() could have caused memory corruption
           (but for some reason didn't)
         * passing parameters to a routine that doesn't take any
           parameters caused the compiler to crash

0.90  -- 14 November 2005 fixes:
         * fixed relationals used in expressions (y = x <= z)
         * minor optimization when the destination is a non-volatile bit
         * fixed equalities used in expressions (y = x == z)
         * minor optimization when the destination is a non-volatile bit
         * fixed a bug in the pic branch optimizer -- infinite loops were
           not detected causing an infinite loop in the optimizer
         * fixed a bug in the pic conditional branch code -- in addition
           to the relational and equality operators the logical, not,
           and complement operators should also be allowed.
         * in JAL, '!' is bitwise complement, not logical  
         * if a variable is assigned but not used, do not eliminate it
           if it has a master and the master is used

0.90  -- 12 November 2005 fixes:
         * an alias parameter whose master was volatile in a 'put routine 
           didn't compiler correctly
         * did not have the correct logic for relational inverse
         * the FOR loop didn't work correctly

0.90  --  9 November 2005 fixes:
         * shadowing a byte parameter wasn't working
         * added the `using' clause I claim to support in the FOR loop
         * fixed a bug in array indexing
         * optimized multiply & divide -- if the same parameter are used
           the function is not called (since the result will be the same)
           for example:
               x = n % 10
               y = n / 10
           since the result of (n/10) is still in the accumulators, this
           becomes
               x = n % 10
               y = pic_div_quotient
         * fixed a bug in the relational operators
         * fixed a bug in the signed relational operators
         * allow `pragma' in assembler blocks
         * allow labels on lines by themselves in assembler blocks
         * fixed three indirect function bugs
           * if a parameter to an 'put function is never used, don't
             try to assign to it
           * always assume an indirect function is used if called
             indirectly
           * assign function --> function ptr wasn't working
         * work on stack depth calculations ; currently assumes that
           an indirect function does not call any other functions
         * volatile is now inherited. for example:
           ---
           var volatile byte port_b_direction at {0x86, 0x186}
           var bit pin_b0_direction at port_b_direction : 0

           pin_b0_direction = low
           ---

           formerly, pin_b0_direction would be optimized out because
           it is never used. Now, since it refers to port_b_direction
           and port_b_direction is volatile, it is not optimized away.
         * changed `-nopcode' to `-pcode'
         * reduced code size for relational branching
         * fixed assembly from constant lookup tables
         * fixed passing bits or arrays in W
         * fixed multi-byte decrement
         * fixed signed divide
         * added identities:
           x / -1 = -x
           x * -1 = -x
         * fixed multi-byte lookup table assignments
         * untyped constants now use the smallest possible representation

0.90  --  2 November 2005 fixes:
         * fixed bit constants
         * added some more optimizations
            * x == 0 --> !x
            * x != 0 --> !!x
            * x == 1, x a single bit --> !!x
            * x != 1, x a single bit -->  !x
         * fixed a bug in the conditional branch ahead optimization:
            goto [true|false] val lbl1
            goto lbl2
            lbl1:
            -->
            goto [false|true] val lbl2
         * fixed a cosmetic bug where branchhi_clr was changed to 
           branchlo_clr when unneeded but kept
         * fixed a bug where the internal program counter was incorrect
           causing the resulting HEX file to be wrong
         * added another optimization
           * x ^ 255 --> comf x
         * fixed a bug translating branchlo_[set|clr] from inline assembly to 
           pic asm  
         * fixed indirect calls (volatile parameters)  
         * added `-long_start' flag to force the first 3 instructions to be a
           long jump to the program start. This is needed by some bootloaders.
           

0.90  -- 31 October 2005 fixes:
         * ``if (!x) then ...'' would compile the same as ``if (x) then...''
         * the inline-assembly function, ``asm bank movfw x'' would always
            set the high & low bank bits
         * added a couple of branch optimizations:
            * _temp = !x
              branch [true|false] _temp, ...
              --> branch [false|true] x, ...
            * _temp = !!x
              branch [true|false] _temp, ...
              --> branch [true|false] x, ...
         * fixed NOT and LOGICAL operators      
         * fixed `pragma keep [bank|data]'
         * fixed `a = b +/- c', where c is a variable
         * fixed `a = b +/- c', where c is a constant

0.90  -- Initial release -- 30 October 2005

Bugs
====

Of course not! If you find one, please drop me a note:

mailto://kyle@casadeyork.com

There are two known issues however (not bugs mind you):

1. The assembly file always has ``list p=16f877'' regardless of the
   actual processor being used.

2. The TRIS instructions, according to the PIC12C5XX datasheet, should
   be 0x0005, 0x0006, and 0x0007 (for TRIS 5, TRIS 6, and TRIS 7).
   MPASM emits 0x0065, 0x0066, and 0x0067.

