#!/bin/sh
set -e

VERSION=$1
[ x"$VERSION" = "x" ] && exit 1

ARCH=x86_64
STRONG_VERSION=${VERSION}.cernvm.${ARCH}
BASEURL=http://cernvm.cern.ch/releases
REPOS="cernvm-sl7.cern.ch cernvm-devel.cern.ch cernvm-testing.cern.ch cernvm-prod.cern.ch"
FILENAME=ucernvm.${STRONG_VERSION}.tar
URL=${BASEURL}/ucernvm-images.${STRONG_VERSION}/${FILENAME}

curl -O $URL
for repo in $REPOS; do
  sudo cvmfs_server transaction $repo
  sudo cp $FILENAME /cvmfs/$repo/update-packs/kernel/
  sudo sh -c "echo version=${STRONG_VERSION} > /cvmfs/$repo/update-packs/kernel/latest"
  sudo sh -c "echo update-pack=${FILENAME} >> /cvmfs/$repo/update-packs/kernel/latest"
  sudo cvmfs_server publish $repo
done
