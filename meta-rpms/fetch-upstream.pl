#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Std;
use Data::Dumper;
use English;
use File::Basename;

my $VERSION = 0.1;

sub main::HELP_MESSAGE {
  print "CernVM Fetch RPM-XML (Sqlite) Upstream Meta Data\n";
  print "Usage:\n  $0 [options]\n";
  print "Options: \n";
  print "  -r  Directory containing repodata SQlite files\n";
  print "  -u  Upstream version\n";
  print "  -a  Architecture (i386, x86_64)\n";
  print "  -s  Specific repo only\n";
}

sub main::VERSION_MESSAGE {
  print "$0 version $VERSION (contact: jblomer\@cern.ch)\n";
}

my $basedir = dirname(__FILE__);
my %repo_config = do "./$basedir/upstream.pl";

# Option parsing
$Getopt::Std::STANDARD_HELP_VERSION = 1;
our($opt_r, $opt_u, $opt_a, $opt_s);
getopts('r:u:a:s:');
my $arch = $opt_a;
my $upstream_version = $opt_u;
my $repodata_dir = $opt_r;
my $specific_repo = $opt_s;  

foreach my $repo (keys %repo_config) {
  if (!defined($specific_repo) or $repo eq $specific_repo) {
    my $url = $repo_config{$repo}->{'baseurl'}->{$upstream_version}->{$arch};
    print "Fetching meta data of $repo ($url)\n";
    my $decompressor = "bunzip2";
    my $primary = `curl $url/repodata/repomd.xml 2>/dev/null | grep primary.sqlite.bz2`;
    if ($primary eq "") {
      $primary = `curl $url/repodata/repomd.xml 2>/dev/null | grep primary.sqlite.xz`;
      $decompressor = "xzdec";
    }
    if ($primary eq "") {
      next;
    }
    chomp $primary;
    $primary =~ s|^[^/]*/([a-z0-9\.\-]*).*|$1|;

    print "Fetching timestamp of $url/repodata/$primary\n";
    system("curl -I -R -o timestamp $url/repodata/$primary 2>/dev/null");
    if ( (! -e "$repodata_dir/$repo.sqlite") || ((stat('timestamp'))[9] > (stat("$repodata_dir/$repo.sqlite"))[9]) ) {
      print "Downloading $url/repodata/$primary\n";
      system("curl $url/repodata/$primary 2>/dev/null | $decompressor -c > $repodata_dir/$repo.sqlite");
    }
    unlink 'timestamp';
  }
}
