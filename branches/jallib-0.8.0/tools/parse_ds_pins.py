import os, sys, re

PINS_DIR = "pins"
DS_DIR = "ds"


glue = {}
from pic_ds_map import pic_ds

try:
	pin_files = [os.path.basename(sys.argv[1])]
except IndexError:
	pin_files = [i for i in os.listdir(PINS_DIR) if i.endswith(".pins")]


def clean_pin_info(pinstr):
	pinfo = re.sub("_____.*","",pinstr)
	# some pins are glue together in txt DS
	zepin = pinfo.split("/")[0]
	splitter = re.sub("\d","",zepin,re.DOTALL)
	keep = re.split("%s\d+" % splitter,pinfo)[1]
	pinfo = zepin + keep
	return pinfo.split("/")

for f in pin_files:

	##if not f.startswith("18"):
	##	continue

	print "Dealing with %s" % f

	pic = re.sub("\.jal.pins","",f).upper()
	try:
		dsfile = pic_ds[pic]
	except KeyError:
		print "No datasheet for %s" % pic
		continue

	if dsfile == '-':
		# No DS available
		continue
	dsfiletxt = dsfile + ".txt"
	fin = file(os.path.join(DS_DIR,dsfiletxt)).read()
	fin = fin.replace("\n","_____")	# this will help searching with regex ("____" not supposed to exist)
	pins = file(os.path.join(PINS_DIR,f)).read().splitlines()

	glue[pic] = {}

	try:
		picgrp,picnum = re.match("(^\d\d[A-Z]{1,2})(\d+\w*\d+\w*)$",pic).groups()
	except AttributeError:
		print "Unable to parse PIC grp/num for %s" % pic
		continue

	for pin in pins:
		# some PICs have R[A,B,C,...]x pin, other (small) have GPx
		# only small PIC have GP* pins
		if picgrp.startswith("10F") or picgrp.startswith("12F"):
			pinnum = re.match("R[A-Z](\d+)",pin).groups()[0]
			patstr = "(PIC%s(\d*/)*%s).*?(GP%s/?([\w|\+|-]+|/)+)" % (picgrp,picnum,pinnum)
			res = re.findall(patstr,fin,re.MULTILINE)
		else:
			res = None
		# pin diagrams is on very first pages
		if not res:
			patstr = "(PIC%s(\d*/)*%s).*?(%s/?([\w|\+|-]+|/)*)" % (picgrp,picnum,pin)
			res = re.findall(patstr,fin,re.MULTILINE)
			if not res:
				print "For PIC %s ,could not find pin %s in DS %s using '%s', dead end..." % (pic,pin,dsfiletxt,patstr)
			else:
				glue[pic][pin] = clean_pin_info(res[0][2])
		else:
			glue[pic][pin] = clean_pin_info(res[0][2])

import pprint
fout = file("pinmap_tmp.py","w")
print >> fout, "pinmap_tmp = \\"
s = pprint.pformat(glue)
print >> fout, s
fout.close()

