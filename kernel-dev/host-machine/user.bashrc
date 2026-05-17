#!/bin/bash

REAL_PS1=$PS1

SSH_PROJ_NAME="sci-detect"

SSH_USER="ste"
SSH_HOST="192.168.122.65"
SSH_PORT="22"

SSH_KEY="$HOME/.ssh/vmssh"

export SSH_MNTP="$HOME/mnt"
export SSH_USERHOME="$SSH_MNTP/home/ste"
export SSH_CWD="$SSH_USERHOME/$SSH_PROJ_NAME"

SSHFS_DIR="/"

_ssh_banner() {
	echo " --- Connecting to $SSH_HOST as user $SSH_USER, port $SSH_PORT"
	echo " --- using key located at $SSH_KEY"
}

sshshell() {
	_ssh_banner
	ssh -i $SSH_KEY $SSH_USER@$SSH_HOST -p $SSH_PORT
}

sshmount() {
	_ssh_banner
	sshfs $SSH_USER@$SSH_HOST:$SSHFS_DIR $SSH_MNTP -o IdentityFile=$SSH_KEY
	echo " --- Remote fs root: $SSHFS_DIR"
	echo " --- Mountpoint: $SSH_MNTP"
	echo " --- Change directory to $SSH_CWD"
	cd $SSH_CWD

	_hook_after_sshmount_and_cwd
}

_hook_after_sshmount_and_cwd() {
	_kernsrcpath=$(readlink $SSH_MNTP/kernsrcpath)
	if [ -d $SSH_USERHOME/kernsrcpath ]; then
		rm $SSH_USERHOME/kernsrcpath
	fi

	ln -sv $SSH_MNTP/$_kernsrcpath $SSH_USERHOME/kernsrcpath
}

_is_sshfs_mounted() {
	MNTDPATH=$(mount | grep $SSH_MNTP | awk '{ print $3 }')
	[[ $MNTDPATH != "" && $PWD == "$MNTDPATH"* ]] && return 1 || return 0
}

_ssh_pwd_ps1() {
	res=$(echo ${PWD#$SSH_MNTP})
	if [[ $res == "" || $res == "/" ]]; then
		echo "-mntroot-"
	else
		echo $res
	fi
}

cd() {
	builtin cd "$@" || return
	if [[ $OLDPWD == $PWD ]]; then
		return
	fi

	_is_sshfs_mounted
	if [ $? -eq 1 ]; then
		PS1='\[\033[31m\](sshmounted) \u:$(_ssh_pwd_ps1)\[\033[0m\]:\[\033[31m\]\$\[\033[0m\] '
	else
		PS1=$REAL_PS1
	fi
}

