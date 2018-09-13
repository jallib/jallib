# Microsoft Developer Studio Generated NMAKE File, Based on jal.dsp
!IF "$(CFG)" == ""
CFG=jal - Win32 Debug
!MESSAGE No configuration specified. Defaulting to jal - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "jal - Win32 Release" && "$(CFG)" != "jal - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "jal.mak" CFG="jal - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "jal - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "jal - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "jal - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release

!IF "$(RECURSE)" == "0" 

ALL : "..\jalv2.exe"

!ELSE 

ALL : "libcore - Win32 Release" "libutils - Win32 Release"\
 "libpic12 - Win32 Release" "..\jalv2.exe"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libpic12 - Win32 ReleaseCLEAN" "libutils - Win32 ReleaseCLEAN"\
 "libcore - Win32 ReleaseCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\jal_asm.obj"
	-@erase "$(INTDIR)\jal_blck.obj"
	-@erase "$(INTDIR)\jal_ctrl.obj"
	-@erase "$(INTDIR)\jal_expr.obj"
	-@erase "$(INTDIR)\jal_file.obj"
	-@erase "$(INTDIR)\jal_incl.obj"
	-@erase "$(INTDIR)\jal_main.obj"
	-@erase "$(INTDIR)\jal_op.obj"
	-@erase "$(INTDIR)\jal_prnt.obj"
	-@erase "$(INTDIR)\jal_proc.obj"
	-@erase "$(INTDIR)\jal_tokn.obj"
	-@erase "$(INTDIR)\jal_vdef.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "..\jalv2.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D\
 "_MBCS" /Fp"$(INTDIR)\jal.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Release/
CPP_SBRS=.
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\jal.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)\jalv2.pdb" /machine:I386 /out:"../jalv2.exe" 
LINK32_OBJS= \
	"$(INTDIR)\jal_asm.obj" \
	"$(INTDIR)\jal_blck.obj" \
	"$(INTDIR)\jal_ctrl.obj" \
	"$(INTDIR)\jal_expr.obj" \
	"$(INTDIR)\jal_file.obj" \
	"$(INTDIR)\jal_incl.obj" \
	"$(INTDIR)\jal_main.obj" \
	"$(INTDIR)\jal_op.obj" \
	"$(INTDIR)\jal_prnt.obj" \
	"$(INTDIR)\jal_proc.obj" \
	"$(INTDIR)\jal_tokn.obj" \
	"$(INTDIR)\jal_vdef.obj" \
	"..\libcore\Release\libcore.lib" \
	"..\libpic12\Release\libpic12.lib" \
	"..\libutils\Release\libutils.lib"

"..\jalv2.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug

!IF "$(RECURSE)" == "0" 

ALL : "..\jalv2d.exe"

!ELSE 

ALL : "libcore - Win32 Debug" "libutils - Win32 Debug" "libpic12 - Win32 Debug"\
 "..\jalv2d.exe"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libpic12 - Win32 DebugCLEAN" "libutils - Win32 DebugCLEAN"\
 "libcore - Win32 DebugCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\jal_asm.obj"
	-@erase "$(INTDIR)\jal_blck.obj"
	-@erase "$(INTDIR)\jal_ctrl.obj"
	-@erase "$(INTDIR)\jal_expr.obj"
	-@erase "$(INTDIR)\jal_file.obj"
	-@erase "$(INTDIR)\jal_incl.obj"
	-@erase "$(INTDIR)\jal_main.obj"
	-@erase "$(INTDIR)\jal_op.obj"
	-@erase "$(INTDIR)\jal_prnt.obj"
	-@erase "$(INTDIR)\jal_proc.obj"
	-@erase "$(INTDIR)\jal_tokn.obj"
	-@erase "$(INTDIR)\jal_vdef.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(INTDIR)\vc50.pdb"
	-@erase "$(OUTDIR)\jalv2d.pdb"
	-@erase "..\jalv2d.exe"
	-@erase "..\jalv2d.ilk"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MLd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE"\
 /D "_MBCS" /Fp"$(INTDIR)\jal.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\jal.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=/nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)\jalv2d.pdb" /debug /machine:I386 /out:"..\jalv2d.exe"\
 /pdbtype:sept 
