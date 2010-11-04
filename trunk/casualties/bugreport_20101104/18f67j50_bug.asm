; compiler: jal 2.4n (compiled Jun  2 2010)

; command line:  D:\jalv2\compiler\jalv2.exe -s D:\jalv2\lib -no-variable-reuse -hex D:\jalv2\sample\temp.hex G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
                                list p=18f67j50, r=dec
                                errorlevel -306 ; no page boundary warnings
                                errorlevel -302 ; no bank 0 warnings
                                errorlevel -202 ; no 'argument out of range' warnings

                             __config 0x0001fff8, 0xec
                             __config 0x0001fff9, 0xf7
                             __config 0x0001fffa, 0x02
                             __config 0x0001fffb, 0xff
                             __config 0x0001fffc, 0x00
                             __config 0x0001fffd, 0xf3
                             __config 0x0001fffe, 0x00
                             __config 0x0001ffff, 0xf0
v_true                         EQU 1
v_false                        EQU 0
v__pic_accum                   EQU 0x005e  ; _pic_accum
v_baudctl1                     EQU 0x0f7e  ; baudctl1
v_baudctl1_brg16               EQU 0x0f7e  ; baudctl1_brg16-->baudctl1:3
v_spbrgh1                      EQU 0x0f7f  ; spbrgh1
v_osctune                      EQU 0x0f9b  ; osctune
v_osctune_pllen                EQU 0x0f9b  ; osctune_pllen-->osctune:6
v_pie1                         EQU 0x0f9d  ; pie1
v_pie1_rc1ie                   EQU 0x0f9d  ; pie1_rc1ie-->pie1:5
v_pie1_tx1ie                   EQU 0x0f9d  ; pie1_tx1ie-->pie1:4
v_pir1                         EQU 0x0f9e  ; pir1
v_pir1_tx1if                   EQU 0x0f9e  ; pir1_tx1if-->pir1:4
v_rcsta1                       EQU 0x0fac  ; rcsta1
v_txsta1                       EQU 0x0fad  ; txsta1
v_txsta1_txen                  EQU 0x0fad  ; txsta1_txen-->txsta1:5
v_txsta1_brgh                  EQU 0x0fad  ; txsta1_brgh-->txsta1:2
v_txreg1                       EQU 0x0fae  ; txreg1
v_spbrg1                       EQU 0x0fb0  ; spbrg1
v_wdtcon                       EQU 0x0fc0  ; wdtcon
v_wdtcon_adshr                 EQU 0x0fc0  ; wdtcon_adshr-->wdtcon:4
v_adcon1                       EQU 0x0fc1  ; adcon1
v_adcon0                       EQU 0x0fc2  ; adcon0
v_cm2con1                      EQU 0x0fd1  ; cm2con1
v_cm1con1                      EQU 0x0fd2  ; cm1con1
v_osccon                       EQU 0x0fd3  ; osccon
v__status                      EQU 0x0fd8  ; _status
v__z                           EQU 2
v__c                           EQU 0
v__banked                      EQU 1
v__access                      EQU 0
v__fsr0l                       EQU 0x0fe9  ; _fsr0l
v__fsr0h                       EQU 0x0fea  ; _fsr0h
v__ind                         EQU 0x0fef  ; _ind
v__tablat                      EQU 0x0ff5  ; _tablat
v__tblptr                      EQU 0x0ff6  ; _tblptr
v__pcl                         EQU 0x0ff9  ; _pcl
v__pclath                      EQU 0x0ffa  ; _pclath
v__pclatu                      EQU 0x0ffb  ; _pclatu
v__ancon0                      EQU 0x0fc1  ; _ancon0
v__ancon1                      EQU 0x0fc2  ; _ancon1
v_ascii_lf                     EQU 10
v_ascii_cr                     EQU 13
v_print_prefix                 EQU 0x0089  ; print_prefix-->_bitbucket:0
v_sd_sector_buffer_low         EQU 0x0100  ; sd_sector_buffer_low
v_sd_sector_buffer_high        EQU 0x0200  ; sd_sector_buffer_high
v_string1                      EQU 0x006f  ; string1
v__bitbucket                   EQU 0x0089  ; _bitbucket
v__pic_temp                    EQU 0x0060  ; _pic_temp-->_pic_state
v__pic_pointer                 EQU 0x006a  ; _pic_pointer
v__pic_loop                    EQU 0x0068  ; _pic_loop
v__pic_divisor                 EQU 0x0064  ; _pic_divisor-->_pic_state+4
v__pic_dividend                EQU 0x0060  ; _pic_dividend-->_pic_state
v__pic_quotient                EQU 0x0066  ; _pic_quotient-->_pic_state+6
v__pic_remainder               EQU 0x0062  ; _pic_remainder-->_pic_state+2
v__pic_divaccum                EQU 0x0060  ; _pic_divaccum-->_pic_state
v__pic_state                   EQU 0x0060  ; _pic_state
v___x_265                      EQU 0x008a  ; x
v___x_266                      EQU 0x008b  ; x
v____device_put_22             EQU 0x008c  ; fat32_print_sector_buffer_hex:_device_put
v___bytes_per_line_1           EQU 0x008f  ; fat32_print_sector_buffer_hex:bytes_per_line
v_step1                        EQU 0x0091  ; fat32_print_sector_buffer_hex:step1
v__floop3                      EQU 0x0093  ; fat32_print_sector_buffer_hex:_floop3
v__floop4                      EQU 0x0095  ; fat32_print_sector_buffer_hex:_floop4
v__floop5                      EQU 0x0097  ; fat32_print_sector_buffer_hex:_floop5
v__floop6                      EQU 0x0099  ; fat32_print_sector_buffer_hex:_floop6
v____device_put_12             EQU 0x009b  ; print_byte_hex:_device_put
v___data_37                    EQU 0x009e  ; print_byte_hex:data
v____temp_65                   EQU 0x009f  ; print_byte_hex:_temp
v____device_put_9              EQU 0x00a1  ; print_dword_hex:_device_put
v___data_31                    EQU 0x00a4  ; print_dword_hex:data
v____temp_62                   EQU 0x00a8  ; print_dword_hex:_temp
v____device_put_1              EQU 0x00b0  ; print_string:_device_put
v__str_count                   EQU 0x00b3  ; print_string:_str_count
v___str_1                      EQU 0x00b5  ; print_string:str
v_len                          EQU 0x00b8  ; print_string:len
v_i                            EQU 0x00ba  ; print_string:i
v__device_put                  EQU 0x00bb  ; print_crlf:_device_put
v___data_9                     EQU 0x006d  ; _serial_hw_data_put:data
v___data_3                     EQU 0       ; serial_hw_write_word(): data
v___data_1                     EQU 0x006e  ; serial_hw_write:data
v_usart_div                    EQU 103     ; _calculate_and_set_baudrate(): usart_div
;   25 include 18f67j50                    -- target PICmicro
                               org      0
                               goto     l__main
