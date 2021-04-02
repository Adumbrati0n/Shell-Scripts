#!/bin/bash

# This script shows open network ports on a system.
# Use -4 as an argument to limit to tcpv4 ports. E.G: ./luser13.sh -4

netstat -nutl ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'
