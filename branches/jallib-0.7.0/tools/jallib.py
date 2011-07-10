#!/usr/bin/python
#
#
# Title: jallib main wrapper script
# Author: Sebastien Lelong, Copyright (c) 2008, all rights reserved.
# Adapted-by:
# Compiler:
#
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
#
# Description: this script handles common tasks when using the jallib SVN repository
# `jallib help` for more !
#
# Dependencies: according to the following actions, you'll need to install the
# following libraries (if you don't use the action, you can skip it)
# If you use the binary executables, you won't need to install them
deps = [
    # (lib name, used in actions, website)
    ('cheetah','jalapi','http://cheetahtemplate.org'),
    ]
# Of course, since it's about jal, you'll need jalv2 compiler installed
# (not bundled in binary executables)
# - jalv2 executable (compile): http://www.casadeyork.com/jalv2
#
# Notes:
#


import sys, os
import getopt
import re
import datetime, time
import types as pytypes

try:
    import Cheetah.Template
    has_cheetah = True
except ImportError:
    has_cheetah = False

try:
    import subprocess
    has_subprocess = True
except ImportError:
    has_subprocess = False


#########
# TOOLS #
#########

def get_jal_filenames(dir,subdir=None,predicate=lambda dir,filename: True):
    jalfiles = {}
    if os.path.isfile(dir):
        return {dir:dir}
    for df in os.listdir(dir):
        if df.startswith("."):
            continue
        fulldf = os.path.join(dir,df)
        halfdf = os.path.join(subdir and subdir or "",df)
        if os.path.isfile(fulldf) and fulldf.endswith(".jal") and predicate(dir,df):
            jalfiles[df] = halfdf
        elif os.path.isdir(fulldf):
            jalfiles.update(get_jal_filenames(fulldf,subdir=os.path.join(subdir and subdir or "",df),predicate=predicate))
    return jalfiles

def get_full_sample_path(sample_dir,sample=""):
    return os.path.join(sample_dir,sample)


# cache found files
explored_tests = None
def get_full_test_path(sample_dir,test=""):
    global explored_tests
    testdir = os.path.join(sample_dir,"..","test")
    if not test:
        return testdir
    else:
        if not explored_tests:
            # exclude board
            tdirs = [(d,os.path.join(testdir,d)) for d in os.listdir(testdir) if not d.startswith(".") and d != "board"]
            # search for test file...
            test_files = {}
            for (subdir,tdir) in tdirs:
                test_files.update(get_jal_filenames(tdir,subdir)) ## if f.startswith("test_")])
            explored_tests = test_files

        return os.path.join(testdir,explored_tests[test])

def get_full_board_path(sample_dir,board=""):
    return os.path.join(sample_dir,"..","test","board",board)


def find_includes(jalfile):
    content = file(jalfile).read()
    return re.findall("^\s*include\s+(\w+)\s*",content,re.MULTILINE)


def split_repos(repos):
    # honor way to define to different paths whether it's on *nix
    # (using ":") or windows (using ";" like jalv2 compiler)
    if not repos:
        return []
    if sys.platform.lower().startswith("win"):
        gdirs = repos.split(";")
    else:
        gdirs = repos.split(":")
   
    return gdirs


################
# MAIN TARGETS #
################


#---------#
# COMPILE #
#---------#

def _explore_dir(onedir):
    dirs = [onedir]
    def keepit(fd):
        if os.path.isdir(fd):
            dirs.extend(_explore_dir(fd))
    # silently don't explore subdirs if onedir actually
    # doesn't exist, and simply ignore it
    if not os.path.isdir(onedir):
        return []
    for fd in os.listdir(onedir):
        if not fd.startswith("."):
            keepit(os.path.join(onedir,fd))
    return dirs


def clean_compiler_products(fromjalfile):
    outdir = os.path.dirname(fromjalfile) or os.path.curdir
    outfile = os.path.basename(fromjalfile)
    noext = outfile[:-4]
    for f in os.listdir(outdir):
        # luckily all product files have 3-letters extension
        if f[:-4] == noext and f[-4:] in [".asm",".hex",".err",".cod",".obj",".lst"]:
            toclean = os.path.join(outdir,f)
            print >> sys.stderr, "Cleaning %s" % toclean
            try:
                os.unlink(toclean)
            except OSError,e:
                print >> sys.stderr, "Can't clean %s because: %s" % (toclean,e)


def do_compile(args,exitonerror=True,clean=False,stdout=None,stderr=None):
    if not has_subprocess:
        print >> sys.stderr, "You can't use this action, because subprocess module is not installed"
        sys.exit(255)

    # If we can't parse given args, this means there're all
    # for the compiler. Keep them as backup
    original_args = args

    # Only parse jallib arg, leave other for underlying cmd
    def parse_args(args,limit=0):
        if limit:
            args = args[:limit]
        if not args:
            return (),()
        # If error, eats args from the end, until no error: seperate args for
        # jallib and args for compiler (not that clean...)
        try:
            opts, args = getopt.getopt(args, ACTIONS['compile']['options'])
            return opts,args
        except getopt.error,e:
            return parse_args(args,-1)

    # There's not even an argument for the compiler...
    if not original_args:
        print >> sys.stderr, "Missing arguments to jalv2 compiler..."
        sys.exit(255)

    # Try to extract jallib args
    opts, args = parse_args(args)
    if not opts:
        # If it gives nothing, this means all given args
        # are for the compiler. Restore original args.
        args = original_args
    else:
        # there are opts for jallib, but args for jalv2 may have been
        # eaten in parse_args(). Need to extract them according to opts
        jallib_args = []
        map(lambda i: jallib_args.extend(i),opts)
        args = list(set(original_args).difference(set(jallib_args)))


    jalv2_exec = None
    dirs = []
    for o,v in opts:
        if o == '-R':
            gdirs = v.split(";")
            for d in gdirs:
                dirs.extend(_explore_dir(d))
        elif o == '-E':
            jalv2_exec = v
        else:
            print >> sys.stderr, "Wrong option %s" % o
    # No root specified ? Try env var, else defaut to cwd
    if not dirs:
        try:
            gdirs = split_repos(os.environ['JALLIB_REPOS'])
        except KeyError:
            # no such env var, takes param from commandline, and honor
            # jalv2 compiler separator
            gdirs = os.path.curdir.split(";")
        for d in gdirs:
            dirs.extend(_explore_dir(d))
    # No exec specify, try env var or defaulting
    if not jalv2_exec:
        jalv2_exec = os.environ.get('JALLIB_JALV2','jalv2')
    cmd = [jalv2_exec] + ["-s",";".join(dirs)]
    ###print cmd
    # Complete with compiler args
    if args:
        cmd.extend(args)
    try:
        status = subprocess.check_call(cmd,shell=False,stdout=stdout,stderr=stderr)
        if clean:
            # assume srcfile is last arg (it not, can't clean)
            srcfile = cmd[-1]
            if not srcfile.endswith(".jal"):
                print >> sys.stderr, "Can't clean, because can't know which file is the source file"
                return status
            clean_compiler_products(srcfile)

        return status

    except subprocess.CalledProcessError,e:
        print >> sys.stderr, "Error while compiling file (status=%s).\nSee previous message." % e.returncode
        exitonerror and sys.exit(e.returncode)
        return e.returncode



#----------#
# VALIDATE #
#----------#

def content_not_empty(val):
    return val.strip() != ''
def compiler_version(val):
    return re.match("^(>|<|>=|<=|=)?\d+(\.\d+\w*)+\s+$",val)

JALLIB = """^-- This file is part of (jallib|jaluino)\s+\(http://(jallib|jaluino).googlecode.com\)"""
LICENSE = """^-- Released under the BSD license\s+\(http://www.opensource.org/licenses/bsd-license.php\)"""
LICENSE2 = """^-- Released under the ZLIB license\s+\(http://www.opensource.org/licenses/zlib-license.html\)"""

