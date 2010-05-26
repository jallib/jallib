; compiler: jal 2.4n-beta (compiled Mar 13 2010)

; command line:  c:\jallib\compiler\jalv2 -debug jallib.jal
; compiler flags:
;    boot-fuse, debug-compiler, debug-codegen, opt-expr-reduce
;    opt-cexpr-reduce, opt-variable-reduce, warn-backend
;    warn-conversion, warn-misc, warn-range, warn-stack-overflow
;    warn-truncate
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
v__btemp79                     EQU 0x006a  ; _btemp79-->_bitbucket:2
v___x_69                       EQU 0x0041  ; x-->_porta_shadow:2
v___char_7                     EQU 0x006c  ; char
v____btemp67_1                 EQU 0x006a  ; _btemp67-->_bitbucket:4
v____btemp73_1                 EQU 0x006a  ; _btemp73-->_bitbucket:10
v___duty_1                     EQU 0x006d  ; setdutycycle:duty
v____temp_46                   EQU 0       ; gpstakt(): _temp
v__btemp61                     EQU 0x006d  ; parsemessageid:_btemp61-->_bitbucket4:0
v__btemp62                     EQU 0x006d  ; parsemessageid:_btemp62-->_bitbucket4:1
v__btemp63                     EQU 0x006d  ; parsemessageid:_btemp63-->_bitbucket4:2
v__btemp64                     EQU 0x006d  ; parsemessageid:_btemp64-->_bitbucket4:3
v__btemp65                     EQU 0x006d  ; parsemessageid:_btemp65-->_bitbucket4:4
v__btemp66                     EQU 0x006d  ; parsemessageid:_btemp66-->_bitbucket4:5
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
v__btemp47                     EQU 0x0135  ; _print_universal_dec:_btemp47-->_bitbucket42:3
v__btemp48                     EQU 0x0135  ; _print_universal_dec:_btemp48-->_bitbucket42:4
v__btemp49                     EQU 0x0135  ; _print_universal_dec:_btemp49-->_bitbucket42:5
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
                               goto     l_isr               ; 4294967295 -V rs rs [hl hl] 000e 2bf9
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
                               goto     l__l527             ;  2 OV rs rs [?? ??] 004c 2859
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
l__l527
                               movwf    v__pic_sign         ;  2 OV rs rs [?? ??] 0059 00b3
                               movlw    0                   ;  2 OV rs rs [?? ??] 005a 3000
                                                            ; W = v__pic_sign
                               btfss    v__pic_divisor+3, 7 ;  2 OV rs rs [?? ??] 005b 1fab
                               goto     l__l528             ;  2 OV rs rs [?? ??] 005c 2869
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
l__l528
                               xorwf    v__pic_sign,f       ;  2 OV rs rs [?? ??] 0069 06b3
                               goto     l__l529             ;  2 OV rs rs [?? ??] 006a 286c
l__pic_divide
                               clrf     v__pic_sign         ;  2 OV rs rs [?? ??] 006b 01b3
                                                            ; W = v__pic_dividend
l__l529
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
l__l524
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
                               goto     l__l530             ;  2 OV rs rs [?? ??] 0083 288e
                               movf     v__pic_remainder+2,w;  2 OV rs rs [?? ??] 0084 0826
                                                            ; W = v__pic_sign
                               subwf    v__pic_divisor+2,w  ;  2 OV rs rs [?? ??] 0085 022a
                                                            ; W = v__pic_remainder
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 0086 1d03
                               goto     l__l530             ;  2 OV rs rs [?? ??] 0087 288e
                               movf     v__pic_remainder+1,w;  2 OV rs rs [?? ??] 0088 0825
                               subwf    v__pic_divisor+1,w  ;  2 OV rs rs [?? ??] 0089 0229
                                                            ; W = v__pic_remainder
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 008a 1d03
                               goto     l__l530             ;  2 OV rs rs [?? ??] 008b 288e
                               movf     v__pic_remainder,w  ;  2 OV rs rs [?? ??] 008c 0824
                               subwf    v__pic_divisor,w    ;  2 OV rs rs [?? ??] 008d 0228
                                                            ; W = v__pic_remainder
l__l530
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 008e 1903
                               goto     l__l526             ;  2 OV rs rs [?? ??] 008f 2892
                               btfsc    v__status, v__c     ;  2 OV rs rs [?? ??] 0090 1803
                                                            ; W = v__pic_sign
                               goto     l__l525             ;  2 OV rs rs [?? ??] 0091 28a1
                                                            ; W = v__pic_sign
l__l526
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
l__l525
                               decfsz   v__pic_loop,f       ;  2 OV rs rs [?? ??] 00a1 0bb2
                                                            ; W = v__pic_sign
                               goto     l__l524             ;  2 OV rs rs [?? ??] 00a2 2872
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
; 16f690.jal
;   96 var          byte  _PORTA_shadow        = PORTA
                               movf     v_porta,w           ;  0 OV rs rs [hl hl] 00c1 0805
                               movwf    v__porta_shadow     ;  0 OV rs rs [hl hl] 00c2 00c1
; jallib.jal
;   30 pin_a2_direction =  output
                               datalo_set v_trisa ; pin_a2_direction        ;  0 OV rs rS [hl hl] 00c3 1683
                                                            ; W = v__porta_shadow
                               bcf      v_trisa, 2 ; pin_a2_direction       ;  0 OV rS rS [hl hl] 00c4 1105
                                                            ; W = v__porta_shadow
;   32 enable_digital_io()
; 16f690.jal
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
; jallib.jal
;   32 enable_digital_io()
; 16f690.jal
;  891    analog_off()
; jallib.jal
;   32 enable_digital_io()
; 16f690.jal
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
; jallib.jal
;   32 enable_digital_io()
; 16f690.jal
;  892    adc_off()
; jallib.jal
;   32 enable_digital_io()
; 16f690.jal
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
; jallib.jal
;   32 enable_digital_io()
; 16f690.jal
;  893    comparator_off()
; jallib.jal
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
; serial_hw_int_cts.jal
;  134 end if
                               goto     l__l225             ;  0 OV rS rS [hl hl] 00d6 29f2
; usart_common.jal
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
; serial_hw_int_cts.jal
;  176 procedure  _serial_transmit_interrupt_handler() is
l__serial_transmit_interrupt_handler
;  182    if ((PIR1_TXIF == TRUE) & (PIE1_TXIE == TRUE)) then          -- UART xmit interrupt
                               bcf      v____bitbucket_54, 0 ; _btemp1;  4 OV rs rs [hl hl] 00de 103a
                               btfsc    v_pir1, 4 ; pir1_txif        ;  4 OV rs rs [hl hl] 00df 1a0c
                               bsf      v____bitbucket_54, 0 ; _btemp1;  4 OV rs rs [hl hl] 00e0 143a
                               datalo_set v_pie1 ; pie1_txie         ;  4 OV rs rS [hl hl] 00e1 1683
                               btfsc    v_pie1, 4 ; pie1_txie        ;  4 OV rS rS [hl hl] 00e2 1a0c
                               goto     l__l531             ;  4 OV rS rS [hl hl] 00e3 28e7
                               datalo_clr v____bitbucket_54 ; _btemp2;  4 OV rS rs [hl hl] 00e4 1283
                               bcf      v____bitbucket_54, 1 ; _btemp2;  4 OV rs rs [hl hl] 00e5 10ba
                               goto     l__l532             ;  4 OV rs rs [hl hl] 00e6 28e9
l__l531
                               datalo_clr v____bitbucket_54 ; _btemp2;  4 OV rS rs [hl hl] 00e7 1283
                               bsf      v____bitbucket_54, 1 ; _btemp2;  4 OV rs rs [hl hl] 00e8 14ba
l__l532
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
                               goto     l__l536             ;  4 OV rs rs [hl hl] 00fd 2900
                               btfss    v__status, v__c     ;  4 OV rs rs [hl hl] 00fe 1c03
                               goto     l__l161             ;  4 OV rs rs [hl hl] 00ff 2901
l__l536
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
                               goto     l__l540             ;  4 OV rs rs [hl hl] 013b 293e
                               btfss    v__status, v__c     ;  4 OV rs rs [hl hl] 013c 1c03
                                                            ; W = v__serial_offsetrcvhead
                               goto     l__l175             ;  4 OV rs rs [hl hl] 013d 293f
                                                            ; W = v__serial_offsetrcvhead
l__l540
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
                               goto     l__l546             ;  1 OV rs rs [?? ??] 0173 2976
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 0174 1c03
                                                            ; W = v___x_68
                               goto     l__l189             ;  1 OV rs rs [?? ??] 0175 2977
                                                            ; W = v___x_68
l__l546
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
                               goto     l__l550             ;  1 OV Rs Rs [?? ??] 0191 2994
                               btfss    v__status, v__c     ;  1 OV Rs Rs [?? ??] 0192 1c03
                               goto     l__l190             ;  1 OV Rs Rs [?? ??] 0193 2996
l__l550
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
                               goto     l__l554             ;  3 OV rs rs [?? ??] 01bb 29be
                               btfss    v__status, v__c     ;  3 OV rs rs [?? ??] 01bc 1c03
                                                            ; W = v__serial_offsetxmthead
                               goto     l__l203             ;  3 OV rs rs [?? ??] 01bd 29bf
                                                            ; W = v__serial_offsetxmthead
l__l554
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
; jallib.jal
;   54 serial_hw_init()               
                               call     l_serial_hw_init    ;  0 OV rS ?? [hl ??] 01f2 21d1
; print.jal
;   57 procedure print_crlf(volatile byte out device) is
                               goto     l__l368             ;  0 OV ?? ?? [?? ??] 01f3 2b0c
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
                               goto     l__l249             ;  1 OV rs rs [?? ??] 0208 2a21
                                                            ; W = v_len
l__l248
;   70       device = str[i]
                               datahi_set v___str_1         ;  1 OV rs Rs [?? ??] 0209 1703
                               movf     v___str_1+1,w       ;  1 OV Rs Rs [?? ??] 020a 0827
                               datahi_clr v__pic_pointer    ;  1 OV Rs rs [?? ??] 020b 1303
                                                            ; W = v___str_1
                               movwf    v__pic_pointer+1    ;  1 OV rs rs [?? ??] 020c 00b5
                                                            ; W = v___str_1
                               movf     v_i,w               ;  1 OV rs rs [?? ??] 020d 086f
                                                            ; W = v__pic_pointer
                               datahi_set v___str_1         ;  1 OV rs Rs [?? ??] 020e 1703
                                                            ; W = v_i
                               addwf    v___str_1,w         ;  1 OV Rs Rs [?? ??] 020f 0726
                                                            ; W = v_i
                               datahi_clr v__pic_pointer    ;  1 OV Rs rs [?? ??] 0210 1303
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0211 00b4
                               btfsc    v__status, v__c     ;  1 OV rs rs [?? ??] 0212 1803
                                                            ; W = v__pic_pointer
                               incf     v__pic_pointer+1,f  ;  1 OV rs rs [?? ??] 0213 0ab5
                                                            ; W = v__pic_pointer
                               bcf      v__pic_pointer+1, 6 ;  1 OV rs rs [?? ??] 0214 1335
                               movf     v__pic_pointer+1,w  ;  1 OV rs rs [?? ??] 0215 0835
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0216 20bd
                                                            ; W = v__pic_pointer
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0217 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 0218 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0219 00a0
                               movf     v____device_put_1,w ;  1 OV rs rs [?? ??] 021a 086d
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 021b 00b4
                                                            ; W = v____device_put_1
                               movf     v____device_put_1+1,w;  1 OV rs rs [?? ??] 021c 086e
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 021d 20bd
                                                            ; W = v____device_put_1
;   71    end loop
                               datalo_clr v_i               ;  1 OV ?? ?s [?? ??] 021e 1283
                               datahi_clr v_i               ;  1 OV ?s rs [?? ??] 021f 1303
                               incf     v_i,f               ;  1 OV rs rs [?? ??] 0220 0aef
l__l249
                               movf     v_i,w               ;  1 OV rs rs [?? ??] 0221 086f
                                                            ; W = v_len
                               datahi_set v_len             ;  1 OV rs Rs [?? ??] 0222 1703
                                                            ; W = v_i
                               subwf    v_len,w             ;  1 OV Rs Rs [?? ??] 0223 022c
                                                            ; W = v_i
                               datahi_clr v__pic_temp       ;  1 OV Rs rs [?? ??] 0224 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0225 00a0
                               datahi_set v_len             ;  1 OV rs Rs [?? ??] 0226 1703
                                                            ; W = v__pic_temp
                               movf     v_len+1,w           ;  1 OV Rs Rs [?? ??] 0227 082d
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_temp       ;  1 OV Rs rs [?? ??] 0228 1303
                                                            ; W = v_len
                               iorwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 0229 0420
                                                            ; W = v_len
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 022a 1d03
                               goto     l__l248             ;  1 OV rs rs [?? ??] 022b 2a09
;   73 end procedure
                               return                       ;  1 OV rs rs [?? ??] 022c 0008
;  273 procedure print_byte_dec(volatile byte out device, byte in data) is
l_print_byte_dec
                               datahi_set v___data_49       ;  1 OV rs Rs [?? ??] 022d 1703
                                                            ; W = v_gpserrorcode
                               movwf    v___data_49         ;  1 OV Rs Rs [?? ??] 022e 00a2
                                                            ; W = v_gpserrorcode
;  275    _print_universal_dec(device, data, 100, 3)
                               datahi_clr v____device_put_19;  1 OV Rs rs [?? ??] 022f 1303
                                                            ; W = v___data_49
                               movf     v____device_put_19,w;  1 OV rs rs [?? ??] 0230 086d
                                                            ; W = v___data_49
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 0231 1703
                                                            ; W = v____device_put_19
                               movwf    v____device_put_21  ;  1 OV Rs Rs [?? ??] 0232 00a4
                                                            ; W = v____device_put_19
                               datahi_clr v____device_put_19;  1 OV Rs rs [?? ??] 0233 1303
                                                            ; W = v____device_put_21
                               movf     v____device_put_19+1,w;  1 OV rs rs [?? ??] 0234 086e
                                                            ; W = v____device_put_21
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 0235 1703
                                                            ; W = v____device_put_19
                               movwf    v____device_put_21+1;  1 OV Rs Rs [?? ??] 0236 00a5
                                                            ; W = v____device_put_19
                               movf     v___data_49,w       ;  1 OV Rs Rs [?? ??] 0237 0822
                                                            ; W = v____device_put_21
                               movwf    v___data_53         ;  1 OV Rs Rs [?? ??] 0238 00a8
                                                            ; W = v___data_49
                               clrf     v___data_53+1       ;  1 OV Rs Rs [?? ??] 0239 01a9
                                                            ; W = v___data_53
                               clrf     v___data_53+2       ;  1 OV Rs Rs [?? ??] 023a 01aa
                                                            ; W = v___data_53
                               clrf     v___data_53+3       ;  1 OV Rs Rs [?? ??] 023b 01ab
                                                            ; W = v___data_53
                               movlw    100                 ;  1 OV Rs Rs [?? ??] 023c 3064
                                                            ; W = v___data_53
                               movwf    v___digit_divisor_5 ;  1 OV Rs Rs [?? ??] 023d 00ae
                               clrf     v___digit_divisor_5+1;  1 OV Rs Rs [?? ??] 023e 01af
                                                            ; W = v___digit_divisor_5
                               clrf     v___digit_divisor_5+2;  1 OV Rs Rs [?? ??] 023f 01b0
                                                            ; W = v___digit_divisor_5
                               clrf     v___digit_divisor_5+3;  1 OV Rs Rs [?? ??] 0240 01b1
                                                            ; W = v___digit_divisor_5
                               movlw    3                   ;  1 OV Rs Rs [?? ??] 0241 3003
                                                            ; W = v___digit_divisor_5
                               goto     l__print_universal_dec;  1 OV Rs Rs [?? ??] 0242 2a43
;  277 end procedure
;  294 procedure _print_universal_dec(volatile byte out device, dword in data, sdword in digit_divisor, byte in digit_number) is
l__print_universal_dec
                               movwf    v___digit_number_5  ;  1 OV Rs Rs [?? ??] 0243 00b2
;  298    if (data == 0) then
                               movf     v___data_53,w       ;  1 OV Rs Rs [?? ??] 0244 0828
                                                            ; W = v___digit_number_5
                               iorwf    v___data_53+1,w     ;  1 OV Rs Rs [?? ??] 0245 0429
                                                            ; W = v___data_53
                               iorwf    v___data_53+2,w     ;  1 OV Rs Rs [?? ??] 0246 042a
                               iorwf    v___data_53+3,w     ;  1 OV Rs Rs [?? ??] 0247 042b
                               btfss    v__status, v__z     ;  1 OV Rs Rs [?? ??] 0248 1d03
                               goto     l__l319             ;  1 OV Rs Rs [?? ??] 0249 2a54
;  299       device = "0"      
                               movlw    48                  ;  1 OV Rs Rs [?? ??] 024a 3030
                               datahi_clr v__pic_temp       ;  1 OV Rs rs [?? ??] 024b 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 024c 00a0
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 024d 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_21,w;  1 OV Rs Rs [?? ??] 024e 0824
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  1 OV Rs rs [?? ??] 024f 1303
                                                            ; W = v____device_put_21
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0250 00b4
                                                            ; W = v____device_put_21
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 0251 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_21+1,w;  1 OV Rs Rs [?? ??] 0252 0825
                                                            ; W = v__pic_pointer
                               goto     l__pic_indirect     ;  1 OV Rs Rs [?? ??] 0253 28bd
                                                            ; W = v____device_put_21
