use strict;

my $PrintFlag = 0;

while (<>) {       
   
   if (/Jal -> C code converter/) {
      $PrintFlag = 1;
   }       
   print if ($PrintFlag);
}                

