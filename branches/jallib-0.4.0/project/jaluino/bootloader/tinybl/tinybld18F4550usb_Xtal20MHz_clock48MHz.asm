	radix DEC
	LIST      P=18F4550	; change also: Configure->SelectDevice from Mplab
; 20MHzQuartz / 5 * 24 / 2 => 48MHz	; check _CONFIG1
xtal EQU 48000000		; 'xtal' here is resulted frequency (is no longer quartz frequency)
baud EQU 115200			; the desired baud rate
	
	;********************************************************************
	;	Tiny Bootloader		18F*55 series		Size=100words
	;	claudiu.chiculita@ugal.ro
	;	http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;********************************************************************
	;	     |	12kW	16kW
	;	-----+----------------
	;	28pin|	2455	2550
	;	40pin|	4455	4550
	#include "../icdpictypes.inc"	;takes care of: #include "p18fxxx.inc",  max_flash, IdTypePIC
	#include "../spbrgselect.inc"	; RoundResult and baud_rate

		#define first_address max_flash-200		;100 words
	__CONFIG _CONFIG1L, _PLLDIV_5_1L & _CPUDIV_OSC1_PLL2_1L & _USBDIV_2_1L
	__CONFIG _CONFIG1H, _FOSC_HSPLL_HS_1H & _FCMEN_OFF_1H & _IESO_OFF_1H 
	__CONFIG _CONFIG2L, _PWRT_ON_2L & _BOR_OFF_2L ; _VREGEN_OFF_2L
	__CONFIG _CONFIG2H, _WDT_OFF_2H & _WDTPS_1_2H 
	__CONFIG _CONFIG3H, _MCLRE_ON_3H & _PBADEN_OFF_3H & _CCP2MX_OFF_3H
	__CONFIG _CONFIG4L, _DEBUG_OFF_4L & _LVP_OFF_4L & _STVREN_OFF_4L & _XINST_OFF_4L
	__CONFIG _CONFIG5L, _CP0_OFF_5L & _CP1_OFF_5L & _CP2_OFF_5L
	__CONFIG _CONFIG5H, _CPB_OFF_5H & _CPD_OFF_5H
	__CONFIG _CONFIG6L, _WRT0_OFF_6L & _WRT1_OFF_6L & _WRT2_OFF_6L & _WRT3_OFF_6L
	__CONFIG _CONFIG6H, _WRTB_OFF_6H & _WRTC_OFF_6H & _WRTD_OFF_6H
	__CONFIG _CONFIG7L, _EBTR0_OFF_7L & _EBTR1_OFF_7L & _EBTR2_OFF_7L & _EBTR3_OFF_7L
	__CONFIG _CONFIG7H, _EBTRB_OFF_7H


;----------------------------- PROGRAM ---------------------------------
	cblock 0
	crc
	i
	cnt1
	cnt2
	cnt3
	counter_hi
	counter_lo
	flag
	endc
	cblock 10
	buffer:64
	endc
	
SendL macro car
	movlw car
	movwf TXREG
	endm
	
;0000000000000000000000000 RESET 00000000000000000000000000

		ORG     0x0000
		GOTO    IntrareBootloader

;view with TabSize=4
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;PC_flash:		C1h				U		H		L		x  ...  <64 bytes>   ...  crc	
;PC_eeprom:		C1h			   	40h   EEADR   EEDATA	0		crc					
;PC_cfg			C1h			U OR 80h	H		L		1		byte	crc
;PIC_response:	   type `K`
	
	ORG first_address			;space to deposit first 4 instr. of user prog.
	nop
	nop
	nop
	nop
	org first_address+8
IntrareBootloader
	;skip TRIS to 0 C6			;init serial port
	movlw b'00100100'
	movwf TXSTA
	;use only SPBRG (8 bit mode default) not using BAUDCON
	movlw spbrg_value
	movwf SPBRG
	movlw b'10010000'
	movwf RCSTA
						;wait for computer
	rcall Receive			
	sublw 0xC1				;Expect C1h
	bnz way_to_exit
	SendL IdTypePIC				;send PIC type
MainLoop
	SendL 'K'				; "-Everything OK, ready and waiting."
mainl
	clrf crc
	rcall Receive			;Upper
	movwf TBLPTRU
		movwf flag			;(for EEPROM and CFG cases)
	rcall Receive			;Hi
	movwf TBLPTRH
		movwf EEADR			;(for EEPROM case)
	rcall Receive			;Lo
	movwf TBLPTRL
		movwf EEDATA		;(for EEPROM case)

	rcall Receive			;count
	movwf i
	incf i
	lfsr FSR0, (buffer-1)
rcvoct						;read 64+1 bytes
		movwf TABLAT		;prepare for cfg; => store byte before crc
	rcall Receive
	movwf PREINC0
	decfsz i
	bra rcvoct
	
	tstfsz crc				;check crc
	bra ziieroare
		btfss flag,6		;is EEPROM data?
		bra noeeprom
		movlw b'00000100'	;Setup eeprom
		rcall Write
		bra waitwre
noeeprom
		btfss flag,7		;is CFG data?
		bra noconfig
		tblwt*				;write TABLAT(byte before crc) to TBLPTR***
		movlw b'11000100'	;Setup cfg
		rcall Write
		bra waitwre
noconfig
							;write
eraseloop
	movlw	b'10010100'		; Setup erase
	rcall Write
	TBLRD*-					; point to adr-1
	
writebigloop	
	movlw 2					; 2groups
	movwf counter_hi
	lfsr FSR0,buffer
writesloop
	movlw 32				; 32bytes = 4instr
	movwf counter_lo
writebyte
	movf POSTINC0,w			; put 1 byte
	movwf TABLAT
	tblwt+*
	decfsz counter_lo
	bra writebyte
	
	movlw	b'10000100'		; Setup writes
	rcall Write
	decfsz counter_hi
	bra writesloop
waitwre	
	;btfsc EECON1,WR		;for eeprom writes (wait to finish write)
	;bra waitwre			;no need: round trip time with PC bigger than 4ms
	
	bcf EECON1,WREN			;disable writes
	bra MainLoop
	
ziieroare					;CRC failed
	SendL 'N'
	bra mainl
	  
;******** procedures ******************

Write
	movwf EECON1
	movlw 0x55
	movwf EECON2
	movlw 0xAA
	movwf EECON2
	bsf EECON1,WR			;WRITE
	nop
	;nop
	return


Receive
	movlw xtal/2000000+1	; for 20MHz => 11 => 1second delay
	movwf cnt1
rpt2						
	clrf cnt2
rpt3
	clrf cnt3
rptc
		btfss PIR1,RCIF			;test RX
		bra notrcv
	    movf RCREG,w			;return read data in W
	    addwf crc,f				;compute crc
		return
notrcv
	decfsz cnt3
	bra rptc
	decfsz cnt2
	bra rpt3
	decfsz cnt1
	bra rpt2
	;timeout:
way_to_exit
	bcf	RCSTA,	SPEN			; deactivate UART
	bra first_address
;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

            END
