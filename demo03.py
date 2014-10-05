#!/bin/usr/python

#Prints the numbers i up to the given n, repeated i times each
#Written by Raphael Rueda

import sys

print "enter a number"
num = int(sys.stdin.readline())
for i in range(0, num+1):
    for j in range(0, i):
	print i
