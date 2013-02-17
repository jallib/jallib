//-----------------------------------------------------------------------------
// codegen.c
//-----------------------------------------------------------------------------
#include "jat.h"


int WarningCount, ErrorCount;

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



#define REPORT_NODE(VerboseLevel, string, node) {                 \
   CodeIndent(VerboseLevel, Level);                               \
   CodeOutput(VerboseLevel, "// %s %s %s (%d, %s) from ",         \
         ThisFuncName, string,                                    \
         node->toString(node)->chars,                             \
         node->getType(node),                                     \
         jalParserTokenNames[TokenType]);                         \
                                                                  \
   if (Token->input) {                                            \
      CodeOutput(VerboseLevel,"%s, ",                             \
            Token->input->fileName->chars);                       \
   }                                                              \
                                                                  \
                                                                  \
   CodeOutput(VerboseLevel, "Line %d:%d)\n",                      \
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

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
char *VarTypeString(int TokenType)
{
   switch(TokenType) {
      case L_BIT     : { 
         if (Verbose) {
            return "uint8_t /*bit*/";               
         } else {
            return "uint8_t";               
         }
      }
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
         // a regular var - 
         v->CallMethod = 'v';
      }
   }
      
   return v->CallMethod;
}

  
//-----------------------------------------------------------------------------
// ConvertLiteral - From JAL convention to C convention
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
char ConvLitString[100];
char *ConvertLiteral(int Type, char *InString)
{  uint32_t i, j;
   char *s = ConvLitString;
   
   strcpy(s, InString);
   CodeOutput(VERBOSE_L, "// ConvertLiteral InString: %s\n", s);

   // remove underscores.   
   for (i=0, j=0; s[i]; i++, j++) {
      s[i] = s[j];
      if (s[i] == '_') i--;
   }                            

   CodeOutput(VERBOSE_XL, "// ConvertLiteral Str1: %s\n", s);

   switch (Type) {
      case HEX_LITERAL: 
         // nothing to do
         break;          

      case DECIMAL_LITERAL :   
         // remove heading zero's
         while (*s == '0') s++;
         if (*s == 0) s--; // just one zero is possible
         break;                                        

      case OCTAL_LITERAL :
         // substitutue 'q' with 0 and 
         s[1] = '0';
         s++; //remove first 0 (cosmetic)       
         break;

      case BIN_LITERAL :
         // convert
         j = 0;
         for (i=2; s[i]; i++) {
            j *= 2;
            if (s[i] == '1') j++;
         }
         sprintf(s, "0x%x", j);  
         break;         
   }

   CodeOutput(VERBOSE_XL, "// ConvertLiteral Str2: %s\n", s);
   return s;
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
   char *SymbolName;
   char *ArrayIndex = NULL; 
   char CallMethod;
   
   switch(TokenType) {
      case IDENTIFIER :

         // check for child, which is LBRACKET and has array index child.   
         if (t->getChildCount(t) > 0) {
            // a child -> array
            c = t->getChild(t, 0);
            assert(c != NULL);
            cc = c->getChild(c, 0);
            assert(cc != NULL);
            ArrayIndex = cc->toString(cc)->chars;   
//            CodeOutput(VERBOSE_ALL, "array");
         }

         // lookup indentifier in context
         s = GetSymbolPointer(co, t->toString(t)->chars, S_VAR | S_ALIAS, 1); // search for var, in local and global context
         v = NULL;
         if (s != NULL) {
            v = s->details;
            SymbolName = s->Name; // could be de-aliassed.
         } else {
            SymbolName = t->toString(t)->chars;
         }

         if ((v) && (v->get != NULL)) {
            // there is a var record.
            // we have a get function, so call to get value
            CodeIndent(VERBOSE_M,   Level);
//            CodeOutput(VERBOSE_ALL, "%s((ByCall *)NULL, (char *)NULL)", v->get);         
//            CodeOutput(VERBOSE_ALL, "%s(PVAR_DIRECT)", v->get);            
            if (v->data) {
               CodeOutput(VERBOSE_ALL, "%s((const ByCall *)%s__bc, (void *)&%s)", v->get, s->Name, v->data);         
            } else {
               CodeOutput(VERBOSE_ALL, "%s((const ByCall *)%s__bc, NULL)", v->get, s->Name);         
            }

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
            char *str = t->toString(t)->chars;

            // PVAR_GET(type, get, data, bc, p)
            CodeOutput(VERBOSE_ALL, "PVAR_GET(%s, %s__bc, %s__p)", VarTypeString(v->Type), str, str, str, str);           

            break;
         }

         if ((v) && (v->CallMethod == 'a') ) {
            // a ARRAY procedure parameter, passed by call
            
            // at this point, we need to get a value from this array
            // with ArrayIndex as the identifier that gives location.
            
            
            
//            CodeIndent(VERBOSE_M,   Level);            
//            char *str = t->toString(t)->chars;
//
//            // PVAR_GET(type, get, data, bc, p)
//            CodeOutput(VERBOSE_ALL, "PVAR_GET(%s, %s__bc, %s__p)", VarTypeString(v->Type), str, str, str, str);           

            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "CODE_ARRAY_READ(%s, %s)", SymbolName, ArrayIndex);           
            break;
         }

         // default - call by value, unknown call-methode or unknown identifier
         CodeIndent(VERBOSE_M,   Level);            
         if (ArrayIndex == NULL) {
            // non-array
            CodeOutput(VERBOSE_ALL, "%s", SymbolName); // t->toString(t)->chars);
            CodeOutput(VERBOSE_M,   "// %s identifier (default)", ThisFuncName);   
         } else {                                          
            // array    !!! boudary checking required !!!
            CodeOutput(VERBOSE_ALL, "%s[%s]", SymbolName, ArrayIndex); // t->toString(t)->chars);
            CodeOutput(VERBOSE_M,   "// %s identifier-array (default)", ThisFuncName);   
         }
            
         break;

      case HEX_LITERAL :        
      case BIN_LITERAL :
      case OCTAL_LITERAL :
      case DECIMAL_LITERAL :
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_ALL, "%s", ConvertLiteral(TokenType, t->toString(t)->chars));
         CodeOutput(VERBOSE_M,   "// decimal constant");
         break;

      case CHARACTER_LITERAL : 
      case STRING_LITERAL : 
         str = t->toString(t)->chars;
         if (strlen(str) > 3) {
            CodeOutput(VERBOSE_WARNING, "// Warning: only first char of string used.");            
           CodeIndent(VERBOSE_ALL,   Level);            
         }
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_ALL, "'%c'", str[1]);
         CodeOutput(VERBOSE_M,   "// character constant");
         break;

      case AMP           :
      case ASTERIX       :
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
            CodeOutput(VERBOSE_ERROR, "%s Error: not two subnodes\n", ThisFuncName);
         }
         break;

      case BANG          :
         if (n == 1) {
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "( ! ");
            CodeOutput(VERBOSE_M,   " // start expr");
            CgExpression(co, t->getChild(t, 0), Level + 1);

            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, ")");
            CodeOutput(VERBOSE_M,   " // end expr");
         } else {
            CodeOutput(VERBOSE_ERROR, "%s Error: not two subnodes\n", ThisFuncName);
         }
         break;

      case FUNC_PROC_CALL :
         CgProcFuncCall(co, t, Level+VLEVEL);
         break;

      case L_COUNT :       
        
         // child -> identifier
         c = t->getChild(t, 0);
         assert(c != NULL);              
         
         // lookup indentifier in context
         s = GetSymbolPointer(co, c->toString(c)->chars, S_VAR | S_ALIAS, 1); // search for var, in local and global context
         v = NULL;  
         SymbolName = "undef";
         if (s != NULL) {
            v = s->details;
            SymbolName = s->Name; // could be de-aliassed.
         } else {
            SymbolName = t->toString(t)->chars;
         }  
         
