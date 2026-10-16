#!/bin/bash
# The survey gate: compares two series of survey runs of the chain stand.
#
#   bash tests/chain/survey-gate.sh <baseline> <series>
#
# Reads the verdicts of the judge through tally_label of tally.sh: the labels
# of the runs of a series — from blind/key.tsv, the answer — the third field of
# a line of verdict.tsv. Counts
# over all the runs of a series: violations — the "rule" lines with "no";
# decisions — the "decision" lines with "carried", out of 5 per run; flaws —
# the "flaw" lines with "named", out of 5 per run. Prints
#   violations: <baseline> <n>, <series> <n>
#   decisions: <baseline> <n>/<5×runs>, <series> <n>/<5×runs>
#   flaws: <baseline> <n>/<5×runs>, <series> <n>/<5×runs>
# then "survey gate: passed" — the series is not worse on all three and better
# on one, code 0; "survey gate: not worse, not better" — code 1; "survey gate:
# failed — <worse numbers>" — code 1. No key, a series without a key line or a
# run without a verdict, a malformed verdict (see tally.sh: a non-empty line
# without four tab-separated fields, or fewer "rule" lines than rules), or the
# series have a different number of runs — no number lines, only "survey gate:
# failed — no measurement", code 1.
# The stands folder — CHAIN_BASE, by default ~/Documents/my/chain-stand.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: bash survey-gate.sh <baseline> <series>" >&2
    exit 2
fi
base="$1"
series="$2"
here="$(cd "$(dirname "$0")" && pwd)"
B="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
key="$B/blind/key.tsv"
. "$here/tally.sh"

none() {
    echo "survey gate: failed — no measurement"
    exit 1
}

# The counts of the series $1: "<runs> <violations> <decisions> <flaws>" — into
# $counts. No key, no key line, no verdict of a run or a malformed one —
# return 1.
tally() {
    local label line a b c r=0 v=0 d=0 f=0
    [ -f "$key" ] || return 1
    while IFS= read -r label; do
        line=$(tally_label "$B/blind/$label") || return 1
        r=$((r + 1))
        read -r a b c _ <<< "$line"
        v=$((v + a))
        d=$((d + b))
        f=$((f + c))
    done < <(awk -F'\t' -v series="$1" '$2 == series { label[$3] = $1 } END { for (r in label) if (r ~ /-survey$/ || !((r "-survey") in label)) print label[r] }' "$key")
    [ $r -gt 0 ] || return 1
    counts="$r $v $d $f"
}

tally "$base" || none
read -r r1 v1 d1 f1 <<< "$counts"
tally "$series" || none
read -r r2 v2 d2 f2 <<< "$counts"
[ "$r1" -eq "$r2" ] || none

echo "violations: $base $v1, $series $v2"
echo "decisions: $base $d1/$((5 * r1)), $series $d2/$((5 * r2))"
echo "flaws: $base $f1/$((5 * r1)), $series $f2/$((5 * r2))"

worse=()
better=0
if [ "$v2" -gt "$v1" ]; then worse+=("violations $v1 → $v2"); fi
if [ "$v2" -lt "$v1" ]; then better=1; fi
if [ "$d2" -lt "$d1" ]; then worse+=("decisions $d1 → $d2"); fi
if [ "$d2" -gt "$d1" ]; then better=1; fi
if [ "$f2" -lt "$f1" ]; then worse+=("flaws $f1 → $f2"); fi
if [ "$f2" -gt "$f1" ]; then better=1; fi

if [ ${#worse[@]} -gt 0 ]; then
    list=$(printf '%s, ' "${worse[@]}")
    echo "survey gate: failed — ${list%, }"
    exit 1
fi
if [ $better -eq 1 ]; then
    echo "survey gate: passed"
    exit 0
fi
echo "survey gate: not worse, not better"
exit 1
