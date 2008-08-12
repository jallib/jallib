; compiler: jal 2.4 (compiled Jul 30 2008)

; command line:  jalv2 -s /Users/eur/jalv2/jallib;/Users/eur/jalv2/jallib/tools;/Users/eur/jalv2/jallib/unvalidated;/Users/eur/jalv2/jallib/unvalidated/includes;/Users/eur/jalv2/jallib/unvalidated/includes/core;/Users/eur/jalv2/jallib/unvalidated/includes/core/delay;/Users/eur/jalv2/jallib/unvalidated/includes/delay;/Users/eur/jalv2/jallib/unvalidated/includes/device;/Users/eur/jalv2/jallib/unvalidated/includes/devices;/Users/eur/jalv2/jallib/unvalidated/includes/devices/core_14;/Users/eur/jalv2/jallib/unvalidated/includes/external;/Users/eur/jalv2/jallib/unvalidated/includes/external/lcd;/Users/eur/jalv2/jallib/unvalidated/includes/external/motor;/Users/eur/jalv2/jallib/unvalidated/includes/external/motor/dc;/Users/eur/jalv2/jallib/unvalidated/includes/external/motor/servo;/Users/eur/jalv2/jallib/unvalidated/includes/external/motor/stepper;/Users/eur/jalv2/jallib/unvalidated/includes/external/ranger;/Users/eur/jalv2/jallib/unvalidated/includes/external/ranger/ir;/Users/eur/jalv2/jallib/unvalidated/includes/external/ranger/us;/Users/eur/jalv2/jallib/unvalidated/includes/external/temperature;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces;/Users/eur/jalv2/jallib/unvalidated/includes/interfaces/lcd;/Users/eur/jalv2/jallib/unvalidated/includes/jal;/Users/eur/jalv2/jallib/unvalidated/includes/peripheral;/Users/eur/jalv2/jallib/unvalidated/includes/peripheral/adc;/Users/eur/jalv2/jallib/unvalidated/includes/peripheral/comparator;/Users/eur/jalv2/jallib/unvalidated/includes/peripheral/data_eeprom;/Users/eur/jalv2/jallib/unvalidated/includes/peripheral/flash_memory;/Users/eur/jalv2/jallib/unvalidated/includes/peripheral/i2c;/Users/eur/jalv2/jallib/unvalidated/includes/peripheral/pwm;/Users/eur/jalv2/jallib/unvalidated/includes/peripheral/spi;/Users/eur/jalv2/jallib/unvalidated/includes/peripheral/timer;/Users/eur/jalv2/jallib/unvalidated/includes/peripheral/usart;/Users/eur/jalv2/jallib/unvalidated/includes/protocols;/Users/eur/jalv2/jallib/unvalidated/samples;/Users/eur/jalv2/jallib/unvalidated/samples/adc;/Users/eur/jalv2/jallib/unvalidated/samples/blink;/Users/eur/jalv2/jallib/unvalidated/samples/delay;/Users/eur/jalv2/jallib/unvalidated/samples/interfaces;/Users/eur/jalv2/jallib/unvalidated/samples/interfaces/lcd;/Users/eur/jalv2/jallib/unvalidated/samples/serial;/Users/eur/jalv2/jallib/validated;/Users/eur/jalv2/jallib/validated/includes;/Users/eur/jalv2/jallib/validated/includes/delay;/Users/eur/jalv2/jallib/validated/includes/device;/Users/eur/jalv2/jallib/validated/includes/external;/Users/eur/jalv2/jallib/validated/includes/external/lcd;/Users/eur/jalv2/jallib/validated/includes/external/motor;/Users/eur/jalv2/jallib/validated/includes/external/motor/dc;/Users/eur/jalv2/jallib/validated/includes/external/motor/servo;/Users/eur/jalv2/jallib/validated/includes/external/motor/stepper;/Users/eur/jalv2/jallib/validated/includes/external/ranger;/Users/eur/jalv2/jallib/validated/includes/external/ranger/ir;/Users/eur/jalv2/jallib/validated/includes/external/ranger/us;/Users/eur/jalv2/jallib/validated/includes/external/temperature;/Users/eur/jalv2/jallib/validated/includes/peripheral;/Users/eur/jalv2/jallib/validated/includes/peripheral/adc;/Users/eur/jalv2/jallib/validated/includes/peripheral/comparator;/Users/eur/jalv2/jallib/validated/includes/peripheral/data_eeprom;/Users/eur/jalv2/jallib/validated/includes/peripheral/flash_memory;/Users/eur/jalv2/jallib/validated/includes/peripheral/i2c;/Users/eur/jalv2/jallib/validated/includes/peripheral/pwm;/Users/eur/jalv2/jallib/validated/includes/peripheral/spi;/Users/eur/jalv2/jallib/validated/includes/peripheral/timer;/Users/eur/jalv2/jallib/validated/includes/peripheral/usart;/Users/eur/jalv2/jallib/validated/samples;/Users/eur/jalv2/jallib/validated/samples/blink;/Users/eur/jalv2/jallib/validated/samples/delay;/Users/eur/jalv2/jallib/validated/samples/serial; 20mhz_b16f877a.jal
                                list p=16f877a, r=dec
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
v__pic_state                   EQU 0x0020
v__pic_temp                    EQU 0x0020    ; _pic_state
v____tmp_bit_33                EQU 0x0023    ; _port_a_shadow : 0
v____tmp_bit_34                EQU 0x0023    ; _port_a_shadow : 0
v____tmp_bit_35                EQU 0x0023    ; _port_a_shadow : 0
;    7 include 16f877a                     -- target PICmicro
                               org      0
