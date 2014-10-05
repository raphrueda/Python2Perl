#!/usr/bin/perl -w

#Marking test
#Written by Raphael Rueda


print "Enter a mark for Raphael Rueda's tests", "\n";
$mark = <STDIN>;

if ($mark < 100) {
    print "Are you serious? Waaaaaay too low.", "\n";
} else {
    print "Acceptable.", "\n";
}
