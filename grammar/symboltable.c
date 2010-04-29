// symboltable.c

#include "jat.h"


Symbol *SymbolTail= NULL;  // points to most recent symbol
Symbol *SymbolHead = NULL; // points to oldest symbol

// static prototypes
static void append_node(Symbol *lnode);
static void remove_node(Symbol *lnode);
static void insert_node(Symbol *lnode, Symbol *after); 

static Symbol *AddSymbol(void);                           


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Symbol *NewSymbolFunction(void)
{  Symbol *s;
   SymbolFunction *f;
   
   s = AddSymbol();
   s->Name = NULL; //CreateName(Name);
   s->Type = S_FUNCTION;
            
   f = malloc(sizeof(SymbolFunction));
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
// AddSymbol - malloc memory for Symbol stuct & add to chain
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static Symbol *AddSymbol()
{  Symbol *s;

   if (Verbose > 1) printf("//AddSymbol\n");
   s = malloc(sizeof(Symbol));
   if (s == NULL) {
      printf("Out of memory error\n");
      exit(1);
   }

   append_node(s);

	s->Name = NULL;
	s->Type = 0;    // function, procedure, variable, constant

   if (Verbose > 1) printf("//AddSymbol added %x\n", s);

   return s;
}

//-----------------------------------------------------------------------------
// CreateName - malloc memory, copy name and return pointer
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
char *CreateName(char *Name)
{  char *n;
   
   n = malloc(strlen(Name) + 1);
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
  

  
Symbol *GetSymbolPointer  (char *SymbolName)
{  Symbol *s;
   
   for(s = SymbolHead; s != NULL; s = s->Next) {
      if (strcmp(SymbolName, s->Name) != 0) continue;

      // match
      return s;
   }       
   
   return NULL;
}
  
void DumpSymbol(Symbol *s)
{  int i;
      
   printf("//\n//Symbol name: '%s' at %x, Type: %d ", s->Name, s, s->Type);
   switch (s->Type) {
      case S_FUNCTION : {                
         printf("(Function)\n");
         SymbolFunction *f = s->details;
         if (f == NULL) { printf("error: function struct missing\n"); exit(1);}
         printf("//   Function returns %s (%d)\n", VarTypeString(f->ReturnType), f->ReturnType);         
         SymbolParam *p = f->Param;
         for (;;) {
            if (p == NULL) break;
            printf("//   param Name: '%s', Type: %s (%d), CallBy: %c\n",
                  p->Name, jalParserTokenNames[p->Type], p->Type, p->CallMethod);
            p = p->next;    
         }
         break;
      }        
      case S_PVAR : {
         printf("(Pvar)\n");
         Pvar *v = s->details;
         if (v == NULL) { printf("error: var struct missing\n"); exit(1);}

         if ((v->put == NULL) & (v->get == NULL)) {
            printf("//   Regular VAR ");
         } else {
            printf("//   Put: %s, Get: %s, ",
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



void DumpSymbolTable()
{  Symbol *s;
      
   for(s = SymbolHead; s != NULL; s = s->Next) {
      if (s== NULL) break;
      //printf("DumpSymbolTable %x\n", s);
      DumpSymbol(s);
   }
}

// /* destroy the dll list */
// while(head != NULL)
//  remove_node(head);

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static void append_node(Symbol *lnode) {
   if(SymbolHead == NULL) {
      SymbolHead = lnode;
      lnode->Prev = NULL;
   } else {
      SymbolTail->Next = lnode;
      lnode->Prev = SymbolTail;
   }

   SymbolTail = lnode;
   lnode->Next = NULL;
}


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static void insert_node(Symbol *lnode, Symbol *after) 
{
   lnode->Next = after->Next;
   lnode->Prev = after;

   if(after->Next != NULL) {
      after->Next->Prev = lnode;
   } else {
     SymbolTail = lnode;
   }
   after->Next = lnode;
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static void remove_node(Symbol *lnode) 
{
   if(lnode->Prev == NULL) {
      SymbolHead = lnode->Next;
   } else {
      lnode->Prev->Next = lnode->Next;
   }
   if(lnode->Next == NULL) {
      SymbolTail = lnode->Prev;
   } else {
      lnode->Next->Prev = lnode->Prev;
   }
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void SymbolPrintPvarTable()
{  Symbol *s;
   Pvar   *v;

   printf("\n\n   // Pseudo Var table\n");   

   for(s = SymbolHead; s != NULL; s = s->Next) {
      if (s->Type != S_PVAR) continue;
      v = s->details;   
      if (v == NULL) { printf("error: var struct missing\n"); exit(1);}
      if ((v->put != NULL) | (v->get != NULL)) {
         printf("   const ByCall __%s = { (void *)&%s, (void *)&%s, &%s, %d, %d, %d};\n",
            s->Name, v->put, v->get, v->data, v->size, v->p1, v->p2); 
      }
   }              
}


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static Pvar *AddPvar(char *Name)
{  Symbol *s;
   Pvar *p;
//   static int ID = 0;
   
   if (Verbose > 1) printf("// AddPvar Name: %s\n", Name);
   
   s = AddSymbol();
   s->Name = CreateName(Name);
   s->Type = S_PVAR;

   p = malloc(sizeof(Pvar));
   s->details = p;
   
//   p->ID    = ID++;
   
   p->put      = NULL;   
   p->get      = NULL;   
   p->data     = NULL;   
   p->size     = 1;
   p->p1       = 0;
   p->p2       = 0;

   return p;
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Pvar *SymbolGetPvar(char *SymbolName)
{  Symbol *s;
   Pvar *p;

   if (Verbose > 1) printf("// SymbolGetPvar Name: %s\n", SymbolName);

   for(s = SymbolHead; s != NULL; s = s->Next) {
//printf("boom %x %x\n", s, s->Name);
      if (s == NULL) { break; }
      if (s->Name == NULL) { break; }  // unnamed identiefier (valid while ad in progress)
      if (Verbose > 1) printf("// SymbolGetPvar check Name: %s at %x\n", s->Name, s);
         
      if (strcmp(SymbolName, s->Name) != 0) continue;
//printf("roos\n");
      // name match                            
      if (s->Type == S_PVAR) {
         p = s->details;
         return p;
      } else {
         printf("// GetPvar: name found with non-pvar type\n");
      }
   }          
   return NULL;
}

//----------------------------------------------------------------------------- 
// SymbolGetOrAddPvar - Find Pvar record, create if it does not exist.
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Pvar *SymbolGetOrAddPvar(char *Name)
{  Pvar *p;

   if (Verbose > 1) printf("// SymbolGetOrAddPvar Name: %s\n", Name);
   
   p = SymbolGetPvar(Name);
   
   if (p == NULL) {
      p = AddPvar(Name);
      if (Verbose > 1) printf("// SymbolGetOrAddPvar new %x\n", p);
   } else {
      if (Verbose > 1) printf("// SymbolGetOrAddPvar found %x\n", p);
   }
      
   return p;   
}

//-----------------------------------------------------------------------------
// SymbolPvarAdd_PutName - set PutName value of pseudo-var
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void SymbolPvarAdd_PutName(char *BaseName, char *PutName)
{  Pvar *p;

   if (Verbose > 1) printf("// SymbolPvarAdd_PutName BaseName: %s, PutName: %s\n", BaseName, PutName);

   p = SymbolGetOrAddPvar(BaseName);                                              
   if (p == NULL) { printf("Error: PutName pointer p is NULL\n"); exit(1); }
   
   p->put = CreateName(PutName);   
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void SymbolPvarAdd_GetName(char *BaseName, char *GetName)
{  Pvar *p;

   p = SymbolGetOrAddPvar(BaseName);
   p->get = CreateName(GetName);
   
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void SymbolPvarAdd_DataName(char *BaseName, char *DataName)
{  Pvar *p;
//   printf("SymbolPvarAdd_DataName Base: %s, Data: %s\n", BaseName, DataName);

   p = SymbolGetOrAddPvar(BaseName);

   p->data =CreateName(DataName);
   
}