# exceptions while checking case
ALLOWED_MIXED_CASE = """.*(pin|port|_shadow|_flush).*"""

FIELDS = [
        {'field':"Title",'predicate' : content_not_empty,'mandatory': True, 'multiline' :False},
        {'field':"Author",'predicate':content_not_empty,'mandatory':True,'multiline':False},
        {'field':"Adapted-by",'predicate':content_not_empty,'mandatory':False,'multiline':False},
        {'field':"Compiler",'predicate':compiler_version,'mandatory':True,'multiline':False},
        {'field':"Description",'predicate':content_not_empty,'mandatory':True,'multiline':True},
        {'field':"Sources",'predicate':content_not_empty,'mandatory':False,'multiline':True},
        {'field':"Notes",'predicate':content_not_empty,'mandatory':False,'multiline':True},
    ]

errors = []
warnings = []

def extract_header(content):
    # reverse() to pop header lines (no such shift())
    content.reverse()
    header = []
    while True:
        i,l = content.pop()
        if not l.startswith("--"):
            # not a header line, put it again
            content.append((i,l))
            break
        else:
            header.append((i,l))
    # remaining content: back to forward...
    content.reverse()
    return header

def validate_field(data,field,predicate,mandatory,multiline=False):

    syntax = "^-- %s:\s*(.*)" % field

    def single_line_content(line):
        return "".join(re.sub(syntax,lambda x:x.group(1),line))
    def multi_line_content(num,line,data):
        c = single_line_content(line)
        for i,l in data[data.index((num,line)) + 1:]:
            # Check no comment gap
            if not re.match("^--\s",l):
                errors.append("%d: cannot extract content, line is not starting with comment: %s" % (i,repr(l)))
                return ""
            # No other field within content
            for f in [d['field'] for d in FIELDS]:
                if l.startswith("-- %s:" % f):
                    errors.append("%d: detected field %s within content of field %s" % (i,f,field))
                    return ""
            if l.strip() == '--':
                # got end of block
                break
            c += re.sub("^--\s","",l)
        else:
            errors.append("Cannot find end of field content %s" % field)
        return c

    # eat header, and check fields (mandatory or not) and
    # content (using predicate)
    c = None
    for i,l in data:
        if re.match(syntax,l):
            # got it, check field content
            if multiline:
                c = multi_line_content(i,l,data)
            else:
                c = single_line_content(l)
            # and check with predicate
            valid = predicate(c)
            if mandatory and not valid:
                errors.append("%d: content for field %s is not valid: %s" % (i,field,repr(c)))
            break
    else:
        if mandatory:
            errors.append("Cannot find field %s (searched for '%s')" % (field,syntax))

    return c


def validate_header(content):
    header = extract_header(content)

    # check stuff about jallib and license
    jallib = False
    license = False
    for i,line in header:
        if re.match(JALLIB,line):
            jallib = True
            if license: break
        if re.match(LICENSE,line) or re.match(LICENSE2,line):
            license = True
            if jallib: break
    not jallib and errors.append("Cannot find references to jallib (should have: %s)" % repr(JALLIB))
    not license and errors.append("Cannot find references to license")
    for field_dict in FIELDS:
        validate_field(header,**field_dict)


def validate_filename(filename):
    # must be lowercase
    filename = os.path.basename(filename)
    if filename.lower() != filename:
        errors.append("Filename is not lowercase: %s" % filename)
    # should have "jal" extention
    if not filename.endswith(".jal"):
        warnings.append("Filename doesn't have '*.jal' extention: %s" % filename)
    pass


def validate_lower_case(content):
    # tokenize content, searching for infamous CamelCase words
    # Also search Capitalized ones...
    tokenizer = re.compile("\w+")
    caps = re.compile("[A-Z]")
    freetext = re.compile('(("|\').*("|\'))')
    mixed = re.compile(ALLOWED_MIXED_CASE,re.IGNORECASE)
    # no check in comments
    codeonly = []
    for i,line in content:
        if line.startswith(";") or line.startswith("--"):
            continue
        # don't consider free text (between quotes)
        line = freetext.sub("",line)
        l = line.split()
        def nocomment(l,c):
            # dirty search comments...
            if c in l:
                l = l[:l.index(c)]
            tmp = [w.startswith(c) for n,w in enumerate(l)]
            if True in tmp:
                l = l[:tmp.index(True)]
            return l
        # first check ";" *then* "--"
        # so things like ";;;;-- Note" are not considered
        # (else produces wrong splitting...)
        l = nocomment(l,";")
        l = nocomment(l,"--")
        # propagate line number
        codeonly.append((i," ".join(l)))

    weird = {}  # stores all errors
    for i,line in codeonly:
        for token in tokenizer.findall(line):
            # it can be all in caps (constants)
            if token.upper() == token:
                continue
            # hex definition, give up
            if "0x" in token:
                continue
            # exceptions...
            if mixed.match(token.lower()):
                continue
            if caps.findall(token):
                weird.setdefault("Found Capitals in token: %s" % repr(token),[]).append(i)
    # reconsitute errors, with multiple line number if error has occured multiple time
    for s,nums in weird.items():
        err = "%s: %s" % (",".join(map(str,nums)),s)
        errors.append(err)

def validate_procfunc_defs(content):
    # no () in definition
    func_proc = re.compile("^(procedure|function)")
    no_spaces = re.compile(".*\s+\(.*is")
    for i,line in content:
        # don't even check both (), not needed
        if func_proc.match(line) and not "(" in line:
            errors.append("%d: %s missing (). Calls must also be explicit" % (i,repr(line)))
        if func_proc.match(line) and no_spaces.match(line):
            errors.append("%d: found a space before parenthesis: %s" % (i,repr(line)))

def validate_code(content):
    validate_lower_case(content)
    validate_procfunc_defs(content)
    # ...

def validate(filename):
    global errors
    global warnings
    errors = []
    warnings = []
    validate_filename(filename)
    # also extract line number (enumerate from 0, count from 1)
    content = [(i + 1,l) for i,l in enumerate(open(filename,"r").readlines())]
    validate_header(content)
    # remaining content has no more header
    validate_code(content)


def report(filename):
    print >> sys.stderr, "File: %s" % filename
    print >> sys.stderr, "%d errors found" % len(errors)
    for err in errors:
        print >> sys.stderr, "\tERROR: %s:%s" % (os.path.basename(filename),err)
    print >> sys.stderr
    print >> sys.stderr, "%d warnings found" % len(warnings)
    for warn in warnings:
        print >> sys.stderr, "\twarning: %s:%s" % (os.path.basename(filename),warn)

    if errors or warnings:
        return True


def do_validate(args):
    # No jallib args (yet!) for validating
    # args contain jal file to validate

    at_least_one_failed = False
    for filename in args:
        validate(filename)
        if report(filename):
            at_least_one_failed = True

    if at_least_one_failed:
        sys.exit(1)
    else:
        sys.exit(0)


#--------#
# SAMPLE #
#--------#

def parse_tags(content,*args):
    current_tag = None
    current_value = None
    restags = {}
    for l in content:
        if "@jallib" in l:
            what = l.split()
            # only keep "interesting" jallib invokations
            if len(what) == 3:
                atjallib,tag,value = l.split()
                if tag in args:
                    current_tag = tag
                    current_value = value
                    restags.setdefault(current_tag,{})[current_value] = []

        if current_tag:
            restags[current_tag][current_value].append(l)
    return restags


def parse_sections(content):
    return parse_tags(content,"section")

