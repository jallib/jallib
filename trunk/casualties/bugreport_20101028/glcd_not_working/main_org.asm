; compiler: jal 2.4n (compiled Jun  2 2010)

; command line:  C:\PICjal\JAL\Compiler\jalv2.exe -Wno-all -long-start -clear -s c:\PICjal\JAL\Libraries; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
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
v_true                         EQU 1
v_false                        EQU 0
v_high                         EQU 1
v_low                          EQU 0
v_input                        EQU 1
v_output                       EQU 0
v_all_input                    EQU 255
v_all_output                   EQU 0
v__pic_accum                   EQU 0x007e  ; _pic_accum
v__ind                         EQU 0x0000  ; _ind
v__pcl                         EQU 0x0002  ; _pcl
v__status                      EQU 0x0003  ; _status
v__irp                         EQU 7
v__z                           EQU 2
v__c                           EQU 0
v__fsr                         EQU 0x0004  ; _fsr
v_porta                        EQU 0x0005  ; porta
v__porta_shadow                EQU 0x0037  ; _porta_shadow
v_portb                        EQU 0x0006  ; portb
v__portb_shadow                EQU 0x0038  ; _portb_shadow
v_portc                        EQU 0x0007  ; portc
v__portc_shadow                EQU 0x0039  ; _portc_shadow
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
v_tad_value                    EQU 0x003a  ; tad_value
v_adc_min_tad                  EQU 16
v_adc_max_tad                  EQU 60
v__adcon0_shadow               EQU 0x0034  ; _adcon0_shadow
v_adc_conversion_delay         EQU 0x003b  ; adc_conversion_delay
v_measure_a                    EQU 0x003c  ; measure_a
v__pr2_shadow_plus1            EQU 0x0035  ; _pr2_shadow_plus1
v__ccpr1l_shadow               EQU 0x003e  ; _ccpr1l_shadow
v__ccp1con_shadow              EQU 0x003f  ; _ccp1con_shadow
v_pwmvalue                     EQU 0x0040  ; pwmvalue
v____temp_47                   EQU 0x0041  ; _temp
v_ks0108_left                  EQU 0
v_ks0108_right                 EQU 1
v_ks0108_cmd_on                EQU 63
v_ks0108_cmd_page              EQU 184
v_ks0108_cmd_column            EQU 64
v_buff                         EQU 0x0043  ; buff
v_buffx                        EQU 0x0044  ; buffx
v_buffy                        EQU 0x0045  ; buffy
v_timer                        EQU 0x0046  ; timer
v_oldadc                       EQU 0x0047  ; oldadc
v_adclowres                    EQU 0x0049  ; adclowres
v___e1_2                       EQU 0x0052  ; e1-->_bitbucket:5
v___e2_2                       EQU 0x0052  ; e2-->_bitbucket:6
v_graphleft                    EQU 0x004a  ; graphleft
v_graphright                   EQU 0x004b  ; graphright
v_graphtop                     EQU 0x004c  ; graphtop
v_graphbottom                  EQU 0x004d  ; graphbottom
v_graphy                       EQU 0x004e  ; graphy
v__bitbucket                   EQU 0x0052  ; _bitbucket
v__pic_temp                    EQU 0x0020  ; _pic_temp-->_pic_state
v__pic_loop                    EQU 0x0030  ; _pic_loop
v__pic_multiplier              EQU 0x0020  ; _pic_multiplier-->_pic_state
v__pic_multiplicand            EQU 0x0022  ; _pic_multiplicand-->_pic_state+2
v__pic_mresult                 EQU 0x0024  ; _pic_mresult-->_pic_state+4
v__pic_divisor                 EQU 0x0028  ; _pic_divisor-->_pic_state+8
v__pic_dividend                EQU 0x0020  ; _pic_dividend-->_pic_state
v__pic_quotient                EQU 0x002c  ; _pic_quotient-->_pic_state+12
v__pic_remainder               EQU 0x0024  ; _pic_remainder-->_pic_state+4
v__pic_divaccum                EQU 0x0020  ; _pic_divaccum-->_pic_state
v__pic_pointer                 EQU 0x0032  ; _pic_pointer
v__pic_state                   EQU 0x0020  ; _pic_state
v___vcfg_shadow_3              EQU 0x0054  ; vcfg_shadow
v____btemp32_2                 EQU 0x0052  ; _btemp32-->_bitbucket:10
v____btemp34_2                 EQU 0x0052  ; _btemp34-->_bitbucket:12
v____btemp36_2                 EQU 0x0052  ; _btemp36-->_bitbucket:14
v___x_135                      EQU 0x0054  ; x
v___x_136                      EQU 0x0039  ; x-->_portc_shadow:4
v___x_137                      EQU 0x0037  ; x-->_porta_shadow:5
v___x_138                      EQU 0x0039  ; x-->_portc_shadow:1
v___x_139                      EQU 0x0039  ; x-->_portc_shadow:0
v___side_46                    EQU 0x0054  ; side
v___page_4                     EQU 0x0055  ; page
v____temp_119                  EQU 0x0056  ; _temp
v___side_47                    EQU 0x0054  ; side
v___page_5                     EQU 0x0055  ; page
v____temp_120                  EQU 0x0056  ; _temp
v___side_48                    EQU 0x0054  ; side
v___column_6                   EQU 0x0055  ; column
v____temp_121                  EQU 0x0056  ; _temp
v___side_49                    EQU 0x0054  ; side
v___column_7                   EQU 0x0055  ; column
v____temp_122                  EQU 0x0056  ; _temp
v___x0_8                       EQU 0x0054  ; x0
v___y_16                       EQU 0x0055  ; y
v___x1_8                       EQU 0x0056  ; x1
v___value_4                    EQU 0x0057  ; value
v___max_4                      EQU 0x0059  ; max
v___startleft_2                EQU 0x0052  ; startleft-->_bitbucket:7
v___maxx_1                     EQU 0x005b  ; maxx
v___thevalue_2                 EQU 0x005c  ; thevalue
v____temp_123                  EQU 0x005e  ; _temp
v____rparam16_1                EQU 0x0061  ; _rparam16
v__btemp107                    EQU 0x0052  ; _btemp107-->_bitbucket:4
v___x_131                      EQU 0x0062  ; lcd_print:x
v___y_13                       EQU 0x0064  ; lcd_print:y
v____str_count_1               EQU 0x0068  ; lcd_print:_str_count
v___str_3                      EQU 0x006b  ; lcd_print:str
v___i_1                        EQU 0x006f  ; lcd_print:i
v___j_1                        EQU 0x00a2  ; lcd_print:j
v____temp_111                  EQU 0x00a3  ; lcd_print:_temp
v____bitbucket_3               EQU 0x00a4  ; lcd_print:_bitbucket
v__rparam14                    EQU 0x00a5  ; lcd_print:_rparam14
v___x_132                      EQU 0x00a7  ; lcd_print:x
v___debug_6                    EQU 0x00a4  ; lcd_print:debug-->_bitbucket3:0
v___findex_5                   EQU 0x00a8  ; lcd_print:findex
v___cx_5                       EQU 0x00ab  ; lcd_print:cx
v___doloop_5                   EQU 0x00ae  ; lcd_print:doloop
v____temp_112                  EQU 0x00af  ; lcd_print:_temp
v____floop7_5                  EQU 0x00b7  ; lcd_print:_floop7
v____rparam3_5                 EQU 0x00bb  ; lcd_print:_rparam3
v___side_42                    EQU 0x00bc  ; lcd_print:side
v____temp_113                  EQU 0x00bd  ; lcd_print:_temp
v___side_43                    EQU 0x00bc  ; lcd_print:side
v____temp_114                  EQU 0x00bd  ; lcd_print:_temp
v____rparam4_5                 EQU 0x00bb  ; lcd_print:_rparam4
v____rparam5_5                 EQU 0x00bc  ; lcd_print:_rparam5
v___side_44                    EQU 0x00bd  ; lcd_print:side
v____temp_115                  EQU 0x00be  ; lcd_print:_temp
v___side_45                    EQU 0x00bd  ; lcd_print:side
v____temp_116                  EQU 0x00be  ; lcd_print:_temp
v___x_126                      EQU 0x0062  ; lcd_num:x
v___y_11                       EQU 0x0064  ; lcd_num:y
v___num_1                      EQU 0x0068  ; lcd_num:num
v____temp_95                   EQU 0x006b  ; lcd_num:_temp
v_hundrets                     EQU 0x00a3  ; lcd_num:hundrets
v_tens                         EQU 0x00a4  ; lcd_num:tens
v_ones                         EQU 0x00a5  ; lcd_num:ones
v__rparam9                     EQU 0x00a7  ; lcd_num:_rparam9
v__rparam11                    EQU 0x00a8  ; lcd_num:_rparam11
v__rparam13                    EQU 0x00aa  ; lcd_num:_rparam13
v____bitbucket_4               EQU 0x00ab  ; lcd_num:_bitbucket
v___x_127                      EQU 0x00ae  ; lcd_num:x
v___debug_3                    EQU 0x00ab  ; lcd_num:debug-->_bitbucket4:0
v___findex_2                   EQU 0x00af  ; lcd_num:findex
v___cx_2                       EQU 0x00b4  ; lcd_num:cx
v___doloop_2                   EQU 0x00b5  ; lcd_num:doloop
v____temp_96                   EQU 0x00b7  ; lcd_num:_temp
v____floop7_2                  EQU 0x00be  ; lcd_num:_floop7
v____rparam3_2                 EQU 0x00bf  ; lcd_num:_rparam3
v___side_30                    EQU 0x00c0  ; lcd_num:side
v____temp_97                   EQU 0x00c1  ; lcd_num:_temp
v___side_31                    EQU 0x00c0  ; lcd_num:side
v____temp_98                   EQU 0x00c1  ; lcd_num:_temp
v____rparam4_2                 EQU 0x00bf  ; lcd_num:_rparam4
v____rparam5_2                 EQU 0x00c0  ; lcd_num:_rparam5
v___side_32                    EQU 0x00c1  ; lcd_num:side
v____temp_99                   EQU 0x00c2  ; lcd_num:_temp
v___side_33                    EQU 0x00c1  ; lcd_num:side
v____temp_100                  EQU 0x00c2  ; lcd_num:_temp
v___x_128                      EQU 0x00ae  ; lcd_num:x
v___debug_4                    EQU 0x00ab  ; lcd_num:debug-->_bitbucket4:0
v___findex_3                   EQU 0x00af  ; lcd_num:findex
v___cx_3                       EQU 0x00b4  ; lcd_num:cx
v___doloop_3                   EQU 0x00b5  ; lcd_num:doloop
v____temp_101                  EQU 0x00b7  ; lcd_num:_temp
v____floop7_3                  EQU 0x00be  ; lcd_num:_floop7
v____rparam3_3                 EQU 0x00bf  ; lcd_num:_rparam3
v___side_34                    EQU 0x00c0  ; lcd_num:side
v____temp_102                  EQU 0x00c1  ; lcd_num:_temp
v___side_35                    EQU 0x00c0  ; lcd_num:side
v____temp_103                  EQU 0x00c1  ; lcd_num:_temp
v____rparam4_3                 EQU 0x00bf  ; lcd_num:_rparam4
v____rparam5_3                 EQU 0x00c0  ; lcd_num:_rparam5
v___side_36                    EQU 0x00c1  ; lcd_num:side
v____temp_104                  EQU 0x00c2  ; lcd_num:_temp
v___side_37                    EQU 0x00c1  ; lcd_num:side
v____temp_105                  EQU 0x00c2  ; lcd_num:_temp
v___x_129                      EQU 0x00ae  ; lcd_num:x
v___debug_5                    EQU 0x00ab  ; lcd_num:debug-->_bitbucket4:0
v___findex_4                   EQU 0x00af  ; lcd_num:findex
v___cx_4                       EQU 0x00b4  ; lcd_num:cx
v___doloop_4                   EQU 0x00b5  ; lcd_num:doloop
v____temp_106                  EQU 0x00b7  ; lcd_num:_temp
v____floop7_4                  EQU 0x00be  ; lcd_num:_floop7
v____rparam3_4                 EQU 0x00bf  ; lcd_num:_rparam3
v___side_38                    EQU 0x00c0  ; lcd_num:side
v____temp_107                  EQU 0x00c1  ; lcd_num:_temp
v___side_39                    EQU 0x00c0  ; lcd_num:side
v____temp_108                  EQU 0x00c1  ; lcd_num:_temp
v____rparam4_4                 EQU 0x00bf  ; lcd_num:_rparam4
v____rparam5_4                 EQU 0x00c0  ; lcd_num:_rparam5
v___side_40                    EQU 0x00c1  ; lcd_num:side
v____temp_109                  EQU 0x00c2  ; lcd_num:_temp
v___side_41                    EQU 0x00c1  ; lcd_num:side
v____temp_110                  EQU 0x00c2  ; lcd_num:_temp
v___x0_5                       EQU 0x0062  ; lcd_filled_rect:x0
v___y0_5                       EQU 0x0064  ; lcd_filled_rect:y0
v___x1_5                       EQU 0x0068  ; lcd_filled_rect:x1
v___y1_5                       EQU 0x006a  ; lcd_filled_rect:y1
v___state_1                    EQU 0x00ab  ; lcd_filled_rect:state-->_bitbucket9:0
v____temp_83                   EQU 0x006b  ; lcd_filled_rect:_temp
v_xdiff                        EQU 0x006f  ; lcd_filled_rect:xdiff
v_ydiff                        EQU 0x00a2  ; lcd_filled_rect:ydiff
v_currx                        EQU 0x00a3  ; lcd_filled_rect:currx
v_curry                        EQU 0x00a4  ; lcd_filled_rect:curry
v___write_2                    EQU 0x00ab  ; lcd_filled_rect:write-->_bitbucket9:1
v_area                         EQU 0x00a5  ; lcd_filled_rect:area
v__floop9                      EQU 0x00a8  ; lcd_filled_rect:_floop9
v____bitbucket_9               EQU 0x00ab  ; lcd_filled_rect:_bitbucket
v__btemp95                     EQU 0x00ab  ; lcd_filled_rect:_btemp95-->_bitbucket9:2
v__btemp96                     EQU 0x00ab  ; lcd_filled_rect:_btemp96-->_bitbucket9:3
v__btemp97                     EQU 0x00ab  ; lcd_filled_rect:_btemp97-->_bitbucket9:4
v__rparam8                     EQU 0x00b3  ; lcd_filled_rect:_rparam8
v__btemp99                     EQU 0x00ab  ; lcd_filled_rect:_btemp99-->_bitbucket9:6
v__btemp100                    EQU 0x00ab  ; lcd_filled_rect:_btemp100-->_bitbucket9:7
v__btemp101                    EQU 0x00ab  ; lcd_filled_rect:_btemp101-->_bitbucket9:8
v___x_123                      EQU 0x00b4  ; lcd_filled_rect:x
v___e1_1                       EQU 0x00ab  ; lcd_filled_rect:e1-->_bitbucket9:10
v___e3_1                       EQU 0x00ab  ; lcd_filled_rect:e3-->_bitbucket9:11
v___e4_1                       EQU 0x00ab  ; lcd_filled_rect:e4-->_bitbucket9:12
v___e2_1                       EQU 0x00ab  ; lcd_filled_rect:e2-->_bitbucket9:13
v____btemp77_1                 EQU 0x00ab  ; lcd_filled_rect:_btemp77-->_bitbucket9:14
v____temp_84                   EQU 0x00b5  ; lcd_filled_rect:_temp
v____btemp79_1                 EQU 0x00ab  ; lcd_filled_rect:_btemp79-->_bitbucket9:16
v____btemp83_1                 EQU 0x00ab  ; lcd_filled_rect:_btemp83-->_bitbucket9:20
v___data_22                    EQU 0x00bb  ; lcd_filled_rect:data
v___yy_3                       EQU 0x00bc  ; lcd_filled_rect:yy
v___side_25                    EQU 0x00bd  ; lcd_filled_rect:side
v____rparam6_1                 EQU 0x00be  ; lcd_filled_rect:_rparam6
v____temp_85                   EQU 0x00bf  ; lcd_filled_rect:_temp
v____temp_86                   EQU 0x00bf  ; lcd_filled_rect:_temp
v____temp_87                   EQU 0x00be  ; lcd_filled_rect:_temp
v___x0_1                       EQU 0x0062  ; lcd_line:x0
v___y0_1                       EQU 0x0064  ; lcd_line:y0
v___x1_1                       EQU 0x0068  ; lcd_line:x1
v___y1_1                       EQU 0x006a  ; lcd_line:y1
v___onoff_5                    EQU 0x00a7  ; lcd_line:onoff-->_bitbucket11:0
v_xi                           EQU 0x006b  ; lcd_line:xi
v_yi                           EQU 0x00a0  ; lcd_line:yi
v_xfark                        EQU 0x006f  ; lcd_line:xfark
v_yfark                        EQU 0x00a2  ; lcd_line:yfark
v_fark                         EQU 0x00a3  ; lcd_line:fark
v_xx                           EQU 0x00a4  ; lcd_line:xx
v__floop8                      EQU 0x00a5  ; lcd_line:_floop8
v____bitbucket_11              EQU 0x00a7  ; lcd_line:_bitbucket
v___x_122                      EQU 0x00a8  ; lcd_line:x
v___data_21                    EQU 0x00aa  ; lcd_line:data
v___yy_2                       EQU 0x00ab  ; lcd_line:yy
v___side_24                    EQU 0x00ae  ; lcd_line:side
v____temp_79                   EQU 0x00af  ; lcd_line:_temp
v____rparam0_1                 EQU 0x00b4  ; lcd_line:_rparam0
v____temp_80                   EQU 0x00b5  ; lcd_line:_temp
v____temp_81                   EQU 0x00b5  ; lcd_line:_temp
v____temp_82                   EQU 0x00b5  ; lcd_line:_temp
v____temp_74                   EQU 0       ; lcd_write_pixel_buff(): _temp
v___data_19                    EQU 0x0062  ; lcd_fill:data
v_i                            EQU 0x0064  ; lcd_fill:i
v__floop5                      EQU 0x0068  ; lcd_fill:_floop5
v__floop6                      EQU 0x006a  ; lcd_fill:_floop6
v___side_11                    EQU 0x006b  ; lcd_fill:side
v____temp_60                   EQU 0x00a0  ; lcd_fill:_temp
v___side_12                    EQU 0x006b  ; lcd_fill:side
v____temp_61                   EQU 0x00a0  ; lcd_fill:_temp
v___side_13                    EQU 0x006b  ; lcd_fill:side
v___column_2                   EQU 0x00a0  ; lcd_fill:column
v____temp_62                   EQU 0x006f  ; lcd_fill:_temp
v___side_14                    EQU 0x006b  ; lcd_fill:side
v___column_3                   EQU 0x00a0  ; lcd_fill:column
v____temp_63                   EQU 0x006f  ; lcd_fill:_temp
v____temp_57                   EQU 0       ; ks0108_read_byte(): _temp
v___x_110                      EQU 0x00c0  ; ks0108_write_byte:x
v___y_3                        EQU 0x00c1  ; ks0108_write_byte:y
v___veri_1                     EQU 0x00c2  ; ks0108_write_byte:veri
v___side_9                     EQU 0x00c3  ; ks0108_write_byte:side
v__rparam1                     EQU 0x00c5  ; ks0108_write_byte:_rparam1
v____temp_55                   EQU 0x00c6  ; ks0108_write_byte:_temp
v____temp_56                   EQU 0x00c6  ; ks0108_write_byte:_temp
v____temp_50                   EQU 0       ; lcd_write_pixel(): _temp
v___x_106                      EQU 0x0039  ; _ks0108_data:x-->_portc_shadow:5
v___x_105                      EQU 0x0039  ; _ks0108_inst:x-->_portc_shadow:5
v___side_3                     EQU 0x00c0  ; _ks0108_read:side
v___data_15                    EQU 0x00c1  ; _ks0108_read:data
v___x_98                       EQU 0x0039  ; _ks0108_read:x-->_portc_shadow:0
v___x_99                       EQU 0x0039  ; _ks0108_read:x-->_portc_shadow:1
v___x_100                      EQU 0x0039  ; _ks0108_read:x-->_portc_shadow:3
v___x_101                      EQU 0x0037  ; _ks0108_read:x-->_porta_shadow:5
v___x_102                      EQU 0x0037  ; _ks0108_read:x-->_porta_shadow:5
v___x_103                      EQU 0x0039  ; _ks0108_read:x-->_portc_shadow:1
v___x_104                      EQU 0x0039  ; _ks0108_read:x-->_portc_shadow:0
v___side_1                     EQU 0x00c7  ; _ks0108_write:side
v___data_14                    EQU 0x00c8  ; _ks0108_write:data
v___x_91                       EQU 0x0039  ; _ks0108_write:x-->_portc_shadow:0
v___x_92                       EQU 0x0039  ; _ks0108_write:x-->_portc_shadow:1
v___x_93                       EQU 0x0039  ; _ks0108_write:x-->_portc_shadow:3
v___x_94                       EQU 0x0037  ; _ks0108_write:x-->_porta_shadow:5
v___x_95                       EQU 0x0037  ; _ks0108_write:x-->_porta_shadow:5
v___x_96                       EQU 0x0039  ; _ks0108_write:x-->_portc_shadow:1
v___x_97                       EQU 0x0039  ; _ks0108_write:x-->_portc_shadow:0
v___b_1                        EQU 0x00c3  ; serial_hw_byte:b
v_zw                           EQU 0x00c6  ; serial_hw_byte:zw
v_oldb                         EQU 0x00c7  ; serial_hw_byte:oldb
v____temp_46                   EQU 0x00c8  ; serial_hw_byte:_temp
v__str_count                   EQU 0x0062  ; serial_hw_printf:_str_count
v___str_1                      EQU 0x0068  ; serial_hw_printf:str
v_l                            EQU 0x006b  ; serial_hw_printf:l
v_t                            EQU 0x00a0  ; serial_hw_printf:t
v___data_3                     EQU 0       ; serial_hw_write_word(): data
v___data_1                     EQU 0x00ca  ; serial_hw_write:data
v_usart_div                    EQU 259     ; _calculate_and_set_baudrate(): usart_div
v___duty_5                     EQU 0x0062  ; pwm1_set_dutycycle:duty
v____temp_40                   EQU 0x0064  ; pwm1_set_dutycycle:_temp
v___duty_1                     EQU 0x00a0  ; pwm1_set_dutycycle_highres:duty
v___prescaler_1                EQU 0x0062  ; pwm_max_resolution:prescaler
v___adc_chan_7                 EQU 0x0062  ; adc_read_low_res:adc_chan
v_adc_value                    EQU 0x0064  ; adc_read_low_res:adc_value
v_shift_alias                  EQU 0x0068  ; adc_read_low_res:shift_alias
v___ax_2                       EQU 0x0068  ; adc_read_low_res:ax-->shift_alias
v___ad_value_1                 EQU 0       ; adc_read_bytes(): ad_value
v____temp_34                   EQU 0       ; adc_read_bytes(): _temp
v___adc_chan_3                 EQU 0x0062  ; adc_read:adc_chan
v_ad_value                     EQU 0x0064  ; adc_read:ad_value
v_ax                           EQU 0x0064  ; adc_read:ax-->ad_value
v___adc_chan_1                 EQU 0x006b  ; _adc_read_low_res:adc_chan
v___adc_byte_1                 EQU 0x00a0  ; _adc_read_low_res:adc_byte
v___factor_1                   EQU 0x0062  ; _adc_eval_tad:factor
v_tad_ok                       EQU 0x006b  ; _adc_eval_tad:tad_ok-->_bitbucket64:0
v____temp_33                   EQU 0x0068  ; _adc_eval_tad:_temp
v__btemp29                     EQU 0x006b  ; _adc_eval_tad:_btemp29-->_bitbucket64:1
v__btemp30                     EQU 0x006b  ; _adc_eval_tad:_btemp30-->_bitbucket64:2
v__btemp31                     EQU 0x006b  ; _adc_eval_tad:_btemp31-->_bitbucket64:3
v____bitbucket_64              EQU 0x006b  ; _adc_eval_tad:_bitbucket
v___an_pin_num_1               EQU 0x0062  ; set_analog_pin:an_pin_num
v___n_3                        EQU 0x0062  ; delay_1ms:n
v__floop2                      EQU 0x0068  ; delay_1ms:_floop2
v___n_1                        EQU 0x006f  ; delay_10us:n
v__floop1                      EQU 0x00a2  ; delay_10us:_floop1
;    2 include 16f886
                               org      0
                               branchhi_clr l__pic_pre_user
                               branchlo_clr l__pic_pre_user
                               goto     l__pic_pre_user
                               nop      
