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

echo "::group::using this url prefix: ${URL_PREFIX}"
echo "::group::downloading templates... export_templates.tpz"
wget ${URL_PREFIX}export_templates.tpz -O templ.tpz
echo "::endgroup::"
echo "::group::downloading engine... x11.64.zip"
wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_x11.64.zip -O app.zip
echo "::endgroup::"
echo "::endgroup::"
echo "::group::unzipping engine zip file..."
unzip app.zip
echo "::endgroup::"
echo "::group::make engine executable..."
chmod +x Godot*
echo "::endgroup::"
echo "::group::creating template directory..."
mkdir ${TEMPLATE_BASE} -p -v
echo "::endgroup::"
echo "::group::unzipping template zip..."
unzip templ.tpz
echo "::endgroup::"
echo "::group::moving templates to ${TEMPLATE_TARGET}"
mv -v templates "${TEMPLATE_TARGET}"
echo "::endgroup::"

#set +v +x