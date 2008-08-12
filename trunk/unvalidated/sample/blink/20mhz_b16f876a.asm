; compiler: jal 2.4 (compiled Jul 30 2008)

; command line:  jalv2 -s /Users/eur/jalv2/jallib;/Users/eur/jalv2/jallib/unvalidated;/Users/eur/jalv2/jallib/unvalidated/includes;/Users/eur/jalv2/jallib/unvalidated/includes/core;/Users/eur/jalv2/jallib/unvalidated/includes/core/adc;/Users/eur/jalv2/jallib/unvalidated/includes/core/delay;/Users/eur/jalv2/jallib/unvalidated/includes/core/memory;/Users/eur/jalv2/jallib/unvalidated/includes/core/pwm;/Users/eur/jalv2/jallib/unvalidated/includes/devices;/Users/eur/jalv2/jallib/unvalidated/includes/devices/core_14;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/lcd;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor/dc;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor/servo;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/motor/stepper;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/ranger;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/ranger/ir;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/ranger/us;/Users/eur/jalv2/jallib/unvalidated/includes/protocols;/Users/eur/jalv2/jallib/unvalidated/includes/protocols/i2c;/Users/eur/jalv2/jallib/unvalidated/includes/protocols/serial;/Users/eur/jalv2/jallib/unvalidated/includes/protocols/spi;/Users/eur/jalv2/jallib/unvalidated/samples;/Users/eur/jalv2/jallib/unvalidated/samples/blink;/Users/eur/jalv2/jallib/unvalidated/samples/core;/Users/eur/jalv2/jallib/unvalidated/samples/serial;/Users/eur/jalv2/jallib/validated;/Users/eur/jalv2/jallib/validated/includes;/Users/eur/jalv2/jallib/validated/includes/core;/Users/eur/jalv2/jallib/validated/includes/core/adc;/Users/eur/jalv2/jallib/validated/includes/core/delay;/Users/eur/jalv2/jallib/validated/includes/core/memory;/Users/eur/jalv2/jallib/validated/includes/core/pwm;/Users/eur/jalv2/jallib/validated/includes/devices;/Users/eur/jalv2/jallib/validated/includes/interfaces;/Users/eur/jalv2/jallib/validated/includes/interfaces/lcd;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor/dc;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor/servo;/Users/eur/jalv2/jallib/validated/includes/interfaces/motor/stepper;/Users/eur/jalv2/jallib/validated/includes/interfaces/ranger;/Users/eur/jalv2/jallib/validated/includes/interfaces/ranger/ir;/Users/eur/jalv2/jallib/validated/includes/interfaces/ranger/us;/Users/eur/jalv2/jallib/validated/includes/protocols;/Users/eur/jalv2/jallib/validated/includes/protocols/i2c;/Users/eur/jalv2/jallib/validated/includes/protocols/serial;/Users/eur/jalv2/jallib/validated/includes/protocols/spi;/Users/eur/jalv2/jallib/validated/samples; 20mhz_b16f876a.jal
                                list p=16f876a, r=dec
                                errorlevel -306 ; no page boundary warnings
                                errorlevel -302 ; no bank 0 warnings
                                errorlevel -202 ; no 'argument out of range' warnings

                             __config 0x3ffe
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
v_on                           EQU 1
v_off                          EQU 0
v_output                       EQU 0
v_porta                        EQU 0x0005
v__port_a_shadow               EQU 0x0023
v_adcon0                       EQU 0x001f
v_trisa                        EQU 0x0085
v_pin_a0_direction             EQU 0x0085    ; trisa : 0
v_cmcon                        EQU 0x009c
v_adcon1                       EQU 0x009f
v_led                          EQU 0x0005    ; porta : 0
v__pic_state                   EQU 0x0020
v__pic_temp                    EQU 0x0020    ; _pic_state
v____tmp_bit_22                EQU 0x0023    ; _port_a_shadow : 0
v____tmp_bit_23                EQU 0x0023    ; _port_a_shadow : 0
;    7 include 16f876a                     -- target PICmicro
                               org      0
