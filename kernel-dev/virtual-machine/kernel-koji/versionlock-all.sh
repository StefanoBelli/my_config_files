#!/bin/bash

for i in $(ls); do
	if [[ $i == "new-kernel.sh" || $i == "versionlock-all.sh" ]]; then
		echo "skip $i"
		continue
	fi

	echo "locking kernel version $i"
	sudo dnf versionlock add kernel-*-0:$i kernel-*0:$i
done
