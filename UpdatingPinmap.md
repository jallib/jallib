# What's pinmap ? #

**pinmap.py** is a file containing all pin definitions & aliases. As you know, given a PIC, each of its pins can have multiple functionality. For instance, one pin can be involved in ADC conversion, serial comms, i2c, etc... Depending on the functionality, its name can vary. The purpose of this file is to describe, for each PIC, for each pin, what are the aliases.

Format is a python dictionary. It's a very simple format, human-readable.


# Why ? What is it used for ? #

Creating and maintaining this file is highly time-consuming. You may ask "why are you doing this guys ? Can't you get this information from somewhere at Microchip ?". No it seems not. (but if you aware of something, please report...). At the beginning, this file was produced by parsing datasheets (see ParsingDatasheets), but this was a one-shot approach, highly fragile. By that times, gods were with us and it was working. Now they have seem to have left us, with a cursed burden: update maintenance...

This pinmap.py file is then used to produce many derivative files. All aliases are also available from device files, and may be involved libraries such as ADC for instance. These derivative files are also JSON versions of this python file, a format parsable in many language (note: python file remains the pristine source, mostly because you can add comments in it and because dict's keys can be lists, not just strings).


# "I don't know what to do during my days, I want to help and feed pinmap.py !" #

OK, welcome to hell... hum... here !

Say a new PIC just appeared, or you've just discovered there were some errors for a give PIC. For instance, PIC 16f722 has wrong alias definition. This can occur when parsing has failed to identified correct PICs in a datasheet.

Anyway, we're about lower energy of the Universe and slow down this increasing entropy by fixing things for this PIC.

Open pinmap.py file, with favorite editor. A PIC entry looks like:

```
{'10F200': {'RA0': ['GP0', 'ICSPDAT'],
            'RA1': ['GP1', 'ICSPCLK'],
            'RA2': ['GP2', 'T0CKI', 'FOSC4'],
            'RA3': ['GP3', 'MCLR', 'VPP']}
```

This is a python dictionary for those who know. It reads like: for PIC named "10F200", there's a first pin named "RA0" for which there are two aliases, "GP0" and "ICSPDAT". All this information is available by reading pin diagram for the given PIC.

Note "RA0" comes from the device file: there's no RA0 pin in datasheet, but all pins are normalized to this naming convention.

Now open 16F722 datasheet, read the pin diagram for it, and adjust things in pinmap.py. Once you're done, save it, and check things are formatted correctly. For this, you can just import your pinmap.py

```
python> import pinmap
python> 
```

Any error ? Make sure you did not forget any quotes, commas, etc... If no error occured, you're not done yet, now you have to make sure "adc\_pcfg.py" file is also up-to-date, located in "tools/adc". "Hey, I did not sign for this !", I can hear. Too late, you too are cursed, you need to get things done 'til the end ! If the PIC has PCFG bits, you may have to fill "adc\_pcfg.py". If not, just jump to the last action.

If you look at 16F877 datasheet and look for "PCFG", you'll find a big table where PCFG bits combinations are listed to configure ADC pins. This is what you have to transcribe here. In this file, things are listed by datasheet references, not by PIC. Find your reference by looking at PicGroups. you may just have nothing to do, but just make sure things are ok for your PIC.

Here an example of content, showing one combination:

```
 '30491C' : {
      '0000' : {
            'AN15/RH7' : 'A',
            'AN14/RH6' : 'A',
            'AN13/RH5' : 'A',
            'AN12/RH4' : 'A',
            'AN11/RF6' : 'A',
            'AN10/RF5' : 'A',
            'AN9/RF4' : 'A',
            'AN8/RF3' : 'A',
            'AN7/RF2' : 'A',
            'AN6/RF1' : 'A',
            'AN5/RF0' : 'A',
            'AN4/RA5' : 'A',
            'AN3/RA3' : 'A',
            'AN2/RA2' : 'A',
            'AN1/RA1' : 'A',
            'AN0/RA0' : 'A'
```

It reads: for datasheet reference 30491C, when PCGF bits equals 0b\_0000, then all pins (AN15/... to AN0/...) are analog (A). "D" means digital. Sometimes, pins are named just "RA0" instead of "AN0/RA0". This is because datasheets refer them using these two notations. But remember, in "AN0/RA0", the analog part ("AN0") is before "/".


Last action, generate all derivate files. For this, you'll use to get **simplejson** python library installed (see here: http://pypi.python.org/pypi/simplejson/)

```
python extract_pininfos.py
```

You're done, you're brave.