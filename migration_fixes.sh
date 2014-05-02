#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

sudo package-cleanup $YUM_OPTIONS --oldkernels --count=1

if rpm --root "$DEST_ROOT" -q gcutil; then
  sudo yum $YUM_OPTIONS erase gcutil
fi

if rpm --root "$DEST_ROOT" -q gsutil; then
  sudo yum $YUM_OPTIONS erase gsutil
fi

if rpm --root "$DEST_ROOT" -q retry_decorator; then
  sudo yum $YUM_OPTIONS erase retry_decorator
fi

# SL6.4 --> SL6.5
#if rpm --root "$DEST_ROOT" -q tigervnc-server; then
#  if rpm --root "$DEST_ROOT" -q tigervnc-server-module; then
#    sudo yum $YUM_OPTIONS erase tigervnc-server-module
#  fi
#fi

