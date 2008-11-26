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
   ('yaml','test','http://pyyaml.org/wiki/PyYAML'),
   ('pysvn','jalapi,test','http://pysvn.tigris.org/'),
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

# Disable action when can't import deps
try:
	import yaml
	has_yaml = True
except ImportError:
	has_yaml = False

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
	import pysvn
	has_pysvn = True
except ImportError:
	has_pysvn = False


#########
# TOOLS #
#########

def get_jal_filenames(dir,subdir=None):
	jalfiles = {}
	if os.path.isfile(dir):
		return {dir:dir}
	for df in os.listdir(dir):
		if df.startswith("."):
			continue
		fulldf = os.path.join(dir,df)
		halfdf = os.path.join(subdir and subdir or "",df)
		if os.path.isfile(fulldf) and fulldf.endswith(".jal"):
			jalfiles[df] = halfdf
		elif os.path.isdir(fulldf):
			jalfiles.update(get_jal_filenames(fulldf,subdir=os.path.join(subdir and subdir or "",df)))
	return jalfiles

def get_full_sample_path(sample_dir,pic="",sample=""):
	return os.path.join(sample_dir,"by_device",pic,sample)


# cache found files
explored_tests = None
def get_full_test_path(sample_dir,test=""):
	global explored_tests
	testdir = os.path.join(sample_dir,"test")
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
	return os.path.join(sample_dir,"test","board",board)
	

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


def do_compile(args,exitonerror=True):
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
		jalv2_exec = os.environ.get('JALLIB_JALV2','jalv2')
	cmd = [jalv2_exec,"-s",";".join(dirs)]
	# Complete with compiler args
	if args:
		cmd.extend(args)
	try:
		status = subprocess.check_call(cmd,shell=False)
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
	return re.match("^(>|<|>=|<=|=)\d+(\.\d+\w*)+\s+$",val)

JALLIB = """^-- This file is part of jallib\s+\(http://jallib.googlecode.com\)"""
LICENSE = """^-- Released under the BSD license\s+\(http://www.opensource.org/licenses/bsd-license.php\)"""
LICENSE2 = """^-- Released under the ZLIB license\s+\(http://www.opensource.org/licenses/zlib-license.html\)"""

# exceptions while checking case
ALLOWED_MIXED_CASE = """.*(pin|port|tris|option|ancon).*"""

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
		
	weird = {}	# stores all errors
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


#------#
# TEST #
#------#

def do_test(args):

	if not has_yaml:
		print >> sys.stderr, "You can't use this action, because yaml is not installed"
		sys.exit(255)

	try:
		opts, args = getopt.getopt(args, ACTIONS['test']['options'])
	except getopt.error,e:
		print >> sys.stderr, "Wrong option or missing argument: %s" % e.opt
		sys.exit(255)
	
	do_update = False
	do_prune = False
	do_generate = False
	do_add = False
	do_delete = False
	do_html = False
	do_print = False
	do_merge = False
	got_html = False
	sample_dir = None
	test_str = None
	tmpl_file = None
	tmpl_file_pic = None
	html_file = None
	pic = None
	outfile = None
	only_tested = False
	each_pic_tmpl = None
	selected_pics = None
	sub_matrix = None
	for o,v in opts:
		if o == '-u':
			do_update = True
		elif o == '-e':
			do_prune = True
		elif o == '-a':
			do_add = True
			test_str = v
		elif o == '-d':
			do_delete = True
			test_str = v
		elif o == '-s':
			sample_dir = v
		elif o == '-f':
			outfile = v
		elif o == '-G':
			do_html = True
			tmpl_file = v
		elif o == '-g':
			do_html = True
			tmpl_file_pic = v
		elif o == '-o':
			got_html = True
			html_file = v
		elif o == '-p':
			do_print = True
			pic = v
		elif o == '-1':
			only_tested = True
		elif o == '-t':
			each_pic_tmpl = v
		elif o == '-n':
			selected_pics = v.split(",")
		elif o == '-m':
			do_merge = True
			sub_matrix = v
		else:
			print >> sys.stderr, "Don't know what to do with option %s" % o
	if not outfile:
		try:
			outfile = os.environ['JALLIB_MATRIX']
		except KeyError:
			print >> sys.stderr,"Please provide a file to get/store the testing matrix\n(-f option or JALLIB_MATRIX env. var)"
			sys.exit(255)
	if not sample_dir:
		sample_dir = os.environ.get('JALLIB_SAMPLEDIR',os.path.curdir)
	if do_update:
		update_testing_matrix(sample_dir,outfile,selected_pics)
	elif do_prune:
		prune_testing_matrix(sample_dir,outfile,selected_pics)
	elif do_add:
		add_update_test(test_str,outfile,sample_dir)
	elif do_delete:
		delete_test(test_str,outfile)
	elif do_merge:
		merge_matrix(outfile,sub_matrix)
	elif do_html:
		if not got_html:
			html_file = ".".join(tmpl_file.split(".")[:-1]) + ".html"
		generate_html(tmpl_file,tmpl_file_pic,html_file,outfile,sample_dir,only_tested,each_pic_tmpl)
	elif do_print:
		display_test_results(pic,outfile)
	else:
		print >> sys.stderr, "Error while parsing arguments. 'jallib help' for more"
		sys.exit(255)

