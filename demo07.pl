#!/usr/bin/perl -w



print "enter a number", "\n";
$num = <STDIN>;

if ($num == 0) {
    print "1", "\n";
} else {
    $x = 0;
    $y = 1;
    foreach $i (1..$num - 1) {
        $z = $x + $y;
        $x = $y;
        $y = $z;
    }
    print $x , "\n";
}
