#
#  "make" with no arguments will generate code for all mb files and compile everything
#  "make run" will compile iff needed and run the simulation
#  "make clean" remove all generated/object data
#

MODELS = instruments_models
LOCAL = instruments_local
SC_MAIN = sc_main

PROJECT = $(patsubst %.v2p,%,$(wildcard *.v2p))
PROJECTEXE = $(PROJECT)/build/D_PRJDIR_/$(SC_MAIN).exe

SRCS = $(wildcard *.cpp) $(wildcard $(MODELS)/*.cpp) $(wildcard $(LOCAL)/*cpp)

all: $(PROJECTEXE)

$(PROJECTEXE): $(SRCS)
	vista_build_project -gcc45 -sc23 $(PROJECT)

run: $(PROJECTEXE)
	vista_simulate -gcc45 -sc23 $(PROJECT)

COMMAND = "if {![does_tlm_library_exist $(MODELS)]} \
              {create_tlm_library $(MODELS) $(MODELS)}; \
           reload_tlm_library $(MODELS);\
           foreach n [glob -directory $(MODELS) -tails *.mb] { \
             save_model -g TLM/$(MODELS)/[lindex [split \$$n .] 0] }; \
           if {![does_tlm_library_exist $(LOCAL)]} \
              {create_tlm_library $(LOCAL) $(LOCAL)}; \
           reload_tlm_library $(LOCAL);\
           foreach n [glob -directory $(LOCAL) -tails *.mb] { \
             save_model -g TLM/$(LOCAL)/[lindex [split \$$n .] 0] }"

mb:
	if [ -e $(MODELS) ]; then vista_model_builder -c $(COMMAND); fi

clean:
	rm -rf vista_work $(PROJECT) sim papoulis_project
	find . -name "*~" -exec rm {} \;
	rm -rf vista_*

