# makefile.do - antlr3 lib build description
#

set projectname      antlr3

filelist {     

   src\antlr3baserecognizer.c
   src\antlr3basetree.c
   src\antlr3basetreeadaptor.c
   src\antlr3bitset.c
   src\antlr3collections.c
   src\antlr3commontoken.c
   src\antlr3commontree.c
   src\antlr3commontreeadaptor.c
   src\antlr3commontreenodestream.c
   src\antlr3convertutf.c
   src\antlr3cyclicdfa.c
#  src\antlr3debughandlers.c
   src\antlr3encodings.c
   src\antlr3exception.c
   src\antlr3filestream.c
   src\antlr3inputstream.c
   src\antlr3intstream.c
   src\antlr3lexer.c
   src\antlr3parser.c
   src\antlr3rewritestreams.c
   src\antlr3string.c
   src\antlr3stringstream.c
   src\antlr3tokenstream.c
   src\antlr3treeparser.c
   src\antlr3ucs2inputstream.c
}

transform .c .o {  
   clear suffix
   exec "gcc -Wmissing-prototypes -B. -c ($_).c -o ($_).o"
}

merge .o .lib {

   exec "ar rcs ($projectname).lib ($_) "
}

command all { clean .lib }

command clean
{
   exec_i "del ($projectname).lib"
   exec_i "del src\*.o"
}

