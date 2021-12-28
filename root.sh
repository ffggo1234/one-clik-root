#!/bin/bash

green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}

lsattr /etc/passwd /etc/shadow >/dev/null 2>&1
chattr -i /etc/passwd /etc/shadow >/dev/null 2>&1
chattr -a /etc/passwd /etc/shadow >/dev/null 2>&1
lsattr /etc/passwd /etc/shadow >/dev/null 2>&1
prl=`grep PermitRootLogin /etc/ssh/sshd_config`
pa=`grep PasswordAuthentication /etc/ssh/sshd_config`
if [[ -n $prl && -n $pa ]]; then
read -p "自定义root密码:" mima
echo root:$mima | chpasswd root
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
service sshd restart
green "VPS当前用户名：root"
green "vps当前root密码：$mima"
else
red "当前vps不支持root账户或无法自定义root密码" && exit 1
fi
