//-----------------------------------------------------------------------------
// codegen.c
//-----------------------------------------------------------------------------
#include "jat.h"


//#include <stdio.h>
//
//// antlr generate
//#include    "jalLexer.h"
//#include    "jalParser.h"
//
////extern pANTLR3_UINT8   jalParserTokenNames[];
//#include "symboltable.h"

SymbolFunction *ActiveProcedureDefintion = NULL; // used for dereferencing procedure params within procedure body

// Pass 1 collects global variables, constants and function/procedure defs
// Pass 2 collects the rest, all 'loose' code and puts it into main.
static int Pass;



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
   if (Verbose) {                                                 \
      Indent(Level);                                              \
      printf("// %s", ThisFuncName);                            \
   }                                                              \
   n = t->getChildCount(t);                                       \
                                                                  \
   /* get data of supplied node */                                \
   Token = t->getToken(t);                                        \
   TokenType = t->getType(t);                                     \
                                                                  
#define CODE_GENERATOR_GET_CHILD_INFO           \
      c = t->getChild(t, ChildIx);              \
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

//-----------------------------------------------------------------------------
// Indent - print indent for screen dump / treewalk
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void Indent(int Level)
{   int i;
//   Level += 2;   
                
   if ((Pass == 1) && (Level > 0)) Level --;
   printf("\n");   
   for (i=0; i<Level; i++) printf("   ");
}                                 

//-----------------------------------------------------------------------------
// PrintJ2cString - print from second word
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void PrintJ2cString(char *String)
{  char *s = String;
    
   // find first whitespace
   while ((*s != ' ') && (*s != '\t')){
      if (*s == 0) {
         printf("PrintJ2cString error (%s)\n", String);
         return;
      }
      s++;   
   } 
   
   // find first non-whitespace
   while ((*s == ' ') || (*s == '\t')){
      if (*s == 0) {
         printf("PrintJ2cString error (%s)\n", String);
         return;
      }
      s++;   
   } 
   
   printf("%s", s);   
}




