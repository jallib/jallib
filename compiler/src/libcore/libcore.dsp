# Microsoft Developer Studio Project File - Name="libcore" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 5.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=libcore - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "libcore.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "libcore.mak" CFG="libcore - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "libcore - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "libcore - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe

!IF  "$(CFG)" == "libcore - Win32 Release"

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
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /FD /c
# SUBTRACT CPP /YX
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

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
# ADD CPP /nologo /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /FD /c
# SUBTRACT CPP /YX
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ENDIF 

# Begin Target

# Name "libcore - Win32 Release"
# Name "libcore - Win32 Debug"
# Begin Source File

SOURCE=.\cmd.c
# End Source File
# Begin Source File

SOURCE=.\cmd_asm.c
# End Source File
# Begin Source File

SOURCE=.\cmd_brch.c
# End Source File
# Begin Source File

SOURCE=.\cmd_lbl.c
# End Source File
# Begin Source File

SOURCE=.\cmd_log.c
# End Source File
# Begin Source File

SOURCE=.\cmd_op.c
# End Source File
# Begin Source File

SOURCE=.\cmd_optm.c
# End Source File
# Begin Source File

SOURCE=.\cmd_proc.c
# End Source File
# Begin Source File

SOURCE=.\cmdarray.c
# End Source File
# Begin Source File

SOURCE=.\cmdassrt.c
# End Source File
# Begin Source File

SOURCE=.\cmddelay.c
# End Source File
# Begin Source File

SOURCE=.\expr.c
# End Source File
# Begin Source File

SOURCE=.\exprnode.c
# End Source File
# Begin Source File

SOURCE=.\label.c
# End Source File
# Begin Source File

SOURCE=.\operator.c
# End Source File
# Begin Source File

SOURCE=.\pf_block.c
# End Source File
# Begin Source File

SOURCE=.\pf_cmd.c
# End Source File
# Begin Source File

SOURCE=.\pf_expr.c
# End Source File
# Begin Source File

SOURCE=.\pf_op.c
# End Source File
# Begin Source File

SOURCE=.\pf_proc.c
# End Source File
# Begin Source File

SOURCE=.\pf_proca.c
# End Source File
# Begin Source File

SOURCE=.\pf_src.c
# End Source File
# Begin Source File

SOURCE=.\pf_token.c
# End Source File
# Begin Source File

SOURCE=.\pfile.c
# End Source File
# Begin Source File

SOURCE=.\tag.c
# End Source File
# Begin Source File

SOURCE=.\value.c
# End Source File
# Begin Source File

SOURCE=.\vararray.c
# End Source File
# Begin Source File

SOURCE=.\vardef.c
# End Source File
# Begin Source File

SOURCE=.\variable.c
# End Source File
# End Target
# End Project
