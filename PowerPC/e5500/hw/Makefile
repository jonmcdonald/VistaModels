#
#  "make" with no arguments will generate code for all mb files and compile everything
#  "make run" will compile iff needed and run the simulation
#  "make clean" remove all generated/object data
#

MODELS = models
SC_MAIN = sc_main

PROJECT = $(patsubst %.v2p,%,$(wildcard *.v2p))
PROJECTEXE = $(PROJECT)/build/D_PRJDIR_/$(SC_MAIN).exe

SRCS = $(wildcard *.cpp) $(wildcard $(MODELS)/*.cpp)

all: $(PROJECTEXE) 

$(PROJECTEXE): $(SRCS)
	vista_build_project $(PROJECT)

mybit.dgn: begin.tcl
	vista_sw_tool begin.tcl

run: $(PROJECTEXE) mybit.dgn
	rm -f mybit.tst
	rm -f coverage.html
	rm -rf coverage_files
	vista_simulate $(PROJECT)

report: end.tcl mybit.tst mybit.dgn
	vista_sw_tool end.tcl
	firefox coverage.html

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
	rm -f mybit.dgn
	rm -f mybit.tst
	rm -f coverage.html
	rm -rf coverage_files


