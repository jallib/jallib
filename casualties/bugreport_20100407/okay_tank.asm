; compiler: jal 2.4n-beta (compiled Mar 13 2010)

; command line:  c:\jallib\compiler\jalv2.exe okay_tank.jal -long-start -debug -s "c:\jallib\include;c:\jallib\include\device;c:\jallib\include\external;c:\jallib\include\external\adc;c:\jallib\include\external\can;c:\jallib\include\external\co2;c:\jallib\include\external\humidity;c:\jallib\include\external\keyboard;c:\jallib\include\external\lcd;c:\jallib\include\external\media;c:\jallib\include\external\motor;c:\jallib\include\external\motor\dc;c:\jallib\include\external\motor\period_skip;c:\jallib\include\external\motor\servo;c:\jallib\include\external\motor\stepper;c:\jallib\include\external\ranger;c:\jallib\include\external\ranger\ir;c:\jallib\include\external\ranger\us;c:\jallib\include\external\rtc;c:\jallib\include\external\seven_segment;c:\jallib\include\external\storage;c:\jallib\include\external\storage\eeprom;c:\jallib\include\external\storage\harddisk;c:\jallib\include\external\storage\ram;c:\jallib\include\external\storage\ram\23k256;c:\jallib\include\external\storage\sd_card;c:\jallib\include\external\temperature;c:\jallib\include\filesystem;c:\jallib\include\jal;c:\jallib\include\peripheral;c:\jallib\include\peripheral\adc;c:\jallib\include\peripheral\can;c:\jallib\include\peripheral\comparator;c:\jallib\include\peripheral\data_eeprom;c:\jallib\include\peripheral\flash_memory;c:\jallib\include\peripheral\i2c;c:\jallib\include\peripheral\pwm;c:\jallib\include\peripheral\spi;c:\jallib\include\peripheral\timer;c:\jallib\include\peripheral\usart;c:\jallib\include\peripheral\usb;c:\jallib\include\protocol;c:\jallib\test;c:\jallib\test\board;c:\jallib\test\external;c:\jallib\test\external\keyboard;c:\jallib\test\external\lcd;c:\jallib\test\external\ranger;c:\jallib\test\external\ranger\ir;c:\jallib\test\external\rtc;c:\jallib\test\external\seven_segment;c:\jallib\test\jal;c:\jallib\test\peripheral;c:\jallib\test\peripheral\adc;c:\jallib\test\peripheral\comparator;c:\jallib\test\peripheral\data_eeprom;c:\jallib\test\peripheral\flash_memory;c:\jallib\test\peripheral\i2c;c:\jallib\test\peripheral\pwm;c:\jallib\test\peripheral\spi;c:\jallib\test\peripheral\timer;c:\jallib\test\peripheral\usart;c:\jallib\test\peripheral\usb;c:\jallib\test\unittest;"
; compiler flags:
;    boot-fuse, boot-long-start, debug-compiler, debug-codegen
;    opt-expr-reduce, opt-cexpr-reduce, opt-variable-reduce
;    warn-backend, warn-conversion, warn-misc, warn-range
;    warn-stack-overflow, warn-truncate
                                list p=16f877, r=dec
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
v_on                           EQU 1
v_off                          EQU 0
v_output                       EQU 0
v__pic_isr_w                   EQU 0x007f  ; _pic_isr_w
v__ind                         EQU 0x0000  ; _ind
v_tmr0                         EQU 0x0001  ; tmr0
v__pcl                         EQU 0x0002  ; _pcl
v__status                      EQU 0x0003  ; _status
v__z                           EQU 2
v__c                           EQU 0
v__fsr                         EQU 0x0004  ; _fsr
v_portd                        EQU 0x0008  ; portd
v__portd_shadow                EQU 0x0042  ; _portd_shadow
v_pin_d2                       EQU 0x0008  ; pin_d2-->portd:2
v_pin_d1                       EQU 0x0008  ; pin_d1-->portd:1
v__pclath                      EQU 0x000a  ; _pclath
v_intcon                       EQU 0x000b  ; intcon
v_intcon_gie                   EQU 0x000b  ; intcon_gie-->intcon:7
v_intcon_peie                  EQU 0x000b  ; intcon_peie-->intcon:6
v_intcon_tmr0ie                EQU 0x000b  ; intcon_tmr0ie-->intcon:5
v_intcon_tmr0if                EQU 0x000b  ; intcon_tmr0if-->intcon:2
v_pir1                         EQU 0x000c  ; pir1
v_pir1_txif                    EQU 0x000c  ; pir1_txif-->pir1:4
v_t2con                        EQU 0x0012  ; t2con
v_t2con_tmr2on                 EQU 0x0012  ; t2con_tmr2on-->t2con:2
v_ccpr1l                       EQU 0x0015  ; ccpr1l
v_ccp1con                      EQU 0x0017  ; ccp1con
v_rcsta                        EQU 0x0018  ; rcsta
v_txreg                        EQU 0x0019  ; txreg
v_ccpr2l                       EQU 0x001b  ; ccpr2l
v_ccp2con                      EQU 0x001d  ; ccp2con
v_adresh                       EQU 0x001e  ; adresh
v_adcon0                       EQU 0x001f  ; adcon0
v_adcon0_go                    EQU 0x001f  ; adcon0_go-->adcon0:2
v_adcon0_adon                  EQU 0x001f  ; adcon0_adon-->adcon0:0
v_option_reg                   EQU 0x0081  ; option_reg
v_option_reg_t0cs              EQU 0x0081  ; option_reg_t0cs-->option_reg:5
v_option_reg_psa               EQU 0x0081  ; option_reg_psa-->option_reg:3
v_trisc                        EQU 0x0087  ; trisc
v_pin_c2_direction             EQU 0x0087  ; pin_c2_direction-->trisc:2
v_pin_c1_direction             EQU 0x0087  ; pin_c1_direction-->trisc:1
v_trisd                        EQU 0x0088  ; trisd
v_pie1                         EQU 0x008c  ; pie1
v_pie1_rcie                    EQU 0x008c  ; pie1_rcie-->pie1:5
v_pie1_txie                    EQU 0x008c  ; pie1_txie-->pie1:4
v_pr2                          EQU 0x0092  ; pr2
v_txsta                        EQU 0x0098  ; txsta
v_txsta_txen                   EQU 0x0098  ; txsta_txen-->txsta:5
v_txsta_brgh                   EQU 0x0098  ; txsta_brgh-->txsta:2
v_spbrg                        EQU 0x0099  ; spbrg
v_adresl                       EQU 0x009e  ; adresl
v_adcon1                       EQU 0x009f  ; adcon1
v_adcon1_adfm                  EQU 0x009f  ; adcon1_adfm-->adcon1:7
v__pr2_shadow_plus1            EQU 0x0039  ; _pr2_shadow_plus1
v__ccpr1l_shadow               EQU 0x0043  ; _ccpr1l_shadow
v__ccp1con_shadow              EQU 0x0044  ; _ccp1con_shadow
v__ccpr2l_shadow               EQU 0x0045  ; _ccpr2l_shadow
v__ccp2con_shadow              EQU 0x0046  ; _ccp2con_shadow
v_delay_slots                  EQU 2
v_internal_isr_counter         EQU 0x0047  ; internal_isr_counter
v_isr_countdown                EQU 0x0049  ; isr_countdown
v_timer0_load                  EQU 0x004d  ; timer0_load
v_tad_value                    EQU 0x004e  ; tad_value
v_adc_min_tad                  EQU 16
v_adc_max_tad                  EQU 60
v__adcon0_shadow               EQU 0x003b  ; _adcon0_shadow
v_adc_conversion_delay         EQU 0x004f  ; adc_conversion_delay
v_pwml                         EQU 0x0050  ; pwml
v_pwmr                         EQU 0x0051  ; pwmr
v_motorl_fwd                   EQU 0x005c  ; motorl_fwd-->_bitbucket:0
v_motorr_fwd                   EQU 0x005c  ; motorr_fwd-->_bitbucket:1
v_prev_isr_counter             EQU 0x0052  ; prev_isr_counter
v_lefteye                      EQU 0x0054  ; lefteye
v_righteye                     EQU 0x0056  ; righteye
v___temp_1                     EQU 0x0058  ; temp
v____temp_72                   EQU 0x005a  ; _temp
v__bitbucket                   EQU 0x005c  ; _bitbucket
v__pic_temp                    EQU 0x0020  ; _pic_temp-->_pic_state
v__pic_pointer                 EQU 0x0036  ; _pic_pointer
v__pic_loop                    EQU 0x0034  ; _pic_loop
v__pic_divisor                 EQU 0x0028  ; _pic_divisor-->_pic_state+8
v__pic_dividend                EQU 0x0020  ; _pic_dividend-->_pic_state
v__pic_quotient                EQU 0x002c  ; _pic_quotient-->_pic_state+12
v__pic_remainder               EQU 0x0024  ; _pic_remainder-->_pic_state+4
v__pic_divaccum                EQU 0x0020  ; _pic_divaccum-->_pic_state
v__pic_isr_fsr                 EQU 0x0038  ; _pic_isr_fsr
v__pic_isr_status              EQU 0x0032  ; _pic_isr_status
v__pic_isr_pclath              EQU 0x0033  ; _pic_isr_pclath
v__pic_multiplier              EQU 0x0020  ; _pic_multiplier-->_pic_state
v__pic_multiplicand            EQU 0x0022  ; _pic_multiplicand-->_pic_state+2
v__pic_mresult                 EQU 0x0024  ; _pic_mresult-->_pic_state+4
v__pic_sign                    EQU 0x0035  ; _pic_sign
v__pic_state                   EQU 0x0020  ; _pic_state
v__pic_isr_state               EQU 0x0030  ; _pic_isr_state
v____btemp57_2                 EQU 0x005c  ; _btemp57-->_bitbucket:12
v____btemp59_2                 EQU 0x005c  ; _btemp59-->_bitbucket:14
v____btemp61_2                 EQU 0x005c  ; _btemp61-->_bitbucket:16
v____temp_71                   EQU 0x005f  ; _temp
v__btemp65                     EQU 0x005c  ; _btemp65-->_bitbucket:3
v__btemp69                     EQU 0x005c  ; _btemp69-->_bitbucket:7
v__btemp70                     EQU 0x005c  ; _btemp70-->_bitbucket:8
v___x_116                      EQU 0x0042  ; x-->_portd_shadow:1
v___x_117                      EQU 0x0042  ; x-->_portd_shadow:0
v___x_118                      EQU 0x0042  ; x-->_portd_shadow:2
v___x_119                      EQU 0x0042  ; x-->_portd_shadow:3
v_shift_alias                  EQU 0       ; adc_read_low_res(): shift_alias
v___ad_value_1                 EQU 0       ; adc_read_bytes(): ad_value
v____temp_69                   EQU 0       ; adc_read_bytes(): _temp
v___adc_chan_3                 EQU 0x0061  ; adc_read:adc_chan
v_ad_value                     EQU 0x0063  ; adc_read:ad_value
v_ax                           EQU 0x0063  ; adc_read:ax-->ad_value
v___adc_chan_1                 EQU 0x0069  ; _adc_read_low_res:adc_chan
v___adc_byte_1                 EQU 0x006a  ; _adc_read_low_res:adc_byte
v___factor_1                   EQU 0x0061  ; _adc_eval_tad:factor
v_tad_ok                       EQU 0x006a  ; _adc_eval_tad:tad_ok-->_bitbucket10:0
v____temp_68                   EQU 0x0067  ; _adc_eval_tad:_temp
v__btemp54                     EQU 0x006a  ; _adc_eval_tad:_btemp54-->_bitbucket10:1
v__btemp55                     EQU 0x006a  ; _adc_eval_tad:_btemp55-->_bitbucket10:2
v__btemp56                     EQU 0x006a  ; _adc_eval_tad:_btemp56-->_bitbucket10:3
v____bitbucket_10              EQU 0x006a  ; _adc_eval_tad:_bitbucket
v_idx                          EQU 6       ; _adc_setup_pins(): idx
v____temp_67                   EQU 0x003c  ; isr:_temp
v_index                        EQU 0x003f  ; isr:index
v___i_1                        EQU 0x0061  ; timer0_isr_init:i
v____temp_66                   EQU 0x0063  ; timer0_isr_init:_temp
v___slot_3                     EQU 0x0061  ; check_delay:slot
v____temp_65                   EQU 0x0063  ; check_delay:_temp
v___slot_1                     EQU 0x0061  ; set_delay:slot
v___ticks_1                    EQU 0x0063  ; set_delay:ticks
v____temp_64                   EQU 0x0069  ; set_delay:_temp
v_temp                         EQU 0x0061  ; _isr_counter_get:temp
v___duty_12                    EQU 0x0061  ; pwm2_set_dutycycle:duty
v____temp_62                   EQU 0x0063  ; pwm2_set_dutycycle:_temp
v___duty_8                     EQU 0x006c  ; pwm2_set_dutycycle_highres:duty
v___duty_5                     EQU 0x0061  ; pwm1_set_dutycycle:duty
v____temp_58                   EQU 0x0063  ; pwm1_set_dutycycle:_temp
v___duty_1                     EQU 0x006c  ; pwm1_set_dutycycle_highres:duty
v___prescaler_1                EQU 0x0061  ; pwm_max_resolution:prescaler
v___data_52                    EQU 0x0040  ; _serial_hw_data_put:data
v___data_46                    EQU 0       ; serial_hw_write_word(): data
v___data_44                    EQU 0x0041  ; serial_hw_write:data
v_usart_div                    EQU 10      ; _calculate_and_set_baudrate(): usart_div
v____device_put_18             EQU 0x0061  ; print_word_dec:_device_put
v___data_36                    EQU 0x0067  ; print_word_dec:data
v___str_1                      EQU 0       ; print_string(): str
v____device_put_21             EQU 0x006a  ; _print_universal_dec:_device_put
v___data_42                    EQU 0x00a0  ; _print_universal_dec:data
v___digit_divisor_5            EQU 0x00a4  ; _print_universal_dec:digit_divisor
v___digit_number_5             EQU 0x006e  ; _print_universal_dec:digit_number
v_digit                        EQU 0x006f  ; _print_universal_dec:digit
v_no_digits_printed_yet        EQU 0x00a9  ; _print_universal_dec:no_digits_printed_yet-->_bitbucket67:0
v____temp_53                   EQU 0x00a8  ; _print_universal_dec:_temp
v____bitbucket_67              EQU 0x00a9  ; _print_universal_dec:_bitbucket
v__btemp22                     EQU 0x00a9  ; _print_universal_dec:_btemp22-->_bitbucket67:3
v__btemp23                     EQU 0x00a9  ; _print_universal_dec:_btemp23-->_bitbucket67:4
v__btemp24                     EQU 0x00a9  ; _print_universal_dec:_btemp24-->_bitbucket67:5
v___n_1                        EQU 0x006c  ; delay_10us:n
v__floop1                      EQU 0x00a0  ; delay_10us:_floop1
;   16 include 16f877
                               org      0                   ;  0 -- -- -- [-- --] 0000
                               branchhi_clr l__main         ;  0 -V rs rs [hl hl] 0000 120a
                               branchlo_clr l__main         ;  0 -V rs rs [hl hl] 0001 118a
                               goto     l__main             ;  0 -V rs rs [hl hl] 0002 289d
                               nop                          ; 4294967295 -- -- -- [-- --] 0003 0000
                               org      4                   ; 4294967295 -- -- -- [-- --] 0004
                               movwf    v__pic_isr_w        ; 4294967295 -V rs rs [hl hl] 0004 00ff
                               swapf    v__status,w         ; 4294967295 -V rs rs [hl hl] 0005 0e03
                               clrf     v__status           ; 4294967295 -V rs rs [hl hl] 0006 0183
                               movwf    v__pic_isr_status   ; 4294967295 -V rs rs [hl hl] 0007 00b2
                               movf     v__pclath,w         ; 4294967295 -V rs rs [hl hl] 0008 080a
                                                            ; W = v__pic_isr_status
                               movwf    v__pic_isr_pclath   ; 4294967295 -V rs rs [hl hl] 0009 00b3
                               clrf     v__pclath           ; 4294967295 -V rs rs [hl hl] 000a 018a
                                                            ; W = v__pic_isr_pclath
                               movf     v__fsr,w            ; 4294967295 -V rs rs [hl hl] 000b 0804
                                                            ; W = v__pic_isr_pclath
                               movwf    v__pic_isr_fsr      ; 4294967295 -V rs rs [hl hl] 000c 00b8
                               movf     v__pic_state,w      ; 4294967295 -V rs rs [hl hl] 000d 0820
                                                            ; W = v__pic_isr_fsr
                               movwf    v__pic_isr_state    ; 4294967295 -V rs rs [hl hl] 000e 00b0
                                                            ; W = v__pic_state
                               movf     v__pic_state+1,w    ; 4294967295 -V rs rs [hl hl] 000f 0821
                               movwf    v__pic_isr_state+1  ; 4294967295 -V rs rs [hl hl] 0010 00b1
                                                            ; W = v__pic_state
                               branchhi_clr l_isr           ; 4294967295 -V rs rs [hl hl] 0011 120a
                               branchlo_clr l_isr           ; 4294967295 -V rs rs [hl hl] 0012 118a
                               goto     l_isr               ; 4294967295 -V rs rs [hl hl] 0013 2ac3
l__pic_multiply
                               movlw    16                  ;  2 OV rs rs [?? ??] 0014 3010
                                                            ; W = v__pic_multiplicand
                               movwf    v__pic_loop         ;  2 OV rs rs [?? ??] 0015 00b4
l__l866
                               bcf      v__status, v__c     ;  2 OV rs rs [?? ??] 0016 1003
                               rlf      v__pic_mresult,f    ;  2 OV rs rs [?? ??] 0017 0da4
                               rlf      v__pic_mresult+1,f  ;  2 OV rs rs [?? ??] 0018 0da5
                               bcf      v__status, v__c     ;  2 OV rs rs [?? ??] 0019 1003
                               rlf      v__pic_multiplier,f ;  2 OV rs rs [?? ??] 001a 0da0
                               rlf      v__pic_multiplier+1,f;  2 OV rs rs [?? ??] 001b 0da1
                               btfss    v__status, v__c     ;  2 OV rs rs [?? ??] 001c 1c03
                               goto     l__l867             ;  2 OV rs rs [?? ??] 001d 2824
                               movf     v__pic_multiplicand+1,w;  2 OV rs rs [?? ??] 001e 0823
                               addwf    v__pic_mresult+1,f  ;  2 OV rs rs [?? ??] 001f 07a5
                                                            ; W = v__pic_multiplicand
                               movf     v__pic_multiplicand,w;  2 OV rs rs [?? ??] 0020 0822
                                                            ; W = v__pic_multiplicand
                               addwf    v__pic_mresult,f    ;  2 OV rs rs [?? ??] 0021 07a4
                                                            ; W = v__pic_multiplicand
                               btfsc    v__status, v__c     ;  2 OV rs rs [?? ??] 0022 1803
                                                            ; W = v__pic_multiplicand
                               incf     v__pic_mresult+1,f  ;  2 OV rs rs [?? ??] 0023 0aa5
                                                            ; W = v__pic_multiplicand
l__l867
                               decfsz   v__pic_loop,f       ;  2 OV rs rs [?? ??] 0024 0bb4
                               goto     l__l866             ;  2 OV rs rs [?? ??] 0025 2816
                               return                       ;  2 OV rs rs [?? ??] 0026 0008
l__pic_sdivide
                               movlw    0                   ;  2 OV rs rs [?? ??] 0027 3000
                                                            ; W = v__pic_dividend
                               btfss    v__pic_dividend+3, 7;  2 OV rs rs [?? ??] 0028 1fa3
                               goto     l__l871             ;  2 OV rs rs [?? ??] 0029 2836
                               comf     v__pic_dividend,f   ;  2 OV rs rs [?? ??] 002a 09a0
                               comf     v__pic_dividend+1,f ;  2 OV rs rs [?? ??] 002b 09a1
                               comf     v__pic_dividend+2,f ;  2 OV rs rs [?? ??] 002c 09a2
                               comf     v__pic_dividend+3,f ;  2 OV rs rs [?? ??] 002d 09a3
                               incf     v__pic_dividend,f   ;  2 OV rs rs [?? ??] 002e 0aa0
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 002f 1903
                               incf     v__pic_dividend+1,f ;  2 OV rs rs [?? ??] 0030 0aa1
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0031 1903
                               incf     v__pic_dividend+2,f ;  2 OV rs rs [?? ??] 0032 0aa2
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0033 1903
                               incf     v__pic_dividend+3,f ;  2 OV rs rs [?? ??] 0034 0aa3
                               movlw    1                   ;  2 OV rs rs [?? ??] 0035 3001
l__l871
                               movwf    v__pic_sign         ;  2 OV rs rs [?? ??] 0036 00b5
                               movlw    0                   ;  2 OV rs rs [?? ??] 0037 3000
                                                            ; W = v__pic_sign
                               btfss    v__pic_divisor+3, 7 ;  2 OV rs rs [?? ??] 0038 1fab
                               goto     l__l872             ;  2 OV rs rs [?? ??] 0039 2846
                               comf     v__pic_divisor,f    ;  2 OV rs rs [?? ??] 003a 09a8
                               comf     v__pic_divisor+1,f  ;  2 OV rs rs [?? ??] 003b 09a9
                               comf     v__pic_divisor+2,f  ;  2 OV rs rs [?? ??] 003c 09aa
                               comf     v__pic_divisor+3,f  ;  2 OV rs rs [?? ??] 003d 09ab
                               incf     v__pic_divisor,f    ;  2 OV rs rs [?? ??] 003e 0aa8
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 003f 1903
                               incf     v__pic_divisor+1,f  ;  2 OV rs rs [?? ??] 0040 0aa9
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0041 1903
                               incf     v__pic_divisor+2,f  ;  2 OV rs rs [?? ??] 0042 0aaa
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0043 1903
                               incf     v__pic_divisor+3,f  ;  2 OV rs rs [?? ??] 0044 0aab
                               movlw    1                   ;  2 OV rs rs [?? ??] 0045 3001
l__l872
                               xorwf    v__pic_sign,f       ;  2 OV rs rs [?? ??] 0046 06b5
                               goto     l__l873             ;  2 OV rs rs [?? ??] 0047 2849
l__pic_divide
                               clrf     v__pic_sign         ;  2 OV rs rs [?? ??] 0048 01b5
                                                            ; W = v__pic_dividend
l__l873
                               movlw    32                  ;  2 OV rs rs [?? ??] 0049 3020
                                                            ; W = v__pic_dividend
                               movwf    v__pic_loop         ;  2 OV rs rs [?? ??] 004a 00b4
                               clrf     v__pic_remainder    ;  2 OV rs rs [?? ??] 004b 01a4
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+1  ;  2 OV rs rs [?? ??] 004c 01a5
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+2  ;  2 OV rs rs [?? ??] 004d 01a6
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+3  ;  2 OV rs rs [?? ??] 004e 01a7
                                                            ; W = v__pic_loop
l__l868
                               bcf      v__status, v__c     ;  2 OV rs rs [?? ??] 004f 1003
                               rlf      v__pic_quotient,f   ;  2 OV rs rs [?? ??] 0050 0dac
                               rlf      v__pic_quotient+1,f ;  2 OV rs rs [?? ??] 0051 0dad
                               rlf      v__pic_quotient+2,f ;  2 OV rs rs [?? ??] 0052 0dae
                               rlf      v__pic_quotient+3,f ;  2 OV rs rs [?? ??] 0053 0daf
                               bcf      v__status, v__c     ;  2 OV rs rs [?? ??] 0054 1003
                               rlf      v__pic_divaccum,f   ;  2 OV rs rs [?? ??] 0055 0da0
                               rlf      v__pic_divaccum+1,f ;  2 OV rs rs [?? ??] 0056 0da1
                               rlf      v__pic_divaccum+2,f ;  2 OV rs rs [?? ??] 0057 0da2
                               rlf      v__pic_divaccum+3,f ;  2 OV rs rs [?? ??] 0058 0da3
                               rlf      v__pic_divaccum+4,f ;  2 OV rs rs [?? ??] 0059 0da4
                               rlf      v__pic_divaccum+5,f ;  2 OV rs rs [?? ??] 005a 0da5
                               rlf      v__pic_divaccum+6,f ;  2 OV rs rs [?? ??] 005b 0da6
                               rlf      v__pic_divaccum+7,f ;  2 OV rs rs [?? ??] 005c 0da7
                               movf     v__pic_remainder+3,w;  2 OV rs rs [?? ??] 005d 0827
                               subwf    v__pic_divisor+3,w  ;  2 OV rs rs [?? ??] 005e 022b
                                                            ; W = v__pic_remainder
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 005f 1d03
                               goto     l__l874             ;  2 OV rs rs [?? ??] 0060 286b
                               movf     v__pic_remainder+2,w;  2 OV rs rs [?? ??] 0061 0826
                                                            ; W = v__pic_sign
                               subwf    v__pic_divisor+2,w  ;  2 OV rs rs [?? ??] 0062 022a
                                                            ; W = v__pic_remainder
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 0063 1d03
                               goto     l__l874             ;  2 OV rs rs [?? ??] 0064 286b
                               movf     v__pic_remainder+1,w;  2 OV rs rs [?? ??] 0065 0825
                               subwf    v__pic_divisor+1,w  ;  2 OV rs rs [?? ??] 0066 0229
                                                            ; W = v__pic_remainder
                               btfss    v__status, v__z     ;  2 OV rs rs [?? ??] 0067 1d03
                               goto     l__l874             ;  2 OV rs rs [?? ??] 0068 286b
                               movf     v__pic_remainder,w  ;  2 OV rs rs [?? ??] 0069 0824
                               subwf    v__pic_divisor,w    ;  2 OV rs rs [?? ??] 006a 0228
                                                            ; W = v__pic_remainder
l__l874
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 006b 1903
                               goto     l__l870             ;  2 OV rs rs [?? ??] 006c 286f
                               btfsc    v__status, v__c     ;  2 OV rs rs [?? ??] 006d 1803
                                                            ; W = v__pic_sign
                               goto     l__l869             ;  2 OV rs rs [?? ??] 006e 287e
                                                            ; W = v__pic_sign
l__l870
                               movf     v__pic_divisor,w    ;  2 OV rs rs [?? ??] 006f 0828
                               subwf    v__pic_remainder,f  ;  2 OV rs rs [?? ??] 0070 02a4
                                                            ; W = v__pic_divisor
                               movf     v__pic_divisor+1,w  ;  2 OV rs rs [?? ??] 0071 0829
                                                            ; W = v__pic_divisor
                               btfss    v__status, v__c     ;  2 OV rs rs [?? ??] 0072 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+1,w  ;  2 OV rs rs [?? ??] 0073 0f29
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+1,f;  2 OV rs rs [?? ??] 0074 02a5
                               movf     v__pic_divisor+2,w  ;  2 OV rs rs [?? ??] 0075 082a
                               btfss    v__status, v__c     ;  2 OV rs rs [?? ??] 0076 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+2,w  ;  2 OV rs rs [?? ??] 0077 0f2a
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+2,f;  2 OV rs rs [?? ??] 0078 02a6
                               movf     v__pic_divisor+3,w  ;  2 OV rs rs [?? ??] 0079 082b
                               btfss    v__status, v__c     ;  2 OV rs rs [?? ??] 007a 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+3,w  ;  2 OV rs rs [?? ??] 007b 0f2b
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+3,f;  2 OV rs rs [?? ??] 007c 02a7
                               bsf      v__pic_quotient, 0  ;  2 OV rs rs [?? ??] 007d 142c
l__l869
                               decfsz   v__pic_loop,f       ;  2 OV rs rs [?? ??] 007e 0bb4
                                                            ; W = v__pic_sign
                               goto     l__l868             ;  2 OV rs rs [?? ??] 007f 284f
                                                            ; W = v__pic_sign
                               movf     v__pic_sign,w       ;  2 OV rs rs [?? ??] 0080 0835
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0081 1903
                                                            ; W = v__pic_sign
                               return                       ;  2 OV rs rs [?? ??] 0082 0008
                                                            ; W = v__pic_sign
                               comf     v__pic_quotient,f   ;  2 OV rs rs [?? ??] 0083 09ac
                               comf     v__pic_quotient+1,f ;  2 OV rs rs [?? ??] 0084 09ad
                               comf     v__pic_quotient+2,f ;  2 OV rs rs [?? ??] 0085 09ae
                               comf     v__pic_quotient+3,f ;  2 OV rs rs [?? ??] 0086 09af
                               incf     v__pic_quotient,f   ;  2 OV rs rs [?? ??] 0087 0aac
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0088 1903
                               incf     v__pic_quotient+1,f ;  2 OV rs rs [?? ??] 0089 0aad
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 008a 1903
                               incf     v__pic_quotient+2,f ;  2 OV rs rs [?? ??] 008b 0aae
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 008c 1903
                               incf     v__pic_quotient+3,f ;  2 OV rs rs [?? ??] 008d 0aaf
                               comf     v__pic_remainder,f  ;  2 OV rs rs [?? ??] 008e 09a4
                               comf     v__pic_remainder+1,f;  2 OV rs rs [?? ??] 008f 09a5
                               comf     v__pic_remainder+2,f;  2 OV rs rs [?? ??] 0090 09a6
                               comf     v__pic_remainder+3,f;  2 OV rs rs [?? ??] 0091 09a7
                               incf     v__pic_remainder,f  ;  2 OV rs rs [?? ??] 0092 0aa4
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0093 1903
                               incf     v__pic_remainder+1,f;  2 OV rs rs [?? ??] 0094 0aa5
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0095 1903
                               incf     v__pic_remainder+2,f;  2 OV rs rs [?? ??] 0096 0aa6
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0097 1903
                               incf     v__pic_remainder+3,f;  2 OV rs rs [?? ??] 0098 0aa7
                               return                       ;  2 OV rs rs [?? ??] 0099 0008
l__pic_indirect
                               movwf    v__pclath           ;  2 OV rs rs [?? ??] 009a 008a
                                                            ; W = v____device_put_21
                               movf     v__pic_pointer,w    ;  2 OV rs rs [?? ??] 009b 0836
                               movwf    v__pcl              ;  2 OV rs rs [?? ??] 009c 0082
                                                            ; W = v__pic_pointer
l__main
; c:\jallib\include\device/16f877.jal
;  404 var          byte  _PORTD_shadow        = PORTD
                               movf     v_portd,w           ;  0 OV rs rs [hl hl] 009d 0808
                               movwf    v__portd_shadow     ;  0 OV rs rs [hl hl] 009e 00c2
;  513 procedure _PORTE_flush() is
                               goto     l__l430             ;  0 OV rs rs [hl hl] 009f 29a2
                                                            ; W = v__portd_shadow
; c:\jallib\include\jal/delay.jal
;   83 procedure delay_10us(byte in n) is
l_delay_10us
                               movwf    v___n_1             ;  3 OV rs rs [?? ??] 00a0 00ec
                                                            ; W = v_adc_conversion_delay
;   84    if n==0 then
                               movf     v___n_1,w           ;  3 OV rs rs [?? ??] 00a1 086c
                                                            ; W = v___n_1
                               btfsc    v__status, v__z     ;  3 OV rs rs [?? ??] 00a2 1903
                                                            ; W = v___n_1
;   85       return
                               return                       ;  3 OV rs rs [?? ??] 00a3 0008
;   86    elsif n==1 then
l__l241
                               movlw    1                   ;  3 OV rs rs [?? ??] 00a4 3001
                                                            ; W = v___n_1
                               subwf    v___n_1,w           ;  3 OV rs rs [?? ??] 00a5 026c
                               btfss    v__status, v__z     ;  3 OV rs rs [?? ??] 00a6 1d03
                               goto     l__l242             ;  3 OV rs rs [?? ??] 00a7 28b1
;   89        _usec_delay(_ten_us_delay1)
                               datalo_clr v__pic_temp       ;  3 -V rs rs [?? ??] 00a8 1283
                               datahi_clr v__pic_temp       ;  3 -V rs rs [?? ??] 00a9 1303
                               movlw    10                  ;  3 -V rs rs [?? ??] 00aa 300a
                               movwf    v__pic_temp         ;  3 -V rs rs [?? ??] 00ab 00a0
                               branchhi_clr l__l875         ;  3 -V rs rs [?? h?] 00ac 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l875         ;  3 -V rs rs [h? hl] 00ad 118a
                                                            ; W = v__pic_temp
