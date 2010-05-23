; compiler: jal 2.4n-beta (compiled May 21 2010)

; command line:  C:\jallib\compiler\jalv2n.exe jallib.jal -pcode -debug -Wall -Wno-directives -long-start -s "c:\jallib\include;c:\jallib\include\device;c:\jallib\include\external;c:\jallib\include\external\adc;c:\jallib\include\external\can;c:\jallib\include\external\co2;c:\jallib\include\external\humidity;c:\jallib\include\external\keyboard;c:\jallib\include\external\lcd;c:\jallib\include\external\media;c:\jallib\include\external\motor;c:\jallib\include\external\motor\dc;c:\jallib\include\external\motor\period_skip;c:\jallib\include\external\motor\servo;c:\jallib\include\external\motor\stepper;c:\jallib\include\external\ranger;c:\jallib\include\external\ranger\ir;c:\jallib\include\external\ranger\us;c:\jallib\include\external\rtc;c:\jallib\include\external\seven_segment;c:\jallib\include\external\storage;c:\jallib\include\external\storage\eeprom;c:\jallib\include\external\storage\harddisk;c:\jallib\include\external\storage\ram;c:\jallib\include\external\storage\ram\23k256;c:\jallib\include\external\storage\sd_card;c:\jallib\include\external\temperature;c:\jallib\include\filesystem;c:\jallib\include\jal;c:\jallib\include\peripheral;c:\jallib\include\peripheral\adc;c:\jallib\include\peripheral\can;c:\jallib\include\peripheral\comparator;c:\jallib\include\peripheral\data_eeprom;c:\jallib\include\peripheral\flash_memory;c:\jallib\include\peripheral\i2c;c:\jallib\include\peripheral\pwm;c:\jallib\include\peripheral\spi;c:\jallib\include\peripheral\timer;c:\jallib\include\peripheral\usart;c:\jallib\include\peripheral\usb;c:\jallib\include\protocol;c:\jallib\test;c:\jallib\test\board;c:\jallib\test\external;c:\jallib\test\external\keyboard;c:\jallib\test\external\lcd;c:\jallib\test\external\ranger;c:\jallib\test\external\ranger\ir;c:\jallib\test\external\rtc;c:\jallib\test\external\seven_segment;c:\jallib\test\jal;c:\jallib\test\peripheral;c:\jallib\test\peripheral\adc;c:\jallib\test\peripheral\comparator;c:\jallib\test\peripheral\data_eeprom;c:\jallib\test\peripheral\flash_memory;c:\jallib\test\peripheral\i2c;c:\jallib\test\peripheral\pwm;c:\jallib\test\peripheral\spi;c:\jallib\test\peripheral\timer;c:\jallib\test\peripheral\usart;c:\jallib\test\peripheral\usb;c:\jallib\test\unittest;"
; compiler flags:
;    boot-fuse, boot-long-start, debug-compiler, debug-pcode
;    debug-codegen, opt-expr-reduce, opt-cexpr-reduce
;    opt-variable-reduce, warn-backend, warn-conversion, warn-misc
;    warn-range, warn-stack-overflow, warn-truncate
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
v_output                       EQU 0
v__ind                         EQU 0x0000  ; _ind
v__pcl                         EQU 0x0002  ; _pcl
v__status                      EQU 0x0003  ; _status
v__z                           EQU 2
v__c                           EQU 0
v__fsr                         EQU 0x0004  ; _fsr
v_portc                        EQU 0x0007  ; portc
v__portc_shadow                EQU 0x0026  ; _portc_shadow
v__pclath                      EQU 0x000a  ; _pclath
v_pir1                         EQU 0x000c  ; pir1
v_pir1_txif                    EQU 0x000c  ; pir1_txif-->pir1:4
v_rcsta                        EQU 0x0018  ; rcsta
v_txreg                        EQU 0x0019  ; txreg
v_trisc                        EQU 0x0087  ; trisc
v_pin_c2_direction             EQU 0x0087  ; pin_c2_direction-->trisc:2
v_pie1                         EQU 0x008c  ; pie1
v_pie1_rcie                    EQU 0x008c  ; pie1_rcie-->pie1:5
v_pie1_txie                    EQU 0x008c  ; pie1_txie-->pie1:4
v_txsta                        EQU 0x0098  ; txsta
v_txsta_txen                   EQU 0x0098  ; txsta_txen-->txsta:5
v_txsta_brgh                   EQU 0x0098  ; txsta_brgh-->txsta:2
v_spbrg                        EQU 0x0099  ; spbrg
v__pic_temp                    EQU 0x0020  ; _pic_temp-->_pic_state
v__pic_pointer                 EQU 0x0022  ; _pic_pointer
v__pic_state                   EQU 0x0020  ; _pic_state
v___x_116                      EQU 0x0026  ; x-->_portc_shadow:2
v___x_117                      EQU 0x0026  ; x-->_portc_shadow:2
v____device_put_1              EQU 0x0027  ; print_string:_device_put
v__str_count                   EQU 0x0029  ; print_string:_str_count
v___str_1                      EQU 0x002b  ; print_string:str
v_len                          EQU 0x002d  ; print_string:len
v_i                            EQU 0x002f  ; print_string:i
v___n_3                        EQU 0x0027  ; delay_1ms:n
v__floop2                      EQU 0x0029  ; delay_1ms:_floop2
v___data_9                     EQU 0x0024  ; _serial_hw_data_put:data
v___data_3                     EQU 0       ; serial_hw_write_word(): data
v___data_1                     EQU 0x0025  ; serial_hw_write:data
v_usart_div                    EQU 10      ; _calculate_and_set_baudrate(): usart_div
;    3 include board_16f877a_startersguide    
; c(4611c8) l(2) 4611c8{u-} _main:
                               org      0                   ;  0 -- -- -- [-- --] 0000
                               branchhi_clr l__main         ;  0 -V rs rs [hl hl] 0000 120a
                               branchlo_clr l__main         ;  0 -V rs rs [hl hl] 0001 118a
                               goto     l__main             ;  0 -V rs rs [hl hl] 0002 2823
                               nop                          ; 4294967295 -- -- -- [-- --] 0003 0000
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0004 0782
                               retlw    13                  ; 4294967295 -V -- -- [-- --] 0005 340d
                               retlw    10                  ; 4294967295 -V -- -- [-- --] 0006 340a
                               retlw    10                  ; 4294967295 -V -- -- [-- --] 0007 340a
                               retlw    72                  ; 4294967295 -V -- -- [-- --] 0008 3448
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0009 3465
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 000a 346c
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 000b 346c
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 000c 346f
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 000d 3420
                               retlw    74                  ; 4294967295 -V -- -- [-- --] 000e 344a
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 000f 3461
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 0010 346c
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 0011 346c
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 0012 3469
                               retlw    98                  ; 4294967295 -V -- -- [-- --] 0013 3462
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0014 3420
                               retlw    119                 ; 4294967295 -V -- -- [-- --] 0015 3477
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 0016 346f
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 0017 3472
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 0018 346c
                               retlw    100                 ; 4294967295 -V -- -- [-- --] 0019 3464
                               retlw    33                  ; 4294967295 -V -- -- [-- --] 001a 3421
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 001b 3420
                               retlw    92                  ; 4294967295 -V -- -- [-- --] 001c 345c
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 001d 3420
                               retlw    13                  ; 4294967295 -V -- -- [-- --] 001e 340d
                               retlw    10                  ; 4294967295 -V -- -- [-- --] 001f 340a
l__pic_indirect
                               movwf    v__pclath           ;  2 OV rs rs [?? ??] 0020 008a
                               movf     v__pic_pointer,w    ;  2 OV rs rs [?? ??] 0021 0822
                               movwf    v__pcl              ;  2 OV rs rs [?? ??] 0022 0082
                                                            ; W = v__pic_pointer
l__main
; c:\jallib\include\device/16f877a.jal
;  294 var          byte  _PORTC_shadow        = PORTC
; c(4a3c68) l(293) 4a3c68{u-} = 679[i------1]:{_portc_shadow[i---1]}, 678[i-V----1]:{portc[i-V-1]}
                               movf     v_portc,w           ;  0 OV rs rs [hl hl] 0023 0807
                               movwf    v__portc_shadow     ;  0 OV rs rs [hl hl] 0024 00a6
; c(4a3ed8) l(293) 4a3ed8{u-} {eos}
; jallib.jal
;    4 led_direction = output
; c(503a58) l(3) 503a58{u-} = 1522[B-V----1]:{pin_c2_direction[B-V-:1]}, 1523[BC-----1]:{output[BC--:1]0}
                               datalo_set v_trisc ; pin_c2_direction        ;  0 OV rs rS [hl hl] 0025 1683
                                                            ; W = v__portc_shadow
                               bcf      v_trisc, 2 ; pin_c2_direction       ;  0 OV rS rS [hl hl] 0026 1107
                                                            ; W = v__portc_shadow
; c(503cc8) l(3) 503cc8{u-} {eos}
; c:\jallib\include\peripheral\usart/usart_common.jal
;   21 end if
; c(504328) l(20) 504328{u-} goto _l286
                               goto     l__l286             ;  0 OV rS rS [hl hl] 0027 2840
                                                            ; W = v__portc_shadow
;   43 procedure _calculate_and_set_baudrate() is
; c(5047c8) l(42) 5047c8{u-} {enter: _calculate_and_set_baudrate}
l__calculate_and_set_baudrate
; c(504838) l(42) 504838{u-} {block}
;   99                SPBRG = usart_div 
; c(5064c8) l(98) 5064c8{u-} = 1575[i-V----1]:{spbrg[i-V-1]}, 1576[iC-----4]:{usart_div[iC--4]10}
                               movlw    10                  ;  2 OV rS rS [hl hl] 0028 300a
                                                            ; W = v__portc_shadow
                               movwf    v_spbrg             ;  2 OV rS rS [hl hl] 0029 0099
; c(506738) l(98) 506738{u-} {eos}
;  103             TXSTA_BRGH = true
; c(506a28) l(102) 506a28{u-} = 1578[B-V----1]:{txsta_brgh[B-V-:1]}, 1579[BC-----1]:{true[BC--:1]1}
                               bsf      v_txsta, 2 ; txsta_brgh       ;  2 OV rS rS [hl hl] 002a 1518
; c(506c98) l(102) 506c98{u-} {eos}
;  152 end procedure
; c(507268) l(151) 507268{u-} {end-of-block}
; c(5072d8) l(151) 5072d8{u-} {leave _calculate_and_set_baudrate}
                               return                       ;  2 OV rS rS [hl hl] 002b 0008
; c:\jallib\include\peripheral\usart/serial_hardware.jal
;   25 procedure serial_hw_init() is 
; c(507758) l(24) 507758{u-} {enter: serial_hw_init}
l_serial_hw_init
; c(5077c8) l(24) 5077c8{u-} {block}
;   27    _calculate_and_set_baudrate()
; c(507948) l(26) 507948{u-} call _calculate_and_set_baudrate()
                               call     l__calculate_and_set_baudrate;  1 OV rS ?? [hl ??] 002c 2028
                                                            ; W = v__portc_shadow
