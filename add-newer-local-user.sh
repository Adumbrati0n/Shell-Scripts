#!/bin/bash

# Use first argument provided on cmd line as username for account. Any remaining arguments on cmd line will be treated as comment for account.

# Inform user if account was not able to be created for some reason. If not able to be created, return exist status of 1 for script. All messages associated with this event will display standard error.

# Supress output from all other commands

# This script creates a new user on the local system.
# You must supply a username as an argument to the script.
# Optionally, you can also provide a comment for the account as an argument
# A password will be auto generated for this account.
# Username, password, and host for account will be displayed.

# Ensure script is being executed with root/ superuser privileges
if [[ "${UID}" -ne 0 ]]
then
	echo 'You are not root. You must run with root/ superuser privileges. Please run with sudo and try again.' >&2 
	exit 1
fi
# If user does not supply at least 1 argument, then give help.
if [[ "${#}" -lt 1 ]]
then
	echo "USAGE: ${0} USER_NAME [COMMENT] ..." >&2
	echo 'Create an account on the local system with the name of USER_NAME and a comments field of comment.' >&2
	exit 1
fi
# First parameter is username.
USER_NAME="${1}"
# Rest of the parameters are for the account comments.
shift
COMMENT="${@}"
# Generate a password.
PASSWORD=$(date +%s%N${RANDOM} | sha256sum | head -c48)
# Create user with password.
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null 
# Check to see if passswd command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo 'The account could not be created.' >&2
	exit 1
fi
# Set the password.
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null
# Check to see if passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo 'The password for the account could not be set.' >&2
	exit 1
fi
# Force password change on first login.
passwd -e ${USER_NAME} &> /dev/null
# Display username, password and host where user was created.
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
exit 0
