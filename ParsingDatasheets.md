**Say you want to parse datasheet for a new PIC, 18F87J93.**



  * Need to create/update python lib from Datasheets.wiki

```
cd tools
python dsref2py.py
```

  * use device files to create a new file only containing pins (starting with "R", eg. "RA0")

```
cat include/device/18f87j93.jal | grep var.volatile.bit.*pin_.*at | sed "s#.*pin_\([A-Z0-9]*\).*#R\1#" | sort -u > 18f87j93.jal.pins
```

  * download PDF (Datasheet.wiki page says it's 39948A.pdf, and convert it to text. If you don't have the datasheet, you'll get an error. In that case, remove the .pins file.

```
export ds=39948A
wget ww1.microchip.com/downloads/en/DeviceDoc/$ds.pdf
pdftotext $ds.pdf
```

  * run magical script. You may need to adjust some file/directory location

Note: before running this step, you may want to reprocude previous steps in order to parse/analyze several datasheets at a time

```
python parse_ds_pins.py 2>&1 [ tee out
```


  * cross your fingers it doesn't crash. Check "out" file for errors (like missing datasheets, for instance)

  * observe the generated  pinmap\_tmp.py. Are you happy ? Then merge it to master pinmap.py

```
cd tools
ipython
python> run pinmap
python> run pinmap_tmp
python> pinmap.update(pinmap_tmp)
python> import pprint
python> fout = file("pinmap.py","w")
python> fout.write("pinmap = \\\n")
python> print >> fout, pprint.pformat(pinmap)
python> fout.close()
python> exit
```


  * have a beer (or two)

  * (or three)

  * don't forget to generate other dependent files ! This script will also generate JSON format files.

```
cd tools
python extract_pininfos.py
make adclib
...
```


**ADC specific** : if the new added PIC has PCFG bits **and** if these PCFG bits declare combination (eg. PCFG = 3 means 6 analog pins on RA1, ... and 3 digital pins on RC4, ...), then `tools/adc/adc_pcfg.py` should be filled by hand as well...