def merge_board_testfile(boardcontent,testcontent):
    board = parse_sections(boardcontent)
    # replace sections in testcontent
    testcontent = os.linesep.join(testcontent)
    toreplace = [m for m in re.finditer("((--)+)|(;+)\s*@jallib use (.*)",testcontent,re.MULTILINE) if m.groups()[-1]]
    newcontent = ""
    start = 0
    for m in toreplace:
        sectionname = m.groups()[-1].strip()
        # when eating line sep char (to keep layout),
        # remember some OS needs 2 chars !
        newcontent += testcontent[start:m.start() - len(os.linesep)]
        if board['section'].get(sectionname):
            new = os.linesep.join(board['section'][sectionname])
            start = m.end() + 1 # next char
            newcontent += new
    newcontent += testcontent[start:]
    return newcontent

def normalize_linefeed(content):
    # use single char
    content = content.replace("\r\n","\n")
    # split and join using OS settings
    lines = re.split("[\n|\r]",content,re.MULTILINE)
    content = "\n".join(lines)
    return content


def generate_one_sample(boardfile,testfile,outfile,deleteiffailed=True):
    # try to find which linefeed is used
    board = file(boardfile).read().splitlines()
    test = file(testfile).read().splitlines()
    # keep test's headers, but enrich them with info about how files were merged
    # headers need index (enumerate() on content)
    # extract_header will change content in place, ie. will remove
    # header from test content.
    test = [t for t in enumerate(test)]
    header = extract_header(test)
    header = os.linesep.join([h for i,h in header])
    header += os.linesep.join([
                         os.linesep + "--",
                         "-- This file has been generated from:",
                         "--    * board: %s" % os.path.basename(boardfile),
                         "--    * test : %s" % os.path.basename(testfile),
                         "--",
                         os.linesep])
    # back to content without index
    test = [l for i,l in test]
    merged = merge_board_testfile(board,test)
    # wb: write binary format, no ASCII/chars interpretation
    fout = file(outfile,"wb")
    fout.write(header)
    fout.write(merged)
    fout.close()

    # compile it !
    status = do_compile([outfile],exitonerror=False,clean=True)
    if status == 0:
        print "Succesfully generated sample '%s' from board '%s' and test '%s'" % (outfile,boardfile,testfile)
    elif deleteiffailed:
        # delete the file !
        clean_compiler_products(outfile)
        os.unlink(outfile)
        raise Exception("Can't compile sample '%s' generated from '%s' and test '%s'" % (outfile,boardfile,testfile))


def find_board_files(boarddir):
    return [os.path.join(boarddir,f) for f in os.listdir(boarddir) if not f.startswith(".") and f.startswith("board_") and f.endswith(".jal")]

def find_test_files(testdir):
    # testdir contains "board" dir, to be excluded
    testfiles = []
    for d in [d for d in os.listdir(testdir) if d != "board" and not d.startswith(".")]:
        d = os.path.join(testdir,d)
        testfiles.extend([os.path.join(d,v) for v in get_jal_filenames(d,predicate=lambda _,x: x.startswith("test_")).values()])
    return testfiles

def preferred_board(board):
    data = file(board).read()
    # well, should not consider comment but... should not occur, right ? :)
    return "@jallib preferred" in data

def is_test_autoable(test):
    return not "@jallib skip-auto" in file(test).read()

def generate_samples_for_board(path_to_sample,board,outdir=None):
    if outdir:
        assert os.path.isdir(outdir), "%s must be a directory when auto-generate samples (this is where samples will be stored)" % outdir
    testpath = get_full_test_path(path_to_sample)
    samplepath = get_full_sample_path(path_to_sample)
    fulltestfiles = find_test_files(testpath)

    picname = os.path.basename(board).split("_")[1] # naming convention
    # in automated mode, only board files with "@jallib preferred" are kept.
    # this is because there can be multiple boards for a given PIC, but only
    # ony being used to auto-generate samples
    for test in fulltestfiles:
        if not is_test_autoable(test):
            print >> sys.stderr, "Skip test '%s' because tagged 'skip-auto'" % test
            continue
        samplename = picname + "_" + os.path.basename(test)[5:] # remove "test_", naming convention
        fullsamplepath = outdir and os.path.join(outdir,samplename) or get_full_sample_path(path_to_sample,samplename)
        try:
           generate_one_sample(board,test,fullsamplepath)
        except Exception,e:
           print >> sys.stderr,"Invalid board/test combination: %s" % e
           import traceback
           print >> sys.stderr, traceback.format_exc()
           continue

def generate_samples_for_test(path_to_sample,test,outdir=None):
    if outdir:
        assert os.path.isdir(outdir), "%s must be a directory when auto-generate samples (this is where samples will be stored)" % outdir
    samplepath = get_full_sample_path(path_to_sample)
    boardpath = get_full_board_path(path_to_sample)
    fullboardfiles = find_board_files(boardpath)

    if not is_test_autoable(test):
        print >> sys.stderr, "Skip test '%s' because tagged 'skip-auto'" % test
        return

    # in automated mode, only board files with "@jallib preferred" are kept.
    # this is because there can be multiple boards for a given PIC, but only
    # ony being used to auto-generate samples
    for board in fullboardfiles:
        if not preferred_board(board):
            print >> sys.stderr,"board %s is not 'preferred', skip it" % board
            continue
        picname = os.path.basename(board).split("_")[1] # naming convention
        samplename = picname + "_" + os.path.basename(test)[5:] # remove "test_", naming convention
        fullsamplepath = outdir and os.path.join(outdir,samplename) or get_full_sample_path(path_to_sample,samplename)
        try:
           generate_one_sample(board,test,fullsamplepath)
        except Exception,e:
           print >> sys.stderr,"Invalid board/test combination: %s" % e
           import traceback
           print >> sys.stderr, traceback.format_exc()
           continue

def generate_all_samples(path_to_sample,outdir=None):
    boardpath = get_full_board_path(path_to_sample)
    fullboarfiles = find_board_files(boardpath)
    for board in fullboarfiles:
        if not preferred_board(board):
            print >> sys.stderr,"board %s is not 'preferred', skip it" % board
            continue
        generate_samples_for_board(path_to_sample,board,outdir)


def do_sample(args=[]):
    try:
        opts, args = getopt.getopt(args, ACTIONS['sample']['options'])
    except getopt.error,e:
        print >> sys.stderr, "Wrong option or missing argument: %s" % e.opt
        sys.exit(255)

    boardfile = None
    testfile = None
    outfile = None
    automatic = None
    path_to_sample = None
    for o,v in opts:
        if o == '-b':
            boardfile = v
        elif o == '-t':
            testfile = v
        elif o == '-o':
            outfile = v
        elif o == '-a':
            automatic = True
            path_to_sample = v
    if automatic and path_to_sample and boardfile:
        generate_samples_for_board(path_to_sample,boardfile,outdir=outfile)
    elif automatic and testfile:
        generate_samples_for_test(path_to_sample,testfile)
        generate_samples_for_test(path_to_sample,testfile)
    elif automatic and path_to_sample:
        generate_all_samples(path_to_sample,outdir=outfile)
    elif boardfile and testfile and outfile:
        # don't delete sample if compilation fails: user knows what he's doing
        generate_one_sample(boardfile,testfile,outfile,deleteiffailed=False)
    else:
        print >> sys.stderr, "Provide a board, a test file and an output file"
        sys.exit(255)


#---------------#
# REINDENT FUNC #
#---------------#

POSTINC = ["assembler","block","case","while","for","forever","then","function","procedure"]
INLINEKW = ["assembler","block","case","function","procedure","if"]
PROTO = ["procedure","function"]
PREDEC = ["end"]
PREINCPOST = ["else","elsif"]

