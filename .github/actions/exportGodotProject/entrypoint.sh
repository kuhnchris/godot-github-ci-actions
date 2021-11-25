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
echo "$@"
echo "::endgroup::"

echo "::group::Parsing and preparing variables"

targetDir=${GITHUB_WORKSPACE}
BASE_DIR=$1
DEBUG=$2
PACK=$3
PLATFORM_EXPORT=$4
PLATFORM=$5
EXECNAME=$6
if [ "${BASE_DIR}x" != "x" ] && [ "$BASE_DIR" != "false" ]; then
    targetDir="${GITHUB_WORKSPACE}/${BASE_DIR}/"
    echo "Using this project directory: ${targetDir}"
fi

targetDirDebug=${targetDir}/export-debug/
targetDirPck=${targetDir}/export-pck/
targetDirPlatform=${targetDir}/export-platform/
echo "::endgroup::"

echo "::group::Cleaning and preparing export directories..."
rm -Rf "${targetDirDebug}" 2>&1 || true
mkdir "${targetDirDebug}"
rm -Rf "${targetDirPck}" 2>&1 || true
mkdir "${targetDirPck}"
rm -Rf "${targetDirPlatform}" 2>&1 || true
mkdir "${targetDirPlatform}"
rm -Rf ./export-artifacts 2>&1 || true
echo "::endgroup::"

echo "::group::Evaluating input variables..."
godot_args=""
ziping=""
zippostfix="$(date "+automated_build-%Y.%m.%d-%H:%M:%S")-$GITHUB_REF"
if [ "${DEBUG}x" != "x" ] && [ "${DEBUG}x" != "falsex" ]; then
    godot_args="${godot_args} --export-debug ${PLATFORM} ${targetDirDebug}/${EXECNAME}"
    ziping="zip -0 -r export-artifacts/export-with-debug-symbols-${zippostfix}.zip ${targetDirDebug};"
fi

if [ "${PACK}x" != "x" ] && [ "${PACK}x" != "falsex" ]; then
    godot_args="${godot_args} --export-pack ${PLATFORM} ${targetDirPck}/${EXECNAME}"
    ziping="zip -0 -r export-artifacts/export-pack-${zippostfix}.zip ${targetDirPck};"
fi

if [ "${PLATFORM_EXPORT}x" != "x" ] && [ "${PLATFORM_EXPORT}x" != "falsex" ]; then
    godot_args="${godot_args} --export ${PLATFORM} ${targetDirPlatform}/${EXECNAME}"
    ziping="zip -0 -r export-artifacts/export-${zippostfix}.zip ${targetDirPlatform};"
fi
echo "::endgroup::"

execs=(./Godot*)

chmod +x "${execs[0]}"
echo "::group::running the engine with following parameters: ${godot_args}"
"${execs[0]}" "${godot_args}" --no-window "${targetDir}"/project.godot --quit
echo "::group::ziping projects..."
${ziping}
echo "::endgroup::"
#set +v +x
