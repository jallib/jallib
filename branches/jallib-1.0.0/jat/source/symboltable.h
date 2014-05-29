// symboltable.h
#include <stdio.h>

// Overall structure:
//    
//    - The context struct contains a list of elements (content).
//    - The context struct optioinal points to a wider context.
//    - The global context is stored separate and should be checks after the widere contexts.
//    (about to implement the above ;)
// 
//    The elements in the list are 'symbol' structs, with name, type and pointer to details.
// 
//    There are two main types of symbols: 
//       - VAR - contains info on a var, can be normal var, pseudo var or both
//       - FUNCTION (or procedure which is function with void return). Function has 
//         a param-struct for each param, used to create the proper fuction call.
//         Each function parameter is also added to the scope within the 
//         function as a VAR. So within the function, use of 'var' covers 
//         local vars, global vars *and* function parameters.
//
//-----------------------------------------------------------------------------
//  RECONSIDERATION (when local scope is required for further processing) 
//
//  Scope is currently modelled as a list of lists. This can be converted to
//  a single list, so each element kind of creates a new scope. If the 
//  scope is single linked (from newest to oldest), storing the most recent 
//  pointer gives - at any point - the relevant scope. This way, the scope 
//  remains available after a tree scan for further processing (assuming the
//  pointers are stored at relevant points in the tree).
//  This will require some rework on the global scope, which is now a single 
//  list but will become a range of symbols. Global scope can't be mixed with
//  local one, since the local one gets 'dropped' (out of scope) later.
//  And.. the global scope need a fixed starting point. So either this 
//  startpoint is in the middle - with global scope growing one way and local
//  the other way - or there is a placeholder for the global scope and new
//  global symbols are added between this placeholder and the previous 
//  global scope. Afaik order of global scope does not matter, so the first
//  is probably most easy (no special placeholder to handle).
//                                                               
// (as a positive side-effect, this will merge the similar concepts 
// of 'scope' and 'symbol list'.)
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Function/Procedure parameter structure
//-----------------------------------------------------------------------------
typedef struct SymbolParam_struct{ 
   struct SymbolParam_struct *next;
   
	char     *Name;

   int      Type;	                                                            
   int      ArraySize;  // 0 = not an array, -1 = undetermined size.
   char     CallMethod; // v = value, r = reference, c = code
} SymbolParam;

//-----------------------------------------------------------------------------
// Function/Procedure struct
//-----------------------------------------------------------------------------
typedef struct SymbolFunction_struct{

   int      ReturnType;   
//   int      NrOfParams;        
   SymbolParam *Param;
   
   
} SymbolFunction;

//-----------------------------------------------------------------------------
// Variable struct 
//-----------------------------------------------------------------------------
typedef struct Var_stuct {          

   // param-related
   int      Type;	                                                            
   int      ArraySize;  // 0 = not an array, -1 = undetermined size.
   char     CallMethod; // 0 = no param, 'v' = value, 'r' = reference, 'c' = code

   char *put;     // put function name
   char *get;     // get function name
   char *data;    // data field name 
   int   size;    // PV data size in bytes (round up)
   char  p1;      // Param1, implementation-dependent
   char  p2;      // Param2, implementation-dependent
} Var;

//-----------------------------------------------------------------------------
// Symbol stuct 
//-----------------------------------------------------------------------------
typedef struct Symbol_type{
	struct Symbol_type    *Next;
	
	char     *Name;
	int      Type;    // function, procedure, variable, constant

   void    *details;
   
} Symbol;

//-----------------------------------------------------------------------------
// Context struct
//-----------------------------------------------------------------------------
typedef struct Context_type{

	Symbol  *Head;
   Symbol  *Last;

   int      IsGlobal;   
	struct Context_type   *Wider; // wider context
	
} Context;


// Types of symbol details
#define S_FUNCTION 1
#define S_VAR      2
#define S_ALIAS    4
#define S_ALL      255


// external vars & prototypes

extern pANTLR3_UINT8   jalParserTokenNames[];
extern Context *GlobalContext;

char *CreateName(char *Name);
                           
                           
void DumpContext(Context *co);
                           
Symbol *GetSymbolPointer(Context *co, char *SymbolName, int SymbolType, int IncludeGlobal);

SymbolParam *SymbolFunctionAddParam(SymbolFunction *f, int TokenType);
void SymbolParamSetName(SymbolParam *p, char *Name);
void DumpSymbol(int VerboseLevel, Symbol *s);
Symbol *NewSymbolFunction(Context *co);
Symbol *NewSymbolAlias(Context *co, char *AliasName, char *AliasTarget);

void SymbolPrintVarTable(Context *co);
Var *SymbolGetVar(Context *co, char *SymbolName);
Var *SymbolGetOrNewVar(Context *co, char *Name);
void SymbolVarAdd_PutName(Context *co, char *BaseName, char *PutName);
void SymbolVarAdd_GetName(Context *co, char *BaseName, char *GetName);
Var *SymbolVarAdd_DataName(Context *co, char *BaseName, char *DataName);

void SymbolPrintVarTableExternals(Context *co, char *Filename);

void CreateGlobalContext(void);

Context *NewContext(Context *WiderContext);


