#!/bin/sh
set -e

#RENEGADE_PATH=../renegade
DEST_REPOSITORY=${DEST_REPOSITORY:=cernvm-slc5.cern.ch}

#make -C "$RENEGADE_PATH"
touch _refetch_repometadata
make
make -f install.mk DEST_REPOSITORY="$DEST_REPOSITORY"
make -f archive.mk

buildno=$(cat buildno)
buildno=$((${buildno}+1))
echo $buildno > buildno
