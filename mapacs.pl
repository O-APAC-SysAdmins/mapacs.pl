#!/usr/bin/env perl

use Getopt::Long;
use Pod::Usage;
use File::Temp qw(tempfile);
use List::Util qw(first);
use HTTP::Tiny;
use Text::ParseWords;
use strict;
use warnings;

# Prelude
#########################
$SIG{INT} = sub {
  print "\r[-] Ctrl-c received, exiting..\n";
  exit 1;
};
open TTY, '<', '/dev/tty';
$|++; # enable auto-flush

# Argument parsing
##################
my $split_index = (first { $ARGV[$_] eq '-' } 0..$#ARGV) // undef;
my @arguments = @ARGV[$split_index+1..$#ARGV];
@ARGV = @ARGV[0..$split_index-1] if defined $split_index;

GetOptions(help    => \my $help,
           verbose => \my $verbose)
  or pod2usage($!);
pod2usage(0) if $help;

# Scripts list
##############
my $scripts = [
  ['WiFi Backend Switch' => 'https://raw.githubusercontent.com/O-APAC-SysAdmins/wifi_backend/refs/heads/main/wifi.sh'],
  ['Freeze AMDGPU'       => 'https://raw.githubusercontent.com/O-APAC-SysAdmins/amd_freeze/refs/heads/main/freeze.sh'],
  ['Printer HK'          => 'https://raw.githubusercontent.com/O-APAC-SysAdmins/printerHK/refs/heads/main/printerhk.pl'],
  # add more here..
];

# Get script choice
###################
my $menu_idx = 0;
my @menu     = map { sprintf "[%d] %s", ++$menu_idx, @$_[0] } @$scripts;

my $user_choice;
while (1) {
  print join("\n", @menu), "\n\n> ";
  $user_choice = <TTY>;
  last if $user_choice =~ /^\d+$/ and $user_choice >= 1 and $user_choice <= @$scripts;
  printf "Please enter a number between 1 and %d..\n", scalar @$scripts;
}
my $choice = @$scripts[$user_choice-1];
print "choice is: @$choice\n" if $verbose;

# Download script
#################
my ($fh, $filename) = tempfile();
print "[+] Temp file at: $filename\n" if $verbose;
die   "[-] Couldnt fetch file at: @$choice[1]" unless HTTP::Tiny->new->mirror(@$choice[1], $filename)->{success};
print "[+] Fetched @$choice[1]\n" if $verbose;

# Execute script
################
chmod(0700, $filename);
close $fh;

print "executing: $filename @arguments\n" if $verbose;
exec($filename, shellwords(@arguments)) or die "couldnt exec $filename: $!";

__END__

=head1 NAME

mapacs - Master Asia Pacific Script

=head1 SYNOPSIS

mapacs.pl [options] [arguments]

 Options:
   -v, --verbose     Toggle verbose mode
   -h, --help        Show this help
