#!/bin/bash
# Two live swork sessions at once in one project of the pair case and their check.
#
#   bash tests/chain/pair-run.sh a|b|c|d|e|f|g|h <skills folder>
#
# Builds a stand in a new mktemp -d folder under $CHAIN_BASE (default
# ~/Documents/my/chain-stand) with the skills of <skills folder>, seeds the case with
# seed-pair.sh and drives the stage pair twice at once at effort medium into the stage
# folders s1 and s2: case a — the topics usage and version, case b — the topic pair in both,
# cases c, d, f and g — the topics left and right, case e — the topics shop and hud.
# Case h starts session 1 on left alone, waits — every 5 s, at most 600 s — for the phase
# "execution in progress" in its state.md, writes into before.txt of the stand folder
# "before switch: none" when the project has no .agents/, else "before switch: present",
# then starts session 2 on right with the stage pair-multi.
# Then passes on the output and the code of pair-check.sh: the last line "pair run: pass"
# with code 0 or "pair run: fail" with code 1. The stand folder goes to stderr.
# Takes from ten minutes to an hour.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "usage: bash pair-run.sh a|b|c|d|e|f|g|h <skills folder>" >&2
    exit 2
}
[ $# -eq 2 ] || usage
case "$1" in
    a) topic1=usage; topic2=version ;;
    b) topic1=pair; topic2=pair ;;
    c | d | f | g | h) topic1=left; topic2=right ;;
    e) topic1=shop; topic2=hud ;;
    *) usage ;;
esac
here="$(cd "$(dirname "$0")" && pwd)"
skills="$(cd "$2" && pwd)"

B="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"; mkdir -p "$B"; T=$(mktemp -d "$B/pair.XXXXXX")
echo "stand: $T" >&2
P="$T/wiki-trial/clean"
"$BASH" "$here/stand.sh" "$T" "$skills" >&2
"$BASH" "$here/seed-pair.sh" "$P" "$1" >&2
"$BASH" "$here/drive.sh" "$P" pair "$T/s1" medium "$topic1" >&2 &
first=$!
stage2=pair
if [ "$1" = h ]; then
    stage2=pair-multi
    waited=0
    while [ $waited -lt 600 ] && ! grep -qs 'execution in progress' "$P/docs/work/$topic1/state.md"; do
        sleep 5
        waited=$((waited + 5))
    done
    if [ -e "$P/.agents" ]; then
        echo 'before switch: present' > "$T/before.txt"
    else
        echo 'before switch: none' > "$T/before.txt"
    fi
fi
"$BASH" "$here/drive.sh" "$P" "$stage2" "$T/s2" medium "$topic2" >&2 &
second=$!
# A failed drive still leaves the check to tell what the sessions reached.
wait "$first" || echo "drive.sh 1 failed" >&2
wait "$second" || echo "drive.sh 2 failed" >&2
exec "$BASH" "$here/pair-check.sh" "$P" "$T/s1" "$T/s2" "$1"
