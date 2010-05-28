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
// you may prefer to view this file from the 'ANTLRWorks' GUI tool, 
// which is a single Java 'jar' file, from here: http://www.antlr.org/works/index.html
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

tokens {
	BODY;
	CASE_VALUE;
	CONDITION;
	FUNC_PROC_CALL;
	PARAMS;
	VAR;
	L_VOID;  // used in translator as return type for procedures
}

program : ( statement )+ EOF; 

statement 
	:	
        asm_block | asm_stmt | block_stmt | for_stmt | forever_stmt | if_stmt 
        | repeat_stmt | while_stmt | case_stmt
        | var_def | const_def | alias_def
        | proc_def | func_def 
        | ( L_EXIT L_LOOP ) ->^(L_EXIT)
        | L_RETURN^ expr?
        | L_ASSERT expr
        | INCLUDE_STMT 
        | J2CG_COMMENT
        | J2C_COMMENT
        | L__DEBUG^ STRING_LITERAL
        | L__ERROR^ STRING_LITERAL
        | L__WARN^ STRING_LITERAL
        | pragma 
	| variable ASSIGN^ expr
	| proc_func_call
	| identifier
	;




variable 
	: identifier^ ( var_def_array )?	;

asm_stmt 
	: L_ASM (L_NOP | (identifier (cexpr ( COMMA cexpr )*)?))
	;

asm_block 
	: L_ASSEMBLER (identifier | expr | constant | COMMA | COLON) * L_END L_ASSEMBLER
	;

// cexpr is a constant expression at compile time. It can contain constant identifierS,
// so at this point, it's not possible to determine the difference between expr and cexpr.
// cexpr is used in this grammar conform the actual language specification.
cexpr   :   expr
        ;

cexpr_list : LCURLY cexpr ( COMMA cexpr )* RCURLY
		-> ^(LCURLY cexpr*)
	;
	
for_stmt : L_FOR expr ( L_USING identifier )? loop_stmt 
	-> ^(L_FOR ^(L_USING identifier)? ^(CONDITION expr) loop_stmt ) 
	;

loop_stmt : L_LOOP statement* L_END L_LOOP
            -> ^(BODY statement*) 
	;

forever_stmt : L_FOREVER^ loop_stmt ;  

while_stmt : L_WHILE expr loop_stmt
	-> ^(L_WHILE ^(CONDITION expr) loop_stmt ) 
        ;

repeat_stmt : L_REPEAT statement* L_UNTIL expr
	-> ^(L_REPEAT ^(BODY statement*) ^(CONDITION expr)) 
        ;

if_stmt : L_IF expr L_THEN statement* if_elsif* if_else? L_END L_IF
		-> ^(L_IF ^(CONDITION expr) ^(BODY statement*) if_elsif* if_else?) 
        ;

if_else : L_ELSE statement* 
	-> ^(L_ELSE ^(BODY statement*))
        ;

if_elsif : L_ELSIF expr L_THEN statement*
	-> ^(L_ELSIF ^(CONDITION expr) ^(BODY statement*)) 
        ;

case_value :	cexpr (COMMA cexpr)* COLON statement
		-> ^(CASE_VALUE ^(CONDITION cexpr)* ^(BODY statement)) 
        ;

case_stmt : L_CASE expr L_OF case_value* (L_OTHERWISE statement)? L_END L_CASE
	-> ^(L_CASE ^(CONDITION expr) case_value* ^(L_OTHERWISE statement)?) 
        ;

block_stmt : L_BLOCK statement* L_END L_BLOCK 			-> ^(L_BLOCK statement*);

proc_params 
	:  LPAREN ( proc_param (COMMA proc_param)* )? RPAREN -> ^(PARAMS proc_param*)
	;

proc_param : L_VOLATILE? vtype ( L_IN | L_OUT | L_IN L_OUT ) identifier (LBRACKET expr? RBRACKET)? at_decl?
   -> ^(vtype L_VOLATILE? L_IN? L_OUT? ^(LBRACKET expr?) at_decl? identifier)
    ;

proc_body : L_IS statement* L_END L_PROCEDURE -> ^(BODY statement*)
    ;

// the optional part proc_body is for the procedure body definition, the first part only is a prototype
proc_def : L_PROCEDURE identifier (APOSTROPHE L_PUT)? proc_params proc_body?
	 -> ^( L_PROCEDURE L_PUT? identifier  proc_params proc_body?)
    ;

func_body : L_IS statement* L_END L_FUNCTION -> ^(BODY statement*)
    ;

// the optional part func_body is for the function body definition, the first part only is a prototype
func_def : L_FUNCTION  identifier (APOSTROPHE L_GET)? proc_params L_RETURN vtype func_body?
	-> ^( L_FUNCTION L_GET? ^(L_RETURN vtype) identifier proc_params func_body?)
    	;

alias_def : L_ALIAS identifier L_IS identifier
	-> ^(L_ALIAS identifier*)
        ;

