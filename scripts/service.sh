#!/bin/sh

SERVICE=$1 
MODE=$2

if [[ $USER == "root" ]]; 
then
   /etc/init.d/$SERVICE $MODE && 
	exit 0 || 
	echo "There was a problem"
	exit 2
else
	printf "\033[31m * \033[0m Only superuser can do that. :( I am so sorry\n"
	exit 1
fi
