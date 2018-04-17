#!/bin/bash

## Global var
sysType="Ubuntu"
installCmd="apt"
app="git vim sdcv autojump"

## Functions
function SystemType(){
    Distributor=`lsb_release -i | awk -F: '{print $2}'`
    RedHat=`echo ${Distributor} | grep -i "RedHat"`
    CentOS=`echo ${Distributor} | grep -i "CentOS"`
    Fedora=`echo ${Distributor} | grep -i "Fedora"`

    RedHat=$((RedHat+CentOS+Fedora))

    if [ ${RedHat} -ne 0 ];then
	echo "RedHat"
    else
	echo "Ubuntu"
    fi
}

sysType=`SystemType`
echo -e "\033[32mCurrent System Type \033[00m<\033[31m${sysType}\033[00m>"
if [ ${sysType} == "Ubuntu" ]; then
    installCmd="apt"
else
    installCmd="yum"
fi



## Install softwares
sudo ${installCmd} install ${app} -y

## Enviroment config
mv .vim ~
cat ./mybashrc.cfg >> ~/.bashrc
sudo mkdir -p /usr/share/stardict/dic
sudo tar jxvf stardict.tar.bz2 -C /usr/share/stardict/dic

