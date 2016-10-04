use_coverage

load_design ./mybit.dgn
load_test ./mybit.tst

dump_report -output coverage.html -full -source-dir ../sw


