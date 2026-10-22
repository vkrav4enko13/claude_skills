#!/bin/bash
# Runs a series of chain runs on the stand without a person and takes their
# measurement.
#
#   bash tests/chain/series.sh <series> <skills folder> [--runs N] [--stages "<stages>"] [--effort <level>]
#
# By default three runs, the stages brain plan work seed and the effort level
# medium; the levels are low medium high xhigh max. A series is the
# folder $CHAIN_BASE/<series>, by default ~/Documents/my/chain-stand/<series>.
# The level of a series is the line of its file effort; a series folder with
# skills/ and without that file was run at xhigh. Its file stages holds every
# stage it was ever run with, for zero.sh. A series asked at another
# level than its own — "series <name> was run at <level>" and code 2.
# The four skills and tests/chain/rules.md, if it exists, are copied into it
# once — into skills/ and rules.md, while there is no skills/ folder: the
# stands take the skills from the copy. The runs — the folders 1, 2, 3 — go at
# the same time, the lanes of a run — one after another: count — the stages
# brain plan work on the project wiki-trial/clean, then longest — the stage
# seed on the project seedbox/wiki-trial/clean after seed.sh, then survey —
# the stage survey on the project surveybox/wiki-trial/clean, then grill — the
# stage grill on the project grillbox/wiki-trial/clean with grill-longest.sh as
# longest.sh and grill-plan.md as plan-shortest.md in its root, then away —
# the stage away on awaybox/wiki-trial/clean after seed-away.sh, its check
# away-check.sh into away-check.txt; then nonstop — drive.sh with the stage
# seed into the folder nonstop on nonstopbox/wiki-trial/clean after
# seed-away.sh, its check nonstop-check.sh into nonstop-check.txt; then pair —
# seed-pair.sh on pairbox/wiki-trial/clean with case a in run 1 and b in the
# others, two drive.sh with the stage pair at the same time into the folders
# pair1 and pair2 (case a: the topics usage and version, case b: pair and
# pair), its check pair-check.sh into pair-check.txt. The stages away,
# nonstop and pair are named only on request. A check that fails does not fail
# its lane: the check file holds the verdict. A lane whose named stages are
# all passed (done in stage.json; pair — in both pair1 and pair2) is not
# touched; otherwise its project and the folders of its stages are erased and
# it goes anew. A lane that is not passed does not end the run: the next lanes
# go all the same. Then measure.sh. Per run — a line "run <N>: done" or a line
# "run <N>: lane <name> not passed" for every lane not passed. All are done —
# the file done in the series folder and code 0, otherwise code 1.
# Takes from ten minutes to an hour and longer.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo 'usage: bash series.sh <series> <skills folder> [--runs N] [--stages "<stages>"] [--effort <level>]' >&2
    exit 2
}
[ $# -ge 2 ] || usage
series="$1"
src="$(cd "$2" && pwd)"
shift 2
runs=3
stages='brain plan work seed'
effort=medium
while [ $# -gt 0 ]; do
    [ $# -ge 2 ] || usage
    case "$1" in
        --runs) runs="$2" ;;
        --stages) stages="$2" ;;
        --effort) effort="$2" ;;
        *) usage ;;
    esac
    shift 2
done
[[ $runs =~ ^[1-9][0-9]*$ ]] || usage
case "$effort" in
    low | medium | high | xhigh | max) ;;
    *) usage ;;
esac
for s in $stages; do
    case "$s" in
        brain | plan | work | seed | survey | grill | away | nonstop | pair) ;;
        *) echo "unknown stage: $s" >&2; exit 2 ;;
    esac
done

here="$(cd "$(dirname "$0")" && pwd)"
S="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}/$series"

# The level the series was run at: a series made before the file effort — xhigh.
if [ -d "$S/skills" ]; then
    was=xhigh
    if [ -f "$S/effort" ]; then was="$(cat "$S/effort")"; fi
    if [ "$was" != "$effort" ]; then
        echo "series $series was run at $was" >&2
        exit 2
    fi
fi

rm -f "$S/done"
if [ ! -d "$S/skills" ]; then
    mkdir -p "$S/skills"
    for skill in sbrain splan swork saway; do
        cp -R "$src/$skill" "$S/skills/$skill"
    done
    if [ -f "$here/rules.md" ]; then cp "$here/rules.md" "$S/rules.md"; fi
fi
echo "$effort" > "$S/effort"
# The stages the series was run with, for zero.sh: the earlier ones and these.
had=""
if [ -f "$S/stages" ]; then had="$(cat "$S/stages")"; fi
for s in brain plan work seed survey grill away nonstop pair; do
    case " $had $stages " in *" $s "*) echo "$s" ;; esac
