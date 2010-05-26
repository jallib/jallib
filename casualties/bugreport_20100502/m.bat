copy  16f877a_serial_print_ok.jal jallib.jal
c:\jallib\compiler\jalv2 -debug jallib.jal
copy jallib.asm jallib_ok.asm

copy  16f877a_serial_print_err.jal jallib.jal
c:\jallib\compiler\jalv2 -debug jallib.jal
copy jallib.asm jallib_err.asm
