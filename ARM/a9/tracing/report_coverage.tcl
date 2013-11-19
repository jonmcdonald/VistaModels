# cd tracing/data; vista_sw_tool ../report_coverage.tcl; cd ../..; google-chrome tracing/data/coverage.html

use_coverage
load_design gears.dgn
load_test coverage.tst
dump_report -output coverage.html

