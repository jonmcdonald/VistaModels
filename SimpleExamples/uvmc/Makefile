UVMC_HOME = /data/uvm/uvmc-2.2
VISTA_HOME = /data/tools/vista3.5.0

SCCOM  = vista_sccom
VSIM   = vsim
SCFLAGS = -g -incr -scv -nodebug -suppress 6102 +model_builder +models_catalogue
SCMAINFLAGS = -g -incr -scv -suppress 6102 +model_builder +models_catalogue

MODELS = models
LOCAL  = diagrams
VLOGFILES = ip_if ip ip_wrapper

MODEL_BUILDER_HOME = $(VISTA_HOME)/papoulis
export MODEL_BUILDER_HOME

QUESTA_OBJDIR = work/_sc/linux_x86_64_gcc-4.3.4
vpath %.o $(QUESTA_OBJDIR)
vpath %.cpp $(MODELS)
vpath %.sv rtl

MAINSRCS = $(wildcard *.cpp)
MAINOBJS = $(MAINSRCS:.cpp=.o)
SRCS = $(wildcard $(MODELS)/*.cpp)
OBJS = $(SRCS:.cpp=.o)

VLOGOBJ = $(patsubst %, work/%/_primary.dbs, $(VLOGFILES))

MAINSRCSB = $(notdir $(MAINSRCS))
MAINOBJSB = $(notdir $(MAINOBJS))
SRCSB = $(notdir $(SRCS))
OBJSB = $(notdir $(OBJS))

INCDIR = -I. -I./include -I./$(LOCAL) -I./$(MODELS) -I$(UVMC_HOME)/src/connect/sc

.SUFFIXES: .cpp .cc .o .x .h .dbs .sv

questa: work $(VLOGOBJ) $(MAINOBJSB) $(OBJSB) 
	$(SCCOM) -link +model_builder +models_catalogue -lib $(UVMC_HOME)/lib/uvmc_lib
	ln -f -s linux_x86_64_gcc-4.3.4 work/_sc/linux_x86_64_gcc-4.3.3
	$(VSIM) -64 -dpicppinstall 4.3.3 -cppinstall 4.3.3 +UVM_NO_RELNOTES -suppress 4025,6627 -c -do "run -all; quit -f" -t 1ps -L $(UVMC_HOME)/lib/uvmc_lib sc_main ip_wrapper

$(MAINOBJSB) : %.o: %.cpp
	$(SCCOM) $(SCMAINFLAGS) $(INCDIR) $<

$(OBJSB) : %.o: %.cpp
	$(SCCOM) $(SCFLAGS) $(INCDIR) $<

$(VLOGOBJ) : work/%/_primary.dbs: %.sv
	vlog -sv -L $(UVMC_HOME)/lib/uvmc_lib +define+QUESTA $<

work:
	vlib work

clean:
	rm -rf vista_work papoulis_project work si
	find . -name "*~" -exec rm {} \;
	find . -name "*.d" -exec rm {} \;
	find . -name "*.gcno" -exec rm {} \;
	find . -name "*.gcda" -exec rm {} \;
	find . -name "*.gcov" -exec rm {} \;
	rm -rf app.info index* vista_* gcov* gmon* transcript *.png Dep *.wlf questa.log
	rm -f $(MBOBJS) $(MBARCHIVE)

