#!/bin/usr/python

#Calculate the nth fibonacci number iteratively
#Written by Raphael Rueda

import sys

print "enter a number"
num = int(sys.stdin.readline())

if num == 0: 
    print "1"
else:
    x = 0
    y = 1
    for i in range(1, num):
	z = x + y
	x = y
	y = z
    print x 
