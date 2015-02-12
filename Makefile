# Result is a Meta RPM and its dependencies mirrored in the cernvm-os repository

include config.mk

PLATFORM = x86_64
SL_UPSTREAM = 7
EDITION = system

TOP = $(shell pwd)
STRONG_VERSION=$(EDITION)-$(VERSION)-$(PLATFORM)
STRONG_HOTFIX_VERSION=$(EDITION)-$(HOTFIX_VERSION)-$(PLATFORM)
STRONG_PLATFORM=$(SL_UPSTREAM)-$(PLATFORM)
CERNVM_REPO_BASE = /data/yum/cernvm
CERNVM_META_REPOTYPE = 

OS_RPM_DIR = $(CERNVM_REPO_BASE)/os/$(SL_UPSTREAM)/$(PLATFORM)
META_RPM_DIR = $(CERNVM_REPO_BASE)/meta$(CERNVM_META_REPOTYPE)/$(SL_UPSTREAM)/$(PLATFORM)
META_RPM_NAME = cernvm-$(EDITION)-$(VERSION)-1.el$(SL_UPSTREAM).$(PLATFORM).rpm
META_RPM_HOTFIX_NAME = cernvm-$(EDITION)-$(HOTFIX_VERSION)-1.el$(SL_UPSTREAM).$(PLATFORM).rpm
META_RPM = $(META_RPM_DIR)/$(META_RPM_NAME)
META_RPM_HOTFIX = $(META_RPM_DIR)/$(META_RPM_HOTFIX_NAME)

all: $(META_RPM)
	$(MAKE) repos

clean-meta-rpm:
	rm -f $(META_RPM)

hotfix: artifacts/cernvm-$(STRONG_HOTFIX_VERSION).spec
	rpmbuild --define "%_topdir $(TOP)/artifacts/rpmbuild-$(STRONG_HOTFIX_VERSION)" \
	  --define "%_tmppath $(TOP)/artifacts/rpmbuild-$(STRONG_HOTFIX_VERSION)/TMP" \
          -ba --target $(PLATFORM) \
          artifacts/cernvm-$(STRONG_HOTFIX_VERSION).spec
	mv artifacts/rpmbuild-$(STRONG_HOTFIX_VERSION)/RPMS/$(PLATFORM)/$(META_RPM_HOTFIX_NAME) artifacts/
	cp artifacts/$(META_RPM_HOTFIX_NAME) $(META_RPM_HOTFIX)	
	$(MAKE) repos

#############################
#  Yum Repository Metadata  #
#############################

repos: $(OS_RPM_DIR)/repodata/repomd.xml $(META_RPM_DIR)/repodata/repomd.xml