done | tr '\n' ' ' | sed 's/ $//' > "$S/stages"
echo >> "$S/stages"

# The stage is passed: $1 — the stage folder.
stage_done() {
    jq -e '.done == true' "$1/stage.json" > /dev/null 2>&1
}

# The stage folders of the stage $1: pair has two.
folders() {
    if [ "$1" = pair ]; then echo 'pair1 pair2'; else echo "$1"; fi
}

# The lane $2 of the run in the folder $1. Code 1 — the lane is not passed.
lane() {
    local R="$1" all box project s f mine="" todo=0 pcase first second
    case "$2" in
        count) all='brain plan work'; box="$R" ;;
        longest) all=seed; box="$R/seedbox" ;;
        survey) all=survey; box="$R/surveybox" ;;
        grill) all=grill; box="$R/grillbox" ;;
        away) all=away; box="$R/awaybox" ;;
        nonstop) all=nonstop; box="$R/nonstopbox" ;;
        pair) all=pair; box="$R/pairbox" ;;
    esac
    project="$box/wiki-trial/clean"
    # The named stages of the lane — in its order.
    for s in $all; do
        case " $stages " in *" $s "*) mine="$mine $s" ;; esac
    done
    for s in $mine; do
        for f in $(folders "$s"); do
            if ! stage_done "$R/$f"; then todo=1; fi
        done
    done
    [ $todo -eq 1 ] || return 0

    # The project is erased and built anew by stand.sh itself.
    for s in $all; do
        for f in $(folders "$s"); do rm -rf "$R/$f"; done
    done
    "$BASH" "$here/stand.sh" "$box" "$S/skills" || return 1
    case "$2" in
        longest) "$BASH" "$here/seed.sh" "$project" || return 1 ;;
        grill)
            cp "$here/grill-longest.sh" "$project/longest.sh"
            cp "$here/grill-plan.md" "$project/plan-shortest.md"
            ;;
        away | nonstop) "$BASH" "$here/seed-away.sh" "$project" || return 1 ;;
        pair)
            pcase=b
            if [ "${R##*/}" = 1 ]; then pcase=a; fi
            "$BASH" "$here/seed-pair.sh" "$project" "$pcase" || return 1
            ;;
    esac
    # A failed drive of the new lanes still leaves the check to tell what the
    # stage reached.
    case "$2" in
        away)
            "$BASH" "$here/drive.sh" "$project" away "$R/away" "$effort" || true
            "$BASH" "$here/away-check.sh" "$project" "$R/away" > "$R/away-check.txt" 2>&1 || true
            stage_done "$R/away" || return 1
            ;;
        nonstop)
            "$BASH" "$here/drive.sh" "$project" seed "$R/nonstop" "$effort" || true
            "$BASH" "$here/nonstop-check.sh" "$project" "$R/nonstop" > "$R/nonstop-check.txt" 2>&1 || true
            stage_done "$R/nonstop" || return 1
            ;;
        pair)
            if [ "$pcase" = a ]; then first=usage; second=version; else first=pair; second=pair; fi
            "$BASH" "$here/drive.sh" "$project" pair "$R/pair1" "$effort" "$first" &
            local one=$!
            "$BASH" "$here/drive.sh" "$project" pair "$R/pair2" "$effort" "$second" &
            local two=$!
            wait "$one" || true
            wait "$two" || true
            "$BASH" "$here/pair-check.sh" "$project" "$R/pair1" "$R/pair2" "$pcase" > "$R/pair-check.txt" 2>&1 || true
            stage_done "$R/pair1" && stage_done "$R/pair2" || return 1
            ;;
        *)
            for s in $mine; do
                "$BASH" "$here/drive.sh" "$project" "$s" "$R/$s" "$effort" || return 1
                stage_done "$R/$s" || return 1
            done
            ;;
    esac
}

# The run $1: every lane one after another, then the measurement.
run() {
    local R="$S/$1" name failed=0
    mkdir -p "$R"
    for name in count longest survey grill away nonstop pair; do
        if ! lane "$R" "$name"; then
            echo "run $1: lane $name not passed"
            failed=1
        fi
    done
    "$BASH" "$here/measure.sh" "$R"
    [ $failed -eq 0 ] || return 1
    echo "run $1: done"
}

pids=()
for ((n = 1; n <= runs; n++)); do
    run "$n" &
    pids+=($!)
done
ready=1
for pid in "${pids[@]}"; do
    if ! wait "$pid"; then ready=0; fi
done
[ $ready -eq 1 ] || exit 1
: > "$S/done"
