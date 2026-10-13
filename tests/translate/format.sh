#!/bin/bash
# Changes the format of an old wiki from Russian to English, in place.
#
#   bash tests/translate/format.sh <wiki folder>
#
# Walks the .md files of the five parts of the wiki - 00-index.md, rules.md,
# journal/, work/, notes/ - and does not enter folders whose name starts with
# a dot. A Russian string of map.tsv, scopes "skills" and "old", is replaced
# by its English name only at its place in the format:
#   heading - a line "#", "##" or "###" starts with a string of the kind
#             "heading";
#   field   - "**<field>:**" at the start of a line or of a list item, the
#             sub-items "create:", "change:", "takes:", "gives:" and the
#             header cells of a check lines table;
#   value   - the text right after a field up to the end of the line, up to
#             " — " or up to ";", and the start of a "Result" cell;
#   phrase  - a hook line and the description in an index line that are
#             wholly a string of the kind "phrase";
#   tails   - the phase and "— next:" in a line of the section "In progress",
#             "in the user's words" at the end of a line of rules.md, the
#             phase at the end of a chain line of the journal, "— goal:" in
#             the line "Requirements confirmed".
# Everything else in a card is text and stays as it is, even where a word is
# a string of the table. Prints "format: <n> files changed"; a second run
# changes nothing. No argument, or the folder has no 00-index.md - a message
# and exit code 2. map.tsv lies next to this script.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "run: bash format.sh <wiki folder>" >&2
    exit 2
fi
if [ ! -f "${1%/}/00-index.md" ]; then
    echo "$1: not a wiki: no 00-index.md" >&2
    exit 2
fi
here="$(cd "$(dirname "$0")" && pwd)"
cd "$1"

# The wiki files, as paths from the wiki folder.
wiki_files() {
    local part
    echo 00-index.md
    if [ -f rules.md ]; then echo rules.md; fi
    for part in journal notes work; do
        if [ -d "$part" ]; then
            find "$part" -name '.*' -prune -o -type f -name '*.md' -print
        fi
    done
}

files=()
while IFS= read -r file; do files+=("$file"); done < <(wiki_files)

perl -CSD - "$here/map.tsv" "${files[@]}" << 'PERL'
use strict;
use warnings;

my ($map, @files) = @ARGV;

# The English name of every Russian string of the scopes "skills" and "old",
# by kind.
my %english;
open(my $in, '<', $map) or die "cannot read $map\n";
while (<$in>) {
    chomp;
    my @field = split /\t/, $_, -1;
    die "map.tsv: not five fields: $_\n" unless @field == 5;
    my ($scope, $kind, $russian, $english) = @field;
    next unless $scope eq 'skills' || $scope eq 'old';
    $english{$kind}{$russian} //= $english;
}
close $in;

# The Russian string of the kind $_[0] with the English name $_[1].
sub russian {
    my ($kind, $name) = @_;
    my @found = grep { $english{$kind}{$_} eq $name } keys %{ $english{$kind} };
    die "map.tsv: not one $kind \"$name\"\n" unless @found == 1;
    return $found[0];
}

# A pattern of the given strings, the longest first.
sub any {
    my $list = join '|', map { quotemeta } sort { length($b) <=> length($a) || $a cmp $b } @_;
    return qr/$list/;
}

my ($heading, $field, $value, $phrase) = map { any(keys %{ $english{$_} }) } qw(heading field value phrase);
my $sub = any(map { russian('field', $_) } qw(create change takes gives));
my $progress = russian('heading', 'In progress');
my $confirmed = russian('field', 'Requirements confirmed');
my $result = russian('field', 'Result');
my $next = russian('tail', 'next:');
my $goal = russian('tail', 'goal:');
my $words = russian('tail', "in the user's words");

my $dash = "\x{2014}";               # the long dash; in the format it stands between spaces
my $stop = qr/(?![\p{L}\p{N}])/;     # the string does not go on as a word
my $link = qr/- \[[^\]]*\]\([^)]*\)/;

my $changed = 0;
for my $file (@files) {
    open(my $in, '<', $file) or die "cannot read $file\n";
    my $was = do { local $/; <$in> } // '';
    close $in;

    my $index = $file =~ m{(?:^|/)00-(?:index|archive)\.md$};
    my $section = 0;    # inside the section "In progress"
    my $table = 0;      # inside a check lines table whose last cell is "Result"
    my $text = '';
    for my $line (split /^/, $was) {
        my $end = chomp($line) ? "\n" : '';

        # A heading; the section "In progress" lasts until the next one.
        if ($line =~ /^#+ /) {
            $section = $line eq "## $progress";
            $line =~ s/^(#{1,3} )($heading)$stop/$1$english{heading}{$2}/;
        }

        # A field, the value right after it and the tail "goal:" in the line
        # "Requirements confirmed".
        if ($line =~ /^(\s*(?:- )?\*\*)($field)(:\*\* ?)(.*)\z/ || $line =~ /^(\s+- )($sub)(: ?)(.*)\z/) {
            my ($head, $name, $mark, $rest) = ($1, $2, $3, $4);
            $rest =~ s/^($value)(?=;| $dash |\z)/$english{value}{$1}/;
            $rest =~ s/( $dash )\Q$goal\E/$1$english{tail}{$goal}/ if $name eq $confirmed;
            $line = $head . $english{field}{$name} . $mark . $rest;
        }

        # The header of a check lines table - every cell is a field - and the
        # start of the "Result" cell in the lines under it.
        if ($line =~ /^\|/) {
            my @cells = $line =~ /\| *([^|]*?) *(?=\|)/g;
            if (@cells && !grep { !exists $english{field}{$_} } @cells) {
                $table = $cells[-1] eq $result;
                $line =~ s/(\| *)([^|]*?)( *)(?=\|)/$1$english{field}{$2}$3/g;
            } elsif ($table) {
                $line =~ s/^(.* \| )($value)$stop(?=[^|]*\|\s*\z)/$1$english{value}{$2}/;
            }
        } else {
            $table = 0;
        }

        # A hook line and the description in an index line.
        $line =~ s/^> ($phrase)\z/> $english{phrase}{$1}/;
        $line =~ s/^($link $dash )($phrase)\z/$1$english{phrase}{$2}/ if $index;

        # The tails.
        if ($section) {
            $line =~ s/^($link $dash )($value)(?= $dash |\z)/$1$english{value}{$2}/;
            $line =~ s/^($link $dash .*? $dash )\Q$next\E/$1$english{tail}{$next}/;
        }
        if ($file eq 'rules.md') {
            $line =~ s/\Q$words\E\z/$english{tail}{$words}/;
        }
        if ($file =~ m{^journal/}) {
            $line =~ s/^(- \d{4}-\d\d-\d\d \x{b7} \[[^\]]*\]\([^)]*\): .* $dash )($value)\z/$1$english{value}{$2}/;
        }

        $text .= $line . $end;
    }
    next if $text eq $was;

    open(my $out, '>', $file) or die "cannot write $file\n";
    print $out $text;
    close $out or die "cannot write $file\n";
    $changed++;
}
print "format: $changed files changed\n";
PERL
