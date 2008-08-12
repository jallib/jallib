; compiler: jal 2.4 (compiled Jul 30 2008)

; command line:  jalv2 -s /Users/eur/jalv2/jallib;/Users/eur/jalv2/jallib/unvalidated;/Users/eur/jalv2/jallib/unvalidated/includes;/Users/eur/jalv2/jallib/unvalidated/includes/core;/Users/eur/jalv2/jallib/unvalidated/includes/core/adc;/Users/eur/jalv2/jallib/unvalidated/includes/core/delay;/Users/eur/jalv2/jallib/unvalidated/includes/core/memory;/Users/eur/jalv2/jallib/unvalidated/includes/core/pwm;/Users/eur/jalv2/jallib/unvalidated/includes/devices;/Users/eur/jalv2/jallib/unvalidated/includes/devices/core_14;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/lcd;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor/dc;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor/servo;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor/stepper;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/ranger;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/ranger/ir;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/ranger/us;/Users/eur/jalv2/jallib/unvalidated/includes/protocols;/Users/eur/jalv2/jallib/unvalidated/includes/protocols/i2c;/Users/eur/jalv2/jallib/unvalidated/includes/protocols/serial;/Users/eur/jalv2/jallib/unvalidated/includes/protocols/spi;/Users/eur/jalv2/jallib/unvalidated/samples;/Users/eur/jalv2/jallib/unvalidated/samples/blink;/Users/eur/jalv2/jallib/unvalidated/samples/core;/Users/eur/jalv2/jallib/unvalidated/samples/serial;/Users/eur/jalv2/jallib/validated;/Users/eur/jalv2/jallib/validated/includes;/Users/eur/jalv2/jallib/validated/includes/core;/Users/eur/jalv2/jallib/validated/includes/core/adc;/Users/eur/jalv2/jallib/validated/includes/core/delay;/Users/eur/jalv2/jallib/validated/includes/core/memory;/Users/eur/jalv2/jallib/validated/includes/core/pwm;/Users/eur/jalv2/jallib/validated/includes/devices;/Users/eur/jalv2/jallib/validated/includes/interfaces;/Users/eur/jalv2/jallib/validated/includes/interfaces/lcd;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor/dc;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor/servo;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor/stepper;/Users/eur/jalv2/jallib/validated/includes/interfaces/ranger;/Users/eur/jalv2/jallib/validated/includes/interfaces/ranger/ir;/Users/eur/jalv2/jallib/validated/includes/interfaces/ranger/us;/Users/eur/jalv2/jallib/validated/includes/protocols;/Users/eur/jalv2/jallib/validated/includes/protocols/i2c;/Users/eur/jalv2/jallib/validated/includes/protocols/serial;/Users/eur/jalv2/jallib/validated/includes/protocols/spi;/Users/eur/jalv2/jallib/validated/samples; 20mhz_b18f4620.jal
                                list p=18f4620, r=dec
                                errorlevel -306 ; no page boundary warnings
                                errorlevel -302 ; no bank 0 warnings
                                errorlevel -202 ; no 'argument out of range' warnings

                             __config 0x00300000, 0xff
                             __config 0x00300001, 0xf2
                             __config 0x00300002, 0xff
                             __config 0x00300003, 0xfe
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
v_output                       EQU 0
v_lata                         EQU 0x0f89
v_trisa                        EQU 0x0f92
v_pin_a0_direction             EQU 0x0f92    ; trisa : 0
v_cmcon                        EQU 0x0fb4
v_adcon1                       EQU 0x0fc1
v_adcon0                       EQU 0x0fc2
v__banked                      EQU 1
v__access                      EQU 0
v_led                          EQU 0x0f89    ; lata : 0
v__pic_state                   EQU 0x0080
v__pic_temp                    EQU 0x0080    ; _pic_state
v____tmp_bit_35                EQU 0x1f12    ; lata + 3977 : 0
v____tmp_bit_36                EQU 0x1f12    ; lata + 3977 : 0
;    7 include 18f4620                     -- target PICmicro
                               org      0
l__main
;   15 var volatile bit LED is pin_a0 = off  -- LED is now alias
                               movlb    15
                               bcf      v_lata, 0,v__banked ; led, 0,v__banked
;   16 pin_a0_direction = output
                               bcf      v_trisa, 0,v__access ; pin_a0_direction, 0,v__access
;   18 enable_digital_io()          -- disable analog I/O
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/18f4620.jal
; 1149   ADCON0 = 0b0000_0000         -- disable ADC
                               clrf     v_adcon0,v__access
; 1150   ADCON1 = 0b0000_0111         -- digital I/O
                               movlw    7
                               movwf    v_adcon1,v__access
; 1151   CMCON  = 0b0000_0111         -- disable comparators
                               movlw    7
                               movwf    v_cmcon,v__access
; 20mhz_b18f4620.jal
;   18 enable_digital_io()          -- disable analog I/O
;   20 forever loop
l__l164
;   21   LED = on                   -- switch LED on
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/18f4620.jal
;  217   _Tmp_Bit = x
                               movlb    31
                               bsf      v_lata, 0,v__banked ; _tmp_bit35, 0,v__banked
; 20mhz_b18f4620.jal
;   21   LED = on                   -- switch LED on
;   22   _usec_delay(250000)        -- spin 1/4 sec.
                               movlb    0
                               movlw    44
                               movwf    v__pic_temp,v__access
l__l174
                               movlw    108
                               movwf    v__pic_temp+1,v__access
l__l175
                               movlw    86
                               movwf    v__pic_temp+2,v__access
l__l176
                               decfsz   v__pic_temp+2,f,v__access
                               goto     l__l176
                               decfsz   v__pic_temp+1,f,v__access
                               goto     l__l175
                               decfsz   v__pic_temp,f,v__access
                               goto     l__l174
                               nop      
;   23   LED = off                  -- switch LED off
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/18f4620.jal
;  217   _Tmp_Bit = x
                               movlb    31
                               bcf      v_lata, 0,v__banked ; _tmp_bit36, 0,v__banked
; 20mhz_b18f4620.jal
;   23   LED = off                  -- switch LED off
;   24   _usec_delay(250000)        -- spin 1/4 sec.
                               movlb    0
                               movlw    44
                               movwf    v__pic_temp,v__access
l__l177
                               movlw    108
                               movwf    v__pic_temp+1,v__access
l__l178
                               movlw    86
                               movwf    v__pic_temp+2,v__access
l__l179
                               decfsz   v__pic_temp+2,f,v__access
                               goto     l__l179
                               decfsz   v__pic_temp+1,f,v__access
                               goto     l__l178
                               decfsz   v__pic_temp,f,v__access
                               goto     l__l177
                               nop      
;   25 end loop
                               goto     l__l164
                               end
