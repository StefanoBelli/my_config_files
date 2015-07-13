#! /bin/bash
update-linux(){
		  CONF_FILE=".config"
		  cd /home/stefanozzz123/kernels/git/linux
		  printf "\033[32m*\033[0m Checking for .config file....\n"
		  [[ -f $CONF_FILE ]] && 
		  printf "\033[32m*\033[0m $CONF_FILE exists... \n"  
		  sleep 1 || make menuconfig

		  printf "\033[33m*\033[0m Fetching latest commits from remote repository (origin)...\n"
		  git pull
		  echo -n "? Would you like to continue[y/n]?-> "; read CHOICE

		  case $CHOICE in
					 ("y")
								printf "\033[32m*\033[0m Compiling source...\n"
								make -j3
								echo -n "Press any key to install modules, headers and update GRUB..."
								read
								echo "Don't leave... It will take a while..."
								sudo make modules_install; sudo make headers_install
								printf "\033[32m*\033[0m Copying kernel...\n"
								sudo cp arch/x86/boot/bzImage /boot/vmlinuz-linux_git_build
								printf "\033[32m*\033[0m Updating GRUB...\n"
								sudo grub-mkconfig -o /boot/grub/grub.cfg
								exit 0
								break;;
					 ("n")
								printf "\033[31m*\033[0m Bye. "
								break;;
			esac
		  exit 0
 }
update-linux
