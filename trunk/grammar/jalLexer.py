# $ANTLR 3.1.2 jal.g 2010-04-09 21:39:31

import sys
from antlr3 import *
from antlr3.compat import set, frozenset


# for convenience in actions
HIDDEN = BaseRecognizer.HIDDEN

# token types
T__68=68
T__69=69
T__66=66
T__67=67
T__29=29
T__64=64
T__28=28
T__65=65
T__27=27
T__62=62
T__26=26
T__63=63
T__25=25
T__24=24
T__23=23
LETTER=9
T__22=22
T__21=21
T__20=20
PRAGMA=8
T__61=61
EOF=-1
T__60=60
HexDigit=14
T__55=55
T__19=19
T__56=56
T__57=57
T__58=58
STRING_LITERAL=5
T__51=51
IN=6
T__52=52
T__53=53
T__54=54
IDENTIFIER=4
T__59=59
BIN_LITERAL=10
HEX_LITERAL=11
T__50=50
T__42=42
T__43=43
T__40=40
T__41=41
T__46=46
T__80=80
T__47=47
T__81=81
T__44=44
T__45=45
LINE_COMMENT=18
T__48=48
T__49=49
CHARACTER_LITERAL=7
OCTAL_LITERAL=12
T__30=30
T__31=31
T__32=32
T__33=33
T__71=71
WS=17
T__34=34
T__72=72
T__35=35
T__36=36
T__70=70
T__37=37
T__38=38
T__39=39
T__76=76
T__75=75
T__74=74
T__73=73
DECIMAL_LITERAL=13
EscapeSequence=15
OctalEscape=16
T__79=79
T__78=78
T__77=77