def reindent_file(filename,withchar,howmany):
    '''
    Default jallib standard is 3-spaces indentation
    '''
    indentchars = howmany * withchar
    data = file(filename).read()
    # dont keep last one, because since it's ended with a \n,
    # it will appear as an element in lines, resulting in a
    # new line at the end of file. Is this true ?...
    lines = re.split("\n|\r\n",data)[:-1]

    level = 0
    content = []
    for l in lines:
        # This exception is known as Joep's exception :)
        if l.startswith(";"):
            content.append(l)
            continue
        # check if comments
        try:
            code,comchars,comment = re.match("(.*?)(-{2}|;)(.*)",l).groups()
        except AttributeError,e:
            # no comments, normalize
            code = l
            comchars = comment = ""

        # remove strings between " and ', to focus only on jal keywords
        onlyjalkw = re.sub("[\"|'].*[\"|']","",code)
        fields = map(lambda x: x.lower(),onlyjalkw.strip().split())

        do_postinc = do_preincpost = do_predec = False
        if set(fields).intersection(set(POSTINC)):
            do_postinc = True
        if set(fields).intersection(set(PREINCPOST)):
            do_preincpost = True
        if set(fields).intersection(set(PREDEC)):
            do_predec = True

        # search for inline code
        reg = "|".join(INLINEKW+ ["loop"])
        found = re.findall(reg,onlyjalkw)
        if len(set(found)) != len(found):
            # inline code because duplicated kw, do nothing
            do_postinc = do_preincpost = do_predec = False
        # don't indent prototypes
        if not do_predec and set(fields).intersection(set(PROTO)) and not "is" in fields:
            do_postinc = do_preincpost = do_predec = False

        # "while ... loop end loop" : post increment (while) + pre decrement (end) => do nothing
        # but "end procedure" : post increment (procedure) + pre decrement (end) => decrement
        # hypothese: only loop are written inline...
        # FIX: could also count occurences
        if do_postinc and do_predec:
            do_postinc = False
        if do_postinc and do_preincpost:
            do_postinc = False

        # unindent code to apply new
        code = re.sub("^\s*","",code)
        if do_postinc:
            content.append(indentchars * level + code + comchars + comment)
            level += 1
            continue
        if do_predec:
            level -= 1
            content.append(indentchars * level + code + comchars + comment)
            continue
        if do_preincpost:
            level -= 1
            content.append(indentchars * level + code + comchars + comment)
            level += 1
            continue

        content.append(indentchars * level + code + comchars + comment)
        if level < 0:
            raise Exception("Adjusting indent level gives negative one. Please report bug !")

    assert level == 0, "Reached the end of file, but indent level is not null (it should)"
    # ok, now we can save the content back to the file
    fout = file(filename,"wb")
    fout.write(os.linesep.join(content) + os.linesep)   # linefeed on last line
    fout.close()

def do_reindent(args):
    try:
        opts, args = getopt.getopt(args, ACTIONS['reindent']['options'])
    except getopt.error,e:
        print >> sys.stderr, "Wrong option or missing argument: %s" % e.opt
        sys.exit(255)

    # default jallib standard
    withchar = " "
    howmany = 3
    try:
        for o,v in opts:
            if o == "-c":
                i,s = v.split("-")
                howmany = int(i)
                if "tab" in s:
                    withchar = "\t"
                elif "space" in s:
                    withchar = " "
                else:
                    withchar = s
    except Exception,e:
        print >> sys.stderr, "Can't understand %s (error: %s)" % (repr(v),e)

    for filename in args:
        reindent_file(filename,withchar,howmany)


#---------------#
# UNITTEST FUNC #
#---------------#

def unittest(filename,verbose=False):
    oracle = {'success' : None, 'failure' : None, 'notrun' : None}
    content = file(filename).read().splitlines()
    fnout = filename + ".stdout"
    fnerr = filename + ".stderr"
    try:
        try:
            fout = file(fnout,"w")
            ferr = file(fnerr,"w")
            status = do_compile([filename],exitonerror=False,clean=False,stdout=fout,stderr=ferr)
            fout.close()
            ferr.close()
        except Exception,e:
            print >> sys.stderr, "Error while compiling file '%s': %s" % (filename,e)
            raise

        if status == 0:
            print "%s compiled, running tests..." % filename

            jal = filename
            asm = filename.replace(".jal",".asm")
            hex = filename.replace(".jal",".hex")
            
            try:
                from picshell.console.picshell_unittest import picshell_unittest
                oracle = picshell_unittest(jal,asm,hex)
            except ImportError,e:
                print >> sys.stderr, "Can't find PICShell libraries. Install PICShell and adjust PYTHONPATH\n%s" % e
                sys.exit(255)
                oracle['failure'] = 1

        else:
            oracle['failure'] = 1

    finally:
        fout = file(fnout)
        ferr = file(fnerr)

        clean_compiler_products(filename)

        if verbose:
            print fout.read()
            print ferr.read()

        fout.close()
        ferr.close()

        os.unlink(fnout)
        os.unlink(fnerr)

    return oracle

def get_testcases(filename):
    content = file(filename).read().splitlines()
    restags = parse_tags(content,"section","testcase")
    return restags

def parse_unittest(filename,run_testcases=[]):
    import tempfile
    restags = get_testcases(filename)

    # build a pseudo board
    pseudoboard = []
    [pseudoboard.extend(l) for k,l in restags['section'].items()]

    # extract each tests, and store them in temporary files
    test_filenames = []
    for testname,testcontent in restags['testcase'].items():
        if run_testcases and not testname in run_testcases:
            continue
        wholetest = merge_board_testfile(pseudoboard,testcontent)
        fileno,filename = tempfile.mkstemp(prefix="jallib_",suffix="_%s.jal" % testname)
        fileobj = os.fdopen(fileno,"w")
        fileobj.write(wholetest)
        fileobj.close()
        test_filenames.append(filename)

    return test_filenames

def do_unittest(args):

    try:
        opts, args = getopt.getopt(args, ACTIONS['unittest']['options'])
    except getopt.error,e:
        print >> sys.stderr, "Wrong option or missing argument: %s" % e.opt
        sys.exit(255)

    # default jallib standard
    list_only = False
    clean_files = True
    verbose = False
    for o,v in opts:
        if o == "-k":
            clean_files = False
        elif o == "-l":
            list_only = True
        elif o == "-v":
            verbose = True

    # args contain a jal file to test, and optionally a list
    # testcase's name to run. If it's a "regular jal" file
    # there's no way to specify which testcase to run, since
    # only one testcase can be declared.
    filename = args[0]
    testcases = args[1:]

    at_least_one_failed = False
    if filename.endswith(".jalt"):
        if list_only:
            restags = get_testcases(filename)
            print "\n".join(restags['testcase'].keys())
        else:
            utests = parse_unittest(filename,testcases)
            for t in utests:
                try:
                    oracle = unittest(t,verbose)
                finally:
                    if clean_files:
                        # clean tmp file !
                        os.unlink(t)
                if oracle['failure'] or oracle['notrun']:
                    at_least_one_failed = True
                print "Test results: %s" % oracle

    # or just a regular file
    else:
        oracle = unittest(filename)
        if oracle['failure'] or oracle['notrun']:
            at_least_one_failed = True
        print "Test results: %s" % oracle

    if at_least_one_failed:
        sys.exit(1)
    else:
        sys.exit(0)


#-------------#
# JALAPI FUNC #
#-------------#

SVN_URL_SAMPLEDIR = "http://code.google.com/p/jallib/source/browse/trunk/sample"

