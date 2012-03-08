
#=======================================
# Modifiable Variables
#=======================================
MODELS      = models 

USERSRC     = 
USERINC     = 
USERLIBS    = 

SC_MAIN     = sc_main.cpp
DIAGRAMS    = diagrams
PROJECT     = Project

OPTIMIZE    = 0     # 0=no_optimize 1=optimize
USER_CFLAGS = 

DEBUG  = -g -tsv

#=======================================
# "stable" variables
#=======================================

EXE       = run.x
OBJDIR    = objdir
MBAR_BASE = models
MBARCHIVE = $(OBJDIR)/lib$(MBAR_BASE).a

CC        = vista_c++ -gcc43 -sc22 -Wall +model_builder +models_catalogue
OPT_FLAGS = -O3 

#=======================================
# Calculated Variables
#=======================================


ifeq ($(OPTIMIZE),1)
  # Optimizing Compile Flags
  CFLAGS    = $(OPT_FLAGS) $(USER_CFLAGS)
else
  # Debug flags
  CFLAGS    = $(DEBUG) $(USER_CFLAGS)
endif

ifeq ($(VISTA_ROOT),)
    # try to find Vista if its not set
    VISTA_ROOT         = $(patsubst %/bin/,%, $(dir $(shell which vista)))
endif
ifeq ($(MODEL_BUILDER_HOME),)
    MODEL_BUILDER_HOME = $(VISTA_ROOT)/papoulis
endif

VISTA_VERSION      = $(strip $(patsubst Vista,,$(shell vista -version)))
PAPOULIS_PROJECT   = vista_work/papoulis_project$(VISTA_VERSION)
SRCDIRS            = $(USERSRC) $(MODELS)
PWD                = $(shell pwd)

# should only add -I to non-null variables
INCDIR    = -I$(MODEL_BUILDER_HOME)/include/mb_include -I$(DIAGRAMS) $(foreach uinc, $(USERINC), -I$(uinc)) $(foreach sdir, $(MODELS) $(USERSRC), -I$(sdir)/include -I$(sdir)) 
LIBS      = -L$(OBJDIR) $(USERLIBS) 
ARLIBS    = -l$(MBAR_BASE) 


