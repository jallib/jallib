// symboltable.c

#include "jat.h"

Context *GlobalContext = NULL;

// static prototypes
static void _AddSymbolToContext(Context *co, Symbol *s);
//static void append_node(Symbol *lnode);
//static void remove_node(Symbol *lnode);
//static void insert_node(Symbol *lnode, Symbol *after); 

static Symbol *NewSymbol(Context *co);                           

#define CHECK_NULL(n)                     \
   if (n == NULL) {                       \
      printf("Out of memory error\n");    \
      exit(1);                            \
   }                                      \


//----------------------------------------------------------------------------- 
// NewSymbolFunction - add function record to symbol table
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Symbol *NewSymbolFunction(Context *co)
{  Symbol *s;
   SymbolFunction *f;
   
   s = NewSymbol(co);
   s->Name = NULL; //CreateName(Name);
   s->Type = S_FUNCTION;
            
   f = malloc(sizeof(SymbolFunction));
   CHECK_NULL(f);
   
   s->details = f;
   
   f->ReturnType = L_VOID;   
//   f->NrOfParams = 0;        
   f->Param      = NULL;

   return s;
}


// add paramter record to function-def
SymbolParam *SymbolFunctionAddParam(SymbolFunction *f, int TokenType)
{  SymbolParam *p;
   
   // create record   
   p = malloc(sizeof(SymbolParam));
   CHECK_NULL(p);

   // add to list
   if(f->Param == NULL) {
      // first in list
      f->Param = p;
   } else {
      // assing to end of list
      SymbolParam *x = f->Param;
      while (x->next != NULL) x = x->next;
      x->next = p;
   }              

   // init                
   p->next = NULL;
   p->Type = TokenType; 
   p->Name = NULL;
   p->CallMethod = 'v'; // default call by value

   return p;
}


//-----------------------------------------------------------------------------
// CreateName - malloc memory, copy name and return pointer
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
char *CreateName(char *Name)
{  char *n;
   
   n = malloc(strlen(Name) + 1);
   CHECK_NULL(n);

   strcpy(n, Name);
   
   return n;
}           

//-----------------------------------------------------------------------------
// SymbolParamSetName -
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void SymbolParamSetName(SymbolParam *p, char *Name)
{
   p->Name = CreateName(Name);   
}
  

  
//-----------------------------------------------------------------------------
// GetSymbolPointer - 
//-----------------------------------------------------------------------------
// from current context or wider.

//-----------------------------------------------------------------------------
Symbol *GetSymbolPointer(Context *co, char *SymbolName, int SymbolType, int IncludeGlobal)
{  Symbol *s;

   if (Verbose > 1) printf("\n// GetSymbolPointer co: %x, SymbolName: %s, Type: %d, IncludeGolbal: %d\n", 
                                   co, SymbolName, SymbolType, IncludeGlobal);

   for (;co != NULL; co=co->Wider) {  

      if (Verbose > 2) printf("\n// GetSymbolPointer co %x\n", co);
                        
      // return if Global scope is not included.   
      if ((co->IsGlobal) && (IncludeGlobal == 0)) return NULL; 

      if (Verbose > 2) printf("// GetSymbolPointer mark 1\n");
         
      for(s = co->Head; s != NULL; s = s->Next) {       

         if (Verbose > 2) printf("\n//    GetSymbolPointer s %x\n", s);
         
         // check name
         if (strcmp(SymbolName, s->Name) != 0) continue;
         if (Verbose > 2) printf("//    GetSymbolPointer mark 2\n");

         // check Type
         if ((s->Type & SymbolType) == 0)  continue;
         if (Verbose > 2) printf("//    GetSymbolPointer mark 3\n");

         // -----         
         // match
         // -----         
         return s;
      }       
   }
   return NULL;  // no match
}
  
