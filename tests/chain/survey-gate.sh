#!/bin/bash
# The survey gate: compares two series of survey runs of the chain stand.
#
#   bash tests/chain/survey-gate.sh <baseline> <series>
#
# Reads the verdicts of the judge: the labels of the runs of a series — from
# blind/key.tsv, the answer — the third field of a line of verdict.tsv; a word
# of an earlier verdict is first replaced by its English name from the rows of
# tests/translate/map.tsv with the scope "stand" and the kind "judge". Counts
# over all the runs of a series: violations — the "rule" lines with "no";
# decisions — the "decision" lines with "carried", out of 5 per run; flaws —
# the "flaw" lines with "named", out of 5 per run. Prints
#   violations: <baseline> <n>, <series> <n>
#   decisions: <baseline> <n>/<5×runs>, <series> <n>/<5×runs>
#   flaws: <baseline> <n>/<5×runs>, <series> <n>/<5×runs>
# then "survey gate: passed" — the series is not worse on all three and better
# on one, code 0; "survey gate: not worse, not better" — code 1; "survey gate:
# failed — <worse numbers>" — code 1. No key, a series without a key line or a
# run without a verdict, or the series have a different number of runs — no
# number lines, only "survey gate: failed — no measurement", code 1.
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
map="$here/../translate/map.tsv"

none() {
    echo "survey gate: failed — no measurement"
    exit 1
}

# The counts of the series $1: "<runs> <violations> <decisions> <flaws>" — into
# $counts. No key, no key line or no verdict of a run — return 1.
tally() {
    local label file line a b c r=0 v=0 d=0 f=0
    [ -f "$key" ] || return 1
    while IFS= read -r label; do
        file="$B/blind/$label/verdict.tsv"
        [ -s "$file" ] || return 1
        r=$((r + 1))
        # The first file is the table: the English names of the judge words.
        line=$(awk -F'\t' '
            FILENAME == ARGV[1] {
                if ($1 == "stand" && $2 == "judge") english[$3] = $4
                next
            }
            {
                k = ($1 in english) ? english[$1] : $1
                a = ($3 in english) ? english[$3] : $3
                if (k == "rule" && a == "no") v++
                if (k == "decision" && a == "carried") d++
                if (k == "flaw" && a == "named") f++
            }
            END { print v + 0, d + 0, f + 0 }' "$map" "$file")
        read -r a b c <<< "$line"
        v=$((v + a))
        d=$((d + b))
        f=$((f + c))
    done < <(awk -F'\t' -v series="$1" '$2 == series { print $1 }' "$key")
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
