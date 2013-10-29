
# vista_sw_tool -c "coverage::create_design software/gears.axf -output tracing/data/gears.dgn"

set current_core "top.cpu.PV.core"

add_default_symbol_file

enable_coverage -design tracing/data/gears.dgn -test tracing/data/coverage.tst

