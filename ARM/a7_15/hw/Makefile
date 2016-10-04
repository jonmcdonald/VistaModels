#
#  "make" with no arguments will generate code for all mb files and compile everything
#  "make run" will compile iff needed and run the simulation
#  "make clean" remove all generated/object data
#

.PHONY:	a7 a15

MODELS ?= models
SC_MAIN = sc_main

MBDIRS = $(sort $(patsubst %/,%,$(dir $(wildcard */*.mb))))
A15PROJECTEXE = a15/build/D_PRJDIR_/$(SC_MAIN).exe
A7PROJECTEXE  =  a7/build/D_PRJDIR_/$(SC_MAIN).exe
MODELSLIB = Models/build/Models.a

SRCS = $(wildcard *.cpp) $(wildcard */*.cpp) $(wildcard */*.h)

all: $(A15PROJECTEXE) $(A7PROJECTEXE)

$(MODELSLIB) : $(SRCS)
	vista_build_project Models

$(A7PROJECTEXE) : $(SRCS) $(MODELSLIB)
	vista_build_project a7

$(A15PROJECTEXE) : $(SRCS) $(MODELSLIB)
	vista_build_project a15

a15vista: $(A15PROJECT)
	vista_simulate a15

a7vista: $(A7PROJECT)
	vista_simulate a7

a15: $(A15PROJECTEXE)
	$(A15PROJECTEXE)

a7: $(A7PROJECTEXE)
	$(A7PROJECTEXE)

COMMAND = "if {![does_tlm_library_exist $(MODELS)]} \
              {create_tlm_library $(MODELS) $(MODELS)}; \
           reload_tlm_library $(MODELS);\
           foreach n [glob -directory $(MODELS) -tails *.mb] { \
             save_model -g TLM/$(MODELS)/[lindex [split \$$n .] 0] }"

mb:
	if [ -e $(MODELS) ]; then vista_model_builder -c $(COMMAND); fi

mbs:
	for m in $(MBDIRS) ; do \
	  make mb MODELS=$$m ; \
	done

clean:
	rm -rf vista_work sim papoulis_project
	find . -name "*~" -exec rm {} \;
	rm -rf vista_* a15 a7 Models models/model_builder

