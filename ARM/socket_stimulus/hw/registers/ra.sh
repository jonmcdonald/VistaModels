#!/bin/sh
export RA_HOME=/mnt/store/tools/HDS_2013.1b/registerassistant

echo "Block Name,Project Parameter Name,Project Parameter Value,Project Parameter Description" > input/C_settings.csv
echo -n "reg_block,c.TEMPLATE_PATH," >> input/C_settings.csv
PWD=`pwd`
echo -n `./path_convert.sh $RA_HOME/resources/templates $PWD/input/c_header.h` >> input/C_settings.csv
echo ",Path to the C header template." >> input/C_settings.csv

$RA_HOME/regassist -project ./output -f ./ctrl.rcf > logfile.txt 
cat logfile.txt
