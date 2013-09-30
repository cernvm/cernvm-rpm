#!/bin/sh

CVMFS_REPOSITORY=$1
VERSION=$2
ROLLING_TAG=HEAD

[ -z "$CVMFS_REPOSITORY" ] && exit 1
[ -z "$VERSION" ] && exit 1

HASH=$(sudo cvmfs_server lstags ${CVMFS_REPOSITORY} | grep cernvm-system-${VERSION} | awk -F'|' '{print $2}' | sed "s/ //")
sudo cvmfs_server transaction ${CVMFS_REPOSITORY}
sudo cvmfs_server publish -a ${ROLLING_TAG} -h ${HASH} ${CVMFS_REPOSITORY}
sudo cvmfs_server lstags ${CVMFS_REPOSITORY}

