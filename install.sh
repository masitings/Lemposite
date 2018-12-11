#!/bin/bash
#
#
# GitHub:   https://github.com/masitings/Lemposite
# Author:   Rafi Bagaskara Halilintar
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
. ./versions.txt
. ./options.conf
. ./include/color.sh
. ./include/check_os.sh
. ./include/check_dir.sh
. ./include/download.sh
. ./include/get_char.sh

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

	IPADDR=$(./include/get_ipaddr.py)
	PUBLIC_IPADDR=$(./include/get_public_ipaddr.py)
	IPADDR_COUNTRY=$(./include/get_ipaddr_state.py $PUBLIC_IPADDR)
	
	. ./include/check_download.sh
	downloadDepsSrc=1
	checkDownload 2>&1 | tee -a ${lemposite_dir}/install.log

	[ -e "/usr/local/bin/openssl" ] && rm -rf /usr/local/bin/openssl
	[ -e "/usr/local/include/openssl" ] && rm -rf /usr/local/include/openssl
	
	. ./include/memory.sh

    if [ ! -e ~/.lemposite ]; then
	  # Check binary dependencies packages
	  . ./include/check_sw.sh
	  case "${OS}" in
	    "CentOS")
	      installDepsCentOS 2>&1 | tee ${lemposite_dir}/install.log
	      . include/init_CentOS.sh 2>&1 | tee -a ${lemposite_dir}/install.log
	      [ -n "$(gcc --version | head -n1 | grep '4\.1\.')" ] && export CC="gcc44" CXX="g++44"
	      ;;
	    "Debian")
	      installDepsDebian 2>&1 | tee ${lemposite_dir}/install.log
	      . include/init_Debian.sh 2>&1 | tee -a ${lemposite_dir}/install.log
	      ;;
	    "Ubuntu")
	      installDepsUbuntu 2>&1 | tee ${lemposite_dir}/install.log
	      . include/init_Ubuntu.sh 2>&1 | tee -a ${lemposite_dir}/install.log
	      ;;
	  esac
	  # Install dependencies from source package
	  installDepsBySrc 2>&1 | tee -a ${lemposite_dir}/install.log
	fi

	startTime=`date +%s`
	# Install Jemalloc
	. include/jemalloc.sh
	Install_Jemalloc | tee -a ${lemposite_dir}/install.log
	# Install OpenSSL
	. ./include/openssl.sh
	Install_openSSL | tee -a ${lemposite_dir}/install.log
	# Install MariaDB
	. include/mariadb-10.3.sh
	Install_MariaDB103 2>&1 | tee -a ${lemposite_dir}/install.log
	# Install Nginx
    . include/nginx.sh
    Install_Nginx 2>&1 | tee -a ${lemposite_dir}/install.log
    # Install PHP72
    . include/php-7.2.sh
    Install_PHP72 2>&1 | tee -a ${lemposite_dir}/install.log
    # Install PhpMyAdmin
    . include/phpmyadmin.sh
  	Install_phpMyAdmin 2>&1 | tee -a ${lemposite_dir}/install.log
  	# Install Demo Index
  	. include/demo.sh
  	DEMO 2>&1 | tee -a ${oneinstack_dir}/install.log

esac