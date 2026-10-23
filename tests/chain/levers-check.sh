#!/bin/bash
# Counts the subagents of each stage of a chain stand series by role.
#
#   bash tests/chain/levers-check.sh <series>
#
# A series is the folder $CHAIN_BASE/<series>, by default
# ~/Documents/my/chain-stand/<series>; its runs are the folders [0-9]*, a stage
# folder of a run is every folder with stage.json, raw/ or turns/ (small and
# trap-* included). The role of a subagent is that of trace.sh, from the
# description of its raw/subagents/agent-*.meta.json: executor — executor;
# conformance and review — pass; review-2 — round2; plan-review and
# plan-review-2 — reviewer; stage — stage-agent; the other roles are not
# counted. Prints a line per run and stage:
#   <run>/<stage>: executor=<n> pass=<n> round2=<n> reviewer=<n> stage-agent=<n>
# Code 0; no series or no stage folder — a message and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash levers-check.sh <series>" >&2
    exit 2
fi
S="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}/$1"
if [ ! -d "$S" ]; then
    echo "no series $1" >&2
    exit 1
fi

# The counts line of the stage folder $1.
counts() {
    local metas=(/dev/null) f
    for f in "$1"/raw/subagents/agent-*.meta.json; do
        if [ -f "$f" ]; then metas+=("$f"); fi
    done
    jq -rn '
        def role_of:
            ascii_downcase as $d
            | ($d | test("second|round 2")) as $two
            | if $d | startswith("stage ") then "stage"
            elif ($d | contains("plan review")) and $two then "plan-review-2"
            elif $d | contains("plan review") then "plan-review"
            elif $d | startswith("execute slice") then "executor"
            elif $d | startswith("fix ") then "fixer"
            elif $d | contains("conformance") then "conformance"
            elif $two then "review-2"
            elif $d | contains("review") then "review"
            else "other" end;
        [inputs | .description // "" | role_of] as $r
        | def n(roles): [$r[] | select(. as $x | roles | index($x))] | length;
        "executor=\(n(["executor"])) pass=\(n(["conformance", "review"])) round2=\(n(["review-2"]))"
        + " reviewer=\(n(["plan-review", "plan-review-2"])) stage-agent=\(n(["stage"]))"
    ' "${metas[@]}"
}

found=0
for R in "$S"/[0-9]*; do
    for d in "$R"/*/; do
        d="${d%/}"
        if [ -f "$d/stage.json" ] || [ -d "$d/raw" ] || [ -d "$d/turns" ]; then
            found=1
            echo "${R##*/}/${d##*/}: $(counts "$d")"
        fi
    done
done
if [ $found -eq 0 ]; then
    echo "no stage folders in $1" >&2
    exit 1
fi
