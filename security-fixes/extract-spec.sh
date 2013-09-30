#!/bin/sh
# Recovers a spec file from the archive

VERSION=$1
[ -z "$VERSION" ] && exit 1

tar -xf ../archive/artifacts-${VERSION}.tar.gz artifacts-${VERSION}/cernvm-system-${VERSION}-x86_64.spec
mv artifacts-${VERSION}/cernvm-system-${VERSION}-x86_64.spec vulnerable/cernvm-system-${VERSION}-x86_64.spec.UPDATE-ME
rmdir artifacts-${VERSION}

