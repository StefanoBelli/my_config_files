#!/bin/sh

CURRENT_HOSTNAME=$(cat /etc/hostname) 
CURRENT_HOSTNAME_FILE=/etc/hostname.bak
COMMON_FUNCT_DIR="/usr/lib/anonymode"
COMMON_FUNCT_PATH="/usr/lib/anonymode/common.sh"

if [ -d $COMMON_FUNCT_DIR ];
then
	source $COMMON_FUNCT_PATH
else
	printf "\033[31m*\033[0m You need to put common.sh in /usr/lib/anonymode!!\n"
	exit 1
fi

#check_user

checks_before_start()
{
				check_user
				if which tor 2>/dev/null;
				then
								msg "tor found" 
				else
								err "tor not found"
								err "Aborting..."
								exit 2
				fi

				if which torify 2>/dev/null;
				then
								msg "torify found"
				else
								err "torify not found"
								err "Aborting..."
								exit 3
				fi

				if which torsocks 2>/dev/null;
				then
								msg "torsocks found"
				else
								err "torsocks not found"
								err "Aborting..."
								exit 4
				fi

				if which iptables 2>/dev/null;
				then
								msg "iptables found"
				else
								err "iptables not found"
								err "Aborting..."
								exit 5
				fi

				if which systemctl 2>/dev/null;
				then
								msg "systemctl found"
				else
								err "systemctl not found"
								err "Aborting..."
								exit 6
				fi

				[ -f /etc/tor/torrc ] && msg "/etc/tor/torrc found on filesystem" || err "You need to create /etc/tor/torrc"
				[ -f /etc/tor/torsocks.conf ] && msg "/etc/tor/torsocks.conf found on filesystem" || err "You need to create /etc/tor/torsocks.conf" 
				[ -f /usr/lib/systemd/system/tor.service ] && msg "/usr/lib/systemd/system/tor.service found on filesystem" || err "You need to create /usr/lib/systemd/system/tor.service"
}

set_iptables_rules()
{
				msg "Setting temporary iptables rules..."
				msg "Current iptables service saved --> /etc/iptables/iptables.rules.bak"
				mv /etc/iptables/iptables.rules /etc/iptables/iptables.rules.bak
				iptables -P INPUT DROP
				iptables -P OUTPUT DROP
				iptables -P FORWARD DROP
				iptables -A INPUT -i lo -j ACCEPT
				iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
				iptables-save > /etc/iptables/iptables.rules
				msg "Done"
}

tmp_kill_services()
{
				msg "Killing services..."
				systemctl stop netctl 2>/dev/null
				systemctl stop NetworkManager 2>/dev/null
				systemctl stop wicd 2>/dev/null
				killall tor 2>/dev/null
				systemctl stop systemd-hostnamectl 2>/dev/null
				systemctl stop systemd-networkd 2>/dev/null
				systemctl stop systemd-resolved 2>/dev/null
				systemctl stop iptables 2>/dev/null
				msg "Done"
}

tmp_start_services()
{
				msg "Starting services..."
				systemctl start netctl 2>/dev/null
				systemctl start NetworkManager 2>/dev/null
				systemctl start wicd 2>/dev/null
				systemctl start systemd-hostnamed 2>/dev/null
				systemctl start systemd-networkd 2>/dev/null
				systemctl start systemd-resolved 2>/dev/null
				systemctl start iptables 2>/dev/null
				systemctl start tor 2>/dev/null
				msg "Done"
}

change_stuff()
{
				echo $CURRENT_HOSTNAME > $CURRENT_HOSTNAME_FILE 
				info "Type new temporary hostname: "
				read NEW_TMP_HOSTNAME
				echo $NEW_TMP_HOSTNAME > /etc/hostname
				msg "Done"
				set_iptables_rules
}

restore_stuff()
{
				CURRENT_HOSTNAME_FILE_CAT=$(cat $CURRENT_HOSTNAME_FILE)
				msg "Restoring hostname..."
				echo $CURRENT_HOSTNAME_FILE_CAT > /etc/hostname
				msg "Done"
				msg "Restoring iptables state..."
				rm /etc/iptables/iptables.rules 2> /dev/null
				mv /etc/iptables/iptables.rules.bak /etc/iptables/iptables.rules 2>/dev/null
				msg "Done"
}

startmode()
{
				checks_before_start
				tmp_kill_services
				change_stuff
				tmp_start_services
}

stopmode()
{
				checks_before_start
				tmp_kill_services
				restore_stuff
				tmp_start_services
				killall tor
}

argparsing()
{
				if [ $# -eq 1 ];
				then
								[[ $1 == "start" ]] && startmode
								[[ $1 == "stop" ]] && stopmode
				else
								err "Usage: <$0> [start|stop]"
								exit 2
				fi
}

argparsing $@
