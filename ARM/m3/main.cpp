#include "simple.h"
#include "rijndael_tb.h"
#include <time.h>

#define TOP rijndael_tb

int sc_main(int argc, char *argv[]) {

  //sc_report_handler::set_actions("/IEEE_Std_1666/deprecated", SC_DO_NOTHING);

  TOP *inst_top_arm = new TOP("Top");

  clock_t TimeStart = clock ();


  sc_start();

  clock_t TimeStop = clock ();

  delete inst_top_arm;

  cout << endl << "CPU time: " 
       << difftime (TimeStop, TimeStart) / CLOCKS_PER_SEC << " sec" 
       << endl << endl;

  return 0;
}
