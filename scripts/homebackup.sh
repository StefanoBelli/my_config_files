#! /bin/bash

OUT_FILE_COMP_DIR="/home/$USER/backup"
WHAT_TO_COMPRESS="/home/$USER"

printf "\033[32m * \033[0m Using tar compression method...\n"
if [[ -d $OUT_FILE_COMP_DIR ]]; 
then
       cd $OUT_FILE_COMP_DIR
       printf "\033[32m * \033[0m Compressing in 4 seconds...Press CTRL+C to exit before backup starts.\n "
       sleep 1
       echo -ne "[==============>                                                 ]15%\r"
       sleep 1
       echo -ne "[======================================>                         ]65%\r"
       sleep 1
       echo -ne "[===============================================================>]100%\r"
       echo "Starting compression..."
       sleep 1
       tar -zcvf backup.tar.gz $WHAT_TO_COMPRESS
       exit 0
else
       printf "\033[31m  * \033[0m Backup directory does not exists!!\nI will make it..."
       mkdir $OUT_FILE_COMP_DIR
       exit 1
fi
exit 0