def get_matrix(outfile):
	# localized import: if one doesn't want to deal
	# with test, don't force him to install yaml lib
	
	# existing file or from scratch ?
	if os.path.isfile(outfile):
		matrix = yaml.load(file(outfile).read())
	else:
		matrix = {}
	return matrix

def save_matrix(matrix,outfile):
	fout = file(outfile,"w")
	print >> fout, yaml.dump(matrix)
	fout.close()
	
def update_testing_matrix(sample_dir,outfile,selected_pics=[]):

	matrix = get_matrix(outfile)

	def analyze_samples(device,fullpathdir):
		content = os.listdir(fullpathdir)
		for jalfile in content:
			if jalfile.startswith(".") or not jalfile.endswith(".jal"):
				continue
			matrix[device]['samples'].setdefault(jalfile,{'pass' : None, 'revision' : None})

	def analyse_sampledir(dir):
		if not "by_device" in os.listdir(dir):
			print >> sys.stderr, "Sample dir '%s' does not contain 'by_device' map." % dir
			sys.exit(1)
		for devicedir in os.listdir(get_full_sample_path(dir)):
			if selected_pics and not devicedir in selected_pics:
				# skip, not wanted by user
				continue
			fullpath = get_full_sample_path(dir,devicedir)
			if not os.path.isdir(fullpath) or devicedir.startswith("."):
				continue
			matrix.setdefault(devicedir,{'samples' : {}, 'tests' : {}})
			analyze_samples(devicedir,fullpath)

	def analyse_testdir(dir):
		if not "test" in os.listdir(dir):
			print >> sys.stderr, "Sample dir '%s' does not contain 'test' map." % dir
			sys.exit(1)
		if not "board" in os.listdir(os.path.join(dir,"test")):
			print >> sys.stderr, "Sample dir '%s' does not contain 'board' map." % os.path.join(dir,"test")
			sys.exit(1)
		# Get ALL test files
		testdir = get_full_test_path(dir)
		tdirs = [(d,os.path.join(testdir,d)) for d in os.listdir(testdir) if not d.startswith(".") and d != "board"]
		test_files = {}
		for (subdir,tdir) in tdirs:
			test_files.update(get_jal_filenames(tdir,subdir)) ## if f.startswith("test_")])
		# analyse board files, so pic can be deduced
		boarddir = get_full_board_path(dir)
		for boardfile in os.listdir(boarddir):
			if not boardfile.endswith(".jal"):
				continue
			try:
				pic = re.match("board_(.*)_.*\.jal",boardfile).groups()[0]
				if selected_pics and not pic in selected_pics:
					# skip it, not wanted by user
					continue
			except Exception,e:
				print >> sys.stderr, "Unable to parse board filename '%s', skip it" % boardfile
				continue
			# now try to compile every tests with this given board
			for test,pathtest in test_files.items():
				status = do_compile(["-i",get_full_board_path(dir,boardfile),os.path.join(testdir,pathtest)],exitonerror=False)
				if status == 0:
					# dispatch to devices
					matrix[pic]['tests'].setdefault(test,{'pass' : None, 'revision' : None})
					print "Test '%s' registered for pic '%s'" % (test,pic)
				else:
					print >> sys.stderr, "Compilation failed for test '%s' with pic '%s' (status=%s)" % (test,pic,status)


	analyse_sampledir(sample_dir)
	analyse_testdir(sample_dir)
	
	save_matrix(matrix,outfile)

