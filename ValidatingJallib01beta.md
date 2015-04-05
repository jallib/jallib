#summary This page show the validation results to create jallib 0.1beta release.
#labels Phase-QA,Deprecated

Instead of a "OK/KO" voting system, I've taken the voting system from Apache (http://www.apache.org/foundation/voting.html). This helps expressing more than a binary opinion, which often not the case. Here are the rules (inspired from this page):

"""

The in-between values are indicative of how strongly the voting individual feels. Here are some examples of fractional votes and ways in which they might be intended and interpreted:


| -1   | I really don't like this, but I'm not going to stand in the way if everyone else wants to go ahead with it. |
|:-----|:------------------------------------------------------------------------------------------------------------|
|  0   | I don't have any opinion on this... |
| +1   | I've used it, don't feel strongly about it, but I'm okey with this. Or, I did not use it, but I like the way it's designed. |
| +2   | I've used it, this is cool ! |
| +3   | I've used it many times. Wow! I like this! Amazing ! |

"""


Because "practicality beats purity", people who have used to the library have more power: they can vote from -1 to +3. The unlucky ones who did not used the library can vote from -1 to +1, mainly according to the way the library is designed.

There's also no veto vote, so the majority wins :) Ideally, absolute majority is the goal. When there's a negative vote, we have to discuss to better know we all have understood the problem. The jallib group is here to help: put a "validate" or the the like in the subject, so we all know what this is about.

There is no dedicated section about device files. When they are involved in a sample, they are validated. The more they are involved in samples, the more they are tested, the more we are confident about them. So, once vote is done, we'll extract device files involved in all validated files.

Once the vote is done, all files which are **positive** (majority agree, score > 0) goes to the "validated" map (move ?, copy ?)

Finally, before voting, every jal file must first fulfill the [validation process](ValidationProcess.md) (3 criteria)


---


# Validating "include" files #

| **include file**                             | Rob | Eur | Joep | Seb |_Total_|
|:---------------------------------------------|:----|:----|:-----|:----|:------|
| external/lcd/lcd\_st7036.jal                |     |     |      |     |       |
| external/lcd/lcd\_hd44780\_4.jal             |  2  |  2  |  2   |     |       |
| external/temperature/temp\_tc77.jal         |     |  2  |      |     |       |
| external/keyboard/keyboard.jal             |     |  2  |      |     |       |
| external/rtc/rtc\_ds1302.jal                |     |     |      |     |       |
| external/co2/t6603\_co2.jal                 |     |  2  |      |     |       |
| jal/delay\_any\_mc.jal                       |  2  |  2  |  3   |  3  |       |
| jal/print.jal                              |  3  |  3  |  3   |  3  |       |
| jal/format.jal                             |  2  |  2  |  2   |  2  |       |
| peripheral/data\_eeprom/pic\_data\_eeprom.jal |     |     |      |  2  |       |
| peripheral/pwm/pwm\_common.jal              |     |     |      |  3  |       |
| peripheral/pwm/pwm\_ccp1.jal                |     |     |      |  3  |       |
| peripheral/pwm/pwm\_ccp2.jal                |     |     |      |  1  |       |
| peripheral/pwm/pwm\_ccp3.jal                |     |     |      |  1  |       |
| peripheral/pwm/pwm\_ccp4.jal                |     |     |      |  1  |       |
| peripheral/pwm/pwm\_ccp5.jal                |     |     |      |  1  |       |
| peripheral/adc/adc\_hardware.jal            |     |     |      |  2  |       |
| peripheral/i2c/i2c\_hardware.jal            |     |     |  2   |  1  |       |
| peripheral/i2c/i2c\_software.jal            |     |     |  2   |  1  |       |
| peripheral/usart/serial\_hardware.jal       |     |  3  |  3   |  3  |       |
| peripheral/usart/serial\_software.jal       |     |     |      |  2  |       |
| peripheral/usart/serial\_hw\_int\_cts.jal     |  2  |     |      |  2  |       |


---


# Validating "samples" and "tests" files #

Note:
> Tests aren't listed here, because they aren't enough mature, still need work (but Work In Progress...)

Remember: a sample, to be validated, must be manually tested succesfully.

## Blink files ##

