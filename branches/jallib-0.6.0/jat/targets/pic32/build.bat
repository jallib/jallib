

@set ARG1=CODESOURCERY
@IF NOT "%1"==""  @set ARG1=%1

@IF %ARG1%==MYGCC goto setup_env_my_gcc

@echo SETUP CODE SOURCERY GCC TOOLCHAIN

@REM assumes that path is setup during the install of codesourcery
@set GCC_EXE=mips-sde-elf-gcc

@goto setup_env_done
 
:setup_env_my_gcc
@echo setup my GCC TOOLCHAIN
@set PATH=c:\gcc\mips\install\bin;c:\mingw\bin;%PATH%
@set GCC_EXE=mipsel-elf-gcc.exe

:setup_env_done

@echo Cleanup
@if EXIST blink_led.c del /q blink_led.c
@if EXIST blink_led.s del /q blink_led.s
@if EXIST blink_led.elf del /q blink_led.elf
@echo done

@echo Translate JAL to C
@..\..\bin\jalparser -nomainparams blink_led.jal
@echo done


@echo Comiple

@%GCC_EXE% -EL -O3 -S  -c -march=24kc -nostdlib -I../../bin -I. -D__PIC32MX__ -D__C32__ -D__32MX360F512L__ -D__PIC32_FEATURE_SET__=300 -T elf32pic32mx.x blink_led.c
%GCC_EXE% -EL -O3 -march=24kc -nostdlib -I../../bin -I. -D__PIC32MX__ -D__C32__ -D__32MX360F512L__ -D__PIC32_FEATURE_SET__=300 -T elf32pic32mx.x -o blink_led.elf crt0.S blink_led.c
@echo done

