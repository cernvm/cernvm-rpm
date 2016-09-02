# chroot installation of the cernvm-meta rpm in cvmfs

include config.mk
DEST_REPOSITORY =
DEST_PATH = boinc-i686

DEST_ROOT = /cvmfs/$(DEST_REPOSITORY)/$(DEST_PATH)
YUM_OPTIONS = -y --nogpgcheck --disablerepo=* --enablerepo=cernvm-meta --enablerepo=cernvm-os --enablerepo=cernvm-extras --installroot $(DEST_ROOT) --skip-broken

DEVICES = stdout stderr random urandom

all:/cvmfs/$(DEST_REPOSITORY)/$(DEST_PATH)/.installed_cernvm-system-$(VERSION)
	
/cvmfs/$(DEST_REPOSITORY)/$(DEST_PATH)/.installed_cernvm-system-$(VERSION): meta-rpms/verify-metarpm.sh
	echo "local folder instead of chroot install of cernvm-system-$(VERSION)"
	if [ -d $(DEST_ROOT)/dev ]; then \
	  for d in $(DEVICES); do sudo rm -f $(DEST_ROOT)/dev/$$d && sudo ln -s /dev/$$d $(DEST_ROOT)/dev/$$d; done \
	fi
	./pre_migration_fixes.sh $(DEST_ROOT) "$(YUM_OPTIONS)"
	sudo yum $(YUM_OPTIONS) clean all;
	if rpm --root $(DEST_ROOT) -q cernvm-system >/dev/null 2>&1; then \
	  sudo yum $(YUM_OPTIONS) update cernvm-system-$(VERSION); \
	else \
	  sudo yum $(YUM_OPTIONS) install cernvm-system-$(VERSION); \
	  ./set_repos.sh; \
	fi
	for d in $(DEVICES); do sudo rm -f $(DEST_ROOT)/dev/$$d; done
	./migration_fixes.sh $(DEST_ROOT) "$(YUM_OPTIONS)"
	meta-rpms/verify-metarpm.sh $(DEST_ROOT) $(VERSION)
	sudo update-packs/mk_update_pack.sh $(DEST_ROOT) /cvmfs/$(DEST_REPOSITORY)/update-packs/$(DEST_PATH)
