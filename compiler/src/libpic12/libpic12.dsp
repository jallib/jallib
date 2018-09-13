# Microsoft Developer Studio Project File - Name="libpic12" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 5.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=libpic12 - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "libpic12.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "libpic12.mak" CFG="libpic12 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "libpic12 - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "libpic12 - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe

!IF  "$(CFG)" == "libpic12 - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# SUBTRACT CPP /YX
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# SUBTRACT CPP /YX
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ENDIF 

# Begin Target

# Name "libpic12 - Win32 Release"
# Name "libpic12 - Win32 Debug"
# Begin Source File

SOURCE=.\pic.c
# End Source File
# Begin Source File

SOURCE=.\pic12.c
# End Source File
# Begin Source File

SOURCE=.\pic14.c
# End Source File
# Begin Source File

SOURCE=.\pic14h.c
# End Source File
# Begin Source File

SOURCE=.\pic16.c
# End Source File
# Begin Source File

SOURCE=.\pic_brop.c
# End Source File
# Begin Source File

SOURCE=.\pic_cmdo.c
# End Source File
# Begin Source File

SOURCE=.\pic_code.c
# End Source File
# Begin Source File

SOURCE=.\pic_daop.c
# End Source File
# Begin Source File

SOURCE=.\pic_emu.c
# End Source File
# Begin Source File

SOURCE=.\pic_gop.c
# End Source File
# Begin Source File

SOURCE=.\pic_inst.c
# End Source File
# Begin Source File

SOURCE=.\pic_op.c
# End Source File
# Begin Source File

SOURCE=.\pic_opfn.c
# End Source File
# Begin Source File

SOURCE=.\pic_stk.c
# End Source File
# Begin Source File

SOURCE=.\pic_stvar.c
# End Source File
# Begin Source File

SOURCE=.\pic_var.c
# End Source File
# Begin Source File

SOURCE=.\pic_wopt.c
# End Source File
# Begin Source File

SOURCE=.\picbsrop.c
# End Source File
# Begin Source File

SOURCE=.\piccolst.c
# End Source File
# Begin Source File

SOURCE=.\picdelay.c
# End Source File
# Begin Source File

SOURCE=.\picmovlpop.c
# End Source File
# End Target
# End Project