def do_jalapi(args):
    if not has_cheetah:
        print >> sys.stderr, "You can't use this action, because cheetah module is not installed"
        sys.exit(255)

    try:
        opts, args = getopt.getopt(args, ACTIONS['jalapi']['options'])
    except getopt.error,e:
        print >> sys.stderr, "Wrong option or missing argument: %s" % e.opt
        sys.exit(255)

    tmplfile = None
    outfile = None
    singlepage = False
    locallinks = False
    sampledir = None
    svnbaseurl = SVN_URL_SAMPLEDIR
    for o,v in opts:
        if o == "-t":
            tmplfile = v
        elif o == '-s':
            singlepage = True
        elif o == '-l':
            locallinks = True
        elif o == '-d':
            sampledir = v
        elif o == '-g':
            svnbaseurl = v
        elif o == '-o':
            if v == '-':
                outfile = sys.stdout
            else:
                outfile = file(v,"w")
        else:
            print >> sys.stderr, "Wrong option %s" % o

    if not tmplfile:
        print >> sys.stderr, "You must specify a template file with -t option"
        sys.exit(255)
    if not outfile:
        print >> sys.stderr, "You must specify an output filename with -o option"
        sys.exit(255)

    # env.var > arg
    sampledir = os.environ.get('JALLIB_SAMPLEDIR',sampledir)
    if not sampledir:
        print >> sys.stderr, "Specify a sample directory, either with -d option, or JALLIB_SAMPLEDIR environment variable"
        sys.exit(255)

    assert len(args) == 1, "Need one and only one jal file"
    w = args[0]
    def no_device(dir,filename):
        h,tail = os.path.split(dir)
        return tail != "device"

    if os.path.isdir(w):
        dfiles = get_jal_filenames(w,predicate=no_device)
        files = []
        for f,path in sorted(dfiles.items(),cmp=lambda x,y: cmp(x[0],y[0])):
            files.append(os.path.join(w,path))
    else:
        files = [w]

    jalinfos = []
    for jalfile in files:
        api,samples = jalapi_extract(jalfile,sampledir,svnbaseurl,locallinks)
        jalinfos.append((api,samples))

    if singlepage:
        output = jalapi_generate(jalinfos,tmplfile,sampledir,locallinks)
    else:
        api,samples = jalinfos[0]
        output = jalapi_generate({'api' : api, 'samples' : samples},tmplfile,sampledir,locallinks)
    print >> outfile, output.replace("\r","")

def jalapi_extract(jalfile,sampledir,svnbaseurl,locallinks):
    # extract JSG info
    dhead,dproc,dfunc,dvarconst,ddeps = jalapi_extract_doc(jalfile)
    # get samples info using this jal file
    libname,dsamples = jalapi_extract_samples(jalfile,sampledir,svnbaseurl,locallinks)
    return (dhead,dproc,dfunc,dvarconst,ddeps),(libname,dsamples)


def jalapi_extract_samples(jalfile,sampledir,svnbaseurl,locallinks):
    # search samples using this file
    libname = re.sub("\.jal$","",os.path.basename(jalfile))
    def use_lib(dir,sample):
        return libname in find_includes(os.path.join(dir,sample))
    samples = get_jal_filenames(sampledir,predicate=use_lib).values()
    dsamples = {}

    def joinurl(p1,p2):
        return "/".join([p1.rstrip("/"),p2.strip("/")])

    # remove double "/", should use a lib
    # but let's be careful with deps
    samplebase = svnbaseurl
    if locallinks:
        samplebase = sampledir
    for sample in samples:
        # big naming convention here...
        pic = sample.split("_")[0]
        dsamples[(pic,sample)] = joinurl(samplebase,sample)

    return (libname,dsamples)

def jalapi_extract_doc(filename):
    # deals with header
    # jsg wants line number...
    content = [(i + 1,l) for i,l in enumerate(open(filename,"r").readlines())]
    header = extract_header(content)
    dhead = {}
    for field_dict in FIELDS:
        # Special case: when still '--' comment chars,this means new paragraph
        c = validate_field(header,**field_dict)
        c = c and "\n".join(map(lambda c: re.sub("^--","\n\n",c),c.split("\n"))) or c
        dhead[field_dict['field']] = c

    # now deals with procedure/function definitions
    # and global variables/constant
    # get comment above
    content.reverse()
    proc = re.compile("^procedure\s+(.*)\s+is")
    func = re.compile("^function\s+(.*)\s+is")
    var_const = re.compile("^(var|const)")
    include = re.compile("^include\s+(\w+)")
    dfunc = {}
    dproc = {}
    dvarconst = {}
    ddeps = {}
    doc = None
    # re-enumerate with content indexes
    for i,(_,line) in enumerate(content):
        # strip line once matched, else loose ident
        if func.match(line):
            line,doc = jalapi_extract_comments(i,line.strip(),content[i+1:])
            dfunc[func.match(line).groups()[0]] = doc
        if proc.match(line):
            line,doc = jalapi_extract_comments(i,line.strip(),content[i+1:])
            dproc[proc.match(line).groups()[0]] = doc
        if var_const.match(line):
            line,doc = jalapi_extract_comments(i,line.strip(),content[i+1:])
            dvarconst[line] = doc
        if include.match(line):
            dep = include.match(line).groups()[0]
            ddeps[dep] = True

    return (dhead,dproc,dfunc,dvarconst,ddeps)

def jalapi_extract_comments(i,origline,content):
    doc = []
    # this regex is used to detect the end of comments,
    # and remove the comment chars, but also to clean
    # long-dash lines.
    stillcomment = re.compile("^--\s-*")
    for _,line in content:
        if not stillcomment.match(line) or line.strip() == "":
            break
        doc.append(stillcomment.sub("",line))

    # clean potential comments following declaration
    comm = re.compile("--\s?(.*)")
    followdoc = ""
    if comm.findall(origline):
        followdoc = comm.findall(origline)[-1]
        origline = comm.sub("",origline)

    if not doc and followdoc:
        # use potential following comment
        doc.append(followdoc)

    # no comment found
    if not doc:
        print >> sys.stderr, "No documentation found for %s (line %s)" % (repr(origline),i)
        return (origline,None)
    # back to human readable content
    doc.reverse()
    # clean documented line with 
    return (origline,"".join(doc)) or (origline,None)

def jalapi_generate(infos,tmpl_file,sampledir,locallinks):

    # prepare template
    tmplsrc = "".join(file(tmpl_file,"r").readlines())
    klass = Cheetah.Template.Template.compile(tmplsrc)
    tmpl = klass()
    tmpl.locallinks = locallinks
    tmpl.sampledir = sampledir

    if isinstance(infos,pytypes.ListType):
        # tmpl file should be able to handle multiple API infos
        tmpl.infos = infos
        return tmpl.main_singlepage()
    else:
        dhead,dproc,dfunc,dvarconst,ddeps = infos['api']
        libname,dsamples = infos['samples']
        tmpl.dhead = dhead
        tmpl.dproc = dproc
        tmpl.dfunc = dfunc
        tmpl.dvarconst = dvarconst
        tmpl.ddeps = ddeps
        tmpl.libname = libname
        tmpl.dsamples = dsamples

        return tmpl.main()


#-----------#
# LIST FUNC #
#-----------#


def get_library_list(repos=None):
    repos = repos or os.environ.get('JALLIB_REPOS',"")
    gdirs = split_repos(repos)
    # first directories have precedence, so we start by the end
    # and will override as needed
    gdirs.reverse()
    jalfiles = {}
    for gdir in gdirs:
        found = get_jal_filenames(gdir)
        # rebuild complete path
        for fname,path in found.items():
            jalfiles[fname] = os.path.join(gdir,path)

    return jalfiles

def do_list(_trash):
    jalfiles = get_library_list()
    # sort on filename (not using path)
    for jalfile in sorted(jalfiles.items(),cmp=lambda a,b: cmp(a[0],b[0])):
        print jalfile[1]


#----------#
# API FUNC #
#----------#
# Extract some API informations (const, var, proc, func,...)
# Can be used in IDE

VALID_IDENTIFIER = "a-z0-9_"
COMMENT_RE = re.compile("((--)|;).*")