;  300       return
;  301    end if
l__l319
;  303    no_digits_printed_yet = true
                               bsf      v____bitbucket_42, 0 ; no_digits_printed_yet;  1 OV Rs Rs [?? ??] 0254 1435
;  304    while (digit_divisor > 0) loop
l__l320
                               movf     v___digit_divisor_5+3,w;  1 OV Rs Rs [?? ??] 0255 0831
                                                            ; W = v_digit
                               xorlw    128                 ;  1 OV Rs Rs [?? ??] 0256 3a80
                                                            ; W = v___digit_divisor_5
                               datahi_clr v__pic_temp       ;  1 OV Rs rs [?? ??] 0257 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0258 00a0
                               movlw    128                 ;  1 OV rs rs [?? ??] 0259 3080
                                                            ; W = v__pic_temp
                               subwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 025a 0220
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 025b 1d03
                               goto     l__l555             ;  1 OV rs rs [?? ??] 025c 2a68
                               movlw    0                   ;  1 OV rs rs [?? ??] 025d 3000
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 025e 1703
                               subwf    v___digit_divisor_5+2,w;  1 OV Rs Rs [?? ??] 025f 0230
                               btfss    v__status, v__z     ;  1 OV Rs Rs [?? ??] 0260 1d03
                               goto     l__l555             ;  1 OV Rs Rs [?? ??] 0261 2a68
                               movlw    0                   ;  1 OV Rs Rs [?? ??] 0262 3000
                               subwf    v___digit_divisor_5+1,w;  1 OV Rs Rs [?? ??] 0263 022f
                               btfss    v__status, v__z     ;  1 OV Rs Rs [?? ??] 0264 1d03
                               goto     l__l555             ;  1 OV Rs Rs [?? ??] 0265 2a68
                               movlw    0                   ;  1 OV Rs Rs [?? ??] 0266 3000
                               subwf    v___digit_divisor_5,w;  1 OV Rs Rs [?? ??] 0267 022e
l__l555
                               btfsc    v__status, v__z     ;  1 OV ?s Rs [?? ??] 0268 1903
                               goto     l__l321             ;  1 OV ?s Rs [?? ??] 0269 2ae9
                               btfss    v__status, v__c     ;  1 OV ?s Rs [?? ??] 026a 1c03
                               goto     l__l321             ;  1 OV ?s Rs [?? ??] 026b 2ae9
;  305       digit = byte ( data / digit_divisor )
                               datahi_set v___digit_divisor_5;  1 OV ?s Rs [?? ??] 026c 1703
                               movf     v___digit_divisor_5,w;  1 OV Rs Rs [?? ??] 026d 082e
                               datahi_clr v__pic_divisor    ;  1 OV Rs rs [?? ??] 026e 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 026f 00a8
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 0270 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+1,w;  1 OV Rs Rs [?? ??] 0271 082f
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_divisor    ;  1 OV Rs rs [?? ??] 0272 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+1    ;  1 OV rs rs [?? ??] 0273 00a9
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 0274 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+2,w;  1 OV Rs Rs [?? ??] 0275 0830
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_divisor    ;  1 OV Rs rs [?? ??] 0276 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+2    ;  1 OV rs rs [?? ??] 0277 00aa
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 0278 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+3,w;  1 OV Rs Rs [?? ??] 0279 0831
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_divisor    ;  1 OV Rs rs [?? ??] 027a 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+3    ;  1 OV rs rs [?? ??] 027b 00ab
                                                            ; W = v___digit_divisor_5
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 027c 1703
                                                            ; W = v__pic_divisor
                               movf     v___data_53,w       ;  1 OV Rs Rs [?? ??] 027d 0828
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 027e 1303
                                                            ; W = v___data_53
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 027f 00a0
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 0280 1703
                                                            ; W = v__pic_dividend
                               movf     v___data_53+1,w     ;  1 OV Rs Rs [?? ??] 0281 0829
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 0282 1303
                                                            ; W = v___data_53
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 0283 00a1
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 0284 1703
                                                            ; W = v__pic_dividend
                               movf     v___data_53+2,w     ;  1 OV Rs Rs [?? ??] 0285 082a
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 0286 1303
                                                            ; W = v___data_53
                               movwf    v__pic_dividend+2   ;  1 OV rs rs [?? ??] 0287 00a2
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 0288 1703
                                                            ; W = v__pic_dividend
                               movf     v___data_53+3,w     ;  1 OV Rs Rs [?? ??] 0289 082b
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 028a 1303
                                                            ; W = v___data_53
                               movwf    v__pic_dividend+3   ;  1 OV rs rs [?? ??] 028b 00a3
                                                            ; W = v___data_53
                               call     l__pic_divide       ;  1 OV rs ?? [?? ??] 028c 206b
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 028d 1283
                               datahi_clr v__pic_quotient   ;  1 OV ?s rs [?? ??] 028e 1303
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 028f 082c
                               datahi_set v_digit           ;  1 OV rs Rs [?? ??] 0290 1703
                                                            ; W = v__pic_quotient
                               movwf    v_digit             ;  1 OV Rs Rs [?? ??] 0291 00b3
                                                            ; W = v__pic_quotient
;  306       data = data % digit_divisor
                               datahi_clr v__pic_remainder  ;  1 OV Rs rs [?? ??] 0292 1303
                                                            ; W = v_digit
                               movf     v__pic_remainder,w  ;  1 OV rs rs [?? ??] 0293 0824
                                                            ; W = v_digit
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 0294 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_53         ;  1 OV Rs Rs [?? ??] 0295 00a8
                                                            ; W = v__pic_remainder
                               datahi_clr v__pic_remainder  ;  1 OV Rs rs [?? ??] 0296 1303
                                                            ; W = v___data_53
                               movf     v__pic_remainder+1,w;  1 OV rs rs [?? ??] 0297 0825
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 0298 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_53+1       ;  1 OV Rs Rs [?? ??] 0299 00a9
                                                            ; W = v__pic_remainder
                               datahi_clr v__pic_remainder  ;  1 OV Rs rs [?? ??] 029a 1303
                                                            ; W = v___data_53
                               movf     v__pic_remainder+2,w;  1 OV rs rs [?? ??] 029b 0826
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 029c 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_53+2       ;  1 OV Rs Rs [?? ??] 029d 00aa
                                                            ; W = v__pic_remainder
                               datahi_clr v__pic_remainder  ;  1 OV Rs rs [?? ??] 029e 1303
                                                            ; W = v___data_53
                               movf     v__pic_remainder+3,w;  1 OV rs rs [?? ??] 029f 0827
                                                            ; W = v___data_53
                               datahi_set v___data_53       ;  1 OV rs Rs [?? ??] 02a0 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_53+3       ;  1 OV Rs Rs [?? ??] 02a1 00ab
                                                            ; W = v__pic_remainder
;  307       digit_divisor = digit_divisor / 10
                               movlw    10                  ;  1 OV Rs Rs [?? ??] 02a2 300a
                                                            ; W = v___data_53
                               datahi_clr v__pic_divisor    ;  1 OV Rs rs [?? ??] 02a3 1303
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 02a4 00a8
                               clrf     v__pic_divisor+1    ;  1 OV rs rs [?? ??] 02a5 01a9
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+2    ;  1 OV rs rs [?? ??] 02a6 01aa
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+3    ;  1 OV rs rs [?? ??] 02a7 01ab
                                                            ; W = v__pic_divisor
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02a8 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5,w;  1 OV Rs Rs [?? ??] 02a9 082e
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 02aa 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 02ab 00a0
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02ac 1703
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+1,w;  1 OV Rs Rs [?? ??] 02ad 082f
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 02ae 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 02af 00a1
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02b0 1703
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+2,w;  1 OV Rs Rs [?? ??] 02b1 0830
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 02b2 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+2   ;  1 OV rs rs [?? ??] 02b3 00a2
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02b4 1703
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+3,w;  1 OV Rs Rs [?? ??] 02b5 0831
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  1 OV Rs rs [?? ??] 02b6 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+3   ;  1 OV rs rs [?? ??] 02b7 00a3
                                                            ; W = v___digit_divisor_5
                               call     l__pic_sdivide      ;  1 OV rs ?? [?? ??] 02b8 204a
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 02b9 1283
                               datahi_clr v__pic_quotient   ;  1 OV ?s rs [?? ??] 02ba 1303
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 02bb 082c
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02bc 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5 ;  1 OV Rs Rs [?? ??] 02bd 00ae
                                                            ; W = v__pic_quotient
                               datahi_clr v__pic_quotient   ;  1 OV Rs rs [?? ??] 02be 1303
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+1,w ;  1 OV rs rs [?? ??] 02bf 082d
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02c0 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+1;  1 OV Rs Rs [?? ??] 02c1 00af
                                                            ; W = v__pic_quotient
                               datahi_clr v__pic_quotient   ;  1 OV Rs rs [?? ??] 02c2 1303
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+2,w ;  1 OV rs rs [?? ??] 02c3 082e
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02c4 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+2;  1 OV Rs Rs [?? ??] 02c5 00b0
                                                            ; W = v__pic_quotient
                               datahi_clr v__pic_quotient   ;  1 OV Rs rs [?? ??] 02c6 1303
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+3,w ;  1 OV rs rs [?? ??] 02c7 082f
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  1 OV rs Rs [?? ??] 02c8 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+3;  1 OV Rs Rs [?? ??] 02c9 00b1
                                                            ; W = v__pic_quotient
;  309       if ((digit != 0) | (no_digits_printed_yet == false)) then
                               movf     v_digit,w           ;  1 OV Rs Rs [?? ??] 02ca 0833
                                                            ; W = v___digit_divisor_5
                               bsf      v____bitbucket_42, 3 ; _btemp47;  1 OV Rs Rs [?? ??] 02cb 15b5
                                                            ; W = v_digit
                               btfsc    v__status, v__z     ;  1 OV Rs Rs [?? ??] 02cc 1903
                                                            ; W = v_digit
                               bcf      v____bitbucket_42, 3 ; _btemp47;  1 OV Rs Rs [?? ??] 02cd 11b5
                                                            ; W = v_digit
                               bcf      v____bitbucket_42, 4 ; _btemp48;  1 OV Rs Rs [?? ??] 02ce 1235
                                                            ; W = v_digit
                               btfss    v____bitbucket_42, 0 ; no_digits_printed_yet;  1 OV Rs Rs [?? ??] 02cf 1c35
                                                            ; W = v_digit
                               bsf      v____bitbucket_42, 4 ; _btemp48;  1 OV Rs Rs [?? ??] 02d0 1635
                                                            ; W = v_digit
                               bcf      v____bitbucket_42, 5 ; _btemp49;  1 OV Rs Rs [?? ??] 02d1 12b5
                                                            ; W = v_digit
                               btfss    v____bitbucket_42, 3 ; _btemp47;  1 OV Rs Rs [?? ??] 02d2 1db5
                                                            ; W = v_digit
                               btfsc    v____bitbucket_42, 4 ; _btemp48;  1 OV Rs Rs [?? ??] 02d3 1a35
                                                            ; W = v_digit
                               bsf      v____bitbucket_42, 5 ; _btemp49;  1 OV Rs Rs [?? ??] 02d4 16b5
                                                            ; W = v_digit
                               btfss    v____bitbucket_42, 5 ; _btemp49;  1 OV Rs Rs [?? ??] 02d5 1eb5
                                                            ; W = v_digit
                               goto     l__l324             ;  1 OV Rs Rs [?? ??] 02d6 2ae7
                                                            ; W = v_digit
;  310          device = digit | "0"
                               movlw    48                  ;  1 OV Rs Rs [?? ??] 02d7 3030
                               iorwf    v_digit,w           ;  1 OV Rs Rs [?? ??] 02d8 0433
                               movwf    v____temp_42        ;  1 OV Rs Rs [?? ??] 02d9 00b4
                               movf     v____temp_42,w      ;  1 OV Rs Rs [?? ??] 02da 0834
                                                            ; W = v____temp_42
                               datahi_clr v__pic_temp       ;  1 OV Rs rs [?? ??] 02db 1303
                                                            ; W = v____temp_42
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 02dc 00a0
                                                            ; W = v____temp_42
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 02dd 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_21,w;  1 OV Rs Rs [?? ??] 02de 0824
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  1 OV Rs rs [?? ??] 02df 1303
                                                            ; W = v____device_put_21
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 02e0 00b4
                                                            ; W = v____device_put_21
                               datahi_set v____device_put_21;  1 OV rs Rs [?? ??] 02e1 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_21+1,w;  1 OV Rs Rs [?? ??] 02e2 0825
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV Rs ?? [?? ??] 02e3 20bd
                                                            ; W = v____device_put_21
;  311          no_digits_printed_yet = false
                               datalo_clr v____bitbucket_42 ; no_digits_printed_yet;  1 OV ?? ?s [?? ??] 02e4 1283
                               datahi_set v____bitbucket_42 ; no_digits_printed_yet;  1 OV ?s Rs [?? ??] 02e5 1703
                               bcf      v____bitbucket_42, 0 ; no_digits_printed_yet;  1 OV Rs Rs [?? ??] 02e6 1035
;  312       end if
l__l324
;  313       digit_number = digit_number - 1
                               decf     v___digit_number_5,f;  1 OV Rs Rs [?? ??] 02e7 03b2
                                                            ; W = v_digit
;  314    end loop
                               goto     l__l320             ;  1 OV Rs Rs [?? ??] 02e8 2a55
                                                            ; W = v_digit
l__l321
;  316 end procedure
l__l239
                               return                       ;  1 OV ?s Rs [?? ??] 02e9 0008
; delay.jal
;  113 procedure delay_1ms(word in n) is
l_delay_1ms
;  115    for n loop
                               datahi_set v__floop4         ;  1 OV rs Rs [?? ??] 02ea 1703
                                                            ; W = v___n_3
                               clrf     v__floop4           ;  1 OV Rs Rs [?? ??] 02eb 01a2
                                                            ; W = v___n_3
                               clrf     v__floop4+1         ;  1 OV Rs Rs [?? ??] 02ec 01a3
                                                            ; W = v___n_3
                               goto     l__l359             ;  1 OV Rs Rs [?? ??] 02ed 2b00
                                                            ; W = v___n_3
l__l358
;  117          _usec_delay(_one_ms_delay)
                               datalo_clr v__pic_temp       ;  1 -V rs rs [?? ??] 02ee 1283
                               datahi_clr v__pic_temp       ;  1 -V rs rs [?? ??] 02ef 1303
                               movlw    35                  ;  1 -V rs rs [?? ??] 02f0 3023
                               movwf    v__pic_temp         ;  1 -V rs rs [?? ??] 02f1 00a0
l__l559
                               movlw    13                  ;  1 -V rs rs [?? ??] 02f2 300d
                               movwf    v__pic_temp+1       ;  1 -V rs rs [?? ??] 02f3 00a1
l__l560
                               branchhi_clr l__l560         ;  1 -V rs rs [?? h?] 02f4 120a
                               branchlo_clr l__l560         ;  1 -V rs rs [h? hl] 02f5 118a
                               decfsz   v__pic_temp+1,f     ;  1 -V rs rs [hl hl] 02f6 0ba1
                               goto     l__l560             ;  1 -V rs rs [hl hl] 02f7 2af4
                               branchhi_clr l__l559         ;  1 -V rs rs [hl hl] 02f8 120a
                               branchlo_clr l__l559         ;  1 -V rs rs [hl hl] 02f9 118a
                               decfsz   v__pic_temp,f       ;  1 -V rs rs [hl hl] 02fa 0ba0
                               goto     l__l559             ;  1 -V rs rs [hl hl] 02fb 2af2
;  121    end loop
                               datahi_set v__floop4         ;  1 OV rs Rs [hl hl] 02fc 1703
                                                            ; W = v__pic_temp
                               incf     v__floop4,f         ;  1 OV Rs Rs [hl hl] 02fd 0aa2
                                                            ; W = v__pic_temp
                               btfsc    v__status, v__z     ;  1 OV Rs Rs [hl hl] 02fe 1903
                                                            ; W = v__pic_temp
                               incf     v__floop4+1,f       ;  1 OV Rs Rs [hl hl] 02ff 0aa3
                                                            ; W = v__pic_temp
l__l359
                               movf     v__floop4,w         ;  1 OV Rs Rs [?? ??] 0300 0822
                                                            ; W = v___n_3
                               datahi_clr v___n_3           ;  1 OV Rs rs [?? ??] 0301 1303
                                                            ; W = v__floop4
                               subwf    v___n_3,w           ;  1 OV rs rs [?? ??] 0302 026d
                                                            ; W = v__floop4
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0303 00a0
                               datahi_set v__floop4         ;  1 OV rs Rs [?? ??] 0304 1703
                                                            ; W = v__pic_temp
                               movf     v__floop4+1,w       ;  1 OV Rs Rs [?? ??] 0305 0823
                                                            ; W = v__pic_temp
                               datahi_clr v___n_3           ;  1 OV Rs rs [?? ??] 0306 1303
                                                            ; W = v__floop4
                               subwf    v___n_3+1,w         ;  1 OV rs rs [?? ??] 0307 026e
                                                            ; W = v__floop4
                               iorwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 0308 0420
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 0309 1d03
                               goto     l__l358             ;  1 OV rs rs [?? ??] 030a 2aee
