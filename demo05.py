#!/bin/usr/python

#Prints the prime number up to the given number
#Written by Raphael Rueda

import sys

print "enter a number"
num = int(sys.stdin.readline())
if num > 2: print "2"

for n in range(1, num+1):
    for x in range(2, n):
	if n % x == 0:
	    break
	if x == n-1:
	    print n