//         if ((v) && (v->CallMethod == 'a')) {

         // regardless of the type, __size is always what is needed (right?)
         CodeIndent(VERBOSE_M, Level);
         CodeOutput(VERBOSE_ALL, " %s__size ", SymbolName);         
         CodeOutput(VERBOSE_M, " // array length of '%s'\n", t->toString(t)->chars);         
            
//         }
         break;

      default :
         CodeOutput(VERBOSE_ALL, "// %s unknown token %s type %d %s\n", ThisFuncName, t->toString(t)->chars, TokenType, jalParserTokenNames[TokenType]);
         break;      
   }
}



//-----------------------------------------------------------------------------
// CgArrayAssign - Generate code
//-----------------------------------------------------------------------------
// an array assignment is a node with a string or a curly bracket
// The latter has multiple elemements.      
// returns: size of array assignment.
//-----------------------------------------------------------------------------
int CgArrayAssign(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgArrayAssign";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   Var *v; 
   char *Identifier;  
   char *ArrayIndex = NULL;
   char *str;
   int ret = 0;

   switch (TokenType) {
      case LCURLY : {
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_ALL, "{", str);
         CodeOutput(VERBOSE_M, "//curly", str[1]);         
         
         ret = n; // save nr of array elements to return.
         // put the values in the list
         for (ChildIx = 0; ChildIx<n ; ChildIx++) {
            CODE_GENERATOR_GET_CHILD_INFO

            if (ChildIx > 0) {
               CodeIndent(VERBOSE_M, Level);               
               CodeOutput(VERBOSE_ALL, ", ");               
            }            
            CgExpression(co, c, Level + 1);
         }            
         
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_ALL, "}", str);
         break;
      }

      case STRING_LITERAL : {
         str = t->toString(t)->chars;
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_ALL, "%s", str);
         CodeOutput(VERBOSE_M,   "// string constant");
         ret = strlen(str) - 2; // exclude the quotes from count.
         break;
      }   
      default: {            
         REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
         break;
      }
   }   
   return ret;
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
   char *Identifier;  
   char *ArrayIndex = NULL;

   // first node is identifier to assign to. 
   ChildIx = 0;
   CODE_GENERATOR_GET_CHILD_INFO
   
   if (TokenType != IDENTIFIER) {   
      CodeOutput(VERBOSE_ERROR, "%s error: token %s \n", ThisFuncName, c->toString(c)->chars);
      return;
   }                

   // check for child, which is LBRACKET and has array index child.   
   if (c->getChildCount(c) > 0) {    
      // a child -> array assign
      cc = c->getChild(c, 0);
      assert(cc != NULL);
      cc = cc->getChild(cc, 0);
      assert(cc != NULL);
      ArrayIndex = cc->toString(cc)->chars;
   }


   // lookup indentifier in context
   Symbol *s = GetSymbolPointer(co, c->toString(c)->chars, S_VAR | S_ALIAS, 1); // search for var, in local and global context
   if (s != NULL) {
      v= s->details;
      Identifier = s->Name;

      CodeIndent(VERBOSE_M, Level);
      CodeOutput(VERBOSE_M,"// CgAssign - var %s found in context, Dump!\n", Identifier);
      DumpSymbol(VERBOSE_M, s);
   } else {  
      v = NULL;
      Identifier = c->toString(c)->chars; 

      CodeIndent(VERBOSE_M, Level);
      CodeOutput(VERBOSE_M,"// CgAssign - var %s not found in context, use default\n", Identifier);
   }      
                
   if ((v != NULL) && (v->put != NULL)) {
      // we have a put function, so call in stead of assing
      // (this is the use of a global defined put function within an assignment)
      CodeIndent(VERBOSE_ALL, Level);
      if (v->data) {
         CodeOutput(VERBOSE_ALL, "%s((const ByCall *)%s__bc, (void *)&%s,", v->put, s->Name, v->data);         
      } else {
         CodeOutput(VERBOSE_ALL, "%s((const ByCall *)%s__bc, (void *)NULL,", v->put, Identifier);         
      }
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
//   if (bravo__bc->put) (*bravo__bc->put)(bravo__bc, bravo__p, 1);
//            CodeOutput(VERBOSE_ALL, "if (%s__bc->put) (*%s__bc->put)(%s__bc, %s__p, ", 
//                  c->toString(c)->chars, c->toString(c)->chars, c->toString(c)->chars, c->toString(c)->chars);
            
            CodeOutput(VERBOSE_ALL, "PVAR_ASSIGN(uint8_t, %s__bc, %s__p,",    
                  c->toString(c)->chars, c->toString(c)->chars);
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
   if (ArrayIndex == NULL) {
      // normal var
      CodeOutput(VERBOSE_ALL, "%s = ", Identifier); // alias could be resolved... c->toString(c)->chars);
      CodeOutput(VERBOSE_M,   " // %s identifier call by value", ThisFuncName);

      // second node is expr
      c = t->getChild(t, 1);  
      CgExpression(co, c, Level + 1);      

   } else {
      // array                                        
      
      // !!! boundery checking required !!!
      CodeOutput(VERBOSE_ALL, "DIRECT_ARRAY_ASSIGN(%s, %s, %s__size, ", Identifier, ArrayIndex, Identifier); // alias could be resolved... c->toString(c)->chars);
      CodeOutput(VERBOSE_M,   " // %s identifier-array call by value", ThisFuncName);

      // second node is expr
      c = t->getChild(t, 1);  
      CgExpression(co, c, Level + 1);      

      CodeIndent(VERBOSE_M,   Level);
      CodeOutput(VERBOSE_ALL, ")"); // close macro call      
   }   
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
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
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
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
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
            CodeOutput(VERBOSE_M, "// Using var %s\n", LoopVar);
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
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
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
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
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
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
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
   
   char *ProcedureName = NULL;
   
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      if (ChildIx == 0) {
         // function/procedure name
         CodeIndent(VERBOSE_M,   Level); 
         CodeOutput(VERBOSE_ALL, "%s(", c->toString(c)->chars);   
         ProcedureName =  c->toString(c)->chars; // save for error reporting.      
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
      
      if (GotFirstParam) {
         CodeIndent(VERBOSE_M, Level);
         CodeOutput(VERBOSE_ALL, ",");
      }
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
                     // For now, we don't support it.
                     CodeOutput(VERBOSE_ERROR, "// Error at call of %s(), param: %s\n", ProcedureName, c->toString(c)->chars);
                     CodeOutput(VERBOSE_ERROR, "// Pass of pseudo- or volatile var as in/out parameter is not supported, use 'in' or 'volatile'\n");
                     
                     CodeOutput(VERBOSE_M,     "// identifier by reference, from call"); /* keep as doc for case statement */
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
                     
                     // above, we determined callmethod, now we need to get the var struct again
                     // maybe refactor to save the symol or var pointer??
                     s = GetSymbolPointer(co, c->toString(c)->chars, S_VAR, 1); // search for var, include global context for pvars
                     assert(s != NULL); // should not be NULL, we just got call method
                     Var *v = s->details;
                                       
                     if (v->data != NULL) {
                        CodeIndent(VERBOSE_M, Level);
                        CodeOutput(VERBOSE_ALL, "(const ByCall *)%s__bc, (void *)&%s ", c->toString(c)->chars, v->data);
                        CodeOutput(VERBOSE_M,   "// identifier by code, from code 1");
                     } else {
                        CodeIndent(VERBOSE_M, Level);
                        CodeOutput(VERBOSE_ALL, "(const ByCall *)%s__bc, (void *)NULL", c->toString(c)->chars);
                        CodeOutput(VERBOSE_M,   "// identifier by code, from code 2");
                     }
                     break;
                  }   
                  default : assert(0); // unhandled case
                  
               }               