def prune_testing_matrix(sample_dir,outfile,selected_pics=[]):
	if not "by_device" in os.listdir(sample_dir):
		print >> sys.stderr, "Sample dir '%s' does not contain 'by_device' map." % bydevicedir
		sys.exit(1)
	bydevicedir = os.path.join(sample_dir,"by_device")

	matrix = get_matrix(outfile)
	pics = selected_pics and selected_pics or matrix.keys()
	for pic in pics:
		for s in matrix[pic]['samples'].keys():
			if not os.path.isfile(os.path.join(bydevicedir,pic,s)):
				print "PIC: %s, sample '%s' doesn't exist, removing from the matrix..." % (pic,s)
				del matrix[pic]['samples'][s]

	save_matrix(matrix,outfile)


def add_update_test(test_str,outfile,sample_dir):
	matrix = get_matrix(outfile)
	try:
		pic,testfile,result = test_str.split(":")
	except ValueError:
		print >> sys.stderr,"Please specify the result as <pic>:<test_file>:<result>\n(eg. 16f88:serial_hw_echo.jal:true)"
		sys.exit(1)
	# extract manually passed revision (if exists)
	revision = None
	if "@" in result:
		result,revision = result.split("@")
	# normalize
	try:
		result = {'true':True,'false':False,'null':None}[result]
	except KeyError,e:
		print >> sys.stderr,"Invalid result '%s'. Specify either true, false or null" % e
		sys.exit(1)

	try:
		# dispatch by naming convention...
		if testfile.startswith("test_"):
			tdict = matrix[pic]['tests']
			testdir = os.path.join(sample_dir,'test')
			if not os.path.isdir(testdir):
				print >> sys.stderr, "'%s' is not a valid directory" % testdir
				sys.exit(1)
			tfiles = get_jal_filenames(get_full_test_path(sample_dir))
			if not testfile in tfiles.keys():
				print >> sys.stderr, "Can't find test '%s'" % testfile
				sys.exit(1)
			fullsfile = os.path.join(testdir,tfiles[testfile])
		else:
			tdict = matrix[pic]['samples']
			# check if sample exist, and under svn
			bydevice = get_full_sample_path(sample_dir)
			if not os.path.isdir(bydevice):
				print >> sys.stderr, "'%s' is not a valid directory" % bydevice
				sys.exit(1)
			fullsfile = os.path.join(bydevice,pic,testfile)
			if not os.path.isfile(fullsfile):
				print >> sys.stderr, "Sample '%s' does not exist" % fullsfile
				sys.exit(1)
	except KeyError,e:
		print >> sys.stderr,"Can't find PIC %s (need to update the matrix ?)" % e
		sys.exit(1)
	
	if revision:
		# bypass automatic info fetching
		try:
			revision = int(revision)
		except TypeError,ValueError:
			print >> sys.stderr, "Revision must be an integer, not %s" % repr(revision)
			sys.exit(1)
	elif has_pysvn:
		# get svn info using pysvn 
		try:
			svnclient = pysvn.Client()
			revision = svnclient.info(fullsfile)['revision'].number
		except pysvn.ClientError,e:
			print >> sys.stderr, "Unable to get SVN information, because: %s" % e
			sys.exit(1)
	else:
		print >> sys.stderr, "You don't have pysvn installed, you need to specify the revision\n\t<pic>:<testfile>:<true|false|null>@<revision"
		sys.exit(1)

	n = {'pass' : result, 'revision' : revision}
	if tdict.has_key(testfile):
		t = tdict[testfile]
		print "Update '%s' result for PIC %s: %s => %s" % (testfile,pic,repr(t),repr(n))
		tdict[testfile] = n
	else:
		print "Add new file '%s' for PIC %s: %s" % (testfile,pic,n)
	tdict[testfile] = n
	save_matrix(matrix,outfile)

