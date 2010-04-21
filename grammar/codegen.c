// codegen.c

#include <stdio.h>
#include    "jalLexer.h"
#include    "jalParser.h"
extern pANTLR3_UINT8   jalParserTokenNames[];

static int Pass;

// my prototypes
void CodeGenerate(pANTLR3_BASE_TREE p);
void CgStatements(pANTLR3_BASE_TREE p, int StartIx, int Level);


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// code blocks
//-----------------------------------------------------------------------------
// Many functions start alike, so below are code blocks to help on this.
// There are two types of functions:
// - Functions called with StartIx operate on the subnode of the node passed.
//   They at least process this one node (and all of its subnodes, of course)
//   but might also proceed to the next one, until they encounter a node that 
//   not recognised. The function always returns the index of the next subnode
//   to be processed.
// - Functions called without StartIx process the node passed (and all of its 
//   subnodes, of course). There is no return value.
//-----------------------------------------------------------------------------

#define CG_HEADER_NO_STARTIX              \
   ANTLR3_UINT32   n, ChildIx, TokenType; \
   pANTLR3_BASE_TREE   Child;             \
   pANTLR3_COMMON_TOKEN Token;            \
   Indent(Level);                         \
   printf("// %s\n", ThisFuncName);       \
                                          \
   n = p->getChildCount(p);               \
                                          \
   /* get data of supplied node */        \
   Token = p->getToken(p);                \
   TokenType = p->getType(p);             \


#define REPORT_NODE(string, node) {                   \
   Indent(Level);                                     \
   printf("// %s %s %s (%d, %s)\n",                   \
         ThisFuncName, string,                        \
         node->toString(node)->chars,                 \
         node->getType(node),                         \
         jalParserTokenNames[TokenType]);             \
}                                                     \

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// end of code blocks
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

char *VarTypeString(int TokenType)
{
   switch(TokenType) {
      case L_BYTE    : { return "unsigned char";         }
      case L_SBYTE   : { return "char";                  }
      case L_WORD    : { return "unsigned short int";    }
      case L_SWORD   : { return "short intn";            }
      case L_DWORD   : { return "unsigned long int";     }
      case L_SDWORD  : { return "long int";              }
      default        : { return "unexpected token";      }
   }
}



//-----------------------------------------------------------------------------
// Indent - print indent for screen dump / treewalk
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void static Indent(int Level)
{   int i;
   Level += 2;
   
   for (i=0; i<Level; i++) printf("   ");
}




//-----------------------------------------------------------------------------
// CgExpression - Generate code for an Expression node
//-----------------------------------------------------------------------------
// an expression is a node with an operation, with two
// subnodes, or a single node with a value or identifier. 
//-----------------------------------------------------------------------------
int CgExpression(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgExpression";
   CG_HEADER_NO_STARTIX  // declare vars, print debug, get n, Token and TokenType of 'p'
       
   switch(TokenType) {
      case IDENTIFIER :
      case DECIMAL_LITERAL :
         Indent(Level);            
         printf("%s // constant or identifier \n", p->toString(p)->chars);
         break;

      case AMP           :
      case ASTERIX       :
      case BANG          :
      case CARET         :
      case EQUAL         :
      case GREATER       :
      case GREATER_EQUAL :
      case LEFT_SHIFT    :
      case LESS          :
      case LESS_EQUAL    :
      case MINUS         :
      case NOT_EQUAL     :
      case OR            :
      case PERCENT       :
      case PLUS          :
      case RIGHT_SHIFT   :
      case SLASH         :
                         
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
            printf("%s Error: not two subnodes\n", ThisFuncName);
         }
         break;

      default :
         printf("// %s unknown token %s type %d %s // tostring \n", ThisFuncName, p->toString(p)->chars, TokenType, jalParserTokenNames[TokenType]);
         break;      
   }
}