VAR_RE = re.compile("var\s+(volatile\s*)?([%s\*]+)\s+([%s]+)(\s*\[.*\])?\s*=?" % (VALID_IDENTIFIER,VALID_IDENTIFIER),re.IGNORECASE)
CONST_RE = re.compile("const\s+([%s]+\s+)?([%s]+)\s*(\[.*\])?\s*=" % (VALID_IDENTIFIER,VALID_IDENTIFIER),re.IGNORECASE)
ALIAS_RE = re.compile("alias\s+([%s]+)\s+is\s+([%s]+)" % (VALID_IDENTIFIER,VALID_IDENTIFIER),re.IGNORECASE)
PROC_RE = re.compile("procedure\s+([%s]+)\s*\((.*)\)\s+is" % VALID_IDENTIFIER,re.IGNORECASE) # FIX: signature can be on multine
PSEU_RE = re.compile("(procedure|function)\s+([%s]+)'(put|get)\s*(\(.*\))?\s*(return\s*.*)?\s+is" % VALID_IDENTIFIER,re.IGNORECASE)
FUNC_RE = re.compile("function\s+([%s]+)\s*\((.*)\)\s+return\s+([%s]+)\s+is" % (VALID_IDENTIFIER,VALID_IDENTIFIER),re.IGNORECASE)
SIGN_RE = re.compile("(bit|byte|sbyte|word|sword|dword|sdword)\s+(in|out|in out)\s+([%s]+),?" % VALID_IDENTIFIER,re.IGNORECASE)
INCL_RE = re.compile("include\s+([%s]+)" % VALID_IDENTIFIER)

# in addition to func/proc, this will make detection out of global scope
# thus not considered in API description (we only want real global var/const/...)
BLOCK_RE = re.compile("(.*\s+)?block",re.IGNORECASE)
CASE_RE = re.compile("case\s+.*\s+of",re.IGNORECASE)
FOR_RE = re.compile("for\s*.*\s+loop",re.IGNORECASE)
FOREVER_RE = re.compile("forever\s+loop",re.IGNORECASE)
IF_RE = re.compile("if\s*.*(\s+then)?",re.IGNORECASE)
REPEAT_RE = re.compile("repeat",re.IGNORECASE)
WHILE_RE = re.compile("while\s*.*(\s+loop)?",re.IGNORECASE)
level_up = [BLOCK_RE,CASE_RE,FOR_RE,FOREVER_RE,IF_RE,REPEAT_RE,WHILE_RE,PROC_RE,FUNC_RE,PSEU_RE]
#
END_PROC = re.compile("end\s+procedure",re.IGNORECASE)
END_FUNC = re.compile("end\s+function",re.IGNORECASE)
END_FOR = re.compile("end\s+loop",re.IGNORECASE)
END_BLOCK = re.compile("end\s+block",re.IGNORECASE)
END_CASE = re.compile("end\s+case",re.IGNORECASE)
END_IF = re.compile("end\s+if",re.IGNORECASE)
END_REPEAT = re.compile("until\s+.*",re.IGNORECASE)
level_down = [END_PROC,END_FUNC,END_FOR,END_BLOCK,END_CASE,END_IF,END_REPEAT]
# inline structure
INLINE_WHILE_RE = re.compile("while\s*.*\s+end\s+loop",re.IGNORECASE)
INLINE_IF_RE = re.compile("if\s*.*\s+then\s+.*\s+end\s+if",re.IGNORECASE)
level_keep = [INLINE_WHILE_RE,INLINE_IF_RE]

class APIParsingError(Exception): pass

def api_parse_content(lines,strict=True):

    def get_params(signature):
        params = SIGN_RE.findall(signature)
        dsign = []
        for param in params:
            dsign.append({'type' : param[0], 'context' : param[1], 'name' : param[2]})
        return dsign
    
    desc = {"include" : {}, "procedure" : {}, "function" : {},
            "var" : {}, "const" : {}, 'alias' : {}, 'pseudovar' : {}}
    level = 0
    for num,content in enumerate(lines):
        content = content.strip()
        # clean comments
        content = COMMENT_RE.sub("",content)
        if level == 0:
            if VAR_RE.match(content):
                _,type,name,arr = VAR_RE.match(content).groups()
                desc['var'][name] =  {'type' : type, 'name' : name, 'line' : num}#, 'content' : content}
            elif CONST_RE.match(content):
                type,name,arr = CONST_RE.match(content).groups()
                desc['const'][name] = {'type' : type, 'name' : name, 'line' : num}#, 'content' : content}
            elif ALIAS_RE.match(content):
                alias, source = ALIAS_RE.match(content).groups()
                desc['alias'][alias] = {'name' : alias, 'source' : source, 'line' : num}#, 'content' : content}
            elif PSEU_RE.match(content):
                _,name,_,_,_ = PSEU_RE.match(content).groups()
                # line won't be accurate, as we only keep the last pseudovar def, that is either 'put or 'get
                desc['pseudovar'][name] = {'name' : name, 'line' : num}

        # because of conditional compile, we consider every include/proc/func, even those nested
        if INCL_RE.match(content):
            lib = INCL_RE.match(content).groups()[0]
            desc['include'][lib] = {'name' : lib, 'line' : num}
        elif PROC_RE.match(content):
            name,signature = PROC_RE.match(content).groups()
            params = get_params(signature)
            desc['procedure'][name] = {'name' : name, 'params' : params, 'line' : num}
        elif FUNC_RE.match(content):
            name,signature,rettype = FUNC_RE.match(content).groups()
            params = get_params(signature)
            desc['function'][name] = {'name' : name, 'params' : params, 'return' : rettype, 'line' : num}

        if [matching for matching in level_keep if matching.match(content)]:
            ##print >> sys.stderr, "content KEEP (%s): %s " % (level,repr(content))
            # trap
            pass
        # catch closing level RE before (so "end block" won't match "block")
        elif [matching for matching in level_down if matching.match(content)]:
            level -= 1
            ##print >> sys.stderr, "content DOWN (%s): %s" % (level,repr(content))
        elif [matching for matching in level_up if matching.match(content)]:
            level += 1
            ##print >> sys.stderr, "content UP   (%s): %s " % (level,repr(content))

    if strict and level != 0:
        raise APIParsingError("Should reach level 0 when done parsing (level is %s)" % level)

    # normalize: replace {} used to keep things unique by real list
    final = {}.fromkeys(desc)
    for k,v in desc.items():
        final[k] = v.values()

    return final


def api_parse(filenames,filelist=[]):

    apis = {}
    for filename in filenames + filelist:
        if filename == "-":
            lines = sys.stdin.readlines()
        else:
            lines = file(filename).readlines()

        basefn = os.path.basename(filename)
        apis[basefn] = api_parse_content(lines,strict=False)

    return apis
    
def api2xml(py,elem=None,doc=None,libname=None):
    import xml.dom.minidom as minidom
    if not doc:
        doc = minidom.Document()
        elem = doc.appendChild(doc.createElement("api"))
        elem.setAttribute("name",libname.replace(".jal",""))
    if isinstance(py,pytypes.DictType):
        for k,v in py.items():
            node = doc.createElement(k)
            elem.appendChild(node)
            api2xml(v,node,doc)
    if isinstance(py,pytypes.ListType):
        for val in py:
            node = doc.createElement("element")
            elem.appendChild(node)
            api2xml(val,node,doc)
    if isinstance(py,pytypes.StringType) or isinstance(py,pytypes.IntType):
        elem.setAttribute("value",str(py))
    
    return doc

def api2json(py):
    import simplejson
    return simplejson.dumps(py)

def api2pickle(py):
    import cPickle
    return cPickle.dumps(py)

