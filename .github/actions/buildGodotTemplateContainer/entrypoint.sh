#!/bin/sh
#set -v -x
TAG=godot-github-ci-actions
#GODOT_VERSION=$1
#GODOT_VERSION=INPUT_GODOT_VERSION

cd "${ACTION_PATH}" || exit 2;
sed 's/\$1/'${GODOT_VERSION}'/g' -i fetchGodot/entrypoint.sh
cd fetchGodot || exit 2;
docker build . --file Dockerfile --tag "${TAG}" --label "runnumber=${GITHUB_RUN_ID}"
cd ..
