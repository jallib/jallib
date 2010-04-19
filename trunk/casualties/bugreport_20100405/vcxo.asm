; compiler: jal 2.4n-beta (compiled Mar 13 2010)

; command line:  c:\jallib\compiler\jalv2.exe vcxo.jal -long-start -debug -s "c:\jallib\include;c:\jallib\include\device;c:\jallib\include\external;c:\jallib\include\external\adc;c:\jallib\include\external\can;c:\jallib\include\external\co2;c:\jallib\include\external\humidity;c:\jallib\include\external\keyboard;c:\jallib\include\external\lcd;c:\jallib\include\external\media;c:\jallib\include\external\motor;c:\jallib\include\external\motor\dc;c:\jallib\include\external\motor\period_skip;c:\jallib\include\external\motor\servo;c:\jallib\include\external\motor\stepper;c:\jallib\include\external\ranger;c:\jallib\include\external\ranger\ir;c:\jallib\include\external\ranger\us;c:\jallib\include\external\rtc;c:\jallib\include\external\seven_segment;c:\jallib\include\external\storage;c:\jallib\include\external\storage\eeprom;c:\jallib\include\external\storage\harddisk;c:\jallib\include\external\storage\ram;c:\jallib\include\external\storage\ram\23k256;c:\jallib\include\external\storage\sd_card;c:\jallib\include\external\temperature;c:\jallib\include\filesystem;c:\jallib\include\jal;c:\jallib\include\peripheral;c:\jallib\include\peripheral\adc;c:\jallib\include\peripheral\can;c:\jallib\include\peripheral\comparator;c:\jallib\include\peripheral\data_eeprom;c:\jallib\include\peripheral\flash_memory;c:\jallib\include\peripheral\i2c;c:\jallib\include\peripheral\pwm;c:\jallib\include\peripheral\spi;c:\jallib\include\peripheral\timer;c:\jallib\include\peripheral\usart;c:\jallib\include\peripheral\usb;c:\jallib\include\protocol;c:\jallib\test;c:\jallib\test\board;c:\jallib\test\external;c:\jallib\test\external\keyboard;c:\jallib\test\external\lcd;c:\jallib\test\external\ranger;c:\jallib\test\external\ranger\ir;c:\jallib\test\external\rtc;c:\jallib\test\external\seven_segment;c:\jallib\test\jal;c:\jallib\test\peripheral;c:\jallib\test\peripheral\adc;c:\jallib\test\peripheral\comparator;c:\jallib\test\peripheral\data_eeprom;c:\jallib\test\peripheral\flash_memory;c:\jallib\test\peripheral\i2c;c:\jallib\test\peripheral\pwm;c:\jallib\test\peripheral\spi;c:\jallib\test\peripheral\timer;c:\jallib\test\peripheral\usart;c:\jallib\test\peripheral\usb;c:\jallib\test\unittest;"
; compiler flags:
;    boot-fuse, boot-long-start, debug-compiler, debug-codegen
;    opt-expr-reduce, opt-cexpr-reduce, opt-variable-reduce
;    warn-backend, warn-conversion, warn-misc, warn-range
;    warn-stack-overflow, warn-truncate
                                list p=16f690, r=dec
                                errorlevel -306 ; no page boundary warnings
                                errorlevel -302 ; no bank 0 warnings
                                errorlevel -202 ; no 'argument out of range' warnings

                             __config 0x3ff6
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
v_enabled                      EQU 1
v_output                       EQU 0
v__pic_isr_w                   EQU 0x007f  ; _pic_isr_w
v__ind                         EQU 0x0000  ; _ind
v__pcl                         EQU 0x0002  ; _pcl
v__status                      EQU 0x0003  ; _status
v__irp                         EQU 7
v__z                           EQU 2
v__c                           EQU 0
v__fsr                         EQU 0x0004  ; _fsr
v_porta                        EQU 0x0005  ; porta
v__porta_shadow                EQU 0x0041  ; _porta_shadow
v_pin_a2                       EQU 0x0005  ; pin_a2-->porta:2
v__pclath                      EQU 0x000a  ; _pclath
v_intcon                       EQU 0x000b  ; intcon
v_intcon_gie                   EQU 0x000b  ; intcon_gie-->intcon:7
v_intcon_peie                  EQU 0x000b  ; intcon_peie-->intcon:6
v_pir1                         EQU 0x000c  ; pir1
v_pir1_rcif                    EQU 0x000c  ; pir1_rcif-->pir1:5
v_pir1_txif                    EQU 0x000c  ; pir1_txif-->pir1:4
v_pir1_tmr2if                  EQU 0x000c  ; pir1_tmr2if-->pir1:1
v_t2con                        EQU 0x0012  ; t2con
v_t2con_tmr2on                 EQU 0x0012  ; t2con_tmr2on-->t2con:2
v_ccpr1l                       EQU 0x0015  ; ccpr1l
v_ccp1con                      EQU 0x0017  ; ccp1con
v_rcsta                        EQU 0x0018  ; rcsta
v_rcsta_spen                   EQU 0x0018  ; rcsta_spen-->rcsta:7
v_rcsta_cren                   EQU 0x0018  ; rcsta_cren-->rcsta:4
v_rcsta_ferr                   EQU 0x0018  ; rcsta_ferr-->rcsta:2
v_rcsta_oerr                   EQU 0x0018  ; rcsta_oerr-->rcsta:1
v_txreg                        EQU 0x0019  ; txreg
v_rcreg                        EQU 0x001a  ; rcreg
v_adcon0                       EQU 0x001f  ; adcon0
v_option_reg                   EQU 0x0081  ; option_reg
v_option_reg_nrapu             EQU 0x0081  ; option_reg_nrapu-->option_reg:7
v_trisa                        EQU 0x0085  ; trisa
v_pin_a2_direction             EQU 0x0085  ; pin_a2_direction-->trisa:2
v_trisc                        EQU 0x0087  ; trisc
v_pin_c5_direction             EQU 0x0087  ; pin_c5_direction-->trisc:5
v_pie1                         EQU 0x008c  ; pie1
v_pie1_rcie                    EQU 0x008c  ; pie1_rcie-->pie1:5
v_pie1_txie                    EQU 0x008c  ; pie1_txie-->pie1:4
v_pie1_tmr2ie                  EQU 0x008c  ; pie1_tmr2ie-->pie1:1
v_pr2                          EQU 0x0092  ; pr2
v_wpua                         EQU 0x0095  ; wpua
v_txsta                        EQU 0x0098  ; txsta
v_txsta_txen                   EQU 0x0098  ; txsta_txen-->txsta:5
v_txsta_brgh                   EQU 0x0098  ; txsta_brgh-->txsta:2
v_spbrg                        EQU 0x0099  ; spbrg
v_spbrgh                       EQU 0x009a  ; spbrgh
v_baudctl                      EQU 0x009b  ; baudctl
v_baudctl_brg16                EQU 0x009b  ; baudctl_brg16-->baudctl:3
v_adcon1                       EQU 0x009f  ; adcon1
v_cm1con0                      EQU 0x0119  ; cm1con0
v_cm2con0                      EQU 0x011a  ; cm2con0
v_ansel                        EQU 0x011e  ; ansel
v_anselh                       EQU 0x011f  ; anselh
v_dummy                        EQU 0x006a  ; dummy-->_bitbucket:0
v_serial_xmtbufsize            EQU 80
v_serial_rcvbufsize            EQU 12
v_serial_delta                 EQU 17
v__serial_xmtbuf               EQU 0x00a0  ; _serial_xmtbuf
v__serial_rcvbuf               EQU 0x0042  ; _serial_rcvbuf
v__serial_offsetxmthead        EQU 0x004e  ; _serial_offsetxmthead
v__serial_offsetxmttail        EQU 0x004f  ; _serial_offsetxmttail
v__serial_offsetrcvhead        EQU 0x0050  ; _serial_offsetrcvhead
v__serial_offsetrcvtail        EQU 0x0051  ; _serial_offsetrcvtail
v_serial_send_success          EQU 0x006a  ; serial_send_success-->_bitbucket:1
v_ascii_lf                     EQU 10
v_ascii_cr                     EQU 13
v_gpsinbuffer                  EQU 0x0052  ; gpsinbuffer
v_gpsinbufferindex             EQU 0x0066  ; gpsinbufferindex
v_gpsfieldnr                   EQU 0x0067  ; gpsfieldnr
v_gpserrorcode                 EQU 0x0068  ; gpserrorcode
v_ticks                        EQU 0x0037  ; ticks
v__floop7                      EQU 0x0069  ; _floop7
v__bitbucket                   EQU 0x006a  ; _bitbucket
v__pic_isr_fsr                 EQU 0x0036  ; _pic_isr_fsr
v__pic_isr_status              EQU 0x0030  ; _pic_isr_status
v__pic_isr_pclath              EQU 0x0031  ; _pic_isr_pclath
v__pic_temp                    EQU 0x0020  ; _pic_temp-->_pic_state
v__pic_pointer                 EQU 0x0034  ; _pic_pointer
v__pic_loop                    EQU 0x0032  ; _pic_loop
v__pic_divisor                 EQU 0x0028  ; _pic_divisor-->_pic_state+8
v__pic_dividend                EQU 0x0020  ; _pic_dividend-->_pic_state
v__pic_quotient                EQU 0x002c  ; _pic_quotient-->_pic_state+12
v__pic_remainder               EQU 0x0024  ; _pic_remainder-->_pic_state+4
v__pic_divaccum                EQU 0x0020  ; _pic_divaccum-->_pic_state
v__pic_sign                    EQU 0x0033  ; _pic_sign
v__pic_state                   EQU 0x0020  ; _pic_state
v__btemp80                     EQU 0x006a  ; _btemp80-->_bitbucket:2
v___x_69                       EQU 0x0041  ; x-->_porta_shadow:2
v___char_7                     EQU 0x006c  ; char
v____btemp68_1                 EQU 0x006a  ; _btemp68-->_bitbucket:4
v____btemp74_1                 EQU 0x006a  ; _btemp74-->_bitbucket:10
v___duty_1                     EQU 0x006d  ; setdutycycle:duty
v____temp_46                   EQU 0       ; gpstakt(): _temp
v__btemp62                     EQU 0x006d  ; parsemessageid:_btemp62-->_bitbucket4:0
v__btemp63                     EQU 0x006d  ; parsemessageid:_btemp63-->_bitbucket4:1
v__btemp64                     EQU 0x006d  ; parsemessageid:_btemp64-->_bitbucket4:2
v__btemp65                     EQU 0x006d  ; parsemessageid:_btemp65-->_bitbucket4:3
v__btemp66                     EQU 0x006d  ; parsemessageid:_btemp66-->_bitbucket4:4
v__btemp67                     EQU 0x006d  ; parsemessageid:_btemp67-->_bitbucket4:5
v____bitbucket_4               EQU 0x006d  ; parsemessageid:_bitbucket
v___name_1                     EQU 0x0120  ; ismsg:name
v___i_2                        EQU 0x0124  ; ismsg:i
v___char_5                     EQU 0x006d  ; storebytes:char
v___n_3                        EQU 0x006d  ; delay_1ms:n
v__floop4                      EQU 0x0122  ; delay_1ms:_floop4
v____device_put_19             EQU 0x006d  ; print_byte_dec:_device_put
v___data_49                    EQU 0x0122  ; print_byte_dec:data
v____device_put_1              EQU 0x006d  ; print_string:_device_put
v__str_count                   EQU 0x0122  ; print_string:_str_count
v___str_1                      EQU 0x0126  ; print_string:str
v_len                          EQU 0x012c  ; print_string:len
v_i                            EQU 0x006f  ; print_string:i
v__device_put                  EQU 0x006d  ; print_crlf:_device_put
v____device_put_21             EQU 0x0124  ; _print_universal_dec:_device_put
v___data_53                    EQU 0x0128  ; _print_universal_dec:data
v___digit_divisor_5            EQU 0x012e  ; _print_universal_dec:digit_divisor
v___digit_number_5             EQU 0x0132  ; _print_universal_dec:digit_number
v_digit                        EQU 0x0133  ; _print_universal_dec:digit
v_no_digits_printed_yet        EQU 0x0135  ; _print_universal_dec:no_digits_printed_yet-->_bitbucket42:0
v____temp_42                   EQU 0x0134  ; _print_universal_dec:_temp
v____bitbucket_42              EQU 0x0135  ; _print_universal_dec:_bitbucket
v__btemp48                     EQU 0x0135  ; _print_universal_dec:_btemp48-->_bitbucket42:3
v__btemp49                     EQU 0x0135  ; _print_universal_dec:_btemp49-->_bitbucket42:4
v__btemp50                     EQU 0x0135  ; _print_universal_dec:_btemp50-->_bitbucket42:5
v____temp_29                   EQU 0       ; serial_hw_write(): _temp
v___data_7                     EQU 0x003d  ; _serial_hw_data_put:data
v____temp_28                   EQU 0       ; _serial_hw_data_put(): _temp
v___data_5                     EQU 0x003e  ; serial_send_byte:data
v_newxmthead                   EQU 0x003f  ; serial_send_byte:newxmthead
v__btemp23                     EQU 0x0040  ; serial_send_byte:_btemp23-->_bitbucket50:0
v__btemp24                     EQU 0x0040  ; serial_send_byte:_btemp24-->_bitbucket50:1
v__btemp25                     EQU 0x0040  ; serial_send_byte:_btemp25-->_bitbucket50:2
v____bitbucket_50              EQU 0x0040  ; serial_send_byte:_bitbucket
v___data_1                     EQU 0x006d  ; serial_hw_read:data
v___x_68                       EQU 0x0120  ; serial_hw_read:x
v____temp_26                   EQU 0x0122  ; serial_hw_read:_temp
v___x_67                       EQU 0x0039  ; _serial_receive_interrupt_handler:x
v____temp_25                   EQU 0x003a  ; _serial_receive_interrupt_handler:_temp
v____bitbucket_53              EQU 0x003b  ; _serial_receive_interrupt_handler:_bitbucket
v__btemp8                      EQU 0x003b  ; _serial_receive_interrupt_handler:_btemp8-->_bitbucket53:1
v__btemp9                      EQU 0x003b  ; _serial_receive_interrupt_handler:_btemp9-->_bitbucket53:2
v__btemp10                     EQU 0x003b  ; _serial_receive_interrupt_handler:_btemp10-->_bitbucket53:3
v___x_66                       EQU 0x0039  ; _serial_transmit_interrupt_handler:x
v__btemp1                      EQU 0x003a  ; _serial_transmit_interrupt_handler:_btemp1-->_bitbucket54:0
v__btemp2                      EQU 0x003a  ; _serial_transmit_interrupt_handler:_btemp2-->_bitbucket54:1
v__btemp3                      EQU 0x003a  ; _serial_transmit_interrupt_handler:_btemp3-->_bitbucket54:2
v____bitbucket_54              EQU 0x003a  ; _serial_transmit_interrupt_handler:_bitbucket
v_usart_div                    EQU 520     ; _calculate_and_set_baudrate(): usart_div
;   22 include 16f690
                               org      0                   ;  0 -- -- -- [-- --] 0000
                               branchhi_clr l__main         ;  0 -V rs rs [hl hl] 0000 120a
                               branchlo_clr l__main         ;  0 -V rs rs [hl hl] 0001 118a
                               goto     l__main             ;  0 -V rs rs [hl hl] 0002 28c1
                               nop                          ; 4294967295 -- -- -- [-- --] 0003 0000
                               org      4                   ; 4294967295 -- -- -- [-- --] 0004
                               movwf    v__pic_isr_w        ; 4294967295 -V rs rs [hl hl] 0004 00ff
                               swapf    v__status,w         ; 4294967295 -V rs rs [hl hl] 0005 0e03
                               clrf     v__status           ; 4294967295 -V rs rs [hl hl] 0006 0183
                               movwf    v__pic_isr_status   ; 4294967295 -V rs rs [hl hl] 0007 00b0
                               movf     v__pclath,w         ; 4294967295 -V rs rs [hl hl] 0008 080a
                                                            ; W = v__pic_isr_status
                               movwf    v__pic_isr_pclath   ; 4294967295 -V rs rs [hl hl] 0009 00b1
                               clrf     v__pclath           ; 4294967295 -V rs rs [hl hl] 000a 018a
                                                            ; W = v__pic_isr_pclath
                               movf     v__fsr,w            ; 4294967295 -V rs rs [hl hl] 000b 0804
                                                            ; W = v__pic_isr_pclath
                               movwf    v__pic_isr_fsr      ; 4294967295 -V rs rs [hl hl] 000c 00b6
                               branchlo_clr l_isr           ; 4294967295 -V rs rs [hl hl] 000d 118a
                                                            ; W = v__pic_isr_fsr
                               goto     l_isr               ; 4294967295 -V rs rs [hl hl] 000e 2c04
                                                            ; W = v__pic_isr_fsr
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 000f 0782
l__data_str1_2
                               retlw    86                  ; 4294967295 -V -- -- [-- --] 0010 3456
                               retlw    99                  ; 4294967295 -V -- -- [-- --] 0011 3463
                               retlw    120                 ; 4294967295 -V -- -- [-- --] 0012 3478
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 0013 346f
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0014 3420
                               retlw    86                  ; 4294967295 -V -- -- [-- --] 0015 3456
                               retlw    48                  ; 4294967295 -V -- -- [-- --] 0016 3430
                               retlw    46                  ; 4294967295 -V -- -- [-- --] 0017 342e
                               retlw    49                  ; 4294967295 -V -- -- [-- --] 0018 3431
                               retlw    10                  ; 4294967295 -V -- -- [-- --] 0019 340a
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 001a 0782
l__data_str_error
                               retlw    69                  ; 4294967295 -V -- -- [-- --] 001b 3445
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 001c 3472
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 001d 3472
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 001e 346f
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 001f 3472
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0020 3420
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0021 0782
l__data_str_gpgsv
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 0022 3447
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 0023 3450
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 0024 3447
                               retlw    83                  ; 4294967295 -V -- -- [-- --] 0025 3453
                               retlw    86                  ; 4294967295 -V -- -- [-- --] 0026 3456
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0027 0782
l__data_str_gpgga
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 0028 3447
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 0029 3450
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 002a 3447
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 002b 3447
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 002c 3441
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 002d 0782
l__data_str_gpvtg
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 002e 3447
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 002f 3450
                               retlw    86                  ; 4294967295 -V -- -- [-- --] 0030 3456
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 0031 3454
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 0032 3447
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0033 0782
l__data_str_gpgsa
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 0034 3447
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 0035 3450
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 0036 3447
                               retlw    83                  ; 4294967295 -V -- -- [-- --] 0037 3453
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 0038 3441
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0039 0782
l__data_str_gpgll
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 003a 3447
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 003b 3450
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 003c 3447
                               retlw    76                  ; 4294967295 -V -- -- [-- --] 003d 344c
                               retlw    76                  ; 4294967295 -V -- -- [-- --] 003e 344c
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 003f 0782
l__data_str_gprmc
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 0040 3447
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 0041 3450
                               retlw    82                  ; 4294967295 -V -- -- [-- --] 0042 3452
                               retlw    77                  ; 4294967295 -V -- -- [-- --] 0043 344d
                               retlw    67                  ; 4294967295 -V -- -- [-- --] 0044 3443
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0045 0782
l__data_str_msg
                               retlw    77                  ; 4294967295 -V -- -- [-- --] 0046 344d
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 0047 3473
                               retlw    103                 ; 4294967295 -V -- -- [-- --] 0048 3467
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0049 3420
l__pic_sdivide
                               movlw    0                   ;  2 OV rs rs [?? ??] 004a 3000
                                                            ; W = v__pic_dividend
                               btfss    v__pic_dividend+3, 7;  2 OV rs rs [?? ??] 004b 1fa3
                               goto     l__l530             ;  2 OV rs rs [?? ??] 004c 2859
                               comf     v__pic_dividend,f   ;  2 OV rs rs [?? ??] 004d 09a0
                               comf     v__pic_dividend+1,f ;  2 OV rs rs [?? ??] 004e 09a1
                               comf     v__pic_dividend+2,f ;  2 OV rs rs [?? ??] 004f 09a2
                               comf     v__pic_dividend+3,f ;  2 OV rs rs [?? ??] 0050 09a3
                               incf     v__pic_dividend,f   ;  2 OV rs rs [?? ??] 0051 0aa0
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0052 1903
                               incf     v__pic_dividend+1,f ;  2 OV rs rs [?? ??] 0053 0aa1
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0054 1903
                               incf     v__pic_dividend+2,f ;  2 OV rs rs [?? ??] 0055 0aa2
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0056 1903
                               incf     v__pic_dividend+3,f ;  2 OV rs rs [?? ??] 0057 0aa3
                               movlw    1                   ;  2 OV rs rs [?? ??] 0058 3001
l__l530
                               movwf    v__pic_sign         ;  2 OV rs rs [?? ??] 0059 00b3
                               movlw    0                   ;  2 OV rs rs [?? ??] 005a 3000
                                                            ; W = v__pic_sign
                               btfss    v__pic_divisor+3, 7 ;  2 OV rs rs [?? ??] 005b 1fab
                               goto     l__l531             ;  2 OV rs rs [?? ??] 005c 2869
                               comf     v__pic_divisor,f    ;  2 OV rs rs [?? ??] 005d 09a8
                               comf     v__pic_divisor+1,f  ;  2 OV rs rs [?? ??] 005e 09a9
                               comf     v__pic_divisor+2,f  ;  2 OV rs rs [?? ??] 005f 09aa
                               comf     v__pic_divisor+3,f  ;  2 OV rs rs [?? ??] 0060 09ab
                               incf     v__pic_divisor,f    ;  2 OV rs rs [?? ??] 0061 0aa8
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0062 1903
                               incf     v__pic_divisor+1,f  ;  2 OV rs rs [?? ??] 0063 0aa9
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0064 1903
                               incf     v__pic_divisor+2,f  ;  2 OV rs rs [?? ??] 0065 0aaa
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0066 1903
                               incf     v__pic_divisor+3,f  ;  2 OV rs rs [?? ??] 0067 0aab
                               movlw    1                   ;  2 OV rs rs [?? ??] 0068 3001
l__l531
                               xorwf    v__pic_sign,f       ;  2 OV rs rs [?? ??] 0069 06b3
                               goto     l__l532             ;  2 OV rs rs [?? ??] 006a 286c
l__pic_divide
                               clrf     v__pic_sign         ;  2 OV rs rs [?? ??] 006b 01b3
                                                            ; W = v__pic_dividend
l__l532
                               movlw    32                  ;  2 OV rs rs [?? ??] 006c 3020
                                                            ; W = v__pic_dividend
                               movwf    v__pic_loop         ;  2 OV rs rs [?? ??] 006d 00b2
                               clrf     v__pic_remainder    ;  2 OV rs rs [?? ??] 006e 01a4
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+1  ;  2 OV rs rs [?? ??] 006f 01a5
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+2  ;  2 OV rs rs [?? ??] 0070 01a6
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+3  ;  2 OV rs rs [?? ??] 0071 01a7
                                                            ; W = v__pic_loop
l__l527
                               bcf      v__status, v__c     ;  2 OV rs rs [?? ??] 0072 1003
                               rlf      v__pic_quotient,f   ;  2 OV rs rs [?? ??] 0073 0dac
                               rlf      v__pic_quotient+1,f ;  2 OV rs rs [?? ??] 0074 0dad
                               rlf      v__pic_quotient+2,f ;  2 OV rs rs [?? ??] 0075 0dae
                               rlf      v__pic_quotient+3,f ;  2 OV rs rs [?? ??] 0076 0daf
                               bcf      v__status, v__c     ;  2 OV rs rs [?? ??] 0077 1003
                               rlf      v__pic_divaccum,f   ;  2 OV rs rs [?? ??] 0078 0da0
                               rlf      v__pic_divaccum+1,f ;  2 OV rs rs [?? ??] 0079 0da1
                               rlf      v__pic_divaccum+2,f ;  2 OV rs rs [?? ??] 007a 0da2
                               rlf      v__pic_divaccum+3,f ;  2 OV rs rs [?? ??] 007b 0da3
                               rlf      v__pic_divaccum+4,f ;  2 OV rs rs [?? ??] 007c 0da4
                               rlf      v__pic_divaccum+5,f ;  2 OV rs rs [?? ??] 007d 0da5
                               rlf      v__pic_divaccum+6,f ;  2 OV rs rs [?? ??] 007e 0da6
                               rlf      v__pic_divaccum+7,f ;  2 OV rs rs [?? ??] 007f 0da7
                               movf     v__pic_remainder+3,w;  2 OV rs rs [?? ??] 0080 0827
                               subwf    v__pic_divisor+3,w  ;  2 OV rs rs [?? ??] 0081 022b
                                                            ; W = v__pic_remainder
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 0082 1d03
                               goto     l__l533             ;  2 OV rs rs [?? ??] 0083 288e
                               movf     v__pic_remainder+2,w;  2 OV rs rs [?? ??] 0084 0826
                                                            ; W = v__pic_sign
                               subwf    v__pic_divisor+2,w  ;  2 OV rs rs [?? ??] 0085 022a
                                                            ; W = v__pic_remainder
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 0086 1d03
                               goto     l__l533             ;  2 OV rs rs [?? ??] 0087 288e
                               movf     v__pic_remainder+1,w;  2 OV rs rs [?? ??] 0088 0825
                               subwf    v__pic_divisor+1,w  ;  2 OV rs rs [?? ??] 0089 0229
                                                            ; W = v__pic_remainder
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 008a 1d03
                               goto     l__l533             ;  2 OV rs rs [?? ??] 008b 288e
                               movf     v__pic_remainder,w  ;  2 OV rs rs [?? ??] 008c 0824
                               subwf    v__pic_divisor,w    ;  2 OV rs rs [?? ??] 008d 0228
                                                            ; W = v__pic_remainder
l__l533
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 008e 1903
                               goto     l__l529             ;  2 OV rs rs [?? ??] 008f 2892
                               btfsc    v__status, v__c     ;  2 OV rs rs [?? ??] 0090 1803
                                                            ; W = v__pic_sign
                               goto     l__l528             ;  2 OV rs rs [?? ??] 0091 28a1
                                                            ; W = v__pic_sign
l__l529
                               movf     v__pic_divisor,w    ;  2 OV rs rs [?? ??] 0092 0828
                               subwf    v__pic_remainder,f  ;  2 OV rs rs [?? ??] 0093 02a4
                                                            ; W = v__pic_divisor
                               movf     v__pic_divisor+1,w  ;  2 OV rs rs [?? ??] 0094 0829
                                                            ; W = v__pic_divisor
                               btfss    v__status, v__c     ;  2 OV rs rs [?? ??] 0095 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+1,w  ;  2 OV rs rs [?? ??] 0096 0f29
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+1,f;  2 OV rs rs [?? ??] 0097 02a5
                               movf     v__pic_divisor+2,w  ;  2 OV rs rs [?? ??] 0098 082a
                               btfss    v__status, v__c     ;  2 OV rs rs [?? ??] 0099 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+2,w  ;  2 OV rs rs [?? ??] 009a 0f2a
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+2,f;  2 OV rs rs [?? ??] 009b 02a6
                               movf     v__pic_divisor+3,w  ;  2 OV rs rs [?? ??] 009c 082b
                               btfss    v__status, v__c     ;  2 OV rs rs [?? ??] 009d 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+3,w  ;  2 OV rs rs [?? ??] 009e 0f2b
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+3,f;  2 OV rs rs [?? ??] 009f 02a7
                               bsf      v__pic_quotient, 0  ;  2 OV rs rs [?? ??] 00a0 142c
l__l528
                               decfsz   v__pic_loop,f       ;  2 OV rs rs [?? ??] 00a1 0bb2
                                                            ; W = v__pic_sign
                               goto     l__l527             ;  2 OV rs rs [?? ??] 00a2 2872
                                                            ; W = v__pic_sign
                               movf     v__pic_sign,w       ;  2 OV rs rs [?? ??] 00a3 0833
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00a4 1903
                                                            ; W = v__pic_sign
                               return                       ;  2 OV rs rs [?? ??] 00a5 0008
                                                            ; W = v__pic_sign
                               comf     v__pic_quotient,f   ;  2 OV rs rs [?? ??] 00a6 09ac
                               comf     v__pic_quotient+1,f ;  2 OV rs rs [?? ??] 00a7 09ad
                               comf     v__pic_quotient+2,f ;  2 OV rs rs [?? ??] 00a8 09ae
                               comf     v__pic_quotient+3,f ;  2 OV rs rs [?? ??] 00a9 09af
                               incf     v__pic_quotient,f   ;  2 OV rs rs [?? ??] 00aa 0aac
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00ab 1903
                               incf     v__pic_quotient+1,f ;  2 OV rs rs [?? ??] 00ac 0aad
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00ad 1903
                               incf     v__pic_quotient+2,f ;  2 OV rs rs [?? ??] 00ae 0aae
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00af 1903
                               incf     v__pic_quotient+3,f ;  2 OV rs rs [?? ??] 00b0 0aaf
                               comf     v__pic_remainder,f  ;  2 OV rs rs [?? ??] 00b1 09a4
                               comf     v__pic_remainder+1,f;  2 OV rs rs [?? ??] 00b2 09a5
                               comf     v__pic_remainder+2,f;  2 OV rs rs [?? ??] 00b3 09a6
                               comf     v__pic_remainder+3,f;  2 OV rs rs [?? ??] 00b4 09a7
                               incf     v__pic_remainder,f  ;  2 OV rs rs [?? ??] 00b5 0aa4
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00b6 1903
                               incf     v__pic_remainder+1,f;  2 OV rs rs [?? ??] 00b7 0aa5
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00b8 1903
                               incf     v__pic_remainder+2,f;  2 OV rs rs [?? ??] 00b9 0aa6
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 00ba 1903
                               incf     v__pic_remainder+3,f;  2 OV rs rs [?? ??] 00bb 0aa7
                               return                       ;  2 OV rs rs [?? ??] 00bc 0008
l__pic_indirect
                               movwf    v__pclath           ;  3 OV ?s Rs [?? ??] 00bd 008a
                               datahi_clr v__pic_pointer    ;  3 OV ?s rs [?? ??] 00be 1303
                               movf     v__pic_pointer,w    ;  3 OV rs rs [?? ??] 00bf 0834
                               movwf    v__pcl              ;  3 OV rs rs [?? ??] 00c0 0082
                                                            ; W = v__pic_pointer
l__main
; c:\jallib\include\device/16f690.jal
;   96 var          byte  _PORTA_shadow        = PORTA
                               movf     v_porta,w           ;  0 OV rs rs [hl hl] 00c1 0805
                               movwf    v__porta_shadow     ;  0 OV rs rs [hl hl] 00c2 00c1
; vcxo.jal
;   30 pin_a2_direction =  output
                               datalo_set v_trisa ; pin_a2_direction        ;  0 OV rs rS [hl hl] 00c3 1683
                                                            ; W = v__porta_shadow
                               bcf      v_trisa, 2 ; pin_a2_direction       ;  0 OV rS rS [hl hl] 00c4 1105
                                                            ; W = v__porta_shadow
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  867    ANSEL  = 0b0000_0000       -- all digital
                               datalo_clr v_ansel           ;  0 OV rS rs [hl hl] 00c5 1283
                                                            ; W = v__porta_shadow
                               datahi_set v_ansel           ;  0 OV rs Rs [hl hl] 00c6 1703
                                                            ; W = v__porta_shadow
                               clrf     v_ansel             ;  0 OV Rs Rs [hl hl] 00c7 019e
                                                            ; W = v__porta_shadow
