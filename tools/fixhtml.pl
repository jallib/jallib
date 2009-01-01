use strict;

my %Links;


{  # start of main
   my $reference;
   my $chapter;
   my ($start, $einde);
   my $state = 0;
   
   print"<a name=\"top\">";
   
   while (<>) {

      if (/<H1/) {
         $state = 1; # done with collect, now fix.
      }
      if ($state == 0) {
         # collect required anchors
         if(/outline/) {
            $reference = $_;
            $start = index($reference, "HREF=\"");
            $einde = index($reference, "\">");
            $reference = substr($reference, $start + 6, $einde + 15 - $start);
            $chapter = substr($reference, 3, index($reference, "|outline" ) - 3);
            if (substr($chapter,0, 1) eq "0") {
               $chapter = substr($chapter, 2, length($chapter)- 3);
            }

            $Links{$chapter} = $reference;
#            print "reference '$reference' found for chapter '$chapter'\n";
         }
      } else {
         # fix (add anchors)
         foreach $chapter (keys %Links) {
            if (index($_, $chapter) != -1) {
               print "<a name=\"$Links{$chapter}\">";
#print;
            }
            
         }  
      }
      print;
   }
}  # end of main
