#
# Dpkg functional testsuite (kind of)
#
# Copyright © 2008-2015 Guillem Jover <guillem@debian.org>
#


-include .pkg-tests.conf

## Feature checks setup ##

DPKG_SERIES ?= 1.20.x

include Feature.mk

## Test cases ##

TESTS_MANUAL :=
TESTS_MANUAL += t-deb-lfs
TESTS_MANUAL += t-conffile-prompt

TESTS_FAIL :=
TESTS_FAIL += t-dir-leftover-deadlock
TESTS_FAIL += t-dir-shared-replaces-lost
TESTS_FAIL += t-disappear-depended
TESTS_FAIL += t-conffile-divert-conffile
TESTS_FAIL += t-breaks-multiarch

TESTS_PASS :=
TESTS_PASS += t-db
TESTS_PASS += t-normal
TESTS_PASS += t-field-priority
TESTS_PASS += t-deb-format
TESTS_PASS += t-deb-split
TESTS_PASS += t-deb-conffiles
ifdef DPKG_HAS_STRICT_PATHNAME_WITHOUT_NEWLINES
TESTS_PASS += t-deb-newline
endif
TESTS_PASS += t-option-dry-run
TESTS_PASS += t-option-recursive
TESTS_PASS += t-control-bogus
TESTS_PASS += t-control-no-arch
TESTS_PASS += t-unpack-symlink
TESTS_PASS += t-unpack-hardlink
ifdef DPKG_HAS_WORKING_ROOTDIR_DIVERSIONS
TESTS_PASS += t-unpack-divert-hardlink
endif
TESTS_PASS += t-unpack-divert-nowarn
TESTS_PASS += t-unpack-fifo
ifdef DPKG_AS_ROOT
# No permissions for devices
TESTS_PASS += t-unpack-device
endif
TESTS_PASS += t-maintscript-leak
TESTS_PASS += t-filtering
TESTS_PASS += t-depends
TESTS_PASS += t-dir-leftover-parents
TESTS_PASS += t-dir-leftover-conffile
TESTS_PASS += t-disappear
TESTS_PASS += t-disappear-empty
TESTS_PASS += t-provides
TESTS_PASS += t-provides-self
TESTS_PASS += t-provides-arch-implicit
TESTS_PASS += t-provides-arch-qualified
TESTS_PASS += t-breaks
# This only works with dpkg >= 1.18.x
ifdef DPKG_HAS_SAME_RUN_BIDIRECTIONAL_CONFLICTS
TESTS_PASS += t-conflicts
endif
TESTS_PASS += t-conflict-provide-replace-real
TESTS_PASS += t-conflict-provide-replace-virtual
TESTS_PASS += t-conflict-provide-replace-virtual-multiarch
TESTS_PASS += t-conflict-provide-replace-interface
TESTS_PASS += t-predepends-no-triggers
TESTS_PASS += t-triggers
ifdef DPKG_HAS_WORKING_TRIGGERS_PENDING_UPGRADE
TESTS_PASS += t-triggers-configure
endif
TESTS_PASS += t-triggers-path
TESTS_PASS += t-triggers-depends
# This only works with dpkg >= 1.18.x
ifdef DPKG_HAS_TRIGPROC_DEPCHECK
TESTS_PASS += t-triggers-depcycle
TESTS_PASS += t-triggers-depfarcycle
endif
TESTS_PASS += t-triggers-selfcycle
TESTS_PASS += t-triggers-cycle
ifdef DPKG_HAS_TRIGPROC_DEPCHECK
TESTS_PASS += t-triggers-halt
endif
TESTS_PASS += t-file-conflicts
TESTS_PASS += t-file-replaces
TESTS_PASS += t-file-replaces-disappear
TESTS_PASS += t-file-replaces-versioned
TESTS_PASS += t-conffile-normal
ifdef DPKG_HAS_WORKING_ROOTDIR_MAINTSCRIPT_HELPER
TESTS_PASS += t-conffile-obsolete
endif
TESTS_PASS += t-conffile-orphan
TESTS_PASS += t-conffile-forcemiss
TESTS_PASS += t-conffile-forcenew
TESTS_PASS += t-conffile-forceask
ifdef DPKG_CAN_INSTALL_CONFFILE_ON_ALT_ROOT
TESTS_PASS += t-conffile-root-option
endif
TESTS_PASS += t-conffile-divert-normal
TESTS_PASS += t-conffile-conflict
TESTS_PASS += t-conffile-replaces
TESTS_PASS += t-conffile-replaces-upgrade
TESTS_PASS += t-conffile-replaces-downgrade
TESTS_PASS += t-conffile-replaces-existing
TESTS_PASS += t-conffile-replaces-existing-and-upgrade
TESTS_PASS += t-conffile-replaces-disappear
ifdef DPKG_CAN_REPLACE_DIVERTED_CONFFILE
ifdef DPKG_HAS_WORKING_ROOTDIR_DIVERSIONS
TESTS_PASS_CONFFILE_REPLACES_DIVERTED = yes
endif
ifdef DPKG_AS_ROOT
TESTS_PASS_CONFFILE_REPLACES_DIVERTED = yes
endif
ifdef TESTS_PASS_CONFFILE_REPLACES_DIVERTED
TESTS_PASS += t-conffile-replaces-diverted
endif
endif
TESTS_PASS += t-conffile-versioned-replaces-downgrade
ifdef DPKG_HAS_WORKING_ROOTDIR_MAINTSCRIPT_HELPER
TESTS_PASS += t-conffile-rename
endif
TESTS_PASS += t-queue-process-deconf-dupe
TESTS_PASS += t-package-type
TESTS_PASS += t-symlink-dir
# This only works with dpkg >= 1.17.x
ifdef DPKG_HAS_MAINTSCRIPT_SWITCH_DIR_SYMLINK
ifdef DPKG_HAS_WORKING_ROOTDIR_MAINTSCRIPT_HELPER
TESTS_PASS += t-switch-symlink-abs-to-dir
TESTS_PASS += t-switch-symlink-rel-to-dir
TESTS_PASS += t-switch-dir-to-symlink-abs
TESTS_PASS += t-switch-dir-to-symlink-rel
endif
endif
TESTS_PASS += t-source-minimal
TESTS_PASS += t-substvars
TESTS_PASS += t-failinst-failrm
TESTS_PASS += t-dir-extension-check
TESTS_PASS += t-multiarch

