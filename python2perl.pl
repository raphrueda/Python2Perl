#!/usr/bin/perl -w

@variables = ();
while($line = <>){
    if($line =~ /^#!/ && $. == 1){
	#first line
	print "#!/usr/bin/perl -w\n";
    } elsif($line =~ /^\s*#/ || $line =~ /^\s*$/){
	#comments
	print $line if $line =~ /^\s*#/;
    } elsif($line =~ /^\s*print\s*(.*)\s*$/){
	#print
	$toPrint = $1;
	$toPrint =~ s/\"//;
	$newLine = "print \"$toPrint\\n\";\n";
	foreach $var (@variables){
	    $newLine =~ s/$var/\$$var/g;
	}
	$newLine =~ s/\"((\$[a-z][a-z0-9]* [\+\-\/\*\%(\*\*)] )+\$[a-z][a-z0-9]*)/$1, \"/;
	print $newLine;
    } elsif($line =~ /^\s*([^ ]*)\s*=\s*(.*)\s*/){
	#assign variables
	push (@variables, $1);
	$assignment = $2;
	foreach $var (@variables){
            $assignment =~ s/$var/\$$var/;
        }
	print "\$$1 = $assignment;\n";
    } else {
	print "#$line\n";
    }
}
