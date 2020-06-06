#!/bin/sh

reposync --delete --newest-only --repoid=eos --download_path=/data/yum/cernvm/mirror/7/x86_64
reposync --delete --newest-only --repoid=eosdep --download_path=/data/yum/cernvm/mirror/7/x86_64
reposync --delete --newest-only --repoid=epel --download_path=/data/yum/cernvm/mirror/7/x86_64
createrepo --database --update --workers=6 /data/yum/cernvm/mirror/7/x86_64/epel
createrepo --database --update --workers=6 /data/yum/cernvm/mirror/7/x86_64/eos
createrepo --database --update --workers=6 /data/yum/cernvm/mirror/7/x86_64/eosdep