;  868    ANSELH = 0b0000_0000       -- all digital
                               clrf     v_anselh            ;  0 OV Rs Rs [hl hl] 00c8 019f
                                                            ; W = v__porta_shadow
; vcxo.jal
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  891    analog_off()
; vcxo.jal
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  875    ADCON0 = 0b0000_0000         -- disable ADC
                               datahi_clr v_adcon0          ;  0 OV Rs rs [hl hl] 00c9 1303
                                                            ; W = v__porta_shadow
                               clrf     v_adcon0            ;  0 OV rs rs [hl hl] 00ca 019f
                                                            ; W = v__porta_shadow
;  876    ADCON1 = 0b0000_0000
                               datalo_set v_adcon1          ;  0 OV rs rS [hl hl] 00cb 1683
                                                            ; W = v__porta_shadow
                               clrf     v_adcon1            ;  0 OV rS rS [hl hl] 00cc 019f
                                                            ; W = v__porta_shadow
; vcxo.jal
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  892    adc_off()
; vcxo.jal
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  883    CM1CON0 = 0b0000_0000       -- disable comparator
                               datalo_clr v_cm1con0         ;  0 OV rS rs [hl hl] 00cd 1283
                                                            ; W = v__porta_shadow
                               datahi_set v_cm1con0         ;  0 OV rs Rs [hl hl] 00ce 1703
                                                            ; W = v__porta_shadow
                               clrf     v_cm1con0           ;  0 OV Rs Rs [hl hl] 00cf 0199
                                                            ; W = v__porta_shadow
;  884    CM2CON0 = 0b0000_0000       -- disable 2nd comparator
                               clrf     v_cm2con0           ;  0 OV Rs Rs [hl hl] 00d0 019a
                                                            ; W = v__porta_shadow
; vcxo.jal
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  893    comparator_off()
; vcxo.jal
;   32 enable_digital_io()
;   34 OPTION_REG_NRAPU = false -- enable pull-up on port A
                               datalo_set v_option_reg ; option_reg_nrapu   ;  0 OV Rs RS [hl hl] 00d1 1683
                                                            ; W = v__porta_shadow
                               bcf      v_option_reg, 7 ; option_reg_nrapu  ;  0 OV RS RS [hl hl] 00d2 1381
                                                            ; W = v__porta_shadow
;   35 WPUA = 0b0000_0100          -- pull-up off voor alle pins behalve A2.
                               movlw    4                   ;  0 OV RS RS [hl hl] 00d3 3004
                                                            ; W = v__porta_shadow
                               datahi_clr v_wpua            ;  0 OV RS rS [hl hl] 00d4 1303
                               movwf    v_wpua              ;  0 OV rS rS [hl hl] 00d5 0095
; c:\jallib\include\peripheral\usart/serial_hw_int_cts.jal
;  134 end if
                               goto     l__l225             ;  0 OV rS rS [hl hl] 00d6 29f2
; c:\jallib\include\peripheral\usart/usart_common.jal
;   43 procedure _calculate_and_set_baudrate() is
l__calculate_and_set_baudrate
;   49          BAUDCTL_BRG16 = true
                               bsf      v_baudctl, 3 ; baudctl_brg16     ;  2 OV rS rS [hl hl] 00d7 159b
;   50          TXSTA_BRGH = true
                               bsf      v_txsta, 2 ; txsta_brgh       ;  2 OV rS rS [hl hl] 00d8 1518
;   65          SPBRG = byte(usart_div)
                               movlw    8                   ;  2 OV rS rS [hl hl] 00d9 3008
                               movwf    v_spbrg             ;  2 OV rS rS [hl hl] 00da 0099
;   66          SPBRGH = byte(usart_div >> 8)
                               movlw    2                   ;  2 OV rS rS [hl hl] 00db 3002
                               movwf    v_spbrgh            ;  2 OV rS rS [hl hl] 00dc 009a
;  152 end procedure
                               return                       ;  2 OV rS rS [hl hl] 00dd 0008
; c:\jallib\include\peripheral\usart/serial_hw_int_cts.jal
;  176 procedure  _serial_transmit_interrupt_handler() is
l__serial_transmit_interrupt_handler
;  182    if ((PIR1_TXIF == TRUE) & (PIE1_TXIE == TRUE)) then          -- UART xmit interrupt
                               bcf      v____bitbucket_54, 0 ; _btemp1;  4 OV rs rs [hl hl] 00de 103a
                               btfsc    v_pir1, 4 ; pir1_txif        ;  4 OV rs rs [hl hl] 00df 1a0c
                               bsf      v____bitbucket_54, 0 ; _btemp1;  4 OV rs rs [hl hl] 00e0 143a
                               datalo_set v_pie1 ; pie1_txie         ;  4 OV rs rS [hl hl] 00e1 1683
                               btfsc    v_pie1, 4 ; pie1_txie        ;  4 OV rS rS [hl hl] 00e2 1a0c
                               goto     l__l534             ;  4 OV rS rS [hl hl] 00e3 28e7
                               datalo_clr v____bitbucket_54 ; _btemp2;  4 OV rS rs [hl hl] 00e4 1283
                               bcf      v____bitbucket_54, 1 ; _btemp2;  4 OV rs rs [hl hl] 00e5 10ba
                               goto     l__l535             ;  4 OV rs rs [hl hl] 00e6 28e9
l__l534
                               datalo_clr v____bitbucket_54 ; _btemp2;  4 OV rS rs [hl hl] 00e7 1283
                               bsf      v____bitbucket_54, 1 ; _btemp2;  4 OV rs rs [hl hl] 00e8 14ba
l__l535
                               bsf      v____bitbucket_54, 2 ; _btemp3;  4 OV rs rs [hl hl] 00e9 153a
                               btfsc    v____bitbucket_54, 0 ; _btemp1;  4 OV rs rs [hl hl] 00ea 183a
                               btfss    v____bitbucket_54, 1 ; _btemp2;  4 OV rs rs [hl hl] 00eb 1cba
                               bcf      v____bitbucket_54, 2 ; _btemp3;  4 OV rs rs [hl hl] 00ec 113a
                               btfss    v____bitbucket_54, 2 ; _btemp3;  4 OV rs rs [hl hl] 00ed 1d3a
                               goto     l__l157             ;  4 OV rs rs [hl hl] 00ee 290a
;  183       if (_serial_offsetxmttail != _serial_offsetxmthead) then  -- data in xmit buffer
                               movf     v__serial_offsetxmttail,w;  4 OV rs rs [hl hl] 00ef 084f
                               subwf    v__serial_offsetxmthead,w;  4 OV rs rs [hl hl] 00f0 024e
                                                            ; W = v__serial_offsetxmttail
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 00f1 1903
                               goto     l__l156             ;  4 OV rs rs [hl hl] 00f2 290a
;  184          x = _serial_xmtbuf[_serial_offsetxmttail]              -- next byte to xmit
                               movlw    v__serial_xmtbuf    ;  4 OV rs rs [hl hl] 00f3 30a0
                               addwf    v__serial_offsetxmttail,w;  4 OV rs rs [hl hl] 00f4 074f
                               movwf    v__fsr              ;  4 OV rs rs [hl hl] 00f5 0084
                               irp_clr                      ;  4 OV rs rs [hl hl] 00f6 1383
                               movf     v__ind,w            ;  4 OV rs rs [hl hl] 00f7 0800
                               movwf    v___x_66            ;  4 OV rs rs [hl hl] 00f8 00b9
;  185          _serial_offsetxmttail = _serial_offsetxmttail + 1      -- next position
                               incf     v__serial_offsetxmttail,f;  4 OV rs rs [hl hl] 00f9 0acf
                                                            ; W = v___x_66
;  186          if (_serial_offsetxmttail >= SERIAL_XMTBUFSIZE) then   -- beyond buffer
                               movlw    80                  ;  4 OV rs rs [hl hl] 00fa 3050
                                                            ; W = v___x_66
                               subwf    v__serial_offsetxmttail,w;  4 OV rs rs [hl hl] 00fb 024f
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 00fc 1903
                               goto     l__l539             ;  4 OV rs rs [hl hl] 00fd 2900
                               btfss    v__status, v__c     ;  4 OV rs rs [hl hl] 00fe 1c03
                               goto     l__l161             ;  4 OV rs rs [hl hl] 00ff 2901
l__l539
;  187             _serial_offsetxmttail = 0           -- wrap to begin
                               clrf     v__serial_offsetxmttail;  4 OV rs rs [hl hl] 0100 01cf
;  188          end if
l__l161
;  189          if (_serial_offsetxmttail == _serial_offsetxmthead) then  -- last byte xmt'd
                               movf     v__serial_offsetxmttail,w;  4 OV rs rs [hl hl] 0101 084f
                               subwf    v__serial_offsetxmthead,w;  4 OV rs rs [hl hl] 0102 024e
                                                            ; W = v__serial_offsetxmttail
                               btfss    v__status, v__z     ;  4 OV rs rs [hl hl] 0103 1d03
                               goto     l__l163             ;  4 OV rs rs [hl hl] 0104 2907
;  190             PIE1_TXIE = FALSE                   -- disable xmit interrupts
                               datalo_set v_pie1 ; pie1_txie         ;  4 OV rs rS [hl hl] 0105 1683
                               bcf      v_pie1, 4 ; pie1_txie        ;  4 OV rS rS [hl hl] 0106 120c
;  191          end if
l__l163
;  192          TXREG = x                              -- actually xmit byte
                               datalo_clr v___x_66          ;  4 OV r? rs [hl hl] 0107 1283
                               movf     v___x_66,w          ;  4 OV rs rs [hl hl] 0108 0839
                               movwf    v_txreg             ;  4 OV rs rs [hl hl] 0109 0099
                                                            ; W = v___x_66
;  194    end if
l__l157
l__l156
;  196 end procedure
                               movf     v__pic_isr_fsr,w    ;  4 OV rs rs [hl hl] 010a 0836
                               movwf    v__fsr              ;  4 OV rs rs [hl hl] 010b 0084
                                                            ; W = v__pic_isr_fsr
                               movf     v__pic_isr_pclath,w ;  4 -V rs rs [hl hl] 010c 0831
                               movwf    v__pclath           ;  4 -V rs rs [hl hl] 010d 008a
                                                            ; W = v__pic_isr_pclath
                               swapf    v__pic_isr_status,w ;  4 -V rs rs [hl hl] 010e 0e30
                               movwf    v__status           ;  4 -V rs rs [hl hl] 010f 0083
                               swapf    v__pic_isr_w,f      ;  4 -V rs rs [hl hl] 0110 0eff
                               swapf    v__pic_isr_w,w      ;  4 -V rs rs [hl hl] 0111 0e7f
                               retfie                       ;  4 -V rs rs [hl hl] 0112 0009
;  206 procedure  _serial_receive_interrupt_handler() is
l__serial_receive_interrupt_handler
;  212    if  (PIR1_RCIF == TRUE)  then                -- UART receive interrupt
                               btfss    v_pir1, 5 ; pir1_rcif        ;  4 OV rs rs [hl hl] 0113 1e8c
                               goto     l__serial_transmit_interrupt_handler;  4 OV rs rs [hl hl] 0114 28de
;  214       if ((RCSTA_OERR == TRUE) | (RCSTA_FERR == TRUE)) then  -- frame/overr error
                               bcf      v____bitbucket_53, 1 ; _btemp8;  4 OV rs rs [hl hl] 0115 10bb
                               btfsc    v_rcsta, 1 ; rcsta_oerr       ;  4 OV rs rs [hl hl] 0116 1898
                               bsf      v____bitbucket_53, 1 ; _btemp8;  4 OV rs rs [hl hl] 0117 14bb
                               bcf      v____bitbucket_53, 2 ; _btemp9;  4 OV rs rs [hl hl] 0118 113b
                               btfsc    v_rcsta, 2 ; rcsta_ferr       ;  4 OV rs rs [hl hl] 0119 1918
                               bsf      v____bitbucket_53, 2 ; _btemp9;  4 OV rs rs [hl hl] 011a 153b
                               bcf      v____bitbucket_53, 3 ; _btemp10;  4 OV rs rs [hl hl] 011b 11bb
                               btfss    v____bitbucket_53, 1 ; _btemp8;  4 OV rs rs [hl hl] 011c 1cbb
                               btfsc    v____bitbucket_53, 2 ; _btemp9;  4 OV rs rs [hl hl] 011d 193b
                               bsf      v____bitbucket_53, 3 ; _btemp10;  4 OV rs rs [hl hl] 011e 15bb
                               btfss    v____bitbucket_53, 3 ; _btemp10;  4 OV rs rs [hl hl] 011f 1dbb
                               goto     l__l169             ;  4 OV rs rs [hl hl] 0120 2930
;  215          x = RCREG                              -- flush hardware buffer
                               movf     v_rcreg,w           ;  4 OV rs rs [hl hl] 0121 081a
                                                            ; W = v___x_67
                               movwf    v___x_67            ;  4 OV rs rs [hl hl] 0122 00b9
;  216          while RCSTA_OERR == TRUE loop          -- overrun state
l__l170
                               btfss    v_rcsta, 1 ; rcsta_oerr       ;  4 OV rs rs [hl hl] 0123 1c98
                                                            ; W = v___x_67
                               goto     l__l171             ;  4 OV rs rs [hl hl] 0124 292c
                                                            ; W = v___x_67
;  217             RCSTA_CREN = FALSE                  -- disable UART
                               bcf      v_rcsta, 4 ; rcsta_cren       ;  4 OV rs rs [hl hl] 0125 1218
;  218             RCSTA_CREN = TRUE                   -- re-enable UART
                               bsf      v_rcsta, 4 ; rcsta_cren       ;  4 OV rs rs [hl hl] 0126 1618
;  219             x = RCREG                           -- \  flush hardware buffers
                               movf     v_rcreg,w           ;  4 OV rs rs [hl hl] 0127 081a
                               movwf    v___x_67            ;  4 OV rs rs [hl hl] 0128 00b9
;  220             x = RCREG                           -- /
                               movf     v_rcreg,w           ;  4 OV rs rs [hl hl] 0129 081a
                                                            ; W = v___x_67
                               movwf    v___x_67            ;  4 OV rs rs [hl hl] 012a 00b9
;  221          end loop                               -- until no more overrun
                               goto     l__l170             ;  4 OV rs rs [hl hl] 012b 2923
                                                            ; W = v___x_67
l__l171
;  222          _serial_offsetrcvtail = 0              -- \  flush circular buffer
                               clrf     v__serial_offsetrcvtail;  4 OV rs rs [hl hl] 012c 01d1
                                                            ; W = v___x_67
;  223          _serial_offsetrcvhead = 0              -- /
                               clrf     v__serial_offsetrcvhead;  4 OV rs rs [hl hl] 012d 01d0
                                                            ; W = v___x_67
;  224          serial_ctsinv = FALSE                  -- ensure CTS true
                               bcf      v__bitbucket, 0 ; dummy  ;  4 OV rs rs [hl hl] 012e 106a
                                                            ; W = v___x_67
;  226       else                                      -- data without errors
                               goto     l__serial_transmit_interrupt_handler;  4 OV rs rs [hl hl] 012f 28de
                                                            ; W = v___x_67
l__l169
;  227          _serial_rcvbuf[_serial_offsetrcvhead] = RCREG      -- move byte to rcv buffer
                               movlw    v__serial_rcvbuf    ;  4 OV rs rs [hl hl] 0130 3042
                               addwf    v__serial_offsetrcvhead,w;  4 OV rs rs [hl hl] 0131 0750
                               movwf    v__fsr              ;  4 OV rs rs [hl hl] 0132 0084
                               irp_clr                      ;  4 OV rs rs [hl hl] 0133 1383
                               movf     v_rcreg,w           ;  4 OV rs rs [hl hl] 0134 081a
                               movwf    v__ind              ;  4 OV rs rs [hl hl] 0135 0080
;  247          x = _serial_offsetrcvhead + 1          -- update offset
                               incf     v__serial_offsetrcvhead,w;  4 OV rs rs [hl hl] 0136 0a50
                               movwf    v___x_67            ;  4 OV rs rs [hl hl] 0137 00b9
;  248          if x >= SERIAL_RCVBUFSIZE then         -- buffer overflow
                               movlw    12                  ;  4 OV rs rs [hl hl] 0138 300c
                                                            ; W = v___x_67
                               subwf    v___x_67,w          ;  4 OV rs rs [hl hl] 0139 0239
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 013a 1903
                               goto     l__l543             ;  4 OV rs rs [hl hl] 013b 293e
                               btfss    v__status, v__c     ;  4 OV rs rs [hl hl] 013c 1c03
                                                            ; W = v__serial_offsetrcvhead
                               goto     l__l175             ;  4 OV rs rs [hl hl] 013d 293f
                                                            ; W = v__serial_offsetrcvhead
l__l543
;  249             x = 0                               -- wrap
                               clrf     v___x_67            ;  4 OV rs rs [hl hl] 013e 01b9
;  250          end if
l__l175
;  251          if (x != _serial_offsetrcvtail) then   -- buffer not yet full
                               movf     v___x_67,w          ;  4 OV rs rs [hl hl] 013f 0839
                                                            ; W = v__serial_offsetrcvhead
                               subwf    v__serial_offsetrcvtail,w;  4 OV rs rs [hl hl] 0140 0251
                                                            ; W = v___x_67
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 0141 1903
                               goto     l__l177             ;  4 OV rs rs [hl hl] 0142 2945
;  252             _serial_offsetrcvhead = x           -- update offset
                               movf     v___x_67,w          ;  4 OV rs rs [hl hl] 0143 0839
                                                            ; W = v___x_67
                               movwf    v__serial_offsetrcvhead;  4 OV rs rs [hl hl] 0144 00d0
                                                            ; W = v___x_67
