Catpad library

these are work in progress and suffix mw to avoid accident overwrites with existing till
the release!

Glcd1.sch	
bcd_utils.jal  -- Maybe combine with strings or math. BCD <-> String conversion
catpatv1.jal   -- Main Program
cmds_ft817.jal	-- All the CAT routines and RIG routines and RTC
eeprom_24lc256mw.jal -- added byte[2] r/w. Will add page R/W for larger array
fmRadio1.sch      -- eagle file : PIC controlled $1 radio (option in PCB catPad)
glcd_ks0108mw.jal -- 128 x 64 K0108 / K0107 panel.
graphics_mw.jal	  -- everything to do with screen above device specific
isr_250_tmr0.jal  -- earlier 250us RTC attempt. Moved into cmds_ft817 	
keypad5_2mw.jal	  -- D0 ..D7 and B2..B7 Matrix Keypad. Will have rotary Encoder
main.sch	-- eagle file.: Main PCB of the CatPad
math_mw.jal	 -- Integer, fixed point integer, BCD, CRCs, PRNGs  and such
rds_rx.jal	 -- 57kHz subcarrier data on FM Radio. Decoder RDS (Eu and USA)
readme.txt	 -- you're reading it
serial_hardwaremw.jal  -- added twostopbits and broke it
