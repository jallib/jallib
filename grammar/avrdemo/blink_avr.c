// include BaseName: _device_avr_
// Tree :  ;@j2cg #include <avr/io.h> ;@j2cg  ;@j2cg #define F_CPU 16000000 ;@j2cg  ;@j2cg // Some macros that make the code more readable ;@j2cg #define output_low(port,pin) port &= ~(1<<pin) ;@j2cg #define output_high(port,pin) port |= (1<<pin) ;@j2cg #define set_input(portdir,pin) portdir &= ~(1<<pin) ;@j2cg #define set_output(portdir,pin) portdir |= (1<<pin) ;@j2cg         (procedure delay_ms (PARAMS (byte in ms)) (BODY ;@j2c   uint16_t delay_count = F_CPU / 17500; ;@j2c   volatile uint16_t i; ;@j2c  ;@j2c   while (ms != 0) { ;@j2c     for (i=0; i != delay_count; i++); ;@j2c     ms--; ;@j2c   })) (var byte (VAR LED (= 4))) (FUNC_PROC_CALL set_output DDRB LED) (forever (BODY (FUNC_PROC_CALL output_high PORTB LED) (FUNC_PROC_CALL delay_ms 200) (FUNC_PROC_CALL output_low PORTB LED) (FUNC_PROC_CALL delay_ms 200)))
// nil-node
//       (15, INCLUDE_STMT)
//      ;@j2cg #include <avr/io.h> (16, J2CG_COMMENT)
//      ;@j2cg  (16, J2CG_COMMENT)
//      ;@j2cg #define F_CPU 16000000 (16, J2CG_COMMENT)
//      ;@j2cg  (16, J2CG_COMMENT)
//      ;@j2cg // Some macros that make the code more readable (16, J2CG_COMMENT)
//      ;@j2cg #define output_low(port,pin) port &= ~(1<<pin) (16, J2CG_COMMENT)
//      ;@j2cg #define output_high(port,pin) port |= (1<<pin) (16, J2CG_COMMENT)
//      ;@j2cg #define set_input(portdir,pin) portdir &= ~(1<<pin) (16, J2CG_COMMENT)
//      ;@j2cg #define set_output(portdir,pin) portdir |= (1<<pin) (16, J2CG_COMMENT)
//      ;@j2cg         (16, J2CG_COMMENT)
//      procedure (53, L_PROCEDURE)
//         delay_ms (99, IDENTIFIER)
//         PARAMS (8, PARAMS)
//            byte (64, L_BYTE)
//               in (50, L_IN)
//               ms (99, IDENTIFIER)
//         BODY (4, BODY)
//            ;@j2c   uint16_t delay_count = F_CPU / 17500; (17, J2C_COMMENT)
//            ;@j2c   volatile uint16_t i; (17, J2C_COMMENT)
//            ;@j2c  (17, J2C_COMMENT)
//            ;@j2c   while (ms != 0) { (17, J2C_COMMENT)
//            ;@j2c     for (i=0; i != delay_count; i++); (17, J2C_COMMENT)
//            ;@j2c     ms--; (17, J2C_COMMENT)
//            ;@j2c   } (17, J2C_COMMENT)
//      var (61, L_VAR)
//         byte (64, L_BYTE)
//         VAR (9, VAR)
//            LED (99, IDENTIFIER)
//            = (22, ASSIGN)
//               4 (103, DECIMAL_LITERAL)
//      FUNC_PROC_CALL (7, FUNC_PROC_CALL)
//         set_output (99, IDENTIFIER)
//         DDRB (99, IDENTIFIER)
//         LED (99, IDENTIFIER)
//      forever (35, L_FOREVER)
//         BODY (4, BODY)
//            FUNC_PROC_CALL (7, FUNC_PROC_CALL)
//               output_high (99, IDENTIFIER)
//               PORTB (99, IDENTIFIER)
//               LED (99, IDENTIFIER)
//            FUNC_PROC_CALL (7, FUNC_PROC_CALL)
//               delay_ms (99, IDENTIFIER)
//               200 (103, DECIMAL_LITERAL)
//            FUNC_PROC_CALL (7, FUNC_PROC_CALL)
//               output_low (99, IDENTIFIER)
//               PORTB (99, IDENTIFIER)
//               LED (99, IDENTIFIER)
//            FUNC_PROC_CALL (7, FUNC_PROC_CALL)
//               delay_ms (99, IDENTIFIER)
//               200 (103, DECIMAL_LITERAL)


// Jal -> C code converter
#include <stdio.h>

#include <stdint.h>

         // CgStatement
         //  (15, INCLUDE_STMT)
         // CgStatement Unsupported statement  (15, INCLUDE_STMT)
         // CgStatement
         // ;@j2cg #include <avr/io.h> (16, J2CG_COMMENT)
           #include <avr/io.h>
         // CgStatement
         // ;@j2cg  (16, J2CG_COMMENT)
           
         // CgStatement
         // ;@j2cg #define F_CPU 16000000 (16, J2CG_COMMENT)
           #define F_CPU 16000000
         // CgStatement
         // ;@j2cg  (16, J2CG_COMMENT)
           
         // CgStatement
         // ;@j2cg // Some macros that make the code more readable (16, J2CG_COMMENT)
           // Some macros that make the code more readable
         // CgStatement
         // ;@j2cg #define output_low(port,pin) port &= ~(1<<pin) (16, J2CG_COMMENT)
           #define output_low(port,pin) port &= ~(1<<pin)
         // CgStatement
         // ;@j2cg #define output_high(port,pin) port |= (1<<pin) (16, J2CG_COMMENT)
           #define output_high(port,pin) port |= (1<<pin)
         // CgStatement
         // ;@j2cg #define set_input(portdir,pin) portdir &= ~(1<<pin) (16, J2CG_COMMENT)
           #define set_input(portdir,pin) portdir &= ~(1<<pin)
         // CgStatement
         // ;@j2cg #define set_output(portdir,pin) portdir |= (1<<pin) (16, J2CG_COMMENT)
           #define set_output(portdir,pin) portdir |= (1<<pin)
         // CgStatement
         // ;@j2cg         (16, J2CG_COMMENT)
                  
         // CgStatement
         // procedure (53, L_PROCEDURE)
            // CgProcedureDef
