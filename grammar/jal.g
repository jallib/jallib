// Title: jal.g
// Author:  Joep Suijs, William Welch, Copyright (C) 2010  
// Adapted-by:
// Compiler: >=2.4m
//
// This file is part of jallib (http://jallib.googlecode.com)
// Released under the ZLIB license (http://www.opensource.org/licenses/zlib-license.html)
//
// Description: antlr3 grammar definition of JAL
//
//
// 
// you may prefer to view this file from the 'ANTLRWorks' GUI tool, 
// which is a single Java 'jar' file, from here: http://www.antlr.org/works/index.html
//
// If you want to run the test program, jaltest.py, then you need to 
// generate the lexer and parser first, like this:
//    java -cp antlr-3.1.2.jar org.antlr.Tool jal.g 
// js: note grammar is for Java client now, so you need to change 'options' to use Python
//
// this first cut of JAL grammar was derived from an example found 
// here: http://www.antlr.org/wiki/display/ANTLR3/Example
//
// Conventions:
// - identifiers names are single case (upper case for lex, lower case for parser rules).
// - lex litterals have 'L_' prefix, so 'foo' is named L_FOO.


grammar jal;

options {
	language=Java;
//	language=C;	ASTLabelType=pANTLR3_BASE_TREE;  // C code
	output=AST;

    	backtrack	= true;
}

program : ( statement )+ ; 

statement 
	:	
        asm_block | asm_stmt | block_stmt | for_stmt | forever_stmt | if_stmt 
        | repeat_stmt | while_stmt | case_stmt
        | var_def | const_def | alias_def
        | proc_def | pseudo_proc_def
        | func_def | pseudo_func_def
        | ( L_EXIT^ L_LOOP )
        | L_RETURN^ expr?
        | L_ASSERT expr
        | INCLUDE_STMT
        | L__DEBUG^ STRING_LITERAL
        | L__ERROR^ STRING_LITERAL
        | L__WARN^ STRING_LITERAL
        | pragma 
	| proc_func_call
	| variable ASSIGN^ expr
	;

variable 
	: identifier^ ('[' expr ']')?	;

//include_stmt 
//	: L_INCLUDE^ (identifier|constant|'/')+	 
//	;
	
asm_stmt 
	: L_ASM (L_NOP | (identifier (cexpr ( ',' cexpr )*)?))
	;

asm_block 
	: L_ASSEMBLER (identifier | expr | constant | ',' | ':') * L_END L_ASSEMBLER
	;

// cexpr is a constant expression at compile time. It can contain constant identifierS,
// so at this point, it's not possible to determine the difference between expr and cexpr.
// cexpr is used in this grammar conform the actual language specification.
cexpr   :   expr
        ;

cexpr_list : '{' cexpr ( ',' cexpr )* '}'
	;
	
for_stmt : L_FOR^ expr ( L_USING identifier )? loop_stmt ;

loop_stmt 
	:   L_LOOP^  
                statement*
            L_END! L_LOOP!
	;

forever_stmt : L_FOREVER^ loop_stmt ;  

while_stmt : L_WHILE expr L_LOOP 
                statement*
            L_END L_LOOP
        ;

repeat_stmt : L_REPEAT
                statement*
            L_UNTIL expr
        ;

if_stmt : L_IF^ expr L_THEN statement*
            (L_ELSEIF expr L_THEN statement* )*
            (L_ELSE statement* )?
            L_END L_IF
        ;

case_stmt : L_CASE expr 'of'
                ( cexpr (',' cexpr)* ':' statement )*
                (L_OTHERWISE statement)?
            L_END L_CASE
        ;

block_stmt : L_BLOCK statement* L_END L_BLOCK 			-> ^(L_BLOCK statement*);

proc_params 
	: ( '(' ( proc_parm (',' proc_parm)* )? ')' )?	
	;

proc_parm : L_VOLATILE? vtype ( L_IN | L_OUT | L_IN L_OUT ) identifier ('[' expr? ']')? at_decl?
    ;

