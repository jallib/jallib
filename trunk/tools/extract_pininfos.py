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

