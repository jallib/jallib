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
//         a param-struct for each param.
     
//-----------------------------------------------------------------------------
// Function/Procedure parameter structure
//-----------------------------------------------------------------------------
typedef struct SymbolParam_struct{ 
   struct SymbolParam_struct *next;
   
   int      Type;	                                                            
	char     *Name;
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


// external vars & prototypes

extern pANTLR3_UINT8   jalParserTokenNames[];
extern Context *GlobalContext;

char *CreateName(char *Name);
                           
void DumpSymbolTable(Context *co);
Symbol *GetSymbolPointer  (Context *co, char *SymbolName);

SymbolParam *SymbolFunctionAddParam(SymbolFunction *f, int TokenType);
void SymbolParamSetName(SymbolParam *p, char *Name);
void DumpSymbol(Symbol *s);
Symbol *NewSymbolFunction(Context *co);

void SymbolPrintVarTable(Context *co);
Var *SymbolGetVar(Context *co, char *SymbolName);
Var *SymbolGetOrNewVar(Context *co, char *Name);
void SymbolVarAdd_PutName(Context *co, char *BaseName, char *PutName);
void SymbolVarAdd_GetName(Context *co, char *BaseName, char *GetName);
void SymbolVarAdd_DataName(Context *co, char *BaseName, char *DataName);


void CreateGlobalContext(void);

Context *NewContext(Context *WiderContext);


