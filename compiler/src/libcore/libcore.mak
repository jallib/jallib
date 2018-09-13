# Microsoft Developer Studio Generated NMAKE File, Based on libcore.dsp
!IF "$(CFG)" == ""
CFG=libcore - Win32 Debug
!MESSAGE No configuration specified. Defaulting to libcore - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "libcore - Win32 Release" && "$(CFG)" !=\
 "libcore - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
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
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe

!IF  "$(CFG)" == "libcore - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\libcore.lib"

!ELSE 

ALL : "$(OUTDIR)\libcore.lib"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\cmd.obj"
	-@erase "$(INTDIR)\cmd_asm.obj"
	-@erase "$(INTDIR)\cmd_brch.obj"
	-@erase "$(INTDIR)\cmd_lbl.obj"
	-@erase "$(INTDIR)\cmd_log.obj"
	-@erase "$(INTDIR)\cmd_op.obj"
	-@erase "$(INTDIR)\cmd_optm.obj"
	-@erase "$(INTDIR)\cmd_proc.obj"
	-@erase "$(INTDIR)\cmdarray.obj"
	-@erase "$(INTDIR)\cmdassrt.obj"
	-@erase "$(INTDIR)\cmddelay.obj"
	-@erase "$(INTDIR)\expr.obj"
	-@erase "$(INTDIR)\exprnode.obj"
	-@erase "$(INTDIR)\label.obj"
	-@erase "$(INTDIR)\operator.obj"
	-@erase "$(INTDIR)\pf_block.obj"
	-@erase "$(INTDIR)\pf_cmd.obj"
	-@erase "$(INTDIR)\pf_expr.obj"
	-@erase "$(INTDIR)\pf_op.obj"
	-@erase "$(INTDIR)\pf_proc.obj"
	-@erase "$(INTDIR)\pf_proca.obj"
	-@erase "$(INTDIR)\pf_src.obj"
	-@erase "$(INTDIR)\pf_token.obj"
	-@erase "$(INTDIR)\pfile.obj"
	-@erase "$(INTDIR)\tag.obj"
	-@erase "$(INTDIR)\value.obj"
	-@erase "$(INTDIR)\vararray.obj"
	-@erase "$(INTDIR)\vardef.obj"
	-@erase "$(INTDIR)\variable.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(OUTDIR)\libcore.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS"\
 /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Release/
CPP_SBRS=.
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\libcore.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\libcore.lib" 
LIB32_OBJS= \
	"$(INTDIR)\cmd.obj" \
	"$(INTDIR)\cmd_asm.obj" \
	"$(INTDIR)\cmd_brch.obj" \
	"$(INTDIR)\cmd_lbl.obj" \
	"$(INTDIR)\cmd_log.obj" \
	"$(INTDIR)\cmd_op.obj" \
	"$(INTDIR)\cmd_optm.obj" \
	"$(INTDIR)\cmd_proc.obj" \
	"$(INTDIR)\cmdarray.obj" \
	"$(INTDIR)\cmdassrt.obj" \
	"$(INTDIR)\cmddelay.obj" \
	"$(INTDIR)\expr.obj" \
	"$(INTDIR)\exprnode.obj" \
	"$(INTDIR)\label.obj" \
	"$(INTDIR)\operator.obj" \
	"$(INTDIR)\pf_block.obj" \
	"$(INTDIR)\pf_cmd.obj" \
	"$(INTDIR)\pf_expr.obj" \
	"$(INTDIR)\pf_op.obj" \
	"$(INTDIR)\pf_proc.obj" \
	"$(INTDIR)\pf_proca.obj" \
	"$(INTDIR)\pf_src.obj" \
	"$(INTDIR)\pf_token.obj" \
	"$(INTDIR)\pfile.obj" \
	"$(INTDIR)\tag.obj" \
	"$(INTDIR)\value.obj" \
	"$(INTDIR)\vararray.obj" \
	"$(INTDIR)\vardef.obj" \
	"$(INTDIR)\variable.obj"

"$(OUTDIR)\libcore.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\libcore.lib"

!ELSE 