l__data_nibble2hex
                               db       0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
                               db       0x38,0x39,0x41,0x42,0x43,0x44,0x45,0x46
l__pic_divide
                               movlw    16
                               movwf    v__pic_loop,v__banked
                               clrf     v__pic_remainder,v__banked
                               clrf     v__pic_remainder+1,v__banked
l__l545
                               bcf      v__status, v__c,v__access
                               rlcf     v__pic_quotient,f,v__banked
                               rlcf     v__pic_quotient+1,f,v__banked
                               bcf      v__status, v__c,v__access
                               rlcf     v__pic_divaccum,f,v__banked
                               rlcf     v__pic_divaccum+1,f,v__banked
                               rlcf     v__pic_divaccum+2,f,v__banked
                               rlcf     v__pic_divaccum+3,f,v__banked
                               movf     v__pic_remainder+1,w,v__banked
                               subwf    v__pic_divisor+1,w,v__banked
                               btfss    v__status, v__z,v__access
                               goto     l__l548
                               movf     v__pic_remainder,w,v__banked
                               subwf    v__pic_divisor,w,v__banked
l__l548
                               btfsc    v__status, v__z,v__access
                               goto     l__l547
                               btfsc    v__status, v__c,v__access
                               goto     l__l546
l__l547
                               bsf      v__status, v__c,v__access
                               movf     v__pic_remainder,w,v__banked
                               subfwb   v__pic_divisor,w,v__banked
                               movwf    v__pic_remainder,v__banked
                               movf     v__pic_remainder+1,w,v__banked
                               subfwb   v__pic_divisor+1,w,v__banked
                               movwf    v__pic_remainder+1,v__banked
                               bsf      v__pic_quotient, 0,v__banked
l__l546
                               decfsz   v__pic_loop,f,v__banked
                               goto     l__l545
                               return   
l__pic_indirect
                               movwf    v__pclatu,v__access
                               movf     v__pic_pointer+1,w,v__banked
                               movwf    v__pclath,v__access
                               movf     v__pic_pointer,w,v__banked
                               movwf    v__pcl,v__access
l__main
; D:\jalv2\lib/18f67j50.jal
; 1815 WDTCON_ADSHR = FALSE                 -- ensure default (legacy) SFR mapping
                               bcf      v_wdtcon, 4,v__access ; wdtcon_adshr
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   35 OSCTUNE_PLLEN = 1                  -- set 96mhz pll
                               bsf      v_osctune, 6,v__access ; osctune_pllen
;   36 OSCCON_SCS = 0b00
                               movlw    252
                               andwf    v_osccon,f,v__access
;   37 _usec_delay(1_000)                 -- wait for OSC PLL to settle
                               movlb    0
                               movlw    67
                               movwf    v__pic_temp,v__banked
l__l549
                               movlw    58
                               movwf    v__pic_temp+1,v__banked
l__l550
                               decfsz   v__pic_temp+1,f,v__banked
                               goto     l__l550
                               decfsz   v__pic_temp,f,v__banked
                               goto     l__l549
                               nop      
                               nop      
                               nop      
                               nop      
;   42 enable_digital_io()                -- make all pins digital I/O
; D:\jalv2\lib/18f67j50.jal
; 2674    ANCON0 = 0b1111_1111        -- all digital
                               movlw    255
                               movwf    v___x_265,v__banked
                               bsf      v_wdtcon, 4,v__access ; wdtcon_adshr
                               movf     v___x_265,w,v__banked
                               movwf    v__ancon0,v__access
                               bcf      v_wdtcon, 4,v__access ; wdtcon_adshr
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   42 enable_digital_io()                -- make all pins digital I/O
; D:\jalv2\lib/18f67j50.jal
; 2674    ANCON0 = 0b1111_1111        -- all digital
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   42 enable_digital_io()                -- make all pins digital I/O
; D:\jalv2\lib/18f67j50.jal
; 2675    ANCON1 = 0b1111_1111        -- all digital
                               movlw    255
                               movwf    v___x_266,v__banked
                               bsf      v_wdtcon, 4,v__access ; wdtcon_adshr
                               movf     v___x_266,w,v__banked
                               movwf    v__ancon1,v__access
                               bcf      v_wdtcon, 4,v__access ; wdtcon_adshr
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   42 enable_digital_io()                -- make all pins digital I/O
; D:\jalv2\lib/18f67j50.jal
; 2675    ANCON1 = 0b1111_1111        -- all digital
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   42 enable_digital_io()                -- make all pins digital I/O
; D:\jalv2\lib/18f67j50.jal
; 2698    analog_off()
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   42 enable_digital_io()                -- make all pins digital I/O
; D:\jalv2\lib/18f67j50.jal
; 2682    ADCON0 = 0b0000_0000         -- disable ADC
                               clrf     v_adcon0,v__access
; 2683    ADCON1 = 0b0000_0000
                               clrf     v_adcon1,v__access
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   42 enable_digital_io()                -- make all pins digital I/O
; D:\jalv2\lib/18f67j50.jal
; 2699    adc_off()
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   42 enable_digital_io()                -- make all pins digital I/O
; D:\jalv2\lib/18f67j50.jal
; 2690    CM1CON1 = 0b0000_0000       -- disable comparator
                               clrf     v_cm1con1,v__access
; 2691    CM2CON1 = 0b0000_0000       -- disable 2nd comparator
                               clrf     v_cm2con1,v__access
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   42 enable_digital_io()                -- make all pins digital I/O
; D:\jalv2\lib/18f67j50.jal
; 2700    comparator_off()
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   42 enable_digital_io()                -- make all pins digital I/O
; D:\jalv2\lib/usart_common.jal
;   21 end if
                               goto     l__l430
