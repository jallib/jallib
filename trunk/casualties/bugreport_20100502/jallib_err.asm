; compiler: jal 2.4n-beta (compiled Mar 13 2010)

; command line:  c:\jallib\compiler\jalv2.exe jallib.jal -Wall -Wno-directives -long-start -debug -s "c:\jallib\include;c:\jallib\include\device;c:\jallib\include\external;c:\jallib\include\external\adc;c:\jallib\include\external\can;c:\jallib\include\external\co2;c:\jallib\include\external\humidity;c:\jallib\include\external\keyboard;c:\jallib\include\external\lcd;c:\jallib\include\external\media;c:\jallib\include\external\motor;c:\jallib\include\external\motor\dc;c:\jallib\include\external\motor\period_skip;c:\jallib\include\external\motor\servo;c:\jallib\include\external\motor\stepper;c:\jallib\include\external\ranger;c:\jallib\include\external\ranger\ir;c:\jallib\include\external\ranger\us;c:\jallib\include\external\rtc;c:\jallib\include\external\seven_segment;c:\jallib\include\external\storage;c:\jallib\include\external\storage\eeprom;c:\jallib\include\external\storage\harddisk;c:\jallib\include\external\storage\ram;c:\jallib\include\external\storage\ram\23k256;c:\jallib\include\external\storage\sd_card;c:\jallib\include\external\temperature;c:\jallib\include\filesystem;c:\jallib\include\jal;c:\jallib\include\peripheral;c:\jallib\include\peripheral\adc;c:\jallib\include\peripheral\can;c:\jallib\include\peripheral\comparator;c:\jallib\include\peripheral\data_eeprom;c:\jallib\include\peripheral\flash_memory;c:\jallib\include\peripheral\i2c;c:\jallib\include\peripheral\pwm;c:\jallib\include\peripheral\spi;c:\jallib\include\peripheral\timer;c:\jallib\include\peripheral\usart;c:\jallib\include\peripheral\usb;c:\jallib\include\protocol;c:\jallib\test;c:\jallib\test\board;c:\jallib\test\external;c:\jallib\test\external\keyboard;c:\jallib\test\external\lcd;c:\jallib\test\external\ranger;c:\jallib\test\external\ranger\ir;c:\jallib\test\external\rtc;c:\jallib\test\external\seven_segment;c:\jallib\test\jal;c:\jallib\test\peripheral;c:\jallib\test\peripheral\adc;c:\jallib\test\peripheral\comparator;c:\jallib\test\peripheral\data_eeprom;c:\jallib\test\peripheral\flash_memory;c:\jallib\test\peripheral\i2c;c:\jallib\test\peripheral\pwm;c:\jallib\test\peripheral\spi;c:\jallib\test\peripheral\timer;c:\jallib\test\peripheral\usart;c:\jallib\test\peripheral\usb;c:\jallib\test\unittest;"
; compiler flags:
;    boot-fuse, boot-long-start, debug-compiler, debug-codegen
;    opt-expr-reduce, opt-cexpr-reduce, opt-variable-reduce
;    warn-backend, warn-conversion, warn-misc, warn-range
;    warn-stack-overflow, warn-truncate
                                list p=16f877a, r=dec
                                errorlevel -306 ; no page boundary warnings
                                errorlevel -302 ; no bank 0 warnings
                                errorlevel -202 ; no 'argument out of range' warnings

                             __config 0x3f7a
datahi_set macro val
  bsf 3, 6 ; STATUS<rp1>
  endm
datahi_clr macro val
  bcf 3, 6 ; STATUS<rp1>
  endm
datalo_set macro val
  bsf 3, 5 ; STATUS<rp0>
  endm
datalo_clr macro val
  bcf 3, 5 ; STATUS<rp0>
  endm
irp_clr macro
  bcf 3, 7 ; STATUS<irp>
  endm
irp_set macro
  bsf 3, 7 ; STATUS<irp>
  endm
branchhi_set macro lbl
    bsf 10, 4 ; PCLATH<4>
  endm
branchhi_clr macro lbl
    bcf 10, 4 ; PCLATH<4>
  endm
branchlo_set macro lbl
    bsf 10, 3 ; PCLATH<3>
  endm
branchlo_clr macro lbl
    bcf 10, 3 ; PCLATH<3>
  endm
branchhi_nop macro lbl
  endm
branchlo_nop macro lbl
  endm
v_true                         EQU 1
v_false                        EQU 0
v_high                         EQU 1
v_low                          EQU 0
v_output                       EQU 0
v__ind                         EQU 0x0000  ; _ind
v__pcl                         EQU 0x0002  ; _pcl
v__status                      EQU 0x0003  ; _status
v__irp                         EQU 7
v__z                           EQU 2
v__c                           EQU 0
v__fsr                         EQU 0x0004  ; _fsr
v_portc                        EQU 0x0007  ; portc
v__portc_shadow                EQU 0x0036  ; _portc_shadow
v__pclath                      EQU 0x000a  ; _pclath
v_pir1                         EQU 0x000c  ; pir1
v_pir1_txif                    EQU 0x000c  ; pir1_txif-->pir1:4
v_rcsta                        EQU 0x0018  ; rcsta
v_txreg                        EQU 0x0019  ; txreg
v_adcon0                       EQU 0x001f  ; adcon0
v_trisc                        EQU 0x0087  ; trisc
v_pin_c2_direction             EQU 0x0087  ; pin_c2_direction-->trisc:2
v_pie1                         EQU 0x008c  ; pie1
v_pie1_rcie                    EQU 0x008c  ; pie1_rcie-->pie1:5
v_pie1_txie                    EQU 0x008c  ; pie1_txie-->pie1:4
v_txsta                        EQU 0x0098  ; txsta
v_txsta_txen                   EQU 0x0098  ; txsta_txen-->txsta:5
v_txsta_brgh                   EQU 0x0098  ; txsta_brgh-->txsta:2
v_spbrg                        EQU 0x0099  ; spbrg
v_cmcon                        EQU 0x009c  ; cmcon
v_adcon1                       EQU 0x009f  ; adcon1
v_ascii_lf                     EQU 10
v_ascii_cr                     EQU 13
v_print_prefix                 EQU 0x0037  ; print_prefix-->_bitbucket:0
v__bitbucket                   EQU 0x0037  ; _bitbucket
v__pic_temp                    EQU 0x0020  ; _pic_temp-->_pic_state
v__pic_pointer                 EQU 0x0032  ; _pic_pointer
v__pic_loop                    EQU 0x0030  ; _pic_loop
v__pic_divisor                 EQU 0x0028  ; _pic_divisor-->_pic_state+8
v__pic_dividend                EQU 0x0020  ; _pic_dividend-->_pic_state
v__pic_quotient                EQU 0x002c  ; _pic_quotient-->_pic_state+12
v__pic_remainder               EQU 0x0024  ; _pic_remainder-->_pic_state+4
v__pic_divaccum                EQU 0x0020  ; _pic_divaccum-->_pic_state
v__pic_sign                    EQU 0x0031  ; _pic_sign
v__pic_state                   EQU 0x0020  ; _pic_state
v_a                            EQU 0x0038  ; a
v___b_2                        EQU 0x0039  ; b
v_c                            EQU 0x003a  ; c
v_d                            EQU 0x003c  ; d
v_e                            EQU 0x003e  ; e
v___f_1                        EQU 0x0042  ; f
v_g                            EQU 0x0037  ; g-->_bitbucket:1
v___x_118                      EQU 0x0046  ; x
v___x_116                      EQU 0x0036  ; x-->_portc_shadow:2
v___x_117                      EQU 0x0036  ; x-->_portc_shadow:2
v____device_put_34             EQU 0x0047  ; print_byte_dec:_device_put
v___data_71                    EQU 0x0049  ; print_byte_dec:data
v____device_put_33             EQU 0x0047  ; print_word_dec:_device_put
v___data_69                    EQU 0x0049  ; print_word_dec:data
v____device_put_32             EQU 0x0047  ; print_dword_dec:_device_put
v___data_67                    EQU 0x0049  ; print_dword_dec:data
v____device_put_31             EQU 0x0047  ; print_sbyte_dec:_device_put
v___data_65                    EQU 0x0049  ; print_sbyte_dec:data
v____device_put_29             EQU 0x0047  ; print_sword_dec:_device_put
v___data_61                    EQU 0x0049  ; print_sword_dec:data
v____device_put_28             EQU 0x0047  ; print_sdword_dec:_device_put
v___data_59                    EQU 0x0049  ; print_sdword_dec:data
v____device_put_27             EQU 0x0047  ; print_byte_hex:_device_put
v___data_57                    EQU 0x0049  ; print_byte_hex:data
v____temp_64                   EQU 0x004d  ; print_byte_hex:_temp
v____device_put_26             EQU 0x0047  ; print_word_hex:_device_put
v___data_55                    EQU 0x0049  ; print_word_hex:data
v____temp_63                   EQU 0x004f  ; print_word_hex:_temp
v____device_put_24             EQU 0x0047  ; print_dword_hex:_device_put
v___data_51                    EQU 0x0049  ; print_dword_hex:data
v____temp_61                   EQU 0x0055  ; print_dword_hex:_temp
v____device_put_21             EQU 0x0047  ; print_word_binary:_device_put
v___data_45                    EQU 0x0049  ; print_word_binary:data
v____temp_58                   EQU 0x004f  ; print_word_binary:_temp
v____device_put_20             EQU 0x0047  ; print_dword_binary:_device_put
v___data_43                    EQU 0x0049  ; print_dword_binary:data
v____temp_57                   EQU 0x0055  ; print_dword_binary:_temp
v____device_put_19             EQU 0x0047  ; print_bit_10:_device_put
v___data_41                    EQU 0x0049  ; print_bit_10:data-->_bitbucket15:0
v____bitbucket_15              EQU 0x0049  ; print_bit_10:_bitbucket
v____device_put_18             EQU 0x0047  ; print_bit_highlow:_device_put
v___data_39                    EQU 0x0049  ; print_bit_highlow:data-->_bitbucket16:0
v____bitbucket_16              EQU 0x0049  ; print_bit_highlow:_bitbucket
v____device_put_17             EQU 0x0047  ; print_bit_truefalse:_device_put
v___data_37                    EQU 0x0049  ; print_bit_truefalse:data-->_bitbucket17:0
v____bitbucket_17              EQU 0x0049  ; print_bit_truefalse:_bitbucket
v____device_put_16             EQU 0x004d  ; print_string:_device_put
v__str_count                   EQU 0x0053  ; print_string:_str_count
v___str_1                      EQU 0x005d  ; print_string:str
v___len_2                      EQU 0x0063  ; print_string:len
v___i_1                        EQU 0x0066  ; print_string:i
v____device_put_15             EQU 0x0047  ; print_crlf:_device_put
v____device_put_22             EQU 0x005d  ; print_byte_binary:_device_put
v___data_47                    EQU 0x0063  ; print_byte_binary:data
v__floop8                      EQU 0x0065  ; print_byte_binary:_floop8
v____temp_59                   EQU 0x0066  ; print_byte_binary:_temp
v____device_put_35             EQU 0x0055  ; _print_suniversal_dec:_device_put
v___data_73                    EQU 0x005f  ; _print_suniversal_dec:data
v___digit_divisor_3            EQU 0x0067  ; _print_suniversal_dec:digit_divisor
v___digit_number_3             EQU 0x006b  ; _print_suniversal_dec:digit_number
v____device_put_36             EQU 0x006c  ; _print_universal_dec:_device_put
v___data_75                    EQU 0x00a0  ; _print_universal_dec:data
v___digit_divisor_5            EQU 0x00a4  ; _print_universal_dec:digit_divisor
v___digit_number_5             EQU 0x006e  ; _print_universal_dec:digit_number
v___digit_8                    EQU 0x006f  ; _print_universal_dec:digit
v_no_digits_printed_yet        EQU 0x00a9  ; _print_universal_dec:no_digits_printed_yet-->_bitbucket22:0
v____temp_67                   EQU 0x00a8  ; _print_universal_dec:_temp
v____bitbucket_22              EQU 0x00a9  ; _print_universal_dec:_bitbucket
v__btemp67                     EQU 0x00a9  ; _print_universal_dec:_btemp67-->_bitbucket22:3
v__btemp68                     EQU 0x00a9  ; _print_universal_dec:_btemp68-->_bitbucket22:4
v__btemp69                     EQU 0x00a9  ; _print_universal_dec:_btemp69-->_bitbucket22:5
v___data_32                    EQU 0       ; format_dword_hex(): data
v___data_30                    EQU 0       ; format_word_hex(): data
v_char                         EQU 0       ; format_sword_dec_length(): char
v___data_9                     EQU 0x0034  ; _serial_hw_data_put:data
v___data_3                     EQU 0       ; serial_hw_write_word(): data
v___data_1                     EQU 0x0035  ; serial_hw_write:data
v_usart_div                    EQU 10      ; _calculate_and_set_baudrate(): usart_div
v___n_5                        EQU 0x0047  ; delay_100ms:n
v__floop3                      EQU 0x0049  ; delay_100ms:_floop3
;   78  include outdir/16f877a_serial_print_err
                               org      0                   ;  0 -- -- -- [-- --] 0000
                               branchhi_clr l__main         ;  0 -V rs rs [hl hl] 0000 120a
                               branchlo_clr l__main         ;  0 -V rs rs [hl hl] 0001 118a
                               goto     l__main             ;  0 -V rs rs [hl hl] 0002 2958
                               nop                          ; 4294967295 -- -- -- [-- --] 0003 0000
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0004 0782
l__data_str7
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0005 3420
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 0006 3461
                               retlw    110                 ; 4294967295 -V -- -- [-- --] 0007 346e
                               retlw    100                 ; 4294967295 -V -- -- [-- --] 0008 3464
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0009 3420
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 000a 3472
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 000b 3465
                               retlw    112                 ; 4294967295 -V -- -- [-- --] 000c 3470
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 000d 3472
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 000e 3465
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 000f 3473
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0010 3465
                               retlw    110                 ; 4294967295 -V -- -- [-- --] 0011 346e
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0012 3474
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 0013 3473
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0014 3420
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 0015 3441
                               retlw    83                  ; 4294967295 -V -- -- [-- --] 0016 3453
                               retlw    67                  ; 4294967295 -V -- -- [-- --] 0017 3443
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 0018 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 0019 3449
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 001a 3420
                               retlw    99                  ; 4294967295 -V -- -- [-- --] 001b 3463
                               retlw    104                 ; 4294967295 -V -- -- [-- --] 001c 3468
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 001d 3461
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 001e 3472
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 001f 3461
                               retlw    99                  ; 4294967295 -V -- -- [-- --] 0020 3463
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0021 3474
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0022 3465
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 0023 3472
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0024 3420
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0025 0782
l__data_str5
                               retlw    86                  ; 4294967295 -V -- -- [-- --] 0026 3456
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 0027 3461
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 0028 3472
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 0029 3469
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 002a 3461
                               retlw    98                  ; 4294967295 -V -- -- [-- --] 002b 3462
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 002c 346c
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 002d 3465
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 002e 3420
                               retlw    120                 ; 4294967295 -V -- -- [-- --] 002f 3478
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0030 3420
                               retlw    104                 ; 4294967295 -V -- -- [-- --] 0031 3468
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 0032 3461
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 0033 3473
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0034 3420
                               retlw    100                 ; 4294967295 -V -- -- [-- --] 0035 3464
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0036 3465
                               retlw    99                  ; 4294967295 -V -- -- [-- --] 0037 3463
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 0038 3469
                               retlw    109                 ; 4294967295 -V -- -- [-- --] 0039 346d
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 003a 3461
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 003b 346c
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 003c 3420
                               retlw    118                 ; 4294967295 -V -- -- [-- --] 003d 3476
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 003e 3461
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 003f 346c
                               retlw    117                 ; 4294967295 -V -- -- [-- --] 0040 3475
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0041 3465
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0042 3420
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0043 0782
l__data_str1_2
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0044 3420
                               retlw    45                  ; 4294967295 -V -- -- [-- --] 0045 342d
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0046 3420
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 0047 3454
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0048 3465
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 0049 3473
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 004a 3474
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 004b 3420
                               retlw    112                 ; 4294967295 -V -- -- [-- --] 004c 3470
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 004d 3472
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 004e 3469
                               retlw    110                 ; 4294967295 -V -- -- [-- --] 004f 346e
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0050 3474
                               retlw    46                  ; 4294967295 -V -- -- [-- --] 0051 342e
                               retlw    106                 ; 4294967295 -V -- -- [-- --] 0052 346a
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 0053 3461
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 0054 346c
                               retlw    45                  ; 4294967295 -V -- -- [-- --] 0055 342d
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0056 3420
                               retlw    98                  ; 4294967295 -V -- -- [-- --] 0057 3462
                               retlw    121                 ; 4294967295 -V -- -- [-- --] 0058 3479
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0059 3474
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 005a 3465
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 005b 3473
                               retlw    13                  ; 4294967295 -V -- -- [-- --] 005c 340d
                               retlw    10                  ; 4294967295 -V -- -- [-- --] 005d 340a
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 005e 0782
l__data_str3
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 005f 3454
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0060 3465
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 0061 3473
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0062 3474
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0063 3420
                               retlw    112                 ; 4294967295 -V -- -- [-- --] 0064 3470
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 0065 3472
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 0066 3469
                               retlw    110                 ; 4294967295 -V -- -- [-- --] 0067 346e
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0068 3474
                               retlw    46                  ; 4294967295 -V -- -- [-- --] 0069 342e
                               retlw    106                 ; 4294967295 -V -- -- [-- --] 006a 346a
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 006b 3461
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 006c 346c
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 006d 3420
                               retlw    45                  ; 4294967295 -V -- -- [-- --] 006e 342d
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 006f 3420
                               retlw    100                 ; 4294967295 -V -- -- [-- --] 0070 3464
                               retlw    119                 ; 4294967295 -V -- -- [-- --] 0071 3477
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 0072 346f
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 0073 3472
                               retlw    100                 ; 4294967295 -V -- -- [-- --] 0074 3464
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 0075 3473
                               retlw    13                  ; 4294967295 -V -- -- [-- --] 0076 340d
                               retlw    10                  ; 4294967295 -V -- -- [-- --] 0077 340a
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0078 0782
l__data_str2
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 0079 3454
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 007a 3465
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 007b 3473
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 007c 3474
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 007d 3420
                               retlw    112                 ; 4294967295 -V -- -- [-- --] 007e 3470
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 007f 3472
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 0080 3469
                               retlw    110                 ; 4294967295 -V -- -- [-- --] 0081 346e
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0082 3474
                               retlw    46                  ; 4294967295 -V -- -- [-- --] 0083 342e
                               retlw    106                 ; 4294967295 -V -- -- [-- --] 0084 346a
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 0085 3461
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 0086 346c
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0087 3420
                               retlw    45                  ; 4294967295 -V -- -- [-- --] 0088 342d
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0089 3420
                               retlw    119                 ; 4294967295 -V -- -- [-- --] 008a 3477
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 008b 346f
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 008c 3472
                               retlw    100                 ; 4294967295 -V -- -- [-- --] 008d 3464
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 008e 3473
                               retlw    13                  ; 4294967295 -V -- -- [-- --] 008f 340d
                               retlw    10                  ; 4294967295 -V -- -- [-- --] 0090 340a
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0091 0782
l__data_str4
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 0092 3454
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0093 3465
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 0094 3473
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0095 3474
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0096 3420
                               retlw    112                 ; 4294967295 -V -- -- [-- --] 0097 3470
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 0098 3472
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 0099 3469
                               retlw    110                 ; 4294967295 -V -- -- [-- --] 009a 346e
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 009b 3474
                               retlw    46                  ; 4294967295 -V -- -- [-- --] 009c 342e
                               retlw    106                 ; 4294967295 -V -- -- [-- --] 009d 346a
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 009e 3461
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 009f 346c
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 00a0 3420
                               retlw    45                  ; 4294967295 -V -- -- [-- --] 00a1 342d
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 00a2 3420
                               retlw    98                  ; 4294967295 -V -- -- [-- --] 00a3 3462
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 00a4 3469
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 00a5 3474
                               retlw    13                  ; 4294967295 -V -- -- [-- --] 00a6 340d
                               retlw    10                  ; 4294967295 -V -- -- [-- --] 00a7 340a
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 00a8 0782
l__data_str6
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 00a9 3420
                               retlw    119                 ; 4294967295 -V -- -- [-- --] 00aa 3477
                               retlw    104                 ; 4294967295 -V -- -- [-- --] 00ab 3468
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 00ac 3469
                               retlw    99                  ; 4294967295 -V -- -- [-- --] 00ad 3463
                               retlw    104                 ; 4294967295 -V -- -- [-- --] 00ae 3468
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 00af 3420
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 00b0 3469
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 00b1 3473
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 00b2 3420
                               retlw    104                 ; 4294967295 -V -- -- [-- --] 00b3 3468
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 00b4 3465
                               retlw    120                 ; 4294967295 -V -- -- [-- --] 00b5 3478
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 00b6 3420
                               retlw    118                 ; 4294967295 -V -- -- [-- --] 00b7 3476
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 00b8 3461
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 00b9 346c
                               retlw    117                 ; 4294967295 -V -- -- [-- --] 00ba 3475
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 00bb 3465
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 00bc 3420
l__lookup_nibble2hex
                               addwf    v__pcl,f            ;  2 -V rs rs [?? ??] 00bd 0782
                               retlw    48                  ; 4294967295 -V -- -- [-- --] 00be 3430
                               retlw    49                  ; 4294967295 -V -- -- [-- --] 00bf 3431
                               retlw    50                  ; 4294967295 -V -- -- [-- --] 00c0 3432
                               retlw    51                  ; 4294967295 -V -- -- [-- --] 00c1 3433
                               retlw    52                  ; 4294967295 -V -- -- [-- --] 00c2 3434
                               retlw    53                  ; 4294967295 -V -- -- [-- --] 00c3 3435
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 00c4 3436
                               retlw    55                  ; 4294967295 -V -- -- [-- --] 00c5 3437
                               retlw    56                  ; 4294967295 -V -- -- [-- --] 00c6 3438
                               retlw    57                  ; 4294967295 -V -- -- [-- --] 00c7 3439
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00c8 3441
                               retlw    66                  ; 4294967295 -V -- -- [-- --] 00c9 3442
                               retlw    67                  ; 4294967295 -V -- -- [-- --] 00ca 3443
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 00cb 3444
                               retlw    69                  ; 4294967295 -V -- -- [-- --] 00cc 3445
                               retlw    70                  ; 4294967295 -V -- -- [-- --] 00cd 3446
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 00ce 0782
l__data_str0
                               retlw    102                 ; 4294967295 -V -- -- [-- --] 00cf 3466
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 00d0 3461
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 00d1 346c
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 00d2 3473
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 00d3 3465
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 00d4 0782
l__data_str1
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 00d5 3474
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 00d6 3472
                               retlw    117                 ; 4294967295 -V -- -- [-- --] 00d7 3475
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 00d8 3465
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 00d9 0782
l__data_str1_1
                               retlw    104                 ; 4294967295 -V -- -- [-- --] 00da 3468
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 00db 3469
                               retlw    103                 ; 4294967295 -V -- -- [-- --] 00dc 3467
                               retlw    104                 ; 4294967295 -V -- -- [-- --] 00dd 3468
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 00de 0782
l__data_str0_1
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 00df 346c
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 00e0 346f
                               retlw    119                 ; 4294967295 -V -- -- [-- --] 00e1 3477
l__pic_sdivide
                               movlw    0                   ;  2 OV rs rs [?? ??] 00e2 3000
                                                            ; W = v__pic_dividend
                               btfss    v__pic_dividend+3, 7;  2 OV rs rs [?? ??] 00e3 1fa3
                               goto     l__l562             ;  2 OV rs rs [?? ??] 00e4 28f1
                               comf     v__pic_dividend,f   ;  2 OV rs rs [?? ??] 00e5 09a0
                               comf     v__pic_dividend+1,f ;  2 OV rs rs [?? ??] 00e6 09a1
                               comf     v__pic_dividend+2,f ;  2 OV rs rs [?? ??] 00e7 09a2
                               comf     v__pic_dividend+3,f ;  2 OV rs rs [?? ??] 00e8 09a3
                               incf     v__pic_dividend,f   ;  2 OV rs rs [?? ??] 00e9 0aa0
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00ea 1903
                               incf     v__pic_dividend+1,f ;  2 OV rs rs [?? ??] 00eb 0aa1
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00ec 1903
                               incf     v__pic_dividend+2,f ;  2 OV rs rs [?? ??] 00ed 0aa2
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00ee 1903
                               incf     v__pic_dividend+3,f ;  2 OV rs rs [?? ??] 00ef 0aa3
                               movlw    1                   ;  2 OV rs rs [?? ??] 00f0 3001
l__l562
                               movwf    v__pic_sign         ;  2 OV rs rs [?? ??] 00f1 00b1
                               movlw    0                   ;  2 OV rs rs [?? ??] 00f2 3000
                                                            ; W = v__pic_sign
                               btfss    v__pic_divisor+3, 7 ;  2 OV rs rs [?? ??] 00f3 1fab
                               goto     l__l563             ;  2 OV rs rs [?? ??] 00f4 2901
                               comf     v__pic_divisor,f    ;  2 OV rs rs [?? ??] 00f5 09a8
                               comf     v__pic_divisor+1,f  ;  2 OV rs rs [?? ??] 00f6 09a9
                               comf     v__pic_divisor+2,f  ;  2 OV rs rs [?? ??] 00f7 09aa
                               comf     v__pic_divisor+3,f  ;  2 OV rs rs [?? ??] 00f8 09ab
                               incf     v__pic_divisor,f    ;  2 OV rs rs [?? ??] 00f9 0aa8
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00fa 1903
                               incf     v__pic_divisor+1,f  ;  2 OV rs rs [?? ??] 00fb 0aa9
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00fc 1903
                               incf     v__pic_divisor+2,f  ;  2 OV rs rs [?? ??] 00fd 0aaa
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00fe 1903
                               incf     v__pic_divisor+3,f  ;  2 OV rs rs [?? ??] 00ff 0aab
                               movlw    1                   ;  2 OV rs rs [?? ??] 0100 3001
l__l563
                               xorwf    v__pic_sign,f       ;  2 OV rs rs [?? ??] 0101 06b1
                               goto     l__l564             ;  2 OV rs rs [?? ??] 0102 2904
l__pic_divide
                               clrf     v__pic_sign         ;  2 OV rs rs [?? ??] 0103 01b1
                                                            ; W = v__pic_dividend
l__l564
                               movlw    32                  ;  2 OV rs rs [?? ??] 0104 3020
                                                            ; W = v__pic_dividend
                               movwf    v__pic_loop         ;  2 OV rs rs [?? ??] 0105 00b0
                               clrf     v__pic_remainder    ;  2 OV rs rs [?? ??] 0106 01a4
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+1  ;  2 OV rs rs [?? ??] 0107 01a5
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+2  ;  2 OV rs rs [?? ??] 0108 01a6
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+3  ;  2 OV rs rs [?? ??] 0109 01a7
                                                            ; W = v__pic_loop
l__l559
                               bcf      v__status, v__c     ;  2 OV rs rs [?? ??] 010a 1003
                               rlf      v__pic_quotient,f   ;  2 OV rs rs [?? ??] 010b 0dac
                               rlf      v__pic_quotient+1,f ;  2 OV rs rs [?? ??] 010c 0dad
                               rlf      v__pic_quotient+2,f ;  2 OV rs rs [?? ??] 010d 0dae
                               rlf      v__pic_quotient+3,f ;  2 OV rs rs [?? ??] 010e 0daf
                               bcf      v__status, v__c     ;  2 OV rs rs [?? ??] 010f 1003
                               rlf      v__pic_divaccum,f   ;  2 OV rs rs [?? ??] 0110 0da0
                               rlf      v__pic_divaccum+1,f ;  2 OV rs rs [?? ??] 0111 0da1
                               rlf      v__pic_divaccum+2,f ;  2 OV rs rs [?? ??] 0112 0da2
                               rlf      v__pic_divaccum+3,f ;  2 OV rs rs [?? ??] 0113 0da3
                               rlf      v__pic_divaccum+4,f ;  2 OV rs rs [?? ??] 0114 0da4
                               rlf      v__pic_divaccum+5,f ;  2 OV rs rs [?? ??] 0115 0da5
                               rlf      v__pic_divaccum+6,f ;  2 OV rs rs [?? ??] 0116 0da6
                               rlf      v__pic_divaccum+7,f ;  2 OV rs rs [?? ??] 0117 0da7
                               movf     v__pic_remainder+3,w;  2 OV rs rs [?? ??] 0118 0827
                               subwf    v__pic_divisor+3,w  ;  2 OV rs rs [?? ??] 0119 022b
                                                            ; W = v__pic_remainder
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 011a 1d03
                               goto     l__l565             ;  2 OV rs rs [?? ??] 011b 2926
                               movf     v__pic_remainder+2,w;  2 OV rs rs [?? ??] 011c 0826
                                                            ; W = v__pic_sign
                               subwf    v__pic_divisor+2,w  ;  2 OV rs rs [?? ??] 011d 022a
                                                            ; W = v__pic_remainder
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 011e 1d03
                               goto     l__l565             ;  2 OV rs rs [?? ??] 011f 2926
                               movf     v__pic_remainder+1,w;  2 OV rs rs [?? ??] 0120 0825
                               subwf    v__pic_divisor+1,w  ;  2 OV rs rs [?? ??] 0121 0229
                                                            ; W = v__pic_remainder
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 0122 1d03
                               goto     l__l565             ;  2 OV rs rs [?? ??] 0123 2926
                               movf     v__pic_remainder,w  ;  2 OV rs rs [?? ??] 0124 0824
                               subwf    v__pic_divisor,w    ;  2 OV rs rs [?? ??] 0125 0228
                                                            ; W = v__pic_remainder
l__l565
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0126 1903
                               goto     l__l561             ;  2 OV rs rs [?? ??] 0127 292a
                               btfsc    v__status, v__c     ;  2 OV rs rs [?? ??] 0128 1803
                                                            ; W = v__pic_sign
                               goto     l__l560             ;  2 OV rs rs [?? ??] 0129 2939
                                                            ; W = v__pic_sign
l__l561
                               movf     v__pic_divisor,w    ;  2 OV rs rs [?? ??] 012a 0828
                               subwf    v__pic_remainder,f  ;  2 OV rs rs [?? ??] 012b 02a4
                                                            ; W = v__pic_divisor
                               movf     v__pic_divisor+1,w  ;  2 OV rs rs [?? ??] 012c 0829
                                                            ; W = v__pic_divisor
                               btfss    v__status, v__c     ;  2 OV rs rs [?? ??] 012d 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+1,w  ;  2 OV rs rs [?? ??] 012e 0f29
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+1,f;  2 OV rs rs [?? ??] 012f 02a5
                               movf     v__pic_divisor+2,w  ;  2 OV rs rs [?? ??] 0130 082a
                               btfss    v__status, v__c     ;  2 OV rs rs [?? ??] 0131 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+2,w  ;  2 OV rs rs [?? ??] 0132 0f2a
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+2,f;  2 OV rs rs [?? ??] 0133 02a6
                               movf     v__pic_divisor+3,w  ;  2 OV rs rs [?? ??] 0134 082b
                               btfss    v__status, v__c     ;  2 OV rs rs [?? ??] 0135 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+3,w  ;  2 OV rs rs [?? ??] 0136 0f2b
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+3,f;  2 OV rs rs [?? ??] 0137 02a7
                               bsf      v__pic_quotient, 0  ;  2 OV rs rs [?? ??] 0138 142c
l__l560
                               decfsz   v__pic_loop,f       ;  2 OV rs rs [?? ??] 0139 0bb0
                                                            ; W = v__pic_sign
                               goto     l__l559             ;  2 OV rs rs [?? ??] 013a 290a
                                                            ; W = v__pic_sign
                               movf     v__pic_sign,w       ;  2 OV rs rs [?? ??] 013b 0831
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 013c 1903
                                                            ; W = v__pic_sign
                               return                       ;  2 OV rs rs [?? ??] 013d 0008
                                                            ; W = v__pic_sign
                               comf     v__pic_quotient,f   ;  2 OV rs rs [?? ??] 013e 09ac
                               comf     v__pic_quotient+1,f ;  2 OV rs rs [?? ??] 013f 09ad
                               comf     v__pic_quotient+2,f ;  2 OV rs rs [?? ??] 0140 09ae
                               comf     v__pic_quotient+3,f ;  2 OV rs rs [?? ??] 0141 09af
                               incf     v__pic_quotient,f   ;  2 OV rs rs [?? ??] 0142 0aac
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0143 1903
                               incf     v__pic_quotient+1,f ;  2 OV rs rs [?? ??] 0144 0aad
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0145 1903
                               incf     v__pic_quotient+2,f ;  2 OV rs rs [?? ??] 0146 0aae
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0147 1903
                               incf     v__pic_quotient+3,f ;  2 OV rs rs [?? ??] 0148 0aaf
                               comf     v__pic_remainder,f  ;  2 OV rs rs [?? ??] 0149 09a4
                               comf     v__pic_remainder+1,f;  2 OV rs rs [?? ??] 014a 09a5
                               comf     v__pic_remainder+2,f;  2 OV rs rs [?? ??] 014b 09a6
                               comf     v__pic_remainder+3,f;  2 OV rs rs [?? ??] 014c 09a7
                               incf     v__pic_remainder,f  ;  2 OV rs rs [?? ??] 014d 0aa4
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 014e 1903
                               incf     v__pic_remainder+1,f;  2 OV rs rs [?? ??] 014f 0aa5
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0150 1903
                               incf     v__pic_remainder+2,f;  2 OV rs rs [?? ??] 0151 0aa6
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0152 1903
                               incf     v__pic_remainder+3,f;  2 OV rs rs [?? ??] 0153 0aa7
                               return                       ;  2 OV rs rs [?? ??] 0154 0008
l__pic_indirect
                               movwf    v__pclath           ;  3 OV rs rs [?? ??] 0155 008a
                               movf     v__pic_pointer,w    ;  3 OV rs rs [?? ??] 0156 0832
                               movwf    v__pcl              ;  3 OV rs rs [?? ??] 0157 0082
                                                            ; W = v__pic_pointer
l__main
; c:\jallib\include\device/16f877a.jal
;  294 var          byte  _PORTC_shadow        = PORTC
                               movf     v_portc,w           ;  0 OV rs rs [hl hl] 0158 0807
                               movwf    v__portc_shadow     ;  0 OV rs rs [hl hl] 0159 00b6
;  516 procedure _PORTE_flush() is
                               goto     l__l267             ;  0 OV rs rs [hl hl] 015a 297f
                                                            ; W = v__portc_shadow
; c:\jallib\include\jal/delay.jal
;  125 procedure delay_100ms(word in n) is
l_delay_100ms
;  127    for n loop
                               clrf     v__floop3           ;  1 OV rs rs [?? ??] 015b 01c9
                                                            ; W = v___n_5
                               clrf     v__floop3+1         ;  1 OV rs rs [?? ??] 015c 01ca
                                                            ; W = v___n_5
                               goto     l__l265             ;  1 OV rs rs [?? ??] 015d 2976
                                                            ; W = v___n_5
l__l264
;  128       _usec_delay(_100_ms_delay)
                               datalo_clr v__pic_temp       ;  1 -V rs rs [?? ??] 015e 1283
                               datahi_clr v__pic_temp       ;  1 -V rs rs [?? ??] 015f 1303
                               movlw    94                  ;  1 -V rs rs [?? ??] 0160 305e
                               movwf    v__pic_temp         ;  1 -V rs rs [?? ??] 0161 00a0
l__l566
                               movlw    253                 ;  1 -V rs rs [?? ??] 0162 30fd
                               movwf    v__pic_temp+1       ;  1 -V rs rs [?? ??] 0163 00a1
l__l567
                               movlw    3                   ;  1 -V rs rs [?? ??] 0164 3003
                               movwf    v__pic_temp+2       ;  1 -V rs rs [?? ??] 0165 00a2
l__l568
                               branchhi_clr l__l568         ;  1 -V rs rs [?? h?] 0166 120a
                               branchlo_clr l__l568         ;  1 -V rs rs [h? hl] 0167 118a
                               decfsz   v__pic_temp+2,f     ;  1 -V rs rs [hl hl] 0168 0ba2
                               goto     l__l568             ;  1 -V rs rs [hl hl] 0169 2966
                               branchhi_clr l__l567         ;  1 -V rs rs [hl hl] 016a 120a
                               branchlo_clr l__l567         ;  1 -V rs rs [hl hl] 016b 118a
                               decfsz   v__pic_temp+1,f     ;  1 -V rs rs [hl hl] 016c 0ba1
                               goto     l__l567             ;  1 -V rs rs [hl hl] 016d 2964
                               branchhi_clr l__l566         ;  1 -V rs rs [hl hl] 016e 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l566         ;  1 -V rs rs [hl hl] 016f 118a
                                                            ; W = v__pic_temp
                               decfsz   v__pic_temp,f       ;  1 -V rs rs [hl hl] 0170 0ba0
                                                            ; W = v__pic_temp
                               goto     l__l566             ;  1 -V rs rs [hl hl] 0171 2962
                                                            ; W = v__pic_temp
                               nop                          ;  1 -V rs rs [hl hl] 0172 0000
                                                            ; W = v__pic_temp
;  129    end loop
                               incf     v__floop3,f         ;  1 OV rs rs [hl hl] 0173 0ac9
                                                            ; W = v__pic_temp
                               btfsc    v__status, v__z     ;  1 OV rs rs [hl hl] 0174 1903
                                                            ; W = v__pic_temp
                               incf     v__floop3+1,f       ;  1 OV rs rs [hl hl] 0175 0aca
                                                            ; W = v__pic_temp
l__l265
                               movf     v__floop3,w         ;  1 OV rs rs [?? ??] 0176 0849
                                                            ; W = v___n_5
                               subwf    v___n_5,w           ;  1 OV rs rs [?? ??] 0177 0247
                                                            ; W = v__floop3
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0178 00a0
                               movf     v__floop3+1,w       ;  1 OV rs rs [?? ??] 0179 084a
                                                            ; W = v__pic_temp
                               subwf    v___n_5+1,w         ;  1 OV rs rs [?? ??] 017a 0248
                                                            ; W = v__floop3
                               iorwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 017b 0420
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 017c 1d03
                               goto     l__l264             ;  1 OV rs rs [?? ??] 017d 295e
;  130 end procedure
                               return                       ;  1 OV rs rs [?? ??] 017e 0008
                                                            ; W = v__pic_temp
;  138 end procedure
l__l267
; outdir/16f877a_serial_print_err.jal
;   44 enable_digital_io()
; c:\jallib\include\device/16f877a.jal
; 1056    ADCON0 = 0b0000_0000         -- disable ADC
                               clrf     v_adcon0            ;  0 OV rs rs [hl hl] 017f 019f
                                                            ; W = v__portc_shadow
; 1057    ADCON1 = 0b0000_0111         -- digital I/O
                               movlw    7                   ;  0 OV rs rs [hl hl] 0180 3007
                                                            ; W = v__portc_shadow
                               datalo_set v_adcon1          ;  0 OV rs rS [hl hl] 0181 1683
                               movwf    v_adcon1            ;  0 OV rS rS [hl hl] 0182 009f
