// symboltable.c

#include "jat.h"

Context *GlobalContext = NULL;

// static prototypes
static void _AddSymbolToContext(Context *co, Symbol *s);
static Symbol *NewSymbol(Context *co);                           

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
   assert(f != NULL);
   
   s->details = f;
   
   f->ReturnType = L_VOID;   
//   f->NrOfParams = 0;        
   f->Param      = NULL;

   return s;
}

//----------------------------------------------------------------------------- 
// NewSymbolAlias - add an ALIAS record to symbol table
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Symbol *NewSymbolAlias(Context *co, char *AliasName, char *AliasTarget)
{  Symbol *s;
   SymbolFunction *f;

   Symbol *Target;

   // make sure alias name does not exists
   s = GetSymbolPointer(co, AliasName, S_ALL, 1);   
   if (s != NULL) {
      printf("warning adding alias '%s' - Symbol already exists\n", AliasName);
      CodeOutput(VERBOSE_ALL, "// waring adding alias '%s' - Symbol already exists\n", AliasName);
//      ErrorCount++;
//      return NULL;
   }

   // find alias target
   Target = GetSymbolPointer(co, AliasTarget, S_ALL, 1);   
   if (Target == NULL) {
      printf("Error adding alias '%s' - Target '%s' does not exist\n", AliasName, AliasTarget);
      CodeOutput(VERBOSE_ALL, "// Error adding alias '%s' - Target '%s' does not exist\n", AliasName, AliasTarget);
      ErrorCount++;
      return NULL;
   }

   // add alias      
   s = NewSymbol(co);
   s->Name = CreateName(AliasName);
   s->Type = S_ALIAS;
   s->details = Target;  // details points to symbol record.
   
   return s;
}


