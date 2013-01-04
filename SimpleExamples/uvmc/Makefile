TARGET_ARCH = linux64

CC     = vista_c++
SCCOM  = sccom
OPT    = 
DEBUG  = -g -DMB_DEBUG
OTHER  =
SCFLAGS = $(DEBUG) $(OTHER) -64 -DSC_INCLUDE_DYNAMIC_PROCESSES -DQUESTA -suppress 6102 
CFLAGS = $(DEBUG) $(OTHER)

MODELS = models
LOCAL  = diagrams
Project = Project

VISTA_HOME = /data/tools/vista3.5.0
QUESTA_HOME = /data/tools/questa_10.0d/questasim
UVM_HOME = /data/uvm/uvm-1.1c
UVMC_HOME = /data/uvm/uvmc-2.2

MODEL_BUILDER_HOME = $(VISTA_HOME)/papoulis
export MODEL_BUILDER_HOME

QUESTA_OBJDIR = work/_sc/linux_x86_64_gcc-4.3.3

vpath %.o $(QUESTA_OBJDIR)
vpath %.cpp $(MODELS)
vpath %.sv rtl

SRCS = $(wildcard *.cpp) $(wildcard $(MODELS)/*.cpp)
OBJS = $(SRCS:.cpp=.o)

VLOGFILES = ip_if ip ip_wrapper
VLOGOBJ = $(patsubst %, work/%/_primary.dbs, $(VLOGFILES))

SRCSB = $(notdir $(SRCS))
OBJSB = $(notdir $(OBJS))

INCDIR = -I. -I./include -I./$(LOCAL) -I./$(MODELS) \
         -I$(MODEL_BUILDER_HOME)/include \
         -I$(QUESTA_HOME)/include \
         -I$(QUESTA_HOME)/include/systemc \
         -I$(VISTA_HOME)/generic/include \
         -I$(UVMC_HOME)/src/connect/sc

LIBS   = $(EXTRA_LIBS) 
MBLIBS = $(MODEL_BUILDER_HOME)/$(TARGET_ARCH)/libst.esl.library.so \
	 $(MODEL_BUILDER_HOME)/$(TARGET_ARCH)/vista-gcc43-mti100/esl.sc_sim.a
EXE    = $(MODULE).x

.SUFFIXES: .cpp .cc .o .x .h .dbs .sv

questa: work $(VLOGOBJ) $(OBJSB) 
	$(SCCOM) -64 -link -DSC_INCLUDE_DYNAMIC_PROCESSES -lib $(UVMC_HOME)/lib/uvmc_lib $(MBLIBS)
	vsim -64 -suppress 4025 -c -do "run -all; quit -f" -t 1ps -L $(UVMC_HOME)/lib/uvmc_lib -l questa.log sc_main ip_wrapper

$(OBJSB) : %.o: %.cpp
	$(SCCOM) $(SCFLAGS) $(INCDIR) $<

$(VLOGOBJ) : work/%/_primary.dbs: %.sv
	vlog -64 -sv +incdir+$(UVM_HOME)/src -L $(UVMC_HOME)/lib/uvmc_lib +define+QUESTA $<

work:
	vlib work

clean:
	rm -rf vista_work $(Project) Source Object sim papoulis_project work
	find . -name "*~" -exec rm {} \;
	find . -name "*.d" -exec rm {} \;
	find . -name "*.gcno" -exec rm {} \;
	find . -name "*.gcda" -exec rm {} \;
	find . -name "*.gcov" -exec rm {} \;
	rm -rf app.info index* vista_* gcov* gmon* transcript *.png Dep *.wlf
	rm -f $(MBOBJS) $(MBARCHIVE) $(EXE)