class jalLexer(Lexer):

    grammarFileName = "jal.g"
    antlr_version = version_str_to_tuple("3.1.2")
    antlr_version_str = "3.1.2"

    def __init__(self, input=None, state=None):
        if state is None:
            state = RecognizerSharedState()
        Lexer.__init__(self, input, state)

        self.dfa16 = self.DFA16(
            self, 16,
            eot = self.DFA16_eot,
            eof = self.DFA16_eof,
            min = self.DFA16_min,
            max = self.DFA16_max,
            accept = self.DFA16_accept,
            special = self.DFA16_special,
            transition = self.DFA16_transition
            )






    # $ANTLR start "T__19"
    def mT__19(self, ):

        try:
            _type = T__19
            _channel = DEFAULT_CHANNEL

            # jal.g:7:7: ( 'return' )
            # jal.g:7:9: 'return'
            pass 
            self.match("return")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__19"



    # $ANTLR start "T__20"
    def mT__20(self, ):

        try:
            _type = T__20
            _channel = DEFAULT_CHANNEL

            # jal.g:8:7: ( 'assert' )
            # jal.g:8:9: 'assert'
            pass 
            self.match("assert")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__20"



    # $ANTLR start "T__21"
    def mT__21(self, ):

        try:
            _type = T__21
            _channel = DEFAULT_CHANNEL

            # jal.g:9:7: ( 'include' )
            # jal.g:9:9: 'include'
            pass 
            self.match("include")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__21"



    # $ANTLR start "T__22"
    def mT__22(self, ):

        try:
            _type = T__22
            _channel = DEFAULT_CHANNEL

            # jal.g:10:7: ( '_debug' )
            # jal.g:10:9: '_debug'
            pass 
            self.match("_debug")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__22"



    # $ANTLR start "T__23"
    def mT__23(self, ):

        try:
            _type = T__23
            _channel = DEFAULT_CHANNEL

            # jal.g:11:7: ( '_error' )
            # jal.g:11:9: '_error'
            pass 
            self.match("_error")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__23"



    # $ANTLR start "T__24"
    def mT__24(self, ):

        try:
            _type = T__24
            _channel = DEFAULT_CHANNEL

            # jal.g:12:7: ( '_warn' )
            # jal.g:12:9: '_warn'
            pass 
            self.match("_warn")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__24"



    # $ANTLR start "T__25"
    def mT__25(self, ):

        try:
            _type = T__25
            _channel = DEFAULT_CHANNEL

            # jal.g:13:7: ( '=' )
            # jal.g:13:9: '='
            pass 
            self.match(61)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__25"



    # $ANTLR start "T__26"
    def mT__26(self, ):

        try:
            _type = T__26
            _channel = DEFAULT_CHANNEL

            # jal.g:14:7: ( '{' )
            # jal.g:14:9: '{'
            pass 
            self.match(123)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__26"



    # $ANTLR start "T__27"
    def mT__27(self, ):

        try:
            _type = T__27
            _channel = DEFAULT_CHANNEL

            # jal.g:15:7: ( ',' )
            # jal.g:15:9: ','
            pass 
            self.match(44)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__27"



    # $ANTLR start "T__28"
    def mT__28(self, ):

        try:
            _type = T__28
            _channel = DEFAULT_CHANNEL

            # jal.g:16:7: ( '}' )
            # jal.g:16:9: '}'
            pass 
            self.match(125)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__28"



    # $ANTLR start "T__29"
    def mT__29(self, ):

        try:
            _type = T__29
            _channel = DEFAULT_CHANNEL

            # jal.g:17:7: ( 'for' )
            # jal.g:17:9: 'for'
            pass 
            self.match("for")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__29"



    # $ANTLR start "T__30"
    def mT__30(self, ):

        try:
            _type = T__30
            _channel = DEFAULT_CHANNEL

            # jal.g:18:7: ( 'using' )
            # jal.g:18:9: 'using'
            pass 
            self.match("using")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__30"



    # $ANTLR start "T__31"
    def mT__31(self, ):

        try:
            _type = T__31
            _channel = DEFAULT_CHANNEL

            # jal.g:19:7: ( 'loop' )
            # jal.g:19:9: 'loop'
            pass 
            self.match("loop")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__31"



    # $ANTLR start "T__32"
    def mT__32(self, ):

        try:
            _type = T__32
            _channel = DEFAULT_CHANNEL

            # jal.g:20:7: ( 'exit' )
            # jal.g:20:9: 'exit'
            pass 
            self.match("exit")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__32"



    # $ANTLR start "T__33"
    def mT__33(self, ):

        try:
            _type = T__33
            _channel = DEFAULT_CHANNEL

            # jal.g:21:7: ( 'end' )
            # jal.g:21:9: 'end'
            pass 
            self.match("end")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__33"



    # $ANTLR start "T__34"
    def mT__34(self, ):

        try:
            _type = T__34
            _channel = DEFAULT_CHANNEL

            # jal.g:22:7: ( 'forever' )
            # jal.g:22:9: 'forever'
            pass 
            self.match("forever")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__34"



    # $ANTLR start "T__35"
    def mT__35(self, ):

        try:
            _type = T__35
            _channel = DEFAULT_CHANNEL

            # jal.g:23:7: ( 'while' )
            # jal.g:23:9: 'while'
            pass 
            self.match("while")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__35"



    # $ANTLR start "T__36"
    def mT__36(self, ):

        try:
            _type = T__36
            _channel = DEFAULT_CHANNEL

            # jal.g:24:7: ( 'repeat' )
            # jal.g:24:9: 'repeat'
            pass 
            self.match("repeat")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__36"



    # $ANTLR start "T__37"
    def mT__37(self, ):

        try:
            _type = T__37
            _channel = DEFAULT_CHANNEL

            # jal.g:25:7: ( 'until' )
            # jal.g:25:9: 'until'
            pass 
            self.match("until")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__37"



    # $ANTLR start "T__38"
    def mT__38(self, ):

        try:
            _type = T__38
            _channel = DEFAULT_CHANNEL

            # jal.g:26:7: ( 'if' )
            # jal.g:26:9: 'if'
            pass 
            self.match("if")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__38"



    # $ANTLR start "T__39"
    def mT__39(self, ):

        try:
            _type = T__39
            _channel = DEFAULT_CHANNEL

            # jal.g:27:7: ( 'then' )
            # jal.g:27:9: 'then'
            pass 
            self.match("then")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__39"



    # $ANTLR start "T__40"
    def mT__40(self, ):

        try:
            _type = T__40
            _channel = DEFAULT_CHANNEL

            # jal.g:28:7: ( 'elsif' )
            # jal.g:28:9: 'elsif'
            pass 
            self.match("elsif")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__40"



    # $ANTLR start "T__41"
    def mT__41(self, ):

        try:
            _type = T__41
            _channel = DEFAULT_CHANNEL

            # jal.g:29:7: ( 'else' )
            # jal.g:29:9: 'else'
            pass 
            self.match("else")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__41"



    # $ANTLR start "T__42"
    def mT__42(self, ):

        try:
            _type = T__42
            _channel = DEFAULT_CHANNEL

            # jal.g:30:7: ( 'case' )
            # jal.g:30:9: 'case'
            pass 
            self.match("case")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__42"



    # $ANTLR start "T__43"
    def mT__43(self, ):

        try:
            _type = T__43
            _channel = DEFAULT_CHANNEL

            # jal.g:31:7: ( 'of' )
            # jal.g:31:9: 'of'
            pass 
            self.match("of")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__43"



    # $ANTLR start "T__44"
    def mT__44(self, ):

        try:
            _type = T__44
            _channel = DEFAULT_CHANNEL

            # jal.g:32:7: ( ':' )
            # jal.g:32:9: ':'
            pass 
            self.match(58)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__44"



    # $ANTLR start "T__45"
    def mT__45(self, ):

        try:
            _type = T__45
            _channel = DEFAULT_CHANNEL

            # jal.g:33:7: ( 'otherwise' )
            # jal.g:33:9: 'otherwise'
            pass 
            self.match("otherwise")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__45"



    # $ANTLR start "T__46"
    def mT__46(self, ):

        try:
            _type = T__46
            _channel = DEFAULT_CHANNEL

            # jal.g:34:7: ( 'block' )
            # jal.g:34:9: 'block'
            pass 
            self.match("block")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__46"



    # $ANTLR start "T__47"
    def mT__47(self, ):

        try:
            _type = T__47
            _channel = DEFAULT_CHANNEL

            # jal.g:35:7: ( 'procedure' )
            # jal.g:35:9: 'procedure'
            pass 
            self.match("procedure")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__47"



    # $ANTLR start "T__48"
    def mT__48(self, ):

        try:
            _type = T__48
            _channel = DEFAULT_CHANNEL

            # jal.g:36:7: ( '(' )
            # jal.g:36:9: '('
            pass 
            self.match(40)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__48"



    # $ANTLR start "T__49"
    def mT__49(self, ):

        try:
            _type = T__49
            _channel = DEFAULT_CHANNEL

            # jal.g:37:7: ( ')' )
            # jal.g:37:9: ')'
            pass 
            self.match(41)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__49"



    # $ANTLR start "T__50"
    def mT__50(self, ):

        try:
            _type = T__50
            _channel = DEFAULT_CHANNEL

            # jal.g:38:7: ( 'is' )
            # jal.g:38:9: 'is'
            pass 
            self.match("is")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__50"



    # $ANTLR start "T__51"
    def mT__51(self, ):

        try:
            _type = T__51
            _channel = DEFAULT_CHANNEL

            # jal.g:39:7: ( 'function' )
            # jal.g:39:9: 'function'
            pass 
            self.match("function")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__51"



    # $ANTLR start "T__52"
    def mT__52(self, ):

        try:
            _type = T__52
            _channel = DEFAULT_CHANNEL

            # jal.g:40:7: ( 'volatile' )
            # jal.g:40:9: 'volatile'
            pass 
            self.match("volatile")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__52"



    # $ANTLR start "T__53"
    def mT__53(self, ):

        try:
            _type = T__53
            _channel = DEFAULT_CHANNEL

            # jal.g:41:7: ( 'out' )
            # jal.g:41:9: 'out'
            pass 
            self.match("out")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__53"



    # $ANTLR start "T__54"
    def mT__54(self, ):

        try:
            _type = T__54
            _channel = DEFAULT_CHANNEL

            # jal.g:42:7: ( '\\'' )
            # jal.g:42:9: '\\''
            pass 
            self.match(39)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__54"



    # $ANTLR start "T__55"
    def mT__55(self, ):

        try:
            _type = T__55
            _channel = DEFAULT_CHANNEL

            # jal.g:43:7: ( 'put' )
            # jal.g:43:9: 'put'
            pass 
            self.match("put")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__55"



    # $ANTLR start "T__56"
    def mT__56(self, ):

        try:
            _type = T__56
            _channel = DEFAULT_CHANNEL

            # jal.g:44:7: ( 'get' )
            # jal.g:44:9: 'get'
            pass 
            self.match("get")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__56"



    # $ANTLR start "T__57"
    def mT__57(self, ):

        try:
            _type = T__57
            _channel = DEFAULT_CHANNEL

            # jal.g:45:7: ( 'alias' )
            # jal.g:45:9: 'alias'
            pass 
            self.match("alias")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__57"



    # $ANTLR start "T__58"
    def mT__58(self, ):

        try:
            _type = T__58
            _channel = DEFAULT_CHANNEL

            # jal.g:46:7: ( 'const' )
            # jal.g:46:9: 'const'
            pass 
            self.match("const")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__58"



    # $ANTLR start "T__59"
    def mT__59(self, ):

        try:
            _type = T__59
            _channel = DEFAULT_CHANNEL

            # jal.g:47:7: ( '[' )
            # jal.g:47:9: '['
            pass 
            self.match(91)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__59"



    # $ANTLR start "T__60"
    def mT__60(self, ):

        try:
            _type = T__60
            _channel = DEFAULT_CHANNEL

            # jal.g:48:7: ( ']' )
            # jal.g:48:9: ']'
            pass 
            self.match(93)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__60"



    # $ANTLR start "T__61"
    def mT__61(self, ):

        try:
            _type = T__61
            _channel = DEFAULT_CHANNEL

            # jal.g:49:7: ( 'var' )
            # jal.g:49:9: 'var'
            pass 
            self.match("var")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__61"



    # $ANTLR start "T__62"
    def mT__62(self, ):

        try:
            _type = T__62
            _channel = DEFAULT_CHANNEL

            # jal.g:50:7: ( '*' )
            # jal.g:50:9: '*'
            pass 
            self.match(42)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__62"



    # $ANTLR start "T__63"
    def mT__63(self, ):

        try:
            _type = T__63
            _channel = DEFAULT_CHANNEL

            # jal.g:51:7: ( 'shared' )
            # jal.g:51:9: 'shared'
            pass 
            self.match("shared")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__63"



    # $ANTLR start "T__64"
    def mT__64(self, ):

        try:
            _type = T__64
            _channel = DEFAULT_CHANNEL

            # jal.g:52:7: ( 'at' )
            # jal.g:52:9: 'at'
            pass 
            self.match("at")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__64"



    # $ANTLR start "T__65"
    def mT__65(self, ):

        try:
            _type = T__65
            _channel = DEFAULT_CHANNEL

            # jal.g:53:7: ( 'bit' )
            # jal.g:53:9: 'bit'
            pass 
            self.match("bit")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__65"



    # $ANTLR start "T__66"
    def mT__66(self, ):

        try:
            _type = T__66
            _channel = DEFAULT_CHANNEL

            # jal.g:54:7: ( 'byte' )
            # jal.g:54:9: 'byte'
            pass 
            self.match("byte")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__66"



    # $ANTLR start "T__67"
    def mT__67(self, ):

        try:
            _type = T__67
            _channel = DEFAULT_CHANNEL

            # jal.g:55:7: ( 'word' )
            # jal.g:55:9: 'word'
            pass 
            self.match("word")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__67"



    # $ANTLR start "T__68"
    def mT__68(self, ):

        try:
            _type = T__68
            _channel = DEFAULT_CHANNEL

            # jal.g:56:7: ( 'dword' )
            # jal.g:56:9: 'dword'
            pass 
            self.match("dword")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__68"



    # $ANTLR start "T__69"
    def mT__69(self, ):

        try:
            _type = T__69
            _channel = DEFAULT_CHANNEL

            # jal.g:57:7: ( 'sbyte' )
            # jal.g:57:9: 'sbyte'
            pass 
            self.match("sbyte")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__69"



    # $ANTLR start "T__70"
    def mT__70(self, ):

        try:
            _type = T__70
            _channel = DEFAULT_CHANNEL

            # jal.g:58:7: ( 'sword' )
            # jal.g:58:9: 'sword'
            pass 
            self.match("sword")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__70"



    # $ANTLR start "T__71"
    def mT__71(self, ):

        try:
            _type = T__71
            _channel = DEFAULT_CHANNEL

            # jal.g:59:7: ( 'sdword' )
            # jal.g:59:9: 'sdword'
            pass 
            self.match("sdword")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__71"



    # $ANTLR start "T__72"
    def mT__72(self, ):

        try:
            _type = T__72
            _channel = DEFAULT_CHANNEL

            # jal.g:60:7: ( '|' )
            # jal.g:60:9: '|'
            pass 
            self.match(124)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__72"



    # $ANTLR start "T__73"
    def mT__73(self, ):

        try:
            _type = T__73
            _channel = DEFAULT_CHANNEL

            # jal.g:61:7: ( '^' )
            # jal.g:61:9: '^'
            pass 
            self.match(94)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__73"



    # $ANTLR start "T__74"
    def mT__74(self, ):

        try:
            _type = T__74
            _channel = DEFAULT_CHANNEL

            # jal.g:62:7: ( '&' )
            # jal.g:62:9: '&'
            pass 
            self.match(38)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__74"



    # $ANTLR start "T__75"
    def mT__75(self, ):

        try:
            _type = T__75
            _channel = DEFAULT_CHANNEL

            # jal.g:63:7: ( '<<' )
            # jal.g:63:9: '<<'
            pass 
            self.match("<<")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__75"



    # $ANTLR start "T__76"
    def mT__76(self, ):

        try:
            _type = T__76
            _channel = DEFAULT_CHANNEL

            # jal.g:64:7: ( '>>' )
            # jal.g:64:9: '>>'
            pass 
            self.match(">>")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__76"



    # $ANTLR start "T__77"
    def mT__77(self, ):

        try:
            _type = T__77
            _channel = DEFAULT_CHANNEL

            # jal.g:65:7: ( '+' )
            # jal.g:65:9: '+'
            pass 
            self.match(43)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__77"



    # $ANTLR start "T__78"
    def mT__78(self, ):

        try:
            _type = T__78
            _channel = DEFAULT_CHANNEL

            # jal.g:66:7: ( '-' )
            # jal.g:66:9: '-'
            pass 
            self.match(45)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__78"



    # $ANTLR start "T__79"
    def mT__79(self, ):

        try:
            _type = T__79
            _channel = DEFAULT_CHANNEL

            # jal.g:67:7: ( '/' )
            # jal.g:67:9: '/'
            pass 
            self.match(47)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__79"



    # $ANTLR start "T__80"
    def mT__80(self, ):

        try:
            _type = T__80
            _channel = DEFAULT_CHANNEL

            # jal.g:68:7: ( '%' )
            # jal.g:68:9: '%'
            pass 
            self.match(37)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__80"



    # $ANTLR start "T__81"
    def mT__81(self, ):

        try:
            _type = T__81
            _channel = DEFAULT_CHANNEL

            # jal.g:69:7: ( '~' )
            # jal.g:69:9: '~'
            pass 
            self.match(126)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__81"



    # $ANTLR start "IN"
    def mIN(self, ):

        try:
            _type = IN
            _channel = DEFAULT_CHANNEL

            # jal.g:109:4: ( 'in' )
            # jal.g:109:6: 'in'
            pass 
            self.match("in")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "IN"



    # $ANTLR start "PRAGMA"
    def mPRAGMA(self, ):

        try:
            _type = PRAGMA
            _channel = DEFAULT_CHANNEL

            # jal.g:158:5: ( 'pragma' (~ ( '\\n' | '\\r' ) )* ( '\\r' )? '\\n' )
            # jal.g:158:7: 'pragma' (~ ( '\\n' | '\\r' ) )* ( '\\r' )? '\\n'
            pass 
            self.match("pragma")
            # jal.g:158:16: (~ ( '\\n' | '\\r' ) )*
            while True: #loop1
                alt1 = 2
                LA1_0 = self.input.LA(1)

                if ((0 <= LA1_0 <= 9) or (11 <= LA1_0 <= 12) or (14 <= LA1_0 <= 65535)) :
                    alt1 = 1


                if alt1 == 1:
                    # jal.g:158:16: ~ ( '\\n' | '\\r' )
                    pass 
                    if (0 <= self.input.LA(1) <= 9) or (11 <= self.input.LA(1) <= 12) or (14 <= self.input.LA(1) <= 65535):
                        self.input.consume()
                    else:
                        mse = MismatchedSetException(None, self.input)
                        self.recover(mse)
                        raise mse



                else:
                    break #loop1


            # jal.g:158:30: ( '\\r' )?
            alt2 = 2
            LA2_0 = self.input.LA(1)

            if (LA2_0 == 13) :
                alt2 = 1
            if alt2 == 1:
                # jal.g:158:30: '\\r'
                pass 
                self.match(13)



            self.match(10)
            #action start
            _channel=HIDDEN;
            #action end



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "PRAGMA"



    # $ANTLR start "IDENTIFIER"
    def mIDENTIFIER(self, ):

        try:
            _type = IDENTIFIER
            _channel = DEFAULT_CHANNEL

            # jal.g:213:12: ( LETTER ( LETTER | '0' .. '9' )* )
            # jal.g:213:14: LETTER ( LETTER | '0' .. '9' )*
            pass 
            self.mLETTER()
            # jal.g:213:21: ( LETTER | '0' .. '9' )*
            while True: #loop3
                alt3 = 2
                LA3_0 = self.input.LA(1)

                if ((48 <= LA3_0 <= 57) or (65 <= LA3_0 <= 90) or LA3_0 == 95 or (97 <= LA3_0 <= 122)) :
                    alt3 = 1


                if alt3 == 1:
                    # jal.g:
                    pass 
                    if (48 <= self.input.LA(1) <= 57) or (65 <= self.input.LA(1) <= 90) or self.input.LA(1) == 95 or (97 <= self.input.LA(1) <= 122):
                        self.input.consume()
                    else:
                        mse = MismatchedSetException(None, self.input)
                        self.recover(mse)
                        raise mse



                else:
                    break #loop3





            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "IDENTIFIER"



    # $ANTLR start "LETTER"
    def mLETTER(self, ):

        try:
            # jal.g:216:8: ( 'A' .. 'Z' | 'a' .. 'z' | '_' )
            # jal.g:
            pass 
            if (65 <= self.input.LA(1) <= 90) or self.input.LA(1) == 95 or (97 <= self.input.LA(1) <= 122):
                self.input.consume()
            else:
                mse = MismatchedSetException(None, self.input)
                self.recover(mse)
                raise mse





        finally:

            pass

    # $ANTLR end "LETTER"



    # $ANTLR start "BIN_LITERAL"
    def mBIN_LITERAL(self, ):

        try:
            _type = BIN_LITERAL
            _channel = DEFAULT_CHANNEL

            # jal.g:220:13: ( '0' ( 'b' | 'B' ) ( '0' | '1' | '_' )+ )
            # jal.g:220:15: '0' ( 'b' | 'B' ) ( '0' | '1' | '_' )+
            pass 
            self.match(48)
            if self.input.LA(1) == 66 or self.input.LA(1) == 98:
                self.input.consume()
            else:
                mse = MismatchedSetException(None, self.input)
                self.recover(mse)
                raise mse

            # jal.g:220:29: ( '0' | '1' | '_' )+
            cnt4 = 0
            while True: #loop4
                alt4 = 2
                LA4_0 = self.input.LA(1)

                if ((48 <= LA4_0 <= 49) or LA4_0 == 95) :
                    alt4 = 1


                if alt4 == 1:
                    # jal.g:
                    pass 
                    if (48 <= self.input.LA(1) <= 49) or self.input.LA(1) == 95:
                        self.input.consume()
                    else:
                        mse = MismatchedSetException(None, self.input)
                        self.recover(mse)
                        raise mse



                else:
                    if cnt4 >= 1:
                        break #loop4

                    eee = EarlyExitException(4, self.input)
                    raise eee

                cnt4 += 1





            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "BIN_LITERAL"



    # $ANTLR start "DECIMAL_LITERAL"
    def mDECIMAL_LITERAL(self, ):

        try:
            _type = DECIMAL_LITERAL
            _channel = DEFAULT_CHANNEL

            # jal.g:222:17: ( ( '0' | '1' .. '9' ( '0' .. '9' )* ) )
            # jal.g:222:19: ( '0' | '1' .. '9' ( '0' .. '9' )* )
            pass 
            # jal.g:222:19: ( '0' | '1' .. '9' ( '0' .. '9' )* )
            alt6 = 2
            LA6_0 = self.input.LA(1)

            if (LA6_0 == 48) :
                alt6 = 1
            elif ((49 <= LA6_0 <= 57)) :
                alt6 = 2
            else:
                nvae = NoViableAltException("", 6, 0, self.input)

                raise nvae

            if alt6 == 1:
                # jal.g:222:20: '0'
                pass 
                self.match(48)


            elif alt6 == 2:
                # jal.g:222:26: '1' .. '9' ( '0' .. '9' )*
                pass 
                self.matchRange(49, 57)
                # jal.g:222:35: ( '0' .. '9' )*
                while True: #loop5
                    alt5 = 2
                    LA5_0 = self.input.LA(1)

                    if ((48 <= LA5_0 <= 57)) :
                        alt5 = 1


                    if alt5 == 1:
                        # jal.g:222:35: '0' .. '9'
                        pass 
                        self.matchRange(48, 57)


                    else:
                        break #loop5








            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "DECIMAL_LITERAL"



    # $ANTLR start "HEX_LITERAL"
    def mHEX_LITERAL(self, ):

        try:
            _type = HEX_LITERAL
            _channel = DEFAULT_CHANNEL

            # jal.g:224:13: ( '0' ( 'x' | 'X' ) ( HexDigit )+ )
            # jal.g:224:15: '0' ( 'x' | 'X' ) ( HexDigit )+
            pass 
            self.match(48)
            if self.input.LA(1) == 88 or self.input.LA(1) == 120:
                self.input.consume()
            else:
                mse = MismatchedSetException(None, self.input)
                self.recover(mse)
                raise mse

            # jal.g:224:29: ( HexDigit )+
            cnt7 = 0
            while True: #loop7
                alt7 = 2
                LA7_0 = self.input.LA(1)

                if ((48 <= LA7_0 <= 57) or (65 <= LA7_0 <= 70) or LA7_0 == 95 or (97 <= LA7_0 <= 102)) :
                    alt7 = 1


                if alt7 == 1:
                    # jal.g:224:29: HexDigit
                    pass 
                    self.mHexDigit()


                else:
                    if cnt7 >= 1:
                        break #loop7

                    eee = EarlyExitException(7, self.input)
                    raise eee

                cnt7 += 1





            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "HEX_LITERAL"



    # $ANTLR start "OCTAL_LITERAL"
    def mOCTAL_LITERAL(self, ):

        try:
            _type = OCTAL_LITERAL
            _channel = DEFAULT_CHANNEL

            # jal.g:226:15: ( '0' ( '0' .. '7' )+ )
            # jal.g:226:17: '0' ( '0' .. '7' )+
            pass 
            self.match(48)
            # jal.g:226:21: ( '0' .. '7' )+
            cnt8 = 0
            while True: #loop8
                alt8 = 2
                LA8_0 = self.input.LA(1)

                if ((48 <= LA8_0 <= 55)) :
                    alt8 = 1


                if alt8 == 1:
                    # jal.g:226:22: '0' .. '7'
                    pass 
                    self.matchRange(48, 55)


                else:
                    if cnt8 >= 1:
                        break #loop8

                    eee = EarlyExitException(8, self.input)
                    raise eee

                cnt8 += 1





            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "OCTAL_LITERAL"



    # $ANTLR start "CHARACTER_LITERAL"
    def mCHARACTER_LITERAL(self, ):

        try:
            _type = CHARACTER_LITERAL
            _channel = DEFAULT_CHANNEL

            # jal.g:228:19: ( '\"' ( EscapeSequence | ~ ( '\\'' | '\\\\' ) ) '\"' )
            # jal.g:228:23: '\"' ( EscapeSequence | ~ ( '\\'' | '\\\\' ) ) '\"'
            pass 
            self.match(34)
            # jal.g:228:27: ( EscapeSequence | ~ ( '\\'' | '\\\\' ) )
            alt9 = 2
            LA9_0 = self.input.LA(1)

            if (LA9_0 == 92) :
                alt9 = 1
            elif ((0 <= LA9_0 <= 38) or (40 <= LA9_0 <= 91) or (93 <= LA9_0 <= 65535)) :
                alt9 = 2
            else:
                nvae = NoViableAltException("", 9, 0, self.input)

                raise nvae

            if alt9 == 1:
                # jal.g:228:29: EscapeSequence
                pass 
                self.mEscapeSequence()


            elif alt9 == 2:
                # jal.g:228:46: ~ ( '\\'' | '\\\\' )
                pass 
                if (0 <= self.input.LA(1) <= 38) or (40 <= self.input.LA(1) <= 91) or (93 <= self.input.LA(1) <= 65535):
                    self.input.consume()
                else:
                    mse = MismatchedSetException(None, self.input)
                    self.recover(mse)
                    raise mse




            self.match(34)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "CHARACTER_LITERAL"



    # $ANTLR start "STRING_LITERAL"
    def mSTRING_LITERAL(self, ):

        try:
            _type = STRING_LITERAL
            _channel = DEFAULT_CHANNEL

            # jal.g:231:16: ( '\"' ( EscapeSequence | ~ ( '\\\\' | '\"' ) )* '\"' )
            # jal.g:231:19: '\"' ( EscapeSequence | ~ ( '\\\\' | '\"' ) )* '\"'
            pass 
            self.match(34)
            # jal.g:231:23: ( EscapeSequence | ~ ( '\\\\' | '\"' ) )*
            while True: #loop10
                alt10 = 3
                LA10_0 = self.input.LA(1)

                if (LA10_0 == 92) :
                    alt10 = 1
                elif ((0 <= LA10_0 <= 33) or (35 <= LA10_0 <= 91) or (93 <= LA10_0 <= 65535)) :
                    alt10 = 2


                if alt10 == 1:
                    # jal.g:231:25: EscapeSequence
                    pass 
                    self.mEscapeSequence()


                elif alt10 == 2:
                    # jal.g:231:42: ~ ( '\\\\' | '\"' )
                    pass 
                    if (0 <= self.input.LA(1) <= 33) or (35 <= self.input.LA(1) <= 91) or (93 <= self.input.LA(1) <= 65535):
                        self.input.consume()
                    else:
                        mse = MismatchedSetException(None, self.input)
                        self.recover(mse)
                        raise mse



                else:
                    break #loop10


            self.match(34)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "STRING_LITERAL"



    # $ANTLR start "HexDigit"
    def mHexDigit(self, ):

        try:
            # jal.g:235:10: ( ( '0' .. '9' | 'a' .. 'f' | 'A' .. 'F' | '_' ) )
            # jal.g:235:12: ( '0' .. '9' | 'a' .. 'f' | 'A' .. 'F' | '_' )
            pass 
            if (48 <= self.input.LA(1) <= 57) or (65 <= self.input.LA(1) <= 70) or self.input.LA(1) == 95 or (97 <= self.input.LA(1) <= 102):
                self.input.consume()
            else:
                mse = MismatchedSetException(None, self.input)
                self.recover(mse)
                raise mse





        finally:

            pass

    # $ANTLR end "HexDigit"



    # $ANTLR start "EscapeSequence"
    def mEscapeSequence(self, ):

        try:
            # jal.g:237:25: ( '\\\\' ( 'b' | 't' | 'n' | 'f' | 'r' | '\\\"' | '\\'' | '\\\\' ) | OctalEscape )
            alt11 = 2
            LA11_0 = self.input.LA(1)

            if (LA11_0 == 92) :
                LA11_1 = self.input.LA(2)

                if (LA11_1 == 34 or LA11_1 == 39 or LA11_1 == 92 or LA11_1 == 98 or LA11_1 == 102 or LA11_1 == 110 or LA11_1 == 114 or LA11_1 == 116) :
                    alt11 = 1
                elif ((48 <= LA11_1 <= 55)) :
                    alt11 = 2
                else:
                    nvae = NoViableAltException("", 11, 1, self.input)

                    raise nvae

            else:
                nvae = NoViableAltException("", 11, 0, self.input)

                raise nvae

            if alt11 == 1:
                # jal.g:237:29: '\\\\' ( 'b' | 't' | 'n' | 'f' | 'r' | '\\\"' | '\\'' | '\\\\' )
                pass 
                self.match(92)
                if self.input.LA(1) == 34 or self.input.LA(1) == 39 or self.input.LA(1) == 92 or self.input.LA(1) == 98 or self.input.LA(1) == 102 or self.input.LA(1) == 110 or self.input.LA(1) == 114 or self.input.LA(1) == 116:
                    self.input.consume()
                else:
                    mse = MismatchedSetException(None, self.input)
                    self.recover(mse)
                    raise mse



            elif alt11 == 2:
                # jal.g:238:9: OctalEscape
                pass 
                self.mOctalEscape()



        finally:

            pass

    # $ANTLR end "EscapeSequence"



    # $ANTLR start "OctalEscape"
    def mOctalEscape(self, ):

        try:
            # jal.g:241:22: ( '\\\\' ( '0' .. '3' ) ( '0' .. '7' ) ( '0' .. '7' ) | '\\\\' ( '0' .. '7' ) ( '0' .. '7' ) | '\\\\' ( '0' .. '7' ) )
            alt12 = 3
            LA12_0 = self.input.LA(1)

            if (LA12_0 == 92) :
                LA12_1 = self.input.LA(2)

                if ((48 <= LA12_1 <= 51)) :
                    LA12_2 = self.input.LA(3)

                    if ((48 <= LA12_2 <= 55)) :
                        LA12_4 = self.input.LA(4)

                        if ((48 <= LA12_4 <= 55)) :
                            alt12 = 1
                        else:
                            alt12 = 2
                    else:
                        alt12 = 3
                elif ((52 <= LA12_1 <= 55)) :
                    LA12_3 = self.input.LA(3)

                    if ((48 <= LA12_3 <= 55)) :
                        alt12 = 2
                    else:
                        alt12 = 3
                else:
                    nvae = NoViableAltException("", 12, 1, self.input)

                    raise nvae

            else:
                nvae = NoViableAltException("", 12, 0, self.input)

                raise nvae

            if alt12 == 1:
                # jal.g:241:26: '\\\\' ( '0' .. '3' ) ( '0' .. '7' ) ( '0' .. '7' )
                pass 
                self.match(92)
                # jal.g:241:31: ( '0' .. '3' )
                # jal.g:241:32: '0' .. '3'
                pass 
                self.matchRange(48, 51)



                # jal.g:241:42: ( '0' .. '7' )
                # jal.g:241:43: '0' .. '7'
                pass 
                self.matchRange(48, 55)



                # jal.g:241:53: ( '0' .. '7' )
                # jal.g:241:54: '0' .. '7'
                pass 
                self.matchRange(48, 55)





            elif alt12 == 2:
                # jal.g:242:9: '\\\\' ( '0' .. '7' ) ( '0' .. '7' )
                pass 
                self.match(92)
                # jal.g:242:14: ( '0' .. '7' )
                # jal.g:242:15: '0' .. '7'
                pass 
                self.matchRange(48, 55)



                # jal.g:242:25: ( '0' .. '7' )
                # jal.g:242:26: '0' .. '7'
                pass 
                self.matchRange(48, 55)





            elif alt12 == 3:
                # jal.g:243:9: '\\\\' ( '0' .. '7' )
                pass 
                self.match(92)
                # jal.g:243:14: ( '0' .. '7' )
                # jal.g:243:15: '0' .. '7'
                pass 
                self.matchRange(48, 55)






        finally:

            pass

    # $ANTLR end "OctalEscape"



    # $ANTLR start "WS"
    def mWS(self, ):

        try:
            _type = WS
            _channel = DEFAULT_CHANNEL

            # jal.g:246:5: ( ( ' ' | '\\r' | '\\t' | '\\u000C' | '\\n' ) )
            # jal.g:246:8: ( ' ' | '\\r' | '\\t' | '\\u000C' | '\\n' )
            pass 
            if (9 <= self.input.LA(1) <= 10) or (12 <= self.input.LA(1) <= 13) or self.input.LA(1) == 32:
                self.input.consume()
            else:
                mse = MismatchedSetException(None, self.input)
                self.recover(mse)
                raise mse

            #action start
            _channel=HIDDEN;
            #action end



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "WS"



    # $ANTLR start "LINE_COMMENT"
    def mLINE_COMMENT(self, ):

        try:
            _type = LINE_COMMENT
            _channel = DEFAULT_CHANNEL

            # jal.g:250:5: ( ( '--' | ';' ) (~ ( '\\n' | '\\r' ) )* ( '\\r' )? '\\n' )
            # jal.g:250:7: ( '--' | ';' ) (~ ( '\\n' | '\\r' ) )* ( '\\r' )? '\\n'
            pass 
            # jal.g:250:7: ( '--' | ';' )
            alt13 = 2
            LA13_0 = self.input.LA(1)

            if (LA13_0 == 45) :
                alt13 = 1
            elif (LA13_0 == 59) :
                alt13 = 2
            else:
                nvae = NoViableAltException("", 13, 0, self.input)

                raise nvae

            if alt13 == 1:
                # jal.g:250:8: '--'
                pass 
                self.match("--")


            elif alt13 == 2:
                # jal.g:250:15: ';'
                pass 
                self.match(59)



            # jal.g:250:20: (~ ( '\\n' | '\\r' ) )*
            while True: #loop14
                alt14 = 2
                LA14_0 = self.input.LA(1)

                if ((0 <= LA14_0 <= 9) or (11 <= LA14_0 <= 12) or (14 <= LA14_0 <= 65535)) :
                    alt14 = 1


                if alt14 == 1:
                    # jal.g:250:20: ~ ( '\\n' | '\\r' )
                    pass 
                    if (0 <= self.input.LA(1) <= 9) or (11 <= self.input.LA(1) <= 12) or (14 <= self.input.LA(1) <= 65535):
                        self.input.consume()
                    else:
                        mse = MismatchedSetException(None, self.input)
                        self.recover(mse)
                        raise mse



                else:
                    break #loop14


            # jal.g:250:34: ( '\\r' )?
            alt15 = 2
            LA15_0 = self.input.LA(1)

            if (LA15_0 == 13) :
                alt15 = 1
            if alt15 == 1:
                # jal.g:250:34: '\\r'
                pass 
                self.match(13)



            self.match(10)
            #action start
            _channel=HIDDEN;
            #action end



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "LINE_COMMENT"



    def mTokens(self):
        # jal.g:1:8: ( T__19 | T__20 | T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | T__32 | T__33 | T__34 | T__35 | T__36 | T__37 | T__38 | T__39 | T__40 | T__41 | T__42 | T__43 | T__44 | T__45 | T__46 | T__47 | T__48 | T__49 | T__50 | T__51 | T__52 | T__53 | T__54 | T__55 | T__56 | T__57 | T__58 | T__59 | T__60 | T__61 | T__62 | T__63 | T__64 | T__65 | T__66 | T__67 | T__68 | T__69 | T__70 | T__71 | T__72 | T__73 | T__74 | T__75 | T__76 | T__77 | T__78 | T__79 | T__80 | T__81 | IN | PRAGMA | IDENTIFIER | BIN_LITERAL | DECIMAL_LITERAL | HEX_LITERAL | OCTAL_LITERAL | CHARACTER_LITERAL | STRING_LITERAL | WS | LINE_COMMENT )
        alt16 = 74
        alt16 = self.dfa16.predict(self.input)
        if alt16 == 1:
            # jal.g:1:10: T__19
            pass 
            self.mT__19()


        elif alt16 == 2:
            # jal.g:1:16: T__20
            pass 
            self.mT__20()


        elif alt16 == 3:
            # jal.g:1:22: T__21
            pass 
            self.mT__21()


        elif alt16 == 4:
            # jal.g:1:28: T__22
            pass 
            self.mT__22()


        elif alt16 == 5:
            # jal.g:1:34: T__23
            pass 
            self.mT__23()


        elif alt16 == 6:
            # jal.g:1:40: T__24
            pass 
            self.mT__24()


        elif alt16 == 7:
            # jal.g:1:46: T__25
            pass 
            self.mT__25()


        elif alt16 == 8:
            # jal.g:1:52: T__26
            pass 
            self.mT__26()


        elif alt16 == 9:
            # jal.g:1:58: T__27
            pass 
            self.mT__27()


        elif alt16 == 10:
            # jal.g:1:64: T__28
            pass 
            self.mT__28()


        elif alt16 == 11:
            # jal.g:1:70: T__29
            pass 
            self.mT__29()


        elif alt16 == 12:
            # jal.g:1:76: T__30
            pass 
            self.mT__30()


        elif alt16 == 13:
            # jal.g:1:82: T__31
            pass 
            self.mT__31()


        elif alt16 == 14:
            # jal.g:1:88: T__32
            pass 
            self.mT__32()


        elif alt16 == 15:
            # jal.g:1:94: T__33
            pass 
            self.mT__33()


        elif alt16 == 16:
            # jal.g:1:100: T__34
            pass 
            self.mT__34()


        elif alt16 == 17:
            # jal.g:1:106: T__35
            pass 
            self.mT__35()


        elif alt16 == 18:
            # jal.g:1:112: T__36
            pass 
            self.mT__36()


        elif alt16 == 19:
            # jal.g:1:118: T__37
            pass 
            self.mT__37()


        elif alt16 == 20:
            # jal.g:1:124: T__38
            pass 
            self.mT__38()


        elif alt16 == 21:
            # jal.g:1:130: T__39
            pass 
            self.mT__39()


        elif alt16 == 22:
            # jal.g:1:136: T__40
            pass 
            self.mT__40()


        elif alt16 == 23:
            # jal.g:1:142: T__41
            pass 
            self.mT__41()


        elif alt16 == 24:
            # jal.g:1:148: T__42
            pass 
            self.mT__42()


        elif alt16 == 25:
            # jal.g:1:154: T__43
            pass 
            self.mT__43()


        elif alt16 == 26:
            # jal.g:1:160: T__44
            pass 
            self.mT__44()


        elif alt16 == 27:
            # jal.g:1:166: T__45
            pass 
            self.mT__45()


        elif alt16 == 28:
            # jal.g:1:172: T__46
            pass 
            self.mT__46()


        elif alt16 == 29:
            # jal.g:1:178: T__47
            pass 
            self.mT__47()


        elif alt16 == 30:
            # jal.g:1:184: T__48
            pass 
            self.mT__48()


        elif alt16 == 31:
            # jal.g:1:190: T__49
            pass 
            self.mT__49()


        elif alt16 == 32:
            # jal.g:1:196: T__50
            pass 
            self.mT__50()


        elif alt16 == 33:
            # jal.g:1:202: T__51
            pass 
            self.mT__51()


        elif alt16 == 34:
            # jal.g:1:208: T__52
            pass 
            self.mT__52()


        elif alt16 == 35:
            # jal.g:1:214: T__53
            pass 
            self.mT__53()


        elif alt16 == 36:
            # jal.g:1:220: T__54
            pass 
            self.mT__54()


        elif alt16 == 37:
            # jal.g:1:226: T__55
            pass 
            self.mT__55()


        elif alt16 == 38:
            # jal.g:1:232: T__56
            pass 
            self.mT__56()


        elif alt16 == 39:
            # jal.g:1:238: T__57
            pass 
            self.mT__57()


        elif alt16 == 40:
            # jal.g:1:244: T__58
            pass 
            self.mT__58()


        elif alt16 == 41:
            # jal.g:1:250: T__59
            pass 
            self.mT__59()


        elif alt16 == 42:
            # jal.g:1:256: T__60
            pass 
            self.mT__60()


        elif alt16 == 43:
            # jal.g:1:262: T__61
            pass 
            self.mT__61()


        elif alt16 == 44:
            # jal.g:1:268: T__62
            pass 
            self.mT__62()


        elif alt16 == 45:
            # jal.g:1:274: T__63
            pass 
            self.mT__63()


        elif alt16 == 46:
            # jal.g:1:280: T__64
            pass 
            self.mT__64()


        elif alt16 == 47:
            # jal.g:1:286: T__65
            pass 
            self.mT__65()


        elif alt16 == 48:
            # jal.g:1:292: T__66
            pass 
            self.mT__66()


        elif alt16 == 49:
            # jal.g:1:298: T__67
            pass 
            self.mT__67()


        elif alt16 == 50:
            # jal.g:1:304: T__68
            pass 
            self.mT__68()


        elif alt16 == 51:
            # jal.g:1:310: T__69
            pass 
            self.mT__69()


        elif alt16 == 52:
            # jal.g:1:316: T__70
            pass 
            self.mT__70()


        elif alt16 == 53:
            # jal.g:1:322: T__71
            pass 
            self.mT__71()


        elif alt16 == 54:
            # jal.g:1:328: T__72
            pass 
            self.mT__72()


        elif alt16 == 55:
            # jal.g:1:334: T__73
            pass 
            self.mT__73()


        elif alt16 == 56:
            # jal.g:1:340: T__74
            pass 
            self.mT__74()


        elif alt16 == 57:
            # jal.g:1:346: T__75
            pass 
            self.mT__75()


        elif alt16 == 58:
            # jal.g:1:352: T__76
            pass 
            self.mT__76()


        elif alt16 == 59:
            # jal.g:1:358: T__77
            pass 
            self.mT__77()


        elif alt16 == 60:
            # jal.g:1:364: T__78
            pass 
            self.mT__78()


        elif alt16 == 61:
            # jal.g:1:370: T__79
            pass 
            self.mT__79()


        elif alt16 == 62:
            # jal.g:1:376: T__80
            pass 
            self.mT__80()


        elif alt16 == 63:
            # jal.g:1:382: T__81
            pass 
            self.mT__81()


        elif alt16 == 64:
            # jal.g:1:388: IN
            pass 
            self.mIN()


        elif alt16 == 65:
            # jal.g:1:391: PRAGMA
            pass 
            self.mPRAGMA()


        elif alt16 == 66:
            # jal.g:1:398: IDENTIFIER
            pass 
            self.mIDENTIFIER()


        elif alt16 == 67:
            # jal.g:1:409: BIN_LITERAL
            pass 
            self.mBIN_LITERAL()


        elif alt16 == 68:
            # jal.g:1:421: DECIMAL_LITERAL
            pass 
            self.mDECIMAL_LITERAL()


        elif alt16 == 69:
            # jal.g:1:437: HEX_LITERAL
            pass 
            self.mHEX_LITERAL()


        elif alt16 == 70:
            # jal.g:1:449: OCTAL_LITERAL
            pass 
            self.mOCTAL_LITERAL()


        elif alt16 == 71:
            # jal.g:1:463: CHARACTER_LITERAL
            pass 
            self.mCHARACTER_LITERAL()


        elif alt16 == 72:
            # jal.g:1:481: STRING_LITERAL
            pass 
            self.mSTRING_LITERAL()


        elif alt16 == 73:
            # jal.g:1:496: WS
            pass 
            self.mWS()


        elif alt16 == 74:
            # jal.g:1:499: LINE_COMMENT
            pass 
            self.mLINE_COMMENT()







    # lookup tables for DFA #16

    DFA16_eot = DFA.unpack(
        u"\1\uffff\4\50\4\uffff\10\50\1\uffff\2\50\2\uffff\1\50\1\uffff"
        u"\1\50\3\uffff\2\50\6\uffff\1\125\4\uffff\1\52\4\uffff\3\50\1\141"
        u"\1\143\1\144\1\145\20\50\1\166\17\50\6\uffff\1\134\1\uffff\4\50"
        u"\1\uffff\1\50\3\uffff\3\50\1\u0095\5\50\1\u009b\6\50\1\uffff\1"
        u"\50\1\u00a4\1\50\1\u00a6\3\50\1\u00aa\1\50\1\u00ac\1\u00ad\5\50"
        u"\5\uffff\11\50\1\uffff\3\50\1\u00c1\1\u00c2\1\uffff\1\50\1\u00c4"
        u"\1\50\1\u00c6\1\u00c7\1\u00c8\2\50\1\uffff\1\50\1\uffff\1\u00cc"
        u"\2\50\1\uffff\1\50\2\uffff\5\50\2\uffff\3\50\1\u00d9\3\50\1\u00dd"
        u"\2\50\1\u00e0\1\u00e1\2\uffff\1\u00e2\1\uffff\1\u00e3\3\uffff\1"
        u"\u00e4\1\50\1\u00e6\1\uffff\4\50\1\u00eb\1\u00ec\1\50\1\u00ee\1"
        u"\uffff\1\u00ef\1\u00f0\1\u00f1\1\uffff\1\50\1\u00f3\1\u00f4\1\uffff"
        u"\2\50\5\uffff\1\50\1\uffff\3\50\1\u00fc\2\uffff\1\u00fd\4\uffff"
        u"\1\u00fe\2\uffff\1\u00ff\4\50\1\uffff\1\50\4\uffff\1\u0104\2\50"
        u"\1\u0107\1\uffff\1\u0108\1\u0109\3\uffff"
        )

    DFA16_eof = DFA.unpack(
        u"\u010a\uffff"
        )

    DFA16_min = DFA.unpack(
        u"\1\11\1\145\1\154\1\146\1\144\4\uffff\1\157\1\156\1\157\1\154"
        u"\2\150\1\141\1\146\1\uffff\1\151\1\162\2\uffff\1\141\1\uffff\1"
        u"\145\3\uffff\1\142\1\167\6\uffff\1\55\4\uffff\1\60\1\uffff\1\0"
        u"\2\uffff\1\160\1\163\1\151\4\60\1\145\1\162\1\141\1\162\1\156\1"
        u"\151\1\164\1\157\1\151\1\144\1\163\1\151\1\162\1\145\1\163\1\156"
        u"\1\60\1\150\1\164\1\157\2\164\1\141\1\164\1\154\1\162\1\164\1\141"
        u"\1\171\1\157\1\167\1\157\4\uffff\1\42\1\0\1\42\1\uffff\1\165\2"
        u"\145\1\141\1\uffff\1\154\3\uffff\1\142\2\162\1\60\1\143\1\156\1"
        u"\151\1\160\1\164\1\60\1\145\1\154\1\144\1\156\1\145\1\163\1\uffff"
        u"\1\145\1\60\1\143\1\60\1\145\1\143\1\147\1\60\1\141\2\60\1\162"
        u"\1\164\1\162\1\157\1\162\3\0\2\uffff\1\162\1\141\1\162\1\163\2"
        u"\165\1\157\1\156\1\166\1\uffff\1\164\1\147\1\154\2\60\1\uffff\1"
        u"\146\1\60\1\145\3\60\1\164\1\162\1\uffff\1\153\1\uffff\1\60\1\145"
        u"\1\155\1\uffff\1\164\2\uffff\2\145\1\144\1\162\1\144\2\0\1\156"
        u"\2\164\1\60\1\144\1\147\1\162\1\60\1\145\1\151\2\60\2\uffff\1\60"
        u"\1\uffff\1\60\3\uffff\1\60\1\167\1\60\1\uffff\1\144\1\141\1\151"
        u"\1\144\2\60\1\144\1\60\1\0\3\60\1\uffff\1\145\2\60\1\uffff\1\162"
        u"\1\157\5\uffff\1\151\1\uffff\1\165\1\0\1\154\1\60\2\uffff\1\60"
        u"\4\uffff\1\60\2\uffff\1\60\1\156\1\163\1\162\1\0\1\uffff\1\145"
        u"\4\uffff\1\60\2\145\1\60\1\uffff\2\60\3\uffff"
        )

    DFA16_max = DFA.unpack(
        u"\1\176\1\145\1\164\1\163\1\167\4\uffff\1\165\1\163\1\157\1\170"
        u"\1\157\1\150\1\157\1\165\1\uffff\1\171\1\165\2\uffff\1\157\1\uffff"
        u"\1\145\3\uffff\2\167\6\uffff\1\55\4\uffff\1\170\1\uffff\1\uffff"
        u"\2\uffff\1\164\1\163\1\151\4\172\1\145\1\162\1\141\1\162\1\156"
        u"\1\151\1\164\1\157\1\151\1\144\1\163\1\151\1\162\1\145\1\163\1"
        u"\156\1\172\1\150\1\164\1\157\2\164\1\157\1\164\1\154\1\162\1\164"
        u"\1\141\1\171\1\157\1\167\1\157\4\uffff\1\164\1\uffff\1\42\1\uffff"
        u"\1\165\2\145\1\141\1\uffff\1\154\3\uffff\1\142\2\162\1\172\1\143"
        u"\1\156\1\151\1\160\1\164\1\172\1\151\1\154\1\144\1\156\1\145\1"
        u"\163\1\uffff\1\145\1\172\1\143\1\172\1\145\1\143\1\147\1\172\1"
        u"\141\2\172\1\162\1\164\1\162\1\157\1\162\3\uffff\2\uffff\1\162"
        u"\1\141\1\162\1\163\2\165\1\157\1\156\1\166\1\uffff\1\164\1\147"
        u"\1\154\2\172\1\uffff\1\146\1\172\1\145\3\172\1\164\1\162\1\uffff"
        u"\1\153\1\uffff\1\172\1\145\1\155\1\uffff\1\164\2\uffff\2\145\1"
        u"\144\1\162\1\144\2\uffff\1\156\2\164\1\172\1\144\1\147\1\162\1"
        u"\172\1\145\1\151\2\172\2\uffff\1\172\1\uffff\1\172\3\uffff\1\172"
        u"\1\167\1\172\1\uffff\1\144\1\141\1\151\1\144\2\172\1\144\1\172"
        u"\1\uffff\3\172\1\uffff\1\145\2\172\1\uffff\1\162\1\157\5\uffff"
        u"\1\151\1\uffff\1\165\1\uffff\1\154\1\172\2\uffff\1\172\4\uffff"
        u"\1\172\2\uffff\1\172\1\156\1\163\1\162\1\uffff\1\uffff\1\145\4"
        u"\uffff\1\172\2\145\1\172\1\uffff\2\172\3\uffff"
        )

    DFA16_accept = DFA.unpack(
        u"\5\uffff\1\7\1\10\1\11\1\12\10\uffff\1\32\2\uffff\1\36\1\37\1"
        u"\uffff\1\44\1\uffff\1\51\1\52\1\54\2\uffff\1\66\1\67\1\70\1\71"
        u"\1\72\1\73\1\uffff\1\75\1\76\1\77\1\102\1\uffff\1\104\1\uffff\1"
        u"\111\1\112\47\uffff\1\74\1\103\1\105\1\106\3\uffff\1\110\4\uffff"
        u"\1\56\1\uffff\1\100\1\24\1\40\20\uffff\1\31\23\uffff\2\107\11\uffff"
        u"\1\13\5\uffff\1\17\10\uffff\1\43\1\uffff\1\57\3\uffff\1\45\1\uffff"
        u"\1\53\1\46\23\uffff\1\15\1\16\1\uffff\1\27\1\uffff\1\61\1\25\1"
        u"\30\3\uffff\1\60\14\uffff\1\47\3\uffff\1\6\2\uffff\1\14\1\23\1"
        u"\26\1\21\1\50\1\uffff\1\34\4\uffff\1\63\1\64\1\uffff\1\62\1\1\1"
        u"\22\1\2\1\uffff\1\4\1\5\5\uffff\1\101\1\uffff\1\55\1\65\1\3\1\20"
        u"\4\uffff\1\41\2\uffff\1\42\1\33\1\35"
        )

    DFA16_special = DFA.unpack(
        u"\53\uffff\1\3\56\uffff\1\1\54\uffff\1\4\1\5\1\11\51\uffff\1\0"
        u"\1\10\40\uffff\1\7\22\uffff\1\6\20\uffff\1\2\20\uffff"
        )

            
    DFA16_transition = [
        DFA.unpack(u"\2\54\1\uffff\2\54\22\uffff\1\54\1\uffff\1\53\2\uffff"
        u"\1\46\1\40\1\27\1\24\1\25\1\33\1\43\1\7\1\44\1\uffff\1\45\1\51"
        u"\11\52\1\21\1\55\1\41\1\5\1\42\2\uffff\32\50\1\31\1\uffff\1\32"
        u"\1\37\1\4\1\uffff\1\2\1\22\1\17\1\35\1\14\1\11\1\30\1\50\1\3\2"
        u"\50\1\13\2\50\1\20\1\23\1\50\1\1\1\34\1\16\1\12\1\26\1\15\3\50"
        u"\1\6\1\36\1\10\1\47"),
        DFA.unpack(u"\1\56"),
        DFA.unpack(u"\1\60\6\uffff\1\57\1\61"),
        DFA.unpack(u"\1\63\7\uffff\1\62\4\uffff\1\64"),
        DFA.unpack(u"\1\65\1\66\21\uffff\1\67"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\70\5\uffff\1\71"),
        DFA.unpack(u"\1\73\4\uffff\1\72"),
        DFA.unpack(u"\1\74"),
        DFA.unpack(u"\1\77\1\uffff\1\76\11\uffff\1\75"),
        DFA.unpack(u"\1\100\6\uffff\1\101"),
        DFA.unpack(u"\1\102"),
        DFA.unpack(u"\1\103\15\uffff\1\104"),
        DFA.unpack(u"\1\105\15\uffff\1\106\1\107"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\111\2\uffff\1\110\14\uffff\1\112"),
        DFA.unpack(u"\1\113\2\uffff\1\114"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\116\15\uffff\1\115"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\117"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\121\1\uffff\1\123\3\uffff\1\120\16\uffff\1\122"),
        DFA.unpack(u"\1\124"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\55"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\10\130\12\uffff\1\126\25\uffff\1\127\11\uffff\1\126"
        u"\25\uffff\1\127"),
        DFA.unpack(u""),
        DFA.unpack(u"\42\132\1\133\4\132\1\134\64\132\1\131\uffa3\132"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\136\3\uffff\1\135"),
        DFA.unpack(u"\1\137"),
        DFA.unpack(u"\1\140"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\2\50\1\142"
        u"\27\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\146"),
        DFA.unpack(u"\1\147"),
        DFA.unpack(u"\1\150"),
        DFA.unpack(u"\1\151"),
        DFA.unpack(u"\1\152"),
        DFA.unpack(u"\1\153"),
        DFA.unpack(u"\1\154"),
        DFA.unpack(u"\1\155"),
        DFA.unpack(u"\1\156"),
        DFA.unpack(u"\1\157"),
        DFA.unpack(u"\1\160"),
        DFA.unpack(u"\1\161"),
        DFA.unpack(u"\1\162"),
        DFA.unpack(u"\1\163"),
        DFA.unpack(u"\1\164"),
        DFA.unpack(u"\1\165"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\167"),
        DFA.unpack(u"\1\170"),
        DFA.unpack(u"\1\171"),
        DFA.unpack(u"\1\172"),
        DFA.unpack(u"\1\173"),
        DFA.unpack(u"\1\175\15\uffff\1\174"),
        DFA.unpack(u"\1\176"),
        DFA.unpack(u"\1\177"),
        DFA.unpack(u"\1\u0080"),
        DFA.unpack(u"\1\u0081"),
        DFA.unpack(u"\1\u0082"),
        DFA.unpack(u"\1\u0083"),
        DFA.unpack(u"\1\u0084"),
        DFA.unpack(u"\1\u0085"),
        DFA.unpack(u"\1\u0086"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u0087\4\uffff\1\u0087\10\uffff\4\u0088\4\u0089"
        u"\44\uffff\1\u0087\5\uffff\1\u0087\3\uffff\1\u0087\7\uffff\1\u0087"
        u"\3\uffff\1\u0087\1\uffff\1\u0087"),
        DFA.unpack(u"\42\134\1\u008a\uffdd\134"),
        DFA.unpack(u"\1\u008b"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u008c"),
        DFA.unpack(u"\1\u008d"),
        DFA.unpack(u"\1\u008e"),
        DFA.unpack(u"\1\u008f"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u0090"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u0091"),
        DFA.unpack(u"\1\u0092"),
        DFA.unpack(u"\1\u0093"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\4\50\1\u0094"
        u"\25\50"),
        DFA.unpack(u"\1\u0096"),
        DFA.unpack(u"\1\u0097"),
        DFA.unpack(u"\1\u0098"),
        DFA.unpack(u"\1\u0099"),
        DFA.unpack(u"\1\u009a"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u009d\3\uffff\1\u009c"),
        DFA.unpack(u"\1\u009e"),
        DFA.unpack(u"\1\u009f"),
        DFA.unpack(u"\1\u00a0"),
        DFA.unpack(u"\1\u00a1"),
        DFA.unpack(u"\1\u00a2"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00a3"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u00a5"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u00a7"),
        DFA.unpack(u"\1\u00a8"),
        DFA.unpack(u"\1\u00a9"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u00ab"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u00ae"),
        DFA.unpack(u"\1\u00af"),
        DFA.unpack(u"\1\u00b0"),
        DFA.unpack(u"\1\u00b1"),
        DFA.unpack(u"\1\u00b2"),
        DFA.unpack(u"\42\134\1\u008a\uffdd\134"),
        DFA.unpack(u"\42\134\1\u008a\15\134\10\u00b3\uffc8\134"),
        DFA.unpack(u"\42\134\1\u008a\15\134\10\u00b4\uffc8\134"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00b5"),
        DFA.unpack(u"\1\u00b6"),
        DFA.unpack(u"\1\u00b7"),
        DFA.unpack(u"\1\u00b8"),
        DFA.unpack(u"\1\u00b9"),
        DFA.unpack(u"\1\u00ba"),
        DFA.unpack(u"\1\u00bb"),
        DFA.unpack(u"\1\u00bc"),
        DFA.unpack(u"\1\u00bd"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00be"),
        DFA.unpack(u"\1\u00bf"),
        DFA.unpack(u"\1\u00c0"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00c3"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u00c5"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u00c9"),
        DFA.unpack(u"\1\u00ca"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00cb"),
        DFA.unpack(u""),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u00cd"),
        DFA.unpack(u"\1\u00ce"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00cf"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00d0"),
        DFA.unpack(u"\1\u00d1"),
        DFA.unpack(u"\1\u00d2"),
        DFA.unpack(u"\1\u00d3"),
        DFA.unpack(u"\1\u00d4"),
        DFA.unpack(u"\42\134\1\u008a\15\134\10\u00d5\uffc8\134"),
        DFA.unpack(u"\42\134\1\u008a\uffdd\134"),
        DFA.unpack(u"\1\u00d6"),
        DFA.unpack(u"\1\u00d7"),
        DFA.unpack(u"\1\u00d8"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u00da"),
        DFA.unpack(u"\1\u00db"),
        DFA.unpack(u"\1\u00dc"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u00de"),
        DFA.unpack(u"\1\u00df"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u00e5"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00e7"),
        DFA.unpack(u"\1\u00e8"),
        DFA.unpack(u"\1\u00e9"),
        DFA.unpack(u"\1\u00ea"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u00ed"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\42\134\1\u008a\uffdd\134"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00f2"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00f5"),
        DFA.unpack(u"\1\u00f6"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00f7"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u00f8"),
        DFA.unpack(u"\60\u00fa\12\u00f9\7\u00fa\32\u00f9\4\u00fa\1\u00f9"
        u"\1\u00fa\32\u00f9\uff85\u00fa"),
        DFA.unpack(u"\1\u00fb"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u0100"),
        DFA.unpack(u"\1\u0101"),
        DFA.unpack(u"\1\u0102"),
        DFA.unpack(u"\60\u00fa\12\u00f9\7\u00fa\32\u00f9\4\u00fa\1\u00f9"
        u"\1\u00fa\32\u00f9\uff85\u00fa"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\u0103"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\1\u0105"),
        DFA.unpack(u"\1\u0106"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u"\12\50\7\uffff\32\50\4\uffff\1\50\1\uffff\32\50"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"")
    ]

    # class definition for DFA #16

    class DFA16(DFA):
        def specialStateTransition(self_, s, input):
            # convince pylint that my self_ magic is ok ;)
            # pylint: disable-msg=E0213

            # pretend we are a member of the recognizer
            # thus semantic predicates can be evaluated
            self = self_.recognizer

            _s = s

            if s == 0: 
                LA16_179 = input.LA(1)

                s = -1
                if (LA16_179 == 34):
                    s = 138

                elif ((0 <= LA16_179 <= 33) or (35 <= LA16_179 <= 47) or (56 <= LA16_179 <= 65535)):
                    s = 92

                elif ((48 <= LA16_179 <= 55)):
                    s = 213

                if s >= 0:
                    return s
            elif s == 1: 
                LA16_90 = input.LA(1)

                s = -1
                if (LA16_90 == 34):
                    s = 138

                elif ((0 <= LA16_90 <= 33) or (35 <= LA16_90 <= 65535)):
                    s = 92

                if s >= 0:
                    return s
            elif s == 2: 
                LA16_249 = input.LA(1)

                s = -1
                if ((0 <= LA16_249 <= 47) or (58 <= LA16_249 <= 64) or (91 <= LA16_249 <= 94) or LA16_249 == 96 or (123 <= LA16_249 <= 65535)):
                    s = 250

                elif ((48 <= LA16_249 <= 57) or (65 <= LA16_249 <= 90) or LA16_249 == 95 or (97 <= LA16_249 <= 122)):
                    s = 249

                else:
                    s = 40

                if s >= 0:
                    return s
            elif s == 3: 
                LA16_43 = input.LA(1)

                s = -1
                if (LA16_43 == 92):
                    s = 89

                elif ((0 <= LA16_43 <= 33) or (35 <= LA16_43 <= 38) or (40 <= LA16_43 <= 91) or (93 <= LA16_43 <= 65535)):
                    s = 90

                elif (LA16_43 == 34):
                    s = 91

                elif (LA16_43 == 39):
                    s = 92

                if s >= 0:
                    return s
            elif s == 4: 
                LA16_135 = input.LA(1)

                s = -1
                if (LA16_135 == 34):
                    s = 138

                elif ((0 <= LA16_135 <= 33) or (35 <= LA16_135 <= 65535)):
                    s = 92

                if s >= 0:
                    return s
            elif s == 5: 
                LA16_136 = input.LA(1)

                s = -1
                if ((48 <= LA16_136 <= 55)):
                    s = 179

                elif (LA16_136 == 34):
                    s = 138

                elif ((0 <= LA16_136 <= 33) or (35 <= LA16_136 <= 47) or (56 <= LA16_136 <= 65535)):
                    s = 92

                if s >= 0:
                    return s
            elif s == 6: 
                LA16_232 = input.LA(1)

                s = -1
                if ((48 <= LA16_232 <= 57) or (65 <= LA16_232 <= 90) or LA16_232 == 95 or (97 <= LA16_232 <= 122)):
                    s = 249

                elif ((0 <= LA16_232 <= 47) or (58 <= LA16_232 <= 64) or (91 <= LA16_232 <= 94) or LA16_232 == 96 or (123 <= LA16_232 <= 65535)):
                    s = 250

                else:
                    s = 40

                if s >= 0:
                    return s
            elif s == 7: 
                LA16_213 = input.LA(1)

                s = -1
                if (LA16_213 == 34):
                    s = 138

                elif ((0 <= LA16_213 <= 33) or (35 <= LA16_213 <= 65535)):
                    s = 92

                if s >= 0:
                    return s
            elif s == 8: 
                LA16_180 = input.LA(1)

                s = -1
                if (LA16_180 == 34):
                    s = 138

                elif ((0 <= LA16_180 <= 33) or (35 <= LA16_180 <= 65535)):
                    s = 92

                if s >= 0:
                    return s
            elif s == 9: 
                LA16_137 = input.LA(1)

                s = -1
                if ((48 <= LA16_137 <= 55)):
                    s = 180

                elif (LA16_137 == 34):
                    s = 138

                elif ((0 <= LA16_137 <= 33) or (35 <= LA16_137 <= 47) or (56 <= LA16_137 <= 65535)):
                    s = 92

                if s >= 0:
                    return s

            nvae = NoViableAltException(self_.getDescription(), 16, _s, input)
            self_.error(nvae)
            raise nvae
 



def main(argv, stdin=sys.stdin, stdout=sys.stdout, stderr=sys.stderr):
    from antlr3.main import LexerMain
    main = LexerMain(jalLexer)
    main.stdin = stdin
    main.stdout = stdout
    main.stderr = stderr
    main.execute(argv)


if __name__ == '__main__':
    main(sys.argv)
