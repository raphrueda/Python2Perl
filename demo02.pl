#!/usr/bin/perl -w

print "enter a number to get its factors", "\n";
$number = <STDIN>;
$currNum = 2;
print "1", "\n";

while ($currNum < $number) {
    if ($number % $currNum == 0) {
        print $currNum, "\n";
    }
    $currNum = $currNum + 1;
}
