#! /bin/bash

#OpenVpn start script
#
#For Europe/TCP/443-SSL

FILE_OVPN="vpnbook-euro1-tcp443.ovpn"
FILE_DIR="/home/stefanozzz123/Documenti/vpnbook"

echo "You are on $(pwd)"
printf "\033[32m * \033[0mChanging Directory"
cd $FILE_DIR
printf "\n\033[34m * \033[0mUSING: $FILE_OVPN \n"
if [[ $FILE_OVPN == "vpnbook-euro1-tcp443.ovpn" ]]; then
        echo   "********************************"
	printf "\033[32m * \033[0mEurope\n"
	printf "\033[32m * \033[0mTCP\n"
	printf "\033[32m * \033[0m443/SSL\n"
        echo   "********************************"
else
	echo ""
fi
printf "\033[33m * \033[0mLaunching OpenVPN...\n"
sudo openvpn --config $FILE_OVPN
clear
printf "\033[34m * \033[0mBye bye!\n"
sleep 1

#End