def delete_test(test_str,outfile):
	matrix = get_matrix(outfile)
	try:
		pic,testfile = test_str.split(":")
	except ValueError:
		print >> sys.stderr,"Please specify the test to remove as <pic>:<test_file>\n(eg. 16f88:bad_test.jal)"
		sys.exit(1)
	try:
		ttype = "sample"
		if testfile.startswith("test_"):
			ttype = "test"
		print "Unregistering %s '%s' from PIC %s" % (ttype,testfile,pic)
		del matrix[pic]['%ss' % ttype][testfile]
		save_matrix(matrix,outfile)
	except KeyError,e:
		print >> sys.stderr, "Unable to delete '%s' from PIC %s, cannot find '%s'" % (testfile,pic,e)
		sys.exit(1)

def get_meter_label(meter):
	if meter < 0:
		return "not supported"
	elif meter == 0:
	   return "not tested"
	elif meter <= 10:
	   return "poor"
	elif meter <= 30:
	   return "risky"
	elif meter <= 50:
	   return "average"
	elif meter <= 60:
	   return "nice"
	elif meter <= 70:
	   return "good"
	elif meter <= 80:
	   return "very good"
	elif meter <= 90:
	   return "awesome"
	elif meter <= 100:
	   return "oh my..."
	else:
	   return "can't be serious"

def sample_stat(data):
	true = false = none = 0
	for what in ('samples','tests'):
		true += len([s for s in data[what] if data[what][s]['pass'] == True])
		false += len([s for s in data[what] if data[what][s]['pass'] == False])
		none += len([s for s in data[what] if data[what][s]['pass'] == None])
	return (true,false,none)

def compute_meter(data):
	sample_num = len(data['samples']) + len(data['tests'])
	if sample_num == 0:
	   return 0.0
	true,false,none = sample_stat(data)
	print "true_samples: %s, false_samples: %s, none_samples: %s --- %s sample_num" % (true,false,none,sample_num)
	note = ((float(true) - float(false)) / float(sample_num)) * 100.0
	return note


def find_includes(jalfile):
	content = file(jalfile).read()
	return re.findall("^\s*include\s+(\w+)\s*",content,re.MULTILINE)


def generate_html(tmpl_file,tmpl_file_pic,html_file,outfile,sample_dir,only_tested=False,for_each_pic_tmpl=None):
	if not has_cheetah:
		print >> sys.stderr, "You can't use this action, because cheetah module is not installed"
		sys.exit(255)
		
	matrix = get_matrix(outfile)
	# TODO
	newtr = {}
	for pic,res in matrix.items():
		libs = {True : [], False : [], None: []}
		# build libds list for all samples attached to this PIC
		# and also a list of libs for each samples
		# (both used for main matrix and dedicated test page)
		for sample,info in res['samples'].items() + res['tests'].items():
			if sample.startswith("test_"):
				found_libs = find_includes(get_full_test_path(sample_dir,sample))
			else:
				found_libs = find_includes(get_full_sample_path(sample_dir,pic,sample))
			# normalize
			found_libs = map(lambda x: x.lower(),found_libs)
			info['libs'] = found_libs
			libs[info['pass']].extend(found_libs)
		# unique
		for k in libs.keys():
			libs[k] = list(set(libs[k]))
		if only_tested and len(libs[True]) == 0 and len(libs[False]) == 0:
			continue
		else:
			newtr[pic] = res
			newtr[pic]['libs'] = libs

	# generate global matrix
	tmplsrc = "".join(file(tmpl_file,"r").readlines())
	klass = Cheetah.Template.Template.compile(tmplsrc)
	tmpl = klass()
	tmpl.test_results = newtr
	tmpl.sample_stat = sample_stat
	tmpl.compute_meter = compute_meter
	tmpl.get_meter_label = get_meter_label
	fout = file(html_file,"w")
	print >> fout, tmpl.main()

	# then dedicated page
	if tmpl_file_pic:
		outdir = os.path.dirname(html_file)
		tmplsrc = "".join(file(tmpl_file_pic,"r").readlines())
		klass = Cheetah.Template.Template.compile(tmplsrc)
		tmpl2 = klass()
		for pic,res in newtr.items():
			tmpl2.sample_stat = sample_stat
			tmpl2.compute_meter = compute_meter
			tmpl2.get_meter_label = get_meter_label
			tmpl2.data = res
			print "res: %s" % res
			tmpl2.picname = pic
			fout = file(os.path.join(outdir,"test_%s.html" % pic),"w")
			print >> fout, tmpl2.main()
		
		

