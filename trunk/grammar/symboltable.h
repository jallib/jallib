// symboltable.h

#include <stdio.h>

// size is fixed but large.
#define MAX_NR_PARAMS      20

// dit is een parameter van een procedure
typedef struct SymbolParam_struct{ 
   struct SymbolParam_struct *next;
   
   int      Type;	                                                            
	char     *Name;
   char     CallMethod; // v = value, r = reference, c = code
} SymbolParam;


// function / procedure related	                                                            
typedef struct SymbolFunction_struct{

   int      ReturnType;   
//   int      NrOfParams;        
   SymbolParam *Param;
   
   
} SymbolFunction;


// pvar related (pseudo-var, volatile)

typedef struct Pvar_stuct {          
   char *put;     // put function name
   char *get;     // get function name
   char *data;    // data field name 
   int   size;    // PV data size in bytes (round up)
   char  p1;      // Param1, implementation-dependent
   char  p2;      // Param2, implementation-dependent
} Pvar;

// main symbol stuct 
typedef struct Symbol_type{
	struct Symbol_type    *Prev;
	struct Symbol_type    *Next;
	
	char     *Name;
	int      Type;    // function, procedure, variable, constant

   void    *details;
   
} Symbol;

extern pANTLR3_UINT8   jalParserTokenNames[];
extern Symbol *SymbolTail;  // points to most recent symbol
extern Symbol *SymbolHead;  // points to oldest symbol

char *CreateName(char *Name);
                           
void DumpSymbolTable(void);
Symbol *GetSymbolPointer  (char *SymbolName);

SymbolParam *SymbolFunctionAddParam(SymbolFunction *f, int TokenType);
void SymbolParamSetName(SymbolParam *p, char *Name);
void DumpSymbol(Symbol *s);
Symbol *NewSymbolFunction(void);



void SymbolPrintPvarTable(void);
Pvar *SymbolGetPvar(char *Name);
Pvar *SymbolGetOrAddPvar(char *Name);
void SymbolPvarAdd_PutName(char *BaseName, char *PutName);
void SymbolPvarAdd_GetName(char *BaseName, char *GetName);
void SymbolPvarAdd_DataName(char *BaseName, char *DataName);





#define S_FUNCTION 1
#define S_PVAR     2
