#!/bin/bash

# This script pings a list of servers and reports their status.

SERVER_LIST='/vagrant/servers' # Change SERVER_LIST to suit your own. In here i am using vagrant.

if [[ ! -e "${SERVER_LIST}" ]] # If SERVER_LIST does not exist or cannot be opened show an error message. 
then
	echo "Cannot open ${SERVER_LIST}" >&2
	exit 1 
fi

for SERVER in $(cat ${SERVER_LIST})
do
	echo "Pinging ${SERVER}"
	ping -c 1 ${SERVER} &> /dev/null
	if [[ "${?}" -ne 0 ]]
	then
		echo "${SERVER} cannot be pinged. Server may be down."
	else
		echo "${SERVER} up."
	fi
done
