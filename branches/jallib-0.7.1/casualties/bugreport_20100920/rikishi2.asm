; compiler: jal 2.4n (compiled Jun  2 2010)

; command line:  C:\jallib\compiler\jalv2.exe -debug rikishi2.jal
; compiler flags:
;    boot-fuse, debug-compiler, debug-codegen, opt-expr-reduce
;    opt-cexpr-reduce, opt-variable-reduce, warn-backend
;    warn-conversion, warn-misc, warn-range, warn-stack-overflow
;    warn-truncate
                                list p=16f876a, r=dec
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
v_on                           EQU 1
v_off                          EQU 0
v_input                        EQU 1
v_output                       EQU 0
v__pic_isr_w                   EQU 0x007f  ; _pic_isr_w
v__ind                         EQU 0x0000  ; _ind
v_tmr0                         EQU 0x0001  ; tmr0
v__pcl                         EQU 0x0002  ; _pcl
v__status                      EQU 0x0003  ; _status
v__irp                         EQU 7
v__z                           EQU 2
v__c                           EQU 0
v__fsr                         EQU 0x0004  ; _fsr
v_porta                        EQU 0x0005  ; porta
v__porta_shadow                EQU 0x0042  ; _porta_shadow
v_portb                        EQU 0x0006  ; portb
v__portb_shadow                EQU 0x0043  ; _portb_shadow
v_pin_b7                       EQU 0x0006  ; pin_b7-->portb:7
v_pin_b5                       EQU 0x0006  ; pin_b5-->portb:5
v_pin_b2                       EQU 0x0006  ; pin_b2-->portb:2
v__pclath                      EQU 0x000a  ; _pclath
v_intcon                       EQU 0x000b  ; intcon
v_intcon_gie                   EQU 0x000b  ; intcon_gie-->intcon:7
v_intcon_peie                  EQU 0x000b  ; intcon_peie-->intcon:6
v_intcon_tmr0ie                EQU 0x000b  ; intcon_tmr0ie-->intcon:5
v_intcon_tmr0if                EQU 0x000b  ; intcon_tmr0if-->intcon:2
v_pir1                         EQU 0x000c  ; pir1
v_pir1_rcif                    EQU 0x000c  ; pir1_rcif-->pir1:5
v_pir1_txif                    EQU 0x000c  ; pir1_txif-->pir1:4
v_pir1_sspif                   EQU 0x000c  ; pir1_sspif-->pir1:3
v_t2con                        EQU 0x0012  ; t2con
v_t2con_tmr2on                 EQU 0x0012  ; t2con_tmr2on-->t2con:2
v_sspbuf                       EQU 0x0013  ; sspbuf
v_sspcon                       EQU 0x0014  ; sspcon
v_sspcon_sspen                 EQU 0x0014  ; sspcon_sspen-->sspcon:5
v_ccpr1l                       EQU 0x0015  ; ccpr1l
v_ccp1con                      EQU 0x0017  ; ccp1con
v_rcsta                        EQU 0x0018  ; rcsta
v_rcsta_cren                   EQU 0x0018  ; rcsta_cren-->rcsta:4
v_rcsta_oerr                   EQU 0x0018  ; rcsta_oerr-->rcsta:1
v_txreg                        EQU 0x0019  ; txreg
v_rcreg                        EQU 0x001a  ; rcreg
v_ccpr2l                       EQU 0x001b  ; ccpr2l
v_ccp2con                      EQU 0x001d  ; ccp2con
v_adresh                       EQU 0x001e  ; adresh
v_adcon0                       EQU 0x001f  ; adcon0
v_adcon0_go                    EQU 0x001f  ; adcon0_go-->adcon0:2
v_adcon0_adon                  EQU 0x001f  ; adcon0_adon-->adcon0:0
v_option_reg                   EQU 0x0081  ; option_reg
v_option_reg_t0cs              EQU 0x0081  ; option_reg_t0cs-->option_reg:5
v_option_reg_psa               EQU 0x0081  ; option_reg_psa-->option_reg:3
v_trisa                        EQU 0x0085  ; trisa
v_pin_a5_direction             EQU 0x0085  ; pin_a5_direction-->trisa:5
v_pin_a4_direction             EQU 0x0085  ; pin_a4_direction-->trisa:4
v_pin_a3_direction             EQU 0x0085  ; pin_a3_direction-->trisa:3
v_pin_a2_direction             EQU 0x0085  ; pin_a2_direction-->trisa:2
v_pin_a1_direction             EQU 0x0085  ; pin_a1_direction-->trisa:1
v_pin_a0_direction             EQU 0x0085  ; pin_a0_direction-->trisa:0
v_trisb                        EQU 0x0086  ; trisb
v_pin_b7_direction             EQU 0x0086  ; pin_b7_direction-->trisb:7
v_pin_b6_direction             EQU 0x0086  ; pin_b6_direction-->trisb:6
v_pin_b5_direction             EQU 0x0086  ; pin_b5_direction-->trisb:5
v_pin_b4_direction             EQU 0x0086  ; pin_b4_direction-->trisb:4
v_pin_b3_direction             EQU 0x0086  ; pin_b3_direction-->trisb:3
v_pin_b2_direction             EQU 0x0086  ; pin_b2_direction-->trisb:2
v_pin_b1_direction             EQU 0x0086  ; pin_b1_direction-->trisb:1
v_trisc                        EQU 0x0087  ; trisc
v_pin_c2_direction             EQU 0x0087  ; pin_c2_direction-->trisc:2
v_pin_c1_direction             EQU 0x0087  ; pin_c1_direction-->trisc:1
v_pie1                         EQU 0x008c  ; pie1
v_pie1_rcie                    EQU 0x008c  ; pie1_rcie-->pie1:5
v_pie1_txie                    EQU 0x008c  ; pie1_txie-->pie1:4
v_sspcon2                      EQU 0x0091  ; sspcon2
v_sspcon2_ackstat              EQU 0x0091  ; sspcon2_ackstat-->sspcon2:6
v_sspcon2_ackdt                EQU 0x0091  ; sspcon2_ackdt-->sspcon2:5
v_sspcon2_acken                EQU 0x0091  ; sspcon2_acken-->sspcon2:4
v_sspcon2_rcen                 EQU 0x0091  ; sspcon2_rcen-->sspcon2:3
v_sspcon2_pen                  EQU 0x0091  ; sspcon2_pen-->sspcon2:2
v_sspcon2_rsen                 EQU 0x0091  ; sspcon2_rsen-->sspcon2:1
v_sspcon2_sen                  EQU 0x0091  ; sspcon2_sen-->sspcon2:0
v_pr2                          EQU 0x0092  ; pr2
v_sspstat                      EQU 0x0094  ; sspstat
v_sspstat_bf                   EQU 0x0094  ; sspstat_bf-->sspstat:0
v_txsta                        EQU 0x0098  ; txsta
v_txsta_txen                   EQU 0x0098  ; txsta_txen-->txsta:5
v_txsta_brgh                   EQU 0x0098  ; txsta_brgh-->txsta:2
v_spbrg                        EQU 0x0099  ; spbrg
v_adresl                       EQU 0x009e  ; adresl
v_adcon1                       EQU 0x009f  ; adcon1
v_adcon1_adfm                  EQU 0x009f  ; adcon1_adfm-->adcon1:7
v_adcon1_adcs2                 EQU 0x009f  ; adcon1_adcs2-->adcon1:6
v_ascii_lf                     EQU 10
v_ascii_cr                     EQU 13
v_print_prefix                 EQU 0x0065  ; print_prefix-->_bitbucket:0
v_tad_value                    EQU 0x0044  ; tad_value
v_adc_min_tad                  EQU 16
v_adc_max_tad                  EQU 60
v__adcon0_shadow               EQU 0x0039  ; _adcon0_shadow
v_adc_conversion_delay         EQU 0x0045  ; adc_conversion_delay
v_delay_slots                  EQU 2
v_internal_isr_counter         EQU 0x0046  ; internal_isr_counter
v_isr_countdown                EQU 0x0048  ; isr_countdown
v_timer0_load                  EQU 0x004c  ; timer0_load
v__pr2_shadow_plus1            EQU 0x003a  ; _pr2_shadow_plus1
v__ccpr1l_shadow               EQU 0x004d  ; _ccpr1l_shadow
v__ccp1con_shadow              EQU 0x004e  ; _ccp1con_shadow
v__ccpr2l_shadow               EQU 0x004f  ; _ccpr2l_shadow
v__ccp2con_shadow              EQU 0x0050  ; _ccp2con_shadow
v_pcfdata                      EQU 0
v_swselect                     EQU 0x0065  ; swselect-->_bitbucket:1
v_swright                      EQU 0x0065  ; swright-->_bitbucket:2
v_swleft                       EQU 0x0065  ; swleft-->_bitbucket:3
v_prevbuttonio                 EQU 0x0051  ; prevbuttonio
v_buttondelay                  EQU 0x0052  ; buttondelay
v_line_norm                    EQU 150
v_motorl                       EQU 0x0053  ; motorl
v_motorr                       EQU 0x0054  ; motorr
v_draairichting                EQU 0x0065  ; draairichting-->_bitbucket:4
v_requestcontrol               EQU 0x0055  ; requestcontrol
v_prevwinner                   EQU 0x0056  ; prevwinner
v_linel                        EQU 0x0057  ; linel
v_liner                        EQU 0x0059  ; liner
v_cntavoid                     EQU 0x005b  ; cntavoid
v_startcounter                 EQU 0x005d  ; startcounter
v_eeprom_adres                 EQU 0x005e  ; eeprom_adres
v___str1_2                     EQU 0x00a0  ; str1
v_previsr_counter              EQU 0x0060  ; previsr_counter
v__btemp152                    EQU 0x0065  ; _btemp152-->_bitbucket:5
v__btemp153                    EQU 0x0065  ; _btemp153-->_bitbucket:6
v_prevpcfdata                  EQU 0x0062  ; prevpcfdata
v____temp_69                   EQU 0x0063  ; _temp
v__bitbucket                   EQU 0x0065  ; _bitbucket
v__pic_temp                    EQU 0x0020  ; _pic_temp-->_pic_state
v__pic_pointer                 EQU 0x0036  ; _pic_pointer
v__pic_loop                    EQU 0x0034  ; _pic_loop
v__pic_divisor                 EQU 0x0028  ; _pic_divisor-->_pic_state+8
v__pic_dividend                EQU 0x0020  ; _pic_dividend-->_pic_state
v__pic_quotient                EQU 0x002c  ; _pic_quotient-->_pic_state+12
v__pic_remainder               EQU 0x0024  ; _pic_remainder-->_pic_state+4
v__pic_divaccum                EQU 0x0020  ; _pic_divaccum-->_pic_state
v__pic_multiplier              EQU 0x0020  ; _pic_multiplier-->_pic_state
v__pic_multiplicand            EQU 0x0022  ; _pic_multiplicand-->_pic_state+2
v__pic_mresult                 EQU 0x0024  ; _pic_mresult-->_pic_state+4
v__pic_isr_fsr                 EQU 0x0038  ; _pic_isr_fsr
v__pic_isr_status              EQU 0x0032  ; _pic_isr_status
v__pic_isr_pclath              EQU 0x0033  ; _pic_isr_pclath
v__pic_sign                    EQU 0x0035  ; _pic_sign
v__pic_state                   EQU 0x0020  ; _pic_state
v__pic_isr_state               EQU 0x0030  ; _pic_isr_state
v____btemp34_2                 EQU 0x0065  ; _btemp34-->_bitbucket:21
v____btemp36_2                 EQU 0x0065  ; _btemp36-->_bitbucket:23
v____btemp38_2                 EQU 0x0065  ; _btemp38-->_bitbucket:25
v____btemp40_2                 EQU 0x0065  ; _btemp40-->_bitbucket:27
v____btemp42_2                 EQU 0x0065  ; _btemp42-->_bitbucket:29
v____btemp44_2                 EQU 0x0065  ; _btemp44-->_bitbucket:31
v___adcs_msb_2                 EQU 0x0065  ; adcs_msb-->_bitbucket:20
v___x_74                       EQU 0x0043  ; x-->_portb_shadow:5
v___x_75                       EQU 0x0043  ; x-->_portb_shadow:4
v___x_76                       EQU 0x0043  ; x-->_portb_shadow:2
v___x_77                       EQU 0x0043  ; x-->_portb_shadow:1
v___x_102                      EQU 0x0043  ; x-->_portb_shadow:4
v___x_103                      EQU 0x0043  ; x-->_portb_shadow:1
v__btemp159                    EQU 0x0065  ; _btemp159-->_bitbucket:12
v__btemp161                    EQU 0x0065  ; _btemp161-->_bitbucket:14
v__btemp162                    EQU 0x0065  ; _btemp162-->_bitbucket:15
v_mstr2                        EQU 0x00b4  ; mstr2
v_mstr1                        EQU 0x00b4  ; mstr1
v___x_104                      EQU 0x0043  ; x-->_portb_shadow:2
v___x_105                      EQU 0x0043  ; x-->_portb_shadow:2
v___x_106                      EQU 0x0043  ; x-->_portb_shadow:1
v___x_107                      EQU 0x0043  ; x-->_portb_shadow:5
v___x_108                      EQU 0x0043  ; x-->_portb_shadow:5
v___x_109                      EQU 0x0043  ; x-->_portb_shadow:4
v__btemp164                    EQU 0x0065  ; _btemp164-->_bitbucket:17
v___x_110                      EQU 0x0043  ; x-->_portb_shadow:7
v_cmd                          EQU 0x006a  ; console:cmd
v__btemp149                    EQU 0x006c  ; console:_btemp149-->_bitbucket1:0
v____bitbucket_1               EQU 0x006c  ; console:_bitbucket
v_cstr2                        EQU 0x00bd  ; console:cstr2
v_cstr4                        EQU 0x00da  ; console:cstr4
v_cstr3                        EQU 0x00e9  ; console:cstr3
v_cstr5                        EQU 0x0110  ; console:cstr5
v_cstr6                        EQU 0x0123  ; console:cstr6
v_cstr1                        EQU 0x00bd  ; console:cstr1
v___chr_2                      EQU 0x0130  ; csvdump:chr
v____temp_68                   EQU 0       ; csvdump(): _temp
v____temp_67                   EQU 0       ; csvoutput(): _temp
v____temp_66                   EQU 0       ; csvlog(): _temp
v___addr_1                     EQU 0x0132  ; read_byte_from_eeprom:addr
v_chr                          EQU 0x0136  ; read_byte_from_eeprom:chr
v____temp_65                   EQU 0x0138  ; read_byte_from_eeprom:_temp
v____temp_64                   EQU 0       ; readpcf8574(): _temp
v_sensortmp                    EQU 0x006a  ; vloersensor:sensortmp
v____temp_63                   EQU 0       ; vloersensor(): _temp
v___x_99                       EQU 0x0042  ; vloersensor:x-->_porta_shadow:4
v___x_100                      EQU 0x0042  ; vloersensor:x-->_porta_shadow:4
v___id_17                      EQU 0x006a  ; behavewaitstart:id
v_tmp                          EQU 0x006c  ; behavewaitstart:tmp
v____temp_62                   EQU 0x00bd  ; behavewaitstart:_temp
v____bitbucket_9               EQU 0x00d2  ; behavewaitstart:_bitbucket
v___x_78                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:3
v___x_79                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:7
v___x_80                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:6
v___x_81                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:3
v___x_82                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:7
v___x_83                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:6
v__btemp117                    EQU 0x00d2  ; behavewaitstart:_btemp117-->_bitbucket9:6
v___x_84                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:3
v___x_85                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:7
v___x_86                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:6
v___x_87                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:3
v___x_88                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:7
v___x_89                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:6
v___x_90                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:3
v___x_91                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:7
v___x_92                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:6
v___x_93                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:3
v___x_94                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:7
v___x_95                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:6
v___x_96                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:3
v___x_97                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:7
v___x_98                       EQU 0x0043  ; behavewaitstart:x-->_portb_shadow:6
v___id_13                      EQU 0x006a  ; behaveavoid:id
v__btemp97                     EQU 0x006c  ; behaveavoid:_btemp97-->_bitbucket11:0
v__btemp98                     EQU 0x006c  ; behaveavoid:_btemp98-->_bitbucket11:1
v__btemp99                     EQU 0x006c  ; behaveavoid:_btemp99-->_bitbucket11:2
v__btemp101                    EQU 0x006c  ; behaveavoid:_btemp101-->_bitbucket11:4
v__btemp102                    EQU 0x006c  ; behaveavoid:_btemp102-->_bitbucket11:5
v__btemp103                    EQU 0x006c  ; behaveavoid:_btemp103-->_bitbucket11:6
v__btemp104                    EQU 0x006c  ; behaveavoid:_btemp104-->_bitbucket11:7
v__btemp105                    EQU 0x006c  ; behaveavoid:_btemp105-->_bitbucket11:8
v__btemp106                    EQU 0x006c  ; behaveavoid:_btemp106-->_bitbucket11:9
v____bitbucket_11              EQU 0x006c  ; behaveavoid:_bitbucket
v_battery                      EQU 0x006a  ; batterycheck:battery
v____temp_56                   EQU 0       ; batterycheck(): _temp
v____temp_55                   EQU 0x006a  ; buttons:_temp
v___prescaler_1                EQU 0x006a  ; pwm_max_resolution:prescaler
v___ack_1                      EQU 0x013c  ; i2c_receive_byte:ack-->_bitbucket34:0
v___data_58                    EQU 0x013a  ; i2c_receive_byte:data
v____bitbucket_34              EQU 0x013c  ; i2c_receive_byte:_bitbucket
v___data_57                    EQU 0x013a  ; i2c_transmit_byte:data
v____temp_44                   EQU 0x003c  ; isr:_temp
v_index                        EQU 0x003f  ; isr:index
v___i_1                        EQU 0x006a  ; timer0_isr_init:i
v____temp_43                   EQU 0x006c  ; timer0_isr_init:_temp
v___slot_3                     EQU 0x00d5  ; check_delay:slot
v____temp_42                   EQU 0x00d7  ; check_delay:_temp
v___slot_1                     EQU 0x00d5  ; set_delay:slot
v___ticks_1                    EQU 0x00d7  ; set_delay:ticks
v____temp_41                   EQU 0x00d9  ; set_delay:_temp
v_temp                         EQU 0x00d5  ; _isr_counter_get:temp
v_shift_alias                  EQU 0       ; adc_read_low_res(): shift_alias
v___ad_value_1                 EQU 0       ; adc_read_bytes(): ad_value
v____temp_39                   EQU 0       ; adc_read_bytes(): _temp
v___adc_chan_3                 EQU 0x00bd  ; adc_read:adc_chan
v_ad_value                     EQU 0x006e  ; adc_read:ad_value
v_ax                           EQU 0x006e  ; adc_read:ax-->ad_value
v___adc_chan_1                 EQU 0x00d1  ; _adc_read_low_res:adc_chan
v___adc_byte_1                 EQU 0x00d2  ; _adc_read_low_res:adc_byte
v___factor_1                   EQU 0x006a  ; _adc_eval_tad:factor
v_tad_ok                       EQU 0x00cd  ; _adc_eval_tad:tad_ok-->_bitbucket54:0
v____temp_38                   EQU 0x00bd  ; _adc_eval_tad:_temp
v__btemp31                     EQU 0x00cd  ; _adc_eval_tad:_btemp31-->_bitbucket54:1
v__btemp32                     EQU 0x00cd  ; _adc_eval_tad:_btemp32-->_bitbucket54:2
v__btemp33                     EQU 0x00cd  ; _adc_eval_tad:_btemp33-->_bitbucket54:3
v____bitbucket_54              EQU 0x00cd  ; _adc_eval_tad:_bitbucket
v_idx                          EQU 15      ; _adc_setup_pins(): idx
v___data_52                    EQU 0x0040  ; _serial_hw_data_put:data
v___data_50                    EQU 0x0130  ; serial_hw_read:data
v__btemp28                     EQU 0x0132  ; serial_hw_read:_btemp28-->_bitbucket63:0
v____bitbucket_63              EQU 0x0132  ; serial_hw_read:_bitbucket
v___data_46                    EQU 0       ; serial_hw_write_word(): data
v___data_44                    EQU 0x0041  ; serial_hw_write:data
v_usart_div                    EQU 10      ; _calculate_and_set_baudrate(): usart_div
v____device_put_19             EQU 0x0130  ; print_byte_dec:_device_put
v___data_38                    EQU 0x0134  ; print_byte_dec:data
v____device_put_18             EQU 0x0130  ; print_word_dec:_device_put
v___data_36                    EQU 0x0134  ; print_word_dec:data
v____device_put_14             EQU 0x0130  ; print_sword_dec:_device_put
v___data_28                    EQU 0x0134  ; print_sword_dec:data
v____device_put_12             EQU 0x0132  ; print_byte_hex:_device_put
v___data_24                    EQU 0x0136  ; print_byte_hex:data
v____temp_34                   EQU 0x0138  ; print_byte_hex:_temp
v____device_put_11             EQU 0x006a  ; print_word_hex:_device_put
v___data_22                    EQU 0x00bd  ; print_word_hex:data
v____temp_33                   EQU 0x00cd  ; print_word_hex:_temp
v____device_put_2              EQU 0x0130  ; print_bit_truefalse:_device_put
v___data_4                     EQU 0x0134  ; print_bit_truefalse:data-->_bitbucket87:0
v____bitbucket_87              EQU 0x0134  ; print_bit_truefalse:_bitbucket
v____device_put_1              EQU 0x0136  ; print_string:_device_put
v__str_count                   EQU 0x013a  ; print_string:_str_count
v___str_1                      EQU 0x0140  ; print_string:str
v_len                          EQU 0x0142  ; print_string:len
v_i                            EQU 0x0148  ; print_string:i
v__device_put                  EQU 0x0132  ; print_crlf:_device_put
v____device_put_20             EQU 0x0138  ; _print_suniversal_dec:_device_put
v___data_40                    EQU 0x013c  ; _print_suniversal_dec:data
v___digit_divisor_3            EQU 0x0144  ; _print_suniversal_dec:digit_divisor
v___digit_number_3             EQU 0x0149  ; _print_suniversal_dec:digit_number
v____device_put_21             EQU 0x014a  ; _print_universal_dec:_device_put
v___data_42                    EQU 0x014c  ; _print_universal_dec:data
v___digit_divisor_5            EQU 0x0150  ; _print_universal_dec:digit_divisor
v___digit_number_5             EQU 0x0154  ; _print_universal_dec:digit_number
v_digit                        EQU 0x0155  ; _print_universal_dec:digit
v_no_digits_printed_yet        EQU 0x0157  ; _print_universal_dec:no_digits_printed_yet-->_bitbucket92:0
v____temp_37                   EQU 0x0156  ; _print_universal_dec:_temp
v____bitbucket_92              EQU 0x0157  ; _print_universal_dec:_bitbucket
v__btemp21                     EQU 0x0157  ; _print_universal_dec:_btemp21-->_bitbucket92:3
v__btemp22                     EQU 0x0157  ; _print_universal_dec:_btemp22-->_bitbucket92:4
v__btemp23                     EQU 0x0157  ; _print_universal_dec:_btemp23-->_bitbucket92:5
v___n_1                        EQU 0x00d4  ; delay_10us:n
v__floop1                      EQU 0x00d5  ; delay_10us:_floop1
;   61 include 16f876a
                               org      0                   ;  0 -- -- -- [-- --] 0000
                               branchhi_clr l__main         ;  0 -V rs rs [hl hl] 0000 120a
                               branchlo_clr l__main         ;  0 -V rs rs [hl hl] 0001 118a
                               goto     l__main             ;  0 -V rs rs [hl hl] 0002 28d7
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
                               goto     l_isr               ; 4294967295 -V rs rs [hl hl] 0013 2d79
l__lookup_nibble2hex
                               addwf    v__pcl,f            ;  3 -V ?? rS [?l ?l] 0014 0782
                               retlw    48                  ; 4294967295 -V -- -- [-- --] 0015 3430
                               retlw    49                  ; 4294967295 -V -- -- [-- --] 0016 3431
                               retlw    50                  ; 4294967295 -V -- -- [-- --] 0017 3432
                               retlw    51                  ; 4294967295 -V -- -- [-- --] 0018 3433
                               retlw    52                  ; 4294967295 -V -- -- [-- --] 0019 3434
                               retlw    53                  ; 4294967295 -V -- -- [-- --] 001a 3435
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 001b 3436
                               retlw    55                  ; 4294967295 -V -- -- [-- --] 001c 3437
                               retlw    56                  ; 4294967295 -V -- -- [-- --] 001d 3438
                               retlw    57                  ; 4294967295 -V -- -- [-- --] 001e 3439
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 001f 3441
                               retlw    66                  ; 4294967295 -V -- -- [-- --] 0020 3442
                               retlw    67                  ; 4294967295 -V -- -- [-- --] 0021 3443
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 0022 3444
                               retlw    69                  ; 4294967295 -V -- -- [-- --] 0023 3445
                               retlw    70                  ; 4294967295 -V -- -- [-- --] 0024 3446
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0025 0782
l__data_bstr1
                               retlw    98                  ; 4294967295 -V -- -- [-- --] 0026 3462
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 0027 3461
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0028 3474
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0029 3474
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 002a 3465
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 002b 3472
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 002c 3469
                               retlw    106                 ; 4294967295 -V -- -- [-- --] 002d 346a
                               retlw    58                  ; 4294967295 -V -- -- [-- --] 002e 343a
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 002f 3420
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0030 0782
l__data_str0
                               retlw    102                 ; 4294967295 -V -- -- [-- --] 0031 3466
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 0032 3461
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 0033 346c
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 0034 3473
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0035 3465
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0036 0782
l__data_str1
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0037 3474
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 0038 3472
                               retlw    117                 ; 4294967295 -V -- -- [-- --] 0039 3475
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 003a 3465
l__pic_multiply
                               movlw    16                  ;  2 OV rs rs [?l ?l] 003b 3010
                                                            ; W = v__pic_multiplicand
                               movwf    v__pic_loop         ;  2 OV rs rs [?l ?l] 003c 00b4
l__l1138
                               bcf      v__status, v__c     ;  2 OV rs rs [?l ?l] 003d 1003
                               rlf      v__pic_mresult,f    ;  2 OV rs rs [?l ?l] 003e 0da4
                               rlf      v__pic_mresult+1,f  ;  2 OV rs rs [?l ?l] 003f 0da5
                               bcf      v__status, v__c     ;  2 OV rs rs [?l ?l] 0040 1003
                               rlf      v__pic_multiplier,f ;  2 OV rs rs [?l ?l] 0041 0da0
                               rlf      v__pic_multiplier+1,f;  2 OV rs rs [?l ?l] 0042 0da1
                               branchlo_nop l__l1139        ;  2 OV rs rs [?l ?l] 0043
                               btfss    v__status, v__c     ;  2 OV rs rs [?l ?l] 0043 1c03
                               goto     l__l1139            ;  2 OV rs rs [?l ?l] 0044 284b
                               movf     v__pic_multiplicand+1,w;  2 OV rs rs [?l ?l] 0045 0823
                               addwf    v__pic_mresult+1,f  ;  2 OV rs rs [?l ?l] 0046 07a5
                                                            ; W = v__pic_multiplicand
                               movf     v__pic_multiplicand,w;  2 OV rs rs [?l ?l] 0047 0822
                                                            ; W = v__pic_multiplicand
                               addwf    v__pic_mresult,f    ;  2 OV rs rs [?l ?l] 0048 07a4
                                                            ; W = v__pic_multiplicand
                               btfsc    v__status, v__c     ;  2 OV rs rs [?l ?l] 0049 1803
                                                            ; W = v__pic_multiplicand
                               incf     v__pic_mresult+1,f  ;  2 OV rs rs [?l ?l] 004a 0aa5
                                                            ; W = v__pic_multiplicand
l__l1139
                               branchlo_nop l__l1138        ;  2 OV rs rs [?l ?l] 004b
                               decfsz   v__pic_loop,f       ;  2 OV rs rs [?l ?l] 004b 0bb4
                               goto     l__l1138            ;  2 OV rs rs [?l ?l] 004c 283d
                               return                       ;  2 OV rs rs [?l ?l] 004d 0008
l__pic_sdivide
                               movlw    0                   ;  3 OV rs rs [?l ?l] 004e 3000
                                                            ; W = v__pic_dividend
                               branchlo_nop l__l1143        ;  3 OV rs rs [?l ?l] 004f
                               btfss    v__pic_dividend+3, 7;  3 OV rs rs [?l ?l] 004f 1fa3
                               goto     l__l1143            ;  3 OV rs rs [?l ?l] 0050 285d
                               comf     v__pic_dividend,f   ;  3 OV rs rs [?l ?l] 0051 09a0
                               comf     v__pic_dividend+1,f ;  3 OV rs rs [?l ?l] 0052 09a1
                               comf     v__pic_dividend+2,f ;  3 OV rs rs [?l ?l] 0053 09a2
                               comf     v__pic_dividend+3,f ;  3 OV rs rs [?l ?l] 0054 09a3
                               incf     v__pic_dividend,f   ;  3 OV rs rs [?l ?l] 0055 0aa0
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 0056 1903
                               incf     v__pic_dividend+1,f ;  3 OV rs rs [?l ?l] 0057 0aa1
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 0058 1903
                               incf     v__pic_dividend+2,f ;  3 OV rs rs [?l ?l] 0059 0aa2
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 005a 1903
                               incf     v__pic_dividend+3,f ;  3 OV rs rs [?l ?l] 005b 0aa3
                               movlw    1                   ;  3 OV rs rs [?l ?l] 005c 3001
l__l1143
                               movwf    v__pic_sign         ;  3 OV rs rs [?l ?l] 005d 00b5
                               movlw    0                   ;  3 OV rs rs [?l ?l] 005e 3000
                                                            ; W = v__pic_sign
                               branchlo_nop l__l1144        ;  3 OV rs rs [?l ?l] 005f
                               btfss    v__pic_divisor+3, 7 ;  3 OV rs rs [?l ?l] 005f 1fab
                               goto     l__l1144            ;  3 OV rs rs [?l ?l] 0060 286d
                               comf     v__pic_divisor,f    ;  3 OV rs rs [?l ?l] 0061 09a8
                               comf     v__pic_divisor+1,f  ;  3 OV rs rs [?l ?l] 0062 09a9
                               comf     v__pic_divisor+2,f  ;  3 OV rs rs [?l ?l] 0063 09aa
                               comf     v__pic_divisor+3,f  ;  3 OV rs rs [?l ?l] 0064 09ab
                               incf     v__pic_divisor,f    ;  3 OV rs rs [?l ?l] 0065 0aa8
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 0066 1903
                               incf     v__pic_divisor+1,f  ;  3 OV rs rs [?l ?l] 0067 0aa9
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 0068 1903
                               incf     v__pic_divisor+2,f  ;  3 OV rs rs [?l ?l] 0069 0aaa
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 006a 1903
                               incf     v__pic_divisor+3,f  ;  3 OV rs rs [?l ?l] 006b 0aab
                               movlw    1                   ;  3 OV rs rs [?l ?l] 006c 3001
l__l1144
                               xorwf    v__pic_sign,f       ;  3 OV rs rs [?l ?l] 006d 06b5
                               branchlo_nop l__l1145        ;  3 OV rs rs [?l ?l] 006e
                               goto     l__l1145            ;  3 OV rs rs [?l ?l] 006e 2870
l__pic_divide
                               clrf     v__pic_sign         ;  3 OV rs rs [?l ?l] 006f 01b5
                                                            ; W = v__pic_dividend
l__l1145
                               movlw    32                  ;  3 OV rs rs [?l ?l] 0070 3020
                                                            ; W = v__pic_dividend
                               movwf    v__pic_loop         ;  3 OV rs rs [?l ?l] 0071 00b4
                               clrf     v__pic_remainder    ;  3 OV rs rs [?l ?l] 0072 01a4
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+1  ;  3 OV rs rs [?l ?l] 0073 01a5
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+2  ;  3 OV rs rs [?l ?l] 0074 01a6
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+3  ;  3 OV rs rs [?l ?l] 0075 01a7
                                                            ; W = v__pic_loop
l__l1140
                               bcf      v__status, v__c     ;  3 OV rs rs [?l ?l] 0076 1003
                               rlf      v__pic_quotient,f   ;  3 OV rs rs [?l ?l] 0077 0dac
                               rlf      v__pic_quotient+1,f ;  3 OV rs rs [?l ?l] 0078 0dad
                               rlf      v__pic_quotient+2,f ;  3 OV rs rs [?l ?l] 0079 0dae
                               rlf      v__pic_quotient+3,f ;  3 OV rs rs [?l ?l] 007a 0daf
                               bcf      v__status, v__c     ;  3 OV rs rs [?l ?l] 007b 1003
                               rlf      v__pic_divaccum,f   ;  3 OV rs rs [?l ?l] 007c 0da0
                               rlf      v__pic_divaccum+1,f ;  3 OV rs rs [?l ?l] 007d 0da1
                               rlf      v__pic_divaccum+2,f ;  3 OV rs rs [?l ?l] 007e 0da2
                               rlf      v__pic_divaccum+3,f ;  3 OV rs rs [?l ?l] 007f 0da3
                               rlf      v__pic_divaccum+4,f ;  3 OV rs rs [?l ?l] 0080 0da4
                               rlf      v__pic_divaccum+5,f ;  3 OV rs rs [?l ?l] 0081 0da5
                               rlf      v__pic_divaccum+6,f ;  3 OV rs rs [?l ?l] 0082 0da6
                               rlf      v__pic_divaccum+7,f ;  3 OV rs rs [?l ?l] 0083 0da7
                               movf     v__pic_remainder+3,w;  3 OV rs rs [?l ?l] 0084 0827
                               subwf    v__pic_divisor+3,w  ;  3 OV rs rs [?l ?l] 0085 022b
                                                            ; W = v__pic_remainder
                               branchlo_nop l__l1146        ;  3 OV rs rs [?l ?l] 0086
                               btfss    v__status, v__z     ;  3 OV rs rs [?l ?l] 0086 1d03
                               goto     l__l1146            ;  3 OV rs rs [?l ?l] 0087 2892
                               movf     v__pic_remainder+2,w;  3 OV rs rs [?l ?l] 0088 0826
                                                            ; W = v__pic_sign
                               subwf    v__pic_divisor+2,w  ;  3 OV rs rs [?l ?l] 0089 022a
                                                            ; W = v__pic_remainder
                               branchlo_nop l__l1146        ;  3 OV rs rs [?l ?l] 008a
                               btfss    v__status, v__z     ;  3 OV rs rs [?l ?l] 008a 1d03
                               goto     l__l1146            ;  3 OV rs rs [?l ?l] 008b 2892
                               movf     v__pic_remainder+1,w;  3 OV rs rs [?l ?l] 008c 0825
                               subwf    v__pic_divisor+1,w  ;  3 OV rs rs [?l ?l] 008d 0229
                                                            ; W = v__pic_remainder
                               branchlo_nop l__l1146        ;  3 OV rs rs [?l ?l] 008e
                               btfss    v__status, v__z     ;  3 OV rs rs [?l ?l] 008e 1d03
                               goto     l__l1146            ;  3 OV rs rs [?l ?l] 008f 2892
                               movf     v__pic_remainder,w  ;  3 OV rs rs [?l ?l] 0090 0824
                               subwf    v__pic_divisor,w    ;  3 OV rs rs [?l ?l] 0091 0228
                                                            ; W = v__pic_remainder
l__l1146
                               branchlo_nop l__l1142        ;  3 OV rs rs [?l ?l] 0092
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 0092 1903
                               goto     l__l1142            ;  3 OV rs rs [?l ?l] 0093 2896
                               branchlo_nop l__l1141        ;  3 OV rs rs [?l ?l] 0094
                                                            ; W = v__pic_sign
                               btfsc    v__status, v__c     ;  3 OV rs rs [?l ?l] 0094 1803
                                                            ; W = v__pic_sign
                               goto     l__l1141            ;  3 OV rs rs [?l ?l] 0095 28a5
                                                            ; W = v__pic_sign
l__l1142
                               movf     v__pic_divisor,w    ;  3 OV rs rs [?l ?l] 0096 0828
                               subwf    v__pic_remainder,f  ;  3 OV rs rs [?l ?l] 0097 02a4
                                                            ; W = v__pic_divisor
                               movf     v__pic_divisor+1,w  ;  3 OV rs rs [?l ?l] 0098 0829
                                                            ; W = v__pic_divisor
                               btfss    v__status, v__c     ;  3 OV rs rs [?l ?l] 0099 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+1,w  ;  3 OV rs rs [?l ?l] 009a 0f29
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+1,f;  3 OV rs rs [?l ?l] 009b 02a5
                               movf     v__pic_divisor+2,w  ;  3 OV rs rs [?l ?l] 009c 082a
                               btfss    v__status, v__c     ;  3 OV rs rs [?l ?l] 009d 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+2,w  ;  3 OV rs rs [?l ?l] 009e 0f2a
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+2,f;  3 OV rs rs [?l ?l] 009f 02a6
                               movf     v__pic_divisor+3,w  ;  3 OV rs rs [?l ?l] 00a0 082b
                               btfss    v__status, v__c     ;  3 OV rs rs [?l ?l] 00a1 1c03
                                                            ; W = v__pic_divisor
                               incfsz   v__pic_divisor+3,w  ;  3 OV rs rs [?l ?l] 00a2 0f2b
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder+3,f;  3 OV rs rs [?l ?l] 00a3 02a7
                               bsf      v__pic_quotient, 0  ;  3 OV rs rs [?l ?l] 00a4 142c
l__l1141
                               branchlo_nop l__l1140        ;  3 OV rs rs [?l ?l] 00a5
                                                            ; W = v__pic_sign
                               decfsz   v__pic_loop,f       ;  3 OV rs rs [?l ?l] 00a5 0bb4
                                                            ; W = v__pic_sign
                               goto     l__l1140            ;  3 OV rs rs [?l ?l] 00a6 2876
                                                            ; W = v__pic_sign
                               movf     v__pic_sign,w       ;  3 OV rs rs [?l ?l] 00a7 0835
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 00a8 1903
                                                            ; W = v__pic_sign
                               return                       ;  3 OV rs rs [?l ?l] 00a9 0008
                                                            ; W = v__pic_sign
                               comf     v__pic_quotient,f   ;  3 OV rs rs [?l ?l] 00aa 09ac
                               comf     v__pic_quotient+1,f ;  3 OV rs rs [?l ?l] 00ab 09ad
                               comf     v__pic_quotient+2,f ;  3 OV rs rs [?l ?l] 00ac 09ae
                               comf     v__pic_quotient+3,f ;  3 OV rs rs [?l ?l] 00ad 09af
                               incf     v__pic_quotient,f   ;  3 OV rs rs [?l ?l] 00ae 0aac
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 00af 1903
                               incf     v__pic_quotient+1,f ;  3 OV rs rs [?l ?l] 00b0 0aad
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 00b1 1903
                               incf     v__pic_quotient+2,f ;  3 OV rs rs [?l ?l] 00b2 0aae
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 00b3 1903
                               incf     v__pic_quotient+3,f ;  3 OV rs rs [?l ?l] 00b4 0aaf
                               comf     v__pic_remainder,f  ;  3 OV rs rs [?l ?l] 00b5 09a4
                               comf     v__pic_remainder+1,f;  3 OV rs rs [?l ?l] 00b6 09a5
                               comf     v__pic_remainder+2,f;  3 OV rs rs [?l ?l] 00b7 09a6
                               comf     v__pic_remainder+3,f;  3 OV rs rs [?l ?l] 00b8 09a7
                               incf     v__pic_remainder,f  ;  3 OV rs rs [?l ?l] 00b9 0aa4
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 00ba 1903
                               incf     v__pic_remainder+1,f;  3 OV rs rs [?l ?l] 00bb 0aa5
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 00bc 1903
                               incf     v__pic_remainder+2,f;  3 OV rs rs [?l ?l] 00bd 0aa6
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 00be 1903
                               incf     v__pic_remainder+3,f;  3 OV rs rs [?l ?l] 00bf 0aa7
                               return                       ;  3 OV rs rs [?l ?l] 00c0 0008
l__pic_pointer_read
                               branchlo_nop l__l1147        ;  3 OV rs rs [?l ?l] 00c1
                               btfsc    v__pic_pointer+1, 7 ;  3 OV rs rs [?l ?l] 00c1 1bb7
                               goto     l__l1147            ;  3 OV rs rs [?l ?l] 00c2 28d2
                               branchlo_nop l__l1148        ;  3 OV rs rs [?l ?l] 00c3
                               btfsc    v__pic_pointer+1, 6 ;  3 OV rs rs [?l ?l] 00c3 1b37
                               goto     l__l1148            ;  3 OV rs rs [?l ?l] 00c4 28cd
                               movf     v__pic_pointer,w    ;  3 OV rs rs [?l ?l] 00c5 0836
                               movwf    v__fsr              ;  3 OV rs rs [?l ?l] 00c6 0084
                                                            ; W = v__pic_pointer
                               bcf      v__status, v__irp   ;  3 OV rs rs [?l ?l] 00c7 1383
                               movf     v__pic_pointer+1,f  ;  3 OV rs rs [?l ?l] 00c8 08b7
                               btfss    v__status, v__z     ;  3 OV rs rs [?l ?l] 00c9 1d03
                               bsf      v__status, v__irp   ;  3 OV rs rs [?l ?l] 00ca 1783
                               movf     v__ind,w            ;  3 OV rs rs [?l ?l] 00cb 0800
                               return                       ;  3 OV rs rs [?l ?l] 00cc 0008
l__l1148
                               movf     v__pic_pointer,w    ;  3 OV rs rs [?l ?l] 00cd 0836
                               movwf    v__pic_sign         ;  3 OV rs rs [?l ?l] 00ce 00b5
                                                            ; W = v__pic_pointer
                               movf     v__pic_pointer+1,w  ;  3 OV rs rs [?l ?l] 00cf 0837
                                                            ; W = v__pic_sign
                               andlw    63                  ;  3 OV rs rs [?l ?l] 00d0 393f
                                                            ; W = v__pic_pointer
                               branchlo_nop l__pic_indirect ;  3 OV rs rs [?l ?l] 00d1
                               goto     l__pic_indirect     ;  3 OV rs rs [?l ?l] 00d1 28d3
l__l1147
                               return                       ;  3 OV rs rs [?l ?l] 00d2 0008
l__pic_indirect
                               movwf    v__pclath           ;  3 OV ?s rs [?l ?l] 00d3 008a
                               datahi_clr v__pic_pointer    ;  3 OV ?s rs [?l ?l] 00d4 1303
                               movf     v__pic_pointer,w    ;  3 OV rs rs [?l ?l] 00d5 0836
                               movwf    v__pcl              ;  3 OV rs rs [?l ?l] 00d6 0082
                                                            ; W = v__pic_pointer
l__main
; 16f876a.jal
;   96 var          byte  _PORTA_shadow        = PORTA
                               movf     v_porta,w           ;  0 OV rs rs [hl hl] 00d7 0805
                               movwf    v__porta_shadow     ;  0 OV rs rs [hl hl] 00d8 00c2
;  191 var          byte  _PORTB_shadow        = PORTB
                               movf     v_portb,w           ;  0 OV rs rs [hl hl] 00d9 0806
                                                            ; W = v__porta_shadow
                               movwf    v__portb_shadow     ;  0 OV rs rs [hl hl] 00da 00c3
;  296 procedure _PORTC_flush() is
                               branchlo_nop l__l197         ;  0 OV rs rs [hl hl] 00db
                                                            ; W = v__portb_shadow
                               goto     l__l197             ;  0 OV rs rs [hl hl] 00db 290c
                                                            ; W = v__portb_shadow
; delay.jal
;   83 procedure delay_10us(byte in n) is
l_delay_10us
                               datalo_set v___n_1           ;  4 OV r? rS [?l ?l] 00dc 1683
                               movwf    v___n_1             ;  4 OV rS rS [?l ?l] 00dd 00d4
;   84    if n==0 then
                               movf     v___n_1,w           ;  4 OV rS rS [?l ?l] 00de 0854
                                                            ; W = v___n_1
                               branchlo_nop l__l165         ;  4 OV rS rS [?l ?l] 00df
                                                            ; W = v___n_1
                               btfsc    v__status, v__z     ;  4 OV rS rS [?l ?l] 00df 1903
                                                            ; W = v___n_1
;   85       return
                               return                       ;  4 OV rS rS [?l ?l] 00e0 0008
;   86    elsif n==1 then
l__l165
                               movlw    1                   ;  4 OV rS rS [?l ?l] 00e1 3001
                                                            ; W = v___n_1
                               subwf    v___n_1,w           ;  4 OV rS rS [?l ?l] 00e2 0254
                               branchlo_nop l__l166         ;  4 OV rS rS [?l ?l] 00e3
                               btfss    v__status, v__z     ;  4 OV rS rS [?l ?l] 00e3 1d03
                               goto     l__l166             ;  4 OV rS rS [?l ?l] 00e4 28ee
;   89        _usec_delay(_ten_us_delay1)
                               datalo_clr v__pic_temp       ;  4 -V rS rs [?l ?l] 00e5 1283
                               datahi_clr v__pic_temp       ;  4 -V rs rs [?l ?l] 00e6 1303
                               movlw    10                  ;  4 -V rs rs [?l ?l] 00e7 300a
                               movwf    v__pic_temp         ;  4 -V rs rs [?l ?l] 00e8 00a0
                               branchhi_clr l__l1149        ;  4 -V rs rs [?l hl] 00e9 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l1149        ;  4 -V rs rs [hl hl] 00ea 118a
                                                            ; W = v__pic_temp
l__l1149
                               decfsz   v__pic_temp,f       ;  4 -V rs rs [hl hl] 00eb 0ba0
                               goto     l__l1149            ;  4 -V rs rs [hl hl] 00ec 28eb
;   90      end if
                               return                       ;  4 OV rs rs [hl hl] 00ed 0008
;   91    else     
l__l166
;   92       n = n - 1;
                               decf     v___n_1,f           ;  4 OV rS rS [?l ?l] 00ee 03d4
;   95          _usec_delay(_ten_us_delay2)   
                               datalo_clr v__pic_temp       ;  4 -V rS rs [?l ?l] 00ef 1283
                               datahi_clr v__pic_temp       ;  4 -V rs rs [?l ?l] 00f0 1303
                               movlw    6                   ;  4 -V rs rs [?l ?l] 00f1 3006
                               movwf    v__pic_temp         ;  4 -V rs rs [?l ?l] 00f2 00a0
                               branchhi_clr l__l1150        ;  4 -V rs rs [?l hl] 00f3 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l1150        ;  4 -V rs rs [hl hl] 00f4 118a
                                                            ; W = v__pic_temp
l__l1150
                               decfsz   v__pic_temp,f       ;  4 -V rs rs [hl hl] 00f5 0ba0
                               goto     l__l1150            ;  4 -V rs rs [hl hl] 00f6 28f5
                               nop                          ;  4 -V rs rs [hl hl] 00f7 0000
                               nop                          ;  4 -V rs rs [hl hl] 00f8 0000
;  101       for n loop
                               datalo_set v__floop1         ;  4 OV rs rS [hl hl] 00f9 1683
                               clrf     v__floop1           ;  4 OV rS rS [hl hl] 00fa 01d5
                               branchlo_nop l__l172         ;  4 OV rS rS [hl hl] 00fb
                               goto     l__l172             ;  4 OV rS rS [hl hl] 00fb 2907
l__l171
;  103             _usec_delay(_ten_us_delay3)
                               datalo_clr v__pic_temp       ;  4 -V rS rs [hl hl] 00fc 1283
                               datahi_clr v__pic_temp       ;  4 -V rs rs [hl hl] 00fd 1303
                               movlw    13                  ;  4 -V rs rs [hl hl] 00fe 300d
                               movwf    v__pic_temp         ;  4 -V rs rs [hl hl] 00ff 00a0
                               branchhi_clr l__l1151        ;  4 -V rs rs [hl hl] 0100 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l1151        ;  4 -V rs rs [hl hl] 0101 118a
                                                            ; W = v__pic_temp
l__l1151
                               decfsz   v__pic_temp,f       ;  4 -V rs rs [hl hl] 0102 0ba0
                               goto     l__l1151            ;  4 -V rs rs [hl hl] 0103 2902
                               nop                          ;  4 -V rs rs [hl hl] 0104 0000
;  107       end loop
                               datalo_set v__floop1         ;  4 OV rs rS [hl hl] 0105 1683
                               incf     v__floop1,f         ;  4 OV rS rS [hl hl] 0106 0ad5
l__l172
                               movf     v__floop1,w         ;  4 OV rS rS [hl hl] 0107 0855
                               subwf    v___n_1,w           ;  4 OV rS rS [hl hl] 0108 0254
                                                            ; W = v__floop1
                               branchlo_nop l__l171         ;  4 OV rS rS [hl hl] 0109
                               btfss    v__status, v__z     ;  4 OV rS rS [hl hl] 0109 1d03
                               goto     l__l171             ;  4 OV rS rS [hl hl] 010a 28fc
;  108    end if
l__l164
;  110 end procedure
l__l163
                               return                       ;  4 OV rS rS [hl hl] 010b 0008
; jascii.jal
;   77 end procedure
l__l197
; print.jal
;   55 var bit print_prefix = false        
                               bcf      v__bitbucket, 0 ; print_prefix  ;  0 OV rs rs [hl hl] 010c 1065
                                                            ; W = v__portb_shadow
;   57 procedure print_crlf(volatile byte out device) is
                               branchlo_nop l__l351         ;  0 OV rs rs [hl hl] 010d
                                                            ; W = v__portb_shadow
                               goto     l__l351             ;  0 OV rs rs [hl hl] 010d 2b8d
                                                            ; W = v__portb_shadow
l_print_crlf
;   58    device = ASCII_CR -- cariage return
                               movlw    13                  ;  2 OV Rs Rs [?l ?l] 010e 300d
                                                            ; W = v__device_put
                               datahi_clr v__pic_temp       ;  2 OV Rs rs [?l ?l] 010f 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?l ?l] 0110 00a0
                               datahi_set v__device_put     ;  2 OV rs Rs [?l ?l] 0111 1703
                                                            ; W = v__pic_temp
                               movf     v__device_put,w     ;  2 OV Rs Rs [?l ?l] 0112 0832
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?l ?l] 0113 1303
                                                            ; W = v__device_put
                               movwf    v__pic_pointer      ;  2 OV rs rs [?l ?l] 0114 00b6
                                                            ; W = v__device_put
                               datahi_set v__device_put     ;  2 OV rs Rs [?l ?l] 0115 1703
                                                            ; W = v__pic_pointer
                               movf     v__device_put+1,w   ;  2 OV Rs Rs [?l ?l] 0116 0833
                                                            ; W = v__pic_pointer
                               branchlo_nop l__pic_indirect ;  2 OV Rs Rs [?l ?l] 0117
                                                            ; W = v__device_put
                               call     l__pic_indirect     ;  2 OV Rs ?? [?l ??] 0117 20d3
                                                            ; W = v__device_put
;   59    device = ASCII_LF -- line feed
                               movlw    10                  ;  2 OV ?? ?? [?? ??] 0118 300a
                               datalo_clr v__pic_temp       ;  2 OV ?? ?s [?? ??] 0119 1283
                               datahi_clr v__pic_temp       ;  2 OV ?s rs [?? ??] 011a 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 011b 00a0
                               datahi_set v__device_put     ;  2 OV rs Rs [?? ??] 011c 1703
                                                            ; W = v__pic_temp
                               movf     v__device_put,w     ;  2 OV Rs Rs [?? ??] 011d 0832
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?? ??] 011e 1303
                                                            ; W = v__device_put
                               movwf    v__pic_pointer      ;  2 OV rs rs [?? ??] 011f 00b6
                                                            ; W = v__device_put
                               datahi_set v__device_put     ;  2 OV rs Rs [?? ??] 0120 1703
                                                            ; W = v__pic_pointer
                               movf     v__device_put+1,w   ;  2 OV Rs Rs [?? ??] 0121 0833
                                                            ; W = v__pic_pointer
                               branchlo_clr l__pic_indirect ;  2 OV Rs Rs [?? ?l] 0122 118a
                                                            ; W = v__device_put
                               goto     l__pic_indirect     ;  2 OV Rs Rs [?l ?l] 0123 28d3
                                                            ; W = v__device_put
;   60 end procedure
;   62 procedure print_string(volatile byte out device, byte in str[]) is
l_print_string
;   63    var word len = count(str)
                               movf     v__str_count,w      ;  2 OV Rs Rs [?l ?l] 0124 083a
                                                            ; W = v___str_1
                               movwf    v_len               ;  2 OV Rs Rs [?l ?l] 0125 00c2
                                                            ; W = v__str_count
                               movf     v__str_count+1,w    ;  2 OV Rs Rs [?l ?l] 0126 083b
                                                            ; W = v_len
                               movwf    v_len+1             ;  2 OV Rs Rs [?l ?l] 0127 00c3
                                                            ; W = v__str_count
;   66    for len using i loop           
                               clrf     v_i                 ;  2 OV Rs Rs [?l ?l] 0128 01c8
                                                            ; W = v_len
                               branchlo_nop l__l212         ;  2 OV Rs Rs [?l ?l] 0129
                                                            ; W = v_len
                               goto     l__l212             ;  2 OV Rs Rs [?l ?l] 0129 2944
                                                            ; W = v_len
l__l211
;   70       device = str[i]
                               datahi_set v___str_1         ;  2 OV rs Rs [?l ?l] 012a 1703
                               movf     v___str_1+1,w       ;  2 OV Rs Rs [?l ?l] 012b 0841
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?l ?l] 012c 1303
                                                            ; W = v___str_1
                               movwf    v__pic_pointer+1    ;  2 OV rs rs [?l ?l] 012d 00b7
                                                            ; W = v___str_1
                               datahi_set v_i               ;  2 OV rs Rs [?l ?l] 012e 1703
                                                            ; W = v__pic_pointer
                               movf     v_i,w               ;  2 OV Rs Rs [?l ?l] 012f 0848
                                                            ; W = v__pic_pointer
                               addwf    v___str_1,w         ;  2 OV Rs Rs [?l ?l] 0130 0740
                                                            ; W = v_i
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?l ?l] 0131 1303
                               movwf    v__pic_pointer      ;  2 OV rs rs [?l ?l] 0132 00b6
                               btfsc    v__status, v__c     ;  2 OV rs rs [?l ?l] 0133 1803
                                                            ; W = v__pic_pointer
                               incf     v__pic_pointer+1,f  ;  2 OV rs rs [?l ?l] 0134 0ab7
                                                            ; W = v__pic_pointer
                               branchlo_nop l__pic_pointer_read;  2 OV rs rs [?l ?l] 0135
                               call     l__pic_pointer_read ;  2 OV rs ?? [?l ??] 0135 20c1
                               datalo_clr v__pic_temp       ;  2 OV ?? ?s [?? ??] 0136 1283
                               datahi_clr v__pic_temp       ;  2 OV ?s rs [?? ??] 0137 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 0138 00a0
                               datahi_set v____device_put_1 ;  2 OV rs Rs [?? ??] 0139 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_1,w ;  2 OV Rs Rs [?? ??] 013a 0836
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?? ??] 013b 1303
                                                            ; W = v____device_put_1
                               movwf    v__pic_pointer      ;  2 OV rs rs [?? ??] 013c 00b6
                                                            ; W = v____device_put_1
                               datahi_set v____device_put_1 ;  2 OV rs Rs [?? ??] 013d 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_1+1,w;  2 OV Rs Rs [?? ??] 013e 0837
                                                            ; W = v__pic_pointer
                               branchlo_clr l__pic_indirect ;  2 OV Rs Rs [?? ?l] 013f 118a
                                                            ; W = v____device_put_1
                               call     l__pic_indirect     ;  2 OV Rs ?? [?l ??] 0140 20d3
                                                            ; W = v____device_put_1
;   71    end loop
                               datalo_clr v_i               ;  2 OV ?? ?s [?? ??] 0141 1283
                               datahi_set v_i               ;  2 OV ?s Rs [?? ??] 0142 1703
                               incf     v_i,f               ;  2 OV Rs Rs [?? ??] 0143 0ac8
l__l212
                               movf     v_i,w               ;  2 OV Rs Rs [?? ??] 0144 0848
                                                            ; W = v_len
                               subwf    v_len,w             ;  2 OV Rs Rs [?? ??] 0145 0242
                                                            ; W = v_i
                               datahi_clr v__pic_temp       ;  2 OV Rs rs [?? ??] 0146 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 0147 00a0
                               datahi_set v_len             ;  2 OV rs Rs [?? ??] 0148 1703
                                                            ; W = v__pic_temp
                               movf     v_len+1,w           ;  2 OV Rs Rs [?? ??] 0149 0843
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_temp       ;  2 OV Rs rs [?? ??] 014a 1303
                                                            ; W = v_len
                               iorwf    v__pic_temp,w       ;  2 OV rs rs [?? ??] 014b 0420
                                                            ; W = v_len
                               branchlo_clr l__l211         ;  2 OV rs rs [?? ?l] 014c 118a
                               btfss    v__status, v__z     ;  2 OV rs rs [?l ?l] 014d 1d03
                               goto     l__l211             ;  2 OV rs rs [?l ?l] 014e 292a
;   73 end procedure
                               return                       ;  2 OV rs rs [?l ?l] 014f 0008
;   75 procedure print_bit_truefalse(volatile byte out device, bit in data) is
l_print_bit_truefalse
;   80    if (data) then
                               branchlo_nop l__l218         ;  2 OV Rs Rs [?l ?l] 0150
                                                            ; W = v____device_put_2
                               btfss    v____bitbucket_87, 0 ; data4;  2 OV Rs Rs [?l ?l] 0150 1c34
                                                            ; W = v____device_put_2
                               goto     l__l218             ;  2 OV Rs Rs [?l ?l] 0151 295f
                                                            ; W = v____device_put_2
;   81       print_string(device, str1)
                               movf     v____device_put_2,w ;  2 OV Rs Rs [?l ?l] 0152 0830
                               movwf    v____device_put_1   ;  2 OV Rs Rs [?l ?l] 0153 00b6
                                                            ; W = v____device_put_2
                               movf     v____device_put_2+1,w;  2 OV Rs Rs [?l ?l] 0154 0831
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  2 OV Rs Rs [?l ?l] 0155 00b7
                                                            ; W = v____device_put_2
                               movlw    4                   ;  2 OV Rs Rs [?l ?l] 0156 3004
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  2 OV Rs Rs [?l ?l] 0157 00ba
                               clrf     v__str_count+1      ;  2 OV Rs Rs [?l ?l] 0158 01bb
                                                            ; W = v__str_count
                               movlw    l__data_str1        ;  2 OV Rs Rs [?l ?l] 0159 3037
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  2 OV Rs Rs [?l ?l] 015a 00c0
                               movlw    HIGH l__data_str1   ;  2 OV Rs Rs [?l ?l] 015b 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  2 OV Rs Rs [?l ?l] 015c 3840
                               movwf    v___str_1+1         ;  2 OV Rs Rs [?l ?l] 015d 00c1
                               branchlo_nop l_print_string  ;  2 OV Rs Rs [?l ?l] 015e
                                                            ; W = v___str_1
                               goto     l_print_string      ;  2 OV Rs Rs [?l ?l] 015e 2924
                                                            ; W = v___str_1
;   82    else
l__l218
;   83       print_string(device, str0)
                               movf     v____device_put_2,w ;  2 OV Rs Rs [?l ?l] 015f 0830
                                                            ; W = v____device_put_2
                               movwf    v____device_put_1   ;  2 OV Rs Rs [?l ?l] 0160 00b6
                                                            ; W = v____device_put_2
                               movf     v____device_put_2+1,w;  2 OV Rs Rs [?l ?l] 0161 0831
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  2 OV Rs Rs [?l ?l] 0162 00b7
                                                            ; W = v____device_put_2
                               movlw    5                   ;  2 OV Rs Rs [?l ?l] 0163 3005
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  2 OV Rs Rs [?l ?l] 0164 00ba
                               clrf     v__str_count+1      ;  2 OV Rs Rs [?l ?l] 0165 01bb
                                                            ; W = v__str_count
                               movlw    l__data_str0        ;  2 OV Rs Rs [?l ?l] 0166 3031
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  2 OV Rs Rs [?l ?l] 0167 00c0
                               movlw    HIGH l__data_str0   ;  2 OV Rs Rs [?l ?l] 0168 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  2 OV Rs Rs [?l ?l] 0169 3840
                               movwf    v___str_1+1         ;  2 OV Rs Rs [?l ?l] 016a 00c1
                               branchlo_nop l_print_string  ;  2 OV Rs Rs [?l ?l] 016b
                                                            ; W = v___str_1
                               goto     l_print_string      ;  2 OV Rs Rs [?l ?l] 016b 2924
                                                            ; W = v___str_1
;   84    end if
l__l217
;   86 end procedure
;  209 procedure print_word_hex(volatile byte out device, word in data) is
l_print_word_hex
;  211    if (print_prefix) then
                               datalo_clr v__bitbucket ; print_prefix   ;  1 OV rS rs [?l ?l] 016c 1283
                               branchlo_nop l__l260         ;  1 OV rs rs [?l ?l] 016d
                               btfss    v__bitbucket, 0 ; print_prefix  ;  1 OV rs rs [?l ?l] 016d 1c65
                               goto     l__l260             ;  1 OV rs rs [?l ?l] 016e 297e
;  212       device = "0"
                               movlw    48                  ;  1 OV rs rs [?l ?l] 016f 3030
                               movwf    v__pic_temp         ;  1 OV rs rs [?l ?l] 0170 00a0
                               movf     v____device_put_11,w;  1 OV rs rs [?l ?l] 0171 086a
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?l ?l] 0172 00b6
                                                            ; W = v____device_put_11
                               movf     v____device_put_11+1,w;  1 OV rs rs [?l ?l] 0173 086b
                                                            ; W = v__pic_pointer
                               branchlo_nop l__pic_indirect ;  1 OV rs rs [?l ?l] 0174
                                                            ; W = v____device_put_11
                               call     l__pic_indirect     ;  1 OV rs ?? [?l ??] 0174 20d3
                                                            ; W = v____device_put_11
;  213       device = "x"
                               movlw    120                 ;  1 OV ?? ?? [?? ??] 0175 3078
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0176 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 0177 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0178 00a0
                               movf     v____device_put_11,w;  1 OV rs rs [?? ??] 0179 086a
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 017a 00b6
                                                            ; W = v____device_put_11
                               movf     v____device_put_11+1,w;  1 OV rs rs [?? ??] 017b 086b
                                                            ; W = v__pic_pointer
                               branchlo_clr l__pic_indirect ;  1 OV rs rs [?? ?l] 017c 118a
                                                            ; W = v____device_put_11
                               call     l__pic_indirect     ;  1 OV rs ?? [?l ??] 017d 20d3
                                                            ; W = v____device_put_11
;  214    end if
l__l260
;  216    device = nibble2hex[0x0F & (data>>12)]
                               datalo_set v___data_22       ;  1 OV ?? ?S [?? ??] 017e 1683
                               datahi_clr v___data_22       ;  1 OV ?S rS [?? ??] 017f 1303
                               swapf    v___data_22+1,w     ;  1 OV rS rS [?? ??] 0180 0e3e
                               andlw    15                  ;  1 OV rS rS [?? ??] 0181 390f
                               movwf    v____temp_33        ;  1 OV rS rS [?? ??] 0182 00cd
                               clrf     v____temp_33+1      ;  1 OV rS rS [?? ??] 0183 01ce
                                                            ; W = v____temp_33
                               movlw    15                  ;  1 OV rS rS [?? ??] 0184 300f
                                                            ; W = v____temp_33
                               andwf    v____temp_33,w      ;  1 OV rS rS [?? ??] 0185 054d
                               movwf    v____temp_33+2      ;  1 OV rS rS [?? ??] 0186 00cf
                               clrf     v____temp_33+3      ;  1 OV rS rS [?? ??] 0187 01d0
                                                            ; W = v____temp_33
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rS rS [?? ??] 0188 3000
                                                            ; W = v____temp_33
                               movwf    v__pclath           ;  1 OV rS rS [?? ??] 0189 008a
                               movf     v____temp_33+2,w    ;  1 OV rS rS [?? ??] 018a 084f
                               branchlo_clr l__lookup_nibble2hex;  1 OV rS rS [?? ?l] 018b 118a
                                                            ; W = v____temp_33
                               call     l__lookup_nibble2hex;  1 OV rS ?? [?l ??] 018c 2014
                                                            ; W = v____temp_33
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 018d 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 018e 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 018f 00a0
                               movf     v____device_put_11,w;  1 OV rs rs [?? ??] 0190 086a
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0191 00b6
                                                            ; W = v____device_put_11
                               movf     v____device_put_11+1,w;  1 OV rs rs [?? ??] 0192 086b
                                                            ; W = v__pic_pointer
                               branchlo_clr l__pic_indirect ;  1 OV rs rs [?? ?l] 0193 118a
                                                            ; W = v____device_put_11
                               call     l__pic_indirect     ;  1 OV rs ?? [?l ??] 0194 20d3
                                                            ; W = v____device_put_11
;  217    device = nibble2hex[0x0F & (data>>8)]
                               datalo_set v___data_22       ;  1 OV ?? ?S [?? ??] 0195 1683
                               datahi_clr v___data_22       ;  1 OV ?S rS [?? ??] 0196 1303
                               movf     v___data_22+1,w     ;  1 OV rS rS [?? ??] 0197 083e
                               movwf    v____temp_33        ;  1 OV rS rS [?? ??] 0198 00cd
                                                            ; W = v___data_22
                               clrf     v____temp_33+1      ;  1 OV rS rS [?? ??] 0199 01ce
                                                            ; W = v____temp_33
                               movlw    15                  ;  1 OV rS rS [?? ??] 019a 300f
                                                            ; W = v____temp_33
                               andwf    v____temp_33,w      ;  1 OV rS rS [?? ??] 019b 054d
                               movwf    v____temp_33+2      ;  1 OV rS rS [?? ??] 019c 00cf
                               clrf     v____temp_33+3      ;  1 OV rS rS [?? ??] 019d 01d0
                                                            ; W = v____temp_33
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rS rS [?? ??] 019e 3000
                                                            ; W = v____temp_33
                               movwf    v__pclath           ;  1 OV rS rS [?? ??] 019f 008a
                               movf     v____temp_33+2,w    ;  1 OV rS rS [?? ??] 01a0 084f
                               branchlo_clr l__lookup_nibble2hex;  1 OV rS rS [?? ?l] 01a1 118a
                                                            ; W = v____temp_33
                               call     l__lookup_nibble2hex;  1 OV rS ?? [?l ??] 01a2 2014
                                                            ; W = v____temp_33
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 01a3 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 01a4 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01a5 00a0
                               movf     v____device_put_11,w;  1 OV rs rs [?? ??] 01a6 086a
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 01a7 00b6
                                                            ; W = v____device_put_11
                               movf     v____device_put_11+1,w;  1 OV rs rs [?? ??] 01a8 086b
                                                            ; W = v__pic_pointer
                               branchlo_clr l__pic_indirect ;  1 OV rs rs [?? ?l] 01a9 118a
                                                            ; W = v____device_put_11
                               call     l__pic_indirect     ;  1 OV rs ?? [?l ??] 01aa 20d3
                                                            ; W = v____device_put_11
;  218    device = nibble2hex[0x0F & (data>>4)]
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 01ab 1003
                               datalo_set v___data_22       ;  1 OV ?? ?S [?? ??] 01ac 1683
                               datahi_clr v___data_22       ;  1 OV ?S rS [?? ??] 01ad 1303
                               rrf      v___data_22+1,w     ;  1 OV rS rS [?? ??] 01ae 0c3e
                               movwf    v____temp_33+1      ;  1 OV rS rS [?? ??] 01af 00ce
                               rrf      v___data_22,w       ;  1 OV rS rS [?? ??] 01b0 0c3d
                                                            ; W = v____temp_33
                               movwf    v____temp_33        ;  1 OV rS rS [?? ??] 01b1 00cd
                               movlw    3                   ;  1 OV rS rS [?? ??] 01b2 3003
                                                            ; W = v____temp_33
                               datalo_clr v__pic_temp       ;  1 OV rS rs [?? ??] 01b3 1283
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01b4 00a0
l__l1152
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 01b5 1003
                               datalo_set v____temp_33      ;  1 OV rs rS [?? ??] 01b6 1683
                               rrf      v____temp_33+1,f    ;  1 OV rS rS [?? ??] 01b7 0cce
                               rrf      v____temp_33,f      ;  1 OV rS rS [?? ??] 01b8 0ccd
                               datalo_clr v__pic_temp       ;  1 OV rS rs [?? ??] 01b9 1283
                               branchlo_clr l__l1152        ;  1 OV rs rs [?? ?l] 01ba 118a
                               decfsz   v__pic_temp,f       ;  1 OV rs rs [?l ?l] 01bb 0ba0
                               goto     l__l1152            ;  1 OV rs rs [?l ?l] 01bc 29b5
                               movlw    15                  ;  1 OV rs rs [?l ?l] 01bd 300f
                               datalo_set v____temp_33      ;  1 OV rs rS [?l ?l] 01be 1683
                               andwf    v____temp_33,w      ;  1 OV rS rS [?l ?l] 01bf 054d
                               movwf    v____temp_33+2      ;  1 OV rS rS [?l ?l] 01c0 00cf
                               clrf     v____temp_33+3      ;  1 OV rS rS [?l ?l] 01c1 01d0
                                                            ; W = v____temp_33
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rS rS [?l ?l] 01c2 3000
                                                            ; W = v____temp_33
                               movwf    v__pclath           ;  1 OV rS rS [?l ?l] 01c3 008a
                               movf     v____temp_33+2,w    ;  1 OV rS rS [?l ?l] 01c4 084f
                               branchlo_nop l__lookup_nibble2hex;  1 OV rS rS [?l ?l] 01c5
                                                            ; W = v____temp_33
                               call     l__lookup_nibble2hex;  1 OV rS ?? [?l ??] 01c5 2014
                                                            ; W = v____temp_33
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 01c6 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 01c7 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01c8 00a0
                               movf     v____device_put_11,w;  1 OV rs rs [?? ??] 01c9 086a
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 01ca 00b6
                                                            ; W = v____device_put_11
                               movf     v____device_put_11+1,w;  1 OV rs rs [?? ??] 01cb 086b
                                                            ; W = v__pic_pointer
                               branchlo_clr l__pic_indirect ;  1 OV rs rs [?? ?l] 01cc 118a
                                                            ; W = v____device_put_11
                               call     l__pic_indirect     ;  1 OV rs ?? [?l ??] 01cd 20d3
                                                            ; W = v____device_put_11
;  219    device = nibble2hex[0x0F & (data)]
                               movlw    15                  ;  1 OV ?? ?? [?? ??] 01ce 300f
                               datalo_set v___data_22       ;  1 OV ?? ?S [?? ??] 01cf 1683
                               datahi_clr v___data_22       ;  1 OV ?S rS [?? ??] 01d0 1303
                               andwf    v___data_22,w       ;  1 OV rS rS [?? ??] 01d1 053d
                               movwf    v____temp_33        ;  1 OV rS rS [?? ??] 01d2 00cd
                               clrf     v____temp_33+1      ;  1 OV rS rS [?? ??] 01d3 01ce
                                                            ; W = v____temp_33
                               movlw    HIGH l__lookup_nibble2hex;  1 OV rS rS [?? ??] 01d4 3000
                                                            ; W = v____temp_33
                               movwf    v__pclath           ;  1 OV rS rS [?? ??] 01d5 008a
                               movf     v____temp_33,w      ;  1 OV rS rS [?? ??] 01d6 084d
                               branchlo_clr l__lookup_nibble2hex;  1 OV rS rS [?? ?l] 01d7 118a
                                                            ; W = v____temp_33
                               call     l__lookup_nibble2hex;  1 OV rS ?? [?l ??] 01d8 2014
                                                            ; W = v____temp_33
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 01d9 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 01da 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 01db 00a0
                               movf     v____device_put_11,w;  1 OV rs rs [?? ??] 01dc 086a
                                                            ; W = v__pic_temp
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 01dd 00b6
                                                            ; W = v____device_put_11
                               movf     v____device_put_11+1,w;  1 OV rs rs [?? ??] 01de 086b
                                                            ; W = v__pic_pointer
                               branchlo_clr l__pic_indirect ;  1 OV rs rs [?? ?l] 01df 118a
                                                            ; W = v____device_put_11
                               goto     l__pic_indirect     ;  1 OV rs rs [?l ?l] 01e0 28d3
                                                            ; W = v____device_put_11
;  221 end procedure
;  223 procedure print_byte_hex(volatile byte out device, byte in data) is             
l_print_byte_hex
                               datalo_clr v___data_24       ;  2 OV ?? rs [?l ?l] 01e1 1283
                               datahi_set v___data_24       ;  2 OV ?s Rs [?l ?l] 01e2 1703
                               movwf    v___data_24         ;  2 OV Rs Rs [?l ?l] 01e3 00b6
;  225    if (print_prefix) then
                               datahi_clr v__bitbucket ; print_prefix   ;  2 OV Rs rs [?l ?l] 01e4 1303
                                                            ; W = v___data_24
                               branchlo_nop l__l264         ;  2 OV rs rs [?l ?l] 01e5
                                                            ; W = v___data_24
                               btfss    v__bitbucket, 0 ; print_prefix  ;  2 OV rs rs [?l ?l] 01e5 1c65
                                                            ; W = v___data_24
                               goto     l__l264             ;  2 OV rs rs [?l ?l] 01e6 29fc
                                                            ; W = v___data_24
;  226       device = "0"
                               movlw    48                  ;  2 OV rs rs [?l ?l] 01e7 3030
                               movwf    v__pic_temp         ;  2 OV rs rs [?l ?l] 01e8 00a0
                               datahi_set v____device_put_12;  2 OV rs Rs [?l ?l] 01e9 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_12,w;  2 OV Rs Rs [?l ?l] 01ea 0832
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?l ?l] 01eb 1303
                                                            ; W = v____device_put_12
                               movwf    v__pic_pointer      ;  2 OV rs rs [?l ?l] 01ec 00b6
                                                            ; W = v____device_put_12
                               datahi_set v____device_put_12;  2 OV rs Rs [?l ?l] 01ed 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_12+1,w;  2 OV Rs Rs [?l ?l] 01ee 0833
                                                            ; W = v__pic_pointer
                               branchlo_nop l__pic_indirect ;  2 OV Rs Rs [?l ?l] 01ef
                                                            ; W = v____device_put_12
                               call     l__pic_indirect     ;  2 OV Rs ?? [?l ??] 01ef 20d3
                                                            ; W = v____device_put_12
;  227       device = "x"
                               movlw    120                 ;  2 OV ?? ?? [?? ??] 01f0 3078
                               datalo_clr v__pic_temp       ;  2 OV ?? ?s [?? ??] 01f1 1283
                               datahi_clr v__pic_temp       ;  2 OV ?s rs [?? ??] 01f2 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 01f3 00a0
                               datahi_set v____device_put_12;  2 OV rs Rs [?? ??] 01f4 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_12,w;  2 OV Rs Rs [?? ??] 01f5 0832
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?? ??] 01f6 1303
                                                            ; W = v____device_put_12
                               movwf    v__pic_pointer      ;  2 OV rs rs [?? ??] 01f7 00b6
                                                            ; W = v____device_put_12
                               datahi_set v____device_put_12;  2 OV rs Rs [?? ??] 01f8 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_12+1,w;  2 OV Rs Rs [?? ??] 01f9 0833
                                                            ; W = v__pic_pointer
                               branchlo_clr l__pic_indirect ;  2 OV Rs Rs [?? ?l] 01fa 118a
                                                            ; W = v____device_put_12
                               call     l__pic_indirect     ;  2 OV Rs ?? [?l ??] 01fb 20d3
                                                            ; W = v____device_put_12
;  228    end if
l__l264
;  230    device = nibble2hex[0x0F & (data>>4)]
                               datalo_clr v___data_24       ;  2 OV ?? ?s [?? ??] 01fc 1283
                                                            ; W = v___data_24
                               datahi_set v___data_24       ;  2 OV ?s Rs [?? ??] 01fd 1703
                                                            ; W = v___data_24
                               swapf    v___data_24,w       ;  2 OV Rs Rs [?? ??] 01fe 0e36
                                                            ; W = v___data_24
                               andlw    15                  ;  2 OV Rs Rs [?? ??] 01ff 390f
                               movwf    v____temp_34        ;  2 OV Rs Rs [?? ??] 0200 00b8
                               movlw    15                  ;  2 OV Rs Rs [?? ??] 0201 300f
                                                            ; W = v____temp_34
                               andwf    v____temp_34,w      ;  2 OV Rs Rs [?? ??] 0202 0538
                               movwf    v____temp_34+1      ;  2 OV Rs Rs [?? ??] 0203 00b9
                               movlw    HIGH l__lookup_nibble2hex;  2 OV Rs Rs [?? ??] 0204 3000
                                                            ; W = v____temp_34
                               movwf    v__pclath           ;  2 OV Rs Rs [?? ??] 0205 008a
                               movf     v____temp_34+1,w    ;  2 OV Rs Rs [?? ??] 0206 0839
                               branchlo_clr l__lookup_nibble2hex;  2 OV Rs Rs [?? ?l] 0207 118a
                                                            ; W = v____temp_34
                               call     l__lookup_nibble2hex;  2 OV Rs ?? [?l ??] 0208 2014
                                                            ; W = v____temp_34
                               datalo_clr v__pic_temp       ;  2 OV ?? ?s [?? ??] 0209 1283
                               datahi_clr v__pic_temp       ;  2 OV ?s rs [?? ??] 020a 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 020b 00a0
                               datahi_set v____device_put_12;  2 OV rs Rs [?? ??] 020c 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_12,w;  2 OV Rs Rs [?? ??] 020d 0832
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?? ??] 020e 1303
                                                            ; W = v____device_put_12
                               movwf    v__pic_pointer      ;  2 OV rs rs [?? ??] 020f 00b6
                                                            ; W = v____device_put_12
                               datahi_set v____device_put_12;  2 OV rs Rs [?? ??] 0210 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_12+1,w;  2 OV Rs Rs [?? ??] 0211 0833
                                                            ; W = v__pic_pointer
                               branchlo_clr l__pic_indirect ;  2 OV Rs Rs [?? ?l] 0212 118a
                                                            ; W = v____device_put_12
                               call     l__pic_indirect     ;  2 OV Rs ?? [?l ??] 0213 20d3
                                                            ; W = v____device_put_12
;  231    device = nibble2hex[0x0F & (data)]
                               movlw    15                  ;  2 OV ?? ?? [?? ??] 0214 300f
                               datalo_clr v___data_24       ;  2 OV ?? ?s [?? ??] 0215 1283
                               datahi_set v___data_24       ;  2 OV ?s Rs [?? ??] 0216 1703
                               andwf    v___data_24,w       ;  2 OV Rs Rs [?? ??] 0217 0536
                               movwf    v____temp_34        ;  2 OV Rs Rs [?? ??] 0218 00b8
                               movlw    HIGH l__lookup_nibble2hex;  2 OV Rs Rs [?? ??] 0219 3000
                                                            ; W = v____temp_34
                               movwf    v__pclath           ;  2 OV Rs Rs [?? ??] 021a 008a
                               movf     v____temp_34,w      ;  2 OV Rs Rs [?? ??] 021b 0838
                               branchlo_clr l__lookup_nibble2hex;  2 OV Rs Rs [?? ?l] 021c 118a
                                                            ; W = v____temp_34
                               call     l__lookup_nibble2hex;  2 OV Rs ?? [?l ??] 021d 2014
                                                            ; W = v____temp_34
                               datalo_clr v__pic_temp       ;  2 OV ?? ?s [?? ??] 021e 1283
                               datahi_clr v__pic_temp       ;  2 OV ?s rs [?? ??] 021f 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 0220 00a0
                               datahi_set v____device_put_12;  2 OV rs Rs [?? ??] 0221 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_12,w;  2 OV Rs Rs [?? ??] 0222 0832
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?? ??] 0223 1303
                                                            ; W = v____device_put_12
                               movwf    v__pic_pointer      ;  2 OV rs rs [?? ??] 0224 00b6
                                                            ; W = v____device_put_12
                               datahi_set v____device_put_12;  2 OV rs Rs [?? ??] 0225 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_12+1,w;  2 OV Rs Rs [?? ??] 0226 0833
                                                            ; W = v__pic_pointer
                               branchlo_clr l__pic_indirect ;  2 OV Rs Rs [?? ?l] 0227 118a
                                                            ; W = v____device_put_12
                               goto     l__pic_indirect     ;  2 OV Rs Rs [?l ?l] 0228 28d3
                                                            ; W = v____device_put_12
;  233 end procedure
;  241 procedure print_sword_dec(volatile byte out device, sword in data) is
l_print_sword_dec
;  243    _print_suniversal_dec(device, data, 10000, 5)
                               movf     v____device_put_14,w;  2 OV Rs Rs [?l ?l] 0229 0830
                                                            ; W = v___data_28
                               movwf    v____device_put_20  ;  2 OV Rs Rs [?l ?l] 022a 00b8
                                                            ; W = v____device_put_14
                               movf     v____device_put_14+1,w;  2 OV Rs Rs [?l ?l] 022b 0831
                                                            ; W = v____device_put_20
                               movwf    v____device_put_20+1;  2 OV Rs Rs [?l ?l] 022c 00b9
                                                            ; W = v____device_put_14
                               movf     v___data_28,w       ;  2 OV Rs Rs [?l ?l] 022d 0834
                                                            ; W = v____device_put_20
                               movwf    v___data_40         ;  2 OV Rs Rs [?l ?l] 022e 00bc
                                                            ; W = v___data_28
                               movf     v___data_28+1,w     ;  2 OV Rs Rs [?l ?l] 022f 0835
                                                            ; W = v___data_40
                               movwf    v___data_40+1       ;  2 OV Rs Rs [?l ?l] 0230 00bd
                                                            ; W = v___data_28
                               movlw    0                   ;  2 OV Rs Rs [?l ?l] 0231 3000
                                                            ; W = v___data_40
                               btfsc    v___data_40+1, 7    ;  2 OV Rs Rs [?l ?l] 0232 1bbd
                               movlw    255                 ;  2 OV Rs Rs [?l ?l] 0233 30ff
                               movwf    v___data_40+2       ;  2 OV Rs Rs [?l ?l] 0234 00be
                               movwf    v___data_40+3       ;  2 OV Rs Rs [?l ?l] 0235 00bf
                                                            ; W = v___data_40
                               movlw    16                  ;  2 OV Rs Rs [?l ?l] 0236 3010
                                                            ; W = v___data_40
                               movwf    v___digit_divisor_3 ;  2 OV Rs Rs [?l ?l] 0237 00c4
                               movlw    39                  ;  2 OV Rs Rs [?l ?l] 0238 3027
                                                            ; W = v___digit_divisor_3
                               movwf    v___digit_divisor_3+1;  2 OV Rs Rs [?l ?l] 0239 00c5
                               clrf     v___digit_divisor_3+2;  2 OV Rs Rs [?l ?l] 023a 01c6
                                                            ; W = v___digit_divisor_3
                               clrf     v___digit_divisor_3+3;  2 OV Rs Rs [?l ?l] 023b 01c7
                                                            ; W = v___digit_divisor_3
                               movlw    5                   ;  2 OV Rs Rs [?l ?l] 023c 3005
                                                            ; W = v___digit_divisor_3
                               branchlo_nop l__print_suniversal_dec;  2 OV Rs Rs [?l ?l] 023d
                               goto     l__print_suniversal_dec;  2 OV Rs Rs [?l ?l] 023d 2a62
;  245 end procedure
;  267 procedure print_word_dec(volatile byte out device, word in data) is
l_print_word_dec
;  269    _print_universal_dec(device, data, 10000, 5)
                               movf     v____device_put_18,w;  2 OV Rs Rs [?l ?l] 023e 0830
                                                            ; W = v___data_36
                               movwf    v____device_put_21  ;  2 OV Rs Rs [?l ?l] 023f 00ca
                                                            ; W = v____device_put_18
                               movf     v____device_put_18+1,w;  2 OV Rs Rs [?l ?l] 0240 0831
                                                            ; W = v____device_put_21
                               movwf    v____device_put_21+1;  2 OV Rs Rs [?l ?l] 0241 00cb
                                                            ; W = v____device_put_18
                               movf     v___data_36,w       ;  2 OV Rs Rs [?l ?l] 0242 0834
                                                            ; W = v____device_put_21
                               movwf    v___data_42         ;  2 OV Rs Rs [?l ?l] 0243 00cc
                                                            ; W = v___data_36
                               movf     v___data_36+1,w     ;  2 OV Rs Rs [?l ?l] 0244 0835
                                                            ; W = v___data_42
                               movwf    v___data_42+1       ;  2 OV Rs Rs [?l ?l] 0245 00cd
                                                            ; W = v___data_36
                               clrf     v___data_42+2       ;  2 OV Rs Rs [?l ?l] 0246 01ce
                                                            ; W = v___data_42
                               clrf     v___data_42+3       ;  2 OV Rs Rs [?l ?l] 0247 01cf
                                                            ; W = v___data_42
                               movlw    16                  ;  2 OV Rs Rs [?l ?l] 0248 3010
                                                            ; W = v___data_42
                               movwf    v___digit_divisor_5 ;  2 OV Rs Rs [?l ?l] 0249 00d0
                               movlw    39                  ;  2 OV Rs Rs [?l ?l] 024a 3027
                                                            ; W = v___digit_divisor_5
                               movwf    v___digit_divisor_5+1;  2 OV Rs Rs [?l ?l] 024b 00d1
                               clrf     v___digit_divisor_5+2;  2 OV Rs Rs [?l ?l] 024c 01d2
                                                            ; W = v___digit_divisor_5
                               clrf     v___digit_divisor_5+3;  2 OV Rs Rs [?l ?l] 024d 01d3
                                                            ; W = v___digit_divisor_5
                               movlw    5                   ;  2 OV Rs Rs [?l ?l] 024e 3005
                                                            ; W = v___digit_divisor_5
                               branchlo_nop l__print_universal_dec;  2 OV Rs Rs [?l ?l] 024f
                               goto     l__print_universal_dec;  2 OV Rs Rs [?l ?l] 024f 2aa9
;  271 end procedure
;  273 procedure print_byte_dec(volatile byte out device, byte in data) is
l_print_byte_dec
                               datahi_set v___data_38       ;  2 OV rs Rs [?l ?l] 0250 1703
                               movwf    v___data_38         ;  2 OV Rs Rs [?l ?l] 0251 00b4
;  275    _print_universal_dec(device, data, 100, 3)
                               movf     v____device_put_19,w;  2 OV Rs Rs [?l ?l] 0252 0830
                                                            ; W = v___data_38
                               movwf    v____device_put_21  ;  2 OV Rs Rs [?l ?l] 0253 00ca
                                                            ; W = v____device_put_19
                               movf     v____device_put_19+1,w;  2 OV Rs Rs [?l ?l] 0254 0831
                                                            ; W = v____device_put_21
                               movwf    v____device_put_21+1;  2 OV Rs Rs [?l ?l] 0255 00cb
                                                            ; W = v____device_put_19
                               movf     v___data_38,w       ;  2 OV Rs Rs [?l ?l] 0256 0834
                                                            ; W = v____device_put_21
                               movwf    v___data_42         ;  2 OV Rs Rs [?l ?l] 0257 00cc
                                                            ; W = v___data_38
                               clrf     v___data_42+1       ;  2 OV Rs Rs [?l ?l] 0258 01cd
                                                            ; W = v___data_42
                               clrf     v___data_42+2       ;  2 OV Rs Rs [?l ?l] 0259 01ce
                                                            ; W = v___data_42
                               clrf     v___data_42+3       ;  2 OV Rs Rs [?l ?l] 025a 01cf
                                                            ; W = v___data_42
                               movlw    100                 ;  2 OV Rs Rs [?l ?l] 025b 3064
                                                            ; W = v___data_42
                               movwf    v___digit_divisor_5 ;  2 OV Rs Rs [?l ?l] 025c 00d0
                               clrf     v___digit_divisor_5+1;  2 OV Rs Rs [?l ?l] 025d 01d1
                                                            ; W = v___digit_divisor_5
                               clrf     v___digit_divisor_5+2;  2 OV Rs Rs [?l ?l] 025e 01d2
                                                            ; W = v___digit_divisor_5
                               clrf     v___digit_divisor_5+3;  2 OV Rs Rs [?l ?l] 025f 01d3
                                                            ; W = v___digit_divisor_5
                               movlw    3                   ;  2 OV Rs Rs [?l ?l] 0260 3003
                                                            ; W = v___digit_divisor_5
                               branchlo_nop l__print_universal_dec;  2 OV Rs Rs [?l ?l] 0261
                               goto     l__print_universal_dec;  2 OV Rs Rs [?l ?l] 0261 2aa9
;  277 end procedure
;  282 procedure _print_suniversal_dec(volatile byte out device, sdword in data, sdword in digit_divisor, byte in digit_number) is
l__print_suniversal_dec
                               movwf    v___digit_number_3  ;  2 OV Rs Rs [?l ?l] 0262 00c9
;  284    if (data < 0) then
                               movf     v___data_40+3,w     ;  2 OV Rs Rs [?l ?l] 0263 083f
                                                            ; W = v___digit_number_3
                               xorlw    128                 ;  2 OV Rs Rs [?l ?l] 0264 3a80
                                                            ; W = v___data_40
                               datahi_clr v__pic_temp       ;  2 OV Rs rs [?l ?l] 0265 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?l ?l] 0266 00a0
                               movlw    128                 ;  2 OV rs rs [?l ?l] 0267 3080
                                                            ; W = v__pic_temp
                               subwf    v__pic_temp,w       ;  2 OV rs rs [?l ?l] 0268 0220
                               branchlo_nop l__l1153        ;  2 OV rs rs [?l ?l] 0269
                               btfss    v__status, v__z     ;  2 OV rs rs [?l ?l] 0269 1d03
                               goto     l__l1153            ;  2 OV rs rs [?l ?l] 026a 2a76
                               movlw    0                   ;  2 OV rs rs [?l ?l] 026b 3000
                               datahi_set v___data_40       ;  2 OV rs Rs [?l ?l] 026c 1703
                               subwf    v___data_40+2,w     ;  2 OV Rs Rs [?l ?l] 026d 023e
                               branchlo_nop l__l1153        ;  2 OV Rs Rs [?l ?l] 026e
                               btfss    v__status, v__z     ;  2 OV Rs Rs [?l ?l] 026e 1d03
                               goto     l__l1153            ;  2 OV Rs Rs [?l ?l] 026f 2a76
                               movlw    0                   ;  2 OV Rs Rs [?l ?l] 0270 3000
                               subwf    v___data_40+1,w     ;  2 OV Rs Rs [?l ?l] 0271 023d
                               branchlo_nop l__l1153        ;  2 OV Rs Rs [?l ?l] 0272
                               btfss    v__status, v__z     ;  2 OV Rs Rs [?l ?l] 0272 1d03
                               goto     l__l1153            ;  2 OV Rs Rs [?l ?l] 0273 2a76
                               movlw    0                   ;  2 OV Rs Rs [?l ?l] 0274 3000
                               subwf    v___data_40,w       ;  2 OV Rs Rs [?l ?l] 0275 023c
l__l1153
                               branchlo_nop l__l280         ;  2 OV ?s Rs [?l ?l] 0276
                               btfsc    v__status, v__z     ;  2 OV ?s Rs [?l ?l] 0276 1903
                               goto     l__l280             ;  2 OV ?s Rs [?l ?l] 0277 2a90
                               branchlo_nop l__l280         ;  2 OV ?s Rs [?l ?l] 0278
                               btfsc    v__status, v__c     ;  2 OV ?s Rs [?l ?l] 0278 1803
                               goto     l__l280             ;  2 OV ?s Rs [?l ?l] 0279 2a90
;  285       data = -data
                               datahi_set v___data_40       ;  2 OV ?s Rs [?l ?l] 027a 1703
                               comf     v___data_40,f       ;  2 OV Rs Rs [?l ?l] 027b 09bc
                               comf     v___data_40+1,f     ;  2 OV Rs Rs [?l ?l] 027c 09bd
                               comf     v___data_40+2,f     ;  2 OV Rs Rs [?l ?l] 027d 09be
                               comf     v___data_40+3,f     ;  2 OV Rs Rs [?l ?l] 027e 09bf
                               incf     v___data_40,f       ;  2 OV Rs Rs [?l ?l] 027f 0abc
                               btfsc    v__status, v__z     ;  2 OV Rs Rs [?l ?l] 0280 1903
                               incf     v___data_40+1,f     ;  2 OV Rs Rs [?l ?l] 0281 0abd
                               btfsc    v__status, v__z     ;  2 OV Rs Rs [?l ?l] 0282 1903
                               incf     v___data_40+2,f     ;  2 OV Rs Rs [?l ?l] 0283 0abe
                               btfsc    v__status, v__z     ;  2 OV Rs Rs [?l ?l] 0284 1903
                               incf     v___data_40+3,f     ;  2 OV Rs Rs [?l ?l] 0285 0abf
;  286       device = "-"      
                               movlw    45                  ;  2 OV Rs Rs [?l ?l] 0286 302d
                               datahi_clr v__pic_temp       ;  2 OV Rs rs [?l ?l] 0287 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?l ?l] 0288 00a0
                               datahi_set v____device_put_20;  2 OV rs Rs [?l ?l] 0289 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_20,w;  2 OV Rs Rs [?l ?l] 028a 0838
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?l ?l] 028b 1303
                                                            ; W = v____device_put_20
                               movwf    v__pic_pointer      ;  2 OV rs rs [?l ?l] 028c 00b6
                                                            ; W = v____device_put_20
                               datahi_set v____device_put_20;  2 OV rs Rs [?l ?l] 028d 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_20+1,w;  2 OV Rs Rs [?l ?l] 028e 0839
                                                            ; W = v__pic_pointer
                               branchlo_nop l__pic_indirect ;  2 OV Rs Rs [?l ?l] 028f
                                                            ; W = v____device_put_20
                               call     l__pic_indirect     ;  2 OV Rs ?? [?l ??] 028f 20d3
                                                            ; W = v____device_put_20
;  287    end if
l__l280
;  289    _print_universal_dec(device, dword( data ), digit_divisor, digit_number)
                               datalo_clr v____device_put_20;  2 OV ?? ?s [?? ??] 0290 1283
                               datahi_set v____device_put_20;  2 OV ?s Rs [?? ??] 0291 1703
                               movf     v____device_put_20,w;  2 OV Rs Rs [?? ??] 0292 0838
                               movwf    v____device_put_21  ;  2 OV Rs Rs [?? ??] 0293 00ca
                                                            ; W = v____device_put_20
                               movf     v____device_put_20+1,w;  2 OV Rs Rs [?? ??] 0294 0839
                                                            ; W = v____device_put_21
                               movwf    v____device_put_21+1;  2 OV Rs Rs [?? ??] 0295 00cb
                                                            ; W = v____device_put_20
                               movf     v___data_40,w       ;  2 OV Rs Rs [?? ??] 0296 083c
                                                            ; W = v____device_put_21
                               movwf    v___data_42         ;  2 OV Rs Rs [?? ??] 0297 00cc
                                                            ; W = v___data_40
                               movf     v___data_40+1,w     ;  2 OV Rs Rs [?? ??] 0298 083d
                                                            ; W = v___data_42
                               movwf    v___data_42+1       ;  2 OV Rs Rs [?? ??] 0299 00cd
                                                            ; W = v___data_40
                               movf     v___data_40+2,w     ;  2 OV Rs Rs [?? ??] 029a 083e
                                                            ; W = v___data_42
                               movwf    v___data_42+2       ;  2 OV Rs Rs [?? ??] 029b 00ce
                                                            ; W = v___data_40
                               movf     v___data_40+3,w     ;  2 OV Rs Rs [?? ??] 029c 083f
                                                            ; W = v___data_42
                               movwf    v___data_42+3       ;  2 OV Rs Rs [?? ??] 029d 00cf
                                                            ; W = v___data_40
                               movf     v___digit_divisor_3,w;  2 OV Rs Rs [?? ??] 029e 0844
                                                            ; W = v___data_42
                               movwf    v___digit_divisor_5 ;  2 OV Rs Rs [?? ??] 029f 00d0
                                                            ; W = v___digit_divisor_3
                               movf     v___digit_divisor_3+1,w;  2 OV Rs Rs [?? ??] 02a0 0845
                                                            ; W = v___digit_divisor_5
                               movwf    v___digit_divisor_5+1;  2 OV Rs Rs [?? ??] 02a1 00d1
                                                            ; W = v___digit_divisor_3
                               movf     v___digit_divisor_3+2,w;  2 OV Rs Rs [?? ??] 02a2 0846
                                                            ; W = v___digit_divisor_5
                               movwf    v___digit_divisor_5+2;  2 OV Rs Rs [?? ??] 02a3 00d2
                                                            ; W = v___digit_divisor_3
                               movf     v___digit_divisor_3+3,w;  2 OV Rs Rs [?? ??] 02a4 0847
                                                            ; W = v___digit_divisor_5
                               movwf    v___digit_divisor_5+3;  2 OV Rs Rs [?? ??] 02a5 00d3
                                                            ; W = v___digit_divisor_3
                               movf     v___digit_number_3,w;  2 OV Rs Rs [?? ??] 02a6 0849
                                                            ; W = v___digit_divisor_5
                               branchlo_clr l__print_universal_dec;  2 OV Rs Rs [?? ?l] 02a7 118a
                                                            ; W = v___digit_number_3
                               goto     l__print_universal_dec;  2 OV Rs Rs [?l ?l] 02a8 2aa9
                                                            ; W = v___digit_number_3
;  291 end procedure
;  294 procedure _print_universal_dec(volatile byte out device, dword in data, sdword in digit_divisor, byte in digit_number) is
l__print_universal_dec
                               movwf    v___digit_number_5  ;  2 OV Rs Rs [?l ?l] 02a9 00d4
                                                            ; W = v___digit_number_3
;  298    if (data == 0) then
                               movf     v___data_42,w       ;  2 OV Rs Rs [?l ?l] 02aa 084c
                                                            ; W = v___digit_number_5
                               iorwf    v___data_42+1,w     ;  2 OV Rs Rs [?l ?l] 02ab 044d
                                                            ; W = v___data_42
                               iorwf    v___data_42+2,w     ;  2 OV Rs Rs [?l ?l] 02ac 044e
                               iorwf    v___data_42+3,w     ;  2 OV Rs Rs [?l ?l] 02ad 044f
                               branchlo_nop l__l282         ;  2 OV Rs Rs [?l ?l] 02ae
                               btfss    v__status, v__z     ;  2 OV Rs Rs [?l ?l] 02ae 1d03
                               goto     l__l282             ;  2 OV Rs Rs [?l ?l] 02af 2aba
;  299       device = "0"      
                               movlw    48                  ;  2 OV Rs Rs [?l ?l] 02b0 3030
                               datahi_clr v__pic_temp       ;  2 OV Rs rs [?l ?l] 02b1 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?l ?l] 02b2 00a0
                               datahi_set v____device_put_21;  2 OV rs Rs [?l ?l] 02b3 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_21,w;  2 OV Rs Rs [?l ?l] 02b4 084a
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?l ?l] 02b5 1303
                                                            ; W = v____device_put_21
                               movwf    v__pic_pointer      ;  2 OV rs rs [?l ?l] 02b6 00b6
                                                            ; W = v____device_put_21
                               datahi_set v____device_put_21;  2 OV rs Rs [?l ?l] 02b7 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_21+1,w;  2 OV Rs Rs [?l ?l] 02b8 084b
                                                            ; W = v__pic_pointer
                               branchlo_nop l__pic_indirect ;  2 OV Rs Rs [?l ?l] 02b9
                                                            ; W = v____device_put_21
                               goto     l__pic_indirect     ;  2 OV Rs Rs [?l ?l] 02b9 28d3
                                                            ; W = v____device_put_21
;  300       return
;  301    end if
l__l282
;  303    no_digits_printed_yet = true
                               bsf      v____bitbucket_92, 0 ; no_digits_printed_yet;  2 OV Rs Rs [?l ?l] 02ba 1457
;  304    while (digit_divisor > 0) loop
l__l283
                               movf     v___digit_divisor_5+3,w;  2 OV Rs Rs [?l ?l] 02bb 0853
                                                            ; W = v_digit
                               xorlw    128                 ;  2 OV Rs Rs [?l ?l] 02bc 3a80
                                                            ; W = v___digit_divisor_5
                               datahi_clr v__pic_temp       ;  2 OV Rs rs [?l ?l] 02bd 1303
                               movwf    v__pic_temp         ;  2 OV rs rs [?l ?l] 02be 00a0
                               movlw    128                 ;  2 OV rs rs [?l ?l] 02bf 3080
                                                            ; W = v__pic_temp
                               subwf    v__pic_temp,w       ;  2 OV rs rs [?l ?l] 02c0 0220
                               branchlo_nop l__l1155        ;  2 OV rs rs [?l ?l] 02c1
                               btfss    v__status, v__z     ;  2 OV rs rs [?l ?l] 02c1 1d03
                               goto     l__l1155            ;  2 OV rs rs [?l ?l] 02c2 2ace
                               movlw    0                   ;  2 OV rs rs [?l ?l] 02c3 3000
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?l ?l] 02c4 1703
                               subwf    v___digit_divisor_5+2,w;  2 OV Rs Rs [?l ?l] 02c5 0252
                               branchlo_nop l__l1155        ;  2 OV Rs Rs [?l ?l] 02c6
                               btfss    v__status, v__z     ;  2 OV Rs Rs [?l ?l] 02c6 1d03
                               goto     l__l1155            ;  2 OV Rs Rs [?l ?l] 02c7 2ace
                               movlw    0                   ;  2 OV Rs Rs [?l ?l] 02c8 3000
                               subwf    v___digit_divisor_5+1,w;  2 OV Rs Rs [?l ?l] 02c9 0251
                               branchlo_nop l__l1155        ;  2 OV Rs Rs [?l ?l] 02ca
                               btfss    v__status, v__z     ;  2 OV Rs Rs [?l ?l] 02ca 1d03
                               goto     l__l1155            ;  2 OV Rs Rs [?l ?l] 02cb 2ace
                               movlw    0                   ;  2 OV Rs Rs [?l ?l] 02cc 3000
                               subwf    v___digit_divisor_5,w;  2 OV Rs Rs [?l ?l] 02cd 0250
l__l1155
                               branchlo_nop l__l284         ;  2 OV ?s Rs [?l ?l] 02ce
                               btfsc    v__status, v__z     ;  2 OV ?s Rs [?l ?l] 02ce 1903
                               goto     l__l284             ;  2 OV ?s Rs [?l ?l] 02cf 2b52
                               branchlo_nop l__l284         ;  2 OV ?s Rs [?l ?l] 02d0
                               btfss    v__status, v__c     ;  2 OV ?s Rs [?l ?l] 02d0 1c03
                               goto     l__l284             ;  2 OV ?s Rs [?l ?l] 02d1 2b52
;  305       digit = byte ( data / digit_divisor )
                               datahi_set v___digit_divisor_5;  2 OV ?s Rs [?l ?l] 02d2 1703
                               movf     v___digit_divisor_5,w;  2 OV Rs Rs [?l ?l] 02d3 0850
                               datahi_clr v__pic_divisor    ;  2 OV Rs rs [?l ?l] 02d4 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor      ;  2 OV rs rs [?l ?l] 02d5 00a8
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?l ?l] 02d6 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+1,w;  2 OV Rs Rs [?l ?l] 02d7 0851
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_divisor    ;  2 OV Rs rs [?l ?l] 02d8 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+1    ;  2 OV rs rs [?l ?l] 02d9 00a9
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?l ?l] 02da 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+2,w;  2 OV Rs Rs [?l ?l] 02db 0852
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_divisor    ;  2 OV Rs rs [?l ?l] 02dc 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+2    ;  2 OV rs rs [?l ?l] 02dd 00aa
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?l ?l] 02de 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5+3,w;  2 OV Rs Rs [?l ?l] 02df 0853
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_divisor    ;  2 OV Rs rs [?l ?l] 02e0 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_divisor+3    ;  2 OV rs rs [?l ?l] 02e1 00ab
                                                            ; W = v___digit_divisor_5
                               datahi_set v___data_42       ;  2 OV rs Rs [?l ?l] 02e2 1703
                                                            ; W = v__pic_divisor
                               movf     v___data_42,w       ;  2 OV Rs Rs [?l ?l] 02e3 084c
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_dividend   ;  2 OV Rs rs [?l ?l] 02e4 1303
                                                            ; W = v___data_42
                               movwf    v__pic_dividend     ;  2 OV rs rs [?l ?l] 02e5 00a0
                                                            ; W = v___data_42
                               datahi_set v___data_42       ;  2 OV rs Rs [?l ?l] 02e6 1703
                                                            ; W = v__pic_dividend
                               movf     v___data_42+1,w     ;  2 OV Rs Rs [?l ?l] 02e7 084d
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  2 OV Rs rs [?l ?l] 02e8 1303
                                                            ; W = v___data_42
                               movwf    v__pic_dividend+1   ;  2 OV rs rs [?l ?l] 02e9 00a1
                                                            ; W = v___data_42
                               datahi_set v___data_42       ;  2 OV rs Rs [?l ?l] 02ea 1703
                                                            ; W = v__pic_dividend
                               movf     v___data_42+2,w     ;  2 OV Rs Rs [?l ?l] 02eb 084e
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  2 OV Rs rs [?l ?l] 02ec 1303
                                                            ; W = v___data_42
                               movwf    v__pic_dividend+2   ;  2 OV rs rs [?l ?l] 02ed 00a2
                                                            ; W = v___data_42
                               datahi_set v___data_42       ;  2 OV rs Rs [?l ?l] 02ee 1703
                                                            ; W = v__pic_dividend
                               movf     v___data_42+3,w     ;  2 OV Rs Rs [?l ?l] 02ef 084f
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  2 OV Rs rs [?l ?l] 02f0 1303
                                                            ; W = v___data_42
                               movwf    v__pic_dividend+3   ;  2 OV rs rs [?l ?l] 02f1 00a3
                                                            ; W = v___data_42
                               branchlo_nop l__pic_divide   ;  2 OV rs rs [?l ?l] 02f2
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  2 OV rs ?? [?l ??] 02f2 206f
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  2 OV ?? ?s [?? ??] 02f3 1283
                               datahi_clr v__pic_quotient   ;  2 OV ?s rs [?? ??] 02f4 1303
                               movf     v__pic_quotient,w   ;  2 OV rs rs [?? ??] 02f5 082c
                               datahi_set v_digit           ;  2 OV rs Rs [?? ??] 02f6 1703
                                                            ; W = v__pic_quotient
                               movwf    v_digit             ;  2 OV Rs Rs [?? ??] 02f7 00d5
                                                            ; W = v__pic_quotient
;  306       data = data % digit_divisor
                               datahi_clr v__pic_remainder  ;  2 OV Rs rs [?? ??] 02f8 1303
                                                            ; W = v_digit
                               movf     v__pic_remainder,w  ;  2 OV rs rs [?? ??] 02f9 0824
                                                            ; W = v_digit
                               datahi_set v___data_42       ;  2 OV rs Rs [?? ??] 02fa 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_42         ;  2 OV Rs Rs [?? ??] 02fb 00cc
                                                            ; W = v__pic_remainder
                               datahi_clr v__pic_remainder  ;  2 OV Rs rs [?? ??] 02fc 1303
                                                            ; W = v___data_42
                               movf     v__pic_remainder+1,w;  2 OV rs rs [?? ??] 02fd 0825
                                                            ; W = v___data_42
                               datahi_set v___data_42       ;  2 OV rs Rs [?? ??] 02fe 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_42+1       ;  2 OV Rs Rs [?? ??] 02ff 00cd
                                                            ; W = v__pic_remainder
                               datahi_clr v__pic_remainder  ;  2 OV Rs rs [?? ??] 0300 1303
                                                            ; W = v___data_42
                               movf     v__pic_remainder+2,w;  2 OV rs rs [?? ??] 0301 0826
                                                            ; W = v___data_42
                               datahi_set v___data_42       ;  2 OV rs Rs [?? ??] 0302 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_42+2       ;  2 OV Rs Rs [?? ??] 0303 00ce
                                                            ; W = v__pic_remainder
                               datahi_clr v__pic_remainder  ;  2 OV Rs rs [?? ??] 0304 1303
                                                            ; W = v___data_42
                               movf     v__pic_remainder+3,w;  2 OV rs rs [?? ??] 0305 0827
                                                            ; W = v___data_42
                               datahi_set v___data_42       ;  2 OV rs Rs [?? ??] 0306 1703
                                                            ; W = v__pic_remainder
                               movwf    v___data_42+3       ;  2 OV Rs Rs [?? ??] 0307 00cf
                                                            ; W = v__pic_remainder
;  307       digit_divisor = digit_divisor / 10
                               movlw    10                  ;  2 OV Rs Rs [?? ??] 0308 300a
                                                            ; W = v___data_42
                               datahi_clr v__pic_divisor    ;  2 OV Rs rs [?? ??] 0309 1303
                               movwf    v__pic_divisor      ;  2 OV rs rs [?? ??] 030a 00a8
                               clrf     v__pic_divisor+1    ;  2 OV rs rs [?? ??] 030b 01a9
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+2    ;  2 OV rs rs [?? ??] 030c 01aa
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+3    ;  2 OV rs rs [?? ??] 030d 01ab
                                                            ; W = v__pic_divisor
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?? ??] 030e 1703
                                                            ; W = v__pic_divisor
                               movf     v___digit_divisor_5,w;  2 OV Rs Rs [?? ??] 030f 0850
                                                            ; W = v__pic_divisor
                               datahi_clr v__pic_dividend   ;  2 OV Rs rs [?? ??] 0310 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend     ;  2 OV rs rs [?? ??] 0311 00a0
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?? ??] 0312 1703
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+1,w;  2 OV Rs Rs [?? ??] 0313 0851
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  2 OV Rs rs [?? ??] 0314 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+1   ;  2 OV rs rs [?? ??] 0315 00a1
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?? ??] 0316 1703
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+2,w;  2 OV Rs Rs [?? ??] 0317 0852
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  2 OV Rs rs [?? ??] 0318 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+2   ;  2 OV rs rs [?? ??] 0319 00a2
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?? ??] 031a 1703
                                                            ; W = v__pic_dividend
                               movf     v___digit_divisor_5+3,w;  2 OV Rs Rs [?? ??] 031b 0853
                                                            ; W = v__pic_dividend
                               datahi_clr v__pic_dividend   ;  2 OV Rs rs [?? ??] 031c 1303
                                                            ; W = v___digit_divisor_5
                               movwf    v__pic_dividend+3   ;  2 OV rs rs [?? ??] 031d 00a3
                                                            ; W = v___digit_divisor_5
                               branchlo_clr l__pic_sdivide  ;  2 OV rs rs [?? ?l] 031e 118a
                                                            ; W = v__pic_dividend
                               call     l__pic_sdivide      ;  2 OV rs ?? [?l ??] 031f 204e
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  2 OV ?? ?s [?? ??] 0320 1283
                               datahi_clr v__pic_quotient   ;  2 OV ?s rs [?? ??] 0321 1303
                               movf     v__pic_quotient,w   ;  2 OV rs rs [?? ??] 0322 082c
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?? ??] 0323 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5 ;  2 OV Rs Rs [?? ??] 0324 00d0
                                                            ; W = v__pic_quotient
                               datahi_clr v__pic_quotient   ;  2 OV Rs rs [?? ??] 0325 1303
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+1,w ;  2 OV rs rs [?? ??] 0326 082d
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?? ??] 0327 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+1;  2 OV Rs Rs [?? ??] 0328 00d1
                                                            ; W = v__pic_quotient
                               datahi_clr v__pic_quotient   ;  2 OV Rs rs [?? ??] 0329 1303
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+2,w ;  2 OV rs rs [?? ??] 032a 082e
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?? ??] 032b 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+2;  2 OV Rs Rs [?? ??] 032c 00d2
                                                            ; W = v__pic_quotient
                               datahi_clr v__pic_quotient   ;  2 OV Rs rs [?? ??] 032d 1303
                                                            ; W = v___digit_divisor_5
                               movf     v__pic_quotient+3,w ;  2 OV rs rs [?? ??] 032e 082f
                                                            ; W = v___digit_divisor_5
                               datahi_set v___digit_divisor_5;  2 OV rs Rs [?? ??] 032f 1703
                                                            ; W = v__pic_quotient
                               movwf    v___digit_divisor_5+3;  2 OV Rs Rs [?? ??] 0330 00d3
                                                            ; W = v__pic_quotient
;  309       if ((digit != 0) | (no_digits_printed_yet == false)) then
                               movf     v_digit,w           ;  2 OV Rs Rs [?? ??] 0331 0855
                                                            ; W = v___digit_divisor_5
                               bsf      v____bitbucket_92, 3 ; _btemp21;  2 OV Rs Rs [?? ??] 0332 15d7
                                                            ; W = v_digit
                               btfsc    v__status, v__z     ;  2 OV Rs Rs [?? ??] 0333 1903
                                                            ; W = v_digit
                               bcf      v____bitbucket_92, 3 ; _btemp21;  2 OV Rs Rs [?? ??] 0334 11d7
                                                            ; W = v_digit
                               bcf      v____bitbucket_92, 4 ; _btemp22;  2 OV Rs Rs [?? ??] 0335 1257
                                                            ; W = v_digit
                               btfss    v____bitbucket_92, 0 ; no_digits_printed_yet;  2 OV Rs Rs [?? ??] 0336 1c57
                                                            ; W = v_digit
                               bsf      v____bitbucket_92, 4 ; _btemp22;  2 OV Rs Rs [?? ??] 0337 1657
                                                            ; W = v_digit
                               bcf      v____bitbucket_92, 5 ; _btemp23;  2 OV Rs Rs [?? ??] 0338 12d7
                                                            ; W = v_digit
                               btfss    v____bitbucket_92, 3 ; _btemp21;  2 OV Rs Rs [?? ??] 0339 1dd7
                                                            ; W = v_digit
                               btfsc    v____bitbucket_92, 4 ; _btemp22;  2 OV Rs Rs [?? ??] 033a 1a57
                                                            ; W = v_digit
                               bsf      v____bitbucket_92, 5 ; _btemp23;  2 OV Rs Rs [?? ??] 033b 16d7
                                                            ; W = v_digit
                               branchlo_clr l__l287         ;  2 OV Rs Rs [?? ?l] 033c 118a
                                                            ; W = v_digit
                               btfss    v____bitbucket_92, 5 ; _btemp23;  2 OV Rs Rs [?l ?l] 033d 1ed7
                                                            ; W = v_digit
                               goto     l__l287             ;  2 OV Rs Rs [?l ?l] 033e 2b4f
                                                            ; W = v_digit
;  310          device = digit | "0"
                               movlw    48                  ;  2 OV Rs Rs [?l ?l] 033f 3030
                               iorwf    v_digit,w           ;  2 OV Rs Rs [?l ?l] 0340 0455
                               movwf    v____temp_37        ;  2 OV Rs Rs [?l ?l] 0341 00d6
                               movf     v____temp_37,w      ;  2 OV Rs Rs [?l ?l] 0342 0856
                                                            ; W = v____temp_37
                               datahi_clr v__pic_temp       ;  2 OV Rs rs [?l ?l] 0343 1303
                                                            ; W = v____temp_37
                               movwf    v__pic_temp         ;  2 OV rs rs [?l ?l] 0344 00a0
                                                            ; W = v____temp_37
                               datahi_set v____device_put_21;  2 OV rs Rs [?l ?l] 0345 1703
                                                            ; W = v__pic_temp
                               movf     v____device_put_21,w;  2 OV Rs Rs [?l ?l] 0346 084a
                                                            ; W = v__pic_temp
                               datahi_clr v__pic_pointer    ;  2 OV Rs rs [?l ?l] 0347 1303
                                                            ; W = v____device_put_21
                               movwf    v__pic_pointer      ;  2 OV rs rs [?l ?l] 0348 00b6
                                                            ; W = v____device_put_21
                               datahi_set v____device_put_21;  2 OV rs Rs [?l ?l] 0349 1703
                                                            ; W = v__pic_pointer
                               movf     v____device_put_21+1,w;  2 OV Rs Rs [?l ?l] 034a 084b
                                                            ; W = v__pic_pointer
                               branchlo_nop l__pic_indirect ;  2 OV Rs Rs [?l ?l] 034b
                                                            ; W = v____device_put_21
                               call     l__pic_indirect     ;  2 OV Rs ?? [?l ??] 034b 20d3
                                                            ; W = v____device_put_21
;  311          no_digits_printed_yet = false
                               datalo_clr v____bitbucket_92 ; no_digits_printed_yet;  2 OV ?? ?s [?? ??] 034c 1283
                               datahi_set v____bitbucket_92 ; no_digits_printed_yet;  2 OV ?s Rs [?? ??] 034d 1703
                               bcf      v____bitbucket_92, 0 ; no_digits_printed_yet;  2 OV Rs Rs [?? ??] 034e 1057
;  312       end if
l__l287
;  313       digit_number = digit_number - 1
                               decf     v___digit_number_5,f;  2 OV Rs Rs [?? ??] 034f 03d4
                                                            ; W = v_digit
;  314    end loop
                               branchlo_clr l__l283         ;  2 OV Rs Rs [?? ?l] 0350 118a
                                                            ; W = v_digit
                               goto     l__l283             ;  2 OV Rs Rs [?l ?l] 0351 2abb
                                                            ; W = v_digit
l__l284
;  316 end procedure
l__l202
                               return                       ;  2 OV ?s Rs [?l ?l] 0352 0008
; usart_common.jal
;   43 procedure _calculate_and_set_baudrate() is
l__calculate_and_set_baudrate
;   99                SPBRG = usart_div 
                               movlw    10                  ;  2 OV rs rs [hl hl] 0353 300a
                                                            ; W = v__portb_shadow
                               datalo_set v_spbrg           ;  2 OV rs rS [hl hl] 0354 1683
                               movwf    v_spbrg             ;  2 OV rS rS [hl hl] 0355 0099
;  103             TXSTA_BRGH = true
                               bsf      v_txsta, 2 ; txsta_brgh       ;  2 OV rS rS [hl hl] 0356 1518
;  152 end procedure
                               return                       ;  2 OV rS rS [hl hl] 0357 0008
; serial_hardware.jal
;   25 procedure serial_hw_init() is 
l_serial_hw_init
;   27    _calculate_and_set_baudrate()
                               branchlo_nop l__calculate_and_set_baudrate;  1 OV rs rs [hl hl] 0358
                                                            ; W = v__portb_shadow
                               call     l__calculate_and_set_baudrate;  1 OV rs ?? [hl ??] 0358 2353
                                                            ; W = v__portb_shadow
;   30    PIE1_RCIE = false
                               datalo_set v_pie1 ; pie1_rcie         ;  1 OV ?? ?S [?? ??] 0359 1683
                               datahi_clr v_pie1 ; pie1_rcie         ;  1 OV ?S rS [?? ??] 035a 1303
                               bcf      v_pie1, 5 ; pie1_rcie        ;  1 OV rS rS [?? ??] 035b 128c
;   31    PIE1_TXIE = false
                               bcf      v_pie1, 4 ; pie1_txie        ;  1 OV rS rS [?? ??] 035c 120c
;   34    TXSTA_TXEN = true
                               bsf      v_txsta, 5 ; txsta_txen       ;  1 OV rS rS [?? ??] 035d 1698
;   38    RCSTA = 0x90
                               movlw    144                 ;  1 OV rS rS [?? ??] 035e 3090
                               datalo_clr v_rcsta           ;  1 OV rS rs [?? ??] 035f 1283
                               movwf    v_rcsta             ;  1 OV rs rs [?? ??] 0360 0098
;   40 end procedure
                               return                       ;  1 OV rs rs [?? ??] 0361 0008
;   67 procedure serial_hw_write(byte in data) is
l_serial_hw_write
                               movwf    v___data_44         ;  2 OV rs rs [?l ?l] 0362 00c1
                                                            ; W = v___data_52
;   69    while ! PIR1_TXIF loop end loop
l__l313
                               branchlo_nop l__l314         ;  2 OV rs rs [?l ?l] 0363
                                                            ; W = v___data_44
                               btfsc    v_pir1, 4 ; pir1_txif        ;  2 OV rs rs [?l ?l] 0363 1a0c
                                                            ; W = v___data_44
                               goto     l__l314             ;  2 OV rs rs [?l ?l] 0364 2b66
                                                            ; W = v___data_44
                               branchlo_nop l__l313         ;  2 OV rs rs [?l ?l] 0365
                               goto     l__l313             ;  2 OV rs rs [?l ?l] 0365 2b63
l__l314
;   71    TXREG = data
                               movf     v___data_44,w       ;  2 OV rs rs [?l ?l] 0366 0841
                                                            ; W = v___data_44
                               movwf    v_txreg             ;  2 OV rs rs [?l ?l] 0367 0099
                                                            ; W = v___data_44
;   72 end procedure
                               return                       ;  2 OV rs rs [?l ?l] 0368 0008
;  123 function serial_hw_read(byte out data) return bit is
l_serial_hw_read
;  124    return _serial_hw_read(data)
                               datalo_clr v_pir1 ; pir1_rcif         ;  2 OV ?? ?s [?l ?l] 0369 1283
                               datahi_clr v_pir1 ; pir1_rcif         ;  2 OV ?s rs [?l ?l] 036a 1303
                               branchlo_nop l__l332         ;  2 OV rs rs [?l ?l] 036b
                               btfss    v_pir1, 5 ; pir1_rcif        ;  2 OV rs rs [?l ?l] 036b 1e8c
                               goto     l__l332             ;  2 OV rs rs [?l ?l] 036c 2b73
                               movf     v_rcreg,w           ;  2 OV rs rs [?l ?l] 036d 081a
                                                            ; W = v___data_50
                               datahi_set v___data_50       ;  2 OV rs Rs [?l ?l] 036e 1703
                               movwf    v___data_50         ;  2 OV Rs Rs [?l ?l] 036f 00b0
                               datahi_clr v_pir1 ; pir1_rcif         ;  2 OV Rs rs [?l ?l] 0370 1303
                                                            ; W = v___data_50
                               bcf      v_pir1, 5 ; pir1_rcif        ;  2 OV rs rs [?l ?l] 0371 128c
                                                            ; W = v___data_50
                               branchlo_nop l__l333         ;  2 OV rs rs [?l ?l] 0372
                                                            ; W = v___data_50
                               goto     l__l333             ;  2 OV rs rs [?l ?l] 0372 2b76
                                                            ; W = v___data_50
l__l332
                               datahi_set v____bitbucket_63 ; _btemp28;  2 OV rs Rs [?l ?l] 0373 1703
                               bcf      v____bitbucket_63, 0 ; _btemp28;  2 OV Rs Rs [?l ?l] 0374 1032
                               branchlo_nop l__l336         ;  2 OV Rs Rs [?l ?l] 0375
                               goto     l__l336             ;  2 OV Rs Rs [?l ?l] 0375 2b7c
l__l333
                               branchlo_nop l__l334         ;  2 OV rs rs [?l ?l] 0376
                                                            ; W = v___data_50
                               btfss    v_rcsta, 1 ; rcsta_oerr       ;  2 OV rs rs [?l ?l] 0376 1c98
                                                            ; W = v___data_50
                               goto     l__l334             ;  2 OV rs rs [?l ?l] 0377 2b7a
                                                            ; W = v___data_50
                               bcf      v_rcsta, 4 ; rcsta_cren       ;  2 OV rs rs [?l ?l] 0378 1218
                                                            ; W = v___data_50
                               bsf      v_rcsta, 4 ; rcsta_cren       ;  2 OV rs rs [?l ?l] 0379 1618
                                                            ; W = v___data_50
l__l334
                               datahi_set v____bitbucket_63 ; _btemp28;  2 OV rs Rs [?l ?l] 037a 1703
                                                            ; W = v___data_50
                               bsf      v____bitbucket_63, 0 ; _btemp28;  2 OV Rs Rs [?l ?l] 037b 1432
                                                            ; W = v___data_50
l__l336
                               branchlo_nop l__l1159        ;  2 OV Rs Rs [?l ?l] 037c
                                                            ; W = v___data_50
                               btfsc    v____bitbucket_63, 0 ; _btemp28;  2 OV Rs Rs [?l ?l] 037c 1832
                                                            ; W = v___data_50
                               goto     l__l1159            ;  2 OV Rs Rs [?l ?l] 037d 2b81
                                                            ; W = v___data_50
                               datahi_clr v__pic_temp ; _pic_temp    ;  2 OV Rs rs [?l ?l] 037e 1303
                                                            ; W = v___data_50
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  2 OV rs rs [?l ?l] 037f 1020
                                                            ; W = v___data_50
                               branchlo_nop l__l1160        ;  2 OV rs rs [?l ?l] 0380
                                                            ; W = v___data_50
                               goto     l__l1160            ;  2 OV rs rs [?l ?l] 0380 2b83
                                                            ; W = v___data_50
l__l1159
                               datahi_clr v__pic_temp ; _pic_temp    ;  2 OV Rs rs [?l ?l] 0381 1303
                                                            ; W = v___data_50
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  2 OV rs rs [?l ?l] 0382 1420
                                                            ; W = v___data_50
l__l1160
                               datahi_set v___data_50       ;  2 OV rs Rs [?l ?l] 0383 1703
                                                            ; W = v___data_50
                               movf     v___data_50,w       ;  2 OV Rs Rs [?l ?l] 0384 0830
                                                            ; W = v___data_50
                               return                       ;  2 OV Rs Rs [?l ?l] 0385 0008
                                                            ; W = v___data_50
l__serial_hw_data_put
                               datalo_clr v__pic_temp       ;  2 OV ?? ?s [?? ??] 0386 1283
                               datahi_clr v__pic_temp       ;  2 OV ?s rs [?? ??] 0387 1303
                               movf     v__pic_temp,w       ;  2 OV rs rs [?? ??] 0388 0820
                               movwf    v___data_52         ;  2 OV rs rs [?? ??] 0389 00c0
                                                            ; W = v__pic_temp
                               movf     v___data_52,w       ;  2 OV rs rs [?? ??] 038a 0840
                                                            ; W = v___data_52
                               branchlo_clr l_serial_hw_write;  2 OV rs rs [?? ?l] 038b 118a
                                                            ; W = v___data_52
                               goto     l_serial_hw_write   ;  2 OV rs rs [?l ?l] 038c 2b62
                                                            ; W = v___data_52
l__l351
; rikishi2.jal
;   73 Serial_HW_init
                               branchlo_nop l_serial_hw_init;  0 OV rs rs [hl hl] 038d
                                                            ; W = v__portb_shadow
                               call     l_serial_hw_init    ;  0 OV rs ?? [hl ??] 038d 2358
                                                            ; W = v__portb_shadow
; adc_channels.jal
;  132    _debug "ADC channels config: dependent pins, via PCFG bits"
;  134    procedure _adc_setup_pins() is
                               branchlo_clr l__l437         ;  0 OV ?? ?? [?? ?l] 038e 118a
                               goto     l__l437             ;  0 OV ?? ?? [?l ?l] 038f 2bda
; 2649    procedure _adc_vref() is
l__adc_vref
; 2650    end procedure
                               return                       ; 4294967295 OV -- -- [-- --] 0390 0008
; adc_clock.jal
;   31 function _adc_eval_tad(word in factor) return bit is
l__adc_eval_tad
;   42    var bit tad_ok = false
                               datalo_set v____bitbucket_54 ; tad_ok;  1 OV rs rS [?l ?l] 0391 1683
                                                            ; W = v___factor_1
                               bcf      v____bitbucket_54, 0 ; tad_ok;  1 OV rS rS [?l ?l] 0392 104d
                                                            ; W = v___factor_1
;   43    tad_value = byte((factor * 10) / (target_clock / 1_000_000))
                               datalo_clr v___factor_1      ;  1 OV rS rs [?l ?l] 0393 1283
                                                            ; W = v___factor_1
                               movf     v___factor_1,w      ;  1 OV rs rs [?l ?l] 0394 086a
                                                            ; W = v___factor_1
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?l ?l] 0395 00a0
                                                            ; W = v___factor_1
                               movf     v___factor_1+1,w    ;  1 OV rs rs [?l ?l] 0396 086b
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplier+1 ;  1 OV rs rs [?l ?l] 0397 00a1
                                                            ; W = v___factor_1
                               movlw    10                  ;  1 OV rs rs [?l ?l] 0398 300a
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?l ?l] 0399 00a2
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?l ?l] 039a 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_nop l__pic_multiply ;  1 OV rs rs [?l ?l] 039b
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?l ??] 039b 203b
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 039c 1283
                               datahi_clr v__pic_mresult    ;  1 OV ?s rs [?? ??] 039d 1303
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 039e 0824
                               datalo_set v____temp_38      ;  1 OV rs rS [?? ??] 039f 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_38        ;  1 OV rS rS [?? ??] 03a0 00bd
                                                            ; W = v__pic_mresult
                               datalo_clr v__pic_mresult    ;  1 OV rS rs [?? ??] 03a1 1283
                                                            ; W = v____temp_38
                               movf     v__pic_mresult+1,w  ;  1 OV rs rs [?? ??] 03a2 0825
                                                            ; W = v____temp_38
                               datalo_set v____temp_38      ;  1 OV rs rS [?? ??] 03a3 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_38+1      ;  1 OV rS rS [?? ??] 03a4 00be
                                                            ; W = v__pic_mresult
                               movlw    20                  ;  1 OV rS rS [?? ??] 03a5 3014
                                                            ; W = v____temp_38
                               datalo_clr v__pic_divisor    ;  1 OV rS rs [?? ??] 03a6 1283
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 03a7 00a8
                               clrf     v__pic_divisor+1    ;  1 OV rs rs [?? ??] 03a8 01a9
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+2    ;  1 OV rs rs [?? ??] 03a9 01aa
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+3    ;  1 OV rs rs [?? ??] 03aa 01ab
                                                            ; W = v__pic_divisor
                               datalo_set v____temp_38      ;  1 OV rs rS [?? ??] 03ab 1683
                                                            ; W = v__pic_divisor
                               movf     v____temp_38,w      ;  1 OV rS rS [?? ??] 03ac 083d
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 03ad 1283
                                                            ; W = v____temp_38
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 03ae 00a0
                                                            ; W = v____temp_38
                               datalo_set v____temp_38      ;  1 OV rs rS [?? ??] 03af 1683
                                                            ; W = v__pic_dividend
                               movf     v____temp_38+1,w    ;  1 OV rS rS [?? ??] 03b0 083e
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  1 OV rS rs [?? ??] 03b1 1283
                                                            ; W = v____temp_38
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 03b2 00a1
                                                            ; W = v____temp_38
                               clrf     v__pic_dividend+2   ;  1 OV rs rs [?? ??] 03b3 01a2
                                                            ; W = v__pic_dividend
                               clrf     v__pic_dividend+3   ;  1 OV rs rs [?? ??] 03b4 01a3
                                                            ; W = v__pic_dividend
                               branchlo_clr l__pic_divide   ;  1 OV rs rs [?? ?l] 03b5 118a
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  1 OV rs ?? [?l ??] 03b6 206f
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 03b7 1283
                               datahi_clr v__pic_quotient   ;  1 OV ?s rs [?? ??] 03b8 1303
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 03b9 082c
                               movwf    v_tad_value         ;  1 OV rs rs [?? ??] 03ba 00c4
                                                            ; W = v__pic_quotient
;   44    if tad_value >= ADC_MIN_TAD & tad_value < ADC_MAX_TAD then
                               movlw    16                  ;  1 OV rs rs [?? ??] 03bb 3010
                                                            ; W = v_tad_value
                               subwf    v_tad_value,w       ;  1 OV rs rs [?? ??] 03bc 0244
                               datalo_set v____bitbucket_54 ; _btemp31;  1 OV rs rS [?? ??] 03bd 1683
                               bcf      v____bitbucket_54, 1 ; _btemp31;  1 OV rS rS [?? ??] 03be 10cd
                               btfss    v__status, v__z     ;  1 OV rS rS [?? ??] 03bf 1d03
                               btfsc    v__status, v__c     ;  1 OV rS rS [?? ??] 03c0 1803
                               bsf      v____bitbucket_54, 1 ; _btemp31;  1 OV rS rS [?? ??] 03c1 14cd
                               movlw    60                  ;  1 OV rS rS [?? ??] 03c2 303c
                               datalo_clr v_tad_value       ;  1 OV rS rs [?? ??] 03c3 1283
                               subwf    v_tad_value,w       ;  1 OV rs rs [?? ??] 03c4 0244
                               datalo_set v____bitbucket_54 ; _btemp32;  1 OV rs rS [?? ??] 03c5 1683
                               bcf      v____bitbucket_54, 2 ; _btemp32;  1 OV rS rS [?? ??] 03c6 114d
                               branchlo_clr l__l1163        ;  1 OV rS rS [?? ?l] 03c7 118a
                               btfsc    v__status, v__z     ;  1 OV rS rS [?l ?l] 03c8 1903
                               goto     l__l1163            ;  1 OV rS rS [?l ?l] 03c9 2bcc
                               btfss    v__status, v__c     ;  1 OV rS rS [?l ?l] 03ca 1c03
                               bsf      v____bitbucket_54, 2 ; _btemp32;  1 OV rS rS [?l ?l] 03cb 154d
l__l1163
                               bsf      v____bitbucket_54, 3 ; _btemp33;  1 OV rS rS [?l ?l] 03cc 15cd
                               btfsc    v____bitbucket_54, 1 ; _btemp31;  1 OV rS rS [?l ?l] 03cd 18cd
                               btfss    v____bitbucket_54, 2 ; _btemp32;  1 OV rS rS [?l ?l] 03ce 1d4d
                               bcf      v____bitbucket_54, 3 ; _btemp33;  1 OV rS rS [?l ?l] 03cf 11cd
                               branchlo_nop l__l412         ;  1 OV rS rS [?l ?l] 03d0
                               btfsc    v____bitbucket_54, 3 ; _btemp33;  1 OV rS rS [?l ?l] 03d0 19cd
;   45 	  tad_ok = true
                               bsf      v____bitbucket_54, 0 ; tad_ok;  1 OV rS rS [?l ?l] 03d1 144d
;   46    end if
l__l412
;   47    return tad_ok
                               branchlo_nop l__l1166        ;  1 OV rS rS [?l ?l] 03d2
                               btfsc    v____bitbucket_54, 0 ; tad_ok;  1 OV rS rS [?l ?l] 03d2 184d
                               goto     l__l1166            ;  1 OV rS rS [?l ?l] 03d3 2bd7
                               datalo_clr v__pic_temp ; _pic_temp    ;  1 OV rS rs [?l ?l] 03d4 1283
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?l ?l] 03d5 1020
                               return                       ;  1 OV rs rs [?l ?l] 03d6 0008
l__l1166
                               datalo_clr v__pic_temp ; _pic_temp    ;  1 OV rS rs [?l ?l] 03d7 1283
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?l ?l] 03d8 1420
l__l1167
;   48 end function
                               return                       ;  1 OV rs rs [?l ?l] 03d9 0008
; adc.jal
;   55 end if
l__l437
;   72 var volatile byte _adcon0_shadow = 0
                               datalo_clr v__adcon0_shadow  ;  0 OV ?? ?s [?l ?l] 03da 1283
                               datahi_clr v__adcon0_shadow  ;  0 OV ?s rs [?l ?l] 03db 1303
                               clrf     v__adcon0_shadow    ;  0 OV rs rs [?l ?l] 03dc 01b9
;   77 procedure _adc_read_low_res(byte in adc_chan, byte out adc_byte) is
                               branchlo_nop l__l582         ;  0 OV rs rs [?l ?l] 03dd
                               goto     l__l582             ;  0 OV rs rs [?l ?l] 03dd 2c27
l__adc_read_low_res
                               movwf    v___adc_chan_1      ;  3 OV rS rS [?l ?l] 03de 00d1
                                                            ; W = v___adc_chan_3
;   79    ADCON0_CHS = adc_chan
                               rlf      v___adc_chan_1,w    ;  3 OV rS rS [?l ?l] 03df 0d51
                                                            ; W = v___adc_chan_1
                               datalo_clr v__pic_temp       ;  3 OV rS rs [?l ?l] 03e0 1283
                               movwf    v__pic_temp         ;  3 OV rs rs [?l ?l] 03e1 00a0
                               rlf      v__pic_temp,f       ;  3 OV rs rs [?l ?l] 03e2 0da0
                                                            ; W = v__pic_temp
                               rlf      v__pic_temp,f       ;  3 OV rs rs [?l ?l] 03e3 0da0
                               movlw    56                  ;  3 OV rs rs [?l ?l] 03e4 3038
                               andwf    v__pic_temp,f       ;  3 OV rs rs [?l ?l] 03e5 05a0
                               movlw    199                 ;  3 OV rs rs [?l ?l] 03e6 30c7
                               andwf    v_adcon0,w          ;  3 OV rs rs [?l ?l] 03e7 051f
                               iorwf    v__pic_temp,w       ;  3 OV rs rs [?l ?l] 03e8 0420
                               movwf    v_adcon0            ;  3 OV rs rs [?l ?l] 03e9 009f
;   80    ADCON0_ADON = true                -- turn on ADC module
                               bsf      v_adcon0, 0 ; adcon0_adon      ;  3 OV rs rs [?l ?l] 03ea 141f
                                                            ; W = v_adcon0
;   81    delay_10us(adc_conversion_delay)  -- wait acquisition time
                               movf     v_adc_conversion_delay,w;  3 OV rs rs [?l ?l] 03eb 0845
                                                            ; W = v_adcon0
                               branchlo_nop l_delay_10us    ;  3 OV rs rs [?l ?l] 03ec
                                                            ; W = v_adc_conversion_delay
                               call     l_delay_10us        ;  3 OV rs ?? [?l ??] 03ec 20dc
                                                            ; W = v_adc_conversion_delay
;   82    ADCON0_GO = true                  -- start conversion
                               datalo_clr v_adcon0 ; adcon0_go       ;  3 OV ?? ?s [?? ??] 03ed 1283
                               datahi_clr v_adcon0 ; adcon0_go       ;  3 OV ?s rs [?? ??] 03ee 1303
                               bsf      v_adcon0, 2 ; adcon0_go      ;  3 OV rs rs [?? ??] 03ef 151f
;   83    while ADCON0_GO loop end loop     -- wait till conversion finished
l__l443
                               branchlo_clr l__l444         ;  3 OV rs rs [?? ?l] 03f0 118a
                               btfss    v_adcon0, 2 ; adcon0_go      ;  3 OV rs rs [?l ?l] 03f1 1d1f
                               goto     l__l444             ;  3 OV rs rs [?l ?l] 03f2 2bf4
                               branchlo_nop l__l443         ;  3 OV rs rs [?l ?l] 03f3
                               goto     l__l443             ;  3 OV rs rs [?l ?l] 03f3 2bf0
l__l444
;   90       adc_byte = ADRESH                  -- read high byte 
                               movf     v_adresh,w          ;  3 OV rs rs [?l ?l] 03f4 081e
                               datalo_set v___adc_byte_1    ;  3 OV rs rS [?l ?l] 03f5 1683
                               movwf    v___adc_byte_1      ;  3 OV rS rS [?l ?l] 03f6 00d2
;   98    if tad_value >= (ADC_MAX_TAD + ADC_MIN_TAD) / 2 then
                               movlw    38                  ;  3 OV rS rS [?l ?l] 03f7 3026
                                                            ; W = v___adc_byte_1
                               datalo_clr v_tad_value       ;  3 OV rS rs [?l ?l] 03f8 1283
                               subwf    v_tad_value,w       ;  3 OV rs rs [?l ?l] 03f9 0244
                               branchlo_nop l__l1169        ;  3 OV rs rs [?l ?l] 03fa
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 03fa 1903
                               goto     l__l1169            ;  3 OV rs rs [?l ?l] 03fb 2bfe
                               branchlo_nop l__l449         ;  3 OV rs rs [?l ?l] 03fc
                                                            ; W = v___adc_byte_1
                               btfss    v__status, v__c     ;  3 OV rs rs [?l ?l] 03fc 1c03
                                                            ; W = v___adc_byte_1
                               goto     l__l449             ;  3 OV rs rs [?l ?l] 03fd 2c08
                                                            ; W = v___adc_byte_1
l__l1169
;   99       _usec_delay(2 * ADC_MAX_TAD)
                               datalo_clr v__pic_temp       ;  3 -V rs rs [?l ?l] 03fe 1283
                               datahi_clr v__pic_temp       ;  3 -V rs rs [?l ?l] 03ff 1303
                               movlw    198                 ;  3 -V rs rs [?l ?l] 0400 30c6
                               movwf    v__pic_temp         ;  3 -V rs rs [?l ?l] 0401 00a0
                               branchhi_clr l__l1170        ;  3 -V rs rs [?l hl] 0402 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l1170        ;  3 -V rs rs [hl hl] 0403 118a
                                                            ; W = v__pic_temp
l__l1170
                               decfsz   v__pic_temp,f       ;  3 -V rs rs [hl hl] 0404 0ba0
                               goto     l__l1170            ;  3 -V rs rs [hl hl] 0405 2c04
                               nop                          ;  3 -V rs rs [hl hl] 0406 0000
;  100    else
                               branchlo_nop l__l448         ;  3 OV rs rs [hl hl] 0407
                               goto     l__l448             ;  3 OV rs rs [hl hl] 0407 2c12
l__l449
;  101       _usec_delay(2 * ADC_MIN_TAD)
                               datalo_clr v__pic_temp       ;  3 -V rs rs [?l ?l] 0408 1283
                                                            ; W = v___adc_byte_1
                               datahi_clr v__pic_temp       ;  3 -V rs rs [?l ?l] 0409 1303
                                                            ; W = v___adc_byte_1
                               movlw    51                  ;  3 -V rs rs [?l ?l] 040a 3033
                                                            ; W = v___adc_byte_1
                               movwf    v__pic_temp         ;  3 -V rs rs [?l ?l] 040b 00a0
                               branchhi_clr l__l1171        ;  3 -V rs rs [?l hl] 040c 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l1171        ;  3 -V rs rs [hl hl] 040d 118a
                                                            ; W = v__pic_temp
l__l1171
                               decfsz   v__pic_temp,f       ;  3 -V rs rs [hl hl] 040e 0ba0
                               goto     l__l1171            ;  3 -V rs rs [hl hl] 040f 2c0e
                               nop                          ;  3 -V rs rs [hl hl] 0410 0000
                               nop                          ;  3 -V rs rs [hl hl] 0411 0000
;  102    end if
l__l448
;  103    ADCON0_ADON = false               -- turn off ADC module
                               bcf      v_adcon0, 0 ; adcon0_adon      ;  3 OV rs rs [hl hl] 0412 101f
;  104 end procedure
                               datalo_set v___adc_byte_1    ;  3 OV rs rS [hl hl] 0413 1683
                               movf     v___adc_byte_1,w    ;  3 OV rS rS [hl hl] 0414 0852
                               return                       ;  3 OV rS rS [hl hl] 0415 0008
                                                            ; W = v___adc_byte_1
;  110 function adc_read(byte in adc_chan) return word is
l_adc_read
                               datalo_set v___adc_chan_3    ;  2 OV ?? ?S [?l ?l] 0416 1683
                               datahi_clr v___adc_chan_3    ;  2 OV ?S rS [?l ?l] 0417 1303
                               movwf    v___adc_chan_3      ;  2 OV rS rS [?l ?l] 0418 00bd
;  115       _adc_read_low_res(adc_chan,ax[1])   -- do conversion and get high byte  
                               movf     v___adc_chan_3,w    ;  2 OV rS rS [?l ?l] 0419 083d
                                                            ; W = v___adc_chan_3
                               branchlo_nop l__adc_read_low_res;  2 OV rS rS [?l ?l] 041a
                                                            ; W = v___adc_chan_3
                               call     l__adc_read_low_res ;  2 OV rS ?? [?l ??] 041a 23de
                                                            ; W = v___adc_chan_3
                               datalo_clr v_ax+1            ;  2 OV ?? ?s [?? ??] 041b 1283
                               datahi_clr v_ax+1            ;  2 OV ?s rs [?? ??] 041c 1303
                               movwf    v_ax+1              ;  2 OV rs rs [?? ??] 041d 00ef
;  116       ax[0] = ADRESL                       -- get low byte
                               datalo_set v_adresl          ;  2 OV rs rS [?? ??] 041e 1683
                                                            ; W = v_ax
                               movf     v_adresl,w          ;  2 OV rS rS [?? ??] 041f 081e
                                                            ; W = v_ax
                               datalo_clr v_ax              ;  2 OV rS rs [?? ??] 0420 1283
                               movwf    v_ax                ;  2 OV rs rs [?? ??] 0421 00ee
;  125    return ad_value
                               movf     v_ad_value,w        ;  2 OV rs rs [?? ??] 0422 086e
                                                            ; W = v_ax
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 0423 00a0
                                                            ; W = v_ad_value
                               movf     v_ad_value+1,w      ;  2 OV rs rs [?? ??] 0424 086f
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  2 OV rs rs [?? ??] 0425 00a1
                                                            ; W = v_ad_value
;  126 end function
                               return                       ;  2 OV rs rs [?? ??] 0426 0008
                                                            ; W = v__pic_temp
;  266    end if
l__l582
; rikishi2.jal
;   80 adc_init()
; adc_channels.jal
;  423          var bit*4 no_vref = 0
                               movlw    195                 ;  0 OV rs rs [?l ?l] 0427 30c3
                               andwf    v__bitbucket+2,f    ;  0 OV rs rs [?l ?l] 0428 05e7
;  443             pin_AN4_direction = input
                               datalo_set v_trisa ; pin_a5_direction        ;  0 OV rs rS [?l ?l] 0429 1683
                               bsf      v_trisa, 5 ; pin_a5_direction       ;  0 OV rS rS [?l ?l] 042a 1685
;  444             pin_AN1_direction = input
                               bsf      v_trisa, 1 ; pin_a1_direction       ;  0 OV rS rS [?l ?l] 042b 1485
;  445             pin_AN0_direction = input
                               bsf      v_trisa, 0 ; pin_a0_direction       ;  0 OV rS rS [?l ?l] 042c 1405
;  446             pin_AN2_direction = input
                               bsf      v_trisa, 2 ; pin_a2_direction       ;  0 OV rS rS [?l ?l] 042d 1505
;  447             pin_AN3_direction = input
                               bsf      v_trisa, 3 ; pin_a3_direction       ;  0 OV rS rS [?l ?l] 042e 1585
; 2622          no_vref = ADC_PCFG_MAP[idx]
                               movlw    195                 ;  0 OV rS rS [?l ?l] 042f 30c3
                               datalo_clr v__bitbucket      ;  0 OV rS rs [?l ?l] 0430 1283
                               andwf    v__bitbucket+2,w    ;  0 OV rs rs [?l ?l] 0431 0567
                               iorlw    36                  ;  0 OV rs rs [?l ?l] 0432 3824
                               movwf    v__bitbucket+2      ;  0 OV rs rs [?l ?l] 0433 00e7
; 2623          ADCON1_PCFG = no_vref  ;; here it is
                               rrf      v__bitbucket+2,w    ;  0 OV rs rs [?l ?l] 0434 0c67
                                                            ; W = v__bitbucket
                               movwf    v__pic_temp+3       ;  0 OV rs rs [?l ?l] 0435 00a3
                               rrf      v__bitbucket+1,w    ;  0 OV rs rs [?l ?l] 0436 0c66
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+2       ;  0 OV rs rs [?l ?l] 0437 00a2
                               rrf      v__bitbucket,w      ;  0 OV rs rs [?l ?l] 0438 0c65
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?l ?l] 0439 00a1
                               rrf      v__pic_temp+3,f     ;  0 OV rs rs [?l ?l] 043a 0ca3
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp+2,f     ;  0 OV rs rs [?l ?l] 043b 0ca2
                               rrf      v__pic_temp+1,f     ;  0 OV rs rs [?l ?l] 043c 0ca1
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?l ?l] 043d 0821
                               movwf    v__pic_temp         ;  0 OV rs rs [?l ?l] 043e 00a0
                                                            ; W = v__pic_temp
                               movlw    15                  ;  0 OV rs rs [?l ?l] 043f 300f
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp,f       ;  0 OV rs rs [?l ?l] 0440 05a0
                               movlw    15                  ;  0 OV rs rs [?l ?l] 0441 300f
                               andwf    v__pic_temp,w       ;  0 OV rs rs [?l ?l] 0442 0520
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?l ?l] 0443 00a1
                               movlw    240                 ;  0 OV rs rs [?l ?l] 0444 30f0
                                                            ; W = v__pic_temp
                               datalo_set v_adcon1          ;  0 OV rs rS [?l ?l] 0445 1683
                               andwf    v_adcon1,w          ;  0 OV rS rS [?l ?l] 0446 051f
                               datalo_clr v__pic_temp+1     ;  0 OV rS rs [?l ?l] 0447 1283
                               iorwf    v__pic_temp+1,w     ;  0 OV rs rs [?l ?l] 0448 0421
                               datalo_set v_adcon1          ;  0 OV rs rS [?l ?l] 0449 1683
                               movwf    v_adcon1            ;  0 OV rS rS [?l ?l] 044a 009f
; 2625          serial_hw_data = "#"
                               movlw    35                  ;  0 OV rS rS [?l ?l] 044b 3023
                                                            ; W = v_adcon1
                               datalo_clr v__pic_temp       ;  0 OV rS rs [?l ?l] 044c 1283
                               movwf    v__pic_temp         ;  0 OV rs rs [?l ?l] 044d 00a0
                               branchlo_nop l__serial_hw_data_put;  0 OV rs rs [?l ?l] 044e
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  0 OV rs ?? [?l ??] 044e 2386
                                                            ; W = v__pic_temp
; 2626       	print_byte_hex(serial_hw_data, ADC_PCFG_MAP[idx])
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 044f 3086
                               datalo_clr v____device_put_12;  0 OV ?? ?s [?? ??] 0450 1283
                               datahi_set v____device_put_12;  0 OV ?s Rs [?? ??] 0451 1703
                               movwf    v____device_put_12  ;  0 OV Rs Rs [?? ??] 0452 00b2
                               movlw    HIGH l__serial_hw_data_put;  0 OV Rs Rs [?? ??] 0453 3003
                                                            ; W = v____device_put_12
                               movwf    v____device_put_12+1;  0 OV Rs Rs [?? ??] 0454 00b3
                               movlw    9                   ;  0 OV Rs Rs [?? ??] 0455 3009
                                                            ; W = v____device_put_12
                               branchlo_clr l_print_byte_hex;  0 OV Rs Rs [?? ?l] 0456 118a
                               call     l_print_byte_hex    ;  0 OV Rs ?? [?l ??] 0457 21e1
; 2627          serial_hw_data = "_"
                               movlw    95                  ;  0 OV ?? ?? [?? ??] 0458 305f
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 0459 1283
                               datahi_clr v__pic_temp       ;  0 OV ?s rs [?? ??] 045a 1303
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 045b 00a0
                               branchlo_clr l__serial_hw_data_put;  0 OV rs rs [?? ?l] 045c 118a
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  0 OV rs ?? [?l ??] 045d 2386
                                                            ; W = v__pic_temp
; 2628       	print_word_hex(serial_hw_data, no_vref)
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 045e 3086
                               datalo_clr v____device_put_11;  0 OV ?? ?s [?? ??] 045f 1283
                               datahi_clr v____device_put_11;  0 OV ?s rs [?? ??] 0460 1303
                               movwf    v____device_put_11  ;  0 OV rs rs [?? ??] 0461 00ea
                               movlw    HIGH l__serial_hw_data_put;  0 OV rs rs [?? ??] 0462 3003
                                                            ; W = v____device_put_11
                               movwf    v____device_put_11+1;  0 OV rs rs [?? ??] 0463 00eb
                               rrf      v__bitbucket+2,w    ;  0 OV rs rs [?? ??] 0464 0c67
                                                            ; W = v____device_put_11
                               movwf    v__pic_temp+2       ;  0 OV rs rs [?? ??] 0465 00a2
                               rrf      v__bitbucket+1,w    ;  0 OV rs rs [?? ??] 0466 0c66
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?? ??] 0467 00a1
                               rrf      v__bitbucket,w      ;  0 OV rs rs [?? ??] 0468 0c65
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 0469 00a0
                               rrf      v__pic_temp+2,f     ;  0 OV rs rs [?? ??] 046a 0ca2
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp+1,f     ;  0 OV rs rs [?? ??] 046b 0ca1
                               rrf      v__pic_temp,f       ;  0 OV rs rs [?? ??] 046c 0ca0
                               movf     v__pic_temp,w       ;  0 OV rs rs [?? ??] 046d 0820
                               datalo_set v___data_22       ;  0 OV rs rS [?? ??] 046e 1683
                                                            ; W = v__pic_temp
                               movwf    v___data_22         ;  0 OV rS rS [?? ??] 046f 00bd
                                                            ; W = v__pic_temp
                               datalo_clr v__pic_temp       ;  0 OV rS rs [?? ??] 0470 1283
                                                            ; W = v___data_22
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 0471 0821
                                                            ; W = v___data_22
                               datalo_set v___data_22       ;  0 OV rs rS [?? ??] 0472 1683
                                                            ; W = v__pic_temp
                               movwf    v___data_22+1       ;  0 OV rS rS [?? ??] 0473 00be
                                                            ; W = v__pic_temp
                               movlw    15                  ;  0 OV rS rS [?? ??] 0474 300f
                                                            ; W = v___data_22
                               andwf    v___data_22,f       ;  0 OV rS rS [?? ??] 0475 05bd
                               branchlo_clr l_print_word_hex;  0 OV rS rS [?? ?l] 0476 118a
                               call     l_print_word_hex    ;  0 OV rS ?? [?l ??] 0477 216c
; rikishi2.jal
;   80 adc_init()
; adc.jal
;  253    _adc_setup_pins()    -- conditionally defined according to PIC
;  254    _adc_vref()          -- conditionally defined according to PIC
; rikishi2.jal
;   80 adc_init()
; adc.jal
;  267    _adc_setup()
; rikishi2.jal
;   80 adc_init()
; adc.jal
;  190 	  JALLIB_ADFM = 1
                               datalo_set v_adcon1 ; adcon1_adfm       ;  0 OV ?? ?S [?? ??] 0478 1683
                               datahi_clr v_adcon1 ; adcon1_adfm       ;  0 OV ?S rS [?? ??] 0479 1303
                               bsf      v_adcon1, 7 ; adcon1_adfm      ;  0 OV rS rS [?? ??] 047a 179f
; adc_clock.jal
;  116    var volatile bit*3 adcs = 0b_000
                               movlw    227                 ;  0 OV rS rS [?? ??] 047b 30e3
                               datalo_clr v__bitbucket      ;  0 OV rS rs [?? ??] 047c 1283
                               andwf    v__bitbucket+2,f    ;  0 OV rs rs [?? ??] 047d 05e7
;  120 	  if _adc_eval_tad(64) == true then
                               movlw    64                  ;  0 OV rs rs [?? ??] 047e 3040
                               movwf    v___factor_1        ;  0 OV rs rs [?? ??] 047f 00ea
                               clrf     v___factor_1+1      ;  0 OV rs rs [?? ??] 0480 01eb
                                                            ; W = v___factor_1
                               branchlo_clr l__adc_eval_tad ;  0 OV rs rs [?? ?l] 0481 118a
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [?l ??] 0482 2391
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+2 ; _btemp342 ;  0 OV ?? ?s [?? ??] 0483 1283
                               datahi_clr v__bitbucket+2 ; _btemp342 ;  0 OV ?s rs [?? ??] 0484 1303
                               bcf      v__bitbucket+2, 5 ; _btemp342;  0 OV rs rs [?? ??] 0485 12e7
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 0486 1820
                               bsf      v__bitbucket+2, 5 ; _btemp342;  0 OV rs rs [?? ??] 0487 16e7
                               branchlo_clr l__l634         ;  0 OV rs rs [?? ?l] 0488 118a
                               btfss    v__bitbucket+2, 5 ; _btemp342;  0 OV rs rs [?l ?l] 0489 1ee7
                               goto     l__l634             ;  0 OV rs rs [?l ?l] 048a 2c90
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  121 		 adcs = 0b_110
                               movlw    227                 ;  0 OV rs rs [?l ?l] 048b 30e3
                                                            ; W = v__bitbucket
                               andwf    v__bitbucket+2,w    ;  0 OV rs rs [?l ?l] 048c 0567
                               iorlw    24                  ;  0 OV rs rs [?l ?l] 048d 3818
                               movwf    v__bitbucket+2      ;  0 OV rs rs [?l ?l] 048e 00e7
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  122 	  elsif _adc_eval_tad(32) == true then
                               branchlo_nop l__l642         ;  0 OV rs rs [?l ?l] 048f
                                                            ; W = v__bitbucket
                               goto     l__l642             ;  0 OV rs rs [?l ?l] 048f 2ce2
                                                            ; W = v__bitbucket
l__l634
                               movlw    32                  ;  0 OV rs rs [?l ?l] 0490 3020
                               movwf    v___factor_1        ;  0 OV rs rs [?l ?l] 0491 00ea
                               clrf     v___factor_1+1      ;  0 OV rs rs [?l ?l] 0492 01eb
                                                            ; W = v___factor_1
                               branchlo_nop l__adc_eval_tad ;  0 OV rs rs [?l ?l] 0493
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [?l ??] 0493 2391
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+2 ; _btemp362 ;  0 OV ?? ?s [?? ??] 0494 1283
                               datahi_clr v__bitbucket+2 ; _btemp362 ;  0 OV ?s rs [?? ??] 0495 1303
                               bcf      v__bitbucket+2, 7 ; _btemp362;  0 OV rs rs [?? ??] 0496 13e7
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 0497 1820
                               bsf      v__bitbucket+2, 7 ; _btemp362;  0 OV rs rs [?? ??] 0498 17e7
                               branchlo_clr l__l635         ;  0 OV rs rs [?? ?l] 0499 118a
                               btfss    v__bitbucket+2, 7 ; _btemp362;  0 OV rs rs [?l ?l] 049a 1fe7
                               goto     l__l635             ;  0 OV rs rs [?l ?l] 049b 2ca1
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  123 		 adcs = 0b_010
                               movlw    227                 ;  0 OV rs rs [?l ?l] 049c 30e3
                                                            ; W = v__bitbucket
                               andwf    v__bitbucket+2,w    ;  0 OV rs rs [?l ?l] 049d 0567
                               iorlw    8                   ;  0 OV rs rs [?l ?l] 049e 3808
                               movwf    v__bitbucket+2      ;  0 OV rs rs [?l ?l] 049f 00e7
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  124 	  elsif _adc_eval_tad(16) == true then
                               branchlo_nop l__l640         ;  0 OV rs rs [?l ?l] 04a0
                                                            ; W = v__bitbucket
                               goto     l__l640             ;  0 OV rs rs [?l ?l] 04a0 2ce2
                                                            ; W = v__bitbucket
l__l635
                               movlw    16                  ;  0 OV rs rs [?l ?l] 04a1 3010
                               movwf    v___factor_1        ;  0 OV rs rs [?l ?l] 04a2 00ea
                               clrf     v___factor_1+1      ;  0 OV rs rs [?l ?l] 04a3 01eb
                                                            ; W = v___factor_1
                               branchlo_nop l__adc_eval_tad ;  0 OV rs rs [?l ?l] 04a4
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [?l ??] 04a4 2391
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+3 ; _btemp382 ;  0 OV ?? ?s [?? ??] 04a5 1283
                               datahi_clr v__bitbucket+3 ; _btemp382 ;  0 OV ?s rs [?? ??] 04a6 1303
                               bcf      v__bitbucket+3, 1 ; _btemp382;  0 OV rs rs [?? ??] 04a7 10e8
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 04a8 1820
                               bsf      v__bitbucket+3, 1 ; _btemp382;  0 OV rs rs [?? ??] 04a9 14e8
                               branchlo_clr l__l636         ;  0 OV rs rs [?? ?l] 04aa 118a
                               btfss    v__bitbucket+3, 1 ; _btemp382;  0 OV rs rs [?l ?l] 04ab 1ce8
                               goto     l__l636             ;  0 OV rs rs [?l ?l] 04ac 2cb2
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  125 		 adcs = 0b_101
                               movlw    227                 ;  0 OV rs rs [?l ?l] 04ad 30e3
                                                            ; W = v__bitbucket
                               andwf    v__bitbucket+2,w    ;  0 OV rs rs [?l ?l] 04ae 0567
                               iorlw    20                  ;  0 OV rs rs [?l ?l] 04af 3814
                               movwf    v__bitbucket+2      ;  0 OV rs rs [?l ?l] 04b0 00e7
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  126 	  elsif _adc_eval_tad(8) == true then
                               branchlo_nop l__l640         ;  0 OV rs rs [?l ?l] 04b1
                                                            ; W = v__bitbucket
                               goto     l__l640             ;  0 OV rs rs [?l ?l] 04b1 2ce2
                                                            ; W = v__bitbucket
l__l636
                               movlw    8                   ;  0 OV rs rs [?l ?l] 04b2 3008
                               movwf    v___factor_1        ;  0 OV rs rs [?l ?l] 04b3 00ea
                               clrf     v___factor_1+1      ;  0 OV rs rs [?l ?l] 04b4 01eb
                                                            ; W = v___factor_1
                               branchlo_nop l__adc_eval_tad ;  0 OV rs rs [?l ?l] 04b5
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [?l ??] 04b5 2391
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+3 ; _btemp402 ;  0 OV ?? ?s [?? ??] 04b6 1283
                               datahi_clr v__bitbucket+3 ; _btemp402 ;  0 OV ?s rs [?? ??] 04b7 1303
                               bcf      v__bitbucket+3, 3 ; _btemp402;  0 OV rs rs [?? ??] 04b8 11e8
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 04b9 1820
                               bsf      v__bitbucket+3, 3 ; _btemp402;  0 OV rs rs [?? ??] 04ba 15e8
                               branchlo_clr l__l637         ;  0 OV rs rs [?? ?l] 04bb 118a
                               btfss    v__bitbucket+3, 3 ; _btemp402;  0 OV rs rs [?l ?l] 04bc 1de8
                               goto     l__l637             ;  0 OV rs rs [?l ?l] 04bd 2cc3
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  127 		 adcs = 0b_001
                               movlw    227                 ;  0 OV rs rs [?l ?l] 04be 30e3
                                                            ; W = v__bitbucket
                               andwf    v__bitbucket+2,w    ;  0 OV rs rs [?l ?l] 04bf 0567
                               iorlw    4                   ;  0 OV rs rs [?l ?l] 04c0 3804
                               movwf    v__bitbucket+2      ;  0 OV rs rs [?l ?l] 04c1 00e7
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  128 	  elsif _adc_eval_tad(4) == true then
                               branchlo_nop l__l640         ;  0 OV rs rs [?l ?l] 04c2
                                                            ; W = v__bitbucket
                               goto     l__l640             ;  0 OV rs rs [?l ?l] 04c2 2ce2
                                                            ; W = v__bitbucket
l__l637
                               movlw    4                   ;  0 OV rs rs [?l ?l] 04c3 3004
                               movwf    v___factor_1        ;  0 OV rs rs [?l ?l] 04c4 00ea
                               clrf     v___factor_1+1      ;  0 OV rs rs [?l ?l] 04c5 01eb
                                                            ; W = v___factor_1
                               branchlo_nop l__adc_eval_tad ;  0 OV rs rs [?l ?l] 04c6
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [?l ??] 04c6 2391
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+3 ; _btemp422 ;  0 OV ?? ?s [?? ??] 04c7 1283
                               datahi_clr v__bitbucket+3 ; _btemp422 ;  0 OV ?s rs [?? ??] 04c8 1303
                               bcf      v__bitbucket+3, 5 ; _btemp422;  0 OV rs rs [?? ??] 04c9 12e8
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 04ca 1820
                               bsf      v__bitbucket+3, 5 ; _btemp422;  0 OV rs rs [?? ??] 04cb 16e8
                               branchlo_clr l__l638         ;  0 OV rs rs [?? ?l] 04cc 118a
                               btfss    v__bitbucket+3, 5 ; _btemp422;  0 OV rs rs [?l ?l] 04cd 1ee8
                               goto     l__l638             ;  0 OV rs rs [?l ?l] 04ce 2cd4
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  129 		 adcs = 0b_100
                               movlw    227                 ;  0 OV rs rs [?l ?l] 04cf 30e3
                               andwf    v__bitbucket+2,w    ;  0 OV rs rs [?l ?l] 04d0 0567
                               iorlw    16                  ;  0 OV rs rs [?l ?l] 04d1 3810
                               movwf    v__bitbucket+2      ;  0 OV rs rs [?l ?l] 04d2 00e7
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  130 	  elsif _adc_eval_tad(2) == true then
                               branchlo_nop l__l640         ;  0 OV rs rs [?l ?l] 04d3
                                                            ; W = v__bitbucket
                               goto     l__l640             ;  0 OV rs rs [?l ?l] 04d3 2ce2
                                                            ; W = v__bitbucket
l__l638
                               movlw    2                   ;  0 OV rs rs [?l ?l] 04d4 3002
                               movwf    v___factor_1        ;  0 OV rs rs [?l ?l] 04d5 00ea
                               clrf     v___factor_1+1      ;  0 OV rs rs [?l ?l] 04d6 01eb
                                                            ; W = v___factor_1
                               branchlo_nop l__adc_eval_tad ;  0 OV rs rs [?l ?l] 04d7
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [?l ??] 04d7 2391
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+3 ; _btemp442 ;  0 OV ?? ?s [?? ??] 04d8 1283
                               datahi_clr v__bitbucket+3 ; _btemp442 ;  0 OV ?s rs [?? ??] 04d9 1303
                               bcf      v__bitbucket+3, 7 ; _btemp442;  0 OV rs rs [?? ??] 04da 13e8
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 04db 1820
                               bsf      v__bitbucket+3, 7 ; _btemp442;  0 OV rs rs [?? ??] 04dc 17e8
                               branchlo_clr l__l639         ;  0 OV rs rs [?? ?l] 04dd 118a
                               btfss    v__bitbucket+3, 7 ; _btemp442;  0 OV rs rs [?l ?l] 04de 1fe8
                               goto     l__l639             ;  0 OV rs rs [?l ?l] 04df 2ce2
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  131 		 adcs = 0b_000
                               movlw    227                 ;  0 OV rs rs [?l ?l] 04e0 30e3
                               andwf    v__bitbucket+2,f    ;  0 OV rs rs [?l ?l] 04e1 05e7
; rikishi2.jal
;   80 adc_init()
; adc_clock.jal
;  132 	  end if
l__l639
l__l640
;  133    else
l__l642
;  148 		 jallib_adcs_lsb = adcs_lsb
                               rrf      v__bitbucket+2,w    ;  0 OV rs rs [?l ?l] 04e2 0c67
                               movwf    v__pic_temp+3       ;  0 OV rs rs [?l ?l] 04e3 00a3
                               rrf      v__bitbucket+1,w    ;  0 OV rs rs [?l ?l] 04e4 0c66
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+2       ;  0 OV rs rs [?l ?l] 04e5 00a2
                               rrf      v__bitbucket,w      ;  0 OV rs rs [?l ?l] 04e6 0c65
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?l ?l] 04e7 00a1
                               rrf      v__pic_temp+3,f     ;  0 OV rs rs [?l ?l] 04e8 0ca3
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp+2,f     ;  0 OV rs rs [?l ?l] 04e9 0ca2
                               rrf      v__pic_temp+1,f     ;  0 OV rs rs [?l ?l] 04ea 0ca1
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?l ?l] 04eb 0821
                               movwf    v__pic_temp         ;  0 OV rs rs [?l ?l] 04ec 00a0
                                                            ; W = v__pic_temp
                               movlw    3                   ;  0 OV rs rs [?l ?l] 04ed 3003
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp,f       ;  0 OV rs rs [?l ?l] 04ee 05a0
                               rrf      v__pic_temp,w       ;  0 OV rs rs [?l ?l] 04ef 0c20
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?l ?l] 04f0 00a1
                               rrf      v__pic_temp+1,f     ;  0 OV rs rs [?l ?l] 04f1 0ca1
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp+1,w     ;  0 OV rs rs [?l ?l] 04f2 0c21
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?l ?l] 04f3 00a1
                               movlw    192                 ;  0 OV rs rs [?l ?l] 04f4 30c0
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp+1,f     ;  0 OV rs rs [?l ?l] 04f5 05a1
                               movlw    63                  ;  0 OV rs rs [?l ?l] 04f6 303f
                               andwf    v_adcon0,w          ;  0 OV rs rs [?l ?l] 04f7 051f
                               iorwf    v__pic_temp+1,w     ;  0 OV rs rs [?l ?l] 04f8 0421
                               movwf    v_adcon0            ;  0 OV rs rs [?l ?l] 04f9 009f
;  149 		 jallib_adcs_msb = adcs_msb
                               branchlo_nop l__l1172        ;  0 OV rs rs [?l ?l] 04fa
                                                            ; W = v_adcon0
                               btfsc    v__bitbucket+2, 4 ; adcs_msb2;  0 OV rs rs [?l ?l] 04fa 1a67
                                                            ; W = v_adcon0
                               goto     l__l1172            ;  0 OV rs rs [?l ?l] 04fb 2cff
                                                            ; W = v_adcon0
                               datalo_set v_adcon1 ; adcon1_adcs2       ;  0 OV rs rS [?l ?l] 04fc 1683
                               bcf      v_adcon1, 6 ; adcon1_adcs2      ;  0 OV rS rS [?l ?l] 04fd 131f
                               branchlo_nop l__l1173        ;  0 OV rS rS [?l ?l] 04fe
                               goto     l__l1173            ;  0 OV rS rS [?l ?l] 04fe 2d01
l__l1172
                               datalo_set v_adcon1 ; adcon1_adcs2       ;  0 OV rs rS [?l ?l] 04ff 1683
                                                            ; W = v_adcon0
                               bsf      v_adcon1, 6 ; adcon1_adcs2      ;  0 OV rS rS [?l ?l] 0500 171f
                                                            ; W = v_adcon0
l__l1173
; rikishi2.jal
;   80 adc_init()
; adc.jal
;  270    _adc_init_clock()
; rikishi2.jal
;   80 adc_init()
; adc.jal
;  243    adc_conversion_delay = 2 + adc_tc + adc_tcoff   -- Tamp seems to be a constant: 2usecs
                               movlw    21                  ;  0 OV rS rS [?l ?l] 0501 3015
                                                            ; W = v_adcon0
                               datalo_clr v_adc_conversion_delay;  0 OV rS rs [?l ?l] 0502 1283
                               movwf    v_adc_conversion_delay;  0 OV rs rs [?l ?l] 0503 00c5
; rikishi2.jal
;   80 adc_init()
; adc.jal
;  271    _adc_init_acquisition_delay()
; rikishi2.jal
;   80 adc_init()
; timer0_isr_interval.jal
;   52 function isr_counter'get() return word is
                               branchlo_nop l__l676         ;  0 OV rs rs [?l ?l] 0504
                                                            ; W = v_adc_conversion_delay
                               goto     l__l676             ;  0 OV rs rs [?l ?l] 0504 2dbd
                                                            ; W = v_adc_conversion_delay
l__isr_counter_get
;   55    INTCON_TMR0IE = off
                               bcf      v_intcon, 5 ; intcon_tmr0ie      ;  2 OV ?? ?? [?l ?l] 0505 128b
;   56    temp = internal_isr_counter
                               datalo_clr v_internal_isr_counter;  2 OV ?? ?s [?l ?l] 0506 1283
                               datahi_clr v_internal_isr_counter;  2 OV ?s rs [?l ?l] 0507 1303
                               movf     v_internal_isr_counter,w;  2 OV rs rs [?l ?l] 0508 0846
                               datalo_set v_temp            ;  2 OV rs rS [?l ?l] 0509 1683
                                                            ; W = v_internal_isr_counter
                               movwf    v_temp              ;  2 OV rS rS [?l ?l] 050a 00d5
                                                            ; W = v_internal_isr_counter
                               datalo_clr v_internal_isr_counter;  2 OV rS rs [?l ?l] 050b 1283
                                                            ; W = v_temp
                               movf     v_internal_isr_counter+1,w;  2 OV rs rs [?l ?l] 050c 0847
                                                            ; W = v_temp
                               datalo_set v_temp            ;  2 OV rs rS [?l ?l] 050d 1683
                                                            ; W = v_internal_isr_counter
                               movwf    v_temp+1            ;  2 OV rS rS [?l ?l] 050e 00d6
                                                            ; W = v_internal_isr_counter
;   57    INTCON_TMR0IE = on
                               bsf      v_intcon, 5 ; intcon_tmr0ie      ;  2 OV rS rS [?l ?l] 050f 168b
                                                            ; W = v_temp
;   59    return temp
                               movf     v_temp,w            ;  2 OV rS rS [?l ?l] 0510 0855
                                                            ; W = v_temp
                               datalo_clr v__pic_temp       ;  2 OV rS rs [?l ?l] 0511 1283
                                                            ; W = v_temp
                               movwf    v__pic_temp         ;  2 OV rs rs [?l ?l] 0512 00a0
                                                            ; W = v_temp
                               datalo_set v_temp            ;  2 OV rs rS [?l ?l] 0513 1683
                                                            ; W = v__pic_temp
                               movf     v_temp+1,w          ;  2 OV rS rS [?l ?l] 0514 0856
                                                            ; W = v__pic_temp
                               datalo_clr v__pic_temp       ;  2 OV rS rs [?l ?l] 0515 1283
                                                            ; W = v_temp
                               movwf    v__pic_temp+1       ;  2 OV rs rs [?l ?l] 0516 00a1
                                                            ; W = v_temp
;   60 end function
                               return                       ;  2 OV rs rs [?l ?l] 0517 0008
                                                            ; W = v__pic_temp
;   62 procedure set_delay(byte in slot, word in ticks) is
l_set_delay
                               movwf    v___slot_1          ;  2 OV rS rS [?l ?l] 0518 00d5
;   64    if (slot >= DELAY_SLOTS) then return end if
                               movlw    2                   ;  2 OV rS rS [?l ?l] 0519 3002
                                                            ; W = v___slot_1
                               subwf    v___slot_1,w        ;  2 OV rS rS [?l ?l] 051a 0255
                               branchlo_nop l__l1175        ;  2 OV rS rS [?l ?l] 051b
                               btfsc    v__status, v__z     ;  2 OV rS rS [?l ?l] 051b 1903
                               goto     l__l1175            ;  2 OV rS rS [?l ?l] 051c 2d1f
                               branchlo_nop l__l657         ;  2 OV rS rS [?l ?l] 051d
                               btfss    v__status, v__c     ;  2 OV rS rS [?l ?l] 051d 1c03
                               goto     l__l657             ;  2 OV rS rS [?l ?l] 051e 2d20
l__l1175
                               return                       ;  2 OV rS rS [?l ?l] 051f 0008
l__l657
;   66    INTCON_TMR0IE = off
                               bcf      v_intcon, 5 ; intcon_tmr0ie      ;  2 OV rS rS [?l ?l] 0520 128b
;   67    isr_countdown[slot] = ticks
                               bcf      v__status, v__c     ;  2 OV rS rS [?l ?l] 0521 1003
                               rlf      v___slot_1,w        ;  2 OV rS rS [?l ?l] 0522 0d55
                               movwf    v____temp_41        ;  2 OV rS rS [?l ?l] 0523 00d9
                               movlw    v_isr_countdown     ;  2 OV rS rS [?l ?l] 0524 3048
                                                            ; W = v____temp_41
                               addwf    v____temp_41,w      ;  2 OV rS rS [?l ?l] 0525 0759
                               movwf    v__fsr              ;  2 OV rS rS [?l ?l] 0526 0084
                               irp_clr                      ;  2 OV rS rS [?l ?l] 0527 1383
                               movf     v___ticks_1,w       ;  2 OV rS rS [?l ?l] 0528 0857
                               movwf    v__ind              ;  2 OV rS rS [?l ?l] 0529 0080
                                                            ; W = v___ticks_1
                               incf     v__fsr,f            ;  2 OV rS rS [?l ?l] 052a 0a84
                               movf     v___ticks_1+1,w     ;  2 OV rS rS [?l ?l] 052b 0858
                               movwf    v__ind              ;  2 OV rS rS [?l ?l] 052c 0080
                                                            ; W = v___ticks_1
;   68    INTCON_TMR0IE = on
                               bsf      v_intcon, 5 ; intcon_tmr0ie      ;  2 OV rS rS [?l ?l] 052d 168b
;   70 end procedure
l__l655
                               return                       ;  2 OV rS rS [?l ?l] 052e 0008
;   72 function check_delay(byte in slot) return bit is
l_check_delay
                               datalo_set v___slot_3        ;  2 OV rs rS [?l ?l] 052f 1683
                               movwf    v___slot_3          ;  2 OV rS rS [?l ?l] 0530 00d5
;   74    if (slot >= DELAY_SLOTS) then return true end if
                               movlw    2                   ;  2 OV rS rS [?l ?l] 0531 3002
                                                            ; W = v___slot_3
                               subwf    v___slot_3,w        ;  2 OV rS rS [?l ?l] 0532 0255
                               branchlo_nop l__l1177        ;  2 OV rS rS [?l ?l] 0533
                               btfsc    v__status, v__z     ;  2 OV rS rS [?l ?l] 0533 1903
                               goto     l__l1177            ;  2 OV rS rS [?l ?l] 0534 2d37
                               branchlo_nop l__l661         ;  2 OV rS rS [?l ?l] 0535
                               btfss    v__status, v__c     ;  2 OV rS rS [?l ?l] 0535 1c03
                               goto     l__l661             ;  2 OV rS rS [?l ?l] 0536 2d3a
l__l1177
                               datalo_clr v__pic_temp ; _pic_temp    ;  2 OV rS rs [?l ?l] 0537 1283
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  2 OV rs rs [?l ?l] 0538 1420
                               return                       ;  2 OV rs rs [?l ?l] 0539 0008
l__l661
;   76    if (isr_countdown[slot] == 0) then
                               bcf      v__status, v__c     ;  2 OV rS rS [?l ?l] 053a 1003
                               rlf      v___slot_3,w        ;  2 OV rS rS [?l ?l] 053b 0d55
                               movwf    v____temp_42        ;  2 OV rS rS [?l ?l] 053c 00d7
                               movlw    v_isr_countdown     ;  2 OV rS rS [?l ?l] 053d 3048
                                                            ; W = v____temp_42
                               addwf    v____temp_42,w      ;  2 OV rS rS [?l ?l] 053e 0757
                               movwf    v__fsr              ;  2 OV rS rS [?l ?l] 053f 0084
                               irp_clr                      ;  2 OV rS rS [?l ?l] 0540 1383
                               movf     v__ind,w            ;  2 OV rS rS [?l ?l] 0541 0800
                               incf     v__fsr,f            ;  2 OV rS rS [?l ?l] 0542 0a84
                               iorwf    v__ind,w            ;  2 OV rS rS [?l ?l] 0543 0400
                               branchlo_nop l__l663         ;  2 OV rS rS [?l ?l] 0544
                               btfss    v__status, v__z     ;  2 OV rS rS [?l ?l] 0544 1d03
                               goto     l__l663             ;  2 OV rS rS [?l ?l] 0545 2d55
;   77       if (isr_countdown[slot] == 0) then
                               bcf      v__status, v__c     ;  2 OV rS rS [?l ?l] 0546 1003
                               rlf      v___slot_3,w        ;  2 OV rS rS [?l ?l] 0547 0d55
                               movwf    v____temp_42+1      ;  2 OV rS rS [?l ?l] 0548 00d8
                               movlw    v_isr_countdown     ;  2 OV rS rS [?l ?l] 0549 3048
                                                            ; W = v____temp_42
                               addwf    v____temp_42+1,w    ;  2 OV rS rS [?l ?l] 054a 0758
                               movwf    v__fsr              ;  2 OV rS rS [?l ?l] 054b 0084
                               irp_clr                      ;  2 OV rS rS [?l ?l] 054c 1383
                               movf     v__ind,w            ;  2 OV rS rS [?l ?l] 054d 0800
                               incf     v__fsr,f            ;  2 OV rS rS [?l ?l] 054e 0a84
                               iorwf    v__ind,w            ;  2 OV rS rS [?l ?l] 054f 0400
                               branchlo_nop l__l662         ;  2 OV rS rS [?l ?l] 0550
                               btfss    v__status, v__z     ;  2 OV rS rS [?l ?l] 0550 1d03
                               goto     l__l662             ;  2 OV rS rS [?l ?l] 0551 2d55
;   80          return true    -- delay passed
                               datalo_clr v__pic_temp ; _pic_temp    ;  2 OV rS rs [?l ?l] 0552 1283
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  2 OV rs rs [?l ?l] 0553 1420
                               return                       ;  2 OV rs rs [?l ?l] 0554 0008
;   82    end if
l__l663
l__l662
;   84    return false -- still waiting
                               datalo_clr v__pic_temp ; _pic_temp    ;  2 OV rS rs [?l ?l] 0555 1283
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  2 OV rs rs [?l ?l] 0556 1020
;   86 end function
l__l659
                               return                       ;  2 OV rs rs [?l ?l] 0557 0008
;   88 procedure timer0_isr_init() is
l_timer0_isr_init
;  108       T0CON_T0PS = 4 ; prescaler 32
                               movlw    248                 ;  1 OV rs rs [?l ?l] 0558 30f8
                                                            ; W = v_adc_conversion_delay
                               datalo_set v_option_reg      ;  1 OV rs rS [?l ?l] 0559 1683
                               andwf    v_option_reg,w      ;  1 OV rS rS [?l ?l] 055a 0501
                               iorlw    4                   ;  1 OV rS rS [?l ?l] 055b 3804
                               movwf    v_option_reg        ;  1 OV rS rS [?l ?l] 055c 0081
;  109       timer0_load = 255 - byte(timer0_div / 32)
                               movlw    99                  ;  1 OV rS rS [?l ?l] 055d 3063
                                                            ; W = v_option_reg
                               datalo_clr v_timer0_load     ;  1 OV rS rs [?l ?l] 055e 1283
                               movwf    v_timer0_load       ;  1 OV rs rs [?l ?l] 055f 00cc
;  128    T0CON_T0CS = 0  ; internal clock
                               datalo_set v_option_reg ; option_reg_t0cs   ;  1 OV rs rS [?l ?l] 0560 1683
                                                            ; W = v_timer0_load
                               bcf      v_option_reg, 5 ; option_reg_t0cs  ;  1 OV rS rS [?l ?l] 0561 1281
                                                            ; W = v_timer0_load
;  129    T0CON_PSA  = 0  ; assign prescaler to timer0
                               bcf      v_option_reg, 3 ; option_reg_psa  ;  1 OV rS rS [?l ?l] 0562 1181
                                                            ; W = v_timer0_load
;  131    INTCON_TMR0IF = off
                               bcf      v_intcon, 2 ; intcon_tmr0if      ;  1 OV rS rS [?l ?l] 0563 110b
                                                            ; W = v_timer0_load
;  132    INTCON_TMR0IE = on
                               bsf      v_intcon, 5 ; intcon_tmr0ie      ;  1 OV rS rS [?l ?l] 0564 168b
                                                            ; W = v_timer0_load
;  133    INTCON_GIE  = on    ; enable global interrupts
                               bsf      v_intcon, 7 ; intcon_gie      ;  1 OV rS rS [?l ?l] 0565 178b
                                                            ; W = v_timer0_load
;  134    INTCON_PEIE = on
                               bsf      v_intcon, 6 ; intcon_peie      ;  1 OV rS rS [?l ?l] 0566 170b
                                                            ; W = v_timer0_load
;  137    for DELAY_SLOTS using i loop
                               datalo_clr v___i_1           ;  1 OV rS rs [?l ?l] 0567 1283
                                                            ; W = v_timer0_load
                               clrf     v___i_1             ;  1 OV rs rs [?l ?l] 0568 01ea
                                                            ; W = v_timer0_load
l__l673
;  138       isr_countdown[i] = 0
                               bcf      v__status, v__c     ;  1 OV rs rs [?l ?l] 0569 1003
                               rlf      v___i_1,w           ;  1 OV rs rs [?l ?l] 056a 0d6a
                               movwf    v____temp_43        ;  1 OV rs rs [?l ?l] 056b 00ec
                               movlw    v_isr_countdown     ;  1 OV rs rs [?l ?l] 056c 3048
                                                            ; W = v____temp_43
                               addwf    v____temp_43,w      ;  1 OV rs rs [?l ?l] 056d 076c
                               movwf    v__fsr              ;  1 OV rs rs [?l ?l] 056e 0084
                               irp_clr                      ;  1 OV rs rs [?l ?l] 056f 1383
                               clrf     v__ind              ;  1 OV rs rs [?l ?l] 0570 0180
                               incf     v__fsr,f            ;  1 OV rs rs [?l ?l] 0571 0a84
                               clrf     v__ind              ;  1 OV rs rs [?l ?l] 0572 0180
;  139    end loop
                               incf     v___i_1,f           ;  1 OV rs rs [?l ?l] 0573 0aea
                               movlw    2                   ;  1 OV rs rs [?l ?l] 0574 3002
                               subwf    v___i_1,w           ;  1 OV rs rs [?l ?l] 0575 026a
                               branchlo_nop l__l673         ;  1 OV rs rs [?l ?l] 0576
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0576 1d03
                               goto     l__l673             ;  1 OV rs rs [?l ?l] 0577 2d69
;  142 end procedure
                               return                       ;  1 OV rs rs [?l ?l] 0578 0008
;  144 procedure ISR() is
l_isr
;  147    if INTCON_TMR0IF == true then
                               branchlo_nop l__l679         ;  5 OV rs rs [hl hl] 0579
                               btfss    v_intcon, 2 ; intcon_tmr0if      ;  5 OV rs rs [hl hl] 0579 1d0b
                               goto     l__l679             ;  5 OV rs rs [hl hl] 057a 2db0
;  148       tmr0 = timer0_load
                               movf     v_timer0_load,w     ;  5 OV rs rs [hl hl] 057b 084c
                               movwf    v_tmr0              ;  5 OV rs rs [hl hl] 057c 0081
                                                            ; W = v_timer0_load
;  151       internal_isr_counter = internal_isr_counter + 1
                               incf     v_internal_isr_counter,f;  5 OV rs rs [hl hl] 057d 0ac6
                               btfsc    v__status, v__z     ;  5 OV rs rs [hl hl] 057e 1903
                               incf     v_internal_isr_counter+1,f;  5 OV rs rs [hl hl] 057f 0ac7
;  154       for DELAY_SLOTS using index loop
                               clrf     v_index             ;  5 OV rs rs [hl hl] 0580 01bf
l__l680
;  155          if (isr_countdown[index] != 0) then
                               bcf      v__status, v__c     ;  5 OV rs rs [hl hl] 0581 1003
                               rlf      v_index,w           ;  5 OV rs rs [hl hl] 0582 0d3f
                               movwf    v____temp_44        ;  5 OV rs rs [hl hl] 0583 00bc
                               movlw    v_isr_countdown     ;  5 OV rs rs [hl hl] 0584 3048
                                                            ; W = v____temp_44
                               addwf    v____temp_44,w      ;  5 OV rs rs [hl hl] 0585 073c
                               movwf    v__fsr              ;  5 OV rs rs [hl hl] 0586 0084
                               irp_clr                      ;  5 OV rs rs [hl hl] 0587 1383
                               movf     v__ind,w            ;  5 OV rs rs [hl hl] 0588 0800
                               incf     v__fsr,f            ;  5 OV rs rs [hl hl] 0589 0a84
                               iorwf    v__ind,w            ;  5 OV rs rs [hl hl] 058a 0400
                               branchlo_nop l__l684         ;  5 OV rs rs [hl hl] 058b
                               btfsc    v__status, v__z     ;  5 OV rs rs [hl hl] 058b 1903
                               goto     l__l684             ;  5 OV rs rs [hl hl] 058c 2daa
;  156             isr_countdown[index] = isr_countdown[index] - 1
                               bcf      v__status, v__c     ;  5 OV rs rs [hl hl] 058d 1003
                               rlf      v_index,w           ;  5 OV rs rs [hl hl] 058e 0d3f
                               movwf    v____temp_44+1      ;  5 OV rs rs [hl hl] 058f 00bd
                               bcf      v__status, v__c     ;  5 OV rs rs [hl hl] 0590 1003
                                                            ; W = v____temp_44
                               rlf      v_index,w           ;  5 OV rs rs [hl hl] 0591 0d3f
                                                            ; W = v____temp_44
                               movwf    v____temp_44+2      ;  5 OV rs rs [hl hl] 0592 00be
                               movlw    v_isr_countdown     ;  5 OV rs rs [hl hl] 0593 3048
                                                            ; W = v____temp_44
                               addwf    v____temp_44+2,w    ;  5 OV rs rs [hl hl] 0594 073e
                               movwf    v__fsr              ;  5 OV rs rs [hl hl] 0595 0084
                               irp_clr                      ;  5 OV rs rs [hl hl] 0596 1383
                               movf     v__ind,w            ;  5 OV rs rs [hl hl] 0597 0800
                               movwf    v__pic_temp         ;  5 OV rs rs [hl hl] 0598 00a0
                               incf     v__fsr,f            ;  5 OV rs rs [hl hl] 0599 0a84
                                                            ; W = v__pic_temp
                               movf     v__ind,w            ;  5 OV rs rs [hl hl] 059a 0800
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  5 OV rs rs [hl hl] 059b 00a1
                               movlw    v_isr_countdown+1   ;  5 OV rs rs [hl hl] 059c 3049
                                                            ; W = v__pic_temp
                               addwf    v____temp_44+1,w    ;  5 OV rs rs [hl hl] 059d 073d
                               movwf    v__fsr              ;  5 OV rs rs [hl hl] 059e 0084
                               irp_clr                      ;  5 OV rs rs [hl hl] 059f 1383
                               movf     v__pic_temp+1,w     ;  5 OV rs rs [hl hl] 05a0 0821
                               movwf    v__ind              ;  5 OV rs rs [hl hl] 05a1 0080
                                                            ; W = v__pic_temp
                               decf     v__fsr,f            ;  5 OV rs rs [hl hl] 05a2 0384
                               movlw    1                   ;  5 OV rs rs [hl hl] 05a3 3001
                               subwf    v__pic_temp,w       ;  5 OV rs rs [hl hl] 05a4 0220
                               movwf    v__ind              ;  5 OV rs rs [hl hl] 05a5 0080
                               movlw    1                   ;  5 OV rs rs [hl hl] 05a6 3001
                               incf     v__fsr,f            ;  5 OV rs rs [hl hl] 05a7 0a84
                               btfss    v__status, v__c     ;  5 OV rs rs [hl hl] 05a8 1c03
                               subwf    v__ind,f            ;  5 OV rs rs [hl hl] 05a9 0280
;  157          end if
l__l684
;  158       end loop
                               incf     v_index,f           ;  5 OV rs rs [hl hl] 05aa 0abf
                               movlw    2                   ;  5 OV rs rs [hl hl] 05ab 3002
                               subwf    v_index,w           ;  5 OV rs rs [hl hl] 05ac 023f
                               branchlo_nop l__l680         ;  5 OV rs rs [hl hl] 05ad
                               btfss    v__status, v__z     ;  5 OV rs rs [hl hl] 05ad 1d03
                               goto     l__l680             ;  5 OV rs rs [hl hl] 05ae 2d81
;  165       INTCON_TMR0IF = off
                               bcf      v_intcon, 2 ; intcon_tmr0if      ;  5 OV rs rs [hl hl] 05af 110b
;  167    end if
l__l679
;  169 end procedure
                               movf     v__pic_isr_state,w  ;  5 OV rs rs [hl hl] 05b0 0830
                               movwf    v__pic_state        ;  5 OV rs rs [hl hl] 05b1 00a0
                               movf     v__pic_isr_state+1,w;  5 OV rs rs [hl hl] 05b2 0831
                                                            ; W = v__pic_state
                               movwf    v__pic_state+1      ;  5 OV rs rs [hl hl] 05b3 00a1
                               movf     v__pic_isr_fsr,w    ;  5 OV rs rs [hl hl] 05b4 0838
                                                            ; W = v__pic_state
                               movwf    v__fsr              ;  5 OV rs rs [hl hl] 05b5 0084
                                                            ; W = v__pic_isr_fsr
                               movf     v__pic_isr_pclath,w ;  5 -V rs rs [hl hl] 05b6 0833
                               movwf    v__pclath           ;  5 -V rs rs [hl hl] 05b7 008a
                                                            ; W = v__pic_isr_pclath
                               swapf    v__pic_isr_status,w ;  5 -V rs rs [hl hl] 05b8 0e32
                               movwf    v__status           ;  5 -V rs rs [hl hl] 05b9 0083
                               swapf    v__pic_isr_w,f      ;  5 -V rs rs [hl hl] 05ba 0eff
                               swapf    v__pic_isr_w,w      ;  5 -V rs rs [hl hl] 05bb 0e7f
                               retfie                       ;  5 -V rs rs [hl hl] 05bc 0009
l__l676
; rikishi2.jal
;   86 timer0_isr_init()                   -- init timer0 isr
                               branchlo_nop l_timer0_isr_init;  0 OV rs rs [?l ?l] 05bd
                                                            ; W = v_adc_conversion_delay
                               call     l_timer0_isr_init   ;  0 OV rs ?? [?l ??] 05bd 2558
                                                            ; W = v_adc_conversion_delay
; i2c_hardware.jal
;   35 procedure i2c_initialize() is
                               branchlo_clr l__l713         ;  0 OV ?? ?? [?? ?l] 05be 118a
                               goto     l__l713             ;  0 OV ?? ?? [?l ?l] 05bf 2e07
;   67 procedure i2c_start() is
l_i2c_start
;   68    SSPCON2_SEN = high
                               datalo_set v_sspcon2 ; sspcon2_sen      ;  3 OV Rs RS [?l ?l] 05c0 1683
                                                            ; W = v___addr_1
                               datahi_clr v_sspcon2 ; sspcon2_sen      ;  3 OV RS rS [?l ?l] 05c1 1303
                                                            ; W = v___addr_1
                               bsf      v_sspcon2, 0 ; sspcon2_sen     ;  3 OV rS rS [?l ?l] 05c2 1411
                                                            ; W = v___addr_1
;   69    while SSPCON2_SEN == high loop end loop
l__l693
                               branchlo_nop l__l694         ;  3 OV rS rS [?l ?l] 05c3
                                                            ; W = v___addr_1
                               btfss    v_sspcon2, 0 ; sspcon2_sen     ;  3 OV rS rS [?l ?l] 05c3 1c11
                                                            ; W = v___addr_1
                               goto     l__l694             ;  3 OV rS rS [?l ?l] 05c4 2dc6
                                                            ; W = v___addr_1
                               branchlo_nop l__l693         ;  3 OV rS rS [?l ?l] 05c5
                                                            ; W = v___addr_1
                               goto     l__l693             ;  3 OV rS rS [?l ?l] 05c5 2dc3
                                                            ; W = v___addr_1
l__l694
;   70 end procedure
                               return                       ;  3 OV rS rS [?l ?l] 05c6 0008
                                                            ; W = v___addr_1
;   76 procedure i2c_restart() is
l_i2c_restart
;   77    SSPCON2_RSEN = high
                               datalo_set v_sspcon2 ; sspcon2_rsen      ;  3 OV ?? ?S [?l ?l] 05c7 1683
                               datahi_clr v_sspcon2 ; sspcon2_rsen      ;  3 OV ?S rS [?l ?l] 05c8 1303
                               bsf      v_sspcon2, 1 ; sspcon2_rsen     ;  3 OV rS rS [?l ?l] 05c9 1491
;   78    while SSPCON2_RSEN == high loop end loop
l__l698
                               branchlo_nop l__l699         ;  3 OV rS rS [?l ?l] 05ca
                               btfss    v_sspcon2, 1 ; sspcon2_rsen     ;  3 OV rS rS [?l ?l] 05ca 1c91
                               goto     l__l699             ;  3 OV rS rS [?l ?l] 05cb 2dcd
                               branchlo_nop l__l698         ;  3 OV rS rS [?l ?l] 05cc
                               goto     l__l698             ;  3 OV rS rS [?l ?l] 05cc 2dca
l__l699
;   79 end procedure
                               return                       ;  3 OV rS rS [?l ?l] 05cd 0008
;   85 procedure i2c_stop() is
l_i2c_stop
;   86    SSPCON2_PEN = high
                               datalo_set v_sspcon2 ; sspcon2_pen      ;  3 OV Rs RS [?l ?l] 05ce 1683
                                                            ; W = v_chr
                               datahi_clr v_sspcon2 ; sspcon2_pen      ;  3 OV RS rS [?l ?l] 05cf 1303
                                                            ; W = v_chr
                               bsf      v_sspcon2, 2 ; sspcon2_pen     ;  3 OV rS rS [?l ?l] 05d0 1511
                                                            ; W = v_chr
;   87    while SSPCON2_PEN == high loop end loop
l__l703
                               branchlo_nop l__l704         ;  3 OV rS rS [?l ?l] 05d1
                                                            ; W = v_chr
                               btfss    v_sspcon2, 2 ; sspcon2_pen     ;  3 OV rS rS [?l ?l] 05d1 1d11
                                                            ; W = v_chr
                               goto     l__l704             ;  3 OV rS rS [?l ?l] 05d2 2dd4
                                                            ; W = v_chr
                               branchlo_nop l__l703         ;  3 OV rS rS [?l ?l] 05d3
                                                            ; W = v_chr
                               goto     l__l703             ;  3 OV rS rS [?l ?l] 05d3 2dd1
                                                            ; W = v_chr
l__l704
;   88 end procedure
                               return                       ;  3 OV rS rS [?l ?l] 05d4 0008
                                                            ; W = v_chr
;   95 function i2c_transmit_byte(byte in data) return bit is
l_i2c_transmit_byte
                               datalo_clr v___data_57       ;  3 OV ?? ?s [?l ?l] 05d5 1283
                               datahi_set v___data_57       ;  3 OV ?s Rs [?l ?l] 05d6 1703
                               movwf    v___data_57         ;  3 OV Rs Rs [?l ?l] 05d7 00ba
;   97    PIR1_SSPIF = false  ; clear pending flag
                               datahi_clr v_pir1 ; pir1_sspif         ;  3 OV Rs rs [?l ?l] 05d8 1303
                                                            ; W = v___data_57
                               bcf      v_pir1, 3 ; pir1_sspif        ;  3 OV rs rs [?l ?l] 05d9 118c
                                                            ; W = v___data_57
;   98    sspbuf = data       ; write data
                               datahi_set v___data_57       ;  3 OV rs Rs [?l ?l] 05da 1703
                                                            ; W = v___data_57
                               movf     v___data_57,w       ;  3 OV Rs Rs [?l ?l] 05db 083a
                                                            ; W = v___data_57
                               datahi_clr v_sspbuf          ;  3 OV Rs rs [?l ?l] 05dc 1303
                                                            ; W = v___data_57
                               movwf    v_sspbuf            ;  3 OV rs rs [?l ?l] 05dd 0093
                                                            ; W = v___data_57
;  101    while ! PIR1_SSPIF loop end loop
l__l708
                               branchlo_nop l__l709         ;  3 OV rs rs [?l ?l] 05de
                               btfsc    v_pir1, 3 ; pir1_sspif        ;  3 OV rs rs [?l ?l] 05de 198c
                               goto     l__l709             ;  3 OV rs rs [?l ?l] 05df 2de1
                               branchlo_nop l__l708         ;  3 OV rs rs [?l ?l] 05e0
                               goto     l__l708             ;  3 OV rs rs [?l ?l] 05e0 2dde
l__l709
;  106    if SSPCON2_ACKSTAT == low  then
                               datalo_set v_sspcon2 ; sspcon2_ackstat      ;  3 OV rs rS [?l ?l] 05e1 1683
                               branchlo_nop l__l712         ;  3 OV rS rS [?l ?l] 05e2
                               btfsc    v_sspcon2, 6 ; sspcon2_ackstat     ;  3 OV rS rS [?l ?l] 05e2 1b11
                               goto     l__l712             ;  3 OV rS rS [?l ?l] 05e3 2de7
;  107       return true -- okay
                               datalo_clr v__pic_temp ; _pic_temp    ;  3 OV rS rs [?l ?l] 05e4 1283
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  3 OV rs rs [?l ?l] 05e5 1420
                               return                       ;  3 OV rs rs [?l ?l] 05e6 0008
;  108    else
l__l712
;  109       sspcon_sspen = false;
                               datalo_clr v_sspcon ; sspcon_sspen       ;  3 OV rS rs [?l ?l] 05e7 1283
                               bcf      v_sspcon, 5 ; sspcon_sspen      ;  3 OV rs rs [?l ?l] 05e8 1294
;  110       sspcon_sspen = true;
                               bsf      v_sspcon, 5 ; sspcon_sspen      ;  3 OV rs rs [?l ?l] 05e9 1694
;  112       return false -- no response
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  3 OV rs rs [?l ?l] 05ea 1020
;  113    end if
;  114 end function
l__l707
                               return                       ;  3 OV rs rs [?l ?l] 05eb 0008
;  126 function i2c_receive_byte(bit in ACK ) return byte is
l_i2c_receive_byte
;  129    SSPCON2_RCEN = high
                               datalo_set v_sspcon2 ; sspcon2_rcen      ;  3 OV Rs RS [?l ?l] 05ec 1683
                               datahi_clr v_sspcon2 ; sspcon2_rcen      ;  3 OV RS rS [?l ?l] 05ed 1303
                               bsf      v_sspcon2, 3 ; sspcon2_rcen     ;  3 OV rS rS [?l ?l] 05ee 1591
;  131    while SSPSTAT_BF == low loop  end loop
l__l715
                               branchlo_nop l__l716         ;  3 OV rS rS [?l ?l] 05ef
                               btfsc    v_sspstat, 0 ; sspstat_bf     ;  3 OV rS rS [?l ?l] 05ef 1814
                               goto     l__l716             ;  3 OV rS rS [?l ?l] 05f0 2df2
                               branchlo_nop l__l715         ;  3 OV rS rS [?l ?l] 05f1
                                                            ; W = v___data_58
                               goto     l__l715             ;  3 OV rS rS [?l ?l] 05f1 2def
                                                            ; W = v___data_58
l__l716
;  135    SSPCON2_ACKDT = ! ACK
                               datalo_clr v____bitbucket_34 ; ack1;  3 OV rS rs [?l ?l] 05f2 1283
                               datahi_set v____bitbucket_34 ; ack1;  3 OV rs Rs [?l ?l] 05f3 1703
                               branchlo_nop l__l1179        ;  3 OV Rs Rs [?l ?l] 05f4
                               btfss    v____bitbucket_34, 0 ; ack1;  3 OV Rs Rs [?l ?l] 05f4 1c3c
                               goto     l__l1179            ;  3 OV Rs Rs [?l ?l] 05f5 2dfa
                               datalo_set v_sspcon2 ; sspcon2_ackdt      ;  3 OV Rs RS [?l ?l] 05f6 1683
                                                            ; W = v___data_58
                               datahi_clr v_sspcon2 ; sspcon2_ackdt      ;  3 OV RS rS [?l ?l] 05f7 1303
                                                            ; W = v___data_58
                               bcf      v_sspcon2, 5 ; sspcon2_ackdt     ;  3 OV rS rS [?l ?l] 05f8 1291
                                                            ; W = v___data_58
                               branchlo_nop l__l1178        ;  3 OV rS rS [?l ?l] 05f9
                                                            ; W = v___data_58
                               goto     l__l1178            ;  3 OV rS rS [?l ?l] 05f9 2dfd
                                                            ; W = v___data_58
l__l1179
                               datalo_set v_sspcon2 ; sspcon2_ackdt      ;  3 OV Rs RS [?l ?l] 05fa 1683
                               datahi_clr v_sspcon2 ; sspcon2_ackdt      ;  3 OV RS rS [?l ?l] 05fb 1303
                               bsf      v_sspcon2, 5 ; sspcon2_ackdt     ;  3 OV rS rS [?l ?l] 05fc 1691
l__l1178
;  136    SSPCON2_ACKEN = high
                               bsf      v_sspcon2, 4 ; sspcon2_acken     ;  3 OV rS rS [?l ?l] 05fd 1611
;  137    while SSPCON2_ACKEN == high loop end loop
l__l718
                               branchlo_nop l__l719         ;  3 OV rS rS [?l ?l] 05fe
                               btfss    v_sspcon2, 4 ; sspcon2_acken     ;  3 OV rS rS [?l ?l] 05fe 1e11
                               goto     l__l719             ;  3 OV rS rS [?l ?l] 05ff 2e01
                               branchlo_nop l__l718         ;  3 OV rS rS [?l ?l] 0600
                                                            ; W = v___data_58
                               goto     l__l718             ;  3 OV rS rS [?l ?l] 0600 2dfe
                                                            ; W = v___data_58
l__l719
;  140    data = sspbuf
                               datalo_clr v_sspbuf          ;  3 OV rS rs [?l ?l] 0601 1283
                               movf     v_sspbuf,w          ;  3 OV rs rs [?l ?l] 0602 0813
                               datahi_set v___data_58       ;  3 OV rs Rs [?l ?l] 0603 1703
                               movwf    v___data_58         ;  3 OV Rs Rs [?l ?l] 0604 00ba
;  144    return data
                               movf     v___data_58,w       ;  3 OV Rs Rs [?l ?l] 0605 083a
                                                            ; W = v___data_58
;  145 end function
                               return                       ;  3 OV Rs Rs [?l ?l] 0606 0008
                                                            ; W = v___data_58
l__l713
; rikishi2.jal
;  103 pin_b5_direction = output  -- bridge_1
                               datalo_set v_trisb ; pin_b5_direction        ;  0 OV ?? ?S [?l ?l] 0607 1683
                               bcf      v_trisb, 5 ; pin_b5_direction       ;  0 OV ?S ?S [?l ?l] 0608 1286
;  104 pin_b4_direction = output  -- bridge_2
                               bcf      v_trisb, 4 ; pin_b4_direction       ;  0 OV ?S ?S [?l ?l] 0609 1206
;  105 pin_b2_direction = output  -- bridge_3
                               bcf      v_trisb, 2 ; pin_b2_direction       ;  0 OV ?S ?S [?l ?l] 060a 1106
;  106 pin_b1_direction = output  -- bridge_4
                               bcf      v_trisb, 1 ; pin_b1_direction       ;  0 OV ?S ?S [?l ?l] 060b 1086
;  108 bridge_1 = low
                               datalo_clr v__portb_shadow ; x74;  0 OV ?S ?s [?l ?l] 060c 1283
                               datahi_clr v__portb_shadow ; x74;  0 OV ?s rs [?l ?l] 060d 1303
                               bcf      v__portb_shadow, 5 ; x74;  0 OV rs rs [?l ?l] 060e 12c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?l ?l] 060f 0843
                               movwf    v_portb             ;  0 OV rs rs [?l ?l] 0610 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  108 bridge_1 = low
; 16f876a.jal
;  246    _PORTB_flush()
; rikishi2.jal
;  108 bridge_1 = low
;  109 bridge_2 = low
                               bcf      v__portb_shadow, 4 ; x75;  0 OV rs rs [?l ?l] 0611 1243
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?l ?l] 0612 0843
                               movwf    v_portb             ;  0 OV rs rs [?l ?l] 0613 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  109 bridge_2 = low
; 16f876a.jal
;  254    _PORTB_flush()
; rikishi2.jal
;  109 bridge_2 = low
;  110 bridge_3 = low
                               bcf      v__portb_shadow, 2 ; x76;  0 OV rs rs [?l ?l] 0614 1143
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?l ?l] 0615 0843
                               movwf    v_portb             ;  0 OV rs rs [?l ?l] 0616 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  110 bridge_3 = low
; 16f876a.jal
;  271    _PORTB_flush()
; rikishi2.jal
;  110 bridge_3 = low
;  111 bridge_4 = low
                               bcf      v__portb_shadow, 1 ; x77;  0 OV rs rs [?l ?l] 0617 10c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?l ?l] 0618 0843
                               movwf    v_portb             ;  0 OV rs rs [?l ?l] 0619 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  111 bridge_4 = low
; 16f876a.jal
;  279    _PORTB_flush()
; rikishi2.jal
;  111 bridge_4 = low
;  114 pin_ccp1_direction = output
                               datalo_set v_trisc ; pin_c2_direction        ;  0 OV rs rS [?l ?l] 061a 1683
                               bcf      v_trisc, 2 ; pin_c2_direction       ;  0 OV rS rS [?l ?l] 061b 1107
;  115 pin_ccp2_direction = output
                               bcf      v_trisc, 1 ; pin_c1_direction       ;  0 OV rS rS [?l ?l] 061c 1087
; pwm_common.jal
;   23 var volatile word _pr2_shadow_plus1 = 256           -- value(PR2) + 1
                               datalo_clr v__pr2_shadow_plus1;  0 OV rS rs [?l ?l] 061d 1283
                               clrf     v__pr2_shadow_plus1 ;  0 OV rs rs [?l ?l] 061e 01ba
                               movlw    1                   ;  0 OV rs rs [?l ?l] 061f 3001
                               movwf    v__pr2_shadow_plus1+1;  0 OV rs rs [?l ?l] 0620 00bb
;   50 procedure pwm_max_resolution(byte in prescaler) is
                               branchlo_nop l__l735         ;  0 OV rs rs [?l ?l] 0621
                               goto     l__l735             ;  0 OV rs rs [?l ?l] 0621 2e48
l_pwm_max_resolution
                               movwf    v___prescaler_1     ;  1 OV rs rs [?l ?l] 0622 00ea
;   52    _pr2_shadow_plus1 = 256                      -- for maximum resolution
                               clrf     v__pr2_shadow_plus1 ;  1 OV rs rs [?l ?l] 0623 01ba
                                                            ; W = v___prescaler_1
                               movlw    1                   ;  1 OV rs rs [?l ?l] 0624 3001
                                                            ; W = v___prescaler_1
                               movwf    v__pr2_shadow_plus1+1;  1 OV rs rs [?l ?l] 0625 00bb
;   53    PR2 = byte(_pr2_shadow_plus1 - 1)            -- set PR2
                               decf     v__pr2_shadow_plus1,w;  1 OV rs rs [?l ?l] 0626 033a
                               datalo_set v_pr2             ;  1 OV rs rS [?l ?l] 0627 1683
                               movwf    v_pr2               ;  1 OV rS rS [?l ?l] 0628 0092
;   56    if prescaler == 1 then
                               movlw    1                   ;  1 OV rS rS [?l ?l] 0629 3001
                               datalo_clr v___prescaler_1   ;  1 OV rS rs [?l ?l] 062a 1283
                               subwf    v___prescaler_1,w   ;  1 OV rs rs [?l ?l] 062b 026a
                               branchlo_nop l__l732         ;  1 OV rs rs [?l ?l] 062c
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 062c 1d03
                               goto     l__l732             ;  1 OV rs rs [?l ?l] 062d 2e32
;   57       T2CON_T2CKPS = 0b00                       -- prescaler 1:1
                               movlw    252                 ;  1 OV rs rs [?l ?l] 062e 30fc
                                                            ; W = v_t2con
                               andwf    v_t2con,f           ;  1 OV rs rs [?l ?l] 062f 0592
;   58       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?l ?l] 0630 1512
;   59    elsif prescaler == 4  then
                               return                       ;  1 OV rs rs [?l ?l] 0631 0008
l__l732
                               movlw    4                   ;  1 OV rs rs [?l ?l] 0632 3004
                               subwf    v___prescaler_1,w   ;  1 OV rs rs [?l ?l] 0633 026a
                               branchlo_nop l__l733         ;  1 OV rs rs [?l ?l] 0634
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0634 1d03
                               goto     l__l733             ;  1 OV rs rs [?l ?l] 0635 2e3c
;   60       T2CON_T2CKPS = 0b01                       -- prescaler 1:4
                               movlw    252                 ;  1 OV rs rs [?l ?l] 0636 30fc
                                                            ; W = v_t2con
                               andwf    v_t2con,w           ;  1 OV rs rs [?l ?l] 0637 0512
                               iorlw    1                   ;  1 OV rs rs [?l ?l] 0638 3801
                               movwf    v_t2con             ;  1 OV rs rs [?l ?l] 0639 0092
;   61       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?l ?l] 063a 1512
                                                            ; W = v_t2con
;   62    elsif prescaler == 16 then
                               return                       ;  1 OV rs rs [?l ?l] 063b 0008
                                                            ; W = v_t2con
l__l733
                               movlw    16                  ;  1 OV rs rs [?l ?l] 063c 3010
                               subwf    v___prescaler_1,w   ;  1 OV rs rs [?l ?l] 063d 026a
                               branchlo_nop l__l734         ;  1 OV rs rs [?l ?l] 063e
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 063e 1d03
                               goto     l__l734             ;  1 OV rs rs [?l ?l] 063f 2e46
;   63       T2CON_T2CKPS = 0b10                       -- prescaler 1:16
                               movlw    252                 ;  1 OV rs rs [?l ?l] 0640 30fc
                               andwf    v_t2con,w           ;  1 OV rs rs [?l ?l] 0641 0512
                               iorlw    2                   ;  1 OV rs rs [?l ?l] 0642 3802
                               movwf    v_t2con             ;  1 OV rs rs [?l ?l] 0643 0092
;   64       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?l ?l] 0644 1512
                                                            ; W = v_t2con
;   65    else
                               return                       ;  1 OV rs rs [?l ?l] 0645 0008
                                                            ; W = v_t2con
l__l734
;   66       T2CON_TMR2ON = FALSE                      -- disable Timer2 (= PWM off!)
                               bcf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?l ?l] 0646 1112
;   67    end if
l__l731
;   69 end procedure
                               return                       ;  1 OV rs rs [?l ?l] 0647 0008
;  105 end procedure
l__l735
; pwm_ccp1.jal
;   23 var byte  _ccpr1l_shadow  = 0                            -- 8 MSbits of duty cycle
                               clrf     v__ccpr1l_shadow    ;  0 OV rs rs [?l ?l] 0648 01cd
;   24 var byte  _ccp1con_shadow = 0b0000_0000                  -- shadow
                               clrf     v__ccp1con_shadow   ;  0 OV rs rs [?l ?l] 0649 01ce
;   32 procedure pwm1_on() is
                               branchlo_nop l__l742         ;  0 OV rs rs [?l ?l] 064a
                               goto     l__l742             ;  0 OV rs rs [?l ?l] 064a 2e56
l_pwm1_on
;   34    _ccp1con_shadow_ccp1m = 0b1100                    -- set PWM mode
                               movlw    240                 ;  1 OV ?? ?? [?l ?l] 064b 30f0
                               datalo_clr v__ccp1con_shadow ;  1 OV ?? ?s [?l ?l] 064c 1283
                               datahi_clr v__ccp1con_shadow ;  1 OV ?s rs [?l ?l] 064d 1303
                               andwf    v__ccp1con_shadow,w ;  1 OV rs rs [?l ?l] 064e 054e
                               iorlw    12                  ;  1 OV rs rs [?l ?l] 064f 380c
                               movwf    v__ccp1con_shadow   ;  1 OV rs rs [?l ?l] 0650 00ce
;   35    CCPR1L                = _ccpr1l_shadow            -- restore duty cycle
                               movf     v__ccpr1l_shadow,w  ;  1 OV rs rs [?l ?l] 0651 084d
                                                            ; W = v__ccp1con_shadow
                               movwf    v_ccpr1l            ;  1 OV rs rs [?l ?l] 0652 0095
                                                            ; W = v__ccpr1l_shadow
;   36    CCP1CON               = _ccp1con_shadow           -- activate CCP module
                               movf     v__ccp1con_shadow,w ;  1 OV rs rs [?l ?l] 0653 084e
                               movwf    v_ccp1con           ;  1 OV rs rs [?l ?l] 0654 0097
                                                            ; W = v__ccp1con_shadow
;   38 end procedure
                               return                       ;  1 OV rs rs [?l ?l] 0655 0008
; pwm_hardware.jal
;   51 end if
l__l742
; pwm_ccp2.jal
;   23 var byte  _ccpr2l_shadow  = 0                            -- 8 MSbits of duty cycle
                               clrf     v__ccpr2l_shadow    ;  0 OV rs rs [?l ?l] 0656 01cf
;   24 var byte  _ccp2con_shadow = 0b0000_0000                  -- shadow
                               clrf     v__ccp2con_shadow   ;  0 OV rs rs [?l ?l] 0657 01d0
;   32 procedure pwm2_on() is
                               branchlo_nop l__l761         ;  0 OV rs rs [?l ?l] 0658
                               goto     l__l761             ;  0 OV rs rs [?l ?l] 0658 2e64
l_pwm2_on
;   34    _ccp2con_shadow_ccp2m = 0b1100                    -- set PWM mode
                               movlw    240                 ;  1 OV ?? ?? [?l ?l] 0659 30f0
                               datalo_clr v__ccp2con_shadow ;  1 OV ?? ?s [?l ?l] 065a 1283
                               datahi_clr v__ccp2con_shadow ;  1 OV ?s rs [?l ?l] 065b 1303
                               andwf    v__ccp2con_shadow,w ;  1 OV rs rs [?l ?l] 065c 0550
                               iorlw    12                  ;  1 OV rs rs [?l ?l] 065d 380c
                               movwf    v__ccp2con_shadow   ;  1 OV rs rs [?l ?l] 065e 00d0
;   35    CCPR2L                = _ccpr2l_shadow            -- restore duty cycle
                               movf     v__ccpr2l_shadow,w  ;  1 OV rs rs [?l ?l] 065f 084f
                                                            ; W = v__ccp2con_shadow
                               movwf    v_ccpr2l            ;  1 OV rs rs [?l ?l] 0660 009b
                                                            ; W = v__ccpr2l_shadow
;   36    CCP2CON               = _ccp2con_shadow           -- activate CCP module
                               movf     v__ccp2con_shadow,w ;  1 OV rs rs [?l ?l] 0661 0850
                               movwf    v_ccp2con           ;  1 OV rs rs [?l ?l] 0662 009d
                                                            ; W = v__ccp2con_shadow
;   38 end procedure
                               return                       ;  1 OV rs rs [?l ?l] 0663 0008
; pwm_hardware.jal
;   55 end if
l__l761
; rikishi2.jal
;  117 pwm_max_resolution(1)
                               movlw    1                   ;  0 OV rs rs [?l ?l] 0664 3001
                               branchlo_nop l_pwm_max_resolution;  0 OV rs rs [?l ?l] 0665
                               call     l_pwm_max_resolution;  0 OV rs ?? [?l ??] 0665 2622
;  118 pwm1_on()
                               branchlo_clr l_pwm1_on       ;  0 OV ?? ?? [?? ?l] 0666 118a
                               call     l_pwm1_on           ;  0 OV ?? ?? [?l ??] 0667 264b
;  119 pwm2_on()
                               branchlo_clr l_pwm2_on       ;  0 OV ?? ?? [?? ?l] 0668 118a
                               call     l_pwm2_on           ;  0 OV ?? ?? [?l ??] 0669 2659
;  130    pin_b7_direction = output
                               datalo_set v_trisb ; pin_b7_direction        ;  0 OV ?? ?S [?? ??] 066a 1683
                               bcf      v_trisb, 7 ; pin_b7_direction       ;  0 OV ?S ?S [?? ??] 066b 1386
;  131    pin_b6_direction = output
                               bcf      v_trisb, 6 ; pin_b6_direction       ;  0 OV ?S ?S [?? ??] 066c 1306
;  132    pin_b3_direction = output
                               bcf      v_trisb, 3 ; pin_b3_direction       ;  0 OV ?S ?S [?? ??] 066d 1186
; buttons.jal
;   10 procedure Buttons is
                               branchlo_clr l__l854         ;  0 OV ?S ?S [?? ?l] 066e 118a
                               goto     l__l854             ;  0 OV ?S ?S [?l ?l] 066f 2faf
l_buttons
;   12    pin_b3_direction = input
                               datalo_set v_trisb ; pin_b3_direction        ;  1 OV rs rS [?l ?l] 0670 1683
                                                            ; W = v_previsr_counter
                               bsf      v_trisb, 3 ; pin_b3_direction       ;  1 OV rS rS [?l ?l] 0671 1586
                                                            ; W = v_previsr_counter
;   13    pin_b6_direction = input
                               bsf      v_trisb, 6 ; pin_b6_direction       ;  1 OV rS rS [?l ?l] 0672 1706
                                                            ; W = v_previsr_counter
;   14    pin_b7_direction = input
                               bsf      v_trisb, 7 ; pin_b7_direction       ;  1 OV rS rS [?l ?l] 0673 1786
                                                            ; W = v_previsr_counter
;   16    delay_10us(5)
                               movlw    5                   ;  1 OV rS rS [?l ?l] 0674 3005
                                                            ; W = v_previsr_counter
                               branchlo_nop l_delay_10us    ;  1 OV rS rS [?l ?l] 0675
                               call     l_delay_10us        ;  1 OV rS ?? [?l ??] 0675 20dc
;   18    if (PrevButtonIO != (portb & 0xc8)) then
                               movlw    200                 ;  1 OV ?? ?? [?? ??] 0676 30c8
                               datalo_clr v_portb           ;  1 OV ?? ?s [?? ??] 0677 1283
                               andwf    v_portb,w           ;  1 OV ?s ?s [?? ??] 0678 0506
                               datahi_clr v____temp_55      ;  1 OV ?s rs [?? ??] 0679 1303
                               movwf    v____temp_55        ;  1 OV rs rs [?? ??] 067a 00ea
                               movf     v_prevbuttonio,w    ;  1 OV rs rs [?? ??] 067b 0851
                                                            ; W = v____temp_55
                               subwf    v____temp_55,w      ;  1 OV rs rs [?? ??] 067c 026a
                                                            ; W = v_prevbuttonio
                               branchlo_clr l__l791         ;  1 OV rs rs [?? ?l] 067d 118a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 067e 1903
                               goto     l__l791             ;  1 OV rs rs [?l ?l] 067f 2e85
;   19       PrevButtonIO = (portb & 0xC8)
                               movlw    200                 ;  1 OV rs rs [?l ?l] 0680 30c8
                               andwf    v_portb,w           ;  1 OV rs rs [?l ?l] 0681 0506
                               movwf    v_prevbuttonio      ;  1 OV rs rs [?l ?l] 0682 00d1
;   20       ButtonDelay = 10
                               movlw    10                  ;  1 OV rs rs [?l ?l] 0683 300a
                                                            ; W = v_prevbuttonio
                               movwf    v_buttondelay       ;  1 OV rs rs [?l ?l] 0684 00d2
;   21    end if
l__l791
;   23    if (ButtonDelay > 0) then
                               movf     v_buttondelay,w     ;  1 OV rs rs [?l ?l] 0685 0852
                               branchlo_nop l__l793         ;  1 OV rs rs [?l ?l] 0686
                                                            ; W = v_buttondelay
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 0686 1903
                                                            ; W = v_buttondelay
                               goto     l__l793             ;  1 OV rs rs [?l ?l] 0687 2e8d
                                                            ; W = v_buttondelay
;   24       ButtonDelay = ButtonDelay - 1
                               decf     v_buttondelay,f     ;  1 OV rs rs [?l ?l] 0688 03d2
;   25       SwRight  = false
                               bcf      v__bitbucket, 2 ; swright  ;  1 OV rs rs [?l ?l] 0689 1165
;   26       SwSelect = false
                               bcf      v__bitbucket, 1 ; swselect  ;  1 OV rs rs [?l ?l] 068a 10e5
;   27       SwLeft   = false
                               bcf      v__bitbucket, 3 ; swleft  ;  1 OV rs rs [?l ?l] 068b 11e5
;   28    else 
                               branchlo_nop l__l792         ;  1 OV rs rs [?l ?l] 068c
                               goto     l__l792             ;  1 OV rs rs [?l ?l] 068c 2e9c
l__l793
;   29       SwRight  = (PrevButtonIO == 0x08) ;pin_b3
                               movlw    8                   ;  1 OV rs rs [?l ?l] 068d 3008
                                                            ; W = v_buttondelay
                               subwf    v_prevbuttonio,w    ;  1 OV rs rs [?l ?l] 068e 0251
                               bcf      v__bitbucket, 2 ; swright  ;  1 OV rs rs [?l ?l] 068f 1165
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 0690 1903
                               bsf      v__bitbucket, 2 ; swright  ;  1 OV rs rs [?l ?l] 0691 1565
;   30       SwSelect = (PrevButtonIO == 0x40) ;pin_b6
                               movlw    64                  ;  1 OV rs rs [?l ?l] 0692 3040
                               subwf    v_prevbuttonio,w    ;  1 OV rs rs [?l ?l] 0693 0251
                               bcf      v__bitbucket, 1 ; swselect  ;  1 OV rs rs [?l ?l] 0694 10e5
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 0695 1903
                               bsf      v__bitbucket, 1 ; swselect  ;  1 OV rs rs [?l ?l] 0696 14e5
;   31       SwLeft   = (PrevButtonIO == 0x80) ;pin_b7
                               movlw    128                 ;  1 OV rs rs [?l ?l] 0697 3080
                               subwf    v_prevbuttonio,w    ;  1 OV rs rs [?l ?l] 0698 0251
                               bcf      v__bitbucket, 3 ; swleft  ;  1 OV rs rs [?l ?l] 0699 11e5
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 069a 1903
                               bsf      v__bitbucket, 3 ; swleft  ;  1 OV rs rs [?l ?l] 069b 15e5
;   32    end if
l__l792
;   34    if (SwRight) then serial_hw_data = "R" end if
                               branchlo_nop l__l795         ;  1 OV rs rs [?l ?l] 069c
                               btfss    v__bitbucket, 2 ; swright  ;  1 OV rs rs [?l ?l] 069c 1d65
                               goto     l__l795             ;  1 OV rs rs [?l ?l] 069d 2ea1
                               movlw    82                  ;  1 OV rs rs [?l ?l] 069e 3052
                               movwf    v__pic_temp         ;  1 OV rs rs [?l ?l] 069f 00a0
                               branchlo_nop l__serial_hw_data_put;  1 OV rs rs [?l ?l] 06a0
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  1 OV rs ?? [?l ??] 06a0 2386
                                                            ; W = v__pic_temp
l__l795
;   35    if (SwSelect) then serial_hw_data = "S" end if
                               datalo_clr v__bitbucket ; swselect   ;  1 OV ?? ?s [?? ??] 06a1 1283
                               datahi_clr v__bitbucket ; swselect   ;  1 OV ?s rs [?? ??] 06a2 1303
                               branchlo_clr l__l797         ;  1 OV rs rs [?? ?l] 06a3 118a
                               btfss    v__bitbucket, 1 ; swselect  ;  1 OV rs rs [?l ?l] 06a4 1ce5
                               goto     l__l797             ;  1 OV rs rs [?l ?l] 06a5 2ea9
                               movlw    83                  ;  1 OV rs rs [?l ?l] 06a6 3053
                               movwf    v__pic_temp         ;  1 OV rs rs [?l ?l] 06a7 00a0
                               branchlo_nop l__serial_hw_data_put;  1 OV rs rs [?l ?l] 06a8
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  1 OV rs ?? [?l ??] 06a8 2386
                                                            ; W = v__pic_temp
l__l797
;   36    if (SwLeft) then serial_hw_data = "L" end if
                               datalo_clr v__bitbucket ; swleft   ;  1 OV ?? ?s [?? ??] 06a9 1283
                               datahi_clr v__bitbucket ; swleft   ;  1 OV ?s rs [?? ??] 06aa 1303
                               branchlo_clr l__l799         ;  1 OV rs rs [?? ?l] 06ab 118a
                               btfss    v__bitbucket, 3 ; swleft  ;  1 OV rs rs [?l ?l] 06ac 1de5
                               goto     l__l799             ;  1 OV rs rs [?l ?l] 06ad 2eb1
                               movlw    76                  ;  1 OV rs rs [?l ?l] 06ae 304c
                               movwf    v__pic_temp         ;  1 OV rs rs [?l ?l] 06af 00a0
                               branchlo_nop l__serial_hw_data_put;  1 OV rs rs [?l ?l] 06b0
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  1 OV rs ?? [?l ??] 06b0 2386
                                                            ; W = v__pic_temp
l__l799
;   38    pin_b3_direction = output
                               datalo_set v_trisb ; pin_b3_direction        ;  1 OV ?? ?S [?? ??] 06b1 1683
                               bcf      v_trisb, 3 ; pin_b3_direction       ;  1 OV ?S ?S [?? ??] 06b2 1186
;   39    pin_b6_direction = output
                               bcf      v_trisb, 6 ; pin_b6_direction       ;  1 OV ?S ?S [?? ??] 06b3 1306
;   40    pin_b7_direction = output
                               bcf      v_trisb, 7 ; pin_b7_direction       ;  1 OV ?S ?S [?? ??] 06b4 1386
;   42 end procedure
                               return                       ;  1 OV ?S ?S [?? ??] 06b5 0008
;   45 procedure BatteryCheck() is
l_batterycheck
;   50    print_string(serial_hw_data, bstr1)
                               movlw    l__serial_hw_data_put;  1 OV rs rs [?l ?l] 06b6 3086
                               datahi_set v____device_put_1 ;  1 OV rs Rs [?l ?l] 06b7 1703
                               movwf    v____device_put_1   ;  1 OV Rs Rs [?l ?l] 06b8 00b6
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?l ?l] 06b9 3003
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  1 OV Rs Rs [?l ?l] 06ba 00b7
                               movlw    10                  ;  1 OV Rs Rs [?l ?l] 06bb 300a
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  1 OV Rs Rs [?l ?l] 06bc 00ba
                               clrf     v__str_count+1      ;  1 OV Rs Rs [?l ?l] 06bd 01bb
                                                            ; W = v__str_count
                               movlw    l__data_bstr1       ;  1 OV Rs Rs [?l ?l] 06be 3026
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  1 OV Rs Rs [?l ?l] 06bf 00c0
                               movlw    HIGH l__data_bstr1  ;  1 OV Rs Rs [?l ?l] 06c0 3000
                                                            ; W = v___str_1
                               iorlw    64                  ;  1 OV Rs Rs [?l ?l] 06c1 3840
                               movwf    v___str_1+1         ;  1 OV Rs Rs [?l ?l] 06c2 00c1
                               branchlo_nop l_print_string  ;  1 OV Rs Rs [?l ?l] 06c3
                                                            ; W = v___str_1
                               call     l_print_string      ;  1 OV Rs ?? [?l ??] 06c3 2124
                                                            ; W = v___str_1
;   51    Battery = ADC_read(2)
                               movlw    2                   ;  1 OV ?? ?? [?? ??] 06c4 3002
                               branchlo_clr l_adc_read      ;  1 OV ?? ?? [?? ?l] 06c5 118a
                               call     l_adc_read          ;  1 OV ?? ?? [?l ??] 06c6 2416
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 06c7 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 06c8 1303
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 06c9 0820
                               movwf    v_battery           ;  1 OV rs rs [?? ??] 06ca 00ea
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 06cb 0821
                                                            ; W = v_battery
                               movwf    v_battery+1         ;  1 OV rs rs [?? ??] 06cc 00eb
                                                            ; W = v__pic_temp
;   52 	print_word_dec(serial_hw_data, Battery)
                               movlw    l__serial_hw_data_put;  1 OV rs rs [?? ??] 06cd 3086
                                                            ; W = v_battery
                               datahi_set v____device_put_18;  1 OV rs Rs [?? ??] 06ce 1703
                               movwf    v____device_put_18  ;  1 OV Rs Rs [?? ??] 06cf 00b0
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 06d0 3003
                                                            ; W = v____device_put_18
                               movwf    v____device_put_18+1;  1 OV Rs Rs [?? ??] 06d1 00b1
                               datahi_clr v_battery         ;  1 OV Rs rs [?? ??] 06d2 1303
                                                            ; W = v____device_put_18
                               movf     v_battery,w         ;  1 OV rs rs [?? ??] 06d3 086a
                                                            ; W = v____device_put_18
                               datahi_set v___data_36       ;  1 OV rs Rs [?? ??] 06d4 1703
                                                            ; W = v_battery
                               movwf    v___data_36         ;  1 OV Rs Rs [?? ??] 06d5 00b4
                                                            ; W = v_battery
                               datahi_clr v_battery         ;  1 OV Rs rs [?? ??] 06d6 1303
                                                            ; W = v___data_36
                               movf     v_battery+1,w       ;  1 OV rs rs [?? ??] 06d7 086b
                                                            ; W = v___data_36
                               datahi_set v___data_36       ;  1 OV rs Rs [?? ??] 06d8 1703
                                                            ; W = v_battery
                               movwf    v___data_36+1       ;  1 OV Rs Rs [?? ??] 06d9 00b5
                                                            ; W = v_battery
                               branchlo_clr l_print_word_dec;  1 OV Rs Rs [?? ?l] 06da 118a
                                                            ; W = v___data_36
                               call     l_print_word_dec    ;  1 OV Rs ?? [?l ??] 06db 223e
                                                            ; W = v___data_36
;   54    Battery = ADC_read(3)
                               movlw    3                   ;  1 OV ?? ?? [?? ??] 06dc 3003
                               branchlo_clr l_adc_read      ;  1 OV ?? ?? [?? ?l] 06dd 118a
                               call     l_adc_read          ;  1 OV ?? ?? [?l ??] 06de 2416
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 06df 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 06e0 1303
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 06e1 0820
                               movwf    v_battery           ;  1 OV rs rs [?? ??] 06e2 00ea
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 06e3 0821
                                                            ; W = v_battery
                               movwf    v_battery+1         ;  1 OV rs rs [?? ??] 06e4 00eb
                                                            ; W = v__pic_temp
;   55    serial_hw_data = " "
                               movlw    32                  ;  1 OV rs rs [?? ??] 06e5 3020
                                                            ; W = v_battery
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 06e6 00a0
                               branchlo_clr l__serial_hw_data_put;  1 OV rs rs [?? ?l] 06e7 118a
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  1 OV rs ?? [?l ??] 06e8 2386
                                                            ; W = v__pic_temp
;   56 	print_word_dec(serial_hw_data, Battery)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 06e9 3086
                               datalo_clr v____device_put_18;  1 OV ?? ?s [?? ??] 06ea 1283
                               datahi_set v____device_put_18;  1 OV ?s Rs [?? ??] 06eb 1703
                               movwf    v____device_put_18  ;  1 OV Rs Rs [?? ??] 06ec 00b0
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 06ed 3003
                                                            ; W = v____device_put_18
                               movwf    v____device_put_18+1;  1 OV Rs Rs [?? ??] 06ee 00b1
                               datahi_clr v_battery         ;  1 OV Rs rs [?? ??] 06ef 1303
                                                            ; W = v____device_put_18
                               movf     v_battery,w         ;  1 OV rs rs [?? ??] 06f0 086a
                                                            ; W = v____device_put_18
                               datahi_set v___data_36       ;  1 OV rs Rs [?? ??] 06f1 1703
                                                            ; W = v_battery
                               movwf    v___data_36         ;  1 OV Rs Rs [?? ??] 06f2 00b4
                                                            ; W = v_battery
                               datahi_clr v_battery         ;  1 OV Rs rs [?? ??] 06f3 1303
                                                            ; W = v___data_36
                               movf     v_battery+1,w       ;  1 OV rs rs [?? ??] 06f4 086b
                                                            ; W = v___data_36
                               datahi_set v___data_36       ;  1 OV rs Rs [?? ??] 06f5 1703
                                                            ; W = v_battery
                               movwf    v___data_36+1       ;  1 OV Rs Rs [?? ??] 06f6 00b5
                                                            ; W = v_battery
                               branchlo_clr l_print_word_dec;  1 OV Rs Rs [?? ?l] 06f7 118a
                                                            ; W = v___data_36
                               call     l_print_word_dec    ;  1 OV Rs ?? [?l ??] 06f8 223e
                                                            ; W = v___data_36
;   58    Battery = ADC_read(4)
                               movlw    4                   ;  1 OV ?? ?? [?? ??] 06f9 3004
                               branchlo_clr l_adc_read      ;  1 OV ?? ?? [?? ?l] 06fa 118a
                               call     l_adc_read          ;  1 OV ?? ?? [?l ??] 06fb 2416
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 06fc 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 06fd 1303
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 06fe 0820
                               movwf    v_battery           ;  1 OV rs rs [?? ??] 06ff 00ea
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 0700 0821
                                                            ; W = v_battery
                               movwf    v_battery+1         ;  1 OV rs rs [?? ??] 0701 00eb
                                                            ; W = v__pic_temp
;   59    serial_hw_data = " "
                               movlw    32                  ;  1 OV rs rs [?? ??] 0702 3020
                                                            ; W = v_battery
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0703 00a0
                               branchlo_clr l__serial_hw_data_put;  1 OV rs rs [?? ?l] 0704 118a
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  1 OV rs ?? [?l ??] 0705 2386
                                                            ; W = v__pic_temp
;   60 	print_word_dec(serial_hw_data, Battery)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 0706 3086
                               datalo_clr v____device_put_18;  1 OV ?? ?s [?? ??] 0707 1283
                               datahi_set v____device_put_18;  1 OV ?s Rs [?? ??] 0708 1703
                               movwf    v____device_put_18  ;  1 OV Rs Rs [?? ??] 0709 00b0
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 070a 3003
                                                            ; W = v____device_put_18
                               movwf    v____device_put_18+1;  1 OV Rs Rs [?? ??] 070b 00b1
                               datahi_clr v_battery         ;  1 OV Rs rs [?? ??] 070c 1303
                                                            ; W = v____device_put_18
                               movf     v_battery,w         ;  1 OV rs rs [?? ??] 070d 086a
                                                            ; W = v____device_put_18
                               datahi_set v___data_36       ;  1 OV rs Rs [?? ??] 070e 1703
                                                            ; W = v_battery
                               movwf    v___data_36         ;  1 OV Rs Rs [?? ??] 070f 00b4
                                                            ; W = v_battery
                               datahi_clr v_battery         ;  1 OV Rs rs [?? ??] 0710 1303
                                                            ; W = v___data_36
                               movf     v_battery+1,w       ;  1 OV rs rs [?? ??] 0711 086b
                                                            ; W = v___data_36
                               datahi_set v___data_36       ;  1 OV rs Rs [?? ??] 0712 1703
                                                            ; W = v_battery
                               movwf    v___data_36+1       ;  1 OV Rs Rs [?? ??] 0713 00b5
                                                            ; W = v_battery
                               branchlo_clr l_print_word_dec;  1 OV Rs Rs [?? ?l] 0714 118a
                                                            ; W = v___data_36
                               call     l_print_word_dec    ;  1 OV Rs ?? [?l ??] 0715 223e
                                                            ; W = v___data_36
;   62    serial_hw_data = "+"
                               movlw    43                  ;  1 OV ?? ?? [?? ??] 0716 302b
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0717 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 0718 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0719 00a0
                               branchlo_clr l__serial_hw_data_put;  1 OV rs rs [?? ?l] 071a 118a
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  1 OV rs ?? [?l ??] 071b 2386
                                                            ; W = v__pic_temp
;   63 	print_byte_hex(serial_hw_data, adcon0)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 071c 3086
                               datalo_clr v____device_put_12;  1 OV ?? ?s [?? ??] 071d 1283
                               datahi_set v____device_put_12;  1 OV ?s Rs [?? ??] 071e 1703
                               movwf    v____device_put_12  ;  1 OV Rs Rs [?? ??] 071f 00b2
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0720 3003
                                                            ; W = v____device_put_12
                               movwf    v____device_put_12+1;  1 OV Rs Rs [?? ??] 0721 00b3
                               datahi_clr v_adcon0          ;  1 OV Rs rs [?? ??] 0722 1303
                                                            ; W = v____device_put_12
                               movf     v_adcon0,w          ;  1 OV rs rs [?? ??] 0723 081f
                                                            ; W = v____device_put_12
                               branchlo_clr l_print_byte_hex;  1 OV rs rs [?? ?l] 0724 118a
                               call     l_print_byte_hex    ;  1 OV rs ?? [?l ??] 0725 21e1
;   64    serial_hw_data = "+"
                               movlw    43                  ;  1 OV ?? ?? [?? ??] 0726 302b
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0727 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 0728 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0729 00a0
                               branchlo_clr l__serial_hw_data_put;  1 OV rs rs [?? ?l] 072a 118a
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  1 OV rs ?? [?l ??] 072b 2386
                                                            ; W = v__pic_temp
;   65 	print_byte_hex(serial_hw_data, adcon1)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 072c 3086
                               datalo_clr v____device_put_12;  1 OV ?? ?s [?? ??] 072d 1283
                               datahi_set v____device_put_12;  1 OV ?s Rs [?? ??] 072e 1703
                               movwf    v____device_put_12  ;  1 OV Rs Rs [?? ??] 072f 00b2
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0730 3003
                                                            ; W = v____device_put_12
                               movwf    v____device_put_12+1;  1 OV Rs Rs [?? ??] 0731 00b3
                               datalo_set v_adcon1          ;  1 OV Rs RS [?? ??] 0732 1683
                                                            ; W = v____device_put_12
                               datahi_clr v_adcon1          ;  1 OV RS rS [?? ??] 0733 1303
                                                            ; W = v____device_put_12
                               movf     v_adcon1,w          ;  1 OV rS rS [?? ??] 0734 081f
                                                            ; W = v____device_put_12
                               branchlo_clr l_print_byte_hex;  1 OV rS rS [?? ?l] 0735 118a
                               call     l_print_byte_hex    ;  1 OV rS ?? [?l ??] 0736 21e1
;   67 	print_crlf(serial_hw_data)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 0737 3086
                               datalo_clr v__device_put     ;  1 OV ?? ?s [?? ??] 0738 1283
                               datahi_set v__device_put     ;  1 OV ?s Rs [?? ??] 0739 1703
                               movwf    v__device_put       ;  1 OV Rs Rs [?? ??] 073a 00b2
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 073b 3003
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  1 OV Rs Rs [?? ??] 073c 00b3
                               branchlo_clr l_print_crlf    ;  1 OV Rs Rs [?? ?l] 073d 118a
                                                            ; W = v__device_put
                               goto     l_print_crlf        ;  1 OV Rs Rs [?l ?l] 073e 290e
                                                            ; W = v__device_put
;   69 end procedure
; behave.jal
;   53 procedure BehaveSeek (byte in ID) is
;  262 procedure BehaveAvoid (byte in ID) is
l_behaveavoid
                               movwf    v___id_13           ;  1 OV rs rs [?l ?l] 073f 00ea
;  269    if ((LineL > LINE_NORM) | (LineR > LINE_NORM)) then
                               movlw    0                   ;  1 OV rs rs [?l ?l] 0740 3000
                                                            ; W = v___id_13
                               subwf    v_linel+1,w         ;  1 OV rs rs [?l ?l] 0741 0258
                               branchlo_nop l__l1180        ;  1 OV rs rs [?l ?l] 0742
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0742 1d03
                               goto     l__l1180            ;  1 OV rs rs [?l ?l] 0743 2f46
                               movlw    150                 ;  1 OV rs rs [?l ?l] 0744 3096
                               subwf    v_linel,w           ;  1 OV rs rs [?l ?l] 0745 0257
l__l1180
                               bcf      v____bitbucket_11, 0 ; _btemp97;  1 OV rs rs [?l ?l] 0746 106c
                               branchlo_nop l__l1181        ;  1 OV rs rs [?l ?l] 0747
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 0747 1903
                               goto     l__l1181            ;  1 OV rs rs [?l ?l] 0748 2f4b
                               btfsc    v__status, v__c     ;  1 OV rs rs [?l ?l] 0749 1803
                               bsf      v____bitbucket_11, 0 ; _btemp97;  1 OV rs rs [?l ?l] 074a 146c
l__l1181
                               movlw    0                   ;  1 OV rs rs [?l ?l] 074b 3000
                               subwf    v_liner+1,w         ;  1 OV rs rs [?l ?l] 074c 025a
                               branchlo_nop l__l1182        ;  1 OV rs rs [?l ?l] 074d
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 074d 1d03
                               goto     l__l1182            ;  1 OV rs rs [?l ?l] 074e 2f51
                               movlw    150                 ;  1 OV rs rs [?l ?l] 074f 3096
                                                            ; W = v_cntavoid
                               subwf    v_liner,w           ;  1 OV rs rs [?l ?l] 0750 0259
l__l1182
                               bcf      v____bitbucket_11, 1 ; _btemp98;  1 OV rs rs [?l ?l] 0751 10ec
                               branchlo_nop l__l1183        ;  1 OV rs rs [?l ?l] 0752
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 0752 1903
                               goto     l__l1183            ;  1 OV rs rs [?l ?l] 0753 2f56
                               btfsc    v__status, v__c     ;  1 OV rs rs [?l ?l] 0754 1803
                                                            ; W = v_cntavoid
                               bsf      v____bitbucket_11, 1 ; _btemp98;  1 OV rs rs [?l ?l] 0755 14ec
                                                            ; W = v_cntavoid
l__l1183
                               bcf      v____bitbucket_11, 2 ; _btemp99;  1 OV rs rs [?l ?l] 0756 116c
                               btfss    v____bitbucket_11, 0 ; _btemp97;  1 OV rs rs [?l ?l] 0757 1c6c
                               btfsc    v____bitbucket_11, 1 ; _btemp98;  1 OV rs rs [?l ?l] 0758 18ec
                               bsf      v____bitbucket_11, 2 ; _btemp99;  1 OV rs rs [?l ?l] 0759 156c
                               branchlo_nop l__l848         ;  1 OV rs rs [?l ?l] 075a
                               btfss    v____bitbucket_11, 2 ; _btemp99;  1 OV rs rs [?l ?l] 075a 1d6c
                               goto     l__l848             ;  1 OV rs rs [?l ?l] 075b 2f60
;  271       CntAvoid = 1000    --  ms
                               movlw    232                 ;  1 OV rs rs [?l ?l] 075c 30e8
                               movwf    v_cntavoid          ;  1 OV rs rs [?l ?l] 075d 00db
                               movlw    3                   ;  1 OV rs rs [?l ?l] 075e 3003
                                                            ; W = v_cntavoid
                               movwf    v_cntavoid+1        ;  1 OV rs rs [?l ?l] 075f 00dc
;  272    end if
l__l848
;  274    if (CntAvoid == 0) then   
                               movf     v_cntavoid,w        ;  1 OV rs rs [?l ?l] 0760 085b
                               iorwf    v_cntavoid+1,w      ;  1 OV rs rs [?l ?l] 0761 045c
                                                            ; W = v_cntavoid
                               branchlo_nop l__l850         ;  1 OV rs rs [?l ?l] 0762
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 0762 1903
;  276       return
                               return                       ;  1 OV rs rs [?l ?l] 0763 0008
;  277    end if
l__l850
;  279    CntAvoid = CntAvoid - 1
                               decf     v_cntavoid,f        ;  1 OV rs rs [?l ?l] 0764 03db
                               incf     v_cntavoid,w        ;  1 OV rs rs [?l ?l] 0765 0a5b
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 0766 1903
                               decf     v_cntavoid+1,f      ;  1 OV rs rs [?l ?l] 0767 03dc
;  281    if ((LineL > LINE_NORM) & (LineR < LINE_NORM)) then
                               movlw    0                   ;  1 OV rs rs [?l ?l] 0768 3000
                               subwf    v_linel+1,w         ;  1 OV rs rs [?l ?l] 0769 0258
                               branchlo_nop l__l1186        ;  1 OV rs rs [?l ?l] 076a
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 076a 1d03
                               goto     l__l1186            ;  1 OV rs rs [?l ?l] 076b 2f6e
                               movlw    150                 ;  1 OV rs rs [?l ?l] 076c 3096
                               subwf    v_linel,w           ;  1 OV rs rs [?l ?l] 076d 0257
l__l1186
                               bcf      v____bitbucket_11, 4 ; _btemp101;  1 OV rs rs [?l ?l] 076e 126c
                               branchlo_nop l__l1187        ;  1 OV rs rs [?l ?l] 076f
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 076f 1903
                               goto     l__l1187            ;  1 OV rs rs [?l ?l] 0770 2f73
                               btfsc    v__status, v__c     ;  1 OV rs rs [?l ?l] 0771 1803
                               bsf      v____bitbucket_11, 4 ; _btemp101;  1 OV rs rs [?l ?l] 0772 166c
l__l1187
                               movlw    0                   ;  1 OV rs rs [?l ?l] 0773 3000
                               subwf    v_liner+1,w         ;  1 OV rs rs [?l ?l] 0774 025a
                               branchlo_nop l__l1188        ;  1 OV rs rs [?l ?l] 0775
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0775 1d03
                               goto     l__l1188            ;  1 OV rs rs [?l ?l] 0776 2f79
                               movlw    150                 ;  1 OV rs rs [?l ?l] 0777 3096
                                                            ; W = v_motorl
                               subwf    v_liner,w           ;  1 OV rs rs [?l ?l] 0778 0259
l__l1188
                               bcf      v____bitbucket_11, 5 ; _btemp102;  1 OV rs rs [?l ?l] 0779 12ec
                               branchlo_nop l__l1189        ;  1 OV rs rs [?l ?l] 077a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 077a 1903
                               goto     l__l1189            ;  1 OV rs rs [?l ?l] 077b 2f7e
                               btfss    v__status, v__c     ;  1 OV rs rs [?l ?l] 077c 1c03
                                                            ; W = v_motorl
                               bsf      v____bitbucket_11, 5 ; _btemp102;  1 OV rs rs [?l ?l] 077d 16ec
                                                            ; W = v_motorl
l__l1189
                               bsf      v____bitbucket_11, 6 ; _btemp103;  1 OV rs rs [?l ?l] 077e 176c
                               btfsc    v____bitbucket_11, 4 ; _btemp101;  1 OV rs rs [?l ?l] 077f 1a6c
                               btfss    v____bitbucket_11, 5 ; _btemp102;  1 OV rs rs [?l ?l] 0780 1eec
                               bcf      v____bitbucket_11, 6 ; _btemp103;  1 OV rs rs [?l ?l] 0781 136c
                               branchlo_nop l__l852         ;  1 OV rs rs [?l ?l] 0782
                               btfss    v____bitbucket_11, 6 ; _btemp103;  1 OV rs rs [?l ?l] 0782 1f6c
                               goto     l__l852             ;  1 OV rs rs [?l ?l] 0783 2f88
;  284       MotorL = - 100
                               movlw    156                 ;  1 OV rs rs [?l ?l] 0784 309c
                               movwf    v_motorl            ;  1 OV rs rs [?l ?l] 0785 00d3
;  285       MotorR = 0
                               clrf     v_motorr            ;  1 OV rs rs [?l ?l] 0786 01d4
                                                            ; W = v_motorl
;  286    elsif ((LineL < LINE_NORM) & (LineR > LINE_NORM)) then
                               branchlo_nop l__l851         ;  1 OV rs rs [?l ?l] 0787
                                                            ; W = v_motorl
                               goto     l__l851             ;  1 OV rs rs [?l ?l] 0787 2fac
                                                            ; W = v_motorl
l__l852
                               movlw    0                   ;  1 OV rs rs [?l ?l] 0788 3000
                               subwf    v_linel+1,w         ;  1 OV rs rs [?l ?l] 0789 0258
                               branchlo_nop l__l1192        ;  1 OV rs rs [?l ?l] 078a
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 078a 1d03
                               goto     l__l1192            ;  1 OV rs rs [?l ?l] 078b 2f8e
                               movlw    150                 ;  1 OV rs rs [?l ?l] 078c 3096
                               subwf    v_linel,w           ;  1 OV rs rs [?l ?l] 078d 0257
l__l1192
                               bcf      v____bitbucket_11, 7 ; _btemp104;  1 OV rs rs [?l ?l] 078e 13ec
                               branchlo_nop l__l1193        ;  1 OV rs rs [?l ?l] 078f
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 078f 1903
                               goto     l__l1193            ;  1 OV rs rs [?l ?l] 0790 2f93
                               btfss    v__status, v__c     ;  1 OV rs rs [?l ?l] 0791 1c03
                               bsf      v____bitbucket_11, 7 ; _btemp104;  1 OV rs rs [?l ?l] 0792 17ec
l__l1193
                               movlw    0                   ;  1 OV rs rs [?l ?l] 0793 3000
                               subwf    v_liner+1,w         ;  1 OV rs rs [?l ?l] 0794 025a
                               branchlo_nop l__l1194        ;  1 OV rs rs [?l ?l] 0795
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0795 1d03
                               goto     l__l1194            ;  1 OV rs rs [?l ?l] 0796 2f99
                               movlw    150                 ;  1 OV rs rs [?l ?l] 0797 3096
                                                            ; W = v_motorr
                               subwf    v_liner,w           ;  1 OV rs rs [?l ?l] 0798 0259
l__l1194
                               bcf      v____bitbucket_11+1, 0 ; _btemp105;  1 OV rs rs [?l ?l] 0799 106d
                               branchlo_nop l__l1195        ;  1 OV rs rs [?l ?l] 079a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 079a 1903
                               goto     l__l1195            ;  1 OV rs rs [?l ?l] 079b 2f9e
                               btfsc    v__status, v__c     ;  1 OV rs rs [?l ?l] 079c 1803
                                                            ; W = v_motorr
                               bsf      v____bitbucket_11+1, 0 ; _btemp105;  1 OV rs rs [?l ?l] 079d 146d
                                                            ; W = v_motorr
l__l1195
                               bsf      v____bitbucket_11+1, 1 ; _btemp106;  1 OV rs rs [?l ?l] 079e 14ed
                               btfsc    v____bitbucket_11, 7 ; _btemp104;  1 OV rs rs [?l ?l] 079f 1bec
                               btfss    v____bitbucket_11+1, 0 ; _btemp105;  1 OV rs rs [?l ?l] 07a0 1c6d
                               bcf      v____bitbucket_11+1, 1 ; _btemp106;  1 OV rs rs [?l ?l] 07a1 10ed
                               branchlo_nop l__l853         ;  1 OV rs rs [?l ?l] 07a2
                               btfss    v____bitbucket_11+1, 1 ; _btemp106;  1 OV rs rs [?l ?l] 07a2 1ced
                               goto     l__l853             ;  1 OV rs rs [?l ?l] 07a3 2fa8
;  289       MotorL = 0
                               clrf     v_motorl            ;  1 OV rs rs [?l ?l] 07a4 01d3
                                                            ; W = v_requestcontrol
;  290       MotorR = - 100
                               movlw    156                 ;  1 OV rs rs [?l ?l] 07a5 309c
                                                            ; W = v_requestcontrol
                               movwf    v_motorr            ;  1 OV rs rs [?l ?l] 07a6 00d4
;  291    else
                               branchlo_nop l__l851         ;  1 OV rs rs [?l ?l] 07a7
                                                            ; W = v_motorr
                               goto     l__l851             ;  1 OV rs rs [?l ?l] 07a7 2fac
                                                            ; W = v_motorr
l__l853
;  293       MotorL = - 100;
                               movlw    156                 ;  1 OV rs rs [?l ?l] 07a8 309c
                               movwf    v_motorl            ;  1 OV rs rs [?l ?l] 07a9 00d3
;  294       MotorR = - 100;
                               movlw    156                 ;  1 OV rs rs [?l ?l] 07aa 309c
                                                            ; W = v_motorl
                               movwf    v_motorr            ;  1 OV rs rs [?l ?l] 07ab 00d4
;  295    end if
l__l851
;  298    RequestControl = ID
                               movf     v___id_13,w         ;  1 OV rs rs [?l ?l] 07ac 086a
                                                            ; W = v_motorr
                               movwf    v_requestcontrol    ;  1 OV rs rs [?l ?l] 07ad 00d5
                                                            ; W = v___id_13
;  300 end procedure
l__l846
                               return                       ;  1 OV rs rs [?l ?l] 07ae 0008
                                                            ; W = v_requestcontrol
;  355 end procedure
l__l854
;  357 var byte StartCounter = 255
                               movlw    255                 ;  0 OV ?S ?S [?l ?l] 07af 30ff
                               datalo_clr v_startcounter    ;  0 OV ?S ?s [?l ?l] 07b0 1283
                               datahi_clr v_startcounter    ;  0 OV ?s rs [?l ?l] 07b1 1303
                               movwf    v_startcounter      ;  0 OV rs rs [?l ?l] 07b2 00dd
;  363 procedure BehaveWaitStart (byte in ID) is
                               branchlo_set l__l944         ;  0 OV rs rs [?l ?L] 07b3 158a
                                                            ; W = v_startcounter
                               goto     l__l944             ;  0 OV rs rs [?L ?L] 07b4 28e9
                                                            ; W = v_startcounter
l_behavewaitstart
                               datalo_clr v___id_17         ;  1 OV ?? ?s [?l ?l] 07b5 1283
                               datahi_clr v___id_17         ;  1 OV ?s rs [?l ?l] 07b6 1303
                               movwf    v___id_17           ;  1 OV rs rs [?l ?l] 07b7 00ea
;  367    if (SwSelect == true) then
                               branchlo_nop l__l869         ;  1 OV rs rs [?l ?l] 07b8
                                                            ; W = v___id_17
                               btfss    v__bitbucket, 1 ; swselect  ;  1 OV rs rs [?l ?l] 07b8 1ce5
                                                            ; W = v___id_17
                               goto     l__l869             ;  1 OV rs rs [?l ?l] 07b9 2fbc
                                                            ; W = v___id_17
;  368       StartCounter = 255 ; wacht op start-knop
                               movlw    255                 ;  1 OV rs rs [?l ?l] 07ba 30ff
                                                            ; W = v_startcounter
                               movwf    v_startcounter      ;  1 OV rs rs [?l ?l] 07bb 00dd
;  369    end if
l__l869
;  371    if (SwLeft == true) then
                               branchlo_nop l__l871         ;  1 OV rs rs [?l ?l] 07bc
                                                            ; W = v___id_17
                               btfss    v__bitbucket, 3 ; swleft  ;  1 OV rs rs [?l ?l] 07bc 1de5
                                                            ; W = v___id_17
                               goto     l__l871             ;  1 OV rs rs [?l ?l] 07bd 2fc1
                                                            ; W = v___id_17
;  372       DraaiRichting = true
                               bsf      v__bitbucket, 4 ; draairichting  ;  1 OV rs rs [?l ?l] 07be 1665
                                                            ; W = v_startcounter
;  373       StartCounter = 250
                               movlw    250                 ;  1 OV rs rs [?l ?l] 07bf 30fa
                                                            ; W = v_startcounter
                               movwf    v_startcounter      ;  1 OV rs rs [?l ?l] 07c0 00dd
;  374    end if
l__l871
;  376    if (SwRight == true) then
                               branchlo_nop l__l873         ;  1 OV rs rs [?l ?l] 07c1
                                                            ; W = v___id_17
                               btfss    v__bitbucket, 2 ; swright  ;  1 OV rs rs [?l ?l] 07c1 1d65
                                                            ; W = v___id_17
                               goto     l__l873             ;  1 OV rs rs [?l ?l] 07c2 2fc6
                                                            ; W = v___id_17
;  377       DraaiRichting = false
                               bcf      v__bitbucket, 4 ; draairichting  ;  1 OV rs rs [?l ?l] 07c3 1265
;  378       StartCounter = 250
                               movlw    250                 ;  1 OV rs rs [?l ?l] 07c4 30fa
                               movwf    v_startcounter      ;  1 OV rs rs [?l ?l] 07c5 00dd
;  379    end if
l__l873
;  383   if (StartCounter == 0) then 
                               movf     v_startcounter,w    ;  1 OV rs rs [?l ?l] 07c6 085d
                                                            ; W = v___id_17
                               branchlo_nop l__l875         ;  1 OV rs rs [?l ?l] 07c7
                                                            ; W = v_startcounter
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 07c7 1903
                                                            ; W = v_startcounter
;  385       return 
                               return                       ;  1 OV rs rs [?l ?l] 07c8 0008
;  386   end if 
l__l875
;  388   If (StartCounter > 250) then 
                               movlw    250                 ;  1 OV rs rs [?l ?l] 07c9 30fa
                                                            ; W = v_startcounter
                               subwf    v_startcounter,w    ;  1 OV rs rs [?l ?l] 07ca 025d
                               branchlo_nop l__l877         ;  1 OV rs rs [?l ?l] 07cb
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 07cb 1903
                               goto     l__l877             ;  1 OV rs rs [?l ?l] 07cc 2fff
                               branchlo_nop l__l877         ;  1 OV rs rs [?l ?l] 07cd
                               btfss    v__status, v__c     ;  1 OV rs rs [?l ?l] 07cd 1c03
                               goto     l__l877             ;  1 OV rs rs [?l ?l] 07ce 2fff
;  392       if ((isr_counter & 0xFF) < 10) then
                               branchlo_nop l__isr_counter_get;  1 OV rs rs [?l ?l] 07cf
                               call     l__isr_counter_get  ;  1 OV rs ?? [?l ??] 07cf 2505
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 07d0 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 07d1 1303
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 07d2 0820
                               datalo_set v____temp_62      ;  1 OV rs rS [?? ??] 07d3 1683
                                                            ; W = v__pic_temp
                               movwf    v____temp_62        ;  1 OV rS rS [?? ??] 07d4 00bd
                                                            ; W = v__pic_temp
                               datalo_clr v__pic_temp       ;  1 OV rS rs [?? ??] 07d5 1283
                                                            ; W = v____temp_62
                               movf     v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 07d6 0821
                                                            ; W = v____temp_62
                               datalo_set v____temp_62      ;  1 OV rs rS [?? ??] 07d7 1683
                                                            ; W = v__pic_temp
                               movwf    v____temp_62+1      ;  1 OV rS rS [?? ??] 07d8 00be
                                                            ; W = v__pic_temp
                               movf     v____temp_62,w      ;  1 OV rS rS [?? ??] 07d9 083d
                                                            ; W = v____temp_62
                               movwf    v____temp_62+2      ;  1 OV rS rS [?? ??] 07da 00bf
                                                            ; W = v____temp_62
                               clrf     v____temp_62+3      ;  1 OV rS rS [?? ??] 07db 01c0
                                                            ; W = v____temp_62
                               movlw    0                   ;  1 OV rS rS [?? ??] 07dc 3000
                                                            ; W = v____temp_62
                               subwf    v____temp_62+3,w    ;  1 OV rS rS [?? ??] 07dd 0240
                               branchlo_clr l__l1200        ;  1 OV rS rS [?? ?l] 07de 118a
                               btfss    v__status, v__z     ;  1 OV rS rS [?l ?l] 07df 1d03
                               goto     l__l1200            ;  1 OV rS rS [?l ?l] 07e0 2fe3
                               movlw    10                  ;  1 OV rS rS [?l ?l] 07e1 300a
                               subwf    v____temp_62+2,w    ;  1 OV rS rS [?l ?l] 07e2 023f
l__l1200
                               branchlo_nop l__l879         ;  1 OV rS rS [?l ?l] 07e3
                               btfsc    v__status, v__z     ;  1 OV rS rS [?l ?l] 07e3 1903
                               goto     l__l879             ;  1 OV rS rS [?l ?l] 07e4 2ff3
                               branchlo_nop l__l879         ;  1 OV rS rS [?l ?l] 07e5
                               btfsc    v__status, v__c     ;  1 OV rS rS [?l ?l] 07e5 1803
                               goto     l__l879             ;  1 OV rS rS [?l ?l] 07e6 2ff3
;  393          LedGreen  = true
                               datalo_clr v__portb_shadow ; x78;  1 OV rS rs [?l ?l] 07e7 1283
                               bsf      v__portb_shadow, 3 ; x78;  1 OV rs rs [?l ?l] 07e8 15c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?l ?l] 07e9 0843
                               movwf    v_portb             ;  1 OV rs rs [?l ?l] 07ea 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  393          LedGreen  = true
; 16f876a.jal
;  263    _PORTB_flush()
; behave.jal
;  393          LedGreen  = true
;  394          LedYellow = true
                               bsf      v__portb_shadow, 7 ; x79;  1 OV rs rs [?l ?l] 07eb 17c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?l ?l] 07ec 0843
                               movwf    v_portb             ;  1 OV rs rs [?l ?l] 07ed 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  394          LedYellow = true
; 16f876a.jal
;  229    _PORTB_flush()
; behave.jal
;  394          LedYellow = true
;  395          LedOrange = true
                               bsf      v__portb_shadow, 6 ; x80;  1 OV rs rs [?l ?l] 07ee 1743
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?l ?l] 07ef 0843
                               movwf    v_portb             ;  1 OV rs rs [?l ?l] 07f0 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  395          LedOrange = true
; 16f876a.jal
;  238    _PORTB_flush()
; behave.jal
;  395          LedOrange = true
;  396       else
                               branchlo_set l__l876         ;  1 OV rs rs [?l ?L] 07f1 158a
                               goto     l__l876             ;  1 OV rs rs [?L ?L] 07f2 2883
l__l879
;  397          LedGreen  = false
                               datalo_clr v__portb_shadow ; x81;  1 OV rS rs [?l ?l] 07f3 1283
                               bcf      v__portb_shadow, 3 ; x81;  1 OV rs rs [?l ?l] 07f4 11c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?l ?l] 07f5 0843
                               movwf    v_portb             ;  1 OV rs rs [?l ?l] 07f6 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  397          LedGreen  = false
; 16f876a.jal
;  263    _PORTB_flush()
; behave.jal
;  397          LedGreen  = false
;  398          LedYellow = false
                               bcf      v__portb_shadow, 7 ; x82;  1 OV rs rs [?l ?l] 07f7 13c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?l ?l] 07f8 0843
                               movwf    v_portb             ;  1 OV rs rs [?l ?l] 07f9 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  398          LedYellow = false
; 16f876a.jal
;  229    _PORTB_flush()
; behave.jal
;  398          LedYellow = false
;  399          LedOrange = false
                               bcf      v__portb_shadow, 6 ; x83;  1 OV rs rs [?l ?l] 07fa 1343
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?l ?l] 07fb 0843
                               movwf    v_portb             ;  1 OV rs rs [?l ?l] 07fc 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  399          LedOrange = false
; 16f876a.jal
;  238    _PORTB_flush()
; behave.jal
;  399          LedOrange = false
;  400       end if
;  402   else 
                               branchlo_set l__l876         ;  1 OV rs rs [?l ?L] 07fd 158a
                               goto     l__l876             ;  1 OV rs rs [?L ?L] 07fe 2883
l__l877
;  404       if (check_delay(0)) then
                               movlw    0                   ;  1 OV rs rs [?l ?l] 07ff 3000
                               branchlo_nop l_check_delay   ;  1 OV rs rs [?l ?l] 0800
                               call     l_check_delay       ;  1 OV rs ?? [?l ??] 0800 252f
                               datalo_clr v__pic_temp ; _pic_temp    ;  1 OV ?? ?s [?? ??] 0801 1283
                               datahi_clr v__pic_temp ; _pic_temp    ;  1 OV ?s rs [?? ??] 0802 1303
                               branchlo_set l__l1202        ;  1 OV rs rs [?? ?L] 0803 158a
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?L ?L] 0804 1820
                               goto     l__l1202            ;  1 OV rs rs [?L ?L] 0805 2809
                               datalo_set v____bitbucket_9 ; _btemp117;  1 OV rs rS [?L ?L] 0806 1683
                               bcf      v____bitbucket_9, 6 ; _btemp117;  1 OV rS rS [?L ?L] 0807 1352
                               branchlo_nop l__l1203        ;  1 OV rS rS [?L ?L] 0808
                               goto     l__l1203            ;  1 OV rS rS [?L ?L] 0808 280b
l__l1202
                               datalo_set v____bitbucket_9 ; _btemp117;  1 OV rs rS [?L ?L] 0809 1683
                               bsf      v____bitbucket_9, 6 ; _btemp117;  1 OV rS rS [?L ?L] 080a 1752
l__l1203
                               branchlo_nop l__l893         ;  1 OV rS rS [?L ?L] 080b
                               btfss    v____bitbucket_9, 6 ; _btemp117;  1 OV rS rS [?L ?L] 080b 1f52
                               goto     l__l893             ;  1 OV rS rS [?L ?L] 080c 2836
;  407          set_delay(0, 20)
                               movlw    20                  ;  1 OV rS rS [?L ?L] 080d 3014
                               movwf    v___ticks_1         ;  1 OV rS rS [?L ?L] 080e 00d7
                               clrf     v___ticks_1+1       ;  1 OV rS rS [?L ?L] 080f 01d8
                                                            ; W = v___ticks_1
                               movlw    0                   ;  1 OV rS rS [?L ?L] 0810 3000
                                                            ; W = v___ticks_1
                               branchlo_clr l_set_delay     ;  1 OV rS rS [?L ?l] 0811 118a
                               call     l_set_delay         ;  1 OV rS ?? [?l ??] 0812 2518
;  408          tmp = StartCounter % 50 
                               movlw    50                  ;  1 OV ?? ?? [?? ??] 0813 3032
                               datalo_clr v__pic_divisor    ;  1 OV ?? ?s [?? ??] 0814 1283
                               datahi_clr v__pic_divisor    ;  1 OV ?s rs [?? ??] 0815 1303
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 0816 00a8
                               clrf     v__pic_divisor+1    ;  1 OV rs rs [?? ??] 0817 01a9
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+2    ;  1 OV rs rs [?? ??] 0818 01aa
                                                            ; W = v__pic_divisor
                               clrf     v__pic_divisor+3    ;  1 OV rs rs [?? ??] 0819 01ab
                                                            ; W = v__pic_divisor
                               movf     v_startcounter,w    ;  1 OV rs rs [?? ??] 081a 085d
                                                            ; W = v__pic_divisor
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 081b 00a0
                                                            ; W = v_startcounter
                               clrf     v__pic_dividend+1   ;  1 OV rs rs [?? ??] 081c 01a1
                                                            ; W = v__pic_dividend
                               clrf     v__pic_dividend+2   ;  1 OV rs rs [?? ??] 081d 01a2
                                                            ; W = v__pic_dividend
                               clrf     v__pic_dividend+3   ;  1 OV rs rs [?? ??] 081e 01a3
                                                            ; W = v__pic_dividend
                               branchlo_clr l__pic_divide   ;  1 OV rs rs [?? ?l] 081f 118a
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  1 OV rs ?? [?l ??] 0820 206f
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_remainder  ;  1 OV ?? ?s [?? ??] 0821 1283
                               datahi_clr v__pic_remainder  ;  1 OV ?s rs [?? ??] 0822 1303
                               movf     v__pic_remainder,w  ;  1 OV rs rs [?? ??] 0823 0824
                               movwf    v_tmp               ;  1 OV rs rs [?? ??] 0824 00ec
                                                            ; W = v__pic_remainder
;  409          if ((PcfData & 0x10) == 0) then 
                               datalo_set v____temp_62      ;  1 OV rs rS [?? ??] 0825 1683
                                                            ; W = v_tmp
                               clrf     v____temp_62        ;  1 OV rS rS [?? ??] 0826 01bd
                                                            ; W = v_tmp
                               movf     v____temp_62,w      ;  1 OV rS rS [?? ??] 0827 083d
                                                            ; W = v_tmp
                               branchlo_set l__l895         ;  1 OV rS rS [?? ?L] 0828 158a
                                                            ; W = v____temp_62
                               btfss    v__status, v__z     ;  1 OV rS rS [?L ?L] 0829 1d03
                                                            ; W = v____temp_62
                               goto     l__l895             ;  1 OV rS rS [?L ?L] 082a 2834
                                                            ; W = v____temp_62
;  410                if (tmp > 20) then ; 30 * 20 = 0.6 seconde / seconde sneller 
                               movlw    20                  ;  1 OV rS rS [?L ?L] 082b 3014
                               datalo_clr v_tmp             ;  1 OV rS rs [?L ?L] 082c 1283
                               subwf    v_tmp,w             ;  1 OV rs rs [?L ?L] 082d 026c
                               branchlo_nop l__l894         ;  1 OV rs rs [?L ?L] 082e
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 082e 1903
                               goto     l__l894             ;  1 OV rs rs [?L ?L] 082f 2834
                               branchlo_nop l__l894         ;  1 OV rs rs [?L ?L] 0830
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 0830 1c03
                               goto     l__l894             ;  1 OV rs rs [?L ?L] 0831 2834
;  411                   StartCounter = StartCounter - 30
                               movlw    30                  ;  1 OV rs rs [?L ?L] 0832 301e
                               subwf    v_startcounter,f    ;  1 OV rs rs [?L ?L] 0833 02dd
;  412                end if       
;  413          end if 
l__l895
l__l894
;  417          StartCounter = StartCounter - 1              
                               datalo_clr v_startcounter    ;  1 OV r? rs [?L ?L] 0834 1283
                               decf     v_startcounter,f    ;  1 OV rs rs [?L ?L] 0835 03dd
;  418       end if
l__l893
;  421       if (StartCounter > 200) then 
                               movlw    200                 ;  1 OV r? rs [?L ?L] 0836 30c8
                               datalo_clr v_startcounter    ;  1 OV r? rs [?L ?L] 0837 1283
                               subwf    v_startcounter,w    ;  1 OV rs rs [?L ?L] 0838 025d
                               branchlo_nop l__l899         ;  1 OV rs rs [?L ?L] 0839
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0839 1903
                               goto     l__l899             ;  1 OV rs rs [?L ?L] 083a 2847
                               branchlo_nop l__l899         ;  1 OV rs rs [?L ?L] 083b
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 083b 1c03
                               goto     l__l899             ;  1 OV rs rs [?L ?L] 083c 2847
;  423          LedGreen  = true
                               bsf      v__portb_shadow, 3 ; x84;  1 OV rs rs [?L ?L] 083d 15c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 083e 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 083f 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  423          LedGreen  = true
; 16f876a.jal
;  263    _PORTB_flush()
; behave.jal
;  423          LedGreen  = true
;  424          LedYellow = false
                               bcf      v__portb_shadow, 7 ; x85;  1 OV rs rs [?L ?L] 0840 13c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 0841 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 0842 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  424          LedYellow = false
; 16f876a.jal
;  229    _PORTB_flush()
; behave.jal
;  424          LedYellow = false
;  425          LedOrange = false
                               bcf      v__portb_shadow, 6 ; x86;  1 OV rs rs [?L ?L] 0843 1343
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 0844 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 0845 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  425          LedOrange = false
; 16f876a.jal
;  238    _PORTB_flush()
; behave.jal
;  425          LedOrange = false
;  427       elsif (StartCounter > 150) then 
                               branchlo_nop l__l898         ;  1 OV rs rs [?L ?L] 0846
                               goto     l__l898             ;  1 OV rs rs [?L ?L] 0846 2883
l__l899
                               movlw    150                 ;  1 OV rs rs [?L ?L] 0847 3096
                               subwf    v_startcounter,w    ;  1 OV rs rs [?L ?L] 0848 025d
                               branchlo_nop l__l906         ;  1 OV rs rs [?L ?L] 0849
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0849 1903
                               goto     l__l906             ;  1 OV rs rs [?L ?L] 084a 2857
                               branchlo_nop l__l906         ;  1 OV rs rs [?L ?L] 084b
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 084b 1c03
                               goto     l__l906             ;  1 OV rs rs [?L ?L] 084c 2857
;  429          LedGreen  = false
                               bcf      v__portb_shadow, 3 ; x87;  1 OV rs rs [?L ?L] 084d 11c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 084e 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 084f 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  429          LedGreen  = false
; 16f876a.jal
;  263    _PORTB_flush()
; behave.jal
;  429          LedGreen  = false
;  430          LedYellow = true
                               bsf      v__portb_shadow, 7 ; x88;  1 OV rs rs [?L ?L] 0850 17c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 0851 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 0852 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  430          LedYellow = true
; 16f876a.jal
;  229    _PORTB_flush()
; behave.jal
;  430          LedYellow = true
;  431          LedOrange = false
                               bcf      v__portb_shadow, 6 ; x89;  1 OV rs rs [?L ?L] 0853 1343
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 0854 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 0855 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  431          LedOrange = false
; 16f876a.jal
;  238    _PORTB_flush()
; behave.jal
;  431          LedOrange = false
;  433       elsif (StartCounter > 100) then 
                               branchlo_nop l__l898         ;  1 OV rs rs [?L ?L] 0856
                               goto     l__l898             ;  1 OV rs rs [?L ?L] 0856 2883
l__l906
                               movlw    100                 ;  1 OV rs rs [?L ?L] 0857 3064
                               subwf    v_startcounter,w    ;  1 OV rs rs [?L ?L] 0858 025d
                               branchlo_nop l__l913         ;  1 OV rs rs [?L ?L] 0859
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0859 1903
                               goto     l__l913             ;  1 OV rs rs [?L ?L] 085a 2867
                               branchlo_nop l__l913         ;  1 OV rs rs [?L ?L] 085b
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 085b 1c03
                               goto     l__l913             ;  1 OV rs rs [?L ?L] 085c 2867
;  435          LedGreen  = false
                               bcf      v__portb_shadow, 3 ; x90;  1 OV rs rs [?L ?L] 085d 11c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 085e 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 085f 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  435          LedGreen  = false
; 16f876a.jal
;  263    _PORTB_flush()
; behave.jal
;  435          LedGreen  = false
;  436          LedYellow = false
                               bcf      v__portb_shadow, 7 ; x91;  1 OV rs rs [?L ?L] 0860 13c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 0861 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 0862 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  436          LedYellow = false
; 16f876a.jal
;  229    _PORTB_flush()
; behave.jal
;  436          LedYellow = false
;  437          LedOrange = true
                               bsf      v__portb_shadow, 6 ; x92;  1 OV rs rs [?L ?L] 0863 1743
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 0864 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 0865 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  437          LedOrange = true
; 16f876a.jal
;  238    _PORTB_flush()
; behave.jal
;  437          LedOrange = true
;  439       elsif (StartCounter > 50) then 
                               branchlo_nop l__l898         ;  1 OV rs rs [?L ?L] 0866
                               goto     l__l898             ;  1 OV rs rs [?L ?L] 0866 2883
l__l913
                               movlw    50                  ;  1 OV rs rs [?L ?L] 0867 3032
                               subwf    v_startcounter,w    ;  1 OV rs rs [?L ?L] 0868 025d
                               branchlo_nop l__l920         ;  1 OV rs rs [?L ?L] 0869
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0869 1903
                               goto     l__l920             ;  1 OV rs rs [?L ?L] 086a 2877
                               branchlo_nop l__l920         ;  1 OV rs rs [?L ?L] 086b
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 086b 1c03
                               goto     l__l920             ;  1 OV rs rs [?L ?L] 086c 2877
;  441          LedGreen  = false
                               bcf      v__portb_shadow, 3 ; x93;  1 OV rs rs [?L ?L] 086d 11c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 086e 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 086f 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  441          LedGreen  = false
; 16f876a.jal
;  263    _PORTB_flush()
; behave.jal
;  441          LedGreen  = false
;  442          LedYellow = true
                               bsf      v__portb_shadow, 7 ; x94;  1 OV rs rs [?L ?L] 0870 17c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 0871 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 0872 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  442          LedYellow = true
; 16f876a.jal
;  229    _PORTB_flush()
; behave.jal
;  442          LedYellow = true
;  443          LedOrange = false
                               bcf      v__portb_shadow, 6 ; x95;  1 OV rs rs [?L ?L] 0873 1343
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 0874 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 0875 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  443          LedOrange = false
; 16f876a.jal
;  238    _PORTB_flush()
; behave.jal
;  443          LedOrange = false
;  445       elsif (StartCounter > 0) then 
                               branchlo_nop l__l898         ;  1 OV rs rs [?L ?L] 0876
                               goto     l__l898             ;  1 OV rs rs [?L ?L] 0876 2883
l__l920
                               movf     v_startcounter,w    ;  1 OV rs rs [?L ?L] 0877 085d
                               branchlo_nop l__l927         ;  1 OV rs rs [?L ?L] 0878
                                                            ; W = v_startcounter
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0878 1903
                                                            ; W = v_startcounter
                               goto     l__l927             ;  1 OV rs rs [?L ?L] 0879 2883
                                                            ; W = v_startcounter
;  447          LedGreen  = true
                               bsf      v__portb_shadow, 3 ; x96;  1 OV rs rs [?L ?L] 087a 15c3
                                                            ; W = v_requestcontrol
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 087b 0843
                                                            ; W = v_requestcontrol
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 087c 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  447          LedGreen  = true
; 16f876a.jal
;  263    _PORTB_flush()
; behave.jal
;  447          LedGreen  = true
;  448          LedYellow = true
                               bsf      v__portb_shadow, 7 ; x97;  1 OV rs rs [?L ?L] 087d 17c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 087e 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 087f 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  448          LedYellow = true
; 16f876a.jal
;  229    _PORTB_flush()
; behave.jal
;  448          LedYellow = true
;  449          LedOrange = true
                               bsf      v__portb_shadow, 6 ; x98;  1 OV rs rs [?L ?L] 0880 1743
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  1 OV rs rs [?L ?L] 0881 0843
                               movwf    v_portb             ;  1 OV rs rs [?L ?L] 0882 0086
                                                            ; W = v__portb_shadow
; behave.jal
;  449          LedOrange = true
; 16f876a.jal
;  238    _PORTB_flush()
; behave.jal
;  449          LedOrange = true
;  451       end if 
l__l927
l__l898
;  452    end if 
l__l876
;  455    MotorL = 0;
                               clrf     v_motorl            ;  1 OV rs rs [?L ?L] 0883 01d3
                                                            ; W = v_startcounter
;  456    MotorR = 0;
                               clrf     v_motorr            ;  1 OV rs rs [?L ?L] 0884 01d4
                                                            ; W = v_startcounter
;  459    RequestControl = ID
                               movf     v___id_17,w         ;  1 OV rs rs [?L ?L] 0885 086a
                                                            ; W = v_startcounter
                               movwf    v_requestcontrol    ;  1 OV rs rs [?L ?L] 0886 00d5
                                                            ; W = v___id_17
;  461 end procedure
l__l867
                               return                       ;  1 OV rs rs [?L ?L] 0887 0008
                                                            ; W = v_requestcontrol
; vloersensor.jal
;    3 procedure Vloersensor is
l_vloersensor
;   14    pin_a4_direction = output
                               datalo_set v_trisa ; pin_a4_direction        ;  1 OV ?? ?S [?L ?L] 0888 1683
                               datahi_clr v_trisa ; pin_a4_direction        ;  1 OV ?S rS [?L ?L] 0889 1303
                               bcf      v_trisa, 4 ; pin_a4_direction       ;  1 OV rS rS [?L ?L] 088a 1205
;   15    pin_a4 = false
                               datalo_clr v__porta_shadow ; x99;  1 OV rS rs [?L ?L] 088b 1283
                               bcf      v__porta_shadow, 4 ; x99;  1 OV rs rs [?L ?L] 088c 1242
; 16f876a.jal
;  100    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w   ;  1 OV rs rs [?L ?L] 088d 0842
                               movwf    v_porta             ;  1 OV rs rs [?L ?L] 088e 0085
                                                            ; W = v__porta_shadow
; vloersensor.jal
;   15    pin_a4 = false
; 16f876a.jal
;  146    _PORTA_flush()
; vloersensor.jal
;   15    pin_a4 = false
;   17    delay_10us(20)
                               movlw    20                  ;  1 OV rs rs [?L ?L] 088f 3014
                               branchlo_clr l_delay_10us    ;  1 OV rs rs [?L ?l] 0890 118a
                               call     l_delay_10us        ;  1 OV rs ?? [?l ??] 0891 20dc
;   19   	LineL = ADC_read(0)
                               movlw    0                   ;  1 OV ?? ?? [?? ??] 0892 3000
                               branchlo_clr l_adc_read      ;  1 OV ?? ?? [?? ?l] 0893 118a
                               call     l_adc_read          ;  1 OV ?? ?? [?l ??] 0894 2416
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0895 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 0896 1303
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 0897 0820
                               movwf    v_linel             ;  1 OV rs rs [?? ??] 0898 00d7
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 0899 0821
                                                            ; W = v_linel
                               movwf    v_linel+1           ;  1 OV rs rs [?? ??] 089a 00d8
                                                            ; W = v__pic_temp
;   20   	LineR = ADC_read(1)
                               movlw    1                   ;  1 OV rs rs [?? ??] 089b 3001
                                                            ; W = v_linel
                               branchlo_clr l_adc_read      ;  1 OV rs rs [?? ?l] 089c 118a
                               call     l_adc_read          ;  1 OV rs ?? [?l ??] 089d 2416
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 089e 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 089f 1303
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 08a0 0820
                               movwf    v_liner             ;  1 OV rs rs [?? ??] 08a1 00d9
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 08a2 0821
                                                            ; W = v_liner
                               movwf    v_liner+1           ;  1 OV rs rs [?? ??] 08a3 00da
                                                            ; W = v__pic_temp
;   24    pin_a4 = true
                               bsf      v__porta_shadow, 4 ; x100;  1 OV rs rs [?? ??] 08a4 1642
                                                            ; W = v_liner
; 16f876a.jal
;  100    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w   ;  1 OV rs rs [?? ??] 08a5 0842
                                                            ; W = v_liner
                               movwf    v_porta             ;  1 OV rs rs [?? ??] 08a6 0085
                                                            ; W = v__porta_shadow
; vloersensor.jal
;   24    pin_a4 = true
; 16f876a.jal
;  146    _PORTA_flush()
; vloersensor.jal
;   24    pin_a4 = true
;   25    delay_10us(40)
                               movlw    40                  ;  1 OV rs rs [?? ??] 08a7 3028
                               branchlo_clr l_delay_10us    ;  1 OV rs rs [?? ?l] 08a8 118a
                               call     l_delay_10us        ;  1 OV rs ?? [?l ??] 08a9 20dc
;   27    SensorTmp = ADC_read(0)
                               movlw    0                   ;  1 OV ?? ?? [?? ??] 08aa 3000
                               branchlo_clr l_adc_read      ;  1 OV ?? ?? [?? ?l] 08ab 118a
                               call     l_adc_read          ;  1 OV ?? ?? [?l ??] 08ac 2416
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 08ad 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 08ae 1303
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 08af 0820
                               movwf    v_sensortmp         ;  1 OV rs rs [?? ??] 08b0 00ea
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 08b1 0821
                                                            ; W = v_sensortmp
                               movwf    v_sensortmp+1       ;  1 OV rs rs [?? ??] 08b2 00eb
                                                            ; W = v__pic_temp
;   28    if (LineL < SensorTmp) then
                               movf     v_linel+1,w         ;  1 OV rs rs [?? ??] 08b3 0858
                                                            ; W = v_sensortmp
                               subwf    v_sensortmp+1,w     ;  1 OV rs rs [?? ??] 08b4 026b
                                                            ; W = v_linel
                               branchlo_set l__l1214        ;  1 OV rs rs [?? ?L] 08b5 158a
                               btfss    v__status, v__z     ;  1 OV rs rs [?L ?L] 08b6 1d03
                               goto     l__l1214            ;  1 OV rs rs [?L ?L] 08b7 28ba
                               movf     v_linel,w           ;  1 OV rs rs [?L ?L] 08b8 0857
                               subwf    v_sensortmp,w       ;  1 OV rs rs [?L ?L] 08b9 026a
                                                            ; W = v_linel
l__l1214
                               branchlo_nop l__l941         ;  1 OV rs rs [?L ?L] 08ba
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 08ba 1903
                               goto     l__l941             ;  1 OV rs rs [?L ?L] 08bb 28c7
                               branchlo_nop l__l941         ;  1 OV rs rs [?L ?L] 08bc
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 08bc 1c03
                               goto     l__l941             ;  1 OV rs rs [?L ?L] 08bd 28c7
;   29 		LineL = SensorTmp - LineL  	
                               movf     v_linel+1,w         ;  1 OV rs rs [?L ?L] 08be 0858
                               subwf    v_sensortmp+1,w     ;  1 OV rs rs [?L ?L] 08bf 026b
                                                            ; W = v_linel
                               movwf    v_linel+1           ;  1 OV rs rs [?L ?L] 08c0 00d8
                               movf     v_linel,w           ;  1 OV rs rs [?L ?L] 08c1 0857
                                                            ; W = v_linel
                               subwf    v_sensortmp,w       ;  1 OV rs rs [?L ?L] 08c2 026a
                                                            ; W = v_linel
                               movwf    v_linel             ;  1 OV rs rs [?L ?L] 08c3 00d7
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 08c4 1c03
                                                            ; W = v_linel
                               decf     v_linel+1,f         ;  1 OV rs rs [?L ?L] 08c5 03d8
                                                            ; W = v_linel
;   30 	else
                               branchlo_nop l__l940         ;  1 OV rs rs [?L ?L] 08c6
                               goto     l__l940             ;  1 OV rs rs [?L ?L] 08c6 28c9
l__l941
;   31 		LineL = 0
                               clrf     v_linel             ;  1 OV rs rs [?L ?L] 08c7 01d7
                               clrf     v_linel+1           ;  1 OV rs rs [?L ?L] 08c8 01d8
;   32    end if
l__l940
;   34    SensorTmp = ADC_read(1)
                               movlw    1                   ;  1 OV rs rs [?L ?L] 08c9 3001
                               branchlo_clr l_adc_read      ;  1 OV rs rs [?L ?l] 08ca 118a
                               call     l_adc_read          ;  1 OV rs ?? [?l ??] 08cb 2416
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 08cc 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 08cd 1303
                               movf     v__pic_temp,w       ;  1 OV rs rs [?? ??] 08ce 0820
                               movwf    v_sensortmp         ;  1 OV rs rs [?? ??] 08cf 00ea
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  1 OV rs rs [?? ??] 08d0 0821
                                                            ; W = v_sensortmp
                               movwf    v_sensortmp+1       ;  1 OV rs rs [?? ??] 08d1 00eb
                                                            ; W = v__pic_temp
;   35    if (LineR < SensorTmp) then
                               movf     v_liner+1,w         ;  1 OV rs rs [?? ??] 08d2 085a
                                                            ; W = v_sensortmp
                               subwf    v_sensortmp+1,w     ;  1 OV rs rs [?? ??] 08d3 026b
                                                            ; W = v_liner
                               branchlo_set l__l1216        ;  1 OV rs rs [?? ?L] 08d4 158a
                               btfss    v__status, v__z     ;  1 OV rs rs [?L ?L] 08d5 1d03
                               goto     l__l1216            ;  1 OV rs rs [?L ?L] 08d6 28d9
                               movf     v_liner,w           ;  1 OV rs rs [?L ?L] 08d7 0859
                               subwf    v_sensortmp,w       ;  1 OV rs rs [?L ?L] 08d8 026a
                                                            ; W = v_liner
l__l1216
                               branchlo_nop l__l943         ;  1 OV rs rs [?L ?L] 08d9
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 08d9 1903
                               goto     l__l943             ;  1 OV rs rs [?L ?L] 08da 28e6
                               branchlo_nop l__l943         ;  1 OV rs rs [?L ?L] 08db
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 08db 1c03
                               goto     l__l943             ;  1 OV rs rs [?L ?L] 08dc 28e6
;   36 		LineR = SensorTmp - LineR  	
                               movf     v_liner+1,w         ;  1 OV rs rs [?L ?L] 08dd 085a
                               subwf    v_sensortmp+1,w     ;  1 OV rs rs [?L ?L] 08de 026b
                                                            ; W = v_liner
                               movwf    v_liner+1           ;  1 OV rs rs [?L ?L] 08df 00da
                               movf     v_liner,w           ;  1 OV rs rs [?L ?L] 08e0 0859
                                                            ; W = v_liner
                               subwf    v_sensortmp,w       ;  1 OV rs rs [?L ?L] 08e1 026a
                                                            ; W = v_liner
                               movwf    v_liner             ;  1 OV rs rs [?L ?L] 08e2 00d9
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 08e3 1c03
                                                            ; W = v_liner
                               decf     v_liner+1,f         ;  1 OV rs rs [?L ?L] 08e4 03da
                                                            ; W = v_liner
;   37 	else
                               return                       ;  1 OV rs rs [?L ?L] 08e5 0008
l__l943
;   38 		LineR = 0
                               clrf     v_liner             ;  1 OV rs rs [?L ?L] 08e6 01d9
                               clrf     v_liner+1           ;  1 OV rs rs [?L ?L] 08e7 01da
;   39    end if
l__l942
;   41 end procedure
                               return                       ;  1 OV rs rs [?L ?L] 08e8 0008
; pcf8574.jal
;   12 end procedure
l__l944
; csv.jal
;    3 var word eeprom_adres = 0   ; higher and lower address byte
                               clrf     v_eeprom_adres      ;  0 OV rs rs [?L ?L] 08e9 01de
                                                            ; W = v_startcounter
                               clrf     v_eeprom_adres+1    ;  0 OV rs rs [?L ?L] 08ea 01df
                                                            ; W = v_startcounter
;   12 function read_byte_from_eeprom(word in addr) return byte is
                               branchlo_nop l__l977         ;  0 OV rs rs [?L ?L] 08eb
                                                            ; W = v_startcounter
                               goto     l__l977             ;  0 OV rs rs [?L ?L] 08eb 2af0
                                                            ; W = v_startcounter
l_read_byte_from_eeprom
;   16    i2c_start()
                               branchlo_clr l_i2c_start     ;  2 OV Rs Rs [?L ?l] 08ec 118a
                                                            ; W = v___addr_1
                               call     l_i2c_start         ;  2 OV Rs ?? [?l ??] 08ed 25c0
                                                            ; W = v___addr_1
;   17    ret = i2c_transmit_byte(0xA0)            ; chip adres, write
                               movlw    160                 ;  2 OV ?? ?? [?? ??] 08ee 30a0
                               branchlo_clr l_i2c_transmit_byte;  2 OV ?? ?? [?? ?l] 08ef 118a
                               call     l_i2c_transmit_byte ;  2 OV ?? ?? [?l ??] 08f0 25d5
;   18    ret = i2c_transmit_byte(byte(addr >> 8))              ; hi adres
                               datalo_clr v___addr_1        ;  2 OV ?? ?s [?? ??] 08f1 1283
                               datahi_set v___addr_1        ;  2 OV ?s Rs [?? ??] 08f2 1703
                               movf     v___addr_1+1,w      ;  2 OV Rs Rs [?? ??] 08f3 0833
                               datahi_clr v__pic_temp       ;  2 OV Rs rs [?? ??] 08f4 1303
                                                            ; W = v___addr_1
                               movwf    v__pic_temp         ;  2 OV rs rs [?? ??] 08f5 00a0
                                                            ; W = v___addr_1
                               clrf     v__pic_temp+1       ;  2 OV rs rs [?? ??] 08f6 01a1
                                                            ; W = v__pic_temp
                               movf     v__pic_temp,w       ;  2 OV rs rs [?? ??] 08f7 0820
                                                            ; W = v__pic_temp
                               datahi_set v____temp_65      ;  2 OV rs Rs [?? ??] 08f8 1703
                                                            ; W = v__pic_temp
                               movwf    v____temp_65        ;  2 OV Rs Rs [?? ??] 08f9 00b8
                                                            ; W = v__pic_temp
                               movf     v____temp_65,w      ;  2 OV Rs Rs [?? ??] 08fa 0838
                                                            ; W = v____temp_65
                               branchlo_clr l_i2c_transmit_byte;  2 OV Rs Rs [?? ?l] 08fb 118a
                                                            ; W = v____temp_65
                               call     l_i2c_transmit_byte ;  2 OV Rs ?? [?l ??] 08fc 25d5
                                                            ; W = v____temp_65
;   19    ret = i2c_transmit_byte(byte(addr & 0xFF))              ; lo adres
                               datalo_clr v___addr_1        ;  2 OV ?? ?s [?? ??] 08fd 1283
                               datahi_set v___addr_1        ;  2 OV ?s Rs [?? ??] 08fe 1703
                               movf     v___addr_1,w        ;  2 OV Rs Rs [?? ??] 08ff 0832
                               movwf    v____temp_65        ;  2 OV Rs Rs [?? ??] 0900 00b8
                                                            ; W = v___addr_1
                               movf     v____temp_65,w      ;  2 OV Rs Rs [?? ??] 0901 0838
                                                            ; W = v____temp_65
                               branchlo_clr l_i2c_transmit_byte;  2 OV Rs Rs [?? ?l] 0902 118a
                                                            ; W = v____temp_65
                               call     l_i2c_transmit_byte ;  2 OV Rs ?? [?l ??] 0903 25d5
                                                            ; W = v____temp_65
;   20    i2c_restart()
                               branchlo_clr l_i2c_restart   ;  2 OV ?? ?? [?? ?l] 0904 118a
                               call     l_i2c_restart       ;  2 OV ?? ?? [?l ??] 0905 25c7
;   21    ret = i2c_transmit_byte(0xA1)            ; chip adres, read
                               movlw    161                 ;  2 OV ?? ?? [?? ??] 0906 30a1
                               branchlo_clr l_i2c_transmit_byte;  2 OV ?? ?? [?? ?l] 0907 118a
                               call     l_i2c_transmit_byte ;  2 OV ?? ?? [?l ??] 0908 25d5
;   22    chr = i2c_receive_byte(0) ;_HW_receive_byte_nack(chr) ; read, Nack
                               datalo_clr v____bitbucket_34 ; ack1;  2 OV ?? ?s [?? ??] 0909 1283
                               datahi_set v____bitbucket_34 ; ack1;  2 OV ?s Rs [?? ??] 090a 1703
                               bcf      v____bitbucket_34, 0 ; ack1;  2 OV Rs Rs [?? ??] 090b 103c
                               branchlo_clr l_i2c_receive_byte;  2 OV Rs Rs [?? ?l] 090c 118a
                               call     l_i2c_receive_byte  ;  2 OV Rs ?? [?l ??] 090d 25ec
                               datalo_clr v_chr             ;  2 OV ?? ?s [?? ??] 090e 1283
                               datahi_set v_chr             ;  2 OV ?s Rs [?? ??] 090f 1703
                               movwf    v_chr               ;  2 OV Rs Rs [?? ??] 0910 00b6
;   23    i2c_stop()
                               branchlo_clr l_i2c_stop      ;  2 OV Rs Rs [?? ?l] 0911 118a
                                                            ; W = v_chr
                               call     l_i2c_stop          ;  2 OV Rs ?? [?l ??] 0912 25ce
                                                            ; W = v_chr
;   25    return chr
                               datalo_clr v_chr             ;  2 OV ?? ?s [?? ??] 0913 1283
                               datahi_set v_chr             ;  2 OV ?s Rs [?? ??] 0914 1703
                               movf     v_chr,w             ;  2 OV Rs Rs [?? ??] 0915 0836
;   26 end function
                               return                       ;  2 OV Rs Rs [?? ??] 0916 0008
                                                            ; W = v_chr
;  167 procedure CsvDump is
l_csvdump
;  170    eeprom_adres = 0   ; lower address byte
                               clrf     v_eeprom_adres      ;  1 OV rs rs [?L ?L] 0917 01de
                               clrf     v_eeprom_adres+1    ;  1 OV rs rs [?L ?L] 0918 01df
;  172    while (eeprom_adres < 32) loop     
l__l974
                               movlw    0                   ;  1 OV rs rs [?L ?L] 0919 3000
                               subwf    v_eeprom_adres+1,w  ;  1 OV rs rs [?L ?L] 091a 025f
                               branchlo_nop l__l1218        ;  1 OV rs rs [?L ?L] 091b
                               btfss    v__status, v__z     ;  1 OV rs rs [?L ?L] 091b 1d03
                               goto     l__l1218            ;  1 OV rs rs [?L ?L] 091c 291f
                               movlw    32                  ;  1 OV rs rs [?L ?L] 091d 3020
                               subwf    v_eeprom_adres,w    ;  1 OV rs rs [?L ?L] 091e 025e
l__l1218
                               branchlo_nop l__l975         ;  1 OV rs rs [?L ?L] 091f
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 091f 1903
                               goto     l__l975             ;  1 OV rs rs [?L ?L] 0920 2942
                               branchlo_nop l__l975         ;  1 OV rs rs [?L ?L] 0921
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 0921 1803
                               goto     l__l975             ;  1 OV rs rs [?L ?L] 0922 2942
;  173       chr = read_byte_from_eeprom(eeprom_adres);
                               movf     v_eeprom_adres,w    ;  1 OV rs rs [?L ?L] 0923 085e
                               datahi_set v___addr_1        ;  1 OV rs Rs [?L ?L] 0924 1703
                                                            ; W = v_eeprom_adres
                               movwf    v___addr_1          ;  1 OV Rs Rs [?L ?L] 0925 00b2
                                                            ; W = v_eeprom_adres
                               datahi_clr v_eeprom_adres    ;  1 OV Rs rs [?L ?L] 0926 1303
                                                            ; W = v___addr_1
                               movf     v_eeprom_adres+1,w  ;  1 OV rs rs [?L ?L] 0927 085f
                                                            ; W = v___addr_1
                               datahi_set v___addr_1        ;  1 OV rs Rs [?L ?L] 0928 1703
                                                            ; W = v_eeprom_adres
                               movwf    v___addr_1+1        ;  1 OV Rs Rs [?L ?L] 0929 00b3
                                                            ; W = v_eeprom_adres
                               branchlo_nop l_read_byte_from_eeprom;  1 OV Rs Rs [?L ?L] 092a
                                                            ; W = v___addr_1
                               call     l_read_byte_from_eeprom;  1 OV Rs ?? [?L ??] 092a 20ec
                                                            ; W = v___addr_1
                               datalo_clr v___chr_2         ;  1 OV ?? ?s [?? ??] 092b 1283
                               datahi_set v___chr_2         ;  1 OV ?s Rs [?? ??] 092c 1703
                               movwf    v___chr_2           ;  1 OV Rs Rs [?? ??] 092d 00b0
;  174       Print_Byte_Hex(serial_hw_data, Chr)
                               movlw    l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 092e 3086
                                                            ; W = v___chr_2
                               movwf    v____device_put_12  ;  1 OV Rs Rs [?? ??] 092f 00b2
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0930 3003
                                                            ; W = v____device_put_12
                               movwf    v____device_put_12+1;  1 OV Rs Rs [?? ??] 0931 00b3
                               movf     v___chr_2,w         ;  1 OV Rs Rs [?? ??] 0932 0830
                                                            ; W = v____device_put_12
                               branchlo_clr l_print_byte_hex;  1 OV Rs Rs [?? ?l] 0933 118a
                                                            ; W = v___chr_2
                               call     l_print_byte_hex    ;  1 OV Rs ?? [?l ??] 0934 21e1
                                                            ; W = v___chr_2
;  175       serial_hw_data = " "
                               movlw    32                  ;  1 OV ?? ?? [?? ??] 0935 3020
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0936 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 0937 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0938 00a0
                               branchlo_clr l__serial_hw_data_put;  1 OV rs rs [?? ?l] 0939 118a
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  1 OV rs ?? [?l ??] 093a 2386
                                                            ; W = v__pic_temp
;  177       eeprom_adres = eeprom_adres + 1
                               datalo_clr v_eeprom_adres    ;  1 OV ?? ?s [?? ??] 093b 1283
                               datahi_clr v_eeprom_adres    ;  1 OV ?s rs [?? ??] 093c 1303
                               incf     v_eeprom_adres,f    ;  1 OV rs rs [?? ??] 093d 0ade
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 093e 1903
                               incf     v_eeprom_adres+1,f  ;  1 OV rs rs [?? ??] 093f 0adf
;  178    end loop
                               branchlo_set l__l974         ;  1 OV rs rs [?? ?L] 0940 158a
                               goto     l__l974             ;  1 OV rs rs [?L ?L] 0941 2919
l__l975
;  179    Print_CrLf(serial_hw_data)
                               movlw    l__serial_hw_data_put;  1 OV rs rs [?L ?L] 0942 3086
                               datahi_set v__device_put     ;  1 OV rs Rs [?L ?L] 0943 1703
                               movwf    v__device_put       ;  1 OV Rs Rs [?L ?L] 0944 00b2
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?L ?L] 0945 3003
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  1 OV Rs Rs [?L ?L] 0946 00b3
                               branchlo_clr l_print_crlf    ;  1 OV Rs Rs [?L ?l] 0947 118a
                                                            ; W = v__device_put
                               goto     l_print_crlf        ;  1 OV Rs Rs [?l ?l] 0948 290e
                                                            ; W = v__device_put
;  181 end procedure
; console.jal
;    3 procedure console is
l_console
;    6    if (Serial_HW_read(cmd)) then
                               branchlo_clr l_serial_hw_read;  1 OV ?? ?? [?L ?l] 0949 118a
                               call     l_serial_hw_read    ;  1 OV ?? ?? [?l ??] 094a 2369
                               datalo_clr v_cmd             ;  1 OV ?? ?s [?? ??] 094b 1283
                               datahi_clr v_cmd             ;  1 OV ?s rs [?? ??] 094c 1303
                               movwf    v_cmd               ;  1 OV rs rs [?? ??] 094d 00ea
                               bcf      v____bitbucket_1, 0 ; _btemp149;  1 OV rs rs [?? ??] 094e 106c
                                                            ; W = v_cmd
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?? ??] 094f 1820
                                                            ; W = v_cmd
                               bsf      v____bitbucket_1, 0 ; _btemp149;  1 OV rs rs [?? ??] 0950 146c
                                                            ; W = v_cmd
                               branchlo_set l__l980         ;  1 OV rs rs [?? ?L] 0951 158a
                                                            ; W = v_cmd
                               btfss    v____bitbucket_1, 0 ; _btemp149;  1 OV rs rs [?L ?L] 0952 1c6c
                                                            ; W = v_cmd
                               goto     l__l980             ;  1 OV rs rs [?L ?L] 0953 2aef
                                                            ; W = v_cmd
;    8       case cmd of
;   17 		   "d" : block
                               movlw    100                 ;  1 OV rs rs [?L ?L] 0954 3064
                                                            ; W = v_cmd
                               subwf    v_cmd,w             ;  1 OV rs rs [?L ?L] 0955 026a
                               branchlo_nop l__l981         ;  1 OV rs rs [?L ?L] 0956
                               btfss    v__status, v__z     ;  1 OV rs rs [?L ?L] 0956 1d03
                               goto     l__l981             ;  1 OV rs rs [?L ?L] 0957 2959
;   18 		      CsvDump()
                               branchlo_nop l_csvdump       ;  1 OV rs rs [?L ?L] 0958
                               goto     l_csvdump           ;  1 OV rs rs [?L ?L] 0958 2917
;   19 		   end block
l__l981
;   21 		   "s" : block
                               movlw    115                 ;  1 OV rs rs [?L ?L] 0959 3073
                               subwf    v_cmd,w             ;  1 OV rs rs [?L ?L] 095a 026a
                               branchlo_nop l__l984         ;  1 OV rs rs [?L ?L] 095b
                               btfss    v__status, v__z     ;  1 OV rs rs [?L ?L] 095b 1d03
                               goto     l__l984             ;  1 OV rs rs [?L ?L] 095c 2ace
;   22 		      var byte cstr2[] = "Status\r\nWinner: "
                               movlw    83                  ;  1 OV rs rs [?L ?L] 095d 3053
                               datalo_set v_cstr2           ;  1 OV rs rS [?L ?L] 095e 1683
                               movwf    v_cstr2             ;  1 OV rS rS [?L ?L] 095f 00bd
                               movlw    116                 ;  1 OV rS rS [?L ?L] 0960 3074
                                                            ; W = v_cstr2
                               movwf    v_cstr2+1           ;  1 OV rS rS [?L ?L] 0961 00be
                               movlw    97                  ;  1 OV rS rS [?L ?L] 0962 3061
                                                            ; W = v_cstr2
                               movwf    v_cstr2+2           ;  1 OV rS rS [?L ?L] 0963 00bf
                               movlw    116                 ;  1 OV rS rS [?L ?L] 0964 3074
                                                            ; W = v_cstr2
                               movwf    v_cstr2+3           ;  1 OV rS rS [?L ?L] 0965 00c0
                               movlw    117                 ;  1 OV rS rS [?L ?L] 0966 3075
                                                            ; W = v_cstr2
                               movwf    v_cstr2+4           ;  1 OV rS rS [?L ?L] 0967 00c1
                               movlw    115                 ;  1 OV rS rS [?L ?L] 0968 3073
                                                            ; W = v_cstr2
                               movwf    v_cstr2+5           ;  1 OV rS rS [?L ?L] 0969 00c2
                               movlw    13                  ;  1 OV rS rS [?L ?L] 096a 300d
                                                            ; W = v_cstr2
                               movwf    v_cstr2+6           ;  1 OV rS rS [?L ?L] 096b 00c3
                               movlw    10                  ;  1 OV rS rS [?L ?L] 096c 300a
                                                            ; W = v_cstr2
                               movwf    v_cstr2+7           ;  1 OV rS rS [?L ?L] 096d 00c4
                               movlw    87                  ;  1 OV rS rS [?L ?L] 096e 3057
                                                            ; W = v_cstr2
                               movwf    v_cstr2+8           ;  1 OV rS rS [?L ?L] 096f 00c5
                               movlw    105                 ;  1 OV rS rS [?L ?L] 0970 3069
                                                            ; W = v_cstr2
                               movwf    v_cstr2+9           ;  1 OV rS rS [?L ?L] 0971 00c6
                               movlw    110                 ;  1 OV rS rS [?L ?L] 0972 306e
                                                            ; W = v_cstr2
                               movwf    v_cstr2+10          ;  1 OV rS rS [?L ?L] 0973 00c7
                               movlw    110                 ;  1 OV rS rS [?L ?L] 0974 306e
                                                            ; W = v_cstr2
                               movwf    v_cstr2+11          ;  1 OV rS rS [?L ?L] 0975 00c8
                               movlw    101                 ;  1 OV rS rS [?L ?L] 0976 3065
                                                            ; W = v_cstr2
                               movwf    v_cstr2+12          ;  1 OV rS rS [?L ?L] 0977 00c9
                               movlw    114                 ;  1 OV rS rS [?L ?L] 0978 3072
                                                            ; W = v_cstr2
                               movwf    v_cstr2+13          ;  1 OV rS rS [?L ?L] 0979 00ca
                               movlw    58                  ;  1 OV rS rS [?L ?L] 097a 303a
                                                            ; W = v_cstr2
                               movwf    v_cstr2+14          ;  1 OV rS rS [?L ?L] 097b 00cb
                               movlw    32                  ;  1 OV rS rS [?L ?L] 097c 3020
                                                            ; W = v_cstr2
                               movwf    v_cstr2+15          ;  1 OV rS rS [?L ?L] 097d 00cc
;   23             Print_String(serial_hw_data, cstr2)
                               movlw    l__serial_hw_data_put;  1 OV rS rS [?L ?L] 097e 3086
                                                            ; W = v_cstr2
                               datalo_clr v____device_put_1 ;  1 OV rS rs [?L ?L] 097f 1283
                               datahi_set v____device_put_1 ;  1 OV rs Rs [?L ?L] 0980 1703
                               movwf    v____device_put_1   ;  1 OV Rs Rs [?L ?L] 0981 00b6
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?L ?L] 0982 3003
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  1 OV Rs Rs [?L ?L] 0983 00b7
                               movlw    16                  ;  1 OV Rs Rs [?L ?L] 0984 3010
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  1 OV Rs Rs [?L ?L] 0985 00ba
                               clrf     v__str_count+1      ;  1 OV Rs Rs [?L ?L] 0986 01bb
                                                            ; W = v__str_count
                               movlw    189                 ;  1 OV Rs Rs [?L ?L] 0987 30bd
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  1 OV Rs Rs [?L ?L] 0988 00c0
                               clrf     v___str_1+1         ;  1 OV Rs Rs [?L ?L] 0989 01c1
                                                            ; W = v___str_1
                               branchlo_clr l_print_string  ;  1 OV Rs Rs [?L ?l] 098a 118a
                                                            ; W = v___str_1
                               call     l_print_string      ;  1 OV Rs ?? [?l ??] 098b 2124
                                                            ; W = v___str_1
;   24 		      Print_Byte_Dec(serial_hw_data, PrevWinner)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 098c 3086
                               datalo_clr v____device_put_19;  1 OV ?? ?s [?? ??] 098d 1283
                               datahi_set v____device_put_19;  1 OV ?s Rs [?? ??] 098e 1703
                               movwf    v____device_put_19  ;  1 OV Rs Rs [?? ??] 098f 00b0
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0990 3003
                                                            ; W = v____device_put_19
                               movwf    v____device_put_19+1;  1 OV Rs Rs [?? ??] 0991 00b1
                               datahi_clr v_prevwinner      ;  1 OV Rs rs [?? ??] 0992 1303
                                                            ; W = v____device_put_19
                               movf     v_prevwinner,w      ;  1 OV rs rs [?? ??] 0993 0856
                                                            ; W = v____device_put_19
                               branchlo_clr l_print_byte_dec;  1 OV rs rs [?? ?l] 0994 118a
                                                            ; W = v_prevwinner
                               call     l_print_byte_dec    ;  1 OV rs ?? [?l ??] 0995 2250
                                                            ; W = v_prevwinner
;   25 		      Print_CrLf(serial_hw_data)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 0996 3086
                               datalo_clr v__device_put     ;  1 OV ?? ?s [?? ??] 0997 1283
                               datahi_set v__device_put     ;  1 OV ?s Rs [?? ??] 0998 1703
                               movwf    v__device_put       ;  1 OV Rs Rs [?? ??] 0999 00b2
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 099a 3003
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  1 OV Rs Rs [?? ??] 099b 00b3
                               branchlo_clr l_print_crlf    ;  1 OV Rs Rs [?? ?l] 099c 118a
                                                            ; W = v__device_put
                               call     l_print_crlf        ;  1 OV Rs ?? [?l ??] 099d 210e
                                                            ; W = v__device_put
;   27 		      var byte cstr4[] = "Draairichting: "
                               movlw    68                  ;  1 OV ?? ?? [?? ??] 099e 3044
                               datalo_set v_cstr4           ;  1 OV ?? ?S [?? ??] 099f 1683
                               datahi_clr v_cstr4           ;  1 OV ?S rS [?? ??] 09a0 1303
                               movwf    v_cstr4             ;  1 OV rS rS [?? ??] 09a1 00da
                               movlw    114                 ;  1 OV rS rS [?? ??] 09a2 3072
                                                            ; W = v_cstr4
                               movwf    v_cstr4+1           ;  1 OV rS rS [?? ??] 09a3 00db
                               movlw    97                  ;  1 OV rS rS [?? ??] 09a4 3061
                                                            ; W = v_cstr4
                               movwf    v_cstr4+2           ;  1 OV rS rS [?? ??] 09a5 00dc
                               movlw    97                  ;  1 OV rS rS [?? ??] 09a6 3061
                                                            ; W = v_cstr4
                               movwf    v_cstr4+3           ;  1 OV rS rS [?? ??] 09a7 00dd
                               movlw    105                 ;  1 OV rS rS [?? ??] 09a8 3069
                                                            ; W = v_cstr4
                               movwf    v_cstr4+4           ;  1 OV rS rS [?? ??] 09a9 00de
                               movlw    114                 ;  1 OV rS rS [?? ??] 09aa 3072
                                                            ; W = v_cstr4
                               movwf    v_cstr4+5           ;  1 OV rS rS [?? ??] 09ab 00df
                               movlw    105                 ;  1 OV rS rS [?? ??] 09ac 3069
                                                            ; W = v_cstr4
                               movwf    v_cstr4+6           ;  1 OV rS rS [?? ??] 09ad 00e0
                               movlw    99                  ;  1 OV rS rS [?? ??] 09ae 3063
                                                            ; W = v_cstr4
                               movwf    v_cstr4+7           ;  1 OV rS rS [?? ??] 09af 00e1
                               movlw    104                 ;  1 OV rS rS [?? ??] 09b0 3068
                                                            ; W = v_cstr4
                               movwf    v_cstr4+8           ;  1 OV rS rS [?? ??] 09b1 00e2
                               movlw    116                 ;  1 OV rS rS [?? ??] 09b2 3074
                                                            ; W = v_cstr4
                               movwf    v_cstr4+9           ;  1 OV rS rS [?? ??] 09b3 00e3
                               movlw    105                 ;  1 OV rS rS [?? ??] 09b4 3069
                                                            ; W = v_cstr4
                               movwf    v_cstr4+10          ;  1 OV rS rS [?? ??] 09b5 00e4
                               movlw    110                 ;  1 OV rS rS [?? ??] 09b6 306e
                                                            ; W = v_cstr4
                               movwf    v_cstr4+11          ;  1 OV rS rS [?? ??] 09b7 00e5
                               movlw    103                 ;  1 OV rS rS [?? ??] 09b8 3067
                                                            ; W = v_cstr4
                               movwf    v_cstr4+12          ;  1 OV rS rS [?? ??] 09b9 00e6
                               movlw    58                  ;  1 OV rS rS [?? ??] 09ba 303a
                                                            ; W = v_cstr4
                               movwf    v_cstr4+13          ;  1 OV rS rS [?? ??] 09bb 00e7
                               movlw    32                  ;  1 OV rS rS [?? ??] 09bc 3020
                                                            ; W = v_cstr4
                               movwf    v_cstr4+14          ;  1 OV rS rS [?? ??] 09bd 00e8
;   28             Print_String(serial_hw_data, cstr4)
                               movlw    l__serial_hw_data_put;  1 OV rS rS [?? ??] 09be 3086
                                                            ; W = v_cstr4
                               datalo_clr v____device_put_1 ;  1 OV rS rs [?? ??] 09bf 1283
                               datahi_set v____device_put_1 ;  1 OV rs Rs [?? ??] 09c0 1703
                               movwf    v____device_put_1   ;  1 OV Rs Rs [?? ??] 09c1 00b6
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 09c2 3003
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  1 OV Rs Rs [?? ??] 09c3 00b7
                               movlw    15                  ;  1 OV Rs Rs [?? ??] 09c4 300f
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  1 OV Rs Rs [?? ??] 09c5 00ba
                               clrf     v__str_count+1      ;  1 OV Rs Rs [?? ??] 09c6 01bb
                                                            ; W = v__str_count
                               movlw    218                 ;  1 OV Rs Rs [?? ??] 09c7 30da
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  1 OV Rs Rs [?? ??] 09c8 00c0
                               clrf     v___str_1+1         ;  1 OV Rs Rs [?? ??] 09c9 01c1
                                                            ; W = v___str_1
                               branchlo_clr l_print_string  ;  1 OV Rs Rs [?? ?l] 09ca 118a
                                                            ; W = v___str_1
                               call     l_print_string      ;  1 OV Rs ?? [?l ??] 09cb 2124
                                                            ; W = v___str_1
;   29 		      print_bit_truefalse(serial_hw_data, Draairichting)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 09cc 3086
                               datalo_clr v____device_put_2 ;  1 OV ?? ?s [?? ??] 09cd 1283
                               datahi_set v____device_put_2 ;  1 OV ?s Rs [?? ??] 09ce 1703
                               movwf    v____device_put_2   ;  1 OV Rs Rs [?? ??] 09cf 00b0
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 09d0 3003
                                                            ; W = v____device_put_2
                               movwf    v____device_put_2+1 ;  1 OV Rs Rs [?? ??] 09d1 00b1
                               datahi_clr v__bitbucket ; draairichting   ;  1 OV Rs rs [?? ??] 09d2 1303
                                                            ; W = v____device_put_2
                               branchlo_set l__l1220        ;  1 OV rs rs [?? ?L] 09d3 158a
                                                            ; W = v____device_put_2
                               btfsc    v__bitbucket, 4 ; draairichting  ;  1 OV rs rs [?L ?L] 09d4 1a65
                                                            ; W = v____device_put_2
                               goto     l__l1220            ;  1 OV rs rs [?L ?L] 09d5 29d9
                                                            ; W = v____device_put_2
                               datahi_set v____bitbucket_87 ; data4;  1 OV rs Rs [?L ?L] 09d6 1703
                               bcf      v____bitbucket_87, 0 ; data4;  1 OV Rs Rs [?L ?L] 09d7 1034
                               branchlo_nop l__l1221        ;  1 OV Rs Rs [?L ?L] 09d8
                               goto     l__l1221            ;  1 OV Rs Rs [?L ?L] 09d8 29db
l__l1220
                               datahi_set v____bitbucket_87 ; data4;  1 OV rs Rs [?L ?L] 09d9 1703
                                                            ; W = v____device_put_2
                               bsf      v____bitbucket_87, 0 ; data4;  1 OV Rs Rs [?L ?L] 09da 1434
                                                            ; W = v____device_put_2
l__l1221
                               branchlo_clr l_print_bit_truefalse;  1 OV Rs Rs [?L ?l] 09db 118a
                                                            ; W = v____device_put_2
                               call     l_print_bit_truefalse;  1 OV Rs ?? [?l ??] 09dc 2150
                                                            ; W = v____device_put_2
;   30 		      Print_CrLf(serial_hw_data)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 09dd 3086
                               datalo_clr v__device_put     ;  1 OV ?? ?s [?? ??] 09de 1283
                               datahi_set v__device_put     ;  1 OV ?s Rs [?? ??] 09df 1703
                               movwf    v__device_put       ;  1 OV Rs Rs [?? ??] 09e0 00b2
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 09e1 3003
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  1 OV Rs Rs [?? ??] 09e2 00b3
                               branchlo_clr l_print_crlf    ;  1 OV Rs Rs [?? ?l] 09e3 118a
                                                            ; W = v__device_put
                               call     l_print_crlf        ;  1 OV Rs ?? [?l ??] 09e4 210e
                                                            ; W = v__device_put
;   32 		      var byte cstr3[] = "Pcf: 0x"
                               movlw    80                  ;  1 OV ?? ?? [?? ??] 09e5 3050
                               datalo_set v_cstr3           ;  1 OV ?? ?S [?? ??] 09e6 1683
                               datahi_clr v_cstr3           ;  1 OV ?S rS [?? ??] 09e7 1303
                               movwf    v_cstr3             ;  1 OV rS rS [?? ??] 09e8 00e9
                               movlw    99                  ;  1 OV rS rS [?? ??] 09e9 3063
                                                            ; W = v_cstr3
                               movwf    v_cstr3+1           ;  1 OV rS rS [?? ??] 09ea 00ea
                               movlw    102                 ;  1 OV rS rS [?? ??] 09eb 3066
                                                            ; W = v_cstr3
                               movwf    v_cstr3+2           ;  1 OV rS rS [?? ??] 09ec 00eb
                               movlw    58                  ;  1 OV rS rS [?? ??] 09ed 303a
                                                            ; W = v_cstr3
                               movwf    v_cstr3+3           ;  1 OV rS rS [?? ??] 09ee 00ec
                               movlw    32                  ;  1 OV rS rS [?? ??] 09ef 3020
                                                            ; W = v_cstr3
                               movwf    v_cstr3+4           ;  1 OV rS rS [?? ??] 09f0 00ed
                               movlw    48                  ;  1 OV rS rS [?? ??] 09f1 3030
                                                            ; W = v_cstr3
                               movwf    v_cstr3+5           ;  1 OV rS rS [?? ??] 09f2 00ee
                               movlw    120                 ;  1 OV rS rS [?? ??] 09f3 3078
                                                            ; W = v_cstr3
                               movwf    v_cstr3+6           ;  1 OV rS rS [?? ??] 09f4 00ef
;   33             Print_String(serial_hw_data, cstr3)
                               movlw    l__serial_hw_data_put;  1 OV rS rS [?? ??] 09f5 3086
                                                            ; W = v_cstr3
                               datalo_clr v____device_put_1 ;  1 OV rS rs [?? ??] 09f6 1283
                               datahi_set v____device_put_1 ;  1 OV rs Rs [?? ??] 09f7 1703
                               movwf    v____device_put_1   ;  1 OV Rs Rs [?? ??] 09f8 00b6
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 09f9 3003
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  1 OV Rs Rs [?? ??] 09fa 00b7
                               movlw    7                   ;  1 OV Rs Rs [?? ??] 09fb 3007
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  1 OV Rs Rs [?? ??] 09fc 00ba
                               clrf     v__str_count+1      ;  1 OV Rs Rs [?? ??] 09fd 01bb
                                                            ; W = v__str_count
                               movlw    233                 ;  1 OV Rs Rs [?? ??] 09fe 30e9
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  1 OV Rs Rs [?? ??] 09ff 00c0
                               clrf     v___str_1+1         ;  1 OV Rs Rs [?? ??] 0a00 01c1
                                                            ; W = v___str_1
                               branchlo_clr l_print_string  ;  1 OV Rs Rs [?? ?l] 0a01 118a
                                                            ; W = v___str_1
                               call     l_print_string      ;  1 OV Rs ?? [?l ??] 0a02 2124
                                                            ; W = v___str_1
;   34 		      Print_Byte_Hex(serial_hw_data, PcfData)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 0a03 3086
                               datalo_clr v____device_put_12;  1 OV ?? ?s [?? ??] 0a04 1283
                               datahi_set v____device_put_12;  1 OV ?s Rs [?? ??] 0a05 1703
                               movwf    v____device_put_12  ;  1 OV Rs Rs [?? ??] 0a06 00b2
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0a07 3003
                                                            ; W = v____device_put_12
                               movwf    v____device_put_12+1;  1 OV Rs Rs [?? ??] 0a08 00b3
                               movlw    0                   ;  1 OV Rs Rs [?? ??] 0a09 3000
                                                            ; W = v____device_put_12
                               branchlo_clr l_print_byte_hex;  1 OV Rs Rs [?? ?l] 0a0a 118a
                               call     l_print_byte_hex    ;  1 OV Rs ?? [?l ??] 0a0b 21e1
;   35 		      Print_CrLf(serial_hw_data)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 0a0c 3086
                               datalo_clr v__device_put     ;  1 OV ?? ?s [?? ??] 0a0d 1283
                               datahi_set v__device_put     ;  1 OV ?s Rs [?? ??] 0a0e 1703
                               movwf    v__device_put       ;  1 OV Rs Rs [?? ??] 0a0f 00b2
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0a10 3003
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  1 OV Rs Rs [?? ??] 0a11 00b3
                               branchlo_clr l_print_crlf    ;  1 OV Rs Rs [?? ?l] 0a12 118a
                                                            ; W = v__device_put
                               call     l_print_crlf        ;  1 OV Rs ?? [?l ??] 0a13 210e
                                                            ; W = v__device_put
;   37 		      var byte cstr5[] = "Vloersensor (L,R): "
                               movlw    86                  ;  1 OV ?? ?? [?? ??] 0a14 3056
                               datalo_clr v_cstr5           ;  1 OV ?? ?s [?? ??] 0a15 1283
                               datahi_set v_cstr5           ;  1 OV ?s Rs [?? ??] 0a16 1703
                               movwf    v_cstr5             ;  1 OV Rs Rs [?? ??] 0a17 0090
                               movlw    108                 ;  1 OV Rs Rs [?? ??] 0a18 306c
                                                            ; W = v_cstr5
                               movwf    v_cstr5+1           ;  1 OV Rs Rs [?? ??] 0a19 0091
                               movlw    111                 ;  1 OV Rs Rs [?? ??] 0a1a 306f
                                                            ; W = v_cstr5
                               movwf    v_cstr5+2           ;  1 OV Rs Rs [?? ??] 0a1b 0092
                               movlw    101                 ;  1 OV Rs Rs [?? ??] 0a1c 3065
                                                            ; W = v_cstr5
                               movwf    v_cstr5+3           ;  1 OV Rs Rs [?? ??] 0a1d 0093
                               movlw    114                 ;  1 OV Rs Rs [?? ??] 0a1e 3072
                                                            ; W = v_cstr5
                               movwf    v_cstr5+4           ;  1 OV Rs Rs [?? ??] 0a1f 0094
                               movlw    115                 ;  1 OV Rs Rs [?? ??] 0a20 3073
                                                            ; W = v_cstr5
                               movwf    v_cstr5+5           ;  1 OV Rs Rs [?? ??] 0a21 0095
                               movlw    101                 ;  1 OV Rs Rs [?? ??] 0a22 3065
                                                            ; W = v_cstr5
                               movwf    v_cstr5+6           ;  1 OV Rs Rs [?? ??] 0a23 0096
                               movlw    110                 ;  1 OV Rs Rs [?? ??] 0a24 306e
                                                            ; W = v_cstr5
                               movwf    v_cstr5+7           ;  1 OV Rs Rs [?? ??] 0a25 0097
                               movlw    115                 ;  1 OV Rs Rs [?? ??] 0a26 3073
                                                            ; W = v_cstr5
                               movwf    v_cstr5+8           ;  1 OV Rs Rs [?? ??] 0a27 0098
                               movlw    111                 ;  1 OV Rs Rs [?? ??] 0a28 306f
                                                            ; W = v_cstr5
                               movwf    v_cstr5+9           ;  1 OV Rs Rs [?? ??] 0a29 0099
                               movlw    114                 ;  1 OV Rs Rs [?? ??] 0a2a 3072
                                                            ; W = v_cstr5
                               movwf    v_cstr5+10          ;  1 OV Rs Rs [?? ??] 0a2b 009a
                               movlw    32                  ;  1 OV Rs Rs [?? ??] 0a2c 3020
                                                            ; W = v_cstr5
                               movwf    v_cstr5+11          ;  1 OV Rs Rs [?? ??] 0a2d 009b
                               movlw    40                  ;  1 OV Rs Rs [?? ??] 0a2e 3028
                                                            ; W = v_cstr5
                               movwf    v_cstr5+12          ;  1 OV Rs Rs [?? ??] 0a2f 009c
                               movlw    76                  ;  1 OV Rs Rs [?? ??] 0a30 304c
                                                            ; W = v_cstr5
                               movwf    v_cstr5+13          ;  1 OV Rs Rs [?? ??] 0a31 009d
                               movlw    44                  ;  1 OV Rs Rs [?? ??] 0a32 302c
                                                            ; W = v_cstr5
                               movwf    v_cstr5+14          ;  1 OV Rs Rs [?? ??] 0a33 009e
                               movlw    82                  ;  1 OV Rs Rs [?? ??] 0a34 3052
                                                            ; W = v_cstr5
                               movwf    v_cstr5+15          ;  1 OV Rs Rs [?? ??] 0a35 009f
                               movlw    41                  ;  1 OV Rs Rs [?? ??] 0a36 3029
                                                            ; W = v_cstr5
                               movwf    v_cstr5+16          ;  1 OV Rs Rs [?? ??] 0a37 00a0
                               movlw    58                  ;  1 OV Rs Rs [?? ??] 0a38 303a
                                                            ; W = v_cstr5
                               movwf    v_cstr5+17          ;  1 OV Rs Rs [?? ??] 0a39 00a1
                               movlw    32                  ;  1 OV Rs Rs [?? ??] 0a3a 3020
                                                            ; W = v_cstr5
                               movwf    v_cstr5+18          ;  1 OV Rs Rs [?? ??] 0a3b 00a2
;   38             Print_String(serial_hw_data, cstr5)
                               movlw    l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0a3c 3086
                                                            ; W = v_cstr5
                               movwf    v____device_put_1   ;  1 OV Rs Rs [?? ??] 0a3d 00b6
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0a3e 3003
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  1 OV Rs Rs [?? ??] 0a3f 00b7
                               movlw    19                  ;  1 OV Rs Rs [?? ??] 0a40 3013
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  1 OV Rs Rs [?? ??] 0a41 00ba
                               clrf     v__str_count+1      ;  1 OV Rs Rs [?? ??] 0a42 01bb
                                                            ; W = v__str_count
                               movlw    16                  ;  1 OV Rs Rs [?? ??] 0a43 3010
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  1 OV Rs Rs [?? ??] 0a44 00c0
                               movlw    1                   ;  1 OV Rs Rs [?? ??] 0a45 3001
                                                            ; W = v___str_1
                               movwf    v___str_1+1         ;  1 OV Rs Rs [?? ??] 0a46 00c1
                               branchlo_clr l_print_string  ;  1 OV Rs Rs [?? ?l] 0a47 118a
                                                            ; W = v___str_1
                               call     l_print_string      ;  1 OV Rs ?? [?l ??] 0a48 2124
                                                            ; W = v___str_1
;   39 		      Print_Word_Dec(serial_hw_data, LineL)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 0a49 3086
                               datalo_clr v____device_put_18;  1 OV ?? ?s [?? ??] 0a4a 1283
                               datahi_set v____device_put_18;  1 OV ?s Rs [?? ??] 0a4b 1703
                               movwf    v____device_put_18  ;  1 OV Rs Rs [?? ??] 0a4c 00b0
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0a4d 3003
                                                            ; W = v____device_put_18
                               movwf    v____device_put_18+1;  1 OV Rs Rs [?? ??] 0a4e 00b1
                               datahi_clr v_linel           ;  1 OV Rs rs [?? ??] 0a4f 1303
                                                            ; W = v____device_put_18
                               movf     v_linel,w           ;  1 OV rs rs [?? ??] 0a50 0857
                                                            ; W = v____device_put_18
                               datahi_set v___data_36       ;  1 OV rs Rs [?? ??] 0a51 1703
                                                            ; W = v_linel
                               movwf    v___data_36         ;  1 OV Rs Rs [?? ??] 0a52 00b4
                                                            ; W = v_linel
                               datahi_clr v_linel           ;  1 OV Rs rs [?? ??] 0a53 1303
                                                            ; W = v___data_36
                               movf     v_linel+1,w         ;  1 OV rs rs [?? ??] 0a54 0858
                                                            ; W = v___data_36
                               datahi_set v___data_36       ;  1 OV rs Rs [?? ??] 0a55 1703
                                                            ; W = v_linel
                               movwf    v___data_36+1       ;  1 OV Rs Rs [?? ??] 0a56 00b5
                                                            ; W = v_linel
                               branchlo_clr l_print_word_dec;  1 OV Rs Rs [?? ?l] 0a57 118a
                                                            ; W = v___data_36
                               call     l_print_word_dec    ;  1 OV Rs ?? [?l ??] 0a58 223e
                                                            ; W = v___data_36
;   40 		      serial_hw_data = " "
                               movlw    32                  ;  1 OV ?? ?? [?? ??] 0a59 3020
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0a5a 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 0a5b 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0a5c 00a0
                               branchlo_clr l__serial_hw_data_put;  1 OV rs rs [?? ?l] 0a5d 118a
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  1 OV rs ?? [?l ??] 0a5e 2386
                                                            ; W = v__pic_temp
;   41 		      Print_Word_Dec(serial_hw_data, LineR)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 0a5f 3086
                               datalo_clr v____device_put_18;  1 OV ?? ?s [?? ??] 0a60 1283
                               datahi_set v____device_put_18;  1 OV ?s Rs [?? ??] 0a61 1703
                               movwf    v____device_put_18  ;  1 OV Rs Rs [?? ??] 0a62 00b0
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0a63 3003
                                                            ; W = v____device_put_18
                               movwf    v____device_put_18+1;  1 OV Rs Rs [?? ??] 0a64 00b1
                               datahi_clr v_liner           ;  1 OV Rs rs [?? ??] 0a65 1303
                                                            ; W = v____device_put_18
                               movf     v_liner,w           ;  1 OV rs rs [?? ??] 0a66 0859
                                                            ; W = v____device_put_18
                               datahi_set v___data_36       ;  1 OV rs Rs [?? ??] 0a67 1703
                                                            ; W = v_liner
                               movwf    v___data_36         ;  1 OV Rs Rs [?? ??] 0a68 00b4
                                                            ; W = v_liner
                               datahi_clr v_liner           ;  1 OV Rs rs [?? ??] 0a69 1303
                                                            ; W = v___data_36
                               movf     v_liner+1,w         ;  1 OV rs rs [?? ??] 0a6a 085a
                                                            ; W = v___data_36
                               datahi_set v___data_36       ;  1 OV rs Rs [?? ??] 0a6b 1703
                                                            ; W = v_liner
                               movwf    v___data_36+1       ;  1 OV Rs Rs [?? ??] 0a6c 00b5
                                                            ; W = v_liner
                               branchlo_clr l_print_word_dec;  1 OV Rs Rs [?? ?l] 0a6d 118a
                                                            ; W = v___data_36
                               call     l_print_word_dec    ;  1 OV Rs ?? [?l ??] 0a6e 223e
                                                            ; W = v___data_36
;   42 		      Print_CrLf(serial_hw_data)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 0a6f 3086
                               datalo_clr v__device_put     ;  1 OV ?? ?s [?? ??] 0a70 1283
                               datahi_set v__device_put     ;  1 OV ?s Rs [?? ??] 0a71 1703
                               movwf    v__device_put       ;  1 OV Rs Rs [?? ??] 0a72 00b2
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0a73 3003
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  1 OV Rs Rs [?? ??] 0a74 00b3
                               branchlo_clr l_print_crlf    ;  1 OV Rs Rs [?? ?l] 0a75 118a
                                                            ; W = v__device_put
                               call     l_print_crlf        ;  1 OV Rs ?? [?l ??] 0a76 210e
                                                            ; W = v__device_put
;   44 		      var byte cstr6[] = "Motor (L,R): "
                               movlw    77                  ;  1 OV ?? ?? [?? ??] 0a77 304d
                               datalo_clr v_cstr6           ;  1 OV ?? ?s [?? ??] 0a78 1283
                               datahi_set v_cstr6           ;  1 OV ?s Rs [?? ??] 0a79 1703
                               movwf    v_cstr6             ;  1 OV Rs Rs [?? ??] 0a7a 00a3
                               movlw    111                 ;  1 OV Rs Rs [?? ??] 0a7b 306f
                                                            ; W = v_cstr6
                               movwf    v_cstr6+1           ;  1 OV Rs Rs [?? ??] 0a7c 00a4
                               movlw    116                 ;  1 OV Rs Rs [?? ??] 0a7d 3074
                                                            ; W = v_cstr6
                               movwf    v_cstr6+2           ;  1 OV Rs Rs [?? ??] 0a7e 00a5
                               movlw    111                 ;  1 OV Rs Rs [?? ??] 0a7f 306f
                                                            ; W = v_cstr6
                               movwf    v_cstr6+3           ;  1 OV Rs Rs [?? ??] 0a80 00a6
                               movlw    114                 ;  1 OV Rs Rs [?? ??] 0a81 3072
                                                            ; W = v_cstr6
                               movwf    v_cstr6+4           ;  1 OV Rs Rs [?? ??] 0a82 00a7
                               movlw    32                  ;  1 OV Rs Rs [?? ??] 0a83 3020
                                                            ; W = v_cstr6
                               movwf    v_cstr6+5           ;  1 OV Rs Rs [?? ??] 0a84 00a8
                               movlw    40                  ;  1 OV Rs Rs [?? ??] 0a85 3028
                                                            ; W = v_cstr6
                               movwf    v_cstr6+6           ;  1 OV Rs Rs [?? ??] 0a86 00a9
                               movlw    76                  ;  1 OV Rs Rs [?? ??] 0a87 304c
                                                            ; W = v_cstr6
                               movwf    v_cstr6+7           ;  1 OV Rs Rs [?? ??] 0a88 00aa
                               movlw    44                  ;  1 OV Rs Rs [?? ??] 0a89 302c
                                                            ; W = v_cstr6
                               movwf    v_cstr6+8           ;  1 OV Rs Rs [?? ??] 0a8a 00ab
                               movlw    82                  ;  1 OV Rs Rs [?? ??] 0a8b 3052
                                                            ; W = v_cstr6
                               movwf    v_cstr6+9           ;  1 OV Rs Rs [?? ??] 0a8c 00ac
                               movlw    41                  ;  1 OV Rs Rs [?? ??] 0a8d 3029
                                                            ; W = v_cstr6
                               movwf    v_cstr6+10          ;  1 OV Rs Rs [?? ??] 0a8e 00ad
                               movlw    58                  ;  1 OV Rs Rs [?? ??] 0a8f 303a
                                                            ; W = v_cstr6
                               movwf    v_cstr6+11          ;  1 OV Rs Rs [?? ??] 0a90 00ae
                               movlw    32                  ;  1 OV Rs Rs [?? ??] 0a91 3020
                                                            ; W = v_cstr6
                               movwf    v_cstr6+12          ;  1 OV Rs Rs [?? ??] 0a92 00af
;   45             Print_String(serial_hw_data, cstr6)
                               movlw    l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0a93 3086
                                                            ; W = v_cstr6
                               movwf    v____device_put_1   ;  1 OV Rs Rs [?? ??] 0a94 00b6
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0a95 3003
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  1 OV Rs Rs [?? ??] 0a96 00b7
                               movlw    13                  ;  1 OV Rs Rs [?? ??] 0a97 300d
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  1 OV Rs Rs [?? ??] 0a98 00ba
                               clrf     v__str_count+1      ;  1 OV Rs Rs [?? ??] 0a99 01bb
                                                            ; W = v__str_count
                               movlw    35                  ;  1 OV Rs Rs [?? ??] 0a9a 3023
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  1 OV Rs Rs [?? ??] 0a9b 00c0
                               movlw    1                   ;  1 OV Rs Rs [?? ??] 0a9c 3001
                                                            ; W = v___str_1
                               movwf    v___str_1+1         ;  1 OV Rs Rs [?? ??] 0a9d 00c1
                               branchlo_clr l_print_string  ;  1 OV Rs Rs [?? ?l] 0a9e 118a
                                                            ; W = v___str_1
                               call     l_print_string      ;  1 OV Rs ?? [?l ??] 0a9f 2124
                                                            ; W = v___str_1
;   46 		      Print_sword_Dec(serial_hw_data, MotorL)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 0aa0 3086
                               datalo_clr v____device_put_14;  1 OV ?? ?s [?? ??] 0aa1 1283
                               datahi_set v____device_put_14;  1 OV ?s Rs [?? ??] 0aa2 1703
                               movwf    v____device_put_14  ;  1 OV Rs Rs [?? ??] 0aa3 00b0
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0aa4 3003
                                                            ; W = v____device_put_14
                               movwf    v____device_put_14+1;  1 OV Rs Rs [?? ??] 0aa5 00b1
                               datahi_clr v_motorl          ;  1 OV Rs rs [?? ??] 0aa6 1303
                                                            ; W = v____device_put_14
                               movf     v_motorl,w          ;  1 OV rs rs [?? ??] 0aa7 0853
                                                            ; W = v____device_put_14
                               datahi_set v___data_28       ;  1 OV rs Rs [?? ??] 0aa8 1703
                                                            ; W = v_motorl
                               movwf    v___data_28         ;  1 OV Rs Rs [?? ??] 0aa9 00b4
                                                            ; W = v_motorl
                               movlw    0                   ;  1 OV Rs Rs [?? ??] 0aaa 3000
                                                            ; W = v___data_28
                               btfsc    v___data_28, 7      ;  1 OV Rs Rs [?? ??] 0aab 1bb4
                               movlw    255                 ;  1 OV Rs Rs [?? ??] 0aac 30ff
                               movwf    v___data_28+1       ;  1 OV Rs Rs [?? ??] 0aad 00b5
                               branchlo_clr l_print_sword_dec;  1 OV Rs Rs [?? ?l] 0aae 118a
                                                            ; W = v___data_28
                               call     l_print_sword_dec   ;  1 OV Rs ?? [?l ??] 0aaf 2229
                                                            ; W = v___data_28
;   47 		      serial_hw_data = " "
                               movlw    32                  ;  1 OV ?? ?? [?? ??] 0ab0 3020
                               datalo_clr v__pic_temp       ;  1 OV ?? ?s [?? ??] 0ab1 1283
                               datahi_clr v__pic_temp       ;  1 OV ?s rs [?? ??] 0ab2 1303
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0ab3 00a0
                               branchlo_clr l__serial_hw_data_put;  1 OV rs rs [?? ?l] 0ab4 118a
                                                            ; W = v__pic_temp
                               call     l__serial_hw_data_put;  1 OV rs ?? [?l ??] 0ab5 2386
                                                            ; W = v__pic_temp
;   48 		      Print_sword_Dec(serial_hw_data, MotorR)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 0ab6 3086
                               datalo_clr v____device_put_14;  1 OV ?? ?s [?? ??] 0ab7 1283
                               datahi_set v____device_put_14;  1 OV ?s Rs [?? ??] 0ab8 1703
                               movwf    v____device_put_14  ;  1 OV Rs Rs [?? ??] 0ab9 00b0
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0aba 3003
                                                            ; W = v____device_put_14
                               movwf    v____device_put_14+1;  1 OV Rs Rs [?? ??] 0abb 00b1
                               datahi_clr v_motorr          ;  1 OV Rs rs [?? ??] 0abc 1303
                                                            ; W = v____device_put_14
                               movf     v_motorr,w          ;  1 OV rs rs [?? ??] 0abd 0854
                                                            ; W = v____device_put_14
                               datahi_set v___data_28       ;  1 OV rs Rs [?? ??] 0abe 1703
                                                            ; W = v_motorr
                               movwf    v___data_28         ;  1 OV Rs Rs [?? ??] 0abf 00b4
                                                            ; W = v_motorr
                               movlw    0                   ;  1 OV Rs Rs [?? ??] 0ac0 3000
                                                            ; W = v___data_28
                               btfsc    v___data_28, 7      ;  1 OV Rs Rs [?? ??] 0ac1 1bb4
                               movlw    255                 ;  1 OV Rs Rs [?? ??] 0ac2 30ff
                               movwf    v___data_28+1       ;  1 OV Rs Rs [?? ??] 0ac3 00b5
                               branchlo_clr l_print_sword_dec;  1 OV Rs Rs [?? ?l] 0ac4 118a
                                                            ; W = v___data_28
                               call     l_print_sword_dec   ;  1 OV Rs ?? [?l ??] 0ac5 2229
                                                            ; W = v___data_28
;   49 		      Print_CrLf(serial_hw_data)
                               movlw    l__serial_hw_data_put;  1 OV ?? ?? [?? ??] 0ac6 3086
                               datalo_clr v__device_put     ;  1 OV ?? ?s [?? ??] 0ac7 1283
                               datahi_set v__device_put     ;  1 OV ?s Rs [?? ??] 0ac8 1703
                               movwf    v__device_put       ;  1 OV Rs Rs [?? ??] 0ac9 00b2
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?? ??] 0aca 3003
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  1 OV Rs Rs [?? ??] 0acb 00b3
                               branchlo_clr l_print_crlf    ;  1 OV Rs Rs [?? ?l] 0acc 118a
                                                            ; W = v__device_put
                               goto     l_print_crlf        ;  1 OV Rs Rs [?l ?l] 0acd 290e
                                                            ; W = v__device_put
;   50          end block
l__l984
;   52 		   OTHERWISE block
;   53 		      var byte cstr1[] = "Bad cmd\r\n"
                               movlw    66                  ;  1 OV rs rs [?L ?L] 0ace 3042
                               datalo_set v_cstr1           ;  1 OV rs rS [?L ?L] 0acf 1683
                               movwf    v_cstr1             ;  1 OV rS rS [?L ?L] 0ad0 00bd
                               movlw    97                  ;  1 OV rS rS [?L ?L] 0ad1 3061
                                                            ; W = v_cstr1
                               movwf    v_cstr1+1           ;  1 OV rS rS [?L ?L] 0ad2 00be
                               movlw    100                 ;  1 OV rS rS [?L ?L] 0ad3 3064
                                                            ; W = v_cstr1
                               movwf    v_cstr1+2           ;  1 OV rS rS [?L ?L] 0ad4 00bf
                               movlw    32                  ;  1 OV rS rS [?L ?L] 0ad5 3020
                                                            ; W = v_cstr1
                               movwf    v_cstr1+3           ;  1 OV rS rS [?L ?L] 0ad6 00c0
                               movlw    99                  ;  1 OV rS rS [?L ?L] 0ad7 3063
                                                            ; W = v_cstr1
                               movwf    v_cstr1+4           ;  1 OV rS rS [?L ?L] 0ad8 00c1
                               movlw    109                 ;  1 OV rS rS [?L ?L] 0ad9 306d
                                                            ; W = v_cstr1
                               movwf    v_cstr1+5           ;  1 OV rS rS [?L ?L] 0ada 00c2
                               movlw    100                 ;  1 OV rS rS [?L ?L] 0adb 3064
                                                            ; W = v_cstr1
                               movwf    v_cstr1+6           ;  1 OV rS rS [?L ?L] 0adc 00c3
                               movlw    13                  ;  1 OV rS rS [?L ?L] 0add 300d
                                                            ; W = v_cstr1
                               movwf    v_cstr1+7           ;  1 OV rS rS [?L ?L] 0ade 00c4
                               movlw    10                  ;  1 OV rS rS [?L ?L] 0adf 300a
                                                            ; W = v_cstr1
                               movwf    v_cstr1+8           ;  1 OV rS rS [?L ?L] 0ae0 00c5
;   54             Print_String(serial_hw_data, cstr1)
                               movlw    l__serial_hw_data_put;  1 OV rS rS [?L ?L] 0ae1 3086
                                                            ; W = v_cstr1
                               datalo_clr v____device_put_1 ;  1 OV rS rs [?L ?L] 0ae2 1283
                               datahi_set v____device_put_1 ;  1 OV rs Rs [?L ?L] 0ae3 1703
                               movwf    v____device_put_1   ;  1 OV Rs Rs [?L ?L] 0ae4 00b6
                               movlw    HIGH l__serial_hw_data_put;  1 OV Rs Rs [?L ?L] 0ae5 3003
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  1 OV Rs Rs [?L ?L] 0ae6 00b7
                               movlw    9                   ;  1 OV Rs Rs [?L ?L] 0ae7 3009
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  1 OV Rs Rs [?L ?L] 0ae8 00ba
                               clrf     v__str_count+1      ;  1 OV Rs Rs [?L ?L] 0ae9 01bb
                                                            ; W = v__str_count
                               movlw    189                 ;  1 OV Rs Rs [?L ?L] 0aea 30bd
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  1 OV Rs Rs [?L ?L] 0aeb 00c0
                               clrf     v___str_1+1         ;  1 OV Rs Rs [?L ?L] 0aec 01c1
                                                            ; W = v___str_1
                               branchlo_clr l_print_string  ;  1 OV Rs Rs [?L ?l] 0aed 118a
                                                            ; W = v___str_1
                               goto     l_print_string      ;  1 OV Rs Rs [?l ?l] 0aee 2924
                                                            ; W = v___str_1
;   55          end block
l__l983
;   57    end if
l__l980
l__l979
;   59 end procedure
                               return                       ;  1 OV rs rs [?L ?L] 0aef 0008
                                                            ; W = v_cmd
l__l977
; rikishi2.jal
;  145    var byte str1[] = "\nRikishi NG (V2.0)\r\n"
                               movlw    10                  ;  0 OV rs rs [?L ?L] 0af0 300a
                                                            ; W = v_startcounter
                               datalo_set v___str1_2        ;  0 OV rs rS [?L ?L] 0af1 1683
                               movwf    v___str1_2          ;  0 OV rS rS [?L ?L] 0af2 00a0
                               movlw    82                  ;  0 OV rS rS [?L ?L] 0af3 3052
                                                            ; W = v___str1_2
                               movwf    v___str1_2+1        ;  0 OV rS rS [?L ?L] 0af4 00a1
                               movlw    105                 ;  0 OV rS rS [?L ?L] 0af5 3069
                                                            ; W = v___str1_2
                               movwf    v___str1_2+2        ;  0 OV rS rS [?L ?L] 0af6 00a2
                               movlw    107                 ;  0 OV rS rS [?L ?L] 0af7 306b
                                                            ; W = v___str1_2
                               movwf    v___str1_2+3        ;  0 OV rS rS [?L ?L] 0af8 00a3
                               movlw    105                 ;  0 OV rS rS [?L ?L] 0af9 3069
                                                            ; W = v___str1_2
                               movwf    v___str1_2+4        ;  0 OV rS rS [?L ?L] 0afa 00a4
                               movlw    115                 ;  0 OV rS rS [?L ?L] 0afb 3073
                                                            ; W = v___str1_2
                               movwf    v___str1_2+5        ;  0 OV rS rS [?L ?L] 0afc 00a5
                               movlw    104                 ;  0 OV rS rS [?L ?L] 0afd 3068
                                                            ; W = v___str1_2
                               movwf    v___str1_2+6        ;  0 OV rS rS [?L ?L] 0afe 00a6
                               movlw    105                 ;  0 OV rS rS [?L ?L] 0aff 3069
                                                            ; W = v___str1_2
                               movwf    v___str1_2+7        ;  0 OV rS rS [?L ?L] 0b00 00a7
                               movlw    32                  ;  0 OV rS rS [?L ?L] 0b01 3020
                                                            ; W = v___str1_2
                               movwf    v___str1_2+8        ;  0 OV rS rS [?L ?L] 0b02 00a8
                               movlw    78                  ;  0 OV rS rS [?L ?L] 0b03 304e
                                                            ; W = v___str1_2
                               movwf    v___str1_2+9        ;  0 OV rS rS [?L ?L] 0b04 00a9
                               movlw    71                  ;  0 OV rS rS [?L ?L] 0b05 3047
                                                            ; W = v___str1_2
                               movwf    v___str1_2+10       ;  0 OV rS rS [?L ?L] 0b06 00aa
                               movlw    32                  ;  0 OV rS rS [?L ?L] 0b07 3020
                                                            ; W = v___str1_2
                               movwf    v___str1_2+11       ;  0 OV rS rS [?L ?L] 0b08 00ab
                               movlw    40                  ;  0 OV rS rS [?L ?L] 0b09 3028
                                                            ; W = v___str1_2
                               movwf    v___str1_2+12       ;  0 OV rS rS [?L ?L] 0b0a 00ac
                               movlw    86                  ;  0 OV rS rS [?L ?L] 0b0b 3056
                                                            ; W = v___str1_2
                               movwf    v___str1_2+13       ;  0 OV rS rS [?L ?L] 0b0c 00ad
                               movlw    50                  ;  0 OV rS rS [?L ?L] 0b0d 3032
                                                            ; W = v___str1_2
                               movwf    v___str1_2+14       ;  0 OV rS rS [?L ?L] 0b0e 00ae
                               movlw    46                  ;  0 OV rS rS [?L ?L] 0b0f 302e
                                                            ; W = v___str1_2
                               movwf    v___str1_2+15       ;  0 OV rS rS [?L ?L] 0b10 00af
                               movlw    48                  ;  0 OV rS rS [?L ?L] 0b11 3030
                                                            ; W = v___str1_2
                               movwf    v___str1_2+16       ;  0 OV rS rS [?L ?L] 0b12 00b0
                               movlw    41                  ;  0 OV rS rS [?L ?L] 0b13 3029
                                                            ; W = v___str1_2
                               movwf    v___str1_2+17       ;  0 OV rS rS [?L ?L] 0b14 00b1
                               movlw    13                  ;  0 OV rS rS [?L ?L] 0b15 300d
                                                            ; W = v___str1_2
                               movwf    v___str1_2+18       ;  0 OV rS rS [?L ?L] 0b16 00b2
                               movlw    10                  ;  0 OV rS rS [?L ?L] 0b17 300a
                                                            ; W = v___str1_2
                               movwf    v___str1_2+19       ;  0 OV rS rS [?L ?L] 0b18 00b3
;  146    Print_String(serial_hw_data, str1)
                               movlw    l__serial_hw_data_put;  0 OV rS rS [?L ?L] 0b19 3086
                                                            ; W = v___str1_2
                               datalo_clr v____device_put_1 ;  0 OV rS rs [?L ?L] 0b1a 1283
                               datahi_set v____device_put_1 ;  0 OV rs Rs [?L ?L] 0b1b 1703
                               movwf    v____device_put_1   ;  0 OV Rs Rs [?L ?L] 0b1c 00b6
                               movlw    HIGH l__serial_hw_data_put;  0 OV Rs Rs [?L ?L] 0b1d 3003
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  0 OV Rs Rs [?L ?L] 0b1e 00b7
                               movlw    20                  ;  0 OV Rs Rs [?L ?L] 0b1f 3014
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  0 OV Rs Rs [?L ?L] 0b20 00ba
                               clrf     v__str_count+1      ;  0 OV Rs Rs [?L ?L] 0b21 01bb
                                                            ; W = v__str_count
                               movlw    160                 ;  0 OV Rs Rs [?L ?L] 0b22 30a0
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV Rs Rs [?L ?L] 0b23 00c0
                               clrf     v___str_1+1         ;  0 OV Rs Rs [?L ?L] 0b24 01c1
                                                            ; W = v___str_1
                               branchlo_clr l_print_string  ;  0 OV Rs Rs [?L ?l] 0b25 118a
                                                            ; W = v___str_1
                               call     l_print_string      ;  0 OV Rs ?? [?l ??] 0b26 2124
                                                            ; W = v___str_1
;  150    ccpr1l = 0;
                               datalo_clr v_ccpr1l          ;  0 OV ?? ?s [?? ??] 0b27 1283
                               datahi_clr v_ccpr1l          ;  0 OV ?s rs [?? ??] 0b28 1303
                               clrf     v_ccpr1l            ;  0 OV rs rs [?? ??] 0b29 0195
;  151    ccpr2l = 0;
                               clrf     v_ccpr2l            ;  0 OV rs rs [?? ??] 0b2a 019b
;  152    Bridge_2 = ! Bridge_1
                               branchlo_set l__l1223        ;  0 OV rs rs [?? ?L] 0b2b 158a
                               btfss    v_portb, 5 ; pin_b5       ;  0 OV rs rs [?L ?L] 0b2c 1e86
                               goto     l__l1223            ;  0 OV rs rs [?L ?L] 0b2d 2b30
                               bcf      v__bitbucket, 5 ; _btemp152  ;  0 OV rs rs [?L ?L] 0b2e 12e5
                               branchlo_nop l__l1222        ;  0 OV rs rs [?L ?L] 0b2f
                               goto     l__l1222            ;  0 OV rs rs [?L ?L] 0b2f 2b31
l__l1223
                               bsf      v__bitbucket, 5 ; _btemp152  ;  0 OV rs rs [?L ?L] 0b30 16e5
l__l1222
                               bcf      v__portb_shadow, 4 ; x102;  0 OV rs rs [?L ?L] 0b31 1243
                               btfsc    v__bitbucket, 5 ; _btemp152  ;  0 OV rs rs [?L ?L] 0b32 1ae5
                               bsf      v__portb_shadow, 4 ; x102;  0 OV rs rs [?L ?L] 0b33 1643
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?L ?L] 0b34 0843
                               movwf    v_portb             ;  0 OV rs rs [?L ?L] 0b35 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  152    Bridge_2 = ! Bridge_1
; 16f876a.jal
;  254    _PORTB_flush()
; rikishi2.jal
;  152    Bridge_2 = ! Bridge_1
;  153    Bridge_4 = ! Bridge_3
                               branchlo_nop l__l1225        ;  0 OV rs rs [?L ?L] 0b36
                               btfss    v_portb, 2 ; pin_b2       ;  0 OV rs rs [?L ?L] 0b36 1d06
                               goto     l__l1225            ;  0 OV rs rs [?L ?L] 0b37 2b3a
                               bcf      v__bitbucket, 6 ; _btemp153  ;  0 OV rs rs [?L ?L] 0b38 1365
                               branchlo_nop l__l1224        ;  0 OV rs rs [?L ?L] 0b39
                               goto     l__l1224            ;  0 OV rs rs [?L ?L] 0b39 2b3b
l__l1225
                               bsf      v__bitbucket, 6 ; _btemp153  ;  0 OV rs rs [?L ?L] 0b3a 1765
l__l1224
                               bcf      v__portb_shadow, 1 ; x103;  0 OV rs rs [?L ?L] 0b3b 10c3
                               btfsc    v__bitbucket, 6 ; _btemp153  ;  0 OV rs rs [?L ?L] 0b3c 1b65
                               bsf      v__portb_shadow, 1 ; x103;  0 OV rs rs [?L ?L] 0b3d 14c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?L ?L] 0b3e 0843
                               movwf    v_portb             ;  0 OV rs rs [?L ?L] 0b3f 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  153    Bridge_4 = ! Bridge_3
; 16f876a.jal
;  279    _PORTB_flush()
; rikishi2.jal
;  153    Bridge_4 = ! Bridge_3
;  155    PrevWinner = 255
                               movlw    255                 ;  0 OV rs rs [?L ?L] 0b40 30ff
                               movwf    v_prevwinner        ;  0 OV rs rs [?L ?L] 0b41 00d6
;  156    var byte PrevPcfData = 255
                               movlw    255                 ;  0 OV rs rs [?L ?L] 0b42 30ff
                                                            ; W = v_prevwinner
                               movwf    v_prevpcfdata       ;  0 OV rs rs [?L ?L] 0b43 00e2
;  160 BatteryCheck();
                               branchlo_clr l_batterycheck  ;  0 OV rs rs [?L ?l] 0b44 118a
                                                            ; W = v_prevpcfdata
                               call     l_batterycheck      ;  0 OV rs ?? [?l ??] 0b45 26b6
                                                            ; W = v_prevpcfdata
;  162    forever loop
l__l992
;  164       if (PrevIsr_counter != isr_counter) then
                               branchlo_clr l__isr_counter_get;  0 OV ?? ?? [?? ?l] 0b46 118a
                               call     l__isr_counter_get  ;  0 OV ?? ?? [?l ??] 0b47 2505
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 0b48 1283
                               datahi_clr v__pic_temp       ;  0 OV ?s rs [?? ??] 0b49 1303
                               movf     v__pic_temp,w       ;  0 OV rs rs [?? ??] 0b4a 0820
                               movwf    v____temp_69        ;  0 OV rs rs [?? ??] 0b4b 00e3
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 0b4c 0821
                                                            ; W = v____temp_69
                               movwf    v____temp_69+1      ;  0 OV rs rs [?? ??] 0b4d 00e4
                                                            ; W = v__pic_temp
                               movf     v_previsr_counter,w ;  0 OV rs rs [?? ??] 0b4e 0860
                                                            ; W = v____temp_69
                               subwf    v____temp_69,w      ;  0 OV rs rs [?? ??] 0b4f 0263
                                                            ; W = v_previsr_counter
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 0b50 00a0
                               movf     v_previsr_counter+1,w;  0 OV rs rs [?? ??] 0b51 0861
                                                            ; W = v__pic_temp
                               subwf    v____temp_69+1,w    ;  0 OV rs rs [?? ??] 0b52 0264
                                                            ; W = v_previsr_counter
                               iorwf    v__pic_temp,w       ;  0 OV rs rs [?? ??] 0b53 0420
                               branchlo_set l__l992         ;  0 OV rs rs [?? ?L] 0b54 158a
                               btfsc    v__status, v__z     ;  0 OV rs rs [?L ?L] 0b55 1903
                               goto     l__l992             ;  0 OV rs rs [?L ?L] 0b56 2b46
;  167          Previsr_counter = isr_counter
                               branchlo_clr l__isr_counter_get;  0 OV rs rs [?L ?l] 0b57 118a
                               call     l__isr_counter_get  ;  0 OV rs ?? [?l ??] 0b58 2505
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 0b59 1283
                               datahi_clr v__pic_temp       ;  0 OV ?s rs [?? ??] 0b5a 1303
                               movf     v__pic_temp,w       ;  0 OV rs rs [?? ??] 0b5b 0820
                               movwf    v_previsr_counter   ;  0 OV rs rs [?? ??] 0b5c 00e0
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 0b5d 0821
                                                            ; W = v_previsr_counter
                               movwf    v_previsr_counter+1 ;  0 OV rs rs [?? ??] 0b5e 00e1
                                                            ; W = v__pic_temp
;  171          Buttons()         ; ca 50 us
                               branchlo_clr l_buttons       ;  0 OV rs rs [?? ?l] 0b5f 118a
                                                            ; W = v_previsr_counter
                               call     l_buttons           ;  0 OV rs ?? [?l ??] 0b60 2670
                                                            ; W = v_previsr_counter
;  172          VloerSensor()     ; ca 600 us
                               branchlo_set l_vloersensor   ;  0 OV ?? ?? [?? ?L] 0b61 158a
                               call     l_vloersensor       ;  0 OV ?? ?? [?L ??] 0b62 2088
;  176          if (PcfData != PrevPcfData) then
                               movlw    0                   ;  0 OV ?? ?? [?? ??] 0b63 3000
                               datalo_clr v_prevpcfdata     ;  0 OV ?? ?s [?? ??] 0b64 1283
                               datahi_clr v_prevpcfdata     ;  0 OV ?s rs [?? ??] 0b65 1303
                               subwf    v_prevpcfdata,w     ;  0 OV rs rs [?? ??] 0b66 0262
                               branchlo_set l__l997         ;  0 OV rs rs [?? ?L] 0b67 158a
                               btfsc    v__status, v__z     ;  0 OV rs rs [?L ?L] 0b68 1903
                               goto     l__l997             ;  0 OV rs rs [?L ?L] 0b69 2b9f
;  177             var byte mstr2[] = "PcfData: "
                               movlw    80                  ;  0 OV rs rs [?L ?L] 0b6a 3050
                               datalo_set v_mstr2           ;  0 OV rs rS [?L ?L] 0b6b 1683
                               movwf    v_mstr2             ;  0 OV rS rS [?L ?L] 0b6c 00b4
                               movlw    99                  ;  0 OV rS rS [?L ?L] 0b6d 3063
                                                            ; W = v_mstr2
                               movwf    v_mstr2+1           ;  0 OV rS rS [?L ?L] 0b6e 00b5
                               movlw    102                 ;  0 OV rS rS [?L ?L] 0b6f 3066
                                                            ; W = v_mstr2
                               movwf    v_mstr2+2           ;  0 OV rS rS [?L ?L] 0b70 00b6
                               movlw    68                  ;  0 OV rS rS [?L ?L] 0b71 3044
                                                            ; W = v_mstr2
                               movwf    v_mstr2+3           ;  0 OV rS rS [?L ?L] 0b72 00b7
                               movlw    97                  ;  0 OV rS rS [?L ?L] 0b73 3061
                                                            ; W = v_mstr2
                               movwf    v_mstr2+4           ;  0 OV rS rS [?L ?L] 0b74 00b8
                               movlw    116                 ;  0 OV rS rS [?L ?L] 0b75 3074
                                                            ; W = v_mstr2
                               movwf    v_mstr2+5           ;  0 OV rS rS [?L ?L] 0b76 00b9
                               movlw    97                  ;  0 OV rS rS [?L ?L] 0b77 3061
                                                            ; W = v_mstr2
                               movwf    v_mstr2+6           ;  0 OV rS rS [?L ?L] 0b78 00ba
                               movlw    58                  ;  0 OV rS rS [?L ?L] 0b79 303a
                                                            ; W = v_mstr2
                               movwf    v_mstr2+7           ;  0 OV rS rS [?L ?L] 0b7a 00bb
                               movlw    32                  ;  0 OV rS rS [?L ?L] 0b7b 3020
                                                            ; W = v_mstr2
                               movwf    v_mstr2+8           ;  0 OV rS rS [?L ?L] 0b7c 00bc
;  178             print_string(serial_hw_data, mstr2)
                               movlw    l__serial_hw_data_put;  0 OV rS rS [?L ?L] 0b7d 3086
                                                            ; W = v_mstr2
                               datalo_clr v____device_put_1 ;  0 OV rS rs [?L ?L] 0b7e 1283
                               datahi_set v____device_put_1 ;  0 OV rs Rs [?L ?L] 0b7f 1703
                               movwf    v____device_put_1   ;  0 OV Rs Rs [?L ?L] 0b80 00b6
                               movlw    HIGH l__serial_hw_data_put;  0 OV Rs Rs [?L ?L] 0b81 3003
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  0 OV Rs Rs [?L ?L] 0b82 00b7
                               movlw    9                   ;  0 OV Rs Rs [?L ?L] 0b83 3009
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  0 OV Rs Rs [?L ?L] 0b84 00ba
                               clrf     v__str_count+1      ;  0 OV Rs Rs [?L ?L] 0b85 01bb
                                                            ; W = v__str_count
                               movlw    180                 ;  0 OV Rs Rs [?L ?L] 0b86 30b4
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV Rs Rs [?L ?L] 0b87 00c0
                               clrf     v___str_1+1         ;  0 OV Rs Rs [?L ?L] 0b88 01c1
                                                            ; W = v___str_1
                               branchlo_clr l_print_string  ;  0 OV Rs Rs [?L ?l] 0b89 118a
                                                            ; W = v___str_1
                               call     l_print_string      ;  0 OV Rs ?? [?l ??] 0b8a 2124
                                                            ; W = v___str_1
;  179 		      print_byte_hex(serial_hw_data, PcfData)
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0b8b 3086
                               datalo_clr v____device_put_12;  0 OV ?? ?s [?? ??] 0b8c 1283
                               datahi_set v____device_put_12;  0 OV ?s Rs [?? ??] 0b8d 1703
                               movwf    v____device_put_12  ;  0 OV Rs Rs [?? ??] 0b8e 00b2
                               movlw    HIGH l__serial_hw_data_put;  0 OV Rs Rs [?? ??] 0b8f 3003
                                                            ; W = v____device_put_12
                               movwf    v____device_put_12+1;  0 OV Rs Rs [?? ??] 0b90 00b3
                               movlw    0                   ;  0 OV Rs Rs [?? ??] 0b91 3000
                                                            ; W = v____device_put_12
                               branchlo_clr l_print_byte_hex;  0 OV Rs Rs [?? ?l] 0b92 118a
                               call     l_print_byte_hex    ;  0 OV Rs ?? [?l ??] 0b93 21e1
;  180 		      print_CrLf(serial_hw_data)
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0b94 3086
                               datalo_clr v__device_put     ;  0 OV ?? ?s [?? ??] 0b95 1283
                               datahi_set v__device_put     ;  0 OV ?s Rs [?? ??] 0b96 1703
                               movwf    v__device_put       ;  0 OV Rs Rs [?? ??] 0b97 00b2
                               movlw    HIGH l__serial_hw_data_put;  0 OV Rs Rs [?? ??] 0b98 3003
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  0 OV Rs Rs [?? ??] 0b99 00b3
                               branchlo_clr l_print_crlf    ;  0 OV Rs Rs [?? ?l] 0b9a 118a
                                                            ; W = v__device_put
                               call     l_print_crlf        ;  0 OV Rs ?? [?l ??] 0b9b 210e
                                                            ; W = v__device_put
;  182             PrevPcfData = PcfData
                               datalo_clr v_prevpcfdata     ;  0 OV ?? ?s [?? ??] 0b9c 1283
                               datahi_clr v_prevpcfdata     ;  0 OV ?s rs [?? ??] 0b9d 1303
                               clrf     v_prevpcfdata       ;  0 OV rs rs [?? ??] 0b9e 01e2
;  183          end if
l__l997
;  188          MotorL = 0
                               clrf     v_motorl            ;  0 OV rs rs [?? ??] 0b9f 01d3
;  189          MotorR = 0
                               clrf     v_motorr            ;  0 OV rs rs [?? ??] 0ba0 01d4
;  190          RequestControl = 0
                               clrf     v_requestcontrol    ;  0 OV rs rs [?? ??] 0ba1 01d5
;  201 if (RequestControl < 8) then
                               movlw    8                   ;  0 OV rs rs [?? ??] 0ba2 3008
                               subwf    v_requestcontrol,w  ;  0 OV rs rs [?? ??] 0ba3 0255
                               branchlo_set l__l999         ;  0 OV rs rs [?? ?L] 0ba4 158a
                               btfsc    v__status, v__z     ;  0 OV rs rs [?L ?L] 0ba5 1903
                               goto     l__l999             ;  0 OV rs rs [?L ?L] 0ba6 2bac
                               branchlo_nop l__l999         ;  0 OV rs rs [?L ?L] 0ba7
                               btfsc    v__status, v__c     ;  0 OV rs rs [?L ?L] 0ba7 1803
                               goto     l__l999             ;  0 OV rs rs [?L ?L] 0ba8 2bac
;  202          BehaveAvoid(9)
                               movlw    9                   ;  0 OV rs rs [?L ?L] 0ba9 3009
                               branchlo_clr l_behaveavoid   ;  0 OV rs rs [?L ?l] 0baa 118a
                               call     l_behaveavoid       ;  0 OV rs ?? [?l ??] 0bab 273f
;  203 end if
l__l999
;  204          BehaveWaitStart(15)
                               movlw    15                  ;  0 OV ?? ?? [?? ??] 0bac 300f
                               branchlo_clr l_behavewaitstart;  0 OV ?? ?? [?? ?l] 0bad 118a
                               call     l_behavewaitstart   ;  0 OV ?? ?? [?l ??] 0bae 27b5
;  207          if (PrevWinner != RequestControl) then
                               datalo_clr v_prevwinner      ;  0 OV ?? ?s [?? ??] 0baf 1283
                               datahi_clr v_prevwinner      ;  0 OV ?s rs [?? ??] 0bb0 1303
                               movf     v_prevwinner,w      ;  0 OV rs rs [?? ??] 0bb1 0856
                               subwf    v_requestcontrol,w  ;  0 OV rs rs [?? ??] 0bb2 0255
                                                            ; W = v_prevwinner
                               branchlo_set l__l1001        ;  0 OV rs rs [?? ?L] 0bb3 158a
                               btfsc    v__status, v__z     ;  0 OV rs rs [?L ?L] 0bb4 1903
                               goto     l__l1001            ;  0 OV rs rs [?L ?L] 0bb5 2be7
;  208             var byte mstr1[] = "Winner: "
                               movlw    87                  ;  0 OV rs rs [?L ?L] 0bb6 3057
                               datalo_set v_mstr1           ;  0 OV rs rS [?L ?L] 0bb7 1683
                               movwf    v_mstr1             ;  0 OV rS rS [?L ?L] 0bb8 00b4
                               movlw    105                 ;  0 OV rS rS [?L ?L] 0bb9 3069
                                                            ; W = v_mstr1
                               movwf    v_mstr1+1           ;  0 OV rS rS [?L ?L] 0bba 00b5
                               movlw    110                 ;  0 OV rS rS [?L ?L] 0bbb 306e
                                                            ; W = v_mstr1
                               movwf    v_mstr1+2           ;  0 OV rS rS [?L ?L] 0bbc 00b6
                               movlw    110                 ;  0 OV rS rS [?L ?L] 0bbd 306e
                                                            ; W = v_mstr1
                               movwf    v_mstr1+3           ;  0 OV rS rS [?L ?L] 0bbe 00b7
                               movlw    101                 ;  0 OV rS rS [?L ?L] 0bbf 3065
                                                            ; W = v_mstr1
                               movwf    v_mstr1+4           ;  0 OV rS rS [?L ?L] 0bc0 00b8
                               movlw    114                 ;  0 OV rS rS [?L ?L] 0bc1 3072
                                                            ; W = v_mstr1
                               movwf    v_mstr1+5           ;  0 OV rS rS [?L ?L] 0bc2 00b9
                               movlw    58                  ;  0 OV rS rS [?L ?L] 0bc3 303a
                                                            ; W = v_mstr1
                               movwf    v_mstr1+6           ;  0 OV rS rS [?L ?L] 0bc4 00ba
                               movlw    32                  ;  0 OV rS rS [?L ?L] 0bc5 3020
                                                            ; W = v_mstr1
                               movwf    v_mstr1+7           ;  0 OV rS rS [?L ?L] 0bc6 00bb
;  209             Print_String(serial_hw_data, mstr1)
                               movlw    l__serial_hw_data_put;  0 OV rS rS [?L ?L] 0bc7 3086
                                                            ; W = v_mstr1
                               datalo_clr v____device_put_1 ;  0 OV rS rs [?L ?L] 0bc8 1283
                               datahi_set v____device_put_1 ;  0 OV rs Rs [?L ?L] 0bc9 1703
                               movwf    v____device_put_1   ;  0 OV Rs Rs [?L ?L] 0bca 00b6
                               movlw    HIGH l__serial_hw_data_put;  0 OV Rs Rs [?L ?L] 0bcb 3003
                                                            ; W = v____device_put_1
                               movwf    v____device_put_1+1 ;  0 OV Rs Rs [?L ?L] 0bcc 00b7
                               movlw    8                   ;  0 OV Rs Rs [?L ?L] 0bcd 3008
                                                            ; W = v____device_put_1
                               movwf    v__str_count        ;  0 OV Rs Rs [?L ?L] 0bce 00ba
                               clrf     v__str_count+1      ;  0 OV Rs Rs [?L ?L] 0bcf 01bb
                                                            ; W = v__str_count
                               movlw    180                 ;  0 OV Rs Rs [?L ?L] 0bd0 30b4
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV Rs Rs [?L ?L] 0bd1 00c0
                               clrf     v___str_1+1         ;  0 OV Rs Rs [?L ?L] 0bd2 01c1
                                                            ; W = v___str_1
                               branchlo_clr l_print_string  ;  0 OV Rs Rs [?L ?l] 0bd3 118a
                                                            ; W = v___str_1
                               call     l_print_string      ;  0 OV Rs ?? [?l ??] 0bd4 2124
                                                            ; W = v___str_1
;  210 		      Print_Byte_Dec(serial_hw_data, RequestControl)
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0bd5 3086
                               datalo_clr v____device_put_19;  0 OV ?? ?s [?? ??] 0bd6 1283
                               datahi_set v____device_put_19;  0 OV ?s Rs [?? ??] 0bd7 1703
                               movwf    v____device_put_19  ;  0 OV Rs Rs [?? ??] 0bd8 00b0
                               movlw    HIGH l__serial_hw_data_put;  0 OV Rs Rs [?? ??] 0bd9 3003
                                                            ; W = v____device_put_19
                               movwf    v____device_put_19+1;  0 OV Rs Rs [?? ??] 0bda 00b1
                               datahi_clr v_requestcontrol  ;  0 OV Rs rs [?? ??] 0bdb 1303
                                                            ; W = v____device_put_19
                               movf     v_requestcontrol,w  ;  0 OV rs rs [?? ??] 0bdc 0855
                                                            ; W = v____device_put_19
                               branchlo_clr l_print_byte_dec;  0 OV rs rs [?? ?l] 0bdd 118a
                                                            ; W = v_requestcontrol
                               call     l_print_byte_dec    ;  0 OV rs ?? [?l ??] 0bde 2250
                                                            ; W = v_requestcontrol
;  211 		      Print_CrLf(serial_hw_data)
                               movlw    l__serial_hw_data_put;  0 OV ?? ?? [?? ??] 0bdf 3086
                               datalo_clr v__device_put     ;  0 OV ?? ?s [?? ??] 0be0 1283
                               datahi_set v__device_put     ;  0 OV ?s Rs [?? ??] 0be1 1703
                               movwf    v__device_put       ;  0 OV Rs Rs [?? ??] 0be2 00b2
                               movlw    HIGH l__serial_hw_data_put;  0 OV Rs Rs [?? ??] 0be3 3003
                                                            ; W = v__device_put
                               movwf    v__device_put+1     ;  0 OV Rs Rs [?? ??] 0be4 00b3
                               branchlo_clr l_print_crlf    ;  0 OV Rs Rs [?? ?l] 0be5 118a
                                                            ; W = v__device_put
                               call     l_print_crlf        ;  0 OV Rs ?? [?l ??] 0be6 210e
                                                            ; W = v__device_put
;  213          end if
l__l1001
;  214          PrevWinner = RequestControl;
                               datalo_clr v_requestcontrol  ;  0 OV ?? ?s [?? ??] 0be7 1283
                               datahi_clr v_requestcontrol  ;  0 OV ?s rs [?? ??] 0be8 1303
                               movf     v_requestcontrol,w  ;  0 OV rs rs [?? ??] 0be9 0855
                               movwf    v_prevwinner        ;  0 OV rs rs [?? ??] 0bea 00d6
                                                            ; W = v_requestcontrol
;  221          ccp1con = 0x0c       -- set pwm mode (b4:5 = 2 lsb pwm)
                               movlw    12                  ;  0 OV rs rs [?? ??] 0beb 300c
                                                            ; W = v_prevwinner
                               movwf    v_ccp1con           ;  0 OV rs rs [?? ??] 0bec 0097
;  222          if (MotorL >= 0) then
                               movf     v_motorl,w          ;  0 OV rs rs [?? ??] 0bed 0853
                               xorlw    128                 ;  0 OV rs rs [?? ??] 0bee 3a80
                                                            ; W = v_motorl
                               movwf    v__pic_temp         ;  0 OV rs rs [?? ??] 0bef 00a0
                               movlw    128                 ;  0 OV rs rs [?? ??] 0bf0 3080
                                                            ; W = v__pic_temp
                               subwf    v__pic_temp,w       ;  0 OV rs rs [?? ??] 0bf1 0220
                               branchlo_set l__l1229        ;  0 OV rs rs [?? ?L] 0bf2 158a
                               btfsc    v__status, v__z     ;  0 OV rs rs [?L ?L] 0bf3 1903
                               goto     l__l1229            ;  0 OV rs rs [?L ?L] 0bf4 2bf7
                               branchlo_nop l__l1003        ;  0 OV rs rs [?L ?L] 0bf5
                               btfss    v__status, v__c     ;  0 OV rs rs [?L ?L] 0bf5 1c03
                               goto     l__l1003            ;  0 OV rs rs [?L ?L] 0bf6 2bfe
l__l1229
;  223             ccpr2l = 2 * byte(MotorL)   -- set pwm power
                               bcf      v__status, v__c     ;  0 OV rs rs [?L ?L] 0bf7 1003
                               rlf      v_motorl,w          ;  0 OV rs rs [?L ?L] 0bf8 0d53
                               movwf    v_ccpr2l            ;  0 OV rs rs [?L ?L] 0bf9 009b
;  224             Bridge_3 = false
                               bcf      v__portb_shadow, 2 ; x104;  0 OV rs rs [?L ?L] 0bfa 1143
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?L ?L] 0bfb 0843
                               movwf    v_portb             ;  0 OV rs rs [?L ?L] 0bfc 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  224             Bridge_3 = false
; 16f876a.jal
;  271    _PORTB_flush()
; rikishi2.jal
;  224             Bridge_3 = false
;  225          else 
                               branchlo_nop l__l1002        ;  0 OV rs rs [?L ?L] 0bfd
                               goto     l__l1002            ;  0 OV rs rs [?L ?L] 0bfd 2c07
l__l1003
;  226             ccpr2l = 2 * byte(-MotorL)   -- set pwm power
                               comf     v_motorl,w          ;  0 OV rs rs [?L ?L] 0bfe 0953
                               addlw    1                   ;  0 OV rs rs [?L ?L] 0bff 3e01
                               movwf    v____temp_69        ;  0 OV rs rs [?L ?L] 0c00 00e3
                               bcf      v__status, v__c     ;  0 OV rs rs [?L ?L] 0c01 1003
                                                            ; W = v____temp_69
                               rlf      v____temp_69,w      ;  0 OV rs rs [?L ?L] 0c02 0d63
                                                            ; W = v____temp_69
                               movwf    v_ccpr2l            ;  0 OV rs rs [?L ?L] 0c03 009b
;  227             Bridge_3 = true
                               bsf      v__portb_shadow, 2 ; x105;  0 OV rs rs [?L ?L] 0c04 1543
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?L ?L] 0c05 0843
                               movwf    v_portb             ;  0 OV rs rs [?L ?L] 0c06 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  227             Bridge_3 = true
; 16f876a.jal
;  271    _PORTB_flush()
; rikishi2.jal
;  227             Bridge_3 = true
;  228          end if
l__l1002
;  229          Bridge_4 = ! Bridge_3
                               branchlo_nop l__l1231        ;  0 OV rs rs [?L ?L] 0c07
                               btfss    v_portb, 2 ; pin_b2       ;  0 OV rs rs [?L ?L] 0c07 1d06
                               goto     l__l1231            ;  0 OV rs rs [?L ?L] 0c08 2c0b
                               bcf      v__bitbucket+1, 4 ; _btemp159;  0 OV rs rs [?L ?L] 0c09 1266
                               branchlo_nop l__l1230        ;  0 OV rs rs [?L ?L] 0c0a
                               goto     l__l1230            ;  0 OV rs rs [?L ?L] 0c0a 2c0c
l__l1231
                               bsf      v__bitbucket+1, 4 ; _btemp159;  0 OV rs rs [?L ?L] 0c0b 1666
l__l1230
                               bcf      v__portb_shadow, 1 ; x106;  0 OV rs rs [?L ?L] 0c0c 10c3
                               btfsc    v__bitbucket+1, 4 ; _btemp159;  0 OV rs rs [?L ?L] 0c0d 1a66
                               bsf      v__portb_shadow, 1 ; x106;  0 OV rs rs [?L ?L] 0c0e 14c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?L ?L] 0c0f 0843
                               movwf    v_portb             ;  0 OV rs rs [?L ?L] 0c10 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  229          Bridge_4 = ! Bridge_3
; 16f876a.jal
;  279    _PORTB_flush()
; rikishi2.jal
;  229          Bridge_4 = ! Bridge_3
;  231          ccp2con = 0x0c       -- set pwm mode (b4:5 = 2 lsb pwm)
                               movlw    12                  ;  0 OV rs rs [?L ?L] 0c11 300c
                               movwf    v_ccp2con           ;  0 OV rs rs [?L ?L] 0c12 009d
;  232          if (MotorR >= 0) then
                               movf     v_motorr,w          ;  0 OV rs rs [?L ?L] 0c13 0854
                               xorlw    128                 ;  0 OV rs rs [?L ?L] 0c14 3a80
                                                            ; W = v_motorr
                               movwf    v__pic_temp         ;  0 OV rs rs [?L ?L] 0c15 00a0
                               movlw    128                 ;  0 OV rs rs [?L ?L] 0c16 3080
                                                            ; W = v__pic_temp
                               subwf    v__pic_temp,w       ;  0 OV rs rs [?L ?L] 0c17 0220
                               branchlo_nop l__l1233        ;  0 OV rs rs [?L ?L] 0c18
                               btfsc    v__status, v__z     ;  0 OV rs rs [?L ?L] 0c18 1903
                               goto     l__l1233            ;  0 OV rs rs [?L ?L] 0c19 2c1c
                               branchlo_nop l__l1011        ;  0 OV rs rs [?L ?L] 0c1a
                               btfss    v__status, v__c     ;  0 OV rs rs [?L ?L] 0c1a 1c03
                               goto     l__l1011            ;  0 OV rs rs [?L ?L] 0c1b 2c23
l__l1233
;  233             ccpr1l = 2 * byte(MotorR)   -- set pwm power
                               bcf      v__status, v__c     ;  0 OV rs rs [?L ?L] 0c1c 1003
                               rlf      v_motorr,w          ;  0 OV rs rs [?L ?L] 0c1d 0d54
                               movwf    v_ccpr1l            ;  0 OV rs rs [?L ?L] 0c1e 0095
;  234             Bridge_1 = false
                               bcf      v__portb_shadow, 5 ; x107;  0 OV rs rs [?L ?L] 0c1f 12c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?L ?L] 0c20 0843
                               movwf    v_portb             ;  0 OV rs rs [?L ?L] 0c21 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  234             Bridge_1 = false
; 16f876a.jal
;  246    _PORTB_flush()
; rikishi2.jal
;  234             Bridge_1 = false
;  235          else 
                               branchlo_nop l__l1010        ;  0 OV rs rs [?L ?L] 0c22
                               goto     l__l1010            ;  0 OV rs rs [?L ?L] 0c22 2c2c
l__l1011
;  236             ccpr1l = 2 * byte(-MotorR)   -- set pwm power
                               comf     v_motorr,w          ;  0 OV rs rs [?L ?L] 0c23 0954
                               addlw    1                   ;  0 OV rs rs [?L ?L] 0c24 3e01
                               movwf    v____temp_69        ;  0 OV rs rs [?L ?L] 0c25 00e3
                               bcf      v__status, v__c     ;  0 OV rs rs [?L ?L] 0c26 1003
                                                            ; W = v____temp_69
                               rlf      v____temp_69,w      ;  0 OV rs rs [?L ?L] 0c27 0d63
                                                            ; W = v____temp_69
                               movwf    v_ccpr1l            ;  0 OV rs rs [?L ?L] 0c28 0095
;  237             Bridge_1 = true
                               bsf      v__portb_shadow, 5 ; x108;  0 OV rs rs [?L ?L] 0c29 16c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?L ?L] 0c2a 0843
                               movwf    v_portb             ;  0 OV rs rs [?L ?L] 0c2b 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  237             Bridge_1 = true
; 16f876a.jal
;  246    _PORTB_flush()
; rikishi2.jal
;  237             Bridge_1 = true
;  238          end if
l__l1010
;  239          Bridge_2 = ! Bridge_1
                               branchlo_nop l__l1235        ;  0 OV rs rs [?L ?L] 0c2c
                               btfss    v_portb, 5 ; pin_b5       ;  0 OV rs rs [?L ?L] 0c2c 1e86
                               goto     l__l1235            ;  0 OV rs rs [?L ?L] 0c2d 2c30
                               bcf      v__bitbucket+1, 6 ; _btemp161;  0 OV rs rs [?L ?L] 0c2e 1366
                               branchlo_nop l__l1234        ;  0 OV rs rs [?L ?L] 0c2f
                               goto     l__l1234            ;  0 OV rs rs [?L ?L] 0c2f 2c31
l__l1235
                               bsf      v__bitbucket+1, 6 ; _btemp161;  0 OV rs rs [?L ?L] 0c30 1766
l__l1234
                               bcf      v__portb_shadow, 4 ; x109;  0 OV rs rs [?L ?L] 0c31 1243
                               btfsc    v__bitbucket+1, 6 ; _btemp161;  0 OV rs rs [?L ?L] 0c32 1b66
                               bsf      v__portb_shadow, 4 ; x109;  0 OV rs rs [?L ?L] 0c33 1643
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?L ?L] 0c34 0843
                               movwf    v_portb             ;  0 OV rs rs [?L ?L] 0c35 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  239          Bridge_2 = ! Bridge_1
; 16f876a.jal
;  254    _PORTB_flush()
; rikishi2.jal
;  239          Bridge_2 = ! Bridge_1
;  243          if (check_delay(0) ) then
                               movlw    0                   ;  0 OV rs rs [?L ?L] 0c36 3000
                               branchlo_clr l_check_delay   ;  0 OV rs rs [?L ?l] 0c37 118a
                               call     l_check_delay       ;  0 OV rs ?? [?l ??] 0c38 252f
                               datalo_clr v__bitbucket+1 ; _btemp162 ;  0 OV ?? ?s [?? ??] 0c39 1283
                               datahi_clr v__bitbucket+1 ; _btemp162 ;  0 OV ?s rs [?? ??] 0c3a 1303
                               bcf      v__bitbucket+1, 7 ; _btemp162;  0 OV rs rs [?? ??] 0c3b 13e6
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 0c3c 1820
                               bsf      v__bitbucket+1, 7 ; _btemp162;  0 OV rs rs [?? ??] 0c3d 17e6
                               branchlo_set l__l1019        ;  0 OV rs rs [?? ?L] 0c3e 158a
                               btfss    v__bitbucket+1, 7 ; _btemp162;  0 OV rs rs [?L ?L] 0c3f 1fe6
                               goto     l__l1019            ;  0 OV rs rs [?L ?L] 0c40 2c5b
;  245             set_delay(0, 100)
                               movlw    100                 ;  0 OV rs rs [?L ?L] 0c41 3064
                               datalo_set v___ticks_1       ;  0 OV rs rS [?L ?L] 0c42 1683
                               movwf    v___ticks_1         ;  0 OV rS rS [?L ?L] 0c43 00d7
                               clrf     v___ticks_1+1       ;  0 OV rS rS [?L ?L] 0c44 01d8
                                                            ; W = v___ticks_1
                               movlw    0                   ;  0 OV rS rS [?L ?L] 0c45 3000
                                                            ; W = v___ticks_1
                               branchlo_clr l_set_delay     ;  0 OV rS rS [?L ?l] 0c46 118a
                               call     l_set_delay         ;  0 OV rS ?? [?l ??] 0c47 2518
;  248             if (PrevWinner != 15) then
                               movlw    15                  ;  0 OV ?? ?? [?? ??] 0c48 300f
                               datalo_clr v_prevwinner      ;  0 OV ?? ?s [?? ??] 0c49 1283
                               datahi_clr v_prevwinner      ;  0 OV ?s rs [?? ??] 0c4a 1303
                               subwf    v_prevwinner,w      ;  0 OV rs rs [?? ??] 0c4b 0256
                               branchlo_set l__l1021        ;  0 OV rs rs [?? ?L] 0c4c 158a
                               btfsc    v__status, v__z     ;  0 OV rs rs [?L ?L] 0c4d 1903
                               goto     l__l1021            ;  0 OV rs rs [?L ?L] 0c4e 2c59
;  249                LedYellow = ! LedYellow
                               branchlo_nop l__l1237        ;  0 OV rs rs [?L ?L] 0c4f
                               btfss    v_portb, 7 ; pin_b7       ;  0 OV rs rs [?L ?L] 0c4f 1f86
                               goto     l__l1237            ;  0 OV rs rs [?L ?L] 0c50 2c53
                               bcf      v__bitbucket+2, 1 ; _btemp164;  0 OV rs rs [?L ?L] 0c51 10e7
                               branchlo_nop l__l1236        ;  0 OV rs rs [?L ?L] 0c52
                               goto     l__l1236            ;  0 OV rs rs [?L ?L] 0c52 2c54
l__l1237
                               bsf      v__bitbucket+2, 1 ; _btemp164;  0 OV rs rs [?L ?L] 0c53 14e7
l__l1236
                               bcf      v__portb_shadow, 7 ; x110;  0 OV rs rs [?L ?L] 0c54 13c3
                               btfsc    v__bitbucket+2, 1 ; _btemp164;  0 OV rs rs [?L ?L] 0c55 18e7
                               bsf      v__portb_shadow, 7 ; x110;  0 OV rs rs [?L ?L] 0c56 17c3
; 16f876a.jal
;  195    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?L ?L] 0c57 0843
                               movwf    v_portb             ;  0 OV rs rs [?L ?L] 0c58 0086
                                                            ; W = v__portb_shadow
; rikishi2.jal
;  249                LedYellow = ! LedYellow
; 16f876a.jal
;  229    _PORTB_flush()
; rikishi2.jal
;  249                LedYellow = ! LedYellow
;  250             end if
l__l1021
;  252             BatteryCheck()
                               branchlo_clr l_batterycheck  ;  0 OV rs rs [?L ?l] 0c59 118a
                               call     l_batterycheck      ;  0 OV rs ?? [?l ??] 0c5a 26b6
;  253          end if
l__l1019
;  255         console()
                               branchlo_set l_console       ;  0 OV ?? ?? [?? ?L] 0c5b 158a
                               call     l_console           ;  0 OV ?? ?? [?L ??] 0c5c 2149
;  257       end if
;  258    end loop
                               branchlo_set l__l992         ;  0 OV ?? ?? [?? ?L] 0c5d 158a
                               goto     l__l992             ;  0 OV ?? ?? [?L ?L] 0c5e 2b46
                               end
; --- procedures & call stack
;{root} ----- -U- (frame_sz=69 blocks=50)
;   {block enter}
;     --- records ---
;     --- variables ---
;     460cd8:_jal_version  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 2004
;     460dc8:_jal_build  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 20100602
;     4614b8:_device_id word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 3584
;     461c08:_pictype  (type=a dflags=C---- sz=7 use=0 assigned=0)
;      = 49,54,70,56,55,54,65
;     4619c8:_datasheet  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 51,57,53,56,50
;     461ab8:_pgmspec  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 51,57,53,56,57
;     461608:_pic_12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1
;     4616f8:_pic_14  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2
;     4617e8:_pic_16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 3
;     4618d8:_sx_12  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 4
;     462778:_pic_14h  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 5
;     4628e8:_pjal bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     462a58:_w byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     462bc8:_f byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     462d38:_true bit (type=B dflags=C--B- sz=1 use=29 assigned=0 bit=0)
;      = 1
;     462ea8:_false bit (type=B dflags=C--B- sz=1 use=32 assigned=0 bit=0)
;      = 0
;     4613b8:_high bit (type=B dflags=C--B- sz=1 use=5 assigned=0 bit=0)
;      = 1
;     463108:_low bit (type=B dflags=C--B- sz=1 use=4 assigned=0 bit=0)
;      = 0
;     463238:_on bit (type=B dflags=C--B- sz=1 use=5 assigned=0 bit=0)
;      = 1
;     463368:_off bit (type=B dflags=C--B- sz=1 use=4 assigned=0 bit=0)
;      = 0
;     463498:_enabled bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     4635c8:_disabled bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     4636f8:_input bit (type=B dflags=C--B- sz=1 use=8 assigned=0 bit=0)
;      = 1
;     463828:_output bit (type=B dflags=C--B- sz=1 use=13 assigned=0 bit=0)
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
;     467108:_pic_16f1824  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320768
;     467248:_pic_16f1826  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320832
;     467388:_pic_16f1827  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320864
;     4674c8:_pic_16f1828  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320896
;     467608:_pic_16f1933  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319680
;     467748:_pic_16f1934  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319744
;     467888:_pic_16f1936  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319776
;     4679c8:_pic_16f1937  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319808
;     467b08:_pic_16f1938  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319840
;     467c48:_pic_16f1939  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319872
;     467d88:_pic_16f1946  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320192
;     467ec8:_pic_16f1947  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320224
;     468108:_pic_16f505  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242373
;     468248:_pic_16f506  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242374
;     468388:_pic_16f526  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1242406
;     4684c8:_pic_16f610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319520
;     468608:_pic_16f616  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315392
;     468748:_pic_16f627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312672
;     468888:_pic_16f627a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314880
;     4689c8:_pic_16f628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312704
;     468b08:_pic_16f628a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314912
;     468c48:_pic_16f630  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315008
;     468d88:_pic_16f631  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315872
;     468ec8:_pic_16f636  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314976
;     469108:_pic_16f639  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 21039626
;     469248:_pic_16f648a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315072
;     469388:_pic_16f676  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315040
;     4694c8:_pic_16f677  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315904
;     469608:_pic_16f684  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314944
;     469748:_pic_16f685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311904
;     469888:_pic_16f687  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315616
;     4699c8:_pic_16f688  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315200
;     469b08:_pic_16f689  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315648
;     469c48:_pic_16f690  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315840
;     469d88:_pic_16f707  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317568
;     469ec8:_pic_16f716  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315136
;     46a108:_pic_16f72  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1310880
;     46a248:_pic_16f722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316992
;     46a388:_pic_16f722a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317664
;     46a4c8:_pic_16f723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316960
;     46a608:_pic_16f723a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317632
;     46a748:_pic_16f724  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316928
;     46a888:_pic_16f726  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316896
;     46a9c8:_pic_16f727  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1316864
;     46ab08:_pic_16f73  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312256
;     46ac48:_pic_16f737  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313696
;     46ad88:_pic_16f74  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312288
;     46aec8:_pic_16f747  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313760
;     46b108:_pic_16f76  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312320
;     46b248:_pic_16f767  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314464
;     46b388:_pic_16f77  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312352
;     46b4c8:_pic_16f777  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314272
;     46b608:_pic_16f785  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315328
;     46b748:_pic_16f818  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311936
;     46b888:_pic_16f819  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1311968
;     46b9c8:_pic_16f83  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1376131
;     46bb08:_pic_16f84  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1376132
;     46bc48:_pic_16f84a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312096
;     46bd88:_pic_16f87  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312544
;     46bec8:_pic_16f870  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314048
;     46c108:_pic_16f871  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314080
;     46c248:_pic_16f872  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312992
;     46c388:_pic_16f873  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313120
;     46c4c8:_pic_16f873a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314368
;     46c608:_pic_16f874  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313056
;     46c748:_pic_16f874a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314400
;     46c888:_pic_16f876  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313248
;     46c9c8:_pic_16f876a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314304
;     46cb08:_pic_16f877  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1313184
;     46cc48:_pic_16f877a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314336
;     46cd88:_pic_16f88  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1312608
;     46cec8:_pic_16f882  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318912
;     46d108:_pic_16f883  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318944
;     46d248:_pic_16f884  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1318976
;     46d388:_pic_16f886  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319008
;     46d4c8:_pic_16f887  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319040
;     46d608:_pic_16f913  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315808
;     46d748:_pic_16f914  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315776
;     46d888:_pic_16f916  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315744
;     46d9c8:_pic_16f917  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315712
;     46db08:_pic_16f946  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315936
;     46dc48:_pic_16hv610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319584
;     46dd88:_pic_16hv616  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315424
;     46dec8:_pic_16hv785  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1315360
;     46e108:_pic_16lf1823  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320992
;     46e248:_pic_16lf1824  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1321024
;     46e388:_pic_16lf1826  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1321088
;     46e4c8:_pic_16lf1827  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1321120
;     46e608:_pic_16lf1828  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1321152
;     46e748:_pic_16lf1933  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1319936
;     46e888:_pic_16lf1934  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320000
;     46e9c8:_pic_16lf1936  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320032
;     46eb08:_pic_16lf1937  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320064
;     46ec48:_pic_16lf1938  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320096
;     46ed88:_pic_16lf1939  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320128
;     46eec8:_pic_16lf1946  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320320
;     46f108:_pic_16lf1947  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1320352
;     46f248:_pic_16lf707  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317600
;     46f388:_pic_16lf722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317248
;     46f4c8:_pic_16lf722a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317728
;     46f608:_pic_16lf723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317216
;     46f748:_pic_16lf723a  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317696
;     46f888:_pic_16lf724  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317184
;     46f9c8:_pic_16lf726  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317152
;     46fb08:_pic_16lf727  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1317120
;     46fc48:_pic_18f1220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443808
;     46fd88:_pic_18f1230  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449472
;     46fec8:_pic_18f1320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443776
;     461308:_pic_18f1330  (type=i dflags=C---U sz=4 use=0 assigned=0)
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
;      = 23087114
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
;      = 23085066
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
;     474388:_pic_18f26j13  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464608
;     4744c8:_pic_18f26j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461312
;     474608:_pic_18f26j53  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464352
;     474748:_pic_18f26k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450016
;     474888:_pic_18f26k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463360
;     4749c8:_pic_18f27j13  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464672
;     474b08:_pic_18f27j53  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464416
;     474c48:_pic_18f4220  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443232
;     474d88:_pic_18f4221  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450304
;     474ec8:_pic_18f4320  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443104
;     475108:_pic_18f4321  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450240
;     475248:_pic_18f4331  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444000
;     475388:_pic_18f43k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450176
;     4754c8:_pic_18f43k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464064
;     475608:_pic_18f4410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446112
;     475748:_pic_18f442  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442976
;     475888:_pic_18f4420  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446080
;     4759c8:_pic_18f4423  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446096
;     475b08:_pic_18f4431  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443968
;     475c48:_pic_18f4439  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 23087626
;     475d88:_pic_18f4450  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451008
;     475ec8:_pic_18f4455  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446432
;     476108:_pic_18f4458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452576
;     476248:_pic_18f448  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443872
;     476388:_pic_18f4480  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448608
;     4764c8:_pic_18f44j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449248
;     476608:_pic_18f44j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461728
;     476748:_pic_18f44j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461344
;     476888:_pic_18f44k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450112
;     4769c8:_pic_18f44k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463808
;     476b08:_pic_18f4510  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446048
;     476c48:_pic_18f4515  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444960
;     476d88:_pic_18f452  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1442848
;     476ec8:_pic_18f4520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446016
;     477108:_pic_18f4523  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446032
;     477248:_pic_18f4525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444928
;     477388:_pic_18f4539  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 23085578
;     4774c8:_pic_18f4550  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446400
;     477608:_pic_18f4553  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1452544
;     477748:_pic_18f458  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443936
;     477888:_pic_18f4580  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448576
;     4779c8:_pic_18f4585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445536
;     477b08:_pic_18f45j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448992
;     477c48:_pic_18f45j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461760
;     477d88:_pic_18f45j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461376
;     477ec8:_pic_18f45k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1450048
;     478108:_pic_18f45k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463552
;     478248:_pic_18f4610  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444896
;     478388:_pic_18f4620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444864
;     4784c8:_pic_18f4680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445504
;     478608:_pic_18f4682  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451840
;     478748:_pic_18f4685  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1451872
;     478888:_pic_18f46j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461792
;     4789c8:_pic_18f46j13  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464736
;     478b08:_pic_18f46j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461408
;     478c48:_pic_18f46j53  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464480
;     478d88:_pic_18f46k20  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449984
;     478ec8:_pic_18f46k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463296
;     479108:_pic_18f47j13  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464800
;     479248:_pic_18f47j53  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464544
;     479388:_pic_18f6310  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444832
;     4794c8:_pic_18f6390  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444768
;     479608:_pic_18f6393  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448448
;     479748:_pic_18f63j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456384
;     479888:_pic_18f63j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456128
;     4799c8:_pic_18f6410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443552
;     479b08:_pic_18f6490  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443488
;     479c48:_pic_18f6493  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445376
;     479d88:_pic_18f64j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456416
;     479ec8:_pic_18f64j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456160
;     47a108:_pic_18f6520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444640
;     47a248:_pic_18f6525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444576
;     47a388:_pic_18f6527  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446720
;     47a4c8:_pic_18f6585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444448
;     47a608:_pic_18f65j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447200
;     47a748:_pic_18f65j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456480
;     47a888:_pic_18f65j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447232
;     47a9c8:_pic_18f65j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458432
;     47ab08:_pic_18f65j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456224
;     47ac48:_pic_18f65k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463040
;     47ad88:_pic_18f65k90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462848
;     47aec8:_pic_18f6620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443424
;     47b108:_pic_18f6621  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444512
;     47b248:_pic_18f6622  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446784
;     47b388:_pic_18f6627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446848
;     47b4c8:_pic_18f6628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460672
;     47b608:_pic_18f6680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444384
;     47b748:_pic_18f66j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447264
;     47b888:_pic_18f66j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459264
;     47b9c8:_pic_18f66j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447296
;     47bb08:_pic_18f66j16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459296
;     47bc48:_pic_18f66j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458496
;     47bd88:_pic_18f66j55  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458528
;     47bec8:_pic_18f66j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447936
;     47c108:_pic_18f66j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449728
;     47c248:_pic_18f66j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462272
;     47c388:_pic_18f66j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462336
;     47c4c8:_pic_18f66k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462976
;     47c608:_pic_18f66k90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462784
;     47c748:_pic_18f6720  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443360
;     47c888:_pic_18f6722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446912
;     47c9c8:_pic_18f6723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460736
;     47cb08:_pic_18f67j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447328
;     47cc48:_pic_18f67j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459328
;     47cd88:_pic_18f67j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458560
;     47cec8:_pic_18f67j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449760
;     47d108:_pic_18f67j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462304
;     47d248:_pic_18f67j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462368
;     47d388:_pic_18f67k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462656
;     47d4c8:_pic_18f67k90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462528
;     47d608:_pic_18f8310  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444800
;     47d748:_pic_18f8390  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444736
;     47d888:_pic_18f8393  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448480
;     47d9c8:_pic_18f83j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456512
;     47db08:_pic_18f83j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456256
;     47dc48:_pic_18f8410  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443520
;     47dd88:_pic_18f8490  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443456
;     47dec8:_pic_18f8493  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1445408
;     47e108:_pic_18f84j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456544
;     47e248:_pic_18f84j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456288
;     47e388:_pic_18f8520  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444608
;     47e4c8:_pic_18f8525  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444544
;     47e608:_pic_18f8527  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446752
;     47e748:_pic_18f8585  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444416
;     47e888:_pic_18f85j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447392
;     47e9c8:_pic_18f85j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456608
;     47eb08:_pic_18f85j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447680
;     47ec48:_pic_18f85j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458592
;     47ed88:_pic_18f85j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1456352
;     47eec8:_pic_18f85k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463136
;     47f108:_pic_18f85k90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462944
;     47f248:_pic_18f8620  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443392
;     47f388:_pic_18f8621  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444480
;     47f4c8:_pic_18f8622  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446816
;     47f608:_pic_18f8627  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446880
;     47f748:_pic_18f8628  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460704
;     47f888:_pic_18f8680  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1444352
;     47f9c8:_pic_18f86j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447712
;     47fb08:_pic_18f86j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459424
;     47fc48:_pic_18f86j15  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447744
;     47fd88:_pic_18f86j16  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459456
;     47fec8:_pic_18f86j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458656
;     480108:_pic_18f86j55  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458688
;     480248:_pic_18f86j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447968
;     480388:_pic_18f86j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449792
;     4804c8:_pic_18f86j72  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 23397386
;     480608:_pic_18f86j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462400
;     480748:_pic_18f86j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462464
;     480888:_pic_18f86k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463072
;     4809c8:_pic_18f86k90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462880
;     480b08:_pic_18f8720  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1443328
;     480c48:_pic_18f8722  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1446944
;     480d88:_pic_18f8723  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460768
;     480ec8:_pic_18f87j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1447776
;     481108:_pic_18f87j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459488
;     481248:_pic_18f87j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1458720
;     481388:_pic_18f87j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449824
;     4814c8:_pic_18f87j72  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 23397898
;     481608:_pic_18f87j90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462432
;     481748:_pic_18f87j93  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462496
;     481888:_pic_18f87k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462720
;     4819c8:_pic_18f87k90  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462592
;     481b08:_pic_18f96j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1448000
;     481c48:_pic_18f96j65  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449856
;     481d88:_pic_18f97j60  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449888
;     481ec8:_pic_18lf13k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462144
;     482108:_pic_18lf13k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1459968
;     482248:_pic_18lf14k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1462112
;     482388:_pic_18lf14k50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1460000
;     4824c8:_pic_18lf23k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464160
;     482608:_pic_18lf24j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449280
;     482748:_pic_18lf24j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461824
;     482888:_pic_18lf24j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461440
;     4829c8:_pic_18lf24k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463904
;     482b08:_pic_18lf25j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449024
;     482c48:_pic_18lf25j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461856
;     482d88:_pic_18lf25j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461472
;     482ec8:_pic_18lf25k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463648
;     483108:_pic_18lf26j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461888
;     483248:_pic_18lf26j13  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1465120
;     483388:_pic_18lf26j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461504
;     4834c8:_pic_18lf26j53  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464864
;     483608:_pic_18lf26k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463392
;     483748:_pic_18lf27j13  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1465184
;     483888:_pic_18lf27j53  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464928
;     4839c8:_pic_18lf43k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464096
;     483b08:_pic_18lf44j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449312
;     483c48:_pic_18lf44j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461920
;     483d88:_pic_18lf44j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461536
;     483ec8:_pic_18lf44k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463840
;     484108:_pic_18lf45j10  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1449056
;     484248:_pic_18lf45j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461952
;     484388:_pic_18lf45j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461568
;     4844c8:_pic_18lf45k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463584
;     484608:_pic_18lf46j11  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461984
;     484748:_pic_18lf46j13  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1465248
;     484888:_pic_18lf46j50  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1461600
;     4849c8:_pic_18lf46j53  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1464992
;     484b08:_pic_18lf46k22  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1463328
;     484c48:_pic_18lf47j13  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1465312
;     484d88:_pic_18lf47j53  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1465056
;     4638f8:_target_cpu  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2
;     484f68:_target_chip  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 1314304
;     4856d8:_target_chip_name  (type=a dflags=C---- sz=7 use=0 assigned=0)
;      = 49,54,102,56,55,54,97
;     4854c8:_target_bank_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 128
;     485408:_target_page_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2048
;     485348:__stack_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8
;     485288:__code_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8192
;     485108:__eeprom  (type=a dflags=C---- sz=256 use=0 assigned=0)
;      = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;     485e98:__eeprom_used  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 0
;     485f58:__eeprom_base  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 8448
;     486108:__id0  (type=a dflags=C---- sz=4 use=0 assigned=0)
;      = 0,0,0,0
;     4861e8:__id0_used  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 0
;     4862a8:__id0_base  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 8192
;     485588:__pic_accum byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=007e)
;     4851c8:__pic_isr_w byte (type=i dflags=-V--- sz=1 use=2 assigned=2 base=007f)
;     486a88:__fuses_ct word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 1
;     486bf8:__fuse_base word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 8199
;     486d68:__fuses word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 16250
;     486988:_indf byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0000)
;     487108:__ind byte (type=i dflags=-V--- sz=1 use=10 assigned=7 base=0000)
;     4873b8:_tmr0 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0001)
;     487588:_pcl byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0002)
;     487838:__pcl byte (type=i dflags=-V--- sz=1 use=4 assigned=5 base=0002)
;     487ae8:_status byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0003)
;     487d98:_status_irp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> status+0
;     487ee8:_status_rp  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=5) ---> status+0
;     488108:_status_nto bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> status+0
;     488268:_status_npd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> status+0
;     4883c8:_status_z bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> status+0
;     488528:_status_dc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> status+0
;     488688:_status_c bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> status+0
;     4887e8:__status byte (type=i dflags=-V--- sz=1 use=132 assigned=21 base=0003)
;     488b98:__irp byte (type=i dflags=C---- sz=1 use=4 assigned=0)
;      = 7
;     488d08:__rp1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     488e78:__rp0 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     489108:__not_to byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     489278:__not_pd byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     4893e8:__z byte (type=i dflags=C---- sz=1 use=190 assigned=0)
;      = 2
;     489558:__dc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     4896c8:__c byte (type=i dflags=C---- sz=1 use=106 assigned=0)
;      = 0
;     488a98:_fsr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0004)
;     4899e8:__fsr byte (type=i dflags=-V--- sz=1 use=9 assigned=17 base=0004)
;     489c98:_porta byte (type=i dflags=-V--- sz=1 use=1 assigned=2 base=0005)
;     489e28:__porta_shadow byte (type=i dflags=----- auto sz=1 use=2 assigned=3 base=0042)
;     48a598:__porta_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     48b158:__porta_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48b3d8:__porta_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48adc8:__porta_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48ea68:__porta_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48e798:__porta_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     490f68:_porta_ra5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     4911f8:_pin_a5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     491378:_pin_an4 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     491458:_pin_ss bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     491538:_pin_c2out bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     491978:__pin_a5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     491628:_porta_ra4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     492468:_pin_a4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     4925e8:_pin_t0cki bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     4926c8:_pin_c1out bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     492b08:__pin_a4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4927b8:_porta_ra3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     4936a8:_pin_a3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     493828:_pin_an3 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     493908:_pin_vref_pos bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     493d48:__pin_a3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4939f8:_porta_ra2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     4947f8:_pin_a2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     494978:_pin_an2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     494a58:_pin_vref_neg bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     494b38:_pin_cvref bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     494f78:__pin_a2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     494c28:_porta_ra1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     495a78:_pin_a1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     495bf8:_pin_an1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     495548:__pin_a1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     495ce8:_porta_ra0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     496ae8:_pin_a0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     496c68:_pin_an0 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     497108:__pin_a0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     496d58:_portb byte (type=i dflags=-V--- sz=1 use=8 assigned=34 base=0006)
;     497c18:__portb_shadow byte (type=i dflags=----- auto sz=1 use=34 assigned=40 base=0043)
;     4981b8:__portb_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     498d28:__portb_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     499ca8:__portb_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     498a58:__portb_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49c708:__portb_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49c438:__portb_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49eef8:_portb_rb7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49f108:_pin_b7 bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=7) ---> portb+0
;     49f288:_pin_pgd bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     49f6c8:__pin_b7_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49f378:_portb_rb6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     49fc08:_pin_b6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     48cfa8:_pin_pgc bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     4a01b8:__pin_b6_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49add8:_portb_rb5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     4a0c28:_pin_b5 bit (type=B dflags=-V-B- sz=1 use=2 assigned=0 bit=5) ---> portb+0
;     4a1108:__pin_b5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a0db8:_portb_rb4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     4a1b78:_pin_b4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     4a1648:__pin_b4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a1d08:_portb_rb3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     4a2ae8:_pin_b3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     4a2c68:_pin_pgm bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     4a3108:__pin_b3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a2d58:_portb_rb2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portb+0
;     4a3b78:_pin_b2 bit (type=B dflags=-V-B- sz=1 use=2 assigned=0 bit=2) ---> portb+0
;     4a3648:__pin_b2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a3d08:_portb_rb1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     4a4ae8:_pin_b1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     4a45b8:__pin_b1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a4c78:_portb_rb0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a5ae8:_pin_b0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a5c68:_pin_int bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a6108:__pin_b0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a5d58:_portc byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0007)
;     4a6ba8:__portc_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     4a71b8:__portc_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4a7d28:__portc_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a8ca8:__portc_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a7a58:__portc_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ab708:__portc_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ab438:__portc_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4adef8:_portc_rc7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4ae108:_pin_c7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4ae288:_pin_rx bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4ae368:_pin_dt bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4ae7a8:__pin_c7_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ae458:_portc_rc6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4af2a8:_pin_c6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4af428:_pin_tx bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4af508:_pin_ck bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4af948:__pin_c6_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4af5f8:_portc_rc5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4b0388:_pin_c5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4b0508:_pin_sdo bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4b0948:__pin_c5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b05f8:_portc_rc4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4b1468:_pin_c4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4b15e8:_pin_sdi bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4b16c8:_pin_sda bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4b1b08:__pin_c4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b17b8:_portc_rc3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4b26a8:_pin_c3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4b2828:_pin_sck bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4b2908:_pin_scl bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4b2d48:__pin_c3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b29f8:_portc_rc2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4b37f8:_pin_c2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4b3978:_pin_ccp1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4b3db8:__pin_c2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b3a68:_portc_rc1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b47f8:_pin_c1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b4978:_pin_t1osi bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b4a58:_pin_ccp2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b4e98:__pin_c1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b4b48:_portc_rc0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b5988:_pin_c0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b5b08:_pin_t1oso bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b5be8:_pin_t1cki bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b5458:__pin_c0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b5cd8:_pclath byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000a)
;     4b6c28:_pclath_pclath  (type=i dflags=-V-B- sz=5 use=0 assigned=0 bit=0) ---> pclath+0
;     4b6e18:__pclath byte (type=i dflags=-V--- sz=1 use=1 assigned=9 base=000a)
;     4b7108:_intcon byte (type=i dflags=-V--- sz=1 use=1 assigned=9 base=000b)
;     4b73b8:_intcon_gie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=7) ---> intcon+0
;     4b7518:_intcon_peie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=6) ---> intcon+0
;     4b7678:_intcon_tmr0ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=5 bit=5) ---> intcon+0
;     4b77d8:_intcon_inte bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> intcon+0
;     4b7938:_intcon_rbie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> intcon+0
;     4b7a98:_intcon_tmr0if bit (type=B dflags=-V-B- sz=1 use=1 assigned=2 bit=2) ---> intcon+0
;     4b7bf8:_intcon_intf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> intcon+0
;     4b7d58:_intcon_rbif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> intcon+0
;     4b7eb8:_pir1 byte (type=i dflags=-V--- sz=1 use=3 assigned=2 base=000c)
;     4b8108:_pir1_adif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pir1+0
;     4b8268:_pir1_rcif bit (type=B dflags=-V-B- sz=1 use=1 assigned=1 bit=5) ---> pir1+0
;     4b83c8:_pir1_txif bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=4) ---> pir1+0
;     4b8528:_pir1_sspif bit (type=B dflags=-V-B- sz=1 use=1 assigned=1 bit=3) ---> pir1+0
;     4b8688:_pir1_ccp1if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pir1+0
;     4b87e8:_pir1_tmr2if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pir1+0
;     4b8948:_pir1_tmr1if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pir1+0
;     4b8aa8:_pir2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000d)
;     4b8c08:_pir2_cmif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pir2+0
;     4b8d68:_pir2_eeif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pir2+0
;     4b8ec8:_pir2_bclif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pir2+0
;     4b9108:_pir2_ccp2if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pir2+0
;     4b9268:_tmr1 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=000e)
;     4b93c8:_tmr1l byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000e)
;     4b9528:_tmr1h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000f)
;     4b9688:_t1con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0010)
;     4b97d8:_t1con_t1ckps  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> t1con+0
;     4b99c8:_t1con_t1oscen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> t1con+0
;     4b9b28:_t1con_nt1sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> t1con+0
;     4b9c88:_t1con_tmr1cs bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> t1con+0
;     4b9de8:_t1con_tmr1on bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> t1con+0
;     4b9f48:_tmr2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0011)
;     4ba108:_t2con byte (type=i dflags=-V--- sz=1 use=0 assigned=4 base=0012)
;     4ba258:_t2con_toutps  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=3) ---> t2con+0
;     4ba448:_t2con_tmr2on bit (type=B dflags=-V-B- sz=1 use=0 assigned=4 bit=2) ---> t2con+0
;     4ba598:_t2con_t2ckps  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=0) ---> t2con+0
;     4ba788:_sspbuf byte (type=i dflags=-V--- sz=1 use=1 assigned=1 base=0013)
;     4ba8e8:_sspcon byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0014)
;     4baa48:_sspcon_wcol bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspcon+0
;     4baba8:_sspcon_sspov bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspcon+0
;     4bad08:_sspcon_sspen bit (type=B dflags=-V-B- sz=1 use=0 assigned=2 bit=5) ---> sspcon+0
;     4bae68:_sspcon_ckp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspcon+0
;     4bb108:_sspcon_sspm  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> sspcon+0
;     4bb2f8:_ccpr1 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=0015)
;     4bb458:_ccpr1l byte (type=i dflags=-V--- sz=1 use=0 assigned=4 base=0015)
;     4bb5b8:_ccpr1h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0016)
;     4bb718:_ccp1con byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0017)
;     4bb868:_ccp1con_dc1b  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> ccp1con+0
;     4bba48:_ccp1con_ccp1m  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> ccp1con+0
;     4bbc38:_rcsta byte (type=i dflags=-V--- sz=1 use=1 assigned=3 base=0018)
;     4bbd98:_rcsta_spen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> rcsta+0
;     4bbef8:_rcsta_rx9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> rcsta+0
;     4bc108:_rcsta_sren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> rcsta+0
;     4bc268:_rcsta_cren bit (type=B dflags=-V-B- sz=1 use=0 assigned=2 bit=4) ---> rcsta+0
;     4bc3c8:_rcsta_adden bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> rcsta+0
;     4bc528:_rcsta_ferr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> rcsta+0
;     4bc688:_rcsta_oerr bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=1) ---> rcsta+0
;     4bc7e8:_rcsta_rx9d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> rcsta+0
;     4bc948:_txreg byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0019)
;     4bcaa8:_rcreg byte (type=i dflags=-V--- sz=1 use=1 assigned=0 base=001a)
;     4bcc08:_ccpr2 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=001b)
;     4bcd68:_ccpr2l byte (type=i dflags=-V--- sz=1 use=0 assigned=4 base=001b)
;     4bcec8:_ccpr2h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001c)
;     4bd108:_ccp2con byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=001d)
;     4bd258:_ccp2con_dc2b  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> ccp2con+0
;     4bd438:_ccp2con_ccp2m  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> ccp2con+0
;     4bd628:_adresh byte (type=i dflags=-V--- sz=1 use=1 assigned=0 base=001e)
;     4bd788:_adcon0 byte (type=i dflags=-V--- sz=1 use=2 assigned=3 base=001f)
;     4bd8d8:_adcon0_adcs  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;     4bdab8:_adcon0_chs  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=3) ---> adcon0+0
;     4bdca8:_adcon0_go bit (type=B dflags=-V-B- sz=1 use=1 assigned=1 bit=2) ---> adcon0+0
;     4bde08:_adcon0_ndone bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> adcon0+0
;     4bdf68:_adcon0_adon bit (type=B dflags=-V-B- sz=1 use=0 assigned=2 bit=0) ---> adcon0+0
;     4be108:_option_reg byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0081)
;     4be2e8:_option_reg_nrbpu bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> option_reg+0
;     4be468:_option_reg_intedg bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> option_reg+0
;     4be5d8:_option_reg_t0cs bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> option_reg+0
;     4be778:_t0con_t0cs bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> option_reg+0
;     4be838:_option_reg_t0se bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> option_reg+0
;     4be9d8:_t0con_t0se bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> option_reg+0
;     4bea98:_option_reg_psa bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=3) ---> option_reg+0
;     4bec38:_t0con_psa bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> option_reg+0
;     4bece8:_option_reg_ps  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=0) ---> option_reg+0
;     4bef18:_t0con_t0ps  (type=i dflags=-V-B- alias sz=3 use=0 assigned=0 bit=0) ---> option_reg+0
;     4bf108:_trisa byte (type=i dflags=-V--- sz=1 use=0 assigned=6 base=0085)
;     4bf298:_porta_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisa+0
;     4bf688:__porta_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4bf3a8:__porta_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c2108:__porta_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c1cd8:__porta_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c45d8:_trisa_trisa5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4c4778:_pin_a5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> trisa+0
;     4c4948:_pin_an4_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4c4a68:_pin_ss_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4c4b88:_pin_c2out_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4c4c48:_trisa_trisa4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4c4db8:_pin_a4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=4) ---> trisa+0
;     4c4f88:_pin_t0cki_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4c48b8:_pin_c1out_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4c4af8:_trisa_trisa3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4c5108:_pin_a3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=3) ---> trisa+0
;     4c52d8:_pin_an3_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4c53f8:_pin_vref_pos_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4c54b8:_trisa_trisa2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4c5628:_pin_a2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> trisa+0
;     4c57f8:_pin_an2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4c5918:_pin_vref_neg_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4c5a38:_pin_cvref_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4c5af8:_trisa_trisa1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4c5c68:_pin_a1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=1) ---> trisa+0
;     4c5e38:_pin_an1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4c5ef8:_trisa_trisa0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4c5368:_pin_a0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=0) ---> trisa+0
;     4c5da8:_pin_an0_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4c5888:_trisb byte (type=i dflags=-V--- sz=1 use=0 assigned=13 base=0086)
;     4c6108:_portb_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisb+0
;     4c64f8:__portb_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c6218:__portb_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c8d58:__portb_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c8a78:__portb_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4cb218:_trisb_trisb7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4cb3b8:_pin_b7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=3 bit=7) ---> trisb+0
;     4cb588:_pin_pgd_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4cb648:_trisb_trisb6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4cb7b8:_pin_b6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=3 bit=6) ---> trisb+0
;     4cb988:_pin_pgc_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4cba48:_trisb_trisb5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4cbbb8:_pin_b5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> trisb+0
;     4cbd28:_trisb_trisb4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4cbe98:_pin_b4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=4) ---> trisb+0
;     4cb4f8:_trisb_trisb3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4cc108:_pin_b3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=3 bit=3) ---> trisb+0
;     4cc2d8:_pin_pgm_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4cc398:_trisb_trisb2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisb+0
;     4cc508:_pin_b2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> trisb+0
;     4cc678:_trisb_trisb1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisb+0
;     4cc7e8:_pin_b1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=1) ---> trisb+0
;     4cc958:_trisb_trisb0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4ccac8:_pin_b0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4ccc98:_pin_int_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4ccd58:_trisc byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0087)
;     4ccee8:_portc_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisc+0
;     4cd1b8:__portc_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4cc248:__portc_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4cfaa8:__portc_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4cf7c8:__portc_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d1c88:_trisc_trisc7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4d1e28:_pin_c7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4d2108:_pin_rx_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4d2228:_pin_dt_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4d22e8:_trisc_trisc6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4d2458:_pin_c6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4d2628:_pin_tx_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4d2748:_pin_ck_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4d2808:_trisc_trisc5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4d2978:_pin_c5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4d2b48:_pin_sdo_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4d2c08:_trisc_trisc4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4d2d78:_pin_c4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4d2f48:_pin_sdi_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4d2598:_pin_sda_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4d2ab8:_trisc_trisc3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4d2198:_pin_c3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4d3108:_pin_sck_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4d3228:_pin_scl_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4d32e8:_trisc_trisc2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4d3458:_pin_c2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> trisc+0
;     4d3628:_pin_ccp1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4d36e8:_trisc_trisc1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4d3858:_pin_c1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=1) ---> trisc+0
;     4d3a28:_pin_t1osi_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4d3b48:_pin_ccp2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4d3c08:_trisc_trisc0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4d3d78:_pin_c0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4d3f48:_pin_t1oso_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4d3598:_pin_t1cki_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4d3998:_pie1 byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=008c)
;     4d3eb8:_pie1_adie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pie1+0
;     4d3ab8:_pie1_rcie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> pie1+0
;     4d4108:_pie1_txie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=4) ---> pie1+0
;     4d4268:_pie1_sspie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pie1+0
;     4d43c8:_pie1_ccp1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pie1+0
;     4d4528:_pie1_tmr2ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pie1+0
;     4d4688:_pie1_tmr1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pie1+0
;     4d47e8:_pie2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008d)
;     4d4948:_pie2_cmie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pie2+0
;     4d4aa8:_pie2_eeie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pie2+0
;     4d4c08:_pie2_bclie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pie2+0
;     4d4d68:_pie2_ccp2ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pie2+0
;     4d4ec8:_pcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008e)
;     4d5108:_pcon_npor bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pcon+0
;     4d5268:_pcon_nbor bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pcon+0
;     4d53c8:_sspcon2 byte (type=i dflags=-V--- sz=1 use=5 assigned=7 base=0091)
;     4d5528:_sspcon2_gcen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspcon2+0
;     4d5688:_sspcon2_ackstat bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=6) ---> sspcon2+0
;     4d57e8:_sspcon2_ackdt bit (type=B dflags=-V-B- sz=1 use=0 assigned=2 bit=5) ---> sspcon2+0
;     4d5948:_sspcon2_acken bit (type=B dflags=-V-B- sz=1 use=1 assigned=1 bit=4) ---> sspcon2+0
;     4d5aa8:_sspcon2_rcen bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=3) ---> sspcon2+0
;     4d5c08:_sspcon2_pen bit (type=B dflags=-V-B- sz=1 use=1 assigned=1 bit=2) ---> sspcon2+0
;     4d5d68:_sspcon2_rsen bit (type=B dflags=-V-B- sz=1 use=1 assigned=1 bit=1) ---> sspcon2+0
;     4d5ec8:_sspcon2_sen bit (type=B dflags=-V-B- sz=1 use=1 assigned=1 bit=0) ---> sspcon2+0
;     4d6108:_pr2 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0092)
;     4d6268:_sspadd byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0093)
;     4d63c8:_sspstat byte (type=i dflags=-V--- sz=1 use=1 assigned=0 base=0094)
;     4d6528:_sspstat_smp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspstat+0
;     4d6688:_sspstat_cke bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspstat+0
;     4d67e8:_sspstat_d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspstat+0
;     4d6948:_sspstat_na bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspstat+0
;     4d6aa8:_sspstat_p bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspstat+0
;     4d6c08:_sspstat_s bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> sspstat+0
;     4d6d68:_sspstat_r bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspstat+0
;     4d6ec8:_sspstat_nw bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspstat+0
;     4d7108:_sspstat_ua bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> sspstat+0
;     4d7268:_sspstat_bf bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=0) ---> sspstat+0
;     4d73c8:_txsta byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0098)
;     4d7528:_txsta_csrc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> txsta+0
;     4d7688:_txsta_tx9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> txsta+0
;     4d77e8:_txsta_txen bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> txsta+0
;     4d7948:_txsta_sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> txsta+0
;     4d7aa8:_txsta_brgh bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> txsta+0
;     4d7c08:_txsta_trmt bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> txsta+0
;     4d7d68:_txsta_tx9d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> txsta+0
;     4d7ec8:_spbrg byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0099)
;     4d8108:_cmcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=009c)
;     4d8268:_cmcon_c2out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> cmcon+0
;     4d83c8:_cmcon_c1out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> cmcon+0
;     4d8528:_cmcon_c2inv bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> cmcon+0
;     4d8688:_cmcon_c1inv bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> cmcon+0
;     4d87e8:_cmcon_cis bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> cmcon+0
;     4d8938:_cmcon_cm  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=0) ---> cmcon+0
;     4d8b28:_cvrcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=009d)
;     4d8c88:_cvrcon_cvren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> cvrcon+0
;     4d8de8:_cvrcon_cvroe bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> cvrcon+0
;     4d8f48:_cvrcon_cvrr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> cvrcon+0
;     4d9108:_cvrcon_cvr  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> cvrcon+0
;     4d92f8:_adresl byte (type=i dflags=-V--- sz=1 use=1 assigned=0 base=009e)
;     4d9458:_adcon1 byte (type=i dflags=-V--- sz=1 use=1 assigned=3 base=009f)
;     4d95b8:_adcon1_adfm bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=7) ---> adcon1+0
;     4d9718:_adcon1_adcs2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=2 bit=6) ---> adcon1+0
;     4d9868:_adcon1_pcfg  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> adcon1+0
;     4d9a58:_eedata byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010c)
;     4d9bb8:_eeadr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010d)
;     4d9d18:_eedath byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010e)
;     4d9e68:_eedath_eedath  (type=i dflags=-V-B- sz=6 use=0 assigned=0 bit=0) ---> eedath+0
;     4da108:_eeadrh byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010f)
;     4da258:_eeadrh_eeadrh  (type=i dflags=-V-B- sz=5 use=0 assigned=0 bit=0) ---> eeadrh+0
;     4da448:_eecon1 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=018c)
;     4da5a8:_eecon1_eepgd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> eecon1+0
;     4da708:_eecon1_wrerr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> eecon1+0
;     4da868:_eecon1_wren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> eecon1+0
;     4da9c8:_eecon1_wr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> eecon1+0
;     4dab28:_eecon1_rd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> eecon1+0
;     4dac88:_eecon2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=018d)
;     4dae18:_adc_group  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44481
;     4db108:_adc_ntotal_channel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     4daef8:_adc_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4dc398:_comparator_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4dce48:_enable_digital_io_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4deab8:_target_clock  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 20000000
;     4ddd68:_delay_1us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4df1a8:_delay_2us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4df948:_delay_3us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4c3f98:_delay_4us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4e07f8:_delay_5us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4e0f98:_delay_6us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4e17f8:_delay_7us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4e1f98:_delay_8us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4e27f8:_delay_9us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4e2f98:_instruction_time  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 20
;     4e3a08:_delay_10us_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e68c8:_delay_1ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     4eb1f8:_delay_100ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     4ed108:_delay_1s_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     4ef128:_ascii_null byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     4ef298:_ascii_soh byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     4ef408:_ascii_stx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 2
;     4ef578:_ascii_etx byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     4ef6e8:_ascii_eot byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     4ef858:_ascii_enq byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     4ef9c8:_ascii_ack byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     4efb38:_ascii_bel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 7
;     4efca8:_ascii_bs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 8
;     4efe18:_ascii_ht byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 9
;     4eff88:_ascii_lf byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 10
;     462258:_ascii_vt byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 11
;     4d1f68:_ascii_ff byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 12
;     4deb58:_ascii_cr byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 13
;     4e5fa8:_ascii_so byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 14
;     4e5d18:_ascii_si byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 15
;     4f0108:_ascii_dle byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 16
;     4f0278:_ascii_dc1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 17
;     4f03e8:_ascii_dc2 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 18
;     4f0558:_ascii_dc3 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 19
;     4f06c8:_ascii_dc4 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 20
;     4f0838:_ascii_nak byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 21
;     4f09a8:_ascii_syn byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 22
;     4f0b18:_ascii_etb byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 23
;     4f0c88:_ascii_can byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 24
;     4f0df8:_ascii_em byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 25
;     4f0f68:_ascii_sub byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 26
;     4f1108:_ascii_esc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 27
;     4f1278:_ascii_fs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 28
;     4f13e8:_ascii_gs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 29
;     4f1558:_ascii_rs byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 30
;     4f16c8:_ascii_us byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 31
;     4f1838:_ascii_sp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 32
;     4f19a8:_ascii_del byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 127
;     4f1d48:_toupper_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4f48d8:_tolower_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4f79c8:__print_universal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     4f8108:__print_suniversal_dec_1  (type=F dflags=----- sz=11 use=0 assigned=0 base=0000)
;     4f7618:_print_byte_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     4f9528:_nibble2hex  (type=a dflags=C---- lookup sz=16 use=28 assigned=0)
;      = 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70
;     4e35b8:_print_prefix bit (type=B dflags=---B- sz=1 use=2 assigned=1 bit=0) ---> _bitbucket+0
;     4f7728:_print_crlf_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     4f89d8:_print_string_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     4f92e8:_print_bit_truefalse_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     4fcea8:_print_bit_highlow_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     4fecd8:_print_bit_10_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     501378:_print_dword_binary_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     503e98:_print_word_binary_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     50a108:_print_nibble_binary_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     50dac8:_print_dword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     513cc8:_print_sdword_hex_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     51a2b8:_print_word_hex_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     51de38:_print_byte_hex_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     520708:_print_sdword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     521688:_print_sword_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     522628:_print_sword_fp_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     524858:_print_sbyte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5257e8:_print_dword_dec_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     526768:_print_word_dec_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5276f8:_print_byte_dec_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     4f88e8:_serial_hw_baudrate  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 115200
;     5284e8:_usart_hw_serial bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     4f7508:__calculate_and_set_baudrate_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     531a58:_serial_hw_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     531f58:_serial_hw_disable_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     536b48:_serial_hw_enable_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5375a8:_serial_hw_write_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     538be8:_serial_hw_write_word_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     53af08:__serial_hw_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     53d1f8:_serial_hw_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     53f4e8:__serial_hw_data_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5372d8:__serial_hw_data_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     541f78:_serial_hw_data_available bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> pir1+0
;     542108:_serial_hw_data_ready bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> pir1+0
;     5424f8:__serial_hw_data_raw_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     542218:__serial_hw_data_raw_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5438b8:_adc_high_resolution bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     543a88:_adc_nchannel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     543bf8:_adc_nvref byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     543988:__adc_vref_vcfg_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     545558:__adc_vref_adref_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     544978:__adc_setup_pins_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     54a8a8:__adc_vref_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     54b208:_tad_value byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0044)
;     54b308:_adc_min_tad byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 16
;     54b108:_adc_max_tad byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 60
;     54b508:__adc_eval_tad_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     54b408:__adc_init_clock_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     561a28:_adc_rsource word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 10000
;     561918:_adc_temp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 25
;     5638d8:__adcon0_shadow byte (type=i dflags=-V--- auto sticky sz=1 use=0 assigned=1 base=0039)
;     5643c8:_adc_conversion_delay byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0045)
;     5648e8:__adc_read_low_res_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     564648:_adc_read_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5697d8:_adc_read_bytes_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     569438:_adc_read_low_res_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5644f8:__adc_init_justify_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     56dde8:__adc_init_acquisition_delay_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     56f228:__adc_setup_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5759a8:_adc_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     58d538:_timer0_isr_rate word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 1000
;     58d678:_delay_slots  (type=i dflags=C---U sz=4 use=4 assigned=0)
;      = 2
;     58d438:_internal_isr_counter word (type=i dflags=----- auto sz=2 use=4 assigned=2 base=0046)
;     58d9b8:_isr_countdown  (type=a dflags=----- auto sz=4 use=7 assigned=7 base=0048)
;     58da78:_timer0_load byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=004c)
;     58dd68:__isr_counter_get_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     58f2b8:_set_delay_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     58e7b8:_check_delay_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     58ef08:_timer0_isr_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     59b258:_isr_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     59f3f8:__i2c_bus_speed word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 1
;     59f588:__i2c_level bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     594c68:__i2c_100khz  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 49
;     597f28:__i2c_400khz  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 11
;     59df58:__i2c_1mhz  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 4
;     594508:_i2c_initialize_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5a1108:_i2c_start_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5a35d8:_i2c_restart_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5a4ab8:_i2c_stop_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5a6108:_i2c_transmit_byte_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5a8ef8:_i2c_receive_byte_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5a5d28:_bridge_1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     5abd58:_bridge_2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     5abe68:_bridge_3 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portb+0
;     5abf78:_bridge_4 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     5a3c78:__pr2_shadow_plus1 word (type=i dflags=-V--- auto sticky sz=2 use=1 assigned=4 base=003a)
;     5b06f8:_pwm_max_resolution_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5b4f98:_pwm_set_frequency_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5b0418:__ccpr1l_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=004d)
;     5bb8f8:__ccp1con_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=004e)
;     5bbcb8:__ccp1con_shadow_dc1b  (type=i dflags=---B- sz=2 use=0 assigned=0 bit=4) ---> _ccp1con_shadow+0
;     5bbec8:__ccp1con_shadow_ccp1m  (type=i dflags=---B- sz=4 use=0 assigned=0 bit=0) ---> _ccp1con_shadow+0
;     5bc258:_pwm1_on_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5bd548:_pwm1_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5be278:_pwm1_set_dutycycle_highres_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5c0ad8:_pwm1_set_dutycycle_lowres_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5c2558:_pwm1_set_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5c3a48:_pwm1_set_percent_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5bdf88:__ccpr2l_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=004f)
;     5c8478:__ccp2con_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0050)
;     5c8838:__ccp2con_shadow_dc2b  (type=i dflags=---B- sz=2 use=0 assigned=0 bit=4) ---> _ccp2con_shadow+0
;     5c8a48:__ccp2con_shadow_ccp2m  (type=i dflags=---B- sz=4 use=0 assigned=0 bit=0) ---> _ccp2con_shadow+0
;     5c8e18:_pwm2_on_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5ca1b8:_pwm2_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5caeb8:_pwm2_set_dutycycle_highres_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5cd968:_pwm2_set_dutycycle_lowres_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5cf338:_pwm2_set_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5b9f78:_pwm2_set_percent_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5d3b28:_ledyellow bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     5d5378:_ledorange bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     5d5488:_ledgreen bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     5d5de8:_pcfdata  (type=i dflags=C---- sz=1 use=4 assigned=0)
;      = 0
;     5d5518:_swselect bit (type=B dflags=---B- sz=1 use=2 assigned=3 bit=1) ---> _bitbucket+0
;     5d57f8:_swright bit (type=B dflags=---B- sz=1 use=2 assigned=3 bit=2) ---> _bitbucket+0
;     5d6108:_swleft bit (type=B dflags=---B- sz=1 use=2 assigned=3 bit=3) ---> _bitbucket+0
;     5d61c8:_prevbuttonio byte (type=i dflags=----- auto sz=1 use=4 assigned=1 base=0051)
;     5d6288:_buttondelay byte (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0052)
;     5d6528:_buttons_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5ddde8:_batterycheck_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5e1208:_line_norm word (type=i dflags=C---- sz=2 use=6 assigned=0)
;      = 150
;     5e1108:_motorl sbyte (type=i dflags=--S-- auto sz=1 use=4 assigned=5 base=0053)
;     5e1338:_motorr sbyte (type=i dflags=--S-- auto sz=1 use=4 assigned=5 base=0054)
;     5e13f8:_prevmotorl  (type=i dflags=C-S-- sz=1 use=0 assigned=0)
;      = 0
;     5e14b8:_prevmotorr  (type=i dflags=C-S-- sz=1 use=0 assigned=0)
;      = 0
;     5e1678:_servoslope byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     5e1578:_draairichting bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> _bitbucket+0
;     5e17a8:_ldist  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     5e1868:_rdist  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     5e1928:_eyel_h  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     5e19e8:_eyer_h  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     5e1aa8:_requestcontrol byte (type=i dflags=----- auto sz=1 use=4 assigned=3 base=0055)
;     5e1b68:_prevwinner byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=0056)
;     5e1c28:_eyeonflag  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     5e1ce8:_linel word (type=i dflags=----- auto sz=2 use=13 assigned=7 base=0057)
;     5e1da8:_liner word (type=i dflags=----- auto sz=2 use=13 assigned=7 base=0059)
;     5e1e98:_flagwaitstart  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     5e22a8:_cntavoid word (type=i dflags=----- auto sz=2 use=5 assigned=4 base=005b)
;     5e2368:_cntcruise  (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 0
;     5e2428:_cntturn  (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 0
;     5e24e8:_cntspot  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     5e28e8:_behaveseek_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5e4d68:_behavecruise_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5e9158:_behavetracklong_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5ef258:_behavespottarget_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5f52e8:_behavetrackcyclop_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5f7108:_behavetrackshort_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5f78b8:_behaveavoid_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5fd458:_behavesideview_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     604a18:_startcounter byte (type=i dflags=----- auto sz=1 use=10 assigned=6 base=005d)
;     6051b8:_behavewaitstart_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     604e38:_vloersensor_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     624738:_readpcf8574_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     626168:_eeprom_adres word (type=i dflags=----- auto sz=2 use=6 assigned=6 base=005e)
;     626538:_csvheader  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     6265f8:_csv_magic  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     6267e8:_csv_step byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 8
;     626958:_csv_valid byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     626d48:_read_byte_from_eeprom_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     6266b8:_csvlog_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     631858:_csvreset_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     6321b8:_csvoutput_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     63e638:_csvdump_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     640e18:_console_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     65af28:_str1_2  (type=a dflags=----- auto sz=20 use=0 assigned=20 base=00a0)
;     65ebb8:_previsr_counter word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0060)
;     65f4b8:__btemp_51  (type=i dflags=---B- sz=13 use=0 assigned=0 bit=5) ---> _bitbucket+0
;     65f588:__btemp152  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=5) ---> _bitbucket+0
;     64af98:__btemp153  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=6) ---> _bitbucket+0
;     661378:_prevpcfdata byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0062)
;     661df8:__temp_69  (type=i dflags=----- auto sz=2 use=4 assigned=4 base=0063)
;     63d108:__bitbucket  (type=i dflags=----- auto sz=5 use=22 assigned=36 base=0065)
;     523338:__pic_temp  (type=i dflags=----- sz=4 use=71 assigned=94) ---> _pic_state+0
;     519678:__pic_pointer  (type=i dflags=----- sz=2 use=8 assigned=20 base=0036)
;     511548:__pic_loop  (type=i dflags=----- sz=1 use=2 assigned=4 base=0034)
;     5113e8:__pic_divisor  (type=i dflags=----- sz=4 use=20 assigned=24) ---> _pic_state+8
;     510d18:__pic_dividend  (type=i dflags=----- sz=4 use=9 assigned=24) ---> _pic_state+0
;     5107b8:__pic_quotient  (type=i dflags=----- sz=4 use=18 assigned=13) ---> _pic_state+12
;     510a78:__pic_remainder  (type=i dflags=----- sz=4 use=21 assigned=16) ---> _pic_state+4
;     510918:__pic_divaccum  (type=i dflags=----- sz=8 use=8 assigned=8) ---> _pic_state+0
;     50c668:__pic_multiplier  (type=i dflags=----- sz=2 use=2 assigned=4) ---> _pic_state+0
;     50c218:__pic_multiplicand  (type=i dflags=----- sz=2 use=2 assigned=2) ---> _pic_state+2
;     50bcb8:__pic_mresult  (type=i dflags=----- sz=2 use=7 assigned=5) ---> _pic_state+4
;     4a85d8:__pic_isr_fsr  (type=i dflags=----- sz=1 use=1 assigned=1 base=0038)
;     49cd18:__pic_isr_status  (type=i dflags=----- sz=1 use=1 assigned=1 base=0032)
;     49d298:__pic_isr_pclath  (type=i dflags=----- sz=1 use=1 assigned=1 base=0033)
;     7f7368:__pic_sign  (type=i dflags=----- sz=1 use=2 assigned=4 base=0035)
;     8055a8:__pic_state  (type=i dflags=----- sz=16 use=160 assigned=192 base=0020)
;     805698:__pic_isr_state  (type=i dflags=-V--- sz=2 use=2 assigned=2 base=0030)
;     --- labels ---
;     _isr_cleanup (pc(0000) usage=0)
;     _isr_preamble (pc(0000) usage=0)
;     _main (pc(00d7) usage=7)
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
;     delay_10us (pc(00dc) usage=28)
;     delay_1ms (pc(0000) usage=0)
;     delay_100ms (pc(0000) usage=0)
;     delay_1s (pc(0000) usage=0)
;     toupper (pc(0000) usage=0)
;     tolower (pc(0000) usage=0)
;     _print_universal_dec (pc(02a9) usage=21)
;     _print_suniversal_dec (pc(0262) usage=7)
;     print_byte_binary (pc(0000) usage=0)
;     print_crlf (pc(010e) usage=63)
;     print_string (pc(0124) usage=84)
;     print_bit_truefalse (pc(0150) usage=7)
;     print_bit_highlow (pc(0000) usage=0)
;     print_bit_10 (pc(0000) usage=0)
;     print_dword_binary (pc(0000) usage=0)
;     print_word_binary (pc(0000) usage=0)
;     print_nibble_binary (pc(0000) usage=0)
;     print_dword_hex (pc(0000) usage=0)
;     print_sdword_hex (pc(0000) usage=0)
;     print_word_hex (pc(016c) usage=7)
;     print_byte_hex (pc(01e1) usage=42)
;     print_sdword_dec (pc(0000) usage=0)
;     print_sword_dec (pc(0229) usage=14)
;     print_sword_fp_dec (pc(0000) usage=0)
;     print_sbyte_dec (pc(0000) usage=0)
;     print_dword_dec (pc(0000) usage=0)
;     print_word_dec (pc(023e) usage=35)
;     print_byte_dec (pc(0250) usage=14)
;     _calculate_and_set_baudrate (pc(0353) usage=7)
;     serial_hw_init (pc(0358) usage=7)
;     serial_hw_disable (pc(0000) usage=0)
;     serial_hw_enable (pc(0000) usage=0)
;     serial_hw_write (pc(0362) usage=7)
;     serial_hw_write_word (pc(0000) usage=0)
;     _serial_hw_read (pc(0000) usage=0)
;     serial_hw_read (pc(0369) usage=7)
;     _serial_hw_data_put (pc(0386) usage=280)
;     _serial_hw_data_get (pc(0000) usage=0)
;     _serial_hw_data_raw_put (pc(0000) usage=0)
;     _serial_hw_data_raw_get (pc(0000) usage=0)
;     _adc_vref_vcfg (pc(0000) usage=0)
;     _adc_vref_adref (pc(0000) usage=0)
;     _adc_setup_pins (pc(0000) usage=0)
;     _adc_vref (pc(0390) usage=7)
;     _adc_eval_tad (pc(0391) usage=42)
;     _adc_init_clock (pc(0000) usage=0)
;     _adc_read_low_res (pc(03de) usage=7)
;     adc_read (pc(0416) usage=49)
;     adc_read_bytes (pc(0000) usage=0)
;     adc_read_low_res (pc(0000) usage=0)
;     _adc_init_justify (pc(0000) usage=0)
;     _adc_init_acquisition_delay (pc(0000) usage=0)
;     _adc_setup (pc(0000) usage=0)
;     adc_init (pc(0000) usage=0)
;     _isr_counter_get (pc(0505) usage=21)
;     set_delay (pc(0518) usage=14)
;     check_delay (pc(052f) usage=14)
;     timer0_isr_init (pc(0558) usage=7)
;     isr (pc(0579) usage=7)
;     i2c_initialize (pc(0000) usage=0)
;     i2c_start (pc(05c0) usage=7)
;     i2c_restart (pc(05c7) usage=7)
;     i2c_stop (pc(05ce) usage=7)
;     i2c_transmit_byte (pc(05d5) usage=28)
;     i2c_receive_byte (pc(05ec) usage=7)
;     pwm_max_resolution (pc(0622) usage=7)
;     pwm_set_frequency (pc(0000) usage=0)
;     pwm1_on (pc(064b) usage=7)
;     pwm1_off (pc(0000) usage=0)
;     pwm1_set_dutycycle_highres (pc(0000) usage=0)
;     pwm1_set_dutycycle_lowres (pc(0000) usage=0)
;     pwm1_set_dutycycle (pc(0000) usage=0)
;     pwm1_set_percent_dutycycle (pc(0000) usage=0)
;     pwm2_on (pc(0659) usage=7)
;     pwm2_off (pc(0000) usage=0)
;     pwm2_set_dutycycle_highres (pc(0000) usage=0)
;     pwm2_set_dutycycle_lowres (pc(0000) usage=0)
;     pwm2_set_dutycycle (pc(0000) usage=0)
;     pwm2_set_percent_dutycycle (pc(0000) usage=0)
;     buttons (pc(0670) usage=7)
;     batterycheck (pc(06b6) usage=14)
;     behaveseek (pc(0000) usage=0)
;     behavecruise (pc(0000) usage=0)
;     behavetracklong (pc(0000) usage=0)
;     behavespottarget (pc(0000) usage=0)
;     behavetrackcyclop (pc(0000) usage=0)
;     behavetrackshort (pc(0000) usage=0)
;     behaveavoid (pc(073f) usage=7)
;     behavesideview (pc(0000) usage=0)
;     behavewaitstart (pc(07b5) usage=7)
;     vloersensor (pc(0888) usage=7)
;     readpcf8574 (pc(0000) usage=0)
;     read_byte_from_eeprom (pc(08ec) usage=7)
;     csvlog (pc(0000) usage=0)
;     csvreset (pc(0000) usage=0)
;     csvoutput (pc(0000) usage=0)
;     csvdump (pc(0917) usage=7)
;     console (pc(0949) usage=7)
;     _pic_indirect (pc(00d3) usage=102)
;     _pic_pointer_read (pc(00c1) usage=6)
;     _data_str1 (pc(0037) usage=4)
;     _data_str0 (pc(0031) usage=4)
;     _pic_divide (pc(006f) usage=18)
;     _pic_sdivide (pc(004e) usage=6)
;     _pic_multiply (pc(003b) usage=6)
;     _data_bstr1 (pc(0026) usage=4)
;     _pic_reset (pc(0000) usage=0)
;     _pic_isr (pc(0004) usage=0)
;     _pic_lookup (pc(0000) usage=0)
;     _lookup_nibble2hex (pc(0014) usage=24)
;     _lookup_bstr1 (pc(0025) usage=0)
;     _lookup_str0 (pc(0030) usage=0)
;     _lookup_str1 (pc(0036) usage=0)
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
;           5811e8:_no_vref_3  (type=i dflags=---B- sz=4 use=0 assigned=0 bit=18) ---> _bitbucket+0
;           582108:_one_vref_3  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;            = 0
;           582198:_two_vref_3  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;            = 0
;           --- labels ---
;         {block exit}
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         586748:_jallib_adfm_2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> adcon1+0
;         --- labels ---
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         587178:_jallib_adcs_lsb_2  (type=i dflags=-V-B- alias sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;         587208:_jallib_adcs_msb_2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> adcon1+0
;         587298:_adcs_2  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=18) ---> _bitbucket+0
;         587328:__btemp_20  (type=i dflags=---B- sz=12 use=0 assigned=0 bit=21) ---> _bitbucket+0
;         5873b8:__btemp34_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=21) ---> _bitbucket+0
;         587448:__btemp35_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=22) ---> _bitbucket+0
;         5874d8:__btemp36_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=23) ---> _bitbucket+0
;         587568:__btemp37_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=24) ---> _bitbucket+0
;         5875f8:__btemp38_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=25) ---> _bitbucket+0
;         587688:__btemp39_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=26) ---> _bitbucket+0
;         587718:__btemp40_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=27) ---> _bitbucket+0
;         5877a8:__btemp41_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=28) ---> _bitbucket+0
;         587838:__btemp42_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=29) ---> _bitbucket+0
;         5878c8:__btemp43_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=30) ---> _bitbucket+0
;         587958:__btemp44_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=31) ---> _bitbucket+0
;         5879e8:__btemp45_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=32) ---> _bitbucket+0
;         587a78:_adcs_lsb_2  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=18) ---> _bitbucket+0
;         587b08:_adcs_msb_2 bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=20) ---> _bitbucket+0
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
;       5ace68:_x_74 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=5) ---> _portb_shadow+0
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;       {block exit}
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       5ada28:_x_75 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=4) ---> _portb_shadow+0
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;       {block exit}
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       5ae4d8:_x_76 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=2) ---> _portb_shadow+0
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;       {block exit}
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       5aeef8:_x_77 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=1) ---> _portb_shadow+0
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;       {block exit}
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       65f9b8:_x_102 bit (type=B dflags=---B- sz=1 use=0 assigned=2 bit=4) ---> _portb_shadow+0
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;       {block exit}
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       660418:_x_103 bit (type=B dflags=---B- sz=1 use=0 assigned=2 bit=1) ---> _portb_shadow+0
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;       {block exit}
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       6621c8:__btemp154  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _bitbucket+0
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         663108:__btemp155  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=8) ---> _bitbucket+0
;         667148:__btemp156  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=9) ---> _bitbucket+0
;         668108:__btemp157  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=10) ---> _bitbucket+0
;         66b698:__btemp158  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=11) ---> _bitbucket+0
;         66e258:__btemp159  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=12) ---> _bitbucket+0
;         66f448:__btemp160  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=13) ---> _bitbucket+0
;         6717e8:__btemp161  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=14) ---> _bitbucket+0
;         672558:__btemp162  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=15) ---> _bitbucket+0
;         --- labels ---
;         {block enter}
;           --- records ---
;           --- variables ---
;           663ee8:_mstr2  (type=a dflags=----- auto sz=9 use=0 assigned=9 base=00b4)
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
;           668ce8:_mstr1  (type=a dflags=----- auto sz=8 use=0 assigned=8 base=00b4)
;           --- labels ---
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             66c608:_x_104 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=2) ---> _portb_shadow+0
;             --- labels ---
;             {block enter}
;               --- records ---
;               --- variables ---
;               --- labels ---
;             {block exit}
;           {block exit}
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             66d7d8:_x_105 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=2) ---> _portb_shadow+0
;             --- labels ---
;             {block enter}
;               --- records ---
;               --- variables ---
;               --- labels ---
;             {block exit}
;           {block exit}
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           66e588:_x_106 bit (type=B dflags=---B- sz=1 use=0 assigned=2 bit=1) ---> _portb_shadow+0
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
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             61c7d8:_x_107 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=5) ---> _portb_shadow+0
;             --- labels ---
;             {block enter}
;               --- records ---
;               --- variables ---
;               --- labels ---
;             {block exit}
;           {block exit}
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             670ce8:_x_108 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=5) ---> _portb_shadow+0
;             --- labels ---
;             {block enter}
;               --- records ---
;               --- variables ---
;               --- labels ---
;             {block exit}
;           {block exit}
;         {block exit}
;         {block enter}
;           --- records ---
;           --- variables ---
;           671b18:_x_109 bit (type=B dflags=---B- sz=1 use=0 assigned=2 bit=4) ---> _portb_shadow+0
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
;           672e88:__btemp163  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=16) ---> _bitbucket+0
;           --- labels ---
;           {block enter}
;             --- records ---
;             --- variables ---
;             6735d8:__btemp164  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=17) ---> _bitbucket+0
;             --- labels ---
;             {block enter}
;               --- records ---
;               --- variables ---
;               673a08:_x_110 bit (type=B dflags=---B- sz=1 use=0 assigned=2 bit=7) ---> _portb_shadow+0
;               --- labels ---
;               {block enter}
;                 --- records ---
;                 --- variables ---
;                 --- labels ---
;               {block exit}
;             {block exit}
;           {block exit}
;         {block exit}
;       {block exit}
;     {block exit}
;   {block exit}
;      console --D-- -U- (frame_sz=72 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        641108:_cmd byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=006a)
;        641278:__btemp_50  (type=i dflags=---B- sz=3 use=0 assigned=0 bit=0) ---> ___bitbucket1+0
;        641348:__btemp149  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket1+0
;        63c948:__bitbucket_1  (type=i dflags=----- auto sz=1 use=1 assigned=2 base=006c)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          641a38:__btemp150  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> ___bitbucket1+0
;          6426f8:__btemp151  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> ___bitbucket1+0
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            643c78:_cstr2  (type=a dflags=----- auto sz=16 use=0 assigned=16 base=00bd)
;            648188:_cstr4  (type=a dflags=----- auto sz=15 use=0 assigned=15 base=00da)
;            64bab8:_cstr3  (type=a dflags=----- auto sz=7 use=0 assigned=7 base=00e9)
;            64ea98:_cstr5  (type=a dflags=----- auto sz=19 use=0 assigned=19 base=0110)
;            6537c8:_cstr6  (type=a dflags=----- auto sz=13 use=0 assigned=13 base=0123)
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            6576d8:_cstr1  (type=a dflags=----- auto sz=9 use=0 assigned=9 base=00bd)
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      csvdump --D-- -U- (frame_sz=1 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        63e838:_chr_2 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0130)
;        63ef58:__btemp_49  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        63e8e8:__btemp148  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        63f658:__temp_68  (type=? dflags=C---- sz=0 use=1 assigned=0)
;         = 0
;        63bdb8:__bitbucket_2  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      csvoutput ----- --- (frame_sz=0 blocks=8)
;      {block enter}
;        --- records ---
;        --- variables ---
;        6323b8:_flag_1  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        632458:_chr_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        633eb8:__temp_67  (type=i dflags=C---- sz=2 use=5 assigned=0)
;         = 0
;        6341a8:_magic  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        6348d8:_step  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        634f08:_valid  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        636de8:__btemp_48  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;         = 0
;        636eb8:__btemp143  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        63ab58:__bitbucket_3  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          639f08:__btemp144  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            63a718:_x_101  (type=i dflags=C---- sz=1 use=0 assigned=0)
;             = 0
;            63af88:__btemp145  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              63b628:__btemp146  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                63c4c8:__btemp147  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;                --- labels ---
;                {block enter}
;                  --- records ---
;                  --- variables ---
;                  --- labels ---
;                {block exit}
;              {block exit}
;            {block exit}
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      csvreset ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        63a638:__bitbucket_4  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      csvlog ----- --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        62a938:_flag  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        62ad98:__temp_66  (type=i dflags=C---- sz=1 use=1 assigned=0)
;         = 0
;        62be98:__btemp_47  (type=i dflags=C--B- sz=11 use=0 assigned=0 bit=0)
;         = 0
;        62ee18:__btemp138  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
;        62ff98:__btemp139  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=7)
;        623f78:__btemp140  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=8)
;        6305b8:__btemp141  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=9)
;        630e58:__btemp142  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=10)
;        638498:__bitbucket_5  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          62bf68:__btemp132  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          62c688:__btemp133  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          62cc08:__btemp134  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          62d2b8:__btemp135  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          62d798:__btemp136  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;          62dc78:__btemp137  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      read_byte_from_eeprom --D-- -U- (frame_sz=4 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        626f38:_addr_1 word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0132)
;        627108:_chr byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0136)
;        6271a8:_ret_1  (type=B dflags=C--B- sz=1 use=0 assigned=4 bit=0)
;         = 0
;        627558:__btemp_46  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;         = 0
;        627628:__btemp128  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        627ca8:__btemp129  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        627f38:__temp_65  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0138)
;        6288f8:__btemp130  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        629428:__btemp131  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;        638258:__bitbucket_6  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      readpcf8574 ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        624928:_data_60  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        6249e8:_ret  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        624d98:__btemp_45  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        624e68:__btemp127  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        6254c8:__temp_64  (type=? dflags=C---- sz=0 use=1 assigned=0)
;         = 0
;        637f38:__bitbucket_7  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      vloersensor --D-- -U- (frame_sz=2 blocks=9)
;      {block enter}
;        --- records ---
;        --- variables ---
;        61e818:_sensortmp word (type=i dflags=----- auto sz=2 use=8 assigned=4 base=006a)
;        61fa78:__temp_63  (type=? dflags=C---- sz=0 use=4 assigned=0)
;         = 0
;        6214b8:__btemp_44  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        621588:__btemp125  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        622d08:__btemp126  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        637cf8:__bitbucket_8  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          61ed48:_x_99 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=4) ---> _porta_shadow+0
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
;          620428:_x_100 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=4) ---> _porta_shadow+0
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
;      behavewaitstart --D-- -U- (frame_sz=8 blocks=59)
;      {block enter}
;        --- records ---
;        --- variables ---
;        6053a8:_id_17 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=006a)
;        605498:_tmp byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=006c)
;        605668:__btemp_43  (type=i dflags=---B- sz=14 use=0 assigned=0 bit=0) ---> ___bitbucket9+0
;        605738:__btemp111  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> ___bitbucket9+0
;        606468:__btemp112  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> ___bitbucket9+0
;        607318:__btemp113  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> ___bitbucket9+0
;        608128:__btemp114  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> ___bitbucket9+0
;        608c48:__btemp115  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> ___bitbucket9+0
;        609348:__temp_62  (type=i dflags=----- auto sz=4 use=4 assigned=5 base=00bd)
;        637ab8:__bitbucket_9  (type=i dflags=----- auto sz=2 use=1 assigned=2 base=00d2)
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
;          609cd8:__btemp116  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> ___bitbucket9+0
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              60a578:_x_78 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=3) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              60af98:_x_79 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=7) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              60ba28:_x_80 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=6) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              60c6e8:_x_81 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=3) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              60c5d8:_x_82 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=7) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              60d998:_x_83 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=6) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          60e6e8:__btemp117  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=6) ---> ___bitbucket9+0
;          611988:__btemp120  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=9) ---> ___bitbucket9+0
;          613ef8:__btemp121  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=10) ---> ___bitbucket9+0
;          616538:__btemp122  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=11) ---> ___bitbucket9+0
;          618a28:__btemp123  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=12) ---> ___bitbucket9+0
;          61aef8:__btemp124  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=13) ---> ___bitbucket9+0
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            60fa98:__btemp118  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> ___bitbucket9+0
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              51dfa8:__btemp119  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=8) ---> ___bitbucket9+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              612178:_x_84 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=3) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              612a98:_x_85 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=7) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              613498:_x_86 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=6) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              614678:_x_87 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=3) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              614f98:_x_88 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=7) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              6158e8:_x_89 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=6) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              616bf8:_x_90 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=3) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              617648:_x_91 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=7) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              617f68:_x_92 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=6) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              619178:_x_93 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=3) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              619a98:_x_94 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=7) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              61a498:_x_95 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=6) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              61b678:_x_96 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=3) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              61bf98:_x_97 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=7) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              61c8e8:_x_98 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=6) ---> _portb_shadow+0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;        {block exit}
;      {block exit}
;      behavesideview ----- --- (frame_sz=0 blocks=7)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5fedc8:_id_15  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5fee88:_sidelr  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5ff108:__temp_61  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5ff9c8:__btemp_42  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;         = 0
;        5ffa98:__btemp107  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        6007f8:__btemp108  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        601998:__btemp109  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        6025f8:__btemp110  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;        637878:__bitbucket_10  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          --- labels ---
;        {block exit}
;      {block exit}
;      behaveavoid --D-- -U- (frame_sz=3 blocks=6)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5f7aa8:_id_13 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=006a)
;        5f7ca8:__btemp_41  (type=i dflags=---B- sz=10 use=0 assigned=0 bit=0) ---> ___bitbucket11+0
;        5f7d78:__btemp97  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket11+0
;        5f8418:__btemp98  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=1) ---> ___bitbucket11+0
;        5f87d8:__btemp99  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> ___bitbucket11+0
;        5f9788:__btemp100  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> ___bitbucket11+0
;        5fa408:__temp_60  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5fab38:__btemp101  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> ___bitbucket11+0
;        5fae98:__btemp102  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=5) ---> ___bitbucket11+0
;        5fb278:__btemp103  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=6) ---> ___bitbucket11+0
;        5fc328:__btemp104  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=7) ---> ___bitbucket11+0
;        5fc688:__btemp105  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=8) ---> ___bitbucket11+0
;        5fc948:__btemp106  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=9) ---> ___bitbucket11+0
;        637638:__bitbucket_11  (type=i dflags=----- auto sz=2 use=9 assigned=18 base=006c)
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
;      {block exit}
;      behavetrackshort ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5f72f8:_id_11  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        636688:__bitbucket_12  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      behavetrackcyclop ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5f54d8:_id_9  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5f5748:__btemp_40  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5f5818:__btemp96  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        636448:__bitbucket_13  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      behavespottarget ----- --- (frame_sz=0 blocks=7)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5ef448:_id_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5ef6b8:__btemp_39  (type=i dflags=C--B- sz=7 use=0 assigned=0 bit=0)
;         = 0
;        5ef788:__btemp89  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5efd88:__btemp90  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5decf8:__btemp91  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5f0f98:__temp_59  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        635e28:__bitbucket_14  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5f0798:__btemp92  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          5f1b88:__btemp93  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;          5f2bf8:__btemp94  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;          5f3858:__btemp95  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
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
;      behavetracklong ----- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5e9348:_id_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e9408:_frontlr  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e96b8:__temp_58  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5ea6a8:__btemp_38  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;         = 0
;        5ea778:__btemp85  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5eb378:__btemp86  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5ec688:__btemp87  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5ed968:__btemp88  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;        635be8:__bitbucket_15  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      behavecruise ----- --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5e4f58:_id_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e5168:__btemp_37  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        5e5238:__btemp82  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5e6208:__temp_57  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5e6ae8:__btemp83  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5e7ca8:__btemp84  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        6355c8:__bitbucket_16  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      behaveseek ----- --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5e2ad8:_id_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        635388:__bitbucket_17  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      batterycheck --D-- -U- (frame_sz=2 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5dd3b8:_battery word (type=i dflags=----- auto sz=2 use=6 assigned=6 base=006a)
;        5de9d8:_bstr1  (type=a dflags=C---- lookup sz=10 use=1 assigned=0)
;         = 98,97,116,116,101,114,105,106,58,32
;        5de108:__temp_56  (type=? dflags=C---- sz=0 use=3 assigned=0)
;         = 0
;        634d88:__bitbucket_18  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      buttons --D-- -U- (frame_sz=1 blocks=7)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5d7108:__temp_55  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=006a)
;        5d7558:__btemp_36  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;         = 0
;        5d7628:__btemp77  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5d8cb8:__btemp78  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        634758:__bitbucket_19  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          5da6b8:__btemp79  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          5dae28:__btemp80  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          5db728:__btemp81  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;      pwm2_set_percent_dutycycle ----- --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5bb2d8:_percent_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5bef98:_duty_13  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5c4f88:__btemp_35  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        5c7f48:__btemp75  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5d0ce8:__btemp76  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5d1608:__temp_54  (type=i dflags=C---- sz=6 use=0 assigned=0)
;         = 0
;        633a68:__bitbucket_20  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      pwm2_set_dutycycle ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5cf528:_duty_12  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5cf738:__temp_53  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        633b38:__bitbucket_21  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm2_set_dutycycle_lowres ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5cdb58:_duty_10  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5cdea8:__temp_52  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        6336d8:__bitbucket_22  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm2_set_dutycycle_highres --D-- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5cb188:_duty_8  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5cb3f8:__btemp_34  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5cb4c8:__btemp74  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5cc528:__temp_51  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        633498:__bitbucket_23  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        633258:__bitbucket_24  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm2_on --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        632ed8:__bitbucket_25  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_set_percent_dutycycle ----- --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c3c38:_percent_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c3d08:_duty_6  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5c3f78:__btemp_33  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        5c4108:__btemp72  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5c4e38:__btemp73  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5c5708:__temp_50  (type=i dflags=C---- sz=6 use=0 assigned=0)
;         = 0
;        632c98:__bitbucket_26  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      pwm1_set_dutycycle ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c2748:_duty_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c2958:__temp_49  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        632a58:__bitbucket_27  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_set_dutycycle_lowres ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c0cc8:_duty_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c1108:__temp_48  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        632818:__bitbucket_28  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_set_dutycycle_highres --D-- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5be468:_duty_1  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5be6d8:__btemp_32  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5be7a8:__btemp71  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5bf818:__temp_47  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        632558:__bitbucket_29  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        630868:__bitbucket_30  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_on --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        630738:__bitbucket_31  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm_set_frequency ----- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5b51f8:_freq_1  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        5b5498:__temp_46  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5b6698:__btemp_31  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;         = 0
;        5b6768:__btemp66  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5b6c88:__btemp67  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5b7108:__btemp68  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        62dfa8:__bitbucket_32  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5b7908:__btemp69  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          5b85d8:__btemp70  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;        5b08e8:_prescaler_1 byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=006a)
;        5b0fa8:__temp_45  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5b19e8:__btemp_30  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        5b1ab8:__btemp63  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5b2c38:__btemp64  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5b39f8:__btemp65  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        624108:__bitbucket_33  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      i2c_receive_byte --D-- -U- (frame_sz=2 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a91b8:_ack_1 bit (type=B dflags=---B- sz=1 use=1 assigned=1 bit=0) ---> ___bitbucket34+0
;        5a9288:_data_58 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=013a)
;        5a9898:__btemp_29  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        5a9968:__btemp60  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5aa108:__btemp61  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5aacb8:__btemp62  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5343a8:__bitbucket_34  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=013c)
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
;      i2c_transmit_byte --D-- -U- (frame_sz=1 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a6328:_data_57 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=013a)
;        5a6ca8:__btemp_28  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        5a6d78:__btemp58  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5a76f8:__btemp59  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        62ecf8:__bitbucket_35  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      i2c_stop --D-- -U- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a52e8:__btemp_27  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5a53b8:__btemp57  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        62e398:__bitbucket_36  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      i2c_restart --D-- -U- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a3d48:__btemp_26  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5a3e18:__btemp56  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        62cd08:__bitbucket_37  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      i2c_start --D-- -U- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a29d8:__btemp_25  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5a2aa8:__btemp55  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        62c788:__bitbucket_38  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      i2c_initialize ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        62c108:__bitbucket_39  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      isr ----- --I (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        59b5a8:__btemp_24  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        59b678:__btemp52  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        59c108:__temp_44  (type=i dflags=----- sticky sz=3 use=3 assigned=3 base=003c)
;        62b5d8:__bitbucket_40  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          59c838:_index byte (type=i dflags=----- sticky sz=1 use=5 assigned=2 base=003f)
;          59ee88:__btemp54  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            59d688:__btemp53  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
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
;        593938:_timer0_div dword (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 4999
;        5995e8:_i_1 byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=006a)
;        599f18:__temp_43  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=006c)
;        59a8a8:__btemp_23  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        59a978:__btemp51  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        62af68:__bitbucket_41  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5901f8:_slot_3 byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=00d5)
;        590418:__btemp_22  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        5904e8:__btemp48  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        591108:__temp_42  (type=i dflags=----- auto sz=2 use=2 assigned=2 base=00d7)
;        591648:__btemp49  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        625698:__bitbucket_42  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          592398:__btemp50  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
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
;        58f4a8:_slot_1 byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=00d5)
;        58f568:_ticks_1 word (type=i dflags=----- auto sz=2 use=2 assigned=4 base=00d7)
;        58f788:__btemp_21  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        58f858:__btemp47  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        561bb8:__temp_41  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00d9)
;        624f68:__bitbucket_43  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        58df88:_temp word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=00d5)
;        603638:__bitbucket_44  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_init ----L --- (frame_sz=0 blocks=12)
;      {block enter}
;        --- records ---
;        --- variables ---
;        603d28:__bitbucket_45  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            575dc8:_no_vref_2  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;             = 0
;            575c38:_one_vref_2  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;             = 0
;            576458:_two_vref_2  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;             = 0
;            --- labels ---
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          57b178:_jallib_adfm_1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> adcon1+0
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          57bbe8:_jallib_adcs_lsb_1  (type=i dflags=-V-B- alias sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;          57bc78:_jallib_adcs_msb_1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> adcon1+0
;          57bd08:_adcs_1  (type=i dflags=CV-B- sz=3 use=0 assigned=0 bit=0)
;           = 0
;          57bd98:__btemp_19  (type=i dflags=C--B- sz=12 use=0 assigned=0 bit=0)
;           = 0
;          57be28:__btemp34_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          57beb8:__btemp35_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          57bf48:__btemp36_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          57b2e8:__btemp37_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          57c108:__btemp38_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;          57c198:__btemp39_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;          57c228:__btemp40_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
;          57c2b8:__btemp41_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=7)
;          57c348:__btemp42_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=8)
;          57c3d8:__btemp43_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=9)
;          57c468:__btemp44_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=10)
;          57c4f8:__btemp45_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=11)
;          57c588:_adcs_lsb_1  (type=i dflags=-V-B- sz=2 use=0 assigned=0 base=0000 bit=0)
;          57c618:_adcs_msb_1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 base=0000 bit=2)
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
;        603748:__bitbucket_46  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5709c8:_no_vref_1  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;           = 0
;          570a58:_one_vref_1  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;           = 0
;          570ae8:_two_vref_1  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;           = 0
;          --- labels ---
;        {block exit}
;      {block exit}
;      _adc_init_acquisition_delay ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        56f628:_adc_tc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 17
;        56f388:_adc_tcoff byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 2
;        6032e8:__bitbucket_47  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_init_justify ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        56dc88:_jallib_adfm bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> adcon1+0
;        6024d8:__bitbucket_48  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_read_low_res ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        569548:_adc_chan_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56b708:_adc_value  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56b868:_shift_alias  (type=i dflags=C---- sz=2 use=3 assigned=0)
;         = 0
;        56ba48:_ax_2  (type=a dflags=----- sz=2 use=0 assigned=0) ---> shift_alias
;        56c538:__temp_40  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        601878:__bitbucket_49  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_read_bytes ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5699c8:_adc_chan_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        569a88:_adc_hbyte_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        569b48:_adc_lbyte_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        569c18:_ad_value_1  (type=i dflags=C---- sz=2 use=1 assigned=0)
;         = 0
;        569cd8:_ax_1  (type=a dflags=----- sz=2 use=0 assigned=0) ---> __ad_value1
;        569f48:__temp_39  (type=? dflags=C---- sz=0 use=1 assigned=0)
;         = 0
;        601378:__bitbucket_50  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_read --D-- -U- (frame_sz=3 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        565f78:_adc_chan_3 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00bd)
;        567108:_ad_value word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=006e)
;        568108:_ax  (type=a dflags=----- sz=2 use=0 assigned=2) ---> ad_value+0
;        5f5fa8:__bitbucket_51  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_read_low_res --D-- -U- (frame_sz=2 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        564ad8:_adc_chan_1 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00d1)
;        564b68:_adc_byte_1 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00d2)
;        566108:__btemp_18  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        566bc8:__btemp46  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5ff8c8:__bitbucket_52  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      _adc_init_clock ----L --- (frame_sz=0 blocks=7)
;      {block enter}
;        --- records ---
;        --- variables ---
;        55a498:_jallib_adcs_lsb  (type=i dflags=-V-B- alias sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;        55a338:_adc_adcs_bit_long byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 3
;        55a7d8:_adc_adcs_bit_split bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 1
;        55ab68:_jallib_adcs_msb bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> adcon1+0
;        55a708:_adcs  (type=i dflags=CV-B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        55bde8:__btemp_17  (type=i dflags=C--B- sz=12 use=0 assigned=0 bit=0)
;         = 0
;        55bcd8:__btemp34  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        55c2a8:__btemp35  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        55ccf8:__btemp36  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        55d108:__btemp37  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;        55db58:__btemp38  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;        55de58:__btemp39  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;        55ea08:__btemp40  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
;        55ed08:__btemp41  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=7)
;        55f908:__btemp42  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=8)
;        55fc08:__btemp43  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=9)
;        560478:__btemp44  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=10)
;        560778:__btemp45  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=11)
;        561528:_adcs_lsb  (type=i dflags=-V-B- sz=2 use=0 assigned=0 base=0000 bit=0)
;        561718:_adcs_msb bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5f5648:__bitbucket_53  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          --- labels ---
;        {block exit}
;      {block exit}
;      _adc_eval_tad --D-- -U- (frame_sz=5 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        54b608:_factor_1 word (type=i dflags=----- auto sz=2 use=2 assigned=12 base=006a)
;        54b708:_tad_ok bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket54+0
;        5575e8:__temp_38  (type=i dflags=----- auto sz=2 use=2 assigned=2 base=00bd)
;        558528:__btemp_16  (type=i dflags=---B- sz=3 use=0 assigned=0 bit=1) ---> ___bitbucket54+0
;        5585f8:__btemp31  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=1) ---> ___bitbucket54+0
;        558b68:__btemp32  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> ___bitbucket54+0
;        558f18:__btemp33  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket54+0
;        5f6588:__bitbucket_54  (type=i dflags=----- auto sz=1 use=4 assigned=8 base=00cd)
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
;        5f6238:__bitbucket_55  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_setup_pins ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        54b968:_adc_pcfg_map  (type=a dflags=C---- sz=18 use=4 assigned=0)
;         = 6,0,0,14,0,0,0,0,0,4,0,15,0,5,13,9,10,8
;        544868:_no_vref  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;         = 0
;        54acd8:_one_vref  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;         = 0
;        54aea8:_two_vref  (type=i dflags=C--B- sz=4 use=0 assigned=0 bit=0)
;         = 0
;        54a758:_idx byte (type=i dflags=C---- sz=1 use=2 assigned=0)
;         = 15
;        5f4808:__bitbucket_56  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_vref_adref ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5f44b8:__bitbucket_57  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_vref_vcfg ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5443e8:_vcfg_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5f2768:__bitbucket_58  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_raw_get ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5f0e98:__bitbucket_59  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_raw_put ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5426e8:_data_55  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5ef5b8:__bitbucket_60  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_get ----- --- (frame_sz=0 blocks=6)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4eecb8:_data_53  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        530c48:__btemp_15  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        532278:__btemp29  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        541488:__btemp30  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5e95b8:__bitbucket_61  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53f6d8:_data_52 byte (type=i dflags=----- auto sticky sz=1 use=1 assigned=1 base=0040)
;        5ee378:__bitbucket_62  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_read --D-- -U- (frame_sz=2 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        53d418:_data_50 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0130)
;        53d588:__btemp_14  (type=i dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> ___bitbucket63+0
;        53d658:__btemp28  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket63+0
;        5edf08:__bitbucket_63  (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0132)
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
;        53b1f8:_data_48  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5ed308:__bitbucket_64  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        538dd8:_data_46  (type=i dflags=C---- sz=2 use=2 assigned=0)
;         = 0
;        538e98:_dx  (type=a dflags=----- sz=2 use=0 assigned=0) ---> __data46
;        539258:__btemp_13  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        539328:__btemp26  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        53a108:__btemp27  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5ece18:__bitbucket_65  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        537798:_data_44 byte (type=i dflags=----- auto sticky sz=1 use=1 assigned=1 base=0041)
;        537a28:__btemp_12  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        537af8:__btemp25  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5ec538:__bitbucket_66  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5ebf58:__bitbucket_67  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_disable ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        535b68:__btemp_11  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        535c38:__btemp24  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5ebc08:__bitbucket_68  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5eb1f8:__bitbucket_69  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _calculate_and_set_baudrate --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        531738:_max_deviation  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 5
;        5285d8:_usart_div  (type=i dflags=C---U sz=4 use=1 assigned=0)
;         = 10
;        531d38:_real_baud  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 113636
;        5ea508:__bitbucket_70  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_dec --D-- -U- (frame_sz=3 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5278e8:__device_put_19  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=4 base=0130)
;        5279a8:_data_38 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0134)
;        5e9c08:__bitbucket_71  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_word_dec --D-- -U- (frame_sz=4 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        526958:__device_put_18  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=10 base=0130)
;        526a18:_data_36 word (type=i dflags=----- auto sz=2 use=2 assigned=10 base=0134)
;        5e9798:__bitbucket_72  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_dword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5259d8:__device_put_17  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        525a98:_data_34  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        662978:__bitbucket_73  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sbyte_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        524a48:__device_put_16  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        524b08:_data_32  (type=i dflags=C-S-- sz=1 use=0 assigned=0)
;         = 0
;        5e7ba8:__bitbucket_74  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_fp_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        522818:__device_put_15  (type=* dflags=C---- sz=2 use=0 assigned=1)
;         = 0
;        5228d8:_data_30  (type=i dflags=C-S-- sz=2 use=0 assigned=0)
;         = 0
;        522c38:__temp_35  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5e7e08:__bitbucket_75  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sword_dec --D-- -U- (frame_sz=4 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        521878:__device_put_14  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=4 base=0130)
;        521938:_data_28 sword (type=i dflags=--S-- auto sz=2 use=4 assigned=4 base=0134)
;        5e7838:__bitbucket_76  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_sdword_dec ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5208f8:__device_put_13  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        520988:_data_26  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        5e74e8:__bitbucket_77  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_hex --D-- -U- (frame_sz=5 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        51e188:__device_put_12  (type=* dflags=----- auto ptr_ptr sz=2 use=8 assigned=12 base=0132)
;        51e218:_data_24 byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=0136)
;        51ef48:__temp_34  (type=i dflags=----- auto sz=2 use=3 assigned=3 base=0138)
;        5e69b8:__bitbucket_78  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        51a4a8:__device_put_11  (type=* dflags=----- auto ptr_ptr sz=2 use=12 assigned=2 base=006a)
;        51a538:_data_22 word (type=i dflags=----- auto sz=2 use=6 assigned=3 base=00bd)
;        51b398:__temp_33  (type=i dflags=----- auto sz=4 use=9 assigned=16 base=00cd)
;        5e6108:__bitbucket_79  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        513eb8:__device_put_10  (type=* dflags=C---- sz=2 use=0 assigned=10)
;         = 0
;        513f48:_data_20  (type=i dflags=C-S-- sz=4 use=0 assigned=0)
;         = 0
;        514d58:__temp_32  (type=i dflags=C---- sz=8 use=0 assigned=0)
;         = 0
;        5e58d8:__bitbucket_80  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        50dcb8:__device_put_9  (type=* dflags=C---- sz=2 use=0 assigned=10)
;         = 0
;        50dd78:_data_18  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        50eb78:__temp_31  (type=i dflags=C---- sz=8 use=0 assigned=0)
;         = 0
;        5e3478:__bitbucket_81  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        50a2f8:__device_put_8  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        50a3b8:_data_16  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        50a5b8:__floop6  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        50ae28:__temp_30  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        50b5a8:__btemp_8  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        50ce88:__btemp17  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5e3c68:__bitbucket_82  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          50b678:__btemp16  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;        504188:__device_put_6  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        504248:_data_12  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        504e98:__temp_28  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e3588:__bitbucket_83  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        501568:__device_put_5  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        501628:_data_10  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        502348:__temp_27  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e2ec8:__bitbucket_84  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4fb928:__device_put_4  (type=* dflags=C---- sz=2 use=0 assigned=2)
;         = 0
;        500108:_data_8  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5d2f68:__bitbucket_85  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4fcf98:__device_put_3  (type=* dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4fd428:_data_6  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        4feef8:_str1_1  (type=a dflags=C---- sz=4 use=0 assigned=0)
;         = 104,105,103,104
;        4fedc8:_str0_1  (type=a dflags=C---- sz=3 use=0 assigned=0)
;         = 108,111,119
;        5d2e38:__bitbucket_86  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      print_bit_truefalse --D-- -U- (frame_sz=3 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4f93d8:__device_put_2  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=2 base=0130)
;        4fcbc8:_data_4 bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket87+0
;        4fd1b8:_str1  (type=a dflags=C---- lookup sz=4 use=1 assigned=0)
;         = 116,114,117,101
;        4fd578:_str0  (type=a dflags=C---- lookup sz=5 use=1 assigned=0)
;         = 102,97,108,115,101
;        5d2788:__bitbucket_87  (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0134)
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
;        4f8ac8:__device_put_1  (type=* dflags=----- auto ptr_ptr sz=2 use=2 assigned=24 base=0136)
;        4f8bb8:__str_count  (type=i dflags=----- auto sz=2 use=2 assigned=24 base=013a)
;        4f8ca8:_str_1  (type=* dflags=----- auto ptr_ptr ptr_lookup sz=2 use=2 assigned=24 base=0140)
;        4f8d98:_len word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0142)
;        4f8e88:_i byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=0148)
;        4f91f8:__btemp_6  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        4f9108:__btemp13  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5d2628:__bitbucket_88  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4f87f8:__device_put  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=18 base=0132)
;        5d2388:__bitbucket_89  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      print_byte_binary --D-- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        505e08:__device_put_7  (type=* dflags=C---- sz=2 use=0 assigned=4)
;         = 0
;        505ec8:_data_14  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        506a48:__floop5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5073c8:__temp_29  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        507a18:__btemp_7  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        509518:__btemp15  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5d1f58:__bitbucket_90  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          507ae8:__btemp14  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
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
;        528808:__device_put_20  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=2 base=0138)
;        5288c8:_data_40 sdword (type=i dflags=--S-- auto sz=4 use=17 assigned=12 base=013c)
;        528988:_digit_divisor_3 sdword (type=i dflags=--S-- auto sz=4 use=4 assigned=4 base=0144)
;        528a48:_digit_number_3 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0149)
;        528ce8:__btemp_9  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        528db8:__btemp18  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5295d8:__temp_36  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5d2228:__bitbucket_91  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        52ac68:__device_put_21  (type=* dflags=----- auto ptr_ptr sz=2 use=4 assigned=6 base=014a)
;        52ad28:_data_42 dword (type=i dflags=----- auto sz=4 use=8 assigned=16 base=014c)
;        52ade8:_digit_divisor_5 sdword (type=i dflags=--S-- auto sz=4 use=12 assigned=16 base=0150)
;        52aea8:_digit_number_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0154)
;        52af98:_digit byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=0155)
;        52a2b8:_no_digits_printed_yet bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket92+0
;        52b2c8:__btemp_10  (type=i dflags=---B- sz=5 use=0 assigned=0 bit=1) ---> ___bitbucket92+0
;        52b398:__btemp19  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> ___bitbucket92+0
;        52c708:__btemp20  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> ___bitbucket92+0
;        52ce58:__temp_37  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0156)
;        5d14d8:__bitbucket_92  (type=i dflags=----- auto sz=1 use=4 assigned=8 base=0157)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          52e448:__btemp21  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket92+0
;          52e9c8:__btemp22  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> ___bitbucket92+0
;          52ed88:__btemp23  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=5) ---> ___bitbucket92+0
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
;        4f4ac8:_char_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4f4d38:__btemp_5  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        4f4e08:__btemp10  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        4f55b8:__btemp11  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        4f5978:__btemp12  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        4f6238:__temp_26  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5d0bc8:__bitbucket_93  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4f1f38:_char_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4f2208:__btemp_4  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        4f22d8:__btemp7  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        4f28d8:__btemp8  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        4f2c98:__btemp9  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        4f35d8:__temp_25  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5d0658:__bitbucket_94  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4ed2f8:_n_7  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4ed898:__1_s_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 999998
;        4ed4e8:__floop4  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4ed6c8:__btemp_3  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        4ee598:__btemp6  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5cfcb8:__bitbucket_95  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4eb3e8:_n_5  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4eb928:__100_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 99998
;        4eb578:__floop3  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4eb758:__btemp_2  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        4ec648:__btemp5  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5cfb88:__bitbucket_96  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4e9268:_n_3  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4e97a8:__one_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 998
;        4e93f8:__floop2  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4ea108:__btemp_1  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        4e95d8:__btemp4  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5cf818:__bitbucket_97  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4e3bf8:_n_1 byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=00d4)
;        4e3e28:__btemp  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        4e3ef8:__btemp1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        4e4968:__btemp2  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        4e4f68:__temp_24  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5ce788:__bitbucket_98  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          4e5418:__ten_us_delay1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 7
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          4e6a98:__ten_us_delay2  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 5
;          4e75c8:__ten_us_delay3  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 9
;          4e66e8:__floop1  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=00d5)
;          4e7f58:__btemp3  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
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
;        5cdd78:__bitbucket_99  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_8us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5ccc78:__bitbucket_100  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_7us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5cc3f8:__bitbucket_101  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_6us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5cbb68:__bitbucket_102  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_5us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5cb2f8:__bitbucket_103  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_4us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5ca478:__bitbucket_104  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_3us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c6e08:__bitbucket_105  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_2us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c6f08:__bitbucket_106  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_1us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c6858:__bitbucket_107  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      enable_digital_io ----L --- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c66f8:__bitbucket_108  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5c6458:__bitbucket_109  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c6108:__bitbucket_110  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d1498:__temp_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c62f8:__bitbucket_111  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cfc98:_x_73  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4cffa8:__temp_22  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5c55d8:__bitbucket_112  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cee68:__temp_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c4d18:__bitbucket_113  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cd3a8:_x_71  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4cd688:__temp_20  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5c47a8:__bitbucket_114  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ca8d8:__temp_19  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c2ed8:__bitbucket_115  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c8f48:_x_69  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4c92e8:__temp_18  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5c2da8:__bitbucket_116  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c8238:__temp_17  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c2a38:__bitbucket_117  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c66e8:_x_67  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4c69c8:__temp_16  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5c1938:__bitbucket_118  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c3c08:__temp_15  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c0ee8:__bitbucket_119  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c22f8:_x_65  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4c2608:__temp_14  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5bff68:__bitbucket_120  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c1498:__temp_13  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5bf6e8:__bitbucket_121  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4bf878:_x_63  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4bfb58:__temp_12  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5bee48:__bitbucket_122  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_c0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b6268:_x_61 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portc_shadow
;        5be5d8:__bitbucket_123  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b5108:_x_59 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _portc_shadow
;        5bd808:__bitbucket_124  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b3fa8:_x_57 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _portc_shadow
;        5ba4e8:__bitbucket_125  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b2f38:_x_55 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _portc_shadow
;        5b9e28:__bitbucket_126  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b1cf8:_x_53 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portc_shadow
;        5b98d8:__bitbucket_127  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b0b38:_x_51 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portc_shadow
;        5b92b8:__bitbucket_128  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4afb38:_x_49 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portc_shadow
;        5b8c38:__bitbucket_129  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4ae998:_x_47 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portc_shadow
;        5b84b8:__bitbucket_130  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4ad708:__temp_11  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5b7ee8:__bitbucket_131  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ab8f8:_x_45  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4abc38:__temp_10  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5b77e8:__bitbucket_132  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4aab08:__temp_9  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5b6b68:__bitbucket_133  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a8e98:_x_43  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4a9108:__temp_8  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5b6108:__bitbucket_134  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a7f18:_x_41  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5b59e8:__bitbucket_135  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5b5578:__bitbucket_136  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_b0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a62f8:_x_39 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portb_shadow+0
;        5a0518:__bitbucket_137  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a5268:_x_37 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _portb_shadow+0
;        5a0c38:__bitbucket_138  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a4268:_x_35 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _portb_shadow+0
;        5948a8:__bitbucket_139  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a32f8:_x_33 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _portb_shadow+0
;        597588:__bitbucket_140  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a2268:_x_31 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portb_shadow+0
;        5964b8:__bitbucket_141  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a12f8:_x_29 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portb_shadow+0
;        596a88:__bitbucket_142  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a03a8:_x_27 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portb_shadow+0
;        5955b8:__bitbucket_143  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49f8b8:_x_25 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portb_shadow+0
;        595c88:__bitbucket_144  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49e708:__temp_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        593bd8:__bitbucket_145  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        49c8f8:_x_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        49cc38:__temp_6  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        56ce18:__bitbucket_146  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49bb08:__temp_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56c438:__bitbucket_147  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        499e98:_x_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        49a108:__temp_4  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        56bf08:__bitbucket_148  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        498f18:_x_19  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56bca8:__bitbucket_149  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        56aba8:__bitbucket_150  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_a0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4972f8:_x_17 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _porta_shadow+0
;        56a6f8:__bitbucket_151  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        496268:_x_15 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _porta_shadow+0
;        53a7a8:__bitbucket_152  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4951f8:_x_13 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _porta_shadow+0
;        5399f8:__bitbucket_153  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        493f38:_x_11 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _porta_shadow+0
;        525dc8:__bitbucket_154  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        492cf8:_x_9 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _porta_shadow+0
;        525cc8:__bitbucket_155  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        491b68:_x_7 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _porta_shadow+0
;        524e38:__bitbucket_156  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        490778:__temp_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        524d38:__bitbucket_157  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        48ec58:_x_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        48ef98:__temp_2  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        523ee8:__bitbucket_158  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        48df08:__temp_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        523de8:__bitbucket_159  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        48c188:_x_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        48c4b8:__temp  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        523b78:__bitbucket_160  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        48b348:_x_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        523a18:__bitbucket_161  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5236d8:__bitbucket_162  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
; --- call stack ---
; {root} (depth=0)
;   console (depth=1)
;     print_string (depth=2)
;     print_crlf (depth=2)
;     print_sword_dec (depth=2)
;       _print_suniversal_dec (depth=3)
;         _print_universal_dec (depth=4)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     print_sword_dec (depth=2)
;       _print_suniversal_dec (depth=3)
;         _print_universal_dec (depth=4)
;     print_string (depth=2)
;     print_crlf (depth=2)
;     print_word_dec (depth=2)
;       _print_universal_dec (depth=3)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     print_word_dec (depth=2)
;       _print_universal_dec (depth=3)
;     print_string (depth=2)
;     print_crlf (depth=2)
;     print_byte_hex (depth=2)
;     print_string (depth=2)
;     print_crlf (depth=2)
;     print_bit_truefalse (depth=2)
;       print_string (depth=3)
;       print_string (depth=3)
;     print_string (depth=2)
;     print_crlf (depth=2)
;     print_byte_dec (depth=2)
;       _print_universal_dec (depth=3)
;     print_string (depth=2)
;     csvdump (depth=2)
;       print_crlf (depth=3)
;       _serial_hw_data_put (depth=3)
;         serial_hw_write (depth=4)
;       print_byte_hex (depth=3)
;       read_byte_from_eeprom (depth=3)
;         i2c_stop (depth=4)
;         i2c_receive_byte (depth=4)
;         i2c_transmit_byte (depth=4)
;         i2c_restart (depth=4)
;         i2c_transmit_byte (depth=4)
;         i2c_transmit_byte (depth=4)
;         i2c_transmit_byte (depth=4)
;         i2c_start (depth=4)
;     serial_hw_read (depth=2)
;   batterycheck (depth=1)
;     print_crlf (depth=2)
;     print_byte_hex (depth=2)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     print_byte_hex (depth=2)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     print_word_dec (depth=2)
;       _print_universal_dec (depth=3)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     adc_read (depth=2)
;       _adc_read_low_res (depth=3)
;         delay_10us (depth=4)
;     print_word_dec (depth=2)
;       _print_universal_dec (depth=3)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     adc_read (depth=2)
;       _adc_read_low_res (depth=3)
;         delay_10us (depth=4)
;     print_word_dec (depth=2)
;       _print_universal_dec (depth=3)
;     adc_read (depth=2)
;       _adc_read_low_res (depth=3)
;         delay_10us (depth=4)
;     print_string (depth=2)
;   set_delay (depth=1)
;   check_delay (depth=1)
;   print_crlf (depth=1)
;   print_byte_dec (depth=1)
;     _print_universal_dec (depth=2)
;   print_string (depth=1)
;   behavewaitstart (depth=1)
;     set_delay (depth=2)
;     check_delay (depth=2)
;     _isr_counter_get (depth=2)
;   behaveavoid (depth=1)
;   print_crlf (depth=1)
;   print_byte_hex (depth=1)
;   print_string (depth=1)
;   vloersensor (depth=1)
;     adc_read (depth=2)
;       _adc_read_low_res (depth=3)
;         delay_10us (depth=4)
;     adc_read (depth=2)
;       _adc_read_low_res (depth=3)
;         delay_10us (depth=4)
;     delay_10us (depth=2)
;     adc_read (depth=2)
;       _adc_read_low_res (depth=3)
;         delay_10us (depth=4)
;     adc_read (depth=2)
;       _adc_read_low_res (depth=3)
;         delay_10us (depth=4)
;     delay_10us (depth=2)
;   buttons (depth=1)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     delay_10us (depth=2)
;   _isr_counter_get (depth=1)
;   _isr_counter_get (depth=1)
;   batterycheck (depth=1)
;     print_crlf (depth=2)
;     print_byte_hex (depth=2)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     print_byte_hex (depth=2)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     print_word_dec (depth=2)
;       _print_universal_dec (depth=3)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     adc_read (depth=2)
;       _adc_read_low_res (depth=3)
;         delay_10us (depth=4)
;     print_word_dec (depth=2)
;       _print_universal_dec (depth=3)
;     _serial_hw_data_put (depth=2)
;       serial_hw_write (depth=3)
;     adc_read (depth=2)
;       _adc_read_low_res (depth=3)
;         delay_10us (depth=4)
;     print_word_dec (depth=2)
;       _print_universal_dec (depth=3)
;     adc_read (depth=2)
;       _adc_read_low_res (depth=3)
;         delay_10us (depth=4)
;     print_string (depth=2)
;   print_string (depth=1)
;   pwm2_on (depth=1)
;   pwm1_on (depth=1)
;   pwm_max_resolution (depth=1)
;   timer0_isr_init (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_vref (depth=1)
;   print_word_hex (depth=1)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   print_byte_hex (depth=1)
;   _serial_hw_data_put (depth=1)
;     serial_hw_write (depth=2)
;   serial_hw_init (depth=1)
;     _calculate_and_set_baudrate (depth=2)
;Temporary Labels
;48a448:_l1(use=0:ref=2:pc=0000)
;48a4a8:_l2(use=0:ref=2:pc=0000)
;48af48:_l3(use=0:ref=2:pc=0000)
;48afa8:_l4(use=0:ref=2:pc=0000)
;48b998:_l5(use=0:ref=1:pc=0000)
;48be98:_l6(use=0:ref=2:pc=0000)
;48bef8:_l7(use=0:ref=2:pc=0000)
;48d618:_l8(use=0:ref=1:pc=0000)
;48da78:_l9(use=0:ref=2:pc=0000)
;48dad8:_l10(use=0:ref=2:pc=0000)
;48e918:_l11(use=0:ref=2:pc=0000)
;48e978:_l12(use=0:ref=2:pc=0000)
;48fcf8:_l13(use=0:ref=1:pc=0000)
;4902e8:_l14(use=0:ref=2:pc=0000)
;490348:_l15(use=0:ref=2:pc=0000)
;491828:_l16(use=0:ref=2:pc=0000)
;491888:_l17(use=0:ref=2:pc=0000)
;491f58:_l18(use=0:ref=1:pc=0000)
;4929b8:_l19(use=0:ref=2:pc=0000)
;492a18:_l20(use=0:ref=2:pc=0000)
;493218:_l21(use=0:ref=1:pc=0000)
;493bf8:_l22(use=0:ref=2:pc=0000)
;493c58:_l23(use=0:ref=2:pc=0000)
;494368:_l24(use=0:ref=1:pc=0000)
;494e28:_l25(use=0:ref=2:pc=0000)
;494e88:_l26(use=0:ref=2:pc=0000)
;4955e8:_l27(use=0:ref=1:pc=0000)
;495ee8:_l28(use=0:ref=2:pc=0000)
;495f48:_l29(use=0:ref=2:pc=0000)
;496658:_l30(use=0:ref=1:pc=0000)
;496f58:_l31(use=0:ref=2:pc=0000)
;496fb8:_l32(use=0:ref=2:pc=0000)
;4976e8:_l33(use=0:ref=1:pc=0000)
;497668:_l34(use=0:ref=2:pc=0000)
;497a78:_l35(use=0:ref=2:pc=0000)
;498bd8:_l36(use=0:ref=2:pc=0000)
;498c38:_l37(use=0:ref=2:pc=0000)
;499658:_l38(use=0:ref=1:pc=0000)
;499b58:_l39(use=0:ref=2:pc=0000)
;499bb8:_l40(use=0:ref=2:pc=0000)
;49b218:_l41(use=0:ref=1:pc=0000)
;49b678:_l42(use=0:ref=2:pc=0000)
;49b6d8:_l43(use=0:ref=2:pc=0000)
;49c5b8:_l44(use=0:ref=2:pc=0000)
;49c618:_l45(use=0:ref=2:pc=0000)
;49dde8:_l46(use=0:ref=1:pc=0000)
;49e278:_l47(use=0:ref=2:pc=0000)
;49e2d8:_l48(use=0:ref=2:pc=0000)
;49f578:_l49(use=0:ref=2:pc=0000)
;49f5d8:_l50(use=0:ref=2:pc=0000)
;49fca8:_l51(use=0:ref=1:pc=0000)
;49cfb8:_l52(use=0:ref=2:pc=0000)
;49c4e8:_l53(use=0:ref=2:pc=0000)
;4a0798:_l54(use=0:ref=1:pc=0000)
;4a0fb8:_l55(use=0:ref=2:pc=0000)
;4a04a8:_l56(use=0:ref=2:pc=0000)
;4a16e8:_l57(use=0:ref=1:pc=0000)
;4a1f08:_l58(use=0:ref=2:pc=0000)
;4a1f68:_l59(use=0:ref=2:pc=0000)
;4a2658:_l60(use=0:ref=1:pc=0000)
;4a2f58:_l61(use=0:ref=2:pc=0000)
;4a2fb8:_l62(use=0:ref=2:pc=0000)
;4a36e8:_l63(use=0:ref=1:pc=0000)
;4a3f08:_l64(use=0:ref=2:pc=0000)
;4a3f68:_l65(use=0:ref=2:pc=0000)
;4a4658:_l66(use=0:ref=1:pc=0000)
;4a4e78:_l67(use=0:ref=2:pc=0000)
;4a4ed8:_l68(use=0:ref=2:pc=0000)
;4a5658:_l69(use=0:ref=1:pc=0000)
;4a5f58:_l70(use=0:ref=2:pc=0000)
;4a5fb8:_l71(use=0:ref=2:pc=0000)
;4a66e8:_l72(use=0:ref=1:pc=0000)
;4a63f8:_l73(use=0:ref=2:pc=0000)
;4a6668:_l74(use=0:ref=2:pc=0000)
;4a7bd8:_l75(use=0:ref=2:pc=0000)
;4a7c38:_l76(use=0:ref=2:pc=0000)
;4a8658:_l77(use=0:ref=1:pc=0000)
;4a8b58:_l78(use=0:ref=2:pc=0000)
;4a8bb8:_l79(use=0:ref=2:pc=0000)
;4aa218:_l80(use=0:ref=1:pc=0000)
;4aa678:_l81(use=0:ref=2:pc=0000)
;4aa6d8:_l82(use=0:ref=2:pc=0000)
;4ab5b8:_l83(use=0:ref=2:pc=0000)
;4ab618:_l84(use=0:ref=2:pc=0000)
;4acde8:_l85(use=0:ref=1:pc=0000)
;4ad278:_l86(use=0:ref=2:pc=0000)
;4ad2d8:_l87(use=0:ref=2:pc=0000)
;4ae658:_l88(use=0:ref=2:pc=0000)
;4ae6b8:_l89(use=0:ref=2:pc=0000)
;4aed88:_l90(use=0:ref=1:pc=0000)
;4af7f8:_l91(use=0:ref=2:pc=0000)
;4af858:_l92(use=0:ref=2:pc=0000)
;4aff28:_l93(use=0:ref=1:pc=0000)
;4b07f8:_l94(use=0:ref=2:pc=0000)
;4b0858:_l95(use=0:ref=2:pc=0000)
;4b0f28:_l96(use=0:ref=1:pc=0000)
;4b19b8:_l97(use=0:ref=2:pc=0000)
;4b1a18:_l98(use=0:ref=2:pc=0000)
;4b2218:_l99(use=0:ref=1:pc=0000)
;4b2bf8:_l100(use=0:ref=2:pc=0000)
;4b2c58:_l101(use=0:ref=2:pc=0000)
;4b3368:_l102(use=0:ref=1:pc=0000)
;4b3c68:_l103(use=0:ref=2:pc=0000)
;4b3cc8:_l104(use=0:ref=2:pc=0000)
;4b4368:_l105(use=0:ref=1:pc=0000)
;4b4d48:_l106(use=0:ref=2:pc=0000)
;4b4da8:_l107(use=0:ref=2:pc=0000)
;4b54f8:_l108(use=0:ref=1:pc=0000)
;4b5ed8:_l109(use=0:ref=2:pc=0000)
;4b5f38:_l110(use=0:ref=2:pc=0000)
;4b6658:_l111(use=0:ref=1:pc=0000)
;4bf538:_l112(use=0:ref=2:pc=0000)
;4bf598:_l113(use=0:ref=2:pc=0000)
;4c0f08:_l114(use=0:ref=2:pc=0000)
;4c0f68:_l115(use=0:ref=2:pc=0000)
;4c1e68:_l116(use=0:ref=2:pc=0000)
;4c1ec8:_l117(use=0:ref=2:pc=0000)
;4c3778:_l118(use=0:ref=2:pc=0000)
;4c37d8:_l119(use=0:ref=2:pc=0000)
;4c63a8:_l120(use=0:ref=2:pc=0000)
;4c6408:_l121(use=0:ref=2:pc=0000)
;4c7cd8:_l122(use=0:ref=2:pc=0000)
;4c7d38:_l123(use=0:ref=2:pc=0000)
;4c8c08:_l124(use=0:ref=2:pc=0000)
;4c8c68:_l125(use=0:ref=2:pc=0000)
;4ca448:_l126(use=0:ref=2:pc=0000)
;4ca4a8:_l127(use=0:ref=2:pc=0000)
;4ccb28:_l128(use=0:ref=2:pc=0000)
;4ccc28:_l129(use=0:ref=2:pc=0000)
;4ce9d8:_l130(use=0:ref=2:pc=0000)
;4cea38:_l131(use=0:ref=2:pc=0000)
;4cf958:_l132(use=0:ref=2:pc=0000)
;4cf9b8:_l133(use=0:ref=2:pc=0000)
;4d0f08:_l134(use=0:ref=2:pc=0000)
;4d0f68:_l135(use=0:ref=2:pc=0000)
;4db268:_l136(use=0:ref=2:pc=0000)
;4db2c8:_l137(use=0:ref=2:pc=0000)
;4dc248:_l138(use=0:ref=2:pc=0000)
;4dc2a8:_l139(use=0:ref=2:pc=0000)
;4dccf8:_l140(use=0:ref=2:pc=0000)
;4dcd58:_l141(use=0:ref=2:pc=0000)
;4dd578:_l142(use=0:ref=1:pc=0000)
;4dd9c8:_l143(use=0:ref=1:pc=0000)
;4ded78:_l144(use=0:ref=2:pc=0000)
;4dedd8:_l145(use=0:ref=2:pc=0000)
;4df648:_l146(use=0:ref=2:pc=0000)
;4df6a8:_l147(use=0:ref=2:pc=0000)
;4dfde8:_l148(use=0:ref=2:pc=0000)
;4dfe48:_l149(use=0:ref=2:pc=0000)
;4e04f8:_l150(use=0:ref=2:pc=0000)
;4e0558:_l151(use=0:ref=2:pc=0000)
;4e0c98:_l152(use=0:ref=2:pc=0000)
;4e0cf8:_l153(use=0:ref=2:pc=0000)
;4e14f8:_l154(use=0:ref=2:pc=0000)
;4e1558:_l155(use=0:ref=2:pc=0000)
;4e1c98:_l156(use=0:ref=2:pc=0000)
;4e1cf8:_l157(use=0:ref=2:pc=0000)
;4e24f8:_l158(use=0:ref=2:pc=0000)
;4e2558:_l159(use=0:ref=2:pc=0000)
;4e2c98:_l160(use=0:ref=2:pc=0000)
;4e2cf8:_l161(use=0:ref=2:pc=0000)
;4e38b8:_l162(use=0:ref=2:pc=0000)
;4e3918:_l163(use=6:ref=4:pc=010b)
;4e3ca8:_l164(use=6:ref=3:pc=010b)
;4e4428:_l165(use=7:ref=3:pc=00e1)
;4e4cd8:_l166(use=7:ref=3:pc=00ee)
;4e5608:_l167(use=0:ref=1:pc=0000)
;4e57c8:_l168(use=0:ref=1:pc=0000)
;4e6c88:_l169(use=0:ref=1:pc=0000)
;4e6e48:_l170(use=0:ref=1:pc=0000)
;4e7b28:_l171(use=7:ref=3:pc=00fc)
;4e7b88:_l172(use=7:ref=3:pc=0107)
;4e7be8:_l173(use=0:ref=1:pc=0000)
;4e7dd8:_l174(use=0:ref=1:pc=0000)
;4e7388:_l175(use=0:ref=1:pc=0000)
;4e8ea8:_l176(use=0:ref=2:pc=0000)
;4e8f08:_l177(use=0:ref=2:pc=0000)
;4e9d08:_l178(use=0:ref=1:pc=0000)
;4e9d68:_l179(use=0:ref=1:pc=0000)
;4e9dc8:_l180(use=0:ref=1:pc=0000)
;4e9fb8:_l181(use=0:ref=1:pc=0000)
;4ea208:_l182(use=0:ref=1:pc=0000)
;4ea248:_l183(use=0:ref=2:pc=0000)
;4eb108:_l184(use=0:ref=2:pc=0000)
;4ebe88:_l185(use=0:ref=1:pc=0000)
;4ebee8:_l186(use=0:ref=1:pc=0000)
;4ebf48:_l187(use=0:ref=1:pc=0000)
;4ece88:_l188(use=0:ref=2:pc=0000)
;4ecee8:_l189(use=0:ref=2:pc=0000)
;4eddf8:_l190(use=0:ref=1:pc=0000)
;4ede58:_l191(use=0:ref=1:pc=0000)
;4edeb8:_l192(use=0:ref=1:pc=0000)
;4f1bf8:_l193(use=0:ref=2:pc=0000)
;4f1c58:_l194(use=0:ref=2:pc=0000)
;4f11d8:_l195(use=0:ref=1:pc=0000)
;4f3228:_l196(use=0:ref=1:pc=0000)
;4f4788:_l197(use=7:ref=4:pc=010c)
;4f47e8:_l198(use=0:ref=2:pc=0000)
;4f4b78:_l199(use=0:ref=1:pc=0000)
;4f5de8:_l200(use=0:ref=1:pc=0000)
;4f7878:_l201(use=0:ref=2:pc=0000)
;4f78d8:_l202(use=6:ref=4:pc=0352)
;4f7e68:_l203(use=0:ref=2:pc=0000)
;4f7ec8:_l204(use=0:ref=2:pc=0000)
;4f8488:_l205(use=0:ref=2:pc=0000)
;4f84e8:_l206(use=0:ref=2:pc=0000)
;4f9b88:_l207(use=0:ref=2:pc=0000)
;4f9be8:_l208(use=0:ref=2:pc=0000)
;4fa808:_l209(use=0:ref=2:pc=0000)
;4fa868:_l210(use=0:ref=2:pc=0000)
;4fb398:_l211(use=7:ref=3:pc=012a)
;4fb3f8:_l212(use=7:ref=3:pc=0144)
;4fb458:_l213(use=0:ref=1:pc=0000)
;4fb648:_l214(use=0:ref=1:pc=0000)
;4fc888:_l215(use=0:ref=2:pc=0000)
;4fc8e8:_l216(use=0:ref=2:pc=0000)
;4fd638:_l217(use=6:ref=3:pc=016c)
;4fd6d8:_l218(use=7:ref=3:pc=015f)
;4fe718:_l219(use=0:ref=2:pc=0000)
;4fe778:_l220(use=0:ref=2:pc=0000)
;4ff108:_l221(use=0:ref=1:pc=0000)
;4ff1a8:_l222(use=0:ref=1:pc=0000)
;461cf8:_l223(use=0:ref=2:pc=0000)
;461db8:_l224(use=0:ref=2:pc=0000)
;5001e8:_l225(use=0:ref=1:pc=0000)
;5002b8:_l226(use=0:ref=1:pc=0000)
;501228:_l227(use=0:ref=2:pc=0000)
;501288:_l228(use=0:ref=2:pc=0000)
;501708:_l229(use=0:ref=1:pc=0000)
;5017f8:_l230(use=0:ref=1:pc=0000)
;503d48:_l231(use=0:ref=2:pc=0000)
;503da8:_l232(use=0:ref=2:pc=0000)
;504328:_l233(use=0:ref=1:pc=0000)
;504418:_l234(use=0:ref=1:pc=0000)
;505fa8:_l235(use=0:ref=1:pc=0000)
;506108:_l236(use=0:ref=1:pc=0000)
;506e88:_l237(use=0:ref=1:pc=0000)
;506ee8:_l238(use=0:ref=1:pc=0000)
;506f48:_l239(use=0:ref=1:pc=0000)
;5071d8:_l240(use=0:ref=1:pc=0000)
;507f68:_l241(use=0:ref=1:pc=0000)
;509eb8:_l242(use=0:ref=2:pc=0000)
;509f18:_l243(use=0:ref=2:pc=0000)
;50a9f8:_l244(use=0:ref=1:pc=0000)
;50aa58:_l245(use=0:ref=1:pc=0000)
;50aab8:_l246(use=0:ref=1:pc=0000)
;50ac38:_l247(use=0:ref=1:pc=0000)
;50baf8:_l248(use=0:ref=1:pc=0000)
;50d978:_l249(use=0:ref=2:pc=0000)
;50d9d8:_l250(use=0:ref=2:pc=0000)
;50de58:_l251(use=0:ref=1:pc=0000)
;50df48:_l252(use=0:ref=1:pc=0000)
;513b78:_l253(use=0:ref=2:pc=0000)
;513bd8:_l254(use=0:ref=2:pc=0000)
;514108:_l255(use=0:ref=1:pc=0000)
;5141f8:_l256(use=0:ref=1:pc=0000)
;51a168:_l257(use=0:ref=2:pc=0000)
;51a1c8:_l258(use=0:ref=2:pc=0000)
;51a618:_l259(use=0:ref=1:pc=0000)
;51a708:_l260(use=7:ref=3:pc=017e)
;51dce8:_l261(use=0:ref=2:pc=0000)
;51dd48:_l262(use=0:ref=2:pc=0000)
;51e2f8:_l263(use=0:ref=1:pc=0000)
;51e3e8:_l264(use=7:ref=3:pc=01fc)
;5205b8:_l265(use=0:ref=2:pc=0000)
;520618:_l266(use=0:ref=2:pc=0000)
;521538:_l267(use=0:ref=2:pc=0000)
;521598:_l268(use=0:ref=2:pc=0000)
;5224d8:_l269(use=0:ref=2:pc=0000)
;522538:_l270(use=0:ref=2:pc=0000)
;524708:_l271(use=0:ref=2:pc=0000)
;524768:_l272(use=0:ref=2:pc=0000)
;525698:_l273(use=0:ref=2:pc=0000)
;5256f8:_l274(use=0:ref=2:pc=0000)
;526618:_l275(use=0:ref=2:pc=0000)
;526678:_l276(use=0:ref=2:pc=0000)
;5275a8:_l277(use=0:ref=2:pc=0000)
;527608:_l278(use=0:ref=2:pc=0000)
;528b28:_l279(use=0:ref=1:pc=0000)
;529338:_l280(use=13:ref=3:pc=0290)
;52b108:_l281(use=0:ref=1:pc=0000)
;52b818:_l282(use=7:ref=3:pc=02ba)
;52c408:_l283(use=7:ref=3:pc=02bb)
;52c468:_l284(use=13:ref=3:pc=0352)
;52c4c8:_l285(use=0:ref=1:pc=0000)
;52e298:_l286(use=0:ref=1:pc=0000)
;52f338:_l287(use=7:ref=3:pc=034f)
;530dc8:_l288(use=0:ref=1:pc=0000)
;530a18:_l289(use=0:ref=1:pc=0000)
;5313b8:_l290(use=0:ref=2:pc=0000)
;531418:_l291(use=0:ref=2:pc=0000)
;5317f8:_l292(use=0:ref=1:pc=0000)
;5318a8:_l293(use=0:ref=1:pc=0000)
;531908:_l294(use=0:ref=1:pc=0000)
;531c18:_l295(use=0:ref=1:pc=0000)
;5326b8:_l296(use=0:ref=1:pc=0000)
;532848:_l297(use=0:ref=1:pc=0000)
;5328a8:_l298(use=0:ref=1:pc=0000)
;532a98:_l299(use=0:ref=1:pc=0000)
;532b88:_l300(use=0:ref=1:pc=0000)
;532f68:_l301(use=0:ref=1:pc=0000)
;533618:_l302(use=0:ref=2:pc=0000)
;534128:_l303(use=0:ref=2:pc=0000)
;535698:_l304(use=0:ref=2:pc=0000)
;5356f8:_l305(use=0:ref=2:pc=0000)
;535998:_l306(use=0:ref=1:pc=0000)
;5359f8:_l307(use=0:ref=1:pc=0000)
;535a58:_l308(use=0:ref=1:pc=0000)
;5369f8:_l309(use=0:ref=2:pc=0000)
;536a58:_l310(use=0:ref=2:pc=0000)
;537458:_l311(use=0:ref=2:pc=0000)
;5374b8:_l312(use=0:ref=2:pc=0000)
;537848:_l313(use=7:ref=3:pc=0363)
;5378a8:_l314(use=7:ref=3:pc=0366)
;537908:_l315(use=0:ref=1:pc=0000)
;538a98:_l316(use=0:ref=2:pc=0000)
;538af8:_l317(use=0:ref=2:pc=0000)
;538ef8:_l318(use=0:ref=1:pc=0000)
;539108:_l319(use=0:ref=1:pc=0000)
;539168:_l320(use=0:ref=1:pc=0000)
;539df8:_l321(use=0:ref=1:pc=0000)
;539e58:_l322(use=0:ref=1:pc=0000)
;539eb8:_l323(use=0:ref=1:pc=0000)
;53adb8:_l324(use=0:ref=2:pc=0000)
;53ae18:_l325(use=0:ref=2:pc=0000)
;53b2a8:_l326(use=0:ref=1:pc=0000)
;53b368:_l327(use=0:ref=1:pc=0000)
;53c198:_l328(use=0:ref=1:pc=0000)
;53c278:_l329(use=0:ref=1:pc=0000)
;53c6f8:_l330(use=0:ref=2:pc=0000)
;53d108:_l331(use=0:ref=2:pc=0000)
;53dd98:_l332(use=7:ref=3:pc=0373)
;53e208:_l333(use=7:ref=3:pc=0376)
;53e708:_l334(use=7:ref=3:pc=037a)
;53e7d8:_l335(use=0:ref=1:pc=0000)
;53ea68:_l336(use=7:ref=3:pc=037c)
;53f398:_l337(use=0:ref=2:pc=0000)
;53f3f8:_l338(use=0:ref=2:pc=0000)
;53fcd8:_l339(use=0:ref=2:pc=0000)
;53fd38:_l340(use=0:ref=2:pc=0000)
;4eed68:_l341(use=0:ref=1:pc=0000)
;4eeee8:_l342(use=0:ref=1:pc=0000)
;4ef648:_l343(use=0:ref=1:pc=0000)
;5404b8:_l344(use=0:ref=1:pc=0000)
;5407f8:_l345(use=0:ref=1:pc=0000)
;540cf8:_l346(use=0:ref=1:pc=0000)
;540dc8:_l347(use=0:ref=1:pc=0000)
;541198:_l348(use=0:ref=1:pc=0000)
;5423a8:_l349(use=0:ref=2:pc=0000)
;542408:_l350(use=0:ref=2:pc=0000)
;542da8:_l351(use=7:ref=4:pc=038d)
;542e08:_l352(use=0:ref=2:pc=0000)
;5439e8:_l353(use=0:ref=2:pc=0000)
;544108:_l354(use=0:ref=2:pc=0000)
;5447a8:_l355(use=0:ref=1:pc=0000)
;544b48:_l356(use=0:ref=1:pc=0000)
;544d98:_l357(use=0:ref=1:pc=0000)
;545198:_l358(use=0:ref=1:pc=0000)
;545a68:_l359(use=0:ref=2:pc=0000)
;545ac8:_l360(use=0:ref=2:pc=0000)
;545d68:_l361(use=0:ref=1:pc=0000)
;546208:_l362(use=0:ref=1:pc=0000)
;549df8:_l363(use=0:ref=1:pc=0000)
;5491f8:_l364(use=0:ref=2:pc=0000)
;549258:_l365(use=0:ref=2:pc=0000)
;549868:_l366(use=0:ref=1:pc=0000)
;549d98:_l367(use=0:ref=1:pc=0000)
;54a2a8:_l368(use=0:ref=1:pc=0000)
;54a718:_l369(use=0:ref=1:pc=0000)
;54aaa8:_l370(use=0:ref=1:pc=0000)
;54c848:_l371(use=0:ref=1:pc=0000)
;54c8a8:_l372(use=0:ref=1:pc=0000)
;54db28:_l373(use=0:ref=1:pc=0000)
;54e468:_l374(use=0:ref=1:pc=0000)
;54e8d8:_l375(use=0:ref=1:pc=0000)
;54ed48:_l376(use=0:ref=1:pc=0000)
;54e628:_l377(use=0:ref=1:pc=0000)
;54ec08:_l378(use=0:ref=1:pc=0000)
;54f208:_l379(use=0:ref=1:pc=0000)
;54f678:_l380(use=0:ref=1:pc=0000)
;54f8e8:_l381(use=0:ref=1:pc=0000)
;54fb58:_l382(use=0:ref=1:pc=0000)
;54ffc8:_l383(use=0:ref=1:pc=0000)
;54fd18:_l384(use=0:ref=1:pc=0000)
;530b68:_l385(use=0:ref=1:pc=0000)
;54cbf8:_l386(use=0:ref=1:pc=0000)
;54ce78:_l387(use=0:ref=1:pc=0000)
;550208:_l388(use=0:ref=1:pc=0000)
;550638:_l389(use=0:ref=1:pc=0000)
;550a68:_l390(use=0:ref=1:pc=0000)
;550cd8:_l391(use=0:ref=1:pc=0000)
;550768:_l392(use=0:ref=1:pc=0000)
;550d18:_l393(use=0:ref=1:pc=0000)
;551208:_l394(use=0:ref=1:pc=0000)
;551678:_l395(use=0:ref=1:pc=0000)
;551ae8:_l396(use=0:ref=1:pc=0000)
;5519a8:_l397(use=0:ref=1:pc=0000)
;551c68:_l398(use=0:ref=1:pc=0000)
;552208:_l399(use=0:ref=1:pc=0000)
;552478:_l400(use=0:ref=1:pc=0000)
;5528b8:_l401(use=0:ref=1:pc=0000)
;552a28:_l402(use=0:ref=1:pc=0000)
;554408:_l403(use=0:ref=2:pc=0000)
;554468:_l404(use=0:ref=2:pc=0000)
;5562c8:_l405(use=0:ref=1:pc=0000)
;556478:_l406(use=0:ref=1:pc=0000)
;5567b8:_l407(use=0:ref=1:pc=0000)
;556968:_l408(use=0:ref=1:pc=0000)
;556e78:_l409(use=0:ref=2:pc=0000)
;556ed8:_l410(use=0:ref=2:pc=0000)
;558418:_l411(use=0:ref=1:pc=0000)
;559428:_l412(use=7:ref=3:pc=03d2)
;559e38:_l413(use=0:ref=2:pc=0000)
;559e98:_l414(use=0:ref=2:pc=0000)
;55a288:_l415(use=0:ref=1:pc=0000)
;55a588:_l416(use=0:ref=1:pc=0000)
;55a688:_l417(use=0:ref=1:pc=0000)
;55a898:_l418(use=0:ref=1:pc=0000)
;55afb8:_l419(use=0:ref=1:pc=0000)
;55b2a8:_l420(use=0:ref=1:pc=0000)
;55b538:_l421(use=0:ref=1:pc=0000)
;55bc28:_l422(use=0:ref=1:pc=0000)
;55bed8:_l423(use=0:ref=1:pc=0000)
;55bf38:_l424(use=0:ref=1:pc=0000)
;55c618:_l425(use=0:ref=1:pc=0000)
;55d478:_l426(use=0:ref=1:pc=0000)
;55e328:_l427(use=0:ref=1:pc=0000)
;55f228:_l428(use=0:ref=1:pc=0000)
;55ff78:_l429(use=0:ref=1:pc=0000)
;560ae8:_l430(use=0:ref=1:pc=0000)
;561868:_l431(use=0:ref=1:pc=0000)
;561b18:_l432(use=0:ref=1:pc=0000)
;561b78:_l433(use=0:ref=1:pc=0000)
;561cf8:_l434(use=0:ref=1:pc=0000)
;562cd8:_l435(use=0:ref=1:pc=0000)
;562ee8:_l436(use=0:ref=1:pc=0000)
;563278:_l437(use=7:ref=3:pc=03da)
;563488:_l438(use=0:ref=1:pc=0000)
;5637c8:_l439(use=0:ref=1:pc=0000)
;563c48:_l440(use=0:ref=1:pc=0000)
;564798:_l441(use=0:ref=2:pc=0000)
;5647f8:_l442(use=0:ref=2:pc=0000)
;5659a8:_l443(use=7:ref=3:pc=03f0)
;565a08:_l444(use=7:ref=3:pc=03f4)
;565a68:_l445(use=0:ref=1:pc=0000)
;565ec8:_l446(use=0:ref=1:pc=0000)
;5661f8:_l447(use=0:ref=1:pc=0000)
;566778:_l448(use=7:ref=3:pc=0412)
;566f08:_l449(use=7:ref=3:pc=0408)
;567d98:_l450(use=0:ref=2:pc=0000)
;567df8:_l451(use=0:ref=2:pc=0000)
;568288:_l452(use=0:ref=1:pc=0000)
;568338:_l453(use=0:ref=1:pc=0000)
;569688:_l454(use=0:ref=2:pc=0000)
;5696e8:_l455(use=0:ref=2:pc=0000)
;56b3c8:_l456(use=0:ref=2:pc=0000)
;56b428:_l457(use=0:ref=2:pc=0000)
;56b7b8:_l458(use=0:ref=1:pc=0000)
;56d908:_l459(use=0:ref=2:pc=0000)
;56d968:_l460(use=0:ref=2:pc=0000)
;56dc08:_l461(use=0:ref=1:pc=0000)
;56dd18:_l462(use=0:ref=1:pc=0000)
;56e428:_l463(use=0:ref=1:pc=0000)
;56e5a8:_l464(use=0:ref=1:pc=0000)
;56eeb8:_l465(use=0:ref=2:pc=0000)
;56ef18:_l466(use=0:ref=2:pc=0000)
;56f1a8:_l467(use=0:ref=1:pc=0000)
;56fb28:_l468(use=0:ref=1:pc=0000)
;570588:_l469(use=0:ref=2:pc=0000)
;5705e8:_l470(use=0:ref=2:pc=0000)
;570c88:_l471(use=0:ref=1:pc=0000)
;570dc8:_l472(use=0:ref=1:pc=0000)
;570f08:_l473(use=0:ref=1:pc=0000)
;571908:_l474(use=0:ref=1:pc=0000)
;5719d8:_l475(use=0:ref=1:pc=0000)
;571b88:_l476(use=0:ref=1:pc=0000)
;571c58:_l477(use=0:ref=1:pc=0000)
;571d98:_l478(use=0:ref=1:pc=0000)
;571ed8:_l479(use=0:ref=1:pc=0000)
;572128:_l480(use=0:ref=1:pc=0000)
;572268:_l481(use=0:ref=1:pc=0000)
;5723a8:_l482(use=0:ref=1:pc=0000)
;5724e8:_l483(use=0:ref=1:pc=0000)
;572628:_l484(use=0:ref=1:pc=0000)
;572768:_l485(use=0:ref=1:pc=0000)
;5728a8:_l486(use=0:ref=1:pc=0000)
;572ae8:_l487(use=0:ref=1:pc=0000)
;572c28:_l488(use=0:ref=1:pc=0000)
;572d68:_l489(use=0:ref=1:pc=0000)
;572ea8:_l490(use=0:ref=1:pc=0000)
;573108:_l491(use=0:ref=1:pc=0000)
;573248:_l492(use=0:ref=1:pc=0000)
;573388:_l493(use=0:ref=1:pc=0000)
;5734c8:_l494(use=0:ref=1:pc=0000)
;573608:_l495(use=0:ref=1:pc=0000)
;573748:_l496(use=0:ref=1:pc=0000)
;573888:_l497(use=0:ref=1:pc=0000)
;5739c8:_l498(use=0:ref=1:pc=0000)
;573b08:_l499(use=0:ref=1:pc=0000)
;573c48:_l500(use=0:ref=1:pc=0000)
;573d88:_l501(use=0:ref=1:pc=0000)
;573ec8:_l502(use=0:ref=1:pc=0000)
;574108:_l503(use=0:ref=1:pc=0000)
;574248:_l504(use=0:ref=1:pc=0000)
;574388:_l505(use=0:ref=1:pc=0000)
;574b38:_l506(use=0:ref=1:pc=0000)
;574c08:_l507(use=0:ref=1:pc=0000)
;574d48:_l508(use=0:ref=1:pc=0000)
;575858:_l509(use=0:ref=2:pc=0000)
;5758b8:_l510(use=0:ref=2:pc=0000)
;575bb8:_l511(use=0:ref=1:pc=0000)
;575eb8:_l512(use=0:ref=1:pc=0000)
;5765f8:_l513(use=0:ref=1:pc=0000)
;576738:_l514(use=0:ref=1:pc=0000)
;576878:_l515(use=0:ref=1:pc=0000)
;577278:_l516(use=0:ref=1:pc=0000)
;577348:_l517(use=0:ref=1:pc=0000)
;5774f8:_l518(use=0:ref=1:pc=0000)
;5775c8:_l519(use=0:ref=1:pc=0000)
;577708:_l520(use=0:ref=1:pc=0000)
;577848:_l521(use=0:ref=1:pc=0000)
;577988:_l522(use=0:ref=1:pc=0000)
;577ac8:_l523(use=0:ref=1:pc=0000)
;577c08:_l524(use=0:ref=1:pc=0000)
;577d48:_l525(use=0:ref=1:pc=0000)
;577e88:_l526(use=0:ref=1:pc=0000)
;577fc8:_l527(use=0:ref=1:pc=0000)
;578208:_l528(use=0:ref=1:pc=0000)
;578448:_l529(use=0:ref=1:pc=0000)
;578588:_l530(use=0:ref=1:pc=0000)
;5786c8:_l531(use=0:ref=1:pc=0000)
;578808:_l532(use=0:ref=1:pc=0000)
;578948:_l533(use=0:ref=1:pc=0000)
;578a88:_l534(use=0:ref=1:pc=0000)
;578bc8:_l535(use=0:ref=1:pc=0000)
;578d08:_l536(use=0:ref=1:pc=0000)
;578e48:_l537(use=0:ref=1:pc=0000)
;578f88:_l538(use=0:ref=1:pc=0000)
;579208:_l539(use=0:ref=1:pc=0000)
;579348:_l540(use=0:ref=1:pc=0000)
;579488:_l541(use=0:ref=1:pc=0000)
;5795c8:_l542(use=0:ref=1:pc=0000)
;579708:_l543(use=0:ref=1:pc=0000)
;579848:_l544(use=0:ref=1:pc=0000)
;579988:_l545(use=0:ref=1:pc=0000)
;579ac8:_l546(use=0:ref=1:pc=0000)
;579c08:_l547(use=0:ref=1:pc=0000)
;57a4c8:_l548(use=0:ref=1:pc=0000)
;57a598:_l549(use=0:ref=1:pc=0000)
;57a6d8:_l550(use=0:ref=1:pc=0000)
;57a978:_l551(use=0:ref=1:pc=0000)
;57b388:_l552(use=0:ref=1:pc=0000)
;57b458:_l553(use=0:ref=1:pc=0000)
;57b6e8:_l554(use=0:ref=1:pc=0000)
;57b7b8:_l555(use=0:ref=1:pc=0000)
;57b8f8:_l556(use=0:ref=1:pc=0000)
;57c828:_l557(use=0:ref=1:pc=0000)
;57c8f8:_l558(use=0:ref=1:pc=0000)
;57caa8:_l559(use=0:ref=1:pc=0000)
;57cb78:_l560(use=0:ref=1:pc=0000)
;57ccb8:_l561(use=0:ref=1:pc=0000)
;57cdf8:_l562(use=0:ref=1:pc=0000)
;57cf38:_l563(use=0:ref=1:pc=0000)
;57d648:_l564(use=0:ref=1:pc=0000)
;57dae8:_l565(use=0:ref=1:pc=0000)
;57df88:_l566(use=0:ref=1:pc=0000)
;57e558:_l567(use=0:ref=1:pc=0000)
;57e9f8:_l568(use=0:ref=1:pc=0000)
;57ee98:_l569(use=0:ref=1:pc=0000)
;57ef68:_l570(use=0:ref=1:pc=0000)
;57f278:_l571(use=0:ref=1:pc=0000)
;57f348:_l572(use=0:ref=1:pc=0000)
;57f7b8:_l573(use=0:ref=1:pc=0000)
;57f888:_l574(use=0:ref=1:pc=0000)
;57fa38:_l575(use=0:ref=1:pc=0000)
;57fb08:_l576(use=0:ref=1:pc=0000)
;57fc48:_l577(use=0:ref=1:pc=0000)
;581288:_l578(use=0:ref=1:pc=0000)
;5813c8:_l579(use=0:ref=1:pc=0000)
;5815e8:_l580(use=0:ref=1:pc=0000)
;581d08:_l581(use=0:ref=1:pc=0000)
;581dd8:_l582(use=7:ref=3:pc=0427)
;5822b8:_l583(use=0:ref=1:pc=0000)
;5823f8:_l584(use=0:ref=1:pc=0000)
;582538:_l585(use=0:ref=1:pc=0000)
;582de8:_l586(use=0:ref=1:pc=0000)
;582eb8:_l587(use=0:ref=1:pc=0000)
;583198:_l588(use=0:ref=1:pc=0000)
;583268:_l589(use=0:ref=1:pc=0000)
;5833a8:_l590(use=0:ref=1:pc=0000)
;5834e8:_l591(use=0:ref=1:pc=0000)
;583628:_l592(use=0:ref=1:pc=0000)
;583768:_l593(use=0:ref=1:pc=0000)
;5838a8:_l594(use=0:ref=1:pc=0000)
;5839e8:_l595(use=0:ref=1:pc=0000)
;583b28:_l596(use=0:ref=1:pc=0000)
;583d68:_l597(use=0:ref=1:pc=0000)
;583ea8:_l598(use=0:ref=1:pc=0000)
;584108:_l599(use=0:ref=1:pc=0000)
;584248:_l600(use=0:ref=1:pc=0000)
;584388:_l601(use=0:ref=1:pc=0000)
;5844c8:_l602(use=0:ref=1:pc=0000)
;584608:_l603(use=0:ref=1:pc=0000)
;584748:_l604(use=0:ref=1:pc=0000)
;584888:_l605(use=0:ref=1:pc=0000)
;5849c8:_l606(use=0:ref=1:pc=0000)
;584b08:_l607(use=0:ref=1:pc=0000)
;584c48:_l608(use=0:ref=1:pc=0000)
;584d88:_l609(use=0:ref=1:pc=0000)
;584ec8:_l610(use=0:ref=1:pc=0000)
;585108:_l611(use=0:ref=1:pc=0000)
;585248:_l612(use=0:ref=1:pc=0000)
;585388:_l613(use=0:ref=1:pc=0000)
;5854c8:_l614(use=0:ref=1:pc=0000)
;585608:_l615(use=0:ref=1:pc=0000)
;585748:_l616(use=0:ref=1:pc=0000)
;585888:_l617(use=0:ref=1:pc=0000)
;585fb8:_l618(use=0:ref=1:pc=0000)
;586198:_l619(use=0:ref=1:pc=0000)
;5862d8:_l620(use=0:ref=1:pc=0000)
;586578:_l621(use=0:ref=1:pc=0000)
;5868d8:_l622(use=0:ref=1:pc=0000)
;5869a8:_l623(use=0:ref=1:pc=0000)
;586c38:_l624(use=0:ref=1:pc=0000)
;586d08:_l625(use=0:ref=1:pc=0000)
;586e48:_l626(use=0:ref=1:pc=0000)
;587c98:_l627(use=0:ref=1:pc=0000)
;587d68:_l628(use=0:ref=1:pc=0000)
;587f18:_l629(use=0:ref=1:pc=0000)
;588108:_l630(use=0:ref=1:pc=0000)
;588248:_l631(use=0:ref=1:pc=0000)
;588388:_l632(use=0:ref=1:pc=0000)
;5884c8:_l633(use=0:ref=1:pc=0000)
;588ab8:_l634(use=7:ref=3:pc=0490)
;588f58:_l635(use=7:ref=3:pc=04a1)
;589558:_l636(use=7:ref=3:pc=04b2)
;5899f8:_l637(use=7:ref=3:pc=04c3)
;589e98:_l638(use=7:ref=3:pc=04d4)
;58a478:_l639(use=7:ref=3:pc=04e2)
;58a548:_l640(use=28:ref=6:pc=04e2)
;58a6f8:_l641(use=0:ref=1:pc=0000)
;58a7c8:_l642(use=7:ref=3:pc=04e2)
;58ab38:_l643(use=0:ref=1:pc=0000)
;58ac08:_l644(use=0:ref=1:pc=0000)
;58adb8:_l645(use=0:ref=1:pc=0000)
;58ae88:_l646(use=0:ref=1:pc=0000)
;58afc8:_l647(use=0:ref=1:pc=0000)
;58b328:_l648(use=0:ref=1:pc=0000)
;58b468:_l649(use=0:ref=1:pc=0000)
;58b688:_l650(use=0:ref=1:pc=0000)
;58b838:_l651(use=0:ref=1:pc=0000)
;58dc18:_l652(use=0:ref=2:pc=0000)
;58dc78:_l653(use=0:ref=2:pc=0000)
;58f168:_l654(use=0:ref=2:pc=0000)
;58f1c8:_l655(use=6:ref=4:pc=052e)
;58f648:_l656(use=0:ref=1:pc=0000)
;58fcd8:_l657(use=7:ref=3:pc=0520)
;576558:_l658(use=0:ref=2:pc=0000)
;57af98:_l659(use=12:ref=5:pc=0557)
;5902d8:_l660(use=0:ref=1:pc=0000)
;590868:_l661(use=7:ref=3:pc=053a)
;590dd8:_l662(use=7:ref=3:pc=0555)
;591ac8:_l663(use=7:ref=3:pc=0555)
;591c48:_l664(use=0:ref=1:pc=0000)
;592718:_l665(use=0:ref=1:pc=0000)
;593488:_l666(use=0:ref=2:pc=0000)
;5934e8:_l667(use=0:ref=2:pc=0000)
;593d28:_l668(use=0:ref=1:pc=0000)
;594258:_l669(use=0:ref=1:pc=0000)
;595f18:_l670(use=0:ref=1:pc=0000)
;596d18:_l671(use=0:ref=1:pc=0000)
;597818:_l672(use=0:ref=1:pc=0000)
;599a78:_l673(use=7:ref=3:pc=0569)
;599ad8:_l674(use=0:ref=1:pc=0000)
;599b38:_l675(use=0:ref=1:pc=0000)
;59b108:_l676(use=7:ref=4:pc=05bd)
;59b168:_l677(use=0:ref=2:pc=0000)
;59b468:_l678(use=0:ref=1:pc=0000)
;59b9e8:_l679(use=7:ref=3:pc=05b0)
;59ccc8:_l680(use=7:ref=3:pc=0581)
;59cd28:_l681(use=0:ref=1:pc=0000)
;59cd88:_l682(use=0:ref=1:pc=0000)
;59cf08:_l683(use=0:ref=1:pc=0000)
;59da08:_l684(use=7:ref=3:pc=05aa)
;59f378:_l685(use=0:ref=1:pc=0000)
;462628:_l686(use=0:ref=2:pc=0000)
;462848:_l687(use=0:ref=2:pc=0000)
;5a0288:_l688(use=0:ref=1:pc=0000)
;5a1788:_l689(use=0:ref=1:pc=0000)
;5a1838:_l690(use=0:ref=1:pc=0000)
;5a1248:_l691(use=0:ref=2:pc=0000)
;5a2108:_l692(use=0:ref=2:pc=0000)
;5a2798:_l693(use=7:ref=3:pc=05c3)
;5a27f8:_l694(use=7:ref=3:pc=05c6)
;5a2858:_l695(use=0:ref=1:pc=0000)
;5a3488:_l696(use=0:ref=2:pc=0000)
;5a34e8:_l697(use=0:ref=2:pc=0000)
;5a3b08:_l698(use=7:ref=3:pc=05ca)
;5a3b68:_l699(use=7:ref=3:pc=05cd)
;5a3bc8:_l700(use=0:ref=1:pc=0000)
;5a4968:_l701(use=0:ref=2:pc=0000)
;5a49c8:_l702(use=0:ref=2:pc=0000)
;5a4ca8:_l703(use=7:ref=3:pc=05d1)
;5a5108:_l704(use=7:ref=3:pc=05d4)
;5a5168:_l705(use=0:ref=1:pc=0000)
;5a5ee8:_l706(use=0:ref=2:pc=0000)
;5a5f48:_l707(use=6:ref=4:pc=05eb)
;5a6ad8:_l708(use=7:ref=3:pc=05de)
;5a6b38:_l709(use=7:ref=3:pc=05e1)
;5a6b98:_l710(use=0:ref=1:pc=0000)
;5a7598:_l711(use=0:ref=1:pc=0000)
;5a7b68:_l712(use=7:ref=3:pc=05e7)
;5a8da8:_l713(use=7:ref=4:pc=0607)
;5a8e08:_l714(use=0:ref=2:pc=0000)
;5a9658:_l715(use=7:ref=3:pc=05ef)
;5a96b8:_l716(use=7:ref=3:pc=05f2)
;5a9718:_l717(use=0:ref=1:pc=0000)
;5aaa58:_l718(use=7:ref=3:pc=05fe)
;5aaab8:_l719(use=7:ref=3:pc=0601)
;5aab18:_l720(use=0:ref=1:pc=0000)
;5ad4a8:_l721(use=0:ref=1:pc=0000)
;5ad658:_l722(use=0:ref=1:pc=0000)
;5adec8:_l723(use=0:ref=1:pc=0000)
;5ae108:_l724(use=0:ref=1:pc=0000)
;5ae978:_l725(use=0:ref=1:pc=0000)
;5aeb28:_l726(use=0:ref=1:pc=0000)
;5af4a8:_l727(use=0:ref=1:pc=0000)
;5af658:_l728(use=0:ref=1:pc=0000)
;5b05a8:_l729(use=0:ref=2:pc=0000)
;5b0608:_l730(use=0:ref=2:pc=0000)
;5b1858:_l731(use=18:ref=5:pc=0647)
;5b1f28:_l732(use=7:ref=3:pc=0632)
;5b2fa8:_l733(use=7:ref=3:pc=063c)
;5b3d68:_l734(use=7:ref=3:pc=0646)
;5b4e48:_l735(use=7:ref=4:pc=0648)
;5b4ea8:_l736(use=0:ref=2:pc=0000)
;5b64e8:_l737(use=0:ref=1:pc=0000)
;5b7588:_l738(use=0:ref=1:pc=0000)
;5b7708:_l739(use=0:ref=1:pc=0000)
;5b7c88:_l740(use=0:ref=1:pc=0000)
;5b8958:_l741(use=0:ref=1:pc=0000)
;5ba3d8:_l742(use=7:ref=3:pc=0656)
;5bb298:_l743(use=0:ref=1:pc=0000)
;5bc108:_l744(use=0:ref=2:pc=0000)
;5bc168:_l745(use=0:ref=2:pc=0000)
;5bd3f8:_l746(use=0:ref=2:pc=0000)
;5bd458:_l747(use=0:ref=2:pc=0000)
;5be128:_l748(use=0:ref=2:pc=0000)
;5be188:_l749(use=0:ref=2:pc=0000)
;5be518:_l750(use=0:ref=1:pc=0000)
;5bec28:_l751(use=0:ref=1:pc=0000)
;5c0988:_l752(use=0:ref=2:pc=0000)
;5c09e8:_l753(use=0:ref=2:pc=0000)
;5c2408:_l754(use=0:ref=2:pc=0000)
;5c2468:_l755(use=0:ref=2:pc=0000)
;5c38f8:_l756(use=0:ref=2:pc=0000)
;5c3958:_l757(use=0:ref=2:pc=0000)
;5c3db8:_l758(use=0:ref=1:pc=0000)
;5c4588:_l759(use=0:ref=1:pc=0000)
;5c5338:_l760(use=0:ref=1:pc=0000)
;5c79a8:_l761(use=7:ref=3:pc=0664)
;5c7c58:_l762(use=0:ref=1:pc=0000)
;5c8cc8:_l763(use=0:ref=2:pc=0000)
;5c8d28:_l764(use=0:ref=2:pc=0000)
;5c9f68:_l765(use=0:ref=2:pc=0000)
;5c9fc8:_l766(use=0:ref=2:pc=0000)
;5cad68:_l767(use=0:ref=2:pc=0000)
;5cadc8:_l768(use=0:ref=2:pc=0000)
;5cb238:_l769(use=0:ref=1:pc=0000)
;5cb948:_l770(use=0:ref=1:pc=0000)
;5cd818:_l771(use=0:ref=2:pc=0000)
;5cd878:_l772(use=0:ref=2:pc=0000)
;5cf1e8:_l773(use=0:ref=2:pc=0000)
;5cf248:_l774(use=0:ref=2:pc=0000)
;5b2228:_l775(use=0:ref=2:pc=0000)
;5b3ec8:_l776(use=0:ref=2:pc=0000)
;5c07e8:_l777(use=0:ref=1:pc=0000)
;5d0438:_l778(use=0:ref=1:pc=0000)
;5d1238:_l779(use=0:ref=1:pc=0000)
;5d3978:_l780(use=0:ref=1:pc=0000)
;5d3d08:_l781(use=0:ref=1:pc=0000)
;5d3fa8:_l782(use=0:ref=1:pc=0000)
;5d4208:_l783(use=0:ref=1:pc=0000)
;5d44a8:_l784(use=0:ref=1:pc=0000)
;5d4748:_l785(use=0:ref=1:pc=0000)
;5d49e8:_l786(use=0:ref=1:pc=0000)
;5d4c88:_l787(use=0:ref=1:pc=0000)
;5d63d8:_l788(use=0:ref=2:pc=0000)
;5d6438:_l789(use=0:ref=2:pc=0000)
;5d6fc8:_l790(use=0:ref=1:pc=0000)
;5d7aa8:_l791(use=7:ref=3:pc=0685)
;5d8ae8:_l792(use=7:ref=3:pc=069c)
;5d9238:_l793(use=7:ref=3:pc=068d)
;5dbde8:_l794(use=0:ref=1:pc=0000)
;5dbe88:_l795(use=7:ref=3:pc=06a1)
;5dc538:_l796(use=0:ref=1:pc=0000)
;5dc5d8:_l797(use=7:ref=3:pc=06a9)
;5dcc08:_l798(use=0:ref=1:pc=0000)
;5dcca8:_l799(use=7:ref=3:pc=06b1)
;5ddc98:_l800(use=0:ref=2:pc=0000)
;5ddcf8:_l801(use=0:ref=2:pc=0000)
;5e2798:_l802(use=0:ref=2:pc=0000)
;5e27f8:_l803(use=0:ref=2:pc=0000)
;5e2bb8:_l804(use=0:ref=1:pc=0000)
;5e2ca8:_l805(use=0:ref=1:pc=0000)
;5e4c18:_l806(use=0:ref=2:pc=0000)
;5e4c78:_l807(use=0:ref=2:pc=0000)
;5e4448:_l808(use=0:ref=1:pc=0000)
;5e56b8:_l809(use=0:ref=1:pc=0000)
;5e6928:_l810(use=0:ref=1:pc=0000)
;5e6e68:_l811(use=0:ref=1:pc=0000)
;5e7b18:_l812(use=0:ref=1:pc=0000)
;5e8338:_l813(use=0:ref=1:pc=0000)
;5e8f98:_l814(use=0:ref=2:pc=0000)
;5e8498:_l815(use=0:ref=2:pc=0000)
;5ea4a8:_l816(use=0:ref=1:pc=0000)
;5ea648:_l817(use=0:ref=1:pc=0000)
;5eaf48:_l818(use=0:ref=1:pc=0000)
;5eb198:_l819(use=0:ref=1:pc=0000)
;5eb2f8:_l820(use=0:ref=1:pc=0000)
;5ec4d8:_l821(use=0:ref=1:pc=0000)
;5ec608:_l822(use=0:ref=1:pc=0000)
;5ed7b8:_l823(use=0:ref=1:pc=0000)
;5ed8e8:_l824(use=0:ref=1:pc=0000)
;5ee828:_l825(use=0:ref=1:pc=0000)
;5ee898:_l826(use=0:ref=1:pc=0000)
;5ef108:_l827(use=0:ref=2:pc=0000)
;5ef168:_l828(use=0:ref=2:pc=0000)
;5ef4f8:_l829(use=0:ref=1:pc=0000)
;5f0438:_l830(use=0:ref=1:pc=0000)
;5f05b8:_l831(use=0:ref=1:pc=0000)
;5f0c18:_l832(use=0:ref=1:pc=0000)
;5f19d8:_l833(use=0:ref=1:pc=0000)
;5f1f08:_l834(use=0:ref=1:pc=0000)
;5f2a48:_l835(use=0:ref=1:pc=0000)
;5f2f78:_l836(use=0:ref=1:pc=0000)
;5f36a8:_l837(use=0:ref=1:pc=0000)
;5f3bd8:_l838(use=0:ref=1:pc=0000)
;5f5198:_l839(use=0:ref=2:pc=0000)
;5f51f8:_l840(use=0:ref=2:pc=0000)
;5f5588:_l841(use=0:ref=1:pc=0000)
;5f5b98:_l842(use=0:ref=1:pc=0000)
;5f6f28:_l843(use=0:ref=2:pc=0000)
;5f6f88:_l844(use=0:ref=2:pc=0000)
;5f7768:_l845(use=0:ref=2:pc=0000)
;5f77c8:_l846(use=6:ref=4:pc=07ae)
;5f7b88:_l847(use=0:ref=1:pc=0000)
;5f8c58:_l848(use=7:ref=3:pc=0760)
;5f95d8:_l849(use=0:ref=1:pc=0000)
;5f9c08:_l850(use=7:ref=3:pc=0764)
;5faa28:_l851(use=14:ref=4:pc=07ac)
;5fb6f8:_l852(use=7:ref=3:pc=0788)
;5fcdc8:_l853(use=7:ref=3:pc=07a8)
;5feae8:_l854(use=14:ref=5:pc=07af)
;5feb48:_l855(use=0:ref=2:pc=0000)
;5ff838:_l856(use=0:ref=1:pc=0000)
;5fff18:_l857(use=0:ref=1:pc=0000)
;600648:_l858(use=0:ref=1:pc=0000)
;600c78:_l859(use=0:ref=1:pc=0000)
;6017e8:_l860(use=0:ref=1:pc=0000)
;601d18:_l861(use=0:ref=1:pc=0000)
;602448:_l862(use=0:ref=1:pc=0000)
;602978:_l863(use=0:ref=1:pc=0000)
;602f58:_l864(use=0:ref=1:pc=0000)
;602ad8:_l865(use=0:ref=1:pc=0000)
;604fb8:_l866(use=0:ref=2:pc=0000)
;604468:_l867(use=6:ref=4:pc=0887)
;605548:_l868(use=0:ref=1:pc=0000)
;605ab8:_l869(use=7:ref=3:pc=07bc)
;606358:_l870(use=0:ref=1:pc=0000)
;6067e8:_l871(use=7:ref=3:pc=07c1)
;607208:_l872(use=0:ref=1:pc=0000)
;607698:_l873(use=7:ref=3:pc=07c6)
;607248:_l874(use=0:ref=1:pc=0000)
;6085a8:_l875(use=7:ref=3:pc=07c9)
;608a48:_l876(use=14:ref=4:pc=0883)
;608fc8:_l877(use=13:ref=3:pc=07ff)
;609248:_l878(use=0:ref=1:pc=0000)
;60a238:_l879(use=13:ref=3:pc=07f3)
;60aa18:_l880(use=0:ref=1:pc=0000)
;60abc8:_l881(use=0:ref=1:pc=0000)
;60b4a8:_l882(use=0:ref=1:pc=0000)
;60b658:_l883(use=0:ref=1:pc=0000)
;60bec8:_l884(use=0:ref=1:pc=0000)
;60c108:_l885(use=0:ref=1:pc=0000)
;60ca88:_l886(use=0:ref=1:pc=0000)
;60cc38:_l887(use=0:ref=1:pc=0000)
;60d418:_l888(use=0:ref=1:pc=0000)
;60d5c8:_l889(use=0:ref=1:pc=0000)
;60dd38:_l890(use=0:ref=1:pc=0000)
;60dee8:_l891(use=0:ref=1:pc=0000)
;60e608:_l892(use=0:ref=1:pc=0000)
;60e948:_l893(use=7:ref=3:pc=0836)
;60f548:_l894(use=13:ref=3:pc=0834)
;60fe18:_l895(use=7:ref=3:pc=0834)
;60ff98:_l896(use=0:ref=1:pc=0000)
;610438:_l897(use=0:ref=1:pc=0000)
;6117b8:_l898(use=28:ref=6:pc=0883)
;611d08:_l899(use=13:ref=3:pc=0847)
;612518:_l900(use=0:ref=1:pc=0000)
;6126c8:_l901(use=0:ref=1:pc=0000)
;612e38:_l902(use=0:ref=1:pc=0000)
;612478:_l903(use=0:ref=1:pc=0000)
;613838:_l904(use=0:ref=1:pc=0000)
;6139e8:_l905(use=0:ref=1:pc=0000)
;614338:_l906(use=13:ref=3:pc=0857)
;614a18:_l907(use=0:ref=1:pc=0000)
;614bc8:_l908(use=0:ref=1:pc=0000)
;615368:_l909(use=0:ref=1:pc=0000)
;615518:_l910(use=0:ref=1:pc=0000)
;615c88:_l911(use=0:ref=1:pc=0000)
;615e38:_l912(use=0:ref=1:pc=0000)
;6168b8:_l913(use=13:ref=3:pc=0867)
;616f98:_l914(use=0:ref=1:pc=0000)
;617278:_l915(use=0:ref=1:pc=0000)
;6179e8:_l916(use=0:ref=1:pc=0000)
;617b98:_l917(use=0:ref=1:pc=0000)
;618368:_l918(use=0:ref=1:pc=0000)
;618518:_l919(use=0:ref=1:pc=0000)
;618da8:_l920(use=13:ref=3:pc=0877)
;619518:_l921(use=0:ref=1:pc=0000)
;6196c8:_l922(use=0:ref=1:pc=0000)
;619e38:_l923(use=0:ref=1:pc=0000)
;619478:_l924(use=0:ref=1:pc=0000)
;61a838:_l925(use=0:ref=1:pc=0000)
;61a9e8:_l926(use=0:ref=1:pc=0000)
;61b338:_l927(use=7:ref=3:pc=0883)
;61ba18:_l928(use=0:ref=1:pc=0000)
;61bbc8:_l929(use=0:ref=1:pc=0000)
;61c368:_l930(use=0:ref=1:pc=0000)
;61c518:_l931(use=0:ref=1:pc=0000)
;61cc88:_l932(use=0:ref=1:pc=0000)
;61ce38:_l933(use=0:ref=1:pc=0000)
;61e508:_l934(use=0:ref=2:pc=0000)
;61e568:_l935(use=0:ref=2:pc=0000)
;61f288:_l936(use=0:ref=1:pc=0000)
;61f438:_l937(use=0:ref=1:pc=0000)
;6207c8:_l938(use=0:ref=1:pc=0000)
;620978:_l939(use=0:ref=1:pc=0000)
;6213c8:_l940(use=7:ref=3:pc=08c9)
;621908:_l941(use=13:ref=3:pc=08c7)
;622bf8:_l942(use=6:ref=3:pc=08e8)
;622f88:_l943(use=13:ref=3:pc=08e6)
;6245e8:_l944(use=7:ref=4:pc=08e9)
;624648:_l945(use=0:ref=2:pc=0000)
;626bf8:_l946(use=0:ref=2:pc=0000)
;626c58:_l947(use=0:ref=2:pc=0000)
;62a628:_l948(use=0:ref=2:pc=0000)
;62a688:_l949(use=0:ref=2:pc=0000)
;62a9e8:_l950(use=0:ref=1:pc=0000)
;62aab8:_l951(use=0:ref=1:pc=0000)
;62ec48:_l952(use=0:ref=1:pc=0000)
;62f438:_l953(use=0:ref=1:pc=0000)
;631708:_l954(use=0:ref=2:pc=0000)
;631768:_l955(use=0:ref=2:pc=0000)
;631f38:_l956(use=0:ref=2:pc=0000)
;631f98:_l957(use=0:ref=2:pc=0000)
;636c58:_l958(use=0:ref=1:pc=0000)
;637438:_l959(use=0:ref=1:pc=0000)
;638e18:_l960(use=0:ref=1:pc=0000)
;638e78:_l961(use=0:ref=1:pc=0000)
;638ed8:_l962(use=0:ref=1:pc=0000)
;639df8:_l963(use=0:ref=1:pc=0000)
;63a4a8:_l964(use=0:ref=1:pc=0000)
;63ad48:_l965(use=0:ref=1:pc=0000)
;63ada8:_l966(use=0:ref=1:pc=0000)
;63ae08:_l967(use=0:ref=1:pc=0000)
;63b4e8:_l968(use=0:ref=1:pc=0000)
;63b8a8:_l969(use=0:ref=1:pc=0000)
;63c388:_l970(use=0:ref=1:pc=0000)
;63c748:_l971(use=0:ref=1:pc=0000)
;63e4e8:_l972(use=0:ref=2:pc=0000)
;63e548:_l973(use=0:ref=2:pc=0000)
;63ec78:_l974(use=7:ref=3:pc=0919)
;63ecd8:_l975(use=13:ref=3:pc=0942)
;63ed38:_l976(use=0:ref=1:pc=0000)
;640cc8:_l977(use=7:ref=4:pc=0af0)
;640d28:_l978(use=0:ref=2:pc=0000)
;6411b8:_l979(use=6:ref=3:pc=0aef)
;6415f8:_l980(use=7:ref=3:pc=0aef)
;641818:_l981(use=7:ref=3:pc=0959)
;6419b8:_l982(use=0:ref=1:pc=0000)
;6423d8:_l983(use=6:ref=3:pc=0aef)
;642518:_l984(use=7:ref=3:pc=0ace)
;642678:_l985(use=0:ref=1:pc=0000)
;656bd8:_l986(use=0:ref=1:pc=0000)
;656c48:_l987(use=0:ref=1:pc=0000)
;65fe58:_l988(use=0:ref=1:pc=0000)
;4629b8:_l989(use=0:ref=1:pc=0000)
;6608b8:_l990(use=0:ref=1:pc=0000)
;660a68:_l991(use=0:ref=1:pc=0000)
;661a98:_l992(use=14:ref=4:pc=0b46)
;661af8:_l993(use=0:ref=1:pc=0000)
;661c78:_l994(use=0:ref=1:pc=0000)
;662648:_l995(use=0:ref=1:pc=0000)
;662f58:_l996(use=0:ref=1:pc=0000)
;663488:_l997(use=7:ref=3:pc=0b9f)
;666618:_l998(use=0:ref=1:pc=0000)
;6675c8:_l999(use=13:ref=3:pc=0bac)
;667e68:_l1000(use=0:ref=1:pc=0000)
;668388:_l1001(use=7:ref=3:pc=0be7)
;66b4e8:_l1002(use=7:ref=3:pc=0c07)
;66bb18:_l1003(use=7:ref=3:pc=0bfe)
;66c9a8:_l1004(use=0:ref=1:pc=0000)
;66cb58:_l1005(use=0:ref=1:pc=0000)
;66db78:_l1006(use=0:ref=1:pc=0000)
;66dd28:_l1007(use=0:ref=1:pc=0000)
;66ea28:_l1008(use=0:ref=1:pc=0000)
;66ebd8:_l1009(use=0:ref=1:pc=0000)
;66f298:_l1010(use=7:ref=3:pc=0c2c)
;66f8c8:_l1011(use=7:ref=3:pc=0c23)
;660cd8:_l1012(use=0:ref=1:pc=0000)
;66afb8:_l1013(use=0:ref=1:pc=0000)
;6711a8:_l1014(use=0:ref=1:pc=0000)
;671358:_l1015(use=0:ref=1:pc=0000)
;671fb8:_l1016(use=0:ref=1:pc=0000)
;672208:_l1017(use=0:ref=1:pc=0000)
;672478:_l1018(use=0:ref=1:pc=0000)
;6727b8:_l1019(use=7:ref=3:pc=0c5b)
;672c88:_l1020(use=0:ref=1:pc=0000)
;673338:_l1021(use=7:ref=3:pc=0c59)
;673ea8:_l1022(use=0:ref=1:pc=0000)
;674198:_l1023(use=0:ref=1:pc=0000)
;716b08:_l1024(use=3:ref=1:pc=0029)
;7175a8:_l1025(use=3:ref=1:pc=0037)
;717f88:_l1026(use=3:ref=1:pc=0047)
;7249c8:_l1027(use=3:ref=1:pc=019d)
;730ee8:_l1028(use=9:ref=1:pc=030f)
;732588:_l1029(use=0:ref=1:pc=0317)
;737f18:_l1030(use=9:ref=1:pc=03d1)
;739588:_l1031(use=0:ref=1:pc=03d9)
;73f6a8:_l1032(use=0:ref=1:pc=0489)
;73f708:_l1033(use=0:ref=1:pc=0000)
;744dc8:_l1034(use=3:ref=1:pc=0511)
;744e28:_l1035(use=3:ref=1:pc=0514)
;7494a8:_l1036(use=0:ref=1:pc=057d)
;749c18:_l1037(use=0:ref=1:pc=0589)
;749f88:_l1038(use=3:ref=1:pc=0594)
;74a748:_l1039(use=0:ref=1:pc=05a0)
;74a7a8:_l1040(use=0:ref=1:pc=0000)
;74b508:_l1041(use=3:ref=1:pc=05b5)
;74b568:_l1042(use=3:ref=1:pc=05b8)
;74e628:_l1043(use=0:ref=1:pc=05fb)
;74e998:_l1044(use=3:ref=1:pc=0603)
;74ee78:_l1045(use=3:ref=1:pc=0609)
;74f758:_l1046(use=3:ref=1:pc=0615)
;758328:_l1047(use=3:ref=1:pc=0700)
;758388:_l1048(use=3:ref=1:pc=0703)
;759ce8:_l1049(use=3:ref=1:pc=072a)
;759d48:_l1050(use=3:ref=1:pc=072d)
;75b808:_l1051(use=3:ref=1:pc=0754)
;75b868:_l1052(use=3:ref=1:pc=0757)
;75d328:_l1053(use=3:ref=1:pc=077e)
;75d388:_l1054(use=3:ref=1:pc=0781)
;75ece8:_l1055(use=3:ref=1:pc=07a8)
;75ed48:_l1056(use=3:ref=1:pc=07ab)
;760808:_l1057(use=3:ref=1:pc=07d2)
;760868:_l1058(use=3:ref=1:pc=07d5)
;764228:_l1059(use=3:ref=1:pc=082d)
;764288:_l1060(use=3:ref=1:pc=0830)
;766228:_l1061(use=0:ref=1:pc=0859)
;766568:_l1062(use=3:ref=1:pc=0861)
;767da8:_l1063(use=0:ref=1:pc=0884)
;768228:_l1064(use=3:ref=1:pc=088c)
;774f88:_l1065(use=3:ref=1:pc=09d7)
;775108:_l1066(use=3:ref=1:pc=09d4)
;78c3a8:_l1067(use=3:ref=1:pc=0c35)
;78cb78:_l1068(use=3:ref=1:pc=0c40)
;78d328:_l1069(use=3:ref=1:pc=0c4c)
;78daf8:_l1070(use=3:ref=1:pc=0c57)
;78e2a8:_l1071(use=0:ref=1:pc=0c63)
;78e308:_l1072(use=0:ref=1:pc=0000)
;78ff28:_l1073(use=3:ref=1:pc=0c94)
;790808:_l1074(use=3:ref=1:pc=0c9f)
;790e68:_l1075(use=3:ref=1:pc=0cab)
;791788:_l1076(use=3:ref=1:pc=0cb6)
;791e08:_l1077(use=0:ref=1:pc=0cc2)
;791e68:_l1078(use=0:ref=1:pc=0000)
;792f88:_l1079(use=3:ref=1:pc=0cde)
;793868:_l1080(use=3:ref=1:pc=0ce9)
;793ec8:_l1081(use=3:ref=1:pc=0cf5)
;794808:_l1082(use=3:ref=1:pc=0d00)
;794e88:_l1083(use=0:ref=1:pc=0d0c)
;794ee8:_l1084(use=0:ref=1:pc=0000)
;798de8:_l1085(use=0:ref=1:pc=0d67)
;799228:_l1086(use=0:ref=1:pc=0d6f)
;79a428:_l1087(use=3:ref=1:pc=0d93)
;79abc8:_l1088(use=0:ref=1:pc=0d9b)
;79d508:_l1089(use=3:ref=1:pc=0de1)
;79d568:_l1090(use=3:ref=1:pc=0de4)
;7a0328:_l1091(use=0:ref=1:pc=0e28)
;7a0668:_l1092(use=0:ref=1:pc=0e30)
;7a11a8:_l1093(use=0:ref=1:pc=0e3b)
;7a14e8:_l1094(use=0:ref=1:pc=0e43)
;7a2a08:_l1095(use=0:ref=1:pc=0e62)
;7a2d48:_l1096(use=0:ref=1:pc=0e6a)
;7a43a8:_l1097(use=0:ref=1:pc=0e89)
;7a46e8:_l1098(use=0:ref=1:pc=0e91)
;7a5be8:_l1099(use=0:ref=1:pc=0eb0)
;7a5f28:_l1100(use=0:ref=1:pc=0eb8)
;7ac328:_l1101(use=3:ref=1:pc=0f5c)
;7acc08:_l1102(use=0:ref=1:pc=0f64)
;7aec68:_l1103(use=3:ref=1:pc=0fa3)
;7af6a8:_l1104(use=0:ref=1:pc=0fab)
;7b3c28:_l1105(use=3:ref=1:pc=1025)
;7b45e8:_l1106(use=0:ref=1:pc=102d)
;7b71a8:_l1107(use=3:ref=1:pc=107c)
;7b7208:_l1108(use=3:ref=1:pc=107f)
;7da528:_l1109(use=3:ref=1:pc=13c8)
;7da588:_l1110(use=3:ref=1:pc=13c5)
;7db628:_l1111(use=3:ref=1:pc=13e4)
;7db688:_l1112(use=3:ref=1:pc=13e1)
;7e33a8:_l1113(use=0:ref=1:pc=14a4)
;7e3748:_l1114(use=0:ref=1:pc=14ac)
;7e84e8:_l1115(use=0:ref=1:pc=1526)
;7e8ce8:_l1116(use=3:ref=1:pc=152e)
;7eac58:_l1117(use=3:ref=1:pc=1564)
;7eacb8:_l1118(use=3:ref=1:pc=1561)
;7ec108:_l1119(use=0:ref=1:pc=1581)
;7ec908:_l1120(use=3:ref=1:pc=1589)
;7ee888:_l1121(use=3:ref=1:pc=15bf)
;7ee8e8:_l1122(use=3:ref=1:pc=15bc)
;7efc68:_l1123(use=3:ref=1:pc=15dd)
;7efcc8:_l1124(use=3:ref=1:pc=15e0)
;7f1668:_l1125(use=3:ref=1:pc=1607)
;7f16c8:_l1126(use=3:ref=1:pc=1604)
;7f7428:_l1127(use=3:ref=1:pc=0000)
;7f7488:_l1128(use=3:ref=1:pc=0000)
;7f91c8:_l1129(use=3:ref=1:pc=0000)
;7f9228:_l1130(use=3:ref=1:pc=0000)
;7f9288:_l1131(use=3:ref=1:pc=0000)
;7f92e8:_l1132(use=3:ref=1:pc=0000)
;7faa68:_l1133(use=3:ref=1:pc=0000)
;7fc328:_l1134(use=3:ref=1:pc=0000)
;7fe628:_l1135(use=9:ref=1:pc=0000)
;803a28:_l1136(use=3:ref=1:pc=0000)
;803a88:_l1137(use=3:ref=1:pc=0000)
;806808:_l1138(use=3:ref=1:pc=003d)
;806868:_l1139(use=3:ref=1:pc=004b)
;8069e8:_l1140(use=3:ref=1:pc=0076)
;806a48:_l1141(use=3:ref=1:pc=00a5)
;806aa8:_l1142(use=3:ref=1:pc=0096)
;806b08:_l1143(use=3:ref=1:pc=005d)
;806c88:_l1144(use=3:ref=1:pc=006d)
;806e08:_l1145(use=3:ref=1:pc=0070)
;806ec8:_l1146(use=9:ref=1:pc=0092)
;806f88:_l1147(use=3:ref=1:pc=00d2)
;806388:_l1148(use=3:ref=1:pc=00cd)
;807188:_l1149(use=3:ref=1:pc=00eb)
;807268:_l1150(use=3:ref=1:pc=00f5)
;807348:_l1151(use=3:ref=1:pc=0102)
;807ab8:_l1152(use=3:ref=1:pc=01b5)
;8083e8:_l1153(use=9:ref=1:pc=0276)
;808648:_l1154(use=0:ref=1:pc=027a)
;808828:_l1155(use=9:ref=1:pc=02ce)
;808a88:_l1156(use=0:ref=1:pc=02d2)
;808b48:_l1157(use=0:ref=1:pc=033c)
;808ba8:_l1158(use=0:ref=1:pc=0000)
;809218:_l1159(use=3:ref=1:pc=0381)
;809278:_l1160(use=3:ref=1:pc=0383)
;809438:_l1161(use=0:ref=1:pc=03bd)
;809528:_l1162(use=0:ref=1:pc=03c5)
;809618:_l1163(use=3:ref=1:pc=03cc)
;809698:_l1164(use=0:ref=1:pc=03d0)
;8096f8:_l1165(use=0:ref=1:pc=0000)
;8097b8:_l1166(use=3:ref=1:pc=03d7)
;809818:_l1167(use=2:ref=1:pc=03d9)
;809b28:_l1168(use=0:ref=1:pc=03fa)
;809c18:_l1169(use=3:ref=1:pc=03fe)
;809c78:_l1170(use=3:ref=1:pc=0404)
;809d58:_l1171(use=3:ref=1:pc=040e)
;80b698:_l1172(use=3:ref=1:pc=04ff)
;80b6f8:_l1173(use=3:ref=1:pc=0501)
;80b878:_l1174(use=0:ref=1:pc=051b)
;80b938:_l1175(use=3:ref=1:pc=051f)
;80bac8:_l1176(use=0:ref=1:pc=0533)
;80bb88:_l1177(use=3:ref=1:pc=0537)
;80c848:_l1178(use=3:ref=1:pc=05fd)
;80c8a8:_l1179(use=3:ref=1:pc=05fa)
;80e3c8:_l1180(use=3:ref=1:pc=0746)
;80e518:_l1181(use=3:ref=1:pc=074b)
;80e578:_l1182(use=3:ref=1:pc=0751)
;80e6c8:_l1183(use=3:ref=1:pc=0756)
;80e728:_l1184(use=0:ref=1:pc=075a)
;80e788:_l1185(use=0:ref=1:pc=0000)
;80e8a8:_l1186(use=3:ref=1:pc=076e)
;80e9f8:_l1187(use=3:ref=1:pc=0773)
;80ea58:_l1188(use=3:ref=1:pc=0779)
;80eba8:_l1189(use=3:ref=1:pc=077e)
;80ec28:_l1190(use=0:ref=1:pc=0782)
;80ec88:_l1191(use=0:ref=1:pc=0000)
;80ed48:_l1192(use=3:ref=1:pc=078e)
;80ee98:_l1193(use=3:ref=1:pc=0793)
;80eef8:_l1194(use=3:ref=1:pc=0799)
;80f148:_l1195(use=3:ref=1:pc=079e)
;80f1c8:_l1196(use=0:ref=1:pc=07a2)
;80f228:_l1197(use=0:ref=1:pc=0000)
;80f5e8:_l1198(use=0:ref=1:pc=07cb)
;80f6a8:_l1199(use=0:ref=1:pc=07cf)
;80f708:_l1200(use=3:ref=1:pc=07e3)
;80f828:_l1201(use=0:ref=1:pc=07e7)
;80fb28:_l1202(use=3:ref=1:pc=0809)
;80fb88:_l1203(use=3:ref=1:pc=080b)
;80fd08:_l1204(use=0:ref=1:pc=082e)
;80fdc8:_l1205(use=0:ref=1:pc=0832)
;80fe88:_l1206(use=0:ref=1:pc=0839)
;80ff48:_l1207(use=0:ref=1:pc=083d)
;462c98:_l1208(use=0:ref=1:pc=0849)
;463408:_l1209(use=0:ref=1:pc=084d)
;463c38:_l1210(use=0:ref=1:pc=0859)
;4631a8:_l1211(use=0:ref=1:pc=085d)
;464458:_l1212(use=0:ref=1:pc=0869)
;464818:_l1213(use=0:ref=1:pc=086d)
;465a98:_l1214(use=3:ref=1:pc=08ba)
;465d18:_l1215(use=0:ref=1:pc=08be)
;4661d8:_l1216(use=3:ref=1:pc=08d9)
;466458:_l1217(use=0:ref=1:pc=08dd)
;466a98:_l1218(use=3:ref=1:pc=091f)
;466f98:_l1219(use=0:ref=1:pc=0923)
;46a458:_l1220(use=3:ref=1:pc=09d9)
;46a6d8:_l1221(use=3:ref=1:pc=09db)
;471e58:_l1222(use=3:ref=1:pc=0b31)
;4721d8:_l1223(use=3:ref=1:pc=0b30)
;472458:_l1224(use=3:ref=1:pc=0b3b)
;4726d8:_l1225(use=3:ref=1:pc=0b3a)
;473a98:_l1226(use=0:ref=1:pc=0ba4)
;473e58:_l1227(use=0:ref=1:pc=0ba9)
;474f98:_l1228(use=0:ref=1:pc=0bf2)
;475598:_l1229(use=3:ref=1:pc=0bf7)
;475e58:_l1230(use=3:ref=1:pc=0c0c)
;4761d8:_l1231(use=3:ref=1:pc=0c0b)
;476598:_l1232(use=0:ref=1:pc=0c18)
;476a98:_l1233(use=3:ref=1:pc=0c1c)
;4771d8:_l1234(use=3:ref=1:pc=0c31)
;477458:_l1235(use=3:ref=1:pc=0c30)
;477bd8:_l1236(use=3:ref=1:pc=0c54)
;477e58:_l1237(use=3:ref=1:pc=0c53)
;Unnamed Constant Variables
;============
