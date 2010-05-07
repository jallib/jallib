// ByCall.h - provide access to variables through functions.

typedef struct ByCall_stuct {
// note: param is used for arrays only. leave it out for now
//   void (*put)(struct ByCall_stuct *s, int Param, int Value) ;
//   int  (*get)(struct ByCall_stuct *s, int Param) ;       


   void (*put)(const struct ByCall_stuct *s, char* Addr, int Value) ;
   int  (*get)(const struct ByCall_stuct *s, char* Addr) ;
   void *data;
   int   Size; // size of type in bytes (round up)
   char  v1;     // var1, implementation-dependent
   char  v2;     // var2, implementation-dependent
} ByCall;

//( alpha__bc->get ?(*alpha__bc->get)(alpha__bc, alpha__p) :  ( alpha__bc->data ? *(uint8_t *)alpha__bc->data : 0)));

#define PVAR_GET(type, bc, p)    \
(                                \
   bc->get ?                     \
      (*bc->get)(bc, p)          \
   : (                           \
      bc->data ?                 \
         *(type *)bc->data       \
      :                          \
         0                       \
   )                             \
)                                \
                                               
#define PVAR_ASSIGN(type, bc, p, expr)        \
   if (bc->put) (*bc->put)(bc, p, expr)

#define PVAR_DIRECT (ByCall *)NULL, (char *)NULL                                               


void     byte__put(ByCall *bc, void *Addr, uint32_t Data)   { *(uint8_t  *)Addr = (uint8_t)   Data; }
uint32_t byte__get(ByCall *bc, void *Addr)                  { return (uint32_t)  *(uint8_t  *)Addr; }

void     word__put(ByCall *bc, void *Addr, uint32_t Data)   { *(uint16_t *)Addr = (uint16_t)  Data; }
uint32_t word__get(ByCall *bc, void *Addr)                  { return (uint32_t)  *(uint16_t *)Addr; }

void     dword__put(ByCall *bc, void *Addr, uint32_t Data)  { *(uint32_t *)Addr = (uint32_t)  Data; }
uint32_t dword__get(ByCall *bc, void *Addr)                 { return (uint32_t)  *(uint32_t *)Addr; }


const ByCall bc_byte  = { (void *) &byte__put, (void *) &byte__get, NULL, 1, 0, 0};
const ByCall bc_word  = { (void *) &word__put, (void *) &word__get, NULL, 2, 0, 0};
const ByCall bc_dword = { (void *)&dword__put, (void *)&dword__get, NULL, 4, 0, 0};


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