l__lookup_myfonttable
                               movwf    v__pclath
                               movf     v__pic_loop,w
                               addlw    10
                               btfsc    v__status, v__c
                               incf     v__pclath,f
                               movwf    v__pcl
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    47
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    7
                               retlw    0
                               retlw    7
                               retlw    0
                               retlw    20
                               retlw    127
                               retlw    20
                               retlw    127
                               retlw    20
                               retlw    36
                               retlw    42
                               retlw    127
                               retlw    42
                               retlw    18
                               retlw    196
                               retlw    200
                               retlw    16
                               retlw    38
                               retlw    70
                               retlw    54
                               retlw    73
                               retlw    85
                               retlw    34
                               retlw    80
                               retlw    0
                               retlw    5
                               retlw    3
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    28
                               retlw    34
                               retlw    65
                               retlw    0
                               retlw    0
                               retlw    65
                               retlw    34
                               retlw    28
                               retlw    0
                               retlw    20
                               retlw    8
                               retlw    62
                               retlw    8
                               retlw    20
                               retlw    8
                               retlw    8
                               retlw    62
                               retlw    8
                               retlw    8
                               retlw    0
                               retlw    0
                               retlw    80
                               retlw    48
                               retlw    0
                               retlw    16
                               retlw    16
                               retlw    16
                               retlw    16
                               retlw    16
                               retlw    0
                               retlw    96
                               retlw    96
                               retlw    0
                               retlw    0
                               retlw    32
                               retlw    16
                               retlw    8
                               retlw    4
                               retlw    2
                               retlw    62
                               retlw    81
                               retlw    73
                               retlw    69
                               retlw    62
                               retlw    0
                               retlw    66
                               retlw    127
                               retlw    64
                               retlw    0
                               retlw    66
                               retlw    97
                               retlw    81
                               retlw    73
                               retlw    70
                               retlw    33
                               retlw    65
                               retlw    69
                               retlw    75
                               retlw    49
                               retlw    24
                               retlw    20
                               retlw    18
                               retlw    127
                               retlw    16
                               retlw    39
                               retlw    69
                               retlw    69
                               retlw    69
                               retlw    57
                               retlw    60
                               retlw    74
                               retlw    73
                               retlw    73
                               retlw    48
                               retlw    1
                               retlw    113
                               retlw    9
                               retlw    5
                               retlw    3
                               retlw    54
                               retlw    73
                               retlw    73
                               retlw    73
                               retlw    54
                               retlw    6
                               retlw    73
                               retlw    73
                               retlw    41
                               retlw    30
                               retlw    0
                               retlw    54
                               retlw    54
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    86
                               retlw    54
                               retlw    0
                               retlw    0
                               retlw    8
                               retlw    20
                               retlw    34
                               retlw    65
                               retlw    0
                               retlw    20
                               retlw    20
                               retlw    20
                               retlw    20
                               retlw    20
                               retlw    0
                               retlw    65
                               retlw    34
                               retlw    20
                               retlw    8
                               retlw    2
                               retlw    1
                               retlw    81
                               retlw    9
                               retlw    6
                               retlw    50
                               retlw    73
                               retlw    89
                               retlw    81
                               retlw    62
                               retlw    126
                               retlw    17
                               retlw    17
                               retlw    17
                               retlw    126
                               retlw    127
                               retlw    73
                               retlw    73
                               retlw    73
                               retlw    54
                               retlw    62
                               retlw    65
                               retlw    65
                               retlw    65
                               retlw    34
                               retlw    127
                               retlw    65
                               retlw    65
                               retlw    34
                               retlw    28
                               retlw    127
                               retlw    73
                               retlw    73
                               retlw    73
                               retlw    65
                               retlw    127
                               retlw    9
                               retlw    9
                               retlw    9
                               retlw    1
                               retlw    62
                               retlw    65
                               retlw    73
                               retlw    73
                               retlw    122
                               retlw    127
                               retlw    8
                               retlw    8
                               retlw    8
                               retlw    127
                               retlw    0
                               retlw    65
                               retlw    127
                               retlw    65
                               retlw    0
                               retlw    32
                               retlw    64
                               retlw    65
                               retlw    63
                               retlw    1
                               retlw    127
                               retlw    8
                               retlw    20
                               retlw    34
                               retlw    65
                               retlw    127
                               retlw    64
                               retlw    64
                               retlw    64
                               retlw    64
                               retlw    127
                               retlw    2
                               retlw    12
                               retlw    2
                               retlw    127
                               retlw    127
                               retlw    4
                               retlw    8
                               retlw    16
                               retlw    127
                               retlw    62
                               retlw    65
                               retlw    65
                               retlw    65
                               retlw    62
                               retlw    127
                               retlw    9
                               retlw    9
                               retlw    9
                               retlw    6
                               retlw    62
                               retlw    65
                               retlw    81
                               retlw    33
                               retlw    94
                               retlw    127
                               retlw    9
                               retlw    25
                               retlw    41
                               retlw    70
                               retlw    70
                               retlw    73
                               retlw    73
                               retlw    73
                               retlw    49
                               retlw    1
                               retlw    1
                               retlw    127
                               retlw    1
                               retlw    1
                               retlw    63
                               retlw    64
                               retlw    64
                               retlw    64
                               retlw    63
                               retlw    31
                               retlw    32
                               retlw    64
                               retlw    32
                               retlw    31
                               retlw    63
                               retlw    64
                               retlw    56
                               retlw    64
                               retlw    63
                               retlw    99
                               retlw    20
                               retlw    8
                               retlw    20
                               retlw    99
                               retlw    7
                               retlw    8
                               retlw    112
                               retlw    8
                               retlw    7
                               retlw    97
                               retlw    81
                               retlw    73
                               retlw    69
                               retlw    67
                               retlw    0
                               retlw    127
                               retlw    65
                               retlw    65
                               retlw    0
                               retlw    85
                               retlw    42
                               retlw    85
                               retlw    42
                               retlw    85
                               retlw    0
                               retlw    65
                               retlw    65
                               retlw    127
                               retlw    0
                               retlw    4
                               retlw    2
                               retlw    1
                               retlw    2
                               retlw    4
                               retlw    64
                               retlw    64
                               retlw    64
                               retlw    64
                               retlw    64
                               retlw    0
                               retlw    1
                               retlw    2
                               retlw    4
                               retlw    0
                               retlw    32
                               retlw    84
                               retlw    84
                               retlw    84
                               retlw    120
                               retlw    127
                               retlw    72
                               retlw    68
                               retlw    68
                               retlw    56
                               retlw    56
                               retlw    68
                               retlw    68
                               retlw    68
                               retlw    32
                               retlw    56
                               retlw    68
                               retlw    68
                               retlw    72
                               retlw    127
                               retlw    56
                               retlw    84
                               retlw    84
                               retlw    84
                               retlw    24
                               retlw    8
                               retlw    126
                               retlw    9
                               retlw    1
                               retlw    2
                               retlw    12
                               retlw    82
                               retlw    82
                               retlw    82
                               retlw    62
                               retlw    127
                               retlw    8
                               retlw    4
                               retlw    4
                               retlw    120
                               retlw    0
                               retlw    68
                               retlw    125
                               retlw    64
                               retlw    0
                               retlw    32
                               retlw    64
                               retlw    68
                               retlw    61
                               retlw    0
                               retlw    127
                               retlw    16
                               retlw    40
                               retlw    68
                               retlw    0
                               retlw    0
                               retlw    65
                               retlw    127
                               retlw    64
                               retlw    0
                               retlw    124
                               retlw    4
                               retlw    24
                               retlw    4
                               retlw    120
                               retlw    124
                               retlw    8
                               retlw    4
                               retlw    4
                               retlw    120
                               retlw    56
                               retlw    68
                               retlw    68
                               retlw    68
                               retlw    56
                               retlw    124
                               retlw    20
                               retlw    20
                               retlw    20
                               retlw    8
                               retlw    8
                               retlw    20
                               retlw    20
                               retlw    24
                               retlw    124
                               retlw    124
                               retlw    8
                               retlw    4
                               retlw    4
                               retlw    8
                               retlw    72
                               retlw    84
                               retlw    84
                               retlw    84
                               retlw    32
                               retlw    4
                               retlw    63
                               retlw    68
                               retlw    64
                               retlw    32
                               retlw    60
                               retlw    64
                               retlw    64
                               retlw    32
                               retlw    124
                               retlw    28
                               retlw    32
                               retlw    64
                               retlw    32
                               retlw    28
                               retlw    60
                               retlw    64
                               retlw    48
                               retlw    64
                               retlw    60
                               retlw    68
                               retlw    40
                               retlw    16
                               retlw    40
                               retlw    68
                               retlw    12
                               retlw    80
                               retlw    80
                               retlw    80
                               retlw    60
                               retlw    68
                               retlw    100
                               retlw    84
                               retlw    76
                               retlw    68
                               retlw    0
                               retlw    8
                               retlw    54
                               retlw    65
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    127
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    65
                               retlw    54
                               retlw    8
                               retlw    0
                               retlw    8
                               retlw    4
                               retlw    8
                               retlw    16
                               retlw    8
                               retlw    0
                               retlw    127
                               retlw    65
                               retlw    127
                               retlw    0
                               retlw    20
                               retlw    62
                               retlw    85
                               retlw    65
                               retlw    34
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    0
                               retlw    80
                               retlw    48
                               retlw    0
                               retlw    0
                               retlw    85
                               retlw    42
                               retlw    85
                               retlw    42
                               retlw    85
                               retlw    85
                               retlw    42
                               retlw    85
                               retlw    42
                               retlw    85
                               retlw    32
                               retlw    0
                               retlw    32
                               retlw    0
                               retlw    32
                               retlw    4
                               retlw    4
                               retlw    127
                               retlw    4
                               retlw    4
                               addwf    v__pcl,f
l__data_test3
                               retlw    111
                               retlw    112
                               retlw    113
                               retlw    114
                               retlw    115
                               retlw    116
                               retlw    117
                               retlw    118
                               retlw    119
                               retlw    120
                               retlw    121
                               retlw    122
                               retlw    48
                               retlw    49
                               retlw    50
                               retlw    51
                               retlw    52
                               retlw    53
                               retlw    54
                               retlw    55
                               addwf    v__pcl,f
l__data_test1
                               retlw    65
                               retlw    66
                               retlw    67
                               retlw    68
                               retlw    69
                               retlw    70
                               retlw    71
                               retlw    72
                               retlw    73
                               retlw    74
                               retlw    75
                               retlw    76
                               retlw    77
                               retlw    78
                               retlw    79
                               retlw    80
                               retlw    81
                               retlw    82
                               retlw    83
                               retlw    84
                               addwf    v__pcl,f
l__data_test2
                               retlw    85
                               retlw    86
                               retlw    87
                               retlw    88
                               retlw    89
                               retlw    90
                               retlw    97
                               retlw    98
                               retlw    99
                               retlw    100
                               retlw    101
                               retlw    102
                               retlw    103
                               retlw    104
                               retlw    105
                               retlw    106
                               retlw    107
                               retlw    108
                               retlw    109
                               retlw    110
                               addwf    v__pcl,f
l__data_test4
                               retlw    56
                               retlw    57
                               retlw    33
                               retlw    64
                               retlw    35
                               retlw    36
                               retlw    37
                               retlw    94
                               retlw    38
                               retlw    42
                               retlw    40
                               retlw    41
                               retlw    128
                               retlw    126
                               retlw    60
                               retlw    62
                               retlw    47
                               addwf    v__pcl,f
l__data_hewo
                               retlw    72
                               retlw    101
                               retlw    108
                               retlw    108
                               retlw    111
                               retlw    32
                               retlw    87
                               retlw    111
                               retlw    114
                               retlw    108
                               retlw    100
                               retlw    33
                               retlw    10
                               addwf    v__pcl,f
l__data_test5
                               retlw    124
                               retlw    91
                               retlw    93
                               retlw    123
                               retlw    125
                               retlw    42
                               retlw    45
                               retlw    43
                               retlw    44
                               retlw    46
                               retlw    58
                               retlw    59
                               retlw    63
                               addwf    v__pcl,f
l__data_adcte
                               retlw    76
                               retlw    105
                               retlw    99
                               retlw    104
                               retlw    116
                               retlw    115
                               retlw    101
                               retlw    110
                               retlw    115
                               retlw    111
                               retlw    114
                               retlw    58
                               addwf    v__pcl,f
l__data_version
                               retlw    86
                               retlw    48
                               retlw    46
                               retlw    48
                               retlw    46
                               retlw    54
                               retlw    10
                               addwf    v__pcl,f
l__data_done
                               retlw    68
                               retlw    111
                               retlw    110
                               retlw    101
                               retlw    33
                               retlw    10
l__pic_multiply
                               movlw    16
                               movwf    v__pic_loop
l__l1071
                               bcf      v__status, v__c
                               rlf      v__pic_mresult,f
                               rlf      v__pic_mresult+1,f
                               bcf      v__status, v__c
                               rlf      v__pic_multiplier,f
                               rlf      v__pic_multiplier+1,f
                               btfss    v__status, v__c
                               goto     l__l1072
                               movf     v__pic_multiplicand+1,w
                               addwf    v__pic_mresult+1,f
                               movf     v__pic_multiplicand,w
                               addwf    v__pic_mresult,f
                               btfsc    v__status, v__c
                               incf     v__pic_mresult+1,f
l__l1072
                               decfsz   v__pic_loop,f
                               goto     l__l1071
                               return   
l__pic_divide
                               movlw    32
                               movwf    v__pic_loop
                               clrf     v__pic_remainder
                               clrf     v__pic_remainder+1
                               clrf     v__pic_remainder+2
                               clrf     v__pic_remainder+3
l__l1073
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
                               goto     l__l1076
                               movf     v__pic_remainder+2,w
                               subwf    v__pic_divisor+2,w
                               btfss    v__status, v__z
                               goto     l__l1076
                               movf     v__pic_remainder+1,w
                               subwf    v__pic_divisor+1,w
                               btfss    v__status, v__z
                               goto     l__l1076
                               movf     v__pic_remainder,w
                               subwf    v__pic_divisor,w
l__l1076
                               btfsc    v__status, v__z
                               goto     l__l1075
                               btfsc    v__status, v__c
                               goto     l__l1074
l__l1075
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
l__l1074
                               decfsz   v__pic_loop,f
                               goto     l__l1073
                               return   
l__pic_memset
l__l1077
                               movwf    v__ind
                               incf     v__fsr,f
                               decfsz   v__pic_loop,f
                               goto     l__l1077
                               return   
l__pic_indirect
                               movwf    v__pclath
                               movf     v__pic_pointer,w
                               movwf    v__pcl
l__pic_pre_user
                               bcf      v__status, v__irp
                               movlw    55
                               movwf    v__fsr
                               movlw    57
                               movwf    v__pic_loop
                               movlw    0
                               call     l__pic_memset
                               bcf      v__status, v__irp
                               movlw    160
                               movwf    v__fsr
                               movlw    43
                               datalo_clr v__pic_loop
                               datahi_clr v__pic_loop
                               movwf    v__pic_loop
                               movlw    0
                               branchlo_clr l__pic_memset
                               branchhi_clr l__pic_memset
                               call     l__pic_memset
                               branchlo_clr l__main
                               branchhi_clr l__main
l__main
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;   97 var          byte  _PORTA_shadow        = PORTA
                               datalo_clr v_porta
                               datahi_clr v_porta
                               movf     v_porta,w
                               movwf    v__porta_shadow
;  217 var          byte  _PORTB_shadow        = PORTB
                               movf     v_portb,w
                               movwf    v__portb_shadow
;  332 var          byte  _PORTC_shadow        = PORTC
                               movf     v_portc,w
                               movwf    v__portc_shadow
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;    3 enable_digital_io() 
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
; 1026    ANSEL  = 0b0000_0000       -- all digital
                               datalo_set v_ansel
                               datahi_set v_ansel
                               clrf     v_ansel
; 1027    ANSELH = 0b0000_0000       -- all digital
                               clrf     v_anselh
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;    3 enable_digital_io() 
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
; 1050    analog_off()
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;    3 enable_digital_io() 
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
; 1034    ADCON0 = 0b0000_0000         -- disable ADC
                               datalo_clr v_adcon0
                               datahi_clr v_adcon0
                               clrf     v_adcon0
; 1035    ADCON1 = 0b0000_0000
                               datalo_set v_adcon1
                               clrf     v_adcon1
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;    3 enable_digital_io() 
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
; 1051    adc_off()
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;    3 enable_digital_io() 
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
; 1042    CM1CON0 = 0b0000_0000       -- disable comparator
                               datalo_clr v_cm1con0
                               datahi_set v_cm1con0
                               clrf     v_cm1con0
; 1043    CM2CON0 = 0b0000_0000       -- disable 2nd comparator
                               clrf     v_cm2con0
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;    3 enable_digital_io() 
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
; 1052    comparator_off()
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;    3 enable_digital_io() 
; D:\My Documents\My Dropbox\Elektronica\glcd/delay.jal
;   26 procedure delay_1us() is
                               goto     l__l399
;   83 procedure delay_10us(byte in n) is
l_delay_10us
                               movwf    v___n_1
;   84    if n==0 then
                               movf     v___n_1,w
                               btfsc    v__status, v__z
;   85       return
                               return   
;   86    elsif n==1 then
l__l204
                               movlw    1
                               subwf    v___n_1,w
                               btfss    v__status, v__z
                               goto     l__l205
;   89        _usec_delay(_ten_us_delay1)
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    10
                               movwf    v__pic_temp
                               branchhi_clr l__l1078
                               branchlo_clr l__l1078
l__l1078
                               decfsz   v__pic_temp,f
                               goto     l__l1078
;   90      end if
                               return   
;   91    else     
l__l205
;   92       n = n - 1;
                               decf     v___n_1,f
;   95          _usec_delay(_ten_us_delay2)   
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    6
                               movwf    v__pic_temp
                               branchhi_clr l__l1079
                               branchlo_clr l__l1079
l__l1079
                               decfsz   v__pic_temp,f
                               goto     l__l1079
                               nop      
                               nop      
;  101       for n loop
                               datalo_set v__floop1
                               clrf     v__floop1
                               goto     l__l211
l__l210
;  103             _usec_delay(_ten_us_delay3)
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    13
                               movwf    v__pic_temp
                               branchhi_clr l__l1080
                               branchlo_clr l__l1080
l__l1080
                               decfsz   v__pic_temp,f
                               goto     l__l1080
                               nop      
;  107       end loop
                               datalo_set v__floop1
                               incf     v__floop1,f
l__l211
                               movf     v__floop1,w
                               datalo_clr v___n_1
                               subwf    v___n_1,w
                               btfss    v__status, v__z
                               goto     l__l210
;  108    end if
l__l203
;  110 end procedure
l__l202
                               return   
;  113 procedure delay_1ms(word in n) is
l_delay_1ms
;  115    for n loop
                               clrf     v__floop2
                               clrf     v__floop2+1
                               goto     l__l218
l__l217
;  117          _usec_delay(_one_ms_delay)
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    6
                               movwf    v__pic_temp
l__l1081
                               movlw    165
                               movwf    v__pic_temp+1
l__l1082
                               branchhi_clr l__l1082
                               branchlo_clr l__l1082
                               decfsz   v__pic_temp+1,f
                               goto     l__l1082
                               branchhi_clr l__l1081
                               branchlo_clr l__l1081
                               decfsz   v__pic_temp,f
                               goto     l__l1081
                               nop      