;   43 procedure _calculate_and_set_baudrate() is
l__calculate_and_set_baudrate
;   49          BAUDCTL_BRG16 = true
                               bsf      v_baudctl1, 3,v__access ; baudctl1_brg16
;   50          TXSTA_BRGH = true
                               bsf      v_txsta1, 2,v__access ; txsta1_brgh
;   65          SPBRG = byte(usart_div)
                               movlw    103
                               movwf    v_spbrg1,v__access
;   66          SPBRGH = byte(usart_div >> 8)
                               clrf     v_spbrgh1,v__access
;  152 end procedure
                               return   
; D:\jalv2\lib/serial_hardware.jal
;   26 procedure serial_hw_init() is 
l_serial_hw_init
;   28    _calculate_and_set_baudrate()
                               call     l__calculate_and_set_baudrate
;   31    PIE1_RCIE = false
                               bcf      v_pie1, 5,v__access ; pie1_rc1ie
;   32    PIE1_TXIE = false
                               bcf      v_pie1, 4,v__access ; pie1_tx1ie
;   35    TXSTA_TXEN = true
                               bsf      v_txsta1, 5,v__access ; txsta1_txen
;   39    RCSTA = 0x90
                               movlw    144
                               movwf    v_rcsta1,v__access
;   41 end procedure
                               return   
;   68 procedure serial_hw_write(byte in data) is
l_serial_hw_write
                               movwf    v___data_1,v__banked
;   70    while ! PIR1_TXIF loop end loop
l__l392
                               btfss    v_pir1, 4,v__access ; pir1_tx1if
                               goto     l__l392
l__l393
;   72    TXREG = data
                               movf     v___data_1,w,v__banked
                               movwf    v_txreg1,v__access
;   73 end procedure
                               return   
;  147 procedure serial_hw_data'put(byte in data) is
l__serial_hw_data_put
                               movlb    0
                               movf     v__pic_temp,w,v__banked
                               movwf    v___data_9,v__banked
;  148    serial_hw_write(data)
                               movf     v___data_9,w,v__banked
                               goto     l_serial_hw_write
;  149 end procedure
;  176 end function
l__l430
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   48 serial_hw_init()
                               call     l_serial_hw_init
; D:\jalv2\lib/print.jal
;   55 var bit print_prefix = false        
                               movlb    0
                               bcf      v__bitbucket, 0,v__banked ; print_prefix
;   57 procedure print_crlf(volatile byte out device) is
                               goto     l__l527
l_print_crlf
;   58    device = ASCII_CR -- cariage return
                               movlw    13
                               movwf    v__pic_temp,v__banked
                               movf     v__device_put,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v__device_put+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v__device_put+2,w,v__banked
                               call     l__pic_indirect
;   59    device = ASCII_LF -- line feed
                               movlw    10
                               movlb    0
                               movwf    v__pic_temp,v__banked
                               movf     v__device_put,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v__device_put+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v__device_put+2,w,v__banked
                               goto     l__pic_indirect
;   60 end procedure
;   62 procedure print_string(volatile byte out device, byte in str[]) is
l_print_string
;   63    var word len = count(str)
                               movf     v__str_count,w,v__banked
                               movwf    v_len,v__banked
                               movf     v__str_count+1,w,v__banked
                               movwf    v_len+1,v__banked
;   66    for len using i loop           
                               clrf     v_i,v__banked
                               goto     l__l451
l__l450
;   70       device = str[i]
                               movf     v___str_1,w,v__banked
                               addwf    v_i,w,v__banked
                               movwf    v__fsr0l,v__access
                               movf     v___str_1+1,w,v__banked
                               movwf    v__fsr0h,v__access
                               movf     v__ind,w,v__access
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_1,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_1+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_1+2,w,v__banked
                               call     l__pic_indirect
;   71    end loop
                               movlb    0
                               incf     v_i,f,v__banked
l__l451
                               movf     v_i,w,v__banked
                               subwf    v_len,w,v__banked
                               movwf    v__pic_temp,v__banked
                               movf     v_len+1,w,v__banked
                               iorwf    v__pic_temp,w,v__banked
                               btfss    v__status, v__z,v__access
                               goto     l__l450
;   73 end procedure
                               return   
;  172 procedure print_dword_hex(volatile byte out device, dword in data) is
l_print_dword_hex
;  174    if (print_prefix) then
                               btfss    v__bitbucket, 0,v__banked ; print_prefix
                               goto     l__l491
;  175       device = "0"
                               movlw    48
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_9,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_9+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_9+2,w,v__banked
                               call     l__pic_indirect
;  176       device = "x"
                               movlw    120
                               movlb    0
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_9,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_9+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_9+2,w,v__banked
                               call     l__pic_indirect
;  177    end if
l__l491
;  179    device = nibble2hex[0x0F & (data>>28)]
                               movlb    0
                               swapf    v___data_31+3,w,v__banked
                               andlw    15
                               movwf    v____temp_62,v__banked
                               clrf     v____temp_62+1,v__banked
                               clrf     v____temp_62+2,v__banked
                               clrf     v____temp_62+3,v__banked
                               movlw    15
                               andwf    v____temp_62,w,v__banked
                               movwf    v____temp_62+4,v__banked
                               clrf     v____temp_62+5,v__banked
                               clrf     v____temp_62+6,v__banked
                               clrf     v____temp_62+7,v__banked
                               movlw    l__data_nibble2hex
                               movwf    v__tblptr,v__access
                               movlw    HIGH l__data_nibble2hex
                               movwf    v__tblptr+1,v__access
                               movlw    UPPER l__data_nibble2hex
                               movwf    v__tblptr+2,v__access
                               movf     v__tblptr,w,v__access
                               addwf    v____temp_62+4,w,v__banked
                               movwf    v__pic_temp+1,v__banked
                               movf     v__tblptr+1,w,v__access
                               addwfc   v____temp_62+5,w,v__banked
                               movwf    v__pic_temp+2,v__banked
                               movf     v__tblptr+2,w,v__access
                               addwfc   v____temp_62+6,w,v__banked
                               movwf    v__pic_temp+3,v__banked
                               movf     v__pic_temp+1,w,v__banked
                               movwf    v__tblptr,v__access
                               movf     v__pic_temp+2,w,v__banked
                               movwf    v__tblptr+1,v__access
                               movf     v__pic_temp+3,w,v__banked
                               movwf    v__tblptr+2,v__access
                               tblrd    *+
                               movf     v__tablat,w,v__access
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_9,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_9+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_9+2,w,v__banked
                               call     l__pic_indirect
