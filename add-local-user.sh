#!/bin/bash

# Enforce script to be used with root priviledges, if not executed with superuser priviledges stop attempt to create user and return exist status of 1
# Prompt person who executes script to enter username, name and pass for account.
# Create new user on local system with input provided by user
# Inform user if account was not able to be created for some reason. If account is not created, script is to return and exit status of 1
# Display username, pass and host where account was created.


# This scipt creates a new user on local system.
# You will be prompted to enter username(login), name, and a password.
# Username, password and host for the account will be displayed.

#Make sure script is being executed with root priviledges
if [[ "${UID}" -ne 0 ]]
then
	echo "You are not root. This script must be executed with root/superuser priviledges. Please run in sudo or root and try again."
	exit 1
fi
# Ask for username to create
read -p 'Enter username you want to create: ' USER_NAME
#Ask for name of person/application using this account
read -p 'Enter name of person/application using this account: ' COMMENT
#Ask for password for the account
read -p 'Enter password to use for the account" ' PASSWORD
#Create User
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check to see if useradd command succeeded. If not, script is to return and exit status of 1 and inform user that account could not be created.
if [[ "${?}" -ne 0 ]]
then
	echo "Account could not be created"
	exit 1
fi
#Set password for user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

#Check to see if passwd command succeeeded
if [[ "${?}" -ne 0 ]]
then
	echo "The password for the account could not be created"
	exit 1
fi
#Force password change on first login
passwd -e ${USER_NAME}

# Display username, password and host where user was created
echo
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password"'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
exit 0
