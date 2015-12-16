#/***********************************************************************
# * Licensed Materials - Property of IBM 
# *
# * IBM SPSS Products: Statistics Common
# *
# * (C) Copyright IBM Corp. 1989, 2013
# *
# * US Government Users Restricted Rights - Use, duplication or disclosure
# * restricted by GSA ADP Schedule Contract with IBM Corp. 
# ************************************************************************/

##########################################################################
# NAME
#
#   invokeR.mak  - To build InvokeR.dll
#
# SYNOPSIS
#
#   nmake -f [path]invokeR.mak PLATFORM=<platformname>
#
#   PLATFORM:  By setting the environment variable "PLATFORM", you can
#   build 32-bit or 64-bit InvokeR.dll. The following values exist for
#   various platform:
#       Win32(default)  - Build the 32-bit .dll
#       Win64           - Build the 64-bit .dll for AMD64 or intel EMT64
#
#
# EXAMPLE
#
#   To build 32-bit InvokeR.dll.....
#
#   nmake -f invokeR.mak
#
#   To build 64-bit InvokeR.dll.....
#
#   nmake -f invokeR.mak PLATFORM = Win64
#
#
# PREREQUISITES:
#
#   Environment variables which must be set prior to the calling of this makefile.
#     R_HOME - must be defined as the installation directory of R
#
#   Visual Studio 2008 must be installed for building 32-bit and 64-bit .dll
#
# OPTIONS: Environment variables which affect what invokeR.mak does
#
#   DEBUG - If defined, CodeView symbols will be included
#
#########################################################################


#   --  ensure all needed environment variables are set before beginning

!if !defined(R_HOME)
!       ERROR R_HOME - must be defined as the installation directory of R (ie R_HOME="C:\Program Files\R\R-2.15.2")
!endif
R_HOME = "$(R_HOME)"


#   --  Specify the extension of the default target
DEFAULT_TARGET=DLL

#   --  Specify the platform.
!if defined(PLATFORM)
PLATFORM = $(PLATFORM)
!elseif defined(platform)
PLATFORM = $(platform)
!else
PLATFORM = Win32
!endif

#   --  Specify the mode of build - Release, or Debug
!if defined(Debug)
MODE = Debug
!elseif defined(DEBUG)
MODE = Debug
!else
MODE = Release
!endif

#   --  Where your source files are put into
SRC_DIR = ..\

#   --  Pick up the header files
INC_PATH = \
           -I $(R_HOME)\include \
           -I $(R_HOME)\include\R_ext \
           -I $(SRC_DIR)
          
#   --  Pick up the libraries files
LIB_PATH = .\libs

#   --  Where the created files will be put into, such as .obj, .res, .dll, .lib
!if "$(PLATFORM)" == "Win64" || "$(PLATFORM)" == "win64" || "$(PLATFORM)" == "WIN64"
OUT_DIR = $(SRC_DIR)\X64\$(MODE)
!else
OUT_DIR = $(SRC_DIR)\$(MODE)
!endif

VERSIONINF=$(SRC_DIR)\InvokeR.res

#   --  We need the libraries plus
!if "$(MODE)" == "Debug"
LIBS_LIST = Rdll.lib Rgraphapp.lib
!else
LIBS_LIST = Rdll.lib Rgraphapp.lib
!endif

LIBS_LIST = $(LIBS_LIST) \
            advapi32.lib User32.lib

#   -- Define macros
MACROS = -DINVOKER_EXPORTS \
         -DWIN32 \
         -DWin32 \
         -D_WINDOWS \
         -DMS_WINDOWS \
         -D_USRDLL \
         -D_WINDLL \
         -D_MBCS \
         -DHAVE_INTPTR_T \
         -DHAVE_UINTPTR_T \
         -DHAS_WINDOWS_THREADS=1 \
         -DRETSIGTYPE=void \
         -DDEFN_H_ \
         -DSTATR_EXPORTS

!if "$(MODE)" == "Debug"
MACROS = $(MACROS) -DDEBUG
!else
MACROS = $(MACROS) -DNDEBUG
!endif