//AddSymbol
            void  delay_ms ( // proc/func name
                           // CgParams
                uint8_t // 64
// set ParamType
                  // CgParamChilds
                   ms 
// param,
            ) { // body
                  // CgStatement
                  // ;@j2c   uint16_t delay_count = F_CPU / 17500; (17, J2C_COMMENT)
                      uint16_t delay_count = F_CPU / 17500;
                  // CgStatement
                  // ;@j2c   volatile uint16_t i; (17, J2C_COMMENT)
                      volatile uint16_t i;
                  // CgStatement
                  // ;@j2c  (17, J2C_COMMENT)
                    
                  // CgStatement
                  // ;@j2c   while (ms != 0) { (17, J2C_COMMENT)
                      while (ms != 0) {
                  // CgStatement
                  // ;@j2c     for (i=0; i != delay_count; i++); (17, J2C_COMMENT)
                        for (i=0; i != delay_count; i++);
                  // CgStatement
                  // ;@j2c     ms--; (17, J2C_COMMENT)
                        ms--;
                  // CgStatement
                  // ;@j2c   } (17, J2C_COMMENT)
                      }
            } // end body
         // CgStatement
         // var (61, L_VAR)
            // CgVar
             uint8_t 
                           // CgSingleVar
                LED 
               = // assign
                  // CgExpression
                  4 // constant or identifier 
                           ;
         // CgStatement
         // FUNC_PROC_CALL (7, FUNC_PROC_CALL)
         // CgStatement
         // forever (35, L_FOREVER)
int main(int argc, char **argv) {
         // CgStatement
         //  (15, INCLUDE_STMT)
         // CgStatement Unsupported statement  (15, INCLUDE_STMT)
         // CgStatement
         // ;@j2cg #include <avr/io.h> (16, J2CG_COMMENT)
         // CgStatement
         // ;@j2cg  (16, J2CG_COMMENT)
         // CgStatement
         // ;@j2cg #define F_CPU 16000000 (16, J2CG_COMMENT)
         // CgStatement
         // ;@j2cg  (16, J2CG_COMMENT)
         // CgStatement
         // ;@j2cg // Some macros that make the code more readable (16, J2CG_COMMENT)
         // CgStatement
         // ;@j2cg #define output_low(port,pin) port &= ~(1<<pin) (16, J2CG_COMMENT)
         // CgStatement
         // ;@j2cg #define output_high(port,pin) port |= (1<<pin) (16, J2CG_COMMENT)
         // CgStatement
         // ;@j2cg #define set_input(portdir,pin) portdir &= ~(1<<pin) (16, J2CG_COMMENT)
         // CgStatement
         // ;@j2cg #define set_output(portdir,pin) portdir |= (1<<pin) (16, J2CG_COMMENT)
         // CgStatement
         // ;@j2cg         (16, J2CG_COMMENT)
         // CgStatement
         // procedure (53, L_PROCEDURE)
         // CgStatement
         // var (61, L_VAR)
         // CgStatement
         // FUNC_PROC_CALL (7, FUNC_PROC_CALL)
            // CgFuncProcCall
             set_output(
               // CgExpression
               DDRB // constant or identifier 
,               // CgExpression
               LED // constant or identifier 
            ); // end of proc/func call
         // CgStatement
         // forever (35, L_FOREVER)
            // CgForever
             for (;;) {
                  // CgStatement
                  // FUNC_PROC_CALL (7, FUNC_PROC_CALL)
                     // CgFuncProcCall
                      output_high(
                        // CgExpression
                        PORTB // constant or identifier 
,                        // CgExpression
                        LED // constant or identifier 
                     ); // end of proc/func call
                  // CgStatement
                  // FUNC_PROC_CALL (7, FUNC_PROC_CALL)
                     // CgFuncProcCall
                      delay_ms(
                        // CgExpression
                        200 // constant or identifier 
                     ); // end of proc/func call
                  // CgStatement
                  // FUNC_PROC_CALL (7, FUNC_PROC_CALL)
                     // CgFuncProcCall
                      output_low(
                        // CgExpression
                        PORTB // constant or identifier 
,                        // CgExpression
                        LED // constant or identifier 
                     ); // end of proc/func call
                  // CgStatement
                  // FUNC_PROC_CALL (7, FUNC_PROC_CALL)
                     // CgFuncProcCall
                      delay_ms(
                        // CgExpression
                        200 // constant or identifier 
                     ); // end of proc/func call
            }
} // end of main
// Jal -> C END

//Symbol name: delay_ms return: L_VOID, Params: 1
//   param 0 Name: ms, Type: L_BYTE (64), Ref: 0
