#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Std;
use Data::Dumper;
use DBI;
use English;
use File::Basename;

my $VERSION = 0.1;

sub main::HELP_MESSAGE {
  print "CernVM Meta Package Dependecy Resolution\n";
  print "Usage:\n  $0 [options]\n";
  print "Options: \n";
  print "  -r  Directory containing repodata SQlite files\n";
  print "  -u  Upstream version\n";
  print "  -a  Architecture (i386, x86_64)\n";
  print "  -b  Compatible architecture (e.g. i386 for x86_64)\n";
  print "  -p  File containing the shopping list of packages\n";
  print "  -i  ILP solution, parse and spit out packages\n";
  print "  -o  Where to write ILP output to\n";
  print "  -k  Output file of package -- key translation table\n";
  print "  -d  Debug log file\n";
}

sub main::VERSION_MESSAGE {
  print "$0 version $VERSION (contact: jblomer\@cern.ch)\n";
}

my $basedir = dirname(__FILE__);
my %repo_config = do "$basedir/upstream.pl";

# Option parsing
$Getopt::Std::STANDARD_HELP_VERSION = 1;
our($opt_r, $opt_u, $opt_a, $opt_b, $opt_p, $opt_d, $opt_i, $opt_o, $opt_k);
getopts('r:u:a:b:p:d:i:o:k:');
my $arch = $opt_a;
my $compat_arch;
if (defined($opt_b)) {
  $compat_arch = $opt_b;
} else {
  $compat_arch = "NO_COMPAT_ARCH";
}
my $upstream_version = $opt_u;
my $repodata_dir = $opt_r;
my $ilp_out = $opt_o;
my $pkgkey_out = $opt_k;
my $version_check = 1;
if (defined($opt_d)) {
  open (DEBUG, '>', $opt_d) or die "couldn't open $opt_d";
} else {
  open (DEBUG, '>', "/dev/null") or die;
}

# Preparing upstream, extras repositories
sub prepare_repository {
  my ($name, $sqlite, $repo_hash_ref) = (shift, shift, shift);

  my $dbh = DBI->connect("dbi:SQLite:dbname=$sqlite", "", "", { RaiseError => 1 })
              or die $DBI::errstr;
  # Finds all providing packages for a specific capability (including files)
  my $st_provides = $dbh->prepare(
    "SELECT packages.name, packages.epoch, packages.version, packages.release, \
      packages.arch, provides.name, provides.flags, provides.epoch, \
      provides.version, provides.release, packages.pkgKey, 1 \
    FROM provides, packages \
    WHERE provides.pkgKey = packages.pkgKey and provides.name = ? \
    UNION SELECT packages.name, packages.epoch, packages.version, packages.release, \
      packages.arch, obsoletes.name, obsoletes.flags, obsoletes.epoch, \
      obsoletes.version, obsoletes.release, packages.pkgKey, 2 \
    FROM obsoletes, packages \
    WHERE obsoletes.pkgKey = packages.pkgKey and obsoletes.name = ? \
    UNION SELECT packages.name, packages.epoch, packages.version, \
      packages.release, packages.arch, files.name, NULL, NULL, NULL, NULL, \
      packages.pkgKey, 0 \
    FROM packages, files \
    WHERE packages.pkgKey = files.pkgKey and files.name = ?");
  my $st_select = $dbh->prepare(
    "SELECT packages.name, packages.epoch, packages.version, packages.release, \
      packages.arch, packages.location_href FROM packages WHERE pkgKey = ?");
  $repo_hash_ref->{$name} = [$dbh, $st_provides, $st_select];
}

my %upstream_repos;
my %extras_repos;
foreach my $repo (keys %repo_config) {
  next if ! $repo_config{$repo}->{'active'};
  my ($name, $sqlite) = ($repo, "$repodata_dir/$repo.sqlite");
  if ($repo_config{$repo}->{'extras'}) {
    prepare_repository $name, $sqlite, \%extras_repos;
  } else {
    prepare_repository $name, $sqlite, \%upstream_repos;
  }
}
my %all_repos = (%upstream_repos, %extras_repos);

