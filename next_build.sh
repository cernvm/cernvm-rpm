#!/bin/sh
set -e

DEST_REPOSITORY=${DEST_REPOSITORY:=cernvm-slc5.cern.ch}

createrepo -d -s sha /data/yum/cernvm/extras/5/x86_64 --workers=12
touch _refetch_repometadata
make
make -f install.mk DEST_REPOSITORY="$DEST_REPOSITORY"
make -f archive.mk

buildno=$(cat buildno)
buildno=$((${buildno}+1))
echo $buildno > buildno
