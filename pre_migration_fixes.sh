#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

#for pkg in xorg-x11-drv-void openafs-kpasswd puppet-3.6.2-1.el6sat facter-1.7.6-2.el6sat ruby-shadow-1.4.1-13.el6_4 ruby-augeas-0.4.1-1.el6_4 ganglia \
#cern-cloudinit-modules; do
#for pkg in xorg-x11-drv-vmware xorg-x11-drv-wacom openssl-perl openssl-devel xcb-util astronomy-bookmarks; do
#for pkg in openafs-kpasswd puppet-3.6.2-1.el6sat facter-1.7.6-2.el6sat ruby-shadow-1.4.1-13.el6_4 ruby-augeas-0.4.1-1.el6_4 libganglia; do
#  if rpm --root "$DEST_ROOT" -q $pkg; then
#    sudo yum $YUM_OPTIONS erase $pkg
#  fi
#done

#sudo rpm --root "$DEST_ROOT" --nodeps -e openssl

