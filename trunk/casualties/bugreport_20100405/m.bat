

copy  gps_converter_ok.jal gps_converter.jal
c:\jallib\compiler\jalv2 -debug jallib.jal
copy jallib.asm jallib_ok.asm
copy jallib.hex jallib_ok.hex

copy  gps_converter_err.jal gps_converter.jal
c:\jallib\compiler\jalv2 -debug jallib.jal
copy jallib.asm jallib_err.asm
copy jallib.hex jallib_err.hex
                              
                              