;  180    device = nibble2hex[0x0F & (data>>24)]
                               movlb    0
                               movf     v___data_31+3,w,v__banked
                               movwf    v____temp_62,v__banked
                               clrf     v____temp_62+1,v__banked
                               clrf     v____temp_62+2,v__banked
                               clrf     v____temp_62+3,v__banked
                               movlw    15
                               andwf    v____temp_62,w,v__banked
                               movwf    v____temp_62+4,v__banked
                               clrf     v____temp_62+5,v__banked
                               clrf     v____temp_62+6,v__banked
                               clrf     v____temp_62+7,v__banked
                               movlw    l__data_nibble2hex
                               movwf    v__tblptr,v__access
                               movlw    HIGH l__data_nibble2hex
                               movwf    v__tblptr+1,v__access
                               movlw    UPPER l__data_nibble2hex
                               movwf    v__tblptr+2,v__access
                               movf     v__tblptr,w,v__access
                               addwf    v____temp_62+4,w,v__banked
                               movwf    v__pic_temp+1,v__banked
                               movf     v__tblptr+1,w,v__access
                               addwfc   v____temp_62+5,w,v__banked
                               movwf    v__pic_temp+2,v__banked
                               movf     v__tblptr+2,w,v__access
                               addwfc   v____temp_62+6,w,v__banked
                               movwf    v__pic_temp+3,v__banked
                               movf     v__pic_temp+1,w,v__banked
                               movwf    v__tblptr,v__access
                               movf     v__pic_temp+2,w,v__banked
                               movwf    v__tblptr+1,v__access
                               movf     v__pic_temp+3,w,v__banked
                               movwf    v__tblptr+2,v__access
                               tblrd    *+
                               movf     v__tablat,w,v__access
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_9,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_9+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_9+2,w,v__banked
                               call     l__pic_indirect
;  181    device = nibble2hex[0x0F & (data>>20)]
                               movlb    0
                               movf     v___data_31+2,w,v__banked
                               movwf    v____temp_62,v__banked
                               movf     v___data_31+3,w,v__banked
                               movwf    v____temp_62+1,v__banked
                               clrf     v____temp_62+2,v__banked
                               clrf     v____temp_62+3,v__banked
                               movlw    4
                               movwf    v__pic_temp,v__banked
l__l551
                               bcf      v__status, v__c,v__access
                               rrcf     v____temp_62+1,f,v__banked
                               rrcf     v____temp_62,f,v__banked
                               decfsz   v__pic_temp,f,v__banked
                               goto     l__l551
                               movlw    15
                               andwf    v____temp_62,w,v__banked
                               movwf    v____temp_62+4,v__banked
                               clrf     v____temp_62+5,v__banked
                               clrf     v____temp_62+6,v__banked
                               clrf     v____temp_62+7,v__banked
                               movlw    l__data_nibble2hex
                               movwf    v__tblptr,v__access
                               movlw    HIGH l__data_nibble2hex
                               movwf    v__tblptr+1,v__access
                               movlw    UPPER l__data_nibble2hex
                               movwf    v__tblptr+2,v__access
                               movf     v__tblptr,w,v__access
                               addwf    v____temp_62+4,w,v__banked
                               movwf    v__pic_temp+1,v__banked
                               movf     v__tblptr+1,w,v__access
                               addwfc   v____temp_62+5,w,v__banked
                               movwf    v__pic_temp+2,v__banked
                               movf     v__tblptr+2,w,v__access
                               addwfc   v____temp_62+6,w,v__banked
                               movwf    v__pic_temp+3,v__banked
                               movf     v__pic_temp+1,w,v__banked
                               movwf    v__tblptr,v__access
                               movf     v__pic_temp+2,w,v__banked
                               movwf    v__tblptr+1,v__access
                               movf     v__pic_temp+3,w,v__banked
                               movwf    v__tblptr+2,v__access
                               tblrd    *+
                               movf     v__tablat,w,v__access
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_9,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_9+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_9+2,w,v__banked
                               call     l__pic_indirect
;  182    device = nibble2hex[0x0F & (data>>16)]
                               movlb    0
                               movf     v___data_31+2,w,v__banked
                               movwf    v____temp_62,v__banked
                               movf     v___data_31+3,w,v__banked
                               movwf    v____temp_62+1,v__banked
                               clrf     v____temp_62+2,v__banked
                               clrf     v____temp_62+3,v__banked
                               movlw    15
                               andwf    v____temp_62,w,v__banked
                               movwf    v____temp_62+4,v__banked
                               clrf     v____temp_62+5,v__banked
                               clrf     v____temp_62+6,v__banked
                               clrf     v____temp_62+7,v__banked
                               movlw    l__data_nibble2hex
                               movwf    v__tblptr,v__access
                               movlw    HIGH l__data_nibble2hex
                               movwf    v__tblptr+1,v__access
                               movlw    UPPER l__data_nibble2hex
                               movwf    v__tblptr+2,v__access
                               movf     v__tblptr,w,v__access
                               addwf    v____temp_62+4,w,v__banked
                               movwf    v__pic_temp+1,v__banked
                               movf     v__tblptr+1,w,v__access
                               addwfc   v____temp_62+5,w,v__banked
                               movwf    v__pic_temp+2,v__banked
                               movf     v__tblptr+2,w,v__access
                               addwfc   v____temp_62+6,w,v__banked
                               movwf    v__pic_temp+3,v__banked
                               movf     v__pic_temp+1,w,v__banked
                               movwf    v__tblptr,v__access
                               movf     v__pic_temp+2,w,v__banked
                               movwf    v__tblptr+1,v__access
                               movf     v__pic_temp+3,w,v__banked
                               movwf    v__tblptr+2,v__access
                               tblrd    *+
                               movf     v__tablat,w,v__access
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_9,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_9+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_9+2,w,v__banked
                               call     l__pic_indirect
;  183    device = nibble2hex[0x0F & (data>>12)]
                               movlb    0
                               movf     v___data_31+1,w,v__banked
                               movwf    v____temp_62,v__banked
                               movf     v___data_31+2,w,v__banked
                               movwf    v____temp_62+1,v__banked
                               movf     v___data_31+3,w,v__banked
                               movwf    v____temp_62+2,v__banked
                               clrf     v____temp_62+3,v__banked
                               movlw    4
                               movwf    v__pic_temp,v__banked
