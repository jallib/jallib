# $ANTLR 3.1.2 jal.g 2010-04-09 21:39:30

import sys
from antlr3 import *
from antlr3.compat import set, frozenset

from antlr3.tree import *



# for convenience in actions
HIDDEN = BaseRecognizer.HIDDEN

# token types
T__68=68
T__69=69
T__66=66
T__67=67
T__64=64
T__29=29
T__65=65
T__28=28
T__62=62
T__27=27
T__63=63
T__26=26
T__25=25
T__24=24
LETTER=9
T__23=23
T__22=22
T__21=21
T__20=20
PRAGMA=8
T__61=61
T__60=60
EOF=-1
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
T__80=80
T__46=46
T__81=81
T__47=47
T__44=44
T__45=45
LINE_COMMENT=18
T__48=48
T__49=49
OCTAL_LITERAL=12
CHARACTER_LITERAL=7
T__30=30
T__31=31
T__32=32
WS=17
T__71=71
T__33=33
T__72=72
T__34=34
T__35=35
T__70=70
T__36=36
T__37=37
T__38=38
T__39=39
T__76=76
T__75=75
T__74=74
OctalEscape=16
EscapeSequence=15
DECIMAL_LITERAL=13
T__73=73
T__79=79
T__78=78
T__77=77

# token names
tokenNames = [
    "<invalid>", "<EOR>", "<DOWN>", "<UP>", 
    "IDENTIFIER", "STRING_LITERAL", "IN", "CHARACTER_LITERAL", "PRAGMA", 
    "LETTER", "BIN_LITERAL", "HEX_LITERAL", "OCTAL_LITERAL", "DECIMAL_LITERAL", 
    "HexDigit", "EscapeSequence", "OctalEscape", "WS", "LINE_COMMENT", "'return'", 
    "'assert'", "'include'", "'_debug'", "'_error'", "'_warn'", "'='", "'{'", 
    "','", "'}'", "'for'", "'using'", "'loop'", "'exit'", "'end'", "'forever'", 
    "'while'", "'repeat'", "'until'", "'if'", "'then'", "'elsif'", "'else'", 
    "'case'", "'of'", "':'", "'otherwise'", "'block'", "'procedure'", "'('", 
    "')'", "'is'", "'function'", "'volatile'", "'out'", "'\\''", "'put'", 
    "'get'", "'alias'", "'const'", "'['", "']'", "'var'", "'*'", "'shared'", 
    "'at'", "'bit'", "'byte'", "'word'", "'dword'", "'sbyte'", "'sword'", 
    "'sdword'", "'|'", "'^'", "'&'", "'<<'", "'>>'", "'+'", "'-'", "'/'", 
    "'%'", "'~'"
]