l__l875
                               decfsz   v__pic_temp,f       ;  3 -V rs rs [hl hl] 00ae 0ba0
                               goto     l__l875             ;  3 -V rs rs [hl hl] 00af 28ae
;   90      end if
                               return                       ;  3 OV rs rs [hl hl] 00b0 0008
;   91    else     
l__l242
;   92       n = n - 1;
                               decf     v___n_1,f           ;  3 OV rs rs [?? ??] 00b1 03ec
;   95          _usec_delay(_ten_us_delay2)   
                               datalo_clr v__pic_temp       ;  3 -V rs rs [?? ??] 00b2 1283
                               datahi_clr v__pic_temp       ;  3 -V rs rs [?? ??] 00b3 1303
                               movlw    6                   ;  3 -V rs rs [?? ??] 00b4 3006
                               movwf    v__pic_temp         ;  3 -V rs rs [?? ??] 00b5 00a0
                               branchhi_clr l__l876         ;  3 -V rs rs [?? h?] 00b6 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l876         ;  3 -V rs rs [h? hl] 00b7 118a
                                                            ; W = v__pic_temp
l__l876
                               decfsz   v__pic_temp,f       ;  3 -V rs rs [hl hl] 00b8 0ba0
                               goto     l__l876             ;  3 -V rs rs [hl hl] 00b9 28b8
                               nop                          ;  3 -V rs rs [hl hl] 00ba 0000
                               nop                          ;  3 -V rs rs [hl hl] 00bb 0000
;  101       for n loop
                               datalo_set v__floop1         ;  3 OV rs rS [hl hl] 00bc 1683
                               clrf     v__floop1           ;  3 OV rS rS [hl hl] 00bd 01a0
                               goto     l__l248             ;  3 OV rS rS [hl hl] 00be 28ca
l__l247
;  103             _usec_delay(_ten_us_delay3)
                               datalo_clr v__pic_temp       ;  3 -V rs rs [hl hl] 00bf 1283
                               datahi_clr v__pic_temp       ;  3 -V rs rs [hl hl] 00c0 1303
                               movlw    13                  ;  3 -V rs rs [hl hl] 00c1 300d
                               movwf    v__pic_temp         ;  3 -V rs rs [hl hl] 00c2 00a0
                               branchhi_clr l__l877         ;  3 -V rs rs [hl hl] 00c3 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l877         ;  3 -V rs rs [hl hl] 00c4 118a
                                                            ; W = v__pic_temp
l__l877
                               decfsz   v__pic_temp,f       ;  3 -V rs rs [hl hl] 00c5 0ba0
                               goto     l__l877             ;  3 -V rs rs [hl hl] 00c6 28c5
                               nop                          ;  3 -V rs rs [hl hl] 00c7 0000
;  107       end loop
                               datalo_set v__floop1         ;  3 OV rs rS [hl hl] 00c8 1683
                               incf     v__floop1,f         ;  3 OV rS rS [hl hl] 00c9 0aa0
l__l248
                               movf     v__floop1,w         ;  3 OV rS rS [hl hl] 00ca 0820
                               datalo_clr v___n_1           ;  3 OV rS rs [hl hl] 00cb 1283
                                                            ; W = v__floop1
                               subwf    v___n_1,w           ;  3 OV rs rs [hl hl] 00cc 026c
                                                            ; W = v__floop1
                               btfss    v__status, v__z     ;  3 OV rs rs [hl hl] 00cd 1d03
                               goto     l__l247             ;  3 OV rs rs [hl hl] 00ce 28bf
;  108    end if
l__l240
;  110 end procedure
l__l239
                               return                       ;  3 OV rs rs [hl hl] 00cf 0008
; c:\jallib\include\jal/print.jal
;   57 procedure print_crlf(volatile byte out device) is
;  265 procedure print_word_dec(volatile byte out device, word in data) is
l_print_word_dec
;  267    _print_universal_dec(device, data, 10000, 5)
                               movf     v____device_put_18,w;  1 OV rs rs [?? ??] 00d0 0861
                                                            ; W = v___data_36
                               movwf    v____device_put_21  ;  1 OV rs rs [?? ??] 00d1 00ea
                                                            ; W = v____device_put_18
                               movf     v____device_put_18+1,w;  1 OV rs rs [?? ??] 00d2 0862
                                                            ; W = v____device_put_21
                               movwf    v____device_put_21+1;  1 OV rs rs [?? ??] 00d3 00eb
                                                            ; W = v____device_put_18
                               movf     v___data_36,w       ;  1 OV rs rs [?? ??] 00d4 0867
                                                            ; W = v____device_put_21
                               datalo_set v___data_42       ;  1 OV rs rS [?? ??] 00d5 1683
                                                            ; W = v___data_36
                               movwf    v___data_42         ;  1 OV rS rS [?? ??] 00d6 00a0
                                                            ; W = v___data_36
                               datalo_clr v___data_36       ;  1 OV rS rs [?? ??] 00d7 1283
                                                            ; W = v___data_42
                               movf     v___data_36+1,w     ;  1 OV rs rs [?? ??] 00d8 0868
                                                            ; W = v___data_42
                               datalo_set v___data_42       ;  1 OV rs rS [?? ??] 00d9 1683
                                                            ; W = v___data_36
                               movwf    v___data_42+1       ;  1 OV rS rS [?? ??] 00da 00a1
                                                            ; W = v___data_36
                               clrf     v___data_42+2       ;  1 OV rS rS [?? ??] 00db 01a2
                                                            ; W = v___data_42
                               clrf     v___data_42+3       ;  1 OV rS rS [?? ??] 00dc 01a3
                                                            ; W = v___data_42
                               movlw    16                  ;  1 OV rS rS [?? ??] 00dd 3010
                                                            ; W = v___data_42
                               movwf    v___digit_divisor_5 ;  1 OV rS rS [?? ??] 00de 00a4
                               movlw    39                  ;  1 OV rS rS [?? ??] 00df 3027
                                                            ; W = v___digit_divisor_5
                               movwf    v___digit_divisor_5+1;  1 OV rS rS [?? ??] 00e0 00a5
                               clrf     v___digit_divisor_5+2;  1 OV rS rS [?? ??] 00e1 01a6
                                                            ; W = v___digit_divisor_5
                               clrf     v___digit_divisor_5+3;  1 OV rS rS [?? ??] 00e2 01a7
                                                            ; W = v___digit_divisor_5
                               movlw    5                   ;  1 OV rS rS [?? ??] 00e3 3005
                                                            ; W = v___digit_divisor_5
                               goto     l__print_universal_dec;  1 OV rS rS [?? ??] 00e4 28e5
;  269 end procedure
;  292 procedure _print_universal_dec(volatile byte out device, dword in data, sdword in digit_divisor, byte in digit_number) is
l__print_universal_dec
                               datalo_clr v___digit_number_5;  1 OV rS rs [?? ??] 00e5 1283
                               movwf    v___digit_number_5  ;  1 OV rs rs [?? ??] 00e6 00ee
;  296    if (data == 0) then
                               datalo_set v___data_42       ;  1 OV rs rS [?? ??] 00e7 1683
                                                            ; W = v___digit_number_5
                               movf     v___data_42,w       ;  1 OV rS rS [?? ??] 00e8 0820
                                                            ; W = v___digit_number_5
                               iorwf    v___data_42+1,w     ;  1 OV rS rS [?? ??] 00e9 0421
                                                            ; W = v___data_42
                               iorwf    v___data_42+2,w     ;  1 OV rS rS [?? ??] 00ea 0422
                               iorwf    v___data_42+3,w     ;  1 OV rS rS [?? ??] 00eb 0423
                               btfss    v__status, v__z     ;  1 OV rS rS [?? ??] 00ec 1d03
                               goto     l__l361             ;  1 OV rS rS [?? ??] 00ed 28f5
;  297       device = "0"      
                               movlw    48                  ;  1 OV rS rS [?? ??] 00ee 3030
                               datalo_clr v__pic_temp       ;  1 OV rS rs [?? ??] 00ef 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 00f0 00a0
                               movf     v____device_put_21,w;  1 OV rs rs [?? ??] 00f1 086a
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 00f2 00b6
                                                            ; W = v____device_put_21
                               movf     v____device_put_21+1,w;  1 OV rs rs [?? ??] 00f3 086b
                                                            ; W = v__pic_pointer
                               goto     l__pic_indirect     ;  1 OV rs rs [?? ??] 00f4 289a
                                                            ; W = v____device_put_21
;  298       return
;  299    end if
l__l361
;  301    no_digits_printed_yet = true
                               bsf      v____bitbucket_67, 0 ; no_digits_printed_yet;  1 OV rS rS [?? ??] 00f5 1429
;  302    while (digit_divisor > 0) loop
l__l362
                               datalo_set v___digit_divisor_5;  1 OV r? rS [?? ??] 00f6 1683
                                                            ; W = v_digit
                               movf     v___digit_divisor_5+3,w;  1 OV rS rS [?? ??] 00f7 0827
                                                            ; W = v_digit
                               xorlw    128                 ;  1 OV rS rS [?? ??] 00f8 3a80
                                                            ; W = v___digit_divisor_5
                               datalo_clr v__pic_temp       ;  1 OV rS rs [?? ??] 00f9 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 00fa 00a0
                               movlw    128                 ;  1 OV rs rs [?? ??] 00fb 3080
                                                            ; W = v__pic_temp
                               subwf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 00fc 0220
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 00fd 1d03
                               goto     l__l878             ;  1 OV rs rs [?? ??] 00fe 290a
                               movlw    0                   ;  1 OV rs rs [?? ??] 00ff 3000
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0100 1683
                               subwf    v___digit_divisor_5+2,w;  1 OV rS rS [?? ??] 0101 0226
                               btfss    v__status, v__z     ;  1 OV rS rS [?? ??] 0102 1d03
                               goto     l__l878             ;  1 OV rS rS [?? ??] 0103 290a
                               movlw    0                   ;  1 OV rS rS [?? ??] 0104 3000
                               subwf    v___digit_divisor_5+1,w;  1 OV rS rS [?? ??] 0105 0225
                               btfss    v__status, v__z     ;  1 OV rS rS [?? ??] 0106 1d03
                               goto     l__l878             ;  1 OV rS rS [?? ??] 0107 290a
                               movlw    0                   ;  1 OV rS rS [?? ??] 0108 3000
                               subwf    v___digit_divisor_5,w;  1 OV rS rS [?? ??] 0109 0224
l__l878
                               btfsc    v__status, v__z     ;  1 OV r? rS [?? ??] 010a 1903
                               goto     l__l363             ;  1 OV r? rS [?? ??] 010b 2988
                               btfss    v__status, v__c     ;  1 OV r? rS [?? ??] 010c 1c03
                               goto     l__l363             ;  1 OV r? rS [?? ??] 010d 2988
;  303       digit = byte ( data / digit_divisor )
                               datalo_set v___digit_divisor_5;  1 OV r? rS [?? ??] 010e 1683
                               movf     v___digit_divisor_5,w;  1 OV rS rS [?? ??] 010f 0824
                               datalo_clr v__pic_divisor    ;  1 OV rS rs [?? ??] 0110 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 0111 00a8
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0112 1683
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+1,w;  1 OV rS rS [?? ??] 0113 0825
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_divisor    ;  1 OV rS rs [?? ??] 0114 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+1    ;  1 OV rs rs [?? ??] 0115 00a9
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0116 1683
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+2,w;  1 OV rS rS [?? ??] 0117 0826
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_divisor    ;  1 OV rS rs [?? ??] 0118 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+2    ;  1 OV rs rs [?? ??] 0119 00aa
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 011a 1683
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+3,w;  1 OV rS rS [?? ??] 011b 0827
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_divisor    ;  1 OV rS rs [?? ??] 011c 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+3    ;  1 OV rs rs [?? ??] 011d 00ab
                                                            ; W = v___digit_divisor_5
                               datalo_set v___data_42       ;  1 OV rs rS [?? ??] 011e 1683
                                                            ; W = v__pic_divisor
                               movf     v___data_42,w       ;  1 OV rS rS [?? ??] 011f 0820
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 0120 1283
                                                            ; W = v___data_42
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 0121 00a0
                                                            ; W = v___data_42
                               datalo_set v___data_42       ;  1 OV rs rS [?? ??] 0122 1683
                                                            ; W = v__pic_dividend
                               movf     v___data_42+1,w     ;  1 OV rS rS [?? ??] 0123 0821
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 0124 1283
                                                            ; W = v___data_42
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 0125 00a1
                                                            ; W = v___data_42
                               datalo_set v___data_42       ;  1 OV rs rS [?? ??] 0126 1683
                                                            ; W = v__pic_dividend
                               movf     v___data_42+2,w     ;  1 OV rS rS [?? ??] 0127 0822
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 0128 1283
                                                            ; W = v___data_42
                               movwf    v__pic_dividend+2   ;  1 OV rs rs [?? ??] 0129 00a2
                                                            ; W = v___data_42
                               datalo_set v___data_42       ;  1 OV rs rS [?? ??] 012a 1683
                                                            ; W = v__pic_dividend
                               movf     v___data_42+3,w     ;  1 OV rS rS [?? ??] 012b 0823
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 012c 1283
                                                            ; W = v___data_42
                               movwf    v__pic_dividend+3   ;  1 OV rs rs [?? ??] 012d 00a3
                                                            ; W = v___data_42
                               call     l__pic_divide       ;  1 OV rs ?? [?? ??] 012e 2048
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 012f 1283
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 0130 082c
                               movwf    v_digit             ;  1 OV rs rs [?? ??] 0131 00ef
                                                            ; W = v__pic_quotient
;  304       data = data % digit_divisor
                               movf     v__pic_remainder,w  ;  1 OV rs rs [?? ??] 0132 0824
                                                            ; W = v_digit
                               datalo_set v___data_42       ;  1 OV rs rS [?? ??] 0133 1683
                                                            ; W = v__pic_remainder
                               movwf    v___data_42         ;  1 OV rS rS [?? ??] 0134 00a0
                                                            ; W = v__pic_remainder
                               datalo_clr v__pic_remainder  ;  1 OV rS rs [?? ??] 0135 1283
                                                            ; W = v___data_42
                               movf     v__pic_remainder+1,w;  1 OV rs rs [?? ??] 0136 0825
                                                            ; W = v___data_42
                               datalo_set v___data_42       ;  1 OV rs rS [?? ??] 0137 1683
                                                            ; W = v__pic_remainder
                               movwf    v___data_42+1       ;  1 OV rS rS [?? ??] 0138 00a1
                                                            ; W = v__pic_remainder
                               datalo_clr v__pic_remainder  ;  1 OV rS rs [?? ??] 0139 1283
                                                            ; W = v___data_42
                               movf     v__pic_remainder+2,w;  1 OV rs rs [?? ??] 013a 0826
                                                            ; W = v___data_42
                               datalo_set v___data_42       ;  1 OV rs rS [?? ??] 013b 1683
                                                            ; W = v__pic_remainder
                               movwf    v___data_42+2       ;  1 OV rS rS [?? ??] 013c 00a2
                                                            ; W = v__pic_remainder
                               datalo_clr v__pic_remainder  ;  1 OV rS rs [?? ??] 013d 1283
                                                            ; W = v___data_42
                               movf     v__pic_remainder+3,w;  1 OV rs rs [?? ??] 013e 0827
                                                            ; W = v___data_42
                               datalo_set v___data_42       ;  1 OV rs rS [?? ??] 013f 1683
                                                            ; W = v__pic_remainder
                               movwf    v___data_42+3       ;  1 OV rS rS [?? ??] 0140 00a3
                                                            ; W = v__pic_remainder
;  305       digit_divisor = digit_divisor / 10
                               movlw    10                  ;  1 OV rS rS [?? ??] 0141 300a
                                                            ; W = v___data_42
                               datalo_clr v__pic_divisor    ;  1 OV rS rs [?? ??] 0142 1283
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 0143 00a8
                               clrf     v__pic_divisor+1    ;  1 OV rs rs [?? ??] 0144 01a9
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+2    ;  1 OV rs rs [?? ??] 0145 01aa
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+3    ;  1 OV rs rs [?? ??] 0146 01ab
                                                            ; W = v__pic_divisor
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0147 1683
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5,w;  1 OV rS rS [?? ??] 0148 0824
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 0149 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 014a 00a0
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 014b 1683
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+1,w;  1 OV rS rS [?? ??] 014c 0825
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 014d 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 014e 00a1
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 014f 1683
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+2,w;  1 OV rS rS [?? ??] 0150 0826
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 0151 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+2   ;  1 OV rs rs [?? ??] 0152 00a2
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0153 1683
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+3,w;  1 OV rS rS [?? ??] 0154 0827
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 0155 1283
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+3   ;  1 OV rs rs [?? ??] 0156 00a3
                                                            ; W = v___digit_divisor_5
                               call     l__pic_sdivide      ;  1 OV rs ?? [?? ??] 0157 2027
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 0158 1283
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 0159 082c
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 015a 1683
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5 ;  1 OV rS rS [?? ??] 015b 00a4
                                                            ; W = v__pic_quotient
                               datalo_clr v__pic_quotient   ;  1 OV rS rs [?? ??] 015c 1283
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+1,w ;  1 OV rs rs [?? ??] 015d 082d
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 015e 1683
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+1;  1 OV rS rS [?? ??] 015f 00a5
                                                            ; W = v__pic_quotient
                               datalo_clr v__pic_quotient   ;  1 OV rS rs [?? ??] 0160 1283
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+2,w ;  1 OV rs rs [?? ??] 0161 082e
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0162 1683
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+2;  1 OV rS rS [?? ??] 0163 00a6
                                                            ; W = v__pic_quotient
                               datalo_clr v__pic_quotient   ;  1 OV rS rs [?? ??] 0164 1283
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+3,w ;  1 OV rs rs [?? ??] 0165 082f
                                                            ; W = v___digit_divisor_5
                               datalo_set v___digit_divisor_5;  1 OV rs rS [?? ??] 0166 1683
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+3;  1 OV rS rS [?? ??] 0167 00a7
                                                            ; W = v__pic_quotient
;  307       if ((digit != 0) | (no_digits_printed_yet == false)) then
                               datalo_clr v_digit           ;  1 OV rS rs [?? ??] 0168 1283
                                                            ; W = v___digit_divisor_5
                               movf     v_digit,w           ;  1 OV rs rs [?? ??] 0169 086f
                                                            ; W = v___digit_divisor_5
                               datalo_set v____bitbucket_67 ; _btemp22;  1 OV rs rS [?? ??] 016a 1683
                                                            ; W = v_digit
                               bsf      v____bitbucket_67, 3 ; _btemp22;  1 OV rS rS [?? ??] 016b 15a9
                                                            ; W = v_digit
                               btfsc    v__status, v__z     ;  1 OV rS rS [?? ??] 016c 1903
                                                            ; W = v_digit
                               bcf      v____bitbucket_67, 3 ; _btemp22;  1 OV rS rS [?? ??] 016d 11a9
                                                            ; W = v_digit
                               bcf      v____bitbucket_67, 4 ; _btemp23;  1 OV rS rS [?? ??] 016e 1229
                                                            ; W = v_digit
                               btfss    v____bitbucket_67, 0 ; no_digits_printed_yet;  1 OV rS rS [?? ??] 016f 1c29
                                                            ; W = v_digit
                               bsf      v____bitbucket_67, 4 ; _btemp23;  1 OV rS rS [?? ??] 0170 1629
                                                            ; W = v_digit
                               bcf      v____bitbucket_67, 5 ; _btemp24;  1 OV rS rS [?? ??] 0171 12a9
                                                            ; W = v_digit
                               btfss    v____bitbucket_67, 3 ; _btemp22;  1 OV rS rS [?? ??] 0172 1da9
                                                            ; W = v_digit
                               btfsc    v____bitbucket_67, 4 ; _btemp23;  1 OV rS rS [?? ??] 0173 1a29
                                                            ; W = v_digit
                               bsf      v____bitbucket_67, 5 ; _btemp24;  1 OV rS rS [?? ??] 0174 16a9
                                                            ; W = v_digit
                               btfss    v____bitbucket_67, 5 ; _btemp24;  1 OV rS rS [?? ??] 0175 1ea9
                                                            ; W = v_digit
                               goto     l__l366             ;  1 OV rS rS [?? ??] 0176 2985
                                                            ; W = v_digit
;  308          device = digit | "0"
                               movlw    48                  ;  1 OV rS rS [?? ??] 0177 3030
                               datalo_clr v_digit           ;  1 OV rS rs [?? ??] 0178 1283
                               iorwf    v_digit,w           ;  1 OV rs rs [?? ??] 0179 046f
                               datalo_set v____temp_53      ;  1 OV rs rS [?? ??] 017a 1683
                               movwf    v____temp_53        ;  1 OV rS rS [?? ??] 017b 00a8
                               movf     v____temp_53,w      ;  1 OV rS rS [?? ??] 017c 0828
                                                            ; W = v____temp_53
                               datalo_clr v__pic_temp       ;  1 OV rS rs [?? ??] 017d 1283
                                                            ; W = v____temp_53
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 017e 00a0
                                                            ; W = v____temp_53
                               movf     v____device_put_21,w;  1 OV rs rs [?? ??] 017f 086a
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0180 00b6
                                                            ; W = v____device_put_21
                               movf     v____device_put_21+1,w;  1 OV rs rs [?? ??] 0181 086b
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?? ??] 0182 209a
                                                            ; W = v____device_put_21
;  309          no_digits_printed_yet = false
                               datalo_set v____bitbucket_67 ; no_digits_printed_yet;  1 OV ?? ?S [?? ??] 0183 1683
                               bcf      v____bitbucket_67, 0 ; no_digits_printed_yet;  1 OV rS rS [?? ??] 0184 1029
;  310       end if
l__l366
;  311       digit_number = digit_number - 1
                               datalo_clr v___digit_number_5;  1 OV rS rs [?? ??] 0185 1283
                                                            ; W = v_digit
                               decf     v___digit_number_5,f;  1 OV rs rs [?? ??] 0186 03ee
                                                            ; W = v_digit
;  312    end loop
                               goto     l__l362             ;  1 OV rs rs [?? ??] 0187 28f6
                                                            ; W = v_digit
l__l363
;  314 end procedure
l__l280
                               return                       ;  1 OV r? rS [?? ??] 0188 0008
; c:\jallib\include\peripheral\usart/usart_common.jal
;   43 procedure _calculate_and_set_baudrate() is
l__calculate_and_set_baudrate
;   99                SPBRG = usart_div 
                               movlw    10                  ;  2 OV rs rs [hl hl] 0189 300a
                                                            ; W = v__portd_shadow
                               datalo_set v_spbrg           ;  2 OV rs rS [hl hl] 018a 1683
                               movwf    v_spbrg             ;  2 OV rS rS [hl hl] 018b 0099
;  103             TXSTA_BRGH = true
                               bsf      v_txsta, 2 ; txsta_brgh       ;  2 OV rS rS [hl hl] 018c 1518
;  152 end procedure
                               return                       ;  2 OV rS rS [hl hl] 018d 0008
; c:\jallib\include\peripheral\usart/serial_hardware.jal
;   25 procedure serial_hw_init() is 
l_serial_hw_init
;   27    _calculate_and_set_baudrate()
                               call     l__calculate_and_set_baudrate;  1 OV rs ?? [hl ??] 018e 2189
                                                            ; W = v__portd_shadow
;   30    PIE1_RCIE = false
                               datalo_set v_pie1 ; pie1_rcie         ;  1 OV ?? ?S [?? ??] 018f 1683
                               bcf      v_pie1, 5 ; pie1_rcie        ;  1 OV rS rS [?? ??] 0190 128c
;   31    PIE1_TXIE = false
                               bcf      v_pie1, 4 ; pie1_txie        ;  1 OV rS rS [?? ??] 0191 120c
;   34    TXSTA_TXEN = true
                               bsf      v_txsta, 5 ; txsta_txen       ;  1 OV rS rS [?? ??] 0192 1698
;   38    RCSTA = 0x90
                               movlw    144                 ;  1 OV rS rS [?? ??] 0193 3090
                               datalo_clr v_rcsta           ;  1 OV rS rs [?? ??] 0194 1283
                               movwf    v_rcsta             ;  1 OV rs rs [?? ??] 0195 0098
;   40 end procedure
                               return                       ;  1 OV rs rs [?? ??] 0196 0008
;   67 procedure serial_hw_write(byte in data) is
l_serial_hw_write
                               movwf    v___data_44         ;  1 OV rs rs [?? ??] 0197 00c1
                                                            ; W = v___data_52
;   69    while ! PIR1_TXIF loop end loop
l__l392
                               btfss    v_pir1, 4 ; pir1_txif        ;  1 OV rs rs [?? ??] 0198 1e0c
                                                            ; W = v___data_44
                               goto     l__l392             ;  1 OV rs rs [?? ??] 0199 2998
l__l393
;   71    TXREG = data
                               movf     v___data_44,w       ;  1 OV rs rs [?? ??] 019a 0841
                                                            ; W = v___data_44
                               movwf    v_txreg             ;  1 OV rs rs [?? ??] 019b 0099
                                                            ; W = v___data_44
;   72 end procedure
                               return                       ;  1 OV rs rs [?? ??] 019c 0008
;  146 procedure serial_hw_data'put(byte in data) is
l__serial_hw_data_put
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 019d 1283
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 019e 0820
                               movwf    v___data_52         ;  1 OV rs rs [?? ??] 019f 00c0
                                                            ; W = v__pic_temp
;  147    serial_hw_write(data)
                               movf     v___data_52,w       ;  1 OV rs rs [?? ??] 01a0 0840
                                                            ; W = v___data_52
                               goto     l_serial_hw_write   ;  1 OV rs rs [?? ??] 01a1 2997
                                                            ; W = v___data_52
;  148 end procedure
;  175 end function
l__l430
; okay_tank.jal
;   29 serial_hw_init()
                               call     l_serial_hw_init    ;  0 OV rs ?? [hl ??] 01a2 218e
                                                            ; W = v__portd_shadow
;   32 pin_ccp1_direction = output
                               datalo_set v_trisc ; pin_c2_direction        ;  0 OV ?? ?S [?? ??] 01a3 1683
                               bcf      v_trisc, 2 ; pin_c2_direction       ;  0 OV rS rS [?? ??] 01a4 1107
;   33 pin_ccp2_direction = output
                               bcf      v_trisc, 1 ; pin_c1_direction       ;  0 OV rS rS [?? ??] 01a5 1087
; c:\jallib\include\peripheral\pwm/pwm_common.jal
;   23 var volatile word _pr2_shadow_plus1 = 256           -- value(PR2) + 1
                               datalo_clr v__pr2_shadow_plus1;  0 OV rS rs [?? ??] 01a6 1283
                               clrf     v__pr2_shadow_plus1 ;  0 OV rs rs [?? ??] 01a7 01b9
                               movlw    1                   ;  0 OV rs rs [?? ??] 01a8 3001
                               movwf    v__pr2_shadow_plus1+1;  0 OV rs rs [?? ??] 01a9 00ba
;   50 procedure pwm_max_resolution(byte in prescaler) is
                               goto     l__l438             ;  0 OV rs rs [?? ??] 01aa 29d1
l_pwm_max_resolution
                               movwf    v___prescaler_1     ;  1 OV rs rs [?? ??] 01ab 00e1
;   52    _pr2_shadow_plus1 = 256                      -- for maximum resolution
                               clrf     v__pr2_shadow_plus1 ;  1 OV rs rs [?? ??] 01ac 01b9
                                                            ; W = v___prescaler_1
                               movlw    1                   ;  1 OV rs rs [?? ??] 01ad 3001
                                                            ; W = v___prescaler_1
                               movwf    v__pr2_shadow_plus1+1;  1 OV rs rs [?? ??] 01ae 00ba
;   53    PR2 = byte(_pr2_shadow_plus1 - 1)            -- set PR2
                               decf     v__pr2_shadow_plus1,w;  1 OV rs rs [?? ??] 01af 0339
                               datalo_set v_pr2             ;  1 OV rs rS [?? ??] 01b0 1683
                               movwf    v_pr2               ;  1 OV rS rS [?? ??] 01b1 0092
;   56    if prescaler == 1 then
                               movlw    1                   ;  1 OV rS rS [?? ??] 01b2 3001
                               datalo_clr v___prescaler_1   ;  1 OV rS rs [?? ??] 01b3 1283
                               subwf    v___prescaler_1,w   ;  1 OV rs rs [?? ??] 01b4 0261
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 01b5 1d03
                               goto     l__l435             ;  1 OV rs rs [?? ??] 01b6 29bb
;   57       T2CON_T2CKPS = 0b00                       -- prescaler 1:1
                               movlw    252                 ;  1 OV rs rs [?? ??] 01b7 30fc
                                                            ; W = v_t2con
                               andwf    v_t2con,f           ;  1 OV rs rs [?? ??] 01b8 0592
;   58       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?? ??] 01b9 1512
;   59    elsif prescaler == 4  then
                               return                       ;  1 OV rs rs [?? ??] 01ba 0008
l__l435
                               movlw    4                   ;  1 OV rs rs [?? ??] 01bb 3004
                               subwf    v___prescaler_1,w   ;  1 OV rs rs [?? ??] 01bc 0261
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 01bd 1d03
                               goto     l__l436             ;  1 OV rs rs [?? ??] 01be 29c5
;   60       T2CON_T2CKPS = 0b01                       -- prescaler 1:4
                               movlw    252                 ;  1 OV rs rs [?? ??] 01bf 30fc
                                                            ; W = v_t2con
                               andwf    v_t2con,w           ;  1 OV rs rs [?? ??] 01c0 0512
                               iorlw    1                   ;  1 OV rs rs [?? ??] 01c1 3801
                               movwf    v_t2con             ;  1 OV rs rs [?? ??] 01c2 0092
;   61       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?? ??] 01c3 1512
                                                            ; W = v_t2con
;   62    elsif prescaler == 16 then
                               return                       ;  1 OV rs rs [?? ??] 01c4 0008
                                                            ; W = v_t2con
l__l436
                               movlw    16                  ;  1 OV rs rs [?? ??] 01c5 3010
                               subwf    v___prescaler_1,w   ;  1 OV rs rs [?? ??] 01c6 0261
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 01c7 1d03
                               goto     l__l437             ;  1 OV rs rs [?? ??] 01c8 29cf
;   63       T2CON_T2CKPS = 0b10                       -- prescaler 1:16
                               movlw    252                 ;  1 OV rs rs [?? ??] 01c9 30fc
                               andwf    v_t2con,w           ;  1 OV rs rs [?? ??] 01ca 0512
                               iorlw    2                   ;  1 OV rs rs [?? ??] 01cb 3802
                               movwf    v_t2con             ;  1 OV rs rs [?? ??] 01cc 0092
;   64       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?? ??] 01cd 1512
                                                            ; W = v_t2con
;   65    else
                               return                       ;  1 OV rs rs [?? ??] 01ce 0008
                                                            ; W = v_t2con
l__l437
;   66       T2CON_TMR2ON = FALSE                      -- disable Timer2 (= PWM off!)
                               bcf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?? ??] 01cf 1112
;   67    end if
l__l434
;   69 end procedure
                               return                       ;  1 OV rs rs [?? ??] 01d0 0008
;  105 end procedure
l__l438
; c:\jallib\include\peripheral\pwm/pwm_ccp1.jal
;   23 var byte  _ccpr1l_shadow  = 0                            -- 8 MSbits of duty cycle
                               clrf     v__ccpr1l_shadow    ;  0 OV rs rs [?? ??] 01d1 01c3
;   24 var byte  _ccp1con_shadow = 0b0000_0000                  -- shadow
                               clrf     v__ccp1con_shadow   ;  0 OV rs rs [?? ??] 01d2 01c4
;   32 procedure pwm1_on() is
                               goto     l__l445             ;  0 OV rs rs [?? ??] 01d3 2a13
