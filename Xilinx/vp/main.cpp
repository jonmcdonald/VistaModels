
#include "vptop.h"
#include "RealTimeStall.h"

bool parse_arguments(int argc, char *argv[])
{
  for (int u = 0; u < argc; u++) {
    if (argv[u][0] == '-') {
      if (!strcmp(argv[u], "-d")) {
        mb::sysc::set_parameter("gdbstub_port", 1234);
      }
      if (!strcmp(argv[u], "-t")) {
        u++;
        mb::sysc::set_parameter("trace_script", argv[u]);
      }
    } else {
      mb::sysc::set_parameter("top.Zynq_SoC_inst.cpu_inst0.CPU_INST0.elf_image_file", argv[u]);
    }
  }

  return true;
}

int sc_main(int argc, char *argv[]) {

  if (!parse_arguments(argc - 1, argv + 1)) {
    fprintf(stderr, "Wrong arguments.\n");
    return -1;
  }

  vptop *inst_top = new vptop("top");
  RealTimeStall *m_stall = new RealTimeStall("stall");

  sc_start();
  delete inst_top;

  return 0;
}
