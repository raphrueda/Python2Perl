#!/bin/usr/python

#Print a checker board of specified width and height
#Written by Raphael Rueda

import sys

print "enter width"
width = int(sys.stdin.readline())
print "enter height"
height = int(sys.stdin.readline())
pattern = 0

for i in range(0, height):
    if i % 2 == 0: 
	for j in range(0, width):
	    if j % 2 == pattern:
		sys.stdout.write("#")
	    else:
		sys.stdout.write(" ")
	if pattern == 0: 
	    pattern = 1
	else: 
	    pattern = 0
        print
