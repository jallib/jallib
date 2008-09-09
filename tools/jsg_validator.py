#!/usr/bin/python
#
#
# Title: Jallib Style Guide validator script
# Author: Sebastien Lelong, Copyright (c) 2008, all rights reserved.
# Adapted-by:
# Compiler:
# 
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
# 
# Description: this script analyses a jallib file (JAL file only) and shows warnings and errors,
#              according to the JSG, Jallib Style Guide. It's supposed to help
#              having a standard, coherent code withint the jallib repository.
#              See: http://code.google.com/p/jallib/wiki/JallibStyleGuide for more
#              
#
# Notes:
#

import sys,os
import re

def content_not_empty(val):
	return val.strip() != ''
def compiler_version(val):
	return re.match("^(>|<|>=|<=|=)\d+(\.\d+\w*)+\s+$",val)

JALLIB = """^-- This file is part of jallib\s+\(http://jallib.googlecode.com\)"""
LICENSE = """^-- Released under the BSD license\s+\(http://www.opensource.org/licenses/bsd-license.php\)"""

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
			errors.append("%d: cannot find end of field content %s" % (i,field))
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
		if re.match(LICENSE,line):
			license = True
			if jallib: break
	not jallib and errors.append("Cannot find references to jallib (should have: %s)" % repr(JALLIB))
	not license and errors.append("Cannot find references to license (should have: %s)" % repr(LICENSE))
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
	print "File: %s" % filename
	print "%d errors found" % len(errors)
	for err in errors:
		print "\tERROR: %s" % err
	print
	print "%d warnings found" % len(warnings)
	for warn in warnings:
		print "\twarning: %s" % warn
	
	if errors or warnings:
		return True


if __name__ == '__main__':
	if len(sys.argv) < 2:
		print "Please provide a JAL file to validate"
		sys.exit(255)

	at_least_one_failed = False
	errors = []
	warnings = []

	for filename in sys.argv[1:]:
		validate(filename)
		if report(filename):
			at_least_one_failed = True
		errors = []
		warnings = []

	if at_least_one_failed:
		sys.exit(1)
	else:
		sys.exit(0)

	

