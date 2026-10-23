#!/bin/bash
# Checks compare.sh on fake series.
#
#   bash tests/chain/compare-test.sh
#
# Builds a throwaway CHAIN_BASE ct.XXXXXX under CHAIN_BASE (default
# ~/Documents/my/chain-stand); per case a baseline and a candidate series of
# one run anew: a stage brain with a judged label in blind/key.tsv, a stage
# folder trap-reuse-plan and trap-reuse.json. Cases: pass, violations, hidden,
# lines, time, overeng, caught, new-rules, medians, report, map, only,
# zero-ratio, count, trap-name. Prints "case <name>: ok" or "case <name>: got <output>", then
# "compare test: all ok" and code 0, or "compare test: failed" and code 1.
# The throwaway folder is removed.
export LC_ALL=C.UTF-8
set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
CB="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
mkdir -p "$CB"
T=$(mktemp -d "$CB/ct.XXXXXX")
trap 'rm -rf "$T"' EXIT
TAB=$(printf '\t')
failed=0

# Both series anew: no series, an empty key.
fresh() {
    rm -rf "${T:?}"/*
    mkdir -p "$T/blind"
    : > "$T/blind/key.tsv"
}

# A stage folder $1 with wall_s $2, output tokens $3 and cost $4.
stage() {
    mkdir -p "$1/raw" "$1/turns"
    printf '{"done":true,"wall_s":%s}\n' "$2" > "$1/stage.json"
    printf '{"type":"assistant","requestId":"r1","message":{"usage":{"output_tokens":%s}}}\n' "$3" > "$1/raw/s.jsonl"
    printf '{"total_cost_usd":%s}\n' "$4" > "$1/turns/01.json"
}

# The trap measurement of the task $2 in the run folder $1: lines $3, hidden $4, overeng $5,
# caught $6, wall_s $7, tokens_out $8.
trapj() {
    printf '{"lines":%s,"hidden":"%s","risky_test":false,"tokens_out":%s,"wall_s":%s,"cost_usd":0.5,"gz_bytes":%s,"overeng":%s,"construct":null,"caught":%s,"mutants":3}\n' \
        "$3" "$4" "$8" "$7" "$3" "$5" "$6" > "$1/trap-$2.json"
}

# The series $1 of one run; the arguments after it — name=value over the defaults; count —
# the fixture copied into wiki-trial/clean, none — no copy.
make() {
    local s="$1" rules="sbrain-1 sbrain-2" noes="" wall=100 tok=1000 cost=1.5 lines=10 hidden=pass
    local over=1 caught=2 twall=50 ttok=500 brain=1 count=none kv id R
    shift
    for kv in "$@"; do local "$kv"; done
    R="$T/$s/1"
    mkdir -p "$R"
    if [ "$brain" = 1 ]; then
        stage "$R/brain" "$wall" "$tok" "$cost"
        mkdir "$T/blind/$s-1"
        printf '%s\t%s\t1\n' "$s-1" "$s" >> "$T/blind/key.tsv"
        for id in $rules; do printf -- '- %s. A rule — x.md:1\n' "$id"; done > "$T/blind/$s-1/rules.md"
        for id in $rules; do
            case " $noes " in
                *" $id "*) printf 'rule\t%s\tno\there\n' "$id" ;;
                *) printf 'rule\t%s\tyes\there\n' "$id" ;;
            esac
        done > "$T/blind/$s-1/verdict.tsv"
    fi
    if [ "$count" != none ]; then
        mkdir -p "$R/wiki-trial/clean"
        cp "$here/fixtures/count-$count/count.sh" "$R/wiki-trial/clean/count.sh"
    fi
    stage "$R/trap-reuse-plan" "$twall" "$ttok" 0.5
    trapj "$R" reuse "$lines" "$hidden" "$over" "$caught" "$twall" "$ttok"
}

out="" code=0
# compare.sh with the arguments.
run() {
    out=$(CHAIN_BASE="$T" bash "$here/compare.sh" "$@" 2>&1)
    code=$?
}

# The case $1 holds when the command after it succeeds; otherwise the output.
check() {
    local name="$1"
    shift
    if "$@"; then
        echo "case $name: ok"
    else
        echo "case $name: got $(printf '%s\n' "$out" | tr '\n' '|') (code $code)"
        failed=1
    fi
}

# The output has the line $1.
has() {
    printf '%s\n' "$out" | grep -qxF -- "$1"
}

# The output ends with "accept: pass" and code 0.
passes() {
    [ $code -eq 0 ] && [ "$(printf '%s\n' "$out" | tail -1)" = 'accept: pass' ]
}

# The output ends with the fail line $1 and code 1.
fails() {
    [ $code -eq 1 ] && [ "$(printf '%s\n' "$out" | tail -1)" = "accept: fail — $1" ]
}

# A candidate with the arguments against the default baseline.
against() {
    fresh
    make base
    make cand "$@"
    run base cand
}

against lines=5
check pass passes

against lines=5 noes=sbrain-1
check violations fails violations

against lines=5 hidden=fail
check hidden fails hidden

against
check lines fails lines

against lines=5 wall=200
check time fails 'wall (time only)'

against lines=5 over=2
check overeng fails overeng

against lines=5 caught=1
check caught fails caught

new_rules() {
    passes && has 'new rules: cand 2' && has 'violations: base 0 cand 0 (shared rules)'
}
against lines=5 rules="sbrain-1 sbrain-2 sbrain-3 sbrain-4" noes="sbrain-3 sbrain-4"
check new-rules new_rules

# Two tasks over three runs: reuse lines 10 20 30 against 5 10 15, native 40 40 50 against
# 10 10 10 — medians 20 and 40 against 10 and 10, ratios 0.5 and 0.25, the mean 0.35.
fresh
for s in base cand; do
    make "$s"
    rm -f "$T/$s/1/trap-reuse.json"
done
for r in 1 2 3; do
    mkdir -p "$T/base/$r" "$T/cand/$r"
    set -- 10 20 30
    trapj "$T/base/$r" reuse "${!r}" pass 1 2 50 500
    set -- 40 40 50
    trapj "$T/base/$r" native "${!r}" pass 1 2 50 500
    set -- 5 10 15
    trapj "$T/cand/$r" reuse "${!r}" pass 1 2 50 500
    trapj "$T/cand/$r" native 10 pass 1 2 50 500
done
run --only traps base cand
check medians has 'lines: median base 60 cand 20 ratio 0.35'

report() {
    has 'tokens: base 1500 cand 1500' && has 'cost: base 2.00 cand 2.00' && has 'speed: x1.00'
}
against lines=5
check report report

map() {
    run --map base cand
    [ $code -eq 0 ] && [ "$(printf '%s\n' "$out" | tail -1)" = 'map: keep' ] || return 1
    against ttok=600
    run --map base cand
    [ $code -eq 1 ] && [ "$(printf '%s\n' "$out" | tail -1)" = 'map: drop' ]
}
against ttok=400
check map map

only() {
    passes && has 'violations: skipped' && has 'stages: skipped' && has 'trap runs: base 1/15, cand 1/15'
}
fresh
make base
make cand brain=0 lines=5
run --only traps base cand
check only only

zero_ratio() {
    passes && has 'caught: median base 0 cand 1 ratio n/a'
}
fresh
make base caught=0
make cand caught=1 lines=5
run base cand
check zero-ratio zero_ratio

count_lane() {
    fails count && has 'count: base 1/1 cand 0/1'
}
fresh
make base count=good
make cand lines=5 count=words
run base cand
check count count_lane

trap_name() {
    passes && has 'trap runs: base 1/15, cand 1/15' && has 'lines: median base 10 cand 5 ratio 0.50' \
        && has 'count: skipped'
}
fresh
make base
make cand brain=0 lines=5
run --only trap-reuse base cand
check trap-name trap_name

if [ $failed -eq 0 ]; then
    echo "compare test: all ok"
    exit 0
fi
echo "compare test: failed"
exit 1
