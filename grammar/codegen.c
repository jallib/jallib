// codegen.c

#include <stdio.h>

// antlr generate
#include    "jalLexer.h"
#include    "jalParser.h"

//extern pANTLR3_UINT8   jalParserTokenNames[];
#include "symboltable.h"



// Pass 1 collects all global variables and all function/procedure defs
// Pass 2 collects the rest, all 'loose' code and puts it into main.
static int Pass;

// my prototypes
void CodeGenerate(pANTLR3_BASE_TREE p);
void CgStatements(pANTLR3_BASE_TREE p, int Level);
void CgFuncProcCall(pANTLR3_BASE_TREE p, int Level);
void CgStatement(pANTLR3_BASE_TREE p, int Level);


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// code blocks
//-----------------------------------------------------------------------------
// Many functions start alike, so below are code blocks to help on this.
// - Functions called without StartIx process the node passed (and all of its 
//   subnodes, of course). There is no return value.
//-----------------------------------------------------------------------------

#define CODE_GENERATOR_FUNCT_HEADER                               \
   ANTLR3_UINT32   n, ChildIx, TokenType;                         \
   pANTLR3_BASE_TREE   c;  /* child (assigned below) */           \
   pANTLR3_BASE_TREE   cc; /* 'child of child (not assigned!) */  \
   pANTLR3_COMMON_TOKEN Token;                                    \
   Indent(Level);                                                 \
   printf("// %s\n", ThisFuncName);                               \
                                                                  \
   n = p->getChildCount(p);                                       \
                                                                  \
   /* get data of supplied node */                                \
   Token = p->getToken(p);                                        \
   TokenType = p->getType(p);                                     \
                                                                  
#define CODE_GENERATOR_GET_CHILD_INFO           \
      c = p->getChild(p, ChildIx);              \
      if (c->getToken == NULL) {                \
         printf("Error: getToken null\n");      \
         return;                                \
      }                                         \
                                                \
      /* get data of child */                   \
      Token = c->getToken(c);                   \
      TokenType = c->getType(c);                \



#define REPORT_NODE(string, node) {                   \
   Indent(Level);                                     \
   printf("// %s %s %s (%d, %s)\n",                   \
         ThisFuncName, string,                        \
         node->toString(node)->chars,                 \
         node->getType(node),                         \
         jalParserTokenNames[TokenType]);             \
}                                                     \

#define PASS1 if ((Level == 1) & (Pass != 1)) break;
#define PASS2 if ((Level == 1) & (Pass != 2)) break;


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// end of code blocks
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

char *VarTypeString(int TokenType)
{
   switch(TokenType) {
      case L_BYTE    : { return "uint8_t";            }
      case L_SBYTE   : { return "int8_t";             }
      case L_WORD    : { return "uint16_t";           }
      case L_SWORD   : { return "int8_t";             }
      case L_DWORD   : { return "uint32_t";           }
      case L_SDWORD  : { return "int32_t";            }
      default        : { return "unexpected token";   }
   }
}

//-----------------------------------------------------------------------------
// GetUniqueIdentifier - Creates an Identifier with unique number
//-----------------------------------------------------------------------------
// return: pointer to (allocated) memory containing string.
//-----------------------------------------------------------------------------
char *GetUniqueIdentifier()
{  static int UniqueIdentCounter = 0;          
   
   char *Ident = malloc(10);
   sprintf(Ident, "I%04d", UniqueIdentCounter++);
   
   return Ident;
}
               
