#!/bin/usr/python

#Calculate bases raised to a positive power
#Written by Raphael Rueda

import sys

print "enter a base"
number = int(sys.stdin.readline())
print "enter a power"
power = int(sys.stdin.readline())
total = 1

if power < 0:
    print "positive power required"
else:
    while power > 0:
	total = total * number
	power = power - 1
    print total
