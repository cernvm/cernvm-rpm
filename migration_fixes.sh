#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

sudo package-cleanup $YUM_OPTIONS --oldkernels --count=1

