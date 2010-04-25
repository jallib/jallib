// symboltable.h

#include <stdio.h>

// size is fixed but large.
#define SYMBOL_NAME_SIZE   60     
#define MAX_NR_PARAMS      20

struct SymbolParam{
   int      Type;	                                                            
	char     Name[SYMBOL_NAME_SIZE];
   char     CallMethod; // v = value, r = reference, c = code
};

typedef struct Symbol_type{
	struct Symbol_type    *Prev;
	struct Symbol_type    *Next;
	
	char     Name[SYMBOL_NAME_SIZE];
	int      Type;    // function, procedure, variable, constant
	                                                            
   int      ReturnType;
   
   int      NrOfParams;     
   
   struct SymbolParam Param[MAX_NR_PARAMS];
} Symbol;

extern pANTLR3_UINT8   jalParserTokenNames[];

                           
void DumpSymbolTable();
Symbol *AddSymbol();                           
Symbol *GetSymbolPointer  (char *SymbolName);


extern Symbol *SymbolTail;  // points to most recent symbol
extern Symbol *SymbolHead;  // points to oldest symbol

