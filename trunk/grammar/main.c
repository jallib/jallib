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

#include <stdio.h>  

// antlr generated
#include    "jalLexer.h"
#include    "jalParser.h"

#include    "symboltable.h"


int verbose = 1;

void CodeGenerate(pANTLR3_BASE_TREE p);

void TreeWalk(pANTLR3_BASE_TREE p);    
jalParser_program_return ParseSource(pANTLR3_UINT8 fName);



// Main entry point for this example
//
int main (int argc, char *argv[])
{  jalParser_program_return r;

   if (argc < 2 || argv[1] == NULL) {
      printf("Use: %s jal-file\n", argv[0]);
      exit(0);
   }

   // read, LEX and PARSE source tree   
   r= ParseSource(argv[1]);
   
   if (verbose > 0) {
      
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

    
   DumpSymbolTable();

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
	   printf("// nil-node\n");
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
         printf("// getToken null\n");
         Token = 0; 
      } else {
         Token = child->getToken(child);
      }


      ANTLR3_UINT32 TokenType = child->getType(child);
      printf("//");
      Indent(Level);            
      printf("%s (%d, %s)\n",child->toString(child)->chars, TokenType, jalParserTokenNames[TokenType]);   
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

   // note: PUSHSTREAM only works in LEX context (not this code, nor PARSER context).
   // So leave it in the gramar-file.
   return in;
}