LINK32_OBJS= \
	"$(INTDIR)\jal_asm.obj" \
	"$(INTDIR)\jal_blck.obj" \
	"$(INTDIR)\jal_ctrl.obj" \
	"$(INTDIR)\jal_expr.obj" \
	"$(INTDIR)\jal_file.obj" \
	"$(INTDIR)\jal_incl.obj" \
	"$(INTDIR)\jal_main.obj" \
	"$(INTDIR)\jal_op.obj" \
	"$(INTDIR)\jal_prnt.obj" \
	"$(INTDIR)\jal_proc.obj" \
	"$(INTDIR)\jal_tokn.obj" \
	"$(INTDIR)\jal_vdef.obj" \
	"..\libcore\Debug\libcore.lib" \
	"..\libpic12\Debug\libpic12.lib" \
	"..\libutils\Debug\libutils.lib"

"..\jalv2d.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.c{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<


!IF "$(CFG)" == "jal - Win32 Release" || "$(CFG)" == "jal - Win32 Debug"

!IF  "$(CFG)" == "jal - Win32 Release"

"libpic12 - Win32 Release" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libpic12"
   $(MAKE) /$(MAKEFLAGS) /F .\libpic12.mak CFG="libpic12 - Win32 Release" 
   cd "..\jal"

"libpic12 - Win32 ReleaseCLEAN" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libpic12"
   $(MAKE) /$(MAKEFLAGS) CLEAN /F .\libpic12.mak CFG="libpic12 - Win32 Release"\
 RECURSE=1 
   cd "..\jal"

!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

"libpic12 - Win32 Debug" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libpic12"
   $(MAKE) /$(MAKEFLAGS) /F .\libpic12.mak CFG="libpic12 - Win32 Debug" 
   cd "..\jal"

"libpic12 - Win32 DebugCLEAN" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libpic12"
   $(MAKE) /$(MAKEFLAGS) CLEAN /F .\libpic12.mak CFG="libpic12 - Win32 Debug"\
 RECURSE=1 
   cd "..\jal"

!ENDIF 

!IF  "$(CFG)" == "jal - Win32 Release"

"libutils - Win32 Release" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libutils"
   $(MAKE) /$(MAKEFLAGS) /F .\libutils.mak CFG="libutils - Win32 Release" 
   cd "..\jal"

"libutils - Win32 ReleaseCLEAN" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libutils"
   $(MAKE) /$(MAKEFLAGS) CLEAN /F .\libutils.mak CFG="libutils - Win32 Release"\
 RECURSE=1 
   cd "..\jal"

!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

"libutils - Win32 Debug" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libutils"
   $(MAKE) /$(MAKEFLAGS) /F .\libutils.mak CFG="libutils - Win32 Debug" 
   cd "..\jal"

"libutils - Win32 DebugCLEAN" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libutils"
   $(MAKE) /$(MAKEFLAGS) CLEAN /F .\libutils.mak CFG="libutils - Win32 Debug"\
 RECURSE=1 
   cd "..\jal"

!ENDIF 

!IF  "$(CFG)" == "jal - Win32 Release"

"libcore - Win32 Release" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libcore"
   $(MAKE) /$(MAKEFLAGS) /F .\libcore.mak CFG="libcore - Win32 Release" 
   cd "..\jal"

"libcore - Win32 ReleaseCLEAN" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libcore"
   $(MAKE) /$(MAKEFLAGS) CLEAN /F .\libcore.mak CFG="libcore - Win32 Release"\
 RECURSE=1 
   cd "..\jal"

!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

"libcore - Win32 Debug" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libcore"
   $(MAKE) /$(MAKEFLAGS) /F .\libcore.mak CFG="libcore - Win32 Debug" 
   cd "..\jal"