; outdir/16f877a_serial_print_err.jal
;   44 enable_digital_io()
; c:\jallib\include\device/16f877a.jal
; 1071    adc_off()
; outdir/16f877a_serial_print_err.jal
;   44 enable_digital_io()
; c:\jallib\include\device/16f877a.jal
; 1064    CMCON  = 0b0000_0111        -- disable comparator
                               movlw    7                   ;  0 OV rS rS [hl hl] 0183 3007
                               movwf    v_cmcon             ;  0 OV rS rS [hl hl] 0184 009c
; outdir/16f877a_serial_print_err.jal
;   44 enable_digital_io()
; c:\jallib\include\device/16f877a.jal
; 1072    comparator_off()
; outdir/16f877a_serial_print_err.jal
;   44 enable_digital_io()
; c:\jallib\include\peripheral\usart/usart_common.jal
;   21 end if
                               goto     l__l338             ;  0 OV rS rS [hl hl] 0185 299e
;   43 procedure _calculate_and_set_baudrate() is
l__calculate_and_set_baudrate
;   99                SPBRG = usart_div 
                               movlw    10                  ;  2 OV rS rS [hl hl] 0186 300a
                               movwf    v_spbrg             ;  2 OV rS rS [hl hl] 0187 0099
;  103             TXSTA_BRGH = true
                               bsf      v_txsta, 2 ; txsta_brgh       ;  2 OV rS rS [hl hl] 0188 1518
;  152 end procedure
                               return                       ;  2 OV rS rS [hl hl] 0189 0008
; c:\jallib\include\peripheral\usart/serial_hardware.jal
;   25 procedure serial_hw_init() is 
l_serial_hw_init
;   27    _calculate_and_set_baudrate()
                               call     l__calculate_and_set_baudrate;  1 OV rS ?? [hl ??] 018a 2186
;   30    PIE1_RCIE = false
                               datalo_set v_pie1 ; pie1_rcie         ;  1 OV ?? ?S [?? ??] 018b 1683
                               bcf      v_pie1, 5 ; pie1_rcie        ;  1 OV rS rS [?? ??] 018c 128c
;   31    PIE1_TXIE = false
                               bcf      v_pie1, 4 ; pie1_txie        ;  1 OV rS rS [?? ??] 018d 120c
;   34    TXSTA_TXEN = true
                               bsf      v_txsta, 5 ; txsta_txen       ;  1 OV rS rS [?? ??] 018e 1698
;   38    RCSTA = 0x90
                               movlw    144                 ;  1 OV rS rS [?? ??] 018f 3090
                               datalo_clr v_rcsta           ;  1 OV rS rs [?? ??] 0190 1283
                               movwf    v_rcsta             ;  1 OV rs rs [?? ??] 0191 0098
;   40 end procedure
                               return                       ;  1 OV rs rs [?? ??] 0192 0008
;   67 procedure serial_hw_write(byte in data) is
l_serial_hw_write
                               movwf    v___data_1          ;  1 OV rs rs [?? ??] 0193 00b5
                                                            ; W = v___data_9
;   69    while ! PIR1_TXIF loop end loop
l__l300
                               btfss    v_pir1, 4 ; pir1_txif        ;  1 OV rs rs [?? ??] 0194 1e0c
                                                            ; W = v___data_1
                               goto     l__l300             ;  1 OV rs rs [?? ??] 0195 2994
l__l301
;   71    TXREG = data
                               movf     v___data_1,w        ;  1 OV rs rs [?? ??] 0196 0835
                                                            ; W = v___data_1
                               movwf    v_txreg             ;  1 OV rs rs [?? ??] 0197 0099
                                                            ; W = v___data_1
;   72 end procedure
                               return                       ;  1 OV rs rs [?? ??] 0198 0008
;  146 procedure serial_hw_data'put(byte in data) is
l__serial_hw_data_put
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0199 1283
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 019a 0820
                               movwf    v___data_9          ;  1 OV rs rs [?? ??] 019b 00b4
                                                            ; W = v__pic_temp
;  147    serial_hw_write(data)
                               movf     v___data_9,w        ;  1 OV rs rs [?? ??] 019c 0834
                                                            ; W = v___data_9
                               goto     l_serial_hw_write   ;  1 OV rs rs [?? ??] 019d 2993
                                                            ; W = v___data_9
;  148 end procedure
;  175 end function
l__l338
; outdir/16f877a_serial_print_err.jal
;   50 serial_hw_init()
                               call     l_serial_hw_init    ;  0 OV rS ?? [hl ??] 019e 218a
; c:\jallib\include\jal/print.jal
;   55 var bit print_prefix = false        
                               datalo_clr v__bitbucket ; print_prefix   ;  0 OV ?? ?s [?? ??] 019f 1283
                               bcf      v__bitbucket, 0 ; print_prefix  ;  0 OV rs rs [?? ??] 01a0 1037
;   57 procedure print_crlf(volatile byte out device) is
                               goto     l__l445             ;  0 OV rs rs [?? ??] 01a1 2d8e
l_print_crlf
;   58    device = ASCII_CR -- cariage return
                               movlw    13                  ;  1 OV rs rs [?? ??] 01a2 300d
                                                            ; W = v____device_put_15
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01a3 00a0
                               movf     v____device_put_15,w;  1 OV rs rs [?? ??] 01a4 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 01a5 00b2
                                                            ; W = v____device_put_15
                               movf     v____device_put_15+1,w;  1 OV rs rs [?? ??] 01a6 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 01a7 2155
                                                            ; W = v____device_put_15
;   59    device = ASCII_LF -- line feed
                               movlw    10                  ;  1 OV ?? ?? [?? ??] 01a8 300a
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 01a9 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01aa 00a0
                               movf     v____device_put_15,w;  1 OV rs rs [?? ??] 01ab 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 01ac 00b2
                                                            ; W = v____device_put_15
                               movf     v____device_put_15+1,w;  1 OV rs rs [?? ??] 01ad 0848
                                                            ; W = v__pic_pointer
                               goto     l__pic_indirect     ;  1 OV rs rs [?? ??] 01ae 2955
                                                            ; W = v____device_put_15
;   60 end procedure
;   62 procedure print_string(volatile byte out device, byte in str[]) is
l_print_string
;   63    var word len = count(str)
                               movf     v__str_count,w      ;  1 OV rs rs [?? ??] 01af 0853
                                                            ; W = v___str_1
                               movwf    v___len_2           ;  1 OV rs rs [?? ??] 01b0 00e3
                                                            ; W = v__str_count
                               movf     v__str_count+1,w    ;  1 OV rs rs [?? ??] 01b1 0854
                                                            ; W = v___len_2
                               movwf    v___len_2+1         ;  1 OV rs rs [?? ??] 01b2 00e4
                                                            ; W = v__str_count
;   66    for len using i loop    
                               clrf     v___i_1             ;  1 OV rs rs [?? ??] 01b3 01e6
                                                            ; W = v___len_2
                               goto     l__l456             ;  1 OV rs rs [?? ??] 01b4 29d0
                                                            ; W = v___len_2
l__l455
;   67       if (str[i] == print_string_terminator) then 
                               movf     v___str_1,w         ;  1 OV rs rs [?? ??] 01b5 085d
                               addwf    v___i_1,w           ;  1 OV rs rs [?? ??] 01b6 0766
                                                            ; W = v___str_1
                               movwf    v__fsr              ;  1 OV rs rs [?? ??] 01b7 0084
                               bcf      v__status, v__irp   ;  1 OV rs rs [?? ??] 01b8 1383
                               btfsc    v___str_1+1, 0      ;  1 OV rs rs [?? ??] 01b9 185e
                               bsf      v__status, v__irp   ;  1 OV rs rs [?? ??] 01ba 1783
                               movf     v__ind,w            ;  1 OV rs rs [?? ??] 01bb 0800
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 01bc 1903
;   68          exit loop 
                               return                       ;  1 OV rs rs [?? ??] 01bd 0008
;   69       end if
l__l459
;   70       device = str[i]
                               movf     v___str_1+1,w       ;  1 OV rs rs [?? ??] 01be 085e
                               movwf    v__pic_pointer+1    ;  1 OV rs rs [?? ??] 01bf 00b3
                                                            ; W = v___str_1
                               movf     v___i_1,w           ;  1 OV rs rs [?? ??] 01c0 0866
                                                            ; W = v__pic_pointer
                               addwf    v___str_1,w         ;  1 OV rs rs [?? ??] 01c1 075d
                                                            ; W = v___i_1
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 01c2 00b2
                               btfsc    v__status, v__c     ;  1 OV rs rs [?? ??] 01c3 1803
                                                            ; W = v__pic_pointer
                               incf     v__pic_pointer+1,f  ;  1 OV rs rs [?? ??] 01c4 0ab3
                                                            ; W = v__pic_pointer
                               bcf      v__pic_pointer+1, 6 ;  1 OV rs rs [?? ??] 01c5 1333
                               movf     v__pic_pointer+1,w  ;  1 OV rs rs [?? ??] 01c6 0833
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 01c7 2155
                                                            ; W = v__pic_pointer
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 01c8 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01c9 00a0
                               movf     v____device_put_16,w;  1 OV rs rs [?? ??] 01ca 084d
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 01cb 00b2
                                                            ; W = v____device_put_16
                               movf     v____device_put_16+1,w;  1 OV rs rs [?? ??] 01cc 084e
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 01cd 2155
                                                            ; W = v____device_put_16
;   71    end loop
                               datalo_clr v___i_1           ;  1 OV ?? ?s [?? ??] 01ce 1283
                               incf     v___i_1,f           ;  1 OV rs rs [?? ??] 01cf 0ae6
l__l456
                               movf     v___i_1,w           ;  1 OV rs rs [?? ??] 01d0 0866
                                                            ; W = v___len_2
                               subwf    v___len_2,w         ;  1 OV rs rs [?? ??] 01d1 0263
                                                            ; W = v___i_1
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01d2 00a0
                               movf     v___len_2+1,w       ;  1 OV rs rs [?? ??] 01d3 0864
                                                            ; W = v__pic_temp
                               iorwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 01d4 0420
                                                            ; W = v___len_2
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 01d5 1d03
                               goto     l__l455             ;  1 OV rs rs [?? ??] 01d6 29b5
l__l457
;   73 end procedure
                               return                       ;  1 OV rs rs [?? ??] 01d7 0008
;   75 procedure print_bit_truefalse(volatile byte out device, bit in data) is
l_print_bit_truefalse
;   80    if (data) then
                               btfss    v____bitbucket_17, 0 ; data37;  1 OV rs rs [?? ??] 01d8 1c49
                                                            ; W = v____device_put_17
                               goto     l__l463             ;  1 OV rs rs [?? ??] 01d9 29e7
                                                            ; W = v____device_put_17
;   81       print_string(device, str1)
                               movf     v____device_put_17,w;  1 OV rs rs [?? ??] 01da 0847
                               movwf    v____device_put_16  ;  1 OV rs rs [?? ??] 01db 00cd
                                                            ; W = v____device_put_17
                               movf     v____device_put_17+1,w;  1 OV rs rs [?? ??] 01dc 0848
                                                            ; W = v____device_put_16
                               movwf    v____device_put_16+1;  1 OV rs rs [?? ??] 01dd 00ce
                                                            ; W = v____device_put_17
                               movlw    4                   ;  1 OV rs rs [?? ??] 01de 3004
                                                            ; W = v____device_put_16
                               movwf    v__str_count        ;  1 OV rs rs [?? ??] 01df 00d3
                               clrf     v__str_count+1      ;  1 OV rs rs [?? ??] 01e0 01d4
                                                            ; W = v__str_count
                               movlw    l__data_str1        ;  1 OV rs rs [?? ??] 01e1 30d5
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  1 OV rs rs [?? ??] 01e2 00dd
                               movlw    HIGH l__data_str1   ;  1 OV rs rs [?? ??] 01e3 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  1 OV rs rs [?? ??] 01e4 3840
                               movwf    v___str_1+1         ;  1 OV rs rs [?? ??] 01e5 00de
                               goto     l_print_string      ;  1 OV rs rs [?? ??] 01e6 29af
                                                            ; W = v___str_1
;   82    else
l__l463
;   83       print_string(device, str0)
                               movf     v____device_put_17,w;  1 OV rs rs [?? ??] 01e7 0847
                                                            ; W = v____device_put_17
                               movwf    v____device_put_16  ;  1 OV rs rs [?? ??] 01e8 00cd
                                                            ; W = v____device_put_17
                               movf     v____device_put_17+1,w;  1 OV rs rs [?? ??] 01e9 0848
                                                            ; W = v____device_put_16
                               movwf    v____device_put_16+1;  1 OV rs rs [?? ??] 01ea 00ce
                                                            ; W = v____device_put_17
                               movlw    5                   ;  1 OV rs rs [?? ??] 01eb 3005
                                                            ; W = v____device_put_16
                               movwf    v__str_count        ;  1 OV rs rs [?? ??] 01ec 00d3
                               clrf     v__str_count+1      ;  1 OV rs rs [?? ??] 01ed 01d4
                                                            ; W = v__str_count
                               movlw    l__data_str0        ;  1 OV rs rs [?? ??] 01ee 30cf
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  1 OV rs rs [?? ??] 01ef 00dd
                               movlw    HIGH l__data_str0   ;  1 OV rs rs [?? ??] 01f0 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  1 OV rs rs [?? ??] 01f1 3840
                               movwf    v___str_1+1         ;  1 OV rs rs [?? ??] 01f2 00de
                               goto     l_print_string      ;  1 OV rs rs [?? ??] 01f3 29af
                                                            ; W = v___str_1
;   84    end if
l__l462
;   86 end procedure
;   88 procedure print_bit_highlow(volatile byte out device, bit in data) is
l_print_bit_highlow
;   93    if (data) then
                               btfss    v____bitbucket_16, 0 ; data39;  1 OV rs rs [?? ??] 01f4 1c49
                                                            ; W = v____device_put_18
                               goto     l__l467             ;  1 OV rs rs [?? ??] 01f5 2a03
                                                            ; W = v____device_put_18
;   94       print_string(device, str1)
                               movf     v____device_put_18,w;  1 OV rs rs [?? ??] 01f6 0847
                               movwf    v____device_put_16  ;  1 OV rs rs [?? ??] 01f7 00cd
                                                            ; W = v____device_put_18
                               movf     v____device_put_18+1,w;  1 OV rs rs [?? ??] 01f8 0848
                                                            ; W = v____device_put_16
                               movwf    v____device_put_16+1;  1 OV rs rs [?? ??] 01f9 00ce
                                                            ; W = v____device_put_18
                               movlw    4                   ;  1 OV rs rs [?? ??] 01fa 3004
                                                            ; W = v____device_put_16
                               movwf    v__str_count        ;  1 OV rs rs [?? ??] 01fb 00d3
                               clrf     v__str_count+1      ;  1 OV rs rs [?? ??] 01fc 01d4
                                                            ; W = v__str_count
                               movlw    l__data_str1_1      ;  1 OV rs rs [?? ??] 01fd 30da
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  1 OV rs rs [?? ??] 01fe 00dd
                               movlw    HIGH l__data_str1_1 ;  1 OV rs rs [?? ??] 01ff 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  1 OV rs rs [?? ??] 0200 3840
                               movwf    v___str_1+1         ;  1 OV rs rs [?? ??] 0201 00de
                               goto     l_print_string      ;  1 OV rs rs [?? ??] 0202 29af
                                                            ; W = v___str_1
;   95    else
l__l467
;   96       print_string(device, str0)
                               movf     v____device_put_18,w;  1 OV rs rs [?? ??] 0203 0847
                                                            ; W = v____device_put_18
                               movwf    v____device_put_16  ;  1 OV rs rs [?? ??] 0204 00cd
                                                            ; W = v____device_put_18
                               movf     v____device_put_18+1,w;  1 OV rs rs [?? ??] 0205 0848
                                                            ; W = v____device_put_16
                               movwf    v____device_put_16+1;  1 OV rs rs [?? ??] 0206 00ce
                                                            ; W = v____device_put_18
                               movlw    3                   ;  1 OV rs rs [?? ??] 0207 3003
                                                            ; W = v____device_put_16
                               movwf    v__str_count        ;  1 OV rs rs [?? ??] 0208 00d3
                               clrf     v__str_count+1      ;  1 OV rs rs [?? ??] 0209 01d4
                                                            ; W = v__str_count
                               movlw    l__data_str0_1      ;  1 OV rs rs [?? ??] 020a 30df
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  1 OV rs rs [?? ??] 020b 00dd
                               movlw    HIGH l__data_str0_1 ;  1 OV rs rs [?? ??] 020c 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  1 OV rs rs [?? ??] 020d 3840
                               movwf    v___str_1+1         ;  1 OV rs rs [?? ??] 020e 00de
                               goto     l_print_string      ;  1 OV rs rs [?? ??] 020f 29af
                                                            ; W = v___str_1
;   97    end if
l__l466
;   99 end procedure
;  101 procedure print_bit_10(volatile byte out device, bit in data) is
l_print_bit_10
;  103    if (data) then
                               btfss    v____bitbucket_15, 0 ; data41;  1 OV rs rs [?? ??] 0210 1c49
                                                            ; W = v____device_put_19
                               goto     l__l471             ;  1 OV rs rs [?? ??] 0211 2a18
                                                            ; W = v____device_put_19
;  104       device = "1"
                               movlw    49                  ;  1 OV rs rs [?? ??] 0212 3031
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0213 00a0
                               movf     v____device_put_19,w;  1 OV rs rs [?? ??] 0214 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0215 00b2
                                                            ; W = v____device_put_19
                               movf     v____device_put_19+1,w;  1 OV rs rs [?? ??] 0216 0848
                                                            ; W = v__pic_pointer
                               goto     l__pic_indirect     ;  1 OV rs rs [?? ??] 0217 2955
                                                            ; W = v____device_put_19
;  105    else
l__l471
;  106       device = "0"
                               movlw    48                  ;  1 OV rs rs [?? ??] 0218 3030
                                                            ; W = v____device_put_19
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0219 00a0
                               movf     v____device_put_19,w;  1 OV rs rs [?? ??] 021a 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 021b 00b2
                                                            ; W = v____device_put_19
                               movf     v____device_put_19+1,w;  1 OV rs rs [?? ??] 021c 0848
                                                            ; W = v__pic_pointer
                               goto     l__pic_indirect     ;  1 OV rs rs [?? ??] 021d 2955
                                                            ; W = v____device_put_19
;  107    end if
l__l470
;  109 end procedure
;  111 procedure print_dword_binary(volatile byte out device, dword in data) is
l_print_dword_binary
;  113    if (print_prefix) then
                               btfss    v__bitbucket, 0 ; print_prefix  ;  1 OV rs rs [?? ??] 021e 1c37
                                                            ; W = v___data_43
                               goto     l__l475             ;  1 OV rs rs [?? ??] 021f 2a2d
                                                            ; W = v___data_43
;  114       device = "0"
                               movlw    48                  ;  1 OV rs rs [?? ??] 0220 3030
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0221 00a0
                               movf     v____device_put_20,w;  1 OV rs rs [?? ??] 0222 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0223 00b2
                                                            ; W = v____device_put_20
                               movf     v____device_put_20+1,w;  1 OV rs rs [?? ??] 0224 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0225 2155
                                                            ; W = v____device_put_20
;  115       device = "b"
                               movlw    98                  ;  1 OV ?? ?? [?? ??] 0226 3062
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0227 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0228 00a0
                               movf     v____device_put_20,w;  1 OV rs rs [?? ??] 0229 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 022a 00b2
                                                            ; W = v____device_put_20
                               movf     v____device_put_20+1,w;  1 OV rs rs [?? ??] 022b 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 022c 2155
                                                            ; W = v____device_put_20
;  116    end if
l__l475
;  118    print_byte_binary(device, byte(data>>24))
                               datalo_clr v___data_43       ;  1 OV ?? ?s [?? ??] 022d 1283
                                                            ; W = v___data_43
                               movf     v___data_43+3,w     ;  1 OV rs rs [?? ??] 022e 084c
                                                            ; W = v___data_43
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 022f 00a0
                                                            ; W = v___data_43
                               clrf     v__pic_temp+1       ;  1 OV rs rs [?? ??] 0230 01a1
                                                            ; W = v__pic_temp
                               clrf     v__pic_temp+2       ;  1 OV rs rs [?? ??] 0231 01a2
                                                            ; W = v__pic_temp
                               clrf     v__pic_temp+3       ;  1 OV rs rs [?? ??] 0232 01a3
                                                            ; W = v__pic_temp
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 0233 0820
                                                            ; W = v__pic_temp
                               movwf    v____temp_57        ;  1 OV rs rs [?? ??] 0234 00d5
                                                            ; W = v__pic_temp
                               movf     v____device_put_20,w;  1 OV rs rs [?? ??] 0235 0847
                                                            ; W = v____temp_57
                               movwf    v____device_put_22  ;  1 OV rs rs [?? ??] 0236 00dd
                                                            ; W = v____device_put_20
                               movf     v____device_put_20+1,w;  1 OV rs rs [?? ??] 0237 0848
                                                            ; W = v____device_put_22
                               movwf    v____device_put_22+1;  1 OV rs rs [?? ??] 0238 00de
                                                            ; W = v____device_put_20
                               movf     v____temp_57,w      ;  1 OV rs rs [?? ??] 0239 0855
                                                            ; W = v____device_put_22
                               call     l_print_byte_binary ;  1 OV rs ?? [?? ??] 023a 2283
                                                            ; W = v____temp_57
;  119    print_byte_binary(device, byte(data>>16))
                               datalo_clr v___data_43       ;  1 OV ?? ?s [?? ??] 023b 1283
                               movf     v___data_43+2,w     ;  1 OV rs rs [?? ??] 023c 084b
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 023d 00a0
                                                            ; W = v___data_43
                               movf     v___data_43+3,w     ;  1 OV rs rs [?? ??] 023e 084c
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 023f 00a1
                                                            ; W = v___data_43
                               clrf     v__pic_temp+2       ;  1 OV rs rs [?? ??] 0240 01a2
                                                            ; W = v__pic_temp
                               clrf     v__pic_temp+3       ;  1 OV rs rs [?? ??] 0241 01a3
                                                            ; W = v__pic_temp
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 0242 0820
                                                            ; W = v__pic_temp
                               movwf    v____temp_57        ;  1 OV rs rs [?? ??] 0243 00d5
                                                            ; W = v__pic_temp
                               movf     v____device_put_20,w;  1 OV rs rs [?? ??] 0244 0847
                                                            ; W = v____temp_57
                               movwf    v____device_put_22  ;  1 OV rs rs [?? ??] 0245 00dd
                                                            ; W = v____device_put_20
                               movf     v____device_put_20+1,w;  1 OV rs rs [?? ??] 0246 0848
                                                            ; W = v____device_put_22
                               movwf    v____device_put_22+1;  1 OV rs rs [?? ??] 0247 00de
                                                            ; W = v____device_put_20
                               movf     v____temp_57,w      ;  1 OV rs rs [?? ??] 0248 0855
                                                            ; W = v____device_put_22
                               call     l_print_byte_binary ;  1 OV rs ?? [?? ??] 0249 2283
                                                            ; W = v____temp_57
;  120    print_byte_binary(device, byte(data>>8))
                               datalo_clr v___data_43       ;  1 OV ?? ?s [?? ??] 024a 1283
                               movf     v___data_43+1,w     ;  1 OV rs rs [?? ??] 024b 084a
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 024c 00a0
                                                            ; W = v___data_43
                               movf     v___data_43+2,w     ;  1 OV rs rs [?? ??] 024d 084b
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 024e 00a1
                                                            ; W = v___data_43
                               movf     v___data_43+3,w     ;  1 OV rs rs [?? ??] 024f 084c
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+2       ;  1 OV rs rs [?? ??] 0250 00a2
                                                            ; W = v___data_43
                               clrf     v__pic_temp+3       ;  1 OV rs rs [?? ??] 0251 01a3
                                                            ; W = v__pic_temp
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 0252 0820
                                                            ; W = v__pic_temp
                               movwf    v____temp_57        ;  1 OV rs rs [?? ??] 0253 00d5
                                                            ; W = v__pic_temp
                               movf     v____device_put_20,w;  1 OV rs rs [?? ??] 0254 0847
                                                            ; W = v____temp_57
                               movwf    v____device_put_22  ;  1 OV rs rs [?? ??] 0255 00dd
                                                            ; W = v____device_put_20
                               movf     v____device_put_20+1,w;  1 OV rs rs [?? ??] 0256 0848
                                                            ; W = v____device_put_22
                               movwf    v____device_put_22+1;  1 OV rs rs [?? ??] 0257 00de
                                                            ; W = v____device_put_20
                               movf     v____temp_57,w      ;  1 OV rs rs [?? ??] 0258 0855
                                                            ; W = v____device_put_22
                               call     l_print_byte_binary ;  1 OV rs ?? [?? ??] 0259 2283
                                                            ; W = v____temp_57
;  121    print_byte_binary(device, byte(data))
                               datalo_clr v____device_put_20;  1 OV ?? ?s [?? ??] 025a 1283
                               movf     v____device_put_20,w;  1 OV rs rs [?? ??] 025b 0847
                               movwf    v____device_put_22  ;  1 OV rs rs [?? ??] 025c 00dd
                                                            ; W = v____device_put_20
                               movf     v____device_put_20+1,w;  1 OV rs rs [?? ??] 025d 0848
                                                            ; W = v____device_put_22
                               movwf    v____device_put_22+1;  1 OV rs rs [?? ??] 025e 00de
                                                            ; W = v____device_put_20
                               movf     v___data_43,w       ;  1 OV rs rs [?? ??] 025f 0849
                                                            ; W = v____device_put_22
                               goto     l_print_byte_binary ;  1 OV rs rs [?? ??] 0260 2a83
                                                            ; W = v___data_43
;  123 end procedure
;  125 procedure print_word_binary(volatile byte out device, word in data) is
l_print_word_binary
;  127    if (print_prefix) then
                               btfss    v__bitbucket, 0 ; print_prefix  ;  1 OV rs rs [?? ??] 0261 1c37
                                                            ; W = v___data_45
                               goto     l__l479             ;  1 OV rs rs [?? ??] 0262 2a70
                                                            ; W = v___data_45
;  128       device = "0"
                               movlw    48                  ;  1 OV rs rs [?? ??] 0263 3030
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0264 00a0
                               movf     v____device_put_21,w;  1 OV rs rs [?? ??] 0265 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0266 00b2
                                                            ; W = v____device_put_21
                               movf     v____device_put_21+1,w;  1 OV rs rs [?? ??] 0267 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0268 2155
                                                            ; W = v____device_put_21
;  129       device = "b"
                               movlw    98                  ;  1 OV ?? ?? [?? ??] 0269 3062
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 026a 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 026b 00a0
                               movf     v____device_put_21,w;  1 OV rs rs [?? ??] 026c 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 026d 00b2
                                                            ; W = v____device_put_21
                               movf     v____device_put_21+1,w;  1 OV rs rs [?? ??] 026e 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 026f 2155
                                                            ; W = v____device_put_21
;  130    end if
l__l479
;  132    print_byte_binary(device, byte(data>>8))
                               datalo_clr v___data_45       ;  1 OV ?? ?s [?? ??] 0270 1283
                                                            ; W = v___data_45
                               movf     v___data_45+1,w     ;  1 OV rs rs [?? ??] 0271 084a
                                                            ; W = v___data_45
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0272 00a0
                                                            ; W = v___data_45
                               clrf     v__pic_temp+1       ;  1 OV rs rs [?? ??] 0273 01a1
                                                            ; W = v__pic_temp
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 0274 0820
                                                            ; W = v__pic_temp
                               movwf    v____temp_58        ;  1 OV rs rs [?? ??] 0275 00cf
                                                            ; W = v__pic_temp
                               movf     v____device_put_21,w;  1 OV rs rs [?? ??] 0276 0847
                                                            ; W = v____temp_58
                               movwf    v____device_put_22  ;  1 OV rs rs [?? ??] 0277 00dd
                                                            ; W = v____device_put_21
                               movf     v____device_put_21+1,w;  1 OV rs rs [?? ??] 0278 0848
                                                            ; W = v____device_put_22
                               movwf    v____device_put_22+1;  1 OV rs rs [?? ??] 0279 00de
                                                            ; W = v____device_put_21
                               movf     v____temp_58,w      ;  1 OV rs rs [?? ??] 027a 084f
                                                            ; W = v____device_put_22
                               call     l_print_byte_binary ;  1 OV rs ?? [?? ??] 027b 2283
                                                            ; W = v____temp_58
;  133    print_byte_binary(device, byte(data))
                               datalo_clr v____device_put_21;  1 OV ?? ?s [?? ??] 027c 1283
                               movf     v____device_put_21,w;  1 OV rs rs [?? ??] 027d 0847
                               movwf    v____device_put_22  ;  1 OV rs rs [?? ??] 027e 00dd
                                                            ; W = v____device_put_21
                               movf     v____device_put_21+1,w;  1 OV rs rs [?? ??] 027f 0848
                                                            ; W = v____device_put_22
                               movwf    v____device_put_22+1;  1 OV rs rs [?? ??] 0280 00de
                                                            ; W = v____device_put_21
                               movf     v___data_45,w       ;  1 OV rs rs [?? ??] 0281 0849
                                                            ; W = v____device_put_22
                               goto     l_print_byte_binary ;  1 OV rs rs [?? ??] 0282 2a83
                                                            ; W = v___data_45
;  135 end procedure
;  138 procedure print_byte_binary(volatile byte out device, byte in data) is
l_print_byte_binary
                               movwf    v___data_47         ;  2 OV rs rs [?? ??] 0283 00e3
;  140    if (print_prefix) then
                               btfss    v__bitbucket, 0 ; print_prefix  ;  2 OV rs rs [?? ??] 0284 1c37
                                                            ; W = v___data_47
                               goto     l__l481             ;  2 OV rs rs [?? ??] 0285 2a93
                                                            ; W = v___data_47
;  141       device = "0"
                               movlw    48                  ;  2 OV rs rs [?? ??] 0286 3030
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 0287 00a0
                               movf     v____device_put_22,w;  2 OV rs rs [?? ??] 0288 085d
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  2 OV rs rs [?? ??] 0289 00b2
                                                            ; W = v____device_put_22
                               movf     v____device_put_22+1,w;  2 OV rs rs [?? ??] 028a 085e
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  2 OV rs ?? [?? ??] 028b 2155
                                                            ; W = v____device_put_22
;  142       device = "b"
                               movlw    98                  ;  2 OV ?? ?? [?? ??] 028c 3062
                               datalo_clr v__pic_temp       ;  2 OV ?? ?s [?? ??] 028d 1283
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 028e 00a0
                               movf     v____device_put_22,w;  2 OV rs rs [?? ??] 028f 085d
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  2 OV rs rs [?? ??] 0290 00b2
                                                            ; W = v____device_put_22
                               movf     v____device_put_22+1,w;  2 OV rs rs [?? ??] 0291 085e
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  2 OV rs ?? [?? ??] 0292 2155
                                                            ; W = v____device_put_22
;  143    end if
l__l481
;  145    for 8 loop    
                               datalo_clr v__floop8         ;  2 OV ?? ?s [?? ??] 0293 1283
                                                            ; W = v___data_47
                               clrf     v__floop8           ;  2 OV rs rs [?? ??] 0294 01e5
                                                            ; W = v___data_47
l__l482
;  146       if ((data & 0x80) != 0) then
                               movlw    128                 ;  2 OV rs rs [?? ??] 0295 3080
                               andwf    v___data_47,w       ;  2 OV rs rs [?? ??] 0296 0563
                               movwf    v____temp_59        ;  2 OV rs rs [?? ??] 0297 00e6
                               movf     v____temp_59,w      ;  2 OV rs rs [?? ??] 0298 0866
                                                            ; W = v____temp_59
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0299 1903
                                                            ; W = v____temp_59
                               goto     l__l486             ;  2 OV rs rs [?? ??] 029a 2aa2
                                                            ; W = v____temp_59
;  147          device = "1"
                               movlw    49                  ;  2 OV rs rs [?? ??] 029b 3031
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 029c 00a0
                               movf     v____device_put_22,w;  2 OV rs rs [?? ??] 029d 085d
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  2 OV rs rs [?? ??] 029e 00b2
                                                            ; W = v____device_put_22
                               movf     v____device_put_22+1,w;  2 OV rs rs [?? ??] 029f 085e
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  2 OV rs ?? [?? ??] 02a0 2155
                                                            ; W = v____device_put_22
;  148       else
                               goto     l__l485             ;  2 OV ?? ?? [?? ??] 02a1 2aa8
l__l486
;  149          device = "0"
                               movlw    48                  ;  2 OV rs rs [?? ??] 02a2 3030
                                                            ; W = v____temp_59
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 02a3 00a0
                               movf     v____device_put_22,w;  2 OV rs rs [?? ??] 02a4 085d
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  2 OV rs rs [?? ??] 02a5 00b2
                                                            ; W = v____device_put_22
                               movf     v____device_put_22+1,w;  2 OV rs rs [?? ??] 02a6 085e
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  2 OV rs ?? [?? ??] 02a7 2155
                                                            ; W = v____device_put_22
;  150       end if
l__l485
;  151       data = data * 2
                               bcf      v__status, v__c     ;  2 OV ?? ?? [?? ??] 02a8 1003
                               datalo_clr v___data_47       ;  2 OV ?? ?s [?? ??] 02a9 1283
                               rlf      v___data_47,f       ;  2 OV rs rs [?? ??] 02aa 0de3
;  152    end loop
                               incf     v__floop8,f         ;  2 OV rs rs [?? ??] 02ab 0ae5
                               movlw    8                   ;  2 OV rs rs [?? ??] 02ac 3008
                               subwf    v__floop8,w         ;  2 OV rs rs [?? ??] 02ad 0265
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 02ae 1d03
                               goto     l__l482             ;  2 OV rs rs [?? ??] 02af 2a95
;  154 end procedure
                               return                       ;  2 OV rs rs [?? ??] 02b0 0008
;  172 procedure print_dword_hex(volatile byte out device, dword in data) is
l_print_dword_hex
;  174    if (print_prefix) then
                               btfss    v__bitbucket, 0 ; print_prefix  ;  1 OV rs rs [?? ??] 02b1 1c37
                                                            ; W = v___data_51
                               goto     l__l497             ;  1 OV rs rs [?? ??] 02b2 2ac0
                                                            ; W = v___data_51
;  175       device = "0"
                               movlw    48                  ;  1 OV rs rs [?? ??] 02b3 3030
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 02b4 00a0
                               movf     v____device_put_24,w;  1 OV rs rs [?? ??] 02b5 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 02b6 00b2
                                                            ; W = v____device_put_24
                               movf     v____device_put_24+1,w;  1 OV rs rs [?? ??] 02b7 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 02b8 2155
                                                            ; W = v____device_put_24
;  176       device = "x"
                               movlw    120                 ;  1 OV ?? ?? [?? ??] 02b9 3078
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 02ba 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 02bb 00a0
                               movf     v____device_put_24,w;  1 OV rs rs [?? ??] 02bc 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 02bd 00b2
                                                            ; W = v____device_put_24
                               movf     v____device_put_24+1,w;  1 OV rs rs [?? ??] 02be 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 02bf 2155
                                                            ; W = v____device_put_24
;  177    end if
l__l497
;  179    device = nibble2hex[0x0F & (data>>28)]
                               datalo_clr v___data_51       ;  1 OV ?? ?s [?? ??] 02c0 1283
                                                            ; W = v___data_51
                               swapf    v___data_51+3,w     ;  1 OV rs rs [?? ??] 02c1 0e4c
                                                            ; W = v___data_51
                               andlw    15                  ;  1 OV rs rs [?? ??] 02c2 390f
                               movwf    v____temp_61        ;  1 OV rs rs [?? ??] 02c3 00d5
                               clrf     v____temp_61+1      ;  1 OV rs rs [?? ??] 02c4 01d6
                                                            ; W = v____temp_61
                               clrf     v____temp_61+2      ;  1 OV rs rs [?? ??] 02c5 01d7
                                                            ; W = v____temp_61
                               clrf     v____temp_61+3      ;  1 OV rs rs [?? ??] 02c6 01d8
                                                            ; W = v____temp_61
                               movlw    15                  ;  1 OV rs rs [?? ??] 02c7 300f
                                                            ; W = v____temp_61
                               andwf    v____temp_61,w      ;  1 OV rs rs [?? ??] 02c8 0555
                               movwf    v____temp_61+4      ;  1 OV rs rs [?? ??] 02c9 00d9
                               clrf     v____temp_61+5      ;  1 OV rs rs [?? ??] 02ca 01da
                                                            ; W = v____temp_61
                               clrf     v____temp_61+6      ;  1 OV rs rs [?? ??] 02cb 01db
                                                            ; W = v____temp_61
                               clrf     v____temp_61+7      ;  1 OV rs rs [?? ??] 02cc 01dc
                                                            ; W = v____temp_61
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 02cd 3000
                                                            ; W = v____temp_61
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 02ce 008a
                               movf     v____temp_61+4,w    ;  1 OV rs rs [?? ??] 02cf 0859
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 02d0 20bd
                                                            ; W = v____temp_61
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 02d1 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 02d2 00a0
                               movf     v____device_put_24,w;  1 OV rs rs [?? ??] 02d3 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 02d4 00b2
                                                            ; W = v____device_put_24
                               movf     v____device_put_24+1,w;  1 OV rs rs [?? ??] 02d5 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 02d6 2155
                                                            ; W = v____device_put_24
;  180    device = nibble2hex[0x0F & (data>>24)]
                               datalo_clr v___data_51       ;  1 OV ?? ?s [?? ??] 02d7 1283
                               movf     v___data_51+3,w     ;  1 OV rs rs [?? ??] 02d8 084c
                               movwf    v____temp_61        ;  1 OV rs rs [?? ??] 02d9 00d5
                                                            ; W = v___data_51
                               clrf     v____temp_61+1      ;  1 OV rs rs [?? ??] 02da 01d6
                                                            ; W = v____temp_61
                               clrf     v____temp_61+2      ;  1 OV rs rs [?? ??] 02db 01d7
                                                            ; W = v____temp_61
                               clrf     v____temp_61+3      ;  1 OV rs rs [?? ??] 02dc 01d8
                                                            ; W = v____temp_61
                               movlw    15                  ;  1 OV rs rs [?? ??] 02dd 300f
                                                            ; W = v____temp_61
                               andwf    v____temp_61,w      ;  1 OV rs rs [?? ??] 02de 0555
                               movwf    v____temp_61+4      ;  1 OV rs rs [?? ??] 02df 00d9
                               clrf     v____temp_61+5      ;  1 OV rs rs [?? ??] 02e0 01da
                                                            ; W = v____temp_61
                               clrf     v____temp_61+6      ;  1 OV rs rs [?? ??] 02e1 01db
                                                            ; W = v____temp_61
                               clrf     v____temp_61+7      ;  1 OV rs rs [?? ??] 02e2 01dc
                                                            ; W = v____temp_61
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 02e3 3000
                                                            ; W = v____temp_61
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 02e4 008a
                               movf     v____temp_61+4,w    ;  1 OV rs rs [?? ??] 02e5 0859
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 02e6 20bd
                                                            ; W = v____temp_61
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 02e7 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 02e8 00a0
                               movf     v____device_put_24,w;  1 OV rs rs [?? ??] 02e9 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 02ea 00b2
                                                            ; W = v____device_put_24
                               movf     v____device_put_24+1,w;  1 OV rs rs [?? ??] 02eb 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 02ec 2155
                                                            ; W = v____device_put_24