l_pwm1_on
;   34    _ccp1con_shadow_ccp1m = 0b1100                    -- set PWM mode
                               movlw    240                 ;  1 OV ?? ?? [?? ??] 01d4 30f0
                                                            ; W = v__ccp1con_shadow
                               datalo_clr v__ccp1con_shadow ;  1 OV ?? ?s [?? ??] 01d5 1283
                               andwf    v__ccp1con_shadow,w ;  1 OV rs rs [?? ??] 01d6 0544
                               iorlw    12                  ;  1 OV rs rs [?? ??] 01d7 380c
                               movwf    v__ccp1con_shadow   ;  1 OV rs rs [?? ??] 01d8 00c4
;   35    CCPR1L                = _ccpr1l_shadow            -- restore duty cycle
                               movf     v__ccpr1l_shadow,w  ;  1 OV rs rs [?? ??] 01d9 0843
                                                            ; W = v__ccp1con_shadow
                               movwf    v_ccpr1l            ;  1 OV rs rs [?? ??] 01da 0095
                                                            ; W = v__ccpr1l_shadow
;   36    CCP1CON               = _ccp1con_shadow           -- activate CCP module
                               movf     v__ccp1con_shadow,w ;  1 OV rs rs [?? ??] 01db 0844
                               movwf    v_ccp1con           ;  1 OV rs rs [?? ??] 01dc 0097
                                                            ; W = v__ccp1con_shadow
;   38 end procedure
                               return                       ;  1 OV rs rs [?? ??] 01dd 0008
;   57 procedure pwm1_set_dutycycle_highres(word in duty) is
l_pwm1_set_dutycycle_highres
;   59    if (duty > 1023) then                            -- upper limit
                               movlw    3                   ;  1 OV rs rs [?? ??] 01de 3003
                                                            ; W = v___duty_1
                               subwf    v___duty_1+1,w      ;  1 OV rs rs [?? ??] 01df 026d
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 01e0 1d03
                               goto     l__l882             ;  1 OV rs rs [?? ??] 01e1 29e4
                               movlw    255                 ;  1 OV rs rs [?? ??] 01e2 30ff
                                                            ; W = v___duty_1
                               subwf    v___duty_1,w        ;  1 OV rs rs [?? ??] 01e3 026c
l__l882
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 01e4 1903
                               goto     l__l454             ;  1 OV rs rs [?? ??] 01e5 29ec
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 01e6 1c03
                               goto     l__l454             ;  1 OV rs rs [?? ??] 01e7 29ec
;   60       duty = 1023
                               movlw    255                 ;  1 OV rs rs [?? ??] 01e8 30ff
                               movwf    v___duty_1          ;  1 OV rs rs [?? ??] 01e9 00ec
                               movlw    3                   ;  1 OV rs rs [?? ??] 01ea 3003
                                                            ; W = v___duty_1
                               movwf    v___duty_1+1        ;  1 OV rs rs [?? ??] 01eb 00ed
;   61    end if
l__l454
;   62    _ccpr1l_shadow = byte(duty >> 2)
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 01ec 1003
                               rrf      v___duty_1+1,w      ;  1 OV rs rs [?? ??] 01ed 0c6d
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 01ee 00a1
                               rrf      v___duty_1,w        ;  1 OV rs rs [?? ??] 01ef 0c6c
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01f0 00a0
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 01f1 1003
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp+1,f     ;  1 OV rs rs [?? ??] 01f2 0ca1
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp,f       ;  1 OV rs rs [?? ??] 01f3 0ca0
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 01f4 0820
                               movwf    v__ccpr1l_shadow    ;  1 OV rs rs [?? ??] 01f5 00c3
                                                            ; W = v__pic_temp
;   63    _ccp1con_shadow_dc1b = byte(duty) & 0b11
                               movlw    3                   ;  1 OV rs rs [?? ??] 01f6 3003
                                                            ; W = v__ccpr1l_shadow
                               andwf    v___duty_1,w        ;  1 OV rs rs [?? ??] 01f7 056c
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01f8 00a0
                               swapf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 01f9 0e20
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 01fa 00a1
                               movlw    48                  ;  1 OV rs rs [?? ??] 01fb 3030
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp+1,f     ;  1 OV rs rs [?? ??] 01fc 05a1
                               movlw    207                 ;  1 OV rs rs [?? ??] 01fd 30cf
                               andwf    v__ccp1con_shadow,w ;  1 OV rs rs [?? ??] 01fe 0544
                               iorwf    v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 01ff 0421
                               movwf    v__ccp1con_shadow   ;  1 OV rs rs [?? ??] 0200 00c4
;   65    pwm1_on()                                        -- activate PWM
                               goto     l_pwm1_on           ;  1 OV rs rs [?? ??] 0201 29d4
                                                            ; W = v__ccp1con_shadow
;   67 end procedure
;   98 procedure pwm1_set_dutycycle(byte in duty) is
l_pwm1_set_dutycycle
                               movwf    v___duty_5          ;  1 OV rs rs [?? ??] 0202 00e1
                                                            ; W = v_pwml
;  100    pwm1_set_dutycycle_highres(word(duty) << 2)
                               movf     v___duty_5,w        ;  1 OV rs rs [?? ??] 0203 0861
                                                            ; W = v___duty_5
                               movwf    v____temp_58        ;  1 OV rs rs [?? ??] 0204 00e3
                                                            ; W = v___duty_5
                               clrf     v____temp_58+1      ;  1 OV rs rs [?? ??] 0205 01e4
                                                            ; W = v____temp_58
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 0206 1003
                                                            ; W = v____temp_58
                               rlf      v____temp_58,w      ;  1 OV rs rs [?? ??] 0207 0d63
                                                            ; W = v____temp_58
                               movwf    v____temp_58+2      ;  1 OV rs rs [?? ??] 0208 00e5
                               rlf      v____temp_58+1,w    ;  1 OV rs rs [?? ??] 0209 0d64
                                                            ; W = v____temp_58
                               movwf    v____temp_58+3      ;  1 OV rs rs [?? ??] 020a 00e6
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 020b 1003
                                                            ; W = v____temp_58
                               rlf      v____temp_58+2,f    ;  1 OV rs rs [?? ??] 020c 0de5
                                                            ; W = v____temp_58
                               rlf      v____temp_58+3,f    ;  1 OV rs rs [?? ??] 020d 0de6
                               movf     v____temp_58+2,w    ;  1 OV rs rs [?? ??] 020e 0865
                               movwf    v___duty_1          ;  1 OV rs rs [?? ??] 020f 00ec
                                                            ; W = v____temp_58
                               movf     v____temp_58+3,w    ;  1 OV rs rs [?? ??] 0210 0866
                                                            ; W = v___duty_1
                               movwf    v___duty_1+1        ;  1 OV rs rs [?? ??] 0211 00ed
                                                            ; W = v____temp_58
                               goto     l_pwm1_set_dutycycle_highres;  1 OV rs rs [?? ??] 0212 29de
                                                            ; W = v___duty_1
;  102 end procedure
; c:\jallib\include\peripheral\pwm/pwm_hardware.jal
;   51 end if
l__l445
; c:\jallib\include\peripheral\pwm/pwm_ccp2.jal
;   23 var byte  _ccpr2l_shadow  = 0                            -- 8 MSbits of duty cycle
                               clrf     v__ccpr2l_shadow    ;  0 OV rs rs [?? ??] 0213 01c5
;   24 var byte  _ccp2con_shadow = 0b0000_0000                  -- shadow
                               clrf     v__ccp2con_shadow   ;  0 OV rs rs [?? ??] 0214 01c6
;   32 procedure pwm2_on() is
                               goto     l__l464             ;  0 OV rs rs [?? ??] 0215 2a55
l_pwm2_on
;   34    _ccp2con_shadow_ccp2m = 0b1100                    -- set PWM mode
                               movlw    240                 ;  1 OV ?? ?? [?? ??] 0216 30f0
                                                            ; W = v__ccp2con_shadow
                               datalo_clr v__ccp2con_shadow ;  1 OV ?? ?s [?? ??] 0217 1283
                               andwf    v__ccp2con_shadow,w ;  1 OV rs rs [?? ??] 0218 0546
                               iorlw    12                  ;  1 OV rs rs [?? ??] 0219 380c
                               movwf    v__ccp2con_shadow   ;  1 OV rs rs [?? ??] 021a 00c6
;   35    CCPR2L                = _ccpr2l_shadow            -- restore duty cycle
                               movf     v__ccpr2l_shadow,w  ;  1 OV rs rs [?? ??] 021b 0845
                                                            ; W = v__ccp2con_shadow
                               movwf    v_ccpr2l            ;  1 OV rs rs [?? ??] 021c 009b
                                                            ; W = v__ccpr2l_shadow
;   36    CCP2CON               = _ccp2con_shadow           -- activate CCP module
                               movf     v__ccp2con_shadow,w ;  1 OV rs rs [?? ??] 021d 0846
                               movwf    v_ccp2con           ;  1 OV rs rs [?? ??] 021e 009d
                                                            ; W = v__ccp2con_shadow
;   38 end procedure
                               return                       ;  1 OV rs rs [?? ??] 021f 0008
;   57 procedure pwm2_set_dutycycle_highres(word in duty) is
l_pwm2_set_dutycycle_highres
;   59    if (duty > 1023) then                            -- upper limit
                               movlw    3                   ;  1 OV rs rs [?? ??] 0220 3003
                                                            ; W = v___duty_8
                               subwf    v___duty_8+1,w      ;  1 OV rs rs [?? ??] 0221 026d
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 0222 1d03
                               goto     l__l884             ;  1 OV rs rs [?? ??] 0223 2a26
                               movlw    255                 ;  1 OV rs rs [?? ??] 0224 30ff
                                                            ; W = v___duty_8
                               subwf    v___duty_8,w        ;  1 OV rs rs [?? ??] 0225 026c
l__l884
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 0226 1903
                               goto     l__l473             ;  1 OV rs rs [?? ??] 0227 2a2e
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 0228 1c03
                               goto     l__l473             ;  1 OV rs rs [?? ??] 0229 2a2e
;   60       duty = 1023
                               movlw    255                 ;  1 OV rs rs [?? ??] 022a 30ff
                               movwf    v___duty_8          ;  1 OV rs rs [?? ??] 022b 00ec
                               movlw    3                   ;  1 OV rs rs [?? ??] 022c 3003
                                                            ; W = v___duty_8
                               movwf    v___duty_8+1        ;  1 OV rs rs [?? ??] 022d 00ed
;   61    end if
l__l473
;   62    _ccpr2l_shadow = byte(duty >> 2)
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 022e 1003
                               rrf      v___duty_8+1,w      ;  1 OV rs rs [?? ??] 022f 0c6d
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 0230 00a1
                               rrf      v___duty_8,w        ;  1 OV rs rs [?? ??] 0231 0c6c
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0232 00a0
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 0233 1003
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp+1,f     ;  1 OV rs rs [?? ??] 0234 0ca1
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp,f       ;  1 OV rs rs [?? ??] 0235 0ca0
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 0236 0820
                               movwf    v__ccpr2l_shadow    ;  1 OV rs rs [?? ??] 0237 00c5
                                                            ; W = v__pic_temp
;   63    _ccp2con_shadow_dc2b = byte(duty) & 0b11
                               movlw    3                   ;  1 OV rs rs [?? ??] 0238 3003
                                                            ; W = v__ccpr2l_shadow
                               andwf    v___duty_8,w        ;  1 OV rs rs [?? ??] 0239 056c
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 023a 00a0
                               swapf    v__pic_temp,w       ;  1 OV rs rs [?? ??] 023b 0e20
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 023c 00a1
                               movlw    48                  ;  1 OV rs rs [?? ??] 023d 3030
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp+1,f     ;  1 OV rs rs [?? ??] 023e 05a1
                               movlw    207                 ;  1 OV rs rs [?? ??] 023f 30cf
                               andwf    v__ccp2con_shadow,w ;  1 OV rs rs [?? ??] 0240 0546
                               iorwf    v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 0241 0421
                               movwf    v__ccp2con_shadow   ;  1 OV rs rs [?? ??] 0242 00c6
;   65    pwm2_on()                                        -- activate PWM
                               goto     l_pwm2_on           ;  1 OV rs rs [?? ??] 0243 2a16
                                                            ; W = v__ccp2con_shadow
;   67 end procedure
;   98 procedure pwm2_set_dutycycle(byte in duty) is
l_pwm2_set_dutycycle
                               movwf    v___duty_12         ;  1 OV rs rs [?? ??] 0244 00e1
                                                            ; W = v_pwmr
;  100    pwm2_set_dutycycle_highres(word(duty) << 2)
                               movf     v___duty_12,w       ;  1 OV rs rs [?? ??] 0245 0861
                                                            ; W = v___duty_12
                               movwf    v____temp_62        ;  1 OV rs rs [?? ??] 0246 00e3
                                                            ; W = v___duty_12
                               clrf     v____temp_62+1      ;  1 OV rs rs [?? ??] 0247 01e4
                                                            ; W = v____temp_62
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 0248 1003
                                                            ; W = v____temp_62
                               rlf      v____temp_62,w      ;  1 OV rs rs [?? ??] 0249 0d63
                                                            ; W = v____temp_62
                               movwf    v____temp_62+2      ;  1 OV rs rs [?? ??] 024a 00e5
                               rlf      v____temp_62+1,w    ;  1 OV rs rs [?? ??] 024b 0d64
                                                            ; W = v____temp_62
                               movwf    v____temp_62+3      ;  1 OV rs rs [?? ??] 024c 00e6
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 024d 1003
                                                            ; W = v____temp_62
                               rlf      v____temp_62+2,f    ;  1 OV rs rs [?? ??] 024e 0de5
                                                            ; W = v____temp_62
                               rlf      v____temp_62+3,f    ;  1 OV rs rs [?? ??] 024f 0de6
                               movf     v____temp_62+2,w    ;  1 OV rs rs [?? ??] 0250 0865
                               movwf    v___duty_8          ;  1 OV rs rs [?? ??] 0251 00ec
                                                            ; W = v____temp_62
                               movf     v____temp_62+3,w    ;  1 OV rs rs [?? ??] 0252 0866
                                                            ; W = v___duty_8
                               movwf    v___duty_8+1        ;  1 OV rs rs [?? ??] 0253 00ed
                                                            ; W = v____temp_62
                               goto     l_pwm2_set_dutycycle_highres;  1 OV rs rs [?? ??] 0254 2a20
                                                            ; W = v___duty_8
;  102 end procedure
; c:\jallib\include\peripheral\pwm/pwm_hardware.jal
;   55 end if
l__l464
; okay_tank.jal
;   35 pwm_max_resolution(16)
                               movlw    16                  ;  0 OV rs rs [?? ??] 0255 3010
                               call     l_pwm_max_resolution;  0 OV rs ?? [?? ??] 0256 21ab
;   36 pwm1_on()
                               call     l_pwm1_on           ;  0 OV ?? ?? [?? ??] 0257 21d4
;   37 pwm2_on()
                               call     l_pwm2_on           ;  0 OV ?? ?? [?? ??] 0258 2216
; c:\jallib\include\peripheral\timer/timer0_isr_interval.jal
;   52 function isr_counter'get() return word is
                               goto     l__l515             ;  0 OV ?? ?? [?? ??] 0259 2b07
l__isr_counter_get
;   55    INTCON_TMR0IE = off
                               bcf      v_intcon, 5 ; intcon_tmr0ie      ;  1 OV ?? ?? [?? ??] 025a 128b
;   56    temp = internal_isr_counter
                               datalo_clr v_internal_isr_counter;  1 OV ?? ?s [?? ??] 025b 1283
                               movf     v_internal_isr_counter,w;  1 OV rs rs [?? ??] 025c 0847
                               movwf    v_temp              ;  1 OV rs rs [?? ??] 025d 00e1
                                                            ; W = v_internal_isr_counter
                               movf     v_internal_isr_counter+1,w;  1 OV rs rs [?? ??] 025e 0848
                                                            ; W = v_temp
                               movwf    v_temp+1            ;  1 OV rs rs [?? ??] 025f 00e2
                                                            ; W = v_internal_isr_counter
;   57    INTCON_TMR0IE = on
                               bsf      v_intcon, 5 ; intcon_tmr0ie      ;  1 OV rs rs [?? ??] 0260 168b
                                                            ; W = v_temp
;   59    return temp
                               movf     v_temp,w            ;  1 OV rs rs [?? ??] 0261 0861
                                                            ; W = v_temp
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0262 00a0
                                                            ; W = v_temp
                               movf     v_temp+1,w          ;  1 OV rs rs [?? ??] 0263 0862
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 0264 00a1
                                                            ; W = v_temp
;   60 end function
                               return                       ;  1 OV rs rs [?? ??] 0265 0008
                                                            ; W = v__pic_temp
;   62 procedure set_delay(byte in slot, word in ticks) is
l_set_delay
                               movwf    v___slot_1          ;  1 OV rs rs [?? ??] 0266 00e1
;   64    if (slot >= DELAY_SLOTS) then return end if
                               movlw    2                   ;  1 OV rs rs [?? ??] 0267 3002
                                                            ; W = v___slot_1
                               subwf    v___slot_1,w        ;  1 OV rs rs [?? ??] 0268 0261
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 0269 1903
                               goto     l__l887             ;  1 OV rs rs [?? ??] 026a 2a6d
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 026b 1c03
                               goto     l__l496             ;  1 OV rs rs [?? ??] 026c 2a6e
l__l887
                               return                       ;  1 OV rs rs [?? ??] 026d 0008
l__l496
;   66    INTCON_TMR0IE = off
                               bcf      v_intcon, 5 ; intcon_tmr0ie      ;  1 OV rs rs [?? ??] 026e 128b
;   67    isr_countdown[slot] = ticks
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 026f 1003
                               rlf      v___slot_1,w        ;  1 OV rs rs [?? ??] 0270 0d61
                               movwf    v____temp_64        ;  1 OV rs rs [?? ??] 0271 00e9
                               movlw    v_isr_countdown     ;  1 OV rs rs [?? ??] 0272 3049
                                                            ; W = v____temp_64
                               addwf    v____temp_64,w      ;  1 OV rs rs [?? ??] 0273 0769
                               movwf    v__fsr              ;  1 OV rs rs [?? ??] 0274 0084
                               irp_clr                      ;  1 OV rs rs [?? ??] 0275 1383
                               movf     v___ticks_1,w       ;  1 OV rs rs [?? ??] 0276 0863
                               movwf    v__ind              ;  1 OV rs rs [?? ??] 0277 0080
                                                            ; W = v___ticks_1
                               incf     v__fsr,f            ;  1 OV rs rs [?? ??] 0278 0a84
                               movf     v___ticks_1+1,w     ;  1 OV rs rs [?? ??] 0279 0864
                               movwf    v__ind              ;  1 OV rs rs [?? ??] 027a 0080
                                                            ; W = v___ticks_1
;   68    INTCON_TMR0IE = on
                               bsf      v_intcon, 5 ; intcon_tmr0ie      ;  1 OV rs rs [?? ??] 027b 168b
;   70 end procedure
l__l494
                               return                       ;  1 OV rs rs [?? ??] 027c 0008
;   72 function check_delay(byte in slot) return bit is
l_check_delay
                               movwf    v___slot_3          ;  1 OV rs rs [?? ??] 027d 00e1
;   74    if (slot >= DELAY_SLOTS) then return true end if
                               movlw    2                   ;  1 OV rs rs [?? ??] 027e 3002
                                                            ; W = v___slot_3
                               subwf    v___slot_3,w        ;  1 OV rs rs [?? ??] 027f 0261
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 0280 1903
                               goto     l__l889             ;  1 OV rs rs [?? ??] 0281 2a84
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 0282 1c03
                               goto     l__l500             ;  1 OV rs rs [?? ??] 0283 2a86
l__l889
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 0284 1420
                               return                       ;  1 OV rs rs [?? ??] 0285 0008
l__l500
;   76    if (isr_countdown[slot] == 0) then
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 0286 1003
                               rlf      v___slot_3,w        ;  1 OV rs rs [?? ??] 0287 0d61
                               movwf    v____temp_65        ;  1 OV rs rs [?? ??] 0288 00e3
                               movlw    v_isr_countdown     ;  1 OV rs rs [?? ??] 0289 3049
                                                            ; W = v____temp_65
                               addwf    v____temp_65,w      ;  1 OV rs rs [?? ??] 028a 0763
                               movwf    v__fsr              ;  1 OV rs rs [?? ??] 028b 0084
                               irp_clr                      ;  1 OV rs rs [?? ??] 028c 1383
                               movf     v__ind,w            ;  1 OV rs rs [?? ??] 028d 0800
                               incf     v__fsr,f            ;  1 OV rs rs [?? ??] 028e 0a84
                               iorwf    v__ind,w            ;  1 OV rs rs [?? ??] 028f 0400
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 0290 1d03
                               goto     l__l502             ;  1 OV rs rs [?? ??] 0291 2aa0
;   77       if (isr_countdown[slot] == 0) then
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 0292 1003
                               rlf      v___slot_3,w        ;  1 OV rs rs [?? ??] 0293 0d61
                               movwf    v____temp_65+1      ;  1 OV rs rs [?? ??] 0294 00e4
                               movlw    v_isr_countdown     ;  1 OV rs rs [?? ??] 0295 3049
                                                            ; W = v____temp_65
                               addwf    v____temp_65+1,w    ;  1 OV rs rs [?? ??] 0296 0764
                               movwf    v__fsr              ;  1 OV rs rs [?? ??] 0297 0084
                               irp_clr                      ;  1 OV rs rs [?? ??] 0298 1383
                               movf     v__ind,w            ;  1 OV rs rs [?? ??] 0299 0800
                               incf     v__fsr,f            ;  1 OV rs rs [?? ??] 029a 0a84
                               iorwf    v__ind,w            ;  1 OV rs rs [?? ??] 029b 0400
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 029c 1d03
                               goto     l__l501             ;  1 OV rs rs [?? ??] 029d 2aa0
;   80          return true    -- delay passed
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 029e 1420
                               return                       ;  1 OV rs rs [?? ??] 029f 0008
;   82    end if
l__l502
l__l501
;   84    return false -- still waiting
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 02a0 1020
;   86 end function
l__l498
                               return                       ;  1 OV rs rs [?? ??] 02a1 0008
;   88 procedure timer0_isr_init() is
l_timer0_isr_init
;  108       OPTION_REG_PS = 4 ; prescaler 32
                               movlw    248                 ;  1 OV ?? ?? [?? ??] 02a2 30f8
                               datalo_set v_option_reg      ;  1 OV ?? ?S [?? ??] 02a3 1683
                               andwf    v_option_reg,w      ;  1 OV ?S ?S [?? ??] 02a4 0501
                               iorlw    4                   ;  1 OV ?S ?S [?? ??] 02a5 3804
                               movwf    v_option_reg        ;  1 OV ?S ?S [?? ??] 02a6 0081
;  109       timer0_load = 255 - byte(timer0_div / 32)
                               movlw    99                  ;  1 OV ?S ?S [?? ??] 02a7 3063
                                                            ; W = v_option_reg
                               datalo_clr v_timer0_load     ;  1 OV ?S ?s [?? ??] 02a8 1283
                               movwf    v_timer0_load       ;  1 OV rs rs [?? ??] 02a9 00cd
;  128    OPTION_REG_T0CS = 0  ; internal clock
                               datalo_set v_option_reg ; option_reg_t0cs   ;  1 OV rs rS [?? ??] 02aa 1683
                                                            ; W = v_timer0_load
                               bcf      v_option_reg, 5 ; option_reg_t0cs  ;  1 OV rS rS [?? ??] 02ab 1281
                                                            ; W = v_timer0_load
;  129    OPTION_REG_PSA  = 0  ; assign prescaler to timer0
                               bcf      v_option_reg, 3 ; option_reg_psa  ;  1 OV rS rS [?? ??] 02ac 1181
                                                            ; W = v_timer0_load
;  131    INTCON_TMR0IF = off
                               bcf      v_intcon, 2 ; intcon_tmr0if      ;  1 OV rS rS [?? ??] 02ad 110b
                                                            ; W = v_timer0_load
;  132    INTCON_TMR0IE = on
                               bsf      v_intcon, 5 ; intcon_tmr0ie      ;  1 OV rS rS [?? ??] 02ae 168b
                                                            ; W = v_timer0_load
;  133    INTCON_GIE  = on    ; enable global interrupts
                               bsf      v_intcon, 7 ; intcon_gie      ;  1 OV rS rS [?? ??] 02af 178b
                                                            ; W = v_timer0_load
;  134    INTCON_PEIE = on
                               bsf      v_intcon, 6 ; intcon_peie      ;  1 OV rS rS [?? ??] 02b0 170b
                                                            ; W = v_timer0_load
;  137    for DELAY_SLOTS using i loop
                               datalo_clr v___i_1           ;  1 OV rS rs [?? ??] 02b1 1283
                                                            ; W = v_timer0_load
                               clrf     v___i_1             ;  1 OV rs rs [?? ??] 02b2 01e1
                                                            ; W = v_timer0_load
l__l512
;  138       isr_countdown[i] = 0
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 02b3 1003
                               rlf      v___i_1,w           ;  1 OV rs rs [?? ??] 02b4 0d61
                               movwf    v____temp_66        ;  1 OV rs rs [?? ??] 02b5 00e3
                               movlw    v_isr_countdown     ;  1 OV rs rs [?? ??] 02b6 3049
                                                            ; W = v____temp_66
                               addwf    v____temp_66,w      ;  1 OV rs rs [?? ??] 02b7 0763
                               movwf    v__fsr              ;  1 OV rs rs [?? ??] 02b8 0084
                               irp_clr                      ;  1 OV rs rs [?? ??] 02b9 1383
                               clrf     v__ind              ;  1 OV rs rs [?? ??] 02ba 0180
                               incf     v__fsr,f            ;  1 OV rs rs [?? ??] 02bb 0a84
                               clrf     v__ind              ;  1 OV rs rs [?? ??] 02bc 0180
;  139    end loop
                               incf     v___i_1,f           ;  1 OV rs rs [?? ??] 02bd 0ae1
                               movlw    2                   ;  1 OV rs rs [?? ??] 02be 3002
                               subwf    v___i_1,w           ;  1 OV rs rs [?? ??] 02bf 0261
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 02c0 1d03
                               goto     l__l512             ;  1 OV rs rs [?? ??] 02c1 2ab3
;  142 end procedure
                               return                       ;  1 OV rs rs [?? ??] 02c2 0008
;  144 procedure ISR() is
l_isr
;  147    if INTCON_TMR0IF == true then
                               btfss    v_intcon, 2 ; intcon_tmr0if      ;  4 OV rs rs [hl hl] 02c3 1d0b
                               goto     l__l518             ;  4 OV rs rs [hl hl] 02c4 2afa
;  148       tmr0 = timer0_load
                               movf     v_timer0_load,w     ;  4 OV rs rs [hl hl] 02c5 084d
                               movwf    v_tmr0              ;  4 OV rs rs [hl hl] 02c6 0081
                                                            ; W = v_timer0_load
;  151       internal_isr_counter = internal_isr_counter + 1
                               incf     v_internal_isr_counter,f;  4 OV rs rs [hl hl] 02c7 0ac7
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 02c8 1903
                               incf     v_internal_isr_counter+1,f;  4 OV rs rs [hl hl] 02c9 0ac8
;  154       for DELAY_SLOTS using index loop
                               clrf     v_index             ;  4 OV rs rs [hl hl] 02ca 01bf
l__l519
;  155          if (isr_countdown[index] != 0) then
                               bcf      v__status, v__c     ;  4 OV rs rs [hl hl] 02cb 1003
                               rlf      v_index,w           ;  4 OV rs rs [hl hl] 02cc 0d3f
                               movwf    v____temp_67        ;  4 OV rs rs [hl hl] 02cd 00bc
                               movlw    v_isr_countdown     ;  4 OV rs rs [hl hl] 02ce 3049
                                                            ; W = v____temp_67
                               addwf    v____temp_67,w      ;  4 OV rs rs [hl hl] 02cf 073c
                               movwf    v__fsr              ;  4 OV rs rs [hl hl] 02d0 0084
                               irp_clr                      ;  4 OV rs rs [hl hl] 02d1 1383
                               movf     v__ind,w            ;  4 OV rs rs [hl hl] 02d2 0800
                               incf     v__fsr,f            ;  4 OV rs rs [hl hl] 02d3 0a84
                               iorwf    v__ind,w            ;  4 OV rs rs [hl hl] 02d4 0400
                               btfsc    v__status, v__z     ;  4 OV rs rs [hl hl] 02d5 1903
                               goto     l__l523             ;  4 OV rs rs [hl hl] 02d6 2af4
;  156             isr_countdown[index] = isr_countdown[index] - 1
                               bcf      v__status, v__c     ;  4 OV rs rs [hl hl] 02d7 1003
                               rlf      v_index,w           ;  4 OV rs rs [hl hl] 02d8 0d3f
                               movwf    v____temp_67+1      ;  4 OV rs rs [hl hl] 02d9 00bd
                               bcf      v__status, v__c     ;  4 OV rs rs [hl hl] 02da 1003
                                                            ; W = v____temp_67
                               rlf      v_index,w           ;  4 OV rs rs [hl hl] 02db 0d3f
                                                            ; W = v____temp_67
                               movwf    v____temp_67+2      ;  4 OV rs rs [hl hl] 02dc 00be
                               movlw    v_isr_countdown     ;  4 OV rs rs [hl hl] 02dd 3049
                                                            ; W = v____temp_67
                               addwf    v____temp_67+2,w    ;  4 OV rs rs [hl hl] 02de 073e
                               movwf    v__fsr              ;  4 OV rs rs [hl hl] 02df 0084
                               irp_clr                      ;  4 OV rs rs [hl hl] 02e0 1383
                               movf     v__ind,w            ;  4 OV rs rs [hl hl] 02e1 0800
                               movwf    v__pic_temp         ;  4 OV rs rs [hl hl] 02e2 00a0
                               incf     v__fsr,f            ;  4 OV rs rs [hl hl] 02e3 0a84
                                                            ; W = v__pic_temp
                               movf     v__ind,w            ;  4 OV rs rs [hl hl] 02e4 0800
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  4 OV rs rs [hl hl] 02e5 00a1
                               movlw    v_isr_countdown+1   ;  4 OV rs rs [hl hl] 02e6 304a
                                                            ; W = v__pic_temp
                               addwf    v____temp_67+1,w    ;  4 OV rs rs [hl hl] 02e7 073d
                               movwf    v__fsr              ;  4 OV rs rs [hl hl] 02e8 0084
                               irp_clr                      ;  4 OV rs rs [hl hl] 02e9 1383
                               movf     v__pic_temp+1,w     ;  4 OV rs rs [hl hl] 02ea 0821
                               movwf    v__ind              ;  4 OV rs rs [hl hl] 02eb 0080
                                                            ; W = v__pic_temp
                               decf     v__fsr,f            ;  4 OV rs rs [hl hl] 02ec 0384
                               movlw    1                   ;  4 OV rs rs [hl hl] 02ed 3001
                               subwf    v__pic_temp,w       ;  4 OV rs rs [hl hl] 02ee 0220
                               movwf    v__ind              ;  4 OV rs rs [hl hl] 02ef 0080
                               movlw    1                   ;  4 OV rs rs [hl hl] 02f0 3001
                               incf     v__fsr,f            ;  4 OV rs rs [hl hl] 02f1 0a84
                               btfss    v__status, v__c     ;  4 OV rs rs [hl hl] 02f2 1c03
                               subwf    v__ind,f            ;  4 OV rs rs [hl hl] 02f3 0280
;  157          end if
l__l523
;  158       end loop
                               incf     v_index,f           ;  4 OV rs rs [hl hl] 02f4 0abf
                               movlw    2                   ;  4 OV rs rs [hl hl] 02f5 3002
                               subwf    v_index,w           ;  4 OV rs rs [hl hl] 02f6 023f
                               btfss    v__status, v__z     ;  4 OV rs rs [hl hl] 02f7 1d03
                               goto     l__l519             ;  4 OV rs rs [hl hl] 02f8 2acb
;  165       INTCON_TMR0IF = off
                               bcf      v_intcon, 2 ; intcon_tmr0if      ;  4 OV rs rs [hl hl] 02f9 110b
