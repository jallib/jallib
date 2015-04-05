# Introduction #

There have been lots of messages on testing of jallib (or QA in general).
A very important part of QA is the buildbot that compiles all samples when there has been an update to svn. This will assure we only release compilable code.

# testfiles and boardfiles #

In the svn under test, you will find a directory board.
This directory contains files that define an specific board setup: processor type & setup and which pins can be used for which purpose. In general, these files don't generate any code.
If you have a board with an other pin-out (which is likely), feel free to add your specific setup.

The other directories under /test contain testfiles. These are test programs that rely on a board file to define the processor and required pins. Testfiles should never use a pinname directly.

So a boardfile and testfile together provide a working testprogram. One way to generate such a program is to create and compile a jal-file with just two lines:
```
include board_16f88_sl
include test_serial_print
```
The alternative is to generate samples from a board- and testfile. This is described below (and also explains the @jallib tags).

Note: we once concidered to use three files: chip (include device
file & pragma's), board (pin configuration) and test file, but decided
to combine the first two in the board file. If you have many chips on
the same board, this is not that efficient.

## create samples from test- and boardfiles ##

@jallib is the magic string

In board files, ";@jallib section `<`name>" defines the end of a previous section and start of a new section. `<`name> is the name of the section.

In the testfile the tag "@jallib use `<`name>" includes the section defined in the board file.
The purpose of this tags is to avoid that the numerous definitions in the board file (e.g. i2c and various lcd definitions) are included in samples where they are not relevant (e.g. test\_serial\_print.jal). This would overwhelm the sample user with irrelevant information.

Create all samples an put them into 'outdir':
```
md outdir
jallib sample -a c:\jallib\sample -o outdir
```
This will create a sample of the combinations of each boardfile with each sample file. It will compile each sample and if compile fails, the sample will be removed.


# testconsole #

As you may have seen, I (Joep) created a file called serial\_testconsole.jal.
It provides an framework to run different unit tests on a target
system. The tests are triggered via the serial port.

How does it work?

Well, first you create some tests you want to execute:

```
include a board file (or name it a test file)
include serial_tc_header -- optional - only required if you want to use the test vars (see below)
```
then:
```
const byte testname_a[] = "clear screen"
procedure unit_test_a() is
  lcd_clear_screen()
end procedure
```
where testname_`*` is a string that gives you info about the test. You
can leave it out if you don't need it or want to save program space.
It is printed when you start the test.
The procedure unit\_test_`*` is the code executed. And as you might have
guessed, `*` represents a char [a...z], case insensitive, that triggers
the test. So up to 26 test can be defined at the same time.

In addition to this, there is (some preliminary) support for
maintenance of test vars.

There is an array of 10 vars:
```
var word tc_var[10]
```
each of which can also be addressed directly:
var word tc\_var0 at tc\_var[0](0.md)


These values can be maintained from the keyboard:

```
-- ! selects this menu
-- ` exits this menu
-- space print all vars
-- 0..9 select var
-- + increment var by 1
-- = increment var by 1 (= is unshifted plus on my keyboard)
-- - decrement var by 1
```

When done defining the unit test:

```
include serial_testconsole
testconsole_init()

tc_var2 = 1 -- optionally change default value 0 of tc-var

testconsole()  -- contains forever loop
```
And you are done. (See test\_display\_hd44780\_4.jal for a working example)

The reason I created this is the increasing amount of repeating work
to create tests. And for me, testing on a target system is the way to
go. I don't like testing with emulators and don't use ICD's or
breakpoints.