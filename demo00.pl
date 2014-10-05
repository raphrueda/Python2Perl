#!/usr/bin/perl -w

print "enter a base", "\n";
$number = <STDIN>;
print "enter a power", "\n";
$power = <STDIN>;
$total = 1;

if ($power < 0) {
    print "positive number required", "\n";
} else {
    while ($power > 0) {
        $total = $total * $number;
        $power = $power - 1;
    }
    print $total, "\n";
}
