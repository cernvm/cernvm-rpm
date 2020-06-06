#!/bin/sh
set -e

RENEGADE_PATH=../renegade
DEST_REPOSITORY=${DEST_REPOSITORY:=cernvm-sl7.cern.ch}

#reposync --delete --newest-only --repoid=epel --download_path=/data/yum/cernvm/mirror/7/x86_64
#createrepo --database --update --workers=6 /data/yum/cernvm/mirror/7/x86_64/epel

#make -C "$RENEGADE_PATH"
touch _refetch_repometadata
make
make -f install.mk DEST_REPOSITORY="$DEST_REPOSITORY"
make -f install.mk DEST_REPOSITORY="$DEST_REPOSITORY" check
make -f install.mk DEST_REPOSITORY="$DEST_REPOSITORY" rolling_tag
make -f archive.mk

buildno=$(cat buildno)
buildno=$((${buildno}+1))
echo $buildno > buildno
