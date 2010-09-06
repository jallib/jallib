// jat.h - Just Another Translator - 

#include <stdio.h>   
#include <stdlib.h>
#include <assert.h>



// antlr generated
#include    "jalLexer.h"
#include    "jalParser.h"


#define MAX_FILENAME_SIZE 255 // including path



void TreeWalk(pANTLR3_BASE_TREE p);    
jalParser_program_return ParseSource(pANTLR3_UINT8 fName);


#include    "symboltable.h"

// command line switches
extern int Verbose;    
extern int NoMainParams;
extern int NoInclude;
extern int ToStdOut;  
extern char *IncludePath;  
extern char *Filename;

// more indent levels with verbose:
#define VLEVEL (Verbose > 0 ? 1 : 0) 

// main function prototypes
void TreeWalkWorker(pANTLR3_BASE_TREE p, int Level);
pANTLR3_INPUT_STREAM JalOpenInclude(char *Line);


// parser.c
jalParser_program_return ParseSource(pANTLR3_UINT8 fName);

// output.c
int OpenCodeOut(char *Filename, int Translate);
void CodeOutputEnable(int Flag);
void CodeOutput(int VerboseCategory, char *fmt, ... );
void CodeIndent(int VerboseCategory, int Level);     
int GetFileExtIndex(char *Filename);


#define VERBOSE_ALL 0   // always output (if output stream is on)
#define VERBOSE_M   1   // medium (which is already quite a lot - all tree walking stuff)
#define VERBOSE_L   2   // large  (more details on table searching etc)
#define VERBOSE_XL  3   // extra large  (probably too much ;) )
#define VERBOSE_UNCOND  10
#define VERBOSE_WARNING 11
#define VERBOSE_ERROR   12

// codegen.c        
extern int Pass;
extern int WarningCount;
extern int ErrorCount;

char *VarTypeString(int TokenType);
char *GetUniqueIdentifier(void);
char *DeRefSub(char *InString, char CallMethod);
void PrintJ2cString(char *String);

char *ConvertLiteral(int Type, char *InString);

char *DeReference    (Context *co, char *InString);
char GetCallMethod   (Context *co, char *ParamName);


void CodeGenerate(pANTLR3_BASE_TREE t);

void  CgAlias        (Context *co, pANTLR3_BASE_TREE t, int Level);
int   CgExpression   (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgAssign       (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgCaseValue    (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgCase         (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgFor          (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgWhile        (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgRepeat       (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgSingleVar    (Context *co, pANTLR3_BASE_TREE t, int Level, int VarType, int IsConstant); 
void  CgSingleBitVar (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgVar          (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgParamChilds  (Context *co, pANTLR3_BASE_TREE t, int Level, SymbolParam *p, int VarType);
void  CgParams       (Context *co, pANTLR3_BASE_TREE t, int Level, SymbolFunction *f);
void  CgProcedureDef (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgConst        (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgIf           (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgForever      (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgStatements   (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgProcFuncCall (Context *co, pANTLR3_BASE_TREE t, int Level);
void  CgStatement    (Context *co, pANTLR3_BASE_TREE t, int Level);
char *CgGetAtInfo    (Context *co, pANTLR3_BASE_TREE t, int Level, char **BitLocation);