l__l552
                               bcf      v__status, v__c,v__access
                               rrcf     v____temp_62+2,f,v__banked
                               rrcf     v____temp_62+1,f,v__banked
                               rrcf     v____temp_62,f,v__banked
                               decfsz   v__pic_temp,f,v__banked
                               goto     l__l552
                               movlw    15
                               andwf    v____temp_62,w,v__banked
                               movwf    v____temp_62+4,v__banked
                               clrf     v____temp_62+5,v__banked
                               clrf     v____temp_62+6,v__banked
                               clrf     v____temp_62+7,v__banked
                               movlw    l__data_nibble2hex
                               movwf    v__tblptr,v__access
                               movlw    HIGH l__data_nibble2hex
                               movwf    v__tblptr+1,v__access
                               movlw    UPPER l__data_nibble2hex
                               movwf    v__tblptr+2,v__access
                               movf     v__tblptr,w,v__access
                               addwf    v____temp_62+4,w,v__banked
                               movwf    v__pic_temp+1,v__banked
                               movf     v__tblptr+1,w,v__access
                               addwfc   v____temp_62+5,w,v__banked
                               movwf    v__pic_temp+2,v__banked
                               movf     v__tblptr+2,w,v__access
                               addwfc   v____temp_62+6,w,v__banked
                               movwf    v__pic_temp+3,v__banked
                               movf     v__pic_temp+1,w,v__banked
                               movwf    v__tblptr,v__access
                               movf     v__pic_temp+2,w,v__banked
                               movwf    v__tblptr+1,v__access
                               movf     v__pic_temp+3,w,v__banked
                               movwf    v__tblptr+2,v__access
                               tblrd    *+
                               movf     v__tablat,w,v__access
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_9,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_9+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_9+2,w,v__banked
                               call     l__pic_indirect
;  184    device = nibble2hex[0x0F & (data>>8)]
                               movlb    0
                               movf     v___data_31+1,w,v__banked
                               movwf    v____temp_62,v__banked
                               movf     v___data_31+2,w,v__banked
                               movwf    v____temp_62+1,v__banked
                               movf     v___data_31+3,w,v__banked
                               movwf    v____temp_62+2,v__banked
                               clrf     v____temp_62+3,v__banked
                               movlw    15
                               andwf    v____temp_62,w,v__banked
                               movwf    v____temp_62+4,v__banked
                               clrf     v____temp_62+5,v__banked
                               clrf     v____temp_62+6,v__banked
                               clrf     v____temp_62+7,v__banked
                               movlw    l__data_nibble2hex
                               movwf    v__tblptr,v__access
                               movlw    HIGH l__data_nibble2hex
                               movwf    v__tblptr+1,v__access
                               movlw    UPPER l__data_nibble2hex
                               movwf    v__tblptr+2,v__access
                               movf     v__tblptr,w,v__access
                               addwf    v____temp_62+4,w,v__banked
                               movwf    v__pic_temp+1,v__banked
                               movf     v__tblptr+1,w,v__access
                               addwfc   v____temp_62+5,w,v__banked
                               movwf    v__pic_temp+2,v__banked
                               movf     v__tblptr+2,w,v__access
                               addwfc   v____temp_62+6,w,v__banked
                               movwf    v__pic_temp+3,v__banked
                               movf     v__pic_temp+1,w,v__banked
                               movwf    v__tblptr,v__access
                               movf     v__pic_temp+2,w,v__banked
                               movwf    v__tblptr+1,v__access
                               movf     v__pic_temp+3,w,v__banked
                               movwf    v__tblptr+2,v__access
                               tblrd    *+
                               movf     v__tablat,w,v__access
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_9,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_9+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_9+2,w,v__banked
                               call     l__pic_indirect
;  185    device = nibble2hex[0x0F & (data>>4)]
                               bcf      v__status, v__c,v__access
                               movlb    0
                               rrcf     v___data_31+3,w,v__banked
                               movwf    v____temp_62+3,v__banked
                               rrcf     v___data_31+2,w,v__banked
                               movwf    v____temp_62+2,v__banked
                               rrcf     v___data_31+1,w,v__banked
                               movwf    v____temp_62+1,v__banked
                               rrcf     v___data_31,w,v__banked
                               movwf    v____temp_62,v__banked
                               movlw    3
                               movwf    v__pic_temp,v__banked
l__l553
                               bcf      v__status, v__c,v__access
                               rrcf     v____temp_62+3,f,v__banked
                               rrcf     v____temp_62+2,f,v__banked
                               rrcf     v____temp_62+1,f,v__banked
                               rrcf     v____temp_62,f,v__banked
                               decfsz   v__pic_temp,f,v__banked
                               goto     l__l553
                               movlw    15
                               andwf    v____temp_62,w,v__banked
                               movwf    v____temp_62+4,v__banked
                               clrf     v____temp_62+5,v__banked
                               clrf     v____temp_62+6,v__banked
                               clrf     v____temp_62+7,v__banked
                               movlw    l__data_nibble2hex
                               movwf    v__tblptr,v__access
                               movlw    HIGH l__data_nibble2hex
                               movwf    v__tblptr+1,v__access
                               movlw    UPPER l__data_nibble2hex
                               movwf    v__tblptr+2,v__access
                               movf     v__tblptr,w,v__access
                               addwf    v____temp_62+4,w,v__banked
                               movwf    v__pic_temp+1,v__banked
                               movf     v__tblptr+1,w,v__access
                               addwfc   v____temp_62+5,w,v__banked
                               movwf    v__pic_temp+2,v__banked
                               movf     v__tblptr+2,w,v__access
                               addwfc   v____temp_62+6,w,v__banked
                               movwf    v__pic_temp+3,v__banked
                               movf     v__pic_temp+1,w,v__banked
                               movwf    v__tblptr,v__access
                               movf     v__pic_temp+2,w,v__banked
                               movwf    v__tblptr+1,v__access
                               movf     v__pic_temp+3,w,v__banked
                               movwf    v__tblptr+2,v__access
                               tblrd    *+
                               movf     v__tablat,w,v__access
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_9,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_9+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_9+2,w,v__banked
                               call     l__pic_indirect
