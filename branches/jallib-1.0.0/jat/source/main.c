//-----------------------------------------------------------------------------
// Title: main.c
//-----------------------------------------------------------------------------  
// Description: main functions of 'Just Another Translator'.
//
//-----------------------------------------------------------------------------  
// Copyright (c) 2010, Joep Suijs
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
// 
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer. 
//
// Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution. 
//
// Neither the name of the <ORGANIZATION> nor the names of its contributors may
// be used to endorse or promote products derived from this software without 
// specific prior written permission.    
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//-----------------------------------------------------------------------------

#include "jat.h"

int Verbose = 0;


void CodeGenerate(pANTLR3_BASE_TREE p);
void CIndent(int Level);
                         

// command line option - vars
char *Filename       = NULL; 
char *OutFileName    = NULL;
char *IncludePath    = NULL;
int   NoInclude      = 0;
int   NoMainParams   = 0;
int   ToStdOut       = 0;
int   ParseOnly      = 0;

char *Namestring = "JAT V0.1 - Just Another Translator (Jal -> C code converter)";                       


// Main entry point for JustAnotherTranslator
//
int main (int argc, char *argv[])
{  jalParser_program_return r;

   printf("%s\n", Namestring);                       
  
   int i;

   for (i=1; i<argc; i++) {   

      if (strcmp(argv[i], "-h") == 0) {
         // help message
//         printf("   (argv[0]: '%s', assumed 'jalparser')\n", argv[0]);
         printf("\n");
         printf("  jalparser sourcefile.jal - converts 'sourcefile.jal' to 'sourcefile.c'\n");
         printf("\n");
         printf("  -s path [ ';' path1... ] - set include search path (like jal compiler)\n");
         printf("\n");
         printf("  -o outfile.c             - output is 'outfile.c' (overrides 'sourcefile.c')\n");
         printf("  -stdout                  - output to stdout, overrides -s\n");
         printf("\n");         
         printf("  -v                       - increase verbose level, can be used multiple times\n");
         printf("  -noinclude               - ignore include statments\n");
         printf("  -parseonly               - exit after parse, do not generate code\n");
         printf("\n");
         
         exit(0); 
      }

      if (strcmp(argv[i], "-s") == 0) {
         // include path
         i++;
         if (IncludePath != NULL) {
            printf("Error: second include path %s specified, while only one is supported\n", argv[i]);
            printf("First one: %s\n", IncludePath);
            exit(1);
         }                   
         IncludePath = argv[i];
         continue;
      }                 

      if (strcmp(argv[i], "-o") == 0) {
         // output filename
         i++;
         if (OutFileName != NULL) {
            printf("Error: second output filename (-o) %s specified, while only one is supported\n", argv[i]);
            printf("First one: %s\n", OutFileName);
            exit(1);
         }                   
         OutFileName = argv[i];
         continue;
      }                 
      
      if (strcmp(argv[i], "-v") == 0) {
         // verbose (use two times for more verbose)
         Verbose ++;
         continue;
      }

      if (strcmp(argv[i], "-nomainparams") == 0) {
         // no-main-params - main(void) rather than main(argc, argv)
         NoMainParams = 1;
         continue;
      }

      if (strcmp(argv[i], "-noinclude") == 0) {
         // no-include - disable include function
         NoInclude = 1;
         continue;
      }

      if (strcmp(argv[i], "-parseonly") == 0) {
         // parse-only - exit after parse
         ParseOnly = 1;
         continue;
      }

      if (strcmp(argv[i], "-stdout") == 0) {
         // stdout - output to stdout rather then filename (usefull to catch the last bytes when exceptions occure)
         ToStdOut = 1;
         continue;
      }

      // check if argument starts with '-', which is not a filename...
      if (argv[i][0] == '-') {
         printf("Error: unrecognized command line option: '%s'\n", argv[i]);
         exit(1);
      }

      // default = filename
      if (Filename != NULL) {
         printf("Error: second Filename %s specified, while only one is supported\n", argv[i]);
         printf("First one: %s\n", Filename);
         exit(1);
      }                   
      Filename = argv[i];

   }

   //-------------------------   
   // argument processing done.
   //-------------------------   
   
   // check for filename param.
   if (argc < 2 || Filename == NULL) {
      printf("Use: %s sourcefile.jal\n", argv[0]);
      printf("     %s -h for help\n", argv[0]);
      exit(0);
   }

   // open output file
   if (OutFileName!= NULL) {
      // specific filename, no translation by OpenCodeOut
      if (OpenCodeOut(OutFileName, 0) == 0) {
         printf("Error opening output file '%s'\n", OutFileName);
         exit(1);
      }
   } else {
      // no output filename, so base it on input filename      
      // note: OpenCodeOut() changes extension from '.jal' to '.c'     
      if (OpenCodeOut(Filename, 1) == 0) {
         printf("Error opening output\n");
         exit(1);
      }
   }

   // start message
   CodeOutput(VERBOSE_ALL, "//%s\n", Namestring);                       

   // dump parameters.
   CodeOutput(VERBOSE_M, "//-----------------------------\n");
   CodeOutput(VERBOSE_M, "// argv[0]:        %s\n", argv[0]);
   CodeOutput(VERBOSE_M, "// Source:         %s\n", Filename);
   CodeOutput(VERBOSE_M, "// -s:             %s\n", IncludePath);
   CodeOutput(VERBOSE_M, "// -o              %s\n", OutFileName);
   CodeOutput(VERBOSE_M, "// -stdout         %d\n", ToStdOut);
   CodeOutput(VERBOSE_M, "// -v              %d\n", Verbose);
   CodeOutput(VERBOSE_M, "// -nomainparams   %d\n", NoMainParams);
   CodeOutput(VERBOSE_M, "// -noinclude      %d\n", NoInclude);
   CodeOutput(VERBOSE_M, "// -parseonly      %d\n", ParseOnly);
   CodeOutput(VERBOSE_M, "//-----------------------------\n");
   

   // ------------------------------
   // okay, now the real work start!
   // ------------------------------

   // read, LEX and PARSE source tree   
   r= ParseSource(Filename);

//extern pjalLexer lxr;
//   printf("// Nr of syntax errors in parser: %d\n", lxr.getNumberOfSyntaxErrors()   );
// (niet werkend, zou moeten werken op zowel lexer als parser object... een keer uitzoeken.)
 
// this works (but there is similar code in the parser): 
//    extern pjalParser psr;
//    printf("// Nr of syntax errors in parser: %d\n", psr->pParser->rec->getNumberOfSyntaxErrors(psr->pParser->rec)   );

   if (Verbose > 0) {
      
      CodeOutput(VERBOSE_L, "// Tree : %s\n", r.tree->toStringTree(r.tree)->chars);  // dump whole tree on one line

      // print tree elements with indent
      TreeWalk(r.tree);
   }


   if (ParseOnly) {
      CodeOutput(VERBOSE_UNCOND, "// ParseOnly done.\n");
      exit(0);
   }

   // call code generator   
   CodeGenerate(r.tree);  

   if (Verbose) DumpContext(GlobalContext);

   if (ErrorCount) {
      exit(1);
   }       
   exit(0); // success
 
   // below is memory cleanup, which sometimes causes 0-pointer exceptions. 
   // Should be fixed one day... 
   //   if (psr) { 
   //      psr->free(psr);	    
   //      psr = NULL;
   //   } else {
   //      printf("psr is null at close\n");
   //   }
   //   if (tstream) { 
   //    tstream ->free(tstream);
   //    tstream = NULL;
   //   } else {
   //      printf("tstream is null at close\n");
   //   }                 
   //   if (lxr) { 
   //   lxr->free(lxr);
   //   lxr = NULL;
   //   } else {
   //      printf("lxr is null at close\n");
   //   }                 
   //
   //   if (input) { 
   //    input ->free(input);
   //    input = NULL;
   //   } else {
   //      printf("input is null at close\n");
   //   }                 
   //
  
   return 0;
}



