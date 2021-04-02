#!/bin/bash

# Enforce Script to be executed with superroot privileges. If not it will not attempt to create user and return exist status of 1.
# Provide usage statment like you would find in a man page if user doesn't supply an account name on cmd line and return exit status of 1.
# Use first argument provided on cmd line as username for account. Any remaining arguments on cmd line will be treated as comment for account.
# Auto gen pass for new account.
# Inform user if account was not able to be created for some reason. If account is not created, script returns exit status of 1.
# Display username, password, and host where account was created.

# Script creates new user on local system
# Supply a username as an argument to the script.
# Optionally, provide a comment for the account as an argument.
# A password will be auto generated for account.
# Username, Password and host for account will be displayed.

# Make sure script is executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
	echo "You are not root. This script must be executed with root/superuser priviledges. Please run in sudo or root and try again."
	exit 1
fi
# If user doesn't supply at least 1 argument, give them help.
if [[ "${#}" -lt 1 ]]
then
	echo "Usage: ${0} USER_NAME [COMMENT]..."
	echo 'Create account on local system with name of USER_NAME and comment field of COMMENT.'
	exit 1
fi
# First parameter is username
USER_NAME="${1}"
# Rest of parameters are for account comments.
shift
COMMENT="${@}"
# Generate a passsword
PASSWORD=$(date +%s%N${RANDOM} | sha256sum | head -c48)
# Create user with password
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check to see if useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo 'User account could not be created.'
	exit 1
fi
# Set the password
echo ${PASSWORD} | passwd --stdin ${USER_NAME} 
# Check to see if passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo 'Password for account could not be set.'
	exit 1
fi
# Force password change on first login.
passwd -e ${USER_NAME}
# Display username, pass and host where user was created.
echo
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
exit 0
