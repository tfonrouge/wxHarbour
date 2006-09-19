##
##
## GCC Makefile include
## (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
##
##

XHFLAGS = -n -a -v -m -es2 -w2 $(XHF_DEBUG)

ifeq ($(OSTYPE),Win32)
OBJDIR=Win32
OBJEXT=.obj
XHDEFINES = -D__EXPORT__ -DHB_OS_WIN_32
PATHOBJ = ../../obj/Win32
PATHCXXPRG = ../../cxxprg/Win32
CCOUT=-Fo
XHINCLUDES = -I/usr/include/xharbour -I../../include
ALLCFLAGS = $(XHINCLUDES) -c -TP -W3 -nologo
ALLCXXFLAGS = -c -TP -W3 -nologo `wx-config --cxxflags` $(XHINCLUDES)
$(info Using Windows environment...)
else
OBJDIR=gcc
OBJEXT=.o
XHDEFINES = -D__EXPORT__ -DHB_OS_LINUX
  ifndef PATHOBJ
    PATHOBJ = ../../obj/gcc
  endif
  ifndef PATHCXXPRG
    PATHCXXPRG = ../../cxxprg/gcc
  endif
CCOUT=-o
XHINCLUDES = -I/usr/include/xharbour -I../../include -I../include
ALLCFLAGS = $(XHINCLUDES) -c -g -O3 -Wall
ALLCXXFLAGS = -c -g -O3 -Wall -fno-strict-aliasing `wx-config --cxxflags` $(XHINCLUDES)
#ALLCXXFLAGS = -c -g -O3 -Wall `wx-config --cxxflags` $(XHINCLUDES)
$(info Using Linux environment...)
endif

SEPARATOR = "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

OBJS_PRG_LIST = $(addprefix $(PATHOBJ)/, $(subst .prg,$(OBJEXT), $(filter %.prg, $(PRGS) ) ) )
OBJS_C_LIST   = $(addprefix $(PATHOBJ)/, $(subst .c,$(OBJEXT), $(filter %.c, $(PRGS) ) ) )
OBJS_CXX_LIST = $(addprefix $(PATHOBJ)/, $(subst .cpp,$(OBJEXT), $(filter %.cpp, $(PRGS) ) ) )

ALLOBJS = $(OBJS_PRG_LIST) $(OBJS_C_LIST) $(OBJS_CXX_LIST)

# Can be: "c" or "cpp" sourcefile extensions
CXX_PRG = c
CXXPRG_LIST = $(addprefix $(PATHCXXPRG)/, $(subst .prg,.$(CXX_PRG), $(filter %.prg, $(PRGS) ) ) )

.SECONDARY: $(CXXPRG_LIST)

#Can be "OBJ" to let the harbour compiler create the object
#    or "SRC" to let the harbour compiler just create the c source code to be compiled
XHCOMPLEVEL = OBJ

ifeq ($(OSTYPE),Win32)
  CXX_COMPILER = cl
else
  CXX_COMPILER = gcc
endif

ifeq ($(XHCOMPLEVEL),SRC)
  ifeq ($(CXX_PRG),c)
    ifeq ($(OSTYPE),Win32)
      CXX_PRG_COMPILER = cl
    else
      CXX_PRG_COMPILER = gcc
    endif
    CXX_PRG_COMPILER_FLAGS = $(ALLCFLAGS)
  endif
  ifeq ($(CXX_PRG),cpp)
    ifeq ($(OSTYPE),Win32)
      CXX_PRG_COMPILER = cl
    else
      CXX_PRG_COMPILER = g++
    endif
    CXX_PRG_COMPILER_FLAGS = $(ALLCXXFLAGS)
  endif
  ALLXHFLAGS = -gc $(XHINCLUDES) $(XHDEFINES) $(XHFLAGS)
else
  ALLXHFLAGS = -go3 $(XHINCLUDES) $(XHDEFINES) $(XHFLAGS)
endif

ifeq ($(OSTYPE),Win32)
  ARCHOBJ = $(PATHOBJ)/$(MODULE).lib
else
  ARCHOBJ = $(PATHOBJ)/$(MODULE).a
endif

.PHONY: MOD_$(MODULE)
MOD_$(MODULE) : $(ARCHOBJ) $(EXENAME)
	@echo $(MODULE) done...

$(ARCHOBJ): $(OBJS_PRG_LIST) $(OBJS_CXX_LIST) $(OBJS_C_LIST)
ifeq ($(OSTYPE),Win32)
	lib /out:$(ARCHOBJ) $?
else
	ar -crs $(ARCHOBJ) $?
endif

ifeq ($(XHCOMPLEVEL),SRC)
# Compile prg sources to CXX source
$(PATHCXXPRG)/%.$(CXX_PRG): %.prg
ifneq ($(OSTYPE),Win32)
	+@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
endif
	@echo $(SEPARATOR)
	@echo 1. Compiling xHarbour source $<
	harbour $(ALLXHFLAGS) -o$@ $<

# Compile prg compiled sources
$(PATHOBJ)/%$(OBJEXT): $(PATHCXXPRG)/%.$(CXX_PRG)
ifneq ($(OSTYPE),Win32)
	+@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
endif
	@echo 2. Compiling C source created from xHarbour source $<
	$(CXX_PRG_COMPILER) $(CXX_PRG_COMPILER_FLAGS) $(CCOUT)$@ $<
endif

ifeq ($(XHCOMPLEVEL),OBJ)
#Compile PRG sources to obj
$(PATHOBJ)/%$(OBJEXT): %.prg
ifneq ($(OSTYPE),Win32)
	+@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
endif
	@echo $(SEPARATOR)
	@echo Direct Compiling xHarbour source $<
	harbour $(ALLXHFLAGS) -o$@ $<
endif

#Compile C sources
$(PATHOBJ)/%$(OBJEXT): %.c
ifneq ($(OSTYPE),Win32)
	+@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
endif
	@echo $(SEPARATOR)
	@echo Compiling C source $<
	$(CXX_COMPILER) $(ALLCFLAGS) $(CCOUT)$@ $<

#Compile C++ sources
$(PATHOBJ)/%$(OBJEXT): %.cpp
ifneq ($(OSTYPE),Win32)
	+@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
endif
	@echo $(SEPARATOR)
	@echo Compiling C++ source $<
	$(CXX_COMPILER) $(ALLCXXFLAGS) $(CCOUT)$@ $<

.PHONY: clean
clean:
ifneq ($(OSTYPE),Win32)
	@rm -f $(OBJS_PRG_LIST)
	@rm -f $(OBJS_CXX_LIST)
	@rm -f $(OBJS_C_LIST)
	@rm -f $(ARCHOBJ)
	@rm -f $(CXXPRG_LIST)
	@rm -f $(EXENAME)
	@rm -f error.log
	@echo $(MODULE) cleaned...
endif
