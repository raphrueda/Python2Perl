#!/bin/usr/python

#Distinguishes odd and even numbers, using the continue statement
#Written by Raphael Rueda

import sys

num = int(sys.stdin.readline())
for n in range(1, num):
    print n
    if n % 2 == 0:
	print " is even"
	continue
    print " is odd"
