#!/bin/sh
#set -v -x
targetDir=${GITHUB_WORKSPACE}
GODOT_VERSION=$1
TEMPLATE_TARGET=${TEMPLATE_TARGET}/${GODOT_VERSION}.stable
TEMPLATE_BASE=~/.local/share/godot/templates
URL_PREFIX=https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_
echo "::debug::running with parameters: $GITHUB_WORKSPACE - $GODOT_VERSION" 
if [ "$GODOT_VERSION" == "" ]; then
    echo "no Godot Version defined. cannot proceed."
    exit 2
fi  
cd ${targetDir};

echo "::debug::using this url prefix: ${URL_PREFIX}"
echo "downloading templates... export_templates.tpz"
wget ${URL_PREFIX}export_templates.tpz -O templ.tpz
echo "downloading engine... x11.64.zip"
wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_x11.64.zip -O app.zip
echo "::debug::unzipping engine zip file..."
unzip app.zip
echo "::debug::make engine executable..."
chmod +x Godot*
echo "::debug::creating template directory..."
mkdir ${TEMPLATE_BASE} -p -v
echo "::debug::unzipping template zip..."
unzip templ.tpz
echo "::debug::moving templates to ${TEMPLATE_TARGET}"
mv -v templates ${TEMPLATE_TARGET}

#set +v +x