#!/usr/bin/perl -w

print "enter a number", "\n";
$num = <STDIN>;
foreach $i (0..$num) {
    foreach $j (0..$i - 1) {
        print $i, "\n";
    }
}