l__main
; /Users/eur/jalv2/jallib/unvalidated/includes/device/16f877a.jal
;   96 var          byte  _PORT_A_SHADOW        = PORTA
                               movf     v_porta,w
                               movwf    v__port_a_shadow
;  504 procedure _port_E_flush is
                               goto     l__l215
;  935 procedure enable_digital_io() is
l_enable_digital_io
;  937   ADCON0 = 0b0000_0000         -- disable ADC
                               datalo_clr v_adcon0
                               clrf     v_adcon0
;  938   ADCON1 = 0b0000_0111         -- digital I/O
                               movlw    7
                               datalo_set v_adcon1
                               movwf    v_adcon1
;  939   CMCON  = 0b0000_0111         -- disable comparators
                               movlw    7
                               movwf    v_cmcon
;  940 end procedure
                               return   
l__l215
; 20mhz_b16f877a.jal
;   16 LED = off
; /Users/eur/jalv2/jallib/unvalidated/includes/device/16f877a.jal
;  177   _Tmp_Bit = x
                               bcf      v__port_a_shadow, 0 ; _tmp_bit33, 0
; 20mhz_b16f877a.jal
;   16 LED = off
; /Users/eur/jalv2/jallib/unvalidated/includes/device/16f877a.jal
;  100   PORTA = _PORT_A_SHADOW
                               movf     v__port_a_shadow,w
                               movwf    v_porta
; 20mhz_b16f877a.jal
;   16 LED = off
; /Users/eur/jalv2/jallib/unvalidated/includes/device/16f877a.jal
;  178   _port_A_flush
; 20mhz_b16f877a.jal
;   16 LED = off
;   17 pin_a0_direction = output	-- pin_a0 is now output
                               datalo_set v_trisa ; pin_a0_direction
                               bcf      v_trisa, 0 ; pin_a0_direction, 0
;   19 enable_digital_io()          -- disable analog I/O
                               call     l_enable_digital_io
;   21 forever loop
l__l219
;   22   LED = on                   -- switch LED on
; /Users/eur/jalv2/jallib/unvalidated/includes/device/16f877a.jal
;  177   _Tmp_Bit = x
                               datalo_clr v__port_a_shadow ; _tmp_bit34
                               bsf      v__port_a_shadow, 0 ; _tmp_bit34, 0
; 20mhz_b16f877a.jal
;   22   LED = on                   -- switch LED on
; /Users/eur/jalv2/jallib/unvalidated/includes/device/16f877a.jal
;  100   PORTA = _PORT_A_SHADOW
                               movf     v__port_a_shadow,w
                               movwf    v_porta
; 20mhz_b16f877a.jal
;   22   LED = on                   -- switch LED on
; /Users/eur/jalv2/jallib/unvalidated/includes/device/16f877a.jal
;  178   _port_A_flush
; 20mhz_b16f877a.jal
;   22   LED = on                   -- switch LED on
;   23   _usec_delay(250000)        -- spin 1/4 sec.
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    167
                               movwf    v__pic_temp
l__l231
                               movlw    9
                               movwf    v__pic_temp+1
l__l232
                               movlw    165
                               movwf    v__pic_temp+2
l__l233
                               branchhi_clr l__l233
                               branchlo_clr l__l233
                               decfsz   v__pic_temp+2,f
                               goto     l__l233
                               branchhi_clr l__l232
                               branchlo_clr l__l232
                               decfsz   v__pic_temp+1,f
                               goto     l__l232
                               branchhi_clr l__l231
                               branchlo_clr l__l231
                               decfsz   v__pic_temp,f
                               goto     l__l231
                               nop      
                               nop      
;   24   LED = off                  -- switch LED off
; /Users/eur/jalv2/jallib/unvalidated/includes/device/16f877a.jal
;  177   _Tmp_Bit = x
                               bcf      v__port_a_shadow, 0 ; _tmp_bit35, 0
; 20mhz_b16f877a.jal
;   24   LED = off                  -- switch LED off
; /Users/eur/jalv2/jallib/unvalidated/includes/device/16f877a.jal
;  100   PORTA = _PORT_A_SHADOW
                               movf     v__port_a_shadow,w
                               movwf    v_porta
; 20mhz_b16f877a.jal
;   24   LED = off                  -- switch LED off
; /Users/eur/jalv2/jallib/unvalidated/includes/device/16f877a.jal
;  178   _port_A_flush
; 20mhz_b16f877a.jal
;   24   LED = off                  -- switch LED off
;   25   _usec_delay(250000)        -- spin 1/4 sec.
                               datalo_clr v__pic_temp
                               datahi_clr v__pic_temp
                               movlw    167
                               movwf    v__pic_temp
l__l234
                               movlw    9
                               movwf    v__pic_temp+1
l__l235
                               movlw    165
                               movwf    v__pic_temp+2
l__l236
                               branchhi_clr l__l236
                               branchlo_clr l__l236
                               decfsz   v__pic_temp+2,f
                               goto     l__l236
                               branchhi_clr l__l235
                               branchlo_clr l__l235
                               decfsz   v__pic_temp+1,f
                               goto     l__l235
                               branchhi_clr l__l234
                               branchlo_clr l__l234
                               decfsz   v__pic_temp,f
                               goto     l__l234
                               nop      
                               nop      
;   26 end loop
                               goto     l__l219
                               end
