# Title: Script to generate the different PWM register-specific libs
# Author: Sebastien Lelong, Copyright (c) 2008, all rights reserved.
# Adapted-by:
# Compiler:
# 
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
# 
# Description: this script generates PWM register-specific libs
# (eg. pwm_ccp1.jal, pwm_ccp2.jal, ...). Currently only CCPxCON is handled, 
# not PWMxCON.
#              
#
# Notes:
#

import Cheetah.Template

if __name__ == "__main__":
	import sys
	try:
		tmpl_file = sys.argv[1]
		num = sys.argv[2]
	except IndexError:
		print >> sys.stderr, """
Usage:
	python %s <tmpl_file> <ccp_num>

Example to generate pwm_ccp1.jal:
	python %s pwm_ccpx.tmpl 1
""" % (sys.argv[0],sys.argv[0])
		sys.exit(255)
	
	tmplsrc = "".join(file(tmpl_file,"r").readlines())
	klass = Cheetah.Template.Template.compile(tmplsrc)
	tmpl = klass()
	tmpl.num = num
	
	fout = file("pwm_ccp%s.jal" % num,"w")
	fout.write(tmpl.main())
	#print tmpl.main()
	sys.exit(0)

