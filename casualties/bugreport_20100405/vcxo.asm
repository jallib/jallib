; compiler: jal 2.4n-beta (compiled Mar 13 2010)

; command line:  c:\jallib\compiler\jalv2.exe vcxo.jal -long-start -s "c:\jallib\include;c:\jallib\include\device;c:\jallib\include\external;c:\jallib\include\external\can;c:\jallib\include\external\co2;c:\jallib\include\external\humidity;c:\jallib\include\external\keyboard;c:\jallib\include\external\lcd;c:\jallib\include\external\media;c:\jallib\include\external\motor;c:\jallib\include\external\motor\dc;c:\jallib\include\external\motor\period_skip;c:\jallib\include\external\motor\servo;c:\jallib\include\external\motor\stepper;c:\jallib\include\external\ranger;c:\jallib\include\external\ranger\ir;c:\jallib\include\external\ranger\us;c:\jallib\include\external\rtc;c:\jallib\include\external\seven_segment;c:\jallib\include\external\storage;c:\jallib\include\external\storage\eeprom;c:\jallib\include\external\storage\harddisk;c:\jallib\include\external\storage\ram;c:\jallib\include\external\storage\ram\23k256;c:\jallib\include\external\storage\sd_card;c:\jallib\include\external\temperature;c:\jallib\include\filesystem;c:\jallib\include\jal;c:\jallib\include\peripheral;c:\jallib\include\peripheral\adc;c:\jallib\include\peripheral\can;c:\jallib\include\peripheral\comparator;c:\jallib\include\peripheral\data_eeprom;c:\jallib\include\peripheral\flash_memory;c:\jallib\include\peripheral\i2c;c:\jallib\include\peripheral\pwm;c:\jallib\include\peripheral\spi;c:\jallib\include\peripheral\timer;c:\jallib\include\peripheral\usart;c:\jallib\include\peripheral\usb;c:\jallib\include\protocol;c:\jallib\test;c:\jallib\test\board;c:\jallib\test\external;c:\jallib\test\external\keyboard;c:\jallib\test\external\lcd;c:\jallib\test\external\ranger;c:\jallib\test\external\ranger\ir;c:\jallib\test\external\rtc;c:\jallib\test\external\seven_segment;c:\jallib\test\jal;c:\jallib\test\peripheral;c:\jallib\test\peripheral\adc;c:\jallib\test\peripheral\comparator;c:\jallib\test\peripheral\data_eeprom;c:\jallib\test\peripheral\flash_memory;c:\jallib\test\peripheral\i2c;c:\jallib\test\peripheral\pwm;c:\jallib\test\peripheral\spi;c:\jallib\test\peripheral\timer;c:\jallib\test\peripheral\usart;c:\jallib\test\peripheral\usb;c:\jallib\test\unittest;"
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
v__porta_shadow                EQU 0x0042  ; _porta_shadow
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
v_dummy                        EQU 0x006b  ; dummy-->_bitbucket:0
v_serial_xmtbufsize            EQU 80
v_serial_rcvbufsize            EQU 12
v_serial_delta                 EQU 17
v__serial_xmtbuf               EQU 0x00a0  ; _serial_xmtbuf
v__serial_rcvbuf               EQU 0x0043  ; _serial_rcvbuf
v__serial_offsetxmthead        EQU 0x004f  ; _serial_offsetxmthead
v__serial_offsetxmttail        EQU 0x0050  ; _serial_offsetxmttail
v__serial_offsetrcvhead        EQU 0x0051  ; _serial_offsetrcvhead
v__serial_offsetrcvtail        EQU 0x0052  ; _serial_offsetrcvtail
v_serial_send_success          EQU 0x006b  ; serial_send_success-->_bitbucket:1
v_ascii_lf                     EQU 10
v_ascii_cr                     EQU 13
v_gpsinbuffer                  EQU 0x0053  ; gpsinbuffer
v_gpsinbufferindex             EQU 0x0067  ; gpsinbufferindex
v_gpsmsgnr                     EQU 0x0037  ; gpsmsgnr
v_gpsfieldnr                   EQU 0x0068  ; gpsfieldnr
v_gpserrorcode                 EQU 0x0069  ; gpserrorcode
v_ticks                        EQU 0x0038  ; ticks
v__floop7                      EQU 0x006a  ; _floop7
v__bitbucket                   EQU 0x006b  ; _bitbucket
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
v__btemp79                     EQU 0x006b  ; _btemp79-->_bitbucket:2
v___x_69                       EQU 0x0042  ; x-->_porta_shadow:2
v___char_7                     EQU 0x006d  ; char
v____btemp67_1                 EQU 0x006b  ; _btemp67-->_bitbucket:4
v____btemp73_1                 EQU 0x006b  ; _btemp73-->_bitbucket:10
v___duty_1                     EQU 0x006e  ; setdutycycle:duty
v____temp_46                   EQU 0       ; gpstakt(): _temp
v__btemp61                     EQU 0x006e  ; parsemessageid:_btemp61-->_bitbucket4:0
v__btemp62                     EQU 0x006e  ; parsemessageid:_btemp62-->_bitbucket4:1
v__btemp63                     EQU 0x006e  ; parsemessageid:_btemp63-->_bitbucket4:2
v__btemp64                     EQU 0x006e  ; parsemessageid:_btemp64-->_bitbucket4:3
v__btemp65                     EQU 0x006e  ; parsemessageid:_btemp65-->_bitbucket4:4
v__btemp66                     EQU 0x006e  ; parsemessageid:_btemp66-->_bitbucket4:5
v____bitbucket_4               EQU 0x006e  ; parsemessageid:_bitbucket
v___name_1                     EQU 0x0120  ; ismsg:name
v___i_2                        EQU 0x0124  ; ismsg:i
v___char_5                     EQU 0x006e  ; storebytes:char
v___n_3                        EQU 0x006e  ; delay_1ms:n
v__floop4                      EQU 0x0122  ; delay_1ms:_floop4
v____device_put_19             EQU 0x006e  ; print_byte_dec:_device_put
v___data_49                    EQU 0x0122  ; print_byte_dec:data
v____device_put_1              EQU 0x006e  ; print_string:_device_put
v__str_count                   EQU 0x0122  ; print_string:_str_count
v___str_1                      EQU 0x0126  ; print_string:str
v_len                          EQU 0x012c  ; print_string:len
v_i                            EQU 0x012e  ; print_string:i
v__device_put                  EQU 0x006e  ; print_crlf:_device_put
v____device_put_21             EQU 0x0124  ; _print_universal_dec:_device_put
v___data_53                    EQU 0x0128  ; _print_universal_dec:data
v___digit_divisor_5            EQU 0x012f  ; _print_universal_dec:digit_divisor
v___digit_number_5             EQU 0x0133  ; _print_universal_dec:digit_number
v_digit                        EQU 0x0134  ; _print_universal_dec:digit
v_no_digits_printed_yet        EQU 0x0136  ; _print_universal_dec:no_digits_printed_yet-->_bitbucket42:0
v____temp_42                   EQU 0x0135  ; _print_universal_dec:_temp
v____bitbucket_42              EQU 0x0136  ; _print_universal_dec:_bitbucket
v__btemp47                     EQU 0x0136  ; _print_universal_dec:_btemp47-->_bitbucket42:3
v__btemp48                     EQU 0x0136  ; _print_universal_dec:_btemp48-->_bitbucket42:4
v__btemp49                     EQU 0x0136  ; _print_universal_dec:_btemp49-->_bitbucket42:5
v____temp_29                   EQU 0       ; serial_hw_write(): _temp
v___data_7                     EQU 0x003e  ; _serial_hw_data_put:data
v____temp_28                   EQU 0       ; _serial_hw_data_put(): _temp
v___data_5                     EQU 0x003f  ; serial_send_byte:data
v_newxmthead                   EQU 0x0040  ; serial_send_byte:newxmthead
v__btemp23                     EQU 0x0041  ; serial_send_byte:_btemp23-->_bitbucket50:0
v__btemp24                     EQU 0x0041  ; serial_send_byte:_btemp24-->_bitbucket50:1
v__btemp25                     EQU 0x0041  ; serial_send_byte:_btemp25-->_bitbucket50:2
v____bitbucket_50              EQU 0x0041  ; serial_send_byte:_bitbucket
v___data_1                     EQU 0x006e  ; serial_hw_read:data
v___x_68                       EQU 0x0120  ; serial_hw_read:x
v____temp_26                   EQU 0x0122  ; serial_hw_read:_temp
v___x_67                       EQU 0x003a  ; _serial_receive_interrupt_handler:x
v____temp_25                   EQU 0x003b  ; _serial_receive_interrupt_handler:_temp
v____bitbucket_53              EQU 0x003c  ; _serial_receive_interrupt_handler:_bitbucket
v__btemp8                      EQU 0x003c  ; _serial_receive_interrupt_handler:_btemp8-->_bitbucket53:1
v__btemp9                      EQU 0x003c  ; _serial_receive_interrupt_handler:_btemp9-->_bitbucket53:2
v__btemp10                     EQU 0x003c  ; _serial_receive_interrupt_handler:_btemp10-->_bitbucket53:3
v___x_66                       EQU 0x003a  ; _serial_transmit_interrupt_handler:x
v__btemp1                      EQU 0x003b  ; _serial_transmit_interrupt_handler:_btemp1-->_bitbucket54:0
v__btemp2                      EQU 0x003b  ; _serial_transmit_interrupt_handler:_btemp2-->_bitbucket54:1
v__btemp3                      EQU 0x003b  ; _serial_transmit_interrupt_handler:_btemp3-->_bitbucket54:2
v____bitbucket_54              EQU 0x003b  ; _serial_transmit_interrupt_handler:_bitbucket
v_usart_div                    EQU 520     ; _calculate_and_set_baudrate(): usart_div
;   22 include 16f690
                               org      0
                               branchhi_clr l__main
                               branchlo_clr l__main
                               goto     l__main
                               nop      
                               org      4
                               movwf    v__pic_isr_w
                               swapf    v__status,w
                               clrf     v__status
                               movwf    v__pic_isr_status
                               movf     v__pclath,w
                               movwf    v__pic_isr_pclath
                               clrf     v__pclath
                               movf     v__fsr,w
                               movwf    v__pic_isr_fsr
                               branchlo_clr l_isr
                               goto     l_isr
                               addwf    v__pcl,f
l__data_str1_2
                               retlw    86
                               retlw    99
                               retlw    120
                               retlw    111
                               retlw    32
                               retlw    86
                               retlw    48
                               retlw    46
                               retlw    49
                               retlw    10
                               addwf    v__pcl,f
l__data_str_error
                               retlw    69
                               retlw    114
                               retlw    114
                               retlw    111
                               retlw    114
                               retlw    32
                               addwf    v__pcl,f
l__data_str_gpgsv
                               retlw    71
                               retlw    80
                               retlw    71
                               retlw    83
                               retlw    86
                               addwf    v__pcl,f
l__data_str_gpgga
                               retlw    71
                               retlw    80
                               retlw    71
                               retlw    71
                               retlw    65
                               addwf    v__pcl,f
l__data_str_gpvtg
                               retlw    71
                               retlw    80
                               retlw    86
                               retlw    84
                               retlw    71
                               addwf    v__pcl,f
l__data_str_gpgsa
                               retlw    71
                               retlw    80
                               retlw    71
                               retlw    83
                               retlw    65
                               addwf    v__pcl,f
l__data_str_gpgll
                               retlw    71
                               retlw    80
                               retlw    71
                               retlw    76
                               retlw    76
                               addwf    v__pcl,f
l__data_str_gprmc
                               retlw    71
                               retlw    80
                               retlw    82
                               retlw    77
                               retlw    67
                               addwf    v__pcl,f
l__data_str_msg
                               retlw    77
                               retlw    115
                               retlw    103
                               retlw    32
l__pic_sdivide
                               movlw    0
                               btfss    v__pic_dividend+3, 7
                               goto     l__l526
                               comf     v__pic_dividend,f
                               comf     v__pic_dividend+1,f
                               comf     v__pic_dividend+2,f
                               comf     v__pic_dividend+3,f
                               incf     v__pic_dividend,f
                               btfsc    v__status, v__z
                               incf     v__pic_dividend+1,f
                               btfsc    v__status, v__z
                               incf     v__pic_dividend+2,f
                               btfsc    v__status, v__z
                               incf     v__pic_dividend+3,f
                               movlw    1
l__l526
                               movwf    v__pic_sign
                               movlw    0
                               btfss    v__pic_divisor+3, 7
                               goto     l__l527
                               comf     v__pic_divisor,f
                               comf     v__pic_divisor+1,f
                               comf     v__pic_divisor+2,f
                               comf     v__pic_divisor+3,f
                               incf     v__pic_divisor,f
                               btfsc    v__status, v__z
                               incf     v__pic_divisor+1,f
                               btfsc    v__status, v__z
                               incf     v__pic_divisor+2,f
                               btfsc    v__status, v__z
                               incf     v__pic_divisor+3,f
                               movlw    1
l__l527
                               xorwf    v__pic_sign,f
                               goto     l__l528
l__pic_divide
                               clrf     v__pic_sign
l__l528
                               movlw    32
                               movwf    v__pic_loop
                               clrf     v__pic_remainder
                               clrf     v__pic_remainder+1
                               clrf     v__pic_remainder+2
                               clrf     v__pic_remainder+3
l__l523
                               bcf      v__status, v__c
                               rlf      v__pic_quotient,f
                               rlf      v__pic_quotient+1,f
                               rlf      v__pic_quotient+2,f
                               rlf      v__pic_quotient+3,f
                               bcf      v__status, v__c
                               rlf      v__pic_divaccum,f
                               rlf      v__pic_divaccum+1,f
                               rlf      v__pic_divaccum+2,f
                               rlf      v__pic_divaccum+3,f
                               rlf      v__pic_divaccum+4,f
                               rlf      v__pic_divaccum+5,f
                               rlf      v__pic_divaccum+6,f
                               rlf      v__pic_divaccum+7,f
                               movf     v__pic_remainder+3,w
                               subwf    v__pic_divisor+3,w
                               btfss    v__status, v__z
                               goto     l__l529
                               movf     v__pic_remainder+2,w
                               subwf    v__pic_divisor+2,w
                               btfss    v__status, v__z
                               goto     l__l529
                               movf     v__pic_remainder+1,w
                               subwf    v__pic_divisor+1,w
                               btfss    v__status, v__z
                               goto     l__l529
                               movf     v__pic_remainder,w
                               subwf    v__pic_divisor,w
l__l529
                               btfsc    v__status, v__z
                               goto     l__l525
                               btfsc    v__status, v__c
                               goto     l__l524
l__l525
                               movf     v__pic_divisor,w
                               subwf    v__pic_remainder,f
                               movf     v__pic_divisor+1,w
                               btfss    v__status, v__c
                               incfsz   v__pic_divisor+1,w
                               subwf    v__pic_remainder+1,f
                               movf     v__pic_divisor+2,w
                               btfss    v__status, v__c
                               incfsz   v__pic_divisor+2,w
                               subwf    v__pic_remainder+2,f
                               movf     v__pic_divisor+3,w
                               btfss    v__status, v__c
                               incfsz   v__pic_divisor+3,w
                               subwf    v__pic_remainder+3,f
                               bsf      v__pic_quotient, 0
l__l524
                               decfsz   v__pic_loop,f
                               goto     l__l523
                               movf     v__pic_sign,w
                               btfsc    v__status, v__z
                               return   
                               comf     v__pic_quotient,f
                               comf     v__pic_quotient+1,f
                               comf     v__pic_quotient+2,f
                               comf     v__pic_quotient+3,f
                               incf     v__pic_quotient,f
                               btfsc    v__status, v__z
                               incf     v__pic_quotient+1,f
                               btfsc    v__status, v__z
                               incf     v__pic_quotient+2,f
                               btfsc    v__status, v__z
                               incf     v__pic_quotient+3,f
                               comf     v__pic_remainder,f
                               comf     v__pic_remainder+1,f
                               comf     v__pic_remainder+2,f
                               comf     v__pic_remainder+3,f
                               incf     v__pic_remainder,f
                               btfsc    v__status, v__z
                               incf     v__pic_remainder+1,f
                               btfsc    v__status, v__z
                               incf     v__pic_remainder+2,f
                               btfsc    v__status, v__z
                               incf     v__pic_remainder+3,f
                               return   
l__pic_indirect
                               movwf    v__pclath
                               datahi_clr v__pic_pointer
                               movf     v__pic_pointer,w
                               movwf    v__pcl
l__main
; c:\jallib\include\device/16f690.jal
;   96 var          byte  _PORTA_shadow        = PORTA
                               movf     v_porta,w
                               movwf    v__porta_shadow
; vcxo.jal
;   30 pin_a2_direction =  output
                               datalo_set v_trisa ; pin_a2_direction
                               bcf      v_trisa, 2 ; pin_a2_direction
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  867    ANSEL  = 0b0000_0000       -- all digital
                               datalo_clr v_ansel
                               datahi_set v_ansel
                               clrf     v_ansel
;  868    ANSELH = 0b0000_0000       -- all digital
                               clrf     v_anselh
; vcxo.jal
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  891    analog_off()
; vcxo.jal
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  875    ADCON0 = 0b0000_0000         -- disable ADC
                               datahi_clr v_adcon0
                               clrf     v_adcon0
;  876    ADCON1 = 0b0000_0000
                               datalo_set v_adcon1
                               clrf     v_adcon1
; vcxo.jal
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  892    adc_off()
; vcxo.jal
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  883    CM1CON0 = 0b0000_0000       -- disable comparator
                               datalo_clr v_cm1con0
                               datahi_set v_cm1con0
                               clrf     v_cm1con0
;  884    CM2CON0 = 0b0000_0000       -- disable 2nd comparator
                               clrf     v_cm2con0
; vcxo.jal
;   32 enable_digital_io()
; c:\jallib\include\device/16f690.jal
;  893    comparator_off()
; vcxo.jal
;   32 enable_digital_io()
;   34 OPTION_REG_NRAPU = false -- enable pull-up on port A
                               datalo_set v_option_reg ; option_reg_nrapu
                               bcf      v_option_reg, 7 ; option_reg_nrapu
;   35 WPUA = 0b0000_0100          -- pull-up off voor alle pins behalve A2.
                               movlw    4
                               datahi_clr v_wpua
                               movwf    v_wpua
; c:\jallib\include\peripheral\usart/serial_hw_int_cts.jal
;  134 end if
                               goto     l__l225
; c:\jallib\include\peripheral\usart/usart_common.jal
;   43 procedure _calculate_and_set_baudrate() is
l__calculate_and_set_baudrate
;   49          BAUDCTL_BRG16 = true
                               bsf      v_baudctl, 3 ; baudctl_brg16
;   50          TXSTA_BRGH = true
                               bsf      v_txsta, 2 ; txsta_brgh
;   65          SPBRG = byte(usart_div)
                               movlw    8
                               movwf    v_spbrg
;   66          SPBRGH = byte(usart_div >> 8)
                               movlw    2
                               movwf    v_spbrgh
;  152 end procedure
                               return   
; c:\jallib\include\peripheral\usart/serial_hw_int_cts.jal
;  176 procedure  _serial_transmit_interrupt_handler() is
l__serial_transmit_interrupt_handler
;  182    if ((PIR1_TXIF == TRUE) & (PIE1_TXIE == TRUE)) then          -- UART xmit interrupt
                               bcf      v____bitbucket_54, 0 ; _btemp1
                               btfsc    v_pir1, 4 ; pir1_txif
                               bsf      v____bitbucket_54, 0 ; _btemp1
                               datalo_set v_pie1 ; pie1_txie
                               btfsc    v_pie1, 4 ; pie1_txie
                               goto     l__l530
                               datalo_clr v____bitbucket_54 ; _btemp2
                               bcf      v____bitbucket_54, 1 ; _btemp2
                               goto     l__l531
l__l530
                               datalo_clr v____bitbucket_54 ; _btemp2
                               bsf      v____bitbucket_54, 1 ; _btemp2
l__l531
                               bsf      v____bitbucket_54, 2 ; _btemp3
                               btfsc    v____bitbucket_54, 0 ; _btemp1
                               btfss    v____bitbucket_54, 1 ; _btemp2
                               bcf      v____bitbucket_54, 2 ; _btemp3
                               btfss    v____bitbucket_54, 2 ; _btemp3
                               goto     l__l157
;  183       if (_serial_offsetxmttail != _serial_offsetxmthead) then  -- data in xmit buffer
                               movf     v__serial_offsetxmttail,w
                               subwf    v__serial_offsetxmthead,w
                               btfsc    v__status, v__z
                               goto     l__l156
;  184          x = _serial_xmtbuf[_serial_offsetxmttail]              -- next byte to xmit
                               movlw    v__serial_xmtbuf
                               addwf    v__serial_offsetxmttail,w
                               movwf    v__fsr
                               irp_clr  
                               movf     v__ind,w
                               movwf    v___x_66
;  185          _serial_offsetxmttail = _serial_offsetxmttail + 1      -- next position
                               incf     v__serial_offsetxmttail,f
;  186          if (_serial_offsetxmttail >= SERIAL_XMTBUFSIZE) then   -- beyond buffer
                               movlw    80
                               subwf    v__serial_offsetxmttail,w
                               btfsc    v__status, v__z
                               goto     l__l535
                               btfss    v__status, v__c
                               goto     l__l161
l__l535
;  187             _serial_offsetxmttail = 0           -- wrap to begin
                               clrf     v__serial_offsetxmttail
;  188          end if
l__l161
;  189          if (_serial_offsetxmttail == _serial_offsetxmthead) then  -- last byte xmt'd
                               movf     v__serial_offsetxmttail,w
                               subwf    v__serial_offsetxmthead,w
                               btfss    v__status, v__z
                               goto     l__l163
;  190             PIE1_TXIE = FALSE                   -- disable xmit interrupts
                               datalo_set v_pie1 ; pie1_txie
                               bcf      v_pie1, 4 ; pie1_txie
;  191          end if
l__l163
;  192          TXREG = x                              -- actually xmit byte
                               datalo_clr v___x_66
                               movf     v___x_66,w
                               movwf    v_txreg
;  194    end if
l__l157
l__l156
;  196 end procedure
                               movf     v__pic_isr_fsr,w
                               movwf    v__fsr
                               movf     v__pic_isr_pclath,w
                               movwf    v__pclath
                               swapf    v__pic_isr_status,w
                               movwf    v__status
                               swapf    v__pic_isr_w,f
                               swapf    v__pic_isr_w,w
                               retfie   
;  206 procedure  _serial_receive_interrupt_handler() is
l__serial_receive_interrupt_handler
;  212    if  (PIR1_RCIF == TRUE)  then                -- UART receive interrupt
                               btfss    v_pir1, 5 ; pir1_rcif
                               goto     l__serial_transmit_interrupt_handler
;  214       if ((RCSTA_OERR == TRUE) | (RCSTA_FERR == TRUE)) then  -- frame/overr error
                               bcf      v____bitbucket_53, 1 ; _btemp8
                               btfsc    v_rcsta, 1 ; rcsta_oerr
                               bsf      v____bitbucket_53, 1 ; _btemp8
                               bcf      v____bitbucket_53, 2 ; _btemp9
                               btfsc    v_rcsta, 2 ; rcsta_ferr
                               bsf      v____bitbucket_53, 2 ; _btemp9
                               bcf      v____bitbucket_53, 3 ; _btemp10
                               btfss    v____bitbucket_53, 1 ; _btemp8
                               btfsc    v____bitbucket_53, 2 ; _btemp9
                               bsf      v____bitbucket_53, 3 ; _btemp10
                               btfss    v____bitbucket_53, 3 ; _btemp10
                               goto     l__l169
;  215          x = RCREG                              -- flush hardware buffer
                               movf     v_rcreg,w
                               movwf    v___x_67
;  216          while RCSTA_OERR == TRUE loop          -- overrun state
l__l170
                               btfss    v_rcsta, 1 ; rcsta_oerr
                               goto     l__l171
;  217             RCSTA_CREN = FALSE                  -- disable UART
                               bcf      v_rcsta, 4 ; rcsta_cren
;  218             RCSTA_CREN = TRUE                   -- re-enable UART
                               bsf      v_rcsta, 4 ; rcsta_cren
;  219             x = RCREG                           -- \  flush hardware buffers
                               movf     v_rcreg,w
                               movwf    v___x_67
;  220             x = RCREG                           -- /
                               movf     v_rcreg,w
                               movwf    v___x_67
;  221          end loop                               -- until no more overrun
                               goto     l__l170
l__l171
;  222          _serial_offsetrcvtail = 0              -- \  flush circular buffer
                               clrf     v__serial_offsetrcvtail
;  223          _serial_offsetrcvhead = 0              -- /
                               clrf     v__serial_offsetrcvhead
;  224          serial_ctsinv = FALSE                  -- ensure CTS true
                               bcf      v__bitbucket, 0 ; dummy
;  226       else                                      -- data without errors
                               goto     l__serial_transmit_interrupt_handler
l__l169
;  227          _serial_rcvbuf[_serial_offsetrcvhead] = RCREG      -- move byte to rcv buffer
                               movlw    v__serial_rcvbuf
                               addwf    v__serial_offsetrcvhead,w
                               movwf    v__fsr
                               irp_clr  
                               movf     v_rcreg,w
                               movwf    v__ind
;  247          x = _serial_offsetrcvhead + 1          -- update offset
                               incf     v__serial_offsetrcvhead,w
                               movwf    v___x_67
;  248          if x >= SERIAL_RCVBUFSIZE then         -- buffer overflow
                               movlw    12
                               subwf    v___x_67,w
                               btfsc    v__status, v__z
                               goto     l__l539
                               btfss    v__status, v__c
                               goto     l__l175
