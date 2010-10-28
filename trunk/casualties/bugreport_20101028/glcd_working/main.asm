; compiler: jal 2.4n (compiled Jun  2 2010)

; command line:  c:\jallib\compiler\jalv2.exe -debug -Wno-all -long-start main.jal
; compiler flags:
;    boot-fuse, boot-long-start, debug-compiler, debug-codegen
;    opt-expr-reduce, opt-cexpr-reduce, opt-variable-reduce
                                list p=16f886, r=dec
                                errorlevel -306 ; no page boundary warnings
                                errorlevel -302 ; no bank 0 warnings
                                errorlevel -202 ; no 'argument out of range' warnings

                             __config 0x2007, 0x2ff2
                             __config 0x2008, 0x3fff
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
v_input                        EQU 1
v_output                       EQU 0
v_all_input                    EQU 255
v_all_output                   EQU 0
v__pic_accum                   EQU 0x007e  ; _pic_accum
v__pcl                         EQU 0x0002  ; _pcl
v__status                      EQU 0x0003  ; _status
v__z                           EQU 2
v__c                           EQU 0
v_porta                        EQU 0x0005  ; porta
v__porta_shadow                EQU 0x002f  ; _porta_shadow
v_portb                        EQU 0x0006  ; portb
v__portb_shadow                EQU 0x0030  ; _portb_shadow
v_portc                        EQU 0x0007  ; portc
v__portc_shadow                EQU 0x0031  ; _portc_shadow
v__pclath                      EQU 0x000a  ; _pclath
v_pir1                         EQU 0x000c  ; pir1
v_pir1_txif                    EQU 0x000c  ; pir1_txif-->pir1:4
v_t2con                        EQU 0x0012  ; t2con
v_t2con_tmr2on                 EQU 0x0012  ; t2con_tmr2on-->t2con:2
v_ccpr1l                       EQU 0x0015  ; ccpr1l
v_ccp1con                      EQU 0x0017  ; ccp1con
v_rcsta                        EQU 0x0018  ; rcsta
v_txreg                        EQU 0x0019  ; txreg
v_adresh                       EQU 0x001e  ; adresh
v_adcon0                       EQU 0x001f  ; adcon0
v_adcon0_go                    EQU 0x001f  ; adcon0_go-->adcon0:1
v_adcon0_adon                  EQU 0x001f  ; adcon0_adon-->adcon0:0
v_trisa                        EQU 0x0085  ; trisa
v_pin_a5_direction             EQU 0x0085  ; pin_a5_direction-->trisa:5
v_pin_a3_direction             EQU 0x0085  ; pin_a3_direction-->trisa:3
v_pin_a2_direction             EQU 0x0085  ; pin_a2_direction-->trisa:2
v_pin_a1_direction             EQU 0x0085  ; pin_a1_direction-->trisa:1
v_pin_a0_direction             EQU 0x0085  ; pin_a0_direction-->trisa:0
v_trisb                        EQU 0x0086  ; trisb
v_portb_direction              EQU 0x0086  ; portb_direction-->trisb
v_pin_b5_direction             EQU 0x0086  ; pin_b5_direction-->trisb:5
v_pin_b4_direction             EQU 0x0086  ; pin_b4_direction-->trisb:4
v_pin_b3_direction             EQU 0x0086  ; pin_b3_direction-->trisb:3
v_pin_b2_direction             EQU 0x0086  ; pin_b2_direction-->trisb:2
v_pin_b1_direction             EQU 0x0086  ; pin_b1_direction-->trisb:1
v_pin_b0_direction             EQU 0x0086  ; pin_b0_direction-->trisb:0
v_trisc                        EQU 0x0087  ; trisc
v_pin_c5_direction             EQU 0x0087  ; pin_c5_direction-->trisc:5
v_pin_c4_direction             EQU 0x0087  ; pin_c4_direction-->trisc:4
v_pin_c3_direction             EQU 0x0087  ; pin_c3_direction-->trisc:3
v_pin_c2_direction             EQU 0x0087  ; pin_c2_direction-->trisc:2
v_pin_c1_direction             EQU 0x0087  ; pin_c1_direction-->trisc:1
v_pin_c0_direction             EQU 0x0087  ; pin_c0_direction-->trisc:0
v_pie1                         EQU 0x008c  ; pie1
v_pie1_rcie                    EQU 0x008c  ; pie1_rcie-->pie1:5
v_pie1_txie                    EQU 0x008c  ; pie1_txie-->pie1:4
v_pr2                          EQU 0x0092  ; pr2
v_txsta                        EQU 0x0098  ; txsta
v_txsta_txen                   EQU 0x0098  ; txsta_txen-->txsta:5
v_txsta_brgh                   EQU 0x0098  ; txsta_brgh-->txsta:2
v_spbrg                        EQU 0x0099  ; spbrg
v_spbrgh                       EQU 0x009a  ; spbrgh
v_adresl                       EQU 0x009e  ; adresl
v_adcon1                       EQU 0x009f  ; adcon1
v_adcon1_adfm                  EQU 0x009f  ; adcon1_adfm-->adcon1:7
v_cm1con0                      EQU 0x0107  ; cm1con0
v_cm2con0                      EQU 0x0108  ; cm2con0
v_baudctl                      EQU 0x0187  ; baudctl
v_baudctl_brg16                EQU 0x0187  ; baudctl_brg16-->baudctl:3
v_ansel                        EQU 0x0188  ; ansel
v_jansel_ans4                  EQU 0x0188  ; jansel_ans4-->ansel:4
v_jansel_ans3                  EQU 0x0188  ; jansel_ans3-->ansel:3
v_jansel_ans2                  EQU 0x0188  ; jansel_ans2-->ansel:2
v_jansel_ans1                  EQU 0x0188  ; jansel_ans1-->ansel:1
v_jansel_ans0                  EQU 0x0188  ; jansel_ans0-->ansel:0
v_anselh                       EQU 0x0189  ; anselh
v_jansel_ans13                 EQU 0x0189  ; jansel_ans13-->anselh:5
v_jansel_ans12                 EQU 0x0189  ; jansel_ans12-->anselh:4
v_jansel_ans11                 EQU 0x0189  ; jansel_ans11-->anselh:3
v_jansel_ans10                 EQU 0x0189  ; jansel_ans10-->anselh:2
v_jansel_ans9                  EQU 0x0189  ; jansel_ans9-->anselh:1
v_jansel_ans8                  EQU 0x0189  ; jansel_ans8-->anselh:0
v_adc_channel_a                EQU 0
v_adc_nvref                    EQU 0
v_tad_value                    EQU 0x0032  ; tad_value
v_adc_min_tad                  EQU 16
v_adc_max_tad                  EQU 60
v__adcon0_shadow               EQU 0x002c  ; _adcon0_shadow
v_adc_conversion_delay         EQU 0x0033  ; adc_conversion_delay
v_measure_a                    EQU 0x0034  ; measure_a
v__pr2_shadow_plus1            EQU 0x002d  ; _pr2_shadow_plus1
v__ccpr1l_shadow               EQU 0x0036  ; _ccpr1l_shadow
v__ccp1con_shadow              EQU 0x0037  ; _ccp1con_shadow
v_pwmvalue                     EQU 0x0038  ; pwmvalue
v____temp_47                   EQU 0x0039  ; _temp
v_ks0108_left                  EQU 0
v_ks0108_right                 EQU 1
v_ks0108_cmd_on                EQU 63
v_ks0108_cmd_page              EQU 184
v_ks0108_cmd_column            EQU 64
v_buff                         EQU 0x003b  ; buff
v_buffx                        EQU 0x003c  ; buffx
v_buffy                        EQU 0x003d  ; buffy
v_timer                        EQU 0x003e  ; timer
v_oldadc                       EQU 0x003f  ; oldadc
v___e1_2                       EQU 0x0045  ; e1-->_bitbucket:5
v___e2_2                       EQU 0x0045  ; e2-->_bitbucket:6
v_graphleft                    EQU 0x0041  ; graphleft
v_graphright                   EQU 0x0042  ; graphright
v_graphtop                     EQU 0x0043  ; graphtop
v_graphbottom                  EQU 0x0044  ; graphbottom
v__bitbucket                   EQU 0x0045  ; _bitbucket
v__pic_temp                    EQU 0x0020  ; _pic_temp-->_pic_state
v__pic_loop                    EQU 0x0028  ; _pic_loop
v__pic_multiplier              EQU 0x0020  ; _pic_multiplier-->_pic_state
v__pic_multiplicand            EQU 0x0022  ; _pic_multiplicand-->_pic_state+2
v__pic_mresult                 EQU 0x0024  ; _pic_mresult-->_pic_state+4
v__pic_divisor                 EQU 0x0024  ; _pic_divisor-->_pic_state+4
v__pic_dividend                EQU 0x0020  ; _pic_dividend-->_pic_state
v__pic_quotient                EQU 0x0026  ; _pic_quotient-->_pic_state+6
v__pic_remainder               EQU 0x0022  ; _pic_remainder-->_pic_state+2
v__pic_divaccum                EQU 0x0020  ; _pic_divaccum-->_pic_state
v__pic_pointer                 EQU 0x002a  ; _pic_pointer
v__pic_state                   EQU 0x0020  ; _pic_state
v___vcfg_shadow_3              EQU 0x0047  ; vcfg_shadow
v____btemp32_2                 EQU 0x0045  ; _btemp32-->_bitbucket:10
v____btemp34_2                 EQU 0x0045  ; _btemp34-->_bitbucket:12
v____btemp36_2                 EQU 0x0045  ; _btemp36-->_bitbucket:14
v___x_135                      EQU 0x0047  ; x
v___x_136                      EQU 0x0031  ; x-->_portc_shadow:4
v___x_137                      EQU 0x002f  ; x-->_porta_shadow:5
v___x_138                      EQU 0x0031  ; x-->_portc_shadow:1
v___x_139                      EQU 0x0031  ; x-->_portc_shadow:0
v___side_46                    EQU 0x0047  ; side
v___page_4                     EQU 0x0048  ; page
v____temp_119                  EQU 0x0049  ; _temp
v___side_47                    EQU 0x0047  ; side
v___page_5                     EQU 0x0048  ; page
v____temp_120                  EQU 0x0049  ; _temp
v___side_48                    EQU 0x0047  ; side
v___column_6                   EQU 0x0048  ; column
v____temp_121                  EQU 0x0049  ; _temp
v___side_49                    EQU 0x0047  ; side
v___column_7                   EQU 0x0048  ; column
v____temp_122                  EQU 0x0049  ; _temp
v___x0_8                       EQU 0x0047  ; x0
v___y_16                       EQU 0x0048  ; y
v___x1_8                       EQU 0x0049  ; x1
v___value_4                    EQU 0x004a  ; value
v___max_4                      EQU 0x004c  ; max
v___startleft_2                EQU 0x0045  ; startleft-->_bitbucket:7
v___maxx_1                     EQU 0x004e  ; maxx
v___thevalue_2                 EQU 0x004f  ; thevalue
v____temp_123                  EQU 0x0051  ; _temp
v____rparam16_1                EQU 0x0054  ; _rparam16
v__btemp107                    EQU 0x0045  ; _btemp107-->_bitbucket:4
v___x_131                      EQU 0x0055  ; lcd_print:x
v___y_13                       EQU 0x0057  ; lcd_print:y
v____str_count_1               EQU 0x005b  ; lcd_print:_str_count
v___str_3                      EQU 0x005e  ; lcd_print:str
v___i_1                        EQU 0x0064  ; lcd_print:i
v___j_1                        EQU 0x0065  ; lcd_print:j
v____temp_111                  EQU 0x0066  ; lcd_print:_temp
v____bitbucket_3               EQU 0x0067  ; lcd_print:_bitbucket
v__rparam14                    EQU 0x0068  ; lcd_print:_rparam14
v___x_132                      EQU 0x006a  ; lcd_print:x
v___debug_6                    EQU 0x0067  ; lcd_print:debug-->_bitbucket3:0
v___findex_5                   EQU 0x006b  ; lcd_print:findex
v___cx_5                       EQU 0x00a0  ; lcd_print:cx
v___doloop_5                   EQU 0x006e  ; lcd_print:doloop
v____temp_112                  EQU 0x00a3  ; lcd_print:_temp
v____floop7_5                  EQU 0x00aa  ; lcd_print:_floop7
v____rparam3_5                 EQU 0x00ae  ; lcd_print:_rparam3
v___side_42                    EQU 0x00af  ; lcd_print:side
v____temp_113                  EQU 0x00b0  ; lcd_print:_temp
v___side_43                    EQU 0x00af  ; lcd_print:side
v____temp_114                  EQU 0x00b0  ; lcd_print:_temp
v____rparam4_5                 EQU 0x00ae  ; lcd_print:_rparam4
v____rparam5_5                 EQU 0x00af  ; lcd_print:_rparam5
v___side_44                    EQU 0x00b0  ; lcd_print:side
v____temp_115                  EQU 0x00b1  ; lcd_print:_temp
v___side_45                    EQU 0x00b0  ; lcd_print:side
v____temp_116                  EQU 0x00b1  ; lcd_print:_temp
v___x_126                      EQU 0x0055  ; lcd_num:x
v___y_11                       EQU 0x0057  ; lcd_num:y
v___num_1                      EQU 0x005b  ; lcd_num:num
v____temp_95                   EQU 0x005e  ; lcd_num:_temp
v_hundrets                     EQU 0x0066  ; lcd_num:hundrets
v_tens                         EQU 0x0067  ; lcd_num:tens
v_ones                         EQU 0x0068  ; lcd_num:ones
v__rparam9                     EQU 0x006a  ; lcd_num:_rparam9
v__rparam11                    EQU 0x006b  ; lcd_num:_rparam11
v__rparam13                    EQU 0x006d  ; lcd_num:_rparam13
v____bitbucket_4               EQU 0x00a0  ; lcd_num:_bitbucket
v___x_127                      EQU 0x006e  ; lcd_num:x
v___debug_3                    EQU 0x00a0  ; lcd_num:debug-->_bitbucket4:0
v___findex_2                   EQU 0x00a3  ; lcd_num:findex
v___cx_2                       EQU 0x00a7  ; lcd_num:cx
v___doloop_2                   EQU 0x00a8  ; lcd_num:doloop
v____temp_96                   EQU 0x00aa  ; lcd_num:_temp
v____floop7_2                  EQU 0x00b1  ; lcd_num:_floop7
v____rparam3_2                 EQU 0x00b2  ; lcd_num:_rparam3
v___side_30                    EQU 0x00b3  ; lcd_num:side
v____temp_97                   EQU 0x00b4  ; lcd_num:_temp
v___side_31                    EQU 0x00b3  ; lcd_num:side
v____temp_98                   EQU 0x00b4  ; lcd_num:_temp
v____rparam4_2                 EQU 0x00b2  ; lcd_num:_rparam4
v____rparam5_2                 EQU 0x00b3  ; lcd_num:_rparam5
v___side_32                    EQU 0x00b4  ; lcd_num:side
v____temp_99                   EQU 0x00b5  ; lcd_num:_temp
v___side_33                    EQU 0x00b4  ; lcd_num:side
v____temp_100                  EQU 0x00b5  ; lcd_num:_temp
v___x_128                      EQU 0x006e  ; lcd_num:x
v___debug_4                    EQU 0x00a0  ; lcd_num:debug-->_bitbucket4:0
v___findex_3                   EQU 0x00a3  ; lcd_num:findex
v___cx_3                       EQU 0x00a7  ; lcd_num:cx
v___doloop_3                   EQU 0x00a8  ; lcd_num:doloop
v____temp_101                  EQU 0x00aa  ; lcd_num:_temp
v____floop7_3                  EQU 0x00b1  ; lcd_num:_floop7
v____rparam3_3                 EQU 0x00b2  ; lcd_num:_rparam3
v___side_34                    EQU 0x00b3  ; lcd_num:side
v____temp_102                  EQU 0x00b4  ; lcd_num:_temp
v___side_35                    EQU 0x00b3  ; lcd_num:side
v____temp_103                  EQU 0x00b4  ; lcd_num:_temp
v____rparam4_3                 EQU 0x00b2  ; lcd_num:_rparam4
v____rparam5_3                 EQU 0x00b3  ; lcd_num:_rparam5
v___side_36                    EQU 0x00b4  ; lcd_num:side
v____temp_104                  EQU 0x00b5  ; lcd_num:_temp
v___side_37                    EQU 0x00b4  ; lcd_num:side
v____temp_105                  EQU 0x00b5  ; lcd_num:_temp
v___x_129                      EQU 0x006e  ; lcd_num:x
v___debug_5                    EQU 0x00a0  ; lcd_num:debug-->_bitbucket4:0
v___findex_4                   EQU 0x00a3  ; lcd_num:findex
v___cx_4                       EQU 0x00a7  ; lcd_num:cx
v___doloop_4                   EQU 0x00a8  ; lcd_num:doloop
v____temp_106                  EQU 0x00aa  ; lcd_num:_temp
v____floop7_4                  EQU 0x00b1  ; lcd_num:_floop7
v____rparam3_4                 EQU 0x00b2  ; lcd_num:_rparam3
v___side_38                    EQU 0x00b3  ; lcd_num:side
v____temp_107                  EQU 0x00b4  ; lcd_num:_temp
v___side_39                    EQU 0x00b3  ; lcd_num:side
v____temp_108                  EQU 0x00b4  ; lcd_num:_temp
v____rparam4_4                 EQU 0x00b2  ; lcd_num:_rparam4
v____rparam5_4                 EQU 0x00b3  ; lcd_num:_rparam5
v___side_40                    EQU 0x00b4  ; lcd_num:side
v____temp_109                  EQU 0x00b5  ; lcd_num:_temp
v___side_41                    EQU 0x00b4  ; lcd_num:side
v____temp_110                  EQU 0x00b5  ; lcd_num:_temp
v___x0_5                       EQU 0x0055  ; lcd_filled_rect:x0
v___y0_5                       EQU 0x0057  ; lcd_filled_rect:y0
v___x1_5                       EQU 0x005b  ; lcd_filled_rect:x1
v___y1_5                       EQU 0x005d  ; lcd_filled_rect:y1
v___state_1                    EQU 0x00a0  ; lcd_filled_rect:state-->_bitbucket9:0
v____temp_83                   EQU 0x005e  ; lcd_filled_rect:_temp
v_xdiff                        EQU 0x0064  ; lcd_filled_rect:xdiff
v_ydiff                        EQU 0x0065  ; lcd_filled_rect:ydiff
v_currx                        EQU 0x0066  ; lcd_filled_rect:currx
v_curry                        EQU 0x0067  ; lcd_filled_rect:curry
v___write_2                    EQU 0x00a0  ; lcd_filled_rect:write-->_bitbucket9:1
v_area                         EQU 0x0068  ; lcd_filled_rect:area
v__floop9                      EQU 0x006b  ; lcd_filled_rect:_floop9
v____bitbucket_9               EQU 0x00a0  ; lcd_filled_rect:_bitbucket
v__btemp95                     EQU 0x00a0  ; lcd_filled_rect:_btemp95-->_bitbucket9:2
v__btemp96                     EQU 0x00a0  ; lcd_filled_rect:_btemp96-->_bitbucket9:3
v__btemp97                     EQU 0x00a0  ; lcd_filled_rect:_btemp97-->_bitbucket9:4
v__rparam8                     EQU 0x006f  ; lcd_filled_rect:_rparam8
v__btemp99                     EQU 0x00a0  ; lcd_filled_rect:_btemp99-->_bitbucket9:6
v__btemp100                    EQU 0x00a0  ; lcd_filled_rect:_btemp100-->_bitbucket9:7
v__btemp101                    EQU 0x00a0  ; lcd_filled_rect:_btemp101-->_bitbucket9:8
v___x_123                      EQU 0x00a7  ; lcd_filled_rect:x
v___e1_1                       EQU 0x00a0  ; lcd_filled_rect:e1-->_bitbucket9:10
v___e3_1                       EQU 0x00a0  ; lcd_filled_rect:e3-->_bitbucket9:11
v___e4_1                       EQU 0x00a0  ; lcd_filled_rect:e4-->_bitbucket9:12
v___e2_1                       EQU 0x00a0  ; lcd_filled_rect:e2-->_bitbucket9:13
v____btemp77_1                 EQU 0x00a0  ; lcd_filled_rect:_btemp77-->_bitbucket9:14
v____temp_84                   EQU 0x00a8  ; lcd_filled_rect:_temp
v____btemp79_1                 EQU 0x00a0  ; lcd_filled_rect:_btemp79-->_bitbucket9:16
v____btemp83_1                 EQU 0x00a0  ; lcd_filled_rect:_btemp83-->_bitbucket9:20
v___data_22                    EQU 0x00ae  ; lcd_filled_rect:data
v___yy_3                       EQU 0x00af  ; lcd_filled_rect:yy
v___side_25                    EQU 0x00b0  ; lcd_filled_rect:side
v____rparam6_1                 EQU 0x00b1  ; lcd_filled_rect:_rparam6
v____temp_85                   EQU 0x00b2  ; lcd_filled_rect:_temp
v____temp_86                   EQU 0x00b2  ; lcd_filled_rect:_temp
v____temp_87                   EQU 0x00b1  ; lcd_filled_rect:_temp
v___x0_1                       EQU 0x0055  ; lcd_line:x0
v___y0_1                       EQU 0x0057  ; lcd_line:y0
v___x1_1                       EQU 0x005b  ; lcd_line:x1
v___y1_1                       EQU 0x005d  ; lcd_line:y1
v___onoff_5                    EQU 0x006a  ; lcd_line:onoff-->_bitbucket11:0
v_xi                           EQU 0x005e  ; lcd_line:xi
v_yi                           EQU 0x0062  ; lcd_line:yi
v_xfark                        EQU 0x0064  ; lcd_line:xfark
v_yfark                        EQU 0x0065  ; lcd_line:yfark
v_fark                         EQU 0x0066  ; lcd_line:fark
v_xx                           EQU 0x0067  ; lcd_line:xx
v__floop8                      EQU 0x0068  ; lcd_line:_floop8
v____bitbucket_11              EQU 0x006a  ; lcd_line:_bitbucket
v___x_122                      EQU 0x006b  ; lcd_line:x
v___data_21                    EQU 0x006d  ; lcd_line:data
v___yy_2                       EQU 0x00a0  ; lcd_line:yy
v___side_24                    EQU 0x006e  ; lcd_line:side
v____temp_79                   EQU 0x00a3  ; lcd_line:_temp
v____rparam0_1                 EQU 0x00a7  ; lcd_line:_rparam0
v____temp_80                   EQU 0x00a8  ; lcd_line:_temp
v____temp_81                   EQU 0x00a8  ; lcd_line:_temp
v____temp_82                   EQU 0x00a8  ; lcd_line:_temp
v____temp_74                   EQU 0       ; lcd_write_pixel_buff(): _temp
v___data_19                    EQU 0x0055  ; lcd_fill:data
v_i                            EQU 0x0057  ; lcd_fill:i
v__floop5                      EQU 0x005b  ; lcd_fill:_floop5
v__floop6                      EQU 0x005d  ; lcd_fill:_floop6
v___side_11                    EQU 0x005e  ; lcd_fill:side
v____temp_60                   EQU 0x0062  ; lcd_fill:_temp
v___side_12                    EQU 0x005e  ; lcd_fill:side
v____temp_61                   EQU 0x0062  ; lcd_fill:_temp
v___side_13                    EQU 0x005e  ; lcd_fill:side
v___column_2                   EQU 0x0062  ; lcd_fill:column
v____temp_62                   EQU 0x0064  ; lcd_fill:_temp
v___side_14                    EQU 0x005e  ; lcd_fill:side
v___column_3                   EQU 0x0062  ; lcd_fill:column
v____temp_63                   EQU 0x0064  ; lcd_fill:_temp
v____temp_57                   EQU 0       ; ks0108_read_byte(): _temp
v___x_110                      EQU 0x00b3  ; ks0108_write_byte:x
v___y_3                        EQU 0x00b4  ; ks0108_write_byte:y
v___veri_1                     EQU 0x00b5  ; ks0108_write_byte:veri
v___side_9                     EQU 0x00b6  ; ks0108_write_byte:side
v__rparam1                     EQU 0x00b8  ; ks0108_write_byte:_rparam1
v____temp_55                   EQU 0x00b9  ; ks0108_write_byte:_temp
v____temp_56                   EQU 0x00b9  ; ks0108_write_byte:_temp
v____temp_50                   EQU 0       ; lcd_write_pixel(): _temp
v___x_106                      EQU 0x0031  ; _ks0108_data:x-->_portc_shadow:5
v___x_105                      EQU 0x0031  ; _ks0108_inst:x-->_portc_shadow:5
v___side_3                     EQU 0x00b3  ; _ks0108_read:side
v___data_15                    EQU 0x00b4  ; _ks0108_read:data
v___x_98                       EQU 0x0031  ; _ks0108_read:x-->_portc_shadow:0
v___x_99                       EQU 0x0031  ; _ks0108_read:x-->_portc_shadow:1
v___x_100                      EQU 0x0031  ; _ks0108_read:x-->_portc_shadow:3
v___x_101                      EQU 0x002f  ; _ks0108_read:x-->_porta_shadow:5
v___x_102                      EQU 0x002f  ; _ks0108_read:x-->_porta_shadow:5
v___x_103                      EQU 0x0031  ; _ks0108_read:x-->_portc_shadow:1
v___x_104                      EQU 0x0031  ; _ks0108_read:x-->_portc_shadow:0
v___side_1                     EQU 0x00ba  ; _ks0108_write:side
v___data_14                    EQU 0x00bb  ; _ks0108_write:data
v___x_91                       EQU 0x0031  ; _ks0108_write:x-->_portc_shadow:0
v___x_92                       EQU 0x0031  ; _ks0108_write:x-->_portc_shadow:1
v___x_93                       EQU 0x0031  ; _ks0108_write:x-->_portc_shadow:3
v___x_94                       EQU 0x002f  ; _ks0108_write:x-->_porta_shadow:5
v___x_95                       EQU 0x002f  ; _ks0108_write:x-->_porta_shadow:5
v___x_96                       EQU 0x0031  ; _ks0108_write:x-->_portc_shadow:1
v___x_97                       EQU 0x0031  ; _ks0108_write:x-->_portc_shadow:0
v___b_1                        EQU 0x00b6  ; serial_hw_byte:b
v_zw                           EQU 0x00b9  ; serial_hw_byte:zw
v_oldb                         EQU 0x00ba  ; serial_hw_byte:oldb
v____temp_46                   EQU 0x00bb  ; serial_hw_byte:_temp
v__str_count                   EQU 0x0055  ; serial_hw_printf:_str_count
v___str_1                      EQU 0x005b  ; serial_hw_printf:str
v_l                            EQU 0x005e  ; serial_hw_printf:l
v_t                            EQU 0x0062  ; serial_hw_printf:t
v___data_3                     EQU 0       ; serial_hw_write_word(): data
v___data_1                     EQU 0x00bd  ; serial_hw_write:data
v_usart_div                    EQU 259     ; _calculate_and_set_baudrate(): usart_div
v___duty_5                     EQU 0x0055  ; pwm1_set_dutycycle:duty
v____temp_40                   EQU 0x0057  ; pwm1_set_dutycycle:_temp
v___duty_1                     EQU 0x0062  ; pwm1_set_dutycycle_highres:duty
v___prescaler_1                EQU 0x0055  ; pwm_max_resolution:prescaler
v___adc_chan_7                 EQU 0x0055  ; adc_read_low_res:adc_chan
v_adc_value                    EQU 0x0057  ; adc_read_low_res:adc_value
v_shift_alias                  EQU 0x005b  ; adc_read_low_res:shift_alias
v___ax_2                       EQU 0x005b  ; adc_read_low_res:ax-->shift_alias
v___ad_value_1                 EQU 0       ; adc_read_bytes(): ad_value
v____temp_34                   EQU 0       ; adc_read_bytes(): _temp
v___adc_chan_3                 EQU 0x0055  ; adc_read:adc_chan
v_ad_value                     EQU 0x0057  ; adc_read:ad_value
v_ax                           EQU 0x0057  ; adc_read:ax-->ad_value
v___adc_chan_1                 EQU 0x005e  ; _adc_read_low_res:adc_chan
v___adc_byte_1                 EQU 0x0062  ; _adc_read_low_res:adc_byte
v___factor_1                   EQU 0x0055  ; _adc_eval_tad:factor
v_tad_ok                       EQU 0x005e  ; _adc_eval_tad:tad_ok-->_bitbucket64:0
v____temp_33                   EQU 0x005b  ; _adc_eval_tad:_temp
v__btemp29                     EQU 0x005e  ; _adc_eval_tad:_btemp29-->_bitbucket64:1
v__btemp30                     EQU 0x005e  ; _adc_eval_tad:_btemp30-->_bitbucket64:2
v__btemp31                     EQU 0x005e  ; _adc_eval_tad:_btemp31-->_bitbucket64:3
v____bitbucket_64              EQU 0x005e  ; _adc_eval_tad:_bitbucket
v___an_pin_num_1               EQU 0x0055  ; set_analog_pin:an_pin_num
v___n_3                        EQU 0x0055  ; delay_1ms:n
v__floop2                      EQU 0x005b  ; delay_1ms:_floop2
v___n_1                        EQU 0x0064  ; delay_10us:n
v__floop1                      EQU 0x0065  ; delay_10us:_floop1
;    2 include 16f886
                               org      0                   ;  0 -- -- -- [-- --] 0000
                               branchhi_clr l__main         ;  0 -V rs rs [hl hl] 0000 120a
                               branchlo_clr l__main         ;  0 -V rs rs [hl hl] 0001 118a
                               goto     l__main             ;  0 -V rs rs [hl hl] 0002 2acc
                               nop                          ; 4294967295 -- -- -- [-- --] 0003 0000
l__lookup_myfonttable
                               movwf    v__pclath           ;  2 -V r? rS [?l ?l] 0004 008a
                               movf     v__pic_loop,w       ;  2 -V r? rS [?l ?l] 0005 0828
                               addlw    10                  ;  2 -V r? rS [?l ?l] 0006 3e0a
                                                            ; W = v__pic_loop
                               btfsc    v__status, v__c     ;  2 -V r? rS [?l ?l] 0007 1803
                               incf     v__pclath,f         ;  2 -V r? rS [?l ?l] 0008 0a8a
                               movwf    v__pcl              ;  2 -V r? rS [?l ?l] 0009 0082
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 000a 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 000b 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 000c 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 000d 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 000e 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 000f 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0010 3400
                               retlw    47                  ; 4294967295 -V -- -- [-- --] 0011 342f
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0012 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0013 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0014 3400
                               retlw    7                   ; 4294967295 -V -- -- [-- --] 0015 3407
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0016 3400
                               retlw    7                   ; 4294967295 -V -- -- [-- --] 0017 3407
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0018 3400
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 0019 3414
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 001a 347f
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 001b 3414
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 001c 347f
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 001d 3414
                               retlw    36                  ; 4294967295 -V -- -- [-- --] 001e 3424
                               retlw    42                  ; 4294967295 -V -- -- [-- --] 001f 342a
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 0020 347f
                               retlw    42                  ; 4294967295 -V -- -- [-- --] 0021 342a
                               retlw    18                  ; 4294967295 -V -- -- [-- --] 0022 3412
                               retlw    196                 ; 4294967295 -V -- -- [-- --] 0023 34c4
                               retlw    200                 ; 4294967295 -V -- -- [-- --] 0024 34c8
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 0025 3410
                               retlw    38                  ; 4294967295 -V -- -- [-- --] 0026 3426
                               retlw    70                  ; 4294967295 -V -- -- [-- --] 0027 3446
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 0028 3436
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 0029 3449
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 002a 3455
                               retlw    34                  ; 4294967295 -V -- -- [-- --] 002b 3422
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 002c 3450
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 002d 3400
                               retlw    5                   ; 4294967295 -V -- -- [-- --] 002e 3405
                               retlw    3                   ; 4294967295 -V -- -- [-- --] 002f 3403
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0030 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0031 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0032 3400
                               retlw    28                  ; 4294967295 -V -- -- [-- --] 0033 341c
                               retlw    34                  ; 4294967295 -V -- -- [-- --] 0034 3422
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 0035 3441
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0036 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0037 3400
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 0038 3441
                               retlw    34                  ; 4294967295 -V -- -- [-- --] 0039 3422
                               retlw    28                  ; 4294967295 -V -- -- [-- --] 003a 341c
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 003b 3400
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 003c 3414
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 003d 3408
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 003e 343e
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 003f 3408
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 0040 3414
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 0041 3408
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 0042 3408
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 0043 343e
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 0044 3408
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 0045 3408
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0046 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0047 3400
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 0048 3450
                               retlw    48                  ; 4294967295 -V -- -- [-- --] 0049 3430
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 004a 3400
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 004b 3410
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 004c 3410
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 004d 3410
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 004e 3410
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 004f 3410
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0050 3400
                               retlw    96                  ; 4294967295 -V -- -- [-- --] 0051 3460
                               retlw    96                  ; 4294967295 -V -- -- [-- --] 0052 3460
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0053 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0054 3400
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0055 3420
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 0056 3410
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 0057 3408
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 0058 3404
                               retlw    2                   ; 4294967295 -V -- -- [-- --] 0059 3402
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 005a 343e
                               retlw    81                  ; 4294967295 -V -- -- [-- --] 005b 3451
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 005c 3449
                               retlw    69                  ; 4294967295 -V -- -- [-- --] 005d 3445
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 005e 343e
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 005f 3400
                               retlw    66                  ; 4294967295 -V -- -- [-- --] 0060 3442
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 0061 347f
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0062 3440
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0063 3400
                               retlw    66                  ; 4294967295 -V -- -- [-- --] 0064 3442
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 0065 3461
                               retlw    81                  ; 4294967295 -V -- -- [-- --] 0066 3451
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 0067 3449
                               retlw    70                  ; 4294967295 -V -- -- [-- --] 0068 3446
                               retlw    33                  ; 4294967295 -V -- -- [-- --] 0069 3421
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 006a 3441
                               retlw    69                  ; 4294967295 -V -- -- [-- --] 006b 3445
                               retlw    75                  ; 4294967295 -V -- -- [-- --] 006c 344b
                               retlw    49                  ; 4294967295 -V -- -- [-- --] 006d 3431
                               retlw    24                  ; 4294967295 -V -- -- [-- --] 006e 3418
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 006f 3414
                               retlw    18                  ; 4294967295 -V -- -- [-- --] 0070 3412
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 0071 347f
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 0072 3410
                               retlw    39                  ; 4294967295 -V -- -- [-- --] 0073 3427
                               retlw    69                  ; 4294967295 -V -- -- [-- --] 0074 3445
                               retlw    69                  ; 4294967295 -V -- -- [-- --] 0075 3445
                               retlw    69                  ; 4294967295 -V -- -- [-- --] 0076 3445
                               retlw    57                  ; 4294967295 -V -- -- [-- --] 0077 3439
                               retlw    60                  ; 4294967295 -V -- -- [-- --] 0078 343c
                               retlw    74                  ; 4294967295 -V -- -- [-- --] 0079 344a
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 007a 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 007b 3449
                               retlw    48                  ; 4294967295 -V -- -- [-- --] 007c 3430
                               retlw    1                   ; 4294967295 -V -- -- [-- --] 007d 3401
                               retlw    113                 ; 4294967295 -V -- -- [-- --] 007e 3471
                               retlw    9                   ; 4294967295 -V -- -- [-- --] 007f 3409
                               retlw    5                   ; 4294967295 -V -- -- [-- --] 0080 3405
                               retlw    3                   ; 4294967295 -V -- -- [-- --] 0081 3403
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 0082 3436
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 0083 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 0084 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 0085 3449
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 0086 3436
                               retlw    6                   ; 4294967295 -V -- -- [-- --] 0087 3406
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 0088 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 0089 3449
                               retlw    41                  ; 4294967295 -V -- -- [-- --] 008a 3429
                               retlw    30                  ; 4294967295 -V -- -- [-- --] 008b 341e
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 008c 3400
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 008d 3436
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 008e 3436
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 008f 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0090 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0091 3400
                               retlw    86                  ; 4294967295 -V -- -- [-- --] 0092 3456
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 0093 3436
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0094 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0095 3400
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 0096 3408
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 0097 3414
                               retlw    34                  ; 4294967295 -V -- -- [-- --] 0098 3422
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 0099 3441
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 009a 3400
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 009b 3414
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 009c 3414
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 009d 3414
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 009e 3414
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 009f 3414
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 00a0 3400
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00a1 3441
                               retlw    34                  ; 4294967295 -V -- -- [-- --] 00a2 3422
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 00a3 3414
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 00a4 3408
                               retlw    2                   ; 4294967295 -V -- -- [-- --] 00a5 3402
                               retlw    1                   ; 4294967295 -V -- -- [-- --] 00a6 3401
                               retlw    81                  ; 4294967295 -V -- -- [-- --] 00a7 3451
                               retlw    9                   ; 4294967295 -V -- -- [-- --] 00a8 3409
                               retlw    6                   ; 4294967295 -V -- -- [-- --] 00a9 3406
                               retlw    50                  ; 4294967295 -V -- -- [-- --] 00aa 3432
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 00ab 3449
                               retlw    89                  ; 4294967295 -V -- -- [-- --] 00ac 3459
                               retlw    81                  ; 4294967295 -V -- -- [-- --] 00ad 3451
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 00ae 343e
                               retlw    126                 ; 4294967295 -V -- -- [-- --] 00af 347e
                               retlw    17                  ; 4294967295 -V -- -- [-- --] 00b0 3411
                               retlw    17                  ; 4294967295 -V -- -- [-- --] 00b1 3411
                               retlw    17                  ; 4294967295 -V -- -- [-- --] 00b2 3411
                               retlw    126                 ; 4294967295 -V -- -- [-- --] 00b3 347e
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00b4 347f
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 00b5 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 00b6 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 00b7 3449
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 00b8 3436
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 00b9 343e
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00ba 3441
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00bb 3441
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00bc 3441
                               retlw    34                  ; 4294967295 -V -- -- [-- --] 00bd 3422
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00be 347f
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00bf 3441
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00c0 3441
                               retlw    34                  ; 4294967295 -V -- -- [-- --] 00c1 3422
                               retlw    28                  ; 4294967295 -V -- -- [-- --] 00c2 341c
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00c3 347f
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 00c4 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 00c5 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 00c6 3449
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00c7 3441
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00c8 347f
                               retlw    9                   ; 4294967295 -V -- -- [-- --] 00c9 3409
                               retlw    9                   ; 4294967295 -V -- -- [-- --] 00ca 3409
                               retlw    9                   ; 4294967295 -V -- -- [-- --] 00cb 3409
                               retlw    1                   ; 4294967295 -V -- -- [-- --] 00cc 3401
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 00cd 343e
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00ce 3441
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 00cf 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 00d0 3449
                               retlw    122                 ; 4294967295 -V -- -- [-- --] 00d1 347a
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00d2 347f
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 00d3 3408
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 00d4 3408
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 00d5 3408
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00d6 347f
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 00d7 3400
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00d8 3441
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00d9 347f
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00da 3441
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 00db 3400
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 00dc 3420
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 00dd 3440
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00de 3441
                               retlw    63                  ; 4294967295 -V -- -- [-- --] 00df 343f
                               retlw    1                   ; 4294967295 -V -- -- [-- --] 00e0 3401
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00e1 347f
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 00e2 3408
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 00e3 3414
                               retlw    34                  ; 4294967295 -V -- -- [-- --] 00e4 3422
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00e5 3441
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00e6 347f
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 00e7 3440
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 00e8 3440
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 00e9 3440
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 00ea 3440
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00eb 347f
                               retlw    2                   ; 4294967295 -V -- -- [-- --] 00ec 3402
                               retlw    12                  ; 4294967295 -V -- -- [-- --] 00ed 340c
                               retlw    2                   ; 4294967295 -V -- -- [-- --] 00ee 3402
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00ef 347f
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00f0 347f
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 00f1 3404
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 00f2 3408
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 00f3 3410
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00f4 347f
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 00f5 343e
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00f6 3441
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00f7 3441
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 00f8 3441
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 00f9 343e
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 00fa 347f
                               retlw    9                   ; 4294967295 -V -- -- [-- --] 00fb 3409
                               retlw    9                   ; 4294967295 -V -- -- [-- --] 00fc 3409
                               retlw    9                   ; 4294967295 -V -- -- [-- --] 00fd 3409
                               retlw    6                   ; 4294967295 -V -- -- [-- --] 00fe 3406
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 00ff 343e
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 0100 3441
                               retlw    81                  ; 4294967295 -V -- -- [-- --] 0101 3451
                               retlw    33                  ; 4294967295 -V -- -- [-- --] 0102 3421
                               retlw    94                  ; 4294967295 -V -- -- [-- --] 0103 345e
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 0104 347f
                               retlw    9                   ; 4294967295 -V -- -- [-- --] 0105 3409
                               retlw    25                  ; 4294967295 -V -- -- [-- --] 0106 3419
                               retlw    41                  ; 4294967295 -V -- -- [-- --] 0107 3429
                               retlw    70                  ; 4294967295 -V -- -- [-- --] 0108 3446
                               retlw    70                  ; 4294967295 -V -- -- [-- --] 0109 3446
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 010a 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 010b 3449
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 010c 3449
                               retlw    49                  ; 4294967295 -V -- -- [-- --] 010d 3431
                               retlw    1                   ; 4294967295 -V -- -- [-- --] 010e 3401
                               retlw    1                   ; 4294967295 -V -- -- [-- --] 010f 3401
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 0110 347f
                               retlw    1                   ; 4294967295 -V -- -- [-- --] 0111 3401
                               retlw    1                   ; 4294967295 -V -- -- [-- --] 0112 3401
                               retlw    63                  ; 4294967295 -V -- -- [-- --] 0113 343f
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0114 3440
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0115 3440
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0116 3440
                               retlw    63                  ; 4294967295 -V -- -- [-- --] 0117 343f
                               retlw    31                  ; 4294967295 -V -- -- [-- --] 0118 341f
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0119 3420
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 011a 3440
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 011b 3420
                               retlw    31                  ; 4294967295 -V -- -- [-- --] 011c 341f
                               retlw    63                  ; 4294967295 -V -- -- [-- --] 011d 343f
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 011e 3440
                               retlw    56                  ; 4294967295 -V -- -- [-- --] 011f 3438
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0120 3440
                               retlw    63                  ; 4294967295 -V -- -- [-- --] 0121 343f
                               retlw    99                  ; 4294967295 -V -- -- [-- --] 0122 3463
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 0123 3414
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 0124 3408
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 0125 3414
                               retlw    99                  ; 4294967295 -V -- -- [-- --] 0126 3463
                               retlw    7                   ; 4294967295 -V -- -- [-- --] 0127 3407
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 0128 3408
                               retlw    112                 ; 4294967295 -V -- -- [-- --] 0129 3470
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 012a 3408
                               retlw    7                   ; 4294967295 -V -- -- [-- --] 012b 3407
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 012c 3461
                               retlw    81                  ; 4294967295 -V -- -- [-- --] 012d 3451
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 012e 3449
                               retlw    69                  ; 4294967295 -V -- -- [-- --] 012f 3445
                               retlw    67                  ; 4294967295 -V -- -- [-- --] 0130 3443
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0131 3400
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 0132 347f
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 0133 3441
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 0134 3441
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0135 3400
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 0136 3455
                               retlw    42                  ; 4294967295 -V -- -- [-- --] 0137 342a
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 0138 3455
                               retlw    42                  ; 4294967295 -V -- -- [-- --] 0139 342a
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 013a 3455
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 013b 3400
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 013c 3441
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 013d 3441
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 013e 347f
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 013f 3400
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 0140 3404
                               retlw    2                   ; 4294967295 -V -- -- [-- --] 0141 3402
                               retlw    1                   ; 4294967295 -V -- -- [-- --] 0142 3401
                               retlw    2                   ; 4294967295 -V -- -- [-- --] 0143 3402
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 0144 3404
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0145 3440
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0146 3440
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0147 3440
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0148 3440
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0149 3440
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 014a 3400
                               retlw    1                   ; 4294967295 -V -- -- [-- --] 014b 3401
                               retlw    2                   ; 4294967295 -V -- -- [-- --] 014c 3402
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 014d 3404
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 014e 3400
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 014f 3420
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 0150 3454
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 0151 3454
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 0152 3454
                               retlw    120                 ; 4294967295 -V -- -- [-- --] 0153 3478
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 0154 347f
                               retlw    72                  ; 4294967295 -V -- -- [-- --] 0155 3448
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 0156 3444
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 0157 3444
                               retlw    56                  ; 4294967295 -V -- -- [-- --] 0158 3438
                               retlw    56                  ; 4294967295 -V -- -- [-- --] 0159 3438
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 015a 3444
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 015b 3444
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 015c 3444
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 015d 3420
                               retlw    56                  ; 4294967295 -V -- -- [-- --] 015e 3438
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 015f 3444
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 0160 3444
                               retlw    72                  ; 4294967295 -V -- -- [-- --] 0161 3448
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 0162 347f
                               retlw    56                  ; 4294967295 -V -- -- [-- --] 0163 3438
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 0164 3454
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 0165 3454
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 0166 3454
                               retlw    24                  ; 4294967295 -V -- -- [-- --] 0167 3418
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 0168 3408
                               retlw    126                 ; 4294967295 -V -- -- [-- --] 0169 347e
                               retlw    9                   ; 4294967295 -V -- -- [-- --] 016a 3409
                               retlw    1                   ; 4294967295 -V -- -- [-- --] 016b 3401
                               retlw    2                   ; 4294967295 -V -- -- [-- --] 016c 3402
                               retlw    12                  ; 4294967295 -V -- -- [-- --] 016d 340c
                               retlw    82                  ; 4294967295 -V -- -- [-- --] 016e 3452
                               retlw    82                  ; 4294967295 -V -- -- [-- --] 016f 3452
                               retlw    82                  ; 4294967295 -V -- -- [-- --] 0170 3452
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 0171 343e
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 0172 347f
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 0173 3408
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 0174 3404
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 0175 3404
                               retlw    120                 ; 4294967295 -V -- -- [-- --] 0176 3478
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0177 3400
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 0178 3444
                               retlw    125                 ; 4294967295 -V -- -- [-- --] 0179 347d
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 017a 3440
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 017b 3400
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 017c 3420
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 017d 3440
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 017e 3444
                               retlw    61                  ; 4294967295 -V -- -- [-- --] 017f 343d
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0180 3400
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 0181 347f
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 0182 3410
                               retlw    40                  ; 4294967295 -V -- -- [-- --] 0183 3428
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 0184 3444
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0185 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0186 3400
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 0187 3441
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 0188 347f
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0189 3440
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 018a 3400
                               retlw    124                 ; 4294967295 -V -- -- [-- --] 018b 347c
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 018c 3404
                               retlw    24                  ; 4294967295 -V -- -- [-- --] 018d 3418
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 018e 3404
                               retlw    120                 ; 4294967295 -V -- -- [-- --] 018f 3478
                               retlw    124                 ; 4294967295 -V -- -- [-- --] 0190 347c
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 0191 3408
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 0192 3404
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 0193 3404
                               retlw    120                 ; 4294967295 -V -- -- [-- --] 0194 3478
                               retlw    56                  ; 4294967295 -V -- -- [-- --] 0195 3438
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 0196 3444
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 0197 3444
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 0198 3444
                               retlw    56                  ; 4294967295 -V -- -- [-- --] 0199 3438
                               retlw    124                 ; 4294967295 -V -- -- [-- --] 019a 347c
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 019b 3414
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 019c 3414
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 019d 3414
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 019e 3408
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 019f 3408
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 01a0 3414
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 01a1 3414
                               retlw    24                  ; 4294967295 -V -- -- [-- --] 01a2 3418
                               retlw    124                 ; 4294967295 -V -- -- [-- --] 01a3 347c
                               retlw    124                 ; 4294967295 -V -- -- [-- --] 01a4 347c
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 01a5 3408
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 01a6 3404
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 01a7 3404
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 01a8 3408
                               retlw    72                  ; 4294967295 -V -- -- [-- --] 01a9 3448
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 01aa 3454
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 01ab 3454
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 01ac 3454
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 01ad 3420
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 01ae 3404
                               retlw    63                  ; 4294967295 -V -- -- [-- --] 01af 343f
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 01b0 3444
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 01b1 3440
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 01b2 3420
                               retlw    60                  ; 4294967295 -V -- -- [-- --] 01b3 343c
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 01b4 3440
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 01b5 3440
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 01b6 3420
                               retlw    124                 ; 4294967295 -V -- -- [-- --] 01b7 347c
                               retlw    28                  ; 4294967295 -V -- -- [-- --] 01b8 341c
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 01b9 3420
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 01ba 3440
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 01bb 3420
                               retlw    28                  ; 4294967295 -V -- -- [-- --] 01bc 341c
                               retlw    60                  ; 4294967295 -V -- -- [-- --] 01bd 343c
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 01be 3440
                               retlw    48                  ; 4294967295 -V -- -- [-- --] 01bf 3430
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 01c0 3440
                               retlw    60                  ; 4294967295 -V -- -- [-- --] 01c1 343c
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 01c2 3444
                               retlw    40                  ; 4294967295 -V -- -- [-- --] 01c3 3428
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 01c4 3410
                               retlw    40                  ; 4294967295 -V -- -- [-- --] 01c5 3428
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 01c6 3444
                               retlw    12                  ; 4294967295 -V -- -- [-- --] 01c7 340c
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 01c8 3450
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 01c9 3450
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 01ca 3450
                               retlw    60                  ; 4294967295 -V -- -- [-- --] 01cb 343c
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 01cc 3444
                               retlw    100                 ; 4294967295 -V -- -- [-- --] 01cd 3464
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 01ce 3454
                               retlw    76                  ; 4294967295 -V -- -- [-- --] 01cf 344c
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 01d0 3444
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01d1 3400
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 01d2 3408
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 01d3 3436
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 01d4 3441
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01d5 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01d6 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01d7 3400
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 01d8 347f
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01d9 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01da 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01db 3400
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 01dc 3441
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 01dd 3436
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 01de 3408
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01df 3400
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 01e0 3408
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 01e1 3404
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 01e2 3408
                               retlw    16                  ; 4294967295 -V -- -- [-- --] 01e3 3410
                               retlw    8                   ; 4294967295 -V -- -- [-- --] 01e4 3408
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01e5 3400
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 01e6 347f
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 01e7 3441
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 01e8 347f
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01e9 3400
                               retlw    20                  ; 4294967295 -V -- -- [-- --] 01ea 3414
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 01eb 343e
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 01ec 3455
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 01ed 3441
                               retlw    34                  ; 4294967295 -V -- -- [-- --] 01ee 3422
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01ef 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01f0 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01f1 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01f2 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01f3 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01f4 3400
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 01f5 3450
                               retlw    48                  ; 4294967295 -V -- -- [-- --] 01f6 3430
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01f7 3400
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 01f8 3400
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 01f9 3455
                               retlw    42                  ; 4294967295 -V -- -- [-- --] 01fa 342a
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 01fb 3455
                               retlw    42                  ; 4294967295 -V -- -- [-- --] 01fc 342a
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 01fd 3455
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 01fe 3455
                               retlw    42                  ; 4294967295 -V -- -- [-- --] 01ff 342a
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 0200 3455
                               retlw    42                  ; 4294967295 -V -- -- [-- --] 0201 342a
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 0202 3455
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0203 3420
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0204 3400
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0205 3420
                               retlw    0                   ; 4294967295 -V -- -- [-- --] 0206 3400
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0207 3420
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 0208 3404
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 0209 3404
                               retlw    127                 ; 4294967295 -V -- -- [-- --] 020a 347f
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 020b 3404
                               retlw    4                   ; 4294967295 -V -- -- [-- --] 020c 3404
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 020d 0782
l__data_test3
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 020e 346f
                               retlw    112                 ; 4294967295 -V -- -- [-- --] 020f 3470
                               retlw    113                 ; 4294967295 -V -- -- [-- --] 0210 3471
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 0211 3472
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 0212 3473
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 0213 3474
                               retlw    117                 ; 4294967295 -V -- -- [-- --] 0214 3475
                               retlw    118                 ; 4294967295 -V -- -- [-- --] 0215 3476
                               retlw    119                 ; 4294967295 -V -- -- [-- --] 0216 3477
                               retlw    120                 ; 4294967295 -V -- -- [-- --] 0217 3478
                               retlw    121                 ; 4294967295 -V -- -- [-- --] 0218 3479
                               retlw    122                 ; 4294967295 -V -- -- [-- --] 0219 347a
                               retlw    48                  ; 4294967295 -V -- -- [-- --] 021a 3430
                               retlw    49                  ; 4294967295 -V -- -- [-- --] 021b 3431
                               retlw    50                  ; 4294967295 -V -- -- [-- --] 021c 3432
                               retlw    51                  ; 4294967295 -V -- -- [-- --] 021d 3433
                               retlw    52                  ; 4294967295 -V -- -- [-- --] 021e 3434
                               retlw    53                  ; 4294967295 -V -- -- [-- --] 021f 3435
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 0220 3436
                               retlw    55                  ; 4294967295 -V -- -- [-- --] 0221 3437
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0222 0782
l__data_test1
                               retlw    65                  ; 4294967295 -V -- -- [-- --] 0223 3441
                               retlw    66                  ; 4294967295 -V -- -- [-- --] 0224 3442
                               retlw    67                  ; 4294967295 -V -- -- [-- --] 0225 3443
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 0226 3444
                               retlw    69                  ; 4294967295 -V -- -- [-- --] 0227 3445
                               retlw    70                  ; 4294967295 -V -- -- [-- --] 0228 3446
                               retlw    71                  ; 4294967295 -V -- -- [-- --] 0229 3447
                               retlw    72                  ; 4294967295 -V -- -- [-- --] 022a 3448
                               retlw    73                  ; 4294967295 -V -- -- [-- --] 022b 3449
                               retlw    74                  ; 4294967295 -V -- -- [-- --] 022c 344a
                               retlw    75                  ; 4294967295 -V -- -- [-- --] 022d 344b
                               retlw    76                  ; 4294967295 -V -- -- [-- --] 022e 344c
                               retlw    77                  ; 4294967295 -V -- -- [-- --] 022f 344d
                               retlw    78                  ; 4294967295 -V -- -- [-- --] 0230 344e
                               retlw    79                  ; 4294967295 -V -- -- [-- --] 0231 344f
                               retlw    80                  ; 4294967295 -V -- -- [-- --] 0232 3450
                               retlw    81                  ; 4294967295 -V -- -- [-- --] 0233 3451
                               retlw    82                  ; 4294967295 -V -- -- [-- --] 0234 3452
                               retlw    83                  ; 4294967295 -V -- -- [-- --] 0235 3453
                               retlw    84                  ; 4294967295 -V -- -- [-- --] 0236 3454
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0237 0782
l__data_test2
                               retlw    85                  ; 4294967295 -V -- -- [-- --] 0238 3455
                               retlw    86                  ; 4294967295 -V -- -- [-- --] 0239 3456
                               retlw    87                  ; 4294967295 -V -- -- [-- --] 023a 3457
                               retlw    88                  ; 4294967295 -V -- -- [-- --] 023b 3458
                               retlw    89                  ; 4294967295 -V -- -- [-- --] 023c 3459
                               retlw    90                  ; 4294967295 -V -- -- [-- --] 023d 345a
                               retlw    97                  ; 4294967295 -V -- -- [-- --] 023e 3461
                               retlw    98                  ; 4294967295 -V -- -- [-- --] 023f 3462
                               retlw    99                  ; 4294967295 -V -- -- [-- --] 0240 3463
                               retlw    100                 ; 4294967295 -V -- -- [-- --] 0241 3464
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0242 3465
                               retlw    102                 ; 4294967295 -V -- -- [-- --] 0243 3466
                               retlw    103                 ; 4294967295 -V -- -- [-- --] 0244 3467
                               retlw    104                 ; 4294967295 -V -- -- [-- --] 0245 3468
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 0246 3469
                               retlw    106                 ; 4294967295 -V -- -- [-- --] 0247 346a
                               retlw    107                 ; 4294967295 -V -- -- [-- --] 0248 346b
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 0249 346c
                               retlw    109                 ; 4294967295 -V -- -- [-- --] 024a 346d
                               retlw    110                 ; 4294967295 -V -- -- [-- --] 024b 346e
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 024c 0782
l__data_test4
                               retlw    56                  ; 4294967295 -V -- -- [-- --] 024d 3438
                               retlw    57                  ; 4294967295 -V -- -- [-- --] 024e 3439
                               retlw    33                  ; 4294967295 -V -- -- [-- --] 024f 3421
                               retlw    64                  ; 4294967295 -V -- -- [-- --] 0250 3440
                               retlw    35                  ; 4294967295 -V -- -- [-- --] 0251 3423
                               retlw    36                  ; 4294967295 -V -- -- [-- --] 0252 3424
                               retlw    37                  ; 4294967295 -V -- -- [-- --] 0253 3425
                               retlw    94                  ; 4294967295 -V -- -- [-- --] 0254 345e
                               retlw    38                  ; 4294967295 -V -- -- [-- --] 0255 3426
                               retlw    42                  ; 4294967295 -V -- -- [-- --] 0256 342a
                               retlw    40                  ; 4294967295 -V -- -- [-- --] 0257 3428
                               retlw    41                  ; 4294967295 -V -- -- [-- --] 0258 3429
                               retlw    128                 ; 4294967295 -V -- -- [-- --] 0259 3480
                               retlw    126                 ; 4294967295 -V -- -- [-- --] 025a 347e
                               retlw    60                  ; 4294967295 -V -- -- [-- --] 025b 343c
                               retlw    62                  ; 4294967295 -V -- -- [-- --] 025c 343e
                               retlw    47                  ; 4294967295 -V -- -- [-- --] 025d 342f
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 025e 0782
l__data_hewo
                               retlw    72                  ; 4294967295 -V -- -- [-- --] 025f 3448
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0260 3465
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 0261 346c
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 0262 346c
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 0263 346f
                               retlw    32                  ; 4294967295 -V -- -- [-- --] 0264 3420
                               retlw    87                  ; 4294967295 -V -- -- [-- --] 0265 3457
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 0266 346f
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 0267 3472
                               retlw    108                 ; 4294967295 -V -- -- [-- --] 0268 346c
                               retlw    100                 ; 4294967295 -V -- -- [-- --] 0269 3464
                               retlw    33                  ; 4294967295 -V -- -- [-- --] 026a 3421
                               retlw    10                  ; 4294967295 -V -- -- [-- --] 026b 340a
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 026c 0782
l__data_test5
                               retlw    124                 ; 4294967295 -V -- -- [-- --] 026d 347c
                               retlw    91                  ; 4294967295 -V -- -- [-- --] 026e 345b
                               retlw    93                  ; 4294967295 -V -- -- [-- --] 026f 345d
                               retlw    123                 ; 4294967295 -V -- -- [-- --] 0270 347b
                               retlw    125                 ; 4294967295 -V -- -- [-- --] 0271 347d
                               retlw    42                  ; 4294967295 -V -- -- [-- --] 0272 342a
                               retlw    45                  ; 4294967295 -V -- -- [-- --] 0273 342d
                               retlw    43                  ; 4294967295 -V -- -- [-- --] 0274 342b
                               retlw    44                  ; 4294967295 -V -- -- [-- --] 0275 342c
                               retlw    46                  ; 4294967295 -V -- -- [-- --] 0276 342e
                               retlw    58                  ; 4294967295 -V -- -- [-- --] 0277 343a
                               retlw    59                  ; 4294967295 -V -- -- [-- --] 0278 343b
                               retlw    63                  ; 4294967295 -V -- -- [-- --] 0279 343f
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 027a 0782
l__data_adcte
                               retlw    76                  ; 4294967295 -V -- -- [-- --] 027b 344c
                               retlw    105                 ; 4294967295 -V -- -- [-- --] 027c 3469
                               retlw    99                  ; 4294967295 -V -- -- [-- --] 027d 3463
                               retlw    104                 ; 4294967295 -V -- -- [-- --] 027e 3468
                               retlw    116                 ; 4294967295 -V -- -- [-- --] 027f 3474
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 0280 3473
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0281 3465
                               retlw    110                 ; 4294967295 -V -- -- [-- --] 0282 346e
                               retlw    115                 ; 4294967295 -V -- -- [-- --] 0283 3473
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 0284 346f
                               retlw    114                 ; 4294967295 -V -- -- [-- --] 0285 3472
                               retlw    58                  ; 4294967295 -V -- -- [-- --] 0286 343a
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 0287 0782
l__data_version
                               retlw    86                  ; 4294967295 -V -- -- [-- --] 0288 3456
                               retlw    48                  ; 4294967295 -V -- -- [-- --] 0289 3430
                               retlw    46                  ; 4294967295 -V -- -- [-- --] 028a 342e
                               retlw    48                  ; 4294967295 -V -- -- [-- --] 028b 3430
                               retlw    46                  ; 4294967295 -V -- -- [-- --] 028c 342e
                               retlw    54                  ; 4294967295 -V -- -- [-- --] 028d 3436
                               retlw    10                  ; 4294967295 -V -- -- [-- --] 028e 340a
                               addwf    v__pcl,f            ; 4294967295 -V -- -- [-- --] 028f 0782
l__data_done
                               retlw    68                  ; 4294967295 -V -- -- [-- --] 0290 3444
                               retlw    111                 ; 4294967295 -V -- -- [-- --] 0291 346f
                               retlw    110                 ; 4294967295 -V -- -- [-- --] 0292 346e
                               retlw    101                 ; 4294967295 -V -- -- [-- --] 0293 3465
                               retlw    33                  ; 4294967295 -V -- -- [-- --] 0294 3421
                               retlw    10                  ; 4294967295 -V -- -- [-- --] 0295 340a
l__pic_multiply
                               movlw    16                  ;  3 OV rs rs [?l ?l] 0296 3010
                                                            ; W = v__pic_multiplicand
                               movwf    v__pic_loop         ;  3 OV rs rs [?l ?l] 0297 00a8
l__l1070
                               bcf      v__status, v__c     ;  3 OV rs rs [?l ?l] 0298 1003
                               rlf      v__pic_mresult,f    ;  3 OV rs rs [?l ?l] 0299 0da4
                               rlf      v__pic_mresult+1,f  ;  3 OV rs rs [?l ?l] 029a 0da5
                               bcf      v__status, v__c     ;  3 OV rs rs [?l ?l] 029b 1003
                               rlf      v__pic_multiplier,f ;  3 OV rs rs [?l ?l] 029c 0da0
                               rlf      v__pic_multiplier+1,f;  3 OV rs rs [?l ?l] 029d 0da1
                               branchlo_nop l__l1071        ;  3 OV rs rs [?l ?l] 029e
                               btfss    v__status, v__c     ;  3 OV rs rs [?l ?l] 029e 1c03
                               goto     l__l1071            ;  3 OV rs rs [?l ?l] 029f 2aa6
                               movf     v__pic_multiplicand+1,w;  3 OV rs rs [?l ?l] 02a0 0823
                               addwf    v__pic_mresult+1,f  ;  3 OV rs rs [?l ?l] 02a1 07a5
                                                            ; W = v__pic_multiplicand
                               movf     v__pic_multiplicand,w;  3 OV rs rs [?l ?l] 02a2 0822
                                                            ; W = v__pic_multiplicand
                               addwf    v__pic_mresult,f    ;  3 OV rs rs [?l ?l] 02a3 07a4
                                                            ; W = v__pic_multiplicand
                               btfsc    v__status, v__c     ;  3 OV rs rs [?l ?l] 02a4 1803
                                                            ; W = v__pic_multiplicand
                               incf     v__pic_mresult+1,f  ;  3 OV rs rs [?l ?l] 02a5 0aa5
                                                            ; W = v__pic_multiplicand
l__l1071
                               branchlo_nop l__l1070        ;  3 OV rs rs [?l ?l] 02a6
                               decfsz   v__pic_loop,f       ;  3 OV rs rs [?l ?l] 02a6 0ba8
                               goto     l__l1070            ;  3 OV rs rs [?l ?l] 02a7 2a98
                               return                       ;  3 OV rs rs [?l ?l] 02a8 0008
l__pic_divide
                               movlw    16                  ;  3 OV rs rs [?l ?l] 02a9 3010
                                                            ; W = v__pic_dividend
                               movwf    v__pic_loop         ;  3 OV rs rs [?l ?l] 02aa 00a8
                               clrf     v__pic_remainder    ;  3 OV rs rs [?l ?l] 02ab 01a2
                                                            ; W = v__pic_loop
                               clrf     v__pic_remainder+1  ;  3 OV rs rs [?l ?l] 02ac 01a3
                                                            ; W = v__pic_loop
l__l1072
                               bcf      v__status, v__c     ;  3 OV rs rs [?l ?l] 02ad 1003
                               rlf      v__pic_quotient,f   ;  3 OV rs rs [?l ?l] 02ae 0da6
                               rlf      v__pic_quotient+1,f ;  3 OV rs rs [?l ?l] 02af 0da7
                               bcf      v__status, v__c     ;  3 OV rs rs [?l ?l] 02b0 1003
                               rlf      v__pic_divaccum,f   ;  3 OV rs rs [?l ?l] 02b1 0da0
                               rlf      v__pic_divaccum+1,f ;  3 OV rs rs [?l ?l] 02b2 0da1
                               rlf      v__pic_divaccum+2,f ;  3 OV rs rs [?l ?l] 02b3 0da2
                               rlf      v__pic_divaccum+3,f ;  3 OV rs rs [?l ?l] 02b4 0da3
                               movf     v__pic_remainder+1,w;  3 OV rs rs [?l ?l] 02b5 0823
                               subwf    v__pic_divisor+1,w  ;  3 OV rs rs [?l ?l] 02b6 0225
                                                            ; W = v__pic_remainder
                               branchlo_nop l__l1075        ;  3 OV rs rs [?l ?l] 02b7
                               btfss    v__status, v__z     ;  3 OV rs rs [?l ?l] 02b7 1d03
                               goto     l__l1075            ;  3 OV rs rs [?l ?l] 02b8 2abb
                               movf     v__pic_remainder,w  ;  3 OV rs rs [?l ?l] 02b9 0822
                               subwf    v__pic_divisor,w    ;  3 OV rs rs [?l ?l] 02ba 0224
                                                            ; W = v__pic_remainder
l__l1075
                               branchlo_nop l__l1074        ;  3 OV rs rs [?l ?l] 02bb
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 02bb 1903
                               goto     l__l1074            ;  3 OV rs rs [?l ?l] 02bc 2abf
                               branchlo_nop l__l1073        ;  3 OV rs rs [?l ?l] 02bd
                                                            ; W = v__pic_remainder
                               btfsc    v__status, v__c     ;  3 OV rs rs [?l ?l] 02bd 1803
                                                            ; W = v__pic_remainder
                               goto     l__l1073            ;  3 OV rs rs [?l ?l] 02be 2ac6
                                                            ; W = v__pic_remainder
l__l1074
                               movf     v__pic_divisor+1,w  ;  3 OV rs rs [?l ?l] 02bf 0825
                               subwf    v__pic_remainder+1,f;  3 OV rs rs [?l ?l] 02c0 02a3
                                                            ; W = v__pic_divisor
                               movf     v__pic_divisor,w    ;  3 OV rs rs [?l ?l] 02c1 0824
                                                            ; W = v__pic_divisor
                               subwf    v__pic_remainder,f  ;  3 OV rs rs [?l ?l] 02c2 02a2
                                                            ; W = v__pic_divisor
                               btfss    v__status, v__c     ;  3 OV rs rs [?l ?l] 02c3 1c03
                                                            ; W = v__pic_divisor
                               decf     v__pic_remainder+1,f;  3 OV rs rs [?l ?l] 02c4 03a3
                                                            ; W = v__pic_divisor
                               bsf      v__pic_quotient, 0  ;  3 OV rs rs [?l ?l] 02c5 1426
                                                            ; W = v__pic_divisor
l__l1073
                               branchlo_nop l__l1072        ;  3 OV rs rs [?l ?l] 02c6
                               decfsz   v__pic_loop,f       ;  3 OV rs rs [?l ?l] 02c6 0ba8
                               goto     l__l1072            ;  3 OV rs rs [?l ?l] 02c7 2aad
                               return                       ;  3 OV rs rs [?l ?l] 02c8 0008
l__pic_indirect
                               movwf    v__pclath           ;  2 OV rs rs [?l ?l] 02c9 008a
                                                            ; W = v__pic_pointer
                               movf     v__pic_pointer,w    ;  2 OV rs rs [?l ?l] 02ca 082a
                               movwf    v__pcl              ;  2 OV rs rs [?l ?l] 02cb 0082
                                                            ; W = v__pic_pointer
l__main
; 16f886.jal
;   97 var          byte  _PORTA_shadow        = PORTA
                               movf     v_porta,w           ;  0 OV rs rs [hl hl] 02cc 0805
                               movwf    v__porta_shadow     ;  0 OV rs rs [hl hl] 02cd 00af
;  217 var          byte  _PORTB_shadow        = PORTB
                               movf     v_portb,w           ;  0 OV rs rs [hl hl] 02ce 0806
                                                            ; W = v__porta_shadow
                               movwf    v__portb_shadow     ;  0 OV rs rs [hl hl] 02cf 00b0
;  332 var          byte  _PORTC_shadow        = PORTC
                               movf     v_portc,w           ;  0 OV rs rs [hl hl] 02d0 0807
                                                            ; W = v__portb_shadow
                               movwf    v__portc_shadow     ;  0 OV rs rs [hl hl] 02d1 00b1
; main.jal
;    3 enable_digital_io() 
; 16f886.jal
; 1026    ANSEL  = 0b0000_0000       -- all digital
                               datalo_set v_ansel           ;  0 OV rs rS [hl hl] 02d2 1683
                                                            ; W = v__portc_shadow
                               datahi_set v_ansel           ;  0 OV rS RS [hl hl] 02d3 1703
                                                            ; W = v__portc_shadow
                               clrf     v_ansel             ;  0 OV RS RS [hl hl] 02d4 0188
                                                            ; W = v__portc_shadow
; 1027    ANSELH = 0b0000_0000       -- all digital
                               clrf     v_anselh            ;  0 OV RS RS [hl hl] 02d5 0189
                                                            ; W = v__portc_shadow
; main.jal
;    3 enable_digital_io() 
; 16f886.jal
; 1050    analog_off()
; main.jal
;    3 enable_digital_io() 
; 16f886.jal
; 1034    ADCON0 = 0b0000_0000         -- disable ADC
                               datalo_clr v_adcon0          ;  0 OV RS Rs [hl hl] 02d6 1283
                                                            ; W = v__portc_shadow
                               datahi_clr v_adcon0          ;  0 OV Rs rs [hl hl] 02d7 1303
                                                            ; W = v__portc_shadow
                               clrf     v_adcon0            ;  0 OV rs rs [hl hl] 02d8 019f
                                                            ; W = v__portc_shadow
; 1035    ADCON1 = 0b0000_0000
                               datalo_set v_adcon1          ;  0 OV rs rS [hl hl] 02d9 1683
                                                            ; W = v__portc_shadow
                               clrf     v_adcon1            ;  0 OV rS rS [hl hl] 02da 019f
                                                            ; W = v__portc_shadow
; main.jal
;    3 enable_digital_io() 
; 16f886.jal
; 1051    adc_off()
; main.jal
;    3 enable_digital_io() 
; 16f886.jal
; 1042    CM1CON0 = 0b0000_0000       -- disable comparator
                               datalo_clr v_cm1con0         ;  0 OV rS rs [hl hl] 02db 1283
                                                            ; W = v__portc_shadow
                               datahi_set v_cm1con0         ;  0 OV rs Rs [hl hl] 02dc 1703
                                                            ; W = v__portc_shadow
                               clrf     v_cm1con0           ;  0 OV Rs Rs [hl hl] 02dd 0187
                                                            ; W = v__portc_shadow
; 1043    CM2CON0 = 0b0000_0000       -- disable 2nd comparator
                               clrf     v_cm2con0           ;  0 OV Rs Rs [hl hl] 02de 0188
                                                            ; W = v__portc_shadow
; main.jal
;    3 enable_digital_io() 
; 16f886.jal
; 1052    comparator_off()
; main.jal
;    3 enable_digital_io() 
; delay.jal
;   26 procedure delay_1us() is
                               branchlo_nop l__l399         ;  0 OV Rs Rs [hl hl] 02df
                                                            ; W = v__portc_shadow
                               goto     l__l399             ;  0 OV Rs Rs [hl hl] 02df 2bcd
                                                            ; W = v__portc_shadow
;   83 procedure delay_10us(byte in n) is
l_delay_10us
                               movwf    v___n_1             ;  3 OV rs rs [?l ?l] 02e0 00e4
                                                            ; W = v_adc_conversion_delay
;   84    if n==0 then
                               movf     v___n_1,w           ;  3 OV rs rs [?l ?l] 02e1 0864
                                                            ; W = v___n_1
                               branchlo_nop l__l204         ;  3 OV rs rs [?l ?l] 02e2
                                                            ; W = v___n_1
                               btfsc    v__status, v__z     ;  3 OV rs rs [?l ?l] 02e2 1903
                                                            ; W = v___n_1
;   85       return
                               return                       ;  3 OV rs rs [?l ?l] 02e3 0008
;   86    elsif n==1 then
l__l204
                               movlw    1                   ;  3 OV rs rs [?l ?l] 02e4 3001
                                                            ; W = v___n_1
                               subwf    v___n_1,w           ;  3 OV rs rs [?l ?l] 02e5 0264
                               branchlo_nop l__l205         ;  3 OV rs rs [?l ?l] 02e6
                               btfss    v__status, v__z     ;  3 OV rs rs [?l ?l] 02e6 1d03
                               goto     l__l205             ;  3 OV rs rs [?l ?l] 02e7 2af1
;   89        _usec_delay(_ten_us_delay1)
                               datalo_clr v__pic_temp       ;  3 -V rs rs [?l ?l] 02e8 1283
                               datahi_clr v__pic_temp       ;  3 -V rs rs [?l ?l] 02e9 1303
                               movlw    10                  ;  3 -V rs rs [?l ?l] 02ea 300a
                               movwf    v__pic_temp         ;  3 -V rs rs [?l ?l] 02eb 00a0
                               branchhi_clr l__l1076        ;  3 -V rs rs [?l hl] 02ec 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l1076        ;  3 -V rs rs [hl hl] 02ed 118a
                                                            ; W = v__pic_temp
l__l1076
                               decfsz   v__pic_temp,f       ;  3 -V rs rs [hl hl] 02ee 0ba0
                               goto     l__l1076            ;  3 -V rs rs [hl hl] 02ef 2aee
;   90      end if
                               return                       ;  3 OV rs rs [hl hl] 02f0 0008
;   91    else     
l__l205
;   92       n = n - 1;
                               decf     v___n_1,f           ;  3 OV rs rs [?l ?l] 02f1 03e4
;   95          _usec_delay(_ten_us_delay2)   
                               datalo_clr v__pic_temp       ;  3 -V rs rs [?l ?l] 02f2 1283
                               datahi_clr v__pic_temp       ;  3 -V rs rs [?l ?l] 02f3 1303
                               movlw    6                   ;  3 -V rs rs [?l ?l] 02f4 3006
                               movwf    v__pic_temp         ;  3 -V rs rs [?l ?l] 02f5 00a0
                               branchhi_clr l__l1077        ;  3 -V rs rs [?l hl] 02f6 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l1077        ;  3 -V rs rs [hl hl] 02f7 118a
                                                            ; W = v__pic_temp
l__l1077
                               decfsz   v__pic_temp,f       ;  3 -V rs rs [hl hl] 02f8 0ba0
                               goto     l__l1077            ;  3 -V rs rs [hl hl] 02f9 2af8
                               nop                          ;  3 -V rs rs [hl hl] 02fa 0000
                               nop                          ;  3 -V rs rs [hl hl] 02fb 0000
;  101       for n loop
                               clrf     v__floop1           ;  3 OV rs rs [hl hl] 02fc 01e5
                               branchlo_nop l__l211         ;  3 OV rs rs [hl hl] 02fd
                               goto     l__l211             ;  3 OV rs rs [hl hl] 02fd 2b08
l__l210
;  103             _usec_delay(_ten_us_delay3)
                               datalo_clr v__pic_temp       ;  3 -V rs rs [hl hl] 02fe 1283
                               datahi_clr v__pic_temp       ;  3 -V rs rs [hl hl] 02ff 1303
                               movlw    13                  ;  3 -V rs rs [hl hl] 0300 300d
                               movwf    v__pic_temp         ;  3 -V rs rs [hl hl] 0301 00a0
                               branchhi_clr l__l1078        ;  3 -V rs rs [hl hl] 0302 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l1078        ;  3 -V rs rs [hl hl] 0303 118a
                                                            ; W = v__pic_temp
l__l1078
                               decfsz   v__pic_temp,f       ;  3 -V rs rs [hl hl] 0304 0ba0
                               goto     l__l1078            ;  3 -V rs rs [hl hl] 0305 2b04
                               nop                          ;  3 -V rs rs [hl hl] 0306 0000
;  107       end loop
                               incf     v__floop1,f         ;  3 OV rs rs [hl hl] 0307 0ae5
l__l211
                               movf     v__floop1,w         ;  3 OV rs rs [hl hl] 0308 0865
                               subwf    v___n_1,w           ;  3 OV rs rs [hl hl] 0309 0264
                                                            ; W = v__floop1
                               branchlo_nop l__l210         ;  3 OV rs rs [hl hl] 030a
                               btfss    v__status, v__z     ;  3 OV rs rs [hl hl] 030a 1d03
                               goto     l__l210             ;  3 OV rs rs [hl hl] 030b 2afe
;  108    end if
l__l203
;  110 end procedure
l__l202
                               return                       ;  3 OV rs rs [hl hl] 030c 0008
;  113 procedure delay_1ms(word in n) is
l_delay_1ms
;  115    for n loop
                               clrf     v__floop2           ;  1 OV rs rs [?l ?l] 030d 01db
                                                            ; W = v___n_3
                               clrf     v__floop2+1         ;  1 OV rs rs [?l ?l] 030e 01dc
                                                            ; W = v___n_3
                               branchlo_nop l__l218         ;  1 OV rs rs [?l ?l] 030f
                                                            ; W = v___n_3
                               goto     l__l218             ;  1 OV rs rs [?l ?l] 030f 2b22
                                                            ; W = v___n_3
l__l217
;  117          _usec_delay(_one_ms_delay)
                               datalo_clr v__pic_temp       ;  1 -V rs rs [?l ?l] 0310 1283
                               datahi_clr v__pic_temp       ;  1 -V rs rs [?l ?l] 0311 1303
                               movlw    6                   ;  1 -V rs rs [?l ?l] 0312 3006
                               movwf    v__pic_temp         ;  1 -V rs rs [?l ?l] 0313 00a0
l__l1079
                               movlw    165                 ;  1 -V rs rs [?l ?l] 0314 30a5
                               movwf    v__pic_temp+1       ;  1 -V rs rs [?l ?l] 0315 00a1
l__l1080
                               branchhi_clr l__l1080        ;  1 -V rs rs [?l hl] 0316 120a
                               branchlo_clr l__l1080        ;  1 -V rs rs [hl hl] 0317 118a
                               decfsz   v__pic_temp+1,f     ;  1 -V rs rs [hl hl] 0318 0ba1
                               goto     l__l1080            ;  1 -V rs rs [hl hl] 0319 2b16
                               branchhi_clr l__l1079        ;  1 -V rs rs [hl hl] 031a 120a
                               branchlo_clr l__l1079        ;  1 -V rs rs [hl hl] 031b 118a
                               decfsz   v__pic_temp,f       ;  1 -V rs rs [hl hl] 031c 0ba0
                               goto     l__l1079            ;  1 -V rs rs [hl hl] 031d 2b14
                               nop                          ;  1 -V rs rs [hl hl] 031e 0000
                                                            ; W = v__pic_temp
;  121    end loop
                               incf     v__floop2,f         ;  1 OV rs rs [hl hl] 031f 0adb
                                                            ; W = v__pic_temp
                               btfsc    v__status, v__z     ;  1 OV rs rs [hl hl] 0320 1903
                                                            ; W = v__pic_temp
                               incf     v__floop2+1,f       ;  1 OV rs rs [hl hl] 0321 0adc
                                                            ; W = v__pic_temp
l__l218
                               movf     v__floop2,w         ;  1 OV rs rs [?l ?l] 0322 085b
                                                            ; W = v___n_3
                               subwf    v___n_3,w           ;  1 OV rs rs [?l ?l] 0323 0255
                                                            ; W = v__floop2
                               movwf    v__pic_temp         ;  1 OV rs rs [?l ?l] 0324 00a0
                               movf     v__floop2+1,w       ;  1 OV rs rs [?l ?l] 0325 085c
                                                            ; W = v__pic_temp
                               subwf    v___n_3+1,w         ;  1 OV rs rs [?l ?l] 0326 0256
                                                            ; W = v__floop2
                               iorwf    v__pic_temp,w       ;  1 OV rs rs [?l ?l] 0327 0420
                               branchlo_nop l__l217         ;  1 OV rs rs [?l ?l] 0328
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0328 1d03
                               goto     l__l217             ;  1 OV rs rs [?l ?l] 0329 2b10
;  122 end procedure
                               return                       ;  1 OV rs rs [?l ?l] 032a 0008
                                                            ; W = v__pic_temp
; adc/adc_channels.jal
;  120 end procedure
l__l240
; 2916    _debug "ADC channels config: independent pins, via ANS bits"
; 2948    procedure _adc_setup_pins() is
l__adc_setup_pins
; 2949    end procedure
                               return                       ; 4294967295 OV -- -- [-- --] 032b 0008
                                                            ; W = v__portc_shadow
; 2958    procedure set_analog_pin(byte in an_pin_num) is
l_set_analog_pin
                               movwf    v___an_pin_num_1    ;  1 OV rs rs [?l ?l] 032c 00d5
; 2960          if an_pin_num == 0 then
                               movf     v___an_pin_num_1,w  ;  1 OV rs rs [?l ?l] 032d 0855
                                                            ; W = v___an_pin_num_1
                               branchlo_nop l__l248         ;  1 OV rs rs [?l ?l] 032e
                                                            ; W = v___an_pin_num_1
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 032e 1d03
                                                            ; W = v___an_pin_num_1
                               goto     l__l248             ;  1 OV rs rs [?l ?l] 032f 2b35
                                                            ; W = v___an_pin_num_1
; 2961             JANSEL_ANS0 = true
                               datalo_set v_ansel ; jansel_ans0        ;  1 OV rs rS [?l ?l] 0330 1683
                               datahi_set v_ansel ; jansel_ans0        ;  1 OV rS RS [?l ?l] 0331 1703
                               bsf      v_ansel, 0 ; jansel_ans0       ;  1 OV RS RS [?l ?l] 0332 1408
; 2962             pin_AN0_direction = input
                               datahi_clr v_trisa ; pin_a0_direction        ;  1 OV RS rS [?l ?l] 0333 1303
                               bsf      v_trisa, 0 ; pin_a0_direction       ;  1 OV rS rS [?l ?l] 0334 1405
; 2963          end if
; 2964       end if
l__l248
; 2966          if an_pin_num == 1 then
                               movlw    1                   ;  1 OV r? rS [?l ?l] 0335 3001
                                                            ; W = v___an_pin_num_1
                               datalo_clr v___an_pin_num_1  ;  1 OV r? rs [?l ?l] 0336 1283
                               subwf    v___an_pin_num_1,w  ;  1 OV rs rs [?l ?l] 0337 0255
                               branchlo_nop l__l252         ;  1 OV rs rs [?l ?l] 0338
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0338 1d03
                               goto     l__l252             ;  1 OV rs rs [?l ?l] 0339 2b3f
; 2967             JANSEL_ANS1 = true
                               datalo_set v_ansel ; jansel_ans1        ;  1 OV rs rS [?l ?l] 033a 1683
                               datahi_set v_ansel ; jansel_ans1        ;  1 OV rS RS [?l ?l] 033b 1703
                               bsf      v_ansel, 1 ; jansel_ans1       ;  1 OV RS RS [?l ?l] 033c 1488
; 2968             pin_AN1_direction = input
                               datahi_clr v_trisa ; pin_a1_direction        ;  1 OV RS rS [?l ?l] 033d 1303
                               bsf      v_trisa, 1 ; pin_a1_direction       ;  1 OV rS rS [?l ?l] 033e 1485
; 2969          end if
; 2970       end if
l__l252
; 2972          if an_pin_num == 2 then
                               movlw    2                   ;  1 OV r? rS [?l ?l] 033f 3002
                               datalo_clr v___an_pin_num_1  ;  1 OV r? rs [?l ?l] 0340 1283
                               subwf    v___an_pin_num_1,w  ;  1 OV rs rs [?l ?l] 0341 0255
                               branchlo_nop l__l256         ;  1 OV rs rs [?l ?l] 0342
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0342 1d03
                               goto     l__l256             ;  1 OV rs rs [?l ?l] 0343 2b49
; 2973             JANSEL_ANS2 = true
                               datalo_set v_ansel ; jansel_ans2        ;  1 OV rs rS [?l ?l] 0344 1683
                               datahi_set v_ansel ; jansel_ans2        ;  1 OV rS RS [?l ?l] 0345 1703
                               bsf      v_ansel, 2 ; jansel_ans2       ;  1 OV RS RS [?l ?l] 0346 1508
; 2974             pin_AN2_direction = input
                               datahi_clr v_trisa ; pin_a2_direction        ;  1 OV RS rS [?l ?l] 0347 1303
                               bsf      v_trisa, 2 ; pin_a2_direction       ;  1 OV rS rS [?l ?l] 0348 1505
; 2975          end if
; 2976       end if
l__l256
; 2978          if an_pin_num == 3 then
                               movlw    3                   ;  1 OV r? rS [?l ?l] 0349 3003
                               datalo_clr v___an_pin_num_1  ;  1 OV r? rs [?l ?l] 034a 1283
                               subwf    v___an_pin_num_1,w  ;  1 OV rs rs [?l ?l] 034b 0255
                               branchlo_nop l__l260         ;  1 OV rs rs [?l ?l] 034c
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 034c 1d03
                               goto     l__l260             ;  1 OV rs rs [?l ?l] 034d 2b53
; 2979             JANSEL_ANS3 = true
                               datalo_set v_ansel ; jansel_ans3        ;  1 OV rs rS [?l ?l] 034e 1683
                               datahi_set v_ansel ; jansel_ans3        ;  1 OV rS RS [?l ?l] 034f 1703
                               bsf      v_ansel, 3 ; jansel_ans3       ;  1 OV RS RS [?l ?l] 0350 1588
; 2980             pin_AN3_direction = input
                               datahi_clr v_trisa ; pin_a3_direction        ;  1 OV RS rS [?l ?l] 0351 1303
                               bsf      v_trisa, 3 ; pin_a3_direction       ;  1 OV rS rS [?l ?l] 0352 1585
; 2981          end if
; 2982       end if
l__l260
; 2984          if an_pin_num == 4 then
                               movlw    4                   ;  1 OV r? rS [?l ?l] 0353 3004
                               datalo_clr v___an_pin_num_1  ;  1 OV r? rs [?l ?l] 0354 1283
                               subwf    v___an_pin_num_1,w  ;  1 OV rs rs [?l ?l] 0355 0255
                               branchlo_nop l__l264         ;  1 OV rs rs [?l ?l] 0356
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0356 1d03
                               goto     l__l264             ;  1 OV rs rs [?l ?l] 0357 2b5d
; 2985             JANSEL_ANS4 = true
                               datalo_set v_ansel ; jansel_ans4        ;  1 OV rs rS [?l ?l] 0358 1683
                               datahi_set v_ansel ; jansel_ans4        ;  1 OV rS RS [?l ?l] 0359 1703
                               bsf      v_ansel, 4 ; jansel_ans4       ;  1 OV RS RS [?l ?l] 035a 1608
; 2986             pin_AN4_direction = input
                               datahi_clr v_trisa ; pin_a5_direction        ;  1 OV RS rS [?l ?l] 035b 1303
                               bsf      v_trisa, 5 ; pin_a5_direction       ;  1 OV rS rS [?l ?l] 035c 1685
; 2987          end if
; 2988       end if
l__l264
; 3008          if an_pin_num == 8 then
                               movlw    8                   ;  1 OV r? rS [?l ?l] 035d 3008
                               datalo_clr v___an_pin_num_1  ;  1 OV r? rs [?l ?l] 035e 1283
                               subwf    v___an_pin_num_1,w  ;  1 OV rs rs [?l ?l] 035f 0255
                               branchlo_nop l__l271         ;  1 OV rs rs [?l ?l] 0360
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0360 1d03
                               goto     l__l271             ;  1 OV rs rs [?l ?l] 0361 2b66
; 3009             JANSEL_ANS8 = true
                               datalo_set v_anselh ; jansel_ans8       ;  1 OV rs rS [?l ?l] 0362 1683
                               datahi_set v_anselh ; jansel_ans8       ;  1 OV rS RS [?l ?l] 0363 1703
                               bsf      v_anselh, 0 ; jansel_ans8      ;  1 OV RS RS [?l ?l] 0364 1409
; 3010             pin_AN8_direction = input
                               bsf      v_trisb, 2 ; pin_b2_direction       ;  1 OV RS RS [?l ?l] 0365 1506
; 3011          end if
; 3012       end if
l__l271
; 3014          if an_pin_num == 9 then
                               movlw    9                   ;  1 OV ?? RS [?l ?l] 0366 3009
                               datalo_clr v___an_pin_num_1  ;  1 OV ?? Rs [?l ?l] 0367 1283
                               datahi_clr v___an_pin_num_1  ;  1 OV ?s rs [?l ?l] 0368 1303
                               subwf    v___an_pin_num_1,w  ;  1 OV rs rs [?l ?l] 0369 0255
                               branchlo_nop l__l275         ;  1 OV rs rs [?l ?l] 036a
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 036a 1d03
                               goto     l__l275             ;  1 OV rs rs [?l ?l] 036b 2b70
; 3015             JANSEL_ANS9 = true
                               datalo_set v_anselh ; jansel_ans9       ;  1 OV rs rS [?l ?l] 036c 1683
                               datahi_set v_anselh ; jansel_ans9       ;  1 OV rS RS [?l ?l] 036d 1703
                               bsf      v_anselh, 1 ; jansel_ans9      ;  1 OV RS RS [?l ?l] 036e 1489
; 3016             pin_AN9_direction = input
                               bsf      v_trisb, 3 ; pin_b3_direction       ;  1 OV RS RS [?l ?l] 036f 1586
; 3017          end if
; 3018       end if
l__l275
; 3020          if an_pin_num == 10 then
                               movlw    10                  ;  1 OV ?? RS [?l ?l] 0370 300a
                               datalo_clr v___an_pin_num_1  ;  1 OV ?? Rs [?l ?l] 0371 1283
                               datahi_clr v___an_pin_num_1  ;  1 OV ?s rs [?l ?l] 0372 1303
                               subwf    v___an_pin_num_1,w  ;  1 OV rs rs [?l ?l] 0373 0255
                               branchlo_nop l__l279         ;  1 OV rs rs [?l ?l] 0374
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0374 1d03
                               goto     l__l279             ;  1 OV rs rs [?l ?l] 0375 2b7a
; 3021             JANSEL_ANS10 = true
                               datalo_set v_anselh ; jansel_ans10       ;  1 OV rs rS [?l ?l] 0376 1683
                               datahi_set v_anselh ; jansel_ans10       ;  1 OV rS RS [?l ?l] 0377 1703
                               bsf      v_anselh, 2 ; jansel_ans10      ;  1 OV RS RS [?l ?l] 0378 1509
; 3022             pin_AN10_direction = input
                               bsf      v_trisb, 1 ; pin_b1_direction       ;  1 OV RS RS [?l ?l] 0379 1486
; 3023          end if
; 3024       end if
l__l279
; 3026          if an_pin_num == 11 then
                               movlw    11                  ;  1 OV ?? RS [?l ?l] 037a 300b
                               datalo_clr v___an_pin_num_1  ;  1 OV ?? Rs [?l ?l] 037b 1283
                               datahi_clr v___an_pin_num_1  ;  1 OV ?s rs [?l ?l] 037c 1303
                               subwf    v___an_pin_num_1,w  ;  1 OV rs rs [?l ?l] 037d 0255
                               branchlo_nop l__l283         ;  1 OV rs rs [?l ?l] 037e
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 037e 1d03
                               goto     l__l283             ;  1 OV rs rs [?l ?l] 037f 2b84
; 3027             JANSEL_ANS11 = true
                               datalo_set v_anselh ; jansel_ans11       ;  1 OV rs rS [?l ?l] 0380 1683
                               datahi_set v_anselh ; jansel_ans11       ;  1 OV rS RS [?l ?l] 0381 1703
                               bsf      v_anselh, 3 ; jansel_ans11      ;  1 OV RS RS [?l ?l] 0382 1589
; 3028             pin_AN11_direction = input
                               bsf      v_trisb, 4 ; pin_b4_direction       ;  1 OV RS RS [?l ?l] 0383 1606
; 3029          end if
; 3030       end if
l__l283
; 3032          if an_pin_num == 12 then
                               movlw    12                  ;  1 OV ?? RS [?l ?l] 0384 300c
                               datalo_clr v___an_pin_num_1  ;  1 OV ?? Rs [?l ?l] 0385 1283
                               datahi_clr v___an_pin_num_1  ;  1 OV ?s rs [?l ?l] 0386 1303
                               subwf    v___an_pin_num_1,w  ;  1 OV rs rs [?l ?l] 0387 0255
                               branchlo_nop l__l287         ;  1 OV rs rs [?l ?l] 0388
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0388 1d03
                               goto     l__l287             ;  1 OV rs rs [?l ?l] 0389 2b8e
; 3033             JANSEL_ANS12 = true
                               datalo_set v_anselh ; jansel_ans12       ;  1 OV rs rS [?l ?l] 038a 1683
                               datahi_set v_anselh ; jansel_ans12       ;  1 OV rS RS [?l ?l] 038b 1703
                               bsf      v_anselh, 4 ; jansel_ans12      ;  1 OV RS RS [?l ?l] 038c 1609
; 3034             pin_AN12_direction = input
                               bsf      v_trisb, 0 ; pin_b0_direction       ;  1 OV RS RS [?l ?l] 038d 1406
; 3035          end if
; 3036       end if
l__l287
; 3038          if an_pin_num == 13 then
                               movlw    13                  ;  1 OV ?? RS [?l ?l] 038e 300d
                               datalo_clr v___an_pin_num_1  ;  1 OV ?? Rs [?l ?l] 038f 1283
                               datahi_clr v___an_pin_num_1  ;  1 OV ?s rs [?l ?l] 0390 1303
                               subwf    v___an_pin_num_1,w  ;  1 OV rs rs [?l ?l] 0391 0255
                               branchlo_nop l__l291         ;  1 OV rs rs [?l ?l] 0392
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0392 1d03
                               goto     l__l291             ;  1 OV rs rs [?l ?l] 0393 2b98
; 3039             JANSEL_ANS13 = true
                               datalo_set v_anselh ; jansel_ans13       ;  1 OV rs rS [?l ?l] 0394 1683
                               datahi_set v_anselh ; jansel_ans13       ;  1 OV rS RS [?l ?l] 0395 1703
                               bsf      v_anselh, 5 ; jansel_ans13      ;  1 OV RS RS [?l ?l] 0396 1689
; 3040             pin_AN13_direction = input
                               bsf      v_trisb, 5 ; pin_b5_direction       ;  1 OV RS RS [?l ?l] 0397 1686
; 3041          end if
; 3042       end if
l__l291
; 3130    end procedure
                               return                       ;  1 OV ?? RS [?l ?l] 0398 0008
; adc/adc_clock.jal
;   31 function _adc_eval_tad(word in factor) return bit is
l__adc_eval_tad
;   42    var bit tad_ok = false
                               bcf      v____bitbucket_64, 0 ; tad_ok;  1 OV rs rs [?l ?l] 0399 105e
                                                            ; W = v___factor_1
;   43    tad_value = byte((factor * 10) / (target_clock / 1_000_000))
                               movf     v___factor_1,w      ;  1 OV rs rs [?l ?l] 039a 0855
                                                            ; W = v___factor_1
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?l ?l] 039b 00a0
                                                            ; W = v___factor_1
                               movf     v___factor_1+1,w    ;  1 OV rs rs [?l ?l] 039c 0856
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplier+1 ;  1 OV rs rs [?l ?l] 039d 00a1
                                                            ; W = v___factor_1
                               movlw    10                  ;  1 OV rs rs [?l ?l] 039e 300a
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?l ?l] 039f 00a2
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?l ?l] 03a0 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_nop l__pic_multiply ;  1 OV rs rs [?l ?l] 03a1
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?l ??] 03a1 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 03a2 1283
                               datahi_clr v__pic_mresult    ;  1 OV ?s rs [?? ??] 03a3 1303
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 03a4 0824
                               movwf    v____temp_33        ;  1 OV rs rs [?? ??] 03a5 00db
                                                            ; W = v__pic_mresult
                               movf     v__pic_mresult+1,w  ;  1 OV rs rs [?? ??] 03a6 0825
                                                            ; W = v____temp_33
                               movwf    v____temp_33+1      ;  1 OV rs rs [?? ??] 03a7 00dc
                                                            ; W = v__pic_mresult
                               movlw    20                  ;  1 OV rs rs [?? ??] 03a8 3014
                                                            ; W = v____temp_33
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 03a9 00a4
                               clrf     v__pic_divisor+1    ;  1 OV rs rs [?? ??] 03aa 01a5
                                                            ; W = v__pic_divisor
                               movf     v____temp_33,w      ;  1 OV rs rs [?? ??] 03ab 085b
                                                            ; W = v__pic_divisor
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 03ac 00a0
                                                            ; W = v____temp_33
                               movf     v____temp_33+1,w    ;  1 OV rs rs [?? ??] 03ad 085c
                                                            ; W = v__pic_dividend
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 03ae 00a1
                                                            ; W = v____temp_33
                               branchlo_clr l__pic_divide   ;  1 OV rs rs [?? ?l] 03af 118a
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  1 OV rs ?? [?l ??] 03b0 22a9
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 03b1 1283
                               datahi_clr v__pic_quotient   ;  1 OV ?s rs [?? ??] 03b2 1303
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 03b3 0826
                               movwf    v_tad_value         ;  1 OV rs rs [?? ??] 03b4 00b2
                                                            ; W = v__pic_quotient
;   44    if tad_value >= ADC_MIN_TAD & tad_value < ADC_MAX_TAD then
                               movlw    16                  ;  1 OV rs rs [?? ??] 03b5 3010
                                                            ; W = v_tad_value
                               subwf    v_tad_value,w       ;  1 OV rs rs [?? ??] 03b6 0232
                               bcf      v____bitbucket_64, 1 ; _btemp29;  1 OV rs rs [?? ??] 03b7 10de
                               btfss    v__status, v__z     ;  1 OV rs rs [?? ??] 03b8 1d03
                               btfsc    v__status, v__c     ;  1 OV rs rs [?? ??] 03b9 1803
                               bsf      v____bitbucket_64, 1 ; _btemp29;  1 OV rs rs [?? ??] 03ba 14de
                               movlw    60                  ;  1 OV rs rs [?? ??] 03bb 303c
                               subwf    v_tad_value,w       ;  1 OV rs rs [?? ??] 03bc 0232
                               bcf      v____bitbucket_64, 2 ; _btemp30;  1 OV rs rs [?? ??] 03bd 115e
                               branchlo_clr l__l1083        ;  1 OV rs rs [?? ?l] 03be 118a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 03bf 1903
                               goto     l__l1083            ;  1 OV rs rs [?l ?l] 03c0 2bc3
                               btfss    v__status, v__c     ;  1 OV rs rs [?l ?l] 03c1 1c03
                               bsf      v____bitbucket_64, 2 ; _btemp30;  1 OV rs rs [?l ?l] 03c2 155e
l__l1083
                               bsf      v____bitbucket_64, 3 ; _btemp31;  1 OV rs rs [?l ?l] 03c3 15de
                               btfsc    v____bitbucket_64, 1 ; _btemp29;  1 OV rs rs [?l ?l] 03c4 18de
                               btfss    v____bitbucket_64, 2 ; _btemp30;  1 OV rs rs [?l ?l] 03c5 1d5e
                               bcf      v____bitbucket_64, 3 ; _btemp31;  1 OV rs rs [?l ?l] 03c6 11de
                               branchlo_nop l__l383         ;  1 OV rs rs [?l ?l] 03c7
                               btfsc    v____bitbucket_64, 3 ; _btemp31;  1 OV rs rs [?l ?l] 03c7 19de
;   45 	  tad_ok = true
                               bsf      v____bitbucket_64, 0 ; tad_ok;  1 OV rs rs [?l ?l] 03c8 145e
;   46    end if
l__l383
;   47    return tad_ok
                               bcf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?l ?l] 03c9 1020
                               btfsc    v____bitbucket_64, 0 ; tad_ok;  1 OV rs rs [?l ?l] 03ca 185e
                               bsf      v__pic_temp, 0 ; _pic_temp   ;  1 OV rs rs [?l ?l] 03cb 1420
;   48 end function
                               return                       ;  1 OV rs rs [?l ?l] 03cc 0008
; adc/adc.jal
;   55 end if
l__l399
;   72 var volatile byte _adcon0_shadow = 0
                               datahi_clr v__adcon0_shadow  ;  0 OV Rs rs [hl hl] 03cd 1303
                                                            ; W = v__portc_shadow
                               clrf     v__adcon0_shadow    ;  0 OV rs rs [hl hl] 03ce 01ac
                                                            ; W = v__portc_shadow
;   77 procedure _adc_read_low_res(byte in adc_chan, byte out adc_byte) is
                               branchlo_nop l__l474         ;  0 OV rs rs [hl hl] 03cf
                                                            ; W = v__portc_shadow
                               goto     l__l474             ;  0 OV rs rs [hl hl] 03cf 2c28
                                                            ; W = v__portc_shadow
l__adc_read_low_res
                               movwf    v___adc_chan_1      ;  2 OV rs rs [?l ?l] 03d0 00de
;   79    ADCON0_CHS = adc_chan
                               rlf      v___adc_chan_1,w    ;  2 OV rs rs [?l ?l] 03d1 0d5e
                                                            ; W = v___adc_chan_1
                               movwf    v__pic_temp         ;  2 OV rs rs [?l ?l] 03d2 00a0
                               rlf      v__pic_temp,f       ;  2 OV rs rs [?l ?l] 03d3 0da0
                                                            ; W = v__pic_temp
                               movlw    60                  ;  2 OV rs rs [?l ?l] 03d4 303c
                               andwf    v__pic_temp,f       ;  2 OV rs rs [?l ?l] 03d5 05a0
                               movlw    195                 ;  2 OV rs rs [?l ?l] 03d6 30c3
                               andwf    v_adcon0,w          ;  2 OV rs rs [?l ?l] 03d7 051f
                               iorwf    v__pic_temp,w       ;  2 OV rs rs [?l ?l] 03d8 0420
                               movwf    v_adcon0            ;  2 OV rs rs [?l ?l] 03d9 009f
;   80    ADCON0_ADON = true                -- turn on ADC module
                               bsf      v_adcon0, 0 ; adcon0_adon      ;  2 OV rs rs [?l ?l] 03da 141f
                                                            ; W = v_adcon0
;   81    delay_10us(adc_conversion_delay)  -- wait acquisition time
                               movf     v_adc_conversion_delay,w;  2 OV rs rs [?l ?l] 03db 0833
                                                            ; W = v_adcon0
                               branchlo_nop l_delay_10us    ;  2 OV rs rs [?l ?l] 03dc
                                                            ; W = v_adc_conversion_delay
                               call     l_delay_10us        ;  2 OV rs ?? [?l ??] 03dc 22e0
                                                            ; W = v_adc_conversion_delay
;   82    ADCON0_GO = true                  -- start conversion
                               datalo_clr v_adcon0 ; adcon0_go       ;  2 OV ?? ?s [?? ??] 03dd 1283
                               datahi_clr v_adcon0 ; adcon0_go       ;  2 OV ?s rs [?? ??] 03de 1303
                               bsf      v_adcon0, 1 ; adcon0_go      ;  2 OV rs rs [?? ??] 03df 149f
;   83    while ADCON0_GO loop end loop     -- wait till conversion finished
l__l405
                               branchlo_clr l__l406         ;  2 OV rs rs [?? ?l] 03e0 118a
                               btfss    v_adcon0, 1 ; adcon0_go      ;  2 OV rs rs [?l ?l] 03e1 1c9f
                               goto     l__l406             ;  2 OV rs rs [?l ?l] 03e2 2be4
                               branchlo_nop l__l405         ;  2 OV rs rs [?l ?l] 03e3
                               goto     l__l405             ;  2 OV rs rs [?l ?l] 03e3 2be0
l__l406
;   90       adc_byte = ADRESH                  -- read high byte 
                               movf     v_adresh,w          ;  2 OV rs rs [?l ?l] 03e4 081e
                               movwf    v___adc_byte_1      ;  2 OV rs rs [?l ?l] 03e5 00e2
;   98    if tad_value >= (ADC_MAX_TAD + ADC_MIN_TAD) / 2 then
                               movlw    38                  ;  2 OV rs rs [?l ?l] 03e6 3026
                                                            ; W = v___adc_byte_1
                               subwf    v_tad_value,w       ;  2 OV rs rs [?l ?l] 03e7 0232
                               branchlo_nop l__l1087        ;  2 OV rs rs [?l ?l] 03e8
                               btfsc    v__status, v__z     ;  2 OV rs rs [?l ?l] 03e8 1903
                               goto     l__l1087            ;  2 OV rs rs [?l ?l] 03e9 2bec
                               branchlo_nop l__l411         ;  2 OV rs rs [?l ?l] 03ea
                                                            ; W = v___adc_byte_1
                               btfss    v__status, v__c     ;  2 OV rs rs [?l ?l] 03ea 1c03
                                                            ; W = v___adc_byte_1
                               goto     l__l411             ;  2 OV rs rs [?l ?l] 03eb 2bf6
                                                            ; W = v___adc_byte_1
l__l1087
;   99       _usec_delay(2 * ADC_MAX_TAD)
                               datalo_clr v__pic_temp       ;  2 -V rs rs [?l ?l] 03ec 1283
                               datahi_clr v__pic_temp       ;  2 -V rs rs [?l ?l] 03ed 1303
                               movlw    198                 ;  2 -V rs rs [?l ?l] 03ee 30c6
                               movwf    v__pic_temp         ;  2 -V rs rs [?l ?l] 03ef 00a0
                               branchhi_clr l__l1088        ;  2 -V rs rs [?l hl] 03f0 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l1088        ;  2 -V rs rs [hl hl] 03f1 118a
                                                            ; W = v__pic_temp
l__l1088
                               decfsz   v__pic_temp,f       ;  2 -V rs rs [hl hl] 03f2 0ba0
                               goto     l__l1088            ;  2 -V rs rs [hl hl] 03f3 2bf2
                               nop                          ;  2 -V rs rs [hl hl] 03f4 0000
;  100    else
                               branchlo_nop l__l410         ;  2 OV rs rs [hl hl] 03f5
                               goto     l__l410             ;  2 OV rs rs [hl hl] 03f5 2c00
l__l411
;  101       _usec_delay(2 * ADC_MIN_TAD)
                               datalo_clr v__pic_temp       ;  2 -V rs rs [?l ?l] 03f6 1283
                                                            ; W = v___adc_byte_1
                               datahi_clr v__pic_temp       ;  2 -V rs rs [?l ?l] 03f7 1303
                                                            ; W = v___adc_byte_1
                               movlw    51                  ;  2 -V rs rs [?l ?l] 03f8 3033
                                                            ; W = v___adc_byte_1
                               movwf    v__pic_temp         ;  2 -V rs rs [?l ?l] 03f9 00a0
                               branchhi_clr l__l1089        ;  2 -V rs rs [?l hl] 03fa 120a
                                                            ; W = v__pic_temp
                               branchlo_clr l__l1089        ;  2 -V rs rs [hl hl] 03fb 118a
                                                            ; W = v__pic_temp
l__l1089
                               decfsz   v__pic_temp,f       ;  2 -V rs rs [hl hl] 03fc 0ba0
                               goto     l__l1089            ;  2 -V rs rs [hl hl] 03fd 2bfc
                               nop                          ;  2 -V rs rs [hl hl] 03fe 0000
                               nop                          ;  2 -V rs rs [hl hl] 03ff 0000
;  102    end if
l__l410
;  103    ADCON0_ADON = false               -- turn off ADC module
                               bcf      v_adcon0, 0 ; adcon0_adon      ;  2 OV rs rs [hl hl] 0400 101f
;  104 end procedure
                               movf     v___adc_byte_1,w    ;  2 OV rs rs [hl hl] 0401 0862
                               return                       ;  2 OV rs rs [hl hl] 0402 0008
                                                            ; W = v___adc_byte_1
;  110 function adc_read(byte in adc_chan) return word is
l_adc_read
                               datalo_clr v___adc_chan_3    ;  1 OV ?? ?s [?l ?l] 0403 1283
                               datahi_clr v___adc_chan_3    ;  1 OV ?s rs [?l ?l] 0404 1303
                               movwf    v___adc_chan_3      ;  1 OV rs rs [?l ?l] 0405 00d5
;  115       _adc_read_low_res(adc_chan,ax[1])   -- do conversion and get high byte  
                               movf     v___adc_chan_3,w    ;  1 OV rs rs [?l ?l] 0406 0855
                                                            ; W = v___adc_chan_3
                               branchlo_nop l__adc_read_low_res;  1 OV rs rs [?l ?l] 0407
                                                            ; W = v___adc_chan_3
                               call     l__adc_read_low_res ;  1 OV rs ?? [?l ??] 0407 23d0
                                                            ; W = v___adc_chan_3
                               datalo_clr v_ax+1            ;  1 OV ?? ?s [?? ??] 0408 1283
                               datahi_clr v_ax+1            ;  1 OV ?s rs [?? ??] 0409 1303
                               movwf    v_ax+1              ;  1 OV rs rs [?? ??] 040a 00d8
;  116       ax[0] = ADRESL                       -- get low byte
                               datalo_set v_adresl          ;  1 OV rs rS [?? ??] 040b 1683
                                                            ; W = v_ax
                               movf     v_adresl,w          ;  1 OV rS rS [?? ??] 040c 081e
                                                            ; W = v_ax
                               datalo_clr v_ax              ;  1 OV rS rs [?? ??] 040d 1283
                               movwf    v_ax                ;  1 OV rs rs [?? ??] 040e 00d7
;  125    return ad_value
                               movf     v_ad_value,w        ;  1 OV rs rs [?? ??] 040f 0857
                                                            ; W = v_ax
                               movwf    v__pic_temp         ;  1 OV rs rs [?? ??] 0410 00a0
                                                            ; W = v_ad_value
                               movf     v_ad_value+1,w      ;  1 OV rs rs [?? ??] 0411 0858
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?? ??] 0412 00a1
                                                            ; W = v_ad_value
;  126 end function
                               return                       ;  1 OV rs rs [?? ??] 0413 0008
                                                            ; W = v__pic_temp
;  143 function adc_read_low_res(byte in adc_chan) return byte is
l_adc_read_low_res
                               movwf    v___adc_chan_7      ;  1 OV rs rs [?l ?l] 0414 00d5
;  150       _adc_read_low_res(adc_chan,ax[1])
                               movf     v___adc_chan_7,w    ;  1 OV rs rs [?l ?l] 0415 0855
                                                            ; W = v___adc_chan_7
                               branchlo_nop l__adc_read_low_res;  1 OV rs rs [?l ?l] 0416
                                                            ; W = v___adc_chan_7
                               call     l__adc_read_low_res ;  1 OV rs ?? [?l ??] 0416 23d0
                                                            ; W = v___adc_chan_7
                               datalo_clr v___ax_2+1        ;  1 OV ?? ?s [?? ??] 0417 1283
                               datahi_clr v___ax_2+1        ;  1 OV ?s rs [?? ??] 0418 1303
                               movwf    v___ax_2+1          ;  1 OV rs rs [?? ??] 0419 00dc
;  151       ax[0] = ADRESL
                               datalo_set v_adresl          ;  1 OV rs rS [?? ??] 041a 1683
                                                            ; W = v___ax_2
                               movf     v_adresl,w          ;  1 OV rS rS [?? ??] 041b 081e
                                                            ; W = v___ax_2
                               datalo_clr v___ax_2          ;  1 OV rS rs [?? ??] 041c 1283
                               movwf    v___ax_2            ;  1 OV rs rs [?? ??] 041d 00db
;  153 	  shift_alias = shift_alias >> 2
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 041e 1003
                                                            ; W = v___ax_2
                               rrf      v_shift_alias+1,f   ;  1 OV rs rs [?? ??] 041f 0cdc
                                                            ; W = v___ax_2
                               rrf      v_shift_alias,f     ;  1 OV rs rs [?? ??] 0420 0cdb
                                                            ; W = v___ax_2
                               bcf      v__status, v__c     ;  1 OV rs rs [?? ??] 0421 1003
                                                            ; W = v___ax_2
                               rrf      v_shift_alias+1,f   ;  1 OV rs rs [?? ??] 0422 0cdc
                                                            ; W = v___ax_2
                               rrf      v_shift_alias,f     ;  1 OV rs rs [?? ??] 0423 0cdb
                                                            ; W = v___ax_2
;  154 	  adc_value = ax[0]
                               movf     v___ax_2,w          ;  1 OV rs rs [?? ??] 0424 085b
                                                            ; W = v___ax_2
                               movwf    v_adc_value         ;  1 OV rs rs [?? ??] 0425 00d7
                                                            ; W = v___ax_2
;  156    return adc_value
                               movf     v_adc_value,w       ;  1 OV rs rs [?? ??] 0426 0857
                                                            ; W = v_adc_value
;  157 end function
                               return                       ;  1 OV rs rs [?? ??] 0427 0008
                                                            ; W = v_adc_value
;  266    end if
l__l474
; main.jal
;   28 adc_init()                                      -- init library
; adc/adc.jal
;  253    _adc_setup_pins()    -- conditionally defined according to PIC
; main.jal
;   28 adc_init()                                      -- init library
; adc/adc_channels.jal
;   46    var byte vcfg_shadow = ADC_NVREF
                               clrf     v___vcfg_shadow_3   ;  0 OV rs rs [hl hl] 0428 01c7
;   57       ADCON1_VCFG = vcfg_shadow
                               swapf    v___vcfg_shadow_3,w ;  0 OV rs rs [hl hl] 0429 0e47
                               movwf    v__pic_temp         ;  0 OV rs rs [hl hl] 042a 00a0
                               movlw    48                  ;  0 OV rs rs [hl hl] 042b 3030
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp,f       ;  0 OV rs rs [hl hl] 042c 05a0
                               movlw    207                 ;  0 OV rs rs [hl hl] 042d 30cf
                               datalo_set v_adcon1          ;  0 OV rs rS [hl hl] 042e 1683
                               andwf    v_adcon1,w          ;  0 OV rS rS [hl hl] 042f 051f
                               datalo_clr v__pic_temp       ;  0 OV rS rs [hl hl] 0430 1283
                               iorwf    v__pic_temp,w       ;  0 OV rs rs [hl hl] 0431 0420
                               datalo_set v_adcon1          ;  0 OV rs rS [hl hl] 0432 1683
                               movwf    v_adcon1            ;  0 OV rS rS [hl hl] 0433 009f
; adc/adc.jal
;  190 	  JALLIB_ADFM = 1
                               bsf      v_adcon1, 7 ; adcon1_adfm      ;  0 OV rS rS [hl hl] 0434 179f
                                                            ; W = v_adcon1
; adc/adc_clock.jal
;  116    var volatile bit*3 adcs = 0b_000
                               movlw    127                 ;  0 OV rS rS [hl hl] 0435 307f
                                                            ; W = v_adcon1
                               datalo_clr v__bitbucket      ;  0 OV rS rs [hl hl] 0436 1283
                               andwf    v__bitbucket,f      ;  0 OV rs rs [hl hl] 0437 05c5
                               movlw    252                 ;  0 OV rs rs [hl hl] 0438 30fc
                               andwf    v__bitbucket+1,f    ;  0 OV rs rs [hl hl] 0439 05c6
;  135 	  if _adc_eval_tad(32) == true then
                               movlw    32                  ;  0 OV rs rs [hl hl] 043a 3020
                               movwf    v___factor_1        ;  0 OV rs rs [hl hl] 043b 00d5
                               clrf     v___factor_1+1      ;  0 OV rs rs [hl hl] 043c 01d6
                                                            ; W = v___factor_1
                               branchlo_nop l__adc_eval_tad ;  0 OV rs rs [hl hl] 043d
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [hl ??] 043d 2399
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+1 ; _btemp322 ;  0 OV ?? ?s [?? ??] 043e 1283
                               datahi_clr v__bitbucket+1 ; _btemp322 ;  0 OV ?s rs [?? ??] 043f 1303
                               bcf      v__bitbucket+1, 2 ; _btemp322;  0 OV rs rs [?? ??] 0440 1146
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 0441 1820
                               bsf      v__bitbucket+1, 2 ; _btemp322;  0 OV rs rs [?? ??] 0442 1546
                               branchlo_clr l__l494         ;  0 OV rs rs [?? ?l] 0443 118a
                               btfss    v__bitbucket+1, 2 ; _btemp322;  0 OV rs rs [?l ?l] 0444 1d46
                               goto     l__l494             ;  0 OV rs rs [?l ?l] 0445 2c4d
; main.jal
;   28 adc_init()                                      -- init library
; adc/adc_clock.jal
;  136 		 adcs = 0b_010
                               movlw    127                 ;  0 OV rs rs [?l ?l] 0446 307f
                               andwf    v__bitbucket,f      ;  0 OV rs rs [?l ?l] 0447 05c5
                               movlw    252                 ;  0 OV rs rs [?l ?l] 0448 30fc
                               andwf    v__bitbucket+1,w    ;  0 OV rs rs [?l ?l] 0449 0546
                               iorlw    1                   ;  0 OV rs rs [?l ?l] 044a 3801
                               movwf    v__bitbucket+1      ;  0 OV rs rs [?l ?l] 044b 00c6
; main.jal
;   28 adc_init()                                      -- init library
; adc/adc_clock.jal
;  137 	  elsif _adc_eval_tad(8) == true then
                               branchlo_nop l__l497         ;  0 OV rs rs [?l ?l] 044c
                                                            ; W = v__bitbucket
                               goto     l__l497             ;  0 OV rs rs [?l ?l] 044c 2c70
                                                            ; W = v__bitbucket
l__l494
                               movlw    8                   ;  0 OV rs rs [?l ?l] 044d 3008
                               movwf    v___factor_1        ;  0 OV rs rs [?l ?l] 044e 00d5
                               clrf     v___factor_1+1      ;  0 OV rs rs [?l ?l] 044f 01d6
                                                            ; W = v___factor_1
                               branchlo_nop l__adc_eval_tad ;  0 OV rs rs [?l ?l] 0450
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [?l ??] 0450 2399
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+1 ; _btemp342 ;  0 OV ?? ?s [?? ??] 0451 1283
                               datahi_clr v__bitbucket+1 ; _btemp342 ;  0 OV ?s rs [?? ??] 0452 1303
                               bcf      v__bitbucket+1, 4 ; _btemp342;  0 OV rs rs [?? ??] 0453 1246
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 0454 1820
                               bsf      v__bitbucket+1, 4 ; _btemp342;  0 OV rs rs [?? ??] 0455 1646
                               branchlo_clr l__l495         ;  0 OV rs rs [?? ?l] 0456 118a
                               btfss    v__bitbucket+1, 4 ; _btemp342;  0 OV rs rs [?l ?l] 0457 1e46
                               goto     l__l495             ;  0 OV rs rs [?l ?l] 0458 2c60
; main.jal
;   28 adc_init()                                      -- init library
; adc/adc_clock.jal
;  138 		 adcs = 0b_001
                               movlw    127                 ;  0 OV rs rs [?l ?l] 0459 307f
                               andwf    v__bitbucket,w      ;  0 OV rs rs [?l ?l] 045a 0545
                               iorlw    128                 ;  0 OV rs rs [?l ?l] 045b 3880
                               movwf    v__bitbucket        ;  0 OV rs rs [?l ?l] 045c 00c5
                               movlw    252                 ;  0 OV rs rs [?l ?l] 045d 30fc
                                                            ; W = v__bitbucket
                               andwf    v__bitbucket+1,f    ;  0 OV rs rs [?l ?l] 045e 05c6
; main.jal
;   28 adc_init()                                      -- init library
; adc/adc_clock.jal
;  139 	  elsif _adc_eval_tad(2) == true then
                               branchlo_nop l__l497         ;  0 OV rs rs [?l ?l] 045f
                               goto     l__l497             ;  0 OV rs rs [?l ?l] 045f 2c70
l__l495
                               movlw    2                   ;  0 OV rs rs [?l ?l] 0460 3002
                               movwf    v___factor_1        ;  0 OV rs rs [?l ?l] 0461 00d5
                               clrf     v___factor_1+1      ;  0 OV rs rs [?l ?l] 0462 01d6
                                                            ; W = v___factor_1
                               branchlo_nop l__adc_eval_tad ;  0 OV rs rs [?l ?l] 0463
                                                            ; W = v___factor_1
                               call     l__adc_eval_tad     ;  0 OV rs ?? [?l ??] 0463 2399
                                                            ; W = v___factor_1
                               datalo_clr v__bitbucket+1 ; _btemp362 ;  0 OV ?? ?s [?? ??] 0464 1283
                               datahi_clr v__bitbucket+1 ; _btemp362 ;  0 OV ?s rs [?? ??] 0465 1303
                               bcf      v__bitbucket+1, 6 ; _btemp362;  0 OV rs rs [?? ??] 0466 1346
                               btfsc    v__pic_temp, 0 ; _pic_temp   ;  0 OV rs rs [?? ??] 0467 1820
                               bsf      v__bitbucket+1, 6 ; _btemp362;  0 OV rs rs [?? ??] 0468 1746
                               branchlo_clr l__l496         ;  0 OV rs rs [?? ?l] 0469 118a
                               btfss    v__bitbucket+1, 6 ; _btemp362;  0 OV rs rs [?l ?l] 046a 1f46
                               goto     l__l496             ;  0 OV rs rs [?l ?l] 046b 2c70
; main.jal
;   28 adc_init()                                      -- init library
; adc/adc_clock.jal
;  140 		 adcs = 0b_000
                               movlw    127                 ;  0 OV rs rs [?l ?l] 046c 307f
                               andwf    v__bitbucket,f      ;  0 OV rs rs [?l ?l] 046d 05c5
                               movlw    252                 ;  0 OV rs rs [?l ?l] 046e 30fc
                               andwf    v__bitbucket+1,f    ;  0 OV rs rs [?l ?l] 046f 05c6
; main.jal
;   28 adc_init()                                      -- init library
; adc/adc_clock.jal
;  141 	  end if
l__l496
l__l497
;  154 	  jallib_adcs_lsb = adcs_lsb
                               rrf      v__bitbucket+1,w    ;  0 OV rs rs [?l ?l] 0470 0c46
                               movwf    v__pic_temp+2       ;  0 OV rs rs [?l ?l] 0471 00a2
                               rrf      v__bitbucket,w      ;  0 OV rs rs [?l ?l] 0472 0c45
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?l ?l] 0473 00a1
                               movlw    6                   ;  0 OV rs rs [?l ?l] 0474 3006
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+3       ;  0 OV rs rs [?l ?l] 0475 00a3
l__l1090
                               rrf      v__pic_temp+2,f     ;  0 OV rs rs [?l ?l] 0476 0ca2
                               rrf      v__pic_temp+1,f     ;  0 OV rs rs [?l ?l] 0477 0ca1
                               branchlo_nop l__l1090        ;  0 OV rs rs [?l ?l] 0478
                               decfsz   v__pic_temp+3,f     ;  0 OV rs rs [?l ?l] 0478 0ba3
                               goto     l__l1090            ;  0 OV rs rs [?l ?l] 0479 2c76
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?l ?l] 047a 0821
                               movwf    v__pic_temp         ;  0 OV rs rs [?l ?l] 047b 00a0
                                                            ; W = v__pic_temp
                               movlw    3                   ;  0 OV rs rs [?l ?l] 047c 3003
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp,f       ;  0 OV rs rs [?l ?l] 047d 05a0
                               rrf      v__pic_temp,w       ;  0 OV rs rs [?l ?l] 047e 0c20
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?l ?l] 047f 00a1
                               rrf      v__pic_temp+1,f     ;  0 OV rs rs [?l ?l] 0480 0ca1
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp+1,w     ;  0 OV rs rs [?l ?l] 0481 0c21
                               movwf    v__pic_temp+1       ;  0 OV rs rs [?l ?l] 0482 00a1
                               movlw    192                 ;  0 OV rs rs [?l ?l] 0483 30c0
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp+1,f     ;  0 OV rs rs [?l ?l] 0484 05a1
                               movlw    63                  ;  0 OV rs rs [?l ?l] 0485 303f
                               andwf    v_adcon0,w          ;  0 OV rs rs [?l ?l] 0486 051f
                               iorwf    v__pic_temp+1,w     ;  0 OV rs rs [?l ?l] 0487 0421
                               movwf    v_adcon0            ;  0 OV rs rs [?l ?l] 0488 009f
; main.jal
;   28 adc_init()                                      -- init library
; adc/adc.jal
;  270    _adc_init_clock()
; main.jal
;   28 adc_init()                                      -- init library
; adc/adc.jal
;  243    adc_conversion_delay = 2 + adc_tc + adc_tcoff   -- Tamp seems to be a constant: 2usecs
                               movlw    16                  ;  0 OV rs rs [?l ?l] 0489 3010
                                                            ; W = v_adcon0
                               movwf    v_adc_conversion_delay;  0 OV rs rs [?l ?l] 048a 00b3
; main.jal
;   28 adc_init()                                      -- init library
; adc/adc.jal
;  271    _adc_init_acquisition_delay()
; main.jal
;   28 adc_init()                                      -- init library
;   29 set_analog_pin(ADC_CHANNEL_A)                   -- init used ADC channel
                               movlw    0                   ;  0 OV rs rs [?l ?l] 048b 3000
                                                            ; W = v_adc_conversion_delay
                               branchlo_nop l_set_analog_pin;  0 OV rs rs [?l ?l] 048c
                               call     l_set_analog_pin    ;  0 OV rs ?? [?l ??] 048c 232c
;   33 pin_CCP1_direction = output
                               datalo_set v_trisc ; pin_c2_direction        ;  0 OV ?? ?S [?? ??] 048d 1683
                               datahi_clr v_trisc ; pin_c2_direction        ;  0 OV ?S rS [?? ??] 048e 1303
                               bcf      v_trisc, 2 ; pin_c2_direction       ;  0 OV rS rS [?? ??] 048f 1107
; pwm/pwm_common.jal
;   23 var volatile word _pr2_shadow_plus1 = 256           -- value(PR2) + 1
                               datalo_clr v__pr2_shadow_plus1;  0 OV rS rs [?? ??] 0490 1283
                               clrf     v__pr2_shadow_plus1 ;  0 OV rs rs [?? ??] 0491 01ad
                               movlw    1                   ;  0 OV rs rs [?? ??] 0492 3001
                               movwf    v__pr2_shadow_plus1+1;  0 OV rs rs [?? ??] 0493 00ae
;   50 procedure pwm_max_resolution(byte in prescaler) is
                               branchlo_clr l__l511         ;  0 OV rs rs [?? ?l] 0494 118a
                               goto     l__l511             ;  0 OV rs rs [?l ?l] 0495 2cbc
l_pwm_max_resolution
                               movwf    v___prescaler_1     ;  1 OV rs rs [?l ?l] 0496 00d5
;   52    _pr2_shadow_plus1 = 256                      -- for maximum resolution
                               clrf     v__pr2_shadow_plus1 ;  1 OV rs rs [?l ?l] 0497 01ad
                                                            ; W = v___prescaler_1
                               movlw    1                   ;  1 OV rs rs [?l ?l] 0498 3001
                                                            ; W = v___prescaler_1
                               movwf    v__pr2_shadow_plus1+1;  1 OV rs rs [?l ?l] 0499 00ae
;   53    PR2 = byte(_pr2_shadow_plus1 - 1)            -- set PR2
                               decf     v__pr2_shadow_plus1,w;  1 OV rs rs [?l ?l] 049a 032d
                               datalo_set v_pr2             ;  1 OV rs rS [?l ?l] 049b 1683
                               movwf    v_pr2               ;  1 OV rS rS [?l ?l] 049c 0092
;   56    if prescaler == 1 then
                               movlw    1                   ;  1 OV rS rS [?l ?l] 049d 3001
                               datalo_clr v___prescaler_1   ;  1 OV rS rs [?l ?l] 049e 1283
                               subwf    v___prescaler_1,w   ;  1 OV rs rs [?l ?l] 049f 0255
                               branchlo_nop l__l508         ;  1 OV rs rs [?l ?l] 04a0
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 04a0 1d03
                               goto     l__l508             ;  1 OV rs rs [?l ?l] 04a1 2ca6
;   57       T2CON_T2CKPS = 0b00                       -- prescaler 1:1
                               movlw    252                 ;  1 OV rs rs [?l ?l] 04a2 30fc
                                                            ; W = v_t2con
                               andwf    v_t2con,f           ;  1 OV rs rs [?l ?l] 04a3 0592
;   58       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?l ?l] 04a4 1512
;   59    elsif prescaler == 4  then
                               return                       ;  1 OV rs rs [?l ?l] 04a5 0008
l__l508
                               movlw    4                   ;  1 OV rs rs [?l ?l] 04a6 3004
                               subwf    v___prescaler_1,w   ;  1 OV rs rs [?l ?l] 04a7 0255
                               branchlo_nop l__l509         ;  1 OV rs rs [?l ?l] 04a8
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 04a8 1d03
                               goto     l__l509             ;  1 OV rs rs [?l ?l] 04a9 2cb0
;   60       T2CON_T2CKPS = 0b01                       -- prescaler 1:4
                               movlw    252                 ;  1 OV rs rs [?l ?l] 04aa 30fc
                                                            ; W = v_t2con
                               andwf    v_t2con,w           ;  1 OV rs rs [?l ?l] 04ab 0512
                               iorlw    1                   ;  1 OV rs rs [?l ?l] 04ac 3801
                               movwf    v_t2con             ;  1 OV rs rs [?l ?l] 04ad 0092
;   61       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?l ?l] 04ae 1512
                                                            ; W = v_t2con
;   62    elsif prescaler == 16 then
                               return                       ;  1 OV rs rs [?l ?l] 04af 0008
                                                            ; W = v_t2con
l__l509
                               movlw    16                  ;  1 OV rs rs [?l ?l] 04b0 3010
                               subwf    v___prescaler_1,w   ;  1 OV rs rs [?l ?l] 04b1 0255
                               branchlo_nop l__l510         ;  1 OV rs rs [?l ?l] 04b2
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 04b2 1d03
                               goto     l__l510             ;  1 OV rs rs [?l ?l] 04b3 2cba
;   63       T2CON_T2CKPS = 0b10                       -- prescaler 1:16
                               movlw    252                 ;  1 OV rs rs [?l ?l] 04b4 30fc
                               andwf    v_t2con,w           ;  1 OV rs rs [?l ?l] 04b5 0512
                               iorlw    2                   ;  1 OV rs rs [?l ?l] 04b6 3802
                               movwf    v_t2con             ;  1 OV rs rs [?l ?l] 04b7 0092
;   64       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?l ?l] 04b8 1512
                                                            ; W = v_t2con
;   65    else
                               return                       ;  1 OV rs rs [?l ?l] 04b9 0008
                                                            ; W = v_t2con
l__l510
;   66       T2CON_TMR2ON = FALSE                      -- disable Timer2 (= PWM off!)
                               bcf      v_t2con, 2 ; t2con_tmr2on       ;  1 OV rs rs [?l ?l] 04ba 1112
;   67    end if
l__l507
;   69 end procedure
                               return                       ;  1 OV rs rs [?l ?l] 04bb 0008
;  105 end procedure
l__l511
; pwm/pwm_ccp1.jal
;   23 var byte  _ccpr1l_shadow  = 0                            -- 8 MSbits of duty cycle
                               clrf     v__ccpr1l_shadow    ;  0 OV rs rs [?l ?l] 04bc 01b6
;   24 var byte  _ccp1con_shadow = 0b0000_0000                  -- shadow
                               clrf     v__ccp1con_shadow   ;  0 OV rs rs [?l ?l] 04bd 01b7
;   32 procedure pwm1_on() is
                               branchlo_nop l__l518         ;  0 OV rs rs [?l ?l] 04be
                               goto     l__l518             ;  0 OV rs rs [?l ?l] 04be 2cff
l_pwm1_on
;   34    _ccp1con_shadow_ccp1m = 0b1100                    -- set PWM mode
                               movlw    240                 ;  1 OV ?? ?? [?l ?l] 04bf 30f0
                                                            ; W = v__ccp1con_shadow
                               datalo_clr v__ccp1con_shadow ;  1 OV ?? ?s [?l ?l] 04c0 1283
                               datahi_clr v__ccp1con_shadow ;  1 OV ?s rs [?l ?l] 04c1 1303
                               andwf    v__ccp1con_shadow,w ;  1 OV rs rs [?l ?l] 04c2 0537
                               iorlw    12                  ;  1 OV rs rs [?l ?l] 04c3 380c
                               movwf    v__ccp1con_shadow   ;  1 OV rs rs [?l ?l] 04c4 00b7
;   35    CCPR1L                = _ccpr1l_shadow            -- restore duty cycle
                               movf     v__ccpr1l_shadow,w  ;  1 OV rs rs [?l ?l] 04c5 0836
                                                            ; W = v__ccp1con_shadow
                               movwf    v_ccpr1l            ;  1 OV rs rs [?l ?l] 04c6 0095
                                                            ; W = v__ccpr1l_shadow
;   36    CCP1CON               = _ccp1con_shadow           -- activate CCP module
                               movf     v__ccp1con_shadow,w ;  1 OV rs rs [?l ?l] 04c7 0837
                               movwf    v_ccp1con           ;  1 OV rs rs [?l ?l] 04c8 0097
                                                            ; W = v__ccp1con_shadow
;   38 end procedure
                               return                       ;  1 OV rs rs [?l ?l] 04c9 0008
;   57 procedure pwm1_set_dutycycle_highres(word in duty) is
l_pwm1_set_dutycycle_highres
;   59    if (duty > 1023) then                            -- upper limit
                               movlw    3                   ;  1 OV rs rs [?l ?l] 04ca 3003
                                                            ; W = v___duty_1
                               subwf    v___duty_1+1,w      ;  1 OV rs rs [?l ?l] 04cb 0263
                               branchlo_nop l__l1091        ;  1 OV rs rs [?l ?l] 04cc
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 04cc 1d03
                               goto     l__l1091            ;  1 OV rs rs [?l ?l] 04cd 2cd0
                               movlw    255                 ;  1 OV rs rs [?l ?l] 04ce 30ff
                                                            ; W = v___duty_1
                               subwf    v___duty_1,w        ;  1 OV rs rs [?l ?l] 04cf 0262
l__l1091
                               branchlo_nop l__l527         ;  1 OV rs rs [?l ?l] 04d0
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 04d0 1903
                               goto     l__l527             ;  1 OV rs rs [?l ?l] 04d1 2cd8
                               branchlo_nop l__l527         ;  1 OV rs rs [?l ?l] 04d2
                               btfss    v__status, v__c     ;  1 OV rs rs [?l ?l] 04d2 1c03
                               goto     l__l527             ;  1 OV rs rs [?l ?l] 04d3 2cd8
;   60       duty = 1023
                               movlw    255                 ;  1 OV rs rs [?l ?l] 04d4 30ff
                               movwf    v___duty_1          ;  1 OV rs rs [?l ?l] 04d5 00e2
                               movlw    3                   ;  1 OV rs rs [?l ?l] 04d6 3003
                                                            ; W = v___duty_1
                               movwf    v___duty_1+1        ;  1 OV rs rs [?l ?l] 04d7 00e3
;   61    end if
l__l527
;   62    _ccpr1l_shadow = byte(duty >> 2)
                               bcf      v__status, v__c     ;  1 OV rs rs [?l ?l] 04d8 1003
                               rrf      v___duty_1+1,w      ;  1 OV rs rs [?l ?l] 04d9 0c63
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?l ?l] 04da 00a1
                               rrf      v___duty_1,w        ;  1 OV rs rs [?l ?l] 04db 0c62
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp         ;  1 OV rs rs [?l ?l] 04dc 00a0
                               bcf      v__status, v__c     ;  1 OV rs rs [?l ?l] 04dd 1003
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp+1,f     ;  1 OV rs rs [?l ?l] 04de 0ca1
                                                            ; W = v__pic_temp
                               rrf      v__pic_temp,f       ;  1 OV rs rs [?l ?l] 04df 0ca0
                               movf     v__pic_temp,w       ;  1 OV rs rs [?l ?l] 04e0 0820
                               movwf    v__ccpr1l_shadow    ;  1 OV rs rs [?l ?l] 04e1 00b6
                                                            ; W = v__pic_temp
;   63    _ccp1con_shadow_dc1b = byte(duty) & 0b11
                               movlw    3                   ;  1 OV rs rs [?l ?l] 04e2 3003
                                                            ; W = v__ccpr1l_shadow
                               andwf    v___duty_1,w        ;  1 OV rs rs [?l ?l] 04e3 0562
                               movwf    v__pic_temp         ;  1 OV rs rs [?l ?l] 04e4 00a0
                               swapf    v__pic_temp,w       ;  1 OV rs rs [?l ?l] 04e5 0e20
                                                            ; W = v__pic_temp
                               movwf    v__pic_temp+1       ;  1 OV rs rs [?l ?l] 04e6 00a1
                               movlw    48                  ;  1 OV rs rs [?l ?l] 04e7 3030
                                                            ; W = v__pic_temp
                               andwf    v__pic_temp+1,f     ;  1 OV rs rs [?l ?l] 04e8 05a1
                               movlw    207                 ;  1 OV rs rs [?l ?l] 04e9 30cf
                               andwf    v__ccp1con_shadow,w ;  1 OV rs rs [?l ?l] 04ea 0537
                               iorwf    v__pic_temp+1,w     ;  1 OV rs rs [?l ?l] 04eb 0421
                               movwf    v__ccp1con_shadow   ;  1 OV rs rs [?l ?l] 04ec 00b7
;   65    pwm1_on()                                        -- activate PWM
                               branchlo_nop l_pwm1_on       ;  1 OV rs rs [?l ?l] 04ed
                                                            ; W = v__ccp1con_shadow
                               goto     l_pwm1_on           ;  1 OV rs rs [?l ?l] 04ed 2cbf
                                                            ; W = v__ccp1con_shadow
;   67 end procedure
;   98 procedure pwm1_set_dutycycle(byte in duty) is
l_pwm1_set_dutycycle
                               movwf    v___duty_5          ;  1 OV rs rs [?l ?l] 04ee 00d5
                                                            ; W = v_pwmvalue
;  100    pwm1_set_dutycycle_highres(word(duty) << 2)
                               movf     v___duty_5,w        ;  1 OV rs rs [?l ?l] 04ef 0855
                                                            ; W = v___duty_5
                               movwf    v____temp_40        ;  1 OV rs rs [?l ?l] 04f0 00d7
                                                            ; W = v___duty_5
                               clrf     v____temp_40+1      ;  1 OV rs rs [?l ?l] 04f1 01d8
                                                            ; W = v____temp_40
                               bcf      v__status, v__c     ;  1 OV rs rs [?l ?l] 04f2 1003
                                                            ; W = v____temp_40
                               rlf      v____temp_40,w      ;  1 OV rs rs [?l ?l] 04f3 0d57
                                                            ; W = v____temp_40
                               movwf    v____temp_40+2      ;  1 OV rs rs [?l ?l] 04f4 00d9
                               rlf      v____temp_40+1,w    ;  1 OV rs rs [?l ?l] 04f5 0d58
                                                            ; W = v____temp_40
                               movwf    v____temp_40+3      ;  1 OV rs rs [?l ?l] 04f6 00da
                               bcf      v__status, v__c     ;  1 OV rs rs [?l ?l] 04f7 1003
                                                            ; W = v____temp_40
                               rlf      v____temp_40+2,f    ;  1 OV rs rs [?l ?l] 04f8 0dd9
                                                            ; W = v____temp_40
                               rlf      v____temp_40+3,f    ;  1 OV rs rs [?l ?l] 04f9 0dda
                               movf     v____temp_40+2,w    ;  1 OV rs rs [?l ?l] 04fa 0859
                               movwf    v___duty_1          ;  1 OV rs rs [?l ?l] 04fb 00e2
                                                            ; W = v____temp_40
                               movf     v____temp_40+3,w    ;  1 OV rs rs [?l ?l] 04fc 085a
                                                            ; W = v___duty_1
                               movwf    v___duty_1+1        ;  1 OV rs rs [?l ?l] 04fd 00e3
                                                            ; W = v____temp_40
                               branchlo_nop l_pwm1_set_dutycycle_highres;  1 OV rs rs [?l ?l] 04fe
                                                            ; W = v___duty_1
                               goto     l_pwm1_set_dutycycle_highres;  1 OV rs rs [?l ?l] 04fe 2cca
                                                            ; W = v___duty_1
;  102 end procedure
; pwm/pwm_hardware.jal
;   51 end if
l__l518
; pwm/pwm_ccp2.jal
;   23 var byte  _ccpr2l_shadow  = 0                            -- 8 MSbits of duty cycle
; main.jal
;   35 pwm_max_resolution(1)
                               movlw    1                   ;  0 OV rs rs [?l ?l] 04ff 3001
                               branchlo_nop l_pwm_max_resolution;  0 OV rs rs [?l ?l] 0500
                               call     l_pwm_max_resolution;  0 OV rs ?? [?l ??] 0500 2496
;   36 pwm1_on()
                               branchlo_clr l_pwm1_on       ;  0 OV ?? ?? [?? ?l] 0501 118a
                               call     l_pwm1_on           ;  0 OV ?? ?? [?l ??] 0502 24bf
; usart_common.jal
;   43 procedure _calculate_and_set_baudrate() is
                               branchlo_clr l__l622         ;  0 OV ?? ?? [?? ?l] 0503 118a
                               goto     l__l622             ;  0 OV ?? ?? [?l ?l] 0504 2db7
l__calculate_and_set_baudrate
;   49          BAUDCTL_BRG16 = true
                               datalo_set v_baudctl ; baudctl_brg16      ;  2 OV ?? ?S [?l ?l] 0505 1683
                               datahi_set v_baudctl ; baudctl_brg16      ;  2 OV ?S RS [?l ?l] 0506 1703
                               bsf      v_baudctl, 3 ; baudctl_brg16     ;  2 OV RS RS [?l ?l] 0507 1587
;   50          TXSTA_BRGH = true
                               datahi_clr v_txsta ; txsta_brgh        ;  2 OV RS rS [?l ?l] 0508 1303
                               bsf      v_txsta, 2 ; txsta_brgh       ;  2 OV rS rS [?l ?l] 0509 1518
;   65          SPBRG = byte(usart_div)
                               movlw    3                   ;  2 OV rS rS [?l ?l] 050a 3003
                               movwf    v_spbrg             ;  2 OV rS rS [?l ?l] 050b 0099
;   66          SPBRGH = byte(usart_div >> 8)
                               movlw    1                   ;  2 OV rS rS [?l ?l] 050c 3001
                               movwf    v_spbrgh            ;  2 OV rS rS [?l ?l] 050d 009a
;  152 end procedure
                               return                       ;  2 OV rS rS [?l ?l] 050e 0008
; serial_hardware.jal
;   25 procedure serial_hw_init() is 
l_serial_hw_init
;   27    _calculate_and_set_baudrate()
                               branchlo_nop l__calculate_and_set_baudrate;  1 OV ?? ?? [?l ?l] 050f
                               call     l__calculate_and_set_baudrate;  1 OV ?? ?? [?l ??] 050f 2505
;   30    PIE1_RCIE = false
                               datalo_set v_pie1 ; pie1_rcie         ;  1 OV ?? ?S [?? ??] 0510 1683
                               datahi_clr v_pie1 ; pie1_rcie         ;  1 OV ?S rS [?? ??] 0511 1303
                               bcf      v_pie1, 5 ; pie1_rcie        ;  1 OV rS rS [?? ??] 0512 128c
;   31    PIE1_TXIE = false
                               bcf      v_pie1, 4 ; pie1_txie        ;  1 OV rS rS [?? ??] 0513 120c
;   34    TXSTA_TXEN = true
                               bsf      v_txsta, 5 ; txsta_txen       ;  1 OV rS rS [?? ??] 0514 1698
;   38    RCSTA = 0x90
                               movlw    144                 ;  1 OV rS rS [?? ??] 0515 3090
                               datalo_clr v_rcsta           ;  1 OV rS rs [?? ??] 0516 1283
                               movwf    v_rcsta             ;  1 OV rs rs [?? ??] 0517 0098
;   40 end procedure
                               return                       ;  1 OV rs rs [?? ??] 0518 0008
;   67 procedure serial_hw_write(byte in data) is
l_serial_hw_write
                               datalo_set v___data_1        ;  3 OV ?? ?S [?l ?l] 0519 1683
                               datahi_clr v___data_1        ;  3 OV ?S rS [?l ?l] 051a 1303
                               movwf    v___data_1          ;  3 OV rS rS [?l ?l] 051b 00bd
;   69    while ! PIR1_TXIF loop end loop
l__l577
                               datalo_clr v_pir1 ; pir1_txif         ;  3 OV r? rs [?l ?l] 051c 1283
                                                            ; W = v___data_1
                               branchlo_nop l__l578         ;  3 OV rs rs [?l ?l] 051d
                                                            ; W = v___data_1
                               btfsc    v_pir1, 4 ; pir1_txif        ;  3 OV rs rs [?l ?l] 051d 1a0c
                                                            ; W = v___data_1
                               goto     l__l578             ;  3 OV rs rs [?l ?l] 051e 2d20
                                                            ; W = v___data_1
                               branchlo_nop l__l577         ;  3 OV rs rs [?l ?l] 051f
                               goto     l__l577             ;  3 OV rs rs [?l ?l] 051f 2d1c
l__l578
;   71    TXREG = data
                               datalo_set v___data_1        ;  3 OV rs rS [?l ?l] 0520 1683
                                                            ; W = v___data_1
                               movf     v___data_1,w        ;  3 OV rS rS [?l ?l] 0521 083d
                                                            ; W = v___data_1
                               datalo_clr v_txreg           ;  3 OV rS rs [?l ?l] 0522 1283
                                                            ; W = v___data_1
                               movwf    v_txreg             ;  3 OV rs rs [?l ?l] 0523 0099
                                                            ; W = v___data_1
;   72 end procedure
                               return                       ;  3 OV rs rs [?l ?l] 0524 0008
;  177 procedure serial_hw_printf(byte in str[]) is
l_serial_hw_printf
;  184     l=count(str)
                               movf     v__str_count,w      ;  1 OV rs rs [?l ?l] 0525 0855
                                                            ; W = v___str_1
                               movwf    v_l                 ;  1 OV rs rs [?l ?l] 0526 00de
                                                            ; W = v__str_count
;  185     for l using t loop
                               clrf     v_t                 ;  1 OV rs rs [?l ?l] 0527 01e2
                                                            ; W = v_l
                               branchlo_nop l__l620         ;  1 OV rs rs [?l ?l] 0528
                                                            ; W = v_l
                               goto     l__l620             ;  1 OV rs rs [?l ?l] 0528 2d38
                                                            ; W = v_l
l__l619
;  187         serial_hw_write(str[t])
                               movf     v___str_1+1,w       ;  1 OV rs rs [?l ?l] 0529 085c
                               movwf    v__pic_pointer+1    ;  1 OV rs rs [?l ?l] 052a 00ab
                                                            ; W = v___str_1
                               movf     v_t,w               ;  1 OV rs rs [?l ?l] 052b 0862
                                                            ; W = v__pic_pointer
                               addwf    v___str_1,w         ;  1 OV rs rs [?l ?l] 052c 075b
                                                            ; W = v_t
                               movwf    v__pic_pointer      ;  1 OV rs rs [?l ?l] 052d 00aa
                               btfsc    v__status, v__c     ;  1 OV rs rs [?l ?l] 052e 1803
                                                            ; W = v__pic_pointer
                               incf     v__pic_pointer+1,f  ;  1 OV rs rs [?l ?l] 052f 0aab
                                                            ; W = v__pic_pointer
                               bcf      v__pic_pointer+1, 6 ;  1 OV rs rs [?l ?l] 0530 132b
                               movf     v__pic_pointer+1,w  ;  1 OV rs rs [?l ?l] 0531 082b
                               branchlo_nop l__pic_indirect ;  1 OV rs rs [?l ?l] 0532
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?l ??] 0532 22c9
                                                            ; W = v__pic_pointer
                               branchlo_clr l_serial_hw_write;  1 OV ?? ?? [?? ?l] 0533 118a
                               call     l_serial_hw_write   ;  1 OV ?? ?? [?l ??] 0534 2519
;  188     end loop
                               datalo_clr v_t               ;  1 OV ?? ?s [?? ??] 0535 1283
                               datahi_clr v_t               ;  1 OV ?s rs [?? ??] 0536 1303
                               incf     v_t,f               ;  1 OV rs rs [?? ??] 0537 0ae2
l__l620
                               movf     v_t,w               ;  1 OV rs rs [?? ??] 0538 0862
                                                            ; W = v_l
                               subwf    v_l,w               ;  1 OV rs rs [?? ??] 0539 025e
                                                            ; W = v_t
                               branchlo_clr l__l619         ;  1 OV rs rs [?? ?l] 053a 118a
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 053b 1d03
                               goto     l__l619             ;  1 OV rs rs [?l ?l] 053c 2d29
;  189 end procedure
                               return                       ;  1 OV rs rs [?l ?l] 053d 0008
;  191 procedure serial_hw_byte(word in b) is
l_serial_hw_byte
;  197     oldb=b;
                               movf     v___b_1,w           ;  2 OV rS rS [?l ?l] 053e 0836
                                                            ; W = v___b_1
                               movwf    v_oldb              ;  2 OV rS rS [?l ?l] 053f 00ba
                                                            ; W = v___b_1
;  198     zw=b/100;                               -- One hundreds
                               movlw    100                 ;  2 OV rS rS [?l ?l] 0540 3064
                                                            ; W = v_oldb
                               datalo_clr v__pic_divisor    ;  2 OV rS rs [?l ?l] 0541 1283
                               movwf    v__pic_divisor      ;  2 OV rs rs [?l ?l] 0542 00a4
                               clrf     v__pic_divisor+1    ;  2 OV rs rs [?l ?l] 0543 01a5
                                                            ; W = v__pic_divisor
                               datalo_set v___b_1           ;  2 OV rs rS [?l ?l] 0544 1683
                                                            ; W = v__pic_divisor
                               movf     v___b_1,w           ;  2 OV rS rS [?l ?l] 0545 0836
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_dividend   ;  2 OV rS rs [?l ?l] 0546 1283
                                                            ; W = v___b_1
                               movwf    v__pic_dividend     ;  2 OV rs rs [?l ?l] 0547 00a0
                                                            ; W = v___b_1
                               datalo_set v___b_1           ;  2 OV rs rS [?l ?l] 0548 1683
                                                            ; W = v__pic_dividend
                               movf     v___b_1+1,w         ;  2 OV rS rS [?l ?l] 0549 0837
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  2 OV rS rs [?l ?l] 054a 1283
                                                            ; W = v___b_1
                               movwf    v__pic_dividend+1   ;  2 OV rs rs [?l ?l] 054b 00a1
                                                            ; W = v___b_1
                               branchlo_nop l__pic_divide   ;  2 OV rs rs [?l ?l] 054c
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  2 OV rs ?? [?l ??] 054c 22a9
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  2 OV ?? ?s [?? ??] 054d 1283
                               datahi_clr v__pic_quotient   ;  2 OV ?s rs [?? ??] 054e 1303
                               movf     v__pic_quotient,w   ;  2 OV rs rs [?? ??] 054f 0826
                               datalo_set v_zw              ;  2 OV rs rS [?? ??] 0550 1683
                                                            ; W = v__pic_quotient
                               movwf    v_zw                ;  2 OV rS rS [?? ??] 0551 00b9
                                                            ; W = v__pic_quotient
;  199     if (oldb>=100) then serial_hw_write(zw+0x30) else serial_hw_write(32) end if;
                               movlw    100                 ;  2 OV rS rS [?? ??] 0552 3064
                                                            ; W = v_zw
                               subwf    v_oldb,w            ;  2 OV rS rS [?? ??] 0553 023a
                               branchlo_clr l__l1094        ;  2 OV rS rS [?? ?l] 0554 118a
                               btfsc    v__status, v__z     ;  2 OV rS rS [?l ?l] 0555 1903
                               goto     l__l1094            ;  2 OV rS rS [?l ?l] 0556 2d59
                               branchlo_nop l__l625         ;  2 OV rS rS [?l ?l] 0557
                               btfss    v__status, v__c     ;  2 OV rS rS [?l ?l] 0557 1c03
                               goto     l__l625             ;  2 OV rS rS [?l ?l] 0558 2d60
l__l1094
                               movlw    48                  ;  2 OV rS rS [?l ?l] 0559 3030
                               addwf    v_zw,w              ;  2 OV rS rS [?l ?l] 055a 0739
                               movwf    v____temp_46        ;  2 OV rS rS [?l ?l] 055b 00bb
                               movf     v____temp_46,w      ;  2 OV rS rS [?l ?l] 055c 083b
                                                            ; W = v____temp_46
                               branchlo_nop l_serial_hw_write;  2 OV rS rS [?l ?l] 055d
                                                            ; W = v____temp_46
                               call     l_serial_hw_write   ;  2 OV rS ?? [?l ??] 055d 2519
                                                            ; W = v____temp_46
                               branchlo_clr l__l624         ;  2 OV ?? ?? [?? ?l] 055e 118a
                               goto     l__l624             ;  2 OV ?? ?? [?l ?l] 055f 2d62
l__l625
                               movlw    32                  ;  2 OV rS rS [?l ?l] 0560 3020
                               branchlo_nop l_serial_hw_write;  2 OV rS rS [?l ?l] 0561
                               call     l_serial_hw_write   ;  2 OV rS ?? [?l ??] 0561 2519
l__l624
;  200     b=b-zw*100;                             -- Tens
                               datalo_set v_zw              ;  2 OV ?? ?S [?? ??] 0562 1683
                               datahi_clr v_zw              ;  2 OV ?S rS [?? ??] 0563 1303
                               movf     v_zw,w              ;  2 OV rS rS [?? ??] 0564 0839
                               datalo_clr v__pic_multiplier ;  2 OV rS rs [?? ??] 0565 1283
                                                            ; W = v_zw
                               movwf    v__pic_multiplier   ;  2 OV rs rs [?? ??] 0566 00a0
                                                            ; W = v_zw
                               clrf     v__pic_multiplier+1 ;  2 OV rs rs [?? ??] 0567 01a1
                                                            ; W = v__pic_multiplier
                               movlw    100                 ;  2 OV rs rs [?? ??] 0568 3064
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  2 OV rs rs [?? ??] 0569 00a2
                               clrf     v__pic_multiplicand+1;  2 OV rs rs [?? ??] 056a 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  2 OV rs rs [?? ?l] 056b 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  2 OV rs ?? [?l ??] 056c 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  2 OV ?? ?s [?? ??] 056d 1283
                               datahi_clr v__pic_mresult    ;  2 OV ?s rs [?? ??] 056e 1303
                               movf     v__pic_mresult,w    ;  2 OV rs rs [?? ??] 056f 0824
                               datalo_set v____temp_46      ;  2 OV rs rS [?? ??] 0570 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_46        ;  2 OV rS rS [?? ??] 0571 00bb
                                                            ; W = v__pic_mresult
                               movf     v____temp_46,w      ;  2 OV rS rS [?? ??] 0572 083b
                                                            ; W = v____temp_46
                               subwf    v___b_1,f           ;  2 OV rS rS [?? ??] 0573 02b6
                                                            ; W = v____temp_46
                               btfss    v__status, v__c     ;  2 OV rS rS [?? ??] 0574 1c03
                                                            ; W = v____temp_46
                               decf     v___b_1+1,f         ;  2 OV rS rS [?? ??] 0575 03b7
                                                            ; W = v____temp_46
;  201     zw=b/10;
                               movlw    10                  ;  2 OV rS rS [?? ??] 0576 300a
                                                            ; W = v____temp_46
                               datalo_clr v__pic_divisor    ;  2 OV rS rs [?? ??] 0577 1283
                               movwf    v__pic_divisor      ;  2 OV rs rs [?? ??] 0578 00a4
                               clrf     v__pic_divisor+1    ;  2 OV rs rs [?? ??] 0579 01a5
                                                            ; W = v__pic_divisor
                               datalo_set v___b_1           ;  2 OV rs rS [?? ??] 057a 1683
                                                            ; W = v__pic_divisor
                               movf     v___b_1,w           ;  2 OV rS rS [?? ??] 057b 0836
                                                            ; W = v__pic_divisor
                               datalo_clr v__pic_dividend   ;  2 OV rS rs [?? ??] 057c 1283
                                                            ; W = v___b_1
                               movwf    v__pic_dividend     ;  2 OV rs rs [?? ??] 057d 00a0
                                                            ; W = v___b_1
                               datalo_set v___b_1           ;  2 OV rs rS [?? ??] 057e 1683
                                                            ; W = v__pic_dividend
                               movf     v___b_1+1,w         ;  2 OV rS rS [?? ??] 057f 0837
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_dividend   ;  2 OV rS rs [?? ??] 0580 1283
                                                            ; W = v___b_1
                               movwf    v__pic_dividend+1   ;  2 OV rs rs [?? ??] 0581 00a1
                                                            ; W = v___b_1
                               branchlo_clr l__pic_divide   ;  2 OV rs rs [?? ?l] 0582 118a
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  2 OV rs ?? [?l ??] 0583 22a9
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  2 OV ?? ?s [?? ??] 0584 1283
                               datahi_clr v__pic_quotient   ;  2 OV ?s rs [?? ??] 0585 1303
                               movf     v__pic_quotient,w   ;  2 OV rs rs [?? ??] 0586 0826
                               datalo_set v_zw              ;  2 OV rs rS [?? ??] 0587 1683
                                                            ; W = v__pic_quotient
                               movwf    v_zw                ;  2 OV rS rS [?? ??] 0588 00b9
                                                            ; W = v__pic_quotient
;  202     if (oldb>=10) then serial_hw_write(zw+0x30)  else serial_hw_write(32) end if;
                               movlw    10                  ;  2 OV rS rS [?? ??] 0589 300a
                                                            ; W = v_zw
                               subwf    v_oldb,w            ;  2 OV rS rS [?? ??] 058a 023a
                               branchlo_clr l__l1096        ;  2 OV rS rS [?? ?l] 058b 118a
                               btfsc    v__status, v__z     ;  2 OV rS rS [?l ?l] 058c 1903
                               goto     l__l1096            ;  2 OV rS rS [?l ?l] 058d 2d90
                               branchlo_nop l__l627         ;  2 OV rS rS [?l ?l] 058e
                               btfss    v__status, v__c     ;  2 OV rS rS [?l ?l] 058e 1c03
                               goto     l__l627             ;  2 OV rS rS [?l ?l] 058f 2d97
l__l1096
                               movlw    48                  ;  2 OV rS rS [?l ?l] 0590 3030
                               addwf    v_zw,w              ;  2 OV rS rS [?l ?l] 0591 0739
                               movwf    v____temp_46        ;  2 OV rS rS [?l ?l] 0592 00bb
                               movf     v____temp_46,w      ;  2 OV rS rS [?l ?l] 0593 083b
                                                            ; W = v____temp_46
                               branchlo_nop l_serial_hw_write;  2 OV rS rS [?l ?l] 0594
                                                            ; W = v____temp_46
                               call     l_serial_hw_write   ;  2 OV rS ?? [?l ??] 0594 2519
                                                            ; W = v____temp_46
                               branchlo_clr l__l626         ;  2 OV ?? ?? [?? ?l] 0595 118a
                               goto     l__l626             ;  2 OV ?? ?? [?l ?l] 0596 2d99
l__l627
                               movlw    32                  ;  2 OV rS rS [?l ?l] 0597 3020
                               branchlo_nop l_serial_hw_write;  2 OV rS rS [?l ?l] 0598
                               call     l_serial_hw_write   ;  2 OV rS ?? [?l ??] 0598 2519
l__l626
;  203     b=b-zw*10;                              -- Singles
                               datalo_set v_zw              ;  2 OV ?? ?S [?? ??] 0599 1683
                               datahi_clr v_zw              ;  2 OV ?S rS [?? ??] 059a 1303
                               movf     v_zw,w              ;  2 OV rS rS [?? ??] 059b 0839
                               datalo_clr v__pic_multiplier ;  2 OV rS rs [?? ??] 059c 1283
                                                            ; W = v_zw
                               movwf    v__pic_multiplier   ;  2 OV rs rs [?? ??] 059d 00a0
                                                            ; W = v_zw
                               clrf     v__pic_multiplier+1 ;  2 OV rs rs [?? ??] 059e 01a1
                                                            ; W = v__pic_multiplier
                               movlw    10                  ;  2 OV rs rs [?? ??] 059f 300a
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  2 OV rs rs [?? ??] 05a0 00a2
                               clrf     v__pic_multiplicand+1;  2 OV rs rs [?? ??] 05a1 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  2 OV rs rs [?? ?l] 05a2 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  2 OV rs ?? [?l ??] 05a3 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  2 OV ?? ?s [?? ??] 05a4 1283
                               datahi_clr v__pic_mresult    ;  2 OV ?s rs [?? ??] 05a5 1303
                               movf     v__pic_mresult,w    ;  2 OV rs rs [?? ??] 05a6 0824
                               datalo_set v____temp_46      ;  2 OV rs rS [?? ??] 05a7 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_46        ;  2 OV rS rS [?? ??] 05a8 00bb
                                                            ; W = v__pic_mresult
                               movf     v____temp_46,w      ;  2 OV rS rS [?? ??] 05a9 083b
                                                            ; W = v____temp_46
                               subwf    v___b_1,f           ;  2 OV rS rS [?? ??] 05aa 02b6
                                                            ; W = v____temp_46
                               btfss    v__status, v__c     ;  2 OV rS rS [?? ??] 05ab 1c03
                                                            ; W = v____temp_46
                               decf     v___b_1+1,f         ;  2 OV rS rS [?? ??] 05ac 03b7
                                                            ; W = v____temp_46
;  204     serial_hw_write(b+0x30);
                               movf     v___b_1+1,w         ;  2 OV rS rS [?? ??] 05ad 0837
                                                            ; W = v____temp_46
                               movwf    v____temp_46+1      ;  2 OV rS rS [?? ??] 05ae 00bc
                                                            ; W = v___b_1
                               movlw    48                  ;  2 OV rS rS [?? ??] 05af 3030
                                                            ; W = v____temp_46
                               addwf    v___b_1,w           ;  2 OV rS rS [?? ??] 05b0 0736
                               movwf    v____temp_46        ;  2 OV rS rS [?? ??] 05b1 00bb
                               btfsc    v__status, v__c     ;  2 OV rS rS [?? ??] 05b2 1803
                                                            ; W = v____temp_46
                               incf     v____temp_46+1,f    ;  2 OV rS rS [?? ??] 05b3 0abc
                                                            ; W = v____temp_46
                               movf     v____temp_46,w      ;  2 OV rS rS [?? ??] 05b4 083b
                               branchlo_clr l_serial_hw_write;  2 OV rS rS [?? ?l] 05b5 118a
                                                            ; W = v____temp_46
                               goto     l_serial_hw_write   ;  2 OV rS rS [?l ?l] 05b6 2d19
                                                            ; W = v____temp_46
;  205 end procedure
l__l622
; main.jal
;   43 Serial_HW_init
                               branchlo_nop l_serial_hw_init;  0 OV ?? ?? [?l ?l] 05b7
                               call     l_serial_hw_init    ;  0 OV ?? ?? [?l ??] 05b7 250f
;   45 serial_hw_printf(hewo)
                               movlw    13                  ;  0 OV ?? ?? [?? ??] 05b8 300d
                               datalo_clr v__str_count      ;  0 OV ?? ?s [?? ??] 05b9 1283
                               datahi_clr v__str_count      ;  0 OV ?s rs [?? ??] 05ba 1303
                               movwf    v__str_count        ;  0 OV rs rs [?? ??] 05bb 00d5
                               clrf     v__str_count+1      ;  0 OV rs rs [?? ??] 05bc 01d6
                                                            ; W = v__str_count
                               movlw    l__data_hewo        ;  0 OV rs rs [?? ??] 05bd 305f
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV rs rs [?? ??] 05be 00db
                               movlw    HIGH l__data_hewo   ;  0 OV rs rs [?? ??] 05bf 3002
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV rs rs [?? ??] 05c0 3840
                               movwf    v___str_1+1         ;  0 OV rs rs [?? ??] 05c1 00dc
                               branchlo_clr l_serial_hw_printf;  0 OV rs rs [?? ?l] 05c2 118a
                                                            ; W = v___str_1
                               call     l_serial_hw_printf  ;  0 OV rs ?? [?l ??] 05c3 2525
                                                            ; W = v___str_1
;   46 serial_hw_printf(version)
                               movlw    7                   ;  0 OV ?? ?? [?? ??] 05c4 3007
                               datalo_clr v__str_count      ;  0 OV ?? ?s [?? ??] 05c5 1283
                               datahi_clr v__str_count      ;  0 OV ?s rs [?? ??] 05c6 1303
                               movwf    v__str_count        ;  0 OV rs rs [?? ??] 05c7 00d5
                               clrf     v__str_count+1      ;  0 OV rs rs [?? ??] 05c8 01d6
                                                            ; W = v__str_count
                               movlw    l__data_version     ;  0 OV rs rs [?? ??] 05c9 3088
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV rs rs [?? ??] 05ca 00db
                               movlw    HIGH l__data_version;  0 OV rs rs [?? ??] 05cb 3002
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV rs rs [?? ??] 05cc 3840
                               movwf    v___str_1+1         ;  0 OV rs rs [?? ??] 05cd 00dc
                               branchlo_clr l_serial_hw_printf;  0 OV rs rs [?? ?l] 05ce 118a
                                                            ; W = v___str_1
                               call     l_serial_hw_printf  ;  0 OV rs ?? [?l ??] 05cf 2525
                                                            ; W = v___str_1
;   49 var byte pwmValue	=	0
                               datalo_clr v_pwmvalue        ;  0 OV ?? ?s [?? ??] 05d0 1283
                               datahi_clr v_pwmvalue        ;  0 OV ?s rs [?? ??] 05d1 1303
                               clrf     v_pwmvalue          ;  0 OV rs rs [?? ??] 05d2 01b8
;   50 while pwmValue != 255 loop
l__l628
                               movlw    255                 ;  0 OV ?? ?? [?? ??] 05d3 30ff
                               datalo_clr v_pwmvalue        ;  0 OV ?? ?s [?? ??] 05d4 1283
                               datahi_clr v_pwmvalue        ;  0 OV ?s rs [?? ??] 05d5 1303
                               subwf    v_pwmvalue,w        ;  0 OV rs rs [?? ??] 05d6 0238
                               branchlo_set l__l930         ;  0 OV rs rs [?? ?L] 05d7 158a
                               btfsc    v__status, v__z     ;  0 OV rs rs [?L ?L] 05d8 1903
                               goto     l__l930             ;  0 OV rs rs [?L ?L] 05d9 2cf3
;   51 	pwm1_set_dutycycle(pwmValue)
                               movf     v_pwmvalue,w        ;  0 OV rs rs [?L ?L] 05da 0838
                               branchlo_clr l_pwm1_set_dutycycle;  0 OV rs rs [?L ?l] 05db 118a
                                                            ; W = v_pwmvalue
                               call     l_pwm1_set_dutycycle;  0 OV rs ?? [?l ??] 05dc 24ee
                                                            ; W = v_pwmvalue
;   52 	pwmValue = pwmValue + 1
                               datalo_clr v_pwmvalue        ;  0 OV ?? ?s [?? ??] 05dd 1283
                               datahi_clr v_pwmvalue        ;  0 OV ?s rs [?? ??] 05de 1303
                               incf     v_pwmvalue,f        ;  0 OV rs rs [?? ??] 05df 0ab8
;   53 	delay_1ms(10)
                               movlw    10                  ;  0 OV rs rs [?? ??] 05e0 300a
                               movwf    v___n_3             ;  0 OV rs rs [?? ??] 05e1 00d5
                               clrf     v___n_3+1           ;  0 OV rs rs [?? ??] 05e2 01d6
                                                            ; W = v___n_3
                               branchlo_clr l_delay_1ms     ;  0 OV rs rs [?? ?l] 05e3 118a
                                                            ; W = v___n_3
                               call     l_delay_1ms         ;  0 OV rs ?? [?l ??] 05e4 230d
                                                            ; W = v___n_3
;   54 end loop
                               branchlo_clr l__l628         ;  0 OV ?? ?? [?? ?l] 05e5 118a
                               goto     l__l628             ;  0 OV ?? ?? [?l ?l] 05e6 2dd3
; glcd_ks0108.jal
;   43 procedure _ks0108_write(byte in side, byte in data) is
l__ks0108_write
                               datalo_set v___side_1        ;  3 OV r? rS [?l ?l] 05e7 1683
                               movwf    v___side_1          ;  3 OV rS rS [?l ?l] 05e8 00ba
;   44    if side == 1 then          -- Choose which side to write to
                               movlw    1                   ;  3 OV rS rS [?l ?l] 05e9 3001
                                                            ; W = v___side_1
                               subwf    v___side_1,w        ;  3 OV rS rS [?l ?l] 05ea 023a
                               branchlo_nop l__l634         ;  3 OV rS rS [?l ?l] 05eb
                               btfss    v__status, v__z     ;  3 OV rS rS [?l ?l] 05eb 1d03
                               goto     l__l634             ;  3 OV rS rS [?l ?l] 05ec 2df2
;   45       GLCD_CS2 = high
                               datalo_clr v__portc_shadow ; x91;  3 OV rS rs [?l ?l] 05ed 1283
                               bsf      v__portc_shadow, 0 ; x91;  3 OV rs rs [?l ?l] 05ee 1431
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  3 OV rs rs [?l ?l] 05ef 0831
                               movwf    v_portc             ;  3 OV rs rs [?l ?l] 05f0 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;   45       GLCD_CS2 = high
; 16f886.jal
;  440    _PORTC_flush()
; glcd_ks0108.jal
;   45       GLCD_CS2 = high
;   46    else
                               branchlo_nop l__l633         ;  3 OV rs rs [?l ?l] 05f1
                               goto     l__l633             ;  3 OV rs rs [?l ?l] 05f1 2df6
l__l634
;   47       GLCD_CS1 = high
                               datalo_clr v__portc_shadow ; x92;  3 OV rS rs [?l ?l] 05f2 1283
                               bsf      v__portc_shadow, 1 ; x92;  3 OV rs rs [?l ?l] 05f3 14b1
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  3 OV rs rs [?l ?l] 05f4 0831
                               movwf    v_portc             ;  3 OV rs rs [?l ?l] 05f5 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;   47       GLCD_CS1 = high
; 16f886.jal
;  430    _PORTC_flush()
; glcd_ks0108.jal
;   47       GLCD_CS1 = high
;   48    end if
l__l633
;   49    GLCD_RW = low        -- Set for writing
                               bcf      v__portc_shadow, 3 ; x93;  3 OV rs rs [?l ?l] 05f6 11b1
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  3 OV rs rs [?l ?l] 05f7 0831
                               movwf    v_portc             ;  3 OV rs rs [?l ?l] 05f8 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;   49    GLCD_RW = low        -- Set for writing
; 16f886.jal
;  410    _PORTC_flush()
; glcd_ks0108.jal
;   49    GLCD_RW = low        -- Set for writing
;   50    GLCD_DATAPRT = data     -- Put the data on the port
; 16f886.jal
;  225    _PORTB_shadow = x
                               datalo_set v___data_14       ;  3 OV rs rS [?l ?l] 05f9 1683
                               movf     v___data_14,w       ;  3 OV rS rS [?l ?l] 05fa 083b
                               datalo_clr v__portb_shadow   ;  3 OV rS rs [?l ?l] 05fb 1283
                                                            ; W = v___data_14
                               movwf    v__portb_shadow     ;  3 OV rs rs [?l ?l] 05fc 00b0
                                                            ; W = v___data_14
; glcd_ks0108.jal
;   50    GLCD_DATAPRT = data     -- Put the data on the port
; 16f886.jal
;  221    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  3 OV rs rs [?l ?l] 05fd 0830
                                                            ; W = v__portb_shadow
                               movwf    v_portb             ;  3 OV rs rs [?l ?l] 05fe 0086
                                                            ; W = v__portb_shadow
; glcd_ks0108.jal
;   50    GLCD_DATAPRT = data     -- Put the data on the port
; 16f886.jal
;  226    _PORTB_flush()
; glcd_ks0108.jal
;   50    GLCD_DATAPRT = data     -- Put the data on the port
;   51    GLCD_DATAPRT_DIR = all_output
                               datalo_set v_portb_direction ;  3 OV rs rS [?l ?l] 05ff 1683
                               clrf     v_portb_direction   ;  3 OV rS rS [?l ?l] 0600 0186
;   53    asm nop asm nop      -- delay_cycles(1)
                               nop                          ;  3 -V rS rS [?l ?l] 0601 0000
                               nop                          ;  3 -V rS rS [?l ?l] 0602 0000
;   54    GLCD_E = high        -- Pulse the enable pin
                               datalo_clr v__porta_shadow ; x94;  3 OV rS rs [?l ?l] 0603 1283
                               bsf      v__porta_shadow, 5 ; x94;  3 OV rs rs [?l ?l] 0604 16af
; 16f886.jal
;  101    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w   ;  3 OV rs rs [?l ?l] 0605 082f
                               movwf    v_porta             ;  3 OV rs rs [?l ?l] 0606 0085
                                                            ; W = v__porta_shadow
; glcd_ks0108.jal
;   54    GLCD_E = high        -- Pulse the enable pin
; 16f886.jal
;  157    _PORTA_flush()
; glcd_ks0108.jal
;   54    GLCD_E = high        -- Pulse the enable pin
;   55    delay_2us()
; delay.jal
;   34   _usec_delay(2)
                               nop                          ;  3 -V rs rs [?l ?l] 0607 0000
                               nop                          ;  3 -V rs rs [?l ?l] 0608 0000
                               nop                          ;  3 -V rs rs [?l ?l] 0609 0000
                               nop                          ;  3 -V rs rs [?l ?l] 060a 0000
                               nop                          ;  3 -V rs rs [?l ?l] 060b 0000
                               nop                          ;  3 -V rs rs [?l ?l] 060c 0000
                               nop                          ;  3 -V rs rs [?l ?l] 060d 0000
                               nop                          ;  3 -V rs rs [?l ?l] 060e 0000
                               nop                          ;  3 -V rs rs [?l ?l] 060f 0000
                               nop                          ;  3 -V rs rs [?l ?l] 0610 0000
; glcd_ks0108.jal
;   55    delay_2us()
;   57    GLCD_E = low
                               bcf      v__porta_shadow, 5 ; x95;  3 OV rs rs [?l ?l] 0611 12af
; 16f886.jal
;  101    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w   ;  3 OV rs rs [?l ?l] 0612 082f
                               movwf    v_porta             ;  3 OV rs rs [?l ?l] 0613 0085
                                                            ; W = v__porta_shadow
; glcd_ks0108.jal
;   57    GLCD_E = low
; 16f886.jal
;  157    _PORTA_flush()
; glcd_ks0108.jal
;   57    GLCD_E = low
;   58    GLCD_CS1 = low       -- Reset the chip select lines
                               bcf      v__portc_shadow, 1 ; x96;  3 OV rs rs [?l ?l] 0614 10b1
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  3 OV rs rs [?l ?l] 0615 0831
                               movwf    v_portc             ;  3 OV rs rs [?l ?l] 0616 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;   58    GLCD_CS1 = low       -- Reset the chip select lines
; 16f886.jal
;  430    _PORTC_flush()
; glcd_ks0108.jal
;   58    GLCD_CS1 = low       -- Reset the chip select lines
;   59    GLCD_CS2 = low
                               bcf      v__portc_shadow, 0 ; x97;  3 OV rs rs [?l ?l] 0617 1031
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  3 OV rs rs [?l ?l] 0618 0831
                               movwf    v_portc             ;  3 OV rs rs [?l ?l] 0619 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;   59    GLCD_CS2 = low
; 16f886.jal
;  440    _PORTC_flush()
; glcd_ks0108.jal
;   59    GLCD_CS2 = low
;   60    delay_2us()
; delay.jal
;   34   _usec_delay(2)
                               nop                          ;  3 -V rs rs [?l ?l] 061a 0000
                               nop                          ;  3 -V rs rs [?l ?l] 061b 0000
                               nop                          ;  3 -V rs rs [?l ?l] 061c 0000
                               nop                          ;  3 -V rs rs [?l ?l] 061d 0000
                               nop                          ;  3 -V rs rs [?l ?l] 061e 0000
                               nop                          ;  3 -V rs rs [?l ?l] 061f 0000
                               nop                          ;  3 -V rs rs [?l ?l] 0620 0000
                               nop                          ;  3 -V rs rs [?l ?l] 0621 0000
                               nop                          ;  3 -V rs rs [?l ?l] 0622 0000
                               nop                          ;  3 -V rs rs [?l ?l] 0623 0000
; glcd_ks0108.jal
;   60    delay_2us()
;   62 end procedure
                               return                       ;  3 OV rs rs [?l ?l] 0624 0008
;   69 function _ks0108_read(byte in side) return byte  is
l__ks0108_read
                               datalo_set v___side_3        ;  2 OV r? rS [?l ?l] 0625 1683
                               movwf    v___side_3          ;  2 OV rS rS [?l ?l] 0626 00b3
;   71    GLCD_DATAPRT_DIR = all_input           -- Set port d to input
                               movlw    255                 ;  2 OV rS rS [?l ?l] 0627 30ff
                                                            ; W = v___side_3
                               movwf    v_portb_direction   ;  2 OV rS rS [?l ?l] 0628 0086
;   73    if side == 1 then     -- Choose which side to write to
                               movlw    1                   ;  2 OV rS rS [?l ?l] 0629 3001
                               subwf    v___side_3,w        ;  2 OV rS rS [?l ?l] 062a 0233
                               branchlo_nop l__l656         ;  2 OV rS rS [?l ?l] 062b
                               btfss    v__status, v__z     ;  2 OV rS rS [?l ?l] 062b 1d03
                               goto     l__l656             ;  2 OV rS rS [?l ?l] 062c 2e32
;   74       GLCD_CS2 = high
                               datalo_clr v__portc_shadow ; x98;  2 OV rS rs [?l ?l] 062d 1283
                                                            ; W = v___data_15
                               bsf      v__portc_shadow, 0 ; x98;  2 OV rs rs [?l ?l] 062e 1431
                                                            ; W = v___data_15
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  2 OV rs rs [?l ?l] 062f 0831
                                                            ; W = v___data_15
                               movwf    v_portc             ;  2 OV rs rs [?l ?l] 0630 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;   74       GLCD_CS2 = high
; 16f886.jal
;  440    _PORTC_flush()
; glcd_ks0108.jal
;   74       GLCD_CS2 = high
;   75    else
                               branchlo_nop l__l655         ;  2 OV rs rs [?l ?l] 0631
                               goto     l__l655             ;  2 OV rs rs [?l ?l] 0631 2e36
l__l656
;   76       GLCD_CS1 = high
                               datalo_clr v__portc_shadow ; x99;  2 OV rS rs [?l ?l] 0632 1283
                               bsf      v__portc_shadow, 1 ; x99;  2 OV rs rs [?l ?l] 0633 14b1
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  2 OV rs rs [?l ?l] 0634 0831
                               movwf    v_portc             ;  2 OV rs rs [?l ?l] 0635 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;   76       GLCD_CS1 = high
; 16f886.jal
;  430    _PORTC_flush()
; glcd_ks0108.jal
;   76       GLCD_CS1 = high
;   77    end if
l__l655
;   78    GLCD_RW = high       -- Set for reading
                               bsf      v__portc_shadow, 3 ; x100;  2 OV rs rs [?l ?l] 0636 15b1
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  2 OV rs rs [?l ?l] 0637 0831
                               movwf    v_portc             ;  2 OV rs rs [?l ?l] 0638 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;   78    GLCD_RW = high       -- Set for reading
; 16f886.jal
;  410    _PORTC_flush()
; glcd_ks0108.jal
;   78    GLCD_RW = high       -- Set for reading
;   80    asm nop  asm nop     --  delay_cycles(1)
                               nop                          ;  2 -V rs rs [?l ?l] 0639 0000
                               nop                          ;  2 -V rs rs [?l ?l] 063a 0000
;   81    GLCD_E = high        -- Pulse the enable pin
                               bsf      v__porta_shadow, 5 ; x101;  2 OV rs rs [?l ?l] 063b 16af
; 16f886.jal
;  101    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w   ;  2 OV rs rs [?l ?l] 063c 082f
                               movwf    v_porta             ;  2 OV rs rs [?l ?l] 063d 0085
                                                            ; W = v__porta_shadow
; glcd_ks0108.jal
;   81    GLCD_E = high        -- Pulse the enable pin
; 16f886.jal
;  157    _PORTA_flush()
; glcd_ks0108.jal
;   81    GLCD_E = high        -- Pulse the enable pin
;   83    delay_2us()
; delay.jal
;   34   _usec_delay(2)
                               nop                          ;  2 -V rs rs [?l ?l] 063e 0000
                               nop                          ;  2 -V rs rs [?l ?l] 063f 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0640 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0641 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0642 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0643 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0644 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0645 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0646 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0647 0000
; glcd_ks0108.jal
;   83    delay_2us()
;   84    data = GLCD_DATAPRT     -- Get the data from the display's output register
                               movf     v_portb,w           ;  2 OV rs rs [?l ?l] 0648 0806
                               datalo_set v___data_15       ;  2 OV rs rS [?l ?l] 0649 1683
                               movwf    v___data_15         ;  2 OV rS rS [?l ?l] 064a 00b4
;   85    GLCD_E = low
                               datalo_clr v__porta_shadow ; x102;  2 OV rS rs [?l ?l] 064b 1283
                                                            ; W = v___data_15
                               bcf      v__porta_shadow, 5 ; x102;  2 OV rs rs [?l ?l] 064c 12af
                                                            ; W = v___data_15
; 16f886.jal
;  101    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w   ;  2 OV rs rs [?l ?l] 064d 082f
                                                            ; W = v___data_15
                               movwf    v_porta             ;  2 OV rs rs [?l ?l] 064e 0085
                                                            ; W = v__porta_shadow
; glcd_ks0108.jal
;   85    GLCD_E = low
; 16f886.jal
;  157    _PORTA_flush()
; glcd_ks0108.jal
;   85    GLCD_E = low
;   87    GLCD_CS1 = low       -- Reset the chip select lines
                               bcf      v__portc_shadow, 1 ; x103;  2 OV rs rs [?l ?l] 064f 10b1
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  2 OV rs rs [?l ?l] 0650 0831
                               movwf    v_portc             ;  2 OV rs rs [?l ?l] 0651 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;   87    GLCD_CS1 = low       -- Reset the chip select lines
; 16f886.jal
;  430    _PORTC_flush()
; glcd_ks0108.jal
;   87    GLCD_CS1 = low       -- Reset the chip select lines
;   88    GLCD_CS2 = low
                               bcf      v__portc_shadow, 0 ; x104;  2 OV rs rs [?l ?l] 0652 1031
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  2 OV rs rs [?l ?l] 0653 0831
                               movwf    v_portc             ;  2 OV rs rs [?l ?l] 0654 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;   88    GLCD_CS2 = low
; 16f886.jal
;  440    _PORTC_flush()
; glcd_ks0108.jal
;   88    GLCD_CS2 = low
;   89    delay_2us()
; delay.jal
;   34   _usec_delay(2)
                               nop                          ;  2 -V rs rs [?l ?l] 0655 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0656 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0657 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0658 0000
                               nop                          ;  2 -V rs rs [?l ?l] 0659 0000
                               nop                          ;  2 -V rs rs [?l ?l] 065a 0000
                               nop                          ;  2 -V rs rs [?l ?l] 065b 0000
                               nop                          ;  2 -V rs rs [?l ?l] 065c 0000
                               nop                          ;  2 -V rs rs [?l ?l] 065d 0000
                               nop                          ;  2 -V rs rs [?l ?l] 065e 0000
; glcd_ks0108.jal
;   89    delay_2us()
;   91    return data          -- Return the read data
                               datalo_set v___data_15       ;  2 OV rs rS [?l ?l] 065f 1683
                               movf     v___data_15,w       ;  2 OV rS rS [?l ?l] 0660 0834
;   92 end function
                               return                       ;  2 OV rS rS [?l ?l] 0661 0008
                                                            ; W = v___data_15
;   98 procedure lcd_on() is
l_lcd_on
;   99     _ks0108_write(KS0108_LEFT,  KS0108_CMD_ON)
                               movlw    63                  ;  1 OV ?? ?? [?l ?l] 0662 303f
                               datalo_set v___data_14       ;  1 OV ?? ?S [?l ?l] 0663 1683
                               datahi_clr v___data_14       ;  1 OV ?S rS [?l ?l] 0664 1303
                               movwf    v___data_14         ;  1 OV rS rS [?l ?l] 0665 00bb
                               movlw    0                   ;  1 OV rS rS [?l ?l] 0666 3000
                                                            ; W = v___data_14
                               branchlo_nop l__ks0108_write ;  1 OV rS rS [?l ?l] 0667
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0667 25e7
;  100     _ks0108_write(KS0108_RIGHT, KS0108_CMD_ON)
                               movlw    63                  ;  1 OV ?? ?? [?? ??] 0668 303f
                               datalo_set v___data_14       ;  1 OV ?? ?S [?? ??] 0669 1683
                               datahi_clr v___data_14       ;  1 OV ?S rS [?? ??] 066a 1303
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 066b 00bb
                               movlw    1                   ;  1 OV rS rS [?? ??] 066c 3001
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 066d 118a
                               goto     l__ks0108_write     ;  1 OV rS rS [?l ?l] 066e 2de7
;  101 end procedure
;  136 procedure _ks0108_inst() is     
l__ks0108_inst
;  137    GLCD_DI = low
                               datalo_clr v__portc_shadow ; x105;  3 OV ?? ?s [?l ?l] 066f 1283
                               datahi_clr v__portc_shadow ; x105;  3 OV ?s rs [?l ?l] 0670 1303
                               bcf      v__portc_shadow, 5 ; x105;  3 OV rs rs [?l ?l] 0671 12b1
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  3 OV rs rs [?l ?l] 0672 0831
                               movwf    v_portc             ;  3 OV rs rs [?l ?l] 0673 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;  137    GLCD_DI = low
; 16f886.jal
;  390    _PORTC_flush()
; glcd_ks0108.jal
;  137    GLCD_DI = low
;  138 end procedure
                               return                       ;  3 OV rs rs [?l ?l] 0674 0008
;  144 procedure  _ks0108_data() is
l__ks0108_data
;  145    GLCD_DI = high
                               datalo_clr v__portc_shadow ; x106;  3 OV ?? ?s [?l ?l] 0675 1283
                               datahi_clr v__portc_shadow ; x106;  3 OV ?s rs [?l ?l] 0676 1303
                               bsf      v__portc_shadow, 5 ; x106;  3 OV rs rs [?l ?l] 0677 16b1
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  3 OV rs rs [?l ?l] 0678 0831
                               movwf    v_portc             ;  3 OV rs rs [?l ?l] 0679 0087
                                                            ; W = v__portc_shadow
; glcd_ks0108.jal
;  145    GLCD_DI = high
; 16f886.jal
;  390    _PORTC_flush()
; glcd_ks0108.jal
;  145    GLCD_DI = high
;  146 end procedure
                               return                       ;  3 OV rs rs [?l ?l] 067a 0008
;  194 procedure ks0108_write_byte(byte in x, byte in y, byte in veri) is
l_ks0108_write_byte
                               movwf    v___x_110           ;  2 OV rS rS [?l ?l] 067b 00b3
                                                            ; W = v___x_123
;  195    var byte side = KS0108_LEFT   -- Stores which chip to use on the LCD
                               clrf     v___side_9          ;  2 OV rS rS [?l ?l] 067c 01b6
                                                            ; W = v___x_110
;  197    if x > 63 then                -- Check for first or second display area
                               movlw    63                  ;  2 OV rS rS [?l ?l] 067d 303f
                                                            ; W = v___x_110
                               subwf    v___x_110,w         ;  2 OV rS rS [?l ?l] 067e 0233
                               branchlo_nop l__l701         ;  2 OV rS rS [?l ?l] 067f
                               btfsc    v__status, v__z     ;  2 OV rS rS [?l ?l] 067f 1903
                               goto     l__l701             ;  2 OV rS rS [?l ?l] 0680 2e87
                               branchlo_nop l__l701         ;  2 OV rS rS [?l ?l] 0681
                               btfss    v__status, v__c     ;  2 OV rS rS [?l ?l] 0681 1c03
                               goto     l__l701             ;  2 OV rS rS [?l ?l] 0682 2e87
;  198       x = x - 64
                               movlw    64                  ;  2 OV rS rS [?l ?l] 0683 3040
                               subwf    v___x_110,f         ;  2 OV rS rS [?l ?l] 0684 02b3
;  199       side = KS0108_RIGHT
                               movlw    1                   ;  2 OV rS rS [?l ?l] 0685 3001
                               movwf    v___side_9          ;  2 OV rS rS [?l ?l] 0686 00b6
;  200    end if
l__l701
;  203     _ks0108_inst()                -- Set for instruction
                               branchlo_nop l__ks0108_inst  ;  2 OV rS rS [?l ?l] 0687
                               call     l__ks0108_inst      ;  2 OV rS ?? [?l ??] 0687 266f
;  204     _ks0108_column(side,x)        -- Set the horizontal address
                               movlw    64                  ;  2 OV ?? ?? [?? ??] 0688 3040
                               datalo_set v___x_110         ;  2 OV ?? ?S [?? ??] 0689 1683
                               datahi_clr v___x_110         ;  2 OV ?S rS [?? ??] 068a 1303
                               iorwf    v___x_110,w         ;  2 OV rS rS [?? ??] 068b 0433
                               movwf    v____temp_55        ;  2 OV rS rS [?? ??] 068c 00b9
                               movf     v____temp_55,w      ;  2 OV rS rS [?? ??] 068d 0839
                                                            ; W = v____temp_55
                               movwf    v___data_14         ;  2 OV rS rS [?? ??] 068e 00bb
                                                            ; W = v____temp_55
                               movf     v___side_9,w        ;  2 OV rS rS [?? ??] 068f 0836
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  2 OV rS rS [?? ?l] 0690 118a
                                                            ; W = v___side_9
                               call     l__ks0108_write     ;  2 OV rS ?? [?l ??] 0691 25e7
                                                            ; W = v___side_9
                               bcf      v__status, v__c     ;  2 OV ?? ?? [?? ??] 0692 1003
                               datalo_set v___y_3           ;  2 OV ?? ?S [?? ??] 0693 1683
                               datahi_clr v___y_3           ;  2 OV ?S rS [?? ??] 0694 1303
                               rrf      v___y_3,w           ;  2 OV rS rS [?? ??] 0695 0c34
                               movwf    v__rparam1          ;  2 OV rS rS [?? ??] 0696 00b8
                               bcf      v__status, v__c     ;  2 OV rS rS [?? ??] 0697 1003
                                                            ; W = v__rparam1
                               rrf      v__rparam1,f        ;  2 OV rS rS [?? ??] 0698 0cb8
                                                            ; W = v__rparam1
                               bcf      v__status, v__c     ;  2 OV rS rS [?? ??] 0699 1003
                               rrf      v__rparam1,f        ;  2 OV rS rS [?? ??] 069a 0cb8
                               movlw    184                 ;  2 OV rS rS [?? ??] 069b 30b8
                               iorwf    v__rparam1,w        ;  2 OV rS rS [?? ??] 069c 0438
                               movwf    v____temp_56        ;  2 OV rS rS [?? ??] 069d 00b9
                               movf     v____temp_56,w      ;  2 OV rS rS [?? ??] 069e 0839
                                                            ; W = v____temp_56
                               movwf    v___data_14         ;  2 OV rS rS [?? ??] 069f 00bb
                                                            ; W = v____temp_56
                               movf     v___side_9,w        ;  2 OV rS rS [?? ??] 06a0 0836
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  2 OV rS rS [?? ?l] 06a1 118a
                                                            ; W = v___side_9
                               call     l__ks0108_write     ;  2 OV rS ?? [?l ??] 06a2 25e7
                                                            ; W = v___side_9
                               branchlo_clr l__ks0108_data  ;  2 OV ?? ?? [?? ?l] 06a3 118a
                               call     l__ks0108_data      ;  2 OV ?? ?? [?l ??] 06a4 2675
                               datalo_set v___veri_1        ;  2 OV ?? ?S [?? ??] 06a5 1683
                               datahi_clr v___veri_1        ;  2 OV ?S rS [?? ??] 06a6 1303
                               movf     v___veri_1,w        ;  2 OV rS rS [?? ??] 06a7 0835
                               movwf    v___data_14         ;  2 OV rS rS [?? ??] 06a8 00bb
                                                            ; W = v___veri_1
                               movf     v___side_9,w        ;  2 OV rS rS [?? ??] 06a9 0836
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  2 OV rS rS [?? ?l] 06aa 118a
                                                            ; W = v___side_9
                               goto     l__ks0108_write     ;  2 OV rS rS [?l ?l] 06ab 2de7
                                                            ; W = v___side_9
l_lcd_fill
                               datalo_clr v___data_19       ;  1 OV ?? ?s [?l ?l] 06ac 1283
                               datahi_clr v___data_19       ;  1 OV ?s rs [?l ?l] 06ad 1303
                               movwf    v___data_19         ;  1 OV rs rs [?l ?l] 06ae 00d5
                               clrf     v_i                 ;  1 OV rs rs [?l ?l] 06af 01d7
                                                            ; W = v___data_19
                               clrf     v__floop5           ;  1 OV rs rs [?l ?l] 06b0 01db
                                                            ; W = v___data_19
l__l712
                               branchlo_nop l__ks0108_inst  ;  1 OV rs rs [?l ?l] 06b1
                               call     l__ks0108_inst      ;  1 OV rs ?? [?l ??] 06b1 266f
                               datalo_clr v___side_11       ;  1 OV ?? ?s [?? ??] 06b2 1283
                               datahi_clr v___side_11       ;  1 OV ?s rs [?? ??] 06b3 1303
                               clrf     v___side_11         ;  1 OV rs rs [?? ??] 06b4 01de
                               movlw    184                 ;  1 OV rs rs [?? ??] 06b5 30b8
                               iorwf    v_i,w               ;  1 OV rs rs [?? ??] 06b6 0457
                               movwf    v____temp_60        ;  1 OV rs rs [?? ??] 06b7 00e2
                               movf     v____temp_60,w      ;  1 OV rs rs [?? ??] 06b8 0862
                                                            ; W = v____temp_60
                               datalo_set v___data_14       ;  1 OV rs rS [?? ??] 06b9 1683
                                                            ; W = v____temp_60
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 06ba 00bb
                                                            ; W = v____temp_60
                               datalo_clr v___side_11       ;  1 OV rS rs [?? ??] 06bb 1283
                                                            ; W = v___data_14
                               movf     v___side_11,w       ;  1 OV rs rs [?? ??] 06bc 085e
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rs rs [?? ?l] 06bd 118a
                                                            ; W = v___side_11
                               call     l__ks0108_write     ;  1 OV rs ?? [?l ??] 06be 25e7
                                                            ; W = v___side_11
                               movlw    1                   ;  1 OV ?? ?? [?? ??] 06bf 3001
                               datalo_clr v___side_12       ;  1 OV ?? ?s [?? ??] 06c0 1283
                               datahi_clr v___side_12       ;  1 OV ?s rs [?? ??] 06c1 1303
                               movwf    v___side_12         ;  1 OV rs rs [?? ??] 06c2 00de
                               movlw    184                 ;  1 OV rs rs [?? ??] 06c3 30b8
                                                            ; W = v___side_12
                               iorwf    v_i,w               ;  1 OV rs rs [?? ??] 06c4 0457
                               movwf    v____temp_61        ;  1 OV rs rs [?? ??] 06c5 00e2
                               movf     v____temp_61,w      ;  1 OV rs rs [?? ??] 06c6 0862
                                                            ; W = v____temp_61
                               datalo_set v___data_14       ;  1 OV rs rS [?? ??] 06c7 1683
                                                            ; W = v____temp_61
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 06c8 00bb
                                                            ; W = v____temp_61
                               datalo_clr v___side_12       ;  1 OV rS rs [?? ??] 06c9 1283
                                                            ; W = v___data_14
                               movf     v___side_12,w       ;  1 OV rs rs [?? ??] 06ca 085e
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rs rs [?? ?l] 06cb 118a
                                                            ; W = v___side_12
                               call     l__ks0108_write     ;  1 OV rs ?? [?l ??] 06cc 25e7
                                                            ; W = v___side_12
                               datalo_clr v___side_13       ;  1 OV ?? ?s [?? ??] 06cd 1283
                               datahi_clr v___side_13       ;  1 OV ?s rs [?? ??] 06ce 1303
                               clrf     v___side_13         ;  1 OV rs rs [?? ??] 06cf 01de
                               clrf     v___column_2        ;  1 OV rs rs [?? ??] 06d0 01e2
                               movlw    64                  ;  1 OV rs rs [?? ??] 06d1 3040
                               iorwf    v___column_2,w      ;  1 OV rs rs [?? ??] 06d2 0462
                               movwf    v____temp_62        ;  1 OV rs rs [?? ??] 06d3 00e4
                               movf     v____temp_62,w      ;  1 OV rs rs [?? ??] 06d4 0864
                                                            ; W = v____temp_62
                               datalo_set v___data_14       ;  1 OV rs rS [?? ??] 06d5 1683
                                                            ; W = v____temp_62
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 06d6 00bb
                                                            ; W = v____temp_62
                               datalo_clr v___side_13       ;  1 OV rS rs [?? ??] 06d7 1283
                                                            ; W = v___data_14
                               movf     v___side_13,w       ;  1 OV rs rs [?? ??] 06d8 085e
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rs rs [?? ?l] 06d9 118a
                                                            ; W = v___side_13
                               call     l__ks0108_write     ;  1 OV rs ?? [?l ??] 06da 25e7
                                                            ; W = v___side_13
                               movlw    1                   ;  1 OV ?? ?? [?? ??] 06db 3001
                               datalo_clr v___side_14       ;  1 OV ?? ?s [?? ??] 06dc 1283
                               datahi_clr v___side_14       ;  1 OV ?s rs [?? ??] 06dd 1303
                               movwf    v___side_14         ;  1 OV rs rs [?? ??] 06de 00de
                               clrf     v___column_3        ;  1 OV rs rs [?? ??] 06df 01e2
                                                            ; W = v___side_14
                               movlw    64                  ;  1 OV rs rs [?? ??] 06e0 3040
                                                            ; W = v___side_14
                               iorwf    v___column_3,w      ;  1 OV rs rs [?? ??] 06e1 0462
                               movwf    v____temp_63        ;  1 OV rs rs [?? ??] 06e2 00e4
                               movf     v____temp_63,w      ;  1 OV rs rs [?? ??] 06e3 0864
                                                            ; W = v____temp_63
                               datalo_set v___data_14       ;  1 OV rs rS [?? ??] 06e4 1683
                                                            ; W = v____temp_63
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 06e5 00bb
                                                            ; W = v____temp_63
                               datalo_clr v___side_14       ;  1 OV rS rs [?? ??] 06e6 1283
                                                            ; W = v___data_14
                               movf     v___side_14,w       ;  1 OV rs rs [?? ??] 06e7 085e
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rs rs [?? ?l] 06e8 118a
                                                            ; W = v___side_14
                               call     l__ks0108_write     ;  1 OV rs ?? [?l ??] 06e9 25e7
                                                            ; W = v___side_14
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 06ea 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 06eb 2675
                               datalo_clr v__floop6         ;  1 OV ?? ?s [?? ??] 06ec 1283
                               datahi_clr v__floop6         ;  1 OV ?s rs [?? ??] 06ed 1303
                               clrf     v__floop6           ;  1 OV rs rs [?? ??] 06ee 01dd
l__l719
                               movf     v___data_19,w       ;  1 OV rs rs [?? ??] 06ef 0855
                               datalo_set v___data_14       ;  1 OV rs rS [?? ??] 06f0 1683
                                                            ; W = v___data_19
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 06f1 00bb
                                                            ; W = v___data_19
                               movlw    0                   ;  1 OV rS rS [?? ??] 06f2 3000
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 06f3 118a
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 06f4 25e7
                               datalo_clr v___data_19       ;  1 OV ?? ?s [?? ??] 06f5 1283
                               datahi_clr v___data_19       ;  1 OV ?s rs [?? ??] 06f6 1303
                               movf     v___data_19,w       ;  1 OV rs rs [?? ??] 06f7 0855
                               datalo_set v___data_14       ;  1 OV rs rS [?? ??] 06f8 1683
                                                            ; W = v___data_19
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 06f9 00bb
                                                            ; W = v___data_19
                               movlw    1                   ;  1 OV rS rS [?? ??] 06fa 3001
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 06fb 118a
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 06fc 25e7
                               datalo_clr v__floop6         ;  1 OV ?? ?s [?? ??] 06fd 1283
                               datahi_clr v__floop6         ;  1 OV ?s rs [?? ??] 06fe 1303
                               incf     v__floop6,f         ;  1 OV rs rs [?? ??] 06ff 0add
                               movlw    64                  ;  1 OV rs rs [?? ??] 0700 3040
                               subwf    v__floop6,w         ;  1 OV rs rs [?? ??] 0701 025d
                               branchlo_clr l__l719         ;  1 OV rs rs [?? ?l] 0702 118a
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0703 1d03
                               goto     l__l719             ;  1 OV rs rs [?l ?l] 0704 2eef
                               incf     v_i,f               ;  1 OV rs rs [?l ?l] 0705 0ad7
                               incf     v__floop5,f         ;  1 OV rs rs [?l ?l] 0706 0adb
                               movlw    8                   ;  1 OV rs rs [?l ?l] 0707 3008
                               subwf    v__floop5,w         ;  1 OV rs rs [?l ?l] 0708 025b
                               branchlo_nop l__l712         ;  1 OV rs rs [?l ?l] 0709
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0709 1d03
                               goto     l__l712             ;  1 OV rs rs [?l ?l] 070a 2eb1
                               return                       ;  1 OV rs rs [?l ?l] 070b 0008
; glcd_common.jal
;   25 procedure lcd_line(byte in x0, byte in y0, byte in x1, byte in y1, bit in onoff) is
l_lcd_line
                               movwf    v___x0_1            ;  1 OV rs rs [?l ?l] 070c 00d5
;   28    xi = x0
                               movf     v___x0_1,w          ;  1 OV rs rs [?l ?l] 070d 0855
                                                            ; W = v___x0_1
                               movwf    v_xi                ;  1 OV rs rs [?l ?l] 070e 00de
                                                            ; W = v___x0_1
;   29    yi = y0
                               movf     v___y0_1,w          ;  1 OV rs rs [?l ?l] 070f 0857
                                                            ; W = v_xi
                               movwf    v_yi                ;  1 OV rs rs [?l ?l] 0710 00e2
                                                            ; W = v___y0_1
;   30    if x1 >= x0  then  xfark = x1 - x0 else  xfark = x0 - x1 end if
                               movf     v___x1_1,w          ;  1 OV rs rs [?l ?l] 0711 085b
                                                            ; W = v_yi
                               subwf    v___x0_1,w          ;  1 OV rs rs [?l ?l] 0712 0255
                                                            ; W = v___x1_1
                               branchlo_nop l__l1100        ;  1 OV rs rs [?l ?l] 0713
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 0713 1903
                               goto     l__l1100            ;  1 OV rs rs [?l ?l] 0714 2f17
                               branchlo_nop l__l774         ;  1 OV rs rs [?l ?l] 0715
                                                            ; W = v_yfark
                               btfsc    v__status, v__c     ;  1 OV rs rs [?l ?l] 0715 1803
                                                            ; W = v_yfark
                               goto     l__l774             ;  1 OV rs rs [?l ?l] 0716 2f1b
                                                            ; W = v_yfark
l__l1100
                               movf     v___x0_1,w          ;  1 OV rs rs [?l ?l] 0717 0855
                               subwf    v___x1_1,w          ;  1 OV rs rs [?l ?l] 0718 025b
                                                            ; W = v___x0_1
                               movwf    v_xfark             ;  1 OV rs rs [?l ?l] 0719 00e4
                               branchlo_nop l__l773         ;  1 OV rs rs [?l ?l] 071a
                                                            ; W = v_xfark
                               goto     l__l773             ;  1 OV rs rs [?l ?l] 071a 2f1e
                                                            ; W = v_xfark
l__l774
                               movf     v___x1_1,w          ;  1 OV rs rs [?l ?l] 071b 085b
                                                            ; W = v_yfark
                               subwf    v___x0_1,w          ;  1 OV rs rs [?l ?l] 071c 0255
                                                            ; W = v___x1_1
                               movwf    v_xfark             ;  1 OV rs rs [?l ?l] 071d 00e4
l__l773
;   31    if y1 >= y0  then  yfark = y1 - y0 else  yfark = y0 - y1 end if
                               movf     v___y1_1,w          ;  1 OV rs rs [?l ?l] 071e 085d
                                                            ; W = v_xfark
                               subwf    v___y0_1,w          ;  1 OV rs rs [?l ?l] 071f 0257
                                                            ; W = v___y1_1
                               branchlo_nop l__l1102        ;  1 OV rs rs [?l ?l] 0720
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 0720 1903
                               goto     l__l1102            ;  1 OV rs rs [?l ?l] 0721 2f24
                               branchlo_nop l__l776         ;  1 OV rs rs [?l ?l] 0722
                                                            ; W = v_fark
                               btfsc    v__status, v__c     ;  1 OV rs rs [?l ?l] 0722 1803
                                                            ; W = v_fark
                               goto     l__l776             ;  1 OV rs rs [?l ?l] 0723 2f28
                                                            ; W = v_fark
l__l1102
                               movf     v___y0_1,w          ;  1 OV rs rs [?l ?l] 0724 0857
                               subwf    v___y1_1,w          ;  1 OV rs rs [?l ?l] 0725 025d
                                                            ; W = v___y0_1
                               movwf    v_yfark             ;  1 OV rs rs [?l ?l] 0726 00e5
                               branchlo_nop l__l775         ;  1 OV rs rs [?l ?l] 0727
                                                            ; W = v_yfark
                               goto     l__l775             ;  1 OV rs rs [?l ?l] 0727 2f2b
                                                            ; W = v_yfark
l__l776
                               movf     v___y1_1,w          ;  1 OV rs rs [?l ?l] 0728 085d
                                                            ; W = v_fark
                               subwf    v___y0_1,w          ;  1 OV rs rs [?l ?l] 0729 0257
                                                            ; W = v___y1_1
                               movwf    v_yfark             ;  1 OV rs rs [?l ?l] 072a 00e5
l__l775
;   33    if xfark >= yfark then fark = xfark else fark = yfark end if
                               movf     v_xfark,w           ;  1 OV rs rs [?l ?l] 072b 0864
                                                            ; W = v_yfark
                               subwf    v_yfark,w           ;  1 OV rs rs [?l ?l] 072c 0265
                                                            ; W = v_xfark
                               branchlo_nop l__l1104        ;  1 OV rs rs [?l ?l] 072d
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 072d 1903
                               goto     l__l1104            ;  1 OV rs rs [?l ?l] 072e 2f31
                               branchlo_nop l__l778         ;  1 OV rs rs [?l ?l] 072f
                                                            ; W = v___side_24
                               btfsc    v__status, v__c     ;  1 OV rs rs [?l ?l] 072f 1803
                                                            ; W = v___side_24
                               goto     l__l778             ;  1 OV rs rs [?l ?l] 0730 2f34
                                                            ; W = v___side_24
l__l1104
                               movf     v_xfark,w           ;  1 OV rs rs [?l ?l] 0731 0864
                               movwf    v_fark              ;  1 OV rs rs [?l ?l] 0732 00e6
                                                            ; W = v_xfark
                               branchlo_nop l__l777         ;  1 OV rs rs [?l ?l] 0733
                                                            ; W = v_fark
                               goto     l__l777             ;  1 OV rs rs [?l ?l] 0733 2f36
                                                            ; W = v_fark
l__l778
                               movf     v_yfark,w           ;  1 OV rs rs [?l ?l] 0734 0865
                                                            ; W = v___side_24
                               movwf    v_fark              ;  1 OV rs rs [?l ?l] 0735 00e6
                                                            ; W = v_yfark
l__l777
;   34    xx = 0
                               clrf     v_xx                ;  1 OV rs rs [?l ?l] 0736 01e7
                                                            ; W = v_fark
;   35    for fark loop
                               clrf     v__floop8           ;  1 OV rs rs [?l ?l] 0737 01e8
                                                            ; W = v_fark
                               branchlo_nop l__l780         ;  1 OV rs rs [?l ?l] 0738
                                                            ; W = v_fark
                               goto     l__l780             ;  1 OV rs rs [?l ?l] 0738 2fdb
                                                            ; W = v_fark
l__l779
;   36       lcd_write_pixel ( xi, yi ,onoff)
                               movf     v_xi,w              ;  1 OV rs rs [?l ?l] 0739 085e
                               movwf    v___x_122           ;  1 OV rs rs [?l ?l] 073a 00eb
                                                            ; W = v_xi
; glcd_ks0108.jal
;  159    var byte side = KS0108_LEFT   -- Stores which chip to use on the LCD
                               clrf     v___side_24         ;  1 OV rs rs [?l ?l] 073b 01ee
                                                            ; W = v___x_122
;  161    if x > 63 then                -- Check for first or second display area
                               movlw    63                  ;  1 OV rs rs [?l ?l] 073c 303f
                                                            ; W = v___x_122
                               subwf    v___x_122,w         ;  1 OV rs rs [?l ?l] 073d 026b
                               branchlo_nop l__l782         ;  1 OV rs rs [?l ?l] 073e
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 073e 1903
                               goto     l__l782             ;  1 OV rs rs [?l ?l] 073f 2f46
                               branchlo_nop l__l782         ;  1 OV rs rs [?l ?l] 0740
                                                            ; W = v____temp_79
                               btfss    v__status, v__c     ;  1 OV rs rs [?l ?l] 0740 1c03
                                                            ; W = v____temp_79
                               goto     l__l782             ;  1 OV rs rs [?l ?l] 0741 2f46
                                                            ; W = v____temp_79
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  162       x = x - 64
                               movlw    64                  ;  1 OV rs rs [?l ?l] 0742 3040
                               subwf    v___x_122,f         ;  1 OV rs rs [?l ?l] 0743 02eb
;  163       side = KS0108_RIGHT
                               movlw    1                   ;  1 OV rs rs [?l ?l] 0744 3001
                               movwf    v___side_24         ;  1 OV rs rs [?l ?l] 0745 00ee
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  164    end if
l__l782
;  166    _ks0108_inst()                 -- Set for instruction
                               branchlo_nop l__ks0108_inst  ;  1 OV rs rs [?l ?l] 0746
                                                            ; W = v____temp_79
                               call     l__ks0108_inst      ;  1 OV rs ?? [?l ??] 0746 266f
                                                            ; W = v____temp_79
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  129    _ks0108_write(side, KS0108_CMD_COLUMN | column)
                               movlw    64                  ;  1 OV ?? ?? [?? ??] 0747 3040
                               datalo_clr v___x_122         ;  1 OV ?? ?s [?? ??] 0748 1283
                               datahi_clr v___x_122         ;  1 OV ?s rs [?? ??] 0749 1303
                               iorwf    v___x_122,w         ;  1 OV rs rs [?? ??] 074a 046b
                               datalo_set v____temp_80      ;  1 OV rs rS [?? ??] 074b 1683
                               movwf    v____temp_80        ;  1 OV rS rS [?? ??] 074c 00a8
                               movf     v____temp_80,w      ;  1 OV rS rS [?? ??] 074d 0828
                                                            ; W = v____temp_80
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 074e 00bb
                                                            ; W = v____temp_80
                               datalo_clr v___side_24       ;  1 OV rS rs [?? ??] 074f 1283
                                                            ; W = v___data_14
                               movf     v___side_24,w       ;  1 OV rs rs [?? ??] 0750 086e
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rs rs [?? ?l] 0751 118a
                                                            ; W = v___side_24
                               call     l__ks0108_write     ;  1 OV rs ?? [?l ??] 0752 25e7
                                                            ; W = v___side_24
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  167    _ks0108_column(side,x)         -- Set the horizontal address
;  168    _ks0108_page(side,(y / 8))     -- Set the page address
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 0753 1003
                               datalo_clr v_yi              ;  1 OV ?? ?s [?? ??] 0754 1283
                               datahi_clr v_yi              ;  1 OV ?s rs [?? ??] 0755 1303
                               rrf      v_yi,w              ;  1 OV rs rs [?? ??] 0756 0c62
                               datalo_set v____rparam0_1    ;  1 OV rs rS [?? ??] 0757 1683
                               movwf    v____rparam0_1      ;  1 OV rS rS [?? ??] 0758 00a7
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0759 1003
                                                            ; W = v____rparam0_1
                               rrf      v____rparam0_1,f    ;  1 OV rS rS [?? ??] 075a 0ca7
                                                            ; W = v____rparam0_1
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 075b 1003
                               rrf      v____rparam0_1,f    ;  1 OV rS rS [?? ??] 075c 0ca7
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  119    _ks0108_write(side, KS0108_CMD_PAGE | page)
                               movlw    184                 ;  1 OV rS rS [?? ??] 075d 30b8
                               iorwf    v____rparam0_1,w    ;  1 OV rS rS [?? ??] 075e 0427
                               movwf    v____temp_81        ;  1 OV rS rS [?? ??] 075f 00a8
                               movf     v____temp_81,w      ;  1 OV rS rS [?? ??] 0760 0828
                                                            ; W = v____temp_81
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0761 00bb
                                                            ; W = v____temp_81
                               datalo_clr v___side_24       ;  1 OV rS rs [?? ??] 0762 1283
                                                            ; W = v___data_14
                               movf     v___side_24,w       ;  1 OV rs rs [?? ??] 0763 086e
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rs rs [?? ?l] 0764 118a
                                                            ; W = v___side_24
                               call     l__ks0108_write     ;  1 OV rs ?? [?l ??] 0765 25e7
                                                            ; W = v___side_24
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  168    _ks0108_page(side,(y / 8))     -- Set the page address
;  169    _ks0108_data()                 -- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 0766 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 0767 2675
;  170    data = _ks0108_read(side)      -- ignore; need two reads to get data at new address
                               datalo_clr v___side_24       ;  1 OV ?? ?s [?? ??] 0768 1283
                               datahi_clr v___side_24       ;  1 OV ?s rs [?? ??] 0769 1303
                               movf     v___side_24,w       ;  1 OV rs rs [?? ??] 076a 086e
                               branchlo_clr l__ks0108_read  ;  1 OV rs rs [?? ?l] 076b 118a
                                                            ; W = v___side_24
                               call     l__ks0108_read      ;  1 OV rs ?? [?l ??] 076c 2625
                                                            ; W = v___side_24
                               datalo_clr v___data_21       ;  1 OV ?? ?s [?? ??] 076d 1283
                               datahi_clr v___data_21       ;  1 OV ?s rs [?? ??] 076e 1303
                               movwf    v___data_21         ;  1 OV rs rs [?? ??] 076f 00ed
;  171    data = _ks0108_read(side)      -- actual data
                               movf     v___side_24,w       ;  1 OV rs rs [?? ??] 0770 086e
                                                            ; W = v___data_21
                               branchlo_clr l__ks0108_read  ;  1 OV rs rs [?? ?l] 0771 118a
                                                            ; W = v___side_24
                               call     l__ks0108_read      ;  1 OV rs ?? [?l ??] 0772 2625
                                                            ; W = v___side_24
                               datalo_clr v___data_21       ;  1 OV ?? ?s [?? ??] 0773 1283
                               datahi_clr v___data_21       ;  1 OV ?s rs [?? ??] 0774 1303
                               movwf    v___data_21         ;  1 OV rs rs [?? ??] 0775 00ed
;  173    if onoff == 1 then
                               branchlo_clr l__l786         ;  1 OV rs rs [?? ?l] 0776 118a
                                                            ; W = v___data_21
                               btfss    v____bitbucket_11, 0 ; onoff5;  1 OV rs rs [?l ?l] 0777 1c6a
                                                            ; W = v___data_21
                               goto     l__l786             ;  1 OV rs rs [?l ?l] 0778 2f8c
                                                            ; W = v___data_21
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  175       yy = y % 8
                               movlw    7                   ;  1 OV rs rs [?l ?l] 0779 3007
                               andwf    v_yi,w              ;  1 OV rs rs [?l ?l] 077a 0562
                               datalo_set v___yy_2          ;  1 OV rs rS [?l ?l] 077b 1683
                               movwf    v___yy_2            ;  1 OV rS rS [?l ?l] 077c 00a0
;  176       data = data | ( 1 << yy )
                               movf     v___yy_2,w          ;  1 OV rS rS [?l ?l] 077d 0820
                                                            ; W = v___yy_2
                               movwf    v__pic_accum        ;  1 OV rS rS [?l ?l] 077e 00fe
                                                            ; W = v___yy_2
                               movlw    1                   ;  1 OV rS rS [?l ?l] 077f 3001
                               movwf    v____temp_79        ;  1 OV rS rS [?l ?l] 0780 00a3
                               movf     v__pic_accum,w      ;  1 OV rS rS [?l ?l] 0781 087e
                                                            ; W = v____temp_79
                               branchlo_nop l__l1108        ;  1 OV rS rS [?l ?l] 0782
                               goto     l__l1108            ;  1 OV rS rS [?l ?l] 0782 2f86
l__l1107
                               bcf      v__status, v__c     ;  1 OV rS rS [?l ?l] 0783 1003
                               rlf      v____temp_79,f      ;  1 OV rS rS [?l ?l] 0784 0da3
                               decf     v__pic_accum,f      ;  1 OV rS rS [?l ?l] 0785 03fe
l__l1108
                               branchlo_nop l__l1107        ;  1 OV rS rS [?l ?l] 0786
                               btfss    v__status, v__z     ;  1 OV rS rS [?l ?l] 0786 1d03
                               goto     l__l1107            ;  1 OV rS rS [?l ?l] 0787 2f83
                               movf     v____temp_79,w      ;  1 OV rS rS [?l ?l] 0788 0823
                               datalo_clr v___data_21       ;  1 OV rS rs [?l ?l] 0789 1283
                                                            ; W = v____temp_79
                               iorwf    v___data_21,f       ;  1 OV rs rs [?l ?l] 078a 04ed
                                                            ; W = v____temp_79
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  177    else                        -- or
                               branchlo_nop l__l787         ;  1 OV rs rs [?l ?l] 078b
                                                            ; W = v____temp_79
                               goto     l__l787             ;  1 OV rs rs [?l ?l] 078b 2fa0
                                                            ; W = v____temp_79
l__l786
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  179       yy = y % 8
                               movlw    7                   ;  1 OV rs rs [?l ?l] 078c 3007
                                                            ; W = v___data_21
                               andwf    v_yi,w              ;  1 OV rs rs [?l ?l] 078d 0562
                               datalo_set v___yy_2          ;  1 OV rs rS [?l ?l] 078e 1683
                               movwf    v___yy_2            ;  1 OV rS rS [?l ?l] 078f 00a0
;  180       data = data & !( 1 << yy )
                               movf     v___yy_2,w          ;  1 OV rS rS [?l ?l] 0790 0820
                                                            ; W = v___yy_2
                               movwf    v__pic_accum        ;  1 OV rS rS [?l ?l] 0791 00fe
                                                            ; W = v___yy_2
                               movlw    1                   ;  1 OV rS rS [?l ?l] 0792 3001
                               movwf    v____temp_79        ;  1 OV rS rS [?l ?l] 0793 00a3
                               movf     v__pic_accum,w      ;  1 OV rS rS [?l ?l] 0794 087e
                                                            ; W = v____temp_79
                               branchlo_nop l__l1110        ;  1 OV rS rS [?l ?l] 0795
                               goto     l__l1110            ;  1 OV rS rS [?l ?l] 0795 2f99
l__l1109
                               bcf      v__status, v__c     ;  1 OV rS rS [?l ?l] 0796 1003
                               rlf      v____temp_79,f      ;  1 OV rS rS [?l ?l] 0797 0da3
                               decf     v__pic_accum,f      ;  1 OV rS rS [?l ?l] 0798 03fe
l__l1110
                               branchlo_nop l__l1109        ;  1 OV rS rS [?l ?l] 0799
                               btfss    v__status, v__z     ;  1 OV rS rS [?l ?l] 0799 1d03
                               goto     l__l1109            ;  1 OV rS rS [?l ?l] 079a 2f96
                               comf     v____temp_79,w      ;  1 OV rS rS [?l ?l] 079b 0923
                               movwf    v____temp_79+1      ;  1 OV rS rS [?l ?l] 079c 00a4
                               movf     v____temp_79+1,w    ;  1 OV rS rS [?l ?l] 079d 0824
                                                            ; W = v____temp_79
                               datalo_clr v___data_21       ;  1 OV rS rs [?l ?l] 079e 1283
                                                            ; W = v____temp_79
                               andwf    v___data_21,f       ;  1 OV rs rs [?l ?l] 079f 05ed
                                                            ; W = v____temp_79
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  181    end if
l__l787
;  182    _ks0108_inst()              -- Set for instruction
                               branchlo_nop l__ks0108_inst  ;  1 OV rs rs [?l ?l] 07a0
                                                            ; W = v____temp_79
                               call     l__ks0108_inst      ;  1 OV rs ?? [?l ??] 07a0 266f
                                                            ; W = v____temp_79
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  129    _ks0108_write(side, KS0108_CMD_COLUMN | column)
                               movlw    64                  ;  1 OV ?? ?? [?? ??] 07a1 3040
                               datalo_clr v___x_122         ;  1 OV ?? ?s [?? ??] 07a2 1283
                               datahi_clr v___x_122         ;  1 OV ?s rs [?? ??] 07a3 1303
                               iorwf    v___x_122,w         ;  1 OV rs rs [?? ??] 07a4 046b
                               datalo_set v____temp_82      ;  1 OV rs rS [?? ??] 07a5 1683
                               movwf    v____temp_82        ;  1 OV rS rS [?? ??] 07a6 00a8
                               movf     v____temp_82,w      ;  1 OV rS rS [?? ??] 07a7 0828
                                                            ; W = v____temp_82
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 07a8 00bb
                                                            ; W = v____temp_82
                               datalo_clr v___side_24       ;  1 OV rS rs [?? ??] 07a9 1283
                                                            ; W = v___data_14
                               movf     v___side_24,w       ;  1 OV rs rs [?? ??] 07aa 086e
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rs rs [?? ?l] 07ab 118a
                                                            ; W = v___side_24
                               call     l__ks0108_write     ;  1 OV rs ?? [?l ??] 07ac 25e7
                                                            ; W = v___side_24
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; glcd_ks0108.jal
;  183    _ks0108_column(side,x)         -- Set the horizontal address
;  184    _ks0108_data()              -- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 07ad 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 07ae 2675
;  185    _ks0108_write(side, data)       -- Write the pixel data
                               datalo_clr v___data_21       ;  1 OV ?? ?s [?? ??] 07af 1283
                               datahi_clr v___data_21       ;  1 OV ?s rs [?? ??] 07b0 1303
                               movf     v___data_21,w       ;  1 OV rs rs [?? ??] 07b1 086d
                               datalo_set v___data_14       ;  1 OV rs rS [?? ??] 07b2 1683
                                                            ; W = v___data_21
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 07b3 00bb
                                                            ; W = v___data_21
                               datalo_clr v___side_24       ;  1 OV rS rs [?? ??] 07b4 1283
                                                            ; W = v___data_14
                               movf     v___side_24,w       ;  1 OV rs rs [?? ??] 07b5 086e
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rs rs [?? ?l] 07b6 118a
                                                            ; W = v___side_24
                               call     l__ks0108_write     ;  1 OV rs ?? [?l ??] 07b7 25e7
                                                            ; W = v___side_24
; glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
;   37       if xx < xfark then
                               datalo_clr v_xx              ;  1 OV ?? ?s [?? ??] 07b8 1283
                               datahi_clr v_xx              ;  1 OV ?s rs [?? ??] 07b9 1303
                               movf     v_xx,w              ;  1 OV rs rs [?? ??] 07ba 0867
                               subwf    v_xfark,w           ;  1 OV rs rs [?? ??] 07bb 0264
                                                            ; W = v_xx
                               branchlo_clr l__l791         ;  1 OV rs rs [?? ?l] 07bc 118a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 07bd 1903
                               goto     l__l791             ;  1 OV rs rs [?l ?l] 07be 2fca
                               branchlo_nop l__l791         ;  1 OV rs rs [?l ?l] 07bf
                               btfss    v__status, v__c     ;  1 OV rs rs [?l ?l] 07bf 1c03
                               goto     l__l791             ;  1 OV rs rs [?l ?l] 07c0 2fca
;   38           if x1 >= x0 then xi = xi + 1 else xi = xi - 1 end if
                               movf     v___x1_1,w          ;  1 OV rs rs [?l ?l] 07c1 085b
                               subwf    v___x0_1,w          ;  1 OV rs rs [?l ?l] 07c2 0255
                                                            ; W = v___x1_1
                               branchlo_nop l__l1114        ;  1 OV rs rs [?l ?l] 07c3
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 07c3 1903
                               goto     l__l1114            ;  1 OV rs rs [?l ?l] 07c4 2fc7
                               branchlo_nop l__l793         ;  1 OV rs rs [?l ?l] 07c5
                               btfsc    v__status, v__c     ;  1 OV rs rs [?l ?l] 07c5 1803
                               goto     l__l793             ;  1 OV rs rs [?l ?l] 07c6 2fc9
l__l1114
                               incf     v_xi,f              ;  1 OV rs rs [?l ?l] 07c7 0ade
                               branchlo_nop l__l790         ;  1 OV rs rs [?l ?l] 07c8
                               goto     l__l790             ;  1 OV rs rs [?l ?l] 07c8 2fca
l__l793
                               decf     v_xi,f              ;  1 OV rs rs [?l ?l] 07c9 03de
;   39       end if
l__l791
l__l790
;   40       if xx < yfark then
                               movf     v_xx,w              ;  1 OV rs rs [?l ?l] 07ca 0867
                               subwf    v_yfark,w           ;  1 OV rs rs [?l ?l] 07cb 0265
                                                            ; W = v_xx
                               branchlo_nop l__l795         ;  1 OV rs rs [?l ?l] 07cc
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 07cc 1903
                               goto     l__l795             ;  1 OV rs rs [?l ?l] 07cd 2fd9
                               branchlo_nop l__l795         ;  1 OV rs rs [?l ?l] 07ce
                               btfss    v__status, v__c     ;  1 OV rs rs [?l ?l] 07ce 1c03
                               goto     l__l795             ;  1 OV rs rs [?l ?l] 07cf 2fd9
;   41           if y1 >= y0 then yi = yi + 1 else yi = yi - 1 end if
                               movf     v___y1_1,w          ;  1 OV rs rs [?l ?l] 07d0 085d
                               subwf    v___y0_1,w          ;  1 OV rs rs [?l ?l] 07d1 0257
                                                            ; W = v___y1_1
                               branchlo_nop l__l1118        ;  1 OV rs rs [?l ?l] 07d2
                               btfsc    v__status, v__z     ;  1 OV rs rs [?l ?l] 07d2 1903
                               goto     l__l1118            ;  1 OV rs rs [?l ?l] 07d3 2fd6
                               branchlo_nop l__l797         ;  1 OV rs rs [?l ?l] 07d4
                               btfsc    v__status, v__c     ;  1 OV rs rs [?l ?l] 07d4 1803
                               goto     l__l797             ;  1 OV rs rs [?l ?l] 07d5 2fd8
l__l1118
                               incf     v_yi,f              ;  1 OV rs rs [?l ?l] 07d6 0ae2
                               branchlo_nop l__l794         ;  1 OV rs rs [?l ?l] 07d7
                               goto     l__l794             ;  1 OV rs rs [?l ?l] 07d7 2fd9
l__l797
                               decf     v_yi,f              ;  1 OV rs rs [?l ?l] 07d8 03e2
;   42       end if
l__l795
l__l794
;   43       xx = xx + 1
                               incf     v_xx,f              ;  1 OV rs rs [?l ?l] 07d9 0ae7
;   44    end loop
                               incf     v__floop8,f         ;  1 OV rs rs [?l ?l] 07da 0ae8
l__l780
                               movf     v__floop8,w         ;  1 OV rs rs [?l ?l] 07db 0868
                                                            ; W = v_fark
                               subwf    v_fark,w            ;  1 OV rs rs [?l ?l] 07dc 0266
                                                            ; W = v__floop8
                               branchlo_nop l__l779         ;  1 OV rs rs [?l ?l] 07dd
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 07dd 1d03
                               goto     l__l779             ;  1 OV rs rs [?l ?l] 07de 2f39
;   45 end procedure
                               return                       ;  1 OV rs rs [?l ?l] 07df 0008
                                                            ; W = v___side_24
;   58 procedure lcd_filled_rect(byte in x0, byte in y0, byte in x1, byte in y1, bit in state) is
l_lcd_filled_rect
                               movwf    v___x0_5            ;  1 OV rs rs [?l ?l] 07e0 00d5
;   59 	var byte xDiff = x1 - x0
                               movf     v___x0_5,w          ;  1 OV rs rs [?l ?l] 07e1 0855
                                                            ; W = v___x0_5
                               subwf    v___x1_5,w          ;  1 OV rs rs [?l ?l] 07e2 025b
                                                            ; W = v___x0_5
                               movwf    v_xdiff             ;  1 OV rs rs [?l ?l] 07e3 00e4
;   60 	var byte yDiff = y1 - y0
                               movf     v___y0_5,w          ;  1 OV rs rs [?l ?l] 07e4 0857
                                                            ; W = v_xdiff
                               subwf    v___y1_5,w          ;  1 OV rs rs [?l ?l] 07e5 025d
                                                            ; W = v___y0_5
                               movwf    v_ydiff             ;  1 OV rs rs [?l ?l] 07e6 00e5
;   61 	var byte currX = 0
                               clrf     v_currx             ;  1 OV rs rs [?l ?l] 07e7 01e6
                                                            ; W = v_ydiff
;   62 	var byte currY = 0
                               clrf     v_curry             ;  1 OV rs rs [?l ?l] 07e8 01e7
                                                            ; W = v_ydiff
;   65 	var word area = xDiff * yDiff
                               movf     v_xdiff,w           ;  1 OV rs rs [?l ?l] 07e9 0864
                                                            ; W = v_ydiff
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?l ?l] 07ea 00a0
                                                            ; W = v_xdiff
                               clrf     v__pic_multiplier+1 ;  1 OV rs rs [?l ?l] 07eb 01a1
                                                            ; W = v__pic_multiplier
                               movf     v_ydiff,w           ;  1 OV rs rs [?l ?l] 07ec 0865
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?l ?l] 07ed 00a2
                                                            ; W = v_ydiff
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?l ?l] 07ee 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_nop l__pic_multiply ;  1 OV rs rs [?l ?l] 07ef
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?l ??] 07ef 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 07f0 1283
                               datahi_clr v__pic_mresult    ;  1 OV ?s rs [?? ??] 07f1 1303
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 07f2 0824
                               movwf    v_area              ;  1 OV rs rs [?? ??] 07f3 00e8
                                                            ; W = v__pic_mresult
                               movf     v__pic_mresult+1,w  ;  1 OV rs rs [?? ??] 07f4 0825
                                                            ; W = v_area
                               movwf    v_area+1            ;  1 OV rs rs [?? ??] 07f5 00e9
                                                            ; W = v__pic_mresult
;   67 	for area loop
                               clrf     v__floop9           ;  1 OV rs rs [?? ??] 07f6 01eb
                                                            ; W = v_area
                               clrf     v__floop9+1         ;  1 OV rs rs [?? ??] 07f7 01ec
                                                            ; W = v_area
                               branchlo_set l__l803         ;  1 OV rs rs [?? ?L] 07f8 158a
                                                            ; W = v_area
                               goto     l__l803             ;  1 OV rs rs [?L ?L] 07f9 291a
                                                            ; W = v_area
l__l802
;   68 		if (currY == yDiff) & (currX == xDiff) then
                               movf     v_curry,w           ;  1 OV rs rs [?l ?l] 07fa 0867
                               subwf    v_ydiff,w           ;  1 OV rs rs [?l ?l] 07fb 0265
                                                            ; W = v_curry
                               datalo_set v____bitbucket_9 ; _btemp95;  1 OV rs rS [?l ?l] 07fc 1683
                               bcf      v____bitbucket_9, 2 ; _btemp95;  1 OV rS rS [?l ?l] 07fd 1120
                               btfsc    v__status, v__z     ;  1 OV rS rS [?l ?l] 07fe 1903
                               bsf      v____bitbucket_9, 2 ; _btemp95;  1 OV rS rS [?l ?l] 07ff 1520
                               datalo_clr v_currx           ;  1 OV rS rs [?l ?l] 0800 1283
                               movf     v_currx,w           ;  1 OV rs rs [?l ?l] 0801 0866
                               subwf    v_xdiff,w           ;  1 OV rs rs [?l ?l] 0802 0264
                                                            ; W = v_currx
                               datalo_set v____bitbucket_9 ; _btemp96;  1 OV rs rS [?l ?l] 0803 1683
                               bcf      v____bitbucket_9, 3 ; _btemp96;  1 OV rS rS [?l ?l] 0804 11a0
                               btfsc    v__status, v__z     ;  1 OV rS rS [?l ?l] 0805 1903
                               bsf      v____bitbucket_9, 3 ; _btemp96;  1 OV rS rS [?l ?l] 0806 15a0
                               bsf      v____bitbucket_9, 4 ; _btemp97;  1 OV rS rS [?l ?l] 0807 1620
                               btfsc    v____bitbucket_9, 2 ; _btemp95;  1 OV rS rS [?l ?l] 0808 1920
                               btfss    v____bitbucket_9, 3 ; _btemp96;  1 OV rS rS [?l ?l] 0809 1da0
                               bcf      v____bitbucket_9, 4 ; _btemp97;  1 OV rS rS [?l ?l] 080a 1220
                               branchlo_set l__l806         ;  1 OV rS rS [?l ?L] 080b 158a
                               btfss    v____bitbucket_9, 4 ; _btemp97;  1 OV rS rS [?L ?L] 080c 1e20
                               goto     l__l806             ;  1 OV rS rS [?L ?L] 080d 2810
;   69 			write = 1
                               bsf      v____bitbucket_9, 1 ; write2;  1 OV rS rS [?L ?L] 080e 14a0
;   70 		else
                               branchlo_nop l__l805         ;  1 OV rS rS [?L ?L] 080f
                               goto     l__l805             ;  1 OV rS rS [?L ?L] 080f 2811
l__l806
;   71 			write = 0
                               bcf      v____bitbucket_9, 1 ; write2;  1 OV rS rS [?L ?L] 0810 10a0
;   72 		end if
l__l805
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
                               datalo_clr v_currx           ;  1 OV rS rs [?L ?L] 0811 1283
                               movf     v_currx,w           ;  1 OV rs rs [?L ?L] 0812 0866
                               addwf    v___x0_5,w          ;  1 OV rs rs [?L ?L] 0813 0755
                                                            ; W = v_currx
                               movwf    v____temp_83        ;  1 OV rs rs [?L ?L] 0814 00de
                               movf     v_curry,w           ;  1 OV rs rs [?L ?L] 0815 0867
                                                            ; W = v____temp_83
                               addwf    v___y0_5,w          ;  1 OV rs rs [?L ?L] 0816 0757
                                                            ; W = v_curry
                               movwf    v____temp_83+1      ;  1 OV rs rs [?L ?L] 0817 00df
                               movf     v____temp_83+1,w    ;  1 OV rs rs [?L ?L] 0818 085f
                                                            ; W = v____temp_83
                               movwf    v__rparam8          ;  1 OV rs rs [?L ?L] 0819 00ef
                                                            ; W = v____temp_83
                               movf     v____temp_83,w      ;  1 OV rs rs [?L ?L] 081a 085e
                                                            ; W = v__rparam8
                               datalo_set v___x_123         ;  1 OV rs rS [?L ?L] 081b 1683
                                                            ; W = v____temp_83
                               movwf    v___x_123           ;  1 OV rS rS [?L ?L] 081c 00a7
                                                            ; W = v____temp_83
; glcd_ks0108.jal
;  471 	e1 = !(buffX == x)		-- If the X is different than that of the buffer
                               datalo_clr v_buffx           ;  1 OV rS rs [?L ?L] 081d 1283
                                                            ; W = v___x_123
                               movf     v_buffx,w           ;  1 OV rs rs [?L ?L] 081e 083c
                                                            ; W = v___x_123
                               datalo_set v___x_123         ;  1 OV rs rS [?L ?L] 081f 1683
                                                            ; W = v_buffx
                               subwf    v___x_123,w         ;  1 OV rS rS [?L ?L] 0820 0227
                                                            ; W = v_buffx
                               bcf      v____bitbucket_9+1, 6 ; _btemp771;  1 OV rS rS [?L ?L] 0821 1321
                               btfsc    v__status, v__z     ;  1 OV rS rS [?L ?L] 0822 1903
                               bsf      v____bitbucket_9+1, 6 ; _btemp771;  1 OV rS rS [?L ?L] 0823 1721
                               btfsc    v____bitbucket_9+1, 6 ; _btemp771;  1 OV rS rS [?L ?L] 0824 1b21
                               bcf      v____bitbucket_9+1, 2 ; e11;  1 OV rS rS [?L ?L] 0825 1121
                               btfss    v____bitbucket_9+1, 6 ; _btemp771;  1 OV rS rS [?L ?L] 0826 1f21
                               bsf      v____bitbucket_9+1, 2 ; e11;  1 OV rS rS [?L ?L] 0827 1521
;  472 	e2 = !(buffY == (y/8))	-- If the Y is out of the buffer range
                               bcf      v__status, v__c     ;  1 OV rS rS [?L ?L] 0828 1003
                               datalo_clr v__rparam8        ;  1 OV rS rs [?L ?L] 0829 1283
                               rrf      v__rparam8,w        ;  1 OV rs rs [?L ?L] 082a 0c6f
                               datalo_set v____temp_84      ;  1 OV rs rS [?L ?L] 082b 1683
                               movwf    v____temp_84        ;  1 OV rS rS [?L ?L] 082c 00a8
                               bcf      v__status, v__c     ;  1 OV rS rS [?L ?L] 082d 1003
                                                            ; W = v____temp_84
                               rrf      v____temp_84,f      ;  1 OV rS rS [?L ?L] 082e 0ca8
                                                            ; W = v____temp_84
                               bcf      v__status, v__c     ;  1 OV rS rS [?L ?L] 082f 1003
                               rrf      v____temp_84,f      ;  1 OV rS rS [?L ?L] 0830 0ca8
                               datalo_clr v_buffy           ;  1 OV rS rs [?L ?L] 0831 1283
                               movf     v_buffy,w           ;  1 OV rs rs [?L ?L] 0832 083d
                               datalo_set v____temp_84      ;  1 OV rs rS [?L ?L] 0833 1683
                                                            ; W = v_buffy
                               subwf    v____temp_84,w      ;  1 OV rS rS [?L ?L] 0834 0228
                                                            ; W = v_buffy
                               bcf      v____bitbucket_9+2, 0 ; _btemp791;  1 OV rS rS [?L ?L] 0835 1022
                               btfsc    v__status, v__z     ;  1 OV rS rS [?L ?L] 0836 1903
                               bsf      v____bitbucket_9+2, 0 ; _btemp791;  1 OV rS rS [?L ?L] 0837 1422
                               btfsc    v____bitbucket_9+2, 0 ; _btemp791;  1 OV rS rS [?L ?L] 0838 1822
                               bcf      v____bitbucket_9+1, 5 ; e21;  1 OV rS rS [?L ?L] 0839 12a1
                               btfss    v____bitbucket_9+2, 0 ; _btemp791;  1 OV rS rS [?L ?L] 083a 1c22
                               bsf      v____bitbucket_9+1, 5 ; e21;  1 OV rS rS [?L ?L] 083b 16a1
;  473 	e3 = (buff > 0)			-- And, if the buffer is not empty
                               datalo_clr v_buff            ;  1 OV rS rs [?L ?L] 083c 1283
                               movf     v_buff,w            ;  1 OV rs rs [?L ?L] 083d 083b
                               datalo_set v____bitbucket_9+1 ; e31;  1 OV rs rS [?L ?L] 083e 1683
                                                            ; W = v_buff
                               bsf      v____bitbucket_9+1, 3 ; e31;  1 OV rS rS [?L ?L] 083f 15a1
                                                            ; W = v_buff
                               btfsc    v__status, v__z     ;  1 OV rS rS [?L ?L] 0840 1903
                                                            ; W = v_buff
                               bcf      v____bitbucket_9+1, 3 ; e31;  1 OV rS rS [?L ?L] 0841 11a1
                                                            ; W = v_buff
;  474 	e4 = (e1 | e2)			-- If X is different OR Y is out of range
                               bcf      v____bitbucket_9+1, 4 ; e41;  1 OV rS rS [?L ?L] 0842 1221
                                                            ; W = v_buff
                               btfss    v____bitbucket_9+1, 2 ; e11;  1 OV rS rS [?L ?L] 0843 1d21
                                                            ; W = v_buff
                               btfsc    v____bitbucket_9+1, 5 ; e21;  1 OV rS rS [?L ?L] 0844 1aa1
                                                            ; W = v_buff
                               bsf      v____bitbucket_9+1, 4 ; e41;  1 OV rS rS [?L ?L] 0845 1621
                                                            ; W = v_buff
;  475 	if (e4 & e3) then		
                               bsf      v____bitbucket_9+2, 4 ; _btemp831;  1 OV rS rS [?L ?L] 0846 1622
                                                            ; W = v_buff
                               btfsc    v____bitbucket_9+1, 4 ; e41;  1 OV rS rS [?L ?L] 0847 1a21
                                                            ; W = v_buff
                               btfss    v____bitbucket_9+1, 3 ; e31;  1 OV rS rS [?L ?L] 0848 1da1
                                                            ; W = v_buff
                               bcf      v____bitbucket_9+2, 4 ; _btemp831;  1 OV rS rS [?L ?L] 0849 1222
                                                            ; W = v_buff
                               branchlo_nop l__l807         ;  1 OV rS rS [?L ?L] 084a
                                                            ; W = v_buff
                               btfss    v____bitbucket_9+2, 4 ; _btemp831;  1 OV rS rS [?L ?L] 084a 1e22
                                                            ; W = v_buff
                               goto     l__l807             ;  1 OV rS rS [?L ?L] 084b 2863
                                                            ; W = v_buff
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  476 		ks0108_write_byte(x, (buffY * 8), buff) -- Write the buffer
                               bcf      v__status, v__c     ;  1 OV rS rS [?L ?L] 084c 1003
                                                            ; W = v___side_25
                               datalo_clr v_buffy           ;  1 OV rS rs [?L ?L] 084d 1283
                                                            ; W = v___side_25
                               rlf      v_buffy,w           ;  1 OV rs rs [?L ?L] 084e 0d3d
                                                            ; W = v___side_25
                               datalo_set v____temp_84      ;  1 OV rs rS [?L ?L] 084f 1683
                               movwf    v____temp_84        ;  1 OV rS rS [?L ?L] 0850 00a8
                               bcf      v__status, v__c     ;  1 OV rS rS [?L ?L] 0851 1003
                                                            ; W = v____temp_84
                               rlf      v____temp_84,f      ;  1 OV rS rS [?L ?L] 0852 0da8
                                                            ; W = v____temp_84
                               bcf      v__status, v__c     ;  1 OV rS rS [?L ?L] 0853 1003
                               rlf      v____temp_84,f      ;  1 OV rS rS [?L ?L] 0854 0da8
                               movf     v____temp_84,w      ;  1 OV rS rS [?L ?L] 0855 0828
                               movwf    v___y_3             ;  1 OV rS rS [?L ?L] 0856 00b4
                                                            ; W = v____temp_84
                               datalo_clr v_buff            ;  1 OV rS rs [?L ?L] 0857 1283
                                                            ; W = v___y_3
                               movf     v_buff,w            ;  1 OV rs rs [?L ?L] 0858 083b
                                                            ; W = v___y_3
                               datalo_set v___veri_1        ;  1 OV rs rS [?L ?L] 0859 1683
                                                            ; W = v_buff
                               movwf    v___veri_1          ;  1 OV rS rS [?L ?L] 085a 00b5
                                                            ; W = v_buff
                               movf     v___x_123,w         ;  1 OV rS rS [?L ?L] 085b 0827
                                                            ; W = v___veri_1
                               branchlo_clr l_ks0108_write_byte;  1 OV rS rS [?L ?l] 085c 118a
                                                            ; W = v___x_123
                               call     l_ks0108_write_byte ;  1 OV rS ?? [?l ??] 085d 267b
                                                            ; W = v___x_123
;  477 		buff = 0								-- Set all to 0
                               datalo_clr v_buff            ;  1 OV ?? ?s [?? ??] 085e 1283
                               datahi_clr v_buff            ;  1 OV ?s rs [?? ??] 085f 1303
                               clrf     v_buff              ;  1 OV rs rs [?? ??] 0860 01bb
;  478 		buffX = 0
                               clrf     v_buffx             ;  1 OV rs rs [?? ??] 0861 01bc
;  479 		buffY = 0
                               clrf     v_buffy             ;  1 OV rs rs [?? ??] 0862 01bd
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  480 	end if
l__l807
;  483 	var byte side = KS0108_LEFT   -- Stores which chip to use on the LCD
                               datalo_set v___side_25       ;  1 OV r? rS [?? ??] 0863 1683
                                                            ; W = v_buff
                               clrf     v___side_25         ;  1 OV rS rS [?? ??] 0864 01b0
                                                            ; W = v_buff
;  485 	if x > 63 then                -- Check for first or second display area
                               movlw    63                  ;  1 OV rS rS [?? ??] 0865 303f
                                                            ; W = v_buff
                               subwf    v___x_123,w         ;  1 OV rS rS [?? ??] 0866 0227
                               branchlo_set l__l809         ;  1 OV rS rS [?? ?L] 0867 158a
                               btfsc    v__status, v__z     ;  1 OV rS rS [?L ?L] 0868 1903
                               goto     l__l809             ;  1 OV rS rS [?L ?L] 0869 2870
                               branchlo_nop l__l809         ;  1 OV rS rS [?L ?L] 086a
                                                            ; W = v___data_22
                               btfss    v__status, v__c     ;  1 OV rS rS [?L ?L] 086a 1c03
                                                            ; W = v___data_22
                               goto     l__l809             ;  1 OV rS rS [?L ?L] 086b 2870
                                                            ; W = v___data_22
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  486 		x = x - 64
                               movlw    64                  ;  1 OV rS rS [?L ?L] 086c 3040
                                                            ; W = v_buff
                               subwf    v___x_123,f         ;  1 OV rS rS [?L ?L] 086d 02a7
;  487 		side = KS0108_RIGHT
                               movlw    1                   ;  1 OV rS rS [?L ?L] 086e 3001
                               movwf    v___side_25         ;  1 OV rS rS [?L ?L] 086f 00b0
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  488 	end if
l__l809
;  490 	if buff == 0 then					-- Only gather data when the buffer is empty
                               datalo_clr v_buff            ;  1 OV rS rs [?L ?L] 0870 1283
                                                            ; W = v___data_22
                               movf     v_buff,w            ;  1 OV rs rs [?L ?L] 0871 083b
                                                            ; W = v___data_22
                               branchlo_nop l__l813         ;  1 OV rs rs [?L ?L] 0872
                                                            ; W = v_buff
                               btfss    v__status, v__z     ;  1 OV rs rs [?L ?L] 0872 1d03
                                                            ; W = v_buff
                               goto     l__l813             ;  1 OV rs rs [?L ?L] 0873 28a4
                                                            ; W = v_buff
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  491 		_ks0108_inst()					-- Set for instruction
                               branchlo_clr l__ks0108_inst  ;  1 OV rs rs [?L ?l] 0874 118a
                                                            ; W = v____temp_84
                               call     l__ks0108_inst      ;  1 OV rs ?? [?l ??] 0875 266f
                                                            ; W = v____temp_84
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  129    _ks0108_write(side, KS0108_CMD_COLUMN | column)
                               movlw    64                  ;  1 OV ?? ?? [?? ??] 0876 3040
                               datalo_set v___x_123         ;  1 OV ?? ?S [?? ??] 0877 1683
                               datahi_clr v___x_123         ;  1 OV ?S rS [?? ??] 0878 1303
                               iorwf    v___x_123,w         ;  1 OV rS rS [?? ??] 0879 0427
                               movwf    v____temp_85        ;  1 OV rS rS [?? ??] 087a 00b2
                               movf     v____temp_85,w      ;  1 OV rS rS [?? ??] 087b 0832
                                                            ; W = v____temp_85
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 087c 00bb
                                                            ; W = v____temp_85
                               movf     v___side_25,w       ;  1 OV rS rS [?? ??] 087d 0830
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 087e 118a
                                                            ; W = v___side_25
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 087f 25e7
                                                            ; W = v___side_25
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  492 		_ks0108_column(side,x)			-- Set the horizontal address
;  493 		_ks0108_page(side,(y / 8))		-- Set the page address
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 0880 1003
                               datalo_clr v__rparam8        ;  1 OV ?? ?s [?? ??] 0881 1283
                               datahi_clr v__rparam8        ;  1 OV ?s rs [?? ??] 0882 1303
                               rrf      v__rparam8,w        ;  1 OV rs rs [?? ??] 0883 0c6f
                               datalo_set v____rparam6_1    ;  1 OV rs rS [?? ??] 0884 1683
                               movwf    v____rparam6_1      ;  1 OV rS rS [?? ??] 0885 00b1
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0886 1003
                                                            ; W = v____rparam6_1
                               rrf      v____rparam6_1,f    ;  1 OV rS rS [?? ??] 0887 0cb1
                                                            ; W = v____rparam6_1
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0888 1003
                               rrf      v____rparam6_1,f    ;  1 OV rS rS [?? ??] 0889 0cb1
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  119    _ks0108_write(side, KS0108_CMD_PAGE | page)
                               movlw    184                 ;  1 OV rS rS [?? ??] 088a 30b8
                               iorwf    v____rparam6_1,w    ;  1 OV rS rS [?? ??] 088b 0431
                               movwf    v____temp_86        ;  1 OV rS rS [?? ??] 088c 00b2
                               movf     v____temp_86,w      ;  1 OV rS rS [?? ??] 088d 0832
                                                            ; W = v____temp_86
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 088e 00bb
                                                            ; W = v____temp_86
                               movf     v___side_25,w       ;  1 OV rS rS [?? ??] 088f 0830
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0890 118a
                                                            ; W = v___side_25
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0891 25e7
                                                            ; W = v___side_25
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  493 		_ks0108_page(side,(y / 8))		-- Set the page address
;  494 		_ks0108_data()					-- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 0892 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 0893 2675
;  495 		data = _ks0108_read(side)		-- ignore; need two reads to get data at new address
                               datalo_set v___side_25       ;  1 OV ?? ?S [?? ??] 0894 1683
                               datahi_clr v___side_25       ;  1 OV ?S rS [?? ??] 0895 1303
                               movf     v___side_25,w       ;  1 OV rS rS [?? ??] 0896 0830
                               branchlo_clr l__ks0108_read  ;  1 OV rS rS [?? ?l] 0897 118a
                                                            ; W = v___side_25
                               call     l__ks0108_read      ;  1 OV rS ?? [?l ??] 0898 2625
                                                            ; W = v___side_25
                               datalo_set v___data_22       ;  1 OV ?? ?S [?? ??] 0899 1683
                               datahi_clr v___data_22       ;  1 OV ?S rS [?? ??] 089a 1303
                               movwf    v___data_22         ;  1 OV rS rS [?? ??] 089b 00ae
;  496 		data = _ks0108_read(side)		-- actual data
                               movf     v___side_25,w       ;  1 OV rS rS [?? ??] 089c 0830
                                                            ; W = v___data_22
                               branchlo_clr l__ks0108_read  ;  1 OV rS rS [?? ?l] 089d 118a
                                                            ; W = v___side_25
                               call     l__ks0108_read      ;  1 OV rS ?? [?l ??] 089e 2625
                                                            ; W = v___side_25
                               datalo_set v___data_22       ;  1 OV ?? ?S [?? ??] 089f 1683
                               datahi_clr v___data_22       ;  1 OV ?S rS [?? ??] 08a0 1303
                               movwf    v___data_22         ;  1 OV rS rS [?? ??] 08a1 00ae
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  497 	else
                               branchlo_set l__l814         ;  1 OV rS rS [?? ?L] 08a2 158a
                                                            ; W = v___data_22
                               goto     l__l814             ;  1 OV rS rS [?L ?L] 08a3 28a7
                                                            ; W = v___data_22
l__l813
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  498 		data = buff						-- so that we can add data to it!
                               movf     v_buff,w            ;  1 OV rs rs [?L ?L] 08a4 083b
                                                            ; W = v_buff
                               datalo_set v___data_22       ;  1 OV rs rS [?L ?L] 08a5 1683
                                                            ; W = v_buff
                               movwf    v___data_22         ;  1 OV rS rS [?L ?L] 08a6 00ae
                                                            ; W = v_buff
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  499 	end if
l__l814
;  502 	if onoff == 1 then
                               branchlo_nop l__l815         ;  1 OV rS rS [?L ?L] 08a7
                                                            ; W = v___data_22
                               btfss    v____bitbucket_9, 0 ; state1;  1 OV rS rS [?L ?L] 08a7 1c20
                                                            ; W = v___data_22
                               goto     l__l815             ;  1 OV rS rS [?L ?L] 08a8 28bc
                                                            ; W = v___data_22
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  503 		yy = y % 8					-- Calculate where the position of the y is
                               movlw    7                   ;  1 OV rS rS [?L ?L] 08a9 3007
                               datalo_clr v__rparam8        ;  1 OV rS rs [?L ?L] 08aa 1283
                               andwf    v__rparam8,w        ;  1 OV rs rs [?L ?L] 08ab 056f
                               datalo_set v___yy_3          ;  1 OV rs rS [?L ?L] 08ac 1683
                               movwf    v___yy_3            ;  1 OV rS rS [?L ?L] 08ad 00af
;  504 		data = data | ( 1 << yy )	-- Set the bit on
                               movf     v___yy_3,w          ;  1 OV rS rS [?L ?L] 08ae 082f
                                                            ; W = v___yy_3
                               movwf    v__pic_accum        ;  1 OV rS rS [?L ?L] 08af 00fe
                                                            ; W = v___yy_3
                               movlw    1                   ;  1 OV rS rS [?L ?L] 08b0 3001
                               movwf    v____temp_84        ;  1 OV rS rS [?L ?L] 08b1 00a8
                               movf     v__pic_accum,w      ;  1 OV rS rS [?L ?L] 08b2 087e
                                                            ; W = v____temp_84
                               branchlo_nop l__l1128        ;  1 OV rS rS [?L ?L] 08b3
                               goto     l__l1128            ;  1 OV rS rS [?L ?L] 08b3 28b7
l__l1127
                               bcf      v__status, v__c     ;  1 OV rS rS [?L ?L] 08b4 1003
                               rlf      v____temp_84,f      ;  1 OV rS rS [?L ?L] 08b5 0da8
                               decf     v__pic_accum,f      ;  1 OV rS rS [?L ?L] 08b6 03fe
l__l1128
                               branchlo_nop l__l1127        ;  1 OV rS rS [?L ?L] 08b7
                               btfss    v__status, v__z     ;  1 OV rS rS [?L ?L] 08b7 1d03
                               goto     l__l1127            ;  1 OV rS rS [?L ?L] 08b8 28b4
                               movf     v____temp_84,w      ;  1 OV rS rS [?L ?L] 08b9 0828
                               iorwf    v___data_22,f       ;  1 OV rS rS [?L ?L] 08ba 04ae
                                                            ; W = v____temp_84
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  505 	else
                               branchlo_nop l__l816         ;  1 OV rS rS [?L ?L] 08bb
                                                            ; W = v____temp_84
                               goto     l__l816             ;  1 OV rS rS [?L ?L] 08bb 28d0
                                                            ; W = v____temp_84
l__l815
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  506 		yy = y % 8					-- Calculate where the position of the y is
                               movlw    7                   ;  1 OV rS rS [?L ?L] 08bc 3007
                                                            ; W = v___data_22
                               datalo_clr v__rparam8        ;  1 OV rS rs [?L ?L] 08bd 1283
                               andwf    v__rparam8,w        ;  1 OV rs rs [?L ?L] 08be 056f
                               datalo_set v___yy_3          ;  1 OV rs rS [?L ?L] 08bf 1683
                               movwf    v___yy_3            ;  1 OV rS rS [?L ?L] 08c0 00af
;  507 		data = data & !( 1 << yy )	-- Set the bit off
                               movf     v___yy_3,w          ;  1 OV rS rS [?L ?L] 08c1 082f
                                                            ; W = v___yy_3
                               movwf    v__pic_accum        ;  1 OV rS rS [?L ?L] 08c2 00fe
                                                            ; W = v___yy_3
                               movlw    1                   ;  1 OV rS rS [?L ?L] 08c3 3001
                               movwf    v____temp_84        ;  1 OV rS rS [?L ?L] 08c4 00a8
                               movf     v__pic_accum,w      ;  1 OV rS rS [?L ?L] 08c5 087e
                                                            ; W = v____temp_84
                               branchlo_nop l__l1130        ;  1 OV rS rS [?L ?L] 08c6
                               goto     l__l1130            ;  1 OV rS rS [?L ?L] 08c6 28ca
l__l1129
                               bcf      v__status, v__c     ;  1 OV rS rS [?L ?L] 08c7 1003
                               rlf      v____temp_84,f      ;  1 OV rS rS [?L ?L] 08c8 0da8
                               decf     v__pic_accum,f      ;  1 OV rS rS [?L ?L] 08c9 03fe
l__l1130
                               branchlo_nop l__l1129        ;  1 OV rS rS [?L ?L] 08ca
                               btfss    v__status, v__z     ;  1 OV rS rS [?L ?L] 08ca 1d03
                               goto     l__l1129            ;  1 OV rS rS [?L ?L] 08cb 28c7
                               comf     v____temp_84,w      ;  1 OV rS rS [?L ?L] 08cc 0928
                               movwf    v____temp_84+1      ;  1 OV rS rS [?L ?L] 08cd 00a9
                               movf     v____temp_84+1,w    ;  1 OV rS rS [?L ?L] 08ce 0829
                                                            ; W = v____temp_84
                               andwf    v___data_22,f       ;  1 OV rS rS [?L ?L] 08cf 05ae
                                                            ; W = v____temp_84
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  508 	end if
l__l816
;  510 	if write then
                               branchlo_nop l__l818         ;  1 OV rS rS [?L ?L] 08d0
                                                            ; W = v____temp_84
                               btfss    v____bitbucket_9, 1 ; write2;  1 OV rS rS [?L ?L] 08d0 1ca0
                                                            ; W = v____temp_84
                               goto     l__l818             ;  1 OV rS rS [?L ?L] 08d1 28e9
                                                            ; W = v____temp_84
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  511 		_ks0108_inst()				-- Set for instruction
                               branchlo_clr l__ks0108_inst  ;  1 OV rS rS [?L ?l] 08d2 118a
                               call     l__ks0108_inst      ;  1 OV rS ?? [?l ??] 08d3 266f
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  129    _ks0108_write(side, KS0108_CMD_COLUMN | column)
                               movlw    64                  ;  1 OV ?? ?? [?? ??] 08d4 3040
                               datalo_set v___x_123         ;  1 OV ?? ?S [?? ??] 08d5 1683
                               datahi_clr v___x_123         ;  1 OV ?S rS [?? ??] 08d6 1303
                               iorwf    v___x_123,w         ;  1 OV rS rS [?? ??] 08d7 0427
                               movwf    v____temp_87        ;  1 OV rS rS [?? ??] 08d8 00b1
                               movf     v____temp_87,w      ;  1 OV rS rS [?? ??] 08d9 0831
                                                            ; W = v____temp_87
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 08da 00bb
                                                            ; W = v____temp_87
                               movf     v___side_25,w       ;  1 OV rS rS [?? ??] 08db 0830
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 08dc 118a
                                                            ; W = v___side_25
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 08dd 25e7
                                                            ; W = v___side_25
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  512 		_ks0108_column(side,x)		-- Set the horizontal address
;  513 		_ks0108_data()				-- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 08de 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 08df 2675
;  514 		_ks0108_write(side, data)	-- Write the pixel data
                               datalo_set v___data_22       ;  1 OV ?? ?S [?? ??] 08e0 1683
                               datahi_clr v___data_22       ;  1 OV ?S rS [?? ??] 08e1 1303
                               movf     v___data_22,w       ;  1 OV rS rS [?? ??] 08e2 082e
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 08e3 00bb
                                                            ; W = v___data_22
                               movf     v___side_25,w       ;  1 OV rS rS [?? ??] 08e4 0830
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 08e5 118a
                                                            ; W = v___side_25
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 08e6 25e7
                                                            ; W = v___side_25
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  515 	else
                               branchlo_set l__l819         ;  1 OV ?? ?? [?? ?L] 08e7 158a
                               goto     l__l819             ;  1 OV ?? ?? [?L ?L] 08e8 28f7
l__l818
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  516 		buff = data					-- Store the data in the buffer
                               movf     v___data_22,w       ;  1 OV rS rS [?L ?L] 08e9 082e
                                                            ; W = v____temp_84
                               datalo_clr v_buff            ;  1 OV rS rs [?L ?L] 08ea 1283
                                                            ; W = v___data_22
                               movwf    v_buff              ;  1 OV rs rs [?L ?L] 08eb 00bb
                                                            ; W = v___data_22
;  517 		buffX = x					-- Store the X
                               datalo_set v___x_123         ;  1 OV rs rS [?L ?L] 08ec 1683
                                                            ; W = v_buff
                               movf     v___x_123,w         ;  1 OV rS rS [?L ?L] 08ed 0827
                                                            ; W = v_buff
                               datalo_clr v_buffx           ;  1 OV rS rs [?L ?L] 08ee 1283
                                                            ; W = v___x_123
                               movwf    v_buffx             ;  1 OV rs rs [?L ?L] 08ef 00bc
                                                            ; W = v___x_123
;  518 		buffY = (y / 8)				-- Set the row of Y
                               bcf      v__status, v__c     ;  1 OV rs rs [?L ?L] 08f0 1003
                                                            ; W = v_buffx
                               rrf      v__rparam8,w        ;  1 OV rs rs [?L ?L] 08f1 0c6f
                                                            ; W = v_buffx
                               movwf    v_buffy             ;  1 OV rs rs [?L ?L] 08f2 00bd
                               bcf      v__status, v__c     ;  1 OV rs rs [?L ?L] 08f3 1003
                                                            ; W = v_buffy
                               rrf      v_buffy,f           ;  1 OV rs rs [?L ?L] 08f4 0cbd
                                                            ; W = v_buffy
                               bcf      v__status, v__c     ;  1 OV rs rs [?L ?L] 08f5 1003
                               rrf      v_buffy,f           ;  1 OV rs rs [?L ?L] 08f6 0cbd
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; glcd_ks0108.jal
;  519 	end if
l__l819
; glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
;   75 		currY = currY + 1
                               datalo_clr v_curry           ;  1 OV ?? ?s [?L ?L] 08f7 1283
                               datahi_clr v_curry           ;  1 OV ?s rs [?L ?L] 08f8 1303
                               incf     v_curry,f           ;  1 OV rs rs [?L ?L] 08f9 0ae7
;   76 		if currY == yDiff then
                               movf     v_curry,w           ;  1 OV rs rs [?L ?L] 08fa 0867
                               subwf    v_ydiff,w           ;  1 OV rs rs [?L ?L] 08fb 0265
                                                            ; W = v_curry
                               branchlo_nop l__l822         ;  1 OV rs rs [?L ?L] 08fc
                               btfss    v__status, v__z     ;  1 OV rs rs [?L ?L] 08fc 1d03
                               goto     l__l822             ;  1 OV rs rs [?L ?L] 08fd 2900
;   77 			currY = 0
                               clrf     v_curry             ;  1 OV rs rs [?L ?L] 08fe 01e7
;   78 			currX = currX + 1
                               incf     v_currx,f           ;  1 OV rs rs [?L ?L] 08ff 0ae6
;   79 		end if
l__l822
;   80 		if (currY == yDiff) & (currX == xDiff) then
                               movf     v_curry,w           ;  1 OV rs rs [?L ?L] 0900 0867
                               subwf    v_ydiff,w           ;  1 OV rs rs [?L ?L] 0901 0265
                                                            ; W = v_curry
                               datalo_set v____bitbucket_9 ; _btemp99;  1 OV rs rS [?L ?L] 0902 1683
                               bcf      v____bitbucket_9, 6 ; _btemp99;  1 OV rS rS [?L ?L] 0903 1320
                               btfsc    v__status, v__z     ;  1 OV rS rS [?L ?L] 0904 1903
                               bsf      v____bitbucket_9, 6 ; _btemp99;  1 OV rS rS [?L ?L] 0905 1720
                               datalo_clr v_currx           ;  1 OV rS rs [?L ?L] 0906 1283
                               movf     v_currx,w           ;  1 OV rs rs [?L ?L] 0907 0866
                               subwf    v_xdiff,w           ;  1 OV rs rs [?L ?L] 0908 0264
                                                            ; W = v_currx
                               datalo_set v____bitbucket_9 ; _btemp100;  1 OV rs rS [?L ?L] 0909 1683
                               bcf      v____bitbucket_9, 7 ; _btemp100;  1 OV rS rS [?L ?L] 090a 13a0
                               btfsc    v__status, v__z     ;  1 OV rS rS [?L ?L] 090b 1903
                               bsf      v____bitbucket_9, 7 ; _btemp100;  1 OV rS rS [?L ?L] 090c 17a0
                               bsf      v____bitbucket_9+1, 0 ; _btemp101;  1 OV rS rS [?L ?L] 090d 1421
                               btfsc    v____bitbucket_9, 6 ; _btemp99;  1 OV rS rS [?L ?L] 090e 1b20
                               btfss    v____bitbucket_9, 7 ; _btemp100;  1 OV rS rS [?L ?L] 090f 1fa0
                               bcf      v____bitbucket_9+1, 0 ; _btemp101;  1 OV rS rS [?L ?L] 0910 1021
                               branchlo_nop l__l824         ;  1 OV rS rS [?L ?L] 0911
                               btfss    v____bitbucket_9+1, 0 ; _btemp101;  1 OV rS rS [?L ?L] 0911 1c21
                               goto     l__l824             ;  1 OV rS rS [?L ?L] 0912 2915
;   81 			write = 1
                               bsf      v____bitbucket_9, 1 ; write2;  1 OV rS rS [?L ?L] 0913 14a0
;   82 		else
                               branchlo_nop l__l823         ;  1 OV rS rS [?L ?L] 0914
                               goto     l__l823             ;  1 OV rS rS [?L ?L] 0914 2916
l__l824
;   83 			write = 0
                               bcf      v____bitbucket_9, 1 ; write2;  1 OV rS rS [?L ?L] 0915 10a0
;   84 		end if
l__l823
;   85 	end loop
                               datalo_clr v__floop9         ;  1 OV rS rs [?L ?L] 0916 1283
                               incf     v__floop9,f         ;  1 OV rs rs [?L ?L] 0917 0aeb
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0918 1903
                               incf     v__floop9+1,f       ;  1 OV rs rs [?L ?L] 0919 0aec
l__l803
                               movf     v__floop9,w         ;  1 OV rs rs [?L ?L] 091a 086b
                                                            ; W = v_area
                               subwf    v_area,w            ;  1 OV rs rs [?L ?L] 091b 0268
                                                            ; W = v__floop9
                               movwf    v__pic_temp         ;  1 OV rs rs [?L ?L] 091c 00a0
                               movf     v__floop9+1,w       ;  1 OV rs rs [?L ?L] 091d 086c
                                                            ; W = v__pic_temp
                               subwf    v_area+1,w          ;  1 OV rs rs [?L ?L] 091e 0269
                                                            ; W = v__floop9
                               iorwf    v__pic_temp,w       ;  1 OV rs rs [?L ?L] 091f 0420
                               branchlo_clr l__l802         ;  1 OV rs rs [?L ?l] 0920 118a
                               btfss    v__status, v__z     ;  1 OV rs rs [?l ?l] 0921 1d03
                               goto     l__l802             ;  1 OV rs rs [?l ?l] 0922 2ffa
;   86 end procedure
                               return                       ;  1 OV rs rs [?l ?l] 0923 0008
;   95 procedure lcd'put(byte in char) is
;  114 procedure  lcd_clearscreen() is
l_lcd_clearscreen
;  115    lcd_fill(0)           -- Clear the display                 
                               movlw    0                   ;  1 OV rs rs [?L ?L] 0924 3000
                               branchlo_clr l_lcd_fill      ;  1 OV rs rs [?L ?l] 0925 118a
                               goto     l_lcd_fill          ;  1 OV rs rs [?l ?l] 0926 2eac
;  118 end procedure                                 
;  140 procedure lcd_num(byte in x, byte in y, word in num) is
l_lcd_num
                               movwf    v___x_126           ;  1 OV rs rs [?L ?L] 0927 00d5
;  141 	var byte hundrets = num / 100
                               movlw    100                 ;  1 OV rs rs [?L ?L] 0928 3064
                                                            ; W = v___x_126
                               movwf    v__pic_divisor      ;  1 OV rs rs [?L ?L] 0929 00a4
                               clrf     v__pic_divisor+1    ;  1 OV rs rs [?L ?L] 092a 01a5
                                                            ; W = v__pic_divisor
                               movf     v___num_1,w         ;  1 OV rs rs [?L ?L] 092b 085b
                                                            ; W = v__pic_divisor
                               movwf    v__pic_dividend     ;  1 OV rs rs [?L ?L] 092c 00a0
                                                            ; W = v___num_1
                               movf     v___num_1+1,w       ;  1 OV rs rs [?L ?L] 092d 085c
                                                            ; W = v__pic_dividend
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?L ?L] 092e 00a1
                                                            ; W = v___num_1
                               branchlo_clr l__pic_divide   ;  1 OV rs rs [?L ?l] 092f 118a
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  1 OV rs ?? [?l ??] 0930 22a9
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 0931 1283
                               datahi_clr v__pic_quotient   ;  1 OV ?s rs [?? ??] 0932 1303
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 0933 0826
                               movwf    v_hundrets          ;  1 OV rs rs [?? ??] 0934 00e6
                                                            ; W = v__pic_quotient
;  142 	var byte tens = (num - (hundrets * 100)) / 10
                               movf     v_hundrets,w        ;  1 OV rs rs [?? ??] 0935 0866
                                                            ; W = v_hundrets
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?? ??] 0936 00a0
                                                            ; W = v_hundrets
                               clrf     v__pic_multiplier+1 ;  1 OV rs rs [?? ??] 0937 01a1
                                                            ; W = v__pic_multiplier
                               movlw    100                 ;  1 OV rs rs [?? ??] 0938 3064
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?? ??] 0939 00a2
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?? ??] 093a 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  1 OV rs rs [?? ?l] 093b 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?l ??] 093c 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 093d 1283
                               datahi_clr v__pic_mresult    ;  1 OV ?s rs [?? ??] 093e 1303
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 093f 0824
                               movwf    v____temp_95        ;  1 OV rs rs [?? ??] 0940 00de
                                                            ; W = v__pic_mresult
                               movf     v___num_1+1,w       ;  1 OV rs rs [?? ??] 0941 085c
                                                            ; W = v____temp_95
                               movwf    v____temp_95+2      ;  1 OV rs rs [?? ??] 0942 00e0
                                                            ; W = v___num_1
                               movf     v____temp_95,w      ;  1 OV rs rs [?? ??] 0943 085e
                                                            ; W = v____temp_95
                               subwf    v___num_1,w         ;  1 OV rs rs [?? ??] 0944 025b
                                                            ; W = v____temp_95
                               movwf    v____temp_95+1      ;  1 OV rs rs [?? ??] 0945 00df
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 0946 1c03
                                                            ; W = v____temp_95
                               decf     v____temp_95+2,f    ;  1 OV rs rs [?? ??] 0947 03e0
                                                            ; W = v____temp_95
                               movlw    10                  ;  1 OV rs rs [?? ??] 0948 300a
                               movwf    v__pic_divisor      ;  1 OV rs rs [?? ??] 0949 00a4
                               clrf     v__pic_divisor+1    ;  1 OV rs rs [?? ??] 094a 01a5
                                                            ; W = v__pic_divisor
                               movf     v____temp_95+1,w    ;  1 OV rs rs [?? ??] 094b 085f
                                                            ; W = v__pic_divisor
                               movwf    v__pic_dividend     ;  1 OV rs rs [?? ??] 094c 00a0
                                                            ; W = v____temp_95
                               movf     v____temp_95+2,w    ;  1 OV rs rs [?? ??] 094d 0860
                                                            ; W = v__pic_dividend
                               movwf    v__pic_dividend+1   ;  1 OV rs rs [?? ??] 094e 00a1
                                                            ; W = v____temp_95
                               branchlo_clr l__pic_divide   ;  1 OV rs rs [?? ?l] 094f 118a
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  1 OV rs ?? [?l ??] 0950 22a9
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  1 OV ?? ?s [?? ??] 0951 1283
                               datahi_clr v__pic_quotient   ;  1 OV ?s rs [?? ??] 0952 1303
                               movf     v__pic_quotient,w   ;  1 OV rs rs [?? ??] 0953 0826
                               movwf    v_tens              ;  1 OV rs rs [?? ??] 0954 00e7
                                                            ; W = v__pic_quotient
;  143 	var byte ones = num - (hundrets * 100) - (tens * 10)
                               movf     v_hundrets,w        ;  1 OV rs rs [?? ??] 0955 0866
                                                            ; W = v_tens
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?? ??] 0956 00a0
                                                            ; W = v_hundrets
                               clrf     v__pic_multiplier+1 ;  1 OV rs rs [?? ??] 0957 01a1
                                                            ; W = v__pic_multiplier
                               movlw    100                 ;  1 OV rs rs [?? ??] 0958 3064
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?? ??] 0959 00a2
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?? ??] 095a 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  1 OV rs rs [?? ?l] 095b 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?l ??] 095c 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 095d 1283
                               datahi_clr v__pic_mresult    ;  1 OV ?s rs [?? ??] 095e 1303
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 095f 0824
                               movwf    v____temp_95        ;  1 OV rs rs [?? ??] 0960 00de
                                                            ; W = v__pic_mresult
                               movf     v___num_1+1,w       ;  1 OV rs rs [?? ??] 0961 085c
                                                            ; W = v____temp_95
                               movwf    v____temp_95+2      ;  1 OV rs rs [?? ??] 0962 00e0
                                                            ; W = v___num_1
                               movf     v____temp_95,w      ;  1 OV rs rs [?? ??] 0963 085e
                                                            ; W = v____temp_95
                               subwf    v___num_1,w         ;  1 OV rs rs [?? ??] 0964 025b
                                                            ; W = v____temp_95
                               movwf    v____temp_95+1      ;  1 OV rs rs [?? ??] 0965 00df
                               btfss    v__status, v__c     ;  1 OV rs rs [?? ??] 0966 1c03
                                                            ; W = v____temp_95
                               decf     v____temp_95+2,f    ;  1 OV rs rs [?? ??] 0967 03e0
                                                            ; W = v____temp_95
                               movf     v_tens,w            ;  1 OV rs rs [?? ??] 0968 0867
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?? ??] 0969 00a0
                                                            ; W = v_tens
                               clrf     v__pic_multiplier+1 ;  1 OV rs rs [?? ??] 096a 01a1
                                                            ; W = v__pic_multiplier
                               movlw    10                  ;  1 OV rs rs [?? ??] 096b 300a
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?? ??] 096c 00a2
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?? ??] 096d 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  1 OV rs rs [?? ?l] 096e 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?l ??] 096f 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 0970 1283
                               datahi_clr v__pic_mresult    ;  1 OV ?s rs [?? ??] 0971 1303
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 0972 0824
                               movwf    v____temp_95+3      ;  1 OV rs rs [?? ??] 0973 00e1
                                                            ; W = v__pic_mresult
                               movf     v____temp_95+3,w    ;  1 OV rs rs [?? ??] 0974 0861
                                                            ; W = v____temp_95
                               subwf    v____temp_95+1,w    ;  1 OV rs rs [?? ??] 0975 025f
                                                            ; W = v____temp_95
                               movwf    v_ones              ;  1 OV rs rs [?? ??] 0976 00e8
;  145 	lcd_write_char(x, y, hundrets + 48,0)
                               movlw    48                  ;  1 OV rs rs [?? ??] 0977 3030
                                                            ; W = v_ones
                               addwf    v_hundrets,w        ;  1 OV rs rs [?? ??] 0978 0766
                               movwf    v__rparam9          ;  1 OV rs rs [?? ??] 0979 00ea
                               movf     v___x_126,w         ;  1 OV rs rs [?? ??] 097a 0855
                                                            ; W = v__rparam9
                               movwf    v___x_127           ;  1 OV rs rs [?? ??] 097b 00ee
                                                            ; W = v___x_126
                               datalo_set v____bitbucket_4 ; debug3;  1 OV rs rS [?? ??] 097c 1683
                                                            ; W = v___x_127
                               bcf      v____bitbucket_4, 0 ; debug3;  1 OV rS rS [?? ??] 097d 1020
                                                            ; W = v___x_127
; glcd_ks0108.jal
;  423 	var word fIndex = 0
                               clrf     v___findex_2        ;  1 OV rS rS [?? ??] 097e 01a3
                                                            ; W = v___x_127
                               clrf     v___findex_2+1      ;  1 OV rS rS [?? ??] 097f 01a4
                                                            ; W = v___x_127
;  424 	var byte cx = 0b10101010
                               movlw    170                 ;  1 OV rS rS [?? ??] 0980 30aa
                                                            ; W = v___x_127
                               movwf    v___cx_2            ;  1 OV rS rS [?? ??] 0981 00a7
;  425 	var byte doLoop = 5
                               movlw    5                   ;  1 OV rS rS [?? ??] 0982 3005
                                                            ; W = v___cx_2
                               movwf    v___doloop_2        ;  1 OV rS rS [?? ??] 0983 00a8
;  426 	if (ch <  31) then return end if
                               movlw    31                  ;  1 OV rS rS [?? ??] 0984 301f
                                                            ; W = v___doloop_2
                               datalo_clr v__rparam9        ;  1 OV rS rs [?? ??] 0985 1283
                               subwf    v__rparam9,w        ;  1 OV rs rs [?? ??] 0986 026a
                               branchlo_set l__l852         ;  1 OV rs rs [?? ?L] 0987 158a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0988 1903
                               goto     l__l852             ;  1 OV rs rs [?L ?L] 0989 298d
                               branchlo_nop l__l852         ;  1 OV rs rs [?L ?L] 098a
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 098a 1803
                               goto     l__l852             ;  1 OV rs rs [?L ?L] 098b 298d
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  426 	if (ch <  31) then return end if
                               branchlo_nop l__l868         ;  1 OV rs rs [?L ?L] 098c
                               goto     l__l868             ;  1 OV rs rs [?L ?L] 098c 2a48
l__l852
;  427 	if (ch > 135) then return end if
                               movlw    135                 ;  1 OV rs rs [?L ?L] 098d 3087
                               subwf    v__rparam9,w        ;  1 OV rs rs [?L ?L] 098e 026a
                               branchlo_nop l__l854         ;  1 OV rs rs [?L ?L] 098f
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 098f 1903
                               goto     l__l854             ;  1 OV rs rs [?L ?L] 0990 2994
                               branchlo_nop l__l854         ;  1 OV rs rs [?L ?L] 0991
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 0991 1c03
                               goto     l__l854             ;  1 OV rs rs [?L ?L] 0992 2994
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  427 	if (ch > 135) then return end if
                               branchlo_nop l__l868         ;  1 OV rs rs [?L ?L] 0993
                               goto     l__l868             ;  1 OV rs rs [?L ?L] 0993 2a48
l__l854
;  430 	fIndex = fIndex + 5 * word(ch - 32)
                               movlw    32                  ;  1 OV rs rs [?L ?L] 0994 3020
                               subwf    v__rparam9,w        ;  1 OV rs rs [?L ?L] 0995 026a
                               datalo_set v____temp_96      ;  1 OV rs rS [?L ?L] 0996 1683
                               movwf    v____temp_96        ;  1 OV rS rS [?L ?L] 0997 00aa
                               clrf     v____temp_96+1      ;  1 OV rS rS [?L ?L] 0998 01ab
                                                            ; W = v____temp_96
                               movf     v____temp_96,w      ;  1 OV rS rS [?L ?L] 0999 082a
                                                            ; W = v____temp_96
                               datalo_clr v__pic_multiplier ;  1 OV rS rs [?L ?L] 099a 1283
                                                            ; W = v____temp_96
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?L ?L] 099b 00a0
                                                            ; W = v____temp_96
                               datalo_set v____temp_96      ;  1 OV rs rS [?L ?L] 099c 1683
                                                            ; W = v__pic_multiplier
                               movf     v____temp_96+1,w    ;  1 OV rS rS [?L ?L] 099d 082b
                                                            ; W = v__pic_multiplier
                               datalo_clr v__pic_multiplier ;  1 OV rS rs [?L ?L] 099e 1283
                                                            ; W = v____temp_96
                               movwf    v__pic_multiplier+1 ;  1 OV rs rs [?L ?L] 099f 00a1
                                                            ; W = v____temp_96
                               movlw    5                   ;  1 OV rs rs [?L ?L] 09a0 3005
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?L ?L] 09a1 00a2
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?L ?L] 09a2 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  1 OV rs rs [?L ?l] 09a3 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?l ??] 09a4 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 09a5 1283
                               datahi_clr v__pic_mresult    ;  1 OV ?s rs [?? ??] 09a6 1303
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 09a7 0824
                               datalo_set v____temp_96+2    ;  1 OV rs rS [?? ??] 09a8 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_96+2      ;  1 OV rS rS [?? ??] 09a9 00ac
                                                            ; W = v__pic_mresult
                               datalo_clr v__pic_mresult    ;  1 OV rS rs [?? ??] 09aa 1283
                                                            ; W = v____temp_96
                               movf     v__pic_mresult+1,w  ;  1 OV rs rs [?? ??] 09ab 0825
                                                            ; W = v____temp_96
                               datalo_set v____temp_96+2    ;  1 OV rs rS [?? ??] 09ac 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_96+3      ;  1 OV rS rS [?? ??] 09ad 00ad
                                                            ; W = v__pic_mresult
                               movf     v____temp_96+3,w    ;  1 OV rS rS [?? ??] 09ae 082d
                                                            ; W = v____temp_96
                               addwf    v___findex_2+1,f    ;  1 OV rS rS [?? ??] 09af 07a4
                                                            ; W = v____temp_96
                               movf     v____temp_96+2,w    ;  1 OV rS rS [?? ??] 09b0 082c
                                                            ; W = v____temp_96
                               addwf    v___findex_2,f      ;  1 OV rS rS [?? ??] 09b1 07a3
                                                            ; W = v____temp_96
                               btfsc    v__status, v__c     ;  1 OV rS rS [?? ??] 09b2 1803
                                                            ; W = v____temp_96
                               incf     v___findex_2+1,f    ;  1 OV rS rS [?? ??] 09b3 0aa4
                                                            ; W = v____temp_96
;  433 	for doLoop loop
                               clrf     v____floop7_2       ;  1 OV rS rS [?? ??] 09b4 01b1
                                                            ; W = v____temp_96
                               branchlo_set l__l866         ;  1 OV rS rS [?? ?L] 09b5 158a
                                                            ; W = v____temp_96
                               goto     l__l866             ;  1 OV rS rS [?L ?L] 09b6 2a43
                                                            ; W = v____temp_96
l__l856
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  434 		cx = myFontTable[fIndex]
                               movf     v___findex_2,w      ;  1 OV rS rS [?L ?L] 09b7 0823
                               datalo_clr v__pic_loop       ;  1 OV rS rs [?L ?L] 09b8 1283
                                                            ; W = v___findex_2
                               movwf    v__pic_loop         ;  1 OV rs rs [?L ?L] 09b9 00a8
                                                            ; W = v___findex_2
                               datalo_set v___findex_2      ;  1 OV rs rS [?L ?L] 09ba 1683
                                                            ; W = v__pic_loop
                               movf     v___findex_2+1,w    ;  1 OV rS rS [?L ?L] 09bb 0824
                                                            ; W = v__pic_loop
                               branchlo_clr l__lookup_myfonttable;  1 OV rS rS [?L ?l] 09bc 118a
                                                            ; W = v___findex_2
                               call     l__lookup_myfonttable;  1 OV rS ?? [?l ??] 09bd 2004
                                                            ; W = v___findex_2
                               datalo_set v___cx_2          ;  1 OV ?? ?S [?? ??] 09be 1683
                               datahi_clr v___cx_2          ;  1 OV ?S rS [?? ??] 09bf 1303
                               movwf    v___cx_2            ;  1 OV rS rS [?? ??] 09c0 00a7
;  435 		if debug then
                               branchlo_set l__l857         ;  1 OV rS rS [?? ?L] 09c1 158a
                                                            ; W = v___cx_2
                               btfss    v____bitbucket_4, 0 ; debug3;  1 OV rS rS [?L ?L] 09c2 1c20
                                                            ; W = v___cx_2
                               goto     l__l857             ;  1 OV rS rS [?L ?L] 09c3 29d4
                                                            ; W = v___cx_2
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  436 			serial_hw_byte(fIndex)
                               movf     v___findex_2,w      ;  1 OV rS rS [?L ?L] 09c4 0823
                               movwf    v___b_1             ;  1 OV rS rS [?L ?L] 09c5 00b6
                                                            ; W = v___findex_2
                               movf     v___findex_2+1,w    ;  1 OV rS rS [?L ?L] 09c6 0824
                                                            ; W = v___b_1
                               movwf    v___b_1+1           ;  1 OV rS rS [?L ?L] 09c7 00b7
                                                            ; W = v___findex_2
                               branchlo_clr l_serial_hw_byte;  1 OV rS rS [?L ?l] 09c8 118a
                                                            ; W = v___b_1
                               call     l_serial_hw_byte    ;  1 OV rS ?? [?l ??] 09c9 253e
                                                            ; W = v___b_1
;  437 			serial_hw_byte(cx)
                               datalo_set v___cx_2          ;  1 OV ?? ?S [?? ??] 09ca 1683
                               datahi_clr v___cx_2          ;  1 OV ?S rS [?? ??] 09cb 1303
                               movf     v___cx_2,w          ;  1 OV rS rS [?? ??] 09cc 0827
                               movwf    v___b_1             ;  1 OV rS rS [?? ??] 09cd 00b6
                                                            ; W = v___cx_2
                               clrf     v___b_1+1           ;  1 OV rS rS [?? ??] 09ce 01b7
                                                            ; W = v___b_1
                               branchlo_clr l_serial_hw_byte;  1 OV rS rS [?? ?l] 09cf 118a
                                                            ; W = v___b_1
                               call     l_serial_hw_byte    ;  1 OV rS ?? [?l ??] 09d0 253e
                                                            ; W = v___b_1
;  438 			serial_hw_write(0x0A)
                               movlw    10                  ;  1 OV ?? ?? [?? ??] 09d1 300a
                               branchlo_clr l_serial_hw_write;  1 OV ?? ?? [?? ?l] 09d2 118a
                               call     l_serial_hw_write   ;  1 OV ?? ?? [?l ??] 09d3 2519
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  439 		end if
l__l857
;  440 		_ks0108_inst()                          -- Set for instruction          
                               branchlo_clr l__ks0108_inst  ;  1 OV ?? ?? [?? ?l] 09d4 118a
                                                            ; W = v___cx_2
                               call     l__ks0108_inst      ;  1 OV ?? ?? [?l ??] 09d5 266f
                                                            ; W = v___cx_2
;  442 		if (x < 64) then
                               movlw    64                  ;  1 OV ?? ?? [?? ??] 09d6 3040
                               datalo_clr v___x_127         ;  1 OV ?? ?s [?? ??] 09d7 1283
                               datahi_clr v___x_127         ;  1 OV ?s rs [?? ??] 09d8 1303
                               subwf    v___x_127,w         ;  1 OV rs rs [?? ??] 09d9 026e
                               branchlo_set l__l861         ;  1 OV rs rs [?? ?L] 09da 158a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 09db 1903
                               goto     l__l861             ;  1 OV rs rs [?L ?L] 09dc 2a09
                               branchlo_nop l__l861         ;  1 OV rs rs [?L ?L] 09dd
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 09dd 1803
                               goto     l__l861             ;  1 OV rs rs [?L ?L] 09de 2a09
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
                               datalo_set v___side_30       ;  1 OV rs rS [?L ?L] 09df 1683
                               clrf     v___side_30         ;  1 OV rS rS [?L ?L] 09e0 01b3
                               movlw    64                  ;  1 OV rS rS [?L ?L] 09e1 3040
                               datalo_clr v___x_127         ;  1 OV rS rs [?L ?L] 09e2 1283
                               iorwf    v___x_127,w         ;  1 OV rs rs [?L ?L] 09e3 046e
                               datalo_set v____temp_97      ;  1 OV rs rS [?L ?L] 09e4 1683
                               movwf    v____temp_97        ;  1 OV rS rS [?L ?L] 09e5 00b4
                               movf     v____temp_97,w      ;  1 OV rS rS [?L ?L] 09e6 0834
                                                            ; W = v____temp_97
                               movwf    v___data_14         ;  1 OV rS rS [?L ?L] 09e7 00bb
                                                            ; W = v____temp_97
                               movf     v___side_30,w       ;  1 OV rS rS [?L ?L] 09e8 0833
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?L ?l] 09e9 118a
                                                            ; W = v___side_30
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 09ea 25e7
                                                            ; W = v___side_30
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 09eb 1003
                               datalo_clr v___y_11          ;  1 OV ?? ?s [?? ??] 09ec 1283
                               datahi_clr v___y_11          ;  1 OV ?s rs [?? ??] 09ed 1303
                               rrf      v___y_11,w          ;  1 OV rs rs [?? ??] 09ee 0c57
                               datalo_set v____rparam3_2    ;  1 OV rs rS [?? ??] 09ef 1683
                               movwf    v____rparam3_2      ;  1 OV rS rS [?? ??] 09f0 00b2
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 09f1 1003
                                                            ; W = v____rparam3_2
                               rrf      v____rparam3_2,f    ;  1 OV rS rS [?? ??] 09f2 0cb2
                                                            ; W = v____rparam3_2
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 09f3 1003
                               rrf      v____rparam3_2,f    ;  1 OV rS rS [?? ??] 09f4 0cb2
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               clrf     v___side_31         ;  1 OV rS rS [?? ??] 09f5 01b3
                               movlw    184                 ;  1 OV rS rS [?? ??] 09f6 30b8
                               iorwf    v____rparam3_2,w    ;  1 OV rS rS [?? ??] 09f7 0432
                               movwf    v____temp_98        ;  1 OV rS rS [?? ??] 09f8 00b4
                               movf     v____temp_98,w      ;  1 OV rS rS [?? ??] 09f9 0834
                                                            ; W = v____temp_98
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 09fa 00bb
                                                            ; W = v____temp_98
                               movf     v___side_31,w       ;  1 OV rS rS [?? ??] 09fb 0833
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 09fc 118a
                                                            ; W = v___side_31
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 09fd 25e7
                                                            ; W = v___side_31
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
;  445 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 09fe 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 09ff 2675
;  446 			_ks0108_write(KS0108_LEFT, cx)       -- Write the pixel data
                               datalo_set v___cx_2          ;  1 OV ?? ?S [?? ??] 0a00 1683
                               datahi_clr v___cx_2          ;  1 OV ?S rS [?? ??] 0a01 1303
                               movf     v___cx_2,w          ;  1 OV rS rS [?? ??] 0a02 0827
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0a03 00bb
                                                            ; W = v___cx_2
                               movlw    0                   ;  1 OV rS rS [?? ??] 0a04 3000
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0a05 118a
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0a06 25e7
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  447 		elsif (x < 128) then
                               branchlo_set l__l865         ;  1 OV ?? ?? [?? ?L] 0a07 158a
                               goto     l__l865             ;  1 OV ?? ?? [?L ?L] 0a08 2a3a
l__l861
                               movlw    128                 ;  1 OV rs rs [?L ?L] 0a09 3080
                               subwf    v___x_127,w         ;  1 OV rs rs [?L ?L] 0a0a 026e
                               branchlo_nop l__l864         ;  1 OV rs rs [?L ?L] 0a0b
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0a0b 1903
                               goto     l__l864             ;  1 OV rs rs [?L ?L] 0a0c 2a3a
                               branchlo_nop l__l864         ;  1 OV rs rs [?L ?L] 0a0d
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 0a0d 1803
                               goto     l__l864             ;  1 OV rs rs [?L ?L] 0a0e 2a3a
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    64                  ;  1 OV rs rs [?L ?L] 0a0f 3040
                               subwf    v___x_127,w         ;  1 OV rs rs [?L ?L] 0a10 026e
                               datalo_set v____rparam4_2    ;  1 OV rs rS [?L ?L] 0a11 1683
                               movwf    v____rparam4_2      ;  1 OV rS rS [?L ?L] 0a12 00b2
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    1                   ;  1 OV rS rS [?L ?L] 0a13 3001
                                                            ; W = v____rparam4_2
                               movwf    v___side_32         ;  1 OV rS rS [?L ?L] 0a14 00b4
                               movlw    64                  ;  1 OV rS rS [?L ?L] 0a15 3040
                                                            ; W = v___side_32
                               iorwf    v____rparam4_2,w    ;  1 OV rS rS [?L ?L] 0a16 0432
                               movwf    v____temp_99        ;  1 OV rS rS [?L ?L] 0a17 00b5
                               movf     v____temp_99,w      ;  1 OV rS rS [?L ?L] 0a18 0835
                                                            ; W = v____temp_99
                               movwf    v___data_14         ;  1 OV rS rS [?L ?L] 0a19 00bb
                                                            ; W = v____temp_99
                               movf     v___side_32,w       ;  1 OV rS rS [?L ?L] 0a1a 0834
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?L ?l] 0a1b 118a
                                                            ; W = v___side_32
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0a1c 25e7
                                                            ; W = v___side_32
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 0a1d 1003
                               datalo_clr v___y_11          ;  1 OV ?? ?s [?? ??] 0a1e 1283
                               datahi_clr v___y_11          ;  1 OV ?s rs [?? ??] 0a1f 1303
                               rrf      v___y_11,w          ;  1 OV rs rs [?? ??] 0a20 0c57
                               datalo_set v____rparam5_2    ;  1 OV rs rS [?? ??] 0a21 1683
                               movwf    v____rparam5_2      ;  1 OV rS rS [?? ??] 0a22 00b3
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0a23 1003
                                                            ; W = v____rparam5_2
                               rrf      v____rparam5_2,f    ;  1 OV rS rS [?? ??] 0a24 0cb3
                                                            ; W = v____rparam5_2
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0a25 1003
                               rrf      v____rparam5_2,f    ;  1 OV rS rS [?? ??] 0a26 0cb3
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               movlw    1                   ;  1 OV rS rS [?? ??] 0a27 3001
                               movwf    v___side_33         ;  1 OV rS rS [?? ??] 0a28 00b4
                               movlw    184                 ;  1 OV rS rS [?? ??] 0a29 30b8
                                                            ; W = v___side_33
                               iorwf    v____rparam5_2,w    ;  1 OV rS rS [?? ??] 0a2a 0433
                               movwf    v____temp_100       ;  1 OV rS rS [?? ??] 0a2b 00b5
                               movf     v____temp_100,w     ;  1 OV rS rS [?? ??] 0a2c 0835
                                                            ; W = v____temp_100
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0a2d 00bb
                                                            ; W = v____temp_100
                               movf     v___side_33,w       ;  1 OV rS rS [?? ??] 0a2e 0834
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0a2f 118a
                                                            ; W = v___side_33
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0a30 25e7
                                                            ; W = v___side_33
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
;  450 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 0a31 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 0a32 2675
;  451 			_ks0108_write(KS0108_RIGHT, cx)      -- Write the pixel data
                               datalo_set v___cx_2          ;  1 OV ?? ?S [?? ??] 0a33 1683
                               datahi_clr v___cx_2          ;  1 OV ?S rS [?? ??] 0a34 1303
                               movf     v___cx_2,w          ;  1 OV rS rS [?? ??] 0a35 0827
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0a36 00bb
                                                            ; W = v___cx_2
                               movlw    1                   ;  1 OV rS rS [?? ??] 0a37 3001
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0a38 118a
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0a39 25e7
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  452 		end if
l__l864
l__l865
;  455 		fIndex = fIndex + 1
                               datalo_set v___findex_2      ;  1 OV ?? ?S [?? ??] 0a3a 1683
                               datahi_clr v___findex_2      ;  1 OV ?S rS [?? ??] 0a3b 1303
                               incf     v___findex_2,f      ;  1 OV rS rS [?? ??] 0a3c 0aa3
                               btfsc    v__status, v__z     ;  1 OV rS rS [?? ??] 0a3d 1903
                               incf     v___findex_2+1,f    ;  1 OV rS rS [?? ??] 0a3e 0aa4
;  456 		x = x + 1
                               datalo_clr v___x_127         ;  1 OV rS rs [?? ??] 0a3f 1283
                               incf     v___x_127,f         ;  1 OV rs rs [?? ??] 0a40 0aee
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; glcd_ks0108.jal
;  457 	end loop
                               datalo_set v____floop7_2     ;  1 OV rs rS [?? ??] 0a41 1683
                               incf     v____floop7_2,f     ;  1 OV rS rS [?? ??] 0a42 0ab1
l__l866
                               movf     v____floop7_2,w     ;  1 OV rS rS [?? ??] 0a43 0831
                                                            ; W = v____temp_96
                               subwf    v___doloop_2,w      ;  1 OV rS rS [?? ??] 0a44 0228
                                                            ; W = v____floop7_2
                               branchlo_set l__l856         ;  1 OV rS rS [?? ?L] 0a45 158a
                               btfss    v__status, v__z     ;  1 OV rS rS [?L ?L] 0a46 1d03
                               goto     l__l856             ;  1 OV rS rS [?L ?L] 0a47 29b7
;  458 end procedure
l__l868
; glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
                               movlw    6                   ;  1 OV r? rs [?L ?L] 0a48 3006
                               datalo_clr v___x_126         ;  1 OV r? rs [?L ?L] 0a49 1283
                               addwf    v___x_126,w         ;  1 OV rs rs [?L ?L] 0a4a 0755
                               movwf    v____temp_95        ;  1 OV rs rs [?L ?L] 0a4b 00de
                               movlw    48                  ;  1 OV rs rs [?L ?L] 0a4c 3030
                                                            ; W = v____temp_95
                               addwf    v_tens,w            ;  1 OV rs rs [?L ?L] 0a4d 0767
                               movwf    v____temp_95+1      ;  1 OV rs rs [?L ?L] 0a4e 00df
                               movf     v____temp_95+1,w    ;  1 OV rs rs [?L ?L] 0a4f 085f
                                                            ; W = v____temp_95
                               movwf    v__rparam11         ;  1 OV rs rs [?L ?L] 0a50 00eb
                                                            ; W = v____temp_95
                               movf     v____temp_95,w      ;  1 OV rs rs [?L ?L] 0a51 085e
                                                            ; W = v__rparam11
                               movwf    v___x_128           ;  1 OV rs rs [?L ?L] 0a52 00ee
                                                            ; W = v____temp_95
                               datalo_set v____bitbucket_4 ; debug4;  1 OV rs rS [?L ?L] 0a53 1683
                                                            ; W = v___x_128
                               bcf      v____bitbucket_4, 0 ; debug4;  1 OV rS rS [?L ?L] 0a54 1020
                                                            ; W = v___x_128
; glcd_ks0108.jal
;  423 	var word fIndex = 0
                               clrf     v___findex_3        ;  1 OV rS rS [?L ?L] 0a55 01a3
                                                            ; W = v___x_128
                               clrf     v___findex_3+1      ;  1 OV rS rS [?L ?L] 0a56 01a4
                                                            ; W = v___x_128
;  424 	var byte cx = 0b10101010
                               movlw    170                 ;  1 OV rS rS [?L ?L] 0a57 30aa
                                                            ; W = v___x_128
                               movwf    v___cx_3            ;  1 OV rS rS [?L ?L] 0a58 00a7
;  425 	var byte doLoop = 5
                               movlw    5                   ;  1 OV rS rS [?L ?L] 0a59 3005
                                                            ; W = v___cx_3
                               movwf    v___doloop_3        ;  1 OV rS rS [?L ?L] 0a5a 00a8
;  426 	if (ch <  31) then return end if
                               movlw    31                  ;  1 OV rS rS [?L ?L] 0a5b 301f
                                                            ; W = v___doloop_3
                               datalo_clr v__rparam11       ;  1 OV rS rs [?L ?L] 0a5c 1283
                               subwf    v__rparam11,w       ;  1 OV rs rs [?L ?L] 0a5d 026b
                               branchlo_nop l__l869         ;  1 OV rs rs [?L ?L] 0a5e
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0a5e 1903
                               goto     l__l869             ;  1 OV rs rs [?L ?L] 0a5f 2a63
                               branchlo_nop l__l869         ;  1 OV rs rs [?L ?L] 0a60
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 0a60 1803
                               goto     l__l869             ;  1 OV rs rs [?L ?L] 0a61 2a63
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  426 	if (ch <  31) then return end if
                               branchlo_nop l__l885         ;  1 OV rs rs [?L ?L] 0a62
                               goto     l__l885             ;  1 OV rs rs [?L ?L] 0a62 2b1e
l__l869
;  427 	if (ch > 135) then return end if
                               movlw    135                 ;  1 OV rs rs [?L ?L] 0a63 3087
                               subwf    v__rparam11,w       ;  1 OV rs rs [?L ?L] 0a64 026b
                               branchlo_nop l__l871         ;  1 OV rs rs [?L ?L] 0a65
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0a65 1903
                               goto     l__l871             ;  1 OV rs rs [?L ?L] 0a66 2a6a
                               branchlo_nop l__l871         ;  1 OV rs rs [?L ?L] 0a67
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 0a67 1c03
                               goto     l__l871             ;  1 OV rs rs [?L ?L] 0a68 2a6a
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  427 	if (ch > 135) then return end if
                               branchlo_nop l__l885         ;  1 OV rs rs [?L ?L] 0a69
                               goto     l__l885             ;  1 OV rs rs [?L ?L] 0a69 2b1e
l__l871
;  430 	fIndex = fIndex + 5 * word(ch - 32)
                               movlw    32                  ;  1 OV rs rs [?L ?L] 0a6a 3020
                               subwf    v__rparam11,w       ;  1 OV rs rs [?L ?L] 0a6b 026b
                               datalo_set v____temp_101     ;  1 OV rs rS [?L ?L] 0a6c 1683
                               movwf    v____temp_101       ;  1 OV rS rS [?L ?L] 0a6d 00aa
                               clrf     v____temp_101+1     ;  1 OV rS rS [?L ?L] 0a6e 01ab
                                                            ; W = v____temp_101
                               movf     v____temp_101,w     ;  1 OV rS rS [?L ?L] 0a6f 082a
                                                            ; W = v____temp_101
                               datalo_clr v__pic_multiplier ;  1 OV rS rs [?L ?L] 0a70 1283
                                                            ; W = v____temp_101
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?L ?L] 0a71 00a0
                                                            ; W = v____temp_101
                               datalo_set v____temp_101     ;  1 OV rs rS [?L ?L] 0a72 1683
                                                            ; W = v__pic_multiplier
                               movf     v____temp_101+1,w   ;  1 OV rS rS [?L ?L] 0a73 082b
                                                            ; W = v__pic_multiplier
                               datalo_clr v__pic_multiplier ;  1 OV rS rs [?L ?L] 0a74 1283
                                                            ; W = v____temp_101
                               movwf    v__pic_multiplier+1 ;  1 OV rs rs [?L ?L] 0a75 00a1
                                                            ; W = v____temp_101
                               movlw    5                   ;  1 OV rs rs [?L ?L] 0a76 3005
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?L ?L] 0a77 00a2
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?L ?L] 0a78 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  1 OV rs rs [?L ?l] 0a79 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?l ??] 0a7a 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 0a7b 1283
                               datahi_clr v__pic_mresult    ;  1 OV ?s rs [?? ??] 0a7c 1303
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 0a7d 0824
                               datalo_set v____temp_101+2   ;  1 OV rs rS [?? ??] 0a7e 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_101+2     ;  1 OV rS rS [?? ??] 0a7f 00ac
                                                            ; W = v__pic_mresult
                               datalo_clr v__pic_mresult    ;  1 OV rS rs [?? ??] 0a80 1283
                                                            ; W = v____temp_101
                               movf     v__pic_mresult+1,w  ;  1 OV rs rs [?? ??] 0a81 0825
                                                            ; W = v____temp_101
                               datalo_set v____temp_101+2   ;  1 OV rs rS [?? ??] 0a82 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_101+3     ;  1 OV rS rS [?? ??] 0a83 00ad
                                                            ; W = v__pic_mresult
                               movf     v____temp_101+3,w   ;  1 OV rS rS [?? ??] 0a84 082d
                                                            ; W = v____temp_101
                               addwf    v___findex_3+1,f    ;  1 OV rS rS [?? ??] 0a85 07a4
                                                            ; W = v____temp_101
                               movf     v____temp_101+2,w   ;  1 OV rS rS [?? ??] 0a86 082c
                                                            ; W = v____temp_101
                               addwf    v___findex_3,f      ;  1 OV rS rS [?? ??] 0a87 07a3
                                                            ; W = v____temp_101
                               btfsc    v__status, v__c     ;  1 OV rS rS [?? ??] 0a88 1803
                                                            ; W = v____temp_101
                               incf     v___findex_3+1,f    ;  1 OV rS rS [?? ??] 0a89 0aa4
                                                            ; W = v____temp_101
;  433 	for doLoop loop
                               clrf     v____floop7_3       ;  1 OV rS rS [?? ??] 0a8a 01b1
                                                            ; W = v____temp_101
                               branchlo_set l__l883         ;  1 OV rS rS [?? ?L] 0a8b 158a
                                                            ; W = v____temp_101
                               goto     l__l883             ;  1 OV rS rS [?L ?L] 0a8c 2b19
                                                            ; W = v____temp_101
l__l873
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  434 		cx = myFontTable[fIndex]
                               movf     v___findex_3,w      ;  1 OV rS rS [?L ?L] 0a8d 0823
                               datalo_clr v__pic_loop       ;  1 OV rS rs [?L ?L] 0a8e 1283
                                                            ; W = v___findex_3
                               movwf    v__pic_loop         ;  1 OV rs rs [?L ?L] 0a8f 00a8
                                                            ; W = v___findex_3
                               datalo_set v___findex_3      ;  1 OV rs rS [?L ?L] 0a90 1683
                                                            ; W = v__pic_loop
                               movf     v___findex_3+1,w    ;  1 OV rS rS [?L ?L] 0a91 0824
                                                            ; W = v__pic_loop
                               branchlo_clr l__lookup_myfonttable;  1 OV rS rS [?L ?l] 0a92 118a
                                                            ; W = v___findex_3
                               call     l__lookup_myfonttable;  1 OV rS ?? [?l ??] 0a93 2004
                                                            ; W = v___findex_3
                               datalo_set v___cx_3          ;  1 OV ?? ?S [?? ??] 0a94 1683
                               datahi_clr v___cx_3          ;  1 OV ?S rS [?? ??] 0a95 1303
                               movwf    v___cx_3            ;  1 OV rS rS [?? ??] 0a96 00a7
;  435 		if debug then
                               branchlo_set l__l874         ;  1 OV rS rS [?? ?L] 0a97 158a
                                                            ; W = v___cx_3
                               btfss    v____bitbucket_4, 0 ; debug4;  1 OV rS rS [?L ?L] 0a98 1c20
                                                            ; W = v___cx_3
                               goto     l__l874             ;  1 OV rS rS [?L ?L] 0a99 2aaa
                                                            ; W = v___cx_3
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  436 			serial_hw_byte(fIndex)
                               movf     v___findex_3,w      ;  1 OV rS rS [?L ?L] 0a9a 0823
                               movwf    v___b_1             ;  1 OV rS rS [?L ?L] 0a9b 00b6
                                                            ; W = v___findex_3
                               movf     v___findex_3+1,w    ;  1 OV rS rS [?L ?L] 0a9c 0824
                                                            ; W = v___b_1
                               movwf    v___b_1+1           ;  1 OV rS rS [?L ?L] 0a9d 00b7
                                                            ; W = v___findex_3
                               branchlo_clr l_serial_hw_byte;  1 OV rS rS [?L ?l] 0a9e 118a
                                                            ; W = v___b_1
                               call     l_serial_hw_byte    ;  1 OV rS ?? [?l ??] 0a9f 253e
                                                            ; W = v___b_1
;  437 			serial_hw_byte(cx)
                               datalo_set v___cx_3          ;  1 OV ?? ?S [?? ??] 0aa0 1683
                               datahi_clr v___cx_3          ;  1 OV ?S rS [?? ??] 0aa1 1303
                               movf     v___cx_3,w          ;  1 OV rS rS [?? ??] 0aa2 0827
                               movwf    v___b_1             ;  1 OV rS rS [?? ??] 0aa3 00b6
                                                            ; W = v___cx_3
                               clrf     v___b_1+1           ;  1 OV rS rS [?? ??] 0aa4 01b7
                                                            ; W = v___b_1
                               branchlo_clr l_serial_hw_byte;  1 OV rS rS [?? ?l] 0aa5 118a
                                                            ; W = v___b_1
                               call     l_serial_hw_byte    ;  1 OV rS ?? [?l ??] 0aa6 253e
                                                            ; W = v___b_1
;  438 			serial_hw_write(0x0A)
                               movlw    10                  ;  1 OV ?? ?? [?? ??] 0aa7 300a
                               branchlo_clr l_serial_hw_write;  1 OV ?? ?? [?? ?l] 0aa8 118a
                               call     l_serial_hw_write   ;  1 OV ?? ?? [?l ??] 0aa9 2519
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  439 		end if
l__l874
;  440 		_ks0108_inst()                          -- Set for instruction          
                               branchlo_clr l__ks0108_inst  ;  1 OV ?? ?? [?? ?l] 0aaa 118a
                                                            ; W = v___cx_3
                               call     l__ks0108_inst      ;  1 OV ?? ?? [?l ??] 0aab 266f
                                                            ; W = v___cx_3
;  442 		if (x < 64) then
                               movlw    64                  ;  1 OV ?? ?? [?? ??] 0aac 3040
                               datalo_clr v___x_128         ;  1 OV ?? ?s [?? ??] 0aad 1283
                               datahi_clr v___x_128         ;  1 OV ?s rs [?? ??] 0aae 1303
                               subwf    v___x_128,w         ;  1 OV rs rs [?? ??] 0aaf 026e
                               branchlo_set l__l878         ;  1 OV rs rs [?? ?L] 0ab0 158a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0ab1 1903
                               goto     l__l878             ;  1 OV rs rs [?L ?L] 0ab2 2adf
                               branchlo_nop l__l878         ;  1 OV rs rs [?L ?L] 0ab3
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 0ab3 1803
                               goto     l__l878             ;  1 OV rs rs [?L ?L] 0ab4 2adf
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
                               datalo_set v___side_34       ;  1 OV rs rS [?L ?L] 0ab5 1683
                               clrf     v___side_34         ;  1 OV rS rS [?L ?L] 0ab6 01b3
                               movlw    64                  ;  1 OV rS rS [?L ?L] 0ab7 3040
                               datalo_clr v___x_128         ;  1 OV rS rs [?L ?L] 0ab8 1283
                               iorwf    v___x_128,w         ;  1 OV rs rs [?L ?L] 0ab9 046e
                               datalo_set v____temp_102     ;  1 OV rs rS [?L ?L] 0aba 1683
                               movwf    v____temp_102       ;  1 OV rS rS [?L ?L] 0abb 00b4
                               movf     v____temp_102,w     ;  1 OV rS rS [?L ?L] 0abc 0834
                                                            ; W = v____temp_102
                               movwf    v___data_14         ;  1 OV rS rS [?L ?L] 0abd 00bb
                                                            ; W = v____temp_102
                               movf     v___side_34,w       ;  1 OV rS rS [?L ?L] 0abe 0833
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?L ?l] 0abf 118a
                                                            ; W = v___side_34
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0ac0 25e7
                                                            ; W = v___side_34
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 0ac1 1003
                               datalo_clr v___y_11          ;  1 OV ?? ?s [?? ??] 0ac2 1283
                               datahi_clr v___y_11          ;  1 OV ?s rs [?? ??] 0ac3 1303
                               rrf      v___y_11,w          ;  1 OV rs rs [?? ??] 0ac4 0c57
                               datalo_set v____rparam3_3    ;  1 OV rs rS [?? ??] 0ac5 1683
                               movwf    v____rparam3_3      ;  1 OV rS rS [?? ??] 0ac6 00b2
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0ac7 1003
                                                            ; W = v____rparam3_3
                               rrf      v____rparam3_3,f    ;  1 OV rS rS [?? ??] 0ac8 0cb2
                                                            ; W = v____rparam3_3
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0ac9 1003
                               rrf      v____rparam3_3,f    ;  1 OV rS rS [?? ??] 0aca 0cb2
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               clrf     v___side_35         ;  1 OV rS rS [?? ??] 0acb 01b3
                               movlw    184                 ;  1 OV rS rS [?? ??] 0acc 30b8
                               iorwf    v____rparam3_3,w    ;  1 OV rS rS [?? ??] 0acd 0432
                               movwf    v____temp_103       ;  1 OV rS rS [?? ??] 0ace 00b4
                               movf     v____temp_103,w     ;  1 OV rS rS [?? ??] 0acf 0834
                                                            ; W = v____temp_103
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0ad0 00bb
                                                            ; W = v____temp_103
                               movf     v___side_35,w       ;  1 OV rS rS [?? ??] 0ad1 0833
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0ad2 118a
                                                            ; W = v___side_35
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0ad3 25e7
                                                            ; W = v___side_35
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
;  445 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 0ad4 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 0ad5 2675
;  446 			_ks0108_write(KS0108_LEFT, cx)       -- Write the pixel data
                               datalo_set v___cx_3          ;  1 OV ?? ?S [?? ??] 0ad6 1683
                               datahi_clr v___cx_3          ;  1 OV ?S rS [?? ??] 0ad7 1303
                               movf     v___cx_3,w          ;  1 OV rS rS [?? ??] 0ad8 0827
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0ad9 00bb
                                                            ; W = v___cx_3
                               movlw    0                   ;  1 OV rS rS [?? ??] 0ada 3000
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0adb 118a
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0adc 25e7
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  447 		elsif (x < 128) then
                               branchlo_set l__l882         ;  1 OV ?? ?? [?? ?L] 0add 158a
                               goto     l__l882             ;  1 OV ?? ?? [?L ?L] 0ade 2b10
l__l878
                               movlw    128                 ;  1 OV rs rs [?L ?L] 0adf 3080
                               subwf    v___x_128,w         ;  1 OV rs rs [?L ?L] 0ae0 026e
                               branchlo_nop l__l881         ;  1 OV rs rs [?L ?L] 0ae1
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0ae1 1903
                               goto     l__l881             ;  1 OV rs rs [?L ?L] 0ae2 2b10
                               branchlo_nop l__l881         ;  1 OV rs rs [?L ?L] 0ae3
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 0ae3 1803
                               goto     l__l881             ;  1 OV rs rs [?L ?L] 0ae4 2b10
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    64                  ;  1 OV rs rs [?L ?L] 0ae5 3040
                               subwf    v___x_128,w         ;  1 OV rs rs [?L ?L] 0ae6 026e
                               datalo_set v____rparam4_3    ;  1 OV rs rS [?L ?L] 0ae7 1683
                               movwf    v____rparam4_3      ;  1 OV rS rS [?L ?L] 0ae8 00b2
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    1                   ;  1 OV rS rS [?L ?L] 0ae9 3001
                                                            ; W = v____rparam4_3
                               movwf    v___side_36         ;  1 OV rS rS [?L ?L] 0aea 00b4
                               movlw    64                  ;  1 OV rS rS [?L ?L] 0aeb 3040
                                                            ; W = v___side_36
                               iorwf    v____rparam4_3,w    ;  1 OV rS rS [?L ?L] 0aec 0432
                               movwf    v____temp_104       ;  1 OV rS rS [?L ?L] 0aed 00b5
                               movf     v____temp_104,w     ;  1 OV rS rS [?L ?L] 0aee 0835
                                                            ; W = v____temp_104
                               movwf    v___data_14         ;  1 OV rS rS [?L ?L] 0aef 00bb
                                                            ; W = v____temp_104
                               movf     v___side_36,w       ;  1 OV rS rS [?L ?L] 0af0 0834
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?L ?l] 0af1 118a
                                                            ; W = v___side_36
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0af2 25e7
                                                            ; W = v___side_36
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 0af3 1003
                               datalo_clr v___y_11          ;  1 OV ?? ?s [?? ??] 0af4 1283
                               datahi_clr v___y_11          ;  1 OV ?s rs [?? ??] 0af5 1303
                               rrf      v___y_11,w          ;  1 OV rs rs [?? ??] 0af6 0c57
                               datalo_set v____rparam5_3    ;  1 OV rs rS [?? ??] 0af7 1683
                               movwf    v____rparam5_3      ;  1 OV rS rS [?? ??] 0af8 00b3
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0af9 1003
                                                            ; W = v____rparam5_3
                               rrf      v____rparam5_3,f    ;  1 OV rS rS [?? ??] 0afa 0cb3
                                                            ; W = v____rparam5_3
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0afb 1003
                               rrf      v____rparam5_3,f    ;  1 OV rS rS [?? ??] 0afc 0cb3
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               movlw    1                   ;  1 OV rS rS [?? ??] 0afd 3001
                               movwf    v___side_37         ;  1 OV rS rS [?? ??] 0afe 00b4
                               movlw    184                 ;  1 OV rS rS [?? ??] 0aff 30b8
                                                            ; W = v___side_37
                               iorwf    v____rparam5_3,w    ;  1 OV rS rS [?? ??] 0b00 0433
                               movwf    v____temp_105       ;  1 OV rS rS [?? ??] 0b01 00b5
                               movf     v____temp_105,w     ;  1 OV rS rS [?? ??] 0b02 0835
                                                            ; W = v____temp_105
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0b03 00bb
                                                            ; W = v____temp_105
                               movf     v___side_37,w       ;  1 OV rS rS [?? ??] 0b04 0834
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0b05 118a
                                                            ; W = v___side_37
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0b06 25e7
                                                            ; W = v___side_37
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
;  450 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 0b07 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 0b08 2675
;  451 			_ks0108_write(KS0108_RIGHT, cx)      -- Write the pixel data
                               datalo_set v___cx_3          ;  1 OV ?? ?S [?? ??] 0b09 1683
                               datahi_clr v___cx_3          ;  1 OV ?S rS [?? ??] 0b0a 1303
                               movf     v___cx_3,w          ;  1 OV rS rS [?? ??] 0b0b 0827
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0b0c 00bb
                                                            ; W = v___cx_3
                               movlw    1                   ;  1 OV rS rS [?? ??] 0b0d 3001
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0b0e 118a
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0b0f 25e7
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  452 		end if
l__l881
l__l882
;  455 		fIndex = fIndex + 1
                               datalo_set v___findex_3      ;  1 OV ?? ?S [?? ??] 0b10 1683
                               datahi_clr v___findex_3      ;  1 OV ?S rS [?? ??] 0b11 1303
                               incf     v___findex_3,f      ;  1 OV rS rS [?? ??] 0b12 0aa3
                               btfsc    v__status, v__z     ;  1 OV rS rS [?? ??] 0b13 1903
                               incf     v___findex_3+1,f    ;  1 OV rS rS [?? ??] 0b14 0aa4
;  456 		x = x + 1
                               datalo_clr v___x_128         ;  1 OV rS rs [?? ??] 0b15 1283
                               incf     v___x_128,f         ;  1 OV rs rs [?? ??] 0b16 0aee
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; glcd_ks0108.jal
;  457 	end loop
                               datalo_set v____floop7_3     ;  1 OV rs rS [?? ??] 0b17 1683
                               incf     v____floop7_3,f     ;  1 OV rS rS [?? ??] 0b18 0ab1
l__l883
                               movf     v____floop7_3,w     ;  1 OV rS rS [?? ??] 0b19 0831
                                                            ; W = v____temp_101
                               subwf    v___doloop_3,w      ;  1 OV rS rS [?? ??] 0b1a 0228
                                                            ; W = v____floop7_3
                               branchlo_set l__l873         ;  1 OV rS rS [?? ?L] 0b1b 158a
                               btfss    v__status, v__z     ;  1 OV rS rS [?L ?L] 0b1c 1d03
                               goto     l__l873             ;  1 OV rS rS [?L ?L] 0b1d 2a8d
;  458 end procedure
l__l885
; glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
                               movlw    12                  ;  1 OV r? rs [?L ?L] 0b1e 300c
                               datalo_clr v___x_126         ;  1 OV r? rs [?L ?L] 0b1f 1283
                               addwf    v___x_126,w         ;  1 OV rs rs [?L ?L] 0b20 0755
                               movwf    v____temp_95        ;  1 OV rs rs [?L ?L] 0b21 00de
                               movlw    48                  ;  1 OV rs rs [?L ?L] 0b22 3030
                                                            ; W = v____temp_95
                               addwf    v_ones,w            ;  1 OV rs rs [?L ?L] 0b23 0768
                               movwf    v____temp_95+1      ;  1 OV rs rs [?L ?L] 0b24 00df
                               movf     v____temp_95+1,w    ;  1 OV rs rs [?L ?L] 0b25 085f
                                                            ; W = v____temp_95
                               movwf    v__rparam13         ;  1 OV rs rs [?L ?L] 0b26 00ed
                                                            ; W = v____temp_95
                               movf     v____temp_95,w      ;  1 OV rs rs [?L ?L] 0b27 085e
                                                            ; W = v__rparam13
                               movwf    v___x_129           ;  1 OV rs rs [?L ?L] 0b28 00ee
                                                            ; W = v____temp_95
                               datalo_set v____bitbucket_4 ; debug5;  1 OV rs rS [?L ?L] 0b29 1683
                                                            ; W = v___x_129
                               bcf      v____bitbucket_4, 0 ; debug5;  1 OV rS rS [?L ?L] 0b2a 1020
                                                            ; W = v___x_129
; glcd_ks0108.jal
;  423 	var word fIndex = 0
                               clrf     v___findex_4        ;  1 OV rS rS [?L ?L] 0b2b 01a3
                                                            ; W = v___x_129
                               clrf     v___findex_4+1      ;  1 OV rS rS [?L ?L] 0b2c 01a4
                                                            ; W = v___x_129
;  424 	var byte cx = 0b10101010
                               movlw    170                 ;  1 OV rS rS [?L ?L] 0b2d 30aa
                                                            ; W = v___x_129
                               movwf    v___cx_4            ;  1 OV rS rS [?L ?L] 0b2e 00a7
;  425 	var byte doLoop = 5
                               movlw    5                   ;  1 OV rS rS [?L ?L] 0b2f 3005
                                                            ; W = v___cx_4
                               movwf    v___doloop_4        ;  1 OV rS rS [?L ?L] 0b30 00a8
;  426 	if (ch <  31) then return end if
                               movlw    31                  ;  1 OV rS rS [?L ?L] 0b31 301f
                                                            ; W = v___doloop_4
                               datalo_clr v__rparam13       ;  1 OV rS rs [?L ?L] 0b32 1283
                               subwf    v__rparam13,w       ;  1 OV rs rs [?L ?L] 0b33 026d
                               branchlo_nop l__l886         ;  1 OV rs rs [?L ?L] 0b34
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0b34 1903
                               goto     l__l886             ;  1 OV rs rs [?L ?L] 0b35 2b39
                               branchlo_nop l__l886         ;  1 OV rs rs [?L ?L] 0b36
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 0b36 1803
                               goto     l__l886             ;  1 OV rs rs [?L ?L] 0b37 2b39
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  426 	if (ch <  31) then return end if
                               return                       ;  1 OV rs rs [?L ?L] 0b38 0008
l__l886
;  427 	if (ch > 135) then return end if
                               movlw    135                 ;  1 OV rs rs [?L ?L] 0b39 3087
                               subwf    v__rparam13,w       ;  1 OV rs rs [?L ?L] 0b3a 026d
                               branchlo_nop l__l888         ;  1 OV rs rs [?L ?L] 0b3b
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0b3b 1903
                               goto     l__l888             ;  1 OV rs rs [?L ?L] 0b3c 2b40
                               branchlo_nop l__l888         ;  1 OV rs rs [?L ?L] 0b3d
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 0b3d 1c03
                               goto     l__l888             ;  1 OV rs rs [?L ?L] 0b3e 2b40
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  427 	if (ch > 135) then return end if
                               return                       ;  1 OV rs rs [?L ?L] 0b3f 0008
l__l888
;  430 	fIndex = fIndex + 5 * word(ch - 32)
                               movlw    32                  ;  1 OV rs rs [?L ?L] 0b40 3020
                               subwf    v__rparam13,w       ;  1 OV rs rs [?L ?L] 0b41 026d
                               datalo_set v____temp_106     ;  1 OV rs rS [?L ?L] 0b42 1683
                               movwf    v____temp_106       ;  1 OV rS rS [?L ?L] 0b43 00aa
                               clrf     v____temp_106+1     ;  1 OV rS rS [?L ?L] 0b44 01ab
                                                            ; W = v____temp_106
                               movf     v____temp_106,w     ;  1 OV rS rS [?L ?L] 0b45 082a
                                                            ; W = v____temp_106
                               datalo_clr v__pic_multiplier ;  1 OV rS rs [?L ?L] 0b46 1283
                                                            ; W = v____temp_106
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?L ?L] 0b47 00a0
                                                            ; W = v____temp_106
                               datalo_set v____temp_106     ;  1 OV rs rS [?L ?L] 0b48 1683
                                                            ; W = v__pic_multiplier
                               movf     v____temp_106+1,w   ;  1 OV rS rS [?L ?L] 0b49 082b
                                                            ; W = v__pic_multiplier
                               datalo_clr v__pic_multiplier ;  1 OV rS rs [?L ?L] 0b4a 1283
                                                            ; W = v____temp_106
                               movwf    v__pic_multiplier+1 ;  1 OV rs rs [?L ?L] 0b4b 00a1
                                                            ; W = v____temp_106
                               movlw    5                   ;  1 OV rs rs [?L ?L] 0b4c 3005
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?L ?L] 0b4d 00a2
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?L ?L] 0b4e 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  1 OV rs rs [?L ?l] 0b4f 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?l ??] 0b50 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 0b51 1283
                               datahi_clr v__pic_mresult    ;  1 OV ?s rs [?? ??] 0b52 1303
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 0b53 0824
                               datalo_set v____temp_106+2   ;  1 OV rs rS [?? ??] 0b54 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_106+2     ;  1 OV rS rS [?? ??] 0b55 00ac
                                                            ; W = v__pic_mresult
                               datalo_clr v__pic_mresult    ;  1 OV rS rs [?? ??] 0b56 1283
                                                            ; W = v____temp_106
                               movf     v__pic_mresult+1,w  ;  1 OV rs rs [?? ??] 0b57 0825
                                                            ; W = v____temp_106
                               datalo_set v____temp_106+2   ;  1 OV rs rS [?? ??] 0b58 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_106+3     ;  1 OV rS rS [?? ??] 0b59 00ad
                                                            ; W = v__pic_mresult
                               movf     v____temp_106+3,w   ;  1 OV rS rS [?? ??] 0b5a 082d
                                                            ; W = v____temp_106
                               addwf    v___findex_4+1,f    ;  1 OV rS rS [?? ??] 0b5b 07a4
                                                            ; W = v____temp_106
                               movf     v____temp_106+2,w   ;  1 OV rS rS [?? ??] 0b5c 082c
                                                            ; W = v____temp_106
                               addwf    v___findex_4,f      ;  1 OV rS rS [?? ??] 0b5d 07a3
                                                            ; W = v____temp_106
                               btfsc    v__status, v__c     ;  1 OV rS rS [?? ??] 0b5e 1803
                                                            ; W = v____temp_106
                               incf     v___findex_4+1,f    ;  1 OV rS rS [?? ??] 0b5f 0aa4
                                                            ; W = v____temp_106
;  433 	for doLoop loop
                               clrf     v____floop7_4       ;  1 OV rS rS [?? ??] 0b60 01b1
                                                            ; W = v____temp_106
                               branchlo_set l__l900         ;  1 OV rS rS [?? ?L] 0b61 158a
                                                            ; W = v____temp_106
                               goto     l__l900             ;  1 OV rS rS [?L ?L] 0b62 2bef
                                                            ; W = v____temp_106
l__l890
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  434 		cx = myFontTable[fIndex]
                               movf     v___findex_4,w      ;  1 OV rS rS [?L ?L] 0b63 0823
                               datalo_clr v__pic_loop       ;  1 OV rS rs [?L ?L] 0b64 1283
                                                            ; W = v___findex_4
                               movwf    v__pic_loop         ;  1 OV rs rs [?L ?L] 0b65 00a8
                                                            ; W = v___findex_4
                               datalo_set v___findex_4      ;  1 OV rs rS [?L ?L] 0b66 1683
                                                            ; W = v__pic_loop
                               movf     v___findex_4+1,w    ;  1 OV rS rS [?L ?L] 0b67 0824
                                                            ; W = v__pic_loop
                               branchlo_clr l__lookup_myfonttable;  1 OV rS rS [?L ?l] 0b68 118a
                                                            ; W = v___findex_4
                               call     l__lookup_myfonttable;  1 OV rS ?? [?l ??] 0b69 2004
                                                            ; W = v___findex_4
                               datalo_set v___cx_4          ;  1 OV ?? ?S [?? ??] 0b6a 1683
                               datahi_clr v___cx_4          ;  1 OV ?S rS [?? ??] 0b6b 1303
                               movwf    v___cx_4            ;  1 OV rS rS [?? ??] 0b6c 00a7
;  435 		if debug then
                               branchlo_set l__l891         ;  1 OV rS rS [?? ?L] 0b6d 158a
                                                            ; W = v___cx_4
                               btfss    v____bitbucket_4, 0 ; debug5;  1 OV rS rS [?L ?L] 0b6e 1c20
                                                            ; W = v___cx_4
                               goto     l__l891             ;  1 OV rS rS [?L ?L] 0b6f 2b80
                                                            ; W = v___cx_4
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  436 			serial_hw_byte(fIndex)
                               movf     v___findex_4,w      ;  1 OV rS rS [?L ?L] 0b70 0823
                               movwf    v___b_1             ;  1 OV rS rS [?L ?L] 0b71 00b6
                                                            ; W = v___findex_4
                               movf     v___findex_4+1,w    ;  1 OV rS rS [?L ?L] 0b72 0824
                                                            ; W = v___b_1
                               movwf    v___b_1+1           ;  1 OV rS rS [?L ?L] 0b73 00b7
                                                            ; W = v___findex_4
                               branchlo_clr l_serial_hw_byte;  1 OV rS rS [?L ?l] 0b74 118a
                                                            ; W = v___b_1
                               call     l_serial_hw_byte    ;  1 OV rS ?? [?l ??] 0b75 253e
                                                            ; W = v___b_1
;  437 			serial_hw_byte(cx)
                               datalo_set v___cx_4          ;  1 OV ?? ?S [?? ??] 0b76 1683
                               datahi_clr v___cx_4          ;  1 OV ?S rS [?? ??] 0b77 1303
                               movf     v___cx_4,w          ;  1 OV rS rS [?? ??] 0b78 0827
                               movwf    v___b_1             ;  1 OV rS rS [?? ??] 0b79 00b6
                                                            ; W = v___cx_4
                               clrf     v___b_1+1           ;  1 OV rS rS [?? ??] 0b7a 01b7
                                                            ; W = v___b_1
                               branchlo_clr l_serial_hw_byte;  1 OV rS rS [?? ?l] 0b7b 118a
                                                            ; W = v___b_1
                               call     l_serial_hw_byte    ;  1 OV rS ?? [?l ??] 0b7c 253e
                                                            ; W = v___b_1
;  438 			serial_hw_write(0x0A)
                               movlw    10                  ;  1 OV ?? ?? [?? ??] 0b7d 300a
                               branchlo_clr l_serial_hw_write;  1 OV ?? ?? [?? ?l] 0b7e 118a
                               call     l_serial_hw_write   ;  1 OV ?? ?? [?l ??] 0b7f 2519
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  439 		end if
l__l891
;  440 		_ks0108_inst()                          -- Set for instruction          
                               branchlo_clr l__ks0108_inst  ;  1 OV ?? ?? [?? ?l] 0b80 118a
                                                            ; W = v___cx_4
                               call     l__ks0108_inst      ;  1 OV ?? ?? [?l ??] 0b81 266f
                                                            ; W = v___cx_4
;  442 		if (x < 64) then
                               movlw    64                  ;  1 OV ?? ?? [?? ??] 0b82 3040
                               datalo_clr v___x_129         ;  1 OV ?? ?s [?? ??] 0b83 1283
                               datahi_clr v___x_129         ;  1 OV ?s rs [?? ??] 0b84 1303
                               subwf    v___x_129,w         ;  1 OV rs rs [?? ??] 0b85 026e
                               branchlo_set l__l895         ;  1 OV rs rs [?? ?L] 0b86 158a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0b87 1903
                               goto     l__l895             ;  1 OV rs rs [?L ?L] 0b88 2bb5
                               branchlo_nop l__l895         ;  1 OV rs rs [?L ?L] 0b89
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 0b89 1803
                               goto     l__l895             ;  1 OV rs rs [?L ?L] 0b8a 2bb5
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
                               datalo_set v___side_38       ;  1 OV rs rS [?L ?L] 0b8b 1683
                               clrf     v___side_38         ;  1 OV rS rS [?L ?L] 0b8c 01b3
                               movlw    64                  ;  1 OV rS rS [?L ?L] 0b8d 3040
                               datalo_clr v___x_129         ;  1 OV rS rs [?L ?L] 0b8e 1283
                               iorwf    v___x_129,w         ;  1 OV rs rs [?L ?L] 0b8f 046e
                               datalo_set v____temp_107     ;  1 OV rs rS [?L ?L] 0b90 1683
                               movwf    v____temp_107       ;  1 OV rS rS [?L ?L] 0b91 00b4
                               movf     v____temp_107,w     ;  1 OV rS rS [?L ?L] 0b92 0834
                                                            ; W = v____temp_107
                               movwf    v___data_14         ;  1 OV rS rS [?L ?L] 0b93 00bb
                                                            ; W = v____temp_107
                               movf     v___side_38,w       ;  1 OV rS rS [?L ?L] 0b94 0833
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?L ?l] 0b95 118a
                                                            ; W = v___side_38
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0b96 25e7
                                                            ; W = v___side_38
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 0b97 1003
                               datalo_clr v___y_11          ;  1 OV ?? ?s [?? ??] 0b98 1283
                               datahi_clr v___y_11          ;  1 OV ?s rs [?? ??] 0b99 1303
                               rrf      v___y_11,w          ;  1 OV rs rs [?? ??] 0b9a 0c57
                               datalo_set v____rparam3_4    ;  1 OV rs rS [?? ??] 0b9b 1683
                               movwf    v____rparam3_4      ;  1 OV rS rS [?? ??] 0b9c 00b2
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0b9d 1003
                                                            ; W = v____rparam3_4
                               rrf      v____rparam3_4,f    ;  1 OV rS rS [?? ??] 0b9e 0cb2
                                                            ; W = v____rparam3_4
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0b9f 1003
                               rrf      v____rparam3_4,f    ;  1 OV rS rS [?? ??] 0ba0 0cb2
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               clrf     v___side_39         ;  1 OV rS rS [?? ??] 0ba1 01b3
                               movlw    184                 ;  1 OV rS rS [?? ??] 0ba2 30b8
                               iorwf    v____rparam3_4,w    ;  1 OV rS rS [?? ??] 0ba3 0432
                               movwf    v____temp_108       ;  1 OV rS rS [?? ??] 0ba4 00b4
                               movf     v____temp_108,w     ;  1 OV rS rS [?? ??] 0ba5 0834
                                                            ; W = v____temp_108
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0ba6 00bb
                                                            ; W = v____temp_108
                               movf     v___side_39,w       ;  1 OV rS rS [?? ??] 0ba7 0833
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0ba8 118a
                                                            ; W = v___side_39
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0ba9 25e7
                                                            ; W = v___side_39
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
;  445 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 0baa 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 0bab 2675
;  446 			_ks0108_write(KS0108_LEFT, cx)       -- Write the pixel data
                               datalo_set v___cx_4          ;  1 OV ?? ?S [?? ??] 0bac 1683
                               datahi_clr v___cx_4          ;  1 OV ?S rS [?? ??] 0bad 1303
                               movf     v___cx_4,w          ;  1 OV rS rS [?? ??] 0bae 0827
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0baf 00bb
                                                            ; W = v___cx_4
                               movlw    0                   ;  1 OV rS rS [?? ??] 0bb0 3000
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0bb1 118a
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0bb2 25e7
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  447 		elsif (x < 128) then
                               branchlo_set l__l899         ;  1 OV ?? ?? [?? ?L] 0bb3 158a
                               goto     l__l899             ;  1 OV ?? ?? [?L ?L] 0bb4 2be6
l__l895
                               movlw    128                 ;  1 OV rs rs [?L ?L] 0bb5 3080
                               subwf    v___x_129,w         ;  1 OV rs rs [?L ?L] 0bb6 026e
                               branchlo_nop l__l898         ;  1 OV rs rs [?L ?L] 0bb7
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0bb7 1903
                               goto     l__l898             ;  1 OV rs rs [?L ?L] 0bb8 2be6
                               branchlo_nop l__l898         ;  1 OV rs rs [?L ?L] 0bb9
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 0bb9 1803
                               goto     l__l898             ;  1 OV rs rs [?L ?L] 0bba 2be6
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    64                  ;  1 OV rs rs [?L ?L] 0bbb 3040
                               subwf    v___x_129,w         ;  1 OV rs rs [?L ?L] 0bbc 026e
                               datalo_set v____rparam4_4    ;  1 OV rs rS [?L ?L] 0bbd 1683
                               movwf    v____rparam4_4      ;  1 OV rS rS [?L ?L] 0bbe 00b2
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    1                   ;  1 OV rS rS [?L ?L] 0bbf 3001
                                                            ; W = v____rparam4_4
                               movwf    v___side_40         ;  1 OV rS rS [?L ?L] 0bc0 00b4
                               movlw    64                  ;  1 OV rS rS [?L ?L] 0bc1 3040
                                                            ; W = v___side_40
                               iorwf    v____rparam4_4,w    ;  1 OV rS rS [?L ?L] 0bc2 0432
                               movwf    v____temp_109       ;  1 OV rS rS [?L ?L] 0bc3 00b5
                               movf     v____temp_109,w     ;  1 OV rS rS [?L ?L] 0bc4 0835
                                                            ; W = v____temp_109
                               movwf    v___data_14         ;  1 OV rS rS [?L ?L] 0bc5 00bb
                                                            ; W = v____temp_109
                               movf     v___side_40,w       ;  1 OV rS rS [?L ?L] 0bc6 0834
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?L ?l] 0bc7 118a
                                                            ; W = v___side_40
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0bc8 25e7
                                                            ; W = v___side_40
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 0bc9 1003
                               datalo_clr v___y_11          ;  1 OV ?? ?s [?? ??] 0bca 1283
                               datahi_clr v___y_11          ;  1 OV ?s rs [?? ??] 0bcb 1303
                               rrf      v___y_11,w          ;  1 OV rs rs [?? ??] 0bcc 0c57
                               datalo_set v____rparam5_4    ;  1 OV rs rS [?? ??] 0bcd 1683
                               movwf    v____rparam5_4      ;  1 OV rS rS [?? ??] 0bce 00b3
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0bcf 1003
                                                            ; W = v____rparam5_4
                               rrf      v____rparam5_4,f    ;  1 OV rS rS [?? ??] 0bd0 0cb3
                                                            ; W = v____rparam5_4
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0bd1 1003
                               rrf      v____rparam5_4,f    ;  1 OV rS rS [?? ??] 0bd2 0cb3
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               movlw    1                   ;  1 OV rS rS [?? ??] 0bd3 3001
                               movwf    v___side_41         ;  1 OV rS rS [?? ??] 0bd4 00b4
                               movlw    184                 ;  1 OV rS rS [?? ??] 0bd5 30b8
                                                            ; W = v___side_41
                               iorwf    v____rparam5_4,w    ;  1 OV rS rS [?? ??] 0bd6 0433
                               movwf    v____temp_110       ;  1 OV rS rS [?? ??] 0bd7 00b5
                               movf     v____temp_110,w     ;  1 OV rS rS [?? ??] 0bd8 0835
                                                            ; W = v____temp_110
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0bd9 00bb
                                                            ; W = v____temp_110
                               movf     v___side_41,w       ;  1 OV rS rS [?? ??] 0bda 0834
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0bdb 118a
                                                            ; W = v___side_41
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0bdc 25e7
                                                            ; W = v___side_41
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
;  450 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 0bdd 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 0bde 2675
;  451 			_ks0108_write(KS0108_RIGHT, cx)      -- Write the pixel data
                               datalo_set v___cx_4          ;  1 OV ?? ?S [?? ??] 0bdf 1683
                               datahi_clr v___cx_4          ;  1 OV ?S rS [?? ??] 0be0 1303
                               movf     v___cx_4,w          ;  1 OV rS rS [?? ??] 0be1 0827
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0be2 00bb
                                                            ; W = v___cx_4
                               movlw    1                   ;  1 OV rS rS [?? ??] 0be3 3001
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0be4 118a
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0be5 25e7
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  452 		end if
l__l898
l__l899
;  455 		fIndex = fIndex + 1
                               datalo_set v___findex_4      ;  1 OV ?? ?S [?? ??] 0be6 1683
                               datahi_clr v___findex_4      ;  1 OV ?S rS [?? ??] 0be7 1303
                               incf     v___findex_4,f      ;  1 OV rS rS [?? ??] 0be8 0aa3
                               btfsc    v__status, v__z     ;  1 OV rS rS [?? ??] 0be9 1903
                               incf     v___findex_4+1,f    ;  1 OV rS rS [?? ??] 0bea 0aa4
;  456 		x = x + 1
                               datalo_clr v___x_129         ;  1 OV rS rs [?? ??] 0beb 1283
                               incf     v___x_129,f         ;  1 OV rs rs [?? ??] 0bec 0aee
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; glcd_ks0108.jal
;  457 	end loop
                               datalo_set v____floop7_4     ;  1 OV rs rS [?? ??] 0bed 1683
                               incf     v____floop7_4,f     ;  1 OV rS rS [?? ??] 0bee 0ab1
l__l900
                               movf     v____floop7_4,w     ;  1 OV rS rS [?? ??] 0bef 0831
                                                            ; W = v____temp_106
                               subwf    v___doloop_4,w      ;  1 OV rS rS [?? ??] 0bf0 0228
                                                            ; W = v____floop7_4
                               branchlo_set l__l890         ;  1 OV rS rS [?? ?L] 0bf1 158a
                               btfss    v__status, v__z     ;  1 OV rS rS [?L ?L] 0bf2 1d03
                               goto     l__l890             ;  1 OV rS rS [?L ?L] 0bf3 2b63
;  458 end procedure
l__l902
; glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
;  148 end procedure
                               return                       ;  1 OV rS rS [?L ?L] 0bf4 0008
;  153 procedure lcd_print(byte in x, byte in y, byte in str[]) is
l_lcd_print
                               movwf    v___x_131           ;  1 OV rs rs [?L ?L] 0bf5 00d5
;  156 	for count(str) using i loop
                               clrf     v___i_1             ;  1 OV rs rs [?L ?L] 0bf6 01e4
                                                            ; W = v___x_131
                               branchlo_nop l__l906         ;  1 OV rs rs [?L ?L] 0bf7
                                                            ; W = v___x_131
                               goto     l__l906             ;  1 OV rs rs [?L ?L] 0bf7 2ceb
                                                            ; W = v___x_131
l__l905
;  157 		j = x
                               movf     v___x_131,w         ;  1 OV rs rs [?L ?L] 0bf8 0855
                               movwf    v___j_1             ;  1 OV rs rs [?L ?L] 0bf9 00e5
                                                            ; W = v___x_131
;  158 		j = j + (i * 6)
                               movf     v___i_1,w           ;  1 OV rs rs [?L ?L] 0bfa 0864
                                                            ; W = v___j_1
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?L ?L] 0bfb 00a0
                                                            ; W = v___i_1
                               clrf     v__pic_multiplier+1 ;  1 OV rs rs [?L ?L] 0bfc 01a1
                                                            ; W = v__pic_multiplier
                               movlw    6                   ;  1 OV rs rs [?L ?L] 0bfd 3006
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?L ?L] 0bfe 00a2
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?L ?L] 0bff 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  1 OV rs rs [?L ?l] 0c00 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?l ??] 0c01 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 0c02 1283
                               datahi_clr v__pic_mresult    ;  1 OV ?s rs [?? ??] 0c03 1303
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 0c04 0824
                               movwf    v____temp_111       ;  1 OV rs rs [?? ??] 0c05 00e6
                                                            ; W = v__pic_mresult
                               movf     v____temp_111,w     ;  1 OV rs rs [?? ??] 0c06 0866
                                                            ; W = v____temp_111
                               addwf    v___j_1,f           ;  1 OV rs rs [?? ??] 0c07 07e5
                                                            ; W = v____temp_111
;  159 		lcd_write_char(j, y, str[i],0)
                               movf     v___str_3+1,w       ;  1 OV rs rs [?? ??] 0c08 085f
                                                            ; W = v____temp_111
                               movwf    v__pic_pointer+1    ;  1 OV rs rs [?? ??] 0c09 00ab
                                                            ; W = v___str_3
                               movf     v___i_1,w           ;  1 OV rs rs [?? ??] 0c0a 0864
                                                            ; W = v__pic_pointer
                               addwf    v___str_3,w         ;  1 OV rs rs [?? ??] 0c0b 075e
                                                            ; W = v___i_1
                               movwf    v__pic_pointer      ;  1 OV rs rs [?? ??] 0c0c 00aa
                               btfsc    v__status, v__c     ;  1 OV rs rs [?? ??] 0c0d 1803
                                                            ; W = v__pic_pointer
                               incf     v__pic_pointer+1,f  ;  1 OV rs rs [?? ??] 0c0e 0aab
                                                            ; W = v__pic_pointer
                               bcf      v__pic_pointer+1, 6 ;  1 OV rs rs [?? ??] 0c0f 132b
                               movf     v__pic_pointer+1,w  ;  1 OV rs rs [?? ??] 0c10 082b
                               branchlo_clr l__pic_indirect ;  1 OV rs rs [?? ?l] 0c11 118a
                                                            ; W = v__pic_pointer
                               call     l__pic_indirect     ;  1 OV rs ?? [?l ??] 0c12 22c9
                                                            ; W = v__pic_pointer
                               datalo_clr v__rparam14       ;  1 OV ?? ?s [?? ??] 0c13 1283
                               datahi_clr v__rparam14       ;  1 OV ?s rs [?? ??] 0c14 1303
                               movwf    v__rparam14         ;  1 OV rs rs [?? ??] 0c15 00e8
                               movf     v___j_1,w           ;  1 OV rs rs [?? ??] 0c16 0865
                                                            ; W = v__rparam14
                               movwf    v___x_132           ;  1 OV rs rs [?? ??] 0c17 00ea
                                                            ; W = v___j_1
                               bcf      v____bitbucket_3, 0 ; debug6;  1 OV rs rs [?? ??] 0c18 1067
                                                            ; W = v___x_132
; glcd_ks0108.jal
;  423 	var word fIndex = 0
                               clrf     v___findex_5        ;  1 OV rs rs [?? ??] 0c19 01eb
                                                            ; W = v___x_132
                               clrf     v___findex_5+1      ;  1 OV rs rs [?? ??] 0c1a 01ec
                                                            ; W = v___x_132
;  424 	var byte cx = 0b10101010
                               movlw    170                 ;  1 OV rs rs [?? ??] 0c1b 30aa
                                                            ; W = v___x_132
                               datalo_set v___cx_5          ;  1 OV rs rS [?? ??] 0c1c 1683
                               movwf    v___cx_5            ;  1 OV rS rS [?? ??] 0c1d 00a0
;  425 	var byte doLoop = 5
                               movlw    5                   ;  1 OV rS rS [?? ??] 0c1e 3005
                                                            ; W = v___cx_5
                               datalo_clr v___doloop_5      ;  1 OV rS rs [?? ??] 0c1f 1283
                               movwf    v___doloop_5        ;  1 OV rs rs [?? ??] 0c20 00ee
;  426 	if (ch <  31) then return end if
                               movlw    31                  ;  1 OV rs rs [?? ??] 0c21 301f
                                                            ; W = v___doloop_5
                               subwf    v__rparam14,w       ;  1 OV rs rs [?? ??] 0c22 0268
                               branchlo_set l__l908         ;  1 OV rs rs [?? ?L] 0c23 158a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0c24 1903
                               goto     l__l908             ;  1 OV rs rs [?L ?L] 0c25 2c29
                               branchlo_nop l__l908         ;  1 OV rs rs [?L ?L] 0c26
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 0c26 1803
                               goto     l__l908             ;  1 OV rs rs [?L ?L] 0c27 2c29
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  426 	if (ch <  31) then return end if
                               branchlo_nop l__l924         ;  1 OV rs rs [?L ?L] 0c28
                               goto     l__l924             ;  1 OV rs rs [?L ?L] 0c28 2cea
l__l908
;  427 	if (ch > 135) then return end if
                               movlw    135                 ;  1 OV rs rs [?L ?L] 0c29 3087
                               subwf    v__rparam14,w       ;  1 OV rs rs [?L ?L] 0c2a 0268
                               branchlo_nop l__l910         ;  1 OV rs rs [?L ?L] 0c2b
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0c2b 1903
                               goto     l__l910             ;  1 OV rs rs [?L ?L] 0c2c 2c30
                               branchlo_nop l__l910         ;  1 OV rs rs [?L ?L] 0c2d
                               btfss    v__status, v__c     ;  1 OV rs rs [?L ?L] 0c2d 1c03
                               goto     l__l910             ;  1 OV rs rs [?L ?L] 0c2e 2c30
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  427 	if (ch > 135) then return end if
                               branchlo_nop l__l924         ;  1 OV rs rs [?L ?L] 0c2f
                               goto     l__l924             ;  1 OV rs rs [?L ?L] 0c2f 2cea
l__l910
;  430 	fIndex = fIndex + 5 * word(ch - 32)
                               movlw    32                  ;  1 OV rs rs [?L ?L] 0c30 3020
                               subwf    v__rparam14,w       ;  1 OV rs rs [?L ?L] 0c31 0268
                               datalo_set v____temp_112     ;  1 OV rs rS [?L ?L] 0c32 1683
                               movwf    v____temp_112       ;  1 OV rS rS [?L ?L] 0c33 00a3
                               clrf     v____temp_112+1     ;  1 OV rS rS [?L ?L] 0c34 01a4
                                                            ; W = v____temp_112
                               movf     v____temp_112,w     ;  1 OV rS rS [?L ?L] 0c35 0823
                                                            ; W = v____temp_112
                               datalo_clr v__pic_multiplier ;  1 OV rS rs [?L ?L] 0c36 1283
                                                            ; W = v____temp_112
                               movwf    v__pic_multiplier   ;  1 OV rs rs [?L ?L] 0c37 00a0
                                                            ; W = v____temp_112
                               datalo_set v____temp_112     ;  1 OV rs rS [?L ?L] 0c38 1683
                                                            ; W = v__pic_multiplier
                               movf     v____temp_112+1,w   ;  1 OV rS rS [?L ?L] 0c39 0824
                                                            ; W = v__pic_multiplier
                               datalo_clr v__pic_multiplier ;  1 OV rS rs [?L ?L] 0c3a 1283
                                                            ; W = v____temp_112
                               movwf    v__pic_multiplier+1 ;  1 OV rs rs [?L ?L] 0c3b 00a1
                                                            ; W = v____temp_112
                               movlw    5                   ;  1 OV rs rs [?L ?L] 0c3c 3005
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  1 OV rs rs [?L ?L] 0c3d 00a2
                               clrf     v__pic_multiplicand+1;  1 OV rs rs [?L ?L] 0c3e 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  1 OV rs rs [?L ?l] 0c3f 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  1 OV rs ?? [?l ??] 0c40 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  1 OV ?? ?s [?? ??] 0c41 1283
                               datahi_clr v__pic_mresult    ;  1 OV ?s rs [?? ??] 0c42 1303
                               movf     v__pic_mresult,w    ;  1 OV rs rs [?? ??] 0c43 0824
                               datalo_set v____temp_112+2   ;  1 OV rs rS [?? ??] 0c44 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_112+2     ;  1 OV rS rS [?? ??] 0c45 00a5
                                                            ; W = v__pic_mresult
                               datalo_clr v__pic_mresult    ;  1 OV rS rs [?? ??] 0c46 1283
                                                            ; W = v____temp_112
                               movf     v__pic_mresult+1,w  ;  1 OV rs rs [?? ??] 0c47 0825
                                                            ; W = v____temp_112
                               datalo_set v____temp_112+2   ;  1 OV rs rS [?? ??] 0c48 1683
                                                            ; W = v__pic_mresult
                               movwf    v____temp_112+3     ;  1 OV rS rS [?? ??] 0c49 00a6
                                                            ; W = v__pic_mresult
                               movf     v____temp_112+3,w   ;  1 OV rS rS [?? ??] 0c4a 0826
                                                            ; W = v____temp_112
                               datalo_clr v___findex_5      ;  1 OV rS rs [?? ??] 0c4b 1283
                                                            ; W = v____temp_112
                               addwf    v___findex_5+1,f    ;  1 OV rs rs [?? ??] 0c4c 07ec
                                                            ; W = v____temp_112
                               datalo_set v____temp_112+2   ;  1 OV rs rS [?? ??] 0c4d 1683
                                                            ; W = v____temp_112
                               movf     v____temp_112+2,w   ;  1 OV rS rS [?? ??] 0c4e 0825
                                                            ; W = v____temp_112
                               datalo_clr v___findex_5      ;  1 OV rS rs [?? ??] 0c4f 1283
                                                            ; W = v____temp_112
                               addwf    v___findex_5,f      ;  1 OV rs rs [?? ??] 0c50 07eb
                                                            ; W = v____temp_112
                               btfsc    v__status, v__c     ;  1 OV rs rs [?? ??] 0c51 1803
                                                            ; W = v____temp_112
                               incf     v___findex_5+1,f    ;  1 OV rs rs [?? ??] 0c52 0aec
                                                            ; W = v____temp_112
;  433 	for doLoop loop
                               datalo_set v____floop7_5     ;  1 OV rs rS [?? ??] 0c53 1683
                                                            ; W = v____temp_112
                               clrf     v____floop7_5       ;  1 OV rS rS [?? ??] 0c54 01aa
                                                            ; W = v____temp_112
                               branchlo_set l__l922         ;  1 OV rS rS [?? ?L] 0c55 158a
                                                            ; W = v____temp_112
                               goto     l__l922             ;  1 OV rS rS [?L ?L] 0c56 2ce4
                                                            ; W = v____temp_112
l__l912
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  434 		cx = myFontTable[fIndex]
                               movf     v___findex_5,w      ;  1 OV rs rs [?L ?L] 0c57 086b
                               movwf    v__pic_loop         ;  1 OV rs rs [?L ?L] 0c58 00a8
                                                            ; W = v___findex_5
                               movf     v___findex_5+1,w    ;  1 OV rs rs [?L ?L] 0c59 086c
                                                            ; W = v__pic_loop
                               branchlo_clr l__lookup_myfonttable;  1 OV rs rs [?L ?l] 0c5a 118a
                                                            ; W = v___findex_5
                               call     l__lookup_myfonttable;  1 OV rs ?? [?l ??] 0c5b 2004
                                                            ; W = v___findex_5
                               datalo_set v___cx_5          ;  1 OV ?? ?S [?? ??] 0c5c 1683
                               datahi_clr v___cx_5          ;  1 OV ?S rS [?? ??] 0c5d 1303
                               movwf    v___cx_5            ;  1 OV rS rS [?? ??] 0c5e 00a0
;  435 		if debug then
                               datalo_clr v____bitbucket_3 ; debug6;  1 OV rS rs [?? ??] 0c5f 1283
                                                            ; W = v___cx_5
                               branchlo_set l__l913         ;  1 OV rs rs [?? ?L] 0c60 158a
                                                            ; W = v___cx_5
                               btfss    v____bitbucket_3, 0 ; debug6;  1 OV rs rs [?L ?L] 0c61 1c67
                                                            ; W = v___cx_5
                               goto     l__l913             ;  1 OV rs rs [?L ?L] 0c62 2c76
                                                            ; W = v___cx_5
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  436 			serial_hw_byte(fIndex)
                               movf     v___findex_5,w      ;  1 OV rs rs [?L ?L] 0c63 086b
                               datalo_set v___b_1           ;  1 OV rs rS [?L ?L] 0c64 1683
                                                            ; W = v___findex_5
                               movwf    v___b_1             ;  1 OV rS rS [?L ?L] 0c65 00b6
                                                            ; W = v___findex_5
                               datalo_clr v___findex_5      ;  1 OV rS rs [?L ?L] 0c66 1283
                                                            ; W = v___b_1
                               movf     v___findex_5+1,w    ;  1 OV rs rs [?L ?L] 0c67 086c
                                                            ; W = v___b_1
                               datalo_set v___b_1           ;  1 OV rs rS [?L ?L] 0c68 1683
                                                            ; W = v___findex_5
                               movwf    v___b_1+1           ;  1 OV rS rS [?L ?L] 0c69 00b7
                                                            ; W = v___findex_5
                               branchlo_clr l_serial_hw_byte;  1 OV rS rS [?L ?l] 0c6a 118a
                                                            ; W = v___b_1
                               call     l_serial_hw_byte    ;  1 OV rS ?? [?l ??] 0c6b 253e
                                                            ; W = v___b_1
;  437 			serial_hw_byte(cx)
                               datalo_set v___cx_5          ;  1 OV ?? ?S [?? ??] 0c6c 1683
                               datahi_clr v___cx_5          ;  1 OV ?S rS [?? ??] 0c6d 1303
                               movf     v___cx_5,w          ;  1 OV rS rS [?? ??] 0c6e 0820
                               movwf    v___b_1             ;  1 OV rS rS [?? ??] 0c6f 00b6
                                                            ; W = v___cx_5
                               clrf     v___b_1+1           ;  1 OV rS rS [?? ??] 0c70 01b7
                                                            ; W = v___b_1
                               branchlo_clr l_serial_hw_byte;  1 OV rS rS [?? ?l] 0c71 118a
                                                            ; W = v___b_1
                               call     l_serial_hw_byte    ;  1 OV rS ?? [?l ??] 0c72 253e
                                                            ; W = v___b_1
;  438 			serial_hw_write(0x0A)
                               movlw    10                  ;  1 OV ?? ?? [?? ??] 0c73 300a
                               branchlo_clr l_serial_hw_write;  1 OV ?? ?? [?? ?l] 0c74 118a
                               call     l_serial_hw_write   ;  1 OV ?? ?? [?l ??] 0c75 2519
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  439 		end if
l__l913
;  440 		_ks0108_inst()                          -- Set for instruction          
                               branchlo_clr l__ks0108_inst  ;  1 OV ?? ?? [?? ?l] 0c76 118a
                                                            ; W = v___cx_5
                               call     l__ks0108_inst      ;  1 OV ?? ?? [?l ??] 0c77 266f
                                                            ; W = v___cx_5
;  442 		if (x < 64) then
                               movlw    64                  ;  1 OV ?? ?? [?? ??] 0c78 3040
                               datalo_clr v___x_132         ;  1 OV ?? ?s [?? ??] 0c79 1283
                               datahi_clr v___x_132         ;  1 OV ?s rs [?? ??] 0c7a 1303
                               subwf    v___x_132,w         ;  1 OV rs rs [?? ??] 0c7b 026a
                               branchlo_set l__l917         ;  1 OV rs rs [?? ?L] 0c7c 158a
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0c7d 1903
                               goto     l__l917             ;  1 OV rs rs [?L ?L] 0c7e 2cab
                               branchlo_nop l__l917         ;  1 OV rs rs [?L ?L] 0c7f
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 0c7f 1803
                               goto     l__l917             ;  1 OV rs rs [?L ?L] 0c80 2cab
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
                               datalo_set v___side_42       ;  1 OV rs rS [?L ?L] 0c81 1683
                               clrf     v___side_42         ;  1 OV rS rS [?L ?L] 0c82 01af
                               movlw    64                  ;  1 OV rS rS [?L ?L] 0c83 3040
                               datalo_clr v___x_132         ;  1 OV rS rs [?L ?L] 0c84 1283
                               iorwf    v___x_132,w         ;  1 OV rs rs [?L ?L] 0c85 046a
                               datalo_set v____temp_113     ;  1 OV rs rS [?L ?L] 0c86 1683
                               movwf    v____temp_113       ;  1 OV rS rS [?L ?L] 0c87 00b0
                               movf     v____temp_113,w     ;  1 OV rS rS [?L ?L] 0c88 0830
                                                            ; W = v____temp_113
                               movwf    v___data_14         ;  1 OV rS rS [?L ?L] 0c89 00bb
                                                            ; W = v____temp_113
                               movf     v___side_42,w       ;  1 OV rS rS [?L ?L] 0c8a 082f
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?L ?l] 0c8b 118a
                                                            ; W = v___side_42
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0c8c 25e7
                                                            ; W = v___side_42
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 0c8d 1003
                               datalo_clr v___y_13          ;  1 OV ?? ?s [?? ??] 0c8e 1283
                               datahi_clr v___y_13          ;  1 OV ?s rs [?? ??] 0c8f 1303
                               rrf      v___y_13,w          ;  1 OV rs rs [?? ??] 0c90 0c57
                               datalo_set v____rparam3_5    ;  1 OV rs rS [?? ??] 0c91 1683
                               movwf    v____rparam3_5      ;  1 OV rS rS [?? ??] 0c92 00ae
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0c93 1003
                                                            ; W = v____rparam3_5
                               rrf      v____rparam3_5,f    ;  1 OV rS rS [?? ??] 0c94 0cae
                                                            ; W = v____rparam3_5
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0c95 1003
                               rrf      v____rparam3_5,f    ;  1 OV rS rS [?? ??] 0c96 0cae
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               clrf     v___side_43         ;  1 OV rS rS [?? ??] 0c97 01af
                               movlw    184                 ;  1 OV rS rS [?? ??] 0c98 30b8
                               iorwf    v____rparam3_5,w    ;  1 OV rS rS [?? ??] 0c99 042e
                               movwf    v____temp_114       ;  1 OV rS rS [?? ??] 0c9a 00b0
                               movf     v____temp_114,w     ;  1 OV rS rS [?? ??] 0c9b 0830
                                                            ; W = v____temp_114
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0c9c 00bb
                                                            ; W = v____temp_114
                               movf     v___side_43,w       ;  1 OV rS rS [?? ??] 0c9d 082f
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0c9e 118a
                                                            ; W = v___side_43
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0c9f 25e7
                                                            ; W = v___side_43
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
;  445 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 0ca0 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 0ca1 2675
;  446 			_ks0108_write(KS0108_LEFT, cx)       -- Write the pixel data
                               datalo_set v___cx_5          ;  1 OV ?? ?S [?? ??] 0ca2 1683
                               datahi_clr v___cx_5          ;  1 OV ?S rS [?? ??] 0ca3 1303
                               movf     v___cx_5,w          ;  1 OV rS rS [?? ??] 0ca4 0820
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0ca5 00bb
                                                            ; W = v___cx_5
                               movlw    0                   ;  1 OV rS rS [?? ??] 0ca6 3000
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0ca7 118a
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0ca8 25e7
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  447 		elsif (x < 128) then
                               branchlo_set l__l921         ;  1 OV ?? ?? [?? ?L] 0ca9 158a
                               goto     l__l921             ;  1 OV ?? ?? [?L ?L] 0caa 2cdc
l__l917
                               movlw    128                 ;  1 OV rs rs [?L ?L] 0cab 3080
                               subwf    v___x_132,w         ;  1 OV rs rs [?L ?L] 0cac 026a
                               branchlo_nop l__l920         ;  1 OV rs rs [?L ?L] 0cad
                               btfsc    v__status, v__z     ;  1 OV rs rs [?L ?L] 0cad 1903
                               goto     l__l920             ;  1 OV rs rs [?L ?L] 0cae 2cdc
                               branchlo_nop l__l920         ;  1 OV rs rs [?L ?L] 0caf
                               btfsc    v__status, v__c     ;  1 OV rs rs [?L ?L] 0caf 1803
                               goto     l__l920             ;  1 OV rs rs [?L ?L] 0cb0 2cdc
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    64                  ;  1 OV rs rs [?L ?L] 0cb1 3040
                               subwf    v___x_132,w         ;  1 OV rs rs [?L ?L] 0cb2 026a
                               datalo_set v____rparam4_5    ;  1 OV rs rS [?L ?L] 0cb3 1683
                               movwf    v____rparam4_5      ;  1 OV rS rS [?L ?L] 0cb4 00ae
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    1                   ;  1 OV rS rS [?L ?L] 0cb5 3001
                                                            ; W = v____rparam4_5
                               movwf    v___side_44         ;  1 OV rS rS [?L ?L] 0cb6 00b0
                               movlw    64                  ;  1 OV rS rS [?L ?L] 0cb7 3040
                                                            ; W = v___side_44
                               iorwf    v____rparam4_5,w    ;  1 OV rS rS [?L ?L] 0cb8 042e
                               movwf    v____temp_115       ;  1 OV rS rS [?L ?L] 0cb9 00b1
                               movf     v____temp_115,w     ;  1 OV rS rS [?L ?L] 0cba 0831
                                                            ; W = v____temp_115
                               movwf    v___data_14         ;  1 OV rS rS [?L ?L] 0cbb 00bb
                                                            ; W = v____temp_115
                               movf     v___side_44,w       ;  1 OV rS rS [?L ?L] 0cbc 0830
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?L ?l] 0cbd 118a
                                                            ; W = v___side_44
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0cbe 25e7
                                                            ; W = v___side_44
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               bcf      v__status, v__c     ;  1 OV ?? ?? [?? ??] 0cbf 1003
                               datalo_clr v___y_13          ;  1 OV ?? ?s [?? ??] 0cc0 1283
                               datahi_clr v___y_13          ;  1 OV ?s rs [?? ??] 0cc1 1303
                               rrf      v___y_13,w          ;  1 OV rs rs [?? ??] 0cc2 0c57
                               datalo_set v____rparam5_5    ;  1 OV rs rS [?? ??] 0cc3 1683
                               movwf    v____rparam5_5      ;  1 OV rS rS [?? ??] 0cc4 00af
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0cc5 1003
                                                            ; W = v____rparam5_5
                               rrf      v____rparam5_5,f    ;  1 OV rS rS [?? ??] 0cc6 0caf
                                                            ; W = v____rparam5_5
                               bcf      v__status, v__c     ;  1 OV rS rS [?? ??] 0cc7 1003
                               rrf      v____rparam5_5,f    ;  1 OV rS rS [?? ??] 0cc8 0caf
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               movlw    1                   ;  1 OV rS rS [?? ??] 0cc9 3001
                               movwf    v___side_45         ;  1 OV rS rS [?? ??] 0cca 00b0
                               movlw    184                 ;  1 OV rS rS [?? ??] 0ccb 30b8
                                                            ; W = v___side_45
                               iorwf    v____rparam5_5,w    ;  1 OV rS rS [?? ??] 0ccc 042f
                               movwf    v____temp_116       ;  1 OV rS rS [?? ??] 0ccd 00b1
                               movf     v____temp_116,w     ;  1 OV rS rS [?? ??] 0cce 0831
                                                            ; W = v____temp_116
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0ccf 00bb
                                                            ; W = v____temp_116
                               movf     v___side_45,w       ;  1 OV rS rS [?? ??] 0cd0 0830
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0cd1 118a
                                                            ; W = v___side_45
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0cd2 25e7
                                                            ; W = v___side_45
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
;  450 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data  ;  1 OV ?? ?? [?? ?l] 0cd3 118a
                               call     l__ks0108_data      ;  1 OV ?? ?? [?l ??] 0cd4 2675
;  451 			_ks0108_write(KS0108_RIGHT, cx)      -- Write the pixel data
                               datalo_set v___cx_5          ;  1 OV ?? ?S [?? ??] 0cd5 1683
                               datahi_clr v___cx_5          ;  1 OV ?S rS [?? ??] 0cd6 1303
                               movf     v___cx_5,w          ;  1 OV rS rS [?? ??] 0cd7 0820
                               movwf    v___data_14         ;  1 OV rS rS [?? ??] 0cd8 00bb
                                                            ; W = v___cx_5
                               movlw    1                   ;  1 OV rS rS [?? ??] 0cd9 3001
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  1 OV rS rS [?? ?l] 0cda 118a
                               call     l__ks0108_write     ;  1 OV rS ?? [?l ??] 0cdb 25e7
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  452 		end if
l__l920
l__l921
;  455 		fIndex = fIndex + 1
                               datalo_clr v___findex_5      ;  1 OV ?? ?s [?? ??] 0cdc 1283
                               datahi_clr v___findex_5      ;  1 OV ?s rs [?? ??] 0cdd 1303
                               incf     v___findex_5,f      ;  1 OV rs rs [?? ??] 0cde 0aeb
                               btfsc    v__status, v__z     ;  1 OV rs rs [?? ??] 0cdf 1903
                               incf     v___findex_5+1,f    ;  1 OV rs rs [?? ??] 0ce0 0aec
;  456 		x = x + 1
                               incf     v___x_132,f         ;  1 OV rs rs [?? ??] 0ce1 0aea
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; glcd_ks0108.jal
;  457 	end loop
                               datalo_set v____floop7_5     ;  1 OV rs rS [?? ??] 0ce2 1683
                               incf     v____floop7_5,f     ;  1 OV rS rS [?? ??] 0ce3 0aaa
l__l922
                               movf     v____floop7_5,w     ;  1 OV rS rS [?? ??] 0ce4 082a
                                                            ; W = v____temp_112
                               datalo_clr v___doloop_5      ;  1 OV rS rs [?? ??] 0ce5 1283
                                                            ; W = v____floop7_5
                               subwf    v___doloop_5,w      ;  1 OV rs rs [?? ??] 0ce6 026e
                                                            ; W = v____floop7_5
                               branchlo_set l__l912         ;  1 OV rs rs [?? ?L] 0ce7 158a
                               btfss    v__status, v__z     ;  1 OV rs rs [?L ?L] 0ce8 1d03
                               goto     l__l912             ;  1 OV rs rs [?L ?L] 0ce9 2c57
;  458 end procedure
l__l924
; glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
;  160 	end loop
                               incf     v___i_1,f           ;  1 OV rs rs [?L ?L] 0cea 0ae4
l__l906
                               movf     v___i_1,w           ;  1 OV rs rs [?L ?L] 0ceb 0864
                                                            ; W = v___x_131
                               subwf    v____str_count_1,w  ;  1 OV rs rs [?L ?L] 0cec 025b
                                                            ; W = v___i_1
                               movwf    v__pic_temp         ;  1 OV rs rs [?L ?L] 0ced 00a0
                               movf     v____str_count_1+1,w;  1 OV rs rs [?L ?L] 0cee 085c
                                                            ; W = v__pic_temp
                               iorwf    v__pic_temp,w       ;  1 OV rs rs [?L ?L] 0cef 0420
                                                            ; W = v____str_count_1
                               branchlo_nop l__l905         ;  1 OV rs rs [?L ?L] 0cf0
                               btfss    v__status, v__z     ;  1 OV rs rs [?L ?L] 0cf0 1d03
                               goto     l__l905             ;  1 OV rs rs [?L ?L] 0cf1 2bf8
;  161 end procedure
                               return                       ;  1 OV rs rs [?L ?L] 0cf2 0008
;  233 end procedure 
l__l930
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  274    GLCD_DATAPRT = 0x00
                               clrf     v___x_135           ;  0 OV rs rs [?L ?L] 0cf3 01c7
; 16f886.jal
;  225    _PORTB_shadow = x
                               movf     v___x_135,w         ;  0 OV rs rs [?L ?L] 0cf4 0847
                               movwf    v__portb_shadow     ;  0 OV rs rs [?L ?L] 0cf5 00b0
                                                            ; W = v___x_135
; main.jal
;   58 lcd_init()
; 16f886.jal
;  221    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w   ;  0 OV rs rs [?L ?L] 0cf6 0830
                                                            ; W = v__portb_shadow
                               movwf    v_portb             ;  0 OV rs rs [?L ?L] 0cf7 0086
                                                            ; W = v__portb_shadow
; main.jal
;   58 lcd_init()
; 16f886.jal
;  226    _PORTB_flush()
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  274    GLCD_DATAPRT = 0x00
;  275    GLCD_DATAPRT_DIR = all_output
                               datalo_set v_portb_direction ;  0 OV rs rS [?L ?L] 0cf8 1683
                               clrf     v_portb_direction   ;  0 OV rS rS [?L ?L] 0cf9 0186
;  277    GLCD_RW_DIRECTION  = output
                               bcf      v_trisc, 3 ; pin_c3_direction       ;  0 OV rS rS [?L ?L] 0cfa 1187
;  278    GLCD_CS1_DIRECTION = output
                               bcf      v_trisc, 1 ; pin_c1_direction       ;  0 OV rS rS [?L ?L] 0cfb 1087
;  279    GLCD_E_DIRECTION   = output
                               bcf      v_trisa, 5 ; pin_a5_direction       ;  0 OV rS rS [?L ?L] 0cfc 1285
;  280    GLCD_DI_DIRECTION  = output
                               bcf      v_trisc, 5 ; pin_c5_direction       ;  0 OV rS rS [?L ?L] 0cfd 1287
;  281    GLCD_RST_DIRECTION = output
                               bcf      v_trisc, 4 ; pin_c4_direction       ;  0 OV rS rS [?L ?L] 0cfe 1207
;  282    GLCD_CS2_DIRECTION = output
                               bcf      v_trisc, 0 ; pin_c0_direction       ;  0 OV rS rS [?L ?L] 0cff 1007
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  284    GLCD_RST	= high
                               datalo_clr v__portc_shadow ; x136;  0 OV rS rs [?L ?L] 0d00 1283
                               bsf      v__portc_shadow, 4 ; x136;  0 OV rs rs [?L ?L] 0d01 1631
; main.jal
;   58 lcd_init()
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  0 OV rs rs [?L ?L] 0d02 0831
                               movwf    v_portc             ;  0 OV rs rs [?L ?L] 0d03 0087
                                                            ; W = v__portc_shadow
; main.jal
;   58 lcd_init()
; 16f886.jal
;  400    _PORTC_flush()
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  284    GLCD_RST	= high
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  285    GLCD_E	= low
                               bcf      v__porta_shadow, 5 ; x137;  0 OV rs rs [?L ?L] 0d04 12af
; main.jal
;   58 lcd_init()
; 16f886.jal
;  101    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w   ;  0 OV rs rs [?L ?L] 0d05 082f
                               movwf    v_porta             ;  0 OV rs rs [?L ?L] 0d06 0085
                                                            ; W = v__porta_shadow
; main.jal
;   58 lcd_init()
; 16f886.jal
;  157    _PORTA_flush()
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  285    GLCD_E	= low
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  286    GLCD_CS1	= high
                               bsf      v__portc_shadow, 1 ; x138;  0 OV rs rs [?L ?L] 0d07 14b1
; main.jal
;   58 lcd_init()
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  0 OV rs rs [?L ?L] 0d08 0831
                               movwf    v_portc             ;  0 OV rs rs [?L ?L] 0d09 0087
                                                            ; W = v__portc_shadow
; main.jal
;   58 lcd_init()
; 16f886.jal
;  430    _PORTC_flush()
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  286    GLCD_CS1	= high
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  287    GLCD_CS2 = low
                               bcf      v__portc_shadow, 0 ; x139;  0 OV rs rs [?L ?L] 0d0a 1031
; main.jal
;   58 lcd_init()
; 16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w   ;  0 OV rs rs [?L ?L] 0d0b 0831
                               movwf    v_portc             ;  0 OV rs rs [?L ?L] 0d0c 0087
                                                            ; W = v__portc_shadow
; main.jal
;   58 lcd_init()
; 16f886.jal
;  440    _PORTC_flush()
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  287    GLCD_CS2 = low
;  290    _ks0108_inst()             -- Set for instruction
                               branchlo_clr l__ks0108_inst  ;  0 OV rs rs [?L ?l] 0d0d 118a
                               call     l__ks0108_inst      ;  0 OV rs ?? [?l ??] 0d0e 266f
;  291    _ks0108_write(KS0108_LEFT,  KS0108_CMD_TOP_RAM | 0)       -- First RAM line at the top of the screen
                               movlw    192                 ;  0 OV ?? ?? [?? ??] 0d0f 30c0
                               datalo_set v___data_14       ;  0 OV ?? ?S [?? ??] 0d10 1683
                               datahi_clr v___data_14       ;  0 OV ?S rS [?? ??] 0d11 1303
                               movwf    v___data_14         ;  0 OV rS rS [?? ??] 0d12 00bb
                               movlw    0                   ;  0 OV rS rS [?? ??] 0d13 3000
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  0 OV rS rS [?? ?l] 0d14 118a
                               call     l__ks0108_write     ;  0 OV rS ?? [?l ??] 0d15 25e7
;  292    _ks0108_write(KS0108_RIGHT, KS0108_CMD_TOP_RAM | 0)      -- First RAM line at the top of the screen
                               movlw    192                 ;  0 OV ?? ?? [?? ??] 0d16 30c0
                               datalo_set v___data_14       ;  0 OV ?? ?S [?? ??] 0d17 1683
                               datahi_clr v___data_14       ;  0 OV ?S rS [?? ??] 0d18 1303
                               movwf    v___data_14         ;  0 OV rS rS [?? ??] 0d19 00bb
                               movlw    1                   ;  0 OV rS rS [?? ??] 0d1a 3001
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  0 OV rS rS [?? ?l] 0d1b 118a
                               call     l__ks0108_write     ;  0 OV rS ?? [?l ??] 0d1c 25e7
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  293    _ks0108_page  (KS0108_LEFT ,0)        -- Set the page address to 0
                               datalo_clr v___side_46       ;  0 OV ?? ?s [?? ??] 0d1d 1283
                               datahi_clr v___side_46       ;  0 OV ?s rs [?? ??] 0d1e 1303
                               clrf     v___side_46         ;  0 OV rs rs [?? ??] 0d1f 01c7
                               clrf     v___page_4          ;  0 OV rs rs [?? ??] 0d20 01c8
                               movlw    184                 ;  0 OV rs rs [?? ??] 0d21 30b8
                               iorwf    v___page_4,w        ;  0 OV rs rs [?? ??] 0d22 0448
                               movwf    v____temp_119       ;  0 OV rs rs [?? ??] 0d23 00c9
                               movf     v____temp_119,w     ;  0 OV rs rs [?? ??] 0d24 0849
                                                            ; W = v____temp_119
                               datalo_set v___data_14       ;  0 OV rs rS [?? ??] 0d25 1683
                                                            ; W = v____temp_119
                               movwf    v___data_14         ;  0 OV rS rS [?? ??] 0d26 00bb
                                                            ; W = v____temp_119
                               datalo_clr v___side_46       ;  0 OV rS rs [?? ??] 0d27 1283
                                                            ; W = v___data_14
                               movf     v___side_46,w       ;  0 OV rs rs [?? ??] 0d28 0847
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  0 OV rs rs [?? ?l] 0d29 118a
                                                            ; W = v___side_46
                               call     l__ks0108_write     ;  0 OV rs ?? [?l ??] 0d2a 25e7
                                                            ; W = v___side_46
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  293    _ks0108_page  (KS0108_LEFT ,0)        -- Set the page address to 0
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  294    _ks0108_page  (KS0108_RIGHT,0)
                               movlw    1                   ;  0 OV ?? ?? [?? ??] 0d2b 3001
                               datalo_clr v___side_47       ;  0 OV ?? ?s [?? ??] 0d2c 1283
                               datahi_clr v___side_47       ;  0 OV ?s rs [?? ??] 0d2d 1303
                               movwf    v___side_47         ;  0 OV rs rs [?? ??] 0d2e 00c7
                               clrf     v___page_5          ;  0 OV rs rs [?? ??] 0d2f 01c8
                                                            ; W = v___side_47
                               movlw    184                 ;  0 OV rs rs [?? ??] 0d30 30b8
                                                            ; W = v___side_47
                               iorwf    v___page_5,w        ;  0 OV rs rs [?? ??] 0d31 0448
                               movwf    v____temp_120       ;  0 OV rs rs [?? ??] 0d32 00c9
                               movf     v____temp_120,w     ;  0 OV rs rs [?? ??] 0d33 0849
                                                            ; W = v____temp_120
                               datalo_set v___data_14       ;  0 OV rs rS [?? ??] 0d34 1683
                                                            ; W = v____temp_120
                               movwf    v___data_14         ;  0 OV rS rS [?? ??] 0d35 00bb
                                                            ; W = v____temp_120
                               datalo_clr v___side_47       ;  0 OV rS rs [?? ??] 0d36 1283
                                                            ; W = v___data_14
                               movf     v___side_47,w       ;  0 OV rs rs [?? ??] 0d37 0847
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  0 OV rs rs [?? ?l] 0d38 118a
                                                            ; W = v___side_47
                               call     l__ks0108_write     ;  0 OV rs ?? [?l ??] 0d39 25e7
                                                            ; W = v___side_47
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  294    _ks0108_page  (KS0108_RIGHT,0)
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  295    _ks0108_column(KS0108_LEFT ,0)        -- Set the column address to 0
                               datalo_clr v___side_48       ;  0 OV ?? ?s [?? ??] 0d3a 1283
                               datahi_clr v___side_48       ;  0 OV ?s rs [?? ??] 0d3b 1303
                               clrf     v___side_48         ;  0 OV rs rs [?? ??] 0d3c 01c7
                               clrf     v___column_6        ;  0 OV rs rs [?? ??] 0d3d 01c8
                               movlw    64                  ;  0 OV rs rs [?? ??] 0d3e 3040
                               iorwf    v___column_6,w      ;  0 OV rs rs [?? ??] 0d3f 0448
                               movwf    v____temp_121       ;  0 OV rs rs [?? ??] 0d40 00c9
                               movf     v____temp_121,w     ;  0 OV rs rs [?? ??] 0d41 0849
                                                            ; W = v____temp_121
                               datalo_set v___data_14       ;  0 OV rs rS [?? ??] 0d42 1683
                                                            ; W = v____temp_121
                               movwf    v___data_14         ;  0 OV rS rS [?? ??] 0d43 00bb
                                                            ; W = v____temp_121
                               datalo_clr v___side_48       ;  0 OV rS rs [?? ??] 0d44 1283
                                                            ; W = v___data_14
                               movf     v___side_48,w       ;  0 OV rs rs [?? ??] 0d45 0847
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  0 OV rs rs [?? ?l] 0d46 118a
                                                            ; W = v___side_48
                               call     l__ks0108_write     ;  0 OV rs ?? [?l ??] 0d47 25e7
                                                            ; W = v___side_48
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  295    _ks0108_column(KS0108_LEFT ,0)        -- Set the column address to 0
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  296    _ks0108_column(KS0108_RIGHT,0)
                               movlw    1                   ;  0 OV ?? ?? [?? ??] 0d48 3001
                               datalo_clr v___side_49       ;  0 OV ?? ?s [?? ??] 0d49 1283
                               datahi_clr v___side_49       ;  0 OV ?s rs [?? ??] 0d4a 1303
                               movwf    v___side_49         ;  0 OV rs rs [?? ??] 0d4b 00c7
                               clrf     v___column_7        ;  0 OV rs rs [?? ??] 0d4c 01c8
                                                            ; W = v___side_49
                               movlw    64                  ;  0 OV rs rs [?? ??] 0d4d 3040
                                                            ; W = v___side_49
                               iorwf    v___column_7,w      ;  0 OV rs rs [?? ??] 0d4e 0448
                               movwf    v____temp_122       ;  0 OV rs rs [?? ??] 0d4f 00c9
                               movf     v____temp_122,w     ;  0 OV rs rs [?? ??] 0d50 0849
                                                            ; W = v____temp_122
                               datalo_set v___data_14       ;  0 OV rs rS [?? ??] 0d51 1683
                                                            ; W = v____temp_122
                               movwf    v___data_14         ;  0 OV rS rS [?? ??] 0d52 00bb
                                                            ; W = v____temp_122
                               datalo_clr v___side_49       ;  0 OV rS rs [?? ??] 0d53 1283
                                                            ; W = v___data_14
                               movf     v___side_49,w       ;  0 OV rs rs [?? ??] 0d54 0847
                                                            ; W = v___data_14
                               branchlo_clr l__ks0108_write ;  0 OV rs rs [?? ?l] 0d55 118a
                                                            ; W = v___side_49
                               call     l__ks0108_write     ;  0 OV rs ?? [?l ??] 0d56 25e7
                                                            ; W = v___side_49
; main.jal
;   58 lcd_init()
; glcd_ks0108.jal
;  296    _ks0108_column(KS0108_RIGHT,0)
;  297    lcd_on()                       -- Turn the display on
                               branchlo_clr l_lcd_on        ;  0 OV ?? ?? [?? ?l] 0d57 118a
                               call     l_lcd_on            ;  0 OV ?? ?? [?l ??] 0d58 2662
;  299    lcd_fill(0)           -- Clear the display
                               movlw    0                   ;  0 OV ?? ?? [?? ??] 0d59 3000
                               branchlo_clr l_lcd_fill      ;  0 OV ?? ?? [?? ?l] 0d5a 118a
                               call     l_lcd_fill          ;  0 OV ?? ?? [?l ??] 0d5b 26ac
; main.jal
;   58 lcd_init()
;   61 lcd_print(0, 0, hewo)
                               datalo_clr v___y_13          ;  0 OV ?? ?s [?? ??] 0d5c 1283
                               datahi_clr v___y_13          ;  0 OV ?s rs [?? ??] 0d5d 1303
                               clrf     v___y_13            ;  0 OV rs rs [?? ??] 0d5e 01d7
                               movlw    13                  ;  0 OV rs rs [?? ??] 0d5f 300d
                               movwf    v____str_count_1    ;  0 OV rs rs [?? ??] 0d60 00db
                               clrf     v____str_count_1+1  ;  0 OV rs rs [?? ??] 0d61 01dc
                                                            ; W = v____str_count_1
                               movlw    l__data_hewo        ;  0 OV rs rs [?? ??] 0d62 305f
                                                            ; W = v____str_count_1
                               movwf    v___str_3           ;  0 OV rs rs [?? ??] 0d63 00de
                               movlw    HIGH l__data_hewo   ;  0 OV rs rs [?? ??] 0d64 3002
                                                            ; W = v___str_3
                               iorlw    64                  ;  0 OV rs rs [?? ??] 0d65 3840
                               movwf    v___str_3+1         ;  0 OV rs rs [?? ??] 0d66 00df
                               movlw    0                   ;  0 OV rs rs [?? ??] 0d67 3000
                                                            ; W = v___str_3
                               branchlo_set l_lcd_print     ;  0 OV rs rs [?? ?L] 0d68 158a
                               call     l_lcd_print         ;  0 OV rs ?? [?L ??] 0d69 23f5
;   62 lcd_print(0, 8, test1)
                               movlw    8                   ;  0 OV ?? ?? [?? ??] 0d6a 3008
                               datalo_clr v___y_13          ;  0 OV ?? ?s [?? ??] 0d6b 1283
                               datahi_clr v___y_13          ;  0 OV ?s rs [?? ??] 0d6c 1303
                               movwf    v___y_13            ;  0 OV rs rs [?? ??] 0d6d 00d7
                               movlw    20                  ;  0 OV rs rs [?? ??] 0d6e 3014
                                                            ; W = v___y_13
                               movwf    v____str_count_1    ;  0 OV rs rs [?? ??] 0d6f 00db
                               clrf     v____str_count_1+1  ;  0 OV rs rs [?? ??] 0d70 01dc
                                                            ; W = v____str_count_1
                               movlw    l__data_test1       ;  0 OV rs rs [?? ??] 0d71 3023
                                                            ; W = v____str_count_1
                               movwf    v___str_3           ;  0 OV rs rs [?? ??] 0d72 00de
                               movlw    HIGH l__data_test1  ;  0 OV rs rs [?? ??] 0d73 3002
                                                            ; W = v___str_3
                               iorlw    64                  ;  0 OV rs rs [?? ??] 0d74 3840
                               movwf    v___str_3+1         ;  0 OV rs rs [?? ??] 0d75 00df
                               movlw    0                   ;  0 OV rs rs [?? ??] 0d76 3000
                                                            ; W = v___str_3
                               branchlo_set l_lcd_print     ;  0 OV rs rs [?? ?L] 0d77 158a
                               call     l_lcd_print         ;  0 OV rs ?? [?L ??] 0d78 23f5
;   63 lcd_print(0, 16, test2)
                               movlw    16                  ;  0 OV ?? ?? [?? ??] 0d79 3010
                               datalo_clr v___y_13          ;  0 OV ?? ?s [?? ??] 0d7a 1283
                               datahi_clr v___y_13          ;  0 OV ?s rs [?? ??] 0d7b 1303
                               movwf    v___y_13            ;  0 OV rs rs [?? ??] 0d7c 00d7
                               movlw    20                  ;  0 OV rs rs [?? ??] 0d7d 3014
                                                            ; W = v___y_13
                               movwf    v____str_count_1    ;  0 OV rs rs [?? ??] 0d7e 00db
                               clrf     v____str_count_1+1  ;  0 OV rs rs [?? ??] 0d7f 01dc
                                                            ; W = v____str_count_1
                               movlw    l__data_test2       ;  0 OV rs rs [?? ??] 0d80 3038
                                                            ; W = v____str_count_1
                               movwf    v___str_3           ;  0 OV rs rs [?? ??] 0d81 00de
                               movlw    HIGH l__data_test2  ;  0 OV rs rs [?? ??] 0d82 3002
                                                            ; W = v___str_3
                               iorlw    64                  ;  0 OV rs rs [?? ??] 0d83 3840
                               movwf    v___str_3+1         ;  0 OV rs rs [?? ??] 0d84 00df
                               movlw    0                   ;  0 OV rs rs [?? ??] 0d85 3000
                                                            ; W = v___str_3
                               branchlo_set l_lcd_print     ;  0 OV rs rs [?? ?L] 0d86 158a
                               call     l_lcd_print         ;  0 OV rs ?? [?L ??] 0d87 23f5
;   64 lcd_print(0, 24, test3)
                               movlw    24                  ;  0 OV ?? ?? [?? ??] 0d88 3018
                               datalo_clr v___y_13          ;  0 OV ?? ?s [?? ??] 0d89 1283
                               datahi_clr v___y_13          ;  0 OV ?s rs [?? ??] 0d8a 1303
                               movwf    v___y_13            ;  0 OV rs rs [?? ??] 0d8b 00d7
                               movlw    20                  ;  0 OV rs rs [?? ??] 0d8c 3014
                                                            ; W = v___y_13
                               movwf    v____str_count_1    ;  0 OV rs rs [?? ??] 0d8d 00db
                               clrf     v____str_count_1+1  ;  0 OV rs rs [?? ??] 0d8e 01dc
                                                            ; W = v____str_count_1
                               movlw    l__data_test3       ;  0 OV rs rs [?? ??] 0d8f 300e
                                                            ; W = v____str_count_1
                               movwf    v___str_3           ;  0 OV rs rs [?? ??] 0d90 00de
                               movlw    HIGH l__data_test3  ;  0 OV rs rs [?? ??] 0d91 3002
                                                            ; W = v___str_3
                               iorlw    64                  ;  0 OV rs rs [?? ??] 0d92 3840
                               movwf    v___str_3+1         ;  0 OV rs rs [?? ??] 0d93 00df
                               movlw    0                   ;  0 OV rs rs [?? ??] 0d94 3000
                                                            ; W = v___str_3
                               branchlo_set l_lcd_print     ;  0 OV rs rs [?? ?L] 0d95 158a
                               call     l_lcd_print         ;  0 OV rs ?? [?L ??] 0d96 23f5
;   65 lcd_print(0, 32, test4)
                               movlw    32                  ;  0 OV ?? ?? [?? ??] 0d97 3020
                               datalo_clr v___y_13          ;  0 OV ?? ?s [?? ??] 0d98 1283
                               datahi_clr v___y_13          ;  0 OV ?s rs [?? ??] 0d99 1303
                               movwf    v___y_13            ;  0 OV rs rs [?? ??] 0d9a 00d7
                               movlw    17                  ;  0 OV rs rs [?? ??] 0d9b 3011
                                                            ; W = v___y_13
                               movwf    v____str_count_1    ;  0 OV rs rs [?? ??] 0d9c 00db
                               clrf     v____str_count_1+1  ;  0 OV rs rs [?? ??] 0d9d 01dc
                                                            ; W = v____str_count_1
                               movlw    l__data_test4       ;  0 OV rs rs [?? ??] 0d9e 304d
                                                            ; W = v____str_count_1
                               movwf    v___str_3           ;  0 OV rs rs [?? ??] 0d9f 00de
                               movlw    HIGH l__data_test4  ;  0 OV rs rs [?? ??] 0da0 3002
                                                            ; W = v___str_3
                               iorlw    64                  ;  0 OV rs rs [?? ??] 0da1 3840
                               movwf    v___str_3+1         ;  0 OV rs rs [?? ??] 0da2 00df
                               movlw    0                   ;  0 OV rs rs [?? ??] 0da3 3000
                                                            ; W = v___str_3
                               branchlo_set l_lcd_print     ;  0 OV rs rs [?? ?L] 0da4 158a
                               call     l_lcd_print         ;  0 OV rs ?? [?L ??] 0da5 23f5
;   66 lcd_print(0, 40, test5)
                               movlw    40                  ;  0 OV ?? ?? [?? ??] 0da6 3028
                               datalo_clr v___y_13          ;  0 OV ?? ?s [?? ??] 0da7 1283
                               datahi_clr v___y_13          ;  0 OV ?s rs [?? ??] 0da8 1303
                               movwf    v___y_13            ;  0 OV rs rs [?? ??] 0da9 00d7
                               movlw    13                  ;  0 OV rs rs [?? ??] 0daa 300d
                                                            ; W = v___y_13
                               movwf    v____str_count_1    ;  0 OV rs rs [?? ??] 0dab 00db
                               clrf     v____str_count_1+1  ;  0 OV rs rs [?? ??] 0dac 01dc
                                                            ; W = v____str_count_1
                               movlw    l__data_test5       ;  0 OV rs rs [?? ??] 0dad 306d
                                                            ; W = v____str_count_1
                               movwf    v___str_3           ;  0 OV rs rs [?? ??] 0dae 00de
                               movlw    HIGH l__data_test5  ;  0 OV rs rs [?? ??] 0daf 3002
                                                            ; W = v___str_3
                               iorlw    64                  ;  0 OV rs rs [?? ??] 0db0 3840
                               movwf    v___str_3+1         ;  0 OV rs rs [?? ??] 0db1 00df
                               movlw    0                   ;  0 OV rs rs [?? ??] 0db2 3000
                                                            ; W = v___str_3
                               branchlo_set l_lcd_print     ;  0 OV rs rs [?? ?L] 0db3 158a
                               call     l_lcd_print         ;  0 OV rs ?? [?L ??] 0db4 23f5
;   69 for 150 using timer loop
                               datalo_clr v_timer           ;  0 OV ?? ?s [?? ??] 0db5 1283
                               datahi_clr v_timer           ;  0 OV ?s rs [?? ??] 0db6 1303
                               clrf     v_timer             ;  0 OV rs rs [?? ??] 0db7 01be
l__l950
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
                               comf     v_timer,w           ;  0 OV rs rs [?? ??] 0db8 093e
                               movwf    v____temp_47        ;  0 OV rs rs [?? ??] 0db9 00b9
                               movlw    151                 ;  0 OV rs rs [?? ??] 0dba 3097
                                                            ; W = v____temp_47
                               addwf    v____temp_47,f      ;  0 OV rs rs [?? ??] 0dbb 07b9
                               clrf     v___x0_8            ;  0 OV rs rs [?? ??] 0dbc 01c7
                               movlw    49                  ;  0 OV rs rs [?? ??] 0dbd 3031
                               movwf    v___y_16            ;  0 OV rs rs [?? ??] 0dbe 00c8
                               movlw    54                  ;  0 OV rs rs [?? ??] 0dbf 3036
                                                            ; W = v___y_16
                               movwf    v___x1_8            ;  0 OV rs rs [?? ??] 0dc0 00c9
                               movf     v____temp_47,w      ;  0 OV rs rs [?? ??] 0dc1 0839
                                                            ; W = v___x1_8
                               movwf    v___value_4         ;  0 OV rs rs [?? ??] 0dc2 00ca
                                                            ; W = v____temp_47
                               clrf     v___value_4+1       ;  0 OV rs rs [?? ??] 0dc3 01cb
                                                            ; W = v___value_4
                               movlw    150                 ;  0 OV rs rs [?? ??] 0dc4 3096
                                                            ; W = v___value_4
                               movwf    v___max_4           ;  0 OV rs rs [?? ??] 0dc5 00cc
                               clrf     v___max_4+1         ;  0 OV rs rs [?? ??] 0dc6 01cd
                                                            ; W = v___max_4
                               bsf      v__bitbucket, 7 ; startleft2  ;  0 OV rs rs [?? ??] 0dc7 17c5
                                                            ; W = v___max_4
; glcd_common.jal
;  218 	maxX = x1 - x0 - 1 			-- Calculate our maximum horizontal space we can use.
                               movf     v___x0_8,w          ;  0 OV rs rs [?? ??] 0dc8 0847
                                                            ; W = v___max_4
                               subwf    v___x1_8,w          ;  0 OV rs rs [?? ??] 0dc9 0249
                                                            ; W = v___x0_8
                               movwf    v____temp_123+1     ;  0 OV rs rs [?? ??] 0dca 00d2
                               decf     v____temp_123+1,w   ;  0 OV rs rs [?? ??] 0dcb 0352
                                                            ; W = v____temp_123
                               movwf    v___maxx_1          ;  0 OV rs rs [?? ??] 0dcc 00ce
;  219 	theValue = (value*100)		-- Times 100.. Because we cannot handle numbers > 1
                               movf     v___value_4,w       ;  0 OV rs rs [?? ??] 0dcd 084a
                                                            ; W = v___maxx_1
                               movwf    v__pic_multiplier   ;  0 OV rs rs [?? ??] 0dce 00a0
                                                            ; W = v___value_4
                               movf     v___value_4+1,w     ;  0 OV rs rs [?? ??] 0dcf 084b
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplier+1 ;  0 OV rs rs [?? ??] 0dd0 00a1
                                                            ; W = v___value_4
                               movlw    100                 ;  0 OV rs rs [?? ??] 0dd1 3064
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  0 OV rs rs [?? ??] 0dd2 00a2
                               clrf     v__pic_multiplicand+1;  0 OV rs rs [?? ??] 0dd3 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  0 OV rs rs [?? ?l] 0dd4 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  0 OV rs ?? [?l ??] 0dd5 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  0 OV ?? ?s [?? ??] 0dd6 1283
                               datahi_clr v__pic_mresult    ;  0 OV ?s rs [?? ??] 0dd7 1303
                               movf     v__pic_mresult,w    ;  0 OV rs rs [?? ??] 0dd8 0824
                               movwf    v___thevalue_2      ;  0 OV rs rs [?? ??] 0dd9 00cf
                                                            ; W = v__pic_mresult
                               movf     v__pic_mresult+1,w  ;  0 OV rs rs [?? ??] 0dda 0825
                                                            ; W = v___thevalue_2
                               movwf    v___thevalue_2+1    ;  0 OV rs rs [?? ??] 0ddb 00d0
                                                            ; W = v__pic_mresult
;  220 	theValue = theValue / max	-- Calculate percentage
                               movf     v___max_4,w         ;  0 OV rs rs [?? ??] 0ddc 084c
                                                            ; W = v___thevalue_2
                               movwf    v__pic_divisor      ;  0 OV rs rs [?? ??] 0ddd 00a4
                                                            ; W = v___max_4
                               movf     v___max_4+1,w       ;  0 OV rs rs [?? ??] 0dde 084d
                                                            ; W = v__pic_divisor
                               movwf    v__pic_divisor+1    ;  0 OV rs rs [?? ??] 0ddf 00a5
                                                            ; W = v___max_4
                               movf     v___thevalue_2,w    ;  0 OV rs rs [?? ??] 0de0 084f
                                                            ; W = v__pic_divisor
                               movwf    v__pic_dividend     ;  0 OV rs rs [?? ??] 0de1 00a0
                                                            ; W = v___thevalue_2
                               movf     v___thevalue_2+1,w  ;  0 OV rs rs [?? ??] 0de2 0850
                                                            ; W = v__pic_dividend
                               movwf    v__pic_dividend+1   ;  0 OV rs rs [?? ??] 0de3 00a1
                                                            ; W = v___thevalue_2
                               branchlo_clr l__pic_divide   ;  0 OV rs rs [?? ?l] 0de4 118a
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  0 OV rs ?? [?l ??] 0de5 22a9
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  0 OV ?? ?s [?? ??] 0de6 1283
                               datahi_clr v__pic_quotient   ;  0 OV ?s rs [?? ??] 0de7 1303
                               movf     v__pic_quotient,w   ;  0 OV rs rs [?? ??] 0de8 0826
                               movwf    v___thevalue_2      ;  0 OV rs rs [?? ??] 0de9 00cf
                                                            ; W = v__pic_quotient
                               movf     v__pic_quotient+1,w ;  0 OV rs rs [?? ??] 0dea 0827
                                                            ; W = v___thevalue_2
                               movwf    v___thevalue_2+1    ;  0 OV rs rs [?? ??] 0deb 00d0
                                                            ; W = v__pic_quotient
;  221 	theValue = theValue * maxX	-- Times the maxX so that 100% = maxX
                               movf     v___thevalue_2,w    ;  0 OV rs rs [?? ??] 0dec 084f
                                                            ; W = v___thevalue_2
                               movwf    v__pic_multiplier   ;  0 OV rs rs [?? ??] 0ded 00a0
                                                            ; W = v___thevalue_2
                               movf     v___thevalue_2+1,w  ;  0 OV rs rs [?? ??] 0dee 0850
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplier+1 ;  0 OV rs rs [?? ??] 0def 00a1
                                                            ; W = v___thevalue_2
                               movf     v___maxx_1,w        ;  0 OV rs rs [?? ??] 0df0 084e
                                                            ; W = v__pic_multiplier
                               movwf    v__pic_multiplicand ;  0 OV rs rs [?? ??] 0df1 00a2
                                                            ; W = v___maxx_1
                               clrf     v__pic_multiplicand+1;  0 OV rs rs [?? ??] 0df2 01a3
                                                            ; W = v__pic_multiplicand
                               branchlo_clr l__pic_multiply ;  0 OV rs rs [?? ?l] 0df3 118a
                                                            ; W = v__pic_multiplicand
                               call     l__pic_multiply     ;  0 OV rs ?? [?l ??] 0df4 2296
                                                            ; W = v__pic_multiplicand
                               datalo_clr v__pic_mresult    ;  0 OV ?? ?s [?? ??] 0df5 1283
                               datahi_clr v__pic_mresult    ;  0 OV ?s rs [?? ??] 0df6 1303
                               movf     v__pic_mresult,w    ;  0 OV rs rs [?? ??] 0df7 0824
                               movwf    v___thevalue_2      ;  0 OV rs rs [?? ??] 0df8 00cf
                                                            ; W = v__pic_mresult
                               movf     v__pic_mresult+1,w  ;  0 OV rs rs [?? ??] 0df9 0825
                                                            ; W = v___thevalue_2
                               movwf    v___thevalue_2+1    ;  0 OV rs rs [?? ??] 0dfa 00d0
                                                            ; W = v__pic_mresult
;  222 	theValue = theValue / 100	-- And divide that by 100, so that we get a number that is below maxX
                               movlw    100                 ;  0 OV rs rs [?? ??] 0dfb 3064
                                                            ; W = v___thevalue_2
                               movwf    v__pic_divisor      ;  0 OV rs rs [?? ??] 0dfc 00a4
                               clrf     v__pic_divisor+1    ;  0 OV rs rs [?? ??] 0dfd 01a5
                                                            ; W = v__pic_divisor
                               movf     v___thevalue_2,w    ;  0 OV rs rs [?? ??] 0dfe 084f
                                                            ; W = v__pic_divisor
                               movwf    v__pic_dividend     ;  0 OV rs rs [?? ??] 0dff 00a0
                                                            ; W = v___thevalue_2
                               movf     v___thevalue_2+1,w  ;  0 OV rs rs [?? ??] 0e00 0850
                                                            ; W = v__pic_dividend
                               movwf    v__pic_dividend+1   ;  0 OV rs rs [?? ??] 0e01 00a1
                                                            ; W = v___thevalue_2
                               branchlo_clr l__pic_divide   ;  0 OV rs rs [?? ?l] 0e02 118a
                                                            ; W = v__pic_dividend
                               call     l__pic_divide       ;  0 OV rs ?? [?l ??] 0e03 22a9
                                                            ; W = v__pic_dividend
                               datalo_clr v__pic_quotient   ;  0 OV ?? ?s [?? ??] 0e04 1283
                               datahi_clr v__pic_quotient   ;  0 OV ?s rs [?? ??] 0e05 1303
                               movf     v__pic_quotient,w   ;  0 OV rs rs [?? ??] 0e06 0826
                               movwf    v___thevalue_2      ;  0 OV rs rs [?? ??] 0e07 00cf
                                                            ; W = v__pic_quotient
                               movf     v__pic_quotient+1,w ;  0 OV rs rs [?? ??] 0e08 0827
                                                            ; W = v___thevalue_2
                               movwf    v___thevalue_2+1    ;  0 OV rs rs [?? ??] 0e09 00d0
                                                            ; W = v__pic_quotient
;  225 	if startLeft then
                               branchlo_set l__l953         ;  0 OV rs rs [?? ?L] 0e0a 158a
                                                            ; W = v___thevalue_2
                               btfss    v__bitbucket, 7 ; startleft2  ;  0 OV rs rs [?L ?L] 0e0b 1fc5
                                                            ; W = v___thevalue_2
                               goto     l__l953             ;  0 OV rs rs [?L ?L] 0e0c 2e3b
                                                            ; W = v___thevalue_2
; main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; glcd_common.jal
;  226 		lcd_filled_rect(x0, y, theValue+1, y+5, 1)		-- Fill the part that needs filling
                               movlw    1                   ;  0 OV rs rs [?L ?L] 0e0d 3001
                               addwf    v___thevalue_2,w    ;  0 OV rs rs [?L ?L] 0e0e 074f
                               movwf    v____temp_123       ;  0 OV rs rs [?L ?L] 0e0f 00d1
                               movlw    0                   ;  0 OV rs rs [?L ?L] 0e10 3000
                                                            ; W = v____temp_123
                               btfsc    v__status, v__c     ;  0 OV rs rs [?L ?L] 0e11 1803
                               movlw    1                   ;  0 OV rs rs [?L ?L] 0e12 3001
                               addwf    v___thevalue_2+1,w  ;  0 OV rs rs [?L ?L] 0e13 0750
                               movwf    v____temp_123+1     ;  0 OV rs rs [?L ?L] 0e14 00d2
                               movlw    5                   ;  0 OV rs rs [?L ?L] 0e15 3005
                                                            ; W = v____temp_123
                               addwf    v___y_16,w          ;  0 OV rs rs [?L ?L] 0e16 0748
                               movwf    v____temp_123+2     ;  0 OV rs rs [?L ?L] 0e17 00d3
                               movf     v___y_16,w          ;  0 OV rs rs [?L ?L] 0e18 0848
                                                            ; W = v____temp_123
                               movwf    v___y0_5            ;  0 OV rs rs [?L ?L] 0e19 00d7
                                                            ; W = v___y_16
                               movf     v____temp_123,w     ;  0 OV rs rs [?L ?L] 0e1a 0851
                                                            ; W = v___y0_5
                               movwf    v___x1_5            ;  0 OV rs rs [?L ?L] 0e1b 00db
                                                            ; W = v____temp_123
                               movf     v____temp_123+2,w   ;  0 OV rs rs [?L ?L] 0e1c 0853
                                                            ; W = v___x1_5
                               movwf    v___y1_5            ;  0 OV rs rs [?L ?L] 0e1d 00dd
                                                            ; W = v____temp_123
                               datalo_set v____bitbucket_9 ; state1;  0 OV rs rS [?L ?L] 0e1e 1683
                                                            ; W = v___y1_5
                               bsf      v____bitbucket_9, 0 ; state1;  0 OV rS rS [?L ?L] 0e1f 1420
                                                            ; W = v___y1_5
                               datalo_clr v___x0_8          ;  0 OV rS rs [?L ?L] 0e20 1283
                                                            ; W = v___y1_5
                               movf     v___x0_8,w          ;  0 OV rs rs [?L ?L] 0e21 0847
                                                            ; W = v___y1_5
                               branchlo_clr l_lcd_filled_rect;  0 OV rs rs [?L ?l] 0e22 118a
                                                            ; W = v___x0_8
                               call     l_lcd_filled_rect   ;  0 OV rs ?? [?l ??] 0e23 27e0
                                                            ; W = v___x0_8
;  227 		lcd_filled_rect(theValue, y+1, x1-1, y+5, 0)	-- And empty the part that doesn't
                               datalo_clr v___y_16          ;  0 OV ?? ?s [?? ??] 0e24 1283
                               datahi_clr v___y_16          ;  0 OV ?s rs [?? ??] 0e25 1303
                               incf     v___y_16,w          ;  0 OV rs rs [?? ??] 0e26 0a48
                               movwf    v____temp_123       ;  0 OV rs rs [?? ??] 0e27 00d1
                               decf     v___x1_8,w          ;  0 OV rs rs [?? ??] 0e28 0349
                                                            ; W = v____temp_123
                               movwf    v____temp_123+1     ;  0 OV rs rs [?? ??] 0e29 00d2
                               movlw    5                   ;  0 OV rs rs [?? ??] 0e2a 3005
                                                            ; W = v____temp_123
                               addwf    v___y_16,w          ;  0 OV rs rs [?? ??] 0e2b 0748
                               movwf    v____temp_123+2     ;  0 OV rs rs [?? ??] 0e2c 00d3
                               movf     v____temp_123,w     ;  0 OV rs rs [?? ??] 0e2d 0851
                                                            ; W = v____temp_123
                               movwf    v___y0_5            ;  0 OV rs rs [?? ??] 0e2e 00d7
                                                            ; W = v____temp_123
                               movf     v____temp_123+1,w   ;  0 OV rs rs [?? ??] 0e2f 0852
                                                            ; W = v___y0_5
                               movwf    v___x1_5            ;  0 OV rs rs [?? ??] 0e30 00db
                                                            ; W = v____temp_123
                               movf     v____temp_123+2,w   ;  0 OV rs rs [?? ??] 0e31 0853
                                                            ; W = v___x1_5
                               movwf    v___y1_5            ;  0 OV rs rs [?? ??] 0e32 00dd
                                                            ; W = v____temp_123
                               datalo_set v____bitbucket_9 ; state1;  0 OV rs rS [?? ??] 0e33 1683
                                                            ; W = v___y1_5
                               bcf      v____bitbucket_9, 0 ; state1;  0 OV rS rS [?? ??] 0e34 1020
                                                            ; W = v___y1_5
                               datalo_clr v___thevalue_2    ;  0 OV rS rs [?? ??] 0e35 1283
                                                            ; W = v___y1_5
                               movf     v___thevalue_2,w    ;  0 OV rs rs [?? ??] 0e36 084f
                                                            ; W = v___y1_5
                               branchlo_clr l_lcd_filled_rect;  0 OV rs rs [?? ?l] 0e37 118a
                                                            ; W = v___thevalue_2
                               call     l_lcd_filled_rect   ;  0 OV rs ?? [?l ??] 0e38 27e0
                                                            ; W = v___thevalue_2
; main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; glcd_common.jal
;  228 	else
                               branchlo_set l__l954         ;  0 OV ?? ?? [?? ?L] 0e39 158a
                               goto     l__l954             ;  0 OV ?? ?? [?L ?L] 0e3a 2e67
l__l953
; main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; glcd_common.jal
;  229 		lcd_filled_rect(x0, y, theValue+1, y+5, 0)		-- Fill the part that needs filling
                               movlw    1                   ;  0 OV rs rs [?L ?L] 0e3b 3001
                                                            ; W = v___thevalue_2
                               addwf    v___thevalue_2,w    ;  0 OV rs rs [?L ?L] 0e3c 074f
                               movwf    v____temp_123       ;  0 OV rs rs [?L ?L] 0e3d 00d1
                               movlw    0                   ;  0 OV rs rs [?L ?L] 0e3e 3000
                                                            ; W = v____temp_123
                               btfsc    v__status, v__c     ;  0 OV rs rs [?L ?L] 0e3f 1803
                               movlw    1                   ;  0 OV rs rs [?L ?L] 0e40 3001
                               addwf    v___thevalue_2+1,w  ;  0 OV rs rs [?L ?L] 0e41 0750
                               movwf    v____temp_123+1     ;  0 OV rs rs [?L ?L] 0e42 00d2
                               movlw    5                   ;  0 OV rs rs [?L ?L] 0e43 3005
                                                            ; W = v____temp_123
                               addwf    v___y_16,w          ;  0 OV rs rs [?L ?L] 0e44 0748
                               movwf    v____temp_123+2     ;  0 OV rs rs [?L ?L] 0e45 00d3
                               movf     v___y_16,w          ;  0 OV rs rs [?L ?L] 0e46 0848
                                                            ; W = v____temp_123
                               movwf    v___y0_5            ;  0 OV rs rs [?L ?L] 0e47 00d7
                                                            ; W = v___y_16
                               movf     v____temp_123,w     ;  0 OV rs rs [?L ?L] 0e48 0851
                                                            ; W = v___y0_5
                               movwf    v___x1_5            ;  0 OV rs rs [?L ?L] 0e49 00db
                                                            ; W = v____temp_123
                               movf     v____temp_123+2,w   ;  0 OV rs rs [?L ?L] 0e4a 0853
                                                            ; W = v___x1_5
                               movwf    v___y1_5            ;  0 OV rs rs [?L ?L] 0e4b 00dd
                                                            ; W = v____temp_123
                               datalo_set v____bitbucket_9 ; state1;  0 OV rs rS [?L ?L] 0e4c 1683
                                                            ; W = v___y1_5
                               bcf      v____bitbucket_9, 0 ; state1;  0 OV rS rS [?L ?L] 0e4d 1020
                                                            ; W = v___y1_5
                               datalo_clr v___x0_8          ;  0 OV rS rs [?L ?L] 0e4e 1283
                                                            ; W = v___y1_5
                               movf     v___x0_8,w          ;  0 OV rs rs [?L ?L] 0e4f 0847
                                                            ; W = v___y1_5
                               branchlo_clr l_lcd_filled_rect;  0 OV rs rs [?L ?l] 0e50 118a
                                                            ; W = v___x0_8
                               call     l_lcd_filled_rect   ;  0 OV rs ?? [?l ??] 0e51 27e0
                                                            ; W = v___x0_8
;  230 		lcd_filled_rect(theValue, y+1, x1-1, y+5, 1)	-- And empty the part that doesn't
                               datalo_clr v___y_16          ;  0 OV ?? ?s [?? ??] 0e52 1283
                               datahi_clr v___y_16          ;  0 OV ?s rs [?? ??] 0e53 1303
                               incf     v___y_16,w          ;  0 OV rs rs [?? ??] 0e54 0a48
                               movwf    v____temp_123       ;  0 OV rs rs [?? ??] 0e55 00d1
                               decf     v___x1_8,w          ;  0 OV rs rs [?? ??] 0e56 0349
                                                            ; W = v____temp_123
                               movwf    v____temp_123+1     ;  0 OV rs rs [?? ??] 0e57 00d2
                               movlw    5                   ;  0 OV rs rs [?? ??] 0e58 3005
                                                            ; W = v____temp_123
                               addwf    v___y_16,w          ;  0 OV rs rs [?? ??] 0e59 0748
                               movwf    v____temp_123+2     ;  0 OV rs rs [?? ??] 0e5a 00d3
                               movf     v____temp_123,w     ;  0 OV rs rs [?? ??] 0e5b 0851
                                                            ; W = v____temp_123
                               movwf    v___y0_5            ;  0 OV rs rs [?? ??] 0e5c 00d7
                                                            ; W = v____temp_123
                               movf     v____temp_123+1,w   ;  0 OV rs rs [?? ??] 0e5d 0852
                                                            ; W = v___y0_5
                               movwf    v___x1_5            ;  0 OV rs rs [?? ??] 0e5e 00db
                                                            ; W = v____temp_123
                               movf     v____temp_123+2,w   ;  0 OV rs rs [?? ??] 0e5f 0853
                                                            ; W = v___x1_5
                               movwf    v___y1_5            ;  0 OV rs rs [?? ??] 0e60 00dd
                                                            ; W = v____temp_123
                               datalo_set v____bitbucket_9 ; state1;  0 OV rs rS [?? ??] 0e61 1683
                                                            ; W = v___y1_5
                               bsf      v____bitbucket_9, 0 ; state1;  0 OV rS rS [?? ??] 0e62 1420
                                                            ; W = v___y1_5
                               datalo_clr v___thevalue_2    ;  0 OV rS rs [?? ??] 0e63 1283
                                                            ; W = v___y1_5
                               movf     v___thevalue_2,w    ;  0 OV rs rs [?? ??] 0e64 084f
                                                            ; W = v___y1_5
                               branchlo_clr l_lcd_filled_rect;  0 OV rs rs [?? ?l] 0e65 118a
                                                            ; W = v___thevalue_2
                               call     l_lcd_filled_rect   ;  0 OV rs ?? [?l ??] 0e66 27e0
                                                            ; W = v___thevalue_2
; main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; glcd_common.jal
;  231 	end if
l__l954
;  232 	lcd_rect(x0,y,x1,y+5)							-- Draw the rectangle around it
                               movlw    5                   ;  0 OV ?? ?? [?? ??] 0e67 3005
                               datalo_clr v___y_16          ;  0 OV ?? ?s [?? ??] 0e68 1283
                               datahi_clr v___y_16          ;  0 OV ?s rs [?? ??] 0e69 1303
                               addwf    v___y_16,w          ;  0 OV rs rs [?? ??] 0e6a 0748
                               movwf    v____rparam16_1     ;  0 OV rs rs [?? ??] 0e6b 00d4
; main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; glcd_common.jal
;   52    lcd_line ( x0,y0, x1,y0 ,1)
                               movf     v___y_16,w          ;  0 OV rs rs [?? ??] 0e6c 0848
                                                            ; W = v____rparam16_1
                               movwf    v___y0_1            ;  0 OV rs rs [?? ??] 0e6d 00d7
                                                            ; W = v___y_16
                               movf     v___x1_8,w          ;  0 OV rs rs [?? ??] 0e6e 0849
                                                            ; W = v___y0_1
                               movwf    v___x1_1            ;  0 OV rs rs [?? ??] 0e6f 00db
                                                            ; W = v___x1_8
                               movf     v___y_16,w          ;  0 OV rs rs [?? ??] 0e70 0848
                                                            ; W = v___x1_1
                               movwf    v___y1_1            ;  0 OV rs rs [?? ??] 0e71 00dd
                                                            ; W = v___y_16
                               bsf      v____bitbucket_11, 0 ; onoff5;  0 OV rs rs [?? ??] 0e72 146a
                                                            ; W = v___y1_1
                               movf     v___x0_8,w          ;  0 OV rs rs [?? ??] 0e73 0847
                                                            ; W = v___y1_1
                               branchlo_clr l_lcd_line      ;  0 OV rs rs [?? ?l] 0e74 118a
                                                            ; W = v___x0_8
                               call     l_lcd_line          ;  0 OV rs ?? [?l ??] 0e75 270c
                                                            ; W = v___x0_8
;   53    lcd_line ( x1,y0, x1,y1 ,1)
                               datalo_clr v___y_16          ;  0 OV ?? ?s [?? ??] 0e76 1283
                               datahi_clr v___y_16          ;  0 OV ?s rs [?? ??] 0e77 1303
                               movf     v___y_16,w          ;  0 OV rs rs [?? ??] 0e78 0848
                               movwf    v___y0_1            ;  0 OV rs rs [?? ??] 0e79 00d7
                                                            ; W = v___y_16
                               movf     v___x1_8,w          ;  0 OV rs rs [?? ??] 0e7a 0849
                                                            ; W = v___y0_1
                               movwf    v___x1_1            ;  0 OV rs rs [?? ??] 0e7b 00db
                                                            ; W = v___x1_8
                               movf     v____rparam16_1,w   ;  0 OV rs rs [?? ??] 0e7c 0854
                                                            ; W = v___x1_1
                               movwf    v___y1_1            ;  0 OV rs rs [?? ??] 0e7d 00dd
                                                            ; W = v____rparam16_1
                               bsf      v____bitbucket_11, 0 ; onoff5;  0 OV rs rs [?? ??] 0e7e 146a
                                                            ; W = v___y1_1
                               movf     v___x1_8,w          ;  0 OV rs rs [?? ??] 0e7f 0849
                                                            ; W = v___y1_1
                               branchlo_clr l_lcd_line      ;  0 OV rs rs [?? ?l] 0e80 118a
                                                            ; W = v___x1_8
                               call     l_lcd_line          ;  0 OV rs ?? [?l ??] 0e81 270c
                                                            ; W = v___x1_8
;   54    lcd_line ( x1,y1, x0,y1 ,1)
                               datalo_clr v____rparam16_1   ;  0 OV ?? ?s [?? ??] 0e82 1283
                               datahi_clr v____rparam16_1   ;  0 OV ?s rs [?? ??] 0e83 1303
                               movf     v____rparam16_1,w   ;  0 OV rs rs [?? ??] 0e84 0854
                               movwf    v___y0_1            ;  0 OV rs rs [?? ??] 0e85 00d7
                                                            ; W = v____rparam16_1
                               movf     v___x0_8,w          ;  0 OV rs rs [?? ??] 0e86 0847
                                                            ; W = v___y0_1
                               movwf    v___x1_1            ;  0 OV rs rs [?? ??] 0e87 00db
                                                            ; W = v___x0_8
                               movf     v____rparam16_1,w   ;  0 OV rs rs [?? ??] 0e88 0854
                                                            ; W = v___x1_1
                               movwf    v___y1_1            ;  0 OV rs rs [?? ??] 0e89 00dd
                                                            ; W = v____rparam16_1
                               bsf      v____bitbucket_11, 0 ; onoff5;  0 OV rs rs [?? ??] 0e8a 146a
                                                            ; W = v___y1_1
                               movf     v___x1_8,w          ;  0 OV rs rs [?? ??] 0e8b 0849
                                                            ; W = v___y1_1
                               branchlo_clr l_lcd_line      ;  0 OV rs rs [?? ?l] 0e8c 118a
                                                            ; W = v___x1_8
                               call     l_lcd_line          ;  0 OV rs ?? [?l ??] 0e8d 270c
                                                            ; W = v___x1_8
;   55    lcd_line ( x0,y1, x0,y0 ,1)
                               datalo_clr v____rparam16_1   ;  0 OV ?? ?s [?? ??] 0e8e 1283
                               datahi_clr v____rparam16_1   ;  0 OV ?s rs [?? ??] 0e8f 1303
                               movf     v____rparam16_1,w   ;  0 OV rs rs [?? ??] 0e90 0854
                               movwf    v___y0_1            ;  0 OV rs rs [?? ??] 0e91 00d7
                                                            ; W = v____rparam16_1
                               movf     v___x0_8,w          ;  0 OV rs rs [?? ??] 0e92 0847
                                                            ; W = v___y0_1
                               movwf    v___x1_1            ;  0 OV rs rs [?? ??] 0e93 00db
                                                            ; W = v___x0_8
                               movf     v___y_16,w          ;  0 OV rs rs [?? ??] 0e94 0848
                                                            ; W = v___x1_1
                               movwf    v___y1_1            ;  0 OV rs rs [?? ??] 0e95 00dd
                                                            ; W = v___y_16
                               bsf      v____bitbucket_11, 0 ; onoff5;  0 OV rs rs [?? ??] 0e96 146a
                                                            ; W = v___y1_1
                               movf     v___x0_8,w          ;  0 OV rs rs [?? ??] 0e97 0847
                                                            ; W = v___y1_1
                               branchlo_clr l_lcd_line      ;  0 OV rs rs [?? ?l] 0e98 118a
                                                            ; W = v___x0_8
                               call     l_lcd_line          ;  0 OV rs ?? [?l ??] 0e99 270c
                                                            ; W = v___x0_8
; main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; glcd_common.jal
;  232 	lcd_rect(x0,y,x1,y+5)							-- Draw the rectangle around it
; main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
;   72 	delay_1ms(10)
                               movlw    10                  ;  0 OV ?? ?? [?? ??] 0e9a 300a
                               datalo_clr v___n_3           ;  0 OV ?? ?s [?? ??] 0e9b 1283
                               datahi_clr v___n_3           ;  0 OV ?s rs [?? ??] 0e9c 1303
                               movwf    v___n_3             ;  0 OV rs rs [?? ??] 0e9d 00d5
                               clrf     v___n_3+1           ;  0 OV rs rs [?? ??] 0e9e 01d6
                                                            ; W = v___n_3
                               branchlo_clr l_delay_1ms     ;  0 OV rs rs [?? ?l] 0e9f 118a
                                                            ; W = v___n_3
                               call     l_delay_1ms         ;  0 OV rs ?? [?l ??] 0ea0 230d
                                                            ; W = v___n_3
;   73 end loop
                               datalo_clr v_timer           ;  0 OV ?? ?s [?? ??] 0ea1 1283
                               datahi_clr v_timer           ;  0 OV ?s rs [?? ??] 0ea2 1303
                               incf     v_timer,f           ;  0 OV rs rs [?? ??] 0ea3 0abe
                               movlw    150                 ;  0 OV rs rs [?? ??] 0ea4 3096
                               subwf    v_timer,w           ;  0 OV rs rs [?? ??] 0ea5 023e
                               branchlo_set l__l950         ;  0 OV rs rs [?? ?L] 0ea6 158a
                               btfss    v__status, v__z     ;  0 OV rs rs [?L ?L] 0ea7 1d03
                               goto     l__l950             ;  0 OV rs rs [?L ?L] 0ea8 2db8
;   75 lcd_clearscreen()
                               branchlo_nop l_lcd_clearscreen;  0 OV rs rs [?L ?L] 0ea9
                               call     l_lcd_clearscreen   ;  0 OV rs ?? [?L ??] 0ea9 2124
;   78 lcd_print(0, 0, adcte)
                               datalo_clr v___y_13          ;  0 OV ?? ?s [?? ??] 0eaa 1283
                               datahi_clr v___y_13          ;  0 OV ?s rs [?? ??] 0eab 1303
                               clrf     v___y_13            ;  0 OV rs rs [?? ??] 0eac 01d7
                               movlw    12                  ;  0 OV rs rs [?? ??] 0ead 300c
                               movwf    v____str_count_1    ;  0 OV rs rs [?? ??] 0eae 00db
                               clrf     v____str_count_1+1  ;  0 OV rs rs [?? ??] 0eaf 01dc
                                                            ; W = v____str_count_1
                               movlw    l__data_adcte       ;  0 OV rs rs [?? ??] 0eb0 307b
                                                            ; W = v____str_count_1
                               movwf    v___str_3           ;  0 OV rs rs [?? ??] 0eb1 00de
                               movlw    HIGH l__data_adcte  ;  0 OV rs rs [?? ??] 0eb2 3002
                                                            ; W = v___str_3
                               iorlw    64                  ;  0 OV rs rs [?? ??] 0eb3 3840
                               movwf    v___str_3+1         ;  0 OV rs rs [?? ??] 0eb4 00df
                               movlw    0                   ;  0 OV rs rs [?? ??] 0eb5 3000
                                                            ; W = v___str_3
                               branchlo_set l_lcd_print     ;  0 OV rs rs [?? ?L] 0eb6 158a
                               call     l_lcd_print         ;  0 OV rs ?? [?L ??] 0eb7 23f5
;   83 serial_hw_printf(done)
                               movlw    6                   ;  0 OV ?? ?? [?? ??] 0eb8 3006
                               datalo_clr v__str_count      ;  0 OV ?? ?s [?? ??] 0eb9 1283
                               datahi_clr v__str_count      ;  0 OV ?s rs [?? ??] 0eba 1303
                               movwf    v__str_count        ;  0 OV rs rs [?? ??] 0ebb 00d5
                               clrf     v__str_count+1      ;  0 OV rs rs [?? ??] 0ebc 01d6
                                                            ; W = v__str_count
                               movlw    l__data_done        ;  0 OV rs rs [?? ??] 0ebd 3090
                                                            ; W = v__str_count
                               movwf    v___str_1           ;  0 OV rs rs [?? ??] 0ebe 00db
                               movlw    HIGH l__data_done   ;  0 OV rs rs [?? ??] 0ebf 3002
                                                            ; W = v___str_1
                               iorlw    64                  ;  0 OV rs rs [?? ??] 0ec0 3840
                               movwf    v___str_1+1         ;  0 OV rs rs [?? ??] 0ec1 00dc
                               branchlo_clr l_serial_hw_printf;  0 OV rs rs [?? ?l] 0ec2 118a
                                                            ; W = v___str_1
                               call     l_serial_hw_printf  ;  0 OV rs ?? [?l ??] 0ec3 2525
                                                            ; W = v___str_1
;   85 var byte graphLeft 		= 8		-- X
                               movlw    8                   ;  0 OV ?? ?? [?? ??] 0ec4 3008
                               datalo_clr v_graphleft       ;  0 OV ?? ?s [?? ??] 0ec5 1283
                               datahi_clr v_graphleft       ;  0 OV ?s rs [?? ??] 0ec6 1303
                               movwf    v_graphleft         ;  0 OV rs rs [?? ??] 0ec7 00c1
;   86 var byte graphRight		= 126	-- X
                               movlw    126                 ;  0 OV rs rs [?? ??] 0ec8 307e
                                                            ; W = v_graphleft
                               movwf    v_graphright        ;  0 OV rs rs [?? ??] 0ec9 00c2
;   87 var byte graphTop		= 18	-- Y
                               movlw    18                  ;  0 OV rs rs [?? ??] 0eca 3012
                                                            ; W = v_graphright
                               movwf    v_graphtop          ;  0 OV rs rs [?? ??] 0ecb 00c3
;   88 var byte graphBottom	= 63	-- Y
                               movlw    63                  ;  0 OV rs rs [?? ??] 0ecc 303f
                                                            ; W = v_graphtop
                               movwf    v_graphbottom       ;  0 OV rs rs [?? ??] 0ecd 00c4
;   95 lcd_line(graphLeft, graphBottom, graphRight, graphBottom, 1)
                               movf     v_graphbottom,w     ;  0 OV rs rs [?? ??] 0ece 0844
                                                            ; W = v_graphbottom
                               movwf    v___y0_1            ;  0 OV rs rs [?? ??] 0ecf 00d7
                                                            ; W = v_graphbottom
                               movf     v_graphright,w      ;  0 OV rs rs [?? ??] 0ed0 0842
                                                            ; W = v___y0_1
                               movwf    v___x1_1            ;  0 OV rs rs [?? ??] 0ed1 00db
                                                            ; W = v_graphright
                               movf     v_graphbottom,w     ;  0 OV rs rs [?? ??] 0ed2 0844
                                                            ; W = v___x1_1
                               movwf    v___y1_1            ;  0 OV rs rs [?? ??] 0ed3 00dd
                                                            ; W = v_graphbottom
                               bsf      v____bitbucket_11, 0 ; onoff5;  0 OV rs rs [?? ??] 0ed4 146a
                                                            ; W = v___y1_1
                               movf     v_graphleft,w       ;  0 OV rs rs [?? ??] 0ed5 0841
                                                            ; W = v___y1_1
                               branchlo_clr l_lcd_line      ;  0 OV rs rs [?? ?l] 0ed6 118a
                                                            ; W = v_graphleft
                               call     l_lcd_line          ;  0 OV rs ?? [?l ??] 0ed7 270c
                                                            ; W = v_graphleft
;   96 lcd_line(graphLeft, graphTop, graphLeft, graphBottom, 1)
                               datalo_clr v_graphtop        ;  0 OV ?? ?s [?? ??] 0ed8 1283
                               datahi_clr v_graphtop        ;  0 OV ?s rs [?? ??] 0ed9 1303
                               movf     v_graphtop,w        ;  0 OV rs rs [?? ??] 0eda 0843
                               movwf    v___y0_1            ;  0 OV rs rs [?? ??] 0edb 00d7
                                                            ; W = v_graphtop
                               movf     v_graphleft,w       ;  0 OV rs rs [?? ??] 0edc 0841
                                                            ; W = v___y0_1
                               movwf    v___x1_1            ;  0 OV rs rs [?? ??] 0edd 00db
                                                            ; W = v_graphleft
                               movf     v_graphbottom,w     ;  0 OV rs rs [?? ??] 0ede 0844
                                                            ; W = v___x1_1
                               movwf    v___y1_1            ;  0 OV rs rs [?? ??] 0edf 00dd
                                                            ; W = v_graphbottom
                               bsf      v____bitbucket_11, 0 ; onoff5;  0 OV rs rs [?? ??] 0ee0 146a
                                                            ; W = v___y1_1
                               movf     v_graphleft,w       ;  0 OV rs rs [?? ??] 0ee1 0841
                                                            ; W = v___y1_1
                               branchlo_clr l_lcd_line      ;  0 OV rs rs [?? ?l] 0ee2 118a
                                                            ; W = v_graphleft
                               call     l_lcd_line          ;  0 OV rs ?? [?l ??] 0ee3 270c
                                                            ; W = v_graphleft
;   97 forever loop
l__l957
;   99 	measure_a = adc_read(ADC_CHANNEL_A)
                               movlw    0                   ;  0 OV ?? ?? [?? ??] 0ee4 3000
                               branchlo_clr l_adc_read      ;  0 OV ?? ?? [?? ?l] 0ee5 118a
                               call     l_adc_read          ;  0 OV ?? ?? [?l ??] 0ee6 2403
                               datalo_clr v__pic_temp       ;  0 OV ?? ?s [?? ??] 0ee7 1283
                               datahi_clr v__pic_temp       ;  0 OV ?s rs [?? ??] 0ee8 1303
                               movf     v__pic_temp,w       ;  0 OV rs rs [?? ??] 0ee9 0820
                               movwf    v_measure_a         ;  0 OV rs rs [?? ??] 0eea 00b4
                                                            ; W = v__pic_temp
                               movf     v__pic_temp+1,w     ;  0 OV rs rs [?? ??] 0eeb 0821
                                                            ; W = v_measure_a
                               movwf    v_measure_a+1       ;  0 OV rs rs [?? ??] 0eec 00b5
                                                            ; W = v__pic_temp
;  100 	e1 = (measure_a < (oldADC - 3))
                               movf     v_oldadc+1,w        ;  0 OV rs rs [?? ??] 0eed 0840
                                                            ; W = v_measure_a
                               movwf    v____temp_47+1      ;  0 OV rs rs [?? ??] 0eee 00ba
                                                            ; W = v_oldadc
                               movlw    3                   ;  0 OV rs rs [?? ??] 0eef 3003
                                                            ; W = v____temp_47
                               subwf    v_oldadc,w          ;  0 OV rs rs [?? ??] 0ef0 023f
                               movwf    v____temp_47        ;  0 OV rs rs [?? ??] 0ef1 00b9
                               btfss    v__status, v__c     ;  0 OV rs rs [?? ??] 0ef2 1c03
                                                            ; W = v____temp_47
                               decf     v____temp_47+1,f    ;  0 OV rs rs [?? ??] 0ef3 03ba
                                                            ; W = v____temp_47
                               movf     v_measure_a+1,w     ;  0 OV rs rs [?? ??] 0ef4 0835
                               subwf    v____temp_47+1,w    ;  0 OV rs rs [?? ??] 0ef5 023a
                                                            ; W = v_measure_a
                               branchlo_set l__l1165        ;  0 OV rs rs [?? ?L] 0ef6 158a
                               btfss    v__status, v__z     ;  0 OV rs rs [?L ?L] 0ef7 1d03
                               goto     l__l1165            ;  0 OV rs rs [?L ?L] 0ef8 2efb
                               movf     v_measure_a,w       ;  0 OV rs rs [?L ?L] 0ef9 0834
                               subwf    v____temp_47,w      ;  0 OV rs rs [?L ?L] 0efa 0239
                                                            ; W = v_measure_a
l__l1165
                               bcf      v__bitbucket, 5 ; e12  ;  0 OV rs rs [?L ?L] 0efb 12c5
                               branchlo_nop l__l1166        ;  0 OV rs rs [?L ?L] 0efc
                               btfsc    v__status, v__z     ;  0 OV rs rs [?L ?L] 0efc 1903
                               goto     l__l1166            ;  0 OV rs rs [?L ?L] 0efd 2f00
                               btfsc    v__status, v__c     ;  0 OV rs rs [?L ?L] 0efe 1803
                               bsf      v__bitbucket, 5 ; e12  ;  0 OV rs rs [?L ?L] 0eff 16c5
l__l1166
;  101 	e2 = (measure_a > (oldADC + 3))
                               movf     v_oldadc+1,w        ;  0 OV rs rs [?L ?L] 0f00 0840
                               movwf    v____temp_47+1      ;  0 OV rs rs [?L ?L] 0f01 00ba
                                                            ; W = v_oldadc
                               movlw    3                   ;  0 OV rs rs [?L ?L] 0f02 3003
                                                            ; W = v____temp_47
                               addwf    v_oldadc,w          ;  0 OV rs rs [?L ?L] 0f03 073f
                               movwf    v____temp_47        ;  0 OV rs rs [?L ?L] 0f04 00b9
                               btfsc    v__status, v__c     ;  0 OV rs rs [?L ?L] 0f05 1803
                                                            ; W = v____temp_47
                               incf     v____temp_47+1,f    ;  0 OV rs rs [?L ?L] 0f06 0aba
                                                            ; W = v____temp_47
                               movf     v_measure_a+1,w     ;  0 OV rs rs [?L ?L] 0f07 0835
                               subwf    v____temp_47+1,w    ;  0 OV rs rs [?L ?L] 0f08 023a
                                                            ; W = v_measure_a
                               branchlo_nop l__l1167        ;  0 OV rs rs [?L ?L] 0f09
                               btfss    v__status, v__z     ;  0 OV rs rs [?L ?L] 0f09 1d03
                               goto     l__l1167            ;  0 OV rs rs [?L ?L] 0f0a 2f0d
                               movf     v_measure_a,w       ;  0 OV rs rs [?L ?L] 0f0b 0834
                               subwf    v____temp_47,w      ;  0 OV rs rs [?L ?L] 0f0c 0239
                                                            ; W = v_measure_a
l__l1167
                               bcf      v__bitbucket, 6 ; e22  ;  0 OV rs rs [?L ?L] 0f0d 1345
                               branchlo_nop l__l1168        ;  0 OV rs rs [?L ?L] 0f0e
                               btfsc    v__status, v__z     ;  0 OV rs rs [?L ?L] 0f0e 1903
                               goto     l__l1168            ;  0 OV rs rs [?L ?L] 0f0f 2f12
                               btfss    v__status, v__c     ;  0 OV rs rs [?L ?L] 0f10 1c03
                               bsf      v__bitbucket, 6 ; e22  ;  0 OV rs rs [?L ?L] 0f11 1745
l__l1168
;  102 	if e1 | e2 then
                               bcf      v__bitbucket, 4 ; _btemp107  ;  0 OV rs rs [?L ?L] 0f12 1245
                               btfss    v__bitbucket, 5 ; e12  ;  0 OV rs rs [?L ?L] 0f13 1ec5
                               btfsc    v__bitbucket, 6 ; e22  ;  0 OV rs rs [?L ?L] 0f14 1b45
                               bsf      v__bitbucket, 4 ; _btemp107  ;  0 OV rs rs [?L ?L] 0f15 1645
                               branchlo_nop l__l957         ;  0 OV rs rs [?L ?L] 0f16
                               btfss    v__bitbucket, 4 ; _btemp107  ;  0 OV rs rs [?L ?L] 0f16 1e45
                               goto     l__l957             ;  0 OV rs rs [?L ?L] 0f17 2ee4
;  103 		lcd_num(0, 8, measure_a)
                               movlw    8                   ;  0 OV rs rs [?L ?L] 0f18 3008
                               movwf    v___y_11            ;  0 OV rs rs [?L ?L] 0f19 00d7
                               movf     v_measure_a,w       ;  0 OV rs rs [?L ?L] 0f1a 0834
                                                            ; W = v___y_11
                               movwf    v___num_1           ;  0 OV rs rs [?L ?L] 0f1b 00db
                                                            ; W = v_measure_a
                               movf     v_measure_a+1,w     ;  0 OV rs rs [?L ?L] 0f1c 0835
                                                            ; W = v___num_1
                               movwf    v___num_1+1         ;  0 OV rs rs [?L ?L] 0f1d 00dc
                                                            ; W = v_measure_a
                               movlw    0                   ;  0 OV rs rs [?L ?L] 0f1e 3000
                                                            ; W = v___num_1
                               branchlo_nop l_lcd_num       ;  0 OV rs rs [?L ?L] 0f1f
                               call     l_lcd_num           ;  0 OV rs ?? [?L ??] 0f1f 2127
;  104 		oldADC = measure_a
                               datalo_clr v_measure_a       ;  0 OV ?? ?s [?? ??] 0f20 1283
                               datahi_clr v_measure_a       ;  0 OV ?s rs [?? ??] 0f21 1303
                               movf     v_measure_a,w       ;  0 OV rs rs [?? ??] 0f22 0834
                               movwf    v_oldadc            ;  0 OV rs rs [?? ??] 0f23 00bf
                                                            ; W = v_measure_a
                               movf     v_measure_a+1,w     ;  0 OV rs rs [?? ??] 0f24 0835
                                                            ; W = v_oldadc
                               movwf    v_oldadc+1          ;  0 OV rs rs [?? ??] 0f25 00c0
                                                            ; W = v_measure_a
;  107 		ADCLowRes = adc_read_low_res(ADC_CHANNEL_A)
                               movlw    0                   ;  0 OV rs rs [?? ??] 0f26 3000
                                                            ; W = v_oldadc
                               branchlo_clr l_adc_read_low_res;  0 OV rs rs [?? ?l] 0f27 118a
                               call     l_adc_read_low_res  ;  0 OV rs ?? [?l ??] 0f28 2414
;  113 	end if
;  126 end loop
                               branchlo_set l__l957         ;  0 OV ?? ?? [?? ?L] 0f29 158a
                               goto     l__l957             ;  0 OV ?? ?? [?L ?L] 0f2a 2ee4
                               end
; --- procedures & call stack
;{root} ----- -U- (frame_sz=38 blocks=37)
;   {block enter}
;     --- records ---
;     --- variables ---
;     460c38:_jal_version  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 2004
;     460d28:_jal_build  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 20100602
;     4613f8:_device_id word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 8288
;     461a58:_pictype  (type=a dflags=C---- sz=6 use=0 assigned=0)
;      = 49,54,70,56,56,54
;     461908:_datasheet  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 52,49,50,57,49
;     462108:_pgmspec  (type=a dflags=C---- sz=5 use=0 assigned=0)
;      = 52,49,50,56,55
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
;     462e18:_true bit (type=B dflags=C--B- sz=1 use=20 assigned=0 bit=0)
;      = 1
;     462f88:_false bit (type=B dflags=C--B- sz=1 use=5 assigned=0 bit=0)
;      = 0
;     4612f8:_high bit (type=B dflags=C--B- sz=1 use=10 assigned=0 bit=0)
;      = 1
;     463108:_low bit (type=B dflags=C--B- sz=1 use=10 assigned=0 bit=0)
;      = 0
;     463238:_on bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     463368:_off bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     463498:_enabled bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     4635c8:_disabled bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 0
;     4636f8:_input bit (type=B dflags=C--B- sz=1 use=11 assigned=0 bit=0)
;      = 1
;     463828:_output bit (type=B dflags=C--B- sz=1 use=7 assigned=0 bit=0)
;      = 0
;     4639f8:_all_input byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 255
;     463b68:_all_output byte (type=i dflags=C---- sz=1 use=2 assigned=0)
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
;     461248:_pic_18f1330  (type=i dflags=C---U sz=4 use=0 assigned=0)
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
;      = 1319008
;     485618:_target_chip_name  (type=a dflags=C---- sz=6 use=0 assigned=0)
;      = 49,54,102,56,56,54
;     485408:_target_bank_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 128
;     485348:_target_page_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 2048
;     485288:__stack_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8
;     4851c8:__code_size  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 8192
;     485c68:__eeprom  (type=a dflags=C---- sz=256 use=0 assigned=0)
;      = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;     485e38:__eeprom_used  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 0
;     485ef8:__eeprom_base  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 8448
;     486108:__id0  (type=a dflags=C---- sz=4 use=0 assigned=0)
;      = 0,0,0,0
;     4861e8:__id0_used  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 0
;     4862a8:__id0_base  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 8192
;     4854c8:__pic_accum byte (type=i dflags=-V--- sz=1 use=8 assigned=8 base=007e)
;     485108:__pic_isr_w byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=007f)
;     486a88:__fuses_ct word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 2
;     486d28:__fuse_base  (type=a dflags=C---- sz=4 use=0 assigned=0)
;      = 8199,8200
;     486f68:__fuses  (type=a dflags=C---- sz=4 use=0 assigned=0)
;      = 12274,16383
;     486988:_indf byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0000)
;     486bf8:__ind byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0000)
;     487108:_tmr0 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0001)
;     4872d8:_pcl byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0002)
;     487588:__pcl byte (type=i dflags=-V--- sz=1 use=9 assigned=11 base=0002)
;     487838:_status byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0003)
;     487ae8:_status_irp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> status+0
;     487c38:_status_rp  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=5) ---> status+0
;     487e28:_status_nto bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> status+0
;     487f88:_status_npd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> status+0
;     488108:_status_z bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> status+0
;     488268:_status_dc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> status+0
;     4883c8:_status_c bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> status+0
;     488528:__status byte (type=i dflags=-V--- sz=1 use=144 assigned=56 base=0003)
;     4888d8:__irp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 7
;     488a48:__rp1 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 6
;     488bb8:__rp0 byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 5
;     488d28:__not_to byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 4
;     488e98:__not_pd byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 3
;     489108:__z byte (type=i dflags=C---- sz=1 use=180 assigned=0)
;      = 2
;     489278:__dc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 1
;     4893e8:__c byte (type=i dflags=C---- sz=1 use=220 assigned=0)
;      = 0
;     4887d8:_fsr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0004)
;     489708:__fsr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0004)
;     4899b8:_porta byte (type=i dflags=-V--- sz=1 use=1 assigned=5 base=0005)
;     489b48:__porta_shadow byte (type=i dflags=----- auto sz=1 use=5 assigned=6 base=002f)
;     48a1b8:__porta_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     48acb8:__porta_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48bbf8:__porta_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48a9e8:__porta_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48e708:__porta_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     48e438:__porta_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     490b28:_porta_ra7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> porta+0
;     490cb8:_pin_a7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> porta+0
;     490e38:_pin_osc1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> porta+0
;     490f18:_pin_clkin bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> porta+0
;     491458:__pin_a7_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     491108:_porta_ra6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> porta+0
;     491ec8:_pin_a6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> porta+0
;     491998:_pin_osc2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> porta+0
;     492108:_pin_clkout bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> porta+0
;     492548:__pin_a6_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4921f8:_porta_ra5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     492a88:_pin_a5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     493108:_pin_an4 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     4931e8:_pin_ss bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     4932c8:_pin_c2out bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     493708:__pin_a5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4933b8:_porta_ra4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     494108:_pin_a4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     494288:_pin_t0cki bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     494368:_pin_c1out bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> porta+0
;     4947a8:__pin_a4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     494458:_porta_ra3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     4952a8:_pin_a3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     495428:_pin_an3 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     495508:_pin_vref_pos bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     4955e8:_pin_c1in_pos bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porta+0
;     495a28:__pin_a3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4956d8:_porta_ra2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     496558:_pin_a2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     4966d8:_pin_an2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     4967b8:_pin_vref_neg bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     496898:_pin_cvref bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     496978:_pin_c2in_pos bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> porta+0
;     496db8:__pin_a2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     496a68:_porta_ra1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     4977f8:_pin_a1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     497978:_pin_an1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     497a58:_pin_c12in1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> porta+0
;     497e98:__pin_a1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     497b48:_porta_ra0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     498988:_pin_a0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     498b08:_pin_an0 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     498be8:_pin_ulpwu bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     498cc8:_pin_c12in0 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> porta+0
;     499108:__pin_a0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     498db8:_portb byte (type=i dflags=-V--- sz=1 use=2 assigned=2 base=0006)
;     499c18:__portb_shadow byte (type=i dflags=----- auto sz=1 use=2 assigned=3 base=0030)
;     49a1b8:__portb_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     49ad28:__portb_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49bca8:__portb_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49aa58:__portb_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49e708:__portb_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     49e438:__portb_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a0b98:_portb_rb7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     4a0d28:_pin_b7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     4a0ea8:_pin_icspdat bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portb+0
;     4a1328:__pin_b7_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a0f98:_portb_rb6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     4a1d98:_pin_b6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     4a1f18:_pin_icspclk bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portb+0
;     4a2258:__pin_b6_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a1868:_portb_rb5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     4a2cc8:_pin_b5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     4a2e48:_pin_an13 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     4a2f28:_pin_t1g bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portb+0
;     4a32b8:__pin_b5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a2798:_portb_rb4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     4a3d28:_pin_b4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     4a3ea8:_pin_an11 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     4a3f88:_pin_p1d bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portb+0
;     4a4328:__pin_b4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a37f8:_portb_rb3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     4a4d98:_pin_b3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     4a4f18:_pin_an9 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     4a4868:_pin_pgm bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     4a5108:_pin_c12in2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portb+0
;     4a5548:__pin_b3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a51f8:_portb_rb2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portb+0
;     4a5a88:_pin_b2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portb+0
;     4a6108:_pin_an8 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portb+0
;     4a61e8:_pin_p1b bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portb+0
;     4a6628:__pin_b2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a62d8:_portb_rb1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     4a6b68:_pin_b1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     4a7108:_pin_an10 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     4a71e8:_pin_p1c bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     4a72c8:_pin_c12in3 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portb+0
;     4a7708:__pin_b1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a73b8:_portb_rb0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a8108:_pin_b0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a8288:_pin_an12 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a8368:_pin_int bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portb+0
;     4a87a8:__pin_b0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4a8458:_portc byte (type=i dflags=-V--- sz=1 use=1 assigned=15 base=0007)
;     4a92d8:__portc_shadow byte (type=i dflags=----- auto sz=1 use=15 assigned=16 base=0031)
;     4a9898:__portc_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4aa528:__portc_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ab468:__portc_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4aa258:__portc_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4ade48:__portc_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4adb78:__portc_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b0748:_portc_rc7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4b08d8:_pin_c7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4b0a58:_pin_rx bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4b0b38:_pin_dt bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> portc+0
;     4b0f78:__pin_c7_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b0c28:_portc_rc6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4b1ae8:_pin_c6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4b1c68:_pin_tx bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4b1d48:_pin_ck bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> portc+0
;     4b21b8:__pin_c6_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b1e38:_portc_rc5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4b2c28:_pin_c5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4b2da8:_pin_sdo bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     4b31b8:__pin_c5_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b2e98:_portc_rc4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4b3c28:_pin_c4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4b3da8:_pin_sdi bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4b3e88:_pin_sda bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     4b41f8:__pin_c4_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b3f78:_portc_rc3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4b4c68:_pin_c3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4b4de8:_pin_sck bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4b4ec8:_pin_scl bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     4b5258:__pin_c3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b4738:_portc_rc2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4b5cc8:_pin_c2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4b5e48:_pin_p1a bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4b5f28:_pin_ccp1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> portc+0
;     4b62b8:__pin_c2_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b5798:_portc_rc1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b6d28:_pin_c1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b6ea8:_pin_t1osi bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b6f88:_pin_ccp2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     4b7328:__pin_c1_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b67f8:_portc_rc0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b7d98:_pin_c0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b7f18:_pin_t1oso bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b7868:_pin_t1cki bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     4b8458:__pin_c0_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b8108:_porte byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0009)
;     4b8ef8:__porte_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     4b9598:__porte_flush_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4ba1b8:__porte_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4bb108:__porte_low_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4b9e38:__porte_low_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4bdb38:__porte_high_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4bd868:__porte_high_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c0368:_porte_re3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porte+0
;     4c04f8:_pin_e3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> porte+0
;     4c0678:_pin_mclr bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porte+0
;     4c0758:_pin_vpp bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> porte+0
;     4c0b98:__pin_e3_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4c0848:_pclath byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000a)
;     4c1858:_pclath_pclath  (type=i dflags=-V-B- sz=5 use=0 assigned=0 bit=0) ---> pclath+0
;     4c1a48:__pclath byte (type=i dflags=-V--- sz=1 use=1 assigned=3 base=000a)
;     4c1cf8:_intcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000b)
;     4c1fa8:_intcon_gie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> intcon+0
;     4c2108:_intcon_peie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> intcon+0
;     4c2268:_intcon_tmr0ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> intcon+0
;     4c23c8:_intcon_inte bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> intcon+0
;     4c2528:_intcon_rbie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> intcon+0
;     4c2688:_intcon_tmr0if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> intcon+0
;     4c27e8:_intcon_intf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> intcon+0
;     4c2948:_intcon_rbif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> intcon+0
;     4c2aa8:_pir1 byte (type=i dflags=-V--- sz=1 use=1 assigned=0 base=000c)
;     4c2c08:_pir1_adif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pir1+0
;     4c2d68:_pir1_rcif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> pir1+0
;     4c2ec8:_pir1_txif bit (type=B dflags=-V-B- sz=1 use=1 assigned=0 bit=4) ---> pir1+0
;     4c3108:_pir1_sspif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pir1+0
;     4c3268:_pir1_ccp1if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pir1+0
;     4c33c8:_pir1_tmr2if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pir1+0
;     4c3528:_pir1_tmr1if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pir1+0
;     4c3688:_pir2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000d)
;     4c37e8:_pir2_osfif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> pir2+0
;     4c3948:_pir2_c2if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pir2+0
;     4c3aa8:_pir2_c1if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> pir2+0
;     4c3c08:_pir2_eeif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pir2+0
;     4c3d68:_pir2_bclif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pir2+0
;     4c3ec8:_pir2_ulpwuif bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pir2+0
;     4c4108:_pir2_ccp2if bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pir2+0
;     4c4268:_tmr1 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=000e)
;     4c43c8:_tmr1l byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000e)
;     4c4528:_tmr1h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=000f)
;     4c4688:_t1con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0010)
;     4c47e8:_t1con_t1ginv bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> t1con+0
;     4c4948:_t1con_tmr1ge bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> t1con+0
;     4c4a98:_t1con_t1ckps  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> t1con+0
;     4c4c88:_t1con_t1oscen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> t1con+0
;     4c4de8:_t1con_nt1sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> t1con+0
;     4c4f48:_t1con_tmr1cs bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> t1con+0
;     4c5108:_t1con_tmr1on bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> t1con+0
;     4c5268:_tmr2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0011)
;     4c53c8:_t2con byte (type=i dflags=-V--- sz=1 use=0 assigned=4 base=0012)
;     4c5518:_t2con_toutps  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=3) ---> t2con+0
;     4c5708:_t2con_tmr2on bit (type=B dflags=-V-B- sz=1 use=0 assigned=4 bit=2) ---> t2con+0
;     4c5858:_t2con_t2ckps  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=0) ---> t2con+0
;     4c5a48:_sspbuf byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0013)
;     4c5ba8:_sspcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0014)
;     4c5d08:_sspcon_wcol bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspcon+0
;     4c5e68:_sspcon_sspov bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspcon+0
;     4c6108:_sspcon_sspen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspcon+0
;     4c6268:_sspcon_ckp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspcon+0
;     4c63b8:_sspcon_sspm  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> sspcon+0
;     4c65a8:_ccpr1 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=0015)
;     4c6708:_ccpr1l byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0015)
;     4c6868:_ccpr1h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0016)
;     4c69c8:_ccp1con byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0017)
;     4c6b18:_ccp1con_p1m  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=6) ---> ccp1con+0
;     4c6cf8:_ccp1con_dc1b  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> ccp1con+0
;     4c6ed8:_ccp1con_ccp1m  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> ccp1con+0
;     4c7108:_rcsta byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0018)
;     4c7268:_rcsta_spen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> rcsta+0
;     4c73c8:_rcsta_rx9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> rcsta+0
;     4c7528:_rcsta_sren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> rcsta+0
;     4c7688:_rcsta_cren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> rcsta+0
;     4c77e8:_rcsta_adden bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> rcsta+0
;     4c7948:_rcsta_ferr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> rcsta+0
;     4c7aa8:_rcsta_oerr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> rcsta+0
;     4c7c08:_rcsta_rx9d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> rcsta+0
;     4c7d68:_txreg byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0019)
;     4c7ec8:_rcreg byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001a)
;     4c8108:_ccpr2 word (type=i dflags=-V--- sz=2 use=0 assigned=0 base=001b)
;     4c8268:_ccpr2l byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001b)
;     4c83c8:_ccpr2h byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001c)
;     4c8528:_ccp2con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=001d)
;     4c8688:_ccp2con_dc2b1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> ccp2con+0
;     4c87e8:_ccp2con_dc2b0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> ccp2con+0
;     4c8938:_ccp2con_dc2b  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> ccp2con+0
;     4c8b18:_ccp2con_ccp2m  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> ccp2con+0
;     4c8d08:_adresh byte (type=i dflags=-V--- sz=1 use=1 assigned=0 base=001e)
;     4c8e68:_adcon0 byte (type=i dflags=-V--- sz=1 use=1 assigned=4 base=001f)
;     4c9108:_adcon0_adcs  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;     4c92e8:_adcon0_chs  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=2) ---> adcon0+0
;     4c94d8:_adcon0_go bit (type=B dflags=-V-B- sz=1 use=1 assigned=1 bit=1) ---> adcon0+0
;     4c9638:_adcon0_ndone bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> adcon0+0
;     4c9798:_adcon0_adon bit (type=B dflags=-V-B- sz=1 use=0 assigned=2 bit=0) ---> adcon0+0
;     4c98f8:_option_reg byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0081)
;     4c9ad8:_option_reg_nrbpu bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> option_reg+0
;     4c9c58:_option_reg_intedg bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> option_reg+0
;     4c9dc8:_option_reg_t0cs bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> option_reg+0
;     4c9f68:_t0con_t0cs bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> option_reg+0
;     4ca108:_option_reg_t0se bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> option_reg+0
;     4ca2a8:_t0con_t0se bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> option_reg+0
;     4ca368:_option_reg_psa bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> option_reg+0
;     4ca508:_t0con_psa bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> option_reg+0
;     4ca5b8:_option_reg_ps  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=0) ---> option_reg+0
;     4ca7e8:_t0con_t0ps  (type=i dflags=-V-B- alias sz=3 use=0 assigned=0 bit=0) ---> option_reg+0
;     4ca8a8:_trisa byte (type=i dflags=-V--- sz=1 use=0 assigned=6 base=0085)
;     4caa38:_porta_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisa+0
;     4cae28:__porta_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4cab48:__porta_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4cd7f8:__porta_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4cd518:__porta_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4cfc88:_trisa_trisa7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisa+0
;     4cfe28:_pin_a7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisa+0
;     4cdf18:_pin_osc1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisa+0
;     4cff68:_pin_clkin_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisa+0
;     4d0108:_trisa_trisa6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisa+0
;     4d0278:_pin_a6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisa+0
;     4d0448:_pin_osc2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisa+0
;     4d0568:_pin_clkout_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisa+0
;     4d0628:_trisa_trisa5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4d0798:_pin_a5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=2 bit=5) ---> trisa+0
;     4d0968:_pin_an4_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4d0a88:_pin_ss_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4d0ba8:_pin_c2out_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     4d0c68:_trisa_trisa4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4d0dd8:_pin_a4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4d0fa8:_pin_t0cki_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4d03b8:_pin_c1out_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisa+0
;     4d08d8:_trisa_trisa3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4d0f18:_pin_a3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=3) ---> trisa+0
;     4d1108:_pin_an3_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4d1228:_pin_vref_pos_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4d1348:_pin_c1in_pos_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisa+0
;     4d1408:_trisa_trisa2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4d1578:_pin_a2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> trisa+0
;     4d1748:_pin_an2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4d1868:_pin_vref_neg_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4d1988:_pin_cvref_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4d1aa8:_pin_c2in_pos_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisa+0
;     4d1b68:_trisa_trisa1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4d1cd8:_pin_a1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=1) ---> trisa+0
;     4d1ea8:_pin_an1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4d1198:_pin_c12in1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisa+0
;     4d16b8:_trisa_trisa0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4d1e18:_pin_a0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=0) ---> trisa+0
;     4d1f38:_pin_an0_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4d2108:_pin_ulpwu_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4d2228:_pin_c12in0_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisa+0
;     4d22e8:_trisb byte (type=i dflags=-V--- sz=1 use=0 assigned=9 base=0086)
;     4d24e8:_portb_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=3) ---> trisb+0
;     4d28d8:__portb_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d25f8:__portb_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d52b8:__portb_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d4ec8:__portb_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d76d8:_trisb_trisb7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4d7878:_pin_b7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4d7a48:_pin_icspdat_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisb+0
;     4d7b08:_trisb_trisb6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4d7c78:_pin_b6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4d7e48:_pin_icspclk_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisb+0
;     4d7f08:_trisb_trisb5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4d79b8:_pin_b5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> trisb+0
;     4d8108:_pin_an13_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4d8228:_pin_t1g_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisb+0
;     4d82e8:_trisb_trisb4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4d8458:_pin_b4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=4) ---> trisb+0
;     4d8628:_pin_an11_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4d8748:_pin_p1d_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisb+0
;     4d8808:_trisb_trisb3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4d8978:_pin_b3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=3) ---> trisb+0
;     4d8b48:_pin_an9_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4d8c68:_pin_pgm_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4d8d88:_pin_c12in2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisb+0
;     4d8e48:_trisb_trisb2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisb+0
;     4d8198:_pin_b2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> trisb+0
;     4d8ab8:_pin_an8_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisb+0
;     4d86b8:_pin_p1b_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisb+0
;     4d8cf8:_trisb_trisb1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisb+0
;     4d9108:_pin_b1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=1) ---> trisb+0
;     4d92d8:_pin_an10_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisb+0
;     4d93f8:_pin_p1c_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisb+0
;     4d9518:_pin_c12in3_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisb+0
;     4d95d8:_trisb_trisb0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4d9748:_pin_b0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=0) ---> trisb+0
;     4d9918:_pin_an12_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4d9a38:_pin_int_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisb+0
;     4d9af8:_trisc byte (type=i dflags=-V--- sz=1 use=0 assigned=6 base=0087)
;     4d9c88:_portc_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trisc+0
;     4d9488:__portc_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4d9d98:__portc_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4dca08:__portc_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4dc728:__portc_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4dede8:_trisc_trisc7 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4def88:_pin_c7_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4df1f8:_pin_rx_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4df318:_pin_dt_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> trisc+0
;     4df3d8:_trisc_trisc6 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4df548:_pin_c6_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4df718:_pin_tx_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4df838:_pin_ck_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=6) ---> trisc+0
;     4df8f8:_trisc_trisc5 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4dfa68:_pin_c5_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> trisc+0
;     4dfc38:_pin_sdo_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     4dfcf8:_trisc_trisc4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4dfe68:_pin_c4_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=4) ---> trisc+0
;     4df288:_pin_sdi_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4df688:_pin_sda_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     4dfba8:_trisc_trisc3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4d2198:_pin_c3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=3) ---> trisc+0
;     4d6f88:_pin_sck_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4d9888:_pin_scl_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     4dbf28:_trisc_trisc2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4e0108:_pin_c2_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> trisc+0
;     4e02d8:_pin_p1a_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4e03f8:_pin_ccp1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=2) ---> trisc+0
;     4e04b8:_trisc_trisc1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4e0628:_pin_c1_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=1) ---> trisc+0
;     4e07f8:_pin_t1osi_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4e0918:_pin_ccp2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     4e09d8:_trisc_trisc0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4e0b48:_pin_c0_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=0) ---> trisc+0
;     4e0d18:_pin_t1oso_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4e0e38:_pin_t1cki_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     4e0ef8:_trise byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0089)
;     4e0368:_porte_direction byte (type=i dflags=-V--- sz=1 use=0 assigned=0) ---> trise+0
;     4e11b8:__porte_low_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e0768:__porte_low_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e3aa8:__porte_high_direction_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e37c8:__porte_high_direction_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     4e5de8:_trise_trise3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trise+0
;     4e5f88:_pin_e3_direction bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> trise+0
;     4e61f8:_pin_mclr_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trise+0
;     4e6318:_pin_vpp_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trise+0
;     4e63d8:_pie1 byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=008c)
;     4e6538:_pie1_adie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pie1+0
;     4e6698:_pie1_rcie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> pie1+0
;     4e67f8:_pie1_txie bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=4) ---> pie1+0
;     4e6958:_pie1_sspie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pie1+0
;     4e6ab8:_pie1_ccp1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pie1+0
;     4e6c18:_pie1_tmr2ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pie1+0
;     4e6d78:_pie1_tmr1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pie1+0
;     4e6ed8:_pie2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008d)
;     4e6288:_pie2_osfie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> pie2+0
;     4e7108:_pie2_c2ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> pie2+0
;     4e7268:_pie2_c1ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> pie2+0
;     4e73c8:_pie2_eeie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pie2+0
;     4e7528:_pie2_bclie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pie2+0
;     4e7688:_pie2_ulpwuie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pie2+0
;     4e77e8:_pie2_ccp2ie bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pie2+0
;     4e7948:_pcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008e)
;     4e7aa8:_pcon_ulpwu bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> pcon+0
;     4e7c08:_pcon_sboren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pcon+0
;     4e7d68:_pcon_npor bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pcon+0
;     4e7ec8:_pcon_nbor bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pcon+0
;     4e8108:_osccon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=008f)
;     4e8258:_osccon_ircf  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=4) ---> osccon+0
;     4e8448:_osccon_osts bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> osccon+0
;     4e85a8:_osccon_hts bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> osccon+0
;     4e8708:_osccon_lts bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> osccon+0
;     4e8868:_osccon_scs bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> osccon+0
;     4e89c8:_osctune byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0090)
;     4e8b18:_osctune_tun  (type=i dflags=-V-B- sz=5 use=0 assigned=0 bit=0) ---> osctune+0
;     4e8d08:_sspcon2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0091)
;     4e8e68:_sspcon2_gcen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspcon2+0
;     4e9108:_sspcon2_ackstat bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspcon2+0
;     4e9268:_sspcon2_ackdt bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspcon2+0
;     4e93c8:_sspcon2_acken bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspcon2+0
;     4e9528:_sspcon2_rcen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> sspcon2+0
;     4e9688:_sspcon2_pen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspcon2+0
;     4e97e8:_sspcon2_rsen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> sspcon2+0
;     4e9948:_sspcon2_sen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> sspcon2+0
;     4e9aa8:_pr2 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0092)
;     4e9c08:_sspadd byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0093)
;     4e9d68:_sspstat byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0094)
;     4e9ec8:_sspstat_smp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> sspstat+0
;     4ea108:_sspstat_cke bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> sspstat+0
;     4ea268:_sspstat_d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspstat+0
;     4ea3c8:_sspstat_na bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> sspstat+0
;     4ea528:_sspstat_p bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> sspstat+0
;     4ea688:_sspstat_s bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> sspstat+0
;     4ea7e8:_sspstat_r bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspstat+0
;     4ea948:_sspstat_nw bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> sspstat+0
;     4eaaa8:_sspstat_ua bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> sspstat+0
;     4eac08:_sspstat_bf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> sspstat+0
;     4ead68:_wpub byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0095)
;     4eaec8:_iocb byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0096)
;     4eb108:_vrcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0097)
;     4eb268:_vrcon_vren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> vrcon+0
;     4eb3c8:_vrcon_vroe bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> vrcon+0
;     4eb528:_vrcon_vrr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> vrcon+0
;     4eb688:_vrcon_vrss bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> vrcon+0
;     4eb7d8:_vrcon_vr  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=0) ---> vrcon+0
;     4eb9c8:_txsta byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=0098)
;     4ebb28:_txsta_csrc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> txsta+0
;     4ebc88:_txsta_tx9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> txsta+0
;     4ebde8:_txsta_txen bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> txsta+0
;     4ebf48:_txsta_sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> txsta+0
;     4ec108:_txsta_brgh bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> txsta+0
;     4ec268:_txsta_trmt bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> txsta+0
;     4ec3c8:_txsta_tx9d bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> txsta+0
;     4ec528:_spbrg byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0099)
;     4ec688:_spbrgh byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=009a)
;     4ec7e8:_pwm1con byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=009b)
;     4ec948:_pwm1con_prsen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> pwm1con+0
;     4eca98:_pwm1con_pdc  (type=i dflags=-V-B- sz=7 use=0 assigned=0 bit=0) ---> pwm1con+0
;     4ecc88:_eccpas byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=009c)
;     4ecde8:_eccpas_eccpase bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> eccpas+0
;     4ecf38:_eccpas_eccpas  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=4) ---> eccpas+0
;     4ed108:_eccpas_pssac  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=2) ---> eccpas+0
;     4ed2e8:_eccpas_pssbd  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=0) ---> eccpas+0
;     4ed4d8:_pstrcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=009d)
;     4ed638:_pstrcon_strsync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> pstrcon+0
;     4ed798:_pstrcon_strd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> pstrcon+0
;     4ed8f8:_pstrcon_strc bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> pstrcon+0
;     4eda58:_pstrcon_strb bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> pstrcon+0
;     4edbb8:_pstrcon_stra bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> pstrcon+0
;     4edd18:_adresl byte (type=i dflags=-V--- sz=1 use=2 assigned=0 base=009e)
;     4ede78:_adcon1 byte (type=i dflags=-V--- sz=1 use=0 assigned=2 base=009f)
;     4ee108:_adcon1_adfm bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=7) ---> adcon1+0
;     4ee268:_adcon1_vcfg1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> adcon1+0
;     4ee3c8:_adcon1_vcfg0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> adcon1+0
;     4ee518:_adcon1_vcfg  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=4) ---> adcon1+0
;     4ee708:_wdtcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0105)
;     4ee858:_wdtcon_wdtps  (type=i dflags=-V-B- sz=4 use=0 assigned=0 bit=1) ---> wdtcon+0
;     4eea48:_wdtcon_swdten bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> wdtcon+0
;     4eeba8:_cm1con0 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0107)
;     4eed08:_cm1con0_c1on bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> cm1con0+0
;     4eee68:_cm1con0_c1out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> cm1con0+0
;     4ef108:_cm1con0_c1oe bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> cm1con0+0
;     4ef268:_cm1con0_c1pol bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> cm1con0+0
;     4ef3c8:_cm1con0_c1r bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> cm1con0+0
;     4ef518:_cm1con0_c1ch  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=0) ---> cm1con0+0
;     4ef708:_cm2con0 byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0108)
;     4ef868:_cm2con0_c2on bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> cm2con0+0
;     4ef9c8:_cm2con0_c2out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> cm2con0+0
;     4efb28:_cm2con0_c2oe bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> cm2con0+0
;     4efc88:_cm2con0_c2pol bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> cm2con0+0
;     4efde8:_cm2con0_c2r bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> cm2con0+0
;     4eff38:_cm2con0_c2ch  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=0) ---> cm2con0+0
;     4f0108:_cm2con1 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0109)
;     4f0268:_cm2con1_mc1out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> cm2con1+0
;     4f03c8:_cm2con1_mc2out bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> cm2con1+0
;     4f0528:_cm2con1_c1rsel bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> cm2con1+0
;     4f0688:_cm2con1_c2rsel bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> cm2con1+0
;     4f07e8:_cm2con1_t1gss bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> cm2con1+0
;     4f0948:_cm2con1_c2sync bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> cm2con1+0
;     4f0aa8:_eedata byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010c)
;     4f0c08:_eeadr byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010d)
;     4f0d68:_eedath byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010e)
;     4f0eb8:_eedath_eedath  (type=i dflags=-V-B- sz=6 use=0 assigned=0 bit=0) ---> eedath+0
;     4f1108:_eeadrh byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=010f)
;     4f1258:_eeadrh_eeadrh  (type=i dflags=-V-B- sz=5 use=0 assigned=0 bit=0) ---> eeadrh+0
;     4f1448:_srcon byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=0185)
;     4f15a8:_srcon_sr1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> srcon+0
;     4f1708:_srcon_sr0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> srcon+0
;     4f1868:_srcon_c1sen bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=5) ---> srcon+0
;     4f19c8:_srcon_c2ren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> srcon+0
;     4f1b28:_srcon_pulss bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> srcon+0
;     4f1c88:_srcon_pulsr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> srcon+0
;     4f1de8:_srcon_fvren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> srcon+0
;     4f1f48:_baudctl byte (type=i dflags=-V--- sz=1 use=0 assigned=1 base=0187)
;     4f2108:_baudctl_abdovf bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> baudctl+0
;     4f2268:_baudctl_rcidl bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=6) ---> baudctl+0
;     4f23c8:_baudctl_sckp bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=4) ---> baudctl+0
;     4f2528:_baudctl_brg16 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=3) ---> baudctl+0
;     4f2688:_baudctl_wue bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> baudctl+0
;     4f27e8:_baudctl_abden bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> baudctl+0
;     4f2948:_ansel byte (type=i dflags=-V--- sz=1 use=0 assigned=6 base=0188)
;     4f2aa8:_jansel_ans4 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=4) ---> ansel+0
;     4f2c08:_jansel_ans3 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=3) ---> ansel+0
;     4f2d68:_jansel_ans2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> ansel+0
;     4f2ec8:_jansel_ans1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=1) ---> ansel+0
;     4f3108:_jansel_ans0 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=0) ---> ansel+0
;     4f3268:_anselh byte (type=i dflags=-V--- sz=1 use=0 assigned=7 base=0189)
;     4f33c8:_jansel_ans13 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=5) ---> anselh+0
;     4f3528:_jansel_ans12 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=4) ---> anselh+0
;     4f3688:_jansel_ans11 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=3) ---> anselh+0
;     4f37e8:_jansel_ans10 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=2) ---> anselh+0
;     4f3948:_jansel_ans9 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=1) ---> anselh+0
;     4f3aa8:_jansel_ans8 bit (type=B dflags=-V-B- sz=1 use=0 assigned=1 bit=0) ---> anselh+0
;     4f3c08:_eecon1 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=018c)
;     4f3d68:_eecon1_eepgd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=7) ---> eecon1+0
;     4f3ec8:_eecon1_wrerr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=3) ---> eecon1+0
;     4f4108:_eecon1_wren bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=2) ---> eecon1+0
;     4f4268:_eecon1_wr bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=1) ---> eecon1+0
;     4f43c8:_eecon1_rd bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=0) ---> eecon1+0
;     4f4528:_eecon2 byte (type=i dflags=-V--- sz=1 use=0 assigned=0 base=018d)
;     4f46b8:_adc_group  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 44480
;     4f48a8:_adc_ntotal_channel byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 11
;     4f4798:_analog_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4f5b18:_adc_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4f6b28:_comparator_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4f7b38:_enable_digital_io_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4fb2f8:_target_clock  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 20000000
;     4fc458:_hewo  (type=a dflags=C---- lookup sz=13 use=2 assigned=0)
;      = 72,101,108,108,111,32,87,111,114,108,100,33,10
;     4fbd98:_version  (type=a dflags=C---- lookup sz=7 use=1 assigned=0)
;      = 86,48,46,48,46,54,10
;     4fbca8:_done  (type=a dflags=C---- lookup sz=6 use=1 assigned=0)
;      = 68,111,110,101,33,10
;     4fd978:_test1  (type=a dflags=C---- lookup sz=20 use=1 assigned=0)
;      = 65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84
;     4fe158:_test2  (type=a dflags=C---- lookup sz=20 use=1 assigned=0)
;      = 85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110
;     4fea68:_test3  (type=a dflags=C---- lookup sz=20 use=1 assigned=0)
;      = 111,112,113,114,115,116,117,118,119,120,121,122,48,49,50,51,52,53,54,55
;     4fd648:_test4  (type=a dflags=C---- lookup sz=17 use=1 assigned=0)
;      = 56,57,33,64,35,36,37,94,38,42,40,41,128,126,60,62,47
;     4fd288:_test5  (type=a dflags=C---- lookup sz=13 use=1 assigned=0)
;      = 124,91,93,123,125,42,45,43,44,46,58,59,63
;     4fd1c8:_adcte  (type=a dflags=C---- lookup sz=12 use=1 assigned=0)
;      = 76,105,99,104,116,115,101,110,115,111,114,58
;     4fb828:_adc_channel_a  (type=i dflags=C---U sz=4 use=3 assigned=0)
;      = 0
;     4fb8e8:_adc_nvref byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 0
;     4fb9d8:_adc_rsource word (type=i dflags=C---- sz=2 use=0 assigned=0)
;      = 5000
;     4fb768:_adc_high_resolution bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     4fbac8:_delay_1us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4fbbb8:_delay_2us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4fbe88:_delay_3us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4fbf78:_delay_4us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4fc128:_delay_5us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4fc218:_delay_6us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4fc308:_delay_7us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4fd108:_delay_8us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4fd378:_delay_9us_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     4fd468:_instruction_time  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 20
;     4fd738:_delay_10us_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     506868:_delay_1ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     50b108:_delay_100ms_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     50cf28:_delay_1s_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     4fd558:__adc_vref_vcfg_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     50f778:__adc_vref_adref_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     511bd8:__adc_setup_pins_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     50f888:_set_analog_pin_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     524a88:_set_digital_pin_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     534b58:__adc_vref  (type=F dflags=----- alias sz=0 use=0 assigned=0) ---> ___adc_vref_vcfg1
;     534cb8:_tad_value byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0032)
;     5114b8:_adc_min_tad byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 16
;     537ab8:_adc_max_tad byte (type=i dflags=C---- sz=1 use=1 assigned=0)
;      = 60
;     538608:__adc_eval_tad_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     537438:__adc_init_clock_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     530bb8:_adc_temp byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 25
;     5407b8:__adcon0_shadow byte (type=i dflags=-V--- auto sticky sz=1 use=0 assigned=1 base=002c)
;     5418a8:_adc_conversion_delay byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0033)
;     541dc8:__adc_read_low_res_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     541b28:_adc_read_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     546b98:_adc_read_bytes_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5467f8:_adc_read_low_res_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5419d8:__adc_init_justify_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     54b268:__adc_init_acquisition_delay_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     54c658:__adc_setup_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     54f2b8:_adc_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     55ac18:_measure_a word (type=i dflags=----- auto sz=2 use=8 assigned=2 base=0034)
;     55b698:__pr2_shadow_plus1 word (type=i dflags=-V--- auto sticky sz=2 use=1 assigned=4 base=002d)
;     55bdb8:_pwm_max_resolution_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     557718:_pwm_set_frequency_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     55bad8:__ccpr1l_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0036)
;     565778:__ccp1con_shadow byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0037)
;     566408:__ccp1con_shadow_dc1b  (type=i dflags=---B- sz=2 use=0 assigned=0 bit=4) ---> _ccp1con_shadow+0
;     566618:__ccp1con_shadow_ccp1m  (type=i dflags=---B- sz=4 use=0 assigned=0 bit=0) ---> _ccp1con_shadow+0
;     5669e8:_pwm1_on_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     567c08:_pwm1_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     568a18:_pwm1_set_dutycycle_highres_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     56b3b8:_pwm1_set_dutycycle_lowres_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     56cc88:_pwm1_set_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     56e1b8:_pwm1_set_percent_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     568738:__ccpr2l_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     572b08:__ccp2con_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     572ec8:__ccp2con_shadow_dc2b  (type=i dflags=---B- sz=2 use=0 assigned=0 bit=4) ---> _ccp2con_shadow
;     5722b8:__ccp2con_shadow_ccp2m  (type=i dflags=---B- sz=4 use=0 assigned=0 bit=0) ---> _ccp2con_shadow
;     5733e8:_pwm2_on_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5747c8:_pwm2_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     575558:_pwm2_set_dutycycle_highres_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     577278:_pwm2_set_dutycycle_lowres_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5799c8:_pwm2_set_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     57ae58:_pwm2_set_percent_dutycycle_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     57f558:_usart_hw_serial bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;      = 1
;     57f718:_serial_hw_baudrate  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 19200
;     57fc28:__calculate_and_set_baudrate_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     580788:_serial_hw_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     584108:_serial_hw_disable_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     585568:_serial_hw_enable_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     585ef8:_serial_hw_write_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5875c8:_serial_hw_write_word_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     589908:__serial_hw_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     58bd88:_serial_hw_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     58df28:__serial_hw_data_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     585c28:__serial_hw_data_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     590d38:_serial_hw_data_available bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> pir1+0
;     590e38:_serial_hw_data_ready bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> pir1+0
;     5912b8:__serial_hw_data_raw_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     590f48:__serial_hw_data_raw_get_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5927c8:_serial_hw_printf_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5949a8:_serial_hw_byte_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     59ae98:_x_90  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     59b4a8:_pwmvalue byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=0038)
;     59bb58:__btemp_24  (type=i dflags=---B- sz=5 use=0 assigned=0 bit=0) ---> _bitbucket+0
;     59bc28:__btemp63  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _bitbucket+0
;     59c718:__temp_47  (type=i dflags=----- auto sz=2 use=8 assigned=8 base=0039)
;     59d4f8:_glcd_cs1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> portc+0
;     59d648:_glcd_cs1_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=1) ---> trisc+0
;     59d758:_glcd_cs2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> portc+0
;     59d8a8:_glcd_cs2_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=0) ---> trisc+0
;     59d9b8:_glcd_rst bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> portc+0
;     59db08:_glcd_rst_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=4) ---> trisc+0
;     59dc18:_glcd_rw bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> portc+0
;     59dd68:_glcd_rw_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=3) ---> trisc+0
;     59de78:_glcd_e bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> porta+0
;     59d588:_glcd_e_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisa+0
;     59da48:_glcd_di bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> portc+0
;     59e108:_glcd_di_direction bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=5) ---> trisc+0
;     59e218:_glcd_dataprt byte (type=i dflags=-V--- alias sz=1 use=0 assigned=0) ---> portb+0
;     59e368:_glcd_dataprt_dir byte (type=i dflags=-V--- alias sz=1 use=0 assigned=0) ---> portb_direction+0
;     59e668:_ks0108_left  (type=i dflags=C---U sz=4 use=22 assigned=0)
;      = 0
;     59e7a8:_ks0108_right  (type=i dflags=C---U sz=4 use=22 assigned=0)
;      = 1
;     59e8e8:_ks0108_cmd_on  (type=i dflags=C---U sz=4 use=2 assigned=0)
;      = 63
;     59ea28:_ks0108_cmd_off  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 62
;     59eb68:_ks0108_cmd_page  (type=i dflags=C---U sz=4 use=15 assigned=0)
;      = 184
;     59ecc8:_ks0108_cmd_column  (type=i dflags=C---U sz=4 use=17 assigned=0)
;      = 64
;     59ee28:_ks0108_cmd_top_ram  (type=i dflags=C---U sz=4 use=0 assigned=0)
;      = 192
;     59f1b8:__ks0108_write_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     59e2a8:__ks0108_read_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     59e598:_lcd_on_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5adbe8:_lcd_off_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5aeaf8:__ks0108_page_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5afd68:__ks0108_column_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5ae718:__ks0108_inst_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5b1ae8:__ks0108_data_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5b2e38:_lcd_write_pixel_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5bb708:_ks0108_write_byte_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5b2ba8:_ks0108_read_byte_1  (type=F dflags=----- sz=3 use=0 assigned=0 base=0000)
;     5b2a98:_lcd_fill_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     5b2948:_lcd_init_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5f3b68:_myfonttable  (type=a dflags=C---- lookup sz=515 use=5 assigned=0)
;      = 0,0,0,0,0,0,0,47,0,0,0,7,0,7,0,20,127,20,127,20,36,42,127,42,18,196,200,16,38,70,54,73,85,34,80,0,5,3,0,0,0,28,34,65,0,0,65,34,28,0,20,8,62,8,20,8,8,62,8,8,0,0,80,48,0,16,16,16,16,16,0,96,96,0,0,32,16,8,4,2,62,81,73,69,62,0,66,127,64,0,66,97,81,73,70,33,65,69,75,49,24,20,18,127,16,39,69,69,69,57,60,74,73,73,48,1,113,9,5,3,54,73,73,73,54,6,73,73,41,30,0,54,54,0,0,0,86,54,0,0,8,20,34,65,0,20,20,20,20,20,0,65,34,20,8,2,1,81,9,6,50,73,89,81,62,126,17,17,17,126,127,73,73,73,54,62,65,65,65,34,127,65,65,34,28,127,73,73,73,65,127,9,9,9,1,62,65,73,73,122,127,8,8,8,127,0,65,127,65,0,32,64,65,63,1,127,8,20,34,65,127,64,64,64,64,127,2,12,2,127,127,4,8,16,127,62,65,65,65,62,127,9,9,9,6,62,65,81,33,94,127,9,25,41,70,70,73,73,73,49,1,1,127,1,1,63,64,64,64,63,31,32,64,32,31,63,64,56,64,63,99,20,8,20,99,7,8,112,8,7,97,81,73,69,67,0,127,65,65,0,85,42,85,42,85,0,65,65,127,0,4,2,1,2,4,64,64,64,64,64,0,1,2,4,0,32,84,84,84,120,127,72,68,68,56,56,68,68,68,32,56,68,68,72,127,56,84,84,84,24,8,126,9,1,2,12,82,82,82,62,127,8,4,4,120,0,68,125,64,0,32,64,68,61,0,127,16,40,68,0,0,65,127,64,0,124,4,24,4,120,124,8,4,4,120,56,68,68,68,56,124,20,20,20,8,8,20,20,24,124,124,8,4,4,8,72,84,84,84,32,4,63,68,64,32,60,64,64,32,124,28,32,64,32,28,60,64,48,64,60,68,40,16,40,68,12,80,80,80,60,68,100,84,76,68,0,8,54,65,0,0,0,127,0,0,0,65,54,8,0,8,4,8,16,8,0,127,65,127,0,20,62,85,65,34,0,0,0,0,0,0,80,48,0,0,85,42,85,42,85,85,42,85,42,85,32,0,32,0,32,4,4,127,4,4
;     5d5618:_lcd_write_char_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5d5218:_buff byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=003b)
;     5d5318:_buffx byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=003c)
;     5d5418:_buffy byte (type=i dflags=----- auto sz=1 use=4 assigned=4 base=003d)
;     5d9128:_lcd_write_pixel_buff_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5dcf28:_lcd_line_1  (type=F dflags=----- sz=5 use=0 assigned=0 base=0000)
;     5dce28:_lcd_rect_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     59fe18:_lcd_filled_rect_1  (type=F dflags=----- sz=5 use=0 assigned=0 base=0000)
;     5d8d28:_glcd_char_x_pos  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     5d8f28:_glcd_char_y_pos  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     5e1a08:__lcd_put_1  (type=F dflags=----- sz=1 use=0 assigned=0 base=0000)
;     59dca8:_lcd_clearscreen_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5e3f08:_lcd_setcursor_1  (type=F dflags=----- sz=2 use=0 assigned=0 base=0000)
;     5e3d08:_lcd_home_1  (type=F dflags=----- sz=0 use=0 assigned=0 base=0000)
;     5e4c08:_lcd_num_1  (type=F dflags=----- sz=4 use=0 assigned=0 base=0000)
;     5ec308:_lcd_print_1  (type=F dflags=----- sz=6 use=0 assigned=0 base=0000)
;     5ef108:_lcd_prg_ver_1  (type=F dflags=----- sz=8 use=0 assigned=0 base=0000)
;     5f1908:_lcd_prg_hor_1  (type=F dflags=----- sz=8 use=0 assigned=0 base=0000)
;     6721a8:_timer byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=003e)
;     679468:__btemp104  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _bitbucket+0
;     679f78:_oldadc word (type=i dflags=----- auto sz=2 use=4 assigned=2 base=003f)
;     67a108:_adclowres  (type=i dflags=C---- sz=1 use=0 assigned=1)
;      = 0
;     67a1a8:_e1_2 bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=5) ---> _bitbucket+0
;     67a248:_e2_2 bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=6) ---> _bitbucket+0
;     67a6d8:_graphleft byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0041)
;     67aba8:_graphright byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0042)
;     67b108:_graphtop byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0043)
;     67b5d8:_graphbottom byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0044)
;     67be18:_graphheight  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     67c308:_graphx  (type=i dflags=C---- sz=1 use=0 assigned=0)
;      = 0
;     67c7d8:_graphy  (type=i dflags=C---- sz=4 use=0 assigned=0)
;      = 0
;     5e3c08:__bitbucket  (type=i dflags=----- auto sz=2 use=7 assigned=13 base=0045)
;     4bcf48:__pic_temp  (type=i dflags=----- sz=4 use=36 assigned=45) ---> _pic_state+0
;     48b278:__pic_loop  (type=i dflags=----- sz=1 use=3 assigned=8 base=0028)
;     680368:__pic_multiplier  (type=i dflags=----- sz=2 use=2 assigned=30) ---> _pic_state+0
;     67c6d8:__pic_multiplicand  (type=i dflags=----- sz=2 use=2 assigned=28) ---> _pic_state+2
;     59adb8:__pic_mresult  (type=i dflags=----- sz=2 use=27 assigned=5) ---> _pic_state+4
;     680498:__pic_divisor  (type=i dflags=----- sz=2 use=4 assigned=14) ---> _pic_state+4
;     5da328:__pic_dividend  (type=i dflags=----- sz=2 use=0 assigned=14) ---> _pic_state+0
;     560f18:__pic_quotient  (type=i dflags=----- sz=2 use=11 assigned=3) ---> _pic_state+6
;     6686d8:__pic_remainder  (type=i dflags=----- sz=2 use=5 assigned=5) ---> _pic_state+2
;     5f2c08:__pic_divaccum  (type=i dflags=----- sz=4 use=4 assigned=4) ---> _pic_state+0
;     4dd9d8:__pic_pointer  (type=i dflags=----- sz=2 use=5 assigned=8 base=002a)
;     965708:__pic_sign  (type=i dflags=----- sz=1 use=0 assigned=0 base=0029)
;     967778:__pic_state  (type=i dflags=----- sz=8 use=91 assigned=148 base=0020)
;     --- labels ---
;     _isr_cleanup (pc(0000) usage=0)
;     _isr_preamble (pc(0000) usage=0)
;     _main (pc(02cc) usage=7)
;     _porta_flush (pc(0000) usage=0)
;     _porta_put (pc(0000) usage=0)
;     _porta_low_put (pc(0000) usage=0)
;     _porta_low_get (pc(0000) usage=0)
;     _porta_high_put (pc(0000) usage=0)
;     _porta_high_get (pc(0000) usage=0)
;     _pin_a7_put (pc(0000) usage=0)
;     _pin_a6_put (pc(0000) usage=0)
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
;     _porte_flush (pc(0000) usage=0)
;     _porte_put (pc(0000) usage=0)
;     _porte_low_put (pc(0000) usage=0)
;     _porte_low_get (pc(0000) usage=0)
;     _porte_high_put (pc(0000) usage=0)
;     _porte_high_get (pc(0000) usage=0)
;     _pin_e3_put (pc(0000) usage=0)
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
;     _porte_low_direction_put (pc(0000) usage=0)
;     _porte_low_direction_get (pc(0000) usage=0)
;     _porte_high_direction_put (pc(0000) usage=0)
;     _porte_high_direction_get (pc(0000) usage=0)
;     analog_off (pc(0000) usage=0)
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
;     delay_10us (pc(02e0) usage=7)
;     delay_1ms (pc(030d) usage=14)
;     delay_100ms (pc(0000) usage=0)
;     delay_1s (pc(0000) usage=0)
;     _adc_vref_vcfg (pc(0000) usage=0)
;     _adc_vref_adref (pc(0000) usage=0)
;     _adc_setup_pins (pc(032b) usage=7)
;     set_analog_pin (pc(032c) usage=7)
;     set_digital_pin (pc(0000) usage=0)
;     _adc_eval_tad (pc(0399) usage=21)
;     _adc_init_clock (pc(0000) usage=0)
;     _adc_read_low_res (pc(03d0) usage=14)
;     adc_read (pc(0403) usage=7)
;     adc_read_bytes (pc(0000) usage=0)
;     adc_read_low_res (pc(0414) usage=7)
;     _adc_init_justify (pc(0000) usage=0)
;     _adc_init_acquisition_delay (pc(0000) usage=0)
;     _adc_setup (pc(0000) usage=0)
;     adc_init (pc(0000) usage=0)
;     pwm_max_resolution (pc(0496) usage=7)
;     pwm_set_frequency (pc(0000) usage=0)
;     pwm1_on (pc(04bf) usage=14)
;     pwm1_off (pc(0000) usage=0)
;     pwm1_set_dutycycle_highres (pc(04ca) usage=7)
;     pwm1_set_dutycycle_lowres (pc(0000) usage=0)
;     pwm1_set_dutycycle (pc(04ee) usage=7)
;     pwm1_set_percent_dutycycle (pc(0000) usage=0)
;     pwm2_on (pc(0000) usage=0)
;     pwm2_off (pc(0000) usage=0)
;     pwm2_set_dutycycle_highres (pc(0000) usage=0)
;     pwm2_set_dutycycle_lowres (pc(0000) usage=0)
;     pwm2_set_dutycycle (pc(0000) usage=0)
;     pwm2_set_percent_dutycycle (pc(0000) usage=0)
;     _calculate_and_set_baudrate (pc(0505) usage=7)
;     serial_hw_init (pc(050f) usage=7)
;     serial_hw_disable (pc(0000) usage=0)
;     serial_hw_enable (pc(0000) usage=0)
;     serial_hw_write (pc(0519) usage=70)
;     serial_hw_write_word (pc(0000) usage=0)
;     _serial_hw_read (pc(0000) usage=0)
;     serial_hw_read (pc(0000) usage=0)
;     _serial_hw_data_put (pc(0000) usage=0)
;     _serial_hw_data_get (pc(0000) usage=0)
;     _serial_hw_data_raw_put (pc(0000) usage=0)
;     _serial_hw_data_raw_get (pc(0000) usage=0)
;     serial_hw_printf (pc(0525) usage=21)
;     serial_hw_byte (pc(053e) usage=56)
;     _ks0108_write (pc(05e7) usage=343)
;     _ks0108_read (pc(0625) usage=28)
;     lcd_on (pc(0662) usage=7)
;     lcd_off (pc(0000) usage=0)
;     _ks0108_page (pc(0000) usage=0)
;     _ks0108_column (pc(0000) usage=0)
;     _ks0108_inst (pc(066f) usage=77)
;     _ks0108_data (pc(0675) usage=98)
;     lcd_write_pixel (pc(0000) usage=0)
;     ks0108_write_byte (pc(067b) usage=7)
;     ks0108_read_byte (pc(0000) usage=0)
;     lcd_fill (pc(06ac) usage=14)
;     lcd_init (pc(0000) usage=0)
;     lcd_write_char (pc(0000) usage=0)
;     lcd_write_pixel_buff (pc(0000) usage=0)
;     lcd_line (pc(070c) usage=42)
;     lcd_rect (pc(0000) usage=0)
;     lcd_filled_rect (pc(07e0) usage=28)
;     _lcd_put (pc(0000) usage=0)
;     lcd_clearscreen (pc(0924) usage=7)
;     lcd_setcursor (pc(0000) usage=0)
;     lcd_home (pc(0000) usage=0)
;     lcd_num (pc(0927) usage=7)
;     lcd_print (pc(0bf5) usage=49)
;     lcd_prg_ver (pc(0000) usage=0)
;     lcd_prg_hor (pc(0000) usage=0)
;     _pic_multiply (pc(0296) usage=84)
;     _pic_divide (pc(02a9) usage=42)
;     _pic_indirect (pc(02c9) usage=12)
;     _data_hewo (pc(025f) usage=8)
;     _data_version (pc(0288) usage=4)
;     _data_test1 (pc(0223) usage=4)
;     _data_test2 (pc(0238) usage=4)
;     _data_test3 (pc(020e) usage=4)
;     _data_test4 (pc(024d) usage=4)
;     _data_test5 (pc(026d) usage=4)
;     _data_adcte (pc(027b) usage=4)
;     _data_done (pc(0290) usage=4)
;     _pic_reset (pc(0000) usage=0)
;     _pic_isr (pc(0000) usage=0)
;     _pic_lookup (pc(0000) usage=0)
;     _lookup_myfonttable (pc(0004) usage=12)
;     _lookup_test3 (pc(020d) usage=0)
;     _lookup_test1 (pc(0222) usage=0)
;     _lookup_test2 (pc(0237) usage=0)
;     _lookup_test4 (pc(024c) usage=0)
;     _lookup_hewo (pc(025e) usage=0)
;     _lookup_test5 (pc(026c) usage=0)
;     _lookup_adcte (pc(027a) usage=0)
;     _lookup_version (pc(0287) usage=0)
;     _lookup_done (pc(028f) usage=0)
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
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;         {block enter}
;           --- records ---
;           --- variables ---
;           555518:_vcfg_shadow_3 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0047)
;           --- labels ---
;         {block exit}
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         556448:_jallib_adfm_2 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> adcon1+0
;         --- labels ---
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         556d18:_jallib_adcs_lsb_2  (type=i dflags=-V-B- alias sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;         556da8:_jallib_adcs_msb_2  (type=B dflags=CV-B- sz=1 use=0 assigned=0 bit=0)
;          = 0
;         556e38:_adcs_2  (type=i dflags=-V-B- sz=3 use=0 assigned=0 bit=7) ---> _bitbucket+0
;         556ec8:__btemp_10  (type=i dflags=---B- sz=6 use=0 assigned=0 bit=10) ---> _bitbucket+0
;         556f58:__btemp32_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=10) ---> _bitbucket+0
;         557108:__btemp33_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=11) ---> _bitbucket+0
;         557198:__btemp34_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=12) ---> _bitbucket+0
;         557228:__btemp35_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=13) ---> _bitbucket+0
;         5572b8:__btemp36_2  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=14) ---> _bitbucket+0
;         557348:__btemp37_2  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=15) ---> _bitbucket+0
;         5573d8:_adcs_lsb_2  (type=i dflags=-V-B- sz=2 use=0 assigned=0 bit=7) ---> _bitbucket+0
;         557468:_adcs_msb_2 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 bit=9) ---> _bitbucket+0
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
;       --- labels ---
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         5e4908:_x_135 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0047)
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
;         5e4a08:_x_136 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=4) ---> _portc_shadow+0
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
;         5e4b08:_x_137 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=5) ---> _porta_shadow+0
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
;         5eed08:_x_138 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=1) ---> _portc_shadow+0
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
;         5eee08:_x_139 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=0) ---> _portc_shadow+0
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
;         5eef08:_side_46 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0047)
;         66c968:_page_4 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0048)
;         66c9f8:__temp_119  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0049)
;         --- labels ---
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         66cf28:_side_47 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0047)
;         66d108:_page_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0048)
;         66d198:__temp_120  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0049)
;         --- labels ---
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         66d6c8:_side_48 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0047)
;         66d758:_column_6 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0048)
;         66d7e8:__temp_121  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0049)
;         --- labels ---
;       {block exit}
;       {block enter}
;         --- records ---
;         --- variables ---
;         66dd18:_side_49 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0047)
;         66dda8:_column_7 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0048)
;         66de38:__temp_122  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0049)
;         --- labels ---
;       {block exit}
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         6736a8:_x0_8 byte (type=i dflags=----- auto sz=1 use=7 assigned=1 base=0047)
;         673738:_y_16 byte (type=i dflags=----- auto sz=1 use=13 assigned=1 base=0048)
;         6737c8:_x1_8 byte (type=i dflags=----- auto sz=1 use=7 assigned=1 base=0049)
;         673858:_value_4 word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=004a)
;         6738e8:_max_4 word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=004c)
;         673978:_startleft_2 bit (type=B dflags=---B- sz=1 use=1 assigned=1 bit=7) ---> _bitbucket+0
;         673a08:_maxx_1 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=004e)
;         673a98:_thevalue_2 word (type=i dflags=----- auto sz=2 use=12 assigned=8 base=004f)
;         673b28:__temp_123  (type=i dflags=----- auto sz=3 use=11 assigned=13 base=0051)
;         673bb8:__rparam16_1 byte (type=i dflags=----- auto sz=1 use=4 assigned=1 base=0054)
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
;     {block exit}
;     {block enter}
;       --- records ---
;       --- variables ---
;       67e108:__btemp105  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _bitbucket+0
;       67ec58:__btemp106  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _bitbucket+0
;       67f4c8:__btemp107  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> _bitbucket+0
;       --- labels ---
;       {block enter}
;         --- records ---
;         --- variables ---
;         --- labels ---
;       {block exit}
;     {block exit}
;   {block exit}
;      lcd_prg_hor ----L --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5f1a08:_x0_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5f1b08:_y_15  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5f1c08:_x1_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5f1d08:_value_3  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5f1e08:_max_3  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5f1f08:_startleft_1  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5f2108:_maxx  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5f2208:_thevalue_1  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5f2308:__temp_118  (type=i dflags=C---- sz=3 use=0 assigned=0)
;         = 0
;        6689d8:__rparam16  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e3b08:__bitbucket_1  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      lcd_prg_ver ----L --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5ef208:_x_134  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5ef308:_y0_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5ef408:_y1_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5ef508:_value_1  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5ef608:_max_1  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5ef708:_starttop_1  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5ef808:_maxy  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5ef908:_thevalue  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5efa08:__temp_117  (type=i dflags=C---- sz=3 use=0 assigned=0)
;         = 0
;        5f1808:__rparam15  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5d8e28:__bitbucket_2  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      lcd_print --D-- -U- (frame_sz=25 blocks=13)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5ec408:_x_131 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0055)
;        5ec508:_y_13 byte (type=i dflags=----- auto sz=1 use=2 assigned=7 base=0057)
;        5ec608:__str_count_1  (type=i dflags=----- auto sz=2 use=2 assigned=14 base=005b)
;        5ec708:_str_3  (type=* dflags=----- auto ptr_lookup sz=2 use=2 assigned=14 base=005e)
;        5ec808:_i_1 byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=0064)
;        5ec908:_j_1 byte (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0065)
;        5ecc08:__temp_111  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0066)
;        5eeb08:__btemp_42  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5eec08:__btemp103  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5d5518:__bitbucket_3  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0067)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5ed108:__rparam14 byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0068)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            5ed208:_x_132 byte (type=i dflags=----- auto sz=1 use=5 assigned=2 base=006a)
;            5ed308:_debug_6 bit (type=B dflags=---B- sz=1 use=1 assigned=1 bit=0) ---> ___bitbucket3+0
;            5ed408:_findex_5 word (type=i dflags=----- auto sz=2 use=9 assigned=7 base=006b)
;            5ed508:_cx_5 byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=00a0)
;            5ed608:_doloop_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=006e)
;            5ed708:__btemp_41  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;             = 0
;            5ed808:__btemp72_5  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;            5ed908:__btemp73_5  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;            5eda08:__temp_112  (type=i dflags=----- auto sz=4 use=4 assigned=4 base=00a3)
;            5edb08:__floop7_5  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=00aa)
;            5edc08:__btemp76_5  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;              5edd08:__btemp74_5  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;              5ede08:__btemp75_5  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                5edf08:__rparam3_5 byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00ae)
;                --- labels ---
;                {block enter}
;                  --- records ---
;                  --- variables ---
;                  5ee108:_side_42 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00af)
;                  5ee208:__temp_113  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b0)
;                  --- labels ---
;                {block exit}
;                {block enter}
;                  --- records ---
;                  --- variables ---
;                  5ee308:_side_43 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00af)
;                  5ee408:__temp_114  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b0)
;                  --- labels ---
;                {block exit}
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                5ee508:__rparam4_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00ae)
;                5ee608:__rparam5_5 byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00af)
;                --- labels ---
;                {block enter}
;                  --- records ---
;                  --- variables ---
;                  5ee708:_side_44 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b0)
;                  5ee808:__temp_115  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b1)
;                  --- labels ---
;                {block exit}
;                {block enter}
;                  --- records ---
;                  --- variables ---
;                  5ee908:_side_45 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b0)
;                  5eea08:__temp_116  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b1)
;                  --- labels ---
;                {block exit}
;              {block exit}
;            {block exit}
;          {block exit}
;        {block exit}
;      {block exit}
;      lcd_num --D-- -U- (frame_sz=29 blocks=34)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5e4d08:_x_126 byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0055)
;        5e4e08:_y_11 byte (type=i dflags=----- auto sz=1 use=6 assigned=1 base=0057)
;        5e4f08:_num_1 word (type=i dflags=----- auto sz=2 use=6 assigned=2 base=005b)
;        5e5208:__temp_95  (type=i dflags=----- auto sz=4 use=12 assigned=13 base=005e)
;        5e5408:_hundrets byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0066)
;        5e5a08:_tens byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=0067)
;        5e6208:_ones byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0068)
;        5e6608:__rparam9 byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=006a)
;        5e8608:__rparam10  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e8708:__rparam11 byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=006b)
;        5ea708:__rparam12  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5ea808:__rparam13 byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=006d)
;        572a38:__bitbucket_4  (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00a0)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5e6708:_x_127 byte (type=i dflags=----- auto sz=1 use=5 assigned=2 base=006e)
;          5e6808:_debug_3 bit (type=B dflags=---B- sz=1 use=1 assigned=1 bit=0) ---> ___bitbucket4+0
;          5e6908:_findex_2 word (type=i dflags=----- auto sz=2 use=9 assigned=7 base=00a3)
;          5e6a08:_cx_2 byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=00a7)
;          5e6b08:_doloop_2 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00a8)
;          5e6c08:__btemp_38  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;           = 0
;          5e6d08:__btemp72_2  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          5e6e08:__btemp73_2  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          5e6f08:__temp_96  (type=i dflags=----- auto sz=4 use=4 assigned=4 base=00aa)
;          5e7108:__floop7_2  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=00b1)
;          5e7208:__btemp76_2  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;            5e7308:__btemp74_2  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;            5e7408:__btemp75_2  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5e7508:__rparam3_2 byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00b2)
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e7608:_side_30 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b3)
;                5e7708:__temp_97  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e7808:_side_31 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b3)
;                5e7908:__temp_98  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5e7a08:__rparam4_2 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b2)
;              5e7b08:__rparam5_2 byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00b3)
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e7c08:_side_32 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                5e7d08:__temp_99  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b5)
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e7e08:_side_33 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                5e7f08:__temp_100  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b5)
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5e8808:_x_128 byte (type=i dflags=----- auto sz=1 use=5 assigned=2 base=006e)
;          5e8908:_debug_4 bit (type=B dflags=---B- sz=1 use=1 assigned=1 bit=0) ---> ___bitbucket4+0
;          5e8a08:_findex_3 word (type=i dflags=----- auto sz=2 use=9 assigned=7 base=00a3)
;          5e8b08:_cx_3 byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=00a7)
;          5e8c08:_doloop_3 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00a8)
;          5e8d08:__btemp_39  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;           = 0
;          5e8e08:__btemp72_3  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          5e8f08:__btemp73_3  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          5e9108:__temp_101  (type=i dflags=----- auto sz=4 use=4 assigned=4 base=00aa)
;          5e9208:__floop7_3  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=00b1)
;          5e9308:__btemp76_3  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;            5e9408:__btemp74_3  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;            5e9508:__btemp75_3  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5e9608:__rparam3_3 byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00b2)
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e9708:_side_34 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b3)
;                5e9808:__temp_102  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e9908:_side_35 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b3)
;                5e9a08:__temp_103  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5e9b08:__rparam4_3 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b2)
;              5e9c08:__rparam5_3 byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00b3)
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e9d08:_side_36 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                5e9e08:__temp_104  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b5)
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e9f08:_side_37 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                5ea108:__temp_105  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b5)
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5ea908:_x_129 byte (type=i dflags=----- auto sz=1 use=5 assigned=2 base=006e)
;          5eaa08:_debug_5 bit (type=B dflags=---B- sz=1 use=1 assigned=1 bit=0) ---> ___bitbucket4+0
;          5eab08:_findex_4 word (type=i dflags=----- auto sz=2 use=9 assigned=7 base=00a3)
;          5eac08:_cx_4 byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=00a7)
;          5ead08:_doloop_4 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00a8)
;          5eae08:__btemp_40  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;           = 0
;          5eaf08:__btemp72_4  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          5eb108:__btemp73_4  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          5eb208:__temp_106  (type=i dflags=----- auto sz=4 use=4 assigned=4 base=00aa)
;          5eb308:__floop7_4  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=00b1)
;          5eb408:__btemp76_4  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;            5eb508:__btemp74_4  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;            5eb608:__btemp75_4  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5eb708:__rparam3_4 byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00b2)
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                5eb808:_side_38 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b3)
;                5eb908:__temp_107  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                5eba08:_side_39 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b3)
;                5ebb08:__temp_108  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5ebc08:__rparam4_4 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b2)
;              5ebd08:__rparam5_4 byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00b3)
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                5ebe08:_side_40 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                5ebf08:__temp_109  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b5)
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                5ec108:_side_41 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;                5ec208:__temp_110  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b5)
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;        {block exit}
;      {block exit}
;      lcd_home ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5723b8:__bitbucket_5  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      lcd_setcursor ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5e4108:_row_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e4208:_col_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e4408:__temp_94  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5f1608:__bitbucket_6  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      lcd_clearscreen --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5f1508:__bitbucket_7  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _lcd_put ----- --- (frame_sz=0 blocks=12)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5e1b08:_char_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e3808:__temp_93  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5f1408:__bitbucket_8  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5e1d08:_x_124  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5e1e08:_debug_2  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;           = 0
;          5e1f08:_findex_1  (type=i dflags=C---- sz=2 use=0 assigned=0)
;           = 0
;          5e2108:_cx_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5e2208:_doloop_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5e2308:__btemp_37  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;           = 0
;          5e2408:__btemp72_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          5e2508:__btemp73_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          5e2608:__temp_88  (type=i dflags=C---- sz=4 use=0 assigned=0)
;           = 0
;          5e2708:__floop7_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5e2808:__btemp76_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;            5e2908:__btemp74_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;            5e2a08:__btemp75_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5e2b08:__rparam3_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;               = 0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e2c08:_side_26  (type=i dflags=C---- sz=1 use=0 assigned=0)
;                 = 0
;                5e2d08:__temp_89  (type=i dflags=C---- sz=1 use=0 assigned=0)
;                 = 0
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e2e08:_side_27  (type=i dflags=C---- sz=1 use=0 assigned=0)
;                 = 0
;                5e2f08:__temp_90  (type=i dflags=C---- sz=1 use=0 assigned=0)
;                 = 0
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5e3108:__rparam4_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;               = 0
;              5e3208:__rparam5_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;               = 0
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e3308:_side_28  (type=i dflags=C---- sz=1 use=0 assigned=0)
;                 = 0
;                5e3408:__temp_91  (type=i dflags=C---- sz=1 use=0 assigned=0)
;                 = 0
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e3508:_side_29  (type=i dflags=C---- sz=1 use=0 assigned=0)
;                 = 0
;                5e3608:__temp_92  (type=i dflags=C---- sz=1 use=0 assigned=0)
;                 = 0
;                --- labels ---
;              {block exit}
;            {block exit}
;          {block exit}
;        {block exit}
;      {block exit}
;      lcd_filled_rect --D-- -U- (frame_sz=26 blocks=19)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a1858:_x0_5 byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=0055)
;        5a2f38:_y0_5 byte (type=i dflags=----- auto sz=1 use=2 assigned=4 base=0057)
;        5a2468:_x1_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=4 base=005b)
;        5a2d18:_y1_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=4 base=005d)
;        5a34d8:_state_1 bit (type=B dflags=---B- sz=1 use=1 assigned=4 bit=0) ---> ___bitbucket9+0
;        5a4d38:__temp_83  (type=i dflags=----- auto sz=2 use=2 assigned=2 base=005e)
;        5a7878:_xdiff byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0064)
;        5a9a48:_ydiff byte (type=i dflags=----- auto sz=1 use=4 assigned=1 base=0065)
;        5abd78:_currx byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=0066)
;        5b4fa8:_curry byte (type=i dflags=----- auto sz=1 use=5 assigned=3 base=0067)
;        5b5f48:_write_2 bit (type=B dflags=---B- sz=1 use=1 assigned=4 bit=1) ---> ___bitbucket9+0
;        5b5bc8:_area word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0068)
;        5baea8:__floop9  (type=i dflags=----- auto sz=2 use=4 assigned=4 base=006b)
;        5bdd18:__btemp_35  (type=i dflags=---B- sz=8 use=0 assigned=0 bit=2) ---> ___bitbucket9+0
;        5e1908:__btemp102  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=9) ---> ___bitbucket9+0
;        5f1308:__bitbucket_9  (type=i dflags=----- auto sz=3 use=17 assigned=34 base=00a0)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5c1e08:__btemp95  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> ___bitbucket9+0
;          5c51e8:__btemp96  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket9+0
;          5c6f28:__btemp97  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=4) ---> ___bitbucket9+0
;          5c83f8:__rparam7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5caf38:__rparam8 byte (type=i dflags=----- auto sz=1 use=5 assigned=1 base=006f)
;          5e0f08:__btemp98  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> ___bitbucket9+0
;          5e1408:__btemp99  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=6) ---> ___bitbucket9+0
;          5e1508:__btemp100  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=7) ---> ___bitbucket9+0
;          5e1608:__btemp101  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=8) ---> ___bitbucket9+0
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
;            5cbbb8:_x_123 byte (type=i dflags=----- auto sz=1 use=7 assigned=2 base=00a7)
;            5cc408:_e1_1 bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=10) ---> ___bitbucket9+0
;            5ccb98:_e3_1 bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=11) ---> ___bitbucket9+0
;            5cd278:_e4_1 bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=12) ---> ___bitbucket9+0
;            5cd758:_e2_1 bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=13) ---> ___bitbucket9+0
;            5cddd8:__btemp_36  (type=i dflags=---B- sz=10 use=0 assigned=0 bit=14) ---> ___bitbucket9+0
;            5ced28:__btemp77_1  (type=B dflags=---B- sz=1 use=2 assigned=2 bit=14) ---> ___bitbucket9+0
;            5cfc08:__btemp78_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=15) ---> ___bitbucket9+0
;            5d0cc8:__temp_84  (type=i dflags=----- auto sz=2 use=11 assigned=11 base=00a8)
;            5d1d08:__btemp79_1  (type=B dflags=---B- sz=1 use=2 assigned=2 bit=16) ---> ___bitbucket9+0
;            5d2ca8:__btemp80_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=17) ---> ___bitbucket9+0
;            5d3c18:__btemp81_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=18) ---> ___bitbucket9+0
;            5e0108:__btemp82_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=19) ---> ___bitbucket9+0
;            5e0208:__btemp83_1  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=20) ---> ___bitbucket9+0
;            5e0308:_data_22 byte (type=i dflags=----- auto sz=1 use=4 assigned=5 base=00ae)
;            5e0408:_yy_3 byte (type=i dflags=----- auto sz=1 use=2 assigned=2 base=00af)
;            5e0508:_side_25 byte (type=i dflags=----- auto sz=1 use=6 assigned=2 base=00b0)
;            5e0608:__btemp84_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=21) ---> ___bitbucket9+0
;            5e0708:__btemp85_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=22) ---> ___bitbucket9+0
;            5e0808:__btemp86_1  (type=B dflags=---B- sz=1 use=0 assigned=0 bit=23) ---> ___bitbucket9+0
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
;              5e0908:__rparam6_1 byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00b1)
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e0a08:__temp_85  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b2)
;                --- labels ---
;              {block exit}
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e0b08:__temp_86  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b2)
;                --- labels ---
;              {block exit}
;            {block exit}
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
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;              {block enter}
;                --- records ---
;                --- variables ---
;                5e0c08:__temp_87  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b1)
;                --- labels ---
;              {block exit}
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
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
;      {block exit}
;      lcd_rect ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        582d78:_x0_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        584fa8:_y0_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        589fa8:_x1_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        58f5e8:_y1_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5f1208:__bitbucket_10  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      lcd_line --D-- -U- (frame_sz=20 blocks=21)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5dd128:_x0_1 byte (type=i dflags=----- auto sz=1 use=5 assigned=1 base=0055)
;        5dd228:_y0_1 byte (type=i dflags=----- auto sz=1 use=5 assigned=6 base=0057)
;        5dd328:_x1_1 byte (type=i dflags=----- auto sz=1 use=4 assigned=6 base=005b)
;        5dd428:_y1_1 byte (type=i dflags=----- auto sz=1 use=4 assigned=6 base=005d)
;        5dd528:_onoff_5 bit (type=B dflags=---B- sz=1 use=1 assigned=6 bit=0) ---> ___bitbucket11+0
;        5dd628:_xi byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=005e)
;        5dd728:_yi byte (type=i dflags=----- auto sz=1 use=5 assigned=3 base=0062)
;        5dd828:_xfark byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=0064)
;        5dd928:_yfark byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=0065)
;        5dda28:_fark byte (type=i dflags=----- auto sz=1 use=1 assigned=2 base=0066)
;        5ddb28:_xx byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=0067)
;        5ddc28:__btemp_33  (type=i dflags=C--B- sz=8 use=0 assigned=0 bit=0)
;         = 0
;        5ddd28:__btemp87  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5dde28:__temp_78  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5de228:__btemp88  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5de528:__btemp89  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5de728:__floop8  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0068)
;        581c48:__btemp94  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=7)
;        5f1108:__bitbucket_11  (type=i dflags=----- auto sz=1 use=1 assigned=6 base=006a)
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
;        {block enter}
;          --- records ---
;          --- variables ---
;          5df628:__btemp90  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          5dfc28:__btemp92  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            5de928:_x_122 byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=006b)
;            5dea28:_data_21 byte (type=i dflags=----- auto sz=1 use=3 assigned=4 base=006d)
;            5deb28:_yy_2 byte (type=i dflags=----- auto sz=1 use=2 assigned=2 base=00a0)
;            5dec28:_side_24 byte (type=i dflags=----- auto sz=1 use=6 assigned=2 base=006e)
;            5ded28:__btemp_34  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;             = 0
;            5dee28:__btemp66_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;            5def28:__temp_79  (type=i dflags=----- auto sz=2 use=5 assigned=5 base=00a3)
;            5df128:__rparam0_1 byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00a7)
;            5df228:__btemp67_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5df328:__temp_80  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00a8)
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5df428:__temp_81  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00a8)
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
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5df528:__temp_82  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00a8)
;              --- labels ---
;            {block exit}
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            5df728:__btemp91  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;          {block enter}
;            --- records ---
;            --- variables ---
;            5dfd28:__btemp93  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
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
;      lcd_write_pixel_buff ----L --- (frame_sz=0 blocks=12)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5d9228:_x_121  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5d9328:_y_9  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5d9428:_onoff_3  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5d9528:_write_1  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5d9628:_e1  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5d9728:_e3  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5d9828:_e4  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5d9928:_e2  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5d9a28:__btemp_32  (type=i dflags=C--B- sz=10 use=0 assigned=0 bit=0)
;         = 0
;        5d9b28:__btemp77  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5d9c28:__btemp78  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5d9e28:__temp_74  (type=i dflags=C---- sz=2 use=4 assigned=0)
;         = 0
;        5da128:__btemp79  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5da228:__btemp80  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;        5da428:__btemp81  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;        5da528:__btemp82  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;        5da628:__btemp83  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
;        5dac28:_data_20  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5dad28:_yy_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5dae28:_side_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5db128:__btemp84  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=7)
;        5db528:__btemp85  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=8)
;        5dbe28:__btemp86  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=9)
;        5f0e08:__bitbucket_12  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          5db928:__rparam6  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            5db628:__temp_75  (type=i dflags=C---- sz=1 use=0 assigned=0)
;             = 0
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            5dba28:__temp_76  (type=i dflags=C---- sz=1 use=0 assigned=0)
;             = 0
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
;          {block enter}
;            --- records ---
;            --- variables ---
;            5dcb28:__temp_77  (type=i dflags=C---- sz=1 use=0 assigned=0)
;             = 0
;            --- labels ---
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      lcd_write_char ----L --- (frame_sz=0 blocks=11)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5d5718:_x_119  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5d5818:_y_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5d5918:_ch_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5d5a18:_debug_1  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5d5c18:_findex  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5d5e18:_cx  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5d6128:_doloop  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5d6328:__btemp_31  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;         = 0
;        5d6428:__btemp72  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5d6628:__btemp73  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5d6928:__temp_69  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        5d6e28:__floop7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5d8c28:__btemp76  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;        5f0f08:__bitbucket_13  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          5d7328:__btemp74  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          5d7c28:__btemp75  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            5d7828:__rparam3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;             = 0
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              5d7428:_side_19  (type=i dflags=C---- sz=1 use=0 assigned=0)
;               = 0
;              5d7528:__temp_70  (type=i dflags=C---- sz=1 use=0 assigned=0)
;               = 0
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5d7928:_side_20  (type=i dflags=C---- sz=1 use=0 assigned=0)
;               = 0
;              5d7a28:__temp_71  (type=i dflags=C---- sz=1 use=0 assigned=0)
;               = 0
;              --- labels ---
;            {block exit}
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            5d7f28:__rparam4  (type=i dflags=C---- sz=1 use=0 assigned=0)
;             = 0
;            5d8528:__rparam5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;             = 0
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              5d8128:_side_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;               = 0
;              5d8228:__temp_72  (type=i dflags=C---- sz=1 use=0 assigned=0)
;               = 0
;              --- labels ---
;            {block exit}
;            {block enter}
;              --- records ---
;              --- variables ---
;              5d8628:_side_22  (type=i dflags=C---- sz=1 use=0 assigned=0)
;               = 0
;              5d8728:__temp_73  (type=i dflags=C---- sz=1 use=0 assigned=0)
;               = 0
;              --- labels ---
;            {block exit}
;          {block exit}
;        {block exit}
;      {block exit}
;      lcd_init ----L --- (frame_sz=0 blocks=15)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5f0d08:__bitbucket_14  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5cbcc8:_x_113  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
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
;          5cdee8:_x_114 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portc_shadow+0
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
;          5cea28:_x_115 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _porta_shadow+0
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
;          5cf3f8:_x_116 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _portc_shadow+0
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
;          5cfd18:_x_117 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portc_shadow+0
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
;          5d0f38:_side_15  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5d0918:_page_2  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5d1108:__temp_65  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5d1648:_side_16  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5d2108:_page_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5d2198:__temp_66  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5d2f88:_side_17  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5d25e8:_column_4  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5d3108:__temp_67  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5d3ef8:_side_18  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5d3f88:_column_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          5d3558:__temp_68  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          --- labels ---
;        {block exit}
;      {block exit}
;      lcd_fill --D-- -U- (frame_sz=7 blocks=7)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5c3fa8:_data_19 byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=0055)
;        5c4108:_i byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=0057)
;        5c41c8:_j  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c47e8:__floop5  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=005b)
;        5c9c68:__btemp_30  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        5ca578:__temp_64  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5cae18:__btemp71  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5f0c08:__bitbucket_15  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5c8d08:__floop6  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=005d)
;          5c9d38:__btemp70  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            5c5408:_side_11 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=005e)
;            5c5498:__temp_60  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0062)
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            5c5868:_side_12 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=005e)
;            5c5e48:__temp_61  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0062)
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            5c6a98:_side_13 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=005e)
;            5c6b28:_column_2 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0062)
;            5c6bb8:__temp_62  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0064)
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            5c7d88:_side_14 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=005e)
;            5c7e18:_column_3 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0062)
;            5c7ea8:__temp_63  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0064)
;            --- labels ---
;          {block exit}
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      ks0108_read_byte ----- --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5bfb38:_x_112  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5bfbf8:_y_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5bfd48:_side_10  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        54cd98:_data_17  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56efa8:__btemp_29  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        571588:__btemp69  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5c07d8:__temp_57  (type=? dflags=C---- sz=0 use=2 assigned=0)
;         = 0
;        5c2418:__rparam2  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5f0b08:__bitbucket_16  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          5c1858:__temp_58  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5c26f8:__temp_59  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          --- labels ---
;        {block exit}
;      {block exit}
;      ks0108_write_byte --D-- -U- (frame_sz=6 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5bb8f8:_x_110 byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=00b3)
;        5bb9b8:_y_3 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;        5bba78:_veri_1 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b5)
;        5bbbc8:_side_9 byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=00b6)
;        5bc108:__btemp_28  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5bc1d8:__btemp68  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5bc9f8:__temp_54  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5be648:__rparam1 byte (type=i dflags=----- auto sz=1 use=3 assigned=3 base=00b8)
;        5f0a08:__bitbucket_17  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          5bdab8:__temp_55  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b9)
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5be928:__temp_56  (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b9)
;          --- labels ---
;        {block exit}
;      {block exit}
;      lcd_write_pixel ----L --- (frame_sz=0 blocks=7)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5b3108:_x_108  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5b3198:_y_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5b3228:_onoff_1  (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5b32f8:_data_16  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5b33b8:_yy  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5b34d8:_side_8  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5b3a58:__btemp_27  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        5b3b28:__btemp66  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5b4478:__temp_50  (type=i dflags=C---- sz=2 use=4 assigned=0)
;         = 0
;        5b63a8:__rparam0  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5b7948:__btemp67  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5f0908:__bitbucket_18  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          5b5618:__temp_51  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5b6688:__temp_52  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
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
;          5ba768:__temp_53  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          --- labels ---
;        {block exit}
;      {block exit}
;      _ks0108_data --D-- -U- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5f0808:__bitbucket_19  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5b1e58:_x_106 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=5) ---> _portc_shadow+0
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      _ks0108_inst --D-- -U- (frame_sz=0 blocks=3)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5f0608:__bitbucket_20  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          5ae868:_x_105 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=5) ---> _portc_shadow+0
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;      {block exit}
;      _ks0108_column ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5aff58:_side_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        528ad8:_column_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        53efa8:__temp_49  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5f0708:__bitbucket_21  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _ks0108_page ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5aece8:_side_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5aeda8:_page_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5af108:__temp_48  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5f0508:__bitbucket_22  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      lcd_off ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5f0308:__bitbucket_23  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      lcd_on --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5efe08:__bitbucket_24  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _ks0108_read --D-- -U- (frame_sz=2 blocks=19)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5a6a98:_side_3 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b3)
;        5a6b38:_data_15 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00b4)
;        5a7108:__btemp_26  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5a71d8:__btemp65  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5efc08:__bitbucket_25  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            5a7988:_x_98 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=0) ---> _portc_shadow+0
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            5a8608:_x_99 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=1) ---> _portc_shadow+0
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5a84f8:_x_100 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=3) ---> _portc_shadow+0
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
;          5a9b58:_x_101 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=5) ---> _porta_shadow+0
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
;          5aac58:_x_102 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=5) ---> _porta_shadow+0
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
;          5ab568:_x_103 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=1) ---> _portc_shadow+0
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
;          5abe88:_x_104 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=0) ---> _portc_shadow+0
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
;      {block exit}
;      _ks0108_write --D-- -U- (frame_sz=2 blocks=21)
;      {block enter}
;        --- records ---
;        --- variables ---
;        59f3a8:_side_1 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00ba)
;        59f438:_data_14 byte (type=i dflags=----- auto sz=1 use=1 assigned=49 base=00bb)
;        59f6a8:__btemp_25  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        59f778:__btemp64  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5efb08:__bitbucket_26  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            59ff28:_x_91 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=0) ---> _portc_shadow+0
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            5a0d38:_x_92 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=1) ---> _portc_shadow+0
;            --- labels ---
;            {block enter}
;              --- records ---
;              --- variables ---
;              --- labels ---
;            {block exit}
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5a1968:_x_93 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=3) ---> _portc_shadow+0
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
;          {block enter}
;            --- records ---
;            --- variables ---
;            --- labels ---
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          5a35e8:_x_94 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=5) ---> _porta_shadow+0
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
;          5a4528:_x_95 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=5) ---> _porta_shadow+0
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
;          5a4e48:_x_96 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=1) ---> _portc_shadow+0
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
;          5a5798:_x_97 bit (type=B dflags=---B- sz=1 use=0 assigned=1 bit=0) ---> _portc_shadow+0
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
;      {block exit}
;      serial_hw_byte --D-- -U- (frame_sz=6 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        594b98:_b_1 word (type=i dflags=----- auto sz=2 use=11 assigned=20 base=00b6)
;        594c88:_zw byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=00b9)
;        594d48:_oldb byte (type=i dflags=----- auto sz=1 use=2 assigned=1 base=00ba)
;        595598:__temp_46  (type=i dflags=----- auto sz=2 use=6 assigned=7 base=00bb)
;        595e48:__btemp_23  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        595f18:__btemp61  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5984b8:__btemp62  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5e4808:__bitbucket_27  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      serial_hw_printf --D-- -U- (frame_sz=6 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5929d8:__str_count  (type=i dflags=----- auto sz=2 use=1 assigned=6 base=0055)
;        592a68:_str_1  (type=* dflags=----- auto ptr_lookup sz=2 use=2 assigned=6 base=005b)
;        592b58:_l byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=005e)
;        592c18:_t byte (type=i dflags=----- auto sz=1 use=3 assigned=2 base=0062)
;        593e18:__btemp_22  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        593ee8:__btemp60  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5e3e08:__bitbucket_28  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
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
;        5e4608:__bitbucket_29  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_raw_put ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5914a8:_data_12  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e4308:__bitbucket_30  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _serial_hw_data_get ----- --- (frame_sz=0 blocks=6)
;      {block enter}
;        --- records ---
;        --- variables ---
;        58eb88:_data_10  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        58ee58:__btemp_21  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        58ef28:__btemp58  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        590248:__btemp59  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5e3708:__bitbucket_31  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      _serial_hw_data_put ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        58e268:_data_9  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5e1c08:__bitbucket_32  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_read ----- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        58bfa8:_data_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        58c108:__btemp_20  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        58c1d8:__btemp57  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5c1ee8:__bitbucket_33  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        589af8:_data_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5c06a8:__bitbucket_34  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5877b8:_data_3  (type=i dflags=C---- sz=2 use=2 assigned=0)
;         = 0
;        587878:_dx  (type=a dflags=----- sz=2 use=0 assigned=0) ---> __data3
;        587ba8:__btemp_19  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        587c78:__btemp55  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        588a18:__btemp56  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        54f9e8:__bitbucket_35  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      serial_hw_write --D-- -U- (frame_sz=1 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        586188:_data_1 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=00bd)
;        586418:__btemp_18  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5864e8:__btemp54  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5891a8:__bitbucket_36  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        588448:__bitbucket_37  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      serial_hw_disable ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5844e8:__btemp_17  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        5845b8:__btemp53  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        57e678:__bitbucket_38  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        57e548:__bitbucket_39  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _calculate_and_set_baudrate --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5659b8:_max_deviation  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 5
;        57f638:_usart_div  (type=i dflags=C---U sz=4 use=1 assigned=0)
;         = 259
;        581108:_real_baud  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 19230
;        57dd18:__bitbucket_40  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm2_set_percent_dutycycle ----- --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57b188:_percent_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        57b258:_duty_13  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        57b4c8:__btemp_16  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        57b598:__btemp51  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        57c3c8:__btemp52  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        57cb18:__temp_45  (type=i dflags=C---- sz=6 use=0 assigned=0)
;         = 0
;        57dbb8:__bitbucket_41  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        579bb8:_duty_12  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        579dc8:__temp_44  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        57d918:__bitbucket_42  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm2_set_dutycycle_lowres ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        578268:_duty_10  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        5785b8:__temp_43  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        57d5c8:__bitbucket_43  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm2_set_dutycycle_highres --D-- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        575748:_duty_8  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        5759b8:__btemp_15  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        575a88:__btemp50  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        576a98:__temp_42  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        57d7b8:__bitbucket_44  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        57c9e8:__bitbucket_45  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm2_on --D-- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        57c2a8:__bitbucket_46  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_set_percent_dutycycle ----- --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        56e3a8:_percent_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56e478:_duty_6  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        56e6e8:__btemp_14  (type=i dflags=C--B- sz=2 use=0 assigned=0 bit=0)
;         = 0
;        56e7b8:__btemp48  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        56f648:__btemp49  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        56fd98:__temp_41  (type=i dflags=C---- sz=6 use=0 assigned=0)
;         = 0
;        57bc38:__bitbucket_47  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        56ce78:_duty_5 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0055)
;        56d108:__temp_40  (type=i dflags=----- auto sz=4 use=6 assigned=6 base=0057)
;        57a468:__bitbucket_48  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_set_dutycycle_lowres ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        56b5a8:_duty_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56b8f8:__temp_39  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        57a338:__bitbucket_49  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_set_dutycycle_highres --D-- -U- (frame_sz=2 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        568c08:_duty_1 word (type=i dflags=----- auto sz=2 use=5 assigned=4 base=0062)
;        568e78:__btemp_13  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        568f48:__btemp47  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        569f28:__temp_38  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        579ea8:__bitbucket_50  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        578de8:__bitbucket_51  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm1_on --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        578488:__bitbucket_52  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      pwm_set_frequency ----- --- (frame_sz=0 blocks=5)
;      {block enter}
;        --- records ---
;        --- variables ---
;        508fa8:_freq_1  (type=i dflags=C---- sz=4 use=0 assigned=0)
;         = 0
;        51af98:__temp_37  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        561108:__btemp_12  (type=i dflags=C--B- sz=5 use=0 assigned=0 bit=0)
;         = 0
;        5611d8:__btemp42  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        5616f8:__btemp43  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        561ab8:__btemp44  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        5773b8:__bitbucket_53  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          562398:__btemp45  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          562f28:__btemp46  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
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
;        55bfa8:_prescaler_1 byte (type=i dflags=----- auto sz=1 use=3 assigned=1 base=0055)
;        55c708:__temp_36  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        55d208:__btemp_11  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        55d2d8:__btemp39  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        55e3c8:__btemp40  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        55f108:__btemp41  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        576968:__bitbucket_54  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      adc_init ----L --- (frame_sz=0 blocks=9)
;      {block enter}
;        --- records ---
;        --- variables ---
;        576238:__bitbucket_55  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;          {block enter}
;            --- records ---
;            --- variables ---
;            54f6a8:_vcfg_shadow_2  (type=i dflags=C---- sz=1 use=0 assigned=0)
;             = 0
;            --- labels ---
;          {block exit}
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          54f548:_jallib_adfm_1 bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> adcon1+0
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          551218:_jallib_adcs_lsb_1  (type=i dflags=-V-B- alias sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;          5512a8:_jallib_adcs_msb_1  (type=B dflags=CV-B- sz=1 use=0 assigned=0 bit=0)
;           = 0
;          551338:_adcs_1  (type=i dflags=CV-B- sz=3 use=0 assigned=0 bit=0)
;           = 0
;          5513c8:__btemp_9  (type=i dflags=C--B- sz=6 use=0 assigned=0 bit=0)
;           = 0
;          551458:__btemp32_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;          5514e8:__btemp33_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;          551578:__btemp34_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;          551608:__btemp35_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;          551698:__btemp36_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;          551728:__btemp37_1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;          5517b8:_adcs_lsb_1  (type=i dflags=-V-B- sz=2 use=0 assigned=0 base=0000 bit=0)
;          551848:_adcs_msb_1 bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 base=0000 bit=2)
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
;        5758b8:__bitbucket_56  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          54d178:_vcfg_shadow_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;           = 0
;          --- labels ---
;        {block exit}
;      {block exit}
;      _adc_init_acquisition_delay ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        54ca58:_adc_tc byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 12
;        54c7b8:_adc_tcoff byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 2
;        574a88:__bitbucket_57  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_init_justify ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        54b108:_jallib_adfm bit (type=B dflags=-V-B- alias sz=1 use=0 assigned=0 bit=7) ---> adcon1+0
;        5736a8:__bitbucket_58  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_read_low_res --D-- -U- (frame_sz=4 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        546908:_adc_chan_7 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0055)
;        548a48:_adc_value byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0057)
;        548ba8:_shift_alias word (type=i dflags=----- auto sz=2 use=5 assigned=6 base=005b)
;        548d88:_ax_2  (type=a dflags=----- sz=2 use=1 assigned=2) ---> shift_alias+0
;        5498d8:__temp_35  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5717b8:__bitbucket_59  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_read_bytes ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        546d88:_adc_chan_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        546e48:_adc_hbyte_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        546f08:_adc_lbyte_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        547108:_ad_value_1  (type=i dflags=C---- sz=2 use=1 assigned=0)
;         = 0
;        5471c8:_ax_1  (type=a dflags=----- sz=2 use=0 assigned=0) ---> __ad_value1
;        547438:__temp_34  (type=? dflags=C---- sz=0 use=1 assigned=0)
;         = 0
;        571688:__bitbucket_60  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_read --D-- -U- (frame_sz=3 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        543408:_adc_chan_3 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0055)
;        5445e8:_ad_value word (type=i dflags=----- auto sz=2 use=2 assigned=2 base=0057)
;        5454d8:_ax  (type=a dflags=----- sz=2 use=0 assigned=2) ---> ad_value+0
;        570e88:__bitbucket_61  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_read_low_res --D-- -U- (frame_sz=2 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        541288:_adc_chan_1 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=005e)
;        542108:_adc_byte_1 byte (type=i dflags=----- auto sz=1 use=1 assigned=1 base=0062)
;        543568:__btemp_8  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        543698:__btemp38  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        570d28:__bitbucket_62  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        53bc68:_jallib_adcs_lsb  (type=i dflags=-V-B- alias sz=2 use=0 assigned=0 bit=6) ---> adcon0+0
;        53bb08:_adc_adcs_bit_long byte (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 2
;        53bfa8:_adc_adcs_bit_split bit (type=B dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        53c1d8:_jallib_adcs_msb  (type=B dflags=CV-B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        53c558:_adcs  (type=i dflags=CV-B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        53d558:__btemp_7  (type=i dflags=C--B- sz=6 use=0 assigned=0 bit=0)
;         = 0
;        53d448:__btemp32  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        53da38:__btemp33  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        53e5c8:__btemp34  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        53e8c8:__btemp35  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;        53f478:__btemp36  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;        53f778:__btemp37  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;        52cbb8:_adcs_lsb  (type=i dflags=-V-B- sz=2 use=0 assigned=0 base=0000 bit=0)
;        52dbb8:_adcs_msb bit (type=B dflags=-V-B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        570a88:__bitbucket_63  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5387f8:_factor_1 word (type=i dflags=----- auto sz=2 use=2 assigned=6 base=0055)
;        5388e8:_tad_ok bit (type=B dflags=---B- sz=1 use=1 assigned=2 bit=0) ---> ___bitbucket64+0
;        538da8:__temp_33  (type=i dflags=----- auto sz=2 use=2 assigned=2 base=005b)
;        539ce8:__btemp_6  (type=i dflags=---B- sz=3 use=0 assigned=0 bit=1) ---> ___bitbucket64+0
;        539db8:__btemp29  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=1) ---> ___bitbucket64+0
;        53a428:__btemp30  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=2) ---> ___bitbucket64+0
;        53a7d8:__btemp31  (type=B dflags=---B- sz=1 use=1 assigned=2 bit=3) ---> ___bitbucket64+0
;        570738:__bitbucket_64  (type=i dflags=----- auto sz=1 use=4 assigned=8 base=005e)
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      set_digital_pin ----- --- (frame_sz=0 blocks=12)
;      {block enter}
;        --- records ---
;        --- variables ---
;        524be8:_an_pin_num_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        526e78:__btemp_5  (type=i dflags=C--B- sz=11 use=0 assigned=0 bit=0)
;         = 0
;        529c08:__btemp18  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        52ab58:__btemp19  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        52bb58:__btemp20  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        52cb58:__btemp21  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;        52db58:__btemp22  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;        52ecb8:__btemp23  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;        4fcbb8:__btemp24  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
;        530b58:__btemp25  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=7)
;        531b58:__btemp26  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=8)
;        532b58:__btemp27  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=9)
;        533b58:__btemp28  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=10)
;        570928:__bitbucket_65  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      set_analog_pin --D-- -U- (frame_sz=1 blocks=12)
;      {block enter}
;        --- records ---
;        --- variables ---
;        515138:_an_pin_num_1 byte (type=i dflags=----- auto sz=1 use=11 assigned=1 base=0055)
;        516cd8:__btemp_4  (type=i dflags=C--B- sz=11 use=0 assigned=0 bit=0)
;         = 0
;        517108:__btemp7  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        518368:__btemp8  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        519728:__btemp9  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
;        51aa88:__btemp10  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=3)
;        51bf48:__btemp11  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=4)
;        51d4c8:__btemp12  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=5)
;        51ef48:__btemp13  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=6)
;        51af38:__btemp14  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=7)
;        520818:__btemp15  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=8)
;        522368:__btemp16  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=9)
;        523728:__btemp17  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=10)
;        56fc68:__bitbucket_66  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;      _adc_setup_pins --D-- -U- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        56f528:__bitbucket_67  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_vref_adref ----- --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        56ee58:__bitbucket_68  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _adc_vref_vcfg ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        50f2f8:_vcfg_shadow  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        56c128:__bitbucket_69  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_1s ----- --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        50d268:_n_7  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50d808:__1_s_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 999998
;        50d458:__floop4  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50d638:__btemp_3  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        50e4d8:__btemp6  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        56b7c8:__bitbucket_70  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        50b2f8:_n_5  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50b838:__100_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 99998
;        50b488:__floop3  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50b668:__btemp_2  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        50c598:__btemp5  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        567ec8:__bitbucket_71  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        5091f8:_n_3 word (type=i dflags=----- auto sz=2 use=2 assigned=4 base=0055)
;        5096d8:__one_ms_delay  (type=i dflags=C---U sz=4 use=0 assigned=0)
;         = 998
;        509388:__floop2  (type=i dflags=----- auto sz=2 use=4 assigned=4 base=005b)
;        5093e8:__btemp_1  (type=i dflags=C--B- sz=1 use=0 assigned=0 bit=0)
;         = 0
;        509508:__btemp4  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        564be8:__bitbucket_72  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4fd828:_n_1 byte (type=i dflags=----- auto sz=1 use=4 assigned=2 base=0064)
;        504128:__btemp  (type=i dflags=C--B- sz=3 use=0 assigned=0 bit=0)
;         = 0
;        5041f8:__btemp1  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=0)
;        504b18:__btemp2  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=1)
;        5051d8:__temp_32  (type=? dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        5646b8:__bitbucket_73  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;          5054f8:__ten_us_delay1  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 7
;          --- labels ---
;        {block exit}
;        {block enter}
;          --- records ---
;          --- variables ---
;          506a08:__ten_us_delay2  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 5
;          5074e8:__ten_us_delay3  (type=i dflags=C---U sz=4 use=0 assigned=0)
;           = 9
;          5066e8:__floop1  (type=i dflags=----- auto sz=1 use=2 assigned=2 base=0065)
;          507e48:__btemp3  (type=B dflags=---B- sz=1 use=0 assigned=0 base=0000 bit=2)
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
;        564168:__bitbucket_74  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_8us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        563bd8:__bitbucket_75  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_7us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        563688:__bitbucket_76  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_6us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        562e08:__bitbucket_77  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_5us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        562978:__bitbucket_78  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_4us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        562278:__bitbucket_79  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_3us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5615d8:__bitbucket_80  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_2us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        560a88:__bitbucket_81  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      delay_1us ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        5604a8:__bitbucket_82  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      enable_digital_io ----L --- (frame_sz=0 blocks=4)
;      {block enter}
;        --- records ---
;        --- variables ---
;        524e38:__bitbucket_83  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        547f08:__bitbucket_84  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      adc_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        547b08:__bitbucket_85  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      analog_off ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        533cb8:__bitbucket_86  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e55f8:__temp_31  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        532cb8:__bitbucket_87  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e3c98:_x_89  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4e3fa8:__temp_30  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        531cb8:__bitbucket_88  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e2e68:__temp_29  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        530cb8:__bitbucket_89  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4e13a8:_x_87  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4e1688:__temp_28  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4fda28:__bitbucket_90  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4de5f8:__temp_27  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52eb58:__bitbucket_91  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4dcbf8:_x_85  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4dcf08:__temp_26  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        52dcb8:__bitbucket_92  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4dbd08:__temp_25  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52ccb8:__bitbucket_93  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4da268:_x_83  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4da548:__temp_24  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        52bcb8:__bitbucket_94  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d6d68:__temp_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        52acb8:__bitbucket_95  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d54a8:_x_81  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4d57b8:__temp_22  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        50d358:__bitbucket_96  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d4688:__temp_21  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        50b3b8:__bitbucket_97  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4d2ac8:_x_79  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4d2da8:__temp_20  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4e56d8:__bitbucket_98  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cf498:__temp_19  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4e54c8:__bitbucket_99  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cd9e8:_x_77  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4cdcf8:__temp_18  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4e4688:__bitbucket_100  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_get ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ccbc8:__temp_17  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4e4158:__bitbucket_101  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_direction_put ----L --- (frame_sz=0 blocks=1)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4cb108:_x_75  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4cb3e8:__temp_16  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4e4528:__bitbucket_102  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_e3_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4c0d88:_x_73 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _porte_shadow
;        4e3e78:__bitbucket_103  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4bfb08:__temp_15  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4e2f48:__bitbucket_104  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4bdd28:_x_71  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4be108:__temp_14  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4e2d38:__bitbucket_105  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4bc6b8:__temp_13  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4e1d98:__bitbucket_106  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porte_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4bb2f8:_x_69  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4bb608:__temp_12  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4e1768:__bitbucket_107  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4ba3a8:_x_67  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4e1c38:__bitbucket_108  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4e1558:__bitbucket_109  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_c0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4b8648:_x_65 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portc_shadow+0
;        4de6d8:__bitbucket_110  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b7518:_x_63 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _portc_shadow+0
;        4de4c8:__bitbucket_111  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b64a8:_x_61 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _portc_shadow+0
;        4dd638:__bitbucket_112  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b5448:_x_59 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _portc_shadow+0
;        4dd108:__bitbucket_113  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b43e8:_x_57 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portc_shadow+0
;        4dd4d8:__bitbucket_114  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b33a8:_x_55 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portc_shadow+0
;        4dcdd8:__bitbucket_115  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b23a8:_x_53 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portc_shadow+0
;        4dbde8:__bitbucket_116  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4b1268:_x_51 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portc_shadow+0
;        4dbbd8:__bitbucket_117  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4aff08:__temp_11  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4dac58:__bitbucket_118  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ae188:_x_49  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4ae4c8:__temp_10  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4da628:__bitbucket_119  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4ad338:__temp_9  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4daaf8:__bitbucket_120  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portc_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4ab658:_x_47  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4ab968:__temp_8  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4da418:__bitbucket_121  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4aa718:_x_45  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4d6e48:__bitbucket_122  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4d6c38:__bitbucket_123  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_b0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4a8998:_x_43 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _portb_shadow+0
;        4d5dc8:__bitbucket_124  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a78f8:_x_41 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _portb_shadow+0
;        4d5898:__bitbucket_125  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a6818:_x_39 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _portb_shadow+0
;        4d5c68:__bitbucket_126  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a5738:_x_37 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _portb_shadow+0
;        4d5688:__bitbucket_127  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a4518:_x_35 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _portb_shadow+0
;        4d4768:__bitbucket_128  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a34a8:_x_33 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _portb_shadow+0
;        4d4558:__bitbucket_129  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a2448:_x_31 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _portb_shadow+0
;        4d35f8:__bitbucket_130  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a1518:_x_29 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _portb_shadow+0
;        4d2e88:__bitbucket_131  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4a03a8:__temp_7  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4d3498:__bitbucket_132  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        49e8f8:_x_27  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        49ec38:__temp_6  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4d2c78:__bitbucket_133  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49db08:__temp_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4cf578:__bitbucket_134  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _portb_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        49be98:_x_25  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        49c108:__temp_4  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4cf368:__bitbucket_135  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        49af18:_x_23  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4ce4f8:__bitbucket_136  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4cddd8:__bitbucket_137  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _pin_a0_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        4992f8:_x_21 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=0) ---> _porta_shadow+0
;        4ce398:__bitbucket_138  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        498108:_x_19 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=1) ---> _porta_shadow+0
;        4cdbc8:__bitbucket_139  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        496fa8:_x_17 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=2) ---> _porta_shadow+0
;        4ccca8:__bitbucket_140  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        495c18:_x_15 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=3) ---> _porta_shadow+0
;        4cca98:__bitbucket_141  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        494998:_x_13 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=4) ---> _porta_shadow+0
;        4cbaf8:__bitbucket_142  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4938f8:_x_11 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=5) ---> _porta_shadow+0
;        4cb4c8:__bitbucket_143  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_a6_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        492738:_x_9 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=6) ---> _porta_shadow+0
;        4cb998:__bitbucket_144  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;        {block enter}
;          --- records ---
;          --- variables ---
;          --- labels ---
;        {block exit}
;      {block exit}
;      _pin_a7_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        491648:_x_7 bit (type=B dflags=---B- sz=1 use=0 assigned=0 bit=7) ---> _porta_shadow+0
;        4cb2b8:__bitbucket_145  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        490338:__temp_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4bfbe8:__bitbucket_146  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_high_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        48e8f8:_x_5  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        48ec38:__temp_2  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4bfa08:__bitbucket_147  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        48db08:__temp_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4be718:__bitbucket_148  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
;      _porta_low_put ----L --- (frame_sz=0 blocks=2)
;      {block enter}
;        --- records ---
;        --- variables ---
;        48bde8:_x_3  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        48c108:__temp  (type=i dflags=C---- sz=2 use=0 assigned=0)
;         = 0
;        4be1e8:__bitbucket_149  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        48aea8:_x_1  (type=i dflags=C---- sz=1 use=0 assigned=0)
;         = 0
;        4be5b8:__bitbucket_150  (type=i dflags=C---- sz=0 use=0 assigned=0)
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
;        4bdf68:__bitbucket_151  (type=i dflags=C---- sz=0 use=0 assigned=0)
;         = 0
;        --- labels ---
;      {block exit}
; --- call stack ---
; {root} (depth=0)
;   adc_read_low_res (depth=1)
;     _adc_read_low_res (depth=2)
;       delay_10us (depth=3)
;   lcd_num (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     serial_hw_write (depth=2)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     serial_hw_write (depth=2)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     serial_hw_write (depth=2)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;   adc_read (depth=1)
;     _adc_read_low_res (depth=2)
;       delay_10us (depth=3)
;   lcd_line (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;   lcd_line (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;   serial_hw_printf (depth=1)
;     serial_hw_write (depth=2)
;   lcd_print (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     serial_hw_write (depth=2)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;   lcd_clearscreen (depth=1)
;     lcd_fill (depth=2)
;       _ks0108_write (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_data (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_inst (depth=3)
;   delay_1ms (depth=1)
;   lcd_line (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;   lcd_line (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;   lcd_line (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;   lcd_line (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;   lcd_filled_rect (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     ks0108_write_byte (depth=2)
;       _ks0108_write (depth=3)
;       _ks0108_data (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_inst (depth=3)
;   lcd_filled_rect (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     ks0108_write_byte (depth=2)
;       _ks0108_write (depth=3)
;       _ks0108_data (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_inst (depth=3)
;   lcd_filled_rect (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     ks0108_write_byte (depth=2)
;       _ks0108_write (depth=3)
;       _ks0108_data (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_inst (depth=3)
;   lcd_filled_rect (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_read (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     ks0108_write_byte (depth=2)
;       _ks0108_write (depth=3)
;       _ks0108_data (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_write (depth=3)
;       _ks0108_inst (depth=3)
;   lcd_print (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     serial_hw_write (depth=2)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;   lcd_print (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     serial_hw_write (depth=2)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;   lcd_print (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     serial_hw_write (depth=2)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;   lcd_print (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     serial_hw_write (depth=2)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;   lcd_print (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     serial_hw_write (depth=2)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;   lcd_print (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;     serial_hw_write (depth=2)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;     serial_hw_byte (depth=2)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;       serial_hw_write (depth=3)
;   lcd_fill (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_data (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;     _ks0108_inst (depth=2)
;   lcd_on (depth=1)
;     _ks0108_write (depth=2)
;     _ks0108_write (depth=2)
;   _ks0108_write (depth=1)
;   _ks0108_write (depth=1)
;   _ks0108_write (depth=1)
;   _ks0108_write (depth=1)
;   _ks0108_write (depth=1)
;   _ks0108_write (depth=1)
;   _ks0108_inst (depth=1)
;   delay_1ms (depth=1)
;   pwm1_set_dutycycle (depth=1)
;     pwm1_set_dutycycle_highres (depth=2)
;       pwm1_on (depth=3)
;   serial_hw_printf (depth=1)
;     serial_hw_write (depth=2)
;   serial_hw_printf (depth=1)
;     serial_hw_write (depth=2)
;   serial_hw_init (depth=1)
;     _calculate_and_set_baudrate (depth=2)
;   pwm1_on (depth=1)
;   pwm_max_resolution (depth=1)
;   set_analog_pin (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_eval_tad (depth=1)
;   _adc_setup_pins (depth=1)
;Temporary Labels
;489f88:_l1(use=0:ref=2:pc=0000)
;4891d8:_l2(use=0:ref=2:pc=0000)
;48ab68:_l3(use=0:ref=2:pc=0000)
;48abc8:_l4(use=0:ref=2:pc=0000)
;48b5a8:_l5(use=0:ref=1:pc=0000)
;48baa8:_l6(use=0:ref=2:pc=0000)
;48bb08:_l7(use=0:ref=2:pc=0000)
;48d218:_l8(use=0:ref=1:pc=0000)
;48d678:_l9(use=0:ref=2:pc=0000)
;48d6d8:_l10(use=0:ref=2:pc=0000)
;48e5b8:_l11(use=0:ref=2:pc=0000)
;48e618:_l12(use=0:ref=2:pc=0000)
;48fde8:_l13(use=0:ref=1:pc=0000)
;462928:_l14(use=0:ref=2:pc=0000)
;462c08:_l15(use=0:ref=2:pc=0000)
;491308:_l16(use=0:ref=2:pc=0000)
;491368:_l17(use=0:ref=2:pc=0000)
;491a38:_l18(use=0:ref=1:pc=0000)
;4923f8:_l19(use=0:ref=2:pc=0000)
;492458:_l20(use=0:ref=2:pc=0000)
;492b28:_l21(use=0:ref=1:pc=0000)
;4935b8:_l22(use=0:ref=2:pc=0000)
;493618:_l23(use=0:ref=2:pc=0000)
;493ce8:_l24(use=0:ref=1:pc=0000)
;494658:_l25(use=0:ref=2:pc=0000)
;4946b8:_l26(use=0:ref=2:pc=0000)
;494d88:_l27(use=0:ref=1:pc=0000)
;4958d8:_l28(use=0:ref=2:pc=0000)
;495938:_l29(use=0:ref=2:pc=0000)
;4951a8:_l30(use=0:ref=1:pc=0000)
;496c68:_l31(use=0:ref=2:pc=0000)
;496cc8:_l32(use=0:ref=2:pc=0000)
;497368:_l33(use=0:ref=1:pc=0000)
;497d48:_l34(use=0:ref=2:pc=0000)
;497da8:_l35(use=0:ref=2:pc=0000)
;4984f8:_l36(use=0:ref=1:pc=0000)
;498fb8:_l37(use=0:ref=2:pc=0000)
;498208:_l38(use=0:ref=2:pc=0000)
;4996e8:_l39(use=0:ref=1:pc=0000)
;499668:_l40(use=0:ref=2:pc=0000)
;499a78:_l41(use=0:ref=2:pc=0000)
;49abd8:_l42(use=0:ref=2:pc=0000)
;49ac38:_l43(use=0:ref=2:pc=0000)
;49b658:_l44(use=0:ref=1:pc=0000)
;49bb58:_l45(use=0:ref=2:pc=0000)
;49bbb8:_l46(use=0:ref=2:pc=0000)
;49d218:_l47(use=0:ref=1:pc=0000)
;49d678:_l48(use=0:ref=2:pc=0000)
;49d6d8:_l49(use=0:ref=2:pc=0000)
;49e5b8:_l50(use=0:ref=2:pc=0000)
;49e618:_l51(use=0:ref=2:pc=0000)
;49fde8:_l52(use=0:ref=1:pc=0000)
;495808:_l53(use=0:ref=2:pc=0000)
;495d18:_l54(use=0:ref=2:pc=0000)
;4a11d8:_l55(use=0:ref=2:pc=0000)
;4a1238:_l56(use=0:ref=2:pc=0000)
;4a1908:_l57(use=0:ref=1:pc=0000)
;4a2108:_l58(use=0:ref=2:pc=0000)
;4a2168:_l59(use=0:ref=2:pc=0000)
;4a2838:_l60(use=0:ref=1:pc=0000)
;4a3168:_l61(use=0:ref=2:pc=0000)
;4a31c8:_l62(use=0:ref=2:pc=0000)
;4a3898:_l63(use=0:ref=1:pc=0000)
;4a41d8:_l64(use=0:ref=2:pc=0000)
;4a4238:_l65(use=0:ref=2:pc=0000)
;4a4908:_l66(use=0:ref=1:pc=0000)
;4a53f8:_l67(use=0:ref=2:pc=0000)
;4a5458:_l68(use=0:ref=2:pc=0000)
;4a5b28:_l69(use=0:ref=1:pc=0000)
;4a64d8:_l70(use=0:ref=2:pc=0000)
;4a6538:_l71(use=0:ref=2:pc=0000)
;4a6c08:_l72(use=0:ref=1:pc=0000)
;4a75b8:_l73(use=0:ref=2:pc=0000)
;4a7618:_l74(use=0:ref=2:pc=0000)
;4a7ce8:_l75(use=0:ref=1:pc=0000)
;4a8658:_l76(use=0:ref=2:pc=0000)
;4a86b8:_l77(use=0:ref=2:pc=0000)
;4a8d88:_l78(use=0:ref=1:pc=0000)
;4a9748:_l79(use=0:ref=2:pc=0000)
;4a97a8:_l80(use=0:ref=2:pc=0000)
;4aa3d8:_l81(use=0:ref=2:pc=0000)
;4aa438:_l82(use=0:ref=2:pc=0000)
;4aadf8:_l83(use=0:ref=1:pc=0000)
;4ab318:_l84(use=0:ref=2:pc=0000)
;4ab378:_l85(use=0:ref=2:pc=0000)
;4aca28:_l86(use=0:ref=1:pc=0000)
;4ace88:_l87(use=0:ref=2:pc=0000)
;4acee8:_l88(use=0:ref=2:pc=0000)
;4adcf8:_l89(use=0:ref=2:pc=0000)
;4add58:_l90(use=0:ref=2:pc=0000)
;4af618:_l91(use=0:ref=1:pc=0000)
;4afa78:_l92(use=0:ref=2:pc=0000)
;4afad8:_l93(use=0:ref=2:pc=0000)
;4b0e28:_l94(use=0:ref=2:pc=0000)
;4b0e88:_l95(use=0:ref=2:pc=0000)
;4b1658:_l96(use=0:ref=1:pc=0000)
;4b15b8:_l97(use=0:ref=2:pc=0000)
;4b19e8:_l98(use=0:ref=2:pc=0000)
;4b2798:_l99(use=0:ref=1:pc=0000)
;4b2718:_l100(use=0:ref=2:pc=0000)
;4b2b28:_l101(use=0:ref=2:pc=0000)
;4b3798:_l102(use=0:ref=1:pc=0000)
;4b3438:_l103(use=0:ref=2:pc=0000)
;4b4108:_l104(use=0:ref=2:pc=0000)
;4b47d8:_l105(use=0:ref=1:pc=0000)
;4b5108:_l106(use=0:ref=2:pc=0000)
;4b5168:_l107(use=0:ref=2:pc=0000)
;4b5838:_l108(use=0:ref=1:pc=0000)
;4b6168:_l109(use=0:ref=2:pc=0000)
;4b61c8:_l110(use=0:ref=2:pc=0000)
;4b6898:_l111(use=0:ref=1:pc=0000)
;4b71d8:_l112(use=0:ref=2:pc=0000)
;4b7238:_l113(use=0:ref=2:pc=0000)
;4b7908:_l114(use=0:ref=1:pc=0000)
;4b8308:_l115(use=0:ref=2:pc=0000)
;4b8368:_l116(use=0:ref=2:pc=0000)
;4b8a38:_l117(use=0:ref=1:pc=0000)
;4b9448:_l118(use=0:ref=2:pc=0000)
;4b94a8:_l119(use=0:ref=2:pc=0000)
;4b9fb8:_l120(use=0:ref=2:pc=0000)
;4b9828:_l121(use=0:ref=2:pc=0000)
;4baa88:_l122(use=0:ref=1:pc=0000)
;4baf88:_l123(use=0:ref=2:pc=0000)
;4ba438:_l124(use=0:ref=2:pc=0000)
;4bc758:_l125(use=0:ref=1:pc=0000)
;4bcbb8:_l126(use=0:ref=2:pc=0000)
;4bcc18:_l127(use=0:ref=2:pc=0000)
;4bd9e8:_l128(use=0:ref=2:pc=0000)
;4bda48:_l129(use=0:ref=2:pc=0000)
;4bf218:_l130(use=0:ref=1:pc=0000)
;4bf678:_l131(use=0:ref=2:pc=0000)
;4bf6d8:_l132(use=0:ref=2:pc=0000)
;4c0a48:_l133(use=0:ref=2:pc=0000)
;4c0aa8:_l134(use=0:ref=2:pc=0000)
;4c1288:_l135(use=0:ref=1:pc=0000)
;4cacd8:_l136(use=0:ref=2:pc=0000)
;4cad38:_l137(use=0:ref=2:pc=0000)
;4cc738:_l138(use=0:ref=2:pc=0000)
;4cc798:_l139(use=0:ref=2:pc=0000)
;4cd6a8:_l140(use=0:ref=2:pc=0000)
;4cd708:_l141(use=0:ref=2:pc=0000)
;4cef08:_l142(use=0:ref=2:pc=0000)
;4cef68:_l143(use=0:ref=2:pc=0000)
;4d2788:_l144(use=0:ref=2:pc=0000)
;4d27e8:_l145(use=0:ref=2:pc=0000)
;4d41f8:_l146(use=0:ref=2:pc=0000)
;4d4258:_l147(use=0:ref=2:pc=0000)
;4d5168:_l148(use=0:ref=2:pc=0000)
;4d51c8:_l149(use=0:ref=2:pc=0000)
;4d68d8:_l150(use=0:ref=2:pc=0000)
;4d6938:_l151(use=0:ref=2:pc=0000)
;4d9f28:_l152(use=0:ref=2:pc=0000)
;4d9f88:_l153(use=0:ref=2:pc=0000)
;4db878:_l154(use=0:ref=2:pc=0000)
;4db8d8:_l155(use=0:ref=2:pc=0000)
;4dc8b8:_l156(use=0:ref=2:pc=0000)
;4dc918:_l157(use=0:ref=2:pc=0000)
;4de168:_l158(use=0:ref=2:pc=0000)
;4de1c8:_l159(use=0:ref=2:pc=0000)
;4e0da8:_l160(use=0:ref=2:pc=0000)
;4e0f58:_l161(use=0:ref=2:pc=0000)
;4e29d8:_l162(use=0:ref=2:pc=0000)
;4e2a38:_l163(use=0:ref=2:pc=0000)
;4e3958:_l164(use=0:ref=2:pc=0000)
;4e39b8:_l165(use=0:ref=2:pc=0000)
;4e5168:_l166(use=0:ref=2:pc=0000)
;4e51c8:_l167(use=0:ref=2:pc=0000)
;4f4a18:_l168(use=0:ref=2:pc=0000)
;4f4a78:_l169(use=0:ref=2:pc=0000)
;4f59c8:_l170(use=0:ref=2:pc=0000)
;4f5a28:_l171(use=0:ref=2:pc=0000)
;4f69d8:_l172(use=0:ref=2:pc=0000)
;4f6a38:_l173(use=0:ref=2:pc=0000)
;4f79e8:_l174(use=0:ref=2:pc=0000)
;4f7a48:_l175(use=0:ref=2:pc=0000)
;4f8288:_l176(use=0:ref=1:pc=0000)
;4f8798:_l177(use=0:ref=1:pc=0000)
;4f8cc8:_l178(use=0:ref=1:pc=0000)
;4fa638:_l179(use=0:ref=1:pc=0000)
;4faa58:_l180(use=0:ref=1:pc=0000)
;4fae78:_l181(use=0:ref=1:pc=0000)
;4fb108:_l182(use=0:ref=1:pc=0000)
;4ff968:_l183(use=0:ref=2:pc=0000)
;4ff9c8:_l184(use=0:ref=2:pc=0000)
;4ff4c8:_l185(use=0:ref=2:pc=0000)
;4ffc68:_l186(use=0:ref=2:pc=0000)
;500408:_l187(use=0:ref=2:pc=0000)
;500468:_l188(use=0:ref=2:pc=0000)
;500b48:_l189(use=0:ref=2:pc=0000)
;500ba8:_l190(use=0:ref=2:pc=0000)
;501398:_l191(use=0:ref=2:pc=0000)
;5013f8:_l192(use=0:ref=2:pc=0000)
;501ad8:_l193(use=0:ref=2:pc=0000)
;501b38:_l194(use=0:ref=2:pc=0000)
;502328:_l195(use=0:ref=2:pc=0000)
;502388:_l196(use=0:ref=2:pc=0000)
;502a68:_l197(use=0:ref=2:pc=0000)
;502ac8:_l198(use=0:ref=2:pc=0000)
;5032b8:_l199(use=0:ref=2:pc=0000)
;503318:_l200(use=0:ref=2:pc=0000)
;503cf8:_l201(use=0:ref=2:pc=0000)
;503d58:_l202(use=6:ref=4:pc=030c)
;5035b8:_l203(use=6:ref=3:pc=030c)
;504638:_l204(use=7:ref=3:pc=02e4)
;504e58:_l205(use=7:ref=3:pc=02f1)
;5056e8:_l206(use=0:ref=1:pc=0000)
;5058a8:_l207(use=0:ref=1:pc=0000)
;506bf8:_l208(use=0:ref=1:pc=0000)
;506db8:_l209(use=0:ref=1:pc=0000)
;507a48:_l210(use=7:ref=3:pc=02fe)
;507aa8:_l211(use=7:ref=3:pc=0308)
;507b08:_l212(use=0:ref=1:pc=0000)
;507cf8:_l213(use=0:ref=1:pc=0000)
;507f18:_l214(use=0:ref=1:pc=0000)
;508db8:_l215(use=0:ref=2:pc=0000)
;508e18:_l216(use=0:ref=2:pc=0000)
;509c38:_l217(use=7:ref=3:pc=0310)
;509c98:_l218(use=7:ref=3:pc=0322)
;509cf8:_l219(use=0:ref=1:pc=0000)
;509ee8:_l220(use=0:ref=1:pc=0000)
;509738:_l221(use=0:ref=1:pc=0000)
;50ae98:_l222(use=0:ref=2:pc=0000)
;50aef8:_l223(use=0:ref=2:pc=0000)
;50bd98:_l224(use=0:ref=1:pc=0000)
;50bdf8:_l225(use=0:ref=1:pc=0000)
;50be58:_l226(use=0:ref=1:pc=0000)
;50cdd8:_l227(use=0:ref=2:pc=0000)
;50ce38:_l228(use=0:ref=2:pc=0000)
;50dd68:_l229(use=0:ref=1:pc=0000)
;50ddc8:_l230(use=0:ref=1:pc=0000)
;50de28:_l231(use=0:ref=1:pc=0000)
;50ee38:_l232(use=0:ref=2:pc=0000)
;50ee98:_l233(use=0:ref=2:pc=0000)
;50f6b8:_l234(use=0:ref=1:pc=0000)
;50fa58:_l235(use=0:ref=1:pc=0000)
;50fca8:_l236(use=0:ref=1:pc=0000)
;50f7d8:_l237(use=0:ref=1:pc=0000)
;510538:_l238(use=0:ref=1:pc=0000)
;510598:_l239(use=0:ref=1:pc=0000)
;510be8:_l240(use=4:ref=4:pc=032b)
;510cf8:_l241(use=0:ref=2:pc=0000)
;511368:_l242(use=0:ref=1:pc=0000)
;511898:_l243(use=0:ref=1:pc=0000)
;516248:_l244(use=0:ref=2:pc=0000)
;5162a8:_l245(use=0:ref=2:pc=0000)
;516928:_l246(use=0:ref=2:pc=0000)
;516988:_l247(use=0:ref=2:pc=0000)
;516c58:_l248(use=7:ref=3:pc=0335)
;516ec8:_l249(use=0:ref=1:pc=0000)
;516f28:_l250(use=0:ref=1:pc=0000)
;517548:_l251(use=0:ref=1:pc=0000)
;5182e8:_l252(use=7:ref=3:pc=033f)
;5185b8:_l253(use=0:ref=1:pc=0000)
;518618:_l254(use=0:ref=1:pc=0000)
;518a38:_l255(use=0:ref=1:pc=0000)
;5196a8:_l256(use=7:ref=3:pc=0349)
;519978:_l257(use=0:ref=1:pc=0000)
;5199d8:_l258(use=0:ref=1:pc=0000)
;519df8:_l259(use=0:ref=1:pc=0000)
;51aa08:_l260(use=7:ref=3:pc=0353)
;51acd8:_l261(use=0:ref=1:pc=0000)
;51ad38:_l262(use=0:ref=1:pc=0000)
;51b328:_l263(use=0:ref=1:pc=0000)
;51bec8:_l264(use=7:ref=3:pc=035d)
;51c1f8:_l265(use=0:ref=1:pc=0000)
;51c258:_l266(use=0:ref=1:pc=0000)
;51c678:_l267(use=0:ref=1:pc=0000)
;51d2e8:_l268(use=0:ref=1:pc=0000)
;51d698:_l269(use=0:ref=1:pc=0000)
;51d928:_l270(use=0:ref=1:pc=0000)
;51dbb8:_l271(use=7:ref=3:pc=0366)
;51dd68:_l272(use=0:ref=1:pc=0000)
;51ddc8:_l273(use=0:ref=1:pc=0000)
;51e328:_l274(use=0:ref=1:pc=0000)
;51eec8:_l275(use=7:ref=3:pc=0370)
;51f1f8:_l276(use=0:ref=1:pc=0000)
;51f258:_l277(use=0:ref=1:pc=0000)
;51f678:_l278(use=0:ref=1:pc=0000)
;518fb8:_l279(use=7:ref=3:pc=037a)
;51d7e8:_l280(use=0:ref=1:pc=0000)
;51d9c8:_l281(use=0:ref=1:pc=0000)
;520398:_l282(use=0:ref=1:pc=0000)
;520f38:_l283(use=7:ref=3:pc=0384)
;5211f8:_l284(use=0:ref=1:pc=0000)
;521258:_l285(use=0:ref=1:pc=0000)
;521678:_l286(use=0:ref=1:pc=0000)
;5222e8:_l287(use=7:ref=3:pc=038e)
;5225b8:_l288(use=0:ref=1:pc=0000)
;522618:_l289(use=0:ref=1:pc=0000)
;522a38:_l290(use=0:ref=1:pc=0000)
;5236a8:_l291(use=7:ref=3:pc=0398)
;523978:_l292(use=0:ref=1:pc=0000)
;5239d8:_l293(use=0:ref=1:pc=0000)
;523df8:_l294(use=0:ref=1:pc=0000)
;524a08:_l295(use=0:ref=1:pc=0000)
;524db8:_l296(use=0:ref=1:pc=0000)
;524ae8:_l297(use=0:ref=1:pc=0000)
;525208:_l298(use=0:ref=1:pc=0000)
;525498:_l299(use=0:ref=1:pc=0000)
;525728:_l300(use=0:ref=1:pc=0000)
;5259b8:_l301(use=0:ref=1:pc=0000)
;525c48:_l302(use=0:ref=1:pc=0000)
;525ed8:_l303(use=0:ref=1:pc=0000)
;525a38:_l304(use=0:ref=1:pc=0000)
;526198:_l305(use=0:ref=1:pc=0000)
;526428:_l306(use=0:ref=1:pc=0000)
;5266b8:_l307(use=0:ref=1:pc=0000)
;526948:_l308(use=0:ref=1:pc=0000)
;526bd8:_l309(use=0:ref=1:pc=0000)
;5294d8:_l310(use=0:ref=2:pc=0000)
;529538:_l311(use=0:ref=2:pc=0000)
;529808:_l312(use=0:ref=1:pc=0000)
;529a18:_l313(use=0:ref=1:pc=0000)
;529a78:_l314(use=0:ref=1:pc=0000)
;52a228:_l315(use=0:ref=1:pc=0000)
;52aad8:_l316(use=0:ref=1:pc=0000)
;52ada8:_l317(use=0:ref=1:pc=0000)
;52ae08:_l318(use=0:ref=1:pc=0000)
;52b328:_l319(use=0:ref=1:pc=0000)
;52bad8:_l320(use=0:ref=1:pc=0000)
;52bda8:_l321(use=0:ref=1:pc=0000)
;52be08:_l322(use=0:ref=1:pc=0000)
;52c328:_l323(use=0:ref=1:pc=0000)
;52cad8:_l324(use=0:ref=1:pc=0000)
;52cda8:_l325(use=0:ref=1:pc=0000)
;52ce08:_l326(use=0:ref=1:pc=0000)
;52d328:_l327(use=0:ref=1:pc=0000)
;52dad8:_l328(use=0:ref=1:pc=0000)
;52dda8:_l329(use=0:ref=1:pc=0000)
;52de08:_l330(use=0:ref=1:pc=0000)
;52e328:_l331(use=0:ref=1:pc=0000)
;52ead8:_l332(use=0:ref=1:pc=0000)
;52ee88:_l333(use=0:ref=1:pc=0000)
;52e488:_l334(use=0:ref=1:pc=0000)
;52f278:_l335(use=0:ref=1:pc=0000)
;52f428:_l336(use=0:ref=1:pc=0000)
;52f488:_l337(use=0:ref=1:pc=0000)
;52f8a8:_l338(use=0:ref=1:pc=0000)
;52f4c8:_l339(use=0:ref=1:pc=0000)
;4fdbc8:_l340(use=0:ref=1:pc=0000)
;4fdc88:_l341(use=0:ref=1:pc=0000)
;530328:_l342(use=0:ref=1:pc=0000)
;530ad8:_l343(use=0:ref=1:pc=0000)
;530da8:_l344(use=0:ref=1:pc=0000)
;530e08:_l345(use=0:ref=1:pc=0000)
;531328:_l346(use=0:ref=1:pc=0000)
;531ad8:_l347(use=0:ref=1:pc=0000)
;531da8:_l348(use=0:ref=1:pc=0000)
;531e08:_l349(use=0:ref=1:pc=0000)
;532328:_l350(use=0:ref=1:pc=0000)
;532ad8:_l351(use=0:ref=1:pc=0000)
;532da8:_l352(use=0:ref=1:pc=0000)
;532e08:_l353(use=0:ref=1:pc=0000)
;533328:_l354(use=0:ref=1:pc=0000)
;533ad8:_l355(use=0:ref=1:pc=0000)
;533da8:_l356(use=0:ref=1:pc=0000)
;533e08:_l357(use=0:ref=1:pc=0000)
;534328:_l358(use=0:ref=1:pc=0000)
;534ad8:_l359(use=0:ref=1:pc=0000)
;534e88:_l360(use=0:ref=1:pc=0000)
;534488:_l361(use=0:ref=1:pc=0000)
;535278:_l362(use=0:ref=1:pc=0000)
;535508:_l363(use=0:ref=1:pc=0000)
;535798:_l364(use=0:ref=1:pc=0000)
;535a28:_l365(use=0:ref=1:pc=0000)
;535cb8:_l366(use=0:ref=1:pc=0000)
;535f48:_l367(use=0:ref=1:pc=0000)
;535aa8:_l368(use=0:ref=1:pc=0000)
;536208:_l369(use=0:ref=1:pc=0000)
;536498:_l370(use=0:ref=1:pc=0000)
;536728:_l371(use=0:ref=1:pc=0000)
;5369b8:_l372(use=0:ref=1:pc=0000)
;536e88:_l373(use=0:ref=1:pc=0000)
;5367a8:_l374(use=0:ref=1:pc=0000)
;537228:_l375(use=0:ref=1:pc=0000)
;537968:_l376(use=0:ref=1:pc=0000)
;537b78:_l377(use=0:ref=1:pc=0000)
;537eb8:_l378(use=0:ref=1:pc=0000)
;5379e8:_l379(use=0:ref=1:pc=0000)
;5384b8:_l380(use=0:ref=2:pc=0000)
;538518:_l381(use=0:ref=2:pc=0000)
;539bd8:_l382(use=0:ref=1:pc=0000)
;53ac48:_l383(use=7:ref=3:pc=03c9)
;53b758:_l384(use=0:ref=2:pc=0000)
;53b7b8:_l385(use=0:ref=2:pc=0000)
;53ba58:_l386(use=0:ref=1:pc=0000)
;53bd58:_l387(use=0:ref=1:pc=0000)
;53be58:_l388(use=0:ref=1:pc=0000)
;53c4d8:_l389(use=0:ref=1:pc=0000)
;53c828:_l390(use=0:ref=1:pc=0000)
;53cab8:_l391(use=0:ref=1:pc=0000)
;53d398:_l392(use=0:ref=1:pc=0000)
;53d6b8:_l393(use=0:ref=1:pc=0000)
;53dda8:_l394(use=0:ref=1:pc=0000)
;53ec38:_l395(use=0:ref=1:pc=0000)
;53fae8:_l396(use=0:ref=1:pc=0000)
;52d4f8:_l397(use=0:ref=1:pc=0000)
;540738:_l398(use=0:ref=1:pc=0000)
;540a28:_l399(use=10:ref=3:pc=03cd)
;540bd8:_l400(use=0:ref=1:pc=0000)
;540f18:_l401(use=0:ref=1:pc=0000)
;541208:_l402(use=0:ref=1:pc=0000)
;541c78:_l403(use=0:ref=2:pc=0000)
;541cd8:_l404(use=0:ref=2:pc=0000)
;542de8:_l405(use=7:ref=3:pc=03e0)
;542e48:_l406(use=7:ref=3:pc=03e4)
;542ea8:_l407(use=0:ref=1:pc=0000)
;543358:_l408(use=0:ref=1:pc=0000)
;543658:_l409(use=0:ref=1:pc=0000)
;543bd8:_l410(use=7:ref=3:pc=0400)
;544398:_l411(use=7:ref=3:pc=03f6)
;545108:_l412(use=0:ref=2:pc=0000)
;545168:_l413(use=0:ref=2:pc=0000)
;545658:_l414(use=0:ref=1:pc=0000)
;545708:_l415(use=0:ref=1:pc=0000)
;546a48:_l416(use=0:ref=2:pc=0000)
;546aa8:_l417(use=0:ref=2:pc=0000)
;548708:_l418(use=0:ref=2:pc=0000)
;548768:_l419(use=0:ref=2:pc=0000)
;548af8:_l420(use=0:ref=1:pc=0000)
;54ace8:_l421(use=0:ref=2:pc=0000)
;54ad48:_l422(use=0:ref=2:pc=0000)
;54a278:_l423(use=0:ref=1:pc=0000)
;54b518:_l424(use=0:ref=1:pc=0000)
;54b928:_l425(use=0:ref=1:pc=0000)
;54baa8:_l426(use=0:ref=1:pc=0000)
;54c2d8:_l427(use=0:ref=2:pc=0000)
;54c338:_l428(use=0:ref=2:pc=0000)
;54c5d8:_l429(use=0:ref=1:pc=0000)
;54cf58:_l430(use=0:ref=1:pc=0000)
;54d9f8:_l431(use=0:ref=2:pc=0000)
;54da58:_l432(use=0:ref=2:pc=0000)
;54e218:_l433(use=0:ref=1:pc=0000)
;54e358:_l434(use=0:ref=1:pc=0000)
;54e5e8:_l435(use=0:ref=1:pc=0000)
;54e6b8:_l436(use=0:ref=1:pc=0000)
;54e868:_l437(use=0:ref=1:pc=0000)
;54e938:_l438(use=0:ref=1:pc=0000)
;54ea78:_l439(use=0:ref=1:pc=0000)
;54f168:_l440(use=0:ref=2:pc=0000)
;54f1c8:_l441(use=0:ref=2:pc=0000)
;54f4c8:_l442(use=0:ref=1:pc=0000)
;54f798:_l443(use=0:ref=1:pc=0000)
;54ff38:_l444(use=0:ref=1:pc=0000)
;54f9a8:_l445(use=0:ref=1:pc=0000)
;53cfa8:_l446(use=0:ref=1:pc=0000)
;53c8a8:_l447(use=0:ref=1:pc=0000)
;549308:_l448(use=0:ref=1:pc=0000)
;54dcd8:_l449(use=0:ref=1:pc=0000)
;550208:_l450(use=0:ref=1:pc=0000)
;5503b8:_l451(use=0:ref=1:pc=0000)
;5509d8:_l452(use=0:ref=1:pc=0000)
;550aa8:_l453(use=0:ref=1:pc=0000)
;550d38:_l454(use=0:ref=1:pc=0000)
;550e08:_l455(use=0:ref=1:pc=0000)
;550f48:_l456(use=0:ref=1:pc=0000)
;5519e8:_l457(use=0:ref=1:pc=0000)
;551b98:_l458(use=0:ref=1:pc=0000)
;551c68:_l459(use=0:ref=1:pc=0000)
;551da8:_l460(use=0:ref=1:pc=0000)
;551ee8:_l461(use=0:ref=1:pc=0000)
;552128:_l462(use=0:ref=1:pc=0000)
;552718:_l463(use=0:ref=1:pc=0000)
;552bb8:_l464(use=0:ref=1:pc=0000)
;553198:_l465(use=0:ref=1:pc=0000)
;553268:_l466(use=0:ref=1:pc=0000)
;5533a8:_l467(use=0:ref=1:pc=0000)
;5535c8:_l468(use=0:ref=1:pc=0000)
;553708:_l469(use=0:ref=1:pc=0000)
;554648:_l470(use=0:ref=1:pc=0000)
;554788:_l471(use=0:ref=1:pc=0000)
;5549a8:_l472(use=0:ref=1:pc=0000)
;5545a8:_l473(use=0:ref=1:pc=0000)
;555198:_l474(use=7:ref=3:pc=0428)
;555718:_l475(use=0:ref=1:pc=0000)
;555858:_l476(use=0:ref=1:pc=0000)
;555ae8:_l477(use=0:ref=1:pc=0000)
;555bb8:_l478(use=0:ref=1:pc=0000)
;555d68:_l479(use=0:ref=1:pc=0000)
;555e38:_l480(use=0:ref=1:pc=0000)
;555f78:_l481(use=0:ref=1:pc=0000)
;556278:_l482(use=0:ref=1:pc=0000)
;5565d8:_l483(use=0:ref=1:pc=0000)
;5566a8:_l484(use=0:ref=1:pc=0000)
;556938:_l485(use=0:ref=1:pc=0000)
;556a08:_l486(use=0:ref=1:pc=0000)
;556b48:_l487(use=0:ref=1:pc=0000)
;557588:_l488(use=0:ref=1:pc=0000)
;557838:_l489(use=0:ref=1:pc=0000)
;557908:_l490(use=0:ref=1:pc=0000)
;557a48:_l491(use=0:ref=1:pc=0000)
;557b88:_l492(use=0:ref=1:pc=0000)
;557cc8:_l493(use=0:ref=1:pc=0000)
;5583c8:_l494(use=7:ref=3:pc=044d)
;558868:_l495(use=7:ref=3:pc=0460)
;558d08:_l496(use=7:ref=3:pc=0470)
;558dd8:_l497(use=14:ref=4:pc=0470)
;558f18:_l498(use=0:ref=1:pc=0000)
;559278:_l499(use=0:ref=1:pc=0000)
;5593b8:_l500(use=0:ref=1:pc=0000)
;559618:_l501(use=0:ref=1:pc=0000)
;559758:_l502(use=0:ref=1:pc=0000)
;559978:_l503(use=0:ref=1:pc=0000)
;559b28:_l504(use=0:ref=1:pc=0000)
;55bc68:_l505(use=0:ref=2:pc=0000)
;55bcc8:_l506(use=0:ref=2:pc=0000)
;55cf38:_l507(use=18:ref=5:pc=04bb)
;55d748:_l508(use=7:ref=3:pc=04a6)
;55e738:_l509(use=7:ref=3:pc=04b0)
;55f478:_l510(use=7:ref=3:pc=04ba)
;5545e8:_l511(use=7:ref=4:pc=04bc)
;554d98:_l512(use=0:ref=2:pc=0000)
;560e68:_l513(use=0:ref=1:pc=0000)
;561f38:_l514(use=0:ref=1:pc=0000)
;562198:_l515(use=0:ref=1:pc=0000)
;562718:_l516(use=0:ref=1:pc=0000)
;5633a8:_l517(use=0:ref=1:pc=0000)
;5656f8:_l518(use=7:ref=3:pc=04ff)
;565978:_l519(use=0:ref=1:pc=0000)
;566898:_l520(use=0:ref=2:pc=0000)
;5668f8:_l521(use=0:ref=2:pc=0000)
;567ab8:_l522(use=0:ref=2:pc=0000)
;567b18:_l523(use=0:ref=2:pc=0000)
;5688c8:_l524(use=0:ref=2:pc=0000)
;568928:_l525(use=0:ref=2:pc=0000)
;568cb8:_l526(use=0:ref=1:pc=0000)
;5694a8:_l527(use=13:ref=3:pc=04d8)
;56b268:_l528(use=0:ref=2:pc=0000)
;56b2c8:_l529(use=0:ref=2:pc=0000)
;56cb38:_l530(use=0:ref=2:pc=0000)
;56cb98:_l531(use=0:ref=2:pc=0000)
;56df48:_l532(use=0:ref=2:pc=0000)
;56dfa8:_l533(use=0:ref=2:pc=0000)
;56e528:_l534(use=0:ref=1:pc=0000)
;56ec38:_l535(use=0:ref=1:pc=0000)
;56f9c8:_l536(use=0:ref=1:pc=0000)
;572208:_l537(use=0:ref=1:pc=0000)
;5724b8:_l538(use=0:ref=1:pc=0000)
;573298:_l539(use=0:ref=2:pc=0000)
;5732f8:_l540(use=0:ref=2:pc=0000)
;574678:_l541(use=0:ref=2:pc=0000)
;5746d8:_l542(use=0:ref=2:pc=0000)
;575408:_l543(use=0:ref=2:pc=0000)
;575468:_l544(use=0:ref=2:pc=0000)
;5757f8:_l545(use=0:ref=1:pc=0000)
;575f08:_l546(use=0:ref=1:pc=0000)
;577ea8:_l547(use=0:ref=2:pc=0000)
;577f08:_l548(use=0:ref=2:pc=0000)
;579878:_l549(use=0:ref=2:pc=0000)
;5798d8:_l550(use=0:ref=2:pc=0000)
;57ad08:_l551(use=0:ref=2:pc=0000)
;57ad68:_l552(use=0:ref=2:pc=0000)
;57b308:_l553(use=0:ref=1:pc=0000)
;57ba18:_l554(use=0:ref=1:pc=0000)
;57c748:_l555(use=0:ref=1:pc=0000)
;57faa8:_l556(use=0:ref=1:pc=0000)
;57fed8:_l557(use=0:ref=2:pc=0000)
;57ff38:_l558(use=0:ref=2:pc=0000)
;565a78:_l559(use=0:ref=1:pc=0000)
;566728:_l560(use=0:ref=1:pc=0000)
;567f98:_l561(use=0:ref=1:pc=0000)
;56b188:_l562(use=0:ref=1:pc=0000)
;5812f8:_l563(use=0:ref=1:pc=0000)
;581478:_l564(use=0:ref=1:pc=0000)
;5814d8:_l565(use=0:ref=1:pc=0000)
;582a98:_l566(use=0:ref=2:pc=0000)
;582af8:_l567(use=0:ref=2:pc=0000)
;583f98:_l568(use=0:ref=2:pc=0000)
;5832e8:_l569(use=0:ref=2:pc=0000)
;584318:_l570(use=0:ref=1:pc=0000)
;584378:_l571(use=0:ref=1:pc=0000)
;5843d8:_l572(use=0:ref=1:pc=0000)
;585418:_l573(use=0:ref=2:pc=0000)
;585478:_l574(use=0:ref=2:pc=0000)
;585da8:_l575(use=0:ref=2:pc=0000)
;585e08:_l576(use=0:ref=2:pc=0000)
;586238:_l577(use=7:ref=3:pc=051c)
;586298:_l578(use=7:ref=3:pc=0520)
;5862f8:_l579(use=0:ref=1:pc=0000)
;587478:_l580(use=0:ref=2:pc=0000)
;5874d8:_l581(use=0:ref=2:pc=0000)
;5879f8:_l582(use=0:ref=1:pc=0000)
;587a58:_l583(use=0:ref=1:pc=0000)
;587ab8:_l584(use=0:ref=1:pc=0000)
;588848:_l585(use=0:ref=1:pc=0000)
;5888a8:_l586(use=0:ref=1:pc=0000)
;588908:_l587(use=0:ref=1:pc=0000)
;5897b8:_l588(use=0:ref=2:pc=0000)
;589818:_l589(use=0:ref=2:pc=0000)
;589ba8:_l590(use=0:ref=1:pc=0000)
;589c68:_l591(use=0:ref=1:pc=0000)
;58ab38:_l592(use=0:ref=1:pc=0000)
;58ac18:_l593(use=0:ref=1:pc=0000)
;58bc38:_l594(use=0:ref=2:pc=0000)
;58bc98:_l595(use=0:ref=2:pc=0000)
;58c918:_l596(use=0:ref=1:pc=0000)
;58cc58:_l597(use=0:ref=1:pc=0000)
;58d278:_l598(use=0:ref=1:pc=0000)
;58d348:_l599(use=0:ref=1:pc=0000)
;58d5d8:_l600(use=0:ref=1:pc=0000)
;58ddd8:_l601(use=0:ref=2:pc=0000)
;58de38:_l602(use=0:ref=2:pc=0000)
;58e868:_l603(use=0:ref=2:pc=0000)
;58e8c8:_l604(use=0:ref=2:pc=0000)
;58ec38:_l605(use=0:ref=1:pc=0000)
;58ec98:_l606(use=0:ref=1:pc=0000)
;58ecf8:_l607(use=0:ref=1:pc=0000)
;58f688:_l608(use=0:ref=1:pc=0000)
;58f9c8:_l609(use=0:ref=1:pc=0000)
;58fec8:_l610(use=0:ref=1:pc=0000)
;58ff98:_l611(use=0:ref=1:pc=0000)
;576fa8:_l612(use=0:ref=1:pc=0000)
;591168:_l613(use=0:ref=2:pc=0000)
;5911c8:_l614(use=0:ref=2:pc=0000)
;591b68:_l615(use=0:ref=2:pc=0000)
;591bc8:_l616(use=0:ref=2:pc=0000)
;592678:_l617(use=0:ref=2:pc=0000)
;5926d8:_l618(use=0:ref=2:pc=0000)
;593628:_l619(use=7:ref=3:pc=0529)
;593688:_l620(use=7:ref=3:pc=0538)
;5936e8:_l621(use=0:ref=1:pc=0000)
;594858:_l622(use=7:ref=4:pc=05b7)
;5948b8:_l623(use=0:ref=2:pc=0000)
;595cb8:_l624(use=7:ref=3:pc=0562)
;5964a8:_l625(use=7:ref=3:pc=0560)
;598308:_l626(use=7:ref=3:pc=0599)
;598838:_l627(use=7:ref=3:pc=0597)
;59b868:_l628(use=7:ref=3:pc=05d3)
;59b8c8:_l629(use=0:ref=1:pc=0000)
;59b928:_l630(use=0:ref=1:pc=0000)
;59eaf8:_l631(use=0:ref=2:pc=0000)
;59ec48:_l632(use=0:ref=2:pc=0000)
;59f4e8:_l633(use=7:ref=3:pc=05f6)
;59fbe8:_l634(use=7:ref=3:pc=05f2)
;5a05a8:_l635(use=0:ref=1:pc=0000)
;5a0758:_l636(use=0:ref=1:pc=0000)
;5a1288:_l637(use=0:ref=1:pc=0000)
;5a1438:_l638(use=0:ref=1:pc=0000)
;5a1f08:_l639(use=0:ref=1:pc=0000)
;5a2198:_l640(use=0:ref=1:pc=0000)
;5a28f8:_l641(use=0:ref=1:pc=0000)
;5a2aa8:_l642(use=0:ref=1:pc=0000)
;5a3a88:_l643(use=0:ref=1:pc=0000)
;5a3c38:_l644(use=0:ref=1:pc=0000)
;5a4288:_l645(use=0:ref=1:pc=0000)
;5a48c8:_l646(use=0:ref=1:pc=0000)
;5a4a78:_l647(use=0:ref=1:pc=0000)
;5a5218:_l648(use=0:ref=1:pc=0000)
;5a53c8:_l649(use=0:ref=1:pc=0000)
;5a5b38:_l650(use=0:ref=1:pc=0000)
;5a5ce8:_l651(use=0:ref=1:pc=0000)
;5a6288:_l652(use=0:ref=1:pc=0000)
;5a67b8:_l653(use=0:ref=2:pc=0000)
;5a6818:_l654(use=0:ref=2:pc=0000)
;5a6f08:_l655(use=7:ref=3:pc=0636)
;5a7648:_l656(use=7:ref=3:pc=0632)
;5a7d28:_l657(use=0:ref=1:pc=0000)
;5a7ed8:_l658(use=0:ref=1:pc=0000)
;5a89a8:_l659(use=0:ref=1:pc=0000)
;5a8b58:_l660(use=0:ref=1:pc=0000)
;5a9418:_l661(use=0:ref=1:pc=0000)
;5a95c8:_l662(use=0:ref=1:pc=0000)
;5a9ef8:_l663(use=0:ref=1:pc=0000)
;5aa198:_l664(use=0:ref=1:pc=0000)
;5aa6f8:_l665(use=0:ref=1:pc=0000)
;5aa3e8:_l666(use=0:ref=1:pc=0000)
;5ab198:_l667(use=0:ref=1:pc=0000)
;5ab908:_l668(use=0:ref=1:pc=0000)
;5abab8:_l669(use=0:ref=1:pc=0000)
;5ac2f8:_l670(use=0:ref=1:pc=0000)
;5ac4a8:_l671(use=0:ref=1:pc=0000)
;5aca08:_l672(use=0:ref=1:pc=0000)
;5acfa8:_l673(use=0:ref=2:pc=0000)
;5ac258:_l674(use=0:ref=2:pc=0000)
;5ada98:_l675(use=0:ref=2:pc=0000)
;5adaf8:_l676(use=0:ref=2:pc=0000)
;5ae9a8:_l677(use=0:ref=2:pc=0000)
;5aea08:_l678(use=0:ref=2:pc=0000)
;5afc18:_l679(use=0:ref=2:pc=0000)
;5afc78:_l680(use=0:ref=2:pc=0000)
;5b0878:_l681(use=0:ref=2:pc=0000)
;5b08d8:_l682(use=0:ref=2:pc=0000)
;5b1288:_l683(use=0:ref=1:pc=0000)
;5b1438:_l684(use=0:ref=1:pc=0000)
;5b1998:_l685(use=0:ref=2:pc=0000)
;5b19f8:_l686(use=0:ref=2:pc=0000)
;5b2288:_l687(use=0:ref=1:pc=0000)
;5b2438:_l688(use=0:ref=1:pc=0000)
;5b2ce8:_l689(use=0:ref=2:pc=0000)
;5b2d48:_l690(use=0:ref=2:pc=0000)
;5b3898:_l691(use=0:ref=1:pc=0000)
;5b3f98:_l692(use=0:ref=1:pc=0000)
;5b5918:_l693(use=0:ref=1:pc=0000)
;5b6988:_l694(use=0:ref=1:pc=0000)
;5b7798:_l695(use=0:ref=1:pc=0000)
;5b7db8:_l696(use=0:ref=1:pc=0000)
;5baa68:_l697(use=0:ref=1:pc=0000)
;5bb5b8:_l698(use=0:ref=2:pc=0000)
;5bb618:_l699(use=0:ref=2:pc=0000)
;5bbe88:_l700(use=0:ref=1:pc=0000)
;5bc648:_l701(use=13:ref=3:pc=0687)
;5bddb8:_l702(use=0:ref=1:pc=0000)
;5bec28:_l703(use=0:ref=1:pc=0000)
;5bf828:_l704(use=0:ref=2:pc=0000)
;5bf888:_l705(use=0:ref=2:pc=0000)
;54c928:_l706(use=0:ref=1:pc=0000)
;5c0428:_l707(use=0:ref=1:pc=0000)
;5c1b58:_l708(use=0:ref=1:pc=0000)
;5c29f8:_l709(use=0:ref=1:pc=0000)
;5c3cc8:_l710(use=0:ref=2:pc=0000)
;5c3d28:_l711(use=0:ref=2:pc=0000)
;5c4c28:_l712(use=7:ref=3:pc=06b1)
;5c4c88:_l713(use=0:ref=1:pc=0000)
;5c4ce8:_l714(use=0:ref=1:pc=0000)
;5c5908:_l715(use=0:ref=1:pc=0000)
;5c63e8:_l716(use=0:ref=1:pc=0000)
;5c7478:_l717(use=0:ref=1:pc=0000)
;5c8478:_l718(use=0:ref=1:pc=0000)
;5c9328:_l719(use=7:ref=3:pc=06ef)
;5c9388:_l720(use=0:ref=1:pc=0000)
;5c93e8:_l721(use=0:ref=1:pc=0000)
;5cb758:_l722(use=0:ref=2:pc=0000)
;5cb7b8:_l723(use=0:ref=2:pc=0000)
;5cc488:_l724(use=0:ref=1:pc=0000)
;5cc638:_l725(use=0:ref=1:pc=0000)
;5ce4a8:_l726(use=0:ref=1:pc=0000)
;5ce658:_l727(use=0:ref=1:pc=0000)
;5cedc8:_l728(use=0:ref=1:pc=0000)
;5cef78:_l729(use=0:ref=1:pc=0000)
;5cf798:_l730(use=0:ref=1:pc=0000)
;5cf948:_l731(use=0:ref=1:pc=0000)
;581fc8:_l732(use=0:ref=1:pc=0000)
;58afb8:_l733(use=0:ref=1:pc=0000)
;5d16e8:_l734(use=0:ref=1:pc=0000)
;5d2678:_l735(use=0:ref=1:pc=0000)
;5d35e8:_l736(use=0:ref=1:pc=0000)
;5d4558:_l737(use=0:ref=1:pc=0000)
;5f3f88:_l738(use=0:ref=2:pc=0000)
;5f3168:_l739(use=0:ref=2:pc=0000)
;5f4f48:_l740(use=0:ref=1:pc=0000)
;5f5538:_l741(use=0:ref=1:pc=0000)
;5f59d8:_l742(use=0:ref=1:pc=0000)
;5f5de8:_l743(use=0:ref=1:pc=0000)
;5f7328:_l744(use=0:ref=1:pc=0000)
;5f7388:_l745(use=0:ref=1:pc=0000)
;5f73e8:_l746(use=0:ref=1:pc=0000)
;5f7878:_l747(use=0:ref=1:pc=0000)
;5f7908:_l748(use=0:ref=1:pc=0000)
;5f83b8:_l749(use=0:ref=1:pc=0000)
;5f88c8:_l750(use=0:ref=1:pc=0000)
;5f8f68:_l751(use=0:ref=1:pc=0000)
;5f9df8:_l752(use=0:ref=1:pc=0000)
;5faba8:_l753(use=0:ref=1:pc=0000)
;5fb828:_l754(use=0:ref=1:pc=0000)
;5fc5f8:_l755(use=0:ref=1:pc=0000)
;5fe618:_l756(use=0:ref=2:pc=0000)
;5fe678:_l757(use=0:ref=2:pc=0000)
;601a48:_l758(use=0:ref=1:pc=0000)
;601f38:_l759(use=0:ref=1:pc=0000)
;6037c8:_l760(use=0:ref=1:pc=0000)
;603bc8:_l761(use=0:ref=1:pc=0000)
;604648:_l762(use=0:ref=1:pc=0000)
;604a48:_l763(use=0:ref=1:pc=0000)
;605218:_l764(use=0:ref=1:pc=0000)
;605cf8:_l765(use=0:ref=1:pc=0000)
;606b08:_l766(use=0:ref=1:pc=0000)
;606368:_l767(use=0:ref=1:pc=0000)
;6089d8:_l768(use=0:ref=1:pc=0000)
;608a68:_l769(use=0:ref=1:pc=0000)
;609218:_l770(use=0:ref=1:pc=0000)
;60a888:_l771(use=0:ref=2:pc=0000)
;60a8e8:_l772(use=0:ref=2:pc=0000)
;60b6e8:_l773(use=7:ref=3:pc=071e)
;60baf8:_l774(use=7:ref=3:pc=071b)
;60c988:_l775(use=7:ref=3:pc=072b)
;60cd48:_l776(use=7:ref=3:pc=0728)
;60d888:_l777(use=7:ref=3:pc=0736)
;60dd48:_l778(use=7:ref=3:pc=0734)
;60ee58:_l779(use=7:ref=3:pc=0739)
;60eeb8:_l780(use=7:ref=3:pc=07db)
;60ef18:_l781(use=0:ref=1:pc=0000)
;60fd88:_l782(use=13:ref=3:pc=0746)
;60fe58:_l783(use=0:ref=1:pc=0000)
;5f9408:_l784(use=0:ref=1:pc=0000)
;5fefa8:_l785(use=0:ref=1:pc=0000)
;6103c8:_l786(use=7:ref=3:pc=078c)
;610938:_l787(use=7:ref=3:pc=07a0)
;610da8:_l788(use=0:ref=1:pc=0000)
;611278:_l789(use=0:ref=1:pc=0000)
;612798:_l790(use=7:ref=3:pc=07ca)
;612b58:_l791(use=13:ref=3:pc=07ca)
;612cd8:_l792(use=0:ref=1:pc=0000)
;612f98:_l793(use=7:ref=3:pc=07c9)
;613f18:_l794(use=7:ref=3:pc=07d9)
;614228:_l795(use=13:ref=3:pc=07d9)
;6143a8:_l796(use=0:ref=1:pc=0000)
;614668:_l797(use=7:ref=3:pc=07d8)
;6166f8:_l798(use=0:ref=2:pc=0000)
;616758:_l799(use=0:ref=2:pc=0000)
;617828:_l800(use=0:ref=2:pc=0000)
;617888:_l801(use=0:ref=2:pc=0000)
;619cb8:_l802(use=7:ref=3:pc=07fa)
;619d18:_l803(use=7:ref=3:pc=091a)
;619d78:_l804(use=0:ref=1:pc=0000)
;619f68:_l805(use=7:ref=3:pc=0811)
;61ab38:_l806(use=7:ref=3:pc=0810)
;61d598:_l807(use=7:ref=3:pc=0863)
;61d668:_l808(use=0:ref=1:pc=0000)
;61dd28:_l809(use=13:ref=3:pc=0870)
;61ddf8:_l810(use=0:ref=1:pc=0000)
;61e568:_l811(use=0:ref=1:pc=0000)
;61ea38:_l812(use=0:ref=1:pc=0000)
;61f198:_l813(use=7:ref=3:pc=08a4)
;61f468:_l814(use=7:ref=3:pc=08a7)
;61fb28:_l815(use=7:ref=3:pc=08bc)
;60f2d8:_l816(use=7:ref=3:pc=08d0)
;620278:_l817(use=0:ref=1:pc=0000)
;6206e8:_l818(use=7:ref=3:pc=08e9)
;620be8:_l819(use=7:ref=3:pc=08f7)
;620d28:_l820(use=0:ref=1:pc=0000)
;623e78:_l821(use=0:ref=1:pc=0000)
;624228:_l822(use=7:ref=3:pc=0900)
;624d88:_l823(use=7:ref=3:pc=0916)
;625988:_l824(use=7:ref=3:pc=0915)
;6279a8:_l825(use=0:ref=2:pc=0000)
;627a08:_l826(use=0:ref=2:pc=0000)
;628f78:_l827(use=0:ref=1:pc=0000)
;629198:_l828(use=0:ref=1:pc=0000)
;629628:_l829(use=0:ref=1:pc=0000)
;6296f8:_l830(use=0:ref=1:pc=0000)
;629bb8:_l831(use=0:ref=1:pc=0000)
;62a4c8:_l832(use=0:ref=1:pc=0000)
;62a598:_l833(use=0:ref=1:pc=0000)
;62ac68:_l834(use=0:ref=1:pc=0000)
;62b2f8:_l835(use=0:ref=1:pc=0000)
;62b768:_l836(use=0:ref=1:pc=0000)
;62bde8:_l837(use=0:ref=1:pc=0000)
;62c478:_l838(use=0:ref=1:pc=0000)
;62c8e8:_l839(use=0:ref=1:pc=0000)
;62c9b8:_l840(use=0:ref=1:pc=0000)
;62ce78:_l841(use=0:ref=1:pc=0000)
;62d128:_l842(use=0:ref=1:pc=0000)
;62d368:_l843(use=0:ref=1:pc=0000)
;630d88:_l844(use=0:ref=2:pc=0000)
;630de8:_l845(use=0:ref=2:pc=0000)
;631de8:_l846(use=0:ref=2:pc=0000)
;631e48:_l847(use=0:ref=2:pc=0000)
;6333f8:_l848(use=0:ref=2:pc=0000)
;633458:_l849(use=0:ref=2:pc=0000)
;634238:_l850(use=0:ref=2:pc=0000)
;634298:_l851(use=0:ref=2:pc=0000)
;637f18:_l852(use=13:ref=3:pc=098d)
;638108:_l853(use=0:ref=1:pc=0000)
;638598:_l854(use=13:ref=3:pc=0994)
;638668:_l855(use=0:ref=1:pc=0000)
;638b28:_l856(use=7:ref=3:pc=09b7)
;639448:_l857(use=7:ref=3:pc=09d4)
;639518:_l858(use=0:ref=1:pc=0000)
;639be8:_l859(use=0:ref=1:pc=0000)
;63a278:_l860(use=0:ref=1:pc=0000)
;63a6e8:_l861(use=13:ref=3:pc=0a09)
;63ad68:_l862(use=0:ref=1:pc=0000)
;63b438:_l863(use=0:ref=1:pc=0000)
;63b8a8:_l864(use=13:ref=3:pc=0a3a)
;63b978:_l865(use=7:ref=3:pc=0a3a)
;63be38:_l866(use=7:ref=3:pc=0a43)
;63c108:_l867(use=0:ref=1:pc=0000)
;63c348:_l868(use=14:ref=4:pc=0a48)
;640908:_l869(use=13:ref=3:pc=0a63)
;6409d8:_l870(use=0:ref=1:pc=0000)
;640e68:_l871(use=13:ref=3:pc=0a6a)
;640f38:_l872(use=0:ref=1:pc=0000)
;641518:_l873(use=7:ref=3:pc=0a8d)
;641ca8:_l874(use=7:ref=3:pc=0aaa)
;641d78:_l875(use=0:ref=1:pc=0000)
;642558:_l876(use=0:ref=1:pc=0000)
;642ac8:_l877(use=0:ref=1:pc=0000)
;642f38:_l878(use=13:ref=3:pc=0adf)
;6436d8:_l879(use=0:ref=1:pc=0000)
;643c48:_l880(use=0:ref=1:pc=0000)
;644208:_l881(use=13:ref=3:pc=0b10)
;6442d8:_l882(use=7:ref=3:pc=0b10)
;644798:_l883(use=7:ref=3:pc=0b19)
;644948:_l884(use=0:ref=1:pc=0000)
;644b88:_l885(use=14:ref=4:pc=0b1e)
;649728:_l886(use=13:ref=3:pc=0b39)
;6497f8:_l887(use=0:ref=1:pc=0000)
;649c88:_l888(use=13:ref=3:pc=0b40)
;649d58:_l889(use=0:ref=1:pc=0000)
;64a358:_l890(use=7:ref=3:pc=0b63)
;64aae8:_l891(use=7:ref=3:pc=0b80)
;64abb8:_l892(use=0:ref=1:pc=0000)
;64b388:_l893(use=0:ref=1:pc=0000)
;64b8f8:_l894(use=0:ref=1:pc=0000)
;64bd68:_l895(use=13:ref=3:pc=0bb5)
;64c5e8:_l896(use=0:ref=1:pc=0000)
;64cb58:_l897(use=0:ref=1:pc=0000)
;64cfc8:_l898(use=13:ref=3:pc=0be6)
;64d198:_l899(use=7:ref=3:pc=0be6)
;64d658:_l900(use=7:ref=3:pc=0bef)
;64d808:_l901(use=0:ref=1:pc=0000)
;64da48:_l902(use=12:ref=4:pc=0bf4)
;650ec8:_l903(use=0:ref=2:pc=0000)
;650f28:_l904(use=0:ref=2:pc=0000)
;6517b8:_l905(use=7:ref=3:pc=0bf8)
;651818:_l906(use=7:ref=3:pc=0ceb)
;651878:_l907(use=0:ref=1:pc=0000)
;653c68:_l908(use=13:ref=3:pc=0c29)
;653d38:_l909(use=0:ref=1:pc=0000)
;6542e8:_l910(use=13:ref=3:pc=0c30)
;6543b8:_l911(use=0:ref=1:pc=0000)
;654878:_l912(use=7:ref=3:pc=0c57)
;655198:_l913(use=7:ref=3:pc=0c76)
;655268:_l914(use=0:ref=1:pc=0000)
;655938:_l915(use=0:ref=1:pc=0000)
;655ea8:_l916(use=0:ref=1:pc=0000)
;656448:_l917(use=13:ref=3:pc=0cab)
;656ac8:_l918(use=0:ref=1:pc=0000)
;657198:_l919(use=0:ref=1:pc=0000)
;657608:_l920(use=13:ref=3:pc=0cdc)
;6576d8:_l921(use=7:ref=3:pc=0cdc)
;657b98:_l922(use=7:ref=3:pc=0ce4)
;657d48:_l923(use=0:ref=1:pc=0000)
;657f88:_l924(use=14:ref=4:pc=0cea)
;65bf88:_l925(use=0:ref=2:pc=0000)
;65c108:_l926(use=0:ref=2:pc=0000)
;65e8b8:_l927(use=0:ref=1:pc=0000)
;65e948:_l928(use=0:ref=1:pc=0000)
;6613f8:_l929(use=0:ref=1:pc=0000)
;661ee8:_l930(use=14:ref=5:pc=0cf3)
;661f48:_l931(use=0:ref=2:pc=0000)
;664788:_l932(use=0:ref=1:pc=0000)
;664818:_l933(use=0:ref=1:pc=0000)
;6692f8:_l934(use=0:ref=1:pc=0000)
;66a1a8:_l935(use=0:ref=1:pc=0000)
;66a358:_l936(use=0:ref=1:pc=0000)
;66ae08:_l937(use=0:ref=1:pc=0000)
;66afb8:_l938(use=0:ref=1:pc=0000)
;66b558:_l939(use=0:ref=1:pc=0000)
;66b708:_l940(use=0:ref=1:pc=0000)
;66bb98:_l941(use=0:ref=1:pc=0000)
;66bd48:_l942(use=0:ref=1:pc=0000)
;66c2e8:_l943(use=0:ref=1:pc=0000)
;66c498:_l944(use=0:ref=1:pc=0000)
;66cd58:_l945(use=0:ref=1:pc=0000)
;66d4f8:_l946(use=0:ref=1:pc=0000)
;66db48:_l947(use=0:ref=1:pc=0000)
;66e2f8:_l948(use=0:ref=1:pc=0000)
;66e688:_l949(use=0:ref=1:pc=0000)
;6726e8:_l950(use=7:ref=3:pc=0db8)
;672748:_l951(use=0:ref=1:pc=0000)
;6727a8:_l952(use=0:ref=1:pc=0000)
;675b58:_l953(use=7:ref=3:pc=0e3b)
;676278:_l954(use=7:ref=3:pc=0e67)
;676a48:_l955(use=0:ref=1:pc=0000)
;676bf8:_l956(use=0:ref=1:pc=0000)
;67d348:_l957(use=14:ref=4:pc=0ee4)
;67d3a8:_l958(use=0:ref=1:pc=0000)
;67f398:_l959(use=0:ref=1:pc=0000)
;67f938:_l960(use=0:ref=1:pc=0000)
;741428:_l961(use=3:ref=1:pc=0041)
;741d78:_l962(use=3:ref=1:pc=004f)
;7428a8:_l963(use=3:ref=1:pc=005f)
;743da8:_l964(use=3:ref=1:pc=007d)
;743e08:_l965(use=3:ref=1:pc=007f)
;74ec08:_l966(use=0:ref=1:pc=0186)
;74f4a8:_l967(use=0:ref=1:pc=0192)
;74f818:_l968(use=3:ref=1:pc=019d)
;74fe98:_l969(use=0:ref=1:pc=01a9)
;74fef8:_l970(use=0:ref=1:pc=0000)
;750c88:_l971(use=3:ref=1:pc=01be)
;750ce8:_l972(use=3:ref=1:pc=01c1)
;753c08:_l973(use=0:ref=1:pc=0201)
;753f78:_l974(use=3:ref=1:pc=0209)
;7545a8:_l975(use=3:ref=1:pc=020f)
;754d88:_l976(use=3:ref=1:pc=021b)
;759ef8:_l977(use=3:ref=1:pc=02aa)
;759f58:_l978(use=3:ref=1:pc=02ad)
;75bce8:_l979(use=3:ref=1:pc=02d8)
;75bd48:_l980(use=3:ref=1:pc=02db)
;75da08:_l981(use=3:ref=1:pc=0306)
;75da68:_l982(use=3:ref=1:pc=0309)
;75f6c8:_l983(use=3:ref=1:pc=0327)
;766db8:_l984(use=3:ref=1:pc=03eb)
;767688:_l985(use=0:ref=1:pc=03f3)
;771aa8:_l986(use=0:ref=1:pc=0500)
;771de8:_l987(use=3:ref=1:pc=0508)
;7753a8:_l988(use=0:ref=1:pc=055f)
;7756e8:_l989(use=3:ref=1:pc=0567)
;785928:_l990(use=0:ref=1:pc=070f)
;785cc8:_l991(use=0:ref=1:pc=0717)
;78f9a8:_l992(use=0:ref=1:pc=081c)
;78fd88:_l993(use=3:ref=1:pc=0824)
;790f28:_l994(use=0:ref=1:pc=083f)
;791428:_l995(use=3:ref=1:pc=0847)
;7925a8:_l996(use=0:ref=1:pc=0862)
;792988:_l997(use=3:ref=1:pc=086a)
;7942a8:_l998(use=0:ref=1:pc=088f)
;794648:_l999(use=0:ref=1:pc=0897)
;798708:_l1000(use=3:ref=1:pc=0905)
;798768:_l1001(use=3:ref=1:pc=090a)
;799f28:_l1002(use=3:ref=1:pc=092a)
;799f88:_l1003(use=3:ref=1:pc=092f)
;79c8a8:_l1004(use=0:ref=1:pc=096a)
;79cc88:_l1005(use=0:ref=1:pc=0972)
;79d2a8:_l1006(use=0:ref=1:pc=0978)
;79d688:_l1007(use=3:ref=1:pc=0980)
;79e2a8:_l1008(use=0:ref=1:pc=098f)
;79e688:_l1009(use=0:ref=1:pc=0997)
;79eb68:_l1010(use=0:ref=1:pc=099d)
;79ef48:_l1011(use=3:ref=1:pc=09a5)
;7a38c8:_l1012(use=0:ref=1:pc=0a2a)
;7a3928:_l1013(use=0:ref=1:pc=0000)
;7a84a8:_l1014(use=0:ref=1:pc=0aae)
;7a8508:_l1015(use=0:ref=1:pc=0000)
;7a8c18:_l1016(use=0:ref=1:pc=0aba)
;7a8c78:_l1017(use=0:ref=1:pc=0000)
;7ab128:_l1018(use=0:ref=1:pc=0af1)
;7ab468:_l1019(use=0:ref=1:pc=0af9)
;7afe08:_l1020(use=3:ref=1:pc=0b77)
;7afe68:_l1021(use=3:ref=1:pc=0b7c)
;7b17a8:_l1022(use=3:ref=1:pc=0b9c)
;7b1808:_l1023(use=3:ref=1:pc=0ba1)
;7b6e48:_l1024(use=0:ref=1:pc=0c33)
;7b6ea8:_l1025(use=0:ref=1:pc=0000)
;7c1228:_l1026(use=0:ref=1:pc=0d3f)
;7c15c8:_l1027(use=0:ref=1:pc=0d47)
;7c1ca8:_l1028(use=0:ref=1:pc=0d4e)
;7c21a8:_l1029(use=0:ref=1:pc=0d56)
;7c6c68:_l1030(use=0:ref=1:pc=0dd4)
;7c7108:_l1031(use=0:ref=1:pc=0ddc)
;7ca228:_l1032(use=0:ref=1:pc=0e2b)
;7ca5c8:_l1033(use=0:ref=1:pc=0e33)
;7d05e8:_l1034(use=0:ref=1:pc=0eca)
;7d0988:_l1035(use=0:ref=1:pc=0ed2)
;7d11a8:_l1036(use=0:ref=1:pc=0ed9)
;7d1548:_l1037(use=0:ref=1:pc=0ee1)
;7d6108:_l1038(use=0:ref=1:pc=0f5f)
;7d64a8:_l1039(use=0:ref=1:pc=0f67)
;7d95c8:_l1040(use=0:ref=1:pc=0fb6)
;7d9968:_l1041(use=0:ref=1:pc=0fbe)
;7df928:_l1042(use=0:ref=1:pc=1055)
;7dfcc8:_l1043(use=0:ref=1:pc=105d)
;7e04a8:_l1044(use=0:ref=1:pc=1064)
;7e0848:_l1045(use=0:ref=1:pc=106c)
;7e5428:_l1046(use=0:ref=1:pc=10ea)
;7e57c8:_l1047(use=0:ref=1:pc=10f2)
;7e88e8:_l1048(use=0:ref=1:pc=1141)
;7e8c88:_l1049(use=0:ref=1:pc=1149)
;7f0d88:_l1050(use=0:ref=1:pc=121a)
;7f1228:_l1051(use=0:ref=1:pc=1222)
;7f1908:_l1052(use=0:ref=1:pc=1229)
;7f1ca8:_l1053(use=0:ref=1:pc=1231)
;7f6868:_l1054(use=0:ref=1:pc=12af)
;7f6c08:_l1055(use=0:ref=1:pc=12b7)
;7f9d68:_l1056(use=0:ref=1:pc=1306)
;7fa228:_l1057(use=0:ref=1:pc=130e)
;826868:_l1058(use=3:ref=1:pc=17a0)
;8272a8:_l1059(use=3:ref=1:pc=17ab)
;8283a8:_l1060(use=3:ref=1:pc=17cc)
;828c88:_l1061(use=3:ref=1:pc=17d7)
;829428:_l1062(use=0:ref=1:pc=17e3)
;829488:_l1063(use=0:ref=1:pc=0000)
;965828:_l1064(use=3:ref=1:pc=0000)
;965888:_l1065(use=3:ref=1:pc=0000)
;967898:_l1066(use=3:ref=1:pc=0000)
;9678f8:_l1067(use=3:ref=1:pc=0000)
;967958:_l1068(use=3:ref=1:pc=0000)
;968c98:_l1069(use=3:ref=1:pc=0000)
;484458:_l1070(use=3:ref=1:pc=0298)
;485468:_l1071(use=3:ref=1:pc=02a6)
;485b38:_l1072(use=3:ref=1:pc=02ad)
;485fb8:_l1073(use=3:ref=1:pc=02c6)
;485228:_l1074(use=3:ref=1:pc=02bf)
;4863c8:_l1075(use=3:ref=1:pc=02bb)
;486638:_l1076(use=3:ref=1:pc=02ee)
;486c58:_l1077(use=3:ref=1:pc=02f8)
;487418:_l1078(use=3:ref=1:pc=0304)
;487658:_l1079(use=3:ref=1:pc=0314)
;487738:_l1080(use=3:ref=1:pc=0316)
;48c778:_l1081(use=0:ref=1:pc=03b7)
;48da68:_l1082(use=0:ref=1:pc=03bd)
;48efc8:_l1083(use=3:ref=1:pc=03c3)
;48e4e8:_l1084(use=0:ref=1:pc=03c7)
;48ea28:_l1085(use=0:ref=1:pc=0000)
;490298:_l1086(use=0:ref=1:pc=03e8)
;491238:_l1087(use=3:ref=1:pc=03ec)
;491748:_l1088(use=3:ref=1:pc=03f2)
;492328:_l1089(use=3:ref=1:pc=03fc)
;499bb8:_l1090(use=3:ref=1:pc=0476)
;4a2548:_l1091(use=3:ref=1:pc=04d0)
;4a4df8:_l1092(use=0:ref=1:pc=04d4)
;4a9278:_l1093(use=0:ref=1:pc=0554)
;4aa308:_l1094(use=3:ref=1:pc=0559)
;4ab248:_l1095(use=0:ref=1:pc=058b)
;4ab8c8:_l1096(use=3:ref=1:pc=0590)
;4b3728:_l1097(use=0:ref=1:pc=067f)
;4b4fb8:_l1098(use=0:ref=1:pc=0683)
;4b8fb8:_l1099(use=0:ref=1:pc=0713)
;4b8238:_l1100(use=3:ref=1:pc=0717)
;4b8748:_l1101(use=0:ref=1:pc=0720)
;4b9ee8:_l1102(use=3:ref=1:pc=0724)
;4baeb8:_l1103(use=0:ref=1:pc=072d)
;4bb3f8:_l1104(use=3:ref=1:pc=0731)
;4bb568:_l1105(use=0:ref=1:pc=073e)
;4bbc78:_l1106(use=0:ref=1:pc=0742)
;4bd918:_l1107(use=3:ref=1:pc=0783)
;4be248:_l1108(use=3:ref=1:pc=0786)
;4bfc48:_l1109(use=3:ref=1:pc=0796)
;4c03c8:_l1110(use=3:ref=1:pc=0799)
;4c0978:_l1111(use=0:ref=1:pc=07bc)
;4c0e88:_l1112(use=0:ref=1:pc=07c1)
;4c16f8:_l1113(use=0:ref=1:pc=07c3)
;4c18b8:_l1114(use=3:ref=1:pc=07c7)
;4c1aa8:_l1115(use=0:ref=1:pc=07cc)
;4c1b88:_l1116(use=0:ref=1:pc=07d0)
;4c1d58:_l1117(use=0:ref=1:pc=07d2)
;4c1e38:_l1118(use=3:ref=1:pc=07d6)
;4c11e8:_l1119(use=0:ref=1:pc=080b)
;4c22c8:_l1120(use=0:ref=1:pc=0000)
;4c29a8:_l1121(use=0:ref=1:pc=0846)
;4c2c68:_l1122(use=0:ref=1:pc=0000)
;4c2f28:_l1123(use=0:ref=1:pc=084a)
;4c32c8:_l1124(use=0:ref=1:pc=0000)
;4c36e8:_l1125(use=0:ref=1:pc=0867)
;4c3b08:_l1126(use=0:ref=1:pc=086c)
;4c49a8:_l1127(use=3:ref=1:pc=08b4)
;4c4b98:_l1128(use=3:ref=1:pc=08b7)
;4c5fc8:_l1129(use=3:ref=1:pc=08c7)
;4c52c8:_l1130(use=3:ref=1:pc=08ca)
;4c5958:_l1131(use=0:ref=1:pc=0911)
;4c5c08:_l1132(use=0:ref=1:pc=0000)
;4c6f38:_l1133(use=0:ref=1:pc=0987)
;4c72c8:_l1134(use=0:ref=1:pc=098c)
;4c7588:_l1135(use=0:ref=1:pc=098f)
;4c79a8:_l1136(use=0:ref=1:pc=0993)
;4c8fb8:_l1137(use=0:ref=1:pc=09da)
;4c8428:_l1138(use=0:ref=1:pc=09df)
;4c8b78:_l1139(use=0:ref=1:pc=0a0b)
;4c8ec8:_l1140(use=0:ref=1:pc=0a0f)
;4c9e28:_l1141(use=0:ref=1:pc=0a5e)
;4ca178:_l1142(use=0:ref=1:pc=0a62)
;4ca3c8:_l1143(use=0:ref=1:pc=0a65)
;4ca6b8:_l1144(use=0:ref=1:pc=0a69)
;4cb318:_l1145(use=0:ref=1:pc=0ab0)
;4cbb58:_l1146(use=0:ref=1:pc=0ab5)
;4cd5c8:_l1147(use=0:ref=1:pc=0ae1)
;4cde38:_l1148(use=0:ref=1:pc=0ae5)
;4d1d38:_l1149(use=0:ref=1:pc=0b34)
;4d2348:_l1150(use=0:ref=1:pc=0b38)
;4d26a8:_l1151(use=0:ref=1:pc=0b3b)
;4d2ee8:_l1152(use=0:ref=1:pc=0b3f)
;4d4f78:_l1153(use=0:ref=1:pc=0b86)
;4d47c8:_l1154(use=0:ref=1:pc=0b8b)
;4d6198:_l1155(use=0:ref=1:pc=0bb7)
;4d6c98:_l1156(use=0:ref=1:pc=0bbb)
;4d97a8:_l1157(use=0:ref=1:pc=0c23)
;4da478:_l1158(use=0:ref=1:pc=0c28)
;4dab58:_l1159(use=0:ref=1:pc=0c2b)
;4db168:_l1160(use=0:ref=1:pc=0c2f)
;4dce38:_l1161(use=0:ref=1:pc=0c7c)
;4dd168:_l1162(use=0:ref=1:pc=0c81)
;4de528:_l1163(use=0:ref=1:pc=0cad)
;4df958:_l1164(use=0:ref=1:pc=0cb1)
;4ecf98:_l1165(use=3:ref=1:pc=0efb)
;4ed168:_l1166(use=3:ref=1:pc=0f00)
;4ed3e8:_l1167(use=3:ref=1:pc=0f0d)
;4ed698:_l1168(use=3:ref=1:pc=0f12)
;4ed958:_l1169(use=0:ref=1:pc=0f16)
;4edc18:_l1170(use=0:ref=1:pc=0000)
;Unnamed Constant Variables
;============