;  167    end if
l__l518
;  169 end procedure
                               movf     v__pic_isr_state,w  ;  4 OV rs rs [hl hl] 02fa 0830
                               movwf    v__pic_state        ;  4 OV rs rs [hl hl] 02fb 00a0
                               movf     v__pic_isr_state+1,w;  4 OV rs rs [hl hl] 02fc 0831
                                                            ; W = v__pic_state
                               movwf    v__pic_state+1      ;  4 OV rs rs [hl hl] 02fd 00a1
                               movf     v__pic_isr_fsr,w    ;  4 OV rs rs [hl hl] 02fe 0838
                                                            ; W = v__pic_state
                               movwf    v__fsr              ;  4 OV rs rs [hl hl] 02ff 0084
                                                            ; W = v__pic_isr_fsr
                               movf     v__pic_isr_pclath,w ;  4 -V rs rs [hl hl] 0300 0833
                               movwf    v__pclath           ;  4 -V rs rs [hl hl] 0301 008a
                                                            ; W = v__pic_isr_pclath
                               swapf    v__pic_isr_status,w ;  4 -V rs rs [hl hl] 0302 0e32
                               movwf    v__status           ;  4 -V rs rs [hl hl] 0303 0083
                               swapf    v__pic_isr_w,f      ;  4 -V rs rs [hl hl] 0304 0eff
                               swapf    v__pic_isr_w,w      ;  4 -V rs rs [hl hl] 0305 0e7f
                               retfie                       ;  4 -V rs rs [hl hl] 0306 0009
l__l515
; okay_tank.jal
;   43 timer0_isr_init()             -- init timer0 isr
                               call     l_timer0_isr_init   ;  0 OV ?? ?? [?? ??] 0307 22a2
; c:\jallib\include\peripheral\adc/adc_channels.jal
;  132    _debug "ADC channels config: dependent pins, via PCFG bits"
;  134    procedure _adc_setup_pins() is
                               goto     l__l599             ;  0 OV ?? ?? [?? ??] 0308 2b3e
; 2432    procedure _adc_vref() is
l__adc_vref
; 2433    end procedure
                               return                       ; 4294967295 OV -- -- [-- --] 0309 0008
                                                            ; W = v_adcon1
; c:\jallib\include\peripheral\adc/adc_clock.jal
;   31 function _adc_eval_tad(word in factor) return bit is
l__adc_eval_tad
;   42    var bit tad_ok = false
                               bcf      v____bitbucket_10, 0 ; tad_ok;  1 OV rs rs [?? ??] 030a 106a
                                                            ; W = v___factor_1
;   43    tad_value = byte((factor * 10) / (target_clock / 1_000_000))
                               movf     v___factor_1,w      ;  1 OV rs rs [?? ??] 030b 0861
                                                            ; W = v___factor_1
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?? ??] 030c 00a0
                                                            ; W = v___factor_1
                               movf     v___factor_1+1,w    ;  1 OV rs rs [?? ??] 030d 0862
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplier+1 ;  1 OV rs rs [?? ??] 030e 00a1
                                                            ; W = v___factor_1
                               movlw    10                  ;  1 OV rs rs [?? ??] 030f 300a
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?? ??] 0310 00a2
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?? ??] 0311 01a3
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?? ??] 0312 2014
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 0313 1283
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 0314 0824
                               movwf    v____temp_68        ;  1 OV rs rs [?? ??] 0315 00e7
                                                            ; W = v__pic_mresult
                               movf     v__pic_mresult+1,w  ;  1 OV rs rs [?? ??] 0316 0825
                                                            ; W = v____temp_68
                               movwf    v____temp_68+1      ;  1 OV rs rs [?? ??] 0317 00e8
                                                            ; W = v__pic_mresult
                               movlw    20                  ;  1 OV rs rs [?? ??] 0318 3014
                                                            ; W = v____temp_68
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 0319 00a8
                               clrf     v__pic_divisor+1    ;  1 OV rs rs [?? ??] 031a 01a9
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+2    ;  1 OV rs rs [?? ??] 031b 01aa
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+3    ;  1 OV rs rs [?? ??] 031c 01ab
                                                            ; W = v__pic_divisor
                               movf     v____temp_68,w      ;  1 OV rs rs [?? ??] 031d 0867
                                                            ; W = v__pic_divisor
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 031e 00a0
                                                            ; W = v____temp_68
                               movf     v____temp_68+1,w    ;  1 OV rs rs [?? ??] 031f 0868
                                                            ; W = v__pic_dividend
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 0320 00a1
                                                            ; W = v____temp_68
                               clrf     v__pic_dividend+2   ;  1 OV rs rs [?? ??] 0321 01a2
                                                            ; W = v__pic_dividend
                               clrf     v__pic_dividend+3   ;  1 OV rs rs [?? ??] 0322 01a3
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  1 OV rs ?? [?? ??] 0323 2048
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 0324 1283
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 0325 082c
                               movwf    v_tad_value         ;  1 OV rs rs [?? ??] 0326 00ce
                                                            ; W = v__pic_quotient
;   44    if tad_value >= ADC_MIN_TAD & tad_value < ADC_MAX_TAD then
                               movlw    16                  ;  1 OV rs rs [?? ??] 0327 3010
                                                            ; W = v_tad_value
                               subwf    v_tad_value,w       ;  1 OV rs rs [?? ??] 0328 024e
                               bcf      v____bitbucket_10, 1 ; _btemp54;  1 OV rs rs [?? ??] 0329 10ea
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 032a 1d03
                               btfsc    v__status, v__c     ;  1 OV rs rs [?? ??] 032b 1803
                               bsf      v____bitbucket_10, 1 ; _btemp54;  1 OV rs rs [?? ??] 032c 14ea
                               movlw    60                  ;  1 OV rs rs [?? ??] 032d 303c
                               subwf    v_tad_value,w       ;  1 OV rs rs [?? ??] 032e 024e
                               bcf      v____bitbucket_10, 2 ; _btemp55;  1 OV rs rs [?? ??] 032f 116a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 0330 1903
                               goto     l__l892             ;  1 OV rs rs [?? ??] 0331 2b34
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 0332 1c03
                               bsf      v____bitbucket_10, 2 ; _btemp55;  1 OV rs rs [?? ??] 0333 156a
l__l892
                               bsf      v____bitbucket_10, 3 ; _btemp56;  1 OV rs rs [?? ??] 0334 15ea
                               btfsc    v____bitbucket_10, 1 ; _btemp54;  1 OV rs rs [?? ??] 0335 18ea
                               btfss    v____bitbucket_10, 2 ; _btemp55;  1 OV rs rs [?? ??] 0336 1d6a
                               bcf      v____bitbucket_10, 3 ; _btemp56;  1 OV rs rs [?? ??] 0337 11ea
                               btfsc    v____bitbucket_10, 3 ; _btemp56;  1 OV rs rs [?? ??] 0338 19ea
;   45 	  tad_ok = true
                               bsf      v____bitbucket_10, 0 ; tad_ok;  1 OV rs rs [?? ??] 0339 146a
;   46    end if
l__l582
;   47    return tad_ok
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 033a 1020
                               btfsc    v____bitbucket_10, 0 ; tad_ok;  1 OV rs rs [?? ??] 033b 186a
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 033c 1420
;   48 end function
                               return                       ;  1 OV rs rs [?? ??] 033d 0008
; c:\jallib\include\peripheral\adc/adc.jal
;   55 end if
l__l599
;   72 var volatile byte _adcon0_shadow = 0
                               datalo_clr v__adcon0_shadow  ;  0 OV ?? ?s [?? ??] 033e 1283
                               clrf     v__adcon0_shadow    ;  0 OV rs rs [?? ??] 033f 01bb
;   77 procedure _adc_read_low_res(byte in adc_chan, byte out adc_byte) is
                               goto     l__l732             ;  0 OV rs rs [?? ??] 0340 2b81
l__adc_read_low_res
                               movwf    v___adc_chan_1      ;  2 OV rs rs [?? ??] 0341 00e9
                                                            ; W = v___adc_chan_3
;   79    ADCON0_CHS = adc_chan
                               rlf      v___adc_chan_1,w    ;  2 OV rs rs [?? ??] 0342 0d69
                                                            ; W = v___adc_chan_1
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 0343 00a0
                               rlf      v__pic_temp,f       ;  2 OV rs rs [?? ??] 0344 0da0
                                                            ; W = v__pic_temp
                               rlf      v__pic_temp,f       ;  2 OV rs rs [?? ??] 0345 0da0
                               movlw    56                  ;  2 OV rs rs [?? ??] 0346 3038
                               andwf    v__pic_temp,f       ;  2 OV rs rs [?? ??] 0347 05a0
                               movlw    199                 ;  2 OV rs rs [?? ??] 0348 30c7
                               andwf    v_adcon0,w          ;  2 OV rs rs [?? ??] 0349 051f
                               iorwf    v__pic_temp,w       ;  2 OV rs rs [?? ??] 034a 0420
                               movwf    v_adcon0            ;  2 OV rs rs [?? ??] 034b 009f
;   80    ADCON0_ADON = true                -- turn on ADC module
                               bsf      v_adcon0, 0 ; adcon0_adon      ;  2 OV rs rs [?? ??] 034c 141f
                                                            ; W = v_adcon0
;   81    delay_10us(adc_conversion_delay)  -- wait acquisition time
                               movf     v_adc_conversion_delay,w;  2 OV rs rs [?? ??] 034d 084f
                                                            ; W = v_adcon0
                               call     l_delay_10us        ;  2 OV rs ?? [?? ??] 034e 20a0
                                                            ; W = v_adc_conversion_delay
;   82    ADCON0_GO = true                  -- start conversion
                               datalo_clr v_adcon0 ; adcon0_go       ;  2 OV ?? ?s [?? ??] 034f 1283
                               bsf      v_adcon0, 2 ; adcon0_go      ;  2 OV rs rs [?? ??] 0350 151f
;   83    while ADCON0_GO loop end loop     -- wait till conversion finished
l__l605
                               btfsc    v_adcon0, 2 ; adcon0_go      ;  2 OV rs rs [?? ??] 0351 191f
                               goto     l__l605             ;  2 OV rs rs [?? ??] 0352 2b51
l__l606
;   90       adc_byte = ADRESH                  -- read high byte 
                               movf     v_adresh,w          ;  2 OV rs rs [?? ??] 0353 081e
                               movwf    v___adc_byte_1      ;  2 OV rs rs [?? ??] 0354 00ea
;   98    if tad_value >= (ADC_MAX_TAD + ADC_MIN_TAD) / 2 then
                               movlw    38                  ;  2 OV rs rs [?? ??] 0355 3026
                                                            ; W = v___adc_byte_1
                               subwf    v_tad_value,w       ;  2 OV rs rs [?? ??] 0356 024e
                               btfsc    v__status, v__z     ;  2 OV rs rs [?? ??] 0357 1903
                               goto     l__l896             ;  2 OV rs rs [?? ??] 0358 2b5b
                               btfss    v__status, v__c     ;  2 OV rs rs [?? ??] 0359 1c03
                                                            ; W = v___adc_byte_1
                               goto     l__l611             ;  2 OV rs rs [?? ??] 035a 2b65
                                                            ; W = v___adc_byte_1
l__l896
;   99       _usec_delay(2 * ADC_MAX_TAD)
                               datalo_clr v__pic_temp       ;  2 -V rs rs [?? ??] 035b 1283
                               datahi_clr v__pic_temp       ;  2 -V rs rs [?? ??] 035c 1303
                               movlw    198                 ;  2 -V rs rs [?? ??] 035d 30c6
                               movwf    v__pic_temp         ;  2 -V rs rs [?? ??] 035e 00a0
                               branchhi_clr l__l897         ;  2 -V rs rs [?? h?] 035f 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l897         ;  2 -V rs rs [h? hl] 0360 118a
                                                            ; W = v__pic_temp
l__l897
                               decfsz   v__pic_temp,f       ;  2 -V rs rs [hl hl] 0361 0ba0
                               goto     l__l897             ;  2 -V rs rs [hl hl] 0362 2b61
                               nop                          ;  2 -V rs rs [hl hl] 0363 0000
;  100    else
                               goto     l__l610             ;  2 OV rs rs [hl hl] 0364 2b6f
l__l611
;  101       _usec_delay(2 * ADC_MIN_TAD)
                               datalo_clr v__pic_temp       ;  2 -V rs rs [?? ??] 0365 1283
                                                            ; W = v___adc_byte_1
                               datahi_clr v__pic_temp       ;  2 -V rs rs [?? ??] 0366 1303
                                                            ; W = v___adc_byte_1
                               movlw    51                  ;  2 -V rs rs [?? ??] 0367 3033
                                                            ; W = v___adc_byte_1
                               movwf    v__pic_temp         ;  2 -V rs rs [?? ??] 0368 00a0
                               branchhi_clr l__l898         ;  2 -V rs rs [?? h?] 0369 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l898         ;  2 -V rs rs [h? hl] 036a 118a
                                                            ; W = v__pic_temp
l__l898
                               decfsz   v__pic_temp,f       ;  2 -V rs rs [hl hl] 036b 0ba0
                               goto     l__l898             ;  2 -V rs rs [hl hl] 036c 2b6b
                               nop                          ;  2 -V rs rs [hl hl] 036d 0000
                               nop                          ;  2 -V rs rs [hl hl] 036e 0000
;  102    end if
l__l610
;  103    ADCON0_ADON = false               -- turn off ADC module
                               bcf      v_adcon0, 0 ; adcon0_adon      ;  2 OV rs rs [hl hl] 036f 101f
;  104 end procedure
                               movf     v___adc_byte_1,w    ;  2 OV rs rs [hl hl] 0370 086a
                               return                       ;  2 OV rs rs [hl hl] 0371 0008
                                                            ; W = v___adc_byte_1
;  110 function adc_read(byte in adc_chan) return word is
l_adc_read
                               datalo_clr v___adc_chan_3    ;  1 OV ?? ?s [?? ??] 0372 1283
                               movwf    v___adc_chan_3      ;  1 OV rs rs [?? ??] 0373 00e1
;  115       _adc_read_low_res(adc_chan,ax[1])   -- do conversion and get high byte  
                               movf     v___adc_chan_3,w    ;  1 OV rs rs [?? ??] 0374 0861
                                                            ; W = v___adc_chan_3
                               call     l__adc_read_low_res ;  1 OV rs ?? [?? ??] 0375 2341
                                                            ; W = v___adc_chan_3
                               datalo_clr v_ax+1            ;  1 OV ?? ?s [?? ??] 0376 1283
                               movwf    v_ax+1              ;  1 OV rs rs [?? ??] 0377 00e4
;  116       ax[0] = ADRESL                       -- get low byte
                               datalo_set v_adresl          ;  1 OV rs rS [?? ??] 0378 1683
                                                            ; W = v_ax
                               movf     v_adresl,w          ;  1 OV rS rS [?? ??] 0379 081e
                                                            ; W = v_ax
                               datalo_clr v_ax              ;  1 OV rS rs [?? ??] 037a 1283
                               movwf    v_ax                ;  1 OV rs rs [?? ??] 037b 00e3
;  125    return ad_value
                               movf     v_ad_value,w        ;  1 OV rs rs [?? ??] 037c 0863
                                                            ; W = v_ax
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 037d 00a0
                                                            ; W = v_ad_value
                               movf     v_ad_value+1,w      ;  1 OV rs rs [?? ??] 037e 0864
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 037f 00a1
                                                            ; W = v_ad_value
;  126 end function
                               return                       ;  1 OV rs rs [?? ??] 0380 0008
                                                            ; W = v__pic_temp
;  266    end if
l__l732
; okay_tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_channels.jal
;  982          var bit*4 no_vref = 0
                               movlw    225                 ;  0 OV rs rs [?? ??] 0381 30e1
                               andwf    v__bitbucket+1,f    ;  0 OV rs rs [?? ??] 0382 05dd
;  991             asm nop
                               nop                          ;  0 -V rs rs [?? ??] 0383 0000
; 2411          no_vref = ADC_PCFG_MAP[idx]
                               movlw    225                 ;  0 OV rs rs [?? ??] 0384 30e1
                               andwf    v__bitbucket+1,f    ;  0 OV rs rs [?? ??] 0385 05dd
; 2412          ADCON1_PCFG = no_vref
                               rrf      v__bitbucket+1,w    ;  0 OV rs rs [?? ??] 0386 0c5d
                               movwf    v__pic_temp+2       ;  0 OV rs rs [?? ??] 0387 00a2
                               rrf      v__bitbucket,w      ;  0 OV rs rs [?? ??] 0388 0c5c
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?? ??] 0389 00a1
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 038a 0821
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 038b 00a0
                                                            ; W = v__pic_temp
                               movlw    15                  ;  0 OV rs rs [?? ??] 038c 300f
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp,f       ;  0 OV rs rs [?? ??] 038d 05a0
                               movlw    15                  ;  0 OV rs rs [?? ??] 038e 300f
                               andwf    v__pic_temp,w       ;  0 OV rs rs [?? ??] 038f 0520
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?? ??] 0390 00a1
                               movlw    240                 ;  0 OV rs rs [?? ??] 0391 30f0
                                                            ; W = v__pic_temp
                               datalo_set v_adcon1          ;  0 OV rs rS [?? ??] 0392 1683
                               andwf    v_adcon1,w          ;  0 OV rS rS [?? ??] 0393 051f
                               datalo_clr v__pic_temp+1     ;  0 OV rS rs [?? ??] 0394 1283
                               iorwf    v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 0395 0421
                               datalo_set v_adcon1          ;  0 OV rs rS [?? ??] 0396 1683
                               movwf    v_adcon1            ;  0 OV rS rS [?? ??] 0397 009f
; okay_tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc.jal
;  253    _adc_setup_pins()    -- conditionally defined according to PIC
;  254    _adc_vref()          -- conditionally defined according to PIC
; okay_tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc.jal
;  267    _adc_setup()
                               bsf      v_adcon1, 7 ; adcon1_adfm      ;  0 OV rS rS [?? ??] 0398 179f
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  116    var volatile bit*3 adcs = 0b_000
                               movlw    241                 ;  0 OV rS rS [?? ??] 0399 30f1
                               datalo_clr v__bitbucket      ;  0 OV rS rs [?? ??] 039a 1283
                               andwf    v__bitbucket+1,f    ;  0 OV rs rs [?? ??] 039b 05dd
;  135 	  if _adc_eval_tad(32) == true then
                               movlw    32                  ;  0 OV rs rs [?? ??] 039c 3020
                               movwf    v___factor_1        ;  0 OV rs rs [?? ??] 039d 00e1
                               clrf     v___factor_1+1      ;  0 OV rs rs [?? ??] 039e 01e2
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [?? ??] 039f 230a
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+1 ; _btemp572 ;  0 OV ?? ?s [?? ??] 03a0 1283
                               bcf      v__bitbucket+1, 4 ; _btemp572;  0 OV rs rs [?? ??] 03a1 125d
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 03a2 1820
                               bsf      v__bitbucket+1, 4 ; _btemp572;  0 OV rs rs [?? ??] 03a3 165d
                               btfss    v__bitbucket+1, 4 ; _btemp572;  0 OV rs rs [?? ??] 03a4 1e5d
                               goto     l__l781             ;  0 OV rs rs [?? ??] 03a5 2bab
; okay_tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  136 		 adcs = 0b_010
                               movlw    241                 ;  0 OV rs rs [?? ??] 03a6 30f1
                                                            ; W = v__bitbucket
                               andwf    v__bitbucket+1,w    ;  0 OV rs rs [?? ??] 03a7 055d
                               iorlw    4                   ;  0 OV rs rs [?? ??] 03a8 3804
                               movwf    v__bitbucket+1      ;  0 OV rs rs [?? ??] 03a9 00dd
; okay_tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  137 	  elsif _adc_eval_tad(8) == true then
                               goto     l__l784             ;  0 OV rs rs [?? ??] 03aa 2bc6
                                                            ; W = v__bitbucket
l__l781
                               movlw    8                   ;  0 OV rs rs [?? ??] 03ab 3008
                               movwf    v___factor_1        ;  0 OV rs rs [?? ??] 03ac 00e1
                               clrf     v___factor_1+1      ;  0 OV rs rs [?? ??] 03ad 01e2
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [?? ??] 03ae 230a
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+1 ; _btemp592 ;  0 OV ?? ?s [?? ??] 03af 1283
                               bcf      v__bitbucket+1, 6 ; _btemp592;  0 OV rs rs [?? ??] 03b0 135d
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 03b1 1820
                               bsf      v__bitbucket+1, 6 ; _btemp592;  0 OV rs rs [?? ??] 03b2 175d
                               btfss    v__bitbucket+1, 6 ; _btemp592;  0 OV rs rs [?? ??] 03b3 1f5d
                               goto     l__l782             ;  0 OV rs rs [?? ??] 03b4 2bba
; okay_tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  138 		 adcs = 0b_001
                               movlw    241                 ;  0 OV rs rs [?? ??] 03b5 30f1
                               andwf    v__bitbucket+1,w    ;  0 OV rs rs [?? ??] 03b6 055d
                               iorlw    2                   ;  0 OV rs rs [?? ??] 03b7 3802
                               movwf    v__bitbucket+1      ;  0 OV rs rs [?? ??] 03b8 00dd
; okay_tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  139 	  elsif _adc_eval_tad(2) == true then
                               goto     l__l784             ;  0 OV rs rs [?? ??] 03b9 2bc6
                                                            ; W = v__bitbucket
l__l782
                               movlw    2                   ;  0 OV rs rs [?? ??] 03ba 3002
                               movwf    v___factor_1        ;  0 OV rs rs [?? ??] 03bb 00e1
                               clrf     v___factor_1+1      ;  0 OV rs rs [?? ??] 03bc 01e2
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [?? ??] 03bd 230a
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+2 ; _btemp612 ;  0 OV ?? ?s [?? ??] 03be 1283
                               bcf      v__bitbucket+2, 0 ; _btemp612;  0 OV rs rs [?? ??] 03bf 105e
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 03c0 1820
                               bsf      v__bitbucket+2, 0 ; _btemp612;  0 OV rs rs [?? ??] 03c1 145e
                               btfss    v__bitbucket+2, 0 ; _btemp612;  0 OV rs rs [?? ??] 03c2 1c5e
                               goto     l__l783             ;  0 OV rs rs [?? ??] 03c3 2bc6
; okay_tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  140 		 adcs = 0b_000
                               movlw    241                 ;  0 OV rs rs [?? ??] 03c4 30f1
                                                            ; W = v_prev_isr_counter
                               andwf    v__bitbucket+1,f    ;  0 OV rs rs [?? ??] 03c5 05dd
;  141 	  end if
l__l783
l__l784
;  154 	  jallib_adcs_lsb = adcs_lsb
                               rrf      v__bitbucket+1,w    ;  0 OV rs rs [?? ??] 03c6 0c5d
                               movwf    v__pic_temp+2       ;  0 OV rs rs [?? ??] 03c7 00a2
                               rrf      v__bitbucket,w      ;  0 OV rs rs [?? ??] 03c8 0c5c
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?? ??] 03c9 00a1
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 03ca 0821
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 03cb 00a0
                                                            ; W = v__pic_temp
                               movlw    3                   ;  0 OV rs rs [?? ??] 03cc 3003
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp,f       ;  0 OV rs rs [?? ??] 03cd 05a0
                               rrf      v__pic_temp,w       ;  0 OV rs rs [?? ??] 03ce 0c20
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?? ??] 03cf 00a1
                               rrf      v__pic_temp+1,f     ;  0 OV rs rs [?? ??] 03d0 0ca1
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 03d1 0c21
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?? ??] 03d2 00a1
                               movlw    192                 ;  0 OV rs rs [?? ??] 03d3 30c0
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp+1,f     ;  0 OV rs rs [?? ??] 03d4 05a1
                               movlw    63                  ;  0 OV rs rs [?? ??] 03d5 303f
                               andwf    v_adcon0,w          ;  0 OV rs rs [?? ??] 03d6 051f
                               iorwf    v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 03d7 0421
                               movwf    v_adcon0            ;  0 OV rs rs [?? ??] 03d8 009f
; okay_tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc.jal
;  270    _adc_init_clock()
; okay_tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc.jal
;  243    adc_conversion_delay = 2 + adc_tc + adc_tcoff   -- Tamp seems to be a constant: 2usecs
                               movlw    21                  ;  0 OV rs rs [?? ??] 03d9 3015
                                                            ; W = v_adcon0
                               movwf    v_adc_conversion_delay;  0 OV rs rs [?? ??] 03da 00cf
; okay_tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc.jal
;  271    _adc_init_acquisition_delay()
; okay_tank.jal
;   50 adc_init()
;   54 var byte PwmL        = 0 ; pwm setpoint
                               clrf     v_pwml              ;  0 OV rs rs [?? ??] 03db 01d0
                                                            ; W = v_adc_conversion_delay
;   55 var byte PwmR        = 0 ; pwm setpoint
                               clrf     v_pwmr              ;  0 OV rs rs [?? ??] 03dc 01d1
                                                            ; W = v_adc_conversion_delay
;   56 var bit MotorL_fwd   = true
                               bsf      v__bitbucket, 0 ; motorl_fwd  ;  0 OV rs rs [?? ??] 03dd 145c
                                                            ; W = v_adc_conversion_delay
;   57 var bit MotorR_fwd   = true
                               bsf      v__bitbucket, 1 ; motorr_fwd  ;  0 OV rs rs [?? ??] 03de 14dc
                                                            ; W = v_adc_conversion_delay
;   65 PORTD_low_direction = all_output
; c:\jallib\include\device/16f877.jal
;  851    TRISD = (TRISD & 0xF0) | (x & 0x0F)
                               movlw    240                 ;  0 OV rs rs [?? ??] 03df 30f0
                                                            ; W = v_adc_conversion_delay
                               datalo_set v_trisd           ;  0 OV rs rS [?? ??] 03e0 1683
                               andwf    v_trisd,w           ;  0 OV rS rS [?? ??] 03e1 0508
                               datalo_clr v____temp_71      ;  0 OV rS rs [?? ??] 03e2 1283
                               movwf    v____temp_71        ;  0 OV rs rs [?? ??] 03e3 00df
                               clrf     v____temp_71+1      ;  0 OV rs rs [?? ??] 03e4 01e0
                                                            ; W = v____temp_71
                               movf     v____temp_71+1,w    ;  0 OV rs rs [?? ??] 03e5 0860
                                                            ; W = v____temp_71
                               iorwf    v____temp_71,w      ;  0 OV rs rs [?? ??] 03e6 045f
                                                            ; W = v____temp_71
                               datalo_set v_trisd           ;  0 OV rs rS [?? ??] 03e7 1683
                               movwf    v_trisd             ;  0 OV rS rS [?? ??] 03e8 0088
; okay_tank.jal
;   65 PORTD_low_direction = all_output
;   73 forever loop       
l__l793
;   79    if (isr_counter != prev_isr_counter) then
                               call     l__isr_counter_get  ;  0 OV ?? ?? [?? ??] 03e9 225a
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 03ea 1283
                               movf     v__pic_temp,w       ;  0 OV rs rs [?? ??] 03eb 0820
                               movwf    v____temp_72        ;  0 OV rs rs [?? ??] 03ec 00da
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 03ed 0821
                                                            ; W = v____temp_72
                               movwf    v____temp_72+1      ;  0 OV rs rs [?? ??] 03ee 00db
                                                            ; W = v__pic_temp
                               movf     v____temp_72,w      ;  0 OV rs rs [?? ??] 03ef 085a
                                                            ; W = v____temp_72
                               subwf    v_prev_isr_counter,w;  0 OV rs rs [?? ??] 03f0 0252
                                                            ; W = v____temp_72
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 03f1 00a0
                               movf     v____temp_72+1,w    ;  0 OV rs rs [?? ??] 03f2 085b
                                                            ; W = v__pic_temp
                               subwf    v_prev_isr_counter+1,w;  0 OV rs rs [?? ??] 03f3 0253
                                                            ; W = v____temp_72
                               iorwf    v__pic_temp,w       ;  0 OV rs rs [?? ??] 03f4 0420
                               btfsc    v__status, v__z     ;  0 OV rs rs [?? ??] 03f5 1903
                               goto     l__l796             ;  0 OV rs rs [?? ??] 03f6 2bfd
;   80       prev_isr_counter = isr_counter
                               call     l__isr_counter_get  ;  0 OV rs ?? [?? ??] 03f7 225a
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 03f8 1283
                               movf     v__pic_temp,w       ;  0 OV rs rs [?? ??] 03f9 0820
                               movwf    v_prev_isr_counter  ;  0 OV rs rs [?? ??] 03fa 00d2
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 03fb 0821
                                                            ; W = v_prev_isr_counter
                               movwf    v_prev_isr_counter+1;  0 OV rs rs [?? ??] 03fc 00d3
                                                            ; W = v__pic_temp
;   86    end if ; 1 kHz loop   
l__l796
;   88    if (check_delay(0)) then
                               movlw    0                   ;  0 OV rs rs [?? ??] 03fd 3000
                               call     l_check_delay       ;  0 OV rs ?? [?? ??] 03fe 227d
                               datalo_clr v__bitbucket ; _btemp65   ;  0 OV ?? ?s [?? ??] 03ff 1283
                               bcf      v__bitbucket, 3 ; _btemp65  ;  0 OV rs rs [?? ??] 0400 11dc
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 0401 1820
                               bsf      v__bitbucket, 3 ; _btemp65  ;  0 OV rs rs [?? ??] 0402 15dc
                               btfss    v__bitbucket, 3 ; _btemp65  ;  0 OV rs rs [?? ??] 0403 1ddc
                               goto     l__l793             ;  0 OV rs rs [?? ??] 0404 2be9
;   89       set_delay(0, 100) --  20 ticks on delay-slot 0
                               movlw    100                 ;  0 OV rs rs [?? ??] 0405 3064
                               movwf    v___ticks_1         ;  0 OV rs rs [?? ??] 0406 00e3
                               clrf     v___ticks_1+1       ;  0 OV rs rs [?? ??] 0407 01e4
                                                            ; W = v___ticks_1
                               movlw    0                   ;  0 OV rs rs [?? ??] 0408 3000
                                                            ; W = v___ticks_1
                               call     l_set_delay         ;  0 OV rs ?? [?? ??] 0409 2266
;   95       LeftEye  = 30000 / adc_read(0)
                               movlw    0                   ;  0 OV ?? ?? [?? ??] 040a 3000
                               call     l_adc_read          ;  0 OV ?? ?? [?? ??] 040b 2372
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 040c 1283
                               movf     v__pic_temp,w       ;  0 OV rs rs [?? ??] 040d 0820
                               movwf    v____temp_72        ;  0 OV rs rs [?? ??] 040e 00da
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 040f 0821
                                                            ; W = v____temp_72
                               movwf    v____temp_72+1      ;  0 OV rs rs [?? ??] 0410 00db
                                                            ; W = v__pic_temp
                               movf     v____temp_72,w      ;  0 OV rs rs [?? ??] 0411 085a
                                                            ; W = v____temp_72
                               movwf    v__pic_divisor      ;  0 OV rs rs [?? ??] 0412 00a8
                                                            ; W = v____temp_72
                               movf     v____temp_72+1,w    ;  0 OV rs rs [?? ??] 0413 085b
                                                            ; W = v__pic_divisor
                               movwf    v__pic_divisor+1    ;  0 OV rs rs [?? ??] 0414 00a9
                                                            ; W = v____temp_72
                               clrf     v__pic_divisor+2    ;  0 OV rs rs [?? ??] 0415 01aa
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+3    ;  0 OV rs rs [?? ??] 0416 01ab
                                                            ; W = v__pic_divisor
                               movlw    48                  ;  0 OV rs rs [?? ??] 0417 3030
                                                            ; W = v__pic_divisor
                               movwf    v__pic_dividend     ;  0 OV rs rs [?? ??] 0418 00a0
                               movlw    117                 ;  0 OV rs rs [?? ??] 0419 3075
                                                            ; W = v__pic_dividend
                               movwf    v__pic_dividend+1   ;  0 OV rs rs [?? ??] 041a 00a1
                               clrf     v__pic_dividend+2   ;  0 OV rs rs [?? ??] 041b 01a2
                                                            ; W = v__pic_dividend
                               clrf     v__pic_dividend+3   ;  0 OV rs rs [?? ??] 041c 01a3
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  0 OV rs ?? [?? ??] 041d 2048
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  0 OV ?? ?s [?? ??] 041e 1283
                               movf     v__pic_quotient,w   ;  0 OV rs rs [?? ??] 041f 082c
                               movwf    v_lefteye           ;  0 OV rs rs [?? ??] 0420 00d4
                                                            ; W = v__pic_quotient
                               movf     v__pic_quotient+1,w ;  0 OV rs rs [?? ??] 0421 082d
                                                            ; W = v_lefteye
                               movwf    v_lefteye+1         ;  0 OV rs rs [?? ??] 0422 00d5
                                                            ; W = v__pic_quotient
