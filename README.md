cernvm-rpm
==========

Build system for the CernVM Meta-RPM including chroot install into cvmfs

Creating the CernVM-FS operating system repository comprises the following
steps:
  1.  Create the fully versioned Meta-RPM closure that defines the system.
  The Meta-RPM is called cernvm-system.
  It is created based on a "shopping list" of packages
  defined in the groups/ directory.
  The dependeny resolution is done by the glpk integer linear program solver
  steered by the Perl script meta-rpm/resolve.pl
  The upstream repositories including cernvm-extras are in meta-rpm/upstream.pl.
  The cernvm-extras repository has precedence,
  otherwise newer versions have precedence over older versions.

  2. Upstream packages are shadowed into the cernvm-os yum repository for
  long-term data preservation.

  3. The cernvm-system RPM is installed/updated via yum on a cvmfs repository.
  Thus all dependencies will be installed as well.
  The cvmfs repository is tagged, the rolling hash is updated.

  4. The artifacts created during the compilation of the cernvm-system RPM
  are archived for long-term data preservation.


## Versioning

The cernvm-system version scheme is MAJOR.MINOR.BUILD.SECURITY-FIX.
The major version number is 3, as long as the repository is based on SL6.
The minor version number is the next release that is currently being worked on.
Every build increases the build counter.
Already published releases might be updated with security fixes,
indicated by the forth version number.

## How to

  * Make a new build in cernvm-devel.cern.ch: run ./next_build.sh (push to git)
  * Install a build into another repository: 
    make -f install.mk VERSION=2.9.166.0 DEST_REPOSITORY=cernvm-testing.cern.ch
  * Create a security hotfix:
