#
#  "make" with no arguments will generate code for all mb files and compile everything
#  "make run" will compile iff needed and run the simulation
#  "make clean" remove all generated/object data
#

MODELS = local
BLOCKS = local
SC_MAIN = main
VISTA = vista
ARGS = -sc22 -gcc43
ARGS = 

PROJECT = $(patsubst %.v2p,%,$(wildcard *.v2p))
PROJECTEXE = $(PROJECT)/build/D_PRJDIR_/$(SC_MAIN).exe

SRCS = $(wildcard *.cpp) $(wildcard $(MODELS)/*.cpp)
HEADERS = $(wildcard $(BLOCKS)/*.h)

all: $(PROJECTEXE)

$(PROJECTEXE): $(SRCS) $(HEADERS)
	vista_build_project $(ARGS) $(PROJECT)

run: $(PROJECTEXE)
	export V2_VP_PLUS=1; export V2_IO_DEBUG_ENABLED=1; $(VISTA)_simulate $(ARGS) $(PROJECT)

T ?= tracing/sim.tcl
P ?= parameters.txt
S ?= sim

batch: $(PROJECTEXE) $T
	 vista -simscript $T -params $P -simdir $S -batch -exec -project $(PROJECT)

COMMAND = "if {![does_tlm_library_exist $(MODELS)]} \
              {create_tlm_library $(MODELS) $(MODELS)}; \
           reload_tlm_library $(MODELS);\
           foreach n [glob -directory $(MODELS) -tails *.mb] { \
             save_model -g TLM/$(MODELS)/[lindex [split \$$n .] 0] }"

mb:
	if [ -e $(MODELS) ]; then vista_model_builder -c $(COMMAND); fi

clean:
	rm -rf vista_work $(PROJECT) sim papoulis_project
	find . -name "*~" -exec rm {} \;
	rm -rf vista_*

