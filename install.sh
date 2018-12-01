#!/bin/bash
#
#
# GitHub:   https://github.com/masitings/Lemposite
# Author:   Thamaraiselvam
# URL:      https://rafi-halilintar.me
#
export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
clear
printf "
#######################################################################
#                          LEMPOSITE WEBSERBER                        #
#        Custom installation script https://rafi-halilintar.me        #
#       Aplikasi ini hanya berlaku untuk Linux (Debian & Ubuntu)      #
#######################################################################
"
dbrootpwd=`< /dev/urandom tr -dc A-Za-z0-9 | head -c8`
# Melakukan validasi apakah root atau bukan yang login dan akan mengeksekusi script ini.
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: Maaf, script ini hanya bisa dijalankan oleh super user (root)${CEND}"; exit 1; }

lemposite_dir=$(dirname "`readlink -f $0`")
pushd ${lemposite_dir} > /dev/null
. ./include/check_dir.sh


printf "
Aplikasi yang akan di install : 
    [*] Nginx Web Server
    [*] MariaDB
    [*] PHP 7.2
"

read -e -p "Apakah anda ingin tetap melanjutkannya ? [y/n]: " installasi

if [[ ! ${installasi} =~ ^[y,n]$ ]]; then
    echo "${CWARNING}Error! masukan hanya 'y' atau 'n'${CEND}"
fi

case "${installasi}" in
    y )
    . include/nginx.sh
    Install_Nginx 2>&1 | tee -a ${oneinstack_dir}/install.log
        ;;
esac