; c(5079b8) l(26) 5079b8{u-} {eos}
;   30    PIE1_RCIE = false
; c(507b28) l(29) 507b28{u-} = 1582[B-V----1]:{pie1_rcie[B-V-:1]}, 1583[BC-----1]:{false[BC--:1]0}
                               datalo_set v_pie1 ; pie1_rcie         ;  1 OV ?? ?S [?? ??] 002d 1683
                               bcf      v_pie1, 5 ; pie1_rcie        ;  1 OV rS rS [?? ??] 002e 128c
; c(507d98) l(29) 507d98{u-} {eos}
;   31    PIE1_TXIE = false
; c(507ed8) l(30) 507ed8{u-} = 1585[B-V----1]:{pie1_txie[B-V-:1]}, 1586[BC-----1]:{false[BC--:1]0}
                               bcf      v_pie1, 4 ; pie1_txie        ;  1 OV rS rS [?? ??] 002f 120c
; c(508208) l(30) 508208{u-} {eos}
;   34    TXSTA_TXEN = true
; c(508388) l(33) 508388{u-} = 1588[B-V----1]:{txsta_txen[B-V-:1]}, 1589[BC-----1]:{true[BC--:1]1}
                               bsf      v_txsta, 5 ; txsta_txen       ;  1 OV rS rS [?? ??] 0030 1698
; c(5084f8) l(33) 5084f8{u-} {eos}
;   38    RCSTA = 0x90
; c(508678) l(37) 508678{u-} = 1591[i-V----1]:{rcsta[i-V-1]}, 1592[iC-----4]:{[iC--4]144}
                               movlw    144                 ;  1 OV rS rS [?? ??] 0031 3090
                               datalo_clr v_rcsta           ;  1 OV rS rs [?? ??] 0032 1283
                               movwf    v_rcsta             ;  1 OV rs rs [?? ??] 0033 0098
; c(5088e8) l(37) 5088e8{u-} {eos}
;   40 end procedure
; c(5089d8) l(39) 5089d8{u-} {end-of-block}
; c(508a48) l(39) 508a48{u-} {leave serial_hw_init}
                               return                       ;  1 OV rs rs [?? ??] 0034 0008
;   67 procedure serial_hw_write(byte in data) is
; c(50ac48) l(66) 50ac48{u-} {enter: serial_hw_write}
l_serial_hw_write
                               movwf    v___data_1          ; 4294967295 OV rs rs [?? ??] 0035 00a5
                                                            ; W = v___data_9
; c(50acb8) l(66) 50acb8{u-} {block}
;   69    while ! PIR1_TXIF loop end loop
; c(50aee8) l(68) 50aee8{u-} _l248:
l__l248
; c(50b1e8) l(68) 50b1e8{u-} ~ , 1602[B-V----1]:{pir1_txif[B-V-:1]}
; c(50b468) l(68) 50b468{u-} goto false ? -->_l249
                               btfss    v_pir1, 4 ; pir1_txif        ; 4294967295 OV rs rs [?? ??] 0036 1e0c
                                                            ; W = v___data_1
; c(50b608) l(68) 50b608{u-} goto _l248
                               goto     l__l248             ; 4294967295 OV rs rs [?? ??] 0037 2836
; c(50b678) l(68) 50b678{u-} _l249:
l__l249
;   71    TXREG = data
; c(50b8c8) l(70) 50b8c8{u-} = 1605[i-V----1]:{txreg[i-V-1]}, 1606[i------1]:{__data_1[i---1]}
                               movf     v___data_1,w        ; 4294967295 OV rs rs [?? ??] 0038 0825
                                                            ; W = v___data_1
                               movwf    v_txreg             ; 4294967295 OV rs rs [?? ??] 0039 0099
                                                            ; W = v___data_1
; c(50bb38) l(70) 50bb38{u-} {eos}
;   72 end procedure
; c(50bc28) l(71) 50bc28{u-} {end-of-block}
; c(50bc98) l(71) 50bc98{u-} {leave serial_hw_write}
                               return                       ; 4294967295 OV rs rs [?? ??] 003a 0008
;  146 procedure serial_hw_data'put(byte in data) is
; c(512438) l(145) 512438{u-} {enter: _serial_hw_data_put}
l__serial_hw_data_put
                               datalo_clr v__pic_temp       ; 4294967295 OV ?? ?s [?? ??] 003b 1283
                               movf     v__pic_temp,w       ; 4294967295 OV rs rs [?? ??] 003c 0820
                               movwf    v___data_9          ; 4294967295 OV rs rs [?? ??] 003d 00a4
                                                            ; W = v__pic_temp
; c(5124a8) l(145) 5124a8{u-} {block}
;  147    serial_hw_write(data)
; c(5126f8) l(146) 5126f8{u-} call serial_hw_write(,1650[i------1]:{__data_9[i---1]})
                               movf     v___data_9,w        ; 4294967295 OV rs rs [?? ??] 003e 0824
                                                            ; W = v___data_9
                               goto     l_serial_hw_write   ; 4294967295 OV rs rs [?? ??] 003f 2835
                                                            ; W = v___data_9
; c(512768) l(146) 512768{u-} {eos}
;  148 end procedure
; c(512858) l(147) 512858{u-} {end-of-block}
; c(5128c8) l(147) 5128c8{u-} {leave _serial_hw_data_put}
;  175 end function
; c(516bb8) l(174) 516bb8{u-} _l286:
l__l286
; jallib.jal
;    7 serial_hw_init()
; c(516e18) l(6) 516e18{u-} call serial_hw_init()
                               call     l_serial_hw_init    ;  0 OV rS ?? [hl ??] 0040 202c
                                                            ; W = v__portc_shadow
; c(516e88) l(6) 516e88{u-} {eos}
; c:\jallib\include\jal/delay.jal
;   26 procedure delay_1us() is
; c(517508) l(25) 517508{u-} goto _l345
                               goto     l__l345             ;  0 OV ?? ?? [?? ??] 0041 2880
;  113 procedure delay_1ms(word in n) is
; c(520f38) l(112) 520f38{u-} {enter: delay_1ms}
l_delay_1ms
; c(521108) l(112) 521108{u-} {block}
;  115    for n loop
; c(521998) l(114) 521998{u-} = 1739[i------2]:{_floop2[i---2]}, 1740[iC-----4]:{[iC--4]0}
                               clrf     v__floop2           ;  1 OV rs rs [?? ??] 0042 01a9
                                                            ; W = v___n_3
                               clrf     v__floop2+1         ;  1 OV rs rs [?? ??] 0043 01aa
                                                            ; W = v___n_3
; c(521d28) l(114) 521d28{u-} goto _l323
                               goto     l__l323             ;  1 OV rs rs [?? ??] 0044 2857
                                                            ; W = v___n_3
; c(521d98) l(114) 521d98{u-} _l322:
l__l322
; c(521e48) l(114) 521e48{u-} {block}
;  117          _usec_delay(_one_ms_delay)
; c(522298) l(116) 522298{u-} usec_delay(998)
                               datalo_clr v__pic_temp       ;  1 -V rs rs [?? ??] 0045 1283
                               datahi_clr v__pic_temp       ;  1 -V rs rs [?? ??] 0046 1303
                               movlw    6                   ;  1 -V rs rs [?? ??] 0047 3006
                               movwf    v__pic_temp         ;  1 -V rs rs [?? ??] 0048 00a0
l__l440
                               movlw    165                 ;  1 -V rs rs [?? ??] 0049 30a5
                               movwf    v__pic_temp+1       ;  1 -V rs rs [?? ??] 004a 00a1
l__l441
                               branchhi_clr l__l441         ;  1 -V rs rs [?? h?] 004b 120a
                               branchlo_clr l__l441         ;  1 -V rs rs [h? hl] 004c 118a
                               decfsz   v__pic_temp+1,f     ;  1 -V rs rs [hl hl] 004d 0ba1
                               goto     l__l441             ;  1 -V rs rs [hl hl] 004e 284b
                               branchhi_clr l__l440         ;  1 -V rs rs [hl hl] 004f 120a
                               branchlo_clr l__l440         ;  1 -V rs rs [hl hl] 0050 118a
                               decfsz   v__pic_temp,f       ;  1 -V rs rs [hl hl] 0051 0ba0
                               goto     l__l440             ;  1 -V rs rs [hl hl] 0052 2849
                               nop                          ;  1 -V rs rs [hl hl] 0053 0000
                                                            ; W = v__pic_temp
; c(522308) l(116) 522308{u-} {eos}
;  121    end loop
; c(522558) l(120) 522558{u-} {end-of-block}
; c(5225c8) l(120) 5225c8{u-} ++ 1739[i------2]:{_floop2[i---2]}, 1739[i------2]:{_floop2[i---2]}
                               incf     v__floop2,f         ;  1 OV rs rs [hl hl] 0054 0aa9
                                                            ; W = v__pic_temp
                               btfsc    v__status, v__z     ;  1 OV rs rs [hl hl] 0055 1903
                                                            ; W = v__pic_temp
                               incf     v__floop2+1,f       ;  1 OV rs rs [hl hl] 0056 0aaa
                                                            ; W = v__pic_temp
; c(522738) l(120) 522738{u-} _l323:
l__l323
; c(522888) l(120) 522888{u-} == , 1739[i------2]:{_floop2[i---2]}, 1738[i------2]:{__n_3[i---2]}
; c(522af8) l(120) 522af8{u-} goto false ? -->_l322
                               movf     v__floop2,w         ;  1 OV rs rs [?? ??] 0057 0829
                                                            ; W = v___n_3
                               subwf    v___n_3,w           ;  1 OV rs rs [?? ??] 0058 0227
                                                            ; W = v__floop2
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0059 00a0
                               movf     v__floop2+1,w       ;  1 OV rs rs [?? ??] 005a 082a
                                                            ; W = v__pic_temp
                               subwf    v___n_3+1,w         ;  1 OV rs rs [?? ??] 005b 0228
                                                            ; W = v__floop2
                               iorwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 005c 0420
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 005d 1d03
                               goto     l__l322             ;  1 OV rs rs [?? ??] 005e 2845
;  122 end procedure
; c(522cc8) l(121) 522cc8{u-} {end-of-block}
; c(522d38) l(121) 522d38{u-} {leave delay_1ms}
                               return                       ;  1 OV rs rs [?? ??] 005f 0008
                                                            ; W = v__pic_temp
; c:\jallib\include\jal/print.jal
;   57 procedure print_crlf(volatile byte out device) is
; c(531868) l(56) 531868{u-} goto _l345
;   62 procedure print_string(volatile byte out device, byte in str[]) is
; c(532428) l(61) 532428{u-} {enter: print_string}
l_print_string
; c(532498) l(61) 532498{u-} {block}
;   63    var word len = count(str)
; c(532648) l(62) 532648{u-} = 1869[i------2]:{len[i---2]}, 1868[i------2]:{_str_count[i---2]}
                               movf     v__str_count,w      ;  1 OV rs rs [?? ??] 0060 0829
                               movwf    v_len               ;  1 OV rs rs [?? ??] 0061 00ad
                                                            ; W = v__str_count
                               movf     v__str_count+1,w    ;  1 OV rs rs [?? ??] 0062 082a
                                                            ; W = v_len
                               movwf    v_len+1             ;  1 OV rs rs [?? ??] 0063 00ae
                                                            ; W = v__str_count