;  186    device = nibble2hex[0x0F & (data)]
                               movlw    15
                               movlb    0
                               andwf    v___data_31,w,v__banked
                               movwf    v____temp_62,v__banked
                               clrf     v____temp_62+1,v__banked
                               clrf     v____temp_62+2,v__banked
                               clrf     v____temp_62+3,v__banked
                               movlw    l__data_nibble2hex
                               movwf    v__tblptr,v__access
                               movlw    HIGH l__data_nibble2hex
                               movwf    v__tblptr+1,v__access
                               movlw    UPPER l__data_nibble2hex
                               movwf    v__tblptr+2,v__access
                               movf     v__tblptr,w,v__access
                               addwf    v____temp_62,w,v__banked
                               movwf    v__pic_temp+1,v__banked
                               movf     v__tblptr+1,w,v__access
                               addwfc   v____temp_62+1,w,v__banked
                               movwf    v__pic_temp+2,v__banked
                               movf     v__tblptr+2,w,v__access
                               addwfc   v____temp_62+2,w,v__banked
                               movwf    v__pic_temp+3,v__banked
                               movf     v__pic_temp+1,w,v__banked
                               movwf    v__tblptr,v__access
                               movf     v__pic_temp+2,w,v__banked
                               movwf    v__tblptr+1,v__access
                               movf     v__pic_temp+3,w,v__banked
                               movwf    v__tblptr+2,v__access
                               tblrd    *+
                               movf     v__tablat,w,v__access
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_9,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_9+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_9+2,w,v__banked
                               goto     l__pic_indirect
;  188 end procedure
;  223 procedure print_byte_hex(volatile byte out device, byte in data) is             
l_print_byte_hex
                               movwf    v___data_37,v__banked
;  225    if (print_prefix) then
                               btfss    v__bitbucket, 0,v__banked ; print_prefix
                               goto     l__l503
;  226       device = "0"
                               movlw    48
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_12,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_12+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_12+2,w,v__banked
                               call     l__pic_indirect
;  227       device = "x"
                               movlw    120
                               movlb    0
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_12,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_12+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_12+2,w,v__banked
                               call     l__pic_indirect
;  228    end if
l__l503
;  230    device = nibble2hex[0x0F & (data>>4)]
                               movlb    0
                               swapf    v___data_37,w,v__banked
                               andlw    15
                               movwf    v____temp_65,v__banked
                               movlw    15
                               andwf    v____temp_65,w,v__banked
                               movwf    v____temp_65+1,v__banked
                               movlw    l__data_nibble2hex
                               movwf    v__tblptr,v__access
                               movlw    HIGH l__data_nibble2hex
                               movwf    v__tblptr+1,v__access
                               movlw    UPPER l__data_nibble2hex
                               movwf    v__tblptr+2,v__access
                               movf     v__tblptr,w,v__access
                               addwf    v____temp_65+1,w,v__banked
                               movwf    v__pic_temp+1,v__banked
                               movlw    0
                               movwf    v__pic_accum,v__access
                               movf     v__tblptr+1,w,v__access
                               addwfc   v__pic_accum,w,v__access
                               movwf    v__pic_temp+2,v__banked
                               movf     v__tblptr+2,w,v__access
                               addwfc   v__pic_accum,w,v__access
                               movwf    v__pic_temp+3,v__banked
                               movf     v__pic_temp+1,w,v__banked
                               movwf    v__tblptr,v__access
                               movf     v__pic_temp+2,w,v__banked
                               movwf    v__tblptr+1,v__access
                               movf     v__pic_temp+3,w,v__banked
                               movwf    v__tblptr+2,v__access
                               tblrd    *+
                               movf     v__tablat,w,v__access
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_12,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_12+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_12+2,w,v__banked
                               call     l__pic_indirect
;  231    device = nibble2hex[0x0F & (data)]
                               movlw    15
                               movlb    0
                               andwf    v___data_37,w,v__banked
                               movwf    v____temp_65,v__banked
                               movlw    l__data_nibble2hex
                               movwf    v__tblptr,v__access
                               movlw    HIGH l__data_nibble2hex
                               movwf    v__tblptr+1,v__access
                               movlw    UPPER l__data_nibble2hex
                               movwf    v__tblptr+2,v__access
                               movf     v__tblptr,w,v__access
                               addwf    v____temp_65,w,v__banked
                               movwf    v__pic_temp+1,v__banked
                               movlw    0
                               movwf    v__pic_accum,v__access
                               movf     v__tblptr+1,w,v__access
                               addwfc   v__pic_accum,w,v__access
                               movwf    v__pic_temp+2,v__banked
                               movf     v__tblptr+2,w,v__access
                               addwfc   v__pic_accum,w,v__access
                               movwf    v__pic_temp+3,v__banked
                               movf     v__pic_temp+1,w,v__banked
                               movwf    v__tblptr,v__access
                               movf     v__pic_temp+2,w,v__banked
                               movwf    v__tblptr+1,v__access
                               movf     v__pic_temp+3,w,v__banked
                               movwf    v__tblptr+2,v__access
                               tblrd    *+
                               movf     v__tablat,w,v__access
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_12,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_12+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_12+2,w,v__banked
                               goto     l__pic_indirect
;  233 end procedure
; G:\jallib\casualties\bugreport_20101104\18f67j50_bug.jal
;   61 procedure fat32_print_sector_buffer_hex(volatile byte out device,word in bytes_per_line) is
l_fat32_print_sector_buffer_hex
;   62    var word step1 = 0
                               clrf     v_step1,v__banked
                               clrf     v_step1+1,v__banked
;   63    for 512 / bytes_per_line loop
                               movf     v___bytes_per_line_1,w,v__banked
                               movwf    v__pic_divisor,v__banked
                               movf     v___bytes_per_line_1+1,w,v__banked
                               movwf    v__pic_divisor+1,v__banked
                               clrf     v__pic_dividend,v__banked
                               movlw    2
                               movwf    v__pic_dividend+1,v__banked
                               call     l__pic_divide
                               movlb    0
                               movf     v__pic_quotient,w,v__banked
                               movwf    v__floop3,v__banked
                               movf     v__pic_quotient+1,w,v__banked
                               movwf    v__floop3+1,v__banked
                               clrf     v__floop4,v__banked
                               clrf     v__floop4+1,v__banked
                               goto     l__l530