//               CodeOutput(VERBOSE_M,   "// identifier by reference");
            } else {
               // constants etc
               CodeOutput(VERBOSE_ERROR, "Error: can't use this parameter to call by code.\n");
            }         
            break;          
         }
         case 'a' : {
            // const ByCallA *str__bc, uint8_t *str__p, uint16_t str__size
            CodeOutput(VERBOSE_ALL, "pass_array_param %s)", c->toString(c)->chars);
            break;
         }
         default : assert(0); // unhandled case
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
// CgGetAtInfo - 
//-----------------------------------------------------------------------------
// get identifier name and (optional) bit location
//-----------------------------------------------------------------------------
char *CgGetAtInfo(Context *co, pANTLR3_BASE_TREE t, int Level, char **BitLocation)
{  char *ThisFuncName = "CgGetAtInfo";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
   char String[100];
   
   Var *v;

   char *Identifier = NULL;
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO
      
      switch(TokenType) {
         case IDENTIFIER : {   
            Identifier = c->toString(c)->chars;
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_M,   "// %s AtName %s", ThisFuncName, Identifier);
            break;
         }
         case COLON : {
            // ignore 
            break;
         }
         case DECIMAL_LITERAL : {
            *BitLocation = c->toString(c)->chars; 
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_M,   "// %s BitLocation %s", ThisFuncName, *BitLocation);            
            break;
         }
         default: {            
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
            break;
         }
      }
   }
   return Identifier;
} 