"libcore - Win32 DebugCLEAN" : 
   cd "\kyle\projects\jalv2\jalv24m\src\libcore"
   $(MAKE) /$(MAKEFLAGS) CLEAN /F .\libcore.mak CFG="libcore - Win32 Debug"\
 RECURSE=1 
   cd "..\jal"

!ENDIF 

SOURCE=.\jal_asm.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_A=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_asm.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_proc.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_asm.h"\
	".\jal_blck.h"\
	".\jal_expr.h"\
	".\jal_incl.h"\
	".\jal_tokn.h"\
	

"$(INTDIR)\jal_asm.obj" : $(SOURCE) $(DEP_CPP_JAL_A) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_A=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_asm.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_proc.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_asm.h"\
	".\jal_blck.h"\
	".\jal_expr.h"\
	".\jal_incl.h"\
	".\jal_tokn.h"\
	

"$(INTDIR)\jal_asm.obj" : $(SOURCE) $(DEP_CPP_JAL_A) "$(INTDIR)"


!ENDIF 

SOURCE=.\jal_blck.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_B=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_asm.h"\
	".\jal_blck.h"\
	".\jal_ctrl.h"\
	".\jal_expr.h"\
	".\jal_file.h"\
	".\jal_incl.h"\
	".\jal_prnt.h"\
	".\jal_proc.h"\
	".\jal_tokn.h"\
	".\jal_vdef.h"\
	

"$(INTDIR)\jal_blck.obj" : $(SOURCE) $(DEP_CPP_JAL_B) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_B=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_asm.h"\
	".\jal_blck.h"\
	".\jal_ctrl.h"\
	".\jal_expr.h"\
	".\jal_file.h"\
	".\jal_incl.h"\
	".\jal_prnt.h"\
	".\jal_proc.h"\
	".\jal_tokn.h"\
	".\jal_vdef.h"\
	

"$(INTDIR)\jal_blck.obj" : $(SOURCE) $(DEP_CPP_JAL_B) "$(INTDIR)"


!ENDIF 

SOURCE=.\jal_ctrl.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_C=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_proc.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_blck.h"\
	".\jal_ctrl.h"\
	".\jal_expr.h"\
	".\jal_file.h"\
	".\jal_tokn.h"\
	

"$(INTDIR)\jal_ctrl.obj" : $(SOURCE) $(DEP_CPP_JAL_C) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_C=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_proc.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_blck.h"\
	".\jal_ctrl.h"\
	".\jal_expr.h"\
	".\jal_file.h"\
	".\jal_tokn.h"\
	

"$(INTDIR)\jal_ctrl.obj" : $(SOURCE) $(DEP_CPP_JAL_C) "$(INTDIR)"


!ENDIF 

SOURCE=.\jal_expr.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_E=\
	"..\libcore\cmd.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_expr.h"\
	".\jal_proc.h"\
	".\jal_tokn.h"\
	".\jal_vdef.h"\
	

"$(INTDIR)\jal_expr.obj" : $(SOURCE) $(DEP_CPP_JAL_E) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_E=\
	"..\libcore\cmd.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_expr.h"\
	".\jal_proc.h"\
	".\jal_tokn.h"\
	".\jal_vdef.h"\
	

"$(INTDIR)\jal_expr.obj" : $(SOURCE) $(DEP_CPP_JAL_E) "$(INTDIR)"


!ENDIF 

SOURCE=.\jal_file.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_F=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_file.h"\
	

"$(INTDIR)\jal_file.obj" : $(SOURCE) $(DEP_CPP_JAL_F) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_F=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_file.h"\
	

"$(INTDIR)\jal_file.obj" : $(SOURCE) $(DEP_CPP_JAL_F) "$(INTDIR)"


!ENDIF 

SOURCE=.\jal_incl.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_I=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_proc.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_expr.h"\
	".\jal_incl.h"\
	".\jal_tokn.h"\
	".\jal_vdef.h"\
	

"$(INTDIR)\jal_incl.obj" : $(SOURCE) $(DEP_CPP_JAL_I) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_I=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_proc.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_expr.h"\
	".\jal_incl.h"\
	".\jal_tokn.h"\
	".\jal_vdef.h"\
	