def display_test_results(pic,outfile):
	matrix = get_matrix(outfile)
	try:
		for ttype in ("samples","tests"):
			print "%s:" % ttype
			for k,v in matrix[pic][ttype].items():
				print "    %s : %s" % (k,v['pass'])
	except KeyError,e:
		print >> sys.stderr, "Can't test result for PIC %s" % e
		sys.exit(1)

def merge_matrix(outfile,sub_matrix):
	main_matrix = get_matrix(outfile)
	sub_matrix = get_matrix(sub_matrix)
	main_matrix.update(sub_matrix)
	save_matrix(main_matrix,outfile)


##########
# SAMPLE #
##########

def parse_board(boardcontent):
	current_section = None
	sections = {}
	for l in boardcontent:
		if "@jallib" in l:
			current_section = l.split()[-1]
			sections[current_section] = []
		if current_section:
			sections[current_section] += l
	return {'sections' : sections}
	

def merge_board_testfile(boardcontent,testcontent):
	board = parse_board(boardcontent)
	# replace sections in testcontent
	testcontent = "".join(testcontent)
	toreplace = [m for m in re.finditer("((--)+)|(;+)\s*@jallib use (.*)",testcontent,re.MULTILINE) if m.groups()[-1]]
	newcontent = ""
	start = 0
	for m in toreplace:
		newcontent += testcontent[start:m.start() - 1]
		new = "".join(board['sections'][m.groups()[-1].strip()])
		start = m.end() + 1
		newcontent += new
	newcontent += testcontent[start:]
	return newcontent


def do_sample(args=[]):
	try:
		opts, args = getopt.getopt(args, ACTIONS['sample']['options'])
	except getopt.error,e:
		print >> sys.stderr, "Wrong option or missing argument: %s" % e.opt
		sys.exit(255)
	
	boardfile = None
	testfile = None
	outfile = None
	for o,v in opts:
		if o == '-b':
			boardfile = v
		elif o == '-t':
			testfile = v
		elif o == '-o':
			outfile = v
	if boardfile and testfile:
		board = map(lambda x: x.replace("\r\n",os.linesep),file(boardfile).readlines())
		test = map(lambda x: x.replace("\r\n",os.linesep),file(testfile).readlines())
		# keep test's headers, but enrich them with info about how files were merged
		# headers need index
		# extract_header will change content in place, ie. will remove
		# header from test content. 
		test = [t for t in enumerate(test)]
		header = extract_header(test)
		header = "".join([h for i,h in header])
		header += """--
-- This file has been generated on %s, from:
--    * board: %s
--    * test : %s
--
""" % (time.strftime("%c",datetime.datetime.now().timetuple()),os.path.basename(boardfile),os.path.basename(testfile))
		# back to content without index
		test = [l for i,l in test]
		merged = merge_board_testfile(board,test)
		fout = file(outfile,"w")
		print >> fout, header
		print >> fout, merged
		fout.close()
	else:
		print >> sys.stderr, "Provide a board and a test file"
		sys.exit(255)


#################
# REINDENT FUNC #
#################

POSTINC = ["assembler","block","case","while","for","forever","then","function","procedure"]
INLINEKW = ["assembler","block","case","function","procedure","if"]
PROTO = ["procedure","function"]
PREDEC = ["end"]
PREINCPOST = ["else","elsif"]
INDENTCHARS = 3 * " "

def reindent_file(filename):
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
			content.append(INDENTCHARS * level + code + comchars + comment)
			level += 1
			continue
		if do_predec:
			level -= 1
			content.append(INDENTCHARS * level + code + comchars + comment)
			continue
		if do_preincpost:
			level -= 1
			content.append(INDENTCHARS * level + code + comchars + comment)
			level += 1
			continue
			
		content.append(INDENTCHARS * level + code + comchars + comment)
		if level < 0:
			raise Exception("Adjusting indent level gives negative one. Please report bug !")
	
	assert level == 0, "Reached the end of file, but indent level is not null (it should)"
	# ok, now we can save the content back to the file
	fout = file(filename,"w")
	print >> fout, "\n".join(content)
	fout.close()

def do_reindent(args):
	for filename in args:
		reindent_file(filename)
	
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
    - test     : handle testing matrix and test results.

Use 'help' with each action for more (eg. "jallib help compile")

http://jallib.googlecode.com 
"""

def do_license(_trash):
	print """
http://jallib.googlecode.com 
Released under the BSD license

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