;  122 end procedure
                               return                       ;  1 OV rs rs [?? ??] 030b 0008
                                                            ; W = v__pic_temp
;  138 end procedure
l__l368
; gps_converter.jal
;   16 var byte GpsErrorCode = 1  ; errorcode 1 = startup (wait for $).
                               movlw    1                   ;  0 OV ?? ?? [?? ??] 030c 3001
                               datalo_clr v_gpserrorcode    ;  0 OV ?? ?s [?? ??] 030d 1283
                               datahi_clr v_gpserrorcode    ;  0 OV ?s rs [?? ??] 030e 1303
                               movwf    v_gpserrorcode      ;  0 OV rs rs [?? ??] 030f 00e8
;   22 procedure DumpGpsInBuffer is      
                               goto     l__l405             ;  0 OV rs rs [?? ??] 0310 2baa
                                                            ; W = v_gpserrorcode
;   44 function StoreBytes (byte in char) return bit is
l_storebytes
                               movwf    v___char_5          ;  1 OV rs rs [?? ??] 0311 00ed
                                                            ; W = v___char_7
;   47    if (char == ",") then
                               movlw    44                  ;  1 OV rs rs [?? ??] 0312 302c
                                                            ; W = v___char_5
                               subwf    v___char_5,w        ;  1 OV rs rs [?? ??] 0313 026d
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 0314 1d03
                               goto     l__l381             ;  1 OV rs rs [?? ??] 0315 2b18
;   48       return true
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 0316 1420
                               return                       ;  1 OV rs rs [?? ??] 0317 0008
;   49    end if
l__l381
;   51    if (GpsInBufferIndex >= (IN_BUF_SIZE-1)) then
                               movlw    19                  ;  1 OV rs rs [?? ??] 0318 3013
                               subwf    v_gpsinbufferindex,w;  1 OV rs rs [?? ??] 0319 0266
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 031a 1903
                               goto     l__l562             ;  1 OV rs rs [?? ??] 031b 2b1e
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 031c 1c03
                                                            ; W = v_gpserrorcode
                               goto     l__l383             ;  1 OV rs rs [?? ??] 031d 2b21
                                                            ; W = v_gpserrorcode
l__l562
;   53       GpsErrorCode = 201
                               movlw    201                 ;  1 OV rs rs [?? ??] 031e 30c9
                               movwf    v_gpserrorcode      ;  1 OV rs rs [?? ??] 031f 00e8
;   54       return;
                               return                       ;  1 OV rs rs [?? ??] 0320 0008
                                                            ; W = v_gpserrorcode
;   55    end if
l__l383
;   57    GpsInBuffer[GpsInBufferIndex] = char
                               movlw    v_gpsinbuffer       ;  1 OV rs rs [?? ??] 0321 3052
                                                            ; W = v_gpserrorcode
                               addwf    v_gpsinbufferindex,w;  1 OV rs rs [?? ??] 0322 0766
                               movwf    v__fsr              ;  1 OV rs rs [?? ??] 0323 0084
                               irp_clr                      ;  1 OV rs rs [?? ??] 0324 1383
                               movf     v___char_5,w        ;  1 OV rs rs [?? ??] 0325 086d
                               movwf    v__ind              ;  1 OV rs rs [?? ??] 0326 0080
                                                            ; W = v___char_5
;   58    GpsInBufferIndex = GpsInBufferIndex + 1
                               incf     v_gpsinbufferindex,f;  1 OV rs rs [?? ??] 0327 0ae6
;   59    GpsInBuffer[GpsInBufferIndex] = 0 ; iedere keer de afsluit-0 plaatsen.
                               movlw    v_gpsinbuffer       ;  1 OV rs rs [?? ??] 0328 3052
                               addwf    v_gpsinbufferindex,w;  1 OV rs rs [?? ??] 0329 0766
                               movwf    v__fsr              ;  1 OV rs rs [?? ??] 032a 0084
                               irp_clr                      ;  1 OV rs rs [?? ??] 032b 1383
                               clrf     v__ind              ;  1 OV rs rs [?? ??] 032c 0180
;   61    return false ; not done yet.
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 032d 1020
;   62 end function
l__l379
                               return                       ;  1 OV rs rs [?? ??] 032e 0008
                                                            ; W = v_gpserrorcode
;   64 function IsMsg(byte in name[]) return bit is
l_ismsg
;   67    for 5 using i loop       
                               clrf     v___i_2             ;  2 OV Rs Rs [?? ??] 032f 01a4
                                                            ; W = v___name_1
l__l386
;   73       if (name[i] != GpsInBuffer[i]) then return false end if
                               movf     v___name_1+1,w      ;  2 OV Rs Rs [?? ??] 0330 0821
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?? ??] 0331 1303
                                                            ; W = v___name_1
                               movwf    v__pic_pointer+1    ;  2 OV rs rs [?? ??] 0332 00b5
                                                            ; W = v___name_1
                               datahi_set v___i_2           ;  2 OV rs Rs [?? ??] 0333 1703
                                                            ; W = v__pic_pointer
                               movf     v___i_2,w           ;  2 OV Rs Rs [?? ??] 0334 0824
                                                            ; W = v__pic_pointer
                               addwf    v___name_1,w        ;  2 OV Rs Rs [?? ??] 0335 0720
                                                            ; W = v___i_2
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?? ??] 0336 1303
                               movwf    v__pic_pointer      ;  2 OV rs rs [?? ??] 0337 00b4
                               btfsc    v__status, v__c     ;  2 OV rs rs [?? ??] 0338 1803
                                                            ; W = v__pic_pointer
                               incf     v__pic_pointer+1,f  ;  2 OV rs rs [?? ??] 0339 0ab5
                                                            ; W = v__pic_pointer
                               bcf      v__pic_pointer+1, 6 ;  2 OV rs rs [?? ??] 033a 1335
                               movf     v__pic_pointer+1,w  ;  2 OV rs rs [?? ??] 033b 0835
                               call     l__pic_indirect     ;  2 OV rs ?? [?? ??] 033c 20bd
                                                            ; W = v__pic_pointer
                               datalo_clr v__pic_temp       ;  2 OV ?? ?s [?? ??] 033d 1283
                               datahi_clr v__pic_temp       ;  2 OV ?s rs [?? ??] 033e 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 033f 00a0
                               movlw    v_gpsinbuffer       ;  2 OV rs rs [?? ??] 0340 3052
                                                            ; W = v__pic_temp
                               datahi_set v___i_2           ;  2 OV rs Rs [?? ??] 0341 1703
                               addwf    v___i_2,w           ;  2 OV Rs Rs [?? ??] 0342 0724
                               movwf    v__fsr              ;  2 OV Rs Rs [?? ??] 0343 0084
                               irp_clr                      ;  2 OV Rs Rs [?? ??] 0344 1383
                               datahi_clr v__pic_temp       ;  2 OV Rs rs [?? ??] 0345 1303
                               movf     v__pic_temp,w       ;  2 OV rs rs [?? ??] 0346 0820
                               subwf    v__ind,w            ;  2 OV rs rs [?? ??] 0347 0200
                                                            ; W = v__pic_temp
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0348 1903
                               goto     l__l390             ;  2 OV rs rs [?? ??] 0349 2b4c
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  2 OV rs rs [?? ??] 034a 1020
                                                            ; W = v___name_1
                               return                       ;  2 OV rs rs [?? ??] 034b 0008
                                                            ; W = v___name_1
l__l390
;   74    end loop
                               datahi_set v___i_2           ;  2 OV rs Rs [?? ??] 034c 1703
                               incf     v___i_2,f           ;  2 OV Rs Rs [?? ??] 034d 0aa4
                               movlw    5                   ;  2 OV Rs Rs [?? ??] 034e 3005
                               subwf    v___i_2,w           ;  2 OV Rs Rs [?? ??] 034f 0224
                               btfss    v__status, v__z     ;  2 OV Rs Rs [?? ??] 0350 1d03
                               goto     l__l386             ;  2 OV Rs Rs [?? ??] 0351 2b30
;   78    return true
                               datahi_clr v__pic_temp ; _pic_temp    ;  2 OV Rs rs [?? ??] 0352 1303
                                                            ; W = v___name_1
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  2 OV rs rs [?? ??] 0353 1420
                                                            ; W = v___name_1
;   79 end function
l__l385
                               return                       ;  2 OV rs rs [?? ??] 0354 0008
                                                            ; W = v___name_1
;   88 function ParseMessageID() return byte is
l_parsemessageid
;   89    if (IsMsg(str_gpgga)) then return 1 end if
                               movlw    l__data_str_gpgga   ;  1 OV rs rs [?? ??] 0355 3028
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 0356 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 0357 00a0
                               movlw    HIGH l__data_str_gpgga;  1 OV Rs Rs [?? ??] 0358 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 0359 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 035a 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 035b 232f
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp61;  1 OV ?? ?s [?? ??] 035c 1283
                               datahi_clr v____bitbucket_4 ; _btemp61;  1 OV ?s rs [?? ??] 035d 1303
                               bcf      v____bitbucket_4, 0 ; _btemp61;  1 OV rs rs [?? ??] 035e 106d
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 035f 1820
                               bsf      v____bitbucket_4, 0 ; _btemp61;  1 OV rs rs [?? ??] 0360 146d
                               btfsc    v____bitbucket_4, 0 ; _btemp61;  1 OV rs rs [?? ??] 0361 186d
                               retlw    1                   ;  1 OV rs rs [?? ??] 0362 3401
l__l394
;   90    if (IsMsg(str_gpgll)) then return 2 end if
                               movlw    l__data_str_gpgll   ;  1 OV rs rs [?? ??] 0363 303a
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 0364 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 0365 00a0
                               movlw    HIGH l__data_str_gpgll;  1 OV Rs Rs [?? ??] 0366 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 0367 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 0368 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 0369 232f
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp62;  1 OV ?? ?s [?? ??] 036a 1283
                               datahi_clr v____bitbucket_4 ; _btemp62;  1 OV ?s rs [?? ??] 036b 1303
                               bcf      v____bitbucket_4, 1 ; _btemp62;  1 OV rs rs [?? ??] 036c 10ed
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 036d 1820
                               bsf      v____bitbucket_4, 1 ; _btemp62;  1 OV rs rs [?? ??] 036e 14ed
                               btfsc    v____bitbucket_4, 1 ; _btemp62;  1 OV rs rs [?? ??] 036f 18ed
                               retlw    2                   ;  1 OV rs rs [?? ??] 0370 3402
l__l396
;   91    if (IsMsg(str_gpgsa)) then return 3 end if
                               movlw    l__data_str_gpgsa   ;  1 OV rs rs [?? ??] 0371 3034
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 0372 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 0373 00a0
                               movlw    HIGH l__data_str_gpgsa;  1 OV Rs Rs [?? ??] 0374 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 0375 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 0376 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 0377 232f
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp63;  1 OV ?? ?s [?? ??] 0378 1283
                               datahi_clr v____bitbucket_4 ; _btemp63;  1 OV ?s rs [?? ??] 0379 1303
                               bcf      v____bitbucket_4, 2 ; _btemp63;  1 OV rs rs [?? ??] 037a 116d
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 037b 1820
                               bsf      v____bitbucket_4, 2 ; _btemp63;  1 OV rs rs [?? ??] 037c 156d
                               btfsc    v____bitbucket_4, 2 ; _btemp63;  1 OV rs rs [?? ??] 037d 196d
                               retlw    3                   ;  1 OV rs rs [?? ??] 037e 3403
l__l398
;   92    if (IsMsg(str_gpgsv)) then return 4 end if
                               movlw    l__data_str_gpgsv   ;  1 OV rs rs [?? ??] 037f 3022
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 0380 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 0381 00a0
                               movlw    HIGH l__data_str_gpgsv;  1 OV Rs Rs [?? ??] 0382 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 0383 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 0384 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 0385 232f
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp64;  1 OV ?? ?s [?? ??] 0386 1283
                               datahi_clr v____bitbucket_4 ; _btemp64;  1 OV ?s rs [?? ??] 0387 1303
                               bcf      v____bitbucket_4, 3 ; _btemp64;  1 OV rs rs [?? ??] 0388 11ed
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 0389 1820
                               bsf      v____bitbucket_4, 3 ; _btemp64;  1 OV rs rs [?? ??] 038a 15ed
                               btfsc    v____bitbucket_4, 3 ; _btemp64;  1 OV rs rs [?? ??] 038b 19ed
                               retlw    4                   ;  1 OV rs rs [?? ??] 038c 3404
l__l400
;   93    if (IsMsg(str_gprmc)) then return 5 end if
                               movlw    l__data_str_gprmc   ;  1 OV rs rs [?? ??] 038d 3040
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 038e 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 038f 00a0
                               movlw    HIGH l__data_str_gprmc;  1 OV Rs Rs [?? ??] 0390 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 0391 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 0392 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 0393 232f
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp65;  1 OV ?? ?s [?? ??] 0394 1283
                               datahi_clr v____bitbucket_4 ; _btemp65;  1 OV ?s rs [?? ??] 0395 1303
                               bcf      v____bitbucket_4, 4 ; _btemp65;  1 OV rs rs [?? ??] 0396 126d
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 0397 1820
                               bsf      v____bitbucket_4, 4 ; _btemp65;  1 OV rs rs [?? ??] 0398 166d
                               btfsc    v____bitbucket_4, 4 ; _btemp65;  1 OV rs rs [?? ??] 0399 1a6d
                               retlw    5                   ;  1 OV rs rs [?? ??] 039a 3405
l__l402
;   94    if (IsMsg(str_gpvtg)) then return 6 end if
                               movlw    l__data_str_gpvtg   ;  1 OV rs rs [?? ??] 039b 302e
                               datahi_set v___name_1        ;  1 OV rs Rs [?? ??] 039c 1703
                               movwf    v___name_1          ;  1 OV Rs Rs [?? ??] 039d 00a0
                               movlw    HIGH l__data_str_gpvtg;  1 OV Rs Rs [?? ??] 039e 3000
                                                            ; W = v___name_1
                               iorlw    64                  ;  1 OV Rs Rs [?? ??] 039f 3840
                               movwf    v___name_1+1        ;  1 OV Rs Rs [?? ??] 03a0 00a1
                               call     l_ismsg             ;  1 OV Rs ?? [?? ??] 03a1 232f
                                                            ; W = v___name_1
                               datalo_clr v____bitbucket_4 ; _btemp66;  1 OV ?? ?s [?? ??] 03a2 1283
                               datahi_clr v____bitbucket_4 ; _btemp66;  1 OV ?s rs [?? ??] 03a3 1303
                               bcf      v____bitbucket_4, 5 ; _btemp66;  1 OV rs rs [?? ??] 03a4 12ed
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 03a5 1820
                               bsf      v____bitbucket_4, 5 ; _btemp66;  1 OV rs rs [?? ??] 03a6 16ed
                               btfsc    v____bitbucket_4, 5 ; _btemp66;  1 OV rs rs [?? ??] 03a7 1aed
                               retlw    6                   ;  1 OV rs rs [?? ??] 03a8 3406
l__l404
;   96    return 0 ; unknown message
                               retlw    0                   ;  1 OV rs rs [?? ??] 03a9 3400
;   97 end function
l__l392
;  164 end procedure                             
l__l405
; jallib.jal
;   70 T2CON_TOUTPS = 0b00                       -- postscaler 1:1
                               movlw    135                 ;  0 OV rs rs [?? ??] 03aa 3087
                                                            ; W = v_gpserrorcode
                               andwf    v_t2con,f           ;  0 OV rs rs [?? ??] 03ab 0592
;   71 T2CON_T2CKPS = 0b00                       -- prescaler 1:1
                               movlw    252                 ;  0 OV rs rs [?? ??] 03ac 30fc
                               andwf    v_t2con,f           ;  0 OV rs rs [?? ??] 03ad 0592
;   72 T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on       ;  0 OV rs rs [?? ??] 03ae 1512
;   73 PR2 = 249   -- count from 0 to 249 and skip back to 0 = 250 steps
                               movlw    249                 ;  0 OV rs rs [?? ??] 03af 30f9
                               datalo_set v_pr2             ;  0 OV rs rS [?? ??] 03b0 1683
                               movwf    v_pr2               ;  0 OV rS rS [?? ??] 03b1 0092
;   75 ccp1con_p1m = 0  -- alleen output op pin P1A
                               movlw    63                  ;  0 OV rS rS [?? ??] 03b2 303f
                               datalo_clr v_ccp1con         ;  0 OV rS rs [?? ??] 03b3 1283
                               andwf    v_ccp1con,f         ;  0 OV rs rs [?? ??] 03b4 0597
;   76 ccp1con_ccp1m = 0b1100  -- pwm mode
                               movlw    240                 ;  0 OV rs rs [?? ??] 03b5 30f0
                               andwf    v_ccp1con,w         ;  0 OV rs rs [?? ??] 03b6 0517
                               iorlw    12                  ;  0 OV rs rs [?? ??] 03b7 380c
                               movwf    v_ccp1con           ;  0 OV rs rs [?? ??] 03b8 0097