//-----------------------------------------------------------------------------
// CgExpression - Generate code for an Expression node
//-----------------------------------------------------------------------------
// an expression is a node with an operation, with two
// subnodes, or a single node with a value or identifier. 
//-----------------------------------------------------------------------------
int CgExpression(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgExpression";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
       
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
            printf(")%s( // expression\n", p->toString(p)->chars);
            CgExpression(p->getChild(p, 1), Level + 1);
            Indent(Level);            
            printf(") // end subexpr\n");
         } else {
            printf("%s Error: not two subnodes\n", ThisFuncName);
         }
         break;

      case FUNC_PROC_CALL :
         CgFuncProcCall(p, Level+1);
         break;

      default :
         printf("// %s unknown token %s type %d %s\n", ThisFuncName, p->toString(p)->chars, TokenType, jalParserTokenNames[TokenType]);
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
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   // first node is identifier to assign to. 
   ChildIx = 0;
   CODE_GENERATOR_GET_CHILD_INFO
   
   if (TokenType == IDENTIFIER) {   
      Indent(Level);            
      printf("%s  = // %s identifier\n", c->toString(c)->chars, ThisFuncName);
   } else {
      printf("%s error: token %s \n", ThisFuncName, c->toString(c)->chars);
   }                
   
   // second node is expr
   c = p->getChild(p, 1);  

   CgExpression(c, Level + 1);      
} 

//-----------------------------------------------------------------------------
// CgCaseValue - 
//-----------------------------------------------------------------------------
// A CASE node has child 
//-----------------------------------------------------------------------------
void CgCaseValue(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgCaseValue";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case CONDITION : {
            Indent(Level);  
            printf("case ");
            CgExpression(c->getChild(c, 0), Level+1);
            Indent(Level);  
            printf(" : // case_condition \n");
            break;
         }
         case BODY : {
            Indent(Level);  
            printf("{ // case body\n");
            cc = p->getChild(c, 0);
            CgStatement(cc, Level+1);
            Indent(Level);  
            printf("break; } // case body\n");
            break;  
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }                
}                   

//-----------------------------------------------------------------------------
// CgCase - 
//-----------------------------------------------------------------------------
// A CASE_VALUE node has childs
//-----------------------------------------------------------------------------
void CgCase(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgCase";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case CONDITION : {
            Indent(Level);   
            printf("switch( // case\n");         
            CgExpression(c->getChild(c, 0), Level+1);
            Indent(Level);            
            printf(") { // case\n");         
            break;
         }
         case CASE_VALUE : {
            CgCaseValue(c, Level+1);
            break;  
         }
         case L_OTHERWISE : {  
            Indent(Level);   
            printf("default : { // case\n");                     
            cc = c->getChild(c, 0);
            CgStatement(cc, Level+1);   
            Indent(Level);  
            printf("break; } // case body\n");            
            break;  
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }                
   Indent(Level);            
   printf("} // case\n");         
}

//-----------------------------------------------------------------------------
// CgFor - 
//-----------------------------------------------------------------------------
// A for node has child for it's options and one loop child that contains the
// content of the loop
//-----------------------------------------------------------------------------
void CgFor(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgFor";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   char *Ident = NULL;
     
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case L_USING : {  
            cc = p->getChild(c, 0);
            Ident = cc->toString(cc)->chars;         
            printf("// Using var %s\n", Ident);
            break;
         }
         case CONDITION : {
            if (Ident == NULL) {
               Ident = GetUniqueIdentifier();   
               printf("unsigned char %s;\n", Ident);
            } 
            Indent(Level);            
            printf(" for (%s=0;%s<\n", Ident, Ident);
            CgExpression(c->getChild(c, 0), Level+1);
            Indent(Level);            
            printf(";%s++) // End of for condition\n", Ident);
            break;
         }
         case BODY : {
            Indent(Level);            
            printf("{ // for body\n");
            CgStatements(c, Level+1);
            Indent(Level);            
            printf("} // for body\n");
//            GotBody = 1;
            break;  
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }                
}
      
