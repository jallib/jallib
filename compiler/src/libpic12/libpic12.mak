# Microsoft Developer Studio Generated NMAKE File, Based on libpic12.dsp
!IF "$(CFG)" == ""
CFG=libpic12 - Win32 Debug
!MESSAGE No configuration specified. Defaulting to libpic12 - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "libpic12 - Win32 Release" && "$(CFG)" !=\
 "libpic12 - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
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
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe

!IF  "$(CFG)" == "libpic12 - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\libpic12.lib"

!ELSE 

ALL : "$(OUTDIR)\libpic12.lib"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\pic.obj"
	-@erase "$(INTDIR)\pic12.obj"
	-@erase "$(INTDIR)\pic14.obj"
	-@erase "$(INTDIR)\pic16.obj"
	-@erase "$(INTDIR)\pic_brop.obj"
	-@erase "$(INTDIR)\pic_cmdo.obj"
	-@erase "$(INTDIR)\pic_code.obj"
	-@erase "$(INTDIR)\pic_daop.obj"
	-@erase "$(INTDIR)\pic_emu.obj"
	-@erase "$(INTDIR)\pic_inst.obj"
	-@erase "$(INTDIR)\pic_op.obj"
	-@erase "$(INTDIR)\pic_opfn.obj"
	-@erase "$(INTDIR)\pic_stk.obj"
	-@erase "$(INTDIR)\pic_stvar.obj"
	-@erase "$(INTDIR)\pic_var.obj"
	-@erase "$(INTDIR)\pic_wopt.obj"
	-@erase "$(INTDIR)\picbsrop.obj"
	-@erase "$(INTDIR)\piccolst.obj"
	-@erase "$(INTDIR)\picdelay.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(OUTDIR)\libpic12.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)\libpic12.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Release/
CPP_SBRS=.
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\libpic12.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\libpic12.lib" 
LIB32_OBJS= \
	"$(INTDIR)\pic.obj" \
	"$(INTDIR)\pic12.obj" \
	"$(INTDIR)\pic14.obj" \
	"$(INTDIR)\pic16.obj" \
	"$(INTDIR)\pic_brop.obj" \
	"$(INTDIR)\pic_cmdo.obj" \
	"$(INTDIR)\pic_code.obj" \
	"$(INTDIR)\pic_daop.obj" \
	"$(INTDIR)\pic_emu.obj" \
	"$(INTDIR)\pic_inst.obj" \
	"$(INTDIR)\pic_op.obj" \
	"$(INTDIR)\pic_opfn.obj" \
	"$(INTDIR)\pic_stk.obj" \
	"$(INTDIR)\pic_stvar.obj" \
	"$(INTDIR)\pic_var.obj" \
	"$(INTDIR)\pic_wopt.obj" \
	"$(INTDIR)\picbsrop.obj" \
	"$(INTDIR)\piccolst.obj" \
	"$(INTDIR)\picdelay.obj"

"$(OUTDIR)\libpic12.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\libpic12.lib"

!ELSE 

ALL : "$(OUTDIR)\libpic12.lib"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\pic.obj"
	-@erase "$(INTDIR)\pic12.obj"
	-@erase "$(INTDIR)\pic14.obj"
	-@erase "$(INTDIR)\pic16.obj"
	-@erase "$(INTDIR)\pic_brop.obj"
	-@erase "$(INTDIR)\pic_cmdo.obj"
	-@erase "$(INTDIR)\pic_code.obj"
	-@erase "$(INTDIR)\pic_daop.obj"
	-@erase "$(INTDIR)\pic_emu.obj"
	-@erase "$(INTDIR)\pic_inst.obj"
	-@erase "$(INTDIR)\pic_op.obj"
	-@erase "$(INTDIR)\pic_opfn.obj"
	-@erase "$(INTDIR)\pic_stk.obj"
	-@erase "$(INTDIR)\pic_stvar.obj"
	-@erase "$(INTDIR)\pic_var.obj"
	-@erase "$(INTDIR)\pic_wopt.obj"
	-@erase "$(INTDIR)\picbsrop.obj"
	-@erase "$(INTDIR)\piccolst.obj"
	-@erase "$(INTDIR)\picdelay.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(OUTDIR)\libpic12.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MLd /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)\libpic12.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\libpic12.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\libpic12.lib" 