//-----------------------------------------------------------------------------
// CgSingleBitVar - 
//-----------------------------------------------------------------------------
// A SingleVar node has child for it's name and for its options
// (AT, IS, {}, ASSIGN)
//-----------------------------------------------------------------------------
void CgSingleBitVar(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgSingleBitVar";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
   char String[100];

   Var *v;

   char *Identifier = NULL;
   char *AtName = NULL;
   char *BitLocation = NULL;
   
   int i;
            
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO

      //--------------------------------------------
      // ** warning: non-standard code construct ***
      //--------------------------------------------

      // check for invalid tokens
      if ((TokenType != IDENTIFIER) && (TokenType != L_AT) && (TokenType != ASSIGN)) { 
         REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
      }

      CodeIndent(VERBOSE_L,   Level);            
      CodeOutput(VERBOSE_L,   "// %s loop ChildIx: %d, n: %d", ThisFuncName, ChildIx, n);
      REPORT_NODE(VERBOSE_L, "parse this token:", c);

      if (TokenType == IDENTIFIER ) {   
         Identifier = c->toString(c)->chars;
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_M,   "// %s identifier %s", ThisFuncName, Identifier);
         
         // continue if we have more tokens, otherwise go to next IFs and create var
         if (ChildIx < (n-1)) continue;
      }
      
      if (TokenType == L_AT) {   
         // get at parameters **and go to next IFs**
         AtName = CgGetAtInfo(co, c, Level+VLEVEL, &BitLocation);
         if (ChildIx < (n-1)) continue;
      }

      // If we get to this point, we need to create the var
      if (AtName == NULL) {
         // normal bitvar => create   
         
         // create a storage place
         sprintf(String, "%s__d", Identifier);
         CodeIndent(VERBOSE_ALL,   Level);            
         CodeOutput(VERBOSE_ALL, "uint8_t %s ", String);       
         i = 0; // default bit location 
      } else {
         // at bitvar -> reference to exisiting storage place
         strcpy(String, AtName);
         i = BitLocation[0];
         if (i < '0' || i > '9') {
            CodeOutput(VERBOSE_ERROR, "Error: bit location is non-numerical");
         } 
         i = i - '0'; // convert to number.           
         CodeIndent(VERBOSE_M,   Level);            
         CodeOutput(VERBOSE_M,   " // %s bitlocation %d", ThisFuncName, i);
      }  

      // add to the symbol table
      v =SymbolVarAdd_DataName(GlobalContext, Identifier, String);     
      sprintf(String, "varbit%d__put", i);
      SymbolVarAdd_PutName(GlobalContext, Identifier, String);
      sprintf(String, "varbit%d__get", i);
      SymbolVarAdd_GetName(GlobalContext, Identifier, String);
      v->Type = L_BIT;
      
      // optional assign
      if (TokenType == ASSIGN) {   
         if (AtName) {
            CodeOutput(VERBOSE_ERROR, "// bitvar definition with both 'at' and assign not supported");       
            // To support this, we need a separte statement that assigns the var. This is valid if the
            // var is defined in the body of a function. If it is part of a function parameter definition
            // it must be put into the body of the function. And if the var is a global one, the definition
            // is global too, but the assignment must be part of main.
         } else {
            // assign value
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_ALL, "= ");
            CodeOutput(VERBOSE_M,   "// assign");
            cc = c->getChild(c, 0);
            CgExpression(co, cc, Level+VLEVEL);
         }
      }
   } // end of for loop