;  121    end loop
                               incf     v__floop2,f
                               btfsc    v__status, v__z
                               incf     v__floop2+1,f
l__l218
                               movf     v__floop2,w
                               subwf    v___n_3,w
                               movwf    v__pic_temp
                               movf     v__floop2+1,w
                               subwf    v___n_3+1,w
                               iorwf    v__pic_temp,w
                               btfss    v__status, v__z
                               goto     l__l217
;  122 end procedure
                               return   
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc_channels.jal
;  120 end procedure
l__l240
; 2916    _debug "ADC channels config: independent pins, via ANS bits"
; 2948    procedure _adc_setup_pins() is
l__adc_setup_pins
; 2949    end procedure
                               return   
; 2958    procedure set_analog_pin(byte in an_pin_num) is
l_set_analog_pin
                               movwf    v___an_pin_num_1
; 2960          if an_pin_num == 0 then
                               movf     v___an_pin_num_1,w
                               btfss    v__status, v__z
                               goto     l__l248
; 2961             JANSEL_ANS0 = true
                               datalo_set v_ansel ; jansel_ans0
                               datahi_set v_ansel ; jansel_ans0
                               bsf      v_ansel, 0 ; jansel_ans0
; 2962             pin_AN0_direction = input
                               datahi_clr v_trisa ; pin_a0_direction
                               bsf      v_trisa, 0 ; pin_a0_direction
; 2963          end if
; 2964       end if
l__l248
; 2966          if an_pin_num == 1 then
                               movlw    1
                               datalo_clr v___an_pin_num_1
                               subwf    v___an_pin_num_1,w
                               btfss    v__status, v__z
                               goto     l__l252
; 2967             JANSEL_ANS1 = true
                               datalo_set v_ansel ; jansel_ans1
                               datahi_set v_ansel ; jansel_ans1
                               bsf      v_ansel, 1 ; jansel_ans1
; 2968             pin_AN1_direction = input
                               datahi_clr v_trisa ; pin_a1_direction
                               bsf      v_trisa, 1 ; pin_a1_direction
; 2969          end if
; 2970       end if
l__l252
; 2972          if an_pin_num == 2 then
                               movlw    2
                               datalo_clr v___an_pin_num_1
                               subwf    v___an_pin_num_1,w
                               btfss    v__status, v__z
                               goto     l__l256
; 2973             JANSEL_ANS2 = true
                               datalo_set v_ansel ; jansel_ans2
                               datahi_set v_ansel ; jansel_ans2
                               bsf      v_ansel, 2 ; jansel_ans2
; 2974             pin_AN2_direction = input
                               datahi_clr v_trisa ; pin_a2_direction
                               bsf      v_trisa, 2 ; pin_a2_direction
; 2975          end if
; 2976       end if
l__l256
; 2978          if an_pin_num == 3 then
                               movlw    3
                               datalo_clr v___an_pin_num_1
                               subwf    v___an_pin_num_1,w
                               btfss    v__status, v__z
                               goto     l__l260
; 2979             JANSEL_ANS3 = true
                               datalo_set v_ansel ; jansel_ans3
                               datahi_set v_ansel ; jansel_ans3
                               bsf      v_ansel, 3 ; jansel_ans3
; 2980             pin_AN3_direction = input
                               datahi_clr v_trisa ; pin_a3_direction
                               bsf      v_trisa, 3 ; pin_a3_direction
; 2981          end if
; 2982       end if
l__l260
; 2984          if an_pin_num == 4 then
                               movlw    4
                               datalo_clr v___an_pin_num_1
                               subwf    v___an_pin_num_1,w
                               btfss    v__status, v__z
                               goto     l__l264
; 2985             JANSEL_ANS4 = true
                               datalo_set v_ansel ; jansel_ans4
                               datahi_set v_ansel ; jansel_ans4
                               bsf      v_ansel, 4 ; jansel_ans4
; 2986             pin_AN4_direction = input
                               datahi_clr v_trisa ; pin_a5_direction
                               bsf      v_trisa, 5 ; pin_a5_direction
; 2987          end if
; 2988       end if
l__l264
; 3008          if an_pin_num == 8 then
                               movlw    8
                               datalo_clr v___an_pin_num_1
                               subwf    v___an_pin_num_1,w
                               btfss    v__status, v__z
                               goto     l__l271
; 3009             JANSEL_ANS8 = true
                               datalo_set v_anselh ; jansel_ans8
                               datahi_set v_anselh ; jansel_ans8
                               bsf      v_anselh, 0 ; jansel_ans8
; 3010             pin_AN8_direction = input
                               bsf      v_trisb, 2 ; pin_b2_direction
; 3011          end if
; 3012       end if
l__l271
; 3014          if an_pin_num == 9 then
                               movlw    9
                               datalo_clr v___an_pin_num_1
                               datahi_clr v___an_pin_num_1
                               subwf    v___an_pin_num_1,w
                               btfss    v__status, v__z
                               goto     l__l275
; 3015             JANSEL_ANS9 = true
                               datalo_set v_anselh ; jansel_ans9
                               datahi_set v_anselh ; jansel_ans9
                               bsf      v_anselh, 1 ; jansel_ans9
; 3016             pin_AN9_direction = input
                               bsf      v_trisb, 3 ; pin_b3_direction
; 3017          end if
; 3018       end if
l__l275
; 3020          if an_pin_num == 10 then
                               movlw    10
                               datalo_clr v___an_pin_num_1
                               datahi_clr v___an_pin_num_1
                               subwf    v___an_pin_num_1,w
                               btfss    v__status, v__z
                               goto     l__l279
; 3021             JANSEL_ANS10 = true
                               datalo_set v_anselh ; jansel_ans10
                               datahi_set v_anselh ; jansel_ans10
                               bsf      v_anselh, 2 ; jansel_ans10
; 3022             pin_AN10_direction = input
                               bsf      v_trisb, 1 ; pin_b1_direction
; 3023          end if
; 3024       end if
l__l279
; 3026          if an_pin_num == 11 then
                               movlw    11
                               datalo_clr v___an_pin_num_1
                               datahi_clr v___an_pin_num_1
                               subwf    v___an_pin_num_1,w
                               btfss    v__status, v__z
                               goto     l__l283
; 3027             JANSEL_ANS11 = true
                               datalo_set v_anselh ; jansel_ans11
                               datahi_set v_anselh ; jansel_ans11
                               bsf      v_anselh, 3 ; jansel_ans11
; 3028             pin_AN11_direction = input
                               bsf      v_trisb, 4 ; pin_b4_direction
; 3029          end if
; 3030       end if
l__l283
; 3032          if an_pin_num == 12 then
                               movlw    12
                               datalo_clr v___an_pin_num_1
                               datahi_clr v___an_pin_num_1
                               subwf    v___an_pin_num_1,w
                               btfss    v__status, v__z
                               goto     l__l287
; 3033             JANSEL_ANS12 = true
                               datalo_set v_anselh ; jansel_ans12
                               datahi_set v_anselh ; jansel_ans12
                               bsf      v_anselh, 4 ; jansel_ans12
; 3034             pin_AN12_direction = input
                               bsf      v_trisb, 0 ; pin_b0_direction
; 3035          end if
; 3036       end if
l__l287
; 3038          if an_pin_num == 13 then
                               movlw    13
                               datalo_clr v___an_pin_num_1
                               datahi_clr v___an_pin_num_1
                               subwf    v___an_pin_num_1,w
                               btfss    v__status, v__z
                               goto     l__l291
; 3039             JANSEL_ANS13 = true
                               datalo_set v_anselh ; jansel_ans13
                               datahi_set v_anselh ; jansel_ans13
                               bsf      v_anselh, 5 ; jansel_ans13
; 3040             pin_AN13_direction = input
                               bsf      v_trisb, 5 ; pin_b5_direction
; 3041          end if
; 3042       end if
l__l291
; 3130    end procedure
                               return   
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc_clock.jal
;   31 function _adc_eval_tad(word in factor) return bit is
l__adc_eval_tad
;   42    var bit tad_ok = false
                               bcf      v____bitbucket_64, 0 ; tad_ok
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
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               movwf    v____temp_33
                               movf     v__pic_mresult+1,w
                               movwf    v____temp_33+1
                               movlw    20
                               movwf    v__pic_divisor
                               clrf     v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               movf     v____temp_33,w
                               movwf    v__pic_dividend
                               movf     v____temp_33+1,w
                               movwf    v__pic_dividend+1
                               clrf     v__pic_dividend+2
                               clrf     v__pic_dividend+3
                               branchlo_clr l__pic_divide
                               branchhi_clr l__pic_divide
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               movwf    v_tad_value
;   44    if tad_value >= ADC_MIN_TAD & tad_value < ADC_MAX_TAD then
                               movlw    16
                               subwf    v_tad_value,w
                               bcf      v____bitbucket_64, 1 ; _btemp29
                               btfss    v__status, v__z
                               btfsc    v__status, v__c
                               bsf      v____bitbucket_64, 1 ; _btemp29
                               movlw    60
                               subwf    v_tad_value,w
                               bcf      v____bitbucket_64, 2 ; _btemp30
                               branchlo_clr l__l1085
                               branchhi_clr l__l1085
                               btfsc    v__status, v__z
                               goto     l__l1085
                               btfss    v__status, v__c
                               bsf      v____bitbucket_64, 2 ; _btemp30
l__l1085
                               bsf      v____bitbucket_64, 3 ; _btemp31
                               btfsc    v____bitbucket_64, 1 ; _btemp29
                               btfss    v____bitbucket_64, 2 ; _btemp30
                               bcf      v____bitbucket_64, 3 ; _btemp31
                               btfsc    v____bitbucket_64, 3 ; _btemp31
;   45 	  tad_ok = true
                               bsf      v____bitbucket_64, 0 ; tad_ok
;   46    end if
l__l383
;   47    return tad_ok
                               bcf      v__pic_temp, 0 ; _pic_temp
                               btfsc    v____bitbucket_64, 0 ; tad_ok
                               bsf      v__pic_temp, 0 ; _pic_temp
;   48 end function
                               return   
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc.jal
;   55 end if
l__l399
;   72 var volatile byte _adcon0_shadow = 0
                               datahi_clr v__adcon0_shadow
                               clrf     v__adcon0_shadow
;   77 procedure _adc_read_low_res(byte in adc_chan, byte out adc_byte) is
                               goto     l__l474
l__adc_read_low_res
                               movwf    v___adc_chan_1
;   79    ADCON0_CHS = adc_chan
                               rlf      v___adc_chan_1,w
                               movwf    v__pic_temp
                               rlf      v__pic_temp,f
                               movlw    60
                               andwf    v__pic_temp,f
                               movlw    195
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
                               datahi_clr v_adcon0 ; adcon0_go
                               bsf      v_adcon0, 1 ; adcon0_go
;   83    while ADCON0_GO loop end loop     -- wait till conversion finished
l__l405
                               branchlo_clr l__l406
                               branchhi_clr l__l406
                               btfss    v_adcon0, 1 ; adcon0_go
                               goto     l__l406
                               goto     l__l405
l__l406
;   90       adc_byte = ADRESH                  -- read high byte 
                               movf     v_adresh,w
                               datalo_set v___adc_byte_1
                               movwf    v___adc_byte_1
;   98    if tad_value >= (ADC_MAX_TAD + ADC_MIN_TAD) / 2 then
                               movlw    38
                               datalo_clr v_tad_value
                               subwf    v_tad_value,w
                               btfsc    v__status, v__z
                               goto     l__l1089
                               btfss    v__status, v__c
                               goto     l__l411
l__l1089
;   99       _usec_delay(2 * ADC_MAX_TAD)
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    198
                               movwf    v__pic_temp
                               branchhi_clr l__l1090
                               branchlo_clr l__l1090
l__l1090
                               decfsz   v__pic_temp,f
                               goto     l__l1090
                               nop      
;  100    else
                               goto     l__l410
l__l411
;  101       _usec_delay(2 * ADC_MIN_TAD)
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    51
                               movwf    v__pic_temp
                               branchhi_clr l__l1091
                               branchlo_clr l__l1091
l__l1091
                               decfsz   v__pic_temp,f
                               goto     l__l1091
                               nop      
                               nop      
;  102    end if
l__l410
;  103    ADCON0_ADON = false               -- turn off ADC module
                               bcf      v_adcon0, 0 ; adcon0_adon
;  104 end procedure
                               datalo_set v___adc_byte_1
                               movf     v___adc_byte_1,w
                               return   
;  110 function adc_read(byte in adc_chan) return word is
l_adc_read
                               datalo_clr v___adc_chan_3
                               datahi_clr v___adc_chan_3
                               movwf    v___adc_chan_3
;  115       _adc_read_low_res(adc_chan,ax[1])   -- do conversion and get high byte  
                               movf     v___adc_chan_3,w
                               call     l__adc_read_low_res
                               datalo_clr v_ax+1
                               datahi_clr v_ax+1
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
;  143 function adc_read_low_res(byte in adc_chan) return byte is
l_adc_read_low_res
                               movwf    v___adc_chan_7
;  150       _adc_read_low_res(adc_chan,ax[1])
                               movf     v___adc_chan_7,w
                               call     l__adc_read_low_res
                               datalo_clr v___ax_2+1
                               datahi_clr v___ax_2+1
                               movwf    v___ax_2+1
;  151       ax[0] = ADRESL
                               datalo_set v_adresl
                               movf     v_adresl,w
                               datalo_clr v___ax_2
                               movwf    v___ax_2
;  153 	  shift_alias = shift_alias >> 2
                               bcf      v__status, v__c
                               rrf      v_shift_alias+1,f
                               rrf      v_shift_alias,f
                               bcf      v__status, v__c
                               rrf      v_shift_alias+1,f
                               rrf      v_shift_alias,f
;  154 	  adc_value = ax[0]
                               movf     v___ax_2,w
                               movwf    v_adc_value
;  156    return adc_value
                               movf     v_adc_value,w
;  157 end function
                               return   
;  266    end if
l__l474
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc.jal
;  253    _adc_setup_pins()    -- conditionally defined according to PIC
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc_channels.jal
;   46    var byte vcfg_shadow = ADC_NVREF
                               clrf     v___vcfg_shadow_3
;   57       ADCON1_VCFG = vcfg_shadow
                               swapf    v___vcfg_shadow_3,w
                               movwf    v__pic_temp
                               movlw    48
                               andwf    v__pic_temp,f
                               movlw    207
                               datalo_set v_adcon1
                               andwf    v_adcon1,w
                               datalo_clr v__pic_temp
                               iorwf    v__pic_temp,w
                               datalo_set v_adcon1
                               movwf    v_adcon1
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc.jal
;  190 	  JALLIB_ADFM = 1
                               bsf      v_adcon1, 7 ; adcon1_adfm
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc_clock.jal
;  116    var volatile bit*3 adcs = 0b_000
                               movlw    127
                               datalo_clr v__bitbucket
                               andwf    v__bitbucket,f
                               movlw    252
                               andwf    v__bitbucket+1,f
;  135 	  if _adc_eval_tad(32) == true then
                               movlw    32
                               movwf    v___factor_1
                               clrf     v___factor_1+1
                               call     l__adc_eval_tad
                               datalo_clr v__bitbucket+1 ; _btemp322
                               datahi_clr v__bitbucket+1 ; _btemp322
                               bcf      v__bitbucket+1, 2 ; _btemp322
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v__bitbucket+1, 2 ; _btemp322
                               branchlo_clr l__l494
                               branchhi_clr l__l494
                               btfss    v__bitbucket+1, 2 ; _btemp322
                               goto     l__l494
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc_clock.jal
;  136 		 adcs = 0b_010
                               movlw    127
                               andwf    v__bitbucket,f
                               movlw    252
                               andwf    v__bitbucket+1,w
                               iorlw    1
                               movwf    v__bitbucket+1
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc_clock.jal
;  137 	  elsif _adc_eval_tad(8) == true then
                               goto     l__l497
l__l494
                               movlw    8
                               movwf    v___factor_1
                               clrf     v___factor_1+1
                               call     l__adc_eval_tad
                               datalo_clr v__bitbucket+1 ; _btemp342
                               datahi_clr v__bitbucket+1 ; _btemp342
                               bcf      v__bitbucket+1, 4 ; _btemp342
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v__bitbucket+1, 4 ; _btemp342
                               branchlo_clr l__l495
                               branchhi_clr l__l495
                               btfss    v__bitbucket+1, 4 ; _btemp342
                               goto     l__l495
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc_clock.jal
;  138 		 adcs = 0b_001
                               movlw    127
                               andwf    v__bitbucket,w
                               iorlw    128
                               movwf    v__bitbucket
                               movlw    252
                               andwf    v__bitbucket+1,f
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc_clock.jal
;  139 	  elsif _adc_eval_tad(2) == true then
                               goto     l__l497
l__l495
                               movlw    2
                               movwf    v___factor_1
                               clrf     v___factor_1+1
                               call     l__adc_eval_tad
                               datalo_clr v__bitbucket+1 ; _btemp362
                               datahi_clr v__bitbucket+1 ; _btemp362
                               bcf      v__bitbucket+1, 6 ; _btemp362
                               btfsc    v__pic_temp, 0 ; _pic_temp
                               bsf      v__bitbucket+1, 6 ; _btemp362
                               branchlo_clr l__l496
                               branchhi_clr l__l496
                               btfss    v__bitbucket+1, 6 ; _btemp362
                               goto     l__l496
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc_clock.jal
;  140 		 adcs = 0b_000
                               movlw    127
                               andwf    v__bitbucket,f
                               movlw    252
                               andwf    v__bitbucket+1,f
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc_clock.jal
;  141 	  end if
l__l496
l__l497
;  154 	  jallib_adcs_lsb = adcs_lsb
                               rrf      v__bitbucket+1,w
                               movwf    v__pic_temp+2
                               rrf      v__bitbucket,w
                               movwf    v__pic_temp+1
                               movlw    6
                               movwf    v__pic_temp+3
l__l1092
                               rrf      v__pic_temp+2,f
                               rrf      v__pic_temp+1,f
                               decfsz   v__pic_temp+3,f
                               goto     l__l1092
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
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc.jal
;  270    _adc_init_clock()
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc.jal
;  243    adc_conversion_delay = 2 + adc_tc + adc_tcoff   -- Tamp seems to be a constant: 2usecs
                               movlw    16
                               movwf    v_adc_conversion_delay
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
; D:\My Documents\My Dropbox\Elektronica\glcd/adc/adc.jal
;  271    _adc_init_acquisition_delay()
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   28 adc_init()                                      -- init library
;   29 set_analog_pin(ADC_CHANNEL_A)                   -- init used ADC channel
                               movlw    0
                               call     l_set_analog_pin
;   33 pin_CCP1_direction = output
                               datalo_set v_trisc ; pin_c2_direction
                               datahi_clr v_trisc ; pin_c2_direction
                               bcf      v_trisc, 2 ; pin_c2_direction
; D:\My Documents\My Dropbox\Elektronica\glcd/pwm/pwm_common.jal
;   23 var volatile word _pr2_shadow_plus1 = 256           -- value(PR2) + 1
                               datalo_clr v__pr2_shadow_plus1
                               clrf     v__pr2_shadow_plus1
                               movlw    1
                               movwf    v__pr2_shadow_plus1+1
;   50 procedure pwm_max_resolution(byte in prescaler) is
                               branchlo_clr l__l511
                               branchhi_clr l__l511
                               goto     l__l511
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
                               goto     l__l508
;   57       T2CON_T2CKPS = 0b00                       -- prescaler 1:1
                               movlw    252
                               andwf    v_t2con,f
;   58       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on
;   59    elsif prescaler == 4  then
                               return   
l__l508
                               movlw    4
                               subwf    v___prescaler_1,w
                               btfss    v__status, v__z
                               goto     l__l509
;   60       T2CON_T2CKPS = 0b01                       -- prescaler 1:4
                               movlw    252
                               andwf    v_t2con,w
                               iorlw    1
                               movwf    v_t2con
;   61       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on
;   62    elsif prescaler == 16 then
                               return   
l__l509
                               movlw    16
                               subwf    v___prescaler_1,w
                               btfss    v__status, v__z
                               goto     l__l510
;   63       T2CON_T2CKPS = 0b10                       -- prescaler 1:16
                               movlw    252
                               andwf    v_t2con,w
                               iorlw    2
                               movwf    v_t2con
;   64       T2CON_TMR2ON = TRUE
                               bsf      v_t2con, 2 ; t2con_tmr2on
;   65    else
                               return   
l__l510
;   66       T2CON_TMR2ON = FALSE                      -- disable Timer2 (= PWM off!)
                               bcf      v_t2con, 2 ; t2con_tmr2on
;   67    end if
l__l507
;   69 end procedure
                               return   
;  105 end procedure
l__l511
; D:\My Documents\My Dropbox\Elektronica\glcd/pwm/pwm_ccp1.jal
;   23 var byte  _ccpr1l_shadow  = 0                            -- 8 MSbits of duty cycle
                               clrf     v__ccpr1l_shadow
;   24 var byte  _ccp1con_shadow = 0b0000_0000                  -- shadow
                               clrf     v__ccp1con_shadow
;   32 procedure pwm1_on() is
                               goto     l__l518
l_pwm1_on
;   34    _ccp1con_shadow_ccp1m = 0b1100                    -- set PWM mode
                               movlw    240
                               datalo_clr v__ccp1con_shadow
                               datahi_clr v__ccp1con_shadow
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
                               goto     l__l1093
                               movlw    255
                               subwf    v___duty_1,w
l__l1093
                               btfsc    v__status, v__z
                               goto     l__l527
                               btfss    v__status, v__c
                               goto     l__l527
;   60       duty = 1023
                               movlw    255
                               movwf    v___duty_1
                               movlw    3
                               movwf    v___duty_1+1
;   61    end if
l__l527
;   62    _ccpr1l_shadow = byte(duty >> 2)
                               bcf      v__status, v__c
                               rrf      v___duty_1+1,w
                               datalo_clr v__pic_temp
                               movwf    v__pic_temp+1
                               datalo_set v___duty_1
                               rrf      v___duty_1,w
                               datalo_clr v__pic_temp
                               movwf    v__pic_temp
                               bcf      v__status, v__c
                               rrf      v__pic_temp+1,f
                               rrf      v__pic_temp,f
                               movf     v__pic_temp,w
                               movwf    v__ccpr1l_shadow