ALL : "$(OUTDIR)\libcore.lib"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\cmd.obj"
	-@erase "$(INTDIR)\cmd_asm.obj"
	-@erase "$(INTDIR)\cmd_brch.obj"
	-@erase "$(INTDIR)\cmd_lbl.obj"
	-@erase "$(INTDIR)\cmd_log.obj"
	-@erase "$(INTDIR)\cmd_op.obj"
	-@erase "$(INTDIR)\cmd_optm.obj"
	-@erase "$(INTDIR)\cmd_proc.obj"
	-@erase "$(INTDIR)\cmdarray.obj"
	-@erase "$(INTDIR)\cmdassrt.obj"
	-@erase "$(INTDIR)\cmddelay.obj"
	-@erase "$(INTDIR)\expr.obj"
	-@erase "$(INTDIR)\exprnode.obj"
	-@erase "$(INTDIR)\label.obj"
	-@erase "$(INTDIR)\operator.obj"
	-@erase "$(INTDIR)\pf_block.obj"
	-@erase "$(INTDIR)\pf_cmd.obj"
	-@erase "$(INTDIR)\pf_expr.obj"
	-@erase "$(INTDIR)\pf_op.obj"
	-@erase "$(INTDIR)\pf_proc.obj"
	-@erase "$(INTDIR)\pf_proca.obj"
	-@erase "$(INTDIR)\pf_src.obj"
	-@erase "$(INTDIR)\pf_token.obj"
	-@erase "$(INTDIR)\pfile.obj"
	-@erase "$(INTDIR)\tag.obj"
	-@erase "$(INTDIR)\value.obj"
	-@erase "$(INTDIR)\vararray.obj"
	-@erase "$(INTDIR)\vardef.obj"
	-@erase "$(INTDIR)\variable.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(OUTDIR)\libcore.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MLd /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\libcore.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\libcore.lib" 
LIB32_OBJS= \
	"$(INTDIR)\cmd.obj" \
	"$(INTDIR)\cmd_asm.obj" \
	"$(INTDIR)\cmd_brch.obj" \
	"$(INTDIR)\cmd_lbl.obj" \
	"$(INTDIR)\cmd_log.obj" \
	"$(INTDIR)\cmd_op.obj" \
	"$(INTDIR)\cmd_optm.obj" \
	"$(INTDIR)\cmd_proc.obj" \
	"$(INTDIR)\cmdarray.obj" \
	"$(INTDIR)\cmdassrt.obj" \
	"$(INTDIR)\cmddelay.obj" \
	"$(INTDIR)\expr.obj" \
	"$(INTDIR)\exprnode.obj" \
	"$(INTDIR)\label.obj" \
	"$(INTDIR)\operator.obj" \
	"$(INTDIR)\pf_block.obj" \
	"$(INTDIR)\pf_cmd.obj" \
	"$(INTDIR)\pf_expr.obj" \
	"$(INTDIR)\pf_op.obj" \
	"$(INTDIR)\pf_proc.obj" \
	"$(INTDIR)\pf_proca.obj" \
	"$(INTDIR)\pf_src.obj" \
	"$(INTDIR)\pf_token.obj" \
	"$(INTDIR)\pfile.obj" \
	"$(INTDIR)\tag.obj" \
	"$(INTDIR)\value.obj" \
	"$(INTDIR)\vararray.obj" \
	"$(INTDIR)\vardef.obj" \
	"$(INTDIR)\variable.obj"

"$(OUTDIR)\libcore.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
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


!IF "$(CFG)" == "libcore - Win32 Release" || "$(CFG)" ==\
 "libcore - Win32 Debug"
SOURCE=.\cmd.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_CMD_C=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd.obj" : $(SOURCE) $(DEP_CPP_CMD_C) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_CMD_C=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd.obj" : $(SOURCE) $(DEP_CPP_CMD_C) "$(INTDIR)"


!ENDIF 

SOURCE=.\cmd_asm.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_CMD_A=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmd_asm.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_asm.obj" : $(SOURCE) $(DEP_CPP_CMD_A) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_CMD_A=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmd_asm.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_asm.obj" : $(SOURCE) $(DEP_CPP_CMD_A) "$(INTDIR)"


!ENDIF 

SOURCE=.\cmd_brch.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_CMD_B=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_brch.obj" : $(SOURCE) $(DEP_CPP_CMD_B) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_CMD_B=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_brch.obj" : $(SOURCE) $(DEP_CPP_CMD_B) "$(INTDIR)"