;  181    device = nibble2hex[0x0F & (data>>20)]
                               datalo_clr v___data_51       ;  1 OV ?? ?s [?? ??] 02ed 1283
                               movf     v___data_51+2,w     ;  1 OV rs rs [?? ??] 02ee 084b
                               movwf    v____temp_61        ;  1 OV rs rs [?? ??] 02ef 00d5
                                                            ; W = v___data_51
                               movf     v___data_51+3,w     ;  1 OV rs rs [?? ??] 02f0 084c
                                                            ; W = v____temp_61
                               movwf    v____temp_61+1      ;  1 OV rs rs [?? ??] 02f1 00d6
                                                            ; W = v___data_51
                               clrf     v____temp_61+2      ;  1 OV rs rs [?? ??] 02f2 01d7
                                                            ; W = v____temp_61
                               clrf     v____temp_61+3      ;  1 OV rs rs [?? ??] 02f3 01d8
                                                            ; W = v____temp_61
                               movlw    4                   ;  1 OV rs rs [?? ??] 02f4 3004
                                                            ; W = v____temp_61
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 02f5 00a0
l__l569
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 02f6 1003
                               rrf      v____temp_61+1,f    ;  1 OV rs rs [?? ??] 02f7 0cd6
                               rrf      v____temp_61,f      ;  1 OV rs rs [?? ??] 02f8 0cd5
                               decfsz   v__pic_temp,f       ;  1 OV rs rs [?? ??] 02f9 0ba0
                               goto     l__l569             ;  1 OV rs rs [?? ??] 02fa 2af6
                               movlw    15                  ;  1 OV rs rs [?? ??] 02fb 300f
                               andwf    v____temp_61,w      ;  1 OV rs rs [?? ??] 02fc 0555
                               movwf    v____temp_61+4      ;  1 OV rs rs [?? ??] 02fd 00d9
                               clrf     v____temp_61+5      ;  1 OV rs rs [?? ??] 02fe 01da
                                                            ; W = v____temp_61
                               clrf     v____temp_61+6      ;  1 OV rs rs [?? ??] 02ff 01db
                                                            ; W = v____temp_61
                               clrf     v____temp_61+7      ;  1 OV rs rs [?? ??] 0300 01dc
                                                            ; W = v____temp_61
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 0301 3000
                                                            ; W = v____temp_61
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 0302 008a
                               movf     v____temp_61+4,w    ;  1 OV rs rs [?? ??] 0303 0859
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 0304 20bd
                                                            ; W = v____temp_61
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0305 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0306 00a0
                               movf     v____device_put_24,w;  1 OV rs rs [?? ??] 0307 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0308 00b2
                                                            ; W = v____device_put_24
                               movf     v____device_put_24+1,w;  1 OV rs rs [?? ??] 0309 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 030a 2155
                                                            ; W = v____device_put_24
;  182    device = nibble2hex[0x0F & (data>>16)]
                               datalo_clr v___data_51       ;  1 OV ?? ?s [?? ??] 030b 1283
                               movf     v___data_51+2,w     ;  1 OV rs rs [?? ??] 030c 084b
                               movwf    v____temp_61        ;  1 OV rs rs [?? ??] 030d 00d5
                                                            ; W = v___data_51
                               movf     v___data_51+3,w     ;  1 OV rs rs [?? ??] 030e 084c
                                                            ; W = v____temp_61
                               movwf    v____temp_61+1      ;  1 OV rs rs [?? ??] 030f 00d6
                                                            ; W = v___data_51
                               clrf     v____temp_61+2      ;  1 OV rs rs [?? ??] 0310 01d7
                                                            ; W = v____temp_61
                               clrf     v____temp_61+3      ;  1 OV rs rs [?? ??] 0311 01d8
                                                            ; W = v____temp_61
                               movlw    15                  ;  1 OV rs rs [?? ??] 0312 300f
                                                            ; W = v____temp_61
                               andwf    v____temp_61,w      ;  1 OV rs rs [?? ??] 0313 0555
                               movwf    v____temp_61+4      ;  1 OV rs rs [?? ??] 0314 00d9
                               clrf     v____temp_61+5      ;  1 OV rs rs [?? ??] 0315 01da
                                                            ; W = v____temp_61
                               clrf     v____temp_61+6      ;  1 OV rs rs [?? ??] 0316 01db
                                                            ; W = v____temp_61
                               clrf     v____temp_61+7      ;  1 OV rs rs [?? ??] 0317 01dc
                                                            ; W = v____temp_61
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 0318 3000
                                                            ; W = v____temp_61
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 0319 008a
                               movf     v____temp_61+4,w    ;  1 OV rs rs [?? ??] 031a 0859
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 031b 20bd
                                                            ; W = v____temp_61
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 031c 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 031d 00a0
                               movf     v____device_put_24,w;  1 OV rs rs [?? ??] 031e 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 031f 00b2
                                                            ; W = v____device_put_24
                               movf     v____device_put_24+1,w;  1 OV rs rs [?? ??] 0320 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0321 2155
                                                            ; W = v____device_put_24
;  183    device = nibble2hex[0x0F & (data>>12)]
                               datalo_clr v___data_51       ;  1 OV ?? ?s [?? ??] 0322 1283
                               movf     v___data_51+1,w     ;  1 OV rs rs [?? ??] 0323 084a
                               movwf    v____temp_61        ;  1 OV rs rs [?? ??] 0324 00d5
                                                            ; W = v___data_51
                               movf     v___data_51+2,w     ;  1 OV rs rs [?? ??] 0325 084b
                                                            ; W = v____temp_61
                               movwf    v____temp_61+1      ;  1 OV rs rs [?? ??] 0326 00d6
                                                            ; W = v___data_51
                               movf     v___data_51+3,w     ;  1 OV rs rs [?? ??] 0327 084c
                                                            ; W = v____temp_61
                               movwf    v____temp_61+2      ;  1 OV rs rs [?? ??] 0328 00d7
                                                            ; W = v___data_51
                               clrf     v____temp_61+3      ;  1 OV rs rs [?? ??] 0329 01d8
                                                            ; W = v____temp_61
                               movlw    4                   ;  1 OV rs rs [?? ??] 032a 3004
                                                            ; W = v____temp_61
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 032b 00a0
l__l570
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 032c 1003
                               rrf      v____temp_61+2,f    ;  1 OV rs rs [?? ??] 032d 0cd7
                               rrf      v____temp_61+1,f    ;  1 OV rs rs [?? ??] 032e 0cd6
                               rrf      v____temp_61,f      ;  1 OV rs rs [?? ??] 032f 0cd5
                               decfsz   v__pic_temp,f       ;  1 OV rs rs [?? ??] 0330 0ba0
                               goto     l__l570             ;  1 OV rs rs [?? ??] 0331 2b2c
                               movlw    15                  ;  1 OV rs rs [?? ??] 0332 300f
                               andwf    v____temp_61,w      ;  1 OV rs rs [?? ??] 0333 0555
                               movwf    v____temp_61+4      ;  1 OV rs rs [?? ??] 0334 00d9
                               clrf     v____temp_61+5      ;  1 OV rs rs [?? ??] 0335 01da
                                                            ; W = v____temp_61
                               clrf     v____temp_61+6      ;  1 OV rs rs [?? ??] 0336 01db
                                                            ; W = v____temp_61
                               clrf     v____temp_61+7      ;  1 OV rs rs [?? ??] 0337 01dc
                                                            ; W = v____temp_61
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 0338 3000
                                                            ; W = v____temp_61
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 0339 008a
                               movf     v____temp_61+4,w    ;  1 OV rs rs [?? ??] 033a 0859
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 033b 20bd
                                                            ; W = v____temp_61
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 033c 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 033d 00a0
                               movf     v____device_put_24,w;  1 OV rs rs [?? ??] 033e 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 033f 00b2
                                                            ; W = v____device_put_24
                               movf     v____device_put_24+1,w;  1 OV rs rs [?? ??] 0340 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0341 2155
                                                            ; W = v____device_put_24
;  184    device = nibble2hex[0x0F & (data>>8)]
                               datalo_clr v___data_51       ;  1 OV ?? ?s [?? ??] 0342 1283
                               movf     v___data_51+1,w     ;  1 OV rs rs [?? ??] 0343 084a
                               movwf    v____temp_61        ;  1 OV rs rs [?? ??] 0344 00d5
                                                            ; W = v___data_51
                               movf     v___data_51+2,w     ;  1 OV rs rs [?? ??] 0345 084b
                                                            ; W = v____temp_61
                               movwf    v____temp_61+1      ;  1 OV rs rs [?? ??] 0346 00d6
                                                            ; W = v___data_51
                               movf     v___data_51+3,w     ;  1 OV rs rs [?? ??] 0347 084c
                                                            ; W = v____temp_61
                               movwf    v____temp_61+2      ;  1 OV rs rs [?? ??] 0348 00d7
                                                            ; W = v___data_51
                               clrf     v____temp_61+3      ;  1 OV rs rs [?? ??] 0349 01d8
                                                            ; W = v____temp_61
                               movlw    15                  ;  1 OV rs rs [?? ??] 034a 300f
                                                            ; W = v____temp_61
                               andwf    v____temp_61,w      ;  1 OV rs rs [?? ??] 034b 0555
                               movwf    v____temp_61+4      ;  1 OV rs rs [?? ??] 034c 00d9
                               clrf     v____temp_61+5      ;  1 OV rs rs [?? ??] 034d 01da
                                                            ; W = v____temp_61
                               clrf     v____temp_61+6      ;  1 OV rs rs [?? ??] 034e 01db
                                                            ; W = v____temp_61
                               clrf     v____temp_61+7      ;  1 OV rs rs [?? ??] 034f 01dc
                                                            ; W = v____temp_61
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 0350 3000
                                                            ; W = v____temp_61
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 0351 008a
                               movf     v____temp_61+4,w    ;  1 OV rs rs [?? ??] 0352 0859
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 0353 20bd
                                                            ; W = v____temp_61
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0354 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0355 00a0
                               movf     v____device_put_24,w;  1 OV rs rs [?? ??] 0356 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0357 00b2
                                                            ; W = v____device_put_24
                               movf     v____device_put_24+1,w;  1 OV rs rs [?? ??] 0358 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0359 2155
                                                            ; W = v____device_put_24
;  185    device = nibble2hex[0x0F & (data>>4)]
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 035a 1003
                               datalo_clr v___data_51       ;  1 OV ?? ?s [?? ??] 035b 1283
                               rrf      v___data_51+3,w     ;  1 OV rs rs [?? ??] 035c 0c4c
                               movwf    v____temp_61+3      ;  1 OV rs rs [?? ??] 035d 00d8
                               rrf      v___data_51+2,w     ;  1 OV rs rs [?? ??] 035e 0c4b
                                                            ; W = v____temp_61
                               movwf    v____temp_61+2      ;  1 OV rs rs [?? ??] 035f 00d7
                               rrf      v___data_51+1,w     ;  1 OV rs rs [?? ??] 0360 0c4a
                                                            ; W = v____temp_61
                               movwf    v____temp_61+1      ;  1 OV rs rs [?? ??] 0361 00d6
                               rrf      v___data_51,w       ;  1 OV rs rs [?? ??] 0362 0c49
                                                            ; W = v____temp_61
                               movwf    v____temp_61        ;  1 OV rs rs [?? ??] 0363 00d5
                               movlw    3                   ;  1 OV rs rs [?? ??] 0364 3003
                                                            ; W = v____temp_61
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0365 00a0
l__l571
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 0366 1003
                               rrf      v____temp_61+3,f    ;  1 OV rs rs [?? ??] 0367 0cd8
                               rrf      v____temp_61+2,f    ;  1 OV rs rs [?? ??] 0368 0cd7
                               rrf      v____temp_61+1,f    ;  1 OV rs rs [?? ??] 0369 0cd6
                               rrf      v____temp_61,f      ;  1 OV rs rs [?? ??] 036a 0cd5
                               decfsz   v__pic_temp,f       ;  1 OV rs rs [?? ??] 036b 0ba0
                               goto     l__l571             ;  1 OV rs rs [?? ??] 036c 2b66
                               movlw    15                  ;  1 OV rs rs [?? ??] 036d 300f
                               andwf    v____temp_61,w      ;  1 OV rs rs [?? ??] 036e 0555
                               movwf    v____temp_61+4      ;  1 OV rs rs [?? ??] 036f 00d9
                               clrf     v____temp_61+5      ;  1 OV rs rs [?? ??] 0370 01da
                                                            ; W = v____temp_61
                               clrf     v____temp_61+6      ;  1 OV rs rs [?? ??] 0371 01db
                                                            ; W = v____temp_61
                               clrf     v____temp_61+7      ;  1 OV rs rs [?? ??] 0372 01dc
                                                            ; W = v____temp_61
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 0373 3000
                                                            ; W = v____temp_61
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 0374 008a
                               movf     v____temp_61+4,w    ;  1 OV rs rs [?? ??] 0375 0859
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 0376 20bd
                                                            ; W = v____temp_61
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0377 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0378 00a0
                               movf     v____device_put_24,w;  1 OV rs rs [?? ??] 0379 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 037a 00b2
                                                            ; W = v____device_put_24
                               movf     v____device_put_24+1,w;  1 OV rs rs [?? ??] 037b 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 037c 2155
                                                            ; W = v____device_put_24
;  186    device = nibble2hex[0x0F & (data)]
                               movlw    15                  ;  1 OV ?? ?? [?? ??] 037d 300f
                               datalo_clr v___data_51       ;  1 OV ?? ?s [?? ??] 037e 1283
                               andwf    v___data_51,w       ;  1 OV rs rs [?? ??] 037f 0549
                               movwf    v____temp_61        ;  1 OV rs rs [?? ??] 0380 00d5
                               clrf     v____temp_61+1      ;  1 OV rs rs [?? ??] 0381 01d6
                                                            ; W = v____temp_61
                               clrf     v____temp_61+2      ;  1 OV rs rs [?? ??] 0382 01d7
                                                            ; W = v____temp_61
                               clrf     v____temp_61+3      ;  1 OV rs rs [?? ??] 0383 01d8
                                                            ; W = v____temp_61
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 0384 3000
                                                            ; W = v____temp_61
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 0385 008a
                               movf     v____temp_61,w      ;  1 OV rs rs [?? ??] 0386 0855
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 0387 20bd
                                                            ; W = v____temp_61
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0388 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0389 00a0
                               movf     v____device_put_24,w;  1 OV rs rs [?? ??] 038a 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 038b 00b2
                                                            ; W = v____device_put_24
                               movf     v____device_put_24+1,w;  1 OV rs rs [?? ??] 038c 0848
                                                            ; W = v__pic_pointer
                               goto     l__pic_indirect     ;  1 OV rs rs [?? ??] 038d 2955
                                                            ; W = v____device_put_24
;  188 end procedure
;  209 procedure print_word_hex(volatile byte out device, word in data) is
l_print_word_hex
;  211    if (print_prefix) then
                               btfss    v__bitbucket, 0 ; print_prefix  ;  1 OV rs rs [?? ??] 038e 1c37
                                                            ; W = v___data_55
                               goto     l__l505             ;  1 OV rs rs [?? ??] 038f 2b9d
                                                            ; W = v___data_55
;  212       device = "0"
                               movlw    48                  ;  1 OV rs rs [?? ??] 0390 3030
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0391 00a0
                               movf     v____device_put_26,w;  1 OV rs rs [?? ??] 0392 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0393 00b2
                                                            ; W = v____device_put_26
                               movf     v____device_put_26+1,w;  1 OV rs rs [?? ??] 0394 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0395 2155
                                                            ; W = v____device_put_26
;  213       device = "x"
                               movlw    120                 ;  1 OV ?? ?? [?? ??] 0396 3078
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0397 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0398 00a0
                               movf     v____device_put_26,w;  1 OV rs rs [?? ??] 0399 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 039a 00b2
                                                            ; W = v____device_put_26
                               movf     v____device_put_26+1,w;  1 OV rs rs [?? ??] 039b 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 039c 2155
                                                            ; W = v____device_put_26
;  214    end if
l__l505
;  216    device = nibble2hex[0x0F & (data>>12)]
                               datalo_clr v___data_55       ;  1 OV ?? ?s [?? ??] 039d 1283
                                                            ; W = v___data_55
                               swapf    v___data_55+1,w     ;  1 OV rs rs [?? ??] 039e 0e4a
                                                            ; W = v___data_55
                               andlw    15                  ;  1 OV rs rs [?? ??] 039f 390f
                               movwf    v____temp_63        ;  1 OV rs rs [?? ??] 03a0 00cf
                               clrf     v____temp_63+1      ;  1 OV rs rs [?? ??] 03a1 01d0
                                                            ; W = v____temp_63
                               movlw    15                  ;  1 OV rs rs [?? ??] 03a2 300f
                                                            ; W = v____temp_63
                               andwf    v____temp_63,w      ;  1 OV rs rs [?? ??] 03a3 054f
                               movwf    v____temp_63+2      ;  1 OV rs rs [?? ??] 03a4 00d1
                               clrf     v____temp_63+3      ;  1 OV rs rs [?? ??] 03a5 01d2
                                                            ; W = v____temp_63
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 03a6 3000
                                                            ; W = v____temp_63
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 03a7 008a
                               movf     v____temp_63+2,w    ;  1 OV rs rs [?? ??] 03a8 0851
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 03a9 20bd
                                                            ; W = v____temp_63
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 03aa 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03ab 00a0
                               movf     v____device_put_26,w;  1 OV rs rs [?? ??] 03ac 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 03ad 00b2
                                                            ; W = v____device_put_26
                               movf     v____device_put_26+1,w;  1 OV rs rs [?? ??] 03ae 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 03af 2155
                                                            ; W = v____device_put_26
;  217    device = nibble2hex[0x0F & (data>>8)]
                               datalo_clr v___data_55       ;  1 OV ?? ?s [?? ??] 03b0 1283
                               movf     v___data_55+1,w     ;  1 OV rs rs [?? ??] 03b1 084a
                               movwf    v____temp_63        ;  1 OV rs rs [?? ??] 03b2 00cf
                                                            ; W = v___data_55
                               clrf     v____temp_63+1      ;  1 OV rs rs [?? ??] 03b3 01d0
                                                            ; W = v____temp_63
                               movlw    15                  ;  1 OV rs rs [?? ??] 03b4 300f
                                                            ; W = v____temp_63
                               andwf    v____temp_63,w      ;  1 OV rs rs [?? ??] 03b5 054f
                               movwf    v____temp_63+2      ;  1 OV rs rs [?? ??] 03b6 00d1
                               clrf     v____temp_63+3      ;  1 OV rs rs [?? ??] 03b7 01d2
                                                            ; W = v____temp_63
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 03b8 3000
                                                            ; W = v____temp_63
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 03b9 008a
                               movf     v____temp_63+2,w    ;  1 OV rs rs [?? ??] 03ba 0851
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 03bb 20bd
                                                            ; W = v____temp_63
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 03bc 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03bd 00a0
                               movf     v____device_put_26,w;  1 OV rs rs [?? ??] 03be 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 03bf 00b2
                                                            ; W = v____device_put_26
                               movf     v____device_put_26+1,w;  1 OV rs rs [?? ??] 03c0 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 03c1 2155
                                                            ; W = v____device_put_26
;  218    device = nibble2hex[0x0F & (data>>4)]
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 03c2 1003
                               datalo_clr v___data_55       ;  1 OV ?? ?s [?? ??] 03c3 1283
                               rrf      v___data_55+1,w     ;  1 OV rs rs [?? ??] 03c4 0c4a
                               movwf    v____temp_63+1      ;  1 OV rs rs [?? ??] 03c5 00d0
                               rrf      v___data_55,w       ;  1 OV rs rs [?? ??] 03c6 0c49
                                                            ; W = v____temp_63
                               movwf    v____temp_63        ;  1 OV rs rs [?? ??] 03c7 00cf
                               movlw    3                   ;  1 OV rs rs [?? ??] 03c8 3003
                                                            ; W = v____temp_63
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03c9 00a0
l__l572
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 03ca 1003
                               rrf      v____temp_63+1,f    ;  1 OV rs rs [?? ??] 03cb 0cd0
                               rrf      v____temp_63,f      ;  1 OV rs rs [?? ??] 03cc 0ccf
                               decfsz   v__pic_temp,f       ;  1 OV rs rs [?? ??] 03cd 0ba0
                               goto     l__l572             ;  1 OV rs rs [?? ??] 03ce 2bca
                               movlw    15                  ;  1 OV rs rs [?? ??] 03cf 300f
                               andwf    v____temp_63,w      ;  1 OV rs rs [?? ??] 03d0 054f
                               movwf    v____temp_63+2      ;  1 OV rs rs [?? ??] 03d1 00d1
                               clrf     v____temp_63+3      ;  1 OV rs rs [?? ??] 03d2 01d2
                                                            ; W = v____temp_63
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 03d3 3000
                                                            ; W = v____temp_63
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 03d4 008a
                               movf     v____temp_63+2,w    ;  1 OV rs rs [?? ??] 03d5 0851
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 03d6 20bd
                                                            ; W = v____temp_63
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 03d7 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03d8 00a0
                               movf     v____device_put_26,w;  1 OV rs rs [?? ??] 03d9 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 03da 00b2
                                                            ; W = v____device_put_26
                               movf     v____device_put_26+1,w;  1 OV rs rs [?? ??] 03db 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 03dc 2155
                                                            ; W = v____device_put_26
;  219    device = nibble2hex[0x0F & (data)]
                               movlw    15                  ;  1 OV ?? ?? [?? ??] 03dd 300f
                               datalo_clr v___data_55       ;  1 OV ?? ?s [?? ??] 03de 1283
                               andwf    v___data_55,w       ;  1 OV rs rs [?? ??] 03df 0549
                               movwf    v____temp_63        ;  1 OV rs rs [?? ??] 03e0 00cf
                               clrf     v____temp_63+1      ;  1 OV rs rs [?? ??] 03e1 01d0
                                                            ; W = v____temp_63
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 03e2 3000
                                                            ; W = v____temp_63
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 03e3 008a
                               movf     v____temp_63,w      ;  1 OV rs rs [?? ??] 03e4 084f
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 03e5 20bd
                                                            ; W = v____temp_63
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 03e6 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03e7 00a0
                               movf     v____device_put_26,w;  1 OV rs rs [?? ??] 03e8 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 03e9 00b2
                                                            ; W = v____device_put_26
                               movf     v____device_put_26+1,w;  1 OV rs rs [?? ??] 03ea 0848
                                                            ; W = v__pic_pointer
                               goto     l__pic_indirect     ;  1 OV rs rs [?? ??] 03eb 2955
                                                            ; W = v____device_put_26
;  221 end procedure
;  223 procedure print_byte_hex(volatile byte out device, byte in data) is             
l_print_byte_hex
                               movwf    v___data_57         ;  1 OV rs rs [?? ??] 03ec 00c9
;  225    if (print_prefix) then
                               btfss    v__bitbucket, 0 ; print_prefix  ;  1 OV rs rs [?? ??] 03ed 1c37
                                                            ; W = v___data_57
                               goto     l__l509             ;  1 OV rs rs [?? ??] 03ee 2bfc
                                                            ; W = v___data_57
;  226       device = "0"
                               movlw    48                  ;  1 OV rs rs [?? ??] 03ef 3030
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03f0 00a0
                               movf     v____device_put_27,w;  1 OV rs rs [?? ??] 03f1 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 03f2 00b2
                                                            ; W = v____device_put_27
                               movf     v____device_put_27+1,w;  1 OV rs rs [?? ??] 03f3 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 03f4 2155
                                                            ; W = v____device_put_27
;  227       device = "x"
                               movlw    120                 ;  1 OV ?? ?? [?? ??] 03f5 3078
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 03f6 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03f7 00a0
                               movf     v____device_put_27,w;  1 OV rs rs [?? ??] 03f8 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 03f9 00b2
                                                            ; W = v____device_put_27
                               movf     v____device_put_27+1,w;  1 OV rs rs [?? ??] 03fa 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 03fb 2155
                                                            ; W = v____device_put_27
;  228    end if
l__l509
;  230    device = nibble2hex[0x0F & (data>>4)]
                               datalo_clr v___data_57       ;  1 OV ?? ?s [?? ??] 03fc 1283
                                                            ; W = v___data_57
                               swapf    v___data_57,w       ;  1 OV rs rs [?? ??] 03fd 0e49
                                                            ; W = v___data_57
                               andlw    15                  ;  1 OV rs rs [?? ??] 03fe 390f
                               movwf    v____temp_64        ;  1 OV rs rs [?? ??] 03ff 00cd
                               movlw    15                  ;  1 OV rs rs [?? ??] 0400 300f
                                                            ; W = v____temp_64
                               andwf    v____temp_64,w      ;  1 OV rs rs [?? ??] 0401 054d
                               movwf    v____temp_64+1      ;  1 OV rs rs [?? ??] 0402 00ce
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 0403 3000
                                                            ; W = v____temp_64
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 0404 008a
                               movf     v____temp_64+1,w    ;  1 OV rs rs [?? ??] 0405 084e
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 0406 20bd
                                                            ; W = v____temp_64
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0407 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0408 00a0
                               movf     v____device_put_27,w;  1 OV rs rs [?? ??] 0409 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 040a 00b2
                                                            ; W = v____device_put_27
                               movf     v____device_put_27+1,w;  1 OV rs rs [?? ??] 040b 0848
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 040c 2155
                                                            ; W = v____device_put_27
;  231    device = nibble2hex[0x0F & (data)]
                               movlw    15                  ;  1 OV ?? ?? [?? ??] 040d 300f
                               datalo_clr v___data_57       ;  1 OV ?? ?s [?? ??] 040e 1283
                               andwf    v___data_57,w       ;  1 OV rs rs [?? ??] 040f 0549
                               movwf    v____temp_64        ;  1 OV rs rs [?? ??] 0410 00cd
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rs rs [?? ??] 0411 3000
                                                            ; W = v____temp_64
                               movwf    v__pclath           ;  1 OV rs rs [?? ??] 0412 008a
                               movf     v____temp_64,w      ;  1 OV rs rs [?? ??] 0413 084d
                               call     l__lookup_nibble2hex;  1 OV rs ?? [?? ??] 0414 20bd
                                                            ; W = v____temp_64
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0415 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0416 00a0
                               movf     v____device_put_27,w;  1 OV rs rs [?? ??] 0417 0847
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0418 00b2
                                                            ; W = v____device_put_27
                               movf     v____device_put_27+1,w;  1 OV rs rs [?? ??] 0419 0848
                                                            ; W = v__pic_pointer
                               goto     l__pic_indirect     ;  1 OV rs rs [?? ??] 041a 2955
                                                            ; W = v____device_put_27
;  233 end procedure
;  235 procedure print_sdword_dec(volatile byte out device, sdword in data) is
l_print_sdword_dec
;  237    _print_suniversal_dec(device, data, 1000000000, 10)
                               movf     v____device_put_28,w;  1 OV rs rs [?? ??] 041b 0847
                                                            ; W = v___data_59
                               movwf    v____device_put_35  ;  1 OV rs rs [?? ??] 041c 00d5
                                                            ; W = v____device_put_28
                               movf     v____device_put_28+1,w;  1 OV rs rs [?? ??] 041d 0848
                                                            ; W = v____device_put_35
                               movwf    v____device_put_35+1;  1 OV rs rs [?? ??] 041e 00d6
                                                            ; W = v____device_put_28
                               movf     v___data_59,w       ;  1 OV rs rs [?? ??] 041f 0849
                                                            ; W = v____device_put_35
                               movwf    v___data_73         ;  1 OV rs rs [?? ??] 0420 00df
                                                            ; W = v___data_59
                               movf     v___data_59+1,w     ;  1 OV rs rs [?? ??] 0421 084a
                                                            ; W = v___data_73
                               movwf    v___data_73+1       ;  1 OV rs rs [?? ??] 0422 00e0
                                                            ; W = v___data_59
                               movf     v___data_59+2,w     ;  1 OV rs rs [?? ??] 0423 084b
                                                            ; W = v___data_73
                               movwf    v___data_73+2       ;  1 OV rs rs [?? ??] 0424 00e1
                                                            ; W = v___data_59
                               movf     v___data_59+3,w     ;  1 OV rs rs [?? ??] 0425 084c
                                                            ; W = v___data_73
                               movwf    v___data_73+3       ;  1 OV rs rs [?? ??] 0426 00e2
                                                            ; W = v___data_59
                               clrf     v___digit_divisor_3 ;  1 OV rs rs [?? ??] 0427 01e7
                                                            ; W = v___data_73
                               movlw    202                 ;  1 OV rs rs [?? ??] 0428 30ca
                                                            ; W = v___data_73
                               movwf    v___digit_divisor_3+1;  1 OV rs rs [?? ??] 0429 00e8
                               movlw    154                 ;  1 OV rs rs [?? ??] 042a 309a
                                                            ; W = v___digit_divisor_3
                               movwf    v___digit_divisor_3+2;  1 OV rs rs [?? ??] 042b 00e9
                               movlw    59                  ;  1 OV rs rs [?? ??] 042c 303b
                                                            ; W = v___digit_divisor_3
                               movwf    v___digit_divisor_3+3;  1 OV rs rs [?? ??] 042d 00ea
                               movlw    10                  ;  1 OV rs rs [?? ??] 042e 300a
                                                            ; W = v___digit_divisor_3
                               goto     l__print_suniversal_dec;  1 OV rs rs [?? ??] 042f 2c9c
;  239 end procedure
;  241 procedure print_sword_dec(volatile byte out device, sword in data) is
l_print_sword_dec
;  243    _print_suniversal_dec(device, data, 10000, 5)
                               movf     v____device_put_29,w;  1 OV rs rs [?? ??] 0430 0847
                                                            ; W = v___data_61
                               movwf    v____device_put_35  ;  1 OV rs rs [?? ??] 0431 00d5
                                                            ; W = v____device_put_29
                               movf     v____device_put_29+1,w;  1 OV rs rs [?? ??] 0432 0848
                                                            ; W = v____device_put_35
                               movwf    v____device_put_35+1;  1 OV rs rs [?? ??] 0433 00d6
                                                            ; W = v____device_put_29
                               movf     v___data_61,w       ;  1 OV rs rs [?? ??] 0434 0849
                                                            ; W = v____device_put_35
                               movwf    v___data_73         ;  1 OV rs rs [?? ??] 0435 00df
                                                            ; W = v___data_61
                               movf     v___data_61+1,w     ;  1 OV rs rs [?? ??] 0436 084a
                                                            ; W = v___data_73
                               movwf    v___data_73+1       ;  1 OV rs rs [?? ??] 0437 00e0
                                                            ; W = v___data_61
                               movlw    0                   ;  1 OV rs rs [?? ??] 0438 3000
                                                            ; W = v___data_73
                               btfsc    v___data_73+1, 7    ;  1 OV rs rs [?? ??] 0439 1be0
                               movlw    255                 ;  1 OV rs rs [?? ??] 043a 30ff
                               movwf    v___data_73+2       ;  1 OV rs rs [?? ??] 043b 00e1
                               movwf    v___data_73+3       ;  1 OV rs rs [?? ??] 043c 00e2
                                                            ; W = v___data_73
                               movlw    16                  ;  1 OV rs rs [?? ??] 043d 3010
                                                            ; W = v___data_73
                               movwf    v___digit_divisor_3 ;  1 OV rs rs [?? ??] 043e 00e7
                               movlw    39                  ;  1 OV rs rs [?? ??] 043f 3027
                                                            ; W = v___digit_divisor_3
                               movwf    v___digit_divisor_3+1;  1 OV rs rs [?? ??] 0440 00e8
                               clrf     v___digit_divisor_3+2;  1 OV rs rs [?? ??] 0441 01e9
                                                            ; W = v___digit_divisor_3
                               clrf     v___digit_divisor_3+3;  1 OV rs rs [?? ??] 0442 01ea
                                                            ; W = v___digit_divisor_3
                               movlw    5                   ;  1 OV rs rs [?? ??] 0443 3005
                                                            ; W = v___digit_divisor_3
                               goto     l__print_suniversal_dec;  1 OV rs rs [?? ??] 0444 2c9c
;  245 end procedure
;  255 procedure print_sbyte_dec(volatile byte out device, sbyte in data) is
l_print_sbyte_dec
                               movwf    v___data_65         ;  1 OV rs rs [?? ??] 0445 00c9
                                                            ; W = v___b_2
;  257    _print_suniversal_dec(device, data, 100, 3)
                               movf     v____device_put_31,w;  1 OV rs rs [?? ??] 0446 0847
                                                            ; W = v___data_65
                               movwf    v____device_put_35  ;  1 OV rs rs [?? ??] 0447 00d5
                                                            ; W = v____device_put_31
                               movf     v____device_put_31+1,w;  1 OV rs rs [?? ??] 0448 0848
                                                            ; W = v____device_put_35
                               movwf    v____device_put_35+1;  1 OV rs rs [?? ??] 0449 00d6
                                                            ; W = v____device_put_31
                               movf     v___data_65,w       ;  1 OV rs rs [?? ??] 044a 0849
                                                            ; W = v____device_put_35
                               movwf    v___data_73         ;  1 OV rs rs [?? ??] 044b 00df
                                                            ; W = v___data_65
                               movlw    0                   ;  1 OV rs rs [?? ??] 044c 3000
                                                            ; W = v___data_73
                               btfsc    v___data_73, 7      ;  1 OV rs rs [?? ??] 044d 1bdf
                               movlw    255                 ;  1 OV rs rs [?? ??] 044e 30ff
                               movwf    v___data_73+1       ;  1 OV rs rs [?? ??] 044f 00e0
                               movwf    v___data_73+2       ;  1 OV rs rs [?? ??] 0450 00e1
                                                            ; W = v___data_73
                               movwf    v___data_73+3       ;  1 OV rs rs [?? ??] 0451 00e2
                                                            ; W = v___data_73
                               movlw    100                 ;  1 OV rs rs [?? ??] 0452 3064
                                                            ; W = v___data_73
                               movwf    v___digit_divisor_3 ;  1 OV rs rs [?? ??] 0453 00e7
                               clrf     v___digit_divisor_3+1;  1 OV rs rs [?? ??] 0454 01e8
                                                            ; W = v___digit_divisor_3
                               clrf     v___digit_divisor_3+2;  1 OV rs rs [?? ??] 0455 01e9
                                                            ; W = v___digit_divisor_3
                               clrf     v___digit_divisor_3+3;  1 OV rs rs [?? ??] 0456 01ea
                                                            ; W = v___digit_divisor_3
                               movlw    3                   ;  1 OV rs rs [?? ??] 0457 3003
                                                            ; W = v___digit_divisor_3
                               goto     l__print_suniversal_dec;  1 OV rs rs [?? ??] 0458 2c9c
;  259 end procedure
;  261 procedure print_dword_dec(volatile byte out device, dword in data) is
l_print_dword_dec
;  263    _print_universal_dec(device, data, 1000000000, 10)
                               movf     v____device_put_32,w;  1 OV rs rs [?? ??] 0459 0847
                                                            ; W = v___data_67
                               movwf    v____device_put_36  ;  1 OV rs rs [?? ??] 045a 00ec
                                                            ; W = v____device_put_32
                               movf     v____device_put_32+1,w;  1 OV rs rs [?? ??] 045b 0848
                                                            ; W = v____device_put_36
                               movwf    v____device_put_36+1;  1 OV rs rs [?? ??] 045c 00ed
                                                            ; W = v____device_put_32
                               movf     v___data_67,w       ;  1 OV rs rs [?? ??] 045d 0849
                                                            ; W = v____device_put_36
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 045e 1683
                                                            ; W = v___data_67
                               movwf    v___data_75         ;  1 OV rS rS [?? ??] 045f 00a0
                                                            ; W = v___data_67
                               datalo_clr v___data_67       ;  1 OV rS rs [?? ??] 0460 1283
                                                            ; W = v___data_75
                               movf     v___data_67+1,w     ;  1 OV rs rs [?? ??] 0461 084a
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 0462 1683
                                                            ; W = v___data_67
                               movwf    v___data_75+1       ;  1 OV rS rS [?? ??] 0463 00a1
                                                            ; W = v___data_67
                               datalo_clr v___data_67       ;  1 OV rS rs [?? ??] 0464 1283
                                                            ; W = v___data_75
                               movf     v___data_67+2,w     ;  1 OV rs rs [?? ??] 0465 084b
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 0466 1683
                                                            ; W = v___data_67
                               movwf    v___data_75+2       ;  1 OV rS rS [?? ??] 0467 00a2
                                                            ; W = v___data_67
                               datalo_clr v___data_67       ;  1 OV rS rs [?? ??] 0468 1283
                                                            ; W = v___data_75
                               movf     v___data_67+3,w     ;  1 OV rs rs [?? ??] 0469 084c
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 046a 1683
                                                            ; W = v___data_67
                               movwf    v___data_75+3       ;  1 OV rS rS [?? ??] 046b 00a3
                                                            ; W = v___data_67
                               clrf     v___digit_divisor_5 ;  1 OV rS rS [?? ??] 046c 01a4
                                                            ; W = v___data_75
                               movlw    202                 ;  1 OV rS rS [?? ??] 046d 30ca
                                                            ; W = v___data_75
                               movwf    v___digit_divisor_5+1;  1 OV rS rS [?? ??] 046e 00a5
                               movlw    154                 ;  1 OV rS rS [?? ??] 046f 309a
                                                            ; W = v___digit_divisor_5
                               movwf    v___digit_divisor_5+2;  1 OV rS rS [?? ??] 0470 00a6
                               movlw    59                  ;  1 OV rS rS [?? ??] 0471 303b
                                                            ; W = v___digit_divisor_5
                               movwf    v___digit_divisor_5+3;  1 OV rS rS [?? ??] 0472 00a7
                               movlw    10                  ;  1 OV rS rS [?? ??] 0473 300a
                                                            ; W = v___digit_divisor_5
                               goto     l__print_universal_dec;  1 OV rS rS [?? ??] 0474 2cea
