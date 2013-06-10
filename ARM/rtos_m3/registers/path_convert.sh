#!/bin/bash
# both $1 and $2 are absolute paths
# returns $2 relative to $1

source=$1
target=$2

common_part=$source
back=
while [ "${target#$common_part}" = "${target}" ]; do
  common_part=$(dirname $common_part)
  back="../${back}"
done

echo ${back}${target#$common_part/}