// note: next *is* constant, but makes use of var rules and sub-structure.
const_def2 : identifier ( LBRACKET cexpr? RBRACKET )? var_init?
	-> ^(VAR identifier ^(LBRACKET cexpr)?  var_init? )
	;

const_def : L_CONST vtype? const_def2 (COMMA const_def2)* 
	-> ^(L_CONST vtype? const_def2*)
        ;

//identifier ( LBRACKET cexpr* RBRACKET )* ASSIGN
//            ( cexpr | cexpr_list | identifier | STRING_LITERAL )

var_init : ASSIGN^ (cexpr | cexpr_list | STRING_LITERAL | CHARACTER_LITERAL | identifier) ;

var_def_array  
	: LBRACKET cexpr? RBRACKET 
	-> ^(LBRACKET cexpr?)
	;

var_def2 : identifier ( var_def_array )? ( at_decl | is_decl | var_init)*
	-> ^(VAR identifier var_def_array?  at_decl*  is_decl* var_init? )
	;

var_def : L_VAR L_VOLATILE? vtype var_def2 (COMMA var_def2)* 
	-> ^(L_VAR L_VOLATILE? vtype var_def2*)
        ;

vtype   :   type^ (ASTERIX cexpr)? ;

type    :   L_BIT | L_BYTE | L_WORD | L_DWORD  | L_SBYTE | L_SWORD | L_SDWORD ;

at_decl : (L_SHARED)? L_AT ( ( cexpr bitloc? ) | (  identifier bitloc? ) | cexpr_list )
	-> ^(L_AT L_SHARED? cexpr? identifier? bitloc? cexpr_list?)
        ;

is_decl : L_IS^ identifier
        ;

bitloc  : COLON cexpr // constant
        ;

// parenthesis are mandatory for this rule. JAL allows procedure/function calls without parenthesis
// which are matched as 'identifiers' and must be handled by the code genarator.
proc_func_call   : identifier (LPAREN expr? (COMMA expr) * RPAREN) -> ^(FUNC_PROC_CALL identifier expr*) ;

count : L_COUNT^ LPAREN! identifier RPAREN! ;  


pragma
    : L_PRAGMA^ (
	(   L_TARGET pragma_target )
	| ( L_INLINE ) 	
	| ( L_INTERRUPT ) 	
	| ( L_STACK constant ) 	
	| ( L_CODE constant ) 	
	| ( L_EEPROM constant COMMA constant ) 	
	| ( L_ID constant COMMA constant ) 	
	| ( L_DATA constant MINUS constant (COMMA constant MINUS constant)* ) 	
	| ( L_SHARED constant MINUS constant) 	
	| ( L_FUSEDEF identifier bitloc? constant LCURLY pragma_fusedef+ RCURLY)
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
     
expr :  or_expr (OR^ or_expr)*
     ;

or_expr :  xor_expr (CARET^ xor_expr)*
     ;

xor_expr : and_expr (AMP^ and_expr)*
         ;

and_expr : equality_expr ((EQUAL | NOT_EQUAL )^ equality_expr)* 
         ;

equality_expr : relational_expr ((LESS | GREATER | LESS_EQUAL | GREATER_EQUAL )^ relational_expr)* 
         ;

relational_expr :arith_expr ((LEFT_SHIFT|RIGHT_SHIFT)^ arith_expr)*
           ;

arith_expr: term ((PLUS|MINUS)^ term)* 
          ;

term : pling ((ASTERIX | SLASH | PERCENT )^ pling)*
     ;

pling 	: BANG^? factor	
	;

factor : PLUS^ factor
       | MINUS^ factor
//       | '~' factor
       | atom
       ;

array : identifier^ var_def_array 
      ;

atom	: CHARACTER_LITERAL
      | STRING_LITERAL
	   | vtype LPAREN expr RPAREN // cast, byte(foo)
      | constant
	   | LPAREN! expr RPAREN!
	   | count
	   | array 
	   | proc_func_call
	   | identifier
	   ;
          
identifier : IDENTIFIER
            | L_DATA
            ;          

constant :  BIN_LITERAL | HEX_LITERAL | OCTAL_LITERAL | DECIMAL_LITERAL ;

BIN_LITERAL : '0' ('b'|'B') ('0' | '1' | '_')+ ;

//DECIMAL_LITERAL : ('0' | '1'..'9' ('0'..'9' | '_')*) ;
DECIMAL_LITERAL : ('0'..'9' ('0'..'9' | '_')*) ;

HEX_LITERAL : '0' ('x'|'X') HEX_DIGIT+ ;

OCTAL_LITERAL : '0' ('q'|'Q') (('0'..'7') | '_')+ ;

CHARACTER_LITERAL :   '"' ( ESCAPE_SEQUENCE | ~(APOSTROPHE|'\\') ) '"'
    ;

STRING_LITERAL :  '"' ( ESCAPE_SEQUENCE | ~('\\'|'"') )* '"'
    ;

fragment HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F'|'_') ;

fragment ESCAPE_SEQUENCE :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|APOSTROPHE|'\\')
    |   OCTAL_ESCAPE
    ;