;  253          end if                                 -- (else discard byte,
l__l177
;  255          if (serial_ctsinv == FALSE) then       -- CTS is TRUE
                               btfsc    v__bitbucket, 0 ; dummy  ;  4 OV rs rs [hl hl] 0145 186a
                               goto     l__serial_transmit_interrupt_handler;  4 OV rs rs [hl hl] 0146 28de
;  256             if _serial_offsetrcvhead > _serial_offsetrcvtail then  -- offset difference
                               movf     v__serial_offsetrcvhead,w;  4 OV rs rs [hl hl] 0147 0850
                               subwf    v__serial_offsetrcvtail,w;  4 OV rs rs [hl hl] 0148 0251
                                                            ; W = v__serial_offsetrcvhead
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 0149 1903
                               goto     l__l181             ;  4 OV rs rs [hl hl] 014a 2955
                               btfsc    v__status, v__c     ;  4 OV rs rs [hl hl] 014b 1803
                               goto     l__l181             ;  4 OV rs rs [hl hl] 014c 2955
;  257                x = SERIAL_RCVBUFSIZE - _serial_offsetrcvhead + _serial_offsetrcvtail
                               comf     v__serial_offsetrcvhead,w;  4 OV rs rs [hl hl] 014d 0950
                               movwf    v____temp_25        ;  4 OV rs rs [hl hl] 014e 00ba
                               movlw    13                  ;  4 OV rs rs [hl hl] 014f 300d
                                                            ; W = v____temp_25
                               addwf    v____temp_25,f      ;  4 OV rs rs [hl hl] 0150 07ba
                               movf     v__serial_offsetrcvtail,w;  4 OV rs rs [hl hl] 0151 0851
                               addwf    v____temp_25,w      ;  4 OV rs rs [hl hl] 0152 073a
                                                            ; W = v__serial_offsetrcvtail
                               movwf    v___x_67            ;  4 OV rs rs [hl hl] 0153 00b9
;  258             else
                               goto     l__l180             ;  4 OV rs rs [hl hl] 0154 2958
                                                            ; W = v___x_67
l__l181
;  259                x = _serial_offsetrcvtail - _serial_offsetrcvhead
                               movf     v__serial_offsetrcvhead,w;  4 OV rs rs [hl hl] 0155 0850
                               subwf    v__serial_offsetrcvtail,w;  4 OV rs rs [hl hl] 0156 0251
                                                            ; W = v__serial_offsetrcvhead
                               movwf    v___x_67            ;  4 OV rs rs [hl hl] 0157 00b9
;  260             end if
l__l180
;  261             if (x < SERIAL_DELTA) then          -- circular buffer almost full
                               movlw    17                  ;  4 OV rs rs [hl hl] 0158 3011
                                                            ; W = v___x_67
                               subwf    v___x_67,w          ;  4 OV rs rs [hl hl] 0159 0239
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 015a 1903
                               goto     l__l178             ;  4 OV rs rs [hl hl] 015b 2960
                               btfsc    v__status, v__c     ;  4 OV rs rs [hl hl] 015c 1803
                               goto     l__l178             ;  4 OV rs rs [hl hl] 015d 2960
;  262                serial_ctsinv = TRUE             -- set CTS FALSE
                               bsf      v__bitbucket, 0 ; dummy  ;  4 OV rs rs [hl hl] 015e 146a
;  264          end if
                               goto     l__serial_transmit_interrupt_handler;  4 OV rs rs [hl hl] 015f 28de
l__l178
;  266       end if
;  268    end if
                               goto     l__serial_transmit_interrupt_handler;  4 OV rs rs [hl hl] 0160 28de
;  270 end procedure
;  287 function serial_hw_read(byte out data) return bit is
l_serial_hw_read
;  291    if (_serial_offsetrcvtail == _serial_offsetrcvhead) then  -- receive buffer empty
                               datalo_clr v__serial_offsetrcvtail;  1 OV ?? ?s [?? ??] 0161 1283
                               datahi_clr v__serial_offsetrcvtail;  1 OV ?s rs [?? ??] 0162 1303
                               movf     v__serial_offsetrcvtail,w;  1 OV rs rs [?? ??] 0163 0851
                               subwf    v__serial_offsetrcvhead,w;  1 OV rs rs [?? ??] 0164 0250
                                                            ; W = v__serial_offsetrcvtail
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 0165 1d03
                               goto     l__l187             ;  1 OV rs rs [?? ??] 0166 2969
;  292       return false                              -- no data available
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 0167 1020
                                                            ; W = v___data_1
                               goto     l__l185             ;  1 OV rs rs [?? ??] 0168 2998
                                                            ; W = v___data_1
;  293    end if
l__l187
;  295    data = _serial_rcvbuf[_serial_offsetrcvtail]  -- first available byte
                               movlw    v__serial_rcvbuf    ;  1 OV rs rs [?? ??] 0169 3042
                               addwf    v__serial_offsetrcvtail,w;  1 OV rs rs [?? ??] 016a 0751
                               movwf    v__fsr              ;  1 OV rs rs [?? ??] 016b 0084
                               irp_clr                      ;  1 OV rs rs [?? ??] 016c 1383
                               movf     v__ind,w            ;  1 OV rs rs [?? ??] 016d 0800
                               movwf    v___data_1          ;  1 OV rs rs [?? ??] 016e 00ed
;  296    _serial_offsetrcvtail = _serial_offsetrcvtail + 1
                               incf     v__serial_offsetrcvtail,f;  1 OV rs rs [?? ??] 016f 0ad1
                                                            ; W = v___data_1
;  297    if (_serial_offsetrcvtail >= SERIAL_RCVBUFSIZE) then  -- buffer overflow
                               movlw    12                  ;  1 OV rs rs [?? ??] 0170 300c
                                                            ; W = v___data_1
                               subwf    v__serial_offsetrcvtail,w;  1 OV rs rs [?? ??] 0171 0251
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 0172 1903
                               goto     l__l549             ;  1 OV rs rs [?? ??] 0173 2976
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 0174 1c03
                                                            ; W = v___x_68
                               goto     l__l189             ;  1 OV rs rs [?? ??] 0175 2977
                                                            ; W = v___x_68
l__l549
;  298       _serial_offsetrcvtail = 0                 -- wrap
                               clrf     v__serial_offsetrcvtail;  1 OV rs rs [?? ??] 0176 01d1
;  299    end if
l__l189
;  300    if (serial_ctsinv == TRUE) then              -- CTS is FALSE
                               btfss    v__bitbucket, 0 ; dummy  ;  1 OV rs rs [?? ??] 0177 1c6a
                                                            ; W = v___x_68
                               goto     l__l191             ;  1 OV rs rs [?? ??] 0178 2996
                                                            ; W = v___x_68
;  301       if (_serial_offsetrcvhead > _serial_offsetrcvtail) then
                               movf     v__serial_offsetrcvhead,w;  1 OV rs rs [?? ??] 0179 0850
                                                            ; W = v___data_1
                               subwf    v__serial_offsetrcvtail,w;  1 OV rs rs [?? ??] 017a 0251
                                                            ; W = v__serial_offsetrcvhead
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 017b 1903
                               goto     l__l193             ;  1 OV rs rs [?? ??] 017c 298a
                               btfsc    v__status, v__c     ;  1 OV rs rs [?? ??] 017d 1803
                               goto     l__l193             ;  1 OV rs rs [?? ??] 017e 298a
;  302          x = SERIAL_RCVBUFSIZE - _serial_offsetrcvhead + _serial_offsetrcvtail
                               comf     v__serial_offsetrcvhead,w;  1 OV rs rs [?? ??] 017f 0950
                               datahi_set v____temp_26      ;  1 OV rs Rs [?? ??] 0180 1703
                               movwf    v____temp_26        ;  1 OV Rs Rs [?? ??] 0181 00a2
                               movlw    13                  ;  1 OV Rs Rs [?? ??] 0182 300d
                                                            ; W = v____temp_26
                               addwf    v____temp_26,f      ;  1 OV Rs Rs [?? ??] 0183 07a2
                               datahi_clr v__serial_offsetrcvtail;  1 OV Rs rs [?? ??] 0184 1303
                               movf     v__serial_offsetrcvtail,w;  1 OV rs rs [?? ??] 0185 0851
                               datahi_set v____temp_26      ;  1 OV rs Rs [?? ??] 0186 1703
                                                            ; W = v__serial_offsetrcvtail
                               addwf    v____temp_26,w      ;  1 OV Rs Rs [?? ??] 0187 0722
                                                            ; W = v__serial_offsetrcvtail
                               movwf    v___x_68            ;  1 OV Rs Rs [?? ??] 0188 00a0
;  303       else
                               goto     l__l192             ;  1 OV Rs Rs [?? ??] 0189 298e
                                                            ; W = v___x_68
l__l193
;  304          x = _serial_offsetrcvtail - _serial_offsetrcvhead  -- offset difference
                               movf     v__serial_offsetrcvhead,w;  1 OV rs rs [?? ??] 018a 0850
                               subwf    v__serial_offsetrcvtail,w;  1 OV rs rs [?? ??] 018b 0251
                                                            ; W = v__serial_offsetrcvhead
                               datahi_set v___x_68          ;  1 OV rs Rs [?? ??] 018c 1703
                               movwf    v___x_68            ;  1 OV Rs Rs [?? ??] 018d 00a0
;  305       end if
l__l192
;  306       if (x >= SERIAL_DELTA) then               -- enough free space now
                               movlw    17                  ;  1 OV Rs Rs [?? ??] 018e 3011
                                                            ; W = v___x_68
                               subwf    v___x_68,w          ;  1 OV Rs Rs [?? ??] 018f 0220
                               btfsc    v__status, v__z     ;  1 OV Rs Rs [?? ??] 0190 1903
                               goto     l__l553             ;  1 OV Rs Rs [?? ??] 0191 2994
                               btfss    v__status, v__c     ;  1 OV Rs Rs [?? ??] 0192 1c03
                               goto     l__l190             ;  1 OV Rs Rs [?? ??] 0193 2996
l__l553
;  307          serial_ctsinv = FALSE                  -- make CTS TRUE
                               datahi_clr v__bitbucket ; dummy   ;  1 OV Rs rs [?? ??] 0194 1303
                               bcf      v__bitbucket, 0 ; dummy  ;  1 OV rs rs [?? ??] 0195 106a
;  309    end if
l__l191
l__l190
;  311    return true                                  -- byte available
                               datahi_clr v__pic_temp ; _pic_temp    ;  1 OV ?s rs [?? ??] 0196 1303
                                                            ; W = v___x_68
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 0197 1420
                                                            ; W = v___x_68
;  313 end function
l__l185
                               movf     v___data_1,w        ;  1 OV rs rs [?? ??] 0198 086d
                                                            ; W = v___x_68
                               return                       ;  1 OV rs rs [?? ??] 0199 0008
                                                            ; W = v___data_1
;  338 function  serial_send_byte(byte in data) return byte is
l_serial_send_byte
                               movwf    v___data_5          ;  3 OV rs rs [?? ??] 019a 00be
                                                            ; W = v___data_7
;  342    serial_send_success = true                   -- indicate byte sent
                               bsf      v__bitbucket, 1 ; serial_send_success  ;  3 OV rs rs [?? ??] 019b 14ea
                                                            ; W = v___data_5
;  344    if (_serial_offsetxmthead == _serial_offsetxmttail  &  -- nothing buffered
                               movf     v__serial_offsetxmthead,w;  3 OV rs rs [?? ??] 019c 084e
                                                            ; W = v___data_5
                               subwf    v__serial_offsetxmttail,w;  3 OV rs rs [?? ??] 019d 024f
                                                            ; W = v__serial_offsetxmthead
                               bcf      v____bitbucket_50, 0 ; _btemp23;  3 OV rs rs [?? ??] 019e 1040
                               btfsc    v__status, v__z     ;  3 OV rs rs [?? ??] 019f 1903
                               bsf      v____bitbucket_50, 0 ; _btemp23;  3 OV rs rs [?? ??] 01a0 1440
                               bcf      v____bitbucket_50, 1 ; _btemp24;  3 OV rs rs [?? ??] 01a1 10c0
                               btfsc    v_pir1, 4 ; pir1_txif        ;  3 OV rs rs [?? ??] 01a2 1a0c
                               bsf      v____bitbucket_50, 1 ; _btemp24;  3 OV rs rs [?? ??] 01a3 14c0
                               bsf      v____bitbucket_50, 2 ; _btemp25;  3 OV rs rs [?? ??] 01a4 1540
                               btfsc    v____bitbucket_50, 0 ; _btemp23;  3 OV rs rs [?? ??] 01a5 1840
                               btfss    v____bitbucket_50, 1 ; _btemp24;  3 OV rs rs [?? ??] 01a6 1cc0
                               bcf      v____bitbucket_50, 2 ; _btemp25;  3 OV rs rs [?? ??] 01a7 1140
                               btfss    v____bitbucket_50, 2 ; _btemp25;  3 OV rs rs [?? ??] 01a8 1d40
                               goto     l__l201             ;  3 OV rs rs [?? ??] 01a9 29b0
;  346       PIE1_TXIE = FALSE                         -- disable xmt interrupt
                               datalo_set v_pie1 ; pie1_txie         ;  3 OV rs rS [?? ??] 01aa 1683
                                                            ; W = v_newxmthead
                               bcf      v_pie1, 4 ; pie1_txie        ;  3 OV rS rS [?? ??] 01ab 120c
                                                            ; W = v_newxmthead
;  347       TXREG = data                              -- transmit byte immediately
                               datalo_clr v___data_5        ;  3 OV rS rs [?? ??] 01ac 1283
                                                            ; W = v_newxmthead
                               movf     v___data_5,w        ;  3 OV rs rs [?? ??] 01ad 083e
                                                            ; W = v_newxmthead
                               movwf    v_txreg             ;  3 OV rs rs [?? ??] 01ae 0099
                                                            ; W = v___data_5
;  348    else                                         -- use circular buffer
                               goto     l__l200             ;  3 OV rs rs [?? ??] 01af 29ce
l__l201
;  349       _serial_xmtbuf[_serial_offsetxmthead] = data  -- put byte in buffer
                               movlw    v__serial_xmtbuf    ;  3 OV rs rs [?? ??] 01b0 30a0
                               addwf    v__serial_offsetxmthead,w;  3 OV rs rs [?? ??] 01b1 074e
                               movwf    v__fsr              ;  3 OV rs rs [?? ??] 01b2 0084
                               irp_clr                      ;  3 OV rs rs [?? ??] 01b3 1383
                               movf     v___data_5,w        ;  3 OV rs rs [?? ??] 01b4 083e
                               movwf    v__ind              ;  3 OV rs rs [?? ??] 01b5 0080
                                                            ; W = v___data_5
;  350       newxmthead = _serial_offsetxmthead + 1    -- offset next char
                               incf     v__serial_offsetxmthead,w;  3 OV rs rs [?? ??] 01b6 0a4e
                               movwf    v_newxmthead        ;  3 OV rs rs [?? ??] 01b7 00bf
;  351       if (newxmthead >= SERIAL_XMTBUFSIZE) then  -- beyond buffer end
                               movlw    80                  ;  3 OV rs rs [?? ??] 01b8 3050
                                                            ; W = v_newxmthead
                               subwf    v_newxmthead,w      ;  3 OV rs rs [?? ??] 01b9 023f
                               btfsc    v__status, v__z     ;  3 OV rs rs [?? ??] 01ba 1903
                               goto     l__l557             ;  3 OV rs rs [?? ??] 01bb 29be
                               btfss    v__status, v__c     ;  3 OV rs rs [?? ??] 01bc 1c03
                                                            ; W = v__serial_offsetxmthead
                               goto     l__l203             ;  3 OV rs rs [?? ??] 01bd 29bf
                                                            ; W = v__serial_offsetxmthead
l__l557
;  352          newxmthead = 0                         -- wrap to begin
                               clrf     v_newxmthead        ;  3 OV rs rs [?? ??] 01be 01bf
;  353       end if
l__l203
;  354       if (newxmthead != _serial_offsetxmttail) then  -- buffer not full
                               movf     v_newxmthead,w      ;  3 OV rs rs [?? ??] 01bf 083f
                                                            ; W = v__serial_offsetxmthead
                               subwf    v__serial_offsetxmttail,w;  3 OV rs rs [?? ??] 01c0 024f
                                                            ; W = v_newxmthead
                               btfsc    v__status, v__z     ;  3 OV rs rs [?? ??] 01c1 1903
                               goto     l__l205             ;  3 OV rs rs [?? ??] 01c2 29c6
;  355          _serial_offsetxmthead = newxmthead     -- update offset
                               movf     v_newxmthead,w      ;  3 OV rs rs [?? ??] 01c3 083f
                                                            ; W = v___data_5
                               movwf    v__serial_offsetxmthead;  3 OV rs rs [?? ??] 01c4 00ce
                                                            ; W = v_newxmthead
;  356       else                                      -- buffer full!
                               goto     l__l204             ;  3 OV rs rs [?? ??] 01c5 29cc
                                                            ; W = v__serial_offsetxmthead
l__l205
;  358             while (newxmthead == _serial_offsetxmttail) loop   -- buffer full
l__l208
                               movf     v_newxmthead,w      ;  3 OV rs rs [?? ??] 01c6 083f
                               subwf    v__serial_offsetxmttail,w;  3 OV rs rs [?? ??] 01c7 024f
                                                            ; W = v_newxmthead
                               btfsc    v__status, v__z     ;  3 OV rs rs [?? ??] 01c8 1903
;  360             end loop
                               goto     l__l208             ;  3 OV rs rs [?? ??] 01c9 29c6
                                                            ; W = v___data_5
l__l209
;  361             _serial_offsetxmthead = newxmthead  -- update offset
                               movf     v_newxmthead,w      ;  3 OV rs rs [?? ??] 01ca 083f
                               movwf    v__serial_offsetxmthead;  3 OV rs rs [?? ??] 01cb 00ce
                                                            ; W = v_newxmthead
;  366       end if
l__l204
;  367       PIE1_TXIE = TRUE                          -- (re-)enable xmit interrupts
                               datalo_set v_pie1 ; pie1_txie         ;  3 OV rs rS [?? ??] 01cc 1683
                                                            ; W = v__serial_offsetxmthead
                               bsf      v_pie1, 4 ; pie1_txie        ;  3 OV rS rS [?? ??] 01cd 160c
                                                            ; W = v__serial_offsetxmthead
;  368    end if
l__l200
;  370    return data                                  -- transmitted byte!
                               datalo_clr v___data_5        ;  3 OV r? rs [?? ??] 01ce 1283
                                                            ; W = v__serial_offsetxmthead
                               movf     v___data_5,w        ;  3 OV rs rs [?? ??] 01cf 083e
                                                            ; W = v__serial_offsetxmthead
;  372 end function
                               return                       ;  3 OV rs rs [?? ??] 01d0 0008
                                                            ; W = v___data_5
;  378 procedure serial_hw_init() is
l_serial_hw_init
;  380    _serial_offsetxmthead  = 0                   -- offset next byte from appl
                               datalo_clr v__serial_offsetxmthead;  1 OV rS rs [hl hl] 01d1 1283
                               clrf     v__serial_offsetxmthead;  1 OV rs rs [hl hl] 01d2 01ce
;  381    _serial_offsetxmttail  = 0                   -- offset next byte to port
                               clrf     v__serial_offsetxmttail;  1 OV rs rs [hl hl] 01d3 01cf
;  382    _serial_offsetrcvhead  = 0                   -- offset next byte from port
                               clrf     v__serial_offsetrcvhead;  1 OV rs rs [hl hl] 01d4 01d0
;  383    _serial_offsetrcvtail  = 0                   -- offset next byte to appl
                               clrf     v__serial_offsetrcvtail;  1 OV rs rs [hl hl] 01d5 01d1
;  385    RCSTA                  = 0b0000_0000         -- reset
                               clrf     v_rcsta             ;  1 OV rs rs [hl hl] 01d6 0198
;  386    RCSTA_SPEN             = enabled             -- serial port enable
                               bsf      v_rcsta, 7 ; rcsta_spen       ;  1 OV rs rs [hl hl] 01d7 1798
;  387    RCSTA_CREN             = enabled             -- continuous receive enable
                               bsf      v_rcsta, 4 ; rcsta_cren       ;  1 OV rs rs [hl hl] 01d8 1618
;  389    TXSTA                  = 0b0000_0000         -- reset (8 bit, asyn)
                               datalo_set v_txsta           ;  1 OV rs rS [hl hl] 01d9 1683
                               clrf     v_txsta             ;  1 OV rS rS [hl hl] 01da 0198
;  390    TXSTA_TXEN             = enabled             -- UART transmit enabled
                               bsf      v_txsta, 5 ; txsta_txen       ;  1 OV rS rS [hl hl] 01db 1698
;  393    _calculate_and_set_baudrate()                -- set baudrate
                               call     l__calculate_and_set_baudrate;  1 OV rS ?? [hl ??] 01dc 20d7
;  395    PIE1_RCIE              = enabled             -- UART receive int. enable
                               datalo_set v_pie1 ; pie1_rcie         ;  1 OV ?? ?S [?? ??] 01dd 1683
                               datahi_clr v_pie1 ; pie1_rcie         ;  1 OV ?S rS [?? ??] 01de 1303
                               bsf      v_pie1, 5 ; pie1_rcie        ;  1 OV rS rS [?? ??] 01df 168c
;  397    INTCON_PEIE            = enabled             -- periferal
                               bsf      v_intcon, 6 ; intcon_peie      ;  1 OV rS rS [?? ??] 01e0 170b
;  398    INTCON_GIE             = enabled             -- general
                               bsf      v_intcon, 7 ; intcon_gie      ;  1 OV rS rS [?? ??] 01e1 178b
;  400    serial_ctsinv          = false               -- CTS true: accept PC data
                               datalo_clr v__bitbucket ; dummy   ;  1 OV rS rs [?? ??] 01e2 1283
                               bcf      v__bitbucket, 0 ; dummy  ;  1 OV rs rs [?? ??] 01e3 106a
;  402 end procedure
                               return                       ;  1 OV rs rs [?? ??] 01e4 0008
;  418 procedure serial_hw_data'put(byte in data) is
l__serial_hw_data_put
                               datalo_clr v__pic_temp       ;  2 OV ?? ?s [?? ??] 01e5 1283
                               datahi_clr v__pic_temp       ;  2 OV ?s rs [?? ??] 01e6 1303
                               movf     v__pic_temp,w       ;  2 OV rs rs [?? ??] 01e7 0820
                               movwf    v___data_7          ;  2 OV rs rs [?? ??] 01e8 00bd
                                                            ; W = v__pic_temp
;  422    serial_send_success = false
                               bcf      v__bitbucket, 1 ; serial_send_success  ;  2 OV rs rs [?? ??] 01e9 10ea
                                                            ; W = v___data_7
;  423    while (serial_send_success == false) loop
l__l217
                               datalo_clr v__bitbucket ; serial_send_success   ;  2 OV ?? ?s [?? ??] 01ea 1283
                                                            ; W = v___data_7
                               datahi_clr v__bitbucket ; serial_send_success   ;  2 OV ?s rs [?? ??] 01eb 1303
                                                            ; W = v___data_7
                               btfsc    v__bitbucket, 1 ; serial_send_success  ;  2 OV rs rs [?? ??] 01ec 18ea
                                                            ; W = v___data_7
                               goto     l__l218             ;  2 OV rs rs [?? ??] 01ed 29f1
                                                            ; W = v___data_7
;  424       dummy = serial_send_byte(data)
                               movf     v___data_7,w        ;  2 OV rs rs [?? ??] 01ee 083d
                                                            ; W = v___data_7
                               call     l_serial_send_byte  ;  2 OV rs ?? [?? ??] 01ef 219a
                                                            ; W = v___data_7
;  425    end loop
                               goto     l__l217             ;  2 OV ?? ?? [?? ??] 01f0 29ea
l__l218
;  427 end procedure
                               return                       ;  2 OV rs rs [?? ??] 01f1 0008
                                                            ; W = v___data_7
;  449 end function
l__l225
; vcxo.jal
;   54 serial_hw_init()               
                               call     l_serial_hw_init    ;  0 OV rS ?? [hl ??] 01f2 21d1
; c:\jallib\include\jal/print.jal
;   57 procedure print_crlf(volatile byte out device) is
                               goto     l__l371             ;  0 OV ?? ?? [?? ??] 01f3 2b17
l_print_crlf
;   58    device = ASCII_CR -- cariage return
                               movlw    13                  ;  1 OV rs rs [?? ??] 01f4 300d
                                                            ; W = v__device_put
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01f5 00a0
                               movf     v__device_put,w     ;  1 OV rs rs [?? ??] 01f6 086d
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 01f7 00b4
                                                            ; W = v__device_put
                               movf     v__device_put+1,w   ;  1 OV rs rs [?? ??] 01f8 086e
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 01f9 20bd
                                                            ; W = v__device_put
;   59    device = ASCII_LF -- line feed
                               movlw    10                  ;  1 OV ?? ?? [?? ??] 01fa 300a
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 01fb 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 01fc 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01fd 00a0
                               movf     v__device_put,w     ;  1 OV rs rs [?? ??] 01fe 086d
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 01ff 00b4
                                                            ; W = v__device_put
                               movf     v__device_put+1,w   ;  1 OV rs rs [?? ??] 0200 086e
                                                            ; W = v__pic_pointer
                               goto     l__pic_indirect     ;  1 OV rs rs [?? ??] 0201 28bd
                                                            ; W = v__device_put
;   60 end procedure
;   62 procedure print_string(volatile byte out device, byte in str[]) is
l_print_string
;   63    var word len = count(str)
                               movf     v__str_count,w      ;  1 OV Rs Rs [?? ??] 0202 0822
                                                            ; W = v___str_1
                               movwf    v_len               ;  1 OV Rs Rs [?? ??] 0203 00ac
                                                            ; W = v__str_count
                               movf     v__str_count+1,w    ;  1 OV Rs Rs [?? ??] 0204 0823
                                                            ; W = v_len
                               movwf    v_len+1             ;  1 OV Rs Rs [?? ??] 0205 00ad
                                                            ; W = v__str_count
;   66    for len using i loop    
                               datahi_clr v_i               ;  1 OV Rs rs [?? ??] 0206 1303
                                                            ; W = v_len
                               clrf     v_i                 ;  1 OV rs rs [?? ??] 0207 01ef
                                                            ; W = v_len
                               goto     l__l251             ;  1 OV rs rs [?? ??] 0208 2a2c
                                                            ; W = v_len
l__l250
;   67       if (str[i] == print_string_terminator) then exit loop end if
                               datahi_set v___str_1         ;  1 OV rs Rs [?? ??] 0209 1703
                               movf     v___str_1,w         ;  1 OV Rs Rs [?? ??] 020a 0826
                               datahi_clr v_i               ;  1 OV Rs rs [?? ??] 020b 1303
                                                            ; W = v___str_1
                               addwf    v_i,w               ;  1 OV rs rs [?? ??] 020c 076f
                                                            ; W = v___str_1
                               movwf    v__fsr              ;  1 OV rs rs [?? ??] 020d 0084
                               bcf      v__status, v__irp   ;  1 OV rs rs [?? ??] 020e 1383
                               datahi_set v___str_1         ;  1 OV rs Rs [?? ??] 020f 1703
                               btfsc    v___str_1+1, 0      ;  1 OV Rs Rs [?? ??] 0210 1827
                               bsf      v__status, v__irp   ;  1 OV Rs Rs [?? ??] 0211 1783
                               movf     v__ind,w            ;  1 OV Rs Rs [?? ??] 0212 0800
                               btfsc    v__status, v__z     ;  1 OV Rs Rs [?? ??] 0213 1903
                               return                       ;  1 OV Rs Rs [?? ??] 0214 0008
l__l254
;   68       device = str[i]
                               movf     v___str_1+1,w       ;  1 OV Rs Rs [?? ??] 0215 0827
                               datahi_clr v__pic_pointer    ;  1 OV Rs rs [?? ??] 0216 1303
                                                            ; W = v___str_1
                               movwf    v__pic_pointer+1    ;  1 OV rs rs [?? ??] 0217 00b5
                                                            ; W = v___str_1
                               movf     v_i,w               ;  1 OV rs rs [?? ??] 0218 086f
                                                            ; W = v__pic_pointer
                               datahi_set v___str_1         ;  1 OV rs Rs [?? ??] 0219 1703
                                                            ; W = v_i
                               addwf    v___str_1,w         ;  1 OV Rs Rs [?? ??] 021a 0726
                                                            ; W = v_i
                               datahi_clr v__pic_pointer    ;  1 OV Rs rs [?? ??] 021b 1303
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 021c 00b4
                               btfsc    v__status, v__c     ;  1 OV rs rs [?? ??] 021d 1803
                                                            ; W = v__pic_pointer
                               incf     v__pic_pointer+1,f  ;  1 OV rs rs [?? ??] 021e 0ab5
                                                            ; W = v__pic_pointer
                               bcf      v__pic_pointer+1, 6 ;  1 OV rs rs [?? ??] 021f 1335
                               movf     v__pic_pointer+1,w  ;  1 OV rs rs [?? ??] 0220 0835
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0221 20bd
                                                            ; W = v__pic_pointer
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0222 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 0223 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0224 00a0
                               movf     v____device_put_1,w ;  1 OV rs rs [?? ??] 0225 086d
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0226 00b4
                                                            ; W = v____device_put_1
                               movf     v____device_put_1+1,w;  1 OV rs rs [?? ??] 0227 086e
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0228 20bd
                                                            ; W = v____device_put_1
;   69    end loop
                               datalo_clr v_i               ;  1 OV ?? ?s [?? ??] 0229 1283
                               datahi_clr v_i               ;  1 OV ?s rs [?? ??] 022a 1303
                               incf     v_i,f               ;  1 OV rs rs [?? ??] 022b 0aef
l__l251
                               movf     v_i,w               ;  1 OV rs rs [?? ??] 022c 086f
                                                            ; W = v_len
                               datahi_set v_len             ;  1 OV rs Rs [?? ??] 022d 1703
                                                            ; W = v_i
                               subwf    v_len,w             ;  1 OV Rs Rs [?? ??] 022e 022c
                                                            ; W = v_i
                               datahi_clr v__pic_temp       ;  1 OV Rs rs [?? ??] 022f 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0230 00a0
                               datahi_set v_len             ;  1 OV rs Rs [?? ??] 0231 1703
                                                            ; W = v__pic_temp
                               movf     v_len+1,w           ;  1 OV Rs Rs [?? ??] 0232 082d
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_temp       ;  1 OV Rs rs [?? ??] 0233 1303
                                                            ; W = v_len
                               iorwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 0234 0420
                                                            ; W = v_len
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 0235 1d03
                               goto     l__l250             ;  1 OV rs rs [?? ??] 0236 2a09
l__l252
;   71 end procedure
                               return                       ;  1 OV rs rs [?? ??] 0237 0008
;  271 procedure print_byte_dec(volatile byte out device, byte in data) is
l_print_byte_dec
                               datahi_set v___data_49       ;  1 OV rs Rs [?? ??] 0238 1703
                                                            ; W = v_gpserrorcode
                               movwf    v___data_49         ;  1 OV Rs Rs [?? ??] 0239 00a2
                                                            ; W = v_gpserrorcode
;  273    _print_universal_dec(device, data, 100, 3)
                               datahi_clr v____device_put_19;  1 OV Rs rs [?? ??] 023a 1303
                                                            ; W = v___data_49
                               movf     v____device_put_19,w;  1 OV rs rs [?? ??] 023b 086d
                                                            ; W = v___data_49
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 023c 1703
                                                            ; W = v____device_put_19
                               movwf    v____device_put_21  ;  1 OV Rs Rs [?? ??] 023d 00a4
                                                            ; W = v____device_put_19
                               datahi_clr v____device_put_19;  1 OV Rs rs [?? ??] 023e 1303
                                                            ; W = v____device_put_21
                               movf     v____device_put_19+1,w;  1 OV rs rs [?? ??] 023f 086e
                                                            ; W = v____device_put_21
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 0240 1703
                                                            ; W = v____device_put_19
                               movwf    v____device_put_21+1;  1 OV Rs Rs [?? ??] 0241 00a5
                                                            ; W = v____device_put_19
                               movf     v___data_49,w       ;  1 OV Rs Rs [?? ??] 0242 0822
                                                            ; W = v____device_put_21
                               movwf    v___data_53         ;  1 OV Rs Rs [?? ??] 0243 00a8
                                                            ; W = v___data_49
                               clrf     v___data_53+1       ;  1 OV Rs Rs [?? ??] 0244 01a9
                                                            ; W = v___data_53
                               clrf     v___data_53+2       ;  1 OV Rs Rs [?? ??] 0245 01aa
                                                            ; W = v___data_53
                               clrf     v___data_53+3       ;  1 OV Rs Rs [?? ??] 0246 01ab
                                                            ; W = v___data_53
                               movlw    100                 ;  1 OV Rs Rs [?? ??] 0247 3064
                                                            ; W = v___data_53
                               movwf    v___digit_divisor_5 ;  1 OV Rs Rs [?? ??] 0248 00ae
                               clrf     v___digit_divisor_5+1;  1 OV Rs Rs [?? ??] 0249 01af
                                                            ; W = v___digit_divisor_5
                               clrf     v___digit_divisor_5+2;  1 OV Rs Rs [?? ??] 024a 01b0
                                                            ; W = v___digit_divisor_5
                               clrf     v___digit_divisor_5+3;  1 OV Rs Rs [?? ??] 024b 01b1
                                                            ; W = v___digit_divisor_5
                               movlw    3                   ;  1 OV Rs Rs [?? ??] 024c 3003
                                                            ; W = v___digit_divisor_5
                               goto     l__print_universal_dec;  1 OV Rs Rs [?? ??] 024d 2a4e
;  275 end procedure
;  292 procedure _print_universal_dec(volatile byte out device, dword in data, sdword in digit_divisor, byte in digit_number) is
l__print_universal_dec
                               movwf    v___digit_number_5  ;  1 OV Rs Rs [?? ??] 024e 00b2
;  296    if (data == 0) then
                               movf     v___data_53,w       ;  1 OV Rs Rs [?? ??] 024f 0828
                                                            ; W = v___digit_number_5
                               iorwf    v___data_53+1,w     ;  1 OV Rs Rs [?? ??] 0250 0429
                                                            ; W = v___data_53
                               iorwf    v___data_53+2,w     ;  1 OV Rs Rs [?? ??] 0251 042a
                               iorwf    v___data_53+3,w     ;  1 OV Rs Rs [?? ??] 0252 042b
                               btfss    v__status, v__z     ;  1 OV Rs Rs [?? ??] 0253 1d03
                               goto     l__l322             ;  1 OV Rs Rs [?? ??] 0254 2a5f
;  297       device = "0"      
                               movlw    48                  ;  1 OV Rs Rs [?? ??] 0255 3030
                               datahi_clr v__pic_temp       ;  1 OV Rs rs [?? ??] 0256 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0257 00a0
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 0258 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_21,w;  1 OV Rs Rs [?? ??] 0259 0824
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  1 OV Rs rs [?? ??] 025a 1303
                                                            ; W = v____device_put_21
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 025b 00b4
                                                            ; W = v____device_put_21
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 025c 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_21+1,w;  1 OV Rs Rs [?? ??] 025d 0825
                                                            ; W = v__pic_pointer
                               goto     l__pic_indirect     ;  1 OV Rs Rs [?? ??] 025e 28bd
                                                            ; W = v____device_put_21
;  298       return
;  299    end if
l__l322
;  301    no_digits_printed_yet = true
                               bsf      v____bitbucket_42, 0 ; no_digits_printed_yet;  1 OV Rs Rs [?? ??] 025f 1435
;  302    while (digit_divisor > 0) loop
l__l323
                               movf     v___digit_divisor_5+3,w;  1 OV Rs Rs [?? ??] 0260 0831
                                                            ; W = v_digit
                               xorlw    128                 ;  1 OV Rs Rs [?? ??] 0261 3a80
                                                            ; W = v___digit_divisor_5
                               datahi_clr v__pic_temp       ;  1 OV Rs rs [?? ??] 0262 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0263 00a0
                               movlw    128                 ;  1 OV rs rs [?? ??] 0264 3080
                                                            ; W = v__pic_temp
                               subwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 0265 0220
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 0266 1d03
                               goto     l__l558             ;  1 OV rs rs [?? ??] 0267 2a73
                               movlw    0                   ;  1 OV rs rs [?? ??] 0268 3000
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 0269 1703
                               subwf    v___digit_divisor_5+2,w;  1 OV Rs Rs [?? ??] 026a 0230
                               btfss    v__status, v__z     ;  1 OV Rs Rs [?? ??] 026b 1d03
                               goto     l__l558             ;  1 OV Rs Rs [?? ??] 026c 2a73
                               movlw    0                   ;  1 OV Rs Rs [?? ??] 026d 3000
                               subwf    v___digit_divisor_5+1,w;  1 OV Rs Rs [?? ??] 026e 022f
                               btfss    v__status, v__z     ;  1 OV Rs Rs [?? ??] 026f 1d03
                               goto     l__l558             ;  1 OV Rs Rs [?? ??] 0270 2a73
                               movlw    0                   ;  1 OV Rs Rs [?? ??] 0271 3000
                               subwf    v___digit_divisor_5,w;  1 OV Rs Rs [?? ??] 0272 022e
l__l558
                               btfsc    v__status, v__z     ;  1 OV ?s Rs [?? ??] 0273 1903
                               goto     l__l324             ;  1 OV ?s Rs [?? ??] 0274 2af4
                               btfss    v__status, v__c     ;  1 OV ?s Rs [?? ??] 0275 1c03
                               goto     l__l324             ;  1 OV ?s Rs [?? ??] 0276 2af4
;  303       digit = byte ( data / digit_divisor )
                               datahi_set v___digit_divisor_5;  1 OV ?s Rs [?? ??] 0277 1703
                               movf     v___digit_divisor_5,w;  1 OV Rs Rs [?? ??] 0278 082e
                               datahi_clr v__pic_divisor    ;  1 OV Rs rs [?? ??] 0279 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 027a 00a8
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 027b 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+1,w;  1 OV Rs Rs [?? ??] 027c 082f
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_divisor    ;  1 OV Rs rs [?? ??] 027d 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+1    ;  1 OV rs rs [?? ??] 027e 00a9
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 027f 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+2,w;  1 OV Rs Rs [?? ??] 0280 0830
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_divisor    ;  1 OV Rs rs [?? ??] 0281 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+2    ;  1 OV rs rs [?? ??] 0282 00aa
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 0283 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+3,w;  1 OV Rs Rs [?? ??] 0284 0831
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_divisor    ;  1 OV Rs rs [?? ??] 0285 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+3    ;  1 OV rs rs [?? ??] 0286 00ab
                                                            ; W = v___digit_divisor_5
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 0287 1703
                                                            ; W = v__pic_divisor
                               movf     v___data_53,w       ;  1 OV Rs Rs [?? ??] 0288 0828
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 0289 1303
                                                            ; W = v___data_53
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 028a 00a0
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 028b 1703
                                                            ; W = v__pic_dividend
                               movf     v___data_53+1,w     ;  1 OV Rs Rs [?? ??] 028c 0829
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 028d 1303
                                                            ; W = v___data_53
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 028e 00a1
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 028f 1703
                                                            ; W = v__pic_dividend
                               movf     v___data_53+2,w     ;  1 OV Rs Rs [?? ??] 0290 082a
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 0291 1303
                                                            ; W = v___data_53
                               movwf    v__pic_dividend+2   ;  1 OV rs rs [?? ??] 0292 00a2
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 0293 1703
                                                            ; W = v__pic_dividend
                               movf     v___data_53+3,w     ;  1 OV Rs Rs [?? ??] 0294 082b
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 0295 1303
                                                            ; W = v___data_53
                               movwf    v__pic_dividend+3   ;  1 OV rs rs [?? ??] 0296 00a3
                                                            ; W = v___data_53
                               call     l__pic_divide       ;  1 OV rs ?? [?? ??] 0297 206b
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 0298 1283
                               datahi_clr v__pic_quotient   ;  1 OV ?s rs [?? ??] 0299 1303
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 029a 082c
                               datahi_set v_digit           ;  1 OV rs Rs [?? ??] 029b 1703
                                                            ; W = v__pic_quotient
                               movwf    v_digit             ;  1 OV Rs Rs [?? ??] 029c 00b3
                                                            ; W = v__pic_quotient
;  304       data = data % digit_divisor
                               datahi_clr v__pic_remainder  ;  1 OV Rs rs [?? ??] 029d 1303
                                                            ; W = v_digit
                               movf     v__pic_remainder,w  ;  1 OV rs rs [?? ??] 029e 0824
                                                            ; W = v_digit
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 029f 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_53         ;  1 OV Rs Rs [?? ??] 02a0 00a8
                                                            ; W = v__pic_remainder
                               datahi_clr v__pic_remainder  ;  1 OV Rs rs [?? ??] 02a1 1303
                                                            ; W = v___data_53
                               movf     v__pic_remainder+1,w;  1 OV rs rs [?? ??] 02a2 0825
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 02a3 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_53+1       ;  1 OV Rs Rs [?? ??] 02a4 00a9
                                                            ; W = v__pic_remainder
                               datahi_clr v__pic_remainder  ;  1 OV Rs rs [?? ??] 02a5 1303
                                                            ; W = v___data_53
                               movf     v__pic_remainder+2,w;  1 OV rs rs [?? ??] 02a6 0826
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 02a7 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_53+2       ;  1 OV Rs Rs [?? ??] 02a8 00aa
                                                            ; W = v__pic_remainder
                               datahi_clr v__pic_remainder  ;  1 OV Rs rs [?? ??] 02a9 1303
                                                            ; W = v___data_53
                               movf     v__pic_remainder+3,w;  1 OV rs rs [?? ??] 02aa 0827
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 02ab 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_53+3       ;  1 OV Rs Rs [?? ??] 02ac 00ab
                                                            ; W = v__pic_remainder
;  305       digit_divisor = digit_divisor / 10
                               movlw    10                  ;  1 OV Rs Rs [?? ??] 02ad 300a
                                                            ; W = v___data_53
                               datahi_clr v__pic_divisor    ;  1 OV Rs rs [?? ??] 02ae 1303
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 02af 00a8
                               clrf     v__pic_divisor+1    ;  1 OV rs rs [?? ??] 02b0 01a9
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+2    ;  1 OV rs rs [?? ??] 02b1 01aa
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+3    ;  1 OV rs rs [?? ??] 02b2 01ab
                                                            ; W = v__pic_divisor
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02b3 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5,w;  1 OV Rs Rs [?? ??] 02b4 082e
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 02b5 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 02b6 00a0
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02b7 1703
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+1,w;  1 OV Rs Rs [?? ??] 02b8 082f
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 02b9 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 02ba 00a1
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02bb 1703
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+2,w;  1 OV Rs Rs [?? ??] 02bc 0830
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 02bd 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+2   ;  1 OV rs rs [?? ??] 02be 00a2
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02bf 1703
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+3,w;  1 OV Rs Rs [?? ??] 02c0 0831
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 02c1 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+3   ;  1 OV rs rs [?? ??] 02c2 00a3
                                                            ; W = v___digit_divisor_5
                               call     l__pic_sdivide      ;  1 OV rs ?? [?? ??] 02c3 204a
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 02c4 1283
                               datahi_clr v__pic_quotient   ;  1 OV ?s rs [?? ??] 02c5 1303
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 02c6 082c
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02c7 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5 ;  1 OV Rs Rs [?? ??] 02c8 00ae
                                                            ; W = v__pic_quotient
                               datahi_clr v__pic_quotient   ;  1 OV Rs rs [?? ??] 02c9 1303
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+1,w ;  1 OV rs rs [?? ??] 02ca 082d
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02cb 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+1;  1 OV Rs Rs [?? ??] 02cc 00af
                                                            ; W = v__pic_quotient
                               datahi_clr v__pic_quotient   ;  1 OV Rs rs [?? ??] 02cd 1303
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+2,w ;  1 OV rs rs [?? ??] 02ce 082e
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02cf 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+2;  1 OV Rs Rs [?? ??] 02d0 00b0
                                                            ; W = v__pic_quotient
                               datahi_clr v__pic_quotient   ;  1 OV Rs rs [?? ??] 02d1 1303
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+3,w ;  1 OV rs rs [?? ??] 02d2 082f
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02d3 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+3;  1 OV Rs Rs [?? ??] 02d4 00b1
                                                            ; W = v__pic_quotient
;  307       if ((digit != 0) | (no_digits_printed_yet == false)) then
                               movf     v_digit,w           ;  1 OV Rs Rs [?? ??] 02d5 0833
                                                            ; W = v___digit_divisor_5
                               bsf      v____bitbucket_42, 3 ; _btemp48;  1 OV Rs Rs [?? ??] 02d6 15b5
                                                            ; W = v_digit
                               btfsc    v__status, v__z     ;  1 OV Rs Rs [?? ??] 02d7 1903
                                                            ; W = v_digit
                               bcf      v____bitbucket_42, 3 ; _btemp48;  1 OV Rs Rs [?? ??] 02d8 11b5
                                                            ; W = v_digit
                               bcf      v____bitbucket_42, 4 ; _btemp49;  1 OV Rs Rs [?? ??] 02d9 1235
                                                            ; W = v_digit
                               btfss    v____bitbucket_42, 0 ; no_digits_printed_yet;  1 OV Rs Rs [?? ??] 02da 1c35
                                                            ; W = v_digit
                               bsf      v____bitbucket_42, 4 ; _btemp49;  1 OV Rs Rs [?? ??] 02db 1635
                                                            ; W = v_digit
                               bcf      v____bitbucket_42, 5 ; _btemp50;  1 OV Rs Rs [?? ??] 02dc 12b5
                                                            ; W = v_digit
                               btfss    v____bitbucket_42, 3 ; _btemp48;  1 OV Rs Rs [?? ??] 02dd 1db5
                                                            ; W = v_digit
                               btfsc    v____bitbucket_42, 4 ; _btemp49;  1 OV Rs Rs [?? ??] 02de 1a35
                                                            ; W = v_digit
                               bsf      v____bitbucket_42, 5 ; _btemp50;  1 OV Rs Rs [?? ??] 02df 16b5
                                                            ; W = v_digit
                               btfss    v____bitbucket_42, 5 ; _btemp50;  1 OV Rs Rs [?? ??] 02e0 1eb5
                                                            ; W = v_digit
                               goto     l__l327             ;  1 OV Rs Rs [?? ??] 02e1 2af2
                                                            ; W = v_digit
;  308          device = digit | "0"
                               movlw    48                  ;  1 OV Rs Rs [?? ??] 02e2 3030
                               iorwf    v_digit,w           ;  1 OV Rs Rs [?? ??] 02e3 0433
                               movwf    v____temp_42        ;  1 OV Rs Rs [?? ??] 02e4 00b4
                               movf     v____temp_42,w      ;  1 OV Rs Rs [?? ??] 02e5 0834
                                                            ; W = v____temp_42
                               datahi_clr v__pic_temp       ;  1 OV Rs rs [?? ??] 02e6 1303
                                                            ; W = v____temp_42
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 02e7 00a0
                                                            ; W = v____temp_42
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 02e8 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_21,w;  1 OV Rs Rs [?? ??] 02e9 0824
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  1 OV Rs rs [?? ??] 02ea 1303
                                                            ; W = v____device_put_21
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 02eb 00b4
                                                            ; W = v____device_put_21
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 02ec 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_21+1,w;  1 OV Rs Rs [?? ??] 02ed 0825
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV Rs ?? [?? ??] 02ee 20bd
                                                            ; W = v____device_put_21
;  309          no_digits_printed_yet = false
                               datalo_clr v____bitbucket_42 ; no_digits_printed_yet;  1 OV ?? ?s [?? ??] 02ef 1283
                               datahi_set v____bitbucket_42 ; no_digits_printed_yet;  1 OV ?s Rs [?? ??] 02f0 1703
                               bcf      v____bitbucket_42, 0 ; no_digits_printed_yet;  1 OV Rs Rs [?? ??] 02f1 1035
;  310       end if
l__l327
;  311       digit_number = digit_number - 1
                               decf     v___digit_number_5,f;  1 OV Rs Rs [?? ??] 02f2 03b2
                                                            ; W = v_digit
;  312    end loop
                               goto     l__l323             ;  1 OV Rs Rs [?? ??] 02f3 2a60
                                                            ; W = v_digit
l__l324
;  314 end procedure
l__l241
                               return                       ;  1 OV ?s Rs [?? ??] 02f4 0008
; c:\jallib\include\jal/delay.jal
;  113 procedure delay_1ms(word in n) is
l_delay_1ms
;  115    for n loop
                               datahi_set v__floop4         ;  1 OV rs Rs [?? ??] 02f5 1703
                                                            ; W = v___n_3
                               clrf     v__floop4           ;  1 OV Rs Rs [?? ??] 02f6 01a2
                                                            ; W = v___n_3
                               clrf     v__floop4+1         ;  1 OV Rs Rs [?? ??] 02f7 01a3
                                                            ; W = v___n_3
                               goto     l__l362             ;  1 OV Rs Rs [?? ??] 02f8 2b0b
                                                            ; W = v___n_3
l__l361
;  117          _usec_delay(_one_ms_delay)
                               datalo_clr v__pic_temp       ;  1 -V rs rs [?? ??] 02f9 1283
                               datahi_clr v__pic_temp       ;  1 -V rs rs [?? ??] 02fa 1303
                               movlw    35                  ;  1 -V rs rs [?? ??] 02fb 3023
                               movwf    v__pic_temp         ;  1 -V rs rs [?? ??] 02fc 00a0
l__l562
                               movlw    13                  ;  1 -V rs rs [?? ??] 02fd 300d
                               movwf    v__pic_temp+1       ;  1 -V rs rs [?? ??] 02fe 00a1
l__l563
                               branchhi_clr l__l563         ;  1 -V rs rs [?? h?] 02ff 120a
                               branchlo_clr l__l563         ;  1 -V rs rs [h? hl] 0300 118a
                               decfsz   v__pic_temp+1,f     ;  1 -V rs rs [hl hl] 0301 0ba1
                               goto     l__l563             ;  1 -V rs rs [hl hl] 0302 2aff
                               branchhi_clr l__l562         ;  1 -V rs rs [hl hl] 0303 120a
                               branchlo_clr l__l562         ;  1 -V rs rs [hl hl] 0304 118a
                               decfsz   v__pic_temp,f       ;  1 -V rs rs [hl hl] 0305 0ba0
                               goto     l__l562             ;  1 -V rs rs [hl hl] 0306 2afd
;  121    end loop
                               datahi_set v__floop4         ;  1 OV rs Rs [hl hl] 0307 1703
                                                            ; W = v__pic_temp
                               incf     v__floop4,f         ;  1 OV Rs Rs [hl hl] 0308 0aa2
                                                            ; W = v__pic_temp
                               btfsc    v__status, v__z     ;  1 OV Rs Rs [hl hl] 0309 1903
                                                            ; W = v__pic_temp
                               incf     v__floop4+1,f       ;  1 OV Rs Rs [hl hl] 030a 0aa3
                                                            ; W = v__pic_temp
l__l362
                               movf     v__floop4,w         ;  1 OV Rs Rs [?? ??] 030b 0822
                                                            ; W = v___n_3
                               datahi_clr v___n_3           ;  1 OV Rs rs [?? ??] 030c 1303
                                                            ; W = v__floop4
                               subwf    v___n_3,w           ;  1 OV rs rs [?? ??] 030d 026d
                                                            ; W = v__floop4
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 030e 00a0
                               datahi_set v__floop4         ;  1 OV rs Rs [?? ??] 030f 1703
                                                            ; W = v__pic_temp
                               movf     v__floop4+1,w       ;  1 OV Rs Rs [?? ??] 0310 0823
                                                            ; W = v__pic_temp
                               datahi_clr v___n_3           ;  1 OV Rs rs [?? ??] 0311 1303
                                                            ; W = v__floop4
                               subwf    v___n_3+1,w         ;  1 OV rs rs [?? ??] 0312 026e
                                                            ; W = v__floop4
                               iorwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 0313 0420
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 0314 1d03
                               goto     l__l361             ;  1 OV rs rs [?? ??] 0315 2af9
;  122 end procedure
                               return                       ;  1 OV rs rs [?? ??] 0316 0008
                                                            ; W = v__pic_temp
;  138 end procedure
l__l371
; gps_converter.jal
;   16 var byte GpsErrorCode = 1  ; errorcode 1 = startup (wait for $).
                               movlw    1                   ;  0 OV ?? ?? [?? ??] 0317 3001
                               datalo_clr v_gpserrorcode    ;  0 OV ?? ?s [?? ??] 0318 1283
                               datahi_clr v_gpserrorcode    ;  0 OV ?s rs [?? ??] 0319 1303
                               movwf    v_gpserrorcode      ;  0 OV rs rs [?? ??] 031a 00e8
;   22 procedure DumpGpsInBuffer is      
                               goto     l__l408             ;  0 OV rs rs [?? ??] 031b 2bb5
                                                            ; W = v_gpserrorcode
;   44 function StoreBytes (byte in char) return bit is
l_storebytes
                               movwf    v___char_5          ;  1 OV rs rs [?? ??] 031c 00ed
                                                            ; W = v___char_7
;   47    if (char == ",") then
                               movlw    44                  ;  1 OV rs rs [?? ??] 031d 302c
                                                            ; W = v___char_5
                               subwf    v___char_5,w        ;  1 OV rs rs [?? ??] 031e 026d
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 031f 1d03
                               goto     l__l384             ;  1 OV rs rs [?? ??] 0320 2b23
;   48       return true
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 0321 1420
                               return                       ;  1 OV rs rs [?? ??] 0322 0008
;   49    end if
l__l384
;   51    if (GpsInBufferIndex >= (IN_BUF_SIZE-1)) then
                               movlw    19                  ;  1 OV rs rs [?? ??] 0323 3013
                               subwf    v_gpsinbufferindex,w;  1 OV rs rs [?? ??] 0324 0266
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 0325 1903
                               goto     l__l565             ;  1 OV rs rs [?? ??] 0326 2b29
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 0327 1c03
                                                            ; W = v_gpserrorcode
                               goto     l__l386             ;  1 OV rs rs [?? ??] 0328 2b2c
                                                            ; W = v_gpserrorcode
l__l565
;   53       GpsErrorCode = 201
                               movlw    201                 ;  1 OV rs rs [?? ??] 0329 30c9
                               movwf    v_gpserrorcode      ;  1 OV rs rs [?? ??] 032a 00e8
;   54       return;
                               return                       ;  1 OV rs rs [?? ??] 032b 0008
                                                            ; W = v_gpserrorcode
;   55    end if
l__l386
;   57    GpsInBuffer[GpsInBufferIndex] = char
                               movlw    v_gpsinbuffer       ;  1 OV rs rs [?? ??] 032c 3052
                                                            ; W = v_gpserrorcode
                               addwf    v_gpsinbufferindex,w;  1 OV rs rs [?? ??] 032d 0766
                               movwf    v__fsr              ;  1 OV rs rs [?? ??] 032e 0084
                               irp_clr                      ;  1 OV rs rs [?? ??] 032f 1383
                               movf     v___char_5,w        ;  1 OV rs rs [?? ??] 0330 086d
                               movwf    v__ind              ;  1 OV rs rs [?? ??] 0331 0080
                                                            ; W = v___char_5
;   58    GpsInBufferIndex = GpsInBufferIndex + 1
                               incf     v_gpsinbufferindex,f;  1 OV rs rs [?? ??] 0332 0ae6
;   59    GpsInBuffer[GpsInBufferIndex] = 0 ; iedere keer de afsluit-0 plaatsen.
                               movlw    v_gpsinbuffer       ;  1 OV rs rs [?? ??] 0333 3052
                               addwf    v_gpsinbufferindex,w;  1 OV rs rs [?? ??] 0334 0766
                               movwf    v__fsr              ;  1 OV rs rs [?? ??] 0335 0084
                               irp_clr                      ;  1 OV rs rs [?? ??] 0336 1383
                               clrf     v__ind              ;  1 OV rs rs [?? ??] 0337 0180
;   61    return false ; not done yet.
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 0338 1020
;   62 end function
l__l382
                               return                       ;  1 OV rs rs [?? ??] 0339 0008
                                                            ; W = v_gpserrorcode
;   64 function IsMsg(byte in name[]) return bit is
l_ismsg
;   67    for 5 using i loop       
                               clrf     v___i_2             ;  2 OV Rs Rs [?? ??] 033a 01a4
                                                            ; W = v___name_1
l__l389
;   73       if (name[i] != GpsInBuffer[i]) then return false end if
                               movf     v___name_1+1,w      ;  2 OV Rs Rs [?? ??] 033b 0821
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?? ??] 033c 1303
                                                            ; W = v___name_1
                               movwf    v__pic_pointer+1    ;  2 OV rs rs [?? ??] 033d 00b5
                                                            ; W = v___name_1
                               datahi_set v___i_2           ;  2 OV rs Rs [?? ??] 033e 1703
                                                            ; W = v__pic_pointer
                               movf     v___i_2,w           ;  2 OV Rs Rs [?? ??] 033f 0824
                                                            ; W = v__pic_pointer
                               addwf    v___name_1,w        ;  2 OV Rs Rs [?? ??] 0340 0720
                                                            ; W = v___i_2
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?? ??] 0341 1303
                               movwf    v__pic_pointer      ;  2 OV rs rs [?? ??] 0342 00b4
                               btfsc    v__status, v__c     ;  2 OV rs rs [?? ??] 0343 1803
                                                            ; W = v__pic_pointer
                               incf     v__pic_pointer+1,f  ;  2 OV rs rs [?? ??] 0344 0ab5
                                                            ; W = v__pic_pointer
                               bcf      v__pic_pointer+1, 6 ;  2 OV rs rs [?? ??] 0345 1335
                               movf     v__pic_pointer+1,w  ;  2 OV rs rs [?? ??] 0346 0835
                               call     l__pic_indirect     ;  2 OV rs ?? [?? ??] 0347 20bd
                                                            ; W = v__pic_pointer
                               datalo_clr v__pic_temp       ;  2 OV ?? ?s [?? ??] 0348 1283
                               datahi_clr v__pic_temp       ;  2 OV ?s rs [?? ??] 0349 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 034a 00a0
                               movlw    v_gpsinbuffer       ;  2 OV rs rs [?? ??] 034b 3052
                                                            ; W = v__pic_temp
                               datahi_set v___i_2           ;  2 OV rs Rs [?? ??] 034c 1703
                               addwf    v___i_2,w           ;  2 OV Rs Rs [?? ??] 034d 0724
                               movwf    v__fsr              ;  2 OV Rs Rs [?? ??] 034e 0084
                               irp_clr                      ;  2 OV Rs Rs [?? ??] 034f 1383
                               datahi_clr v__pic_temp       ;  2 OV Rs rs [?? ??] 0350 1303
                               movf     v__pic_temp,w       ;  2 OV rs rs [?? ??] 0351 0820
                               subwf    v__ind,w            ;  2 OV rs rs [?? ??] 0352 0200
                                                            ; W = v__pic_temp
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0353 1903
                               goto     l__l393             ;  2 OV rs rs [?? ??] 0354 2b57
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  2 OV rs rs [?? ??] 0355 1020
                                                            ; W = v___name_1
                               return                       ;  2 OV rs rs [?? ??] 0356 0008
                                                            ; W = v___name_1