!ENDIF 

SOURCE=.\cmd_lbl.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_CMD_L=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_lbl.obj" : $(SOURCE) $(DEP_CPP_CMD_L) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_CMD_L=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_lbl.obj" : $(SOURCE) $(DEP_CPP_CMD_L) "$(INTDIR)"


!ENDIF 

SOURCE=.\cmd_log.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_CMD_LO=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_log.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_log.obj" : $(SOURCE) $(DEP_CPP_CMD_LO) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_CMD_LO=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_log.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_log.obj" : $(SOURCE) $(DEP_CPP_CMD_LO) "$(INTDIR)"


!ENDIF 

SOURCE=.\cmd_op.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_CMD_O=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_op.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_op.obj" : $(SOURCE) $(DEP_CPP_CMD_O) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_CMD_O=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_op.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_op.obj" : $(SOURCE) $(DEP_CPP_CMD_O) "$(INTDIR)"


!ENDIF 

SOURCE=.\cmd_optm.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_CMD_OP=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_brch.h"\
	".\cmd_op.h"\
	".\cmd_optm.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_op.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_optm.obj" : $(SOURCE) $(DEP_CPP_CMD_OP) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_CMD_OP=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_brch.h"\
	".\cmd_op.h"\
	".\cmd_optm.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_op.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_optm.obj" : $(SOURCE) $(DEP_CPP_CMD_OP) "$(INTDIR)"


!ENDIF 

SOURCE=.\cmd_proc.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_CMD_P=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_proc.obj" : $(SOURCE) $(DEP_CPP_CMD_P) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_CMD_P=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmd_proc.obj" : $(SOURCE) $(DEP_CPP_CMD_P) "$(INTDIR)"


!ENDIF 

SOURCE=.\cmdarray.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_CMDAR=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	".\cmdarray.h"\
	".\univ.h"\
	

"$(INTDIR)\cmdarray.obj" : $(SOURCE) $(DEP_CPP_CMDAR) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_CMDAR=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	".\cmdarray.h"\
	".\univ.h"\
	

"$(INTDIR)\cmdarray.obj" : $(SOURCE) $(DEP_CPP_CMDAR) "$(INTDIR)"


!ENDIF 

SOURCE=.\cmdassrt.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_CMDAS=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmdassrt.obj" : $(SOURCE) $(DEP_CPP_CMDAS) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_CMDAS=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmdassrt.obj" : $(SOURCE) $(DEP_CPP_CMDAS) "$(INTDIR)"


!ENDIF 

SOURCE=.\cmddelay.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_CMDDE=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmd_usec.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmddelay.obj" : $(SOURCE) $(DEP_CPP_CMDDE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_CMDDE=\
	"..\libpic12\pic.h"\
	"..\libpic12\pic_code.h"\
	"..\libpic12\pic_inst.h"\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_asmd.h"\
	".\cmd_brch.h"\
	".\cmd_brdc.h"\
	".\cmd_opdc.h"\
	".\cmd_usec.h"\
	".\cmdd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\cmddelay.obj" : $(SOURCE) $(DEP_CPP_CMDDE) "$(INTDIR)"


!ENDIF 

SOURCE=.\expr.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_EXPR_=\
	"..\libutils\cache.h"\
	"..\libutils\mem.h"\
	".\expr.h"\
	".\exprd.h"\
	".\operator.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\expr.obj" : $(SOURCE) $(DEP_CPP_EXPR_) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_EXPR_=\
	"..\libutils\cache.h"\
	"..\libutils\mem.h"\
	".\expr.h"\
	".\exprd.h"\
	".\operator.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\expr.obj" : $(SOURCE) $(DEP_CPP_EXPR_) "$(INTDIR)"


!ENDIF 

SOURCE=.\exprnode.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_EXPRN=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\mem.h"\
	".\exprnode.h"\
	".\operator.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\exprnode.obj" : $(SOURCE) $(DEP_CPP_EXPRN) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_EXPRN=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\mem.h"\
	".\exprnode.h"\
	".\operator.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\exprnode.obj" : $(SOURCE) $(DEP_CPP_EXPRN) "$(INTDIR)"


!ENDIF 

