#/***********************************************************************
# * Licensed Materials - Property of IBM 
# *
# * IBM SPSS Products: Statistics Common
# *
# * (C) Copyright IBM Corp. 1989, 2012
# *
# * US Government Users Restricted Rights - Use, duplication or disclosure
# * restricted by GSA ADP Schedule Contract with IBM Corp. 
# ************************************************************************/

##########################################################################
#
# FILE : invokeR.mk
#
# PURPOSE : This file is used to build libInvokeR.so on unix.
#
# USAGE SYNOPSIS:
#       (g)make -f [path]invokeR.mk
#        if you need 64 bit lib on linux,use 
#       (g)make -f [path]invokeR.mk PLATFORM=64
#
# PREREQUISITES: Environment variables which must be set prior to the
#       calling of this makefile.
#
#   R_HOME - must be defined as the installation directory of R.
#
# Copyright (c) 2005 SPSS Inc. All rights reserved.
#
#########################################################################


#   --  ensure all needed environment variables are set before beginning
ifndef R_HOME
%: forceabort
	@echo "ERROR: R_HOME not defined"
	@exit 1
forceabort: ;
endif


MACHINE = $(shell uname)

#   --  Define DIRNAME for different platform
ifeq ($(MACHINE),AIX)
    DIRNAME= aix64
    INVOKE_NAME=libInvokeR.so
endif

ifeq ($(MACHINE), SunOS)
    DIRNAME= solaris_sparc64
    INVOKE_NAME=libInvokeR.so
endif

ifeq ($(MACHINE),Linux)
    HARDWARE = $(shell uname -i)
    ifeq ($(HARDWARE),s390x)
        ifeq ($(PLATFORM),64)
            DIRNAME= zlinux64
        else
            DIRNAME= zlinux
        endif
    else
        ifeq ($(PLATFORM),64)
            DIRNAME= lintel64
        else
            DIRNAME= lintel
        endif
    endif
    INVOKE_NAME=libInvokeR.so
endif

ifeq ($(MACHINE), HP-UX)
    DIRNAME= hpux_it
    INVOKE_NAME=libInvokeR.sl
endif

ifeq ($(MACHINE),Darwin)
    DIRNAME= macosx
    INVOKE_NAME=libInvokeR.dylib
    CFLAGS += -DUNX_MACOSX
#   --  Define Mac machine type i386, it will be assigned a value only on Mac platform.
    MAC_ARCH_I386= -arch i386
endif

OBJECT_NAME=embedded.o 

#   --  Where your source files are put into
SRC_DIR = ./..

#   --  Where the created files will be put into, such as .o, .so
OUT_DIR = $(SRC_DIR)/$(DIRNAME)


#   --  Pick up the header files
INC_PATH= \
         -I$(R_HOME)/lib/R/include/R_ext \
         -I$(R_HOME)/lib/R/include \
         -I$(SRC_DIR) \
         -I/usr/local/include \
         -I.

#   --  Pick up the libraries files
LIB_PATH= \
         -L$(R_HOME)/lib/R/lib \
         -L/usr/local/lib \
         -L.

#   --  We need the libraries plus
LIBS =  -lR -lm -ldl

#   -- Define compile and link options for different platform
ifeq ($(MACHINE), AIX)
        MACROS = \
        		-D_LARGE_FILES \
        		-DAIX \
        		-DVA40 \
        		-DUNIX \
        		-Dunix \
        		-D_BIG_ENDIAN \
        		-D_BigEndian \
        		-DREQUIRE_LOGIN \
        		-DLP64

        CC = xlC_r -q64
        CXX= xlC_r
        CFLAGS+= \
        		-qlanglvl=extc99 \
        		-qopt=3 \
        		-qstrict \
        		$(MACROS) \
        		-c \
        		-O \
        		-qrtti=all \
        		-qlibansi \
        		-qthreaded \
        		-qstaticinline \
        		-qlonglong \
        		-qtmplparse=no \
        		-qdollar \
        		-qalign=power

        LFLAGS+= \
        		-b64 \
        		-q64 \
        		-qrtti=all \
        		-Wl,-brtl \
        		-Wl,-blibpath:/usr/lib/threads:/usr/lib:/lib \
        		-Wl,-bexpall \
        		-Wl,-bnoentry \
        		-Wl,-bf \
        		-Wl,-G
endif

ifeq ($(MACHINE), SunOS)
#   --  Pick up the libraries files
LIB_PATH+= \
            -L/usr/local/lib/sparcv9

LIBS = -lR -ldl -lm -lsocket -lposix4 -lm9x -lnsl -lstdc++ -lCstd -lCrun -lc -lsunmath -lfsu -lgen
MACROS = \
	-D__sparc__ \
	-D__sunos__ \
	-D__OSVERSION__=5 \
	-DHAS_BOOL \
	-mt \
	-D_BigEndian \
	-DLP64 \
	-DSOLARIS \
	-DUNIX \
	-DREQUIRE_LOGIN \
	-DODBC64 \
	-DSPSS_U8_OR_CP \
	-KPIC

