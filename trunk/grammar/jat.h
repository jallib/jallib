// jat.h - Just Another Translator - 

#include <stdio.h>  

// antlr generated
#include    "jalLexer.h"
#include    "jalParser.h"

#include    "symboltable.h"

#define DEBUG 1
extern int Debug;

// main function prototypes
void Indent(int Level);
void TreeWalkWorker(pANTLR3_BASE_TREE p, int Level);
pANTLR3_INPUT_STREAM JalOpenInclude(char *Line);

// parser.c
jalParser_program_return ParseSource(pANTLR3_UINT8 fName);


// codegen.c
char *VarTypeString(int TokenType);
char *GetUniqueIdentifier(void);
char GetCallMethod(char *ParamName);
char *DeRefSub(char *InString, char CallMethod);
char *DeReference(char *InString);

void CodeGenerate(pANTLR3_BASE_TREE t);

int CgExpression(pANTLR3_BASE_TREE t, int Level);
void CgAssign(pANTLR3_BASE_TREE t, int Level);
void CgCaseValue(pANTLR3_BASE_TREE t, int Level);
void CgCase(pANTLR3_BASE_TREE t, int Level);
void CgFor(pANTLR3_BASE_TREE t, int Level);
void CgWhile(pANTLR3_BASE_TREE t, int Level);
void CgRepeat(pANTLR3_BASE_TREE t, int Level);
void CgSingleVar(pANTLR3_BASE_TREE t, int Level);
void CgVar(pANTLR3_BASE_TREE t, int Level);
void CgParamChilds(pANTLR3_BASE_TREE t, int Level, SymbolParam *p);
void CgParams(pANTLR3_BASE_TREE t, int Level, SymbolFunction *f);
void CgProcedureDef(pANTLR3_BASE_TREE t, int Level);
void CgConst(pANTLR3_BASE_TREE t, int Level);
void CgIf(pANTLR3_BASE_TREE t, int Level);
void CgForever(pANTLR3_BASE_TREE t, int Level);
void CgStatements(pANTLR3_BASE_TREE t, int Level);
void CgFuncProcCall(pANTLR3_BASE_TREE t, int Level);
void CgStatement(pANTLR3_BASE_TREE t, int Level);











