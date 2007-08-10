##
##
## GCC Makefile include
## (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
##
##
XHFLAGS = -n -a -v -m -es2 -w2 $(XHF_DEBUG)
XHLANG=harbour
XHLANGC=Harbour

ifeq ($(OSTYPE),msys)
XHBDIR=/usr/local
OBJDIR=msys
OBJEXT=.o
XHDEFINES = -D__EXPORT__ -DHB_OS_LINUX
ifndef PATHOBJ
PATHOBJ = ../obj/msys
endif
ifndef PATHCXXPRG
PATHCXXPRG = ../cxxprg/msys
endif
CCOUT=-o
XHINCLUDES = -I$(XHBDIR)/include/$(XHLANG) -I../../include -I../include
ALLCFLAGS = $(XHINCLUDES) -c -g -O3 -Wall
ALLCXXFLAGS = -c -g -O3 -Wall -fno-strict-aliasing $(XHINCLUDES) `wx-config --cxxflags`
#ALLCXXFLAGS = -c -g -O3 -Wall `wx-config --cxxflags` $(XHINCLUDES)
$(info Using msys environment...)
else
XHBDIR=/usr
OBJDIR=linux
OBJEXT=.o
XHDEFINES = -D__EXPORT__ -DHB_OS_LINUX
ifndef PATHOBJ
PATHOBJ = ../obj/gcc
endif
ifndef PATHCXXPRG
PATHCXXPRG = ../cxxprg/gcc
endif
CCOUT=-o
XHINCLUDES = -I$(XHBDIR)/include/$(XHLANG) -I../../include -I../include
ALLCFLAGS = $(XHINCLUDES) -c -g -O3 -Wall
ALLCXXFLAGS = -c -g -O3 -Wall -fno-strict-aliasing $(XHINCLUDES) `wx-config --cxxflags`
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
XHCOMPLEVEL = SRC

ifeq ($(OSTYPE),msys)
  CXX_COMPILER = gcc
else
  CXX_COMPILER = gcc
endif

ifeq ($(XHCOMPLEVEL),SRC)
$(info Using SRC mode compiling...)
  ifeq ($(CXX_PRG),c)
    ifeq ($(OSTYPE),msys)
      CXX_PRG_COMPILER = gcc
    else
      CXX_PRG_COMPILER = gcc
    endif
    CXX_PRG_COMPILER_FLAGS = $(ALLCFLAGS)
  endif
  ifeq ($(CXX_PRG),cpp)
    ifeq ($(OSTYPE),msys)
      CXX_PRG_COMPILER = g++
    else
      CXX_PRG_COMPILER = g++
    endif
    CXX_PRG_COMPILER_FLAGS = $(ALLCXXFLAGS)
  endif
  ALLXHFLAGS = -gc $(XHINCLUDES) $(XHDEFINES) $(XHFLAGS)
else
$(info Using OBJ mode compiling...)
  ALLXHFLAGS = -go3 $(XHINCLUDES) $(XHDEFINES) $(XHFLAGS)
endif

ifeq ($(OSTYPE),msys)
  ARCHOBJ = $(PATHOBJ)/$(MODULE).a
else
  ARCHOBJ = $(PATHOBJ)/$(MODULE).a
endif

.PHONY: MOD_$(MODULE)
MOD_$(MODULE) : $(ARCHOBJ) $(EXENAME)
	@echo $(MODULE) done...

$(ARCHOBJ): $(OBJS_PRG_LIST) $(OBJS_CXX_LIST) $(OBJS_C_LIST)
ifeq ($(OSTYPE),msys)
	ar -crs $(ARCHOBJ) $?
else
	ar -crs $(ARCHOBJ) $?
endif

ifeq ($(XHCOMPLEVEL),SRC)
# Compile prg sources to CXX source
$(PATHCXXPRG)/%.$(CXX_PRG): %.prg
	@echo Compiling [x]Harbour sources to C[PP] sources...
	+@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
	@echo $(SEPARATOR)
	@echo $(OSTYPE)
	@echo 1. Compiling $(XHLANGC) source $<
	$(XHBDIR)/bin/harbour $(ALLXHFLAGS) -o$@ $<

# Compile prg compiled sources
$(PATHOBJ)/%$(OBJEXT): $(PATHCXXPRG)/%.$(CXX_PRG)
	+@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
	@echo 2. Compiling C source created from $(XHLANGC) source $<
	$(CXX_PRG_COMPILER) $(CXX_PRG_COMPILER_FLAGS) $(CCOUT)$@ $<
endif

ifeq ($(XHCOMPLEVEL),OBJ)
#Compile PRG sources to obj
$(PATHOBJ)/%$(OBJEXT): %.prg
	@echo Compiling [x]Harbour sources to PRG's...
	+@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
	@echo $(SEPARATOR)
	@echo Direct Compiling $(XHLANGC) source $<
	$(XHBDIR)/bin/harbour $(ALLXHFLAGS) -o$@ $<
endif

#Compile C sources
$(PATHOBJ)/%$(OBJEXT): %.c
	@echo Compiling C sources...
	+@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
	@echo $(SEPARATOR)
	@echo Compiling C source $<
	$(CXX_COMPILER) $(ALLCFLAGS) $(CCOUT)$@ $<

#Compile C++ sources
$(PATHOBJ)/%$(OBJEXT): %.cpp
	@echo Compiling C++ sources...
	+@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
	@echo $(SEPARATOR)
	@echo Compiling C++ source $<
	$(CXX) $(ALLCXXFLAGS) $(CCOUT)$@ $<

.PHONY: clean
clean:
	@rm -f $(OBJS_PRG_LIST)
	@rm -f $(OBJS_CXX_LIST)
	@rm -f $(OBJS_C_LIST)
	@rm -f $(ARCHOBJ)
	@rm -f $(CXXPRG_LIST)
	@rm -f $(EXENAME)
	@rm -f error.log
	@echo $(MODULE) cleaned...
