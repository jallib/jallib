; compiler: jal 2.4n-beta (compiled Mar 13 2010)

; command line:  c:\jallib\compiler\jalv2.exe tank.jal -Wall -Wno-directives -long-start -s "c:\jallib\include;c:\jallib\include\device;c:\jallib\include\external;c:\jallib\include\external\can;c:\jallib\include\external\co2;c:\jallib\include\external\humidity;c:\jallib\include\external\keyboard;c:\jallib\include\external\lcd;c:\jallib\include\external\media;c:\jallib\include\external\motor;c:\jallib\include\external\motor\dc;c:\jallib\include\external\motor\period_skip;c:\jallib\include\external\motor\servo;c:\jallib\include\external\motor\stepper;c:\jallib\include\external\ranger;c:\jallib\include\external\ranger\ir;c:\jallib\include\external\ranger\us;c:\jallib\include\external\rtc;c:\jallib\include\external\seven_segment;c:\jallib\include\external\storage;c:\jallib\include\external\storage\eeprom;c:\jallib\include\external\storage\harddisk;c:\jallib\include\external\storage\ram;c:\jallib\include\external\storage\ram\23k256;c:\jallib\include\external\storage\sd_card;c:\jallib\include\external\temperature;c:\jallib\include\filesystem;c:\jallib\include\jal;c:\jallib\include\peripheral;c:\jallib\include\peripheral\adc;c:\jallib\include\peripheral\can;c:\jallib\include\peripheral\comparator;c:\jallib\include\peripheral\data_eeprom;c:\jallib\include\peripheral\flash_memory;c:\jallib\include\peripheral\i2c;c:\jallib\include\peripheral\pwm;c:\jallib\include\peripheral\spi;c:\jallib\include\peripheral\timer;c:\jallib\include\peripheral\usart;c:\jallib\include\peripheral\usb;c:\jallib\include\protocol;c:\jallib\test;c:\jallib\test\board;c:\jallib\test\external;c:\jallib\test\external\keyboard;c:\jallib\test\external\lcd;c:\jallib\test\external\ranger;c:\jallib\test\external\ranger\ir;c:\jallib\test\external\rtc;c:\jallib\test\external\seven_segment;c:\jallib\test\jal;c:\jallib\test\peripheral;c:\jallib\test\peripheral\adc;c:\jallib\test\peripheral\comparator;c:\jallib\test\peripheral\data_eeprom;c:\jallib\test\peripheral\flash_memory;c:\jallib\test\peripheral\i2c;c:\jallib\test\peripheral\pwm;c:\jallib\test\peripheral\spi;c:\jallib\test\peripheral\timer;c:\jallib\test\peripheral\usart;c:\jallib\test\peripheral\usb;c:\jallib\test\unittest;"
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
                               movf     v__pic_state,w
                               movwf    v__pic_isr_state
                               movf     v__pic_state+1,w
                               movwf    v__pic_isr_state+1
                               branchhi_clr l_isr
                               branchlo_clr l_isr
                               goto     l_isr
l__pic_multiply
                               movlw    16
                               movwf    v__pic_loop
l__l864
                               bcf      v__status, v__c
                               rlf      v__pic_mresult,f
                               rlf      v__pic_mresult+1,f
                               bcf      v__status, v__c
                               rlf      v__pic_multiplier,f
                               rlf      v__pic_multiplier+1,f
                               btfss    v__status, v__c
                               goto     l__l865
                               movf     v__pic_multiplicand+1,w
                               addwf    v__pic_mresult+1,f
                               movf     v__pic_multiplicand,w
                               addwf    v__pic_mresult,f
                               btfsc    v__status, v__c
                               incf     v__pic_mresult+1,f
l__l865
                               decfsz   v__pic_loop,f
                               goto     l__l864
                               return   
l__pic_sdivide
                               movlw    0
                               btfss    v__pic_dividend+3, 7
                               goto     l__l869
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
l__l869
                               movwf    v__pic_sign
                               movlw    0
                               btfss    v__pic_divisor+3, 7
                               goto     l__l870
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
l__l870
                               xorwf    v__pic_sign,f
                               goto     l__l871
l__pic_divide
                               clrf     v__pic_sign
l__l871
                               movlw    32
                               movwf    v__pic_loop
                               clrf     v__pic_remainder
                               clrf     v__pic_remainder+1
                               clrf     v__pic_remainder+2
                               clrf     v__pic_remainder+3
l__l866
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
                               goto     l__l872
                               movf     v__pic_remainder+2,w
                               subwf    v__pic_divisor+2,w
                               btfss    v__status, v__z
                               goto     l__l872
                               movf     v__pic_remainder+1,w
                               subwf    v__pic_divisor+1,w
                               btfss    v__status, v__z
                               goto     l__l872
                               movf     v__pic_remainder,w
                               subwf    v__pic_divisor,w
l__l872
                               btfsc    v__status, v__z
                               goto     l__l868
                               btfsc    v__status, v__c
                               goto     l__l867
l__l868
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
l__l867
                               decfsz   v__pic_loop,f
                               goto     l__l866
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
                               movf     v__pic_pointer,w
                               movwf    v__pcl
l__main
; c:\jallib\include\device/16f877.jal
;  404 var          byte  _PORTD_shadow        = PORTD
                               movf     v_portd,w
                               movwf    v__portd_shadow
;  513 procedure _PORTE_flush() is
                               goto     l__l428
; c:\jallib\include\jal/delay.jal
;   83 procedure delay_10us(byte in n) is
l_delay_10us
                               movwf    v___n_1
;   84    if n==0 then
                               movf     v___n_1,w
                               btfsc    v__status, v__z
;   85       return
                               return   
;   86    elsif n==1 then
l__l241
                               movlw    1
                               subwf    v___n_1,w
                               btfss    v__status, v__z
                               goto     l__l242
;   89        _usec_delay(_ten_us_delay1)
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    10
                               movwf    v__pic_temp
                               branchhi_clr l__l873
                               branchlo_clr l__l873
l__l873
                               decfsz   v__pic_temp,f
                               goto     l__l873
;   90      end if
                               return   
;   91    else     
l__l242
;   92       n = n - 1;
                               decf     v___n_1,f
;   95          _usec_delay(_ten_us_delay2)   
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    6
                               movwf    v__pic_temp
                               branchhi_clr l__l874
                               branchlo_clr l__l874
l__l874
                               decfsz   v__pic_temp,f
                               goto     l__l874
                               nop      
                               nop      
;  101       for n loop
                               datalo_set v__floop1
                               clrf     v__floop1
                               goto     l__l248
l__l247
;  103             _usec_delay(_ten_us_delay3)
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    13
                               movwf    v__pic_temp
                               branchhi_clr l__l875
                               branchlo_clr l__l875
l__l875
                               decfsz   v__pic_temp,f
                               goto     l__l875
                               nop      
;  107       end loop
                               datalo_set v__floop1
                               incf     v__floop1,f
l__l248
                               movf     v__floop1,w
                               datalo_clr v___n_1
                               subwf    v___n_1,w
                               btfss    v__status, v__z
                               goto     l__l247
