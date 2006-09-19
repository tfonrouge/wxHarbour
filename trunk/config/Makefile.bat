##
##
## batch Makefile
## (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
##
##

_all_list = $(addprefix all_,$(EXES))
_clean_list = $(addprefix clean_,$(EXES))

all: $(_all_list)

clean: $(_clean_list)

$(_all_list):
	$(MAKE) -C $(subst all_,,$@ ) all

$(_clean_list):
	$(MAKE) -C $(subst clean_,,$@ ) clean











