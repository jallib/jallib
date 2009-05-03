import sys
import pprint

from pinmap import pinmap

# AN...
adc_pins = {}
for pic,pinfo in pinmap.items():
	for pin,func in pinfo.items():
		for f in func:
			if f.startswith("AN"):
				adc_pins.setdefault(pic,{})[pin] = f  

fout = file("adc_pins.py","w")
print >> fout, "adc_pins = \\"
print >> fout, pprint.pformat(adc_pins)
fout.close()


# ADC group according to AN*
from adc_pins import adc_pins
grp = {}
for k,v in adc_pins.items():
	# group by the way ADC pins appears in PIC
	l = tuple(sorted(v.items()))
	grp.setdefault(l,[]).append(k)

fout = file("adc_an_grp.py","w")
print >> fout, "adc_grp = \\"
print >> fout, pprint.pformat(grp)
fout.close()


# VREF
vref_pins = {}
for pic,pinfo in pinmap.items():
	for pin,func in pinfo.items():
		for f in func:
			if f.startswith("VREF"):
				vref_pins.setdefault(pic,{})[pin] = f

fout = file("vref_pins.py","w")
print >> fout, "vref_pins = \\"
print >> fout, pprint.pformat(vref_pins)
fout.close()

