#!/bin/bash
###########
###
### add_mailuser.bash 
###
### Script adding a shell-less/disabled-login user on the system
### Use it to create mail adress, they will be on
### the following format : user@datapopcorn.com
###
### Author : Julien AVENET - julien@datapopcorn.com
### 
### Versionning
###	08/11/16 : Script creation 
###
### MIT Licence
###
##########

checkUserId=`id -u`
clear
if [ "$checkUserId" != "0" ]; then
	printf "You must run this program as root !\n"
	exit 1
else
	read -p "Name of the user : " username
	grep $username /etc/passwd 1>/dev/null
	checkUserExists=$?
	if [ "$checkUserExists" == "1" ]; then
		read -p "Password of the user : " -s password
		printf "\n"
		while true; do
			read -p "Are you sure to add the user $username to the system ? " yn
			case $yn in
				[Yy]* ) break;;
				[Nn]* ) exit;;
				* ) printf "\nPlease answer yes or no.\n";;
    			esac
		done
		adduser --home /home/$username --shell /sbin/nologin --gecos ABCDE --ingroup mail --disabled-login $username 
		echo "$username:$password" | chpasswd 

		grep $username /etc/passwd 1>/dev/null
		checkEtcPasswd=$?
			
		ls /home/$username 1>/dev/null
		checkUserHome=$?
		
		if [ "$checkEtcPasswd" == "0" ] && [ "$checkUserHome == "0" ]; then
			printf "\nEverything seems to be alright."
			exit 0
		else
			printf "\nSomething went wrong... Enjoy debugging."
			printf "\nEnd of /etc/passwd"
			tail -n 1 /etc/passwd
			exit 1
		fi
	else
		printf "\nUser already exists, exiting the program."
		exit 1
	fi
fi
