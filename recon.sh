
#Gather Initial Information:
# Update Log:
# 05-08-2017 - Disabled dirb causing hang.

clear
echo =====================
echo IP To Scan:
echo =====================
read ip
clear

echo ==========================
echo Do You Know The Hostname?
echo ==========================
read host
clear



# Run Nmap
nmap -sV -p- $ip -A -oN nmap_tmp


# Run Nikto and Dirb
if grep "http" nmap_tmp; then
	grep "/tcp" nmap_tmp | grep http | cut -d / -f1>>ports_tmp
	port=($(cat ports_tmp))
	for i in "${port[@]}"
	do
		nikto -h $ip:$i -o nikto -Format text
		dirb http://$ip:$i -r -o dirb_tmp
	done
else
	echo No HTTP found >>nikto
fi
clear



# Check for SMB
if grep "smb" nmap_tmp; then
	nmap -p 139,445 --script=/usr/share/nmap/scripts/smb-enum-shares.nse $ip -oN shares_tmp
else
	echo No shares found!
fi
clear


# Check for OS
if grep "linux" nmap_tmp; then
	os=Linux
else
	os=Windows
fi
clear


# Check For Host Name
grep "computer name" nmap_tmp | cut -d " " -f 7 >>host_tmp
host=($(cat host_tmp))



# Build Report For Zim

echo Building Report . . . . . 
sleep 5

echo ========================>report.txt
echo Money>>report.txt
echo ========================>>report.txt
echo Hostname: $host >>report.txt
echo OS: $os>>report.txt
echo Proof.txt: >>report.txt
echo >>report.txt
echo >>report.txt

echo ========================>>report.txt
echo Recreation Steps>>report.txt
echo ========================>>report.txt
echo >>report.txt
echo >>report.txt

echo ========================>>report.txt
echo Noteables>>report.txt
echo ========================>>report.txt
echo >>report.txt
echo >>report.txt

echo ========================>>report.txt
echo Pass Dump>>report.txt
echo ========================>>report.txt
echo >>report.txt
echo >>report.txt


echo ========================>>report.txt
echo Running Services>>report.txt
echo ========================>>report.txt
grep "/tcp" nmap_tmp | grep -vE closed | awk '{print $1,$2, $4, $5, $6, $7, $8, $9}'>>report.txt
echo >>report.txt
echo >>report.txt



echo ========================>>report.txt
echo Nmap Results>>report.txt
echo ========================>>report.txt
cat nmap_tmp >>report.txt
echo >>report.txt
echo >>report.txt




echo ========================>>report.txt
echo Nikto>>report.txt
echo ========================>>report.txt
cat nikto >>report.txt
echo >>report.txt
echo >>report.txt
echo >>report.txt


echo ========================>>report.txt
echo Dirb>>report.txt
echo ========================>>report.txt
cat dirb_tmp >>report.txt
echo >>report.txt
echo >>report.txt
echo >>report.txt


echo ========================>>report.txt
echo SMB Shares>>report.txt
echo ========================>>report.txt
cat shares_tmp>>report.txt
echo >>report.txt
echo >>report.txt
echo >>report.txt



echo ========================>>report.txt
echo IP Configuration>>report.txt
echo ========================>>report.txt
echo >>report.txt
echo >>report.txt


echo ========================>>report.txt
echo Searchsploit>>report.txt
echo ========================>>report.txt
echo Refine Searches For Searchsploit >sploit_tmp
grep "/tcp" nmap_tmp | grep -vE closed | awk '{print "searchsploit -t " $4, $5, $6}'>>sploit_tmp
gedit sploit_tmp
cat sploit_tmp>>report.txt
echo >>report.txt
echo >>report.txt



# Make Searchsploit Script
mv sploit_tmp searchsploit.sh
chmod +x searchsploit.sh


# Clean Up Temp Files Needed For Reporting
rm *_tmp
rm nikto
rm nmap

clear
# Open Report
echo Opening Report. . . . .
sleep 10
firefox report.txt
clear
echo Complete. 