// add paramter record to function-def
SymbolParam *SymbolFunctionAddParam(SymbolFunction *f, int TokenType)
{  SymbolParam *p;
   
   // create record   
   p = malloc(sizeof(SymbolParam));
   assert(p != NULL);

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
   p->Name = NULL;
   p->Type = TokenType; 
   p->ArraySize  = 0;   // 0 not an array, -1 = undetermined size.
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
   assert(n != NULL);

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
// GetSymbolPointer - find record for name, restricted by type.
//-----------------------------------------------------------------------------
// from current context or wider.
//-----------------------------------------------------------------------------
Symbol *GetSymbolPointer(Context *co, char *SymbolName, int SymbolType, int IncludeGlobal)
{  Symbol *s;

   CodeOutput(VERBOSE_L, "\n// GetSymbolPointer params co: %x, SymbolName: %s, Type: %d, IncludeGolbal: %d\n", 
                                   co, SymbolName, SymbolType, IncludeGlobal);

   for (;co != NULL; co=co->Wider) {  

      CodeOutput(VERBOSE_XL, "\n// GetSymbolPointer co %x\n", co);
                        
      // return if Global scope is not included.   
      if ((co->IsGlobal) && (IncludeGlobal == 0)) return NULL; 

      CodeOutput(VERBOSE_XL, "// GetSymbolPointer mark 1\n");
         
      for(s = co->Head; s != NULL; s = s->Next) {       

         CodeOutput(VERBOSE_XL, "\n//    GetSymbolPointer s %x\n", s);
         
         // check name
         if (strcmp(SymbolName, s->Name) != 0) continue;
         CodeOutput(VERBOSE_XL, "//    GetSymbolPointer mark 2\n");

         // check Type
         if ((s->Type & SymbolType) == 0)  continue;
         CodeOutput(VERBOSE_XL, "//    GetSymbolPointer mark 3\n");

         // -----         
         // match
         // -----         
         for (;;) {
            // alias resolving
            if (s->Type == S_ALIAS) {
               CodeOutput(VERBOSE_XL, "// alias resolve step\n");
               DumpSymbol(VERBOSE_XL, s);
               s = s->details;
            } else {
               break;
            }
         }
         CodeOutput(VERBOSE_L, "// matched symbol:\n");
         DumpSymbol(VERBOSE_L, s);
         return s;
      }       
   }
   return NULL;  // no match
}
  
void DumpSymbol(int VerboseLevel, Symbol *s)
{  int i;
      
   CodeOutput(VerboseLevel,"//\n//   Symbol name: '%s' at %x, Type: %d ", s->Name, s, s->Type);
   switch (s->Type) {
      case S_FUNCTION : {                
         CodeOutput(VerboseLevel, "(Function)\n");
         SymbolFunction *f = s->details; 
         assert(f != NULL); // error: function struct missing
         CodeOutput(VerboseLevel, "//      Function returns %s (%d)\n", VarTypeString(f->ReturnType), f->ReturnType);         
         SymbolParam *p = f->Param;
         for (;;) {
            if (p == NULL) break;
            CodeOutput(VerboseLevel, "//      param Name: '%s', Type: %s (%d), CallBy: %c\n",
                  p->Name, jalParserTokenNames[p->Type], p->Type, p->CallMethod);
            p = p->next;    
         }
         break;
      }        
      case S_VAR : {
         CodeOutput(VerboseLevel, "(Var)\n");
         Var *v = s->details;
         assert(v != NULL); // error: var struct missing

         if (v->ArraySize) {
            if (v->ArraySize > 0) {
               CodeOutput(VerboseLevel, "//      Array size %d elements\n", v->ArraySize);
            } else {
               CodeOutput(VerboseLevel, "//      Array of unspecified size\n");
            }
         }

         if ((v->put == NULL) & (v->get == NULL)) {
            if (v->CallMethod == 0) {
               // no put, no get, no call method => regular var
               CodeOutput(VerboseLevel, "//      Regular VAR, type %s", jalParserTokenNames[v->Type]);
            } else {
               CodeOutput(VerboseLevel, "//      Procedure/Function parameter, Type: %s, CallMethod: %c\n",
                     jalParserTokenNames[v->Type], v->CallMethod );
               CodeOutput(VerboseLevel, "//         ");
            }               
         } else {
            CodeOutput(VerboseLevel, "//      Put: %s, Get: %s, Type: %s",
               (v->put  != NULL) ? v->put  : "NULL",   
               (v->get  != NULL) ? v->get  : "NULL",
               jalParserTokenNames[v->Type]);   
         }
         CodeOutput(VerboseLevel, " Data: %s, Size: %d, P1: %d, P2: %d\n",
            (v->data != NULL) ? v->data : "NULL",   
            v->size, v->p1, v->p2); 
         break;
      }
      case S_ALIAS : {
         CodeOutput(VerboseLevel, "Alias\n");
         break;
      }

      default : {
         CodeOutput(VerboseLevel, "!! Unknown type !!\n");
         break;
      }
   }                 
}                        




//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void DumpContext(Context *co)
{  Symbol *s;
   
   CodeOutput(VERBOSE_ALL, "\n//DumpContext -------------------------------\n");

   for (;;) {

      if (co == NULL) break;

      CodeOutput(VERBOSE_ALL, "//\n//Context %x, IsGlobal: %d\n", co, co->IsGlobal);
      
      for(s = co->Head; s != NULL; s = s->Next) {
         if (s== NULL) break;
         //CodeOutput(VERBOSE_ALL, "DumpSymbolTable %x\n", s);
         DumpSymbol(VERBOSE_ALL, s);
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

   CodeOutput(VERBOSE_M, "\n\n   // Pseudo Var table");   

   for(s = co->Head; s != NULL; s = s->Next) {
      if (s->Type != S_VAR) continue;
      v = s->details;   
      assert(v != NULL); // error: var struct missing
      if ((v->put != NULL) | (v->get != NULL)) {
         CodeIndent(VERBOSE_ALL, 1);
         CodeOutput(VERBOSE_ALL, "   const ByCall %s__bcs = { ",s->Name);
         if (v->put ) {
            CodeOutput(VERBOSE_ALL, "(void *)&%s, ", v->put ); 
          } else {
// TODO add proper type here.            
            CodeOutput(VERBOSE_ALL, "(void *)&byte__put, "); 
         }
         if (v->get ) {
            CodeOutput(VERBOSE_ALL, "(void *)&%s, ", v->get ); 
         } else {
// TODO add proper type here.            
            CodeOutput(VERBOSE_ALL, "(void *)&byte__get, "); 
         }
//         if (v->data) CodeOutput(VERBOSE_ALL, "(void *)&%s, ", v->data); else CodeOutput(VERBOSE_ALL, "NULL, "); 
         CodeOutput(VERBOSE_ALL, "%d, %d, %d};", v->size, v->p1, v->p2); 

         CodeIndent(VERBOSE_ALL, 1);
         CodeOutput(VERBOSE_ALL, "   const ByCall *%s__bc = &%s__bcs; ",s->Name ,s->Name);


         CodeIndent(VERBOSE_ALL, 1);
         if (v->data) {
            CodeOutput(VERBOSE_ALL, "   char *%s__p = &%s;", s->Name, v->data);
         } else {
            CodeOutput(VERBOSE_ALL, "   char *%s__p = NULL;", s->Name);
         }
         CodeOutput(VERBOSE_M,   " // pointer to actual data-field (if there is one)");
      }
   }              
   CodeIndent(VERBOSE_ALL, 1);
}

//-----------------------------------------------------------------------------
// SymbolPrintVarTableExternals - print these externals to include file
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void SymbolPrintVarTableExternals(Context *co, char *Filename)
{  Symbol *s;
   Var   *v;
   
   FILE *fp;
   int i;
   char String[MAX_FILENAME_SIZE];


   // create .h filename
   i = GetFileExtIndex(Filename);
   strcpy(String, Filename);
   String[i] = 'h';
   String[i+1] = 0;   
   
             
   CodeOutput(VERBOSE_M, "\n\n   // Pseudo Var table created in %s", String);   
   
   fp = fopen(String, "w");     
   assert(fp != NULL);

   fprintf(fp, "//-----------------------------------------------------------------------------\n");                       
   fprintf(fp, "// %s - Pseudo Var table (generated code)\n//\n", String);   
   fprintf(fp, "//-----------------------------------------------------------------------------\n");                       
   fprintf(fp, "// note: these vars are not realy extern to the master file,\n");
   fprintf(fp, "//       but will be defined later...\n");
   fprintf(fp, "//-----------------------------------------------------------------------------\n\n");                       

   for(s = co->Head; s != NULL; s = s->Next) {
      if (s->Type != S_VAR) continue;
      v = s->details;   
      assert(v != NULL); // error: var struct missing
      if ((v->put != NULL) | (v->get != NULL)) {
         fprintf(fp, "extern const ByCall *%s__bc;\n",s->Name);
      }
   }
   fprintf(fp, "\n// Generated code end\n", String);   

}



//-----------------------------------------------------------------------------  
// NewSymbolVar - Add new var to current context.
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static Var *NewSymbolVar(Context *co, char *Name)
{  Symbol *s;
   Var *v;
//   static int ID = 0;
   
   CodeOutput(VERBOSE_L, "// NewSymbolVar Name: %s\n", Name);
   
   s = NewSymbol(co);
   s->Name = CreateName(Name);
   s->Type = S_VAR;

   v = malloc(sizeof(Var));
   assert(v != NULL);

   s->details = v;
   
//   p->ID    = ID++;

   v->Type        = 0;     // undetermined type    
   v->ArraySize   = 0;     // not an array, -1 = undetermined size.
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

   CodeOutput(VERBOSE_L, "// SymbolGetVar Name: %s\n", SymbolName);

   for(s = co->Head; s != NULL; s = s->Next) {

      if (s == NULL) { break; }
      if (s->Name == NULL) { break; }  // unnamed identiefier (valid while ad in progress)
      CodeOutput(VERBOSE_L, "// SymbolGetVar check Name: %s at %x\n", s->Name, s);
         
      if (strcmp(SymbolName, s->Name) != 0) continue;

      // name match                            
      if (s->Type == S_VAR) {
         v = s->details;
         return v;
      } else {
         CodeOutput(VERBOSE_ALL, "// GetVar: name found with non-var type\n");
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

   CodeOutput(VERBOSE_L, "// SymbolGetOrNewVar Name: %s\n", Name);
   
   v = SymbolGetVar(GlobalContext, Name);
   
   if (v == NULL) {
      v = NewSymbolVar(co, Name);
      CodeOutput(VERBOSE_L, "// SymbolGetOrAddVar new %x\n", v);
   } else {
      CodeOutput(VERBOSE_L, "// SymbolGetOrAddVar found %x\n", v);
   }
      
   return v;   
}

//-----------------------------------------------------------------------------
// SymbolVarAdd_PutName - set PutName value of pseudo-var
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void SymbolVarAdd_PutName(Context *co, char *BaseName, char *PutName)
{  Var *v;

   CodeOutput(VERBOSE_L, "// SymbolVarAdd_PutName BaseName: %s, PutName: %s\n", BaseName, PutName);

   v = SymbolGetOrNewVar(co, BaseName);                                              
   assert(v != NULL); // Error: PutName pointer v is NULL
   
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
// SymbolVarAdd_DataName - lookup/create record and add name
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Var *SymbolVarAdd_DataName(Context *co, char *BaseName, char *DataName)
{  Var *v;

   CodeOutput(VERBOSE_L, "\n// SymbolVarAdd_DataName Base: %s, Data: %s\n", BaseName, DataName);

   v = SymbolGetOrNewVar(co, BaseName);                       
   
   v->data =CreateName(DataName);
   
   return v;
} 

//-----------------------------------------------------------------------------
// CreateGlobalContext - create the basis of the global context
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CreateGlobalContext(void)
{ 
   if (GlobalContext) {
      CodeOutput(VERBOSE_ALL, "Serious warning: re-create global context\n");
   }
   GlobalContext = NewContext(NULL);
   assert(GlobalContext != NULL);
   
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
   assert(co != NULL);

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

   CodeOutput(VERBOSE_L, "//NewSymbol\n");
   s = malloc(sizeof(Symbol));
   assert(s != NULL);

   _AddSymbolToContext(co, s);

	s->Name = NULL;
	s->Type = 0;    // function, procedure, variable, constant

   CodeOutput(VERBOSE_L, "//AddSymbol added %x\n", s);

   return s;
}

