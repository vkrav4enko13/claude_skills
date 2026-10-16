#!/bin/bash
# Checks that a malformed judge verdict is "no measurement", not a count.
#
#   bash tests/chain/verdict-test.sh
#
# Builds a throwaway CHAIN_BASE vt.XXXXXX under CHAIN_BASE (default
# ~/Documents/my/chain-stand) with two series of one run each: blind/key.tsv
# and per label a rules file and verdict.tsv. Four cases, a line each:
#   verdict malformed — verdict.sh on a verdict with a line of three fields;
#   verdict short     — verdict.sh on one rule line for two rules;
#   survey malformed  — survey-gate.sh on a survey label (rules-survey.md)
#                       with a line of three fields;
#   verdict good      — verdict.sh on well-formed verdicts gives a number.
# A case as expected — "<case>: no measurement" or "verdict good: counted";
# otherwise "<case>: got <output>". Then "verdict test: all ok", code 0, or
# "verdict test: failed", code 1. The throwaway folder is removed.
export LC_ALL=C.UTF-8
set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
base="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
mkdir -p "$base"
T=$(mktemp -d "$base/vt.XXXXXX")
trap 'rm -rf "$T"' EXIT
mkdir -p "$T/blind"
printf 'la\tbefore\t1\nlb\tafter\t1\n' > "$T/blind/key.tsv"
TAB=$(printf '\t')
failed=0

# The label folder $1 anew: the rules file $2 with the rule ids $3 (space
# separated), the verdict from standard input.
label() {
    local id
    rm -rf "$T/blind/$1"
    mkdir "$T/blind/$1"
    for id in $3; do printf -- '- %s. A rule — x.md:1\n' "$id"; done > "$T/blind/$1/$2"
    cat > "$T/blind/$1/verdict.tsv"
}

# The case $1: the output of the command after it ends with $2 and the code
# is 1 — "<case>: no measurement".
unmeasured() {
    local name="$1" want="$2" out code
    shift 2
    out=$(CHAIN_BASE="$T" "$@" 2>&1)
    code=$?
    if [ $code -eq 1 ] && [ "$(printf '%s\n' "$out" | tail -1)" = "$want" ]; then
        echo "$name: no measurement"
    else
        echo "$name: got $out (code $code)"
        failed=1
    fi
}

good="rule${TAB}sbrain-1${TAB}yes${TAB}here
rule${TAB}sbrain-2${TAB}no${TAB}here"

label la rules.md "sbrain-1 sbrain-2" <<< "$good"
label lb rules.md "sbrain-1 sbrain-2" <<< "rule${TAB}sbrain-1${TAB}yes
rule${TAB}sbrain-2${TAB}no${TAB}here"
unmeasured "verdict malformed" "no measurement: verdict lb" bash "$here/verdict.sh" quality before after

label lb rules.md "sbrain-1 sbrain-2" <<< "rule${TAB}sbrain-1${TAB}yes${TAB}here"
unmeasured "verdict short" "no measurement: verdict lb" bash "$here/verdict.sh" quality before after

label la rules-survey.md "sv-1 sv-2" <<< "rule${TAB}sv-1${TAB}yes${TAB}here
rule${TAB}sv-2${TAB}no${TAB}here"
label lb rules-survey.md "sv-1 sv-2" <<< "rule${TAB}sv-1${TAB}yes
rule${TAB}sv-2${TAB}no${TAB}here"
unmeasured "survey malformed" "survey gate: failed — no measurement" bash "$here/survey-gate.sh" before after

label la rules.md "sbrain-1 sbrain-2" <<< "$good"
label lb rules.md "sbrain-1 sbrain-2" <<< "$good"
out=$(CHAIN_BASE="$T" bash "$here/verdict.sh" quality before after 2>&1)
if printf '%s\n' "$out" | grep -qE '^violations: before [0-9]+, after [0-9]+ '; then
    echo "verdict good: counted"
else
    echo "verdict good: got $out"
    failed=1
fi

if [ $failed -eq 0 ]; then
    echo "verdict test: all ok"
    exit 0
fi
echo "verdict test: failed"
exit 1
