#!/bin/sh

msg()
{
	printf "\033[32m*\033[0m $@ \n"
}

err()
{
	printf "\033[31m*\033[0m $@ \n"
}

warn()
{
	printf "\033[33m*\033[0m $@ \n"
}

info()
{
	printf "\033[34m*\033[0m $@ \n"
}

check_user()
{
	if [ $(id -u) -eq 0 ];
	then
		msg " \"root\" accepted!"
	else
	  err " \"$USER\" (with UID: $(id -u) ) , you need to be root!"
		exit 1
	fi
}


