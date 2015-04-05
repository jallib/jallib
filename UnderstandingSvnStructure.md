# Why do we have such a structure? #

_"Yes, why do we have such a (complicated) structure ?"_ you ask, humble visitor... The current jalv2 compiler version cannot handle include statements in sub-directories, so this is a quite legitimate question.

We, the jallib team, decided on such a structure because:-

  * having files organized helps finding them. Visitors may only want to download a few files, or search for a specific library. **A structured repository helps**.
  * as a developer, or as a committer, it's not reasonable to put all the files into a single place; that would be a mess (there are a _lot_ of files) and developers don't like entropy. A structure helps to classify things and when you classify things you have a better understanding of the overall picture.  So, **a structured repository is mandatory**


# Description #

Now let's dive into this!

_Note: what is described here starts from the SVN /trunk._


Here's a simple map, to better understand where we are in the overall structure during this trip.

```

               ┌────────────────────────────────┐
       high    │            external            │
               ├────────────────┬───────────────┤
        │      │   peripheral   │    jal        │      
               ├────────────────┴───────────────┤
       low     │         device   files         │   
               └────────────────────────────────┘

```

## casualties ##

**casualties** contains libraries and samples which were to be included in jallib, but are stored here because they're just not working, are not compilable, have no maintainer, or are orphans... You may want to have a look at this collection, maybe you'll find the library you want. But be aware that you'll probably have to modify it a lot.  If it works, please do let us know! We'll be more than happy to include it back into the appropriate directory.


## include/sample ##

  * **include**: contains files which can be included in a user's program. That is, libraries...
  * **sample**: contains files _named by device_, where you can find many working example programs for each PIC (also see below for the description of _test_ , which is used to produce the sample files -- although this is actually more for internal use, for developers).

Now, in the following paragraphs, we'll talk about the structure within the **include** section.

## include ##

### device ###

Ah... **device**! Have you ever wondered how many PICs are handled in jallib?  Is your shiny-but-weird PIC supported?  Come here and you'll find the answer, amongst about 500 (yes, five hundred!) device files!

Device files are the very base of every program, you'll find more on this subject in the [page](JallibFileStructure.md) section titled "Device File". Device files are the lowest level of jallib and, if you want, you can use only them to create your program (but you'll miss out on the power of all of the other jallib libraries).

### peripheral ###

In this directory, you'll find every library used to handle PICs' peripherals. Peripherals is the term Microchip uses to describe PIC's on-board, peripheral features. These libraries belong to the **core**. It's at a slightly higher level than device files, but still at quite a low level.

You'll find everything you need here to play with: **adc**, **comparator**, **data\_eeprom**, **flash\_memory**, **i2c**, **pwm**, **spi**, **timer**, **usart**.


### jal ###

The **jal** section is quite special. This is not about the compiler, no, it's about _jal language extensions_, that is functionalities you'd like to see as built-ins, implemented into the compiler, for everyday/common usage. These are **core** too. These extensions take jalv2 to an even higher level!

Here you'll find libraries to produce **delays**, to **print** and **format** messages, and many more.


### external ###

This is the highest level... This is where you'll find dedicated libraries for specific parts. It's named **external** because it's about everything that's not internal to a PIC chip.

Here you'll find libraries to play with **LCDs**, **keyboards**, **motors**, **sensors**, **memory**, etc...


## sample ##

This section contains samples and examples. Every sample is prefixed by a specific PIC's name, so you should be able to easily find all of the available samples for your favorite PIC chip (for example:- _16f88\_blink.jal_ is a complete, working example of the simple, blinking LED program for the 16F88 processor).

These samples are _ready-to-compile_, so feel free to give them a try, it's easy! If you have created a new sample, please don't hesitate, **share your shiny new sample with the jallib group and we'll be pleased to add it to the repository**.

## test ##

In the "test" map, you'll find almost the same hierarchy as in "include". This is where test files are stored. Test files are chip independent (there's no "include 16fxxxx"), and perform heavy tests on several important libraries (mainly PIC-specific core libraries).

So, for instance, in `test/peripheral/usart`, you'll find tests dedicated to USART libraries. These tests are matched up with a "board" file (from the "board" directory). Together, a _board_ file and a _test_ file give  a functional, compilable piece of code, which will perform the selected test on the selected target, using the selected board.

"Whoa!" I hear you say... "Why is it so complicated?" It's really not that complicated.  At least, the apparent complexity avoids code duplication and permits us to separate the test logic from the board/target chip set-up. Each type of file focuses on a specific task. Don't worry too much about all of this; unless you plan to contribute to jallib as a developer you won't really need to remember it.  But... we'd be pleased if you do decide to help :)

### unittest ###

This sub-directory of test is about unit-testing. You'll find files containing tests which you can run using the
`jallib` script, like this: `jallib unittest <testfile>`.

Unit-testing is performed using PICShell libraries.  The files are annotated with special tags (like @assertEquals ...). These tests can be run in PC-silico, and do not require a physical PIC. The tests here verify some library and compiler features, ensuring there's no regression.