//-----------------------------------------------------------------------------
// CgAssign - Generate code for an assign node and it's subnodes
//-----------------------------------------------------------------------------
// an assignment is a node with an operation, with two
// subnodes, the target identifier and an expression. 
//-----------------------------------------------------------------------------
void CgAssign(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgAssign";
   CG_HEADER_NO_STARTIX  // declare vars, print debug, get n, Token and TokenType of 'p'

   // first node is identifier to assign to.
   Child = p->getChild(p, 0);  
   Token = Child->getToken(Child);
   TokenType = Child->getType(Child);

   if (TokenType == IDENTIFIER) {   
      Indent(Level);            
      printf("%s  = // %s identifier\n", Child->toString(Child)->chars, ThisFuncName);
   } else {
      printf("%s error: token %s \n", ThisFuncName, Child->toString(Child)->chars);
   }                
   
   // second node is expr
   Child = p->getChild(p, 1);  

   CgExpression(Child, Level + 1);      
}

//-----------------------------------------------------------------------------
// CgFor - 
//-----------------------------------------------------------------------------
// A for node has child for it's options and one loop child that contains the
// content of the loop
//-----------------------------------------------------------------------------
void CgFor(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgFor";
   CG_HEADER_NO_STARTIX  // declare vars, print debug, get n, Token and TokenType of 'p'
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      Child = p->getChild(p, ChildIx);
      if (Child->getToken == NULL) {
         printf("Error: getToken null\n");
         return;
      }

      /* get data of child */      
      Token = Child->getToken(Child);                
      TokenType = Child->getType(Child);             

      switch(TokenType) {
         case L_LOOP : {
            Indent(Level);            
            printf(" for (;;) {\n");
            CgStatements(Child, 0, Level+1);
            Indent(Level);            
            printf("}\n");
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", Child);
            break;
         }
      }
   }                
}

//-----------------------------------------------------------------------------
// CgFuncProcCall - 
//-----------------------------------------------------------------------------
// A FuncProc node has child for it's name and one for each parameter (expression)
//-----------------------------------------------------------------------------
void CgFuncProcCall(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgFuncProcCall";
   CG_HEADER_NO_STARTIX  // declare vars, print debug, get n, Token and TokenType of 'p'

   int GotFirstParam = 0;
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      Child = p->getChild(p, ChildIx);
      if (Child->getToken == NULL) {
         printf("Error: getToken null\n");
         return;
      }

      /* get data of child */      
      Token = Child->getToken(Child);                
      TokenType = Child->getType(Child);             

      if (ChildIx == 0) {
         // function/procedure name
         Indent(Level);            
         printf(" %s(\n", Child->toString(Child)->chars);         
         continue;
      }
      
      if (GotFirstParam) printf(",");
      GotFirstParam = 1;
      
      CgExpression(Child, Level + 1);
      
      
   }                
   Indent(Level);            
   printf("); // end of proc/func call\n");

}
 
//-----------------------------------------------------------------------------
// CgVar - 
//-----------------------------------------------------------------------------
// A var node has child for it's options
//-----------------------------------------------------------------------------
void CgVar(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgVar";
   CG_HEADER_NO_STARTIX  // declare vars, print debug, get n, Token and TokenType of 'p'
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      Child = p->getChild(p, ChildIx);
      if (Child->getToken == NULL) {
         printf("Error: getToken null\n");
         return;
      }

      /* get data of child */      
      Token = Child->getToken(Child);                
      TokenType = Child->getType(Child);             

      switch(TokenType) {
         case L_BYTE   : 
         case L_SBYTE  : 
         case L_WORD   : 
         case L_SWORD  : 
         case L_DWORD  : 
         case L_SDWORD : {
            Indent(Level);            
            printf(" %s \n", VarTypeString(TokenType));
            break;
         }
         case IDENTIFIER : {
            Indent(Level);            
            printf(" %s \n", Child->toString(Child)->chars);
            break;
         }
         case COMMA : {
            Indent(Level);            
            printf(",\n");
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", Child);
            break;
         }
      }
   }
   Indent(Level);            
   printf(";\n");                
} 