l__main
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/16f876a.jal
;   85 var          byte  _port_A_shadow        = PORTA
                               movf     v_porta,w
                               movwf    v__port_a_shadow
; 20mhz_b16f876a.jal
;   12 var volatile bit LED is pin_a0 = off  -- LED is alias
                               bcf      v_porta, 0 ; led, 0
;   13 pin_a0_direction = output
                               datalo_set v_trisa ; pin_a0_direction
                               bcf      v_trisa, 0 ; pin_a0_direction, 0
;   15 enable_digital_io()          -- disable analog I/O
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/16f876a.jal
;  695   ADCON0 = 0b0000_0000         -- disable ADC
                               datalo_clr v_adcon0
                               clrf     v_adcon0
;  696   ADCON1 = 0b0000_0111         -- digital I/O
                               movlw    7
                               datalo_set v_adcon1
                               movwf    v_adcon1
;  697   CMCON  = 0b0000_0111         -- disable comparators
                               movlw    7
                               movwf    v_cmcon
; 20mhz_b16f876a.jal
;   15 enable_digital_io()          -- disable analog I/O
;   17 forever loop
l__l139
;   18   LED = on                   -- switch LED on
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/16f876a.jal
;  166   _Tmp_Bit = x
                               datalo_clr v__port_a_shadow ; _tmp_bit22
                               bsf      v__port_a_shadow, 0 ; _tmp_bit22, 0
; 20mhz_b16f876a.jal
;   18   LED = on                   -- switch LED on
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/16f876a.jal
;   89   PORTA = _port_A_shadow
                               movf     v__port_a_shadow,w
                               movwf    v_porta
; 20mhz_b16f876a.jal
;   18   LED = on                   -- switch LED on
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/16f876a.jal
;  167   _port_A_flush
; 20mhz_b16f876a.jal
;   18   LED = on                   -- switch LED on
;   19   _usec_delay(250000)        -- spin 1/4 sec.
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    167
                               movwf    v__pic_temp
l__l151
                               movlw    9
                               movwf    v__pic_temp+1
l__l152
                               movlw    165
                               movwf    v__pic_temp+2
l__l153
                               branchhi_clr l__l153
                               branchlo_clr l__l153
                               decfsz   v__pic_temp+2,f
                               goto     l__l153
                               branchhi_clr l__l152
                               branchlo_clr l__l152
                               decfsz   v__pic_temp+1,f
                               goto     l__l152
                               branchhi_clr l__l151
                               branchlo_clr l__l151
                               decfsz   v__pic_temp,f
                               goto     l__l151
                               nop      
                               nop      
;   20   LED = off                  -- switch LED off
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/16f876a.jal
;  166   _Tmp_Bit = x
                               bcf      v__port_a_shadow, 0 ; _tmp_bit23, 0
; 20mhz_b16f876a.jal
;   20   LED = off                  -- switch LED off
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/16f876a.jal
;   89   PORTA = _port_A_shadow
                               movf     v__port_a_shadow,w
                               movwf    v_porta
; 20mhz_b16f876a.jal
;   20   LED = off                  -- switch LED off
; /Users/eur/jalv2/jallib/unvalidated/includes/devices/16f876a.jal
;  167   _port_A_flush
; 20mhz_b16f876a.jal
;   20   LED = off                  -- switch LED off
;   21   _usec_delay(250000)        -- spin 1/4 sec.
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    167
                               movwf    v__pic_temp
l__l154
                               movlw    9
                               movwf    v__pic_temp+1
l__l155
                               movlw    165
                               movwf    v__pic_temp+2
l__l156
                               branchhi_clr l__l156
                               branchlo_clr l__l156
                               decfsz   v__pic_temp+2,f
                               goto     l__l156
                               branchhi_clr l__l155
                               branchlo_clr l__l155
                               decfsz   v__pic_temp+1,f
                               goto     l__l155
                               branchhi_clr l__l154
                               branchlo_clr l__l154
                               decfsz   v__pic_temp,f
                               goto     l__l154
                               nop      
                               nop      
;   22 end loop
                               goto     l__l139
                               end