fragment OCTAL_ESCAPE :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

WS  :  (' '|'\r'|'\t'|'\u000C'|'\n') {$channel=HIDDEN;}
    ;

fragment NEOL // no-end-of-line (all chars up to end of line)
	: ~('\n'|'\r')* ;	 

INCLUDE_STMT
    : 'include' line = NEOL
	{   	pANTLR3_INPUT_STREAM    in;

//		pANTLR3_STRING	fName;
//		fName = $line.text;

		in = (pANTLR3_INPUT_STREAM)JalOpenInclude((char *)($line.text)->chars);
		
		if (in != NULL) {
			// note: error handling done in JalOpenInclude
			PUSHSTREAM(in);
		}
	}	
	;

// j2cG comment is a special case that is passed to the Jal2C convertor
J2CG_COMMENT
    : (';@j2cg') NEOL
    ;



// j2c comment is a special case that is passed to the Jal2C convertor
J2C_COMMENT
    : (';@j2c') NEOL
    ;

LINE_COMMENT
    : ('--' | ';') NEOL {$channel=HIDDEN;}
    ;

L__DEBUG	:	'_debug'	;		
L__ERROR	:	'_error'	;		
L__WARN		:	'_warn'		;
L_ALIAS		:	'alias'		;
L_ASM		:	'asm'		;
L_ASSEMBLER	:	'assembler'	;		
L_ASSERT	:	'assert'	;		
L_AT		:	'at'		;
L_BIT		:	'bit'		;
L_BLOCK		:	'block'		;
L_BYTE		:	'byte'		;
L_CASE		:	'case'		;
L_CHIP		:	'chip'		;
L_CODE		:	'code'		;
L_CONST		:	'const'		;
L_COUNT		:	'count'		;
L_DATA		:	'data'		;
L_DWORD		:	'dword'		;
L_EEPROM	:	'eeprom'	;		
L_ELSE		:	'else'		;
L_ELSIF		:	'elsif'		;	
L_END		:	'end'		;
L_EXIT		:	'exit'		;
L_FOR		:	'for'		;
L_FOREVER	:	'forever'	;		
L_FUNCTION	:	'function'	;		
L_FUSEDEF	:	'fuse_def'	;		
L_GET		:	'get'		;
L_ID		:	'ID'		;
L_IF		:	'if'		;
L_IN		:	'in'		;
//L_INCLUDE	:	'include'	;		
L_INLINE	:	'inline'	;		
L_INTERRUPT	:	'interrupt'	;		
L_IS		:	'is'		;
L_LOOP		:	'loop'		;
L_NOP		:	'nop'		;
L_OF		:	'of'		;
L_OTHERWISE	:	'otherwise'	;		
L_OUT		:	'out'		;
L_PRAGMA	:	'pragma'	;		
L_PROCEDURE	:	'procedure'	;		
L_PUT		:	'put'		;
L_REPEAT	:	'repeat'	;		
L_RETURN	:	'return'	;		
L_SBYTE		:	'sbyte'		;
L_SDWORD	:	'sdword'	;		
L_SHARED	:	'shared'	;		
L_STACK		:	'stack'		;
L_SWORD		:	'sword'		;
L_TARGET	:	'target'	;		
L_THEN		:	'then'		;
L_UNTIL		:	'until'		;
L_USING		:	'using'		;
L_VAR		:	'var'		;
L_VOLATILE	:	'volatile'	;		
L_WHILE		:	'while'		;
L_WORD		:	'word'		;

AMP		:	'&'		;	
APOSTROPHE	:	'\''		;		
ASSIGN		:	'='		;	
ASTERIX		:	'*'		;	
BANG		:	'!'		;	
CARET		:	'^'		;	
COLON		:	':'		;	
COMMA		:	','		;	
EQUAL		:	'=='		;	
GREATER		:	'>'		;	
GREATER_EQUAL	:	'>='		;		
LBRACKET	:	'['		;		
LCURLY		:	'{'		;	
LEFT_SHIFT	:	'<<'		;		
LESS		:	'<'		;	
LESS_EQUAL	:	'<='		;		
LPAREN		:	'('		;	
MINUS		:	'-'		;	
NOT_EQUAL	:	'!='		;		
OR		:	'|'		;	
PERCENT		:	'%'		;	
PLUS		:	'+'		;	
RBRACKET	:	']'		;		
RCURLY		:	'}'		;	
RIGHT_SHIFT	:	'>>'		;		
RPAREN		:	')'		;	
SLASH		:	'/'		;	

// note: some identifiers may be matched as tokens before...
IDENTIFIER : LETTER (LETTER|'0'..'9')* ;

fragment LETTER : 'A'..'Z' | 'a'..'z' | '_' ;
	
	



	