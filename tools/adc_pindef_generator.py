# Title: Script to generate ADC pins/group definition
# Author: Sebastien Lelong, Copyright (c) 2009, all rights reserved.
# Adapted-by:
# Compiler:
# 
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
# 
# Description: This script uses python dict to generate a jal library.
# This jal library is arbitrary classification of PICs according to their
# ADC pins, and also provide a mapping between declared pins in device
# files and ADC pins (eg. pin_A2 is an ADC pins named AN0)
#              
#
# Notes: this script expect some python libs to be in the same directory
#

import Cheetah.Template

if __name__ == "__main__":
	import sys
	# Prepare template
	tmpl_file = "adc_pindef.jal.tmpl"
	tmplsrc = "".join(file(tmpl_file,"r").readlines())
	klass = Cheetah.Template.Template.compile(tmplsrc)
	tmpl = klass()
	# ADC pins grouped + whole pin map
	from adc_an_grp import adc_an_grp
	from pinmap import pinmap
	tmpl.adc_an_grp = adc_an_grp
	tmpl.pinmap = pinmap
	
	fout = file("adc_pindef.jal","w")
	print >> fout,tmpl.main()
	fout.close()
	sys.exit(0)

