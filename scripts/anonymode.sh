#!/bin/sh

TOR_CONFIG="/etc/tor/torrc"
TORSOCKS_CONFIG="/etc/tor/torsocks.conf"
TOR_SYSTEMD_SERVICE="/usr/lib/systemd/system/tor.service"
TOR="/usr/bin/tor "
TORIFY="/usr/bin/torify "
TORSOCKS="/usr/bin/torsocks "
IPTABLES_IP4="/usr/bin/iptables "
SYSTEMCTL_START="/usr/bin/systemctl start "
SYSTEMCTL_STOP="/usr/bin/systemctl stop "
IFCONFIG="/usr/bin/ifconfig "
MACCHANGER="/usr/bin/macchanger "
IPTABLES_RULES_OLD="/etc/iptables/iptables.rules"
IPTABLES_RULES_NEW="/etc/iptables/iptables.rules.bak.anonymode"
IPTABLES_RULES_TEMPORARY="/etc/iptables/iptables.rules"
HOSTNAME_BAK="/etc/hostname.bak.anonymode"
HOSTNAME_NEW="/etc/hostname"
SET_IPTABLES_OLDRULES=1
SERVICES="systemd-hostnamed.service systemd-networkd.service NetworkManager.service wicd.service netctl.service iptables.service tor.service" #start,stop
#AVOID_SERVICES="NetworkManager.service wicd.service"
NETWORK_SERVICE="NetworkManager"

msg()
{
				printf "\033[32m*\033[0m $@ \n"
}

err()
{
				printf "\033[31m*\033[0m $@ \n"
}

info()
{
				printf "\033[34m*\033[0m $@ \n"
}

check_user()
{
				if [ $(id -u) -eq 0 ];
				then
								msg "root : Allowed"
				else
								err "$USER (with UID: $(id -u) ) : Not ALlowed"
								err "Aborting..."
								exit 1
				fi
}

check_all()
{
				check_user
				[[ -f $TOR_CONFIG ]] && msg "Tor config file detected" || \
								err "Tor config file not detected" \
								exit 2
				[[ -f $TORSOCKS_CONFIG ]] && msg "Torsocks config file detected" || \
								err "Torsocks config file not detected" \
								exit 2
				[[ -f $TOR_SYSTEMD_SERVICE ]] && msg "Tor systemd service file detected" || \
								err "Tor's systemd service not detected" \
								exit 2
				[[ -f $IPTABLES_RULES_OLD ]] && msg "Iptables (IPv4) rules detected" || \
								err "Iptables rules not detected" \
								err "But we can set temporary rules" \
								SET_IPTABLES_OLDRULES=0

				if which macchanger >>/dev/null; then msg "Macchanger detected" 
				else 
								err "Macchanger not detected..."
								exit 3
				fi
				
				if which tor >>/dev/null; then msg "Tor detected"
				else
								err "Tor not detected..."
								exit 3
				fi

				if which torify >>/dev/null; then msg "Torify detected"
				else
								err "Torify not detected..."
								exit 3
				fi

				if which torsocks >>/dev/null; then msg "Torsocks detected"
				else
								err "Torsocks not detected..."
								exit 3
				fi

				if which iptables >>/dev/null; then msg "Iptables detected"
				else
								err "Iptables not detected..."
								exit 3
				fi

				if which systemctl >>/dev/null; then msg "Systemctl detected"
				else
								err "Systemctl not detected..."
								exit 3
				fi

				if [[ -d /usr/lib/systemd ]] >>/dev/null; then msg "Systemd detected"
				else
								err "Systemd required but not detected, as this script is using systemd!"
								exit 3
				fi
}

create_file()
{
				if [[ -f /var/anonymode.pid ]];
				then
								err "Already running..."
								exit 6
				else
								touch /var/anonymode.pid
				fi
}

remove_file()
{
				if [[ -f /var/anonymode.pid ]];
				then
								rm /var/anonymode.pid 2>/dev/null
				else
								err "Not running..."
								err "Avoiding problems :) "
								exit 6
				fi
}

shutting_down_services()
{
				info "Shutting down services..."
				for i in $SERVICES; 
				do
								info "Shutting down: $i"
								if [[ $i == "tor.service" ]];
								then
												continue
								fi
								$SYSTEMCTL_STOP $i 2>/dev/null
				done
				killall tor
}

