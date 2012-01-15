# makefile.do - jalparser build description
#

set(projectname, jalparser)                            
set(avr_comport, com1)
set(term_baudrate, 115200)

createlist(project) {     
   "../grammar/jal.g"

   main.c
   parser.c    
   codegen.c    
   symboltable.c 
   output.c   
}

foreach (t_grammar, .g)  {                   
   depend(jat.h, .g) 
   output("jal.g", clean) # geconverteerde versie van jal.g met aangepaste params
   output("jalLexer.c")
   output("jalParser.c", clean, outlist, depend) # demo, idem als zonder attribute params.

   exec("perl changeoptions.pl ($filename).g >jal.g")   
   exec("java -cp antlr-3.2.jar org.antlr.Tool jal.g")   
}

foreach(t_compile, .c) {                 
   print("t+compile voor file ($filename_ext)")    # print demo

   depend(.c, "jat.h", "symboltable.h")
#   usedependfile(.d)   not yet supported
   output(.o)
   
   exec("gcc -Wmissing-prototypes\" -Blibantlr3c-3.2\\ -c ($filename_ext) -o ($filename).o")
}

merge(t_link, .o) {
   depend (.o, ".\\libantlr3c-3.2\\antlr3.lib")  
   output("($projectname).exe", depend, clean)  # note: don't put final targt in outlist, since it does not require further processing.
   
   exec("gcc -Wl,-Map=($projectname).map ($filename_ext) .\\libantlr3c-3.2\\antlr3.lib -o ($projectname).exe")
}

command(all) { 
   uselist(project)
   #clean .
   call(t_grammar)
   call(t_compile)
   dumplist()
   call(t_link)
   dumpvars()
}

#command(clean)
#{
#
#}

command(test) {
   set(cmd, "jalparser -v -v -v ")
   append(cmd, " test.jal")
   exec (cmd)

   exec("gcc test.c -otest.exe")
}

command(terminal) { 
  exec("c:/myrobot/jal/bootloader/pdload.exe port ($avr_comport) termspeed ($term_baudrate) TERM_RTSON TERMINAL")
}    
    

