# makefile.do - jalparser build description
#

set projectname      jalparser

filelist {     
   jal.g

   main.c
   parser.c    
   codegen.c    
   symboltable.c
   
   jalLexer.c 
   jalParser.c                      

   libantlr3c-3.2\src\antlr3baserecognizer.c
   libantlr3c-3.2\src\antlr3basetree.c
   libantlr3c-3.2\src\antlr3basetreeadaptor.c
   libantlr3c-3.2\src\antlr3bitset.c
   libantlr3c-3.2\src\antlr3collections.c
   libantlr3c-3.2\src\antlr3commontoken.c
   libantlr3c-3.2\src\antlr3commontree.c
   libantlr3c-3.2\src\antlr3commontreeadaptor.c
   libantlr3c-3.2\src\antlr3commontreenodestream.c
   libantlr3c-3.2\src\antlr3convertutf.c
   libantlr3c-3.2\src\antlr3cyclicdfa.c
#  libantlr3c-3.2\src\antlr3debughandlers.c
   libantlr3c-3.2\src\antlr3encodings.c
   libantlr3c-3.2\src\antlr3exception.c
   libantlr3c-3.2\src\antlr3filestream.c
   libantlr3c-3.2\src\antlr3inputstream.c
   libantlr3c-3.2\src\antlr3intstream.c
   libantlr3c-3.2\src\antlr3lexer.c
   libantlr3c-3.2\src\antlr3parser.c
   libantlr3c-3.2\src\antlr3rewritestreams.c
   libantlr3c-3.2\src\antlr3string.c
   libantlr3c-3.2\src\antlr3stringstream.c
   libantlr3c-3.2\src\antlr3tokenstream.c
   libantlr3c-3.2\src\antlr3treeparser.c
   libantlr3c-3.2\src\antlr3ucs2inputstream.c
}

transform .g .c  {                   
   exec_i "md tmp_g"
   exec "perl changeoptions.pl jal.g >tmp_g\jal.g"   
   exec "java -cp antlr-3.2.jar org.antlr.Tool tmp_g\jal.g"   
   exec "copy /y tmp_g\*.c ."   
   exec "copy /y tmp_g\*.h ."   
   clear suffix
   exec "echo // timestamp dummy >($_).c"   
   exec "del *.o"
}

transform .c .o {  
   clear suffix
   exec "gcc -Blibantlr3c-3.2\ -c ($_).c -o ($_).o"
}

merge .o .exe {

   exec "gcc -Wl,-Map=($projectname).map ($_) -o ($projectname).exe"
}

command all { clean .exe }

command clean
{
   exec_i "del ($projectname).o"
   exec_i "del ($projectname).o.d"
   exec_i "del ($projectname).hex"
   exec_i "del ($projectname).elf"
}

command test {
   set cmd    "jalparser "
   append cmd " test.jal"
   append cmd " >test.c"
   exec ($cmd)

#   exec "cat test.txt"   
#   exec "perl cfilter.pl test.txt >test.c"
   exec "gcc test.c -otest.exe"
 
}


command terminal { 
  exec "c:\myrobot\jal\bootloader\pdload.exe port ($avr_comport) termspeed ($term_baudrate) TERM_RTSON TERMINAL"
}    