;   96       RightEye = 30000 / adc_read(1)      
                               movlw    1                   ;  0 OV rs rs [?? ??] 0423 3001
                                                            ; W = v_lefteye
                               call     l_adc_read          ;  0 OV rs ?? [?? ??] 0424 2372
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 0425 1283
                               movf     v__pic_temp,w       ;  0 OV rs rs [?? ??] 0426 0820
                               movwf    v____temp_72        ;  0 OV rs rs [?? ??] 0427 00da
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 0428 0821
                                                            ; W = v____temp_72
                               movwf    v____temp_72+1      ;  0 OV rs rs [?? ??] 0429 00db
                                                            ; W = v__pic_temp
                               movf     v____temp_72,w      ;  0 OV rs rs [?? ??] 042a 085a
                                                            ; W = v____temp_72
                               movwf    v__pic_divisor      ;  0 OV rs rs [?? ??] 042b 00a8
                                                            ; W = v____temp_72
                               movf     v____temp_72+1,w    ;  0 OV rs rs [?? ??] 042c 085b
                                                            ; W = v__pic_divisor
                               movwf    v__pic_divisor+1    ;  0 OV rs rs [?? ??] 042d 00a9
                                                            ; W = v____temp_72
                               clrf     v__pic_divisor+2    ;  0 OV rs rs [?? ??] 042e 01aa
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+3    ;  0 OV rs rs [?? ??] 042f 01ab
                                                            ; W = v__pic_divisor
                               movlw    48                  ;  0 OV rs rs [?? ??] 0430 3030
                                                            ; W = v__pic_divisor
                               movwf    v__pic_dividend     ;  0 OV rs rs [?? ??] 0431 00a0
                               movlw    117                 ;  0 OV rs rs [?? ??] 0432 3075
                                                            ; W = v__pic_dividend
                               movwf    v__pic_dividend+1   ;  0 OV rs rs [?? ??] 0433 00a1
                               clrf     v__pic_dividend+2   ;  0 OV rs rs [?? ??] 0434 01a2
                                                            ; W = v__pic_dividend
                               clrf     v__pic_dividend+3   ;  0 OV rs rs [?? ??] 0435 01a3
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  0 OV rs ?? [?? ??] 0436 2048
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  0 OV ?? ?s [?? ??] 0437 1283
                               movf     v__pic_quotient,w   ;  0 OV rs rs [?? ??] 0438 082c
                               movwf    v_righteye          ;  0 OV rs rs [?? ??] 0439 00d6
                                                            ; W = v__pic_quotient
                               movf     v__pic_quotient+1,w ;  0 OV rs rs [?? ??] 043a 082d
                                                            ; W = v_righteye
                               movwf    v_righteye+1        ;  0 OV rs rs [?? ??] 043b 00d7
                                                            ; W = v__pic_quotient
;   99       if (RightEye > 200) then
                               movlw    0                   ;  0 OV rs rs [?? ??] 043c 3000
                                                            ; W = v_righteye
                               subwf    v_righteye+1,w      ;  0 OV rs rs [?? ??] 043d 0257
                               btfss    v__status, v__z     ;  0 OV rs rs [?? ??] 043e 1d03
                               goto     l__l899             ;  0 OV rs rs [?? ??] 043f 2c42
                               movlw    200                 ;  0 OV rs rs [?? ??] 0440 30c8
                               subwf    v_righteye,w        ;  0 OV rs rs [?? ??] 0441 0256
l__l899
                               btfsc    v__status, v__z     ;  0 OV rs rs [?? ??] 0442 1903
                               goto     l__l800             ;  0 OV rs rs [?? ??] 0443 2c62
                               btfss    v__status, v__c     ;  0 OV rs rs [?? ??] 0444 1c03
                               goto     l__l800             ;  0 OV rs rs [?? ??] 0445 2c62
;  101          temp = LeftEye
                               movf     v_lefteye,w         ;  0 OV rs rs [?? ??] 0446 0854
                               movwf    v___temp_1          ;  0 OV rs rs [?? ??] 0447 00d8
                                                            ; W = v_lefteye
                               movf     v_lefteye+1,w       ;  0 OV rs rs [?? ??] 0448 0855
                                                            ; W = v___temp_1
                               movwf    v___temp_1+1        ;  0 OV rs rs [?? ??] 0449 00d9
                                                            ; W = v_lefteye
;  102          if (temp > 255) then temp = 255 end if
                               movlw    0                   ;  0 OV rs rs [?? ??] 044a 3000
                                                            ; W = v___temp_1
                               subwf    v___temp_1+1,w      ;  0 OV rs rs [?? ??] 044b 0259
                               btfss    v__status, v__z     ;  0 OV rs rs [?? ??] 044c 1d03
                               goto     l__l901             ;  0 OV rs rs [?? ??] 044d 2c50
                               movlw    255                 ;  0 OV rs rs [?? ??] 044e 30ff
                                                            ; W = v___temp_1
                               subwf    v___temp_1,w        ;  0 OV rs rs [?? ??] 044f 0258
l__l901
                               btfsc    v__status, v__z     ;  0 OV rs rs [?? ??] 0450 1903
                               goto     l__l802             ;  0 OV rs rs [?? ??] 0451 2c57
                               btfss    v__status, v__c     ;  0 OV rs rs [?? ??] 0452 1c03
                               goto     l__l802             ;  0 OV rs rs [?? ??] 0453 2c57
                               movlw    255                 ;  0 OV rs rs [?? ??] 0454 30ff
                               movwf    v___temp_1          ;  0 OV rs rs [?? ??] 0455 00d8
                               clrf     v___temp_1+1        ;  0 OV rs rs [?? ??] 0456 01d9
                                                            ; W = v___temp_1
l__l802
;  104          if (temp > 127) then 
                               movlw    0                   ;  0 OV rs rs [?? ??] 0457 3000
                               subwf    v___temp_1+1,w      ;  0 OV rs rs [?? ??] 0458 0259
                               btfss    v__status, v__z     ;  0 OV rs rs [?? ??] 0459 1d03
                               goto     l__l903             ;  0 OV rs rs [?? ??] 045a 2c5d
                               movlw    127                 ;  0 OV rs rs [?? ??] 045b 307f
                               subwf    v___temp_1,w        ;  0 OV rs rs [?? ??] 045c 0258
l__l903
                               btfsc    v__status, v__z     ;  0 OV rs rs [?? ??] 045d 1903
                               goto     l__l799             ;  0 OV rs rs [?? ??] 045e 2c64
                               btfss    v__status, v__c     ;  0 OV rs rs [?? ??] 045f 1c03
                               goto     l__l799             ;  0 OV rs rs [?? ??] 0460 2c64
;  111       else  
                               goto     l__l799             ;  0 OV rs rs [?? ??] 0461 2c64
l__l800
;  112          PwmL = 0
                               clrf     v_pwml              ;  0 OV rs rs [?? ??] 0462 01d0
;  113          PwmR = 0
                               clrf     v_pwmr              ;  0 OV rs rs [?? ??] 0463 01d1
;  114       end if
l__l799
;  118 		MotorH1 = MotorL_fwd
                               bcf      v__portd_shadow, 1 ; x116;  0 OV rs rs [?? ??] 0464 10c2
                               btfsc    v__bitbucket, 0 ; motorl_fwd  ;  0 OV rs rs [?? ??] 0465 185c
                               bsf      v__portd_shadow, 1 ; x116;  0 OV rs rs [?? ??] 0466 14c2
; c:\jallib\include\device/16f877.jal
;  408    PORTD = _PORTD_shadow
                               movf     v__portd_shadow,w   ;  0 OV rs rs [?? ??] 0467 0842
                               movwf    v_portd             ;  0 OV rs rs [?? ??] 0468 0088
                                                            ; W = v__portd_shadow
; okay_tank.jal
;  118 		MotorH1 = MotorL_fwd
; c:\jallib\include\device/16f877.jal
;  496    _PORTD_flush()
; okay_tank.jal
;  118 		MotorH1 = MotorL_fwd
;  119 		MotorH2 = !MotorH1
                               btfss    v_portd, 1 ; pin_d1       ;  0 OV rs rs [?? ??] 0469 1c88
                               goto     l__l906             ;  0 OV rs rs [?? ??] 046a 2c6d
                               bcf      v__bitbucket, 7 ; _btemp69  ;  0 OV rs rs [?? ??] 046b 13dc
                               goto     l__l905             ;  0 OV rs rs [?? ??] 046c 2c6e
l__l906
                               bsf      v__bitbucket, 7 ; _btemp69  ;  0 OV rs rs [?? ??] 046d 17dc
l__l905
                               bcf      v__portd_shadow, 0 ; x117;  0 OV rs rs [?? ??] 046e 1042
                               btfsc    v__bitbucket, 7 ; _btemp69  ;  0 OV rs rs [?? ??] 046f 1bdc
                               bsf      v__portd_shadow, 0 ; x117;  0 OV rs rs [?? ??] 0470 1442
; c:\jallib\include\device/16f877.jal
;  408    PORTD = _PORTD_shadow
                               movf     v__portd_shadow,w   ;  0 OV rs rs [?? ??] 0471 0842
                               movwf    v_portd             ;  0 OV rs rs [?? ??] 0472 0088
                                                            ; W = v__portd_shadow
; okay_tank.jal
;  119 		MotorH2 = !MotorH1
; c:\jallib\include\device/16f877.jal
;  505    _PORTD_flush()
; okay_tank.jal
;  119 		MotorH2 = !MotorH1
;  120       pwm1_set_dutycycle(PwmL)	
                               movf     v_pwml,w            ;  0 OV rs rs [?? ??] 0473 0850
                               call     l_pwm1_set_dutycycle;  0 OV rs ?? [?? ??] 0474 2202
                                                            ; W = v_pwml
;  122 		MotorH3 = MotorR_fwd
                               datalo_clr v__portd_shadow ; x118;  0 OV ?? ?s [?? ??] 0475 1283
                               bcf      v__portd_shadow, 2 ; x118;  0 OV rs rs [?? ??] 0476 1142
                               btfsc    v__bitbucket, 1 ; motorr_fwd  ;  0 OV rs rs [?? ??] 0477 18dc
                               bsf      v__portd_shadow, 2 ; x118;  0 OV rs rs [?? ??] 0478 1542
; c:\jallib\include\device/16f877.jal
;  408    PORTD = _PORTD_shadow
                               movf     v__portd_shadow,w   ;  0 OV rs rs [?? ??] 0479 0842
                               movwf    v_portd             ;  0 OV rs rs [?? ??] 047a 0088
                                                            ; W = v__portd_shadow
; okay_tank.jal
;  122 		MotorH3 = MotorR_fwd
; c:\jallib\include\device/16f877.jal
;  487    _PORTD_flush()
; okay_tank.jal
;  122 		MotorH3 = MotorR_fwd
;  123 		MotorH4 = !MotorH3
                               btfss    v_portd, 2 ; pin_d2       ;  0 OV rs rs [?? ??] 047b 1d08
                               goto     l__l908             ;  0 OV rs rs [?? ??] 047c 2c7f
                               bcf      v__bitbucket+1, 0 ; _btemp70;  0 OV rs rs [?? ??] 047d 105d
                               goto     l__l907             ;  0 OV rs rs [?? ??] 047e 2c80
l__l908
                               bsf      v__bitbucket+1, 0 ; _btemp70;  0 OV rs rs [?? ??] 047f 145d
l__l907
                               bcf      v__portd_shadow, 3 ; x119;  0 OV rs rs [?? ??] 0480 11c2
                               btfsc    v__bitbucket+1, 0 ; _btemp70;  0 OV rs rs [?? ??] 0481 185d
                               bsf      v__portd_shadow, 3 ; x119;  0 OV rs rs [?? ??] 0482 15c2
; c:\jallib\include\device/16f877.jal
;  408    PORTD = _PORTD_shadow
                               movf     v__portd_shadow,w   ;  0 OV rs rs [?? ??] 0483 0842
                               movwf    v_portd             ;  0 OV rs rs [?? ??] 0484 0088
                                                            ; W = v__portd_shadow
; okay_tank.jal
;  123 		MotorH4 = !MotorH3
; c:\jallib\include\device/16f877.jal
;  478    _PORTD_flush()
; okay_tank.jal
;  123 		MotorH4 = !MotorH3
;  124    	pwm2_set_dutycycle(PwmR)			
                               movf     v_pwmr,w            ;  0 OV rs rs [?? ??] 0485 0851
                               call     l_pwm2_set_dutycycle;  0 OV rs ?? [?? ??] 0486 2244
                                                            ; W = v_pwmr
;  133       print_word_dec(serial_hw_data, LeftEye)      
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0487 309d
                               datalo_clr v____device_put_18;  0 OV ?? ?s [?? ??] 0488 1283
                               movwf    v____device_put_18  ;  0 OV rs rs [?? ??] 0489 00e1
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 048a 3001
                                                            ; W = v____device_put_18
                               movwf    v____device_put_18+1;  0 OV rs rs [?? ??] 048b 00e2
                               movf     v_lefteye,w         ;  0 OV rs rs [?? ??] 048c 0854
                                                            ; W = v____device_put_18
                               movwf    v___data_36         ;  0 OV rs rs [?? ??] 048d 00e7
                                                            ; W = v_lefteye
                               movf     v_lefteye+1,w       ;  0 OV rs rs [?? ??] 048e 0855
                                                            ; W = v___data_36
                               movwf    v___data_36+1       ;  0 OV rs rs [?? ??] 048f 00e8
                                                            ; W = v_lefteye
                               call     l_print_word_dec    ;  0 OV rs ?? [?? ??] 0490 20d0
                                                            ; W = v___data_36
;  134       serial_hw_data = " "
                               movlw    32                  ;  0 OV ?? ?? [?? ??] 0491 3020
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 0492 1283
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 0493 00a0
                               call     l__serial_hw_data_put;  0 OV rs ?? [?? ??] 0494 219d
                                                            ; W = v__pic_temp
;  135       print_word_dec(serial_hw_data, RightEye)      
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0495 309d
                               datalo_clr v____device_put_18;  0 OV ?? ?s [?? ??] 0496 1283
                               movwf    v____device_put_18  ;  0 OV rs rs [?? ??] 0497 00e1
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0498 3001
                                                            ; W = v____device_put_18
                               movwf    v____device_put_18+1;  0 OV rs rs [?? ??] 0499 00e2
                               movf     v_righteye,w        ;  0 OV rs rs [?? ??] 049a 0856
                                                            ; W = v____device_put_18
                               movwf    v___data_36         ;  0 OV rs rs [?? ??] 049b 00e7
                                                            ; W = v_righteye
                               movf     v_righteye+1,w      ;  0 OV rs rs [?? ??] 049c 0857
                                                            ; W = v___data_36
                               movwf    v___data_36+1       ;  0 OV rs rs [?? ??] 049d 00e8
                                                            ; W = v_righteye
                               call     l_print_word_dec    ;  0 OV rs ?? [?? ??] 049e 20d0
                                                            ; W = v___data_36
;  136       serial_hw_data = 13
                               movlw    13                  ;  0 OV ?? ?? [?? ??] 049f 300d
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 04a0 1283
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 04a1 00a0
                               call     l__serial_hw_data_put;  0 OV rs ?? [?? ??] 04a2 219d
                                                            ; W = v__pic_temp
;  137       serial_hw_data = 10
                               movlw    10                  ;  0 OV ?? ?? [?? ??] 04a3 300a
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 04a4 1283
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 04a5 00a0
                               call     l__serial_hw_data_put;  0 OV rs ?? [?? ??] 04a6 219d
                                                            ; W = v__pic_temp
;  140 end loop -- fastest & forever loop
                               goto     l__l793             ;  0 OV ?? ?? [?? ??] 04a7 2be9
                               end
