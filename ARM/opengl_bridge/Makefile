#
#  "make" with no arguments will generate code for all mb files and compile everything
#  "make run" will compile iff needed and run the simulation
#

MODELS = Models
SC_MAIN = sc_main

PROJECT = $(patsubst %.v2p, %, $(wildcard *.v2p))
PROJECTEXE = $(PROJECT)/build/D_PRJDIR_/$(SC_MAIN)

SRCS = $(wildcard *.cpp) $(wildcard $(MODELS)/*.cpp)

all: mb $(PROJECTEXE)

$(PROJECTEXE): $(SRCS)
	vista_build_project $(PROJECT)

run: $(PROJECTEXE)
	vista_simulate $(PROJECT)

COMMAND = "if {![does_tlm_library_exist $(MODELS)]} \
              {create_tlm_library $(MODELS) $(MODELS)}; \
           reload_tlm_library $(MODELS);\
           foreach n [glob -directory $(MODELS) -tails *.mb] { \
             save_model -g TLM/$(MODELS)/[lindex [split \$$n .] 0] }"

mb:
	if [ -e $(MODELS) ]; then vista_model_builder -c $(COMMAND); fi

