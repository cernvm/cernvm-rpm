#!/bin/sh
# Build a new meta-rpm with fixes from vulnerable meta-rpm $VERSION

VERSION=$1
[ -z "$VERSION" ] && exit 1

new_version=$(cat vulnerable/cernvm-system-${VERSION}-x86_64.spec.UPDATE-ME | grep '^%define cernvm_version' | awk '{print $3}')
echo "Staging cernvm-system-${new_version}"

cp vulnerable/cernvm-system-${VERSION}-x86_64.spec.UPDATE-ME fixed/cernvm-system-${new_version}-x86_64.spec
cp vulnerable/cernvm-system-${VERSION}-x86_64.spec.UPDATE-ME ../artifacts/cernvm-system-${new_version}-x86_64.spec 
echo "dummy:" > ../artifacts/Makefile.rpms-system-${new_version}-x86_64 
