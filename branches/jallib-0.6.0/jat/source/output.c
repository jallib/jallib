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
// GetFileExtIndex - Get location of first char after extension '.'
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
int GetFileExtIndex(char *Filename)
{  int i;
   
   // determine lenght
   for (i=0; Filename[i]; i++);
   if (i > (MAX_FILENAME_SIZE - 3)) {
      printf("Error: filename %s too long to process\n", Filename);
      exit(1);
   }                  
   
   // valid (not to short and with '.' at right place)?
   if ((i<5) || (Filename[i-4] != '.')){
      printf("Error: invalid filename %s\n", Filename);
      exit(1);
   }

   return i-3;
}


//-----------------------------------------------------------------------------
// OpenCodeOut - open file for write
//-----------------------------------------------------------------------------    
// IF Translate THEN change extension from .jal to .c.
//-----------------------------------------------------------------------------
int OpenCodeOut(char *Filename, int Translate)    
{  char String[MAX_FILENAME_SIZE];  
   int i;

   if (ToStdOut) {
      CODE = stdout;
      printf("Output file override - print to stdout\n");
      return;
   }

   if (Translate) {      
      
      //----------------------------------------
      // Translate input filename to output name     
      //----------------------------------------               
      
      if (Verbose) printf("Open1 _%s_\n", Filename); //Note: use printf since we can't use CodeOutput yet...

      i = GetFileExtIndex(Filename);   
   
      // change from '.jal' to '.c'
      strcpy(String, Filename);
      String[i] = 'c';
      String[i+1] = 0;   
   } else {                    
      // use given output filename
      strcpy(String, Filename);
   }
                        
   CODE = fopen(String, "w");     

   if (CODE == NULL) return 0;

   return 1;
}

//-----------------------------------------------------------------------------    
// CodeOutputEnable - enable and disable code, printed through CodeOutput
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
{  static PrevCategory = -1;
   
   va_list args;                       

   if ((VerboseCategory != VERBOSE_UNCOND) && (VerboseCategory != VERBOSE_WARNING) && (VerboseCategory != VERBOSE_ERROR)) {
      // test only in 'normal' mode

      // Is code output enabled?
      if (CodeOutputFlag == 0) return;
      
      // is this important enough?
      if(VerboseCategory > Verbose) return;
   } else {
      // warning/error to stdout too.
      if (CODE != stdout) {
         va_start( args, fmt );
         vfprintf(stdout, fmt, args);
         va_end( args );
      }  
      if (VerboseCategory != PrevCategory) {
         // only on change -> multiple error lines 
         // will probably be related to the same error...
         if (VerboseCategory == VERBOSE_WARNING) {
            WarningCount++;
         }
         if (VerboseCategory == VERBOSE_ERROR) {
            ErrorCount++;
         } 
      }
   }
   PrevCategory = VerboseCategory;
   
   assert(CODE != NULL);
        
   // output to CODE stream         
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
