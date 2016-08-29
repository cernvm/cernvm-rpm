#!/bin/sh
set -e

DEST_REPOSITORY=${DEST_REPOSITORY:=cernvm-aarch64.cern.ch}

#make -C "$RENEGADE_PATH"
touch _refetch_repometadata
make
make -f install.mk DEST_REPOSITORY="$DEST_REPOSITORY"
make -f archive.mk

buildno=$(cat buildno)
buildno=$((${buildno}+1))
echo $buildno > buildno