$(OS_RPM_DIR)/repodata/repomd.xml: $(wildcard $(OS_RPM_DIR)/*.rpm)
	createrepo -d --update -s sha $(OS_RPM_DIR) --workers=12

$(META_RPM_DIR)/repodata/repomd.xml: $(wildcard $(META_RPM_DIR)/*.rpm)
	createrepo --no-database -s sha $(META_RPM_DIR) --workers=12

################################
#  CernVM Edition Definitions  #
################################

#artifacts/packages-basic-$(VERSION)-$(PLATFORM): $(wildcard groups/bits/*) _TESTGROUP _TESTEXTRA release
#	cat groups/bits/minimal groups/bits/base groups/bits/misc groups/bits/perl groups/bits/python \
#	  groups/bits/batch groups/bits/head groups/bits/copilot groups/bits/hep-oslibs \
#          groups/bits/atlas groups/bits/32bit groups/bits/cernvm groups/bits/containers groups/bits/upstream-dropped | sort -u > artifacts/packages-basic-$(VERSION)-$(PLATFORM)
#	[ -s _TESTGROUP ] && cat _TESTGROUP > artifacts/packages-basic-$(VERSION)-$(PLATFORM) || true
#	[ -s _TESTEXTRA ] && cat _TESTEXTRA >> artifacts/packages-basic-$(VERSION)-$(PLATFORM) || true

#artifacts/packages-system-$(VERSION)-$(PLATFORM): $(wildcard groups/bits/*) artifacts/packages-basic-$(VERSION)-$(PLATFORM)
#	cat artifacts/packages-basic-$(VERSION)-$(PLATFORM) | sort -u > artifacts/packages-system-$(VERSION)-$(PLATFORM)
#	#cat artifacts/packages-basic-$(VERSION)-$(PLATFORM) groups/bits/gui groups/bits/xfce | sort -u > artifacts/packages-system-$(VERSION)-$(PLATFORM)

groups/packages: $(wildcard groups/bits*) groups/Makefile
	$(MAKE) -C groups packages

artifacts/packages-system-$(VERSION)-$(PLATFORM): _TESTGROUP _TESTEXTRA release groups/packages
	cat groups/packages | sort -u > artifacts/packages-system-$(VERSION)-$(PLATFORM)
	[ -s _TESTGROUP ] && cat _TESTGROUP > artifacts/packages-system-$(VERSION)-$(PLATFORM) || true
	[ -s _TESTEXTRA ] && cat _TESTEXTRA >> artifacts/packages-system-$(VERSION)-$(PLATFORM) || true

artifacts/postscript-$(STRONG_VERSION): groups/bits/postscript
	cat groups/bits/postscript > artifacts/postscript-$(STRONG_VERSION)


#######################################################################
#  Complete, strongly versioned package list including upstream URLs  #
#######################################################################

artifacts/repodata-$(STRONG_PLATFORM): meta-rpms/fetch-upstream.pl meta-rpms/upstream.pl release buildno _refetch_repometadata
	rm -rf artifacts/repodata-$(STRONG_PLATFORM)~
	mkdir artifacts/repodata-$(STRONG_PLATFORM)~
	[ -d artifacts/repodata-$(STRONG_PLATFORM) ] && cp --preserve artifacts/repodata-$(STRONG_PLATFORM)/* artifacts/repodata-$(STRONG_PLATFORM)~ || true
	meta-rpms/fetch-upstream.pl -r artifacts/repodata-$(STRONG_PLATFORM)~ \
	  -u el$(SL_UPSTREAM) -a $(PLATFORM)
	rm -rf artifacts/repodata-$(STRONG_PLATFORM)
	mv artifacts/repodata-$(STRONG_PLATFORM)~ artifacts/repodata-$(STRONG_PLATFORM)

artifacts/Makefile.rpms-$(STRONG_VERSION): artifacts/requires-$(STRONG_VERSION) meta-rpms/create-sourcelist.sh
	cut -d" " -f2 artifacts/requires-$(STRONG_VERSION) | meta-rpms/create-sourcelist.sh > artifacts/Makefile.rpms-$(STRONG_VERSION)

artifacts/pkgilp-$(STRONG_VERSION): artifacts/packages-$(STRONG_VERSION) meta-rpms/resolve.pl meta-rpms/upstream.pl artifacts/repodata-$(STRONG_PLATFORM)
	meta-rpms/resolve.pl -r artifacts/repodata-$(STRONG_PLATFORM) -u el$(SL_UPSTREAM) -a $(PLATFORM) \
	  -p artifacts/packages-$(STRONG_VERSION) \
	  -o artifacts/pkgilp-$(STRONG_VERSION) -d artifacts/deplist-$(STRONG_VERSION) \
	  -k artifacts/rpmlist-$(STRONG_VERSION)

artifacts/pkgilp-solution-$(STRONG_VERSION): artifacts/pkgilp-$(STRONG_VERSION) meta-rpms/resolve.pl meta-rpms/upstream.pl artifacts/repodata-$(STRONG_PLATFORM)
	glpsol --cpxlp artifacts/pkgilp-$(STRONG_VERSION) -o artifacts/pkgilp-solution-$(STRONG_VERSION)~ | \
	  tee artifacts/pkgilp-stdout-$(STRONG_VERSION)
	grep -q "INTEGER OPTIMAL SOLUTION FOUND" artifacts/pkgilp-stdout-$(STRONG_VERSION)
	mv artifacts/pkgilp-solution-$(STRONG_VERSION)~ artifacts/pkgilp-solution-$(STRONG_VERSION)
	rm -f artifacts/pkgilp-stdout-$(STRONG_VERSION)

artifacts/requires-$(STRONG_VERSION): artifacts/pkgilp-solution-$(STRONG_VERSION) meta-rpms/resolve.pl meta-rpms/upstream.pl artifacts/repodata-$(STRONG_PLATFORM)
	meta-rpms/resolve.pl -r artifacts/repodata-$(STRONG_PLATFORM) -u el$(SL_UPSTREAM) -a $(PLATFORM) \
	  -i artifacts/pkgilp-solution-$(STRONG_VERSION) > artifacts/requires-$(STRONG_VERSION)


#####################
#  Create Meta-RPM  #
#####################

artifacts/cernvm-$(STRONG_VERSION).spec: artifacts/requires-$(STRONG_VERSION) artifacts/postscript-$(STRONG_VERSION) meta-rpms/meta-rpm.spec.template
	echo "%define cernvm_edition $(EDITION)" > artifacts/cernvm-$(STRONG_VERSION).spec
	echo "%define cernvm_version $(VERSION)" >> artifacts/cernvm-$(STRONG_VERSION).spec
	echo "%define cernvm_sl_upstream .el$(SL_UPSTREAM)" >> artifacts/cernvm-$(STRONG_VERSION).spec
	awk '{if ($$0 ~ /__DEPENDENCIES__/) {system("cut -d@ -f1 artifacts/requires-$(STRONG_VERSION) | sed -e \"s/=/ = /\" | sort | sed -e \"s/^/Requires: /\"")} else print;}' meta-rpms/meta-rpm.spec.template | \
	  awk '{if ($$0 ~ /__POSTSCRIPT__/) {system("cat artifacts/postscript-$(STRONG_VERSION)")} else print;}' \
	   >> artifacts/cernvm-$(STRONG_VERSION).spec

artifacts/$(META_RPM_NAME): artifacts/cernvm-$(STRONG_VERSION).spec
	rpmbuild --define "%_topdir $(TOP)/artifacts/rpmbuild-$(STRONG_VERSION)" --define "%_tmppath $(TOP)/artifacts/rpmbuild-$(STRONG_VERSION)/TMP" \
	  -ba --target $(PLATFORM) \
	  artifacts/cernvm-$(STRONG_VERSION).spec
	mv artifacts/rpmbuild-$(STRONG_VERSION)/RPMS/$(PLATFORM)/$(META_RPM_NAME) artifacts/


########################
#  Repository Updates  #
########################

$(META_RPM): artifacts/$(META_RPM_NAME) artifacts/Makefile.rpms-$(STRONG_VERSION)
	$(MAKE) RPMS_DIR=$(OS_RPM_DIR) -f artifacts/Makefile.rpms-$(STRONG_VERSION)
	cp artifacts/$(META_RPM_NAME) $(META_RPM)

clean:
	rm -rf artifacts/rpmbuild*
	rm -f artifacts/* || true

distclean:
	rm -rf artifacts/rpmbuild*
	rm -rf artifacts/repodata*
	rm -f artifacts/*