starting_up_services()
{
				info "Starting up serices..."
				for i in $SERVICES;
				do
								info "Starting up: $i"
								$SYSTEMCTL_START $i 2>/dev/null
				done
}

set_iptables_temporary_rules()
{
				info "Setting iptables rules..."
				if [[ $SET_IPTABLES_OLDRULES == 1 ]];
				then
								info "Copying old rules for future restoring..."
								mv $IPTABLES_RULES_OLD $IPTABLES_RULES_NEW 2>/dev/null
								rm $IPTABLES_RULES_TEMPORARY 2>/dev/null
				else 
								msg "/etc/iptables/iptables.rules not found... Not fatal"
				fi

				[[ -f $IPTABLES_RULES_NEW ]] && echo "" || echo ""

				touch /etc/iptables/iptables.rules

				iptables -P INPUT DROP
				iptables -P FORWARD DROP
				iptables -A INPUT -i lo -j ACCEPT
				iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
				
				info "Saving configuration..."
				iptables-save > /etc/iptables/iptables.rules
}

restore_iptables_rules()
{
				info "Restoring iptables rules..."
				if [[ $SET_IPTABLES_OLDRULES == 1 ]];
				then
								info " Restoring..."
								cp $IPTABLES_RULES_NEW /etc/iptables/iptables.rules
				else
								err " No restore required" 
				fi
}

set_temporary_hostname()
{
				info "Setting new hostname"
				cp $HOSTNAME_NEW $HOSTNAME_BAK
				echo -n "Hostname: "
				read HOSTNAME
				touch $HOSTNAME_NEW
				echo $HOSTNAME > $HOSTNAME_NEW
}

restore_hostname()
{
				info "Restoring hostname"
				mv $HOSTNAME_BAK $HOSTNAME_NEW
}

change_macaddr()
{
				info "Changing MAC Address..."
				ifconfig $1 down
				macchanger -r $1
}

restore_macaddr()
{
				info "Restoring MAC Address..."
				ifconfig $1 down
				macchanger -p $1
}

restart_netctl_profile()
{
				$SYSTEMCTL_STOP wicd
				$SYSTEMCTL_STOP NetworkManager
				info "Restoring netctl..."
				netctl start wlp7s0-XSt3pNetW
				netctl stop wlp7s0-XSt3pNetW
				netctl start wlp7s0-XSt3pNetW
}

restart_wicd_profile()
{
				$SYSTEMCTL_STOP NetworkManager
				$SYSTEMCTL_STOP netctl
				info "Restoring wicd..."
				$SYSTEMCTL_START wicd
}

restart_nm_profile()
{
				$SYSTEMCTL_STOP wicd
				$SYSTEMCTL_STOP netctl
				info "Restoring NetworkManager..."
				$SYSTEMCTL_START NetworkManager
				$SYSTEMCTL_RESTART NetworkManager
}

start_anonymode()
{
				info "Starting anonymode: $(date '+%y/%m/%d %H:%M') "
				check_all
				create_file
				shutting_down_services
				set_iptables_temporary_rules 
				set_temporary_hostname
				if [[ $2 == "spoofing" ]];
				then
								change_macaddr $1
				else
								echo ""
				fi
				starting_up_services
				check_network_service
				msg "Done"
}

check_network_service()
{
				if [[ $NETWORK_SERVICE == "wicd" ]];then restart_wicd_profile
				elif [[ $NETWORK_SERVICE == "NetworkManager" ]];then restart_nm_profile
				elif [[ $NETWORK_SERVICE == "netctl" ]];then restart_netctl_profile
				fi
}

stop_anonymode()
{
				info "Stopping anonymode: $(date '+%y/%m/%d %H:%M') "
				check_all
				remove_file
				shutting_down_services
				restore_iptables_rules
				restore_hostname
				restore_macaddr $1
				starting_up_services
				info "Killing tor..."
				killall tor
				check_network_service
				msg "Done"
}

argument_parser()
{
				if [[ $# < 3 ]] || [[ $# == 3 ]];
				then
								if [[ $1 == "start" ]];then 
												[[ $3 == "macspoof" ]] && \
																start_anonymode $2 "spoofing" || \
																start_anonymode $2

								elif [[ $1 == "stop" ]]; then stop_anonymode $2
								else 
												info "Usage: <$0> [start|stop] {INTERFACE}"
												exit 5
								fi
				else
								info "Usage: <$0> [start|stop] {INTERFACE}"
								exit 5
				fi
}

argument_parser $@
