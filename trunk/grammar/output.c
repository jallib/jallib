// Title: output.g
//
// Adapted-by: Joep Suijs
// Compiler: >=2.4m
//
// This file is part of jallib (http://jallib.googlecode.com)
// Released under the ZLIB license (http://www.opensource.org/licenses/zlib-license.html)
//
// Description: output functions for JAT
//

#include "jat.h"

FILE *CODE = NULL;
int CodeOutputFlag = 1;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
int OpenCodeOut(char *Filename) 
{
   CODE = fopen(Filename, "w");     

   if (CODE == NULL) return 0;

   return 1;
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CodeOutputEnable(int Flag)
{
   CodeOutputFlag = Flag;
}
                         
//-----------------------------------------------------------------------------
// CodeOutput - Code output function
//-----------------------------------------------------------------------------
// Outputs to code output stream, when output is enables.
//
//
// Parameters:
// - VerboseCategory - indicates at what verbose level the output has to be
//   included
// - format string + parameters -> like printf
//-----------------------------------------------------------------------------
void CodeOutput(int VerboseCategory, char *fmt, ... ) 
{
   va_list args;                       

   // check if code output is enabled
   if (CodeOutputFlag == 0) return;

   assert(CODE != NULL);
        
   if(VerboseCategory > Verbose) return;
         
   va_start( args, fmt );
   vfprintf(CODE, fmt, args);
   va_end( args );

}   


//-----------------------------------------------------------------------------
// CodeIndent - print indent for code output
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CodeIndent(int VerboseCategory, int Level)
{   int i;
//   Level += 2;   
                
   if ((Pass == 1) && (Level > 0)) Level --;
   CodeOutput(VerboseCategory, "\n");   
   for (i=0; i<Level; i++) CodeOutput(VerboseCategory, "   ");
}                                 