# Read ILP solution, verify dependency closure
if (defined($opt_i)) {
  open (SOLUTION, '<', $opt_i) or die "couldn't open $opt_i";
  while(<SOLUTION>) {
    chomp;
    next if ($_ !~ /PKG_/);
    my @row = split /\s+/, $_;
    my $pkg_key = $row[2];
    my @tokens = split /_/, $pkg_key;
    (my $repo, my $pkg_id) = ($tokens[1], $tokens[2]);
    my $st_select = @{$all_repos{$repo}}[2];
    #print "REPO: $repo PKG: $pkg_id\n";
    $st_select->bind_param(1, $pkg_id);
    $st_select->execute();
    my $row_pkg = $st_select->fetchrow_arrayref();
    $st_select->finish();

    my $package = "@$row_pkg[0]=@$row_pkg[1]:@$row_pkg[2]-@$row_pkg[3]" . '@' .
                  @$row_pkg[4];
    my $active = 0;
    if (scalar(@row) > 3) {
      $active = $row[3];
      $active = $row[4] if ($active !~ /[0,1]/);
    } else {
      my $next_line = <SOLUTION>;
      chomp $next_line;
      my @row = split /\s+/, $next_line;
      $active = $row[1];
      $active = $row[2] if ($active !~ /[0,1]/);
    }
    if ($active) {
      print "$package";
      if (!$repo_config{$repo}->{'extras'}) {
        my $baseurl = $repo_config{$repo}->{'baseurl'}->{$upstream_version}->{$arch};
        print " $baseurl/@$row_pkg[5]";
      } else {
        print " _EXTRAS_";
      }
      print "\n";
    }
  }
  exit 0;
}

# Read CernVM shopping list of packages
my %cernvm_packages;
open (PACKAGES, '<', $opt_p) or die "couldn't open $opt_p";
while(<PACKAGES>) {
  chomp;
  my @fields = split('\s+', $_);
  $cernvm_packages{$fields[0]} = "";
}
close PACKAGES;
print "Read " . keys(%cernvm_packages) . " CernVM packages\n";


# Forumlate ILP
sub check_arch {
  my $rpm_arch = shift;
  return (($rpm_arch eq $arch) or ($rpm_arch eq $compat_arch) or ($rpm_arch eq "noarch"));
}

sub make_pkg_key {
  my ($repo_name, $pkg_id) = (shift, shift);
  return 'PKG_' . $repo_name . '_' . $pkg_id;
}

sub compare_dotted {
  my ($a_verstr, $b_verstr) = (shift, shift);
  my @a_tokens = split '\.', $a_verstr;
  my @b_tokens = split '\.', $b_verstr;
  do {
    my $a_part = shift @a_tokens;
    my $b_part = shift @b_tokens;
    #print STDERR "  Comparing dot parts $a_part and $b_part\n";
    return 0 if (!defined($a_part) and !defined($b_part));
    $a_part = 0 if !defined($a_part);
    $b_part = 0 if !defined($b_part);
    if (($a_part =~ /^[0-9]+$/) and ($b_part =~ /^[0-9]+$/)) {
      return 1 if ($a_part > $b_part);
      return -1 if ($a_part < $b_part);
    } else {
      return 1 if ($a_part gt $b_part);
      return -1 if ($a_part lt $b_part);
    }
  } while (1);
}

sub version_compare {
  my ($a_epoch, $a_version, $a_release, $b_epoch, $b_version, $b_release) =
    (shift, shift, shift, shift, shift, shift);
  my $vercmp;

  #print STDERR "Comparing epoch $a_epoch, $b_epoch\n";
  $a_epoch = 0 if !defined($a_epoch);
  $b_epoch = 0 if !defined($b_epoch);
  return -1 if $a_epoch < $b_epoch;
  return 1 if $a_epoch > $b_epoch;

  #print STDERR "Comparing version $a_version, $b_version\n";
  $a_version = 0 if !defined($a_version);
  $b_version = 0 if !defined($b_version);
  $vercmp = compare_dotted $a_version, $b_version;
  return $vercmp if ($vercmp != 0);

  #print STDERR "Comparing release $a_release, $b_release\n";
  $a_release = 0 if !defined($a_release);
  $b_release = 0 if !defined($b_release);
  $vercmp = compare_dotted $a_release, $b_release;
  return $vercmp if ($vercmp != 0);

  return 0;
}


