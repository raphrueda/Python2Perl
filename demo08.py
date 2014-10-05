#!/bin/usr/python

# editted version of examples/3/triangle.py to print an upsidedown triangle
# editted by Raphael Rueda

import sys

print "How tall do you want your pattern?"
heightInitial = int(sys.stdin.readline())
height = heightInitial

while height > 0:
    j = 1
    while j <= height:
	sys.stdout.write("#")
	j = j + 1
    print
    height = height - 1
