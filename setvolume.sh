#!/bin/sh
vol_entry=$1

amixer set 'Master' ${vol_entry} >>/dev/null 2>/dev/null

