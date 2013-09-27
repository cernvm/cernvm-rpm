#!/bin/sh

REPO=${REPO:=cernvm-testing.cern.ch}
VERSION=$1
if [ "x$VERSION" = "x" ]; then
  exit 1
fi

ROOT=/cvmfs/${REPO}/cvm3
ROLLING_TAG=HEAD

sudo cvmfs_server transaction $REPO
sudo yum --nogpgcheck --disablerepo=* --enablerepo=cernvm-meta-devel --enablerepo=cernvm-os --enablerepo=cernvm-extras --installroot $ROOT clean all
sudo yum -y --nogpgcheck --disablerepo=* --enablerepo=cernvm-meta-devel --enablerepo=cernvm-os --enablerepo=cernvm-extras --installroot $ROOT update cernvm-system-$VERSION
sudo cvmfs_server publish -a cernvm-system-$VERSION $REPO
cvmfs_server check $REPO

HASH=$(sudo cvmfs_server lstags $REPO | grep cernvm-system-$VERSION | awk -F'|' '{print $2}' | sed "s/ //")
sudo cvmfs_server transaction $REPO
sudo cvmfs_server publish -a $ROLLING_TAG -h $HASH $REPO
sudo cvmfs_server lstags $REPO


