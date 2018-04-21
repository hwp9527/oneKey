#!/bin/bash

## Global var
sysType="Ubuntu"
installCmd="apt"
readonly app="git vim sdcv ctags autojump"

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

function IsCmdInstalled(){
    if [ $# -lt 1 ]; then
	echo "IsCmdInstalled: parameters -lt 1"
	exit 255
    fi  

    [[ $(which $1) ]] && echo "$1: installed" && return 0

    echo "$1: Not be installed"
    return 1
}

sysType=$(SystemType)
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

#Vim configuration
if [ `IsCmdInstalled vim` -eq 0 ];then
    vim -c PluginInstall
    vim -c GoInstallBinaries
else
    echo "VIM have not installed!!!"
fi

#Git configuration
if [ `IsCmdInstalled git` -eq 0 ];then
    git config --global push.default simples
    git config --global user.name "hwp9527"
    git config --global user.email hwp195@163.com
    git config --global core.editor vim
    git config --global diff.tool vimdiff
else
    echo "GIT have not installed!!!"
fi

#Go configuration
if [ `IsCmdInstalled go` -eq 0 ];then
    cd $GOPATH/src
    go get github.com/nsf/gocode
else
    echo "GO have not installed!!!"
fi

#Go doc std chinese version
git clone https://github.com/polaris1119/pkgdoc.git ~/pkgdoc