SOURCE=.\label.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_LABEL=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	".\cmd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\label.obj" : $(SOURCE) $(DEP_CPP_LABEL) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_LABEL=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	".\cmd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\label.obj" : $(SOURCE) $(DEP_CPP_LABEL) "$(INTDIR)"


!ENDIF 

SOURCE=.\operator.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_OPERA=\
	"..\libutils\cache.h"\
	".\operator.h"\
	".\tag.h"\
	".\univ.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\operator.obj" : $(SOURCE) $(DEP_CPP_OPERA) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_OPERA=\
	"..\libutils\cache.h"\
	".\operator.h"\
	".\tag.h"\
	".\univ.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\operator.obj" : $(SOURCE) $(DEP_CPP_OPERA) "$(INTDIR)"


!ENDIF 

SOURCE=.\pf_block.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_PF_BL=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_blckd.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_block.obj" : $(SOURCE) $(DEP_CPP_PF_BL) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_PF_BL=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_blckd.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_block.obj" : $(SOURCE) $(DEP_CPP_PF_BL) "$(INTDIR)"


!ENDIF 

SOURCE=.\pf_cmd.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_PF_CM=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmd_brch.h"\
	".\cmd_log.h"\
	".\cmd_op.h"\
	".\cmd_usec.h"\
	".\expr.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_cmd.h"\
	".\pf_expr.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\pfiled.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_cmd.obj" : $(SOURCE) $(DEP_CPP_PF_CM) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_PF_CM=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmd_brch.h"\
	".\cmd_log.h"\
	".\cmd_op.h"\
	".\cmd_usec.h"\
	".\expr.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_cmd.h"\
	".\pf_expr.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\pfiled.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_cmd.obj" : $(SOURCE) $(DEP_CPP_PF_CM) "$(INTDIR)"


!ENDIF 

SOURCE=.\pf_expr.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_PF_EX=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_brch.h"\
	".\expr.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_cmd.h"\
	".\pf_expr.h"\
	".\pf_log.h"\
	".\pf_op.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\pfiled.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_expr.obj" : $(SOURCE) $(DEP_CPP_PF_EX) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_PF_EX=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\cmd_brch.h"\
	".\expr.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_cmd.h"\
	".\pf_expr.h"\
	".\pf_log.h"\
	".\pf_op.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\pfiled.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_expr.obj" : $(SOURCE) $(DEP_CPP_PF_EX) "$(INTDIR)"


!ENDIF 

SOURCE=.\pf_op.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_PF_OP=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\expr.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_expr.h"\
	".\pf_log.h"\
	".\pf_op.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_op.obj" : $(SOURCE) $(DEP_CPP_PF_OP) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_PF_OP=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\expr.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_expr.h"\
	".\pf_log.h"\
	".\pf_op.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_op.obj" : $(SOURCE) $(DEP_CPP_PF_OP) "$(INTDIR)"


!ENDIF 

SOURCE=.\pf_proc.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_PF_PR=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmdarray.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_proca.h"\
	".\pf_procd.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_proc.obj" : $(SOURCE) $(DEP_CPP_PF_PR) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_PF_PR=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmdarray.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_log.h"\
	".\pf_proc.h"\
	".\pf_proca.h"\
	".\pf_procd.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_proc.obj" : $(SOURCE) $(DEP_CPP_PF_PR) "$(INTDIR)"


!ENDIF 

SOURCE=.\pf_proca.c
DEP_CPP_PF_PRO=\
	"..\libutils\array.h"\
	".\pf_proca.h"\
	

"$(INTDIR)\pf_proca.obj" : $(SOURCE) $(DEP_CPP_PF_PRO) "$(INTDIR)"


SOURCE=.\pf_src.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_PF_SR=\
	"..\libutils\cache.h"\
	"..\libutils\mem.h"\
	".\pf_log.h"\
	".\pf_src.h"\
	".\pf_srcd.h"\
	".\univ.h"\
	

"$(INTDIR)\pf_src.obj" : $(SOURCE) $(DEP_CPP_PF_SR) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_PF_SR=\
	"..\libutils\cache.h"\
	"..\libutils\mem.h"\
	".\pf_log.h"\
	".\pf_src.h"\
	".\pf_srcd.h"\
	".\univ.h"\
	

"$(INTDIR)\pf_src.obj" : $(SOURCE) $(DEP_CPP_PF_SR) "$(INTDIR)"