ifneq (,$(filter test-all,$(DPKG_TESTSUITE_OPTIONS)))
TESTS := $(TESTS_PASS) $(TESTS_FAIL) $(TESTS_MANUAL)
else
TESTS := $(TESTS_PASS)
endif


# By default do nothing
all help::
	@echo "Run 'make test' to run all the tests"
	@echo "Run 'make <test-id>-test' to run a specifict test"
	@echo "Run 'make clean' to remove all intermediary files"
	@echo ""
	@echo "The available tests are: $(TESTS)"

build_targets = $(addsuffix -build,$(TESTS))

build:: $(build_targets)
$(build_targets)::
	$(MAKE) -C $(subst -build,,$@) build

.PHONY: build $(build_targets)


test_targets = $(addsuffix -test,$(TESTS))

test:: $(test_targets)
$(test_targets)::
	$(MAKE) -C $(subst -test,,$@) test

.PHONY: test $(test_targets)


test_clean_targets = $(addsuffix -test-clean,$(TESTS))

test-clean:: $(test_clean_targets)
$(test_clean_targets)::
	$(MAKE) -C $(subst -test-clean,,$@) test-clean

.PHONY: test-clean $(test_clean_targets)


clean_targets = $(addsuffix -clean,$(TESTS))

clean:: $(clean_targets)
$(clean_targets)::
	$(MAKE) -C $(subst -clean,,$@) clean

.PHONY: clean $(clean_targets)