//-----------------------------------------------------------------------------
// CgParamChilds - 
//-----------------------------------------------------------------------------
// A ParamChilds node
//-----------------------------------------------------------------------------
void CgParamChilds(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgParamChilds";
   CG_HEADER_NO_STARTIX  // declare vars, print debug, get n, Token and TokenType of 'p'
     
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      Child = p->getChild(p, ChildIx);
      if (Child->getToken == NULL) {
         printf("Error: getToken null\n");
         return;
      }

      /* get data of child */      
      Token = Child->getToken(Child);                
      TokenType = Child->getType(Child);             

      switch(TokenType) {
         case L_IN : {
            break;
         }
         case L_OUT : {
            break;
         }
         case IDENTIFIER : {
            Indent(Level);            
            printf(" %s \n", Child->toString(Child)->chars);
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", Child);
            break;
         }
      }
   }
} 

//-----------------------------------------------------------------------------
// CgParams - 
//-----------------------------------------------------------------------------
// A Param node
//-----------------------------------------------------------------------------
void CgParams(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgParams";
   CG_HEADER_NO_STARTIX  // declare vars, print debug, get n, Token and TokenType of 'p'

   int GotFirstParam = 0;
     
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      Child = p->getChild(p, ChildIx);
      if (Child->getToken == NULL) {
         printf("Error: getToken null\n");
         return;
      }

      /* get data of child */      
      Token = Child->getToken(Child);                
      TokenType = Child->getType(Child);             

      if (GotFirstParam) {           
         Indent(Level);
         printf(", // next param\n");
      }
      GotFirstParam = 1;

      switch(TokenType) {
         case L_BYTE   : 
         case L_SBYTE  : 
         case L_WORD   : 
         case L_SWORD  : 
         case L_DWORD  : 
         case L_SDWORD : {
            Indent(Level);            
            printf(" %s \n", VarTypeString(TokenType));
            CgParamChilds(Child, Level+1);
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", Child);
            break;
         }
      }
   }
} 
 
//-----------------------------------------------------------------------------
// CgProcedureDef - 
//-----------------------------------------------------------------------------
// A procedure def node
//-----------------------------------------------------------------------------
void CgProcedureDef(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgProcedureDef";
   CG_HEADER_NO_STARTIX  // declare vars, print debug, get n, Token and TokenType of 'p'

   int GotReturnType = 0;
   pANTLR3_BASE_TREE cc;
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      Child = p->getChild(p, ChildIx);
      if (Child->getToken == NULL) {
         printf("Error: getToken null\n");
         return;
      }

      /* get data of child */      
      Token = Child->getToken(Child);                
      TokenType = Child->getType(Child);             

      switch(TokenType) {
         case L_RETURN : {
            Indent(Level);            
            cc = p->getChild(Child, 0);
            printf(" %s // return type\n", VarTypeString(cc->getType(cc)));
            GotReturnType = 1;
            break;
         }
         case IDENTIFIER : {
            Indent(Level);    
            if (!GotReturnType) printf("void ");        
            printf(" %s ( // proc/func name\n", Child->toString(Child)->chars);
            break;
         }
         case PARAMS : {
            Indent(Level);             
            CgParams(Child, Level+1);
            printf("// param,\n", Child->toString(Child)->chars);
            break;
         }
         case BODY : {
            Indent(Level);            
            printf(") { // body\n");
            CgStatements(Child, 0, Level+1);
            Indent(Level);            
            printf("} // end body\n");
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", Child);
            break;
         }
      }
   }
} 
 
//-----------------------------------------------------------------------------
// CgForever - 
//-----------------------------------------------------------------------------
// A forever node has only one child that contains the content of the loop
//-----------------------------------------------------------------------------
void CgForever(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgForever";
   CG_HEADER_NO_STARTIX  // declare vars, print debug, get n, Token and TokenType of 'p'
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      Child = p->getChild(p, ChildIx);
      if (Child->getToken == NULL) {
         printf("Error: getToken null\n");
         return;
      }

      /* get data of child */      
      Token = Child->getToken(Child);                
      TokenType = Child->getType(Child);             

      switch(TokenType) {
         case L_LOOP : {
            Indent(Level);            
            printf(" for (;;) {\n");
            CgStatements(Child, 0, Level+1);
            Indent(Level);            
            printf("}\n");
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", Child);
            break;
         }
      }
   }                
}

