#! /bin/sh

# 127.0.0.1 localhost
# ::1       localhost

TO=$1
FROM=$2

checkUser(){
	if [[ $USER == "root" ]];
	then
		echo ""
	else
		printf "\033[31m * \033[0m Sorry, ${USER}, but you need to be root to edit hosts!\n"
		exit 1
	fi	
}

main(){
	checkUser 
	echo "$TO       $FROM" >> /etc/hosts && 
		printf "\033[32m * \033[0m Hosts file was edited\n\033[32m * \033[0m '$FROM' -> '$TO'\n "
		exit 0 || 
		print "\033[31m * \033[0m There was a problem!\n"
		exit 2
}

main