class jalParser(Parser):
    grammarFileName = "jal.g"
    antlr_version = version_str_to_tuple("3.1.2")
    antlr_version_str = "3.1.2"
    tokenNames = tokenNames

    def __init__(self, input, state=None):
        if state is None:
            state = RecognizerSharedState()

        Parser.__init__(self, input, state)


        self.dfa2 = self.DFA2(
            self, 2,
            eot = self.DFA2_eot,
            eof = self.DFA2_eof,
            min = self.DFA2_min,
            max = self.DFA2_max,
            accept = self.DFA2_accept,
            special = self.DFA2_special,
            transition = self.DFA2_transition
            )

        self.dfa57 = self.DFA57(
            self, 57,
            eot = self.DFA57_eot,
            eof = self.DFA57_eof,
            min = self.DFA57_min,
            max = self.DFA57_max,
            accept = self.DFA57_accept,
            special = self.DFA57_special,
            transition = self.DFA57_transition
            )






                
        self._adaptor = CommonTreeAdaptor()


        
    def getTreeAdaptor(self):
        return self._adaptor

    def setTreeAdaptor(self, adaptor):
        self._adaptor = adaptor

    adaptor = property(getTreeAdaptor, setTreeAdaptor)


    class program_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "program"
    # jal.g:22:1: program : ( statement )+ ;
    def program(self, ):

        retval = self.program_return()
        retval.start = self.input.LT(1)

        root_0 = None

        statement1 = None



        try:
            try:
                # jal.g:22:9: ( ( statement )+ )
                # jal.g:22:11: ( statement )+
                pass 
                root_0 = self._adaptor.nil()

                # jal.g:22:11: ( statement )+
                cnt1 = 0
                while True: #loop1
                    alt1 = 2
                    LA1_0 = self.input.LA(1)

                    if (LA1_0 == IDENTIFIER or (19 <= LA1_0 <= 24) or LA1_0 == 29 or (34 <= LA1_0 <= 36) or LA1_0 == 38 or LA1_0 == 42 or (46 <= LA1_0 <= 47) or LA1_0 == 51 or (57 <= LA1_0 <= 58) or LA1_0 == 61) :
                        alt1 = 1


                    if alt1 == 1:
                        # jal.g:22:13: statement
                        pass 
                        self._state.following.append(self.FOLLOW_statement_in_program59)
                        statement1 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement1.tree)
                        if self._state.backtracking == 0:
                            print statement1.tree.toStringTree();



                    else:
                        if cnt1 >= 1:
                            break #loop1

                        if self._state.backtracking > 0:
                            raise BacktrackingFailed

                        eee = EarlyExitException(1, self.input)
                        raise eee

                    cnt1 += 1





                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "program"

    class statement_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "statement"
    # jal.g:24:1: statement : ( block_stmt | for_stmt | forever_stmt | if_stmt | repeat_stmt | while_stmt | case_stmt | var_def | const_def | alias_def | proc_def | pseudo_proc_def | func_def | pseudo_func_def | 'return' expr | 'assert' expr | 'include' IDENTIFIER | '_debug' STRING_LITERAL | '_error' STRING_LITERAL | '_warn' STRING_LITERAL | IDENTIFIER '=' expr | proc_func_call );
    def statement(self, ):

        retval = self.statement_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal16 = None
        string_literal18 = None
        string_literal20 = None
        IDENTIFIER21 = None
        string_literal22 = None
        STRING_LITERAL23 = None
        string_literal24 = None
        STRING_LITERAL25 = None
        string_literal26 = None
        STRING_LITERAL27 = None
        IDENTIFIER28 = None
        char_literal29 = None
        block_stmt2 = None

        for_stmt3 = None

        forever_stmt4 = None

        if_stmt5 = None

        repeat_stmt6 = None

        while_stmt7 = None

        case_stmt8 = None

        var_def9 = None

        const_def10 = None

        alias_def11 = None

        proc_def12 = None

        pseudo_proc_def13 = None

        func_def14 = None

        pseudo_func_def15 = None

        expr17 = None

        expr19 = None

        expr30 = None

        proc_func_call31 = None


        string_literal16_tree = None
        string_literal18_tree = None
        string_literal20_tree = None
        IDENTIFIER21_tree = None
        string_literal22_tree = None
        STRING_LITERAL23_tree = None
        string_literal24_tree = None
        STRING_LITERAL25_tree = None
        string_literal26_tree = None
        STRING_LITERAL27_tree = None
        IDENTIFIER28_tree = None
        char_literal29_tree = None

        try:
            try:
                # jal.g:24:11: ( block_stmt | for_stmt | forever_stmt | if_stmt | repeat_stmt | while_stmt | case_stmt | var_def | const_def | alias_def | proc_def | pseudo_proc_def | func_def | pseudo_func_def | 'return' expr | 'assert' expr | 'include' IDENTIFIER | '_debug' STRING_LITERAL | '_error' STRING_LITERAL | '_warn' STRING_LITERAL | IDENTIFIER '=' expr | proc_func_call )
                alt2 = 22
                alt2 = self.dfa2.predict(self.input)
                if alt2 == 1:
                    # jal.g:25:9: block_stmt
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_block_stmt_in_statement82)
                    block_stmt2 = self.block_stmt()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, block_stmt2.tree)


                elif alt2 == 2:
                    # jal.g:25:22: for_stmt
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_for_stmt_in_statement86)
                    for_stmt3 = self.for_stmt()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, for_stmt3.tree)


                elif alt2 == 3:
                    # jal.g:25:33: forever_stmt
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_forever_stmt_in_statement90)
                    forever_stmt4 = self.forever_stmt()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, forever_stmt4.tree)


                elif alt2 == 4:
                    # jal.g:25:48: if_stmt
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_if_stmt_in_statement94)
                    if_stmt5 = self.if_stmt()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, if_stmt5.tree)


                elif alt2 == 5:
                    # jal.g:26:11: repeat_stmt
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_repeat_stmt_in_statement107)
                    repeat_stmt6 = self.repeat_stmt()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, repeat_stmt6.tree)


                elif alt2 == 6:
                    # jal.g:26:25: while_stmt
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_while_stmt_in_statement111)
                    while_stmt7 = self.while_stmt()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, while_stmt7.tree)


                elif alt2 == 7:
                    # jal.g:26:38: case_stmt
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_case_stmt_in_statement115)
                    case_stmt8 = self.case_stmt()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, case_stmt8.tree)


                elif alt2 == 8:
                    # jal.g:27:11: var_def
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_var_def_in_statement127)
                    var_def9 = self.var_def()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, var_def9.tree)


                elif alt2 == 9:
                    # jal.g:27:21: const_def
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_const_def_in_statement131)
                    const_def10 = self.const_def()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, const_def10.tree)


                elif alt2 == 10:
                    # jal.g:27:33: alias_def
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_alias_def_in_statement135)
                    alias_def11 = self.alias_def()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, alias_def11.tree)


                elif alt2 == 11:
                    # jal.g:28:11: proc_def
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_proc_def_in_statement147)
                    proc_def12 = self.proc_def()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, proc_def12.tree)


                elif alt2 == 12:
                    # jal.g:28:22: pseudo_proc_def
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_pseudo_proc_def_in_statement151)
                    pseudo_proc_def13 = self.pseudo_proc_def()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, pseudo_proc_def13.tree)


                elif alt2 == 13:
                    # jal.g:29:11: func_def
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_func_def_in_statement163)
                    func_def14 = self.func_def()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, func_def14.tree)


                elif alt2 == 14:
                    # jal.g:29:22: pseudo_func_def
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_pseudo_func_def_in_statement167)
                    pseudo_func_def15 = self.pseudo_func_def()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, pseudo_func_def15.tree)


                elif alt2 == 15:
                    # jal.g:30:11: 'return' expr
                    pass 
                    root_0 = self._adaptor.nil()

                    string_literal16=self.match(self.input, 19, self.FOLLOW_19_in_statement179)
                    if self._state.backtracking == 0:

                        string_literal16_tree = self._adaptor.createWithPayload(string_literal16)
                        self._adaptor.addChild(root_0, string_literal16_tree)

                    self._state.following.append(self.FOLLOW_expr_in_statement181)
                    expr17 = self.expr()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, expr17.tree)


                elif alt2 == 16:
                    # jal.g:31:11: 'assert' expr
                    pass 
                    root_0 = self._adaptor.nil()

                    string_literal18=self.match(self.input, 20, self.FOLLOW_20_in_statement193)
                    if self._state.backtracking == 0:

                        string_literal18_tree = self._adaptor.createWithPayload(string_literal18)
                        self._adaptor.addChild(root_0, string_literal18_tree)

                    self._state.following.append(self.FOLLOW_expr_in_statement195)
                    expr19 = self.expr()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, expr19.tree)


                elif alt2 == 17:
                    # jal.g:32:11: 'include' IDENTIFIER
                    pass 
                    root_0 = self._adaptor.nil()

                    string_literal20=self.match(self.input, 21, self.FOLLOW_21_in_statement207)
                    if self._state.backtracking == 0:

                        string_literal20_tree = self._adaptor.createWithPayload(string_literal20)
                        self._adaptor.addChild(root_0, string_literal20_tree)

                    IDENTIFIER21=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_statement209)
                    if self._state.backtracking == 0:

                        IDENTIFIER21_tree = self._adaptor.createWithPayload(IDENTIFIER21)
                        self._adaptor.addChild(root_0, IDENTIFIER21_tree)



                elif alt2 == 18:
                    # jal.g:33:11: '_debug' STRING_LITERAL
                    pass 
                    root_0 = self._adaptor.nil()

                    string_literal22=self.match(self.input, 22, self.FOLLOW_22_in_statement221)
                    if self._state.backtracking == 0:

                        string_literal22_tree = self._adaptor.createWithPayload(string_literal22)
                        self._adaptor.addChild(root_0, string_literal22_tree)

                    STRING_LITERAL23=self.match(self.input, STRING_LITERAL, self.FOLLOW_STRING_LITERAL_in_statement223)
                    if self._state.backtracking == 0:

                        STRING_LITERAL23_tree = self._adaptor.createWithPayload(STRING_LITERAL23)
                        self._adaptor.addChild(root_0, STRING_LITERAL23_tree)



                elif alt2 == 19:
                    # jal.g:34:11: '_error' STRING_LITERAL
                    pass 
                    root_0 = self._adaptor.nil()

                    string_literal24=self.match(self.input, 23, self.FOLLOW_23_in_statement235)
                    if self._state.backtracking == 0:

                        string_literal24_tree = self._adaptor.createWithPayload(string_literal24)
                        self._adaptor.addChild(root_0, string_literal24_tree)

                    STRING_LITERAL25=self.match(self.input, STRING_LITERAL, self.FOLLOW_STRING_LITERAL_in_statement237)
                    if self._state.backtracking == 0:

                        STRING_LITERAL25_tree = self._adaptor.createWithPayload(STRING_LITERAL25)
                        self._adaptor.addChild(root_0, STRING_LITERAL25_tree)



                elif alt2 == 20:
                    # jal.g:35:11: '_warn' STRING_LITERAL
                    pass 
                    root_0 = self._adaptor.nil()

                    string_literal26=self.match(self.input, 24, self.FOLLOW_24_in_statement249)
                    if self._state.backtracking == 0:

                        string_literal26_tree = self._adaptor.createWithPayload(string_literal26)
                        self._adaptor.addChild(root_0, string_literal26_tree)

                    STRING_LITERAL27=self.match(self.input, STRING_LITERAL, self.FOLLOW_STRING_LITERAL_in_statement251)
                    if self._state.backtracking == 0:

                        STRING_LITERAL27_tree = self._adaptor.createWithPayload(STRING_LITERAL27)
                        self._adaptor.addChild(root_0, STRING_LITERAL27_tree)



                elif alt2 == 21:
                    # jal.g:36:4: IDENTIFIER '=' expr
                    pass 
                    root_0 = self._adaptor.nil()

                    IDENTIFIER28=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_statement256)
                    if self._state.backtracking == 0:

                        IDENTIFIER28_tree = self._adaptor.createWithPayload(IDENTIFIER28)
                        self._adaptor.addChild(root_0, IDENTIFIER28_tree)

                    char_literal29=self.match(self.input, 25, self.FOLLOW_25_in_statement258)
                    if self._state.backtracking == 0:

                        char_literal29_tree = self._adaptor.createWithPayload(char_literal29)
                        self._adaptor.addChild(root_0, char_literal29_tree)

                    self._state.following.append(self.FOLLOW_expr_in_statement260)
                    expr30 = self.expr()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, expr30.tree)


                elif alt2 == 22:
                    # jal.g:37:4: proc_func_call
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_proc_func_call_in_statement265)
                    proc_func_call31 = self.proc_func_call()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, proc_func_call31.tree)


                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "statement"

    class cexpr_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "cexpr"
    # jal.g:41:1: cexpr : constant ;
    def cexpr(self, ):

        retval = self.cexpr_return()
        retval.start = self.input.LT(1)

        root_0 = None

        constant32 = None



        try:
            try:
                # jal.g:41:9: ( constant )
                # jal.g:41:13: constant
                pass 
                root_0 = self._adaptor.nil()

                self._state.following.append(self.FOLLOW_constant_in_cexpr280)
                constant32 = self.constant()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, constant32.tree)



                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "cexpr"

    class cexpr_list_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "cexpr_list"
    # jal.g:44:1: cexpr_list : '{' cexpr ( ',' cexpr )* '}' ;
    def cexpr_list(self, ):

        retval = self.cexpr_list_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal33 = None
        char_literal35 = None
        char_literal37 = None
        cexpr34 = None

        cexpr36 = None


        char_literal33_tree = None
        char_literal35_tree = None
        char_literal37_tree = None

        try:
            try:
                # jal.g:44:12: ( '{' cexpr ( ',' cexpr )* '}' )
                # jal.g:44:14: '{' cexpr ( ',' cexpr )* '}'
                pass 
                root_0 = self._adaptor.nil()

                char_literal33=self.match(self.input, 26, self.FOLLOW_26_in_cexpr_list297)
                if self._state.backtracking == 0:

                    char_literal33_tree = self._adaptor.createWithPayload(char_literal33)
                    self._adaptor.addChild(root_0, char_literal33_tree)

                self._state.following.append(self.FOLLOW_cexpr_in_cexpr_list299)
                cexpr34 = self.cexpr()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, cexpr34.tree)
                # jal.g:44:24: ( ',' cexpr )*
                while True: #loop3
                    alt3 = 2
                    LA3_0 = self.input.LA(1)

                    if (LA3_0 == 27) :
                        alt3 = 1


                    if alt3 == 1:
                        # jal.g:44:26: ',' cexpr
                        pass 
                        char_literal35=self.match(self.input, 27, self.FOLLOW_27_in_cexpr_list303)
                        if self._state.backtracking == 0:

                            char_literal35_tree = self._adaptor.createWithPayload(char_literal35)
                            self._adaptor.addChild(root_0, char_literal35_tree)

                        self._state.following.append(self.FOLLOW_cexpr_in_cexpr_list305)
                        cexpr36 = self.cexpr()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, cexpr36.tree)


                    else:
                        break #loop3


                char_literal37=self.match(self.input, 28, self.FOLLOW_28_in_cexpr_list310)
                if self._state.backtracking == 0:

                    char_literal37_tree = self._adaptor.createWithPayload(char_literal37)
                    self._adaptor.addChild(root_0, char_literal37_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "cexpr_list"

    class for_stmt_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "for_stmt"
    # jal.g:47:1: for_stmt : 'for' expr ( 'using' IDENTIFIER )* 'loop' ( statement )+ ( 'exit' 'loop' )* 'end' 'loop' ;
    def for_stmt(self, ):

        retval = self.for_stmt_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal38 = None
        string_literal40 = None
        IDENTIFIER41 = None
        string_literal42 = None
        string_literal44 = None
        string_literal45 = None
        string_literal46 = None
        string_literal47 = None
        expr39 = None

        statement43 = None


        string_literal38_tree = None
        string_literal40_tree = None
        IDENTIFIER41_tree = None
        string_literal42_tree = None
        string_literal44_tree = None
        string_literal45_tree = None
        string_literal46_tree = None
        string_literal47_tree = None

        try:
            try:
                # jal.g:47:10: ( 'for' expr ( 'using' IDENTIFIER )* 'loop' ( statement )+ ( 'exit' 'loop' )* 'end' 'loop' )
                # jal.g:47:12: 'for' expr ( 'using' IDENTIFIER )* 'loop' ( statement )+ ( 'exit' 'loop' )* 'end' 'loop'
                pass 
                root_0 = self._adaptor.nil()

                string_literal38=self.match(self.input, 29, self.FOLLOW_29_in_for_stmt321)
                if self._state.backtracking == 0:

                    string_literal38_tree = self._adaptor.createWithPayload(string_literal38)
                    self._adaptor.addChild(root_0, string_literal38_tree)

                self._state.following.append(self.FOLLOW_expr_in_for_stmt323)
                expr39 = self.expr()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, expr39.tree)
                # jal.g:47:23: ( 'using' IDENTIFIER )*
                while True: #loop4
                    alt4 = 2
                    LA4_0 = self.input.LA(1)

                    if (LA4_0 == 30) :
                        alt4 = 1


                    if alt4 == 1:
                        # jal.g:47:25: 'using' IDENTIFIER
                        pass 
                        string_literal40=self.match(self.input, 30, self.FOLLOW_30_in_for_stmt327)
                        if self._state.backtracking == 0:

                            string_literal40_tree = self._adaptor.createWithPayload(string_literal40)
                            self._adaptor.addChild(root_0, string_literal40_tree)

                        IDENTIFIER41=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_for_stmt329)
                        if self._state.backtracking == 0:

                            IDENTIFIER41_tree = self._adaptor.createWithPayload(IDENTIFIER41)
                            self._adaptor.addChild(root_0, IDENTIFIER41_tree)



                    else:
                        break #loop4


                string_literal42=self.match(self.input, 31, self.FOLLOW_31_in_for_stmt334)
                if self._state.backtracking == 0:

                    string_literal42_tree = self._adaptor.createWithPayload(string_literal42)
                    self._adaptor.addChild(root_0, string_literal42_tree)

                # jal.g:48:17: ( statement )+
                cnt5 = 0
                while True: #loop5
                    alt5 = 2
                    LA5_0 = self.input.LA(1)

                    if (LA5_0 == IDENTIFIER or (19 <= LA5_0 <= 24) or LA5_0 == 29 or (34 <= LA5_0 <= 36) or LA5_0 == 38 or LA5_0 == 42 or (46 <= LA5_0 <= 47) or LA5_0 == 51 or (57 <= LA5_0 <= 58) or LA5_0 == 61) :
                        alt5 = 1


                    if alt5 == 1:
                        # jal.g:0:0: statement
                        pass 
                        self._state.following.append(self.FOLLOW_statement_in_for_stmt353)
                        statement43 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement43.tree)


                    else:
                        if cnt5 >= 1:
                            break #loop5

                        if self._state.backtracking > 0:
                            raise BacktrackingFailed

                        eee = EarlyExitException(5, self.input)
                        raise eee

                    cnt5 += 1


                # jal.g:49:17: ( 'exit' 'loop' )*
                while True: #loop6
                    alt6 = 2
                    LA6_0 = self.input.LA(1)

                    if (LA6_0 == 32) :
                        alt6 = 1


                    if alt6 == 1:
                        # jal.g:49:19: 'exit' 'loop'
                        pass 
                        string_literal44=self.match(self.input, 32, self.FOLLOW_32_in_for_stmt374)
                        if self._state.backtracking == 0:

                            string_literal44_tree = self._adaptor.createWithPayload(string_literal44)
                            self._adaptor.addChild(root_0, string_literal44_tree)

                        string_literal45=self.match(self.input, 31, self.FOLLOW_31_in_for_stmt376)
                        if self._state.backtracking == 0:

                            string_literal45_tree = self._adaptor.createWithPayload(string_literal45)
                            self._adaptor.addChild(root_0, string_literal45_tree)



                    else:
                        break #loop6


                string_literal46=self.match(self.input, 33, self.FOLLOW_33_in_for_stmt393)
                if self._state.backtracking == 0:

                    string_literal46_tree = self._adaptor.createWithPayload(string_literal46)
                    self._adaptor.addChild(root_0, string_literal46_tree)

                string_literal47=self.match(self.input, 31, self.FOLLOW_31_in_for_stmt395)
                if self._state.backtracking == 0:

                    string_literal47_tree = self._adaptor.createWithPayload(string_literal47)
                    self._adaptor.addChild(root_0, string_literal47_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "for_stmt"

    class forever_stmt_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "forever_stmt"
    # jal.g:53:1: forever_stmt : 'forever' 'loop' ( statement )+ ( 'exit' 'loop' )* 'end' 'loop' ;
    def forever_stmt(self, ):

        retval = self.forever_stmt_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal48 = None
        string_literal49 = None
        string_literal51 = None
        string_literal52 = None
        string_literal53 = None
        string_literal54 = None
        statement50 = None


        string_literal48_tree = None
        string_literal49_tree = None
        string_literal51_tree = None
        string_literal52_tree = None
        string_literal53_tree = None
        string_literal54_tree = None

        try:
            try:
                # jal.g:53:14: ( 'forever' 'loop' ( statement )+ ( 'exit' 'loop' )* 'end' 'loop' )
                # jal.g:53:16: 'forever' 'loop' ( statement )+ ( 'exit' 'loop' )* 'end' 'loop'
                pass 
                root_0 = self._adaptor.nil()

                string_literal48=self.match(self.input, 34, self.FOLLOW_34_in_forever_stmt412)
                if self._state.backtracking == 0:

                    string_literal48_tree = self._adaptor.createWithPayload(string_literal48)
                    self._adaptor.addChild(root_0, string_literal48_tree)

                string_literal49=self.match(self.input, 31, self.FOLLOW_31_in_forever_stmt414)
                if self._state.backtracking == 0:

                    string_literal49_tree = self._adaptor.createWithPayload(string_literal49)
                    self._adaptor.addChild(root_0, string_literal49_tree)

                # jal.g:54:17: ( statement )+
                cnt7 = 0
                while True: #loop7
                    alt7 = 2
                    LA7_0 = self.input.LA(1)

                    if (LA7_0 == IDENTIFIER or (19 <= LA7_0 <= 24) or LA7_0 == 29 or (34 <= LA7_0 <= 36) or LA7_0 == 38 or LA7_0 == 42 or (46 <= LA7_0 <= 47) or LA7_0 == 51 or (57 <= LA7_0 <= 58) or LA7_0 == 61) :
                        alt7 = 1


                    if alt7 == 1:
                        # jal.g:0:0: statement
                        pass 
                        self._state.following.append(self.FOLLOW_statement_in_forever_stmt433)
                        statement50 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement50.tree)


                    else:
                        if cnt7 >= 1:
                            break #loop7

                        if self._state.backtracking > 0:
                            raise BacktrackingFailed

                        eee = EarlyExitException(7, self.input)
                        raise eee

                    cnt7 += 1


                # jal.g:55:17: ( 'exit' 'loop' )*
                while True: #loop8
                    alt8 = 2
                    LA8_0 = self.input.LA(1)

                    if (LA8_0 == 32) :
                        alt8 = 1


                    if alt8 == 1:
                        # jal.g:55:19: 'exit' 'loop'
                        pass 
                        string_literal51=self.match(self.input, 32, self.FOLLOW_32_in_forever_stmt454)
                        if self._state.backtracking == 0:

                            string_literal51_tree = self._adaptor.createWithPayload(string_literal51)
                            self._adaptor.addChild(root_0, string_literal51_tree)

                        string_literal52=self.match(self.input, 31, self.FOLLOW_31_in_forever_stmt456)
                        if self._state.backtracking == 0:

                            string_literal52_tree = self._adaptor.createWithPayload(string_literal52)
                            self._adaptor.addChild(root_0, string_literal52_tree)



                    else:
                        break #loop8


                string_literal53=self.match(self.input, 33, self.FOLLOW_33_in_forever_stmt473)
                if self._state.backtracking == 0:

                    string_literal53_tree = self._adaptor.createWithPayload(string_literal53)
                    self._adaptor.addChild(root_0, string_literal53_tree)

                string_literal54=self.match(self.input, 31, self.FOLLOW_31_in_forever_stmt475)
                if self._state.backtracking == 0:

                    string_literal54_tree = self._adaptor.createWithPayload(string_literal54)
                    self._adaptor.addChild(root_0, string_literal54_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "forever_stmt"

    class while_stmt_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "while_stmt"
    # jal.g:59:1: while_stmt : 'while' expr 'loop' ( statement )+ ( 'exit' 'loop' )* 'end' 'loop' ;
    def while_stmt(self, ):

        retval = self.while_stmt_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal55 = None
        string_literal57 = None
        string_literal59 = None
        string_literal60 = None
        string_literal61 = None
        string_literal62 = None
        expr56 = None

        statement58 = None


        string_literal55_tree = None
        string_literal57_tree = None
        string_literal59_tree = None
        string_literal60_tree = None
        string_literal61_tree = None
        string_literal62_tree = None

        try:
            try:
                # jal.g:59:12: ( 'while' expr 'loop' ( statement )+ ( 'exit' 'loop' )* 'end' 'loop' )
                # jal.g:59:14: 'while' expr 'loop' ( statement )+ ( 'exit' 'loop' )* 'end' 'loop'
                pass 
                root_0 = self._adaptor.nil()

                string_literal55=self.match(self.input, 35, self.FOLLOW_35_in_while_stmt492)
                if self._state.backtracking == 0:

                    string_literal55_tree = self._adaptor.createWithPayload(string_literal55)
                    self._adaptor.addChild(root_0, string_literal55_tree)

                self._state.following.append(self.FOLLOW_expr_in_while_stmt494)
                expr56 = self.expr()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, expr56.tree)
                string_literal57=self.match(self.input, 31, self.FOLLOW_31_in_while_stmt496)
                if self._state.backtracking == 0:

                    string_literal57_tree = self._adaptor.createWithPayload(string_literal57)
                    self._adaptor.addChild(root_0, string_literal57_tree)

                # jal.g:60:17: ( statement )+
                cnt9 = 0
                while True: #loop9
                    alt9 = 2
                    LA9_0 = self.input.LA(1)

                    if (LA9_0 == IDENTIFIER or (19 <= LA9_0 <= 24) or LA9_0 == 29 or (34 <= LA9_0 <= 36) or LA9_0 == 38 or LA9_0 == 42 or (46 <= LA9_0 <= 47) or LA9_0 == 51 or (57 <= LA9_0 <= 58) or LA9_0 == 61) :
                        alt9 = 1


                    if alt9 == 1:
                        # jal.g:0:0: statement
                        pass 
                        self._state.following.append(self.FOLLOW_statement_in_while_stmt515)
                        statement58 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement58.tree)


                    else:
                        if cnt9 >= 1:
                            break #loop9

                        if self._state.backtracking > 0:
                            raise BacktrackingFailed

                        eee = EarlyExitException(9, self.input)
                        raise eee

                    cnt9 += 1


                # jal.g:61:17: ( 'exit' 'loop' )*
                while True: #loop10
                    alt10 = 2
                    LA10_0 = self.input.LA(1)

                    if (LA10_0 == 32) :
                        alt10 = 1


                    if alt10 == 1:
                        # jal.g:61:19: 'exit' 'loop'
                        pass 
                        string_literal59=self.match(self.input, 32, self.FOLLOW_32_in_while_stmt536)
                        if self._state.backtracking == 0:

                            string_literal59_tree = self._adaptor.createWithPayload(string_literal59)
                            self._adaptor.addChild(root_0, string_literal59_tree)

                        string_literal60=self.match(self.input, 31, self.FOLLOW_31_in_while_stmt538)
                        if self._state.backtracking == 0:

                            string_literal60_tree = self._adaptor.createWithPayload(string_literal60)
                            self._adaptor.addChild(root_0, string_literal60_tree)



                    else:
                        break #loop10


                string_literal61=self.match(self.input, 33, self.FOLLOW_33_in_while_stmt555)
                if self._state.backtracking == 0:

                    string_literal61_tree = self._adaptor.createWithPayload(string_literal61)
                    self._adaptor.addChild(root_0, string_literal61_tree)

                string_literal62=self.match(self.input, 31, self.FOLLOW_31_in_while_stmt557)
                if self._state.backtracking == 0:

                    string_literal62_tree = self._adaptor.createWithPayload(string_literal62)
                    self._adaptor.addChild(root_0, string_literal62_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "while_stmt"

    class repeat_stmt_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "repeat_stmt"
    # jal.g:65:1: repeat_stmt : 'repeat' ( statement )+ ( 'exit' 'loop' )* 'until' expr ;
    def repeat_stmt(self, ):

        retval = self.repeat_stmt_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal63 = None
        string_literal65 = None
        string_literal66 = None
        string_literal67 = None
        statement64 = None

        expr68 = None


        string_literal63_tree = None
        string_literal65_tree = None
        string_literal66_tree = None
        string_literal67_tree = None

        try:
            try:
                # jal.g:65:13: ( 'repeat' ( statement )+ ( 'exit' 'loop' )* 'until' expr )
                # jal.g:65:15: 'repeat' ( statement )+ ( 'exit' 'loop' )* 'until' expr
                pass 
                root_0 = self._adaptor.nil()

                string_literal63=self.match(self.input, 36, self.FOLLOW_36_in_repeat_stmt574)
                if self._state.backtracking == 0:

                    string_literal63_tree = self._adaptor.createWithPayload(string_literal63)
                    self._adaptor.addChild(root_0, string_literal63_tree)

                # jal.g:66:17: ( statement )+
                cnt11 = 0
                while True: #loop11
                    alt11 = 2
                    LA11_0 = self.input.LA(1)

                    if (LA11_0 == IDENTIFIER or (19 <= LA11_0 <= 24) or LA11_0 == 29 or (34 <= LA11_0 <= 36) or LA11_0 == 38 or LA11_0 == 42 or (46 <= LA11_0 <= 47) or LA11_0 == 51 or (57 <= LA11_0 <= 58) or LA11_0 == 61) :
                        alt11 = 1


                    if alt11 == 1:
                        # jal.g:0:0: statement
                        pass 
                        self._state.following.append(self.FOLLOW_statement_in_repeat_stmt592)
                        statement64 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement64.tree)


                    else:
                        if cnt11 >= 1:
                            break #loop11

                        if self._state.backtracking > 0:
                            raise BacktrackingFailed

                        eee = EarlyExitException(11, self.input)
                        raise eee

                    cnt11 += 1


                # jal.g:67:17: ( 'exit' 'loop' )*
                while True: #loop12
                    alt12 = 2
                    LA12_0 = self.input.LA(1)

                    if (LA12_0 == 32) :
                        alt12 = 1


                    if alt12 == 1:
                        # jal.g:67:19: 'exit' 'loop'
                        pass 
                        string_literal65=self.match(self.input, 32, self.FOLLOW_32_in_repeat_stmt613)
                        if self._state.backtracking == 0:

                            string_literal65_tree = self._adaptor.createWithPayload(string_literal65)
                            self._adaptor.addChild(root_0, string_literal65_tree)

                        string_literal66=self.match(self.input, 31, self.FOLLOW_31_in_repeat_stmt615)
                        if self._state.backtracking == 0:

                            string_literal66_tree = self._adaptor.createWithPayload(string_literal66)
                            self._adaptor.addChild(root_0, string_literal66_tree)



                    else:
                        break #loop12


                string_literal67=self.match(self.input, 37, self.FOLLOW_37_in_repeat_stmt632)
                if self._state.backtracking == 0:

                    string_literal67_tree = self._adaptor.createWithPayload(string_literal67)
                    self._adaptor.addChild(root_0, string_literal67_tree)

                self._state.following.append(self.FOLLOW_expr_in_repeat_stmt634)
                expr68 = self.expr()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, expr68.tree)



                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "repeat_stmt"

    class if_stmt_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "if_stmt"
    # jal.g:71:1: if_stmt : 'if' expr 'then' ( statement )+ ( 'elsif' expr 'then' ( statement )+ )* ( 'else' ( statement )+ )* 'end' 'if' ;
    def if_stmt(self, ):

        retval = self.if_stmt_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal69 = None
        string_literal71 = None
        string_literal73 = None
        string_literal75 = None
        string_literal77 = None
        string_literal79 = None
        string_literal80 = None
        expr70 = None

        statement72 = None

        expr74 = None

        statement76 = None

        statement78 = None


        string_literal69_tree = None
        string_literal71_tree = None
        string_literal73_tree = None
        string_literal75_tree = None
        string_literal77_tree = None
        string_literal79_tree = None
        string_literal80_tree = None

        try:
            try:
                # jal.g:71:9: ( 'if' expr 'then' ( statement )+ ( 'elsif' expr 'then' ( statement )+ )* ( 'else' ( statement )+ )* 'end' 'if' )
                # jal.g:71:11: 'if' expr 'then' ( statement )+ ( 'elsif' expr 'then' ( statement )+ )* ( 'else' ( statement )+ )* 'end' 'if'
                pass 
                root_0 = self._adaptor.nil()

                string_literal69=self.match(self.input, 38, self.FOLLOW_38_in_if_stmt651)
                if self._state.backtracking == 0:

                    string_literal69_tree = self._adaptor.createWithPayload(string_literal69)
                    self._adaptor.addChild(root_0, string_literal69_tree)

                self._state.following.append(self.FOLLOW_expr_in_if_stmt653)
                expr70 = self.expr()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, expr70.tree)
                string_literal71=self.match(self.input, 39, self.FOLLOW_39_in_if_stmt655)
                if self._state.backtracking == 0:

                    string_literal71_tree = self._adaptor.createWithPayload(string_literal71)
                    self._adaptor.addChild(root_0, string_literal71_tree)

                # jal.g:71:28: ( statement )+
                cnt13 = 0
                while True: #loop13
                    alt13 = 2
                    LA13_0 = self.input.LA(1)

                    if (LA13_0 == IDENTIFIER or (19 <= LA13_0 <= 24) or LA13_0 == 29 or (34 <= LA13_0 <= 36) or LA13_0 == 38 or LA13_0 == 42 or (46 <= LA13_0 <= 47) or LA13_0 == 51 or (57 <= LA13_0 <= 58) or LA13_0 == 61) :
                        alt13 = 1


                    if alt13 == 1:
                        # jal.g:0:0: statement
                        pass 
                        self._state.following.append(self.FOLLOW_statement_in_if_stmt657)
                        statement72 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement72.tree)


                    else:
                        if cnt13 >= 1:
                            break #loop13

                        if self._state.backtracking > 0:
                            raise BacktrackingFailed

                        eee = EarlyExitException(13, self.input)
                        raise eee

                    cnt13 += 1


                # jal.g:72:13: ( 'elsif' expr 'then' ( statement )+ )*
                while True: #loop15
                    alt15 = 2
                    LA15_0 = self.input.LA(1)

                    if (LA15_0 == 40) :
                        alt15 = 1


                    if alt15 == 1:
                        # jal.g:72:14: 'elsif' expr 'then' ( statement )+
                        pass 
                        string_literal73=self.match(self.input, 40, self.FOLLOW_40_in_if_stmt673)
                        if self._state.backtracking == 0:

                            string_literal73_tree = self._adaptor.createWithPayload(string_literal73)
                            self._adaptor.addChild(root_0, string_literal73_tree)

                        self._state.following.append(self.FOLLOW_expr_in_if_stmt675)
                        expr74 = self.expr()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, expr74.tree)
                        string_literal75=self.match(self.input, 39, self.FOLLOW_39_in_if_stmt677)
                        if self._state.backtracking == 0:

                            string_literal75_tree = self._adaptor.createWithPayload(string_literal75)
                            self._adaptor.addChild(root_0, string_literal75_tree)

                        # jal.g:72:34: ( statement )+
                        cnt14 = 0
                        while True: #loop14
                            alt14 = 2
                            LA14_0 = self.input.LA(1)

                            if (LA14_0 == IDENTIFIER or (19 <= LA14_0 <= 24) or LA14_0 == 29 or (34 <= LA14_0 <= 36) or LA14_0 == 38 or LA14_0 == 42 or (46 <= LA14_0 <= 47) or LA14_0 == 51 or (57 <= LA14_0 <= 58) or LA14_0 == 61) :
                                alt14 = 1


                            if alt14 == 1:
                                # jal.g:0:0: statement
                                pass 
                                self._state.following.append(self.FOLLOW_statement_in_if_stmt679)
                                statement76 = self.statement()

                                self._state.following.pop()
                                if self._state.backtracking == 0:
                                    self._adaptor.addChild(root_0, statement76.tree)


                            else:
                                if cnt14 >= 1:
                                    break #loop14

                                if self._state.backtracking > 0:
                                    raise BacktrackingFailed

                                eee = EarlyExitException(14, self.input)
                                raise eee

                            cnt14 += 1




                    else:
                        break #loop15


                # jal.g:73:13: ( 'else' ( statement )+ )*
                while True: #loop17
                    alt17 = 2
                    LA17_0 = self.input.LA(1)

                    if (LA17_0 == 41) :
                        alt17 = 1


                    if alt17 == 1:
                        # jal.g:73:14: 'else' ( statement )+
                        pass 
                        string_literal77=self.match(self.input, 41, self.FOLLOW_41_in_if_stmt698)
                        if self._state.backtracking == 0:

                            string_literal77_tree = self._adaptor.createWithPayload(string_literal77)
                            self._adaptor.addChild(root_0, string_literal77_tree)

                        # jal.g:73:21: ( statement )+
                        cnt16 = 0
                        while True: #loop16
                            alt16 = 2
                            LA16_0 = self.input.LA(1)

                            if (LA16_0 == IDENTIFIER or (19 <= LA16_0 <= 24) or LA16_0 == 29 or (34 <= LA16_0 <= 36) or LA16_0 == 38 or LA16_0 == 42 or (46 <= LA16_0 <= 47) or LA16_0 == 51 or (57 <= LA16_0 <= 58) or LA16_0 == 61) :
                                alt16 = 1


                            if alt16 == 1:
                                # jal.g:0:0: statement
                                pass 
                                self._state.following.append(self.FOLLOW_statement_in_if_stmt700)
                                statement78 = self.statement()

                                self._state.following.pop()
                                if self._state.backtracking == 0:
                                    self._adaptor.addChild(root_0, statement78.tree)


                            else:
                                if cnt16 >= 1:
                                    break #loop16

                                if self._state.backtracking > 0:
                                    raise BacktrackingFailed

                                eee = EarlyExitException(16, self.input)
                                raise eee

                            cnt16 += 1




                    else:
                        break #loop17


                string_literal79=self.match(self.input, 33, self.FOLLOW_33_in_if_stmt718)
                if self._state.backtracking == 0:

                    string_literal79_tree = self._adaptor.createWithPayload(string_literal79)
                    self._adaptor.addChild(root_0, string_literal79_tree)

                string_literal80=self.match(self.input, 38, self.FOLLOW_38_in_if_stmt720)
                if self._state.backtracking == 0:

                    string_literal80_tree = self._adaptor.createWithPayload(string_literal80)
                    self._adaptor.addChild(root_0, string_literal80_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "if_stmt"

    class case_stmt_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "case_stmt"
    # jal.g:77:1: case_stmt : 'case' expr 'of' cexpr ( ',' cexpr )* ':' statement ( cexpr ( ',' cexpr )* ':' statement )* ( 'otherwise' statement )* 'end' 'case' ;
    def case_stmt(self, ):

        retval = self.case_stmt_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal81 = None
        string_literal83 = None
        char_literal85 = None
        char_literal87 = None
        char_literal90 = None
        char_literal92 = None
        string_literal94 = None
        string_literal96 = None
        string_literal97 = None
        expr82 = None

        cexpr84 = None

        cexpr86 = None

        statement88 = None

        cexpr89 = None

        cexpr91 = None

        statement93 = None

        statement95 = None


        string_literal81_tree = None
        string_literal83_tree = None
        char_literal85_tree = None
        char_literal87_tree = None
        char_literal90_tree = None
        char_literal92_tree = None
        string_literal94_tree = None
        string_literal96_tree = None
        string_literal97_tree = None

        try:
            try:
                # jal.g:77:11: ( 'case' expr 'of' cexpr ( ',' cexpr )* ':' statement ( cexpr ( ',' cexpr )* ':' statement )* ( 'otherwise' statement )* 'end' 'case' )
                # jal.g:77:13: 'case' expr 'of' cexpr ( ',' cexpr )* ':' statement ( cexpr ( ',' cexpr )* ':' statement )* ( 'otherwise' statement )* 'end' 'case'
                pass 
                root_0 = self._adaptor.nil()

                string_literal81=self.match(self.input, 42, self.FOLLOW_42_in_case_stmt737)
                if self._state.backtracking == 0:

                    string_literal81_tree = self._adaptor.createWithPayload(string_literal81)
                    self._adaptor.addChild(root_0, string_literal81_tree)

                self._state.following.append(self.FOLLOW_expr_in_case_stmt739)
                expr82 = self.expr()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, expr82.tree)
                string_literal83=self.match(self.input, 43, self.FOLLOW_43_in_case_stmt741)
                if self._state.backtracking == 0:

                    string_literal83_tree = self._adaptor.createWithPayload(string_literal83)
                    self._adaptor.addChild(root_0, string_literal83_tree)

                self._state.following.append(self.FOLLOW_cexpr_in_case_stmt759)
                cexpr84 = self.cexpr()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, cexpr84.tree)
                # jal.g:78:23: ( ',' cexpr )*
                while True: #loop18
                    alt18 = 2
                    LA18_0 = self.input.LA(1)

                    if (LA18_0 == 27) :
                        alt18 = 1


                    if alt18 == 1:
                        # jal.g:78:24: ',' cexpr
                        pass 
                        char_literal85=self.match(self.input, 27, self.FOLLOW_27_in_case_stmt762)
                        if self._state.backtracking == 0:

                            char_literal85_tree = self._adaptor.createWithPayload(char_literal85)
                            self._adaptor.addChild(root_0, char_literal85_tree)

                        self._state.following.append(self.FOLLOW_cexpr_in_case_stmt764)
                        cexpr86 = self.cexpr()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, cexpr86.tree)


                    else:
                        break #loop18


                char_literal87=self.match(self.input, 44, self.FOLLOW_44_in_case_stmt768)
                if self._state.backtracking == 0:

                    char_literal87_tree = self._adaptor.createWithPayload(char_literal87)
                    self._adaptor.addChild(root_0, char_literal87_tree)

                self._state.following.append(self.FOLLOW_statement_in_case_stmt770)
                statement88 = self.statement()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, statement88.tree)
                # jal.g:79:17: ( cexpr ( ',' cexpr )* ':' statement )*
                while True: #loop20
                    alt20 = 2
                    LA20_0 = self.input.LA(1)

                    if ((BIN_LITERAL <= LA20_0 <= DECIMAL_LITERAL)) :
                        alt20 = 1


                    if alt20 == 1:
                        # jal.g:79:19: cexpr ( ',' cexpr )* ':' statement
                        pass 
                        self._state.following.append(self.FOLLOW_cexpr_in_case_stmt790)
                        cexpr89 = self.cexpr()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, cexpr89.tree)
                        # jal.g:79:25: ( ',' cexpr )*
                        while True: #loop19
                            alt19 = 2
                            LA19_0 = self.input.LA(1)

                            if (LA19_0 == 27) :
                                alt19 = 1


                            if alt19 == 1:
                                # jal.g:79:26: ',' cexpr
                                pass 
                                char_literal90=self.match(self.input, 27, self.FOLLOW_27_in_case_stmt793)
                                if self._state.backtracking == 0:

                                    char_literal90_tree = self._adaptor.createWithPayload(char_literal90)
                                    self._adaptor.addChild(root_0, char_literal90_tree)

                                self._state.following.append(self.FOLLOW_cexpr_in_case_stmt795)
                                cexpr91 = self.cexpr()

                                self._state.following.pop()
                                if self._state.backtracking == 0:
                                    self._adaptor.addChild(root_0, cexpr91.tree)


                            else:
                                break #loop19


                        char_literal92=self.match(self.input, 44, self.FOLLOW_44_in_case_stmt799)
                        if self._state.backtracking == 0:

                            char_literal92_tree = self._adaptor.createWithPayload(char_literal92)
                            self._adaptor.addChild(root_0, char_literal92_tree)

                        self._state.following.append(self.FOLLOW_statement_in_case_stmt801)
                        statement93 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement93.tree)


                    else:
                        break #loop20


                # jal.g:80:17: ( 'otherwise' statement )*
                while True: #loop21
                    alt21 = 2
                    LA21_0 = self.input.LA(1)

                    if (LA21_0 == 45) :
                        alt21 = 1


                    if alt21 == 1:
                        # jal.g:80:18: 'otherwise' statement
                        pass 
                        string_literal94=self.match(self.input, 45, self.FOLLOW_45_in_case_stmt823)
                        if self._state.backtracking == 0:

                            string_literal94_tree = self._adaptor.createWithPayload(string_literal94)
                            self._adaptor.addChild(root_0, string_literal94_tree)

                        self._state.following.append(self.FOLLOW_statement_in_case_stmt825)
                        statement95 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement95.tree)


                    else:
                        break #loop21


                string_literal96=self.match(self.input, 33, self.FOLLOW_33_in_case_stmt841)
                if self._state.backtracking == 0:

                    string_literal96_tree = self._adaptor.createWithPayload(string_literal96)
                    self._adaptor.addChild(root_0, string_literal96_tree)

                string_literal97=self.match(self.input, 42, self.FOLLOW_42_in_case_stmt843)
                if self._state.backtracking == 0:

                    string_literal97_tree = self._adaptor.createWithPayload(string_literal97)
                    self._adaptor.addChild(root_0, string_literal97_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "case_stmt"

    class block_stmt_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "block_stmt"
    # jal.g:84:1: block_stmt : 'block' ( statement )+ 'end' 'block' ;
    def block_stmt(self, ):

        retval = self.block_stmt_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal98 = None
        string_literal100 = None
        string_literal101 = None
        statement99 = None


        string_literal98_tree = None
        string_literal100_tree = None
        string_literal101_tree = None

        try:
            try:
                # jal.g:84:12: ( 'block' ( statement )+ 'end' 'block' )
                # jal.g:84:14: 'block' ( statement )+ 'end' 'block'
                pass 
                root_0 = self._adaptor.nil()

                string_literal98=self.match(self.input, 46, self.FOLLOW_46_in_block_stmt860)
                if self._state.backtracking == 0:

                    string_literal98_tree = self._adaptor.createWithPayload(string_literal98)
                    self._adaptor.addChild(root_0, string_literal98_tree)

                # jal.g:84:22: ( statement )+
                cnt22 = 0
                while True: #loop22
                    alt22 = 2
                    LA22_0 = self.input.LA(1)

                    if (LA22_0 == IDENTIFIER or (19 <= LA22_0 <= 24) or LA22_0 == 29 or (34 <= LA22_0 <= 36) or LA22_0 == 38 or LA22_0 == 42 or (46 <= LA22_0 <= 47) or LA22_0 == 51 or (57 <= LA22_0 <= 58) or LA22_0 == 61) :
                        alt22 = 1


                    if alt22 == 1:
                        # jal.g:0:0: statement
                        pass 
                        self._state.following.append(self.FOLLOW_statement_in_block_stmt862)
                        statement99 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement99.tree)


                    else:
                        if cnt22 >= 1:
                            break #loop22

                        if self._state.backtracking > 0:
                            raise BacktrackingFailed

                        eee = EarlyExitException(22, self.input)
                        raise eee

                    cnt22 += 1


                string_literal100=self.match(self.input, 33, self.FOLLOW_33_in_block_stmt865)
                if self._state.backtracking == 0:

                    string_literal100_tree = self._adaptor.createWithPayload(string_literal100)
                    self._adaptor.addChild(root_0, string_literal100_tree)

                string_literal101=self.match(self.input, 46, self.FOLLOW_46_in_block_stmt867)
                if self._state.backtracking == 0:

                    string_literal101_tree = self._adaptor.createWithPayload(string_literal101)
                    self._adaptor.addChild(root_0, string_literal101_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "block_stmt"

    class proc_def_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "proc_def"
    # jal.g:86:1: proc_def : 'procedure' IDENTIFIER ( '(' ( proc_parm ( ',' proc_parm )* )? ')' )? 'is' ( statement )* 'end' 'procedure' ;
    def proc_def(self, ):

        retval = self.proc_def_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal102 = None
        IDENTIFIER103 = None
        char_literal104 = None
        char_literal106 = None
        char_literal108 = None
        string_literal109 = None
        string_literal111 = None
        string_literal112 = None
        proc_parm105 = None

        proc_parm107 = None

        statement110 = None


        string_literal102_tree = None
        IDENTIFIER103_tree = None
        char_literal104_tree = None
        char_literal106_tree = None
        char_literal108_tree = None
        string_literal109_tree = None
        string_literal111_tree = None
        string_literal112_tree = None

        try:
            try:
                # jal.g:86:10: ( 'procedure' IDENTIFIER ( '(' ( proc_parm ( ',' proc_parm )* )? ')' )? 'is' ( statement )* 'end' 'procedure' )
                # jal.g:86:12: 'procedure' IDENTIFIER ( '(' ( proc_parm ( ',' proc_parm )* )? ')' )? 'is' ( statement )* 'end' 'procedure'
                pass 
                root_0 = self._adaptor.nil()

                string_literal102=self.match(self.input, 47, self.FOLLOW_47_in_proc_def876)
                if self._state.backtracking == 0:

                    string_literal102_tree = self._adaptor.createWithPayload(string_literal102)
                    self._adaptor.addChild(root_0, string_literal102_tree)

                IDENTIFIER103=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_proc_def878)
                if self._state.backtracking == 0:

                    IDENTIFIER103_tree = self._adaptor.createWithPayload(IDENTIFIER103)
                    self._adaptor.addChild(root_0, IDENTIFIER103_tree)

                # jal.g:86:35: ( '(' ( proc_parm ( ',' proc_parm )* )? ')' )?
                alt25 = 2
                LA25_0 = self.input.LA(1)

                if (LA25_0 == 48) :
                    alt25 = 1
                if alt25 == 1:
                    # jal.g:86:37: '(' ( proc_parm ( ',' proc_parm )* )? ')'
                    pass 
                    char_literal104=self.match(self.input, 48, self.FOLLOW_48_in_proc_def882)
                    if self._state.backtracking == 0:

                        char_literal104_tree = self._adaptor.createWithPayload(char_literal104)
                        self._adaptor.addChild(root_0, char_literal104_tree)

                    # jal.g:86:41: ( proc_parm ( ',' proc_parm )* )?
                    alt24 = 2
                    LA24_0 = self.input.LA(1)

                    if (LA24_0 == 52 or (65 <= LA24_0 <= 71)) :
                        alt24 = 1
                    if alt24 == 1:
                        # jal.g:86:43: proc_parm ( ',' proc_parm )*
                        pass 
                        self._state.following.append(self.FOLLOW_proc_parm_in_proc_def886)
                        proc_parm105 = self.proc_parm()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, proc_parm105.tree)
                        # jal.g:86:53: ( ',' proc_parm )*
                        while True: #loop23
                            alt23 = 2
                            LA23_0 = self.input.LA(1)

                            if (LA23_0 == 27) :
                                alt23 = 1


                            if alt23 == 1:
                                # jal.g:86:54: ',' proc_parm
                                pass 
                                char_literal106=self.match(self.input, 27, self.FOLLOW_27_in_proc_def889)
                                if self._state.backtracking == 0:

                                    char_literal106_tree = self._adaptor.createWithPayload(char_literal106)
                                    self._adaptor.addChild(root_0, char_literal106_tree)

                                self._state.following.append(self.FOLLOW_proc_parm_in_proc_def891)
                                proc_parm107 = self.proc_parm()

                                self._state.following.pop()
                                if self._state.backtracking == 0:
                                    self._adaptor.addChild(root_0, proc_parm107.tree)


                            else:
                                break #loop23





                    char_literal108=self.match(self.input, 49, self.FOLLOW_49_in_proc_def898)
                    if self._state.backtracking == 0:

                        char_literal108_tree = self._adaptor.createWithPayload(char_literal108)
                        self._adaptor.addChild(root_0, char_literal108_tree)




                string_literal109=self.match(self.input, 50, self.FOLLOW_50_in_proc_def903)
                if self._state.backtracking == 0:

                    string_literal109_tree = self._adaptor.createWithPayload(string_literal109)
                    self._adaptor.addChild(root_0, string_literal109_tree)

                # jal.g:87:17: ( statement )*
                while True: #loop26
                    alt26 = 2
                    LA26_0 = self.input.LA(1)

                    if (LA26_0 == IDENTIFIER or (19 <= LA26_0 <= 24) or LA26_0 == 29 or (34 <= LA26_0 <= 36) or LA26_0 == 38 or LA26_0 == 42 or (46 <= LA26_0 <= 47) or LA26_0 == 51 or (57 <= LA26_0 <= 58) or LA26_0 == 61) :
                        alt26 = 1


                    if alt26 == 1:
                        # jal.g:0:0: statement
                        pass 
                        self._state.following.append(self.FOLLOW_statement_in_proc_def921)
                        statement110 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement110.tree)


                    else:
                        break #loop26


                string_literal111=self.match(self.input, 33, self.FOLLOW_33_in_proc_def936)
                if self._state.backtracking == 0:

                    string_literal111_tree = self._adaptor.createWithPayload(string_literal111)
                    self._adaptor.addChild(root_0, string_literal111_tree)

                string_literal112=self.match(self.input, 47, self.FOLLOW_47_in_proc_def938)
                if self._state.backtracking == 0:

                    string_literal112_tree = self._adaptor.createWithPayload(string_literal112)
                    self._adaptor.addChild(root_0, string_literal112_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "proc_def"

    class func_def_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "func_def"
    # jal.g:91:1: func_def : 'function' IDENTIFIER '(' proc_parm ( ',' proc_parm )* ')' 'is' ( statement )* 'end' 'function' ;
    def func_def(self, ):

        retval = self.func_def_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal113 = None
        IDENTIFIER114 = None
        char_literal115 = None
        char_literal117 = None
        char_literal119 = None
        string_literal120 = None
        string_literal122 = None
        string_literal123 = None
        proc_parm116 = None

        proc_parm118 = None

        statement121 = None


        string_literal113_tree = None
        IDENTIFIER114_tree = None
        char_literal115_tree = None
        char_literal117_tree = None
        char_literal119_tree = None
        string_literal120_tree = None
        string_literal122_tree = None
        string_literal123_tree = None

        try:
            try:
                # jal.g:91:10: ( 'function' IDENTIFIER '(' proc_parm ( ',' proc_parm )* ')' 'is' ( statement )* 'end' 'function' )
                # jal.g:91:12: 'function' IDENTIFIER '(' proc_parm ( ',' proc_parm )* ')' 'is' ( statement )* 'end' 'function'
                pass 
                root_0 = self._adaptor.nil()

                string_literal113=self.match(self.input, 51, self.FOLLOW_51_in_func_def951)
                if self._state.backtracking == 0:

                    string_literal113_tree = self._adaptor.createWithPayload(string_literal113)
                    self._adaptor.addChild(root_0, string_literal113_tree)

                IDENTIFIER114=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_func_def953)
                if self._state.backtracking == 0:

                    IDENTIFIER114_tree = self._adaptor.createWithPayload(IDENTIFIER114)
                    self._adaptor.addChild(root_0, IDENTIFIER114_tree)

                char_literal115=self.match(self.input, 48, self.FOLLOW_48_in_func_def955)
                if self._state.backtracking == 0:

                    char_literal115_tree = self._adaptor.createWithPayload(char_literal115)
                    self._adaptor.addChild(root_0, char_literal115_tree)

                self._state.following.append(self.FOLLOW_proc_parm_in_func_def957)
                proc_parm116 = self.proc_parm()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, proc_parm116.tree)
                # jal.g:91:48: ( ',' proc_parm )*
                while True: #loop27
                    alt27 = 2
                    LA27_0 = self.input.LA(1)

                    if (LA27_0 == 27) :
                        alt27 = 1


                    if alt27 == 1:
                        # jal.g:91:49: ',' proc_parm
                        pass 
                        char_literal117=self.match(self.input, 27, self.FOLLOW_27_in_func_def960)
                        if self._state.backtracking == 0:

                            char_literal117_tree = self._adaptor.createWithPayload(char_literal117)
                            self._adaptor.addChild(root_0, char_literal117_tree)

                        self._state.following.append(self.FOLLOW_proc_parm_in_func_def962)
                        proc_parm118 = self.proc_parm()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, proc_parm118.tree)


                    else:
                        break #loop27


                char_literal119=self.match(self.input, 49, self.FOLLOW_49_in_func_def966)
                if self._state.backtracking == 0:

                    char_literal119_tree = self._adaptor.createWithPayload(char_literal119)
                    self._adaptor.addChild(root_0, char_literal119_tree)

                string_literal120=self.match(self.input, 50, self.FOLLOW_50_in_func_def968)
                if self._state.backtracking == 0:

                    string_literal120_tree = self._adaptor.createWithPayload(string_literal120)
                    self._adaptor.addChild(root_0, string_literal120_tree)

                # jal.g:92:17: ( statement )*
                while True: #loop28
                    alt28 = 2
                    LA28_0 = self.input.LA(1)

                    if (LA28_0 == IDENTIFIER or (19 <= LA28_0 <= 24) or LA28_0 == 29 or (34 <= LA28_0 <= 36) or LA28_0 == 38 or LA28_0 == 42 or (46 <= LA28_0 <= 47) or LA28_0 == 51 or (57 <= LA28_0 <= 58) or LA28_0 == 61) :
                        alt28 = 1


                    if alt28 == 1:
                        # jal.g:0:0: statement
                        pass 
                        self._state.following.append(self.FOLLOW_statement_in_func_def986)
                        statement121 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement121.tree)


                    else:
                        break #loop28


                string_literal122=self.match(self.input, 33, self.FOLLOW_33_in_func_def1001)
                if self._state.backtracking == 0:

                    string_literal122_tree = self._adaptor.createWithPayload(string_literal122)
                    self._adaptor.addChild(root_0, string_literal122_tree)

                string_literal123=self.match(self.input, 51, self.FOLLOW_51_in_func_def1003)
                if self._state.backtracking == 0:

                    string_literal123_tree = self._adaptor.createWithPayload(string_literal123)
                    self._adaptor.addChild(root_0, string_literal123_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "func_def"

    class proc_parm_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "proc_parm"
    # jal.g:96:1: proc_parm : ( 'volatile' )* type ( IN | 'out' | IN 'out' ) IDENTIFIER ( at_decl )? ;
    def proc_parm(self, ):

        retval = self.proc_parm_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal124 = None
        IN126 = None
        string_literal127 = None
        IN128 = None
        string_literal129 = None
        IDENTIFIER130 = None
        type125 = None

        at_decl131 = None


        string_literal124_tree = None
        IN126_tree = None
        string_literal127_tree = None
        IN128_tree = None
        string_literal129_tree = None
        IDENTIFIER130_tree = None

        try:
            try:
                # jal.g:96:11: ( ( 'volatile' )* type ( IN | 'out' | IN 'out' ) IDENTIFIER ( at_decl )? )
                # jal.g:96:13: ( 'volatile' )* type ( IN | 'out' | IN 'out' ) IDENTIFIER ( at_decl )?
                pass 
                root_0 = self._adaptor.nil()

                # jal.g:96:13: ( 'volatile' )*
                while True: #loop29
                    alt29 = 2
                    LA29_0 = self.input.LA(1)

                    if (LA29_0 == 52) :
                        alt29 = 1


                    if alt29 == 1:
                        # jal.g:0:0: 'volatile'
                        pass 
                        string_literal124=self.match(self.input, 52, self.FOLLOW_52_in_proc_parm1016)
                        if self._state.backtracking == 0:

                            string_literal124_tree = self._adaptor.createWithPayload(string_literal124)
                            self._adaptor.addChild(root_0, string_literal124_tree)



                    else:
                        break #loop29


                self._state.following.append(self.FOLLOW_type_in_proc_parm1019)
                type125 = self.type()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, type125.tree)
                # jal.g:96:30: ( IN | 'out' | IN 'out' )
                alt30 = 3
                LA30_0 = self.input.LA(1)

                if (LA30_0 == IN) :
                    LA30_1 = self.input.LA(2)

                    if (LA30_1 == 53) :
                        alt30 = 3
                    elif (LA30_1 == IDENTIFIER) :
                        alt30 = 1
                    else:
                        if self._state.backtracking > 0:
                            raise BacktrackingFailed

                        nvae = NoViableAltException("", 30, 1, self.input)

                        raise nvae

                elif (LA30_0 == 53) :
                    alt30 = 2
                else:
                    if self._state.backtracking > 0:
                        raise BacktrackingFailed

                    nvae = NoViableAltException("", 30, 0, self.input)

                    raise nvae

                if alt30 == 1:
                    # jal.g:96:32: IN
                    pass 
                    IN126=self.match(self.input, IN, self.FOLLOW_IN_in_proc_parm1023)
                    if self._state.backtracking == 0:

                        IN126_tree = self._adaptor.createWithPayload(IN126)
                        self._adaptor.addChild(root_0, IN126_tree)



                elif alt30 == 2:
                    # jal.g:96:37: 'out'
                    pass 
                    string_literal127=self.match(self.input, 53, self.FOLLOW_53_in_proc_parm1027)
                    if self._state.backtracking == 0:

                        string_literal127_tree = self._adaptor.createWithPayload(string_literal127)
                        self._adaptor.addChild(root_0, string_literal127_tree)



                elif alt30 == 3:
                    # jal.g:96:45: IN 'out'
                    pass 
                    IN128=self.match(self.input, IN, self.FOLLOW_IN_in_proc_parm1031)
                    if self._state.backtracking == 0:

                        IN128_tree = self._adaptor.createWithPayload(IN128)
                        self._adaptor.addChild(root_0, IN128_tree)

                    string_literal129=self.match(self.input, 53, self.FOLLOW_53_in_proc_parm1033)
                    if self._state.backtracking == 0:

                        string_literal129_tree = self._adaptor.createWithPayload(string_literal129)
                        self._adaptor.addChild(root_0, string_literal129_tree)




                IDENTIFIER130=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_proc_parm1037)
                if self._state.backtracking == 0:

                    IDENTIFIER130_tree = self._adaptor.createWithPayload(IDENTIFIER130)
                    self._adaptor.addChild(root_0, IDENTIFIER130_tree)

                # jal.g:96:67: ( at_decl )?
                alt31 = 2
                LA31_0 = self.input.LA(1)

                if ((63 <= LA31_0 <= 64)) :
                    alt31 = 1
                if alt31 == 1:
                    # jal.g:0:0: at_decl
                    pass 
                    self._state.following.append(self.FOLLOW_at_decl_in_proc_parm1039)
                    at_decl131 = self.at_decl()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, at_decl131.tree)






                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "proc_parm"

    class pseudo_proc_def_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "pseudo_proc_def"
    # jal.g:99:1: pseudo_proc_def : 'procedure' IDENTIFIER '\\'' 'put' '(' ( proc_parm )? ( ',' proc_parm )* ')' 'is' ( statement )* 'end' 'procedure' ;
    def pseudo_proc_def(self, ):

        retval = self.pseudo_proc_def_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal132 = None
        IDENTIFIER133 = None
        char_literal134 = None
        string_literal135 = None
        char_literal136 = None
        char_literal138 = None
        char_literal140 = None
        string_literal141 = None
        string_literal143 = None
        string_literal144 = None
        proc_parm137 = None

        proc_parm139 = None

        statement142 = None


        string_literal132_tree = None
        IDENTIFIER133_tree = None
        char_literal134_tree = None
        string_literal135_tree = None
        char_literal136_tree = None
        char_literal138_tree = None
        char_literal140_tree = None
        string_literal141_tree = None
        string_literal143_tree = None
        string_literal144_tree = None

        try:
            try:
                # jal.g:99:17: ( 'procedure' IDENTIFIER '\\'' 'put' '(' ( proc_parm )? ( ',' proc_parm )* ')' 'is' ( statement )* 'end' 'procedure' )
                # jal.g:99:19: 'procedure' IDENTIFIER '\\'' 'put' '(' ( proc_parm )? ( ',' proc_parm )* ')' 'is' ( statement )* 'end' 'procedure'
                pass 
                root_0 = self._adaptor.nil()

                string_literal132=self.match(self.input, 47, self.FOLLOW_47_in_pseudo_proc_def1053)
                if self._state.backtracking == 0:

                    string_literal132_tree = self._adaptor.createWithPayload(string_literal132)
                    self._adaptor.addChild(root_0, string_literal132_tree)

                IDENTIFIER133=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_pseudo_proc_def1055)
                if self._state.backtracking == 0:

                    IDENTIFIER133_tree = self._adaptor.createWithPayload(IDENTIFIER133)
                    self._adaptor.addChild(root_0, IDENTIFIER133_tree)

                char_literal134=self.match(self.input, 54, self.FOLLOW_54_in_pseudo_proc_def1057)
                if self._state.backtracking == 0:

                    char_literal134_tree = self._adaptor.createWithPayload(char_literal134)
                    self._adaptor.addChild(root_0, char_literal134_tree)

                string_literal135=self.match(self.input, 55, self.FOLLOW_55_in_pseudo_proc_def1059)
                if self._state.backtracking == 0:

                    string_literal135_tree = self._adaptor.createWithPayload(string_literal135)
                    self._adaptor.addChild(root_0, string_literal135_tree)

                char_literal136=self.match(self.input, 48, self.FOLLOW_48_in_pseudo_proc_def1061)
                if self._state.backtracking == 0:

                    char_literal136_tree = self._adaptor.createWithPayload(char_literal136)
                    self._adaptor.addChild(root_0, char_literal136_tree)

                # jal.g:99:57: ( proc_parm )?
                alt32 = 2
                LA32_0 = self.input.LA(1)

                if (LA32_0 == 52 or (65 <= LA32_0 <= 71)) :
                    alt32 = 1
                if alt32 == 1:
                    # jal.g:0:0: proc_parm
                    pass 
                    self._state.following.append(self.FOLLOW_proc_parm_in_pseudo_proc_def1063)
                    proc_parm137 = self.proc_parm()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, proc_parm137.tree)



                # jal.g:99:68: ( ',' proc_parm )*
                while True: #loop33
                    alt33 = 2
                    LA33_0 = self.input.LA(1)

                    if (LA33_0 == 27) :
                        alt33 = 1


                    if alt33 == 1:
                        # jal.g:99:69: ',' proc_parm
                        pass 
                        char_literal138=self.match(self.input, 27, self.FOLLOW_27_in_pseudo_proc_def1067)
                        if self._state.backtracking == 0:

                            char_literal138_tree = self._adaptor.createWithPayload(char_literal138)
                            self._adaptor.addChild(root_0, char_literal138_tree)

                        self._state.following.append(self.FOLLOW_proc_parm_in_pseudo_proc_def1069)
                        proc_parm139 = self.proc_parm()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, proc_parm139.tree)


                    else:
                        break #loop33


                char_literal140=self.match(self.input, 49, self.FOLLOW_49_in_pseudo_proc_def1073)
                if self._state.backtracking == 0:

                    char_literal140_tree = self._adaptor.createWithPayload(char_literal140)
                    self._adaptor.addChild(root_0, char_literal140_tree)

                string_literal141=self.match(self.input, 50, self.FOLLOW_50_in_pseudo_proc_def1075)
                if self._state.backtracking == 0:

                    string_literal141_tree = self._adaptor.createWithPayload(string_literal141)
                    self._adaptor.addChild(root_0, string_literal141_tree)

                # jal.g:100:17: ( statement )*
                while True: #loop34
                    alt34 = 2
                    LA34_0 = self.input.LA(1)

                    if (LA34_0 == IDENTIFIER or (19 <= LA34_0 <= 24) or LA34_0 == 29 or (34 <= LA34_0 <= 36) or LA34_0 == 38 or LA34_0 == 42 or (46 <= LA34_0 <= 47) or LA34_0 == 51 or (57 <= LA34_0 <= 58) or LA34_0 == 61) :
                        alt34 = 1


                    if alt34 == 1:
                        # jal.g:0:0: statement
                        pass 
                        self._state.following.append(self.FOLLOW_statement_in_pseudo_proc_def1093)
                        statement142 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement142.tree)


                    else:
                        break #loop34


                string_literal143=self.match(self.input, 33, self.FOLLOW_33_in_pseudo_proc_def1108)
                if self._state.backtracking == 0:

                    string_literal143_tree = self._adaptor.createWithPayload(string_literal143)
                    self._adaptor.addChild(root_0, string_literal143_tree)

                string_literal144=self.match(self.input, 47, self.FOLLOW_47_in_pseudo_proc_def1110)
                if self._state.backtracking == 0:

                    string_literal144_tree = self._adaptor.createWithPayload(string_literal144)
                    self._adaptor.addChild(root_0, string_literal144_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "pseudo_proc_def"

    class pseudo_func_def_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "pseudo_func_def"
    # jal.g:104:1: pseudo_func_def : 'function' IDENTIFIER '\\'' 'get' '(' ( proc_parm )? ( ',' proc_parm )* ')' 'return' type 'is' ( statement )* 'end' 'function' ;
    def pseudo_func_def(self, ):

        retval = self.pseudo_func_def_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal145 = None
        IDENTIFIER146 = None
        char_literal147 = None
        string_literal148 = None
        char_literal149 = None
        char_literal151 = None
        char_literal153 = None
        string_literal154 = None
        string_literal156 = None
        string_literal158 = None
        string_literal159 = None
        proc_parm150 = None

        proc_parm152 = None

        type155 = None

        statement157 = None


        string_literal145_tree = None
        IDENTIFIER146_tree = None
        char_literal147_tree = None
        string_literal148_tree = None
        char_literal149_tree = None
        char_literal151_tree = None
        char_literal153_tree = None
        string_literal154_tree = None
        string_literal156_tree = None
        string_literal158_tree = None
        string_literal159_tree = None

        try:
            try:
                # jal.g:104:17: ( 'function' IDENTIFIER '\\'' 'get' '(' ( proc_parm )? ( ',' proc_parm )* ')' 'return' type 'is' ( statement )* 'end' 'function' )
                # jal.g:104:19: 'function' IDENTIFIER '\\'' 'get' '(' ( proc_parm )? ( ',' proc_parm )* ')' 'return' type 'is' ( statement )* 'end' 'function'
                pass 
                root_0 = self._adaptor.nil()

                string_literal145=self.match(self.input, 51, self.FOLLOW_51_in_pseudo_func_def1123)
                if self._state.backtracking == 0:

                    string_literal145_tree = self._adaptor.createWithPayload(string_literal145)
                    self._adaptor.addChild(root_0, string_literal145_tree)

                IDENTIFIER146=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_pseudo_func_def1125)
                if self._state.backtracking == 0:

                    IDENTIFIER146_tree = self._adaptor.createWithPayload(IDENTIFIER146)
                    self._adaptor.addChild(root_0, IDENTIFIER146_tree)

                char_literal147=self.match(self.input, 54, self.FOLLOW_54_in_pseudo_func_def1127)
                if self._state.backtracking == 0:

                    char_literal147_tree = self._adaptor.createWithPayload(char_literal147)
                    self._adaptor.addChild(root_0, char_literal147_tree)

                string_literal148=self.match(self.input, 56, self.FOLLOW_56_in_pseudo_func_def1129)
                if self._state.backtracking == 0:

                    string_literal148_tree = self._adaptor.createWithPayload(string_literal148)
                    self._adaptor.addChild(root_0, string_literal148_tree)

                char_literal149=self.match(self.input, 48, self.FOLLOW_48_in_pseudo_func_def1131)
                if self._state.backtracking == 0:

                    char_literal149_tree = self._adaptor.createWithPayload(char_literal149)
                    self._adaptor.addChild(root_0, char_literal149_tree)

                # jal.g:104:56: ( proc_parm )?
                alt35 = 2
                LA35_0 = self.input.LA(1)

                if (LA35_0 == 52 or (65 <= LA35_0 <= 71)) :
                    alt35 = 1
                if alt35 == 1:
                    # jal.g:0:0: proc_parm
                    pass 
                    self._state.following.append(self.FOLLOW_proc_parm_in_pseudo_func_def1133)
                    proc_parm150 = self.proc_parm()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, proc_parm150.tree)



                # jal.g:104:67: ( ',' proc_parm )*
                while True: #loop36
                    alt36 = 2
                    LA36_0 = self.input.LA(1)

                    if (LA36_0 == 27) :
                        alt36 = 1


                    if alt36 == 1:
                        # jal.g:104:68: ',' proc_parm
                        pass 
                        char_literal151=self.match(self.input, 27, self.FOLLOW_27_in_pseudo_func_def1137)
                        if self._state.backtracking == 0:

                            char_literal151_tree = self._adaptor.createWithPayload(char_literal151)
                            self._adaptor.addChild(root_0, char_literal151_tree)

                        self._state.following.append(self.FOLLOW_proc_parm_in_pseudo_func_def1139)
                        proc_parm152 = self.proc_parm()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, proc_parm152.tree)


                    else:
                        break #loop36


                char_literal153=self.match(self.input, 49, self.FOLLOW_49_in_pseudo_func_def1143)
                if self._state.backtracking == 0:

                    char_literal153_tree = self._adaptor.createWithPayload(char_literal153)
                    self._adaptor.addChild(root_0, char_literal153_tree)

                string_literal154=self.match(self.input, 19, self.FOLLOW_19_in_pseudo_func_def1145)
                if self._state.backtracking == 0:

                    string_literal154_tree = self._adaptor.createWithPayload(string_literal154)
                    self._adaptor.addChild(root_0, string_literal154_tree)

                self._state.following.append(self.FOLLOW_type_in_pseudo_func_def1147)
                type155 = self.type()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, type155.tree)
                string_literal156=self.match(self.input, 50, self.FOLLOW_50_in_pseudo_func_def1149)
                if self._state.backtracking == 0:

                    string_literal156_tree = self._adaptor.createWithPayload(string_literal156)
                    self._adaptor.addChild(root_0, string_literal156_tree)

                # jal.g:105:17: ( statement )*
                while True: #loop37
                    alt37 = 2
                    LA37_0 = self.input.LA(1)

                    if (LA37_0 == IDENTIFIER or (19 <= LA37_0 <= 24) or LA37_0 == 29 or (34 <= LA37_0 <= 36) or LA37_0 == 38 or LA37_0 == 42 or (46 <= LA37_0 <= 47) or LA37_0 == 51 or (57 <= LA37_0 <= 58) or LA37_0 == 61) :
                        alt37 = 1


                    if alt37 == 1:
                        # jal.g:0:0: statement
                        pass 
                        self._state.following.append(self.FOLLOW_statement_in_pseudo_func_def1167)
                        statement157 = self.statement()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, statement157.tree)


                    else:
                        break #loop37


                string_literal158=self.match(self.input, 33, self.FOLLOW_33_in_pseudo_func_def1182)
                if self._state.backtracking == 0:

                    string_literal158_tree = self._adaptor.createWithPayload(string_literal158)
                    self._adaptor.addChild(root_0, string_literal158_tree)

                string_literal159=self.match(self.input, 51, self.FOLLOW_51_in_pseudo_func_def1184)
                if self._state.backtracking == 0:

                    string_literal159_tree = self._adaptor.createWithPayload(string_literal159)
                    self._adaptor.addChild(root_0, string_literal159_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "pseudo_func_def"

    class alias_def_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "alias_def"
    # jal.g:111:1: alias_def : 'alias' IDENTIFIER 'is' IDENTIFIER ;
    def alias_def(self, ):

        retval = self.alias_def_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal160 = None
        IDENTIFIER161 = None
        string_literal162 = None
        IDENTIFIER163 = None

        string_literal160_tree = None
        IDENTIFIER161_tree = None
        string_literal162_tree = None
        IDENTIFIER163_tree = None

        try:
            try:
                # jal.g:111:11: ( 'alias' IDENTIFIER 'is' IDENTIFIER )
                # jal.g:111:13: 'alias' IDENTIFIER 'is' IDENTIFIER
                pass 
                root_0 = self._adaptor.nil()

                string_literal160=self.match(self.input, 57, self.FOLLOW_57_in_alias_def1206)
                if self._state.backtracking == 0:

                    string_literal160_tree = self._adaptor.createWithPayload(string_literal160)
                    self._adaptor.addChild(root_0, string_literal160_tree)

                IDENTIFIER161=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_alias_def1208)
                if self._state.backtracking == 0:

                    IDENTIFIER161_tree = self._adaptor.createWithPayload(IDENTIFIER161)
                    self._adaptor.addChild(root_0, IDENTIFIER161_tree)

                string_literal162=self.match(self.input, 50, self.FOLLOW_50_in_alias_def1210)
                if self._state.backtracking == 0:

                    string_literal162_tree = self._adaptor.createWithPayload(string_literal162)
                    self._adaptor.addChild(root_0, string_literal162_tree)

                IDENTIFIER163=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_alias_def1212)
                if self._state.backtracking == 0:

                    IDENTIFIER163_tree = self._adaptor.createWithPayload(IDENTIFIER163)
                    self._adaptor.addChild(root_0, IDENTIFIER163_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "alias_def"

    class const_def_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "const_def"
    # jal.g:114:1: const_def : 'const' ( vtype )* IDENTIFIER ( '[' ( cexpr )* ']' )* '=' ( cexpr | cexpr_list | IDENTIFIER | STRING_LITERAL ) ;
    def const_def(self, ):

        retval = self.const_def_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal164 = None
        IDENTIFIER166 = None
        char_literal167 = None
        char_literal169 = None
        char_literal170 = None
        IDENTIFIER173 = None
        STRING_LITERAL174 = None
        vtype165 = None

        cexpr168 = None

        cexpr171 = None

        cexpr_list172 = None


        string_literal164_tree = None
        IDENTIFIER166_tree = None
        char_literal167_tree = None
        char_literal169_tree = None
        char_literal170_tree = None
        IDENTIFIER173_tree = None
        STRING_LITERAL174_tree = None

        try:
            try:
                # jal.g:114:11: ( 'const' ( vtype )* IDENTIFIER ( '[' ( cexpr )* ']' )* '=' ( cexpr | cexpr_list | IDENTIFIER | STRING_LITERAL ) )
                # jal.g:114:13: 'const' ( vtype )* IDENTIFIER ( '[' ( cexpr )* ']' )* '=' ( cexpr | cexpr_list | IDENTIFIER | STRING_LITERAL )
                pass 
                root_0 = self._adaptor.nil()

                string_literal164=self.match(self.input, 58, self.FOLLOW_58_in_const_def1229)
                if self._state.backtracking == 0:

                    string_literal164_tree = self._adaptor.createWithPayload(string_literal164)
                    self._adaptor.addChild(root_0, string_literal164_tree)

                # jal.g:114:21: ( vtype )*
                while True: #loop38
                    alt38 = 2
                    LA38_0 = self.input.LA(1)

                    if ((65 <= LA38_0 <= 71)) :
                        alt38 = 1


                    if alt38 == 1:
                        # jal.g:0:0: vtype
                        pass 
                        self._state.following.append(self.FOLLOW_vtype_in_const_def1231)
                        vtype165 = self.vtype()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, vtype165.tree)


                    else:
                        break #loop38


                IDENTIFIER166=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_const_def1234)
                if self._state.backtracking == 0:

                    IDENTIFIER166_tree = self._adaptor.createWithPayload(IDENTIFIER166)
                    self._adaptor.addChild(root_0, IDENTIFIER166_tree)

                # jal.g:114:39: ( '[' ( cexpr )* ']' )*
                while True: #loop40
                    alt40 = 2
                    LA40_0 = self.input.LA(1)

                    if (LA40_0 == 59) :
                        alt40 = 1


                    if alt40 == 1:
                        # jal.g:114:41: '[' ( cexpr )* ']'
                        pass 
                        char_literal167=self.match(self.input, 59, self.FOLLOW_59_in_const_def1238)
                        if self._state.backtracking == 0:

                            char_literal167_tree = self._adaptor.createWithPayload(char_literal167)
                            self._adaptor.addChild(root_0, char_literal167_tree)

                        # jal.g:114:45: ( cexpr )*
                        while True: #loop39
                            alt39 = 2
                            LA39_0 = self.input.LA(1)

                            if ((BIN_LITERAL <= LA39_0 <= DECIMAL_LITERAL)) :
                                alt39 = 1


                            if alt39 == 1:
                                # jal.g:0:0: cexpr
                                pass 
                                self._state.following.append(self.FOLLOW_cexpr_in_const_def1240)
                                cexpr168 = self.cexpr()

                                self._state.following.pop()
                                if self._state.backtracking == 0:
                                    self._adaptor.addChild(root_0, cexpr168.tree)


                            else:
                                break #loop39


                        char_literal169=self.match(self.input, 60, self.FOLLOW_60_in_const_def1243)
                        if self._state.backtracking == 0:

                            char_literal169_tree = self._adaptor.createWithPayload(char_literal169)
                            self._adaptor.addChild(root_0, char_literal169_tree)



                    else:
                        break #loop40


                char_literal170=self.match(self.input, 25, self.FOLLOW_25_in_const_def1248)
                if self._state.backtracking == 0:

                    char_literal170_tree = self._adaptor.createWithPayload(char_literal170)
                    self._adaptor.addChild(root_0, char_literal170_tree)

                # jal.g:115:13: ( cexpr | cexpr_list | IDENTIFIER | STRING_LITERAL )
                alt41 = 4
                LA41 = self.input.LA(1)
                if LA41 == BIN_LITERAL or LA41 == HEX_LITERAL or LA41 == OCTAL_LITERAL or LA41 == DECIMAL_LITERAL:
                    alt41 = 1
                elif LA41 == 26:
                    alt41 = 2
                elif LA41 == IDENTIFIER:
                    alt41 = 3
                elif LA41 == STRING_LITERAL:
                    alt41 = 4
                else:
                    if self._state.backtracking > 0:
                        raise BacktrackingFailed

                    nvae = NoViableAltException("", 41, 0, self.input)

                    raise nvae

                if alt41 == 1:
                    # jal.g:115:15: cexpr
                    pass 
                    self._state.following.append(self.FOLLOW_cexpr_in_const_def1264)
                    cexpr171 = self.cexpr()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, cexpr171.tree)


                elif alt41 == 2:
                    # jal.g:115:23: cexpr_list
                    pass 
                    self._state.following.append(self.FOLLOW_cexpr_list_in_const_def1268)
                    cexpr_list172 = self.cexpr_list()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, cexpr_list172.tree)


                elif alt41 == 3:
                    # jal.g:115:36: IDENTIFIER
                    pass 
                    IDENTIFIER173=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_const_def1272)
                    if self._state.backtracking == 0:

                        IDENTIFIER173_tree = self._adaptor.createWithPayload(IDENTIFIER173)
                        self._adaptor.addChild(root_0, IDENTIFIER173_tree)



                elif alt41 == 4:
                    # jal.g:115:49: STRING_LITERAL
                    pass 
                    STRING_LITERAL174=self.match(self.input, STRING_LITERAL, self.FOLLOW_STRING_LITERAL_in_const_def1276)
                    if self._state.backtracking == 0:

                        STRING_LITERAL174_tree = self._adaptor.createWithPayload(STRING_LITERAL174)
                        self._adaptor.addChild(root_0, STRING_LITERAL174_tree)







                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "const_def"

    class var_def_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "var_def"
    # jal.g:118:1: var_def : var_decl1 var_decl2 ( ( var_multi )* | at_decl | is_decl | var_with_init ) ;
    def var_def(self, ):

        retval = self.var_def_return()
        retval.start = self.input.LT(1)

        root_0 = None

        var_decl1175 = None

        var_decl2176 = None

        var_multi177 = None

        at_decl178 = None

        is_decl179 = None

        var_with_init180 = None



        try:
            try:
                # jal.g:118:9: ( var_decl1 var_decl2 ( ( var_multi )* | at_decl | is_decl | var_with_init ) )
                # jal.g:118:11: var_decl1 var_decl2 ( ( var_multi )* | at_decl | is_decl | var_with_init )
                pass 
                root_0 = self._adaptor.nil()

                self._state.following.append(self.FOLLOW_var_decl1_in_var_def1295)
                var_decl1175 = self.var_decl1()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, var_decl1175.tree)
                self._state.following.append(self.FOLLOW_var_decl2_in_var_def1297)
                var_decl2176 = self.var_decl2()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, var_decl2176.tree)
                # jal.g:118:31: ( ( var_multi )* | at_decl | is_decl | var_with_init )
                alt43 = 4
                LA43 = self.input.LA(1)
                if LA43 == EOF or LA43 == IDENTIFIER or LA43 == BIN_LITERAL or LA43 == HEX_LITERAL or LA43 == OCTAL_LITERAL or LA43 == DECIMAL_LITERAL or LA43 == 19 or LA43 == 20 or LA43 == 21 or LA43 == 22 or LA43 == 23 or LA43 == 24 or LA43 == 27 or LA43 == 29 or LA43 == 32 or LA43 == 33 or LA43 == 34 or LA43 == 35 or LA43 == 36 or LA43 == 37 or LA43 == 38 or LA43 == 40 or LA43 == 41 or LA43 == 42 or LA43 == 45 or LA43 == 46 or LA43 == 47 or LA43 == 51 or LA43 == 57 or LA43 == 58 or LA43 == 61:
                    alt43 = 1
                elif LA43 == 63 or LA43 == 64:
                    alt43 = 2
                elif LA43 == 50:
                    alt43 = 3
                elif LA43 == 25:
                    alt43 = 4
                else:
                    if self._state.backtracking > 0:
                        raise BacktrackingFailed

                    nvae = NoViableAltException("", 43, 0, self.input)

                    raise nvae

                if alt43 == 1:
                    # jal.g:118:32: ( var_multi )*
                    pass 
                    # jal.g:118:32: ( var_multi )*
                    while True: #loop42
                        alt42 = 2
                        LA42_0 = self.input.LA(1)

                        if (LA42_0 == 27) :
                            alt42 = 1


                        if alt42 == 1:
                            # jal.g:0:0: var_multi
                            pass 
                            self._state.following.append(self.FOLLOW_var_multi_in_var_def1300)
                            var_multi177 = self.var_multi()

                            self._state.following.pop()
                            if self._state.backtracking == 0:
                                self._adaptor.addChild(root_0, var_multi177.tree)


                        else:
                            break #loop42




                elif alt43 == 2:
                    # jal.g:118:45: at_decl
                    pass 
                    self._state.following.append(self.FOLLOW_at_decl_in_var_def1305)
                    at_decl178 = self.at_decl()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, at_decl178.tree)


                elif alt43 == 3:
                    # jal.g:118:55: is_decl
                    pass 
                    self._state.following.append(self.FOLLOW_is_decl_in_var_def1309)
                    is_decl179 = self.is_decl()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, is_decl179.tree)


                elif alt43 == 4:
                    # jal.g:118:65: var_with_init
                    pass 
                    self._state.following.append(self.FOLLOW_var_with_init_in_var_def1313)
                    var_with_init180 = self.var_with_init()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, var_with_init180.tree)






                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "var_def"

    class var_multi_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "var_multi"
    # jal.g:121:1: var_multi : ',' var_decl2 ;
    def var_multi(self, ):

        retval = self.var_multi_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal181 = None
        var_decl2182 = None


        char_literal181_tree = None

        try:
            try:
                # jal.g:121:11: ( ',' var_decl2 )
                # jal.g:121:13: ',' var_decl2
                pass 
                root_0 = self._adaptor.nil()

                char_literal181=self.match(self.input, 27, self.FOLLOW_27_in_var_multi1331)
                if self._state.backtracking == 0:

                    char_literal181_tree = self._adaptor.createWithPayload(char_literal181)
                    self._adaptor.addChild(root_0, char_literal181_tree)

                self._state.following.append(self.FOLLOW_var_decl2_in_var_multi1333)
                var_decl2182 = self.var_decl2()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, var_decl2182.tree)



                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "var_multi"

    class var_with_init_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "var_with_init"
    # jal.g:124:1: var_with_init : '=' var_init ;
    def var_with_init(self, ):

        retval = self.var_with_init_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal183 = None
        var_init184 = None


        char_literal183_tree = None

        try:
            try:
                # jal.g:124:15: ( '=' var_init )
                # jal.g:124:17: '=' var_init
                pass 
                root_0 = self._adaptor.nil()

                char_literal183=self.match(self.input, 25, self.FOLLOW_25_in_var_with_init1350)
                if self._state.backtracking == 0:

                    char_literal183_tree = self._adaptor.createWithPayload(char_literal183)
                    self._adaptor.addChild(root_0, char_literal183_tree)

                self._state.following.append(self.FOLLOW_var_init_in_var_with_init1352)
                var_init184 = self.var_init()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, var_init184.tree)



                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "var_with_init"

    class var_decl1_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "var_decl1"
    # jal.g:127:1: var_decl1 : 'var' ( 'volatile' )* vtype ;
    def var_decl1(self, ):

        retval = self.var_decl1_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal185 = None
        string_literal186 = None
        vtype187 = None


        string_literal185_tree = None
        string_literal186_tree = None

        try:
            try:
                # jal.g:127:11: ( 'var' ( 'volatile' )* vtype )
                # jal.g:127:13: 'var' ( 'volatile' )* vtype
                pass 
                root_0 = self._adaptor.nil()

                string_literal185=self.match(self.input, 61, self.FOLLOW_61_in_var_decl11369)
                if self._state.backtracking == 0:

                    string_literal185_tree = self._adaptor.createWithPayload(string_literal185)
                    self._adaptor.addChild(root_0, string_literal185_tree)

                # jal.g:127:19: ( 'volatile' )*
                while True: #loop44
                    alt44 = 2
                    LA44_0 = self.input.LA(1)

                    if (LA44_0 == 52) :
                        alt44 = 1


                    if alt44 == 1:
                        # jal.g:0:0: 'volatile'
                        pass 
                        string_literal186=self.match(self.input, 52, self.FOLLOW_52_in_var_decl11371)
                        if self._state.backtracking == 0:

                            string_literal186_tree = self._adaptor.createWithPayload(string_literal186)
                            self._adaptor.addChild(root_0, string_literal186_tree)



                    else:
                        break #loop44


                self._state.following.append(self.FOLLOW_vtype_in_var_decl11374)
                vtype187 = self.vtype()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, vtype187.tree)



                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "var_decl1"

    class var_decl2_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "var_decl2"
    # jal.g:130:1: var_decl2 : IDENTIFIER ( '[' ( cexpr )* ']' )* ;
    def var_decl2(self, ):

        retval = self.var_decl2_return()
        retval.start = self.input.LT(1)

        root_0 = None

        IDENTIFIER188 = None
        char_literal189 = None
        char_literal191 = None
        cexpr190 = None


        IDENTIFIER188_tree = None
        char_literal189_tree = None
        char_literal191_tree = None

        try:
            try:
                # jal.g:130:11: ( IDENTIFIER ( '[' ( cexpr )* ']' )* )
                # jal.g:130:13: IDENTIFIER ( '[' ( cexpr )* ']' )*
                pass 
                root_0 = self._adaptor.nil()

                IDENTIFIER188=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_var_decl21391)
                if self._state.backtracking == 0:

                    IDENTIFIER188_tree = self._adaptor.createWithPayload(IDENTIFIER188)
                    self._adaptor.addChild(root_0, IDENTIFIER188_tree)

                # jal.g:130:24: ( '[' ( cexpr )* ']' )*
                while True: #loop46
                    alt46 = 2
                    LA46_0 = self.input.LA(1)

                    if (LA46_0 == 59) :
                        alt46 = 1


                    if alt46 == 1:
                        # jal.g:130:26: '[' ( cexpr )* ']'
                        pass 
                        char_literal189=self.match(self.input, 59, self.FOLLOW_59_in_var_decl21395)
                        if self._state.backtracking == 0:

                            char_literal189_tree = self._adaptor.createWithPayload(char_literal189)
                            self._adaptor.addChild(root_0, char_literal189_tree)

                        # jal.g:130:30: ( cexpr )*
                        while True: #loop45
                            alt45 = 2
                            LA45_0 = self.input.LA(1)

                            if ((BIN_LITERAL <= LA45_0 <= DECIMAL_LITERAL)) :
                                alt45 = 1


                            if alt45 == 1:
                                # jal.g:0:0: cexpr
                                pass 
                                self._state.following.append(self.FOLLOW_cexpr_in_var_decl21397)
                                cexpr190 = self.cexpr()

                                self._state.following.pop()
                                if self._state.backtracking == 0:
                                    self._adaptor.addChild(root_0, cexpr190.tree)


                            else:
                                break #loop45


                        char_literal191=self.match(self.input, 60, self.FOLLOW_60_in_var_decl21400)
                        if self._state.backtracking == 0:

                            char_literal191_tree = self._adaptor.createWithPayload(char_literal191)
                            self._adaptor.addChild(root_0, char_literal191_tree)



                    else:
                        break #loop46





                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "var_decl2"

    class vtype_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "vtype"
    # jal.g:133:1: vtype : type ( '*' constant )* ;
    def vtype(self, ):

        retval = self.vtype_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal193 = None
        type192 = None

        constant194 = None


        char_literal193_tree = None

        try:
            try:
                # jal.g:133:9: ( type ( '*' constant )* )
                # jal.g:133:13: type ( '*' constant )*
                pass 
                root_0 = self._adaptor.nil()

                self._state.following.append(self.FOLLOW_type_in_vtype1424)
                type192 = self.type()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, type192.tree)
                # jal.g:133:18: ( '*' constant )*
                while True: #loop47
                    alt47 = 2
                    LA47_0 = self.input.LA(1)

                    if (LA47_0 == 62) :
                        alt47 = 1


                    if alt47 == 1:
                        # jal.g:133:19: '*' constant
                        pass 
                        char_literal193=self.match(self.input, 62, self.FOLLOW_62_in_vtype1427)
                        if self._state.backtracking == 0:

                            char_literal193_tree = self._adaptor.createWithPayload(char_literal193)
                            self._adaptor.addChild(root_0, char_literal193_tree)

                        self._state.following.append(self.FOLLOW_constant_in_vtype1429)
                        constant194 = self.constant()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, constant194.tree)


                    else:
                        break #loop47





                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "vtype"

    class at_decl_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "at_decl"
    # jal.g:136:1: at_decl : ( 'shared' )* 'at' ( ( cexpr ( bitloc )* ) | ( IDENTIFIER ( bitloc )* ) | cexpr_list ) ;
    def at_decl(self, ):

        retval = self.at_decl_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal195 = None
        string_literal196 = None
        IDENTIFIER199 = None
        cexpr197 = None

        bitloc198 = None

        bitloc200 = None

        cexpr_list201 = None


        string_literal195_tree = None
        string_literal196_tree = None
        IDENTIFIER199_tree = None

        try:
            try:
                # jal.g:136:9: ( ( 'shared' )* 'at' ( ( cexpr ( bitloc )* ) | ( IDENTIFIER ( bitloc )* ) | cexpr_list ) )
                # jal.g:136:11: ( 'shared' )* 'at' ( ( cexpr ( bitloc )* ) | ( IDENTIFIER ( bitloc )* ) | cexpr_list )
                pass 
                root_0 = self._adaptor.nil()

                # jal.g:136:11: ( 'shared' )*
                while True: #loop48
                    alt48 = 2
                    LA48_0 = self.input.LA(1)

                    if (LA48_0 == 63) :
                        alt48 = 1


                    if alt48 == 1:
                        # jal.g:136:12: 'shared'
                        pass 
                        string_literal195=self.match(self.input, 63, self.FOLLOW_63_in_at_decl1449)
                        if self._state.backtracking == 0:

                            string_literal195_tree = self._adaptor.createWithPayload(string_literal195)
                            self._adaptor.addChild(root_0, string_literal195_tree)



                    else:
                        break #loop48


                string_literal196=self.match(self.input, 64, self.FOLLOW_64_in_at_decl1453)
                if self._state.backtracking == 0:

                    string_literal196_tree = self._adaptor.createWithPayload(string_literal196)
                    self._adaptor.addChild(root_0, string_literal196_tree)

                # jal.g:136:28: ( ( cexpr ( bitloc )* ) | ( IDENTIFIER ( bitloc )* ) | cexpr_list )
                alt51 = 3
                LA51 = self.input.LA(1)
                if LA51 == BIN_LITERAL or LA51 == HEX_LITERAL or LA51 == OCTAL_LITERAL or LA51 == DECIMAL_LITERAL:
                    alt51 = 1
                elif LA51 == IDENTIFIER:
                    alt51 = 2
                elif LA51 == 26:
                    alt51 = 3
                else:
                    if self._state.backtracking > 0:
                        raise BacktrackingFailed

                    nvae = NoViableAltException("", 51, 0, self.input)

                    raise nvae

                if alt51 == 1:
                    # jal.g:136:30: ( cexpr ( bitloc )* )
                    pass 
                    # jal.g:136:30: ( cexpr ( bitloc )* )
                    # jal.g:136:32: cexpr ( bitloc )*
                    pass 
                    self._state.following.append(self.FOLLOW_cexpr_in_at_decl1459)
                    cexpr197 = self.cexpr()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, cexpr197.tree)
                    # jal.g:136:38: ( bitloc )*
                    while True: #loop49
                        alt49 = 2
                        LA49_0 = self.input.LA(1)

                        if (LA49_0 == 44) :
                            alt49 = 1


                        if alt49 == 1:
                            # jal.g:0:0: bitloc
                            pass 
                            self._state.following.append(self.FOLLOW_bitloc_in_at_decl1461)
                            bitloc198 = self.bitloc()

                            self._state.following.pop()
                            if self._state.backtracking == 0:
                                self._adaptor.addChild(root_0, bitloc198.tree)


                        else:
                            break #loop49







                elif alt51 == 2:
                    # jal.g:136:50: ( IDENTIFIER ( bitloc )* )
                    pass 
                    # jal.g:136:50: ( IDENTIFIER ( bitloc )* )
                    # jal.g:136:53: IDENTIFIER ( bitloc )*
                    pass 
                    IDENTIFIER199=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_at_decl1471)
                    if self._state.backtracking == 0:

                        IDENTIFIER199_tree = self._adaptor.createWithPayload(IDENTIFIER199)
                        self._adaptor.addChild(root_0, IDENTIFIER199_tree)

                    # jal.g:136:64: ( bitloc )*
                    while True: #loop50
                        alt50 = 2
                        LA50_0 = self.input.LA(1)

                        if (LA50_0 == 44) :
                            alt50 = 1


                        if alt50 == 1:
                            # jal.g:0:0: bitloc
                            pass 
                            self._state.following.append(self.FOLLOW_bitloc_in_at_decl1473)
                            bitloc200 = self.bitloc()

                            self._state.following.pop()
                            if self._state.backtracking == 0:
                                self._adaptor.addChild(root_0, bitloc200.tree)


                        else:
                            break #loop50







                elif alt51 == 3:
                    # jal.g:136:76: cexpr_list
                    pass 
                    self._state.following.append(self.FOLLOW_cexpr_list_in_at_decl1480)
                    cexpr_list201 = self.cexpr_list()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, cexpr_list201.tree)






                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "at_decl"

    class is_decl_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "is_decl"
    # jal.g:139:1: is_decl : 'is' IDENTIFIER ;
    def is_decl(self, ):

        retval = self.is_decl_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal202 = None
        IDENTIFIER203 = None

        string_literal202_tree = None
        IDENTIFIER203_tree = None

        try:
            try:
                # jal.g:139:9: ( 'is' IDENTIFIER )
                # jal.g:139:11: 'is' IDENTIFIER
                pass 
                root_0 = self._adaptor.nil()

                string_literal202=self.match(self.input, 50, self.FOLLOW_50_in_is_decl1499)
                if self._state.backtracking == 0:

                    string_literal202_tree = self._adaptor.createWithPayload(string_literal202)
                    self._adaptor.addChild(root_0, string_literal202_tree)

                IDENTIFIER203=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_is_decl1501)
                if self._state.backtracking == 0:

                    IDENTIFIER203_tree = self._adaptor.createWithPayload(IDENTIFIER203)
                    self._adaptor.addChild(root_0, IDENTIFIER203_tree)




                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "is_decl"

    class bitloc_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "bitloc"
    # jal.g:142:1: bitloc : ':' constant ;
    def bitloc(self, ):

        retval = self.bitloc_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal204 = None
        constant205 = None


        char_literal204_tree = None

        try:
            try:
                # jal.g:142:9: ( ':' constant )
                # jal.g:142:11: ':' constant
                pass 
                root_0 = self._adaptor.nil()

                char_literal204=self.match(self.input, 44, self.FOLLOW_44_in_bitloc1519)
                if self._state.backtracking == 0:

                    char_literal204_tree = self._adaptor.createWithPayload(char_literal204)
                    self._adaptor.addChild(root_0, char_literal204_tree)

                self._state.following.append(self.FOLLOW_constant_in_bitloc1521)
                constant205 = self.constant()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, constant205.tree)



                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "bitloc"

    class proc_func_call_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "proc_func_call"
    # jal.g:147:1: proc_func_call : IDENTIFIER ( '(' ( IDENTIFIER )* ')' )? ;
    def proc_func_call(self, ):

        retval = self.proc_func_call_return()
        retval.start = self.input.LT(1)

        root_0 = None

        IDENTIFIER206 = None
        char_literal207 = None
        IDENTIFIER208 = None
        char_literal209 = None

        IDENTIFIER206_tree = None
        char_literal207_tree = None
        IDENTIFIER208_tree = None
        char_literal209_tree = None

        try:
            try:
                # jal.g:147:18: ( IDENTIFIER ( '(' ( IDENTIFIER )* ')' )? )
                # jal.g:147:20: IDENTIFIER ( '(' ( IDENTIFIER )* ')' )?
                pass 
                root_0 = self._adaptor.nil()

                IDENTIFIER206=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_proc_func_call1542)
                if self._state.backtracking == 0:

                    IDENTIFIER206_tree = self._adaptor.createWithPayload(IDENTIFIER206)
                    self._adaptor.addChild(root_0, IDENTIFIER206_tree)

                # jal.g:147:31: ( '(' ( IDENTIFIER )* ')' )?
                alt53 = 2
                LA53_0 = self.input.LA(1)

                if (LA53_0 == 48) :
                    alt53 = 1
                if alt53 == 1:
                    # jal.g:147:32: '(' ( IDENTIFIER )* ')'
                    pass 
                    char_literal207=self.match(self.input, 48, self.FOLLOW_48_in_proc_func_call1545)
                    if self._state.backtracking == 0:

                        char_literal207_tree = self._adaptor.createWithPayload(char_literal207)
                        self._adaptor.addChild(root_0, char_literal207_tree)

                    # jal.g:147:36: ( IDENTIFIER )*
                    while True: #loop52
                        alt52 = 2
                        LA52_0 = self.input.LA(1)

                        if (LA52_0 == IDENTIFIER) :
                            alt52 = 1


                        if alt52 == 1:
                            # jal.g:0:0: IDENTIFIER
                            pass 
                            IDENTIFIER208=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_proc_func_call1547)
                            if self._state.backtracking == 0:

                                IDENTIFIER208_tree = self._adaptor.createWithPayload(IDENTIFIER208)
                                self._adaptor.addChild(root_0, IDENTIFIER208_tree)



                        else:
                            break #loop52


                    char_literal209=self.match(self.input, 49, self.FOLLOW_49_in_proc_func_call1550)
                    if self._state.backtracking == 0:

                        char_literal209_tree = self._adaptor.createWithPayload(char_literal209)
                        self._adaptor.addChild(root_0, char_literal209_tree)







                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "proc_func_call"

    class var_init_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "var_init"
    # jal.g:150:1: var_init : ( proc_func_call | cexpr | cexpr_list | STRING_LITERAL | CHARACTER_LITERAL | IDENTIFIER );
    def var_init(self, ):

        retval = self.var_init_return()
        retval.start = self.input.LT(1)

        root_0 = None

        STRING_LITERAL213 = None
        CHARACTER_LITERAL214 = None
        IDENTIFIER215 = None
        proc_func_call210 = None

        cexpr211 = None

        cexpr_list212 = None


        STRING_LITERAL213_tree = None
        CHARACTER_LITERAL214_tree = None
        IDENTIFIER215_tree = None

        try:
            try:
                # jal.g:150:10: ( proc_func_call | cexpr | cexpr_list | STRING_LITERAL | CHARACTER_LITERAL | IDENTIFIER )
                alt54 = 6
                LA54 = self.input.LA(1)
                if LA54 == IDENTIFIER:
                    LA54_1 = self.input.LA(2)

                    if (self.synpred80_jal()) :
                        alt54 = 1
                    elif (True) :
                        alt54 = 6
                    else:
                        if self._state.backtracking > 0:
                            raise BacktrackingFailed

                        nvae = NoViableAltException("", 54, 1, self.input)

                        raise nvae

                elif LA54 == BIN_LITERAL or LA54 == HEX_LITERAL or LA54 == OCTAL_LITERAL or LA54 == DECIMAL_LITERAL:
                    alt54 = 2
                elif LA54 == 26:
                    alt54 = 3
                elif LA54 == STRING_LITERAL:
                    alt54 = 4
                elif LA54 == CHARACTER_LITERAL:
                    alt54 = 5
                else:
                    if self._state.backtracking > 0:
                        raise BacktrackingFailed

                    nvae = NoViableAltException("", 54, 0, self.input)

                    raise nvae

                if alt54 == 1:
                    # jal.g:150:12: proc_func_call
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_proc_func_call_in_var_init1569)
                    proc_func_call210 = self.proc_func_call()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, proc_func_call210.tree)


                elif alt54 == 2:
                    # jal.g:150:29: cexpr
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_cexpr_in_var_init1573)
                    cexpr211 = self.cexpr()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, cexpr211.tree)


                elif alt54 == 3:
                    # jal.g:150:37: cexpr_list
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_cexpr_list_in_var_init1577)
                    cexpr_list212 = self.cexpr_list()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, cexpr_list212.tree)


                elif alt54 == 4:
                    # jal.g:150:50: STRING_LITERAL
                    pass 
                    root_0 = self._adaptor.nil()

                    STRING_LITERAL213=self.match(self.input, STRING_LITERAL, self.FOLLOW_STRING_LITERAL_in_var_init1581)
                    if self._state.backtracking == 0:

                        STRING_LITERAL213_tree = self._adaptor.createWithPayload(STRING_LITERAL213)
                        self._adaptor.addChild(root_0, STRING_LITERAL213_tree)



                elif alt54 == 5:
                    # jal.g:150:67: CHARACTER_LITERAL
                    pass 
                    root_0 = self._adaptor.nil()

                    CHARACTER_LITERAL214=self.match(self.input, CHARACTER_LITERAL, self.FOLLOW_CHARACTER_LITERAL_in_var_init1585)
                    if self._state.backtracking == 0:

                        CHARACTER_LITERAL214_tree = self._adaptor.createWithPayload(CHARACTER_LITERAL214)
                        self._adaptor.addChild(root_0, CHARACTER_LITERAL214_tree)



                elif alt54 == 6:
                    # jal.g:150:87: IDENTIFIER
                    pass 
                    root_0 = self._adaptor.nil()

                    IDENTIFIER215=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_var_init1589)
                    if self._state.backtracking == 0:

                        IDENTIFIER215_tree = self._adaptor.createWithPayload(IDENTIFIER215)
                        self._adaptor.addChild(root_0, IDENTIFIER215_tree)



                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "var_init"

    class type_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "type"
    # jal.g:153:1: type : ( 'bit' | 'byte' | 'word' | 'dword' | 'sbyte' | 'sword' | 'sdword' );
    def type(self, ):

        retval = self.type_return()
        retval.start = self.input.LT(1)

        root_0 = None

        set216 = None

        set216_tree = None

        try:
            try:
                # jal.g:153:9: ( 'bit' | 'byte' | 'word' | 'dword' | 'sbyte' | 'sword' | 'sdword' )
                # jal.g:
                pass 
                root_0 = self._adaptor.nil()

                set216 = self.input.LT(1)
                if (65 <= self.input.LA(1) <= 71):
                    self.input.consume()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, self._adaptor.createWithPayload(set216))
                    self._state.errorRecovery = False

                else:
                    if self._state.backtracking > 0:
                        raise BacktrackingFailed

                    mse = MismatchedSetException(None, self.input)
                    raise mse





                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "type"

    class expr_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "expr"
    # jal.g:181:1: expr : xor_expr ( '|' xor_expr )* ;
    def expr(self, ):

        retval = self.expr_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal218 = None
        xor_expr217 = None

        xor_expr219 = None


        char_literal218_tree = None

        try:
            try:
                # jal.g:181:6: ( xor_expr ( '|' xor_expr )* )
                # jal.g:181:9: xor_expr ( '|' xor_expr )*
                pass 
                root_0 = self._adaptor.nil()

                self._state.following.append(self.FOLLOW_xor_expr_in_expr1723)
                xor_expr217 = self.xor_expr()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, xor_expr217.tree)
                # jal.g:181:18: ( '|' xor_expr )*
                while True: #loop55
                    alt55 = 2
                    LA55_0 = self.input.LA(1)

                    if (LA55_0 == 72) :
                        alt55 = 1


                    if alt55 == 1:
                        # jal.g:181:19: '|' xor_expr
                        pass 
                        char_literal218=self.match(self.input, 72, self.FOLLOW_72_in_expr1726)
                        if self._state.backtracking == 0:

                            char_literal218_tree = self._adaptor.createWithPayload(char_literal218)
                            self._adaptor.addChild(root_0, char_literal218_tree)

                        self._state.following.append(self.FOLLOW_xor_expr_in_expr1728)
                        xor_expr219 = self.xor_expr()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, xor_expr219.tree)


                    else:
                        break #loop55





                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "expr"

    class xor_expr_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "xor_expr"
    # jal.g:184:1: xor_expr : ( and_expr ( '^' and_expr )* | '(' xor_expr ')' );
    def xor_expr(self, ):

        retval = self.xor_expr_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal221 = None
        char_literal223 = None
        char_literal225 = None
        and_expr220 = None

        and_expr222 = None

        xor_expr224 = None


        char_literal221_tree = None
        char_literal223_tree = None
        char_literal225_tree = None

        try:
            try:
                # jal.g:184:10: ( and_expr ( '^' and_expr )* | '(' xor_expr ')' )
                alt57 = 2
                alt57 = self.dfa57.predict(self.input)
                if alt57 == 1:
                    # jal.g:184:12: and_expr ( '^' and_expr )*
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_and_expr_in_xor_expr1744)
                    and_expr220 = self.and_expr()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, and_expr220.tree)
                    # jal.g:184:21: ( '^' and_expr )*
                    while True: #loop56
                        alt56 = 2
                        LA56_0 = self.input.LA(1)

                        if (LA56_0 == 73) :
                            alt56 = 1


                        if alt56 == 1:
                            # jal.g:184:22: '^' and_expr
                            pass 
                            char_literal221=self.match(self.input, 73, self.FOLLOW_73_in_xor_expr1747)
                            if self._state.backtracking == 0:

                                char_literal221_tree = self._adaptor.createWithPayload(char_literal221)
                                self._adaptor.addChild(root_0, char_literal221_tree)

                            self._state.following.append(self.FOLLOW_and_expr_in_xor_expr1749)
                            and_expr222 = self.and_expr()

                            self._state.following.pop()
                            if self._state.backtracking == 0:
                                self._adaptor.addChild(root_0, and_expr222.tree)


                        else:
                            break #loop56




                elif alt57 == 2:
                    # jal.g:185:5: '(' xor_expr ')'
                    pass 
                    root_0 = self._adaptor.nil()

                    char_literal223=self.match(self.input, 48, self.FOLLOW_48_in_xor_expr1757)
                    if self._state.backtracking == 0:

                        char_literal223_tree = self._adaptor.createWithPayload(char_literal223)
                        self._adaptor.addChild(root_0, char_literal223_tree)

                    self._state.following.append(self.FOLLOW_xor_expr_in_xor_expr1759)
                    xor_expr224 = self.xor_expr()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, xor_expr224.tree)
                    char_literal225=self.match(self.input, 49, self.FOLLOW_49_in_xor_expr1761)
                    if self._state.backtracking == 0:

                        char_literal225_tree = self._adaptor.createWithPayload(char_literal225)
                        self._adaptor.addChild(root_0, char_literal225_tree)



                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "xor_expr"

    class and_expr_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "and_expr"
    # jal.g:188:1: and_expr : ( shift_expr ( '&' shift_expr )* | '(' and_expr ')' );
    def and_expr(self, ):

        retval = self.and_expr_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal227 = None
        char_literal229 = None
        char_literal231 = None
        shift_expr226 = None

        shift_expr228 = None

        and_expr230 = None


        char_literal227_tree = None
        char_literal229_tree = None
        char_literal231_tree = None

        try:
            try:
                # jal.g:188:10: ( shift_expr ( '&' shift_expr )* | '(' and_expr ')' )
                alt59 = 2
                LA59_0 = self.input.LA(1)

                if ((IDENTIFIER <= LA59_0 <= STRING_LITERAL) or LA59_0 == CHARACTER_LITERAL or (BIN_LITERAL <= LA59_0 <= DECIMAL_LITERAL) or (77 <= LA59_0 <= 78) or LA59_0 == 81) :
                    alt59 = 1
                elif (LA59_0 == 48) :
                    alt59 = 2
                else:
                    if self._state.backtracking > 0:
                        raise BacktrackingFailed

                    nvae = NoViableAltException("", 59, 0, self.input)

                    raise nvae

                if alt59 == 1:
                    # jal.g:188:12: shift_expr ( '&' shift_expr )*
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_shift_expr_in_and_expr1780)
                    shift_expr226 = self.shift_expr()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, shift_expr226.tree)
                    # jal.g:188:23: ( '&' shift_expr )*
                    while True: #loop58
                        alt58 = 2
                        LA58_0 = self.input.LA(1)

                        if (LA58_0 == 74) :
                            alt58 = 1


                        if alt58 == 1:
                            # jal.g:188:24: '&' shift_expr
                            pass 
                            char_literal227=self.match(self.input, 74, self.FOLLOW_74_in_and_expr1783)
                            if self._state.backtracking == 0:

                                char_literal227_tree = self._adaptor.createWithPayload(char_literal227)
                                self._adaptor.addChild(root_0, char_literal227_tree)

                            self._state.following.append(self.FOLLOW_shift_expr_in_and_expr1785)
                            shift_expr228 = self.shift_expr()

                            self._state.following.pop()
                            if self._state.backtracking == 0:
                                self._adaptor.addChild(root_0, shift_expr228.tree)


                        else:
                            break #loop58




                elif alt59 == 2:
                    # jal.g:189:5: '(' and_expr ')'
                    pass 
                    root_0 = self._adaptor.nil()

                    char_literal229=self.match(self.input, 48, self.FOLLOW_48_in_and_expr1794)
                    if self._state.backtracking == 0:

                        char_literal229_tree = self._adaptor.createWithPayload(char_literal229)
                        self._adaptor.addChild(root_0, char_literal229_tree)

                    self._state.following.append(self.FOLLOW_and_expr_in_and_expr1796)
                    and_expr230 = self.and_expr()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, and_expr230.tree)
                    char_literal231=self.match(self.input, 49, self.FOLLOW_49_in_and_expr1798)
                    if self._state.backtracking == 0:

                        char_literal231_tree = self._adaptor.createWithPayload(char_literal231)
                        self._adaptor.addChild(root_0, char_literal231_tree)



                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "and_expr"

    class shift_expr_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "shift_expr"
    # jal.g:192:1: shift_expr : arith_expr ( ( '<<' | '>>' ) arith_expr )* ;
    def shift_expr(self, ):

        retval = self.shift_expr_return()
        retval.start = self.input.LT(1)

        root_0 = None

        set233 = None
        arith_expr232 = None

        arith_expr234 = None


        set233_tree = None

        try:
            try:
                # jal.g:192:12: ( arith_expr ( ( '<<' | '>>' ) arith_expr )* )
                # jal.g:192:14: arith_expr ( ( '<<' | '>>' ) arith_expr )*
                pass 
                root_0 = self._adaptor.nil()

                self._state.following.append(self.FOLLOW_arith_expr_in_shift_expr1817)
                arith_expr232 = self.arith_expr()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, arith_expr232.tree)
                # jal.g:192:25: ( ( '<<' | '>>' ) arith_expr )*
                while True: #loop60
                    alt60 = 2
                    LA60_0 = self.input.LA(1)

                    if ((75 <= LA60_0 <= 76)) :
                        alt60 = 1


                    if alt60 == 1:
                        # jal.g:192:26: ( '<<' | '>>' ) arith_expr
                        pass 
                        set233 = self.input.LT(1)
                        if (75 <= self.input.LA(1) <= 76):
                            self.input.consume()
                            if self._state.backtracking == 0:
                                self._adaptor.addChild(root_0, self._adaptor.createWithPayload(set233))
                            self._state.errorRecovery = False

                        else:
                            if self._state.backtracking > 0:
                                raise BacktrackingFailed

                            mse = MismatchedSetException(None, self.input)
                            raise mse


                        self._state.following.append(self.FOLLOW_arith_expr_in_shift_expr1826)
                        arith_expr234 = self.arith_expr()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, arith_expr234.tree)


                    else:
                        break #loop60





                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "shift_expr"

    class arith_expr_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "arith_expr"
    # jal.g:195:1: arith_expr : term ( ( '+' | '-' ) term )* ;
    def arith_expr(self, ):

        retval = self.arith_expr_return()
        retval.start = self.input.LT(1)

        root_0 = None

        set236 = None
        term235 = None

        term237 = None


        set236_tree = None

        try:
            try:
                # jal.g:195:11: ( term ( ( '+' | '-' ) term )* )
                # jal.g:195:13: term ( ( '+' | '-' ) term )*
                pass 
                root_0 = self._adaptor.nil()

                self._state.following.append(self.FOLLOW_term_in_arith_expr1847)
                term235 = self.term()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, term235.tree)
                # jal.g:195:18: ( ( '+' | '-' ) term )*
                while True: #loop61
                    alt61 = 2
                    LA61_0 = self.input.LA(1)

                    if ((77 <= LA61_0 <= 78)) :
                        alt61 = 1


                    if alt61 == 1:
                        # jal.g:195:19: ( '+' | '-' ) term
                        pass 
                        set236 = self.input.LT(1)
                        if (77 <= self.input.LA(1) <= 78):
                            self.input.consume()
                            if self._state.backtracking == 0:
                                self._adaptor.addChild(root_0, self._adaptor.createWithPayload(set236))
                            self._state.errorRecovery = False

                        else:
                            if self._state.backtracking > 0:
                                raise BacktrackingFailed

                            mse = MismatchedSetException(None, self.input)
                            raise mse


                        self._state.following.append(self.FOLLOW_term_in_arith_expr1856)
                        term237 = self.term()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, term237.tree)


                    else:
                        break #loop61





                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "arith_expr"

    class term_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "term"
    # jal.g:198:1: term : factor ( ( '*' | '/' | '%' ) factor )* ;
    def term(self, ):

        retval = self.term_return()
        retval.start = self.input.LT(1)

        root_0 = None

        set239 = None
        factor238 = None

        factor240 = None


        set239_tree = None

        try:
            try:
                # jal.g:198:6: ( factor ( ( '*' | '/' | '%' ) factor )* )
                # jal.g:198:8: factor ( ( '*' | '/' | '%' ) factor )*
                pass 
                root_0 = self._adaptor.nil()

                self._state.following.append(self.FOLLOW_factor_in_term1877)
                factor238 = self.factor()

                self._state.following.pop()
                if self._state.backtracking == 0:
                    self._adaptor.addChild(root_0, factor238.tree)
                # jal.g:198:15: ( ( '*' | '/' | '%' ) factor )*
                while True: #loop62
                    alt62 = 2
                    LA62_0 = self.input.LA(1)

                    if (LA62_0 == 62 or (79 <= LA62_0 <= 80)) :
                        alt62 = 1


                    if alt62 == 1:
                        # jal.g:198:16: ( '*' | '/' | '%' ) factor
                        pass 
                        set239 = self.input.LT(1)
                        if self.input.LA(1) == 62 or (79 <= self.input.LA(1) <= 80):
                            self.input.consume()
                            if self._state.backtracking == 0:
                                self._adaptor.addChild(root_0, self._adaptor.createWithPayload(set239))
                            self._state.errorRecovery = False

                        else:
                            if self._state.backtracking > 0:
                                raise BacktrackingFailed

                            mse = MismatchedSetException(None, self.input)
                            raise mse


                        self._state.following.append(self.FOLLOW_factor_in_term1893)
                        factor240 = self.factor()

                        self._state.following.pop()
                        if self._state.backtracking == 0:
                            self._adaptor.addChild(root_0, factor240.tree)


                    else:
                        break #loop62





                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "term"

    class factor_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "factor"
    # jal.g:201:1: factor : ( '+' factor | '-' factor | '~' factor | atom );
    def factor(self, ):

        retval = self.factor_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal241 = None
        char_literal243 = None
        char_literal245 = None
        factor242 = None

        factor244 = None

        factor246 = None

        atom247 = None


        char_literal241_tree = None
        char_literal243_tree = None
        char_literal245_tree = None

        try:
            try:
                # jal.g:201:8: ( '+' factor | '-' factor | '~' factor | atom )
                alt63 = 4
                LA63 = self.input.LA(1)
                if LA63 == 77:
                    alt63 = 1
                elif LA63 == 78:
                    alt63 = 2
                elif LA63 == 81:
                    alt63 = 3
                elif LA63 == IDENTIFIER or LA63 == STRING_LITERAL or LA63 == CHARACTER_LITERAL or LA63 == BIN_LITERAL or LA63 == HEX_LITERAL or LA63 == OCTAL_LITERAL or LA63 == DECIMAL_LITERAL:
                    alt63 = 4
                else:
                    if self._state.backtracking > 0:
                        raise BacktrackingFailed

                    nvae = NoViableAltException("", 63, 0, self.input)

                    raise nvae

                if alt63 == 1:
                    # jal.g:201:10: '+' factor
                    pass 
                    root_0 = self._adaptor.nil()

                    char_literal241=self.match(self.input, 77, self.FOLLOW_77_in_factor1909)
                    if self._state.backtracking == 0:

                        char_literal241_tree = self._adaptor.createWithPayload(char_literal241)
                        self._adaptor.addChild(root_0, char_literal241_tree)

                    self._state.following.append(self.FOLLOW_factor_in_factor1911)
                    factor242 = self.factor()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, factor242.tree)


                elif alt63 == 2:
                    # jal.g:202:10: '-' factor
                    pass 
                    root_0 = self._adaptor.nil()

                    char_literal243=self.match(self.input, 78, self.FOLLOW_78_in_factor1922)
                    if self._state.backtracking == 0:

                        char_literal243_tree = self._adaptor.createWithPayload(char_literal243)
                        self._adaptor.addChild(root_0, char_literal243_tree)

                    self._state.following.append(self.FOLLOW_factor_in_factor1924)
                    factor244 = self.factor()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, factor244.tree)


                elif alt63 == 3:
                    # jal.g:203:10: '~' factor
                    pass 
                    root_0 = self._adaptor.nil()

                    char_literal245=self.match(self.input, 81, self.FOLLOW_81_in_factor1935)
                    if self._state.backtracking == 0:

                        char_literal245_tree = self._adaptor.createWithPayload(char_literal245)
                        self._adaptor.addChild(root_0, char_literal245_tree)

                    self._state.following.append(self.FOLLOW_factor_in_factor1937)
                    factor246 = self.factor()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, factor246.tree)


                elif alt63 == 4:
                    # jal.g:204:10: atom
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_atom_in_factor1948)
                    atom247 = self.atom()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, atom247.tree)


                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "factor"

    class atom_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "atom"
    # jal.g:207:1: atom : ( CHARACTER_LITERAL | STRING_LITERAL | constant | IDENTIFIER );
    def atom(self, ):

        retval = self.atom_return()
        retval.start = self.input.LT(1)

        root_0 = None

        CHARACTER_LITERAL248 = None
        STRING_LITERAL249 = None
        IDENTIFIER251 = None
        constant250 = None


        CHARACTER_LITERAL248_tree = None
        STRING_LITERAL249_tree = None
        IDENTIFIER251_tree = None

        try:
            try:
                # jal.g:207:6: ( CHARACTER_LITERAL | STRING_LITERAL | constant | IDENTIFIER )
                alt64 = 4
                LA64 = self.input.LA(1)
                if LA64 == CHARACTER_LITERAL:
                    alt64 = 1
                elif LA64 == STRING_LITERAL:
                    alt64 = 2
                elif LA64 == BIN_LITERAL or LA64 == HEX_LITERAL or LA64 == OCTAL_LITERAL or LA64 == DECIMAL_LITERAL:
                    alt64 = 3
                elif LA64 == IDENTIFIER:
                    alt64 = 4
                else:
                    if self._state.backtracking > 0:
                        raise BacktrackingFailed

                    nvae = NoViableAltException("", 64, 0, self.input)

                    raise nvae

                if alt64 == 1:
                    # jal.g:207:14: CHARACTER_LITERAL
                    pass 
                    root_0 = self._adaptor.nil()

                    CHARACTER_LITERAL248=self.match(self.input, CHARACTER_LITERAL, self.FOLLOW_CHARACTER_LITERAL_in_atom1970)
                    if self._state.backtracking == 0:

                        CHARACTER_LITERAL248_tree = self._adaptor.createWithPayload(CHARACTER_LITERAL248)
                        self._adaptor.addChild(root_0, CHARACTER_LITERAL248_tree)



                elif alt64 == 2:
                    # jal.g:208:17: STRING_LITERAL
                    pass 
                    root_0 = self._adaptor.nil()

                    STRING_LITERAL249=self.match(self.input, STRING_LITERAL, self.FOLLOW_STRING_LITERAL_in_atom1988)
                    if self._state.backtracking == 0:

                        STRING_LITERAL249_tree = self._adaptor.createWithPayload(STRING_LITERAL249)
                        self._adaptor.addChild(root_0, STRING_LITERAL249_tree)



                elif alt64 == 3:
                    # jal.g:209:17: constant
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_constant_in_atom2006)
                    constant250 = self.constant()

                    self._state.following.pop()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, constant250.tree)


                elif alt64 == 4:
                    # jal.g:210:4: IDENTIFIER
                    pass 
                    root_0 = self._adaptor.nil()

                    IDENTIFIER251=self.match(self.input, IDENTIFIER, self.FOLLOW_IDENTIFIER_in_atom2011)
                    if self._state.backtracking == 0:

                        IDENTIFIER251_tree = self._adaptor.createWithPayload(IDENTIFIER251)
                        self._adaptor.addChild(root_0, IDENTIFIER251_tree)



                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "atom"

    class constant_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "constant"
    # jal.g:218:1: constant : ( BIN_LITERAL | HEX_LITERAL | OCTAL_LITERAL | DECIMAL_LITERAL );
    def constant(self, ):

        retval = self.constant_return()
        retval.start = self.input.LT(1)

        root_0 = None

        set252 = None

        set252_tree = None

        try:
            try:
                # jal.g:218:10: ( BIN_LITERAL | HEX_LITERAL | OCTAL_LITERAL | DECIMAL_LITERAL )
                # jal.g:
                pass 
                root_0 = self._adaptor.nil()

                set252 = self.input.LT(1)
                if (BIN_LITERAL <= self.input.LA(1) <= DECIMAL_LITERAL):
                    self.input.consume()
                    if self._state.backtracking == 0:
                        self._adaptor.addChild(root_0, self._adaptor.createWithPayload(set252))
                    self._state.errorRecovery = False

                else:
                    if self._state.backtracking > 0:
                        raise BacktrackingFailed

                    mse = MismatchedSetException(None, self.input)
                    raise mse





                retval.stop = self.input.LT(-1)

                if self._state.backtracking == 0:

                    retval.tree = self._adaptor.rulePostProcessing(root_0)
                    self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "constant"

    # $ANTLR start "synpred80_jal"
    def synpred80_jal_fragment(self, ):
        # jal.g:150:12: ( proc_func_call )
        # jal.g:150:12: proc_func_call
        pass 
        self._state.following.append(self.FOLLOW_proc_func_call_in_synpred80_jal1569)
        self.proc_func_call()

        self._state.following.pop()


    # $ANTLR end "synpred80_jal"



    # $ANTLR start "synpred93_jal"
    def synpred93_jal_fragment(self, ):
        # jal.g:184:12: ( and_expr ( '^' and_expr )* )
        # jal.g:184:12: and_expr ( '^' and_expr )*
        pass 
        self._state.following.append(self.FOLLOW_and_expr_in_synpred93_jal1744)
        self.and_expr()

        self._state.following.pop()
        # jal.g:184:21: ( '^' and_expr )*
        while True: #loop77
            alt77 = 2
            LA77_0 = self.input.LA(1)

            if (LA77_0 == 73) :
                alt77 = 1


            if alt77 == 1:
                # jal.g:184:22: '^' and_expr
                pass 
                self.match(self.input, 73, self.FOLLOW_73_in_synpred93_jal1747)
                self._state.following.append(self.FOLLOW_and_expr_in_synpred93_jal1749)
                self.and_expr()

                self._state.following.pop()


            else:
                break #loop77




    # $ANTLR end "synpred93_jal"




    # Delegated rules

    def synpred80_jal(self):
        self._state.backtracking += 1
        start = self.input.mark()
        try:
            self.synpred80_jal_fragment()
        except BacktrackingFailed:
            success = False
        else:
            success = True
        self.input.rewind(start)
        self._state.backtracking -= 1
        return success

    def synpred93_jal(self):
        self._state.backtracking += 1
        start = self.input.mark()
        try:
            self.synpred93_jal_fragment()
        except BacktrackingFailed:
            success = False
        else:
            success = True
        self.input.rewind(start)
        self._state.backtracking -= 1
        return success



    # lookup tables for DFA #2

    DFA2_eot = DFA.unpack(
        u"\34\uffff"
        )

    DFA2_eof = DFA.unpack(
        u"\23\uffff\1\27\10\uffff"
        )

    DFA2_min = DFA.unpack(
        u"\1\4\12\uffff\2\4\6\uffff\1\4\2\60\6\uffff"
        )

    DFA2_max = DFA.unpack(
        u"\1\75\12\uffff\2\4\6\uffff\1\75\2\66\6\uffff"
        )

    DFA2_accept = DFA.unpack(
        u"\1\uffff\1\1\1\2\1\3\1\4\1\5\1\6\1\7\1\10\1\11\1\12\2\uffff\1"
        u"\17\1\20\1\21\1\22\1\23\1\24\3\uffff\1\25\1\26\1\14\1\13\1\15\1"
        u"\16"
        )

    DFA2_special = DFA.unpack(
        u"\34\uffff"
        )

            
    DFA2_transition = [
        DFA.unpack(u"\1\23\16\uffff\1\15\1\16\1\17\1\20\1\21\1\22\4\uffff"
        u"\1\2\4\uffff\1\3\1\6\1\5\1\uffff\1\4\3\uffff\1\7\3\uffff\1\1\1"
        u"\13\3\uffff\1\14\5\uffff\1\12\1\11\2\uffff\1\10"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\24"),
        DFA.unpack(u"\1\25"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\27\5\uffff\4\27\5\uffff\6\27\1\26\3\uffff\1\27"
        u"\2\uffff\7\27\1\uffff\3\27\2\uffff\4\27\2\uffff\1\27\5\uffff\2"
        u"\27\2\uffff\1\27"),
        DFA.unpack(u"\1\31\1\uffff\1\31\3\uffff\1\30"),
        DFA.unpack(u"\1\32\5\uffff\1\33"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"")
    ]

    # class definition for DFA #2

    DFA2 = DFA
    # lookup tables for DFA #57

    DFA57_eot = DFA.unpack(
        u"\12\uffff"
        )

    DFA57_eof = DFA.unpack(
        u"\12\uffff"
        )

    DFA57_min = DFA.unpack(
        u"\1\4\7\uffff\1\0\1\uffff"
        )

    DFA57_max = DFA.unpack(
        u"\1\121\7\uffff\1\0\1\uffff"
        )

    DFA57_accept = DFA.unpack(
        u"\1\uffff\1\1\7\uffff\1\2"
        )

    DFA57_special = DFA.unpack(
        u"\10\uffff\1\0\1\uffff"
        )

            
    DFA57_transition = [
        DFA.unpack(u"\2\1\1\uffff\1\1\2\uffff\4\1\42\uffff\1\10\34\uffff"
        u"\2\1\2\uffff\1\1"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\uffff"),
        DFA.unpack(u"")
    ]

    # class definition for DFA #57

    class DFA57(DFA):
        def specialStateTransition(self_, s, input):
            # convince pylint that my self_ magic is ok ;)
            # pylint: disable-msg=E0213

            # pretend we are a member of the recognizer
            # thus semantic predicates can be evaluated
            self = self_.recognizer

            _s = s

            if s == 0: 
                LA57_8 = input.LA(1)

                 
                index57_8 = input.index()
                input.rewind()
                s = -1
                if (self.synpred93_jal()):
                    s = 1

                elif (True):
                    s = 9

                 
                input.seek(index57_8)
                if s >= 0:
                    return s

            if self._state.backtracking >0:
                raise BacktrackingFailed
            nvae = NoViableAltException(self_.getDescription(), 57, _s, input)
            self_.error(nvae)
            raise nvae
 

    FOLLOW_statement_in_program59 = frozenset([1, 4, 19, 20, 21, 22, 23, 24, 29, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_block_stmt_in_statement82 = frozenset([1])
    FOLLOW_for_stmt_in_statement86 = frozenset([1])
    FOLLOW_forever_stmt_in_statement90 = frozenset([1])
    FOLLOW_if_stmt_in_statement94 = frozenset([1])
    FOLLOW_repeat_stmt_in_statement107 = frozenset([1])
    FOLLOW_while_stmt_in_statement111 = frozenset([1])
    FOLLOW_case_stmt_in_statement115 = frozenset([1])
    FOLLOW_var_def_in_statement127 = frozenset([1])
    FOLLOW_const_def_in_statement131 = frozenset([1])
    FOLLOW_alias_def_in_statement135 = frozenset([1])
    FOLLOW_proc_def_in_statement147 = frozenset([1])
    FOLLOW_pseudo_proc_def_in_statement151 = frozenset([1])
    FOLLOW_func_def_in_statement163 = frozenset([1])
    FOLLOW_pseudo_func_def_in_statement167 = frozenset([1])
    FOLLOW_19_in_statement179 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_expr_in_statement181 = frozenset([1])
    FOLLOW_20_in_statement193 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_expr_in_statement195 = frozenset([1])
    FOLLOW_21_in_statement207 = frozenset([4])
    FOLLOW_IDENTIFIER_in_statement209 = frozenset([1])
    FOLLOW_22_in_statement221 = frozenset([5])
    FOLLOW_STRING_LITERAL_in_statement223 = frozenset([1])
    FOLLOW_23_in_statement235 = frozenset([5])
    FOLLOW_STRING_LITERAL_in_statement237 = frozenset([1])
    FOLLOW_24_in_statement249 = frozenset([5])
    FOLLOW_STRING_LITERAL_in_statement251 = frozenset([1])
    FOLLOW_IDENTIFIER_in_statement256 = frozenset([25])
    FOLLOW_25_in_statement258 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_expr_in_statement260 = frozenset([1])
    FOLLOW_proc_func_call_in_statement265 = frozenset([1])
    FOLLOW_constant_in_cexpr280 = frozenset([1])
    FOLLOW_26_in_cexpr_list297 = frozenset([10, 11, 12, 13])
    FOLLOW_cexpr_in_cexpr_list299 = frozenset([27, 28])
    FOLLOW_27_in_cexpr_list303 = frozenset([10, 11, 12, 13])
    FOLLOW_cexpr_in_cexpr_list305 = frozenset([27, 28])
    FOLLOW_28_in_cexpr_list310 = frozenset([1])
    FOLLOW_29_in_for_stmt321 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_expr_in_for_stmt323 = frozenset([30, 31])
    FOLLOW_30_in_for_stmt327 = frozenset([4])
    FOLLOW_IDENTIFIER_in_for_stmt329 = frozenset([30, 31])
    FOLLOW_31_in_for_stmt334 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 32, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_for_stmt353 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 32, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_32_in_for_stmt374 = frozenset([31])
    FOLLOW_31_in_for_stmt376 = frozenset([32, 33])
    FOLLOW_33_in_for_stmt393 = frozenset([31])
    FOLLOW_31_in_for_stmt395 = frozenset([1])
    FOLLOW_34_in_forever_stmt412 = frozenset([31])
    FOLLOW_31_in_forever_stmt414 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 32, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_forever_stmt433 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 32, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_32_in_forever_stmt454 = frozenset([31])
    FOLLOW_31_in_forever_stmt456 = frozenset([32, 33])
    FOLLOW_33_in_forever_stmt473 = frozenset([31])
    FOLLOW_31_in_forever_stmt475 = frozenset([1])
    FOLLOW_35_in_while_stmt492 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_expr_in_while_stmt494 = frozenset([31])
    FOLLOW_31_in_while_stmt496 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 32, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_while_stmt515 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 32, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_32_in_while_stmt536 = frozenset([31])
    FOLLOW_31_in_while_stmt538 = frozenset([32, 33])
    FOLLOW_33_in_while_stmt555 = frozenset([31])
    FOLLOW_31_in_while_stmt557 = frozenset([1])
    FOLLOW_36_in_repeat_stmt574 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 32, 34, 35, 36, 37, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_repeat_stmt592 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 32, 34, 35, 36, 37, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_32_in_repeat_stmt613 = frozenset([31])
    FOLLOW_31_in_repeat_stmt615 = frozenset([32, 37])
    FOLLOW_37_in_repeat_stmt632 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_expr_in_repeat_stmt634 = frozenset([1])
    FOLLOW_38_in_if_stmt651 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_expr_in_if_stmt653 = frozenset([39])
    FOLLOW_39_in_if_stmt655 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 40, 41, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_if_stmt657 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 40, 41, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_40_in_if_stmt673 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_expr_in_if_stmt675 = frozenset([39])
    FOLLOW_39_in_if_stmt677 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 40, 41, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_if_stmt679 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 40, 41, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_41_in_if_stmt698 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 41, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_if_stmt700 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 41, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_33_in_if_stmt718 = frozenset([38])
    FOLLOW_38_in_if_stmt720 = frozenset([1])
    FOLLOW_42_in_case_stmt737 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_expr_in_case_stmt739 = frozenset([43])
    FOLLOW_43_in_case_stmt741 = frozenset([10, 11, 12, 13])
    FOLLOW_cexpr_in_case_stmt759 = frozenset([27, 44])
    FOLLOW_27_in_case_stmt762 = frozenset([10, 11, 12, 13])
    FOLLOW_cexpr_in_case_stmt764 = frozenset([27, 44])
    FOLLOW_44_in_case_stmt768 = frozenset([4, 10, 11, 12, 13, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 45, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_case_stmt770 = frozenset([10, 11, 12, 13, 33, 45])
    FOLLOW_cexpr_in_case_stmt790 = frozenset([27, 44])
    FOLLOW_27_in_case_stmt793 = frozenset([10, 11, 12, 13])
    FOLLOW_cexpr_in_case_stmt795 = frozenset([27, 44])
    FOLLOW_44_in_case_stmt799 = frozenset([4, 10, 11, 12, 13, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 45, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_case_stmt801 = frozenset([10, 11, 12, 13, 33, 45])
    FOLLOW_45_in_case_stmt823 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 45, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_case_stmt825 = frozenset([33, 45])
    FOLLOW_33_in_case_stmt841 = frozenset([42])
    FOLLOW_42_in_case_stmt843 = frozenset([1])
    FOLLOW_46_in_block_stmt860 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_block_stmt862 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_33_in_block_stmt865 = frozenset([46])
    FOLLOW_46_in_block_stmt867 = frozenset([1])
    FOLLOW_47_in_proc_def876 = frozenset([4])
    FOLLOW_IDENTIFIER_in_proc_def878 = frozenset([48, 50])
    FOLLOW_48_in_proc_def882 = frozenset([49, 52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_proc_parm_in_proc_def886 = frozenset([27, 49])
    FOLLOW_27_in_proc_def889 = frozenset([52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_proc_parm_in_proc_def891 = frozenset([27, 49])
    FOLLOW_49_in_proc_def898 = frozenset([50])
    FOLLOW_50_in_proc_def903 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_proc_def921 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_33_in_proc_def936 = frozenset([47])
    FOLLOW_47_in_proc_def938 = frozenset([1])
    FOLLOW_51_in_func_def951 = frozenset([4])
    FOLLOW_IDENTIFIER_in_func_def953 = frozenset([48])
    FOLLOW_48_in_func_def955 = frozenset([52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_proc_parm_in_func_def957 = frozenset([27, 49])
    FOLLOW_27_in_func_def960 = frozenset([52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_proc_parm_in_func_def962 = frozenset([27, 49])
    FOLLOW_49_in_func_def966 = frozenset([50])
    FOLLOW_50_in_func_def968 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_func_def986 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_33_in_func_def1001 = frozenset([51])
    FOLLOW_51_in_func_def1003 = frozenset([1])
    FOLLOW_52_in_proc_parm1016 = frozenset([52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_type_in_proc_parm1019 = frozenset([6, 53])
    FOLLOW_IN_in_proc_parm1023 = frozenset([4])
    FOLLOW_53_in_proc_parm1027 = frozenset([4])
    FOLLOW_IN_in_proc_parm1031 = frozenset([53])
    FOLLOW_53_in_proc_parm1033 = frozenset([4])
    FOLLOW_IDENTIFIER_in_proc_parm1037 = frozenset([1, 63, 64])
    FOLLOW_at_decl_in_proc_parm1039 = frozenset([1])
    FOLLOW_47_in_pseudo_proc_def1053 = frozenset([4])
    FOLLOW_IDENTIFIER_in_pseudo_proc_def1055 = frozenset([54])
    FOLLOW_54_in_pseudo_proc_def1057 = frozenset([55])
    FOLLOW_55_in_pseudo_proc_def1059 = frozenset([48])
    FOLLOW_48_in_pseudo_proc_def1061 = frozenset([27, 49, 52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_proc_parm_in_pseudo_proc_def1063 = frozenset([27, 49])
    FOLLOW_27_in_pseudo_proc_def1067 = frozenset([52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_proc_parm_in_pseudo_proc_def1069 = frozenset([27, 49])
    FOLLOW_49_in_pseudo_proc_def1073 = frozenset([50])
    FOLLOW_50_in_pseudo_proc_def1075 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_pseudo_proc_def1093 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_33_in_pseudo_proc_def1108 = frozenset([47])
    FOLLOW_47_in_pseudo_proc_def1110 = frozenset([1])
    FOLLOW_51_in_pseudo_func_def1123 = frozenset([4])
    FOLLOW_IDENTIFIER_in_pseudo_func_def1125 = frozenset([54])
    FOLLOW_54_in_pseudo_func_def1127 = frozenset([56])
    FOLLOW_56_in_pseudo_func_def1129 = frozenset([48])
    FOLLOW_48_in_pseudo_func_def1131 = frozenset([27, 49, 52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_proc_parm_in_pseudo_func_def1133 = frozenset([27, 49])
    FOLLOW_27_in_pseudo_func_def1137 = frozenset([52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_proc_parm_in_pseudo_func_def1139 = frozenset([27, 49])
    FOLLOW_49_in_pseudo_func_def1143 = frozenset([19])
    FOLLOW_19_in_pseudo_func_def1145 = frozenset([52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_type_in_pseudo_func_def1147 = frozenset([50])
    FOLLOW_50_in_pseudo_func_def1149 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_statement_in_pseudo_func_def1167 = frozenset([4, 19, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_33_in_pseudo_func_def1182 = frozenset([51])
    FOLLOW_51_in_pseudo_func_def1184 = frozenset([1])
    FOLLOW_57_in_alias_def1206 = frozenset([4])
    FOLLOW_IDENTIFIER_in_alias_def1208 = frozenset([50])
    FOLLOW_50_in_alias_def1210 = frozenset([4])
    FOLLOW_IDENTIFIER_in_alias_def1212 = frozenset([1])
    FOLLOW_58_in_const_def1229 = frozenset([4, 52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_vtype_in_const_def1231 = frozenset([4, 52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_IDENTIFIER_in_const_def1234 = frozenset([25, 59])
    FOLLOW_59_in_const_def1238 = frozenset([10, 11, 12, 13, 60])
    FOLLOW_cexpr_in_const_def1240 = frozenset([10, 11, 12, 13, 60])
    FOLLOW_60_in_const_def1243 = frozenset([25, 59])
    FOLLOW_25_in_const_def1248 = frozenset([4, 5, 10, 11, 12, 13, 26])
    FOLLOW_cexpr_in_const_def1264 = frozenset([1])
    FOLLOW_cexpr_list_in_const_def1268 = frozenset([1])
    FOLLOW_IDENTIFIER_in_const_def1272 = frozenset([1])
    FOLLOW_STRING_LITERAL_in_const_def1276 = frozenset([1])
    FOLLOW_var_decl1_in_var_def1295 = frozenset([4])
    FOLLOW_var_decl2_in_var_def1297 = frozenset([1, 25, 27, 50, 63, 64])
    FOLLOW_var_multi_in_var_def1300 = frozenset([1, 27])
    FOLLOW_at_decl_in_var_def1305 = frozenset([1])
    FOLLOW_is_decl_in_var_def1309 = frozenset([1])
    FOLLOW_var_with_init_in_var_def1313 = frozenset([1])
    FOLLOW_27_in_var_multi1331 = frozenset([4])
    FOLLOW_var_decl2_in_var_multi1333 = frozenset([1])
    FOLLOW_25_in_var_with_init1350 = frozenset([4, 5, 7, 10, 11, 12, 13, 19, 20, 21, 22, 23, 24, 26, 29, 34, 35, 36, 38, 42, 46, 47, 51, 57, 58, 61])
    FOLLOW_var_init_in_var_with_init1352 = frozenset([1])
    FOLLOW_61_in_var_decl11369 = frozenset([52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_52_in_var_decl11371 = frozenset([52, 65, 66, 67, 68, 69, 70, 71])
    FOLLOW_vtype_in_var_decl11374 = frozenset([1])
    FOLLOW_IDENTIFIER_in_var_decl21391 = frozenset([1, 59])
    FOLLOW_59_in_var_decl21395 = frozenset([10, 11, 12, 13, 60])
    FOLLOW_cexpr_in_var_decl21397 = frozenset([10, 11, 12, 13, 60])
    FOLLOW_60_in_var_decl21400 = frozenset([1, 59])
    FOLLOW_type_in_vtype1424 = frozenset([1, 62])
    FOLLOW_62_in_vtype1427 = frozenset([10, 11, 12, 13])
    FOLLOW_constant_in_vtype1429 = frozenset([1, 62])
    FOLLOW_63_in_at_decl1449 = frozenset([63, 64])
    FOLLOW_64_in_at_decl1453 = frozenset([4, 10, 11, 12, 13, 26])
    FOLLOW_cexpr_in_at_decl1459 = frozenset([1, 44])
    FOLLOW_bitloc_in_at_decl1461 = frozenset([1, 44])
    FOLLOW_IDENTIFIER_in_at_decl1471 = frozenset([1, 44])
    FOLLOW_bitloc_in_at_decl1473 = frozenset([1, 44])
    FOLLOW_cexpr_list_in_at_decl1480 = frozenset([1])
    FOLLOW_50_in_is_decl1499 = frozenset([4])
    FOLLOW_IDENTIFIER_in_is_decl1501 = frozenset([1])
    FOLLOW_44_in_bitloc1519 = frozenset([10, 11, 12, 13])
    FOLLOW_constant_in_bitloc1521 = frozenset([1])
    FOLLOW_IDENTIFIER_in_proc_func_call1542 = frozenset([1, 48])
    FOLLOW_48_in_proc_func_call1545 = frozenset([4, 49])
    FOLLOW_IDENTIFIER_in_proc_func_call1547 = frozenset([4, 49])
    FOLLOW_49_in_proc_func_call1550 = frozenset([1])
    FOLLOW_proc_func_call_in_var_init1569 = frozenset([1])
    FOLLOW_cexpr_in_var_init1573 = frozenset([1])
    FOLLOW_cexpr_list_in_var_init1577 = frozenset([1])
    FOLLOW_STRING_LITERAL_in_var_init1581 = frozenset([1])
    FOLLOW_CHARACTER_LITERAL_in_var_init1585 = frozenset([1])
    FOLLOW_IDENTIFIER_in_var_init1589 = frozenset([1])
    FOLLOW_set_in_type0 = frozenset([1])
    FOLLOW_xor_expr_in_expr1723 = frozenset([1, 72])
    FOLLOW_72_in_expr1726 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_xor_expr_in_expr1728 = frozenset([1, 72])
    FOLLOW_and_expr_in_xor_expr1744 = frozenset([1, 73])
    FOLLOW_73_in_xor_expr1747 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_and_expr_in_xor_expr1749 = frozenset([1, 73])
    FOLLOW_48_in_xor_expr1757 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_xor_expr_in_xor_expr1759 = frozenset([49])
    FOLLOW_49_in_xor_expr1761 = frozenset([1])
    FOLLOW_shift_expr_in_and_expr1780 = frozenset([1, 74])
    FOLLOW_74_in_and_expr1783 = frozenset([4, 5, 7, 10, 11, 12, 13, 77, 78, 81])
    FOLLOW_shift_expr_in_and_expr1785 = frozenset([1, 74])
    FOLLOW_48_in_and_expr1794 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_and_expr_in_and_expr1796 = frozenset([49])
    FOLLOW_49_in_and_expr1798 = frozenset([1])
    FOLLOW_arith_expr_in_shift_expr1817 = frozenset([1, 75, 76])
    FOLLOW_set_in_shift_expr1820 = frozenset([4, 5, 7, 10, 11, 12, 13, 77, 78, 81])
    FOLLOW_arith_expr_in_shift_expr1826 = frozenset([1, 75, 76])
    FOLLOW_term_in_arith_expr1847 = frozenset([1, 77, 78])
    FOLLOW_set_in_arith_expr1850 = frozenset([4, 5, 7, 10, 11, 12, 13, 77, 78, 81])
    FOLLOW_term_in_arith_expr1856 = frozenset([1, 77, 78])
    FOLLOW_factor_in_term1877 = frozenset([1, 62, 79, 80])
    FOLLOW_set_in_term1880 = frozenset([4, 5, 7, 10, 11, 12, 13, 77, 78, 81])
    FOLLOW_factor_in_term1893 = frozenset([1, 62, 79, 80])
    FOLLOW_77_in_factor1909 = frozenset([4, 5, 7, 10, 11, 12, 13, 77, 78, 81])
    FOLLOW_factor_in_factor1911 = frozenset([1])
    FOLLOW_78_in_factor1922 = frozenset([4, 5, 7, 10, 11, 12, 13, 77, 78, 81])
    FOLLOW_factor_in_factor1924 = frozenset([1])
    FOLLOW_81_in_factor1935 = frozenset([4, 5, 7, 10, 11, 12, 13, 77, 78, 81])
    FOLLOW_factor_in_factor1937 = frozenset([1])
    FOLLOW_atom_in_factor1948 = frozenset([1])
    FOLLOW_CHARACTER_LITERAL_in_atom1970 = frozenset([1])
    FOLLOW_STRING_LITERAL_in_atom1988 = frozenset([1])
    FOLLOW_constant_in_atom2006 = frozenset([1])
    FOLLOW_IDENTIFIER_in_atom2011 = frozenset([1])
    FOLLOW_set_in_constant0 = frozenset([1])
    FOLLOW_proc_func_call_in_synpred80_jal1569 = frozenset([1])
    FOLLOW_and_expr_in_synpred93_jal1744 = frozenset([1, 73])
    FOLLOW_73_in_synpred93_jal1747 = frozenset([4, 5, 7, 10, 11, 12, 13, 48, 77, 78, 81])
    FOLLOW_and_expr_in_synpred93_jal1749 = frozenset([1, 73])



def main(argv, stdin=sys.stdin, stdout=sys.stdout, stderr=sys.stderr):
    from antlr3.main import ParserMain
    main = ParserMain("jalLexer", jalParser)
    main.stdin = stdin
    main.stdout = stdout
    main.stderr = stderr
    main.execute(argv)


if __name__ == '__main__':
    main(sys.argv)
