#!/bin/sh
targetDir="/github/workspace/"
#set -v -x

cd $targetDir;
if [ "$BASE_DIR" != "" ]; then
    targetDir="/github/workspace/${BASE_DIR}/"
fi

wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz -O templ.tpz
wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_x11.64.zip -O app.zip
unzip app.zip
chmod +x godot*
mkdir ~/.local/share/godot/templates -p
tar xf templ.tpz
mv templates ~/.local/share/godot/${GODOT_VERSION}.stable

#set +v +x