#!/bin/bash
# Says whether a series of chain runs passed the quality gate, and why not.
#
#   bash tests/chain/gate.sh <reference series> <series> [--group <group>]
#
# Prints "stages: <done>/<all>", "seeds: <found>/<5 × runs>", the line of
# verdict.sh quality and a last line. <all> is 4 × the number of run folders
# of the series, <done> — the number of their stages brain plan work seed with
# done in stage.json; <found> — the seeds the judge found in the series.
# "gate: passed" and code 0 — every stage is done, every seed is found and
# verdict.sh quality ends with code 0. Otherwise "gate: failed — <reasons>"
# and code 1, the reasons joined by ", " from "stages <done>/<all>",
# "seeds <found>/<5 × runs>", "violations more", "no measurement". A "no
# measurement" answer of either verdict.sh call gives the reason "no
# measurement" and the line "seeds: 0/<5 × runs>".
# With --group: no row of that group in tests/chain/levers.tsv (tab-separated,
# a header row, the group in column 2, the verdict in column 6) has the
# verdict "taken" — "gate: skipped — no lever taken in <group>" and code 0,
# the series is not looked at. No levers.tsv — "gate: failed — no levers.tsv"
# and code 1.
# The stands folder — CHAIN_BASE, by default ~/Documents/my/chain-stand.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "usage: bash gate.sh <reference series> <series> [--group <group>]" >&2
    exit 2
}
[ $# -eq 2 ] || { [ $# -eq 4 ] && [ "$3" = "--group" ]; } || usage
reference="$1"
series="$2"
here="$(cd "$(dirname "$0")" && pwd)"
S="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"

if [ $# -eq 4 ]; then
    group="$4"
    levers="$here/levers.tsv"
    if [ ! -f "$levers" ]; then
        echo "gate: failed — no levers.tsv"
        exit 1
    fi
    taken=$(awk -F'\t' -v group="$group" 'NR > 1 && $2 == group && $6 == "taken" { n++ } END { print n + 0 }' "$levers")
    if [ "$taken" -eq 0 ]; then
        echo "gate: skipped — no lever taken in $group"
        exit 0
    fi
fi

runs=0
completed=0
for dir in "$S/$series"/[0-9]*; do
    [ -d "$dir" ] || continue
    runs=$((runs + 1))
    for stage in brain plan work seed; do
        if jq -e '.done == true' "$dir/$stage/stage.json" > /dev/null 2>&1; then
            completed=$((completed + 1))
        fi
    done
done
all=$((4 * runs))
seeds_all=$((5 * runs))

unmeasured=0
found=0
line=$(bash "$here/verdict.sh" seeds "$series" "$series") || true
case "$line" in
    "no measurement:"*) unmeasured=1 ;;
    *) found=$(printf '%s\n' "$line" | sed -n 's/.*after \([0-9][0-9]*\).*/\1/p') ;;
esac

code=0
quality=$(bash "$here/verdict.sh" quality "$reference" "$series") || code=$?
case "$quality" in
    "no measurement:"*) unmeasured=1 ;;
esac
[ $unmeasured -eq 0 ] || found=0

echo "stages: $completed/$all"
echo "seeds: $found/$seeds_all"
echo "$quality"

reasons=()
[ "$completed" -eq "$all" ] || reasons+=("stages $completed/$all")
if [ $unmeasured -eq 1 ]; then
    reasons+=("no measurement")
else
    [ "$found" -eq "$seeds_all" ] || reasons+=("seeds $found/$seeds_all")
    [ "$code" -eq 0 ] || reasons+=("violations more")
fi

if [ ${#reasons[@]} -eq 0 ]; then
    echo "gate: passed"
    exit 0
fi
joined=$(printf '%s, ' "${reasons[@]}")
echo "gate: failed — ${joined%, }"
exit 1
