#!/bin/usr/python

#Combination of logical and comparison operators
#Written by Raphael Rueda

import sys

a = int(sys.stdin.readline())
b = int(sys.stdin.readline())

if (a < b) and (b < 100):
    print "b is between a and 100"
elif (b < a) and (a < 100):
    print "a is between b and 100"
elif (b == a):
    print "equal"
else:
    print "a or b must be greater than 100"
