#!/bin/bash
# Adds some test accounts for testing

# Run command in root
if [[ ${UID} -ne 0 ]] 
then
	echo 'You are not in root. Please run with sudo or root priviledges.' >&2
	exit 1
fi

for U in christianf louisec alicel raymondc kimif pattyd
do
	useradd ${U}
	echo 'password' | passwd --stdin ${U}
done