MACROS2 = \
	-z muldefs
	#  \
	#  -z defs
	CC=	CC
	CXX=
	LINKCC=	$(CC)
	CFLAGS+= \
		-c \
		-xO4 \
		-xarch=v9 \
		-PIC \
		$(MACROS)


	LFLAGS+= \
		-xO4 \
		-xarch=v9 \
		-PIC \
		-mt \
		-G \
		$(MACROS2)
endif

ifeq ($(MACHINE), HP-UX)
            LIBS= -lR -ldl -ldld -lm -lnsl -lc -lgen -lxnet -lCsup -lrt
            CC=aCC
            CXX=aCC
            CFLAGS +=   -c \
        				+DD64 \
                        +Z \
                        -AA \
                        -mt \
                        -DNDEBUG
            LFLAGS +=  \
                        -b \
                        +DD64 \
                        -AA

            LIB_PATH += \
                        -L/usr/lib/hpux64
endif

ifeq ($(MACHINE),Linux)
    CC=         g++
    CXX=
    LINKCC=     $(CC)
    LIBS+=-lRblas -lRlapack -lrt
    ifeq ($(PLATFORM),64)
        CFLAGS += -m64 \
                  -fPIC \
                  -O2 \
                  -fexceptions \
                  -pedantic \
                  -Wno-long-long \
                  -DUNIX \
                  -c \
                  -DLINUX \
                  -DLINUX_64 \
                  -DHAS_BOOL \
                  -Dunix

        LFLAGS += -m64\
                 -fPIC \
                 -O2 \
                 -fexceptions \
                 -pedantic \
                 --export-dynamic \
                 -shared \
                 -Wl,--hash-style=both
    else
        CFLAGS += -m32 \
                  -fPIC \
                  -O2 \
                  -fexceptions \
                  -pedantic \
                  -Wno-long-long \
                  -DUNIX \
                  -c \
                  -DLINUX \
                  -DHAS_BOOL \
                  -Dunix

        LFLAGS += -m32 \
                 -fPIC \
                 -O2 \
                 -fexceptions \
                 -pedantic \
                 --export-dynamic \
                 -shared \
                 -Wl,--hash-style=both
    endif
endif

ifeq ($(MACHINE),Darwin)
	INC_PATH= \
             -I$(R_HOME)/include/R_ext \
			 -I$(R_HOME)/include \
			 -I$(SRC_DIR) \
			 -I/usr/local/include \
			 -I.
    LIB_PATH= \
            -L$(R_HOME)/lib/i386 \
            -L.
	CC=         g++
	CXX=
	LINKCC=     $(CC)
	CFLAGS += -fPIC \
              -pedantic \
              -Wno-long-long \
              -trigraphs \
              -O2 \
              -c \
              -Dunix \
              -isysroot /Developer/SDKs/MacOSX10.6.sdk \
              -mmacosx-version-min=10.6

	LFLAGS += \
              -dynamiclib \
              -pedantic \
              -Wno-long-long \
              -trigraphs \
              -fPIC \
              -Wl,-syslibroot,/Developer/SDKs/MacOSX10.6.sdk \
              -mmacosx-version-min=10.6 \
              -single_module
endif

#   -- Additional flags, which is not required
RM = rm -f
VPATH = src include
ifdef DEBUG
	CFLAGS +=     -g
endif


#   -- Create directory $(OUT_DIR) if it doesn't already exist.
define CreateDir
if [ ! -d $(OUT_DIR) ]; then \
   (umask 002; set -x; mkdir $(OUT_DIR) ); \
fi
endef


#   -- Build libInvokeR.so
.PHONY:all
all:$(INVOKE_NAME)
$(INVOKE_NAME):$(OBJECT_NAME)
	$(CC) $(LFLAGS) $(MAC_ARCH_I386) $(LIB_PATH) $(LIBS) -o $(OUT_DIR)/$(INVOKE_NAME) $(OUT_DIR)/embedded.o
	$(RM)  $(OUT_DIR)/embedded.o

embedded.o: $(SRC_DIR)/embedded.cpp
	$(CreateDir)
	$(CC) $(CFLAGS) $(MAC_ARCH_I386) $(INC_PATH) -o $(OUT_DIR)/embedded.o $(SRC_DIR)/embedded.cpp

#   -- Clean output files
.PHONY:clean
clean:
	$(RM) $(OUT_DIR)/*.*

.PHONY:export
export:
	cp $(OUT_DIR)/$(INVOKE_NAME) $(SPSS_HOME)/lib

