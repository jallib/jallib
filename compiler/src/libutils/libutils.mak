# Microsoft Developer Studio Generated NMAKE File, Based on libutils.dsp
!IF "$(CFG)" == ""
CFG=libutils - Win32 Debug
!MESSAGE No configuration specified. Defaulting to libutils - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "libutils - Win32 Release" && "$(CFG)" !=\
 "libutils - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "libutils.mak" CFG="libutils - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "libutils - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "libutils - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe

!IF  "$(CFG)" == "libutils - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\libutils.lib"

!ELSE 

ALL : "$(OUTDIR)\libutils.lib"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\array.obj"
	-@erase "$(INTDIR)\cache.obj"
	-@erase "$(INTDIR)\cod_file.obj"
	-@erase "$(INTDIR)\mem.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(OUTDIR)\libutils.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)\libutils.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Release/
CPP_SBRS=.
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\libutils.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\libutils.lib" 
LIB32_OBJS= \
	"$(INTDIR)\array.obj" \
	"$(INTDIR)\cache.obj" \
	"$(INTDIR)\cod_file.obj" \
	"$(INTDIR)\mem.obj"

"$(OUTDIR)\libutils.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ELSEIF  "$(CFG)" == "libutils - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\libutils.lib"

!ELSE 

ALL : "$(OUTDIR)\libutils.lib"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\array.obj"
	-@erase "$(INTDIR)\cache.obj"
	-@erase "$(INTDIR)\cod_file.obj"
	-@erase "$(INTDIR)\mem.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(OUTDIR)\libutils.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MLd /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)\libutils.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\libutils.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\libutils.lib" 
LIB32_OBJS= \
	"$(INTDIR)\array.obj" \
	"$(INTDIR)\cache.obj" \
	"$(INTDIR)\cod_file.obj" \
	"$(INTDIR)\mem.obj"

"$(OUTDIR)\libutils.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
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


!IF "$(CFG)" == "libutils - Win32 Release" || "$(CFG)" ==\
 "libutils - Win32 Debug"
SOURCE=.\array.c

!IF  "$(CFG)" == "libutils - Win32 Release"

DEP_CPP_ARRAY=\
	".\array.h"\
	".\mem.h"\
	

"$(INTDIR)\array.obj" : $(SOURCE) $(DEP_CPP_ARRAY) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "libutils - Win32 Debug"

DEP_CPP_ARRAY=\
	".\array.h"\
	".\mem.h"\
	

"$(INTDIR)\array.obj" : $(SOURCE) $(DEP_CPP_ARRAY) "$(INTDIR)"


!ENDIF 

SOURCE=.\cache.c
DEP_CPP_CACHE=\
	".\cache.h"\
	".\mem.h"\
	".\types.h"\
	

"$(INTDIR)\cache.obj" : $(SOURCE) $(DEP_CPP_CACHE) "$(INTDIR)"


SOURCE=.\cod_file.c
DEP_CPP_COD_F=\
	".\array.h"\
	".\cod_file.h"\
	

"$(INTDIR)\cod_file.obj" : $(SOURCE) $(DEP_CPP_COD_F) "$(INTDIR)"


SOURCE=.\mem.c
DEP_CPP_MEM_C=\
	".\mem.h"\
	

"$(INTDIR)\mem.obj" : $(SOURCE) $(DEP_CPP_MEM_C) "$(INTDIR)"



!ENDIF 

