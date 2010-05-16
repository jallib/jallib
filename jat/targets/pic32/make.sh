#!/bin/sh

# Translate JAL to C
../../source/jalparser blink_led.jal


# SED for the time being, pic32 does not like argc/argv main arguments
sed 's/int argc, char \*\*argv/void/' blink_led.c >blink_led1.c

# Comiple
mipsel-elf-gcc.exe -O3 -S  -c -EL -march=24kc -nostdlib -I../../bin -I. -D__PIC32MX__ -D__C32__ -D__32MX360F512L__ -D__PIC32_FEATURE_SET__=300 -T elf32pic32mx.x blink_led1.c
mipsel-elf-gcc.exe -O3 -EL -march=24kc -nostdlib -I../../bin -I. -D__PIC32MX__ -D__C32__ -D__32MX360F512L__ -D__PIC32_FEATURE_SET__=300 -T elf32pic32mx.x -o out.elf crt0.S blink_led1.c