#define PASS1 if ((Level == 1) & (Pass != 1)) break;
#define PASS2 if ((Level == 1) & (Pass != 2)) break;
   
//-----------------------------------------------------------------------------
// CgStatement - Generate code for this single statement
//-----------------------------------------------------------------------------   
// This function is the main dispath.
//-----------------------------------------------------------------------------
void CgStatement(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgStatement";
   CG_HEADER_NO_STARTIX  // declare vars, print debug, get n, Token and TokenType of 'p'
       
   Indent(Level);            
   printf("// %s (%d, %s)\n",p->toString(p)->chars, TokenType, jalParserTokenNames[TokenType]);   

   switch(TokenType) {
      case L_BLOCK : {
         PASS2;
         Indent(Level);            
         printf("{ // start of block \n"); 
         CgStatements(p, 0, Level+1); // process nodes of child            
         Indent(Level);            
         printf("} // end of block \n"); 
         break;   
      }
      case L_FOR : {
         PASS2;
         CgFor(p, Level+1); // process nodes of child            
         break;   
      }
      case L_FOREVER : {
         PASS2;
         CgForever(p, Level+1); // process nodes of child            
         break;   
      }
      case L_VAR : {
         PASS1;
         CgVar(p, Level+1); // process nodes of child            
         break;   
      }
      case L_FUNCTION  : 
      case L_PROCEDURE : {
         PASS1;
         CgProcedureDef(p, Level+1); // process nodes of child            
         break;   
      }
      case ASSIGN : {
         PASS2;
         CgAssign(p, Level+1); // process nodes of child            
         Indent(Level);            
         printf("; // end of assign \n");
         break;   
      }
      case FUNC_PROC_CALL : {
         PASS2;
         CgFuncProcCall(p, Level+1); // process nodes of child            
         break;   
      }
      case J2C_COMMENT : {
         PASS2;
         Indent(Level);            
         printf(" %s\n", p->toString(p)->chars + 5 ); // c statement
         break;   
      }
      
   }

//      printf("%s\n",child->toString(child)->chars);  
//      if (ChildCount > 0) {
//         CgStatement(Child, 0, Level+1);   
//      }

}


//-----------------------------------------------------------------------------
// CgStatements - process subnodes with statements.
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CgStatements(pANTLR3_BASE_TREE p, int StartIx, int Level)
{  ANTLR3_UINT32   n, ChildIx;
   pANTLR3_BASE_TREE   Child;
   pANTLR3_COMMON_TOKEN Token;
   ANTLR3_UINT32 TokenType;
      
	if  ((p->isNilNode(p) == ANTLR3_TRUE) & (Level != 0)) {
	   printf("Error: nil-node %d\n", Level);
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
         return;
      }
      CgStatement(Child, Level+1);
   }
}

//-----------------------------------------------------------------------------
// CodeGenerate -
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CodeGenerate(pANTLR3_BASE_TREE p)
{  int Level;
   
   printf("// Jal -> C code converter\n");                       
   printf("#include <stdio.h>\n\n");                       

   Pass = 1;   // generate functions, global vars etc.
   Level = 0;
	if  (p->isNilNode(p) == ANTLR3_TRUE) { 
	   // a nill-node at root level means there are multiple statements to be processed
      CgStatements(p, 0, Level); // Proces childs of p,  start at child 0
	} else {
	   // the root node is a statement itself (this means we have a program with only
	   // one statement. Not common in a real program, but possible and usefull while testing).
      CgStatement(p, Level); // process statement of node p
   }      
   

   Pass = 2;   // generate main function
   Level = 0;
   printf("int main(int argc, int **argv) {\n");                       

	if  (p->isNilNode(p) == ANTLR3_TRUE) { 
      CgStatements(p, 0, Level); // Proces childs of p,  start at child 0
	} else {
      CgStatement(p, Level); // process statement of node p
   }      
   printf("} // end of main\n"); 
   printf("// Jal -> C END\n\n"); 
}