!if "$(PLATFORM)" == "Win64" || "$(PLATFORM)" == "win64" || "$(PLATFORM)" == "WIN64"
MACROS = $(MACROS) -D_M_AMD64
MACROS = $(MACROS) -D_AMD64_
MACROS = $(MACROS) -U_X86_
!else
MACROS = $(MACROS) -DWIN32
!endif

CPPOPTS = $(MACROS)
CPPOPTS = $(CPPOPTS) -O2                        # maximize speed
CPPOPTS = $(CPPOPTS) -GS                       # disable security checks
CPPOPTS = $(CPPOPTS) -Zi                        # enable debugging information
CPPOPTS = $(CPPOPTS) -TC                        # compile all files as .cpp
CPPOPTS = $(CPPOPTS) -MD                        # don't link with LIBCMT.LIB
CPPOPTS = $(CPPOPTS) -W3                        # warning level
CPPOPTS = $(CPPOPTS) -nologo                    # suppress copyright message
CPPOPTS = $(CPPOPTS) -c                         # compile only, no link
CPPOPTS = $(CPPOPTS) -Wp64                      # enable 64 bit porting warnings
CPPOPTS = $(CPPOPTS) -EHsc                      # Specifies the model of exception handling
CPPOPTS = $(CPPOPTS) -FD
CPPOPTS = $(CPPOPTS) -Fo$(OUT_DIR)\             # name object file
CPPOPTS = $(CPPOPTS) -Fd$(OUT_DIR)\InvokeR.pdb     # name pdb file
!if "$(PLATFORM)" == "Win64" || "$(PLATFORM)" == "win64" || "$(PLATFORM)" == "WIN64"
CPPOPTS = $(CPPOPTS) -Zc:wchar_t
!endif

LINKOPTS =
LINKOPTS = $(LINKOPTS) -INCREMENTAL:NO                         # override default incremental link
LINKOPTS = $(LINKOPTS) -NOLOGO                                 # Suppresses startup banner
LINKOPTS = $(LINKOPTS) -$(DEFAULT_TARGET)                      # extension of target
LINKOPTS = $(LINKOPTS) -LIBPATH:$(LIB_PATH)                    # override the environmental library path
LINKOPTS = $(LINKOPTS) -SUBSYSTEM:WINDOWS                      # Tells the operating system how to run the .exe file
LINKOPTS = $(LINKOPTS) -OPT:REF                                # Controls LINK optimizations
LINKOPTS = $(LINKOPTS) -OPT:ICF                                # Controls LINK optimizations
LINKOPTS = $(LINKOPTS) -IMPLIB:$(OUT_DIR)\InvokeR.lib     # Overrides the default import library name
LINKOPTS = $(LINKOPTS) -PDB:$(OUT_DIR)\InvokeR.pdb        # Creates a program database (PDB) file
LINKOPTS = $(LINKOPTS) -DEBUG                                  # Creates debugging information
LINKOPTS = $(LINKOPTS) -MANIFEST
LINKOPTS = $(LINKOPTS) -MANIFESTFILE:$(OUT_DIR)\InvokeR.dll.intermediate.manifest
!if "$(PLATFORM)" == "Win64" || "$(PLATFORM)" == "win64" || "$(PLATFORM)" == "WIN64"
LINKOPTS = $(LINKOPTS) -MACHINE:X64                            # Specifies the target platform
!else
LINKOPTS = $(LINKOPTS) -MACHINE:X86                            # Specifies the target platform
!endif


CC = cl
LD = link

#   --  Do build

default:InvokeR.dll
InvokeR.dll:embedded.obj
	$(LD) $(LINKOPTS) -OUT:$(OUT_DIR)\InvokeR.dll $(LIBS_LIST) $(VERSIONINF) $(OUT_DIR)\embedded.obj


embedded.obj:$(SRC_DIR)/embedded.cpp
    if exist $(OUT_DIR). rd /s/q $(OUT_DIR)
	md $(OUT_DIR)
	$(CC) $(CPPOPTS) -o:$(OUT_DIR)\embedded.obj $(INC_PATH) $(SRC_DIR)\embedded.cpp
