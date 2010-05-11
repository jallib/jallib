use strict;


while (<>) {       
   
   if (/language=Java;/) {
      print	"language=C;	ASTLabelType=pANTLR3_BASE_TREE; output=AST;  // C code\n";
      next;
   }       
   print;
}