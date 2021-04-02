#!/bin/bash

# Count no. of failed logins by IP address. If any IP addresses have 10+ failed login attempts: no. of attempts, IP address and location of IP will be displayed. (geoiplookup to find IP that is sus)
# If there are any IPs with over LIMIT failures, display the count, IP, and location.
# Produce output in CSV (comma-separated values) format with a header of 'Count, IP, Location'.
# File needs to be provided as an argument. If file is not provided/ not to be able to be read, display error message and exit with status of 1.

LIMIT='10'
LOG_FILE="${1}"
# Make sure a file was supplied as an argument
if [[ ! -e "${LOG_FILE}" ]] # If file doesn't exist/can't open show error message.
then
	echo "Cannot open log file: ${LOG_FILE}" >&2
	exit 1
fi
# Display CSV header.
echo 'Count, IP, Location'
# Loop through the list of failed attempts and coreesponding IP addresses.
grep Failed ${LOG_FILE} | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do           				# Go through log file with pattern of 'Failed', print the IP field (NF-3), uniquely sort the results etc.
# If the number of failed attempts is greater than the limit, display count, IP, and location.
	if [[ "${COUNT}" -gt "${LIMIT}" ]]
	then
	LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
	echo "${COUNT},${IP},${LOCATION}"
	fi
done
exit 0