//-----------------------------------------------------------------------------
// CgWhile - 
//-----------------------------------------------------------------------------
// A WHILE node has child CONDITION and child BODY
//-----------------------------------------------------------------------------
void CgWhile(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgWhile";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      c = p->getChild(p, ChildIx);
      if (c->getToken == NULL) {
         printf("Error: getToken null\n");
         return;
      }

      /* get data of child */      
      Token = c->getToken(c);                
      TokenType = c->getType(c);             

      switch(TokenType) {
         case CONDITION : {
            Indent(Level);            
            printf(" while ( // condition start\n");
            CgExpression(c->getChild(c,0), Level+1);
            Indent(Level);            
            printf(") \n // while condition end\n");
            break;
         }
         case BODY : {
            Indent(Level);            
            printf("{ // while body\n");
            CgStatements(c, Level+1);
            Indent(Level);            
            printf("} // while body\n");
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   } 
}

//-----------------------------------------------------------------------------
// CgRepeat - 
//-----------------------------------------------------------------------------
// A CgRepeat node has child CONDITION and child BODY
//-----------------------------------------------------------------------------
void CgRepeat(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgRepeat";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case BODY : {
            Indent(Level);            
            printf("do { // repeat body\n");
            CgStatements(c, Level+1);
            Indent(Level);            
            printf("} // repeat body\n");
            break;
         }       
         case CONDITION : {
            Indent(Level);            
            printf(" while ( // repeat condition start\n");
            CgExpression(c->getChild(c,0), Level+1);
            Indent(Level);            
            printf("); \n // repeat condition end\n");
            break;
         }         
         default: {            
            REPORT_NODE("unexpected token", c);
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
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   int GotFirstParam = 0;
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      if (ChildIx == 0) {
         // function/procedure name
         Indent(Level);            
         printf(" %s(\n", c->toString(c)->chars);         
         continue;
      }
      
      if (GotFirstParam) printf(",");
      GotFirstParam = 1;
      
      CgExpression(c, Level + 1);      
   }                
   Indent(Level);            
   printf("); // end of proc/func call\n");
}
 
