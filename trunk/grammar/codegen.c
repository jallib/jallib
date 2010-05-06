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

// Pass 1 collects global variables, constants and function/procedure defs
// Pass 2 collects the rest, all 'loose' code and puts it into main.
int Pass;
#define PASS1 if ((Level == 1) & (Pass != 1)) break;
#define PASS2 if ((Level == 1) & (Pass != 2)) break;



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
                                                                  \
   CodeIndent(VERBOSE_M,   Level);                                \
   CodeOutput(VERBOSE_M,   "// %s", ThisFuncName);                \
                                                                  \
   n = t->getChildCount(t);                                       \
                                                                  \
   /* get data of supplied node */                                \
   Token = t->getToken(t);                                        \
   TokenType = t->getType(t);                                     \
                                                                  
#define CODE_GENERATOR_GET_CHILD_INFO                             \
      c = t->getChild(t, ChildIx);                                \
      assert (c->getToken != NULL);                               \
                                                                  \
      /* get data of child */                                     \
      Token = c->getToken(c);                                     \
      TokenType = c->getType(c);                                  \



#define REPORT_NODE(string, node) {                               \
   CodeIndent(VERBOSE_ALL, Level);                                \
   CodeOutput(VERBOSE_ALL, "// %s %s %s (%d, %s) from",           \
         ThisFuncName, string,                                    \
         node->toString(node)->chars,                             \
         node->getType(node),                                     \
         jalParserTokenNames[TokenType]);                         \
   CodeOutput(VERBOSE_ALL, "Line %d:%d)\n",                       \
         Token->getLine(Token),                                   \
         Token->getCharPositionInLine(Token));                    \
                                                                  \
}                                                                 \



