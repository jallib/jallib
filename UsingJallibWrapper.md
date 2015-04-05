This page describes how to install, configure and use the "jallib" wrapper script.

# What is the "jallib" wrapper script ? #

"jallib" script can handle common tasks when working with the SVN repository. Tasks include compiling, validating, indent code, generating doc, etc... Whether you're a user or a developper, you may want to have a look at it !


# Installing "jallib" #

The script itself is a python script. It uses several dependencies. You have two options: either you can use the binary executable, or you can install all dependencies.

## All-in-one binary ##

There's currently a windows binary, which embed all these dependencies, including python itself ! If you're able to use this binary (ie. you're under windows, or you have `wine` installed for linux users), this is the fastest way to have "jallib" working. Unfortunately, there's currently only a windows binary.

To make sure it's working for you:

```
cd tools
jallib.exe
jallib.exe help
```

should inform you about about how to get help.

Under linux, if you can't install dependencies, you may want to try it using `wine`

```
cd tools
wine jallib.exe
wine jallib.exe help
```


## Installing dependencies ##

The binary distribution drawback is it's slower than using the script the straight way, that is, with all dependencies installed. This is because when you run the binary, it has to uncompress all the content before running it.

So, whether you want it faster or can't use the binary, you have to install dependencies. Don't worry, it's not that complicated...

First, install python 2.5 (it may run with python 2.6):

  * http://www.python.org/download/releases/2.5.2/
    * for linux & others, use your package distrib, or install using sources
    * windows installation is straightforward


Some actions (like `jalapi`) require Cheetah library, a templating engine. If you need them, install Cheetah 2.0.1:

  * http://sourceforge.net/project/showfiles.php?group_id=28961&package_id=20864
  * installation is standard: unpack, and run `python setup.py install` (note, under windows, if python is not in your %PATH%, this should look like `c:\python25\python setup.py install`)


# Configuring "jallib" #

"jallib" wrapper is highly configurable but you can configure it to use default values. To do this, you can copy/paste one of the following shell script:

  * `tools\jallib.bat` for windows users
  * `tools/jallib.sh` for **nix users**

The idea of these script is to configure it according to your installation, ideally put it in your PATH, and that's it, you're ready to use it !

These scripts can handle both the binary or the I-have-installed-all-dependencies way, you just have to comment/uncomment the corresponding chunk of code. Of course, you can modify and put other things in the shell scripts, if it can help you in your everyday jallib tasks :)


# Using "jallib" #

## Compiling ##

`jallib help compile` will give you details about compiling files with jallib. Basically, once the script is configured, you just have to:

```
jallib compile file.jal
```

Note: jallib wrapper honors error code status, so if jalv2 compiler returns a code status 1, then the wrapper will do the same.

## Validating ##

`jallib help validate` will give you details about validating files, and checking how compliant they are according to the JallibStyleGuide. Basically:

```
jallib validate file.jal [file2.jal ...]
```

You can validate multiple files at a time. If all are compliant, it return 0, else if at least has failed, it returns a non-zero code status.

## reindent ##

`jallib help reindent` for more... This action takes a file as input, re-indents it, and write the result back to the file. This is a convenient way to fulfill on JSG requirement about code layout. By default, and this is the jallib's standard, indentation is 3 spaces.

```
jallib reindent file.jal
```