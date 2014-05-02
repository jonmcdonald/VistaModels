#!/bin/sh

cd sw_cache
make clean
make GPU=1
cd ..
rm -rf sim2

vista_sw_tool tracing/begin.tcl
vista_simulate -simdir sim2 Project

cd sim2
vista_sw_tool ../tracing/end.tcl
cd ..
