#!/bin/bash
# The summary of one series of the chain stand against the zero thresholds.
#
#   bash tests/chain/zero.sh <series>
#
# The series is the folder $CHAIN_BASE/<series>, by default
# ~/Documents/my/chain-stand/<series>; there is none — "zero: fail — no
# measurement" and code 1. Otherwise judge.sh <series> goes first, its output
# to stderr. Then every run folder needs its key lines in blind/key.tsv —
# "<run>" when it has a stage folder brain, plan, work, seed or away,
# "<run>-survey" when it has survey or grill, at least one of them — every
# label a verdict and tally_label of tally.sh a line; otherwise "zero: fail —
# no measurement" and code 1. Otherwise ten lines:
#   stages: <done>/<all>          — stage folders with done in stage.json; all
#                                   the named stages per run, pair as 2: the
#                                   file stages of the series (series.sh); a
#                                   series without it — the stages whose
#                                   folders are in the run
#   seeds: <found>/<5 × runs>     — from the main labels
#   violations: <n> (sbrain <n>, splan <n>, swork <n>, saway <n>, sv <n>)
#   decisions: <n>/<5 × runs>     — from the -survey labels
#   flaws: <n>/<5 × runs>         — from the -survey labels
#   away: <passed>/<runs>         — away-check.txt ends with "away run: pass"
#   nonstop: <passed>/<runs>      — nonstop-check.txt, "nonstop run: pass"
#   pair: <passed>/<runs>         — pair-check.txt, "pair run: pass"
#   judged: saway <n> rules       — the saway- rule lines answered yes or no
#   zero: pass | zero: fail — <reasons>
# pass — every stage done, every seed found, 0 violations, decisions and flaws
# at 5 × runs, every check file passed: code 0; otherwise code 1. Every number
# of a verdict comes from tally_label.
# Takes from seconds to an hour: the judge sessions of judge.sh.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash zero.sh <series>" >&2
    exit 2
fi
here="$(cd "$(dirname "$0")" && pwd)"
B="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
S="$B/$1"
key="$B/blind/key.tsv"
. "$here/tally.sh"

none() {
    echo 'zero: fail — no measurement'
    exit 1
}
[ -d "$S" ] || none

"$BASH" "$here/judge.sh" "$1" >&2 || true
[ -f "$key" ] || none

# The label of the key run $1 of the series; none — empty.
label_of() {
    awk -F'\t' -v series="$series" -v run="$1" '$2 == series && $3 == run { print $1 }' "$key"
}

# The stage is passed: $1 — the stage folder.
stage_done() {
    jq -e '.done == true' "$1/stage.json" > /dev/null 2>&1
}

# The stage folders of the stage $1: pair has two.
folders() {
    if [ "$1" = pair ]; then echo 'pair1 pair2'; else echo "$1"; fi
}

# The check file $1 ends with the line $2.
passed() {
    [ -f "$1" ] && [ "$(awk 'NF { last = $0 } END { print last }' "$1")" = "$2" ]
}

series="$1"
named=""
if [ -f "$S/stages" ]; then named="$(cat "$S/stages")"; fi
runs=0 finished=0 all=0 seeds=0 rule=0 decisions=0 flaws=0
sbrain=0 splan=0 swork=0 saway=0 sv=0 judged=0 away=0 nonstop=0 pair=0
for R in "$S"/[0-9]*; do
    [ -d "$R" ] || continue
    run="${R##*/}"
    runs=$((runs + 1))
    kinds=""
    for s in brain plan work seed away; do
        if [ -d "$R/$s" ]; then kinds=main; break; fi
    done
    if [ -d "$R/survey" ] || [ -d "$R/grill" ]; then kinds="$kinds survey"; fi
    [ -n "$kinds" ] || none
    for kind in $kinds; do
        k="$run"
        if [ "$kind" = survey ]; then k="$run-survey"; fi
        label="$(label_of "$k")"
        [ -n "$label" ] || none
        line="$(tally_label "$B/blind/$label")" || none
        set -- $line
        rule=$((rule + $1))
        sbrain=$((sbrain + $5)); splan=$((splan + $6)); swork=$((swork + $7))
        saway=$((saway + $8)); sv=$((sv + $9)); judged=$((judged + ${10}))
        if [ "$kind" = main ]; then
            seeds=$((seeds + $4))
        else
            decisions=$((decisions + $2)); flaws=$((flaws + $3))
        fi
    done
    mine="$named"
    if [ -z "$mine" ]; then
        for s in brain plan work seed survey grill away nonstop pair; do
            for f in $(folders "$s"); do
                if [ -d "$R/$f" ]; then mine="$mine $s"; break; fi
            done
        done
    fi
    for s in $mine; do
        for f in $(folders "$s"); do
            all=$((all + 1))
            if stage_done "$R/$f"; then finished=$((finished + 1)); fi
        done
    done
    if passed "$R/away-check.txt" 'away run: pass'; then away=$((away + 1)); fi
    if passed "$R/nonstop-check.txt" 'nonstop run: pass'; then nonstop=$((nonstop + 1)); fi
    if passed "$R/pair-check.txt" 'pair run: pass'; then pair=$((pair + 1)); fi
done
[ $runs -gt 0 ] || none

want=$((5 * runs))
echo "stages: $finished/$all"
echo "seeds: $seeds/$want"
echo "violations: $rule (sbrain $sbrain, splan $splan, swork $swork, saway $saway, sv $sv)"
echo "decisions: $decisions/$want"
echo "flaws: $flaws/$want"
echo "away: $away/$runs"
echo "nonstop: $nonstop/$runs"
echo "pair: $pair/$runs"
echo "judged: saway $judged rules"

reasons=""
reason() { reasons="${reasons:+$reasons, }$1"; }
[ $finished -eq $all ] || reason "stages $finished/$all"
[ $seeds -eq $want ] || reason "seeds $seeds/$want"
[ $rule -eq 0 ] || reason "violations $rule"
[ $decisions -eq $want ] || reason "decisions $decisions/$want"
[ $flaws -eq $want ] || reason "flaws $flaws/$want"
[ $away -eq $runs ] || reason "away $away/$runs"
[ $nonstop -eq $runs ] || reason "nonstop $nonstop/$runs"
[ $pair -eq $runs ] || reason "pair $pair/$runs"
if [ -z "$reasons" ]; then
    echo 'zero: pass'
    exit 0
fi
echo "zero: fail — $reasons"
exit 1
