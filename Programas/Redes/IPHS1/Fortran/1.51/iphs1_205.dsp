# Microsoft Developer Studio Project File - Name="iphs1_205" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=iphs1_205 - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "iphs1_205.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "iphs1_205.mak" CFG="iphs1_205 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "iphs1_205 - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "iphs1_205 - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
F90=df.exe
RSC=rc.exe

!IF  "$(CFG)" == "iphs1_205 - Win32 Release"

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
# ADD BASE F90 /compile_only /nologo /warn:nofileopt
# ADD F90 /compile_only /nologo /warn:nofileopt
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD BASE RSC /l 0x416 /d "NDEBUG"
# ADD RSC /l 0x416 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib /nologo /subsystem:console /machine:I386

!ELSEIF  "$(CFG)" == "iphs1_205 - Win32 Debug"

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
# ADD BASE F90 /check:bounds /compile_only /dbglibs /debug:full /nologo /traceback /warn:argument_checking /warn:nofileopt
# ADD F90 /check:bounds /compile_only /dbglibs /debug:full /nologo /traceback /warn:argument_checking /warn:nofileopt
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD BASE RSC /l 0x416 /d "_DEBUG"
# ADD RSC /l 0x416 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib /nologo /subsystem:console /incremental:no /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "iphs1_205 - Win32 Release"
# Name "iphs1_205 - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat;f90;for;f;fpp"
# Begin Source File

SOURCE=.\Amc.for
NODEP_F90_AMC_F=\
	".\Debug\VAR.MOD"\
	
# End Source File
# Begin Source File

SOURCE=.\Amcp.for
NODEP_F90_AMCP_=\
	".\Debug\VAR.MOD"\
	
# End Source File
# Begin Source File

SOURCE=.\AMCPFECH.for
NODEP_F90_AMCPF=\
	".\Debug\VAR.MOD"\
	
# End Source File
# Begin Source File

SOURCE=.\Amusk.for
# End Source File
# Begin Source File

SOURCE=.\Chuvap.for
# End Source File
# Begin Source File

SOURCE=.\Clark.for
# End Source File
# Begin Source File

SOURCE=.\Deriv.for
# End Source File
# Begin Source File

SOURCE=.\divide.for
# End Source File
# Begin Source File

SOURCE=.\Ebase.for
# End Source File
# Begin Source File

SOURCE=.\excessos.for
# End Source File
# Begin Source File

SOURCE=.\Fi.for
# End Source File
# Begin Source File

SOURCE=.\Fint.for
# End Source File
# Begin Source File

SOURCE=.\Funcd.for
# End Source File
# Begin Source File

SOURCE=.\Funcd2.for
# End Source File
# Begin Source File

SOURCE=.\Hec1.for
# End Source File
# Begin Source File

SOURCE=.\Hid.for
# End Source File
# Begin Source File

SOURCE=.\Hidt.for
# End Source File
# Begin Source File

SOURCE=.\Holtan.for
# End Source File
# Begin Source File

SOURCE=.\Hu.for
# End Source File
# Begin Source File

SOURCE=.\Iphii.for
# End Source File
# Begin Source File

SOURCE=.\Iphmen.for
# End Source File
# Begin Source File

SOURCE=".\Iphs1-main.for"
NODEP_F90_IPHS1=\
	".\Debug\VAR.MOD"\
	
# End Source File
# Begin Source File

SOURCE=.\Nash.for
# End Source File
# Begin Source File

SOURCE=.\Newt2.for
# End Source File
# Begin Source File

SOURCE=.\Newtrap.for
NODEP_F90_NEWTR=\
	".\Debug\VAR.MOD"\
	
# End Source File
# Begin Source File

SOURCE=.\Plota.for
# End Source File
# Begin Source File

SOURCE=.\Precip.for
# End Source File
# Begin Source File

SOURCE=.\Propr.for
# End Source File
# Begin Source File

SOURCE=.\Puls.for
NODEP_F90_PULS_=\
	".\Debug\VAR.MOD"\
	
# End Source File
# Begin Source File

SOURCE=.\Scs.for
# End Source File
# Begin Source File

SOURCE=.\Soma.for
# End Source File
# Begin Source File

SOURCE=.\Tcv.for
# End Source File
# Begin Source File

SOURCE=.\VAR.F90
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl;fi;fd"
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# End Group
# End Target
# End Project
