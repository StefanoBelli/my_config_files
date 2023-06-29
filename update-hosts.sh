#!/bin/sh

while ! ping -c 1 example.com; do sleep 1; done

SRC="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts"

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to update your hosts file"
	exit 1
fi

echo "Downloading hosts file from source..."
wget $SRC -O /tmp/hosts || exit 2
echo "Backing up previous hosts file: /etc/hosts -> /etc/hosts.prev"
mv /etc/hosts /etc/hosts.prev || exit 3
echo "Installing new hosts file..."
mv /tmp/hosts /etc/hosts || exit 4
echo "Done"
