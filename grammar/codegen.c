// codegen.c

#include <stdio.h>
#include    "jalLexer.h"
#include    "jalParser.h"

void CodeGenerate(pANTLR3_BASE_TREE p);


//-----------------------------------------------------------------------------
// Indent - print indent for screen dump / treewalk
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void static Indent(int Level)
{   int i;
   Level += 2;
   
   for (i=0; i<Level; i++) printf("   ");
}

extern pANTLR3_UINT8   jalParserTokenNames[];

// an expression is a node with an operation, with two
// subnodes, or a single node with a value or identifier. 
int CgExpression(pANTLR3_BASE_TREE p, int Level)
{  ANTLR3_UINT32   n, ChildIx, TokenType;
   pANTLR3_BASE_TREE   Child;
   pANTLR3_COMMON_TOKEN Token;
   int ChildCount;

   Indent(Level);            
   printf("// CgExpression\n");      
  
   n = p->getChildCount(p);

   // get data from supplied node
   Token = p->getToken(p);
   TokenType = p->getType(p);

   switch(TokenType) {
      case IDENTIFIER :
      case DECIMAL_LITERAL :
         Indent(Level);            
         printf("%s // constant or identifier \n", p->toString(p)->chars);
         break;

      case PLUS :
      case MINUS :                    
         if (n == 2) {
            Indent(Level);            
            printf("( // start subexpr\n");
            CgExpression(p->getChild(p, 0), Level + 1);
            Indent(Level);            
            printf(")%s( // tostring \n", p->toString(p)->chars);
            CgExpression(p->getChild(p, 1), Level + 1);
            Indent(Level);            
            printf(") // end subexpr\n");
         } else {
            printf("Error: not two subnodes\n");
         }
         break;

      default :
         printf("// unknown token %s type %d %s // tostring \n", p->toString(p)->chars, TokenType, jalParserTokenNames[TokenType]);
         break;      
   }
}


// an assignment is a node with an operation, with two
// subnodes, the target identifier and an expression. 
int CgAssign(pANTLR3_BASE_TREE p, int StartIx, int Level)
{  ANTLR3_UINT32   n, ChildIx, TokenType;
   pANTLR3_BASE_TREE   Child;
   pANTLR3_COMMON_TOKEN Token;
   int ChildCount;

   printf("// CgAssign\n");      

   n = p->getChildCount(p);
   if (n < StartIx) {
      printf("Error: n < StartIx (%d < %d)\n", n, StartIx);
   }

   // first node is identifier to assign to.
   StartIx = 0; // take first node, regardless of param value!
   Child = p->getChild(p, StartIx);  
   Token = Child->getToken(Child);
   TokenType = Child->getType(Child);

   if (TokenType == IDENTIFIER) {   
      Indent(Level);            
      printf("%s  = // assign identifier\n", Child->toString(Child)->chars);
   } else {
      printf("Assign error: token %s \n", Child->toString(Child)->chars);
   }                
   
   // second node is expr
   StartIx++; 
   Child = p->getChild(p, StartIx);  
//   Token = Child->getToken(Child);
//   TokenType = Child->getType(Child);

   CgExpression(Child, Level + 1);   
   
}



void CgFor(pANTLR3_BASE_TREE p, int StartIx, int Level)
{  ANTLR3_UINT32   n, ChildIx;
   pANTLR3_BASE_TREE   Child;
   int ChildCount;
   pANTLR3_COMMON_TOKEN Token;
      
   printf("// CgFor\n");      
  
   n = p->getChildCount(p);
   if (n < StartIx) {
      printf("Error: n < StartIx (%d < %d)\n", n, StartIx);
   }
  
   // first, create expression  
   ChildIx = CgExpression(p, Level);

   // next, check for 'using'
      // true -> use ident
      // false -> generate loop name
      

   printf(" for (;;) {\n");


   // check if next one is loop
     // true -> statement
   
//   for	(ChildIx = StartIx; ChildIx<n ; ChildIx++) {
//      Child = p->getChild(p, ChildIx);
////      ChildCount = Child->getChildCount(Child);                     
//      pANTLR3_COMMON_TOKEN Token;
//      if (Child->getToken == NULL) {
//         printf("Error: getToken null\n");
//         Token = 0;     
//         return;
//      }
//
//      Token = Child->getToken(Child);
//
////      printf("@ %s %d\n", child->toString(child)->chars, Token->getTokenIndex(Token)); // tokenindex = plaat is ??
////      printf(" %s (%d %d)\n",child->toString(child)->chars, ChildCount, child->getType(child));   
//
//      ANTLR3_UINT32 TokenType = Child->getType(Child);
//      
//      switch(TokenType) {
//         case L_FOR :
//            CgFor(Child, 0, Level+1); // process nodes of child            
//            Indent(Level);            
//            printf("} // end of loop \n"); // end for statement
//            continue;
//            //break;
//      }
//      
//      Indent(Level);            
//      printf("// %s (%d, %s)\n",Child->toString(Child)->chars, TokenType, jalParserTokenNames[TokenType]);   
////      printf("%s\n",child->toString(child)->chars);  
//      if (ChildCount > 0) {
//         CgStatement(Child, 0, Level+1);   
//      }
//   }
}


//-----------------------------------------------------------------------------
// CgStatement -
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CgStatement(pANTLR3_BASE_TREE p, int StartIx, int Level)
{  ANTLR3_UINT32   n, ChildIx;
   pANTLR3_BASE_TREE   Child;
 //  int ChildCount;
   pANTLR3_COMMON_TOKEN Token;
   ANTLR3_UINT32 TokenType;
      
	if  ((p->isNilNode(p) == ANTLR3_TRUE) & (Level != 0)) {
	   printf("Error? nil-node %d\n", Level);
	   return;
	}
   
   n = p->getChildCount(p);
   if (n < StartIx) {
      printf("Error: n < StartIx (%d < %d)\n", n, StartIx);
   }
   
   for (ChildIx = StartIx; ChildIx<n ; ChildIx++) {
      Child = p->getChild(p, ChildIx);
      if (Child->getToken == NULL) {
         printf("Error: getToken null\n");
         Token = 0;     
         return;
      }

      Token = Child->getToken(Child);
      TokenType = Child->getType(Child);
      Indent(Level);            
      printf("// %s (%d, %s)\n",Child->toString(Child)->chars, TokenType, jalParserTokenNames[TokenType]);   

      switch(TokenType) {
         case L_FOR : {
            CgFor(Child, 0, Level+1); // process nodes of child            
            Indent(Level);            
            printf("} // end of loop \n"); // end for statement
            continue;
            //break;   
         }
         case ASSIGN : {
            CgAssign(Child, 0, Level+1); // process nodes of child            
            Indent(Level);            
            printf("; // end of assign \n"); // end statement
            continue;
            //break;   
         }
         
      }

      
//      printf("%s\n",child->toString(child)->chars);  
//      if (ChildCount > 0) {
//         CgStatement(Child, 0, Level+1);   
//      }
   }
}

//-----------------------------------------------------------------------------
// CodeGenerate -
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CodeGenerate(pANTLR3_BASE_TREE p)
{  int ChildIx, Level;
   
   printf("// Jal -> C code converter\n");                       
   ChildIx = 0;
   Level = 0;
   CgStatement(p, ChildIx, Level); // start processing child 0 of root node, which is level 0
   printf("// Jal -> C END\n"); 
}