;  108    end if
l__l240
;  110 end procedure
l__l239
                               return   
; c:\jallib\include\jal/print.jal
;   42 procedure print_crlf(volatile byte out device) is
;  250 procedure print_word_dec(volatile byte out device, word in data) is
l_print_word_dec
;  252    _print_universal_dec(device, data, 10000, 5)
                               movf     v____device_put_18,w
                               movwf    v____device_put_21
                               movf     v____device_put_18+1,w
                               movwf    v____device_put_21+1
                               movf     v___data_36,w
                               datalo_set v___data_42
                               movwf    v___data_42
                               datalo_clr v___data_36
                               movf     v___data_36+1,w
                               datalo_set v___data_42
                               movwf    v___data_42+1
                               clrf     v___data_42+2
                               clrf     v___data_42+3
                               movlw    16
                               movwf    v___digit_divisor_5
                               movlw    39
                               movwf    v___digit_divisor_5+1
                               clrf     v___digit_divisor_5+2
                               clrf     v___digit_divisor_5+3
                               movlw    5
                               goto     l__print_universal_dec
;  254 end procedure
;  277 procedure _print_universal_dec(volatile byte out device, dword in data, sdword in digit_divisor, byte in digit_number) is
l__print_universal_dec
                               datalo_clr v___digit_number_5
                               movwf    v___digit_number_5
;  281    if (data == 0) then
                               datalo_set v___data_42
                               movf     v___data_42,w
                               iorwf    v___data_42+1,w
                               iorwf    v___data_42+2,w
                               iorwf    v___data_42+3,w
                               btfss    v__status, v__z
                               goto     l__l359
;  282       device = "0"      
                               movlw    48
                               datalo_clr v__pic_temp
                               movwf    v__pic_temp
                               movf     v____device_put_21,w
                               movwf    v__pic_pointer
                               movf     v____device_put_21+1,w
                               goto     l__pic_indirect
;  283       return
;  284    end if
l__l359
;  286    no_digits_printed_yet = true
                               bsf      v____bitbucket_67, 0 ; no_digits_printed_yet
;  287    while (digit_divisor > 0) loop
l__l360
                               datalo_set v___digit_divisor_5
                               movf     v___digit_divisor_5+3,w
                               xorlw    128
                               datalo_clr v__pic_temp
                               movwf    v__pic_temp
                               movlw    128
                               subwf    v__pic_temp,w
                               btfss    v__status, v__z
                               goto     l__l876
                               movlw    0
                               datalo_set v___digit_divisor_5
                               subwf    v___digit_divisor_5+2,w
                               btfss    v__status, v__z
                               goto     l__l876
                               movlw    0
                               subwf    v___digit_divisor_5+1,w
                               btfss    v__status, v__z
                               goto     l__l876
                               movlw    0
                               subwf    v___digit_divisor_5,w
l__l876
                               btfsc    v__status, v__z
                               goto     l__l361
                               btfss    v__status, v__c
                               goto     l__l361
;  288       digit = byte ( data / digit_divisor )
                               datalo_set v___digit_divisor_5
                               movf     v___digit_divisor_5,w
                               datalo_clr v__pic_divisor
                               movwf    v__pic_divisor
                               datalo_set v___digit_divisor_5
                               movf     v___digit_divisor_5+1,w
                               datalo_clr v__pic_divisor
                               movwf    v__pic_divisor+1
                               datalo_set v___digit_divisor_5
                               movf     v___digit_divisor_5+2,w
                               datalo_clr v__pic_divisor
                               movwf    v__pic_divisor+2
                               datalo_set v___digit_divisor_5
                               movf     v___digit_divisor_5+3,w
                               datalo_clr v__pic_divisor
                               movwf    v__pic_divisor+3
                               datalo_set v___data_42
                               movf     v___data_42,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend
                               datalo_set v___data_42
                               movf     v___data_42+1,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend+1
                               datalo_set v___data_42
                               movf     v___data_42+2,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend+2
                               datalo_set v___data_42
                               movf     v___data_42+3,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend+3
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               movwf    v_digit
;  289       data = data % digit_divisor
                               movf     v__pic_remainder,w
                               datalo_set v___data_42
                               movwf    v___data_42
                               datalo_clr v__pic_remainder
                               movf     v__pic_remainder+1,w
                               datalo_set v___data_42
                               movwf    v___data_42+1
                               datalo_clr v__pic_remainder
                               movf     v__pic_remainder+2,w
                               datalo_set v___data_42
                               movwf    v___data_42+2
                               datalo_clr v__pic_remainder
                               movf     v__pic_remainder+3,w
                               datalo_set v___data_42
                               movwf    v___data_42+3
;  290       digit_divisor = digit_divisor / 10
                               movlw    10
                               datalo_clr v__pic_divisor
                               movwf    v__pic_divisor
                               clrf     v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               datalo_set v___digit_divisor_5
                               movf     v___digit_divisor_5,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend
                               datalo_set v___digit_divisor_5
                               movf     v___digit_divisor_5+1,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend+1
                               datalo_set v___digit_divisor_5
                               movf     v___digit_divisor_5+2,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend+2
                               datalo_set v___digit_divisor_5
                               movf     v___digit_divisor_5+3,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend+3
                               call     l__pic_sdivide
                               datalo_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               datalo_set v___digit_divisor_5
                               movwf    v___digit_divisor_5
                               datalo_clr v__pic_quotient
                               movf     v__pic_quotient+1,w
                               datalo_set v___digit_divisor_5
                               movwf    v___digit_divisor_5+1
                               datalo_clr v__pic_quotient
                               movf     v__pic_quotient+2,w
                               datalo_set v___digit_divisor_5
                               movwf    v___digit_divisor_5+2
                               datalo_clr v__pic_quotient
                               movf     v__pic_quotient+3,w
                               datalo_set v___digit_divisor_5
                               movwf    v___digit_divisor_5+3
;  292       if ((digit != 0) | (no_digits_printed_yet == false)) then
                               datalo_clr v_digit
                               movf     v_digit,w
                               datalo_set v____bitbucket_67 ; _btemp22
                               bsf      v____bitbucket_67, 3 ; _btemp22
                               btfsc    v__status, v__z
                               bcf      v____bitbucket_67, 3 ; _btemp22
                               bcf      v____bitbucket_67, 4 ; _btemp23
                               btfss    v____bitbucket_67, 0 ; no_digits_printed_yet
                               bsf      v____bitbucket_67, 4 ; _btemp23
                               bcf      v____bitbucket_67, 5 ; _btemp24
                               btfss    v____bitbucket_67, 3 ; _btemp22
                               btfsc    v____bitbucket_67, 4 ; _btemp23
                               bsf      v____bitbucket_67, 5 ; _btemp24
                               btfss    v____bitbucket_67, 5 ; _btemp24
                               goto     l__l364
;  293          device = digit | "0"
                               movlw    48
                               datalo_clr v_digit
                               iorwf    v_digit,w
                               datalo_set v____temp_53
                               movwf    v____temp_53
                               movf     v____temp_53,w
                               datalo_clr v__pic_temp
                               movwf    v__pic_temp
                               movf     v____device_put_21,w
                               movwf    v__pic_pointer
                               movf     v____device_put_21+1,w
                               call     l__pic_indirect