//proc_parm : 'volatile'? vtype ( 'in' | 'out' | 'in' 'out' ) ('data' | identifier) ('[' expr ']')? at_decl?
//    ;

    	

// the optional part from L_IS is for the real definition, the first part only is a prototype
proc_def : 'procedure' identifier proc_params
	(	 L_IS
                statement*
            L_END 'procedure' )?
    ;

func_def : 'function'  identifier  proc_params L_RETURN vtype L_IS
                statement*
            L_END 'function'
    ;

pseudo_proc_def : 'procedure' identifier '\'' 'put' proc_params L_IS
                statement*
            L_END 'procedure'
    ;

pseudo_func_def : 'function'  identifier '\'' 'get' proc_params L_RETURN vtype L_IS
                statement*
            L_END 'function'
    ;

alias_def : 'alias'^ identifier L_IS identifier
        ;

const_def : 'const'^ vtype* identifier ( '[' cexpr* ']' )* ASSIGN
            ( cexpr | cexpr_list | identifier | STRING_LITERAL )
        ;

//var_def : var_decl1 var_decl2 (var_multi* | at_decl | is_decl | var_with_init)
//        ;
var_def : 'var'^ L_VOLATILE? vtype var_decl2 (',' var_decl2)*
        ;

//fragment var_multi : ',' var_decl2
//        ;

var_with_init : ASSIGN var_init
        ;
 
fragment var_decl2 : identifier ( '[' cexpr? ']' )? ( at_decl | is_decl | var_with_init)*
        ;

vtype   :   type ('*' cexpr)?
        ;

at_decl : (L_SHARED)? L_AT ( ( cexpr bitloc? ) | (  identifier bitloc? ) | cexpr_list )
        ;

is_decl : L_IS identifier
        ;

bitloc  : ':' cexpr // constant
        ;

proc_func_call   : identifier ('(' expr? (',' expr) * ')')?
//proc_func_call   : identifier ('(' expr? (',' expr) * ')') // parenthesis are mandatory, otherwise parsed as identifier
        ;

//var_init : proc_func_call | cexpr | cexpr_list | STRING_LITERAL | CHARACTER_LITERAL | identifier
var_init : cexpr | cexpr_list | STRING_LITERAL | CHARACTER_LITERAL | identifier
        ;

type    :       L_BIT | L_BYTE | L_WORD | L_DWORD 
        | L_SBYTE | L_SWORD | L_SDWORD
        ;
pragma
    : L_PRAGMA^ (
	(   L_TARGET pragma_target )
	| ( L_INLINE ) 	
	| ( L_INTERRUPT ) 	
	| ( L_STACK constant ) 	
	| ( L_CODE constant ) 	
	| ( L_EEPROM constant ',' constant ) 	
	| ( L_ID constant ',' constant ) 	
	| ( L_DATA constant MINUS constant (',' constant MINUS constant)* ) 	
	| ( L_SHARED constant MINUS constant) 	
	| ( L_FUSEDEF identifier bitloc? constant '{' pragma_fusedef+ '}')
    ) 
    ;

pragma_target 
	:	
	( L_CHIP constant identifier ) // note: 16f877 does not qualify as constant or identifier, but the two
	| (identifier identifier)
	| (identifier constant)
	;

pragma_fusedef
	: identifier ASSIGN constant
	;

//-----------------------------------------------------------------------------
// expressions
//-----------------------------------------------------------------------------
     
expr :  or_expr ('|'^ or_expr)*
     ;

or_expr :  xor_expr ('^'^ xor_expr)*
     ;

xor_expr : and_expr ('&'^ and_expr)*
         ;

and_expr : equality_expr (('==' | '!=' )^ equality_expr)* 
         ;

equality_expr : relational_expr (('<' | '>' | '<=' | '>=' )^ relational_expr)* 
         ;

relational_expr :arith_expr (('<<'|'>>')^ arith_expr)*
           ;

arith_expr: term ((PLUS|MINUS)^ term)* //			-> ^(OPERATOR[('+'|'-')])
          ;

term : pling (('*' | '/' | '%' )^ pling)*
     ;