l__l393
;   74    end loop
                               datahi_set v___i_2           ;  2 OV rs Rs [?? ??] 0357 1703
                               incf     v___i_2,f           ;  2 OV Rs Rs [?? ??] 0358 0aa4
                               movlw    5                   ;  2 OV Rs Rs [?? ??] 0359 3005
                               subwf    v___i_2,w           ;  2 OV Rs Rs [?? ??] 035a 0224
                               btfss    v__status, v__z     ;  2 OV Rs Rs [?? ??] 035b 1d03
                               goto     l__l389             ;  2 OV Rs Rs [?? ??] 035c 2b3b
;   78    return true
                               datahi_clr v__pic_temp ; _pic_temp    ;  2 OV Rs rs [?? ??] 035d 1303
                                                            ; W = v___name_1
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  2 OV rs rs [?? ??] 035e 1420
                                                            ; W = v___name_1
;   79 end function
l__l388
                               return                       ;  2 OV rs rs [?? ??] 035f 0008
                                                            ; W = v___name_1
;   88 function ParseMessageID() return byte is
l_parsemessageid
;   89    if (IsMsg(str_gpgga)) then return 1 end if
                               movlw    l__data_str_gpgga   ;  1 OV rs rs [?? ??] 0360 3028
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 0361 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 0362 00a0
                               movlw    HIGH l__data_str_gpgga;  1 OV Rs Rs [?? ??] 0363 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 0364 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 0365 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 0366 233a
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp62;  1 OV ?? ?s [?? ??] 0367 1283
                               datahi_clr v____bitbucket_4 ; _btemp62;  1 OV ?s rs [?? ??] 0368 1303
                               bcf      v____bitbucket_4, 0 ; _btemp62;  1 OV rs rs [?? ??] 0369 106d
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 036a 1820
                               bsf      v____bitbucket_4, 0 ; _btemp62;  1 OV rs rs [?? ??] 036b 146d
                               btfsc    v____bitbucket_4, 0 ; _btemp62;  1 OV rs rs [?? ??] 036c 186d
                               retlw    1                   ;  1 OV rs rs [?? ??] 036d 3401
l__l397
;   90    if (IsMsg(str_gpgll)) then return 2 end if
                               movlw    l__data_str_gpgll   ;  1 OV rs rs [?? ??] 036e 303a
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 036f 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 0370 00a0
                               movlw    HIGH l__data_str_gpgll;  1 OV Rs Rs [?? ??] 0371 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 0372 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 0373 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 0374 233a
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp63;  1 OV ?? ?s [?? ??] 0375 1283
                               datahi_clr v____bitbucket_4 ; _btemp63;  1 OV ?s rs [?? ??] 0376 1303
                               bcf      v____bitbucket_4, 1 ; _btemp63;  1 OV rs rs [?? ??] 0377 10ed
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 0378 1820
                               bsf      v____bitbucket_4, 1 ; _btemp63;  1 OV rs rs [?? ??] 0379 14ed
                               btfsc    v____bitbucket_4, 1 ; _btemp63;  1 OV rs rs [?? ??] 037a 18ed
                               retlw    2                   ;  1 OV rs rs [?? ??] 037b 3402
l__l399
;   91    if (IsMsg(str_gpgsa)) then return 3 end if
                               movlw    l__data_str_gpgsa   ;  1 OV rs rs [?? ??] 037c 3034
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 037d 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 037e 00a0
                               movlw    HIGH l__data_str_gpgsa;  1 OV Rs Rs [?? ??] 037f 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 0380 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 0381 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 0382 233a
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp64;  1 OV ?? ?s [?? ??] 0383 1283
                               datahi_clr v____bitbucket_4 ; _btemp64;  1 OV ?s rs [?? ??] 0384 1303
                               bcf      v____bitbucket_4, 2 ; _btemp64;  1 OV rs rs [?? ??] 0385 116d
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 0386 1820
                               bsf      v____bitbucket_4, 2 ; _btemp64;  1 OV rs rs [?? ??] 0387 156d
                               btfsc    v____bitbucket_4, 2 ; _btemp64;  1 OV rs rs [?? ??] 0388 196d
                               retlw    3                   ;  1 OV rs rs [?? ??] 0389 3403
l__l401
;   92    if (IsMsg(str_gpgsv)) then return 4 end if
                               movlw    l__data_str_gpgsv   ;  1 OV rs rs [?? ??] 038a 3022
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 038b 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 038c 00a0
                               movlw    HIGH l__data_str_gpgsv;  1 OV Rs Rs [?? ??] 038d 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 038e 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 038f 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 0390 233a
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp65;  1 OV ?? ?s [?? ??] 0391 1283
                               datahi_clr v____bitbucket_4 ; _btemp65;  1 OV ?s rs [?? ??] 0392 1303
                               bcf      v____bitbucket_4, 3 ; _btemp65;  1 OV rs rs [?? ??] 0393 11ed
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 0394 1820
                               bsf      v____bitbucket_4, 3 ; _btemp65;  1 OV rs rs [?? ??] 0395 15ed
                               btfsc    v____bitbucket_4, 3 ; _btemp65;  1 OV rs rs [?? ??] 0396 19ed
                               retlw    4                   ;  1 OV rs rs [?? ??] 0397 3404
l__l403
;   93    if (IsMsg(str_gprmc)) then return 5 end if
                               movlw    l__data_str_gprmc   ;  1 OV rs rs [?? ??] 0398 3040
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 0399 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 039a 00a0
                               movlw    HIGH l__data_str_gprmc;  1 OV Rs Rs [?? ??] 039b 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 039c 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 039d 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 039e 233a
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp66;  1 OV ?? ?s [?? ??] 039f 1283
                               datahi_clr v____bitbucket_4 ; _btemp66;  1 OV ?s rs [?? ??] 03a0 1303
                               bcf      v____bitbucket_4, 4 ; _btemp66;  1 OV rs rs [?? ??] 03a1 126d
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 03a2 1820
                               bsf      v____bitbucket_4, 4 ; _btemp66;  1 OV rs rs [?? ??] 03a3 166d
                               btfsc    v____bitbucket_4, 4 ; _btemp66;  1 OV rs rs [?? ??] 03a4 1a6d
                               retlw    5                   ;  1 OV rs rs [?? ??] 03a5 3405
l__l405
;   94    if (IsMsg(str_gpvtg)) then return 6 end if
                               movlw    l__data_str_gpvtg   ;  1 OV rs rs [?? ??] 03a6 302e
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 03a7 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 03a8 00a0
                               movlw    HIGH l__data_str_gpvtg;  1 OV Rs Rs [?? ??] 03a9 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 03aa 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 03ab 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 03ac 233a
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp67;  1 OV ?? ?s [?? ??] 03ad 1283
                               datahi_clr v____bitbucket_4 ; _btemp67;  1 OV ?s rs [?? ??] 03ae 1303
                               bcf      v____bitbucket_4, 5 ; _btemp67;  1 OV rs rs [?? ??] 03af 12ed
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 03b0 1820
                               bsf      v____bitbucket_4, 5 ; _btemp67;  1 OV rs rs [?? ??] 03b1 16ed
                               btfsc    v____bitbucket_4, 5 ; _btemp67;  1 OV rs rs [?? ??] 03b2 1aed
                               retlw    6                   ;  1 OV rs rs [?? ??] 03b3 3406
l__l407
;   96    return 0 ; unknown message
                               retlw    0                   ;  1 OV rs rs [?? ??] 03b4 3400
;   97 end function
l__l395
;  164 end procedure                             
l__l408
; vcxo.jal
;   70 T2CON_TOUTPS = 0b00                       -- postscaler 1:1
                               movlw    135                 ;  0 OV rs rs [?? ??] 03b5 3087
                                                            ; W = v_gpserrorcode
                               andwf    v_t2con,f           ;  0 OV rs rs [?? ??] 03b6 0592
;   71 T2CON_T2CKPS = 0b00                       -- prescaler 1:1
                               movlw    252                 ;  0 OV rs rs [?? ??] 03b7 30fc
                               andwf    v_t2con,f           ;  0 OV rs rs [?? ??] 03b8 0592
;   72 T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on       ;  0 OV rs rs [?? ??] 03b9 1512
;   73 PR2 = 249   -- count from 0 to 249 and skip back to 0 = 250 steps
                               movlw    249                 ;  0 OV rs rs [?? ??] 03ba 30f9
                               datalo_set v_pr2             ;  0 OV rs rS [?? ??] 03bb 1683
                               movwf    v_pr2               ;  0 OV rS rS [?? ??] 03bc 0092
;   75 ccp1con_p1m = 0  -- alleen output op pin P1A
                               movlw    63                  ;  0 OV rS rS [?? ??] 03bd 303f
                               datalo_clr v_ccp1con         ;  0 OV rS rs [?? ??] 03be 1283
                               andwf    v_ccp1con,f         ;  0 OV rs rs [?? ??] 03bf 0597
;   76 ccp1con_ccp1m = 0b1100  -- pwm mode
                               movlw    240                 ;  0 OV rs rs [?? ??] 03c0 30f0
                               andwf    v_ccp1con,w         ;  0 OV rs rs [?? ??] 03c1 0517
                               iorlw    12                  ;  0 OV rs rs [?? ??] 03c2 380c
                               movwf    v_ccp1con           ;  0 OV rs rs [?? ??] 03c3 0097
;   77 pin_c5_direction = output
                               datalo_set v_trisc ; pin_c5_direction        ;  0 OV rs rS [?? ??] 03c4 1683
                                                            ; W = v_ccp1con
                               bcf      v_trisc, 5 ; pin_c5_direction       ;  0 OV rS rS [?? ??] 03c5 1287
                                                            ; W = v_ccp1con
;   79 PIE1_TMR2IE = true
                               bsf      v_pie1, 1 ; pie1_tmr2ie        ;  0 OV rS rS [?? ??] 03c6 148c
                                                            ; W = v_ccp1con
;   80 INTCON_GIE = true
                               bsf      v_intcon, 7 ; intcon_gie      ;  0 OV rS rS [?? ??] 03c7 178b
                                                            ; W = v_ccp1con
;   81 INTCON_PEIE = true
                               bsf      v_intcon, 6 ; intcon_peie      ;  0 OV rS rS [?? ??] 03c8 170b
                                                            ; W = v_ccp1con
;   83 var volatile word Ticks = 0   
                               datalo_clr v_ticks           ;  0 OV rS rs [?? ??] 03c9 1283
                                                            ; W = v_ccp1con
                               clrf     v_ticks             ;  0 OV rs rs [?? ??] 03ca 01b7
                                                            ; W = v_ccp1con
                               clrf     v_ticks+1           ;  0 OV rs rs [?? ??] 03cb 01b8
                                                            ; W = v_ccp1con
;   87 print_string(serial_hw_data, str1)      
                               movlw    l__serial_hw_data_put;  0 OV rs rs [?? ??] 03cc 30e5
                                                            ; W = v_ccp1con
                               movwf    v____device_put_1   ;  0 OV rs rs [?? ??] 03cd 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 03ce 3001
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  0 OV rs rs [?? ??] 03cf 00ee
                               movlw    10                  ;  0 OV rs rs [?? ??] 03d0 300a
                                                            ; W = v____device_put_1
                               datahi_set v__str_count      ;  0 OV rs Rs [?? ??] 03d1 1703
                               movwf    v__str_count        ;  0 OV Rs Rs [?? ??] 03d2 00a2
                               clrf     v__str_count+1      ;  0 OV Rs Rs [?? ??] 03d3 01a3
                                                            ; W = v__str_count
                               movlw    l__data_str1_2      ;  0 OV Rs Rs [?? ??] 03d4 3010
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV Rs Rs [?? ??] 03d5 00a6
                               movlw    HIGH l__data_str1_2 ;  0 OV Rs Rs [?? ??] 03d6 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV Rs Rs [?? ??] 03d7 3840
                               movwf    v___str_1+1         ;  0 OV Rs Rs [?? ??] 03d8 00a7
                               call     l_print_string      ;  0 OV Rs ?? [?? ??] 03d9 2202
                                                            ; W = v___str_1
;   89 procedure SetDutyCycle (word in duty) is
                               goto     l__l432             ;  0 OV ?? ?? [?? ??] 03da 2c17
l_setdutycycle
;   91    if (duty > 999) then 
                               movlw    3                   ;  1 OV rs rs [?? ??] 03db 3003
                                                            ; W = v___duty_1
                               subwf    v___duty_1+1,w      ;  1 OV rs rs [?? ??] 03dc 026e
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 03dd 1d03
                               goto     l__l566             ;  1 OV rs rs [?? ??] 03de 2be1
                               movlw    231                 ;  1 OV rs rs [?? ??] 03df 30e7
                               subwf    v___duty_1,w        ;  1 OV rs rs [?? ??] 03e0 026d
l__l566
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 03e1 1903
                               goto     l__l431             ;  1 OV rs rs [?? ??] 03e2 2bec
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 03e3 1c03
                                                            ; W = v_ccp1con
                               goto     l__l431             ;  1 OV rs rs [?? ??] 03e4 2bec
                                                            ; W = v_ccp1con
;   92       duty = 999
                               movlw    231                 ;  1 OV rs rs [?? ??] 03e5 30e7
                               movwf    v___duty_1          ;  1 OV rs rs [?? ??] 03e6 00ed
                               movlw    3                   ;  1 OV rs rs [?? ??] 03e7 3003
                                                            ; W = v___duty_1
                               movwf    v___duty_1+1        ;  1 OV rs rs [?? ??] 03e8 00ee
;   93       serial_hw_data = "E"
                               movlw    69                  ;  1 OV rs rs [?? ??] 03e9 3045
                                                            ; W = v___duty_1
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03ea 00a0
                               call     l__serial_hw_data_put;  1 OV rs ?? [?? ??] 03eb 21e5
                                                            ; W = v__pic_temp
;   94    end if                
l__l431
;   96    ccpr1l = byte(duty >> 2)
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 03ec 1003
                                                            ; W = v_ccp1con
                               datalo_clr v___duty_1        ;  1 OV ?? ?s [?? ??] 03ed 1283
                                                            ; W = v_ccp1con
                               datahi_clr v___duty_1        ;  1 OV ?s rs [?? ??] 03ee 1303
                                                            ; W = v_ccp1con
                               rrf      v___duty_1+1,w      ;  1 OV rs rs [?? ??] 03ef 0c6e
                                                            ; W = v_ccp1con
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 03f0 00a1
                               rrf      v___duty_1,w        ;  1 OV rs rs [?? ??] 03f1 0c6d
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03f2 00a0
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 03f3 1003
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp+1,f     ;  1 OV rs rs [?? ??] 03f4 0ca1
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp,f       ;  1 OV rs rs [?? ??] 03f5 0ca0
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 03f6 0820
                               movwf    v_ccpr1l            ;  1 OV rs rs [?? ??] 03f7 0095
                                                            ; W = v__pic_temp
;   97    ccp1con_dc1b = byte(duty) & 0b11
                               movlw    3                   ;  1 OV rs rs [?? ??] 03f8 3003
                               andwf    v___duty_1,w        ;  1 OV rs rs [?? ??] 03f9 056d
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03fa 00a0
                               swapf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 03fb 0e20
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 03fc 00a1
                               movlw    48                  ;  1 OV rs rs [?? ??] 03fd 3030
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp+1,f     ;  1 OV rs rs [?? ??] 03fe 05a1
                               movlw    207                 ;  1 OV rs rs [?? ??] 03ff 30cf
                               andwf    v_ccp1con,w         ;  1 OV rs rs [?? ??] 0400 0517
                               iorwf    v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 0401 0421
                               movwf    v_ccp1con           ;  1 OV rs rs [?? ??] 0402 0097
;   99 end procedure
                               return                       ;  1 OV rs rs [?? ??] 0403 0008
                                                            ; W = v_ccp1con
;  104 procedure isr is
l_isr
;  107    if (PIR1_TMR2IF) then
                               btfss    v_pir1, 1 ; pir1_tmr2if        ;  4 OV rs rs [hl hl] 0404 1c8c
                                                            ; W = v__pic_isr_fsr
                               goto     l__serial_receive_interrupt_handler;  4 OV rs rs [hl hl] 0405 2913
                                                            ; W = v__pic_isr_fsr
;  108       PIR1_TMR2IF = false
                               bcf      v_pir1, 1 ; pir1_tmr2if        ;  4 OV rs rs [hl hl] 0406 108c
                                                            ; W = v___x_67
;  109       Ticks = Ticks + 1
                               incf     v_ticks,f           ;  4 OV rs rs [hl hl] 0407 0ab7
                                                            ; W = v___x_67
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 0408 1903
                                                            ; W = v___x_67
                               incf     v_ticks+1,f         ;  4 OV rs rs [hl hl] 0409 0ab8
                                                            ; W = v___x_67
;  110       if (Ticks > 9999) then
                               movlw    39                  ;  4 OV rs rs [hl hl] 040a 3027
                                                            ; W = v___x_67
                               subwf    v_ticks+1,w         ;  4 OV rs rs [hl hl] 040b 0238
                               btfss    v__status, v__z     ;  4 OV rs rs [hl hl] 040c 1d03
                               goto     l__l568             ;  4 OV rs rs [hl hl] 040d 2c10
                               movlw    15                  ;  4 OV rs rs [hl hl] 040e 300f
                               subwf    v_ticks,w           ;  4 OV rs rs [hl hl] 040f 0237
l__l568
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 0410 1903
                               goto     l__serial_receive_interrupt_handler;  4 OV rs rs [hl hl] 0411 2913
                               btfss    v__status, v__c     ;  4 OV rs rs [hl hl] 0412 1c03
                               goto     l__serial_receive_interrupt_handler;  4 OV rs rs [hl hl] 0413 2913
