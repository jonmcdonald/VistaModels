#!/bin/sh

cd ../..
export VISTA_PARAMETERS_FILE=params.gdb
vista_run arm.x &

sleep 3

