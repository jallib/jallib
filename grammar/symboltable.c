// symboltable.c

#include <stdio.h>
#include "jalLexer.h"
#include "jalParser.h"

#include "symboltable.h"

Symbol *SymbolTail= NULL;  // points to most recent symbol
Symbol *SymbolHead = NULL; // points to oldest symbol

void append_node(Symbol *lnode);

//-----------------------------------------------------------------------------
// AddSymbol - malloc memory for Symbol stuct & add to chain
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Symbol *AddSymbol()
{  Symbol *s;

   printf("//AddSymbol\n");
   s = malloc(sizeof(Symbol));
   if (s == NULL) {
      printf("Out of memory error\n");
      exit(0);
   }

   append_node(s);

	s->Name[0] = 0;
	s->Type = 0;    // function, procedure, variable, constant

   s->ReturnType = L_VOID;
   s->NrOfParams = 0;

   return s;
}

void DumpSymbol(Symbol *s)
{  int i;
      
   printf("//Symbol name: %s return: %s, Params: %d\n", s->Name, jalParserTokenNames[s->ReturnType], s->NrOfParams);
   for (i=0; i<s->NrOfParams; i++) {
      printf("//   param %d Name: %s, Type: %s (%d), Ref: %d\n",
            i, s->Param[i].Name, jalParserTokenNames[s->Param[i].Type], s->Param[i].Type, s->Param[i].IsReference);
   }
}


void DumpSymbolTable()
{  Symbol *s;
   int i;
      
   for(s = SymbolHead; s != NULL; s = s->Next) {
      DumpSymbol(s);
   }
}

// /* destroy the dll list */
// while(head != NULL)
//  remove_node(head);

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void append_node(Symbol *lnode) {
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
void insert_node(Symbol *lnode, Symbol *after) {
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
void remove_node(Symbol *lnode) {
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
