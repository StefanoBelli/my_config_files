#!/bin/sh

PREDEF_USER="stefanozzz123"

if [ $(id -u) -eq 0 ];
then
	printf "* Allowed\n"
else
	printf "* You must be root! :(\n"
	exit 1
fi

if which pacman 2>/dev/null >>/dev/null; 
then
				echo "=======PACMAN======"
				pacman -Syyu --noconfirm && echo "* System upgrade done" || exit 2
				pacman -Scc --noconfirm && echo "* System clean done" || exit 2
				pacman-db-upgrade && echo "* System database upgrade done" || exit 2
				pacman-optimize && echo "* Complete pacman optimize done" || exit 2
fi

if which yaourt 2>/dev/null >>/dev/null;
then
				echo "=====YAOURT====="
				su - stefanozzz123 -c "yaourt -Syu --noconfirm" && echo "* AUR Packages upgraded" || exit 2
fi

