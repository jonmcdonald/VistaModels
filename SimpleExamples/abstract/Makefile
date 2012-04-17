TARGET_ARCH = linux

CC     = vista_c++ -gcc43 -sc22 -tsv 
OPT    = -O3
DEBUG  = -g -DMB_DEBUG
OTHER  = -Wall +model_builder
CFLAGS = $(DEBUG) $(OTHER)

MODELS = models
LOCAL  = local
MODULE = run

VISTA_HOME = $(dir $(dir $(shell which vista)))
MODEL_BUILDER_HOME = $(VISTA_HOME)papoulis

SRCS = $(wildcard *.cpp)
OBJS = $(SRCS:.cpp=.o)

MBSRCS = $(wildcard $(MODELS)/*.cpp)
MBOBJS = $(MBSRCS:.cpp=.o)
MBARCHIVE = lib$(MODELS).a

INCDIR = -I. -Iinclude -I$(LOCAL) -I$(MODELS)

LIBS   = $(EXTRA_LIBS) -L. -l$(MODELS) 
EXE    = $(MODULE).x

S ?= sim
P ?= parameters.txt
T ?= traces.tcl

.SUFFIXES: .cpp .cc .o .x .h

$(EXE): papoulis_project $(OBJS) $(MBARCHIVE)
	$(CC) $(CFLAGS) $(INCDIR) -o $@ $(OBJS) $(LIBS) 2>&1 | c++filt

$(MBARCHIVE): $(MBOBJS)
	ar rcs $@ $(MBOBJS)

.cpp.o:
	$(CC) $(CFLAGS) $(INCDIR) -c $< -o $*.o
	@$(CC) -MM $(CFLAGS) $(INCDIR) -c $< > $*.d
	@sed -e 's|.*:|$*.o:|' -e 's|[  ]/[^    ]*| |' -e '/^[  ]*\\/d' < $*.d > $*.d.tmp
	@mv $*.d.tmp $*.d

.cc.o:
	$(CC) $(CFLAGS) $(INCDIR) -c $< -o $*.o
	@$(CC) -MM $(CFLAGS) $(INCDIR) -c $< > $*.d
	@sed -e 's|.*:|$*.o:|' -e 's|[  ]/[^    ]*| |' -e '/^[  ]*\\/d' < $*.d > $*.d.tmp
	@mv $*.d.tmp $*.d

clean:
	rm -rf vista_work Project Source Object sim papoulis_project work
	find . -name "*~" -exec rm {} \;
	find . -name "*.d" -exec rm {} \;
	rm -f $(OBJS) $(MBOBJS) $(MBARCHIVE) $(EXE)

run: $(EXE)
	./$(EXE) > run.log 2>&1

vista: $(EXE) $T
	export ANALYSIS_LOG_FILE=pa.log; \
	vista -sc22 -trace-delta-cycles -tsv -memory-profiling \
		-event-debugging -with-cause -trace-all-sockets \
		-params $P -simdir $S -memory-profiling \
		-exec $(EXE) -simscript $T

batch: $(EXE)
	export ANALYSIS_LOG_FILE=pa.log; \
	vista -sc22 -tsv -simscript $T -params $P -simdir $S \
		-batch -exec $(EXE)

COMMAND = "if {![does_tlm_library_exist $(MODELS)]} \
	      {create_tlm_library $(MODELS) $(MODELS)}; \
	   reload_tlm_library $(MODELS);\
	   foreach n [glob -directory $(MODELS) -nocomplain -tails *.mb] { \
	     save_model -g TLM/$(MODELS)/[lindex [split \$$n .] 0] }"

mb:
	@if [ -e $(MODELS) ]; then vista_model_builder -c $(COMMAND); fi

papoulis_project: mb

pa.sh:
	echo "#!/bin/sh" > pa.sh
	echo "export ANALYSIS_LOG_FILE=pa.log" >> pa.sh
	echo "vista_analysis -sim sim" >> pa.sh
	chmod +x pa.sh

pa: $(EXE) pa.sh
	export ANALYSIS_LOG_FILE=pa.log; \
	sh pa.sh

gprof: run
	gprof ./$(EXE) > gprof.log
	rm -f gmon.out

-include $(OBJS:.o=.d)
