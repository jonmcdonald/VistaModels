TARGET_ARCH = linux

CC     = vista_c++ -gcc43 -sc22
OPT    = -O9 
OPT    = 
DEBUG  = -DMB_DEBUG -tsv -pg -fprofile-arcs -ftest-coverage
OTHER  = -Wall +model_builder 
OTHER  = +model_builder 
CFLAGS = $(OPT) $(OTHER)

MODELS = models
LOCAL  = local
MODULE = run
Project = Project

VISTA_HOME = $(dir $(dir $(shell which vista)))
MODEL_BUILDER_HOME = $(VISTA_HOME)papoulis

SRCS = $(wildcard *.cpp) src/fir_filter.cpp
OBJS = $(SRCS:.cpp=.o)

MBSRCS = $(wildcard $(MODELS)/*.cpp)
MBOBJS = $(MBSRCS:.cpp=.o)
MBARCHIVE = lib$(MODELS).a

INCDIR = -I. -Iinclude -I$(LOCAL) -I$(MODELS) 

LIBS   = $(EXTRA_LIBS) -L. -l$(MODELS) 
EXE    = $(MODULE).x
DFILES = $(OBJS:.o=.d) $(MBOBJS:.o=.d)

S ?= sim
P ?= parameters.txt
T ?= traces.tcl
N ?= top

.SUFFIXES: .cpp .cc .o .x .h

$(EXE): $(OBJS) $(MBARCHIVE)
	$(CC) $(CFLAGS) $(INCDIR) -o $@ $(OBJS) $(LIBS) 2>&1 | c++filt
#	if [ ! -n "$$V2_HOME" ] ; \
#	then vista_build_project $(Project); fi

vistagui: $(EXE)

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
	rm -rf vista_work Project Source Object sim papoulis_project work
	find . -name "*~" -exec rm {} \;
	find . -name "*.d" -exec rm {} \;
	rm -f $(OBJS) $(MBOBJS) $(MBARCHIVE) $(EXE)

vista: $(EXE) $T
	vista -sc22 -trace-delta-cycles -tsv -memory-profiling \
		-event-debugging -with-cause -trace-all-sockets \
		-params $P -simdir $S -memory-profiling \
		-exec $(EXE) -simscript $T

batch: $(EXE) $T
	vista -sc22 -tsv -simscript $T -params $P -simdir $S \
		-batch -exec $(EXE)
#		-trace-all-sockets -batch -exec $(EXE)

events: $S
	vista_dump_events $S -kind initiator_socket -name $N > events2
	diff events*

$T:
	echo "#trace_transactions -name * -tree" > $T
	echo "#trace -name * -tree" >> $T
	echo "#trace -kind sc_object_attribute -name * -tree -unlimited" >> $T

COMMAND = "if {![does_tlm_library_exist $(MODELS)]} \
	      {create_tlm_library $(MODELS) $(MODELS)}; \
	   reload_tlm_library $(MODELS);\
	   foreach n [glob -directory $(MODELS) -tails *.mb] { \
	     save_model -g TLM/$(MODELS)/[lindex [split \$$n .] 0] }"

mb:
	if [ -e $(HOME)/include/custom_models.tcl ]; then \
		vista_mb -c "source $(HOME)/include/custom_models.tcl"; fi
	@if [ -e $(MODELS) ]; then vista_model_builder -c $(COMMAND); fi

papoulis_project:
	if [ -e $(HOME)/include/custom_models.tcl ]; then \
		vista_mb -c "source $(HOME)/include/custom_models.tcl"; fi
	@if [ -e $(MODELS) ]; then vista_model_builder -c $(COMMAND); fi

pa: $(EXE)
	vista_analysis sim

cov: $(EXE)
	lcov -d . -z
	vista_run run.x
	lcov -d . -c -o app.info
	genhtml app.info

-include $(DFILES)
