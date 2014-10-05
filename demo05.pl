#!/usr/bin/perl -w

#Prints the prime number up to the given number
#Written by Raphael Rueda


print "enter a number", "\n";
$num = <STDIN>;
if ($num > 2) {
    print "2", "\n";
}

foreach $n (2..$num) {
    foreach $x (2..$n - 1) {
        if ($n % $x == 0) {
            last;
        }
        if ($x == $n-1) {
            print $n, "\n";
        }
    }
}

