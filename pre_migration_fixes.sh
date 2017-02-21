#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

#sudo yum $YUM_OPTIONS erase $(rpm --root $DEST_ROOT -q '*-i686')

#for pkg in samba-client samba-common samba-common-libs samba-client-libs samba-libs samba-common-tools pytalloc rsyslog-mmjsonparse libnfsidmap; do
#  if rpm --root $DEST_ROOT -q $pkg; then
#    sudo yum $YUM_OPTIONS erase $pkg
#  fi
#done

#for pkg in mono-nunit mono-nunit-devel mono-data-postgresql; do
#  if rpm --root "$DEST_ROOT" -q $pkg; then
#    sudo yum $YUM_OPTIONS erase $pkg
#  fi
#done

