#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

sudo package-cleanup $YUM_OPTIONS --oldkernels --count=1

for pkg in java-1.5.0-gcj java_cup sinjdoc gcutil gsutil retry_decorator hiera ruby-rgen rubygem-json; do
  if rpm --root "$DEST_ROOT" -q $pkg; then
    sudo yum $YUM_OPTIONS erase $pkg
  fi
done

# SL6.4 --> SL6.5
#if rpm --root "$DEST_ROOT" -q tigervnc-server; then
#  if rpm --root "$DEST_ROOT" -q tigervnc-server-module; then
#    sudo yum $YUM_OPTIONS erase tigervnc-server-module
#  fi
#fi