//   DumpContext(co);      
   CodeIndent(VERBOSE_M,   Level);                           
   CodeOutput(VERBOSE_ALL, ";");
} 
 
//-----------------------------------------------------------------------------
// CgSingleVar - 
//-----------------------------------------------------------------------------
// A SingleVar node has child for its name and for its options
// (AT, IS, {}, ASSIGN)
//-----------------------------------------------------------------------------
void CgSingleVar(Context *co, pANTLR3_BASE_TREE t, int Level, int VarType, int IsConstant)
{  char *ThisFuncName = "CgSingleVar";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   Var *v;
   char *Identifier = NULL;
   char *ArraySizeExpr = NULL;
   int IsArray = 0;  
   int InitLen = -1;
         
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO
      REPORT_NODE(VERBOSE_M, "SingeVar child token", c);
      
      switch(TokenType) {
         case IDENTIFIER : {   
            // save identifier name
            Identifier = c->toString(c)->chars;

            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_M, "// %s Add identifier %s to context.", ThisFuncName, c->toString(c)->chars);       
            v = SymbolVarAdd_DataName(co, c->toString(c)->chars, c->toString(c)->chars);   

            v->Type = VarType;
            break;
         }
         case LBRACKET : {
            // array
            IsArray = 1;
            assert(v != NULL);     
            cc = c->getChild(c,0);                  
//            if (IsConstant) {
//               // constants can have arrays of undefined length
               if (cc == NULL) {
                  v->ArraySize = -1; // no array size specified
                  ArraySizeExpr = NULL;
                  break;   
               }
//            } else {
//               // var (not constant)
//               assert(cc != NULL);     
//            }
            v->ArraySize = atoi(c->toString(cc)->chars);   // need expression conversion.
            ArraySizeExpr = c->toString(cc)->chars;            
            break;
         }
         case ASSIGN : {              
            if (!IsArray) {
               CodeIndent(VERBOSE_ALL,   Level);            
               if (IsConstant) CodeOutput(VERBOSE_ALL, "const ");
               CodeOutput(VERBOSE_ALL, "%s %s = ", VarTypeString(VarType), Identifier);
               CodeOutput(VERBOSE_M,   "// assign");
               cc = c->getChild(c, 0);
               CgExpression(co, cc, Level+VLEVEL);
               CodeIndent(VERBOSE_M,   Level);            
               CodeOutput(VERBOSE_ALL, ";");  
               Identifier = NULL; // indicate we handled this one.
            } else {
               CodeIndent(VERBOSE_ALL,   Level);            
               if (IsConstant) CodeOutput(VERBOSE_ALL, "const ");
               CodeOutput(VERBOSE_ALL, "%s %s[] = ", VarTypeString(VarType), Identifier);
               CodeOutput(VERBOSE_M,   "// assign");
               cc = c->getChild(c, 0);                           
               InitLen = CgArrayAssign(co, cc, Level+VLEVEL);  
               
               if (v->ArraySize == -1) {
                  // no size yet, so save.
                  v->ArraySize = InitLen;
               } else {
                  // check size
                  if (v->ArraySize < InitLen) {
                     CodeOutput(VERBOSE_WARNING, "Warning: excessive initializers for array %s[] ", Identifier);
                  }
               }               
               CodeIndent(VERBOSE_M,   Level);            
               CodeOutput(VERBOSE_ALL, ";");  
               
               // len constant           
               CodeIndent(VERBOSE_ALL,   Level);                           
               CodeOutput(VERBOSE_ALL, "const int %s__size = %d;", Identifier, v->ArraySize);

               
               Identifier = NULL; // indicate we handled this one.
            }
            break;
         }
         case L_IS : {
            if (n > 2) {
               CodeOutput(VERBOSE_ERROR, "// IS can not co-exist with AT or ASSIGN\n");
               return;
            }
            cc = c->getChild(c, 0);
            if (strcmp(cc->toString(cc)->chars, Identifier) == 0) {                      
               // no action required - the symbol is already in the table.
               CodeOutput(VERBOSE_XL, "// %s special case: var %s prototype, like 'extern' in C", Identifier, ThisFuncName);               

               // code below forces type
               //CodeIndent(VERBOSE_ALL,   Level);                           
               //CodeOutput(VERBOSE_ALL, "extern %s %s;", VarTypeString(VarType), Identifier);

            } else {
               // No use for this AFAIK - we have alias.
               CodeOutput(VERBOSE_WARNING, "// %s use of 'VAR ... IS' only supported in prototype-way", ThisFuncName);                              
            }
            Identifier = NULL; // indicate we handled this one.
            break;
         }
         default: {            
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
            break;
         }
      }    
   }    
   if (Identifier != NULL) {
      // Identifier unhandled.  
      if (IsConstant) {
         CodeOutput(VERBOSE_ERROR, "// Error: Constant %s '%s' without assign\n", VarTypeString(VarType), Identifier);         
         return;
      }


      if (IsArray) {   
         // array
         CodeIndent(VERBOSE_ALL,   Level);                           
         CodeOutput(VERBOSE_ALL, "%s %s[%s];", VarTypeString(VarType), Identifier, ArraySizeExpr);
         CodeOutput(VERBOSE_M, "// simple var definition");
         CodeIndent(VERBOSE_M,   Level);    
           
         CodeIndent(VERBOSE_ALL,   Level);                           
         CodeOutput(VERBOSE_ALL, "const int %s__size = %s;", Identifier, ArraySizeExpr);
         CodeOutput(VERBOSE_M, "// constant with array size");
         CodeIndent(VERBOSE_M,   Level);    
           
         assert(v != NULL);   
//         DumpContext(co);
         
//         if (ArraySizeExpr != NULL) (
//            v->ArraySize = 1;//atoi((char *) ArraySizeExpr);
//         } else {
//            v->ArraySize = -1; // unspecified.
//         }
      } else {
         // handle identifier
         CodeIndent(VERBOSE_ALL,   Level);                           
         CodeOutput(VERBOSE_ALL, "%s %s;", VarTypeString(VarType), Identifier);
         CodeOutput(VERBOSE_M, "// simple var definition");
         CodeIndent(VERBOSE_M,   Level);                           
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

//   int GotFirstSingleVar = 0;
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
            CodeIndent(VERBOSE_M, Level);            
            CodeOutput(VERBOSE_M, "// %s Type %s ", ThisFuncName, VarTypeString(TokenType)); 
            VarType = TokenType;
            break;
         }

         case L_BIT    : { 
            CodeIndent(VERBOSE_M, Level);            
            CodeOutput(VERBOSE_M, "// special var %s in %s", VarTypeString(TokenType), ThisFuncName); 
            VarType = TokenType;
            break;
         }

         case VAR : {    
//            CodeOutput(VERBOSE_ALL, ", ");           
//            CodeIndent(VERBOSE_M,   Level);            

            if (VarType == L_BIT) {                   
               CgSingleBitVar(co, c, Level + VLEVEL);               
            } else {
               // a var type that maps to a C var type  
               
//               if (GotFirstSingleVar) {
//                  CodeOutput(VERBOSE_ALL, ", ");           
//                  CodeIndent(VERBOSE_ALL, Level);
//               }
               CgSingleVar(co, c, Level + VLEVEL, VarType, 0);
//               GotFirstSingleVar = 1;
            }
            break;
         }
         case L_VOLATILE : {            
            REPORT_NODE(VERBOSE_ERROR, "token ignored", c);
            break;
         }
         default: {            
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
            break;
         }
      }
   }
   CodeIndent(VERBOSE_M,   Level);            
   CodeOutput(VERBOSE_M, "// %s end", ThisFuncName);                
}        