def test_help():
	print """
    jallib test [-u|-a|-d|-m other_matrix.yaml] [-f testing_matrix.yaml]
                [-s path/to/sample] [-p picname] [-n pic1,pic2,...]
                [-g template.tmpl [-o page.html] [-1] [-t template.tmpl]]
                      

Use this option to handle the testing matrix and the test result page.

    -u: update an existing testing matrix, by searching for new samples.
        Tests must be manually added to the testing matrix file (because 
        tests are not relevant to all target chips). This won't erase 
        previous testing results, but will potentially add new sample 
        lines to the testing matrix file.
	
	-e: erase samples which are declared in the matrix, but don't exist
		anymore on the filesystem/repository. Ex: when samples are renamed
		the matrix needs to be updated (-u) to include renamed samples,
		then it needs to be pruned (-e) to remove old samples.

    -a: add or update a test result. If the test does not exist, it's 
        added to the matrix, else results will be updated.
        The format is target:test_file:result[@revision].
        If pysvn module is installed, will automatically get revision
        information for given sample. Else, you'll need to specify the
        revision, using @revision format. Using the full format with 
        revision will also bypass getting information from SVN using
        pysvn, even if this module is installed.

        For example:
         * to register a new test which passed, for 16f88
            -a 16f88:new_test.jal:true
         * to register a new test which failed, for 16f877
            -a 16f877:new_test.jal:false
         * to register a new test, not run yet, for 16f648a
            -a 16f648a:new_test.jal:null
         * to register a new test without pysvn installed (manual),
           assuming the test is working for revision 143
            -a 16f628:new_test.jal:true@143

    -d: delete/unregister test. The format is: target:test_file. Ex:
        To remove a test from 16f88 device:
            -d 16f88:bad_test.jal

    -m: merge another testing matrix with the main one specified with 
        option -f. All test results found in this other matrix will 
        replace those found in the main matrix. This option, with -n one,
        allows to work on a small subset of PICs, and then re-integrate 
        the results in the main testing matrix.

    -p: print current test result for a given PIC

    -n: only consider the list of PICs while generating the matrix. PICs 
        are comma separated. Ex:
            -n 16f88,16f877,16f877a

    -G: generate HTML a testing matrix from tests results, and dedicated 
        test result pages for each PIC, from both samples and tests.

    -g: generate all dedicated test results page for each PIC

    -1: only generate testing matrix for PIC which have at least one test
        executed, whether passed or failed.
    
    -t: also generate dedidated test result pages for each PIC, using given
        template. The output file will be named as: test_<picname>.html 
        (not implemented yet)

    -o: specify output HTML file. Used with -G option. If omitted, will be 
        named the same as the template file, with ".html" extension
        If -g is also specified, then param's dirname will be used to produre html
        files for each PICs.

    -f: file storing the testing matrix results. YAML formatted. If not 
        specified, will look for a JALLIB_MATRIX environment variable.
    
    -s: path to the sample directory. If no option is given, it will expect 
        to define as an environment variable, JALLIB_SAMPLEDIR. If no option
        is given, and no env. variable can be found, the current directory 
        will be considered. The sample(s) directory(ies) *must* contain a 
        'by_device' directory.

"""

def reindent_help():
	print """
    jallib reindent file.jal [anotherfile.jal ...]

Reindent the given jal file, and save it back to the same file.

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
		'compile'	: {'callback' : do_compile, 'options' : 'R:E:', 'help' : compile_help},
		'validate'	: {'callback' : do_validate, 'options' : '', 'help' : validate_help},
		'test'		: {'callback' : do_test, 'options' : 's:uef:a:G:g:d:o:p:t:1n:m:', 'help' : test_help},
		'sample'	: {'callback' : do_sample, 'options' : 'b:t:o:', 'help' : None},
		'reindent'	: {'callback' : do_reindent, 'options' : 'f:o:', 'help' : reindent_help},
		'help'		: {'callback' : do_help, 'options' : '', 'help' : None},
		'license'	: {'callback' : do_license, 'options' : '', 'help' : None},
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
				print "Unknown action %s" % e
				sys.exit(255)
		callme(action_args)
	except IndexError,e:
		print >> sys.stderr, "Please provide an action: %s" % repr(ACTIONS.keys())
		sys.exit(255)
