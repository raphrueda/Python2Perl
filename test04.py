#!/bin/usr/python

#test a long line of commands in a single line control structure
#written by Raphael Rueda

import sys

x = int(sys.stdin.readline())
if (1): print x; x = 2*x; print x; x = 3*x; print x; x = 4*x; print x
