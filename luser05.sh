#!/bin/bash

# This script generates a list of random passwords

# A random no. as a password
PASSWORD="${RANDOM}"
echo "$PASSWORD"

# Three random numbers together
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "$PASSWORD"

# Use current date/time as basis for password.
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# Use nanoseconds to act as random pass
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# A better pass. Turn current date and time into SHA256 by piping output of date command.
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}"
# An even better pass
PASSWORD=$(date +%S%n${RANDOM}${RANDOM} | sha256sum | head -c48)
echo "${PASSWORD}"
# Append a special char to password. Shuf to randomize lines, fold for specific width, head for 1st char
SPECIAL_CHARACTER=$(echo '!@#%$^&*()_-+=' | fold -w1 | shuf | head -c1)
echo "${PASSWORD}${SPECIAL_CHARACTER}"

