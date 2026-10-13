#!/bin/bash
# Compares a translation with its Russian original.
#
#   bash tests/translate/compare.sh <original> <translation>
#   bash tests/translate/compare.sh --portion <N> [--reviewed]
#
# The two files have the same shape when:
#   - they have equally many headings of each level, list items, table rows
#     and code fences;
#   - the translation has no Cyrillic left once the Russian strings of map.tsv
#     with scope "skills" are struck out of it, longest first;
#   - every "strict" string of map.tsv that stands in the original as a whole
#     word - no Cyrillic letter right before it or right after it - is in the
#     translation too, Russian or English; a "strict" string that the original
#     has only inside a longer word does not count.
# Then "same shape" and exit code 0. Otherwise a line per difference and exit
# code 1.
#   --portion  - compares every file of portion <N> from portions.tsv with
#                $CHAIN_BASE/ru-state/<same path>: "portion <N>: same shape"
#                and exit code 0. The paths are paths from the project root,
#                the folder two levels above this script.
#   --reviewed - also requires for every file a line
#                "<path><TAB>checked<TAB>..." in
#                $CHAIN_BASE/translate/review-<N>.tsv.
# CHAIN_BASE is ~/Documents/my/chain-stand by default. map.tsv and
# portions.tsv lie next to this script.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "run: bash compare.sh <original> <translation> | --portion <N> [--reviewed]" >&2
    exit 2
}

here="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$here/../.." && pwd)"
B="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"

# Prints a line per difference between the original $1 and the translation $2,
# each line starting with the name $3. No differences - exit code 0.
pair() {
    local file
    for file in "$1" "$2"; do
        if [ ! -f "$file" ]; then
            echo "no file: $file" >&2
            return 1
        fi
    done
    perl -CSD - "$here/map.tsv" "$1" "$2" "$3" << 'PERL'
use strict;
use warnings;

my ($map, $original, $translation, $name) = @ARGV;
utf8::decode($name);
my $differs = 0;

sub differ {
    print "$name: $_[0]\n";
    $differs = 1;
}

sub lines {
    open(my $in, '<', $_[0]) or die "cannot read $_[0]\n";
    chomp(my @lines = <$in>);
    return @lines;
}

# How many headings of each level, list items, table rows and code fences
# the lines have.
sub shape {
    my %count;
    for (@_) {
        if (/^[ \t]*(#{1,6})[ \t]/) { $count{'level ' . length($1) . ' headings'}++ }
        elsif (/^[ \t]*(?:[-*+]|\d+[.)])[ \t]/) { $count{'list items'}++ }
        elsif (/^[ \t]*\|/) { $count{'table rows'}++ }
        elsif (/^[ \t]*(?:```|~~~)/) { $count{'code fences'}++ }
    }
    return %count;
}

# Russian strings to strike out, longest first, and the strict pairs.
my (@struck, @strict);
for (lines($map)) {
    my @field = split /\t/, $_, -1;
    die "map.tsv: not five fields: $_\n" unless @field == 5;
    push @struck, $field[2] if $field[0] eq 'skills';
    push @strict, [@field[2, 3]] if $field[4] eq 'strict';
}
@struck = sort { length($b) <=> length($a) } @struck;

my @from = lines($original);
my @to = lines($translation);

my %had = shape(@from);
my %has = shape(@to);
for my $kind (sort keys %{{%had, %has}}) {
    my ($was, $is) = ($had{$kind} // 0, $has{$kind} // 0);
    differ("$kind: $was in the original, $is in the translation") if $was != $is;
}

for my $n (1 .. @to) {
    my $rest = $to[$n - 1];
    $rest =~ s/\Q$_\E/ /g for @struck;
    my @left = $rest =~ /\S*\p{Cyrillic}\S*/g;
    differ("line $n: Cyrillic left: @left") if @left;
}

my $from = join("\n", @from);
my $to = join("\n", @to);
for (@strict) {
    my ($russian, $english) = @$_;
    # The original has the string only where it stands as a whole word.
    differ("strict string lost: $russian - $english")
        if $from =~ /(?<!\p{Cyrillic})\Q$russian\E(?!\p{Cyrillic})/
            && index($to, $russian) < 0 && index($to, $english) < 0;
}
exit $differs;
PERL
}

# Compares every file of portion $1 with its original; with --reviewed in $2
# also looks for the "checked" line of the file in the review of the portion.
portion() {
    local n path files=0 bad=0 review="$B/translate/review-$1.tsv"
    while IFS=$'\t' read -r n path; do
        [ "$n" = "$1" ] || continue
        files=$((files + 1))
        pair "$B/ru-state/$path" "$root/$path" "$path" || bad=1
        [ -n "$2" ] || continue
        if [ ! -f "$review" ] || ! awk -F'\t' -v path="$path" \
            '$1 == path && $2 == "checked" && NF > 2 { found = 1 } END { exit !found }' "$review"; then
            echo "$path: no \"checked\" line in $review"
            bad=1
        fi
    done < "$here/portions.tsv"
    if [ $files -eq 0 ]; then
        echo "no portion $1 in $here/portions.tsv" >&2
        exit 1
    fi
    [ $bad -eq 0 ] || exit 1
    echo "portion $1: same shape"
}

if [ "${1:-}" = --portion ]; then
    [ $# -eq 2 ] || { [ $# -eq 3 ] && [ "$3" = --reviewed ]; } || usage
    portion "$2" "${3:-}"
else
    [ $# -eq 2 ] || usage
    pair "$1" "$2" "$2" || exit 1
    echo "same shape"
fi