;  265 end procedure
;  267 procedure print_word_dec(volatile byte out device, word in data) is
l_print_word_dec
;  269    _print_universal_dec(device, data, 10000, 5)
                               movf     v____device_put_33,w;  1 OV rs rs [?? ??] 0475 0847
                                                            ; W = v___data_69
                               movwf    v____device_put_36  ;  1 OV rs rs [?? ??] 0476 00ec
                                                            ; W = v____device_put_33
                               movf     v____device_put_33+1,w;  1 OV rs rs [?? ??] 0477 0848
                                                            ; W = v____device_put_36
                               movwf    v____device_put_36+1;  1 OV rs rs [?? ??] 0478 00ed
                                                            ; W = v____device_put_33
                               movf     v___data_69,w       ;  1 OV rs rs [?? ??] 0479 0849
                                                            ; W = v____device_put_36
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 047a 1683
                                                            ; W = v___data_69
                               movwf    v___data_75         ;  1 OV rS rS [?? ??] 047b 00a0
                                                            ; W = v___data_69
                               datalo_clr v___data_69       ;  1 OV rS rs [?? ??] 047c 1283
                                                            ; W = v___data_75
                               movf     v___data_69+1,w     ;  1 OV rs rs [?? ??] 047d 084a
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 047e 1683
                                                            ; W = v___data_69
                               movwf    v___data_75+1       ;  1 OV rS rS [?? ??] 047f 00a1
                                                            ; W = v___data_69
                               clrf     v___data_75+2       ;  1 OV rS rS [?? ??] 0480 01a2
                                                            ; W = v___data_75
                               clrf     v___data_75+3       ;  1 OV rS rS [?? ??] 0481 01a3
                                                            ; W = v___data_75
                               movlw    16                  ;  1 OV rS rS [?? ??] 0482 3010
                                                            ; W = v___data_75
                               movwf    v___digit_divisor_5 ;  1 OV rS rS [?? ??] 0483 00a4
                               movlw    39                  ;  1 OV rS rS [?? ??] 0484 3027
                                                            ; W = v___digit_divisor_5
                               movwf    v___digit_divisor_5+1;  1 OV rS rS [?? ??] 0485 00a5
                               clrf     v___digit_divisor_5+2;  1 OV rS rS [?? ??] 0486 01a6
                                                            ; W = v___digit_divisor_5
                               clrf     v___digit_divisor_5+3;  1 OV rS rS [?? ??] 0487 01a7
                                                            ; W = v___digit_divisor_5
                               movlw    5                   ;  1 OV rS rS [?? ??] 0488 3005
                                                            ; W = v___digit_divisor_5
                               goto     l__print_universal_dec;  1 OV rS rS [?? ??] 0489 2cea
;  271 end procedure
;  273 procedure print_byte_dec(volatile byte out device, byte in data) is
l_print_byte_dec
                               movwf    v___data_71         ;  1 OV rs rs [?? ??] 048a 00c9
;  275    _print_universal_dec(device, data, 100, 3)
                               movf     v____device_put_34,w;  1 OV rs rs [?? ??] 048b 0847
                                                            ; W = v___data_71
                               movwf    v____device_put_36  ;  1 OV rs rs [?? ??] 048c 00ec
                                                            ; W = v____device_put_34
                               movf     v____device_put_34+1,w;  1 OV rs rs [?? ??] 048d 0848
                                                            ; W = v____device_put_36
                               movwf    v____device_put_36+1;  1 OV rs rs [?? ??] 048e 00ed
                                                            ; W = v____device_put_34
                               movf     v___data_71,w       ;  1 OV rs rs [?? ??] 048f 0849
                                                            ; W = v____device_put_36
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 0490 1683
                                                            ; W = v___data_71
                               movwf    v___data_75         ;  1 OV rS rS [?? ??] 0491 00a0
                                                            ; W = v___data_71
                               clrf     v___data_75+1       ;  1 OV rS rS [?? ??] 0492 01a1
                                                            ; W = v___data_75
                               clrf     v___data_75+2       ;  1 OV rS rS [?? ??] 0493 01a2
                                                            ; W = v___data_75
                               clrf     v___data_75+3       ;  1 OV rS rS [?? ??] 0494 01a3
                                                            ; W = v___data_75
                               movlw    100                 ;  1 OV rS rS [?? ??] 0495 3064
                                                            ; W = v___data_75
                               movwf    v___digit_divisor_5 ;  1 OV rS rS [?? ??] 0496 00a4
                               clrf     v___digit_divisor_5+1;  1 OV rS rS [?? ??] 0497 01a5
                                                            ; W = v___digit_divisor_5
                               clrf     v___digit_divisor_5+2;  1 OV rS rS [?? ??] 0498 01a6
                                                            ; W = v___digit_divisor_5
                               clrf     v___digit_divisor_5+3;  1 OV rS rS [?? ??] 0499 01a7
                                                            ; W = v___digit_divisor_5
                               movlw    3                   ;  1 OV rS rS [?? ??] 049a 3003
                                                            ; W = v___digit_divisor_5
                               goto     l__print_universal_dec;  1 OV rS rS [?? ??] 049b 2cea
;  277 end procedure
;  282 procedure _print_suniversal_dec(volatile byte out device, sdword in data, sdword in digit_divisor, byte in digit_number) is
l__print_suniversal_dec
                               movwf    v___digit_number_3  ;  1 OV rs rs [?? ??] 049c 00eb
;  284    if (data < 0) then
                               movf     v___data_73+3,w     ;  1 OV rs rs [?? ??] 049d 0862
                                                            ; W = v___digit_number_3
                               xorlw    128                 ;  1 OV rs rs [?? ??] 049e 3a80
                                                            ; W = v___data_73
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 049f 00a0
                               movlw    128                 ;  1 OV rs rs [?? ??] 04a0 3080
                                                            ; W = v__pic_temp
                               subwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 04a1 0220
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 04a2 1d03
                               goto     l__l573             ;  1 OV rs rs [?? ??] 04a3 2cae
                               movlw    0                   ;  1 OV rs rs [?? ??] 04a4 3000
                               subwf    v___data_73+2,w     ;  1 OV rs rs [?? ??] 04a5 0261
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 04a6 1d03
                               goto     l__l573             ;  1 OV rs rs [?? ??] 04a7 2cae
                               movlw    0                   ;  1 OV rs rs [?? ??] 04a8 3000
                               subwf    v___data_73+1,w     ;  1 OV rs rs [?? ??] 04a9 0260
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 04aa 1d03
                               goto     l__l573             ;  1 OV rs rs [?? ??] 04ab 2cae
                               movlw    0                   ;  1 OV rs rs [?? ??] 04ac 3000
                               subwf    v___data_73,w       ;  1 OV rs rs [?? ??] 04ad 025f
l__l573
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 04ae 1903
                               goto     l__l525             ;  1 OV rs rs [?? ??] 04af 2cc3
                               btfsc    v__status, v__c     ;  1 OV rs rs [?? ??] 04b0 1803
                               goto     l__l525             ;  1 OV rs rs [?? ??] 04b1 2cc3
;  285       data = -data
                               comf     v___data_73,f       ;  1 OV rs rs [?? ??] 04b2 09df
                               comf     v___data_73+1,f     ;  1 OV rs rs [?? ??] 04b3 09e0
                               comf     v___data_73+2,f     ;  1 OV rs rs [?? ??] 04b4 09e1
                               comf     v___data_73+3,f     ;  1 OV rs rs [?? ??] 04b5 09e2
                               incf     v___data_73,f       ;  1 OV rs rs [?? ??] 04b6 0adf
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 04b7 1903
                               incf     v___data_73+1,f     ;  1 OV rs rs [?? ??] 04b8 0ae0
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 04b9 1903
                               incf     v___data_73+2,f     ;  1 OV rs rs [?? ??] 04ba 0ae1
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 04bb 1903
                               incf     v___data_73+3,f     ;  1 OV rs rs [?? ??] 04bc 0ae2
;  286       device = "-"      
                               movlw    45                  ;  1 OV rs rs [?? ??] 04bd 302d
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 04be 00a0
                               movf     v____device_put_35,w;  1 OV rs rs [?? ??] 04bf 0855
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 04c0 00b2
                                                            ; W = v____device_put_35
                               movf     v____device_put_35+1,w;  1 OV rs rs [?? ??] 04c1 0856
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 04c2 2155
                                                            ; W = v____device_put_35
;  287    end if
l__l525
;  289    _print_universal_dec(device, dword( data ), digit_divisor, digit_number)
                               datalo_clr v____device_put_35;  1 OV ?? ?s [?? ??] 04c3 1283
                               movf     v____device_put_35,w;  1 OV rs rs [?? ??] 04c4 0855
                               movwf    v____device_put_36  ;  1 OV rs rs [?? ??] 04c5 00ec
                                                            ; W = v____device_put_35
                               movf     v____device_put_35+1,w;  1 OV rs rs [?? ??] 04c6 0856
                                                            ; W = v____device_put_36
                               movwf    v____device_put_36+1;  1 OV rs rs [?? ??] 04c7 00ed
                                                            ; W = v____device_put_35
                               movf     v___data_73,w       ;  1 OV rs rs [?? ??] 04c8 085f
                                                            ; W = v____device_put_36
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 04c9 1683
                                                            ; W = v___data_73
                               movwf    v___data_75         ;  1 OV rS rS [?? ??] 04ca 00a0
                                                            ; W = v___data_73
                               datalo_clr v___data_73       ;  1 OV rS rs [?? ??] 04cb 1283
                                                            ; W = v___data_75
                               movf     v___data_73+1,w     ;  1 OV rs rs [?? ??] 04cc 0860
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 04cd 1683
                                                            ; W = v___data_73
                               movwf    v___data_75+1       ;  1 OV rS rS [?? ??] 04ce 00a1
                                                            ; W = v___data_73
                               datalo_clr v___data_73       ;  1 OV rS rs [?? ??] 04cf 1283
                                                            ; W = v___data_75
                               movf     v___data_73+2,w     ;  1 OV rs rs [?? ??] 04d0 0861
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 04d1 1683
                                                            ; W = v___data_73
                               movwf    v___data_75+2       ;  1 OV rS rS [?? ??] 04d2 00a2
                                                            ; W = v___data_73
                               datalo_clr v___data_73       ;  1 OV rS rs [?? ??] 04d3 1283
                                                            ; W = v___data_75
                               movf     v___data_73+3,w     ;  1 OV rs rs [?? ??] 04d4 0862
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 04d5 1683
                                                            ; W = v___data_73
                               movwf    v___data_75+3       ;  1 OV rS rS [?? ??] 04d6 00a3
                                                            ; W = v___data_73
                               datalo_clr v___digit_divisor_3;  1 OV rS rs [?? ??] 04d7 1283
                                                            ; W = v___data_75
                               movf     v___digit_divisor_3,w;  1 OV rs rs [?? ??] 04d8 0867
                                                            ; W = v___data_75
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 04d9 1683
                                                            ; W = v___digit_divisor_3
                               movwf    v___digit_divisor_5 ;  1 OV rS rS [?? ??] 04da 00a4
                                                            ; W = v___digit_divisor_3
                               datalo_clr v___digit_divisor_3;  1 OV rS rs [?? ??] 04db 1283
                                                            ; W = v___digit_divisor_5
                               movf     v___digit_divisor_3+1,w;  1 OV rs rs [?? ??] 04dc 0868
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 04dd 1683
                                                            ; W = v___digit_divisor_3
                               movwf    v___digit_divisor_5+1;  1 OV rS rS [?? ??] 04de 00a5
                                                            ; W = v___digit_divisor_3
                               datalo_clr v___digit_divisor_3;  1 OV rS rs [?? ??] 04df 1283
                                                            ; W = v___digit_divisor_5
                               movf     v___digit_divisor_3+2,w;  1 OV rs rs [?? ??] 04e0 0869
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 04e1 1683
                                                            ; W = v___digit_divisor_3
                               movwf    v___digit_divisor_5+2;  1 OV rS rS [?? ??] 04e2 00a6
                                                            ; W = v___digit_divisor_3
                               datalo_clr v___digit_divisor_3;  1 OV rS rs [?? ??] 04e3 1283
                                                            ; W = v___digit_divisor_5
                               movf     v___digit_divisor_3+3,w;  1 OV rs rs [?? ??] 04e4 086a
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 04e5 1683
                                                            ; W = v___digit_divisor_3
                               movwf    v___digit_divisor_5+3;  1 OV rS rS [?? ??] 04e6 00a7
                                                            ; W = v___digit_divisor_3
                               datalo_clr v___digit_number_3;  1 OV rS rs [?? ??] 04e7 1283
                                                            ; W = v___digit_divisor_5
                               movf     v___digit_number_3,w;  1 OV rs rs [?? ??] 04e8 086b
                                                            ; W = v___digit_divisor_5
                               goto     l__print_universal_dec;  1 OV rs rs [?? ??] 04e9 2cea
                                                            ; W = v___digit_number_3
;  291 end procedure
;  294 procedure _print_universal_dec(volatile byte out device, dword in data, sdword in digit_divisor, byte in digit_number) is
l__print_universal_dec
                               datalo_clr v___digit_number_5;  1 OV r? rs [?? ??] 04ea 1283
                               movwf    v___digit_number_5  ;  1 OV rs rs [?? ??] 04eb 00ee
;  298    if (data == 0) then
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 04ec 1683
                                                            ; W = v___digit_number_5
                               movf     v___data_75,w       ;  1 OV rS rS [?? ??] 04ed 0820
                                                            ; W = v___digit_number_5
                               iorwf    v___data_75+1,w     ;  1 OV rS rS [?? ??] 04ee 0421
                                                            ; W = v___data_75
                               iorwf    v___data_75+2,w     ;  1 OV rS rS [?? ??] 04ef 0422
                               iorwf    v___data_75+3,w     ;  1 OV rS rS [?? ??] 04f0 0423
                               btfss    v__status, v__z     ;  1 OV rS rS [?? ??] 04f1 1d03
                               goto     l__l527             ;  1 OV rS rS [?? ??] 04f2 2cfa
;  299       device = "0"      
                               movlw    48                  ;  1 OV rS rS [?? ??] 04f3 3030
                               datalo_clr v__pic_temp       ;  1 OV rS rs [?? ??] 04f4 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 04f5 00a0
                               movf     v____device_put_36,w;  1 OV rs rs [?? ??] 04f6 086c
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 04f7 00b2
                                                            ; W = v____device_put_36
                               movf     v____device_put_36+1,w;  1 OV rs rs [?? ??] 04f8 086d
                                                            ; W = v__pic_pointer
                               goto     l__pic_indirect     ;  1 OV rs rs [?? ??] 04f9 2955
                                                            ; W = v____device_put_36
;  300       return
;  301    end if
l__l527
;  303    no_digits_printed_yet = true
                               bsf      v____bitbucket_22, 0 ; no_digits_printed_yet;  1 OV rS rS [?? ??] 04fa 1429
;  304    while (digit_divisor > 0) loop
l__l528
                               datalo_set v___digit_divisor_5;  1 OV r? rS [?? ??] 04fb 1683
                                                            ; W = v___digit_8
                               movf     v___digit_divisor_5+3,w;  1 OV rS rS [?? ??] 04fc 0827
                                                            ; W = v___digit_8
                               xorlw    128                 ;  1 OV rS rS [?? ??] 04fd 3a80
                                                            ; W = v___digit_divisor_5
                               datalo_clr v__pic_temp       ;  1 OV rS rs [?? ??] 04fe 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 04ff 00a0
                               movlw    128                 ;  1 OV rs rs [?? ??] 0500 3080
                                                            ; W = v__pic_temp
                               subwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 0501 0220
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 0502 1d03
                               goto     l__l575             ;  1 OV rs rs [?? ??] 0503 2d0f
                               movlw    0                   ;  1 OV rs rs [?? ??] 0504 3000
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0505 1683
                               subwf    v___digit_divisor_5+2,w;  1 OV rS rS [?? ??] 0506 0226
                               btfss    v__status, v__z     ;  1 OV rS rS [?? ??] 0507 1d03
                               goto     l__l575             ;  1 OV rS rS [?? ??] 0508 2d0f
                               movlw    0                   ;  1 OV rS rS [?? ??] 0509 3000
                               subwf    v___digit_divisor_5+1,w;  1 OV rS rS [?? ??] 050a 0225
                               btfss    v__status, v__z     ;  1 OV rS rS [?? ??] 050b 1d03
                               goto     l__l575             ;  1 OV rS rS [?? ??] 050c 2d0f
                               movlw    0                   ;  1 OV rS rS [?? ??] 050d 3000
                               subwf    v___digit_divisor_5,w;  1 OV rS rS [?? ??] 050e 0224
l__l575
                               btfsc    v__status, v__z     ;  1 OV r? rS [?? ??] 050f 1903
                               goto     l__l529             ;  1 OV r? rS [?? ??] 0510 2d8d
                               btfss    v__status, v__c     ;  1 OV r? rS [?? ??] 0511 1c03
                               goto     l__l529             ;  1 OV r? rS [?? ??] 0512 2d8d
;  305       digit = byte ( data / digit_divisor )
                               datalo_set v___digit_divisor_5;  1 OV r? rS [?? ??] 0513 1683
                               movf     v___digit_divisor_5,w;  1 OV rS rS [?? ??] 0514 0824
                               datalo_clr v__pic_divisor    ;  1 OV rS rs [?? ??] 0515 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 0516 00a8
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0517 1683
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+1,w;  1 OV rS rS [?? ??] 0518 0825
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_divisor    ;  1 OV rS rs [?? ??] 0519 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+1    ;  1 OV rs rs [?? ??] 051a 00a9
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 051b 1683
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+2,w;  1 OV rS rS [?? ??] 051c 0826
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_divisor    ;  1 OV rS rs [?? ??] 051d 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+2    ;  1 OV rs rs [?? ??] 051e 00aa
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 051f 1683
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+3,w;  1 OV rS rS [?? ??] 0520 0827
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_divisor    ;  1 OV rS rs [?? ??] 0521 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+3    ;  1 OV rs rs [?? ??] 0522 00ab
                                                            ; W = v___digit_divisor_5
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 0523 1683
                                                            ; W = v__pic_divisor
                               movf     v___data_75,w       ;  1 OV rS rS [?? ??] 0524 0820
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 0525 1283
                                                            ; W = v___data_75
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 0526 00a0
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 0527 1683
                                                            ; W = v__pic_dividend
                               movf     v___data_75+1,w     ;  1 OV rS rS [?? ??] 0528 0821
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 0529 1283
                                                            ; W = v___data_75
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 052a 00a1
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 052b 1683
                                                            ; W = v__pic_dividend
                               movf     v___data_75+2,w     ;  1 OV rS rS [?? ??] 052c 0822
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 052d 1283
                                                            ; W = v___data_75
                               movwf    v__pic_dividend+2   ;  1 OV rs rs [?? ??] 052e 00a2
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 052f 1683
                                                            ; W = v__pic_dividend
                               movf     v___data_75+3,w     ;  1 OV rS rS [?? ??] 0530 0823
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 0531 1283
                                                            ; W = v___data_75
                               movwf    v__pic_dividend+3   ;  1 OV rs rs [?? ??] 0532 00a3
                                                            ; W = v___data_75
                               call     l__pic_divide       ;  1 OV rs ?? [?? ??] 0533 2103
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 0534 1283
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 0535 082c
                               movwf    v___digit_8         ;  1 OV rs rs [?? ??] 0536 00ef
                                                            ; W = v__pic_quotient
;  306       data = data % digit_divisor
                               movf     v__pic_remainder,w  ;  1 OV rs rs [?? ??] 0537 0824
                                                            ; W = v___digit_8
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 0538 1683
                                                            ; W = v__pic_remainder
                               movwf    v___data_75         ;  1 OV rS rS [?? ??] 0539 00a0
                                                            ; W = v__pic_remainder
                               datalo_clr v__pic_remainder  ;  1 OV rS rs [?? ??] 053a 1283
                                                            ; W = v___data_75
                               movf     v__pic_remainder+1,w;  1 OV rs rs [?? ??] 053b 0825
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 053c 1683
                                                            ; W = v__pic_remainder
                               movwf    v___data_75+1       ;  1 OV rS rS [?? ??] 053d 00a1
                                                            ; W = v__pic_remainder
                               datalo_clr v__pic_remainder  ;  1 OV rS rs [?? ??] 053e 1283
                                                            ; W = v___data_75
                               movf     v__pic_remainder+2,w;  1 OV rs rs [?? ??] 053f 0826
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 0540 1683
                                                            ; W = v__pic_remainder
                               movwf    v___data_75+2       ;  1 OV rS rS [?? ??] 0541 00a2
                                                            ; W = v__pic_remainder
                               datalo_clr v__pic_remainder  ;  1 OV rS rs [?? ??] 0542 1283
                                                            ; W = v___data_75
                               movf     v__pic_remainder+3,w;  1 OV rs rs [?? ??] 0543 0827
                                                            ; W = v___data_75
                               datalo_set v___data_75       ;  1 OV rs rS [?? ??] 0544 1683
                                                            ; W = v__pic_remainder
                               movwf    v___data_75+3       ;  1 OV rS rS [?? ??] 0545 00a3
                                                            ; W = v__pic_remainder
;  307       digit_divisor = digit_divisor / 10
                               movlw    10                  ;  1 OV rS rS [?? ??] 0546 300a
                                                            ; W = v___data_75
                               datalo_clr v__pic_divisor    ;  1 OV rS rs [?? ??] 0547 1283
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 0548 00a8
                               clrf     v__pic_divisor+1    ;  1 OV rs rs [?? ??] 0549 01a9
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+2    ;  1 OV rs rs [?? ??] 054a 01aa
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+3    ;  1 OV rs rs [?? ??] 054b 01ab
                                                            ; W = v__pic_divisor
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 054c 1683
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5,w;  1 OV rS rS [?? ??] 054d 0824
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 054e 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 054f 00a0
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0550 1683
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+1,w;  1 OV rS rS [?? ??] 0551 0825
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 0552 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 0553 00a1
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0554 1683
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+2,w;  1 OV rS rS [?? ??] 0555 0826
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 0556 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+2   ;  1 OV rs rs [?? ??] 0557 00a2
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0558 1683
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+3,w;  1 OV rS rS [?? ??] 0559 0827
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 055a 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+3   ;  1 OV rs rs [?? ??] 055b 00a3
                                                            ; W = v___digit_divisor_5
                               call     l__pic_sdivide      ;  1 OV rs ?? [?? ??] 055c 20e2
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 055d 1283
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 055e 082c
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 055f 1683
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5 ;  1 OV rS rS [?? ??] 0560 00a4
                                                            ; W = v__pic_quotient
                               datalo_clr v__pic_quotient   ;  1 OV rS rs [?? ??] 0561 1283
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+1,w ;  1 OV rs rs [?? ??] 0562 082d
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0563 1683
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+1;  1 OV rS rS [?? ??] 0564 00a5
                                                            ; W = v__pic_quotient
                               datalo_clr v__pic_quotient   ;  1 OV rS rs [?? ??] 0565 1283
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+2,w ;  1 OV rs rs [?? ??] 0566 082e
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0567 1683
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+2;  1 OV rS rS [?? ??] 0568 00a6
                                                            ; W = v__pic_quotient
                               datalo_clr v__pic_quotient   ;  1 OV rS rs [?? ??] 0569 1283
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+3,w ;  1 OV rs rs [?? ??] 056a 082f
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 056b 1683
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+3;  1 OV rS rS [?? ??] 056c 00a7
                                                            ; W = v__pic_quotient
;  309       if ((digit != 0) | (no_digits_printed_yet == false)) then
                               datalo_clr v___digit_8       ;  1 OV rS rs [?? ??] 056d 1283
                                                            ; W = v___digit_divisor_5
                               movf     v___digit_8,w       ;  1 OV rs rs [?? ??] 056e 086f
                                                            ; W = v___digit_divisor_5
                               datalo_set v____bitbucket_22 ; _btemp67;  1 OV rs rS [?? ??] 056f 1683
                                                            ; W = v___digit_8
                               bsf      v____bitbucket_22, 3 ; _btemp67;  1 OV rS rS [?? ??] 0570 15a9
                                                            ; W = v___digit_8
                               btfsc    v__status, v__z     ;  1 OV rS rS [?? ??] 0571 1903
                                                            ; W = v___digit_8
                               bcf      v____bitbucket_22, 3 ; _btemp67;  1 OV rS rS [?? ??] 0572 11a9
                                                            ; W = v___digit_8
                               bcf      v____bitbucket_22, 4 ; _btemp68;  1 OV rS rS [?? ??] 0573 1229
                                                            ; W = v___digit_8
                               btfss    v____bitbucket_22, 0 ; no_digits_printed_yet;  1 OV rS rS [?? ??] 0574 1c29
                                                            ; W = v___digit_8
                               bsf      v____bitbucket_22, 4 ; _btemp68;  1 OV rS rS [?? ??] 0575 1629
                                                            ; W = v___digit_8
                               bcf      v____bitbucket_22, 5 ; _btemp69;  1 OV rS rS [?? ??] 0576 12a9
                                                            ; W = v___digit_8
                               btfss    v____bitbucket_22, 3 ; _btemp67;  1 OV rS rS [?? ??] 0577 1da9
                                                            ; W = v___digit_8
                               btfsc    v____bitbucket_22, 4 ; _btemp68;  1 OV rS rS [?? ??] 0578 1a29
                                                            ; W = v___digit_8
                               bsf      v____bitbucket_22, 5 ; _btemp69;  1 OV rS rS [?? ??] 0579 16a9
                                                            ; W = v___digit_8
                               btfss    v____bitbucket_22, 5 ; _btemp69;  1 OV rS rS [?? ??] 057a 1ea9
                                                            ; W = v___digit_8
                               goto     l__l532             ;  1 OV rS rS [?? ??] 057b 2d8a
                                                            ; W = v___digit_8
;  310          device = digit | "0"
                               movlw    48                  ;  1 OV rS rS [?? ??] 057c 3030
                               datalo_clr v___digit_8       ;  1 OV rS rs [?? ??] 057d 1283
                               iorwf    v___digit_8,w       ;  1 OV rs rs [?? ??] 057e 046f
                               datalo_set v____temp_67      ;  1 OV rs rS [?? ??] 057f 1683
                               movwf    v____temp_67        ;  1 OV rS rS [?? ??] 0580 00a8
                               movf     v____temp_67,w      ;  1 OV rS rS [?? ??] 0581 0828
                                                            ; W = v____temp_67
                               datalo_clr v__pic_temp       ;  1 OV rS rs [?? ??] 0582 1283
                                                            ; W = v____temp_67
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0583 00a0
                                                            ; W = v____temp_67
                               movf     v____device_put_36,w;  1 OV rs rs [?? ??] 0584 086c
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0585 00b2
                                                            ; W = v____device_put_36
                               movf     v____device_put_36+1,w;  1 OV rs rs [?? ??] 0586 086d
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0587 2155
                                                            ; W = v____device_put_36
;  311          no_digits_printed_yet = false
                               datalo_set v____bitbucket_22 ; no_digits_printed_yet;  1 OV ?? ?S [?? ??] 0588 1683
                               bcf      v____bitbucket_22, 0 ; no_digits_printed_yet;  1 OV rS rS [?? ??] 0589 1029
;  312       end if
l__l532
;  313       digit_number = digit_number - 1
                               datalo_clr v___digit_number_5;  1 OV rS rs [?? ??] 058a 1283
                                                            ; W = v___digit_8
                               decf     v___digit_number_5,f;  1 OV rs rs [?? ??] 058b 03ee
                                                            ; W = v___digit_8
;  314    end loop
                               goto     l__l528             ;  1 OV rs rs [?? ??] 058c 2cfb
                                                            ; W = v___digit_8
l__l529
;  316 end procedure
l__l446
                               return                       ;  1 OV r? rS [?? ??] 058d 0008
l__l445
; outdir/16f877a_serial_print_err.jal
;   57 led_direction = output
                               datalo_set v_trisc ; pin_c2_direction        ;  0 OV rs rS [?? ??] 058e 1683
                               bcf      v_trisc, 2 ; pin_c2_direction       ;  0 OV rS rS [?? ??] 058f 1107
;   59 forever loop
l__l533
;   60    delay_100ms( 5 )
                               movlw    5                   ;  0 OV ?? ?? [?? ??] 0590 3005
                               datalo_clr v___n_5           ;  0 OV ?? ?s [?? ??] 0591 1283
                               movwf    v___n_5             ;  0 OV rs rs [?? ??] 0592 00c7
                               clrf     v___n_5+1           ;  0 OV rs rs [?? ??] 0593 01c8
                                                            ; W = v___n_5
                               call     l_delay_100ms       ;  0 OV rs ?? [?? ??] 0594 215b
                                                            ; W = v___n_5
;   61    LED = high
                               datalo_clr v__portc_shadow ; x116;  0 OV ?? ?s [?? ??] 0595 1283
                               bsf      v__portc_shadow, 2 ; x116;  0 OV rs rs [?? ??] 0596 1536
; c:\jallib\include\device/16f877a.jal
;  298    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  0 OV rs rs [?? ??] 0597 0836
                               movwf    v_portc             ;  0 OV rs rs [?? ??] 0598 0087
                                                            ; W = v__portc_shadow
; outdir/16f877a_serial_print_err.jal
;   61    LED = high
; c:\jallib\include\device/16f877a.jal
;  381    _PORTC_flush()
; outdir/16f877a_serial_print_err.jal
;   61    LED = high
;   62    delay_100ms( 5 )
                               movlw    5                   ;  0 OV rs rs [?? ??] 0599 3005
                               movwf    v___n_5             ;  0 OV rs rs [?? ??] 059a 00c7
                               clrf     v___n_5+1           ;  0 OV rs rs [?? ??] 059b 01c8
                                                            ; W = v___n_5
                               call     l_delay_100ms       ;  0 OV rs ?? [?? ??] 059c 215b
                                                            ; W = v___n_5
;   63    LED = low
                               datalo_clr v__portc_shadow ; x117;  0 OV ?? ?s [?? ??] 059d 1283
                               bcf      v__portc_shadow, 2 ; x117;  0 OV rs rs [?? ??] 059e 1136
; c:\jallib\include\device/16f877a.jal
;  298    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  0 OV rs rs [?? ??] 059f 0836
                               movwf    v_portc             ;  0 OV rs rs [?? ??] 05a0 0087
                                                            ; W = v__portc_shadow
; outdir/16f877a_serial_print_err.jal
;   63    LED = low
; c:\jallib\include\device/16f877a.jal
;  381    _PORTC_flush()
; outdir/16f877a_serial_print_err.jal
;   63    LED = low
;   66    serial_hw_data = "A" -- output an A to the serial port.
                               movlw    65                  ;  0 OV rs rs [?? ??] 05a1 3041
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 05a2 00a0
                               call     l__serial_hw_data_put;  0 OV rs ?? [?? ??] 05a3 2199
                                                            ; W = v__pic_temp
;   74    print_string(serial_hw_data, str1)                 -- output string
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 05a4 3099
                               datalo_clr v____device_put_16;  0 OV ?? ?s [?? ??] 05a5 1283
                               movwf    v____device_put_16  ;  0 OV rs rs [?? ??] 05a6 00cd
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 05a7 3001
                                                            ; W = v____device_put_16
                               movwf    v____device_put_16+1;  0 OV rs rs [?? ??] 05a8 00ce
                               movlw    26                  ;  0 OV rs rs [?? ??] 05a9 301a
                                                            ; W = v____device_put_16
                               movwf    v__str_count        ;  0 OV rs rs [?? ??] 05aa 00d3
                               clrf     v__str_count+1      ;  0 OV rs rs [?? ??] 05ab 01d4
                                                            ; W = v__str_count
                               movlw    l__data_str1_2      ;  0 OV rs rs [?? ??] 05ac 3044
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV rs rs [?? ??] 05ad 00dd
                               movlw    HIGH l__data_str1_2 ;  0 OV rs rs [?? ??] 05ae 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV rs rs [?? ??] 05af 3840
                               movwf    v___str_1+1         ;  0 OV rs rs [?? ??] 05b0 00de
                               call     l_print_string      ;  0 OV rs ?? [?? ??] 05b1 21af
                                                            ; W = v___str_1
;   80    var  byte a =  210
                               movlw    210                 ;  0 OV ?? ?? [?? ??] 05b2 30d2
                               datalo_clr v_a               ;  0 OV ?? ?s [?? ??] 05b3 1283
                               movwf    v_a                 ;  0 OV rs rs [?? ??] 05b4 00b8
;   81    var sbyte b = -109
                               movlw    147                 ;  0 OV rs rs [?? ??] 05b5 3093
                                                            ; W = v_a
                               movwf    v___b_2             ;  0 OV rs rs [?? ??] 05b6 00b9
;   83    print_byte_dec(serial_hw_data, a)   -- output in (unsigned) decimal format
                               movlw    l__serial_hw_data_put;  0 OV rs rs [?? ??] 05b7 3099
                                                            ; W = v___b_2
                               movwf    v____device_put_34  ;  0 OV rs rs [?? ??] 05b8 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 05b9 3001
                                                            ; W = v____device_put_34
                               movwf    v____device_put_34+1;  0 OV rs rs [?? ??] 05ba 00c8
                               movf     v_a,w               ;  0 OV rs rs [?? ??] 05bb 0838
                                                            ; W = v____device_put_34
                               call     l_print_byte_dec    ;  0 OV rs ?? [?? ??] 05bc 248a
                                                            ; W = v_a
;   84    print_crlf(serial_hw_data)          -- output Carriage Return and Linefeed (0x0D 0x0A), new line
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 05bd 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 05be 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 05bf 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 05c0 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 05c1 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 05c2 21a2
                                                            ; W = v____device_put_15
;   85    print_byte_hex(serial_hw_data, a)   -- output in hex format
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 05c3 3099
                               datalo_clr v____device_put_27;  0 OV ?? ?s [?? ??] 05c4 1283
                               movwf    v____device_put_27  ;  0 OV rs rs [?? ??] 05c5 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 05c6 3001
                                                            ; W = v____device_put_27
                               movwf    v____device_put_27+1;  0 OV rs rs [?? ??] 05c7 00c8
                               movf     v_a,w               ;  0 OV rs rs [?? ??] 05c8 0838
                                                            ; W = v____device_put_27
                               call     l_print_byte_hex    ;  0 OV rs ?? [?? ??] 05c9 23ec
                                                            ; W = v_a
;   86    print_crlf(serial_hw_data)        
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 05ca 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 05cb 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 05cc 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 05cd 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 05ce 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 05cf 21a2
                                                            ; W = v____device_put_15
;   87    print_byte_binary(serial_hw_data, a)   -- output in binary format
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 05d0 3099
                               datalo_clr v____device_put_22;  0 OV ?? ?s [?? ??] 05d1 1283
                               movwf    v____device_put_22  ;  0 OV rs rs [?? ??] 05d2 00dd
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 05d3 3001
                                                            ; W = v____device_put_22
                               movwf    v____device_put_22+1;  0 OV rs rs [?? ??] 05d4 00de
                               movf     v_a,w               ;  0 OV rs rs [?? ??] 05d5 0838
                                                            ; W = v____device_put_22
                               call     l_print_byte_binary ;  0 OV rs ?? [?? ??] 05d6 2283
                                                            ; W = v_a
;   88    print_crlf(serial_hw_data)        
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 05d7 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 05d8 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 05d9 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 05da 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 05db 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 05dc 21a2
                                                            ; W = v____device_put_15
;   90    print_sbyte_dec(serial_hw_data, b)   -- output in signed decimal format
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 05dd 3099
                               datalo_clr v____device_put_31;  0 OV ?? ?s [?? ??] 05de 1283
                               movwf    v____device_put_31  ;  0 OV rs rs [?? ??] 05df 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 05e0 3001
                                                            ; W = v____device_put_31
                               movwf    v____device_put_31+1;  0 OV rs rs [?? ??] 05e1 00c8
                               movf     v___b_2,w           ;  0 OV rs rs [?? ??] 05e2 0839
                                                            ; W = v____device_put_31
                               call     l_print_sbyte_dec   ;  0 OV rs ?? [?? ??] 05e3 2445
                                                            ; W = v___b_2
;   91    print_crlf(serial_hw_data)        
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 05e4 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 05e5 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 05e6 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 05e7 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 05e8 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 05e9 21a2
                                                            ; W = v____device_put_15
;   98    print_string(serial_hw_data, str2) 
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 05ea 3099
                               datalo_clr v____device_put_16;  0 OV ?? ?s [?? ??] 05eb 1283
                               movwf    v____device_put_16  ;  0 OV rs rs [?? ??] 05ec 00cd
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 05ed 3001
                                                            ; W = v____device_put_16
                               movwf    v____device_put_16+1;  0 OV rs rs [?? ??] 05ee 00ce
                               movlw    24                  ;  0 OV rs rs [?? ??] 05ef 3018
                                                            ; W = v____device_put_16
                               movwf    v__str_count        ;  0 OV rs rs [?? ??] 05f0 00d3
                               clrf     v__str_count+1      ;  0 OV rs rs [?? ??] 05f1 01d4
                                                            ; W = v__str_count
                               movlw    l__data_str2        ;  0 OV rs rs [?? ??] 05f2 3079
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV rs rs [?? ??] 05f3 00dd
                               movlw    HIGH l__data_str2   ;  0 OV rs rs [?? ??] 05f4 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV rs rs [?? ??] 05f5 3840
                               movwf    v___str_1+1         ;  0 OV rs rs [?? ??] 05f6 00de
                               call     l_print_string      ;  0 OV rs ?? [?? ??] 05f7 21af
                                                            ; W = v___str_1
;  100    var  word c =  45678
                               movlw    110                 ;  0 OV ?? ?? [?? ??] 05f8 306e
                               datalo_clr v_c               ;  0 OV ?? ?s [?? ??] 05f9 1283
                               movwf    v_c                 ;  0 OV rs rs [?? ??] 05fa 00ba
                               movlw    178                 ;  0 OV rs rs [?? ??] 05fb 30b2
                                                            ; W = v_c
                               movwf    v_c+1               ;  0 OV rs rs [?? ??] 05fc 00bb
;  101    var sword d = -32109
                               movlw    147                 ;  0 OV rs rs [?? ??] 05fd 3093
                                                            ; W = v_c
                               movwf    v_d                 ;  0 OV rs rs [?? ??] 05fe 00bc
                               movlw    130                 ;  0 OV rs rs [?? ??] 05ff 3082
                                                            ; W = v_d
                               movwf    v_d+1               ;  0 OV rs rs [?? ??] 0600 00bd
;  103    print_word_dec(serial_hw_data, c)   -- output in (unsigned) decimal format
                               movlw    l__serial_hw_data_put;  0 OV rs rs [?? ??] 0601 3099
                                                            ; W = v_d
                               movwf    v____device_put_33  ;  0 OV rs rs [?? ??] 0602 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0603 3001
                                                            ; W = v____device_put_33
                               movwf    v____device_put_33+1;  0 OV rs rs [?? ??] 0604 00c8
                               movf     v_c,w               ;  0 OV rs rs [?? ??] 0605 083a
                                                            ; W = v____device_put_33
                               movwf    v___data_69         ;  0 OV rs rs [?? ??] 0606 00c9
                                                            ; W = v_c
                               movf     v_c+1,w             ;  0 OV rs rs [?? ??] 0607 083b
                                                            ; W = v___data_69
                               movwf    v___data_69+1       ;  0 OV rs rs [?? ??] 0608 00ca
                                                            ; W = v_c
                               call     l_print_word_dec    ;  0 OV rs ?? [?? ??] 0609 2475
                                                            ; W = v___data_69
;  104    print_crlf(serial_hw_data)          -- output Carriage Return and Linefeed (0x0D 0x0A), new line
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 060a 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 060b 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 060c 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 060d 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 060e 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 060f 21a2
                                                            ; W = v____device_put_15