char *VarTypeString(int TokenType)
{
   switch(TokenType) {
      case L_VOID    : { return "void";               }
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
// GetCallMethod - Return CallMethtod if this is a proc/func param, else 0
//-----------------------------------------------------------------------------
// This function is used within a procedure body to determine if an
// identifier is a parameter of this procedure and - if  so - what method
// is used when calling.
//
// 0 = not found, else value of CallMethod (Value, Reference, Code)
//-----------------------------------------------------------------------------
char GetCallMethod(char *ParamName)
{  SymbolFunction *f; 
   SymbolParam *p;
   int i;
   
   if (ActiveProcedureDefintion == NULL) return 0;      
   f = ActiveProcedureDefintion; // use short name...
    
    
   for (p = f->Param; p != NULL; p=p->next) {
//      printf("// Check %s\n", s->Param[i].Name);           
      if (strcmp(ParamName, p->Name) == 0) { 
         // match
//         printf("// match %c\n", s->Param[i].CallMethod);           
         return p->CallMethod;
      }
   }   
   return 0;   
}

                    
char DeRefString[100];                    
char *DeRefSub(char *InString, char CallMethod)
{ 
   if (CallMethod == 0) return InString;

   if (CallMethod == 'r') {
      // call by reference, so dereference before use
      sprintf(DeRefString, "*%s", InString);
      return DeRefString;   
   }
   if (CallMethod == 'c') {
      // call by code
      printf("Error: call by code (void, pseudo-vars) not supported, param:");
   }
   return InString;
}


char *DeReference(char *InString)
{  char cm; 

   cm = GetCallMethod(InString);

   return DeRefSub(InString, cm);
}
               
//-----------------------------------------------------------------------------
// CgExpression - Generate code for an Expression node
//-----------------------------------------------------------------------------
// an expression is a node with an operation, with two
// subnodes, or a single node with a value or identifier. 
//-----------------------------------------------------------------------------
int CgExpression(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgExpression";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   Var *v;
       
   switch(TokenType) {
      case IDENTIFIER :

         v= SymbolGetVar(GlobalContext, t->toString(t)->chars);
      
         if ((v) && (v->get != NULL)) {
            // there is a var record.
            // we have a get function, so call to get value
            if (Verbose) Indent(Level);
            printf("%s()", v->get);         
            if (Verbose) printf(" // %s call pseudovar put", ThisFuncName);
         } else {
            if (Verbose) Indent(Level);            
            printf("%s", DeReference(t->toString(t)->chars));
            if (Verbose) printf("// identifier");
         }
         break;
      case DECIMAL_LITERAL :
         if (Verbose) Indent(Level);            
         printf("%s", t->toString(t)->chars);
         if (Verbose) printf("// constant");
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
            if (Verbose) Indent(Level);            
            printf("(");
            if (Verbose) printf(" // start subexpr");
            CgExpression(co, t->getChild(t, 0), Level + 1);
            if (Verbose) Indent(Level);            
            printf(" %s ", t->toString(t)->chars);
            if (Verbose) printf(" // expression");
            CgExpression(co, t->getChild(t, 1), Level + 1);
            if (Verbose) Indent(Level);            
            printf(")");
            if (Verbose) printf(" // end subexpr");
         } else {
            printf("%s Error: not two subnodes\n", ThisFuncName);
         }
         break;

      case FUNC_PROC_CALL :
         CgFuncProcCall(co, t, Level+VLEVEL);
         break;

      default :
         printf("// %s unknown token %s type %d %s\n", ThisFuncName, t->toString(t)->chars, TokenType, jalParserTokenNames[TokenType]);
         break;      
   }
}

//-----------------------------------------------------------------------------
// CgAssign - Generate code for an assign node and it's subnodes
//-----------------------------------------------------------------------------
// an assignment is a node with an operation, with two
// subnodes, the target identifier and an expression. 
//-----------------------------------------------------------------------------
void CgAssign(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgAssign";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   Var *v;

   // first node is identifier to assign to. 
   ChildIx = 0;
   CODE_GENERATOR_GET_CHILD_INFO
   
   if (TokenType != IDENTIFIER) {   
      printf("%s error: token %s \n", ThisFuncName, c->toString(c)->chars);
      return;
   }                
          
   v= SymbolGetVar(GlobalContext, c->toString(c)->chars);

   if (v) {
      // there is a var record.
      if (v->put != NULL) {
         // we have a put function, so call in stead of assing
         Indent(Level);
         printf("%s(", v->put);         
         if (Verbose) printf(" // %s call pseudovar put", ThisFuncName);

         // second node is expr
         c = t->getChild(t, 1);  
         CgExpression(co, c, Level + 1);      

         if (Verbose) Indent(Level);
         printf(")");
         if (Verbose) printf(" // %s var__put call", ThisFuncName);
                                 
         return;
      }
   }
   // normal var
   Indent(Level);  // this one always!
   printf("%s  = ", DeReference(c->toString(c)->chars));
   if (Verbose) printf(" // %s identifier", ThisFuncName);

   // second node is expr
   c = t->getChild(t, 1);  
   CgExpression(co, c, Level + 1);      

} 

//-----------------------------------------------------------------------------
// CgCaseValue - 
//-----------------------------------------------------------------------------
// A CASE node has child 
//-----------------------------------------------------------------------------
void CgCaseValue(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgCaseValue";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case CONDITION : {
            Indent(Level);  
            printf("case ");
            CgExpression(co, c->getChild(c, 0), Level+VLEVEL);
            if (Verbose) Indent(Level);  
            printf(" : ");
            if (Verbose) printf("// case_condition");
            break;
         }
         case BODY : {
            Indent(Level);  
            printf("{ ");
            Level ++;
            Indent(Level);  
            if (Verbose) printf("// start case body");
            cc = c->getChild(c, 0);
            CgStatement(co, cc, Level+1); // real level
            Indent(Level);  
            printf("break;\n");
            Level --;
            Indent(Level);  
            printf("} ");
            if (Verbose) printf("// end case body");
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
void CgCase(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgCase";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case CONDITION : {
            Indent(Level);   
            printf("switch( // case\n");         
            CgExpression(co, c->getChild(c, 0), Level+VLEVEL);
            Indent(Level);            
            printf(") { // case\n");         
            break;
         }
         case CASE_VALUE : {
            CgCaseValue(co, c, Level+VLEVEL);
            break;  
         }
         case L_OTHERWISE : {  
            Indent(Level);   
            printf("default : { // case\n");                     
            cc = c->getChild(c, 0);
            CgStatement(co, cc, Level+1); //real level   
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
void CgFor(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgFor";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   char *Ident = NULL;
     
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case L_USING : {  
            cc = c->getChild(c, 0);
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
            CgExpression(co, c->getChild(c, 0), Level+VLEVEL);
            Indent(Level);            
            printf(";%s++) // End of for condition\n", Ident);
            break;
         }
         case BODY : {
            Indent(Level);            
            printf("{ // for body\n");
            CgStatements(co, c, Level+1); // real level
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
void CgWhile(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgWhile";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      c = t->getChild(t, ChildIx);
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
            CgExpression(co, c->getChild(c,0), Level+VLEVEL);
            Indent(Level);            
            printf(") \n // while condition end\n");
            break;
         }
         case BODY : {
            Indent(Level);            
            printf("{ // while body\n");
            CgStatements(co, c, Level+1); // real level
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
void CgRepeat(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgRepeat";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case BODY : {
            Indent(Level);            
            printf("do { // repeat body\n");
            CgStatements(co, c, Level+1); // real level
            Indent(Level);            
            printf("} // repeat body\n");
            break;
         }       
         case CONDITION : {
            Indent(Level);            
            printf(" while ( // repeat condition start\n");
            CgExpression(co, c->getChild(c,0), Level+VLEVEL);
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
void CgFuncProcCall(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgFuncProcCall";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   int GotFirstParam = 0;
   Symbol      *s = NULL;
   SymbolFunction  *f = NULL;
   SymbolParam *p = NULL;
   
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      if (ChildIx == 0) {
         // function/procedure name
         if (Verbose) Indent(Level); 
         printf(" %s(", c->toString(c)->chars);         
         s = GetSymbolPointer(GlobalContext, c->toString(c)->chars);
         if (s != NULL) {
            if (Verbose > 1) printf("// CgFuncProcCall s: %x\n", s);
            f = (SymbolFunction *) s->details;
            if (Verbose > 1) printf("// CgFuncProcCall f: %x\n", f);
            p =                f->Param;
            if (Verbose > 1) printf("// CgFuncProcCall p: %x\n", p);
         } else {
            p = NULL;
         }
         continue;
      }
      
      if (GotFirstParam) printf(",");
      GotFirstParam = 1;

      if ((p != NULL) && (p->CallMethod == 'r')) {
         if (Verbose > 1) printf("// call by reference\n"); 
         // call by reference
         if (TokenType == IDENTIFIER) {
            if (Verbose) Indent(Level);            
            printf("&%s ", DeReference(c->toString(c)->chars));
            if (Verbose) printf("// identifier by reference");
         } else {
            printf("Error: can't use this parameter to call by reference.\n");
         }         
      } else {
         if (Verbose > 1) printf("// call by value\n");
         // call by value
         CgExpression(co, c, Level + 1);      
      }              
      
      // note: p can be zero if the function name is unknown (in other words,
      // we don't have a prototype) or when we run out of parameters.
      // In both cases the (remaining) parameters are concidered pass by value.
      if (p != NULL) p = p->next;
   }                
   if (Verbose) Indent(Level);            
   printf(")");
   if (Verbose) printf(" // end of proc/func call");
}
 
//-----------------------------------------------------------------------------
// CgSingleVar - 
//-----------------------------------------------------------------------------
// A SingleVar node has child for it's name and for its options
// (AT, IS, {}, ASSIGN)
//-----------------------------------------------------------------------------
void CgSingleVar(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgSingleVar";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO
      
      switch(TokenType) {
         case IDENTIFIER : {
            if (Verbose) Indent(Level);            
            printf(" %s ", c->toString(c)->chars);       
//printf("\n// %d\n", Level);
//            if (Level == 3) { // this is a tricky one; indent may change...
//               printf("CgSingleVar p1\n");
//               // add var to store.
//               SymbolVarAdd_DataName(GlobalContext, c->toString(c)->chars, c->toString(c)->chars);   
//               printf("CgSingleVar p2\n");

               // add var to context.
               SymbolVarAdd_DataName(co, c->toString(c)->chars, c->toString(c)->chars);   
//               printf("CgSingleVar p2\n");
//            }
            break;
         }
         case ASSIGN : {
            if (Verbose) Indent(Level);            
            printf("= ");
            if (Verbose) printf("// assign");
            cc = c->getChild(c, 0);
            CgExpression(co, cc, Level+VLEVEL);
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }
   if (Verbose) Indent(Level);                           
} 

//-----------------------------------------------------------------------------
// CgVar - 
//-----------------------------------------------------------------------------
// A var node has child for it's options and a VAR node for each
// identifier (single var)
//-----------------------------------------------------------------------------
void CgVar(Context *co, pANTLR3_BASE_TREE t, int Level)
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
            printf("%s ", VarTypeString(TokenType));
            break;
         }
         case VAR : {
            if (Verbose) Indent(Level);            
            if (GotFirstSingleVar) {
               printf(", ");           
               Indent(Level);
            }
            CgSingleVar(co, c, Level + 1);
            GotFirstSingleVar = 1;
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }
   if (Verbose) Indent(Level);            
   printf(";");                
}        

//-----------------------------------------------------------------------------
// CgConst - 
//-----------------------------------------------------------------------------
// A CONST node has child for it's options and a VAR node for each
// identifier (single var)
//-----------------------------------------------------------------------------
void CgConst(Context *co, pANTLR3_BASE_TREE t, int Level)
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
            printf("const %s ", VarTypeString(TokenType));
            GotType = 1;
            break;
         }
         case VAR : {   
            if (Verbose) Indent(Level);            
            if (GotType == 0) {
               printf(" const long");
               if (Verbose) printf(" // default const type\n");
               GotType = 1;        
            }
            if (GotFirstSingleVar) printf(", ");
            CgSingleVar(co, c, Level + 1);
            GotFirstSingleVar = 1;
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }
   if (Verbose) Indent(Level);            
   printf(";");                
} 

//-----------------------------------------------------------------------------
// CgParamChilds - 
//-----------------------------------------------------------------------------
// A ParamChilds node
//-----------------------------------------------------------------------------
void CgParamChilds(Context *co, pANTLR3_BASE_TREE t, int Level, SymbolParam *p)
{  char *ThisFuncName = "CgParamChilds";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
          
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case L_IN : {
            break;
         }
         case L_OUT : {                                                 
            if (p->CallMethod != 'c') {  // Call by code
               p->CallMethod = 'r';     // Call by reference
            }
            break;
         }
         case L_VOLATILE : {                                                 
            p->CallMethod = 'c';     // Call by code
            break;
         }
         case L_DATA     : // L_DATA is also identifier
         case IDENTIFIER : {
            if (Verbose) Indent(Level);            
            // store procedure param name
//            strcpy(SymbolTail->Param[(SymbolTail->NrOfParams)-1].Name, c->toString(c)->chars);
            SymbolParamSetName(p, c->toString(c)->chars);
            // deref if called by reference
            printf(" %s ", DeRefSub(c->toString(c)->chars, p->CallMethod));  
            if (Verbose)printf(" // ident");  
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
void CgParams(Context *co, pANTLR3_BASE_TREE t, int Level, SymbolFunction *f)
{  char *ThisFuncName = "CgParams";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'


   int GotFirstParam = 0;

   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      if (GotFirstParam) {           
         if (Verbose) Indent(Level);
         printf(", ");
         if (Verbose) printf("// next param");
      }
      GotFirstParam = 1;

      switch(TokenType) {
         case L_BYTE   : 
         case L_SBYTE  : 
         case L_WORD   : 
         case L_SWORD  : 
         case L_DWORD  : 
         case L_SDWORD : {     
            if (Verbose) Indent(Level);            
            printf("%s", VarTypeString(TokenType)); 
            if (Verbose) printf(" // TokenType: %d (Add param to SymbolTable", TokenType); 

            // add new parameter to current symbol  
            SymbolParam *p = SymbolFunctionAddParam(f, TokenType);

            CgParamChilds(co, c, Level+VLEVEL, p);
            
            // *copy* param info to context
            // (  We could add the pointer to p. But some day, we will free()
            //    the structs when they are not used any more and a pointer to the
            //    actual procedure parameter might free() that too.
            //    So... when cleanup is implemented and some flag is added, copy
            //    can be replaced by th reference.
            // )
            Var *v = SymbolGetOrNewVar(co, p->Name);
            v->Type       = p->Type;
            v->CallMethod = p->CallMethod;

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
//
// For 'put and 'get procedures, there are two relevant records in the 
// symboltable:
// - One is var, that may or may not exist prior to this call. If it does
//   not exist, it is created. In any case, the function name will be 
//   registered as 'put' or 'get' value.                                        
//
// - Next a record is created, as for each function, that describe the 
//   function call. This record holds the function name, which is appended 
//   with __put or __get in the case of put or get.
// 
//-----------------------------------------------------------------------------
void CgProcedureDef(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgProcedureDef";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   // Add level to context
   co = NewContext(co);


   printf("\n"); // empty line before proc/funct def.

   int GotReturnType = 0;
   int GotBody = 0;
   char PvPut = 0;
   char PvGet = 0; 

   
   Symbol *s = NewSymbolFunction(GlobalContext); 
   SymbolFunction *f = s->details;
      
   for (ChildIx = 0; ChildIx<n; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {

         // L_PUT or L_GET are the first childs if they exist. The flags influence further processing.
         case L_PUT : { PvPut = 1; break; }
         case L_GET : { PvGet = 1; break; }

         case L_RETURN : {
            if (PvPut == 0) {
               // normal function return processing
               if (Verbose) Indent(Level);            
               cc = c->getChild(c, 0);
               printf("%s ", VarTypeString(cc->getType(cc)));
               if (Verbose) printf("// return type\n");
               f->ReturnType = cc->getType(cc); // add to symbol table.
               GotReturnType = 1;
            } else {
               // pseudo-var function return processing
               if (Verbose) Indent(Level);            
               cc = c->getChild(c, 0);
               printf("void ");
               if (Verbose) printf(" // PV return type\n"); 
               f->ReturnType = cc->getType(cc); // add to symbol table.
               GotReturnType = 1;
            }
            break;
         }
         case IDENTIFIER : {
            char String[100]; // symbol name length...

            if (Verbose) Indent(Level);    
            if (!GotReturnType) printf("void ");        

            if (strlen(c->toString(c)->chars) > 80) {
               printf("Error: proc/func name %s is too long to handle\n", c->toString(c)->chars);
               exit(1);
            }
            strcpy(String, c->toString(c)->chars);
            if (PvPut) {
               strcat(String, "__put");
               
               SymbolVarAdd_PutName(GlobalContext, c->toString(c)->chars, String);
            }               
            if (PvGet) {
               strcat(String, "__get");
               SymbolVarAdd_GetName(GlobalContext, c->toString(c)->chars, String);
            }               
            
            printf("%s( ", String);
            if (Verbose) printf("// proc/func name");
            s->Name = CreateName(String); // add to symbol table.  
            
            if (PvPut) {  
//               printf("ByCall *__s, ");
//               if (Verbose) printf(" // pvPut stuct");
            }
            if (PvGet) {  
//               printf("ByCall *__s, ");
//               if (Verbose) printf(" // pvGet stuct");
            }
            
            break;
         }
         case PARAMS : {
            CgParams(co, c, Level+VLEVEL, f);
            break;
         }
         case BODY : {
            if (Verbose) Indent(Level);            
            printf(") { \n");         
            if (Verbose) {
               Indent(Level);            
               printf("// start body");         
            }
            
            if (Verbose) DumpContext(co);
            
            ActiveProcedureDefintion = f; // activate dereferencing for relevant parameters.
            CgStatements(co, c, Level+1); // real level!
            ActiveProcedureDefintion = NULL; // deactivate parameter dereferencing.
            Indent(Level);            
            printf("}\n");
            if (Verbose) {
               Indent(Level);            
               printf("// end body");
            }
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
      printf(");\n");      
      if (Verbose) printf("// Add closing parenthesis + semicolon of prototype");      
   }
} 

//-----------------------------------------------------------------------------
// CgIf - 
//-----------------------------------------------------------------------------
// A procedure def node
//-----------------------------------------------------------------------------
void CgIf(Context *co, pANTLR3_BASE_TREE t, int Level)
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
      default     :  REPORT_NODE("unexpected token", t);
         break;
   }
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case CONDITION : {
            Indent(Level);            
            printf("( // condition\n");
            CgExpression(co, c->getChild(c, 0), Level+VLEVEL);
            Indent(Level);            
            printf(") // end condition\n");
            GotBody = 1;
            break;
         }
         case BODY : {
            Indent(Level);            
            printf("{ // body\n");
            CgStatements(co, c, Level+1); // real level
            Indent(Level);            
            printf("} // end body\n");
            GotBody = 1;
            break;
         }
         case L_ELSE: 
         case L_ELSIF : {
            Indent(Level);            
            printf("  // else / elsif\n");
            CgIf(co, c, Level+1); // real level
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
void CgForever(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgForever";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case BODY : {
            Indent(Level);            
            printf(" for (;;) {\n");
            CgStatements(co, c, Level+1); // real level
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
void CgStatement(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgStatement";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
 
   if (Verbose) {      
      Indent(Level);            
      printf("// %s (%d, %s)",t->toString(t)->chars, TokenType, jalParserTokenNames[TokenType]);   
   }
   
   switch(TokenType) {
      case L_BLOCK : {
         PASS2;
         Indent(Level);            
         printf("{\n");
         if (Verbose) printf(" // start of block \n"); 
         CgStatements(co, t, Level+1); // real level             
         printf("\n"); 
         Indent(Level);            
         printf("} \n"); 
         if (Verbose) printf("// end of block \n"); 
         break;   
      }
      case L_CASE : {
         PASS2;
         CgCase(co, t, Level+VLEVEL);           
         break;   
      }
      case L_IF : {
         PASS2;
         CgIf(co, t, Level+VLEVEL);           
         break;   
      }
      case L_FOR : {
         PASS2;
         CgFor(co, t, Level+VLEVEL);           
         break;   
      }                
      case L_REPEAT : {
         PASS2;
         CgRepeat(co, t, Level+VLEVEL);           
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
         CgForever(co, t, Level+VLEVEL);             
         break;   
      }
      case L_VAR : {
         PASS1;
         CgVar(co, t, Level+VLEVEL);             
         break;   
      }
      case L_CONST : {
         PASS1;
         CgConst(co, t, Level+VLEVEL);             
         break;   
      }
      case L_FUNCTION  : 
      case L_PROCEDURE : {
         PASS1;
         CgProcedureDef(co, t, Level+VLEVEL);             
         break;   
      }
      case ASSIGN : {
         PASS2;
         CgAssign(co, t, Level+VLEVEL);             
         if (Verbose) Indent(Level);            
         printf(";\n");
         if (Verbose) printf("// end of assign \n");
         break;   
      }
      case L_RETURN : {
         PASS2;
         Indent(Level);            
         printf("return ");
         if (t->getChildCount(t)) {
            CgExpression(co, t->getChild(t,0), Level+VLEVEL);             
         }
         if (Verbose) Indent(Level);            
         printf(";");
         if (Verbose) printf("// end of return \n");
         break;   
      }
      case FUNC_PROC_CALL : {
         PASS2;
         Indent(Level); 
         CgFuncProcCall(co, t, Level+VLEVEL);      
         if (Verbose) Indent(Level); 
         printf(";");       
         break;    
      }   
      
      // note: j2cg vs j2c is only relevant at root level. 
      // - Code within a function definition, you can use either one and j2c is 
      //   probably the best (less-confusing) choice.
      // - Init code, e.g. a call to init-libs (root-level, so outside a 
      //   function) must use j2c so it gets placed into main()
      // - Global C code (e.g. #include statements, macro's, constant 
      //   definitions used in functions) uses j2cg
      
      case J2CG_COMMENT : {
         PASS1;
         Indent(Level);  
         PrintJ2cString( t->toString(t)->chars); // c statement
         break;   
      }        
      case J2C_COMMENT : {
         PASS2;
         Indent(Level);            
         PrintJ2cString( t->toString(t)->chars); // c statement
         break;   
      }        
      case L_WHILE : {
         PASS2;
         CgWhile(co, t, Level+VLEVEL);             
         break;   
      }
      case INCLUDE_STMT : {    
         // ignore statment
         break;   
      }
      default: {
         REPORT_NODE("Unsupported statement", t);
         break; 
      }
      
   }
}


//-----------------------------------------------------------------------------
// CgStatements - process subnodes with statements.
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CgStatements(Context *co, pANTLR3_BASE_TREE t, int Level)
{  ANTLR3_UINT32   n, ChildIx;
   pANTLR3_BASE_TREE   Child;
   pANTLR3_COMMON_TOKEN Token;
   ANTLR3_UINT32 TokenType;
      
	if  ((t->isNilNode(t) == ANTLR3_TRUE) & (Level != 0)) {
	   printf("Error: nil-node %d\n", Level);
	   return;
	}
   
   n = t->getChildCount(t);
   
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      Child = t->getChild(t, ChildIx);
      if (Child->getToken == NULL) {
         printf("Error: getToken null\n");
         return;
      }                                   
      if (Level == 0) { 
         // To determine which tree to travel in pass1 and pass2, it is
         // required to know if we are at Level=0 or higher. So
         // increment to 1 if we are at level0
         CgStatement(co, Child, Level+1); // real level
      } else {                                
         // Higher level indent are dependent of verbose level.
         CgStatement(co, Child, Level+VLEVEL); 
      }
   }
}

//-----------------------------------------------------------------------------
// CodeGenerate -
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CodeGenerate(pANTLR3_BASE_TREE t)
{  int Level;

   CreateGlobalContext(); 
   
   printf("\n\n//----- JAT code start --------------------------------------------------------\n");                       
   printf("#include <stdio.h>\n");                       
   printf("#include <stdint.h>\n\n");                       
   printf("#include \"jaltarget.h\"\n\n");                       

   Pass = 1;   // generate functions, global vars etc.
   Level = 0;
	if  (t->isNilNode(t) == ANTLR3_TRUE) { 
	   // a nill-node at root level means there are multiple statements to be processed
      CgStatements(GlobalContext, t, Level); // Proces childs of p,  start at child 0
	} else {
	   // the root node is a statement itself (this means we have a program with only
	   // one statement. Not common in a real program, but possible and usefull while testing).
      CgStatement(GlobalContext, t, Level); // process statement of node p
   }      

   SymbolPrintVarTable(GlobalContext);
   
   Pass = 2;   // generate main function
   Level = 0;
   printf("\nint main(int argc, char **argv) {\n");                       

	if  (t->isNilNode(t) == ANTLR3_TRUE) { 
      CgStatements(GlobalContext, t, Level); // Proces childs of p,  start at child 0
	} else {
      CgStatement(GlobalContext, t, Level); // process statement of node p
   }      
   printf("\n} // end of main\n"); 
   printf("//----- JAT code end ----------------------------------------------------------\n\n");
}
