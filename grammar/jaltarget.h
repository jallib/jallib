// ByCall.h - provide access to variables through functions.

typedef struct ByCall_stuct {
// note: param is used for arrays only. leave it out for now
//   void (*put)(struct ByCall_stuct *s, int Param, int Value) ;
//   int  (*get)(struct ByCall_stuct *s, int Param) ;       


   void (*put)(struct ByCall_stuct *s, int Value) ;
   int  (*get)(struct ByCall_stuct *s) ;
   void *data;
   int   Size; // size of type in bytes (round up)
   char  v1;     // var1, implementation-dependent
   char  v2;     // var2, implementation-dependent
} ByCall;




// macro's
// add_put naam, type
// add_get
// -- beide -- instantieer als nodig
//          -- stop translate-time in lijstje en stop dit aan het begin van main.



//// http://www.newty.de/fpt/fpt.html#defi
//
//// 2.1 define a function pointer and initialize to NULL
//int (*pt2Function)(float, char, char) = NULL;                        // C
//
//// C
//int DoIt  (float a, char b, char c){ printf("DoIt\n");   return a+b+c; }
//int DoMore(float a, char b, char c)const{ printf("DoMore\n"); return a-b+c; }
//
//pt2Function = DoIt;      // short form
//pt2Function = &DoMore;   // correct assignment using address operator
//
//// C
//if(pt2Function >0){                           // check if initialized
//   if(pt2Function == &DoIt)
//      printf("Pointer points to DoIt\n"); }
//else
//   printf("Pointer not initialized!!\n");
//
//
//// 2.5 calling a function using a function pointer
//int result1 = pt2Function    (12, 'a', 'b');          // C short way
//int result2 = (*pt2Function) (12, 'a', 'b');          // C
//
//// 2.6 How to Pass a Function Pointer
//
//// <pt2Func> is a pointer to a function which returns an int and takes a float and two char
//void PassPtr(int (*pt2Func)(float, char, char))
//{
//   int result = (*pt2Func)(12, 'a', 'b');     // call using function pointer
//   cout << result << endl;
//}


