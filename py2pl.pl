#!/usr/bin/perl -w

@variables = ();
@converted = ();

$prevIndent = "";
$currIndent = "";

while($line = <>){
    if($line =~ /^(\s*)/){
	#keep track of the indentation of this line
	$currIndent = $1;
	chomp $currIndent;
	chomp $prevIndent;
    }
    if($line =~ // && $. == 1){
	#for the first line
	push @converted, "#!/usr/bin/perl -w\n";
    } elsif($line =~ /^\s*#/ || $line =~ /^\s*$/){
	#leave comments and empty lines unchanged
	push @converted, $line;
    } elsif($line =~ /^\s*print\s*(.*)\s*$/){
	#print statement
	$toPrint = changeVar($1);
	$newLine = $currIndent . "print $toPrint, \"\\n\";\n";
	push @converted, $newLine;
    } elsif($line =~ /^\s*([a-z][a-z0-9]*)\s*=\s*(.*)\s*/){
	#variable assignment
	#extract variable name
	$varName = $1;
	#extract variable value and look for variables inside
	$varVal = changeVar($2);
	#keep track of variable name
	push @variables, $varName;
	#construct the new line
	$newLine = $currIndent . "\$$varName = $varVal;\n";
	push @converted, $newLine;
    } elsif($line =~ /^\s*(if|while|elif)\s*(.*)\s*:/){
	#if statement and while loops
	#extract guard
	$condition = changeVar($2);
	$blockType = $1;
	if($blockType eq "elif"){
	    $newLine = $currIndent . "} elsif (" . $condition . "){\n";
	    push @converted, $newLine;
	} else {
	    $newLine = $currIndent . $blockType . " (" . $condition . ") {\n";
	    push @converted, $newLine;
	    if ($line =~ /:\s*.+\s*$/){
		print "yolo\n";
	        #one line if/while
	        $line =~ /^\s*[^ ]*\s*.*:\s*(.*)\s*$/;
	        #store the actions, separated by a ;
	        $body = $1;
	        @actions = split(/; /, $body);
	        foreach $action(@actions){
		    #push each one with the appropriate indent
		    #each action is untranslated, second pass will deal with these
        	    $newAction = "TODO" . $currIndent . "    " . $action . ";\n";
		    push @converted, $newAction;
                }
	        #push a block close
	        $closeBlock = $currIndent . "}\n";
	        push @converted, $closeBlock;
	    }
	}
    } elsif($line =~ /^\s*else/){
	$newLine = $currIndent . "} else {\n";
	push @converted, $newLine;
    } else {
	$commentedLine = "\#". $line;
	push @converted, $commentedLine;
    }
    $prevIndent = $currIndent;
}

print @converted;

sub changeVar {
    my ($line) = @_;
    foreach my $var (@variables){
	$line =~ s/\b($var)\b/\$$var/g;
    }
    return $line;

}