# Unspecified parts for ranges means "equal", not 0
sub version_compare_ranges {
  my ($a_epoch, $a_version, $a_release, $b_epoch, $b_version, $b_release) =
    (shift, shift, shift, shift, shift, shift);
  my $vercmp;

  #print STDERR "Comparing epoch $a_epoch, $b_epoch\n";
  $a_epoch = 0 if !defined($a_epoch);
  $b_epoch = 0 if !defined($b_epoch);
  return -1 if $a_epoch < $b_epoch;
  return 1 if $a_epoch > $b_epoch;

  #print STDERR "Comparing version $a_version, $b_version\n";
  if (defined($a_version) && defined($b_version)) {
    $vercmp = compare_dotted $a_version, $b_version;
    return $vercmp if ($vercmp != 0);
  }

  #print STDERR "Comparing release $a_release, $b_release\n";
  if (defined($a_release) && defined($b_release)) {
    $vercmp = compare_dotted $a_release, $b_release;
    return $vercmp if ($vercmp != 0);
  }

  return 0;
}


# Makes a segment on the symbolic version line from -5 to 5
sub make_symbolic_version_range {
  my ($version_start, $flag) = (shift, shift);
  my @range;
  if ($flag eq 'EQ') {
    @range = ($version_start, $version_start);
  } elsif ($flag eq 'LT') {
    @range = (-5, $version_start-1);
  } elsif ($flag eq 'GT') {
    @range = ($version_start+1, 5);
  } elsif ($flag eq 'LE') {
    @range = (-5, $version_start);
  } elsif ($flag eq 'GE') {
    @range = ($version_start, 5);
  } else {
    die "Bad flag $flag";
  }
  return @range;
}


sub is_provider_for_requirement {
  my ($provides_flag, $requires_flag, $vercmp) = (shift, shift, shift);

  my @range_requires = make_symbolic_version_range 0, $requires_flag;
  my @range_provides = make_symbolic_version_range 3*$vercmp, $provides_flag;
  return (($range_provides[0] <= $range_requires[1]) &&
          ($range_provides[1] >= $range_requires[0]));
}


sub version_sane {
  my $version = shift;
  if ($version =~ /-/) {
    print STDERR "WARNING: version $version not sane\n";
    return 0;
  }
  return 1;
}


# Find providing packages of a specific capability
sub find_providers {
  my ($repo_hash_ref, $origin_pkg,
      $cap_name, $cap_flag, $cap_epoch, $cap_version, $cap_release)
    = (shift, shift, shift, shift, shift, shift, shift);
  my $include_obsoletes = shift;

  # Through all repos to search for providers
  my @candidates;
  my %seen = ();
  foreach my $repo_provides (keys %$repo_hash_ref) {
    my $st_provides = @{$all_repos{$repo_provides}}[1];
    $st_provides->bind_param(1, $cap_name);
    $st_provides->bind_param(2, $cap_name);
    $st_provides->bind_param(3, $cap_name);
    $st_provides->execute();
    my $row_provides;
    while ($row_provides = $st_provides->fetchrow_arrayref()) {
      my $provider_pkg = make_pkg_key $repo_provides, @$row_provides[10];
      #print STDERR "found provider $provider_pkg (@$row_provides[4]) for name $cap_name\n";
      #print STDERR Dumper($row_provides);
      next if exists($seen{$provider_pkg});
      # check if this is only provided by obsoletes
      next if (!$include_obsoletes && (@$row_provides[11] == 2));
      #print STDERR "provider for $cap_name $provider_pkg (@$row_provides[4]) passed obsoletes\n";
      # architecture check
      next if ! check_arch @$row_provides[4];
      #print STDERR "provider for $cap_name $provider_pkg (@$row_provides[4]) passed arch\n";

      # Check version compatibility
      my ($provides_flag, $provides_epoch, $provides_version, $provides_release) =
        (@$row_provides[6], @$row_provides[7], @$row_provides[8], @$row_provides[9]);

      if (defined($cap_flag) && defined($provides_flag) && $version_check) {
        next if !version_sane($cap_version);  # TODO: why is it in the repo?
        my $vercmp = version_compare_ranges
          $provides_epoch, $provides_version, $provides_release,
          $cap_epoch, $cap_version, $cap_release;
        next if not is_provider_for_requirement $provides_flag, $cap_flag, $vercmp;
      }
      #print STDERR "provider for $cap_name $provider_pkg (@$row_provides[4]) passed version\n";

      $seen{$provider_pkg} = "";
      print DEBUG "    Provider ($repo_provides): @$row_provides[0]-" .
        "@$row_provides[1]:@$row_provides[2]-@$row_provides[3] " .
        "(@$row_provides[4]) / $provider_pkg\n";
      # no self-dependency
      # return ("SELF") if ("$provider_pkg" eq "$origin_pkg");
      #print STDERR "provider for $cap_name $provider_pkg (@$row_provides[4]) passed self-dep test\n";
      push (@candidates, "$provider_pkg");
    }
    $st_provides->finish();
  }
  #if (scalar(@candidates) == 0) {
  #  print STDERR "WARNING: no provider for $cap_name";
  #  print STDERR " ($cap_flag $cap_epoch:$cap_version-$cap_release)" if defined($cap_flag);
  #  print STDERR " / $origin_pkg\n";
  #}
  return @candidates;
}


