use_coverage

load_design ../tracing/data/image.dgn
load_test ../tracing/data/image.tst

dump_report -output coverage.html -full -source-dir sw_cachce
profiling::generate_report ../tracing/data/cache_prof -output cache_prof.html