"$(INTDIR)\jal_incl.obj" : $(SOURCE) $(DEP_CPP_JAL_I) "$(INTDIR)"


!ENDIF 

SOURCE=.\jal_main.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_M=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_cmdo.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_blck.h"\
	".\jal_build.h"\
	".\jal_file.h"\
	".\jal_tokn.h"\
	

"$(INTDIR)\jal_main.obj" : $(SOURCE) $(DEP_CPP_JAL_M) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_M=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_cmdo.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_blck.h"\
	".\jal_build.h"\
	".\jal_file.h"\
	".\jal_tokn.h"\
	

"$(INTDIR)\jal_main.obj" : $(SOURCE) $(DEP_CPP_JAL_M) "$(INTDIR)"


!ENDIF 

SOURCE=.\jal_op.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_O=\
	"..\libcore\operator.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\cache.h"\
	

"$(INTDIR)\jal_op.obj" : $(SOURCE) $(DEP_CPP_JAL_O) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_O=\
	"..\libcore\operator.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\cache.h"\
	

"$(INTDIR)\jal_op.obj" : $(SOURCE) $(DEP_CPP_JAL_O) "$(INTDIR)"


!ENDIF 

SOURCE=.\jal_prnt.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_P=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\jal_expr.h"\
	".\jal_prnt.h"\
	

"$(INTDIR)\jal_prnt.obj" : $(SOURCE) $(DEP_CPP_JAL_P) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_P=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\jal_expr.h"\
	".\jal_prnt.h"\
	

"$(INTDIR)\jal_prnt.obj" : $(SOURCE) $(DEP_CPP_JAL_P) "$(INTDIR)"


!ENDIF 

SOURCE=.\jal_proc.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_PR=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_proc.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_blck.h"\
	".\jal_expr.h"\
	".\jal_proc.h"\
	".\jal_vdef.h"\
	

"$(INTDIR)\jal_proc.obj" : $(SOURCE) $(DEP_CPP_JAL_PR) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_PR=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_cmd.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_proc.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_blck.h"\
	".\jal_expr.h"\
	".\jal_proc.h"\
	".\jal_vdef.h"\
	

"$(INTDIR)\jal_proc.obj" : $(SOURCE) $(DEP_CPP_JAL_PR) "$(INTDIR)"


!ENDIF 

SOURCE=.\jal_tokn.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_T=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\jal_tokn.h"\
	

"$(INTDIR)\jal_tokn.obj" : $(SOURCE) $(DEP_CPP_JAL_T) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_T=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\jal_tokn.h"\
	

"$(INTDIR)\jal_tokn.obj" : $(SOURCE) $(DEP_CPP_JAL_T) "$(INTDIR)"


!ENDIF 

SOURCE=.\jal_vdef.c

!IF  "$(CFG)" == "jal - Win32 Release"

DEP_CPP_JAL_V=\
	"..\libcore\cmd.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_proc.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_expr.h"\
	".\jal_tokn.h"\
	".\jal_vdef.h"\
	

"$(INTDIR)\jal_vdef.obj" : $(SOURCE) $(DEP_CPP_JAL_V) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "jal - Win32 Debug"

DEP_CPP_JAL_V=\
	"..\libcore\cmd.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_msg.h"\
	"..\libcore\pf_proc.h"\
	"..\libcore\pf_src.h"\
	"..\libcore\pf_token.h"\
	"..\libcore\pfile.h"\
	"..\libcore\tag.h"\
	"..\libcore\univ.h"\
	"..\libcore\value.h"\
	"..\libcore\vararray.h"\
	"..\libcore\vardef.h"\
	"..\libcore\variable.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\jal_expr.h"\
	".\jal_tokn.h"\
	".\jal_vdef.h"\
	

"$(INTDIR)\jal_vdef.obj" : $(SOURCE) $(DEP_CPP_JAL_V) "$(INTDIR)"


!ENDIF 


!ENDIF 