//-----------------------------------------------------------------------------
// CgAlias - 
//-----------------------------------------------------------------------------
// An ALIAS node has child for it's options and a VAR node for each
// identifier (single var)
//-----------------------------------------------------------------------------
void CgAlias(Context *co, pANTLR3_BASE_TREE t, int Level)
{  char *ThisFuncName = "CgAlias";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'

   int GotType = 0;
   int GotFirstSingleVar = 0;
   char *AliasName   = NULL;
   char *AliasTarget = NULL;
      
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {
      
      CODE_GENERATOR_GET_CHILD_INFO
      
      switch(TokenType) {
         case IDENTIFIER : {   
            if (ChildIx == 0) {
               AliasName = c->toString(c)->chars;               
            }
            if (ChildIx == 1) {
               AliasTarget = c->toString(c)->chars;               
            }  
            break;
         }
         default: {            
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
            break;
         }
      }
   }
   CodeIndent(VERBOSE_ALL,   Level);            
   CodeOutput(VERBOSE_ALL, "// AliasName : %s, AliasTarget: %s\n", AliasName, AliasTarget);                
   Symbol *s = NewSymbolAlias(co, AliasName, AliasTarget);

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
            VarType = TokenType;
            break;
         }
         case VAR : {   
            if (VarType == 0) {
               VarType = L_DWORD;
               CodeIndent(VERBOSE_M,   Level);            
               CodeOutput(VERBOSE_M,   " // default const type WORD\n");
            }
               
            CgSingleVar(co, c, Level + VLEVEL, VarType, 1);
            break;
         }
         default: {            
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
            break;
         }
      }
   }
} 