; c(5328b8) l(62) 5328b8{u-} {eos}
;   66    for len using i loop           
; c(532a18) l(65) 532a18{u-} = 1871[i------1]:{i[i---1]}, 1872[iC-----4]:{[iC--4]0}
                               clrf     v_i                 ;  1 OV rs rs [?? ??] 0064 01af
                                                            ; W = v_len
; c(532da8) l(65) 532da8{u-} goto _l356
                               goto     l__l356             ;  1 OV rs rs [?? ??] 0065 2878
                                                            ; W = v_len
; c(532e18) l(65) 532e18{u-} _l355:
l__l355
; c(532ec8) l(65) 532ec8{u-} {block}
;   70       device = str[i]
; c(533368) l(69) 533368{u-} call &_device_put(,1879[i---I-P1]:{*__str_1[*---2]}+i)
                               movf     v___str_1+1,w       ;  1 OV rs rs [?? ??] 0066 082c
                               movwf    v__pic_pointer+1    ;  1 OV rs rs [?? ??] 0067 00a3
                                                            ; W = v___str_1
                               movf     v_i,w               ;  1 OV rs rs [?? ??] 0068 082f
                                                            ; W = v__pic_pointer
                               addwf    v___str_1,w         ;  1 OV rs rs [?? ??] 0069 072b
                                                            ; W = v_i
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 006a 00a2
                               btfsc    v__status, v__c     ;  1 OV rs rs [?? ??] 006b 1803
                                                            ; W = v__pic_pointer
                               incf     v__pic_pointer+1,f  ;  1 OV rs rs [?? ??] 006c 0aa3
                                                            ; W = v__pic_pointer
                               bcf      v__pic_pointer+1, 6 ;  1 OV rs rs [?? ??] 006d 1323
                               movf     v__pic_pointer+1,w  ;  1 OV rs rs [?? ??] 006e 0823
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 006f 2020
                                                            ; W = v__pic_pointer
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0070 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0071 00a0
                               movf     v____device_put_1,w ;  1 OV rs rs [?? ??] 0072 0827
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0073 00a2
                                                            ; W = v____device_put_1
                               movf     v____device_put_1+1,w;  1 OV rs rs [?? ??] 0074 0828
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0075 2020
                                                            ; W = v____device_put_1
; c(5333d8) l(69) 5333d8{u-} {eos}
;   71    end loop
; c(533458) l(70) 533458{u-} {end-of-block}
; c(5334c8) l(70) 5334c8{u-} ++ 1871[i------1]:{i[i---1]}, 1871[i------1]:{i[i---1]}
                               datalo_clr v_i               ;  1 OV ?? ?s [?? ??] 0076 1283
                               incf     v_i,f               ;  1 OV rs rs [?? ??] 0077 0aaf
; c(533638) l(70) 533638{u-} _l356:
l__l356
; c(533788) l(70) 533788{u-} == , 1871[i------1]:{i[i---1]}, 1870[i------2]:{len[i---2]}
; c(5339f8) l(70) 5339f8{u-} goto false ? -->_l355
                               movf     v_i,w               ;  1 OV rs rs [?? ??] 0078 082f
                                                            ; W = v_len
                               subwf    v_len,w             ;  1 OV rs rs [?? ??] 0079 022d
                                                            ; W = v_i
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 007a 00a0
                               movf     v_len+1,w           ;  1 OV rs rs [?? ??] 007b 082e
                                                            ; W = v__pic_temp
                               iorwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 007c 0420
                                                            ; W = v_len
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 007d 1d03
                               goto     l__l355             ;  1 OV rs rs [?? ??] 007e 2866
;   73 end procedure
; c(533bc8) l(72) 533bc8{u-} {end-of-block}
; c(533c38) l(72) 533c38{u-} {leave print_string}
                               return                       ;  1 OV rs rs [?? ??] 007f 0008
;  316 end procedure
; c(568498) l(315) 568498{u-} _l345:
l__l345
; jallib.jal
;   15 forever loop
; c(56a1e8) l(14) 56a1e8{u-} _l432:
l__l432
; c(56a298) l(14) 56a298{u-} {block}
;   17    print_string(serial_hw_data, str1)
; c(56a428) l(16) 56a428{u-} call print_string(,2423[F------1]:{___serial_hw_data_put_1[F---1]},2425[iC-----4]:{[iC--4]27},2426[aC-----27]:{__str1_2[aC--27]2139058047})
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0080 303b
                               datalo_clr v____device_put_1 ;  0 OV ?? ?s [?? ??] 0081 1283
                               movwf    v____device_put_1   ;  0 OV rs rs [?? ??] 0082 00a7
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0083 3000
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  0 OV rs rs [?? ??] 0084 00a8
                               movlw    27                  ;  0 OV rs rs [?? ??] 0085 301b
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  0 OV rs rs [?? ??] 0086 00a9
                               clrf     v__str_count+1      ;  0 OV rs rs [?? ??] 0087 01aa
                                                            ; W = v__str_count
                               irp_clr                      ;  0 OV rs rs [?? ??] 0088 1383
                                                            ; W = v__str_count
                               movlw    43                  ;  0 OV rs rs [?? ??] 0089 302b
                                                            ; W = v__str_count
                               movwf    v__fsr              ;  0 OV rs rs [?? ??] 008a 0084
                               movlw    127                 ;  0 OV rs rs [?? ??] 008b 307f
                               movwf    v__ind              ;  0 OV rs rs [?? ??] 008c 0080
                               incf     v__fsr,f            ;  0 OV rs rs [?? ??] 008d 0a84
                               movlw    111                 ;  0 OV rs rs [?? ??] 008e 306f
                               movwf    v__ind              ;  0 OV rs rs [?? ??] 008f 0080
                               call     l_print_string      ;  0 OV rs ?? [?? ??] 0090 2060
; c(56a498) l(16) 56a498{u-} {eos}
;   19    led = true   
; c(56a5e8) l(18) 56a5e8{u-} {block}
; c(56a688) l(18) 56a688{u-} = 2430[B------1]:{__x_116[B---:1]}, 2429[BC-----1]:{true[BC--:1]1}
                               datalo_clr v__portc_shadow ; x116;  0 OV ?? ?s [?? ??] 0091 1283
                               bsf      v__portc_shadow, 2 ; x116;  0 OV rs rs [?? ??] 0092 1526
; c(56a838) l(18) 56a838{u-} {block}
; c:\jallib\include\device/16f877a.jal
;  298    PORTC = _PORTC_shadow
; c(56a8a8) l(297) 56a8a8{u-} = 681[i-V----1]:{portc[i-V-1]}, 682[i------1]:{_portc_shadow[i---1]}
                               movf     v__portc_shadow,w   ;  0 OV rs rs [?? ??] 0093 0826
                               movwf    v_portc             ;  0 OV rs rs [?? ??] 0094 0087
                                                            ; W = v__portc_shadow
; c(56a918) l(297) 56a918{u-} {eos}
; jallib.jal
;   19    led = true   
; c(56aad8) l(18) 56aad8{u-} {end-of-block}
; c:\jallib\include\device/16f877a.jal
;  381    _PORTC_flush()
; c(56ab48) l(380) 56ab48{u-} {eos}
; jallib.jal
;   19    led = true   
; c(56ac88) l(18) 56ac88{u-} {end-of-block}
; c(56adf8) l(18) 56adf8{u-} {eos}
;   20    delay_1ms(500)
; c(56af18) l(19) 56af18{u-} call delay_1ms(,2432[iC-----4]:{[iC--4]500})
                               movlw    244                 ;  0 OV rs rs [?? ??] 0095 30f4
                               movwf    v___n_3             ;  0 OV rs rs [?? ??] 0096 00a7
                               movlw    1                   ;  0 OV rs rs [?? ??] 0097 3001
                                                            ; W = v___n_3
                               movwf    v___n_3+1           ;  0 OV rs rs [?? ??] 0098 00a8
                               call     l_delay_1ms         ;  0 OV rs ?? [?? ??] 0099 2042
                                                            ; W = v___n_3
; c(56af88) l(19) 56af88{u-} {eos}
;   22    led = false   
; c(56a9f8) l(21) 56a9f8{u-} {block}
; c(56b108) l(21) 56b108{u-} = 2436[B------1]:{__x_117[B---:1]}, 2435[BC-----1]:{false[BC--:1]0}
                               datalo_clr v__portc_shadow ; x117;  0 OV ?? ?s [?? ??] 009a 1283
                               bcf      v__portc_shadow, 2 ; x117;  0 OV rs rs [?? ??] 009b 1126
; c(56b1b8) l(21) 56b1b8{u-} {block}
; c:\jallib\include\device/16f877a.jal
;  298    PORTC = _PORTC_shadow
; c(56b228) l(297) 56b228{u-} = 681[i-V----1]:{portc[i-V-1]}, 682[i------1]:{_portc_shadow[i---1]}
                               movf     v__portc_shadow,w   ;  0 OV rs rs [?? ??] 009c 0826
                               movwf    v_portc             ;  0 OV rs rs [?? ??] 009d 0087
                                                            ; W = v__portc_shadow
; c(56b298) l(297) 56b298{u-} {eos}
; jallib.jal
;   22    led = false   
; c(56b458) l(21) 56b458{u-} {end-of-block}
; c:\jallib\include\device/16f877a.jal
;  381    _PORTC_flush()
; c(56b4c8) l(380) 56b4c8{u-} {eos}
; jallib.jal
;   22    led = false   
; c(56b608) l(21) 56b608{u-} {end-of-block}
; c(56b778) l(21) 56b778{u-} {eos}
;   23    delay_1ms(500)
; c(56b898) l(22) 56b898{u-} call delay_1ms(,2438[iC-----4]:{[iC--4]500})
                               movlw    244                 ;  0 OV rs rs [?? ??] 009e 30f4
                               movwf    v___n_3             ;  0 OV rs rs [?? ??] 009f 00a7
                               movlw    1                   ;  0 OV rs rs [?? ??] 00a0 3001
                                                            ; W = v___n_3
                               movwf    v___n_3+1           ;  0 OV rs rs [?? ??] 00a1 00a8
                               call     l_delay_1ms         ;  0 OV rs ?? [?? ??] 00a2 2042
                                                            ; W = v___n_3
; c(56b908) l(22) 56b908{u-} {eos}
;   25 end loop 
; c(56b988) l(24) 56b988{u-} {end-of-block}
; c(56b9f8) l(24) 56b9f8{u-} goto _l432
                               goto     l__l432             ;  0 OV ?? ?? [?? ??] 00a3 2880
                               end
