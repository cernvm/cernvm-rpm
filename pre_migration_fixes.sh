#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

for pkg in cronie cronie-noanacron cloud-utils-growpart liberation-serif-fonts; do
  if rpm --root "$DEST_ROOT" -q $pkg; then
    sudo yum $YUM_OPTIONS erase $pkg
  fi
done