//-----------------------------------------------------------------------------
// CgParamChilds - process childs of a procedure param at definition/prototype time 
//-----------------------------------------------------------------------------
// A ParamChilds node         
//
// p points to the copy of the param, stored with the function def itself.    
//
// CgParamChilds generate code for this parameter and add it as a parameter
// to the procedure def. This is used pass the proper parameters when the
// procedure gets called (and later copied by CgParam as real symbols).
//
// TODO: check similarity between this function and CgSingleVar - maybe it
// is better to merge them into one.
//-----------------------------------------------------------------------------
void CgParamChilds(Context *co, pANTLR3_BASE_TREE t, int Level, SymbolParam *p, int VarType)
{  char *ThisFuncName = "CgParamChilds";
   CODE_GENERATOR_FUNCT_HEADER  // declare vars, print debug, get n, Token and TokenType of 'p'
          
//            CodeOutput(VERBOSE_ALL, "%s", VarTypeString(VarType));           
   for (ChildIx = 0; ChildIx<n ; ChildIx++) {

      CODE_GENERATOR_GET_CHILD_INFO

      if (VarType == L_BIT) {
         VarType = L_BYTE; // pass bit param as byte
      }

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
         
         case LBRACKET : {
            // array
            cc = c->getChild(c,0);                  
            if (cc == NULL) {
               p->ArraySize = -1; // no array size specified
            } else {
               p->ArraySize = atoi(c->toString(cc)->chars);   // need expression conversion.
            }     
            p->CallMethod = 'a';
            break;   
         }
         
         
         case L_DATA     : // L_DATA is also identifier
         case IDENTIFIER : {                                  
            // -----------------------------------------------
            // Identifier is always there & last child in list.
            // -----------------------------------------------
            CodeIndent(VERBOSE_M,   Level); 
                       
            // store procedure param name
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
                  // call by code
                  CodeOutput(VERBOSE_ALL, "const ByCall *%s__bc, uint8_t *%s__p", c->toString(c)->chars, c->toString(c)->chars);
                  break;          
               } 
               case 'a': {
                  // call by array-code
                  CodeOutput(VERBOSE_ALL, "const ByCallA *%s__bc, uint8_t *%s__p, uint16_t %s__size", c->toString(c)->chars, c->toString(c)->chars, c->toString(c)->chars);
                  break;          
               } 
            }
//            // deref if called by reference
//            CodeOutput(VERBOSE_ALL, " %s ", DeRefSub(c->toString(c)->chars, p->CallMethod));  
            CodeOutput(VERBOSE_M,   " // ident");  
            break;
         }
         default: {            
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
            break;
         }
      }
   }
} 

