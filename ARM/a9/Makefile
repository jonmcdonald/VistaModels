#
#  "make" with no arguments will generate code for all mb files and compile everything
#  "make run" will compile iff needed and run the simulation
#  "make clean" remove all generated/object data
#

MODELS = Models
SC_MAIN = sc_main
VISTA = linux32 vista
VISTA_ARGS = -sc23 -gcc45

PROJECT = $(patsubst %.v2p,%,$(wildcard *.v2p))
PROJECTEXE = $(PROJECT)/build/D_PRJDIR_/$(SC_MAIN).exe

SRCS = $(wildcard *.cpp) $(wildcard $(MODELS)/*.cpp)

all: $(PROJECTEXE)

$(PROJECTEXE): $(SRCS)
	$(VISTA)_build_project $(VISTA_ARGS) $(PROJECT)

run: $(PROJECTEXE)
	$(VISTA)_simulate $(PROJECT)

T ?= tracing/sim.tcl
P ?= parameters.txt
S ?= sim

batch: $(PROJECTEXE) $T
	$(VISTA) $(VISTA_ARGS) -simscript $T -params $P -simdir $S -batch -exec -project $(PROJECT)

COMMAND = "if {![does_tlm_library_exist $(MODELS)]} \
              {create_tlm_library $(MODELS) $(MODELS)}; \
           reload_tlm_library $(MODELS);\
           foreach n [glob -directory $(MODELS) -tails *.mb] { \
             save_model -g TLM/$(MODELS)/[lindex [split \$$n .] 0] }"

mb:
	if [ -e $(MODELS) ]; then $(VISTA)_model_builder -c $(COMMAND); fi

clean:
	rm -rf vista_work $(PROJECT) sim papoulis_project
	find . -name "*~" -exec rm {} \;
	rm -rf vista_*

ELF = $(shell egrep "^[^\#]*elf_image_file" parameters.txt | tail -1 | awk '{print $$3}')
SWBCOMMAND = "coverage::create_design ${ELF} -output tracing/sw.dsn -limit 100"

swb:
	$(VISTA)_sw_tool -c ${SWBCOMMAND}

SWCOVCOMMAND = "use_coverage; \
                load_design tracing/sw.dsn; \
                load_test tracing/sw.tst; \
                cd sim; \
                dump_report -output coverage.html -full -source-dir software"

swcov:
	$(VISTA)_sw_tool -c ${SWCOVCOMMAND}
        

