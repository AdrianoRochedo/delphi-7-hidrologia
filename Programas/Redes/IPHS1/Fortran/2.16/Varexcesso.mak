# Microsoft Developer Studio Generated NMAKE File, Format Version 4.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=Varexcesso - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to Varexcesso - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Varexcesso - Win32 Release" && "$(CFG)" !=\
 "Varexcesso - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "Varexcesso.mak" CFG="Varexcesso - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Varexcesso - Win32 Release" (based on\
 "Win32 (x86) Console Application")
!MESSAGE "Varexcesso - Win32 Debug" (based on\
 "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 
################################################################################
# Begin Project
RSC=rc.exe
F90=fl32.exe

!IF  "$(CFG)" == "Varexcesso - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\Varexcesso.exe"

CLEAN : 
	-@erase ".\Varexcesso.exe"
	-@erase ".\Varexcesso.obj"

# ADD BASE F90 /Ox /c /nologo
# ADD F90 /Ox /c /nologo
F90_PROJ=/Ox /c /nologo 
# ADD BASE RSC /l 0x416 /d "NDEBUG"
# ADD RSC /l 0x416 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Varexcesso.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib /nologo /subsystem:console /machine:I386
LINK32_FLAGS=kernel32.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)/Varexcesso.pdb" /machine:I386 /out:"$(OUTDIR)/Varexcesso.exe" 
LINK32_OBJS= \
	"$(INTDIR)/Varexcesso.obj"

"$(OUTDIR)\Varexcesso.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Varexcesso - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\Varexcesso.exe"

CLEAN : 
	-@erase ".\Varexcesso.exe"
	-@erase ".\Varexcesso.obj"
	-@erase ".\Varexcesso.ilk"
	-@erase ".\Varexcesso.pdb"

# ADD BASE F90 /Zi /c /nologo
# ADD F90 /Zi /c /nologo
F90_PROJ=/Zi /c /nologo /Fd"Varexcesso.pdb" 
# ADD BASE RSC /l 0x416 /d "_DEBUG"
# ADD RSC /l 0x416 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Varexcesso.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 kernel32.lib /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS=kernel32.lib /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)/Varexcesso.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)/Varexcesso.exe" 
LINK32_OBJS= \
	"$(INTDIR)/Varexcesso.obj"

"$(OUTDIR)\Varexcesso.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.for.obj:
   $(F90) $(F90_PROJ) $<  

.f.obj:
   $(F90) $(F90_PROJ) $<  

.f90.obj:
   $(F90) $(F90_PROJ) $<  

################################################################################
# Begin Target

# Name "Varexcesso - Win32 Release"
# Name "Varexcesso - Win32 Debug"

!IF  "$(CFG)" == "Varexcesso - Win32 Release"

!ELSEIF  "$(CFG)" == "Varexcesso - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\Varexcesso.f90

!IF  "$(CFG)" == "Varexcesso - Win32 Release"

F90_MODOUT=\
	"VARexcesso"


"$(INTDIR)\Varexcesso.obj" : $(SOURCE) "$(INTDIR)"
   $(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "Varexcesso - Win32 Debug"

F90_MODOUT=\
	"VARexcesso"


"$(INTDIR)\Varexcesso.obj" : $(SOURCE) "$(INTDIR)"
   $(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
