#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

#if rpm --root "$DEST_ROOT" -q xorg-x11-drv-void; then
#  sudo yum $YUM_OPTIONS erase xorg-x11-drv-void
#fi

if rpm --root "$DEST_ROOT" -q openafs-kpasswd; then
  sudo yum $YUM_OPTIONS erase openafs-kpasswd
fi

