#!/bin/bash

for num in `echo 1 2 3 4 5`
do
	python pwm_ccpx_generator.py pwm_ccpx.tmpl $num > ../../include/peripheral/pwm/pwm_ccp$num.jal
done