;  111          Ticks = 0
                               clrf     v_ticks             ;  4 OV rs rs [hl hl] 0414 01b7
                               clrf     v_ticks+1           ;  4 OV rs rs [hl hl] 0415 01b8
;  113    end if   
                               goto     l__serial_receive_interrupt_handler;  4 OV rs rs [hl hl] 0416 2913
;  115 end procedure
l__l432
;  118 for 8 loop
                               datalo_clr v__floop7         ;  0 OV ?? ?s [?? ??] 0417 1283
                               datahi_clr v__floop7         ;  0 OV ?s rs [?? ??] 0418 1303
                               clrf     v__floop7           ;  0 OV rs rs [?? ??] 0419 01e9
l__l438
;  120    led1 = ! led1 
                               btfss    v_porta, 2 ; pin_a2       ;  0 OV rs rs [?? ??] 041a 1d05
                               goto     l__l571             ;  0 OV rs rs [?? ??] 041b 2c1e
                               bcf      v__bitbucket, 2 ; _btemp80  ;  0 OV rs rs [?? ??] 041c 116a
                                                            ; W = v_gpserrorcode
                               goto     l__l570             ;  0 OV rs rs [?? ??] 041d 2c1f
                                                            ; W = v_gpserrorcode
l__l571
                               bsf      v__bitbucket, 2 ; _btemp80  ;  0 OV rs rs [?? ??] 041e 156a
l__l570
                               bcf      v__porta_shadow, 2 ; x69;  0 OV rs rs [?? ??] 041f 1141
                               btfsc    v__bitbucket, 2 ; _btemp80  ;  0 OV rs rs [?? ??] 0420 196a
                               bsf      v__porta_shadow, 2 ; x69;  0 OV rs rs [?? ??] 0421 1541
; c:\jallib\include\device/16f690.jal
;  100    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w   ;  0 OV rs rs [?? ??] 0422 0841
                               movwf    v_porta             ;  0 OV rs rs [?? ??] 0423 0085
                                                            ; W = v__porta_shadow
; vcxo.jal
;  120    led1 = ! led1 
; c:\jallib\include\device/16f690.jal
;  169    _PORTA_flush()
; vcxo.jal
;  120    led1 = ! led1 
;  121    delay_1ms(50)
                               movlw    50                  ;  0 OV rs rs [?? ??] 0424 3032
                               movwf    v___n_3             ;  0 OV rs rs [?? ??] 0425 00ed
                               clrf     v___n_3+1           ;  0 OV rs rs [?? ??] 0426 01ee
                                                            ; W = v___n_3
                               call     l_delay_1ms         ;  0 OV rs ?? [?? ??] 0427 22f5
                                                            ; W = v___n_3
;  122 end loop
                               datalo_clr v__floop7         ;  0 OV ?? ?s [?? ??] 0428 1283
                               datahi_clr v__floop7         ;  0 OV ?s rs [?? ??] 0429 1303
                               incf     v__floop7,f         ;  0 OV rs rs [?? ??] 042a 0ae9
                               movlw    8                   ;  0 OV rs rs [?? ??] 042b 3008
                               subwf    v__floop7,w         ;  0 OV rs rs [?? ??] 042c 0269
                               btfss    v__status, v__z     ;  0 OV rs rs [?? ??] 042d 1d03
                               goto     l__l438             ;  0 OV rs rs [?? ??] 042e 2c1a
;  124 SetDutyCycle(500)
                               movlw    244                 ;  0 OV rs rs [?? ??] 042f 30f4
                               movwf    v___duty_1          ;  0 OV rs rs [?? ??] 0430 00ed
                               movlw    1                   ;  0 OV rs rs [?? ??] 0431 3001
                                                            ; W = v___duty_1
                               movwf    v___duty_1+1        ;  0 OV rs rs [?? ??] 0432 00ee
                               call     l_setdutycycle      ;  0 OV rs ?? [?? ??] 0433 23db
                                                            ; W = v___duty_1
;  129 forever loop    
l__l443
;  139  gpstakt()
; gps_converter.jal
;  111    if (!Serial_HW_read(char)) then
                               call     l_serial_hw_read    ;  0 OV ?? ?? [?? ??] 0434 2161
                               datalo_clr v___char_7        ;  0 OV ?? ?s [?? ??] 0435 1283
                               datahi_clr v___char_7        ;  0 OV ?s rs [?? ??] 0436 1303
                               movwf    v___char_7          ;  0 OV rs rs [?? ??] 0437 00ec
                               bcf      v__bitbucket, 4 ; _btemp681  ;  0 OV rs rs [?? ??] 0438 126a
                                                            ; W = v___char_7
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 0439 1820
                                                            ; W = v___char_7
                               bsf      v__bitbucket, 4 ; _btemp681  ;  0 OV rs rs [?? ??] 043a 166a
                                                            ; W = v___char_7
                               btfss    v__bitbucket, 4 ; _btemp681  ;  0 OV rs rs [?? ??] 043b 1e6a
                                                            ; W = v___char_7
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  112       return
                               goto     l__l443             ;  0 OV rs rs [?? ??] 043c 2c34
                                                            ; W = v_gpserrorcode
;  113    end if
l__l445
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  119    if (GpsErrorCode > 1) then                     
                               movlw    1                   ;  0 OV rs rs [?? ??] 043d 3001
                                                            ; W = v___char_7
                               subwf    v_gpserrorcode,w    ;  0 OV rs rs [?? ??] 043e 0268
                               btfsc    v__status, v__z     ;  0 OV rs rs [?? ??] 043f 1903
                               goto     l__l449             ;  0 OV rs rs [?? ??] 0440 2c64
                               btfss    v__status, v__c     ;  0 OV rs rs [?? ??] 0441 1c03
                               goto     l__l449             ;  0 OV rs rs [?? ??] 0442 2c64
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  120       print_string(serial_hw_data, str_error)
                               movlw    l__serial_hw_data_put;  0 OV rs rs [?? ??] 0443 30e5
                               movwf    v____device_put_1   ;  0 OV rs rs [?? ??] 0444 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0445 3001
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  0 OV rs rs [?? ??] 0446 00ee
                               movlw    6                   ;  0 OV rs rs [?? ??] 0447 3006
                                                            ; W = v____device_put_1
                               datahi_set v__str_count      ;  0 OV rs Rs [?? ??] 0448 1703
                               movwf    v__str_count        ;  0 OV Rs Rs [?? ??] 0449 00a2
                               clrf     v__str_count+1      ;  0 OV Rs Rs [?? ??] 044a 01a3
                                                            ; W = v__str_count
                               movlw    l__data_str_error   ;  0 OV Rs Rs [?? ??] 044b 301b
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV Rs Rs [?? ??] 044c 00a6
                               movlw    HIGH l__data_str_error;  0 OV Rs Rs [?? ??] 044d 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV Rs Rs [?? ??] 044e 3840
                               movwf    v___str_1+1         ;  0 OV Rs Rs [?? ??] 044f 00a7
                               call     l_print_string      ;  0 OV Rs ?? [?? ??] 0450 2202
                                                            ; W = v___str_1
;  121       print_byte_dec(serial_hw_data, GpsErrorCode)
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0451 30e5
                               datalo_clr v____device_put_19;  0 OV ?? ?s [?? ??] 0452 1283
                               datahi_clr v____device_put_19;  0 OV ?s rs [?? ??] 0453 1303
                               movwf    v____device_put_19  ;  0 OV rs rs [?? ??] 0454 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0455 3001
                                                            ; W = v____device_put_19
                               movwf    v____device_put_19+1;  0 OV rs rs [?? ??] 0456 00ee
                               movf     v_gpserrorcode,w    ;  0 OV rs rs [?? ??] 0457 0868
                                                            ; W = v____device_put_19
                               call     l_print_byte_dec    ;  0 OV rs ?? [?? ??] 0458 2238
                                                            ; W = v_gpserrorcode
;  122       print_crlf(serial_hw_data) 
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0459 30e5
                               datalo_clr v__device_put     ;  0 OV ?? ?s [?? ??] 045a 1283
                               datahi_clr v__device_put     ;  0 OV ?s rs [?? ??] 045b 1303
                               movwf    v__device_put       ;  0 OV rs rs [?? ??] 045c 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 045d 3001
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  0 OV rs rs [?? ??] 045e 00ee
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 045f 21f4
                                                            ; W = v__device_put
;  123       GpsErrorCode = 1
                               movlw    1                   ;  0 OV ?? ?? [?? ??] 0460 3001
                               datalo_clr v_gpserrorcode    ;  0 OV ?? ?s [?? ??] 0461 1283
                               datahi_clr v_gpserrorcode    ;  0 OV ?s rs [?? ??] 0462 1303
                               movwf    v_gpserrorcode      ;  0 OV rs rs [?? ??] 0463 00e8
;  124    end if
l__l449
;  126    if (char == "$") then
                               movlw    36                  ;  0 OV rs rs [?? ??] 0464 3024
                               subwf    v___char_7,w        ;  0 OV rs rs [?? ??] 0465 026c
                               btfss    v__status, v__z     ;  0 OV rs rs [?? ??] 0466 1d03
                               goto     l__l451             ;  0 OV rs rs [?? ??] 0467 2c6c
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  128       GpsMsgNr    = 0
;  129       GpsFieldNr  = 0                      
                               clrf     v_gpsfieldnr        ;  0 OV rs rs [?? ??] 0468 01e7
;  130       GpsInBufferIndex = 0
                               clrf     v_gpsinbufferindex  ;  0 OV rs rs [?? ??] 0469 01e6
;  132       GpsErrorCode = 0  ; clear prev errors on new msg start
                               clrf     v_gpserrorcode      ;  0 OV rs rs [?? ??] 046a 01e8
;  135       return
                               goto     l__l443             ;  0 OV rs rs [?? ??] 046b 2c34
;  136    end if
l__l451
;  138    if (GpsErrorCode > 0) then
                               movf     v_gpserrorcode,w    ;  0 OV rs rs [?? ??] 046c 0868
                               btfss    v__status, v__z     ;  0 OV rs rs [?? ??] 046d 1d03
                                                            ; W = v_gpserrorcode
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  139       return
                               goto     l__l443             ;  0 OV rs rs [?? ??] 046e 2c34
;  140    end if   
l__l453
;  142    if (StoreBytes(char)) then ; put byte in buffer, true = field end
                               movf     v___char_7,w        ;  0 OV rs rs [?? ??] 046f 086c
                                                            ; W = v_gpserrorcode
                               call     l_storebytes        ;  0 OV rs ?? [?? ??] 0470 231c
                                                            ; W = v___char_7
                               datalo_clr v__bitbucket+1 ; _btemp741 ;  0 OV ?? ?s [?? ??] 0471 1283
                               datahi_clr v__bitbucket+1 ; _btemp741 ;  0 OV ?s rs [?? ??] 0472 1303
                               bcf      v__bitbucket+1, 2 ; _btemp741;  0 OV rs rs [?? ??] 0473 116b
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 0474 1820
                               bsf      v__bitbucket+1, 2 ; _btemp741;  0 OV rs rs [?? ??] 0475 156b
                               btfss    v__bitbucket+1, 2 ; _btemp741;  0 OV rs rs [?? ??] 0476 1d6b
                               goto     l__l461             ;  0 OV rs rs [?? ??] 0477 2c9f
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  144       if (GpsFieldNr == 0) then
                               movf     v_gpsfieldnr,w      ;  0 OV rs rs [?? ??] 0478 0867
                               btfss    v__status, v__z     ;  0 OV rs rs [?? ??] 0479 1d03
                                                            ; W = v_gpsfieldnr
                               goto     l__l459             ;  0 OV rs rs [?? ??] 047a 2c9b
                                                            ; W = v_gpsfieldnr
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  147          GpsMsgNr = ParseMessageID()    
                               call     l_parsemessageid    ;  0 OV rs ?? [?? ??] 047b 2360
;  149          print_string(serial_hw_data, str_msg)  
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 047c 30e5
                               datalo_clr v____device_put_1 ;  0 OV ?? ?s [?? ??] 047d 1283
                               datahi_clr v____device_put_1 ;  0 OV ?s rs [?? ??] 047e 1303
                               movwf    v____device_put_1   ;  0 OV rs rs [?? ??] 047f 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0480 3001
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  0 OV rs rs [?? ??] 0481 00ee
                               movlw    4                   ;  0 OV rs rs [?? ??] 0482 3004
                                                            ; W = v____device_put_1
                               datahi_set v__str_count      ;  0 OV rs Rs [?? ??] 0483 1703
                               movwf    v__str_count        ;  0 OV Rs Rs [?? ??] 0484 00a2
                               clrf     v__str_count+1      ;  0 OV Rs Rs [?? ??] 0485 01a3
                                                            ; W = v__str_count
                               movlw    l__data_str_msg     ;  0 OV Rs Rs [?? ??] 0486 3046
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV Rs Rs [?? ??] 0487 00a6
                               movlw    HIGH l__data_str_msg;  0 OV Rs Rs [?? ??] 0488 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV Rs Rs [?? ??] 0489 3840
                               movwf    v___str_1+1         ;  0 OV Rs Rs [?? ??] 048a 00a7
                               call     l_print_string      ;  0 OV Rs ?? [?? ??] 048b 2202
                                                            ; W = v___str_1
;  150          print_byte_dec(serial_hw_data, GpsMsgNr) 
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 048c 30e5
                               datalo_clr v____device_put_19;  0 OV ?? ?s [?? ??] 048d 1283
                               datahi_clr v____device_put_19;  0 OV ?s rs [?? ??] 048e 1303
                               movwf    v____device_put_19  ;  0 OV rs rs [?? ??] 048f 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0490 3001
                                                            ; W = v____device_put_19
                               movwf    v____device_put_19+1;  0 OV rs rs [?? ??] 0491 00ee
                               movlw    0                   ;  0 OV rs rs [?? ??] 0492 3000
                                                            ; W = v____device_put_19
                               call     l_print_byte_dec    ;  0 OV rs ?? [?? ??] 0493 2238
;  151          print_crlf(serial_hw_data)
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0494 30e5
                               datalo_clr v__device_put     ;  0 OV ?? ?s [?? ??] 0495 1283
                               datahi_clr v__device_put     ;  0 OV ?s rs [?? ??] 0496 1303
                               movwf    v__device_put       ;  0 OV rs rs [?? ??] 0497 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0498 3001
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  0 OV rs rs [?? ??] 0499 00ee
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 049a 21f4
                                                            ; W = v__device_put
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  153          if (GpsMsgNr == 1) then verbose = 1 end if
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  154          if (GpsMsgNr == 5) then verbose = 1 end if
;  157       end if
l__l459
;  160       GpsInBufferIndex = 0
                               datalo_clr v_gpsinbufferindex;  0 OV ?? ?s [?? ??] 049b 1283
                                                            ; W = v_gpsfieldnr
                               datahi_clr v_gpsinbufferindex;  0 OV ?s rs [?? ??] 049c 1303
                                                            ; W = v_gpsfieldnr
                               clrf     v_gpsinbufferindex  ;  0 OV rs rs [?? ??] 049d 01e6
                                                            ; W = v_gpsfieldnr
;  161       GpsFieldNr = GpsFieldNr + 1
                               incf     v_gpsfieldnr,f      ;  0 OV rs rs [?? ??] 049e 0ae7
                                                            ; W = v_gpsfieldnr
;  163    end if
l__l461
;  164 end procedure                             
l__l463
; vcxo.jal
;  139  gpstakt()
;  161 end loop
                               goto     l__l443             ;  0 OV rs rs [?? ??] 049f 2c34
                               end