//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// end of code blocks
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

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
   
   CodeOutput(VERBOSE_ALL, "%s", s);   
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
      default        : { return "unknown_vartype";    }
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
// NO! -> it can be used anywhere and not only finds procedure parameters, but
// also pseudo vars. work in progress.!!!!!!!!!!!!!!!!!
//
// 0 = not found, else value of CallMethod (Value, Reference, Code)
//-----------------------------------------------------------------------------
char GetCallMethod(Context *co, char *ParamName)
{  SymbolFunction *f; 
   SymbolParam *p;
   int i;


   Symbol *s = GetSymbolPointer(co, ParamName, S_VAR, 1); // search for var, include global context for pvars

   if (s == NULL) return 0;   // symbol not found
      
   Var *v = s->details;
   
   if (v->CallMethod == 0) {             
      // found var without call-method (var is not param)

      if ((v->put!= NULL) || (v->get != NULL))  {
         // pseudo var
         v->CallMethod = 'c';
      } else {
         CodeOutput(VERBOSE_ALL, "// We found something, but not clear what...\n");
      }
   }
      
   return v->CallMethod;
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
   Symbol *s;
   char *str;

   switch(TokenType) {
      case IDENTIFIER :

         // lookup indentifier in context
         s = GetSymbolPointer(co, t->toString(t)->chars, S_VAR, 1); // search for var, in local and global context
         v = NULL;
         if (s != NULL) v = s->details;

         if ((v) && (v->get != NULL)) {
            // there is a var record.
            // we have a get function, so call to get value
            CodeIndent(VERBOSE_M,   Level);
            CodeOutput(VERBOSE_ALL, "%s((ByCall *)NULL, (char *)NULL)", v->get);         
            CodeOutput(VERBOSE_M,   " // %s call pseudovar put", ThisFuncName); 
            break;
         } 
            
         if ((v) && (v->CallMethod == 'r')) {
            // a procedure parameter, passed as reference
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "*%s", t->toString(t)->chars);
            CodeOutput(VERBOSE_M,   "// %s identifier - dereferenced param", ThisFuncName);
            break;
         }

         if ((v) && (v->CallMethod == 'c') ) {
            // a procedure parameter, passed by call
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "(%s) ( %s__bc->get ?(*%s__bc->get)(%s__bc, %s__p) : 0)", 
                  VarTypeString(v->Type), t->toString(t)->chars, t->toString(t)->chars, 
                                          t->toString(t)->chars, t->toString(t)->chars);
            CodeOutput(VERBOSE_M,   " // %s identifier - ByCall param", ThisFuncName);
            break;
         }

         // default - call by value, unknown call-methode or unknown identifier
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_ALL, "%s", t->toString(t)->chars);
         CodeOutput(VERBOSE_M,   "// %s identifier (default)", ThisFuncName);   
            
         break;
         
      case DECIMAL_LITERAL :
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_ALL, "%s", t->toString(t)->chars);
         CodeOutput(VERBOSE_M,   "// decimal constant");
         break;

      case CHARACTER_LITERAL : 
      case STRING_LITERAL : 
         str = t->toString(t)->chars;
         if (strlen(str) > 3) {
            CodeOutput(VERBOSE_ALL, "/*Warning: only first char of string used.*/");            
         }
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_ALL, "'%c'", str[1]);
         CodeOutput(VERBOSE_M,   "// character constant");
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
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "(");
            CodeOutput(VERBOSE_M,   " // start subexpr");
            CgExpression(co, t->getChild(t, 0), Level + 1);
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, " %s ", t->toString(t)->chars);
            CodeOutput(VERBOSE_M,   " // expression");
            CgExpression(co, t->getChild(t, 1), Level + 1);
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, ")");
            CodeOutput(VERBOSE_M,   " // end subexpr");
         } else {
            CodeOutput(VERBOSE_ALL, "%s Error: not two subnodes\n", ThisFuncName);
         }
         break;

      case FUNC_PROC_CALL :
         CgProcFuncCall(co, t, Level+VLEVEL);
         break;

      default :
         CodeOutput(VERBOSE_ALL, "// %s unknown token %s type %d %s\n", ThisFuncName, t->toString(t)->chars, TokenType, jalParserTokenNames[TokenType]);
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

   Var *v = NULL;

   // first node is identifier to assign to. 
   ChildIx = 0;
   CODE_GENERATOR_GET_CHILD_INFO
   
   if (TokenType != IDENTIFIER) {   
      printf("%s error: token %s \n", ThisFuncName, c->toString(c)->chars);
      return;
   }                

   // lookup indentifier in context
   Symbol *s = GetSymbolPointer(co, c->toString(c)->chars, S_VAR, 1); // search for var, in local and global context
   if (s != NULL) v= s->details;
                
   if ((v != NULL) && (v->put != NULL)) {
      // we have a put function, so call in stead of assing
      // (this is the use of a global defined put function within an assignment)
      CodeIndent(VERBOSE_ALL, Level);
      CodeOutput(VERBOSE_ALL, "%s((ByCall *)NULL, (char *)NULL,", v->put);         
      CodeOutput(VERBOSE_M,   " // %s call pseudovar put", ThisFuncName);

      // second node is expr
      c = t->getChild(t, 1);  
      CgExpression(co, c, Level + 1);      

      CodeIndent(VERBOSE_M,   Level);
      CodeOutput(VERBOSE_ALL, ")");
      CodeOutput(VERBOSE_M,   " // %s var__put call", ThisFuncName);
                              
      return;
   }
   
   if (v != NULL) {
      switch (v->CallMethod) {
         case 'r' : {
            // call by reference (so it is a procedure parameter)
            CodeIndent(VERBOSE_ALL, Level);  // this one always!
            CodeOutput(VERBOSE_ALL, "*%s = ", c->toString(c)->chars);
            CodeOutput(VERBOSE_M,   " // %s identifier call by reference", ThisFuncName);

            // second node is expr
            c = t->getChild(t, 1);  
            CgExpression(co, c, Level + 1);      

            return;                        
         }
         case 'c' : {
            // call by code (so it is a procedure parameter)
            CodeIndent(VERBOSE_ALL, Level);  // this one always!
            CodeOutput(VERBOSE_ALL, "if (%s__bc->put) (*%s__bc->put)(%s__bc, %s__p, ", 
                  c->toString(c)->chars, c->toString(c)->chars, c->toString(c)->chars, c->toString(c)->chars);
            CodeOutput(VERBOSE_M,   " // %s identifier call by code", ThisFuncName);

            // second node is expr
            c = t->getChild(t, 1);  
            CgExpression(co, c, Level + 1);      
            CodeIndent(VERBOSE_M,   Level);
            CodeOutput(VERBOSE_ALL, ")");
            CodeOutput(VERBOSE_M,   " // %s identifier call by code closure", ThisFuncName);

            return;
         } 
         default : {
            // 'v' or 0 -> call by value
            break;
         }
      }
   }

   
   // 'v' or 0 or not found -> default = call by value
   CodeIndent(VERBOSE_ALL, Level);  // this one always!
   CodeOutput(VERBOSE_ALL, "%s = ", c->toString(c)->chars);
   CodeOutput(VERBOSE_M,   " // %s identifier call by value", ThisFuncName);

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
            CodeIndent(VERBOSE_ALL, Level);  
            CodeOutput(VERBOSE_ALL, "case ");
            CgExpression(co, c->getChild(c, 0), Level+VLEVEL);
            CodeIndent(VERBOSE_M,   Level);  
            CodeOutput(VERBOSE_ALL, " : ");
            CodeOutput(VERBOSE_M,   "// case_condition");
            break;
         }
         case BODY : {
            CodeIndent(VERBOSE_M,   Level);  
            CodeOutput(VERBOSE_ALL, "{ ");
            Level ++;
            CodeIndent(VERBOSE_M,   Level);  
            CodeOutput(VERBOSE_M,   "// start case body");
            cc = c->getChild(c, 0);
            CgStatement(co, cc, Level); // real level, but already raised in code above
            CodeIndent(VERBOSE_ALL, Level);  
            CodeOutput(VERBOSE_ALL, "break;");
            Level --;
            CodeIndent(VERBOSE_ALL, Level);  
            CodeOutput(VERBOSE_ALL, "}");
            CodeOutput(VERBOSE_M,   "// end case body");
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
            CodeIndent(VERBOSE_ALL, Level);   
            CodeOutput(VERBOSE_ALL, "switch(");         
            CodeOutput(VERBOSE_M,   " // case");         
            CgExpression(co, c->getChild(c, 0), Level+VLEVEL);
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, ") {");         
            CodeOutput(VERBOSE_M,   "// case");         
            break;
         }
         case CASE_VALUE : {
            CgCaseValue(co, c, Level+VLEVEL);
            break;  
         }
         case L_OTHERWISE : {  
            CodeIndent(VERBOSE_ALL, Level);   
            CodeOutput(VERBOSE_ALL, "default : {");                     
            CodeOutput(VERBOSE_M,   " // case");                     
            cc = c->getChild(c, 0);
            CgStatement(co, cc, Level+1); //real level   
            CodeIndent(VERBOSE_ALL, Level+1);  
            CodeOutput(VERBOSE_ALL, "break;");            
            CodeIndent(VERBOSE_ALL, Level);  
            CodeOutput(VERBOSE_ALL, "}");            
            CodeOutput(VERBOSE_M,   "// case body");                     
            break;  
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }                
   CodeIndent(VERBOSE_ALL, Level);            
   CodeOutput(VERBOSE_ALL, "}");         
   CodeOutput(VERBOSE_M,   "// case/switch body\n");         
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

   char *LoopVar = NULL;
     
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case L_USING : {  
            cc = c->getChild(c, 0);
            LoopVar = cc->toString(cc)->chars;         
            CodeOutput(VERBOSE_ALL, "// Using var %s\n", LoopVar);
            break;
         }
         case CONDITION : {
            if (LoopVar == NULL) {
               LoopVar = GetUniqueIdentifier();   
               CodeIndent(VERBOSE_ALL, Level);
               CodeOutput(VERBOSE_ALL, "uint32_t %s;\n", LoopVar);
            } 
            CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "for (%s=0;%s<", LoopVar, LoopVar);
            CgExpression(co, c->getChild(c, 0), Level+VLEVEL);
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, ";%s++) ", LoopVar);
            CodeOutput(VERBOSE_M,   " // End of for condition\n");
            break;
         }
         case BODY : {
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "{");
            CodeOutput(VERBOSE_M,   " // for body\n");
            CgStatements(co, c, Level+1); // real level
            CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "}");
            CodeOutput(VERBOSE_M,   "// for body\n");
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
      assert(c->getToken != NULL);

      /* get data of child */      
      Token = c->getToken(c);                
      TokenType = c->getType(c);             

      switch(TokenType) {
         case CONDITION : {
            CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "while(");
            CodeOutput(VERBOSE_M,   "// condition start");
            CgExpression(co, c->getChild(c,0), Level+VLEVEL);
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, ") ");
            CodeOutput(VERBOSE_M,   " // while condition end");
            break;
         }
         case BODY : {
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "{");
            CodeOutput(VERBOSE_M,   " // while body");
            CgStatements(co, c, Level+1); // real level
            CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "}");
            CodeOutput(VERBOSE_M,   "// while body");
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
            CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "do { ");
            CodeOutput(VERBOSE_M,   " // repeat body");
            CgStatements(co, c, Level+1); // real level
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "} ");
            CodeOutput(VERBOSE_M,   "// repeat body");
            break;
         }       
         case CONDITION : {
            CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "while ((");
            CodeOutput(VERBOSE_M,   "// repeat condition start\n");
            CgExpression(co, c->getChild(c,0), Level+VLEVEL);
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, ") == 0);");
            CodeOutput(VERBOSE_M,   " // repeat-until condition end");
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
// CgProcFuncCall - 
//-----------------------------------------------------------------------------
// A FuncProc node has child for it's name and one for each parameter (expression)
//-----------------------------------------------------------------------------
void CgProcFuncCall(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgProcFuncCall";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   int GotFirstParam = 0;
   Symbol      *s = NULL;
   SymbolFunction  *f = NULL;
   SymbolParam *p = NULL;
   
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      if (ChildIx == 0) {
         // function/procedure name
         CodeIndent(VERBOSE_M,   Level); 
         CodeOutput(VERBOSE_ALL, "%s(", c->toString(c)->chars);         
         s = GetSymbolPointer(GlobalContext, c->toString(c)->chars, S_FUNCTION, 1);
         if (s != NULL) {
            CodeOutput(VERBOSE_XL, "// CgProcFuncCall s: %x\n", s);
            f = (SymbolFunction *) s->details;
            CodeOutput(VERBOSE_XL, "// CgProcFuncCall f: %x\n", f);
            p =                f->Param;
            CodeOutput(VERBOSE_XL, "// CgProcFuncCall p: %x\n", p);
         } else {
            p = NULL;
         }
         continue;
      }
      
      if (GotFirstParam) CodeOutput(VERBOSE_ALL, ",");
      GotFirstParam = 1;

      char CallMethod = 0; // method required by function
      if (p != NULL) CallMethod = p->CallMethod;

      switch(CallMethod) {
         case  0 :
         case 'v': {
            // call by value
            CodeOutput(VERBOSE_L, "// call by value\n");
            // call by value
            CgExpression(co, c, Level + 1);      
            break;          
         }
         case 'r': {
            // call by reference
            if (TokenType == IDENTIFIER) {
               CodeIndent(VERBOSE_M,   Level);             
                  
               // cm = call-method of identifier   
               char cm = GetCallMethod(co, c->toString(c)->chars);
               switch (cm) {
                  case 0 :
                  case 'v' : { // by value or unknown => create pointer
                     CodeOutput(VERBOSE_ALL, "&%s ", c->toString(c)->chars);
                     CodeOutput(VERBOSE_M,   "// identifier by reference, from value");
                     break;
                  }                     
                  case 'r' : { // by reference => just pass pointer
                     CodeOutput(VERBOSE_ALL, "%s ", c->toString(c)->chars);
                     CodeOutput(VERBOSE_M,   "// identifier by reference, from reference");
                     break;
                  }                     
                  case 'c' : { // by code       
                     // here we need to create a var, get the value and pass the parameter.
                     // and... we can't do this - create a var within a procedure call - can we?
                     // so we need a scan of parameters before the actual call...
                     CodeOutput(VERBOSE_ALL, "not supported yet: %s ", c->toString(c)->chars);
                     CodeOutput(VERBOSE_M,   "// identifier by reference, from call");
                     break;
                  }                     
               }                  
               CodeOutput(VERBOSE_M,   "// identifier by reference default..");
            } else {                     
               // constants etc.
               printf("Error: can't use this parameter to call by reference.\n");
            }         
            break;          
         }
         case 'c': {
            // call by code
            if (TokenType == IDENTIFIER) {
               CodeIndent(VERBOSE_M,   Level);            

               // cm = call-method of identifier   
               char cm = GetCallMethod(co, c->toString(c)->chars);
               switch (cm) {
                  case 0 :
                  case 'v' : { // by value or unknown => create pointer
// todo: add proper bc struct                     
                     CodeOutput(VERBOSE_ALL, "&bc_byte, &%s", c->toString(c)->chars);
                     CodeOutput(VERBOSE_M,   "// identifier by code, from value");
                     break;
                  }                     
                  case 'r' : { // by reference 
// todo: add proper bc struct                     
                     CodeOutput(VERBOSE_ALL, "&bc_byte, %s ", c->toString(c)->chars);
                     CodeOutput(VERBOSE_M,   "// identifier by code, from reference");
                     break;
                  }                     
                  case 'c' : { // by code => just pass received params
                     CodeOutput(VERBOSE_ALL, "%s__bc, %s__p ", c->toString(c)->chars, c->toString(c)->chars);
                     CodeOutput(VERBOSE_M,   "// identifier by code, from code");
                     break;
                  }                     
               }               

//               CodeOutput(VERBOSE_M,   "// identifier by reference qq");
            } else {
               // constants etc
               CodeOutput(VERBOSE_ALL, "Error: can't use this parameter to call by code.\n");
            }         
            break;          
         }
      }
      
      // note: p can be zero if the function name is unknown (in other words,
      // we don't have a prototype) or when we run out of parameters.
      // In both cases the (remaining) parameters are concidered pass by value.
      if (p != NULL) p = p->next;
   }                
   CodeIndent(VERBOSE_M,   Level);            
   CodeOutput(VERBOSE_ALL, ")");
   CodeOutput(VERBOSE_M,   " // end of proc/func call");
}
 
