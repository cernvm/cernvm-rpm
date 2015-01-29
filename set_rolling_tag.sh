#!/bin/sh

CVMFS_REPOSITORY=$1
VERSION=$2
ROLLING_TAG=HEAD

[ -z "$CVMFS_REPOSITORY" ] && exit 1
[ -z "$VERSION" ] && exit 1

HASH=$(sudo cvmfs_server tag -lx ${CVMFS_REPOSITORY} | grep cernvm-system-${VERSION} | awk '{print $2}' | sed "s/ //")
sudo cvmfs_server tag -a ${ROLLING_TAG} -h ${HASH} ${CVMFS_REPOSITORY}
sudo cvmfs_server tag -l ${CVMFS_REPOSITORY}

