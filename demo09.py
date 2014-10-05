#!/bin/usr/python

#Marking test
#Written by Raphael Rueda

import sys

print "Enter a mark for Raphael Rueda's tests"
mark = int(sys.stdin.readline())

if mark < 100:
    print "Are you serious? Waaaaaay too low."
else:
    print "Acceptable."