;  294          no_digits_printed_yet = false
                               datalo_set v____bitbucket_67 ; no_digits_printed_yet
                               bcf      v____bitbucket_67, 0 ; no_digits_printed_yet
;  295       end if
l__l364
;  296       digit_number = digit_number - 1
                               datalo_clr v___digit_number_5
                               decf     v___digit_number_5,f
;  297    end loop
                               goto     l__l360
l__l361
;  299 end procedure
l__l278
                               return   
; c:\jallib\include\peripheral\usart/usart_common.jal
;   43 procedure _calculate_and_set_baudrate() is
l__calculate_and_set_baudrate
;   99                SPBRG = usart_div 
                               movlw    10
                               datalo_set v_spbrg
                               movwf    v_spbrg
;  103             TXSTA_BRGH = true
                               bsf      v_txsta, 2 ; txsta_brgh
;  152 end procedure
                               return   
; c:\jallib\include\peripheral\usart/serial_hardware.jal
;   25 procedure serial_hw_init() is 
l_serial_hw_init
;   27    _calculate_and_set_baudrate()
                               call     l__calculate_and_set_baudrate
;   30    PIE1_RCIE = false
                               datalo_set v_pie1 ; pie1_rcie
                               bcf      v_pie1, 5 ; pie1_rcie
;   31    PIE1_TXIE = false
                               bcf      v_pie1, 4 ; pie1_txie
;   34    TXSTA_TXEN = true
                               bsf      v_txsta, 5 ; txsta_txen
;   38    RCSTA = 0x90
                               movlw    144
                               datalo_clr v_rcsta
                               movwf    v_rcsta
;   40 end procedure
                               return   
;   67 procedure serial_hw_write(byte in data) is
l_serial_hw_write
                               movwf    v___data_44
;   69    while ! PIR1_TXIF loop end loop
l__l390
                               btfss    v_pir1, 4 ; pir1_txif
                               goto     l__l390
l__l391
;   71    TXREG = data
                               movf     v___data_44,w
                               movwf    v_txreg
;   72 end procedure
                               return   
;  146 procedure serial_hw_data'put(byte in data) is
l__serial_hw_data_put
                               datalo_clr v__pic_temp
                               movf     v__pic_temp,w
                               movwf    v___data_52
;  147    serial_hw_write(data)
                               movf     v___data_52,w
                               goto     l_serial_hw_write
;  148 end procedure
;  175 end function
l__l428
; tank.jal
;   29 serial_hw_init()
                               call     l_serial_hw_init
;   32 pin_ccp1_direction = output
                               datalo_set v_trisc ; pin_c2_direction
                               bcf      v_trisc, 2 ; pin_c2_direction
;   33 pin_ccp2_direction = output
                               bcf      v_trisc, 1 ; pin_c1_direction
; c:\jallib\include\peripheral\pwm/pwm_common.jal
;   23 var volatile word _pr2_shadow_plus1 = 256           -- value(PR2) + 1
                               datalo_clr v__pr2_shadow_plus1
                               clrf     v__pr2_shadow_plus1
                               movlw    1
                               movwf    v__pr2_shadow_plus1+1
;   50 procedure pwm_max_resolution(byte in prescaler) is
                               goto     l__l436
l_pwm_max_resolution
                               movwf    v___prescaler_1
;   52    _pr2_shadow_plus1 = 256                      -- for maximum resolution
                               clrf     v__pr2_shadow_plus1
                               movlw    1
                               movwf    v__pr2_shadow_plus1+1
;   53    PR2 = byte(_pr2_shadow_plus1 - 1)            -- set PR2
                               decf     v__pr2_shadow_plus1,w
                               datalo_set v_pr2
                               movwf    v_pr2
;   56    if prescaler == 1 then
                               movlw    1
                               datalo_clr v___prescaler_1
                               subwf    v___prescaler_1,w
                               btfss    v__status, v__z
                               goto     l__l433
;   57       T2CON_T2CKPS = 0b00                       -- prescaler 1:1
                               movlw    252
                               andwf    v_t2con,f
;   58       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on
;   59    elsif prescaler == 4  then
                               return   
l__l433
                               movlw    4
                               subwf    v___prescaler_1,w
                               btfss    v__status, v__z
                               goto     l__l434
;   60       T2CON_T2CKPS = 0b01                       -- prescaler 1:4
                               movlw    252
                               andwf    v_t2con,w
                               iorlw    1
                               movwf    v_t2con
;   61       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on
;   62    elsif prescaler == 16 then
                               return   
l__l434
                               movlw    16
                               subwf    v___prescaler_1,w
                               btfss    v__status, v__z
                               goto     l__l435
;   63       T2CON_T2CKPS = 0b10                       -- prescaler 1:16
                               movlw    252
                               andwf    v_t2con,w
                               iorlw    2
                               movwf    v_t2con
;   64       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on
;   65    else
                               return   
l__l435
;   66       T2CON_TMR2ON = FALSE                      -- disable Timer2 (= PWM off!)
                               bcf      v_t2con, 2 ; t2con_tmr2on
;   67    end if
l__l432
;   69 end procedure
                               return   
;  105 end procedure
l__l436
; c:\jallib\include\peripheral\pwm/pwm_ccp1.jal
;   23 var byte  _ccpr1l_shadow  = 0                            -- 8 MSbits of duty cycle
                               clrf     v__ccpr1l_shadow
;   24 var byte  _ccp1con_shadow = 0b0000_0000                  -- shadow
                               clrf     v__ccp1con_shadow
;   32 procedure pwm1_on() is
                               goto     l__l443
l_pwm1_on
;   34    _ccp1con_shadow_ccp1m = 0b1100                    -- set PWM mode
                               movlw    240
                               datalo_clr v__ccp1con_shadow
                               andwf    v__ccp1con_shadow,w
                               iorlw    12
                               movwf    v__ccp1con_shadow
;   35    CCPR1L                = _ccpr1l_shadow            -- restore duty cycle
                               movf     v__ccpr1l_shadow,w
                               movwf    v_ccpr1l
;   36    CCP1CON               = _ccp1con_shadow           -- activate CCP module
                               movf     v__ccp1con_shadow,w
                               movwf    v_ccp1con
;   38 end procedure
                               return   
;   57 procedure pwm1_set_dutycycle_highres(word in duty) is
l_pwm1_set_dutycycle_highres
;   59    if (duty > 1023) then                            -- upper limit
                               movlw    3
                               subwf    v___duty_1+1,w
                               btfss    v__status, v__z
                               goto     l__l880
                               movlw    255
                               subwf    v___duty_1,w
l__l880
                               btfsc    v__status, v__z
                               goto     l__l452
                               btfss    v__status, v__c
                               goto     l__l452
;   60       duty = 1023
                               movlw    255
                               movwf    v___duty_1
                               movlw    3
                               movwf    v___duty_1+1
