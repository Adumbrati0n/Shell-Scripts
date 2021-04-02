#!/bin/bash

# Display the UID and username of the user executing this script.
# Display if user is root user or not.

# Display UID
echo "Your UID is ${UID}"

# Display username
# USER_NAME=$(id -un)
USER_NAME=`id -un`
echo "Your username is ${USER_NAME}"

# Display if user is root user or not.
if [[ "${UID}" -eq 0 ]]
then
	echo 'You are root.'
else
	echo 'You are not root.'
fi

