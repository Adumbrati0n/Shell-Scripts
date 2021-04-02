#!/bin/bash

# This script deletes a user

# Run as root.
if [[ "${UID}" -ne 0 ]]
then
	echo 'You are not root. Please run with sudo or root privileges.' >&2
	exit 1
fi 

# Assume first arugment is the user to delete.
USER="${1}"

# Delete the user
userdel ${USER}

# Make sure user got deleted

if [[ "${?}" -ne 0 ]]
then
	echo "The account ${USER} was NOT deleted." >&2
	exit 1
fi

# Tell user the account was deleted.
echo "The account ${USER} was deleted."

exit 0

	