;   61    end if
l__l452
;   62    _ccpr1l_shadow = byte(duty >> 2)
                               bcf      v__status, v__c
                               rrf      v___duty_1+1,w
                               movwf    v__pic_temp+1
                               rrf      v___duty_1,w
                               movwf    v__pic_temp
                               bcf      v__status, v__c
                               rrf      v__pic_temp+1,f
                               rrf      v__pic_temp,f
                               movf     v__pic_temp,w
                               movwf    v__ccpr1l_shadow
;   63    _ccp1con_shadow_dc1b = byte(duty) & 0b11
                               movlw    3
                               andwf    v___duty_1,w
                               movwf    v__pic_temp
                               swapf    v__pic_temp,w
                               movwf    v__pic_temp+1
                               movlw    48
                               andwf    v__pic_temp+1,f
                               movlw    207
                               andwf    v__ccp1con_shadow,w
                               iorwf    v__pic_temp+1,w
                               movwf    v__ccp1con_shadow
;   65    pwm1_on()                                        -- activate PWM
                               goto     l_pwm1_on
;   67 end procedure
;   98 procedure pwm1_set_dutycycle(byte in duty) is
l_pwm1_set_dutycycle
                               movwf    v___duty_5
;  100    pwm1_set_dutycycle_highres(word(duty) << 2)
                               movf     v___duty_5,w
                               movwf    v____temp_58
                               clrf     v____temp_58+1
                               bcf      v__status, v__c
                               rlf      v____temp_58,w
                               movwf    v____temp_58+2
                               rlf      v____temp_58+1,w
                               movwf    v____temp_58+3
                               bcf      v__status, v__c
                               rlf      v____temp_58+2,f
                               rlf      v____temp_58+3,f
                               movf     v____temp_58+2,w
                               movwf    v___duty_1
                               movf     v____temp_58+3,w
                               movwf    v___duty_1+1
                               goto     l_pwm1_set_dutycycle_highres
;  102 end procedure
; c:\jallib\include\peripheral\pwm/pwm_hardware.jal
;   51 end if
l__l443
; c:\jallib\include\peripheral\pwm/pwm_ccp2.jal
;   23 var byte  _ccpr2l_shadow  = 0                            -- 8 MSbits of duty cycle
                               clrf     v__ccpr2l_shadow
;   24 var byte  _ccp2con_shadow = 0b0000_0000                  -- shadow
                               clrf     v__ccp2con_shadow
;   32 procedure pwm2_on() is
                               goto     l__l462
l_pwm2_on
;   34    _ccp2con_shadow_ccp2m = 0b1100                    -- set PWM mode
                               movlw    240
                               datalo_clr v__ccp2con_shadow
                               andwf    v__ccp2con_shadow,w
                               iorlw    12
                               movwf    v__ccp2con_shadow
;   35    CCPR2L                = _ccpr2l_shadow            -- restore duty cycle
                               movf     v__ccpr2l_shadow,w
                               movwf    v_ccpr2l
;   36    CCP2CON               = _ccp2con_shadow           -- activate CCP module
                               movf     v__ccp2con_shadow,w
                               movwf    v_ccp2con
;   38 end procedure
                               return   
;   57 procedure pwm2_set_dutycycle_highres(word in duty) is
l_pwm2_set_dutycycle_highres
;   59    if (duty > 1023) then                            -- upper limit
                               movlw    3
                               subwf    v___duty_8+1,w
                               btfss    v__status, v__z
                               goto     l__l882
                               movlw    255
                               subwf    v___duty_8,w
l__l882
                               btfsc    v__status, v__z
                               goto     l__l471
                               btfss    v__status, v__c
                               goto     l__l471
;   60       duty = 1023
                               movlw    255
                               movwf    v___duty_8
                               movlw    3
                               movwf    v___duty_8+1
;   61    end if
l__l471
;   62    _ccpr2l_shadow = byte(duty >> 2)
                               bcf      v__status, v__c
                               rrf      v___duty_8+1,w
                               movwf    v__pic_temp+1
                               rrf      v___duty_8,w
                               movwf    v__pic_temp
                               bcf      v__status, v__c
                               rrf      v__pic_temp+1,f
                               rrf      v__pic_temp,f
                               movf     v__pic_temp,w
                               movwf    v__ccpr2l_shadow
;   63    _ccp2con_shadow_dc2b = byte(duty) & 0b11
                               movlw    3
                               andwf    v___duty_8,w
                               movwf    v__pic_temp
                               swapf    v__pic_temp,w
                               movwf    v__pic_temp+1
                               movlw    48
                               andwf    v__pic_temp+1,f
                               movlw    207
                               andwf    v__ccp2con_shadow,w
                               iorwf    v__pic_temp+1,w
                               movwf    v__ccp2con_shadow
;   65    pwm2_on()                                        -- activate PWM
                               goto     l_pwm2_on
;   67 end procedure
;   98 procedure pwm2_set_dutycycle(byte in duty) is
l_pwm2_set_dutycycle
                               movwf    v___duty_12
;  100    pwm2_set_dutycycle_highres(word(duty) << 2)
                               movf     v___duty_12,w
                               movwf    v____temp_62
                               clrf     v____temp_62+1
                               bcf      v__status, v__c
                               rlf      v____temp_62,w
                               movwf    v____temp_62+2
                               rlf      v____temp_62+1,w
                               movwf    v____temp_62+3
                               bcf      v__status, v__c
                               rlf      v____temp_62+2,f
                               rlf      v____temp_62+3,f
                               movf     v____temp_62+2,w
                               movwf    v___duty_8
                               movf     v____temp_62+3,w
                               movwf    v___duty_8+1
                               goto     l_pwm2_set_dutycycle_highres
;  102 end procedure
; c:\jallib\include\peripheral\pwm/pwm_hardware.jal
;   55 end if
l__l462
; tank.jal
;   35 pwm_max_resolution(16)
                               movlw    16
                               call     l_pwm_max_resolution
;   36 pwm1_on()
                               call     l_pwm1_on
;   37 pwm2_on()
                               call     l_pwm2_on
; c:\jallib\include\peripheral\timer/timer0_isr_interval.jal
;   52 function isr_counter'get() return word is
                               goto     l__l513
l__isr_counter_get
;   55    INTCON_TMR0IE = off
                               bcf      v_intcon, 5 ; intcon_tmr0ie
;   56    temp = internal_isr_counter
                               datalo_clr v_internal_isr_counter
                               movf     v_internal_isr_counter,w
                               movwf    v_temp
                               movf     v_internal_isr_counter+1,w
                               movwf    v_temp+1
;   57    INTCON_TMR0IE = on
                               bsf      v_intcon, 5 ; intcon_tmr0ie
;   59    return temp
                               movf     v_temp,w
                               movwf    v__pic_temp
                               movf     v_temp+1,w
                               movwf    v__pic_temp+1
;   60 end function
                               return   
;   62 procedure set_delay(byte in slot, word in ticks) is
l_set_delay
                               movwf    v___slot_1
;   64    if (slot >= DELAY_SLOTS) then return end if
                               movlw    2
                               subwf    v___slot_1,w
                               btfsc    v__status, v__z
                               goto     l__l885
                               btfss    v__status, v__c
                               goto     l__l494
l__l885
                               return   
