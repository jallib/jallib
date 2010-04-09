#!/usr/bin/env python

# bw 9 Jan 2010
#
import os.path
import optparse
from plex import *

resword = Str(  "_debug", "_error", "_warn", "alias", "asm", "assembler", 
                "assert", "at", "bit", "block", "byte", "case", "const", 
                "defined", "dword", "else", "elsif", "end", "exit", "for", "forever", 
                "function", "if", "in", "include", "is", "loop", "of", "out", "pragma", 
                "procedure", "repeat", "return", "sbit", "sbyte", "sdword", "start", 
                "suspend", "sword", "task", "then", "until", "using", "var", "volatile",
                "while", "word" )

comment = Str("--", ";") + Rep(AnyBut('\n')) + Eol
digit = Range("09") | Str('_')
hexdigit = Range("09AFaf") | Str('_')
hexnum = Str("0x") + Rep1(hexdigit)
binarydigit = Range("01") | Str('_')
binarynum = Str("0b") + Rep1(binarydigit)
letter = Range("AZaz") | Str('_')
name = Rep1(letter | digit )
number = Rep1(digit)
ps_get = name + Str("'get")
ps_put = name + Str("'put")
qstring = Str('"') + AnyBut('"') + Rep1(AnyBut('"')) + Str('"')
qascii = Str('"') + AnyBut('"') + Str('"')
space = Any(" \t\n")
op2 = Str("<<", ">>", "<=", "==", "!=", ">=")

def do_resword(token, word):
    return word.lower()

lex_table = Lexicon([
    (comment, 'comment'),  # we may want to see the comments while debugging
    (qstring, 'qstring'),
    (qascii, 'qascii'),
    (resword, do_resword),
    (NoCase(ps_put), 'ps_put'),
    (NoCase(ps_get), 'ps_get'),
    (NoCase(hexnum), 'hexnum'),
    (NoCase(binarynum), 'binarynum'),
    (number, 'number'),
    (op2, 'op2'),
    (name, 'id'),

    # FIXME
    (Any("%!|&.:^[],'(){}+-*/=<>\"\\"),  TEXT),

    (space , IGNORE),
])

# Future: if we want to show a traceback of nested includes.
include_stack = []

token_list = []
include_path = []

# FIXME. need better approach to dealing with
# all the places the file might be found.
def find_and_open(p_fname):

    # Make an exhaustive list, but we'll stop
    # with the first one we can open correctly.
    files = [p_fname]
    for path in include_path:
        files.append(os.path.join(path, p_fname))

    for fname in files:
        try:
            f = open(fname, "r")
        except:
            pass
        else:
            return fname, f

    print "Open failed on file: " , p_fname
    return p_fname, None

def lex_include(cur_file, cur_lineno, inc_file):
    print "do include: ", cur_file, cur_lineno, inc_file
    include_stack.append( (cur_file, cur_lineno, inc_file) )
    # recursive call to lexan
    lexan(inc_file)
    include_stack.pop()

def lexan(p_fname):
    print "lexan file: ", p_fname
    fname, f = find_and_open(p_fname)
    if f is None:
        return

    scanner = Scanner(lex_table, f, fname)
    while True:
        token = scanner.read()
        if not token[0]:
            break
        if token[0] == 'include':
            cur_fname, cur_lineno, cur_pos = scanner.position()
            token = scanner.read()
            inc_file = token[1] + ".jal"
            lex_include(cur_fname, cur_lineno, inc_file)
        else:
            #print "token = ", token
            token_list.append( token )

def parse():
    print "parsing file"
    for t in token_list:
        # supress comments for now
        if t[0] != 'comment':
            print "token = ", t

def compile(fname):
    lexan(fname)
    parse()
    
def main():
    p = optparse.OptionParser()
    p.add_option("-s", action="append", dest="ipath")
    opts, args = p.parse_args()
    global include_path
    include_path = opts.ipath

    for fname in args:
        compile(fname)

if __name__ == '__main__':
    main()

