use strict;

my %Links;

my $debug = 0;

{  # start of main
   my $reference;
   my $chapter;
   my ($start, $einde);
   my $state = 0;
   
   print"<a name=\"top\">\n";
   
   while (<>) {

      if (/<H1/) {
         $state = 1; # done with collect, now fix.
      }
      if ($state == 0) {
         # collect required anchors
         if(/outline/) {
            $reference = $_;
            $start = index($reference, "HREF=\"#");
            $einde = index($reference, "\">");
            $reference = substr($reference, $start + 7, $einde + 15 - $start);
            $chapter = substr($reference, 2, index($reference, "|outline" ) - 2);
            if (substr($chapter,0, 1) eq "0") {
               $chapter = substr($chapter, 2);
            }

            $Links{$chapter} = $reference;
            print "reference '$reference' found for chapter '$chapter'\n" if ($debug);
         }
      } else {
         # fix (add anchors)
         foreach $chapter (keys %Links) {
            if (index($_, $chapter) != -1) {
               print "<a name=\"$Links{$chapter}\">";
               print if ($debug);
            }            
         }  
      }
      print if ($debug == 0);
   }
}  # end of main