!ENDIF 

SOURCE=.\pf_token.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_PF_TO=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_log.h"\
	".\pf_msg.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\pfiled.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_token.obj" : $(SOURCE) $(DEP_CPP_PF_TO) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_PF_TO=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	".\cmd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_log.h"\
	".\pf_msg.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\pfiled.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pf_token.obj" : $(SOURCE) $(DEP_CPP_PF_TO) "$(INTDIR)"


!ENDIF 

SOURCE=.\pfile.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_PFILE=\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmd_asm.h"\
	".\cmd_brch.h"\
	".\cmd_log.h"\
	".\cmd_op.h"\
	".\cmd_optm.h"\
	".\cmdarray.h"\
	".\expr.h"\
	".\exprnode.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_cmd.h"\
	".\pf_expr.h"\
	".\pf_log.h"\
	".\pf_msg.h"\
	".\pf_op.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\pfiled.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pfile.obj" : $(SOURCE) $(DEP_CPP_PFILE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_PFILE=\
	"..\libpic12\pic_opco.h"\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\cmd_asm.h"\
	".\cmd_brch.h"\
	".\cmd_log.h"\
	".\cmd_op.h"\
	".\cmd_optm.h"\
	".\cmdarray.h"\
	".\expr.h"\
	".\exprnode.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_cmd.h"\
	".\pf_expr.h"\
	".\pf_log.h"\
	".\pf_msg.h"\
	".\pf_op.h"\
	".\pf_proc.h"\
	".\pf_src.h"\
	".\pf_token.h"\
	".\pfile.h"\
	".\pfiled.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\pfile.obj" : $(SOURCE) $(DEP_CPP_PFILE) "$(INTDIR)"


!ENDIF 

SOURCE=.\tag.c
DEP_CPP_TAG_C=\
	"..\libutils\mem.h"\
	".\tag.h"\
	

"$(INTDIR)\tag.obj" : $(SOURCE) $(DEP_CPP_TAG_C) "$(INTDIR)"


SOURCE=.\value.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_VALUE=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	".\cmd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_proc.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\value.obj" : $(SOURCE) $(DEP_CPP_VALUE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_VALUE=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	".\cmd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_proc.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\value.obj" : $(SOURCE) $(DEP_CPP_VALUE) "$(INTDIR)"


!ENDIF 

SOURCE=.\vararray.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_VARAR=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	".\tag.h"\
	".\univ.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\vararray.obj" : $(SOURCE) $(DEP_CPP_VARAR) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_VARAR=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	".\tag.h"\
	".\univ.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\vararray.obj" : $(SOURCE) $(DEP_CPP_VARAR) "$(INTDIR)"


!ENDIF 

SOURCE=.\vardef.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_VARDE=\
	"..\libutils\cache.h"\
	"..\libutils\mem.h"\
	".\tag.h"\
	".\univ.h"\
	".\vardef.h"\
	".\vardefd.h"\
	".\variable.h"\
	

"$(INTDIR)\vardef.obj" : $(SOURCE) $(DEP_CPP_VARDE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_VARDE=\
	"..\libutils\cache.h"\
	"..\libutils\mem.h"\
	".\tag.h"\
	".\univ.h"\
	".\vardef.h"\
	".\vardefd.h"\
	".\variable.h"\
	

"$(INTDIR)\vardef.obj" : $(SOURCE) $(DEP_CPP_VARDE) "$(INTDIR)"


!ENDIF 

SOURCE=.\variable.c

!IF  "$(CFG)" == "libcore - Win32 Release"

DEP_CPP_VARIA=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_proc.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\variable.obj" : $(SOURCE) $(DEP_CPP_VARIA) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libcore - Win32 Debug"

DEP_CPP_VARIA=\
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\mem.h"\
	".\cmd.h"\
	".\label.h"\
	".\labelmap.h"\
	".\operator.h"\
	".\pf_block.h"\
	".\pf_proc.h"\
	".\tag.h"\
	".\univ.h"\
	".\value.h"\
	".\vararray.h"\
	".\vardef.h"\
	".\variable.h"\
	

"$(INTDIR)\variable.obj" : $(SOURCE) $(DEP_CPP_VARIA) "$(INTDIR)"


!ENDIF 


!ENDIF 

