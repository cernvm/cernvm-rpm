#!/bin/sh
set -e

REPO=${REPO:=cernvm-devel.cern.ch}
ROOT=/cvmfs/${REPO}/cvm3
ROLLING_TAG=HEAD

VERSION=$1
if [ "x$VERSION" = "x" ]; then
  VERSION=$(grep "^VERSION =" Makefile | awk -F= '{print $2}' | sed "s/ //")
  VERSION_MINOR=$(echo $VERSION | cut -d. -f3)
  VERSION_MINOR=$(($VERSION_MINOR+1))
  VERSION=$(echo $VERSION | awk -F. '{print $1 "." $2}')
  VERSION="${VERSION}.${VERSION_MINOR}"
fi

echo "Version is $VERSION"
sed -i -e "s/^VERSION = .*/VERSION = $VERSION/" Makefile

#rm -f renegade-ready
make -C ../renegade
make
sudo cvmfs_server transaction $REPO
sudo yum --nogpgcheck --disablerepo=* --enablerepo=cernvm-meta-devel --enablerepo=cernvm-os --enablerepo=cernvm-extras --installroot $ROOT clean all
sudo yum -y --nogpgcheck --disablerepo=* --enablerepo=cernvm-meta-devel --enablerepo=cernvm-os --enablerepo=cernvm-extras --installroot $ROOT update cernvm-system-$VERSION
sudo update-packs/mk_update_pack.sh
sudo cvmfs_server publish -r cernvm-system-$VERSION -a cernvm-system-$VERSION $REPO
cvmfs_server check $REPO

HASH=$(sudo cvmfs_server lstags $REPO | grep cernvm-system-$VERSION | awk -F'|' '{print $2}' | sed "s/ //")
sudo cvmfs_server transaction $REPO
sudo cvmfs_server publish -a $ROLLING_TAG -h $HASH $REPO
sudo cvmfs_server lstags $REPO

