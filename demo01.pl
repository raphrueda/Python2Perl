#!/usr/bin/perl -w

print "enter width", "\n";
$width = <STDIN>;
print "enter height", "\n";
$height = <STDIN>;
$pattern = 0;

foreach $i (0..$height - 1) {
    if ($i % 2 == 0) {
        foreach $j (0..$width - 1) {
            if ($j % 2 == $pattern) {
                print "#";
            } else {
                print " ";
            }
        }
        if ($pattern == 0) {
            $pattern = 1;
        } else {
            $pattern = 0;
        }
        print "\n";
    }
}
