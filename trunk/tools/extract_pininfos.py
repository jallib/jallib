import sys
import pprint
#import simplejson as json
import json

from pinmap import pinmap

# first generate JSON format
# simplejson.dump(pinmap,file("pinmap.json","w"),indent=3,sort_keys=True)
json.dump(pinmap,file("pinmap.json","w"),indent=3,sort_keys=True)

# AN...
adc_pins = {}
for pic,pinfo in pinmap.items():
   for pin,func in pinfo.items():
      for f in func:
         if f.startswith("AN"):
            adc_pins.setdefault(pic,{})[pin] = f

fout = file("adc/adc_pins.py","w")
fout.write("adc_pins = \\\n")
print >> fout, pprint.pformat(adc_pins)
fout.close()


# VREF
vref_pins = {}
for pic,pinfo in pinmap.items():
   for pin,func in pinfo.items():
      for f in func:
         if f.startswith("VREF"):
            vref_pins.setdefault(pic,{})[pin] = f

fout = file("adc/vref_pins.py","w")
fout.write("vref_pins = \\\n")
print >> fout, pprint.pformat(vref_pins)
fout.close()

# ADC groups, pin<=>analog => PICs
adc_an_grp = {}
for pic,pins in adc_pins.items():
   adc_an_grp.setdefault(tuple(pins.items()),[]).append(pic)

fout = file("adc/adc_an_grp.py","w")
fout.write("adc_an_grp = \\\n")
print >> fout, pprint.pformat(adc_an_grp)
fout.close()

# build a pinmap dedicated to jallib (no duplicated, suffixes added when
# multiple pins have the same alias (ex. CCP1MUX)
for pic,picpin in pinmap.items():
   pinaliases = {}
   for pin,aliases in picpin.items():
      newpins = []
      for alias in aliases:
         if alias != pin:
            newpins.append(alias)
            pinaliases.setdefault(alias,[]).append(pin)
      picpin[pin] = newpins
   for alias,pins in pinaliases.items():
      if len(pins) > 1:
         for pin in pins:
            picpin[pin][picpin[pin].index(alias)] += "_%s" % pin
# simplejson.dump(pinmap,file("pinmap_pinsuffix.json","w"),indent=3,sort_keys=True)
json.dump(pinmap,file("pinmap_pinsuffix.json","w"),indent=3,sort_keys=True)

