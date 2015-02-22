use strict;


my $OrigLine;      
my @Field;

{ # main

   my $IndentLevel = 0;
   my $i;
   my $filename = $ARGV[0];
                                  
                                  
   print "JalIndent file $filename\n";
   
   for (<>) {
      
#      chomp;
      $OrigLine = $_;
                      
                      
      # --------------------                      
      # process comment "--"
      # --------------------                      
      $i =index($_, "--");

#      print "# $i _ $_\n";
            
      if ($i == 0) {
         # comment at 0-indent stays that way; print & done
         print $OrigLine;
         next;
      }
         
      if ($i > 0) {
      	# comment at higher-level -> parse & reindent string until comment
      	$_ = substr($_, 0, $i);
      }

      # -------------------                      
      # process comment ";"
      # -------------------                      
      $i =index($_, ";");

 #     print "a $i _ $_";
            
      if ($i == 0) {
         # comment at 0-indent stays that way; print & done
         print $OrigLine;
         next;
      }
         
      if ($i > 0) {
      	# comment at higher-level -> parse & reindent string until comment
      	$_ = substr($_, 0, $i);
      }

#      print "b $i _ $_";

		# now we have a line without comment
                     

      # remove strings
      $_ =~ s/\".*\"/ STRING /g;		


		# convert 'other' separators to spaces
      $_ =~ s/\(/ /g;		
      $_ =~ s/\)/ /g;		
      $_ =~ s/=/ /g;		
      $_ =~ s/\t/ /g;		
               
               
               
#      print "c $i _ $_";
      
      # get Fields
      @Field = split();
     
      # determine indent-correction (sometimes one indentlevel less is desired)
      $i = 0; # by default, do not correct indent
      if ($#Field != -1) {
         # there are one or more words this line.
         push(@Field, "irrelevant");   # add an 'irrelevant' token at the end
         $i = CheckIndentCorrection(lc($Field[0]));
         if ($i == 1) { $i = 0; } # no positive correction of indent
      }

      # print the line with proper indent
		$i += $IndentLevel;       
		print $IndentLevel;
	   for (;$i>0; $i--) { print "   "; } 
      print substr($OrigLine, index($OrigLine, $Field[0]));
      

      # calculate the new indention
      if (lc($Field[0] ne "var")) {
         for ($i=0; $i < $#Field; $i++) {           
            $IndentLevel += CheckIndent(lc($Field[$i+0]), lc($Field[$i+1]));
         }
      }
   }
      
      
   if ($IndentLevel == 0) {
      print "# JalIndent succesfull (on file $filename)\n";
   } else {
      print "# JalIndent failed (level $IndentLevel on file $filename)\n";
   }
} # main

sub CheckIndent 
{
   my $Token1 = shift;
   my $Token2 = shift;
   
   if ($Token1 == -1 ) { return 0 ; }

   if ($Token1 eq "end") {
      if ($Token2 eq "assembler" ) {
         return -2;
      }
      if ($Token2 eq "block" ) {
         return -2;
      }
      if ($Token2 eq "case" ) {
         return -2;
      }
      if ($Token2 eq "loop" ) {
         return -2;
      }
      return -1;
   }
   if ($Token1 eq "assembler") {
      return 1;
   }
   if ($Token1 eq "block") {
      return 1;
   }
   if ($Token1 eq "case") {
      return 1;
   }
   if ($Token1 eq "else") {
      return 0;
   }
   if ($Token1 eq "elsif") {
      return -1;
   }
   if ($Token1 eq "is") {
      return 1;
   }
   if ($Token1 eq "loop" ) {
      return 1;
   }
   if ($Token1 eq "then") {
      return 1;
   }
      
   
   return 0;
}

sub CheckIndentCorrection 
{
   my $Token1 = shift;
   
   if ($Token1 eq "end") {
      return -1;
   }
   if ($Token1 eq "else") {
      return -1;
   }
   if ($Token1 eq "elsif") {
      return -1;
   }
   return 0;
}
