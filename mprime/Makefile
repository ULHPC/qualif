##################################################################################
# Makefile - Configuration file for MPRIME (http://www.mersenne.org/freesoft/)
# Creation : 28 Jan 2014
# Time-stamp: <Dim 2014-01-28 14:01 hcartiaux>
#
# Copyright (c) 2014 Hyacinthe Cartiaux <Hyacinthe.Cartiaux@uni.lu>
#
# Available Commands
# ------------------
# make           : Compile files, binaries are generated in the current directory
# make force     : Force the complete re-compilation, even if not needed
# make clean     : Remove backup files (*~) and other generated files
#
############################## Variables Declarations ############################

TARBALL_DIR = tarballs
SRC_DIR     = src
RUNS_DIR    = runs

### Stuff to download
MPRIME_URL       = "http://download.mersenne.ca/gimps/p95v279.linux64.tar.gz"
MPRIME_TARBALL   = $(shell basename $(MPRIME_URL) )

############################
.PHONY: all fetch clean plot

all: fetch plot

fetch:
	@if [ ! -f ./$(TARBALL_DIR)/$(MPRIME_TARBALL) ]; then \
		echo "=> downloading HPL archive  $(MPRIME_TARBALL)"; \
		wget -P $(TARBALL_DIR) $(MPRIME_URL); \
	else \
		echo "=> MPRIME has already been downloaded in $(TARBALL_DIR)/"; \
	fi

build: fetch
	mkdir -p $(RUNS_DIR)/bin
	tar xzvf ./$(TARBALL_DIR)/$(MPRIME_TARBALL) -C $(RUNS_DIR)/bin

run_interactive:
	./$(RUNS_DIR)/launch_mprime_torture

run:
	oarsub -S ./$(RUNS_DIR)/launch_mprime_torture

plot:
	@echo "TODO: define action to plot the result"

clean:
	echo "=> removing $(MPRIME_TARBALL)";
	rm -f  $(TARBALL_DIR)/$(MPRIME_TARBALL);
	rm -rf  $(RUNS_DIR)/bin;


