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

try:
    import picshell.engine.core.PicEngine
    has_picshell = True
except ImportError:
    has_picshell = False


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

def get_full_sample_path(sample_dir,pic="",sample=""):
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
            ###print >> sys.stderr, "Cleaning %s" % toclean
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
    dirs = None
    for o,v in opts:
        if o == '-R':
            dirs = []
            gdirs = v.split(";")
            for d in gdirs:
                dirs.extend(_explore_dir(d))
        elif o == '-E':
            jalv2_exec = v
        else:
            print >> sys.stderr, "Wrong option %s" % o
    # No root specified ? Try env var, else defaut to cwd
    if not dirs:
        v = os.environ.get('JALLIB_REPOS',os.path.curdir)
        gdirs = v.split(";")
        for d in gdirs:
            dirs = _explore_dir(d)
    # No exec specify, try env var or defaulting
    if not jalv2_exec:
        jalv2_exec = os.environ.get('JALLIB_JALV2','jalv2').split()
    cmd = jalv2_exec + ["-s",";".join(dirs)]
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

JALLIB = """^-- This file is part of jallib\s+\(http://jallib.googlecode.com\)"""
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
        print >> sys.stderr, "\tERROR: %s" % err
    print >> sys.stderr
    print >> sys.stderr, "%d warnings found" % len(warnings)
    for warn in warnings:
        print >> sys.stderr, "\twarning: %s" % warn

    if errors or warnings:
        return True


def do_validate(args):
    # No jallib args (yet!) for validating
    # args contain jal file to validate

    global errors
    global warnings
    at_least_one_failed = False
    for filename in args:
        validate(filename)
        if report(filename):
            at_least_one_failed = True
        errors = []
        warnings = []

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
        fullsamplepath = outdir and os.path.join(outdir,samplename) or get_full_sample_path(path_to_sample,picname,samplename)
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
    fout = file(filename,"w")
    print >> fout, os.linesep.join(content)
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


#-------------#
# JALAPI FUNC #
#-------------#

def picshell_unittest(jalFileName,asmFileName,hexFileName):

    if not has_picshell:
        print >> sys.stderr, "Can't find PICShell libraries. Install PICShell and adjust PYTHONPATH"
        sys.exit(255)

    # This piece of code is loosely based on PICShell implementation.
    # This is a quick & dirty assembling :)

    from picshell.parser.JalV2AsmParser import JalV2AsmParser
    from picshell.parser.AnnotationParser import AnnotationParser
    from picshell.engine.core.PicThreadEngine import PicThreadEngine
    from picshell.engine.core.PicEngine import PicEngine
    from picshell.engine.core.State import State
    from picshell.util.AssertUtil import AssertUtil

    from picshell.ui.UIManager import UIManager

    asmParser = JalV2AsmParser()
    wholeCode = asmParser.parseAsmFile(asmFileName, [])
    varTypeDict = JalV2AsmParser.buildVarTypeDict(wholeCode)

    parseRes = AnnotationParser.parse(file(jalFileName).read())
    noDebugList = parseRes["noDebug"]
    debugList = parseRes["debug"]
    langParser = JalV2AsmParser()
    code = langParser.parseAsmFile(asmFileName, noDebugList,debugList)

    def unittest_callback(address,oracle):
        line = langParser.adrToLine[address]
        if line != None:
            txt = code[line].line
            if "@assertEquals" in txt:
                res = AssertUtil.parse(txt)
                var = res["var"].lower()
                label = res["label"]
                ref = res["ref"]
                if (langParser.varAdrMapping.has_key("v_"+str(var))):
                    varAddr = langParser.varAdrMapping["v_"+str(var)]
                    varType = type = varTypeDict.get(var,'bit')
                    val = ui.varValue(varAddr,varType)
                    res= varType+" "+var+" (@"+str(varAddr)+") = 0x%X , expected : 0x%X" %(val,ref)

                    print label,
                    if (ref == val) :
                        oracle['success'] += 1
                        print ": OK"
                    else :
                        oracle['failure'] += 1
                        print ": FAIL, %s != %s" % (ref,val)
                else:
                    oracle['notrun'] += 1
                    print "Can't run test '%s' because var '%s' can't be found" % (label,var)

    emu = PicEngine.newInstance(State(),hexFileName)
    # needed to access varValue function
    ui = UIManager()
    ui.emu = emu

    #         success failure notrun
    oracle = {'success' : 0, 'failure' : 0, 'notrun' : 0}
    def run(to,emu,unittest_callback):
        current_address = emu.runNext()
        while current_address != to:
            #unit testing ?
            if unittest_callback != None:
                unittest_callback(current_address,oracle)
            current_address = emu.runNext()
        # last call on finishing address
        unittest_callback(current_address,oracle)

    run(emu.lastAddress,emu,unittest_callback)

    return oracle

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
        except Exception,e:
            print >> sys.stderr, "Error while compiling file '%s': %s" % (filename,e)
            raise

        if status == 0:
            print "%s compiled, running tests..." % filename

            jal = filename
            asm = filename.replace(".jal",".asm")
            hex = filename.replace(".jal",".hex")
            oracle = picshell_unittest(jal,asm,hex)
        else:
            oracle['failure'] = 1

    finally:
        clean_compiler_products(filename)
        if verbose:
            print file(fnout).read()
            print file(fnerr).read()
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
                if oracle['failure']:
                    at_least_one_failed = True
                print "Test results: %s" % oracle

    # or just a regular file
    else:
        oracle = unittest(filename)
        if oracle['failure']:
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
    print >> outfile, output

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
            doc = jalapi_extract_comments(i,line.strip(),content[i+1:])
            dfunc[func.match(line).groups()[0]] = doc
        if proc.match(line):
            doc = jalapi_extract_comments(i,line.strip(),content[i+1:])
            dproc[proc.match(line).groups()[0]] = doc
        if var_const.match(line):
            doc = jalapi_extract_comments(i,line.strip(),content[i+1:])
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
    # no comment found
    if not doc:
        print >> sys.stderr, "No documentation found for %s (line %s)" % (repr(origline),i)
        return None
    # back to human readable content
    doc.reverse()
    return "".join(doc) or None

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
    - jalapi   : generate HTML documentation from jal files
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

Tests is done using PICShell unittesting facilities. PIC 18F aren't
supported. Several actions can be checked:

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
    -o : specifies which file to write HMLT documentation to (use "-o -" to
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
        'jalapi'    : {'callback' : do_jalapi,   'options' : 'slt:d:g:o:', 'help' : jalapi_help},
        'sample'    : {'callback' : do_sample,   'options' : 'a:b:t:o:',   'help' : sample_help},
        'reindent'  : {'callback' : do_reindent, 'options' : 'c:',         'help' : reindent_help},
        'unittest'  : {'callback' : do_unittest, 'options' : 'kvl',        'help' : unittest_help},
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