|  blink files                | Rob | Eur | Joep | Seb |_Total_|
|:----------------------------|:----|:----|:-----|:----|:|
| 10f206.jal/b10f206.jal      |  2  |     |      |     |      |
| 10f222.jal/b10f222.jal      |  2  |     |      |     |      |
| 12f509.jal/b12f509.jal      |  2  |     |      |     |      |
| 12f510.jal/b12f510.jal      |  2  |     |      |     |      |
| 12f629.jal/b12f629.jal      |  2  |     |      |     |      |
| 12f635.jal/b12f635.jal      |  2  |     |      |     |      |
| 12f675.jal/b12f675.jal      |  2  |     |      |     |      |
| 12f683.jal/b12f683.jal      |  2  |     |      |     |      |
| 12hv615.jal/b12hv615.jal    |  2  |     |      |     |      |
| 16f505.jal/b16f505.jal      |  2  |     |      |     |      |
| 16f506.jal/b16f506.jal      |  2  |     |      |     |      |
| 16f526.jal/b16f526.jal      |  2  |     |      |     |      |
| 16f54.jal/b16f54.jal        |  2  |     |      |     |      |
| 16f57.jal/b16f57.jal        |  2  |     |      |     |      |
| 16f610.jal/b16f610.jal      |  2  |     |      |     |      |
| 16f627.jal/b16f627.jal      |  2  |     |      |     |      |
| 16f628.jal/b16f628.jal      |  2  |     |      |     |      |
| 16f628a.jal/b16f628a.jal    |  2  |     |      |     |      |
| 16f630.jal/b16f630.jal      |  2  |     |      |     |      |
| 16f631.jal/b16f631.jal      |  2  |     |      |     |      |
| 16f636.jal/b16f636.jal      |  2  |     |      |     |      |
| 16f648a.jal/b16f648a.jal    |  2  |     |      |     |      |
| 16f676.jal/b16f676.jal      |  2  |     |      |     |      |
| 16f677.jal/b16f677.jal      |  2  |     |      |     |      |
| 16f684.jal/b16f684.jal      |  2  |     |      |     |      |
| 16f685.jal/b16f685.jal      |  2  |     |      |     |      |
| 16f687.jal/b16f687.jal      |  2  |     |      |     |      |
| 16f688.jal/b16f688.jal      |  2  |     |      |     |      |
| 16f689.jal/b16f689.jal      |  2  |     |      |     |      |
| 16f690.jal/b16f690.jal      |  2  |     |      |     |      |
| 16f72.jal/b16f72.jal        |  2  |     |      |     |      |
| 16f726.jal/b16f726.jal      |  2  |     |      |     |      |
| 16f727.jal/b16f727.jal      |  2  |     |      |     |      |
| 16f73.jal/b16f73.jal        |  2  |     |      |     |      |
| 16f767.jal/b16f767.jal      |  2  |     |      |     |      |
| 16f77.jal/b16F77.jal        |     |     |   2  |     |      |
| 16f777.jal/b16f777.jal      |     |  2  |      |     |      |
| 16f785.jal/b16f785.jal      |  2  |     |      |     |      |
| 16f818.jal/b16f818.jal      |  2  |     |      |     |      |
| 16f819.jal/b16f819.jal      |  2  |     |      |     |      |
| 16f870.jal/b16f870.jal      |  2  |     |      |     |      |
| 16f873.jal/b16f873.jal      |  2  |     |      |     |      |
| 16f873a.jal/b16f873a.jal    |  2  |     |      |     |      |
| 16f876a.jal/b16f876a.jal    |  2  |     |      |     |      |
| 16f877.jal/b16f877.jal      |     |  2  |      |     |      |
| 16f877a.jal/b16f877a.jal    |     |  2  |      |     |      |
| 16f88.jal/b16f88.jal        |  2  |     |      |  2  |      |
| 16f882.jal/b16f882.jal      |  2  |     |      |     |      |
| 16f883.jal/b16f883.jal      |  2  |     |      |     |      |
| 16f886.jal/b16f886.jal      |  2  |     |      |     |      |
| 16f916.jal/b16f916.jal      |  2  |     |      |     |      |
| 16f917.jal/b16f917.jal      |  2  |     |      |     |      |
| 16hv785.jal/b16hv785.jal    |  2  |     |      |     |      |
| 16lf726.jal/b16lf726.jal    |  2  |     |      |     |      |
| 18f1230.jal/b18f1230.jal    |  2  |     |      |     |      |
| 18f1320.jal/b18f1320.jal    |  2  |     |      |     |      |
| 18f1330.jal/b18f1330.jal    |  2  |     |      |     |      |
| 18f2320.jal/b18f2320.jal    |  2  |     |      |     |      |
| 18f242.jal/b18f242.jal      |  2  |     |      |     |      |
| 18f2423.jal/b18f2423.jal    |  2  |     |      |     |      |
| 18f2455.jal/b18f2455.jal    |  2  |     |      |     |      |
| 18f248.jal/b18f248.jal      |  2  |     |      |     |      |
| 18f2480.jal/b18f2480.jal    |  2  |     |      |     |      |
| 18f24k20.jal/b18f24k20.jal  |  2  |     |      |     |      |
| 18f2539.jal/b18f2539.jal    |  2  |     |      |     |      |
| 18f2550.jal/b18f2550.jal    |  2  |     |      |     |      |
| 18f2553.jal/b18f2553.jal    |  2  |     |      |     |      |
| 18f258.jal/b18f258.jal      |  2  |     |      |     |      |
| 18f2620.jal/b18f2620.jal    |  2  |     |      |     |      |
| 18f2685.jal/b18f2685.jal    |  2  |     |      |     |      |
| 18f452.jal/b18f452.jal      |  2  |  2  |      |     |      |
| 18f4550.jal/b18f4550.jal    |     | -1  |      |     |      |
| 18f458.jal/b18f458.jal      |  2  |     |      |     |      |
| 18f4620.jal/b18f4620.jal    |  2  | -1  |      |     |      |
| 18f4682.jal/b18f4682.jal    |  2  |     |      |     |      |
| 18f4685.jal/b18f4685.jal    |  2  |     |      |     |      |
| 18f6310.jal/b18f6310.jal    |  2  |     |      |     |      |


