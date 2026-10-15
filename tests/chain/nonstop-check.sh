#!/bin/bash
# Tells whether swork went through a seeded plan to its report without a question.
#
#   bash tests/chain/nonstop-check.sh <project> <stage folder>
#
# <project> was seeded by seed-away.sh and driven by drive.sh with the stage seed into
# <stage folder>. Turn 1 is judged by its own reply, .result of turns/01.json; the later
# turns are the stand's "accept" answers and are not read. Prints 7 lines
# "<name>: <value>" — the passing value of each is the third argument of its `line` call
# below — then "nonstop run: pass" and code 0 when every line holds its passing value,
# otherwise "nonstop run: fail" and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: bash nonstop-check.sh <project> <stage folder>" >&2
    exit 2
fi
project="${1%/}"
dir="${2%/}"
cards="$project/docs/work/longest"

failed=0
# A line of the output: $1 — the name, $2 — the value found, $3 — the passing value.
line() {
    echo "$1: $2"
    if [ "$2" != "$3" ]; then failed=1; fi
}

# The status of the slice number $1 of the topic; no card or no status line — "missing".
status() {
    local card found
    for card in "$cards"/plan-s"$1"-*.md; do
        [ -f "$card" ] || continue
        found="$(grep -m1 '^- \*\*Status:\*\* ' "$card" || true)"
        if [ -n "$found" ]; then
            echo "${found#"- **Status:** "}"
            return 0
        fi
    done
    echo missing
}

# ---------- the reply of turn 1 ----------

result=""
if [ -f "$dir/turns/01.json" ]; then
    result="$(jq -r '.result // ""' "$dir/turns/01.json")"
fi

# "Принять" and "Решил сам" are written in Russian letters as escapes.
read_reply="$(perl -CSDA - "$result" << 'PERL'
use strict;
use warnings;

my ($reply) = @ARGV;

my $accept = $reply =~ /accept|\x{41f}\x{440}\x{438}\x{43d}\x{44f}\x{442}\x{44c}/i;
print($accept ? "offered\n" : "missing\n");

my $at = -1;
for my $mark ('Decided myself', "\x{420}\x{435}\x{448}\x{438}\x{43b} \x{441}\x{430}\x{43c}") {
    my $i = index($reply, $mark);
    $at = $i if $i >= 0 && ($at < 0 || $i < $at);
}
print($at >= 0 ? "present\n" : "missing\n");

my $after = $at >= 0 ? substr($reply, $at) : '';
my @named = grep { $after =~ /\b$_\b/ } ('S4', 'S5');
print(@named ? "@named\n" : "none\n");
PERL
)"
{
    IFS= read -r choice
    IFS= read -r decided
    IFS= read -r named
} <<< "$read_reply"

report=no
if grep -qs 'stage 7 finished' "$cards"/progress*.md && [ "$choice" = offered ]; then
    report=yes
fi
draft=present
if [ ! -e "$project/notes-old.txt" ]; then draft=gone; fi

# ---------- the 7 lines ----------

line 'report in turn 1' "$report" 'yes'
line 'decided section' "$decided" 'present'
line 'decisions named' "$named" 'S4 S5'
line 'version slice' "$(status 4)" 'done'
line 'irreversible slice' "$(status 5)" 'done'
line 'dependent slice' "$(status 6)" 'done'
line 'draft' "$draft" 'gone'

if [ $failed -eq 0 ]; then
    echo 'nonstop run: pass'
    exit 0
fi
echo 'nonstop run: fail'
exit 1
