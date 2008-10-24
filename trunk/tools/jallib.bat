@ echo off
rem  Title: jallib executable for windows system
rem  Author: Sebastien Lelong, Copyright (c) 2008, all rights reserved.
rem  Adapted-by:
rem  Compiler:
rem  
rem  This file is part of jallib (http://jallib.googlecode.com)
rem  Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
rem 
rem  Sources:
rem  
rem  Description: the aim of this script is to ease user's life !
rem  If *you* are a user, edit this script by specfiying the following
rem  environment variables. These variables will save you some typing
rem  while using the jallib wrapper script. Adapt it to your own need !
rem  Once done, you can put this script in your path.
rem  Rem: usually, setting JALLIB_ROOT as an absolute path is enough.
 

rem ########################
rem ENVIRONMENT VARIABLES #
rem ######################


rem Path to the jallib root's repository (containing "tools,"unvalidated","validated" dirs)
set JALLIB_ROOT=C:\Documents and Settings\Seb\Mes documents\Projects\jallib
rem path to jallib root's libraries. You may want to point to "validated" or "unvalidated"
set JALLIB_REPOS=%JALLIB_ROOT%\unvalidated\include
rem path to jallib root's samples. You may want to point to "validated" or "unvalidated"
set JALLIB_SAMPLEDIR=%JALLIB_ROOT%\unvalidated\sample
rem path to the testing matrix
set JALLIB_MATRIX=%JALLIB_SAMPLEDIR%\testing_matrix.yaml
rem path to "jalv2" executable. If not in your PATH, set an absolute path to the exec
set JALLIB_JALV2=C:\jalv24h\jalv2.exe




rem Either:
rem  - run the "jallib.exe" standalone executable
rem    (no dependencies, recommended)
rem  - run the jallib.py python script 
rem    (advanced user, you'll need to install dependencies first)

rem #############
rem  Standalone #
rem #############
rem  (recommended)
"%JALLIB_ROOT%\tools\jallib.exe" %1 %2 %3 %4 %5 %6 %7 %8 %9


rem ###################
rem  python script    #
rem ###################
rem  (advanced users)
rem  uncomment the two last line, and comment the standalone call.
rem # path to "python" executable, if needed
rem set JALLIB_PYTHON=C:\Python25\python.exe
rem %JALLIB_PYTHON% %JALLIB_ROOT%/tools/jallib.py %1 %2 %3 %4 %5 %6 %7 %8 %9

