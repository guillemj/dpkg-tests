include ../Test.mk

test-case:
	# This should produce a warning
	LC_ALL=C $(DPKG_BUILD_DEB) pkg-conff-dupe 2>&1 | \
	  grep "warning: conffile name '.*' is duplicated" && echo Pass || \
	  ( echo Fail: missing warning in output && exit 1 )

	# Conffiles need a final newline to guarantee there's been no
	# accidental file truncation.
	! $(DPKG_BUILD_DEB) pkg-conff-noel

test-clean:
	$(RM) pkg-conff-dupe.deb
	$(RM) pkg-conff-noel.deb