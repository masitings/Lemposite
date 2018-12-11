#!/bin/bash
# Author:  Alpha Eva <kaneawk AT gmail.com>
#
# Notes: OneinStack for CentOS/RedHat 6+ Debian 7+ and Ubuntu 12+
#
# Project home page:
#       https://oneinstack.com
#       https://github.com/lj2007331/oneinstack

checkDownload() {
  mirrorLink=http://mirrors.linuxeye.com/oneinstack/src
  pushd ${oneinstack_dir}/src > /dev/null
  # General system utils
  echo "Download openSSL..."
  src_url=https://www.openssl.org/source/openssl-${openssl_ver}.tar.gz && Download_src
  echo "Download cacert.pem..."
  src_url=https://curl.haxx.se/ca/cacert.pem && Download_src

  echo "Download jemalloc..."
  src_url=${mirrorLink}/jemalloc-${jemalloc_ver}.tar.bz2 && Download_src
  # Download Nginx
  echo "Download openSSL1.1..."
  src_url=https://www.openssl.org/source/openssl-${openssl11_ver}.tar.gz && Download_src
  echo "Download nginx..."
  src_url=http://nginx.org/download/nginx-${nginx_ver}.tar.gz && Download_src
  # Download Pcre
  echo "Download pcre..."
  src_url=https://ftp.pcre.org/pub/pcre/pcre-${pcre_ver}.tar.gz && Download_src
  # Download Boost
  echo "Download boost..."
  [ "${IPADDR_COUNTRY}"x == "CN"x ] && DOWN_ADDR_BOOST=${mirrorLink} || DOWN_ADDR_BOOST=http://downloads.sourceforge.net/project/boost/boost/${boost_ver}
  boostVersion2=$(echo ${boost_ver} | awk -F. '{print $1"_"$2"_"$3}')
  src_url=${DOWN_ADDR_BOOST}/boost_${boostVersion2}.tar.gz && Download_src
  # Maria DB
  echo "Download MariaDB 10.3 source package..."
  FILE_NAME=mariadb-${mariadb103_ver}.tar.gz
  if [ "${IPADDR_COUNTRY}"x == "CN"x ]; then
      DOWN_ADDR_MARIADB=http://mirrors.tuna.tsinghua.edu.cn/mariadb/mariadb-${mariadb103_ver}/source
      DOWN_ADDR_MARIADB_BK=http://mirrors.ustc.edu.cn/mariadb/mariadb-${mariadb103_ver}/source
  else
    DOWN_ADDR_MARIADB=http://ftp.osuosl.org/pub/mariadb/mariadb-${mariadb103_ver}/source
    DOWN_ADDR_MARIADB_BK=http://mirror.nodesdirect.com/mariadb/mariadb-${mariadb103_ver}/source
  fi
  src_url=${DOWN_ADDR_MARIADB}/${FILE_NAME} && Download_src
  wget -4 --tries=6 -c --no-check-certificate ${DOWN_ADDR_MARIADB}/md5sums.txt -O ${FILE_NAME}.md5
  MARAIDB_TAR_MD5=$(awk '{print $1}' ${FILE_NAME}.md5)
  [ -z "${MARAIDB_TAR_MD5}" ] && MARAIDB_TAR_MD5=$(curl -s ${DOWN_ADDR_MARIADB_BK}/md5sums.txt | grep ${FILE_NAME} | awk '{print $1}')
  tryDlCount=0
  while [ "$(md5sum ${FILE_NAME} | awk '{print $1}')" != "${MARAIDB_TAR_MD5}" ]; do
    wget -c --no-check-certificate ${DOWN_ADDR_MARIADB_BK}/${FILE_NAME};sleep 1
    let "tryDlCount++"
    [ "$(md5sum ${FILE_NAME} | awk '{print $1}')" == "${MARAIDB_TAR_MD5}" -o "${tryDlCount}" == '6' ] && break || continue
  done
  if [ "${tryDlCount}" == '6' ]; then
    echo "${CFAILURE}${FILE_NAME} download failed, Please contact the author! ${CEND}"
    kill -9 $$
  fi
  # Install PHP 7.2
  echo "Install PHP 7.2.."
  sudo apt-get install -y language-pack-en-base
  export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  sudo locale-gen en_US.UTF-8
  sudo add-apt-repository ppa:ondrej/php
  sudo apt-get update
  sudo apt-get install -y php7.2-fpm php7.2-cli php7.2-common php7.2-json php7.2-opcache php7.2-mysql php7.2-recode php7.2-tidy php7.2-dev php7.2-intl php7.2-snmp php7.2-curl php7.2-phpdbg php7.2-mbstring php7.2-zip php7.2-soap php7.2-xml
  # Install Phpmyadmin
  echo "Download phpMyAdmin..."
  src_url=https://files.phpmyadmin.net/phpMyAdmin/${phpmyadmin_ver}/phpMyAdmin-${phpmyadmin_ver}-all-languages.tar.gz && Download_src


  popd > /dev/null
}
