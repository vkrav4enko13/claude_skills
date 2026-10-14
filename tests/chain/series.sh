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
# skills/ and without that file was run at xhigh. A series asked at another
# level than its own — "series <name> was run at <level>" and code 2.
# The four skills and tests/chain/rules.md, if it exists, are copied into it
# once — into skills/ and rules.md, while there is no skills/ folder: the
# stands take the skills from the copy. The runs — the folders 1, 2, 3 — go at
# the same time, the lanes of a run — one after another: count — the stages
# brain plan work on the project wiki-trial/clean, then longest — the stage
# seed on the project seedbox/wiki-trial/clean after seed.sh, then survey —
# the stage survey on the project surveybox/wiki-trial/clean, then grill — the
# stage grill on the project grillbox/wiki-trial/clean with grill-longest.sh as
# longest.sh and grill-plan.md as plan-shortest.md in its root. A lane whose
# named stages are all passed (done in stage.json) is not touched; otherwise
# its project and the folders of its stages are erased and it goes anew. On a
# lane that is not passed the run ends. Then measure.sh. Per run — a line
# "run <N>: done" or "run <N>: lane <name> not passed". All are done — the
# file done in the series folder and code 0, otherwise code 1.
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
        brain | plan | work | seed | survey | grill) ;;
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

# The stage is passed: $1 — the stage folder.
stage_done() {
    jq -e '.done == true' "$1/stage.json" > /dev/null 2>&1
}

# The lane $2 of the run in the folder $1. Code 1 — the lane is not passed.
lane() {
    local R="$1" all box project s mine="" todo=0
    case "$2" in
        count) all='brain plan work'; box="$R" ;;
        longest) all=seed; box="$R/seedbox" ;;
        survey) all=survey; box="$R/surveybox" ;;
        grill) all=grill; box="$R/grillbox" ;;
    esac
    project="$box/wiki-trial/clean"
    # The named stages of the lane — in its order.
    for s in $all; do
        case " $stages " in *" $s "*) mine="$mine $s" ;; esac
    done
    for s in $mine; do
        if ! stage_done "$R/$s"; then todo=1; fi
    done
    [ $todo -eq 1 ] || return 0

    # The project is erased and built anew by stand.sh itself.
    for s in $all; do rm -rf "$R/$s"; done
    "$BASH" "$here/stand.sh" "$box" "$S/skills" || return 1
    if [ "$2" = longest ]; then
        "$BASH" "$here/seed.sh" "$project" || return 1
    fi
    if [ "$2" = grill ]; then
        cp "$here/grill-longest.sh" "$project/longest.sh"
        cp "$here/grill-plan.md" "$project/plan-shortest.md"
    fi
    for s in $mine; do
        "$BASH" "$here/drive.sh" "$project" "$s" "$R/$s" "$effort" || return 1
        stage_done "$R/$s" || return 1
    done
}

# The run $1: the lanes one after another, then the measurement.
run() {
    local R="$S/$1" name failed=""
    mkdir -p "$R"
    for name in count longest survey grill; do
        if ! lane "$R" "$name"; then
            failed=$name
            break
        fi
    done
    "$BASH" "$here/measure.sh" "$R"
    if [ -n "$failed" ]; then
        echo "run $1: lane $failed not passed"
        return 1
    fi
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
