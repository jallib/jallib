Because this data is huge, it can't be displayed here in a wiki page. See CSV file:

http://code.google.com/p/jallib/source/browse/trunk/tools/pin_description.csv


(careful while following this link, this file has ~10000 lines...).

This file provides information about pin description. This is done parsing datasheets, and searching/analyzing PIC diagrams. For instance, you can have this kind of information:

```
RA1/AN1/C12IN0-/VREF+/INT1/PGC
```

RA1, AN1, C12IN0-, VREF+, INT1 and PGC are functionalities "attached" to this pins.

While parsing datasheets, my script failed to extract information for these PICs:

18F4553, 18F4553, 18F6628, 18F6723, 18F8628, 18F8723


Manual operation (but limited) may be required as needed to complete the CSV.