def do_api(args):
    try:
        opts, args = getopt.getopt(args, ACTIONS['api']['options'])
    except getopt.error,e:
        print >> sys.stderr, "Wrong option or missing argument: %s" % e.opt
        sys.exit(255)

    # now args contain jal file

    outxml = False
    outjson = False
    outpystr = False
    outpickl = False
    outfile = sys.stdout
    filelist = []
    input = None
    for o,v in opts:
        if o == "-x":
            outxml = True
        elif o == '-j':
            outjson = True
        elif o == '-p':
            outpystr = True
        elif o == '-k':
            outpickl = True
        elif o == '-o':
            outfile = file(v,"w")
        elif o == '-l':
            filelist = [f.strip() for f in file(v).readlines()]
        else:
            print >> sys.stderr, "Wrong option %s" % o

    if not args and not filelist:
        print >> sys.stderr, "You must specify a JAL file as input (last argument) or a file list (-l option)"

        sys.exit(255)

    pydesc = api_parse(args,filelist)
    if outxml:
        doc = api2xml(pydesc,libname=os.path.basename(args[0]))
        outfile.write(doc.toprettyxml())
    elif outjson:
        json = api2json(pydesc)
        outfile.write(json)
    elif outpickl:
        pickl = api2pickle(pydesc)
        outfile.write(pickl)
    else:
        import pprint
        outfile.write(pprint.pformat(pydesc) + "\n")

#--------------#
# MONITOR FUNC #
#--------------#
# Parse and compare compiler output. Used 
# to monitor and compare different parameters
# (ram, program, stack,...) accross different 
# program or compiler versions

METRIC_KEYS = ["compiler_path","compiler_version","tokens","chars","lines","files",\
               "code_area_used","code_area_avail","data_area_used","data_area_avail",\
               "soft_stack_avail","soft_stack_used","soft_stack_avail","filename"]

def parse_compiler_output(out,err="",compiler=None,filename=None):
    dout = dict(zip(METRIC_KEYS,[None] * len(METRIC_KEYS)))
    dout["compiler_path"] = compiler
    dout["filename"] = filename
    outs = out.splitlines()
    for l in outs:
        if l.startswith("jal 2."):
            dout["compiler_version"] = l  # ex: "jal 2.4o (compiled Mar  6 2011)"
        elif "tokens" in l:
            toks = l.split()        # ex: "1410 tokens, 188860 chars; 4536 lines; 15 files"
            dout["tokens"] = int(toks[0])
            dout["chars"] = int(toks[2])
            dout["lines"] = int(toks[4])
            dout["files"] = int(toks[6])
        elif l.startswith("Code area"):
            ca = l.split()                # ex: "Code area: 3174 of 32768 used (bytes)"
            dout["code_area_used"] = int(ca[2])
            dout["code_area_avail"] = int(ca[4])
        elif l.startswith("Data area"):
            da = l.split()
            dout["data_area_used"] = int(da[2])
            dout["data_area_avail"] = int(da[4])
        elif l.startswith("Software stack"):
            sw = l.split()                # ex: "Software stack available: 838 bytes"
            dout["soft_stack_avail"] = int(sw[3])
        elif l.startswith("Hardware stack"):
            hw = l.split()                # ex: "Hardware stack depth 2 of 31"
            dout["soft_stack_used"] = int(hw[3])
            dout["soft_stack_avail"] = int(hw[5])
            
    return dout

def compare_compiler_outputs(douts):
    # assuming all dicts are structured the same...
    # map on array
    array = {}
    filenames = [dout["filename"] for dout in douts]
    for k in METRIC_KEYS:
        array[k] = [dout[k] for dout in douts]

    return array

def monitor_display_human(results):
    print
    print " " * 20,
    nelem = len(results["filename"])
    for x in range(nelem):
        print "%35s" % results["filename"][x],
    print
    print
    for param in METRIC_KEYS: 
        if param == "filename":
            continue
        print "%20s" % param,
        for x in range(nelem):
            print "%35s" % results[param][x],
        print

def monitor_display_csv(results):
    nelem = len(results["filename"])
    print ",",  # placeholder for param column
    for x in range(nelem):
        print "%s," % results["filename"][x],
    print
    for param in METRIC_KEYS: 
        if param == "filename":
            continue
        print "%s," % param,
        for x in range(nelem):
            print "%s," % results[param][x],
        print
 
def do_monitor(args):

    try:
        opts, args = getopt.getopt(args, ACTIONS['monitor']['options'])
    except getopt.error,e:
        print >> sys.stderr, "Wrong option or missing argument: %s" % e.opt
        sys.exit(255)

    list_only = False
    clean_files = True
    verbose = False
    output_format = ""
    for o,v in opts:
        if o == "-f":
            output_format = v

    # args contain a jal file to test, and optionally a list
    # testcase's name to run. If it's a "regular jal" file
    # there's no way to specify which testcase to run, since
    # only one testcase can be declared.
    compiler_and_repos_and_filenames = args

    douts = []
    for num,compiler_and_repos_and_filename in enumerate(compiler_and_repos_and_filenames):
        compiler = None
        repos = None

        try:
            # extract filename and compiler+repos
            compiler_and_repos,filename = compiler_and_repos_and_filename.split(":")

            # extract compiler and repos
            try:
                compiler,repos = compiler_and_repos.split(",")
            except ValueError:
                compiler = compiler_and_repos

        except ValueError:
            # no compiler specified
            filename = compiler_and_repos_and_filename



        args = []
        if compiler:
            args.extend(["-E",compiler])
        if repos:
             args.extend(["-R",repos])
        args.append(filename)

        fnout = filename + ".stdout"
        fnerr = filename + ".stderr"
        fout = file(fnout,"w")
        ferr = file(fnerr,"w")
        try:
            status = do_compile(args,exitonerror=False,clean=False,stdout=fout,stderr=ferr)
            output = file(fnout).read()
            errput = file(fnerr).read()
            try:
                dout = parse_compiler_output(output,compiler=compiler,filename=filename)
                douts.append(dout)
            except IndexError,e:
                import traceback
                print >> sys.stderr, traceback.format_exc()
                sys.exit(1)
        finally:
            os.unlink(fnout)
            os.unlink(fnerr)

    res = compare_compiler_outputs(douts)

    # dispatch displayer
    displayer = {"human" : monitor_display_human,
                 "csv" : monitor_display_csv}
    displayer.get(output_format,displayer["human"])(res)

    sys.exit(0)

#############
# HELP FUNC #
#############

def generic_help():
    print """
jallib wrapper script (revision: $Revision$)
Actions:
    - compile  : compile the given file, expanding one or more root
                 directories containing libraries
    - validate : validate the given file, according to Jallib Style Guide (JSG)
    - sample   : generate samples from board and test files
    - reindent : re-indent jal code
    - api      : generate API description from jal file
    - jalapi   : generate HTML documentation from jal files
    - list     : list all JAL libraries found in JALLIB_REPOS, as resolved by compiler
    - license  : display license

Use 'help' with each action for more (eg. "jallib help compile")

http://jallib.googlecode.com
"""

def do_license(_trash):
    print """
http://jallib.googlecode.com
Released under the BSD license

"""
    if deps:
        print """
"jallib" binary executables are bundled with several libraries,
please refer to them for their respective licenses:
"""
        for t in deps:
            print "    - %s (%s)" % (t[0],t[2])

