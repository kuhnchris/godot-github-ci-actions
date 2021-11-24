#!/bin/sh
targetDir=$GITHUB_WORKSPACE
#set -v -x
GODOT_VERSION=$1
echo "::debug::running with parameters: $GITHUB_WORKSPACE - $GODOT_VERSION" 
if [ "$GODOT_VERSION" == "" ]; then
    echo "no Godot Version defined. cannot proceed."
    exit 2
fi  

cd $targetDir;
if [ "$BASE_DIR" != "" ]; then
    targetDir="/github/workspace/${BASE_DIR}/"
fi
echo "downloading templates... https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz"
wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz -O templ.tpz
echo "downloading engine... https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_x11.64.zip"
wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_x11.64.zip -O app.zip
unzip app.zip
chmod +x godot*
mkdir ~/.local/share/godot/templates -p
unzip templ.tpz
mv templates ~/.local/share/godot/${GODOT_VERSION}.stable

#set +v +x