l__l529
;   64       print_crlf(device)
                               movf     v____device_put_22,w,v__banked
                               movwf    v__device_put,v__banked
                               movf     v____device_put_22+1,w,v__banked
                               movwf    v__device_put+1,v__banked
                               movf     v____device_put_22+2,w,v__banked
                               movwf    v__device_put+2,v__banked
                               call     l_print_crlf
;   66       for bytes_per_line / 2 loop
                               bcf      v__status, v__c,v__access
                               movlb    0
                               rrcf     v___bytes_per_line_1+1,w,v__banked
                               movwf    v__floop5+1,v__banked
                               rrcf     v___bytes_per_line_1,w,v__banked
                               movwf    v__floop5,v__banked
                               clrf     v__floop6,v__banked
                               clrf     v__floop6+1,v__banked
                               goto     l__l533
l__l532
;   67          device = " "
                               movlw    32
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_22,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_22+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_22+2,w,v__banked
                               call     l__pic_indirect
;   68          print_byte_hex(device,sd_sector_buffer_low[step1])
                               movlb    0
                               movf     v____device_put_22,w,v__banked
                               movwf    v____device_put_12,v__banked
                               movf     v____device_put_22+1,w,v__banked
                               movwf    v____device_put_12+1,v__banked
                               movf     v____device_put_22+2,w,v__banked
                               movwf    v____device_put_12+2,v__banked
                               lfsr     0,256
                               movf     v_step1,w,v__banked
                               addwf    v__fsr0l,f,v__access
                               movf     v__ind,w,v__access
                               call     l_print_byte_hex
;   69          device = " "
                               movlw    32
                               movlb    0
                               movwf    v__pic_temp,v__banked
                               movf     v____device_put_22,w,v__banked
                               movwf    v__pic_pointer,v__banked
                               movf     v____device_put_22+1,w,v__banked
                               movwf    v__pic_pointer+1,v__banked
                               movf     v____device_put_22+2,w,v__banked
                               call     l__pic_indirect
;   70          print_byte_hex(device,sd_sector_buffer_high[step1])
                               movlb    0
                               movf     v____device_put_22,w,v__banked
                               movwf    v____device_put_12,v__banked
                               movf     v____device_put_22+1,w,v__banked
                               movwf    v____device_put_12+1,v__banked
                               movf     v____device_put_22+2,w,v__banked
                               movwf    v____device_put_12+2,v__banked
                               lfsr     0,512
                               movf     v_step1,w,v__banked
                               addwf    v__fsr0l,f,v__access
                               movf     v__ind,w,v__access
                               call     l_print_byte_hex
;   71          step1 = step1 + 1
                               movlb    0
                               incf     v_step1,f,v__banked
                               btfsc    v__status, v__z,v__access
                               incf     v_step1+1,f,v__banked
;   72       end loop
                               incf     v__floop6,f,v__banked
                               btfsc    v__status, v__z,v__access
                               incf     v__floop6+1,f,v__banked
l__l533
                               movf     v__floop6,w,v__banked
                               subwf    v__floop5,w,v__banked
                               movwf    v__pic_temp,v__banked
                               movf     v__floop6+1,w,v__banked
                               subwf    v__floop5+1,w,v__banked
                               iorwf    v__pic_temp,w,v__banked
                               btfss    v__status, v__z,v__access
                               goto     l__l532
;   74    end loop
                               incf     v__floop4,f,v__banked
                               btfsc    v__status, v__z,v__access
                               incf     v__floop4+1,f,v__banked
l__l530
                               movf     v__floop4,w,v__banked
                               subwf    v__floop3,w,v__banked
                               movwf    v__pic_temp,v__banked
                               movf     v__floop4+1,w,v__banked
                               subwf    v__floop3+1,w,v__banked
                               iorwf    v__pic_temp,w,v__banked
                               btfss    v__status, v__z,v__access
                               goto     l__l529
;   75 end procedure
                               return   
l__l527
;   82 sd_sector_buffer_low[28] = 0xDD
                               movlw    221
                               movlb    1
                               movwf    v_sd_sector_buffer_low+28,v__banked
;   83 sd_sector_buffer_high[28] = 0xDD
                               movlw    221
                               movlb    2
                               movwf    v_sd_sector_buffer_high+28,v__banked
;   84 sd_sector_buffer_low[29] = 0xDD -- this one doesn't get stored
                               movlw    221
                               movlb    1
                               movwf    v_sd_sector_buffer_low+29,v__banked
;   85 sd_sector_buffer_high[29] = 0xDD
                               movlw    221
                               movlb    2
                               movwf    v_sd_sector_buffer_high+29,v__banked
;   86 sd_sector_buffer_low[30] = 0xDD
                               movlw    221
                               movlb    1
                               movwf    v_sd_sector_buffer_low+30,v__banked
;   87 sd_sector_buffer_high[30] = 0xDD
                               movlw    221
                               movlb    2
                               movwf    v_sd_sector_buffer_high+30,v__banked
;   90 fat32_print_sector_buffer_hex(serial_hw_data, 32)
                               movlw    l__serial_hw_data_put
                               movlb    0
                               movwf    v____device_put_22,v__banked
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_22+1,v__banked
                               movlw    UPPER l__serial_hw_data_put
                               movwf    v____device_put_22+2,v__banked
                               movlw    32
                               movwf    v___bytes_per_line_1,v__banked
                               clrf     v___bytes_per_line_1+1,v__banked
                               call     l_fat32_print_sector_buffer_hex
;   92 print_crlf(serial_hw_data)
                               movlw    l__serial_hw_data_put
                               movlb    0
                               movwf    v__device_put,v__banked
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v__device_put+1,v__banked
                               movlw    UPPER l__serial_hw_data_put
                               movwf    v__device_put+2,v__banked
                               call     l_print_crlf
;   93 print_crlf(serial_hw_data)
                               movlw    l__serial_hw_data_put
                               movlb    0
                               movwf    v__device_put,v__banked
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v__device_put+1,v__banked
                               movlw    UPPER l__serial_hw_data_put
                               movwf    v__device_put+2,v__banked
                               call     l_print_crlf