;  105    print_word_hex(serial_hw_data, c)   -- output in hex format
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0610 3099
                               datalo_clr v____device_put_26;  0 OV ?? ?s [?? ??] 0611 1283
                               movwf    v____device_put_26  ;  0 OV rs rs [?? ??] 0612 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0613 3001
                                                            ; W = v____device_put_26
                               movwf    v____device_put_26+1;  0 OV rs rs [?? ??] 0614 00c8
                               movf     v_c,w               ;  0 OV rs rs [?? ??] 0615 083a
                                                            ; W = v____device_put_26
                               movwf    v___data_55         ;  0 OV rs rs [?? ??] 0616 00c9
                                                            ; W = v_c
                               movf     v_c+1,w             ;  0 OV rs rs [?? ??] 0617 083b
                                                            ; W = v___data_55
                               movwf    v___data_55+1       ;  0 OV rs rs [?? ??] 0618 00ca
                                                            ; W = v_c
                               call     l_print_word_hex    ;  0 OV rs ?? [?? ??] 0619 238e
                                                            ; W = v___data_55
;  106    print_crlf(serial_hw_data)       
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 061a 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 061b 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 061c 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 061d 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 061e 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 061f 21a2
                                                            ; W = v____device_put_15
;  107    print_word_binary(serial_hw_data, c)   -- output in binary format
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0620 3099
                               datalo_clr v____device_put_21;  0 OV ?? ?s [?? ??] 0621 1283
                               movwf    v____device_put_21  ;  0 OV rs rs [?? ??] 0622 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0623 3001
                                                            ; W = v____device_put_21
                               movwf    v____device_put_21+1;  0 OV rs rs [?? ??] 0624 00c8
                               movf     v_c,w               ;  0 OV rs rs [?? ??] 0625 083a
                                                            ; W = v____device_put_21
                               movwf    v___data_45         ;  0 OV rs rs [?? ??] 0626 00c9
                                                            ; W = v_c
                               movf     v_c+1,w             ;  0 OV rs rs [?? ??] 0627 083b
                                                            ; W = v___data_45
                               movwf    v___data_45+1       ;  0 OV rs rs [?? ??] 0628 00ca
                                                            ; W = v_c
                               call     l_print_word_binary ;  0 OV rs ?? [?? ??] 0629 2261
                                                            ; W = v___data_45
;  108    print_crlf(serial_hw_data)       
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 062a 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 062b 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 062c 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 062d 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 062e 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 062f 21a2
                                                            ; W = v____device_put_15
;  110    print_sword_dec(serial_hw_data, d)   -- output in signed decimal format
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0630 3099
                               datalo_clr v____device_put_29;  0 OV ?? ?s [?? ??] 0631 1283
                               movwf    v____device_put_29  ;  0 OV rs rs [?? ??] 0632 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0633 3001
                                                            ; W = v____device_put_29
                               movwf    v____device_put_29+1;  0 OV rs rs [?? ??] 0634 00c8
                               movf     v_d,w               ;  0 OV rs rs [?? ??] 0635 083c
                                                            ; W = v____device_put_29
                               movwf    v___data_61         ;  0 OV rs rs [?? ??] 0636 00c9
                                                            ; W = v_d
                               movf     v_d+1,w             ;  0 OV rs rs [?? ??] 0637 083d
                                                            ; W = v___data_61
                               movwf    v___data_61+1       ;  0 OV rs rs [?? ??] 0638 00ca
                                                            ; W = v_d
                               call     l_print_sword_dec   ;  0 OV rs ?? [?? ??] 0639 2430
                                                            ; W = v___data_61
;  111    print_crlf(serial_hw_data)        
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 063a 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 063b 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 063c 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 063d 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 063e 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 063f 21a2
                                                            ; W = v____device_put_15
;  117    print_string(serial_hw_data, str3) 
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0640 3099
                               datalo_clr v____device_put_16;  0 OV ?? ?s [?? ??] 0641 1283
                               movwf    v____device_put_16  ;  0 OV rs rs [?? ??] 0642 00cd
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0643 3001
                                                            ; W = v____device_put_16
                               movwf    v____device_put_16+1;  0 OV rs rs [?? ??] 0644 00ce
                               movlw    25                  ;  0 OV rs rs [?? ??] 0645 3019
                                                            ; W = v____device_put_16
                               movwf    v__str_count        ;  0 OV rs rs [?? ??] 0646 00d3
                               clrf     v__str_count+1      ;  0 OV rs rs [?? ??] 0647 01d4
                                                            ; W = v__str_count
                               movlw    l__data_str3        ;  0 OV rs rs [?? ??] 0648 305f
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV rs rs [?? ??] 0649 00dd
                               movlw    HIGH l__data_str3   ;  0 OV rs rs [?? ??] 064a 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV rs rs [?? ??] 064b 3840
                               movwf    v___str_1+1         ;  0 OV rs rs [?? ??] 064c 00de
                               call     l_print_string      ;  0 OV rs ?? [?? ??] 064d 21af
                                                            ; W = v___str_1
;  119    var  dword e =  3210987654
                               movlw    134                 ;  0 OV ?? ?? [?? ??] 064e 3086
                               datalo_clr v_e               ;  0 OV ?? ?s [?? ??] 064f 1283
                               movwf    v_e                 ;  0 OV rs rs [?? ??] 0650 00be
                               movlw    200                 ;  0 OV rs rs [?? ??] 0651 30c8
                                                            ; W = v_e
                               movwf    v_e+1               ;  0 OV rs rs [?? ??] 0652 00bf
                               movlw    99                  ;  0 OV rs rs [?? ??] 0653 3063
                                                            ; W = v_e
                               movwf    v_e+2               ;  0 OV rs rs [?? ??] 0654 00c0
                               movlw    191                 ;  0 OV rs rs [?? ??] 0655 30bf
                                                            ; W = v_e
                               movwf    v_e+3               ;  0 OV rs rs [?? ??] 0656 00c1
;  120    var sdword f = -2109876543
                               movlw    193                 ;  0 OV rs rs [?? ??] 0657 30c1
                                                            ; W = v_e
                               movwf    v___f_1             ;  0 OV rs rs [?? ??] 0658 00c2
                               movlw    214                 ;  0 OV rs rs [?? ??] 0659 30d6
                                                            ; W = v___f_1
                               movwf    v___f_1+1           ;  0 OV rs rs [?? ??] 065a 00c3
                               movlw    61                  ;  0 OV rs rs [?? ??] 065b 303d
                                                            ; W = v___f_1
                               movwf    v___f_1+2           ;  0 OV rs rs [?? ??] 065c 00c4
                               movlw    130                 ;  0 OV rs rs [?? ??] 065d 3082
                                                            ; W = v___f_1
                               movwf    v___f_1+3           ;  0 OV rs rs [?? ??] 065e 00c5
;  122    print_dword_dec(serial_hw_data, e)   -- output in (unsigned) decimal format
                               movlw    l__serial_hw_data_put;  0 OV rs rs [?? ??] 065f 3099
                                                            ; W = v___f_1
                               movwf    v____device_put_32  ;  0 OV rs rs [?? ??] 0660 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0661 3001
                                                            ; W = v____device_put_32
                               movwf    v____device_put_32+1;  0 OV rs rs [?? ??] 0662 00c8
                               movf     v_e,w               ;  0 OV rs rs [?? ??] 0663 083e
                                                            ; W = v____device_put_32
                               movwf    v___data_67         ;  0 OV rs rs [?? ??] 0664 00c9
                                                            ; W = v_e
                               movf     v_e+1,w             ;  0 OV rs rs [?? ??] 0665 083f
                                                            ; W = v___data_67
                               movwf    v___data_67+1       ;  0 OV rs rs [?? ??] 0666 00ca
                                                            ; W = v_e
                               movf     v_e+2,w             ;  0 OV rs rs [?? ??] 0667 0840
                                                            ; W = v___data_67
                               movwf    v___data_67+2       ;  0 OV rs rs [?? ??] 0668 00cb
                                                            ; W = v_e
                               movf     v_e+3,w             ;  0 OV rs rs [?? ??] 0669 0841
                                                            ; W = v___data_67
                               movwf    v___data_67+3       ;  0 OV rs rs [?? ??] 066a 00cc
                                                            ; W = v_e
                               call     l_print_dword_dec   ;  0 OV rs ?? [?? ??] 066b 2459
                                                            ; W = v___data_67
;  123    print_crlf(serial_hw_data)          -- output Carriage Return and Linefeed (0x0D 0x0A), new line
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 066c 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 066d 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 066e 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 066f 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 0670 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 0671 21a2
                                                            ; W = v____device_put_15
;  124    print_dword_hex(serial_hw_data, e)   -- output in hex format
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0672 3099
                               datalo_clr v____device_put_24;  0 OV ?? ?s [?? ??] 0673 1283
                               movwf    v____device_put_24  ;  0 OV rs rs [?? ??] 0674 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0675 3001
                                                            ; W = v____device_put_24
                               movwf    v____device_put_24+1;  0 OV rs rs [?? ??] 0676 00c8
                               movf     v_e,w               ;  0 OV rs rs [?? ??] 0677 083e
                                                            ; W = v____device_put_24
                               movwf    v___data_51         ;  0 OV rs rs [?? ??] 0678 00c9
                                                            ; W = v_e
                               movf     v_e+1,w             ;  0 OV rs rs [?? ??] 0679 083f
                                                            ; W = v___data_51
                               movwf    v___data_51+1       ;  0 OV rs rs [?? ??] 067a 00ca
                                                            ; W = v_e
                               movf     v_e+2,w             ;  0 OV rs rs [?? ??] 067b 0840
                                                            ; W = v___data_51
                               movwf    v___data_51+2       ;  0 OV rs rs [?? ??] 067c 00cb
                                                            ; W = v_e
                               movf     v_e+3,w             ;  0 OV rs rs [?? ??] 067d 0841
                                                            ; W = v___data_51
                               movwf    v___data_51+3       ;  0 OV rs rs [?? ??] 067e 00cc
                                                            ; W = v_e
                               call     l_print_dword_hex   ;  0 OV rs ?? [?? ??] 067f 22b1
                                                            ; W = v___data_51
;  125    print_crlf(serial_hw_data)        
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0680 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 0681 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 0682 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0683 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 0684 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 0685 21a2
                                                            ; W = v____device_put_15
;  126    print_dword_binary(serial_hw_data, e)   -- output in binary format
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0686 3099
                               datalo_clr v____device_put_20;  0 OV ?? ?s [?? ??] 0687 1283
                               movwf    v____device_put_20  ;  0 OV rs rs [?? ??] 0688 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0689 3001
                                                            ; W = v____device_put_20
                               movwf    v____device_put_20+1;  0 OV rs rs [?? ??] 068a 00c8
                               movf     v_e,w               ;  0 OV rs rs [?? ??] 068b 083e
                                                            ; W = v____device_put_20
                               movwf    v___data_43         ;  0 OV rs rs [?? ??] 068c 00c9
                                                            ; W = v_e
                               movf     v_e+1,w             ;  0 OV rs rs [?? ??] 068d 083f
                                                            ; W = v___data_43
                               movwf    v___data_43+1       ;  0 OV rs rs [?? ??] 068e 00ca
                                                            ; W = v_e
                               movf     v_e+2,w             ;  0 OV rs rs [?? ??] 068f 0840
                                                            ; W = v___data_43
                               movwf    v___data_43+2       ;  0 OV rs rs [?? ??] 0690 00cb
                                                            ; W = v_e
                               movf     v_e+3,w             ;  0 OV rs rs [?? ??] 0691 0841
                                                            ; W = v___data_43
                               movwf    v___data_43+3       ;  0 OV rs rs [?? ??] 0692 00cc
                                                            ; W = v_e
                               call     l_print_dword_binary;  0 OV rs ?? [?? ??] 0693 221e
                                                            ; W = v___data_43
;  127    print_crlf(serial_hw_data)        
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0694 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 0695 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 0696 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0697 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 0698 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 0699 21a2
                                                            ; W = v____device_put_15
;  129    print_sdword_dec(serial_hw_data, f)   -- output in signed decimal format
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 069a 3099
                               datalo_clr v____device_put_28;  0 OV ?? ?s [?? ??] 069b 1283
                               movwf    v____device_put_28  ;  0 OV rs rs [?? ??] 069c 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 069d 3001
                                                            ; W = v____device_put_28
                               movwf    v____device_put_28+1;  0 OV rs rs [?? ??] 069e 00c8
                               movf     v___f_1,w           ;  0 OV rs rs [?? ??] 069f 0842
                                                            ; W = v____device_put_28
                               movwf    v___data_59         ;  0 OV rs rs [?? ??] 06a0 00c9
                                                            ; W = v___f_1
                               movf     v___f_1+1,w         ;  0 OV rs rs [?? ??] 06a1 0843
                                                            ; W = v___data_59
                               movwf    v___data_59+1       ;  0 OV rs rs [?? ??] 06a2 00ca
                                                            ; W = v___f_1
                               movf     v___f_1+2,w         ;  0 OV rs rs [?? ??] 06a3 0844
                                                            ; W = v___data_59
                               movwf    v___data_59+2       ;  0 OV rs rs [?? ??] 06a4 00cb
                                                            ; W = v___f_1
                               movf     v___f_1+3,w         ;  0 OV rs rs [?? ??] 06a5 0845
                                                            ; W = v___data_59
                               movwf    v___data_59+3       ;  0 OV rs rs [?? ??] 06a6 00cc
                                                            ; W = v___f_1
                               call     l_print_sdword_dec  ;  0 OV rs ?? [?? ??] 06a7 241b
                                                            ; W = v___data_59
;  130    print_crlf(serial_hw_data)        
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 06a8 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 06a9 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 06aa 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 06ab 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 06ac 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 06ad 21a2
                                                            ; W = v____device_put_15
;  136    print_string(serial_hw_data, str4) 
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 06ae 3099
                               datalo_clr v____device_put_16;  0 OV ?? ?s [?? ??] 06af 1283
                               movwf    v____device_put_16  ;  0 OV rs rs [?? ??] 06b0 00cd
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 06b1 3001
                                                            ; W = v____device_put_16
                               movwf    v____device_put_16+1;  0 OV rs rs [?? ??] 06b2 00ce
                               movlw    22                  ;  0 OV rs rs [?? ??] 06b3 3016
                                                            ; W = v____device_put_16
                               movwf    v__str_count        ;  0 OV rs rs [?? ??] 06b4 00d3
                               clrf     v__str_count+1      ;  0 OV rs rs [?? ??] 06b5 01d4
                                                            ; W = v__str_count
                               movlw    l__data_str4        ;  0 OV rs rs [?? ??] 06b6 3092
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV rs rs [?? ??] 06b7 00dd
                               movlw    HIGH l__data_str4   ;  0 OV rs rs [?? ??] 06b8 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV rs rs [?? ??] 06b9 3840
                               movwf    v___str_1+1         ;  0 OV rs rs [?? ??] 06ba 00de
                               call     l_print_string      ;  0 OV rs ?? [?? ??] 06bb 21af
                                                            ; W = v___str_1
;  138    var bit g = 1
                               datalo_clr v__bitbucket ; g   ;  0 OV ?? ?s [?? ??] 06bc 1283
                               bsf      v__bitbucket, 1 ; g  ;  0 OV rs rs [?? ??] 06bd 14b7
;  140    print_bit_10(serial_hw_data, g)           -- output 0 or 1
                               movlw    l__serial_hw_data_put;  0 OV rs rs [?? ??] 06be 3099
                               movwf    v____device_put_19  ;  0 OV rs rs [?? ??] 06bf 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 06c0 3001
                                                            ; W = v____device_put_19
                               movwf    v____device_put_19+1;  0 OV rs rs [?? ??] 06c1 00c8
                               bcf      v____bitbucket_15, 0 ; data41;  0 OV rs rs [?? ??] 06c2 1049
                                                            ; W = v____device_put_19
                               btfsc    v__bitbucket, 1 ; g  ;  0 OV rs rs [?? ??] 06c3 18b7
                                                            ; W = v____device_put_19
                               bsf      v____bitbucket_15, 0 ; data41;  0 OV rs rs [?? ??] 06c4 1449
                                                            ; W = v____device_put_19
                               call     l_print_bit_10      ;  0 OV rs ?? [?? ??] 06c5 2210
                                                            ; W = v____device_put_19
;  141    serial_hw_data = " "                      -- output a space
                               movlw    32                  ;  0 OV ?? ?? [?? ??] 06c6 3020
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 06c7 1283
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 06c8 00a0
                               call     l__serial_hw_data_put;  0 OV rs ?? [?? ??] 06c9 2199
                                                            ; W = v__pic_temp
;  143    print_bit_highlow(serial_hw_data, g)      -- output text 'high' or 'low'
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 06ca 3099
                               datalo_clr v____device_put_18;  0 OV ?? ?s [?? ??] 06cb 1283
                               movwf    v____device_put_18  ;  0 OV rs rs [?? ??] 06cc 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 06cd 3001
                                                            ; W = v____device_put_18
                               movwf    v____device_put_18+1;  0 OV rs rs [?? ??] 06ce 00c8
                               bcf      v____bitbucket_16, 0 ; data39;  0 OV rs rs [?? ??] 06cf 1049
                                                            ; W = v____device_put_18
                               btfsc    v__bitbucket, 1 ; g  ;  0 OV rs rs [?? ??] 06d0 18b7
                                                            ; W = v____device_put_18
                               bsf      v____bitbucket_16, 0 ; data39;  0 OV rs rs [?? ??] 06d1 1449
                                                            ; W = v____device_put_18
                               call     l_print_bit_highlow ;  0 OV rs ?? [?? ??] 06d2 21f4
                                                            ; W = v____device_put_18
;  144    serial_hw_data = " "                      -- output a space
                               movlw    32                  ;  0 OV ?? ?? [?? ??] 06d3 3020
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 06d4 1283
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 06d5 00a0
                               call     l__serial_hw_data_put;  0 OV rs ?? [?? ??] 06d6 2199
                                                            ; W = v__pic_temp
;  146    print_bit_truefalse(serial_hw_data, g)    -- output text 'true' or 'false'
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 06d7 3099
                               datalo_clr v____device_put_17;  0 OV ?? ?s [?? ??] 06d8 1283
                               movwf    v____device_put_17  ;  0 OV rs rs [?? ??] 06d9 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 06da 3001
                                                            ; W = v____device_put_17
                               movwf    v____device_put_17+1;  0 OV rs rs [?? ??] 06db 00c8
                               bcf      v____bitbucket_17, 0 ; data37;  0 OV rs rs [?? ??] 06dc 1049
                                                            ; W = v____device_put_17
                               btfsc    v__bitbucket, 1 ; g  ;  0 OV rs rs [?? ??] 06dd 18b7
                                                            ; W = v____device_put_17
                               bsf      v____bitbucket_17, 0 ; data37;  0 OV rs rs [?? ??] 06de 1449
                                                            ; W = v____device_put_17
                               call     l_print_bit_truefalse;  0 OV rs ?? [?? ??] 06df 21d8
                                                            ; W = v____device_put_17
;  147    serial_hw_data = " "                      -- output a space
                               movlw    32                  ;  0 OV ?? ?? [?? ??] 06e0 3020
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 06e1 1283
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 06e2 00a0
                               call     l__serial_hw_data_put;  0 OV rs ?? [?? ??] 06e3 2199
                                                            ; W = v__pic_temp
;  149    g = 0
                               datalo_clr v__bitbucket ; g   ;  0 OV ?? ?s [?? ??] 06e4 1283
                               bcf      v__bitbucket, 1 ; g  ;  0 OV rs rs [?? ??] 06e5 10b7
;  151    print_bit_10(serial_hw_data, g)           -- output 0 or 1
                               movlw    l__serial_hw_data_put;  0 OV rs rs [?? ??] 06e6 3099
                               movwf    v____device_put_19  ;  0 OV rs rs [?? ??] 06e7 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 06e8 3001
                                                            ; W = v____device_put_19
                               movwf    v____device_put_19+1;  0 OV rs rs [?? ??] 06e9 00c8
                               bcf      v____bitbucket_15, 0 ; data41;  0 OV rs rs [?? ??] 06ea 1049
                                                            ; W = v____device_put_19
                               btfsc    v__bitbucket, 1 ; g  ;  0 OV rs rs [?? ??] 06eb 18b7
                                                            ; W = v____device_put_19
                               bsf      v____bitbucket_15, 0 ; data41;  0 OV rs rs [?? ??] 06ec 1449
                                                            ; W = v____device_put_19
                               call     l_print_bit_10      ;  0 OV rs ?? [?? ??] 06ed 2210
                                                            ; W = v____device_put_19
;  152    serial_hw_data = " "                      -- output a space
                               movlw    32                  ;  0 OV ?? ?? [?? ??] 06ee 3020
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 06ef 1283
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 06f0 00a0
                               call     l__serial_hw_data_put;  0 OV rs ?? [?? ??] 06f1 2199
                                                            ; W = v__pic_temp
;  154    print_bit_highlow(serial_hw_data, g)      -- output text 'high' or 'low'
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 06f2 3099
                               datalo_clr v____device_put_18;  0 OV ?? ?s [?? ??] 06f3 1283
                               movwf    v____device_put_18  ;  0 OV rs rs [?? ??] 06f4 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 06f5 3001
                                                            ; W = v____device_put_18
                               movwf    v____device_put_18+1;  0 OV rs rs [?? ??] 06f6 00c8
                               bcf      v____bitbucket_16, 0 ; data39;  0 OV rs rs [?? ??] 06f7 1049
                                                            ; W = v____device_put_18
                               btfsc    v__bitbucket, 1 ; g  ;  0 OV rs rs [?? ??] 06f8 18b7
                                                            ; W = v____device_put_18
                               bsf      v____bitbucket_16, 0 ; data39;  0 OV rs rs [?? ??] 06f9 1449
                                                            ; W = v____device_put_18
                               call     l_print_bit_highlow ;  0 OV rs ?? [?? ??] 06fa 21f4
                                                            ; W = v____device_put_18
;  155    serial_hw_data = " "                      -- output a space
                               movlw    32                  ;  0 OV ?? ?? [?? ??] 06fb 3020
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 06fc 1283
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 06fd 00a0
                               call     l__serial_hw_data_put;  0 OV rs ?? [?? ??] 06fe 2199
                                                            ; W = v__pic_temp
;  157    print_bit_truefalse(serial_hw_data, g)    -- output text 'true' or 'false'
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 06ff 3099
                               datalo_clr v____device_put_17;  0 OV ?? ?s [?? ??] 0700 1283
                               movwf    v____device_put_17  ;  0 OV rs rs [?? ??] 0701 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0702 3001
                                                            ; W = v____device_put_17
                               movwf    v____device_put_17+1;  0 OV rs rs [?? ??] 0703 00c8
                               bcf      v____bitbucket_17, 0 ; data37;  0 OV rs rs [?? ??] 0704 1049
                                                            ; W = v____device_put_17
                               btfsc    v__bitbucket, 1 ; g  ;  0 OV rs rs [?? ??] 0705 18b7
                                                            ; W = v____device_put_17
                               bsf      v____bitbucket_17, 0 ; data37;  0 OV rs rs [?? ??] 0706 1449
                                                            ; W = v____device_put_17
                               call     l_print_bit_truefalse;  0 OV rs ?? [?? ??] 0707 21d8
                                                            ; W = v____device_put_17
;  159    print_crlf(serial_hw_data)       
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0708 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 0709 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 070a 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 070b 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 070c 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 070d 21a2
                                                            ; W = v____device_put_15
;  166    var byte x = "y"
                               movlw    121                 ;  0 OV ?? ?? [?? ??] 070e 3079
                               datalo_clr v___x_118         ;  0 OV ?? ?s [?? ??] 070f 1283
                               movwf    v___x_118           ;  0 OV rs rs [?? ??] 0710 00c6
;  168    print_string(serial_hw_data, str5) 
                               movlw    l__serial_hw_data_put;  0 OV rs rs [?? ??] 0711 3099
                                                            ; W = v___x_118
                               movwf    v____device_put_16  ;  0 OV rs rs [?? ??] 0712 00cd
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0713 3001
                                                            ; W = v____device_put_16
                               movwf    v____device_put_16+1;  0 OV rs rs [?? ??] 0714 00ce
                               movlw    29                  ;  0 OV rs rs [?? ??] 0715 301d
                                                            ; W = v____device_put_16
                               movwf    v__str_count        ;  0 OV rs rs [?? ??] 0716 00d3
                               clrf     v__str_count+1      ;  0 OV rs rs [?? ??] 0717 01d4
                                                            ; W = v__str_count
                               movlw    l__data_str5        ;  0 OV rs rs [?? ??] 0718 3026
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV rs rs [?? ??] 0719 00dd
                               movlw    HIGH l__data_str5   ;  0 OV rs rs [?? ??] 071a 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV rs rs [?? ??] 071b 3840
                               movwf    v___str_1+1         ;  0 OV rs rs [?? ??] 071c 00de
                               call     l_print_string      ;  0 OV rs ?? [?? ??] 071d 21af
                                                            ; W = v___str_1
;  169    print_byte_dec(serial_hw_data, x)  
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 071e 3099
                               datalo_clr v____device_put_34;  0 OV ?? ?s [?? ??] 071f 1283
                               movwf    v____device_put_34  ;  0 OV rs rs [?? ??] 0720 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0721 3001
                                                            ; W = v____device_put_34
                               movwf    v____device_put_34+1;  0 OV rs rs [?? ??] 0722 00c8
                               movf     v___x_118,w         ;  0 OV rs rs [?? ??] 0723 0846
                                                            ; W = v____device_put_34
                               call     l_print_byte_dec    ;  0 OV rs ?? [?? ??] 0724 248a
                                                            ; W = v___x_118
;  172    print_string(serial_hw_data, str6) 
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0725 3099
                               datalo_clr v____device_put_16;  0 OV ?? ?s [?? ??] 0726 1283
                               movwf    v____device_put_16  ;  0 OV rs rs [?? ??] 0727 00cd
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0728 3001
                                                            ; W = v____device_put_16
                               movwf    v____device_put_16+1;  0 OV rs rs [?? ??] 0729 00ce
                               movlw    20                  ;  0 OV rs rs [?? ??] 072a 3014
                                                            ; W = v____device_put_16
                               movwf    v__str_count        ;  0 OV rs rs [?? ??] 072b 00d3
                               clrf     v__str_count+1      ;  0 OV rs rs [?? ??] 072c 01d4
                                                            ; W = v__str_count
                               movlw    l__data_str6        ;  0 OV rs rs [?? ??] 072d 30a9
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV rs rs [?? ??] 072e 00dd
                               movlw    HIGH l__data_str6   ;  0 OV rs rs [?? ??] 072f 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV rs rs [?? ??] 0730 3840
                               movwf    v___str_1+1         ;  0 OV rs rs [?? ??] 0731 00de
                               call     l_print_string      ;  0 OV rs ?? [?? ??] 0732 21af
                                                            ; W = v___str_1
;  173    print_byte_hex(serial_hw_data, x)  
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0733 3099
                               datalo_clr v____device_put_27;  0 OV ?? ?s [?? ??] 0734 1283
                               movwf    v____device_put_27  ;  0 OV rs rs [?? ??] 0735 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0736 3001
                                                            ; W = v____device_put_27
                               movwf    v____device_put_27+1;  0 OV rs rs [?? ??] 0737 00c8
                               movf     v___x_118,w         ;  0 OV rs rs [?? ??] 0738 0846
                                                            ; W = v____device_put_27
                               call     l_print_byte_hex    ;  0 OV rs ?? [?? ??] 0739 23ec
                                                            ; W = v___x_118
;  176    print_string(serial_hw_data, str7) 
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 073a 3099
                               datalo_clr v____device_put_16;  0 OV ?? ?s [?? ??] 073b 1283
                               movwf    v____device_put_16  ;  0 OV rs rs [?? ??] 073c 00cd
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 073d 3001
                                                            ; W = v____device_put_16
                               movwf    v____device_put_16+1;  0 OV rs rs [?? ??] 073e 00ce
                               movlw    32                  ;  0 OV rs rs [?? ??] 073f 3020
                                                            ; W = v____device_put_16
                               movwf    v__str_count        ;  0 OV rs rs [?? ??] 0740 00d3
                               clrf     v__str_count+1      ;  0 OV rs rs [?? ??] 0741 01d4
                                                            ; W = v__str_count
                               movlw    l__data_str7        ;  0 OV rs rs [?? ??] 0742 3005
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV rs rs [?? ??] 0743 00dd
                               movlw    HIGH l__data_str7   ;  0 OV rs rs [?? ??] 0744 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV rs rs [?? ??] 0745 3840
                               movwf    v___str_1+1         ;  0 OV rs rs [?? ??] 0746 00de
                               call     l_print_string      ;  0 OV rs ?? [?? ??] 0747 21af
                                                            ; W = v___str_1
;  177    serial_hw_data = x
                               datalo_clr v___x_118         ;  0 OV ?? ?s [?? ??] 0748 1283
                               movf     v___x_118,w         ;  0 OV rs rs [?? ??] 0749 0846
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 074a 00a0
                                                            ; W = v___x_118
                               call     l__serial_hw_data_put;  0 OV rs ?? [?? ??] 074b 2199
                                                            ; W = v__pic_temp
;  179    print_crlf(serial_hw_data)        
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 074c 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 074d 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 074e 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 074f 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 0750 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 0751 21a2
                                                            ; W = v____device_put_15
;  180    print_crlf(serial_hw_data)        
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0752 3099
                               datalo_clr v____device_put_15;  0 OV ?? ?s [?? ??] 0753 1283
                               movwf    v____device_put_15  ;  0 OV rs rs [?? ??] 0754 00c7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0755 3001
                                                            ; W = v____device_put_15
                               movwf    v____device_put_15+1;  0 OV rs rs [?? ??] 0756 00c8
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 0757 21a2
                                                            ; W = v____device_put_15
;  182 end loop
                               goto     l__l533             ;  0 OV ?? ?? [?? ??] 0758 2d90
                               end
