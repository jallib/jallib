The last call of Fat16_OpenFile produces the wrong output to serial port.
Fat16_OpenFile(Test2)

Get:
A12345678 12345678 87654321 <765<765<!!!!!!!!!!

But should be:
A12345678 12345678 87654321 87654321 !!!!!!!!!!