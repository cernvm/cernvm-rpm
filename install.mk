# chroot installation of the cernvm-meta rpm in cvmfs

include config.mk
DEST_REPOSITORY = cernvm-sl7.cern.ch
DEST_PATH = /cvm4

DEST_ROOT = /cvmfs/$(DEST_REPOSITORY)/$(DEST_PATH)
YUM_OPTIONS = -y --nogpgcheck --disablerepo=* --enablerepo=cernvm-meta --enablerepo=cernvm-os --enablerepo=cernvm-extras --disableexcludes=all --installroot $(DEST_ROOT)

DEVICES = stdout stderr random urandom

all: rolling_tag
	
/cvmfs/$(DEST_REPOSITORY)$(DEST_PATH)/.installed_cernvm-system-$(VERSION): meta-rpms/verify-metarpm.sh
	echo "chroot install of cernvm-system-$(VERSION)"
	sudo cvmfs_server transaction $(DEST_REPOSITORY)
	if [ -d $(DEST_ROOT)/dev ]; then \
	  for d in $(DEVICES); do sudo rm -f $(DEST_ROOT)/dev/$$d && sudo ln -s /dev/$$d $(DEST_ROOT)/dev/$$d; done \
	fi
	./pre_migration_fixes.sh $(DEST_ROOT) "$(YUM_OPTIONS)"
	if rpm --root $(DEST_ROOT) -q cernvm-system >/dev/null 2>&1; then \
	  sudo yum $(YUM_OPTIONS) clean all; \
	  sudo yum $(YUM_OPTIONS) update cernvm-system-$(VERSION); \
	else \
	  sudo yum $(YUM_OPTIONS) install cernvm-system-$(VERSION); \
	fi
	for d in $(DEVICES); do sudo rm -f $(DEST_ROOT)/dev/$$d; done
	./migration_fixes.sh $(DEST_ROOT) "$(YUM_OPTIONS)"
	meta-rpms/verify-metarpm.sh $(DEST_ROOT) $(VERSION)
	sudo update-packs/mk_update_pack.sh $(DEST_ROOT) /cvmfs/$(DEST_REPOSITORY)/update-packs/$(DEST_PATH)
	sudo cvmfs_server publish -a cernvm-system-$(VERSION) $(DEST_REPOSITORY)
	cvmfs_server check -c $(DEST_REPOSITORY)

rolling_tag: /cvmfs/$(DEST_REPOSITORY)$(DEST_PATH)/.installed_cernvm-system-$(VERSION)
	./set_rolling_tag.sh $(DEST_REPOSITORY) $(VERSION)		