l__l494
;   66    INTCON_TMR0IE = off
                               bcf      v_intcon, 5 ; intcon_tmr0ie
;   67    isr_countdown[slot] = ticks
                               bcf      v__status, v__c
                               rlf      v___slot_1,w
                               movwf    v____temp_64
                               movlw    v_isr_countdown
                               addwf    v____temp_64,w
                               movwf    v__fsr
                               irp_clr  
                               movf     v___ticks_1,w
                               movwf    v__ind
                               incf     v__fsr,f
                               movf     v___ticks_1+1,w
                               movwf    v__ind
;   68    INTCON_TMR0IE = on
                               bsf      v_intcon, 5 ; intcon_tmr0ie
;   70 end procedure
l__l492
                               return   
;   72 function check_delay(byte in slot) return bit is
l_check_delay
                               movwf    v___slot_3
;   74    if (slot >= DELAY_SLOTS) then return true end if
                               movlw    2
                               subwf    v___slot_3,w
                               btfsc    v__status, v__z
                               goto     l__l887
                               btfss    v__status, v__c
                               goto     l__l498
l__l887
                               bsf      v__pic_temp, 0 ; _pic_temp
                               return   
l__l498
;   76    if (isr_countdown[slot] == 0) then
                               bcf      v__status, v__c
                               rlf      v___slot_3,w
                               movwf    v____temp_65
                               movlw    v_isr_countdown
                               addwf    v____temp_65,w
                               movwf    v__fsr
                               irp_clr  
                               movf     v__ind,w
                               incf     v__fsr,f
                               iorwf    v__ind,w
                               btfss    v__status, v__z
                               goto     l__l500
;   77       if (isr_countdown[slot] == 0) then
                               bcf      v__status, v__c
                               rlf      v___slot_3,w
                               movwf    v____temp_65+1
                               movlw    v_isr_countdown
                               addwf    v____temp_65+1,w
                               movwf    v__fsr
                               irp_clr  
                               movf     v__ind,w
                               incf     v__fsr,f
                               iorwf    v__ind,w
                               btfss    v__status, v__z
                               goto     l__l499
;   80          return true    -- delay passed
                               bsf      v__pic_temp, 0 ; _pic_temp
                               return   
;   82    end if
l__l500
l__l499
;   84    return false -- still waiting
                               bcf      v__pic_temp, 0 ; _pic_temp
;   86 end function
l__l496
                               return   
;   88 procedure timer0_isr_init() is
l_timer0_isr_init
;  108       OPTION_REG_PS = 4 ; prescaler 32
                               movlw    248
                               datalo_set v_option_reg
                               andwf    v_option_reg,w
                               iorlw    4
                               movwf    v_option_reg
;  109       timer0_load = 255 - byte(timer0_div / 32)
                               movlw    99
                               datalo_clr v_timer0_load
                               movwf    v_timer0_load
;  128    OPTION_REG_T0CS = 0  ; internal clock
                               datalo_set v_option_reg ; option_reg_t0cs
                               bcf      v_option_reg, 5 ; option_reg_t0cs
;  129    OPTION_REG_PSA  = 0  ; assign prescaler to timer0
                               bcf      v_option_reg, 3 ; option_reg_psa
;  131    INTCON_TMR0IF = off
                               bcf      v_intcon, 2 ; intcon_tmr0if
;  132    INTCON_TMR0IE = on
                               bsf      v_intcon, 5 ; intcon_tmr0ie
;  133    INTCON_GIE  = on    ; enable global interrupts
                               bsf      v_intcon, 7 ; intcon_gie
;  134    INTCON_PEIE = on
                               bsf      v_intcon, 6 ; intcon_peie
;  137    for DELAY_SLOTS using i loop
                               datalo_clr v___i_1
                               clrf     v___i_1
l__l510
;  138       isr_countdown[i] = 0
                               bcf      v__status, v__c
                               rlf      v___i_1,w
                               movwf    v____temp_66
                               movlw    v_isr_countdown
                               addwf    v____temp_66,w
                               movwf    v__fsr
                               irp_clr  
                               clrf     v__ind
                               incf     v__fsr,f
                               clrf     v__ind
;  139    end loop
                               incf     v___i_1,f
                               movlw    2
                               subwf    v___i_1,w
                               btfss    v__status, v__z
                               goto     l__l510
;  142 end procedure
                               return   
;  144 procedure ISR() is
l_isr
;  147    if INTCON_TMR0IF == true then
                               btfss    v_intcon, 2 ; intcon_tmr0if
                               goto     l__l516
;  148       tmr0 = timer0_load
                               movf     v_timer0_load,w
                               movwf    v_tmr0
;  151       internal_isr_counter = internal_isr_counter + 1
                               incf     v_internal_isr_counter,f
                               btfsc    v__status, v__z
                               incf     v_internal_isr_counter+1,f
;  154       for DELAY_SLOTS using index loop
                               clrf     v_index
l__l517
;  155          if (isr_countdown[index] != 0) then
                               bcf      v__status, v__c
                               rlf      v_index,w
                               movwf    v____temp_67
                               movlw    v_isr_countdown
                               addwf    v____temp_67,w
                               movwf    v__fsr
                               irp_clr  
                               movf     v__ind,w
                               incf     v__fsr,f
                               iorwf    v__ind,w
                               btfsc    v__status, v__z
                               goto     l__l521
;  156             isr_countdown[index] = isr_countdown[index] - 1
                               bcf      v__status, v__c
                               rlf      v_index,w
                               movwf    v____temp_67+1
                               bcf      v__status, v__c
                               rlf      v_index,w
                               movwf    v____temp_67+2
                               movlw    v_isr_countdown
                               addwf    v____temp_67+2,w
                               movwf    v__fsr
                               irp_clr  
                               movf     v__ind,w
                               movwf    v__pic_temp
                               incf     v__fsr,f
                               movf     v__ind,w
                               movwf    v__pic_temp+1
                               movlw    v_isr_countdown+1
                               addwf    v____temp_67+1,w
                               movwf    v__fsr
                               irp_clr  
                               movf     v__pic_temp+1,w
                               movwf    v__ind
                               decf     v__fsr,f
                               movlw    1
                               subwf    v__pic_temp,w
                               movwf    v__ind
                               movlw    1
                               incf     v__fsr,f
                               btfss    v__status, v__c
                               subwf    v__ind,f
;  157          end if
l__l521
;  158       end loop
                               incf     v_index,f
                               movlw    2
                               subwf    v_index,w
                               btfss    v__status, v__z
                               goto     l__l517
;  165       INTCON_TMR0IF = off
                               bcf      v_intcon, 2 ; intcon_tmr0if
;  167    end if
l__l516
;  169 end procedure
                               movf     v__pic_isr_state,w
                               movwf    v__pic_state
                               movf     v__pic_isr_state+1,w
                               movwf    v__pic_state+1
                               movf     v__pic_isr_fsr,w
                               movwf    v__fsr
                               movf     v__pic_isr_pclath,w
                               movwf    v__pclath
                               swapf    v__pic_isr_status,w
                               movwf    v__status
                               swapf    v__pic_isr_w,f
                               swapf    v__pic_isr_w,w
                               retfie   
