#!/usr/bin/env python
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

import re

errors = []
warnings = []

def content_not_empty(val):
	return val.strip() != ''
def compiler_version(val):
	return re.match("^(>|<|>=|<=|=)\d+(\.\d+\w*)+\s+$",val)

JALLIB = """^-- This file is part of jallib\s+\(http://jallib.googlecode.com\)"""
LICENSE = """^-- Released under the BSD license\s+\(http://www.opensource.org/licenses/bsd-license.php\)"""

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
		l = content.pop()
		if not l.startswith("--"):
			# not a header line, put it again
			content.append(l)
			break
		else:
			header.append(l)
	# remaining content: back to forward...
	content.reverse()
	return header

def validate_field(data,field,predicate,mandatory,multiline=False):

	syntax = "^-- %s:\s*(.*)" % field

	def single_line_content(line):
		return "".join(re.sub(syntax,lambda x:x.group(1),line))
	def multi_line_content(line,data):
		c = single_line_content(line)
		for l in data[data.index(line) + 1:]:
			# Check no comment gap
			if not re.match("^--\s",l):
				errors.append("Cannot extract content, line is not starting with comment: %s" % repr(l))
				return ""
			# No other field within content
			for f in [d['field'] for d in FIELDS]:
				if l.startswith("-- %s:" % f):
					errors.append("Detected field %s within content of field %s" % (f,field))
					return ""
			if l.strip() == '--':
				# got end of block
				break
			c += l.replace("-- ","")
		else:
			errors.append("Cannot find end of field content %s" % field)
		return c
		
	# eat header, and check fields (mandatory or not) and 
	# content (using predicate)
	for l in data:
		if re.match(syntax,l):
			# got it, check field content
			if multiline:
				c = multi_line_content(l,data)
			else:
				c = single_line_content(l)
			# and check with predicate
			valid = predicate(c)
			if mandatory and not valid:
				errors.append("Content for field %s is not valid: %s" % (field,repr(c)))
			break
	else:
		if mandatory:
			errors.append("Cannot find field %s (searched for '%s')" % (field,syntax))


def validate_header(content):
	header = extract_header(content)
		
	# check stuff about jallib and license
	jallib = False
	license = False
	for line in header:
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
	# no check in comments
	codeonly = []
	for line in content:
		if line.startswith(";") or line.startswith("--"):	
			continue
		l = line.split()
		def nocomment(l,c):
			# dirty search comments...
			if c in l:
				l = l[:l.index(c)]
			return l
		# first check ";" *then* "--"
		# so things like ";;;;-- Note" are not considered
		# (else produces wrong splitting...)
		l = nocomment(l,";")
		l = nocomment(l,"--")
		codeonly.append(" ".join(l))
		
	weird = []	# stores all errors
	for token in tokenizer.findall("\n".join(codeonly)):
		# it can be all in caps (constants)
		if token.upper() == token:
			continue
		# hex definition, give up
		if "0x" in token:
			continue
		# exception for port and pin
		if "pin" in token.lower() or "port" in token.lower():
			continue
		if caps.findall(token):
			weird.append("Found Capitals in token: %s" % repr(token))
	# unique token error 
	errors.extend(set(weird))

def validate_no_args(content):
	# no () in definition
	noargs = re.compile("^(procedure|function)\s+\w+\s+is")
	for line in content:
		if noargs.match(line):
			errors.append("%s missing (). Calls must also be explicit" % repr(line))

def validate_code(content):
	validate_lower_case(content)
	validate_no_args(content)
	# ...

def validate(filename):
	validate_filename(filename)
	content = open(filename,"r").readlines()
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
	
	if errors:
		sys.exit(1)
	if warnings:
		sys.exit(2)
	sys.exit(0)


if __name__ == '__main__':
	import sys,os
	try:
		filename = sys.argv[1]
		validate(filename)
		report(filename)

	except IndexError:
		print "Please provide a JAL file to validate"
		sys.exit(255)
