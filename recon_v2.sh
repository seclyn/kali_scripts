#!/bin/bash

###################################################
#              Recon Script
#
# Version: v2_08102016
# Created By: Seclyn
# Description: For initial recon of network/hosts.
#
###################################################
#             Set Variables
         workdir=~/challenge_vms
#
###################################################
clear


# Set Directory
echo ---------------------------------------------
tput setaf 6; echo Set Folder Name:
echo example: mrrobot will create $workdir/mrrobot
echo ---------------------------------------------
tput setaf 7;
echo
read work
echo Making directory $workdir/$work
mkdir $workdir/$work
cd $workdir/$work
echo
echo
echo --------------------------------------------
clear


# Get Current IP
echo --------------------------------------------
tput setaf 3; echo Your Host IP Is:
tput setaf 7;
echo --------------------------------------------
host=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
echo $host
echo
echo
echo --------------------------------------------



# Arp Scan
tput setaf 2; echo Current Hosts On The Network:
tput setaf 7;
echo --------------------------------------------
arp-scan -l | grep '192.168.85' | cut -d: -f1 | awk '{ print $1}' >> host_on_network
cat host_on_network
echo
echo
echo --------------------------------------------




# Select IP to Target
tput setaf 4; echo Enter The IP Of The Target:
tput setaf 7;
echo --------------------------------------------
read ip
echo
echo
echo


# Quick Nmap Scan To Get You Started
tput setaf 5;
echo --------------------------------------------
echo         Nmap Quick Scan  - Host $ip
echo --------------------------------------------
tput setaf 7;
echo
nmap $ip -T5 -oN quickmap_$ip
echo
echo



# Nikto
tput setaf 2;
echo ---------------------------------------------------------
echo Running Nikto scan. Output to nikto_$ip.txt
echo ---------------------------------------------------------
tput setaf 7;
sleep 15
echo Checking For HTTP Services . . . .
if grep "http" quickmap_$ip; then
	nikto -h $ip -o nikto_$ip.txt -ask no
else
	echo No HTTP Services Found On $ip
	echo No HTTP Services Found on $ip > nikto_NO_HTTP_$ip
fi
echo
echo



tput setaf 4;
echo
echo --------------------------------------------
echo         Nmap Long Scan  - Host $ip
echo --------------------------------------------
tput setaf 7;
echo Scan will take some time. Output to nmap_$ip
echo
nmap -sV $ip -p- -A -T5 -oN nmap_$ip --stats-every 10s
echo
echo
echo --------------------------------------------




echo Scan completed for $ip
echo Happy Hunting!
echo --------------------------------------------
echo
echo
echo
ls -l $workdir/$work


#end




