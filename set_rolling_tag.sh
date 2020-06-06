#!/bin/sh

CVMFS_REPOSITORY=$1
VERSION=$2
ROLLING_TAGS="HEAD HEAD4"

[ -z "$CVMFS_REPOSITORY" ] && exit 1
[ -z "$VERSION" ] && exit 1

HASH=$(sudo cvmfs_server tag -lx ${CVMFS_REPOSITORY} | grep cernvm-system-${VERSION} | awk '{print $2}' | sed "s/ //")
for tag in $ROLLING_TAGS; do
  sudo cvmfs_server tag -a $tag -h ${HASH} ${CVMFS_REPOSITORY}
done
sudo cvmfs_server tag -l ${CVMFS_REPOSITORY}

