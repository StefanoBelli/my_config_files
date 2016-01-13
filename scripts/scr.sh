#!/bin/sh

OPT=$1
IF_SPLIT=$2
RDISPLAY=HDMI1
MAIN_DISPLAY=LVDS1
IF_ROTATE_DISPLAY=$2
IF_ROTATE_POS=$3

if which xrandr 2>/dev/null >>/dev/null;
then
				printf ""
else
				printf "* XRandr not found\n"
				exit 1
fi

if [ "$OPT" == "-s" ];
then
				xrandr --auto
				if [ "$IF_SPLIT" == "--split" ];
				then
								xrandr --output $RDISPLAY --right-of $MAIN_DISPLAY &
				fi
elif [ "$OPT" == "-t" ];
then
				xrandr --output $RDISPLAY --off
elif [ "$OPT" == "-r" ];
then
				eval "xrandr --output $IF_ROTATE_DISPLAY --rotate $IF_ROTATE_POS"
fi

				

