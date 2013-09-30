# chroot installation of the cernvm-meta rpm in cvmfs

include config.mk
DEST_REPOSITORY = cernvm-devel.cern.ch
DEST_PATH = /cvm3

DEST_ROOT = /cvmfs/$(DEST_REPOSITORY)/$(DEST_PATH)
YUM_OPTIONS = -y --nogpgcheck --disablerepo=* --enablerepo=cernvm-meta --enablerepo=cernvm-os --enablerepo=cernvm-extras --installroot $(DEST_ROOT)

all: /cvmfs/$(DEST_REPOSITORY)$(DEST_PATH)/.installed_cernvm-system-$(VERSION)
	
/cvmfs/$(DEST_REPOSITORY)$(DEST_PATH)/.installed_cernvm-system-$(VERSION): meta-rpms/verify-metarpm.sh
	echo "chroot install of cernvm-system-$(VERSION)"
	sudo cvmfs_server transaction $(DEST_REPOSITORY)
	if rpm --root $(DEST_ROOT) -q cernvm-system >/dev/null 2>&1; then \
	  sudo yum $(YUM_OPTIONS) clean all; \
	  sudo yum $(YUM_OPTIONS) update cernvm-system-$(VERSION); \
	else \
	  sudo yum $(YUM_OPTIONS) install cernvm-system-$(VERSION); \
	fi
	meta-rpms/verify-metarpm.sh $(DEST_ROOT) $(VERSION)
	sudo cvmfs_server publish -r cernvm-system-$(VERSION) -a cernvm-system-$(VERSION) $(DEST_REPOSITORY)
	cvmfs_server check $(DEST_REPOSITORY)	