;   63    _ccp1con_shadow_dc1b = byte(duty) & 0b11
                               movlw    3
                               datalo_set v___duty_1
                               andwf    v___duty_1,w
                               datalo_clr v__pic_temp
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
                               movwf    v____temp_40
                               clrf     v____temp_40+1
                               bcf      v__status, v__c
                               rlf      v____temp_40,w
                               movwf    v____temp_40+2
                               rlf      v____temp_40+1,w
                               movwf    v____temp_40+3
                               bcf      v__status, v__c
                               rlf      v____temp_40+2,f
                               rlf      v____temp_40+3,f
                               movf     v____temp_40+2,w
                               datalo_set v___duty_1
                               movwf    v___duty_1
                               datalo_clr v____temp_40+2
                               movf     v____temp_40+3,w
                               datalo_set v___duty_1
                               movwf    v___duty_1+1
                               goto     l_pwm1_set_dutycycle_highres
;  102 end procedure
; D:\My Documents\My Dropbox\Elektronica\glcd/pwm/pwm_hardware.jal
;   51 end if
l__l518
; D:\My Documents\My Dropbox\Elektronica\glcd/pwm/pwm_ccp2.jal
;   23 var byte  _ccpr2l_shadow  = 0                            -- 8 MSbits of duty cycle
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   35 pwm_max_resolution(1)
                               movlw    1
                               call     l_pwm_max_resolution
;   36 pwm1_on()
                               branchlo_clr l_pwm1_on
                               branchhi_clr l_pwm1_on
                               call     l_pwm1_on
; D:\My Documents\My Dropbox\Elektronica\glcd/usart_common.jal
;   43 procedure _calculate_and_set_baudrate() is
                               branchlo_clr l__l622
                               branchhi_clr l__l622
                               goto     l__l622
l__calculate_and_set_baudrate
;   49          BAUDCTL_BRG16 = true
                               datalo_set v_baudctl ; baudctl_brg16
                               datahi_set v_baudctl ; baudctl_brg16
                               bsf      v_baudctl, 3 ; baudctl_brg16
;   50          TXSTA_BRGH = true
                               datahi_clr v_txsta ; txsta_brgh
                               bsf      v_txsta, 2 ; txsta_brgh
;   65          SPBRG = byte(usart_div)
                               movlw    3
                               movwf    v_spbrg
;   66          SPBRGH = byte(usart_div >> 8)
                               movlw    1
                               movwf    v_spbrgh
;  152 end procedure
                               return   
; D:\My Documents\My Dropbox\Elektronica\glcd/serial_hardware.jal
;   25 procedure serial_hw_init() is 
l_serial_hw_init
;   27    _calculate_and_set_baudrate()
                               call     l__calculate_and_set_baudrate
;   30    PIE1_RCIE = false
                               datalo_set v_pie1 ; pie1_rcie
                               datahi_clr v_pie1 ; pie1_rcie
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
                               datalo_set v___data_1
                               datahi_clr v___data_1
                               movwf    v___data_1
;   69    while ! PIR1_TXIF loop end loop
l__l577
                               datalo_clr v_pir1 ; pir1_txif
                               btfsc    v_pir1, 4 ; pir1_txif
                               goto     l__l578
                               goto     l__l577
l__l578
;   71    TXREG = data
                               datalo_set v___data_1
                               movf     v___data_1,w
                               datalo_clr v_txreg
                               movwf    v_txreg
;   72 end procedure
                               return   
;  177 procedure serial_hw_printf(byte in str[]) is
l_serial_hw_printf
;  184     l=count(str)
                               movf     v__str_count,w
                               movwf    v_l
;  185     for l using t loop
                               datalo_set v_t
                               clrf     v_t
                               goto     l__l620
l__l619
;  187         serial_hw_write(str[t])
                               movf     v___str_1+1,w
                               movwf    v__pic_pointer+1
                               datalo_set v_t
                               movf     v_t,w
                               datalo_clr v___str_1
                               addwf    v___str_1,w
                               movwf    v__pic_pointer
                               btfsc    v__status, v__c
                               incf     v__pic_pointer+1,f
                               bcf      v__pic_pointer+1, 6
                               movf     v__pic_pointer+1,w
                               call     l__pic_indirect
                               branchlo_clr l_serial_hw_write
                               branchhi_clr l_serial_hw_write
                               call     l_serial_hw_write
;  188     end loop
                               datalo_set v_t
                               datahi_clr v_t
                               incf     v_t,f
l__l620
                               movf     v_t,w
                               datalo_clr v_l
                               subwf    v_l,w
                               branchlo_clr l__l619
                               branchhi_clr l__l619
                               btfss    v__status, v__z
                               goto     l__l619
;  189 end procedure
                               return   
;  191 procedure serial_hw_byte(word in b) is
l_serial_hw_byte
;  197     oldb=b;
                               movf     v___b_1,w
                               movwf    v_oldb
;  198     zw=b/100;                               -- One hundreds
                               movlw    100
                               datalo_clr v__pic_divisor
                               movwf    v__pic_divisor
                               clrf     v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               datalo_set v___b_1
                               movf     v___b_1,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend
                               datalo_set v___b_1
                               movf     v___b_1+1,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend+1
                               clrf     v__pic_dividend+2
                               clrf     v__pic_dividend+3
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               datalo_set v_zw
                               movwf    v_zw
;  199     if (oldb>=100) then serial_hw_write(zw+0x30) else serial_hw_write(32) end if;
                               movlw    100
                               subwf    v_oldb,w
                               branchlo_clr l__l1096
                               branchhi_clr l__l1096
                               btfsc    v__status, v__z
                               goto     l__l1096
                               btfss    v__status, v__c
                               goto     l__l625
l__l1096
                               movlw    48
                               addwf    v_zw,w
                               movwf    v____temp_46
                               movf     v____temp_46,w
                               call     l_serial_hw_write
                               branchlo_clr l__l624
                               branchhi_clr l__l624
                               goto     l__l624
l__l625
                               movlw    32
                               call     l_serial_hw_write
l__l624
;  200     b=b-zw*100;                             -- Tens
                               datalo_set v_zw
                               datahi_clr v_zw
                               movf     v_zw,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier
                               clrf     v__pic_multiplier+1
                               movlw    100
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               branchhi_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               datalo_set v____temp_46
                               movwf    v____temp_46
                               movf     v____temp_46,w
                               subwf    v___b_1,f
                               btfss    v__status, v__c
                               decf     v___b_1+1,f
;  201     zw=b/10;
                               movlw    10
                               datalo_clr v__pic_divisor
                               movwf    v__pic_divisor
                               clrf     v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               datalo_set v___b_1
                               movf     v___b_1,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend
                               datalo_set v___b_1
                               movf     v___b_1+1,w
                               datalo_clr v__pic_dividend
                               movwf    v__pic_dividend+1
                               clrf     v__pic_dividend+2
                               clrf     v__pic_dividend+3
                               branchlo_clr l__pic_divide
                               branchhi_clr l__pic_divide
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               datalo_set v_zw
                               movwf    v_zw
;  202     if (oldb>=10) then serial_hw_write(zw+0x30)  else serial_hw_write(32) end if;
                               movlw    10
                               subwf    v_oldb,w
                               branchlo_clr l__l1098
                               branchhi_clr l__l1098
                               btfsc    v__status, v__z
                               goto     l__l1098
                               btfss    v__status, v__c
                               goto     l__l627
l__l1098
                               movlw    48
                               addwf    v_zw,w
                               movwf    v____temp_46
                               movf     v____temp_46,w
                               call     l_serial_hw_write
                               branchlo_clr l__l626
                               branchhi_clr l__l626
                               goto     l__l626
l__l627
                               movlw    32
                               call     l_serial_hw_write
l__l626
;  203     b=b-zw*10;                              -- Singles
                               datalo_set v_zw
                               datahi_clr v_zw
                               movf     v_zw,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier
                               clrf     v__pic_multiplier+1
                               movlw    10
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               branchhi_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               datalo_set v____temp_46
                               movwf    v____temp_46
                               movf     v____temp_46,w
                               subwf    v___b_1,f
                               btfss    v__status, v__c
                               decf     v___b_1+1,f
;  204     serial_hw_write(b+0x30);
                               movf     v___b_1+1,w
                               movwf    v____temp_46+1
                               movlw    48
                               addwf    v___b_1,w
                               movwf    v____temp_46
                               btfsc    v__status, v__c
                               incf     v____temp_46+1,f
                               movf     v____temp_46,w
                               branchlo_clr l_serial_hw_write
                               branchhi_clr l_serial_hw_write
                               goto     l_serial_hw_write
;  205 end procedure
l__l622
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   43 Serial_HW_init
                               call     l_serial_hw_init
;   45 serial_hw_printf(hewo)
                               movlw    13
                               datalo_clr v__str_count
                               datahi_clr v__str_count
                               movwf    v__str_count
                               clrf     v__str_count+1
                               movlw    l__data_hewo
                               movwf    v___str_1
                               movlw    HIGH l__data_hewo
                               iorlw    64
                               movwf    v___str_1+1
                               branchlo_clr l_serial_hw_printf
                               branchhi_clr l_serial_hw_printf
                               call     l_serial_hw_printf
;   46 serial_hw_printf(version)
                               movlw    7
                               datalo_clr v__str_count
                               datahi_clr v__str_count
                               movwf    v__str_count
                               clrf     v__str_count+1
                               movlw    l__data_version
                               movwf    v___str_1
                               movlw    HIGH l__data_version
                               iorlw    64
                               movwf    v___str_1+1
                               branchlo_clr l_serial_hw_printf
                               branchhi_clr l_serial_hw_printf
                               call     l_serial_hw_printf
;   49 var byte pwmValue	=	0
                               datalo_clr v_pwmvalue
                               datahi_clr v_pwmvalue
                               clrf     v_pwmvalue
;   50 while pwmValue != 255 loop
l__l628
                               movlw    255
                               datalo_clr v_pwmvalue
                               datahi_clr v_pwmvalue
                               subwf    v_pwmvalue,w
                               branchlo_set l__l930
                               branchhi_clr l__l930
                               btfsc    v__status, v__z
                               goto     l__l930
;   51 	pwm1_set_dutycycle(pwmValue)
                               movf     v_pwmvalue,w
                               branchlo_clr l_pwm1_set_dutycycle
                               call     l_pwm1_set_dutycycle
;   52 	pwmValue = pwmValue + 1
                               datalo_clr v_pwmvalue
                               datahi_clr v_pwmvalue
                               incf     v_pwmvalue,f
;   53 	delay_1ms(10)
                               movlw    10
                               movwf    v___n_3
                               clrf     v___n_3+1
                               branchlo_clr l_delay_1ms
                               branchhi_clr l_delay_1ms
                               call     l_delay_1ms
;   54 end loop
                               branchlo_clr l__l628
                               branchhi_clr l__l628
                               goto     l__l628
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   43 procedure _ks0108_write(byte in side, byte in data) is
l__ks0108_write
                               datalo_set v___side_1
                               movwf    v___side_1
;   44    if side == 1 then          -- Choose which side to write to
                               movlw    1
                               subwf    v___side_1,w
                               btfss    v__status, v__z
                               goto     l__l634
;   45       GLCD_CS2 = high
                               datalo_clr v__portc_shadow ; x91
                               bsf      v__portc_shadow, 0 ; x91
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   45       GLCD_CS2 = high
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  440    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   45       GLCD_CS2 = high
;   46    else
                               goto     l__l633
l__l634
;   47       GLCD_CS1 = high
                               datalo_clr v__portc_shadow ; x92
                               bsf      v__portc_shadow, 1 ; x92
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   47       GLCD_CS1 = high
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  430    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   47       GLCD_CS1 = high
;   48    end if
l__l633
;   49    GLCD_RW = low        -- Set for writing
                               bcf      v__portc_shadow, 3 ; x93
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   49    GLCD_RW = low        -- Set for writing
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  410    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   49    GLCD_RW = low        -- Set for writing
;   50    GLCD_DATAPRT = data     -- Put the data on the port
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  225    _PORTB_shadow = x
                               datalo_set v___data_14
                               movf     v___data_14,w
                               datalo_clr v__portb_shadow
                               movwf    v__portb_shadow
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   50    GLCD_DATAPRT = data     -- Put the data on the port
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  221    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w
                               movwf    v_portb
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   50    GLCD_DATAPRT = data     -- Put the data on the port
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  226    _PORTB_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   50    GLCD_DATAPRT = data     -- Put the data on the port
;   51    GLCD_DATAPRT_DIR = all_output
                               datalo_set v_portb_direction
                               clrf     v_portb_direction
;   53    asm nop asm nop      -- delay_cycles(1)
                               nop      
                               nop      
;   54    GLCD_E = high        -- Pulse the enable pin
                               datalo_clr v__porta_shadow ; x94
                               bsf      v__porta_shadow, 5 ; x94
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  101    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w
                               movwf    v_porta
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   54    GLCD_E = high        -- Pulse the enable pin
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  157    _PORTA_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   54    GLCD_E = high        -- Pulse the enable pin
;   55    delay_2us()
; D:\My Documents\My Dropbox\Elektronica\glcd/delay.jal
;   34   _usec_delay(2)
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   55    delay_2us()
;   57    GLCD_E = low
                               bcf      v__porta_shadow, 5 ; x95
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  101    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w
                               movwf    v_porta
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   57    GLCD_E = low
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  157    _PORTA_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   57    GLCD_E = low
;   58    GLCD_CS1 = low       -- Reset the chip select lines
                               bcf      v__portc_shadow, 1 ; x96
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   58    GLCD_CS1 = low       -- Reset the chip select lines
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  430    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   58    GLCD_CS1 = low       -- Reset the chip select lines
;   59    GLCD_CS2 = low
                               bcf      v__portc_shadow, 0 ; x97
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   59    GLCD_CS2 = low
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  440    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   59    GLCD_CS2 = low
;   60    delay_2us()
; D:\My Documents\My Dropbox\Elektronica\glcd/delay.jal
;   34   _usec_delay(2)
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   60    delay_2us()
;   62 end procedure
                               return   
;   69 function _ks0108_read(byte in side) return byte  is
l__ks0108_read
                               movwf    v___side_3
;   71    GLCD_DATAPRT_DIR = all_input           -- Set port d to input
                               movlw    255
                               movwf    v_portb_direction
;   73    if side == 1 then     -- Choose which side to write to
                               movlw    1
                               subwf    v___side_3,w
                               btfss    v__status, v__z
                               goto     l__l656
;   74       GLCD_CS2 = high
                               datalo_clr v__portc_shadow ; x98
                               bsf      v__portc_shadow, 0 ; x98
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   74       GLCD_CS2 = high
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  440    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   74       GLCD_CS2 = high
;   75    else
                               goto     l__l655
l__l656
;   76       GLCD_CS1 = high
                               datalo_clr v__portc_shadow ; x99
                               bsf      v__portc_shadow, 1 ; x99
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   76       GLCD_CS1 = high
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  430    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   76       GLCD_CS1 = high
;   77    end if
l__l655
;   78    GLCD_RW = high       -- Set for reading
                               bsf      v__portc_shadow, 3 ; x100
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   78    GLCD_RW = high       -- Set for reading
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  410    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   78    GLCD_RW = high       -- Set for reading
;   80    asm nop  asm nop     --  delay_cycles(1)
                               nop      
                               nop      
;   81    GLCD_E = high        -- Pulse the enable pin
                               bsf      v__porta_shadow, 5 ; x101
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  101    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w
                               movwf    v_porta
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   81    GLCD_E = high        -- Pulse the enable pin
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  157    _PORTA_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   81    GLCD_E = high        -- Pulse the enable pin
;   83    delay_2us()
; D:\My Documents\My Dropbox\Elektronica\glcd/delay.jal
;   34   _usec_delay(2)
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   83    delay_2us()
;   84    data = GLCD_DATAPRT     -- Get the data from the display's output register
                               movf     v_portb,w
                               datalo_set v___data_15
                               movwf    v___data_15
;   85    GLCD_E = low
                               datalo_clr v__porta_shadow ; x102
                               bcf      v__porta_shadow, 5 ; x102
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  101    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w
                               movwf    v_porta
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   85    GLCD_E = low
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  157    _PORTA_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   85    GLCD_E = low
;   87    GLCD_CS1 = low       -- Reset the chip select lines
                               bcf      v__portc_shadow, 1 ; x103
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   87    GLCD_CS1 = low       -- Reset the chip select lines
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  430    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   87    GLCD_CS1 = low       -- Reset the chip select lines
;   88    GLCD_CS2 = low
                               bcf      v__portc_shadow, 0 ; x104
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   88    GLCD_CS2 = low
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  440    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   88    GLCD_CS2 = low
;   89    delay_2us()
; D:\My Documents\My Dropbox\Elektronica\glcd/delay.jal
;   34   _usec_delay(2)
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
                               nop      
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;   89    delay_2us()
;   91    return data          -- Return the read data
                               datalo_set v___data_15
                               movf     v___data_15,w
;   92 end function
                               return   
;   98 procedure lcd_on() is
l_lcd_on
;   99     _ks0108_write(KS0108_LEFT,  KS0108_CMD_ON)
                               movlw    63
                               datalo_set v___data_14
                               datahi_clr v___data_14
                               movwf    v___data_14
                               movlw    0
                               call     l__ks0108_write
;  100     _ks0108_write(KS0108_RIGHT, KS0108_CMD_ON)
                               movlw    63
                               datalo_set v___data_14
                               datahi_clr v___data_14
                               movwf    v___data_14
                               movlw    1
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               goto     l__ks0108_write
;  101 end procedure
;  136 procedure _ks0108_inst() is     
l__ks0108_inst
;  137    GLCD_DI = low
                               datalo_clr v__portc_shadow ; x105
                               datahi_clr v__portc_shadow ; x105
                               bcf      v__portc_shadow, 5 ; x105
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  137    GLCD_DI = low
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  390    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  137    GLCD_DI = low
;  138 end procedure
                               return   
;  144 procedure  _ks0108_data() is
l__ks0108_data
;  145    GLCD_DI = high
                               datalo_clr v__portc_shadow ; x106
                               datahi_clr v__portc_shadow ; x106
                               bsf      v__portc_shadow, 5 ; x106
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  145    GLCD_DI = high
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  390    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  145    GLCD_DI = high
;  146 end procedure
                               return   
;  194 procedure ks0108_write_byte(byte in x, byte in y, byte in veri) is
l_ks0108_write_byte
                               movwf    v___x_110
;  195    var byte side = KS0108_LEFT   -- Stores which chip to use on the LCD
                               clrf     v___side_9
;  197    if x > 63 then                -- Check for first or second display area
                               movlw    63
                               subwf    v___x_110,w
                               btfsc    v__status, v__z
                               goto     l__l701
                               btfss    v__status, v__c
                               goto     l__l701
;  198       x = x - 64
                               movlw    64
                               subwf    v___x_110,f
;  199       side = KS0108_RIGHT
                               movlw    1
                               movwf    v___side_9
;  200    end if
l__l701
;  203     _ks0108_inst()                -- Set for instruction
                               call     l__ks0108_inst
;  204     _ks0108_column(side,x)        -- Set the horizontal address
                               movlw    64
                               datalo_set v___x_110
                               datahi_clr v___x_110
                               iorwf    v___x_110,w
                               movwf    v____temp_55
                               movf     v____temp_55,w
                               movwf    v___data_14
                               movf     v___side_9,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
                               bcf      v__status, v__c
                               datalo_set v___y_3
                               datahi_clr v___y_3
                               rrf      v___y_3,w
                               movwf    v__rparam1
                               bcf      v__status, v__c
                               rrf      v__rparam1,f
                               bcf      v__status, v__c
                               rrf      v__rparam1,f
                               movlw    184
                               iorwf    v__rparam1,w
                               movwf    v____temp_56
                               movf     v____temp_56,w
                               movwf    v___data_14
                               movf     v___side_9,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
                               datalo_set v___veri_1
                               datahi_clr v___veri_1
                               movf     v___veri_1,w
                               movwf    v___data_14
                               movf     v___side_9,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               goto     l__ks0108_write
l_lcd_fill
                               datalo_clr v___data_19
                               datahi_clr v___data_19
                               movwf    v___data_19
                               clrf     v_i
                               clrf     v__floop5
l__l712
                               call     l__ks0108_inst
                               datalo_clr v___side_11
                               datahi_clr v___side_11
                               clrf     v___side_11
                               movlw    184
                               iorwf    v_i,w
                               datalo_set v____temp_60
                               movwf    v____temp_60
                               movf     v____temp_60,w
                               movwf    v___data_14
                               datalo_clr v___side_11
                               movf     v___side_11,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
                               movlw    1
                               datalo_clr v___side_12
                               datahi_clr v___side_12
                               movwf    v___side_12
                               movlw    184
                               iorwf    v_i,w
                               datalo_set v____temp_61
                               movwf    v____temp_61
                               movf     v____temp_61,w
                               movwf    v___data_14
                               datalo_clr v___side_12
                               movf     v___side_12,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
                               datalo_clr v___side_13
                               datahi_clr v___side_13
                               clrf     v___side_13
                               datalo_set v___column_2
                               clrf     v___column_2
                               movlw    64
                               iorwf    v___column_2,w
                               datalo_clr v____temp_62
                               movwf    v____temp_62
                               movf     v____temp_62,w
                               datalo_set v___data_14
                               movwf    v___data_14
                               datalo_clr v___side_13
                               movf     v___side_13,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
                               movlw    1
                               datalo_clr v___side_14
                               datahi_clr v___side_14
                               movwf    v___side_14
                               datalo_set v___column_3
                               clrf     v___column_3
                               movlw    64
                               iorwf    v___column_3,w
                               datalo_clr v____temp_63
                               movwf    v____temp_63
                               movf     v____temp_63,w
                               datalo_set v___data_14
                               movwf    v___data_14
                               datalo_clr v___side_14
                               movf     v___side_14,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
                               datalo_clr v__floop6
                               datahi_clr v__floop6
                               clrf     v__floop6
