#!/bin/bash

LINUX_UNAMER=$(uname -r)
DEFAULT_KERNSRCBASE="/lib/modules/$LINUX_UNAMER/build"
DISTRO=$(cat /etc/os-release | grep ^ID= | tr '=' '\n' | tail -1)

declare -A DISTRO_KERNSRCBASE

DISTRO_KERNSRCBASE[gentoo]="/usr/src/linux-$LINUX_UNAMER"
DISTRO_KERNSRCBASE[fedora]="/usr/src/kernels/$LINUX_UNAMER"

echo " -- distro: $DISTRO"

kernsrcbase=$DEFAULT_KERNSRCBASE

if [[ ${DISTRO_KERNSRCBASE[$DISTRO]} != "" ]]; then
	echo " -- using specific src path for $DISTRO"
	kernsrcbase=${DISTRO_KERNSRCBASE[$DISTRO]}
else
	echo " -- using default src as $DISTRO is not known"
fi

echo " -- kernsrcbase: $kernsrcbase"

copy() {
	echo -ne "checking for $1... "
	if [ -f $1 ]; then
		cp $PWD/$1 $2 && echo "ok" || echo "copy failed"
	else
		echo "file does not exist"
	fi 
}

VSCODE_DIR="../.vscode"
YCMEXCONF="../.ycm_extra_conf.py"
VSCODE_C_CPP_PROPS="$VSCODE_DIR/c_cpp_properties.json"

TEMPLATED_VSCODE_C_CPP_PROPS="templated_c_cpp_properties.json"
TEMPLATED_YCMEXCONF="templated_ycm_extra_conf.py"

mkdir -p $VSCODE_DIR
copy $TEMPLATED_VSCODE_C_CPP_PROPS $VSCODE_C_CPP_PROPS
copy $TEMPLATED_YCMEXCONF $YCMEXCONF

if [ -f $VSCODE_C_CPP_PROPS ]; then
	sed -i "s,__template_KERNSRCBASE,$kernsrcbase,g" $VSCODE_C_CPP_PROPS
fi

if [ -f $YCMEXCONF ]; then
	sed -i "s,__template_KERNSRCBASE,$kernsrcbase,g" $YCMEXCONF
fi

echo " -- linux version: $LINUX_UNAMER"
