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
# Melakukan validasi apakah root atau bukan yang login dan akan mengeksekusi script ini.
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: Maaf, script ini hanya bisa dijalankan oleh super user (root)${CEND}"; exit 1; }
printf "
Aplikasi yang akan di install : 
    [*] Nginx Web Server
    [*] MariaDB
    [*] PHP 7.2
"