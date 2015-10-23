#!/bin/bash

check_user()
{
				if [ $(id -u) -eq 0 ];
				then
								printf "\033[32mGranted\033[0m\n"
				else
								printf "\033[31mHey, $USER, you must be r00t!!\033[0m\n"
								exit 1
				fi
}

monitor_start()
{
				INTERF=$1
				printf "\033[33m*\033[0m Killing services... (dhclient, dhcpcd, avahi-daemon, NetworkManager, wpa_supplicant)\n"
				killall avahi-daemon 2> /dev/null
				killall NetworkManager 2> /dev/null
				killall wpa_supplicant 2> /dev/null
				killall dhclient 2> /dev/null
				killall dhcpcd 2> /dev/null
				printf "\033[33m*\033[0m Enabling monitor mode on ${INTERF}...\n"
				iwconfig $INTERF mode monitor && printf "\033[32m*\033[0m $INTERF MODE: monitor\n" || exit 3
}

monitor_stop()
{
				INTERF=$1
				printf "\033[33m*\033[0m Starting services... (dhclient, dhcpcd, avahi-daemon,NetworkManager,wpa_supplicant)\n"
				systemctl start avahi-daemon 2> /dev/null
				systemctl start wpa_supplicant 2> /dev/null
				systemctl start NetworkManager 2> /dev/null
				systemctl start dhclient 2> /dev/null
				systemctl start dhcpcd 2> /dev/null
				printf "\033[33m*\033[0m Enabling managed mode on ${INTERF}...\n"
				iwconfig $INTERF mode managed && printf "\033[32m*\033[0m $INTERF MODE: managed\n" || exit 3
				printf "\033[33m*\033[0m Restarting NetworkManager...\n"
				systemctl restart NetworkManager
}

main()
{
				OPTION=$1
				CARD=$2
				check_user
				if [[ $OPTION == "start" ]];
				then
								printf "\033[32m*\033[0m Starting monitor mode on $CARD\n"
								monitor_start $CARD
								printf "\033[32m*\033[0m Done.\n"
				elif [[ $OPTION == "stop" ]];
				then
								printf "\033[32m*\033[0m Switching to managed mode on $CARD\n"
								monitor_stop $CARD
								printf "\033[32m*\033[0m Done.\n"
				fi
}

main $1 $2