l__l719
                               movf     v___data_19,w
                               datalo_set v___data_14
                               movwf    v___data_14
                               movlw    0
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
                               datalo_clr v___data_19
                               datahi_clr v___data_19
                               movf     v___data_19,w
                               datalo_set v___data_14
                               movwf    v___data_14
                               movlw    1
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
                               datalo_clr v__floop6
                               datahi_clr v__floop6
                               incf     v__floop6,f
                               movlw    64
                               subwf    v__floop6,w
                               branchlo_clr l__l719
                               branchhi_clr l__l719
                               btfss    v__status, v__z
                               goto     l__l719
                               incf     v_i,f
                               incf     v__floop5,f
                               movlw    8
                               subwf    v__floop5,w
                               btfss    v__status, v__z
                               goto     l__l712
                               return   
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   25 procedure lcd_line(byte in x0, byte in y0, byte in x1, byte in y1, bit in onoff) is
l_lcd_line
                               movwf    v___x0_1
;   28    xi = x0
                               movf     v___x0_1,w
                               movwf    v_xi
;   29    yi = y0
                               movf     v___y0_1,w
                               datalo_set v_yi
                               movwf    v_yi
;   30    if x1 >= x0  then  xfark = x1 - x0 else  xfark = x0 - x1 end if
                               datalo_clr v___x1_1
                               movf     v___x1_1,w
                               subwf    v___x0_1,w
                               btfsc    v__status, v__z
                               goto     l__l1102
                               btfsc    v__status, v__c
                               goto     l__l774
l__l1102
                               movf     v___x0_1,w
                               subwf    v___x1_1,w
                               movwf    v_xfark
                               goto     l__l773
l__l774
                               movf     v___x1_1,w
                               subwf    v___x0_1,w
                               movwf    v_xfark
l__l773
;   31    if y1 >= y0  then  yfark = y1 - y0 else  yfark = y0 - y1 end if
                               movf     v___y1_1,w
                               subwf    v___y0_1,w
                               btfsc    v__status, v__z
                               goto     l__l1104
                               btfsc    v__status, v__c
                               goto     l__l776
l__l1104
                               movf     v___y0_1,w
                               subwf    v___y1_1,w
                               datalo_set v_yfark
                               movwf    v_yfark
                               goto     l__l775
l__l776
                               movf     v___y1_1,w
                               subwf    v___y0_1,w
                               datalo_set v_yfark
                               movwf    v_yfark
l__l775
;   33    if xfark >= yfark then fark = xfark else fark = yfark end if
                               datalo_clr v_xfark
                               movf     v_xfark,w
                               datalo_set v_yfark
                               subwf    v_yfark,w
                               btfsc    v__status, v__z
                               goto     l__l1106
                               btfsc    v__status, v__c
                               goto     l__l778
l__l1106
                               datalo_clr v_xfark
                               movf     v_xfark,w
                               datalo_set v_fark
                               movwf    v_fark
                               goto     l__l777
l__l778
                               movf     v_yfark,w
                               movwf    v_fark
l__l777
;   34    xx = 0
                               clrf     v_xx
;   35    for fark loop
                               clrf     v__floop8
                               branchlo_set l__l780
                               goto     l__l780
l__l779
;   36       lcd_write_pixel ( xi, yi ,onoff)
                               datalo_clr v_xi
                               movf     v_xi,w
                               datalo_set v___x_122
                               movwf    v___x_122
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  159    var byte side = KS0108_LEFT   -- Stores which chip to use on the LCD
                               clrf     v___side_24
;  161    if x > 63 then                -- Check for first or second display area
                               movlw    63
                               subwf    v___x_122,w
                               btfsc    v__status, v__z
                               goto     l__l782
                               btfss    v__status, v__c
                               goto     l__l782
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  162       x = x - 64
                               movlw    64
                               subwf    v___x_122,f
;  163       side = KS0108_RIGHT
                               movlw    1
                               movwf    v___side_24
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  164    end if
l__l782
;  166    _ks0108_inst()                 -- Set for instruction
                               call     l__ks0108_inst
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  129    _ks0108_write(side, KS0108_CMD_COLUMN | column)
                               movlw    64
                               datalo_set v___x_122
                               datahi_clr v___x_122
                               iorwf    v___x_122,w
                               movwf    v____temp_80
                               movf     v____temp_80,w
                               movwf    v___data_14
                               movf     v___side_24,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  167    _ks0108_column(side,x)         -- Set the horizontal address
;  168    _ks0108_page(side,(y / 8))     -- Set the page address
                               bcf      v__status, v__c
                               datalo_set v_yi
                               datahi_clr v_yi
                               rrf      v_yi,w
                               movwf    v____rparam0_1
                               bcf      v__status, v__c
                               rrf      v____rparam0_1,f
                               bcf      v__status, v__c
                               rrf      v____rparam0_1,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  119    _ks0108_write(side, KS0108_CMD_PAGE | page)
                               movlw    184
                               iorwf    v____rparam0_1,w
                               movwf    v____temp_81
                               movf     v____temp_81,w
                               movwf    v___data_14
                               movf     v___side_24,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  168    _ks0108_page(side,(y / 8))     -- Set the page address
;  169    _ks0108_data()                 -- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  170    data = _ks0108_read(side)      -- ignore; need two reads to get data at new address
                               datalo_set v___side_24
                               datahi_clr v___side_24
                               movf     v___side_24,w
                               branchlo_clr l__ks0108_read
                               branchhi_clr l__ks0108_read
                               call     l__ks0108_read
                               datalo_set v___data_21
                               datahi_clr v___data_21
                               movwf    v___data_21
;  171    data = _ks0108_read(side)      -- actual data
                               movf     v___side_24,w
                               branchlo_clr l__ks0108_read
                               branchhi_clr l__ks0108_read
                               call     l__ks0108_read
                               datalo_set v___data_21
                               datahi_clr v___data_21
                               movwf    v___data_21
;  173    if onoff == 1 then
                               branchlo_set l__l786
                               branchhi_clr l__l786
                               btfss    v____bitbucket_11, 0 ; onoff5
                               goto     l__l786
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  175       yy = y % 8
                               movlw    7
                               andwf    v_yi,w
                               movwf    v___yy_2
;  176       data = data | ( 1 << yy )
                               movf     v___yy_2,w
                               movwf    v__pic_accum
                               movlw    1
                               movwf    v____temp_79
                               movf     v__pic_accum,w
                               goto     l__l1110
l__l1109
                               bcf      v__status, v__c
                               rlf      v____temp_79,f
                               decf     v__pic_accum,f
l__l1110
                               btfss    v__status, v__z
                               goto     l__l1109
                               movf     v____temp_79,w
                               iorwf    v___data_21,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  177    else                        -- or
                               goto     l__l787
l__l786
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  179       yy = y % 8
                               movlw    7
                               andwf    v_yi,w
                               movwf    v___yy_2
;  180       data = data & !( 1 << yy )
                               movf     v___yy_2,w
                               movwf    v__pic_accum
                               movlw    1
                               movwf    v____temp_79
                               movf     v__pic_accum,w
                               goto     l__l1112
l__l1111
                               bcf      v__status, v__c
                               rlf      v____temp_79,f
                               decf     v__pic_accum,f
l__l1112
                               btfss    v__status, v__z
                               goto     l__l1111
                               comf     v____temp_79,w
                               movwf    v____temp_79+1
                               movf     v____temp_79+1,w
                               andwf    v___data_21,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  181    end if
l__l787
;  182    _ks0108_inst()              -- Set for instruction
                               branchlo_clr l__ks0108_inst
                               call     l__ks0108_inst
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  129    _ks0108_write(side, KS0108_CMD_COLUMN | column)
                               movlw    64
                               datalo_set v___x_122
                               datahi_clr v___x_122
                               iorwf    v___x_122,w
                               movwf    v____temp_82
                               movf     v____temp_82,w
                               movwf    v___data_14
                               movf     v___side_24,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  183    _ks0108_column(side,x)         -- Set the horizontal address
;  184    _ks0108_data()              -- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  185    _ks0108_write(side, data)       -- Write the pixel data
                               datalo_set v___data_21
                               datahi_clr v___data_21
                               movf     v___data_21,w
                               movwf    v___data_14
                               movf     v___side_24,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   36       lcd_write_pixel ( xi, yi ,onoff)
;   37       if xx < xfark then
                               datalo_set v_xx
                               datahi_clr v_xx
                               movf     v_xx,w
                               datalo_clr v_xfark
                               subwf    v_xfark,w
                               branchlo_set l__l791
                               branchhi_clr l__l791
                               btfsc    v__status, v__z
                               goto     l__l791
                               btfss    v__status, v__c
                               goto     l__l791
;   38           if x1 >= x0 then xi = xi + 1 else xi = xi - 1 end if
                               movf     v___x1_1,w
                               subwf    v___x0_1,w
                               btfsc    v__status, v__z
                               goto     l__l1116
                               btfsc    v__status, v__c
                               goto     l__l793
l__l1116
                               incf     v_xi,f
                               goto     l__l790
l__l793
                               decf     v_xi,f
;   39       end if
l__l791
l__l790
;   40       if xx < yfark then
                               datalo_set v_xx
                               movf     v_xx,w
                               subwf    v_yfark,w
                               btfsc    v__status, v__z
                               goto     l__l795
                               btfss    v__status, v__c
                               goto     l__l795
;   41           if y1 >= y0 then yi = yi + 1 else yi = yi - 1 end if
                               datalo_clr v___y1_1
                               movf     v___y1_1,w
                               subwf    v___y0_1,w
                               btfsc    v__status, v__z
                               goto     l__l1120
                               btfsc    v__status, v__c
                               goto     l__l797
l__l1120
                               datalo_set v_yi
                               incf     v_yi,f
                               goto     l__l794
l__l797
                               datalo_set v_yi
                               decf     v_yi,f
;   42       end if
l__l795
l__l794
;   43       xx = xx + 1
                               incf     v_xx,f
;   44    end loop
                               incf     v__floop8,f
l__l780
                               movf     v__floop8,w
                               subwf    v_fark,w
                               branchlo_clr l__l779
                               btfss    v__status, v__z
                               goto     l__l779
;   45 end procedure
                               return   
;   58 procedure lcd_filled_rect(byte in x0, byte in y0, byte in x1, byte in y1, bit in state) is
l_lcd_filled_rect
                               movwf    v___x0_5
;   59 	var byte xDiff = x1 - x0
                               movf     v___x0_5,w
                               subwf    v___x1_5,w
                               movwf    v_xdiff
;   60 	var byte yDiff = y1 - y0
                               movf     v___y0_5,w
                               subwf    v___y1_5,w
                               datalo_set v_ydiff
                               movwf    v_ydiff
;   61 	var byte currX = 0
                               clrf     v_currx
;   62 	var byte currY = 0
                               clrf     v_curry
;   65 	var word area = xDiff * yDiff
                               datalo_clr v_xdiff
                               movf     v_xdiff,w
                               movwf    v__pic_multiplier
                               clrf     v__pic_multiplier+1
                               datalo_set v_ydiff
                               movf     v_ydiff,w
                               datalo_clr v__pic_multiplicand
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               datalo_set v_area
                               movwf    v_area
                               datalo_clr v__pic_mresult
                               movf     v__pic_mresult+1,w
                               datalo_set v_area
                               movwf    v_area+1
;   67 	for area loop
                               clrf     v__floop9
                               clrf     v__floop9+1
                               branchlo_set l__l803
                               branchhi_clr l__l803
                               goto     l__l803
l__l802
;   68 		if (currY == yDiff) & (currX == xDiff) then
                               datalo_set v_curry
                               movf     v_curry,w
                               subwf    v_ydiff,w
                               bcf      v____bitbucket_9, 2 ; _btemp95
                               btfsc    v__status, v__z
                               bsf      v____bitbucket_9, 2 ; _btemp95
                               movf     v_currx,w
                               datalo_clr v_xdiff
                               subwf    v_xdiff,w
                               datalo_set v____bitbucket_9 ; _btemp96
                               bcf      v____bitbucket_9, 3 ; _btemp96
                               btfsc    v__status, v__z
                               bsf      v____bitbucket_9, 3 ; _btemp96
                               bsf      v____bitbucket_9, 4 ; _btemp97
                               btfsc    v____bitbucket_9, 2 ; _btemp95
                               btfss    v____bitbucket_9, 3 ; _btemp96
                               bcf      v____bitbucket_9, 4 ; _btemp97
                               btfss    v____bitbucket_9, 4 ; _btemp97
                               goto     l__l806
;   69 			write = 1
                               bsf      v____bitbucket_9, 1 ; write2
;   70 		else
                               goto     l__l805
l__l806
;   71 			write = 0
                               bcf      v____bitbucket_9, 1 ; write2
;   72 		end if
l__l805
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
                               movf     v_currx,w
                               datalo_clr v___x0_5
                               addwf    v___x0_5,w
                               movwf    v____temp_83
                               datalo_set v_curry
                               movf     v_curry,w
                               datalo_clr v___y0_5
                               addwf    v___y0_5,w
                               movwf    v____temp_83+1
                               movf     v____temp_83+1,w
                               datalo_set v__rparam8
                               movwf    v__rparam8
                               datalo_clr v____temp_83
                               movf     v____temp_83,w
                               datalo_set v___x_123
                               movwf    v___x_123
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  471 	e1 = !(buffX == x)		-- If the X is different than that of the buffer
                               datalo_clr v_buffx
                               movf     v_buffx,w
                               datalo_set v___x_123
                               subwf    v___x_123,w
                               bcf      v____bitbucket_9+1, 6 ; _btemp771
                               btfsc    v__status, v__z
                               bsf      v____bitbucket_9+1, 6 ; _btemp771
                               btfsc    v____bitbucket_9+1, 6 ; _btemp771
                               bcf      v____bitbucket_9+1, 2 ; e11
                               btfss    v____bitbucket_9+1, 6 ; _btemp771
                               bsf      v____bitbucket_9+1, 2 ; e11
;  472 	e2 = !(buffY == (y/8))	-- If the Y is out of the buffer range
                               bcf      v__status, v__c
                               rrf      v__rparam8,w
                               movwf    v____temp_84
                               bcf      v__status, v__c
                               rrf      v____temp_84,f
                               bcf      v__status, v__c
                               rrf      v____temp_84,f
                               datalo_clr v_buffy
                               movf     v_buffy,w
                               datalo_set v____temp_84
                               subwf    v____temp_84,w
                               bcf      v____bitbucket_9+2, 0 ; _btemp791
                               btfsc    v__status, v__z
                               bsf      v____bitbucket_9+2, 0 ; _btemp791
                               btfsc    v____bitbucket_9+2, 0 ; _btemp791
                               bcf      v____bitbucket_9+1, 5 ; e21
                               btfss    v____bitbucket_9+2, 0 ; _btemp791
                               bsf      v____bitbucket_9+1, 5 ; e21
;  473 	e3 = (buff > 0)			-- And, if the buffer is not empty
                               datalo_clr v_buff
                               movf     v_buff,w
                               datalo_set v____bitbucket_9+1 ; e31
                               bsf      v____bitbucket_9+1, 3 ; e31
                               btfsc    v__status, v__z
                               bcf      v____bitbucket_9+1, 3 ; e31
;  474 	e4 = (e1 | e2)			-- If X is different OR Y is out of range
                               bcf      v____bitbucket_9+1, 4 ; e41
                               btfss    v____bitbucket_9+1, 2 ; e11
                               btfsc    v____bitbucket_9+1, 5 ; e21
                               bsf      v____bitbucket_9+1, 4 ; e41
;  475 	if (e4 & e3) then		
                               bsf      v____bitbucket_9+2, 4 ; _btemp831
                               btfsc    v____bitbucket_9+1, 4 ; e41
                               btfss    v____bitbucket_9+1, 3 ; e31
                               bcf      v____bitbucket_9+2, 4 ; _btemp831
                               btfss    v____bitbucket_9+2, 4 ; _btemp831
                               goto     l__l807
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  476 		ks0108_write_byte(x, (buffY * 8), buff) -- Write the buffer
                               bcf      v__status, v__c
                               datalo_clr v_buffy
                               rlf      v_buffy,w
                               datalo_set v____temp_84
                               movwf    v____temp_84
                               bcf      v__status, v__c
                               rlf      v____temp_84,f
                               bcf      v__status, v__c
                               rlf      v____temp_84,f
                               movf     v____temp_84,w
                               movwf    v___y_3
                               datalo_clr v_buff
                               movf     v_buff,w
                               datalo_set v___veri_1
                               movwf    v___veri_1
                               movf     v___x_123,w
                               branchlo_clr l_ks0108_write_byte
                               call     l_ks0108_write_byte
;  477 		buff = 0								-- Set all to 0
                               datalo_clr v_buff
                               datahi_clr v_buff
                               clrf     v_buff
;  478 		buffX = 0
                               clrf     v_buffx
;  479 		buffY = 0
                               clrf     v_buffy
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  480 	end if
l__l807
;  483 	var byte side = KS0108_LEFT   -- Stores which chip to use on the LCD
                               datalo_set v___side_25
                               clrf     v___side_25
;  485 	if x > 63 then                -- Check for first or second display area
                               movlw    63
                               subwf    v___x_123,w
                               branchlo_set l__l809
                               branchhi_clr l__l809
                               btfsc    v__status, v__z
                               goto     l__l809
                               btfss    v__status, v__c
                               goto     l__l809
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  486 		x = x - 64
                               movlw    64
                               subwf    v___x_123,f
;  487 		side = KS0108_RIGHT
                               movlw    1
                               movwf    v___side_25
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  488 	end if
l__l809
;  490 	if buff == 0 then					-- Only gather data when the buffer is empty
                               datalo_clr v_buff
                               movf     v_buff,w
                               btfss    v__status, v__z
                               goto     l__l813
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  491 		_ks0108_inst()					-- Set for instruction
                               branchlo_clr l__ks0108_inst
                               call     l__ks0108_inst
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  129    _ks0108_write(side, KS0108_CMD_COLUMN | column)
                               movlw    64
                               datalo_set v___x_123
                               datahi_clr v___x_123
                               iorwf    v___x_123,w
                               movwf    v____temp_85
                               movf     v____temp_85,w
                               movwf    v___data_14
                               movf     v___side_25,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  492 		_ks0108_column(side,x)			-- Set the horizontal address
;  493 		_ks0108_page(side,(y / 8))		-- Set the page address
                               bcf      v__status, v__c
                               datalo_set v__rparam8
                               datahi_clr v__rparam8
                               rrf      v__rparam8,w
                               movwf    v____rparam6_1
                               bcf      v__status, v__c
                               rrf      v____rparam6_1,f
                               bcf      v__status, v__c
                               rrf      v____rparam6_1,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  119    _ks0108_write(side, KS0108_CMD_PAGE | page)
                               movlw    184
                               iorwf    v____rparam6_1,w
                               movwf    v____temp_86
                               movf     v____temp_86,w
                               movwf    v___data_14
                               movf     v___side_25,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  493 		_ks0108_page(side,(y / 8))		-- Set the page address
;  494 		_ks0108_data()					-- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  495 		data = _ks0108_read(side)		-- ignore; need two reads to get data at new address
                               datalo_set v___side_25
                               datahi_clr v___side_25
                               movf     v___side_25,w
                               branchlo_clr l__ks0108_read
                               branchhi_clr l__ks0108_read
                               call     l__ks0108_read
                               datalo_set v___data_22
                               datahi_clr v___data_22
                               movwf    v___data_22
;  496 		data = _ks0108_read(side)		-- actual data
                               movf     v___side_25,w
                               branchlo_clr l__ks0108_read
                               branchhi_clr l__ks0108_read
                               call     l__ks0108_read
                               datalo_set v___data_22
                               datahi_clr v___data_22
                               movwf    v___data_22
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  497 	else
                               branchlo_set l__l814
                               branchhi_clr l__l814
                               goto     l__l814
l__l813
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  498 		data = buff						-- so that we can add data to it!
                               movf     v_buff,w
                               datalo_set v___data_22
                               movwf    v___data_22
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  499 	end if
l__l814
;  502 	if onoff == 1 then
                               btfss    v____bitbucket_9, 0 ; state1
                               goto     l__l815
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  503 		yy = y % 8					-- Calculate where the position of the y is
                               movlw    7
                               andwf    v__rparam8,w
                               movwf    v___yy_3
;  504 		data = data | ( 1 << yy )	-- Set the bit on
                               movf     v___yy_3,w
                               movwf    v__pic_accum
                               movlw    1
                               movwf    v____temp_84
                               movf     v__pic_accum,w
                               goto     l__l1130
l__l1129
                               bcf      v__status, v__c
                               rlf      v____temp_84,f
                               decf     v__pic_accum,f
l__l1130
                               btfss    v__status, v__z
                               goto     l__l1129
                               movf     v____temp_84,w
                               iorwf    v___data_22,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  505 	else
                               goto     l__l816
l__l815
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  506 		yy = y % 8					-- Calculate where the position of the y is
                               movlw    7
                               andwf    v__rparam8,w
                               movwf    v___yy_3
;  507 		data = data & !( 1 << yy )	-- Set the bit off
                               movf     v___yy_3,w
                               movwf    v__pic_accum
                               movlw    1
                               movwf    v____temp_84
                               movf     v__pic_accum,w
                               goto     l__l1132
l__l1131
                               bcf      v__status, v__c
                               rlf      v____temp_84,f
                               decf     v__pic_accum,f
l__l1132
                               btfss    v__status, v__z
                               goto     l__l1131
                               comf     v____temp_84,w
                               movwf    v____temp_84+1
                               movf     v____temp_84+1,w
                               andwf    v___data_22,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  508 	end if
l__l816
;  510 	if write then
                               btfss    v____bitbucket_9, 1 ; write2
                               goto     l__l818
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  511 		_ks0108_inst()				-- Set for instruction
                               branchlo_clr l__ks0108_inst
                               call     l__ks0108_inst
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  129    _ks0108_write(side, KS0108_CMD_COLUMN | column)
                               movlw    64
                               datalo_set v___x_123
                               datahi_clr v___x_123
                               iorwf    v___x_123,w
                               movwf    v____temp_87
                               movf     v____temp_87,w
                               movwf    v___data_14
                               movf     v___side_25,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  512 		_ks0108_column(side,x)		-- Set the horizontal address
