#!/bin/sh

cd sw_cache
make clean
make
cd ..
rm -rf sim

vista_sw_tool tracing/begin.tcl
vista_simulate -simdir sim Project

cd sim
vista_sw_tool ../tracing/end.tcl
cd ..

