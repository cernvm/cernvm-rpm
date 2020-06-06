#!/bin/sh

DEST_ROOT="$1"
YUM_OPTIONS="$2"

#sudo yum $YUM_OPTIONS erase $(rpm --root $DEST_ROOT -q '*-i686')

#for pkg in samba-client samba-common samba-common-libs samba-client-libs samba-libs samba-common-tools pytalloc rsyslog-mmjsonparse libnfsidmap; do
#  if rpm --root $DEST_ROOT -q $pkg; then
#    sudo yum $YUM_OPTIONS erase $pkg
#  fi
#done

#for pkg in mesa-private-llvm python2-ecdsa python-paramiko python2-paramiko beecrypt beecrypt-devel beecrypt-apidocs beecrypt-devel; do
#  if rpm --root "$DEST_ROOT" -q $pkg; then
#    sudo yum $YUM_OPTIONS erase $pkg
#  fi
#done

for pkg in xorgxrdp xrdp-selinux python36 python36-libs docker-cernvm python34-libs python34 python-redis eos-client eos-fuse; do
  if rpm --root "$DEST_ROOT" -q $pkg; then
    sudo yum $YUM_OPTIONS erase $pkg
  fi
done

#for pkg in \
#  globus-gass-transfer \
#  globus-gsi-sysconfig \
#  globus-gsi-callback \
#  globus-ftp-control \
#  globus-ftp-client \
#  globus-gsi-credential \
#  globus-callout \
#  globus-io \
#  globus-gsi-openssl-error \
#  globus-gsi-proxy-ssl \
#  globus-xio \
#  globus-gssapi-error \
#  globus-openssl-module \
#  globus-gsi-proxy-core \
#  globus-gssapi-gsi \
#  globus-gss-assist \
#  globus-gsi-cert-utils \
#  globus-xio-popen-driver \
#  globus-common \
#  globus-gass-copy \
#  globus-xio-gsi-driver \
#  gfal2-all \
#  gfal2-plugin-rfio \
#  gfal2-plugin-gridftp \
#  gfal2-plugin-lfc \
#  gfal2-plugin-srm \
#  lfc-libs \
#  uberftp \
#  glusterfs-server \
#  dcap \
#  dcap-libs \
#  dcap-tunnel-gsi \
#  dcap-devel \
#  dcap-tunnel-krb \
#  dcap-tunnel-ssl \
#  dcap-tunnel-telnet
#do
#  if rpm --root "$DEST_ROOT" -q $pkg; then
#    sudo yum $YUM_OPTIONS erase $pkg
#  fi
#done 

#sudo rm "$DEST_ROOT"/etc/yum/protected.d/systemd.conf

