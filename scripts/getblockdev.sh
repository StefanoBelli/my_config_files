#!/bin/sh

LEN_ARG="$#"
BLOCK_DEV=""
BLOCK_DEV_SYS_DIR="/sys/block"
DIALOG_PATH="/usr/bin/dialog"
DIALOG_TITLE="BlockDeviceInfo"
DIALOG_MSG="Device: "
DIALOG_SIZE="10 35"
BLKNAME=""
READONLY=""
REMOVABLE=""
SUBPART=""

get()
{
				cd $BLOCK_DEV_SYS_DIR
				if [ -d $BLKNAME ];
				then
				        if [ $(cat $BLOCK_DEV_SYS_DIR/$BLKNAME/ro) -eq 0 ];
								then
									READONLY="no"
								else
									READONLY="yes"
								fi

								if [ $(cat $BLOCK_DEV_SYS_DIR/$BLKNAME/removable) -eq 0 ];
								then
								  REMOVABLE="no"
								else
									REMOVABLE="yes"
								fi

								if find $BLOCK_DEV_SYS_DIR/$BLKNAME -name $BLKNAME >>/dev/null;
								then
								  SUBPART="yes"
								else
									SUBPART="no"
								fi

								DIALOG_MSG="
Device: $BLOCK_DEV ; $BLKNAME
Size: $(cat $BLOCK_DEV_SYS_DIR/$BLKNAME/size) Bytes
Read-only: $READONLY
Removable: $REMOVABLE
Sub-partitions: $SUBPART
"
								$DIALOG_PATH --title $DIALOG_TITLE --msgbox "$DIALOG_MSG" $DIALOG_SIZE
				else
								DIALOG_MSG="The device $BLKNAME does not exist!"
								DIALOG_SIZE="7 25"
								$DIALOG_PATH --title $DIALOG_TITLE --msgbox "$DIALOG_MSG" $DIALOG_SIZE
								exit 3
				fi
}

if [ -f $DIALOG_PATH ];
then
				echo ""
else
				printf "\033[31m*\033[0m Dialog is not installed!\n"
				exit 1
fi

if [ $LEN_ARG -eq 1 ];
then
				BLOCK_DEV="$1"
				BLKNAME=$(echo $BLOCK_DEV 2>/dev/null | sed "s:/dev/::")
				DIALOG_TITLE="BlockDevice:$BLOCK_DEV"
				DIALOG_MSG="Device: $BLOCK_DEV"
				get
				cd
else
				printf "\033[31m*\033[0mUsage: <$0> [/dev/xxx]\n"
				exit 2
fi
