#!/bin/bash

if [ "$EUID" -ne 0 ] # checks if USER is ROOT
  then echo -e "Please run updater as root"
  exit
fi

echo -e "Press 1 to upgrade MyNode.\nPress 0 to exit."
read decision

if [ $decision == 1 ]; then

	if [ -d mynode ]; then
		echo -e "Old mynode upgrade directory found.\nDeleting ...\n"
		rm -r mynode
	fi
	
	echo -e "Cloning github files."
	git clone https://github.com/mynodebtc/mynode.git --branch latest_release > /dev/null 2>&1
	
	cd mynode
	
	echo -e "Building files"
	make rootfs > /dev/null 2>&1
	
	echo -e "Starting file server"
	make start_file_server > /dev/null 2>&1
	
	echo -e "Upgrading mynode"
	sudo mynode-local-upgrade 127.0.0.1
fi
echo -e "Exiting..."