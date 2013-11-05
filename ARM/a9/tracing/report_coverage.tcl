# vista_sw_tool tracing/report_coverage.tcl; google-chrome tracing/data/coverage.html

use_coverage
load_design tracing/data/gears.dgn
load_test tracing/data/coverage.tst
dump_report -output tracing/data/coverage.html

