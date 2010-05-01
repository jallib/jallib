// Title: main.g
//
// Adapted-by: Joep Suijs
// Compiler: >=2.4m
//
// This file is part of jallib (http://jallib.googlecode.com)
// Released under the ZLIB license (http://www.opensource.org/licenses/zlib-license.html)
//
// Description: test main for antlr3 grammar definition of JAL
//

#include "jat.h"


int Verbose = 0;


void CodeGenerate(pANTLR3_BASE_TREE p);

void TreeWalk(pANTLR3_BASE_TREE p);    
jalParser_program_return ParseSource(pANTLR3_UINT8 fName);

// command line option - vars
char *Filename = NULL;
char *IncludePath = NULL;
int   NoInclude = 0;

// Main entry point for this example
//
int main (int argc, char *argv[])
{  jalParser_program_return r;

   printf("// JAT V0.1 - Just Another Translator (Jal -> C code converter)\n");                       

   int i;

   for (i=1; i<argc; i++) {   
      if (strcmp(argv[i], "-s") == 0) {
         // include path
         i++;
         if (IncludePath != NULL) {
            printf("Error: second include path %s\n", argv[i]);
            printf("First one: %s\n", IncludePath);
            exit(1);
         }                   
         IncludePath = argv[i];
         continue;
      }                 
      
      if (strcmp(argv[i], "-v") == 0) {
         // verbose (use two times for more verbose)
         Verbose ++;
         continue;
      }

      if (strcmp(argv[i], "-noinclude") == 0) {
         // no-include - disable include function
         NoInclude = 1;
         continue;
      }

      // default = filename
      if (Filename != NULL) {
         printf("Error: second Filename %s\n", argv[i]);
         printf("First one: %s\n", Filename);
         exit(1);
      }                   
      Filename = argv[i];

   }
   


   if (argc < 2 || Filename == NULL) {
      printf("Use: %s jal-file\n", argv[0]);
      exit(0);
   }

   // read, LEX and PARSE source tree   
   r= ParseSource(Filename);

//    pjalParser				psr
//extern pjalParser psr;
//   printf("// Nr of syntax errors in parser: %d\n", psr.getNumberOfSyntaxErrors()   );
// (niet werkend, zou moeten werken op zowel lexer als parser object... een keer uitzoeken.)

   if (Verbose > 0) {
      
      printf("// Tree : %s\n", r.tree->toStringTree(r.tree)->chars);  // dump whole tree on one line

      // print tree elements with indent
      TreeWalk(r.tree);
   }

   // call code generator   
   CodeGenerate(r.tree);  


//   Symbol *s;
//   s = AddSymbol();   
//   strcpy(s->Name, "een");
//
//   s = AddSymbol();   
//   strcpy(s->Name, "twee");
//   
//   s = AddSymbol();   
//   strcpy(s->Name, "drie");

    
   if (Verbose) DumpSymbolTable();
       
   return 0;
 
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
// Indent - print indent for screen dump / treewalk
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void Indent(int Level)
{   int i;
   Level += 2;
   printf("\n");   
   for (i=0; i<Level; i++) printf("   ");
}

//-----------------------------------------------------------------------------
// CIndent - print comment-indent for treewalk
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CIndent(int Level)
{   int i;
   Level += 2;
   printf("\n//");   
   for (i=0; i<Level; i++) printf("   ");
}

extern pANTLR3_UINT8   jalParserTokenNames[];

//-----------------------------------------------------------------------------
// TreeWalkWorker -
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void TreeWalkWorker(pANTLR3_BASE_TREE p, int Level)
{  ANTLR3_UINT32   n, c;

	if  (p->isNilNode(p) == ANTLR3_TRUE) {
	   printf("// nil-node");
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
         printf("\n// getToken null");
         Token = 0; 
      } else {
         Token = child->getToken(child);
      }


      ANTLR3_UINT32 TokenType = child->getType(child);
      CIndent(Level);            
      printf("%s (%d, %s from ",child->toString(child)->chars, TokenType, jalParserTokenNames[TokenType]);   
  
      ANTLR3_INPUT_STREAM *is = Token->input;
//      printf("input stream %x,",is);
//      printf("input stream %d,",is->fileName);
      printf("Line %d:%d)",Token->getLine(Token), Token->getCharPositionInLine(Token));
      


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

pANTLR3_INPUT_STREAM JalOpenInclude(char *Line) 
{  int State, i;
   char *BaseName;                       
   char FileName[256];
   pANTLR3_INPUT_STREAM    in;

   if (NoInclude) {
      printf("// Ignore include line %s\n", Line);
      return NULL;
   }
   
//   printf("// JalInclude line: %s\n", Line);

   State = 0;
   for (i=0; ((Line[i] != 0)&(State != 3)); i++) {
      switch(State) {
         case 0 : { // search for first whitespace
            if ((Line[i] == ' ') | (Line[i] == '\t')) {
               State = 1;
            }
            break;  
         }          
         case 1 : { // search for non-whitespace, which is start of filename/path
            if ((Line[i] != ' ') & (Line[i] != '\t')) {
               BaseName = &Line[i];
               State = 2;
            }
            break;  
         }          
         case 2 : { // search for first whitespace, which is end of filename/path
//            if (Line[i] == '/') {
//               Line[i] = '\\';  // seems not required in windows...
//            }
            if ((Line[i] == ' ') | (Line[i] == '\t') | (Line[i] == '\r') | (Line[i] == '\n')) {
               Line[i] = 0; // terminate string
               State = 3;
            }
            break;  
         }               
         default : {
            printf("Error state: %d, i: %d\n", State, i);     
            break;
         }
      }
   }
   printf("// include BaseName: _%s_\n", BaseName);   

   sprintf(FileName, "%s.jal", BaseName);
// TODO:
//
// walk include path to find file.                                  

   in = antlr3AsciiFileStreamNew(FileName);

   if (in == NULL) {
      printf("Error opening include file %s\n", FileName);
      fprintf(stderr, "Error opening include file %s\n", FileName);
      exit(1);
   }

   // note: PUSHSTREAM macro only works in LEX context (not in this code, nor PARSER context).
   // So leave PUSHSTREAM in the gramar-file.
   return in;
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