LIB32_OBJS= \
	"$(INTDIR)\pic.obj" \
	"$(INTDIR)\pic12.obj" \
	"$(INTDIR)\pic14.obj" \
	"$(INTDIR)\pic16.obj" \
	"$(INTDIR)\pic_brop.obj" \
	"$(INTDIR)\pic_cmdo.obj" \
	"$(INTDIR)\pic_code.obj" \
	"$(INTDIR)\pic_daop.obj" \
	"$(INTDIR)\pic_emu.obj" \
	"$(INTDIR)\pic_inst.obj" \
	"$(INTDIR)\pic_op.obj" \
	"$(INTDIR)\pic_opfn.obj" \
	"$(INTDIR)\pic_stk.obj" \
	"$(INTDIR)\pic_stvar.obj" \
	"$(INTDIR)\pic_var.obj" \
	"$(INTDIR)\pic_wopt.obj" \
	"$(INTDIR)\picbsrop.obj" \
	"$(INTDIR)\piccolst.obj" \
	"$(INTDIR)\picdelay.obj"

"$(OUTDIR)\libpic12.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
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


!IF "$(CFG)" == "libpic12 - Win32 Release" || "$(CFG)" ==\
 "libpic12 - Win32 Debug"
SOURCE=.\pic.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC_C=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_asm.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\cmd_op.h"\
	"..\libcore\cmd_usec.h"\
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
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\pic.h"\
	".\pic12.h"\
	".\pic14.h"\
	".\pic16.h"\
	".\pic_brop.h"\
	".\pic_code.h"\
	".\pic_daop.h"\
	".\pic_emu.h"\
	".\pic_inst.h"\
	".\pic_msg.h"\
	".\pic_op.h"\
	".\pic_opco.h"\
	".\pic_opfn.h"\
	".\pic_stk.h"\
	".\pic_stvar.h"\
	".\pic_var.h"\
	".\pic_wopt.h"\
	".\picbsrop.h"\
	".\piccolst.h"\
	".\picdelay.h"\
	

"$(INTDIR)\pic.obj" : $(SOURCE) $(DEP_CPP_PIC_C) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC_C=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_asm.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\cmd_op.h"\
	"..\libcore\cmd_usec.h"\
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
	"..\libutils\array.h"\
	"..\libutils\cache.h"\
	"..\libutils\cod_file.h"\
	"..\libutils\mem.h"\
	".\pic.h"\
	".\pic12.h"\
	".\pic14.h"\
	".\pic16.h"\
	".\pic_brop.h"\
	".\pic_code.h"\
	".\pic_daop.h"\
	".\pic_emu.h"\
	".\pic_inst.h"\
	".\pic_msg.h"\
	".\pic_op.h"\
	".\pic_opco.h"\
	".\pic_opfn.h"\
	".\pic_stk.h"\
	".\pic_stvar.h"\
	".\pic_var.h"\
	".\pic_wopt.h"\
	".\picbsrop.h"\
	".\piccolst.h"\
	".\picdelay.h"\
	

"$(INTDIR)\pic.obj" : $(SOURCE) $(DEP_CPP_PIC_C) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic12.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC12=\
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
	".\pic.h"\
	".\pic12.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	

"$(INTDIR)\pic12.obj" : $(SOURCE) $(DEP_CPP_PIC12) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC12=\
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
	".\pic.h"\
	".\pic12.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	

"$(INTDIR)\pic12.obj" : $(SOURCE) $(DEP_CPP_PIC12) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic14.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC14=\
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
	".\pic.h"\
	".\pic14.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	

