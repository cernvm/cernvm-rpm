#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

#for pkg in lightdm accountservice lightdm-gobject lightdm-greeter; do
#  if rpm --root "$DEST_ROOT" -q $pkg; then
#    sudo yum $YUM_OPTIONS erase $pkg
#  fi
#done