void DumpSymbol(Symbol *s)
{  int i;
      
   printf("//\n//   Symbol name: '%s' at %x, Type: %d ", s->Name, s, s->Type);
   switch (s->Type) {
      case S_FUNCTION : {                
         printf("(Function)\n");
         SymbolFunction *f = s->details;
         if (f == NULL) { printf("error: function struct missing\n"); exit(1);}
         printf("//      Function returns %s (%d)\n", VarTypeString(f->ReturnType), f->ReturnType);         
         SymbolParam *p = f->Param;
         for (;;) {
            if (p == NULL) break;
            printf("//      param Name: '%s', Type: %s (%d), CallBy: %c\n",
                  p->Name, jalParserTokenNames[p->Type], p->Type, p->CallMethod);
            p = p->next;    
         }
         break;
      }        
      case S_VAR : {
         printf("(Var)\n");
         Var *v = s->details;
         if (v == NULL) { printf("error: var struct missing\n"); exit(1);}

         if ((v->put == NULL) & (v->get == NULL)) {
            if (v->CallMethod == 0) {
               printf("//      Regular VAR ");
            } else {
               printf("//      Procedure/Function parameter, Type: %s, CallMethod: %c\n",
                     jalParserTokenNames[v->Type], v->CallMethod );
               printf("//         ");
            }               
         } else {
            printf("//      Put: %s, Get: %s, ",
               (v->put  != NULL) ? v->put  : "NULL",   
               (v->get  != NULL) ? v->get  : "NULL");   
         }
         printf(" Data: %s, Size: %d, P1: %d, P2: %d\n",
            (v->data != NULL) ? v->data : "NULL",   
            v->size, v->p1, v->p2); 
         break;
      }
      default : {
         printf("!! Unknown type !!\n");
         break;
      }
   }                 
}                        




//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void DumpContext(Context *co)
{  Symbol *s;
   
   printf("//DumpContext -------------------------------\n");

   for (;;) {

      if (co == NULL) break;

      printf("//\n//Context %x, IsGlobal: %d\n", co, co->IsGlobal);
      
      for(s = co->Head; s != NULL; s = s->Next) {
         if (s== NULL) break;
         //printf("DumpSymbolTable %x\n", s);
         DumpSymbol(s);
      }

      co = co->Wider;
   }         
}


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void SymbolPrintVarTable(Context *co)
{  Symbol *s;
   Var   *v;

   printf("\n\n   // Pseudo Var table\n");   

   for(s = co->Head; s != NULL; s = s->Next) {
      if (s->Type != S_VAR) continue;
      v = s->details;   
      if (v == NULL) { printf("error: var struct missing\n"); exit(1);}
      if ((v->put != NULL) | (v->get != NULL)) {
         printf("   const ByCall __%s = { ",s->Name);
         if (v->put ) printf("(void *)&%s, ", v->put ); else printf("NULL, "); 
         if (v->get ) printf("(void *)&%s, ", v->get ); else printf("NULL, "); 
         if (v->data) printf("(void *)&%s, ", v->data); else printf("NULL, "); 
         printf("%d, %d, %d};\n", v->size, v->p1, v->p2); 
      }
   }              
}


//-----------------------------------------------------------------------------  
// NewSymbolVar - Add new var to current context.
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static Var *NewSymbolVar(Context *co, char *Name)
{  Symbol *s;
   Var *v;
//   static int ID = 0;
   
   if (Verbose > 1) printf("// NewSymbolVar Name: %s\n", Name);
   
   s = NewSymbol(co);
   s->Name = CreateName(Name);
   s->Type = S_VAR;

   v = malloc(sizeof(Var));
   CHECK_NULL(v);

   s->details = v;
   
//   p->ID    = ID++;

   v->Type        = 0;     // undetermined type
   v->CallMethod  = 0;     // 0 = not a param, 'v' = value, 'r' = reference, 'c' = code
   
   v->put         = NULL;   
   v->get         = NULL;   
   v->data        = NULL;   
   v->size        = 1;     // size in bytes, bit values are rounded up.
   v->p1          = 0;
   v->p2          = 0;

   return v;
}