;   77 pin_c5_direction = output
                               datalo_set v_trisc ; pin_c5_direction        ;  0 OV rs rS [?? ??] 03b9 1683
                                                            ; W = v_ccp1con
                               bcf      v_trisc, 5 ; pin_c5_direction       ;  0 OV rS rS [?? ??] 03ba 1287
                                                            ; W = v_ccp1con
;   79 PIE1_TMR2IE = true
                               bsf      v_pie1, 1 ; pie1_tmr2ie        ;  0 OV rS rS [?? ??] 03bb 148c
                                                            ; W = v_ccp1con
;   80 INTCON_GIE = true
                               bsf      v_intcon, 7 ; intcon_gie      ;  0 OV rS rS [?? ??] 03bc 178b
                                                            ; W = v_ccp1con
;   81 INTCON_PEIE = true
                               bsf      v_intcon, 6 ; intcon_peie      ;  0 OV rS rS [?? ??] 03bd 170b
                                                            ; W = v_ccp1con
;   83 var volatile word Ticks = 0   
                               datalo_clr v_ticks           ;  0 OV rS rs [?? ??] 03be 1283
                                                            ; W = v_ccp1con
                               clrf     v_ticks             ;  0 OV rs rs [?? ??] 03bf 01b7
                                                            ; W = v_ccp1con
                               clrf     v_ticks+1           ;  0 OV rs rs [?? ??] 03c0 01b8
                                                            ; W = v_ccp1con
;   87 print_string(serial_hw_data, str1)      
                               movlw    l__serial_hw_data_put;  0 OV rs rs [?? ??] 03c1 30e5
                                                            ; W = v_ccp1con
                               movwf    v____device_put_1   ;  0 OV rs rs [?? ??] 03c2 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 03c3 3001
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  0 OV rs rs [?? ??] 03c4 00ee
                               movlw    10                  ;  0 OV rs rs [?? ??] 03c5 300a
                                                            ; W = v____device_put_1
                               datahi_set v__str_count      ;  0 OV rs Rs [?? ??] 03c6 1703
                               movwf    v__str_count        ;  0 OV Rs Rs [?? ??] 03c7 00a2
                               clrf     v__str_count+1      ;  0 OV Rs Rs [?? ??] 03c8 01a3
                                                            ; W = v__str_count
                               movlw    l__data_str1_2      ;  0 OV Rs Rs [?? ??] 03c9 3010
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV Rs Rs [?? ??] 03ca 00a6
                               movlw    HIGH l__data_str1_2 ;  0 OV Rs Rs [?? ??] 03cb 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV Rs Rs [?? ??] 03cc 3840
                               movwf    v___str_1+1         ;  0 OV Rs Rs [?? ??] 03cd 00a7
                               call     l_print_string      ;  0 OV Rs ?? [?? ??] 03ce 2202
                                                            ; W = v___str_1
;   89 procedure SetDutyCycle (word in duty) is
                               goto     l__l429             ;  0 OV ?? ?? [?? ??] 03cf 2c0c
l_setdutycycle
;   91    if (duty > 999) then 
                               movlw    3                   ;  1 OV rs rs [?? ??] 03d0 3003
                                                            ; W = v___duty_1
                               subwf    v___duty_1+1,w      ;  1 OV rs rs [?? ??] 03d1 026e
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 03d2 1d03
                               goto     l__l563             ;  1 OV rs rs [?? ??] 03d3 2bd6
                               movlw    231                 ;  1 OV rs rs [?? ??] 03d4 30e7
                               subwf    v___duty_1,w        ;  1 OV rs rs [?? ??] 03d5 026d
l__l563
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 03d6 1903
                               goto     l__l428             ;  1 OV rs rs [?? ??] 03d7 2be1
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 03d8 1c03
                                                            ; W = v_ccp1con
                               goto     l__l428             ;  1 OV rs rs [?? ??] 03d9 2be1
                                                            ; W = v_ccp1con
;   92       duty = 999
                               movlw    231                 ;  1 OV rs rs [?? ??] 03da 30e7
                               movwf    v___duty_1          ;  1 OV rs rs [?? ??] 03db 00ed
                               movlw    3                   ;  1 OV rs rs [?? ??] 03dc 3003
                                                            ; W = v___duty_1
                               movwf    v___duty_1+1        ;  1 OV rs rs [?? ??] 03dd 00ee
;   93       serial_hw_data = "E"
                               movlw    69                  ;  1 OV rs rs [?? ??] 03de 3045
                                                            ; W = v___duty_1
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03df 00a0
                               call     l__serial_hw_data_put;  1 OV rs ?? [?? ??] 03e0 21e5
                                                            ; W = v__pic_temp
;   94    end if                
l__l428
;   96    ccpr1l = byte(duty >> 2)
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 03e1 1003
                                                            ; W = v_ccp1con
                               datalo_clr v___duty_1        ;  1 OV ?? ?s [?? ??] 03e2 1283
                                                            ; W = v_ccp1con
                               datahi_clr v___duty_1        ;  1 OV ?s rs [?? ??] 03e3 1303
                                                            ; W = v_ccp1con
                               rrf      v___duty_1+1,w      ;  1 OV rs rs [?? ??] 03e4 0c6e
                                                            ; W = v_ccp1con
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 03e5 00a1
                               rrf      v___duty_1,w        ;  1 OV rs rs [?? ??] 03e6 0c6d
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03e7 00a0
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 03e8 1003
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp+1,f     ;  1 OV rs rs [?? ??] 03e9 0ca1
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp,f       ;  1 OV rs rs [?? ??] 03ea 0ca0
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 03eb 0820
                               movwf    v_ccpr1l            ;  1 OV rs rs [?? ??] 03ec 0095
                                                            ; W = v__pic_temp
;   97    ccp1con_dc1b = byte(duty) & 0b11
                               movlw    3                   ;  1 OV rs rs [?? ??] 03ed 3003
                               andwf    v___duty_1,w        ;  1 OV rs rs [?? ??] 03ee 056d
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 03ef 00a0
                               swapf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 03f0 0e20
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 03f1 00a1
                               movlw    48                  ;  1 OV rs rs [?? ??] 03f2 3030
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp+1,f     ;  1 OV rs rs [?? ??] 03f3 05a1
                               movlw    207                 ;  1 OV rs rs [?? ??] 03f4 30cf
                               andwf    v_ccp1con,w         ;  1 OV rs rs [?? ??] 03f5 0517
                               iorwf    v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 03f6 0421
                               movwf    v_ccp1con           ;  1 OV rs rs [?? ??] 03f7 0097
;   99 end procedure
                               return                       ;  1 OV rs rs [?? ??] 03f8 0008
                                                            ; W = v_ccp1con
;  104 procedure isr is
l_isr
;  107    if (PIR1_TMR2IF) then
                               btfss    v_pir1, 1 ; pir1_tmr2if        ;  4 OV rs rs [hl hl] 03f9 1c8c
                                                            ; W = v__pic_isr_fsr
                               goto     l__serial_receive_interrupt_handler;  4 OV rs rs [hl hl] 03fa 2913
                                                            ; W = v__pic_isr_fsr
;  108       PIR1_TMR2IF = false
                               bcf      v_pir1, 1 ; pir1_tmr2if        ;  4 OV rs rs [hl hl] 03fb 108c
                                                            ; W = v___x_67
;  109       Ticks = Ticks + 1
                               incf     v_ticks,f           ;  4 OV rs rs [hl hl] 03fc 0ab7
                                                            ; W = v___x_67
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 03fd 1903
                                                            ; W = v___x_67
                               incf     v_ticks+1,f         ;  4 OV rs rs [hl hl] 03fe 0ab8
                                                            ; W = v___x_67
;  110       if (Ticks > 9999) then
                               movlw    39                  ;  4 OV rs rs [hl hl] 03ff 3027
                                                            ; W = v___x_67
                               subwf    v_ticks+1,w         ;  4 OV rs rs [hl hl] 0400 0238
                               btfss    v__status, v__z     ;  4 OV rs rs [hl hl] 0401 1d03
                               goto     l__l565             ;  4 OV rs rs [hl hl] 0402 2c05
                               movlw    15                  ;  4 OV rs rs [hl hl] 0403 300f
                               subwf    v_ticks,w           ;  4 OV rs rs [hl hl] 0404 0237
l__l565
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 0405 1903
                               goto     l__serial_receive_interrupt_handler;  4 OV rs rs [hl hl] 0406 2913
                               btfss    v__status, v__c     ;  4 OV rs rs [hl hl] 0407 1c03
                               goto     l__serial_receive_interrupt_handler;  4 OV rs rs [hl hl] 0408 2913
;  111          Ticks = 0
                               clrf     v_ticks             ;  4 OV rs rs [hl hl] 0409 01b7
                               clrf     v_ticks+1           ;  4 OV rs rs [hl hl] 040a 01b8
;  113    end if   
                               goto     l__serial_receive_interrupt_handler;  4 OV rs rs [hl hl] 040b 2913
;  115 end procedure
l__l429
;  118 for 8 loop
                               datalo_clr v__floop7         ;  0 OV ?? ?s [?? ??] 040c 1283
                               datahi_clr v__floop7         ;  0 OV ?s rs [?? ??] 040d 1303
                               clrf     v__floop7           ;  0 OV rs rs [?? ??] 040e 01e9
l__l435
;  120    led1 = ! led1 
                               btfss    v_porta, 2 ; pin_a2       ;  0 OV rs rs [?? ??] 040f 1d05
                               goto     l__l568             ;  0 OV rs rs [?? ??] 0410 2c13
                               bcf      v__bitbucket, 2 ; _btemp79  ;  0 OV rs rs [?? ??] 0411 116a
                                                            ; W = v_gpserrorcode
                               goto     l__l567             ;  0 OV rs rs [?? ??] 0412 2c14
                                                            ; W = v_gpserrorcode
l__l568
                               bsf      v__bitbucket, 2 ; _btemp79  ;  0 OV rs rs [?? ??] 0413 156a
l__l567
                               bcf      v__porta_shadow, 2 ; x69;  0 OV rs rs [?? ??] 0414 1141
                               btfsc    v__bitbucket, 2 ; _btemp79  ;  0 OV rs rs [?? ??] 0415 196a
                               bsf      v__porta_shadow, 2 ; x69;  0 OV rs rs [?? ??] 0416 1541
; 16f690.jal
;  100    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w   ;  0 OV rs rs [?? ??] 0417 0841
                               movwf    v_porta             ;  0 OV rs rs [?? ??] 0418 0085
                                                            ; W = v__porta_shadow
; jallib.jal
;  120    led1 = ! led1 
; 16f690.jal
;  169    _PORTA_flush()
; jallib.jal
;  120    led1 = ! led1 
;  121    delay_1ms(50)
                               movlw    50                  ;  0 OV rs rs [?? ??] 0419 3032
                               movwf    v___n_3             ;  0 OV rs rs [?? ??] 041a 00ed
                               clrf     v___n_3+1           ;  0 OV rs rs [?? ??] 041b 01ee
                                                            ; W = v___n_3
                               call     l_delay_1ms         ;  0 OV rs ?? [?? ??] 041c 22ea
                                                            ; W = v___n_3
;  122 end loop
                               datalo_clr v__floop7         ;  0 OV ?? ?s [?? ??] 041d 1283
                               datahi_clr v__floop7         ;  0 OV ?s rs [?? ??] 041e 1303
                               incf     v__floop7,f         ;  0 OV rs rs [?? ??] 041f 0ae9
                               movlw    8                   ;  0 OV rs rs [?? ??] 0420 3008
                               subwf    v__floop7,w         ;  0 OV rs rs [?? ??] 0421 0269
                               btfss    v__status, v__z     ;  0 OV rs rs [?? ??] 0422 1d03
                               goto     l__l435             ;  0 OV rs rs [?? ??] 0423 2c0f
;  124 SetDutyCycle(500)
                               movlw    244                 ;  0 OV rs rs [?? ??] 0424 30f4
                               movwf    v___duty_1          ;  0 OV rs rs [?? ??] 0425 00ed
                               movlw    1                   ;  0 OV rs rs [?? ??] 0426 3001
                                                            ; W = v___duty_1
                               movwf    v___duty_1+1        ;  0 OV rs rs [?? ??] 0427 00ee
                               call     l_setdutycycle      ;  0 OV rs ?? [?? ??] 0428 23d0
                                                            ; W = v___duty_1
;  129 forever loop    
l__l440
;  139  gpstakt()
; gps_converter.jal
;  111    if (!Serial_HW_read(char)) then
                               call     l_serial_hw_read    ;  0 OV ?? ?? [?? ??] 0429 2161
                               datalo_clr v___char_7        ;  0 OV ?? ?s [?? ??] 042a 1283
                               datahi_clr v___char_7        ;  0 OV ?s rs [?? ??] 042b 1303
                               movwf    v___char_7          ;  0 OV rs rs [?? ??] 042c 00ec
                               bcf      v__bitbucket, 4 ; _btemp671  ;  0 OV rs rs [?? ??] 042d 126a
                                                            ; W = v___char_7
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 042e 1820
                                                            ; W = v___char_7
                               bsf      v__bitbucket, 4 ; _btemp671  ;  0 OV rs rs [?? ??] 042f 166a
                                                            ; W = v___char_7
                               btfss    v__bitbucket, 4 ; _btemp671  ;  0 OV rs rs [?? ??] 0430 1e6a
                                                            ; W = v___char_7
; jallib.jal
;  139  gpstakt()
; gps_converter.jal
;  112       return
                               goto     l__l440             ;  0 OV rs rs [?? ??] 0431 2c29
                                                            ; W = v_gpserrorcode
;  113    end if
l__l442
; jallib.jal
;  139  gpstakt()
; gps_converter.jal
;  119    if (GpsErrorCode > 1) then                     
                               movlw    1                   ;  0 OV rs rs [?? ??] 0432 3001
                                                            ; W = v___char_7
                               subwf    v_gpserrorcode,w    ;  0 OV rs rs [?? ??] 0433 0268
                               btfsc    v__status, v__z     ;  0 OV rs rs [?? ??] 0434 1903
                               goto     l__l446             ;  0 OV rs rs [?? ??] 0435 2c59
                               btfss    v__status, v__c     ;  0 OV rs rs [?? ??] 0436 1c03
                               goto     l__l446             ;  0 OV rs rs [?? ??] 0437 2c59
; jallib.jal
;  139  gpstakt()
; gps_converter.jal
;  120       print_string(serial_hw_data, str_error)
                               movlw    l__serial_hw_data_put;  0 OV rs rs [?? ??] 0438 30e5
                               movwf    v____device_put_1   ;  0 OV rs rs [?? ??] 0439 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 043a 3001
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  0 OV rs rs [?? ??] 043b 00ee
                               movlw    6                   ;  0 OV rs rs [?? ??] 043c 3006
                                                            ; W = v____device_put_1
                               datahi_set v__str_count      ;  0 OV rs Rs [?? ??] 043d 1703
                               movwf    v__str_count        ;  0 OV Rs Rs [?? ??] 043e 00a2
                               clrf     v__str_count+1      ;  0 OV Rs Rs [?? ??] 043f 01a3
                                                            ; W = v__str_count
                               movlw    l__data_str_error   ;  0 OV Rs Rs [?? ??] 0440 301b
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV Rs Rs [?? ??] 0441 00a6
                               movlw    HIGH l__data_str_error;  0 OV Rs Rs [?? ??] 0442 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV Rs Rs [?? ??] 0443 3840
                               movwf    v___str_1+1         ;  0 OV Rs Rs [?? ??] 0444 00a7
                               call     l_print_string      ;  0 OV Rs ?? [?? ??] 0445 2202
                                                            ; W = v___str_1
;  121       print_byte_dec(serial_hw_data, GpsErrorCode)
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0446 30e5
                               datalo_clr v____device_put_19;  0 OV ?? ?s [?? ??] 0447 1283
                               datahi_clr v____device_put_19;  0 OV ?s rs [?? ??] 0448 1303
                               movwf    v____device_put_19  ;  0 OV rs rs [?? ??] 0449 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 044a 3001
                                                            ; W = v____device_put_19
                               movwf    v____device_put_19+1;  0 OV rs rs [?? ??] 044b 00ee
                               movf     v_gpserrorcode,w    ;  0 OV rs rs [?? ??] 044c 0868
                                                            ; W = v____device_put_19
                               call     l_print_byte_dec    ;  0 OV rs ?? [?? ??] 044d 222d
                                                            ; W = v_gpserrorcode
;  122       print_crlf(serial_hw_data) 
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 044e 30e5
                               datalo_clr v__device_put     ;  0 OV ?? ?s [?? ??] 044f 1283
                               datahi_clr v__device_put     ;  0 OV ?s rs [?? ??] 0450 1303
                               movwf    v__device_put       ;  0 OV rs rs [?? ??] 0451 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0452 3001
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  0 OV rs rs [?? ??] 0453 00ee
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 0454 21f4
                                                            ; W = v__device_put
;  123       GpsErrorCode = 1
                               movlw    1                   ;  0 OV ?? ?? [?? ??] 0455 3001
                               datalo_clr v_gpserrorcode    ;  0 OV ?? ?s [?? ??] 0456 1283
                               datahi_clr v_gpserrorcode    ;  0 OV ?s rs [?? ??] 0457 1303
                               movwf    v_gpserrorcode      ;  0 OV rs rs [?? ??] 0458 00e8