; --- procedures & call stack
;{root} ----- -U- (frame_sz=1 blocks=6)
;   {block enter}
;     --- records ---
;     --- variables ---
;     460d88:_jal_version  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 2004
;     460e78:_jal_build  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 20100521
;     4617f8:_device_id word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 3616
;     461f48:_pictype  (type=a dflags=C---- sz=7 use=0 assigned=0)
;      = 49,54,70,56,55,55,65
;     461d08:_datasheet  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 51,57,53,56,50
;     461df8:_pgmspec  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 51,57,53,56,57
;     461948:_pic_12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1
;     461a38:_pic_14  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2
;     461b28:_pic_16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 3
;     461c18:_sx_12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 4
;     462848:_pic_14h  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 5
;     4629b8:_pjal bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     462b28:_w byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     462c98:_f byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     462e08:_true bit (type=B dflags=C--B- sz=1 use=3 assigned=0 bit=0)
;      = 1
;     462f78:_false bit (type=B dflags=C--B- sz=1 use=3 assigned=0 bit=0)
;      = 0
;     4616f8:_high bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     463108:_low bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     463238:_on bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     463368:_off bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     463498:_enabled bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     4635c8:_disabled bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     4636f8:_input bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     463828:_output bit (type=B dflags=C--B- sz=1 use=1 assigned=0 bit=0)
;      = 0
;     4639f8:_all_input byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 255
;     463b68:_all_output byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     463ca8:_adc_v0  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44480
;     463de8:_adc_v1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44481
;     463f28:_adc_v2  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44482
;     464108:_adc_v3  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44483
;     464248:_adc_v4  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44484
;     464388:_adc_v5  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44485
;     4644c8:_adc_v6  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44486
;     464608:_adc_v7  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44487
;     464748:_adc_v7_1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 711793
;     464888:_adc_v8  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44488
;     4649c8:_adc_v9  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44489
;     464b08:_adc_v10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 711696
;     464c48:_adc_v11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 711697
;     464d88:_adc_v11_1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 11387153
;     464ec8:_adc_v12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 711698
;     465108:_adc_v13  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 711699
;     465248:_adc_v13_1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 11387185
;     465388:_pic_10f200  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241600
;     4654c8:_pic_10f202  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241602
;     465608:_pic_10f204  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241604
;     465748:_pic_10f206  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241606
;     465888:_pic_10f220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241632
;     4659c8:_pic_10f222  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1241634
;     465b08:_pic_12f1822  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320704
;     465c48:_pic_12f508  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242376
;     465d88:_pic_12f509  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242377
;     465ec8:_pic_12f510  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242384
;     466108:_pic_12f519  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242393
;     466248:_pic_12f609  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319488
;     466388:_pic_12f615  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319296
;     4664c8:_pic_12f617  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315680
;     466608:_pic_12f629  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314688
;     466748:_pic_12f635  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314720
;     466888:_pic_12f675  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314752
;     4669c8:_pic_12f683  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311840
;     466b08:_pic_12hv609  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319552
;     466c48:_pic_12hv615  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319328
;     466d88:_pic_12lf1822  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320960
;     466ec8:_pic_16f1823  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320736
;     467108:_pic_16f1826  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320832
;     467248:_pic_16f1827  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320864
;     467388:_pic_16f1933  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319680
;     4674c8:_pic_16f1934  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319744
;     467608:_pic_16f1936  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319776
;     467748:_pic_16f1937  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319808
;     467888:_pic_16f1938  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319840
;     4679c8:_pic_16f1939  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319872
;     467b08:_pic_16f1946  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320192
;     467c48:_pic_16f1947  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320224
;     467d88:_pic_16f505  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242373
;     467ec8:_pic_16f506  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242374
;     468108:_pic_16f526  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242406
;     468248:_pic_16f610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319520
;     468388:_pic_16f616  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315392
;     4684c8:_pic_16f627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312672
;     468608:_pic_16f627a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314880
;     468748:_pic_16f628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312704
;     468888:_pic_16f628a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314912
;     4689c8:_pic_16f630  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315008
;     468b08:_pic_16f631  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315872
;     468c48:_pic_16f636  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314976
;     468d88:_pic_16f639  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314976
;     468ec8:_pic_16f648a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315072
;     469108:_pic_16f676  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315040
;     469248:_pic_16f677  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315904
;     469388:_pic_16f684  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314944
;     4694c8:_pic_16f685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311904
;     469608:_pic_16f687  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315616
;     469748:_pic_16f688  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315200
;     469888:_pic_16f689  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315648
;     4699c8:_pic_16f690  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315840
;     469b08:_pic_16f707  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317568
;     469c48:_pic_16f716  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315136
;     469d88:_pic_16f72  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1310880
;     469ec8:_pic_16f722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316992
;     46a108:_pic_16f722a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317664
;     46a248:_pic_16f723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316960
;     46a388:_pic_16f723a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317632
;     46a4c8:_pic_16f724  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316928
;     46a608:_pic_16f726  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316896
;     46a748:_pic_16f727  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316864
;     46a888:_pic_16f73  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312256
;     46a9c8:_pic_16f737  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313696
;     46ab08:_pic_16f74  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312288
;     46ac48:_pic_16f747  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313760
;     46ad88:_pic_16f76  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312320
;     46aec8:_pic_16f767  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314464
;     46b108:_pic_16f77  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312352
;     46b248:_pic_16f777  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314272
;     46b388:_pic_16f785  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315328
;     46b4c8:_pic_16f818  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311936
;     46b608:_pic_16f819  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311968
;     46b748:_pic_16f83  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1376131
;     46b888:_pic_16f84  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1376132
;     46b9c8:_pic_16f84a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1374282
;     46bb08:_pic_16f87  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312544
;     46bc48:_pic_16f870  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314048
;     46bd88:_pic_16f871  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314080
;     46bec8:_pic_16f872  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312992
;     46c108:_pic_16f873  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313120
;     46c248:_pic_16f873a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314368
;     46c388:_pic_16f874  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313056
;     46c4c8:_pic_16f874a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314400
;     46c608:_pic_16f876  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313248
;     46c748:_pic_16f876a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314304
;     46c888:_pic_16f877  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313184
;     46c9c8:_pic_16f877a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314336
;     46cb08:_pic_16f88  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312608
;     46cc48:_pic_16f882  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318912
;     46cd88:_pic_16f883  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318944
;     46cec8:_pic_16f884  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318976
;     46d108:_pic_16f886  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319008
;     46d248:_pic_16f887  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319040
;     46d388:_pic_16f913  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315808
;     46d4c8:_pic_16f914  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315776
;     46d608:_pic_16f916  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315744
;     46d748:_pic_16f917  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315712
;     46d888:_pic_16f946  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315936
;     46d9c8:_pic_16hv610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319584
;     46db08:_pic_16hv616  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315424
;     46dc48:_pic_16hv785  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315360
;     46dd88:_pic_16lf1823  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320992
;     46dec8:_pic_16lf1826  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1321088
;     46e108:_pic_16lf1827  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1321120
;     46e248:_pic_16lf1933  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319936
;     46e388:_pic_16lf1934  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320000
;     46e4c8:_pic_16lf1936  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320032
;     46e608:_pic_16lf1937  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320064
;     46e748:_pic_16lf1938  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320096
;     46e888:_pic_16lf1939  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320128
;     46e9c8:_pic_16lf1946  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320320
;     46eb08:_pic_16lf1947  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320352
;     46ec48:_pic_16lf707  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317600
;     46ed88:_pic_16lf722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317248
;     46eec8:_pic_16lf722a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317728
;     46f108:_pic_16lf723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317216
;     46f248:_pic_16lf723a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317696
;     46f388:_pic_16lf724  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317184
;     46f4c8:_pic_16lf726  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317152
;     46f608:_pic_16lf727  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317120
;     46f748:_pic_18f1220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443808
;     46f888:_pic_18f1230  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449472
;     46f9c8:_pic_18f1320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443776
;     46fb08:_pic_18f1330  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449504
;     46fc48:_pic_18f13k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462080
;     46fd88:_pic_18f13k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460032
;     46fec8:_pic_18f14k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462048
;     470108:_pic_18f14k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460064
;     470248:_pic_18f2220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443200
;     470388:_pic_18f2221  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450336
;     4704c8:_pic_18f2320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443072
;     470608:_pic_18f2321  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450272
;     470748:_pic_18f2331  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444064
;     470888:_pic_18f23k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450208
;     4709c8:_pic_18f23k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464128
;     470b08:_pic_18f2410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446240
;     470c48:_pic_18f242  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442944
;     470d88:_pic_18f2420  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446208
;     470ec8:_pic_18f2423  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446224
;     471108:_pic_18f2431  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444032
;     471248:_pic_18f2439  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442944
;     471388:_pic_18f2450  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451040
;     4714c8:_pic_18f2455  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446496
;     471608:_pic_18f2458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452640
;     471748:_pic_18f248  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443840
;     471888:_pic_18f2480  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448672
;     4719c8:_pic_18f24j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449216
;     471b08:_pic_18f24j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461632
;     471c48:_pic_18f24j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461248
;     471d88:_pic_18f24k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450144
;     471ec8:_pic_18f24k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463872
;     472108:_pic_18f2510  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446176
;     472248:_pic_18f2515  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445088
;     472388:_pic_18f252  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442816
;     4724c8:_pic_18f2520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446144
;     472608:_pic_18f2523  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446160
;     472748:_pic_18f2525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445056
;     472888:_pic_18f2539  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442816
;     4729c8:_pic_18f2550  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446464
;     472b08:_pic_18f2553  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452608
;     472c48:_pic_18f258  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443904
;     472d88:_pic_18f2580  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448640
;     472ec8:_pic_18f2585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445600
;     473108:_pic_18f25j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448960
;     473248:_pic_18f25j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461664
;     473388:_pic_18f25j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461280
;     4734c8:_pic_18f25k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450080
;     473608:_pic_18f25k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463616
;     473748:_pic_18f2610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445024
;     473888:_pic_18f2620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444992
;     4739c8:_pic_18f2680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445568
;     473b08:_pic_18f2682  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451776
;     473c48:_pic_18f2685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451808
;     473d88:_pic_18f26j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461696
;     473ec8:_pic_18f26j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461312
;     474108:_pic_18f26k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450016
;     474248:_pic_18f26k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463360
;     474388:_pic_18f4220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443232
;     4744c8:_pic_18f4221  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450304
;     474608:_pic_18f4320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443104
;     474748:_pic_18f4321  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450240
;     474888:_pic_18f4331  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444000
;     4749c8:_pic_18f43k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450176
;     474b08:_pic_18f43k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464064
;     474c48:_pic_18f4410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446112
;     474d88:_pic_18f442  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442976
;     474ec8:_pic_18f4420  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446080
;     475108:_pic_18f4423  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446096
;     475248:_pic_18f4431  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443968
;     475388:_pic_18f4439  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442976
;     4754c8:_pic_18f4450  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451008
;     475608:_pic_18f4455  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446432
;     475748:_pic_18f4458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452576
;     475888:_pic_18f448  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443872
;     4759c8:_pic_18f4480  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448608
;     475b08:_pic_18f44j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449248
;     475c48:_pic_18f44j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461728
;     475d88:_pic_18f44j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461344
;     475ec8:_pic_18f44k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450112
;     476108:_pic_18f44k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463808
;     476248:_pic_18f4510  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446048
;     476388:_pic_18f4515  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444960
;     4764c8:_pic_18f452  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442848
;     476608:_pic_18f4520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446016
;     476748:_pic_18f4523  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446032
;     476888:_pic_18f4525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444928
;     4769c8:_pic_18f4539  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442848
;     476b08:_pic_18f4550  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446400
;     476c48:_pic_18f4553  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452544
;     476d88:_pic_18f458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443936
;     476ec8:_pic_18f4580  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448576
;     477108:_pic_18f4585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445536
;     477248:_pic_18f45j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448992
;     477388:_pic_18f45j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461760
;     4774c8:_pic_18f45j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461376
;     477608:_pic_18f45k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450048
;     477748:_pic_18f45k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463552
;     477888:_pic_18f4610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444896
;     4779c8:_pic_18f4620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444864
;     477b08:_pic_18f4680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445504
;     477c48:_pic_18f4682  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451840
;     477d88:_pic_18f4685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451872
;     477ec8:_pic_18f46j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461792
;     478108:_pic_18f46j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461408
;     478248:_pic_18f46k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449984
;     478388:_pic_18f46k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463296
;     4784c8:_pic_18f6310  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444832
;     478608:_pic_18f6390  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444768
;     478748:_pic_18f6393  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448448
;     478888:_pic_18f63j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456384
;     4789c8:_pic_18f63j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456128
;     478b08:_pic_18f6410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443552
;     478c48:_pic_18f6490  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443488
;     478d88:_pic_18f6493  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445376
;     478ec8:_pic_18f64j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456416
;     479108:_pic_18f64j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456160
;     479248:_pic_18f6520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444640
;     479388:_pic_18f6525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444576
;     4794c8:_pic_18f6527  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446720
;     479608:_pic_18f6585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444448
;     479748:_pic_18f65j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447200
;     479888:_pic_18f65j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456480
;     4799c8:_pic_18f65j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447232
;     479b08:_pic_18f65j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458432
;     479c48:_pic_18f65j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456224
;     479d88:_pic_18f6620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443424
;     479ec8:_pic_18f6621  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444512
;     47a108:_pic_18f6622  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446784
;     47a248:_pic_18f6627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446848
;     47a388:_pic_18f6628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460672
;     47a4c8:_pic_18f6680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444384
;     47a608:_pic_18f66j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447264
;     47a748:_pic_18f66j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459264
;     47a888:_pic_18f66j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447296
;     47a9c8:_pic_18f66j16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459296
;     47ab08:_pic_18f66j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458496
;     47ac48:_pic_18f66j55  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458528
;     47ad88:_pic_18f66j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447936
;     47aec8:_pic_18f66j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449728
;     47b108:_pic_18f66j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462272
;     47b248:_pic_18f66j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462336
;     47b388:_pic_18f6720  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443360
;     47b4c8:_pic_18f6722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446912
;     47b608:_pic_18f6723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460736
;     47b748:_pic_18f67j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447328
;     47b888:_pic_18f67j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459328
;     47b9c8:_pic_18f67j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458560
;     47bb08:_pic_18f67j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449760
;     47bc48:_pic_18f67j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462304
;     47bd88:_pic_18f67j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462368
;     47bec8:_pic_18f8310  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444800
;     47c108:_pic_18f8390  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444736
;     47c248:_pic_18f8393  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448480
;     47c388:_pic_18f83j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456512
;     47c4c8:_pic_18f83j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456256
;     47c608:_pic_18f8410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443520
;     47c748:_pic_18f8490  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443456
;     47c888:_pic_18f8493  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445408
;     47c9c8:_pic_18f84j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456544
;     47cb08:_pic_18f84j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456288
;     47cc48:_pic_18f8520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444608
;     47cd88:_pic_18f8525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444544
;     47cec8:_pic_18f8527  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446752
;     47d108:_pic_18f8585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444416
;     47d248:_pic_18f85j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447392
;     47d388:_pic_18f85j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456608
;     47d4c8:_pic_18f85j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447680
;     47d608:_pic_18f85j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458592
;     47d748:_pic_18f85j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456352
;     47d888:_pic_18f8620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443392
;     47d9c8:_pic_18f8621  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444480
;     47db08:_pic_18f8622  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446816
;     47dc48:_pic_18f8627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446880
;     47dd88:_pic_18f8628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460704
;     47dec8:_pic_18f8680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444352
;     47e108:_pic_18f86j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447712
;     47e248:_pic_18f86j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459424
;     47e388:_pic_18f86j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447744
;     47e4c8:_pic_18f86j16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459456
;     47e608:_pic_18f86j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458656
;     47e748:_pic_18f86j55  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458688
;     47e888:_pic_18f86j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447968
;     47e9c8:_pic_18f86j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449792
;     47eb08:_pic_18f86j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462400
;     47ec48:_pic_18f86j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462464
;     47ed88:_pic_18f8720  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443328
;     47eec8:_pic_18f8722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446944
;     47f108:_pic_18f8723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460768
;     47f248:_pic_18f87j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447776
;     47f388:_pic_18f87j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459488
;     47f4c8:_pic_18f87j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458720
;     47f608:_pic_18f87j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449824
;     47f748:_pic_18f87j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462432
;     47f888:_pic_18f87j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462496
;     47f9c8:_pic_18f96j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448000
;     47fb08:_pic_18f96j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449856
;     47fc48:_pic_18f97j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449888
;     47fd88:_pic_18lf13k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462144
;     47fec8:_pic_18lf13k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459968
;     480108:_pic_18lf14k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462112
;     480248:_pic_18lf14k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460000
;     480388:_pic_18lf23k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464160
;     4804c8:_pic_18lf24j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449280
;     480608:_pic_18lf24j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461824
;     480748:_pic_18lf24j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461440
;     480888:_pic_18lf24k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463904
;     4809c8:_pic_18lf25j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449024
;     480b08:_pic_18lf25j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461856
;     480c48:_pic_18lf25j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461472
;     480d88:_pic_18lf25k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463648
;     480ec8:_pic_18lf26j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461888
;     481108:_pic_18lf26j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461504
;     481248:_pic_18lf26k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463392
;     481388:_pic_18lf43k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464096
;     4814c8:_pic_18lf44j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449312
;     481608:_pic_18lf44j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461920
;     481748:_pic_18lf44j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461536
;     481888:_pic_18lf44k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463840
;     4819c8:_pic_18lf45j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449056
;     481b08:_pic_18lf45j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461952
;     481c48:_pic_18lf45j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461568
;     481d88:_pic_18lf45k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463584
;     481ec8:_pic_18lf46j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461984
;     482108:_pic_18lf46j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461600
;     482248:_pic_18lf46k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463328
;     4638f8:_target_cpu  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2
;     482428:_target_chip  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314336
;     482af8:_target_chip_name  (type=a dflags=C---- sz=7 use=0 assigned=0)
;      = 49,54,102,56,55,55,97
;     4828e8:_target_bank_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 128
;     482828:_target_page_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2048
;     482768:__stack_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8
;     4826a8:__code_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8192
;     482528:__eeprom  (type=a dflags=C---- sz=256 use=0 assigned=0)
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
;     4829a8:__pic_accum byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=007e)
;     4825e8:__pic_isr_w byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=007f)
;     483ea8:__fuses_ct word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 1
;     484108:__fuse_base word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 8199
;     484278:__fuses word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 16250
;     483da8:_indf byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0000)
;     484598:__ind byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0000)
;     484848:_tmr0 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0001)
;     484a18:_pcl byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0002)
;     484cc8:__pcl byte (type=i dflags=-V--- sz=1 use=1 assigned=2 base=0002)
;     484f78:_status byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0003)
;     485108:_status_irp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> status+0
;     485258:_status_rp  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=5) ---> status+0
;     485448:_status_nto bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> status+0
;     4855a8:_status_npd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> status+0
;     485708:_status_z bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> status+0
;     485868:_status_dc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> status+0
;     4859c8:_status_c bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> status+0
;     485b28:__status byte (type=i dflags=-V--- sz=1 use=4 assigned=0 base=0003)
;     485ed8:__irp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 7
;     486108:__rp1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     486278:__rp0 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     4863e8:__not_to byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     486558:__not_pd byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     4866c8:__z byte (type=i dflags=C---- sz=1 use=6 assigned=0)
;      = 2
;     486838:__dc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     4869a8:__c byte (type=i dflags=C---- sz=1 use=2 assigned=0)
;      = 0
;     485dd8:_fsr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0004)
;     486cc8:__fsr byte (type=i dflags=-V--- sz=1 use=1 assigned=2 base=0004)
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
;     4a3ba8:__portc_shadow byte (type=i dflags=----- auto sz=1 use=2 assigned=3 base=0026)
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
;     4cd9d8:__pclath byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=000a)
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
;     4d4108:_adcon0 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001f)
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
;     4fbec8:_cmcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=009c)
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
;     4fd268:_adcon1 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=009f)
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
;     5028d8:_button bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     5029f8:_button_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     502ba8:_serial_hw_baudrate  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 115200
;     502ac8:_lcd_rs bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portd+0
;     502d58:_lcd_rs_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisd+0
;     502e38:_lcd_en bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portd+0
;     502f58:_lcd_en_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisd+0
;     502968:_portd_low  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     502cc8:_lcd_dataport byte (type=i dflags=----- alias sz=1 use=0 assigned=0) ---> portd_low
;     503108:_portd_low_direction  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     5031c8:_lcd_dataport_direction byte (type=i dflags=----- alias sz=1 use=0 assigned=0) ---> portd_low_direction
;     503388:_lcd_rows byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 2
;     5034f8:_lcd_chars byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 16
;     503288:_i2c_scl bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     5036a8:_i2c_scl_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     503788:_i2c_sda bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     5038a8:_i2c_sda_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     504108:_usart_hw_serial bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     5039c8:__calculate_and_set_baudrate_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     504cd8:_serial_hw_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     505108:_serial_hw_disable_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     50a1b8:_serial_hw_enable_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     50ab48:_serial_hw_write_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     50c1f8:_serial_hw_write_word_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     50e508:__serial_hw_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     507848:_serial_hw_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     512338:__serial_hw_data_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     50a878:__serial_hw_data_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     515648:_serial_hw_data_available bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> pir1+0
;     515748:_serial_hw_data_ready bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> pir1+0
;     515b38:__serial_hw_data_raw_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     515858:__serial_hw_data_raw_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     517478:_delay_1us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     517688:_delay_2us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     517e58:_delay_3us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     518708:_delay_4us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     518ea8:_delay_5us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     519788:_delay_6us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     519f28:_delay_7us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     51a7f8:_delay_8us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     51af98:_delay_9us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     51b7f8:_instruction_time  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 20
;     51c1b8:_delay_10us_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     51ef28:_delay_1ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5231f8:_delay_100ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     525108:_delay_1s_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     527158:_ascii_null byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     5272c8:_ascii_soh byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     527438:_ascii_stx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 2
;     5275a8:_ascii_etx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     527718:_ascii_eot byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     527888:_ascii_enq byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     5279f8:_ascii_ack byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     527b68:_ascii_bel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 7
;     527cd8:_ascii_bs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 8
;     527e48:_ascii_ht byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 9
;     528108:_ascii_lf byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 10
;     528278:_ascii_vt byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 11
;     5283e8:_ascii_ff byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 12
;     528558:_ascii_cr byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 13
;     5286c8:_ascii_so byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 14
;     528838:_ascii_si byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 15
;     5289a8:_ascii_dle byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 16
;     528b18:_ascii_dc1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 17
;     528c88:_ascii_dc2 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 18
;     528df8:_ascii_dc3 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 19
;     528f68:_ascii_dc4 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 20
;     529108:_ascii_nak byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 21
;     529278:_ascii_syn byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 22
;     5293e8:_ascii_etb byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 23
;     529558:_ascii_can byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 24
;     5296c8:_ascii_em byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 25
;     529838:_ascii_sub byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 26
;     5299a8:_ascii_esc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 27
;     529b18:_ascii_fs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 28
;     529c88:_ascii_gs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 29
;     529df8:_ascii_rs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 30
;     529f68:_ascii_us byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 31
;     52a108:_ascii_sp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 32
;     52a278:_ascii_del byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 127
;     52a618:_toupper_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     52d258:_tolower_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     517108:__print_universal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     526e18:__print_suniversal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     52fe48:_print_byte_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     531188:_nibble2hex  (type=a dflags=C---- sz=16 use=22 assigned=0)
;      = 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70
;     51bd58:_print_prefix  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     52ff58:_print_crlf_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5305b8:_print_string_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     530e28:_print_bit_truefalse_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     534728:_print_bit_highlow_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5364d8:_print_bit_10_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5391b8:_print_dword_binary_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     53bcd8:_print_word_binary_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     541ca8:_print_nibble_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     545768:_print_dword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     54bcc8:_print_sdword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     551cb8:_print_word_hex_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     555a18:_print_byte_hex_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5582b8:_print_sdword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5591f8:_print_sword_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     55a1b8:_print_sword_fp_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     55c2b8:_print_sbyte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     55d1f8:_print_dword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     55e1b8:_print_word_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     55f108:_print_byte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     569f78:_str1_2  (type=a dflags=C---- lookup sz=27 use=1 assigned=0)
;      = 13,10,10,72,101,108,108,111,32,74,97,108,108,105,98,32,119,111,114,108,100,33,32,92,32,13,10
;     5679e8:__bitbucket  (type=i dflags=C---- sz=0 use=0 assigned=0)
;      = 0
;     539a28:__pic_temp  (type=i dflags=----- sz=2 use=5 assigned=7) ---> _pic_state+0
;     5363e8:__pic_pointer  (type=i dflags=----- sz=2 use=3 assigned=5 base=0022)
;     4ee4d8:__pic_state  (type=i dflags=----- sz=2 use=5 assigned=7 base=0020)
;     --- labels ---
;     _isr_cleanup (pc(0000) usage=0)
;     _isr_preamble (pc(0000) usage=0)
;     _main (pc(0023) usage=7)
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
;     _calculate_and_set_baudrate (pc(0028) usage=7)
;     serial_hw_init (pc(002c) usage=7)
;     serial_hw_disable (pc(0000) usage=0)
;     serial_hw_enable (pc(0000) usage=0)
;     serial_hw_write (pc(0035) usage=7)
;     serial_hw_write_word (pc(0000) usage=0)
;     _serial_hw_read (pc(0000) usage=0)
;     serial_hw_read (pc(0000) usage=0)
;     _serial_hw_data_put (pc(003b) usage=5)
;     _serial_hw_data_get (pc(0000) usage=0)
;     _serial_hw_data_raw_put (pc(0000) usage=0)
;     _serial_hw_data_raw_get (pc(0000) usage=0)
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
;     delay_1ms (pc(0042) usage=14)
;     delay_100ms (pc(0000) usage=0)
;     delay_1s (pc(0000) usage=0)
;     toupper (pc(0000) usage=0)
;     tolower (pc(0000) usage=0)
;     _print_universal_dec (pc(0000) usage=0)
;     _print_suniversal_dec (pc(0000) usage=0)
;     print_byte_binary (pc(0000) usage=0)
;     print_crlf (pc(0000) usage=0)
;     print_string (pc(0060) usage=7)
;     print_bit_truefalse (pc(0000) usage=0)
;     print_bit_highlow (pc(0000) usage=0)
;     print_bit_10 (pc(0000) usage=0)
;     print_dword_binary (pc(0000) usage=0)
;     print_word_binary (pc(0000) usage=0)
;     print_nibble_binary (pc(0000) usage=0)
;     print_dword_hex (pc(0000) usage=0)
;     print_sdword_hex (pc(0000) usage=0)
;     print_word_hex (pc(0000) usage=0)
;     print_byte_hex (pc(0000) usage=0)
;     print_sdword_dec (pc(0000) usage=0)
;     print_sword_dec (pc(0000) usage=0)
;     print_sword_fp_dec (pc(0000) usage=0)
;     print_sbyte_dec (pc(0000) usage=0)
;     print_dword_dec (pc(0000) usage=0)
;     print_word_dec (pc(0000) usage=0)
;     print_byte_dec (pc(0000) usage=0)
;     _pic_indirect (pc(0020) usage=12)
;     _pic_reset (pc(0000) usage=0)
;     _pic_isr (pc(0000) usage=0)
;     _pic_lookup (pc(0000) usage=0)
;     _lookup_str1_2 (pc(0004) usage=0)
;     {block enter}
;       --- records ---
;       --- variables ---
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         5304c8:_x_116 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=2) ---> _portc_shadow+0
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
;         55fee8:_x_117 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=2) ---> _portc_shadow+0
;         --- labels ---
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;         {block exit}
;       {block exit}
;     {block exit}
;   {block exit}
;      print_byte_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        55f2f8:__device_put_19  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55f3b8:_data_51  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        567108:__bitbucket_1  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_word_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        55e3a8:__device_put_18  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55e468:_data_49  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        566e98:__bitbucket_2  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_dword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        55d3e8:__device_put_17  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55d4a8:_data_47  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        565578:__bitbucket_3  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sbyte_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        55c4a8:__device_put_16  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55c568:_data_45  (type=i dflags=C-S-- sz=1 use=0 assigned=0)
;         = 0
;        563f08:__bitbucket_4  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_fp_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        55a3a8:__device_put_15  (type=* dflags=C---- sz=2 use=0 assigned=1)
;         = 0
;        55a468:_data_43  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        55a7c8:__temp_51  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5634f8:__bitbucket_5  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5593e8:__device_put_14  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5594a8:_data_41  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        561668:__bitbucket_6  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sdword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5584a8:__device_put_13  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        558538:_data_39  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        5605e8:__bitbucket_7  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_hex ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        555c08:__device_put_12  (type=* dflags=C---- sz=2 use=0 assigned=4)
;         = 0
;        555c98:_data_37  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        556aa8:__temp_50  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55f6e8:__bitbucket_8  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_word_hex ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        551ea8:__device_put_11  (type=* dflags=C---- sz=2 use=0 assigned=6)
;         = 0
;        551f38:_data_35  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        552d58:__temp_49  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        55f5e8:__bitbucket_9  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54beb8:__device_put_10  (type=* dflags=C---- sz=2 use=0 assigned=10)
;         = 0
;        54bf48:_data_33  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        54cd58:__temp_48  (type=i dflags=C---- sz=8 use=0 assigned=0)
;         = 0
;        55e798:__bitbucket_10  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_dword_hex ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        545958:__device_put_9  (type=* dflags=C---- sz=2 use=0 assigned=10)
;         = 0
;        545a18:_data_31  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        546878:__temp_47  (type=i dflags=C---- sz=8 use=0 assigned=0)
;         = 0
;        55e698:__bitbucket_11  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        541e98:__device_put_8  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        541f58:_data_29  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        542248:__floop6  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        542ab8:__temp_46  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        543208:__btemp_13  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        544b28:__btemp24  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        55d7d8:__bitbucket_12  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5432d8:__btemp23  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;      print_word_binary ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53bec8:__device_put_6  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        53bf88:_data_25  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53cc78:__temp_44  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55d6d8:__bitbucket_13  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_dword_binary ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5393a8:__device_put_5  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        539468:_data_23  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        53a158:__temp_43  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55c898:__bitbucket_14  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_bit_10 ----- --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        537d88:__device_put_4  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        537e48:_data_21  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        55c798:__bitbucket_15  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      print_bit_highlow ----- --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        534818:__device_put_3  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        534bd8:_data_19  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5366f8:_str1_1  (type=a dflags=C---- sz=4 use=0 assigned=0)
;         = 104,105,103,104
;        5365c8:_str0_1  (type=a dflags=C---- sz=3 use=0 assigned=0)
;         = 108,111,119
;        55b9e8:__bitbucket_16  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      print_bit_truefalse ----- --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        530f18:__device_put_2  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        534448:_data_17  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        534968:_str1  (type=a dflags=C---- sz=4 use=0 assigned=0)
;         = 116,114,117,101
;        534d28:_str0  (type=a dflags=C---- sz=5 use=0 assigned=0)
;         = 102,97,108,115,101
;        55b8e8:__bitbucket_17  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      print_string --D-- -U- (frame_sz=9 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5306a8:__device_put_1  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=2 base=0027)
;        530798:__str_count  (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0029)
;        530888:_str_1  (type=* dflags=----- auto ptr_lookup sz=2 use=2 assigned=0 base=002b)
;        530978:_len word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=002d)
;        530a68:_i byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=002f)
;        530d38:__btemp_11  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        530c48:__btemp20  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        55b678:__bitbucket_18  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_crlf ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5303d8:__device_put  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        55b518:__bitbucket_19  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_binary --D-- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53dc98:__device_put_7  (type=* dflags=C---- sz=2 use=0 assigned=4)
;         = 0
;        53dd58:_data_27  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53e958:__floop5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53f2f8:__temp_45  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53f948:__btemp_12  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        5411b8:__btemp22  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        55b1d8:__bitbucket_20  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          53fa18:__btemp21  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;      _print_suniversal_dec --D-- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        560208:__device_put_20  (type=* dflags=C---- sz=2 use=0 assigned=1)
;         = 0
;        5602c8:_data_53  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        560388:_digit_divisor_3  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        560448:_digit_number_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5606e8:__btemp_14  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5607b8:__btemp25  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        560ed8:__temp_52  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        55ae18:__bitbucket_21  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _print_universal_dec --D-- --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        562668:__device_put_21  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        562728:_data_55  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        5627e8:_digit_divisor_5  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        5628a8:_digit_number_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        562998:_digit  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        562a78:_no_digits_printed_yet  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        562ce8:__btemp_15  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;         = 0
;        562db8:__btemp26  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        564108:__btemp27  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        564858:__temp_53  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55ad18:__bitbucket_22  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          565cc8:__btemp28  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          566438:__btemp29  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          5667f8:__btemp30  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;        52d448:_char_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52d6b8:__btemp_10  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        52d788:__btemp17  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        52dd88:__btemp18  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        52e278:__btemp19  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        52ea98:__temp_42  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55a8a8:__bitbucket_23  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52a808:_char_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52aa78:__btemp_9  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        52ab48:__btemp14  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        52b228:__btemp15  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        52b5e8:__btemp16  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        52be08:__temp_41  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55a698:__bitbucket_24  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      delay_1s ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5252f8:_n_7  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        525898:__1_s_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 999998
;        5254e8:__floop4  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5256c8:__btemp_8  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        526598:__btemp13  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5597d8:__bitbucket_25  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      delay_100ms ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5233e8:_n_5  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        523928:__100_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 99998
;        523578:__floop3  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        523758:__btemp_7  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        524648:__btemp12  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5596d8:__bitbucket_26  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      delay_1ms --D-- -U- (frame_sz=4 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        521188:_n_3 word (type=i dflags=----- auto sz=2 use=2 assigned=4 base=0027)
;        5216c8:__one_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 998
;        521318:__floop2  (type=i dflags=----- auto sz=2 use=4 assigned=4 base=0029)
;        522108:__btemp_6  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5214f8:__btemp11  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        558868:__bitbucket_27  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        51c3a8:_n_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        51c5b8:__btemp_5  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        51c688:__btemp8  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        51d108:__btemp9  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        51d708:__temp_40  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        558768:__bitbucket_28  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          51dab8:__ten_us_delay1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 7
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          51f108:__ten_us_delay2  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 5
;          51faf8:__ten_us_delay3  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 9
;          51ed48:__floop1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          516f08:__btemp10  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
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
;        5577e8:__bitbucket_29  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_8us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        557618:__bitbucket_30  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_7us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        557108:__bitbucket_31  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_6us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        556818:__bitbucket_32  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_5us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        556b88:__bitbucket_33  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_4us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        556978:__bitbucket_34  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_3us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        556338:__bitbucket_35  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_2us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        556108:__bitbucket_36  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_1us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        554f88:__bitbucket_37  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_raw_get ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        554db8:__bitbucket_38  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_raw_put ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        515d28:_data_12  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5549a8:__bitbucket_39  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_get ----- --- (frame_sz=0 blocks=6)
;      {block enter}
;        --- records ---
;        --- variables ---
;        512e48:_data_10  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        513228:__btemp_4  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        5132f8:__btemp6  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        514a18:__btemp7  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        554448:__bitbucket_40  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      _serial_hw_data_put ---I- F-- (frame_sz=1 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        512528:_data_9 byte (type=i dflags=----- auto sticky sz=1 use=1 assigned=1 base=0024)
;        554708:__bitbucket_41  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_read ----- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        510298:_data_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        510408:__btemp_3  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5104d8:__btemp5  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5545a8:__bitbucket_42  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        50e6f8:_data_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        553ed8:__bitbucket_43  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        50c3e8:_data_3  (type=i dflags=C---- sz=2 use=2 assigned=0)
;         = 0
;        50c4a8:_dx  (type=a dflags=----- sz=2 use=0 assigned=0) ---> __data3
;        50c7d8:__btemp_2  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        50c8a8:__btemp3  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        50d5f8:__btemp4  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        553978:__bitbucket_44  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      serial_hw_write V-D-- --- (frame_sz=1 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        50ad38:_data_1 byte (type=i dflags=----- auto sticky sz=1 use=1 assigned=1 base=0025)
;        50a3a8:__btemp_1  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        50b108:__btemp2  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        553c38:__bitbucket_45  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        553ad8:__bitbucket_46  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_disable ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5091f8:__btemp  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5092c8:__btemp1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        553468:__bitbucket_47  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        552ac8:__bitbucket_48  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _calculate_and_set_baudrate --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5049b8:_max_deviation  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 5
;        5048e8:_usart_div  (type=i dflags=C---U sz=4 use=1 assigned=0)
;         = 10
;        504c08:_real_baud  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 113636
;        552e38:__bitbucket_49  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      enable_digital_io ----L --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        552c28:__bitbucket_50  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5525e8:__bitbucket_51  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5523b8:__bitbucket_52  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f5fa8:__temp_39  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5512d8:__bitbucket_53  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        551108:__bitbucket_54  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f38d8:__temp_37  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        550c48:__bitbucket_55  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5506e8:__bitbucket_56  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ef5f8:__temp_35  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5509a8:__bitbucket_57  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        550848:__bitbucket_58  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ecd08:__temp_33  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5502d8:__bitbucket_59  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54dfa8:__bitbucket_60  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e7fa8:__temp_31  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        540fa8:__bitbucket_61  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54ffa8:__bitbucket_62  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e58d8:__temp_29  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        54fd18:__bitbucket_63  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54f7b8:__bitbucket_64  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e1498:__temp_27  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        54fa78:__bitbucket_65  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54f918:__bitbucket_66  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ded08:__temp_25  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        54f3a8:__bitbucket_67  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54edb8:__bitbucket_68  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4da538:__temp_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        54f108:__bitbucket_69  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54ef18:__bitbucket_70  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d7c68:__temp_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        54e9a8:__bitbucket_71  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54e448:__bitbucket_72  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_e0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cccf8:_x_95 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _porte_shadow
;        54e708:__bitbucket_73  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54e5a8:__bitbucket_74  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54ded8:__bitbucket_75  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54d978:__bitbucket_76  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54dc38:__bitbucket_77  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54dad8:__bitbucket_78  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54d468:__bitbucket_79  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54cac8:__bitbucket_80  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54ce38:__bitbucket_81  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_d0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c23a8:_x_83 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portd_shadow
;        54cc28:__bitbucket_82  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54c5e8:__bitbucket_83  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54c3b8:__bitbucket_84  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54b2d8:__bitbucket_85  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54b108:__bitbucket_86  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54abd8:__bitbucket_87  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54a678:__bitbucket_88  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54a938:__bitbucket_89  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54a7d8:__bitbucket_90  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54a268:__bitbucket_91  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        549bf8:__bitbucket_92  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        549eb8:__bitbucket_93  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        549d58:__bitbucket_94  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5497e8:__bitbucket_95  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_c0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b3108:_x_61 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portc_shadow+0
;        549288:__bitbucket_96  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        549548:__bitbucket_97  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5493e8:__bitbucket_98  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        548d68:__bitbucket_99  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        548808:__bitbucket_100  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        548ac8:__bitbucket_101  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        548968:__bitbucket_102  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5483f8:__bitbucket_103  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        547e48:__bitbucket_104  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        548158:__bitbucket_105  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        547fa8:__bitbucket_106  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        547a38:__bitbucket_107  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5474d8:__bitbucket_108  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        547798:__bitbucket_109  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_b0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a32f8:_x_39 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portb_shadow
;        547638:__bitbucket_110  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        546df8:__bitbucket_111  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5465e8:__bitbucket_112  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        546958:__bitbucket_113  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        546748:__bitbucket_114  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        546108:__bitbucket_115  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        545da8:__bitbucket_116  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        542128:__bitbucket_117  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        544308:__bitbucket_118  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        543d58:__bitbucket_119  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        543918:__bitbucket_120  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        542b98:__bitbucket_121  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        542988:__bitbucket_122  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        542328:__bitbucket_123  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_a0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4942f8:_x_17 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _porta_shadow
;        53e838:__bitbucket_124  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        540838:__bitbucket_125  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5403e8:__bitbucket_126  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        535fa8:__bitbucket_127  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53f3d8:__bitbucket_128  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53f1c8:__bitbucket_129  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53ea38:__bitbucket_130  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53e408:__bitbucket_131  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53e1d8:__bitbucket_132  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53cd58:__bitbucket_133  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53cb48:__bitbucket_134  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53c5e8:__bitbucket_135  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
; --- call stack ---
; {root} (depth=0)
;   delay_1ms (depth=1)
;   delay_1ms (depth=1)
;   print_string (depth=1)
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
;460d08:_l62(use=0:ref=2:pc=0000)
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
;503818:_l223(use=0:ref=1:pc=0000)
;504208:_l224(use=0:ref=1:pc=0000)
;5045d8:_l225(use=0:ref=2:pc=0000)
;504638:_l226(use=0:ref=2:pc=0000)
;504a78:_l227(use=0:ref=1:pc=0000)
;504b28:_l228(use=0:ref=1:pc=0000)
;504b88:_l229(use=0:ref=1:pc=0000)
;505678:_l230(use=0:ref=1:pc=0000)
;505c98:_l231(use=0:ref=1:pc=0000)
;505e28:_l232(use=0:ref=1:pc=0000)
;505e88:_l233(use=0:ref=1:pc=0000)
;505b08:_l234(use=0:ref=1:pc=0000)
;506288:_l235(use=0:ref=1:pc=0000)
;506418:_l236(use=0:ref=1:pc=0000)
;507568:_l237(use=0:ref=2:pc=0000)
;5075c8:_l238(use=0:ref=2:pc=0000)
;508c78:_l239(use=0:ref=2:pc=0000)
;508cd8:_l240(use=0:ref=2:pc=0000)
;508f78:_l241(use=0:ref=1:pc=0000)
;508278:_l242(use=0:ref=1:pc=0000)
;508568:_l243(use=0:ref=1:pc=0000)
;509fc8:_l244(use=0:ref=2:pc=0000)
;509988:_l245(use=0:ref=2:pc=0000)
;50a9f8:_l246(use=0:ref=2:pc=0000)
;50aa58:_l247(use=0:ref=2:pc=0000)
;50ade8:_l248(use=7:ref=3:pc=0036)
;50ae48:_l249(use=7:ref=3:pc=0038)
;50aea8:_l250(use=0:ref=1:pc=0000)
;50bf98:_l251(use=0:ref=2:pc=0000)
;50c108:_l252(use=0:ref=2:pc=0000)
;50c628:_l253(use=0:ref=1:pc=0000)
;50c688:_l254(use=0:ref=1:pc=0000)
;50c6e8:_l255(use=0:ref=1:pc=0000)
;50d428:_l256(use=0:ref=1:pc=0000)
;50d488:_l257(use=0:ref=1:pc=0000)
;50d4e8:_l258(use=0:ref=1:pc=0000)
;50e3b8:_l259(use=0:ref=2:pc=0000)
;50e418:_l260(use=0:ref=2:pc=0000)
;50e7a8:_l261(use=0:ref=1:pc=0000)
;50e868:_l262(use=0:ref=1:pc=0000)
;50f688:_l263(use=0:ref=1:pc=0000)
;50f768:_l264(use=0:ref=1:pc=0000)
;504ee8:_l265(use=0:ref=2:pc=0000)
;505478:_l266(use=0:ref=2:pc=0000)
;510c18:_l267(use=0:ref=1:pc=0000)
;510f58:_l268(use=0:ref=1:pc=0000)
;511558:_l269(use=0:ref=1:pc=0000)
;511628:_l270(use=0:ref=1:pc=0000)
;5118b8:_l271(use=0:ref=1:pc=0000)
;5121e8:_l272(use=0:ref=2:pc=0000)
;512248:_l273(use=0:ref=2:pc=0000)
;512b28:_l274(use=0:ref=2:pc=0000)
;512b88:_l275(use=0:ref=2:pc=0000)
;512ef8:_l276(use=0:ref=1:pc=0000)
;512f58:_l277(use=0:ref=1:pc=0000)
;512fb8:_l278(use=0:ref=1:pc=0000)
;513a38:_l279(use=0:ref=1:pc=0000)
;513d78:_l280(use=0:ref=1:pc=0000)
;5143c8:_l281(use=0:ref=1:pc=0000)
;514498:_l282(use=0:ref=1:pc=0000)
;514728:_l283(use=0:ref=1:pc=0000)
;5159e8:_l284(use=0:ref=2:pc=0000)
;515a48:_l285(use=0:ref=2:pc=0000)
;5165c8:_l286(use=7:ref=4:pc=0040)
;516628:_l287(use=0:ref=2:pc=0000)
;517328:_l288(use=0:ref=2:pc=0000)
;517388:_l289(use=0:ref=2:pc=0000)
;517b58:_l290(use=0:ref=2:pc=0000)
;517bb8:_l291(use=0:ref=2:pc=0000)
;518408:_l292(use=0:ref=2:pc=0000)
;518468:_l293(use=0:ref=2:pc=0000)
;518ba8:_l294(use=0:ref=2:pc=0000)
;518c08:_l295(use=0:ref=2:pc=0000)
;519488:_l296(use=0:ref=2:pc=0000)
;5194e8:_l297(use=0:ref=2:pc=0000)
;519c28:_l298(use=0:ref=2:pc=0000)
;519c88:_l299(use=0:ref=2:pc=0000)
;51a4f8:_l300(use=0:ref=2:pc=0000)
;51a558:_l301(use=0:ref=2:pc=0000)
;51ac98:_l302(use=0:ref=2:pc=0000)
;51acf8:_l303(use=0:ref=2:pc=0000)
;51b4f8:_l304(use=0:ref=2:pc=0000)
;51b558:_l305(use=0:ref=2:pc=0000)
;51bc08:_l306(use=0:ref=2:pc=0000)
;51bdb8:_l307(use=0:ref=2:pc=0000)
;51c458:_l308(use=0:ref=1:pc=0000)
;51caf8:_l309(use=0:ref=1:pc=0000)
;51d478:_l310(use=0:ref=1:pc=0000)
;51dca8:_l311(use=0:ref=1:pc=0000)
;51de68:_l312(use=0:ref=1:pc=0000)
;51f2f8:_l313(use=0:ref=1:pc=0000)
;51f4b8:_l314(use=0:ref=1:pc=0000)
;504948:_l315(use=0:ref=1:pc=0000)
;5054e8:_l316(use=0:ref=1:pc=0000)
;505708:_l317(use=0:ref=1:pc=0000)
;515fb8:_l318(use=0:ref=1:pc=0000)
;516d08:_l319(use=0:ref=1:pc=0000)
;520d48:_l320(use=0:ref=2:pc=0000)
;520da8:_l321(use=0:ref=2:pc=0000)
;521c28:_l322(use=7:ref=3:pc=0045)
;521c88:_l323(use=7:ref=3:pc=0057)
;521ce8:_l324(use=0:ref=1:pc=0000)
;521ed8:_l325(use=0:ref=1:pc=0000)
;522208:_l326(use=0:ref=1:pc=0000)
;522248:_l327(use=0:ref=2:pc=0000)
;523108:_l328(use=0:ref=2:pc=0000)
;523e88:_l329(use=0:ref=1:pc=0000)
;523ee8:_l330(use=0:ref=1:pc=0000)
;523f48:_l331(use=0:ref=1:pc=0000)
;524e88:_l332(use=0:ref=2:pc=0000)
;524ee8:_l333(use=0:ref=2:pc=0000)
;525df8:_l334(use=0:ref=1:pc=0000)
;525e58:_l335(use=0:ref=1:pc=0000)
;525eb8:_l336(use=0:ref=1:pc=0000)
;52a4c8:_l337(use=0:ref=2:pc=0000)
;52a528:_l338(use=0:ref=2:pc=0000)
;52a8b8:_l339(use=0:ref=1:pc=0000)
;52ba58:_l340(use=0:ref=1:pc=0000)
;52d108:_l341(use=0:ref=2:pc=0000)
;52d168:_l342(use=0:ref=2:pc=0000)
;52d4f8:_l343(use=0:ref=1:pc=0000)
;52e6e8:_l344(use=0:ref=1:pc=0000)
;462538:_l345(use=14:ref=5:pc=0080)
;4627d8:_l346(use=0:ref=2:pc=0000)
;51d668:_l347(use=0:ref=2:pc=0000)
;51d7d8:_l348(use=0:ref=2:pc=0000)
;527c38:_l349(use=0:ref=2:pc=0000)
;527f18:_l350(use=0:ref=2:pc=0000)
;5316e8:_l351(use=0:ref=2:pc=0000)
;531748:_l352(use=0:ref=2:pc=0000)
;532238:_l353(use=0:ref=2:pc=0000)
;532298:_l354(use=0:ref=2:pc=0000)
;532ca8:_l355(use=7:ref=3:pc=0066)
;532d08:_l356(use=7:ref=3:pc=0078)
;532d68:_l357(use=0:ref=1:pc=0000)
;532f58:_l358(use=0:ref=1:pc=0000)
;534108:_l359(use=0:ref=2:pc=0000)
;534168:_l360(use=0:ref=2:pc=0000)
;534de8:_l361(use=0:ref=1:pc=0000)
;534e88:_l362(use=0:ref=1:pc=0000)
;535db8:_l363(use=0:ref=2:pc=0000)
;535e18:_l364(use=0:ref=2:pc=0000)
;536998:_l365(use=0:ref=1:pc=0000)
;536a38:_l366(use=0:ref=1:pc=0000)
;537aa8:_l367(use=0:ref=2:pc=0000)
;537b08:_l368(use=0:ref=2:pc=0000)
;537f28:_l369(use=0:ref=1:pc=0000)
;537178:_l370(use=0:ref=1:pc=0000)
;538f28:_l371(use=0:ref=2:pc=0000)
;538f88:_l372(use=0:ref=2:pc=0000)
;539548:_l373(use=0:ref=1:pc=0000)
;539638:_l374(use=0:ref=1:pc=0000)
;53bb88:_l375(use=0:ref=2:pc=0000)
;53bbe8:_l376(use=0:ref=2:pc=0000)
;53c108:_l377(use=0:ref=1:pc=0000)
;53c1f8:_l378(use=0:ref=1:pc=0000)
;53de38:_l379(use=0:ref=1:pc=0000)
;53df28:_l380(use=0:ref=1:pc=0000)
;53ed98:_l381(use=0:ref=1:pc=0000)
;53edf8:_l382(use=0:ref=1:pc=0000)
;53ee58:_l383(use=0:ref=1:pc=0000)
;53f108:_l384(use=0:ref=1:pc=0000)
;53fe98:_l385(use=0:ref=1:pc=0000)
;541b58:_l386(use=0:ref=2:pc=0000)
;541bb8:_l387(use=0:ref=2:pc=0000)
;542688:_l388(use=0:ref=1:pc=0000)
;5426e8:_l389(use=0:ref=1:pc=0000)
;542748:_l390(use=0:ref=1:pc=0000)
;5428c8:_l391(use=0:ref=1:pc=0000)
;543758:_l392(use=0:ref=1:pc=0000)
;545618:_l393(use=0:ref=2:pc=0000)
;545678:_l394(use=0:ref=2:pc=0000)
;545af8:_l395(use=0:ref=1:pc=0000)
;545be8:_l396(use=0:ref=1:pc=0000)
;54bb78:_l397(use=0:ref=2:pc=0000)
;54bbd8:_l398(use=0:ref=2:pc=0000)
;54c108:_l399(use=0:ref=1:pc=0000)
;54c1f8:_l400(use=0:ref=1:pc=0000)
;551b68:_l401(use=0:ref=2:pc=0000)
;551bc8:_l402(use=0:ref=2:pc=0000)
;552108:_l403(use=0:ref=1:pc=0000)
;5521f8:_l404(use=0:ref=1:pc=0000)
;5558c8:_l405(use=0:ref=2:pc=0000)
;555928:_l406(use=0:ref=2:pc=0000)
;555d78:_l407(use=0:ref=1:pc=0000)
;555e68:_l408(use=0:ref=1:pc=0000)
;558168:_l409(use=0:ref=2:pc=0000)
;5581c8:_l410(use=0:ref=2:pc=0000)
;558fc8:_l411(use=0:ref=2:pc=0000)
;559108:_l412(use=0:ref=2:pc=0000)
;559f48:_l413(use=0:ref=2:pc=0000)
;559fa8:_l414(use=0:ref=2:pc=0000)
;55c168:_l415(use=0:ref=2:pc=0000)
;55c1c8:_l416(use=0:ref=2:pc=0000)
;55c628:_l417(use=0:ref=2:pc=0000)
;55d108:_l418(use=0:ref=2:pc=0000)
;55df38:_l419(use=0:ref=2:pc=0000)
;55df98:_l420(use=0:ref=2:pc=0000)
;55eef8:_l421(use=0:ref=2:pc=0000)
;55ef58:_l422(use=0:ref=2:pc=0000)
;560528:_l423(use=0:ref=1:pc=0000)
;560c38:_l424(use=0:ref=1:pc=0000)
;562b28:_l425(use=0:ref=1:pc=0000)
;563338:_l426(use=0:ref=1:pc=0000)
;563d28:_l427(use=0:ref=1:pc=0000)
;563d88:_l428(use=0:ref=1:pc=0000)
;563de8:_l429(use=0:ref=1:pc=0000)
;565b18:_l430(use=0:ref=1:pc=0000)
;566c78:_l431(use=0:ref=1:pc=0000)
;56a148:_l432(use=7:ref=3:pc=0080)
;56a1a8:_l433(use=0:ref=1:pc=0000)
;56aa98:_l434(use=0:ref=1:pc=0000)
;56ac48:_l435(use=0:ref=1:pc=0000)
;56b418:_l436(use=0:ref=1:pc=0000)
;56b5c8:_l437(use=0:ref=1:pc=0000)
;54b908:_l438(use=3:ref=1:pc=0058)
;54b168:_l439(use=3:ref=1:pc=005a)
;578558:_l440(use=3:ref=1:pc=0049)
;5785b8:_l441(use=3:ref=1:pc=004b)
;Unnamed Constant Variables
;============