//-----------------------------------------------------------------------------
// CgSingleVar - 
//-----------------------------------------------------------------------------
// A SingleVar node has child for it's name and for its options
// (AT, IS, {}, ASSIGN)
//-----------------------------------------------------------------------------
void CgSingleVar(Context *co, pANTLR3_BASE_TREE t, int Level, int VarType)
{  char *ThisFuncName = "CgSingleVar";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   Var *v;
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO
      
      switch(TokenType) {
         case IDENTIFIER : {
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "%s ", c->toString(c)->chars);       

            // add var to context.
            v = SymbolVarAdd_DataName(co, c->toString(c)->chars, c->toString(c)->chars);   
            v->Type = VarType;
            break;
         }
         case ASSIGN : {
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "= ");
            CodeOutput(VERBOSE_M,   "// assign");
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
   CodeIndent(VERBOSE_M,   Level);                           
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
   int VarType = 0;
         
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO
      
      switch(TokenType) {
         case L_BYTE   : 
         case L_SBYTE  : 
         case L_WORD   : 
         case L_SWORD  : 
         case L_DWORD  : 
         case L_SDWORD : {
            CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "%s ", VarTypeString(TokenType)); 
            VarType = TokenType;
            break;
         }
         case VAR : {
            CodeIndent(VERBOSE_M,   Level);            
            if (GotFirstSingleVar) {
               CodeOutput(VERBOSE_ALL, ", ");           
               CodeIndent(VERBOSE_ALL, Level);
            }
            CgSingleVar(co, c, Level + 1, VarType);
            GotFirstSingleVar = 1;
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }
   CodeIndent(VERBOSE_M,   Level);            
   CodeOutput(VERBOSE_ALL, ";");                
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
           CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "const %s ", VarTypeString(TokenType));
            GotType = 1;
            break;
         }
         case VAR : {   
            CodeIndent(VERBOSE_M,   Level);            
            if (GotType == 0) {
               CodeOutput(VERBOSE_ALL, "const long ");
               CodeOutput(VERBOSE_M,   " // default const type\n");
               GotType = 1;        
            }
            if (GotFirstSingleVar) CodeOutput(VERBOSE_ALL, ", ");
            CgSingleVar(co, c, Level + 1, L_DWORD);
            GotFirstSingleVar = 1;
            break;
         }
         default: {            
            REPORT_NODE("unexpected token", c);
            break;
         }
      }
   }
   CodeIndent(VERBOSE_M,   Level);            
   CodeOutput(VERBOSE_ALL, ";");                
} 

