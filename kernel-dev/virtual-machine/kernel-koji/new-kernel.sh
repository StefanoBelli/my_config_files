#!/bin/bash

echo " *** Installing new kernel: $1"
mkdir $1

echo " *** Entering directory: $1"
pushd $1 2>/dev/null >>/dev/null

echo " *** Running koji to get kernel $1..."
koji download-build --arch=x86_64 --arch=noarch kernel-$1

if [ $? -ne 0 ]; then
	echo " !!! koji ran into trouble while installing kernel $1 "

	echo " !!! Exiting directory $1..."
	popd 2>/dev/null >>/dev/null

	echo " !!! Removing directory $1..."
	rm -rf $1

	echo " !!! bye bye"
	exit 1
fi

echo " *** Removing debug rpms, if any..."
rm *debug*.rpm

echo " *** Removing UKI rpms, if any..."
rm *uki*.rpm

echo " *** Running dnf install, you must confirm"
sudo dnf install * --skip-broken

echo " *** Exiting directory $1..."
popd 2>/dev/null >>/dev/null

echo " *** bye bye"

