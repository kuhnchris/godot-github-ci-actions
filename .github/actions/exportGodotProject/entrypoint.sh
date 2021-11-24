#!/bin/bash
#set -v -x
echo "::group::Debugging information:"
echo "workdir:"
pwd
echo "os info:"
uname -a
echo "Godot executable lib dependencies"
ldd Godot*
echo "current workdir listing:"
ls -alh
echo "command line:"
echo $@
echo "::endgroup::"

targetDir=${GITHUB_WORKSPACE}
BASE_DIR=$1
DEBUG=$2
PACK=$3
PLATFORM_EXPORT=$4
PLATFORM=$5
if [ "$BASE_DIR" != "" && "$BASE_DIR" != "false" ]; then
    targetDir="${GITHUB_WORKSPACE}/${BASE_DIR}/"
    echo "Using this project directory: ${targetDir}"
fi

rm -Rf ./export-debug 2>&1| true
rm -Rf ./export-pck 2>&1| true
rm -Rf ./export-platform 2>&1| true
rm -Rf ./export-artifacts 2>&1 | true
mkdir export-debug
mkdir export-pck
mkdir export-platform
mkdir export-artifacts

godot_args=""
ziping=""
zippostfix="`date "+automated_build-%Y.%m.%d-%H:%M:%S"`-$GITHUB_REF"
if [ "${DEBUG}x" != "x" && "${DEBUG}x" != "falsex" ]; then
    godot_args="${godot_args} --export-debug ${PLATFORM} ./export-debug"
    ziping="; zip -0 -r export-artifacts/export-with-debug-symbols-${zippostfix}.zip ./export-debug ;"
fi

if [ "${PACK}x" != "x"  && "${PACK}x" != "falsex" ]; then
    godot_args="${godot_args} --export-pack ${PLATFORM} ./export-pck/game.pck"    
    ziping="; zip -0 -r export-artifacts/export-pack-${zippostfix}.zip ./export-pck;"
fi

if [ "${PLATFORM_EXPORT}x" != "x" && "${PLATFORM_EXPORT}x" != "falsex" ]; then
    godot_args="${godot_args} --export ${PLATFORM} ./export-platform"
    ziping="; zip -0 -r export-artifacts/export-${zippostfix}.zip ./export-platform;"
fi

chmod +x Godot*
./Godot* ${godot_args} --no-window ${targetDir}/project.godot
echo "::group::ziping projects..."
${ziping}
echo "::endgroup::"
#set +v +x