## Sample files ##

| **samples file**                          | Rob | Eur | Joep | Seb |_Total_|
|:------------------------------------------|:----|:----|:-----|:----|:------|
| 16f690/hello\_world\_lcd.jal              |  2  |     |      |     |       |
| 16f819/hello\_world\_lcd.jal              |  2  |     |      |     |       |
| 16f876a/test\_tc77.jal                   |     |  2  |      |     |       |
| 16f877/lcd\_hd44780\_tmp\_4\_line.jal       |     |     |      |     |       |
| 16f877/lcd\_hd44780\_tmp\_8\_line.jal       |     |     |      |     |       |
| 16f877/lcd\_st7036.jal                   |     |     |      |     |       |
| 16f877/rtc\_ds1302.jal                   |     |     |      |     |       |
| 16f877a/hello\_world\_lcd.jal             |     |  2  |  2   |     |       |
| 16f877a/lcd\_format.jal                  |     |     |      |     |       |
| 16f877a/test\_display\_hd44780\_4\_line.jal |     |     |      |     |       |
| 16f877a/keyboard\_lcd.jal                |     |  2  |      |     |       |
| 16f877a/test\_display\_hd44780\_8\_line.jal |     |     |      |     |       |
| 16f877a/pwm\_led.jal                     |     |     |  2   |     |       |
| 16f877a/print\_serial\_numbers.jal        |     |     |  2   |     |       |
| 16f877a/read\_co2\_t6603.jal              |     |  2  |      |     |       |
| 16f88/adc\_lowres.jal                    |     |     |      |  2  |       |
| 16f88/delay\_basic.jal                   |     |     |      |  2  |       |
| 16f88/hello\_world\_lcd.jal               |  2  |     |      |         |       |
| 16f88/print\_serial\_numbers.jal          |     |     |  2   |  2  |       |
| 16f88/pwm\_sound.jal                     |     |     |      |  3  |       |
| 16f88/pwm\_led\_highres.jal               |     |     |  2   |  2  |       |
| 16f88/pwm\_led.jal                       |     |     |      |  2  |       |
| 16f88/remember\_me.jal                   |     |     |      |  2  |       |
| 16f88/serial\_hw\_echo.jal                |  2  |     |  2   |  3  |       |
| 16f88/serial\_sw\_echo.jal                |     |     |      |  3  |       |
| 16f88/serial\_hw\_int\_cts\_echo.jal        |  2  |     |      |  2  |       |