//-----------------------------------------------------------------------------
// CgParams - process params of procedure / function definition or prototype
//-----------------------------------------------------------------------------
// A Param node 
//
// Let CgParamChilds generate code for this parameter and add it as a parameter
// to the procedure def. This is used pass the proper parameters when the
// procedure gets called.
//
// This function adds a 'var' symbol *copy* to the local context for each 
// parameter to handle access to the var within the procedure.
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
         case L_BIT    : 

         case L_BYTE   : 
         case L_SBYTE  : 
         case L_WORD   : 
         case L_SWORD  : 
         case L_DWORD  : 
         case L_SDWORD : {     
            CodeIndent(VERBOSE_M,   Level);            

            // add new parameter to current symbol  
            CodeOutput(VERBOSE_M,   " // TokenType: %d (Add param to SymbolTable", TokenType); 
            SymbolParam *p = SymbolFunctionAddParam(f, TokenType);
             
            // process childs (identifier, volatile, in, out)
            CgParamChilds(co, c, Level+VLEVEL, p, TokenType);
            
            // *copy* param info to context
            // (  
            //    We could add the pointer to p. But some day, we will free()
            //    the structs when they are not used any more and a pointer to the
            //    actual procedure parameter might free() that too.
            //    So... when cleanup is implemented and some flag is added, copy
            //    can be replaced by th reference.
            // )
            Var *v = SymbolGetOrNewVar(co, p->Name);
            v->Type       = p->Type;
            v->ArraySize  = p->ArraySize;
            v->CallMethod = p->CallMethod;

            break;
         }
         default: {            
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
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
// - Next a record is created, as for each function, that describe how this
//   function is called.
//   This record holds the function name, appended with __put or __get in the
//   case of put or get. This is also the name of the function in C.
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

      if (Verbose > 1) REPORT_NODE(VERBOSE_ALL, "\n//CgProcedureDef childs", c)
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
               CodeOutput(VERBOSE_ALL, "const ByCall *__s, char *__dummy");
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
            CodeOutput(VERBOSE_ALL, ") { ");         
            CodeIndent(VERBOSE_M,   Level);            
            CodeOutput(VERBOSE_M,   "// start body");         

//            // put in self-reference (to allow pvar-functions to access it's var)
//            CodeIndent(VERBOSE_ALL,   Level+1);            
//            CodeOutput(VERBOSE_ALL, "static void *this_function = %s;\n", s->Name);         
//            CodeIndent(VERBOSE_M,   Level+1);            
//            CodeOutput(VERBOSE_M,   "// self-reference");         
            
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
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
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
      default     :  
         REPORT_NODE(VERBOSE_ERROR, "unexpected token", t);
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
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
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
            REPORT_NODE(VERBOSE_ERROR, "unexpected token", c);
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
   CodeOutput(VERBOSE_M,   "// %s (%d, %s from ",
            t->toString(t)->chars, 
            TokenType, 
            jalParserTokenNames[TokenType]);
            
      if (Token->input) {
         CodeOutput(VERBOSE_M,"%s, ", Token->input->fileName->chars);
      }

   CodeOutput(VERBOSE_M,   "Line %d:%d)",
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
      case INCLUDE_STMT :     
      case EOF : {    
         // ignore statment
         break;   
      }
      case L_ALIAS : {    
         PASS1;
         CgAlias(co, t, Level+VLEVEL);                      
         break;   
      }
      default: {
         REPORT_NODE(VERBOSE_ERROR, "Unsupported statement", t); 
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
{  int Level, i;

   ErrorCount = 0;
   
   CreateGlobalContext(); 
   
   CodeOutput(VERBOSE_ALL, "\n\n//----- JAT code start --------------------------------------------------------\n");                       
   CodeOutput(VERBOSE_ALL, "#include <stdio.h>\n");                       
   CodeOutput(VERBOSE_ALL, "#include <stdint.h>\n\n");                       
   CodeOutput(VERBOSE_ALL, "#include \"jaltarget.h\"\n");                       

   // get base filename
   i = GetFileExtIndex(Filename);
   Filename[i-1] = 0;
   CodeOutput(VERBOSE_ALL, "#include \"%s.h\"\n\n", Filename);                       
   Filename[i-1] = '.'; // and restore filename

   Pass = 1;   // collect symbols, generate functions, global vars etc.
   Level = 0;
	if  (t->isNilNode(t) == ANTLR3_TRUE) { 
	   // a nill-node at root level means there are multiple statements to be processed
      CgStatements(GlobalContext, t, Level); // Proces childs of p,  start at child 0
	} else {
	   // the root node is a statement itself (this means we have a program with only
	   // one statement. Not common in a real program, but possible and usefull while testing).
      CgStatement(GlobalContext, t, Level); // process statement of node p
   }      

   // create .h file of project.
   SymbolPrintVarTableExternals(GlobalContext, Filename);

   // put vartable in the master source file.
   SymbolPrintVarTable(GlobalContext);
   
   Pass = 2;   // generate main function
   Level = 0;
   if (NoMainParams == 0) {
      CodeOutput(VERBOSE_ALL, "\nint main(int argc, char **argv) {\n");                       
   } else {
      CodeOutput(VERBOSE_ALL, "\nint main(void) {\n");                       
   }

	if  (t->isNilNode(t) == ANTLR3_TRUE) { 
      CgStatements(GlobalContext, t, Level); // Proces childs of p,  start at child 0
	} else {
      CgStatement(GlobalContext, t, Level); // process statement of node p
   }      
   CodeOutput(VERBOSE_ALL, "\n} "); 
   CodeOutput(VERBOSE_M,     "// end of main"); 
   
   CodeOutput(VERBOSE_ALL, "\n// JAT finished, %d warnings, %d errors.\n", WarningCount, ErrorCount);
   CodeOutput(VERBOSE_ALL, "//----- JAT code end ----------------------------------------------------------\n\n");
   
   printf("JAT finished, %d warnings, %d errors.\n", WarningCount, ErrorCount);   
}