//-----------------------------------------------------------------------------
// CgSingleVar - 
//-----------------------------------------------------------------------------
// A SingleVar node has child for it's name and for its options
// (AT, IS, {}, ASSIGN)
//-----------------------------------------------------------------------------
void CgSingleVar(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgSingleVar";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO
      
      switch(TokenType) {
         case IDENTIFIER : {
            Indent(Level);            
            printf(" %s \n", c->toString(c)->chars);
            break;
         }
         case ASSIGN : {
            Indent(Level);            
            printf("= // assign\n");
            cc = c->getChild(c, 0);
            CgExpression(cc, Level+1);
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }
   Indent(Level);                           
} 

//-----------------------------------------------------------------------------
// CgVar - 
//-----------------------------------------------------------------------------
// A var node has child for it's options and a VAR node for each
// identifier (single var)
//-----------------------------------------------------------------------------
void CgVar(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgVar";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   int GotFirstSingleVar = 0;
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO
      
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
         case VAR : {
            Indent(Level);            
            if (GotFirstSingleVar) printf(", ");
            CgSingleVar(c, Level + 1);
            GotFirstSingleVar = 1;
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }
   Indent(Level);            
   printf(";\n");                
}        

//-----------------------------------------------------------------------------
// CgConst - 
//-----------------------------------------------------------------------------
// A CONST node has child for it's options and a VAR node for each
// identifier (single var)
//-----------------------------------------------------------------------------
void CgConst(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgConst";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   int GotType = 0;
   int GotFirstSingleVar = 0;
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO
      
      switch(TokenType) {
         case L_BYTE   : 
         case L_SBYTE  : 
         case L_WORD   : 
         case L_SWORD  : 
         case L_DWORD  : 
         case L_SDWORD : {
            Indent(Level);            
            printf(" const %s \n", VarTypeString(TokenType));
            GotType = 1;
            break;
         }
         case VAR : {   
            if (GotType == 0) {
               Indent(Level);            
               printf(" const long // default const type\n");
               GotType = 1;        
            }
            Indent(Level);            
            if (GotFirstSingleVar) printf(", ");
            CgSingleVar(c, Level + 1);
            GotFirstSingleVar = 1;
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
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
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
          
   
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case L_IN : {
            break;
         }
         case L_OUT : {
            SymbolTail->Param[SymbolTail->NrOfParams-1].IsReference = 1;
            break;
         }
         case IDENTIFIER : {
            Indent(Level);            
            printf(" %s \n", c->toString(c)->chars);  
            strcpy(SymbolTail->Param[(SymbolTail->NrOfParams)-1].Name, c->toString(c)->chars);
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }
} 

//-----------------------------------------------------------------------------
// CgParams - process params of procedure / function definition or prototype
//-----------------------------------------------------------------------------
// A Param node
//-----------------------------------------------------------------------------
void CgParams(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgParams";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'


   int GotFirstParam = 0;

   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

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
            printf(" %s // %d\n", VarTypeString(TokenType), TokenType); 
            printf("// set ParamType\n");

            // add new parameter to current symbol
            SymbolTail->NrOfParams ++;
            SymbolTail->Param[SymbolTail->NrOfParams-1].Type = TokenType;

            CgParamChilds(c, Level+1);
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
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
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   int GotReturnType = 0;
   int GotBody = 0;

   AddSymbol(); // ignore pointer, use SymbolTail
      
   for (ChildIx = 0; ChildIx<n; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case L_RETURN : {
            Indent(Level);            
            cc = p->getChild(c, 0);
            printf(" %s // return type\n", VarTypeString(cc->getType(cc)));
            SymbolTail->ReturnType = cc->getType(cc); // add to symbol table.
            GotReturnType = 1;
            break;
         }
         case IDENTIFIER : {
            Indent(Level);    
            if (!GotReturnType) printf("void ");        
            printf(" %s ( // proc/func name\n", c->toString(c)->chars);
            strcpy(SymbolTail->Name, c->toString(c)->chars); // add to symbol table.
            break;
         }
         case PARAMS : {
            Indent(Level);             
            CgParams(c, Level+1);
            printf("// param,\n", c->toString(c)->chars);
            break;
         }
         case BODY : {
            Indent(Level);            
            printf(") { // body\n");
            CgStatements(c, Level+1);
            Indent(Level);            
            printf("} // end body\n");
            GotBody = 1;
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }
   if (!GotBody) {
      printf("); // Add closing parenthesis + semicolon of prototype\n");
   }
} 

//-----------------------------------------------------------------------------
// CgIf - 
//-----------------------------------------------------------------------------
// A procedure def node
//-----------------------------------------------------------------------------
void CgIf(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgIf";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   int GotBody = 0;

      Indent(Level);
   switch (TokenType) {
      case L_IF   :  printf("if        // %s\n", ThisFuncName);    
         break;
      case L_ELSIF : printf("else if   // %s\n", ThisFuncName);    
         break;
      case L_ELSE :  printf("else      // %s\n", ThisFuncName);    
         break;
      default     :  REPORT_NODE("unexpected token", p);
         break;
   }
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case CONDITION : {
            Indent(Level);            
            printf("( // condition\n");
            CgExpression(c->getChild(c, 0), Level+1);
            Indent(Level);            
            printf(") // end condition\n");
            GotBody = 1;
            break;
         }
         case BODY : {
            Indent(Level);            
            printf("{ // body\n");
            CgStatements(c, Level+1);
            Indent(Level);            
            printf("} // end body\n");
            GotBody = 1;
            break;
         }
         case L_ELSE: 
         case L_ELSIF : {
            Indent(Level);            
            printf("  // else / elsif\n");
            CgIf(c, Level+1);
            GotBody = 1;
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }
   if (!GotBody) {
      printf("); // Add closing parenthesis + semicolon of if\n");
   }
} 
 
//-----------------------------------------------------------------------------
// CgForever - 
//-----------------------------------------------------------------------------
// A forever node has only one child that contains the content of the loop
//-----------------------------------------------------------------------------
void CgForever(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgForever";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case BODY : {
            Indent(Level);            
            printf(" for (;;) {\n");
            CgStatements(c, Level+1);
            Indent(Level);            
            printf("}\n");
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }                
}
   
//-----------------------------------------------------------------------------
// CgStatement - Generate code for this single statement
//-----------------------------------------------------------------------------   
// This function is the main dispath.
//-----------------------------------------------------------------------------
void CgStatement(pANTLR3_BASE_TREE p, int Level)
{  char *ThisFuncName = "CgStatement";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
       
   Indent(Level);            
   printf("// %s (%d, %s)\n",p->toString(p)->chars, TokenType, jalParserTokenNames[TokenType]);   

   switch(TokenType) {
      case L_BLOCK : {
         PASS2;
         Indent(Level);            
         printf("{ // start of block \n"); 
         CgStatements(p, Level+1);             
         Indent(Level);            
         printf("} // end of block \n"); 
         break;   
      }
      case L_CASE : {
         PASS2;
         CgCase(p, Level+1);           
         break;   
      }
      case L_IF : {
         PASS2;
         CgIf(p, Level+1);           
         break;   
      }
      case L_FOR : {
         PASS2;
         CgFor(p, Level+1);           
         break;   
      }                
      case L_REPEAT : {
         PASS2;
         CgRepeat(p, Level+1);           
         break;   
      }                      
      case L_EXIT : {
         PASS2;
         Indent(Level);
         printf("break; // exit\n");
         break;   
      }
      case L_FOREVER : {
         PASS2;
         CgForever(p, Level+1);             
         break;   
      }
      case L_VAR : {
         PASS1;
         CgVar(p, Level+1);             
         break;   
      }
      case L_CONST : {
         PASS1;
         CgConst(p, Level+1);             
         break;   
      }
      case L_FUNCTION  : 
      case L_PROCEDURE : {
         PASS1;
         CgProcedureDef(p, Level+1);             
         break;   
      }
      case ASSIGN : {
         PASS2;
         CgAssign(p, Level+1);             
         Indent(Level);            
         printf("; // end of assign \n");
         break;   
      }
      case L_RETURN : {
         PASS2;
         Indent(Level);            
         printf("return\n");
         CgExpression(p->getChild(p,0), Level+1);             
         Indent(Level);            
         printf("; // end of return \n");
         break;   
      }
      case FUNC_PROC_CALL : {
         PASS2;
         CgFuncProcCall(p, Level+1);             
         break;   
      }
      case J2C_COMMENT : {
         PASS2;
         Indent(Level);            
         printf(" %s\n", p->toString(p)->chars + 5 ); // c statement
         break;   
      }        
      case L_WHILE : {
         PASS2;
         CgWhile(p, Level+1);             
         break;   
      }
      default: {
         REPORT_NODE("Unsupported statement", p);
         break; 
      }
      
   }
}


//-----------------------------------------------------------------------------
// CgStatements - process subnodes with statements.
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CgStatements(pANTLR3_BASE_TREE p, int Level)
{  ANTLR3_UINT32   n, ChildIx;
   pANTLR3_BASE_TREE   Child;
   pANTLR3_COMMON_TOKEN Token;
   ANTLR3_UINT32 TokenType;
      
	if  ((p->isNilNode(p) == ANTLR3_TRUE) & (Level != 0)) {
	   printf("Error: nil-node %d\n", Level);
	   return;
	}
   
   n = p->getChildCount(p);
   
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
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
   
   printf("\n\n// Jal -> C code converter\n");                       
   printf("#include <stdio.h>\n\n");                       
   printf("#include <stdint.h>\n\n");                       

   Pass = 1;   // generate functions, global vars etc.
   Level = 0;
	if  (p->isNilNode(p) == ANTLR3_TRUE) { 
	   // a nill-node at root level means there are multiple statements to be processed
      CgStatements(p, Level); // Proces childs of p,  start at child 0
	} else {
	   // the root node is a statement itself (this means we have a program with only
	   // one statement. Not common in a real program, but possible and usefull while testing).
      CgStatement(p, Level); // process statement of node p
   }      
   
   Pass = 2;   // generate main function
   Level = 0;
   printf("int main(int argc, char **argv) {\n");                       

	if  (p->isNilNode(p) == ANTLR3_TRUE) { 
      CgStatements(p, Level); // Proces childs of p,  start at child 0
	} else {
      CgStatement(p, Level); // process statement of node p
   }      
   printf("} // end of main\n"); 
   printf("// Jal -> C END\n\n"); 
}