pling 	: '!'^? factor	
	;

factor : PLUS^ factor
       | MINUS^ factor
//       | '~' factor
       | atom
       ;

atom	:  CHARACTER_LITERAL
        |  STRING_LITERAL
	| vtype '(' expr ')' // cast
        |  constant
	| '(' expr ')'
	|  identifier ('[' expr ']')
	| proc_func_call
	|  identifier
	;
          
identifier : IDENTIFIER
            | L_DATA
            ;          
          

constant :  BIN_LITERAL | HEX_LITERAL | OCTAL_LITERAL | DECIMAL_LITERAL ;

BIN_LITERAL : '0' ('b'|'B') ('0' | '1' | '_')+ ;

DECIMAL_LITERAL : ('0' | '1'..'9' ('0'..'9' | '_')*) ;

HEX_LITERAL : '0' ('x'|'X') HEX_DIGIT+ ;

OCTAL_LITERAL : '0' ('0'..'7')+ ;

CHARACTER_LITERAL :   '"' ( ESCAPE_SEQUENCE | ~('\''|'\\') ) '"'
    ;

STRING_LITERAL :  '"' ( ESCAPE_SEQUENCE | ~('\\'|'"') )* '"'
    ;

fragment HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F'|'_') ;

fragment ESCAPE_SEQUENCE :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   OCTAL_ESCAPE
    ;

fragment OCTAL_ESCAPE :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

WS  :  (' '|'\r'|'\t'|'\u000C'|'\n') {$channel=HIDDEN;}
    ;



INCLUDE_STMT
    : 'include' ~('\n'|'\r')* '\r'? '\n' 
    ;

// todo: line comment to end of file (no cr/lf at the end)
LINE_COMMENT
    : ('--' | ';') ~('\n'|'\r')* {$channel=HIDDEN;}
    ;


L_RETURN	:	'return'	;

L_ASSERT	:	'assert'	;

L_INCLUDE	:	'include'	;

L__DEBUG	:	'_debug'	;
L__ERROR	:	'_error'	;
L__WARN		:	'_warn'		;

L_ASM		:	'asm'		;

L_FOR		:	'for'		;
L_USING		:	'using'		;
L_LOOP		:	'loop'		;
L_EXIT		:	'exit'		;
L_END		:	'end'		;
L_ASSEMBLER	:	'assembler'	;
L_FOREVER	:	'forever'	;
L_WHILE		:	'while'		;
L_REPEAT	:	'repeat'	;
L_UNTIL		:	'until'		;
L_IF		:	'if'		;
L_THEN		:	'then'		;
L_ELSEIF	:	'elsif'		;
L_ELSE		:	'else'		;
L_CASE		:	'case'		;
L_OTHERWISE	:	'otherwise'	;
L_BLOCK		:	'block'		;

L_VOLATILE	:	'volatile'	;
L_IN		:	'in'		;
L_OUT		:	'out'		;
L_SHARED	:	'shared'	;
L_AT		:	'at'		;
L_IS		:	'is'		;

L_BIT		:	'bit'		;
L_BYTE		:	'byte'		;
L_WORD		:	'word'		;
L_DWORD		:	'dword'		;
L_SBYTE		:	'sbyte'		;
L_SWORD		:	'sword'		;
L_SDWORD	:	'sdword'	;

L_PRAGMA	:	'pragma'	;
L_TARGET	:	'target'	;
L_INLINE	:	'inline'	;
L_STACK		:	'stack'		;
L_CODE		:	'code'		;
L_EEPROM	:	'eeprom'	;
L_ID		:	'ID'		;
L_DATA		:	'data'		;
L_FUSEDEF	:	'fuse_def'	;
L_CHIP		:	'chip'		;
L_INTERRUPT	:	'interrupt'	;


L_NOP		:	'nop'		;
	
IDENTIFIER : LETTER (LETTER|'0'..'9')* ;

fragment LETTER : 'A'..'Z' | 'a'..'z' | '_' ;







ASSIGN
	:	'='
	;

PLUS
	:	'+'
	;

MINUS
	:	'-'
	;