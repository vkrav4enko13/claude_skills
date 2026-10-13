#!/bin/bash
# Replaces the Russian strings of map.tsv in files with their English names.
#
#   bash tests/translate/apply.sh [--scope <scope>]... <file>...
#
# Every string of map.tsv with a named scope - without --scope the scope is
# "skills" - is replaced in each file by its English name, longest first.
# A string that two named scopes have is taken from the scope named first.
# Then a line "<file>:<line number>: <fragment>" per line where Cyrillic is
# left, the fragment being the words of the line that have it, and exit
# code 1. No Cyrillic left - no output and exit code 0. A second run changes
# nothing. A named file does not exist - no file is changed, exit code 2.
# map.tsv lies next to this script.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "run: bash apply.sh [--scope <scope>]... <file>..." >&2
    exit 2
}

here="$(cd "$(dirname "$0")" && pwd)"

scopes=
while [ "${1:-}" = --scope ]; do
    [ $# -ge 2 ] || usage
    scopes="${scopes:+$scopes,}$2"
    shift 2
done
[ $# -ge 1 ] || usage
for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "no file: $file" >&2
        exit 2
    fi
done

perl -CSD - "$here/map.tsv" "${scopes:-skills}" "$@" << 'PERL'
use strict;
use warnings;

my ($map, $scopes, @files) = @ARGV;

# The place of every named scope in the order they were named.
my %place;
for (split /,/, $scopes) {
    $place{$_} = keys %place unless exists $place{$_};
}

# The English name of every Russian string of the named scopes; a string of
# two scopes keeps the name from the scope named first.
my (%english, %from);
open(my $in, '<', $map) or die "cannot read $map\n";
while (<$in>) {
    chomp;
    my @field = split /\t/, $_, -1;
    die "map.tsv: not five fields: $_\n" unless @field == 5;
    my ($scope, $russian, $english) = @field[0, 2, 3];
    next unless exists $place{$scope};
    next if exists $from{$russian} && $from{$russian} <= $place{$scope};
    $english{$russian} = $english;
    $from{$russian} = $place{$scope};
}
close $in;
my @russian = sort { length($b) <=> length($a) || $a cmp $b } keys %english;

my $left = 0;
for my $file (@files) {
    open(my $in, '<', $file) or die "cannot read $file\n";
    my $was = do { local $/; <$in> } // '';
    close $in;

    my $text = $was;
    for my $russian (@russian) {
        $text =~ s/\Q$russian\E/$english{$russian}/g;
    }
    if ($text ne $was) {
        open(my $out, '>', $file) or die "cannot write $file\n";
        print $out $text;
        close $out or die "cannot write $file\n";
    }

    my $name = $file;
    utf8::decode($name);
    my $n = 0;
    for my $line (split /\n/, $text) {
        $n++;
        my @words = $line =~ /\S*\p{Cyrillic}\S*/g;
        next unless @words;
        print "$name:$n: @words\n";
        $left = 1;
    }
}
exit $left;
PERL
