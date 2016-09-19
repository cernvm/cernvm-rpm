#!/bin/sh

# Set repos in newly created chroot environment
printf "\
[cernvm-os]\n\
name=CernVM OS\n\
baseurl=http://localhost/data/yum/cernvm/os/7/aarch64\n\
gpgcheck=0\n\
\n\
[cernvm-meta]\n\
name=CernVM Meta\n\
baseurl= http://localhost/data/yum/cernvm/meta/7/aarch64\n\
gpgcheck=0\n\
\n\
[cernvm-extras]\n\
name=CernVM Extras\n\
baseurl= http://localhost/data/yum/cernvm/extras/7/aarch64\n\
gpgcheck=0\n\
"\
| sudo tee -a /cvmfs/cernvm-aarch64.cern.ch/cvm4-aarch64/etc/yum.repos.d/cernvm-rpm.repo