//-----------------------------------------------------------------------------
// CgParamChilds - process childs of a procedure param at definition/prototype time 
//-----------------------------------------------------------------------------
// A ParamChilds node
//-----------------------------------------------------------------------------
void CgParamChilds(Context *co, pANTLR3_BASE_TREE t, int Level, SymbolParam *p, int VarType)
{  char *ThisFuncName = "CgParamChilds";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
          
//            CodeOutput(VERBOSE_ALL, "%s", VarTypeString(VarType));           
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
            CodeIndent(VERBOSE_M,   Level);            
            // store procedure param name
//            strcpy(SymbolTail->Param[(SymbolTail->NrOfParams)-1].Name, c->toString(c)->chars);
            SymbolParamSetName(p, c->toString(c)->chars);      
            
            switch(p->CallMethod) {
               case  0 :
               case 'v': {
                  // call by value
                  CodeOutput(VERBOSE_ALL, "%s %s", VarTypeString(VarType), c->toString(c)->chars);
                  break;          
               }
               case 'r': {
                  // call by reference
                  CodeOutput(VERBOSE_ALL, "%s *%s", VarTypeString(VarType), c->toString(c)->chars);
                  break;          
               }
               case 'c': {
                  // call by reference
                  CodeOutput(VERBOSE_ALL, "const ByCall *%s__bc, char *%s__p", c->toString(c)->chars, c->toString(c)->chars);
                  break;          
               }
            }
//            // deref if called by reference
//            CodeOutput(VERBOSE_ALL, " %s ", DeRefSub(c->toString(c)->chars, p->CallMethod));  
            CodeOutput(VERBOSE_M,   " // ident");  
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
         CodeIndent(VERBOSE_M,   Level);
         CodeOutput(VERBOSE_ALL, ", ");
         CodeOutput(VERBOSE_M,   "// next param");
      }
      GotFirstParam = 1;

      switch(TokenType) {
         case L_BYTE   : 
         case L_SBYTE  : 
         case L_WORD   : 
         case L_SWORD  : 
         case L_DWORD  : 
         case L_SDWORD : {     
            CodeIndent(VERBOSE_M,   Level);            
//            CodeOutput(VERBOSE_ALL, "%s", VarTypeString(TokenType)); 

            // add new parameter to current symbol  
            CodeOutput(VERBOSE_M,   " // TokenType: %d (Add param to SymbolTable", TokenType); 
            SymbolParam *p = SymbolFunctionAddParam(f, TokenType);
             
            // process childs (identifier, volatile, in, out)
            CgParamChilds(co, c, Level+VLEVEL, p, TokenType);
            
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


   CodeOutput(VERBOSE_ALL, "\n"); // empty line before proc/funct def.

   int GotReturnType = 0;
   int GotBody = 0;
   char PvPut = 0;
   char PvGet = 0; 

   
   Symbol *s = NewSymbolFunction(GlobalContext); 
   SymbolFunction *f = s->details;
      
   for (ChildIx = 0; ChildIx<n; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO

      if (Verbose > 1) REPORT_NODE("\n//CgProcedureDef childs", c)
      switch(TokenType) {

         // L_PUT or L_GET are the first childs if they exist. The flags influence further processing.
         case L_PUT : { PvPut = 1; break; }
         case L_GET : { PvGet = 1; break; }

         case L_RETURN : {
            if (PvPut == 0) {
               // normal function return processing
               CodeIndent(VERBOSE_M,   Level);            
               cc = c->getChild(c, 0);
               CodeOutput(VERBOSE_ALL, "%s ", VarTypeString(cc->getType(cc)));
               CodeOutput(VERBOSE_M,   "// return type\n");
               f->ReturnType = cc->getType(cc); // add to symbol table.
               GotReturnType = 1;
            } else {
               // pseudo-var function return processing
               CodeIndent(VERBOSE_M,   Level);            
               cc = c->getChild(c, 0);
               CodeOutput(VERBOSE_ALL, "void ");
               CodeOutput(VERBOSE_M,   " // PV return type\n"); 
               f->ReturnType = cc->getType(cc); // add to symbol table.
               GotReturnType = 1;
            }
            break;
         }
         case IDENTIFIER : {
            char String[100]; // symbol name length...

            CodeIndent(VERBOSE_M,   Level);    
            if (!GotReturnType) CodeOutput(VERBOSE_ALL, "void ");        

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
            
            CodeOutput(VERBOSE_ALL, "%s( ", String);
            CodeOutput(VERBOSE_M,   "// proc/func name");
            s->Name = CreateName(String); // add to symbol table.  
            
            if (PvPut || PvGet) {  
               CodeIndent(VERBOSE_M, Level);
               CodeOutput(VERBOSE_ALL, "ByCall *__s, char *__dummy");
               if (PvPut) CodeOutput(VERBOSE_ALL, ", ");
               CodeOutput(VERBOSE_M,   " // pvPut/pvGet params");
            }
            
            break;
         }
         case PARAMS : {
            CgParams(co, c, Level+VLEVEL, f);
            break;
         }
         case BODY : {
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, ") { \n");         
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_M,   "// start body");         
            
            if (Verbose) DumpContext(co);            

            CgStatements(co, c, Level+1); // real level!
            CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "}\n");
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_M,   "// end body");         

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
      CodeOutput(VERBOSE_ALL, ");\n");      
      CodeOutput(VERBOSE_M,   "// Add closing parenthesis + semicolon of prototype");      
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

  CodeIndent(VERBOSE_ALL, Level);
   switch (TokenType) {
      case L_IF   :
         CodeOutput(VERBOSE_ALL, "if");    
         CodeOutput(VERBOSE_M,   " // %s", ThisFuncName);    
         break;
      case L_ELSIF : 
         CodeOutput(VERBOSE_ALL, "else if");    
         CodeOutput(VERBOSE_M,   " // %s", ThisFuncName);    
         break;
      case L_ELSE :  
         CodeOutput(VERBOSE_ALL, "else");    
         CodeOutput(VERBOSE_M,   " // %s", ThisFuncName);    
         break;
      default     :  REPORT_NODE("unexpected token", t);
         break;
   }
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      switch(TokenType) {
         case CONDITION : {
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "( ");
            CodeOutput(VERBOSE_M,   "// condition");
            CgExpression(co, c->getChild(c, 0), Level+VLEVEL);
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, ") ");
            CodeOutput(VERBOSE_M,   "// end condition");
            GotBody = 1;
            break;
         }
         case BODY : {
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "{ ");
            CodeOutput(VERBOSE_M,   "// body");
            CgStatements(co, c, Level+1); // real level
           CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "}");
            CodeOutput(VERBOSE_M,   "// end body");
            GotBody = 1;
            break;
         }
         case L_ELSE: 
         case L_ELSIF : {
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_M,   "  // else / elsif");
            CgIf(co, c, Level+VLEVEL); // real level
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
      CodeOutput(VERBOSE_ALL, ");");
      CodeOutput(VERBOSE_M,   " // Add closing parenthesis + semicolon of if");
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
           CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "for (;;) {");
            CgStatements(co, c, Level+1); // real level
           CodeIndent(VERBOSE_ALL, Level);            
            CodeOutput(VERBOSE_ALL, "}\n");
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
 
   CodeIndent(VERBOSE_M,   Level);            
   CodeOutput(VERBOSE_M,   "// %s (%d, %s from Line %d:%d)",
            t->toString(t)->chars, 
            TokenType, 
            jalParserTokenNames[TokenType],
            Token->getLine(Token), 
            Token->getCharPositionInLine(Token));

   
   switch(TokenType) {
      case L_BLOCK : {
         PASS2;
        CodeIndent(VERBOSE_ALL, Level);            
         CodeOutput(VERBOSE_ALL, "{");
         CodeOutput(VERBOSE_M,   " // start of block"); 
         CgStatements(co, t, Level+1); // real level             
        CodeIndent(VERBOSE_ALL, Level);            
         CodeOutput(VERBOSE_ALL, "}"); 
         CodeOutput(VERBOSE_M,   "// end of block "); 
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
        CodeIndent(VERBOSE_ALL, Level);
         CodeOutput(VERBOSE_ALL, "break;");
         CodeOutput(VERBOSE_M,   "break; // exit %s \n", ThisFuncName);
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
         if (Pass == 1) {
            // proc/func defs only in the first pass.
            CgProcedureDef(co, t, Level+VLEVEL);             
         }
         break;   
      }
      case ASSIGN : {
         PASS2;
         CgAssign(co, t, Level+VLEVEL);             
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_ALL, ";");
         CodeOutput(VERBOSE_M,   "// end of assign \n");
         break;   
      }
      case L_RETURN : {
         PASS2;
        CodeIndent(VERBOSE_ALL, Level);            
         CodeOutput(VERBOSE_ALL, "return ");
         if (t->getChildCount(t)) {
            CgExpression(co, t->getChild(t,0), Level+VLEVEL);             
         }
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_ALL, ";");
         CodeOutput(VERBOSE_M,   "// end of return \n");
         break;   
      }
      case FUNC_PROC_CALL : {
         PASS2;
        CodeIndent(VERBOSE_ALL, Level); 
         CgProcFuncCall(co, t, Level+VLEVEL);      
         CodeIndent(VERBOSE_M,   Level); 
         CodeOutput(VERBOSE_ALL, ";");       
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
        CodeIndent(VERBOSE_ALL, Level);  
         PrintJ2cString( t->toString(t)->chars); // c statement
         break;   
      }        
      case J2C_COMMENT : {
         PASS2;
        CodeIndent(VERBOSE_ALL, Level);            
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
      assert(Child->getToken != NULL);
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
   
   CodeOutput(VERBOSE_ALL, "\n\n//----- JAT code start --------------------------------------------------------\n");                       
   CodeOutput(VERBOSE_ALL, "#include <stdio.h>\n");                       
   CodeOutput(VERBOSE_ALL, "#include <stdint.h>\n\n");                       
   CodeOutput(VERBOSE_ALL, "#include \"jaltarget.h\"\n\n");                       

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
   CodeOutput(VERBOSE_ALL, "\nint main(int argc, char **argv) {\n");                       

	if  (t->isNilNode(t) == ANTLR3_TRUE) { 
      CgStatements(GlobalContext, t, Level); // Proces childs of p,  start at child 0
	} else {
      CgStatement(GlobalContext, t, Level); // process statement of node p
   }      
   CodeOutput(VERBOSE_ALL, "\n} "); 
   CodeOutput(VERBOSE_M,     "// end of main"); 
   CodeOutput(VERBOSE_ALL, "\n//----- JAT code end ----------------------------------------------------------\n\n");
}