sub make_capabilities_key {
  my ($name, $flag, $epoch, $version, $release) =
    (shift, shift, shift, shift, shift);
  my $key = $name;
  if (defined($flag)) {
    $key .= "-$flag-";
    $key .= "$epoch:" if (defined($epoch));
    $key .= "$version" if (defined($version));
    $key .= "-$release" if (defined($release));
  }
  return $key;
}


my $ilp_integers = "";
my $ilp_bounds = "";
my $ilp_requires = "";
my $ilp_conflicts = "";
my $ilp_missing = "";
my $ilp_obsoleted = "";

# Through all repositories
$OUTPUT_AUTOFLUSH = 1;
my $num_packages = 0;
my %names2versions;  # all versions of a specific package name
my %broken;  # packages with unresolvable dependencies
my %providers = ();  # maps a requires line to all its providers
foreach my $repo (keys %all_repos) {
  print "Processing $repo: ";
  my $dbh = @{$all_repos{$repo}}[0];
  my $st_pkg = $dbh->prepare(
    "SELECT name, epoch, version, release, arch, pkgKey FROM packages");
  my $st_requires = $dbh->prepare(
    "SELECT name, flags, epoch, version, release FROM requires WHERE pkgKey = ? UNION SELECT ?, NULL, NULL, NULL, NULL");
  my $st_conflicts = $dbh->prepare(
    "SELECT name, flags, epoch, version, release FROM conflicts WHERE pkgKey = ?");
  my $st_obsoletes = $dbh->prepare(
    "SELECT name, flags, epoch, version, release FROM obsoletes WHERE pkgKey = ?");
  $st_pkg->execute();
  my $row_pkg;
  # Through all packages
  while ($row_pkg = $st_pkg->fetchrow_arrayref()) {
    print '.' if ($num_packages % 100 == 0);
    $num_packages++;
    my $pkg_desc = { 'name' => @$row_pkg[0], 'epoch' =>  @$row_pkg[1],
                     'version' => @$row_pkg[2], 'release' => @$row_pkg[3],
                     'arch' => @$row_pkg[4],
                     'key' => make_pkg_key $repo, @$row_pkg[5] };
    next if !check_arch $pkg_desc->{'arch'};
    my $pkg_name = "$pkg_desc->{'name'}-$pkg_desc->{'epoch'}:" .
      "$pkg_desc->{'version'}-$pkg_desc->{'release'} ($pkg_desc->{'arch'})";
    print DEBUG "Processing ($repo): $pkg_name\n";

    # Add this particular package to the list of packages with the same name
    my $name_arch = $pkg_desc->{'name'} . ' ' . $pkg_desc->{'arch'};
    if (exists($names2versions{$name_arch})) {
      my $list = $names2versions{$name_arch};
      push(@$list, $pkg_desc);
      $names2versions{$name_arch} = $list;
    } else {
      $names2versions{$name_arch} = [$pkg_desc];
    }

    # Through all required capabilities (i.e. all dependencies)
    $st_requires->bind_param(1, @$row_pkg[5]);
    $st_requires->bind_param(2, $pkg_desc->{'name'});
    $st_requires->execute();
    my $row_requires;
    while ($row_requires = $st_requires->fetchrow_arrayref()) {
      my $requires = make_capabilities_key @$row_requires[0],
        @$row_requires[1], @$row_requires[2], @$row_requires[3], @$row_requires[4];
      print DEBUG "  Requires: $requires\n";

      if (exists $providers{$requires}) {
        my $cached_list = $providers{$requires};
        foreach my $provider (@$cached_list) {
          print DEBUG "    Provider: $provider (from cache)\n";
        }
      } else {
        # Through all repos to search for providers (extras override upstream)
        my $include_obsoletes = 1;
        my @candidates = find_providers \%extras_repos, $pkg_desc->{'key'},
          @$row_requires[0], @$row_requires[1], @$row_requires[2],
          @$row_requires[3], @$row_requires[4], $include_obsoletes;
        if (scalar(@candidates) == 0) {
          @candidates = find_providers \%upstream_repos, $pkg_desc->{'key'},
          @$row_requires[0], @$row_requires[1], @$row_requires[2],
          @$row_requires[3], @$row_requires[4], $include_obsoletes;
        }
        $providers{$requires} = \@candidates;
      }

      # Exlude compat arch packages if also the right architecture exists


      # Construct Dependency ILP clause
      # TODO: Merge primary with file list
      if ((scalar(@{$providers{$requires}}) == 0) && ($requires !~ /^\//)) {
        print DEBUG "    Provider: BROKEN / $pkg_name in $repo\n";
        if (!exists($broken{$pkg_desc->{'key'}})) {
          $ilp_missing .= "$pkg_desc->{'key'} = 0\n";
          $broken{$pkg_desc->{'key'}} = "";
        }
      } else {
        my $subject_to = "0 dummy1";
        my $self_dependency = 0;
        for my $candidate (@{$providers{$requires}}) {
          if ($candidate ne $pkg_desc->{'key'}) {
            $subject_to .= " + $candidate";
          } else {
            $self_dependency = 1;
          }
        }
        if (!$self_dependency and ($subject_to ne "0 dummy1")) {
          $ilp_requires .= "$subject_to - $pkg_desc->{'key'} >= 0\n";
        }
      }
    }
    $st_requires->finish();

    # Through all conflicts
    $st_conflicts->bind_param(1, @$row_pkg[5]);
    $st_conflicts->execute();
    my $row_conflicts;
    while ($row_conflicts = $st_conflicts->fetchrow_arrayref()) {
      my $conflicts = make_capabilities_key @$row_conflicts[0],
        @$row_conflicts[1], @$row_conflicts[2], @$row_conflicts[3], @$row_conflicts[4];
      print DEBUG "  Conflicts: $conflicts\n";

      if (exists $providers{$conflicts}) {
        my $cached_list = $providers{$conflicts};
        foreach my $provider (@$cached_list) {
          print DEBUG "    Provider: $provider (from cache)\n";
        }
      } else {
        # Through all repos to search for providers (extras override upstream)
        my $include_obsoletes = 0;
        my @candidates = find_providers \%all_repos, $pkg_desc->{'key'},
          @$row_conflicts[0], @$row_conflicts[1], @$row_conflicts[2],
          @$row_conflicts[3], @$row_conflicts[4], $include_obsoletes;
        $providers{$conflicts} = \@candidates;
      }

      # Construct Conflicts ILP clause
      for my $candidate (@{$providers{$conflicts}}) {
        if ($candidate eq $pkg_desc->{'key'}) {
          $ilp_conflicts .= "$candidate = 0\n"
        } else {
          $ilp_conflicts .= "$candidate + $pkg_desc->{'key'} <= 1\n";
        }
      }
    }
    $st_conflicts->finish();

    # Through all obsoletes
    $st_obsoletes->bind_param(1, @$row_pkg[5]);
    $st_obsoletes->execute();
    my $row_obsoletes;
    while ($row_obsoletes = $st_obsoletes->fetchrow_arrayref()) {
      my $obsoletes = make_capabilities_key @$row_obsoletes[0],
        @$row_obsoletes[1], @$row_obsoletes[2], @$row_obsoletes[3], @$row_obsoletes[4];
      print DEBUG "  Obsoletes: $obsoletes\n";

      if (exists $providers{$obsoletes}) {
        my $cached_list = $providers{$obsoletes};
        foreach my $provider (@$cached_list) {
          print DEBUG "    Provider: $provider (from cache)\n";
        }
      } else {
        # Through all repos to search for providers
        my $include_obsoletes = 0;
        my @candidates = find_providers \%all_repos, $pkg_desc->{'key'},
          @$row_obsoletes[0], @$row_obsoletes[1], @$row_obsoletes[2],
          @$row_obsoletes[3], @$row_obsoletes[4], $include_obsoletes;
        $providers{$obsoletes} = \@candidates;
      }

      # Construct Obsoleted ILP clause
      for my $candidate (@{$providers{$obsoletes}}) {
        # Obsoleted versions might be necessary, i.e. xrootd-server
        if ($candidate ne $pkg_desc->{'key'}) {
          $ilp_obsoleted .= "$candidate + $pkg_desc->{'key'} <= 1\n";
        }
      }
    }
    $st_conflicts->finish();

    # Package ILP clauses
    $ilp_integers .= "$pkg_desc->{'key'}\n";
    $ilp_bounds .= "$pkg_desc->{'key'} >= 0\n";
    $ilp_bounds .= "$pkg_desc->{'key'} <= 1\n";
  }
  $st_pkg->finish();
  print "\n";
}
print "Processed $num_packages packages (" .
  keys(%names2versions) . " names) from upstream repositories\n";

print "Sorting package versions...\n";
my $ilp_minimize = "0 dummy1";
my $ilp_fixed;
my $ilp_select_version;
for my $name_arch (keys %names2versions) {
  my ($name, $trash) = split(' ', $name_arch);
  my $version_list_ref = $names2versions{$name_arch};
  my @sorted_list = @$version_list_ref;
  #print Dumper(\@sorted_list);
  @$version_list_ref =
    reverse sort {
      version_compare $a->{'epoch'}, $a->{'version'}, $a->{'release'},
        $b->{'epoch'}, $b->{'version'}, $b->{'release'}
    } @$version_list_ref;

  my $version_weight = 1;
  $ilp_select_version .= '0 dummy1';
  foreach my $p (@$version_list_ref) {
    $ilp_minimize .= " + $version_weight $p->{'key'}\n";
    $version_weight += 10;

    $ilp_select_version .= " + $p->{'key'}";
    #print "Name: $p->{'name'}\n";
    #print "  Epoch: $p->{'epoch'}\n";
    #print "  Version: $p->{'version'}\n";
    #print "  Release: $p->{'release'}\n";
  }
  $ilp_select_version .= " <= 1\n";
  if (exists $cernvm_packages{$name}) {  # TODO: only main arch
    $cernvm_packages{$name} = "FOUND";
    $ilp_select_version .= '0 dummy1';
    foreach my $p (@$version_list_ref) {
      $ilp_select_version .= " + $p->{'key'}"
    }
    $ilp_select_version .= " >= 1\n";
  }
}

# Check for missing packages from shopping list
my $packages_missing = 0;
while (my ($key, $value) = each %cernvm_packages) {
  if ($value ne "FOUND") {
    $packages_missing = 1;
    print "MISSING PACKAGE: $key\n";
  }
}
die "packages missing" if ($packages_missing);


if (defined($pkgkey_out)) {
  print "Writing package key translation table...\n";
  open (PKGKEY, '>', $pkgkey_out);
  foreach my $name (keys %names2versions) {
    my $version_list_ref = $names2versions{$name};
    foreach my $version (@$version_list_ref) {
      print PKGKEY "$version->{'key'} " .
        "$version->{'name'}-$version->{'epoch'}:$version->{'version'}-" .
        "$version->{'release'}" . '@' . "$version->{'arch'}\n";
    }
  }
  close PKGKEY;
}

print "Writing ILP\n";
open (ILP, '>', $ilp_out);
print ILP "Minimize\n";
print ILP "$ilp_minimize\n";
print ILP "Subject To\n";
print ILP "\\* Dependencies *\\\n";
print ILP "$ilp_requires";
print ILP "\\* Missing Dependencies *\\\n";
print ILP "$ilp_missing";
print ILP "\\* Obsoleted *\\\n";
print ILP "$ilp_obsoleted";
print ILP "\\* Conflicts *\\\n";
print ILP "$ilp_conflicts";
print ILP "\\* Select version *\\\n";
print ILP "$ilp_select_version";
#print ILP "\\* Fixed packages *\\\n";
#print ILP "$ilp_fixed";
print ILP "Bounds\n";
print ILP "$ilp_bounds\n";
print ILP "Integer\n";
print ILP "$ilp_integers";
print ILP "End\n\n";
close (ILP);
