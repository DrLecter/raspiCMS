#!/bin/bash
. /usr/local/etc/cam.conf
. $regfile
runs=$(ps axu|grep omxplayer.bin|grep -v grep|wc -l)
if [ $current_mode = "single" ];then
    current_channels=1
fi
if [ $runs -lt $current_channels ];then
    /usr/local/bin/cam.sh restart
fi