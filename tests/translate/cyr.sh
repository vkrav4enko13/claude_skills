#!/bin/bash
# Names the lines with Cyrillic that are outside the allowed places.
#
#   bash tests/translate/cyr.sh [<folder>]
#
# Without an argument walks the folders saway, sbrain, splan, swork, tests
# and the file install.sh of the project - the folder two levels above this
# script. With a folder walks every file of that folder instead of the
# project.
# The allowed places are the lines of cyr-allow.txt next to this script:
#   <path>                       - the whole file;
#   <path>:<regular expression>  - the lines of the file that match it.
# A path is a path from the walked folder.
# Cyrillic only in allowed places - "cyrillic: only in allowed places" and
# exit code 0. Otherwise a line "<file>:<line number>" per line that has
# Cyrillic outside them and exit code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -gt 1 ]; then
    echo "run: bash cyr.sh [<folder>]" >&2
    exit 2
fi

here="$(cd "$(dirname "$0")" && pwd)"
if [ $# -eq 1 ]; then
    if [ ! -d "$1" ]; then
        echo "no folder: $1" >&2
        exit 2
    fi
    cd "$1"
    items=(.)
else
    cd "$here/../.."
    items=(saway sbrain splan swork tests install.sh)
fi

perl -CSD - "$here/cyr-allow.txt" "${items[@]}" << 'PERL'
use strict;
use warnings;
use File::Find;

my ($allow, @items) = @ARGV;

# The files allowed as a whole and, per file, the expressions of its allowed
# lines.
my (%whole, %lines);
open(my $in, '<', $allow) or die "cannot read $allow\n";
while (<$in>) {
    chomp;
    my ($path, $expression) = split /:/, $_, 2;
    if (defined $expression) {
        push @{ $lines{$path} }, qr/$expression/;
    } else {
        $whole{$path} = 1;
    }
}
close $in;

my @files;
find({ no_chdir => 1, wanted => sub { push @files, $_ if -f } }, @items);

my $found = 0;
for my $file (sort @files) {
    my $name = $file;
    utf8::decode($name);
    $name =~ s{^\./}{};
    next if $whole{$name};
    open(my $in, '<', $file) or die "cannot read $file\n";
    my $n = 0;
    while (my $line = <$in>) {
        $n++;
        next unless $line =~ /\p{Cyrillic}/;
        chomp $line;
        next if grep { $line =~ $_ } @{ $lines{$name} // [] };
        print "$name:$n\n";
        $found = 1;
    }
    close $in;
}
exit 1 if $found;
print "cyrillic: only in allowed places\n";
PERL
