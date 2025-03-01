#!/bin/bash

copy() {
	echo -ne "checking for $1... "
	if [ -f $1 ]; then
		cp $PWD/$1 $2 && echo "ok" || echo "copy failed"
	else
		echo "file does not exist"
	fi 
}

DISTRO=$(cat /etc/os-release | grep ^ID= | tr '=' '\n' | tail -1)

VSCODE_DIR="../.vscode"
TEMPLATED_VSCODE_C_CPP_PROPS="vscode/${DISTRO}_c_cpp_properties.json"
VSCODE_C_CPP_PROPS="$VSCODE_DIR/c_cpp_properties.json"
TEMPLATED_YCMEXCONF="${DISTRO}_ycm_extra_conf.py"
YCMEXCONF="../.ycm_extra_conf.py"

mkdir -p $VSCODE_DIR
copy $TEMPLATED_VSCODE_C_CPP_PROPS $VSCODE_C_CPP_PROPS
copy $TEMPLATED_YCMEXCONF $YCMEXCONF

GCC_TARGET=$(gcc -v 2>&1 | grep 'Target' | awk '{ print $2 }')
GCC_DUMPVER=$(gcc -dumpversion)
LINUX_UNAMER=$(uname -r)

if [ -f $VSCODE_C_CPP_PROPS ]; then
	sed -i "s/__template_GCC_TARGET/$GCC_TARGET/g" $VSCODE_C_CPP_PROPS
	sed -i "s/__template_GCC_DUMPVER/$GCC_DUMPVER/g" $VSCODE_C_CPP_PROPS
	sed -i "s/__template_LINUX_UNAMER/$LINUX_UNAMER/g" $VSCODE_C_CPP_PROPS
fi

if [ -f $YCMEXCONF ]; then
	sed -i "s/__template_LINUX_UNAMER/$LINUX_UNAMER/g" $YCMEXCONF
fi

echo " -- gcc target: $GCC_TARGET"
echo " -- gcc version: $GCC_DUMPVER"
echo " -- linux version: $LINUX_UNAMER"
