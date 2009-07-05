import os
import pprint

try:
	os.unlink("DataSheets.wiki")
except OSError:
	# none file yet
	pass
os.system("wget http://jallib.googlecode.com/svn/wiki/DataSheets.wiki")

data = file("DataSheets.wiki").readlines()
pic_ds = {}
for d in data:
	if not d.startswith("||"):
		continue
	if "Number" in d:
		# header
		continue
	s = map(lambda x: x.strip(),d.split("||"))
	pic = s[1]
	ds = s[2]
	pic_ds[pic] = ds

ds_pic = {}
for pic,ds in pic_ds.items():
	ds_pic.setdefault(ds,[]).append(pic)

fout = file("pic_ds_map.py","w")
fout.write("pic_ds = \\\n")
print >> fout, pprint.pformat(pic_ds)
print >> fout, "\n"
fout.write("ds_pic = \\\n")
print >> fout, pprint.pformat(ds_pic)
fout.close()
