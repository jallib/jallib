; compiler: jal 2.4 (compiled Jul 30 2008)

; command line:  jalv2 -s /Users/eur/jalv2/jallib;/Users/eur/jalv2/jallib/unvalidated;/Users/eur/jalv2/jallib/unvalidated/includes;/Users/eur/jalv2/jallib/unvalidated/includes/core;/Users/eur/jalv2/jallib/unvalidated/includes/core/adc;/Users/eur/jalv2/jallib/unvalidated/includes/core/delay;/Users/eur/jalv2/jallib/unvalidated/includes/core/memory;/Users/eur/jalv2/jallib/unvalidated/includes/core/pwm;/Users/eur/jalv2/jallib/unvalidated/includes/devices;/Users/eur/jalv2/jallib/unvalidated/includes/devices/core_14;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/lcd;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor/dc;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor/servo;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor/stepper;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/ranger;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/ranger/ir;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/ranger/us;/Users/eur/jalv2/jallib/unvalidated/includes/protocols;/Users/eur/jalv2/jallib/unvalidated/includes/protocols/i2c;/Users/eur/jalv2/jallib/unvalidated/includes/protocols/serial;/Users/eur/jalv2/jallib/unvalidated/includes/protocols/spi;/Users/eur/jalv2/jallib/unvalidated/samples;/Users/eur/jalv2/jallib/unvalidated/samples/blink;/Users/eur/jalv2/jallib/unvalidated/samples/core;/Users/eur/jalv2/jallib/unvalidated/samples/serial;/Users/eur/jalv2/jallib/validated;/Users/eur/jalv2/jallib/validated/includes;/Users/eur/jalv2/jallib/validated/includes/core;/Users/eur/jalv2/jallib/validated/includes/core/adc;/Users/eur/jalv2/jallib/validated/includes/core/delay;/Users/eur/jalv2/jallib/validated/includes/core/memory;/Users/eur/jalv2/jallib/validated/includes/core/pwm;/Users/eur/jalv2/jallib/validated/includes/devices;/Users/eur/jalv2/jallib/validated/includes/interfaces;/Users/eur/jalv2/jallib/validated/includes/interfaces/lcd;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor/dc;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor/servo;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor/stepper;/Users/eur/jalv2/jallib/validated/includes/interfaces/ranger;/Users/eur/jalv2/jallib/validated/includes/interfaces/ranger/ir;/Users/eur/jalv2/jallib/validated/includes/interfaces/ranger/us;/Users/eur/jalv2/jallib/validated/includes/protocols;/Users/eur/jalv2/jallib/validated/includes/protocols/i2c;/Users/eur/jalv2/jallib/validated/includes/protocols/serial;/Users/eur/jalv2/jallib/validated/includes/protocols/spi;/Users/eur/jalv2/jallib/validated/samples; b18f4620.jal
                                list p=18f4620, r=dec
                                errorlevel -306 ; no page boundary warnings
                                errorlevel -302 ; no bank 0 warnings
                                errorlevel -202 ; no 'argument out of range' warnings

                             __config 0x00300000, 0xff
                             __config 0x00300001, 0xff
                             __config 0x00300002, 0xff
                             __config 0x00300003, 0xff
                             __config 0x00300004, 0xff
                             __config 0x00300005, 0xff
                             __config 0x00300006, 0xff
                             __config 0x00300007, 0xff
                             __config 0x00300008, 0xff
                             __config 0x00300009, 0xff
                             __config 0x0030000a, 0xff
                             __config 0x0030000b, 0xff
                             __config 0x0030000c, 0xff
                             __config 0x0030000d, 0xff
v_on                           EQU 1
v_off                          EQU 0
v_lata                         EQU 0x0f89
v_cmcon                        EQU 0x0fb4
v_adcon1                       EQU 0x0fc1
v_adcon0                       EQU 0x0fc2
v__banked                      EQU 1
v__access                      EQU 0
v__pic_state                   EQU 0x0080
v__pic_temp                    EQU 0x0080    ; _pic_state
v____tmp_bit_35                EQU 0x1f12    ; lata + 3977 : 0
v____tmp_bit_36                EQU 0x1f12    ; lata + 3977 : 0
v____tmp_bit_37                EQU 0x1f12    ; lata + 3977 : 0
;    7 include 18f4620                     -- target PICmicro
                               org      0
l__main
;   13 pin_A0 = off            -- set pin low
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/18f4620.jal
;  217   _Tmp_Bit = x
                               movlb    31
                               bcf      v_lata, 0,v__banked ; _tmp_bit35, 0,v__banked
; b18f4620.jal
;   13 pin_A0 = off            -- set pin low
;   15 enable_digital_io()          -- disable analog I/O
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/18f4620.jal
; 1149   ADCON0 = 0b0000_0000         -- disable ADC
                               clrf     v_adcon0,v__access
; 1150   ADCON1 = 0b0000_0111         -- digital I/O
                               movlw    7
                               movwf    v_adcon1,v__access
; 1151   CMCON  = 0b0000_0111         -- disable comparators
                               movlw    7
                               movwf    v_cmcon,v__access
; b18f4620.jal
;   15 enable_digital_io()          -- disable analog I/O
;   17 forever loop
l__l165
;   18   LED = on                   -- switch LED on
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/18f4620.jal
;  217   _Tmp_Bit = x
                               movlb    31
                               bsf      v_lata, 0,v__banked ; _tmp_bit36, 0,v__banked
; b18f4620.jal
;   18   LED = on                   -- switch LED on
;   19   _usec_delay(250000)        -- spin 1/4 sec.
                               movlb    0
                               movlw    12
                               movwf    v__pic_temp,v__access
l__l175
                               movlw    127
                               movwf    v__pic_temp+1,v__access
l__l176
                               movlw    53
                               movwf    v__pic_temp+2,v__access
l__l177
                               decfsz   v__pic_temp+2,f,v__access
                               goto     l__l177
                               decfsz   v__pic_temp+1,f,v__access
                               goto     l__l176
                               decfsz   v__pic_temp,f,v__access
                               goto     l__l175
                               nop      
;   20   LED = off                  -- switch LED off
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/18f4620.jal
;  217   _Tmp_Bit = x
                               movlb    31
                               bcf      v_lata, 0,v__banked ; _tmp_bit37, 0,v__banked
; b18f4620.jal
;   20   LED = off                  -- switch LED off
;   21   _usec_delay(250000)        -- spin 1/4 sec.
                               movlb    0
                               movlw    12
                               movwf    v__pic_temp,v__access
l__l178
                               movlw    127
                               movwf    v__pic_temp+1,v__access
l__l179
                               movlw    53
                               movwf    v__pic_temp+2,v__access
l__l180
                               decfsz   v__pic_temp+2,f,v__access
                               goto     l__l180
                               decfsz   v__pic_temp+1,f,v__access
                               goto     l__l179
                               decfsz   v__pic_temp,f,v__access
                               goto     l__l178
                               nop      
;   22 end loop
                               goto     l__l165
                               end
