# makefile.do - jalparser build description
#

set projectname      jalparser

filelist {     
   ..\grammar\jal.g

   main.c
   parser.c    
   codegen.c    
   symboltable.c 
   output.c 

   jalLexer.c 
   jalParser.c                      
}

transform .g .c  {                   
   exec "perl changeoptions.pl ..\grammar\jal.g >jal.g"   
   exec "java -cp antlr-3.2.jar org.antlr.Tool jal.g"   
   clear suffix
   exec "echo // timestamp dummy >($_).c"   
   exec "del *.o"
}

transform .c .o {  
   clear suffix
   exec "gcc -Wmissing-prototypes -Blibantlr3c-3.2\ -c ($_).c -o ($_).o"
}

merge .o .exe {

   exec "gcc -Wl,-Map=($projectname).map ($_) .\libantlr3c-3.2\antlr3.lib -o ($projectname).exe"
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
   set cmd    "jalparser  "
   append cmd " test.jal"
   exec ($cmd)

   exec "gcc test.c -otest.exe"
}

command terminal { 
  exec "c:\myrobot\jal\bootloader\pdload.exe port ($avr_comport) termspeed ($term_baudrate) TERM_RTSON TERMINAL"
}    
