TARGET_ARCH = linux
VISTAPLATFORMS ?= /home/jon/work/vistagit

CC     = vista_c++
OPT    = 
DEBUG  = -DMB_DEBUG -tsv
OTHER  = -Wall +model_builder 
OTHER  = +model_builder -sc23
CFLAGS = $(DEBUG) $(OTHER)

VISTAVER = $(strip $(patsubst Vista,,$(shell vista -version)))
PAPOULISDIR = vista_work/papoulis_project$(VISTAVER)

MODELS = models
IMODELS = ../instruments/instruments_models
LOCAL  = local
MODULE = run
Project = Project

VISTA_HOME = $(dir $(dir $(shell which vista)))
MODEL_BUILDER_HOME = $(VISTA_HOME)papoulis

SRCS = $(wildcard *.cpp) $(wildcard include/*.cpp)
OBJS = $(SRCS:.cpp=.o)

MBSRCS = $(wildcard $(MODELS)/*.cpp) $(wildcard $(IMODELS)/*.cpp)
MBOBJS = $(MBSRCS:.cpp=.o)
MBARCHIVE = lib$(MODELS).a

INCDIR = -I. -Iinclude -I$(LOCAL) -I$(MODELS) -I$(IMODELS)

LIBS   = $(EXTRA_LIBS) -L. -l$(MODELS) 
EXE    = $(MODULE).x
DFILES = $(OBJS:.o=.d) $(MBOBJS:.o=.d)

S ?= sim
P ?= parameters.txt
T ?= traces.tcl

.SUFFIXES: .cpp .cc .o .x .h

all	: instruments mb $(EXE)

instruments:
	cd ../instruments && $(MAKE) mb && $(MAKE)

$(EXE) : $(OBJS) $(MBARCHIVE) 
	$(CC) $(CFLAGS) $(INCDIR) -o $@ $(OBJS) $(LIBS) 2>&1 | c++filt
	if [ ! -n "$$V2_HOME" ] ; \
	then vista_build_project $(Project); fi



vistagui:
$(MBARCHIVE): $(MBOBJS)
	ar rcs $@ $(MBOBJS)

.cpp.o:
	$(CC) $(CFLAGS) $(INCDIR) -c $< -o $*.o
	@$(CC) -MM $(CFLAGS) $(INCDIR) -c $< > $*.d
	@sed -e 's|.*:|$*.o:|' < $*.d > $*.d.tmp
	@mv $*.d.tmp $*.d


.cc.o:
	$(CC) $(CFLAGS) $(INCDIR) -c $< -o $*.o
	@$(CC) -MM $(CFLAGS) $(INCDIR) -c $< > $*.d
	@sed -e 's|.*:|$*.o:|' < $*.d > $*.d.tmp
	@mv $*.d.tmp $*.d

clean:
	rm -rf vista_work Project Source Object sim work papoulis_project
	find . -name "*~" -exec rm {} \;
	find . -name "*.d" -exec rm {} \;
	find . -name "*_t.h" -exec rm -f {} \;
	find . -name "*_t.cpp" -exec rm -f {} \;
	find . -name "*_model.h" -exec rm -f {} \;
	find . -name "*_model.cpp" -exec rm -f {} \;
	rm -f $(OBJS) $(MBOBJS) $(MBARCHIVE) $(EXE)
	rm -rf vista_power_transcript visualhl.ini
	cd ../instruments && $(MAKE) clean

vista: $(EXE) $T
	vista -sc22 -trace-delta-cycles -tsv -memory-profiling \
		-event-debugging -with-cause -trace-all-sockets \
		-params $P -simdir $S -memory-profiling \
		-exec $(EXE) -simscript $T

batch: $(EXE) $T
	vista -sc22 -tsv -simscript $T -params $P -simdir $S \
		-batch -exec $(EXE)

$T:
	echo "#trace_transactions -name * -tree" > $T
	echo "#trace -name * -tree" >> $T
	echo "#trace -kind sc_object_attribute -name * -tree -unlimited" >> $T

COMMAND = "if {![does_tlm_library_exist $(MODELS)]} \
	      {create_tlm_library $(MODELS) $(MODELS)}; \
	   reload_tlm_library $(MODELS);\
	   foreach n [glob -directory $(MODELS) -tails *.mb] { \
	     save_model -g TLM/$(MODELS)/[lindex [split \$$n .] 0] }"
models:
mb $(PAPOULISDIR): Templates
	@if [ -e $(MODELS) ]; then vista_model_builder -c $(COMMAND); fi

TemplatesCOMMAND = \
        "if {[ file exist protocols ]} \
             {foreach p [glob -directory protocols -tails *.v] { \
                parse_protocol_source protocols/\$$p } }; \
         if {[ file exist templates ]} \
           {foreach t [glob -directory templates -tails *] { \
             add_template \"/TLM/Generic_Library/Custom/\$$t\" [file join [pwd] \"templates/\$$t\"]; \
         }} "

Templates:
	vista_model_builder -c $(TemplatesCOMMAND);

pa: $(EXE)
	vista_analysis sim

getcan:
	cp $(VISTAPLATFORMS)/RH850E1x/RH850E1_models/RH850E1_CAN.mb models
	cp $(VISTAPLATFORMS)/RH850E1x/RH850E1_models/RH850E1_CAN_pv.cpp models
	cp $(VISTAPLATFORMS)/RH850E1x/RH850E1_models/RH850E1_CAN_pv.h models
	
-include $(DFILES)
