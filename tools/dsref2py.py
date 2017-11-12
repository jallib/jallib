import os
import pprint
# import simplejson
import json

# spec = simplejson.load(file("devicespecific.json"))
spec = json.load(file("devicespecific.json"))

pic_ds = {}
for picname,info in spec.items():
	pic_ds[picname] = info["DATASHEET"]

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