; --- procedures & call stack
;{root} ----- -U- (frame_sz=17 blocks=9)
;   {block enter}
;     --- records ---
;     --- variables ---
;     460e28:_jal_version  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 2004
;     460f18:_jal_build  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 20100313
;     4618a8:_device_id word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 3616
;     461488:_pictype  (type=a dflags=C---- sz=7 use=0 assigned=0)
;      = 49,54,70,56,55,55,65
;     461db8:_datasheet  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 51,57,53,56,50
;     461ea8:_pgmspec  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 51,57,53,56,57
;     4619f8:_pic_12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1
;     461ae8:_pic_14  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2
;     461bd8:_pic_16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 3
;     461cc8:_sx_12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 4
;     462a58:_pic_14h  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 5
;     462bc8:_pjal bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     462d38:_w byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     462ea8:_f byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     463108:_true bit (type=B dflags=C--B- sz=1 use=3 assigned=0 bit=0)
;      = 1
;     463278:_false bit (type=B dflags=C--B- sz=1 use=4 assigned=0 bit=0)
;      = 0
;     4617a8:_high bit (type=B dflags=C--B- sz=1 use=1 assigned=0 bit=0)
;      = 1
;     463478:_low bit (type=B dflags=C--B- sz=1 use=1 assigned=0 bit=0)
;      = 0
;     4635a8:_on bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     4636d8:_off bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     463808:_enabled bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     463938:_disabled bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     463a68:_input bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     463b98:_output bit (type=B dflags=C--B- sz=1 use=1 assigned=0 bit=0)
;      = 0
;     463d68:_all_input byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 255
;     463ed8:_all_output byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     464108:_adc_v0  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44480
;     464248:_adc_v1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44481
;     464388:_adc_v2  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44482
;     4644c8:_adc_v3  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44483
;     464608:_adc_v4  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44484
;     464748:_adc_v5  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44485
;     464888:_adc_v6  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44486
;     4649c8:_adc_v7  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44487
;     464b08:_adc_v7_1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 711793
;     464c48:_adc_v8  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44488
;     464d88:_adc_v9  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44489
;     464ec8:_adc_v10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 711696
;     465108:_adc_v11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 711697
;     465248:_adc_v11_1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 11387153
;     465388:_adc_v12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 711698
;     4654c8:_adc_v13  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 711699
;     465608:_adc_v13_1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 11387185
;     465748:_pic_10f200  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241600
;     465888:_pic_10f202  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241602
;     4659c8:_pic_10f204  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241604
;     465b08:_pic_10f206  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241606
;     465c48:_pic_10f220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241632
;     465d88:_pic_10f222  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241634
;     465ec8:_pic_12f1822  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320704
;     466108:_pic_12f508  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242376
;     466248:_pic_12f509  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242377
;     466388:_pic_12f510  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242384
;     4664c8:_pic_12f519  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242393
;     466608:_pic_12f609  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319488
;     466748:_pic_12f615  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319296
;     466888:_pic_12f617  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315680
;     4669c8:_pic_12f629  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314688
;     466b08:_pic_12f635  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314720
;     466c48:_pic_12f675  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314752
;     466d88:_pic_12f683  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311840
;     466ec8:_pic_12hv609  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319552
;     467108:_pic_12hv615  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319328
;     467248:_pic_12lf1822  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320960
;     467388:_pic_16f1823  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320736
;     4674c8:_pic_16f1826  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320832
;     467608:_pic_16f1827  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320864
;     467748:_pic_16f1933  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319680
;     467888:_pic_16f1934  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319744
;     4679c8:_pic_16f1936  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319776
;     467b08:_pic_16f1937  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319808
;     467c48:_pic_16f1938  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319840
;     467d88:_pic_16f1939  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319872
;     467ec8:_pic_16f1946  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320192
;     468108:_pic_16f1947  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320224
;     468248:_pic_16f505  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242373
;     468388:_pic_16f506  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242374
;     4684c8:_pic_16f526  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242406
;     468608:_pic_16f610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319520
;     468748:_pic_16f616  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315392
;     468888:_pic_16f627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312672
;     4689c8:_pic_16f627a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314880
;     468b08:_pic_16f628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312704
;     468c48:_pic_16f628a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314912
;     468d88:_pic_16f630  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315008
;     468ec8:_pic_16f631  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315872
;     469108:_pic_16f636  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314976
;     469248:_pic_16f639  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314976
;     469388:_pic_16f648a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315072
;     4694c8:_pic_16f676  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315040
;     469608:_pic_16f677  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315904
;     469748:_pic_16f684  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314944
;     469888:_pic_16f685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311904
;     4699c8:_pic_16f687  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315616
;     469b08:_pic_16f688  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315200
;     469c48:_pic_16f689  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315648
;     469d88:_pic_16f690  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315840
;     469ec8:_pic_16f707  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317568
;     46a108:_pic_16f716  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315136
;     46a248:_pic_16f72  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1310880
;     46a388:_pic_16f722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316992
;     46a4c8:_pic_16f722a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317664
;     46a608:_pic_16f723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316960
;     46a748:_pic_16f723a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317632
;     46a888:_pic_16f724  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316928
;     46a9c8:_pic_16f726  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316896
;     46ab08:_pic_16f727  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316864
;     46ac48:_pic_16f73  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312256
;     46ad88:_pic_16f737  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313696
;     46aec8:_pic_16f74  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312288
;     46b108:_pic_16f747  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313760
;     46b248:_pic_16f76  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312320
;     46b388:_pic_16f767  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314464
;     46b4c8:_pic_16f77  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312352
;     46b608:_pic_16f777  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314272
;     46b748:_pic_16f785  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315328
;     46b888:_pic_16f818  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311936
;     46b9c8:_pic_16f819  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311968
;     46bb08:_pic_16f83  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1376131
;     46bc48:_pic_16f84  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1376132
;     46bd88:_pic_16f84a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1374282
;     46bec8:_pic_16f87  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312544
;     46c108:_pic_16f870  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314048
;     46c248:_pic_16f871  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314080
;     46c388:_pic_16f872  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312992
;     46c4c8:_pic_16f873  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313120
;     46c608:_pic_16f873a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314368
;     46c748:_pic_16f874  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313056
;     46c888:_pic_16f874a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314400
;     46c9c8:_pic_16f876  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313248
;     46cb08:_pic_16f876a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314304
;     46cc48:_pic_16f877  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313184
;     46cd88:_pic_16f877a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314336
;     46cec8:_pic_16f88  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312608
;     46d108:_pic_16f882  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318912
;     46d248:_pic_16f883  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318944
;     46d388:_pic_16f884  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318976
;     46d4c8:_pic_16f886  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319008
;     46d608:_pic_16f887  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319040
;     46d748:_pic_16f913  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315808
;     46d888:_pic_16f914  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315776
;     46d9c8:_pic_16f916  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315744
;     46db08:_pic_16f917  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315712
;     46dc48:_pic_16f946  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315936
;     46dd88:_pic_16hv610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319584
;     46dec8:_pic_16hv616  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315424
;     46e108:_pic_16hv785  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315360
;     46e248:_pic_16lf1823  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320992
;     46e388:_pic_16lf1826  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1321088
;     46e4c8:_pic_16lf1827  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1321120
;     46e608:_pic_16lf1933  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319936
;     46e748:_pic_16lf1934  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320000
;     46e888:_pic_16lf1936  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320032
;     46e9c8:_pic_16lf1937  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320064
;     46eb08:_pic_16lf1938  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320096
;     46ec48:_pic_16lf1939  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320128
;     46ed88:_pic_16lf1946  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320320
;     46eec8:_pic_16lf1947  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320352
;     46f108:_pic_16lf707  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317600
;     46f248:_pic_16lf722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317248
;     46f388:_pic_16lf722a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317728
;     46f4c8:_pic_16lf723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317216
;     46f608:_pic_16lf723a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317696
;     46f748:_pic_16lf724  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317184
;     46f888:_pic_16lf726  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317152
;     46f9c8:_pic_16lf727  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317120
;     46fb08:_pic_18f1220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443808
;     46fc48:_pic_18f1230  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449472
;     46fd88:_pic_18f1320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443776
;     46fec8:_pic_18f1330  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449504
;     470108:_pic_18f13k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462080
;     470248:_pic_18f13k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460032
;     470388:_pic_18f14k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462048
;     4704c8:_pic_18f14k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460064
;     470608:_pic_18f2220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443200
;     470748:_pic_18f2221  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450336
;     470888:_pic_18f2320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443072
;     4709c8:_pic_18f2321  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450272
;     470b08:_pic_18f2331  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444064
;     470c48:_pic_18f23k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450208
;     470d88:_pic_18f23k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464128
;     470ec8:_pic_18f2410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446240
;     471108:_pic_18f242  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442944
;     471248:_pic_18f2420  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446208
;     471388:_pic_18f2423  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446224
;     4714c8:_pic_18f2431  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444032
;     471608:_pic_18f2439  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442944
;     471748:_pic_18f2450  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451040
;     471888:_pic_18f2455  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446496
;     4719c8:_pic_18f2458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452640
;     471b08:_pic_18f248  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443840
;     471c48:_pic_18f2480  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448672
;     471d88:_pic_18f24j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449216
;     471ec8:_pic_18f24j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461632
;     472108:_pic_18f24j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461248
;     472248:_pic_18f24k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450144
;     472388:_pic_18f24k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463872
;     4724c8:_pic_18f2510  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446176
;     472608:_pic_18f2515  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445088
;     472748:_pic_18f252  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442816
;     472888:_pic_18f2520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446144
;     4729c8:_pic_18f2523  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446160
;     472b08:_pic_18f2525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445056
;     472c48:_pic_18f2539  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442816
;     472d88:_pic_18f2550  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446464
;     472ec8:_pic_18f2553  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452608
;     473108:_pic_18f258  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443904
;     473248:_pic_18f2580  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448640
;     473388:_pic_18f2585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445600
;     4734c8:_pic_18f25j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448960
;     473608:_pic_18f25j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461664
;     473748:_pic_18f25j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461280
;     473888:_pic_18f25k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450080
;     4739c8:_pic_18f25k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463616
;     473b08:_pic_18f2610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445024
;     473c48:_pic_18f2620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444992
;     473d88:_pic_18f2680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445568
;     473ec8:_pic_18f2682  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451776
;     474108:_pic_18f2685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451808
;     474248:_pic_18f26j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461696
;     474388:_pic_18f26j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461312
;     4744c8:_pic_18f26k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450016
;     474608:_pic_18f26k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463360
;     474748:_pic_18f4220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443232
;     474888:_pic_18f4221  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450304
;     4749c8:_pic_18f4320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443104
;     474b08:_pic_18f4321  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450240
;     474c48:_pic_18f4331  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444000
;     474d88:_pic_18f43k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450176
;     474ec8:_pic_18f43k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464064
;     475108:_pic_18f4410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446112
;     475248:_pic_18f442  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442976
;     475388:_pic_18f4420  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446080
;     4754c8:_pic_18f4423  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446096
;     475608:_pic_18f4431  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443968
;     475748:_pic_18f4439  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442976
;     475888:_pic_18f4450  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451008
;     4759c8:_pic_18f4455  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446432
;     475b08:_pic_18f4458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452576
;     475c48:_pic_18f448  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443872
;     475d88:_pic_18f4480  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448608
;     475ec8:_pic_18f44j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449248
;     476108:_pic_18f44j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461728
;     476248:_pic_18f44j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461344
;     476388:_pic_18f44k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450112
;     4764c8:_pic_18f44k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463808
;     476608:_pic_18f4510  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446048
;     476748:_pic_18f4515  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444960
;     476888:_pic_18f452  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442848
;     4769c8:_pic_18f4520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446016
;     476b08:_pic_18f4523  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446032
;     476c48:_pic_18f4525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444928
;     476d88:_pic_18f4539  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442848
;     476ec8:_pic_18f4550  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446400
;     477108:_pic_18f4553  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452544
;     477248:_pic_18f458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443936
;     477388:_pic_18f4580  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448576
;     4774c8:_pic_18f4585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445536
;     477608:_pic_18f45j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448992
;     477748:_pic_18f45j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461760
;     477888:_pic_18f45j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461376
;     4779c8:_pic_18f45k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450048
;     477b08:_pic_18f45k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463552
;     477c48:_pic_18f4610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444896
;     477d88:_pic_18f4620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444864
;     477ec8:_pic_18f4680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445504
;     478108:_pic_18f4682  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451840
;     478248:_pic_18f4685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451872
;     478388:_pic_18f46j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461792
;     4784c8:_pic_18f46j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461408
;     478608:_pic_18f46k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449984
;     478748:_pic_18f46k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463296
;     478888:_pic_18f6310  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444832
;     4789c8:_pic_18f6390  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444768
;     478b08:_pic_18f6393  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448448
;     478c48:_pic_18f63j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456384
;     478d88:_pic_18f63j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456128
;     478ec8:_pic_18f6410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443552
;     479108:_pic_18f6490  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443488
;     479248:_pic_18f6493  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445376
;     479388:_pic_18f64j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456416
;     4794c8:_pic_18f64j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456160
;     479608:_pic_18f6520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444640
;     479748:_pic_18f6525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444576
;     479888:_pic_18f6527  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446720
;     4799c8:_pic_18f6585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444448
;     479b08:_pic_18f65j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447200
;     479c48:_pic_18f65j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456480
;     479d88:_pic_18f65j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447232
;     479ec8:_pic_18f65j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458432
;     47a108:_pic_18f65j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456224
;     47a248:_pic_18f6620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443424
;     47a388:_pic_18f6621  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444512
;     47a4c8:_pic_18f6622  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446784
;     47a608:_pic_18f6627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446848
;     47a748:_pic_18f6628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460672
;     47a888:_pic_18f6680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444384
;     47a9c8:_pic_18f66j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447264
;     47ab08:_pic_18f66j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459264
;     47ac48:_pic_18f66j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447296
;     47ad88:_pic_18f66j16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459296
;     47aec8:_pic_18f66j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458496
;     47b108:_pic_18f66j55  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458528
;     47b248:_pic_18f66j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447936
;     47b388:_pic_18f66j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449728
;     47b4c8:_pic_18f66j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462272
;     47b608:_pic_18f66j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462336
;     47b748:_pic_18f6720  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443360
;     47b888:_pic_18f6722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446912
;     47b9c8:_pic_18f6723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460736
;     47bb08:_pic_18f67j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447328
;     47bc48:_pic_18f67j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459328
;     47bd88:_pic_18f67j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458560
;     47bec8:_pic_18f67j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449760
;     47c108:_pic_18f67j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462304
;     47c248:_pic_18f67j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462368
;     47c388:_pic_18f8310  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444800
;     47c4c8:_pic_18f8390  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444736
;     47c608:_pic_18f8393  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448480
;     47c748:_pic_18f83j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456512
;     47c888:_pic_18f83j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456256
;     47c9c8:_pic_18f8410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443520
;     47cb08:_pic_18f8490  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443456
;     47cc48:_pic_18f8493  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445408
;     47cd88:_pic_18f84j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456544
;     47cec8:_pic_18f84j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456288
;     47d108:_pic_18f8520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444608
;     47d248:_pic_18f8525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444544
;     47d388:_pic_18f8527  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446752
;     47d4c8:_pic_18f8585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444416
;     47d608:_pic_18f85j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447392
;     47d748:_pic_18f85j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456608
;     47d888:_pic_18f85j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447680
;     47d9c8:_pic_18f85j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458592
;     47db08:_pic_18f85j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456352
;     47dc48:_pic_18f8620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443392
;     47dd88:_pic_18f8621  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444480
;     47dec8:_pic_18f8622  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446816
;     47e108:_pic_18f8627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446880
;     47e248:_pic_18f8628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460704
;     47e388:_pic_18f8680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444352
;     47e4c8:_pic_18f86j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447712
;     47e608:_pic_18f86j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459424
;     47e748:_pic_18f86j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447744
;     47e888:_pic_18f86j16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459456
;     47e9c8:_pic_18f86j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458656
;     47eb08:_pic_18f86j55  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458688
;     47ec48:_pic_18f86j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447968
;     47ed88:_pic_18f86j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449792
;     47eec8:_pic_18f86j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462400
;     47f108:_pic_18f86j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462464
;     47f248:_pic_18f8720  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443328
;     47f388:_pic_18f8722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446944
;     47f4c8:_pic_18f8723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460768
;     47f608:_pic_18f87j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447776
;     47f748:_pic_18f87j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459488
;     47f888:_pic_18f87j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458720
;     47f9c8:_pic_18f87j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449824
;     47fb08:_pic_18f87j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462432
;     47fc48:_pic_18f87j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462496
;     47fd88:_pic_18f96j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448000
;     47fec8:_pic_18f96j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449856
;     480108:_pic_18f97j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449888
;     480248:_pic_18lf13k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462144
;     480388:_pic_18lf13k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459968
;     4804c8:_pic_18lf14k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462112
;     480608:_pic_18lf14k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460000
;     480748:_pic_18lf23k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464160
;     480888:_pic_18lf24j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449280
;     4809c8:_pic_18lf24j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461824
;     480b08:_pic_18lf24j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461440
;     480c48:_pic_18lf24k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463904
;     480d88:_pic_18lf25j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449024
;     480ec8:_pic_18lf25j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461856
;     481108:_pic_18lf25j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461472
;     481248:_pic_18lf25k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463648
;     481388:_pic_18lf26j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461888
;     4814c8:_pic_18lf26j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461504
;     481608:_pic_18lf26k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463392
;     481748:_pic_18lf43k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464096
;     481888:_pic_18lf44j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449312
;     4819c8:_pic_18lf44j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461920
;     481b08:_pic_18lf44j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461536
;     481c48:_pic_18lf44k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463840
;     481d88:_pic_18lf45j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449056
;     481ec8:_pic_18lf45j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461952
;     482108:_pic_18lf45j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461568
;     482248:_pic_18lf45k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463584
;     482388:_pic_18lf46j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461984
;     4824c8:_pic_18lf46j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461600
;     482608:_pic_18lf46k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463328
;     463c68:_target_cpu  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2
;     4827e8:_target_chip  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314336
;     482eb8:_target_chip_name  (type=a dflags=C---- sz=7 use=0 assigned=0)
;      = 49,54,102,56,55,55,97
;     482ca8:_target_bank_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 128
;     482be8:_target_page_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2048
;     482b28:__stack_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8
;     482a68:__code_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8192
;     4828e8:__eeprom  (type=a dflags=C---- sz=256 use=0 assigned=0)
;      = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;     483278:__eeprom_used  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 0
;     483338:__eeprom_base  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 8448
;     483528:__id0  (type=a dflags=C---- sz=4 use=0 assigned=0)
;      = 0,0,0,0
;     483608:__id0_used  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 0
;     4836c8:__id0_base  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 8192
;     482d68:__pic_accum byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=007e)
;     4829a8:__pic_isr_w byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=007f)
;     483ea8:__fuses_ct word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 1
;     484108:__fuse_base word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 8199
;     484278:__fuses word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 16250
;     483da8:_indf byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0000)
;     484598:__ind byte (type=i dflags=-V--- sz=1 use=1 assigned=0 base=0000)
;     484848:_tmr0 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0001)
;     484a18:_pcl byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0002)
;     484cc8:__pcl byte (type=i dflags=-V--- sz=1 use=12 assigned=13 base=0002)
;     484f78:_status byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0003)
;     485108:_status_irp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> status+0
;     485258:_status_rp  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=5) ---> status+0
;     485448:_status_nto bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> status+0
;     4855a8:_status_npd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> status+0
;     485708:_status_z bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> status+0
;     485868:_status_dc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> status+0
;     4859c8:_status_c bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> status+0
;     485b28:__status byte (type=i dflags=-V--- sz=1 use=43 assigned=11 base=0003)
;     485ed8:__irp byte (type=i dflags=C---- sz=1 use=4 assigned=0)
;      = 7
;     486108:__rp1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     486278:__rp0 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     4863e8:__not_to byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     486558:__not_pd byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     4866c8:__z byte (type=i dflags=C---- sz=1 use=72 assigned=0)
;      = 2
;     486838:__dc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     4869a8:__c byte (type=i dflags=C---- sz=1 use=32 assigned=0)
;      = 0
;     485dd8:_fsr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0004)
;     486cc8:__fsr byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0004)
;     486f78:_porta byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0005)
;     487108:__porta_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     487698:__porta_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     488258:__porta_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4889f8:__porta_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     487ec8:__porta_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48ba68:__porta_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48b798:__porta_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48e2f8:_porta_ra5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e488:_pin_a5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e608:_pin_an4 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e6e8:_pin_ss bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e7c8:_pin_c2out bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48ec08:__pin_a5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48e8b8:_porta_ra4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48f788:_pin_a4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48f908:_pin_t0cki bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48f9e8:_pin_c1out bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48fe28:__pin_a4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48fad8:_porta_ra3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     490638:_pin_a3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     4907b8:_pin_an3 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     490898:_pin_vref_pos bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     490cd8:__pin_a3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     490988:_porta_ra2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     4917f8:_pin_a2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491978:_pin_an2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491a58:_pin_vref_neg bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491b38:_pin_cvref bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491f78:__pin_a2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     491c28:_porta_ra1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492a78:_pin_a1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492bf8:_pin_an1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492548:__pin_a1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     492ce8:_porta_ra0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     493ae8:_pin_a0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     493c68:_pin_an0 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     494108:__pin_a0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     493d58:_portb byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0006)
;     494c18:__portb_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     4951b8:__portb_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     495d28:__portb_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     496ca8:__portb_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     495a58:__portb_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     499708:__portb_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     499438:__portb_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49bef8:_portb_rb7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49c108:_pin_b7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49c288:_pin_pgd bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49c6c8:__pin_b7_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49c378:_portb_rb6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     49cc08:_pin_b6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     49d108:_pin_pgc bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     49d548:__pin_b6_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49d1f8:_portb_rb5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     49da88:_pin_b5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     49e458:__pin_b5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49e108:_portb_rb4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     49eec8:_pin_b4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     49f258:__pin_b4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49e998:_portb_rb3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     49fcc8:_pin_b3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     49fe48:_pin_pgm bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     499f58:__pin_b3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49ff38:_portb_rb2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portb+0
;     4a0ae8:_pin_b2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portb+0
;     4a05b8:__pin_b2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a0c78:_portb_rb1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     4a1ae8:_pin_b1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     4a15b8:__pin_b1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a1c78:_portb_rb0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a2ae8:_pin_b0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a2c68:_pin_int bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a3108:__pin_b0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a2d58:_portc byte (type=i dflags=-V--- sz=1 use=1 assigned=2 base=0007)
;     4a3ba8:__portc_shadow byte (type=i dflags=----- auto sz=1 use=2 assigned=3 base=0036)
;     4a41b8:__portc_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4a4d28:__portc_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a5ca8:__portc_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a4a58:__portc_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a8708:__portc_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a8438:__portc_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4aaef8:_portc_rc7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4ab108:_pin_c7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4ab288:_pin_rx bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4ab368:_pin_dt bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4ab7a8:__pin_c7_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ab458:_portc_rc6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4ac2a8:_pin_c6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4ac428:_pin_tx bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4ac508:_pin_ck bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4ac948:__pin_c6_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ac5f8:_portc_rc5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4ad468:_pin_c5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4ad5e8:_pin_sdo bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4ada28:__pin_c5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ad6d8:_portc_rc4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4ae558:_pin_c4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4ae6d8:_pin_sdi bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4ae7b8:_pin_sda bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4aebf8:__pin_c4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ae8a8:_portc_rc3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4af788:_pin_c3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4af908:_pin_sck bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4af9e8:_pin_scl bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4afe28:__pin_c3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4afad8:_portc_rc2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4b06a8:_pin_c2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4b0828:_pin_ccp1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4b0c68:__pin_c2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b0918:_portc_rc1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b1788:_pin_c1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b1908:_pin_t1osi bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b19e8:_pin_ccp2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b1e28:__pin_c1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b1ad8:_portc_rc0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b27f8:_pin_c0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b2978:_pin_t1oso bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b2a58:_pin_t1cki bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b2e98:__pin_c0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b2b48:_portd byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0008)
;     4b39b8:__portd_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     4b3f78:__portd_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4b4b78:__portd_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b5bf8:__portd_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b48a8:__portd_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b8708:__portd_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b8438:__portd_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4baef8:_portd_rd7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portd+0
;     4bb108:_pin_d7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portd+0
;     4bb288:_pin_psp7 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portd+0
;     4bb6c8:__pin_d7_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4bb378:_portd_rd6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portd+0
;     4bbc08:_pin_d6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portd+0
;     4bc108:_pin_psp6 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portd+0
;     4bc548:__pin_d6_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4bc1f8:_portd_rd5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portd+0
;     4bca88:_pin_d5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portd+0
;     4bd108:_pin_psp5 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portd+0
;     4bd548:__pin_d5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4bd1f8:_portd_rd4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portd+0
;     4bda88:_pin_d4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portd+0
;     4be108:_pin_psp4 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portd+0
;     4be548:__pin_d4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4be1f8:_portd_rd3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portd+0
;     4bea88:_pin_d3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portd+0
;     4bf108:_pin_psp3 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portd+0
;     4bf548:__pin_d3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4bf1f8:_portd_rd2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portd+0
;     4bfa88:_pin_d2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portd+0
;     4b4fa8:_pin_psp2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portd+0
;     4c01b8:__pin_d2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b6dd8:_portd_rd1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portd+0
;     4c0c28:_pin_d1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portd+0
;     4c0da8:_pin_psp1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portd+0
;     4c11b8:__pin_d1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c0e98:_portd_rd0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portd+0
;     4c1c28:_pin_d0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portd+0
;     4c1da8:_pin_psp0 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portd+0
;     4c21b8:__pin_d0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c1e98:_porte byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0009)
;     4c2c58:__porte_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     4c31f8:__porte_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4c3d68:__porte_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c4cf8:__porte_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c3a98:__porte_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c7708:__porte_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c7438:__porte_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c9ef8:_porte_re2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porte+0
;     4ca108:_pin_e2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porte+0
;     4ca288:_pin_cs bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porte+0
;     4ca368:_pin_an7 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porte+0
;     4ca7a8:__pin_e2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ca458:_porte_re1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porte+0
;     4cb2a8:_pin_e1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porte+0
;     4cb428:_pin_wr bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porte+0
;     4cb508:_pin_an6 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porte+0
;     4cb948:__pin_e1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4cb5f8:_porte_re0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porte+0
;     4cc468:_pin_e0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porte+0
;     4cc5e8:_pin_rd bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porte+0
;     4cc6c8:_pin_an5 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porte+0
;     4ccb08:__pin_e0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4cc7b8:_pclath byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000a)
;     4cd7e8:_pclath_pclath  (type=i dflags=-V-B- sz=5 use=0 assigned=0 bit=0) ---> pclath+0
;     4cd9d8:__pclath byte (type=i dflags=-V--- sz=1 use=0 assigned=15 base=000a)
;     4cdc88:_intcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000b)
;     4cdf38:_intcon_gie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> intcon+0
;     4cdf98:_intcon_peie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> intcon+0
;     4ce108:_intcon_tmr0ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> intcon+0
;     4ce268:_intcon_inte bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> intcon+0
;     4ce3c8:_intcon_rbie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> intcon+0
;     4ce528:_intcon_tmr0if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> intcon+0
;     4ce688:_intcon_intf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> intcon+0
;     4ce7e8:_intcon_rbif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> intcon+0
;     4ce948:_pir1 byte (type=i dflags=-V--- sz=1 use=1 assigned=0 base=000c)
;     4ceaa8:_pir1_pspif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> pir1+0
;     4cec08:_pir1_adif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pir1+0
;     4ced68:_pir1_rcif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> pir1+0
;     4ceec8:_pir1_txif bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=4) ---> pir1+0
;     4cf108:_pir1_sspif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pir1+0
;     4cf268:_pir1_ccp1if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pir1+0
;     4cf3c8:_pir1_tmr2if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pir1+0
;     4cf528:_pir1_tmr1if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pir1+0
;     4cf688:_pir2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000d)
;     4cf7e8:_pir2_cmif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pir2+0
;     4cf948:_pir2_eeif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pir2+0
;     4cfaa8:_pir2_bclif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pir2+0
;     4cfc08:_pir2_ccp2if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pir2+0
;     4cfd68:_tmr1 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=000e)
;     4cfec8:_tmr1l byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000e)
;     4c5dd8:_tmr1h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000f)
;     4c7f58:_t1con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0010)
;     4d0108:_t1con_t1ckps  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> t1con+0
;     4d02f8:_t1con_t1oscen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> t1con+0
;     4d0458:_t1con_nt1sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> t1con+0
;     4d05b8:_t1con_tmr1cs bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> t1con+0
;     4d0718:_t1con_tmr1on bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> t1con+0
;     4d0878:_tmr2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0011)
;     4d09d8:_t2con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0012)
;     4d0b28:_t2con_toutps  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=3) ---> t2con+0
;     4d0d18:_t2con_tmr2on bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> t2con+0
;     4d0e68:_t2con_t2ckps  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=0) ---> t2con+0
;     4d1108:_sspbuf byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0013)
;     4d1268:_sspcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0014)
;     4d13c8:_sspcon_wcol bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspcon+0
;     4d1528:_sspcon_sspov bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspcon+0
;     4d1688:_sspcon_sspen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspcon+0
;     4d17e8:_sspcon_ckp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspcon+0
;     4d1938:_sspcon_sspm  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> sspcon+0
;     4d1b28:_ccpr1 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=0015)
;     4d1c88:_ccpr1l byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0015)
;     4d1de8:_ccpr1h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0016)
;     4d1f48:_ccp1con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0017)
;     4d2108:_ccp1con_dc1b  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> ccp1con+0
;     4d22e8:_ccp1con_ccp1m  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> ccp1con+0
;     4d24d8:_rcsta byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0018)
;     4d2638:_rcsta_spen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> rcsta+0
;     4d2798:_rcsta_rx9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> rcsta+0
;     4d28f8:_rcsta_sren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> rcsta+0
;     4d2a58:_rcsta_cren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> rcsta+0
;     4d2bb8:_rcsta_adden bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> rcsta+0
;     4d2d18:_rcsta_ferr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> rcsta+0
;     4d2e78:_rcsta_oerr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> rcsta+0
;     4d3108:_rcsta_rx9d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> rcsta+0
;     4d3268:_txreg byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0019)
;     4d33c8:_rcreg byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001a)
;     4d3528:_ccpr2 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=001b)
;     4d3688:_ccpr2l byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001b)
;     4d37e8:_ccpr2h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001c)
;     4d3948:_ccp2con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001d)
;     4d3a98:_ccp2con_dc2b  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> ccp2con+0
;     4d3c78:_ccp2con_ccp2m  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> ccp2con+0
;     4d3e68:_adresh byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001e)
;     4d4108:_adcon0 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=001f)
;     4d4258:_adcon0_adcs  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;     4d4438:_adcon0_chs  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=3) ---> adcon0+0
;     4d4628:_adcon0_go bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> adcon0+0
;     4d4788:_adcon0_ndone bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> adcon0+0
;     4d48e8:_adcon0_adon bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> adcon0+0
;     4d4a48:_option_reg byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0081)
;     4d4c28:_option_reg_nrbpu bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> option_reg+0
;     4d4da8:_option_reg_intedg bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> option_reg+0
;     4d4f18:_option_reg_t0cs bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> option_reg+0
;     4d5108:_t0con_t0cs bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> option_reg+0
;     4d51c8:_option_reg_t0se bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> option_reg+0
;     4d5368:_t0con_t0se bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> option_reg+0
;     4d5428:_option_reg_psa bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> option_reg+0
;     4d55c8:_t0con_psa bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> option_reg+0
;     4d5678:_option_reg_ps  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=0) ---> option_reg+0
;     4d58a8:_t0con_t0ps  (type=i dflags=-V-B- alias sz=3 use=0 assigned=0 bit=0) ---> option_reg+0
;     4d5968:_trisa byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0085)
;     4d5af8:_porta_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisa+0
;     4d5ee8:__porta_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d5c08:__porta_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d8908:__porta_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d8628:__porta_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4dad28:_trisa_trisa5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4daec8:_pin_a5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4db108:_pin_an4_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4db228:_pin_ss_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4db348:_pin_c2out_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4db408:_trisa_trisa4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4db578:_pin_a4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4db748:_pin_t0cki_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4db868:_pin_c1out_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4db928:_trisa_trisa3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4dba98:_pin_a3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4dbc68:_pin_an3_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4dbd88:_pin_vref_pos_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4dbe48:_trisa_trisa2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4db198:_pin_a2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4dbbd8:_pin_an2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4db2b8:_pin_vref_neg_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4dc108:_pin_cvref_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4dc1c8:_trisa_trisa1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4dc338:_pin_a1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4dc508:_pin_an1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4dc5c8:_trisa_trisa0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4dc738:_pin_a0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4dc908:_pin_an0_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4dc9c8:_trisb byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0086)
;     4dcbc8:_portb_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisb+0
;     4dc478:__portb_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4dccd8:__portb_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4dfa08:__portb_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4df728:__portb_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e1c88:_trisb_trisb7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4e1e28:_pin_b7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4e2108:_pin_pgd_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4e21c8:_trisb_trisb6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4e2338:_pin_b6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4e2508:_pin_pgc_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4e25c8:_trisb_trisb5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4e2738:_pin_b5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4e28a8:_trisb_trisb4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4e2a18:_pin_b4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4e2b88:_trisb_trisb3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4e2cf8:_pin_b3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4e2ec8:_pin_pgm_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4e2f88:_trisb_trisb2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisb+0
;     4e2e38:_pin_b2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisb+0
;     4e3108:_trisb_trisb1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisb+0
;     4e3278:_pin_b1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisb+0
;     4e33e8:_trisb_trisb0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4e3558:_pin_b0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4e3728:_pin_int_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4e37e8:_trisc byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0087)
;     4e3978:_portc_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisc+0
;     4e3d68:__portc_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e3a88:__portc_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e6548:__portc_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e6268:__portc_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e8868:_trisc_trisc7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4e8a08:_pin_c7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4e8bd8:_pin_rx_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4e8cf8:_pin_dt_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4e8db8:_trisc_trisc6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4e8f28:_pin_c6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4e8c68:_pin_tx_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4e9108:_pin_ck_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4e91c8:_trisc_trisc5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4e9338:_pin_c5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4e9508:_pin_sdo_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4e95c8:_trisc_trisc4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4e9738:_pin_c4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4e9908:_pin_sdi_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4e9a28:_pin_sda_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4e9ae8:_trisc_trisc3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4e9c58:_pin_c3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4e9e28:_pin_sck_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4e9f48:_pin_scl_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4e9478:_trisc_trisc2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4e9d98:_pin_c2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> trisc+0
;     4e9eb8:_pin_ccp1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4ea108:_trisc_trisc1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4ea278:_pin_c1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4ea448:_pin_t1osi_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4ea568:_pin_ccp2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4ea628:_trisc_trisc0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4ea798:_pin_c0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4ea968:_pin_t1oso_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4eaa88:_pin_t1cki_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4eab48:_trisd byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0088)
;     4eacd8:_portd_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisd+0
;     4ea8d8:__portd_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4eade8:__portd_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4eda08:__portd_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ed728:__portd_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4efde8:_trisd_trisd7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisd+0
;     4eff88:_pin_d7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisd+0
;     4dc878:_pin_psp7_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisd+0
;     4def98:_trisd_trisd6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisd+0
;     4e1f68:_pin_d6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisd+0
;     4ecf28:_pin_psp6_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisd+0
;     4f0108:_trisd_trisd5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisd+0
;     4f0278:_pin_d5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisd+0
;     4f0448:_pin_psp5_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisd+0
;     4f0508:_trisd_trisd4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisd+0
;     4f0678:_pin_d4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisd+0
;     4f0848:_pin_psp4_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisd+0
;     4f0908:_trisd_trisd3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisd+0
;     4f0a78:_pin_d3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisd+0
;     4f0c48:_pin_psp3_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisd+0
;     4f0d08:_trisd_trisd2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisd+0
;     4f0e78:_pin_d2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisd+0
;     4f03b8:_pin_psp2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisd+0
;     4f07b8:_trisd_trisd1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisd+0
;     4f1108:_pin_d1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisd+0
;     4f12d8:_pin_psp1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisd+0
;     4f1398:_trisd_trisd0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisd+0
;     4f1508:_pin_d0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisd+0
;     4f16d8:_pin_psp0_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisd+0
;     4f1798:_trise byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0089)
;     4f1928:_porte_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trise+0
;     4f1d18:__porte_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4f1a38:__porte_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4f4548:__porte_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4f4268:__porte_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4f6868:_trise_ibf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trise+0
;     4f69f8:_trise_obf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trise+0
;     4f6b58:_trise_ibov bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trise+0
;     4f6cb8:_trise_pspmode bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trise+0
;     4f6e18:_trise_trise2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trise+0
;     4f6f88:_pin_e2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trise+0
;     4f7108:_pin_cs_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trise+0
;     4f7228:_pin_an7_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trise+0
;     4f72e8:_trise_trise1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trise+0
;     4f7458:_pin_e1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trise+0
;     4f7628:_pin_wr_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trise+0
;     4f7748:_pin_an6_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trise+0
;     4f7808:_trise_trise0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trise+0
;     4f7978:_pin_e0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trise+0
;     4f7b48:_pin_rd_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trise+0
;     4f7c68:_pin_an5_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trise+0
;     4f7d28:_pie1 byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=008c)
;     4f7e88:_pie1_pspie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> pie1+0
;     4f7198:_pie1_adie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pie1+0
;     4f76b8:_pie1_rcie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> pie1+0
;     4f7bd8:_pie1_txie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=4) ---> pie1+0
;     4f8108:_pie1_sspie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pie1+0
;     4f8268:_pie1_ccp1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pie1+0
;     4f83c8:_pie1_tmr2ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pie1+0
;     4f8528:_pie1_tmr1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pie1+0
;     4f8688:_pie2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008d)
;     4f87e8:_pie2_cmie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pie2+0
;     4f8948:_pie2_eeie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pie2+0
;     4f8aa8:_pie2_bclie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pie2+0
;     4f8c08:_pie2_ccp2ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pie2+0
;     4f8d68:_pcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008e)
;     4f8ec8:_pcon_npor bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pcon+0
;     4f9108:_pcon_nbor bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pcon+0
;     4f9268:_sspcon2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0091)
;     4f93c8:_sspcon2_gcen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspcon2+0
;     4f9528:_sspcon2_ackstat bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspcon2+0
;     4f9688:_sspcon2_ackdt bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspcon2+0
;     4f97e8:_sspcon2_acken bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspcon2+0
;     4f9948:_sspcon2_rcen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> sspcon2+0
;     4f9aa8:_sspcon2_pen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspcon2+0
;     4f9c08:_sspcon2_rsen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> sspcon2+0
;     4f9d68:_sspcon2_sen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> sspcon2+0
;     4f9ec8:_pr2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0092)
;     4fa108:_sspadd byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0093)
;     4fa268:_sspstat byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0094)
;     4fa3c8:_sspstat_smp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspstat+0
;     4fa528:_sspstat_cke bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspstat+0
;     4fa688:_sspstat_d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspstat+0
;     4fa7e8:_sspstat_na bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspstat+0
;     4fa948:_sspstat_p bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspstat+0
;     4faaa8:_sspstat_s bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> sspstat+0
;     4fac08:_sspstat_r bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspstat+0
;     4fad68:_sspstat_nw bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspstat+0
;     4faec8:_sspstat_ua bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> sspstat+0
;     4fb108:_sspstat_bf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> sspstat+0
;     4fb268:_txsta byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0098)
;     4fb3c8:_txsta_csrc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> txsta+0
;     4fb528:_txsta_tx9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> txsta+0
;     4fb688:_txsta_txen bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> txsta+0
;     4fb7e8:_txsta_sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> txsta+0
;     4fb948:_txsta_brgh bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> txsta+0
;     4fbaa8:_txsta_trmt bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> txsta+0
;     4fbc08:_txsta_tx9d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> txsta+0
;     4fbd68:_spbrg byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0099)
;     4fbec8:_cmcon byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=009c)
;     4fc108:_cmcon_c2out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> cmcon+0
;     4fc268:_cmcon_c1out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> cmcon+0
;     4fc3c8:_cmcon_c2inv bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> cmcon+0
;     4fc528:_cmcon_c1inv bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> cmcon+0
;     4fc688:_cmcon_cis bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> cmcon+0
;     4fc7d8:_cmcon_cm  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=0) ---> cmcon+0
;     4fc9c8:_cvrcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=009d)
;     4fcb28:_cvrcon_cvren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> cvrcon+0
;     4fcc88:_cvrcon_cvroe bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> cvrcon+0
;     4fcde8:_cvrcon_cvrr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> cvrcon+0
;     4fcf38:_cvrcon_cvr  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> cvrcon+0
;     4fd108:_adresl byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=009e)
;     4fd268:_adcon1 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=009f)
;     4fd3c8:_adcon1_adfm bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> adcon1+0
;     4fd528:_adcon1_adcs2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> adcon1+0
;     4fd678:_adcon1_pcfg  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> adcon1+0
;     4fd868:_eedata byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010c)
;     4fd9c8:_eeadr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010d)
;     4fdb28:_eedath byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010e)
;     4fdc78:_eedath_eedath  (type=i dflags=-V-B- sz=6 use=0 assigned=0 bit=0) ---> eedath+0
;     4fde68:_eeadrh byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010f)
;     4fe108:_eeadrh_eeadrh  (type=i dflags=-V-B- sz=5 use=0 assigned=0 bit=0) ---> eeadrh+0
;     4fe2f8:_eecon1 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=018c)
;     4fe458:_eecon1_eepgd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> eecon1+0
;     4fe5b8:_eecon1_wrerr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> eecon1+0
;     4fe718:_eecon1_wren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> eecon1+0
;     4fe878:_eecon1_wr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> eecon1+0
;     4fe9d8:_eecon1_rd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> eecon1+0
;     4feb38:_eecon2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=018d)
;     4fecc8:_adc_group  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44481
;     4feeb8:_adc_ntotal_channel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 8
;     4feda8:_adc_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     500108:_comparator_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     500bb8:_enable_digital_io_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     502638:_target_clock  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 20000000
;     501ae8:_led bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     5027f8:_led_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     502c08:_delay_1us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     502e18:_delay_2us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     503708:_delay_3us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     503ea8:_delay_4us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     504788:_delay_5us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     504f28:_delay_6us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5057f8:_delay_7us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     505f98:_delay_8us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5067f8:_delay_9us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     506f98:_instruction_time  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 20
;     5079d8:_delay_10us_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     50a8c8:_delay_1ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     50f1f8:_delay_100ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     510c98:_delay_1s_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     513728:_serial_hw_baudrate  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 115200
;     513c78:_usart_hw_serial bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     507588:__calculate_and_set_baudrate_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     514868:_serial_hw_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     514d68:_serial_hw_disable_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     519b48:_serial_hw_enable_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     51a5c8:_serial_hw_write_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     51bc58:_serial_hw_write_word_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     51df08:__serial_hw_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     502938:_serial_hw_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     521c38:__serial_hw_data_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     51a2f8:__serial_hw_data_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     524ee8:_serial_hw_data_available bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> pir1+0
;     525108:_serial_hw_data_ready bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> pir1+0
;     5254f8:__serial_hw_data_raw_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     525218:__serial_hw_data_raw_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     526928:_print_string_terminator  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 0
;     526818:__format_leader  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     526bc8:__format_digit  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     526c88:__format_sign  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     526d78:__format_signed  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     5275d8:__write_real_digit_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     52ae38:__write_digit_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     52da88:_format_byte_dec_1  (type=F dflags=----- sz=5 use=0 assigned=0 base=0000)
;     532df8:_format_word_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     53b918:_format_dword_dec_1  (type=F dflags=----- sz=8 use=0 assigned=0 base=0000)
;     54d1f8:_format_sbyte_dec_1  (type=F dflags=----- sz=5 use=0 assigned=0 base=0000)
;     52afa8:_format_sword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     552ed8:_format_sword_dec_length_1  (type=F dflags=----- sz=7 use=0 assigned=0 base=0000)
;     552c38:_format_sdword_dec_1  (type=F dflags=----- sz=8 use=0 assigned=0 base=0000)
;     52aba8:_format_byte_hex_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     565258:_format_word_hex_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     568e88:_format_dword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     56caf8:_format_time_hm_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     571158:_format_time_hms_1  (type=F dflags=----- sz=5 use=0 assigned=0 base=0000)
;     56c868:_format_time_hm_word_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     527218:_ascii_null byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     579d08:_ascii_soh byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     579e78:_ascii_stx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 2
;     579748:_ascii_etx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     57a108:_ascii_eot byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     57a278:_ascii_enq byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     57a3e8:_ascii_ack byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     57a558:_ascii_bel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 7
;     57a6c8:_ascii_bs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 8
;     57a838:_ascii_ht byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 9
;     57a9a8:_ascii_lf byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 10
;     57ab18:_ascii_vt byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 11
;     57ac88:_ascii_ff byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 12
;     57adf8:_ascii_cr byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 13
;     57af68:_ascii_so byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 14
;     57b108:_ascii_si byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 15
;     57b278:_ascii_dle byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 16
;     57b3e8:_ascii_dc1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 17
;     57b558:_ascii_dc2 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 18
;     57b6c8:_ascii_dc3 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 19
;     57b838:_ascii_dc4 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 20
;     57b9a8:_ascii_nak byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 21
;     57bb18:_ascii_syn byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 22
;     57bc88:_ascii_etb byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 23
;     57bdf8:_ascii_can byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 24
;     57bf68:_ascii_em byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 25
;     57c108:_ascii_sub byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 26
;     57c278:_ascii_esc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 27
;     57c3e8:_ascii_fs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 28
;     57c558:_ascii_gs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 29
;     57c6c8:_ascii_rs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 30
;     57c838:_ascii_us byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 31
;     57c9a8:_ascii_sp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 32
;     57cb18:_ascii_del byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 127
;     57ce98:_toupper_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     57fb48:_tolower_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     582988:__print_universal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     582f78:__print_suniversal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     5825d8:_print_byte_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     584348:_nibble2hex  (type=a dflags=C---- lookup sz=16 use=36 assigned=0)
;      = 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70
;     52aa98:_print_prefix bit (type=B dflags=---B- sz=1 use=6 assigned=1 bit=0) ---> _bitbucket+0
;     5826e8:_print_crlf_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5837c8:_print_string_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5841f8:_print_bit_truefalse_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5884a8:_print_bit_highlow_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     58a2e8:_print_bit_10_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     58ce08:_print_dword_binary_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     58fb98:_print_word_binary_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     595528:_print_nibble_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     598ef8:_print_dword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     59f628:_print_sdword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5a5ae8:_print_word_hex_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5a9858:_print_byte_hex_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5ac1b8:_print_sdword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5ad108:_print_sword_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5adfa8:_print_sword_fp_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     559fa8:_print_sbyte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5b0e98:_print_dword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5b1e28:_print_word_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5b2da8:_print_byte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5af828:__bitbucket  (type=i dflags=----- auto sz=1 use=12 assigned=3 base=0037)
;     553df8:__pic_temp  (type=i dflags=----- sz=4 use=16 assigned=75) ---> _pic_state+0
;     545c48:__pic_pointer  (type=i dflags=----- sz=2 use=3 assigned=40 base=0032)
;     4ddaf8:__pic_loop  (type=i dflags=----- sz=1 use=1 assigned=2 base=0030)
;     4dd418:__pic_divisor  (type=i dflags=----- sz=4 use=20 assigned=16) ---> _pic_state+8
;     4da618:__pic_dividend  (type=i dflags=----- sz=4 use=9 assigned=16) ---> _pic_state+0
;     4da408:__pic_quotient  (type=i dflags=----- sz=4 use=17 assigned=13) ---> _pic_state+12
;     4d9568:__pic_remainder  (type=i dflags=----- sz=4 use=20 assigned=16) ---> _pic_state+4
;     4d8ee8:__pic_divaccum  (type=i dflags=----- sz=8 use=8 assigned=8) ---> _pic_state+0
;     679f88:__pic_sign  (type=i dflags=----- sz=1 use=2 assigned=3 base=0031)
;     67a1c8:__pic_state  (type=i dflags=----- sz=16 use=90 assigned=144 base=0020)
;     --- labels ---
;     _isr_cleanup (pc(0000) usage=0)
;     _isr_preamble (pc(0000) usage=0)
;     _main (pc(0158) usage=7)
;     _porta_flush (pc(0000) usage=0)
;     _porta_put (pc(0000) usage=0)
;     _porta_low_put (pc(0000) usage=0)
;     _porta_low_get (pc(0000) usage=0)
;     _porta_high_put (pc(0000) usage=0)
;     _porta_high_get (pc(0000) usage=0)
;     _pin_a5_put (pc(0000) usage=0)
;     _pin_a4_put (pc(0000) usage=0)
;     _pin_a3_put (pc(0000) usage=0)
;     _pin_a2_put (pc(0000) usage=0)
;     _pin_a1_put (pc(0000) usage=0)
;     _pin_a0_put (pc(0000) usage=0)
;     _portb_flush (pc(0000) usage=0)
;     _portb_put (pc(0000) usage=0)
;     _portb_low_put (pc(0000) usage=0)
;     _portb_low_get (pc(0000) usage=0)
;     _portb_high_put (pc(0000) usage=0)
;     _portb_high_get (pc(0000) usage=0)
;     _pin_b7_put (pc(0000) usage=0)
;     _pin_b6_put (pc(0000) usage=0)
;     _pin_b5_put (pc(0000) usage=0)
;     _pin_b4_put (pc(0000) usage=0)
;     _pin_b3_put (pc(0000) usage=0)
;     _pin_b2_put (pc(0000) usage=0)
;     _pin_b1_put (pc(0000) usage=0)
;     _pin_b0_put (pc(0000) usage=0)
;     _portc_flush (pc(0000) usage=0)
;     _portc_put (pc(0000) usage=0)
;     _portc_low_put (pc(0000) usage=0)
;     _portc_low_get (pc(0000) usage=0)
;     _portc_high_put (pc(0000) usage=0)
;     _portc_high_get (pc(0000) usage=0)
;     _pin_c7_put (pc(0000) usage=0)
;     _pin_c6_put (pc(0000) usage=0)
;     _pin_c5_put (pc(0000) usage=0)
;     _pin_c4_put (pc(0000) usage=0)
;     _pin_c3_put (pc(0000) usage=0)
;     _pin_c2_put (pc(0000) usage=0)
;     _pin_c1_put (pc(0000) usage=0)
;     _pin_c0_put (pc(0000) usage=0)
;     _portd_flush (pc(0000) usage=0)
;     _portd_put (pc(0000) usage=0)
;     _portd_low_put (pc(0000) usage=0)
;     _portd_low_get (pc(0000) usage=0)
;     _portd_high_put (pc(0000) usage=0)
;     _portd_high_get (pc(0000) usage=0)
;     _pin_d7_put (pc(0000) usage=0)
;     _pin_d6_put (pc(0000) usage=0)
;     _pin_d5_put (pc(0000) usage=0)
;     _pin_d4_put (pc(0000) usage=0)
;     _pin_d3_put (pc(0000) usage=0)
;     _pin_d2_put (pc(0000) usage=0)
;     _pin_d1_put (pc(0000) usage=0)
;     _pin_d0_put (pc(0000) usage=0)
;     _porte_flush (pc(0000) usage=0)
;     _porte_put (pc(0000) usage=0)
;     _porte_low_put (pc(0000) usage=0)
;     _porte_low_get (pc(0000) usage=0)
;     _porte_high_put (pc(0000) usage=0)
;     _porte_high_get (pc(0000) usage=0)
;     _pin_e2_put (pc(0000) usage=0)
;     _pin_e1_put (pc(0000) usage=0)
;     _pin_e0_put (pc(0000) usage=0)
;     _porta_low_direction_put (pc(0000) usage=0)
;     _porta_low_direction_get (pc(0000) usage=0)
;     _porta_high_direction_put (pc(0000) usage=0)
;     _porta_high_direction_get (pc(0000) usage=0)
;     _portb_low_direction_put (pc(0000) usage=0)
;     _portb_low_direction_get (pc(0000) usage=0)
;     _portb_high_direction_put (pc(0000) usage=0)
;     _portb_high_direction_get (pc(0000) usage=0)
;     _portc_low_direction_put (pc(0000) usage=0)
;     _portc_low_direction_get (pc(0000) usage=0)
;     _portc_high_direction_put (pc(0000) usage=0)
;     _portc_high_direction_get (pc(0000) usage=0)
;     _portd_low_direction_put (pc(0000) usage=0)
;     _portd_low_direction_get (pc(0000) usage=0)
;     _portd_high_direction_put (pc(0000) usage=0)
;     _portd_high_direction_get (pc(0000) usage=0)
;     _porte_low_direction_put (pc(0000) usage=0)
;     _porte_low_direction_get (pc(0000) usage=0)
;     _porte_high_direction_put (pc(0000) usage=0)
;     _porte_high_direction_get (pc(0000) usage=0)
;     adc_off (pc(0000) usage=0)
;     comparator_off (pc(0000) usage=0)
;     enable_digital_io (pc(0000) usage=0)
;     delay_1us (pc(0000) usage=0)
;     delay_2us (pc(0000) usage=0)
;     delay_3us (pc(0000) usage=0)
;     delay_4us (pc(0000) usage=0)
;     delay_5us (pc(0000) usage=0)
;     delay_6us (pc(0000) usage=0)
;     delay_7us (pc(0000) usage=0)
;     delay_8us (pc(0000) usage=0)
;     delay_9us (pc(0000) usage=0)
;     delay_10us (pc(0000) usage=0)
;     delay_1ms (pc(0000) usage=0)
;     delay_100ms (pc(015b) usage=14)
;     delay_1s (pc(0000) usage=0)
;     _calculate_and_set_baudrate (pc(0186) usage=7)
;     serial_hw_init (pc(018a) usage=7)
;     serial_hw_disable (pc(0000) usage=0)
;     serial_hw_enable (pc(0000) usage=0)
;     serial_hw_write (pc(0193) usage=7)
;     serial_hw_write_word (pc(0000) usage=0)
;     _serial_hw_read (pc(0000) usage=0)
;     serial_hw_read (pc(0000) usage=0)
;     _serial_hw_data_put (pc(0199) usage=259)
;     _serial_hw_data_get (pc(0000) usage=0)
;     _serial_hw_data_raw_put (pc(0000) usage=0)
;     _serial_hw_data_raw_get (pc(0000) usage=0)
;     _write_real_digit (pc(0000) usage=0)
;     _write_digit (pc(0000) usage=0)
;     format_byte_dec (pc(0000) usage=0)
;     format_word_dec (pc(0000) usage=0)
;     format_dword_dec (pc(0000) usage=0)
;     format_sbyte_dec (pc(0000) usage=0)
;     format_sword_dec (pc(0000) usage=0)
;     format_sword_dec_length (pc(0000) usage=0)
;     format_sdword_dec (pc(0000) usage=0)
;     format_byte_hex (pc(0000) usage=0)
;     format_word_hex (pc(0000) usage=0)
;     format_dword_hex (pc(0000) usage=0)
;     format_time_hm (pc(0000) usage=0)
;     format_time_hms (pc(0000) usage=0)
;     format_time_hm_word (pc(0000) usage=0)
;     toupper (pc(0000) usage=0)
;     tolower (pc(0000) usage=0)
;     _print_universal_dec (pc(04ea) usage=28)
;     _print_suniversal_dec (pc(049c) usage=21)
;     print_byte_binary (pc(0283) usage=49)
;     print_crlf (pc(01a2) usage=105)
;     print_string (pc(01af) usage=77)
;     print_bit_truefalse (pc(01d8) usage=14)
;     print_bit_highlow (pc(01f4) usage=14)
;     print_bit_10 (pc(0210) usage=14)
;     print_dword_binary (pc(021e) usage=7)
;     print_word_binary (pc(0261) usage=7)
;     print_nibble_binary (pc(0000) usage=0)
;     print_dword_hex (pc(02b1) usage=7)
;     print_sdword_hex (pc(0000) usage=0)
;     print_word_hex (pc(038e) usage=7)
;     print_byte_hex (pc(03ec) usage=14)
;     print_sdword_dec (pc(041b) usage=7)
;     print_sword_dec (pc(0430) usage=7)
;     print_sword_fp_dec (pc(0000) usage=0)
;     print_sbyte_dec (pc(0445) usage=7)
;     print_dword_dec (pc(0459) usage=7)
;     print_word_dec (pc(0475) usage=7)
;     print_byte_dec (pc(048a) usage=14)
;     _pic_indirect (pc(0155) usage=222)
;     _data_str1 (pc(00d5) usage=4)
;     _data_str0 (pc(00cf) usage=4)
;     _data_str1_1 (pc(00da) usage=4)
;     _data_str0_1 (pc(00df) usage=4)
;     _pic_divide (pc(0103) usage=6)
;     _pic_sdivide (pc(00e2) usage=6)
;     _data_str1_2 (pc(0044) usage=4)
;     _data_str2 (pc(0079) usage=4)
;     _data_str3 (pc(005f) usage=4)
;     _data_str4 (pc(0092) usage=4)
;     _data_str5 (pc(0026) usage=4)
;     _data_str6 (pc(00a9) usage=4)
;     _data_str7 (pc(0005) usage=4)
;     _pic_reset (pc(0000) usage=0)
;     _pic_isr (pc(0000) usage=0)
;     _pic_lookup (pc(0000) usage=0)
;     _lookup_str7 (pc(0004) usage=0)
;     _lookup_str5 (pc(0025) usage=0)
;     _lookup_str1_2 (pc(0043) usage=0)
;     _lookup_str3 (pc(005e) usage=0)
;     _lookup_str2 (pc(0078) usage=0)
;     _lookup_str4 (pc(0091) usage=0)
;     _lookup_str6 (pc(00a8) usage=0)
;     _lookup_nibble2hex (pc(00bd) usage=56)
;     _lookup_str0 (pc(00ce) usage=0)
;     _lookup_str1 (pc(00d4) usage=0)
;     _lookup_str1_1 (pc(00d9) usage=0)
;     _lookup_str0_1 (pc(00de) usage=0)
;     {block enter}
;       --- records ---
;       --- variables ---
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;       {block exit}
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       5bfeb8:_str1_2  (type=a dflags=C---- lookup sz=26 use=1 assigned=0)
;        = 32,45,32,84,101,115,116,32,112,114,105,110,116,46,106,97,108,45,32,98,121,116,101,115,13,10
;       5be6d8:_a byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0038)
;       5be7c8:_b_2 sbyte (type=i dflags=--S-- auto sz=1 use=1 assigned=1 base=0039)
;       5c2458:_str2  (type=a dflags=C---- lookup sz=24 use=1 assigned=0)
;        = 84,101,115,116,32,112,114,105,110,116,46,106,97,108,32,45,32,119,111,114,100,115,13,10
;       5beb88:_c word (type=i dflags=----- auto sz=2 use=6 assigned=2 base=003a)
;       5bec78:_d sword (type=i dflags=--S-- auto sz=2 use=2 assigned=2 base=003c)
;       5c4b48:_str3  (type=a dflags=C---- lookup sz=25 use=1 assigned=0)
;        = 84,101,115,116,32,112,114,105,110,116,46,106,97,108,32,45,32,100,119,111,114,100,115,13,10
;       5bf158:_e dword (type=i dflags=----- auto sz=4 use=12 assigned=4 base=003e)
;       5bf248:_f_1 sdword (type=i dflags=--S-- auto sz=4 use=4 assigned=4 base=0042)
;       5c7348:_str4  (type=a dflags=C---- lookup sz=22 use=1 assigned=0)
;        = 84,101,115,116,32,112,114,105,110,116,46,106,97,108,32,45,32,98,105,116,13,10
;       5bf608:_g bit (type=B dflags=---B- sz=1 use=6 assigned=2 bit=1) ---> _bitbucket+0
;       5bfd88:_x_118 byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0046)
;       5cb188:_str5  (type=a dflags=C---- lookup sz=29 use=1 assigned=0)
;        = 86,97,114,105,97,98,108,101,32,120,32,104,97,115,32,100,101,99,105,109,97,108,32,118,97,108,117,101,32
;       5ca888:_str6  (type=a dflags=C---- lookup sz=20 use=1 assigned=0)
;        = 32,119,104,105,99,104,32,105,115,32,104,101,120,32,118,97,108,117,101,32
;       5cd618:_str7  (type=a dflags=C---- lookup sz=32 use=1 assigned=0)
;        = 32,97,110,100,32,114,101,112,114,101,115,101,110,116,115,32,65,83,67,73,73,32,99,104,97,114,97,99,116,101,114,32
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         5836d8:_x_116 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=2) ---> _portc_shadow+0
;         --- labels ---
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;         {block exit}
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         5b3c38:_x_117 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=2) ---> _portc_shadow+0
;         --- labels ---
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;         {block exit}
;       {block exit}
;     {block exit}
;   {block exit}
;      print_byte_dec --D-- -U- (frame_sz=3 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5b2f98:__device_put_34  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=4 base=0047)
;        5b3108:_data_71 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0049)
;        5af728:__bitbucket_1  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_word_dec --D-- -U- (frame_sz=4 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5b2108:__device_put_33  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=2 base=0047)
;        5b21c8:_data_69 word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0049)
;        5af4b8:__bitbucket_2  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_dword_dec --D-- -U- (frame_sz=6 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5b1188:__device_put_32  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=2 base=0047)
;        5b1248:_data_67 dword (type=i dflags=----- auto sz=4 use=4 assigned=4 base=0049)
;        5af358:__bitbucket_3  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sbyte_dec --D-- -U- (frame_sz=3 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5b01f8:__device_put_31  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=2 base=0047)
;        5b02b8:_data_65 sbyte (type=i dflags=--S-- auto sz=1 use=1 assigned=1 base=0049)
;        5aef78:__bitbucket_4  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_fp_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5ae268:__device_put_30  (type=* dflags=C---- sz=2 use=0 assigned=1)
;         = 0
;        5ae328:_data_63  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        5ae688:__temp_65  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5aecd8:__bitbucket_5  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_dec --D-- -U- (frame_sz=4 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5ad2f8:__device_put_29  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=2 base=0047)
;        5ad3b8:_data_61 sword (type=i dflags=--S-- auto sz=2 use=2 assigned=2 base=0049)
;        5aebd8:__bitbucket_6  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sdword_dec --D-- -U- (frame_sz=6 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5ac3a8:__device_put_28  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=2 base=0047)
;        5ac438:_data_59 sdword (type=i dflags=--S-- auto sz=4 use=4 assigned=4 base=0049)
;        5ae768:__bitbucket_7  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_hex --D-- -U- (frame_sz=5 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a9a48:__device_put_27  (type=* dflags=----- auto ptr_ptr sz=2 use=8 assigned=4 base=0047)
;        5a9ad8:_data_57 byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=0049)
;        5aa948:__temp_64  (type=i dflags=----- auto sz=2 use=3 assigned=3 base=004d)
;        5ae558:__bitbucket_8  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_word_hex --D-- -U- (frame_sz=8 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a5cd8:__device_put_26  (type=* dflags=----- auto ptr_ptr sz=2 use=12 assigned=2 base=0047)
;        5a5d68:_data_55 word (type=i dflags=----- auto sz=2 use=5 assigned=2 base=0049)
;        5a6b78:__temp_63  (type=i dflags=----- auto sz=4 use=9 assigned=16 base=004f)
;        5a5108:__bitbucket_9  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_sdword_hex ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        59f818:__device_put_25  (type=* dflags=C---- sz=2 use=0 assigned=10)
;         = 0
;        59f8a8:_data_53  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        5a0698:__temp_62  (type=i dflags=C---- sz=8 use=0 assigned=0)
;         = 0
;        5a4e88:__bitbucket_10  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_dword_hex --D-- -U- (frame_sz=14 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5991f8:__device_put_24  (type=* dflags=----- auto ptr_ptr sz=2 use=20 assigned=2 base=0047)
;        5992b8:_data_51 dword (type=i dflags=----- auto sz=4 use=17 assigned=4 base=0049)
;        59a108:__temp_61  (type=i dflags=----- auto sz=8 use=24 assigned=69 base=0055)
;        5a4a78:__bitbucket_11  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_nibble_binary ----- --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        595718:__device_put_23  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        5957d8:_data_49  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5959d8:__floop9  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        596388:__temp_60  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5969d8:__btemp_22  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        598418:__btemp63  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5a4518:__bitbucket_12  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          596aa8:__btemp62  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      print_word_binary --D-- -U- (frame_sz=5 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        58fd88:__device_put_21  (type=* dflags=----- auto ptr_ptr sz=2 use=8 assigned=2 base=0047)
;        58fe48:_data_45 word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0049)
;        5904d8:__temp_58  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=004f)
;        5a47d8:__bitbucket_13  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_dword_binary --D-- -U- (frame_sz=7 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        58d108:__device_put_20  (type=* dflags=----- auto ptr_ptr sz=2 use=12 assigned=2 base=0047)
;        58d1c8:_data_43 dword (type=i dflags=----- auto sz=4 use=7 assigned=4 base=0049)
;        58de18:__temp_57  (type=i dflags=----- auto sz=1 use=3 assigned=3 base=0055)
;        5a4678:__bitbucket_14  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_bit_10 --D-- -U- (frame_sz=3 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        58bb48:__device_put_19  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=4 base=0047)
;        58bc08:_data_41 bit (type=B dflags=---B- sz=1 use=1 assigned=4 bit=0) ---> ___bitbucket15+0
;        5a4108:__bitbucket_15  (type=i dflags=----- auto sz=1 use=1 assigned=4 base=0049)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_bit_highlow --D-- -U- (frame_sz=3 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        588598:__device_put_18  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=4 base=0047)
;        588958:_data_39 bit (type=B dflags=---B- sz=1 use=1 assigned=4 bit=0) ---> ___bitbucket16+0
;        58a508:_str1_1  (type=a dflags=C---- lookup sz=4 use=1 assigned=0)
;         = 104,105,103,104
;        58a3d8:_str0_1  (type=a dflags=C---- lookup sz=3 use=1 assigned=0)
;         = 108,111,119
;        5a3a78:__bitbucket_16  (type=i dflags=----- auto sz=1 use=1 assigned=4 base=0049)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_bit_truefalse --D-- -U- (frame_sz=3 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        588108:__device_put_17  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=4 base=0047)
;        5881c8:_data_37 bit (type=B dflags=---B- sz=1 use=1 assigned=4 bit=0) ---> ___bitbucket17+0
;        5886e8:_str1  (type=a dflags=C---- lookup sz=4 use=1 assigned=0)
;         = 116,114,117,101
;        588aa8:_str0  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;         = 102,97,108,115,101
;        5a3d38:__bitbucket_17  (type=i dflags=----- auto sz=1 use=1 assigned=4 base=0049)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_string --D-- -U- (frame_sz=9 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5838b8:__device_put_16  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=22 base=004d)
;        5839a8:__str_count  (type=i dflags=----- auto sz=2 use=2 assigned=22 base=0053)
;        583a98:_str_1  (type=* dflags=----- auto ptr_lookup sz=2 use=4 assigned=22 base=005d)
;        583b88:_len_2 word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0063)
;        583c78:_i_1 byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=0066)
;        583e58:__btemp_20  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        584108:__btemp59  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5a3bd8:__bitbucket_18  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          583f48:__btemp58  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      print_crlf --D-- -U- (frame_sz=2 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5835e8:__device_put_15  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=30 base=0047)
;        5a3668:__bitbucket_19  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_binary --D-- -U- (frame_sz=5 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5913a8:__device_put_22  (type=* dflags=----- auto ptr_ptr sz=2 use=8 assigned=14 base=005d)
;        591468:_data_47 byte (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0063)
;        591f78:__floop8  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0065)
;        592898:__temp_59  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0066)
;        592ee8:__btemp_21  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        594928:__btemp61  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5a3108:__bitbucket_20  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          593108:__btemp60  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      _print_suniversal_dec --D-- -U- (frame_sz=11 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5b3e68:__device_put_35  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=6 base=0055)
;        5b3f28:_data_73 sdword (type=i dflags=--S-- auto sz=4 use=18 assigned=20 base=005f)
;        5b4108:_digit_divisor_3 sdword (type=i dflags=--S-- auto sz=4 use=4 assigned=12 base=0067)
;        5b41c8:_digit_number_3 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=006b)
;        5b4468:__btemp_23  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5b4538:__btemp64  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5b4c58:__temp_66  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5a33c8:__bitbucket_21  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _print_universal_dec --D-- -U- (frame_sz=14 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5b6278:__device_put_36  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=8 base=006c)
;        5b6338:_data_75 dword (type=i dflags=----- auto sz=4 use=8 assigned=20 base=00a0)
;        5b63f8:_digit_divisor_5 sdword (type=i dflags=--S-- auto sz=4 use=12 assigned=20 base=00a4)
;        5b64b8:_digit_number_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=006e)
;        5b6588:_digit_8 byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=006f)
;        5b6668:_no_digits_printed_yet bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket22+0
;        5b68d8:__btemp_24  (type=i dflags=---B- sz=5 use=0 assigned=0 bit=1) ---> ___bitbucket22+0
;        5b69a8:__btemp65  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> ___bitbucket22+0
;        5b7c38:__btemp66  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> ___bitbucket22+0
;        5b8508:__temp_67  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00a8)
;        5a3268:__bitbucket_22  (type=i dflags=----- auto sz=1 use=4 assigned=8 base=00a9)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5b9858:__btemp67  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket22+0
;          5b9dd8:__btemp68  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> ___bitbucket22+0
;          5ba378:__btemp69  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=5) ---> ___bitbucket22+0
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      tolower ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57fd38:_char_4  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        57ffa8:__btemp_19  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        5269c8:__btemp55  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5805b8:__btemp56  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        580978:__btemp57  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        581238:__temp_56  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5a2bd8:__bitbucket_23  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      toupper ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57d188:_char_2  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        57d398:__btemp_18  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        57d468:__btemp52  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        57da68:__btemp53  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        57de28:__btemp54  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        57e7d8:__temp_55  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5a2678:__bitbucket_24  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      format_time_hm_word ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        570dc8:__device_put_14  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5773a8:_minutes_1  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        577478:_d10_2  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        577518:_hh_4  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5775b8:_mm_4  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        577898:__temp_54  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5a2938:__bitbucket_25  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      format_time_hms ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        571358:__device_put_13  (type=* dflags=C---- sz=2 use=0 assigned=8)
;         = 0
;        571418:_hh_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5714d8:_mm_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        571598:_ss_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        571668:_d10_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        571948:__temp_53  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5a27d8:__bitbucket_26  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      format_time_hm --D-- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        56cce8:__device_put_12  (type=* dflags=C---- sz=2 use=0 assigned=5)
;         = 0
;        56cda8:_hh_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56ce68:_mm_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56cf58:_d10  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56d2e8:__temp_52  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5a2268:__bitbucket_27  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      format_dword_hex ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        569188:__device_put_11  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        569248:_data_32  (type=i dflags=C---- sz=4 use=1 assigned=0)
;         = 0
;        569318:_digit_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5693d8:_b_1  (type=a dflags=----- sz=4 use=0 assigned=0) ---> __data32
;        5699b8:__floop7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56a368:__temp_51  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56bcc8:__btemp_17  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        56bd98:__btemp51  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5a1bf8:__bitbucket_28  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      format_word_hex ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        565448:__device_put_10  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        565508:_data_30  (type=i dflags=C---- sz=2 use=1 assigned=0)
;         = 0
;        5655d8:_digit_6  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        565698:_b  (type=a dflags=----- sz=2 use=0 assigned=0) ---> __data30
;        565c98:__floop6  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        566768:__temp_50  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        568298:__btemp_16  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        568368:__btemp50  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5a1eb8:__bitbucket_29  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      format_byte_hex ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        52d7f8:__device_put_9  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        561d28:_data_28  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        561df8:_digit_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5623f8:__floop5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        562ca8:__temp_49  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        564588:__btemp_15  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        564658:__btemp49  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5a1d58:__bitbucket_30  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      format_sdword_dec ----- --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        55ee48:__device_put_8  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55eed8:_data_26  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        55ef98:_n_tot_11  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55f108:_n2_11  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55f1f8:_sign_4 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=31) ---> __data26
;        55f9e8:__temp_48  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5a17e8:__bitbucket_31  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      format_sword_dec_length ----- --- (frame_sz=0 blocks=9)
;      {block enter}
;        --- records ---
;        --- variables ---
;        553208:__device_put_7  (type=* dflags=C---- sz=2 use=0 assigned=3)
;         = 0
;        5532c8:_data_24  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        553388:_sign_3  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        553448:_len_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        553508:_pos_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5535f8:_data_sign bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=15) ---> __data24
;        553758:_char  (type=i dflags=C---- sz=1 use=6 assigned=0)
;         = 0
;        5538b8:_i  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        554108:__temp_47  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        555bb8:__btemp_14  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        555c88:__btemp46  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        55be38:__btemp47  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5a1288:__bitbucket_32  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          55d6f8:__btemp48  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      format_sword_dec ----- --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        550198:__device_put_6  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        550258:_data_22  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        550318:_n_tot_9  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5503d8:_n2_9  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5504c8:_sign_1 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=15) ---> __data22
;        550cb8:__temp_46  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5a1548:__bitbucket_33  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      format_sbyte_dec ----- --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        54d3f8:__device_put_5  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        54d4b8:_data_20  (type=i dflags=C-S-- sz=1 use=0 assigned=0)
;         = 0
;        54d578:_n_tot_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        54d638:_n2_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        54d728:_sign bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> __data20
;        54e108:__temp_45  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5a13e8:__bitbucket_34  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      format_dword_dec --D-- --- (frame_sz=0 blocks=10)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53bb18:__device_put_4  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53bbd8:_data_18  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        53bc98:_n_tot_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53bd58:_n2_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53bf78:_c1_000_000_000 dword (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 1000000000
;        53c128:_c100_000_000 dword (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 100000000
;        53c298:_c10_000_000 dword (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 10000000
;        53c408:_c1_000_000 dword (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 1000000
;        53c578:_c100_000 dword (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 100000
;        53c6e8:_c10_000 word (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 10000
;        53c838:_c1000_1 word (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 1000
;        53c988:_c100_2 word (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 100
;        53cad8:_c10_2 word (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 10
;        53be48:_digit_4  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53d108:__btemp_13  (type=i dflags=C--B- sz=18 use=0 assigned=0 bit=0)
;         = 0
;        53d1d8:__btemp28  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        53d978:__temp_44  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        53f628:__btemp30  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        540df8:__btemp32  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;        542898:__btemp34  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
;        544378:__btemp36  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=8)
;        545d68:__btemp38  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=10)
;        547898:__btemp40  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=12)
;        549378:__btemp42  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=14)
;        54ad68:__btemp44  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=16)
;        5a0c18:__bitbucket_35  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          53eb08:__btemp29  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          540588:__btemp31  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          541f48:__btemp33  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5439f8:__btemp35  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=7)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5454f8:__btemp37  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=9)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          546f08:__btemp39  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=11)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          548a08:__btemp41  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=13)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          54a4f8:__btemp43  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=15)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          54bf08:__btemp45  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=17)
;          --- labels ---
;        {block exit}
;      {block exit}
;      format_word_dec --D-- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        533108:__device_put_3  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5331c8:_data_16  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        533288:_n_tot_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        533348:_n2_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        533568:_c10000 word (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 10000
;        5336d8:_c1000 word (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 1000
;        533828:_c100_1 word (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 100
;        533978:_c10_1 word (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 10
;        533438:_digit_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        533f98:__btemp_12  (type=i dflags=C--B- sz=8 use=0 assigned=0 bit=0)
;         = 0
;        533a58:__btemp20  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5347a8:__temp_43  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        536228:__btemp22  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        537a98:__btemp24  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;        539538:__btemp26  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
;        5a0408:__bitbucket_36  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          535788:__btemp21  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          537228:__btemp23  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          538bc8:__btemp25  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          53a618:__btemp27  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=7)
;          --- labels ---
;        {block exit}
;      {block exit}
;      format_byte_dec --D-- --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        52dc88:__device_put_2  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        52dd48:_data_14  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52de08:_n_tot_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52dec8:_n2_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52e238:_c100 word (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 100
;        52e3a8:_c10 word (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 10
;        52e108:_digit_2  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52e9c8:__btemp_11  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;         = 0
;        52ea98:__btemp16  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        52f198:__temp_42  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5309a8:__btemp18  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5a0778:__bitbucket_37  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5159f8:__btemp17  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          531b08:__btemp19  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          --- labels ---
;        {block exit}
;      {block exit}
;      _write_digit --D-- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        52b188:__device_put_1  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        52b218:_digit_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52b2d8:_point_1  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        52c378:__btemp_10  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5a0568:__bitbucket_38  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          52c448:__btemp15  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      _write_real_digit --D-- --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5277e8:__device_put  (type=* dflags=C---- sz=2 use=0 assigned=3)
;         = 0
;        5283b8:__btemp_9  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        528488:__btemp14  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        528c38:__temp_41  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        59fe68:__bitbucket_39  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _serial_hw_data_raw_get ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        59fc38:__bitbucket_40  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_raw_put ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5256e8:_data_12  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5958b8:__bitbucket_41  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_get ----- --- (frame_sz=0 blocks=6)
;      {block enter}
;        --- records ---
;        --- variables ---
;        522858:_data_10  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        522b28:__btemp_8  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        522bf8:__btemp12  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5243f8:__btemp13  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        597aa8:__bitbucket_42  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _serial_hw_data_put --DI- FU- (frame_sz=1 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        521e28:_data_9 byte (type=i dflags=----- auto sticky sz=1 use=1 assigned=1 base=0034)
;        597658:__bitbucket_43  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_read ----- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        513958:_data_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        513a18:__btemp_7  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        515c78:__btemp11  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        597218:__bitbucket_44  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      _serial_hw_read ----L --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        51e1f8:_data_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        596468:__bitbucket_45  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      serial_hw_write_word ----- --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        51be48:_data_3  (type=i dflags=C---- sz=2 use=2 assigned=0)
;         = 0
;        51bf08:_dx  (type=a dflags=----- sz=2 use=0 assigned=0) ---> __data3
;        51c278:__btemp_6  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        51c348:__btemp9  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        51d108:__btemp10  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        596258:__bitbucket_46  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      serial_hw_write V-D-- -U- (frame_sz=1 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        51a7b8:_data_1 byte (type=i dflags=----- auto sticky sz=1 use=1 assigned=1 base=0035)
;        51aa48:__btemp_5  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        51ab18:__btemp8  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        595ab8:__bitbucket_47  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      serial_hw_enable ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        581678:__bitbucket_48  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_disable ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        518b68:__btemp_4  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        518c38:__btemp7  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        581318:__bitbucket_49  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      serial_hw_init --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        581108:__bitbucket_50  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _calculate_and_set_baudrate --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        514548:_max_deviation  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 5
;        514478:_usart_div  (type=i dflags=C---U sz=4 use=1 assigned=0)
;         = 10
;        514b48:_real_baud  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 113636
;        580498:__bitbucket_51  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_1s ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        510e88:_n_7  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        511518:__1_s_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 999998
;        511168:__floop4  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        511348:__btemp_3  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        512308:__btemp6  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        57fea8:__bitbucket_52  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      delay_100ms --D-- -U- (frame_sz=4 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        50f3e8:_n_5 word (type=i dflags=----- auto sz=2 use=2 assigned=4 base=0047)
;        50f928:__100_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 99998
;        50f578:__floop3  (type=i dflags=----- auto sz=2 use=4 assigned=4 base=0049)
;        50f758:__btemp_2  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        510308:__btemp5  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        57ec18:__bitbucket_53  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      delay_1ms ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        50d268:_n_3  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50d7a8:__one_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 998
;        50d3f8:__floop2  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50e108:__btemp_1  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        50d5d8:__btemp4  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        57e8b8:__bitbucket_54  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      delay_10us ----- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        507bc8:_n_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        507df8:__btemp  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        507ec8:__btemp1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        508968:__btemp2  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        508f68:__temp_40  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        57e6a8:__bitbucket_55  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          509418:__ten_us_delay1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 7
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          50aa98:__ten_us_delay2  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 5
;          50b5c8:__ten_us_delay3  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 9
;          50a6e8:__floop1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          50bf58:__btemp3  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      delay_9us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57d948:__bitbucket_56  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_8us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57d2c8:__bitbucket_57  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_7us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5789e8:__bitbucket_58  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_6us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        578368:__bitbucket_59  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_5us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        577768:__bitbucket_60  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_4us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5766a8:__bitbucket_61  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_3us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5764e8:__bitbucket_62  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_2us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        576158:__bitbucket_63  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_1us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        575f28:__bitbucket_64  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      enable_digital_io ----L --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        575978:__bitbucket_65  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      comparator_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        575308:__bitbucket_66  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        574ef8:__bitbucket_67  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f5fa8:__temp_39  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        574b68:__bitbucket_68  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f4738:_x_115  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4f4a48:__temp_38  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5749a8:__bitbucket_69  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f38d8:__temp_37  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        574618:__bitbucket_70  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f1f08:_x_113  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4f2108:__temp_36  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        574488:__bitbucket_71  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ef5f8:__temp_35  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        573e48:__bitbucket_72  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4edbf8:_x_111  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4edf08:__temp_34  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5737d8:__bitbucket_73  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ecd08:__temp_33  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5734e8:__bitbucket_74  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4eb268:_x_109  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4eb548:__temp_32  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        573158:__bitbucket_75  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e7fa8:__temp_31  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        572f38:__bitbucket_76  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e6738:_x_107  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4e6a48:__temp_30  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        572aa8:__bitbucket_77  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e58d8:__temp_29  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        572918:__bitbucket_78  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e3f58:_x_105  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4e4108:__temp_28  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        572368:__bitbucket_79  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e1498:__temp_27  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        571818:__bitbucket_80  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4dfbf8:_x_103  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4dff08:__temp_26  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        570518:__bitbucket_81  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ded08:__temp_25  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        570358:__bitbucket_82  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4dd268:_x_101  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4dd548:__temp_24  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        56ff18:__bitbucket_83  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4da538:__temp_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56fd88:__bitbucket_84  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d8af8:_x_99  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4d8e08:__temp_22  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        56f7d8:__bitbucket_85  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d7c68:__temp_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56f168:__bitbucket_86  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d61f8:_x_97  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4d64d8:__temp_20  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        56ee18:__bitbucket_87  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_e0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cccf8:_x_95 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _porte_shadow
;        56ea88:__bitbucket_88  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_e1_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cbb38:_x_93 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _porte_shadow
;        56e8c8:__bitbucket_89  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_e2_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ca998:_x_91 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _porte_shadow
;        56e438:__bitbucket_90  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _porte_high_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c9708:__temp_19  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56e2a8:__bitbucket_91  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c78f8:_x_89  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4c7c38:__temp_18  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        56dbd8:__bitbucket_92  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _porte_low_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c6b08:__temp_17  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56d1b8:__bitbucket_93  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c4ee8:_x_87  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4c5108:__temp_16  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5698c8:__bitbucket_94  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _porte_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c3f58:_x_85  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56b108:__bitbucket_95  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _porte_flush ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        56a8b8:__bitbucket_96  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_d0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c23a8:_x_83 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portd_shadow
;        56a448:__bitbucket_97  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_d1_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c13a8:_x_81 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _portd_shadow
;        56a298:__bitbucket_98  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_d2_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c03a8:_x_79 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _portd_shadow
;        56a158:__bitbucket_99  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_d3_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4bf738:_x_77 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _portd_shadow
;        569a98:__bitbucket_100  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_d4_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4be738:_x_75 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portd_shadow
;        5695e8:__bitbucket_101  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_d5_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4bd738:_x_73 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portd_shadow
;        565ba8:__bitbucket_102  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_d6_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4bc738:_x_71 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portd_shadow
;        5675d8:__bitbucket_103  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_d7_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4bb8b8:_x_69 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portd_shadow
;        566cb8:__bitbucket_104  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portd_high_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ba708:__temp_15  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        566848:__bitbucket_105  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b88f8:_x_67  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4b8c38:__temp_14  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        566698:__bitbucket_106  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portd_low_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b7b08:__temp_13  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        566558:__bitbucket_107  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b5de8:_x_65  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4b6108:__temp_12  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        565d78:__bitbucket_108  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portd_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b4d68:_x_63  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5658c8:__bitbucket_109  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portd_flush ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        562308:__bitbucket_110  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_c0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b3108:_x_61 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portc_shadow+0
;        563a78:__bitbucket_111  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_c1_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b1268:_x_59 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _portc_shadow+0
;        563338:__bitbucket_112  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_c2_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b0e58:_x_57 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _portc_shadow+0
;        562d88:__bitbucket_113  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_c3_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4af268:_x_55 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _portc_shadow+0
;        562b78:__bitbucket_114  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_c4_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4aede8:_x_53 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portc_shadow+0
;        5624d8:__bitbucket_115  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_c5_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4adc18:_x_51 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portc_shadow+0
;        561f88:__bitbucket_116  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_c6_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4acb38:_x_49 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portc_shadow+0
;        560e78:__bitbucket_117  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_c7_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ab998:_x_47 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portc_shadow+0
;        560d18:__bitbucket_118  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portc_high_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4aa708:__temp_11  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        560558:__bitbucket_119  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a88f8:_x_45  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4a8c38:__temp_10  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55f618:__bitbucket_120  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portc_low_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a7b08:__temp_9  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55dc88:__bitbucket_121  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a5e98:_x_43  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4a6108:__temp_8  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55ce68:__bitbucket_122  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portc_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a4f18:_x_41  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55c928:__bitbucket_123  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portc_flush ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        55c5c8:__bitbucket_124  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_b0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a32f8:_x_39 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portb_shadow
;        55bd18:__bitbucket_125  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_b1_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a2268:_x_37 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _portb_shadow
;        55b9b8:__bitbucket_126  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_b2_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a1268:_x_35 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _portb_shadow
;        55b388:__bitbucket_127  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_b3_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a0268:_x_33 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _portb_shadow
;        55acb8:__bitbucket_128  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_b4_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        49f448:_x_31 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portb_shadow
;        55ab88:__bitbucket_129  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_b5_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        49e648:_x_29 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portb_shadow
;        55a678:__bitbucket_130  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_b6_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        49d738:_x_27 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portb_shadow
;        559b68:__bitbucket_131  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_b7_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        49c8b8:_x_25 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portb_shadow
;        559df8:__bitbucket_132  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portb_high_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        49b708:__temp_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        559a38:__bitbucket_133  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4998f8:_x_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        499c38:__temp_6  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        559c98:__bitbucket_134  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portb_low_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        498b08:__temp_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        559528:__bitbucket_135  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        496e98:_x_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        497108:__temp_4  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        558a98:__bitbucket_136  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portb_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        495f18:_x_19  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        558d28:__bitbucket_137  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _portb_flush ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        558968:__bitbucket_138  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_a0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4942f8:_x_17 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _porta_shadow
;        558bc8:__bitbucket_139  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_a1_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        493268:_x_15 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _porta_shadow
;        558458:__bitbucket_140  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_a2_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4921f8:_x_13 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _porta_shadow
;        557a18:__bitbucket_141  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_a3_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        490ec8:_x_11 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _porta_shadow
;        557ca8:__bitbucket_142  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_a4_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        48f268:_x_9 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _porta_shadow
;        5578e8:__bitbucket_143  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_a5_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        48edf8:_x_7 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _porta_shadow
;        557b48:__bitbucket_144  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _porta_high_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        48d9b8:__temp_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5573d8:__bitbucket_145  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        48bc58:_x_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        48bf98:__temp_2  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        556898:__bitbucket_146  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _porta_low_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        48af78:__temp_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        556b28:__bitbucket_147  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        489268:_x_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        489598:__temp  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        556768:__bitbucket_148  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _porta_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        488448:_x_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5569c8:__bitbucket_149  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _porta_flush ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        554a58:__bitbucket_150  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
; --- call stack ---
; {root} (depth=0)
;   print_crlf (depth=1)
;   print_crlf (depth=1)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   print_string (depth=1)
;   print_byte_hex (depth=1)
;   print_string (depth=1)
;   print_byte_dec (depth=1)
;     _print_universal_dec (depth=2)
;   print_string (depth=1)
;   print_crlf (depth=1)
;   print_bit_truefalse (depth=1)
;     print_string (depth=2)
;     print_string (depth=2)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   print_bit_highlow (depth=1)
;     print_string (depth=2)
;     print_string (depth=2)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   print_bit_10 (depth=1)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   print_bit_truefalse (depth=1)
;     print_string (depth=2)
;     print_string (depth=2)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   print_bit_highlow (depth=1)
;     print_string (depth=2)
;     print_string (depth=2)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   print_bit_10 (depth=1)
;   print_string (depth=1)
;   print_crlf (depth=1)
;   print_sdword_dec (depth=1)
;     _print_suniversal_dec (depth=2)
;       _print_universal_dec (depth=3)
;   print_crlf (depth=1)
;   print_dword_binary (depth=1)
;     print_byte_binary (depth=2)
;     print_byte_binary (depth=2)
;     print_byte_binary (depth=2)
;     print_byte_binary (depth=2)
;   print_crlf (depth=1)
;   print_dword_hex (depth=1)
;   print_crlf (depth=1)
;   print_dword_dec (depth=1)
;     _print_universal_dec (depth=2)
;   print_string (depth=1)
;   print_crlf (depth=1)
;   print_sword_dec (depth=1)
;     _print_suniversal_dec (depth=2)
;       _print_universal_dec (depth=3)
;   print_crlf (depth=1)
;   print_word_binary (depth=1)
;     print_byte_binary (depth=2)
;     print_byte_binary (depth=2)
;   print_crlf (depth=1)
;   print_word_hex (depth=1)
;   print_crlf (depth=1)
;   print_word_dec (depth=1)
;     _print_universal_dec (depth=2)
;   print_string (depth=1)
;   print_crlf (depth=1)
;   print_sbyte_dec (depth=1)
;     _print_suniversal_dec (depth=2)
;       _print_universal_dec (depth=3)
;   print_crlf (depth=1)
;   print_byte_binary (depth=1)
;   print_crlf (depth=1)
;   print_byte_hex (depth=1)
;   print_crlf (depth=1)
;   print_byte_dec (depth=1)
;     _print_universal_dec (depth=2)
;   print_string (depth=1)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   delay_100ms (depth=1)
;   delay_100ms (depth=1)
;   serial_hw_init (depth=1)
;     _calculate_and_set_baudrate (depth=2)
;Temporary Labels
;487548:_l1(use=0:ref=2:pc=0000)
;4875a8:_l2(use=0:ref=2:pc=0000)
;488108:_l3(use=0:ref=2:pc=0000)
;488168:_l4(use=0:ref=2:pc=0000)
;488a98:_l5(use=0:ref=1:pc=0000)
;488f98:_l6(use=0:ref=2:pc=0000)
;4884d8:_l7(use=0:ref=2:pc=0000)
;48a688:_l8(use=0:ref=1:pc=0000)
;48aae8:_l9(use=0:ref=2:pc=0000)
;48ab48:_l10(use=0:ref=2:pc=0000)
;48b918:_l11(use=0:ref=2:pc=0000)
;48b978:_l12(use=0:ref=2:pc=0000)
;48ccf8:_l13(use=0:ref=1:pc=0000)
;48d528:_l14(use=0:ref=2:pc=0000)
;48d588:_l15(use=0:ref=2:pc=0000)
;48eab8:_l16(use=0:ref=2:pc=0000)
;48eb18:_l17(use=0:ref=2:pc=0000)
;48f2f8:_l18(use=0:ref=1:pc=0000)
;48fcd8:_l19(use=0:ref=2:pc=0000)
;48fd38:_l20(use=0:ref=2:pc=0000)
;4901a8:_l21(use=0:ref=1:pc=0000)
;490b88:_l22(use=0:ref=2:pc=0000)
;490be8:_l23(use=0:ref=2:pc=0000)
;491368:_l24(use=0:ref=1:pc=0000)
;491e28:_l25(use=0:ref=2:pc=0000)
;491e88:_l26(use=0:ref=2:pc=0000)
;4925e8:_l27(use=0:ref=1:pc=0000)
;492ee8:_l28(use=0:ref=2:pc=0000)
;492f48:_l29(use=0:ref=2:pc=0000)
;493658:_l30(use=0:ref=1:pc=0000)
;493f58:_l31(use=0:ref=2:pc=0000)
;493fb8:_l32(use=0:ref=2:pc=0000)
;4946e8:_l33(use=0:ref=1:pc=0000)
;494668:_l34(use=0:ref=2:pc=0000)
;494a78:_l35(use=0:ref=2:pc=0000)
;495bd8:_l36(use=0:ref=2:pc=0000)
;495c38:_l37(use=0:ref=2:pc=0000)
;496658:_l38(use=0:ref=1:pc=0000)
;496b58:_l39(use=0:ref=2:pc=0000)
;496bb8:_l40(use=0:ref=2:pc=0000)
;498218:_l41(use=0:ref=1:pc=0000)
;498678:_l42(use=0:ref=2:pc=0000)
;4986d8:_l43(use=0:ref=2:pc=0000)
;4995b8:_l44(use=0:ref=2:pc=0000)
;499618:_l45(use=0:ref=2:pc=0000)
;49ade8:_l46(use=0:ref=1:pc=0000)
;49b278:_l47(use=0:ref=2:pc=0000)
;49b2d8:_l48(use=0:ref=2:pc=0000)
;49c578:_l49(use=0:ref=2:pc=0000)
;49c5d8:_l50(use=0:ref=2:pc=0000)
;49cca8:_l51(use=0:ref=1:pc=0000)
;49d3f8:_l52(use=0:ref=2:pc=0000)
;49d458:_l53(use=0:ref=2:pc=0000)
;49db28:_l54(use=0:ref=1:pc=0000)
;49e308:_l55(use=0:ref=2:pc=0000)
;49e368:_l56(use=0:ref=2:pc=0000)
;49ea38:_l57(use=0:ref=1:pc=0000)
;49f108:_l58(use=0:ref=2:pc=0000)
;49f168:_l59(use=0:ref=2:pc=0000)
;49f838:_l60(use=0:ref=1:pc=0000)
;49ff98:_l61(use=0:ref=2:pc=0000)
;460da8:_l62(use=0:ref=2:pc=0000)
;4a0658:_l63(use=0:ref=1:pc=0000)
;4a0e78:_l64(use=0:ref=2:pc=0000)
;4a0ed8:_l65(use=0:ref=2:pc=0000)
;4a1658:_l66(use=0:ref=1:pc=0000)
;4a1e78:_l67(use=0:ref=2:pc=0000)
;4a1ed8:_l68(use=0:ref=2:pc=0000)
;4a2658:_l69(use=0:ref=1:pc=0000)
;4a2f58:_l70(use=0:ref=2:pc=0000)
;4a2fb8:_l71(use=0:ref=2:pc=0000)
;4a36e8:_l72(use=0:ref=1:pc=0000)
;4a33f8:_l73(use=0:ref=2:pc=0000)
;4a3668:_l74(use=0:ref=2:pc=0000)
;4a4bd8:_l75(use=0:ref=2:pc=0000)
;4a4c38:_l76(use=0:ref=2:pc=0000)
;4a5658:_l77(use=0:ref=1:pc=0000)
;4a5b58:_l78(use=0:ref=2:pc=0000)
;4a5bb8:_l79(use=0:ref=2:pc=0000)
;4a7218:_l80(use=0:ref=1:pc=0000)
;4a7678:_l81(use=0:ref=2:pc=0000)
;4a76d8:_l82(use=0:ref=2:pc=0000)
;4a85b8:_l83(use=0:ref=2:pc=0000)
;4a8618:_l84(use=0:ref=2:pc=0000)
;4a9de8:_l85(use=0:ref=1:pc=0000)
;4aa278:_l86(use=0:ref=2:pc=0000)
;4aa2d8:_l87(use=0:ref=2:pc=0000)
;4ab658:_l88(use=0:ref=2:pc=0000)
;4ab6b8:_l89(use=0:ref=2:pc=0000)
;4abd88:_l90(use=0:ref=1:pc=0000)
;4ac7f8:_l91(use=0:ref=2:pc=0000)
;4ac858:_l92(use=0:ref=2:pc=0000)
;4acf28:_l93(use=0:ref=1:pc=0000)
;4ad8d8:_l94(use=0:ref=2:pc=0000)
;4ad938:_l95(use=0:ref=2:pc=0000)
;4ad368:_l96(use=0:ref=1:pc=0000)
;4aeaa8:_l97(use=0:ref=2:pc=0000)
;4aeb08:_l98(use=0:ref=2:pc=0000)
;4af2f8:_l99(use=0:ref=1:pc=0000)
;4afcd8:_l100(use=0:ref=2:pc=0000)
;4afd38:_l101(use=0:ref=2:pc=0000)
;4b0218:_l102(use=0:ref=1:pc=0000)
;4b0b18:_l103(use=0:ref=2:pc=0000)
;4b0b78:_l104(use=0:ref=2:pc=0000)
;4b12f8:_l105(use=0:ref=1:pc=0000)
;4b1cd8:_l106(use=0:ref=2:pc=0000)
;4b1d38:_l107(use=0:ref=2:pc=0000)
;4b2368:_l108(use=0:ref=1:pc=0000)
;4b2d48:_l109(use=0:ref=2:pc=0000)
;4b2da8:_l110(use=0:ref=2:pc=0000)
;4b34f8:_l111(use=0:ref=1:pc=0000)
;4b3e28:_l112(use=0:ref=2:pc=0000)
;4b3e88:_l113(use=0:ref=2:pc=0000)
;4b4a28:_l114(use=0:ref=2:pc=0000)
;4b4a88:_l115(use=0:ref=2:pc=0000)
;4b55a8:_l116(use=0:ref=1:pc=0000)
;4b5aa8:_l117(use=0:ref=2:pc=0000)
;4b5b08:_l118(use=0:ref=2:pc=0000)
;4b7218:_l119(use=0:ref=1:pc=0000)
;4b7678:_l120(use=0:ref=2:pc=0000)
;4b76d8:_l121(use=0:ref=2:pc=0000)
;4b85b8:_l122(use=0:ref=2:pc=0000)
;4b8618:_l123(use=0:ref=2:pc=0000)
;4b9de8:_l124(use=0:ref=1:pc=0000)
;4ba278:_l125(use=0:ref=2:pc=0000)
;4ba2d8:_l126(use=0:ref=2:pc=0000)
;4bb578:_l127(use=0:ref=2:pc=0000)
;4bb5d8:_l128(use=0:ref=2:pc=0000)
;4bbca8:_l129(use=0:ref=1:pc=0000)
;4bc3f8:_l130(use=0:ref=2:pc=0000)
;4bc458:_l131(use=0:ref=2:pc=0000)
;4bcb28:_l132(use=0:ref=1:pc=0000)
;4bd3f8:_l133(use=0:ref=2:pc=0000)
;4bd458:_l134(use=0:ref=2:pc=0000)
;4bdb28:_l135(use=0:ref=1:pc=0000)
;4be3f8:_l136(use=0:ref=2:pc=0000)
;4be458:_l137(use=0:ref=2:pc=0000)
;4beb28:_l138(use=0:ref=1:pc=0000)
;4bf3f8:_l139(use=0:ref=2:pc=0000)
;4bf458:_l140(use=0:ref=2:pc=0000)
;4bfb28:_l141(use=0:ref=1:pc=0000)
;4b8fb8:_l142(use=0:ref=2:pc=0000)
;4b84e8:_l143(use=0:ref=2:pc=0000)
;4c0798:_l144(use=0:ref=1:pc=0000)
;4c0718:_l145(use=0:ref=2:pc=0000)
;4c0b28:_l146(use=0:ref=2:pc=0000)
;4c1798:_l147(use=0:ref=1:pc=0000)
;4c1718:_l148(use=0:ref=2:pc=0000)
;4c1b28:_l149(use=0:ref=2:pc=0000)
;4c2798:_l150(use=0:ref=1:pc=0000)
;4c2b28:_l151(use=0:ref=2:pc=0000)
;4c3108:_l152(use=0:ref=2:pc=0000)
;4c3c18:_l153(use=0:ref=2:pc=0000)
;4c3c78:_l154(use=0:ref=2:pc=0000)
;4c46a8:_l155(use=0:ref=1:pc=0000)
;4c4ba8:_l156(use=0:ref=2:pc=0000)
;4c4c08:_l157(use=0:ref=2:pc=0000)
;4c6218:_l158(use=0:ref=1:pc=0000)
;4c6678:_l159(use=0:ref=2:pc=0000)
;4c66d8:_l160(use=0:ref=2:pc=0000)
;4c75b8:_l161(use=0:ref=2:pc=0000)
;4c7618:_l162(use=0:ref=2:pc=0000)
;4c8de8:_l163(use=0:ref=1:pc=0000)
;4c9278:_l164(use=0:ref=2:pc=0000)
;4c92d8:_l165(use=0:ref=2:pc=0000)
;4ca658:_l166(use=0:ref=2:pc=0000)
;4ca6b8:_l167(use=0:ref=2:pc=0000)
;4cad88:_l168(use=0:ref=1:pc=0000)
;4cb7f8:_l169(use=0:ref=2:pc=0000)
;4cb858:_l170(use=0:ref=2:pc=0000)
;4cbf28:_l171(use=0:ref=1:pc=0000)
;4cc9b8:_l172(use=0:ref=2:pc=0000)
;4cca18:_l173(use=0:ref=2:pc=0000)
;4cd218:_l174(use=0:ref=1:pc=0000)
;4d5d98:_l175(use=0:ref=2:pc=0000)
;4d5df8:_l176(use=0:ref=2:pc=0000)
;4d77d8:_l177(use=0:ref=2:pc=0000)
;4d7838:_l178(use=0:ref=2:pc=0000)
;4d87b8:_l179(use=0:ref=2:pc=0000)
;4d8818:_l180(use=0:ref=2:pc=0000)
;4d9f78:_l181(use=0:ref=2:pc=0000)
;4da108:_l182(use=0:ref=2:pc=0000)
;4dce68:_l183(use=0:ref=2:pc=0000)
;4dcec8:_l184(use=0:ref=2:pc=0000)
;4de878:_l185(use=0:ref=2:pc=0000)
;4de8d8:_l186(use=0:ref=2:pc=0000)
;4df8b8:_l187(use=0:ref=2:pc=0000)
;4df918:_l188(use=0:ref=2:pc=0000)
;4e0f08:_l189(use=0:ref=2:pc=0000)
;4e0f68:_l190(use=0:ref=2:pc=0000)
;4e3c18:_l191(use=0:ref=2:pc=0000)
;4e3c78:_l192(use=0:ref=2:pc=0000)
;4e5448:_l193(use=0:ref=2:pc=0000)
;4e54a8:_l194(use=0:ref=2:pc=0000)
;4e63f8:_l195(use=0:ref=2:pc=0000)
;4e6458:_l196(use=0:ref=2:pc=0000)
;4e7b18:_l197(use=0:ref=2:pc=0000)
;4e7b78:_l198(use=0:ref=2:pc=0000)
;4eaf78:_l199(use=0:ref=2:pc=0000)
;4ea168:_l200(use=0:ref=2:pc=0000)
;4ec878:_l201(use=0:ref=2:pc=0000)
;4ec8d8:_l202(use=0:ref=2:pc=0000)
;4ed8b8:_l203(use=0:ref=2:pc=0000)
;4ed918:_l204(use=0:ref=2:pc=0000)
;4ef168:_l205(use=0:ref=2:pc=0000)
;4ef1c8:_l206(use=0:ref=2:pc=0000)
;4f1bc8:_l207(use=0:ref=2:pc=0000)
;4f1c28:_l208(use=0:ref=2:pc=0000)
;4f3448:_l209(use=0:ref=2:pc=0000)
;4f34a8:_l210(use=0:ref=2:pc=0000)
;4f43f8:_l211(use=0:ref=2:pc=0000)
;4f4458:_l212(use=0:ref=2:pc=0000)
;4f5b18:_l213(use=0:ref=2:pc=0000)
;4f5b78:_l214(use=0:ref=2:pc=0000)
;4fe208:_l215(use=0:ref=2:pc=0000)
;4fe4b8:_l216(use=0:ref=2:pc=0000)
;4ffef8:_l217(use=0:ref=2:pc=0000)
;4fff58:_l218(use=0:ref=2:pc=0000)
;500a68:_l219(use=0:ref=2:pc=0000)
;500ac8:_l220(use=0:ref=2:pc=0000)
;5012f8:_l221(use=0:ref=1:pc=0000)
;501748:_l222(use=0:ref=1:pc=0000)
;502ab8:_l223(use=0:ref=2:pc=0000)
;502b18:_l224(use=0:ref=2:pc=0000)
;503408:_l225(use=0:ref=2:pc=0000)
;503468:_l226(use=0:ref=2:pc=0000)
;503ba8:_l227(use=0:ref=2:pc=0000)
;503c08:_l228(use=0:ref=2:pc=0000)
;504488:_l229(use=0:ref=2:pc=0000)
;5044e8:_l230(use=0:ref=2:pc=0000)
;504c28:_l231(use=0:ref=2:pc=0000)
;504c88:_l232(use=0:ref=2:pc=0000)
;5054f8:_l233(use=0:ref=2:pc=0000)
;505558:_l234(use=0:ref=2:pc=0000)
;505c98:_l235(use=0:ref=2:pc=0000)
;505cf8:_l236(use=0:ref=2:pc=0000)
;5064f8:_l237(use=0:ref=2:pc=0000)
;506558:_l238(use=0:ref=2:pc=0000)
;506c98:_l239(use=0:ref=2:pc=0000)
;506cf8:_l240(use=0:ref=2:pc=0000)
;507888:_l241(use=0:ref=2:pc=0000)
;5078e8:_l242(use=0:ref=2:pc=0000)
;507c78:_l243(use=0:ref=1:pc=0000)
;508428:_l244(use=0:ref=1:pc=0000)
;508cd8:_l245(use=0:ref=1:pc=0000)
;509608:_l246(use=0:ref=1:pc=0000)
;5097c8:_l247(use=0:ref=1:pc=0000)
;50ac88:_l248(use=0:ref=1:pc=0000)
;50ae48:_l249(use=0:ref=1:pc=0000)
;50bb28:_l250(use=0:ref=1:pc=0000)
;50bb88:_l251(use=0:ref=1:pc=0000)
;50bbe8:_l252(use=0:ref=1:pc=0000)
;50bdd8:_l253(use=0:ref=1:pc=0000)
;50b388:_l254(use=0:ref=1:pc=0000)
;50cea8:_l255(use=0:ref=2:pc=0000)
;50cf08:_l256(use=0:ref=2:pc=0000)
;50dd08:_l257(use=0:ref=1:pc=0000)
;50dd68:_l258(use=0:ref=1:pc=0000)
;50ddc8:_l259(use=0:ref=1:pc=0000)
;50dfb8:_l260(use=0:ref=1:pc=0000)
;50e208:_l261(use=0:ref=1:pc=0000)
;50e248:_l262(use=0:ref=2:pc=0000)
;50f108:_l263(use=0:ref=2:pc=0000)
;50fe88:_l264(use=7:ref=3:pc=015e)
;50fee8:_l265(use=7:ref=3:pc=0176)
;50ff48:_l266(use=0:ref=1:pc=0000)
;510b48:_l267(use=7:ref=4:pc=017f)
;510ba8:_l268(use=0:ref=2:pc=0000)
;511a78:_l269(use=0:ref=1:pc=0000)
;511ad8:_l270(use=0:ref=1:pc=0000)
;511b38:_l271(use=0:ref=1:pc=0000)
;512f18:_l272(use=0:ref=1:pc=0000)
;513398:_l273(use=0:ref=1:pc=0000)
;513548:_l274(use=0:ref=1:pc=0000)
;513af8:_l275(use=0:ref=1:pc=0000)
;513d78:_l276(use=0:ref=1:pc=0000)
;514168:_l277(use=0:ref=2:pc=0000)
;5141c8:_l278(use=0:ref=2:pc=0000)
;514608:_l279(use=0:ref=1:pc=0000)
;5146b8:_l280(use=0:ref=1:pc=0000)
;514718:_l281(use=0:ref=1:pc=0000)
;514c78:_l282(use=0:ref=1:pc=0000)
;5155b8:_l283(use=0:ref=1:pc=0000)
;515748:_l284(use=0:ref=1:pc=0000)
;5157a8:_l285(use=0:ref=1:pc=0000)
;515998:_l286(use=0:ref=1:pc=0000)
;515428:_l287(use=0:ref=1:pc=0000)
;5158b8:_l288(use=0:ref=1:pc=0000)
;517128:_l289(use=0:ref=2:pc=0000)
;517188:_l290(use=0:ref=2:pc=0000)
;518698:_l291(use=0:ref=2:pc=0000)
;5186f8:_l292(use=0:ref=2:pc=0000)
;518998:_l293(use=0:ref=1:pc=0000)
;5189f8:_l294(use=0:ref=1:pc=0000)
;518a58:_l295(use=0:ref=1:pc=0000)
;5199f8:_l296(use=0:ref=2:pc=0000)
;519a58:_l297(use=0:ref=2:pc=0000)
;51a478:_l298(use=0:ref=2:pc=0000)
;51a4d8:_l299(use=0:ref=2:pc=0000)
;51a868:_l300(use=7:ref=3:pc=0194)
;51a8c8:_l301(use=7:ref=3:pc=0196)
;51a928:_l302(use=0:ref=1:pc=0000)
;51bb08:_l303(use=0:ref=2:pc=0000)
;51bb68:_l304(use=0:ref=2:pc=0000)
;51bf68:_l305(use=0:ref=1:pc=0000)
;51c128:_l306(use=0:ref=1:pc=0000)
;51c188:_l307(use=0:ref=1:pc=0000)
;51ce18:_l308(use=0:ref=1:pc=0000)
;51ce78:_l309(use=0:ref=1:pc=0000)
;51ced8:_l310(use=0:ref=1:pc=0000)
;51ddb8:_l311(use=0:ref=2:pc=0000)
;51de18:_l312(use=0:ref=2:pc=0000)
;51e2a8:_l313(use=0:ref=1:pc=0000)
;51e368:_l314(use=0:ref=1:pc=0000)
;51f198:_l315(use=0:ref=1:pc=0000)
;51f278:_l316(use=0:ref=1:pc=0000)
;51f6f8:_l317(use=0:ref=2:pc=0000)
;461738:_l318(use=0:ref=2:pc=0000)
;520648:_l319(use=0:ref=1:pc=0000)
;520988:_l320(use=0:ref=1:pc=0000)
;520e88:_l321(use=0:ref=1:pc=0000)
;520f58:_l322(use=0:ref=1:pc=0000)
;5212e8:_l323(use=0:ref=1:pc=0000)
;521ae8:_l324(use=0:ref=2:pc=0000)
;521b48:_l325(use=0:ref=2:pc=0000)
;522538:_l326(use=0:ref=2:pc=0000)
;522598:_l327(use=0:ref=2:pc=0000)
;522908:_l328(use=0:ref=1:pc=0000)
;522968:_l329(use=0:ref=1:pc=0000)
;5229c8:_l330(use=0:ref=1:pc=0000)
;523448:_l331(use=0:ref=1:pc=0000)
;523788:_l332(use=0:ref=1:pc=0000)
;523c88:_l333(use=0:ref=1:pc=0000)
;523d58:_l334(use=0:ref=1:pc=0000)
;524108:_l335(use=0:ref=1:pc=0000)
;5253a8:_l336(use=0:ref=2:pc=0000)
;525408:_l337(use=0:ref=2:pc=0000)
;525da8:_l338(use=7:ref=4:pc=019e)
;525e08:_l339(use=0:ref=2:pc=0000)
;527488:_l340(use=0:ref=2:pc=0000)
;5274e8:_l341(use=0:ref=2:pc=0000)
;527898:_l342(use=0:ref=1:pc=0000)
;527978:_l343(use=0:ref=1:pc=0000)
;528208:_l344(use=0:ref=1:pc=0000)
;5288f8:_l345(use=0:ref=1:pc=0000)
;52ace8:_l346(use=0:ref=2:pc=0000)
;52ad48:_l347(use=0:ref=2:pc=0000)
;52b7d8:_l348(use=0:ref=1:pc=0000)
;52b868:_l349(use=0:ref=1:pc=0000)
;52c198:_l350(use=0:ref=1:pc=0000)
;52c7b8:_l351(use=0:ref=1:pc=0000)
;52d938:_l352(use=0:ref=2:pc=0000)
;52d998:_l353(use=0:ref=2:pc=0000)
;52e838:_l354(use=0:ref=1:pc=0000)
;52ef08:_l355(use=0:ref=1:pc=0000)
;5307c8:_l356(use=0:ref=1:pc=0000)
;530d18:_l357(use=0:ref=1:pc=0000)
;532ca8:_l358(use=0:ref=2:pc=0000)
;532d08:_l359(use=0:ref=2:pc=0000)
;533e08:_l360(use=0:ref=1:pc=0000)
;534498:_l361(use=0:ref=1:pc=0000)
;535f98:_l362(use=0:ref=1:pc=0000)
;536598:_l363(use=0:ref=1:pc=0000)
;5378b8:_l364(use=0:ref=1:pc=0000)
;537e08:_l365(use=0:ref=1:pc=0000)
;539358:_l366(use=0:ref=1:pc=0000)
;5398a8:_l367(use=0:ref=1:pc=0000)
;53b7c8:_l368(use=0:ref=2:pc=0000)
;53b828:_l369(use=0:ref=2:pc=0000)
;53cf68:_l370(use=0:ref=1:pc=0000)
;53d648:_l371(use=0:ref=1:pc=0000)
;53f448:_l372(use=0:ref=1:pc=0000)
;53f998:_l373(use=0:ref=1:pc=0000)
;540c18:_l374(use=0:ref=1:pc=0000)
;541328:_l375(use=0:ref=1:pc=0000)
;5426b8:_l376(use=0:ref=1:pc=0000)
;542c08:_l377(use=0:ref=1:pc=0000)
;544198:_l378(use=0:ref=1:pc=0000)
;5446e8:_l379(use=0:ref=1:pc=0000)
;545b88:_l380(use=0:ref=1:pc=0000)
;546228:_l381(use=0:ref=1:pc=0000)
;5476b8:_l382(use=0:ref=1:pc=0000)
;547c08:_l383(use=0:ref=1:pc=0000)
;549198:_l384(use=0:ref=1:pc=0000)
;5496e8:_l385(use=0:ref=1:pc=0000)
;54ab88:_l386(use=0:ref=1:pc=0000)
;54b228:_l387(use=0:ref=1:pc=0000)
;54c8c8:_l388(use=0:ref=2:pc=0000)
;54d108:_l389(use=0:ref=2:pc=0000)
;54d878:_l390(use=0:ref=1:pc=0000)
;54d908:_l391(use=0:ref=1:pc=0000)
;54f178:_l392(use=0:ref=2:pc=0000)
;54f288:_l393(use=0:ref=2:pc=0000)
;5505f8:_l394(use=0:ref=1:pc=0000)
;550688:_l395(use=0:ref=1:pc=0000)
;552d88:_l396(use=0:ref=2:pc=0000)
;552de8:_l397(use=0:ref=2:pc=0000)
;553968:_l398(use=0:ref=1:pc=0000)
;5539f8:_l399(use=0:ref=1:pc=0000)
;553b78:_l400(use=0:ref=1:pc=0000)
;553c38:_l401(use=0:ref=1:pc=0000)
;554fb8:_l402(use=0:ref=1:pc=0000)
;555168:_l403(use=0:ref=1:pc=0000)
;555a28:_l404(use=0:ref=1:pc=0000)
;556228:_l405(use=0:ref=1:pc=0000)
;55b768:_l406(use=0:ref=1:pc=0000)
;55b7c8:_l407(use=0:ref=1:pc=0000)
;55b828:_l408(use=0:ref=1:pc=0000)
;55d548:_l409(use=0:ref=1:pc=0000)
;55da68:_l410(use=0:ref=1:pc=0000)
;55eb58:_l411(use=0:ref=2:pc=0000)
;55ebb8:_l412(use=0:ref=2:pc=0000)
;55f328:_l413(use=0:ref=1:pc=0000)
;55f3b8:_l414(use=0:ref=1:pc=0000)
;5619e8:_l415(use=0:ref=2:pc=0000)
;561a48:_l416(use=0:ref=2:pc=0000)
;562838:_l417(use=0:ref=1:pc=0000)
;562898:_l418(use=0:ref=1:pc=0000)
;5628f8:_l419(use=0:ref=1:pc=0000)
;565108:_l420(use=0:ref=2:pc=0000)
;565168:_l421(use=0:ref=2:pc=0000)
;566228:_l422(use=0:ref=1:pc=0000)
;566288:_l423(use=0:ref=1:pc=0000)
;5662e8:_l424(use=0:ref=1:pc=0000)
;568d38:_l425(use=0:ref=2:pc=0000)
;568d98:_l426(use=0:ref=2:pc=0000)
;569df8:_l427(use=0:ref=1:pc=0000)
;569e58:_l428(use=0:ref=1:pc=0000)
;569eb8:_l429(use=0:ref=1:pc=0000)
;56c9a8:_l430(use=0:ref=2:pc=0000)
;56ca08:_l431(use=0:ref=2:pc=0000)
;570f08:_l432(use=0:ref=2:pc=0000)
;570f68:_l433(use=0:ref=2:pc=0000)
;576f28:_l434(use=0:ref=2:pc=0000)
;576f88:_l435(use=0:ref=2:pc=0000)
;579698:_l436(use=0:ref=1:pc=0000)
;57cd48:_l437(use=0:ref=2:pc=0000)
;57cda8:_l438(use=0:ref=2:pc=0000)
;57d238:_l439(use=0:ref=1:pc=0000)
;57e428:_l440(use=0:ref=1:pc=0000)
;57f9f8:_l441(use=0:ref=2:pc=0000)
;57fa58:_l442(use=0:ref=2:pc=0000)
;57fde8:_l443(use=0:ref=1:pc=0000)
;580de8:_l444(use=0:ref=1:pc=0000)
;582838:_l445(use=7:ref=4:pc=058e)
;582898:_l446(use=6:ref=4:pc=058d)
;582e28:_l447(use=0:ref=2:pc=0000)
;582e88:_l448(use=0:ref=2:pc=0000)
;583278:_l449(use=0:ref=2:pc=0000)
;5832d8:_l450(use=0:ref=2:pc=0000)
;5848a8:_l451(use=0:ref=2:pc=0000)
;584908:_l452(use=0:ref=2:pc=0000)
;585558:_l453(use=0:ref=2:pc=0000)
;5855b8:_l454(use=0:ref=2:pc=0000)
;585f88:_l455(use=7:ref=3:pc=01b5)
;586108:_l456(use=7:ref=3:pc=01d0)
;586168:_l457(use=6:ref=3:pc=01d7)
;586358:_l458(use=0:ref=1:pc=0000)
;586958:_l459(use=7:ref=3:pc=01be)
;587cd8:_l460(use=0:ref=2:pc=0000)
;587d38:_l461(use=0:ref=2:pc=0000)
;588b68:_l462(use=6:ref=3:pc=01f4)
;588c08:_l463(use=7:ref=3:pc=01e7)
;589c48:_l464(use=0:ref=2:pc=0000)
;589ca8:_l465(use=0:ref=2:pc=0000)
;58a7a8:_l466(use=6:ref=3:pc=0210)
;58a848:_l467(use=7:ref=3:pc=0203)
;58b868:_l468(use=0:ref=2:pc=0000)
;58b8c8:_l469(use=0:ref=2:pc=0000)
;58bce8:_l470(use=6:ref=3:pc=021e)
;58bdb8:_l471(use=7:ref=3:pc=0218)
;58ccb8:_l472(use=0:ref=2:pc=0000)
;58cd18:_l473(use=0:ref=2:pc=0000)
;58d2a8:_l474(use=0:ref=1:pc=0000)
;58d398:_l475(use=7:ref=3:pc=022d)
;58fa48:_l476(use=0:ref=2:pc=0000)
;58faa8:_l477(use=0:ref=2:pc=0000)
;58ff28:_l478(use=0:ref=1:pc=0000)
;58ff68:_l479(use=7:ref=3:pc=0270)
;591548:_l480(use=0:ref=1:pc=0000)
;591638:_l481(use=7:ref=3:pc=0293)
;592468:_l482(use=7:ref=3:pc=0295)
;5924c8:_l483(use=0:ref=1:pc=0000)
;592528:_l484(use=0:ref=1:pc=0000)
;5926a8:_l485(use=7:ref=3:pc=02a8)
;593588:_l486(use=7:ref=3:pc=02a2)
;5953d8:_l487(use=0:ref=2:pc=0000)
;595438:_l488(use=0:ref=2:pc=0000)
;595e18:_l489(use=0:ref=1:pc=0000)
;595e78:_l490(use=0:ref=1:pc=0000)
;595ed8:_l491(use=0:ref=1:pc=0000)
;596198:_l492(use=0:ref=1:pc=0000)
;596f28:_l493(use=0:ref=1:pc=0000)
;598da8:_l494(use=0:ref=2:pc=0000)
;598e08:_l495(use=0:ref=2:pc=0000)
;599398:_l496(use=0:ref=1:pc=0000)
;599488:_l497(use=7:ref=3:pc=02c0)
;59f4d8:_l498(use=0:ref=2:pc=0000)
;59f538:_l499(use=0:ref=2:pc=0000)
;59f988:_l500(use=0:ref=1:pc=0000)
;59fa78:_l501(use=0:ref=1:pc=0000)
;5a5998:_l502(use=0:ref=2:pc=0000)
;5a59f8:_l503(use=0:ref=2:pc=0000)
;5a5e48:_l504(use=0:ref=1:pc=0000)
;5a5f38:_l505(use=7:ref=3:pc=039d)
;5a9708:_l506(use=0:ref=2:pc=0000)
;5a9768:_l507(use=0:ref=2:pc=0000)
;5a9bb8:_l508(use=0:ref=1:pc=0000)
;5a9ca8:_l509(use=7:ref=3:pc=03fc)
;5abf48:_l510(use=0:ref=2:pc=0000)
;5abfa8:_l511(use=0:ref=2:pc=0000)
;5acec8:_l512(use=0:ref=2:pc=0000)
;5acf28:_l513(use=0:ref=2:pc=0000)
;5ade58:_l514(use=0:ref=2:pc=0000)
;5adeb8:_l515(use=0:ref=2:pc=0000)
;5aff08:_l516(use=0:ref=2:pc=0000)
;5aff68:_l517(use=0:ref=2:pc=0000)
;5b0d48:_l518(use=0:ref=2:pc=0000)
;5b0da8:_l519(use=0:ref=2:pc=0000)
;5b1cd8:_l520(use=0:ref=2:pc=0000)
;5b1d38:_l521(use=0:ref=2:pc=0000)
;5b2c58:_l522(use=0:ref=2:pc=0000)
;5b2cb8:_l523(use=0:ref=2:pc=0000)
;5b42a8:_l524(use=0:ref=1:pc=0000)
;5b49b8:_l525(use=13:ref=3:pc=04c3)
;5b6718:_l526(use=0:ref=1:pc=0000)
;5b6e28:_l527(use=7:ref=3:pc=04fa)
;5b7938:_l528(use=7:ref=3:pc=04fb)
;5b7998:_l529(use=13:ref=3:pc=058d)
;5b79f8:_l530(use=0:ref=1:pc=0000)
;5b96a8:_l531(use=0:ref=1:pc=0000)
;5ba7f8:_l532(use=7:ref=3:pc=058a)
;5bc588:_l533(use=7:ref=3:pc=0590)
;5bc5e8:_l534(use=0:ref=1:pc=0000)
;5bc748:_l535(use=0:ref=1:pc=0000)
;5bd278:_l536(use=0:ref=1:pc=0000)
;5bdc98:_l537(use=0:ref=1:pc=0000)
;5bde48:_l538(use=0:ref=1:pc=0000)
;5ef728:_l539(use=3:ref=1:pc=0016)
;5ef788:_l540(use=3:ref=1:pc=0018)
;5ef7e8:_l541(use=3:ref=1:pc=001a)
;6144c8:_l542(use=3:ref=1:pc=03fb)
;618d48:_l543(use=3:ref=1:pc=047d)
;61dbc8:_l544(use=3:ref=1:pc=0509)
;625f48:_l545(use=3:ref=1:pc=05ef)
;6384a8:_l546(use=9:ref=1:pc=0806)
;639a68:_l547(use=0:ref=1:pc=080e)
;63f588:_l548(use=9:ref=1:pc=08c8)
;640ae8:_l549(use=0:ref=1:pc=08d0)
;646c28:_l550(use=0:ref=1:pc=0980)
;646c88:_l551(use=0:ref=1:pc=0000)
;67a288:_l552(use=3:ref=1:pc=0000)
;67a2e8:_l553(use=3:ref=1:pc=0000)
;67a348:_l554(use=3:ref=1:pc=0000)
;67a3a8:_l555(use=3:ref=1:pc=0000)
;67bae8:_l556(use=3:ref=1:pc=0000)
;67d3a8:_l557(use=3:ref=1:pc=0000)
;67f6a8:_l558(use=9:ref=1:pc=0000)
;68a608:_l559(use=3:ref=1:pc=010a)
;68a668:_l560(use=3:ref=1:pc=0139)
;68a6c8:_l561(use=3:ref=1:pc=012a)
;68a728:_l562(use=3:ref=1:pc=00f1)
;68a8a8:_l563(use=3:ref=1:pc=0101)
;68aa28:_l564(use=3:ref=1:pc=0104)
;68aae8:_l565(use=9:ref=1:pc=0126)
;68aba8:_l566(use=3:ref=1:pc=0162)
;68ac08:_l567(use=3:ref=1:pc=0164)
;68ac68:_l568(use=3:ref=1:pc=0166)
;68c308:_l569(use=3:ref=1:pc=02f6)
;68c548:_l570(use=3:ref=1:pc=032c)
;68c788:_l571(use=3:ref=1:pc=0366)
;68cca8:_l572(use=3:ref=1:pc=03ca)
;68d9e8:_l573(use=9:ref=1:pc=04ae)
;68dc48:_l574(use=0:ref=1:pc=04b2)
;68de28:_l575(use=9:ref=1:pc=050f)
;68e188:_l576(use=0:ref=1:pc=0513)
;68e248:_l577(use=0:ref=1:pc=057a)
;68e2a8:_l578(use=0:ref=1:pc=0000)
;Unnamed Constant Variables
;============