def compile_help():
    print """
    jallib compile file.jal

Use this option to actually compile the given file. This script
will the -s option of jalv2 compiler, to build an appropriate
command line. When using libs from SVN, libs are organized within a
directory hierarchy. Every sub-directories will then be explored so
all are included in the command line (except hidden dir, starting with '.').

All arguments given to this action will be passed to the jalv2 compiler
(so please, do not pass any -s option...). Also be aware the 'jalv2'
executable must be declare in the path (PATH) by default.

Additional options:

    -R path1[;path2[;path3]...] : use this option to specify one or more
                                  root path to jallib directories. Directory
                                  paths are seperated using ';' char. If no
                                  option is given, this script will also
                                  look at a JALLIB_REPOS environment variable.
                                  If no variable is set, then this script
                                  will consider the current path (cwd) as
                                  the root path.
                                  Precedence: cwd < var < option

    -E path    : use this option to manually set the path to jalv2 executable.
                 If not set, will search for a JALLIB_JALV2 environment
                 variable, or default to 'jalv2' and expect it to be on path.

(for convenience, jallib script's options are uppercased, whereas jalv2's
are lowercased)

"""

def validate_help():
    print """
    jallib validate file.jal [another_file.jal yet_anoter_file.jal ...]

Use this option to validate (or not...) your file against
the Jallib Style Guide (JSG). Not all rules are checked, so
while validating a file, please manually have a look to it too !

See: http://code.google.com/p/jallib/wiki/JallibStyleGuide for more
"""

def reindent_help():
    print """
    jallib reindent [-c <indent-rule>] file.jal [anotherfile.jal ...]

Reindent the given jal file, and save it back to the same file.
Optionally can pass a indent rule (by default, if not specified, 3-spaces
indentation will occur). The form is:

    <number>-<char>

with special cases for space and tab chars (for convenience). Examples:

 - indented with 3 spaces: "-c 3-spaces" (or "-c 3-space", no plural)
 - indented with 1 tab: "-c 1-tab"
 - remove indentation: "-c 0-space"
 - indent with "XXXX" (hey contrived example !): "-c 4-X"

"""

def unittest_help():
    print """
    jallib test file.jal [file.jal]

Run test file and produce results.

  -k: keep jal files generated from jal test files (jalt)
       (careful, there can be many)
  -v: verbose, shows compiler output, ...
  -l: list only testcases, don't run them


Takes a jal file, or
a test file (*.jalt extention). The differences are test files contain several
tests, several sections, which are assembled on the fly
(something like board/test files producing samples)

Tests is done using PICShell unittesting facilities. Several actions can be checked:

  - @assertEquals: will check a variable against a value (from PICShell).

"""

###  - @assertWarning: will check given text will appear as a warning during
###                    compilation (from jallib)
###  - @assertError: same as @assertWarning but for an error


def jalapi_help():
    print """
    jallib jalapi [-l|-s] [-d path/to/sample] -t template.tmpl
                  -o output_file.html one_file.jal|one_dir

Takes a jal library file as *last* argument and parse/extract JSG headers
and procedure/function comments to generate an HTML page (jal file must be
JSG compliant).

Alternatively, it can take a directory as parameter: all jal files
contained in this directory (and recursively in all sub-dirs) will be
considered to generate html. It also searches for samples using this
library, and produces link to them.

    -t : specifies the template to use to generate HTML
    -s : produces a single HTML page (useful combined with directory passed
         as parameter)
    -l : build local link (default is to point to Google Code SVN repository)
    -d : specifies the directory containing samples (if not set, expected to be
         found in JALLIB_SAMPLEDIR environment variable
    -g : specifies the Google Code SVN base URL containing samples, to build
         links to samples (ignored if -l is set).
         Default: http://code.google.com/p/jallib/source/browse/trunk/sample
    -o : specifies which file to write HTML documentation to (use "-o -" to
         on stdout)

"""

def sample_help():
   print """
   jallib sample [-a path/to/sample | -b boardfile -t testfile -o output]

Generate samples from board files and test files. In order to do this,
the board and test files are annotated with special "@jallib" tags.

You can either generate all potential samples from all board and all test
files (using -a option), or generate all potential samples for a given
board (using -a and -b options), and specifically generate one sample,
from one board file and one test file (using -b, -t and -o options).

    -a: analyse available board and test files, try to combine them,
        try to compile them. If it's a success, write the generated sample
        on "sample" map, or in the directory specified by -o option
    -b: specify a board file. Can be used in combination with -a option.
        if -o is also specified, then this is considered as the output
        directory where generated samples will be stored. Without -o,
        samples will be stored in "sample" map
    -t: specify a test file
    -o: specify the output sample filename, or the output directory
        when used in combination with -a option

"""

def list_help():
    print """
    jallib list

List JAL libraries found according to JALLIB_REPOS variable.
JALLIB_REPOS represents the root(s) from which *.jal files are
search, recursively. If multiple repositories are specified, first
have precedence. So listing libraries also take into account this 
precedence rule.

Output contains one line per library.

"""

def api_help():
    print """
    jallib api [-x|-j|-p] [-o output] ([-l flist|-] | (-|f1.jal f2.jal ...)) 

Takes a JAL file (or read stdin if "-" is specified), parses and
extracts API information about const, var, procedure, function,
include, ...

If -l option is specified, a list of file is taken as input (a real file,
or read from stdin. If jal files are also passed through the commandline,
they'll be considered in addition to the file list.

Several output formats are supported:

    -x: XML format
    -j: JSON format (requires simplejson library)
    -k: pickle format (using python cPickle)
    -p: python string (can be used by eval'ing it) -- default

If -o option is specified, output is written in a file, else written
on stdout.

"""


def monitor_help():
    print """
    jallib monitor [-f format] [compiler1[,repos1]:]file1.jal [compiler2[,repos2]:]file2.jal [...]

Compiles file1.jal using compiler1 binary against lib repository repos1, 
file2.jal using compiler2 binary  against lib repository repos2, etc...
and display output results and comparisons. 

"compiler" is a path to a jalv2 compiler binary. If not specified,
it assumes "jalv2" is available on PATH.

"repos" is a path to a directory containing jal libraries used to compile
given file. Explored recursively. Same meaning as -R option of action "compile".

"format" specifies how results are display. Available values are:
    - human : displays a table readable by mere mortals (default)
    - csv : outputs results as a CSV file, comma seperated
"""

def do_help(action_args=[]):
    action = None
    if action_args:
        action = action_args[0]
    if not action:
        generic_help()
    else:
        ACTIONS[action]['help']()


# Main action registry
ACTIONS = {
        'compile'   : {'callback' : do_compile,  'options' : 'R:E:',       'help' : compile_help},
        'validate'  : {'callback' : do_validate, 'options' : '',           'help' : validate_help},
        'list'      : {'callback' : do_list,     'options' : '',           'help' : list_help},
        'api'       : {'callback' : do_api,      'options' : 'xjkpo:l:',   'help' : api_help},
        'jalapi'    : {'callback' : do_jalapi,   'options' : 'slt:d:g:o:', 'help' : jalapi_help},
        'sample'    : {'callback' : do_sample,   'options' : 'a:b:t:o:',   'help' : sample_help},
        'reindent'  : {'callback' : do_reindent, 'options' : 'c:',         'help' : reindent_help},
        'unittest'  : {'callback' : do_unittest, 'options' : 'kvl',        'help' : unittest_help},
        'monitor'   : {'callback' : do_monitor,  'options' : 'f:',         'help' : monitor_help},
        'help'      : {'callback' : do_help,     'options' : '',           'help' : None},
        'license'   : {'callback' : do_license,  'options' : '',           'help' : None},
        }


if __name__ == "__main__":
    try:
        # First extract the action, then parse action's args
        action = sys.argv[1]
        action_args = sys.argv[2:]
        try:
            callme = ACTIONS[action]['callback']
        except KeyError,e:
            if action in ('help','--help','-h'):
                do_help(action_args)
                sys.exit(0)
            else:
                print >> sys.stderr, "Unknown action %s" % e
                sys.exit(255)
        callme(action_args)
    except IndexError,e:
        print >> sys.stderr, "Please provide an action: %s" % repr(ACTIONS.keys())
        sys.exit(255)
