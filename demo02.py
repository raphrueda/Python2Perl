#!/bin/usr/python

#Print the factors of a given number
#Written by Raphael Rueda

import sys

print "enter a number to get its factors"
number = int(sys.stdin.readline())
currNum = 2
print "1"

while currNum < number:
    if number % currNum == 0:
	print currNum
    currNum = currNum + 1
