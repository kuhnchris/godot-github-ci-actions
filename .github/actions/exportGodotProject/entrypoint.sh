#!/bin/sh
#set -v -x
targetDir=${GITHUB_WORKSPACE}
BASE_DIR=$1
DEBUG=$2
PACK=3
PLATFORM=4
if [ "$BASE_DIR" != "" ]; then
    targetDir="${GITHUB_WORKSPACE}/${BASE_DIR}/"
fi

rm -Rf ./export-debug 2>&1| true
rm -Rf ./export-pck 2>&1| true
rm -Rf ./export-platform 2>&1| true
mkdir export-debug
mkdir export-pck
mkdir export-platform

godot_args=""
if [ "${DEBUG}x" == "x" ]; then
    godot_args="${godot_args} --export-debug ${PLATFORM} ./export-debug"
fi

if [ "${PACK}x" == "x" ]; then
    godot_args="${godot_args} --export-pack ${PLATFORM} ./export-pck"    
fi

if [ "${PLATFORM}x" == "x" ]; then
    godot_args="${godot_args} --export ${PLATFORM} ./export-platform"
fi

./Godot* ${godot_args} --no-window
#set +v +x