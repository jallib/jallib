# Title: Script to generate ADC channels (channel number, ADC pin configuration)
# Author: Sebastien Lelong, Copyright (c) 2009, all rights reserved.
# Adapted-by:
# Compiler:
# 
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
# 
# Description: This script uses several python dicts to generate a jal library.
# See generated lib for more about ADC channels
#              
#
# Notes: this script expect some python libs to be in the same directory
#

import Cheetah.Template

if __name__ == "__main__":
    import sys
    # Prepare template
    tmpl_file = "adc_channels.jal.tmpl"
    tmplsrc = "".join(file(tmpl_file,"r").readlines())
    klass = Cheetah.Template.Template.compile(tmplsrc)
    tmpl = klass()
    # ADC pins grouped + whole pin map
    from pinmap import pinmap
    from adc_pcfg import adc_pcfg
    from adc_pins import adc_pins
    from pic_ds_map import pic_ds, ds_pic

    # extract PICs where PCFG is used to configure dependent ADC channels
    dependent_pcfg_dsref = adc_pcfg.keys()
    pcfg_combination_pics = []
    for r in dependent_pcfg_dsref:
        pcfg_combination_pics.extend(ds_pic[r])

    tmpl.pinmap = pinmap
    tmpl.pcfg_combination_pics = pcfg_combination_pics 
    tmpl.adc_pcfg = adc_pcfg
    tmpl.pic_ds = pic_ds
    tmpl.ds_pic = ds_pic
    tmpl.adc_pins = adc_pins
    
    fout = file("adc_channels.jal","w")
    print >> fout,tmpl.main()
    fout.close()
    sys.exit(0)

