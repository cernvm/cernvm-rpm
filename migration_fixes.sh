#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

sudo package-cleanup $YUM_OPTIONS --cleandupes || true

#for pkg in eos-xrootd eos-client; do
#  if rpm --root "$DEST_ROOT" -q $pkg; then
#    sudo yum $YUM_OPTIONS erase $pkg
#  fi
#done