;  124    end if
l__l446
;  126    if (char == "$") then
                               movlw    36                  ;  0 OV rs rs [?? ??] 0459 3024
                               subwf    v___char_7,w        ;  0 OV rs rs [?? ??] 045a 026c
                               btfss    v__status, v__z     ;  0 OV rs rs [?? ??] 045b 1d03
                               goto     l__l448             ;  0 OV rs rs [?? ??] 045c 2c61
; jallib.jal
;  139  gpstakt()
; gps_converter.jal
;  128       GpsMsgNr    = 0
;  129       GpsFieldNr  = 0                      
                               clrf     v_gpsfieldnr        ;  0 OV rs rs [?? ??] 045d 01e7
;  130       GpsInBufferIndex = 0
                               clrf     v_gpsinbufferindex  ;  0 OV rs rs [?? ??] 045e 01e6
;  132       GpsErrorCode = 0  ; clear prev errors on new msg start
                               clrf     v_gpserrorcode      ;  0 OV rs rs [?? ??] 045f 01e8
;  135       return
                               goto     l__l440             ;  0 OV rs rs [?? ??] 0460 2c29
;  136    end if
l__l448
;  138    if (GpsErrorCode > 0) then
                               movf     v_gpserrorcode,w    ;  0 OV rs rs [?? ??] 0461 0868
                               btfss    v__status, v__z     ;  0 OV rs rs [?? ??] 0462 1d03
                                                            ; W = v_gpserrorcode
; jallib.jal
;  139  gpstakt()
; gps_converter.jal
;  139       return
                               goto     l__l440             ;  0 OV rs rs [?? ??] 0463 2c29
;  140    end if   
l__l450
;  142    if (StoreBytes(char)) then ; put byte in buffer, true = field end
                               movf     v___char_7,w        ;  0 OV rs rs [?? ??] 0464 086c
                                                            ; W = v_gpserrorcode
                               call     l_storebytes        ;  0 OV rs ?? [?? ??] 0465 2311
                                                            ; W = v___char_7
                               datalo_clr v__bitbucket+1 ; _btemp731 ;  0 OV ?? ?s [?? ??] 0466 1283
                               datahi_clr v__bitbucket+1 ; _btemp731 ;  0 OV ?s rs [?? ??] 0467 1303
                               bcf      v__bitbucket+1, 2 ; _btemp731;  0 OV rs rs [?? ??] 0468 116b
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 0469 1820
                               bsf      v__bitbucket+1, 2 ; _btemp731;  0 OV rs rs [?? ??] 046a 156b
                               btfss    v__bitbucket+1, 2 ; _btemp731;  0 OV rs rs [?? ??] 046b 1d6b
                               goto     l__l458             ;  0 OV rs rs [?? ??] 046c 2c94
; jallib.jal
;  139  gpstakt()
; gps_converter.jal
;  144       if (GpsFieldNr == 0) then
                               movf     v_gpsfieldnr,w      ;  0 OV rs rs [?? ??] 046d 0867
                               btfss    v__status, v__z     ;  0 OV rs rs [?? ??] 046e 1d03
                                                            ; W = v_gpsfieldnr
                               goto     l__l456             ;  0 OV rs rs [?? ??] 046f 2c90
                                                            ; W = v_gpsfieldnr
; jallib.jal
;  139  gpstakt()
; gps_converter.jal
;  147          GpsMsgNr = ParseMessageID()    
                               call     l_parsemessageid    ;  0 OV rs ?? [?? ??] 0470 2355
;  149          print_string(serial_hw_data, str_msg)  
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0471 30e5
                               datalo_clr v____device_put_1 ;  0 OV ?? ?s [?? ??] 0472 1283
                               datahi_clr v____device_put_1 ;  0 OV ?s rs [?? ??] 0473 1303
                               movwf    v____device_put_1   ;  0 OV rs rs [?? ??] 0474 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0475 3001
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  0 OV rs rs [?? ??] 0476 00ee
                               movlw    4                   ;  0 OV rs rs [?? ??] 0477 3004
                                                            ; W = v____device_put_1
                               datahi_set v__str_count      ;  0 OV rs Rs [?? ??] 0478 1703
                               movwf    v__str_count        ;  0 OV Rs Rs [?? ??] 0479 00a2
                               clrf     v__str_count+1      ;  0 OV Rs Rs [?? ??] 047a 01a3
                                                            ; W = v__str_count
                               movlw    l__data_str_msg     ;  0 OV Rs Rs [?? ??] 047b 3046
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV Rs Rs [?? ??] 047c 00a6
                               movlw    HIGH l__data_str_msg;  0 OV Rs Rs [?? ??] 047d 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV Rs Rs [?? ??] 047e 3840
                               movwf    v___str_1+1         ;  0 OV Rs Rs [?? ??] 047f 00a7
                               call     l_print_string      ;  0 OV Rs ?? [?? ??] 0480 2202
                                                            ; W = v___str_1
;  150          print_byte_dec(serial_hw_data, GpsMsgNr) 
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0481 30e5
                               datalo_clr v____device_put_19;  0 OV ?? ?s [?? ??] 0482 1283
                               datahi_clr v____device_put_19;  0 OV ?s rs [?? ??] 0483 1303
                               movwf    v____device_put_19  ;  0 OV rs rs [?? ??] 0484 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0485 3001
                                                            ; W = v____device_put_19
                               movwf    v____device_put_19+1;  0 OV rs rs [?? ??] 0486 00ee
                               movlw    0                   ;  0 OV rs rs [?? ??] 0487 3000
                                                            ; W = v____device_put_19
                               call     l_print_byte_dec    ;  0 OV rs ?? [?? ??] 0488 222d
;  151          print_crlf(serial_hw_data)
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0489 30e5
                               datalo_clr v__device_put     ;  0 OV ?? ?s [?? ??] 048a 1283
                               datahi_clr v__device_put     ;  0 OV ?s rs [?? ??] 048b 1303
                               movwf    v__device_put       ;  0 OV rs rs [?? ??] 048c 00ed
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 048d 3001
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  0 OV rs rs [?? ??] 048e 00ee
                               call     l_print_crlf        ;  0 OV rs ?? [?? ??] 048f 21f4
                                                            ; W = v__device_put
; jallib.jal
;  139  gpstakt()
; gps_converter.jal
;  153          if (GpsMsgNr == 1) then verbose = 1 end if
; jallib.jal
;  139  gpstakt()
; gps_converter.jal
;  154          if (GpsMsgNr == 5) then verbose = 1 end if
;  157       end if
l__l456
;  160       GpsInBufferIndex = 0
                               datalo_clr v_gpsinbufferindex;  0 OV ?? ?s [?? ??] 0490 1283
                                                            ; W = v_gpsfieldnr
                               datahi_clr v_gpsinbufferindex;  0 OV ?s rs [?? ??] 0491 1303
                                                            ; W = v_gpsfieldnr
                               clrf     v_gpsinbufferindex  ;  0 OV rs rs [?? ??] 0492 01e6
                                                            ; W = v_gpsfieldnr
;  161       GpsFieldNr = GpsFieldNr + 1
                               incf     v_gpsfieldnr,f      ;  0 OV rs rs [?? ??] 0493 0ae7
                                                            ; W = v_gpsfieldnr
;  163    end if
l__l458
;  164 end procedure                             
l__l460
; jallib.jal
;  139  gpstakt()
;  161 end loop
                               goto     l__l440             ;  0 OV rs rs [?? ??] 0494 2c29
                               end
