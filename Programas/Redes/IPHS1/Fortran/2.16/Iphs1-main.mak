# Microsoft Developer Studio Generated NMAKE File, Format Version 4.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=Iphs1-main - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to Iphs1-main - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Iphs1-main - Win32 Release" && "$(CFG)" !=\
 "Iphs1-main - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "Iphs1-main.mak" CFG="Iphs1-main - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Iphs1-main - Win32 Release" (based on\
 "Win32 (x86) Console Application")
!MESSAGE "Iphs1-main - Win32 Debug" (based on\
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
F90=fl32.exe
RSC=rc.exe

!IF  "$(CFG)" == "Iphs1-main - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\Iphs1-main.exe"

CLEAN : 
	-@erase ".\Iphs1-main.exe"
	-@erase ".\Iphs1-main.obj"

# ADD BASE F90 /Ox /c /nologo
# ADD F90 /Ox /c /nologo
F90_PROJ=/Ox /c /nologo 
# ADD BASE RSC /l 0x416 /d "NDEBUG"
# ADD RSC /l 0x416 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Iphs1-main.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib /nologo /subsystem:console /machine:I386
LINK32_FLAGS=kernel32.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)/Iphs1-main.pdb" /machine:I386 /out:"$(OUTDIR)/Iphs1-main.exe" 
LINK32_OBJS= \
	"$(INTDIR)/Iphs1-main.obj"

"$(OUTDIR)\Iphs1-main.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Iphs1-main - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\Iphs1-main.exe"

CLEAN : 
	-@erase ".\Iphs1-main.exe"
	-@erase ".\Iphs1-main.obj"
	-@erase ".\Iphs1-main.ilk"
	-@erase ".\Iphs1-main.pdb"

# ADD BASE F90 /Zi /c /nologo
# ADD F90 /Zi /c /nologo
F90_PROJ=/Zi /c /nologo /Fd"Iphs1-main.pdb" 
# ADD BASE RSC /l 0x416 /d "_DEBUG"
# ADD RSC /l 0x416 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Iphs1-main.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 kernel32.lib /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS=kernel32.lib /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)/Iphs1-main.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)/Iphs1-main.exe" 
LINK32_OBJS= \
	"$(INTDIR)/Iphs1-main.obj"

"$(OUTDIR)\Iphs1-main.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "Iphs1-main - Win32 Release"
# Name "Iphs1-main - Win32 Debug"

!IF  "$(CFG)" == "Iphs1-main - Win32 Release"

!ELSEIF  "$(CFG)" == "Iphs1-main - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=".\Iphs1-main.for"
DEP_F90_IPHS1=\
	".\var.mod"\
	".\varcont.mod"\
	

"$(INTDIR)\Iphs1-main.obj" : $(SOURCE) $(DEP_F90_IPHS1) "$(INTDIR)"


# End Source File
# End Target
# End Project
################################################################################