l__l513
; tank.jal
;   43 timer0_isr_init()             -- init timer0 isr
                               call     l_timer0_isr_init
; c:\jallib\include\peripheral\adc/adc_channels.jal
;  132    _debug "ADC channels config: dependent pins, via PCFG bits"
;  134    procedure _adc_setup_pins() is
                               goto     l__l597
; 2432    procedure _adc_vref() is
l__adc_vref
; 2433    end procedure
                               return   
; c:\jallib\include\peripheral\adc/adc_clock.jal
;   31 function _adc_eval_tad(word in factor) return bit is
l__adc_eval_tad
;   42    var bit tad_ok = false
                               bcf      v____bitbucket_10, 0 ; tad_ok
;   43    tad_value = byte((factor * 10) / (target_clock / 1_000_000))
                               movf     v___factor_1,w
                               movwf    v__pic_multiplier
                               movf     v___factor_1+1,w
                               movwf    v__pic_multiplier+1
                               movlw    10
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               movwf    v____temp_68
                               movf     v__pic_mresult+1,w
                               movwf    v____temp_68+1
                               movlw    20
                               movwf    v__pic_divisor
                               clrf     v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               movf     v____temp_68,w
                               movwf    v__pic_dividend
                               movf     v____temp_68+1,w
                               movwf    v__pic_dividend+1
                               clrf     v__pic_dividend+2
                               clrf     v__pic_dividend+3
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               movwf    v_tad_value
;   44    if tad_value >= ADC_MIN_TAD & tad_value < ADC_MAX_TAD then
                               movlw    16
                               subwf    v_tad_value,w
                               bcf      v____bitbucket_10, 1 ; _btemp54
                               btfss    v__status, v__z
                               btfsc    v__status, v__c
                               bsf      v____bitbucket_10, 1 ; _btemp54
                               movlw    60
                               subwf    v_tad_value,w
                               bcf      v____bitbucket_10, 2 ; _btemp55
                               btfsc    v__status, v__z
                               goto     l__l890
                               btfss    v__status, v__c
                               bsf      v____bitbucket_10, 2 ; _btemp55
l__l890
                               bsf      v____bitbucket_10, 3 ; _btemp56
                               btfsc    v____bitbucket_10, 1 ; _btemp54
                               btfss    v____bitbucket_10, 2 ; _btemp55
                               bcf      v____bitbucket_10, 3 ; _btemp56
                               btfsc    v____bitbucket_10, 3 ; _btemp56
;   45 	  tad_ok = true
                               bsf      v____bitbucket_10, 0 ; tad_ok
;   46    end if
l__l580
;   47    return tad_ok
                               bcf      v__pic_temp, 0 ; _pic_temp
                               btfsc    v____bitbucket_10, 0 ; tad_ok
                               bsf      v__pic_temp, 0 ; _pic_temp
;   48 end function
                               return   
; c:\jallib\include\peripheral\adc/adc.jal
;   55 end if
l__l597
;   72 var volatile byte _adcon0_shadow = 0
                               datalo_clr v__adcon0_shadow
                               clrf     v__adcon0_shadow
;   77 procedure _adc_read_low_res(byte in adc_chan, byte out adc_byte) is
                               goto     l__l730
l__adc_read_low_res
                               movwf    v___adc_chan_1
;   79    ADCON0_CHS = adc_chan
                               rlf      v___adc_chan_1,w
                               movwf    v__pic_temp
                               rlf      v__pic_temp,f
                               rlf      v__pic_temp,f
                               movlw    56
                               andwf    v__pic_temp,f
                               movlw    199
                               andwf    v_adcon0,w
                               iorwf    v__pic_temp,w
                               movwf    v_adcon0
;   80    ADCON0_ADON = true                -- turn on ADC module
                               bsf      v_adcon0, 0 ; adcon0_adon
;   81    delay_10us(adc_conversion_delay)  -- wait acquisition time
                               movf     v_adc_conversion_delay,w
                               call     l_delay_10us
;   82    ADCON0_GO = true                  -- start conversion
                               datalo_clr v_adcon0 ; adcon0_go
                               bsf      v_adcon0, 2 ; adcon0_go
;   83    while ADCON0_GO loop end loop     -- wait till conversion finished
l__l603
                               btfsc    v_adcon0, 2 ; adcon0_go
                               goto     l__l603
l__l604
;   90       adc_byte = ADRESH                  -- read high byte 
                               movf     v_adresh,w
                               movwf    v___adc_byte_1
;   98    if tad_value >= (ADC_MAX_TAD + ADC_MIN_TAD) / 2 then
                               movlw    38
                               subwf    v_tad_value,w
                               btfsc    v__status, v__z
                               goto     l__l894
                               btfss    v__status, v__c
                               goto     l__l609
l__l894
;   99       _usec_delay(2 * ADC_MAX_TAD)
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    198
                               movwf    v__pic_temp
                               branchhi_clr l__l895
                               branchlo_clr l__l895
l__l895
                               decfsz   v__pic_temp,f
                               goto     l__l895
                               nop      
;  100    else
                               goto     l__l608
l__l609
;  101       _usec_delay(2 * ADC_MIN_TAD)
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    51
                               movwf    v__pic_temp
                               branchhi_clr l__l896
                               branchlo_clr l__l896
l__l896
                               decfsz   v__pic_temp,f
                               goto     l__l896
                               nop      
                               nop      
;  102    end if
l__l608
;  103    ADCON0_ADON = false               -- turn off ADC module
                               bcf      v_adcon0, 0 ; adcon0_adon
;  104 end procedure
                               movf     v___adc_byte_1,w
                               return   
;  110 function adc_read(byte in adc_chan) return word is
l_adc_read
                               datalo_clr v___adc_chan_3
                               movwf    v___adc_chan_3
;  115       _adc_read_low_res(adc_chan,ax[1])   -- do conversion and get high byte  
                               movf     v___adc_chan_3,w
                               call     l__adc_read_low_res
                               datalo_clr v_ax+1
                               movwf    v_ax+1
;  116       ax[0] = ADRESL                       -- get low byte
                               datalo_set v_adresl
                               movf     v_adresl,w
                               datalo_clr v_ax
                               movwf    v_ax
;  125    return ad_value
                               movf     v_ad_value,w
                               movwf    v__pic_temp
                               movf     v_ad_value+1,w
                               movwf    v__pic_temp+1
;  126 end function
                               return   
;  266    end if
l__l730
; tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_channels.jal
;  982          var bit*4 no_vref = 0
                               movlw    225
                               andwf    v__bitbucket+1,f
;  991             asm nop
                               nop      
; 2411          no_vref = ADC_PCFG_MAP[idx]
                               movlw    225
                               andwf    v__bitbucket+1,f
; 2412          ADCON1_PCFG = no_vref
                               rrf      v__bitbucket+1,w
                               movwf    v__pic_temp+2
                               rrf      v__bitbucket,w
                               movwf    v__pic_temp+1
                               movf     v__pic_temp+1,w
                               movwf    v__pic_temp
                               movlw    15
                               andwf    v__pic_temp,f
                               movlw    15
                               andwf    v__pic_temp,w
                               movwf    v__pic_temp+1
                               movlw    240
                               datalo_set v_adcon1
                               andwf    v_adcon1,w
                               datalo_clr v__pic_temp+1
                               iorwf    v__pic_temp+1,w
                               datalo_set v_adcon1
                               movwf    v_adcon1
; tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc.jal
;  253    _adc_setup_pins()    -- conditionally defined according to PIC
;  254    _adc_vref()          -- conditionally defined according to PIC
; tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc.jal
;  267    _adc_setup()
                               bsf      v_adcon1, 7 ; adcon1_adfm
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  116    var volatile bit*3 adcs = 0b_000
                               movlw    241
                               datalo_clr v__bitbucket
                               andwf    v__bitbucket+1,f
;  135 	  if _adc_eval_tad(32) == true then
                               movlw    32
                               movwf    v___factor_1
                               clrf     v___factor_1+1
                               call     l__adc_eval_tad
                               datalo_clr v__bitbucket+1 ; _btemp572
                               bcf      v__bitbucket+1, 4 ; _btemp572
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v__bitbucket+1, 4 ; _btemp572
                               btfss    v__bitbucket+1, 4 ; _btemp572
                               goto     l__l779
; tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  136 		 adcs = 0b_010
                               movlw    241
                               andwf    v__bitbucket+1,w
                               iorlw    4
                               movwf    v__bitbucket+1
; tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  137 	  elsif _adc_eval_tad(8) == true then
                               goto     l__l782
l__l779
                               movlw    8
                               movwf    v___factor_1
                               clrf     v___factor_1+1
                               call     l__adc_eval_tad
                               datalo_clr v__bitbucket+1 ; _btemp592
                               bcf      v__bitbucket+1, 6 ; _btemp592
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v__bitbucket+1, 6 ; _btemp592
                               btfss    v__bitbucket+1, 6 ; _btemp592
                               goto     l__l780
; tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  138 		 adcs = 0b_001
                               movlw    241
                               andwf    v__bitbucket+1,w
                               iorlw    2
                               movwf    v__bitbucket+1
; tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  139 	  elsif _adc_eval_tad(2) == true then
                               goto     l__l782
l__l780
                               movlw    2
                               movwf    v___factor_1
                               clrf     v___factor_1+1
                               call     l__adc_eval_tad
                               datalo_clr v__bitbucket+2 ; _btemp612
                               bcf      v__bitbucket+2, 0 ; _btemp612
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v__bitbucket+2, 0 ; _btemp612
                               btfss    v__bitbucket+2, 0 ; _btemp612
                               goto     l__l781
; tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc_clock.jal
;  140 		 adcs = 0b_000
                               movlw    241
                               andwf    v__bitbucket+1,f
;  141 	  end if
l__l781
l__l782
;  154 	  jallib_adcs_lsb = adcs_lsb
                               rrf      v__bitbucket+1,w
                               movwf    v__pic_temp+2
                               rrf      v__bitbucket,w
                               movwf    v__pic_temp+1
                               movf     v__pic_temp+1,w
                               movwf    v__pic_temp
                               movlw    3
                               andwf    v__pic_temp,f
                               rrf      v__pic_temp,w
                               movwf    v__pic_temp+1
                               rrf      v__pic_temp+1,f
                               rrf      v__pic_temp+1,w
                               movwf    v__pic_temp+1
                               movlw    192
                               andwf    v__pic_temp+1,f
                               movlw    63
                               andwf    v_adcon0,w
                               iorwf    v__pic_temp+1,w
                               movwf    v_adcon0
; tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc.jal
;  270    _adc_init_clock()
; tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc.jal
;  243    adc_conversion_delay = 2 + adc_tc + adc_tcoff   -- Tamp seems to be a constant: 2usecs
                               movlw    21
                               movwf    v_adc_conversion_delay
; tank.jal
;   50 adc_init()
; c:\jallib\include\peripheral\adc/adc.jal
;  271    _adc_init_acquisition_delay()
; tank.jal
;   50 adc_init()
;   54 var byte PwmL        = 0 ; pwm setpoint
                               clrf     v_pwml
;   55 var byte PwmR        = 0 ; pwm setpoint
                               clrf     v_pwmr
;   56 var bit MotorL_fwd   = true
                               bsf      v__bitbucket, 0 ; motorl_fwd
;   57 var bit MotorR_fwd   = true
                               bsf      v__bitbucket, 1 ; motorr_fwd
;   65 PORTD_low_direction = all_output
; c:\jallib\include\device/16f877.jal
;  851    TRISD = (TRISD & 0xF0) | (x & 0x0F)
                               movlw    240
                               datalo_set v_trisd
                               andwf    v_trisd,w
                               datalo_clr v____temp_71
                               movwf    v____temp_71
                               clrf     v____temp_71+1
                               movf     v____temp_71+1,w
                               iorwf    v____temp_71,w
                               datalo_set v_trisd
                               movwf    v_trisd
; tank.jal
;   65 PORTD_low_direction = all_output
;   73 forever loop       
l__l791
;   79    if (isr_counter != prev_isr_counter) then
                               call     l__isr_counter_get
                               datalo_clr v__pic_temp
                               movf     v__pic_temp,w
                               movwf    v____temp_72
                               movf     v__pic_temp+1,w
                               movwf    v____temp_72+1
                               movf     v____temp_72,w
                               subwf    v_prev_isr_counter,w
                               movwf    v__pic_temp
                               movf     v____temp_72+1,w
                               subwf    v_prev_isr_counter+1,w
                               iorwf    v__pic_temp,w
                               btfsc    v__status, v__z
                               goto     l__l794
;   80       prev_isr_counter = isr_counter
                               call     l__isr_counter_get
                               datalo_clr v__pic_temp
                               movf     v__pic_temp,w
                               movwf    v_prev_isr_counter
                               movf     v__pic_temp+1,w
                               movwf    v_prev_isr_counter+1
;   86    end if ; 1 kHz loop   
l__l794
;   88    if (check_delay(0)) then
                               movlw    0
                               call     l_check_delay
                               datalo_clr v__bitbucket ; _btemp65
                               bcf      v__bitbucket, 3 ; _btemp65
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v__bitbucket, 3 ; _btemp65
                               btfss    v__bitbucket, 3 ; _btemp65
                               goto     l__l791
;   89       set_delay(0, 100) --  20 ticks on delay-slot 0
                               movlw    100
                               movwf    v___ticks_1
                               clrf     v___ticks_1+1
                               movlw    0
                               call     l_set_delay
;   95       LeftEye  = 30000 / adc_read(0)
                               movlw    0
                               call     l_adc_read
                               datalo_clr v__pic_temp
                               movf     v__pic_temp,w
                               movwf    v____temp_72
                               movf     v__pic_temp+1,w
                               movwf    v____temp_72+1
                               movf     v____temp_72,w
                               movwf    v__pic_divisor
                               movf     v____temp_72+1,w
                               movwf    v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               movlw    48
                               movwf    v__pic_dividend
                               movlw    117
                               movwf    v__pic_dividend+1
                               clrf     v__pic_dividend+2
                               clrf     v__pic_dividend+3
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               movwf    v_lefteye
                               movf     v__pic_quotient+1,w
                               movwf    v_lefteye+1
