use strict;

my ($i, $nl);
while (<>) {

   
   # omit lines with only white spaces + comment-N -> empty line   
   if (/^\s*\/\/n/) { print"\n"; next; } 

   # omit lines with only white spaces + comment   
   if (/^\s*\/\//) { next; } 

   # omit lines with only white spaces
   if (/^\s*$/) { next; } 

   s/ +/ /g; # mutli spaces ->  one
   s/^ *//;  # remove start space
   
   $nl = index($_, "//n");   
   if ($nl > 0) {
      print substr($_, 0, $nl) . "\n";
      next;
   }
   
   $i = index($_, "//");   
   if ($i > 0) {
      print substr($_, 0, $i);
      next;
   }

   print;   
}