"$(INTDIR)\pic14.obj" : $(SOURCE) $(DEP_CPP_PIC14) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC14=\
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
	".\pic.h"\
	".\pic14.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	

"$(INTDIR)\pic14.obj" : $(SOURCE) $(DEP_CPP_PIC14) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic16.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC16=\
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
	".\pic.h"\
	".\pic16.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	

"$(INTDIR)\pic16.obj" : $(SOURCE) $(DEP_CPP_PIC16) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC16=\
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
	".\pic.h"\
	".\pic16.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	

"$(INTDIR)\pic16.obj" : $(SOURCE) $(DEP_CPP_PIC16) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic_brop.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC_B=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_brop.h"\
	".\pic_code.h"\
	".\pic_inst.h"\
	".\pic_msg.h"\
	".\pic_opco.h"\
	".\pic_opfn.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_brop.obj" : $(SOURCE) $(DEP_CPP_PIC_B) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC_B=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_brop.h"\
	".\pic_code.h"\
	".\pic_inst.h"\
	".\pic_msg.h"\
	".\pic_opco.h"\
	".\pic_opfn.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_brop.obj" : $(SOURCE) $(DEP_CPP_PIC_B) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic_cmdo.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC_CM=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\cmd_op.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_cmdo.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	

"$(INTDIR)\pic_cmdo.obj" : $(SOURCE) $(DEP_CPP_PIC_CM) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC_CM=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_brch.h"\
	"..\libcore\cmd_op.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_cmdo.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	

"$(INTDIR)\pic_cmdo.obj" : $(SOURCE) $(DEP_CPP_PIC_CM) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic_code.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC_CO=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_asm.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	

"$(INTDIR)\pic_code.obj" : $(SOURCE) $(DEP_CPP_PIC_CO) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC_CO=\
	"..\libcore\cmd.h"\
	"..\libcore\cmd_asm.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	

"$(INTDIR)\pic_code.obj" : $(SOURCE) $(DEP_CPP_PIC_CO) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic_daop.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC_D=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_daop.h"\
	".\pic_msg.h"\
	".\pic_opco.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_daop.obj" : $(SOURCE) $(DEP_CPP_PIC_D) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC_D=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_daop.h"\
	".\pic_msg.h"\
	".\pic_opco.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_daop.obj" : $(SOURCE) $(DEP_CPP_PIC_D) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic_emu.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC_E=\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_emu.h"\
	".\pic_inst.h"\
	".\pic_opco.h"\
	".\pic_var.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_emu.obj" : $(SOURCE) $(DEP_CPP_PIC_E) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC_E=\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_emu.h"\
	".\pic_inst.h"\
	".\pic_opco.h"\
	".\pic_var.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_emu.obj" : $(SOURCE) $(DEP_CPP_PIC_E) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic_inst.c
DEP_CPP_PIC_I=\
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
	".\pic.h"\
	".\pic12.h"\
	".\pic14.h"\
	".\pic16.h"\
	".\pic_code.h"\
	".\pic_inst.h"\
	".\pic_opco.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_inst.obj" : $(SOURCE) $(DEP_CPP_PIC_I) "$(INTDIR)"


SOURCE=.\pic_op.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC_O=\
	"..\libcore\cmd.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_op.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_inst.h"\
	".\pic_op.h"\
	".\pic_opco.h"\
	".\pic_opfn.h"\
	".\pic_stvar.h"\
	".\pic_var.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_op.obj" : $(SOURCE) $(DEP_CPP_PIC_O) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC_O=\
	"..\libcore\cmd.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
	"..\libcore\pf_expr.h"\
	"..\libcore\pf_log.h"\
	"..\libcore\pf_op.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_inst.h"\
	".\pic_op.h"\
	".\pic_opco.h"\
	".\pic_opfn.h"\
	".\pic_stvar.h"\
	".\pic_var.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_op.obj" : $(SOURCE) $(DEP_CPP_PIC_O) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic_opfn.c