;   96 print_dword_hex(serial_hw_data,sd_sector_buffer_low[29])
                               movlw    l__serial_hw_data_put
                               movlb    0
                               movwf    v____device_put_9,v__banked
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_9+1,v__banked
                               movlw    UPPER l__serial_hw_data_put
                               movwf    v____device_put_9+2,v__banked
                               movlb    1
                               movf     v_sd_sector_buffer_low+29,w,v__banked
                               movlb    0
                               movwf    v___data_31,v__banked
                               clrf     v___data_31+1,v__banked
                               clrf     v___data_31+2,v__banked
                               clrf     v___data_31+3,v__banked
                               call     l_print_dword_hex
;   97 print_crlf(serial_hw_data)
                               movlw    l__serial_hw_data_put
                               movlb    0
                               movwf    v__device_put,v__banked
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v__device_put+1,v__banked
                               movlw    UPPER l__serial_hw_data_put
                               movwf    v__device_put+2,v__banked
                               call     l_print_crlf
;  101 var byte string1[] = "------------------------\r\n"
                               movlw    45
                               movlb    0
                               movwf    v_string1,v__banked
                               movlw    45
                               movwf    v_string1+1,v__banked
                               movlw    45
                               movwf    v_string1+2,v__banked
                               movlw    45
                               movwf    v_string1+3,v__banked
                               movlw    45
                               movwf    v_string1+4,v__banked
                               movlw    45
                               movwf    v_string1+5,v__banked
                               movlw    45
                               movwf    v_string1+6,v__banked
                               movlw    45
                               movwf    v_string1+7,v__banked
                               movlw    45
                               movwf    v_string1+8,v__banked
                               movlw    45
                               movwf    v_string1+9,v__banked
                               movlw    45
                               movwf    v_string1+10,v__banked
                               movlw    45
                               movwf    v_string1+11,v__banked
                               movlw    45
                               movwf    v_string1+12,v__banked
                               movlw    45
                               movwf    v_string1+13,v__banked
                               movlw    45
                               movwf    v_string1+14,v__banked
                               movlw    45
                               movwf    v_string1+15,v__banked
                               movlw    45
                               movwf    v_string1+16,v__banked
                               movlw    45
                               movwf    v_string1+17,v__banked
                               movlw    45
                               movwf    v_string1+18,v__banked
                               movlw    45
                               movwf    v_string1+19,v__banked
                               movlw    45
                               movwf    v_string1+20,v__banked
                               movlw    45
                               movwf    v_string1+21,v__banked
                               movlw    45
                               movwf    v_string1+22,v__banked
                               movlw    45
                               movwf    v_string1+23,v__banked
                               movlw    13
                               movwf    v_string1+24,v__banked
                               movlw    10
                               movwf    v_string1+25,v__banked
;  102 print_string(serial_hw_data, string1)
                               movlw    l__serial_hw_data_put
                               movwf    v____device_put_1,v__banked
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_1+1,v__banked
                               movlw    UPPER l__serial_hw_data_put
                               movwf    v____device_put_1+2,v__banked
                               movlw    26
                               movwf    v__str_count,v__banked
                               clrf     v__str_count+1,v__banked
                               movlw    111
                               movwf    v___str_1,v__banked
                               clrf     v___str_1+1,v__banked
                               clrf     v___str_1+2,v__banked
                               call     l_print_string
;  105 sd_sector_buffer_low[28] = 0xDD
                               movlw    221
                               movlb    1
                               movwf    v_sd_sector_buffer_low+28,v__banked
;  106 sd_sector_buffer_high[28] = 0xDD
                               movlw    221
                               movlb    2
                               movwf    v_sd_sector_buffer_high+28,v__banked
;  107 sd_sector_buffer_low[29] = 0xDD -- this one doesn't get stored
                               movlw    221
                               movlb    1
                               movwf    v_sd_sector_buffer_low+29,v__banked
;  108 sd_sector_buffer_high[29] = 0xDD
                               movlw    221
                               movlb    2
                               movwf    v_sd_sector_buffer_high+29,v__banked
;  109 sd_sector_buffer_low[30] = 0xDD
                               movlw    221
                               movlb    1
                               movwf    v_sd_sector_buffer_low+30,v__banked
;  110 sd_sector_buffer_high[30] = 0xDD
                               movlw    221
                               movlb    2
                               movwf    v_sd_sector_buffer_high+30,v__banked
;  113 print_dword_hex(serial_hw_data,sd_sector_buffer_low[29])
                               movlw    l__serial_hw_data_put
                               movlb    0
                               movwf    v____device_put_9,v__banked
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_9+1,v__banked
                               movlw    UPPER l__serial_hw_data_put
                               movwf    v____device_put_9+2,v__banked
                               movlb    1
                               movf     v_sd_sector_buffer_low+29,w,v__banked
                               movlb    0
                               movwf    v___data_31,v__banked
                               clrf     v___data_31+1,v__banked
                               clrf     v___data_31+2,v__banked
                               clrf     v___data_31+3,v__banked
                               call     l_print_dword_hex
;  115 print_crlf(serial_hw_data)
                               movlw    l__serial_hw_data_put
                               movlb    0
                               movwf    v__device_put,v__banked
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v__device_put+1,v__banked
                               movlw    UPPER l__serial_hw_data_put
                               movwf    v__device_put+2,v__banked
                               call     l_print_crlf
;  116 print_crlf(serial_hw_data)
                               movlw    l__serial_hw_data_put
                               movlb    0
                               movwf    v__device_put,v__banked
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v__device_put+1,v__banked
                               movlw    UPPER l__serial_hw_data_put
                               movwf    v__device_put+2,v__banked
                               call     l_print_crlf
;  119 fat32_print_sector_buffer_hex(serial_hw_data, 32)
                               movlw    l__serial_hw_data_put
                               movlb    0
                               movwf    v____device_put_22,v__banked
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v____device_put_22+1,v__banked
                               movlw    UPPER l__serial_hw_data_put
                               movwf    v____device_put_22+2,v__banked
                               movlw    32
                               movwf    v___bytes_per_line_1,v__banked
                               clrf     v___bytes_per_line_1+1,v__banked
                               call     l_fat32_print_sector_buffer_hex
;  120 print_crlf(serial_hw_data)
                               movlw    l__serial_hw_data_put
                               movlb    0
                               movwf    v__device_put,v__banked
                               movlw    HIGH l__serial_hw_data_put
                               movwf    v__device_put+1,v__banked
                               movlw    UPPER l__serial_hw_data_put
                               movwf    v__device_put+2,v__banked
                               call     l_print_crlf
l__l554
                               sleep    
                               goto     l__l554
                               end