//-----------------------------------------------------------------------------
// CIndent - print comment-indent for treewalk
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CIndent(int Level)
{   int i;
   Level += 2;
   CodeOutput(VERBOSE_ALL, "\n//");   
   for (i=0; i<Level; i++) CodeOutput(VERBOSE_ALL, "   ");
}

extern pANTLR3_UINT8   jalParserTokenNames[];

//-----------------------------------------------------------------------------
// TreeWalkWorker -
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void TreeWalkWorker(pANTLR3_BASE_TREE p, int Level)
{  ANTLR3_UINT32   n, c;

	if  (p->isNilNode(p) == ANTLR3_TRUE) {
	   CodeOutput(VERBOSE_ALL, "// nil-node");
//	   return;
	}
   
   n = p->getChildCount(p);
   
   for	(c = 0; c<n ; c++) {
      pANTLR3_BASE_TREE   child;
      child = p->getChild(p, c);
      //         printf(" %s\n",child->toString(child)->chars);      
      int ChildCount = child->getChildCount(child);                     
      pANTLR3_COMMON_TOKEN Token;
      if (child->getToken == NULL) {
         CodeOutput(VERBOSE_ALL, "\n// getToken null");
         Token = 0; 
      } else {
         Token = child->getToken(child);
      }


      ANTLR3_UINT32 TokenType = child->getType(child);
      CIndent(Level);            
      CodeOutput(VERBOSE_ALL, "%s (%d, %s from ",child->toString(child)->chars, TokenType, jalParserTokenNames[TokenType]);   
  
      if (Token->input) {
         CodeOutput(VERBOSE_ALL,"%s, ", Token->input->fileName->chars);
      }
      CodeOutput(VERBOSE_ALL, "Line %d:%d)",Token->getLine(Token), Token->getCharPositionInLine(Token));



// works but only prints root file name.      
// Need to initialize lexer somehow    
//extern pjalLexer lxr;
//printf("file name %s,",lxr->pLexer->input->fileName->chars);



// error reporting stuff
//    ex->streamName		= ((pANTLR3_COMMON_TOKEN)(ex->token))->input->fileName
//
//    if	(token->getChannel(token) > ANTLR3_TOKEN_DEFAULT_CHANNEL)
//     {
//	   outtext->append8(outtext, "(channel = ");
//	   outtext->addi	(outtext, (ANTLR3_INT32)token->getChannel(token));
//	   outtext->append8(outtext, ") ");
//    }
//
//    outtext->addi   (outtext, (ANTLR3_INT32)token->getLine(token));
//    outtext->append8(outtext, " LinePos:");
//    outtext->addi   (outtext, token->getCharPositionInLine(token));


//      printf("%s\n",child->toString(child)->chars);  
      if (ChildCount > 0) {
         TreeWalkWorker(child, Level+1);   
      }
   }
}

//-----------------------------------------------------------------------------
// TreeWalk -
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void TreeWalk(pANTLR3_BASE_TREE p)
{   
   TreeWalkWorker(p, 0);       
}             



// error reporting stuff
//    ex->streamName		= ((pANTLR3_COMMON_TOKEN)(ex->token))->input->fileName
//
//    if	(token->getChannel(token) > ANTLR3_TOKEN_DEFAULT_CHANNEL)
//     {
//	   outtext->append8(outtext, "(channel = ");
//	   outtext->addi	(outtext, (ANTLR3_INT32)token->getChannel(token));
//	   outtext->append8(outtext, ") ");
//    }
//
//    outtext->addi   (outtext, (ANTLR3_INT32)token->getLine(token));
//    outtext->append8(outtext, " LinePos:");
//    outtext->addi   (outtext, token->getCharPositionInLine(token));
