#!/bin/bash

for num in `echo 1 2 3 4 5 6 7 8 9 10`
do
	python pwm_ccpx_generator.py pwm_ccpx.tmpl $num && mv pwm_ccp${num}.jal ../../include/peripheral/pwm/
done