; --- procedures & call stack
;{root} ----- -U- (frame_sz=124 blocks=19)
;   {block enter}
;     --- records ---
;     --- variables ---
;     460d98:_jal_version  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 2004
;     460e88:_jal_build  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 20100313
;     461588:_device_id word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 5120
;     461be8:_pictype  (type=a dflags=C---- sz=6 use=0 assigned=0)
;      = 49,54,70,54,57,48
;     461a98:_datasheet  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 52,49,50,54,50
;     462108:_pgmspec  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 52,49,50,48,52
;     4616d8:_pic_12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1
;     4617c8:_pic_14  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2
;     4618b8:_pic_16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 3
;     4619a8:_sx_12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 4
;     462868:_pic_14h  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 5
;     4629d8:_pjal bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     462b48:_w byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     462cb8:_f byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     462e28:_true bit (type=B dflags=C--B- sz=1 use=14 assigned=0 bit=0)
;      = 1
;     462f98:_false bit (type=B dflags=C--B- sz=1 use=13 assigned=0 bit=0)
;      = 0
;     461488:_high bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     463108:_low bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     463238:_on bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     463368:_off bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     463498:_enabled bit (type=B dflags=C--B- sz=1 use=6 assigned=0 bit=0)
;      = 1
;     4635c8:_disabled bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     4636f8:_input bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     463828:_output bit (type=B dflags=C--B- sz=1 use=2 assigned=0 bit=0)
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
;     469b08:_pic_16f716  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315136
;     469c48:_pic_16f72  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1310880
;     469d88:_pic_16f722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316992
;     469ec8:_pic_16f722a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317664
;     46a108:_pic_16f723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316960
;     46a248:_pic_16f723a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317632
;     46a388:_pic_16f724  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316928
;     46a4c8:_pic_16f726  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316896
;     46a608:_pic_16f727  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316864
;     46a748:_pic_16f73  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312256
;     46a888:_pic_16f737  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313696
;     46a9c8:_pic_16f74  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312288
;     46ab08:_pic_16f747  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313760
;     46ac48:_pic_16f76  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312320
;     46ad88:_pic_16f767  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314464
;     46aec8:_pic_16f77  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312352
;     46b108:_pic_16f777  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314272
;     46b248:_pic_16f785  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315328
;     46b388:_pic_16f818  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311936
;     46b4c8:_pic_16f819  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311968
;     46b608:_pic_16f83  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1376131
;     46b748:_pic_16f84  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1376132
;     46b888:_pic_16f84a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1374282
;     46b9c8:_pic_16f87  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312544
;     46bb08:_pic_16f870  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314048
;     46bc48:_pic_16f871  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314080
;     46bd88:_pic_16f872  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312992
;     46bec8:_pic_16f873  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313120
;     46c108:_pic_16f873a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314368
;     46c248:_pic_16f874  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313056
;     46c388:_pic_16f874a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314400
;     46c4c8:_pic_16f876  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313248
;     46c608:_pic_16f876a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314304
;     46c748:_pic_16f877  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313184
;     46c888:_pic_16f877a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314336
;     46c9c8:_pic_16f88  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312608
;     46cb08:_pic_16f882  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318912
;     46cc48:_pic_16f883  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318944
;     46cd88:_pic_16f884  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318976
;     46cec8:_pic_16f886  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319008
;     46d108:_pic_16f887  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319040
;     46d248:_pic_16f913  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315808
;     46d388:_pic_16f914  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315776
;     46d4c8:_pic_16f916  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315744
;     46d608:_pic_16f917  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315712
;     46d748:_pic_16f946  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315936
;     46d888:_pic_16hv610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319584
;     46d9c8:_pic_16hv616  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315424
;     46db08:_pic_16hv785  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315360
;     46dc48:_pic_16lf1823  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320992
;     46dd88:_pic_16lf1826  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1321088
;     46dec8:_pic_16lf1827  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1321120
;     46e108:_pic_16lf1933  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319936
;     46e248:_pic_16lf1934  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320000
;     46e388:_pic_16lf1936  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320032
;     46e4c8:_pic_16lf1937  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320064
;     46e608:_pic_16lf1938  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320096
;     46e748:_pic_16lf1939  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320128
;     46e888:_pic_16lf1946  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320320
;     46e9c8:_pic_16lf1947  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320352
;     46eb08:_pic_16lf722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317248
;     46ec48:_pic_16lf722a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317728
;     46ed88:_pic_16lf723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317216
;     46eec8:_pic_16lf723a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317696
;     46f108:_pic_16lf724  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317184
;     46f248:_pic_16lf726  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317152
;     46f388:_pic_16lf727  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317120
;     46f4c8:_pic_18f1220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443808
;     46f608:_pic_18f1230  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449472
;     46f748:_pic_18f1320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443776
;     46f888:_pic_18f1330  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449504
;     46f9c8:_pic_18f13k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462080
;     46fb08:_pic_18f13k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460032
;     46fc48:_pic_18f14k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462048
;     46fd88:_pic_18f14k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460064
;     46fec8:_pic_18f2220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443200
;     4613d8:_pic_18f2221  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450336
;     470108:_pic_18f2320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443072
;     470248:_pic_18f2321  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450272
;     470388:_pic_18f2331  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444064
;     4704c8:_pic_18f23k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450208
;     470608:_pic_18f23k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464128
;     470748:_pic_18f2410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446240
;     470888:_pic_18f242  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442944
;     4709c8:_pic_18f2420  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446208
;     470b08:_pic_18f2423  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446224
;     470c48:_pic_18f2431  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444032
;     470d88:_pic_18f2439  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442944
;     470ec8:_pic_18f2450  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451040
;     471108:_pic_18f2455  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446496
;     471248:_pic_18f2458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452640
;     471388:_pic_18f248  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443840
;     4714c8:_pic_18f2480  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448672
;     471608:_pic_18f24j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449216
;     471748:_pic_18f24j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461632
;     471888:_pic_18f24j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461248
;     4719c8:_pic_18f24k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450144
;     471b08:_pic_18f24k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463872
;     471c48:_pic_18f2510  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446176
;     471d88:_pic_18f2515  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445088
;     471ec8:_pic_18f252  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442816
;     472108:_pic_18f2520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446144
;     472248:_pic_18f2523  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446160
;     472388:_pic_18f2525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445056
;     4724c8:_pic_18f2539  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442816
;     472608:_pic_18f2550  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446464
;     472748:_pic_18f2553  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452608
;     472888:_pic_18f258  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443904
;     4729c8:_pic_18f2580  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448640
;     472b08:_pic_18f2585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445600
;     472c48:_pic_18f25j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448960
;     472d88:_pic_18f25j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461664
;     472ec8:_pic_18f25j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461280
;     473108:_pic_18f25k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450080
;     473248:_pic_18f25k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463616
;     473388:_pic_18f2610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445024
;     4734c8:_pic_18f2620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444992
;     473608:_pic_18f2680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445568
;     473748:_pic_18f2682  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451776
;     473888:_pic_18f2685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451808
;     4739c8:_pic_18f26j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461696
;     473b08:_pic_18f26j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461312
;     473c48:_pic_18f26k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450016
;     473d88:_pic_18f26k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463360
;     473ec8:_pic_18f4220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443232
;     474108:_pic_18f4221  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450304
;     474248:_pic_18f4320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443104
;     474388:_pic_18f4321  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450240
;     4744c8:_pic_18f4331  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444000
;     474608:_pic_18f43k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450176
;     474748:_pic_18f43k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464064
;     474888:_pic_18f4410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446112
;     4749c8:_pic_18f442  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442976
;     474b08:_pic_18f4420  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446080
;     474c48:_pic_18f4423  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446096
;     474d88:_pic_18f4431  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443968
;     474ec8:_pic_18f4439  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442976
;     475108:_pic_18f4450  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451008
;     475248:_pic_18f4455  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446432
;     475388:_pic_18f4458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452576
;     4754c8:_pic_18f448  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443872
;     475608:_pic_18f4480  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448608
;     475748:_pic_18f44j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449248
;     475888:_pic_18f44j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461728
;     4759c8:_pic_18f44j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461344
;     475b08:_pic_18f44k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450112
;     475c48:_pic_18f44k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463808
;     475d88:_pic_18f4510  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446048
;     475ec8:_pic_18f4515  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444960
;     476108:_pic_18f452  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442848
;     476248:_pic_18f4520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446016
;     476388:_pic_18f4523  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446032
;     4764c8:_pic_18f4525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444928
;     476608:_pic_18f4539  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442848
;     476748:_pic_18f4550  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446400
;     476888:_pic_18f4553  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452544
;     4769c8:_pic_18f458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443936
;     476b08:_pic_18f4580  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448576
;     476c48:_pic_18f4585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445536
;     476d88:_pic_18f45j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448992
;     476ec8:_pic_18f45j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461760
;     477108:_pic_18f45j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461376
;     477248:_pic_18f45k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450048
;     477388:_pic_18f45k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463552
;     4774c8:_pic_18f4610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444896
;     477608:_pic_18f4620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444864
;     477748:_pic_18f4680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445504
;     477888:_pic_18f4682  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451840
;     4779c8:_pic_18f4685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451872
;     477b08:_pic_18f46j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461792
;     477c48:_pic_18f46j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461408
;     477d88:_pic_18f46k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449984
;     477ec8:_pic_18f46k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463296
;     478108:_pic_18f6310  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444832
;     478248:_pic_18f6390  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444768
;     478388:_pic_18f6393  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448448
;     4784c8:_pic_18f63j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456384
;     478608:_pic_18f63j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456128
;     478748:_pic_18f6410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443552
;     478888:_pic_18f6490  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443488
;     4789c8:_pic_18f6493  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445376
;     478b08:_pic_18f64j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456416
;     478c48:_pic_18f64j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456160
;     478d88:_pic_18f6520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444640
;     478ec8:_pic_18f6525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444576
;     479108:_pic_18f6527  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446720
;     479248:_pic_18f6585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444448
;     479388:_pic_18f65j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447200
;     4794c8:_pic_18f65j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456480
;     479608:_pic_18f65j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447232
;     479748:_pic_18f65j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458432
;     479888:_pic_18f65j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456224
;     4799c8:_pic_18f6620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443424
;     479b08:_pic_18f6621  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444512
;     479c48:_pic_18f6622  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446784
;     479d88:_pic_18f6627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446848
;     479ec8:_pic_18f6628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460672
;     47a108:_pic_18f6680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444384
;     47a248:_pic_18f66j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447264
;     47a388:_pic_18f66j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459264
;     47a4c8:_pic_18f66j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447296
;     47a608:_pic_18f66j16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459296
;     47a748:_pic_18f66j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458496
;     47a888:_pic_18f66j55  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458528
;     47a9c8:_pic_18f66j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447936
;     47ab08:_pic_18f66j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449728
;     47ac48:_pic_18f66j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462272
;     47ad88:_pic_18f66j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462336
;     47aec8:_pic_18f6720  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443360
;     47b108:_pic_18f6722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446912
;     47b248:_pic_18f6723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460736
;     47b388:_pic_18f67j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447328
;     47b4c8:_pic_18f67j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459328
;     47b608:_pic_18f67j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458560
;     47b748:_pic_18f67j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449760
;     47b888:_pic_18f67j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462304
;     47b9c8:_pic_18f67j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462368
;     47bb08:_pic_18f8310  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444800
;     47bc48:_pic_18f8390  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444736
;     47bd88:_pic_18f8393  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448480
;     47bec8:_pic_18f83j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456512
;     47c108:_pic_18f83j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456256
;     47c248:_pic_18f8410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443520
;     47c388:_pic_18f8490  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443456
;     47c4c8:_pic_18f8493  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445408
;     47c608:_pic_18f84j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456544
;     47c748:_pic_18f84j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456288
;     47c888:_pic_18f8520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444608
;     47c9c8:_pic_18f8525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444544
;     47cb08:_pic_18f8527  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446752
;     47cc48:_pic_18f8585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444416
;     47cd88:_pic_18f85j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447392
;     47cec8:_pic_18f85j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456608
;     47d108:_pic_18f85j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447680
;     47d248:_pic_18f85j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458592
;     47d388:_pic_18f85j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456352
;     47d4c8:_pic_18f8620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443392
;     47d608:_pic_18f8621  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444480
;     47d748:_pic_18f8622  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446816
;     47d888:_pic_18f8627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446880
;     47d9c8:_pic_18f8628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460704
;     47db08:_pic_18f8680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444352
;     47dc48:_pic_18f86j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447712
;     47dd88:_pic_18f86j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459424
;     47dec8:_pic_18f86j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447744
;     47e108:_pic_18f86j16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459456
;     47e248:_pic_18f86j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458656
;     47e388:_pic_18f86j55  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458688
;     47e4c8:_pic_18f86j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447968
;     47e608:_pic_18f86j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449792
;     47e748:_pic_18f86j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462400
;     47e888:_pic_18f86j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462464
;     47e9c8:_pic_18f8720  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443328
;     47eb08:_pic_18f8722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446944
;     47ec48:_pic_18f8723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460768
;     47ed88:_pic_18f87j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447776
;     47eec8:_pic_18f87j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459488
;     47f108:_pic_18f87j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458720
;     47f248:_pic_18f87j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449824
;     47f388:_pic_18f87j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462432
;     47f4c8:_pic_18f87j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462496
;     47f608:_pic_18f96j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448000
;     47f748:_pic_18f96j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449856
;     47f888:_pic_18f97j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449888
;     47f9c8:_pic_18lf13k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462144
;     47fb08:_pic_18lf13k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459968
;     47fc48:_pic_18lf14k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462112
;     47fd88:_pic_18lf14k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460000
;     47fec8:_pic_18lf23k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464160
;     480108:_pic_18lf24j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449280
;     480248:_pic_18lf24j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461824
;     480388:_pic_18lf24j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461440
;     4804c8:_pic_18lf24k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463904
;     480608:_pic_18lf25j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449024
;     480748:_pic_18lf25j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461856
;     480888:_pic_18lf25j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461472
;     4809c8:_pic_18lf25k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463648
;     480b08:_pic_18lf26j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461888
;     480c48:_pic_18lf26j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461504
;     480d88:_pic_18lf26k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463392
;     480ec8:_pic_18lf43k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464096
;     481108:_pic_18lf44j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449312
;     481248:_pic_18lf44j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461920
;     481388:_pic_18lf44j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461536
;     4814c8:_pic_18lf44k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463840
;     481608:_pic_18lf45j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449056
;     481748:_pic_18lf45j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461952
;     481888:_pic_18lf45j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461568
;     4819c8:_pic_18lf45k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463584
;     481b08:_pic_18lf46j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461984
;     481c48:_pic_18lf46j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461600
;     481d88:_pic_18lf46k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463328
;     4638f8:_target_cpu  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2
;     481f68:_target_chip  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315840
;     482618:_target_chip_name  (type=a dflags=C---- sz=6 use=0 assigned=0)
;      = 49,54,102,54,57,48
;     482408:_target_bank_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 128
;     482348:_target_page_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2048
;     482288:__stack_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8
;     4821c8:__code_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 4096
;     482c68:__eeprom  (type=a dflags=C---- sz=256 use=0 assigned=0)
;      = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;     482e38:__eeprom_used  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 0
;     482ef8:__eeprom_base  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 8448
;     483108:__id0  (type=a dflags=C---- sz=4 use=0 assigned=0)
;      = 0,0,0,0
;     4831e8:__id0_used  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 0
;     4832a8:__id0_base  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 8192
;     4824c8:__pic_accum byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=007e)
;     482108:__pic_isr_w byte (type=i dflags=-V--- sz=1 use=2 assigned=2 base=007f)
;     4839b8:__fuses_ct word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 1
;     483b28:__fuse_base word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 8199
;     483c98:__fuses word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 16374
;     4838b8:_indf byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0000)
;     484108:__ind byte (type=i dflags=-V--- sz=1 use=4 assigned=4 base=0000)
;     4843b8:_tmr0 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0001)
;     484588:_pcl byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0002)
;     484838:__pcl byte (type=i dflags=-V--- sz=1 use=9 assigned=10 base=0002)
;     484ae8:_status byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0003)
;     484d98:_status_irp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> status+0
;     484ee8:_status_rp  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=5) ---> status+0
;     485108:_status_nto bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> status+0
;     485268:_status_npd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> status+0
;     4853c8:_status_z bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> status+0
;     485528:_status_dc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> status+0
;     485688:_status_c bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> status+0
;     4857e8:__status byte (type=i dflags=-V--- sz=1 use=76 assigned=8 base=0003)
;     485b98:__irp byte (type=i dflags=C---- sz=1 use=4 assigned=0)
;      = 7
;     485d08:__rp1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     485e78:__rp0 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     486108:__not_to byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     486278:__not_pd byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     4863e8:__z byte (type=i dflags=C---- sz=1 use=112 assigned=0)
;      = 2
;     486558:__dc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     4866c8:__c byte (type=i dflags=C---- sz=1 use=46 assigned=0)
;      = 0
;     485a98:_fsr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0004)
;     4869e8:__fsr byte (type=i dflags=-V--- sz=1 use=1 assigned=9 base=0004)
;     486c98:_porta byte (type=i dflags=-V--- sz=1 use=2 assigned=1 base=0005)
;     486e98:__porta_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=3 base=0041)
;     487598:__porta_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     488158:__porta_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4883e8:__porta_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     487dc8:__porta_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48ba68:__porta_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48b798:__porta_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48e2f8:_porta_ra5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e488:_pin_a5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e608:_pin_t1cki bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e6e8:_pin_osc1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e7c8:_pin_clkin bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48ec08:__pin_a5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48e8b8:_porta_ra4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48f788:_pin_a4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48f908:_pin_an3 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48f9e8:_pin_t1g bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48fac8:_pin_osc2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48fba8:_pin_clkout bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48f258:__pin_a4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48fc98:_porta_ra3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     490788:_pin_a3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     490908:_pin_mclr bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     4909e8:_pin_vpp bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     490e28:__pin_a3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     490ad8:_porta_ra2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     4917f8:_pin_a2 bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=2) ---> porta+0
;     491978:_pin_an2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491a58:_pin_t0cki bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491b38:_pin_c1out bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491f78:__pin_a2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     491c28:_porta_ra1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492a78:_pin_a1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492bf8:_pin_an1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492cd8:_pin_c12in0_neg bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492db8:_pin_icspclk bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     4931b8:__pin_a1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     492ea8:_porta_ra0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     493c28:_pin_a0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     493da8:_pin_an0 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     493e88:_pin_c1in_pos bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     493f68:_pin_icspdat bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     4936f8:_pin_ulpwu bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     494458:__pin_a0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     494108:_portb byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0006)
;     494f68:__portb_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     495598:__portb_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4961b8:__portb_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     497108:__portb_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     495e38:__portb_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     499b38:__portb_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     499868:__portb_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49c3e8:_portb_rb7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49c578:_pin_b7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49c6f8:_pin_tx bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49c7d8:_pin_ck bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49cc18:__pin_b7_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49c8c8:_portb_rb6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     49d788:_pin_b6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     49d908:_pin_sck bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     49d9e8:_pin_scl bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     49de28:__pin_b6_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49dad8:_portb_rb5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     49e7f8:_pin_b5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     49e978:_pin_an11 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     49ea58:_pin_rx bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     49eb38:_pin_dt bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     49ef78:__pin_b5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49ec28:_portb_rb4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     49fa78:_pin_b4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     49fbf8:_pin_an10 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     49fcd8:_pin_sdi bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     49fdb8:_pin_sda bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     49add8:__pin_b4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49fea8:_portc byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0007)
;     4a0b88:__portc_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     4a11b8:__portc_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4a1d28:__portc_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a2ca8:__portc_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a1a58:__portc_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a5708:__portc_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a5438:__portc_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a7ef8:_portc_rc7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4a8108:_pin_c7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4a8288:_pin_an9 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4a8368:_pin_sdo bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4a87a8:__pin_c7_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a8458:_portc_rc6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4a92a8:_pin_c6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4a9428:_pin_an8 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4a9508:_pin_ss bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4a9948:__pin_c6_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a95f8:_portc_rc5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4aa468:_pin_c5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4aa5e8:_pin_ccp1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4aa6c8:_pin_p1a bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4aab08:__pin_c5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4aa7b8:_portc_rc4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4ab6a8:_pin_c4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4ab828:_pin_c2out bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4ab908:_pin_p1b bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4abd48:__pin_c4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ab9f8:_portc_rc3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4ac7f8:_pin_c3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4ac978:_pin_an7 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4aca58:_pin_c12in3_neg bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4acb38:_pin_p1c bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4acf78:__pin_c3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4acc28:_portc_rc2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4ada78:_pin_c2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4adbf8:_pin_an6 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4adcd8:_pin_c12in2_neg bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4addb8:_pin_p1d bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4ae1b8:__pin_c2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4adea8:_portc_rc1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4aec28:_pin_c1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4aeda8:_pin_an5 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4aee88:_pin_c12in1_neg bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4af1f8:__pin_c1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4aef78:_portc_rc0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4afc68:_pin_c0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4afde8:_pin_an4 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4afec8:_pin_c2in_pos bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4a5f58:__pin_c0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4af738:_pclath byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000a)
;     4b0c28:_pclath_pclath  (type=i dflags=-V-B- sz=5 use=0 assigned=0 bit=0) ---> pclath+0
;     4b0e18:__pclath byte (type=i dflags=-V--- sz=1 use=1 assigned=3 base=000a)
;     4b1108:_intcon byte (type=i dflags=-V--- sz=1 use=0 assigned=4 base=000b)
;     4b13b8:_intcon_gie bit (type=B dflags=-V-B- sz=1 use=0 assigned=2 bit=7) ---> intcon+0
;     4b1518:_intcon_peie bit (type=B dflags=-V-B- sz=1 use=0 assigned=2 bit=6) ---> intcon+0
;     4b1678:_intcon_tmr0ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> intcon+0
;     4b17d8:_intcon_inte bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> intcon+0
;     4b1938:_intcon_rabie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> intcon+0
;     4b1a98:_intcon_tmr0if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> intcon+0
;     4b1bf8:_intcon_intf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> intcon+0
;     4b1d58:_intcon_rabif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> intcon+0
;     4b1eb8:_pir1 byte (type=i dflags=-V--- sz=1 use=4 assigned=1 base=000c)
;     4b2108:_pir1_adif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pir1+0
;     4b2268:_pir1_rcif bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=5) ---> pir1+0
;     4b23c8:_pir1_txif bit (type=B dflags=-V-B- sz=1 use=2 assigned=0 bit=4) ---> pir1+0
;     4b2528:_pir1_sspif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pir1+0
;     4b2688:_pir1_ccp1if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pir1+0
;     4b27e8:_pir1_tmr2if bit (type=B dflags=-V-B- sz=1 use=1 assigned=1 bit=1) ---> pir1+0
;     4b2948:_pir1_tmr1if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pir1+0
;     4b2aa8:_pir2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000d)
;     4b2c08:_pir2_osfif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> pir2+0
;     4b2d68:_pir2_c2if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pir2+0
;     4b2ec8:_pir2_c1if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> pir2+0
;     4b3108:_pir2_eeif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pir2+0
;     4b3268:_tmr1 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=000e)
;     4b33c8:_tmr1l byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000e)
;     4b3528:_tmr1h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000f)
;     4b3688:_t1con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0010)
;     4b37e8:_t1con_t1ginv bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> t1con+0
;     4b3948:_t1con_t1ge bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> t1con+0
;     4b3a98:_t1con_t1ckps  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> t1con+0
;     4b3c88:_t1con_t1oscen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> t1con+0
;     4b3de8:_t1con_nt1sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> t1con+0
;     4b3f48:_t1con_tmr1cs bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> t1con+0
;     4b4108:_t1con_tmr1on bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> t1con+0
;     4b4268:_tmr2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0011)
;     4b43c8:_t2con byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0012)
;     4b4518:_t2con_toutps  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=3) ---> t2con+0
;     4b4708:_t2con_tmr2on bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> t2con+0
;     4b4858:_t2con_t2ckps  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=0) ---> t2con+0
;     4b4a48:_sspbuf byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0013)
;     4b4ba8:_sspcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0014)
;     4b4d08:_sspcon_wcol bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspcon+0
;     4b4e68:_sspcon_sspov bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspcon+0
;     4b5108:_sspcon_sspen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspcon+0
;     4b5268:_sspcon_ckp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspcon+0
;     4b53b8:_sspcon_sspm  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> sspcon+0
;     4b55a8:_ccpr word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=0015)
;     4b5708:_ccpr1l byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0015)
;     4b5868:_ccpr1h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0016)
;     4b59c8:_ccp1con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0017)
;     4b5b18:_ccp1con_p1m  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=6) ---> ccp1con+0
;     4b5cf8:_ccp1con_dc1b  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> ccp1con+0
;     4b5ed8:_ccp1con_ccp1m  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> ccp1con+0
;     4b6108:_rcsta byte (type=i dflags=-V--- sz=1 use=3 assigned=5 base=0018)
;     4b6268:_rcsta_spen bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=7) ---> rcsta+0
;     4b63c8:_rcsta_rx9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> rcsta+0
;     4b6528:_rcsta_sren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> rcsta+0
;     4b6688:_rcsta_cren bit (type=B dflags=-V-B- sz=1 use=0 assigned=3 bit=4) ---> rcsta+0
;     4b67e8:_rcsta_adden bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> rcsta+0
;     4b6948:_rcsta_ferr bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=2) ---> rcsta+0
;     4b6aa8:_rcsta_oerr bit (type=B dflags=-V-B- sz=1 use=2 assigned=0 bit=1) ---> rcsta+0
;     4b6c08:_rcsta_rx9d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> rcsta+0
;     4b6d68:_txreg byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0019)
;     4b6ec8:_rcreg byte (type=i dflags=-V--- sz=1 use=4 assigned=0 base=001a)
;     4b7108:_pwm1con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001c)
;     4b7268:_pwm1con_prsen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> pwm1con+0
;     4b73b8:_pwm1con_pdc  (type=i dflags=-V-B- sz=7 use=0 assigned=0 bit=0) ---> pwm1con+0
;     4b75a8:_eccpas byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001d)
;     4b7708:_eccpas_eccpase bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> eccpas+0
;     4b7858:_eccpas_eccpas  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=4) ---> eccpas+0
;     4b7a38:_eccpas_pssac  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=2) ---> eccpas+0
;     4b7c18:_eccpas_pssbd  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=0) ---> eccpas+0
;     4b7e08:_adresh byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001e)
;     4b7f68:_adcon0 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=001f)
;     4b8108:_adcon0_adfm bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> adcon0+0
;     4b8268:_adcon0_vcfg bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> adcon0+0
;     4b83b8:_adcon0_chs  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=2) ---> adcon0+0
;     4b85a8:_adcon0_go bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> adcon0+0
;     4b8708:_adcon0_ndone bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> adcon0+0
;     4b8868:_adcon0_adon bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> adcon0+0
;     4b89c8:_option_reg byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0081)
;     4b8ba8:_option_reg_nrapu bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=7) ---> option_reg+0
;     4b8d28:_option_reg_intedg bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> option_reg+0
;     4b8e98:_option_reg_t0cs bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> option_reg+0
;     4b9108:_t0con_t0cs bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> option_reg+0
;     4b91c8:_option_reg_t0se bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> option_reg+0
;     4b9368:_t0con_t0se bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> option_reg+0
;     4b9428:_option_reg_psa bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> option_reg+0
;     4b95c8:_t0con_psa bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> option_reg+0
;     4b9678:_option_reg_ps  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=0) ---> option_reg+0
;     4b98a8:_t0con_t0ps  (type=i dflags=-V-B- alias sz=3 use=0 assigned=0 bit=0) ---> option_reg+0
;     4b9968:_trisa byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0085)
;     4b9b68:_porta_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisa+0
;     4b9f58:__porta_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b9c78:__porta_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4bca08:__porta_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4bc728:__porta_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4bede8:_trisa_trisa5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4bef88:_pin_a5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4bf1f8:_pin_t1cki_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4bf318:_pin_osc1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4bf438:_pin_clkin_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4bf4f8:_trisa_trisa4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4bf668:_pin_a4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4bf838:_pin_an3_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4bf958:_pin_t1g_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4bfa78:_pin_osc2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4bfb98:_pin_clkout_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4bfc58:_trisa_trisa3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4bfdc8:_pin_a3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4bff98:_pin_mclr_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4bf3a8:_pin_vpp_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4bf7a8:_trisa_trisa2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4bff08:_pin_a2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> trisa+0
;     4bbf28:_pin_an2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4c0108:_pin_t0cki_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4c0228:_pin_c1out_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4c02e8:_trisa_trisa1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4c0458:_pin_a1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4c0628:_pin_an1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4c0748:_pin_c12in0_neg_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4c0868:_pin_icspclk_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4c0928:_trisa_trisa0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4c0a98:_pin_a0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4c0c68:_pin_an0_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4c0d88:_pin_c1in_pos_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4c0ea8:_pin_icspdat_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4c0198:_pin_ulpwu_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4c0598:_trisb byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0086)
;     4c0cf8:_portb_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisb+0
;     4c12b8:__portb_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c06b8:__portb_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c3b98:__portb_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c38b8:__portb_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c5f08:_trisb_trisb7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4c6128:_pin_b7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4c62f8:_pin_tx_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4c6418:_pin_ck_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4c64d8:_trisb_trisb6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4c6648:_pin_b6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4c6818:_pin_sck_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4c6938:_pin_scl_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4c69f8:_trisb_trisb5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4c6b68:_pin_b5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4c6d38:_pin_an11_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4c6e58:_pin_rx_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4c6f78:_pin_dt_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4c6268:_trisb_trisb4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4c6788:_pin_b4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4c6ee8:_pin_an10_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4c7108:_pin_sdi_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4c7228:_pin_sda_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4c72e8:_trisc byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0087)
;     4c74e8:_portc_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisc+0
;     4c78d8:__portc_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c75f8:__portc_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ca2b8:__portc_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c9ec8:__portc_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4cc6d8:_trisc_trisc7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4cc878:_pin_c7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4cca48:_pin_an9_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4ccb68:_pin_sdo_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4ccc28:_trisc_trisc6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4ccd98:_pin_c6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4ccf68:_pin_an8_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4cc9b8:_pin_ss_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4cced8:_trisc_trisc5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4cd108:_pin_c5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> trisc+0
;     4cd2d8:_pin_ccp1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4cd3f8:_pin_p1a_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4cd4b8:_trisc_trisc4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4cd628:_pin_c4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4cd7f8:_pin_c2out_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4cd918:_pin_p1b_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4cd9d8:_trisc_trisc3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4cdb48:_pin_c3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4cdd18:_pin_an7_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4cde38:_pin_c12in3_neg_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4cdf58:_pin_p1c_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4cd248:_trisc_trisc2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4cd768:_pin_c2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4cdec8:_pin_an6_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4cd368:_pin_c12in2_neg_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4ce108:_pin_p1d_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4ce1c8:_trisc_trisc1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4ce338:_pin_c1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4ce508:_pin_an5_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4ce628:_pin_c12in1_neg_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4ce6e8:_trisc_trisc0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4ce858:_pin_c0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4cea28:_pin_an4_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4ceb48:_pin_c2in_pos_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4cec08:_pie1 byte (type=i dflags=-V--- sz=1 use=1 assigned=5 base=008c)
;     4ced68:_pie1_adie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pie1+0
;     4ceec8:_pie1_rcie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> pie1+0
;     4ce478:_pie1_txie bit (type=B dflags=-V-B- sz=1 use=1 assigned=3 bit=4) ---> pie1+0
;     4ce998:_pie1_sspie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pie1+0
;     4ce598:_pie1_ccp1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pie1+0
;     4cf108:_pie1_tmr2ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=1) ---> pie1+0
;     4cf268:_pie1_tmr1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pie1+0
;     4cf3c8:_pie2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008d)
;     4cf528:_pie2_osfie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> pie2+0
;     4cf688:_pie2_c2ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pie2+0
;     4cf7e8:_pie2_c1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> pie2+0
;     4cf948:_pie2_eeie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pie2+0
;     4cfaa8:_pcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008e)
;     4cfc08:_pcon_ulpwue bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> pcon+0
;     4cfd68:_pcon_sboren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pcon+0
;     4cfec8:_pcon_npor bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pcon+0
;     4c6388:_pcon_nbor bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pcon+0
;     4c7198:_osccon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008f)
;     4cbf88:_osccon_ircf  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=4) ---> osccon+0
;     4d0108:_osccon_osts bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> osccon+0
;     4d0268:_osccon_hts bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> osccon+0
;     4d03c8:_osccon_lts bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> osccon+0
;     4d0528:_osccon_scs bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> osccon+0
;     4d0688:_osctune byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0090)
;     4d07d8:_osctune_tun  (type=i dflags=-V-B- sz=5 use=0 assigned=0 bit=0) ---> osctune+0
;     4d09c8:_pr2 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0092)
;     4d0b28:_sspadd byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0093)
;     4d0c88:_sspstat byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0094)
;     4d0de8:_sspstat_smp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspstat+0
;     4d0f48:_sspstat_cke bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspstat+0
;     4d1108:_sspstat_d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspstat+0
;     4d1268:_sspstat_na bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspstat+0
;     4d13c8:_sspstat_p bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspstat+0
;     4d1528:_sspstat_s bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> sspstat+0
;     4d1688:_sspstat_r bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspstat+0
;     4d17e8:_sspstat_nw bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspstat+0
;     4d1948:_sspstat_ua bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> sspstat+0
;     4d1aa8:_sspstat_bf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> sspstat+0
;     4d1c08:_wpua byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0095)
;     4d1d68:_wpua_wpua5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> wpua+0
;     4d1ec8:_wpua_wpua4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> wpua+0
;     4d2108:_wpua_wpua2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> wpua+0
;     4d2268:_wpua_wpua1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> wpua+0
;     4d23c8:_wpua_wpua0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> wpua+0
;     4d2528:_ioca byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0096)
;     4d2688:_ioca_ioca5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> ioca+0
;     4d27e8:_ioca_ioca4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> ioca+0
;     4d2948:_ioca_ioca3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> ioca+0
;     4d2aa8:_ioca_ioca2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> ioca+0
;     4d2c08:_ioca_ioca1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> ioca+0
;     4d2d68:_ioca_ioca0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> ioca+0
;     4d2ec8:_wdtcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0097)
;     4d3108:_wdtcon_wdtps  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=1) ---> wdtcon+0
;     4d32f8:_wdtcon_swdten bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> wdtcon+0
;     4d3458:_txsta byte (type=i dflags=-V--- sz=1 use=0 assigned=3 base=0098)
;     4d35b8:_txsta_csrc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> txsta+0
;     4d3718:_txsta_tx9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> txsta+0
;     4d3878:_txsta_txen bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> txsta+0
;     4d39d8:_txsta_sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> txsta+0
;     4d3b38:_txsta_sendb bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> txsta+0
;     4d3c98:_txsta_brgh bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> txsta+0
;     4d3df8:_txsta_trmt bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> txsta+0
;     4d3f58:_txsta_txgd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> txsta+0
;     4d4108:_spbrg byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0099)
;     4d4268:_spbrgh byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=009a)
;     4d43c8:_baudctl byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=009b)
;     4d4528:_baudctl_abdovf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> baudctl+0
;     4d4688:_baudctl_rcidl bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> baudctl+0
;     4d47e8:_baudctl_sckp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> baudctl+0
;     4d4948:_baudctl_brg16 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=3) ---> baudctl+0
;     4d4aa8:_baudctl_wue bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> baudctl+0
;     4d4c08:_baudctl_abden bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> baudctl+0
;     4d4d68:_adresl byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=009e)
;     4d4ec8:_adcon1 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=009f)
;     4d5108:_adcon1_adcs  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=4) ---> adcon1+0
;     4d52f8:_eedat byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010c)
;     4d5458:_eeadr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010d)
;     4d55b8:_eedath byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010e)
;     4d5708:_eedath_eedath  (type=i dflags=-V-B- sz=6 use=0 assigned=0 bit=0) ---> eedath+0
;     4d58f8:_eeadrh byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010f)
;     4d5a48:_eeadrh_eeadrh  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> eeadrh+0
;     4d5c38:_wpub byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0115)
;     4d5d88:_wpub_wpub  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=4) ---> wpub+0
;     4d5f78:_iocb byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0116)
;     4d6108:_iocb_iocb7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> iocb+0
;     4d6268:_iocb_iocb6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> iocb+0
;     4d63c8:_iocb_iocb5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> iocb+0
;     4d6528:_iocb_iocb4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> iocb+0
;     4d6688:_vrcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0118)
;     4d67e8:_vrcon_c1vren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> vrcon+0
;     4d6948:_vrcon_c2vren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> vrcon+0
;     4d6aa8:_vrcon_vrr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> vrcon+0
;     4d6c08:_vrcon_vp6en bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> vrcon+0
;     4d6d58:_vrcon_vr  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> vrcon+0
;     4d6f48:_cm1con0 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0119)
;     4d7108:_cm1con0_c1on bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> cm1con0+0
;     4d7268:_cm1con0_c1out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> cm1con0+0
;     4d73c8:_cm1con0_c1oe bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> cm1con0+0
;     4d7528:_cm1con0_c1pol bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> cm1con0+0
;     4d7688:_cm1con0_c1sp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> cm1con0+0
;     4d77e8:_cm1con0_c1r bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> cm1con0+0
;     4d7938:_cm1con0_c1ch  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=0) ---> cm1con0+0
;     4d7b28:_cm2con0 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=011a)
;     4d7c88:_cm2con0_c2on bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> cm2con0+0
;     4d7de8:_cm2con0_c2out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> cm2con0+0
;     4d7f48:_cm2con0_c2oe bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> cm2con0+0
;     4d8108:_cm2con0_c2pol bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> cm2con0+0
;     4d8268:_cm2con0_c2sp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> cm2con0+0
;     4d83c8:_cm2con0_c2r bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> cm2con0+0
;     4d8518:_cm2con0_c2ch  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=0) ---> cm2con0+0
;     4d8708:_cm2con1 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=011b)
;     4d8868:_cm2con1_mc1out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> cm2con1+0
;     4d89c8:_cm2con1_mc2out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> cm2con1+0
;     4d8b28:_cm2con1_t1gss bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> cm2con1+0
;     4d8c88:_cm2con1_c2sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> cm2con1+0
;     4d8de8:_ansel byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=011e)
;     4d8f48:_jansel_ans7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> ansel+0
;     4d9108:_jansel_ans6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> ansel+0
;     4d9268:_jansel_ans5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> ansel+0
;     4d93c8:_jansel_ans4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> ansel+0
;     4d9528:_jansel_ans3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> ansel+0
;     4d9688:_jansel_ans2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> ansel+0
;     4d97e8:_jansel_ans1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> ansel+0
;     4d9948:_jansel_ans0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> ansel+0
;     4d9aa8:_anselh byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=011f)
;     4d9c08:_jansel_ans11 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> anselh+0
;     4d9d68:_jansel_ans10 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> anselh+0
;     4d9ec8:_jansel_ans9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> anselh+0
;     4da108:_jansel_ans8 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> anselh+0
;     4da268:_eecon1 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=018c)
;     4da3c8:_eecon1_eepgd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> eecon1+0
;     4da528:_eecon1_wrerr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> eecon1+0
;     4da688:_eecon1_wren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> eecon1+0
;     4da7e8:_eecon1_wr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> eecon1+0
;     4da948:_eecon1_rd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> eecon1+0
;     4daaa8:_eecon2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=018d)
;     4dac08:_pstrcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=019d)
;     4dad68:_pstrcon_strsync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pstrcon+0
;     4daec8:_pstrcon_strd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pstrcon+0
;     4db108:_pstrcon_strc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pstrcon+0
;     4db268:_pstrcon_strb bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pstrcon+0
;     4db3c8:_pstrcon_stra bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pstrcon+0
;     4db528:_srcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=019e)
;     4db678:_srcon_sr  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=6) ---> srcon+0
;     4db868:_srcon_c1sen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> srcon+0
;     4db9c8:_srcon_c2ren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> srcon+0
;     4dbb28:_srcon_pulss bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> srcon+0
;     4dbc88:_srcon_pulsr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> srcon+0
;     4dbe18:_adc_group  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44480
;     4dc108:_adc_ntotal_channel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 12
;     4dbef8:_analog_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4dd388:_adc_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4de398:_comparator_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4df3a8:_enable_digital_io_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4e1248:_target_clock  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 10000000
;     4e0698:_led1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     4e27d8:_dummy bit (type=B dflags=---B- sz=1 use=2 assigned=4 bit=0) ---> _bitbucket+0
;     4e3108:_serial_ctsinv bit (type=B dflags=---B- alias sz=1 use=0 assigned=0 bit=0) ---> _bitbucket+0
;     4e3248:_serial_overflow_discard bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     4e3408:_serial_xmtbufsize  (type=i dflags=C---U sz=4 use=2 assigned=0)
;      = 80
;     4e3568:_serial_rcvbufsize  (type=i dflags=C---U sz=4 use=4 assigned=0)
;      = 12
;     4e36c8:_serial_hw_baudrate  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 4800
;     4e3328:_serial_delta  (type=i dflags=C---U sz=4 use=2 assigned=0)
;      = 17
;     4e3a98:_usart_hw_serial bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     4e43c8:__calculate_and_set_baudrate_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4e5bc8:__serial_xmtbuf  (type=a dflags=----- auto sz=80 use=2 assigned=2 base=00a0)
;     4e5de8:__serial_rcvbuf  (type=a dflags=----- auto sz=12 use=2 assigned=2 base=0042)
;     4e7bd8:__serial_offsetxmthead byte (type=i dflags=----- auto sz=1 use=5 assigned=3 base=004e)
;     4e7cb8:__serial_offsetxmttail byte (type=i dflags=----- auto sz=1 use=8 assigned=3 base=004f)
;     4e7d98:__serial_offsetrcvhead byte (type=i dflags=----- auto sz=1 use=9 assigned=3 base=0050)
;     4e7e78:__serial_offsetrcvtail byte (type=i dflags=----- auto sz=1 use=11 assigned=4 base=0051)
;     4e7f58:_serial_send_success bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=1) ---> _bitbucket+0
;     4e82b8:__serial_transmit_interrupt_handler_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4ed2b8:__serial_receive_interrupt_handler_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4f65f8:_serial_hw_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     4fbce8:_serial_receive_byte_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     4fccf8:_serial_send_byte_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     4f62f8:_serial_hw_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     505e88:_serial_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5068d8:__serial_hw_data_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     508628:_serial_hw_write_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5065f8:__serial_hw_data_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     50ba38:_print_string_terminator byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     50c338:_ascii_null byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     50c4a8:_ascii_soh byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     50c618:_ascii_stx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 2
;     50c788:_ascii_etx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     50c8f8:_ascii_eot byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     50ca68:_ascii_enq byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     50cbd8:_ascii_ack byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     50cd48:_ascii_bel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 7
;     50ceb8:_ascii_bs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 8
;     50d108:_ascii_ht byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 9
;     50d278:_ascii_lf byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 10
;     50d3e8:_ascii_vt byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 11
;     50d558:_ascii_ff byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 12
;     50d6c8:_ascii_cr byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 13
;     50d838:_ascii_so byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 14
;     50d9a8:_ascii_si byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 15
;     50db18:_ascii_dle byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 16
;     50dc88:_ascii_dc1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 17
;     50ddf8:_ascii_dc2 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 18
;     50df68:_ascii_dc3 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 19
;     50e108:_ascii_dc4 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 20
;     50e278:_ascii_nak byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 21
;     50e3e8:_ascii_syn byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 22
;     50e558:_ascii_etb byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 23
;     50e6c8:_ascii_can byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 24
;     50e838:_ascii_em byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 25
;     50e9a8:_ascii_sub byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 26
;     50eb18:_ascii_esc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 27
;     50ec88:_ascii_fs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 28
;     50edf8:_ascii_gs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 29
;     50ef68:_ascii_rs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 30
;     50f108:_ascii_us byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 31
;     50f278:_ascii_sp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 32
;     50f3e8:_ascii_del byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 127
;     50f788:_toupper_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     511eb8:_tolower_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     515108:__print_universal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     5156f8:__print_suniversal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     514c08:_print_byte_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     516bb8:_nibble2hex  (type=a dflags=C---- sz=16 use=22 assigned=0)
;      = 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70
;     50bbc8:_print_prefix  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     514d18:_print_crlf_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     516108:_print_string_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     516a68:_print_bit_truefalse_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     51aae8:_print_bit_highlow_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     51c728:_print_bit_10_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     51f428:_print_dword_binary_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     521a18:_print_word_binary_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     527b48:_print_nibble_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     52b618:_print_dword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     531a28:_print_sdword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     537e38:_print_word_hex_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     53bae8:_print_byte_hex_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     53e3c8:_print_sdword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     53f258:_print_sword_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     4f7948:_print_sword_fp_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     541938:_print_sbyte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5428d8:_print_dword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5438d8:_print_word_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5448d8:_print_byte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     514af8:_delay_1us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     515ed8:_delay_2us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     545738:_delay_3us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     545828:_delay_4us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     54f958:_delay_5us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     50ffa8:_delay_6us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     550628:_delay_7us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     550dc8:_delay_8us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     551698:_delay_9us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     551e38:_instruction_time  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 40
;     552918:_delay_10us_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5558c8:_delay_1ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     55a1f8:_delay_100ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     55c108:_delay_1s_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     55df18:_in_buf_size byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 20
;     5524c8:_gpsinbuffer  (type=a dflags=----- auto sz=20 use=3 assigned=3 base=0052)
;     55e108:_gpsinbufferindex byte (type=i dflags=----- auto sz=1 use=4 assigned=3 base=0066)
;     55e1c8:_gpsmsgnr  (type=i dflags=C---- sz=1 use=0 assigned=1)
;      = 0
;     55e288:_gpsfieldnr byte (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0067)
;     55e418:_gpserrorcode byte (type=i dflags=----- auto sz=1 use=3 assigned=4 base=0068)
;     55ee08:_str_inbuffer  (type=a dflags=C---- sz=6 use=0 assigned=0)
;      = 73,110,66,117,102,32
;     55e808:_dumpgpsinbuffer_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5622b8:_storebytes_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     565b68:_ismsg_1  (type=F dflags=----- sz=5 use=0 assigned=0 base=0000)
;     568578:_str_gpgga  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,71,71,65
;     5688a8:_str_gpgll  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,71,76,76
;     568bd8:_str_gpgsa  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,71,83,65
;     568f08:_str_gpgsv  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,71,83,86
;     569108:_str_gprmc  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,82,77,67
;     569438:_str_gpvtg  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,86,84,71
;     561f58:_parsemessageid_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     56e1b8:_str_msg  (type=a dflags=C---- lookup sz=4 use=1 assigned=0)
;      = 77,115,103,32
;     56e668:_str_error  (type=a dflags=C---- lookup sz=6 use=1 assigned=0)
;      = 69,114,114,111,114,32
;     56dd68:_verbose  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     56de58:_gpstakt_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     57b788:_ticks word (type=i dflags=-V--- auto sticky sz=2 use=4 assigned=6 base=0037)
;     57bb88:_tickslowbyte byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> ticks+0
;     57c5f8:_str1_2  (type=a dflags=C---- lookup sz=10 use=1 assigned=0)
;      = 86,99,120,111,32,86,48,46,49,10
;     57be58:_setdutycycle_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     57bd68:_isr_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5817e8:__floop7  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0069)
;     581f68:__btemp_26  (type=i dflags=---B- sz=2 use=0 assigned=0 bit=2) ---> _bitbucket+0
;     583418:__btemp81  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _bitbucket+0
;     583b58:_ch  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     572558:__bitbucket  (type=i dflags=----- auto sz=2 use=6 assigned=12 base=006a)
;     52d548:__pic_isr_fsr  (type=i dflags=----- sz=1 use=1 assigned=1 base=0036)
;     52c488:__pic_isr_status  (type=i dflags=----- sz=1 use=1 assigned=1 base=0030)
;     52c7f8:__pic_isr_pclath  (type=i dflags=----- sz=1 use=1 assigned=1 base=0031)
;     528848:__pic_temp  (type=i dflags=----- sz=2 use=21 assigned=27) ---> _pic_state+0
;     51fc98:__pic_pointer  (type=i dflags=----- sz=2 use=5 assigned=13 base=0034)
;     511108:__pic_loop  (type=i dflags=----- sz=1 use=1 assigned=2 base=0032)
;     510c78:__pic_divisor  (type=i dflags=----- sz=4 use=20 assigned=16) ---> _pic_state+8
;     510a68:__pic_dividend  (type=i dflags=----- sz=4 use=9 assigned=16) ---> _pic_state+0
;     4e6618:__pic_quotient  (type=i dflags=----- sz=4 use=17 assigned=13) ---> _pic_state+12
;     50fab8:__pic_remainder  (type=i dflags=----- sz=4 use=20 assigned=16) ---> _pic_state+4
;     4cbe48:__pic_divaccum  (type=i dflags=----- sz=8 use=8 assigned=8) ---> _pic_state+0
;     611aa8:__pic_sign  (type=i dflags=----- sz=1 use=2 assigned=3 base=0033)
;     611c18:__pic_state  (type=i dflags=----- sz=16 use=95 assigned=96 base=0020)
;     --- labels ---
;     _isr_cleanup (pc(0000) usage=0)
;     _isr_preamble (pc(0000) usage=0)
;     _main (pc(00c1) usage=7)
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
;     analog_off (pc(0000) usage=0)
;     adc_off (pc(0000) usage=0)
;     comparator_off (pc(0000) usage=0)
;     enable_digital_io (pc(0000) usage=0)
;     _calculate_and_set_baudrate (pc(00d7) usage=5)
;     _serial_transmit_interrupt_handler (pc(00de) usage=31)
;     _serial_receive_interrupt_handler (pc(0113) usage=25)
;     serial_hw_read (pc(0161) usage=5)
;     serial_receive_byte (pc(0000) usage=0)
;     serial_send_byte (pc(019a) usage=5)
;     serial_hw_init (pc(01d1) usage=5)
;     serial_init (pc(0000) usage=0)
;     _serial_hw_data_put (pc(01e5) usage=49)
;     serial_hw_write (pc(0000) usage=0)
;     _serial_hw_data_get (pc(0000) usage=0)
;     toupper (pc(0000) usage=0)
;     tolower (pc(0000) usage=0)
;     _print_universal_dec (pc(024e) usage=5)
;     _print_suniversal_dec (pc(0000) usage=0)
;     print_byte_binary (pc(0000) usage=0)
;     print_crlf (pc(01f4) usage=10)
;     print_string (pc(0202) usage=15)
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
;     print_byte_dec (pc(0238) usage=10)
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
;     delay_1ms (pc(02f5) usage=5)
;     delay_100ms (pc(0000) usage=0)
;     delay_1s (pc(0000) usage=0)
;     dumpgpsinbuffer (pc(0000) usage=0)
;     storebytes (pc(031c) usage=5)
;     ismsg (pc(033a) usage=30)
;     parsemessageid (pc(0360) usage=5)
;     gpstakt (pc(0000) usage=0)
;     setdutycycle (pc(03db) usage=5)
;     isr (pc(0404) usage=5)
;     _pic_indirect (pc(00bd) usage=28)
;     _pic_divide (pc(006b) usage=4)
;     _pic_sdivide (pc(004a) usage=4)
;     _data_str_gpgga (pc(0028) usage=4)
;     _data_str_gpgll (pc(003a) usage=4)
;     _data_str_gpgsa (pc(0034) usage=4)
;     _data_str_gpgsv (pc(0022) usage=4)
;     _data_str_gprmc (pc(0040) usage=4)
;     _data_str_gpvtg (pc(002e) usage=4)
;     _data_str1_2 (pc(0010) usage=4)
;     _data_str_error (pc(001b) usage=4)
;     _data_str_msg (pc(0046) usage=4)
;     _pic_reset (pc(0000) usage=0)
;     _pic_isr (pc(0004) usage=0)
;     _pic_lookup (pc(0000) usage=0)
;     _lookup_str1_2 (pc(000f) usage=0)
;     _lookup_str_error (pc(001a) usage=0)
;     _lookup_str_gpgsv (pc(0021) usage=0)
;     _lookup_str_gpgga (pc(0027) usage=0)
;     _lookup_str_gpvtg (pc(002d) usage=0)
;     _lookup_str_gpgsa (pc(0033) usage=0)
;     _lookup_str_gpgll (pc(0039) usage=0)
;     _lookup_str_gprmc (pc(003f) usage=0)
;     _lookup_str_msg (pc(0045) usage=0)
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
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;       {block exit}
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       582108:__btemp80  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> _bitbucket+0
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         582538:_x_69 bit (type=B dflags=---B- sz=1 use=0 assigned=2 bit=2) ---> _porta_shadow+0
;         --- labels ---
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;         {block exit}
;       {block exit}
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         583f88:_char_7 byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=006c)
;         584108:__btemp_27  (type=i dflags=---B- sz=10 use=0 assigned=0 bit=4) ---> _bitbucket+0
;         584198:__btemp68_1  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> _bitbucket+0
;         584228:__btemp69_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _bitbucket+0
;         5842b8:__btemp70_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _bitbucket+0
;         584348:__btemp71_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _bitbucket+0
;         5843d8:__btemp72_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=8) ---> _bitbucket+0
;         584468:__btemp73_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=9) ---> _bitbucket+0
;         5844f8:__btemp74_1  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=10) ---> _bitbucket+0
;         584588:__temp_49  (type=? dflags=C---- sz=0 use=0 assigned=0)
;          = 0
;         --- labels ---
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           586c48:__btemp75_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=11) ---> _bitbucket+0
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             586e68:__btemp76_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=12) ---> _bitbucket+0
;             586ef8:__btemp77_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=13) ---> _bitbucket+0
;             --- labels ---
;             {block enter}
;               --- records ---
;               --- variables ---
;               --- labels ---
;             {block exit}
;             {block enter}
;               --- records ---
;               --- variables ---
;               --- labels ---
;             {block exit}
;           {block exit}
;         {block exit}
;       {block exit}
;     {block exit}
;   {block exit}
;      isr ----- --I (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57fc98:__temp_48  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        580598:__btemp_25  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        577298:__bitbucket_1  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          580668:__btemp79  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      setdutycycle --D-- -U- (frame_sz=2 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57bf48:_duty_1 word (type=i dflags=----- auto sz=2 use=5 assigned=4 base=006d)
;        57c108:__btemp_24  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        57c1f8:__btemp78  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        57e108:__temp_47  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        576418:__bitbucket_2  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      gpstakt ----L --- (frame_sz=0 blocks=10)
;      {block enter}
;        --- records ---
;        --- variables ---
;        56df48:_char_6  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56e428:__btemp_23  (type=i dflags=C--B- sz=10 use=0 assigned=0 bit=0)
;         = 0
;        56e518:__btemp68  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        56f238:__btemp69  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        56fc18:__btemp70  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5707f8:__btemp71  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;        571db8:__btemp72  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;        573e68:__btemp73  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;        5748e8:__btemp74  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
;        575718:__temp_46  (type=? dflags=C---- sz=0 use=2 assigned=0)
;         = 0
;        561908:__bitbucket_3  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          574e58:__btemp75  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=7)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            576538:__btemp76  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=8)
;            5773b8:__btemp77  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=9)
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;          {block exit}
;        {block exit}
;      {block exit}
;      parsemessageid --D-- -U- (frame_sz=1 blocks=7)
;      {block enter}
;        --- records ---
;        --- variables ---
;        568158:__btemp_22  (type=i dflags=---B- sz=6 use=0 assigned=0 bit=0) ---> ___bitbucket4+0
;        568248:__btemp62  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket4+0
;        56a3d8:__btemp63  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=1) ---> ___bitbucket4+0
;        56add8:__btemp64  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> ___bitbucket4+0
;        56b8b8:__btemp65  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket4+0
;        56c3d8:__btemp66  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> ___bitbucket4+0
;        56cdd8:__btemp67  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=5) ---> ___bitbucket4+0
;        560d98:__bitbucket_4  (type=i dflags=----- auto sz=1 use=6 assigned=12 base=006d)
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
;      ismsg --D-- -U- (frame_sz=3 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        565da8:__name_count  (type=i dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        565e68:_name_1  (type=* dflags=----- auto ptr_lookup sz=2 use=2 assigned=12 base=0120)
;        565f38:_i_2 byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=0124)
;        566a08:__btemp_21  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        5676c8:__btemp61  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5608b8:__bitbucket_5  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          566ad8:__btemp60  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      storebytes --D-- -U- (frame_sz=1 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5624a8:_char_5 byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=006d)
;        562748:__btemp_20  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        562818:__btemp58  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5634b8:__btemp59  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        564978:__temp_45  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5603d8:__bitbucket_6  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      dumpgpsinbuffer ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        55e8f8:_i_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55ecb8:__btemp_19  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        55fd68:__btemp57  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        560e98:__temp_44  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        55ead8:__bitbucket_7  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        55c2f8:_n_7  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55c898:__1_s_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 999995
;        55c4e8:__floop6  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55c6c8:__btemp_18  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        55d598:__btemp56  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        55e9e8:__bitbucket_8  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        55a3e8:_n_5  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55a928:__100_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 99995
;        55a578:__floop5  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55a758:__btemp_17  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        55b648:__btemp55  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        55c3e8:__bitbucket_9  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5581f8:_n_3 word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=006d)
;        558738:__one_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 995
;        558388:__floop4  (type=i dflags=----- auto sz=2 use=4 assigned=4 base=0122)
;        559108:__btemp_16  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        558568:__btemp54  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        55a4a8:__bitbucket_10  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        552b08:_n_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        552d18:__btemp_15  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        552de8:__btemp51  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        553968:__btemp52  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        553f68:__temp_43  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        555618:__bitbucket_11  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          554418:__ten_us_delay1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 4
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          555a98:__ten_us_delay2  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 4294967295
;          556478:__ten_us_delay3  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 8
;          5556e8:__floop3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          556e08:__btemp53  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
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
;        553e68:__bitbucket_12  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_8us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        553848:__bitbucket_13  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_7us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        546e68:__bitbucket_14  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_6us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        545e38:__bitbucket_15  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_5us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        543eb8:__bitbucket_16  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_4us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        543db8:__bitbucket_17  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_3us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        542eb8:__bitbucket_18  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_2us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        542db8:__bitbucket_19  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_1us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        541f18:__bitbucket_20  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_dec --D-- -U- (frame_sz=3 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        544ac8:__device_put_19  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=4 base=006d)
;        544b88:_data_49 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0122)
;        541e18:__bitbucket_21  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_word_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        543ac8:__device_put_18  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        543b88:_data_47  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        541108:__bitbucket_22  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_dword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        542ac8:__device_put_17  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        542b88:_data_45  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        540ee8:__bitbucket_23  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sbyte_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        541b28:__device_put_16  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        541be8:_data_43  (type=i dflags=C-S-- sz=1 use=0 assigned=0)
;         = 0
;        540c78:__bitbucket_24  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_fp_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ff898:__device_put_15  (type=* dflags=C---- sz=2 use=0 assigned=1)
;         = 0
;        503f68:_data_41  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        504ca8:__temp_40  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        540b18:__bitbucket_25  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53f448:__device_put_14  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53f508:_data_39  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        5407d8:__bitbucket_26  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sdword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53e5b8:__device_put_13  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53e648:_data_37  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        540538:__bitbucket_27  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_hex --D-- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53bcd8:__device_put_12  (type=* dflags=C---- sz=2 use=0 assigned=4)
;         = 0
;        53bd68:_data_35  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53cb78:__temp_39  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        540438:__bitbucket_28  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        538188:__device_put_11  (type=* dflags=C---- sz=2 use=0 assigned=6)
;         = 0
;        538218:_data_33  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        538f48:__temp_38  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        508cf8:__bitbucket_29  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        531c18:__device_put_10  (type=* dflags=C---- sz=2 use=0 assigned=10)
;         = 0
;        531ca8:_data_31  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        532aa8:__temp_37  (type=i dflags=C---- sz=8 use=0 assigned=0)
;         = 0
;        504378:__bitbucket_30  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52b808:__device_put_9  (type=* dflags=C---- sz=2 use=0 assigned=10)
;         = 0
;        52b8c8:_data_29  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        52c718:__temp_36  (type=i dflags=C---- sz=8 use=0 assigned=0)
;         = 0
;        53f838:__bitbucket_31  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        527d38:__device_put_8  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        527df8:_data_27  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        528108:__floop2  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        528978:__temp_35  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        529108:__btemp_12  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        52a9d8:__btemp44  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        53f738:__bitbucket_32  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5291d8:__btemp43  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;        521c08:__device_put_6  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        521cc8:_data_23  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5229c8:__temp_33  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53e978:__bitbucket_33  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        51f618:__device_put_5  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        51f6d8:_data_21  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        4eef48:__temp_32  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53e878:__bitbucket_34  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        51e108:__device_put_4  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        51e1c8:_data_19  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        53d948:__bitbucket_35  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        51abd8:__device_put_3  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        51af98:_data_17  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        51c948:_str1_1  (type=a dflags=C---- sz=4 use=0 assigned=0)
;         = 104,105,103,104
;        51c818:_str0_1  (type=a dflags=C---- sz=3 use=0 assigned=0)
;         = 108,111,119
;        53d778:__bitbucket_36  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        51a748:__device_put_2  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        51a808:_data_15  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        51ad28:_str1  (type=a dflags=C---- sz=4 use=0 assigned=0)
;         = 116,114,117,101
;        51b108:_str0  (type=a dflags=C---- sz=5 use=0 assigned=0)
;         = 102,97,108,115,101
;        53d268:__bitbucket_37  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      print_string --D-- -U- (frame_sz=9 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5161f8:__device_put_1  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=6 base=006d)
;        5162e8:__str_count  (type=i dflags=----- auto sz=2 use=2 assigned=6 base=0122)
;        5163d8:_str_1  (type=* dflags=----- auto ptr_lookup sz=2 use=4 assigned=6 base=0126)
;        5164c8:_len word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=012c)
;        5165b8:_i byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=006f)
;        516798:__btemp_10  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        516978:__btemp40  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        53c8e8:__bitbucket_38  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          516888:__btemp39  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;        515de8:__device_put  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=4 base=006d)
;        53cc58:__bitbucket_39  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_binary --D-- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        523998:__device_put_7  (type=* dflags=C---- sz=2 use=0 assigned=4)
;         = 0
;        523a58:_data_25  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        524658:__floop1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        524ec8:__temp_34  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5255d8:__btemp_11  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        526ef8:__btemp42  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        53ca48:__bitbucket_40  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          5256a8:__btemp41  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;        545a58:__device_put_20  (type=* dflags=C---- sz=2 use=0 assigned=1)
;         = 0
;        545b18:_data_51  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        545bd8:_digit_divisor_3  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        545c98:_digit_number_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        545f38:__btemp_13  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        546108:__btemp45  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        546828:__temp_41  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        53c408:__bitbucket_41  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        547ea8:__device_put_21  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=2 base=0124)
;        547f68:_data_53 dword (type=i dflags=----- auto sz=4 use=8 assigned=8 base=0128)
;        5474f8:_digit_divisor_5 sdword (type=i dflags=--S-- auto sz=4 use=12 assigned=8 base=012e)
;        548108:_digit_number_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0132)
;        5481f8:_digit byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=0133)
;        5482d8:_no_digits_printed_yet bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket42+0
;        548548:__btemp_14  (type=i dflags=---B- sz=5 use=0 assigned=0 bit=1) ---> ___bitbucket42+0
;        548618:__btemp46  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> ___bitbucket42+0
;        549898:__btemp47  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> ___bitbucket42+0
;        54a108:__temp_42  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0134)
;        53c1d8:__bitbucket_42  (type=i dflags=----- auto sz=1 use=4 assigned=8 base=0135)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          54b5b8:__btemp48  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket42+0
;          54bb38:__btemp49  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> ___bitbucket42+0
;          54bef8:__btemp50  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=5) ---> ___bitbucket42+0
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
;        5121f8:_char_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        512468:__btemp_9  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        512538:__btemp36  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        512b38:__btemp37  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        512ef8:__btemp38  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        513848:__temp_31  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53b108:__bitbucket_43  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        50f978:_char_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        50fb88:__btemp_8  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        50fc58:__btemp33  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        4e68d8:__btemp34  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        510378:__btemp35  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        510b98:__temp_30  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53ae88:__bitbucket_44  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _serial_hw_data_get ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        50a3f8:_data_10  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        50a6c8:__btemp_7  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        50a798:__btemp31  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        50aa48:__btemp32  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        53aa78:__bitbucket_45  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      serial_hw_write ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        508818:_data_9  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5088b8:_dummy_2  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        508dc8:__btemp_6  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        508e98:__btemp30  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5094b8:__temp_29  (type=? dflags=C---- sz=0 use=1 assigned=0)
;         = 0
;        53a518:__bitbucket_46  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _serial_hw_data_put --DI- FU- (frame_sz=1 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        506ac8:_data_7 byte (type=i dflags=----- auto sticky sz=1 use=1 assigned=1 base=003d)
;        506b98:_dummy_1  (type=i dflags=C---- sz=1 use=0 assigned=1)
;         = 0
;        507108:__btemp_5  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5071d8:__btemp29  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5077d8:__temp_28  (type=? dflags=C---- sz=0 use=1 assigned=0)
;         = 0
;        53a7d8:__bitbucket_47  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      serial_init ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53a678:__bitbucket_48  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_init --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53a108:__bitbucket_49  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_send_byte V-D-- -U- (frame_sz=3 blocks=7)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4fcee8:_data_5 byte (type=i dflags=----- auto sticky sz=1 use=3 assigned=1 base=003e)
;        4fd108:_newxmthead byte (type=i dflags=----- auto sticky sz=1 use=5 assigned=2 base=003f)
;        4fd608:__btemp_4  (type=i dflags=---B- sz=6 use=0 assigned=0 bit=0) ---> ___bitbucket50+0
;        4fd6d8:__btemp23  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket50+0
;        4fda28:__btemp24  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=1) ---> ___bitbucket50+0
;        4fdcd8:__btemp25  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> ___bitbucket50+0
;        4ff108:__temp_27  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        539ab8:__bitbucket_50  (type=i dflags=----- auto sticky sz=1 use=3 assigned=6 base=0040)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          4ff978:__btemp26  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> ___bitbucket50+0
;          500628:__btemp27  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> ___bitbucket50+0
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
;            501108:__btemp28  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> ___bitbucket50+0
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;          {block exit}
;        {block exit}
;      {block exit}
;      serial_receive_byte ----L --- (frame_sz=1 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4fbf08:_data_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4fc2e8:__btemp_3  (type=i dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> ___bitbucket51
;        4fc3b8:__btemp22  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> ___bitbucket51
;        539d78:__bitbucket_51  (type=i dflags=----- auto sz=1 use=0 assigned=0 base=ffff)
;        --- labels ---
;      {block exit}
;      serial_hw_read --D-- -U- (frame_sz=3 blocks=7)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f67e8:_data_1 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=006d)
;        4f68b8:_x_68 byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0120)
;        4f6ac8:__btemp_2  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;         = 0
;        4f6b98:__btemp17  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        4f7b68:__temp_26  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0122)
;        4f83e8:__btemp18  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        4f8f08:__btemp19  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        539c18:__bitbucket_52  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          4f9538:__btemp20  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          4faa18:__btemp21  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;      _serial_receive_interrupt_handler ----- --I (frame_sz=0 blocks=11)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ed4b8:_x_67 byte (type=i dflags=----- sticky sz=1 use=4 assigned=7 base=0039)
;        4ed658:__btemp_1  (type=i dflags=---B- sz=10 use=0 assigned=0 bit=0) ---> ___bitbucket53+0
;        4ed728:__btemp7  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> ___bitbucket53+0
;        4f0d08:__temp_25  (type=i dflags=----- sticky sz=1 use=2 assigned=2 base=003a)
;        5395a8:__bitbucket_53  (type=i dflags=----- sticky sz=2 use=3 assigned=6 base=003b)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          4edd88:__btemp8  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=1) ---> ___bitbucket53+0
;          4ee338:__btemp9  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> ___bitbucket53+0
;          4ee6f8:__btemp10  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket53+0
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            4ef4f8:__btemp11  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> ___bitbucket53+0
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            4f1c98:__btemp12  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> ___bitbucket53+0
;            4f2a98:__btemp13  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> ___bitbucket53+0
;            4f3568:__btemp14  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> ___bitbucket53+0
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              4f3be8:__btemp15  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=8) ---> ___bitbucket53+0
;              4f4e28:__btemp16  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=9) ---> ___bitbucket53+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;        {block exit}
;      {block exit}
;      _serial_transmit_interrupt_handler ----- --I (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e84b8:_x_66 byte (type=i dflags=----- sticky sz=1 use=1 assigned=1 base=0039)
;        4e8648:__btemp  (type=i dflags=---B- sz=6 use=0 assigned=0 bit=0) ---> ___bitbucket54+0
;        4e8718:__btemp1  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket54+0
;        4e8b48:__btemp2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=1) ---> ___bitbucket54+0
;        4e8f08:__btemp3  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> ___bitbucket54+0
;        4ea598:__temp_24  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        538cb8:__bitbucket_54  (type=i dflags=----- sticky sz=1 use=3 assigned=6 base=003a)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          4e97a8:__btemp4  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> ___bitbucket54+0
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            4eae08:__btemp5  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> ___bitbucket54+0
;            4ebc08:__btemp6  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> ___bitbucket54+0
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;          {block exit}
;        {block exit}
;      {block exit}
;      _calculate_and_set_baudrate --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e4778:_max_deviation  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 5
;        4e4f98:_usart_div  (type=i dflags=C---U sz=4 use=1 assigned=0)
;         = 520
;        4e6168:_real_baud  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 4798
;        539108:__bitbucket_55  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      enable_digital_io ----L --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        538e18:__bitbucket_56  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      comparator_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5387d8:__bitbucket_57  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5385a8:__bitbucket_58  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      analog_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        537458:__bitbucket_59  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cbd68:__temp_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        537288:__bitbucket_60  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ca4a8:_x_65  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4ca7b8:__temp_22  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        536d18:__bitbucket_61  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c9688:__temp_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5367b8:__bitbucket_62  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c7ac8:_x_63  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4c7da8:__temp_20  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        536a78:__bitbucket_63  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c5718:__temp_19  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        536918:__bitbucket_64  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c3d88:_x_61  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4c4158:__temp_18  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5363a8:__bitbucket_65  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c2f68:__temp_17  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        535d48:__bitbucket_66  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c14a8:_x_59  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4c1788:__temp_16  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        536108:__bitbucket_67  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4be5f8:__temp_15  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        535ea8:__bitbucket_68  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4bcbf8:_x_57  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4bcf08:__temp_14  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        535938:__bitbucket_69  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4bbd08:__temp_13  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5353d8:__bitbucket_70  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ba268:_x_55  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4ba548:__temp_12  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        535698:__bitbucket_71  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_c0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b0268:_x_53 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portc_shadow
;        535538:__bitbucket_72  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4af3e8:_x_51 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _portc_shadow
;        534e78:__bitbucket_73  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4ae3a8:_x_49 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _portc_shadow
;        534918:__bitbucket_74  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4ad1f8:_x_47 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _portc_shadow
;        534bd8:__bitbucket_75  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4abf38:_x_45 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portc_shadow
;        534a78:__bitbucket_76  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4aacf8:_x_43 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portc_shadow
;        534508:__bitbucket_77  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a9b38:_x_41 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portc_shadow
;        533f88:__bitbucket_78  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a8998:_x_39 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portc_shadow
;        534268:__bitbucket_79  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a7708:__temp_11  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        534108:__bitbucket_80  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a58f8:_x_37  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4a5c38:__temp_10  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        533b78:__bitbucket_81  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a4b08:__temp_9  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        533618:__bitbucket_82  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a2e98:_x_35  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4a3108:__temp_8  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5338d8:__bitbucket_83  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a1f18:_x_33  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        533778:__bitbucket_84  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533108:__bitbucket_85  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_b4_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a0268:_x_31 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portb_shadow
;        532818:__bitbucket_86  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49f1f8:_x_29 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portb_shadow
;        532b88:__bitbucket_87  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49d268:_x_27 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portb_shadow
;        532978:__bitbucket_88  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49ce08:_x_25 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portb_shadow
;        532338:__bitbucket_89  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49bb08:__temp_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        532108:__bitbucket_90  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        499d28:_x_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        49a108:__temp_6  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        530f18:__bitbucket_91  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4986b8:__temp_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        530d48:__bitbucket_92  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4972f8:_x_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        497608:__temp_4  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        530938:__bitbucket_93  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4963a8:_x_19  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5303d8:__bitbucket_94  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        530698:__bitbucket_95  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_a0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        494648:_x_17 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _porta_shadow+0
;        530538:__bitbucket_96  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4933a8:_x_15 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _porta_shadow+0
;        4e85a8:__bitbucket_97  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4921f8:_x_13 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _porta_shadow+0
;        52fa78:__bitbucket_98  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        490268:_x_11 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _porta_shadow+0
;        52fd38:__bitbucket_99  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        486f98:_x_9 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _porta_shadow+0
;        52fbd8:__bitbucket_100  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        48edf8:_x_7 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _porta_shadow+0
;        52f668:__bitbucket_101  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52f108:__bitbucket_102  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52f3c8:__bitbucket_103  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        48af08:__temp_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52f268:__bitbucket_104  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        489188:_x_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4894b8:__temp  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        52ebd8:__bitbucket_105  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        488348:_x_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52e678:__bitbucket_106  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52e938:__bitbucket_107  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
; --- call stack ---
; {root} (depth=0)
;   print_crlf (depth=1)
;   print_byte_dec (depth=1)
;     _print_universal_dec (depth=2)
;   print_string (depth=1)
;   parsemessageid (depth=1)
;     ismsg (depth=2)
;     ismsg (depth=2)
;     ismsg (depth=2)
;     ismsg (depth=2)
;     ismsg (depth=2)
;     ismsg (depth=2)
;   storebytes (depth=1)
;   print_crlf (depth=1)
;   print_byte_dec (depth=1)
;     _print_universal_dec (depth=2)
;   print_string (depth=1)
;   serial_hw_read (depth=1)
;   setdutycycle (depth=1)
;     _serial_hw_data_put (depth=2)
;       serial_send_byte (depth=3)
;   delay_1ms (depth=1)
;   print_string (depth=1)
;   serial_hw_init (depth=1)
;     _calculate_and_set_baudrate (depth=2)
;Temporary Labels
;487448:_l1(use=0:ref=2:pc=0000)
;4874a8:_l2(use=0:ref=2:pc=0000)
;487f48:_l3(use=0:ref=2:pc=0000)
;487fa8:_l4(use=0:ref=2:pc=0000)
;4889c8:_l5(use=0:ref=1:pc=0000)
;488ec8:_l6(use=0:ref=2:pc=0000)
;488f28:_l7(use=0:ref=2:pc=0000)
;48a618:_l8(use=0:ref=1:pc=0000)
;48aa78:_l9(use=0:ref=2:pc=0000)
;48aad8:_l10(use=0:ref=2:pc=0000)
;48b918:_l11(use=0:ref=2:pc=0000)
;48b978:_l12(use=0:ref=2:pc=0000)
;48ccf8:_l13(use=0:ref=1:pc=0000)
;48d528:_l14(use=0:ref=2:pc=0000)
;48d588:_l15(use=0:ref=2:pc=0000)
;48eab8:_l16(use=0:ref=2:pc=0000)
;48eb18:_l17(use=0:ref=2:pc=0000)
;48f2f8:_l18(use=0:ref=1:pc=0000)
;48fe98:_l19(use=0:ref=2:pc=0000)
;48fef8:_l20(use=0:ref=2:pc=0000)
;4902f8:_l21(use=0:ref=1:pc=0000)
;490cd8:_l22(use=0:ref=2:pc=0000)
;490d38:_l23(use=0:ref=2:pc=0000)
;491368:_l24(use=0:ref=1:pc=0000)
;491e28:_l25(use=0:ref=2:pc=0000)
;491e88:_l26(use=0:ref=2:pc=0000)
;4925e8:_l27(use=0:ref=1:pc=0000)
;492978:_l28(use=0:ref=2:pc=0000)
;492f08:_l29(use=0:ref=2:pc=0000)
;493798:_l30(use=0:ref=1:pc=0000)
;494308:_l31(use=0:ref=2:pc=0000)
;494368:_l32(use=0:ref=2:pc=0000)
;494a38:_l33(use=0:ref=1:pc=0000)
;495448:_l34(use=0:ref=2:pc=0000)
;4954a8:_l35(use=0:ref=2:pc=0000)
;495fb8:_l36(use=0:ref=2:pc=0000)
;495828:_l37(use=0:ref=2:pc=0000)
;496a88:_l38(use=0:ref=1:pc=0000)
;496f88:_l39(use=0:ref=2:pc=0000)
;496438:_l40(use=0:ref=2:pc=0000)
;498758:_l41(use=0:ref=1:pc=0000)
;498bb8:_l42(use=0:ref=2:pc=0000)
;498c18:_l43(use=0:ref=2:pc=0000)
;4999e8:_l44(use=0:ref=2:pc=0000)
;499a48:_l45(use=0:ref=2:pc=0000)
;49b218:_l46(use=0:ref=1:pc=0000)
;49b678:_l47(use=0:ref=2:pc=0000)
;49b6d8:_l48(use=0:ref=2:pc=0000)
;49cac8:_l49(use=0:ref=2:pc=0000)
;49cb28:_l50(use=0:ref=2:pc=0000)
;49d2f8:_l51(use=0:ref=1:pc=0000)
;49dcd8:_l52(use=0:ref=2:pc=0000)
;49dd38:_l53(use=0:ref=2:pc=0000)
;49e368:_l54(use=0:ref=1:pc=0000)
;49ee28:_l55(use=0:ref=2:pc=0000)
;49ee88:_l56(use=0:ref=2:pc=0000)
;49f5e8:_l57(use=0:ref=1:pc=0000)
;49f978:_l58(use=0:ref=2:pc=0000)
;49ff08:_l59(use=0:ref=2:pc=0000)
;4a0658:_l60(use=0:ref=1:pc=0000)
;4a02f8:_l61(use=0:ref=2:pc=0000)
;4a05b8:_l62(use=0:ref=2:pc=0000)
;4a1bd8:_l63(use=0:ref=2:pc=0000)
;4a1c38:_l64(use=0:ref=2:pc=0000)
;4a2658:_l65(use=0:ref=1:pc=0000)
;4a2b58:_l66(use=0:ref=2:pc=0000)
;4a2bb8:_l67(use=0:ref=2:pc=0000)
;4a4218:_l68(use=0:ref=1:pc=0000)
;4a4678:_l69(use=0:ref=2:pc=0000)
;4a46d8:_l70(use=0:ref=2:pc=0000)
;4a55b8:_l71(use=0:ref=2:pc=0000)
;4a5618:_l72(use=0:ref=2:pc=0000)
;4a6de8:_l73(use=0:ref=1:pc=0000)
;4a7278:_l74(use=0:ref=2:pc=0000)
;4a72d8:_l75(use=0:ref=2:pc=0000)
;4a8658:_l76(use=0:ref=2:pc=0000)
;4a86b8:_l77(use=0:ref=2:pc=0000)
;4a8d88:_l78(use=0:ref=1:pc=0000)
;4a97f8:_l79(use=0:ref=2:pc=0000)
;4a9858:_l80(use=0:ref=2:pc=0000)
;4a9f28:_l81(use=0:ref=1:pc=0000)
;4aa9b8:_l82(use=0:ref=2:pc=0000)
;4aaa18:_l83(use=0:ref=2:pc=0000)
;4ab218:_l84(use=0:ref=1:pc=0000)
;4abbf8:_l85(use=0:ref=2:pc=0000)
;4abc58:_l86(use=0:ref=2:pc=0000)
;4ac368:_l87(use=0:ref=1:pc=0000)
;4ace28:_l88(use=0:ref=2:pc=0000)
;4ace88:_l89(use=0:ref=2:pc=0000)
;4ad5e8:_l90(use=0:ref=1:pc=0000)
;4ad978:_l91(use=0:ref=2:pc=0000)
;4adf08:_l92(use=0:ref=2:pc=0000)
;4ae798:_l93(use=0:ref=1:pc=0000)
;4ae438:_l94(use=0:ref=2:pc=0000)
;4af108:_l95(use=0:ref=2:pc=0000)
;4af7d8:_l96(use=0:ref=1:pc=0000)
;460d18:_l97(use=0:ref=2:pc=0000)
;461918:_l98(use=0:ref=2:pc=0000)
;4b0658:_l99(use=0:ref=1:pc=0000)
;4b9e08:_l100(use=0:ref=2:pc=0000)
;4b9e68:_l101(use=0:ref=2:pc=0000)
;4bb878:_l102(use=0:ref=2:pc=0000)
;4bb8d8:_l103(use=0:ref=2:pc=0000)
;4bc8b8:_l104(use=0:ref=2:pc=0000)
;4bc918:_l105(use=0:ref=2:pc=0000)
;4be168:_l106(use=0:ref=2:pc=0000)
;4be1c8:_l107(use=0:ref=2:pc=0000)
;4c1168:_l108(use=0:ref=2:pc=0000)
;4c11c8:_l109(use=0:ref=2:pc=0000)
;4c2ad8:_l110(use=0:ref=2:pc=0000)
;4c2b38:_l111(use=0:ref=2:pc=0000)
;4c3a48:_l112(use=0:ref=2:pc=0000)
;4c3aa8:_l113(use=0:ref=2:pc=0000)
;4c5288:_l114(use=0:ref=2:pc=0000)
;4c52e8:_l115(use=0:ref=2:pc=0000)
;4c7788:_l116(use=0:ref=2:pc=0000)
;4c77e8:_l117(use=0:ref=2:pc=0000)
;4c91f8:_l118(use=0:ref=2:pc=0000)
;4c9258:_l119(use=0:ref=2:pc=0000)
;4ca168:_l120(use=0:ref=2:pc=0000)
;4ca1c8:_l121(use=0:ref=2:pc=0000)
;4cb8d8:_l122(use=0:ref=2:pc=0000)
;4cb938:_l123(use=0:ref=2:pc=0000)
;4dc278:_l124(use=0:ref=2:pc=0000)
;4dc2d8:_l125(use=0:ref=2:pc=0000)
;4dd238:_l126(use=0:ref=2:pc=0000)
;4dd298:_l127(use=0:ref=2:pc=0000)
;4de248:_l128(use=0:ref=2:pc=0000)
;4de2a8:_l129(use=0:ref=2:pc=0000)
;4df258:_l130(use=0:ref=2:pc=0000)
;4df2b8:_l131(use=0:ref=2:pc=0000)
;4df9a8:_l132(use=0:ref=1:pc=0000)
;4dfeb8:_l133(use=0:ref=1:pc=0000)
;4e02f8:_l134(use=0:ref=1:pc=0000)
;4e1c18:_l135(use=0:ref=1:pc=0000)
;4e1758:_l136(use=0:ref=1:pc=0000)
;4e24e8:_l137(use=0:ref=1:pc=0000)
;4e2698:_l138(use=0:ref=1:pc=0000)
;4e3918:_l139(use=0:ref=1:pc=0000)
;4e3c78:_l140(use=0:ref=1:pc=0000)
;4e3f18:_l141(use=0:ref=1:pc=0000)
;4e3648:_l142(use=0:ref=1:pc=0000)
;4e4278:_l143(use=0:ref=1:pc=0000)
;4e46f8:_l144(use=0:ref=1:pc=0000)
;4e48b8:_l145(use=0:ref=1:pc=0000)
;4e4c88:_l146(use=0:ref=2:pc=0000)
;4e4ce8:_l147(use=0:ref=2:pc=0000)
;4e48f8:_l148(use=0:ref=1:pc=0000)
;4e4428:_l149(use=0:ref=1:pc=0000)
;4e42f8:_l150(use=0:ref=1:pc=0000)
;4e52e8:_l151(use=0:ref=1:pc=0000)
;4e6358:_l152(use=0:ref=1:pc=0000)
;4e6548:_l153(use=0:ref=1:pc=0000)
;4e8168:_l154(use=0:ref=2:pc=0000)
;4e81c8:_l155(use=0:ref=2:pc=0000)
;4e8568:_l156(use=5:ref=3:pc=010a)
;4e94a8:_l157(use=5:ref=3:pc=010a)
;4e9628:_l158(use=0:ref=1:pc=0000)
;4e9c28:_l159(use=0:ref=1:pc=0000)
;4eacb8:_l160(use=0:ref=1:pc=0000)
;4eb338:_l161(use=5:ref=3:pc=0101)
;4ebab8:_l162(use=0:ref=1:pc=0000)
;4ebe88:_l163(use=5:ref=3:pc=0107)
;4ed168:_l164(use=0:ref=2:pc=0000)
;4ed1c8:_l165(use=0:ref=2:pc=0000)
;4ed568:_l166(use=0:ref=1:pc=0000)
;4edaa8:_l167(use=0:ref=1:pc=0000)
;4edc28:_l168(use=0:ref=1:pc=0000)
;4eeb78:_l169(use=5:ref=3:pc=0130)
;4ef298:_l170(use=5:ref=3:pc=0123)
;4ef2f8:_l171(use=5:ref=3:pc=012c)
;4ef358:_l172(use=0:ref=1:pc=0000)
;4f0828:_l173(use=0:ref=1:pc=0000)
;4f1b68:_l174(use=0:ref=1:pc=0000)
;4f2228:_l175(use=5:ref=3:pc=013f)
;4f2968:_l176(use=0:ref=1:pc=0000)
;4f2e18:_l177(use=5:ref=3:pc=0145)
;4f3448:_l178(use=9:ref=3:pc=0160)
;4f38e8:_l179(use=0:ref=1:pc=0000)
;4f3a68:_l180(use=5:ref=3:pc=0158)
;4f3e58:_l181(use=9:ref=3:pc=0155)
;4f4cf8:_l182(use=0:ref=1:pc=0000)
;4f5338:_l183(use=0:ref=1:pc=0000)
;4f64a8:_l184(use=0:ref=2:pc=0000)
;4f6508:_l185(use=5:ref=4:pc=0198)
;4f6968:_l186(use=0:ref=1:pc=0000)
;4f6e18:_l187(use=5:ref=3:pc=0169)
;4f8298:_l188(use=0:ref=1:pc=0000)
;4f8668:_l189(use=5:ref=3:pc=0177)
;4f8de8:_l190(use=5:ref=3:pc=0196)
;4f9238:_l191(use=5:ref=3:pc=0196)
;4f93b8:_l192(use=5:ref=3:pc=018e)
;4f97b8:_l193(use=9:ref=3:pc=018a)
;4fa8e8:_l194(use=0:ref=1:pc=0000)
;4fad98:_l195(use=0:ref=1:pc=0000)
;4fbb98:_l196(use=0:ref=2:pc=0000)
;4fbbf8:_l197(use=0:ref=2:pc=0000)
;4fcba8:_l198(use=0:ref=2:pc=0000)
;4fcc08:_l199(use=0:ref=2:pc=0000)
;4fd4d8:_l200(use=5:ref=3:pc=01ce)
;4fe338:_l201(use=5:ref=3:pc=01b0)
;4ff828:_l202(use=0:ref=1:pc=0000)
;4ffcf8:_l203(use=5:ref=3:pc=01bf)
;5004d8:_l204(use=5:ref=3:pc=01cc)
;5008a8:_l205(use=5:ref=3:pc=01c6)
;500f78:_l206(use=0:ref=1:pc=0000)
;501208:_l207(use=0:ref=1:pc=0000)
;501268:_l208(use=5:ref=3:pc=01c6)
;5012c8:_l209(use=5:ref=3:pc=01ca)
;501328:_l210(use=0:ref=1:pc=0000)
;502768:_l211(use=0:ref=2:pc=0000)
;5027c8:_l212(use=0:ref=2:pc=0000)
;505d38:_l213(use=0:ref=2:pc=0000)
;505d98:_l214(use=0:ref=2:pc=0000)
;506788:_l215(use=0:ref=2:pc=0000)
;5067e8:_l216(use=0:ref=2:pc=0000)
;506e68:_l217(use=5:ref=3:pc=01ea)
;506ec8:_l218(use=5:ref=3:pc=01f1)
;506f28:_l219(use=0:ref=1:pc=0000)
;5084d8:_l220(use=0:ref=2:pc=0000)
;508538:_l221(use=0:ref=2:pc=0000)
;508b88:_l222(use=0:ref=1:pc=0000)
;508be8:_l223(use=0:ref=1:pc=0000)
;508c48:_l224(use=0:ref=1:pc=0000)
;50a108:_l225(use=5:ref=4:pc=01f2)
;50a168:_l226(use=0:ref=2:pc=0000)
;50a4a8:_l227(use=0:ref=1:pc=0000)
;50a508:_l228(use=0:ref=1:pc=0000)
;50a568:_l229(use=0:ref=1:pc=0000)
;50b9b8:_l230(use=0:ref=1:pc=0000)
;50bcc8:_l231(use=0:ref=1:pc=0000)
;50f638:_l232(use=0:ref=2:pc=0000)
;50f698:_l233(use=0:ref=2:pc=0000)
;50fa28:_l234(use=0:ref=1:pc=0000)
;5107e8:_l235(use=0:ref=1:pc=0000)
;511d68:_l236(use=0:ref=2:pc=0000)
;511dc8:_l237(use=0:ref=2:pc=0000)
;5122a8:_l238(use=0:ref=1:pc=0000)
;513498:_l239(use=0:ref=1:pc=0000)
;514e68:_l240(use=0:ref=2:pc=0000)
;514ec8:_l241(use=4:ref=4:pc=02f4)
;5155a8:_l242(use=0:ref=2:pc=0000)
;515608:_l243(use=0:ref=2:pc=0000)
;515a78:_l244(use=0:ref=2:pc=0000)
;515ad8:_l245(use=0:ref=2:pc=0000)
;516708:_l246(use=0:ref=2:pc=0000)
;5168e8:_l247(use=0:ref=2:pc=0000)
;517c18:_l248(use=0:ref=2:pc=0000)
;517c78:_l249(use=0:ref=2:pc=0000)
;518768:_l250(use=5:ref=3:pc=0209)
;5187c8:_l251(use=5:ref=3:pc=022c)
;518828:_l252(use=4:ref=3:pc=0237)
;518a18:_l253(use=0:ref=1:pc=0000)
;518a58:_l254(use=5:ref=3:pc=0215)
;51a468:_l255(use=0:ref=2:pc=0000)
;51a4c8:_l256(use=0:ref=2:pc=0000)
;51b1c8:_l257(use=0:ref=1:pc=0000)
;51b268:_l258(use=0:ref=1:pc=0000)
;51c168:_l259(use=0:ref=2:pc=0000)
;51c1c8:_l260(use=0:ref=2:pc=0000)
;51cbe8:_l261(use=0:ref=1:pc=0000)
;51cc88:_l262(use=0:ref=1:pc=0000)
;51dd28:_l263(use=0:ref=2:pc=0000)
;51dd88:_l264(use=0:ref=2:pc=0000)
;51e2a8:_l265(use=0:ref=1:pc=0000)
;51e378:_l266(use=0:ref=1:pc=0000)
;51f2d8:_l267(use=0:ref=2:pc=0000)
;51f338:_l268(use=0:ref=2:pc=0000)
;51f7b8:_l269(use=0:ref=1:pc=0000)
;51f8a8:_l270(use=0:ref=1:pc=0000)
;5218c8:_l271(use=0:ref=2:pc=0000)
;521928:_l272(use=0:ref=2:pc=0000)
;521da8:_l273(use=0:ref=1:pc=0000)
;521e98:_l274(use=0:ref=1:pc=0000)
;523b38:_l275(use=0:ref=1:pc=0000)
;523c28:_l276(use=0:ref=1:pc=0000)
;524a98:_l277(use=0:ref=1:pc=0000)
;524af8:_l278(use=0:ref=1:pc=0000)
;524b58:_l279(use=0:ref=1:pc=0000)
;524cd8:_l280(use=0:ref=1:pc=0000)
;525b28:_l281(use=0:ref=1:pc=0000)
;5279f8:_l282(use=0:ref=2:pc=0000)
;527a58:_l283(use=0:ref=2:pc=0000)
;528548:_l284(use=0:ref=1:pc=0000)
;5285a8:_l285(use=0:ref=1:pc=0000)
;528608:_l286(use=0:ref=1:pc=0000)
;528788:_l287(use=0:ref=1:pc=0000)
;529658:_l288(use=0:ref=1:pc=0000)
;52b4c8:_l289(use=0:ref=2:pc=0000)
;52b528:_l290(use=0:ref=2:pc=0000)
;52b9a8:_l291(use=0:ref=1:pc=0000)
;52ba98:_l292(use=0:ref=1:pc=0000)
;5318d8:_l293(use=0:ref=2:pc=0000)
;531938:_l294(use=0:ref=2:pc=0000)
;531d88:_l295(use=0:ref=1:pc=0000)
;531e78:_l296(use=0:ref=1:pc=0000)
;537ce8:_l297(use=0:ref=2:pc=0000)
;537d48:_l298(use=0:ref=2:pc=0000)
;5382f8:_l299(use=0:ref=1:pc=0000)
;5383e8:_l300(use=0:ref=1:pc=0000)
;53b998:_l301(use=0:ref=2:pc=0000)
;53b9f8:_l302(use=0:ref=2:pc=0000)
;53be48:_l303(use=0:ref=1:pc=0000)
;53bf38:_l304(use=0:ref=1:pc=0000)
;53e278:_l305(use=0:ref=2:pc=0000)
;53e2d8:_l306(use=0:ref=2:pc=0000)
;53f108:_l307(use=0:ref=2:pc=0000)
;53f168:_l308(use=0:ref=2:pc=0000)
;53ffa8:_l309(use=0:ref=2:pc=0000)
;53f5c8:_l310(use=0:ref=2:pc=0000)
;5417e8:_l311(use=0:ref=2:pc=0000)
;541848:_l312(use=0:ref=2:pc=0000)
;542788:_l313(use=0:ref=2:pc=0000)
;5427e8:_l314(use=0:ref=2:pc=0000)
;543788:_l315(use=0:ref=2:pc=0000)
;5437e8:_l316(use=0:ref=2:pc=0000)
;544788:_l317(use=0:ref=2:pc=0000)
;5447e8:_l318(use=0:ref=2:pc=0000)
;545d78:_l319(use=0:ref=1:pc=0000)
;546588:_l320(use=0:ref=1:pc=0000)
;548388:_l321(use=0:ref=1:pc=0000)
;548a98:_l322(use=5:ref=3:pc=025f)
;549598:_l323(use=5:ref=3:pc=0260)
;5495f8:_l324(use=9:ref=3:pc=02f4)
;549658:_l325(use=0:ref=1:pc=0000)
;54b408:_l326(use=0:ref=1:pc=0000)
;54c4a8:_l327(use=5:ref=3:pc=02f2)
;54dea8:_l328(use=0:ref=2:pc=0000)
;54df08:_l329(use=0:ref=2:pc=0000)
;54e6c8:_l330(use=0:ref=2:pc=0000)
;54e728:_l331(use=0:ref=2:pc=0000)
;54ee08:_l332(use=0:ref=2:pc=0000)
;54ee68:_l333(use=0:ref=2:pc=0000)
;54f658:_l334(use=0:ref=2:pc=0000)
;54f6b8:_l335(use=0:ref=2:pc=0000)
;54fdf8:_l336(use=0:ref=2:pc=0000)
;54fe58:_l337(use=0:ref=2:pc=0000)
;550328:_l338(use=0:ref=2:pc=0000)
;550388:_l339(use=0:ref=2:pc=0000)
;550ac8:_l340(use=0:ref=2:pc=0000)
;550b28:_l341(use=0:ref=2:pc=0000)
;551398:_l342(use=0:ref=2:pc=0000)
;5513f8:_l343(use=0:ref=2:pc=0000)
;551b38:_l344(use=0:ref=2:pc=0000)
;551b98:_l345(use=0:ref=2:pc=0000)
;5527c8:_l346(use=0:ref=2:pc=0000)
;552828:_l347(use=0:ref=2:pc=0000)
;552bb8:_l348(use=0:ref=1:pc=0000)
;553428:_l349(use=0:ref=1:pc=0000)
;553cd8:_l350(use=0:ref=1:pc=0000)
;554608:_l351(use=0:ref=1:pc=0000)
;5547c8:_l352(use=0:ref=1:pc=0000)
;555c88:_l353(use=0:ref=1:pc=0000)
;5569d8:_l354(use=0:ref=1:pc=0000)
;556a38:_l355(use=0:ref=1:pc=0000)
;556a98:_l356(use=0:ref=1:pc=0000)
;556c88:_l357(use=0:ref=1:pc=0000)
;556f08:_l358(use=0:ref=1:pc=0000)
;557db8:_l359(use=0:ref=2:pc=0000)
;557e18:_l360(use=0:ref=2:pc=0000)
;558c98:_l361(use=5:ref=3:pc=02f9)
;558cf8:_l362(use=5:ref=3:pc=030b)
;558d58:_l363(use=0:ref=1:pc=0000)
;558f48:_l364(use=0:ref=1:pc=0000)
;559208:_l365(use=0:ref=1:pc=0000)
;559248:_l366(use=0:ref=2:pc=0000)
;55a108:_l367(use=0:ref=2:pc=0000)
;55ae88:_l368(use=0:ref=1:pc=0000)
;55aee8:_l369(use=0:ref=1:pc=0000)
;55af48:_l370(use=0:ref=1:pc=0000)
;55be88:_l371(use=5:ref=4:pc=0317)
;55bee8:_l372(use=0:ref=2:pc=0000)
;55cdf8:_l373(use=0:ref=1:pc=0000)
;55ce58:_l374(use=0:ref=1:pc=0000)
;55ceb8:_l375(use=0:ref=1:pc=0000)
;55ef78:_l376(use=0:ref=2:pc=0000)
;55e868:_l377(use=0:ref=2:pc=0000)
;55fa18:_l378(use=0:ref=1:pc=0000)
;55fa78:_l379(use=0:ref=1:pc=0000)
;55fad8:_l380(use=0:ref=1:pc=0000)
;562168:_l381(use=0:ref=2:pc=0000)
;5621c8:_l382(use=8:ref=5:pc=0339)
;562588:_l383(use=0:ref=1:pc=0000)
;562c98:_l384(use=5:ref=3:pc=0323)
;563358:_l385(use=0:ref=1:pc=0000)
;563aa8:_l386(use=5:ref=3:pc=032c)
;565a18:_l387(use=0:ref=2:pc=0000)
;565a78:_l388(use=4:ref=4:pc=035f)
;566598:_l389(use=5:ref=3:pc=033b)
;5665f8:_l390(use=0:ref=1:pc=0000)
;566658:_l391(use=0:ref=1:pc=0000)
;5667d8:_l392(use=0:ref=1:pc=0000)
;566e28:_l393(use=5:ref=3:pc=0357)
;5695d8:_l394(use=0:ref=2:pc=0000)
;569638:_l395(use=24:ref=9:pc=03b5)
;5698d8:_l396(use=0:ref=1:pc=0000)
;569c18:_l397(use=5:ref=3:pc=036e)
;56a2e8:_l398(use=0:ref=1:pc=0000)
;56a6d8:_l399(use=5:ref=3:pc=037c)
;56ace8:_l400(use=0:ref=1:pc=0000)
;56b1b8:_l401(use=5:ref=3:pc=038a)
;56b7c8:_l402(use=0:ref=1:pc=0000)
;56bbb8:_l403(use=5:ref=3:pc=0398)
;56c2e8:_l404(use=0:ref=1:pc=0000)
;56c6d8:_l405(use=5:ref=3:pc=03a6)
;56cce8:_l406(use=0:ref=1:pc=0000)
;56d1b8:_l407(use=5:ref=3:pc=03b4)
;56eb78:_l408(use=5:ref=4:pc=03b5)
;56ebd8:_l409(use=0:ref=2:pc=0000)
;56eeb8:_l410(use=0:ref=1:pc=0000)
;56f598:_l411(use=0:ref=1:pc=0000)
;56fa38:_l412(use=0:ref=1:pc=0000)
;570238:_l413(use=0:ref=1:pc=0000)
;5705f8:_l414(use=0:ref=1:pc=0000)
;570c78:_l415(use=0:ref=1:pc=0000)
;571c08:_l416(use=0:ref=1:pc=0000)
;572338:_l417(use=0:ref=1:pc=0000)
;573c98:_l418(use=0:ref=1:pc=0000)
;574338:_l419(use=0:ref=1:pc=0000)
;5747d8:_l420(use=0:ref=1:pc=0000)
;574ad8:_l421(use=0:ref=1:pc=0000)
;574c58:_l422(use=0:ref=1:pc=0000)
;575438:_l423(use=0:ref=1:pc=0000)
;576388:_l424(use=0:ref=1:pc=0000)
;5769b8:_l425(use=0:ref=1:pc=0000)
;577208:_l426(use=0:ref=1:pc=0000)
;577738:_l427(use=0:ref=1:pc=0000)
;57ca58:_l428(use=0:ref=2:pc=0000)
;57cab8:_l429(use=0:ref=2:pc=0000)
;57cd88:_l430(use=0:ref=1:pc=0000)
;57d438:_l431(use=9:ref=3:pc=03ec)
;57f238:_l432(use=5:ref=4:pc=0417)
;57f298:_l433(use=0:ref=2:pc=0000)
;57f538:_l434(use=0:ref=1:pc=0000)
;57f5f8:_l435(use=0:ref=1:pc=0000)
;580408:_l436(use=0:ref=1:pc=0000)
;5809e8:_l437(use=0:ref=1:pc=0000)
;581c28:_l438(use=5:ref=3:pc=041a)
;581c88:_l439(use=0:ref=1:pc=0000)
;581ce8:_l440(use=0:ref=1:pc=0000)
;582ad8:_l441(use=0:ref=1:pc=0000)
;582c88:_l442(use=0:ref=1:pc=0000)
;583c08:_l443(use=14:ref=4:pc=0434)
;583c68:_l444(use=0:ref=1:pc=0000)
;584af8:_l445(use=5:ref=3:pc=043d)
;584bc8:_l446(use=0:ref=1:pc=0000)
;584f78:_l447(use=0:ref=1:pc=0000)
;585198:_l448(use=0:ref=1:pc=0000)
;5858f8:_l449(use=9:ref=3:pc=0464)
;5859c8:_l450(use=0:ref=1:pc=0000)
;5863c8:_l451(use=5:ref=3:pc=046c)
;586498:_l452(use=0:ref=1:pc=0000)
;586928:_l453(use=5:ref=3:pc=046f)
;5869f8:_l454(use=0:ref=1:pc=0000)
;587898:_l455(use=0:ref=1:pc=0000)
;587968:_l456(use=0:ref=1:pc=0000)
;587df8:_l457(use=0:ref=1:pc=0000)
;587ec8:_l458(use=0:ref=1:pc=0000)
;588208:_l459(use=5:ref=3:pc=049b)
;5882d8:_l460(use=0:ref=1:pc=0000)
;588828:_l461(use=5:ref=3:pc=049f)
;5888f8:_l462(use=0:ref=1:pc=0000)
;588a38:_l463(use=6:ref=4:pc=049f)
;5c3a08:_l464(use=2:ref=1:pc=0043)
;5c3a68:_l465(use=2:ref=1:pc=0046)
;5c43c8:_l466(use=0:ref=1:pc=0052)
;5c4428:_l467(use=0:ref=1:pc=0000)
;5c5a18:_l468(use=0:ref=1:pc=0071)
;5c5d58:_l469(use=2:ref=1:pc=0077)
;5c8428:_l470(use=0:ref=1:pc=00ba)
;5c8488:_l471(use=0:ref=1:pc=0000)
;5cb108:_l472(use=0:ref=1:pc=00fd)
;5cb448:_l473(use=2:ref=1:pc=0103)
;5cc5a8:_l474(use=0:ref=1:pc=0120)
;5cc988:_l475(use=0:ref=1:pc=0126)
;5cdf68:_l476(use=0:ref=1:pc=0148)
;5ce3a8:_l477(use=0:ref=1:pc=014e)
;5cfd88:_l478(use=0:ref=1:pc=0176)
;5d0228:_l479(use=2:ref=1:pc=017c)
;5d0a88:_l480(use=0:ref=1:pc=018a)
;5d0e68:_l481(use=0:ref=1:pc=0190)
;5d25a8:_l482(use=0:ref=1:pc=01b2)
;5d28e8:_l483(use=2:ref=1:pc=01b8)
;5d4548:_l484(use=0:ref=1:pc=01ea)
;5d45a8:_l485(use=0:ref=1:pc=0000)
;5d5ea8:_l486(use=0:ref=1:pc=020e)
;5d6328:_l487(use=2:ref=1:pc=0214)
;5e2988:_l488(use=6:ref=1:pc=0376)
;5e3dc8:_l489(use=0:ref=1:pc=037c)
;5e9d28:_l490(use=0:ref=1:pc=042a)
;5e9d88:_l491(use=0:ref=1:pc=0000)
;5ec2a8:_l492(use=3:ref=1:pc=045c)
;5ec308:_l493(use=3:ref=1:pc=045e)
;5eeb88:_l494(use=0:ref=1:pc=049c)
;5eeef8:_l495(use=2:ref=1:pc=04a2)
;5f3468:_l496(use=2:ref=1:pc=0516)
;5f34c8:_l497(use=2:ref=1:pc=0519)
;5f4908:_l498(use=2:ref=1:pc=0536)
;5f4968:_l499(use=2:ref=1:pc=0539)
;5f5de8:_l500(use=2:ref=1:pc=0556)
;5f5e48:_l501(use=2:ref=1:pc=0559)
;5f73a8:_l502(use=2:ref=1:pc=0576)
;5f7408:_l503(use=2:ref=1:pc=0579)
;5f8888:_l504(use=2:ref=1:pc=0596)
;5f88e8:_l505(use=2:ref=1:pc=0599)
;5f9d68:_l506(use=2:ref=1:pc=05b6)
;5f9dc8:_l507(use=2:ref=1:pc=05b9)
;5fda88:_l508(use=2:ref=1:pc=0612)
;5fe2a8:_l509(use=0:ref=1:pc=0618)
;601908:_l510(use=2:ref=1:pc=0676)
;602128:_l511(use=0:ref=1:pc=067c)
;602c88:_l512(use=2:ref=1:pc=0695)
;602ce8:_l513(use=2:ref=1:pc=0692)
;605228:_l514(use=2:ref=1:pc=06cf)
;605288:_l515(use=2:ref=1:pc=06d2)
;605e68:_l516(use=0:ref=1:pc=06dd)
;6062a8:_l517(use=0:ref=1:pc=06e3)
;6097a8:_l518(use=2:ref=1:pc=0741)
;609808:_l519(use=2:ref=1:pc=0744)
;611cd8:_l520(use=2:ref=1:pc=0000)
;611d38:_l521(use=2:ref=1:pc=0000)
;611d98:_l522(use=2:ref=1:pc=0000)
;611df8:_l523(use=2:ref=1:pc=0000)
;613568:_l524(use=2:ref=1:pc=0000)
;614c68:_l525(use=2:ref=1:pc=0000)
;616f28:_l526(use=6:ref=1:pc=0000)
;61dcc8:_l527(use=2:ref=1:pc=0072)
;61dd28:_l528(use=2:ref=1:pc=00a1)
;61dd88:_l529(use=2:ref=1:pc=0092)
;61dde8:_l530(use=2:ref=1:pc=0059)
;61df68:_l531(use=2:ref=1:pc=0069)
;61da28:_l532(use=2:ref=1:pc=006c)
;61e168:_l533(use=6:ref=1:pc=008e)
;61e4c8:_l534(use=2:ref=1:pc=00e7)
;61e528:_l535(use=2:ref=1:pc=00e9)
;61e5a8:_l536(use=0:ref=1:pc=00ed)
;61e608:_l537(use=0:ref=1:pc=0000)
;61e668:_l538(use=0:ref=1:pc=00fc)
;61e728:_l539(use=2:ref=1:pc=0100)
;61e7e8:_l540(use=0:ref=1:pc=011f)
;61e848:_l541(use=0:ref=1:pc=0000)
;61e9c8:_l542(use=0:ref=1:pc=013a)
;61ea88:_l543(use=2:ref=1:pc=013e)
;61eae8:_l544(use=0:ref=1:pc=0149)
;61eb48:_l545(use=0:ref=1:pc=014d)
;61ec68:_l546(use=0:ref=1:pc=015a)
;61ed28:_l547(use=0:ref=1:pc=015e)
;61ee48:_l548(use=0:ref=1:pc=0172)
;61ef08:_l549(use=2:ref=1:pc=0176)
;61ef68:_l550(use=0:ref=1:pc=017b)
;61efc8:_l551(use=0:ref=1:pc=017f)
;61f1e8:_l552(use=0:ref=1:pc=0190)
;61f2a8:_l553(use=2:ref=1:pc=0194)
;61f448:_l554(use=0:ref=1:pc=01a8)
;61f4a8:_l555(use=0:ref=1:pc=0000)
;61f568:_l556(use=0:ref=1:pc=01ba)
;61f628:_l557(use=2:ref=1:pc=01be)
;61fe68:_l558(use=6:ref=1:pc=0273)
;461cd8:_l559(use=0:ref=1:pc=0277)
;461df8:_l560(use=0:ref=1:pc=02e0)
;461fa8:_l561(use=0:ref=1:pc=0000)
;462938:_l562(use=3:ref=1:pc=02fd)
;462c18:_l563(use=3:ref=1:pc=02ff)
;463ac8:_l564(use=0:ref=1:pc=0325)
;463eb8:_l565(use=2:ref=1:pc=0329)
;466f98:_l566(use=2:ref=1:pc=03e1)
;467458:_l567(use=0:ref=1:pc=03e5)
;468458:_l568(use=2:ref=1:pc=0410)
;468958:_l569(use=0:ref=1:pc=0414)
;468bd8:_l570(use=2:ref=1:pc=041f)
;468e58:_l571(use=2:ref=1:pc=041e)
;4691d8:_l572(use=0:ref=1:pc=043f)
;469598:_l573(use=0:ref=1:pc=0443)
;Unnamed Constant Variables
;============
