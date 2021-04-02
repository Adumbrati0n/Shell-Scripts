#!/bin/bash 

# Simple ping sweep of network for active IP addresses/ devices. To find your ip use ifconfig. Substitute X.X.X.$ip for your ip address range.

# Network IP addresses go from 1 - 254. Loop this sequence!
for ip in {1..254}
do
	ping -c 1 10.0.2.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" & #& just makes process faster/do them all at same time
done 
 
