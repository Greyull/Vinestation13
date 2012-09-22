#!/bin/bash
if [ -z $1 ]
then
	echo "Please use ./vineserver.sh run|stop|update"
else
	if [ $1 = "run" ]
	then
		if [ -f ".vinelock" ]
		then
			echo "Server is already running! Try screen -x vineserver"
		else
			echo "run" >> .vinelock
			/usr/bin/screen -dmS vineserver DreamDaemon /home/vineserver/vinestation/vinestation.dmb 5643
		fi
	elif [ $1 = "stop" ]
	then
		rm .vinelock
		screen -S vineserver -X quit
	elif [ $1 = "update" ]
	then
		if [ -f ".vinelock" ]
		then
			echo "Server is running! Please use ./vineserver.sh stop"
		else
			svn update
		fi
	fi
fi
