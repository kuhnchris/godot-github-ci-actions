#!/bin/bash
#set -v -x
echo "::group::Debugging information:"
echo "workdir:"
pwd
echo "os info:"
uname -a
echo "Godot executable lib dependencies"
ldd /usr/bin/godot
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
sanitizePlatform=$(echo "${PLATFORM}" | sed -e 's/[^A-Za-z0-9._-]/_/g')
localExportDirBase=.ci-exports/${sanitizePlatform}/
localTargetDirDebug=${localExportDirBase}/export-debug
localTargetDirPck=${localExportDirBase}/export-pck
localTargetDirPlatform=${localExportDirBase}/export-platform
targetDirDebug=${targetDir}/${localTargetDirDebug}/
targetDirPck=${targetDir}/${localTargetDirPck}/
targetDirPlatform=${targetDir}/${localTargetDirPlatform}/

echo "::endgroup::"


echo "::group::Linking template directory to proper directory"
sharedir=~/.local/share/
mkdir -pv ${sharedir}
ln -sv /usr/share/godot ${sharedir}/godot
echo "::endgroup::"

echo "::group::Cleaning and preparing export directories..."
rm -Rfv "${targetDirDebug}" 2>&1 || true
mkdir -pv "${targetDirDebug}"
rm -Rfv "${targetDirPck}" 2>&1 || true
mkdir -pv "${targetDirPck}"
rm -Rfv "${targetDirPlatform}" 2>&1 || true
mkdir -pv "${targetDirPlatform}"
#rm -Rf ./export-artifacts 2>&1 || true
mkdir ./export-artifacts
echo "::endgroup::"

echo "::group::Evaluating input variables..."
godot_args=()
ziping=""
zippostfix="$(date "+automated_build-%Y.%m.%d-%H%M%S")-$GITHUB_SHA"
if [ "${DEBUG}x" != "x" ] && [ "${DEBUG}x" != "falsex" ]; then
    godot_args+=("--export-debug" \""${PLATFORM}"\" "${localTargetDirDebug}/${EXECNAME}")
    ziping="zip -0 -r -D \"export-artifacts/build-${sanitizePlatform}-export-with-debug-symbols-${zippostfix}.zip\" ${targetDirDebug} ;"
fi

if [ "${PACK}x" != "x" ] && [ "${PACK}x" != "falsex" ]; then
    godot_args+=("--export-pack" \""${PLATFORM}"\" "${localTargetDirPck}/${EXECNAME}")
    ziping="${ziping}zip -0 -r -D \"export-artifacts/build-${sanitizePlatform}-export-pack-${zippostfix}.zip\" ${targetDirPck} ;"
fi

if [ "${PLATFORM_EXPORT}x" != "x" ] && [ "${PLATFORM_EXPORT}x" != "falsex" ]; then
    godot_args+=("--export" \""${PLATFORM}"\" "${localTargetDirPlatform}/${EXECNAME}")
    ziping="${ziping}zip -0 -r -D \"export-artifacts/build-${sanitizePlatform}-export-${zippostfix}.zip\" ${targetDirPlatform} ;"
fi
echo "::endgroup::"

godot_args+=("--no-window" "${targetDir}/project.godot" "--quit")
execs=(/usr/bin/godot)
chmod +x "${execs[0]}"
echo "::group::running the engine with following parameters: ${godot_args[*]}"
"${execs[0]}" "${godot_args[*]}" > "export-artifacts/engine-output-${sanitizePlatform}.log" 2>&1 
echo "::endgroup::"
echo "::group::ziping projects..."
eval "${ziping}";
echo "::endgroup::"
#set +v +x
