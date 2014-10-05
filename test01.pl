#!/usr/bin/perl -w

#Complex expressions in for loops

$a = 10;
$b = 20;

foreach $i ($a/$b*2..$a/$b*2 + $b*$b*$b/$a - 1) {
    print $i, "\n";
}