;  513 		_ks0108_data()				-- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  514 		_ks0108_write(side, data)	-- Write the pixel data
                               datalo_set v___data_22
                               datahi_clr v___data_22
                               movf     v___data_22,w
                               movwf    v___data_14
                               movf     v___side_25,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  515 	else
                               branchlo_set l__l819
                               branchhi_clr l__l819
                               goto     l__l819
l__l818
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  516 		buff = data					-- Store the data in the buffer
                               movf     v___data_22,w
                               datalo_clr v_buff
                               movwf    v_buff
;  517 		buffX = x					-- Store the X
                               datalo_set v___x_123
                               movf     v___x_123,w
                               datalo_clr v_buffx
                               movwf    v_buffx
;  518 		buffY = (y / 8)				-- Set the row of Y
                               bcf      v__status, v__c
                               datalo_set v__rparam8
                               rrf      v__rparam8,w
                               datalo_clr v_buffy
                               movwf    v_buffy
                               bcf      v__status, v__c
                               rrf      v_buffy,f
                               bcf      v__status, v__c
                               rrf      v_buffy,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  519 	end if
l__l819
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   73 		lcd_write_pixel_buff(x0 + currX, y0 + currY, state, write)
;   75 		currY = currY + 1
                               datalo_set v_curry
                               datahi_clr v_curry
                               incf     v_curry,f
;   76 		if currY == yDiff then
                               movf     v_curry,w
                               subwf    v_ydiff,w
                               btfss    v__status, v__z
                               goto     l__l822
;   77 			currY = 0
                               clrf     v_curry
;   78 			currX = currX + 1
                               incf     v_currx,f
;   79 		end if
l__l822
;   80 		if (currY == yDiff) & (currX == xDiff) then
                               movf     v_curry,w
                               subwf    v_ydiff,w
                               bcf      v____bitbucket_9, 6 ; _btemp99
                               btfsc    v__status, v__z
                               bsf      v____bitbucket_9, 6 ; _btemp99
                               movf     v_currx,w
                               datalo_clr v_xdiff
                               subwf    v_xdiff,w
                               datalo_set v____bitbucket_9 ; _btemp100
                               bcf      v____bitbucket_9, 7 ; _btemp100
                               btfsc    v__status, v__z
                               bsf      v____bitbucket_9, 7 ; _btemp100
                               bsf      v____bitbucket_9+1, 0 ; _btemp101
                               btfsc    v____bitbucket_9, 6 ; _btemp99
                               btfss    v____bitbucket_9, 7 ; _btemp100
                               bcf      v____bitbucket_9+1, 0 ; _btemp101
                               btfss    v____bitbucket_9+1, 0 ; _btemp101
                               goto     l__l824
;   81 			write = 1
                               bsf      v____bitbucket_9, 1 ; write2
;   82 		else
                               goto     l__l823
l__l824
;   83 			write = 0
                               bcf      v____bitbucket_9, 1 ; write2
;   84 		end if
l__l823
;   85 	end loop
                               incf     v__floop9,f
                               btfsc    v__status, v__z
                               incf     v__floop9+1,f
l__l803
                               movf     v__floop9,w
                               subwf    v_area,w
                               datalo_clr v__pic_temp
                               movwf    v__pic_temp
                               datalo_set v__floop9
                               movf     v__floop9+1,w
                               subwf    v_area+1,w
                               datalo_clr v__pic_temp
                               iorwf    v__pic_temp,w
                               btfss    v__status, v__z
                               goto     l__l802
;   86 end procedure
                               return   
;   95 procedure lcd'put(byte in char) is
;  114 procedure  lcd_clearscreen() is
l_lcd_clearscreen
;  115    lcd_fill(0)           -- Clear the display                 
                               movlw    0
                               branchlo_clr l_lcd_fill
                               goto     l_lcd_fill
;  118 end procedure                                 
;  140 procedure lcd_num(byte in x, byte in y, word in num) is
l_lcd_num
                               movwf    v___x_126
;  141 	var byte hundrets = num / 100
                               movlw    100
                               movwf    v__pic_divisor
                               clrf     v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               movf     v___num_1,w
                               movwf    v__pic_dividend
                               movf     v___num_1+1,w
                               movwf    v__pic_dividend+1
                               clrf     v__pic_dividend+2
                               clrf     v__pic_dividend+3
                               branchlo_clr l__pic_divide
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               datalo_set v_hundrets
                               movwf    v_hundrets
;  142 	var byte tens = (num - (hundrets * 100)) / 10
                               movf     v_hundrets,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier
                               clrf     v__pic_multiplier+1
                               movlw    100
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               branchhi_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               movwf    v____temp_95
                               movf     v___num_1+1,w
                               movwf    v____temp_95+2
                               movf     v____temp_95,w
                               subwf    v___num_1,w
                               movwf    v____temp_95+1
                               btfss    v__status, v__c
                               decf     v____temp_95+2,f
                               movlw    10
                               movwf    v__pic_divisor
                               clrf     v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               movf     v____temp_95+1,w
                               movwf    v__pic_dividend
                               movf     v____temp_95+2,w
                               movwf    v__pic_dividend+1
                               clrf     v__pic_dividend+2
                               clrf     v__pic_dividend+3
                               branchlo_clr l__pic_divide
                               branchhi_clr l__pic_divide
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               datalo_set v_tens
                               movwf    v_tens
;  143 	var byte ones = num - (hundrets * 100) - (tens * 10)
                               movf     v_hundrets,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier
                               clrf     v__pic_multiplier+1
                               movlw    100
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               branchhi_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               movwf    v____temp_95
                               movf     v___num_1+1,w
                               movwf    v____temp_95+2
                               movf     v____temp_95,w
                               subwf    v___num_1,w
                               movwf    v____temp_95+1
                               btfss    v__status, v__c
                               decf     v____temp_95+2,f
                               datalo_set v_tens
                               movf     v_tens,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier
                               clrf     v__pic_multiplier+1
                               movlw    10
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               branchhi_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               movwf    v____temp_95+3
                               movf     v____temp_95+3,w
                               subwf    v____temp_95+1,w
                               datalo_set v_ones
                               movwf    v_ones
;  145 	lcd_write_char(x, y, hundrets + 48,0)
                               movlw    48
                               addwf    v_hundrets,w
                               movwf    v__rparam9
                               datalo_clr v___x_126
                               movf     v___x_126,w
                               datalo_set v___x_127
                               movwf    v___x_127
                               bcf      v____bitbucket_4, 0 ; debug3
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  423 	var word fIndex = 0
                               clrf     v___findex_2
                               clrf     v___findex_2+1
;  424 	var byte cx = 0b10101010
                               movlw    170
                               movwf    v___cx_2
;  425 	var byte doLoop = 5
                               movlw    5
                               movwf    v___doloop_2
;  426 	if (ch <  31) then return end if
                               movlw    31
                               subwf    v__rparam9,w
                               branchlo_set l__l852
                               branchhi_clr l__l852
                               btfsc    v__status, v__z
                               goto     l__l852
                               btfsc    v__status, v__c
                               goto     l__l852
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  426 	if (ch <  31) then return end if
                               goto     l__l868
l__l852
;  427 	if (ch > 135) then return end if
                               movlw    135
                               subwf    v__rparam9,w
                               btfsc    v__status, v__z
                               goto     l__l854
                               btfss    v__status, v__c
                               goto     l__l854
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  427 	if (ch > 135) then return end if
                               goto     l__l868
l__l854
;  430 	fIndex = fIndex + 5 * word(ch - 32)
                               movlw    32
                               subwf    v__rparam9,w
                               movwf    v____temp_96
                               clrf     v____temp_96+1
                               movf     v____temp_96,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier
                               datalo_set v____temp_96
                               movf     v____temp_96+1,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier+1
                               movlw    5
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               datalo_set v____temp_96+2
                               movwf    v____temp_96+2
                               datalo_clr v__pic_mresult
                               movf     v__pic_mresult+1,w
                               datalo_set v____temp_96+2
                               movwf    v____temp_96+3
                               movf     v____temp_96+3,w
                               addwf    v___findex_2+1,f
                               movf     v____temp_96+2,w
                               addwf    v___findex_2,f
                               btfsc    v__status, v__c
                               incf     v___findex_2+1,f
;  433 	for doLoop loop
                               clrf     v____floop7_2
                               branchlo_set l__l866
                               branchhi_clr l__l866
                               goto     l__l866
l__l856
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  434 		cx = myFontTable[fIndex]
                               movf     v___findex_2,w
                               datalo_clr v__pic_loop
                               movwf    v__pic_loop
                               datalo_set v___findex_2
                               movf     v___findex_2+1,w
                               branchlo_clr l__lookup_myfonttable
                               call     l__lookup_myfonttable
                               datalo_set v___cx_2
                               datahi_clr v___cx_2
                               movwf    v___cx_2
;  435 		if debug then
                               branchlo_set l__l857
                               branchhi_clr l__l857
                               btfss    v____bitbucket_4, 0 ; debug3
                               goto     l__l857
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  436 			serial_hw_byte(fIndex)
                               movf     v___findex_2,w
                               movwf    v___b_1
                               movf     v___findex_2+1,w
                               movwf    v___b_1+1
                               branchlo_clr l_serial_hw_byte
                               call     l_serial_hw_byte
;  437 			serial_hw_byte(cx)
                               datalo_set v___cx_2
                               datahi_clr v___cx_2
                               movf     v___cx_2,w
                               movwf    v___b_1
                               clrf     v___b_1+1
                               branchlo_clr l_serial_hw_byte
                               branchhi_clr l_serial_hw_byte
                               call     l_serial_hw_byte
;  438 			serial_hw_write(0x0A)
                               movlw    10
                               branchlo_clr l_serial_hw_write
                               branchhi_clr l_serial_hw_write
                               call     l_serial_hw_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  439 		end if
l__l857
;  440 		_ks0108_inst()                          -- Set for instruction          
                               branchlo_clr l__ks0108_inst
                               branchhi_clr l__ks0108_inst
                               call     l__ks0108_inst
;  442 		if (x < 64) then
                               movlw    64
                               datalo_set v___x_127
                               datahi_clr v___x_127
                               subwf    v___x_127,w
                               branchlo_set l__l861
                               branchhi_clr l__l861
                               btfsc    v__status, v__z
                               goto     l__l861
                               btfsc    v__status, v__c
                               goto     l__l861
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
                               clrf     v___side_30
                               movlw    64
                               iorwf    v___x_127,w
                               movwf    v____temp_97
                               movf     v____temp_97,w
                               movwf    v___data_14
                               movf     v___side_30,w
                               branchlo_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               bcf      v__status, v__c
                               datalo_clr v___y_11
                               datahi_clr v___y_11
                               rrf      v___y_11,w
                               datalo_set v____rparam3_2
                               movwf    v____rparam3_2
                               bcf      v__status, v__c
                               rrf      v____rparam3_2,f
                               bcf      v__status, v__c
                               rrf      v____rparam3_2,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               clrf     v___side_31
                               movlw    184
                               iorwf    v____rparam3_2,w
                               movwf    v____temp_98
                               movf     v____temp_98,w
                               movwf    v___data_14
                               movf     v___side_31,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
;  445 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  446 			_ks0108_write(KS0108_LEFT, cx)       -- Write the pixel data
                               datalo_set v___cx_2
                               datahi_clr v___cx_2
                               movf     v___cx_2,w
                               movwf    v___data_14
                               movlw    0
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  447 		elsif (x < 128) then
                               branchlo_set l__l865
                               branchhi_clr l__l865
                               goto     l__l865
l__l861
                               movlw    128
                               subwf    v___x_127,w
                               btfsc    v__status, v__z
                               goto     l__l864
                               btfsc    v__status, v__c
                               goto     l__l864
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    64
                               subwf    v___x_127,w
                               movwf    v____rparam4_2
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    1
                               movwf    v___side_32
                               movlw    64
                               iorwf    v____rparam4_2,w
                               movwf    v____temp_99
                               movf     v____temp_99,w
                               movwf    v___data_14
                               movf     v___side_32,w
                               branchlo_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               bcf      v__status, v__c
                               datalo_clr v___y_11
                               datahi_clr v___y_11
                               rrf      v___y_11,w
                               datalo_set v____rparam5_2
                               movwf    v____rparam5_2
                               bcf      v__status, v__c
                               rrf      v____rparam5_2,f
                               bcf      v__status, v__c
                               rrf      v____rparam5_2,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               movlw    1
                               movwf    v___side_33
                               movlw    184
                               iorwf    v____rparam5_2,w
                               movwf    v____temp_100
                               movf     v____temp_100,w
                               movwf    v___data_14
                               movf     v___side_33,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
;  450 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  451 			_ks0108_write(KS0108_RIGHT, cx)      -- Write the pixel data
                               datalo_set v___cx_2
                               datahi_clr v___cx_2
                               movf     v___cx_2,w
                               movwf    v___data_14
                               movlw    1
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  452 		end if
l__l864
l__l865
;  455 		fIndex = fIndex + 1
                               datalo_set v___findex_2
                               datahi_clr v___findex_2
                               incf     v___findex_2,f
                               btfsc    v__status, v__z
                               incf     v___findex_2+1,f
;  456 		x = x + 1
                               incf     v___x_127,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  457 	end loop
                               incf     v____floop7_2,f
l__l866
                               movf     v____floop7_2,w
                               subwf    v___doloop_2,w
                               branchlo_set l__l856
                               branchhi_clr l__l856
                               btfss    v__status, v__z
                               goto     l__l856
;  458 end procedure
l__l868
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  145 	lcd_write_char(x, y, hundrets + 48,0)
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
                               movlw    6
                               datalo_clr v___x_126
                               addwf    v___x_126,w
                               movwf    v____temp_95
                               movlw    48
                               datalo_set v_tens
                               addwf    v_tens,w
                               datalo_clr v____temp_95+1
                               movwf    v____temp_95+1
                               movf     v____temp_95+1,w
                               datalo_set v__rparam11
                               movwf    v__rparam11
                               datalo_clr v____temp_95
                               movf     v____temp_95,w
                               datalo_set v___x_128
                               movwf    v___x_128
                               bcf      v____bitbucket_4, 0 ; debug4
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  423 	var word fIndex = 0
                               clrf     v___findex_3
                               clrf     v___findex_3+1
;  424 	var byte cx = 0b10101010
                               movlw    170
                               movwf    v___cx_3
;  425 	var byte doLoop = 5
                               movlw    5
                               movwf    v___doloop_3
;  426 	if (ch <  31) then return end if
                               movlw    31
                               subwf    v__rparam11,w
                               btfsc    v__status, v__z
                               goto     l__l869
                               btfsc    v__status, v__c
                               goto     l__l869
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  426 	if (ch <  31) then return end if
                               goto     l__l885
l__l869
;  427 	if (ch > 135) then return end if
                               movlw    135
                               subwf    v__rparam11,w
                               btfsc    v__status, v__z
                               goto     l__l871
                               btfss    v__status, v__c
                               goto     l__l871
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  427 	if (ch > 135) then return end if
                               goto     l__l885
l__l871
;  430 	fIndex = fIndex + 5 * word(ch - 32)
                               movlw    32
                               subwf    v__rparam11,w
                               movwf    v____temp_101
                               clrf     v____temp_101+1
                               movf     v____temp_101,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier
                               datalo_set v____temp_101
                               movf     v____temp_101+1,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier+1
                               movlw    5
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               datalo_set v____temp_101+2
                               movwf    v____temp_101+2
                               datalo_clr v__pic_mresult
                               movf     v__pic_mresult+1,w
                               datalo_set v____temp_101+2
                               movwf    v____temp_101+3
                               movf     v____temp_101+3,w
                               addwf    v___findex_3+1,f
                               movf     v____temp_101+2,w
                               addwf    v___findex_3,f
                               btfsc    v__status, v__c
                               incf     v___findex_3+1,f
;  433 	for doLoop loop
                               clrf     v____floop7_3
                               branchlo_set l__l883
                               branchhi_clr l__l883
                               goto     l__l883
l__l873
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  434 		cx = myFontTable[fIndex]
                               movf     v___findex_3,w
                               datalo_clr v__pic_loop
                               movwf    v__pic_loop
                               datalo_set v___findex_3
                               movf     v___findex_3+1,w
                               branchlo_clr l__lookup_myfonttable
                               call     l__lookup_myfonttable
                               datalo_set v___cx_3
                               datahi_clr v___cx_3
                               movwf    v___cx_3
;  435 		if debug then
                               branchlo_set l__l874
                               branchhi_clr l__l874
                               btfss    v____bitbucket_4, 0 ; debug4
                               goto     l__l874
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  436 			serial_hw_byte(fIndex)
                               movf     v___findex_3,w
                               movwf    v___b_1
                               movf     v___findex_3+1,w
                               movwf    v___b_1+1
                               branchlo_clr l_serial_hw_byte
                               call     l_serial_hw_byte
;  437 			serial_hw_byte(cx)
                               datalo_set v___cx_3
                               datahi_clr v___cx_3
                               movf     v___cx_3,w
                               movwf    v___b_1
                               clrf     v___b_1+1
                               branchlo_clr l_serial_hw_byte
                               branchhi_clr l_serial_hw_byte
                               call     l_serial_hw_byte
;  438 			serial_hw_write(0x0A)
                               movlw    10
                               branchlo_clr l_serial_hw_write
                               branchhi_clr l_serial_hw_write
                               call     l_serial_hw_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  439 		end if
l__l874
;  440 		_ks0108_inst()                          -- Set for instruction          
                               branchlo_clr l__ks0108_inst
                               branchhi_clr l__ks0108_inst
                               call     l__ks0108_inst
;  442 		if (x < 64) then
                               movlw    64
                               datalo_set v___x_128
                               datahi_clr v___x_128
                               subwf    v___x_128,w
                               branchlo_set l__l878
                               branchhi_clr l__l878
                               btfsc    v__status, v__z
                               goto     l__l878
                               btfsc    v__status, v__c
                               goto     l__l878
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
                               clrf     v___side_34
                               movlw    64
                               iorwf    v___x_128,w
                               movwf    v____temp_102
                               movf     v____temp_102,w
                               movwf    v___data_14
                               movf     v___side_34,w
                               branchlo_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               bcf      v__status, v__c
                               datalo_clr v___y_11
                               datahi_clr v___y_11
                               rrf      v___y_11,w
                               datalo_set v____rparam3_3
                               movwf    v____rparam3_3
                               bcf      v__status, v__c
                               rrf      v____rparam3_3,f
                               bcf      v__status, v__c
                               rrf      v____rparam3_3,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               clrf     v___side_35
                               movlw    184
                               iorwf    v____rparam3_3,w
                               movwf    v____temp_103
                               movf     v____temp_103,w
                               movwf    v___data_14
                               movf     v___side_35,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
;  445 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  446 			_ks0108_write(KS0108_LEFT, cx)       -- Write the pixel data
                               datalo_set v___cx_3
                               datahi_clr v___cx_3
                               movf     v___cx_3,w
                               movwf    v___data_14
                               movlw    0
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  447 		elsif (x < 128) then
                               branchlo_set l__l882
                               branchhi_clr l__l882
                               goto     l__l882
l__l878
                               movlw    128
                               subwf    v___x_128,w
                               btfsc    v__status, v__z
                               goto     l__l881
                               btfsc    v__status, v__c
                               goto     l__l881
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    64
                               subwf    v___x_128,w
                               movwf    v____rparam4_3
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    1
                               movwf    v___side_36
                               movlw    64
                               iorwf    v____rparam4_3,w
                               movwf    v____temp_104
                               movf     v____temp_104,w
                               movwf    v___data_14
                               movf     v___side_36,w
                               branchlo_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               bcf      v__status, v__c
                               datalo_clr v___y_11
                               datahi_clr v___y_11
                               rrf      v___y_11,w
                               datalo_set v____rparam5_3
                               movwf    v____rparam5_3
                               bcf      v__status, v__c
                               rrf      v____rparam5_3,f
                               bcf      v__status, v__c
                               rrf      v____rparam5_3,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               movlw    1
                               movwf    v___side_37
                               movlw    184
                               iorwf    v____rparam5_3,w
                               movwf    v____temp_105
                               movf     v____temp_105,w
                               movwf    v___data_14
                               movf     v___side_37,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
;  450 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  451 			_ks0108_write(KS0108_RIGHT, cx)      -- Write the pixel data
                               datalo_set v___cx_3
                               datahi_clr v___cx_3
                               movf     v___cx_3,w
                               movwf    v___data_14
                               movlw    1
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  452 		end if
l__l881
l__l882
;  455 		fIndex = fIndex + 1
                               datalo_set v___findex_3
                               datahi_clr v___findex_3
                               incf     v___findex_3,f
                               btfsc    v__status, v__z
                               incf     v___findex_3+1,f
;  456 		x = x + 1
                               incf     v___x_128,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  457 	end loop
                               incf     v____floop7_3,f
l__l883
                               movf     v____floop7_3,w
                               subwf    v___doloop_3,w
                               branchlo_set l__l873
                               branchhi_clr l__l873
                               btfss    v__status, v__z
                               goto     l__l873
;  458 end procedure
l__l885
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  146 	lcd_write_char(x + 6, y, tens + 48,0)
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
                               movlw    12
                               datalo_clr v___x_126
                               addwf    v___x_126,w
                               movwf    v____temp_95
                               movlw    48
                               datalo_set v_ones
                               addwf    v_ones,w
                               datalo_clr v____temp_95+1
                               movwf    v____temp_95+1
                               movf     v____temp_95+1,w
                               datalo_set v__rparam13
                               movwf    v__rparam13
                               datalo_clr v____temp_95
                               movf     v____temp_95,w
                               datalo_set v___x_129
                               movwf    v___x_129
                               bcf      v____bitbucket_4, 0 ; debug5
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  423 	var word fIndex = 0
                               clrf     v___findex_4
                               clrf     v___findex_4+1
