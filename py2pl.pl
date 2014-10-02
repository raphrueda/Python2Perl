#!/usr/bin/perl -w

%variables = ();
@converted = ();

$prevIndent = "";
$currIndent = "";

while($line = <>){
    if($line =~ /^(\s*)/){
	#keep track of the indentation of this line
	$currIndent = $1;
	chomp $currIndent;
    }
    if(length($currIndent) < length($prevIndent) && $line !~ /^\s*(else|elif)/){
	$currLen = length($currIndent) / 4;
	$prevLen = length($prevIndent) / 4;
	@closingBraces = ();
	while ($currLen < $prevLen){
	    $indent = "";
	    for (1..$currLen){
		$indent .= "    ";
	    }
	    $blockClose = $indent . "}\n";
	    push @closingBraces, $blockClose;
	    $currLen ++;
	}
	push @converted, reverse(@closingBraces);
    }
    if($line =~ // && $. == 1){
	#for the first line
	push @converted, "#!/usr/bin/perl -w\n";
    } elsif($line =~ /^\s*#/ || $line =~ /^\s*$/){
	#leave comments and empty lines unchanged
	push @converted, $line;
    } elsif($line =~ /^\s*print\s*(.*)\s*$/){
	#print statement
	$toPrint = $1;
	if($toPrint ne ""){
    	    if($toPrint =~ /^[^\"].*[^\"]$/){$toPrint = changeVar($toPrint);}
	    $newLine = $currIndent . "print $toPrint, \"\\n\";\n";
	} else {
	    $newLine = $currIndent . "print \"\\n\";\n";
	}
	push @converted, $newLine;
    } elsif($line =~ /^\s*([a-z][a-z0-9]*)\s*=\s*(.*)\s*/){
	#variable assignment
	#extract variable name
	$varName = $1;
	#extract variable value and look for variables inside
	$varVal = changeVar($2);
	#keep track of variable name
	$variables{$varName} = $varVal;
	#construct the new line
	$newLine = $currIndent . "\$$varName = $varVal;\n";
	push @converted, $newLine;
    } elsif($line =~ /^\s*(if|while|elif)\s*(.*)\s*:/){
	#conditional structures
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
	        #one line if/while
	        $line =~ /^\s*[^ ]*\s*.*:\s*(.*)\s*$/;
	        #store the actions, separated by a ;
	        $body = $1;
	        @actions = split(/; /, $body);
	        foreach $action(@actions){
		    #push each one with the appropriate indent
		    #each action is untranslated, second pass will deal with these
        	    $newAction = "TODO" . $currIndent . "    " . $action . "\n";
		    push @converted, $newAction;
                }
	        #push a block closer
	        $closeBlock = $currIndent . "}\n";
	        push @converted, $closeBlock;
	    }
	}
    } elsif($line =~ /^\s*else/){
	$newLine = $currIndent . "} else {\n";
	push @converted, $newLine;
    } elsif($line =~ /^\s*for\s*([a-z][a-z0-9]*)\s*in range\((.*)\)/){
	#for/range handler
	$iterator = $1;
	$variables{$iterator} = 1;
	push @variables, $iterator;
	$range = $2;
	if($range =~ /^([a-z0-9\+\-\/\*\% ]*), ([a-z0-9\+\-\/\*\% ]*)/){
	    $rangeLow = $1;
	    $rangeHigh = $2;
	} elsif($range =~ /^([a-z0-9\+\-\/\*\% ]*)$/){
	    $rangeLow = 0;
	    $rangeHigh = $1;
	}
	if($rangeHigh =~ /([\+\-])\s*([0-9]*)\s*$/){
	    $numericDisplacement = $2 - 1 if $1 eq "+";
	    $numericDisplacement = $2 + 1 if $1 eq "-";
	    $rangeHigh =~ s/$2/$numericDisplacement/;
	} else {
	    $rangeHigh --;
	}
	if($rangeHigh =~ /^(.*)\s*[\+\-]\s*0/){
	    $rangeHigh = $1;
	    $rangeHigh =~ s/\s*$//;
	}
	$rangeLow = changeVar($rangeLow);
	$rangeHigh = changeVar($rangeHigh);	
	$newLine = $currIndent . "foreach \$$iterator ($rangeLow..$rangeHigh) {\n";
	push @converted, $newLine;
    } elsif($line =~ /^\s*sys\.stdout\.write\((.*)\)/){
	$newLine = $currIndent . "print $1;\n";
	push @converted, $newLine;
    } elsif($line =~ /^\s*(break|continue)/){
	$newLine = $currIndent . "last;\n" if $1 eq "break";
	$newLine = $currIndent . "next;\n" if $1 eq "continue";
	push @converted, $newLine;
    } else {
	if($line =~ /^\s*import/){
	    #ignore
	} else {
	    $untransLine = "TODO". $line;
	    push @converted, $untransLine;
	}
    }
    $prevIndent = $currIndent;
}

$currIndent = "";
if(length($currIndent) < length($prevIndent)){
    $blockClose = $currIndent . "}\n";
    push @converted, $blockClose;
}

@refinement = ();
foreach $line(@converted){
    $line =~ s/int\(sys\.stdin\.readline\(\)\)/\<STDIN\>/;
    $line =~ s/sys\.stdin\.readline\(\)/\<STDIN\>/;
    if($line =~ /^TODO/){ #secondary pass
	$line = substr $line, 4;
	if($line =~ /^(\s*)/){
            #keep track of the indentation of this line
            $currIndent = $1;
            chomp $currIndent;
    	}
	if($line =~ /^\s*print\s*(.*)\s*$/){
            #print statement
            $toPrint = $1;
            if($toPrint =~ /^[^\"].*[^\"]$/){$toPrint = changeVar($toPrint);}
            $newLine = $currIndent . "print $toPrint, \"\\n\";\n";
	    push @refinement, $newLine;
	} elsif($line =~ /^\s*([a-z][a-z0-9]*)\s*=\s*(.*)\s*/){
	    #variable assignment
            #extract variable name
            $varName = $1;
            #extract variable value and look for variables inside
            $varVal = changeVar($2);
            #keep track of variable name
            $variables{$varName} = $varVal;
            #construct the new line
            $newLine = $currIndent . "\$$varName = $varVal;\n";
            push @refinement, $newLine;
	} elsif($line =~ /^\s*(break|continue)/){
	    $newLine = $currIndent . "last;\n" if $1 eq "break";
            $newLine = $currIndent . "next;\n" if $1 eq "continue";
            push @refinement, $newLine;
	} else {
	    push @refinement, $line;
	}
    } else {
	push @refinement, $line;
    }
}

print @refinement;

sub changeVar {
    my ($line) = @_;
    foreach my $var ( keys %variables){
	$line =~ s/\b($var)\b/\$$var/g;
    }
    return $line;

}
