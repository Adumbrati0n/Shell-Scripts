#!/bin/bash

# Get the first octets of network ip
ifconfig | grep "broadcast" | cut -d " " -f 10 | cut -d "." -f 1,2,3 | uniq > octets.txt

# Set variable to have the value of octets.txt
OCTETS=$(cat octets.txt)

# Create new .txt file
echo "" > $OCTETS.txt

# Loop. We wont use 255 as it is a broadcast address.
for ip in {1..254}
do
	ping -c 1 $OCTETS.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> $OCTETS.txt &
done

cat $OCTETS.txt | sort > sorted_$OCTETS.txt
	

