#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

#sudo yum $YUM_OPTIONS erase $(rpm --root $DEST_ROOT -q '*-i686')

for pkg in mono-nunit mono-nunit-devel mono-data-postgresql; do
  if rpm --root "$DEST_ROOT" -q $pkg; then
    sudo yum $YUM_OPTIONS erase $pkg
  fi
done

