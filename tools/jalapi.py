#!/usr/bin/python
#
#
# Title: jalapi documentation generator
# Author: Sebastien Lelong, Copyright (c) 2008, all rights reserved.
# Adapted-by:
# Compiler:
# 
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
# 
# Description: this script takes a jal library file as argument and parse/extract
# JSG headers and procedure/function comments to build a googlecode wiki page.
# It also search for samples using this library.
# Used to produce API documentation.
#
# Notes: jal library file must first pass the JSG validator script before using this one
# This script also uses wikify.py script to generate html from GoogleCode (and potentially
# other wikis) wiki. Can be found here:
# 	* http://cspace.googlecode.com/svn/wiki/wikify.py
# You may have to adjust your PYTHONPATH, so it includes wikify's dir, to run this script
#
#

import sys, os
import re
import wikify
import jsg_validator

SVN_BROWSER_ROOT = "http://code.google.com/p/jallib/source/browse"

def extract_comments(i,origline,content):
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

def extract_doc(filename):
	# deals with header
	# jsg wants line number...
	content = [(i + 1,l) for i,l in enumerate(open(filename,"r").readlines())]
	header = jsg_validator.extract_header(content)
	dhead = {}
	for field_dict in jsg_validator.FIELDS:
		# Special case: when still '--' comment chars,this means new paragraph
		c = jsg_validator.validate_field(header,**field_dict)
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
			doc = extract_comments(i,line.strip(),content[i+1:])
			dfunc[func.match(line).groups()[0]] = doc
		if proc.match(line):
			doc = extract_comments(i,line.strip(),content[i+1:])
			dproc[proc.match(line).groups()[0]] = doc
		if var_const.match(line):
			doc = extract_comments(i,line.strip(),content[i+1:])
			dvarconst[line] = doc
		if include.match(line):
			dep = include.match(line).groups()[0]
			ddeps[dep] = True
				
	return (dhead,dproc,dfunc,dvarconst,ddeps)

def get_samples_info(samples):
	dsamples = {}
	for sample in samples:
		# yeah, that's a system call again, for svn...
		# en english please so we can parse...
		stdin,stdout,stderr = os.popen3("LANG=C svn info %s | grep ^URL:" % sample)
		stderr = stderr.read()
		if stderr:
			print >> sys.stderr, "Skip extracting SVN URL for sample %s because: %s" % (sample,stderr)
			continue
		fullurl = stdout.read().replace("URL:","").strip()
		stdin,stdout,stderr = os.popen3("LANG=C svn info %s | grep ^Repository\ Root:" % sample)
		stderr = stderr.read()
		if stderr:
			print >> sys.stderr, "Skip extracting SVN Repository Root for sample %s because: %s" % (sample,stderr)
		reposroot = stdout.read().replace("Repository Root:","").strip()
		svnbrowserurl = fullurl.replace(reposroot,SVN_BROWSER_ROOT)
		dsamples[os.path.basename(sample)] = svnbrowserurl
	
	return dsamples


def html_linker(lib):
	return "%s.html" % lib


if __name__ == '__main__':
	import Cheetah.Template
	try:
		tmpl_file = sys.argv[1]
		filename = sys.argv[2]
	except IndexError:
		print >> sys.stderr, "Please provide a template and jal library file"
		sys.exit(255)

	# first validate it !
	jsg_validator.validate(filename)
	if jsg_validator.errors:
		print >> sys.stderr, "%s does not pass JSG, cannot generate API documentation" % filename
		sys.exit(1)

	# ok, it's valid, I'll do my job...

	# find sample using this lib
	try:
		SAMPLEDIR = os.environ['SAMPLEDIR']
	except KeyError:
		print >> sys.stderr, "Set SAMPLEDIR env. variable, so I can search for sample using %s" % filename
		sys.exit(2)
	# yeah, that's a grep, this should be re-implemened in pure python
	# to be used under MS win.
	libname = re.sub("\.jal$","",os.path.basename(filename))
	stdin,stdout,stderr = os.popen3("""grep -R -l ^include\ %s %s | grep \.jal\$""" % (libname,SAMPLEDIR))
	stderr = stderr.read()
	stdout = stdout.read()
	if stderr:
		print >> sys.stderr, "Can't find sample using %s because: %s" % (filename,stderr)
		sys.exit(3)
	print >> sys.stderr, "Samples using %s:\n%s" % (filename,stdout)
	sample_files = stdout.split()
	dsamples = get_samples_info(sample_files)

	# extract doc
	dhead,dproc,dfunc,dvarconst,ddeps = extract_doc(filename)
	# generate doc
	tmplsrc = "".join(file(tmpl_file,"r").readlines())
	klass = Cheetah.Template.Template.compile(tmplsrc)
	wikifier = wikify.Wikifier(wikify.GoogleCodeWikiFormat,suffix=".html")
	tmpl = klass()
	tmpl.dhead = dhead
	tmpl.dproc = dproc
	tmpl.dfunc = dfunc
	tmpl.dvarconst = dvarconst
	tmpl.ddeps = ddeps
	tmpl.libname = libname
	tmpl.dsamples = dsamples
	tmpl.html_linker = html_linker
	tmpl.wikifier = wikifier

	print tmpl.main()

	print >> sys.stderr, "Success !"
	sys.exit(0)