; --- procedures & call stack
;{root} ----- -U- (frame_sz=31 blocks=26)
;   {block enter}
;     --- records ---
;     --- variables ---
;     460d98:_jal_version  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 2004
;     460e88:_jal_build  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 20100313
;     461588:_device_id word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 2464
;     461be8:_pictype  (type=a dflags=C---- sz=6 use=0 assigned=0)
;      = 49,54,70,56,55,55
;     461a98:_datasheet  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 51,48,50,57,50
;     462108:_pgmspec  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 51,57,48,50,53
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
;     462e28:_true bit (type=B dflags=C--B- sz=1 use=13 assigned=0 bit=0)
;      = 1
;     462f98:_false bit (type=B dflags=C--B- sz=1 use=7 assigned=0 bit=0)
;      = 0
;     461488:_high bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     463108:_low bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     463238:_on bit (type=B dflags=C--B- sz=1 use=5 assigned=0 bit=0)
;      = 1
;     463368:_off bit (type=B dflags=C--B- sz=1 use=4 assigned=0 bit=0)
;      = 0
;     463498:_enabled bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
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
;      = 1313184
;     482618:_target_chip_name  (type=a dflags=C---- sz=6 use=0 assigned=0)
;      = 49,54,102,56,55,55
;     482408:_target_bank_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 128
;     482348:_target_page_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2048
;     482288:__stack_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8
;     4821c8:__code_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8192
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
;     483a88:__fuses_ct word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 1
;     483bf8:__fuse_base word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 8199
;     483d68:__fuses word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 16250
;     483988:_indf byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0000)
;     484108:__ind byte (type=i dflags=-V--- sz=1 use=9 assigned=7 base=0000)
;     4843b8:_tmr0 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0001)
;     484588:_pcl byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0002)
;     484838:__pcl byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0002)
;     484ae8:_status byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0003)
;     484d98:_status_irp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> status+0
;     484ee8:_status_rp  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=5) ---> status+0
;     485108:_status_nto bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> status+0
;     485268:_status_npd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> status+0
;     4853c8:_status_z bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> status+0
;     485528:_status_dc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> status+0
;     485688:_status_c bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> status+0
;     4857e8:__status byte (type=i dflags=-V--- sz=1 use=70 assigned=21 base=0003)
;     485b98:__irp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 7
;     485d08:__rp1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     485e78:__rp0 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     486108:__not_to byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     486278:__not_pd byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     4863e8:__z byte (type=i dflags=C---- sz=1 use=102 assigned=0)
;      = 2
;     486558:__dc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     4866c8:__c byte (type=i dflags=C---- sz=1 use=74 assigned=0)
;      = 0
;     485a98:_fsr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0004)
;     4869e8:__fsr byte (type=i dflags=-V--- sz=1 use=9 assigned=16 base=0004)
;     486c98:_porta byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0005)
;     486e28:__porta_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     487598:__porta_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     488158:__porta_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4883e8:__porta_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     487dc8:__porta_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48ba68:__porta_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48b798:__porta_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48e2f8:_porta_ra5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e488:_pin_a5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e608:_pin_an4 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48e6e8:_pin_ss bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     48eb28:__pin_a5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48e7d8:_porta_ra4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48f6a8:_pin_a4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48f828:_pin_t0cki bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     48fc68:__pin_a4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48f918:_porta_ra3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     490468:_pin_a3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     4905e8:_pin_an3 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     4906c8:_pin_vref_pos bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     490b08:__pin_a3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4907b8:_porta_ra2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     4916a8:_pin_a2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491828:_pin_an2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491908:_pin_vref bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     491d48:__pin_a2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4919f8:_porta_ra1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     4927f8:_pin_a1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492978:_pin_an1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     492db8:__pin_a1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     492a68:_porta_ra0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     4937f8:_pin_a0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     493978:_pin_an0 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     493db8:__pin_a0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     493a68:_portb byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0006)
;     494898:__portb_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     494e58:__portb_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     495968:__portb_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4969b8:__portb_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     495698:__portb_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4994c8:__portb_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4991f8:__portb_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49bc08:_portb_rb7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49bd98:_pin_b7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49bf18:_pin_pgd bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49c458:__pin_b7_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49c108:_portb_rb6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     49cec8:_pin_b6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     49c998:_pin_pgc bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     49d458:__pin_b6_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49d108:_portb_rb5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     49dec8:_pin_b5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     49e258:__pin_b5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49d998:_portb_rb4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     49ecc8:_pin_b4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     49f1b8:__pin_b4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49ee58:_portb_rb3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     49fc28:_pin_b3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     49fda8:_pin_pgm bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     495f08:__pin_b3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49fe98:_portb_rb2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portb+0
;     4a0ae8:_pin_b2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portb+0
;     4a05b8:__pin_b2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a0c78:_portb_rb1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     4a1ae8:_pin_b1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     4a15b8:__pin_b1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a1c78:_portb_rb0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a2ae8:_pin_b0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a2c68:_pin_int bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a3108:__pin_b0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a2d58:_portc byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0007)
;     4a3ba8:__portc_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
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
;     4b2b48:_portd byte (type=i dflags=-V--- sz=1 use=3 assigned=4 base=0008)
;     4b39b8:__portd_shadow byte (type=i dflags=----- auto sz=1 use=4 assigned=9 base=0042)
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
;     4bfa88:_pin_d2 bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=2) ---> portd+0
;     498fa8:_pin_psp2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portd+0
;     4b8f58:__pin_d2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b4fa8:_portd_rd1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portd+0
;     4c0ae8:_pin_d1 bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=1) ---> portd+0
;     4c0c68:_pin_psp1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portd+0
;     4c1108:__pin_d1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c0d58:_portd_rd0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portd+0
;     4c1b78:_pin_d0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portd+0
;     4c1cf8:_pin_psp0 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portd+0
;     4c21b8:__pin_d0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c1de8:_porte byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0009)
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
;     4cd9d8:__pclath byte (type=i dflags=-V--- sz=1 use=1 assigned=3 base=000a)
;     4cdc88:_intcon byte (type=i dflags=-V--- sz=1 use=1 assigned=9 base=000b)
;     4cdf38:_intcon_gie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=7) ---> intcon+0
;     4cdf98:_intcon_peie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=6) ---> intcon+0
;     4ce108:_intcon_tmr0ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=5 bit=5) ---> intcon+0
;     4ce268:_intcon_inte bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> intcon+0
;     4ce3c8:_intcon_rbie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> intcon+0
;     4ce528:_intcon_tmr0if bit (type=B dflags=-V-B- sz=1 use=1 assigned=2 bit=2) ---> intcon+0
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
;     4cf7e8:_pir2_eeif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pir2+0
;     4cf948:_pir2_bclif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pir2+0
;     4cfaa8:_pir2_ccp2if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pir2+0
;     4cfc08:_tmr1 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=000e)
;     4cfd68:_tmr1l byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000e)
;     4cfec8:_tmr1h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000f)
;     4c5dd8:_t1con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0010)
;     4c7f58:_t1con_t1ckps  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> t1con+0
;     4d0108:_t1con_t1oscen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> t1con+0
;     4d0268:_t1con_nt1sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> t1con+0
;     4d03c8:_t1con_tmr1cs bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> t1con+0
;     4d0528:_t1con_tmr1on bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> t1con+0
;     4d0688:_tmr2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0011)
;     4d07e8:_t2con byte (type=i dflags=-V--- sz=1 use=0 assigned=4 base=0012)
;     4d0938:_t2con_toutps  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=3) ---> t2con+0
;     4d0b28:_t2con_tmr2on bit (type=B dflags=-V-B- sz=1 use=0 assigned=4 bit=2) ---> t2con+0
;     4d0c78:_t2con_t2ckps  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=0) ---> t2con+0
;     4d0e68:_sspbuf byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0013)
;     4d1108:_sspcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0014)
;     4d1268:_sspcon_wcol bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspcon+0
;     4d13c8:_sspcon_sspov bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspcon+0
;     4d1528:_sspcon_sspen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspcon+0
;     4d1688:_sspcon_ckp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspcon+0
;     4d17d8:_sspcon_sspm  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> sspcon+0
;     4d19c8:_ccpr1 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=0015)
;     4d1b28:_ccpr1l byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0015)
;     4d1c88:_ccpr1h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0016)
;     4d1de8:_ccp1con byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0017)
;     4d1f38:_ccp1con_dc1b  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> ccp1con+0
;     4d2108:_ccp1con_ccp1m  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> ccp1con+0
;     4d22f8:_rcsta byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0018)
;     4d2458:_rcsta_spen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> rcsta+0
;     4d25b8:_rcsta_rx9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> rcsta+0
;     4d2718:_rcsta_sren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> rcsta+0
;     4d2878:_rcsta_cren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> rcsta+0
;     4d29d8:_rcsta_adden bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> rcsta+0
;     4d2b38:_rcsta_ferr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> rcsta+0
;     4d2c98:_rcsta_oerr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> rcsta+0
;     4d2df8:_rcsta_rx9d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> rcsta+0
;     4d2f58:_txreg byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0019)
;     4d3108:_rcreg byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001a)
;     4d3268:_ccpr2 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=001b)
;     4d33c8:_ccpr2l byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=001b)
;     4d3528:_ccpr2h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001c)
;     4d3688:_ccp2con byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=001d)
;     4d37d8:_ccp2con_dc2b  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> ccp2con+0
;     4d39b8:_ccp2con_ccp2m  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> ccp2con+0
;     4d3ba8:_adresh byte (type=i dflags=-V--- sz=1 use=1 assigned=0 base=001e)
;     4d3d08:_adcon0 byte (type=i dflags=-V--- sz=1 use=1 assigned=3 base=001f)
;     4d3e58:_adcon0_adcs  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;     4d4108:_adcon0_chs  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=3) ---> adcon0+0
;     4d42f8:_adcon0_go bit (type=B dflags=-V-B- sz=1 use=1 assigned=1 bit=2) ---> adcon0+0
;     4d4458:_adcon0_ndone bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> adcon0+0
;     4d45b8:_adcon0_adon bit (type=B dflags=-V-B- sz=1 use=0 assigned=2 bit=0) ---> adcon0+0
;     4d4718:_option_reg byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0081)
;     4d48f8:_option_reg_nrbpu bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> option_reg+0
;     4d4a78:_option_reg_intedg bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> option_reg+0
;     4d4be8:_option_reg_t0cs bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> option_reg+0
;     4d4d88:_t0con_t0cs bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> option_reg+0
;     4d4e48:_option_reg_t0se bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> option_reg+0
;     4d5108:_t0con_t0se bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> option_reg+0
;     4d51c8:_option_reg_psa bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=3) ---> option_reg+0
;     4d5368:_t0con_psa bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> option_reg+0
;     4d5418:_option_reg_ps  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=0) ---> option_reg+0
;     4d5648:_t0con_t0ps  (type=i dflags=-V-B- alias sz=3 use=0 assigned=0 bit=0) ---> option_reg+0
;     4d5708:_trisa byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0085)
;     4d5898:_porta_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisa+0
;     4d5c88:__porta_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d59a8:__porta_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d8698:__porta_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d83b8:__porta_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4daa28:_trisa_trisa5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4dabc8:_pin_a5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4dad98:_pin_an4_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4daeb8:_pin_ss_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4daf78:_trisa_trisa4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4dae28:_pin_a4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4db1f8:_pin_t0cki_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4db2b8:_trisa_trisa3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4db428:_pin_a3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4db5f8:_pin_an3_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4db718:_pin_vref_pos_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4db7d8:_trisa_trisa2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4db948:_pin_a2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4dbb18:_pin_an2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4dbc38:_pin_vref_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4dbcf8:_trisa_trisa1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4dbe68:_pin_a1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4db568:_pin_an1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4dba88:_trisa_trisa0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4dbba8:_pin_a0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4dc108:_pin_an0_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4dc1c8:_trisb byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0086)
;     4dc3c8:_portb_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisb+0
;     4dc7b8:__portb_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4dc4d8:__portb_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4df1b8:__portb_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4dedd8:__portb_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e1458:_trisb_trisb7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4e15f8:_pin_b7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4e17c8:_pin_pgd_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4e1888:_trisb_trisb6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4e19f8:_pin_b6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4e1bc8:_pin_pgc_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4e1c88:_trisb_trisb5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4e1df8:_pin_b5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4e1f68:_trisb_trisb4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4e1b38:_pin_b4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4e2108:_trisb_trisb3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4e2278:_pin_b3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4e2448:_pin_pgm_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4e2508:_trisb_trisb2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisb+0
;     4e2678:_pin_b2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisb+0
;     4e27e8:_trisb_trisb1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisb+0
;     4e2958:_pin_b1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisb+0
;     4e2ac8:_trisb_trisb0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4e2c38:_pin_b0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4e2e08:_pin_int_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4e2ec8:_trisc byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0087)
;     4e23b8:_portc_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisc+0
;     4e31f8:__portc_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e2d78:__portc_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e5b98:__portc_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e58b8:__portc_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e7f08:_trisc_trisc7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4e8128:_pin_c7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4e82f8:_pin_rx_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4e8418:_pin_dt_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4e84d8:_trisc_trisc6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4e8648:_pin_c6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4e8818:_pin_tx_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4e8938:_pin_ck_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4e89f8:_trisc_trisc5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4e8b68:_pin_c5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4e8d38:_pin_sdo_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4e8df8:_trisc_trisc4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4e8f68:_pin_c4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4e8788:_pin_sdi_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4e8ca8:_pin_sda_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4e8388:_trisc_trisc3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4e9108:_pin_c3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4e92d8:_pin_sck_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4e93f8:_pin_scl_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4e94b8:_trisc_trisc2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4e9628:_pin_c2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> trisc+0
;     4e97f8:_pin_ccp1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4e98b8:_trisc_trisc1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4e9a28:_pin_c1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=1) ---> trisc+0
;     4e9bf8:_pin_t1osi_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4e9d18:_pin_ccp2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4e9dd8:_trisc_trisc0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4e9f48:_pin_c0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4e9768:_pin_t1oso_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4e9b68:_pin_t1cki_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4e9368:_trisd byte (type=i dflags=-V--- sz=1 use=1 assigned=1 base=0088)
;     4ea108:_portd_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisd+0
;     4ea4f8:__portd_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ea218:__portd_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ecd58:__portd_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4eca78:__portd_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ef218:_trisd_trisd7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisd+0
;     4ef3b8:_pin_d7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisd+0
;     4ef588:_pin_psp7_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisd+0
;     4ef648:_trisd_trisd6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisd+0
;     4ef7b8:_pin_d6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisd+0
;     4ef988:_pin_psp6_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisd+0
;     4efa48:_trisd_trisd5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisd+0
;     4efbb8:_pin_d5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisd+0
;     4efd88:_pin_psp5_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisd+0
;     4efe48:_trisd_trisd4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisd+0
;     4ef4f8:_pin_d4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisd+0
;     4efcf8:_pin_psp4_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisd+0
;     4dcfa8:_trisd_trisd3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisd+0
;     4e3f18:_pin_d3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisd+0
;     4f0108:_pin_psp3_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisd+0
;     4f01c8:_trisd_trisd2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisd+0
;     4f0338:_pin_d2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisd+0
;     4f0508:_pin_psp2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisd+0
;     4f05c8:_trisd_trisd1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisd+0
;     4f0738:_pin_d1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisd+0
;     4f0908:_pin_psp1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisd+0
;     4f09c8:_trisd_trisd0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisd+0
;     4f0b38:_pin_d0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisd+0
;     4f0d08:_pin_psp0_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisd+0
;     4f0dc8:_trise byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0089)
;     4f0f58:_porte_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trise+0
;     4f11b8:__porte_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4f0478:__porte_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4f3aa8:__porte_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4f37c8:__porte_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4f5de8:_trise_ibf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trise+0
;     4f5f78:_trise_obf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trise+0
;     4f6128:_trise_ibov bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trise+0
;     4f6288:_trise_pspmode bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trise+0
;     4f63e8:_trise_trise2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trise+0
;     4f6558:_pin_e2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trise+0
;     4f6728:_pin_cs_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trise+0
;     4f6848:_pin_an7_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trise+0
;     4f6908:_trise_trise1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trise+0
;     4f6a78:_pin_e1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trise+0
;     4f6c48:_pin_wr_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trise+0
;     4f6d68:_pin_an6_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trise+0
;     4f6e28:_trise_trise0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trise+0
;     4f6f98:_pin_e0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trise+0
;     4f67b8:_pin_rd_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trise+0
;     4f6bb8:_pin_an5_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trise+0
;     4f7108:_pie1 byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=008c)
;     4f7268:_pie1_pspie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> pie1+0
;     4f73c8:_pie1_adie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pie1+0
;     4f7528:_pie1_rcie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> pie1+0
;     4f7688:_pie1_txie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=4) ---> pie1+0
;     4f77e8:_pie1_sspie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pie1+0
;     4f7948:_pie1_ccp1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pie1+0
;     4f7aa8:_pie1_tmr2ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pie1+0
;     4f7c08:_pie1_tmr1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pie1+0
;     4f7d68:_pie2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008d)
;     4f7ec8:_pie2_eeie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pie2+0
;     4f8108:_pie2_bclie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pie2+0
;     4f8268:_pie2_ccp2ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pie2+0
;     4f83c8:_pcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008e)
;     4f8528:_pcon_npor bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pcon+0
;     4f8688:_pcon_nbor bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pcon+0
;     4f87e8:_sspcon2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0091)
;     4f8948:_sspcon2_gcen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspcon2+0
;     4f8aa8:_sspcon2_ackstat bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspcon2+0
;     4f8c08:_sspcon2_ackdt bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspcon2+0
;     4f8d68:_sspcon2_acken bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspcon2+0
;     4f8ec8:_sspcon2_rcen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> sspcon2+0
;     4f9108:_sspcon2_pen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspcon2+0
;     4f9268:_sspcon2_rsen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> sspcon2+0
;     4f93c8:_sspcon2_sen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> sspcon2+0
;     4f9528:_pr2 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0092)
;     4f9688:_sspadd byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0093)
;     4f97e8:_sspstat byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0094)
;     4f9948:_sspstat_smp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspstat+0
;     4f9aa8:_sspstat_cke bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspstat+0
;     4f9c08:_sspstat_d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspstat+0
;     4f9d68:_sspstat_na bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspstat+0
;     4f9ec8:_sspstat_p bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspstat+0
;     4fa108:_sspstat_s bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> sspstat+0
;     4fa268:_sspstat_r bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspstat+0
;     4fa3c8:_sspstat_nw bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspstat+0
;     4fa528:_sspstat_ua bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> sspstat+0
;     4fa688:_sspstat_bf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> sspstat+0
;     4fa7e8:_txsta byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0098)
;     4fa948:_txsta_csrc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> txsta+0
;     4faaa8:_txsta_tx9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> txsta+0
;     4fac08:_txsta_txen bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> txsta+0
;     4fad68:_txsta_sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> txsta+0
;     4faec8:_txsta_brgh bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> txsta+0
;     4fb108:_txsta_trmt bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> txsta+0
;     4fb268:_txsta_tx9d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> txsta+0
;     4fb3c8:_spbrg byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0099)
;     4fb528:_adresl byte (type=i dflags=-V--- sz=1 use=1 assigned=0 base=009e)
;     4fb688:_adcon1 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=009f)
;     4fb7e8:_adcon1_adfm bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=7) ---> adcon1+0
;     4fb938:_adcon1_pcfg  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> adcon1+0
;     4fbb28:_eedata byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010c)
;     4fbc88:_eeadr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010d)
;     4fbde8:_eedath byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010e)
;     4fbf38:_eedath_eedath  (type=i dflags=-V-B- sz=6 use=0 assigned=0 bit=0) ---> eedath+0
;     4fc108:_eeadrh byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010f)
;     4fc258:_eeadrh_eeadrh  (type=i dflags=-V-B- sz=5 use=0 assigned=0 bit=0) ---> eeadrh+0
;     4fc448:_eecon1 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=018c)
;     4fc5a8:_eecon1_eepgd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> eecon1+0
;     4fc708:_eecon1_wrerr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> eecon1+0
;     4fc868:_eecon1_wren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> eecon1+0
;     4fc9c8:_eecon1_wr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> eecon1+0
;     4fcb28:_eecon1_rd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> eecon1+0
;     4fcc88:_eecon2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=018d)
;     4fce18:_adc_group  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44481
;     4fd108:_adc_ntotal_channel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 8
;     4fcef8:_adc_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4fe3a8:_enable_digital_io_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4ffbb8:_target_clock  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 20000000
;     4fed28:_delay_1us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5001a8:_delay_2us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     500948:_delay_3us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     501218:_delay_4us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5019b8:_delay_5us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     502288:_delay_6us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     502a28:_delay_7us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     503288:_delay_8us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     503a28:_delay_9us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     504288:_instruction_time  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 20
;     504c38:_delay_10us_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     507938:_delay_1ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     50c1f8:_delay_100ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     50e108:_delay_1s_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5047e8:_print_string_terminator byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     5103c8:_ascii_null byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     510538:_ascii_soh byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     5106a8:_ascii_stx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 2
;     510818:_ascii_etx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     510988:_ascii_eot byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     510af8:_ascii_enq byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     510c68:_ascii_ack byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     510dd8:_ascii_bel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 7
;     510f48:_ascii_bs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 8
;     511108:_ascii_ht byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 9
;     511278:_ascii_lf byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 10
;     5113e8:_ascii_vt byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 11
;     511558:_ascii_ff byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 12
;     5116c8:_ascii_cr byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 13
;     511838:_ascii_so byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 14
;     5119a8:_ascii_si byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 15
;     511b18:_ascii_dle byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 16
;     511c88:_ascii_dc1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 17
;     511df8:_ascii_dc2 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 18
;     511f68:_ascii_dc3 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 19
;     512108:_ascii_dc4 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 20
;     512278:_ascii_nak byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 21
;     5123e8:_ascii_syn byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 22
;     512558:_ascii_etb byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 23
;     5126c8:_ascii_can byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 24
;     512838:_ascii_em byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 25
;     5129a8:_ascii_sub byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 26
;     512b18:_ascii_esc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 27
;     512c88:_ascii_fs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 28
;     512df8:_ascii_gs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 29
;     512f68:_ascii_rs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 30
;     513108:_ascii_us byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 31
;     513278:_ascii_sp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 32
;     5133e8:_ascii_del byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 127
;     513788:_toupper_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     516348:_tolower_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     519428:__print_universal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     519a18:__print_suniversal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     518f98:_print_byte_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     51ad98:_nibble2hex  (type=a dflags=C---- sz=16 use=22 assigned=0)
;      = 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70
;     462348:_print_prefix  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     519188:_print_crlf_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     51a2e8:_print_string_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     51ac48:_print_bit_truefalse_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     51ef08:_print_bit_highlow_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     520be8:_print_bit_10_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     523698:_print_dword_binary_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5262e8:_print_word_binary_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     52c3c8:_print_nibble_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     52fd98:_print_dword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5361b8:_print_sdword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     53c618:_print_word_hex_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     532f88:_print_byte_hex_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     542868:_print_sdword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5437e8:_print_sword_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     544778:_print_sword_fp_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     546938:_print_sbyte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5478d8:_print_dword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5488d8:_print_word_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5498d8:_print_byte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     51a1f8:_serial_hw_baudrate  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 115200
;     54a738:_usart_hw_serial bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     518e88:__calculate_and_set_baudrate_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     553f28:_serial_hw_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5541d8:_serial_hw_disable_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     558e78:_serial_hw_enable_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     559908:_serial_hw_write_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     55af98:_serial_hw_write_word_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     55d498:__serial_hw_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     55f748:_serial_hw_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5614e8:__serial_hw_data_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     559638:__serial_hw_data_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     564798:_serial_hw_data_available bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> pir1+0
;     564898:_serial_hw_data_ready bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> pir1+0
;     564c88:__serial_hw_data_raw_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5649a8:__serial_hw_data_raw_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     566b18:__pr2_shadow_plus1 word (type=i dflags=-V--- auto sticky sz=2 use=1 assigned=4 base=0039)
;     5672b8:_pwm_max_resolution_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     56bca8:_pwm_set_frequency_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     566f58:__ccpr1l_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0043)
;     571e08:__ccp1con_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0044)
;     572398:__ccp1con_shadow_dc1b  (type=i dflags=---B- sz=2 use=0 assigned=0 bit=4) ---> _ccp1con_shadow+0
;     5725a8:__ccp1con_shadow_ccp1m  (type=i dflags=---B- sz=4 use=0 assigned=0 bit=0) ---> _ccp1con_shadow+0
;     572978:_pwm1_on_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     573b98:_pwm1_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     574a18:_pwm1_set_dutycycle_highres_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5773b8:_pwm1_set_dutycycle_lowres_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     578c88:_pwm1_set_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     57a1b8:_pwm1_set_percent_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     574738:__ccpr2l_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0045)
;     57eb18:__ccp2con_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0046)
;     57eed8:__ccp2con_shadow_dc2b  (type=i dflags=---B- sz=2 use=0 assigned=0 bit=4) ---> _ccp2con_shadow+0
;     57f108:__ccp2con_shadow_ccp2m  (type=i dflags=---B- sz=4 use=0 assigned=0 bit=0) ---> _ccp2con_shadow+0
;     57f4d8:_pwm2_on_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     580468:_pwm2_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5811b8:_pwm2_set_dutycycle_highres_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     583ad8:_pwm2_set_dutycycle_lowres_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     585558:_pwm2_set_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     586a28:_pwm2_set_percent_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     58c2b8:_timer0_isr_rate  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1000
;     58c3f8:_delay_slots  (type=i dflags=C---U sz=4 use=4 assigned=0)
;      = 2
;     58ab58:_internal_isr_counter word (type=i dflags=----- auto sz=2 use=4 assigned=2 base=0047)
;     58c758:_isr_countdown  (type=a dflags=----- auto sz=4 use=7 assigned=7 base=0049)
;     58c818:_timer0_load byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=004d)
;     58cb08:__isr_counter_get_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     58e258:_set_delay_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     58d748:_check_delay_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     58de98:_timer0_isr_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     59b258:_isr_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     59f588:_adc_high_resolution bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     59f798:_adc_nchannel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 2
;     556758:_adc_nvref byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     59f3f8:__adc_vref_vcfg_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5a1cb8:__adc_vref_adref_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5a1b58:__adc_setup_pins_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5a84d8:__adc_vref_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5a86d8:_tad_value byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=004e)
;     5a87d8:_adc_min_tad byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 16
;     5a83d8:_adc_max_tad byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 60
;     5a89d8:__adc_eval_tad_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5a88d8:__adc_init_clock_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5b7948:_adc_rsource word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 10000
;     5b7838:_adc_temp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 25
;     5b8db8:__adcon0_shadow byte (type=i dflags=-V--- auto sticky sz=1 use=0 assigned=1 base=003b)
;     5b9618:_adc_conversion_delay byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=004f)
;     5b9b38:__adc_read_low_res_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5b9898:_adc_read_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5beb28:_adc_read_bytes_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5be788:_adc_read_low_res_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5b9748:__adc_init_justify_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5c2e98:__adc_init_acquisition_delay_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5c4298:__adc_setup_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5ca108:_adc_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5db4d8:_pwml byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0050)
;     5db9a8:_pwmr byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0051)
;     5dbdd8:_motorl_fwd bit (type=B dflags=---B- sz=1 use=1 assigned=1 bit=0) ---> _bitbucket+0
;     5dc208:_motorr_fwd bit (type=B dflags=---B- sz=1 use=1 assigned=1 bit=1) ---> _bitbucket+0
;     5dc588:_motorh1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portd+0
;     5dc698:_motorh2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portd+0
;     5dc7a8:_motorh3 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portd+0
;     5dc8b8:_motorh4 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portd+0
;     5dd558:_prev_isr_counter word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0052)
;     5dd618:_lefteye word (type=i dflags=----- auto sz=2 use=4 assigned=2 base=0054)
;     5dd6d8:_righteye word (type=i dflags=----- auto sz=2 use=4 assigned=2 base=0056)
;     5dd778:_temp_1 word (type=i dflags=----- auto sz=2 use=4 assigned=4 base=0058)
;     5ddad8:__temp_72  (type=i dflags=----- auto sz=2 use=6 assigned=6 base=005a)
;     5ddd48:__btemp_31  (type=i dflags=---B- sz=7 use=0 assigned=0 bit=2) ---> _bitbucket+0
;     5c1598:__bitbucket  (type=i dflags=----- auto sz=3 use=8 assigned=14 base=005c)
;     52ae88:__pic_temp  (type=i dflags=----- sz=3 use=49 assigned=59) ---> _pic_state+0
;     527318:__pic_pointer  (type=i dflags=----- sz=2 use=1 assigned=2 base=0036)
;     524e88:__pic_loop  (type=i dflags=----- sz=1 use=2 assigned=4 base=0034)
;     524788:__pic_divisor  (type=i dflags=----- sz=4 use=20 assigned=28) ---> _pic_state+8
;     524578:__pic_dividend  (type=i dflags=----- sz=4 use=9 assigned=28) ---> _pic_state+0
;     523f08:__pic_quotient  (type=i dflags=----- sz=4 use=22 assigned=13) ---> _pic_state+12
;     523cd8:__pic_remainder  (type=i dflags=----- sz=4 use=20 assigned=16) ---> _pic_state+4
;     522bb8:__pic_divaccum  (type=i dflags=----- sz=8 use=8 assigned=8) ---> _pic_state+0
;     4d6948:__pic_isr_fsr  (type=i dflags=----- sz=1 use=1 assigned=1 base=0038)
;     4c97e8:__pic_isr_status  (type=i dflags=----- sz=1 use=1 assigned=1 base=0032)
;     4c9608:__pic_isr_pclath  (type=i dflags=----- sz=1 use=1 assigned=1 base=0033)
;     4c7d18:__pic_multiplier  (type=i dflags=----- sz=2 use=2 assigned=4) ---> _pic_state+0
;     4c8298:__pic_multiplicand  (type=i dflags=----- sz=2 use=2 assigned=2) ---> _pic_state+2
;     4c7b38:__pic_mresult  (type=i dflags=----- sz=2 use=7 assigned=5) ---> _pic_state+4
;     57be78:__pic_sign  (type=i dflags=----- sz=1 use=2 assigned=3 base=0035)
;     576808:__pic_state  (type=i dflags=----- sz=16 use=141 assigned=165 base=0020)
;     5779d8:__pic_isr_state  (type=i dflags=-V--- sz=2 use=2 assigned=2 base=0030)
;     --- labels ---
;     _isr_cleanup (pc(0000) usage=0)
;     _isr_preamble (pc(0000) usage=0)
;     _main (pc(009d) usage=7)
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
;     delay_10us (pc(00a0) usage=7)
;     delay_1ms (pc(0000) usage=0)
;     delay_100ms (pc(0000) usage=0)
;     delay_1s (pc(0000) usage=0)
;     toupper (pc(0000) usage=0)
;     tolower (pc(0000) usage=0)
;     _print_universal_dec (pc(00e5) usage=7)
;     _print_suniversal_dec (pc(0000) usage=0)
;     print_byte_binary (pc(0000) usage=0)
;     print_crlf (pc(0000) usage=0)
;     print_string (pc(0000) usage=0)
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
;     print_word_dec (pc(00d0) usage=14)
;     print_byte_dec (pc(0000) usage=0)
;     _calculate_and_set_baudrate (pc(0189) usage=7)
;     serial_hw_init (pc(018e) usage=7)
;     serial_hw_disable (pc(0000) usage=0)
;     serial_hw_enable (pc(0000) usage=0)
;     serial_hw_write (pc(0197) usage=7)
;     serial_hw_write_word (pc(0000) usage=0)
;     _serial_hw_read (pc(0000) usage=0)
;     serial_hw_read (pc(0000) usage=0)
;     _serial_hw_data_put (pc(019d) usage=31)
;     _serial_hw_data_get (pc(0000) usage=0)
;     _serial_hw_data_raw_put (pc(0000) usage=0)
;     _serial_hw_data_raw_get (pc(0000) usage=0)
;     pwm_max_resolution (pc(01ab) usage=7)
;     pwm_set_frequency (pc(0000) usage=0)
;     pwm1_on (pc(01d4) usage=14)
;     pwm1_off (pc(0000) usage=0)
;     pwm1_set_dutycycle_highres (pc(01de) usage=7)
;     pwm1_set_dutycycle_lowres (pc(0000) usage=0)
;     pwm1_set_dutycycle (pc(0202) usage=7)
;     pwm1_set_percent_dutycycle (pc(0000) usage=0)
;     pwm2_on (pc(0216) usage=14)
;     pwm2_off (pc(0000) usage=0)
;     pwm2_set_dutycycle_highres (pc(0220) usage=7)
;     pwm2_set_dutycycle_lowres (pc(0000) usage=0)
;     pwm2_set_dutycycle (pc(0244) usage=7)
;     pwm2_set_percent_dutycycle (pc(0000) usage=0)
;     _isr_counter_get (pc(025a) usage=14)
;     set_delay (pc(0266) usage=7)
;     check_delay (pc(027d) usage=7)
;     timer0_isr_init (pc(02a2) usage=7)
;     isr (pc(02c3) usage=7)
;     _adc_vref_vcfg (pc(0000) usage=0)
;     _adc_vref_adref (pc(0000) usage=0)
;     _adc_setup_pins (pc(0000) usage=0)
;     _adc_vref (pc(0309) usage=7)
;     _adc_eval_tad (pc(030a) usage=21)
;     _adc_init_clock (pc(0000) usage=0)
;     _adc_read_low_res (pc(0341) usage=7)
;     adc_read (pc(0372) usage=14)
;     adc_read_bytes (pc(0000) usage=0)
;     adc_read_low_res (pc(0000) usage=0)
;     _adc_init_justify (pc(0000) usage=0)
;     _adc_init_acquisition_delay (pc(0000) usage=0)
;     _adc_setup (pc(0000) usage=0)
;     adc_init (pc(0000) usage=0)
;     _pic_indirect (pc(009a) usage=12)
;     _pic_divide (pc(0048) usage=24)
;     _pic_sdivide (pc(0027) usage=6)
;     _pic_multiply (pc(0014) usage=6)
;     _pic_reset (pc(0000) usage=0)
;     _pic_isr (pc(0004) usage=0)
;     {block enter}
;       --- records ---
;       --- variables ---
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;         {block enter}
;           --- records ---
;           --- variables ---
;           5d2df8:_no_vref_3  (type=i dflags=---B- sz=4 use=0 assigned=0 bit=9) ---> _bitbucket+0
;           5d2e88:_one_vref_3  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;            = 0
;           5d2f18:_two_vref_3  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;            = 0
;           --- labels ---
;         {block exit}
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         5d6b88:_jallib_adfm_2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> adcon1+0
;         --- labels ---
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         5d7578:_jallib_adcs_lsb_2  (type=i dflags=-V-B- alias sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;         5d7608:_jallib_adcs_msb_2  (type=B dflags=CV-B- sz=1 use=0 assigned=0 bit=0)
;          = 0
;         5d7698:_adcs_2  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=9) ---> _bitbucket+0
;         5d7728:__btemp_30  (type=i dflags=---B- sz=6 use=0 assigned=0 bit=12) ---> _bitbucket+0
;         5d77b8:__btemp57_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=12) ---> _bitbucket+0
;         5d7848:__btemp58_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=13) ---> _bitbucket+0
;         5d78d8:__btemp59_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=14) ---> _bitbucket+0
;         5d7968:__btemp60_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=15) ---> _bitbucket+0
;         5d79f8:__btemp61_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=16) ---> _bitbucket+0
;         5d7a88:__btemp62_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=17) ---> _bitbucket+0
;         5d7b18:_adcs_lsb_2  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=9) ---> _bitbucket+0
;         5d7ba8:_adcs_msb_2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=11) ---> _bitbucket+0
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
;       5dcae8:__temp_71  (type=i dflags=----- auto sz=2 use=2 assigned=2 base=005f)
;       --- labels ---
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       5dde18:__btemp64  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _bitbucket+0
;       5dedd8:__btemp65  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> _bitbucket+0
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         5e05b8:__btemp66  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _bitbucket+0
;         5e3f28:__btemp69  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=7) ---> _bitbucket+0
;         5e5bf8:__btemp70  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=8) ---> _bitbucket+0
;         --- labels ---
;         {block enter}
;           --- records ---
;           --- variables ---
;           5e1228:__btemp67  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _bitbucket+0
;           5e1f98:__btemp68  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _bitbucket+0
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             --- labels ---
;           {block exit}
;           {block enter}
;             --- records ---
;             --- variables ---
;             --- labels ---
;           {block exit}
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           5e34a8:_x_116 bit (type=B dflags=---B- sz=1 use=0 assigned=2 bit=1) ---> _portd_shadow+0
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             --- labels ---
;           {block exit}
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           5e4418:_x_117 bit (type=B dflags=---B- sz=1 use=0 assigned=2 bit=0) ---> _portd_shadow+0
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             --- labels ---
;           {block exit}
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           5e5178:_x_118 bit (type=B dflags=---B- sz=1 use=0 assigned=2 bit=2) ---> _portd_shadow+0
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             --- labels ---
;           {block exit}
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           5e6108:_x_119 bit (type=B dflags=---B- sz=1 use=0 assigned=2 bit=3) ---> _portd_shadow+0
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             --- labels ---
;           {block exit}
;         {block exit}
;       {block exit}
;     {block exit}
;   {block exit}
;      adc_init ----L --- (frame_sz=0 blocks=9)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c16c8:__bitbucket_1  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            5ca528:_no_vref_2  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;             = 0
;            5ca398:_one_vref_2  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;             = 0
;            5caa98:_two_vref_2  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;             = 0
;            --- labels ---
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5cec68:_jallib_adfm_1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> adcon1+0
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5cf7b8:_jallib_adcs_lsb_1  (type=i dflags=-V-B- alias sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;          5cf848:_jallib_adcs_msb_1  (type=B dflags=CV-B- sz=1 use=0 assigned=0 bit=0)
;           = 0
;          5cf8d8:_adcs_1  (type=i dflags=CV-B- sz=3 use=0 assigned=0 bit=0)
;           = 0
;          5cf968:__btemp_29  (type=i dflags=C--B- sz=6 use=0 assigned=0 bit=0)
;           = 0
;          5cf9f8:__btemp57_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          5cfa88:__btemp58_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          5cfb18:__btemp59_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          5cfba8:__btemp60_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          5cfc38:__btemp61_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;          5cfcc8:__btemp62_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;          5cfd58:_adcs_lsb_1  (type=i dflags=-V-B- sz=2 use=0 assigned=0 base=0000 bit=0)
;          5cfde8:_adcs_msb_1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 base=0000 bit=2)
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
;      _adc_setup ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c1258:__bitbucket_2  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5c5ac8:_no_vref_1  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;           = 0
;          5c5b58:_one_vref_1  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;           = 0
;          5c5be8:_two_vref_1  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;           = 0
;          --- labels ---
;        {block exit}
;      {block exit}
;      _adc_init_acquisition_delay ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c4698:_adc_tc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 17
;        5c43f8:_adc_tcoff byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 2
;        5c0f78:__bitbucket_3  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_init_justify ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c2d38:_jallib_adfm bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> adcon1+0
;        5bfef8:__bitbucket_4  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_read_low_res ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5be898:_adc_chan_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c09d8:_adc_value  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c0b38:_shift_alias  (type=i dflags=C---- sz=2 use=3 assigned=0)
;         = 0
;        5c0d18:_ax_2  (type=a dflags=----- sz=2 use=0 assigned=0) ---> shift_alias
;        5c17c8:__temp_70  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5bfa48:__bitbucket_5  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_read_bytes ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5bed18:_adc_chan_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5bedd8:_adc_hbyte_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5bee98:_adc_lbyte_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5bef68:_ad_value_1  (type=i dflags=C---- sz=2 use=1 assigned=0)
;         = 0
;        5bf108:_ax_1  (type=a dflags=----- sz=2 use=0 assigned=0) ---> __ad_value1
;        5bf378:__temp_69  (type=? dflags=C---- sz=0 use=1 assigned=0)
;         = 0
;        597588:__bitbucket_6  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_read --D-- -U- (frame_sz=3 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5bb248:_adc_chan_3 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0061)
;        5bc578:_ad_value word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0063)
;        5bd478:_ax  (type=a dflags=----- sz=2 use=0 assigned=2) ---> ad_value+0
;        5964b8:__bitbucket_7  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_read_low_res --D-- -U- (frame_sz=2 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5b9d28:_adc_chan_1 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0069)
;        5b9db8:_adc_byte_1 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=006a)
;        5bb3a8:__btemp_28  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5bbe68:__btemp63  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        596a88:__bitbucket_8  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      _adc_init_clock ----L --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a9808:_jallib_adcs_lsb  (type=i dflags=-V-B- alias sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;        5a9708:_adc_adcs_bit_long byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 2
;        5a9908:_adc_adcs_bit_split bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5b3468:_jallib_adcs_msb  (type=B dflags=CV-B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5b37e8:_adcs  (type=i dflags=CV-B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        5b4558:__btemp_27  (type=i dflags=C--B- sz=6 use=0 assigned=0 bit=0)
;         = 0
;        5b4448:__btemp57  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5b4a38:__btemp58  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5b55c8:__btemp59  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5b58c8:__btemp60  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;        5b6478:__btemp61  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;        5b6778:__btemp62  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;        5b7448:_adcs_lsb  (type=i dflags=-V-B- sz=2 use=0 assigned=0 base=0000 bit=0)
;        5b7638:_adcs_msb bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5955b8:__bitbucket_9  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      _adc_eval_tad --D-- -U- (frame_sz=5 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a8ad8:_factor_1 word (type=i dflags=----- auto sz=2 use=2 assigned=6 base=0061)
;        5a8bd8:_tad_ok bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket10+0
;        5a8dd8:__temp_68  (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0067)
;        5a9308:__btemp_26  (type=i dflags=---B- sz=3 use=0 assigned=0 bit=1) ---> ___bitbucket10+0
;        5a9408:__btemp54  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=1) ---> ___bitbucket10+0
;        5a9508:__btemp55  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> ___bitbucket10+0
;        5a9608:__btemp56  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket10+0
;        595c88:__bitbucket_10  (type=i dflags=----- auto sz=1 use=4 assigned=8 base=006a)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _adc_vref --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        593c58:__bitbucket_11  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_setup_pins ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a9a68:_adc_pcfg_map  (type=a dflags=C---- sz=27 use=2 assigned=0)
;         = 6,0,0,14,0,0,0,0,0,4,5,15,0,0,13,2,3,12,9,10,11,0,0,0,0,1,8
;        5a0c88:_no_vref  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;         = 0
;        5a8108:_one_vref  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;         = 0
;        5a82d8:_two_vref  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;         = 0
;        5a85d8:_idx byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;         = 6
;        589e08:__bitbucket_12  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_vref_adref ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        589f08:__bitbucket_13  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_vref_vcfg ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a0808:_vcfg_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        589858:__bitbucket_14  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      isr ----- --I (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        59b5a8:__btemp_25  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        59b678:__btemp51  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        59c108:__temp_67  (type=i dflags=----- sticky sz=3 use=3 assigned=3 base=003c)
;        5896f8:__bitbucket_15  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          59c838:_index byte (type=i dflags=----- sticky sz=1 use=5 assigned=2 base=003f)
;          59ee88:__btemp53  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            59d688:__btemp52  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;          {block exit}
;        {block exit}
;      {block exit}
;      timer0_isr_init --D-- -U- (frame_sz=2 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        593978:_timer0_div dword (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 4999
;        599578:_i_1 byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=0061)
;        599ea8:__temp_66  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0063)
;        59a8a8:__btemp_24  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        59a978:__btemp50  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        589458:__bitbucket_16  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      check_delay --D-- -U- (frame_sz=3 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        590188:_slot_3 byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0061)
;        5903a8:__btemp_23  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        590478:__btemp47  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        591108:__temp_65  (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0063)
;        591648:__btemp48  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        589108:__bitbucket_17  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          592398:__btemp49  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      set_delay --D-- -U- (frame_sz=4 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        58e448:_slot_1 byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=0061)
;        58e508:_ticks_1 word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0063)
;        58e728:__btemp_22  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        58e7f8:__btemp46  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        58f6f8:__temp_64  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0069)
;        5892f8:__bitbucket_18  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _isr_counter_get --D-- -U- (frame_sz=2 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        58cd28:_temp word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0061)
;        5885d8:__bitbucket_19  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm2_set_percent_dutycycle ----- --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        586c18:_percent_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        586ce8:_duty_13  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        586f58:__btemp_21  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        587108:__btemp44  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        587e38:__btemp45  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        588708:__temp_63  (type=i dflags=C---- sz=6 use=0 assigned=0)
;         = 0
;        587d18:__bitbucket_20  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      pwm2_set_dutycycle --D-- -U- (frame_sz=5 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        585748:_duty_12 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0061)
;        585958:__temp_62  (type=i dflags=----- auto sz=4 use=6 assigned=6 base=0063)
;        5877a8:__bitbucket_21  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm2_set_dutycycle_lowres ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        583cc8:_duty_10  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        584108:__temp_61  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        584938:__bitbucket_22  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm2_set_dutycycle_highres --D-- -U- (frame_sz=2 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5813a8:_duty_8 word (type=i dflags=----- auto sz=2 use=5 assigned=4 base=006c)
;        581618:__btemp_20  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5816e8:__btemp43  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        582718:__temp_60  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        583ee8:__bitbucket_23  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      pwm2_off ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        580728:__bitbucket_24  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm2_on --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57d7b8:__bitbucket_25  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_set_percent_dutycycle ----- --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57a3a8:_percent_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        57a478:_duty_6  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        57a6e8:__btemp_19  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        57a7b8:__btemp41  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        57b648:__btemp42  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        57bd98:__temp_59  (type=i dflags=C---- sz=6 use=0 assigned=0)
;         = 0
;        57d688:__bitbucket_26  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      pwm1_set_dutycycle --D-- -U- (frame_sz=5 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        578e78:_duty_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0061)
;        579108:__temp_58  (type=i dflags=----- auto sz=4 use=6 assigned=6 base=0063)
;        57cf88:__bitbucket_27  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_set_dutycycle_lowres ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5775a8:_duty_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5778f8:__temp_57  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        57ce28:__bitbucket_28  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_set_dutycycle_highres --D-- -U- (frame_sz=2 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        574c08:_duty_1 word (type=i dflags=----- auto sz=2 use=5 assigned=4 base=006c)
;        574e78:__btemp_18  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        574f48:__btemp40  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        575f28:__temp_56  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        57cb88:__bitbucket_29  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      pwm1_off ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57c838:__bitbucket_30  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_on --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57ca28:__bitbucket_31  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm_set_frequency ----- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        56be98:_freq_1  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        56c108:__temp_55  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        56d2b8:__btemp_17  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;         = 0
;        56d388:__btemp35  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        56d8a8:__btemp36  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        56dc68:__btemp37  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        57bc68:__bitbucket_32  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          56e5b8:__btemp38  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          56f228:__btemp39  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;      pwm_max_resolution --D-- -U- (frame_sz=1 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5674a8:_prescaler_1 byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0061)
;        567b68:__temp_54  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5686a8:__btemp_16  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        568778:__btemp32  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        569938:__btemp33  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        56a738:__btemp34  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        57b528:__bitbucket_33  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      {block exit}
;      _serial_hw_data_raw_get ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57ae58:__bitbucket_34  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_raw_put ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        564e78:_data_55  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        578128:__bitbucket_35  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_get ----- --- (frame_sz=0 blocks=6)
;      {block enter}
;        --- records ---
;        --- variables ---
;        562108:_data_53  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5623d8:__btemp_15  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        5624a8:__btemp30  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        563ba8:__btemp31  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5777c8:__bitbucket_36  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5616d8:_data_52 byte (type=i dflags=----- auto sticky sz=1 use=1 assigned=1 base=0040)
;        573e58:__bitbucket_37  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_read ----- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        55f968:_data_50  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        55fad8:__btemp_14  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        55fba8:__btemp29  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        570958:__bitbucket_38  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        55d688:_data_48  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        570428:__bitbucket_39  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        55b268:_data_46  (type=i dflags=C---- sz=2 use=2 assigned=0)
;         = 0
;        55b328:_dx  (type=a dflags=----- sz=2 use=0 assigned=0) ---> __data46
;        55b658:__btemp_13  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        55b728:__btemp27  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        55c548:__btemp28  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        56ff98:__bitbucket_40  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        559af8:_data_44 byte (type=i dflags=----- auto sticky sz=1 use=1 assigned=1 base=0041)
;        559d88:__btemp_12  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        559e58:__btemp26  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        56fdd8:__bitbucket_41  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        56f888:__bitbucket_42  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_disable ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        557e58:__btemp_11  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        557f28:__btemp25  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        56f108:__bitbucket_43  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        56eb98:__bitbucket_44  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _calculate_and_set_baudrate --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        553c08:_max_deviation  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 5
;        54a828:_usart_div  (type=i dflags=C---U sz=4 use=1 assigned=0)
;         = 10
;        553f88:_real_baud  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 113636
;        56e498:__bitbucket_45  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        549ac8:__device_put_19  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        549b88:_data_38  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56d788:__bitbucket_46  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_word_dec --D-- -U- (frame_sz=4 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        548ac8:__device_put_18  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=4 base=0061)
;        548b88:_data_36 word (type=i dflags=----- auto sz=2 use=2 assigned=4 base=0067)
;        56cc38:__bitbucket_47  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_dword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        547ac8:__device_put_17  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        547b88:_data_34  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        56c658:__bitbucket_48  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sbyte_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        546b28:__device_put_16  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        546be8:_data_32  (type=i dflags=C-S-- sz=1 use=0 assigned=0)
;         = 0
;        56c1e8:__bitbucket_49  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_fp_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        544968:__device_put_15  (type=* dflags=C---- sz=2 use=0 assigned=1)
;         = 0
;        544a28:_data_30  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        544d88:__temp_51  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        55cbe8:__bitbucket_50  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5439d8:__device_put_14  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        543a98:_data_28  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        55bdf8:__bitbucket_51  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sdword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        542a58:__device_put_13  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        542ae8:_data_26  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        54be68:__bitbucket_52  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_hex ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        540268:__device_put_12  (type=* dflags=C---- sz=2 use=0 assigned=4)
;         = 0
;        5402f8:_data_24  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        541108:__temp_50  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        54ae38:__bitbucket_53  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53c808:__device_put_11  (type=* dflags=C---- sz=2 use=0 assigned=6)
;         = 0
;        53c898:_data_22  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53d718:__temp_49  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        549eb8:__bitbucket_54  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5363a8:__device_put_10  (type=* dflags=C---- sz=2 use=0 assigned=10)
;         = 0
;        536438:_data_20  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        537238:__temp_48  (type=i dflags=C---- sz=8 use=0 assigned=0)
;         = 0
;        549db8:__bitbucket_55  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52ff88:__device_put_9  (type=* dflags=C---- sz=2 use=0 assigned=10)
;         = 0
;        513fa8:_data_18  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        530b78:__temp_47  (type=i dflags=C---- sz=8 use=0 assigned=0)
;         = 0
;        547eb8:__bitbucket_56  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52c5b8:__device_put_8  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        52c678:_data_16  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52c878:__floop6  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52d238:__temp_46  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52d888:__btemp_8  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        52f2b8:__btemp18  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        547db8:__bitbucket_57  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          52d958:__btemp17  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;        5264d8:__device_put_6  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        526598:_data_12  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        527238:__temp_44  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        546f18:__bitbucket_58  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        523888:__device_put_5  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        523948:_data_10  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        5246a8:__temp_43  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        546e18:__bitbucket_59  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        522348:__device_put_4  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        522408:_data_8  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        546108:__bitbucket_60  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        51f108:__device_put_3  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        51f4c8:_data_6  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        520e08:_str1_1  (type=a dflags=C---- sz=4 use=0 assigned=0)
;         = 104,105,103,104
;        520cd8:_str0_1  (type=a dflags=C---- sz=3 use=0 assigned=0)
;         = 108,111,119
;        545ee8:__bitbucket_61  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        51eb68:__device_put_2  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        51ec28:_data_4  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        51f258:_str1  (type=a dflags=C---- sz=4 use=0 assigned=0)
;         = 116,114,117,101
;        51f618:_str0  (type=a dflags=C---- sz=5 use=0 assigned=0)
;         = 102,97,108,115,101
;        545c78:__bitbucket_62  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      print_string --D-- --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        51a3d8:__device_put_1  (type=* dflags=C---- sz=2 use=0 assigned=1)
;         = 0
;        51a4c8:__str_count  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        51a5b8:_str_1  (type=* dflags=C---- sz=2 use=2 assigned=0)
;         = 0
;        51a6a8:_len  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        51a798:_i  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        51a978:__btemp_6  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        51ab58:__btemp14  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        545b18:__bitbucket_63  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          51aa68:__btemp13  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      print_crlf ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        51a108:__device_put  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        5457d8:__bitbucket_64  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_binary --D-- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5281f8:__device_put_7  (type=* dflags=C---- sz=2 use=0 assigned=4)
;         = 0
;        5282b8:_data_14  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        528dc8:__floop5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        529758:__temp_45  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        529da8:__btemp_7  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        52b7c8:__btemp16  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        545538:__bitbucket_65  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          529e78:__btemp15  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;        54aa58:__device_put_20  (type=* dflags=C---- sz=2 use=0 assigned=1)
;         = 0
;        54ab18:_data_40  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        54abd8:_digit_divisor_3  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        54ac98:_digit_number_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        54af38:__btemp_9  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        54b108:__btemp19  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        54b828:__temp_52  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        545438:__bitbucket_66  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        54cea8:__device_put_21  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=2 base=006a)
;        54cf68:_data_42 dword (type=i dflags=----- auto sz=4 use=8 assigned=8 base=00a0)
;        54c4f8:_digit_divisor_5 sdword (type=i dflags=--S-- auto sz=4 use=12 assigned=8 base=00a4)
;        54d108:_digit_number_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=006e)
;        54d1f8:_digit byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=006f)
;        54d2d8:_no_digits_printed_yet bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket67+0
;        54d548:__btemp_10  (type=i dflags=---B- sz=5 use=0 assigned=0 bit=1) ---> ___bitbucket67+0
;        54d618:__btemp20  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> ___bitbucket67+0
;        54e998:__btemp21  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> ___bitbucket67+0
;        54f108:__temp_53  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00a8)
;        544e68:__bitbucket_67  (type=i dflags=----- auto sz=1 use=4 assigned=8 base=00a9)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5505b8:__btemp22  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket67+0
;          550b38:__btemp23  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> ___bitbucket67+0
;          550ef8:__btemp24  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=5) ---> ___bitbucket67+0
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
;        516538:_char_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5167a8:__btemp_5  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        516878:__btemp10  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        516e78:__btemp11  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        517378:__btemp12  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        517b98:__temp_42  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        544c58:__bitbucket_68  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        513978:_char_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        513b88:__btemp_4  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        513c58:__btemp7  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5143b8:__btemp8  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        514778:__btemp9  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        514f98:__temp_41  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        543dc8:__bitbucket_69  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        50e2f8:_n_7  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50e898:__1_s_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 999998
;        50e4e8:__floop4  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50e6c8:__btemp_3  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        50f598:__btemp6  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        543cc8:__bitbucket_70  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        50c3e8:_n_5  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50c928:__100_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 99998
;        50c578:__floop3  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50c758:__btemp_2  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        50d648:__btemp5  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        542e18:__bitbucket_71  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        50a268:_n_3  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50a7a8:__one_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 998
;        50a3f8:__floop2  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50b108:__btemp_1  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        50a5d8:__btemp4  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        542d18:__bitbucket_72  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      delay_10us --D-- -U- (frame_sz=2 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        504e28:_n_1 byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=006c)
;        504698:__btemp  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        505108:__btemp1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        505ab8:__btemp2  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        506208:__temp_40  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        541d68:__bitbucket_73  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          5065b8:__ten_us_delay1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 7
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          507b08:__ten_us_delay2  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 5
;          508648:__ten_us_delay3  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 9
;          507758:__floop1  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=00a0)
;          5083e8:__btemp3  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
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
;        541b98:__bitbucket_74  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_8us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        541688:__bitbucket_75  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_7us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        540d98:__bitbucket_76  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_6us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5411e8:__bitbucket_77  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_5us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        540ef8:__bitbucket_78  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_4us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5408b8:__bitbucket_79  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_3us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        540688:__bitbucket_80  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_2us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53f848:__bitbucket_81  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_1us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53f678:__bitbucket_82  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      enable_digital_io ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53f268:__bitbucket_83  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      adc_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53ebf8:__bitbucket_84  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f55f8:__temp_39  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53eeb8:__bitbucket_85  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f3c98:_x_115  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4f3fa8:__temp_38  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53ed58:__bitbucket_86  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f2e68:__temp_37  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53e7e8:__bitbucket_87  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f13a8:_x_113  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4f1688:__temp_36  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53e288:__bitbucket_88  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ee8d8:__temp_35  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53e548:__bitbucket_89  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ecf48:_x_111  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4ed2e8:__temp_34  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53e3e8:__bitbucket_90  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ec238:__temp_33  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53dc98:__bitbucket_91  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portd_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ea6e8:_x_109  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4ea9c8:__temp_32  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53d488:__bitbucket_92  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e7718:__temp_31  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53d7f8:__bitbucket_93  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e5d88:_x_107  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4e6158:__temp_30  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53d5e8:__bitbucket_94  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e4f68:__temp_29  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53ce58:__bitbucket_95  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e33e8:_x_105  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4e36c8:__temp_28  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53cc28:__bitbucket_96  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e0b38:__temp_27  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53bae8:__bitbucket_97  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4df3a8:_x_103  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4df6b8:__temp_26  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53b918:__bitbucket_98  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4de598:__temp_25  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53b508:__bitbucket_99  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4dc9a8:_x_101  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4dcc88:__temp_24  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53ae88:__bitbucket_100  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4da238:__temp_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53b268:__bitbucket_101  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d8888:_x_99  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4d8b98:__temp_22  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53b108:__bitbucket_102  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d7a58:__temp_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53aa78:__bitbucket_103  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d5e78:_x_97  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4d6238:__temp_20  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        53a518:__bitbucket_104  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_e0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cccf8:_x_95 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _porte_shadow
;        53a7d8:__bitbucket_105  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53a678:__bitbucket_106  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53a108:__bitbucket_107  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        539a78:__bitbucket_108  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        539d38:__bitbucket_109  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        539bd8:__bitbucket_110  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        539668:__bitbucket_111  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        539108:__bitbucket_112  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5393c8:__bitbucket_113  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_d0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c23a8:_x_83 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portd_shadow+0
;        539268:__bitbucket_114  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4c12f8:_x_81 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _portd_shadow+0
;        538c48:__bitbucket_115  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4c0268:_x_79 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _portd_shadow+0
;        5386e8:__bitbucket_116  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4bf738:_x_77 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _portd_shadow+0
;        5389a8:__bitbucket_117  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4be738:_x_75 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portd_shadow+0
;        538848:__bitbucket_118  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4bd738:_x_73 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portd_shadow+0
;        5382d8:__bitbucket_119  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4bc738:_x_71 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portd_shadow+0
;        537cc8:__bitbucket_120  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4bb8b8:_x_69 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portd_shadow+0
;        537f88:__bitbucket_121  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        537e28:__bitbucket_122  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5377b8:__bitbucket_123  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        536ed8:__bitbucket_124  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        537318:__bitbucket_125  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        537108:__bitbucket_126  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5369f8:__bitbucket_127  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_c0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b3108:_x_61 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portc_shadow
;        5367c8:__bitbucket_128  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b1268:_x_59 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _portc_shadow
;        5356e8:__bitbucket_129  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b0e58:_x_57 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _portc_shadow
;        535518:__bitbucket_130  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4af268:_x_55 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _portc_shadow
;        535108:__bitbucket_131  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4aede8:_x_53 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portc_shadow
;        534a78:__bitbucket_132  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4adc18:_x_51 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portc_shadow
;        534d38:__bitbucket_133  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4acb38:_x_49 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portc_shadow
;        534bd8:__bitbucket_134  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4ab998:_x_47 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portc_shadow
;        534668:__bitbucket_135  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        534108:__bitbucket_136  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5343c8:__bitbucket_137  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        534268:__bitbucket_138  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533bd8:__bitbucket_139  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533678:__bitbucket_140  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533938:__bitbucket_141  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_b0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a32f8:_x_39 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portb_shadow
;        5337d8:__bitbucket_142  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        533268:__bitbucket_143  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        532b88:__bitbucket_144  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        532e48:__bitbucket_145  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49f3a8:_x_31 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portb_shadow
;        532ce8:__bitbucket_146  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49e448:_x_29 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portb_shadow
;        532778:__bitbucket_147  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49d648:_x_27 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portb_shadow
;        532218:__bitbucket_148  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49c648:_x_25 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portb_shadow
;        5324d8:__bitbucket_149  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49b418:__temp_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        532378:__bitbucket_150  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4996b8:_x_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4999f8:__temp_6  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        531cd8:__bitbucket_151  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        498858:__temp_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        531778:__bitbucket_152  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        496ba8:_x_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        496eb8:__temp_4  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        531a38:__bitbucket_153  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        495b58:_x_19  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5318d8:__bitbucket_154  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        531268:__bitbucket_155  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_a0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        493fa8:_x_17 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _porta_shadow
;        5308e8:__bitbucket_156  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        492fa8:_x_15 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _porta_shadow
;        530c58:__bitbucket_157  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        491f38:_x_13 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _porta_shadow
;        530a48:__bitbucket_158  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        490cf8:_x_11 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _porta_shadow
;        530408:__bitbucket_159  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        48fe58:_x_9 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _porta_shadow
;        5301d8:__bitbucket_160  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        48ed18:_x_7 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _porta_shadow
;        52c758:__bitbucket_161  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52e8f8:__bitbucket_162  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52e4a8:__bitbucket_163  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52df98:__bitbucket_164  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52d318:__bitbucket_165  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52d108:__bitbucket_166  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52c958:__bitbucket_167  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
; --- call stack ---
; {root} (depth=0)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   print_word_dec (depth=1)
;     _print_universal_dec (depth=2)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   print_word_dec (depth=1)
;     _print_universal_dec (depth=2)
;   pwm2_set_dutycycle (depth=1)
;     pwm2_set_dutycycle_highres (depth=2)
;       pwm2_on (depth=3)
;   pwm1_set_dutycycle (depth=1)
;     pwm1_set_dutycycle_highres (depth=2)
;       pwm1_on (depth=3)
;   adc_read (depth=1)
;     _adc_read_low_res (depth=2)
;       delay_10us (depth=3)
;   adc_read (depth=1)
;     _adc_read_low_res (depth=2)
;       delay_10us (depth=3)
;   set_delay (depth=1)
;   check_delay (depth=1)
;   _isr_counter_get (depth=1)
;   _isr_counter_get (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_vref (depth=1)
;   timer0_isr_init (depth=1)
;   pwm2_on (depth=1)
;   pwm1_on (depth=1)
;   pwm_max_resolution (depth=1)
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
;48e9d8:_l16(use=0:ref=2:pc=0000)
;48ea38:_l17(use=0:ref=2:pc=0000)
;48f218:_l18(use=0:ref=1:pc=0000)
;48fb18:_l19(use=0:ref=2:pc=0000)
;48fb78:_l20(use=0:ref=2:pc=0000)
;486fc8:_l21(use=0:ref=1:pc=0000)
;4909b8:_l22(use=0:ref=2:pc=0000)
;490a18:_l23(use=0:ref=2:pc=0000)
;491218:_l24(use=0:ref=1:pc=0000)
;491bf8:_l25(use=0:ref=2:pc=0000)
;491c58:_l26(use=0:ref=2:pc=0000)
;492368:_l27(use=0:ref=1:pc=0000)
;492c68:_l28(use=0:ref=2:pc=0000)
;492cc8:_l29(use=0:ref=2:pc=0000)
;493368:_l30(use=0:ref=1:pc=0000)
;493c68:_l31(use=0:ref=2:pc=0000)
;493cc8:_l32(use=0:ref=2:pc=0000)
;494368:_l33(use=0:ref=1:pc=0000)
;494d08:_l34(use=0:ref=2:pc=0000)
;494d68:_l35(use=0:ref=2:pc=0000)
;495818:_l36(use=0:ref=2:pc=0000)
;495878:_l37(use=0:ref=2:pc=0000)
;496368:_l38(use=0:ref=1:pc=0000)
;496868:_l39(use=0:ref=2:pc=0000)
;4968c8:_l40(use=0:ref=2:pc=0000)
;497f58:_l41(use=0:ref=1:pc=0000)
;4983c8:_l42(use=0:ref=2:pc=0000)
;498428:_l43(use=0:ref=2:pc=0000)
;499378:_l44(use=0:ref=2:pc=0000)
;4993d8:_l45(use=0:ref=2:pc=0000)
;49aaf8:_l46(use=0:ref=1:pc=0000)
;49af58:_l47(use=0:ref=2:pc=0000)
;49afb8:_l48(use=0:ref=2:pc=0000)
;49c308:_l49(use=0:ref=2:pc=0000)
;49c368:_l50(use=0:ref=2:pc=0000)
;49ca38:_l51(use=0:ref=1:pc=0000)
;49d308:_l52(use=0:ref=2:pc=0000)
;49d368:_l53(use=0:ref=2:pc=0000)
;49da38:_l54(use=0:ref=1:pc=0000)
;49e108:_l55(use=0:ref=2:pc=0000)
;49e168:_l56(use=0:ref=2:pc=0000)
;49e838:_l57(use=0:ref=1:pc=0000)
;49e798:_l58(use=0:ref=2:pc=0000)
;49ebc8:_l59(use=0:ref=2:pc=0000)
;49f798:_l60(use=0:ref=1:pc=0000)
;49f718:_l61(use=0:ref=2:pc=0000)
;49fb28:_l62(use=0:ref=2:pc=0000)
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
;4b59d8:_l142(use=0:ref=2:pc=0000)
;4b5ee8:_l143(use=0:ref=2:pc=0000)
;4c0658:_l144(use=0:ref=1:pc=0000)
;4c0f58:_l145(use=0:ref=2:pc=0000)
;4c0fb8:_l146(use=0:ref=2:pc=0000)
;4c16e8:_l147(use=0:ref=1:pc=0000)
;4c1388:_l148(use=0:ref=2:pc=0000)
;4c1648:_l149(use=0:ref=2:pc=0000)
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
;4d5b38:_l175(use=0:ref=2:pc=0000)
;4d5b98:_l176(use=0:ref=2:pc=0000)
;4d75c8:_l177(use=0:ref=2:pc=0000)
;4d7628:_l178(use=0:ref=2:pc=0000)
;4d8548:_l179(use=0:ref=2:pc=0000)
;4d85a8:_l180(use=0:ref=2:pc=0000)
;4d9c78:_l181(use=0:ref=2:pc=0000)
;4d9cd8:_l182(use=0:ref=2:pc=0000)
;4dc668:_l183(use=0:ref=2:pc=0000)
;4dc6c8:_l184(use=0:ref=2:pc=0000)
;4de108:_l185(use=0:ref=2:pc=0000)
;4de168:_l186(use=0:ref=2:pc=0000)
;4def68:_l187(use=0:ref=2:pc=0000)
;4defc8:_l188(use=0:ref=2:pc=0000)
;4e06a8:_l189(use=0:ref=2:pc=0000)
;4e0708:_l190(use=0:ref=2:pc=0000)
;4e2c98:_l191(use=0:ref=2:pc=0000)
;4e3108:_l192(use=0:ref=2:pc=0000)
;4e4ad8:_l193(use=0:ref=2:pc=0000)
;4e4b38:_l194(use=0:ref=2:pc=0000)
;4e5a48:_l195(use=0:ref=2:pc=0000)
;4e5aa8:_l196(use=0:ref=2:pc=0000)
;4e7288:_l197(use=0:ref=2:pc=0000)
;4e72e8:_l198(use=0:ref=2:pc=0000)
;4ea3a8:_l199(use=0:ref=2:pc=0000)
;4ea408:_l200(use=0:ref=2:pc=0000)
;4ebcd8:_l201(use=0:ref=2:pc=0000)
;4ebd38:_l202(use=0:ref=2:pc=0000)
;4ecc08:_l203(use=0:ref=2:pc=0000)
;4ecc68:_l204(use=0:ref=2:pc=0000)
;4ee448:_l205(use=0:ref=2:pc=0000)
;4ee4a8:_l206(use=0:ref=2:pc=0000)
;4f0b98:_l207(use=0:ref=2:pc=0000)
;4f0c98:_l208(use=0:ref=2:pc=0000)
;4f29d8:_l209(use=0:ref=2:pc=0000)
;4f2a38:_l210(use=0:ref=2:pc=0000)
;4f3958:_l211(use=0:ref=2:pc=0000)
;4f39b8:_l212(use=0:ref=2:pc=0000)
;4f5168:_l213(use=0:ref=2:pc=0000)
;4f51c8:_l214(use=0:ref=2:pc=0000)
;4fd268:_l215(use=0:ref=2:pc=0000)
;4fd2c8:_l216(use=0:ref=2:pc=0000)
;4fe258:_l217(use=0:ref=2:pc=0000)
;4fe2b8:_l218(use=0:ref=2:pc=0000)
;4fe988:_l219(use=0:ref=1:pc=0000)
;4ffe88:_l220(use=0:ref=2:pc=0000)
;4ffee8:_l221(use=0:ref=2:pc=0000)
;500648:_l222(use=0:ref=2:pc=0000)
;5006a8:_l223(use=0:ref=2:pc=0000)
;500de8:_l224(use=0:ref=2:pc=0000)
;500e48:_l225(use=0:ref=2:pc=0000)
;5016b8:_l226(use=0:ref=2:pc=0000)
;501718:_l227(use=0:ref=2:pc=0000)
;501e58:_l228(use=0:ref=2:pc=0000)
;501eb8:_l229(use=0:ref=2:pc=0000)
;502728:_l230(use=0:ref=2:pc=0000)
;502788:_l231(use=0:ref=2:pc=0000)
;502ec8:_l232(use=0:ref=2:pc=0000)
;502f28:_l233(use=0:ref=2:pc=0000)
;503728:_l234(use=0:ref=2:pc=0000)
;503788:_l235(use=0:ref=2:pc=0000)
;503ec8:_l236(use=0:ref=2:pc=0000)
;503f28:_l237(use=0:ref=2:pc=0000)
;504ae8:_l238(use=0:ref=2:pc=0000)
;504b48:_l239(use=6:ref=4:pc=00cf)
;504ed8:_l240(use=6:ref=3:pc=00cf)
;505578:_l241(use=7:ref=3:pc=00a4)
;505e28:_l242(use=7:ref=3:pc=00b1)
;5067a8:_l243(use=0:ref=1:pc=0000)
;506968:_l244(use=0:ref=1:pc=0000)
;507cf8:_l245(use=0:ref=1:pc=0000)
;507eb8:_l246(use=0:ref=1:pc=0000)
;508ba8:_l247(use=7:ref=3:pc=00bf)
;508c08:_l248(use=7:ref=3:pc=00ca)
;508c68:_l249(use=0:ref=1:pc=0000)
;508e58:_l250(use=0:ref=1:pc=0000)
;5086a8:_l251(use=0:ref=1:pc=0000)
;509ea8:_l252(use=0:ref=2:pc=0000)
;509f08:_l253(use=0:ref=2:pc=0000)
;50ad08:_l254(use=0:ref=1:pc=0000)
;50ad68:_l255(use=0:ref=1:pc=0000)
;50adc8:_l256(use=0:ref=1:pc=0000)
;50afb8:_l257(use=0:ref=1:pc=0000)
;50b208:_l258(use=0:ref=1:pc=0000)
;50b248:_l259(use=0:ref=2:pc=0000)
;50c108:_l260(use=0:ref=2:pc=0000)
;50ce88:_l261(use=0:ref=1:pc=0000)
;50cee8:_l262(use=0:ref=1:pc=0000)
;50cf48:_l263(use=0:ref=1:pc=0000)
;50de88:_l264(use=0:ref=2:pc=0000)
;50dee8:_l265(use=0:ref=2:pc=0000)
;50edf8:_l266(use=0:ref=1:pc=0000)
;50ee58:_l267(use=0:ref=1:pc=0000)
;50eeb8:_l268(use=0:ref=1:pc=0000)
;50fe38:_l269(use=0:ref=1:pc=0000)
;462938:_l270(use=0:ref=1:pc=0000)
;513638:_l271(use=0:ref=2:pc=0000)
;513698:_l272(use=0:ref=2:pc=0000)
;513a28:_l273(use=0:ref=1:pc=0000)
;514be8:_l274(use=0:ref=1:pc=0000)
;5161f8:_l275(use=0:ref=2:pc=0000)
;516258:_l276(use=0:ref=2:pc=0000)
;5165e8:_l277(use=0:ref=1:pc=0000)
;5177e8:_l278(use=0:ref=1:pc=0000)
;5192d8:_l279(use=0:ref=2:pc=0000)
;519338:_l280(use=6:ref=4:pc=0188)
;5198c8:_l281(use=0:ref=2:pc=0000)
;519928:_l282(use=0:ref=2:pc=0000)
;519d98:_l283(use=0:ref=2:pc=0000)
;519df8:_l284(use=0:ref=2:pc=0000)
;51b5c8:_l285(use=0:ref=2:pc=0000)
;51b628:_l286(use=0:ref=2:pc=0000)
;51c168:_l287(use=0:ref=2:pc=0000)
;51c1c8:_l288(use=0:ref=2:pc=0000)
;51cbd8:_l289(use=0:ref=1:pc=0000)
;51cc38:_l290(use=0:ref=1:pc=0000)
;51cc98:_l291(use=0:ref=1:pc=0000)
;51ce88:_l292(use=0:ref=1:pc=0000)
;51d4d8:_l293(use=0:ref=1:pc=0000)
;51e888:_l294(use=0:ref=2:pc=0000)
;51e8e8:_l295(use=0:ref=2:pc=0000)
;51f6d8:_l296(use=0:ref=1:pc=0000)
;51f778:_l297(use=0:ref=1:pc=0000)
;520628:_l298(use=0:ref=2:pc=0000)
;520688:_l299(use=0:ref=2:pc=0000)
;520c48:_l300(use=0:ref=1:pc=0000)
;520ee8:_l301(use=0:ref=1:pc=0000)
;521228:_l302(use=0:ref=2:pc=0000)
;5216d8:_l303(use=0:ref=2:pc=0000)
;5224e8:_l304(use=0:ref=1:pc=0000)
;5225b8:_l305(use=0:ref=1:pc=0000)
;523548:_l306(use=0:ref=2:pc=0000)
;5235a8:_l307(use=0:ref=2:pc=0000)
;523a28:_l308(use=0:ref=1:pc=0000)
;523b18:_l309(use=0:ref=1:pc=0000)
;526198:_l310(use=0:ref=2:pc=0000)
;5261f8:_l311(use=0:ref=2:pc=0000)
;526678:_l312(use=0:ref=1:pc=0000)
;526768:_l313(use=0:ref=1:pc=0000)
;528398:_l314(use=0:ref=1:pc=0000)
;528488:_l315(use=0:ref=1:pc=0000)
;529328:_l316(use=0:ref=1:pc=0000)
;529388:_l317(use=0:ref=1:pc=0000)
;5293e8:_l318(use=0:ref=1:pc=0000)
;529568:_l319(use=0:ref=1:pc=0000)
;52a438:_l320(use=0:ref=1:pc=0000)
;52c278:_l321(use=0:ref=2:pc=0000)
;52c2d8:_l322(use=0:ref=2:pc=0000)
;52ccb8:_l323(use=0:ref=1:pc=0000)
;52cd18:_l324(use=0:ref=1:pc=0000)
;52cd78:_l325(use=0:ref=1:pc=0000)
;52cef8:_l326(use=0:ref=1:pc=0000)
;52ddd8:_l327(use=0:ref=1:pc=0000)
;52fc48:_l328(use=0:ref=2:pc=0000)
;52fca8:_l329(use=0:ref=2:pc=0000)
;513568:_l330(use=0:ref=1:pc=0000)
;516fc8:_l331(use=0:ref=1:pc=0000)
;535f88:_l332(use=0:ref=2:pc=0000)
;535478:_l333(use=0:ref=2:pc=0000)
;536518:_l334(use=0:ref=1:pc=0000)
;536608:_l335(use=0:ref=1:pc=0000)
;53c4c8:_l336(use=0:ref=2:pc=0000)
;53c528:_l337(use=0:ref=2:pc=0000)
;53c978:_l338(use=0:ref=1:pc=0000)
;53ca68:_l339(use=0:ref=1:pc=0000)
;461d38:_l340(use=0:ref=2:pc=0000)
;461df8:_l341(use=0:ref=2:pc=0000)
;5403d8:_l342(use=0:ref=1:pc=0000)
;5404c8:_l343(use=0:ref=1:pc=0000)
;542718:_l344(use=0:ref=2:pc=0000)
;542778:_l345(use=0:ref=2:pc=0000)
;543698:_l346(use=0:ref=2:pc=0000)
;5436f8:_l347(use=0:ref=2:pc=0000)
;544628:_l348(use=0:ref=2:pc=0000)
;544688:_l349(use=0:ref=2:pc=0000)
;5467e8:_l350(use=0:ref=2:pc=0000)
;546848:_l351(use=0:ref=2:pc=0000)
;547788:_l352(use=0:ref=2:pc=0000)
;5477e8:_l353(use=0:ref=2:pc=0000)
;548788:_l354(use=0:ref=2:pc=0000)
;5487e8:_l355(use=0:ref=2:pc=0000)
;549788:_l356(use=0:ref=2:pc=0000)
;5497e8:_l357(use=0:ref=2:pc=0000)
;54ad78:_l358(use=0:ref=1:pc=0000)
;54b588:_l359(use=0:ref=1:pc=0000)
;54d388:_l360(use=0:ref=1:pc=0000)
;54da98:_l361(use=7:ref=3:pc=00f5)
;54e698:_l362(use=7:ref=3:pc=00f6)
;54e6f8:_l363(use=13:ref=3:pc=0188)
;54e758:_l364(use=0:ref=1:pc=0000)
;550408:_l365(use=0:ref=1:pc=0000)
;5514a8:_l366(use=7:ref=3:pc=0185)
;553298:_l367(use=0:ref=1:pc=0000)
;5534b8:_l368(use=0:ref=1:pc=0000)
;553888:_l369(use=0:ref=2:pc=0000)
;5538e8:_l370(use=0:ref=2:pc=0000)
;553cc8:_l371(use=0:ref=1:pc=0000)
;553d78:_l372(use=0:ref=1:pc=0000)
;553dd8:_l373(use=0:ref=1:pc=0000)
;554748:_l374(use=0:ref=1:pc=0000)
;554d68:_l375(use=0:ref=1:pc=0000)
;554ef8:_l376(use=0:ref=1:pc=0000)
;554f58:_l377(use=0:ref=1:pc=0000)
;554bd8:_l378(use=0:ref=1:pc=0000)
;555288:_l379(use=0:ref=1:pc=0000)
;555418:_l380(use=0:ref=1:pc=0000)
;556478:_l381(use=0:ref=2:pc=0000)
;5564d8:_l382(use=0:ref=2:pc=0000)
;557988:_l383(use=0:ref=2:pc=0000)
;5579e8:_l384(use=0:ref=2:pc=0000)
;557c88:_l385(use=0:ref=1:pc=0000)
;557ce8:_l386(use=0:ref=1:pc=0000)
;557d48:_l387(use=0:ref=1:pc=0000)
;558d28:_l388(use=0:ref=2:pc=0000)
;558d88:_l389(use=0:ref=2:pc=0000)
;5597b8:_l390(use=0:ref=2:pc=0000)
;559818:_l391(use=0:ref=2:pc=0000)
;559ba8:_l392(use=7:ref=3:pc=0198)
;559c08:_l393(use=7:ref=3:pc=019a)
;559c68:_l394(use=0:ref=1:pc=0000)
;55ae48:_l395(use=0:ref=2:pc=0000)
;55aea8:_l396(use=0:ref=2:pc=0000)
;55b4a8:_l397(use=0:ref=1:pc=0000)
;55b508:_l398(use=0:ref=1:pc=0000)
;55b568:_l399(use=0:ref=1:pc=0000)
;55c378:_l400(use=0:ref=1:pc=0000)
;55c3d8:_l401(use=0:ref=1:pc=0000)
;55c438:_l402(use=0:ref=1:pc=0000)
;55d348:_l403(use=0:ref=2:pc=0000)
;55d3a8:_l404(use=0:ref=2:pc=0000)
;55d738:_l405(use=0:ref=1:pc=0000)
;55d7f8:_l406(use=0:ref=1:pc=0000)
;55e608:_l407(use=0:ref=1:pc=0000)
;55e6e8:_l408(use=0:ref=1:pc=0000)
;55f5f8:_l409(use=0:ref=2:pc=0000)
;55f658:_l410(use=0:ref=2:pc=0000)
;552fb8:_l411(use=0:ref=1:pc=0000)
;560208:_l412(use=0:ref=1:pc=0000)
;560708:_l413(use=0:ref=1:pc=0000)
;5607d8:_l414(use=0:ref=1:pc=0000)
;560a68:_l415(use=0:ref=1:pc=0000)
;561398:_l416(use=0:ref=2:pc=0000)
;5613f8:_l417(use=0:ref=2:pc=0000)
;561cd8:_l418(use=0:ref=2:pc=0000)
;561d38:_l419(use=0:ref=2:pc=0000)
;5621b8:_l420(use=0:ref=1:pc=0000)
;562218:_l421(use=0:ref=1:pc=0000)
;562278:_l422(use=0:ref=1:pc=0000)
;562be8:_l423(use=0:ref=1:pc=0000)
;562f28:_l424(use=0:ref=1:pc=0000)
;563558:_l425(use=0:ref=1:pc=0000)
;563628:_l426(use=0:ref=1:pc=0000)
;5638b8:_l427(use=0:ref=1:pc=0000)
;564b38:_l428(use=0:ref=2:pc=0000)
;564b98:_l429(use=0:ref=2:pc=0000)
;565638:_l430(use=14:ref=5:pc=01a2)
;565698:_l431(use=0:ref=2:pc=0000)
;567168:_l432(use=0:ref=2:pc=0000)
;5671c8:_l433(use=0:ref=2:pc=0000)
;568518:_l434(use=18:ref=5:pc=01d0)
;568be8:_l435(use=7:ref=3:pc=01bb)
;569ca8:_l436(use=7:ref=3:pc=01c5)
;56aaa8:_l437(use=7:ref=3:pc=01cf)
;56bb58:_l438(use=7:ref=4:pc=01d1)
;56bbb8:_l439(use=0:ref=2:pc=0000)
;56d108:_l440(use=0:ref=1:pc=0000)
;56e238:_l441(use=0:ref=1:pc=0000)
;56e3b8:_l442(use=0:ref=1:pc=0000)
;56e938:_l443(use=0:ref=1:pc=0000)
;56f5a8:_l444(use=0:ref=1:pc=0000)
;571528:_l445(use=7:ref=3:pc=0213)
;5717a8:_l446(use=0:ref=1:pc=0000)
;572828:_l447(use=0:ref=2:pc=0000)
;572888:_l448(use=0:ref=2:pc=0000)
;573a48:_l449(use=0:ref=2:pc=0000)
;573aa8:_l450(use=0:ref=2:pc=0000)
;5748c8:_l451(use=0:ref=2:pc=0000)
;574928:_l452(use=0:ref=2:pc=0000)
;574cb8:_l453(use=0:ref=1:pc=0000)
;5754a8:_l454(use=13:ref=3:pc=01ec)
;577268:_l455(use=0:ref=2:pc=0000)
;5772c8:_l456(use=0:ref=2:pc=0000)
;578b38:_l457(use=0:ref=2:pc=0000)
;578b98:_l458(use=0:ref=2:pc=0000)
;579f48:_l459(use=0:ref=2:pc=0000)
;579fa8:_l460(use=0:ref=2:pc=0000)
;57a528:_l461(use=0:ref=1:pc=0000)
;57ac38:_l462(use=0:ref=1:pc=0000)
;57b9c8:_l463(use=0:ref=1:pc=0000)
;57e208:_l464(use=7:ref=3:pc=0255)
;57e4b8:_l465(use=0:ref=1:pc=0000)
;57f388:_l466(use=0:ref=2:pc=0000)
;57f3e8:_l467(use=0:ref=2:pc=0000)
;580318:_l468(use=0:ref=2:pc=0000)
;580378:_l469(use=0:ref=2:pc=0000)
;580678:_l470(use=0:ref=2:pc=0000)
;5809e8:_l471(use=0:ref=2:pc=0000)
;581458:_l472(use=0:ref=1:pc=0000)
;581b68:_l473(use=13:ref=3:pc=022e)
;583988:_l474(use=0:ref=2:pc=0000)
;5839e8:_l475(use=0:ref=2:pc=0000)
;585408:_l476(use=0:ref=2:pc=0000)
;585468:_l477(use=0:ref=2:pc=0000)
;5868d8:_l478(use=0:ref=2:pc=0000)
;586938:_l479(use=0:ref=2:pc=0000)
;586d98:_l480(use=0:ref=1:pc=0000)
;587588:_l481(use=0:ref=1:pc=0000)
;588338:_l482(use=0:ref=1:pc=0000)
;58a9a8:_l483(use=0:ref=1:pc=0000)
;58ad38:_l484(use=0:ref=1:pc=0000)
;58aa28:_l485(use=0:ref=1:pc=0000)
;58b208:_l486(use=0:ref=1:pc=0000)
;58b4a8:_l487(use=0:ref=1:pc=0000)
;58b748:_l488(use=0:ref=1:pc=0000)
;58b9e8:_l489(use=0:ref=1:pc=0000)
;58bc88:_l490(use=0:ref=1:pc=0000)
;58c9b8:_l491(use=0:ref=2:pc=0000)
;58ca18:_l492(use=0:ref=2:pc=0000)
;58e108:_l493(use=0:ref=2:pc=0000)
;58e168:_l494(use=6:ref=4:pc=027c)
;58e5e8:_l495(use=0:ref=1:pc=0000)
;58ec78:_l496(use=7:ref=3:pc=026e)
;57f218:_l497(use=0:ref=2:pc=0000)
;580a58:_l498(use=12:ref=5:pc=02a1)
;590268:_l499(use=0:ref=1:pc=0000)
;5907f8:_l500(use=7:ref=3:pc=0286)
;590d68:_l501(use=7:ref=3:pc=02a0)
;591ac8:_l502(use=7:ref=3:pc=02a0)
;591c48:_l503(use=0:ref=1:pc=0000)
;592718:_l504(use=0:ref=1:pc=0000)
;593488:_l505(use=0:ref=2:pc=0000)
;5934e8:_l506(use=0:ref=2:pc=0000)
;593da8:_l507(use=0:ref=1:pc=0000)
;594258:_l508(use=0:ref=1:pc=0000)
;595f18:_l509(use=0:ref=1:pc=0000)
;596d18:_l510(use=0:ref=1:pc=0000)
;597818:_l511(use=0:ref=1:pc=0000)
;599a08:_l512(use=7:ref=3:pc=02b3)
;599a68:_l513(use=0:ref=1:pc=0000)
;599ac8:_l514(use=0:ref=1:pc=0000)
;59b108:_l515(use=7:ref=4:pc=0307)
;59b168:_l516(use=0:ref=2:pc=0000)
;59b468:_l517(use=0:ref=1:pc=0000)
;59b9e8:_l518(use=7:ref=3:pc=02fa)
;59ccc8:_l519(use=7:ref=3:pc=02cb)
;59cd28:_l520(use=0:ref=1:pc=0000)
;59cd88:_l521(use=0:ref=1:pc=0000)
;59cf08:_l522(use=0:ref=1:pc=0000)
;59da08:_l523(use=7:ref=3:pc=02f4)
;59f378:_l524(use=0:ref=1:pc=0000)
;5a04c8:_l525(use=0:ref=2:pc=0000)
;5a0528:_l526(use=0:ref=2:pc=0000)
;5a0bc8:_l527(use=0:ref=1:pc=0000)
;5a0f68:_l528(use=0:ref=1:pc=0000)
;5a1198:_l529(use=0:ref=1:pc=0000)
;5a18f8:_l530(use=0:ref=1:pc=0000)
;5a17c8:_l531(use=0:ref=2:pc=0000)
;5a1898:_l532(use=0:ref=2:pc=0000)
;5a2288:_l533(use=0:ref=1:pc=0000)
;5a2758:_l534(use=0:ref=1:pc=0000)
;5a5468:_l535(use=0:ref=1:pc=0000)
;5a59d8:_l536(use=0:ref=2:pc=0000)
;5a5a38:_l537(use=0:ref=2:pc=0000)
;5a5278:_l538(use=0:ref=1:pc=0000)
;5a6208:_l539(use=0:ref=1:pc=0000)
;5a66d8:_l540(use=0:ref=1:pc=0000)
;5a6b48:_l541(use=0:ref=1:pc=0000)
;5a6fb8:_l542(use=0:ref=1:pc=0000)
;5a6d08:_l543(use=0:ref=1:pc=0000)
;5a7198:_l544(use=0:ref=1:pc=0000)
;5a7608:_l545(use=0:ref=1:pc=0000)
;5a7a78:_l546(use=0:ref=1:pc=0000)
;5a7ee8:_l547(use=0:ref=1:pc=0000)
;5a7938:_l548(use=0:ref=1:pc=0000)
;5a73f8:_l549(use=0:ref=1:pc=0000)
;5aa848:_l550(use=0:ref=1:pc=0000)
;5aacd8:_l551(use=0:ref=1:pc=0000)
;5ab368:_l552(use=0:ref=1:pc=0000)
;5ab5d8:_l553(use=0:ref=1:pc=0000)
;5ab848:_l554(use=0:ref=1:pc=0000)
;5abcb8:_l555(use=0:ref=1:pc=0000)
;5ab708:_l556(use=0:ref=1:pc=0000)
;5abe78:_l557(use=0:ref=1:pc=0000)
;5ac198:_l558(use=0:ref=1:pc=0000)
;5ac608:_l559(use=0:ref=1:pc=0000)
;5aca78:_l560(use=0:ref=1:pc=0000)
;5acea8:_l561(use=0:ref=1:pc=0000)
;5ac7c8:_l562(use=0:ref=1:pc=0000)
;5ac1d8:_l563(use=0:ref=1:pc=0000)
;5ad208:_l564(use=0:ref=1:pc=0000)
;5ad678:_l565(use=0:ref=1:pc=0000)
;5adae8:_l566(use=0:ref=1:pc=0000)
;5ad9a8:_l567(use=0:ref=1:pc=0000)
;5adc68:_l568(use=0:ref=1:pc=0000)
;5ae208:_l569(use=0:ref=1:pc=0000)
;5ae478:_l570(use=0:ref=1:pc=0000)
;5ae8b8:_l571(use=0:ref=1:pc=0000)
;5aea28:_l572(use=0:ref=1:pc=0000)
;5af978:_l573(use=0:ref=2:pc=0000)
;5af9d8:_l574(use=0:ref=2:pc=0000)
;5a1ae8:_l575(use=0:ref=1:pc=0000)
;5a3928:_l576(use=0:ref=1:pc=0000)
;5ae678:_l577(use=0:ref=1:pc=0000)
;5aea68:_l578(use=0:ref=1:pc=0000)
;5975e8:_l579(use=0:ref=2:pc=0000)
;597728:_l580(use=0:ref=2:pc=0000)
;5b1298:_l581(use=0:ref=1:pc=0000)
;5b12d8:_l582(use=7:ref=3:pc=033a)
;5b2a28:_l583(use=0:ref=2:pc=0000)
;5b2a88:_l584(use=0:ref=2:pc=0000)
;5b2d28:_l585(use=0:ref=1:pc=0000)
;5b2f68:_l586(use=0:ref=1:pc=0000)
;5b2dd8:_l587(use=0:ref=1:pc=0000)
;5b3768:_l588(use=0:ref=1:pc=0000)
;5b3ab8:_l589(use=0:ref=1:pc=0000)
;5b3d48:_l590(use=0:ref=1:pc=0000)
;5b4398:_l591(use=0:ref=1:pc=0000)
;5b46b8:_l592(use=0:ref=1:pc=0000)
;5b4da8:_l593(use=0:ref=1:pc=0000)
;5b5c38:_l594(use=0:ref=1:pc=0000)
;5b6ae8:_l595(use=0:ref=1:pc=0000)
;5b7788:_l596(use=0:ref=1:pc=0000)
;5b8208:_l597(use=0:ref=1:pc=0000)
;5b8418:_l598(use=0:ref=1:pc=0000)
;5b8758:_l599(use=7:ref=3:pc=033e)
;5b8968:_l600(use=0:ref=1:pc=0000)
;5b8ca8:_l601(use=0:ref=1:pc=0000)
;5b8288:_l602(use=0:ref=1:pc=0000)
;5b99e8:_l603(use=0:ref=2:pc=0000)
;5b9a48:_l604(use=0:ref=2:pc=0000)
;5baba8:_l605(use=7:ref=3:pc=0351)
;5bac08:_l606(use=7:ref=3:pc=0353)
;5bac68:_l607(use=0:ref=1:pc=0000)
;5bb198:_l608(use=0:ref=1:pc=0000)
;5bb498:_l609(use=0:ref=1:pc=0000)
;5bba18:_l610(use=7:ref=3:pc=036f)
;5bc328:_l611(use=7:ref=3:pc=0365)
;5bccd8:_l612(use=0:ref=2:pc=0000)
;5bd108:_l613(use=0:ref=2:pc=0000)
;5bd5f8:_l614(use=0:ref=1:pc=0000)
;5bd6a8:_l615(use=0:ref=1:pc=0000)
;5be9d8:_l616(use=0:ref=2:pc=0000)
;5bea38:_l617(use=0:ref=2:pc=0000)
;5c0698:_l618(use=0:ref=2:pc=0000)
;5c06f8:_l619(use=0:ref=2:pc=0000)
;5c0a88:_l620(use=0:ref=1:pc=0000)
;5c29b8:_l621(use=0:ref=2:pc=0000)
;5c2a18:_l622(use=0:ref=2:pc=0000)
;5c2cb8:_l623(use=0:ref=1:pc=0000)
;5c3108:_l624(use=0:ref=1:pc=0000)
;5c3518:_l625(use=0:ref=1:pc=0000)
;5c3698:_l626(use=0:ref=1:pc=0000)
;5c3fa8:_l627(use=0:ref=2:pc=0000)
;5c3148:_l628(use=0:ref=2:pc=0000)
;5c4218:_l629(use=0:ref=1:pc=0000)
;5c4b98:_l630(use=0:ref=1:pc=0000)
;5c5688:_l631(use=0:ref=2:pc=0000)
;5c56e8:_l632(use=0:ref=2:pc=0000)
;5c5d88:_l633(use=0:ref=1:pc=0000)
;5c5ec8:_l634(use=0:ref=1:pc=0000)
;5c5968:_l635(use=0:ref=1:pc=0000)
;5c6208:_l636(use=0:ref=1:pc=0000)
;5c6348:_l637(use=0:ref=1:pc=0000)
;5c6488:_l638(use=0:ref=1:pc=0000)
;5c65c8:_l639(use=0:ref=1:pc=0000)
;5c6708:_l640(use=0:ref=1:pc=0000)
;5c6848:_l641(use=0:ref=1:pc=0000)
;5c6988:_l642(use=0:ref=1:pc=0000)
;5c6eb8:_l643(use=0:ref=1:pc=0000)
;5c6f88:_l644(use=0:ref=1:pc=0000)
;5c7278:_l645(use=0:ref=1:pc=0000)
;5c7348:_l646(use=0:ref=1:pc=0000)
;5c7488:_l647(use=0:ref=1:pc=0000)
;5c75c8:_l648(use=0:ref=1:pc=0000)
;5c7808:_l649(use=0:ref=1:pc=0000)
;5c7948:_l650(use=0:ref=1:pc=0000)
;5c7a88:_l651(use=0:ref=1:pc=0000)
;5c7bc8:_l652(use=0:ref=1:pc=0000)
;5c7d08:_l653(use=0:ref=1:pc=0000)
;5c7e48:_l654(use=0:ref=1:pc=0000)
;5c7f88:_l655(use=0:ref=1:pc=0000)
;5c8208:_l656(use=0:ref=1:pc=0000)
;5c8348:_l657(use=0:ref=1:pc=0000)
;5c8488:_l658(use=0:ref=1:pc=0000)
;5c85c8:_l659(use=0:ref=1:pc=0000)
;5c8708:_l660(use=0:ref=1:pc=0000)
;5c8848:_l661(use=0:ref=1:pc=0000)
;5c8988:_l662(use=0:ref=1:pc=0000)
;5c8ac8:_l663(use=0:ref=1:pc=0000)
;5c8c08:_l664(use=0:ref=1:pc=0000)
;5c8d48:_l665(use=0:ref=1:pc=0000)
;5c9208:_l666(use=0:ref=1:pc=0000)
;5c92d8:_l667(use=0:ref=1:pc=0000)
;5c9418:_l668(use=0:ref=1:pc=0000)
;5c9e68:_l669(use=0:ref=2:pc=0000)
;5c9ec8:_l670(use=0:ref=2:pc=0000)
;5ca318:_l671(use=0:ref=1:pc=0000)
;5ca618:_l672(use=0:ref=1:pc=0000)
;5cac38:_l673(use=0:ref=1:pc=0000)
;5cad78:_l674(use=0:ref=1:pc=0000)
;5caeb8:_l675(use=0:ref=1:pc=0000)
;5ca3f8:_l676(use=0:ref=1:pc=0000)
;5cb208:_l677(use=0:ref=1:pc=0000)
;5cb348:_l678(use=0:ref=1:pc=0000)
;5cb488:_l679(use=0:ref=1:pc=0000)
;5cb5c8:_l680(use=0:ref=1:pc=0000)
;5cb708:_l681(use=0:ref=1:pc=0000)
;5cb848:_l682(use=0:ref=1:pc=0000)
;5cbd78:_l683(use=0:ref=1:pc=0000)
;5cbe48:_l684(use=0:ref=1:pc=0000)
;5cc108:_l685(use=0:ref=1:pc=0000)
;5cc1d8:_l686(use=0:ref=1:pc=0000)
;5cc318:_l687(use=0:ref=1:pc=0000)
;5cc458:_l688(use=0:ref=1:pc=0000)
;5cc698:_l689(use=0:ref=1:pc=0000)
;5cc7d8:_l690(use=0:ref=1:pc=0000)
;5cc918:_l691(use=0:ref=1:pc=0000)
;5cca58:_l692(use=0:ref=1:pc=0000)
;5ccb98:_l693(use=0:ref=1:pc=0000)
;5cccd8:_l694(use=0:ref=1:pc=0000)
;5cce18:_l695(use=0:ref=1:pc=0000)
;5ccf58:_l696(use=0:ref=1:pc=0000)
;5cd198:_l697(use=0:ref=1:pc=0000)
;5cd2d8:_l698(use=0:ref=1:pc=0000)
;5cd418:_l699(use=0:ref=1:pc=0000)
;5cd558:_l700(use=0:ref=1:pc=0000)
;5cd698:_l701(use=0:ref=1:pc=0000)
;5cd7d8:_l702(use=0:ref=1:pc=0000)
;5cd918:_l703(use=0:ref=1:pc=0000)
;5cda58:_l704(use=0:ref=1:pc=0000)
;5cdb98:_l705(use=0:ref=1:pc=0000)
;5cdf08:_l706(use=0:ref=1:pc=0000)
;5ce108:_l707(use=0:ref=1:pc=0000)
;5ce248:_l708(use=0:ref=1:pc=0000)
;5ce568:_l709(use=0:ref=1:pc=0000)
;5cee78:_l710(use=0:ref=1:pc=0000)
;5cef48:_l711(use=0:ref=1:pc=0000)
;5cf2e8:_l712(use=0:ref=1:pc=0000)
;5cf3b8:_l713(use=0:ref=1:pc=0000)
;5cf4f8:_l714(use=0:ref=1:pc=0000)
;5cff88:_l715(use=0:ref=1:pc=0000)
;5b0508:_l716(use=0:ref=1:pc=0000)
;5b3978:_l717(use=0:ref=1:pc=0000)
;5bb4d8:_l718(use=0:ref=1:pc=0000)
;5c4eb8:_l719(use=0:ref=1:pc=0000)
;5c4918:_l720(use=0:ref=1:pc=0000)
;5d0208:_l721(use=0:ref=1:pc=0000)
;5d06a8:_l722(use=0:ref=1:pc=0000)
;5d0b48:_l723(use=0:ref=1:pc=0000)
;5d0c18:_l724(use=0:ref=1:pc=0000)
;5d0d58:_l725(use=0:ref=1:pc=0000)
;5d0f78:_l726(use=0:ref=1:pc=0000)
;5d1208:_l727(use=0:ref=1:pc=0000)
;5d1fa8:_l728(use=0:ref=1:pc=0000)
;5d2208:_l729(use=0:ref=1:pc=0000)
;5d2428:_l730(use=0:ref=1:pc=0000)
;5d2b18:_l731(use=0:ref=1:pc=0000)
;5d2be8:_l732(use=7:ref=3:pc=0381)
;5d3198:_l733(use=0:ref=1:pc=0000)
;5d32d8:_l734(use=0:ref=1:pc=0000)
;5d3418:_l735(use=0:ref=1:pc=0000)
;5d3558:_l736(use=0:ref=1:pc=0000)
;5d3698:_l737(use=0:ref=1:pc=0000)
;5d37d8:_l738(use=0:ref=1:pc=0000)
;5d3918:_l739(use=0:ref=1:pc=0000)
;5d3a58:_l740(use=0:ref=1:pc=0000)
;5d3b98:_l741(use=0:ref=1:pc=0000)
;5d3cd8:_l742(use=0:ref=1:pc=0000)
;5d4358:_l743(use=0:ref=1:pc=0000)
;5d4428:_l744(use=0:ref=1:pc=0000)
;5d45d8:_l745(use=0:ref=1:pc=0000)
;5d46a8:_l746(use=0:ref=1:pc=0000)
;5d48e8:_l747(use=0:ref=1:pc=0000)
;5d4a28:_l748(use=0:ref=1:pc=0000)
;5d4b68:_l749(use=0:ref=1:pc=0000)
;5d4ca8:_l750(use=0:ref=1:pc=0000)
;5d4de8:_l751(use=0:ref=1:pc=0000)
;5d4f28:_l752(use=0:ref=1:pc=0000)
;5d5198:_l753(use=0:ref=1:pc=0000)
;5d52d8:_l754(use=0:ref=1:pc=0000)
;5d5418:_l755(use=0:ref=1:pc=0000)
;5d5558:_l756(use=0:ref=1:pc=0000)
;5d5698:_l757(use=0:ref=1:pc=0000)
;5d57d8:_l758(use=0:ref=1:pc=0000)
;5d5918:_l759(use=0:ref=1:pc=0000)
;5d5a58:_l760(use=0:ref=1:pc=0000)
;5d5b98:_l761(use=0:ref=1:pc=0000)
;5d5cd8:_l762(use=0:ref=1:pc=0000)
;5d5e18:_l763(use=0:ref=1:pc=0000)
;5d5f58:_l764(use=0:ref=1:pc=0000)
;5d6198:_l765(use=0:ref=1:pc=0000)
;5d6508:_l766(use=0:ref=1:pc=0000)
;5d65d8:_l767(use=0:ref=1:pc=0000)
;5d6718:_l768(use=0:ref=1:pc=0000)
;5d69b8:_l769(use=0:ref=1:pc=0000)
;5d6d18:_l770(use=0:ref=1:pc=0000)
;5d6de8:_l771(use=0:ref=1:pc=0000)
;5d7198:_l772(use=0:ref=1:pc=0000)
;5d7268:_l773(use=0:ref=1:pc=0000)
;5d73a8:_l774(use=0:ref=1:pc=0000)
;5d7cc8:_l775(use=0:ref=1:pc=0000)
;5d7e78:_l776(use=0:ref=1:pc=0000)
;5d7f48:_l777(use=0:ref=1:pc=0000)
;5d8198:_l778(use=0:ref=1:pc=0000)
;5d82d8:_l779(use=0:ref=1:pc=0000)
;5d8418:_l780(use=0:ref=1:pc=0000)
;5d8a08:_l781(use=7:ref=3:pc=03ab)
;5d8ea8:_l782(use=7:ref=3:pc=03ba)
;5d9478:_l783(use=7:ref=3:pc=03c6)
;5d9548:_l784(use=14:ref=4:pc=03c6)
;5d9688:_l785(use=0:ref=1:pc=0000)
;5d98a8:_l786(use=0:ref=1:pc=0000)
;5d99e8:_l787(use=0:ref=1:pc=0000)
;5d9c48:_l788(use=0:ref=1:pc=0000)
;5d9d88:_l789(use=0:ref=1:pc=0000)
;5d9fa8:_l790(use=0:ref=1:pc=0000)
;5da278:_l791(use=0:ref=1:pc=0000)
;5dceb8:_l792(use=0:ref=1:pc=0000)
;5dd828:_l793(use=14:ref=4:pc=03e9)
;5dd888:_l794(use=0:ref=1:pc=0000)
;5dda08:_l795(use=0:ref=1:pc=0000)
;5de438:_l796(use=7:ref=3:pc=03fd)
;5decf8:_l797(use=0:ref=1:pc=0000)
;5df1b8:_l798(use=0:ref=1:pc=0000)
;5e0408:_l799(use=20:ref=4:pc=0464)
;5e0a38:_l800(use=13:ref=3:pc=0462)
;5e0f98:_l801(use=0:ref=1:pc=0000)
;5e16a8:_l802(use=13:ref=3:pc=0457)
;5e1de8:_l803(use=0:ref=1:pc=0000)
;5e23d8:_l804(use=0:ref=1:pc=0000)
;5e3a48:_l805(use=0:ref=1:pc=0000)
;5e3bf8:_l806(use=0:ref=1:pc=0000)
;5e49b8:_l807(use=0:ref=1:pc=0000)
;5e4b68:_l808(use=0:ref=1:pc=0000)
;5e5718:_l809(use=0:ref=1:pc=0000)
;5e58c8:_l810(use=0:ref=1:pc=0000)
;5e66a8:_l811(use=0:ref=1:pc=0000)
;5e6858:_l812(use=0:ref=1:pc=0000)
;61f688:_l813(use=3:ref=1:pc=0000)
;4676d8:_l814(use=3:ref=1:pc=0000)
;6208a8:_l815(use=3:ref=1:pc=0000)
;624ed8:_l816(use=9:ref=1:pc=0000)
;626588:_l817(use=0:ref=1:pc=0000)
;62c6a8:_l818(use=0:ref=1:pc=0000)
;62c708:_l819(use=0:ref=1:pc=0000)
;635fb8:_l820(use=3:ref=1:pc=0000)
;636868:_l821(use=0:ref=1:pc=0000)
;63c328:_l822(use=3:ref=1:pc=0000)
;63cac8:_l823(use=0:ref=1:pc=0000)
;642b88:_l824(use=0:ref=1:pc=0000)
;642ec8:_l825(use=3:ref=1:pc=0000)
;644828:_l826(use=0:ref=1:pc=0000)
;644b68:_l827(use=3:ref=1:pc=0000)
;650828:_l828(use=0:ref=1:pc=0000)
;650f98:_l829(use=0:ref=1:pc=0000)
;651408:_l830(use=3:ref=1:pc=0000)
;651a88:_l831(use=0:ref=1:pc=0000)
;651ae8:_l832(use=0:ref=1:pc=0000)
;652888:_l833(use=3:ref=1:pc=0000)
;6528e8:_l834(use=3:ref=1:pc=0000)
;655928:_l835(use=0:ref=1:pc=0000)
;655c98:_l836(use=3:ref=1:pc=0000)
;6562a8:_l837(use=3:ref=1:pc=0000)
;656a88:_l838(use=3:ref=1:pc=0000)
;65b428:_l839(use=3:ref=1:pc=0000)
;65b488:_l840(use=3:ref=1:pc=0000)
;65ce18:_l841(use=3:ref=1:pc=0000)
;65ce78:_l842(use=3:ref=1:pc=0000)
;65e988:_l843(use=3:ref=1:pc=0000)
;65e9e8:_l844(use=3:ref=1:pc=0000)
;664e88:_l845(use=3:ref=1:pc=0000)
;664ee8:_l846(use=3:ref=1:pc=0000)
;66a9a8:_l847(use=3:ref=1:pc=0000)
;66b2a8:_l848(use=0:ref=1:pc=0000)
;66bd88:_l849(use=3:ref=1:pc=0000)
;66c688:_l850(use=0:ref=1:pc=0000)
;66cfc8:_l851(use=3:ref=1:pc=0000)
;66d868:_l852(use=0:ref=1:pc=0000)
;66eba8:_l853(use=3:ref=1:pc=0000)
;66ec08:_l854(use=3:ref=1:pc=0000)
;670928:_l855(use=3:ref=1:pc=0000)
;670988:_l856(use=3:ref=1:pc=0000)
;675408:_l857(use=3:ref=1:pc=0000)
;675468:_l858(use=3:ref=1:pc=0000)
;676f58:_l859(use=3:ref=1:pc=0000)
;676fb8:_l860(use=3:ref=1:pc=0000)
;677128:_l861(use=3:ref=1:pc=0000)
;677188:_l862(use=3:ref=1:pc=0000)
;678788:_l863(use=3:ref=1:pc=0000)
;679d88:_l864(use=3:ref=1:pc=0000)
;67c128:_l865(use=9:ref=1:pc=0000)
;6819a8:_l866(use=3:ref=1:pc=0016)
;681a08:_l867(use=3:ref=1:pc=0024)
;681b88:_l868(use=3:ref=1:pc=004f)
;681be8:_l869(use=3:ref=1:pc=007e)
;681c48:_l870(use=3:ref=1:pc=006f)
;681ca8:_l871(use=3:ref=1:pc=0036)
;681e28:_l872(use=3:ref=1:pc=0046)
;681fa8:_l873(use=3:ref=1:pc=0049)
;682128:_l874(use=9:ref=1:pc=006b)
;682248:_l875(use=3:ref=1:pc=00ae)
;682328:_l876(use=3:ref=1:pc=00b8)
;682408:_l877(use=3:ref=1:pc=00c5)
;6826f8:_l878(use=9:ref=1:pc=010a)
;682958:_l879(use=0:ref=1:pc=010e)
;682a18:_l880(use=0:ref=1:pc=0175)
;682a78:_l881(use=0:ref=1:pc=0000)
;683748:_l882(use=3:ref=1:pc=01e4)
;683868:_l883(use=0:ref=1:pc=01e8)
;683d88:_l884(use=3:ref=1:pc=0226)
;683ea8:_l885(use=0:ref=1:pc=022a)
;684458:_l886(use=0:ref=1:pc=0269)
;684518:_l887(use=3:ref=1:pc=026d)
;6846a8:_l888(use=0:ref=1:pc=0280)
;684768:_l889(use=3:ref=1:pc=0284)
;685128:_l890(use=0:ref=1:pc=0329)
;685218:_l891(use=0:ref=1:pc=032f)
;685308:_l892(use=3:ref=1:pc=0334)
;685388:_l893(use=0:ref=1:pc=0338)
;6853e8:_l894(use=0:ref=1:pc=0000)
;685758:_l895(use=0:ref=1:pc=0357)
;685848:_l896(use=3:ref=1:pc=035b)
;6858a8:_l897(use=3:ref=1:pc=0361)
;685988:_l898(use=3:ref=1:pc=036b)
;686dc8:_l899(use=3:ref=1:pc=0442)
;686ee8:_l900(use=0:ref=1:pc=0446)
;686f48:_l901(use=3:ref=1:pc=0450)
;6867a8:_l902(use=0:ref=1:pc=0454)
;687168:_l903(use=3:ref=1:pc=045d)
;687288:_l904(use=0:ref=1:pc=0461)
;6872e8:_l905(use=3:ref=1:pc=046e)
;687348:_l906(use=3:ref=1:pc=046d)
;6873a8:_l907(use=3:ref=1:pc=0480)
;687408:_l908(use=3:ref=1:pc=047f)
;Unnamed Constant Variables
;============