//-----------------------------------------------------------------------------  
// OBSOLETE?? See Symbol *GetSymbolPointer  (Context *co, char *SymbolName, int SymbolType, int IncludeGlobal)
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Var *SymbolGetVar(Context *co, char *SymbolName)
{  Symbol *s;
   Var *v;

   if (Verbose > 1) printf("// SymbolGetVar Name: %s\n", SymbolName);

   for(s = co->Head; s != NULL; s = s->Next) {
//printf("boom %x %x\n", s, s->Name);
      if (s == NULL) { break; }
      if (s->Name == NULL) { break; }  // unnamed identiefier (valid while ad in progress)
      if (Verbose > 1) printf("// SymbolGetVar check Name: %s at %x\n", s->Name, s);
         
      if (strcmp(SymbolName, s->Name) != 0) continue;
//printf("roos\n");
      // name match                            
      if (s->Type == S_VAR) {
         v = s->details;
         return v;
      } else {
         printf("// GetVar: name found with non-var type\n");
      }
   }          
   return NULL;
}

//----------------------------------------------------------------------------- 
// SymbolGetOrNewVar - Find Var record, create if it does not exist.
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Var *SymbolGetOrNewVar(Context *co, char *Name)
{  Var *v;

   if (Verbose > 1) printf("// SymbolGetOrNewVar Name: %s\n", Name);
   
   v = SymbolGetVar(GlobalContext, Name);
   
   if (v == NULL) {
      v = NewSymbolVar(co, Name);
      if (Verbose > 1) printf("// SymbolGetOrAddVar new %x\n", v);
   } else {
      if (Verbose > 1) printf("// SymbolGetOrAddVar found %x\n", v);
   }
      
   return v;   
}

//-----------------------------------------------------------------------------
// SymbolVarAdd_PutName - set PutName value of pseudo-var
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void SymbolVarAdd_PutName(Context *co, char *BaseName, char *PutName)
{  Var *v;

   if (Verbose > 1) printf("// SymbolVarAdd_PutName BaseName: %s, PutName: %s\n", BaseName, PutName);

   v = SymbolGetOrNewVar(co, BaseName);                                              
   if (v == NULL) { printf("Error: PutName pointer v is NULL\n"); exit(1); }
   
   v->put = CreateName(PutName);   
}

//-----------------------------------------------------------------------------    
// SymbolVarAdd_GetName -
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void SymbolVarAdd_GetName(Context *co, char *BaseName, char *GetName)
{  Var *v;

   v = SymbolGetOrNewVar(co, BaseName);
   v->get = CreateName(GetName);
   
}

//-----------------------------------------------------------------------------   
// SymbolVarAdd_DataName - 
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void SymbolVarAdd_DataName(Context *co, char *BaseName, char *DataName)
{  Var *v;
//   printf("SymbolVarAdd_DataName Base: %s, Data: %s\n", BaseName, DataName);

   v = SymbolGetOrNewVar(co, BaseName);                       

   v->data =CreateName(DataName);
} 

//-----------------------------------------------------------------------------
// CreateGlobalContext - create the basis of the global context
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CreateGlobalContext(void)
{ 
   if (GlobalContext) {
      printf("Serious warning: re-create global context\n");
   }
   GlobalContext = NewContext(NULL);
   CHECK_NULL(GlobalContext);
   
   GlobalContext->IsGlobal = 1;  // set global flag in struct
}


//-----------------------------------------------------------------------------
// _AddSymbolToContext - add node to context list
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static void _AddSymbolToContext(Context *co, Symbol *s) {
   if(co->Head == NULL) {
      co->Head = s;
   } else {
      co->Last->Next = s;
   }

   co->Last = s; // save last for easy append
   s->Next = NULL;
}



//-----------------------------------------------------------------------------
// NewContext - Create a new context level
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Context *NewContext(Context *WiderContext)
{  Context *co;

   co = malloc(sizeof(Context));     
   CHECK_NULL(co);

	co->Head       = NULL;  // list of symbols
	co->Last       = NULL;  // end list of symbols
   co->Wider      = WiderContext; 
   
   co->IsGlobal   = 0;     // No global context (default)
}

//-----------------------------------------------------------------------------
// NewSymbol - malloc memory for Symbol stuct & add to chain
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static Symbol *NewSymbol(Context *co)
{  Symbol *s;

   if (Verbose > 1) printf("//NewSymbol\n");
   s = malloc(sizeof(Symbol));
   CHECK_NULL(s);

   _AddSymbolToContext(co, s);

	s->Name = NULL;
	s->Type = 0;    // function, procedure, variable, constant

   if (Verbose > 1) printf("//AddSymbol added %x\n", s);

   return s;
}