; --- procedures & call stack
;{root} ----- -U- (frame_sz=124 blocks=19)
;   {block enter}
;     --- records ---
;     --- variables ---
;     460c28:_jal_version  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 2004
;     460d18:_jal_build  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 20100313
;     4613f8:_device_id word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 5120
;     461a58:_pictype  (type=a dflags=C---- sz=6 use=0 assigned=0)
;      = 49,54,70,54,57,48
;     461908:_datasheet  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 52,49,50,54,50
;     462108:_pgmspec  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 52,49,50,48,52
;     461548:_pic_12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1
;     461638:_pic_14  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2
;     461728:_pic_16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 3
;     461818:_sx_12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 4
;     462858:_pic_14h  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 5
;     4629c8:_pjal bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     462b38:_w byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     462ca8:_f byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     462e18:_true bit (type=B dflags=C--B- sz=1 use=14 assigned=0 bit=0)
;      = 1
;     462f88:_false bit (type=B dflags=C--B- sz=1 use=13 assigned=0 bit=0)
;      = 0
;     4612f8:_high bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
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
;     461248:_pic_18f14k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460064
;     470108:_pic_18f2220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443200
;     470248:_pic_18f2221  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450336
;     470388:_pic_18f2320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443072
;     4704c8:_pic_18f2321  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450272
;     470608:_pic_18f2331  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444064
;     470748:_pic_18f23k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450208
;     470888:_pic_18f23k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464128
;     4709c8:_pic_18f2410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446240
;     470b08:_pic_18f242  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442944
;     470c48:_pic_18f2420  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446208
;     470d88:_pic_18f2423  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446224
;     470ec8:_pic_18f2431  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444032
;     471108:_pic_18f2439  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442944
;     471248:_pic_18f2450  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451040
;     471388:_pic_18f2455  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446496
;     4714c8:_pic_18f2458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452640
;     471608:_pic_18f248  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443840
;     471748:_pic_18f2480  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448672
;     471888:_pic_18f24j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449216
;     4719c8:_pic_18f24j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461632
;     471b08:_pic_18f24j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461248
;     471c48:_pic_18f24k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450144
;     471d88:_pic_18f24k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463872
;     471ec8:_pic_18f2510  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446176
;     472108:_pic_18f2515  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445088
;     472248:_pic_18f252  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442816
;     472388:_pic_18f2520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446144
;     4724c8:_pic_18f2523  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446160
;     472608:_pic_18f2525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445056
;     472748:_pic_18f2539  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442816
;     472888:_pic_18f2550  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446464
;     4729c8:_pic_18f2553  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452608
;     472b08:_pic_18f258  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443904
;     472c48:_pic_18f2580  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448640
;     472d88:_pic_18f2585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445600
;     472ec8:_pic_18f25j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448960
;     473108:_pic_18f25j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461664
;     473248:_pic_18f25j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461280
;     473388:_pic_18f25k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450080
;     4734c8:_pic_18f25k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463616
;     473608:_pic_18f2610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445024
;     473748:_pic_18f2620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444992
;     473888:_pic_18f2680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445568
;     4739c8:_pic_18f2682  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451776
;     473b08:_pic_18f2685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451808
;     473c48:_pic_18f26j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461696
;     473d88:_pic_18f26j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461312
;     473ec8:_pic_18f26k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450016
;     474108:_pic_18f26k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463360
;     474248:_pic_18f4220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443232
;     474388:_pic_18f4221  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450304
;     4744c8:_pic_18f4320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443104
;     474608:_pic_18f4321  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450240
;     474748:_pic_18f4331  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444000
;     474888:_pic_18f43k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450176
;     4749c8:_pic_18f43k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464064
;     474b08:_pic_18f4410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446112
;     474c48:_pic_18f442  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442976
;     474d88:_pic_18f4420  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446080
;     474ec8:_pic_18f4423  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446096
;     475108:_pic_18f4431  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443968
;     475248:_pic_18f4439  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442976
;     475388:_pic_18f4450  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451008
;     4754c8:_pic_18f4455  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446432
;     475608:_pic_18f4458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452576
;     475748:_pic_18f448  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443872
;     475888:_pic_18f4480  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448608
;     4759c8:_pic_18f44j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449248
;     475b08:_pic_18f44j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461728
;     475c48:_pic_18f44j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461344
;     475d88:_pic_18f44k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450112
;     475ec8:_pic_18f44k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463808
;     476108:_pic_18f4510  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446048
;     476248:_pic_18f4515  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444960
;     476388:_pic_18f452  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442848
;     4764c8:_pic_18f4520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446016
;     476608:_pic_18f4523  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446032
;     476748:_pic_18f4525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444928
;     476888:_pic_18f4539  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442848
;     4769c8:_pic_18f4550  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446400
;     476b08:_pic_18f4553  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452544
;     476c48:_pic_18f458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443936
;     476d88:_pic_18f4580  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448576
;     476ec8:_pic_18f4585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445536
;     477108:_pic_18f45j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448992
;     477248:_pic_18f45j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461760
;     477388:_pic_18f45j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461376
;     4774c8:_pic_18f45k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450048
;     477608:_pic_18f45k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463552
;     477748:_pic_18f4610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444896
;     477888:_pic_18f4620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444864
;     4779c8:_pic_18f4680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445504
;     477b08:_pic_18f4682  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451840
;     477c48:_pic_18f4685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451872
;     477d88:_pic_18f46j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461792
;     477ec8:_pic_18f46j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461408
;     478108:_pic_18f46k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449984
;     478248:_pic_18f46k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463296
;     478388:_pic_18f6310  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444832
;     4784c8:_pic_18f6390  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444768
;     478608:_pic_18f6393  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448448
;     478748:_pic_18f63j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456384
;     478888:_pic_18f63j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456128
;     4789c8:_pic_18f6410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443552
;     478b08:_pic_18f6490  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443488
;     478c48:_pic_18f6493  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445376
;     478d88:_pic_18f64j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456416
;     478ec8:_pic_18f64j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456160
;     479108:_pic_18f6520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444640
;     479248:_pic_18f6525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444576
;     479388:_pic_18f6527  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446720
;     4794c8:_pic_18f6585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444448
;     479608:_pic_18f65j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447200
;     479748:_pic_18f65j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456480
;     479888:_pic_18f65j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447232
;     4799c8:_pic_18f65j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458432
;     479b08:_pic_18f65j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456224
;     479c48:_pic_18f6620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443424
;     479d88:_pic_18f6621  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444512
;     479ec8:_pic_18f6622  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446784
;     47a108:_pic_18f6627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446848
;     47a248:_pic_18f6628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460672
;     47a388:_pic_18f6680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444384
;     47a4c8:_pic_18f66j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447264
;     47a608:_pic_18f66j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459264
;     47a748:_pic_18f66j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447296
;     47a888:_pic_18f66j16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459296
;     47a9c8:_pic_18f66j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458496
;     47ab08:_pic_18f66j55  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458528
;     47ac48:_pic_18f66j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447936
;     47ad88:_pic_18f66j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449728
;     47aec8:_pic_18f66j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462272
;     47b108:_pic_18f66j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462336
;     47b248:_pic_18f6720  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443360
;     47b388:_pic_18f6722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446912
;     47b4c8:_pic_18f6723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460736
;     47b608:_pic_18f67j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447328
;     47b748:_pic_18f67j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459328
;     47b888:_pic_18f67j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458560
;     47b9c8:_pic_18f67j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449760
;     47bb08:_pic_18f67j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462304
;     47bc48:_pic_18f67j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462368
;     47bd88:_pic_18f8310  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444800
;     47bec8:_pic_18f8390  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444736
;     47c108:_pic_18f8393  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448480
;     47c248:_pic_18f83j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456512
;     47c388:_pic_18f83j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456256
;     47c4c8:_pic_18f8410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443520
;     47c608:_pic_18f8490  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443456
;     47c748:_pic_18f8493  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445408
;     47c888:_pic_18f84j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456544
;     47c9c8:_pic_18f84j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456288
;     47cb08:_pic_18f8520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444608
;     47cc48:_pic_18f8525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444544
;     47cd88:_pic_18f8527  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446752
;     47cec8:_pic_18f8585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444416
;     47d108:_pic_18f85j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447392
;     47d248:_pic_18f85j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456608
;     47d388:_pic_18f85j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447680
;     47d4c8:_pic_18f85j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458592
;     47d608:_pic_18f85j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456352
;     47d748:_pic_18f8620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443392
;     47d888:_pic_18f8621  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444480
;     47d9c8:_pic_18f8622  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446816
;     47db08:_pic_18f8627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446880
;     47dc48:_pic_18f8628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460704
;     47dd88:_pic_18f8680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444352
;     47dec8:_pic_18f86j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447712
;     47e108:_pic_18f86j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459424
;     47e248:_pic_18f86j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447744
;     47e388:_pic_18f86j16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459456
;     47e4c8:_pic_18f86j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458656
;     47e608:_pic_18f86j55  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458688
;     47e748:_pic_18f86j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447968
;     47e888:_pic_18f86j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449792
;     47e9c8:_pic_18f86j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462400
;     47eb08:_pic_18f86j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462464
;     47ec48:_pic_18f8720  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443328
;     47ed88:_pic_18f8722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446944
;     47eec8:_pic_18f8723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460768
;     47f108:_pic_18f87j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447776
;     47f248:_pic_18f87j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459488
;     47f388:_pic_18f87j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458720
;     47f4c8:_pic_18f87j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449824
;     47f608:_pic_18f87j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462432
;     47f748:_pic_18f87j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462496
;     47f888:_pic_18f96j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448000
;     47f9c8:_pic_18f96j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449856
;     47fb08:_pic_18f97j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449888
;     47fc48:_pic_18lf13k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462144
;     47fd88:_pic_18lf13k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459968
;     47fec8:_pic_18lf14k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462112
;     480108:_pic_18lf14k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460000
;     480248:_pic_18lf23k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464160
;     480388:_pic_18lf24j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449280
;     4804c8:_pic_18lf24j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461824
;     480608:_pic_18lf24j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461440
;     480748:_pic_18lf24k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463904
;     480888:_pic_18lf25j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449024
;     4809c8:_pic_18lf25j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461856
;     480b08:_pic_18lf25j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461472
;     480c48:_pic_18lf25k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463648
;     480d88:_pic_18lf26j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461888
;     480ec8:_pic_18lf26j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461504
;     481108:_pic_18lf26k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463392
;     481248:_pic_18lf43k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464096
;     481388:_pic_18lf44j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449312
;     4814c8:_pic_18lf44j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461920
;     481608:_pic_18lf44j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461536
;     481748:_pic_18lf44k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463840
;     481888:_pic_18lf45j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449056
;     4819c8:_pic_18lf45j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461952
;     481b08:_pic_18lf45j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461568
;     481c48:_pic_18lf45k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463584
;     481d88:_pic_18lf46j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461984
;     481ec8:_pic_18lf46j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461600
;     482108:_pic_18lf46k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463328
;     4638f8:_target_cpu  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2
;     4822e8:_target_chip  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315840
;     4828f8:_target_chip_name  (type=a dflags=C---- sz=6 use=0 assigned=0)
;      = 49,54,102,54,57,48
;     4826e8:_target_bank_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 128
;     482628:_target_page_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2048
;     482568:__stack_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8
;     4824a8:__code_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 4096
;     482f48:__eeprom  (type=a dflags=C---- sz=256 use=0 assigned=0)
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
;     4827a8:__pic_accum byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=007e)
;     4823e8:__pic_isr_w byte (type=i dflags=-V--- sz=1 use=2 assigned=2 base=007f)
;     483dd8:__fuses_ct word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 1
;     483f48:__fuse_base word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 8199
;     484108:__fuses word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 16374
;     483cd8:_indf byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0000)
;     484428:__ind byte (type=i dflags=-V--- sz=1 use=3 assigned=4 base=0000)
;     4846d8:_tmr0 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0001)
;     4848a8:_pcl byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0002)
;     484b58:__pcl byte (type=i dflags=-V--- sz=1 use=9 assigned=10 base=0002)
;     484e08:_status byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0003)
;     485108:_status_irp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> status+0
;     485258:_status_rp  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=5) ---> status+0
;     485448:_status_nto bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> status+0
;     4855a8:_status_npd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> status+0
;     485708:_status_z bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> status+0
;     485868:_status_dc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> status+0
;     4859c8:_status_c bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> status+0
;     485b28:__status byte (type=i dflags=-V--- sz=1 use=75 assigned=6 base=0003)
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
;     4866c8:__z byte (type=i dflags=C---- sz=1 use=110 assigned=0)
;      = 2
;     486838:__dc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     4869a8:__c byte (type=i dflags=C---- sz=1 use=46 assigned=0)
;      = 0
;     485dd8:_fsr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0004)
;     486cc8:__fsr byte (type=i dflags=-V--- sz=1 use=1 assigned=8 base=0004)
;     486f78:_porta byte (type=i dflags=-V--- sz=1 use=2 assigned=1 base=0005)
;     487108:__porta_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=3 base=0041)
;     487698:__porta_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     488258:__porta_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     489108:__porta_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     487ec8:__porta_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48bb38:__porta_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48b868:__porta_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48e3e8:_porta_ra5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e578:_pin_a5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e6f8:_pin_t1cki bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e7d8:_pin_osc1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e8b8:_pin_clkin bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48ecf8:__pin_a5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48e9a8:_porta_ra4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48f7f8:_pin_a4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48f978:_pin_an3 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48fa58:_pin_t1g bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48fb38:_pin_osc2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48fc18:_pin_clkout bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     4621a8:__pin_a4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48fd08:_porta_ra3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     490a08:_pin_a3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     490b88:_pin_mclr bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     490c68:_pin_vpp bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     491108:__pin_a3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     490d58:_porta_ra2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491b78:_pin_a2 bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=2) ---> porta+0
;     491cf8:_pin_an2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491dd8:_pin_t0cki bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491eb8:_pin_c1out bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     4921f8:__pin_a2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     491fa8:_porta_ra1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492c68:_pin_a1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492de8:_pin_an1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492ec8:_pin_c12in0_neg bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492fa8:_pin_icspclk bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     4932b8:__pin_a1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     492758:_porta_ra0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     493d28:_pin_a0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     493ea8:_pin_an0 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     493f88:_pin_c1in_pos bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     4937f8:_pin_icspdat bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     494108:_pin_ulpwu bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     494548:__pin_a0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4941f8:_portb byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0006)
;     494a88:__portb_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     495608:__portb_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4961f8:__portb_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     497108:__portb_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     495ea8:__portb_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
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
;     4e3a78:_usart_hw_serial bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     4e4358:__calculate_and_set_baudrate_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4e5b08:__serial_xmtbuf  (type=a dflags=----- auto sz=80 use=2 assigned=2 base=00a0)
;     4e5d28:__serial_rcvbuf  (type=a dflags=----- auto sz=12 use=2 assigned=2 base=0042)
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
;     50bc48:_ascii_null byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     50bdb8:_ascii_soh byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     50bf28:_ascii_stx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 2
;     50c108:_ascii_etx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     50c278:_ascii_eot byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     50c3e8:_ascii_enq byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     50c558:_ascii_ack byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     50c6c8:_ascii_bel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 7
;     50c838:_ascii_bs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 8
;     50c9a8:_ascii_ht byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 9
;     50cb18:_ascii_lf byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 10
;     50cc88:_ascii_vt byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 11
;     50cdf8:_ascii_ff byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 12
;     50cf68:_ascii_cr byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 13
;     50d108:_ascii_so byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 14
;     50d278:_ascii_si byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 15
;     50d3e8:_ascii_dle byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 16
;     50d558:_ascii_dc1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 17
;     50d6c8:_ascii_dc2 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 18
;     50d838:_ascii_dc3 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 19
;     50d9a8:_ascii_dc4 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 20
;     50db18:_ascii_nak byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 21
;     50dc88:_ascii_syn byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 22
;     50ddf8:_ascii_etb byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 23
;     50df68:_ascii_can byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 24
;     50e108:_ascii_em byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 25
;     50e278:_ascii_sub byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 26
;     50e3e8:_ascii_esc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 27
;     50e558:_ascii_fs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 28
;     50e6c8:_ascii_gs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 29
;     50e838:_ascii_rs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 30
;     50e9a8:_ascii_us byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 31
;     50eb18:_ascii_sp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 32
;     50ec88:_ascii_del byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 127
;     50f108:_toupper_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     511b48:_tolower_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     514b78:__print_universal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     5151f8:__print_suniversal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     5147c8:_print_byte_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     516618:_nibble2hex  (type=a dflags=C---- sz=16 use=22 assigned=0)
;      = 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70
;     50bb18:_print_prefix  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     5148d8:_print_crlf_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     515ac8:_print_string_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5163d8:_print_bit_truefalse_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     519ea8:_print_bit_highlow_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     51bcd8:_print_bit_10_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     51e708:_print_dword_binary_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     520b98:_print_word_binary_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     526da8:_print_nibble_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     52a858:_print_dword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5309b8:_print_sdword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     536e38:_print_word_hex_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     53aae8:_print_byte_hex_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     53d3c8:_print_sdword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     53e258:_print_sword_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     53f1b8:_print_sword_fp_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     540b68:_print_sbyte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     541ab8:_print_dword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5429b8:_print_word_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5438d8:_print_byte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5146b8:_delay_1us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5159d8:_delay_2us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     544738:_delay_3us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     544828:_delay_4us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     54e958:_delay_5us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     54f218:_delay_6us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     54f9b8:_delay_7us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     503de8:_delay_8us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4f5fa8:_delay_9us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5507f8:_instruction_time  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 40
;     5511b8:_delay_10us_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     553f28:_delay_1ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     558988:_delay_100ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     55a878:_delay_1s_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     55c868:_in_buf_size byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 20
;     550d58:_gpsinbuffer  (type=a dflags=----- auto sz=20 use=3 assigned=3 base=0052)
;     55ca38:_gpsinbufferindex byte (type=i dflags=----- auto sz=1 use=4 assigned=3 base=0066)
;     55caf8:_gpsmsgnr  (type=i dflags=C---- sz=1 use=0 assigned=1)
;      = 0
;     55cbb8:_gpsfieldnr byte (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0067)
;     55cd48:_gpserrorcode byte (type=i dflags=----- auto sz=1 use=3 assigned=4 base=0068)
;     55d8c8:_str_inbuffer  (type=a dflags=C---- sz=6 use=0 assigned=0)
;      = 73,110,66,117,102,32
;     55d2c8:_dumpgpsinbuffer_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5607a8:_storebytes_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5641f8:_ismsg_1  (type=F dflags=----- sz=5 use=0 assigned=0 base=0000)
;     566a68:_str_gpgga  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,71,71,65
;     566d98:_str_gpgll  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,71,76,76
;     567108:_str_gpgsa  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,71,83,65
;     567438:_str_gpgsv  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,71,83,86
;     567768:_str_gprmc  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,82,77,67
;     567a98:_str_gpvtg  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;      = 71,80,86,84,71
;     5604a8:_parsemessageid_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     56c6b8:_str_msg  (type=a dflags=C---- lookup sz=4 use=1 assigned=0)
;      = 77,115,103,32
;     56cb68:_str_error  (type=a dflags=C---- lookup sz=6 use=1 assigned=0)
;      = 69,114,114,111,114,32
;     56c388:_verbose  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     56c478:_gpstakt_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     579788:_ticks word (type=i dflags=-V--- auto sticky sz=2 use=4 assigned=6 base=0037)
;     579b88:_tickslowbyte byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> ticks+0
;     57a5f8:_str1_2  (type=a dflags=C---- lookup sz=10 use=1 assigned=0)
;      = 86,99,120,111,32,86,48,46,49,10
;     579e58:_setdutycycle_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     579d68:_isr_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     57f8c8:__floop7  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0069)
;     504ca8:__btemp_26  (type=i dflags=---B- sz=2 use=0 assigned=0 bit=2) ---> _bitbucket+0
;     581328:__btemp80  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _bitbucket+0
;     581a68:_ch  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     570658:__bitbucket  (type=i dflags=----- auto sz=2 use=6 assigned=12 base=006a)
;     52c798:__pic_isr_fsr  (type=i dflags=----- sz=1 use=1 assigned=1 base=0036)
;     52b6b8:__pic_isr_status  (type=i dflags=----- sz=1 use=1 assigned=1 base=0030)
;     52ba28:__pic_isr_pclath  (type=i dflags=----- sz=1 use=1 assigned=1 base=0031)
;     527a78:__pic_temp  (type=i dflags=----- sz=2 use=21 assigned=27) ---> _pic_state+0
;     51ef78:__pic_pointer  (type=i dflags=----- sz=2 use=5 assigned=13 base=0034)
;     511ea8:__pic_loop  (type=i dflags=----- sz=1 use=1 assigned=2 base=0032)
;     510c18:__pic_divisor  (type=i dflags=----- sz=4 use=20 assigned=16) ---> _pic_state+8
;     5108b8:__pic_dividend  (type=i dflags=----- sz=4 use=9 assigned=16) ---> _pic_state+0
;     5106a8:__pic_quotient  (type=i dflags=----- sz=4 use=17 assigned=13) ---> _pic_state+12
;     50fb18:__pic_remainder  (type=i dflags=----- sz=4 use=20 assigned=16) ---> _pic_state+4
;     50f468:__pic_divaccum  (type=i dflags=----- sz=8 use=8 assigned=8) ---> _pic_state+0
;     5078b8:__pic_sign  (type=i dflags=----- sz=1 use=2 assigned=3 base=0033)
;     60ead8:__pic_state  (type=i dflags=----- sz=16 use=95 assigned=96 base=0020)
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
;     _print_universal_dec (pc(0243) usage=5)
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
;     print_byte_dec (pc(022d) usage=10)
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
;     delay_1ms (pc(02ea) usage=5)
;     delay_100ms (pc(0000) usage=0)
;     delay_1s (pc(0000) usage=0)
;     dumpgpsinbuffer (pc(0000) usage=0)
;     storebytes (pc(0311) usage=5)
;     ismsg (pc(032f) usage=30)
;     parsemessageid (pc(0355) usage=5)
;     gpstakt (pc(0000) usage=0)
;     setdutycycle (pc(03d0) usage=5)
;     isr (pc(03f9) usage=5)
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
;       536fa8:__btemp79  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> _bitbucket+0
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         580418:_x_69 bit (type=B dflags=---B- sz=1 use=0 assigned=2 bit=2) ---> _porta_shadow+0
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
;         581e98:_char_7 byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=006c)
;         581f28:__btemp_27  (type=i dflags=---B- sz=10 use=0 assigned=0 bit=4) ---> _bitbucket+0
;         582108:__btemp67_1  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> _bitbucket+0
;         582198:__btemp68_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _bitbucket+0
;         582228:__btemp69_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _bitbucket+0
;         5822b8:__btemp70_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _bitbucket+0
;         582348:__btemp71_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=8) ---> _bitbucket+0
;         5823d8:__btemp72_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=9) ---> _bitbucket+0
;         582468:__btemp73_1  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=10) ---> _bitbucket+0
;         5824f8:__temp_49  (type=? dflags=C---- sz=0 use=0 assigned=0)
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
;           584b68:__btemp74_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=11) ---> _bitbucket+0
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             584d88:__btemp75_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=12) ---> _bitbucket+0
;             584e18:__btemp76_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=13) ---> _bitbucket+0
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
;        57dc98:__temp_48  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        57e698:__btemp_25  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        575298:__bitbucket_1  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          57e768:__btemp78  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;        579f48:_duty_1 word (type=i dflags=----- auto sz=2 use=5 assigned=4 base=006d)
;        57a108:__btemp_24  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        57a1f8:__btemp77  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        57c108:__temp_47  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        574418:__bitbucket_2  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        56c568:_char_6  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56c928:__btemp_23  (type=i dflags=C--B- sz=10 use=0 assigned=0 bit=0)
;         = 0
;        56ca18:__btemp67  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        56d698:__btemp68  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        56e108:__btemp69  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        56eb48:__btemp70  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;        4ff898:__btemp71  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;        571e68:__btemp72  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;        5728e8:__btemp73  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
;        573718:__temp_46  (type=? dflags=C---- sz=0 use=2 assigned=0)
;         = 0
;        559f38:__bitbucket_3  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          572e58:__btemp74  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=7)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            574538:__btemp75  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=8)
;            5753b8:__btemp76  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=9)
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
;        566648:__btemp_22  (type=i dflags=---B- sz=6 use=0 assigned=0 bit=0) ---> ___bitbucket4+0
;        566738:__btemp61  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket4+0
;        5688d8:__btemp62  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=1) ---> ___bitbucket4+0
;        5693d8:__btemp63  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> ___bitbucket4+0
;        569dd8:__btemp64  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket4+0
;        56a8b8:__btemp65  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> ___bitbucket4+0
;        56b3d8:__btemp66  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=5) ---> ___bitbucket4+0
;        55f738:__bitbucket_4  (type=i dflags=----- auto sz=1 use=6 assigned=12 base=006d)
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
;        564438:__name_count  (type=i dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        5644f8:_name_1  (type=* dflags=----- auto ptr_lookup sz=2 use=2 assigned=12 base=0120)
;        5645c8:_i_2 byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=0124)
;        564f78:__btemp_21  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        565bb8:__btemp60  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        55f258:__bitbucket_5  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          564e78:__btemp59  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;        560998:_char_5 byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=006d)
;        560c38:__btemp_20  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        560d08:__btemp57  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        561a08:__btemp58  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        562ea8:__temp_45  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        55ed78:__bitbucket_6  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        55d3b8:_i_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55d778:__btemp_19  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        55e758:__btemp56  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        55f838:__temp_44  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        55d598:__bitbucket_7  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        55aa68:_n_7  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55b108:__1_s_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 999995
;        55ac58:__floop6  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55ae38:__btemp_18  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        55bd18:__btemp55  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        55d4a8:__bitbucket_8  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        558b78:_n_5  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        559108:__100_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 99995
;        558d08:__floop5  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        558ee8:__btemp_17  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        559d18:__btemp54  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        55ab58:__bitbucket_9  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5566d8:_n_3 word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=006d)
;        556c18:__one_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 995
;        556868:__floop4  (type=i dflags=----- auto sz=2 use=4 assigned=4 base=0122)
;        557758:__btemp_16  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        556a48:__btemp53  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        558c38:__bitbucket_10  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5513a8:_n_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5515b8:__btemp_15  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        551688:__btemp50  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        552108:__btemp51  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        552708:__temp_43  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        553c78:__bitbucket_11  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          552ab8:__ten_us_delay1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 4
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          554108:__ten_us_delay2  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 4294967295
;          5549d8:__ten_us_delay3  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 8
;          553d48:__floop3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5553c8:__btemp52  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
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
;        552608:__bitbucket_12  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_8us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        551f18:__bitbucket_13  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_7us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        545e68:__bitbucket_14  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_6us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        544e38:__bitbucket_15  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_5us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        542f98:__bitbucket_16  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_4us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        542e98:__bitbucket_17  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_3us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        542108:__bitbucket_18  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_2us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        541f98:__bitbucket_19  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_1us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        541208:__bitbucket_20  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_dec --D-- -U- (frame_sz=3 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        543ac8:__device_put_19  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=4 base=006d)
;        543b88:_data_49 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0122)
;        541108:__bitbucket_21  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_word_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        542ba8:__device_put_18  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        542c68:_data_47  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        540338:__bitbucket_22  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_dword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        541ca8:__device_put_17  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        541d68:_data_45  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        540238:__bitbucket_23  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sbyte_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        540d58:__device_put_16  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        540e18:_data_43  (type=i dflags=C-S-- sz=1 use=0 assigned=0)
;         = 0
;        4fdf28:__bitbucket_24  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_fp_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53f3a8:__device_put_15  (type=* dflags=C---- sz=2 use=0 assigned=1)
;         = 0
;        53f468:_data_41  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        53f7c8:__temp_40  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4f8e28:__bitbucket_25  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53e448:__device_put_14  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53e508:_data_39  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        4f4f78:__bitbucket_26  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sdword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53d5b8:__device_put_13  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53d648:_data_37  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        53fe18:__bitbucket_27  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_hex --D-- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53acd8:__device_put_12  (type=* dflags=C---- sz=2 use=0 assigned=4)
;         = 0
;        53ad68:_data_35  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53bb78:__temp_39  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53fd18:__bitbucket_28  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        537188:__device_put_11  (type=* dflags=C---- sz=2 use=0 assigned=6)
;         = 0
;        537218:_data_33  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        537f48:__temp_38  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        53f8a8:__bitbucket_29  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        530ba8:__device_put_10  (type=* dflags=C---- sz=2 use=0 assigned=10)
;         = 0
;        530c38:_data_31  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        531aa8:__temp_37  (type=i dflags=C---- sz=8 use=0 assigned=0)
;         = 0
;        53f698:__bitbucket_30  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52aa48:__device_put_9  (type=* dflags=C---- sz=2 use=0 assigned=10)
;         = 0
;        52ab08:_data_29  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        52b948:__temp_36  (type=i dflags=C---- sz=8 use=0 assigned=0)
;         = 0
;        53e838:__bitbucket_31  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        526f98:__device_put_8  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        527138:_data_27  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        527338:__floop2  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        527ba8:__temp_35  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        528338:__btemp_12  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        529c18:__btemp43  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        53e738:__bitbucket_32  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          528408:__btemp42  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;        520d88:__device_put_6  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        520e48:_data_23  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        521b48:__temp_33  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53d978:__bitbucket_33  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        51e8f8:__device_put_5  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        51e9b8:_data_21  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        51f6a8:__temp_32  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53d878:__bitbucket_34  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        51d3e8:__device_put_4  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        51d4a8:_data_19  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        53c948:__bitbucket_35  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        519f98:__device_put_3  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        51a428:_data_17  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        51bef8:_str1_1  (type=a dflags=C---- sz=4 use=0 assigned=0)
;         = 104,105,103,104
;        51bdc8:_str0_1  (type=a dflags=C---- sz=3 use=0 assigned=0)
;         = 108,111,119
;        53c778:__bitbucket_36  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5164c8:__device_put_2  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        519bc8:_data_15  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        51a1b8:_str1  (type=a dflags=C---- sz=4 use=0 assigned=0)
;         = 116,114,117,101
;        51a578:_str0  (type=a dflags=C---- sz=5 use=0 assigned=0)
;         = 102,97,108,115,101
;        53c268:__bitbucket_37  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        515bb8:__device_put_1  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=6 base=006d)
;        515ca8:__str_count  (type=i dflags=----- auto sz=2 use=2 assigned=6 base=0122)
;        515d98:_str_1  (type=* dflags=----- auto ptr_lookup sz=2 use=2 assigned=6 base=0126)
;        515e88:_len word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=012c)
;        515f78:_i byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=006f)
;        5162e8:__btemp_10  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5161f8:__btemp39  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        53b8e8:__bitbucket_38  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      print_crlf --D-- -U- (frame_sz=2 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5158e8:__device_put  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=4 base=006d)
;        53bc58:__bitbucket_39  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_binary --D-- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        522b98:__device_put_7  (type=* dflags=C---- sz=2 use=0 assigned=4)
;         = 0
;        522c58:_data_25  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        523888:__floop1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        524238:__temp_34  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        524888:__btemp_11  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        5262b8:__btemp41  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        53ba48:__bitbucket_40  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          524958:__btemp40  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;        544a58:__device_put_20  (type=* dflags=C---- sz=2 use=0 assigned=1)
;         = 0
;        544b18:_data_51  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        544bd8:_digit_divisor_3  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        544c98:_digit_number_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        544f38:__btemp_13  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        545108:__btemp44  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        545828:__temp_41  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        53b408:__bitbucket_41  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        546ea8:__device_put_21  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=2 base=0124)
;        546f68:_data_53 dword (type=i dflags=----- auto sz=4 use=8 assigned=8 base=0128)
;        5464f8:_digit_divisor_5 sdword (type=i dflags=--S-- auto sz=4 use=12 assigned=8 base=012e)
;        547108:_digit_number_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0132)
;        5471f8:_digit byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=0133)
;        5472d8:_no_digits_printed_yet bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket42+0
;        547548:__btemp_14  (type=i dflags=---B- sz=5 use=0 assigned=0 bit=1) ---> ___bitbucket42+0
;        547618:__btemp45  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> ___bitbucket42+0
;        548898:__btemp46  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> ___bitbucket42+0
;        549108:__temp_42  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0134)
;        53b1d8:__bitbucket_42  (type=i dflags=----- auto sz=1 use=4 assigned=8 base=0135)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          54a5b8:__btemp47  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket42+0
;          54ab38:__btemp48  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> ___bitbucket42+0
;          54aef8:__btemp49  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=5) ---> ___bitbucket42+0
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
;        511d38:_char_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        511fa8:__btemp_9  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        512128:__btemp36  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        512728:__btemp37  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        512ae8:__btemp38  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        513408:__temp_31  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53a108:__bitbucket_43  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        50f2f8:_char_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        50f568:__btemp_8  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        50f638:__btemp33  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        50fc38:__btemp34  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        4e3768:__btemp35  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5107d8:__temp_30  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        539e88:__bitbucket_44  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        539a78:__bitbucket_45  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        539518:__bitbucket_46  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5397d8:__bitbucket_47  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        539678:__bitbucket_48  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_init --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        539108:__bitbucket_49  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        538ab8:__bitbucket_50  (type=i dflags=----- auto sticky sz=1 use=3 assigned=6 base=0040)
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
;        538d78:__bitbucket_51  (type=i dflags=----- auto sz=1 use=0 assigned=0 base=ffff)
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
;        538c18:__bitbucket_52  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5385a8:__bitbucket_53  (type=i dflags=----- sticky sz=2 use=3 assigned=6 base=003b)
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
;        537cb8:__bitbucket_54  (type=i dflags=----- sticky sz=1 use=3 assigned=6 base=003a)
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
;        4e4288:_max_deviation  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 5
;        4e4f08:_usart_div  (type=i dflags=C---U sz=4 use=1 assigned=0)
;         = 520
;        4e6148:_real_baud  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 4798
;        538108:__bitbucket_55  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      enable_digital_io ----L --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        537e18:__bitbucket_56  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5377d8:__bitbucket_57  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5375a8:__bitbucket_58  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      analog_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        536458:__bitbucket_59  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cbd68:__temp_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        536288:__bitbucket_60  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        535d18:__bitbucket_61  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c9688:__temp_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5357b8:__bitbucket_62  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        535a78:__bitbucket_63  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c5718:__temp_19  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        535918:__bitbucket_64  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5353a8:__bitbucket_65  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c2f68:__temp_17  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        534d48:__bitbucket_66  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        535108:__bitbucket_67  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4be5f8:__temp_15  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        534ea8:__bitbucket_68  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        534938:__bitbucket_69  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4bbd08:__temp_13  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5343d8:__bitbucket_70  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        534698:__bitbucket_71  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_c0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b0268:_x_53 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portc_shadow
;        534538:__bitbucket_72  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533e78:__bitbucket_73  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533918:__bitbucket_74  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533bd8:__bitbucket_75  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533a78:__bitbucket_76  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533508:__bitbucket_77  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        532f88:__bitbucket_78  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533268:__bitbucket_79  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533108:__bitbucket_80  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        532b78:__bitbucket_81  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        532618:__bitbucket_82  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5328d8:__bitbucket_83  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        532778:__bitbucket_84  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        532108:__bitbucket_85  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_b4_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a0268:_x_31 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portb_shadow
;        531818:__bitbucket_86  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        531b88:__bitbucket_87  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        531978:__bitbucket_88  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        531338:__bitbucket_89  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        531108:__bitbucket_90  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4eef48:__bitbucket_91  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4eacf8:__bitbucket_92  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52fbd8:__bitbucket_93  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4963e8:_x_19  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52f678:__bitbucket_94  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52f938:__bitbucket_95  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_a0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        494738:_x_17 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _porta_shadow+0
;        52f7d8:__bitbucket_96  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4934a8:_x_15 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _porta_shadow+0
;        52f268:__bitbucket_97  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4923e8:_x_13 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _porta_shadow+0
;        52ebf8:__bitbucket_98  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4912f8:_x_11 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _porta_shadow+0
;        52eeb8:__bitbucket_99  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        490188:_x_9 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _porta_shadow+0
;        52ed58:__bitbucket_100  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        48eee8:_x_7 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _porta_shadow+0
;        52e7e8:__bitbucket_101  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        48db08:__temp_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52e288:__bitbucket_102  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        48bd28:_x_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        48c108:__temp_2  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        52e548:__bitbucket_103  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        48a6b8:__temp_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52e3e8:__bitbucket_104  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4892f8:_x_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        489628:__temp  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        52dd68:__bitbucket_105  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52d808:__bitbucket_106  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52dac8:__bitbucket_107  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;487548:_l1(use=0:ref=2:pc=0000)
;4875a8:_l2(use=0:ref=2:pc=0000)
;488108:_l3(use=0:ref=2:pc=0000)
;488168:_l4(use=0:ref=2:pc=0000)
;488ac8:_l5(use=0:ref=1:pc=0000)
;488fc8:_l6(use=0:ref=2:pc=0000)
;4884f8:_l7(use=0:ref=2:pc=0000)
;48a758:_l8(use=0:ref=1:pc=0000)
;48abb8:_l9(use=0:ref=2:pc=0000)
;48ac18:_l10(use=0:ref=2:pc=0000)
;48b9e8:_l11(use=0:ref=2:pc=0000)
;48ba48:_l12(use=0:ref=2:pc=0000)
;48d218:_l13(use=0:ref=1:pc=0000)
;48d678:_l14(use=0:ref=2:pc=0000)
;48d6d8:_l15(use=0:ref=2:pc=0000)
;48eba8:_l16(use=0:ref=2:pc=0000)
;48ec08:_l17(use=0:ref=2:pc=0000)
;48f368:_l18(use=0:ref=1:pc=0000)
;48ff08:_l19(use=0:ref=2:pc=0000)
;48ff68:_l20(use=0:ref=2:pc=0000)
;490578:_l21(use=0:ref=1:pc=0000)
;490f58:_l22(use=0:ref=2:pc=0000)
;490fb8:_l23(use=0:ref=2:pc=0000)
;4916e8:_l24(use=0:ref=1:pc=0000)
;491388:_l25(use=0:ref=2:pc=0000)
;492108:_l26(use=0:ref=2:pc=0000)
;4927d8:_l27(use=0:ref=1:pc=0000)
;493168:_l28(use=0:ref=2:pc=0000)
;4931c8:_l29(use=0:ref=2:pc=0000)
;493898:_l30(use=0:ref=1:pc=0000)
;4943f8:_l31(use=0:ref=2:pc=0000)
;494458:_l32(use=0:ref=2:pc=0000)
;494b28:_l33(use=0:ref=1:pc=0000)
;4954b8:_l34(use=0:ref=2:pc=0000)
;495518:_l35(use=0:ref=2:pc=0000)
;495898:_l36(use=0:ref=2:pc=0000)
;496108:_l37(use=0:ref=2:pc=0000)
;496ac8:_l38(use=0:ref=1:pc=0000)
;496fc8:_l39(use=0:ref=2:pc=0000)
;4964e8:_l40(use=0:ref=2:pc=0000)
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
;460ba8:_l97(use=0:ref=2:pc=0000)
;461788:_l98(use=0:ref=2:pc=0000)
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
;4e38f8:_l139(use=0:ref=1:pc=0000)
;4e3c58:_l140(use=0:ref=1:pc=0000)
;4e3ef8:_l141(use=0:ref=1:pc=0000)
;4e34e8:_l142(use=0:ref=1:pc=0000)
;4e4208:_l143(use=0:ref=1:pc=0000)
;4e4668:_l144(use=0:ref=1:pc=0000)
;4e4828:_l145(use=0:ref=1:pc=0000)
;4e4bf8:_l146(use=0:ref=2:pc=0000)
;4e4c58:_l147(use=0:ref=2:pc=0000)
;4e46e8:_l148(use=0:ref=1:pc=0000)
;4e4868:_l149(use=0:ref=1:pc=0000)
;4e4f68:_l150(use=0:ref=1:pc=0000)
;4e5228:_l151(use=0:ref=1:pc=0000)
;4e6338:_l152(use=0:ref=1:pc=0000)
;4e6528:_l153(use=0:ref=1:pc=0000)
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
;50eed8:_l230(use=0:ref=2:pc=0000)
;50ef38:_l231(use=0:ref=2:pc=0000)
;50f3a8:_l232(use=0:ref=1:pc=0000)
;510428:_l233(use=0:ref=1:pc=0000)
;5119f8:_l234(use=0:ref=2:pc=0000)
;511a58:_l235(use=0:ref=2:pc=0000)
;511de8:_l236(use=0:ref=1:pc=0000)
;512f58:_l237(use=0:ref=1:pc=0000)
;514a28:_l238(use=0:ref=2:pc=0000)
;514a88:_l239(use=4:ref=4:pc=02e9)
;514538:_l240(use=0:ref=2:pc=0000)
;515108:_l241(use=0:ref=2:pc=0000)
;515578:_l242(use=0:ref=2:pc=0000)
;5155d8:_l243(use=0:ref=2:pc=0000)
;516b78:_l244(use=0:ref=2:pc=0000)
;516bd8:_l245(use=0:ref=2:pc=0000)
;517808:_l246(use=0:ref=2:pc=0000)
;517868:_l247(use=0:ref=2:pc=0000)
;518398:_l248(use=5:ref=3:pc=0209)
;5183f8:_l249(use=5:ref=3:pc=0221)
;518458:_l250(use=0:ref=1:pc=0000)
;518648:_l251(use=0:ref=1:pc=0000)
;519888:_l252(use=0:ref=2:pc=0000)
;5198e8:_l253(use=0:ref=2:pc=0000)
;51a638:_l254(use=0:ref=1:pc=0000)
;51a6d8:_l255(use=0:ref=1:pc=0000)
;51b718:_l256(use=0:ref=2:pc=0000)
;51b778:_l257(use=0:ref=2:pc=0000)
;51c108:_l258(use=0:ref=1:pc=0000)
;51c1a8:_l259(use=0:ref=1:pc=0000)
;51d108:_l260(use=0:ref=2:pc=0000)
;51d168:_l261(use=0:ref=2:pc=0000)
;51d588:_l262(use=0:ref=1:pc=0000)
;51d658:_l263(use=0:ref=1:pc=0000)
;51e5b8:_l264(use=0:ref=2:pc=0000)
;51e618:_l265(use=0:ref=2:pc=0000)
;51ea98:_l266(use=0:ref=1:pc=0000)
;51eb88:_l267(use=0:ref=1:pc=0000)
;520a48:_l268(use=0:ref=2:pc=0000)
;520aa8:_l269(use=0:ref=2:pc=0000)
;520f28:_l270(use=0:ref=1:pc=0000)
;520f68:_l271(use=0:ref=1:pc=0000)
;522d38:_l272(use=0:ref=1:pc=0000)
;522e28:_l273(use=0:ref=1:pc=0000)
;523cc8:_l274(use=0:ref=1:pc=0000)
;523d28:_l275(use=0:ref=1:pc=0000)
;523d88:_l276(use=0:ref=1:pc=0000)
;523f08:_l277(use=0:ref=1:pc=0000)
;524dd8:_l278(use=0:ref=1:pc=0000)
;526c58:_l279(use=0:ref=2:pc=0000)
;526cb8:_l280(use=0:ref=2:pc=0000)
;527778:_l281(use=0:ref=1:pc=0000)
;5277d8:_l282(use=0:ref=1:pc=0000)
;527838:_l283(use=0:ref=1:pc=0000)
;5279b8:_l284(use=0:ref=1:pc=0000)
;528888:_l285(use=0:ref=1:pc=0000)
;52a708:_l286(use=0:ref=2:pc=0000)
;52a768:_l287(use=0:ref=2:pc=0000)
;52abe8:_l288(use=0:ref=1:pc=0000)
;52acd8:_l289(use=0:ref=1:pc=0000)
;530868:_l290(use=0:ref=2:pc=0000)
;5308c8:_l291(use=0:ref=2:pc=0000)
;530d18:_l292(use=0:ref=1:pc=0000)
;530e08:_l293(use=0:ref=1:pc=0000)
;536ce8:_l294(use=0:ref=2:pc=0000)
;536d48:_l295(use=0:ref=2:pc=0000)
;5372f8:_l296(use=0:ref=1:pc=0000)
;5373e8:_l297(use=0:ref=1:pc=0000)
;53a998:_l298(use=0:ref=2:pc=0000)
;53a9f8:_l299(use=0:ref=2:pc=0000)
;53ae48:_l300(use=0:ref=1:pc=0000)
;53af38:_l301(use=0:ref=1:pc=0000)
;53d278:_l302(use=0:ref=2:pc=0000)
;53d2d8:_l303(use=0:ref=2:pc=0000)
;53e108:_l304(use=0:ref=2:pc=0000)
;53e168:_l305(use=0:ref=2:pc=0000)
;53efa8:_l306(use=0:ref=2:pc=0000)
;53e5c8:_l307(use=0:ref=2:pc=0000)
;540a18:_l308(use=0:ref=2:pc=0000)
;540a78:_l309(use=0:ref=2:pc=0000)
;541968:_l310(use=0:ref=2:pc=0000)
;5419c8:_l311(use=0:ref=2:pc=0000)
;542868:_l312(use=0:ref=2:pc=0000)
;5428c8:_l313(use=0:ref=2:pc=0000)
;543788:_l314(use=0:ref=2:pc=0000)
;5437e8:_l315(use=0:ref=2:pc=0000)
;544d78:_l316(use=0:ref=1:pc=0000)
;545588:_l317(use=0:ref=1:pc=0000)
;547388:_l318(use=0:ref=1:pc=0000)
;547a98:_l319(use=5:ref=3:pc=0254)
;548598:_l320(use=5:ref=3:pc=0255)
;5485f8:_l321(use=9:ref=3:pc=02e9)
;548658:_l322(use=0:ref=1:pc=0000)
;54a408:_l323(use=0:ref=1:pc=0000)
;54b4a8:_l324(use=5:ref=3:pc=02e7)
;54ce98:_l325(use=0:ref=2:pc=0000)
;54cef8:_l326(use=0:ref=2:pc=0000)
;54d6c8:_l327(use=0:ref=2:pc=0000)
;54d728:_l328(use=0:ref=2:pc=0000)
;54de08:_l329(use=0:ref=2:pc=0000)
;54de68:_l330(use=0:ref=2:pc=0000)
;54e658:_l331(use=0:ref=2:pc=0000)
;54e6b8:_l332(use=0:ref=2:pc=0000)
;54edf8:_l333(use=0:ref=2:pc=0000)
;54ee58:_l334(use=0:ref=2:pc=0000)
;54f6b8:_l335(use=0:ref=2:pc=0000)
;54f718:_l336(use=0:ref=2:pc=0000)
;54fe58:_l337(use=0:ref=2:pc=0000)
;54feb8:_l338(use=0:ref=2:pc=0000)
;527fc8:_l339(use=0:ref=2:pc=0000)
;529fa8:_l340(use=0:ref=2:pc=0000)
;5504f8:_l341(use=0:ref=2:pc=0000)
;550558:_l342(use=0:ref=2:pc=0000)
;550c08:_l343(use=0:ref=2:pc=0000)
;550db8:_l344(use=0:ref=2:pc=0000)
;551458:_l345(use=0:ref=1:pc=0000)
;551af8:_l346(use=0:ref=1:pc=0000)
;552478:_l347(use=0:ref=1:pc=0000)
;552ca8:_l348(use=0:ref=1:pc=0000)
;552e68:_l349(use=0:ref=1:pc=0000)
;5542f8:_l350(use=0:ref=1:pc=0000)
;554f38:_l351(use=0:ref=1:pc=0000)
;554f98:_l352(use=0:ref=1:pc=0000)
;554168:_l353(use=0:ref=1:pc=0000)
;555248:_l354(use=0:ref=1:pc=0000)
;5554c8:_l355(use=0:ref=1:pc=0000)
;5563f8:_l356(use=0:ref=2:pc=0000)
;556458:_l357(use=0:ref=2:pc=0000)
;557328:_l358(use=5:ref=3:pc=02ee)
;557388:_l359(use=5:ref=3:pc=0300)
;5573e8:_l360(use=0:ref=1:pc=0000)
;5575d8:_l361(use=0:ref=1:pc=0000)
;557858:_l362(use=0:ref=1:pc=0000)
;558838:_l363(use=0:ref=2:pc=0000)
;558898:_l364(use=0:ref=2:pc=0000)
;559668:_l365(use=0:ref=1:pc=0000)
;5596c8:_l366(use=0:ref=1:pc=0000)
;559728:_l367(use=0:ref=1:pc=0000)
;55a728:_l368(use=5:ref=4:pc=030c)
;55a788:_l369(use=0:ref=2:pc=0000)
;55b668:_l370(use=0:ref=1:pc=0000)
;55b6c8:_l371(use=0:ref=1:pc=0000)
;55b728:_l372(use=0:ref=1:pc=0000)
;55da38:_l373(use=0:ref=2:pc=0000)
;55da98:_l374(use=0:ref=2:pc=0000)
;55e408:_l375(use=0:ref=1:pc=0000)
;55e468:_l376(use=0:ref=1:pc=0000)
;55e4c8:_l377(use=0:ref=1:pc=0000)
;560658:_l378(use=0:ref=2:pc=0000)
;5606b8:_l379(use=8:ref=5:pc=032e)
;560a78:_l380(use=0:ref=1:pc=0000)
;561338:_l381(use=5:ref=3:pc=0318)
;5618a8:_l382(use=0:ref=1:pc=0000)
;5618e8:_l383(use=5:ref=3:pc=0321)
;563698:_l384(use=0:ref=2:pc=0000)
;564108:_l385(use=4:ref=4:pc=0354)
;564b08:_l386(use=5:ref=3:pc=0330)
;564b68:_l387(use=0:ref=1:pc=0000)
;564bc8:_l388(use=0:ref=1:pc=0000)
;564d48:_l389(use=0:ref=1:pc=0000)
;5653c8:_l390(use=5:ref=3:pc=034c)
;567c38:_l391(use=0:ref=2:pc=0000)
;567c98:_l392(use=24:ref=9:pc=03aa)
;567f38:_l393(use=0:ref=1:pc=0000)
;568238:_l394(use=5:ref=3:pc=0363)
;5687e8:_l395(use=0:ref=1:pc=0000)
;568bd8:_l396(use=5:ref=3:pc=0371)
;5692e8:_l397(use=0:ref=1:pc=0000)
;5696d8:_l398(use=5:ref=3:pc=037f)
;569ce8:_l399(use=0:ref=1:pc=0000)
;56a1b8:_l400(use=5:ref=3:pc=038d)
;56a7c8:_l401(use=0:ref=1:pc=0000)
;56abb8:_l402(use=5:ref=3:pc=039b)
;56b2e8:_l403(use=0:ref=1:pc=0000)
;56b6d8:_l404(use=5:ref=3:pc=03a9)
;56c4d8:_l405(use=5:ref=4:pc=03aa)
;56c7a8:_l406(use=0:ref=2:pc=0000)
;56d3a8:_l407(use=0:ref=1:pc=0000)
;56d9f8:_l408(use=0:ref=1:pc=0000)
;56de98:_l409(use=0:ref=1:pc=0000)
;56e588:_l410(use=0:ref=1:pc=0000)
;56e948:_l411(use=0:ref=1:pc=0000)
;56efc8:_l412(use=0:ref=1:pc=0000)
;56ff78:_l413(use=0:ref=1:pc=0000)
;570438:_l414(use=0:ref=1:pc=0000)
;571c98:_l415(use=0:ref=1:pc=0000)
;572338:_l416(use=0:ref=1:pc=0000)
;5727d8:_l417(use=0:ref=1:pc=0000)
;572ad8:_l418(use=0:ref=1:pc=0000)
;572c58:_l419(use=0:ref=1:pc=0000)
;573438:_l420(use=0:ref=1:pc=0000)
;574388:_l421(use=0:ref=1:pc=0000)
;5749b8:_l422(use=0:ref=1:pc=0000)
;575208:_l423(use=0:ref=1:pc=0000)
;575738:_l424(use=0:ref=1:pc=0000)
;57aa58:_l425(use=0:ref=2:pc=0000)
;57aab8:_l426(use=0:ref=2:pc=0000)
;57ad88:_l427(use=0:ref=1:pc=0000)
;57b438:_l428(use=9:ref=3:pc=03e1)
;57d238:_l429(use=5:ref=4:pc=040c)
;57d298:_l430(use=0:ref=2:pc=0000)
;57d538:_l431(use=0:ref=1:pc=0000)
;57d5f8:_l432(use=0:ref=1:pc=0000)
;57e508:_l433(use=0:ref=1:pc=0000)
;57eae8:_l434(use=0:ref=1:pc=0000)
;57fd08:_l435(use=5:ref=3:pc=040f)
;57fd68:_l436(use=0:ref=1:pc=0000)
;57fdc8:_l437(use=0:ref=1:pc=0000)
;5809b8:_l438(use=0:ref=1:pc=0000)
;580b68:_l439(use=0:ref=1:pc=0000)
;581b18:_l440(use=14:ref=4:pc=0429)
;581b78:_l441(use=0:ref=1:pc=0000)
;582a68:_l442(use=5:ref=3:pc=0432)
;582b38:_l443(use=0:ref=1:pc=0000)
;582ee8:_l444(use=0:ref=1:pc=0000)
;582fb8:_l445(use=0:ref=1:pc=0000)
;583828:_l446(use=9:ref=3:pc=0459)
;5838f8:_l447(use=0:ref=1:pc=0000)
;5842e8:_l448(use=5:ref=3:pc=0461)
;5843b8:_l449(use=0:ref=1:pc=0000)
;584848:_l450(use=5:ref=3:pc=0464)
;584918:_l451(use=0:ref=1:pc=0000)
;5857b8:_l452(use=0:ref=1:pc=0000)
;585888:_l453(use=0:ref=1:pc=0000)
;585d18:_l454(use=0:ref=1:pc=0000)
;585de8:_l455(use=0:ref=1:pc=0000)
;586108:_l456(use=5:ref=3:pc=0490)
;5861d8:_l457(use=0:ref=1:pc=0000)
;586728:_l458(use=5:ref=3:pc=0494)
;5867f8:_l459(use=0:ref=1:pc=0000)
;586938:_l460(use=6:ref=4:pc=0494)
;5c13a8:_l461(use=2:ref=1:pc=0043)
;5c1408:_l462(use=2:ref=1:pc=0046)
;5c1c08:_l463(use=0:ref=1:pc=0052)
;5c1c68:_l464(use=0:ref=1:pc=0000)
;5c33a8:_l465(use=0:ref=1:pc=0071)
;5c36e8:_l466(use=2:ref=1:pc=0077)
;5c5ca8:_l467(use=0:ref=1:pc=00ba)
;5c5d08:_l468(use=0:ref=1:pc=0000)
;5c89a8:_l469(use=0:ref=1:pc=00fd)
;5c8ce8:_l470(use=2:ref=1:pc=0103)
;5c9ea8:_l471(use=0:ref=1:pc=0120)
;5ca3a8:_l472(use=0:ref=1:pc=0126)
;5cb9a8:_l473(use=0:ref=1:pc=0148)
;5cbce8:_l474(use=0:ref=1:pc=014e)
;5cd828:_l475(use=0:ref=1:pc=0176)
;5cdb68:_l476(use=2:ref=1:pc=017c)
;5ce528:_l477(use=0:ref=1:pc=018a)
;5ce908:_l478(use=0:ref=1:pc=0190)
;5cfea8:_l479(use=0:ref=1:pc=01b2)
;5d0328:_l480(use=2:ref=1:pc=01b8)
;5d1ea8:_l481(use=0:ref=1:pc=01ea)
;5d1f08:_l482(use=0:ref=1:pc=0000)
;5d3928:_l483(use=0:ref=1:pc=020e)
;5d3c68:_l484(use=2:ref=1:pc=0214)
;5df808:_l485(use=6:ref=1:pc=0364)
;5e0c48:_l486(use=0:ref=1:pc=036a)
;5e6ba8:_l487(use=0:ref=1:pc=0418)
;5e6c08:_l488(use=0:ref=1:pc=0000)
;5e9108:_l489(use=3:ref=1:pc=044a)
;5e9168:_l490(use=3:ref=1:pc=044c)
;5eb9e8:_l491(use=0:ref=1:pc=048a)
;5ebd58:_l492(use=2:ref=1:pc=0490)
;5f03a8:_l493(use=2:ref=1:pc=0504)
;5f0408:_l494(use=2:ref=1:pc=0507)
;5f1888:_l495(use=2:ref=1:pc=0524)
;5f18e8:_l496(use=2:ref=1:pc=0527)
;5f2d68:_l497(use=2:ref=1:pc=0544)
;5f2dc8:_l498(use=2:ref=1:pc=0547)
;5f4328:_l499(use=2:ref=1:pc=0564)
;5f4388:_l500(use=2:ref=1:pc=0567)
;5f5808:_l501(use=2:ref=1:pc=0584)
;5f5868:_l502(use=2:ref=1:pc=0587)
;5f6ce8:_l503(use=2:ref=1:pc=05a4)
;5f6d48:_l504(use=2:ref=1:pc=05a7)
;5faa08:_l505(use=2:ref=1:pc=0600)
;5fb228:_l506(use=0:ref=1:pc=0606)
;5fe888:_l507(use=2:ref=1:pc=0664)
;5fefa8:_l508(use=0:ref=1:pc=066a)
;5ffc28:_l509(use=2:ref=1:pc=0683)
;5ffc88:_l510(use=2:ref=1:pc=0680)
;6021a8:_l511(use=2:ref=1:pc=06bd)
;602208:_l512(use=2:ref=1:pc=06c0)
;602de8:_l513(use=0:ref=1:pc=06cb)
;603228:_l514(use=0:ref=1:pc=06d1)
;606728:_l515(use=2:ref=1:pc=072f)
;606788:_l516(use=2:ref=1:pc=0732)
;60eb98:_l517(use=2:ref=1:pc=0000)
;60ebf8:_l518(use=2:ref=1:pc=0000)
;60ec58:_l519(use=2:ref=1:pc=0000)
;60ecb8:_l520(use=2:ref=1:pc=0000)
;610328:_l521(use=2:ref=1:pc=0000)
;6119e8:_l522(use=2:ref=1:pc=0000)
;613c28:_l523(use=6:ref=1:pc=0000)
;61a938:_l524(use=2:ref=1:pc=0072)
;61a998:_l525(use=2:ref=1:pc=00a1)
;61a9f8:_l526(use=2:ref=1:pc=0092)
;61aa58:_l527(use=2:ref=1:pc=0059)
;61abd8:_l528(use=2:ref=1:pc=0069)
;61ad58:_l529(use=2:ref=1:pc=006c)
;61ae18:_l530(use=6:ref=1:pc=008e)
;61b138:_l531(use=2:ref=1:pc=00e7)
;61b198:_l532(use=2:ref=1:pc=00e9)
;61b218:_l533(use=0:ref=1:pc=00ed)
;61b278:_l534(use=0:ref=1:pc=0000)
;61b2d8:_l535(use=0:ref=1:pc=00fc)
;61b398:_l536(use=2:ref=1:pc=0100)
;61b458:_l537(use=0:ref=1:pc=011f)
;61b4b8:_l538(use=0:ref=1:pc=0000)
;61b638:_l539(use=0:ref=1:pc=013a)
;61b6f8:_l540(use=2:ref=1:pc=013e)
;61b758:_l541(use=0:ref=1:pc=0149)
;61b7b8:_l542(use=0:ref=1:pc=014d)
;61b8d8:_l543(use=0:ref=1:pc=015a)
;61b998:_l544(use=0:ref=1:pc=015e)
;61bab8:_l545(use=0:ref=1:pc=0172)
;61bb78:_l546(use=2:ref=1:pc=0176)
;61bbd8:_l547(use=0:ref=1:pc=017b)
;61bc38:_l548(use=0:ref=1:pc=017f)
;61bd58:_l549(use=0:ref=1:pc=0190)
;61be18:_l550(use=2:ref=1:pc=0194)
;61bfb8:_l551(use=0:ref=1:pc=01a8)
;61c128:_l552(use=0:ref=1:pc=0000)
;61c1e8:_l553(use=0:ref=1:pc=01ba)
;61c2a8:_l554(use=2:ref=1:pc=01be)
;61ca88:_l555(use=6:ref=1:pc=0268)
;61cce8:_l556(use=0:ref=1:pc=026c)
;61cda8:_l557(use=0:ref=1:pc=02d5)
;61ce08:_l558(use=0:ref=1:pc=0000)
;61cf58:_l559(use=3:ref=1:pc=02f2)
;61cfb8:_l560(use=3:ref=1:pc=02f4)
;61d368:_l561(use=0:ref=1:pc=031a)
;61d458:_l562(use=2:ref=1:pc=031e)
;61e358:_l563(use=2:ref=1:pc=03d6)
;61e478:_l564(use=0:ref=1:pc=03da)
;61e978:_l565(use=2:ref=1:pc=0405)
;61ea98:_l566(use=0:ref=1:pc=0409)
;61eaf8:_l567(use=2:ref=1:pc=0414)
;61eb58:_l568(use=2:ref=1:pc=0413)
;61ed38:_l569(use=0:ref=1:pc=0434)
;61edf8:_l570(use=0:ref=1:pc=0438)
;Unnamed Constant Variables
;============