l__l539
;  249             x = 0                               -- wrap
                               clrf     v___x_67
;  250          end if
l__l175
;  251          if (x != _serial_offsetrcvtail) then   -- buffer not yet full
                               movf     v___x_67,w
                               subwf    v__serial_offsetrcvtail,w
                               btfsc    v__status, v__z
                               goto     l__l177
;  252             _serial_offsetrcvhead = x           -- update offset
                               movf     v___x_67,w
                               movwf    v__serial_offsetrcvhead
;  253          end if                                 -- (else discard byte,
l__l177
;  255          if (serial_ctsinv == FALSE) then       -- CTS is TRUE
                               btfsc    v__bitbucket, 0 ; dummy
                               goto     l__serial_transmit_interrupt_handler
;  256             if _serial_offsetrcvhead > _serial_offsetrcvtail then  -- offset difference
                               movf     v__serial_offsetrcvhead,w
                               subwf    v__serial_offsetrcvtail,w
                               btfsc    v__status, v__z
                               goto     l__l181
                               btfsc    v__status, v__c
                               goto     l__l181
;  257                x = SERIAL_RCVBUFSIZE - _serial_offsetrcvhead + _serial_offsetrcvtail
                               comf     v__serial_offsetrcvhead,w
                               movwf    v____temp_25
                               movlw    13
                               addwf    v____temp_25,f
                               movf     v__serial_offsetrcvtail,w
                               addwf    v____temp_25,w
                               movwf    v___x_67
;  258             else
                               goto     l__l180
l__l181
;  259                x = _serial_offsetrcvtail - _serial_offsetrcvhead
                               movf     v__serial_offsetrcvhead,w
                               subwf    v__serial_offsetrcvtail,w
                               movwf    v___x_67
;  260             end if
l__l180
;  261             if (x < SERIAL_DELTA) then          -- circular buffer almost full
                               movlw    17
                               subwf    v___x_67,w
                               btfsc    v__status, v__z
                               goto     l__l178
                               btfsc    v__status, v__c
                               goto     l__l178
;  262                serial_ctsinv = TRUE             -- set CTS FALSE
                               bsf      v__bitbucket, 0 ; dummy
;  264          end if
                               goto     l__serial_transmit_interrupt_handler
l__l178
;  266       end if
;  268    end if
                               goto     l__serial_transmit_interrupt_handler
;  270 end procedure
;  287 function serial_hw_read(byte out data) return bit is
l_serial_hw_read
;  291    if (_serial_offsetrcvtail == _serial_offsetrcvhead) then  -- receive buffer empty
                               datalo_clr v__serial_offsetrcvtail
                               datahi_clr v__serial_offsetrcvtail
                               movf     v__serial_offsetrcvtail,w
                               subwf    v__serial_offsetrcvhead,w
                               btfss    v__status, v__z
                               goto     l__l187
;  292       return false                              -- no data available
                               bcf      v__pic_temp, 0 ; _pic_temp
                               goto     l__l185
;  293    end if
l__l187
;  295    data = _serial_rcvbuf[_serial_offsetrcvtail]  -- first available byte
                               movlw    v__serial_rcvbuf
                               addwf    v__serial_offsetrcvtail,w
                               movwf    v__fsr
                               irp_clr  
                               movf     v__ind,w
                               movwf    v___data_1
;  296    _serial_offsetrcvtail = _serial_offsetrcvtail + 1
                               incf     v__serial_offsetrcvtail,f
;  297    if (_serial_offsetrcvtail >= SERIAL_RCVBUFSIZE) then  -- buffer overflow
                               movlw    12
                               subwf    v__serial_offsetrcvtail,w
                               btfsc    v__status, v__z
                               goto     l__l545
                               btfss    v__status, v__c
                               goto     l__l189
l__l545
;  298       _serial_offsetrcvtail = 0                 -- wrap
                               clrf     v__serial_offsetrcvtail
;  299    end if
l__l189
;  300    if (serial_ctsinv == TRUE) then              -- CTS is FALSE
                               btfss    v__bitbucket, 0 ; dummy
                               goto     l__l191
;  301       if (_serial_offsetrcvhead > _serial_offsetrcvtail) then
                               movf     v__serial_offsetrcvhead,w
                               subwf    v__serial_offsetrcvtail,w
                               btfsc    v__status, v__z
                               goto     l__l193
                               btfsc    v__status, v__c
                               goto     l__l193
;  302          x = SERIAL_RCVBUFSIZE - _serial_offsetrcvhead + _serial_offsetrcvtail
                               comf     v__serial_offsetrcvhead,w
                               datahi_set v____temp_26
                               movwf    v____temp_26
                               movlw    13
                               addwf    v____temp_26,f
                               datahi_clr v__serial_offsetrcvtail
                               movf     v__serial_offsetrcvtail,w
                               datahi_set v____temp_26
                               addwf    v____temp_26,w
                               movwf    v___x_68
;  303       else
                               goto     l__l192
l__l193
;  304          x = _serial_offsetrcvtail - _serial_offsetrcvhead  -- offset difference
                               movf     v__serial_offsetrcvhead,w
                               subwf    v__serial_offsetrcvtail,w
                               datahi_set v___x_68
                               movwf    v___x_68
;  305       end if
l__l192
;  306       if (x >= SERIAL_DELTA) then               -- enough free space now
                               movlw    17
                               subwf    v___x_68,w
                               btfsc    v__status, v__z
                               goto     l__l549
                               btfss    v__status, v__c
                               goto     l__l190
l__l549
;  307          serial_ctsinv = FALSE                  -- make CTS TRUE
                               datahi_clr v__bitbucket ; dummy
                               bcf      v__bitbucket, 0 ; dummy
;  309    end if
l__l191
l__l190
;  311    return true                                  -- byte available
                               datahi_clr v__pic_temp ; _pic_temp
                               bsf      v__pic_temp, 0 ; _pic_temp
;  313 end function
l__l185
                               movf     v___data_1,w
                               return   
;  338 function  serial_send_byte(byte in data) return byte is
l_serial_send_byte
                               movwf    v___data_5
;  342    serial_send_success = true                   -- indicate byte sent
                               bsf      v__bitbucket, 1 ; serial_send_success
;  344    if (_serial_offsetxmthead == _serial_offsetxmttail  &  -- nothing buffered
                               movf     v__serial_offsetxmthead,w
                               subwf    v__serial_offsetxmttail,w
                               bcf      v____bitbucket_50, 0 ; _btemp23
                               btfsc    v__status, v__z
                               bsf      v____bitbucket_50, 0 ; _btemp23
                               bcf      v____bitbucket_50, 1 ; _btemp24
                               btfsc    v_pir1, 4 ; pir1_txif
                               bsf      v____bitbucket_50, 1 ; _btemp24
                               bsf      v____bitbucket_50, 2 ; _btemp25
                               btfsc    v____bitbucket_50, 0 ; _btemp23
                               btfss    v____bitbucket_50, 1 ; _btemp24
                               bcf      v____bitbucket_50, 2 ; _btemp25
                               btfss    v____bitbucket_50, 2 ; _btemp25
                               goto     l__l201
;  346       PIE1_TXIE = FALSE                         -- disable xmt interrupt
                               datalo_set v_pie1 ; pie1_txie
                               bcf      v_pie1, 4 ; pie1_txie
;  347       TXREG = data                              -- transmit byte immediately
                               datalo_clr v___data_5
                               movf     v___data_5,w
                               movwf    v_txreg
;  348    else                                         -- use circular buffer
                               goto     l__l200
l__l201
;  349       _serial_xmtbuf[_serial_offsetxmthead] = data  -- put byte in buffer
                               movlw    v__serial_xmtbuf
                               addwf    v__serial_offsetxmthead,w
                               movwf    v__fsr
                               irp_clr  
                               movf     v___data_5,w
                               movwf    v__ind
;  350       newxmthead = _serial_offsetxmthead + 1    -- offset next char
                               incf     v__serial_offsetxmthead,w
                               movwf    v_newxmthead
;  351       if (newxmthead >= SERIAL_XMTBUFSIZE) then  -- beyond buffer end
                               movlw    80
                               subwf    v_newxmthead,w
                               btfsc    v__status, v__z
                               goto     l__l553
                               btfss    v__status, v__c
                               goto     l__l203
l__l553
;  352          newxmthead = 0                         -- wrap to begin
                               clrf     v_newxmthead
;  353       end if
l__l203
;  354       if (newxmthead != _serial_offsetxmttail) then  -- buffer not full
                               movf     v_newxmthead,w
                               subwf    v__serial_offsetxmttail,w
                               btfsc    v__status, v__z
                               goto     l__l205
;  355          _serial_offsetxmthead = newxmthead     -- update offset
                               movf     v_newxmthead,w
                               movwf    v__serial_offsetxmthead
;  356       else                                      -- buffer full!
                               goto     l__l204
l__l205
;  358             while (newxmthead == _serial_offsetxmttail) loop   -- buffer full
l__l208
                               movf     v_newxmthead,w
                               subwf    v__serial_offsetxmttail,w
                               btfsc    v__status, v__z
;  360             end loop
                               goto     l__l208
l__l209
;  361             _serial_offsetxmthead = newxmthead  -- update offset
                               movf     v_newxmthead,w
                               movwf    v__serial_offsetxmthead
;  366       end if
l__l204
;  367       PIE1_TXIE = TRUE                          -- (re-)enable xmit interrupts
                               datalo_set v_pie1 ; pie1_txie
                               bsf      v_pie1, 4 ; pie1_txie
;  368    end if
l__l200
;  370    return data                                  -- transmitted byte!
                               datalo_clr v___data_5
                               movf     v___data_5,w
;  372 end function
                               return   
;  378 procedure serial_hw_init() is
l_serial_hw_init
;  380    _serial_offsetxmthead  = 0                   -- offset next byte from appl
                               datalo_clr v__serial_offsetxmthead
                               clrf     v__serial_offsetxmthead
;  381    _serial_offsetxmttail  = 0                   -- offset next byte to port
                               clrf     v__serial_offsetxmttail
;  382    _serial_offsetrcvhead  = 0                   -- offset next byte from port
                               clrf     v__serial_offsetrcvhead
;  383    _serial_offsetrcvtail  = 0                   -- offset next byte to appl
                               clrf     v__serial_offsetrcvtail
;  385    RCSTA                  = 0b0000_0000         -- reset
                               clrf     v_rcsta
;  386    RCSTA_SPEN             = enabled             -- serial port enable
                               bsf      v_rcsta, 7 ; rcsta_spen
;  387    RCSTA_CREN             = enabled             -- continuous receive enable
                               bsf      v_rcsta, 4 ; rcsta_cren
;  389    TXSTA                  = 0b0000_0000         -- reset (8 bit, asyn)
                               datalo_set v_txsta
                               clrf     v_txsta
;  390    TXSTA_TXEN             = enabled             -- UART transmit enabled
                               bsf      v_txsta, 5 ; txsta_txen
;  393    _calculate_and_set_baudrate()                -- set baudrate
                               call     l__calculate_and_set_baudrate
;  395    PIE1_RCIE              = enabled             -- UART receive int. enable
                               datalo_set v_pie1 ; pie1_rcie
                               datahi_clr v_pie1 ; pie1_rcie
                               bsf      v_pie1, 5 ; pie1_rcie
;  397    INTCON_PEIE            = enabled             -- periferal
                               bsf      v_intcon, 6 ; intcon_peie
;  398    INTCON_GIE             = enabled             -- general
                               bsf      v_intcon, 7 ; intcon_gie
;  400    serial_ctsinv          = false               -- CTS true: accept PC data
                               datalo_clr v__bitbucket ; dummy
                               bcf      v__bitbucket, 0 ; dummy
;  402 end procedure
                               return   
;  418 procedure serial_hw_data'put(byte in data) is
l__serial_hw_data_put
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movf     v__pic_temp,w
                               movwf    v___data_7
;  422    serial_send_success = false
                               bcf      v__bitbucket, 1 ; serial_send_success
;  423    while (serial_send_success == false) loop
l__l217
                               datalo_clr v__bitbucket ; serial_send_success
                               datahi_clr v__bitbucket ; serial_send_success
                               btfsc    v__bitbucket, 1 ; serial_send_success
                               goto     l__l218
;  424       dummy = serial_send_byte(data)
                               movf     v___data_7,w
                               call     l_serial_send_byte
;  425    end loop
                               goto     l__l217
l__l218
;  427 end procedure
                               return   
;  449 end function
l__l225
; vcxo.jal
;   54 serial_hw_init()               
                               call     l_serial_hw_init
; c:\jallib\include\jal/print.jal
;   42 procedure print_crlf(volatile byte out device) is
                               goto     l__l367
l_print_crlf
;   43    device = ASCII_CR -- cariage return
                               movlw    13
                               movwf    v__pic_temp
                               movf     v__device_put,w
                               movwf    v__pic_pointer
                               movf     v__device_put+1,w
                               call     l__pic_indirect
;   44    device = ASCII_LF -- line feed
                               movlw    10
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movwf    v__pic_temp
                               movf     v__device_put,w
                               movwf    v__pic_pointer
                               movf     v__device_put+1,w
                               goto     l__pic_indirect
;   45 end procedure
;   47 procedure print_string(volatile byte out device, byte in str[]) is
l_print_string
;   48    var word len = count(str)
                               movf     v__str_count,w
                               movwf    v_len
                               movf     v__str_count+1,w
                               movwf    v_len+1
;   51    for len using i loop
                               clrf     v_i
                               goto     l__l249
l__l248
;   52       device = str[i]
                               datahi_set v___str_1
                               movf     v___str_1+1,w
                               datahi_clr v__pic_pointer
                               movwf    v__pic_pointer+1
                               datahi_set v_i
                               movf     v_i,w
                               addwf    v___str_1,w
                               datahi_clr v__pic_pointer
                               movwf    v__pic_pointer
                               btfsc    v__status, v__c
                               incf     v__pic_pointer+1,f
                               bcf      v__pic_pointer+1, 6
                               movf     v__pic_pointer+1,w
                               call     l__pic_indirect
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movwf    v__pic_temp
                               movf     v____device_put_1,w
                               movwf    v__pic_pointer
                               movf     v____device_put_1+1,w
                               call     l__pic_indirect
;   53    end loop
                               datalo_clr v_i
                               datahi_set v_i
                               incf     v_i,f
l__l249
                               movf     v_i,w
                               subwf    v_len,w
                               datahi_clr v__pic_temp
                               movwf    v__pic_temp
                               datahi_set v_len
                               movf     v_len+1,w
                               datahi_clr v__pic_temp
                               iorwf    v__pic_temp,w
                               btfss    v__status, v__z
                               goto     l__l248
;   55 end procedure
                               return   
;  255 procedure print_byte_dec(volatile byte out device, byte in data) is
l_print_byte_dec
                               datahi_set v___data_49
                               movwf    v___data_49
;  257    _print_universal_dec(device, data, 100, 3)
                               datahi_clr v____device_put_19
                               movf     v____device_put_19,w
                               datahi_set v____device_put_21
                               movwf    v____device_put_21
                               datahi_clr v____device_put_19
                               movf     v____device_put_19+1,w
                               datahi_set v____device_put_21
                               movwf    v____device_put_21+1
                               movf     v___data_49,w
                               movwf    v___data_53
                               clrf     v___data_53+1
                               clrf     v___data_53+2
                               clrf     v___data_53+3
                               movlw    100
                               movwf    v___digit_divisor_5
                               clrf     v___digit_divisor_5+1
                               clrf     v___digit_divisor_5+2
                               clrf     v___digit_divisor_5+3
                               movlw    3
                               goto     l__print_universal_dec
;  259 end procedure
;  276 procedure _print_universal_dec(volatile byte out device, dword in data, sdword in digit_divisor, byte in digit_number) is
l__print_universal_dec
                               movwf    v___digit_number_5
;  280    if (data == 0) then
                               movf     v___data_53,w
                               iorwf    v___data_53+1,w
                               iorwf    v___data_53+2,w
                               iorwf    v___data_53+3,w
                               btfss    v__status, v__z
                               goto     l__l318
;  281       device = "0"      
                               movlw    48
                               datahi_clr v__pic_temp
                               movwf    v__pic_temp
                               datahi_set v____device_put_21
                               movf     v____device_put_21,w
                               datahi_clr v__pic_pointer
                               movwf    v__pic_pointer
                               datahi_set v____device_put_21
                               movf     v____device_put_21+1,w
                               goto     l__pic_indirect
;  282       return
;  283    end if
l__l318
;  285    no_digits_printed_yet = true
                               bsf      v____bitbucket_42, 0 ; no_digits_printed_yet
;  286    while (digit_divisor > 0) loop
l__l319
                               movf     v___digit_divisor_5+3,w
                               xorlw    128
                               datahi_clr v__pic_temp
                               movwf    v__pic_temp
                               movlw    128
                               subwf    v__pic_temp,w
                               btfss    v__status, v__z
                               goto     l__l554
                               movlw    0
                               datahi_set v___digit_divisor_5
                               subwf    v___digit_divisor_5+2,w
                               btfss    v__status, v__z
                               goto     l__l554
                               movlw    0
                               subwf    v___digit_divisor_5+1,w
                               btfss    v__status, v__z
                               goto     l__l554
                               movlw    0
                               subwf    v___digit_divisor_5,w
l__l554
                               btfsc    v__status, v__z
                               goto     l__l320
                               btfss    v__status, v__c
                               goto     l__l320
;  287       digit = byte ( data / digit_divisor )
                               datahi_set v___digit_divisor_5
                               movf     v___digit_divisor_5,w
                               datahi_clr v__pic_divisor
                               movwf    v__pic_divisor
                               datahi_set v___digit_divisor_5
                               movf     v___digit_divisor_5+1,w
                               datahi_clr v__pic_divisor
                               movwf    v__pic_divisor+1
                               datahi_set v___digit_divisor_5
                               movf     v___digit_divisor_5+2,w
                               datahi_clr v__pic_divisor
                               movwf    v__pic_divisor+2
                               datahi_set v___digit_divisor_5
                               movf     v___digit_divisor_5+3,w
                               datahi_clr v__pic_divisor
                               movwf    v__pic_divisor+3
                               datahi_set v___data_53
                               movf     v___data_53,w
                               datahi_clr v__pic_dividend
                               movwf    v__pic_dividend
                               datahi_set v___data_53
                               movf     v___data_53+1,w
                               datahi_clr v__pic_dividend
                               movwf    v__pic_dividend+1
                               datahi_set v___data_53
                               movf     v___data_53+2,w
                               datahi_clr v__pic_dividend
                               movwf    v__pic_dividend+2
                               datahi_set v___data_53
                               movf     v___data_53+3,w
                               datahi_clr v__pic_dividend
                               movwf    v__pic_dividend+3
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               datahi_set v_digit
                               movwf    v_digit
;  288       data = data % digit_divisor
                               datahi_clr v__pic_remainder
                               movf     v__pic_remainder,w
                               datahi_set v___data_53
                               movwf    v___data_53
                               datahi_clr v__pic_remainder
                               movf     v__pic_remainder+1,w
                               datahi_set v___data_53
                               movwf    v___data_53+1
                               datahi_clr v__pic_remainder
                               movf     v__pic_remainder+2,w
                               datahi_set v___data_53
                               movwf    v___data_53+2
                               datahi_clr v__pic_remainder
                               movf     v__pic_remainder+3,w
                               datahi_set v___data_53
                               movwf    v___data_53+3
;  289       digit_divisor = digit_divisor / 10
                               movlw    10
                               datahi_clr v__pic_divisor
                               movwf    v__pic_divisor
                               clrf     v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               datahi_set v___digit_divisor_5
                               movf     v___digit_divisor_5,w
                               datahi_clr v__pic_dividend
                               movwf    v__pic_dividend
                               datahi_set v___digit_divisor_5
                               movf     v___digit_divisor_5+1,w
                               datahi_clr v__pic_dividend
                               movwf    v__pic_dividend+1
                               datahi_set v___digit_divisor_5
                               movf     v___digit_divisor_5+2,w
                               datahi_clr v__pic_dividend
                               movwf    v__pic_dividend+2
                               datahi_set v___digit_divisor_5
                               movf     v___digit_divisor_5+3,w
                               datahi_clr v__pic_dividend
                               movwf    v__pic_dividend+3
                               call     l__pic_sdivide
                               datalo_clr v__pic_quotient
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               datahi_set v___digit_divisor_5
                               movwf    v___digit_divisor_5
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient+1,w
                               datahi_set v___digit_divisor_5
                               movwf    v___digit_divisor_5+1
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient+2,w
                               datahi_set v___digit_divisor_5
                               movwf    v___digit_divisor_5+2
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient+3,w
                               datahi_set v___digit_divisor_5
                               movwf    v___digit_divisor_5+3
;  291       if ((digit != 0) | (no_digits_printed_yet == false)) then
                               movf     v_digit,w
                               bsf      v____bitbucket_42, 3 ; _btemp47
                               btfsc    v__status, v__z
                               bcf      v____bitbucket_42, 3 ; _btemp47
                               bcf      v____bitbucket_42, 4 ; _btemp48
                               btfss    v____bitbucket_42, 0 ; no_digits_printed_yet
                               bsf      v____bitbucket_42, 4 ; _btemp48
                               bcf      v____bitbucket_42, 5 ; _btemp49
                               btfss    v____bitbucket_42, 3 ; _btemp47
                               btfsc    v____bitbucket_42, 4 ; _btemp48
                               bsf      v____bitbucket_42, 5 ; _btemp49
                               btfss    v____bitbucket_42, 5 ; _btemp49
                               goto     l__l323
;  292          device = digit | "0"
                               movlw    48
                               iorwf    v_digit,w
                               movwf    v____temp_42
                               movf     v____temp_42,w
                               datahi_clr v__pic_temp
                               movwf    v__pic_temp
                               datahi_set v____device_put_21
                               movf     v____device_put_21,w
                               datahi_clr v__pic_pointer
                               movwf    v__pic_pointer
                               datahi_set v____device_put_21
                               movf     v____device_put_21+1,w
                               call     l__pic_indirect
;  293          no_digits_printed_yet = false
                               datalo_clr v____bitbucket_42 ; no_digits_printed_yet
                               datahi_set v____bitbucket_42 ; no_digits_printed_yet
                               bcf      v____bitbucket_42, 0 ; no_digits_printed_yet
;  294       end if
l__l323
;  295       digit_number = digit_number - 1
                               decf     v___digit_number_5,f
;  296    end loop
                               goto     l__l319
l__l320
;  298 end procedure
l__l239
                               return   
; c:\jallib\include\jal/delay.jal
;  113 procedure delay_1ms(word in n) is
l_delay_1ms
;  115    for n loop
                               datahi_set v__floop4
                               clrf     v__floop4
                               clrf     v__floop4+1
                               goto     l__l358
l__l357
;  117          _usec_delay(_one_ms_delay)
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    35
                               movwf    v__pic_temp
l__l558
                               movlw    13
                               movwf    v__pic_temp+1
l__l559
                               branchhi_clr l__l559
                               branchlo_clr l__l559
                               decfsz   v__pic_temp+1,f
                               goto     l__l559
                               branchhi_clr l__l558
                               branchlo_clr l__l558
                               decfsz   v__pic_temp,f
                               goto     l__l558
;  121    end loop
                               datahi_set v__floop4
                               incf     v__floop4,f
                               btfsc    v__status, v__z
                               incf     v__floop4+1,f
l__l358
                               movf     v__floop4,w
                               datahi_clr v___n_3
                               subwf    v___n_3,w
                               movwf    v__pic_temp
                               datahi_set v__floop4
                               movf     v__floop4+1,w
                               datahi_clr v___n_3
                               subwf    v___n_3+1,w
                               iorwf    v__pic_temp,w
                               btfss    v__status, v__z
                               goto     l__l357
;  122 end procedure
                               return   
;  138 end procedure
l__l367
; gps_converter.jal
;   16 var byte GpsErrorCode = 1  ; errorcode 1 = startup (wait for $).
                               movlw    1
                               datalo_clr v_gpserrorcode
                               datahi_clr v_gpserrorcode
                               movwf    v_gpserrorcode
;   22 procedure DumpGpsInBuffer is      
                               goto     l__l404
;   44 function StoreBytes (byte in char) return bit is
l_storebytes
                               movwf    v___char_5
;   47    if (char == ",") then
                               movlw    44
                               subwf    v___char_5,w
                               btfss    v__status, v__z
                               goto     l__l380
;   48       return true
                               bsf      v__pic_temp, 0 ; _pic_temp
                               return   
;   49    end if
l__l380
;   51    if (GpsInBufferIndex >= (IN_BUF_SIZE-1)) then
                               movlw    19
                               subwf    v_gpsinbufferindex,w
                               btfsc    v__status, v__z
                               goto     l__l561
                               btfss    v__status, v__c
                               goto     l__l382
l__l561
;   53       GpsErrorCode = 201
                               movlw    201
                               movwf    v_gpserrorcode
;   54       return;
                               return   
;   55    end if
l__l382
;   57    GpsInBuffer[GpsInBufferIndex] = char
                               movlw    v_gpsinbuffer
                               addwf    v_gpsinbufferindex,w
                               movwf    v__fsr
                               irp_clr  
                               movf     v___char_5,w
                               movwf    v__ind
;   58    GpsInBufferIndex = GpsInBufferIndex + 1
                               incf     v_gpsinbufferindex,f
;   59    GpsInBuffer[GpsInBufferIndex] = 0 ; iedere keer de afsluit-0 plaatsen.
                               movlw    v_gpsinbuffer
                               addwf    v_gpsinbufferindex,w
                               movwf    v__fsr
                               irp_clr  
                               clrf     v__ind
;   61    return false ; not done yet.
                               bcf      v__pic_temp, 0 ; _pic_temp
;   62 end function
l__l378
                               return   
;   64 function IsMsg(byte in name[]) return bit is
l_ismsg
;   67    for 5 using i loop       
                               clrf     v___i_2
l__l385
;   73       if (name[i] != GpsInBuffer[i]) then return false end if
                               movf     v___name_1+1,w
                               datahi_clr v__pic_pointer
                               movwf    v__pic_pointer+1
                               datahi_set v___i_2
                               movf     v___i_2,w
                               addwf    v___name_1,w
                               datahi_clr v__pic_pointer
                               movwf    v__pic_pointer
                               btfsc    v__status, v__c
                               incf     v__pic_pointer+1,f
                               bcf      v__pic_pointer+1, 6
                               movf     v__pic_pointer+1,w
                               call     l__pic_indirect
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movwf    v__pic_temp
                               movlw    v_gpsinbuffer
                               datahi_set v___i_2
                               addwf    v___i_2,w
                               movwf    v__fsr
                               irp_clr  
                               datahi_clr v__pic_temp
                               movf     v__pic_temp,w
                               subwf    v__ind,w
                               btfsc    v__status, v__z
                               goto     l__l389
                               bcf      v__pic_temp, 0 ; _pic_temp
                               return   
l__l389
;   74    end loop
                               datahi_set v___i_2
                               incf     v___i_2,f
                               movlw    5
                               subwf    v___i_2,w
                               btfss    v__status, v__z
                               goto     l__l385
;   78    return true
                               datahi_clr v__pic_temp ; _pic_temp
                               bsf      v__pic_temp, 0 ; _pic_temp
;   79 end function
l__l384
                               return   
;   88 function ParseMessageID() return byte is
l_parsemessageid
;   89    if (IsMsg(str_gpgga)) then return 1 end if
                               movlw    l__data_str_gpgga
                               datahi_set v___name_1
                               movwf    v___name_1
                               movlw    HIGH l__data_str_gpgga
                               iorlw    64
                               movwf    v___name_1+1
                               call     l_ismsg
                               datalo_clr v____bitbucket_4 ; _btemp61
                               datahi_clr v____bitbucket_4 ; _btemp61
                               bcf      v____bitbucket_4, 0 ; _btemp61
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v____bitbucket_4, 0 ; _btemp61
                               btfsc    v____bitbucket_4, 0 ; _btemp61
                               retlw    1
l__l393
;   90    if (IsMsg(str_gpgll)) then return 2 end if
                               movlw    l__data_str_gpgll
                               datahi_set v___name_1
                               movwf    v___name_1
                               movlw    HIGH l__data_str_gpgll
                               iorlw    64
                               movwf    v___name_1+1
                               call     l_ismsg
                               datalo_clr v____bitbucket_4 ; _btemp62
                               datahi_clr v____bitbucket_4 ; _btemp62
                               bcf      v____bitbucket_4, 1 ; _btemp62
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v____bitbucket_4, 1 ; _btemp62
                               btfsc    v____bitbucket_4, 1 ; _btemp62
                               retlw    2
l__l395
;   91    if (IsMsg(str_gpgsa)) then return 3 end if
                               movlw    l__data_str_gpgsa
                               datahi_set v___name_1
                               movwf    v___name_1
                               movlw    HIGH l__data_str_gpgsa
                               iorlw    64
                               movwf    v___name_1+1
                               call     l_ismsg
                               datalo_clr v____bitbucket_4 ; _btemp63
                               datahi_clr v____bitbucket_4 ; _btemp63
                               bcf      v____bitbucket_4, 2 ; _btemp63
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v____bitbucket_4, 2 ; _btemp63
                               btfsc    v____bitbucket_4, 2 ; _btemp63
                               retlw    3
l__l397
;   92    if (IsMsg(str_gpgsv)) then return 4 end if
                               movlw    l__data_str_gpgsv
                               datahi_set v___name_1
                               movwf    v___name_1
                               movlw    HIGH l__data_str_gpgsv
                               iorlw    64
                               movwf    v___name_1+1
                               call     l_ismsg
                               datalo_clr v____bitbucket_4 ; _btemp64
                               datahi_clr v____bitbucket_4 ; _btemp64
                               bcf      v____bitbucket_4, 3 ; _btemp64
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v____bitbucket_4, 3 ; _btemp64
                               btfsc    v____bitbucket_4, 3 ; _btemp64
                               retlw    4
l__l399
;   93    if (IsMsg(str_gprmc)) then return 5 end if
                               movlw    l__data_str_gprmc
                               datahi_set v___name_1
                               movwf    v___name_1
                               movlw    HIGH l__data_str_gprmc
                               iorlw    64
                               movwf    v___name_1+1
                               call     l_ismsg
                               datalo_clr v____bitbucket_4 ; _btemp65
                               datahi_clr v____bitbucket_4 ; _btemp65
                               bcf      v____bitbucket_4, 4 ; _btemp65
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v____bitbucket_4, 4 ; _btemp65
                               btfsc    v____bitbucket_4, 4 ; _btemp65
                               retlw    5
l__l401
;   94    if (IsMsg(str_gpvtg)) then return 6 end if
                               movlw    l__data_str_gpvtg
                               datahi_set v___name_1
                               movwf    v___name_1
                               movlw    HIGH l__data_str_gpvtg
                               iorlw    64
                               movwf    v___name_1+1
                               call     l_ismsg
                               datalo_clr v____bitbucket_4 ; _btemp66
                               datahi_clr v____bitbucket_4 ; _btemp66
                               bcf      v____bitbucket_4, 5 ; _btemp66
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v____bitbucket_4, 5 ; _btemp66
                               btfsc    v____bitbucket_4, 5 ; _btemp66
                               retlw    6
l__l403
;   96    return 0 ; unknown message
                               retlw    0
;   97 end function
l__l391
;  164 end procedure                             
l__l404
; vcxo.jal
;   70 T2CON_TOUTPS = 0b00                       -- postscaler 1:1
                               movlw    135
                               andwf    v_t2con,f
;   71 T2CON_T2CKPS = 0b00                       -- prescaler 1:1
                               movlw    252
                               andwf    v_t2con,f
;   72 T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on
;   73 PR2 = 249   -- count from 0 to 249 and skip back to 0 = 250 steps
                               movlw    249
                               datalo_set v_pr2
                               movwf    v_pr2
;   75 ccp1con_p1m = 0  -- alleen output op pin P1A
                               movlw    63
                               datalo_clr v_ccp1con
                               andwf    v_ccp1con,f
;   76 ccp1con_ccp1m = 0b1100  -- pwm mode
                               movlw    240
                               andwf    v_ccp1con,w
                               iorlw    12
                               movwf    v_ccp1con
;   77 pin_c5_direction = output
                               datalo_set v_trisc ; pin_c5_direction
                               bcf      v_trisc, 5 ; pin_c5_direction
;   79 PIE1_TMR2IE = true
                               bsf      v_pie1, 1 ; pie1_tmr2ie
;   80 INTCON_GIE = true
                               bsf      v_intcon, 7 ; intcon_gie
;   81 INTCON_PEIE = true
                               bsf      v_intcon, 6 ; intcon_peie
;   83 var volatile word Ticks = 0   
                               datalo_clr v_ticks
                               clrf     v_ticks
                               clrf     v_ticks+1
;   87 print_string(serial_hw_data, str1)      
                               movlw    l__serial_hw_data_put
                               movwf    v____device_put_1
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_1+1
                               movlw    10
                               datahi_set v__str_count
                               movwf    v__str_count
                               clrf     v__str_count+1
                               movlw    l__data_str1_2
                               movwf    v___str_1
                               movlw    HIGH l__data_str1_2
                               iorlw    64
                               movwf    v___str_1+1
                               call     l_print_string
;   89 procedure SetDutyCycle (word in duty) is
                               goto     l__l428
l_setdutycycle
;   91    if (duty > 999) then 
                               movlw    3
                               subwf    v___duty_1+1,w
                               btfss    v__status, v__z
                               goto     l__l562
                               movlw    231
                               subwf    v___duty_1,w
l__l562
                               btfsc    v__status, v__z
                               goto     l__l427
                               btfss    v__status, v__c
                               goto     l__l427
;   92       duty = 999
                               movlw    231
                               movwf    v___duty_1
                               movlw    3
                               movwf    v___duty_1+1
;   93       serial_hw_data = "E"
                               movlw    69
                               movwf    v__pic_temp
                               call     l__serial_hw_data_put
;   94    end if                
l__l427
;   96    ccpr1l = byte(duty >> 2)
                               bcf      v__status, v__c
                               datalo_clr v___duty_1
                               datahi_clr v___duty_1
                               rrf      v___duty_1+1,w
                               movwf    v__pic_temp+1
                               rrf      v___duty_1,w
                               movwf    v__pic_temp
                               bcf      v__status, v__c
                               rrf      v__pic_temp+1,f
                               rrf      v__pic_temp,f
                               movf     v__pic_temp,w
                               movwf    v_ccpr1l
;   97    ccp1con_dc1b = byte(duty) & 0b11
                               movlw    3
                               andwf    v___duty_1,w
                               movwf    v__pic_temp
                               swapf    v__pic_temp,w
                               movwf    v__pic_temp+1
                               movlw    48
                               andwf    v__pic_temp+1,f
                               movlw    207
                               andwf    v_ccp1con,w
                               iorwf    v__pic_temp+1,w
                               movwf    v_ccp1con
;   99 end procedure
                               return   
;  104 procedure isr is
l_isr
;  107    if (PIR1_TMR2IF) then
                               btfss    v_pir1, 1 ; pir1_tmr2if
                               goto     l__serial_receive_interrupt_handler
;  108       PIR1_TMR2IF = false
                               bcf      v_pir1, 1 ; pir1_tmr2if
;  109       Ticks = Ticks + 1
                               incf     v_ticks,f
                               btfsc    v__status, v__z
                               incf     v_ticks+1,f
;  110       if (Ticks > 9999) then
                               movlw    39
                               subwf    v_ticks+1,w
                               btfss    v__status, v__z
                               goto     l__l564
                               movlw    15
                               subwf    v_ticks,w
l__l564
                               btfsc    v__status, v__z
                               goto     l__serial_receive_interrupt_handler
                               btfss    v__status, v__c
                               goto     l__serial_receive_interrupt_handler
;  111          Ticks = 0
                               clrf     v_ticks
                               clrf     v_ticks+1
;  113    end if   
                               goto     l__serial_receive_interrupt_handler
;  115 end procedure
l__l428
;  118 for 8 loop
                               datalo_clr v__floop7
                               datahi_clr v__floop7
                               clrf     v__floop7
l__l434
;  120    led1 = ! led1 
                               btfss    v_porta, 2 ; pin_a2
                               goto     l__l567
                               bcf      v__bitbucket, 2 ; _btemp79
                               goto     l__l566
l__l567
                               bsf      v__bitbucket, 2 ; _btemp79
l__l566
                               bcf      v__porta_shadow, 2 ; x69
                               btfsc    v__bitbucket, 2 ; _btemp79
                               bsf      v__porta_shadow, 2 ; x69
; c:\jallib\include\device/16f690.jal
;  100    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w
                               movwf    v_porta
; vcxo.jal
;  120    led1 = ! led1 
; c:\jallib\include\device/16f690.jal
;  169    _PORTA_flush()
; vcxo.jal
;  120    led1 = ! led1 
;  121    delay_1ms(50)
                               movlw    50
                               movwf    v___n_3
                               clrf     v___n_3+1
                               call     l_delay_1ms
;  122 end loop
                               datalo_clr v__floop7
                               datahi_clr v__floop7
                               incf     v__floop7,f
                               movlw    8
                               subwf    v__floop7,w
                               btfss    v__status, v__z
                               goto     l__l434
;  124 SetDutyCycle(500)
                               movlw    244
                               movwf    v___duty_1
                               movlw    1
                               movwf    v___duty_1+1
                               call     l_setdutycycle
;  129 forever loop    
l__l439
;  139  gpstakt()
; gps_converter.jal
;  111    if (!Serial_HW_read(char)) then
                               call     l_serial_hw_read
                               datalo_clr v___char_7
                               datahi_clr v___char_7
                               movwf    v___char_7
                               bcf      v__bitbucket, 4 ; _btemp671
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v__bitbucket, 4 ; _btemp671
                               btfss    v__bitbucket, 4 ; _btemp671
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  112       return
                               goto     l__l439
;  113    end if
l__l441
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  119    if (GpsErrorCode > 1) then                     
                               movlw    1
                               subwf    v_gpserrorcode,w
                               btfsc    v__status, v__z
                               goto     l__l445
                               btfss    v__status, v__c
                               goto     l__l445
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  120       print_string(serial_hw_data, str_error)
                               movlw    l__serial_hw_data_put
                               movwf    v____device_put_1
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_1+1
                               movlw    6
                               datahi_set v__str_count
                               movwf    v__str_count
                               clrf     v__str_count+1
                               movlw    l__data_str_error
                               movwf    v___str_1
                               movlw    HIGH l__data_str_error
                               iorlw    64
                               movwf    v___str_1+1
                               call     l_print_string
;  121       print_byte_dec(serial_hw_data, GpsErrorCode)
                               movlw    l__serial_hw_data_put
                               datalo_clr v____device_put_19
                               datahi_clr v____device_put_19
                               movwf    v____device_put_19
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_19+1
                               movf     v_gpserrorcode,w
                               call     l_print_byte_dec
;  122       print_crlf(serial_hw_data) 
                               movlw    l__serial_hw_data_put
                               datalo_clr v__device_put
                               datahi_clr v__device_put
                               movwf    v__device_put
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v__device_put+1
                               call     l_print_crlf
;  123       GpsErrorCode = 1
                               movlw    1
                               datalo_clr v_gpserrorcode
                               datahi_clr v_gpserrorcode
                               movwf    v_gpserrorcode
;  124    end if
l__l445
;  126    if (char == "$") then
                               movlw    36
                               subwf    v___char_7,w
                               btfss    v__status, v__z
                               goto     l__l447
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  128       GpsMsgNr    = 0
                               clrf     v_gpsmsgnr
;  129       GpsFieldNr  = 0                      
                               clrf     v_gpsfieldnr
;  130       GpsInBufferIndex = 0
                               clrf     v_gpsinbufferindex
;  132       GpsErrorCode = 0  ; clear prev errors on new msg start
                               clrf     v_gpserrorcode
;  135       return
                               goto     l__l439
;  136    end if
l__l447
;  138    if (GpsErrorCode > 0) then
                               movf     v_gpserrorcode,w
                               btfss    v__status, v__z
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  139       return
                               goto     l__l439
;  140    end if   
l__l449
;  142    if (StoreBytes(char)) then ; put byte in buffer, true = field end
                               movf     v___char_7,w
                               call     l_storebytes
                               datalo_clr v__bitbucket+1 ; _btemp731
                               datahi_clr v__bitbucket+1 ; _btemp731
                               bcf      v__bitbucket+1, 2 ; _btemp731
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v__bitbucket+1, 2 ; _btemp731
                               btfss    v__bitbucket+1, 2 ; _btemp731
                               goto     l__l457
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  144       if (GpsFieldNr == 0) then
                               movf     v_gpsfieldnr,w
                               btfss    v__status, v__z
                               goto     l__l455
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  147          GpsMsgNr = ParseMessageID()    
                               call     l_parsemessageid
                               datalo_clr v_gpsmsgnr
                               datahi_clr v_gpsmsgnr
                               movwf    v_gpsmsgnr
;  149          print_string(serial_hw_data, str_msg)  
                               movlw    l__serial_hw_data_put
                               movwf    v____device_put_1
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_1+1
                               movlw    4
                               datahi_set v__str_count
                               movwf    v__str_count
                               clrf     v__str_count+1
                               movlw    l__data_str_msg
                               movwf    v___str_1
                               movlw    HIGH l__data_str_msg
                               iorlw    64
                               movwf    v___str_1+1
                               call     l_print_string
;  150          print_byte_dec(serial_hw_data, GpsMsgNr) 
                               movlw    l__serial_hw_data_put
                               datalo_clr v____device_put_19
                               datahi_clr v____device_put_19
                               movwf    v____device_put_19
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_19+1
                               movf     v_gpsmsgnr,w
                               call     l_print_byte_dec
;  151          print_crlf(serial_hw_data)
                               movlw    l__serial_hw_data_put
                               datalo_clr v__device_put
                               datahi_clr v__device_put
                               movwf    v__device_put
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v__device_put+1
                               call     l_print_crlf
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  153          if (GpsMsgNr == 1) then verbose = 1 end if
; vcxo.jal
;  139  gpstakt()
; gps_converter.jal
;  154          if (GpsMsgNr == 5) then verbose = 1 end if
;  157       end if
l__l455
;  160       GpsInBufferIndex = 0
                               datalo_clr v_gpsinbufferindex
                               datahi_clr v_gpsinbufferindex
                               clrf     v_gpsinbufferindex
;  161       GpsFieldNr = GpsFieldNr + 1
                               incf     v_gpsfieldnr,f
;  163    end if
l__l457
;  164 end procedure                             
l__l459
; vcxo.jal
;  139  gpstakt()
;  161 end loop
                               goto     l__l439
                               end