;  424 	var byte cx = 0b10101010
                               movlw    170
                               movwf    v___cx_4
;  425 	var byte doLoop = 5
                               movlw    5
                               movwf    v___doloop_4
;  426 	if (ch <  31) then return end if
                               movlw    31
                               subwf    v__rparam13,w
                               btfsc    v__status, v__z
                               goto     l__l886
                               btfsc    v__status, v__c
                               goto     l__l886
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  426 	if (ch <  31) then return end if
                               return   
l__l886
;  427 	if (ch > 135) then return end if
                               movlw    135
                               subwf    v__rparam13,w
                               btfsc    v__status, v__z
                               goto     l__l888
                               btfss    v__status, v__c
                               goto     l__l888
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  427 	if (ch > 135) then return end if
                               return   
l__l888
;  430 	fIndex = fIndex + 5 * word(ch - 32)
                               movlw    32
                               subwf    v__rparam13,w
                               movwf    v____temp_106
                               clrf     v____temp_106+1
                               movf     v____temp_106,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier
                               datalo_set v____temp_106
                               movf     v____temp_106+1,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier+1
                               movlw    5
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               datalo_set v____temp_106+2
                               movwf    v____temp_106+2
                               datalo_clr v__pic_mresult
                               movf     v__pic_mresult+1,w
                               datalo_set v____temp_106+2
                               movwf    v____temp_106+3
                               movf     v____temp_106+3,w
                               addwf    v___findex_4+1,f
                               movf     v____temp_106+2,w
                               addwf    v___findex_4,f
                               btfsc    v__status, v__c
                               incf     v___findex_4+1,f
;  433 	for doLoop loop
                               clrf     v____floop7_4
                               branchlo_set l__l900
                               branchhi_clr l__l900
                               goto     l__l900
l__l890
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  434 		cx = myFontTable[fIndex]
                               movf     v___findex_4,w
                               datalo_clr v__pic_loop
                               movwf    v__pic_loop
                               datalo_set v___findex_4
                               movf     v___findex_4+1,w
                               branchlo_clr l__lookup_myfonttable
                               call     l__lookup_myfonttable
                               datalo_set v___cx_4
                               datahi_clr v___cx_4
                               movwf    v___cx_4
;  435 		if debug then
                               branchlo_set l__l891
                               branchhi_clr l__l891
                               btfss    v____bitbucket_4, 0 ; debug5
                               goto     l__l891
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  436 			serial_hw_byte(fIndex)
                               movf     v___findex_4,w
                               movwf    v___b_1
                               movf     v___findex_4+1,w
                               movwf    v___b_1+1
                               branchlo_clr l_serial_hw_byte
                               call     l_serial_hw_byte
;  437 			serial_hw_byte(cx)
                               datalo_set v___cx_4
                               datahi_clr v___cx_4
                               movf     v___cx_4,w
                               movwf    v___b_1
                               clrf     v___b_1+1
                               branchlo_clr l_serial_hw_byte
                               branchhi_clr l_serial_hw_byte
                               call     l_serial_hw_byte
;  438 			serial_hw_write(0x0A)
                               movlw    10
                               branchlo_clr l_serial_hw_write
                               branchhi_clr l_serial_hw_write
                               call     l_serial_hw_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  439 		end if
l__l891
;  440 		_ks0108_inst()                          -- Set for instruction          
                               branchlo_clr l__ks0108_inst
                               branchhi_clr l__ks0108_inst
                               call     l__ks0108_inst
;  442 		if (x < 64) then
                               movlw    64
                               datalo_set v___x_129
                               datahi_clr v___x_129
                               subwf    v___x_129,w
                               branchlo_set l__l895
                               branchhi_clr l__l895
                               btfsc    v__status, v__z
                               goto     l__l895
                               btfsc    v__status, v__c
                               goto     l__l895
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
                               clrf     v___side_38
                               movlw    64
                               iorwf    v___x_129,w
                               movwf    v____temp_107
                               movf     v____temp_107,w
                               movwf    v___data_14
                               movf     v___side_38,w
                               branchlo_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               bcf      v__status, v__c
                               datalo_clr v___y_11
                               datahi_clr v___y_11
                               rrf      v___y_11,w
                               datalo_set v____rparam3_4
                               movwf    v____rparam3_4
                               bcf      v__status, v__c
                               rrf      v____rparam3_4,f
                               bcf      v__status, v__c
                               rrf      v____rparam3_4,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               clrf     v___side_39
                               movlw    184
                               iorwf    v____rparam3_4,w
                               movwf    v____temp_108
                               movf     v____temp_108,w
                               movwf    v___data_14
                               movf     v___side_39,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
;  445 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  446 			_ks0108_write(KS0108_LEFT, cx)       -- Write the pixel data
                               datalo_set v___cx_4
                               datahi_clr v___cx_4
                               movf     v___cx_4,w
                               movwf    v___data_14
                               movlw    0
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  447 		elsif (x < 128) then
                               branchlo_set l__l899
                               branchhi_clr l__l899
                               goto     l__l899
l__l895
                               movlw    128
                               subwf    v___x_129,w
                               btfsc    v__status, v__z
                               goto     l__l898
                               btfsc    v__status, v__c
                               goto     l__l898
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    64
                               subwf    v___x_129,w
                               movwf    v____rparam4_4
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    1
                               movwf    v___side_40
                               movlw    64
                               iorwf    v____rparam4_4,w
                               movwf    v____temp_109
                               movf     v____temp_109,w
                               movwf    v___data_14
                               movf     v___side_40,w
                               branchlo_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               bcf      v__status, v__c
                               datalo_clr v___y_11
                               datahi_clr v___y_11
                               rrf      v___y_11,w
                               datalo_set v____rparam5_4
                               movwf    v____rparam5_4
                               bcf      v__status, v__c
                               rrf      v____rparam5_4,f
                               bcf      v__status, v__c
                               rrf      v____rparam5_4,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               movlw    1
                               movwf    v___side_41
                               movlw    184
                               iorwf    v____rparam5_4,w
                               movwf    v____temp_110
                               movf     v____temp_110,w
                               movwf    v___data_14
                               movf     v___side_41,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
;  450 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  451 			_ks0108_write(KS0108_RIGHT, cx)      -- Write the pixel data
                               datalo_set v___cx_4
                               datahi_clr v___cx_4
                               movf     v___cx_4,w
                               movwf    v___data_14
                               movlw    1
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  452 		end if
l__l898
l__l899
;  455 		fIndex = fIndex + 1
                               datalo_set v___findex_4
                               datahi_clr v___findex_4
                               incf     v___findex_4,f
                               btfsc    v__status, v__z
                               incf     v___findex_4+1,f
;  456 		x = x + 1
                               incf     v___x_129,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  457 	end loop
                               incf     v____floop7_4,f
l__l900
                               movf     v____floop7_4,w
                               subwf    v___doloop_4,w
                               branchlo_set l__l890
                               branchhi_clr l__l890
                               btfss    v__status, v__z
                               goto     l__l890
;  458 end procedure
l__l902
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  147 	lcd_write_char(x + 12, y, ones + 48,0)
;  148 end procedure
                               return   
;  153 procedure lcd_print(byte in x, byte in y, byte in str[]) is
l_lcd_print
                               movwf    v___x_131
;  156 	for count(str) using i loop
                               clrf     v___i_1
                               goto     l__l906
l__l905
;  157 		j = x
                               movf     v___x_131,w
                               datalo_set v___j_1
                               movwf    v___j_1
;  158 		j = j + (i * 6)
                               datalo_clr v___i_1
                               movf     v___i_1,w
                               movwf    v__pic_multiplier
                               clrf     v__pic_multiplier+1
                               movlw    6
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               datalo_set v____temp_111
                               movwf    v____temp_111
                               movf     v____temp_111,w
                               addwf    v___j_1,f
;  159 		lcd_write_char(j, y, str[i],0)
                               datalo_clr v___str_3
                               movf     v___str_3+1,w
                               movwf    v__pic_pointer+1
                               movf     v___i_1,w
                               addwf    v___str_3,w
                               movwf    v__pic_pointer
                               btfsc    v__status, v__c
                               incf     v__pic_pointer+1,f
                               bcf      v__pic_pointer+1, 6
                               movf     v__pic_pointer+1,w
                               branchlo_clr l__pic_indirect
                               branchhi_clr l__pic_indirect
                               call     l__pic_indirect
                               datalo_set v__rparam14
                               datahi_clr v__rparam14
                               movwf    v__rparam14
                               movf     v___j_1,w
                               movwf    v___x_132
                               bcf      v____bitbucket_3, 0 ; debug6
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  423 	var word fIndex = 0
                               clrf     v___findex_5
                               clrf     v___findex_5+1
;  424 	var byte cx = 0b10101010
                               movlw    170
                               movwf    v___cx_5
;  425 	var byte doLoop = 5
                               movlw    5
                               movwf    v___doloop_5
;  426 	if (ch <  31) then return end if
                               movlw    31
                               subwf    v__rparam14,w
                               branchlo_set l__l908
                               branchhi_clr l__l908
                               btfsc    v__status, v__z
                               goto     l__l908
                               btfsc    v__status, v__c
                               goto     l__l908
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  426 	if (ch <  31) then return end if
                               goto     l__l924
l__l908
;  427 	if (ch > 135) then return end if
                               movlw    135
                               subwf    v__rparam14,w
                               btfsc    v__status, v__z
                               goto     l__l910
                               btfss    v__status, v__c
                               goto     l__l910
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  427 	if (ch > 135) then return end if
                               goto     l__l924
l__l910
;  430 	fIndex = fIndex + 5 * word(ch - 32)
                               movlw    32
                               subwf    v__rparam14,w
                               movwf    v____temp_112
                               clrf     v____temp_112+1
                               movf     v____temp_112,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier
                               datalo_set v____temp_112
                               movf     v____temp_112+1,w
                               datalo_clr v__pic_multiplier
                               movwf    v__pic_multiplier+1
                               movlw    5
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               datalo_set v____temp_112+2
                               movwf    v____temp_112+2
                               datalo_clr v__pic_mresult
                               movf     v__pic_mresult+1,w
                               datalo_set v____temp_112+2
                               movwf    v____temp_112+3
                               movf     v____temp_112+3,w
                               addwf    v___findex_5+1,f
                               movf     v____temp_112+2,w
                               addwf    v___findex_5,f
                               btfsc    v__status, v__c
                               incf     v___findex_5+1,f
;  433 	for doLoop loop
                               clrf     v____floop7_5
                               branchlo_set l__l922
                               branchhi_clr l__l922
                               goto     l__l922
l__l912
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  434 		cx = myFontTable[fIndex]
                               movf     v___findex_5,w
                               datalo_clr v__pic_loop
                               movwf    v__pic_loop
                               datalo_set v___findex_5
                               movf     v___findex_5+1,w
                               branchlo_clr l__lookup_myfonttable
                               call     l__lookup_myfonttable
                               datalo_set v___cx_5
                               datahi_clr v___cx_5
                               movwf    v___cx_5
;  435 		if debug then
                               branchlo_set l__l913
                               branchhi_clr l__l913
                               btfss    v____bitbucket_3, 0 ; debug6
                               goto     l__l913
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  436 			serial_hw_byte(fIndex)
                               movf     v___findex_5,w
                               movwf    v___b_1
                               movf     v___findex_5+1,w
                               movwf    v___b_1+1
                               branchlo_clr l_serial_hw_byte
                               call     l_serial_hw_byte
;  437 			serial_hw_byte(cx)
                               datalo_set v___cx_5
                               datahi_clr v___cx_5
                               movf     v___cx_5,w
                               movwf    v___b_1
                               clrf     v___b_1+1
                               branchlo_clr l_serial_hw_byte
                               branchhi_clr l_serial_hw_byte
                               call     l_serial_hw_byte
;  438 			serial_hw_write(0x0A)
                               movlw    10
                               branchlo_clr l_serial_hw_write
                               branchhi_clr l_serial_hw_write
                               call     l_serial_hw_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  439 		end if
l__l913
;  440 		_ks0108_inst()                          -- Set for instruction          
                               branchlo_clr l__ks0108_inst
                               branchhi_clr l__ks0108_inst
                               call     l__ks0108_inst
;  442 		if (x < 64) then
                               movlw    64
                               datalo_set v___x_132
                               datahi_clr v___x_132
                               subwf    v___x_132,w
                               branchlo_set l__l917
                               branchhi_clr l__l917
                               btfsc    v__status, v__z
                               goto     l__l917
                               btfsc    v__status, v__c
                               goto     l__l917
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
                               clrf     v___side_42
                               movlw    64
                               iorwf    v___x_132,w
                               movwf    v____temp_113
                               movf     v____temp_113,w
                               movwf    v___data_14
                               movf     v___side_42,w
                               branchlo_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  443 			_ks0108_column(KS0108_LEFT,x)        -- Set the horizontal address
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               bcf      v__status, v__c
                               datalo_clr v___y_13
                               datahi_clr v___y_13
                               rrf      v___y_13,w
                               datalo_set v____rparam3_5
                               movwf    v____rparam3_5
                               bcf      v__status, v__c
                               rrf      v____rparam3_5,f
                               bcf      v__status, v__c
                               rrf      v____rparam3_5,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
                               clrf     v___side_43
                               movlw    184
                               iorwf    v____rparam3_5,w
                               movwf    v____temp_114
                               movf     v____temp_114,w
                               movwf    v___data_14
                               movf     v___side_43,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  444 			_ks0108_page(KS0108_LEFT, (y / 8))   -- Set the page address
;  445 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  446 			_ks0108_write(KS0108_LEFT, cx)       -- Write the pixel data
                               datalo_set v___cx_5
                               datahi_clr v___cx_5
                               movf     v___cx_5,w
                               movwf    v___data_14
                               movlw    0
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  447 		elsif (x < 128) then
                               branchlo_set l__l921
                               branchhi_clr l__l921
                               goto     l__l921
l__l917
                               movlw    128
                               subwf    v___x_132,w
                               btfsc    v__status, v__z
                               goto     l__l920
                               btfsc    v__status, v__c
                               goto     l__l920
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    64
                               subwf    v___x_132,w
                               movwf    v____rparam4_5
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
                               movlw    1
                               movwf    v___side_44
                               movlw    64
                               iorwf    v____rparam4_5,w
                               movwf    v____temp_115
                               movf     v____temp_115,w
                               movwf    v___data_14
                               movf     v___side_44,w
                               branchlo_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  448 			_ks0108_column(KS0108_RIGHT, x-64)   -- Set the horizontal address
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               bcf      v__status, v__c
                               datalo_clr v___y_13
                               datahi_clr v___y_13
                               rrf      v___y_13,w
                               datalo_set v____rparam5_5
                               movwf    v____rparam5_5
                               bcf      v__status, v__c
                               rrf      v____rparam5_5,f
                               bcf      v__status, v__c
                               rrf      v____rparam5_5,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
                               movlw    1
                               movwf    v___side_45
                               movlw    184
                               iorwf    v____rparam5_5,w
                               movwf    v____temp_116
                               movf     v____temp_116,w
                               movwf    v___data_14
                               movf     v___side_45,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  449 			_ks0108_page(KS0108_RIGHT, (y / 8))  -- Set the page address
;  450 			_ks0108_data()                       -- Set for data
                               branchlo_clr l__ks0108_data
                               branchhi_clr l__ks0108_data
                               call     l__ks0108_data
;  451 			_ks0108_write(KS0108_RIGHT, cx)      -- Write the pixel data
                               datalo_set v___cx_5
                               datahi_clr v___cx_5
                               movf     v___cx_5,w
                               movwf    v___data_14
                               movlw    1
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  452 		end if
l__l920
l__l921
;  455 		fIndex = fIndex + 1
                               datalo_set v___findex_5
                               datahi_clr v___findex_5
                               incf     v___findex_5,f
                               btfsc    v__status, v__z
                               incf     v___findex_5+1,f
;  456 		x = x + 1
                               incf     v___x_132,f
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  457 	end loop
                               incf     v____floop7_5,f
l__l922
                               movf     v____floop7_5,w
                               subwf    v___doloop_5,w
                               branchlo_set l__l912
                               branchhi_clr l__l912
                               btfss    v__status, v__z
                               goto     l__l912
;  458 end procedure
l__l924
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  159 		lcd_write_char(j, y, str[i],0)
;  160 	end loop
                               datalo_clr v___i_1
                               incf     v___i_1,f
l__l906
                               movf     v___i_1,w
                               subwf    v____str_count_1,w
                               movwf    v__pic_temp
                               movf     v____str_count_1+1,w
                               iorwf    v__pic_temp,w
                               btfss    v__status, v__z
                               goto     l__l905
;  161 end procedure
                               return   
;  233 end procedure 
l__l930
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  274    GLCD_DATAPRT = 0x00
                               clrf     v___x_135
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  225    _PORTB_shadow = x
                               movf     v___x_135,w
                               movwf    v__portb_shadow
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  221    PORTB = _PORTB_shadow
                               movf     v__portb_shadow,w
                               movwf    v_portb
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  226    _PORTB_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  274    GLCD_DATAPRT = 0x00
;  275    GLCD_DATAPRT_DIR = all_output
                               datalo_set v_portb_direction
                               clrf     v_portb_direction
;  277    GLCD_RW_DIRECTION  = output
                               bcf      v_trisc, 3 ; pin_c3_direction
;  278    GLCD_CS1_DIRECTION = output
                               bcf      v_trisc, 1 ; pin_c1_direction
;  279    GLCD_E_DIRECTION   = output
                               bcf      v_trisa, 5 ; pin_a5_direction
;  280    GLCD_DI_DIRECTION  = output
                               bcf      v_trisc, 5 ; pin_c5_direction
;  281    GLCD_RST_DIRECTION = output
                               bcf      v_trisc, 4 ; pin_c4_direction
;  282    GLCD_CS2_DIRECTION = output
                               bcf      v_trisc, 0 ; pin_c0_direction
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  284    GLCD_RST	= high
                               datalo_clr v__portc_shadow ; x136
                               bsf      v__portc_shadow, 4 ; x136
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  400    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  284    GLCD_RST	= high
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  285    GLCD_E	= low
                               bcf      v__porta_shadow, 5 ; x137
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  101    PORTA = _PORTA_shadow
                               movf     v__porta_shadow,w
                               movwf    v_porta
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  157    _PORTA_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  285    GLCD_E	= low
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  286    GLCD_CS1	= high
                               bsf      v__portc_shadow, 1 ; x138
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  430    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  286    GLCD_CS1	= high
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  287    GLCD_CS2 = low
                               bcf      v__portc_shadow, 0 ; x139
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  336    PORTC = _PORTC_shadow
                               movf     v__portc_shadow,w
                               movwf    v_portc
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/16f886.jal
;  440    _PORTC_flush()
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  287    GLCD_CS2 = low
;  290    _ks0108_inst()             -- Set for instruction
                               branchlo_clr l__ks0108_inst
                               call     l__ks0108_inst
;  291    _ks0108_write(KS0108_LEFT,  KS0108_CMD_TOP_RAM | 0)       -- First RAM line at the top of the screen
                               movlw    192
                               datalo_set v___data_14
                               datahi_clr v___data_14
                               movwf    v___data_14
                               movlw    0
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
;  292    _ks0108_write(KS0108_RIGHT, KS0108_CMD_TOP_RAM | 0)      -- First RAM line at the top of the screen
                               movlw    192
                               datalo_set v___data_14
                               datahi_clr v___data_14
                               movwf    v___data_14
                               movlw    1
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  293    _ks0108_page  (KS0108_LEFT ,0)        -- Set the page address to 0
                               datalo_clr v___side_46
                               datahi_clr v___side_46
                               clrf     v___side_46
                               clrf     v___page_4
                               movlw    184
                               iorwf    v___page_4,w
                               movwf    v____temp_119
                               movf     v____temp_119,w
                               datalo_set v___data_14
                               movwf    v___data_14
                               datalo_clr v___side_46
                               movf     v___side_46,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  293    _ks0108_page  (KS0108_LEFT ,0)        -- Set the page address to 0
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  294    _ks0108_page  (KS0108_RIGHT,0)
                               movlw    1
                               datalo_clr v___side_47
                               datahi_clr v___side_47
                               movwf    v___side_47
                               clrf     v___page_5
                               movlw    184
                               iorwf    v___page_5,w
                               movwf    v____temp_120
                               movf     v____temp_120,w
                               datalo_set v___data_14
                               movwf    v___data_14
                               datalo_clr v___side_47
                               movf     v___side_47,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  294    _ks0108_page  (KS0108_RIGHT,0)
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  295    _ks0108_column(KS0108_LEFT ,0)        -- Set the column address to 0
                               datalo_clr v___side_48
                               datahi_clr v___side_48
                               clrf     v___side_48
                               clrf     v___column_6
                               movlw    64
                               iorwf    v___column_6,w
                               movwf    v____temp_121
                               movf     v____temp_121,w
                               datalo_set v___data_14
                               movwf    v___data_14
                               datalo_clr v___side_48
                               movf     v___side_48,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  295    _ks0108_column(KS0108_LEFT ,0)        -- Set the column address to 0
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  296    _ks0108_column(KS0108_RIGHT,0)
                               movlw    1
                               datalo_clr v___side_49
                               datahi_clr v___side_49
                               movwf    v___side_49
                               clrf     v___column_7
                               movlw    64
                               iorwf    v___column_7,w
                               movwf    v____temp_122
                               movf     v____temp_122,w
                               datalo_set v___data_14
                               movwf    v___data_14
                               datalo_clr v___side_49
                               movf     v___side_49,w
                               branchlo_clr l__ks0108_write
                               branchhi_clr l__ks0108_write
                               call     l__ks0108_write
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_ks0108.jal
;  296    _ks0108_column(KS0108_RIGHT,0)
;  297    lcd_on()                       -- Turn the display on
                               branchlo_clr l_lcd_on
                               branchhi_clr l_lcd_on
                               call     l_lcd_on
