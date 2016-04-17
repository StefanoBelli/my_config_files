#!/bin/bash

#
# Stefano Belli, 
# Simple script to use zram devices
#
# Enable zRam 
# This assumes module is already loaded
# And devices created
# to do that:
# 
# *** Add "zram" to /etc/modules 
#
# % echo "zram" >> /etc/modules
# 
# *** Then change kernel boot parameter, using your favourite editor
#
# % vi /etc/default/grub
# --> GRUB_CMDLINE_LINUX="zram.num_devices=NDEVICES" 
# 
# Where NDEVICES is an integer which says how many /dev/zramX should be created (from 0 -> NDEVICES-1) 
#
# *** Finally, update grub configuration
# 
# # grub-mkconfig -o /boot/grub/grub.cfg
# 
# on debian-based distros you will find an alias -> update-grub
#

NDEVICES=0 #DON'T CHANGE THIS

LOGFILE=/var/log/zram_enable.log # DON'T CHANGE THIS 
KSYS_BLK_PATH=/sys/block/zram #DON'T CHANGE THIS
DEV_BLK_PATH=/dev/zram #DON'T CHANGE THIS
SWAP_ZRAM=0 # DON'T CHANGE THIS
EXTF_ZRAM=0 # DON'T CHANGE THIS 

SWAP_SZ="512M" #Change this value if you want
EXTF_SZ="1G" #Change this value if you want
MCOMP_STREAMS=4 #Change this value if you want

pre_enable_checks() 
{
	index=0

	NDEVICES=$1

	if which modprobe >>/dev/null 2>/dev/null; 
	then
		echo "modprobe found..." >> $LOGFILE 
	else
		echo "modprobe not found..." >> $LOGFILE 
		echo "Exiting... (1) " >> $LOGFILE
		exit 1
	fi
	
	if modprobe -n zram >>/dev/null 2>/dev/null;
	then
		echo "zram module found..." >> $LOGFILE 
	else
		echo "zram module not found..." >> $LOGFILE 
		echo "Exiting... (1)" >> $LOGFILE 
		exit 1
	fi

	while [[ $index < ${NDEVICES}-1 ]]; 
	do 
		if [ $index -eq $NDEVICES ]; 
		then
			break
		fi

		echo "---zram${index}---" >> $LOGFILE 
		if [ -d $KSYS_BLK_PATH${index} ]; 
		then
			echo "$KSYS_BLK_PATH${index} ... exists" >> $LOGFILE
		else
			echo "$KSYS_BLK_PATH${index} ... FAIL!" >> $LOGFILE
			echo "Exiting... (1)" >> $LOGFILE
			exit 1
		fi

		if find /dev -name "zram${index}" >>/dev/null 2>/dev/null;
		then
			echo "$DEV_BLK_PATH${index} ... exists" >> $LOGFILE 
		else
			echo "$DEV_BLK_PATH${index} ... FAIL!" >> $LOGFILE
			echo "Exiting... (1)" >> $LOGFILE
			exit 1
		fi

		if [ -f $KSYS_BLK_PATH${index}/disksize ];
		then
			echo "disksize file found (zram${index})" >> $LOGFILE 
		else
			echo "disksize file NOT FOUND (zram${index})" >> $LOGFILE 
			echo "Exiting... (1)" >> $LOGFILE 
			exit 1
		fi

		index=$[$index+1]
	done
}

enable_zram() 
{
	index=0
	SWAP_ZRAM=$((NDEVICES/2))
	EXTF_ZRAM=$((NDEVICES/2))
	NEXTF_ZRAM=$((EXTF_ZRAM*2))

	echo "--> Enabling ZRam devices" >> $LOGFILE 
	
	while [[ $index < ${SWAP_ZRAM}-1 ]]; 
	do
		if [ $index -eq $SWAP_ZRAM ];
		then
			break
		fi

		echo "--> zram${index} " >> $LOGFILE 
		echo "--> swap " >> $LOGFILE 
		echo "--> size: ${SWAP_SZ} " >> $LOGFILE 

		echo ${MCOMP_STREAMS} > $KSYS_BLK_PATH${index}/max_comp_streams 
		echo ${SWAP_SZ} > $KSYS_BLK_PATH${index}/disksize 
	   
		/sbin/mkswap -L "swap_zram${index}" $DEV_BLK_PATH${index} 2>/dev/null >>/dev/null &&\
			/sbin/swapon $DEV_BLK_PATH${index} 2>/dev/null >>/dev/null 

		if [ $? -eq 0 ];
		then
			echo "--> zram${index} enabled as SWAP DEVICE! -- LABEL: swap_zram${index}" >> $LOGFILE 
		else
			echo "--> zram${index} could not enabled as swap device!" >> $LOGFILE 
			exit 2
		fi

		index=$[$index+1] 
	done

	while [[ $index < ${NEXTF_ZRAM}-1 ]];
	do
		if [ $index -eq ${NEXTF_ZRAM} ];
		then
			break
		fi

		echo "--> zram${index} " >> $LOGFILE 
		echo "--> ext4_fs " >> $LOGFILE 
		echo "--> size: ${EXTF_SZ} " >> $LOGFILE 

		echo ${MCOMP_STREAMS} > $KSYS_BLK_PATH${index}/max_comp_streams
		echo ${EXTF_SZ} > $KSYS_BLK_PATH${index}/disksize 

		/sbin/mkfs.ext4 -L "zram${index}" $DEV_BLK_PATH${index} 2>/dev/null >>/dev/null &&\
			/bin/mount $DEV_BLK_PATH${index} /tmp 

		if [ $? -eq 0 ]; 
		then
				echo "--> zram${index} enabled as DEVICE! (/tmp) -- LABEL: zram${index}" >> $LOGFILE 
				/bin/chmod 1777 /tmp # set default permissions
		else

			echo "--> zram${index} could not be enabled as device!" >> $LOGFILE
			exit 2
		fi

		index=$[$index+1] 
	done
}

# You must be root 
if [ ! $UID -eq 0 ];
then
	exit 3
fi

printf '' > $LOGFILE 

if [[ $# < 1 ]] || [[ $# > 1 ]]; 
then
		echo "** You must specify how many zram devices you have" >> $LOGFILE 
		exit 2
fi

pre_enable_checks $1
enable_zram 

	
