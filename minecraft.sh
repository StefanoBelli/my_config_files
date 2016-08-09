#!/bin/sh

MCPATH=/opt/minecraft/minecraft.jar
JAVA=/usr/bin/java
JAVA_FLAGS=-jar

echo " *** Checking requirements before launching... "

if ! which java 2>/dev/null >>/dev/null;
then
	echo " !!! Java wasn't found in $PATH "
	exit 1
fi

echo " +++ Java found in $PATH"

if [ ! -f $MCPATH ];
then
	echo " !!! Cannot find $MCPATH "
	exit 2
fi

echo " +++ Found $MCPATH"

echo " *** Launching minecraft..."

$JAVA $JAVA_FLAGS $MCPATH

echo " !!! Bye bye"
