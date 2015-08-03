##################################################################################
# Makefile - Configuration file for IORUN
# Creation : 28 Jan 2014
# Time-stamp: <Dim 2014-01-28 18:30 hcartiaux>
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

SRC_DIR     = src
RUNS_DIR    = runs

### Stuff to download
IORUN_URL   = "https://github.com/chaos/ior.git"

############################
.PHONY: all fetch clean plot

all: fetch build run plot

fetch:
	@if [ ! -d ./$(SRC_DIR)/ior ]; then \
		echo "=> git clone $(IORUN_URL) $(SRC_DIR)/ior"; \
		git clone $(IORUN_URL) $(SRC_DIR)/ior; \
	else \
		echo "=> IORUN has already been downloaded in $(SRC_DIR)/ior, updating..."; \
		cd $(SRC_DIR)/ior && git pull; \
	fi

build: fetch
	oarsub -S "./$(SRC_DIR)/build.sh < /dev/null"

run_interactive:
	./$(RUNS_DIR)/launch_iorun

run:
	@if [ -f ./$(RUNS_DIR)/ior ]; then       \
		oarsub -S ./$(RUNS_DIR)/launch_iorun ; \
	else																		 \
		echo "=> IORUN is not built yet";      \
	fi

plot:
	./plots/generate_data
	oarsub "cd plots && gnuplot iorun.gnuplot && epstopdf iorun.eps"
	@echo "=> You probably want now to see the plot:\n\t\tplots/iorun.eps\n\t\tplots/iorun.pdf"

clean:
	echo "=> removing $(SRC_DIR)/ior";
	rm -rf  $(SRC_DIR)/ior;
	rm -f $(RUNS_DIR)/ior


