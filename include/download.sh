#!/bin/bash

Download_src() {
  [ -s "${src_url##*/}" ] && echo "[${CMSG}${src_url##*/}${CEND}] found" || { wget --limit-rate=10M -4 --tries=6 -c --no-check-certificate ${src_url}; sleep 1; }
  if [ ! -e "${src_url##*/}" ]; then
    echo "${CFAILURE}Auto download failed! You can manually download ${src_url} into the oneinstack/src directory.${CEND}"
    kill -9 $$
  fi
}