DEP_CPP_PIC_OP=\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_inst.h"\
	".\pic_op.h"\
	".\pic_opco.h"\
	".\pic_opfn.h"\
	".\pic_stvar.h"\
	

"$(INTDIR)\pic_opfn.obj" : $(SOURCE) $(DEP_CPP_PIC_OP) "$(INTDIR)"


SOURCE=.\pic_stk.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC_S=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	".\pic_stk.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_stk.obj" : $(SOURCE) $(DEP_CPP_PIC_S) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC_S=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	".\pic_stk.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_stk.obj" : $(SOURCE) $(DEP_CPP_PIC_S) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic_stvar.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC_ST=\
	"..\libcore\cmd.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_inst.h"\
	".\pic_op.h"\
	".\pic_opco.h"\
	".\pic_stvar.h"\
	".\pic_var.h"\
	

"$(INTDIR)\pic_stvar.obj" : $(SOURCE) $(DEP_CPP_PIC_ST) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC_ST=\
	"..\libcore\cmd.h"\
	"..\libcore\expr.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_inst.h"\
	".\pic_op.h"\
	".\pic_opco.h"\
	".\pic_stvar.h"\
	".\pic_var.h"\
	

"$(INTDIR)\pic_stvar.obj" : $(SOURCE) $(DEP_CPP_PIC_ST) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic_var.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC_V=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_msg.h"\
	".\pic_opco.h"\
	".\pic_stvar.h"\
	".\pic_var.h"\
	

"$(INTDIR)\pic_var.obj" : $(SOURCE) $(DEP_CPP_PIC_V) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC_V=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_msg.h"\
	".\pic_opco.h"\
	".\pic_stvar.h"\
	".\pic_var.h"\
	

"$(INTDIR)\pic_var.obj" : $(SOURCE) $(DEP_CPP_PIC_V) "$(INTDIR)"


!ENDIF 

SOURCE=.\pic_wopt.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PIC_W=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	".\pic_wopt.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_wopt.obj" : $(SOURCE) $(DEP_CPP_PIC_W) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PIC_W=\
	"..\libcore\cmd.h"\
	"..\libcore\label.h"\
	"..\libcore\labelmap.h"\
	"..\libcore\operator.h"\
	"..\libcore\pf_block.h"\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	".\pic_wopt.h"\
	".\piccolst.h"\
	

"$(INTDIR)\pic_wopt.obj" : $(SOURCE) $(DEP_CPP_PIC_W) "$(INTDIR)"


!ENDIF 

SOURCE=.\picbsrop.c

!IF  "$(CFG)" == "libpic12 - Win32 Release"

DEP_CPP_PICBS=\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_msg.h"\
	".\pic_opco.h"\
	".\picbsrop.h"\
	".\piccolst.h"\
	

"$(INTDIR)\picbsrop.obj" : $(SOURCE) $(DEP_CPP_PICBS) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libpic12 - Win32 Debug"

DEP_CPP_PICBS=\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_msg.h"\
	".\pic_opco.h"\
	".\picbsrop.h"\
	".\piccolst.h"\
	

"$(INTDIR)\picbsrop.obj" : $(SOURCE) $(DEP_CPP_PICBS) "$(INTDIR)"


!ENDIF 

SOURCE=.\piccolst.c
DEP_CPP_PICCO=\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_opco.h"\
	".\piccolst.h"\
	

"$(INTDIR)\piccolst.obj" : $(SOURCE) $(DEP_CPP_PICCO) "$(INTDIR)"


SOURCE=.\picdelay.c
DEP_CPP_PICDE=\
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
	".\pic.h"\
	".\pic_code.h"\
	".\pic_inst.h"\
	".\pic_opco.h"\
	".\pic_stvar.h"\
	".\picdelay.h"\
	

"$(INTDIR)\picdelay.obj" : $(SOURCE) $(DEP_CPP_PICDE) "$(INTDIR)"



!ENDIF 

