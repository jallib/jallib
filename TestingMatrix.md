# Description #

The following table shows tests the jallib team has been performed on several target chip, against multiple library.

**PIC-specific tests** shows the different test results related to PIC themselves. That is, this is where you'll find tests which validate each main registers, peripherals, ... are functional. There are organized by **datasheet names**, so if your PIC is not explicitly listed here, but belongs to the same datasheet than another one, you can be quite confident it'll work the same.

For each name, you can find a link to a dedicated test page showing the whole test results. Graphs and a "level meter" picture will give you the current overall picture.


# PIC-specific tests #

PIC are listed according to datasheet names, in alphabetical order.

| _**Datasheet name**_ |
|:---------------------|
| **PIC10F220/222** | Test10F222 |
| **PIC16F873/4/6/7** | Test16F877 | Test16F877a | Test16F876 |
| **PIC16F87/88** | Test16F88 |

_(if you're looking for samples for a specific PIC, you should have a look at [jalapi](JalapiWelcome.md), select a library, and search for "Related samples")_

# "Hey ! My PIC is not supported ! #

Don't panic ! If your precious PIC does not appear in these tables, it doesn't mean it's not supported. It just mean we don't performed tests on this particular PIC. So, first of all, try to find if there's a test for another PIC closed to yours, that is, on the same datasheet. If so, there're great chances your PIC is also supported. If not, help us validating, and [send us](http://groups.google.com/group/jallib) results so we can add new row !