# no space allowed after "sdir" aka "item_list"
# $(foreach item, item_list, command_using_$item)
# $(patsubst find, replace, text_to_search)
MBOBJS   = $(foreach sdir, $(MODELS),  $(patsubst $(sdir)/%.cpp, $(OBJDIR)/$(sdir)/%.o, $(wildcard $(sdir)/*.cpp))  )
USEROBJS = $(foreach sdir, $(USERSRC), $(patsubst $(sdir)/%.cpp, $(OBJDIR)/$(sdir)/%.o, $(wildcard $(sdir)/*.cpp))  )
OBJDIR_TREE = $(foreach sdir, $(SRCDIRS),  $(patsubst $(sdir), $(OBJDIR)/$(sdir), $(sdir)  ))
SC_MAINOBJ  = $(SC_MAIN:%.cpp=$(OBJDIR)/%.o)

DFILES      =  $(USEROBJS:%.o=%.d) $(MBOBJS:%.o=%.d)  $(SC_MAINOBJ:%.o=%.d) 
SIM         ?= sim
PARAM_TXT   ?= parameters.txt
TRANS_TRACE ?= traces.tcl

MBIT := $(shell /bin/uname -m | /bin/sed -e 's/.*64/64/' | /bin/sed -e 's/.*[^6][^4]/32/')
.SUFFIXES: .cpp .cc .o .x .h

#=====================================
# Default Target
#=====================================

#test:
#	@echo MBOBJS= $(MBOBJS)

ifeq (1,1)
# Build executable
$(EXE).: $(OBJDIR_TREE) $(PAPOULIS_PROJECT)  $(EXE)
else 
# Build .a only 
SC_MAINOBJ = ""
lib$(MBAR_BASE).a: $(OBJDIR_TREE) $(PAPOULIS_PROJECT) $(MBARCHIVE)
endif

#=======================================
# "User" builds
#=======================================


#=======================================
# Model and final builds
#=======================================

#
# Fast Build (skip libmodel.a creation) 
#$(EXE): $(MBOBJS) $(USEROBJS) 
#	$(CC) $(CFLAGS) $(INCDIR) -o $@ $(MBOBJS) $(USEROBJS) $(LIBS) 2>&1 | c++filt
#	@if [ 0 == 1 ] ; then echo "Running vista_build_project"; vista_build_project $(PROJECT); else echo "Skip vista_build_project"; fi

# Standard Build
$(EXE): $(MBARCHIVE) $(SC_MAINOBJ)
	$(CC) $(CFLAGS)  -o $@ $(SC_MAINOBJ) $(MBARCHIVE) $(USEROBJS) $(LIBS) $(ARLIBS) 2>&1 | c++filt
	@if [ 0 == 1 ] ; then echo "Running vista_build_project"; vista_build_project $(PROJECT); else echo "Skip vista_build_project"; fi

vistagui:


# build vista Project.db file (for waveform debug, etc.)
db: $(MBARCHIVE) $(SC_MAINOBJ)
	vista_build_project $(PROJECT)

$(MBARCHIVE): $(MBOBJS) $(USEROBJS)
	ar rcs $@ $(MBOBJS) $(USEROBJS)

$(SC_MAINOBJ) $(MBOBJS) $(USEROBJS): $(OBJDIR)/%.o : %.cpp 
	$(CC) $(CFLAGS) $(INCDIR) -c $< -o $@
	@# Strip absolute pathname from local .cpp/.h in dependency files
	@$(CC) -MM $(CFLAGS) $(INCDIR) -c $< | sed -e 's|^[^ ]*:|$@:|' -e 's|$(PWD)/||' > $(@:.o=.d)

$(OBJDIR_TREE):
	mkdir -p $@

clean:
	rm -rf $(OBJDIR) 
	rm -f $(EXE) 

cleanall cleanAll clean_all:
	rm -rf vista_work sim $(OBJDIR) $(PROJECT)
	rm -f $(EXE) 

##################################
### Run/Simulate targets
##################################

vista: $(EXE) $(TRANS_TRACE)
	vista -sc22 -trace-delta-cycles -tsv -memory-profiling \
		-event-debugging -with-cause -trace-all-sockets \
		-params $(PARAM_TXT) -simdir $(SIM) -memory-profiling \
		-exec $(EXE) -simscript $(TRANS_TRACE)

batch: $(EXE) $(TRANS_TRACE)
	vista -sc22 -tsv -simscript $(TRANS_TRACE) -params $(PARAM_TXT) -simdir $(SIM) \
		-batch -exec $(EXE)

pa: $(EXE)
	vista_analysis sim

$(TRANS_TRACE):
	echo "#trace_transactions -name * -tree" > $(TRANS_TRACE)
	echo "#trace -name * -tree" >> $(TRANS_TRACE)
	echo "#trace -kind sc_object_attribute -name * -tree -unlimited" >> $(TRANS_TRACE)

##################################
### Model Builder targets
##################################

# Model Builder to re-generate models from .mb file
MB_COMMAND = 'reload_tlm_library __MODELS__;                                      \
	           foreach n [glob -directory __MODELS__ -tails *.mb] {               \
	               puts "=== GENERATING MODEL $$n (library __MODELS__) ===";      \
	               save_model -generate TLM/__MODELS__/[lindex [split \$$n .] 0]; \
               }'


# Run model_builder (generates $(PAPOULIS_PROJECT) directory)
mb $(PAPOULIS_PROJECT): 
	@#if [ -e include/custom_models.tcl ]; then \
	#	vista_model_builder -c "source include/custom_models.tcl"; fi
	@# Model Builder doesn't read vista.ini to get library map, do it manually...
	@# create_tlm_library is OK library already exists
	# Problem: load_model and save_model command needs logical name !!!
	@libmaps="`grep LibrariesMap vista.ini | sed -e 's/LibrariesMap//' -e 's/^[ ]*//' -e 's/[ ]*$$//' -e 's/[{}]//g'`" ;\
	echo libmaps= $$libmaps; \
	pair=0;                                                                  \
	for x in $$libmaps ; do                                                  \
		if [ $$pair == 1 ]; then                                             \
			pair=0; physical=$$x;                                            \
	        if [ $$physical != $$logical ]; then                             \
	            echo "!!! ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR"; \
	            echo "!!! ERROR-   Makefile does not support logical != physical libraries ($$logical != $$physical)";      \
	            echo "!!! ERROR-   Creating logical library of the physical name";                                          \
	            echo "!!! ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR"; \
	        fi                                                               \
			#vista_model_builder -c "create_tlm_library $$logical $$physical";\
			vista_model_builder -c "create_tlm_library $$physical $$physical";\
		else                                                                 \
			pair=1; logical=$$x;                                             \
		fi                                                                   \
	done                                                                     
	@for x in $(MODELS) ; do                                            \
	    mbcommand="`echo $(MB_COMMAND) | sed -e "s|__MODELS__|$$x|g"`"; \
	    if [ -e $$x ]; then                                             \
	        echo "Running Vista_model_builder on Directory $$x";        \
	        vista_model_builder -c "$$mbcommand";                       \
	    fi;                                                             \
	done

####################################################
### Help
####################################################
help:
	@echo ""
	@echo "    Build Targets:"
	@echo "    -------------"
	@echo "    run.x # (default) build executable"
	@echo "    mb    # read in *.mb files and regenerate code"
	@echo "    db    # Build Project.db debug database"
	@echo "    vista # simulation in Vista GUI"
	@echo "    batch # simulation in batch mode"
	@echo "    pa    # Power Analysis of simulation"
	@echo "    pa    # Power Analysis of simulation"
	@echo ""
	@echo "    clean     # remove compiled files"
	@echo "    clean_all # remove compiled files and Vista temp files"
	@echo ""

-include $(DFILES)
