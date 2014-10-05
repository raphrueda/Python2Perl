#!/usr/bin/perl -w

%variables = ();
@converted = ();

$prevIndent = "";
$currIndent = "";

while($line = <>){
    if($line =~ /^(\s*)/){				#INDENTATION TRACKER
	$currIndent = $1;
	chomp $currIndent;
	$currIndent =~ s/\t/        /g;			#replace tabs with 8 spaces
    }
    if(length($currIndent) < length($prevIndent) && $line !~ /^\s*(else|elif)/){	#BLOCK CLOSING HANDLER
	$currLen = length($currIndent) / 4;						#produces the cleanest output with indents = 4 spaces
	$prevLen = length($prevIndent) / 4;
	@closingBraces = ();								#cant push directly, since output is reversed
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
    if($line =~ // && $. == 1){					#PYTHON -> PERL HANDLER
	push @converted, "#!/usr/bin/perl -w\n";
    } elsif($line =~ /^\s*#/ || $line =~ /^\s*$/){		#COMMENT AND EMPTY LINE HANDLER
	push @converted, $line;
    } elsif($line =~ /^\s*print\s*(.*)\s*$/){			#PRINT HANDLER
	$toPrint = $1;
	$toPrint =~ s/(\"\s*),(\s*)/ $1 . $2/;
	$toPrint =~ s/(\.\s*)([a-z])/$1\$$2/gi;
	if($toPrint ne ""){					#not just printing a new line
    	    if($toPrint =~ /^[^\"]/ && $toPrint =~ /[^\"]$/){
		$toPrint = changeVar($toPrint);
	    }
	    $newLine = $currIndent . "print $toPrint, \"\\n\";\n";
	} else {						#empty print -> new line
	    $newLine = $currIndent . "print \"\\n\";\n";
	}
	push @converted, $newLine;
    } elsif($line =~ /^\s*([a-z][a-z0-9]*)\s*=\s*(.*)\s*/i){	#VARIABLE ASSIGNMENT HANDLER
	$varName = $1;						#extract variable name
	$varVal = changeVar($2);				#extract value, looking for existing variables
	$variables{$varName} = $varVal;				#store in a hash
	$newLine = $currIndent . "\$$varName = $varVal;\n";	#construct and push
	push @converted, $newLine;
    } elsif($line =~ /^\s*(if|while|elif)\s*(.*)\s*:/){		#CONDITION STRUCTURE HANDLER
	$condition = changeVar($2);				#extract condition
	$blockType = $1;					#extract type
	if($blockType eq "elif"){
	    $newLine = $currIndent . "} elsif (" . $condition . "){\n";
	    push @converted, $newLine;
	} else {
	    $newLine = $currIndent . $blockType . " (" . $condition . ") {\n";
	    push @converted, $newLine;
	    if ($line !~ /:\s*$/){				#ONE-LINE IF/WHILE HANDLER
	        $line =~ /^\s*[^ ]*\s*.*:\s*(.*)\s*$/;		
	        $body = $1;					
	        @actions = split(/; /, $body);			#store actions in a hash
	        foreach $action(@actions){
        	    $newAction = "TODO" . $currIndent . "    " . $action . "\n";
		    push @converted, $newAction;		#push each action with a TODO tag
                }
	        $closeBlock = $currIndent . "}\n";		#close the block
	        push @converted, $closeBlock;
	    }
	}
    } elsif($line =~ /^\s*else/){				#ELSE HANDLER
	$newLine = $currIndent . "} else {\n";
	push @converted, $newLine;
    } elsif($line =~ /^\s*for\s*([a-z][a-z0-9]*)\s*in range\((.*)\)/){	#FOR HANDLER
	$iterator = $1;							#extract the iterating variable
	$variables{$iterator} = 1;					#store it in the hash
	$range = $2;							#extract the range
	if($range =~ /^([a-z0-9\+\-\/\*\% ]*), ([a-z0-9\+\-\/\*\% ]*)/){#two argument range handler
	    $rangeLow = $1;
	    $rangeHigh = $2;
	} elsif($range =~ /^([a-z0-9\+\-\/\*\% ]*)$/){			#one argument range handler
	    $rangeLow = 0;
	    $rangeHigh = $1;
	}
	if($rangeHigh =~ /([\+\-])\s*([0-9]*)\s*$/){			#if higher range ends in a displacement
	    $numericDisplacement = $2 - 1 if $1 eq "+";	
	    $numericDisplacement = $2 + 1 if $1 eq "-";
	    $rangeHigh =~ s/$2/$numericDisplacement/;
	} else {							#if higher range is a multi.. or div..
	    $rangeHigh .= " - 1";
	}
	if($rangeHigh =~ /^(.*)\s*[\+\-]\s*0/){
	    $rangeHigh = $1;
	    $rangeHigh =~ s/\s*$//;
	}
	$rangeLow = changeVar($rangeLow);
	$rangeHigh = changeVar($rangeHigh);	
	$newLine = $currIndent . "foreach \$$iterator ($rangeLow..$rangeHigh) {\n";
	push @converted, $newLine;
    } elsif($line =~ /^\s*sys\.stdout\.write\((.*)\)/){			#STDOUT HANDLER
	$newLine = $currIndent . "print $1;\n";
	push @converted, $newLine;
    } elsif($line =~ /^\s*(break|continue)/){				#BREAK/CONTINUE HANDLER
	$newLine = $currIndent . "last;\n" if $1 eq "break";
	$newLine = $currIndent . "next;\n" if $1 eq "continue";
	push @converted, $newLine;
    } else {					#OTHER HANDLERS
	if($line =~ /^\s*import/){		#ignore imports
	} else {
	    $untransLine = "TODO". $line;	#tag anything that was left untranslated with a TODO
	    push @converted, $untransLine;
	}
    }
    $prevIndent = $currIndent;
}

$currIndent = "";
if(length($currIndent) < length($prevIndent)){      #BLOCK CLOSING HANDLER (for end of code)
    $currLen = length($currIndent) / 4;             #assumes that indentation is 4 spaces
    $prevLen = length($prevIndent) / 4;
    @closingBraces = ();                            #cant push directly, since output is reversed
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

@refinement = ();
foreach $line(@converted){					#CLEANUP
    $line =~ s/int\(sys\.stdin\.readline\(\)\)/\<STDIN\>/;	#stdin handler
    $line =~ s/sys\.stdin\.readline\(\)/\<STDIN\>/;
    if($line =~ /^TODO/){ 					#secondary pass
	$line = substr $line, 4;
	if($line =~ /^(\s*)/){					#indentation tracker
            $currIndent = $1;
            chomp $currIndent;
    	}
	if($line =~ /^\s*print\s*(.*)\s*$/){			#print handler
            $toPrint = $1;
            if($toPrint =~ /^[^\"]?.*[^\"]?$/){$toPrint = changeVar($toPrint);}
            $newLine = $currIndent . "print $toPrint, \"\\n\";\n";
	    push @refinement, $newLine;
	} elsif($line =~ /^\s*([a-z][a-z0-9]*)\s*=\s*(.*)\s*/){	#variable assignment
            $varName = $1;
            $varVal = changeVar($2);
            $variables{$varName} = $varVal;
            $newLine = $currIndent . "\$$varName = $varVal;\n";
            push @refinement, $newLine;
	} elsif($line =~ /^\s*(break|continue)/){
	    $newLine = $currIndent . "last;\n" if $1 eq "break";
            $newLine = $currIndent . "next;\n" if $1 eq "continue";
            push @refinement, $newLine;
	} elsif($line =~ /^\s*sys\.stdout\.write\((.*)\)/){
	    $newLine = $currIndent . "print $1;\n";
            push @refinement, $newLine;
	} else {
	    push @refinement, $line;
	}
    } else {
	push @refinement, $line;
    }
}

print @refinement;			#print the code

sub changeVar {				#subroutine to replace instances of variables
    my ($line) = @_;
    foreach my $var ( keys %variables){
	$line =~ s/\b($var)\b/\$$var/g;
    }
    return $line;

}
