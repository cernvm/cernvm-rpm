#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

#for pkg in xorg-x11-drv-void openafs-kpasswd puppet-3.6.2-1.el6sat facter-1.7.6-2.el6sat ruby-shadow-1.4.1-13.el6_4 ruby-augeas-0.4.1-1.el6_4 ganglia \
#cern-cloudinit-modules; do
#for pkg in xorg-x11-drv-vmware xorg-x11-drv-wacom openssl-perl openssl-devel xcb-util astronomy-bookmarks; do
#for pkg in openafs-kpasswd puppet-3.6.2-1.el6sat facter-1.7.6-2.el6sat ruby-shadow-1.4.1-13.el6_4 ruby-augeas-0.4.1-1.el6_4 libganglia; do

#for pkg in dcap-libs; do
#  if rpm --root "$DEST_ROOT" -q $pkg; then
#    sudo yum $YUM_OPTIONS erase $pkg
#  fi
#done

#for pkg in \
#  globus-gsi-openssl-error \
#  globus-gass-copy \
#  globus-callout \
#  globus-ftp-control \
#  globus-openssl-module \
#  globus-xio-gsi-driver \
#  globus-gsi-sysconfig \
#  globus-gsi-credential \
#  globus-ftp-client \
#  globus-gss-assist \
#  globus-gssapi-gsi \
#  globus-common \
#  globus-gsi-cert-utils \
#  globus-io \
#  globus-gass-transfer \
#  globus-xio \
#  globus-xio-popen-driver \
#  globus-gsi-proxy-ssl \
#  globus-gssapi-error \
#  globus-gsi-callback \
#  globus-gsi-proxy-core
#do
#  if rpm --root "$DEST_ROOT" -q $pkg; then
#    sudo yum $YUM_OPTIONS erase $pkg
#  fi
#done

#sudo rpm --root "$DEST_ROOT" --nodeps -e openssl

