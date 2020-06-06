#!/bin/sh

REPO=cernvm-testing.cern.ch
VERSION=$1

[ -z "$VERSION" ] && exit 1

sudo make -f install.mk DEST_REPOSITORY=$REPO VERSION=$VERSION