;   96       RightEye = 30000 / adc_read(1)      
                               movlw    1
                               call     l_adc_read
                               datalo_clr v__pic_temp
                               movf     v__pic_temp,w
                               movwf    v____temp_72
                               movf     v__pic_temp+1,w
                               movwf    v____temp_72+1
                               movf     v____temp_72,w
                               movwf    v__pic_divisor
                               movf     v____temp_72+1,w
                               movwf    v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               movlw    48
                               movwf    v__pic_dividend
                               movlw    117
                               movwf    v__pic_dividend+1
                               clrf     v__pic_dividend+2
                               clrf     v__pic_dividend+3
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               movwf    v_righteye
                               movf     v__pic_quotient+1,w
                               movwf    v_righteye+1
;   99       if (RightEye > 200) then
                               movlw    0
                               subwf    v_righteye+1,w
                               btfss    v__status, v__z
                               goto     l__l897
                               movlw    200
                               subwf    v_righteye,w
l__l897
                               btfsc    v__status, v__z
                               goto     l__l798
                               btfss    v__status, v__c
                               goto     l__l798
;  101          temp = LeftEye
                               movf     v_lefteye,w
                               movwf    v___temp_1
                               movf     v_lefteye+1,w
                               movwf    v___temp_1+1
;  102          if (temp > 255) then temp = 255 end if
                               movlw    0
                               subwf    v___temp_1+1,w
                               btfss    v__status, v__z
                               goto     l__l899
                               movlw    255
                               subwf    v___temp_1,w
l__l899
                               btfsc    v__status, v__z
                               goto     l__l800
                               btfss    v__status, v__c
                               goto     l__l800
                               movlw    255
                               movwf    v___temp_1
                               clrf     v___temp_1+1
l__l800
;  104          if (temp > 127) then 
                               movlw    0
                               subwf    v___temp_1+1,w
                               btfss    v__status, v__z
                               goto     l__l901
                               movlw    127
                               subwf    v___temp_1,w
l__l901
                               btfsc    v__status, v__z
                               goto     l__l797
                               btfss    v__status, v__c
                               goto     l__l797
;  111       else  
                               goto     l__l797
l__l798
;  112          PwmL = 0
                               clrf     v_pwml
;  113          PwmR = 0
                               clrf     v_pwmr
;  114       end if
l__l797
;  118 		MotorH1 = MotorL_fwd
                               bcf      v__portd_shadow, 1 ; x116
                               btfsc    v__bitbucket, 0 ; motorl_fwd
                               bsf      v__portd_shadow, 1 ; x116
; c:\jallib\include\device/16f877.jal
;  408    PORTD = _PORTD_shadow
                               movf     v__portd_shadow,w
                               movwf    v_portd
; tank.jal
;  118 		MotorH1 = MotorL_fwd
; c:\jallib\include\device/16f877.jal
;  496    _PORTD_flush()
; tank.jal
;  118 		MotorH1 = MotorL_fwd
;  119 		MotorH2 = !MotorH1
                               btfss    v_portd, 1 ; pin_d1
                               goto     l__l904
                               bcf      v__bitbucket, 7 ; _btemp69
                               goto     l__l903
l__l904
                               bsf      v__bitbucket, 7 ; _btemp69
l__l903
                               bcf      v__portd_shadow, 0 ; x117
                               btfsc    v__bitbucket, 7 ; _btemp69
                               bsf      v__portd_shadow, 0 ; x117
; c:\jallib\include\device/16f877.jal
;  408    PORTD = _PORTD_shadow
                               movf     v__portd_shadow,w
                               movwf    v_portd
; tank.jal
;  119 		MotorH2 = !MotorH1
; c:\jallib\include\device/16f877.jal
;  505    _PORTD_flush()
; tank.jal
;  119 		MotorH2 = !MotorH1
;  120       pwm1_set_dutycycle(PwmL)	
                               movf     v_pwml,w
                               call     l_pwm1_set_dutycycle
;  122 		MotorH3 = MotorR_fwd
                               datalo_clr v__portd_shadow ; x118
                               bcf      v__portd_shadow, 2 ; x118
                               btfsc    v__bitbucket, 1 ; motorr_fwd
                               bsf      v__portd_shadow, 2 ; x118
; c:\jallib\include\device/16f877.jal
;  408    PORTD = _PORTD_shadow
                               movf     v__portd_shadow,w
                               movwf    v_portd
; tank.jal
;  122 		MotorH3 = MotorR_fwd
; c:\jallib\include\device/16f877.jal
;  487    _PORTD_flush()
; tank.jal
;  122 		MotorH3 = MotorR_fwd
;  123 		MotorH4 = !MotorH3
                               btfss    v_portd, 2 ; pin_d2
                               goto     l__l906
                               bcf      v__bitbucket+1, 0 ; _btemp70
                               goto     l__l905
l__l906
                               bsf      v__bitbucket+1, 0 ; _btemp70
l__l905
                               bcf      v__portd_shadow, 3 ; x119
                               btfsc    v__bitbucket+1, 0 ; _btemp70
                               bsf      v__portd_shadow, 3 ; x119
; c:\jallib\include\device/16f877.jal
;  408    PORTD = _PORTD_shadow
                               movf     v__portd_shadow,w
                               movwf    v_portd
; tank.jal
;  123 		MotorH4 = !MotorH3
; c:\jallib\include\device/16f877.jal
;  478    _PORTD_flush()
; tank.jal
;  123 		MotorH4 = !MotorH3
;  124    	pwm2_set_dutycycle(PwmR)			
                               movf     v_pwmr,w
                               call     l_pwm2_set_dutycycle
;  133       print_word_dec(serial_hw_data, LeftEye)      
                               movlw    l__serial_hw_data_put
                               datalo_clr v____device_put_18
                               movwf    v____device_put_18
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_18+1
                               movf     v_lefteye,w
                               movwf    v___data_36
                               movf     v_lefteye+1,w
                               movwf    v___data_36+1
                               call     l_print_word_dec
;  134       serial_hw_data = " "
                               movlw    32
                               datalo_clr v__pic_temp
                               movwf    v__pic_temp
                               call     l__serial_hw_data_put
;  135       print_word_dec(serial_hw_data, RightEye)      
                               movlw    l__serial_hw_data_put
                               datalo_clr v____device_put_18
                               movwf    v____device_put_18
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_18+1
                               movf     v_righteye,w
                               movwf    v___data_36
                               movf     v_righteye+1,w
                               movwf    v___data_36+1
                               call     l_print_word_dec
;  136       serial_hw_data = 13
                               movlw    13
                               datalo_clr v__pic_temp
                               movwf    v__pic_temp
                               call     l__serial_hw_data_put
;  137       serial_hw_data = 10
                               movlw    10
                               datalo_clr v__pic_temp
                               movwf    v__pic_temp
                               call     l__serial_hw_data_put
;  140 end loop -- fastest & forever loop
                               goto     l__l791
                               end
