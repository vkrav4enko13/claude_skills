#!/bin/bash
# Two live swork sessions at once in one project of the pair case and their check.
#
#   bash tests/chain/pair-run.sh a|b <skills folder>
#
# Builds a stand in a new mktemp -d folder under $CHAIN_BASE (default
# ~/Documents/my/chain-stand) with the skills of <skills folder>, seeds the case with
# seed-pair.sh and drives the stage pair twice at once at effort medium into the stage
# folders s1 and s2: case a — the topics usage and version, case b — the topic pair in both.
# Then passes on the output and the code of pair-check.sh: the last line "pair run: pass"
# with code 0 or "pair run: fail" with code 1. The stand folder goes to stderr.
# Takes from ten minutes to an hour.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "usage: bash pair-run.sh a|b <skills folder>" >&2
    exit 2
}
[ $# -eq 2 ] || usage
case "$1" in
    a) topic1=usage; topic2=version ;;
    b) topic1=pair; topic2=pair ;;
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
"$BASH" "$here/drive.sh" "$P" pair "$T/s2" medium "$topic2" >&2 &
second=$!
# A failed drive still leaves the check to tell what the sessions reached.
wait "$first" || echo "drive.sh 1 failed" >&2
wait "$second" || echo "drive.sh 2 failed" >&2
exec "$BASH" "$here/pair-check.sh" "$P" "$T/s1" "$T/s2" "$1"
