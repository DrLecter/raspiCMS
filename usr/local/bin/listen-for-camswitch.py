#!/usr/bin/env python

import RPi.GPIO as GPIO
import subprocess

GPIO.setmode(GPIO.BCM)
GPIO.setup(3, GPIO.IN)
while True:
    GPIO.wait_for_edge(3, GPIO.FALLING)
    subprocess.call(['cam.sh', 'cycle'], shell=False)