;  299    lcd_fill(0)           -- Clear the display
                               movlw    0
                               branchlo_clr l_lcd_fill
                               branchhi_clr l_lcd_fill
                               call     l_lcd_fill
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   58 lcd_init()
;   61 lcd_print(0, 0, hewo)
                               datalo_clr v___y_13
                               datahi_clr v___y_13
                               clrf     v___y_13
                               movlw    13
                               movwf    v____str_count_1
                               clrf     v____str_count_1+1
                               movlw    l__data_hewo
                               movwf    v___str_3
                               movlw    HIGH l__data_hewo
                               iorlw    64
                               movwf    v___str_3+1
                               movlw    0
                               branchlo_set l_lcd_print
                               branchhi_clr l_lcd_print
                               call     l_lcd_print
;   62 lcd_print(0, 8, test1)
                               movlw    8
                               datalo_clr v___y_13
                               datahi_clr v___y_13
                               movwf    v___y_13
                               movlw    20
                               movwf    v____str_count_1
                               clrf     v____str_count_1+1
                               movlw    l__data_test1
                               movwf    v___str_3
                               movlw    HIGH l__data_test1
                               iorlw    64
                               movwf    v___str_3+1
                               movlw    0
                               branchlo_set l_lcd_print
                               branchhi_clr l_lcd_print
                               call     l_lcd_print
;   63 lcd_print(0, 16, test2)
                               movlw    16
                               datalo_clr v___y_13
                               datahi_clr v___y_13
                               movwf    v___y_13
                               movlw    20
                               movwf    v____str_count_1
                               clrf     v____str_count_1+1
                               movlw    l__data_test2
                               movwf    v___str_3
                               movlw    HIGH l__data_test2
                               iorlw    64
                               movwf    v___str_3+1
                               movlw    0
                               branchlo_set l_lcd_print
                               branchhi_clr l_lcd_print
                               call     l_lcd_print
;   64 lcd_print(0, 24, test3)
                               movlw    24
                               datalo_clr v___y_13
                               datahi_clr v___y_13
                               movwf    v___y_13
                               movlw    20
                               movwf    v____str_count_1
                               clrf     v____str_count_1+1
                               movlw    l__data_test3
                               movwf    v___str_3
                               movlw    HIGH l__data_test3
                               iorlw    64
                               movwf    v___str_3+1
                               movlw    0
                               branchlo_set l_lcd_print
                               branchhi_clr l_lcd_print
                               call     l_lcd_print
;   65 lcd_print(0, 32, test4)
                               movlw    32
                               datalo_clr v___y_13
                               datahi_clr v___y_13
                               movwf    v___y_13
                               movlw    17
                               movwf    v____str_count_1
                               clrf     v____str_count_1+1
                               movlw    l__data_test4
                               movwf    v___str_3
                               movlw    HIGH l__data_test4
                               iorlw    64
                               movwf    v___str_3+1
                               movlw    0
                               branchlo_set l_lcd_print
                               branchhi_clr l_lcd_print
                               call     l_lcd_print
;   66 lcd_print(0, 40, test5)
                               movlw    40
                               datalo_clr v___y_13
                               datahi_clr v___y_13
                               movwf    v___y_13
                               movlw    13
                               movwf    v____str_count_1
                               clrf     v____str_count_1+1
                               movlw    l__data_test5
                               movwf    v___str_3
                               movlw    HIGH l__data_test5
                               iorlw    64
                               movwf    v___str_3+1
                               movlw    0
                               branchlo_set l_lcd_print
                               branchhi_clr l_lcd_print
                               call     l_lcd_print
;   69 for 150 using timer loop
                               datalo_clr v_timer
                               datahi_clr v_timer
                               clrf     v_timer
l__l950
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
                               comf     v_timer,w
                               movwf    v____temp_47
                               movlw    151
                               addwf    v____temp_47,f
                               clrf     v___x0_8
                               movlw    49
                               movwf    v___y_16
                               movlw    54
                               movwf    v___x1_8
                               movf     v____temp_47,w
                               movwf    v___value_4
                               clrf     v___value_4+1
                               movlw    150
                               movwf    v___max_4
                               clrf     v___max_4+1
                               bsf      v__bitbucket, 7 ; startleft2
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  218 	maxX = x1 - x0 - 1 			-- Calculate our maximum horizontal space we can use.
                               movf     v___x0_8,w
                               subwf    v___x1_8,w
                               movwf    v____temp_123+1
                               decf     v____temp_123+1,w
                               movwf    v___maxx_1
;  219 	theValue = (value*100)		-- Times 100.. Because we cannot handle numbers > 1
                               movf     v___value_4,w
                               movwf    v__pic_multiplier
                               movf     v___value_4+1,w
                               movwf    v__pic_multiplier+1
                               movlw    100
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               branchhi_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               movwf    v___thevalue_2
                               movf     v__pic_mresult+1,w
                               movwf    v___thevalue_2+1
;  220 	theValue = theValue / max	-- Calculate percentage
                               movf     v___max_4,w
                               movwf    v__pic_divisor
                               movf     v___max_4+1,w
                               movwf    v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               movf     v___thevalue_2,w
                               movwf    v__pic_dividend
                               movf     v___thevalue_2+1,w
                               movwf    v__pic_dividend+1
                               clrf     v__pic_dividend+2
                               clrf     v__pic_dividend+3
                               branchlo_clr l__pic_divide
                               branchhi_clr l__pic_divide
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               movwf    v___thevalue_2
                               movf     v__pic_quotient+1,w
                               movwf    v___thevalue_2+1
;  221 	theValue = theValue * maxX	-- Times the maxX so that 100% = maxX
                               movf     v___thevalue_2,w
                               movwf    v__pic_multiplier
                               movf     v___thevalue_2+1,w
                               movwf    v__pic_multiplier+1
                               movf     v___maxx_1,w
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               branchhi_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               movwf    v___thevalue_2
                               movf     v__pic_mresult+1,w
                               movwf    v___thevalue_2+1
;  222 	theValue = theValue / 100	-- And divide that by 100, so that we get a number that is below maxX
                               movlw    100
                               movwf    v__pic_divisor
                               clrf     v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               movf     v___thevalue_2,w
                               movwf    v__pic_dividend
                               movf     v___thevalue_2+1,w
                               movwf    v__pic_dividend+1
                               clrf     v__pic_dividend+2
                               clrf     v__pic_dividend+3
                               branchlo_clr l__pic_divide
                               branchhi_clr l__pic_divide
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               movwf    v___thevalue_2
                               movf     v__pic_quotient+1,w
                               movwf    v___thevalue_2+1
;  225 	if startLeft then
                               branchlo_set l__l953
                               branchhi_clr l__l953
                               btfss    v__bitbucket, 7 ; startleft2
                               goto     l__l953
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  226 		lcd_filled_rect(x0, y, theValue+1, y+5, 1)		-- Fill the part that needs filling
                               movlw    1
                               addwf    v___thevalue_2,w
                               movwf    v____temp_123
                               movlw    0
                               btfsc    v__status, v__c
                               movlw    1
                               addwf    v___thevalue_2+1,w
                               movwf    v____temp_123+1
                               movlw    5
                               addwf    v___y_16,w
                               movwf    v____temp_123+2
                               movf     v___y_16,w
                               movwf    v___y0_5
                               movf     v____temp_123,w
                               movwf    v___x1_5
                               movf     v____temp_123+2,w
                               movwf    v___y1_5
                               datalo_set v____bitbucket_9 ; state1
                               bsf      v____bitbucket_9, 0 ; state1
                               datalo_clr v___x0_8
                               movf     v___x0_8,w
                               call     l_lcd_filled_rect
;  227 		lcd_filled_rect(theValue, y+1, x1-1, y+5, 0)	-- And empty the part that doesn't
                               datalo_clr v___y_16
                               datahi_clr v___y_16
                               incf     v___y_16,w
                               movwf    v____temp_123
                               decf     v___x1_8,w
                               movwf    v____temp_123+1
                               movlw    5
                               addwf    v___y_16,w
                               movwf    v____temp_123+2
                               movf     v____temp_123,w
                               movwf    v___y0_5
                               movf     v____temp_123+1,w
                               movwf    v___x1_5
                               movf     v____temp_123+2,w
                               movwf    v___y1_5
                               datalo_set v____bitbucket_9 ; state1
                               bcf      v____bitbucket_9, 0 ; state1
                               datalo_clr v___thevalue_2
                               movf     v___thevalue_2,w
                               branchlo_set l_lcd_filled_rect
                               branchhi_clr l_lcd_filled_rect
                               call     l_lcd_filled_rect
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  228 	else
                               branchlo_set l__l954
                               branchhi_clr l__l954
                               goto     l__l954
l__l953
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  229 		lcd_filled_rect(x0, y, theValue+1, y+5, 0)		-- Fill the part that needs filling
                               movlw    1
                               addwf    v___thevalue_2,w
                               movwf    v____temp_123
                               movlw    0
                               btfsc    v__status, v__c
                               movlw    1
                               addwf    v___thevalue_2+1,w
                               movwf    v____temp_123+1
                               movlw    5
                               addwf    v___y_16,w
                               movwf    v____temp_123+2
                               movf     v___y_16,w
                               movwf    v___y0_5
                               movf     v____temp_123,w
                               movwf    v___x1_5
                               movf     v____temp_123+2,w
                               movwf    v___y1_5
                               datalo_set v____bitbucket_9 ; state1
                               bcf      v____bitbucket_9, 0 ; state1
                               datalo_clr v___x0_8
                               movf     v___x0_8,w
                               call     l_lcd_filled_rect
;  230 		lcd_filled_rect(theValue, y+1, x1-1, y+5, 1)	-- And empty the part that doesn't
                               datalo_clr v___y_16
                               datahi_clr v___y_16
                               incf     v___y_16,w
                               movwf    v____temp_123
                               decf     v___x1_8,w
                               movwf    v____temp_123+1
                               movlw    5
                               addwf    v___y_16,w
                               movwf    v____temp_123+2
                               movf     v____temp_123,w
                               movwf    v___y0_5
                               movf     v____temp_123+1,w
                               movwf    v___x1_5
                               movf     v____temp_123+2,w
                               movwf    v___y1_5
                               datalo_set v____bitbucket_9 ; state1
                               bsf      v____bitbucket_9, 0 ; state1
                               datalo_clr v___thevalue_2
                               movf     v___thevalue_2,w
                               branchlo_set l_lcd_filled_rect
                               branchhi_clr l_lcd_filled_rect
                               call     l_lcd_filled_rect
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  231 	end if
l__l954
;  232 	lcd_rect(x0,y,x1,y+5)							-- Draw the rectangle around it
                               movlw    5
                               datalo_clr v___y_16
                               datahi_clr v___y_16
                               addwf    v___y_16,w
                               movwf    v____rparam16_1
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;   52    lcd_line ( x0,y0, x1,y0 ,1)
                               movf     v___y_16,w
                               movwf    v___y0_1
                               movf     v___x1_8,w
                               movwf    v___x1_1
                               movf     v___y_16,w
                               movwf    v___y1_1
                               datalo_set v____bitbucket_11 ; onoff5
                               bsf      v____bitbucket_11, 0 ; onoff5
                               datalo_clr v___x0_8
                               movf     v___x0_8,w
                               branchlo_clr l_lcd_line
                               branchhi_clr l_lcd_line
                               call     l_lcd_line
;   53    lcd_line ( x1,y0, x1,y1 ,1)
                               datalo_clr v___y_16
                               datahi_clr v___y_16
                               movf     v___y_16,w
                               movwf    v___y0_1
                               movf     v___x1_8,w
                               movwf    v___x1_1
                               movf     v____rparam16_1,w
                               movwf    v___y1_1
                               datalo_set v____bitbucket_11 ; onoff5
                               bsf      v____bitbucket_11, 0 ; onoff5
                               datalo_clr v___x1_8
                               movf     v___x1_8,w
                               branchlo_clr l_lcd_line
                               branchhi_clr l_lcd_line
                               call     l_lcd_line
;   54    lcd_line ( x1,y1, x0,y1 ,1)
                               datalo_clr v____rparam16_1
                               datahi_clr v____rparam16_1
                               movf     v____rparam16_1,w
                               movwf    v___y0_1
                               movf     v___x0_8,w
                               movwf    v___x1_1
                               movf     v____rparam16_1,w
                               movwf    v___y1_1
                               datalo_set v____bitbucket_11 ; onoff5
                               bsf      v____bitbucket_11, 0 ; onoff5
                               datalo_clr v___x1_8
                               movf     v___x1_8,w
                               branchlo_clr l_lcd_line
                               branchhi_clr l_lcd_line
                               call     l_lcd_line
;   55    lcd_line ( x0,y1, x0,y0 ,1)
                               datalo_clr v____rparam16_1
                               datahi_clr v____rparam16_1
                               movf     v____rparam16_1,w
                               movwf    v___y0_1
                               movf     v___x0_8,w
                               movwf    v___x1_1
                               movf     v___y_16,w
                               movwf    v___y1_1
                               datalo_set v____bitbucket_11 ; onoff5
                               bsf      v____bitbucket_11, 0 ; onoff5
                               datalo_clr v___x0_8
                               movf     v___x0_8,w
                               branchlo_clr l_lcd_line
                               branchhi_clr l_lcd_line
                               call     l_lcd_line
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
; D:\My Documents\My Dropbox\Elektronica\glcd/glcd_common.jal
;  232 	lcd_rect(x0,y,x1,y+5)							-- Draw the rectangle around it
; D:\My Documents\My Dropbox\Elektronica\glcd\main.jal
;   71 	lcd_prg_hor(0, 49, 54, 150-timer, 150, 1)
;   72 	delay_1ms(10)
                               movlw    10
                               datalo_clr v___n_3
                               datahi_clr v___n_3
                               movwf    v___n_3
                               clrf     v___n_3+1
                               branchlo_clr l_delay_1ms
                               branchhi_clr l_delay_1ms
                               call     l_delay_1ms
;   73 end loop
                               datalo_clr v_timer
                               datahi_clr v_timer
                               incf     v_timer,f
                               movlw    150
                               subwf    v_timer,w
                               branchlo_set l__l950
                               branchhi_clr l__l950
                               btfss    v__status, v__z
                               goto     l__l950
;   75 lcd_clearscreen()
                               call     l_lcd_clearscreen
;   78 lcd_print(0, 0, adcte)
                               datalo_clr v___y_13
                               datahi_clr v___y_13
                               clrf     v___y_13
                               movlw    12
                               movwf    v____str_count_1
                               clrf     v____str_count_1+1
                               movlw    l__data_adcte
                               movwf    v___str_3
                               movlw    HIGH l__data_adcte
                               iorlw    64
                               movwf    v___str_3+1
                               movlw    0
                               branchlo_set l_lcd_print
                               branchhi_clr l_lcd_print
                               call     l_lcd_print
;   83 serial_hw_printf(done)
                               movlw    6
                               datalo_clr v__str_count
                               datahi_clr v__str_count
                               movwf    v__str_count
                               clrf     v__str_count+1
                               movlw    l__data_done
                               movwf    v___str_1
                               movlw    HIGH l__data_done
                               iorlw    64
                               movwf    v___str_1+1
                               branchlo_clr l_serial_hw_printf
                               branchhi_clr l_serial_hw_printf
                               call     l_serial_hw_printf
;   85 var byte graphLeft 		= 8		-- X
                               movlw    8
                               datalo_clr v_graphleft
                               datahi_clr v_graphleft
                               movwf    v_graphleft
;   86 var byte graphRight		= 126	-- X
                               movlw    126
                               movwf    v_graphright
;   87 var byte graphTop		= 18	-- Y
                               movlw    18
                               movwf    v_graphtop
;   88 var byte graphBottom	= 63	-- Y
                               movlw    63
                               movwf    v_graphbottom
;   92 var dword graphY = 0
                               clrf     v_graphy
                               clrf     v_graphy+1
                               clrf     v_graphy+2
                               clrf     v_graphy+3
;   95 lcd_line(graphLeft, graphBottom, graphRight, graphBottom, 1)
                               movf     v_graphbottom,w
                               movwf    v___y0_1
                               movf     v_graphright,w
                               movwf    v___x1_1
                               movf     v_graphbottom,w
                               movwf    v___y1_1
                               datalo_set v____bitbucket_11 ; onoff5
                               bsf      v____bitbucket_11, 0 ; onoff5
                               datalo_clr v_graphleft
                               movf     v_graphleft,w
                               branchlo_clr l_lcd_line
                               branchhi_clr l_lcd_line
                               call     l_lcd_line
;   96 lcd_line(graphLeft, graphTop, graphLeft, graphBottom, 1)
                               datalo_clr v_graphtop
                               datahi_clr v_graphtop
                               movf     v_graphtop,w
                               movwf    v___y0_1
                               movf     v_graphleft,w
                               movwf    v___x1_1
                               movf     v_graphbottom,w
                               movwf    v___y1_1
                               datalo_set v____bitbucket_11 ; onoff5
                               bsf      v____bitbucket_11, 0 ; onoff5
                               datalo_clr v_graphleft
                               movf     v_graphleft,w
                               branchlo_clr l_lcd_line
                               branchhi_clr l_lcd_line
                               call     l_lcd_line
;   97 forever loop
l__l957
;   99 	measure_a = adc_read(ADC_CHANNEL_A)
                               movlw    0
                               branchlo_clr l_adc_read
                               branchhi_clr l_adc_read
                               call     l_adc_read
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movf     v__pic_temp,w
                               movwf    v_measure_a
                               movf     v__pic_temp+1,w
                               movwf    v_measure_a+1
;  100 	e1 = (measure_a < (oldADC - 3))
                               movf     v_oldadc+1,w
                               movwf    v____temp_47+1
                               movlw    3
                               subwf    v_oldadc,w
                               movwf    v____temp_47
                               btfss    v__status, v__c
                               decf     v____temp_47+1,f
                               movf     v_measure_a+1,w
                               subwf    v____temp_47+1,w
                               branchlo_clr l__l1167
                               branchhi_set l__l1167
                               btfss    v__status, v__z
                               goto     l__l1167
                               movf     v_measure_a,w
                               subwf    v____temp_47,w
l__l1167
                               bcf      v__bitbucket, 5 ; e12
                               btfsc    v__status, v__z
                               goto     l__l1168
                               btfsc    v__status, v__c
                               bsf      v__bitbucket, 5 ; e12
l__l1168
;  101 	e2 = (measure_a > (oldADC + 3))
                               movf     v_oldadc+1,w
                               movwf    v____temp_47+1
                               movlw    3
                               addwf    v_oldadc,w
                               movwf    v____temp_47
                               btfsc    v__status, v__c
                               incf     v____temp_47+1,f
                               movf     v_measure_a+1,w
                               subwf    v____temp_47+1,w
                               btfss    v__status, v__z
                               goto     l__l1169
                               movf     v_measure_a,w
                               subwf    v____temp_47,w
l__l1169
                               bcf      v__bitbucket, 6 ; e22
                               btfsc    v__status, v__z
                               goto     l__l1170
                               btfss    v__status, v__c
                               bsf      v__bitbucket, 6 ; e22
l__l1170
;  102 	if e1 | e2 then
                               bcf      v__bitbucket, 4 ; _btemp107
                               btfss    v__bitbucket, 5 ; e12
                               btfsc    v__bitbucket, 6 ; e22
                               bsf      v__bitbucket, 4 ; _btemp107
                               branchlo_set l__l957
                               branchhi_clr l__l957
                               btfss    v__bitbucket, 4 ; _btemp107
                               goto     l__l957
;  103 		lcd_num(0, 8, measure_a)
                               movlw    8
                               movwf    v___y_11
                               movf     v_measure_a,w
                               movwf    v___num_1
                               movf     v_measure_a+1,w
                               movwf    v___num_1+1
                               movlw    0
                               call     l_lcd_num
;  104 		oldADC = measure_a
                               datalo_clr v_measure_a
                               datahi_clr v_measure_a
                               movf     v_measure_a,w
                               movwf    v_oldadc
                               movf     v_measure_a+1,w
                               movwf    v_oldadc+1
;  107 		ADCLowRes = adc_read_low_res(ADC_CHANNEL_A)
                               movlw    0
                               branchlo_clr l_adc_read_low_res
                               branchhi_clr l_adc_read_low_res
                               call     l_adc_read_low_res
                               datalo_clr v_adclowres
                               datahi_clr v_adclowres
                               movwf    v_adclowres
;  108 		graphY = ADCLowRes * 100
                               movf     v_adclowres,w
                               movwf    v__pic_multiplier
                               clrf     v__pic_multiplier+1
                               movlw    100
                               movwf    v__pic_multiplicand
                               clrf     v__pic_multiplicand+1
                               branchlo_clr l__pic_multiply
                               branchhi_clr l__pic_multiply
                               call     l__pic_multiply
                               datalo_clr v__pic_mresult
                               datahi_clr v__pic_mresult
                               movf     v__pic_mresult,w
                               movwf    v_graphy
                               movf     v__pic_mresult+1,w
                               movwf    v_graphy+1
                               clrf     v_graphy+2
                               clrf     v_graphy+3
;  109 		graphY = graphY / 255
                               movlw    255
                               movwf    v__pic_divisor
                               clrf     v__pic_divisor+1
                               clrf     v__pic_divisor+2
                               clrf     v__pic_divisor+3
                               movf     v_graphy,w
                               movwf    v__pic_dividend
                               movf     v_graphy+1,w
                               movwf    v__pic_dividend+1
                               movf     v_graphy+2,w
                               movwf    v__pic_dividend+2
                               movf     v_graphy+3,w
                               movwf    v__pic_dividend+3
                               branchlo_clr l__pic_divide
                               branchhi_clr l__pic_divide
                               call     l__pic_divide
                               datalo_clr v__pic_quotient
                               datahi_clr v__pic_quotient
                               movf     v__pic_quotient,w
                               movwf    v_graphy
                               movf     v__pic_quotient+1,w
                               movwf    v_graphy+1
                               movf     v__pic_quotient+2,w
                               movwf    v_graphy+2
                               movf     v__pic_quotient+3,w
                               movwf    v_graphy+3
;  113 	end if
;  126 end loop
                               branchlo_set l__l957
                               branchhi_clr l__l957
                               goto     l__l957
                               end
