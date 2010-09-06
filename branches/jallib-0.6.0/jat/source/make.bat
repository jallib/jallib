@echo off
rem java -cp antlr-3.2.jar org.antlr.Tool jal.g 
perl c:\myrobot\tools\do\do.pl -nouptodate .exe test

rem perl c:\myrobot\tools\do\do.pltest 
    
goto end

rem  gcc -B..\cruntime\libantlr3c-3.1.2\ parser.c jalLexer.c jalParser.c runtime\antlr3baserecognizer.c runtime\antlr3basetree.c runtime\antlr3basetreeadaptor.c runtime\antlr3bitset.c runtime\antlr3collections.c runtime\antlr3commontoken.c runtime\antlr3commontree.c runtime\antlr3commontreeadaptor.c runtime\antlr3commontreenodestream.c runtime\antlr3convertutf.c runtime\antlr3cyclicdfa.c runtime\antlr3debughandlers.c runtime\antlr3encodings.c runtime\antlr3exception.c runtime\antlr3filestream.c runtime\antlr3inputstream.c runtime\antlr3intstream.c runtime\antlr3lexer.c runtime\antlr3parser.c runtime\antlr3rewritestreams.c runtime\antlr3string.c runtime\antlr3stringstream.c runtime\antlr3tokenstream.c runtime\antlr3treeparser.c runtime\antlr3ucs2inputstream.c  -o parser.exe

rem runtime\antlr3baserecognizer.c runtime\antlr3basetree.c runtime\antlr3basetreeadaptor.c runtime\antlr3bitset.c runtime\antlr3collections.c runtime\antlr3commontoken.c runtime\antlr3commontree.c runtime\antlr3commontreeadaptor.c runtime\antlr3commontreenodestream.c runtime\antlr3convertutf.c runtime\antlr3cyclicdfa.c runtime\antlr3debughandlers.c runtime\antlr3encodings.c runtime\antlr3exception.c runtime\antlr3filestream.c runtime\antlr3inputstream.c runtime\antlr3intstream.c runtime\antlr3lexer.c runtime\antlr3parser.c runtime\antlr3rewritestreams.c runtime\antlr3string.c runtime\antlr3stringstream.c runtime\antlr3tokenstream.c runtime\antlr3treeparser.c runtime\antlr3ucs2inputstream.c 

:end